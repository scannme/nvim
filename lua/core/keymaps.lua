vim.g.mapleader=" "

local keymap = vim.keymap

-- ---------- 视觉模式 ---------- ---
--单行或多行移动
keymap.set("v", "K", ":m '<-2<CR>gv=gv")
keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- ---------- 正常模式 ---------- ---
--窗口
keymap.set("n", "<leader>sv", "<C-w>v") -- 水平新增窗口 
keymap.set("n", "<leader>sh", "<C-w>s") -- 垂直新增窗口

-- 取消高亮
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- ---------- 插件 ---------- ---
-- nvim-tree
keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")

-- 切换bufferBufferLineCycleNext
keymap.set("n", "<leader>bn", ":BufferLineCycleNext<CR>")
keymap.set("n", "<leader>bh", ":BufferLineCyclePrev<CR>")
keymap.set("n", "<leader>bp", ":BufferLinePick<CR>")

