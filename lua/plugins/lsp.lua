return {
  -- mason: 自动管理 LSP server 安装
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
      -- 确保 mason bin 在 PATH 中
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "pyright", "gopls", "clangd" },
      automatic_installation = true,
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
            local ok = pcall(require('telescope.builtin').lsp_implementations, opts)
            if not ok or vim.tbl_isempty(vim.fn.getqflist()) then
              require('telescope.builtin').lsp_definitions(opts)
            end
          end, { desc = "Telescope: Impl → Def Fallback" })

          bufmap("n", "<leader>ld", vim.lsp.buf.definition, { desc = "LSP: Go to Definition" })
          bufmap("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover" })
          bufmap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename" })
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

      vim.lsp.enable({ "pyright", "gopls", "clangd" })
    end,
  },
}
