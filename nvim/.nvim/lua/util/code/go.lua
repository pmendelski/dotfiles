local M = {}

-- Return the name of the test function nearest to (and above) the cursor.
function M.nearest_test_name()
  for i = vim.fn.line("."), 1, -1 do
    local name = vim.fn.getline(i):match("^func%s+([%w_]+)")
    if name then return name end
  end
end

-- Command to run all tests in a file (i.e. the file's package).
function M.cmd_for_file(file)
  local rel = vim.fn.fnamemodify(vim.fn.fnamemodify(file, ":h"), ":.")
  return "go test -v ./" .. rel
end

-- Command to run a single named test in a file.
function M.cmd_for_test(file, name)
  local rel = vim.fn.fnamemodify(vim.fn.fnamemodify(file, ":h"), ":.")
  return "go test -v -run ^" .. name .. "$ ./" .. rel
end

-- Command to run all tests under a directory recursively.
function M.cmd_for_dir(dir)
  local rel = vim.fn.fnamemodify(dir, ":.")
  return "go test -v ./" .. rel .. "/..."
end

return M
