return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
    fast_wrap = {},
  },
  config = function(_, opts)
    local ap = require("nvim-autopairs")
    ap.setup(opts)
    -- Integrate with nvim-cmp so Enter accepts completion and inserts pair
    local ok, cmp = pcall(require, "cmp")
    if ok then
      local cmp_ap = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
    end
  end,
}
