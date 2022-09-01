-- vim.g.tokyonight_style = 'storm'
-- vim.g.tokyonight_style = 'day'
vim.cmd("colorscheme tokyonight")

vim.cmd([[
augroup TokyoNightOverrides
  autocmd!
  autocmd ColorScheme tokyonight highlight SpellBad gui=undercurl guifg=NONE guibg=NONE guisp=#e0af68
  autocmd ColorScheme tokyonight highlight SpellCap gui=undercurl guifg=NONE guibg=NONE guisp=#e0af68
  autocmd ColorScheme tokyonight highlight SpellLocal gui=undercurl guifg=NONE guibg=NONE guisp=#e0af68
  autocmd ColorScheme tokyonight highlight SpellRare gui=undercurl guifg=NONE guibg=NONE guisp=#e0af68
  autocmd ColorScheme tokyonight highlight TSInclude gui=NONE guifg=#e0af68 guibg=NONE guisp=NONE
  autocmd ColorScheme tokyonight highlight TSFuncMacro gui=NONE guifg=#e0af68 guibg=NONE guisp=NONE
  autocmd ColorScheme tokyonight highlight DapBreakpointSign gui=NONE guifg=#e0af68 guibg=NONE guisp=NONE
  autocmd ColorScheme tokyonight highlight DapStoppedSign gui=NONE guifg=#e0af68 guibg=NONE guisp=NONE
augroup end
]])

-- -- "#565f89",
-- SpellBad = { sp = c.error, style = "undercurl" }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
-- SpellCap = { sp = c.warning, style = "undercurl" }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
-- SpellLocal = { sp = c.info, style = "undercurl" }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
-- SpellRare = { sp = c.hint, style = "undercurl" }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
