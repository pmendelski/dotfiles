require('kommentary.config').configure_language("default", {
  prefer_single_line_comments = true,
  use_consistent_indentation = true,
  ignore_whitespace = true,
})

-- Keybindings
-------------------------
vim.g.kommentary_create_default_mappings = false
vim.api.nvim_set_keymap('n', '<c-_>', '<Plug>kommentary_line_default', {})
vim.api.nvim_set_keymap('i', '<c-_>', '<esc><Plug>kommentary_line_default<cr>i', {})
vim.api.nvim_set_keymap('v', '<c-_>', '<Plug>kommentary_visual_default', {})
