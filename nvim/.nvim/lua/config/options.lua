-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Propagate globals
-----------------------------------------------------------
local envflag = function(name, default)
  local raw = os.getenv(name)
  if raw == nil then
    return default
  end
  return raw == "true" or raw == "1"
end

vim.g.term_nerd_font_enabled = envflag("TERM_NERD_FONT_ENABLED", true)
vim.g.term_unicodes_enabled = envflag("TERM_UNICODES_ENABLED", true)
vim.g.term_colors = tonumber(os.getenv("TERM_COLORS") or "256")

vim.g.nvim_light = envflag("NVIM_LIGHT", false)
vim.g.nvim_ai_enabled = not vim.g.is_light and envflag("NVIM_AI_ENABLED", false)

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

-- Use absolute line numbers
-----------------------------------------------------------
vim.opt.number = true -- Enable line numbers
vim.opt.relativenumber = false -- Disable relative numbers

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
