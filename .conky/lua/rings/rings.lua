require 'cairo'
local config = require 'lua/rings/config'

local function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
end

local function merge(t1, t2)
    local result = {}
    -- merge fields between t1 and t2
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                result[k] = merge(t1[k], v)
            else
                result[k] = merge(v, {})
            end
        elseif type(t1[k] or false) == "table" then
            result[k] = merge(t1[k], {})
        else
            result[k] = t1[k] or v
        end
    end
    -- add missing fields from t1
    for k,v in pairs(t1) do
        if result[k] == nil then
            if type(v) == "table" then
                result[k] = merge(v, {})
            else
                result[k] = v
            end
        end
    end
    return result
end

local function color_hex2dec(color, alpha)
    return ((color / 0x10000) % 0x100) / 255., ((color / 0x100) % 0x100) / 255., (color % 0x100) / 255., alpha
end

local function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ((pos * (2 * math.pi / 360) ) - (math.pi / 2))
end

local function select_font(display, font)
    cairo_select_font_face(display, font.name, CAIRO_FONT_SLANT_NORMAL, font.weight);
    cairo_set_font_size(display, font.size)
    cairo_set_source_rgba(display, color_hex2dec(font.color, font.alpha))
end

local function draw_arc(display, style, x, y, radius, start_angle, end_angle)
    cairo_arc(display, x, y, radius, angle_to_position(start_angle, 0), angle_to_position(start_angle, end_angle))
    cairo_set_source_rgba(display, color_hex2dec(style.color, style.alpha))
    cairo_set_line_width(display, style.thickness)
    cairo_stroke(display)
end

local function draw_background_ring(display, data)
    local end_angle = (100 * data.unit_angle) % 360
    draw_arc(display, data.graph_arc, data.x, data.y, data.radius, data.start_angle, end_angle)
end

local function draw_value_arc(display, data)
    draw_arc(display, data.value_arc, data.x, data.y, data.radius, data.start_angle, data.unit_angle * data.value)
end

local function draw_value_hand(display, data)
    local unit_angle = data.unit_angle
    local end_angle = 100 * unit_angle
    local start_arc = unit_angle * (data.value - 1)
    if start_arc < 0 then start_arc = 0 end
    local stop_arc = unit_angle
    if data.value <= 0 then start_arc = 0 end
    draw_arc(display, data.hand_arc, data.x, data.y, data.radius, data.start_angle + start_arc, stop_arc)
end

local function draw_caption_and_value(display, data)
    local tox = data.radius * (math.cos((data.start_angle * 2 * math.pi / 360) - (math.pi/2))) - 3
    local toy = data.radius * (math.sin((data.start_angle * 2 * math.pi / 360) - (math.pi/2))) + 2
    cairo_move_to(display, data.x + tox + 5, data.y + toy + 1)
    select_font(display, data.caption_font)
    cairo_show_text(display, string.sub(data.caption, 1, 10) .. ' ')
    select_font(display, data.value_font)
    cairo_show_text(display, data.value .. '%')
    cairo_stroke(display)
end

local function translate_ring(raw_ring)
    local ring = merge(raw_ring, config.default_ring)
    ring.x = ring.x + config.x_offset
    ring.y = ring.y + config.y_offset
    ring.graph_arc.thickness = ring.graph_arc.thickness or ring.thickness
    ring.hand_arc.thickness = ring.hand_arc.thickness or ring.thickness
    ring.value_arc.thickness = ring.value_arc.thickness or ring.thickness
    return ring
end

local function draw_ring(display, data)
    local ring = translate_ring(data)
    draw_background_ring(display, ring)
    draw_value_arc(display, ring)
    draw_value_hand(display, ring)
    draw_caption_and_value(display, ring)
end

local function draw(display, ring)
    pcall(function () draw_ring(display, ring) end)
    -- draw_ring(display, ring)
end

return {
    draw = draw
}
