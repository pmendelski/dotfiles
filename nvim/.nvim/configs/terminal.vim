let s:monkey_terminal_window = -1
let s:monkey_terminal_prev_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1

function! MonkeyTerminalOpen()
  if !&modifiable || &buftype == 'nofile'
    " Move one window to the right, then up
    wincmd l
    wincmd k
  endif
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:monkey_terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves to the window the right the current one
    wincmd J
    resize 15
    let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })
    " Change the name of the buffer to "Terminal 1"
    silent file Terminal
    " Gets the id of the terminal window
    let s:monkey_terminal_window = win_getid()
    let s:monkey_terminal_buffer = bufnr('%')
    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
    normal A
  elseif !win_gotoid(s:monkey_terminal_window)
    sp
    " Moves to the window below the current one
    wincmd J
    resize 15
    buffer Terminal
    " Gets the id of the terminal window
    let s:monkey_terminal_window = win_getid()
    normal A
  endif
endfunction

function! MonkeyTerminalToggle()
  if win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalClose()
    if win_gotoid(s:monkey_terminal_prev_window)
      " switch back to previous window
    endif
  else
    let s:monkey_terminal_prev_window = win_getid()
    call MonkeyTerminalOpen()
  endif
endfunction

function! MonkeyTerminalClose()
  if win_gotoid(s:monkey_terminal_window)
    " close the current window
    hide
  endif
endfunction

function! MonkeyTerminalExec(cmd)
  if !win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalOpen()
  endif
  " clear current input
  call jobsend(s:monkey_terminal_job_id, "clear\n")
  " run cmd
  call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
endfunction

function! MonkeyTerminalToggleFocus()
  if win_getid() == s:monkey_terminal_window && win_gotoid(s:monkey_terminal_prev_window)
    " Open prev window
  else
    " Open terminal window
    let s:monkey_terminal_prev_window = win_getid()
    if !win_gotoid(s:monkey_terminal_window)
      call MonkeyTerminalToggle()
    endif
  endif
endfunction

function! TerminalOptions()
  silent! au BufEnter <buffer> startinsert!
  silent! au BufLeave <buffer> stopinsert!
endfunction
autocmd TermOpen * call TerminalOptions()

" With this maps you can now toggle the terminal
nnoremap <silent> <leader>t :call MonkeyTerminalToggle()<cr>
nnoremap <silent> <F2> :call MonkeyTerminalToggle()<cr>
tnoremap <silent> <F2> <C-\><C-n>:call MonkeyTerminalToggle()<cr>
nnoremap <silent> <A-t> :call MonkeyTerminalToggleFocus()<cr>
tnoremap <silent> <A-t> <C-\><C-n>:call MonkeyTerminalToggleFocus()<cr>
