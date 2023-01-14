local lspconfig = require("lspconfig")
local util = lspconfig.util

local _M = {}

-- Get the value of the module name from go.mod in PWD
local goModuleName = function()
	local f = io.open("go.mod", "rb")
	if f then
		f:close()
	else
		return nil
	end
	for line in io.lines("go.mod") do
		if vim.startswith(line, "module") then
			local items = vim.split(line, " ")
			return vim.trim(items[2])
		end
	end
	return nil
end

function _M.setup(config)
	-- Imports:
	-- https://github.com/neovim/nvim-lspconfig/issues/115
	-- https://github.com/neovim/nvim-lspconfig/issues/115

	lspconfig.gopls.setup(config({
		cmd = { "gopls" },
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		root_dir = util.root_pattern("go.mod", ".git"),
		single_file_support = true,
		settings = {
			gopls = {
				-- buildFlags = { '-tags=tools' },
				gofumpt = true, -- A stricter gofmt
				["local"] = goModuleName(),
				codelenses = {
					gc_details = true, -- Toggle the calculation of gc annotations
					generate = true, -- Runs go generate for a given directory
					regenerate_cgo = true, -- Regenerates cgo definitions
					tidy = true, -- Runs go mod tidy for a module
					upgrade_dependency = true, -- Upgrades a dependency in the go.mod file for a module
					vendor = true, -- Runs go mod vendor for a module
				},
				diagnosticsDelay = "300ms",
				experimentalWatchedFileDelay = "100ms",
				symbolMatcher = "fuzzy",
				completeUnimported = true,
				staticcheck = true,
				matcher = "Fuzzy",
				usePlaceholders = true, -- enables placeholders for function parameters or struct fields in completion responses
				analyses = {
					fieldalignment = false, -- find structs that would use less memory if their fields were sorted
					nilness = true, -- check for redundant or impossible nil comparisons
					shadow = true, -- check for possible unintended shadowing of variables
					unusedparams = true,
					unusedwrite = true,
				},
			},
		},
	}))
end

function _M.organizeImports()
	local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end

return _M
