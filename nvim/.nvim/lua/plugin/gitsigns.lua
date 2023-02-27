require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		map("n", "[c", function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { expr = true })

		-- Actions
		map({ "n", "v" }, "<leader>Gs", ":Gitsigns stage_hunk<CR>")
		map({ "n", "v" }, "<leader>Gr", ":Gitsigns reset_hunk<CR>")
		map("n", "<leader>GS", gs.stage_buffer)
		map("n", "<leader>Gu", gs.undo_stage_hunk)
		map("n", "<leader>GR", gs.reset_buffer)
		map("n", "<leader>gp", gs.preview_hunk)
		map("n", "<leader>gB", function()
			gs.blame_line({ full = true })
		end)
		map("n", "<leader>gb", gs.toggle_current_line_blame)
		-- map('n', '<leader>hd', gs.diffthis)
		-- map('n', '<leader>hD', function() gs.diffthis('~') end)
		-- map('n', '<leader>td', gs.toggle_deleted)
		-- Text object
		-- map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end,
})
