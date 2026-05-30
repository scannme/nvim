-- File: ~/.config/nvim/lua/config/keymap.lua

local map = vim.keymap.set
local function tb(name, opts)
  return function() require("telescope.builtin")[name](opts or {}) end
end

-- Basic
map("n", "<Leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<Leader>q", ":q<CR>", { desc = "Quit" })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Buffer switching
map("n", "<S-l>", ":bnext<CR>")
map("n", "<S-h>", ":bprevious<CR>")

-- File explorer & symbols sidebar
map("n", "<Leader>e", ":NvimTreeToggle<CR>",  { desc = "Toggle file explorer" })
-- <Leader>a (Aerial) is mapped in plugins/aerial.lua

-- Find (f) — generic pickers
map("n", "<Leader>ff", tb("find_files"), { desc = "Find files" })
map("n", "<Leader>fg", tb("live_grep"),  { desc = "Live grep" })
map("n", "<Leader>fb", tb("buffers"),    { desc = "Buffers" })
map("n", "<Leader>fh", tb("help_tags"),  { desc = "Help tags" })
map("n", "<Leader>fr", tb("oldfiles"),   { desc = "Recent files" })
map("n", "<Leader>fk", tb("keymaps"),    { desc = "Keymaps" })
map("n", "<Leader>fR", tb("resume"),     { desc = "Resume last picker" })
map("n", "<Leader>/",  tb("current_buffer_fuzzy_find"), { desc = "Fuzzy find in current buffer" })

-- Search / Symbols (s)
map("n", "<Leader>ss", "<cmd>Telescope aerial<CR>",          { desc = "Symbols (current buffer)" })
map("n", "<Leader>sS", tb("lsp_dynamic_workspace_symbols"),  { desc = "Symbols (workspace, LSP)" })
map("n", "<Leader>sw", function()
  require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
map("v", "<Leader>sw", function()
  local saved = vim.fn.getreg("v")
  vim.cmd('noautocmd normal! "vy')
  local sel = vim.fn.getreg("v")
  vim.fn.setreg("v", saved)
  require("telescope.builtin").grep_string({ search = sel })
end, { desc = "Grep visual selection" })

-- Git (g)
map("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>",      { desc = "Git stage hunk" })
map("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Git undo stage" })
map("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>",      { desc = "Git reset hunk" })
map("n", "<Leader>gb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Git blame line" })
map("n", "<Leader>gc", tb("git_commits"),               { desc = "Git commits" })
map("n", "<Leader>gS", tb("git_status"),                { desc = "Git status" })
map("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next git hunk" })
map("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Prev git hunk" })

-- Diagnostics (d)
map("n", "<Leader>dl", tb("diagnostics"),         { desc = "Diagnostics list" })
map("n", "<Leader>df", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<Leader>dn", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
map("n", "<Leader>dp", vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })

-- Terminal (t)
-- <C-\> opens float terminal (toggleterm default), th/tv defined in plugins/terminal.lua
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Quickfix navigation
map("n", "]q", ":cnext<CR>",     { desc = "Next quickfix" })
map("n", "[q", ":cprevious<CR>", { desc = "Prev quickfix" })
map("n", "]Q", ":clast<CR>",     { desc = "Last quickfix" })
map("n", "[Q", ":cfirst<CR>",    { desc = "First quickfix" })

-- Keep visual selection after indenting
map("v", "<", "<gv", { desc = "Indent left (keep selection)" })
map("v", ">", ">gv", { desc = "Indent right (keep selection)" })
