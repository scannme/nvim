return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    main = "treesitter-context",
    opts = {
      max_lines = 1,
      min_window_height = 20,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
    },
    keys = {
      { "<leader>uc", function() require("treesitter-context").toggle() end, desc = "Toggle TS context" },
      { "[c",        function() require("treesitter-context").go_to_context(vim.v.count1) end, desc = "Jump to context" },
    },
  },
}
