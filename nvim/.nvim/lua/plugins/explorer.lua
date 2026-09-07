local function focus_filetype(ft)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == ft then
      vim.api.nvim_set_current_win(win)
      return true
    end
  end
  return false
end

local function focus()
  local explorer = require("snacks").explorer
  local explorer_ft = "snacks_picker_list"
  if vim.bo.filetype == explorer_ft then
    vim.cmd("wincmd p")
  elseif not focus_filetype("snacks_picker_list") then
    explorer.open()
  end
end

local function toggle()
  local explorer = require("snacks").explorer
  explorer.open()
end

--- The directory an explorer action is scoped to, and a label naming it.
--- Scoped pickers otherwise look identical to unscoped ones -- a bare `Files`
--- covers one directory or the whole tree with no way to tell -- which also
--- hides the case where the cursor sat on the root (or on a top-level file,
--- whose parent *is* the root) and nothing actually got narrowed.
---@param explorer snacks.Picker
---@param item snacks.picker.Item
---@return string dir, string label
local function scope(explorer, item)
  local dir = Snacks.picker.util.dir(item)
  local root = explorer:cwd()
  -- `math.huge` makes truncpath relativize (cwd / git root / ~) without truncating
  local label = dir == root and "<root>"
    or Snacks.picker.util.truncpath(dir, math.huge, { cwd = root }) .. "/"
  return dir, label
end

local code = require("util.code")

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".git" },
          layout = {
            cycle = false,
            auto_hide = { "input" },
          },
          win = {
            input = {
              keys = {
                ["<ESC>"] = false,
              },
            },
            list = {
              keys = {
                ["<ESC>"] = false,
                -- Single letters, not `<leader>x`: a `<leader>` map here shadows
                -- the global `<leader>x…` group for `timeoutlen`, so a moment's
                -- hesitation fires this instead of the global keymap you meant.
                -- `g` is deliberately not used -- it is the prefix of `gg`.
                -- Scoped grep already lives on the built-in `<leader>/`.
                ["t"] = "run_tests",
                ["f"] = "picker_files",
                ["s"] = "lsp_symbols_dir",
              },
            },
          },
          actions = {
            -- `Snacks.picker.actions.picker` (the built-in `picker_files`) passes
            -- `on_show = function() explorer:close() end`, so drilling into a
            -- directory closes the sidebar -- behind the new picker's float, so
            -- you only notice once you confirm a file and the float goes away.
            -- Scope the picker the way the built-in `picker_grep` already does
            -- instead, and leave the explorer alone.
            picker_files = function(explorer, item)
              if not item then
                return
              end
              local dir, label = scope(explorer, item)
              Snacks.picker.files({ cwd = dir, title = "Files: " .. label })
            end,
            -- the built-in `picker_grep` already leaves the explorer alone;
            -- overridden only to name the directory it is scoped to
            picker_grep = function(explorer, item)
              if not item then
                return
              end
              local dir, label = scope(explorer, item)
              Snacks.picker.grep({ cwd = dir, title = "Grep: " .. label })
            end,
            run_tests = function(_, item)
              if not item or not item.file then
                vim.notify("Test runner: no item under cursor", vim.log.levels.WARN)
                return
              end
              code.run_tests_at_path(item.file)
            end,
            -- workspace/symbol has no path scope in the LSP spec, so filter
            -- results client-side instead of via the (unavailable) filter.cwd
            lsp_symbols_dir = function(explorer, item)
              if not item then
                return
              end
              local dir, label = scope(explorer, item)
              -- `snacks.picker.core.filter` takes its LSP context from
              -- `nvim_get_current_buf()` and offers no way to override it. Here
              -- that is the explorer's own `nofile` list buffer, which has no
              -- client attached, so no server is ever asked and the picker comes
              -- up empty. Open it from the main window, which holds a real file.
              vim.api.nvim_win_call(explorer.main, function()
                Snacks.picker.lsp_workspace_symbols({
                  title = "Symbols: " .. label,
                  transform = function(it)
                    local file = it.file and vim.fs.normalize(it.file)
                    return file ~= nil and (file == dir or file:find(dir .. "/", 1, true) == 1)
                  end,
                })
              end)
            end,
          },
        },
      },
    },
  },
  keys = {
    { "<F3>", focus, mode = { "n", "x", "i" }, desc = "Explorer: Toggle focus" },
    { "<F4>", toggle, mode = { "n", "x", "i" }, desc = "Explorer: Toggle" },
  },
}
