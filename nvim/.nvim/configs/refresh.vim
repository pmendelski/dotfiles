if has ('autocmd')
  augroup AutoRefreshBuffersOnFileChange
    autocmd!
    " Triger `autoread` when files changes on disk
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
    " Notification after file change
    " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl Noine
  augroup end

  function! CleanNoNameEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && (getbufline(v:val, 1, "$") == [""])')
    if !empty(buffers)
      exe 'bd '.join(buffers, ' ')
    endif
  endfunction

  augroup AutoRemoveNoNameEmptyBuffers
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \ call CleanNoNameEmptyBuffers()
  augroup end

  " Auto reload config when saving config file
  if has ('autocmd')
    augroup reload_vimrc
      autocmd!
      autocmd BufWritePost $MYVIMRC ++nested source $MYVIMRC | echom "Reloaded: " . $MYVIMRC
    augroup end
    augroup lastpos
      " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
      autocmd!
      autocmd BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    augroup end
  endif
endif
