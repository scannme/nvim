return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = true,
  },
  keys = {
    { "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>",                       desc = "Trouble: workspace diagnostics" },
    { "<leader>dT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",          desc = "Trouble: buffer diagnostics" },
    { "<leader>dq", "<cmd>Trouble qflist toggle<cr>",                            desc = "Trouble: quickfix list" },
    { "<leader>dL", "<cmd>Trouble loclist toggle<cr>",                           desc = "Trouble: location list" },
  },
}
