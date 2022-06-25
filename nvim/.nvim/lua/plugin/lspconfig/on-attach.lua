return function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings
  local border = "single";
  local prefix = 'g';
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', prefix .. 'D', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
  buf_set_keymap('n', prefix .. 'd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  buf_set_keymap('n', prefix .. 'i', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
  buf_set_keymap('n', prefix .. 's', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
  -- lspsaga
  buf_set_keymap('n', prefix .. 'h', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', prefix .. 't', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_set_keymap('n', prefix .. 'r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', prefix .. 'a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap('n', prefix .. 'f', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  buf_set_keymap('n', prefix .. 'p', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ border = "' .. border .. '", focusable = false })<cr>', opts)
  buf_set_keymap('n', '[p', '<cmd>lua vim.lsp.diagnostic.goto_prev({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>', opts)
  buf_set_keymap('n', ']p', '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>', opts)
  buf_set_keymap('n', prefix .. 'x', '<cmd>lua vim.lsp.diagnostic.goto_next({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>', opts)
  buf_set_keymap('n', prefix .. 'l', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)

  -- Mappings for lspsaga
  -- buf_set_keymap('n', prefix .. 'g', "<cmd>lua require('lspsaga.provider').lsp_finder()<cr>", opts)
  -- buf_set_keymap('n', prefix .. 'h', "<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>", opts)
  -- buf_set_keymap('n', prefix .. 'a', "<cmd>lua require('lspsaga.codeaction').code_action()<cr>", opts)
  -- buf_set_keymap('v', prefix .. 'a', ":<c-U>lua require('lspsaga.codeaction').range_code_action()<cr>", opts)
  -- buf_set_keymap('n', '<c-f>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<cr>", opts)
  -- buf_set_keymap('n', '<c-b>', "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<cr>", opts)
  -- buf_set_keymap('n', prefix .. 'r', "<cmd>lua require('lspsaga.rename').rename()<cr>", opts)
  -- buf_set_keymap('n', prefix .. 'p', "<cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<cr>", opts)
  -- buf_set_keymap('n', prefix .. 'P', "<cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<cr>", opts)
  -- buf_set_keymap('n', '[d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<cr>", opts)
  -- buf_set_keymap('n', ']d', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<cr>", opts)
  -- buf_set_keymap('n', prefix .. 'x', "<cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<cr>", opts)
  -- skipped
  -- buf_set_keymap('n', prefix .. 's', "<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>", opts)
  -- buf_set_keymap('n', prefix .. 'd', "<cmd>lua require('lspsaga.provider').preview_definition()<cr>", opts)

  -- Save and format
  buf_set_keymap('n', '<c-s>', ':w<cr>:silent FormatWrite<cr>', opts)
  buf_set_keymap('i', '<c-s>', '<esc>:w<cr>:silent FormatWrite<cr>', opts)
  buf_set_keymap('v', '<c-s>', '<esc>:w<cr>:silent FormatWrite<cr>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    buf_set_keymap("n", "<space>fo", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  end
  if client.server_capabilities.document_range_formatting then
    buf_set_keymap("v", "<space>fo", "<cmd>lua vim.lsp.buf.range_formatting()<cr>", opts)
  end
end
