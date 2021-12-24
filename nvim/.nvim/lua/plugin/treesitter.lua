require('nvim-treesitter.configs').setup({
  ensure_installed = 'maintained', -- one of 'all', 'maintained' (parsers with maintainers), or a list of languages
  autopairs = { enable = true },
  highlight = {
    enable = true,
    -- required for spell check
    additional_vim_regex_highlighting = true
  },
  matchup = { enable = true },
  indent = { enable = true },
  autotag = { enable = true },
})

-- Folding
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldtext = [[ substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines) ' ]]
vim.wo.foldlevel = 999
