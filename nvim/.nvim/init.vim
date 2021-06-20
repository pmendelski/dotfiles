" After adding new plugin run:
"  :PlugInstall
" Required at the top by vim-polyglot
set nocompatible
runtime bundles/vim-plug/plug.vim
call plug#begin('~/.nvim/plugins')
" Colorscheme
Plug 'joshdick/onedark.vim'
" Nice status bar
Plug 'itchyny/lightline.vim'
" Git branchname in statusbar
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Devicons
Plug 'ryanoasis/vim-devicons'
" Autocomplete
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
" Code comments
Plug 'tpope/vim-commentary'
" Syntax highlight
Plug 'sheerun/vim-polyglot'
" Automatically change directory to project root
Plug 'airblade/vim-rooter'
" Editor config
Plug 'editorconfig/editorconfig-vim'
" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Swap function arguments
Plug 'machakann/vim-swap'
" Expand selected region
Plug 'terryma/vim-expand-region'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
" Debugging
Plug 'puremourning/vimspector'
call plug#end()

set encoding=utf8
set shell=/usr/bin/zsh  " use zsh for executing shell commands
set hidden              " TextEdit might fail if hidden is not set.
set mouse=a             " enable mouse in all in all modes
set nocompatible        " some compatybility issues
set ttyfast             " send more characters at a given time
set lazyredraw
set synmaxcol=500
set guioptions-=T       " Remove toolbar
set noswapfile          " No swap files
set undofile            " persistent Undo
set visualbell          " use visual bell instead of audible bell (anoying)
set number              " Also show current absolute line
set updatetime=100

" Keybindings
let mapleader = "\<space>"
set whichwrap+=<,>,h,l,[,],<>

" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=iwhite     " No whitespace in vimdiff
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

" Custom locations
set directory=~/.nvim/tmp/swaps//
set backupdir=~/.nvim/tmp/backups
set undodir=~/.nvim/tmp/undo
set clipboard^=unnamed,unnamedplus " use system clipboard by default
set colorcolumn=100     " and give me a colored column
set showcmd             " show (partial) command in status line.
set completeopt=longest,menuone
set splitbelow          " :new should open split below
set splitright          " :vnew should open split on the right

" Print options
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter

" Decent wildmenu
set wildmenu
set wildmode=longest:full,full
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Search and replace
" Present substitutions in realtime
set inccommand=nosplit
" Search results centered
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/
" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" History
set hidden              " when a buffer is brought to foreground, remember undo history and marks
set history=1000        " increase history from 20 default to 1000

" Wrapping, spaces & tabs
set nowrap
set nocompatible        " Because filetype detection doesn't work well in compatible mode
filetype indent on      " load filetype-specific indent files
filetype plugin on      " load filetype-specific plugins
set autoindent          " copy indent from last line when starting new line
set copyindent
set backspace=indent,eol,start
set expandtab           " use spaces for tabs
set shiftwidth=4
set softtabstop=4       " number of spaces in tab when editing
set tabstop=4           " number of visual spaces per TAB

" Show white characters
set listchars=space:·,eol:¬,tab:>·,trail:•,extends:»,precedes:« " secure mapping for white characters
set list                " by default present whitecharacters

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines


" External configs
runtime configs/code.vim
runtime configs/expand.vim
runtime configs/explorer.vim
runtime configs/file-types.vim
runtime configs/files.vim
runtime configs/folding.vim
runtime configs/git.vim
runtime configs/keybindings.vim
runtime configs/refresh.vim
runtime configs/sessions.vim
runtime configs/statusline.vim
runtime configs/terminal.vim
runtime configs/theme.vim
" }}}
