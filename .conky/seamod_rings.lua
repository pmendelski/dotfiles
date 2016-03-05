--==============================================================================
--                            seamod_rings.lua
--
--  Date    : 05/02/2012
--  Author  : SeaJey
--  Version : v0.1
--  License : Distributed under the terms of GNU GPL version 2 or later
--
--  This version is a modification of lunatico_rings.lua wich is modification of conky_orange.lua
--
--  conky_orange.lua:    http://gnome-look.org/content/show.php?content=137503&forumpage=0
--  lunatico_rings.lua:  http://gnome-look.org/content/show.php?content=142884
--==============================================================================

require 'cairo'


--------------------------------------------------------------------------------
--                                                                    gauge DATA
gauge = {
{
    name='cpu',                    arg='cpu0',                  max_value=100,
    x=70,                          y=130,
    graph_radius=124,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=134,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu0',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu1',                  max_value=100,
    x=70,                          y=130,
    graph_radius=116,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=108,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu1',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},

{
    name='cpu',                    arg='cpu2',                  max_value=100,
    x=70,                          y=130,
    graph_radius=88,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=98,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu2',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu3',                  max_value=100,
    x=70,                          y=130,
    graph_radius=82,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=74,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu3',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},


{
    name='cpu',                    arg='cpu4',                  max_value=100,
    x=70,                          y=130,
    graph_radius=54,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=64,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu4',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu5',                  max_value=100,
    x=70,                          y=130,
    graph_radius=48,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=40,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu5',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu6',                  max_value=100,
    x=70,                          y=130,
    graph_radius=20,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=30,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu6',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='cpu',                    arg='cpu7',                  max_value=100,
    x=70,                          y=130,
    graph_radius=14,
    graph_thickness=5,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=4,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=28,
    graduation_thickness=0,        graduation_mark_thickness=1,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='cpu7',
    caption_weight=1,              caption_size=9.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='memperc',                arg='',                      max_value=100,
    x=70,                          y=350,
    graph_radius=54,
    graph_thickness=15,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=39,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='ram',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='swapperc',               arg='',                      max_value=100,
    x=70,                          y=350,
    graph_radius=24,
    graph_thickness=15,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=12,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.5,
    caption='swap',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='fs_used_perc',           arg='/media/mendlik/storage', skip_on_zero=1, max_value=100,
    x=70,                          y=570,
    graph_radius=65,
    graph_thickness=7,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=75,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='storage',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='fs_used_perc',           arg='/home',                     max_value=100,
    x=70,                          y=570,
    graph_radius=50,
    graph_thickness=7,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=40,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='home',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='fs_used_perc',           arg='/',                     max_value=100,
    x=70,                          y=570,
    graph_radius=32,
    graph_thickness=7,
    graph_start_angle=180,
    graph_unit_angle=2.7,          graph_unit_thickness=2.7,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=24,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='root',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='downspeedf',             arg='eth0',   arg_fallback='wlan0',                  max_value='dynamic',
    x=70,                          y=760,
    graph_radius=54,
    graph_thickness=7,
    graph_start_angle=180,
    graph_unit_angle=270,          graph_unit_thickness=270,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=64,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='Down',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
},
{
    name='upspeedf',               arg='eth0',   arg_fallback='wlan0',                     max_value='dynamic',
    x=70,                          y=760,
    graph_radius=42,
    graph_thickness=7,
    graph_start_angle=180,
    graph_unit_angle=270,          graph_unit_thickness=270,
    graph_bg_colour=0xffffff,      graph_bg_alpha=0.1,
    graph_fg_colour=0xFFFFFF,      graph_fg_alpha=0.3,
    hand_fg_colour=0xEF5A29,       hand_fg_alpha=1.0,
    txt_radius=30,
    txt_weight=0,                  txt_size=9.0,
    txt_fg_colour=0xEF5A29,        txt_fg_alpha=1.0,
    graduation_radius=23,
    graduation_thickness=0,        graduation_mark_thickness=2,
    graduation_unit_angle=27,
    graduation_fg_colour=0xFFFFFF, graduation_fg_alpha=0.3,
    caption='Up',
    caption_weight=1,              caption_size=10.0,
    caption_fg_colour=0xFFFFFF,    caption_fg_alpha=0.5,
}
}

-------------------------------------------------------------------------------
--                                                                 rgb_to_r_g_b
-- converts color in hexa to decimal
--
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-------------------------------------------------------------------------------
--                                                            angle_to_position
-- convert degree to rad and rotate (0 degree is top/north)
--
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end


-------------------------------------------------------------------------------
--                                                              draw_gauge_ring
-- displays gauges
--
function draw_gauge_ring(display, data, value)
    local x_offset, y_offset = 75, 10

    local x, y = data['x'] + x_offset , data['y'] + y_offset
    local graph_radius = data['graph_radius']
    local graph_thickness, graph_unit_thickness = data['graph_thickness'], data['graph_unit_thickness']
    local max_value = data['max_value']
    local graph_unit_angle = data['graph_unit_angle']
    local graph_start_angle = data['graph_start_angle']
    local graph_bg_colour, graph_bg_alpha = data['graph_bg_colour'], data['graph_bg_alpha']
    local graph_fg_colour, graph_fg_alpha = data['graph_fg_colour'], data['graph_fg_alpha']
    local hand_fg_colour, hand_fg_alpha = data['hand_fg_colour'], data['hand_fg_alpha']

    if max_value == 'dynamic' then
        if data['max_value_dynamic'] == nil or data['max_value_dynamic'] < value then
            data['max_value_dynamic'] = value
        end
        max_value = data['max_value_dynamic']
        if max_value > 0 then
	        graph_unit_angle = graph_unit_angle / max_value
	        graph_unit_thickness = graph_unit_thickness / max_value
        end
    end

    local graph_end_angle = (max_value * graph_unit_angle) % 360

    -- background ring
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, 0), angle_to_position(graph_start_angle, graph_end_angle))
    cairo_set_source_rgba(display, rgb_to_r_g_b(graph_bg_colour, graph_bg_alpha))
    cairo_set_line_width(display, graph_thickness)
    cairo_stroke(display)

    -- arc of value
    local val = value % (max_value + 1)
    local start_arc = 0
    local stop_arc = 0
    local i = 1
    if max_value > 0 then
	    while i <= val do
	        start_arc = (graph_unit_angle * i) - graph_unit_thickness
	        stop_arc = (graph_unit_angle * i)
	        cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
	        cairo_set_source_rgba(display, rgb_to_r_g_b(graph_fg_colour, graph_fg_alpha))
	        cairo_stroke(display)
	        i = i + 1
	    end
	end
    local angle = start_arc

    -- hand
    start_arc = (graph_unit_angle * val) - (graph_unit_thickness * 2)
    if start_arc < 0 then start_arc = 0 end
    stop_arc = graph_unit_angle * val
    if stop_arc > graph_end_angle then stop_arc = graph_end_angle end
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
    cairo_set_source_rgba(display, rgb_to_r_g_b(hand_fg_colour, hand_fg_alpha))
    cairo_stroke(display)

    -- graduations marks
    local graduation_radius = data['graduation_radius']
    local graduation_thickness, graduation_mark_thickness = data['graduation_thickness'], data['graduation_mark_thickness']
    local graduation_unit_angle = data['graduation_unit_angle']
    local graduation_fg_colour, graduation_fg_alpha = data['graduation_fg_colour'], data['graduation_fg_alpha']
    if graduation_radius > 0 and graduation_thickness > 0 and graduation_unit_angle > 0 then
        local nb_graduation = graph_end_angle / graduation_unit_angle
        local i = 0
        while i < nb_graduation do
            cairo_set_line_width(display, graduation_thickness)
            start_arc = (graduation_unit_angle * i) - (graduation_mark_thickness / 2)
            stop_arc = (graduation_unit_angle * i) + (graduation_mark_thickness / 2)
            cairo_arc(display, x, y, graduation_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
            cairo_set_source_rgba(display,rgb_to_r_g_b(graduation_fg_colour,graduation_fg_alpha))
            cairo_stroke(display)
            cairo_set_line_width(display, graph_thickness)
            i = i + 1
        end
    end

    -- text
    local txt_radius = data['txt_radius']
    local txt_weight, txt_size = data['txt_weight'], data['txt_size']
    local txt_fg_colour, txt_fg_alpha = data['txt_fg_colour'], data['txt_fg_alpha']
    local movex = txt_radius * math.cos(angle_to_position(graph_start_angle, angle))
    local movey = txt_radius * math.sin(angle_to_position(graph_start_angle, angle))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, txt_weight)
    cairo_set_font_size (display, txt_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(txt_fg_colour, txt_fg_alpha))
    cairo_move_to (display, x + movex - (txt_size / 2), y + movey + 3)
    cairo_show_text (display, value)
    cairo_stroke (display)

    -- caption
    local caption = data['caption']
    local caption_weight, caption_size = data['caption_weight'], data['caption_size']
    local caption_fg_colour, caption_fg_alpha = data['caption_fg_colour'], data['caption_fg_alpha']
    local tox = graph_radius * (math.cos((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    local toy = graph_radius * (math.sin((graph_start_angle * 2 * math.pi / 360)-(math.pi/2)))
    cairo_select_font_face (display, "ubuntu", CAIRO_FONT_SLANT_NORMAL, caption_weight);
    cairo_set_font_size (display, caption_size)
    cairo_set_source_rgba (display, rgb_to_r_g_b(caption_fg_colour, caption_fg_alpha))
    cairo_move_to (display, x + tox + 5, y + toy + 1)
    -- bad hack but not enough time !
    if graph_start_angle < 105 then
        cairo_move_to (display, x + tox - 30, y + toy + 1)
    end
    cairo_show_text (display, caption)
    cairo_stroke (display)
end


-------------------------------------------------------------------------------
--                                                               go_gauge_rings
-- loads data and displays gauges
--
function go_gauge_rings(display)
    local function load_gauge_rings(display, data)
        local str, value = 0
        str = string.format('${%s %s}',data['name'], data['arg'])
        str = conky_parse(str)
        value = tonumber(str)
        if value == 0 and data['arg_fallback'] ~= nil then
            str = string.format('${%s %s}',data['name'], data['arg_fallback'])
            str = conky_parse(str)
            value = tonumber(str)
        end
        if value == 0 and data['skip_on_zero'] == 1 then
            return
        end
        draw_gauge_ring(display, data, value)
    end

    for i in pairs(gauge) do
    	pcall(function () load_gauge_rings(display, gauge[i]) end)
    end
end

-------------------------------------------------------------------------------
--                                                                         MAIN
function conky_main()
    if conky_window == nil then
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)

    local updates = conky_parse('${updates}')
    update_num = tonumber(updates)

    if update_num > 5 then
        go_gauge_rings(display)
    end

    cairo_surface_destroy(cs)
    cairo_destroy(display)

end
