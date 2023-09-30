local _M = {}

function _M.keymap(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
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

function _M.get_max_win()
	local wins = vim.api.nvim_tabpage_list_wins(0)
	local maxWin = -1
	local maxArea = -1
	for _, win in ipairs(wins) do
		local height = vim.api.nvim_win_get_height(win)
		local width = vim.api.nvim_win_get_width(win)
		local area = height * width
		if area > maxArea then
			maxArea = area
			maxWin = win
		end
	end
	return maxWin
end

function _M.set_current_win_max()
	local maxWin = _M.get_max_win()
	if maxWin > 0 then
		vim.api.nvim_set_current_win(maxWin)
	end
end

return _M
