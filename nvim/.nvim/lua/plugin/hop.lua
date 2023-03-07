local hop = require("hop")
local map = require("util").keymap
hop.setup({})

local directions = require("hop.hint").HintDirection
vim.keymap.set("n", "f", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("n", "F", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true })
vim.keymap.set("n", "t", function()
	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true })
vim.keymap.set("n", "T", function()
	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true })

-- Leader based mapping
map("n", "<leader>hw", "<cmd>HopWord<cr>")
map("n", "<leader>hl", "<cmd>HopLineStart<cr>")
map("n", "<leader>h/", "<cmd>HopPattern<cr>")
map("n", "<leader>hb", "<cmd>HopChar2<cr>")
map(
	"n",
	"<leader>hB",
	"<cmd>lua require('hop').hint_char2({"
		.. "direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true"
		.. " })<cr>",
	{}
)
map("n", "<leader>hh", "<cmd>HopChar1<cr>")
map(
	"n",
	"<leader>hH",
	"<cmd>lua require('hop').hint_char1({"
		.. "direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true"
		.. " })<cr>",
	{}
)
