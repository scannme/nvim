# 🧠 Neovim Dev Environment

A modern Neovim setup using **lazy.nvim**, covering LSP, autocompletion, formatting, debugging, file browsing, fuzzy finding, and Git workflows. Languages enabled out of the box: **Python, Go, C/C++, Lua, Shell, JSON, YAML**.

## 📦 Plugins Used

| Plugin                          | Purpose                                       |
|---------------------------------|-----------------------------------------------|
| `lazy.nvim`                     | Plugin manager                                |
| `nvim-lspconfig`                | LSP support                                   |
| `nvim-cmp`, `cmp-nvim-lsp`      | Autocompletion                                |
| `LuaSnip`, `cmp_luasnip`        | Snippet engine                                |
| `nvim-treesitter`               | Syntax highlighting                           |
| `nvim-treesitter-context`       | Sticky context header                         |
| `nvim-dap`, `nvim-dap-ui`       | Debugging core + UI                           |
| `nvim-dap-virtual-text`         | Inline variable values while debugging        |
| `conform.nvim`                  | Formatter (black/isort, gofumpt, stylua, …)   |
| `ray-x/go.nvim`, `gopher.nvim`  | Go tooling (build/test/struct tags)           |
| `aerial.nvim`                   | Symbols sidebar / outline                     |
| `litee-calltree.nvim`           | Call hierarchy viewer                         |
| `telescope.nvim`                | Fuzzy file/grep/symbol picker                 |
| `nvim-tree.lua`                 | File explorer                                 |
| `harpoon`                       | Pinned-file quick switcher                    |
| `flash.nvim`                    | Fast jump motions                             |
| `toggleterm.nvim`               | Built-in terminal + lazygit/Claude floats     |
| `gitsigns.nvim`                 | Git hunk signs + inline blame                 |
| `diffview.nvim`                 | Git diff / file history viewer                |
| `trouble.nvim`                  | Diagnostics / quickfix / loclist UI           |
| `todo-comments.nvim`            | Highlight + search TODO/FIXME/NOTE            |
| `nvim-surround`                 | Surround with brackets/quotes/tags            |
| `nvim-autopairs`                | Auto-close pairs                              |
| `lualine.nvim`                  | Statusline                                    |
| `noice.nvim`                    | Cleaner cmdline / messages UI                 |
| `fidget.nvim`                   | LSP progress notifications                    |
| `which-key.nvim`                | Show available keybindings                    |
| `sourceinsight` (local)         | Colorscheme (default)                         |

---

## 🎹 Keybindings

Leader key is `<Space>` (see `lua/config/settings.lua`).

### 📄 General

| Key             | Action                   |
|-----------------|--------------------------|
| `<Leader>w`     | Save file                |
| `<Leader>q`     | Quit                     |
| `<C-h/j/k/l>`   | Window navigation        |
| `<S-h>/<S-l>`   | Prev / next buffer       |
| `<` / `>` (V)   | Indent and keep selection |

### 🗂 File Explorer & Find (`f`)

| Key             | Action                          |
|-----------------|---------------------------------|
| `<Leader>e`     | Toggle file explorer (nvim-tree)|
| `<Leader>ff`    | Find files                      |
| `<Leader>fg`    | Live grep                       |
| `<Leader>fb`    | Buffers                         |
| `<Leader>fh`    | Help tags                       |
| `<Leader>fr`    | Recent files                    |
| `<Leader>fk`    | Keymaps                         |
| `<Leader>fR`    | Resume last picker              |
| `<Leader>/`     | Fuzzy find in current buffer    |

### 🔎 Search & Symbols (`s`)

| Key                    | Action                                       |
|------------------------|----------------------------------------------|
| `<Leader>a`            | Toggle Aerial (symbols outline)              |
| `<Leader>ss`           | Symbols in current buffer (Aerial)           |
| `<Leader>sS`           | Workspace symbols (LSP) — V-mode prefills sel|
| `<Leader>sw`           | Grep word under cursor (V-mode: selection)   |
| `<Leader>st`           | Search TODOs (Telescope)                     |

### 🧠 LSP (`l`, buffer-local)

| Key             | Action                       |
|-----------------|------------------------------|
| `K`             | Hover                        |
| `<Leader>ld`    | Go to definition             |
| `<Leader>lr`    | References                   |
| `<Leader>li`    | Implementations              |
| `<Leader>lR`    | Rename                       |
| `<Leader>la`    | Code action                  |
| `<Leader>lf`    | Format via LSP               |
| `<Leader>lF`    | Format via conform           |
| `<Leader>lI`    | Incoming calls               |
| `<Leader>lO`    | Outgoing calls               |

### 🩺 Diagnostics & Trouble (`d`, `x`)

| Key             | Action                            |
|-----------------|-----------------------------------|
| `<Leader>dl`    | Diagnostics list (Telescope)      |
| `<Leader>df`    | Diagnostic float                  |
| `<Leader>dn`    | Next diagnostic                   |
| `<Leader>dp`    | Prev diagnostic                   |
| `<Leader>dt`    | Trouble: workspace diagnostics    |
| `<Leader>dT`    | Trouble: buffer diagnostics       |
| `<Leader>dq`    | Trouble: quickfix list            |
| `<Leader>dL`    | Trouble: location list            |
| `<Leader>xt`    | TODOs in Trouble                  |

### 🌿 Git & Diffview (`g`)

| Key             | Action                            |
|-----------------|-----------------------------------|
| `[g` / `]g`     | Prev / next hunk                  |
| `<Leader>gs`    | Stage hunk                        |
| `<Leader>gu`    | Undo stage hunk                   |
| `<Leader>gr`    | Reset hunk                        |
| `<Leader>gb`    | Blame line (full)                 |
| `<Leader>gc`    | Git commits (Telescope)           |
| `<Leader>gS`    | Git status (Telescope)            |
| `<Leader>gd`    | Diffview: working diff            |
| `<Leader>gh`    | Diffview: current file history    |
| `<Leader>gH`    | Diffview: repo history            |
| `<Leader>gx`    | Diffview: close                   |
| `<Leader>gg`    | Lazygit (float)                   |

### 🪝 Harpoon (`h`)

| Key             | Action                            |
|-----------------|-----------------------------------|
| `<Leader>ha`    | Add current file                  |
| `<Leader>hh`    | Toggle quick menu                 |
| `<Leader>1..4`  | Jump to slot 1–4                  |
| `<Leader>hn/hp` | Next / prev slot                  |

### 🐹 Code (Go-only, `c`)

Active only in Go buffers (provided by `gopher.nvim`).

| Key             | Action                            |
|-----------------|-----------------------------------|
| `<Leader>ce`    | Generate `if err != nil` block    |
| `<Leader>cj`    | Add `json` struct tags            |
| `<Leader>cy`    | Add `yaml` struct tags            |
| `<Leader>ct`    | Remove struct tags                |
| `<Leader>ci`    | Implement interface               |
| `<Leader>cs`    | Fill struct                       |
| `<Leader>cw`    | Fill switch                       |

### ⚡ Motion

| Key       | Action                                  |
|-----------|-----------------------------------------|
| `s` (n/x/o) | Flash jump                            |
| `S` (n/x/o) | Flash Treesitter jump                 |
| `r` (o)     | Remote Flash                          |

### 💻 Terminal & Tools (`t`, `c`)

| Key             | Action                            |
|-----------------|-----------------------------------|
| `<C-\>`         | Toggle floating terminal          |
| `<Leader>th`    | Horizontal terminal               |
| `<Leader>tv`    | Vertical terminal                 |
| `<Leader>cc`    | Toggle Claude Code (float)        |
| `<Esc><Esc>`    | Exit terminal mode                |

### 📝 Misc

| Key             | Action                            |
|-----------------|-----------------------------------|
| `]t` / `[t`     | Next / prev TODO                  |
| `]q` / `[q`     | Next / prev quickfix              |
| `]Q` / `[Q`     | Last / first quickfix             |

> Debugging (`nvim-dap`) is installed but no default keymaps are bound — add your own in `lua/config/keymap.lua` or a `plugins/dap.lua` keys block if you use it.

---

## 🚀 Setup Instructions

```bash
# Clone lazy.nvim if not already installed
git clone https://github.com/folke/lazy.nvim ~/.config/nvim/lazy/lazy.nvim

# Copy this repository into ~/.config/nvim
cp -r ./nvim/.config/nvim/* ~/.config/nvim/

# Language tooling (install only what you need)
pip install --user 'python-lsp-server[all]' debugpy black isort
go install golang.org/x/tools/gopls@latest
# clangd, lua-language-server, stylua, shfmt, yamlfmt, jq via your package manager

# Launch Neovim
nvim

# In Neovim:
:Lazy sync
:TSInstall python go c cpp lua bash json yaml
```
