" VIM {{{
augroup filetype_vim
  autocmd!
  " better folds in vim files
  autocmd FileType vim setlocal foldenable
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim setlocal foldlevel=0
augroup END
" }}}

" Rust {{{
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'
" }}}

" Filetypes mapping {{{
augroup JsonToJsonc
  autocmd! FileType json set filetype=jsonc
augroup END
" }}}
