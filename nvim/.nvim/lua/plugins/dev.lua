return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "~/.dotfiles",
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { "folke/neodev.nvim", enabled = false },
}
