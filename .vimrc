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

" Colors {{{
set t_Co=256            " terminal compatybility
syntax enable           " enable syntax processing
set background=dark
colorscheme molotov
" }}}

" Misc {{{
set esckeys             " allow cursor keys in insert mode
set lazyredraw          " faster
set mouse=a             " enable mouse in all in all modes
set nocompatible        " some compatybility issues
set shell=/bin/sh       " use /bin/sh for executing shell commands
set ttyfast             " send more characters at a given time
set ttymouse=xterm      " set mouse type to xterm
set undofile            " persistent Undo
set visualbell          " use visual bell instead of audible bell (anoying)
" }}}

" Spaces & Tabs {{{
set nocompatible        " Because filetype detection doesn't work well in compatible mode
filetype indent on      " load filetype-specific indent files
filetype plugin on      " load filetype-specific plugins
set autoindent          " copy indent from last line when starting new line
set backspace=indent,eol,start
" set expandtab           " use spaces for tabs
set shiftwidth=4
set softtabstop=4       " number of spaces in tab when editing
set tabstop=4           " number of visual spaces per TAB
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:< " mapping for white characters
set list                " by default present whitecharacters
" }}}

" Windows {{{"
set splitbelow          " new window goes below
set splitright          " new windows goes right
set winminheight=0      " allow splits to be reduced to a single line
" }}}

" UI Layout {{{
set cursorline          " highlight current line
set modelines=1
set nostartofline       " don't reset cursor to start of line when moving around
set nowrap              " do not wrap lines
set number              " show line numbers
set ruler               " show the cursor position
set scrolloff=3         " start scrolling three lines before horizontal border of window
set shortmess=atI       " don't show the intro message when starting vim
set showcmd             " show command in bottom bar
set showmatch           " higlight matching parenthesis
set sidescrolloff=3     " start scrolling three columns before vertical border of window
set title               " show the filename in the window titlebar
" }}}

" Diff {{{
set diffopt=filler      " add vertical spaces to keep right and left aligned
set diffopt+=iwhite     " ignore whitespace changes (focus on code changes)
" }}}

" Searching {{{
set gdefault            " by default add g flag to search/replace. Add g to toggle
set hlsearch            " highlight all matches
set ignorecase          " ignore case when searching
set incsearch           " search as characters are entered
set magic               " enable extended regexes
set regexpengine=1      " use the old regular expression engine (it's faster for certain language syntaxes)
set smartcase           " ignore 'ignorecase' if search patter contains uppercase characters
set suffixes=.class,.bak,~,.swp,.swo,.o,.d,.info,.aux,.log,.dvi,.pdf,.bin,.bbl,.blg,.brf,.cb,.dmg,.exe,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyd,.dll " omit during file match
set wrapscan            " searches wrap around end of file
" }}}

" Leader shortcuts {{{
let mapleader=","                        " leader is comma
nnoremap <leader><space> :nohlsearch<CR> " turn off search highlight
nnoremap <leader>s :mksession<CR>        " save session, restore with: vim -S
" }}}

" History {{{
set hidden              " when a buffer is brought to foreground, remember undo history and marks
set history=1000        " increase history from 20 default to 1000
" }}}

" Wild menu {{{
set wildchar=<TAB>      " character for CLI expansion (TAB-completion)
set wildignore+=.DS_Store
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js,*.class
set wildignore+=*/bower_components/*,*/node_modules/*,*/target/*,*/build/*
set wildignore+=*/smarty/*,*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,*/ckeditor/*,*/doc/*,*/source_maps/*,*/dist/*
set wildmenu            " hitting TAB in command mode will show possible completions above command line
set wildmode=list:longest " complete only until point of ambiguity
" }}}

" Folding {{{
nnoremap <space> za     " space open/closes folds
set foldcolumn=0        " column to show folds
set foldenable          " enable folding
set foldlevel=10        " close all folds starting from depth of 10
set foldmethod=indent   " indents are used to specify folds
set foldminlines=0      " allow folding single lines
set foldnestmax=10      " set max fold nesting level
" }}}

" Format {{{
set formatoptions=
set formatoptions+=c    " format comments
set formatoptions+=r    " continue comments by default
set formatoptions+=o    " make comment when using o or O from comment line
set formatoptions+=q    " format comments with gq
set formatoptions+=n    " recognize numbered lists
set formatoptions+=2    " use indent from 2nd line of a paragraph
set formatoptions+=l    " don't break lines that are already long
set formatoptions+=1    " break before 1-letter words
" }}}

" Local directories {{{
set backupdir=~/.vim/tmp/backups
set directory=~/.vim/tmp/swaps
set undodir=~/.vim/tmp/undo
" }}}

" Filetypes {{{
    " JSON {{{
    augroup filetype_json
        autocmd!
        au BufRead,BufNewFile *.json set ft=json syntax=javaScript
    augroup END
    " }}}
" }}}

" Plugins {{{

    execute pathogen#infect()

    " CtrlP.vim {{{
    augroup ctrlp_config
        autocmd!
        let g:ctrlp_match_window = 'bottom,order:ttb'
        let g:ctrlp_switch_buffer = 0
        let g:ctrlp_working_path_mode = 0
    augroup END
    " }}}

    " Syntastic.vim {{{
    augroup syntastic_config
        autocmd!
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 1
        let g:syntastic_error_symbol = '✗'
        let g:syntastic_warning_symbol = '⚠'
        let g:syntastic_javascript_checkers = ['eslint']
        let g:syntastic_ruby_checkers = ['mri', 'rubocop']
    augroup END
    " }}}

" }}}"

" vim:foldmethod=marker:foldlevel=0
