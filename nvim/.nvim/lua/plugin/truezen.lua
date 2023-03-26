local _M = {}

function _M.config()
	local true_zen = require("true-zen")
	true_zen.setup({
		integrations = {
			lualine = true,
		},
	})
	vim.cmd(':command Zen :lua require("plugin/truezen").toggle()<cr>')
end

function _M.toggle()
	require("true-zen").ataraxis()
	if require("true-zen.ataraxis").running then
		vim.o.showtabline = 0
	else
		vim.o.showtabline = 2
	end
end

function _M.keymap()
	local map = require("util").keymap
	map("n", "<leader>z", ":Zen<cr>")
end

return _M
