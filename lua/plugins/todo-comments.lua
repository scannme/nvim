return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      highlight = {
        pattern = [[.*<(KEYWORDS)\s*:]],
      },
      search = {
        pattern = [[\b(KEYWORDS):]],
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "-g", "**/dlpcode/**",
          "-g", "**/go/**",
        },
      },
    },
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                              desc = "Search TODOs (Telescope)" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                                desc = "TODOs in Trouble" },
    },
  },
}
