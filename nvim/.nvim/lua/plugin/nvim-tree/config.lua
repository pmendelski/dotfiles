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
		-- open the tree when running this setup function
		open_on_setup = false,
		-- hijack the cursor in the tree to put it at the start of the filename
		hijack_cursor = true,
		-- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
		update_cwd = true,
		view = {
			width = 30,
			mappings = {
				custom_only = true,
				list = {
					{ key = { "<CR>", "<2-LeftMouse>" }, action = "edit" },
					{ key = "+", cb = tree_action('resize("+10")') },
					{ key = "-", cb = tree_action('resize("-10")') },
					{ key = "=", cb = tree_action('resize("30")') },
					{ key = "<c-[>", action = "dir_up" },
					{ key = "<c-]>", action = "cd" },
					{ key = "<c-r>", action = "reload" },
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
					{ key = "c", action = "copy" },
					{ key = "p", action = "paste" },
					{ key = "y", action = "copy_name" },
					{ key = "Y", action = "copy_path" },
					{ key = "<F3>", cb = "<c-w>l<cr>" },
					{ key = "<esc>", cb = "" },
					{ key = "f", cb = telescope_action("find_files()") },
					{ key = "g", cb = telescope_action("live_grep()") },
				},
			},
		},
		update_focused_file = {
			enable = false,
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
