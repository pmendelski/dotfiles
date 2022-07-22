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
  if view.is_visible() then
    require("nvim-tree.lib").refresh_tree()
  end
end

function _M.config()
  local function custom_callback(callback_name)
    return string.format(":lua require('plugin/nvim-tree/telescope').%s()<CR>", callback_name)
  end
  local tree = require('nvim-tree')
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
    view = {
      width = 30,
      mappings = {
        custom_only = true,
        list = {
          { key = {"<CR>", "<2-LeftMouse>"}, action = "edit" },
          { key = "+", cb = "<cmd>lua require('plugin/nvim-tree/config').resize('+10')<cr>" },
          { key = "-", cb = "<cmd>lua require('plugin/nvim-tree/config').resize('-10')<cr>" },
          { key = "=", cb = "<cmd>lua require('plugin/nvim-tree/config').reset_size()<cr>" },
          { key = "<C-[>", action = "dir_up" },
          { key = "<C-]>", action = "cd" },
          { key = "nv", action = "vsplit" },
          { key = "nh", action = "split" },
          { key = "nt", action = "tabnew" },
          { key = "o", action = "system_open" },
          { key = "v", action = "vsplit" },
          { key = "s", action = "split" },
          { key = "t", action = "tabnew" },
          { key = "<F3>", cb = "<c-w>l<cr>" },
          { key = "<esc>", cb = "" },
          { key = "<c-f>", cb = custom_callback "find_files" },
          { key = "<c-g>", cb = custom_callback "live_grep" },
        }
      }
    },
    update_focused_file = {
      enable = false,
      update_cwd = false
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
    renderer = {
      highlight_git = true,
      special_files = {},
      icons = {
        glyphs = {
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
      }
    },
    actions = {
      open_file = {
        window_picker = {
          exclude = {
            ["filetype"] = { "notify", "packer", "qf", "Outline" },
            ["buftype"] = { "terminal" }
          }
        }
      }
    }
  })

  -- Keybindings
  local map = require('util').keymap
  map("n", "<F2>", ":NvimTreeToggle<cr>")
  map("n", "<F3>", ":NvimTreeFindFile<cr>:NvimTreeFocus<cr>:NvimTreeRefresh<cr>")
  map("i", "<F2>", "<esc>:NvimTreeToggle<cr>")
  map("i", "<F3>", "<esc>:NvimTreeFindFile<cr>:NvimTreeFocus<cr>:NvimTreeRefresh<cr>")
  map("v", "<F2>", "<esc>:NvimTreeToggle<cr>")
  map("v", "<F3>", "<esc>:NvimTreeFindFile<cr>:NvimTreeFocus<cr>:NvimTreeRefresh<cr>")
end

return _M
