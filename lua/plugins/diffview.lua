return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles" },
  keys = {
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: current file history" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "Diffview: repo history" },
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diffview: working diff" },
    { "<leader>gx", "<cmd>DiffviewClose<cr>",         desc = "Diffview: close" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { layout = "diff2_horizontal" },
      merge_tool = { layout = "diff3_horizontal" },
    },
  },
}
