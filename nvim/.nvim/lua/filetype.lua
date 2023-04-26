local cmd = vim.cmd

cmd([[
  rshada!
  syntax on
  filetype on
]])

-- File type related
-----------------------------------------------------------
-- remove line lenght marker for selected filetypes
cmd("autocmd FileType text,markdown,xml,json,yaml,yml,html,xhtml,javascript setlocal cc=0")

-- 2 spaces for selected filetypes
cmd(
	"autocmd FileType xml,html,xhtml,css,scss,javascript,yaml,yml,vim,lua,nginx "
		.. "setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab"
)
-- Use tabs instead of spaces
cmd("autocmd FileType make,lua,go,nasm setlocal shiftwidth=2 softtabstop=0 tabstop=2 noexpandtab")

-- fix syntax
cmd("autocmd FileType asm setlocal syntax=nasm")
