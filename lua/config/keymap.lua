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

-- File explorer
map("n", "<Leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Telescope: find / search
map("n", "<Leader>ff", tb("find_files"),     { desc = "Find files" })
map("n", "<Leader>fg", tb("live_grep"),      { desc = "Live grep" })
map("n", "<Leader>fb", tb("buffers"),        { desc = "Buffers" })
map("n", "<Leader>fh", tb("help_tags"),      { desc = "Help tags" })
map("n", "<Leader>fr", tb("oldfiles"),       { desc = "Recent files" })
map("n", "<Leader>fk", tb("keymaps"),        { desc = "Keymaps" })
map("n", "<Leader>fd", tb("diagnostics"),    { desc = "Diagnostics" })
map("n", "<Leader>fR", tb("resume"),         { desc = "Resume last picker" })
map("n", "<Leader>fc", tb("git_commits"),    { desc = "Git commits" })
map("n", "<Leader>fG", tb("git_status"),     { desc = "Git status" })
map("n", "<Leader>ft", tb("tags"),                { desc = "Tags (all, ctags)" })
map("n", "<Leader>fT", tb("current_buffer_tags"), { desc = "Tags (current buffer)" })
map("n", "<Leader>fS", tb("lsp_dynamic_workspace_symbols"), { desc = "Symbols (workspace, LSP)" })
map("n", "<Leader>fs", "<cmd>Telescope aerial<CR>", { desc = "Symbols (aerial)" })
map("n", "<Leader>ls", "<cmd>Telescope aerial<CR>", { desc = "Symbols (aerial)" })

-- Call hierarchy (litee-calltree): drill-down tree of callers/callees
map("n", "<Leader>ci", vim.lsp.buf.incoming_calls, { desc = "Incoming calls (callers tree)" })
map("n", "<Leader>co", vim.lsp.buf.outgoing_calls, { desc = "Outgoing calls (callees tree)" })

-- Fuzzy find in current buffer
map("n", "<Leader>/", tb("current_buffer_fuzzy_find"), { desc = "Fuzzy find in current buffer" })

-- Grep word under cursor (normal mode = <cword>, visual mode = selection)
map("n", "<Leader>fw", function()
  require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Grep word under cursor" })
map("v", "<Leader>fw", function()
  local saved = vim.fn.getreg("v")
  vim.cmd('noautocmd normal! "vy')
  local sel = vim.fn.getreg("v")
  vim.fn.setreg("v", saved)
  require("telescope.builtin").grep_string({ search = sel })
end, { desc = "Grep visual selection" })

-- Gitsigns hunks (wrapped so gitsigns can be lazy-loaded)
map("n", "]g", function() require("gitsigns").next_hunk() end, { desc = "Next git hunk" })
map("n", "[g", function() require("gitsigns").prev_hunk() end, { desc = "Prev git hunk" })
map("n", "<Leader>gs", ":Gitsigns stage_hunk<CR>",       { desc = "Git stage hunk" })
map("n", "<Leader>gu", ":Gitsigns undo_stage_hunk<CR>",  { desc = "Git undo stage" })
map("n", "<Leader>gr", ":Gitsigns reset_hunk<CR>",       { desc = "Git reset hunk" })

-- Terminal
map("n", "<Leader>tt", "<cmd>ToggleTerm<CR>",                       { desc = "Toggle terminal" })
map("n", "<Leader>th", "<cmd>ToggleTerm direction=horizontal<CR>",  { desc = "Terminal horizontal" })

-- Diagnostics: K shows diagnostic float in normal mode
map("n", "K", vim.diagnostic.open_float, { desc = "Show diagnostic" })
