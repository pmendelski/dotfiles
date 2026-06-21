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
        ["*"] = {
          keys = {
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
        gopls = {
          settings = {
            gopls = {
              ["local"] = goModuleName(),
              analyses = {
                ST1000 = false,
                ST1003 = false,
              },
            },
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
        taplo = {
          settings = {
            root_dir = { ".git", "*.toml" },
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tree-sitter-cli" })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = true,
    },
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      config = function(_, opts)
        vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      end,
      server = {
        -- Resolve via `rustup` so the toolchain pinned in rust-toolchain.toml
        -- (and its bundled rust-analyzer) is used instead of whatever
        -- `rust-analyzer` happens to be first on PATH.
        cmd = function()
          local toolchain_bin = vim.trim(vim.fn.system("rustup which rust-analyzer 2>/dev/null"))
          local bin = "rust-analyzer"
          if vim.v.shell_error == 0 and vim.fn.executable(toolchain_bin) == 1 then
            bin = toolchain_bin
          end
          local config = require("rustaceanvim.config.internal")
          return { bin, "--log-file", config.server.logfile }
        end,
        settings = {
          ["rust-analyzer"] = {
            files = {
              watcher = "server",
            },
            rustfmt = {
              overrideCommand = { "rustup", "run", "nightly", "rustfmt", "--edition", "2024" },
            },
            procMacro = {
              enable = true,
              attributes = { enable = true },
            },
          },
        },
      },
    },
  },
}
