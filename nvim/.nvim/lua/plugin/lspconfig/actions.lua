local go = require("plugin/lspconfig/lang/go")
local util = require("util")
local _M = {}

function _M.format()
	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = util.get_buf_lsp_clients()
	if ft == "go" then
		go.organizeImports()
	elseif util.contains(clients, "eslint") then
		vim.cmd("EslintFixAll")
	end
	vim.lsp.buf.format({
		timeout_ms = 2000,
	})
end

return _M
