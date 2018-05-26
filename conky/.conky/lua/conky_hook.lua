require 'cairo'

local cpu_rings = require 'lua/rings/cpu'
local mem_rings = require 'lua/rings/mem'
local io_rings = require 'lua/rings/io'
local net_rings = require 'lua/rings/net'

local function draw_rings(display)
  cpu_rings.draw(display)
  mem_rings.draw(display)
  io_rings.draw(display)
  net_rings.draw(display)
end

function conky_hook()
  if conky_window == nil then return end
  local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
  local display = cairo_create(cs)
  draw_rings(display)
  cairo_surface_destroy(cs)
  cairo_destroy(display)
  display = nil
end
