return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>lF",
        function() require("conform").format({ async = true, lsp_fallback = true }) end,
        mode = { "n", "v" },
        desc = "Format buffer (conform)",
      },
    },
    opts = {
      formatters_by_ft = {
        c          = { "clang-format" },
        cpp        = { "clang-format" },
        go         = { "goimports", "gofumpt" },
        python     = { "isort", "black" },
        lua        = { "stylua" },
        sh         = { "shfmt" },
        json       = { "jq" },
        yaml       = { "yamlfmt" },
      },
      format_on_save = function(bufnr)
        if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
          return nil
        end
        return { timeout_ms = 2000, lsp_fallback = true }
      end,
    },
    init = function()
      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
      end, { bang = true, desc = "Toggle autoformat (! for buffer-local)" })
    end,
  },
}
