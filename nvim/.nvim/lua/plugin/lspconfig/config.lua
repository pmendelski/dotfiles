-- https://github.com/neovim/nvim-lspconfig

local lspconfig = require('lspconfig')
local on_attach = require('plugin/lspconfig/on-attach')
local map = require('util').keymap

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  },
}

local flags = {
  debounce_text_changes = 500,
}

local config = function(opts)
  local options = { on_attach = on_attach, capabilities = capabilities, flags = flags }
  if opts then options = vim.tbl_extend('force', options, opts) end
  return options
end

-- Global LSP key bindings
map('n', 'gq', '<cmd>:LspRestart<cr>')

-- Customize dioagnostics UI
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  -- show error messages next to the code
  virtual_text = {
    spacing = 4,
    prefix = '●',
    severity_limit = 'Warning',
  },
  signs = true,
  severity_sort = true,
  update_in_insert = true,
}
)

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
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#bashls
-- npm i -g bash-language-server
lspconfig.bashls.setup(config())

-- css, scss, less, html, json
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#cssls
-- npm i -g vscode-langservers-extracted
lspconfig.cssls.setup(config())
lspconfig.html.setup(config())
lspconfig.jsonls.setup(config())
lspconfig.yamlls.setup(config())

-- Eslint
-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#eslint_d
-- go install github.com/mattn/efm-langserver@latest
-- npm install -g eslint_d
local eslint = {
  lintCommand = 'eslint_d -f unix --stdin --stdin-filename ${INPUT}',
  lintStdin = true,
  lintFormats = { '%f:%l:%c: %m' },
  lintIgnoreExitCode = true,
  formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
  formatStdin = true
}

lspconfig.efm.setup({
  init_options = { documentFormatting = true },
  filetypes = { 'javascript', 'typescript' },
  settings = {
    rootMarkers = { '.eslintrc.js', '.git/' },
    languages = {
      javascript = { eslint },
      typescript = { eslint },
    }
  }
})

-- Docker
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#dockerls
-- npm i -g dockerfile-language-server-nodejs
lspconfig.dockerls.setup(config())

-- GraphQL
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#graphql
-- npm i -g graphql-language-service-cli
lspconfig.graphql.setup(config())

-- Groovy
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#groovyls
-- https://github.com/prominic/groovy-language-server.git
lspconfig.groovyls.setup(config({
  cmd = { vim.fn.expand('~/.nvim/lang/groovy/run.sh') },
}))

-- Go
require('plugin/lspconfig/lang/go').setup(config)

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

-- Java
-- https://github.com/georgewfraser/java-language-server
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#java_language_server
lspconfig.java_language_server.setup(config({
  cmd = { vim.fn.expand('~/.nvim/lang/java/run.sh') },
}))

-- Kotlin
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#kotlin_language_server
-- https://github.com/fwcd/kotlin-language-server
lspconfig.kotlin_language_server.setup(config({
  cmd = { vim.fn.expand('~/.nvim/lang/kotlin/bin/kotlin-language-server') },
}))

-- Python
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#pyright
-- https://github.com/microsoft/pyright
-- npm i --global pyright
lspconfig.pyright.setup(config())

-- SQL
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sqlls
-- https://github.com/joe-re/sql-language-server
-- npm i -g sql-language-server
lspconfig.sqlls.setup(config({
  cmd = { 'sql-language-server', 'up', '--method', 'stdio' },
}))

-- Svelte
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#svelte
-- https://github.com/sveltejs/language-tools/tree/master/packages/language-server
-- npm i -g svelte-language-server
lspconfig.svelte.setup(config())

-- Typescript
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
-- https://github.com/theia-ide/typescript-language-server
-- npm i -g typescript typescript-language-server
lspconfig.tsserver.setup(config())

-- Vue
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#vuels
-- https://github.com/vuejs/vetur/tree/master/server
-- npm i -g vls
lspconfig.vuels.setup(config())

-- Lua
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
-- https://github.com/sumneko/lua-language-serve
-- https://www.chiarulli.me/Neovim/28-neovim-lua-development/
local lua_dir = vim.fn.stdpath('data') .. '/lang-servers/lua-language-server'
lspconfig.sumneko_lua.setup(config({
  cmd = { lua_dir .. '/bin/lua-language-server', "-E", lua_dir .. "/main.lua" },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}))
