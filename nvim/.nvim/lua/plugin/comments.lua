require("kommentary.config").configure_language("default", {
	prefer_single_line_comments = true,
	use_consistent_indentation = true,
	ignore_whitespace = true,
})

-- Keybindings
-------------------------
local map = require("util").keymap
-- closing buffers
vim.g.kommentary_create_default_mappings = false
map("n", "<c-_>", "<Plug>kommentary_line_default")
map("i", "<c-_>", "<esc><Plug>kommentary_line_default<cr>i")
map("x", "<c-_>", "<Plug>kommentary_visual_default")
