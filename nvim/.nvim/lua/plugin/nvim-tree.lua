local _M = {}

local function resize(size)
  local view = require("nvim-tree.view")
  view.View.width = size
  view.resize()
end

function _M.resize(size)
  local width = tonumber(size) + vim.api.nvim_win_get_width(0)
  resize(width)
end

function _M.reset_size()
  local default_width = 30
  resize(default_width)
end

function _M.refresh()
  local view = require('nvim-tree.view')
  if view.win_open() then
    require("nvim-tree.lib").refresh_tree()
  end
end

function _M.config()
  vim.g.nvim_tree_disable_default_keybindings = 1 -- Disable default keybindings
  vim.g.nvim_tree_special_files = {}
  vim.g.nvim_tree_git_hl = 1
  vim.g.nvim_tree_disable_window_picker = 1
  vim.g.nvim_tree_window_picker_exclude = {
    ["filetype"] = { "notify", "packer", "qf", "Outline" },
    ["buftype"] = { "terminal" }
  }
  vim.g.nvim_tree_icons = {
    default = '',
    symlink = '',
    git = {
      -- unstaged = "✗",
      unstaged = "+",
      -- staged = "✓",
      staged = "",
      unmerged = "",
      renamed = "➜",
      -- untracked = "★",
      untracked = "*",
      deleted = "",
      -- ignored = "◌"
      ignored = ""
    },
    folder = {
      arrow_open = "",
      arrow_closed = "",
      default = "",
      open = "",
      empty = "",
      empty_open = "",
      symlink = "",
      symlink_open = "",
    }
  }
  local tree = require('nvim-tree')
  local tree_cb = require('nvim-tree.config').nvim_tree_callback
  tree.setup({
    -- Completely disable netrw
    disable_netrw = false,
    -- Hijack netrw window on startup
    hijack_netrw = true,
    -- open the tree when running this setup function
    open_on_setup = false,
    -- hijack the cursor in the tree to put it at the start of the filename
    hijack_cursor = true,
    -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
    update_cwd = true,
    -- closes neovim automatically when the tree is the last **WINDOW** in the view
    auto_close = false,
    view = {
      auto_resize = true,
      mappings = {
        list = {
          { key = {"<CR>", "<2-LeftMouse>"}, cb = tree_cb("edit") },
          { key = "+", cb = "<cmd>lua require('plugin/nvim-tree').resize('+10')<cr>" },
          { key = "-", cb = "<cmd>lua require('plugin/nvim-tree').resize('-10')<cr>" },
          { key = "=", cb = "<cmd>lua require('plugin/nvim-tree').reset_size()<cr>" },
          { key = "<C-[>", cb = tree_cb("dir_up") },
          { key = "nv", cb = tree_cb("vsplit") },
          { key = "nh", cb = tree_cb("split") },
          { key = "nt", cb = tree_cb("tabnew") },
          { key = "o", cb = tree_cb("system_open") },
          { key = "v", cb = tree_cb("vsplit") },
          { key = "s", cb = tree_cb("split") },
          { key = "t", cb = tree_cb("tabnew") },
          { key = "<F3>", cb = "<c-w>l<cr>" },
          { key = "<esc>", cb = "" },
        }
      }
    },
    update_focused_file = {
      enable      = false,
      update_cwd  = false
    },
    diagnostics = {
      enable = true,
      icons = {
        hint = "",
        info = "",
        warning = "",
        error = "",
      }
    },
  })

  -- Keybindings
  local map = require('util').keymap
  map("n", "<F2>", ":NvimTreeToggle<cr>")
  map("n", "<F3>", ":NvimTreeFindFile<cr>")
  map("i", "<F2>", "<esc>:NvimTreeToggle<cr>")
  map("i", "<F3>", "<esc>:NvimTreeFindFile<cr>")
  map("v", "<F2>", "<esc>:NvimTreeToggle<cr>")
  map("v", "<F3>", "<esc>:NvimTreeFindFile<cr>")


  -- Automatically refresh tree
  vim.cmd([[
  augroup AutoRefreshNvimTree
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * lua require('plugin/nvim-tree').refresh()
  augroup end
  ]])
end

return _M
