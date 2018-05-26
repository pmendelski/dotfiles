local rings = require 'lua/rings/rings'
local value = require 'lua/rings/value'
local sh = require 'lua/sh'

local active_iface = sh.command('ifconfig -s | tail -n +2 | tr -s " " | cut -d" " -f1,4 | sort -n -k2 | tail -n 1 | cut -d" " -f1')
local current_iface = nil
local max_down_value = 1
local max_up_value = 1

local function ring_def(name, value, idx)
  return {
    caption = name,
    value = value,
    y = 750,
    thickness = 12,
    radius = 70 - idx * 20
  }
end

local function draw(display)
  local iface = active_iface()
  if iface ~= current_iface then
    current_iface = iface
    max_down_value = 1
    max_up_value = 1
  end
  local down_value = value.eval('downspeedf ' .. iface)
  local up_value = value.eval('upspeedf ' .. iface)
  max_down_value = math.max(max_down_value, down_value)
  max_up_value = math.max(max_up_value, up_value)
  rings.draw(display, ring_def('Down', math.floor(down_value / max_down_value * 100.0), 0))
  rings.draw(display, ring_def('Up', math.floor(up_value / max_up_value * 100.0), 1))
end

return {
  draw = draw
}
