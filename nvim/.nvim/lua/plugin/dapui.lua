require("dapui").setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
	},
	layouts = {
		{
			elements = {
				"scopes",
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 10,
			position = "bottom",
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "single", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
})

local map = require("util").keymap
map("n", "<F5>", ":lua require('dapui').toggle()<CR>")
map("n", "<F6>", ":lua require('dap').step_over()<CR>")
map("n", "<F7>", ":lua require('dap').step_into()<CR>")
map("n", "<F8>", ":lua require('dap').step_out()<CR>")
map("n", "<F9>", ":lua require('dap').continue()<CR>")
map("n", "<leader>b", ":lua require('dap').toggle_breakpoint()<CR>")
map("n", "<leader>B", ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
map("n", "<leader>df", ":lua require('dapui').eval()<CR>")
map("n", "<leader>dr", ":lua require('dap').repl.open()<CR>")
map("n", "<leader>dd", ":lua require('dap').run_last()<CR>")
map("n", "<leader>dl", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")

-- How to debug?
-- Setup breakpoints with: <leader>-b
-- Run code with actions with hover: gh
-- Open dapui: <F5>
