return {
  "olexsmir/gopher.nvim",
  ft = "go",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  build = function() vim.cmd([[silent! GoInstallDeps]]) end,
  config = function()
    require("gopher").setup({})

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "go",
      callback = function(ev)
        local bufmap = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
        end
        bufmap("<leader>ce", "<cmd>GoIfErr<cr>",            "Go: if err")
        bufmap("<leader>cj", "<cmd>GoTagAdd json<cr>",      "Go: add json tags")
        bufmap("<leader>cy", "<cmd>GoTagAdd yaml<cr>",      "Go: add yaml tags")
        bufmap("<leader>ct", "<cmd>GoTagRm<cr>",            "Go: remove tags")
        bufmap("<leader>ci", "<cmd>GoImpl<cr>",             "Go: impl interface")
        bufmap("<leader>cs", "<cmd>GoFillStruct<cr>",       "Go: fill struct")
        bufmap("<leader>cw", "<cmd>GoFillSwitch<cr>",       "Go: fill switch")
      end,
    })
  end,
}
