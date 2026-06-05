return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          done_ttl = 2,
          progress_icon = { pattern = "dots", period = 1 },
        },
      },
      notification = {
        window = { winblend = 0 },
      },
    },
  },
}
