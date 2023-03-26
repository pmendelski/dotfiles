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
	map("n", "<leader>z", ":TZAtaraxis<cr>")
end

return _M
