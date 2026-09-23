return {
  -- mason: 自动管理 LSP server 安装
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
      -- 确保 mason bin 在 PATH 中
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

      -- jdtls 单独通过 nvim-jdtls 管理，这里只保证 Mason 装好它
      -- (放在 mason.nvim 而不是 mason-lspconfig，避免 lspconfig 尝试 auto-enable
      --  跟 nvim-jdtls 打架)
      -- 顺便装 Java DAP + Test adapter，配合 nvim-dap 可以在 nvim 里断点调试 + 跑单个 JUnit
      local registry = require("mason-registry")

      -- jdtls 用最新版（Mason 默认）—— 但需要 Java 21 运行（见 jdtls.lua）
      local tools = {
        "jdtls", "java-debug-adapter", "java-test", "google-java-format",
        -- prettierd: prettier 的常驻守护进程。rainbow 那种 10k 文件的仓库里，
        -- 每次保存 spawn 一次 node 跑 prettier 要几百 ms，prettierd 是常驻的。
        -- 它会自动解析项目里 node_modules 的 prettier 和 .prettierrc，不是用自带的版本。
        "prettierd",
      }
      for _, tool in ipairs(tools) do
        if not registry.is_installed(tool) then
          vim.notify("Installing " .. tool .. " via Mason...", vim.log.levels.INFO)
          registry.get_package(tool):install()
        end
      end
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      -- vtsls 而不是 ts_ls：见下面 vim.lsp.config("vtsls") 的注释
      ensure_installed = { "pyright", "gopls", "clangd", "vtsls" },  -- jdtls 不放这里！
      automatic_installation = true,
      -- 关掉 auto-enable，避免 mason-lspconfig 自动帮 jdtls 调 vim.lsp.enable()
      -- （nvim-jdtls 会自己 start_or_attach，两个都启动会冲突）
      automatic_enable = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      vim.api.nvim_create_user_command("CheckCallHierarchy", function()
        local params = vim.lsp.util.make_position_params(0, "utf-8")
        vim.lsp.buf_request(0, "textDocument/prepareCallHierarchy", params, function(err, items)
          if err then print("prepare err: " .. vim.inspect(err)) return end
          if not items or #items == 0 then print("prepare returned empty") return end
          print("prepare ok, item: " .. (items[1].name or "?") .. " kind=" .. tostring(items[1].kind))
          vim.lsp.buf_request(0, "callHierarchy/incomingCalls", { item = items[1] }, function(e2, res)
            print(vim.inspect({ err = e2, count = res and #res or 0, sample = res and res[1] }))
          end)
        end)
      end, {})

      -- LSP keybindings via LspAttach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local bufmap = function(mode, lhs, rhs, opts)
            opts = vim.tbl_extend("force", { noremap = true, silent = true, buffer = bufnr }, opts or {})
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          bufmap("n", "<leader>lr", function()
            require('telescope.builtin').lsp_references({
              layout_strategy = 'horizontal',
              layout_config = {
                width = 0.8,
                height = 0.6,
                preview_width = 0.6,
              },
              prompt_prefix = '🔍 ',
              initial_mode = 'insert',
              show_line = true,
            })
          end, { desc = "Telescope: LSP References" })

          bufmap("n", "<leader>li", function()
            local opts = {
              layout_strategy = 'horizontal',
              layout_config   = { preview_width = 0.6 },
              prompt_prefix   = '🔍 ',
              show_line       = true,
            }
            local supports = false
            for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
              if c.server_capabilities and c.server_capabilities.implementationProvider then
                supports = true
                break
              end
            end
            if supports then
              require('telescope.builtin').lsp_implementations(opts)
            else
              require('telescope.builtin').lsp_definitions(opts)
            end
          end, { desc = "Telescope: Impl → Def Fallback" })

          bufmap("n", "<leader>ld", vim.lsp.buf.definition,      { desc = "LSP: Go to Definition" })
          bufmap("n", "K",          vim.lsp.buf.hover,           { desc = "LSP: Hover" })
          bufmap("n", "<leader>lR", vim.lsp.buf.rename,          { desc = "LSP: Rename" })
          bufmap("n", "<leader>la", vim.lsp.buf.code_action,     { desc = "LSP: Code action" })
          bufmap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP: Format" })
          bufmap("n", "<leader>lI", vim.lsp.buf.incoming_calls,  { desc = "LSP: Incoming calls" })
          bufmap("n", "<leader>lO", vim.lsp.buf.outgoing_calls,  { desc = "LSP: Outgoing calls" })

          -- 整理 import（删没用的 + 排序）。走通用的 source.organizeImports code action，
          -- 所以 vtsls / gopls / jdtls 都吃这一套。
          bufmap("n", "<leader>lo", function()
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" }, diagnostics = {} },
              apply = true,
            })
          end, { desc = "LSP: Organize imports" })

          bufmap("n", "<leader>lh", function()
            local on = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not on, { bufnr = bufnr })
          end, { desc = "LSP: Toggle inlay hints" })

          -- vtsls 专属：跳到「真正的源码」而不是 .d.ts。
          -- monorepo 里 gd 经常落在 dist/*.d.ts 上，这个能穿透过去。没有 vtsls 或者
          -- 查不到结果时退回普通 definition。
          if args.data and args.data.client_id then
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "vtsls" then
              bufmap("n", "<leader>lD", function()
                local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
                client:exec_cmd({
                  title = "Go to Source Definition",
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                }, { bufnr = bufnr }, function(err, result)
                  if err or type(result) ~= "table" or vim.tbl_isempty(result) then
                    vim.lsp.buf.definition()
                    return
                  end
                  if #result == 1 then
                    vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true })
                  else
                    vim.fn.setqflist({}, " ", {
                      title = "Source Definitions",
                      items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
                    })
                    vim.cmd("botright copen")
                  end
                end)
              end, { desc = "LSP: Go to Source Definition (vtsls)" })
            end
          end
        end,
      })

      -- LSP server 配置 (nvim 0.11+)
      vim.lsp.config("pyright", {
        root_markers = {
          "pyproject.toml", "setup.py", "setup.cfg",
          "requirements.txt", "Pipfile", "pyrightconfig.json",
          ".git",
        },
        -- pyright 默认用 PATH 上的 python（/usr/bin/python），不认项目里的 .venv，
        -- 第三方包全报 "could not be resolved"。这里从 root 往上找 .venv / venv，
        -- 找不到再看 $VIRTUAL_ENV。
        before_init = function(_, config)
          local venv = vim.fs.find({ ".venv", "venv" }, {
            upward = true, type = "directory", path = config.root_dir,
          })[1] or vim.env.VIRTUAL_ENV
          local py = venv and venv .. "/bin/python"
          if py and vim.fn.executable(py) == 1 then
            config.settings.python.pythonPath = py
          end
        end,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              indexing = true,
              -- workspace 模式会分析整个仓库，foggy-anchor / sbm_main 这种 2 万多个 .py
              -- 的仓库会卡死，只分析打开的文件
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses    = { unusedparams = true, unusedwrite = true },
            staticcheck = true,
          },
        },
      })

      vim.lsp.config("clangd", {
        cmd       = { "clangd", "--background-index" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
      })

      -- vtsls 取代 ts_ls。两个不能同时开（会双份诊断 + 双份 tsserver 内存）。
      --
      -- 换掉的原因是 monorepo：ts_ls 用 package.json 当 root marker，像 rainbow 那种
      -- 少数 lib 自带 package.json 的仓库会被切成好几个 workspace，每个起一份 tsserver，
      -- 跨 lib 跳转还跳不过去。vtsls 的 root 是 lock 文件 / .git（即仓库根），单实例，
      -- 内部按文件找最近的 tsconfig —— 正好是 Nx 那种「一个根 + 一堆 project」的形状。
      --
      -- 另外 tsserver 默认堆是 3GB，rainbow 有 10667 个 .ts/.tsx + 91 条 path alias，
      -- 撑不住，所以 maxTsServerMemory 拉到 8GB。
      vim.lsp.config("vtsls", {
        settings = {
          vtsls = {
            -- 用项目 node_modules 里的 TypeScript，而不是 vtsls 自带的那份。
            -- rainbow 是 TS 6.0.3，版本对不上语法会报错。
            autoUseWorkspaceTsdk = true,
            experimental = {
              -- 服务端做模糊匹配，10k 文件下补全候选排序明显更准
              completion = { enableServerSideFuzzyMatch = true },
            },
          },
          typescript = {
            tsserver = { maxTsServerMemory = 8192 },
            -- 移动/重命名文件时自动改所有 import
            updateImportsOnFileMove = { enabled = "always" },
            suggest = { completeFunctionCalls = true },
            -- importModuleSpecifier 保持默认的 "shortest"：rainbow 的惯例是 lib 内部走
            -- 相对路径、跨 lib 走 @lacework/* alias，"shortest" 生成的正好是这个形状。
            inlayHints = {
              parameterNames        = { enabled = "literals" },
              variableTypes         = { enabled = false },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes  = { enabled = true },
              enumMemberValues      = { enabled = true },
            },
          },
          javascript = {
            updateImportsOnFileMove = { enabled = "always" },
          },
        },
      })

      vim.lsp.enable({ "pyright", "gopls", "clangd", "vtsls" })
    end,
  },
}
