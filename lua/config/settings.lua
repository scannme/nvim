vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"
vim.o.guifont = "Courier New:h16"
vim.o.guicursor = "a:block-blinkon500"
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.colorscheme("sourceinsight")

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Auto reload files changed outside of nvim (e.g. by claude code)
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("文件在磁盘上被修改，已重新加载", vim.log.levels.WARN)
  end,
})
