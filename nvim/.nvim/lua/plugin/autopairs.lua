local auto_pairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')

auto_pairs.setup({
  check_ts = true
})

-- Integration with: nvim-autopairs
-- Crashed nvim on 2021-10-17
require('nvim-autopairs.completion.cmp').setup({
  map_cr = true, --  map <cr> on insert mode
  map_complete = true, -- it will auto insert `(` (map_char) after select function or method item
  auto_select = true, -- automatically select the first item
  insert = false, -- use insert confirm behavior instead of replace
  map_char = { -- modifies the function or method delimiter by filetypes
    all = '(',
    tex = '{'
  }
})

