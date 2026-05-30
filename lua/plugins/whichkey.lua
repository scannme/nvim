return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>f", group = "Find" },
      { "<leader>s", group = "Search/Symbols" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>d", group = "Diagnostics" },
      { "<leader>t", group = "Terminal" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>c", group = "Code (Go)" },
      { "<leader>gg", desc = "Lazygit (float)" },
      { "<leader>gh", desc = "Diffview: file history" },
      { "<leader>gH", desc = "Diffview: repo history" },
      { "<leader>gd", desc = "Diffview: working diff" },
      { "<leader>gx", desc = "Diffview: close" },
    })
  end,
}
