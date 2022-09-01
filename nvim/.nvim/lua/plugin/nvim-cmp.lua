-- Most of the config taken from: https://github.com/neovim/nvim-lspconfig/wiki/Snippets
local cmp = require("cmp")

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[Lsp]",
				vsnip = "[Snip]",
				path = "[Path]",
				calc = "[Calc]",
			})[entry.source.name]
			return vim_item
		end,
	},
	mapping = {
		["<c-p>"] = cmp.mapping.select_prev_item(),
		["<c-n>"] = cmp.mapping.select_next_item(),
		["<c-d>"] = cmp.mapping.scroll_docs(-4),
		["<c-f>"] = cmp.mapping.scroll_docs(4),
		["<c-Space>"] = cmp.mapping.complete(),
		["<c-e>"] = cmp.mapping.close(),
		["<cr>"] = cmp.mapping.confirm({
			-- behavior = cmp.ConfirmBehavior.Replace,
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#available"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			else
				fallback()
			end
		end,
		-- ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({
		--   behavior = cmp.SelectBehavior.Select
		-- }), { 'i', 'c' }),
		-- ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({
		--   behavior = cmp.SelectBehavior.Select
		-- }), { 'i', 'c' }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		-- { name = 'buffer' },
		{ name = "path" },
		{ name = "vsnip" },
	}),
})

-- Lazy load rust crates completions
vim.api.nvim_exec(
	[[
autocmd FileType toml lua require('cmp').setup.buffer({ sources = { { name = 'crates' } } })
]],
	false
)

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = cmp.config.sources({
		{ name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
