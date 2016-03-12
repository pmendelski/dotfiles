require 'cairo'

gaugeDefault = {
    max_value = 100,
    graph_start_angle = 180,
    graph_unit_angle = 2.7, graph_unit_thickness = 2.7,
    graph_bg_colour = 0xFFFFFF, graph_bg_alpha = 0.1,
    graph_fg_colour = 0xFFFFFF, graph_fg_alpha = 0.3,
    hand_fg_colour = 0xEF5A29, hand_fg_alpha = 1.0,
    txt_weight = 0, txt_size = 9.0,
    txt_fg_colour = 0xEF5A29, txt_fg_alpha = 1.0,
    graduation_radius = 23,
    graduation_thickness = 0, graduation_mark_thickness = 2,
    graduation_unit_angle = 27,
    graduation_fg_colour = 0xFFFFFF, graduation_fg_alpha = 0.3,
    caption_weight = 1, caption_size = 10.0,
    caption_fg_colour = 0xFFFFFF, caption_fg_alpha = 0.5
};

function buildCpuGauge(idx)
    local gauge = {
        parent = gaugeDefault,
        value = 'cpu cpu', max_value = 100,
        x = 70, y = 130,
        graph_thickness = 5,
        graduation_radius = 28,
        graduation_mark_thickness = 1,
        caption = 'cpu?',
        caption_size = 9.0,
        value = string.format('cpu cpu%d', idx), caption = string.format('cpu%d', idx),
        if_expr = string.format('if_existing /sys/devices/system/cpu/cpu%d', idx)
    }
    gauge['graph_radius'] = 124 - math.floor(idx / 2) * 36
    gauge['txt_radius'] = gauge['graph_radius'] + 10
    if idx % 2 == 1 then
        gauge['graph_radius'] = gauge['graph_radius'] - 8
        gauge['txt_radius'] = gauge['graph_radius'] - 8
    end
    return gauge
end

function buildMemGauge(caption, value, idx)
    local gauge = {
        parent = gaugeDefault,
        caption = caption, value = value,
        x = 70, y = 350,
        graph_thickness=15,
        graph_radius = 54 - idx * 30
    }
    gauge['txt_radius'] = gauge['graph_radius'] - 15
    return gauge
end

function buildFsGauge(caption, value, idx)
    local gauge = {
        parent = gaugeDefault,
        caption = caption, value = string.format('fs_used_perc %s', value),
        x = 70, y = 570,
        graph_thickness = 7,
        graph_radius = 65 - idx * 15,
        if_expr = string.format('if_existing %s', value)
    }
    gauge['txt_radius'] = gauge['graph_radius'] - 15
    return gauge
end

function buildLanGauge(caption, value, expr, idx)
    local gauge = {
        parent = gaugeDefault,
        caption = caption, value = value,
        x = 70, y = 760,
        graph_thickness = 7,
        graph_radius = 54 - idx * 12,
        if_expr = expr
    }
    gauge['txt_radius'] = gauge['graph_radius'] + 12
    if idx % 2 == 1 then
        gauge['txt_radius'] = gauge['graph_radius'] - 12
    end
    return gauge
end

gauge = {
    buildCpuGauge(0), buildCpuGauge(1),
    buildCpuGauge(2), buildCpuGauge(3),
    buildCpuGauge(4), buildCpuGauge(5),
    buildCpuGauge(6), buildCpuGauge(7),

    buildMemGauge('ram', 'memperc', 0),
    buildMemGauge('swap', 'swapperc', 1),

    buildFsGauge('storage', '/media/mendlik/storage', 0),
    buildFsGauge('home', '/home', 1),
    buildFsGauge('root', '/', 2),

    buildLanGauge('Down', 'downspeedf wlan0', 'if_existing /sys/class/net/eth0/operstate down', 0),
    buildLanGauge('Up', 'upspeedf wlan0', 'if_existing /sys/class/net/eth0/operstate down', 1),
    buildLanGauge('Down', 'downspeedf eth0', 'if_existing /sys/class/net/eth0/operstate up', 0),
    buildLanGauge('Up', 'upspeedf eth0', 'if_existing /sys/class/net/eth0/operstate up', 1)
}

-- Converts color in hexa to decimal
function rgb_to_r_g_b(colour, alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

-- Convert degree to rad and rotate (0 degree is top/north)
function angle_to_position(start_angle, current_angle)
    local pos = current_angle + start_angle
    return ( ( pos * (2 * math.pi / 360) ) - (math.pi / 2) )
end

-- Displays gauges
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

    if max_value ==  'dynamic' then
        if data['max_value_dynamic'] ==  nil or data['max_value_dynamic'] < value then
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
    -- print('Printing arc of value ', value)
    local val = value % (max_value + 1)
    local start_arc = 0
    local stop_arc = 0
    local i = 1
    if max_value > 0 then
        while i <=  val do
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
    -- print('Printing hand')
    start_arc = (graph_unit_angle * val) - (graph_unit_thickness * 2)
    if start_arc < 0 then start_arc = 0 end
    stop_arc = graph_unit_angle * val
    if stop_arc > graph_end_angle then stop_arc = graph_end_angle end
    cairo_arc(display, x, y, graph_radius, angle_to_position(graph_start_angle, start_arc), angle_to_position(graph_start_angle, stop_arc))
    cairo_set_source_rgba(display, rgb_to_r_g_b(hand_fg_colour, hand_fg_alpha))
    cairo_stroke(display)

    -- graduation marks
    -- print('Printing graduation marks')
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
    -- print('Printing text')
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
    -- print('Printing caption')
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

-- Merges parent property into the table
function merge_parents(table)
    local parent = table.parent
    if parent ==  nil then return end
    if parent.parent ~=  nil then merge_parents(parent.parent) end
    table.parent = nil
    for k, v in pairs(parent) do
        if table[k] ==  nil then
            table[k] = v
        end
    end
end

function gauge_rings(display)
    local function load_gauge_rings(display, data)
        if data['if_expr'] ~= nil then
            local expr = string.format('${%s}1${else}0${endif}', data['if_expr'])
            expr = conky_parse(expr)
            -- print('if_expr', data['if_expr'], expr)
            if tonumber(expr) == 0 then return end
        end
        local value = string.format('${%s}', data['value'])
        value = conky_parse(value)
        value = tonumber(value)
        if value ==  0 and data['skip_zero'] ==  1 then
            return
        end
        draw_gauge_ring(display, data, value)
    end

    for k,data in pairs(gauge) do
        merge_parents(data)
        pcall(function () load_gauge_rings(display, data) end)
    end
end

function conky_main()
    if conky_window ==  nil then
        return
    end
    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)
    gauge_rings(display)
    cairo_surface_destroy(cs)
    cairo_destroy(display)
end
