" Uses plugin: onedark

" terminal compatybility
if !has('gui_running')
  set t_Co=256
endif
if has("nvim")
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
if has("termguicolors")
  set termguicolors
endif
colorscheme onedark
set cursorline

if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#extend_highlight("CursorIM", { "fg": s:white })
    autocmd ColorScheme * call onedark#extend_highlight("CursorColumn", { "fg": s:white })
  augroup END
endif
