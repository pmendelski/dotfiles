local rings = require 'lua/rings/rings'
local value = require 'lua/rings/value'

local function ring_def(name, expr, idx)
    return {
        caption = name,
        value = value.eval(expr),
        y = 350,
        thickness = 15,
        radius = 54 - idx * 30
    }
end

local function draw(display)
    rings.draw(display, ring_def('ram', 'memperc', 0))
    rings.draw(display, ring_def('swap', 'swapperc', 1))
end

return {
    draw = draw
}
