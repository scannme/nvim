-- File: ~/.config/nvim/lua/keymaphglua

vim.keymap.set("n", "<Leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<Leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

vim.keymap.set("n", "<Leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<Leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<CR>", { desc = "Grep in files" })
vim.keymap.set("n", "<Leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<Leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<Leader>t", ":ToggleTerm<CR>", { desc = "Toggle terminal" })

-- 把 <leader>fw 绑定成用 Telescope grep_string 搜索光标下的单词
vim.api.nvim_set_keymap(
  'n',
  '<leader>fw',
  "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>') })<CR>",
  { noremap = true, silent = true }
)

vim.keymap.set("n", "]g", require("gitsigns").next_hunk)
vim.keymap.set("n", "[g", require("gitsigns").prev_hunk)
vim.keymap.set("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Git stage hunk" })
vim.keymap.set("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Git undo stage" })
vim.keymap.set("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Git reset hunk" })

-- 快速模糊查找引用/定义等
--vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol,  { desc = "LSP: Document Symbols" })
vim.keymap.set("n", "<leader>ls", "<cmd>Telescope aerial<CR>", { desc = "Search symbols" })


vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Terminal Horizontal" })
--vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Terminal Vertical" })



-- 在 normal 模式下，按 K 就弹出诊断信息
vim.keymap.set('n', 'K', vim.diagnostic.open_float, { desc = "Show diagnostic" })

