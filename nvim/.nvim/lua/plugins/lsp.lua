return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
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
        bashls = {},
        gopls = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Enforce installing tree-sitter-cli for faster treesitter
      vim.list_extend(opts.ensure_installed, {
        "tree-sitter-cli",
      })
    end,
  },
}
