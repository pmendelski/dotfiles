require('lspsaga').init_lsp_saga({
  error_sign = "",
  warn_sign = "",
  hint_sign = "",
  infor_sign = "",
  max_preview_lines = 60,
  finder_action_keys = {
    quit = {'q', '<esc>' },
    open = { 'o', '<cr>' },
    vsplit = 's',
    split = 'i',
    scroll_down = '<C-d>',
    scroll_up = '<C-f>'
  },
  code_action_keys = {
    quit = { 'q', '<esc>' },
    exec = '<cr>'
  },
  rename_action_keys = {
    quit = {'<c-c>', '<esc>' }, exec = '<cr>'
  },
})

-- Automatically show diagnostic errors
-- Clashes with nvim-cmp
-- vim.cmd([[autocmd CursorHold,CursorHoldI * lua require('lspsaga.diagnostic').show_cursor_diagnostics()]])
