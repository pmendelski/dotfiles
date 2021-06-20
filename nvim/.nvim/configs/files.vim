" https://github.com/junegunn/fzf#environment-variables
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

function! OpenX(cmd)
  " If more than 1 window, and buffer is not modifiable or file type is special
  if !&modifiable || &buftype == 'nofile'
    " Move one window to the right, then up
    wincmd l
    wincmd l
    wincmd k
    wincmd k
  endif
  exe a:cmd
endfunction
" Search file by content
noremap <silent> <leader>s :call OpenX(":Rg")<cr>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --hidden --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Open file
nnoremap <leader>o :call OpenX(":Files")<cr>
" Open file adjacent to current file
nnoremap <leader>l :call OpenX(":Files " . expand("%:p:h") . "/") <cr>
" Open new file adjacent to current file
nnoremap <leader>n :e <C-R>=expand("%:p:h") . "/" <cr>
" Open buffer
nnoremap <silent> <leader>; :call OpenX(":Buffers")<cr>
" Toggle buffers
nnoremap <leader><leader> <c-^>
" Delete buffer
nnoremap <leader>d :bp<bar>sp<bar>bn<bar>bd<cr>

" let g:fzf_layout = { 'down': '~20%' }
" command! -bang -nargs=* Rg
"   \ call fzf#vim#grep(
"   \   'rg --hidden --column --line-number --no-heading --color=always ' . shellescape(<q-args>),
"   \   1,
"   \   <bang>0 ? fzf#vim#with_preview('up:60%')
"   \           : fzf#vim#with_preview('right:50%:hidden', '?'),
"   \   <bang>0)

" function! s:list_cmd()
"   let base = fnamemodify(expand('%'), ':h:.:S')
"   return base == '.'
"     \ ? 'fd --type file --follow'
"     \ : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
" endfunction

" command! -bang -nargs=? -complete=dir Files
"   \ call fzf#vim#files(<q-args>, {
"   \   'source': s:list_cmd(),
"   \   'options': '--tiebreak=index'
"   \ }, <bang>0)
" }}}


