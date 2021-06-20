" Searching and replacing text {{{
" Clear highlighting on escape in normal mode
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
" search for visually hightlighted text
vnoremap <C-f> y<esc>/<c-r>"<cr>
vnoremap <C-r> "0y<esc>:%s/<C-r>0//g<left><left>
" }}}

" Scroll {{{
" ==========
" Scroll using the shifted up/down arrows
noremap <S-Down> <C-E>
noremap <S-Up> <C-Y>
" }}}

" Editing {{{
" ===========
" Move lines
nnoremap <silent> <A-j> :m .+1<cr>==
nnoremap <silent> <A-k> :m .-2<cr>==
inoremap <silent> <A-j> <esc>:m .+1<cr>==gi
inoremap <silent> <A-k> <esc>:m .-2<cr>==gi
vnoremap <silent> <A-j> :m '>+1<cr>gv=gv
inoremap <silent> <A-j> <esc>:m .+1<cr>==gi
inoremap <silent> <A-k> <esc>:m .-2<cr>==gi
vnoremap <silent> <A-k> :m '<-2<cr>gv=gv
" d is for deleting - skip buffer
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d
" Add indentation when entering I mode
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
" Indent without leaving visual mode
vnoremap < <gv
vnoremap > >gv
" New lines from normal mode
nnoremap <silent> <leader>' :<C-u>call append(line("."),   repeat([""], v:count1))<CR>
nnoremap <silent> <leader>" :<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>
" }}}

" Copy and paste {{{
" ==================
" Ctrl-c - copy (visual)
" Ctrl-x - cut (visual)
" Ctrl-v - paste (insert)
nnoremap <M-v> <C-v>
nnoremap <C-v> p
vnoremap <C-c> y
vnoremap <C-x> c
inoremap <C-v> <esc>p
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
inoremap <buffer> <space> <space><c-g>u
nnoremap <silent> <C-u> :undo<cr>
inoremap <silent> <C-u> <c-o>:undo<cr>
inoremap <silent> <C-z> <c-o>:undo<cr>
nnoremap <silent> <C-r> :redo<cr>
inoremap <silent> <C-r> <c-o>:redo<cr>
inoremap <silent> <C-y> <c-o>:redo<cr>
" }}}

" Insert key {{{
" ================
nnoremap <insert> R
vnoremap <insert> <esc>R
inoremap <expr> <insert> mode() ==# 'R' ? '<esc>i' : '<esc>R'
" }}}

" Filetypes {{{
" =============
nmap <leader>fmd :set filetype=markdown<cr>
nmap <leader>fj :set filetype=java<cr>
nmap <leader>frs :set filetype=rust<cr>
nmap <leader>fsh :set filetype=shell<cr>
nmap <leader>fjson :set filetype=json<cr>
nmap <leader>fyml :set filetype=yaml<cr>
nmap <leader>ftml :set filetype=toml<cr>
nmap <leader>fkt :set filetype=kotlin<cr>
nmap <leader>fgr :set filetype=groovy<cr>
nmap <leader>fjs :set filetype=javascript<cr>
nmap <leader>fts :set filetype=typescript<cr>
" }}}

" Configuration file {{{
" ======================
" Edit vimrc configuration file
nnoremap <leader>ve :split $MYVIMRC<cr>
" Reload vimrc configuration file
nnoremap <leader>vr :source $MYVIMRC<cr>:echo "Reloaded: " . $MYVIMRC<cr>
" }}}

" Comments {{{
" ============
" Plugin: commentary
nmap <C-_> gcc
imap <C-_> <C-o>gcc
vmap <C-_> gc<cr>
" }}}

" Others {{{
" VIM sees <Tab> and <C-i> as the same action therefor remap <C-i>
nnoremap <C-l> <C-i>
" Toggle word wrap
map <silent> <leader>w :set wrap!<cr>
" Quit all
noremap <c-q> :confirm qall<cr>
" }}}
