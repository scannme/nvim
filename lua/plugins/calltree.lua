return {
  "ldelossa/litee-calltree.nvim",
  dependencies = { "ldelossa/litee.nvim" },
  event = "LspAttach",
  init = function()
    local orig = vim.api.nvim_buf_set_extmark
    vim.api.nvim_buf_set_extmark = function(buf, ns, row, col, opts)
      local ok, ret = pcall(orig, buf, ns, row, col, opts)
      if ok then return ret end
      opts = opts or {}
      opts.strict = false
      return orig(buf, ns, row, col, opts)
    end
  end,
  config = function()
    require("litee.lib").setup({
      tree = { icon_set = "default" },
      panel = {
        orientation = "right",
        panel_size  = 45,
      },
    })
    require("litee.calltree").setup({
      on_open = "panel",
      map_resize_keys = false,
      hide_cursor = false,
      keymaps = {
        expand              = "e",
        collapse            = "c",
        collapse_all        = "C",
        jump                = "<CR>",
        jump_split          = "s",
        jump_vsplit         = "v",
        jump_tab            = "t",
        hover               = "i",
        details             = "d",
        close               = "q",
        close_panel_pop_out = "<Esc>",
        help                = "?",
        hide                = "H",
        switch              = "S",
        focus               = "f",
      },
    })
  end,
}
