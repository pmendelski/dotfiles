local _M = {}

function _M.keymap(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function _M.execute(cmd, raw)
	local f = assert(io.popen(cmd, "r"))
	local s = assert(f:read("*a"))
	f:close()
	if raw then
		return s
	end
	s = string.gsub(s, "^%s+", "")
	s = string.gsub(s, "%s+$", "")
	s = string.gsub(s, "[\n\r]+", " ")
	return s
end

function _M.contains(list, x)
	for _, v in pairs(list) do
		if v == x then
			return true
		end
	end
	return false
end

function _M.get_buf_lsp_clients()
	local buf_clients = vim.lsp.buf_get_clients()
	if next(buf_clients) == nil then
		return {}
	end
	local clients = {}
	for _, client in pairs(buf_clients) do
		if client.name ~= "null-ls" then
			table.insert(clients, client.name)
		end
	end
	return clients
end

return _M
