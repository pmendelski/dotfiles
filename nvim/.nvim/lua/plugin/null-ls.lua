local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local FORMATTING = null_ls.methods.FORMATTING

local M = {}

function M.config()
	null_ls.setup({
		sources = {
			-- formatting
			formatting.stylua,
			formatting.shfmt,
			formatting.prettier.with({ disabled_filetypes = { "yaml" }, extra_filetypes = { "toml" } }),
			-- liting
			diagnostics.golangci_lint,
			diagnostics.hadolint,
			diagnostics.yamllint.with({ extra_args = { "-d", "{extends: relaxed, rules: {line-length: {max: 120}}}" } }),
			diagnostics.zsh,
		},
	})
end

function M.configure_client(client, buf)
	local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
	if client.server_capabilities.documentFormattingProvider == false and M.has_formatter(filetype) then
		local enabled = client.name == "null-ls"
		client.server_capabilities.documentFormattingProvider = enabled
	end
end

function M.has_formatter(filetype)
	for _, source in pairs(null_ls.get_sources()) do
		if source.filetypes[filetype] == true and source.methods[FORMATTING] == true then
			return true
		end
	end
	return false
end

function M.list_registered_providers(filetype)
	local registered = {}
	for _, source in pairs(null_ls.get_sources()) do
		if source.filetypes[filetype] == true then
			table.insert(registered, source.name)
		end
	end
	return registered
end

return M
