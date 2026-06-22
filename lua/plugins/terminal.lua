
return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],  -- Ctrl + \ 切换终端
        direction = "float",       -- 使用浮动终端窗口
        start_in_insert = true,    -- 打开即进入插入模式
      })

      -- <C-\> 已是默认浮动终端入口；这里仅留水平/垂直分屏快捷键
      vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal Horizontal" })
      vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal Vertical" })

      -- lazygit 浮窗（按 <Leader>gg 切换）
      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
          border = "rounded",
          width  = function() return math.floor(vim.o.columns * 0.95) end,
          height = function() return math.floor(vim.o.lines   * 0.95) end,
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          -- 在 lazygit 里 q 直接关闭终端窗口
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
          -- lazygit 自己用 <C-h/l> 切换面板，恢复 buffer-local passthrough，避免被全局映射截走导致浮窗失焦
          for _, k in ipairs({ "<C-h>", "<C-j>", "<C-k>", "<C-l>" }) do
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", k, k, { noremap = true, silent = true })
          end
        end,
      })
      vim.keymap.set("n", "<leader>gg", function() lazygit:toggle() end, { desc = "Lazygit (float)" })
    end,
  },
}
