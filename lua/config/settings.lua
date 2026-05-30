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
