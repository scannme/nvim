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
      local java_tools = { "jdtls", "java-debug-adapter", "java-test", "google-java-format" }
      for _, tool in ipairs(java_tools) do
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
      ensure_installed = { "pyright", "gopls", "clangd", "ts_ls" },  -- jdtls 不放这里！
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
        end,
      })

      -- LSP server 配置 (nvim 0.11+)
      vim.lsp.config("pyright", {
        root_markers = {
          "pyproject.toml", "setup.py", "setup.cfg",
          "requirements.txt", "Pipfile", "pyrightconfig.json",
          ".git",
        },
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              indexing = true,
              diagnosticMode = "workspace",
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

      vim.lsp.config("ts_ls", {
        root_markers = {
          "package.json", "tsconfig.json", "jsconfig.json", ".git",
        },
        filetypes = {
          "javascript", "javascriptreact", "javascript.jsx",
          "typescript", "typescriptreact", "typescript.tsx",
        },
      })

      vim.lsp.enable({ "pyright", "gopls", "clangd", "ts_ls" })
    end,
  },
}
