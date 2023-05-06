local dcolors = require("tokyonight.colors").default

require("tokyonight").setup({
	on_highlights = function(hl, c)
		local bg = c.bg
		local prompt_bg = "#2d3149"
		local preview_bg = dcolors.bg
		hl.TelescopeNormal = {
			bg = bg,
			fg = c.fg_dark,
		}
		hl.TelescopeBorder = {
			bg = bg,
			fg = bg,
		}
		-- Prompt (text field)
		hl.TelescopePromptNormal = {
			bg = prompt_bg,
		}
		hl.TelescopePromptBorder = {
			bg = prompt_bg,
			fg = prompt_bg,
		}
		hl.TelescopePromptTitle = {
			bg = prompt_bg,
			fg = c.comment,
		}
		-- Results (left column)
		hl.TelescopeResultsTitle = {
			bg = bg,
			fg = bg,
		}
		-- Preview (right column)
		hl.TelescopePreviewNormal = {
			bg = preview_bg,
		}
		hl.TelescopePreviewBorder = {
			bg = preview_bg,
			fg = preview_bg,
		}
		hl.TelescopePreviewTitle = {
			fg = c.comment,
		}
		-- Selection
		-- hl.TelescopeSelection = { fg = c.magenta_dark, bg = bg_dark }
		-- hl.TelescopeSelectionCaret = { fg = c.magenta }
		-- Floats (terminal!)
		-- hl.Normal = { bg = c.magenta, fg = c.blue }
		-- hl.FloatBorder = { bg = preview_bg }
	end,
})

-- vim.cmd("colorscheme tokyonight")
vim.cmd("colorscheme tokyonight-night")

-- Color names:
-- bg_dark = "#1f2335",
-- bg = "#24283b",
-- bg_highlight = "#292e42",
-- terminal_black = "#414868",
-- fg = "#c0caf5",
-- fg_dark = "#a9b1d6",
-- fg_gutter = "#3b4261",
-- dark3 = "#545c7e",
-- comment = "#565f89",
-- dark5 = "#737aa2",
-- blue0 = "#3d59a1",
-- blue = "#7aa2f7",
-- cyan = "#7dcfff",
-- blue1 = "#2ac3de",
-- blue2 = "#0db9d7",
-- blue5 = "#89ddff",
-- blue6 = "#b4f9f8",
-- blue7 = "#394b70",
-- magenta = "#bb9af7",
-- magenta2 = "#ff007c",
-- purple = "#9d7cd8",
-- orange = "#ff9e64",
-- yellow = "#e0af68",
-- green = "#9ece6a",
-- green1 = "#73daca",
-- green2 = "#41a6b5",
-- teal = "#1abc9c",
-- red = "#f7768e",
-- red1 = "#db4b4b",
-- git = { change = "#6183bb", add = "#449dab", delete = "#914c54" },
-- gitSigns = {
--   add = "#266d6a",
--   change = "#536c9e",
--   delete = "#b2555b",
-- },
