local on_attach = require("plugin/lsp/on-attach")

local extension_path = vim.fn.expand("~/.vscode/extensions/vadimcn.vscode-lldb-*")
local codelldb_path = extension_path .. "/adapter/codelldb"
local liblldb_path = vim.fn.expand(extension_path .. "/lldb/lib/liblldb.*")
-- local liblldb_path = extension_path .. '/lldb/lib/liblldb.dylib' -- macos
-- local liblldb_path = extension_path .. '/lldb/lib/liblldb.so' -- linux

require("rust-tools").setup({
	tools = {
		-- rust-tools options
		-- Automatically set inlay hints (type hints)
		autoSetHints = true,

		-- how to execute terminal commands
		-- options right now: termopen / quickfix
		executor = require("rust-tools/executors").termopen,

		-- callback to execute once rust-analyzer is done initializing the workspace
		-- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
		on_initialized = nil,

		-- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
		reload_workspace_from_cargo_toml = true,

		-- These apply to the default RustSetInlayHints command
		inlay_hints = {
			-- automatically set inlay hints (type hints)
			-- default: true
			auto = true,

			-- Only show inlay hints for the current line
			only_current_line = false,

			-- Event which triggers a refersh of the inlay hints.
			-- You can make this 'CursorMoved' or 'CursorMoved,CursorMovedI' but
			-- not that this may cause  higher CPU usage.
			-- This option is only respected when only_current_line and
			-- autoSetHints both are true.
			only_current_line_autocmd = "CursorHold",

			-- wheter to show parameter hints with the inlay hints or not
			show_parameter_hints = true,

			-- prefix for parameter hints
			parameter_hints_prefix = "<- ",

			-- prefix for all the other hints (type, chaining)
			other_hints_prefix = "=> ",

			-- whether to align to the length of the longest line in the file
			max_len_align = false,

			-- padding from the left if max_len_align is true
			max_len_align_padding = 1,

			-- whether to align to the extreme right or not
			right_align = false,

			-- padding from the right if right_align is true
			right_align_padding = 7,

			-- The color of the hints
			highlight = "Comment",
		},

		hover_actions = {
			-- the border that is used for the hover window
			-- see vim.api.nvim_open_win()
			border = {
				{ "╭", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╮", "FloatBorder" },
				{ "│", "FloatBorder" },
				{ "╯", "FloatBorder" },
				{ "─", "FloatBorder" },
				{ "╰", "FloatBorder" },
				{ "│", "FloatBorder" },
			},

			-- whether the hover action window gets automatically focused
			auto_focus = false,
		},

		-- settings for showing the crate graph based on graphviz and the dot
		-- command
		crate_graph = {
			-- Backend used for displaying the graph
			-- see: https://graphviz.org/docs/outputs/
			-- default: x11
			backend = "x11",
			-- where to store the output, nil for no output stored (relative
			-- path from pwd)
			-- default: nil
			output = nil,
			-- true for all crates.io and external crates, false only the local
			-- crates
			-- default: true
			full = true,
		},
	},

	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
	server = {
		on_attach = on_attach,
		flags = { debounce_text_changes = 150 },
		settings = {
			["rust-analyzer"] = {
				completion = { postfix = { enable = false } },
				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},
				cargo = {
					loadOutDirsFromCheck = true,
					allFeatures = true,
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true,
				},
				diagnostics = {
					enable = true,
					disabled = { "unresolved-proc-macro" },
					experimental = { enable = false },
				},
				checkOnSave = {
					allFeatures = true,
					overrideCommand = {
						"cargo",
						"clippy",
						"--workspace",
						"--message-format=json",
						"--all-targets",
						"--all-features",
					},
				},
			},
		},
	}, -- rust-analyer options

	-- debugging stuff
	dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	},
})
