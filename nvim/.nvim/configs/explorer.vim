" Uses plugin: coc-explorer

" Toggle explorer
let s:explorer_prev_window = -1
function! ToggleExplorer()
  if &filetype == 'coc-explorer'
    if win_gotoid(s:explorer_prev_window)
      " Open prev window
    else
      wincmd l
    endif
  else
    let s:explorer_prev_window = win_getid()
    execute 'CocCommand explorer --no-toggle'
  endif
endfunction
nnoremap <silent> <A-e> :call ToggleExplorer()<cr>
nnoremap <silent> <leader> e :CocCommand explorer --toggle --reveal<cr>

" Enable nerdfont for file icons
set guifont=DroidSansMono\ Nerd\ Font\ 11

" Always coc-explorer when opening dir
function! s:OpenDirHere(dir)
  if isdirectory(a:dir)
  au! FileExplorer
    exec "silent CocCommand explorer --reveal " . a:dir
  endif
endfunction

augroup CocExplorerDefault
  autocmd!
  autocmd VimEnter * call <SID>OpenDirHere(expand('<amatch>'))
augroup end

" Auto refresh coc explorer on files change
augroup RefreshCocExplorer
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
    \ call CocActionAsync('runCommand', 'explorer.doAction', 'closest', ['refresh'])
augroup end

