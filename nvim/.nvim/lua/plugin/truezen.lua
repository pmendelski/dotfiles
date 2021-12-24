local _M = {}

function _M.config()
  local cmd = vim.cmd
  local true_zen = require('true-zen')

  true_zen.setup({
    integrations = {
      lualine = true,
      gitsigns = true,
      nvim_bufferline = true
    }
  })
end

function _M.keymap()
  local map = require('util').keymap
  map('n', '<F12>', '<CMD>TZAtaraxis<cr>')
  map('i', '<F12>', '<CMD>TZAtaraxis<cr>')
  map('v', '<F12>', '<CMD>TZAtaraxis<cr>')
end

return _M
