" Plugin: lightline {{{
" ===========================
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
  \   'n': ' N0RMAL',
  \   'i': ' INSERT',
  \   'R': ' REPLACE',
  \   'v': ' VISUAL',
  \   'V': ' V-LINE',
  \   "\<C-v>": ' V-BL0CK',
  \   'c': ' COMMAND',
  \   's': ' SELECT',
  \   'S': ' S-LINE',
  \   "\<C-s>": ' S-BL0CK',
  \   't': ' TERMINAL'
  \ }
  \ }
function! LightlineGitbranch()
  if &filetype ==# 'coc-explorer'
    return ''
  endif
  let branch = gitbranch#name()
  return winwidth(0) > 70 && branch !=# '' ? ' ' . branch : ''
endfunction
function! LightlinePercent()
  return winwidth(0) > 70
    \ ? printf('%3s', (line('.') * 100 / line('$'))) . '%'
    \ : ''
endfunction
function! LightlineFileType()
  return winwidth(0) > 70
    \ ? WebDevIconsGetFileTypeSymbol() . ' ' .&filetype
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
    \ ? ' EXPLORER' :
    \ lightline#mode()
endfunction
" Use nerd fonts
let g:airline_powerline_fonts = 1
" Use auocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
" }}}

" Plugin: Complection coc-explorer {{{
" ====================================
" Enable nerdfont for file icons
set guifont=DroidSansMono\ Nerd\ Font\ 11
" Always coc-explorer when opening dir
augroup OpenCocExplorer
  autocmd!
  autocmd VimEnter * let d = expand('%')
    \ | if isdirectory(d)
    \ |   silent! bd
    \ |   let root = FindRootDirectory()
    \ |   exe 'CocCommand explorer ' . root
    \ | endif
augroup end
" }}}

" Plugin: Complection coc {{{
" ===========================
set updatetime=300      " Better experience
set shortmess+=c        " Don't pass messages to |ins-completion-menu|.
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of current line
nmap <leader>r <Plug>(coc-rename)
nmap <leader>a <Plug>(coc-codeaction)
nmap <leader>q <Plug>(coc-fix-current)
nmap <leader>f <Plug>(coc-format)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')
" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call CocAction('fold', <f-args>)
" use `:OrganizeImports` for organize import of current buffer
command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')

" CocList: Show all diagnostics
nnoremap <silent> cld  :<C-u>CocList diagnostics<cr>
" CocList: Find symbol of current document
nnoremap <silent> clo  :<C-u>CocList outline<cr>
" }}}
