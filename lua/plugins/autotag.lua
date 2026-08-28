return {
  {
    -- JSX/TSX 标签自动闭合，改开标签时同步改闭标签（反过来也一样）。
    -- 靠 treesitter 判断上下文，所以 <T> 泛型、字符串里的尖括号不会被误伤。
    "windwp/nvim-ts-autotag",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
      "html", "xml", "javascript", "javascriptreact", "typescript", "typescriptreact",
      "markdown", "svelte", "vue", "php",
    },
    opts = {
      opts = {
        enable_close          = true,  -- 打完 <div> 自动补 </div>
        enable_rename         = true,  -- 改 <div> → <section>，闭标签跟着改
        enable_close_on_slash = false, -- 打 </ 不自动补全；跟 autopairs 一起用容易打架
      },
    },
  },
}
