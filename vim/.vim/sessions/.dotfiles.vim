let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/.dotfiles
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +2 nvim/readme.md
badd +176 nvim/.nvim/init.vim
badd +11 nvim/.nvim/configs/plugins.vim
badd +28 nvim/.nvim/configs/keybindings.vim
badd +1 nvim/.nvim/configs/explorer.vim
badd +105 nvim/.nvim/configs/statusline.vim
badd +105 nvim/.nvim/configs/code.vim
badd +56 nvim/.nvim/configs/files.vim
badd +1 init.sh
badd +59 tmux/.tmux/keybindings.sh
argglobal
%argdel
$argadd ~/.dotfiles
edit nvim/.nvim/configs/code.vim
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd w
wincmd w
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 30 + 103) / 206)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 206)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 206)
argglobal
enew
file \[coc-explorer]-1
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal nofen
wincmd w
argglobal
setlocal fdm=marker
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 1 - ((0 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
1
normal! 0
lcd ~/.dotfiles
wincmd w
argglobal
if bufexists("~/.dotfiles/nvim/.nvim/init.vim") | buffer ~/.dotfiles/nvim/.nvim/init.vim | else | edit ~/.dotfiles/nvim/.nvim/init.vim | endif
setlocal fdm=expr
setlocal fde=GetPotionFold(v:lnum)
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal nofen
let s:l = 187 - ((61 * winheight(0) + 28) / 56)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
187
normal! 0
lcd ~/.dotfiles
wincmd w
3wincmd w
exe 'vert 1resize ' . ((&columns * 30 + 103) / 206)
exe 'vert 2resize ' . ((&columns * 87 + 103) / 206)
exe 'vert 3resize ' . ((&columns * 87 + 103) / 206)
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOFAc
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
