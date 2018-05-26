local rings = require 'lua/rings/rings'
local value = require 'lua/rings/value'
local sh = require 'lua/sh'

local list_disks = sh.command('df | grep ^/dev | sed "s|^.*% ||g" | head -n 5 | tac')

local function ring_def(name, disk, idx)
  return {
    caption = name,
    value = value.eval(string.format('fs_used_perc %s', disk)),
    y = 560,
    thickness = 7,
    radius = 65 - idx * 15
  }
end

local function draw(display)
  local disks = list_disks()
  local i = 0
  for disk in string.gmatch(disks,'[^\r\n]+') do
    local last = string.gsub(disk, '(.+/)', '')
    rings.draw(display, ring_def(last, disk, i))
    i = i + 1
  end
end

return {
  draw = draw
}
