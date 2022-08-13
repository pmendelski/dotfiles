-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()

-- Disable these for very fast startup time
vim.cmd([[
  syntax off
  filetype off
  filetype plugin indent off
]])

-- Temporarily disable shada file to improve performance
vim.opt.shadafile = "NONE"

-- Disable built in plugins
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "gzip",
  "zip",
  "zipPlugin",
  "tar",
  "tarPlugin",
  "getscript",
  "getscriptPlugin",
  "vimball",
  "vimballPlugin",
  "2html_plugin",
  "logipat",
  "rrhelper",
  "spellfile_plugin",
  "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end

-- Detect stdin mode
vim.cmd([[
  let g:stdin_mode = 0
  augroup StdIn
    autocmd!
    autocmd StdinReadPre * let g:stdin_mode = 1
  augroup END
]])

-- Detect single file mode
vim.g.single_file_mode = 0
local argv = vim.api.nvim_eval("argv()")
if #argv == 1 and vim.fn.filereadable(argv[1]) == 1 then
  vim.g.single_file_mode = 1
end

-- Load Essentials
require('settings')
require('automatic')

-- Lazy-load Others
vim.defer_fn(function()
  require('keybindings')
  require('plugins')

  -- Restore options after initialziations
  vim.opt.shadafile = ""
  require('filetype')

  print("Lazy Loaded in " .. vim.fn.printf("%.3f",vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))) .. "s")
end, 0)
print("Loaded in " .. vim.fn.printf("%.3f",vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))) .. "s")
