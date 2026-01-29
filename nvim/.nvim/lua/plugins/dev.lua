return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- ładuj tylko dla plików lua
    opts = {
      library = {
        -- Załaduj typy dla pluginów (np. "lazy.nvim")
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
}
