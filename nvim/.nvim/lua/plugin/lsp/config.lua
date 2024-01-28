-- https://github.com/neovim/nvim-lspconfig

local lspconfig = require("lspconfig")
local on_attach = require("plugin/lsp/on-attach")
local map = require("util").keymap

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = {
		"documentation",
		"detail",
		"additionalTextEdits",
	},
}

local flags = {
	debounce_text_changes = 500,
}

local config = function(opts)
	local options = { on_attach = on_attach, capabilities = capabilities, flags = flags }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	return options
end

-- Global LSP key bindings
map("n", "gq", "<cmd>:LspRestart<cr>")

-- Customize dioagnostics UI
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	-- show error messages next to the code
	virtual_text = {
		spacing = 4,
		prefix = "●",
		severity_limit = "Warning",
	},
	signs = true,
	severity_sort = true,
	update_in_insert = true,
})

-- Add border
local border = "single"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

-- Change gutter icons
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Bash
-- npm i -g bash-language-server
lspconfig.bashls.setup(config())

-- css, scss, less, html, json
-- npm i -g vscode-langservers-extracted
lspconfig.cssls.setup(config({
	settings = {
		css = {
			validate = false,
		},
	},
}))
lspconfig.html.setup(config())
lspconfig.jsonls.setup(config())
lspconfig.yamlls.setup(config({
	settings = {
		yaml = {
			keyOrdering = false,
		},
	},
}))
lspconfig.tailwindcss.setup(config({
	filetypes = {
		-- "rust",
		"aspnetcorerazor",
		"django-html",
		"htmldjango",
		"edge",
		"eelixir",
		"elixir",
		"gohtml",
		"handlebars",
		"hbs",
		"html",
		"liquid",
		"markdown",
		"mdx",
		"mustache",
		"njk",
		"nunjucks",
		"php",
		"twig",
		"css",
		"less",
		"postcss",
		"sass",
		"scss",
		"stylus",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
}))

-- Eslint
-- go install github.com/mattn/efm-langserver@latest
-- npm install -g eslint_d
lspconfig.eslint.setup(config())

-- Docker
-- npm i -g dockerfile-language-server-nodejs
lspconfig.dockerls.setup(config())

-- GraphQL
-- npm i -g graphql-language-service-cli
lspconfig.graphql.setup(config())

-- Go
require("plugin/lsp/lang/go").setup(config)

-- Rust
-- Handled by rust-tools
-- lspconfig.rust_analyzer.setup(lsconfig({
--   settings = {
--     -- Add clippy warnings to rust-anayzer
--     -- https://www.reddit.com/r/neovim/comments/nu2w2g/using_clippy_as_linter_for_rust_in/
--     ['rust-analyzer'] = {
--       assist = {
--         importGranularity = "module",
--         importPrefix = "by_self",
--       },
--       cargo = {
--         loadOutDirsFromCheck = true
--       },
--         procMacro = {
--         enable = true
--       },
--       checkOnSave = {
--         allFeatures = true,
--         overrideCommand = {
--           'cargo', 'clippy', '--workspace', '--message-format=json',
--           '--all-targets', '--all-features'
--         }
--       }
--     }
--   },
-- }))

-- Python
-- npm i --global pyright
lspconfig.pyright.setup(config())

-- SQL
-- npm i -g sql-language-server
lspconfig.sqlls.setup(config())

-- Svelte
-- npm i -g svelte-language-server
lspconfig.svelte.setup(config())

-- Typescript
-- npm i -g typescript typescript-language-server
lspconfig.tsserver.setup(config())

-- Vue
-- npm i -g vls
lspconfig.vuels.setup(config())

-- Stylelint
-- npm i -g stylelint-lsp
lspconfig.stylelint_lsp.setup(config({
	filetypes = {
		"css",
		"scss",
		"vue",
	},
}))

-- Toml
-- cargo install --features lsp --locked taplo-cli
lspconfig.taplo.setup(config())

-- Lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
-- https://github.com/luals/lua-language-server/wiki/Getting-Started#command-line
local lua_dir = vim.fn.stdpath("data") .. "/lang-servers/lua_ls"
lspconfig.lua_ls.setup(config({
	cmd = { lua_dir .. "/bin/lua-language-server" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
				ignoreDir = { "nvim/.nvim/tmp" },
			},
			telemetry = {
				enable = false,
			},
		},
	},
}))
