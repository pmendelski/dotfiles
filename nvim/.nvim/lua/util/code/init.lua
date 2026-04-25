local M = {}

local langs = {
  rust = require("util.code.rust"),
  go   = require("util.code.go"),
}

local last_term = nil

local function run(cmd)
  if last_term then
    pcall(function() last_term:close() end)
    last_term = nil
  end
  last_term = require("snacks").terminal(cmd, { win = { style = "split" }, auto_close = false })
end

local function lang()
  return langs[vim.bo.filetype]
end

local function unsupported()
  vim.notify("Test runner: unsupported filetype " .. vim.bo.filetype, vim.log.levels.WARN)
end

-- Run the test function nearest to the cursor.
function M.run_test_at_cursor()
  local l = lang()
  if not l then return unsupported() end
  local name = l.nearest_test_name()
  if not name then
    vim.notify("No test function found near cursor", vim.log.levels.WARN)
    return
  end
  run(l.cmd_for_test(vim.fn.expand("%:p"), name))
end

-- Run all tests in the current file.
function M.run_tests_in_file()
  local l = lang()
  if not l then return unsupported() end
  run(l.cmd_for_file(vim.fn.expand("%:p")))
end

-- Run all tests under `dir` recursively.
function M.run_tests_in_dir(dir)
  if vim.fn.glob(dir .. "/**/*.rs") ~= "" then
    run(langs.rust.cmd_for_dir(dir))
  elseif vim.fn.glob(dir .. "/**/*.go") ~= "" then
    run(langs.go.cmd_for_dir(dir))
  else
    vim.notify("Test runner: no Rust or Go files found in " .. dir, vim.log.levels.WARN)
  end
end

-- Run tests for a path: all tests in the file if it's a file, or recursively if it's a dir.
function M.run_tests_at_path(path)
  if vim.fn.isdirectory(path) == 1 then
    M.run_tests_in_dir(path)
  else
    local ext = path:match("%.(%w+)$")
    local ft = ({ rs = "rust", go = "go" })[ext]
    local l = ft and langs[ft]
    if not l then
      vim.notify("Test runner: unsupported file type for " .. path, vim.log.levels.WARN)
      return
    end
    run(l.cmd_for_file(path))
  end
end

return M
