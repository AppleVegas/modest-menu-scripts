-- Made By AppleVegas
 
local enable = false
 
local speed = 2
 
menu.register_hotkey(32, function()
	if not enable then return end
	local newpos = localplayer:get_position() + vector3(0,0,speed)
 
	localplayer:set_position(newpos)
end)
 
menu.register_hotkey(17, function()
	if not enable then return end
	local newpos = localplayer:get_position() + vector3(0,0,speed * -1)
 
	localplayer:set_position(newpos)
end)
 
menu.register_hotkey(87, function()
	if not enable then return end
	local dir = localplayer:get_heading()
	local newpos = localplayer:get_position() + (dir * speed)
 
	localplayer:set_position(newpos)
end)
 
menu.register_hotkey(83, function()
	if not enable then return end
	local dir = localplayer:get_heading()
	local newpos = localplayer:get_position() + (dir * speed * -1)
 
	localplayer:set_position(newpos)
end)
 
menu.register_hotkey(65, function()
	if not enable then return end
	local dir = localplayer:get_rotation()
	localplayer:set_rotation(dir + vector3(0.5,0,0))
end)
 
menu.register_hotkey(68, function()
	if not enable then return end
	local dir = localplayer:get_rotation()
	localplayer:set_rotation(dir + vector3(0.5 * -1,0,0))
end)
 
function NoClip(e)
	if e then 
		localplayer:set_freeze_momentum(true) 
		localplayer:set_config_flag(292,true)
	else
		localplayer:set_freeze_momentum(false) 
		localplayer:set_config_flag(292,false)
	end
end
 
menu.register_hotkey(51, function()
	enable = not enable 
	NoClip(enable)
end)
 
menu.add_toggle("NoClip", function()
	return enable
end, function()
	enable = not enable 
	NoClip(enable)
end)
 
menu.add_int_range("NoClip Speed", 1, 1, 10, function()
	return speed
end, function(i) speed = i end)
 
-- Thanks for using my scripts!