local _M = {}
local home_dir = vim.fn.expand("~")
local sessions_dir = vim.fn.expand("~/.nvim/tmp/sessions")

local function path_to_name(path)
  return path:gsub('/', '%%') .. '.vim'
end

local function name_to_path(name)
  return name:gsub('%%', '/'):gsub('.vim$', '') .. ''
end

function _M.setup()
  vim.o.sessionoptions='blank,buffers,curdir,folds,help,tabpages'

  -- vim.cmd([[
  -- if exists('g:loaded_auto_session') | finish | endif " prevent loading file twice
  -- let g:in_pager_mode = 0

  -- aug StdIn
  --   autocmd!
  --   autocmd StdinReadPre * let g:in_pager_mode = 1
  -- aug END

  -- augroup SaveRestoreSession
  --   autocmd!
  --   autocmd VimLeave * lua save_session()
  --   autocmd VimEnter * nested lua restore_session()
  -- augroup END

  -- let g:loaded_auto_session = 1
  -- ]])

  -- vim.cmd([[
  --   if exists('g:loaded_auto_session') | finish | endif " prevent loading file twice
  --   let g:in_pager_mode = 0

  --   augroup StdIn
  --     autocmd!
  --     autocmd StdinReadPre * let g:in_pager_mode = 1
  --   augroup END

  --   augroup SaveRestoreSession
  --     autocmd!
  --     autocmd VimLeave * lua require('custom/session').save_session()
  --   augroup END

  --   let g:loaded_auto_session = 1
  -- ]])

  vim.cmd([[
    if exists('g:loaded_auto_session') | finish | endif " prevent loading file twice

    augroup SaveRestoreSession
      autocmd!
      autocmd VimLeave * lua require('custom/session').save_session()
    augroup END

    let g:loaded_auto_session = 1
  ]])
end

function _M.save_session()
  if vim.g.stdin_mode == 1 then return end
  local session_name = path_to_name(vim.fn.getcwd())
  -- save vars
  local tree_opened = require('nvim-tree.view').win_open() and true or false
  local vars = {
    ['nvim-tree_opened'] = tree_opened
  }
  local vars_file = string.format(sessions_dir .. "/%s", session_name:gsub('.vim$', '.var'))
  vim.fn.writefile({ vim.inspect(vars) }, vars_file)
  -- save session
  if tree_opened then require('nvim-tree').close() end
  pcall(vim.cmd, 'bd Neogit*')
  pcall(vim.cmd, 'bd Diffview*')
  local session_file = string.format(sessions_dir .. "/%s", session_name)
  vim.cmd("mksession! " .. session_file:gsub("%%", "\\%%"))
end

function _M.has_session()
  if vim.g.stdin_mode == 1 or vim.g.single_file_mode == 1 then return end
  local session_name = path_to_name(vim.fn.getcwd())
  local session_file = string.format(sessions_dir .. "/%s", session_name)
  return vim.fn.filereadable(session_file) == 1
end

function _M.restore_session()
  if vim.g.stdin_mode == 1 or vim.g.single_file_mode == 1 then return end
  local session_name = path_to_name(vim.fn.getcwd())
  local vars_file = string.format(sessions_dir .. "/%s", session_name:gsub('.vim$', '.var'))
  local session_file = string.format(sessions_dir .. "/%s", session_name)

  if vim.fn.filereadable(session_file) == 1 then
    if not pcall(vim.cmd, "source " .. session_file:gsub("%%", "\\%%")) then
      print("Could not load session: " .. session_name)
    end
    local vars = vim.inspect(vim.fn.readfile(vars_file))
    if vars:find('["nvim-tree_opened"] = true', 1, true) and not require('nvim-tree.view').win_open() then
      require('nvim-tree.view').open({ focus_tree = false })
    end
  end
end

-- Telescope related
-----------------------------------------------------------------

local function get_sessions()
  local sessions = {}
  local cwd = vim.fn.getcwd()
  for _, session_filename in ipairs(vim.fn.readdir(sessions_dir)) do
    local session_path = name_to_path(session_filename)
    if vim.fn.isdirectory(session_path) == 1 and cwd ~= session_path then
      table.insert(sessions, {
        timestamp = vim.fn.getftime(sessions_dir .. "/" .. session_filename),
        filename = session_filename:gsub('.vim$', '')
      })
    end
  end
  table.sort(sessions, function(a, b)
    return a.timestamp > b.timestamp
  end)
  -- If the last session is the current one, then preselect the previous one
  if #sessions >= 2 and sessions[1].filename == vim.fn.getcwd() then
    sessions[1], sessions[2] = sessions[2], sessions[1]
  end
  return sessions
end

local function load_session(session_filename, bang)
  if not session_filename or #session_filename == 0 then
    return
  end

  if not bang or #bang == 0 then
    -- Ask to save files in current session before closing them
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_get_option(buffer, 'modified') then
        local choice = vim.fn.confirm('The files in the current session have changed. Save changes?', '&Yes\n&No\n&Cancel')
        if choice == 3 then
          return -- Cancel
        elseif choice == 1 then
          vim.api.nvim_command('silent wall')
        end
        break
      end
    end
  end

  -- Stop all LSP clients first
  vim.lsp.stop_client(vim.lsp.get_active_clients())

  -- Scedule buffers cleanup to avoid callback issues and source the session
  vim.schedule(function()
    _M.save_session()
    -- Delete all buffers first except the current one to avoid entering buffers scheduled for deletion
    local current_buffer = vim.api.nvim_get_current_buf()
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buffer) and buffer ~= current_buffer then
        vim.api.nvim_buf_delete(buffer, { force = true })
      end
    end
    vim.api.nvim_buf_delete(current_buffer, { force = true })
    vim.cmd(':cd ' .. name_to_path(session_filename))
    _M.restore_session()
  end)
end

function _M.telescope_picker(opts)
  local actions = require('telescope.actions')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local sorters = require('telescope.sorters')
  local themes = require('telescope.themes')
  pickers.new(opts, {
    prompt_title = 'Sessions',
    finder = finders.new_table({
      results = get_sessions(),
      entry_maker = function(entry)
        return {
          value = entry.filename,
          display = os.date('%Y-%m-%d %H:%M', entry.timestamp) .. " " .. name_to_path(entry.filename):gsub(home_dir, "~"),
          ordinal = entry.filename,
        }
      end,
    }),
    sorter = sorters.get_fzy_sorter(),
    attach_mappings = function(prompt_bufnr, map)
      local source_session = function()
        actions.close(prompt_bufnr)
        local entry = actions.get_selected_entry(prompt_bufnr)
        if entry then
          if opts['save_current'] then
            _M.save_session()
          end
          load_session(entry.value)
        end
      end

      actions.select_default:replace(source_session)

      local delete_session = function()
        local entry = actions.get_selected_entry(prompt_bufnr)
        if entry then
          vim.fn.delete(sessions_dir .. entry.value)
          select_session(opts)
        end
      end

      map('n', 'd', delete_session, { nowait = true })
      return true
    end,
  }):find()
end

return _M
