-- disable diagnostics in dependencies
vim.cmd([[
  autocmd BufRead,BufNewFile */node_modules/* lua vim.diagnostic.disable(0)
]])

-- Automatically refresh buffers on file change
vim.cmd([[
  augroup AutoRefreshBuffersOnFileChange
    autocmd!
    " Triger `autoread` when files changes on disk
    " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
    " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
    " Notification after file change
    " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
    autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  augroup end
]])

-- Disable replacement/search visualization for huge files (>10MB)
vim.cmd([[
  augroup HandleHugeFiles
    autocmd BufReadPre * if getfsize(expand("%")) > 10000000 | set inccommand= | endif
  augroup end
]])

-- Automatically close empty buffers
vim.cmd([[
  function! CloseEmptyBuffers()
    let buffers = filter(
      \range(1, bufnr('$')),
      \'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val) < 0 && (getbufline(v:val, 1, "$") == [""])')
    if !empty(buffers)
      exe 'bd '.join(buffers, ' ')
    endif
  endfunction

  augroup AutoCloseEmptyBuffers
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * call CloseEmptyBuffers()
  augroup end
]])

-- Trim whitespaces before write
vim.cmd([[
augroup TrimWhitespaces
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
  autocmd BufWritePre * %s/\n\+\%$//e
augroup END
]])

-- Spell check on certain filetypes
vim.cmd([[
augroup SpellCheckFiletypes
  autocmd!
  autocmd FileType latex,tex,md,markdown setlocal spell
augroup END
]])

-- Autohighlight current word
vim.cmd([[
  " Highlight all instances of word under cursor, when idle.
  " Type z/ to toggle highlighting on/off.
  nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
  function! AutoHighlightToggle()
    let @/ = ''
    if exists('#auto_highlight')
      au! auto_highlight
      augroup! auto_highlight
      echo 'Highlight current word: off'
      return 0
    else
      augroup auto_highlight
        au!
        au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
      augroup end
      echo 'Highlight current word: ON'
      return 1
    endif
  endfunction
]])

-- Set autosave
vim.cmd([[autocmd TextChanged,InsertLeave <buffer> silent! write]])

-- Preserve last editing position
vim.cmd([[
  autocmd BufReadPost *
    \if line("'\"") > 0 && line("'\"") <= line("$") |
    \exe "normal! g'\"" |
    \endif
]])
