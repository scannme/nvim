
  return {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = false,
    dependencies = {
      "zbirenbaum/copilot.lua",
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",  -- 在 MacOS 或 Linux 上构建 tiktoken 支持
    lazy = true,
    cmd = "CopilotChat",      -- 通过命令触发加载
    keys = { "<Leader>cc", "<Leader>cC" },
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1,1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,               -- 自动进入插入模式
        question_header   = "  " .. user .. " ",  -- 用户提示头
        answer_header     = "  Copilot ",       -- 回答提示头
        window = {
          width = 0.4,                         -- 窗口宽度比例
        },
      }
    end,
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      -- 快捷键映射
      vim.keymap.set("n", "<Leader>cc", function() require("CopilotChat").open() end,   { desc = "CopilotChat: Open" })
      vim.keymap.set("n", "<Leader>cC", function() require("CopilotChat").close() end,  { desc = "CopilotChat: Close" })
      vim.keymap.set("i", "<C-Enter>",      function() return require("CopilotChat").send_message() end, { expr = true, silent = true, desc = "CopilotChat: Send Message" })
      vim.keymap.set("i", "<Tab>",          function() return require("CopilotChat").next_message() end, { expr = true, silent = true, desc = "CopilotChat: Next Message" })
      vim.keymap.set("i", "<S-Tab>",        function() return require("CopilotChat").prev_message() end, { expr = true, silent = true, desc = "CopilotChat: Prev Message" })
    end,
  }
