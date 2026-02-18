-- Get the value of the module name from go.mod in PWD
local goModuleName = function()
  local f = io.open("go.mod", "rb")
  if f then
    f:close()
  else
    return nil
  end
  for line in io.lines("go.mod") do
    if vim.startswith(line, "module") then
      local items = vim.split(line, " ")
      return vim.trim(items[2])
    end
  end
  return nil
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        bashls = {},
        gopls = {
          settings = {
            ["local"] = goModuleName(),
          },
        },
        yamlls = {
          settings = {
            yaml = {
              -- Enable built-in schema support
              schemaStore = { enable = true, enableCustomLabels = true },
              schemas = {
                -- Explicitly map Kubernetes and GitHub Actions
                kubernetes = "*.yaml",
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                ["https://json.schemastore.org/github-action.json"] = "/.github/action.{yml,yaml}",
              },
            },
          },
        },
      },
      setup = {
        ["*"] = function(_, opts)
          opts.keys = opts.keys or {}
          vim.list_extend(opts.keys, {
            {
              "gi",
              function()
                Snacks.picker.lsp_implementations()
              end,
              desc = "Goto Implementation",
            },
          })
        end,
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tree-sitter-cli" })
      opts.automatic_installation = true
    end,
  },
}
