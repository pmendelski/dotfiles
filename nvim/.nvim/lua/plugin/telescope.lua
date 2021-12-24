local _M = {}

function _M.keymap()
  local map = require('util').keymap
  map('n', '<leader>fx', ':Telescope<cr>')
  map('n', '<leader>ff', ':Telescope find_files<cr>')
  map('n', '<leader>fb', ':Telescope buffers<cr>')
  map('n', '<leader>fc', ':Telescope current_buffer_fuzzy_find<cr>')
  map('n', '<leader>fg', ':Telescope live_grep<cr>')
  map('n', '<leader>fp', ':Telescope project<cr>')
  map('n', '<leader>fm', ':Telescope media_files<cr>')
  map('n', '<leader>fh', ':Telescope heading<cr>')
  map('n', '<leader>fs', ":lua require('telescope.builtin').symbols({ sources = {'emoji', 'kaomoji', 'gitmoji'} })<cr>")
  -- lsp
  map('n', '<leader>c', '') -- added to not trigger change command by mistake
  map('n', '<leader>cd', ':Telescope lsp_document_symbols<cr>')
  map('n', '<leader>cc', ':Telescope lsp_workspace_symbols<cr>')
  map('n', '<leader>cr', ':Telescope lsp_references<cr>')
  map('n', '<leader>ca', ':Telescope lsp_code_actions<cr>')
  map('n', '<leader>cx', ':Telescope diagnostics<cr>')
  map('n', '<leader>cz', ':Telescope lsp_implementations<cr>')
  map('n', '<leader>cZ', ':Telescope lsp_definitions<cr>')
end

function _M.config()
  local actions = require('telescope.actions')
  local telescope = require('telescope')
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close
        },
        n = {
          ['q'] = actions.close
        },
      },
    },
    extensions = {
      media_files = {
        -- defaults to {'png', 'jpg', 'mp4', 'webm', 'pdf'}
        filetypes = {'png', 'webp', 'jpg', 'jpeg', 'mp4', 'webm', 'pdf'},
        -- defaults to `fd`)
        find_cmd = 'rg'
      },
      project = {
        base_dirs = {
          {'~/Development', max_depth = 4},
        }
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        }
      }
    }
  })
  telescope.load_extension('ui-select')
  telescope.load_extension('fzf')
  telescope.load_extension('project')
  telescope.load_extension('media_files')
  telescope.load_extension('heading')
end

return _M
