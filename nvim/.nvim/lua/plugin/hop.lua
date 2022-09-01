require("hop").setup({})
local map = require("util").keymap
map("n", "<leader>hw", "<cmd>HopWord<CR>")
map("n", "<leader>hl", "<cmd>HopLine<CR>")
map("n", "<leader>h/", "<cmd>HopPattern<CR>")
map(
	"n",
	"h",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
	{}
)
map(
	"n",
	"H",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>",
	{}
)
