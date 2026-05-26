return {
  "stevearc/aerial.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("aerial").setup({
      layout = { default_direction = "right" },
    })
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Aerial (symbols)" })
  end,
}

