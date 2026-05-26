-- lua/plugins/copilot.lua
-- 这是一个使用 lazy.nvim 安装并配置 GitHub Copilot 的插件文件
return {
  "zbirenbaum/copilot.lua",
  enabled = false,
  lazy = true,
  event = "InsertEnter",  -- 进入插入模式时加载
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<C-J>",       -- 接受建议
        next = "<C-\\>",       -- 下一个建议
        prev = "<C-;>",          -- 上一个建议
        dismiss = "<C-/>",       -- 关闭建议
      },
    },
    panel = {
      enabled = true,
      keymap = {
        open = "<Leader>cp",     -- 打开 Copilot 面板
        next = "j",
        prev = "k",
        accept = "<CR>",
        refresh = "r",
      },
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
  end,
}

