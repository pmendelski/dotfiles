local _M = {}

function _M.config()
	local function tree_action(callback_name)
		return string.format(':lua require("nvim-tree").%s<cr>', callback_name)
	end

	local function telescope_action(callback_name)
		return string.format(':lua require("plugin/nvim-tree/telescope").%s<cr>', callback_name)
	end

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
		view = {
			width = 30,
			mappings = {
				custom_only = true,
				list = {
					{ key = { "<CR>", "<2-LeftMouse>" }, action = "edit" },
					{ key = "+", cb = tree_action('resize("+10")') },
					{ key = "-", cb = tree_action('resize("-10")') },
					{ key = "=", cb = tree_action('resize("30")') },
					{ key = "[", action = "dir_up" },
					{ key = "]", action = "cd" },
					{ key = "r", action = "reload" },
					{ key = "o", action = "system_open" },
					{ key = "v", action = "vsplit" },
					{ key = "s", action = "split" },
					{ key = "t", action = "tabnew" },
					{ key = "a", action = "create" },
					{ key = "d", action = "trash" },
					{ key = "D", action = "remove" },
					{ key = "n", action = "rename" },
					{ key = "N", action = "full_rename" },
					{ key = "x", action = "cut" },
					{ key = "y", action = "copy" },
					{ key = "p", action = "paste" },
					{ key = "i", action = "toggle_file_info" },
					{ key = "<BS>", action = "close_node" },
					{ key = "<Tab>", action = "preview" },
					{ key = "c", action = "copy_name" },
					{ key = "C", action = "copy_path" },
					{ key = "h", cb = ":lua require('hop').hint_char1()<cr>" },
					{ key = "<F3>", cb = "<c-w>l<cr>" },
					{ key = "<esc>", cb = "" },
					{ key = "f", cb = telescope_action("find_files()") },
					{ key = "g", cb = telescope_action("live_grep()") },
				},
			},
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
						-- untracked = '★',
						untracked = "*",
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
	map("n", "<F3>", ":NvimTreeFindFile<cr>:NvimTreeFocus<cr>:NvimTreeRefresh<cr>")
	map("i", "<F2>", "<esc>:NvimTreeToggle<cr>")
	map("i", "<F3>", "<esc>:NvimTreeFindFile<cr>:NvimTreeFocus<cr>:NvimTreeRefresh<cr>")
	map("x", "<F2>", "<esc>:NvimTreeToggle<cr>")
	map("x", "<F3>", "<esc>:NvimTreeFindFile<cr>:NvimTreeFocus<cr>:NvimTreeRefresh<cr>")
end

return _M
