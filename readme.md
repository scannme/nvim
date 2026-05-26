# 🧠 Neovim Python Dev Environment

A modern Python development setup using **lazy.nvim**, packed with LSP, autocompletion, formatting, debugging, file browsing, and Git integration.

## 📦 Plugins Used

| Plugin                          | Purpose                                |
|---------------------------------|----------------------------------------|
| `lazy.nvim`                     | Plugin manager                         |
| `nvim-lspconfig`                | LSP support (Python: `pylsp`)          |
| `nvim-cmp`, `cmp-nvim-lsp`      | Autocompletion                         |
| `LuaSnip`, `cmp_luasnip`        | Snippet engine                         |
| `nvim-treesitter`               | Syntax highlighting                    |
| `nvim-dap`, `nvim-dap-ui`       | Debugging interface                    |
| `nvim-dap-virtual-text`         | Show variable values inline            |
| `conform.nvim`                  | Autoformatter (Black, isort)           |
| `venv-selector.nvim`           | Python virtualenv switcher             |
| `telescope.nvim`                | Fuzzy file and content search          |
| `nvim-tree.lua`                 | File explorer                          |
| `toggleterm.nvim`              | Built-in terminal toggler              |
| `gitsigns.nvim`                | Git hunk signs                         |
| `lualine.nvim`                  | Statusline                             |
| `which-key.nvim`               | Show available keybindings             |
| `tokyonight.nvim`              | Colorscheme (default)                  |

---

## 🎹 Keybindings

### 📄 General

| Key             | Action                  |
|----------------|--------------------------|
| `<Leader>w`     | Save file                |
| `<Leader>q`     | Quit                     |
| `<C-h/j/k/l>`   | Window navigation        |
| `<S-h>/<S-l>`   | Buffer navigation        |

### 🗂 File Management & Search

| Key             | Action                  |
|----------------|--------------------------|
| `<Leader>e`     | Toggle file explorer     |
| `<Leader>ff`    | Find files               |
| `<Leader>fg`    | Grep in files            |
| `<Leader>fb`    | Find buffers             |
| `<Leader>fh`    | Help tags                |

### 🐞 Debugging (DAP)

| Key             | Action                    |
|----------------|----------------------------|
| `F5`            | Start/continue             |
| `F10`           | Step over                  |
| `F11`           | Step into                  |
| `F12`           | Step out                   |
| `<Leader>b`     | Toggle breakpoint          |
| `<Leader>B`     | Conditional breakpoint     |
| `<Leader>dr`    | Open REPL                  |
| `<Leader>dl`    | Run last debug session     |

### 💻 Terminal

| Key             | Action                    |
|----------------|----------------------------|
| `<Leader>t`     | Toggle terminal            |

### 🌿 Git Integration

| Key             | Action                    |
|----------------|----------------------------|
| `[g`/`]g`       | Prev/next hunk             |
| `<Leader>gs`    | Stage hunk                 |
| `<Leader>gu`    | Undo stage hunk            |
| `<Leader>gr`    | Reset hunk                 |

---

## 🚀 Setup Instructions

```bash
# Clone lazy.nvim if not already installed
git clone https://github.com/folke/lazy.nvim ~/.config/nvim/lazy/lazy.nvim

# Copy this repository into ~/.config/nvim
cp -r ./nvim/.config/nvim/* ~/.config/nvim/

# Install Python tools
pip install --user 'python-lsp-server[all]' debugpy black isort

# Launch Neovim
nvim

# In Neovim:
:Lazy sync
:TSInstall python

