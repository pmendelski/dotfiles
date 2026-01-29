return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      setup = {
        ["*"] = function(_, opts)
          local on_attach = opts.on_attach
          opts.on_attach = function(client, bufnr)
            if on_attach then
              on_attach(client, bufnr)
            end
            -- WYŁĄCZAMY Semantic Tokens, zostawiamy podświetlanie tylko dla Treesittera
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      },
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
