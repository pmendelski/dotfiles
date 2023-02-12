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
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(_, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,
		-- required for spell check
		-- additional_vim_regex_highlighting = true,
	},
	matchup = { enable = true },
	indent = { enable = true },
	autotag = { enable = true },
})

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = [[
  substitute(getline(v:foldstart) , '\t' , repeat('\ ',&tabstop), 'g')
    . '...'.trim(getline(v:foldend))
    . ' (' . (v:foldend - v:foldstart + 1) . ' lines) '
]]
vim.opt.foldlevel = 999

-- Use it to debug syntax glitches
-- Source: https://neovim.discourse.group/t/underscores-highlighted-in-signature-help/306/3
-- vim.api.nvim_exec(
-- 	[[
--   function! SynStack ()
--     for i1 in synstack(line("."), col("."))
--         let i2 = synIDtrans(i1)
--         let n1 = synIDattr(i1, "name")
--         let n2 = synIDattr(i2, "name")
--         echo n1 "->" n2
--      endfor
--    endfunction
--    map gm :call SynStack()<CR>
-- ]],
-- 	false
-- )
