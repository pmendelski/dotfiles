---Test-file detection, used to keep test noise out of picker results.
local M = {}

---Globs passed to ripgrep/fd (`-g !<glob>`) by the `files` and `grep` sources.
M.globs = {
  "**/test/**",
  "**/tests/**",
  "**/__tests__/**",
  "**/spec/**",
  "**/testdata/**",
  "**/*_test.*",
  "**/*_spec.*",
  "**/*.test.*",
  "**/*.spec.*",
  "**/test_*.py",
}

---Matched against the whole (normalized) path.
M.dir_patterns = {
  "/tests?/",
  "/__tests__/",
  "/spec/",
  "/testdata/",
}

---Matched against the file name only.
M.file_patterns = {
  "_test%.", -- go, python, rust
  "_spec%.", -- ruby, elixir
  "%.test%.", -- js/ts
  "%.spec%.", -- js/ts
  "^test_", -- python
  "Tests?%.%w+$", -- java, c#
}

---@param path? string
---@return boolean
function M.is_test(path)
  if not path or path == "" then
    return false
  end
  path = vim.fs.normalize(path)
  for _, pattern in ipairs(M.dir_patterns) do
    if path:find(pattern) then
      return true
    end
  end
  local name = vim.fs.basename(path)
  for _, pattern in ipairs(M.file_patterns) do
    if name:find(pattern) then
      return true
    end
  end
  return false
end

---Whether a directory sits in the test tree. `dir_patterns` need separators on
---both sides, which a bare directory path lacks.
---@param path? string
---@return boolean
function M.is_test_dir(path)
  if not path or path == "" then
    return false
  end
  -- `is_test` normalizes, which strips the trailing separator `dir_patterns`
  -- need, so match them here instead of delegating
  local dir = "/" .. (vim.fs.normalize(path):gsub("^/+", ""):gsub("/+$", "")) .. "/"
  for _, pattern in ipairs(M.dir_patterns) do
    if dir:find(pattern) then
      return true
    end
  end
  return false
end

---Whether pickers currently hide test files. Unset means hidden: the filter is
---on by default and `<a-t>` / `<a-q>` flip the global for the rest of the session.
---@return boolean
function M.hidden()
  return vim.g.picker_hide_tests ~= false
end

return M
