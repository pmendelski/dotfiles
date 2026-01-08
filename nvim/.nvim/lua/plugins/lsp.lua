return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ["*"] = {
        keys = {
          -- gI - uppercase "I" is inconvenient, but leave it to stay compatible with LazyVim
          { "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
        },
      },
    },
  },
}
