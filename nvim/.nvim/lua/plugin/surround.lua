require("nvim-surround").setup({
	keymaps = {
		insert = "<C-g>s",
		insert_line = "<C-g>S",
		normal = "ys",
		normal_cur = "yss",
		normal_line = "yS",
		normal_cur_line = "ySS",
		visual = "S",
		visual_line = "gS",
		delete = "ds",
		change = "cs",
	},
})

local map = require("util").keymap
local opts = { noremap = false }
map("n", '<leader>s"', 'ysiw"', opts)
map("n", "<leader>s'", "ysiw'", opts)
map("n", "<leader>s`", "ysiw`", opts)
map("n", "<leader>s(", "ysiw(", opts)
map("n", "<leader>s)", "ysiw)", opts)
map("n", "<leader>s[", "ysiw]", opts)
map("n", "<leader>s]", "ysiw]", opts)
map("n", "<leader>s<", "ysiw>", opts)
map("n", "<leader>s>", "ysiw>", opts)
map("n", "<leader>s{", "ysiw}", opts)
map("n", "<leader>s}", "ysiw}", opts)

map("x", '<leader>s"', 'ysiw"', opts)
map("x", "<leader>s'", "ysiw'", opts)
map("x", "<leader>s`", "ysiw`", opts)
map("x", "<leader>s(", "ysiw(", opts)
map("x", "<leader>s)", "ysiw)", opts)
map("x", "<leader>s[", "ysiw]", opts)
map("x", "<leader>s]", "ysiw]", opts)
map("x", "<leader>s<", "ysiw>", opts)
map("x", "<leader>s>", "ysiw>", opts)
map("x", "<leader>s{", "ysiw}", opts)
map("x", "<leader>s}", "ysiw}", opts)
