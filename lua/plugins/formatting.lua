local prettier = { "prettierd", "prettier", stop_after_first = true }

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
        -- Java is left out on purpose: google-java-format rewrites the whole file (2-space
        -- indent, reordered imports) and the repos here use 4-space with unsorted imports, so
        -- saving one file turned a 90-line change into a 2000-line diff. Leaving it out is
        -- not enough on its own -- see the java guard in format_on_save below.

        -- prettierd 是常驻守护进程；prettier 每次保存都要冷启动一次 node，在 rainbow
        -- 那种大仓库里是几百 ms 的可感顿挫。prettierd 会自己去解析项目 node_modules
        -- 里的 prettier 和 .prettierrc，用的是项目那份版本，不是它自带的。
        -- stop_after_first：prettierd 没装/挂了就退回 prettier。
        javascript       = prettier,
        javascriptreact  = prettier,
        typescript       = prettier,
        typescriptreact  = prettier,
        css              = prettier,
        scss             = prettier,
        less             = prettier,
        html             = prettier,
        graphql          = prettier,
        markdown         = prettier,
      },
      format_on_save = function(bufnr)
        if vim.b[bufnr].disable_autoformat or vim.g.disable_autoformat then
          return nil
        end
        -- Omitting java from formatters_by_ft does not spare it: lsp_fallback hands any
        -- unconfigured filetype to the LSP, and jdtls' Eclipse formatter rewraps the whole
        -- file at 120 columns, comments included, so a 150-line change lands as 400+.
        -- Format new code by selecting it and hitting <leader>lF -- conform range-formats
        -- a visual selection, leaving the rest of the file untouched.
        if vim.bo[bufnr].filetype == "java" then
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
