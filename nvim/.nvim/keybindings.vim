let mapleader = "\<Space>"
set whichwrap+=<,>,h,l,[,],<>            " change line or empty

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

" Scroll {{{
" ==========
" Scroll using the shifted up/down arrows
map <S-Down> <C-E>
map <S-Up> <C-Y>
" }}}

" Selection {{{
" =============
" Plugin: vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)
" Select all
nnoremap <leader>a ggVG
vnoremap <leader>a <esc>ggVG
" Select line (no whitespace)
nnoremap <leader>l ^vg_
vnoremap <leader>l <esc>^vg_
" Select code block (with function name)
nnoremap <leader>b [{v%
vnoremap <leader>b <esc>[{v%
" }}}

" Move lines {{{
" ==============
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" }}}

" Copy and paste {{{
" ==================
" Ctrl-c - copy (visual)
" Ctrl-x - cut (visual)
" Ctrl-v - paste (insert)
nnoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-x> "+c
inoremap <C-v> <ESC>"+pa
" Copy and paste using leader
nnoremap <leader>v "+pa
vnoremap <leader>c "+y
vnoremap <leader>x "+c
" Copy and cut using leader - all
nmap <leader>ca ggVG"+yG
vmap <leader>ca <esc>ggVG"+yGv
nmap <leader>xa ggVG"+cG
vmap <leader>xa <esc>ggVG"+cGv
" Copy and cut using leader - line (no whitespace)
nmap <leader>cl ^vg_"+yg_
vmap <leader>cl <esc>^vg_"+yg_v
nmap <leader>xl <esc>^vg_"+cg_
vmap <leader>xl <esc>^vg_"+cg_v
" Copy and cut using leader - code block (with function name)
nmap <leader>cb [{V%"+yg_%<esc>
vmap <leader>cb <esc>[{V%"+yg_%v
nmap <leader>xb [{V%"+c<esc>
vmap <leader>xb <esc>[{V%"+cv
" Copy and paste using leader #2
vnoremap <leader>y "+y
nnoremap <leader>Y "+yg_
nnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>p "+pR
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
" }}}

" Undo and redo {{{
" =================
" Ctrl-u - undo (normal, insert)
" Ctrl-r - redo (normal, insert)
inoremap <buffer> <cr> <cr><c-g>u
inoremap <buffer> . .<c-g>u
inoremap <buffer> ! !<c-g>u
inoremap <buffer> ? ?<c-g>u
inoremap <buffer> , ,<c-g>u
inoremap <buffer> <Space> <Space><c-g>u
nnoremap <silent> <C-u> :undo<cr>
inoremap <silent> <C-u> <c-o>:undo<cr>
inoremap <silent> <C-z> <c-o>:undo<cr>
nnoremap <silent> <C-r> :redo<cr>
inoremap <silent> <C-r> <c-o>:redo<cr>
inoremap <silent> <C-y> <c-o>:redo<cr>
" }}}

" Indentation {{{
" ===============
" Smart indent when entering insert mode
function! IndentWithI()
  if len(getline('.')) == 0
    " indent on empty line
    return "\"_cc"
  elseif strpart(getline('.'), 0, col('.')) =~ '^\s*$'
    " skip whitespaces
    return "^i"
  else
    return "i"
  endif
endfunction
nnoremap <expr> i IndentWithI()
" Tab based indentation
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" }}}

" Quick modes {{{
" ================
" Quick visual mode
nmap <Leader><Leader> V
vmap <Leader><Leader> <Esc>i
" Quick replace mode
nnoremap <insert> R
vnoremap <insert> <Esc>R
inoremap <expr> <insert> mode() ==# 'R' ? '<Esc>i' : '<Esc>R'
" }}}

" Terminal {{{
" ============
nmap <silent> <Leader>t :below 10sp<cr>:terminal<cr>a
tnoremap <Esc> <C-\><C-n>
" }}}

" Filetypes {{{
" =============
nmap <Leader>fmd :set filetype=markdown<cr>
nmap <Leader>fj :set filetype=java<cr>
nmap <Leader>frs :set filetype=rust<cr>
nmap <Leader>fsh :set filetype=shell<cr>
nmap <Leader>fjson :set filetype=json<cr>
nmap <Leader>fyml :set filetype=yaml<cr>
nmap <Leader>ftml :set filetype=toml<cr>
nmap <Leader>fkt :set filetype=kotlin<cr>
nmap <Leader>fgr :set filetype=groovy<cr>
nmap <Leader>fjs :set filetype=javascript<cr>
nmap <Leader>fts :set filetype=typescript<cr>
" }}}

" Configuration file {{{
" ======================
" Edit vimrc configuration file
nnoremap <Leader>ve :split $MYVIMRC<cr>
" Reload vimrc configuration file
nnoremap <Leader>vr :source $MYVIMRC<cr>:echo "Reloaded: " . $MYVIMRC<cr>
" }}}

" Explorer {{{
" ============
" Toggle explorer
nnoremap <space>e :CocCommand explorer --toggle<CR>
" }}}

" Comments {{{
" ============
" Plugin: commentary
nmap <C-_> gcc
imap <C-_> <C-o>gcc
vmap <C-_> gc<cr>
" }}}

" Save file
nnoremap <C-s> :FullFormat<cr>:w<cr>
inoremap <C-s> <ESC>:FullFormat<cr>:w<cr>i
vnoremap <C-s> <ESC>:FullFormat<cr>:w<cr>i

" Split commands
" Navigate splits
map <C-h> <C-w>h
map <C-l> <C-w>l
map <silent> <C-j> <C-w>j
map <silent> <C-k> <C-w>k
imap <C-h> <C-o><C-h>
imap <C-l> <C-o><C-l>
imap <C-j> <C-o><C-j>
imap <C-k> <C-o><C-k>
vmap <C-h> <C-o><C-h>
vmap <C-l> <C-o><C-l>
vmap <C-j> <C-o><C-j>
vmap <C-k> <C-o><C-k>
" resize splits
nmap <silent> <S-h> :vertical :resize +1<CR>
nmap <silent> <S-l> :vertical :resize -1<CR>
nmap <silent> <S-j> :resize -1<CR>
nmap <silent> <S-k> :resize +1<CR>
" create splits
nmap <silent> <leader>- :new<cr>
nmap <silent> <leader>\| :vnew<cr>
nmap <leader>x <C-w>q
nmap <silent> <leader>o :only<cr>
" maximize pane
nmap <leader>z <C-W>_<C-W><Bar>
" make panes equal
nmap <leader>= <C-W>=<CR>
" move pane to a separate tab
nmap <silent> <leader>! :tabedit %<cr>
