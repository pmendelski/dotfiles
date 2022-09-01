-- Onedark color table for highlights
-- https://github.com/Th3Whit3Wolf/onebuddy/blob/main/lua/onebuddy.lua#L75
local null_ls = require("plugin/null-ls")

local colors = {
	yellow = "#e5c07b",
	cyan = "#8abeb7",
	green = "#98c379",
	orange = "#d19a66",
	red = "#e88388",
}

local fileFormatIcons = {
	unix = "", -- e712
	dos = "", -- e70f
	mac = "", -- e711
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	buffer_not_tree = function()
		return vim.bo.filetype ~= "NvimTree"
	end,
	buffer_wide = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local file_size = {
	function()
		local function format_file_size(file)
			local size = vim.fn.getfsize(file)
			if size <= 0 then
				return ""
			end
			local sufixes = { "b", "k", "m", "g" }
			local i = 1
			while size > 1024 do
				size = size / 1024
				i = i + 1
			end
			return string.format("%.1f%s", size, sufixes[i])
		end

		local file = vim.fn.expand("%:p")
		if string.len(file) == 0 then
			return ""
		end
		return format_file_size(file)
	end,
	cond = function()
		return conditions.buffer_not_empty() and conditions.buffer_wide() and conditions.buffer_not_tree()
	end,
}

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	color_error = colors.red,
	color_warn = colors.yellow,
	color_info = colors.cyan,
	cond = function()
		return conditions.buffer_not_tree()
	end,
}

local diff = {
	"diff",
	symbols = { added = " ", modified = "柳 ", removed = " " },
	color_added = colors.green,
	color_modified = colors.orange,
	color_removed = colors.red,
	cond = function()
		return conditions.buffer_wide() and conditions.buffer_not_tree()
	end,
}

local encoding = {
	-- 'encoding',
	function()
		local encoding = "%{strlen(&fenc)?&fenc:&enc}"
		local format = vim.bo.fileformat
		if format == "unix" then
			return encoding
		end
		local icon = fileFormatIcons[format] or format
		return encoding .. " " .. icon
	end,
	cond = function()
		return conditions.buffer_wide() and conditions.buffer_not_tree()
	end,
}

local filetype = {
	"filetype",
	cond = function()
		return conditions.buffer_not_tree()
	end,
}

local location = {
	"location",
	cond = function()
		return conditions.buffer_wide() and conditions.buffer_not_tree()
	end,
}

local progress = {
	"progress",
	cond = function()
		return conditions.buffer_wide() and conditions.buffer_not_tree()
	end,
}

local mode = {
	"mode",
	cond = function()
		return conditions.buffer_not_tree()
	end,
}

local branch = {
	"branch",
	cond = function()
		return conditions.buffer_not_tree()
	end,
}

local lsp_progress = {
	"lsp_progress",
	display_components = { "lsp_client_name", "spinner", { "title", "percentage", "message" } },
	spinner_symbols = { "⣷ ", "⣯ ", "⣟ ", "⡿ ", "⢿ ", "⣻ ", "⣽ ", "⣾ " },
	colors = {
		percentage = colors.cyan,
		title = colors.cyan,
		message = colors.cyan,
		spinner = colors.orange,
		lsp_client_name = colors.orange,
		use = true,
	},
	cond = function()
		return conditions.buffer_not_tree()
	end,
}

local lsp_progress_short = {
	"lsp_progress",
	display_components = { { "percentage" } },
	-- spinner_symbols = { '⣷ ', '⣯ ', '⣟ ', '⡿ ', '⢿ ', '⣻ ', '⣽ ', '⣾ ' },
	colors = {
		percentage = colors.cyan,
		-- title  = colors.cyan,
		-- message  = colors.cyan,
		-- spinner = colors.orange,
		-- lsp_client_name = colors.orange,
		use = true,
	},
	cond = function()
		return not conditions.buffer_wide() and conditions.buffer_not_tree()
	end,
}

local filename = {
	function()
		if vim.bo.filetype == "NvimTree" then
			return "NvimTree"
		end
		if vim.bo.modified then
			return vim.fn.expand("%:t") .. " ●"
		end
		return vim.fn.expand("%:t")
	end,
}

local lsp_client = {
	function()
		local buf_clients = vim.lsp.buf_get_clients()
		if next(buf_clients) == nil then
			return ""
		end
		local clients = {}
		for _, client in pairs(buf_clients) do
			if client.name ~= "null-ls" then
				table.insert(clients, client.name)
			end
		end
		local null_ls_providers = null_ls.list_registered_providers(vim.bo.filetype)
		for _, provider in pairs(null_ls_providers) do
			table.insert(clients, provider)
		end
		return table.concat(clients, ", ")
	end,
	cond = function()
		return conditions.buffer_wide() and conditions.buffer_not_tree()
	end,
}

require("lualine").setup({
	options = {
		theme = "tokyonight",
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch },
		lualine_c = { filename, lsp_progress },
		lualine_x = { diagnostics, lsp_client, filetype, file_size, encoding },
		lualine_y = { progress },
		lualine_z = { location },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { filename },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})
