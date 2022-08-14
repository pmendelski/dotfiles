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
  buf_set_keymap('n', prefix .. 'f', "<cmd>lua vim.lsp.buf.format()<cr>", opts)
  buf_set_keymap('v', prefix .. 'f', "<cmd>lua vim.lsp.buf.range_format()<cr>", opts)
  buf_set_keymap('n', prefix .. 'h', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  buf_set_keymap('n', prefix .. 'H', '<cmd>lua vim.lsp.buf.clear_references() vim.lsp.buf.document_highlight()<cr>', opts)
  buf_set_keymap('n', prefix .. 't', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
  buf_set_keymap('n', prefix .. 'r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  buf_set_keymap('n', prefix .. 'a', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  buf_set_keymap('n', prefix .. 'o', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
  -- Diagnostic
  buf_set_keymap('n', prefix .. 'p',
    '<cmd>lua vim.diagnostic.open_float({ border = "' .. border .. '", focusable = false })<cr>', opts)
  buf_set_keymap('n', '[p',
    '<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>', opts)
  buf_set_keymap('n', ']p',
    '<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>', opts)
  buf_set_keymap('n', prefix .. 'x',
    '<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "' .. border .. '", focusable = false }})<cr>', opts)
  buf_set_keymap('n', prefix .. 'l', '<cmd>lua vim.diagnostic.set_loclist()<cr>', opts)
  -- Save and format
  if client.server_capabilities.documentFormattingProvider then
    buf_set_keymap('n', '<c-s>', '<cmd>lua vim.lsp.buf.format()<cr>:w<cr>', opts)
    buf_set_keymap('i', '<c-s>', '<c-o><cmd>lua vim.lsp.buf.format()<cr><c-o>:w<cr>', opts)
    buf_set_keymap('v', '<c-s>', '<c-o><cmd>lua vim.lsp.buf.format()<cr><c-o>:w<cr>', opts)
  else
    buf_set_keymap('n', '<c-s>', '<cmd>:w<cr>', opts)
    buf_set_keymap('i', '<c-s>', '<c-o>:w<cr>', opts)
    buf_set_keymap('v', '<c-s>', '<c-o>:w<cr>', opts)
  end

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'single',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      })
    end
  })
end
