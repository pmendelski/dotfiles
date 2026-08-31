---Composes the optional picker noise filters (test files, import lines) into
---the two mechanisms snacks understands:
---  * `filter.filter` -- a Lua predicate, honoured by the LSP location pickers
---  * `exclude`       -- rg/fd globs, the only thing the files/grep sources read
local imports = require("util.imports")
local tests = require("util.tests")

local M = {}

---Whether the search is already about tests, in which case hiding them would
---only get in the way: `gr` on a symbol from a test file, or a search scoped to
---a test directory (`<leader>f` on `tests/` in the explorer). Decided once per
---picker -- `apply` runs again on every refresh, by which time the current
---buffer is the picker's own input window.
---@param opts snacks.picker.Config
---@return boolean
local function test_context(opts)
  if opts.test_context == nil then
    local dirs = vim.deepcopy(opts.dirs or {})
    dirs[#dirs + 1] = opts.cwd
    opts.test_context = tests.is_test(vim.api.nvim_buf_get_name(0))
    for _, dir in ipairs(dirs) do
      opts.test_context = opts.test_context or tests.is_test_dir(dir)
    end
  end
  return opts.test_context
end

---The global switches behind the filters. Both hide by default; the `<a-t>` /
---`<a-u>` / `<a-q>` picker actions flip them and the change persists for every
---picker opened afterwards. `applies` decides which sources each one touches.
M.flags = {
  hide_tests = {
    var = "picker_hide_tests",
    hidden = tests.hidden,
    -- The explorer is a file tree, not a result list. Excluding directories
    -- there would make tests unreachable by navigation, not merely quieter.
    applies = function(source)
      return source ~= "explorer"
    end,
    relax = test_context,
  },
  hide_imports = {
    var = "picker_hide_imports",
    hidden = imports.hidden,
    -- `gd`/`gI`/`gy` can legitimately land on an import line (Go jumps to the
    -- import spec for a package name), so references only.
    applies = function(source)
      return source == "lsp_references"
    end,
  },
}

---@param key "hide_tests"|"hide_imports"
---@return boolean
function M.hidden(key)
  return M.flags[key].hidden()
end

---Whether a filter has any effect on this source at all.
---@param key "hide_tests"|"hide_imports"
---@param source? string
---@return boolean
function M.applies(key, source)
  return M.flags[key].applies(source)
end

---What a filter actually does in this picker: the global switch, unless the
---search is already about tests, unless the user pressed the key right here.
---@param key "hide_tests"|"hide_imports"
---@param opts snacks.picker.Config
---@return boolean
function M.effective(key, opts)
  if not M.applies(key, opts.source) then
    return false
  end
  local override = opts.filter_override and opts.filter_override[key]
  if override ~= nil then
    return override
  end
  local flag = M.flags[key]
  return M.hidden(key) and not (flag.relax and flag.relax(opts))
end

---@param key "hide_tests"|"hide_imports"
---@param hide boolean
function M.set(key, hide)
  vim.g[M.flags[key].var] = hide
end

---Add or remove the active filters on a picker config.
---@param opts snacks.picker.Config
---@return snacks.picker.Config
function M.apply(opts)
  -- what each filter does here; the toggle actions read these back
  opts.hide_tests = M.effective("hide_tests", opts)
  opts.hide_imports = M.effective("hide_imports", opts)

  opts.base_exclude = opts.base_exclude or vim.deepcopy(opts.exclude or {})
  opts.exclude = opts.hide_tests and vim.list_extend(vim.deepcopy(opts.base_exclude), tests.globs) or opts.base_exclude

  local preds = {} ---@type fun(item:snacks.picker.finder.Item):boolean[]
  if opts.hide_tests then
    preds[#preds + 1] = function(item)
      return not tests.is_test(item.file)
    end
  end
  if opts.hide_imports then
    -- detecting multi-line imports needs the surrounding lines; cache them for
    -- the lifetime of this config, so a refresh re-reads changed files
    local lines = {} ---@type table<string, string[]>
    preds[#preds + 1] = function(item)
      return not imports.is_import_item(item, lines)
    end
  end

  -- Replace rather than mutate: `opts.filter` may be shared with the source
  -- config (lsp_symbols passes LazyVim's kind_filter there).
  local filter = vim.tbl_extend("force", {}, opts.filter or {})
  filter.filter = nil
  if #preds > 0 then
    filter.filter = function(item)
      for _, pred in ipairs(preds) do
        if not pred(item) then
          return false
        end
      end
      return true
    end
  end
  opts.filter = filter

  return opts
end

return M
