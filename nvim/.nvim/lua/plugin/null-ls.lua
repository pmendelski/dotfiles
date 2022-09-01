local null_ls = require("null-ls")
local sources = require('null-ls/sources')
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local FORMATTING = null_ls.methods.FORMATTING


local M = {}

function M.config()
  null_ls.setup({
    sources = {
      -- formatting
      formatting.stylua,
      formatting.shfmt,
      formatting.prettier.with({
        filetypes = { "html", "css", "markdown", "json" },
      }),
      -- diagnostics
      diagnostics.shellcheck.with({
        method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
      }),
      -- code actions
      code_actions.shellcheck
    }
  })
end

function M.configure_client(client, buf)
  local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
  if M.has_formatter(filetype) then
    local enabled = client.name == "null-ls"
    client.server_capabilities.documentFormattingProvider = enabled
  end
end

function M.has_formatter(filetype)
  local available = sources.get_available(filetype, FORMATTING)
  return #available > 0
end

function M.list_registered_providers(filetype)
  local available_sources = sources.get_available(filetype)
  local registered = {}
  for _, source in ipairs(available_sources) do
    table.insert(registered, source.name)
  end
  return registered
end

return M
