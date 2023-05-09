local _M = {}

function _M.config()
	local on_attach = require("plugin/tree/on-attach")
	local tree = require("nvim-tree")
	tree.setup({
		auto_reload_on_write = true,
		-- Completely disable netrw
		disable_netrw = false,
		-- Hijack netrw window on startup
		hijack_netrw = true,
		-- hijack the cursor in the tree to put it at the start of the filename
		hijack_cursor = true,
		-- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
		update_cwd = true,
		-- Hide .git directory
		filters = { custom = { "^.git$" } },
		on_attach = on_attach,
		view = {
			width = 30,
		},
		update_focused_file = {
			enable = true,
			update_cwd = false,
		},
		diagnostics = {
			enable = true,
			icons = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			},
		},
		renderer = {
			root_folder_label = function(path)
				return vim.fs.basename(path)
			end,
			highlight_git = true,
			special_files = {},
			-- git_placement = "after",
			icons = {
				glyphs = {
					default = "",
					symlink = "",
					git = {
						-- unstaged = '✗',
						unstaged = "+",
						-- staged = '✓',
						staged = "",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						-- untracked = "*",
						deleted = "",
						-- ignored = '◌'
						ignored = "",
					},
					folder = {
						arrow_open = "",
						arrow_closed = "",
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
						symlink_open = "",
					},
				},
			},
		},
		git = {
			ignore = false,
		},
		actions = {
			open_file = {
				window_picker = {
					exclude = {
						["filetype"] = { "notify", "packer", "qf", "Outline" },
						["buftype"] = { "terminal" },
					},
				},
			},
		},
	})

	-- Auto open
	local function open_nvim_tree(data)
		-- buffer is a directory
		local directory = vim.fn.isdirectory(data.file) == 1
		if not directory then
			return
		end
		-- change to the directory
		vim.cmd.cd(data.file)
		-- open the tree
		require("nvim-tree.api").tree.open()
	end
	vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

	-- Keybindings
	local map = require("util").keymap
	map("n", "<F2>", ":NvimTreeToggle<cr>")
	map("n", "<F3>", ":NvimTreeFindFile<cr>:NvimTreeRefresh<cr>:NvimTreeFocus<cr>")
	map("i", "<F2>", "<esc>:NvimTreeToggle<cr>")
	map("i", "<F3>", "<esc>:NvimTreeFindFile<cr>:NvimTreeRefresh<cr>:NvimTreeFocus<cr>")
	map("x", "<F2>", "<esc>:NvimTreeToggle<cr>")
	map("x", "<F3>", "<esc>:NvimTreeFindFile<cr>:NvimTreeRefresh<cr>:NvimTreeFocus<cr>")
end

return _M
