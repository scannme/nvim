return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          -- 自适应宽度：随最长文件名伸缩，不超过 60 列
          width = {
            min = 35,
            max = 60,
            padding = 2,
          },
        },
        git = {
          enable = true,
          timeout = 5000,
        },
      })
    end,
  },
}
