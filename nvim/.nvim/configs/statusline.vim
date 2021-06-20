" Uses plugin: lightline
set laststatus=2
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
  \   'left': [
  \      ['mode', 'paste'],
  \      ['gitbranch', 'filename', 'cocstatus']
  \   ],
  \   'right': [
  \      ['lineinfo'],
  \      ['percent'],
  \      ['filetype', 'fileencoding', 'fileformat']
  \   ]
  \ },
  \ 'inactive': {
  \   'right': []
  \ },
  \ 'component_function': {
  \   'mode': 'LightlineMode',
  \   'percent': 'LightlinePercent',
  \   'filetype': 'LightlineFileType',
  \   'filename': 'LightlineFilename',
  \   'fileformat': 'LightlineFileFormat',
  \   'lineinfo': 'LightlineLineInfo',
  \   'fileencoding': 'LightlineFileEncoding',
  \   'cocstatus': 'coc#status',
  \   'gitbranch': 'LightlineGitbranch'
  \ },
  \ 'mode_map': {
  \   'n': ' N0RMAL',
  \   'i': ' INSERT',
  \   'R': ' REPLACE',
  \   'v': ' VISUAL',
  \   'V': ' V-LINE',
  \   "\<C-v>": ' V-BL0CK',
  \   'c': ' COMMAND',
  \   's': ' SELECT',
  \   'S': ' S-LINE',
  \   "\<C-s>": ' S-BL0CK',
  \   't': ' TERMINAL'
  \ }
  \ }

function! LightlineGitbranch()
  if &filetype ==# 'coc-explorer'
    return ''
  endif
  let branch = fugitive#head()
  return winwidth(0) > 70 && branch !=# '' ? ' ' . branch : ''
endfunction

function! LightlinePercent()
  return winwidth(0) > 70
    \ ? printf('%3s', (line('.') * 100 / line('$'))) . '%'
    \ : ''
endfunction

function! LightlineFileType()
  return winwidth(0) > 70 && &filetype !=# ''
    \ ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype
    \ : ''
endfunction

function! LightlineFileEncoding()
  return &fileencoding !=# 'utf-8' && winwidth(0) > 70
    \ ? &fileencoding : ''
endfunction

function! LightlineFileFormat()
  return &fileformat !=# 'unix' && winwidth(0) > 70
    \ ? &fileformat : ''
endfunction

function! LightlineLineInfo()
  return winwidth(0) > 70
    \ ? col('.') . ':' . line('.') . '/' . line('$')
    \ : ''
endfunction

function! LightlineFilename()
  if &filetype ==# 'coc-explorer'
    return ''
  endif
  let filename = expand('%:t') !=# '' ? expand('%:~:.') : '[New]'
  let terms = split(filename, ':')
  if terms[0] ==# 'term'
    return '[' . terms[-1] . ']'
  endif
  let modified = &modified ? '' : ''
  let icons = &readonly ? '' : modified
  return filename . ' ' . icons
endfunction
" Simplify status in coc-explorer
" let g:lightline.component_function = { 'mode': 'LightlineMode' }
function! LightlineMode() abort
  return &filetype ==# 'coc-explorer'
    \ ? ' EXPLORER' :
    \ lightline#mode()
endfunction
" Use nerd fonts
" let g:airline_powerline_fonts = 1
" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
