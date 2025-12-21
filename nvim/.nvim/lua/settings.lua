-- Neovim API aliases
-----------------------------------------------------------

-- General
-----------------------------------------------------------
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
-- utf8 by default
vim.o.encoding = "utf8"
-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = "a"
-- Don't show the mode, since it's already in the status line
vim.o.showmode = false
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)
-- Decrease update time
vim.o.updatetime = 150
-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
vim.o.confirm = true
-- Detect single file mode
vim.g.single_file_mode = 0
local argv = vim.api.nvim_eval("argv()")
if #argv == 1 and vim.fn.filereadable(argv[1]) == 1 then
	vim.g.single_file_mode = 1
end

-- UI
-----------------------------------------------------------
vim.o.whichwrap = vim.o.whichwrap .. "<,>,h,l,[,],<>"
vim.o.visualbell = true -- use visual bell instead of audible bell (anoying)
vim.o.number = true -- show line numbers
-- vim.o.relativenumber = true -- show relative line numbers
vim.o.breakindent = true -- enable break indent
vim.o.showmatch = true -- highlight matching parenthesis
vim.o.foldmethod = "marker" -- enable folding (default 'foldmarker')
vim.o.colorcolumn = "100" -- line lenght marker at 100 columns
vim.o.signcolumn = "yes" -- always show sign column
vim.o.splitright = true -- vertical split to the right
vim.o.splitbelow = true -- horizontal split to the bottom
vim.o.showcmd = true -- show (partial) command in status line
vim.o.completeopt = "menu,menuone,noselect" -- autocompletion settings
vim.o.ttyfast = true -- send more characters at a given time
vim.o.lazyredraw = true -- faster scrolling
vim.o.synmaxcol = 500 -- max column for syntax highlight
vim.o.termguicolors = true -- enable 24-bit RGB colors
vim.o.cursorline = true
vim.o.scrolloff = 10 -- minimal number of screen lines to keep above and below the cursor
vim.o.shortmess = vim.o.shortmess .. "c" -- avoid showing extra messages when using completion

-- History
-----------------------------------------------------------
vim.o.hidden = true -- when a buffer is brought to foreground, remember undo history and marks
vim.o.history = 1000 -- increase history from 20 default to 1000

-- Search & replace
-----------------------------------------------------------
vim.o.inccommand = "nosplit" -- present substitutions in realtime
vim.o.ignorecase = false -- ignore case letters when search
vim.o.smartcase = true -- ignore lowercase for the whole pattern
vim.o.incsearch = true
vim.o.gdefault = false

-- Temporary files
-----------------------------------------------------------
vim.o.swapfile = false -- don't use swapfile
vim.o.undofile = true -- persistent Undo
vim.o.directory = vim.fn.expand("~/.nvim/tmp/swap")
vim.o.backupdir = vim.fn.expand("~/.nvim/tmp/backup")
vim.o.undodir = vim.fn.expand("~/.nvim/tmp/undo")
vim.o.viewdir = vim.fn.expand("~/.nvim/tmp/view")

-- Wildmenu
-----------------------------------------------------------
vim.o.wildmenu = true
vim.o.wildmode = "longest:full,full"
vim.o.wildignore =
	".hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor"

-- Wrapping, spaces & tabs
-----------------------------------------------------------
vim.o.autoindent = true -- copy indent from last line when starting new line
vim.o.copyindent = true
vim.o.preserveindent = true
vim.o.backspace = "indent,eol,start"
vim.o.expandtab = true -- use spaces for tabs
vim.o.shiftwidth = 4
vim.o.softtabstop = 4 -- number of spaces in tab when editing
vim.o.tabstop = 4 -- number of visual spaces per TAB

-- Wrapping options
vim.o.wrap = false
vim.o.formatoptions = vim.o.formatoptions .. "tc" -- wrap text and comments using textwidth
vim.o.formatoptions = vim.o.formatoptions .. "r" -- continue comments when pressing ENTER in I mode
vim.o.formatoptions = vim.o.formatoptions .. "q" -- enable formatting of comments with gq
vim.o.formatoptions = vim.o.formatoptions .. "n" -- detect lists for formatting
vim.o.formatoptions = vim.o.formatoptions .. "b" -- auto-wrap in insert mode, and do not wrap old long lines

-- Whitespace characters
vim.o.list = true -- present whitecharacters
vim.o.listchars = "space:·,eol:¬,tab:▸ ,nbsp:_,trail:·,extends:»,precedes:«" -- white characters

-- Spellcheck
-----------------------------------------------------------
vim.o.spelllang = "en,cjk,programming"
