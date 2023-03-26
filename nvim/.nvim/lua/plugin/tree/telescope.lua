local set_current_win_max = require("util").set_current_win_max

local M = {}

function M.live_grep(opts)
	return M.launch_telescope("live_grep", opts)
end

function M.find_files(opts)
	return M.launch_telescope("find_files", opts)
end

function M.launch_telescope(func_name, opts)
	local telescope_status_ok, _ = pcall(require, "telescope")
	if not telescope_status_ok then
		return
	end
	local lib_status_ok, lib = pcall(require, "nvim-tree.lib")
	if not lib_status_ok then
		return
	end
	local node = lib.get_node_at_cursor()
	if node == nil then
		return
	end
	local is_folder = node.has_children and true
	local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
	if node.name == ".." and TreeExplorer ~= nil then
		basedir = TreeExplorer.cwd
	end
	opts = opts or {}
	opts.cwd = basedir
	opts.search_dirs = { basedir }
	set_current_win_max()
	if func_name == "live_grep_args" then
		return require("telescope").extensions.live_grep_args.live_grep_args(opts)
	end
	return require("telescope.builtin")[func_name](opts)
end

return M
