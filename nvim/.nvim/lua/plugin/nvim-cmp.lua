-- Most of the config taken from:
-- https://github.com/neovim/nvim-lspconfig/wiki/Snippets
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local luasnip = require("luasnip")
local cmp = require("cmp")

-- buffer source that enables buffer word completion for files under 1MB
local buffersrc = {
	name = "buffer",
	option = {
		get_bufnrs = function()
			local buf = vim.api.nvim_get_current_buf()
			local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
			if byte_size > 1024 * 1024 then -- 1 Megabyte max
				return {}
			end
			return { buf }
		end,
	},
}

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	-- preselect = cmp.PreselectMode.None,
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
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
				luasnip = "[Snip]",
				path = "[Path]",
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
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.mapping.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		-- ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({
		--   behavior = cmp.SelectBehavior.Select
		-- }), { 'i', 'c' }),
		-- ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({
		--   behavior = cmp.SelectBehavior.Select
		-- }), { 'i', 'c' }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "path" },
		{ name = "luasnip" },
	}, { buffersrc }),
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
		buffersrc,
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		buffersrc,
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
