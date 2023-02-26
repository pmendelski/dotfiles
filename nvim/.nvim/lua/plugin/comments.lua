local config = require("kommentary.config")
config.configure_language("default", {
	prefer_single_line_comments = true,
	use_consistent_indentation = true,
	ignore_whitespace = true,
})

local hashComments = {
	single_line_comment_string = "#",
	multi_line_comment_strings = false,
	prefer_single_line_comments = true,
	use_consistent_indentation = true,
	ignore_whitespace = true,
}
config.configure_language("makefile", hashComments)
config.configure_language("dockerfile", hashComments)
config.configure_language("vim", hashComments)

-- Keybindings
-------------------------
local map = require("util").keymap
-- closing buffers
vim.g.kommentary_create_default_mappings = false
map("n", "<c-_>", "<Plug>kommentary_line_default")
map("i", "<c-_>", "<esc><Plug>kommentary_line_default<cr>i")
map("x", "<c-_>", "<Plug>kommentary_visual_default")
-- to have the same mapping in vim and nvim
map("n", "gcc", "<Plug>kommentary_line_default")
map("n", "gc", "<Plug>kommentary_motion_default")
map("v", "gc", "<Plug>kommentary_visual_default<C-c>")
