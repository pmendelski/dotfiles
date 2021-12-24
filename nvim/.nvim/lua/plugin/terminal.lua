local fterm = require("FTerm")
local tutils = require("FTerm.utils")

local commands = {
  term1 = "",
  term2 = "",
  term3 = "",
  term4 = "",
  term5 = "",
  htop = "htop",
  bpytop = "bpytop",
  lazygit = "lazygit",
}

local _M = {}
local current
local terms_by_name = {}

local function is_opened(terminal)
  return terminal ~= nil and terminal.buf ~= nil and terminal.win ~= nil and tutils.is_win_valid(terminal.win)
end

function _M.config()
  fterm.setup({})
end

function _M.toggle(name)
  if commands[name] == nil then
    return
  end
  local terminal = terms_by_name[name]
  if terminal == nil then
    if is_opened(current) then
      current:close()
    end
    local terminal = commands[name] ~= ""
      and fterm:new({ cmd = commands[name] })
      or fterm:new({})
    terms_by_name[name] = terminal
    terminal:toggle()
    current = terminal
  elseif current == terminal then
    if is_opened(current) then
      current:close()
    else
      current:open()
    end
  else
    if is_opened(current) then
      current:close()
    end
    terminal:open()
    current = terminal
  end
end

function _M.toggle_active()
  if current ~= nil then
    current:toggle()
  else
    _M.toggle("term1")
  end
end

function _M.close_active()
  if current ~= nil then
    current:close(true)
  end
end

local map = require('util').keymap
map('t', '<a-h>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("htop")<cr>')
map('t', '<a-b>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("bpytop")<cr>')
map('t', '<a-g>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("lazygit")<cr>')
map('t', '<a-1>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("term1")<cr>')
map('t', '<a-2>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("term2")<cr>')
map('t', '<a-3>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("term3")<cr>')
map('t', '<a-4>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("term4")<cr>')
map('t', '<a-5>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("term5")<cr>')
map('n', '<a-t>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle_active()<cr>')
map('t', '<a-t>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle_active()<cr>')
map('t', '<a-x>', '<c-\\><c-n><cmd>lua require("plugin/terminal").close_active()<cr>')
map('t', '<esc>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle_active()<cr>')
map('t', '<S-Down>', '<c-\\><c-n><c-E>')
map('t', '<S-Up>', '<c-\\><c-n><c-Y>')
-- map('t', '<esc>', '<c-\\><c-n>') -- go to normal mode
map('n', '<leader>th', '<cmd>lua require("plugin/terminal").toggle("htop")<cr>')
map('n', '<leader>tb', '<cmd>lua require("plugin/terminal").toggle("bpytop")<cr>')
map('n', '<leader>tg', '<cmd>lua require("plugin/terminal").toggle("lazygit")<cr>')
map('n', '<leader>t1', '<cmd>lua require("plugin/terminal").toggle("term1")<cr>')
map('n', '<leader>t2', '<cmd>lua require("plugin/terminal").toggle("term2")<cr>')
map('n', '<leader>t3', '<cmd>lua require("plugin/terminal").toggle("term3")<cr>')
map('n', '<leader>t4', '<cmd>lua require("plugin/terminal").toggle("term4")<cr>')
map('n', '<leader>t5', '<cmd>lua require("plugin/terminal").toggle("term5")<cr>')

map('t', '<F1>', '<c-\\><c-n><cmd>lua require("plugin/terminal").toggle("term1")<cr>')
map('n', '<F1>', '<cmd>lua require("plugin/terminal").toggle("term1")<cr>')
map('i', '<F1>', '<esc><cmd>lua require("plugin/terminal").toggle("term1")<cr>')

return _M
