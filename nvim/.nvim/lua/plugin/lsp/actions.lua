local go = require("plugin/lsp/lang/go")
local _M = {}

function _M.format()
	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	if ft == "go" then
		go.organizeImports()
	end
	vim.lsp.buf.format({
		timeout_ms = 2000,
	})
end

return _M
