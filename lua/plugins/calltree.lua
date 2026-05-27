return {
  "ldelossa/litee-calltree.nvim",
  dependencies = { "ldelossa/litee.nvim" },
  event = "LspAttach",
  config = function()
    require("litee.lib").setup({
      tree = { icon_set = "default" },
      panel = {
        orientation = "left",
        panel_size = 40,
      },
    })
    require("litee.calltree").setup({
      on_open = "panel",
      map_resize_keys = false,
      hide_cursor = false,
    })
  end,
}
