" Plugin installer
"-----------------------------------------------------------
" After adding new plugin run:
"  :PlugInstall
" Required at the top by vim-polyglot
set nocompatible
runtime plugins/vim-plug/plug.vim
call plug#begin('~/.vim/plugins')
" Syntax highlight
Plug 'sheerun/vim-polyglot'
" Code comments
Plug 'tpope/vim-commentary'
" Editor config
Plug 'editorconfig/editorconfig-vim'
" Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Nice status bar
Plug 'itchyny/lightline.vim'
" Git branchname in statusbar
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Colorscheme
Plug 'NLKNguyen/papercolor-theme'
call plug#end()

"" General
"-----------------------------------------------------------
let mapleader="\<space>"
set encoding=utf8 " utf8 by default
set mouse=a " enable mouse in all in all modes
set clipboard=unnamed,unnamedplus " copy/paste to system clipboard
set nocompatible " some compatybility issues
set updatetime=150
set synmaxcol=240 " max column for syntax highlight

"" UI
"-----------------------------------------------------------
" let &t_ut='' " fix background on some terminals (kitt)
set whichwrap+=<,>,h,l,[,],<>
set noerrorbells
set novisualbell
set number " show line number
set showmatch " highlight matching parenthesis
"set colorcolumn=100 " line lenght marker at 100 columns
set signcolumn=yes " always show sign column
set splitright " vertical split to the right
set splitbelow " horizontal split to the bottom
set showcmd " show (partial) command in status line
set laststatus=2 " always present status line
set completeopt=menuone,noinsert " :help completeopt
set ttyfast " send more characters at a given time
set lazyredraw " faster scrolling
set synmaxcol=500 " max column for syntax highlight
" set cursorline
set shortmess+=c " avoid showing extra messages when using completion
syntax on
set termguicolors
set background=dark
colorscheme PaperColor

" Cursor
"-----------------------------------------------------------
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

augroup myCmds
  au!
  autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END

" Folding
"-----------------------------------------------------------
set foldcolumn=0 " column to show folds
set foldenable " enable folding
set foldlevel=10 " close all folds starting from depth of 10
set foldmethod=syntax " fold using syntax
set foldminlines=0 " allow folding single lines
set foldnestmax=10 " set max fold nesting level

"" History
"-----------------------------------------------------------
set hidden " when a buffer is brought to foreground, remember undo history and marks
set history=1000 " increase history from 20 default to 1000

" Search & replace
"-----------------------------------------------------------
set hlsearch " highlight all matches
" set ignorecase " ignore case letters when search
set smartcase " ignore lowercase for the whole pattern
set incsearch " search as characters are entered
" set gdefault " by default add g flag to search/replace. Add g to toggle
set magic " enable extended regexes
set regexpengine=1 " use the old regular expression engine (it's faster for certain language syntaxes)
set wrapscan " searches wrap around end of file

" Make diffing better
" https://vimways.org/2018/the-power-of-diff/
"-----------------------------------------------------------
set diffopt+=filler
set diffopt+=iwhite
if has('mac') && $VIM == '/usr/share/vim'
	set diffopt-=internal
elseif has('patch-8.1.0360')
  set diffopt+=algorithm:patience
  set diffopt+=indent-heuristic
endif

"" Temporary files
"-----------------------------------------------------------
set noswapfile " don't use swapfile
set undofile " persistent Undo
set backupdir=~/.vim/tmp/backups
set directory=~/.vim/tmp/swaps
set undodir=~/.vim/tmp/undo

"" Wildmenu
"-----------------------------------------------------------
set wildmenu
set wildchar=<TAB>
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor
set wildmode=list:longest

"" Wrapping, spaces & tabs
"-----------------------------------------------------------
set autoindent " copy indent from last line when starting new line
set copyindent
set backspace=indent,eol,start
set expandtab " use spaces for tabs
set shiftwidth=4
set softtabstop=4 " number of spaces in tab when editing
set tabstop=4 " number of visual spaces per TAB
" Wrapping options
set nowrap
set formatoptions+=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines
" Whitespace characters
set list
set listchars=space:·,eol:¬,tab:▸\ ,nbsp:±,trail:·,extends:»,precedes:«

"" Spellcheck
"-----------------------------------------------------------
"set spell
"set spelllang=en,cjk

"" File type related
"-----------------------------------------------------------
filetype indent on " load filetype-specific indent files
filetype plugin on "  load filetype-specific plugins
" remove line lenght marker for selected filetypes
autocmd FileType text,markdown,xml,json,yaml,html,xhtml,javascript setlocal cc=0
" 2 spaces for selected filetypes
autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2

" Tmux
"-----------------------------------------------------------
if &term =~ '^screen'
 " tmux will send xterm-style keys when its xterm-keys option is on
 " http://superuser.com/a/402084
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif



"-----------------------------------------------------------
" Plugins
"-----------------------------------------------------------

" Plugin: fzf
"-----------------------------------------------------------
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
" Search file by content
noremap <silent> <leader>s :Rg<cr>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)
" Open file
nnoremap <leader>o :Files<cr>
" Open file adjacent to current file
nnoremap <leader>l :Files expand("%:p:h") "/" <cr>
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)




"-----------------------------------------------------------
" Keybindins
"-----------------------------------------------------------

" MacOS
"-----------------------------------------------------------
" Map ESC to physical key
nnoremap § <esc>
inoremap § <esc>
xnoremap § <esc>

" Buffers
"-----------------------------------------------------------
" Open buffer
nnoremap <silent> <leader>; :Buffers<cr>
" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <cr>
" Delete buffer
nnoremap <leader>q :bp<bar>sp<bar>bn<bar>bd<cr>
" Toggle buffers
nnoremap <leader><leader> <c-^>

" VIM Diff
"-----------------------------------------------------------
" ]c - next change
" [c - previous change
nnoremap <silent> <leader>ml :diffget LOCAL<cr>
nnoremap <silent> <leader>mb :diffget BASE<cr>
nnoremap <silent> <leader>mr :diffget REMOTE<cr>

" Search
"-----------------------------------------------------------
" Search results are in the center of the window
nnoremap n nzz
nnoremap N Nzz
" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap § :noh<return><esc>
