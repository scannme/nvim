return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "python", "go", "gomod", "gosum", "c", "cpp", "lua", "vim", "vimdoc",
        "bash", "json", "yaml", "toml", "markdown", "markdown_inline", "java",
        -- 前端：tsx 管 .tsx，typescript 管 .ts，两个都要。
        "javascript", "typescript", "tsx", "jsdoc",
        -- rainbow 满地都是 *.module.scss / *.module.css，没有 parser 就是纯白文本。
        -- graphql 同理（仓库里有 schema.gql 和一堆 .graphql）。
        "css", "scss", "html", "graphql",
      },
      highlight = { enable = true },
      indent    = { enable = true },

      playground = {
        enable = true,
        persist_queries = false,
      },
    },
  },
}
