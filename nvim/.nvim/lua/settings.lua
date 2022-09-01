-- Neovim API aliases
-----------------------------------------------------------
local fn = vim.fn
local g = vim.g
local opt = vim.opt

-- General
-----------------------------------------------------------
g.mapleader = ' ' -- change leader to a space
opt.encoding = 'utf8' -- utf8 by default
opt.mouse = 'a' -- enable mouse in all in all modes
opt.clipboard = 'unnamed,unnamedplus' -- copy/paste to system clipboard
opt.compatible = false -- some compatybility issues
opt.updatetime = 150

-- UI
-----------------------------------------------------------
opt.whichwrap = opt.whichwrap + '<,>,h,l,[,],<>'
opt.visualbell = true -- use visual bell instead of audible bell (anoying)
opt.number = true -- show line number
opt.showmatch = true -- highlight matching parenthesis
opt.foldmethod = 'marker' -- enable folding (default 'foldmarker')
opt.colorcolumn = '100' -- line lenght marker at 100 columns
opt.splitright = true -- vertical split to the right
opt.splitbelow = true -- horizontal split to the bottom
opt.showcmd = true -- show (partial) command in status line
opt.completeopt = 'menu,menuone,noselect' -- autocompletion settings
opt.ttyfast = true -- send more characters at a given time
opt.lazyredraw = true -- faster scrolling
opt.synmaxcol = 500 -- max column for syntax highlight
opt.termguicolors = true -- enable 24-bit RGB colors
opt.cursorline = true
opt.shortmess = opt.shortmess + 'c' -- avoid showing extra messages when using completion

-- History
-----------------------------------------------------------
opt.hidden = true -- when a buffer is brought to foreground, remember undo history and marks
opt.history = 1000 -- increase history from 20 default to 1000

-- Search & replace
-----------------------------------------------------------
opt.inccommand = 'nosplit' -- present substitutions in realtime
opt.ignorecase = true -- ignore case letters when search
opt.smartcase = true -- ignore lowercase for the whole pattern
opt.incsearch = true
opt.gdefault = true

-- Make diffing better
-- https://vimways.org/2018/the-power-of-diff/
-----------------------------------------------------------
opt.diffopt = opt.diffopt + 'filler'
opt.diffopt = opt.diffopt + 'iwhite'
opt.diffopt = opt.diffopt + 'algorithm:patience'
opt.diffopt = opt.diffopt + 'indent-heuristic'

-- Temporary files
-----------------------------------------------------------
opt.swapfile = false -- don't use swapfile
opt.undofile = true -- persistent Undo
opt.directory = fn.expand('~/.nvim/tmp/swap')
opt.backupdir = fn.expand('~/.nvim/tmp/backup')
opt.undodir = fn.expand('~/.nvim/tmp/undo')
opt.viewdir = fn.expand('~/.nvim/tmp/view')

-- Wildmenu
-----------------------------------------------------------
opt.wildmenu = true
opt.wildmode = 'longest:full,full'
opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor'

-- Print options
-----------------------------------------------------------
opt.printfont = ':h10'
opt.printencoding = 'utf-8'
opt.printoptions = 'paper:A4'

-- Wrapping, spaces & tabs
-----------------------------------------------------------
opt.autoindent = true -- copy indent from last line when starting new line
opt.copyindent = true
opt.backspace = 'indent,eol,start'
-- opt.expandtab = true      -- use spaces for tabs
opt.shiftwidth = 4
opt.softtabstop = 4 -- number of spaces in tab when editing
opt.tabstop = 4 -- number of visual spaces per TAB
-- Wrapping options
opt.wrap = false
opt.formatoptions = opt.formatoptions + 'tc' -- wrap text and comments using textwidth
opt.formatoptions = opt.formatoptions + 'r' -- continue comments when pressing ENTER in I mode
opt.formatoptions = opt.formatoptions + 'q' -- enable formatting of comments with gq
opt.formatoptions = opt.formatoptions + 'n' -- detect lists for formatting
opt.formatoptions = opt.formatoptions + 'b' -- auto-wrap in insert mode, and do not wrap old long lines
-- Whitespace characters
opt.list = true -- by default present whitecharacters
opt.listchars = 'space:·,eol:¬,tab:▸ ,nbsp:_,trail:·,extends:»,precedes:«' -- secure mapping for white characters

-- Spellcheck
-----------------------------------------------------------
opt.spelllang = 'en,cjk'

-- Signs
-----------------------------------------------------------
vim.o.signcolumn = 'yes'
