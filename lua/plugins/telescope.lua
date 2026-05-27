return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local symbols = require("telescope.builtin")
    local entry_display = require("telescope.pickers.entry_display")
    local devicons = require("nvim-web-devicons")

    local kind_icons = {
      Class = "",
      Function = "",
      Method = "",
      Variable = "",
      Field = "",
      Interface = "",
      Module = "",
      Property = "",
      Constant = "",
    }

    telescope.setup({
      defaults = {
        file_ignore_patterns = { "cooked", "kernel", ".git/", "build", "__pycache__", "gui" },
        path_display = { "filename_first" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = { width = 0.95, height = 0.9, preview_width = 0.5 },
        },
        dynamic_preview_title = true,
        mappings = {
          i = {
            -- 插入模式下 Esc 和 Ctrl-c 都关闭
            ["<esc>"] = require('telescope.actions').close,
            ["<C-c>"] = require('telescope.actions').close,
          },
          n = {
            -- 普通模式下 q 和 Esc 关闭
            ["q"]      = require('telescope.actions').close,
            ["<esc>"] = require('telescope.actions').close,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
      pickers = {
        lsp_dynamic_workspace_symbols = {
          fname_width = 60,
          symbol_width = 40,
        },
        lsp_workspace_symbols = {
          fname_width = 60,
          symbol_width = 40,
        },
        lsp_document_symbols = {
          entry_maker = function(entry)
            local displayer = entry_display.create({
              separator = " ",
              items = {
                { width = 2 },   -- icon
                { width = 12 },  -- kind
                { width = 30 },  -- symbol name
                { remaining = true },  -- filename + line
              },
            })

            local kind = entry.kind or "Unknown"
            local icon = kind_icons[kind] or ""

            local filename = vim.fn.fnamemodify(entry.filename or "", ":t")
            local location = string.format("%s:%d", filename, entry.lnum or 0)

            return {
              value = entry,
              ordinal = entry.name,
              display = function()
                return displayer({
                  icon,
                  string.format("[%s]", kind),
                  entry.name,
                  location,
                })
              end,
              filename = entry.filename,
              lnum = entry.lnum,
              col = entry.col,
            }
          end,
        },
      },
    })

    require("telescope").load_extension("fzf")
    require("telescope").load_extension("aerial")
  end,
}


