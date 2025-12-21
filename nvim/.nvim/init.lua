-- Store startup time in seconds
vim.g.start_time = vim.fn.reltime()

-- Load configs and plugins
require("settings")
require("automatic")
require("keybindings")
require("filetype")
require("plugins")

-- To see startup times run :messages
print("Loaded in " .. vim.fn.printf("%.3f", vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))) .. "s")
