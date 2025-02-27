-- All globals are up to date for 1.67!

local function null() end 
 
local function Text(submenu, text)
	if (submenu ~= nil) then
		submenu:add_action(text, null)
	else
		menu.add_action(text, null)
	end
end
 
local function GetPlayerCount()
	return player.get_number_of_players()
end
 
-- 1.67 globals. Found by: me (AppleVegas).
local global_bountymoney = 2359296 + 1 + (0 * 5568) + 5150 + 14 -- Bounty amount when setting bounty in yourself.
local global_basebounty = 2794162
local global_bountyset = global_basebounty + 1893 + 57 -- Trigger set bounty on yourself.
 
local global_overridebase = 262145
local money = 1000;
local minpay = 1000
local numbers = {"1", "19", "69", "228", "666", "1337", "6969", "9696", "10000"}
local npos = 1
 
local function calculateFee(amount)
	local fee = 0
	if amount > minpay then
		fee = (amount - minpay) * -1
	elseif amount < minpay then
		fee = (minpay - amount)
	else
		fee = 0
	end
    return fee
end
 
local function overrideBounty(amount)
    local fee = calculateFee(amount)
	globals.set_int(global_overridebase + 2348, minpay)
	globals.set_int(global_overridebase + 2349, minpay)
	globals.set_int(global_overridebase + 2350, minpay)
	globals.set_int(global_overridebase + 2351, minpay)
	globals.set_int(global_overridebase + 2352, minpay)
	globals.set_int(global_overridebase + 7188, fee)
end
 
local function resetoverrideBounty()
	globals.set_int(global_overridebase + 2348, 2000)
	globals.set_int(global_overridebase + 2349, 4000)
	globals.set_int(global_overridebase + 2350, 6000)
	globals.set_int(global_overridebase + 2351, 8000)
	globals.set_int(global_overridebase + 2352, 10000)
	globals.set_int(global_overridebase + 7188, 1000)
end
 
local function sendbounty(id, amount)
    overrideBounty(amount)
    globals.set_int(global_basebounty + 4571, id)
	globals.set_int(global_basebounty + 4571 + 1, 1)
	globals.set_bool(global_basebounty + 4571 + 2 + 1, true)
    sleep(1)
    resetoverrideBounty()
end
 
--If you ever use this option i hope you know what you're doing
local function i_am_reckless_modmenu_user_i_want_mayhem(amount)
    overrideBounty(amount)
    for i = 0, 31 do
		local ply = player.get_player_ped(i)
		if ply then 
            globals.set_int(global_basebounty + 4571, i)
            globals.set_int(global_basebounty + 4571 + 1, 1)
            globals.set_bool(global_basebounty + 4571 + 2 + 1, true)
        end
        sleep(1)
    end
    resetoverrideBounty()
end
 
local sub = menu.add_submenu("AppleVegas's BountySuite")
 
local plylist = nil
 
local function makeop()
    local bs = menu.add_player_submenu("BountySuite")
    bs:add_int_range("Amount", 100, 0, 10000, function() return money end, function(a) money = a end)
    bs:add_array_item("Nice numbers", numbers, function() return npos end, 
    function(a) 
    	npos = a 
    	money = tonumber(numbers[npos])
    end)
	bs:add_action("Set Bounty", function() sendbounty(menu.get_selected_player_index(), money) end)
end
 
local function updateplylist()
    plylist:clear()
    
    plylist:add_int_range("Amount", 100, 0, 10000, function() return money end, function(a) money = a end)
    plylist:add_array_item("Nice numbers", numbers, function() return npos end, 
    function(a) 
    	npos = a 
    	money = tonumber(numbers[npos])
    end)
    plylist:add_bare_item("---AppleVegas's BountySuite, "..GetPlayerCount().." Players---", function() return "---AppleVegas's BountySuite, "..GetPlayerCount().." Players---" end, null, null, null)
    for i = 0, 31 do
		local ply = player.get_player_ped(i)
		if ply then 
			plylist:add_bare_item(player.get_player_name(i), function() return player.get_player_ped(i) ~= nil and (player.get_player_ped(i) == localplayer and "YOU" or player.get_player_name(i)) or "**Invalid**" end, function() local id = i sendbounty(id, money) end, null, null)
		end
	end
    Text(plylist, "---End---")
    
    --If you ever use this option i hope you know what you're doing
    plylist:add_action("\u{26A0} All Online Players (Takes a long time) \u{26A0}", function() i_am_reckless_modmenu_user_i_want_mayhem(money) end)
end
plylist = sub:add_submenu("Set Bounty On Players", function() updateplylist() end)
 
sub:add_int_range("Set Bounty On Yourself", 100, 1, 10000, function() return money end, 
function(a)
	money = a
	globals.set_int(global_bountymoney, money)
	globals.set_int(global_bountyset, 0)
end)
 
sub:add_int_range("Override Lester Bounty", 100, 0, 10000, function() return money end, 
function(a)
	money = a
	overrideBounty(money)
end)
 
sub:add_array_item("Nice numbers", numbers, function() return npos end, 
function(a) 
	npos = a 
	money = tonumber(numbers[npos])
end)
 
--sub:add_action("Lose Bounty", function()
--    globals.set_int(global_dropbounty, 0)
--end)
 
sub:add_action("Reset Lester Override", function()
    resetoverrideBounty()
end)
 
makeop()