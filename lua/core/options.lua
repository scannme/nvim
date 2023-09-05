local opt = vim.opt

-- 行号
opt.number = true
opt.relativenumber = true

-- 缩进
opt.tabstop = 4
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

-- 光标
opt.cursorline = true

-- 启用鼠标
opt.mouse:append("a")

--系统剪切板
opt.clipboard:append("unnamedplus")

-- 默认新窗口
opt.splitright = true
opt.splitbelow = true

-- 搜索
opt.ignorecase = true
opt.smartcase = true

-- 外观
opt.termguicolors = true
opt.signcolumn = "yes"
vim.cmd[[colorscheme tokyonight-moon]]

vim.loader.enable() -- load the impatient for faster start

