-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Propagate globals
-----------------------------------------------------------
vim.g.term_nerd_font_enabled = (os.getenv("TERM_NERD_FONT_ENABLED") or "true") == "true"
vim.g.term_unicodes_enabled = (os.getenv("TERM_UNICODES_ENABLED") or "true") == "true"
vim.g.term_colors = tonumber(os.getenv("TERM_COLORS") or "256")

vim.g.nvim_light = (os.getenv("NVIM_LIGHT") or "false") == "true"
vim.g.nvim_ai_enabled = not vim.g.is_light and (os.getenv("NVIM_AI_ENABLED") or "false") == "true"

-- Whitespace characters
-----------------------------------------------------------
vim.o.list = true -- present whitecharacters
vim.o.listchars = "space:·,eol:¬,tab:▸ ,nbsp:_,trail:·,extends:»,precedes:«" -- white characters

-- Movement
-----------------------------------------------------------
vim.opt.whichwrap:append("<,>,h,l,[,],<>") -- move between line from the end an beginning of line

-- Spellcheck
-----------------------------------------------------------
vim.o.spelllang = "en,cjk"

-- Temporary files
-----------------------------------------------------------
vim.o.swapfile = false -- don't use swapfile
vim.o.undofile = true -- persistent Undo
vim.o.directory = vim.fn.expand("~/.nvim/tmp/swap")
vim.o.backupdir = vim.fn.expand("~/.nvim/tmp/backup")
vim.o.undodir = vim.fn.expand("~/.nvim/tmp/undo")
vim.o.viewdir = vim.fn.expand("~/.nvim/tmp/view")

-- Make clipboard work on SSH
-----------------------------------------------------------
if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
vim.opt.clipboard = "unnamedplus"
