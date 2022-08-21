local _M = {}

function _M.keymap()
  local remap = vim.api.nvim_set_keymap
  remap('n', '<F10>', ':Format<cr>', { noremap = true, silent = true })
  remap('x', '<F10>', ':Format<cr>', { noremap = true, silent = true })

  -- vim.api.nvim_exec([[
  --   augroup FormatAutogroup
  --     autocmd!
  --     autocmd BufWritePost c,cpp,css,html,javascript, FormatWrite
  --   augroup END
  -- ]], true)
end

function _M.config()
  require('formatter.util').print = function() end
  -- Configure formatters
  local formatter = require('formatter')
  local formatter_config = {}

  formatter_config['c'] = {
    function()
      return {
        exe = 'clang-format',
        args = { '--style=LLVM' },
        stdin = true,
        ignore_exitcode = true
      }
    end
  }

  formatter_config['cpp'] = {
    function()
      return {
        exe = 'clang-format',
        args = { '--style=LLVM' },
        stdin = true,
        ignore_exitcode = true
      }
    end
  }

  formatter_config['css'] = {
    function()
      return {
        exe = 'prettier',
        args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote' },
        stdin = true,
        ignore_exitcode = true
      }
    end
  }

  formatter_config['html'] = {
    function()
      return {
        exe = 'prettier',
        args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote' },
        stdin = true,
        ignore_exitcode = true
      }
    end
  }

  formatter_config['javascript'] = {
    function()
      return {
        exe = 'prettier',
        args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote' },
        stdin = true,
        ignore_exitcode = true
      }
    end
  }

  formatter_config['json'] = {
    function()
      return {
        exe = 'prettier',
        args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote' },
        stdin = true,
        ignore_exitcode = true
      }
    end
  }

  formatter_config['lua'] = {
    function()
      return {
        exe = 'luafmt',
        args = { '--indent-count', 2, '--stdin' },
        stdin = true
      }
    end
  }

  formatter_config['php'] = {
    function()
      return {
        exe = 'prettier',
        args = { '--stdin-filepath', vim.api.nvim_buf_get_name(0), '--single-quote' },
        stdin = true
      }
    end
  }

  formatter_config['python'] = {
    function()
      return {
        exe = 'black',
        args = { '-' },
        stdin = true
      }
    end
  }

  formatter_config['rust'] = {
    function()
      return {
        exe = 'rustfmt',
        args = { '--edition=2018', '--emit=stdout' },
        stdin = true
      }
    end
  }

  formatter_config['go'] = {
    function()
      return {
        exe = 'goimports',
        stdin = true
      }
    end
  }

  formatter.setup({
    logging = false,
    filetype = formatter_config
  })
end

return _M
