-- This script was made before kiddion introduced sleep() and menu.emit_event()
-- so don't be surprised very much 

local function Text(text)
	menu.add_action(text, function() end)
end
 
local threads = 1
local funcs = {}
local curthread = 0
 
local sleeping = {}
local sleepticking = {}
 
local function Thread(func)
	funcs[threads] = func
	threads = threads + 1
end
 
local function sleep(ticks)
	sleeping[curthread] = true
	sleepticking[curthread] = ticks * 100
end
 
local stopped = 0
local function Run()
	for i = 1, (threads - 1) do
		curthread = i
 
		if not sleeping[curthread] then
			if (funcs[i]() == false) then
				funcs[i] = function() end
				stopped = stopped + 1
			end
		else
			if sleepticking[curthread] > 0 then
				sleepticking[curthread] = sleepticking[curthread] - 1
			else
				sleeping[curthread] = false
				if (funcs[i]() == false) then
					funcs[i] = function() end
					stopped = stopped + 1
				end
			end
		end
	end
	if (stopped == (threads - 1)) then
		return false
	end
	return true
end
 
local function ClearThreads()
	sleeping = {} 
	sleepticking = {} 
	threads = 1 
	funcs = {} 
	stopped = 0
end
 
local HealPercent = 1
local HealDelay = 4
local deathdisable = false
local goddisable = true
 
function Main()
	if not localplayer then return false end
 
	local max = localplayer:get_max_health()
	local hp = localplayer:get_health()
 
	if deathdisable and hp <= 100 then return false end
	if goddisable and localplayer:get_godmode() then return false end
 
	local add = max*(HealPercent/100)
 
	if (hp + add) > max then
		add = max - hp
	end
 
	localplayer:set_health(hp + add)
	sleep(500*HealDelay)
end
 
Text("--- AppleVegas's AutoHeal ---")
 
menu.add_toggle("Disable script on death", function() return deathdisable end, function() deathdisable = not deathdisable end)
menu.add_toggle("Disable script when godmodded", function() return goddisable end, function() goddisable = not goddisable end)
menu.add_int_range("Healing Delay", 1, 1, 100, function() return HealDelay end, function(val) HealDelay = val end)
menu.add_int_range("Healing Percent", 1, 1, 100, function() return HealPercent end, function(val) HealPercent = val end)
menu.add_action("Start AutoHeal Script", function() ClearThreads() Thread(Main) while (Run()) do end end)
menu.add_action("Set Myself 1 HP", function() localplayer:set_health(101) end)