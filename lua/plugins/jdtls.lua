-- jdtls 的 classpath 是 bazel-jdtls-classpath.sh 生成的静态快照，只有跑过脚本的
-- 模块才有。缺失时 LSP 看起来是连着的，但什么都解析不了，所以启动时先报出来。
local function classpath_state(root)
  if vim.fn.filereadable(root .. "/.classpath") ~= 1 then
    return "missing"
  end
  local generated_at = vim.fn.getftime(root .. "/.classpath")
  for _, name in ipairs({ "BUILD.bazel", "BUILD" }) do
    local build_file = root .. "/" .. name
    if vim.fn.filereadable(build_file) == 1 and vim.fn.getftime(build_file) > generated_at then
      return "stale"
    end
  end
  return "ok"
end

-- 每个模块一个 jdtls 实例，每个都吃几个 G。切走之后没有 buffer 的实例留着只占内存。
-- 当前模块的实例一律保留：停掉它只会换来一次几十秒的重新索引。
local function stop_idle_jdtls(keep_root)
  for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
    local in_use = client.config.root_dir == keep_root
    for bufnr in pairs(client.attached_buffers or {}) do
      if vim.api.nvim_buf_is_loaded(bufnr) then
        in_use = true
        break
      end
    end
    if not in_use then
      vim.lsp.stop_client(client.id, true)
    end
  end
end

-- 重启不重新生成 classpath：卡住的多数是 jdtls 本身，不是 classpath 变了。
local function restart_jdtls()
  for _, client in ipairs(vim.lsp.get_clients({ name = "jdtls" })) do
    vim.lsp.stop_client(client.id, true)
  end
  vim.defer_fn(function()
    if vim.bo.filetype == "java" then
      vim.cmd("doautocmd FileType java")
    end
  end, 500)
end

return {
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = { "williamboman/mason.nvim" },
    -- init 在 nvim 启动时执行（无论有没有 java 文件），用来注册
    -- :BazelJdtlsClasspath 命令 + BUILD 文件保存的提示 autocmd。
    -- config 仍受 ft=java 约束，只有打开 Java 文件才启动 jdtls 本体。
    init = function()
      vim.api.nvim_create_user_command("BazelJdtlsClasspath", function(opts)
        -- 不带参数时交给脚本按当前文件所在模块推断 target
        local target = opts.args ~= "" and opts.args or vim.fn.expand("%:p")

        local script_hits = vim.fs.find("tools/bazel-jdtls-classpath.sh",
          { upward = true, path = vim.fn.expand("%:p:h") })
        if #script_hits == 0 then
          vim.notify("bazel-jdtls-classpath.sh not found (need to run inside services repo)",
            vim.log.levels.ERROR)
          return
        end
        local script = script_hits[1]
        local ws_root = vim.fs.dirname(vim.fs.dirname(script))

        vim.notify("Regenerating classpath for " .. target .. " ...", vim.log.levels.INFO)
        vim.system(
          { "bash", "-c",
            "export AWS_PROFILE=devtest-admin && "
            .. vim.fn.shellescape(script) .. " " .. vim.fn.shellescape(target) },
          { text = true, cwd = ws_root },
          function(res)
            vim.schedule(function()
              if res.code == 0 then
                vim.notify("Classpath refreshed. Restarting jdtls...", vim.log.levels.INFO)
                -- 不能用 :LspRestart jdtls —— 它按名字选中 nvim-lspconfig 自带的
                -- lsp/jdtls.lua，那份配置的 cmd 拿不到 config 会报错，而且绕过了下面
                -- config() 里的 Java 21 / Lombok / 模块级 root 设置。
                restart_jdtls()
              else
                vim.notify("bazel-jdtls-classpath.sh failed (exit " .. res.code .. ")\n"
                  .. (res.stderr or "") .. "\n" .. (res.stdout or ""),
                  vim.log.levels.ERROR)
              end
            end)
          end)
      end, {
        nargs = "?",
        complete = "file",
        desc = "Regenerate the module's .classpath via bazel-jdtls-classpath.sh + restart jdtls",
      })

      vim.api.nvim_create_user_command("JdtlsRestart", restart_jdtls,
        { desc = "Restart jdtls without rebuilding the classpath" })

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "BUILD.bazel", "BUILD" },
        callback = function()
          vim.notify(
            "BUILD file changed. Run :BazelJdtlsClasspath [//pkg:target] to refresh jdtls classpath.",
            vim.log.levels.INFO)
        end,
        desc = "Nudge to refresh jdtls classpath after BUILD edits",
      })
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
          local launcher = vim.fn.glob(mason_pkg .. "/plugins/org.eclipse.equinox.launcher_*.jar")
          if launcher == "" then
            vim.notify("jdtls not installed. Run :MasonInstall jdtls", vim.log.levels.WARN)
            return
          end

          local sysname
          if vim.fn.has("mac") == 1 then
            sysname = "mac"
          elseif vim.fn.has("unix") == 1 then
            sysname = "linux"
          else
            sysname = "win"
          end

          -- 在 Lacework services 巨型 monorepo 里，root 设成模块级（BUILD.bazel 所在），
          -- 避免索引 170+ 子目录导致内存爆掉。
          -- 从当前文件向上找，第一个 BUILD.bazel/BUILD/pom.xml 就停；
          -- 到 monorepo 顶层（WORKSPACE.bazel/MODULE.bazel）也停，作为兜底 root。
          local current_file = vim.api.nvim_buf_get_name(0)
          local function find_module_root(fname)
            local dir = vim.fs.dirname(fname)
            local module_markers   = { "BUILD.bazel", "BUILD", "pom.xml",
                                       "build.gradle", "build.gradle.kts" }
            local monorepo_markers = { "MODULE.bazel", "WORKSPACE.bazel", "WORKSPACE" }
            while dir and dir ~= "/" do
              for _, m in ipairs(module_markers) do
                if vim.uv.fs_stat(dir .. "/" .. m) then return dir end
              end
              for _, m in ipairs(monorepo_markers) do
                if vim.uv.fs_stat(dir .. "/" .. m) then return dir end
              end
              dir = vim.fs.dirname(dir)
            end
            return nil
          end

          local project_root = find_module_root(current_file)
                             or require("jdtls.setup").find_root({ ".git" })
                             or vim.fn.getcwd()

          -- 用完整路径的 hash 做 workspace 名，避免多个模块同名撞车
          local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")
                             .. "-" .. vim.fn.sha256(project_root):sub(1, 8)
          local workspace   = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

          vim.notify("jdtls root: " .. project_root, vim.log.levels.INFO)

          local state = classpath_state(project_root)
          if state == "missing" then
            vim.notify("该模块没有 .classpath，跳转和补全都不可用。\n"
                     .. "运行 :BazelJdtlsClasspath 生成（不带参数即按当前文件推断 target）",
                     vim.log.levels.WARN)
          elseif state == "stale" then
            vim.notify("BUILD.bazel 比 .classpath 新，依赖可能已经变了。\n"
                     .. "需要时运行 :BazelJdtlsClasspath 刷新", vim.log.levels.WARN)
          end

          stop_idle_jdtls(project_root)

          -- 默认 <C-]> 在没有 LSP 时退回 ctags，只报一句 "找不到 tag"，看不出是 jdtls 掉线。
          -- 挂在 FileType 上而不是 on_attach：jdtls 没连上时 on_attach 压根不会跑。
          vim.keymap.set("n", "<C-]>", function()
            if #vim.lsp.get_clients({ bufnr = 0, name = "jdtls" }) == 0 then
              vim.notify("jdtls 未连接：:JdtlsRestart 重启，或 :BazelJdtlsClasspath 重建 classpath",
                vim.log.levels.WARN)
              return
            end
            vim.lsp.buf.definition()
          end, { buffer = true, desc = "JDT: Go to Definition" })

          -- 关键：jdtls 新版本要求 Java 21+ 运行自己
          -- 但你项目是 Java 17，所以：
          --   cmd 用 Java 21 启动 jdtls
          --   settings.java.configuration.runtimes 用 Java 17 编译项目代码
          local jdtls_java = "/usr/lib/jvm/java-21-amazon-corretto/bin/java"
          if vim.fn.executable(jdtls_java) ~= 1 then
            vim.notify("Java 21 not found at " .. jdtls_java
                     .. "\nInstall: sudo apt install java-21-amazon-corretto-jdk",
                     vim.log.levels.WARN)
            jdtls_java = "java"  -- 兜底
          end

          -- Lombok 支持：从 .classpath 里找 Bazel 已经下载好的 lombok.jar
          -- 挂成 -javaagent，jdtls 才能识别 @Data / @Getter / @Builder 生成的方法
          -- 匹配路径最后一段是 "lombok-x.y.z.jar"（避开 "processed_lombok-*"）
          local function find_lombok_jar()
            local cp = project_root .. "/.classpath"
            if vim.fn.filereadable(cp) ~= 1 then return nil end
            for line in io.lines(cp) do
              local jar = line:match('path="([^"]*/lombok%-[%d.]+%.jar)"')
              if jar and vim.uv.fs_stat(jar) then return jar end
            end
            return nil
          end
          local lombok_jar = find_lombok_jar()

          local cmd = {
            jdtls_java,
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            -- ALL 会把 jdtls 的全部 stderr 灌进 ~/.local/state/nvim/lsp.log（涨到过 24MB），
            -- 写日志本身也拖慢响应
            "-Dlog.level=WARNING",
            -- iris 这种模块 classpath 有近 2000 个 jar，4g 跑半小时就贴着上限 GC 抖动
            "-Xmx6g",
            "-XX:+UseG1GC",
            "-XX:+UseStringDeduplication",
            "--add-modules=ALL-SYSTEM",
            "--add-opens", "java.base/java.util=ALL-UNNAMED",
            "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          }
          if lombok_jar then
            table.insert(cmd, "-javaagent:" .. lombok_jar)
          end
          vim.list_extend(cmd, {
            "-jar", launcher,
            "-configuration", mason_pkg .. "/config_" .. sysname,
            "-data", workspace,
          })

          require("jdtls").start_or_attach({
            cmd = cmd,
            root_dir = project_root,
            settings = {
              java = {
                signatureHelp = { enabled = true },
                contentProvider = { preferred = "fernflower" },
                -- 明确告诉 jdtls 项目用 Java 17 编译
                configuration = {
                  runtimes = {
                    {
                      name = "JavaSE-17",
                      path = "/usr/lib/jvm/java-17-amazon-corretto",
                      default = true,
                    },
                  },
                },
                -- 不要试图导入 Maven/Gradle (Bazel repo 里没这些)
                import = {
                  maven = { enabled = false },
                  gradle = { enabled = false },
                },
                -- 一些常用 static import 补全
                completion = {
                  favoriteStaticMembers = {
                    "org.junit.Assert.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "org.mockito.Mockito.*",
                    "org.assertj.core.api.Assertions.*",
                  },
                },
                -- 大 repo 的时候关掉部分诊断，减少卡顿
                maxConcurrentBuilds = 4,
              },
            },
            init_options = {
              -- 加载 Java Debug + Test adapter + Salesforce Bazel bundle
              bundles = (function()
                local mason_share = vim.fn.stdpath("data") .. "/mason/share"
                local jars = {}
                -- Java Debug Adapter
                vim.list_extend(jars, vim.split(vim.fn.glob(
                  mason_share .. "/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar"),
                  "\n", { trimempty = true }))
                -- Java Test Runner
                vim.list_extend(jars, vim.split(vim.fn.glob(
                  mason_share .. "/java-test/*.jar"),
                  "\n", { trimempty = true }))
                return jars
              end)(),
              extendedClientCapabilities = {
                classFileContentsSupport = true,
              },
            },
            on_attach = function(_, bufnr)
              -- Java 独占快捷键（普通 LSP 的 <leader>l* 依然可用）
              local map = function(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
              end
              local jdt = require("jdtls")
              map("<leader>Jo", jdt.organize_imports,    "JDT: Organize Imports")
              map("<leader>Jv", jdt.extract_variable,    "JDT: Extract Variable")
              map("<leader>Jc", jdt.extract_constant,    "JDT: Extract Constant")
              map("<leader>Jm", jdt.extract_method,      "JDT: Extract Method")
              map("<leader>Jt", jdt.test_class,          "JDT: Test Class")
              map("<leader>Jn", jdt.test_nearest_method, "JDT: Test Nearest Method")
              -- DAP debug
              map("<leader>Jd", function() require("jdtls.dap").setup_dap_main_class_configs() end,
                "JDT: Setup DAP configs")
            end,
          })
        end,
      })
    end,
  },

}
