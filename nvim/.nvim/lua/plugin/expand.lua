-- vim-expand-region - visually select increasingly larger regions
-- https://github.com/terryma/vim-expand-region

-- Keybindings {{{
-----------------------------------------------------------
local map = require("util").keymap
-- Expand on v and shrink on ctrl-v
map("x", "v", "<Plug>(expand_region_expand)", { noremap = false })
map("x", "<c-v>", "<Plug>(expand_region_shrink)", { noremap = false })
-- }}}

-- More expansion boundaries
vim.g.expand_region_text_objects = {
	["iw"] = 0,
	["iW"] = 0,
	['i"'] = 1, -- inside "..."
	["i'"] = 1, -- inside '...'
	["a]"] = 1, -- around []
	["ab"] = 1, -- around ()
	["aB"] = 1, -- around {}
	["i]"] = 1, -- inside []
	["ib"] = 1, -- inside ()
	["iB"] = 1, -- inside {}
	["il"] = 1, -- whole line - available through https://github.com/kana/vim-textobj-line
}
