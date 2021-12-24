require('lsp_signature').setup({
  hint_enable = false,
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = 'single'
  },
})
