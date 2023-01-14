local cmd = vim.cmd

cmd([[
  rshada!
  syntax on
  filetype on
  filetype plugin indent on
]])

-- File type related
-----------------------------------------------------------
-- remove line lenght marker for selected filetypes
cmd("autocmd FileType text,markdown,xml,json,yaml,yml,html,xhtml,javascript setlocal cc=0")
-- 2 spaces for selected filetypes
cmd(
	"autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,yml,vim,lua,nginx "
		.. "setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab"
)
-- Use tabs instead of spaces
cmd("autocmd FileType asm,go setlocal shiftwidth=4 softtabstop=0 syntax=nasm noexpandtab")
-- Makefiles
cmd("autocmd FileType make setlocal shiftwidth=4 softtabstop=0 tabstop=4 noexpandtab")
