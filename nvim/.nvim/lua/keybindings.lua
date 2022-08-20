-- Neovim API aliases
-----------------------------------------------------------
local fn = vim.fn
local map = require('util').keymap

-- Init file
-----------------------------------------------------------
-- Edit vimrc configuration file
map('n', '<leader>ve', ':split $MYVIMRC<cr>')
-- Reload vimrc configuration file
map('n', '<leader>vr', ':source $MYVIMRC<cr>:echo "Reloaded: " . $MYVIMRC<cr>')

-- MacOS
-----------------------------------------------------------
-- Map ESC to physical key
map('n', '§', '<esc>')
map('i', '§', '<esc>')
map('v', '§', '<esc>')

-- Movement
-----------------------------------------------------------
-- Move by visual line not actual line
map('n', 'k', 'gk')
map('n', 'j', 'gj')
map('n', 'k', 'gk')
-- Faster movement
map('n', '<s-j>', '4j')
map('n', '<s-k>', '4k')
map('n', '<s-h>', '4h')
map('n', '<s-l>', '4l')
map('v', '<s-j>', '4j')
map('v', '<s-k>', '4k')
map('v', '<s-h>', '4h')
map('v', '<s-l>', '4l')

-- Buffers
-----------------------------------------------------------
-- Toggle buffers
map('n', '<leader><leader>', '<c-^>')
-- Delete buffer
map('n', '<leader>d', ':bp<bar>sp<bar>bn<bar>bd<cr>')
-- Open new file adjacent to current file
map('n', '<leader>n', ':e <C-R>=expand("%:p:h") . "/" <cr>', { silent = false })

-- Splits
-----------------------------------------------------------
--ctrl-arrow to navigate splits
map('n', '<c-Left>', '<cmd>wincmd h<cr>')
map('n', '<c-Down>', '<cmd>wincmd j<cr>')
map('n', '<c-Up>', '<cmd>wincmd k<cr>')
map('n', '<c-Right>', '<cmd>wincmd l<cr>')
--ctrl-hjkl to change split size
map('n', '<c-h>', '<cmd>resize -5<cr>')
map('n', '<c-j>', '<cmd>vertical resize -5<cr>')
map('n', '<c-k>', '<cmd>vertical resize +5<cr>')
map('n', '<c-l>', '<cmd>resize +5<cr>')

-- Search
-----------------------------------------------------------
-- Search results are in the center of the window
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')
map('n', '*', '*zz')
map('n', '#', '#zz')
-- Clear highlighting on escape in normal mode
map('n', '<esc>', ':noh<return><esc>')
map('n', '§', ':noh<return><esc>')
-- Clear highlight and enter intert mode
-- map('n', '<cr>', ':noh<return><esc>i<cr>')
-- map('n', '<esc>^[', '<esc>^[')
-- Search for visually hightlig hted text
map('v', '<c-f>', 'y<esc>/<c-r>"<cr>')
map('v', '<c-r>', '"0y<esc>:%s/<c-r>0//g<left><left>')

-- Scroll
-----------------------------------------------------------
-- Scroll using the shifted up/down arrows
map('n', '<S-Down>', '<c-E>')
map('n', '<S-Up>', '<c-Y>')

-- Editing
-----------------------------------------------------------
-- Move lines
map('n', '<a-j>', ':m .+1<cr>')
map('n', '<a-k>', ':m .-2<cr>')
map('i', '<a-j>', '<esc>:m .+1<cr>gi')
map('i', '<a-k>', '<esc>:m .-2<cr>gi')
map('v', '<a-j>', ":m '>+1<cr>gv")
map('v', '<a-k>', ":m '<-2<cr>gv")
-- d is for deleting - skip buffer
map('n', 'd', '"_d')
map('n', 'D', '"_D')
map('v', 'd', '"_d')
-- Add indentation when entering I mode
_G.indent_i = function()
  if fn.len(fn.getline('.')) == 0 then
    -- indent on empty line
    return "\"_cc"
  elseif string.match(fn.strpart(fn.getline('.'), 0, fn.col('.')), '^[ \t]*$') then
    -- skip whitespaces
    return "^i"
  else
    return "i"
  end
end
map('n', 'i', 'v:lua.indent_i()', { expr = true })
map('n', 'a', 'v:lua.indent_i()', { expr = true })
-- New lines from normal mode
map('n', "<leader>'", ':<c-u>call append(line("."),   repeat([""], v:count1))<cr>')
map('n', '<leader>"', ':<c-u>call append(line(".")-1, repeat([""], v:count1))<cr>')
-- Join lines
map('n', '<c-tab>', ':join!')
-- Duplicate lines
map('n', '<c-d>', 'yyp')
map('i', '<c-d>', '<esc>yypi')
map('v', '<c-d>', 'yP')
-- Copy whole line
map('n', 'Y', 'mzVy<esc>`z')
-- Copy whole file
map('v', 'Y', 'mz<esc>ggV<cr>Gy`z')
-- Indent without leaving mode
map('v', '>', '>gv')
map('v', '<', '<gv')

-- Select
-----------------------------------------------------------
-- Select whole file
map('v', 'a', '<esc>ggV<cr>G')

-- Undo and redo
-----------------------------------------------------------
-- Ctrl-u - undo (normal, insert)
-- Ctrl-r - redo (normal, insert)
map('n', '<c-u>', ':undo<cr>')
map('i', '<c-u>', '<c-o>:undo<cr>')
map('v', '<c-u>', '<esc>:undo<cr>')
map('n', '<c-r>', ':redo<cr>')
map('i', '<c-r>', '<c-o>:redo<cr>')
map('v', '<c-r>', '<esc>:redo<cr>')

-- Insert key
-----------------------------------------------------------
map('n', '<insert>', 'R')
map('v', '<insert>', '<esc>R')
map('i', '<expr> <insert>', 'mode() ==# "R" ? "<esc>i" : "<esc>R"')

-- Spell check
-----------------------------------------------------------
map('n', '<F10>', ':set spell!<cr>')
map('i', '<F10>', '<c-O>:set spell!<cr>')

-- Others
-----------------------------------------------------------
-- Toggle word wrap
-- map('n', '<leader>w', ':set wrap!<cr>')
-- Save
map('n', '<c-s>', '<cmd>:w<cr>')
map('i', '<c-s>', '<c-o>:w<cr>')
map('v', '<c-s>', '<esc>:w<cr>')


-- Quit
-- map('n', 'Q', ':qall!<cr>')
map('n', 'Q', ':confirm qall<cr>')
map('n', 'q', '<c-w>q<cr>')
-- semicolon to enter cmd line
map('n', ';', ':')
