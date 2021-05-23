" Tutorial {{{

" Searching inside a file:
" - Search: /<phrase>
" - Next: n
" - Turn off highlight: :noh OR <leader><space>

" Folding in a file:
" - Default folding marker: indentation
" - Fold/unfold: za OR <space>

" Undo/Redo:
" - Undo: u
" - Redo: Ctrl-r
" - Undo line to original state: U

" White characters:
" - Show: :list
" - Hide: :nolist

" Buffers:
" - Switching: Ctrl-^
" - Listing: :buffers
" - Close: :bd OR :bw (:bw writes down changes)

" .vimrc examples:
" https://github.com/paulirish/dotfiles/blob/master/.vimrc
" http://dougblack.io/words/a-good-vimrc.html

" }}}

" Plugins {{{
" Required at the top by vim-polyglot
set nocompatible
runtime bundles/vim-plug/plug.vim
call plug#begin('~/.nvim/plugins')
" Colorscheme
Plug 'joshdick/onedark.vim'
" Nice status bar
Plug 'itchyny/lightline.vim'
" Git branchname in statusbar
Plug 'itchyny/vim-gitbranch'
" Devicons
Plug 'ryanoasis/vim-devicons'
" Autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Code comments
Plug 'tpope/vim-commentary'
" Syntax highlight
Plug 'sheerun/vim-polyglot'
" Automatically change directory to proejct root
Plug 'airblade/vim-rooter'
" Integrate: Editor config
Plug 'editorconfig/editorconfig-vim'
" Integrate: Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Expand selected region
Plug 'terryma/vim-expand-region'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
call plug#end()
"}}}

" Misc {{{
set encoding=utf8
set hidden              " TextEdit might fail if hidden is not set.
set mouse=a             " enable mouse in all in all modes
set nocompatible        " some compatybility issues
set shell=/bin/bash     " use /bin/sh for executing shell commands
set ttyfast             " send more characters at a given time
set guioptions-=T " Remove toolbar
set backupdir=~/.nvim/tmp/backups
set directory=~/.nvim/tmp/swaps
set undodir=~/.nvim/tmp/undo
set undofile            " persistent Undo
set visualbell          " use visual bell instead of audible bell (anoying)
set number              " Also show current absolute line
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=iwhite " No whitespace in vimdiff
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic

set incsearch                   " show search matches as you type

set colorcolumn=100 " and give me a colored column
set showcmd " Show (partial) command in status line.
set completeopt=longest,menuone

if has ('autocmd') " Remain compatible with earlier versions
  augroup vimrc     " Source vim configuration upon save
    autocmd BufWritePost $MYVIMRC ++nested source $MYVIMRC | echom "Reloaded: " . $MYVIMRC
  augroup END
endif " has autocmd

set splitbelow
set splitright
" }}}

" Colors {{{
" terminal compatybility
if !has('gui_running')
  set t_Co=256
endif
if has("nvim")
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if has("termguicolors")
  set termguicolors
endif
set background=dark
syntax on
colorscheme onedark
set cursorline
" }}}

" History {{{
set hidden              " when a buffer is brought to foreground, remember undo history and marks
set history=1000        " increase history from 20 default to 1000
" }}}

" Sessions {{{
let g:session_directory = "~/.nvim/tmp/sessions"
let g:session_autosave='yes'
let g:session_autoload='yes'
au VimLeave * :SaveSession! default
" }}}

" Spaces & Tabs {{{
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
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:< " secure mapping for white characters
" set listchars=space:_,eol:¬,tab:¦\ ,trail:•,extends:»,precedes:« " secure mapping for white characters
set listchars=space:·,eol:¬,tab:>·,trail:•,extends:»,precedes:« " secure mapping for white characters
set list                " by default present whitecharacters
" }}}

" Folding, Plugins, Filetypes, Keybindings {{{
runtime folding.vim
runtime file-types.vim
runtime plugins.vim
runtime keybindings.vim
" " }}}
