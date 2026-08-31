---Import-statement detection, used to keep import lines out of LSP references.
---Unlike test files this is a property of the referencing *line*, not the path,
---so it is matched against `item.line`.
local M = {}

---Matched against the text of the referencing line.
M.patterns = {
  "^%s*import[%s(]", -- ts, js, java, kotlin, dart, go, python
  "^%s*from%s+[^%s]+%s+import[%s(*]", -- python
  "^%s*export%s.*%sfrom%s", -- ts re-export
  "^%s*use%s+[%w_:{]", -- rust
  "^%s*pub%s+use%s", -- rust re-export
  "^%s*pub%b()%s+use%s", -- rust `pub(crate) use`, `pub(in path) use`
  "^%s*using%s+[%w_]", -- c#
  "^%s*#include%s", -- c, c++
  "^%s*require%s*%(", -- js, lua
  "=%s*require%s*%(", -- js, lua assignment
}

---How far back to look for the start of a multi-line import statement.
M.max_lookback = 30

---@param line? string
---@return boolean
function M.is_import(line)
  if not line or line == "" then
    return false
  end
  for _, pattern in ipairs(M.patterns) do
    if line:find(pattern) then
      return true
    end
  end
  return false
end

---Whether a line leaves a bracket open, i.e. the statement continues below.
---@param line string
---@return boolean
local function unclosed(line)
  local _, opens = line:gsub("[%({%[]", "")
  local _, closes = line:gsub("[%)}%]]", "")
  return opens > closes
end

---@param item snacks.picker.finder.Item
---@param cache table<string, string[]>
---@return string[]?
local function file_lines(item, cache)
  if not item.file then
    return nil
  end
  if not cache[item.file] then
    cache[item.file] = item.buf
        and vim.api.nvim_buf_is_loaded(item.buf)
        and vim.api.nvim_buf_get_lines(item.buf, 0, -1, false)
      or Snacks.picker.util.lines(item.file)
  end
  return cache[item.file]
end

---Whether a reference sits inside an import statement. Handles the
---continuation lines of a braced list, where the keyword is rows above:
---
---    use super::infra::{
---        Repository, RepositoryInner, StorageRepository,   <-- the reference
---    };
---
---@param item snacks.picker.finder.Item
---@param cache? table<string, string[]> per-picker line cache
---@return boolean
function M.is_import_item(item, cache)
  if M.is_import(item.line) then
    return true
  end
  local lnum = item.pos and item.pos[1]
  if not lnum or lnum < 2 then
    return false
  end
  local lines = file_lines(item, cache or {})
  if not lines then
    return false
  end
  for i = lnum - 1, math.max(1, lnum - M.max_lookback), -1 do
    local prev = lines[i]
    if not prev then
      return false
    end
    local trimmed = vim.trim(prev)
    -- a blank line or a finished statement means we are not inside an import
    if trimmed == "" or trimmed:sub(-1) == ";" then
      return false
    end
    if M.is_import(prev) then
      -- only a braced list runs on past its own line
      return unclosed(prev)
    end
  end
  return false
end

---Whether LSP references currently hide import lines. Unset means hidden: the
---filter is on by default and `<a-u>` / `<a-q>` flip the global for the rest of
---the session.
---@return boolean
function M.hidden()
  return vim.g.picker_hide_imports ~= false
end

return M
