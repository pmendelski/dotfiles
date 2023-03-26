local _M = {}

function _M.keymap()
	local map = require("util").keymap
	map("n", "<F1>", "<esc>")
	map("n", "<leader>fx", ":Telescope<cr>")
	map("n", "<leader>fr", ":Telescope resume<cr>")
	map("n", "<leader>ff", ":Telescope find_files hidden=true<cr>")
	map("n", "<leader>fF", ':Telescope find_files hidden=true search_dirs={"%:p:h"}<cr>')
	map("n", "<leader>fv", ":Telescope git_files<cr>")
	map("n", "<leader>fb", ":Telescope buffers<cr>")
	map("n", "<leader>fc", ":Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>")
	map("n", "<leader>fC", ":Telescope current_buffer_fuzzy_find fuzzy=false<cr>")
	map("n", "<leader>fg", ":Telescope live_grep_args<cr>")
	map("n", "<leader>fG", ':Telescope live_grep_args hidden=true search_dirs={"%:p:h"}<cr>')
	map("n", "<leader>fp", ":Telescope project<cr>")
	map("n", "<leader>fm", ":Telescope media_files<cr>")
	map("n", "<leader>fh", ":Telescope heading<cr>")
	map("n", "<leader>fk", ":Telescope keymaps<cr>")
	map("n", "<leader>fj", ":Telescope jumplist<cr>")
	map("n", "<leader>fs", ":Telescope spell_suggest<cr>")
	map("n", "<leader>ft", ":Telescope filetypes<cr>")
	map(
		"n",
		"<leader>fs",
		":lua require('telescope.builtin').symbols({ sources = {'emoji', 'kaomoji', 'gitmoji'} })<cr>"
	)
	-- lsp
	map("n", "<leader>c", "") -- added to not trigger a command by mistake
	map("n", "<leader>ct", ":Telescope treesitter<cr>")
	map("n", "<leader>cc", ":Telescope lsp_document_symbols<cr>")
	map("n", "<leader>cC", ":Telescope lsp_dynamic_workspace_symbols<cr>")
	map("n", "<leader>cr", ":Telescope lsp_references<cr>")
	map("n", "<leader>ca", ":Telescope lsp_code_actions<cr>")
	map("n", "<leader>cx", ":Telescope diagnostics<cr>")
	map("n", "<leader>cn", ":Telescope lsp_incomming_calls<cr>")
	map("n", "<leader>co", ":Telescope lsp_outgoing_calls<cr>")
	map("n", "<leader>ci", ":Telescope lsp_implementations<cr>")
	map("n", "<leader>cD", ":Telescope lsp_definitions<cr>")
	-- git
	map("n", "<leader>g", "") -- added to not trigger a command by mistake
	map("n", "<leader>gg", ":Telescope git_bcommits<cr>")
	map("n", "<leader>gc", ":Telescope git_commits<cr>")
	map("n", "<leader>gs", ":Telescope git_status<cr>")
	map("n", "<leader>gb", ":Telescope git_branches<cr>")
	map("n", "<leader>gt", ":Telescope git_stash<cr>")
end

function _M.config()
	local trouble = require("trouble.providers.telescope")
	local actions = require("telescope.actions")
	local telescope = require("telescope")
	local previewers = require("telescope.previewers")

	-- Ignore files bigger than a threshold
	local new_maker = function(filepath, bufnr, opts)
		opts = opts or {}
		filepath = vim.fn.expand(filepath)
		vim.loop.fs_stat(filepath, function(_, stat)
			if not stat then
				return
			end
			if stat.size > 10000000 then
				return
			else
				previewers.buffer_previewer_maker(filepath, bufnr, opts)
			end
		end)
	end

	telescope.setup({
		defaults = {
			buffer_previewer_maker = new_maker,
			mappings = {
				i = {
					["<esc>"] = actions.close,
					["<C-t>"] = trouble.open_with_trouble,
					["<C-Down>"] = actions.cycle_history_next,
					["<C-Up>"] = actions.cycle_history_prev,
					["<C-h>"] = "which_key",
				},
				n = {
					["q"] = actions.close,
					["<C-t>"] = trouble.open_with_trouble,
				},
			},
			vimgrep_arguments = {
				"rg",
				"--hidden",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--trim", -- add this value to remove indentation
			},
		},
		extensions = {
			media_files = {
				-- defaults to {'png', 'jpg', 'mp4', 'webm', 'pdf'}
				filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf" },
				-- defaults to `fd`)
				find_cmd = "rg",
			},
			project = {
				base_dirs = {
					{ "~/Development", max_depth = 4 },
				},
			},
			["ui-select"] = {
				require("telescope.themes").get_dropdown({
					-- even more opts
				}),
			},
		},
		pickers = {
			lsp_document_symbols = {
				symbol_width = 60,
				symbol_type_width = 100,
			},
			live_grep = {
				only_sort_text = true,
			},
		},
	})
	telescope.load_extension("ui-select")
	telescope.load_extension("live_grep_args")
	telescope.load_extension("fzf")
	telescope.load_extension("project")
	telescope.load_extension("media_files")
	telescope.load_extension("heading")
end

return _M
