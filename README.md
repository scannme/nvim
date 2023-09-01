## 目录结构

## 使用插件

## 快捷键命令

该工程使用space键作为主键

vim.g.mapleader = " "

1. 单行或多行移动
大写的K和J, 在视觉模式下(v), 选中要移动的行数，然后shift+j(上),或shift+k移动（下）
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")  
2. 打开窗口
在普通模式下，使用space 加 sv (水平)或sh (竖直)打开新的窗口
keymap.set("n", "<leader>sv", "<C-w>v") -- 水平新增窗口 
keymap.set("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口 
