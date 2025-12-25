-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- https://www.lazyvim.org/keymaps
-- https://www.lazyvim.org/configuration/general#keymaps

-- Neovim API aliases
-----------------------------------------------------------
local function map_opts(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function map(mode, lhs, rhs, desc)
  local options = { noremap = true, silent = true, desc = desc }
  vim.keymap.set(mode, lhs, rhs, options)
end

-- MacOS
-----------------------------------------------------------
-- Map ESC to physical key
map("n", "§", "<esc>", "MacOS: ESC")
map("i", "§", "<esc>", "MacOS: ESC")
map("x", "§", "<esc>", "MacOS: ESC")

-- VIM Diff
-----------------------------------------------------------
-- ]c - next change
-- [c - previous change
map("n", "<leader>ml", ":diffget LOCAL", "Diff: Use LOCAL")
map("n", "<leader>mb", ":diffget BASE", "Diff: Use BASE")
map("n", "<leader>mr", ":diffget REMOTE", "Diff: Use REMOTE")

-- Splits
-----------------------------------------------------------
--ctrl-arrow to navigate splits
map("n", "<c-Left>", "<cmd>wincmd h<cr>", "Splits: Go to left split")
map("n", "<c-Down>", "<cmd>wincmd j<cr>", "Splits: Go to right split")
map("n", "<c-Up>", "<cmd>wincmd k<cr>", "Splits: Go to above split")
map("n", "<c-Right>", "<cmd>wincmd l<cr>", "Splits: Go to below split")
-- Open current buffer in a vertical split
map("n", "<leader>|", ":vsp<cr>", "Splits: Split vertically")

-- Search
-----------------------------------------------------------
-- Clear highlighting on escape in normal mode
map("n", "<esc>", ":noh<return><esc>")
map("n", "§", ":noh<return><esc>")

-- Editing
-----------------------------------------------------------
-- Move lines
map("n", "<a-j>", ":m .+1<cr>")
map("n", "<a-k>", ":m .-2<cr>")
map("i", "<a-j>", "<esc>:m .+1<cr>gi")
map("i", "<a-k>", "<esc>:m .-2<cr>gi")
map("x", "<a-j>", ":m '>+1<cr>gv")
map("x", "<a-k>", ":m '<-2<cr>gv")
-- Duplicate lines
map("n", "<c-d>", "yyp")
map("i", "<c-d>", "<esc>yypi")
map("x", "<c-d>", "yP")
-- Indent without leaving mode
map("x", ">", ">gv")
map("x", "<", "<gv")
-- Comment with cmd+/
map_opts("n", "<c-_>", "gcc", { remap = true, desc = "Comment" })
map_opts("i", "<c-_>", "<esc>gcci", { remap = true, desc = "Comment" })
map_opts("x", "<c-_>", "gc", { remap = true, desc = "Comment" })

-- Open link under cursor
------------------------------------------------------------
if vim.fn.has("mac") == 1 then
  map("n", "<leader>o", '<cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<cr>', "Open link")
elseif vim.fn.has("unix") == 1 then
  map("n", "<leader>o", '<cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<cr>', "Open link")
end

-- Others
-----------------------------------------------------------
-- Save
map("n", "<c-s>", ":w<cr>")
map("i", "<c-s>", "<esc>:w<cr>i")
map("x", "<c-s>", ":w<cr>")

-- Quit
-- map('n', 'Q', ':qall!<cr>')
map("n", "Q", ":confirm qall<cr>", "Quit all")
map("n", "q", ":confirm q<cr>", "Quit buffer")

-- Reload
map("n", "<leader>R", function()
  -- Reload all unmodified buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_loaded(buf)
      and vim.api.nvim_get_option_value("buftype", { buf = buf }) == ""
      and not vim.api.nvim_get_option_value("modified", { buf = buf })
    then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("edit")
      end)
    end
  end
  vim.notify("Reloaded all", vim.log.levels.INFO)
end, "Refresh reload all buffers")
