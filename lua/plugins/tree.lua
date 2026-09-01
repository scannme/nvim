return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          -- 自适应宽度：随最长文件名伸缩，够放下 Java 那种长类名
          width = {
            min = 45,
            max = 80,
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
