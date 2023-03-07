local api = require("nvim-tree.api")

local function tree_action(callback_name)
	return string.format(':lua require("nvim-tree").%s<cr>', callback_name)
end

local function telescope_action(callback_name)
	return string.format(':lua require("plugin/tree/telescope").%s<cr>', callback_name)
end

return function(bufnr)
	local opts = function(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end
	vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "[", api.tree.change_root_to_parent, opts("Up"))
	vim.keymap.set("n", "]", api.tree.change_root_to_node, opts("CD"))
	vim.keymap.set("n", "o", api.node.run.system, opts("Run System"))
	vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
	vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open: Horizontal Split"))
	vim.keymap.set("n", "t", api.node.open.tab, opts("Open: New Tab"))
	vim.keymap.set("n", "a", api.fs.create, opts("Create"))
	vim.keymap.set("n", "d", api.fs.trash, opts("Trash"))
	vim.keymap.set("n", "D", api.fs.remove, opts("Delete"))
	vim.keymap.set("n", "n", api.fs.rename, opts("Rename"))
	vim.keymap.set("n", "N", api.fs.rename_sub, opts("Rename: Omit Filename"))
	vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
	vim.keymap.set("n", "y", api.fs.copy.node, opts("Copy"))
	vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
	vim.keymap.set("n", "i", api.node.show_info_popup, opts("Info"))
	vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "<Tab>", api.node.open.preview, opts("Open Preview"))
	vim.keymap.set("n", "c", api.fs.copy.filename, opts("Copy Name"))
	vim.keymap.set("n", "C", api.fs.copy.relative_path, opts("Copy Relative Path"))
	-- custom
	vim.keymap.set("n", "<esc>", "", { buffer = bufnr })
	vim.keymap.set("n", "+", tree_action('resize("+10")'), opts("Resize +10"))
	vim.keymap.set("n", "-", tree_action('resize("-10")'), opts("Resize -10"))
	vim.keymap.set("n", "=", tree_action('resize("30")'), opts("Reset size"))
	vim.keymap.set("n", "<F3>", function()
		vim.cmd("wincmd l")
	end, opts("Unfocus tree"))
	vim.keymap.set("n", "h", function()
		require("hop").hint_lines_skip_whitespace()
	end, opts("Hop to line"))
	vim.keymap.set("n", "f", telescope_action("find_files()"), opts("Search subdirectory"))
	vim.keymap.set("n", "g", telescope_action("live_grep()"), opts("Grep subdirectory"))
end