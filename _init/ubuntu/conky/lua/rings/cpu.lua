local rings = require 'lua/rings/rings'
local value = require 'lua/rings/value'
local sh = require 'lua/sh'

local core_count = tonumber(sh('lscpu --parse=cpu | tail -n 1'))

local function ring_def(idx)
  local ring = {
    caption = string.format('cpu%d', idx),
    value = value.eval(string.format('cpu cpu%d', idx)),
    y = 130,
    radius = 18 + math.floor(idx / 2) * 36,
    thickness = 5
  }
  if idx % 2 == 0 then
    ring.radius = ring.radius - 8
  end
  return ring
end

local function draw(display)
  for i=0,core_count do
    rings.draw(display, ring_def(i))
  end
end

return {
  draw = draw
}
