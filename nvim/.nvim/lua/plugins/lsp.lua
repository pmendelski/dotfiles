return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- gI - uppercase "I" is inconvenient, but leave it to stay compatible with LazyVim
          {
            "gi",
            function()
              Snacks.picker.lsp_implementations()
            end,
            desc = "Goto Implementation",
          },
        },
      },
    },
  },
}
