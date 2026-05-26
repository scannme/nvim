return {
  "fatih/vim-go",
  ft = { "go" },
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    -- 1) 用 goimports 而不是 gofmt
    vim.g.go_fmt_command = "goimports"

    -- 2) 保存时自动格式化（同时跑 goimports）
    vim.cmd([[
      augroup GoFmtOnSave
        autocmd!
        autocmd BufWritePre *.go silent! GoFmt
      augroup END
    ]])

    -- （可选）如果你只想做 import 而不格式化：
    -- vim.cmd([[
    --   augroup GoImportsOnSave
    --     autocmd!
    --     autocmd BufWritePre *.go silent! GoImports
    --   augroup END
    -- ]])
  end,
}

