require("indent_blankline").setup({
	char = "|",
	buftype_exclude = { "terminal", "dashboard", "help", "lspinfo", "lspsaga", "NvimTree" },
	filetype_exclude = { "help", "dashboard", "packer" },
	show_trailing_blankline_indent = false,
	show_first_indent_level = false,
})
