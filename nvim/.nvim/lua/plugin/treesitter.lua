require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"bash",
		"clojure",
		"c",
		"cpp",
		"dockerfile",
		"go",
		"graphql",
		"html",
		"java",
		"javascript",
		"json",
		"json5",
		"kotlin",
		"latex",
		"lua",
		"php",
		"python",
		"rust",
		"ruby",
		"scala",
		"scss",
		"svelte",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vue",
		"yaml",
	},
	autopairs = { enable = true },
	highlight = {
		enable = true,
		-- required for spell check
		additional_vim_regex_highlighting = true,
	},
	matchup = { enable = true },
	indent = { enable = true },
	autotag = { enable = true },
})

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext =
	[[ substitute(getline(v:foldstart) , '\t' , repeat('\ ',&tabstop), 'g') . '...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines) ' ]]
vim.opt.foldlevel = 999
