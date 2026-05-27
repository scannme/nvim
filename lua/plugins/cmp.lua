return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "L3MON4D3/LuaSnip",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
        },
      },
      snippets = { preset = "luasnip" },
      sources = {
        -- After `.` / `->` / `::` only ask LSP — buffer / snippets
        -- would otherwise pollute member completions with random words.
        default = function()
          local col  = vim.api.nvim_win_get_cursor(0)[2]
          local line = vim.api.nvim_get_current_line()
          local before = line:sub(1, col)
          if before:match("[%w_%)%]]%s*%.[%w_]*$")
            or before:match("->[%w_]*$")
            or before:match("::[%w_]*$") then
            return { "lsp" }
          end
          return { "lsp", "snippets", "path", "buffer" }
        end,
        providers = {
          lsp      = { score_offset = 10 },
          snippets = { score_offset = -3 },
          path     = { score_offset = -2 },
          buffer   = {
            score_offset = -10,
            min_keyword_length = 3,
          },
        },
      },
    },
  },
}
