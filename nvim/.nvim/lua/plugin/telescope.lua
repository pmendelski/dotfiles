local _M = {}

function _M.keymap()
  local map = require('util').keymap
  map('n', '<leader>fx', ':Telescope<cr>')
  map('n', '<leader>ff', ':Telescope find_files<cr>')
  map('n', '<leader>fv', ':Telescope git_files<cr>')
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
  local action_layout = require("telescope.actions.layout")
  local telescope = require('telescope')
  local previewers = require("telescope.previewers")

  -- Ignore files bigger than a threshold
  local new_maker = function(filepath, bufnr, opts)
    opts = opts or {}
    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then return end
      if stat.size > 100000 then
        return
      else
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end
    end)
  end

  telescope.setup({
    defaults = {
      buffer_previewer_maker = new_maker,
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-u>"] = false,
          ["<C-Down>"] = actions.cycle_history_next,
          ["<C-Up>"] = actions.cycle_history_prev,
          ["<C-p>"] = action_layout.toggle_preview,
          ["<C-h>"] = "which_key"
        },
        n = {
          ['q'] = actions.close,
          ["<C-p>"] = action_layout.toggle_preview
        }
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim" -- add this value to remove indentation
      }
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
    },
    pickers = {
      lsp_document_symbols = {
        symbol_width = 60,
        symbol_type_width = 100
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
