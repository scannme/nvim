return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = { "python", "go", "gomod", "gosum", "c", "cpp", "lua", "vim", "vimdoc", "bash", "json", "yaml", "toml", "markdown" },
      highlight = { enable = true },
      indent    = { enable = true },

      playground = {
        enable = true,
        persist_queries = false,
      },
    },
  },
}
