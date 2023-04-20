local go = require("plugin/lsp/lang/go")
local _M = {}

function _M.format()
	local buf = vim.api.nvim_get_current_buf()
	local ft = vim.api.nvim_buf_get_option(buf, "filetype")
	if ft == "go" then
		go.organizeImports()
	end
	vim.lsp.buf.format({
		timeout_ms = 2000,
	})
end

return _M
