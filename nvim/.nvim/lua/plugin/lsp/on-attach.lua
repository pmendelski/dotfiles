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
			for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
				if vim.api.nvim_win_get_config(winid).zindex then
					return
				end
			end
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
	local prefix = "g"
	local prefix_upper = "G"
	local opts = { noremap = true, silent = true }
	-- Use telescope for basic navigation instead
	buf_set_keymap(
		"n",
		prefix .. "r",
		"<cmd>lua require('telescope.builtin').lsp_references({ include_declaration = false })<cr>",
		opts
	)
	buf_set_keymap("n", prefix .. "O", "<cmd>Telescope lsp_incomming_calls<cr>", opts)
	buf_set_keymap("n", prefix .. "o", "<cmd>Telescope lsp_outgoing_calls<cr>", opts)
	buf_set_keymap("n", prefix .. "i", "<cmd>Telescope lsp_implementations<cr>", opts)
	buf_set_keymap("n", prefix .. "d", "<cmd>Telescope lsp_definitions<cr>", opts)
	-- buf_set_keymap("n", prefix .. "r", "<cmd>lua vim.lsp.buf.references({ includeDeclaration = false })<cr>", opts)
	-- buf_set_keymap("n", prefix .. "D", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
	-- buf_set_keymap("n", prefix .. "d", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
	-- buf_set_keymap("n", prefix .. "i", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)

	-- Use customized formatting
	buf_set_keymap("n", prefix .. "f", '<cmd>lua require("plugin/lsp/actions").format()<cr>', opts)
	-- buf_set_keymap('n', prefix .. 'f', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
	buf_set_keymap("x", prefix .. "f", "<cmd>lua vim.lsp.buf.range_format()<cr>", opts)
	buf_set_keymap("n", prefix .. "s", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
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
	-- Diagnostic
	buf_set_keymap("n", prefix .. "p", "<cmd>lua vim.diagnostic.open_float({ focusable = false })<cr>", opts)
	buf_set_keymap("n", "[" .. prefix, "<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'single' }})<cr>", opts)
	buf_set_keymap("n", "]" .. prefix, "<cmd>lua vim.diagnostic.goto_next({ float = { border = 'single' }})<cr>", opts)
	buf_set_keymap(
		"n",
		"[" .. prefix_upper,
		"<cmd>lua vim.diagnostic.goto_prev({ float = { border = 'single' }, severity = vim.diagnostic.severity.ERROR })<cr>",
		opts
	)
	buf_set_keymap(
		"n",
		"]" .. prefix_upper,
		"<cmd>lua vim.diagnostic.goto_next({ float = { border = 'single'}, severity = vim.diagnostic.severity.ERROR })<cr>",
		opts
	)
	buf_set_keymap("n", prefix .. "e", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
	buf_set_keymap("n", prefix .. "l", "<cmd>lua vim.diagnostic.set_loclist()<cr>", opts)
	highlightReferences(client, bufnr)
	diagnosticsOnHold(bufnr)
	-- Save and format
	null_ls.configure_client(client, bufnr)
	local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
	local supports_format = client.server_capabilities.documentFormattingProvider ~= nil
			or null_ls.has_formatter(filetype)
	if supports_format == true then
		-- if filetype == "typescript" then
		-- 	-- run prettier instead
		-- 	client.server_capabilities.documentFormattingProvider = false
		-- end
		buf_set_keymap("n", "<c-s>", ":execute 'lua require(\"plugin/lsp/actions\").format()' | :w<cr>", opts)
		buf_set_keymap("i", "<c-s>", "<esc>:execute 'lua require(\"plugin/lsp/actions\").format()' | :w<cr>", opts)
		buf_set_keymap("x", "<c-s>", "<esc>:execute 'lua require(\"plugin/lsp/actions\").format()' | :w<cr>", opts)
	end
end
