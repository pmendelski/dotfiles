local _M = {}

function _M.config()
	local true_zen = require("true-zen")
	true_zen.setup({
		integrations = {
			lualine = true,
		},
	})
end

function _M.keymap()
	local map = require("util").keymap
	map("n", "<F12>", ":TZAtaraxis<cr>")
	map("i", "<F12>", ":TZAtaraxis<cr>")
	map("v", "<F12>", ":'<,'>TZNarrow<CR>")
end

return _M
