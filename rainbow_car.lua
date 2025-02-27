function hsvToRgb(h, s, v)
    local r, g, b
  
    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);
  
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
  
    return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end
 
b = false
s = 0.5
menu.add_toggle("Smooth Rainbow Car",function() return b end,function() b = not b menu.emit_event("Rainbow_Vehicle_Start") end)
menu.add_float_range("Rainbow Speed", 0.1, 0.1, 2.0,function() return s end,function(v) s = v end)
menu.register_callback("Rainbow_Vehicle_Start", function()
    t = 0
    while b == true do
        t=t+1
        p = localplayer
        v = p and p:get_current_vehicle() or nil
        if v then
            c_r,c_g,c_b = hsvToRgb(t/100 * s, 1, 1)
            v:set_custom_primary_colour(c_r,c_g,c_b)
            v:set_custom_secondary_colour(c_r,c_g,c_b)
        end
        sleep(0.01)
    end
end)