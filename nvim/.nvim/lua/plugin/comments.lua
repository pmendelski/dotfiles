local config = require("kommentary.config")

config.configure_language("default", {
	prefer_single_line_comments = true,
	use_consistent_indentation = true,
	ignore_whitespace = true,
})

local baseConfig = {
	multi_line_comment_strings = false,
	prefer_single_line_comments = true,
	use_consistent_indentation = true,
	ignore_whitespace = true,
}

local hashComments = vim.tbl_extend("force", baseConfig, {
	single_line_comment_string = "#",
})

local quoteComments = vim.tbl_extend("force", baseConfig, {
	single_line_comment_string = '"',
})

local htmlComments = vim.tbl_extend("force", baseConfig, {
	prefer_single_line_comments = false,
	prefer_multi_line_comments = true,
	multi_line_comment_strings = { "<!--", "-->" },
})

config.configure_language("conf", hashComments)
config.configure_language("makefile", hashComments)
config.configure_language("make", hashComments)
config.configure_language("dockerfile", hashComments)
config.configure_language("yaml", hashComments)
config.configure_language("tmux", hashComments)
config.configure_language("sh", hashComments)
config.configure_language("bash", hashComments)
config.configure_language("zsh", hashComments)
config.configure_language("vim", quoteComments)
config.configure_language("template", htmlComments)

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
