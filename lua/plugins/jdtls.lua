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
        local target = opts.args ~= "" and opts.args or "//iris:iris-test-lib"

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
                vim.cmd("LspRestart jdtls")
              else
                vim.notify("bazel-jdtls-classpath.sh failed (exit " .. res.code .. ")\n"
                  .. (res.stderr or "") .. "\n" .. (res.stdout or ""),
                  vim.log.levels.ERROR)
              end
            end)
          end)
      end, {
        nargs = "?",
        desc = "Regenerate iris/.classpath via bazel-jdtls-classpath.sh + LspRestart",
      })

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
            "-Dlog.level=ALL",
            "-Xmx4g",  -- 大 monorepo（如 lacework/services）建议 4G+
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
