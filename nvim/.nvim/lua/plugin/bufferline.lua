local _M = {}

local function get_listed_buffers()
	local buffers = {}
	local len = 0
	local vim_fn = vim.fn
	local buflisted = vim_fn.buflisted
	for buffer = 1, vim_fn.bufnr("$") do
		if buflisted(buffer) == 1 then
			len = len + 1
			buffers[len] = buffer
		end
	end
	return buffers
end

function _M.close_buffer(buffer)
	-- handle modified buffers
	local isModified = tonumber(vim.api.nvim_eval("getbufvar(" .. buffer .. ', "&mod")'))
	if isModified ~= nil and isModified > 0 then
		print("Close buffer and drop unsaved changes: [y/n] ")
		local decision = vim.api.nvim_eval("nr2char(getchar())")
		if decision ~= "y" and decision ~= "Y" then
			return
		end
	end

	-- cycle to prev buffer before closing for nvim tree
	local bufferline = require("bufferline")
	local activeBuffer = vim.api.nvim_get_current_buf()
	local explorerWindow = require("nvim-tree.view").get_winnr()
	local wasExplorerOpen = vim.api.nvim_win_is_valid(explorerWindow)
	local buffers = tonumber(vim.api.nvim_eval("len(getbufinfo({'buflisted':1}))"))
	if wasExplorerOpen and activeBuffer == buffer and buffers > 1 then
		-- switch to previous buffer (tracked by bufferline)
		pcall(bufferline.cycle, -1)
	end

	-- delete initially open buffer
	---@diagnostic disable-next-line: param-type-mismatch
	pcall(vim.cmd, "bdelete! " .. buffer)
	require("bufferline.ui").refresh()
end

function _M.close_active_buffer()
	_M.close_buffer(vim.api.nvim_get_current_buf())
end

function _M.close_other_buffers()
	local active = vim.api.nvim_get_current_buf()
	local buffers = get_listed_buffers()
	for _, value in ipairs(buffers) do
		if value ~= active then
			_M.close_buffer(value)
		end
	end
end

function _M.config()
	require("bufferline").setup({
		highlights = {
			fill = {
				-- tweak for onedark theme
				bg = "#17191e",
			},
		},
		options = {
			numbers = function(opts)
				return string.format("%s ", opts.ordinal)
			end,
			close_command = function(buff)
				return _M.close_buffer(buff)
			end,
			-- right_mouse_command = "vert sbuffer %d",
			max_prefix_length = 15,
			diagnostics = false,
			show_close_icon = false,
			-- show_buffer_close_icons = false,
			offsets = { { filetype = "NvimTree", text = "Files", text_align = "center" } },
			always_show_bufferline = false,
		},
	})

	local map = require("util").keymap
	map("n", "<leader>bb", ":Telescope buffers<cr>")
	-- reload buffer
	map("n", "<leader>br", ":bufdo edit!<cr>")
	-- closing buffers
	map("n", "<leader>bq", "<cmd>lua require('plugin/bufferline').close_active_buffer()<cr>")
	map("n", "<leader>bo", "<cmd>lua require('plugin/bufferline').close_other_buffers()<cr>")
	-- cycling buffers
	map("n", "]b", "<cmd>:BufferLineCycleNext<cr>")
	map("n", "[b", "<cmd>:BufferLineCyclePrev<cr>")
	-- moving buffers
	map("n", "]B", "<cmd>:BufferLineMoveNext<cr>")
	map("n", "[B", "<cmd>:BufferLineMovePrev<cr>")
	-- picking buffers
	local numbers = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
	for _, num in pairs(numbers) do
		map("n", "<leader>b" .. num, "<cmd>BufferLineGoToBuffer " .. num .. "<cr>")
	end
end

return _M
