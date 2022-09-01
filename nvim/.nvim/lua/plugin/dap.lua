require("dap")

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointSign", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStoppedSign", linehl = "", numhl = "" })
