require('trouble').setup({
  auto_close = true,
  use_diagnostic_signs = true
})

local map = require('util').keymap
map('n', '<leader>xx', ':TroubleToggle<cr>')
map('n', '<leader>xw', ':TroubleToggle workspace_diagnostics<cr>')
map('n', '<leader>xd', ':TroubleToggle document_diagnostics<cr>')
map('n', '<leader>xq', ':TroubleToggle quickfix<cr>')
map('n', '<leader>xl', ':TroubleToggle loclist<cr>')
map('n', '<leader>xr', ':TroubleToggle lsp_references<cr>')
