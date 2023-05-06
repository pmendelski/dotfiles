-- Neovim API aliases
-----------------------------------------------------------
local map = require("util").keymap

-- Init file
-----------------------------------------------------------
-- Edit vimrc configuration file
map("n", "<leader>ve", ":split $MYVIMRC<cr>")
-- Reload vimrc configuration file
map("n", "<leader>vr", ':source $MYVIMRC<cr>:echo "Reloaded: " . $MYVIMRC<cr>', { silent = false })

-- MacOS
-----------------------------------------------------------
-- Map ESC to physical key
map("n", "§", "<esc>")
map("i", "§", "<esc>")
map("x", "§", "<esc>")

-- VIM Diff
-----------------------------------------------------------
-- ]c - next change
-- [c - previous change
map("n", "<leader>ml", ":diffget LOCAL")
map("n", "<leader>mr", ":diffget BASE")
map("n", "<leader>mr", ":diffget REMOTE")

-- Movement
-----------------------------------------------------------
-- Move by visual line not actual line
map("n", "k", "gk")
map("n", "j", "gj")
map("n", "k", "gk")
-- Faster movement
map("n", "<s-j>", "5j")
map("n", "<s-k>", "5k")
map("n", "<s-h>", "5h")
map("n", "<s-l>", "5l")
map("x", "<s-j>", "5j")
map("x", "<s-k>", "5k")
map("x", "<s-h>", "5h")
map("x", "<s-l>", "5l")

-- Buffers
-----------------------------------------------------------
-- Toggle buffers
map("n", "<leader><leader>", "<c-^>")
-- Close buffer
map("n", "<leader>q", ":bp<bar>sp<bar>bn<bar>bd<cr>")
-- Open new file adjacent to current file
map("n", "<leader>e", ':e <C-R>=expand("%:p:h") . "/" <cr>', { silent = false })
-- Open current buffer in a vertical split
map("n", "<leader>w", ":vsp<cr>")

-- Splits
-----------------------------------------------------------
--ctrl-arrow to navigate splits
map("n", "<c-Left>", "<cmd>wincmd h<cr>")
map("n", "<c-Down>", "<cmd>wincmd j<cr>")
map("n", "<c-Up>", "<cmd>wincmd k<cr>")
map("n", "<c-Right>", "<cmd>wincmd l<cr>")
--ctrl-hjkl to change split size
map("n", "<c-h>", "<cmd>vertical resize -5<cr>")
map("n", "<c-j>", "<cmd>resize -5<cr>")
map("n", "<c-k>", "<cmd>resize +5<cr>")
map("n", "<c-l>", "<cmd>vertical resize +5<cr>")

-- Search
-----------------------------------------------------------
-- Search results are in the center of the window
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
-- Clear highlighting on escape in normal mode
map("n", "<esc>", ":noh<return><esc>")
map("n", "§", ":noh<return><esc>")
-- Search for visually hightlighted text
map("x", "<leader>//", 'y<esc>/<c-r>"<cr>', { silent = false })
map("x", "<leader>/?", 'y<esc>:%s/<c-r>"//g<left><left>', { silent = false })
-- Search for current word
map("n", "<leader>//", 'yiw/<c-r>"<cr>', { silent = false })
map("n", "<leader>/?", 'yiw:%s/<c-r>"//g<left><left>', { silent = false })

-- Scroll
-----------------------------------------------------------
-- Scroll using the shifted up/down arrows
map("n", "<S-Down>", "<c-E>")
map("n", "<S-Up>", "<c-Y>")

-- Editing
-----------------------------------------------------------
-- Move lines
map("n", "<a-j>", ":m .+1<cr>")
map("n", "<a-k>", ":m .-2<cr>")
map("i", "<a-j>", "<esc>:m .+1<cr>gi")
map("i", "<a-k>", "<esc>:m .-2<cr>gi")
map("x", "<a-j>", ":m '>+1<cr>gv")
map("x", "<a-k>", ":m '<-2<cr>gv")
-- -- Skip buffer on delete - controversial
-- map("n", "d", '"_d')
-- map("n", "D", '"_D')
-- map("x", "d", '"_d')
-- Duplicate lines
map("n", "<c-d>", "yyp")
map("i", "<c-d>", "<esc>yypi")
map("x", "<c-d>", "yP")
-- Add indentation when entering I mode
-- _G.indent_i = function(ia)
-- 	if fn.len(fn.getline(".")) == 0 then
-- 		-- indent on empty line
-- 		return '"_cc'
-- 	elseif string.match(fn.strpart(fn.getline("."), 0, fn.col(".")), "^[ \t]*$") then
-- 		-- skip whitespaces
-- 		return "^" + ia
-- 	else
-- 		return ia
-- 	end
-- end
-- map("n", "i", "v:lua.indent_i('i')", { expr = true })
-- map("n", "a", "v:lua.indent_i('a')", { expr = true })
-- Indent without leaving mode
map("x", ">", ">gv")
map("x", "<", "<gv")
-- Whole file actions
-- copy file content
map("n", "yY", ":%y<cr>")
-- delete file content
map("n", "dD", ":%d<cr>")
-- change file content
map("n", "cC", ":gg0cG")

-- Undo and redo
-----------------------------------------------------------
-- Ctrl-u - undo (normal, insert)
-- Ctrl-r - redo (normal, insert)
map("n", "<c-u>", ":undo<cr>")
map("i", "<c-u>", "<c-o>:undo<cr>")
map("x", "<c-u>", "<esc>:undo<cr>")
map("n", "<c-r>", ":redo<cr>")
map("i", "<c-r>", "<c-o>:redo<cr>")
map("x", "<c-r>", "<esc>:redo<cr>")

-- Insert key
-----------------------------------------------------------
map("n", "<insert>", "R")
map("x", "<insert>", "<esc>R")
map("i", "<expr> <insert>", 'mode() ==# "R" ? "<esc>i" : "<esc>R"')

-- Spell check
-----------------------------------------------------------
map("n", "<F10>", ":set spell!<cr>")
map("i", "<F10>", "<c-o>:set spell!<cr>")

-- Open link under cursor
------------------------------------------------------------
if vim.fn.has("mac") == 1 then
	map("n", "gx", '<cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<cr>', {})
elseif vim.fn.has("unix") == 1 then
	map("n", "gx", '<cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>', {})
end

-- Others
-----------------------------------------------------------
-- Save
map("n", "<c-s>", ":w<cr>")
map("i", "<c-s>", "<esc>:w<cr>")
map("x", "<c-s>", "<esc>:w<cr>")
-- Save all buffers
map("n", "<leader>s", ":wa<cr>")

-- Quit
-- map('n', 'Q', ':qall!<cr>')
map("n", "Q", ":confirm qall<cr>")
map("n", "q", "<c-w>q")
