local util = require("util")
local null_ls = require("plugin/null-ls")

local function highlightReferences(client, bufnr)
	-- Autohighlight references
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Document Highlight",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Clear All the References",
		})
	end
end

local function diagnosticsOnHold(bufnr)
	vim.api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			vim.diagnostic.open_float(nil, {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "single",
				source = "always",
				prefix = " ",
				scope = "cursor",
			})
		end,
	})
end

return function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	-- Mappings
	local border = "single"
	local prefix = "g"
	local opts = { noremap = true, silent = true }
	buf_set_keymap("n", prefix .. "D", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	buf_set_keymap("n", prefix .. "d", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	buf_set_keymap("n", prefix .. "i", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
	buf_set_keymap("n", prefix .. "s", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
	buf_set_keymap("n", prefix .. "f", '<cmd>lua require("plugin/lspconfig/actions").format()<cr>', opts)
	-- buf_set_keymap('n', prefix .. 'f', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
	buf_set_keymap("x", prefix .. "f", "<cmd>lua vim.lsp.buf.range_format()<cr>", opts)
	buf_set_keymap("n", prefix .. "h", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
	buf_set_keymap(
		"n",
		prefix .. "H",
		"<cmd>lua vim.lsp.buf.clear_references() vim.lsp.buf.document_highlight()<cr>",
		opts
	)
	buf_set_keymap("n", prefix .. "t", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
	buf_set_keymap("n", prefix .. "n", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
	buf_set_keymap("n", prefix .. "a", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
	buf_set_keymap("n", prefix .. "r", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
	-- Diagnostic
	buf_set_keymap(
		"n",
		prefix .. "p",
		'<cmd>lua vim.diagnostic.open_float({ border = "' .. border .. '", focusable = false })<cr>',
		opts
	)
	buf_set_keymap(
		"n",
		"[p",
		'<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>',
		opts
	)
	buf_set_keymap(
		"n",
		"]p",
		'<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>',
		opts
	)
	buf_set_keymap(
		"n",
		prefix .. "e",
		'<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>',
		opts
	)
	buf_set_keymap("n", prefix .. "l", "<cmd>lua vim.diagnostic.set_loclist()<cr>", opts)
	-- Save and format
	buf_set_keymap("n", "<c-s>", '<cmd>lua require("plugin/lspconfig/actions").format()<cr>:w<cr>', opts)
	buf_set_keymap("i", "<c-s>", '<c-o><cmd>lua require("plugin/lspconfig/actions").format()<cr><c-o>:w<cr>', opts)
	buf_set_keymap("x", "<c-s>", '<esc><cmd>lua require("plugin/lspconfig/actions").format()<cr>:w<cr>', opts)
	highlightReferences(client, bufnr)
	diagnosticsOnHold(bufnr)
	null_ls.configure_client(client, bufnr)
end
