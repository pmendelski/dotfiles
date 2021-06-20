" Uses plugin: vim-expand-region

" Expand on v and c-v
vmap v <plug>(expand_region_expand)
vmap <c-v> <plug>(expand_region_shrink)
" More expansion boundaries
call expand_region#custom_text_objects({
  \ 'a]': 1,
  \ 'a>': 1,
  \ 'ab': 1,
  \ 'aB': 1,
  \ })
