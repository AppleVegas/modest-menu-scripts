local function null() end
local function clamp(num, min, max) if num > max then return max elseif num < min then return min else return num end end
local function multstr(s,n) for i = 0, n - 1 do s = s..s end return s end
local function PrintTable(T, O) if not O then O = 0 end if O == 0 then print(tostring(T)..":") end for k,v in pairs(T) do if type(v) == "table" then print(multstr("   ",O)..k.." ("..tostring(v)..") =") PrintTable(v, O + 1) else print(multstr("   ",O)..k.." ("..type(v)..") = "..tostring(v)) end end end
local function traveldisttosqr(vec1, vec2) return ((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2) end

-- Lua namespaces be like
local PlayerLog = {}
PlayerLog.Config = {}
PlayerLog.Config.Launches = 0
PlayerLog.Config.Log = {}
PlayerLog.Config.Log.Players = true
PlayerLog.Config.Log.Modders = true
PlayerLog.Config.Log.EventLogger = {}
PlayerLog.Config.Log.EventLogger.Enabled = false
PlayerLog.Config.Log.EventLogger.SaveInterval = 1
PlayerLog.Config.Log.EventLogger.LogToConsole = false
PlayerLog.Config.Log.EventLogger.PlayerJoins = true
PlayerLog.Config.Log.EventLogger.PlayerLeaves = true
PlayerLog.Config.Log.EventLogger.PlayerDeaths = true
PlayerLog.Config.Log.EventLogger.PlayerTeleports = true
PlayerLog.Config.Log.EventLogger.PlayerTeleportThreshold = 5000
PlayerLog.Config.Log.EventLogger.PlayerGodmodes = true
PlayerLog.EventLogger = {}
PlayerLog.EventLogger.log = {}
PlayerLog.EventLogger.OnlinePlayers = {}
PlayerLog.EventLogger.CachedPlayers = {}
PlayerLog.EventLogger.SaveWait = 0
PlayerLog.Config.SaveInterval = 10
PlayerLog.SaveWait = 0
PlayerLog.Time = 0
PlayerLog.Players = {}
PlayerLog.Players[0] = {}
PlayerLog.Modders = {}
PlayerLog.Modders[0] = {}
PlayerLog.EmptyPlayer = {nil, nil, nil}

PlayerLog.LaunchFile = function(bool)
    json.savefile("playerlog_launched", {bool})
end

PlayerLog.LoadLaunchFile = function()
    local s, c = pcall(json.loadfile, "playerlog_launched")
    if s then
        return c[1]
    end
    return false
end

PlayerLog.LoadPlayers = function()
    local s, c = pcall(json.loadfile, "playerlog_players.json")
    if s then
        PlayerLog.Players = c
        PlayerLog.Players[0] = {}
        for i = 1, #c do
            PlayerLog.Players[0][c[i][1]] = {i, c[i][2]}
        end
    end
end

PlayerLog.SavePlayers = function()
    local a = {table.unpack(PlayerLog.Players)}
    a[0] = nil
    json.savefile("playerlog_players.json", a)
end

PlayerLog.LoadModders = function()
    local s, c = pcall(json.loadfile, "playerlog_modders.json")
    if s then
        PlayerLog.Modders = c
        PlayerLog.Modders[0] = {}
        for i = 1, #c do
            PlayerLog.Modders[0][c[i][1]] = {i, c[i][2], c[i][3]}
        end
    end
end

PlayerLog.SaveModders = function()
    local a = {table.unpack(PlayerLog.Modders)}
    a[0] = nil
    json.savefile("playerlog_modders.json", a)
end

PlayerLog.LoadConfig = function()
    local s, c = pcall(json.loadfile, "playerlog.json")
    if s then
        PlayerLog.Config = c
    end
end

PlayerLog.SaveConfig = function()
    json.savefile("playerlog.json", PlayerLog.Config)
end

PlayerLog.LoadAll = function()
    PlayerLog.LoadPlayers()
    PlayerLog.LoadModders()
    PlayerLog.LoadConfig()
end

PlayerLog.SaveAll = function()
    PlayerLog.SavePlayers()
    PlayerLog.SaveModders()
    PlayerLog.SaveConfig()
end

PlayerLog.GetPlayer = function(player)
    if type(player) == "string" then
        local p = PlayerLog.Players[0][player]
        return p and p or PlayerLog.EmptyPlayer
    else
        local p = PlayerLog.Players[player]
        return p and p or PlayerLog.EmptyPlayer
    end
end

PlayerLog.AddPlayer = function(player_name)
    if PlayerLog.GetPlayer(player_name)[1] then
        PlayerLog.Players[0][player_name][2] = PlayerLog.Config.Launches
        PlayerLog.Players[PlayerLog.Players[0][player_name][1]][2] = PlayerLog.Config.Launches
        return
    end
    PlayerLog.Players[0][player_name] = {#PlayerLog.Players + 1, PlayerLog.Config.Launches}
    PlayerLog.Players[#PlayerLog.Players + 1] = {player_name, PlayerLog.Config.Launches}
end

PlayerLog.RemovePlayer = function(player)
    local index = player
    if type(player) == "string" then
        index = PlayerLog.Players[0][player][1]
    end
    table.remove(PlayerLog.Players, index)
    PlayerLog.Players[0][player] = nil
    for i = index, #PlayerLog.Players do
        PlayerLog.Players[0][PlayerLog.Players[i][1]] = {i, PlayerLog.Players[i][2]}
    end
end

PlayerLog.GetModder = function(player)
    if type(player) == "string" then
        local p = PlayerLog.Modders[0][player]
        return p and p or PlayerLog.EmptyPlayer
    else
        local p = PlayerLog.Modders[player]
        return p and p or PlayerLog.EmptyPlayer
    end
end

PlayerLog.AddModder = function(player_name, reason)
    if PlayerLog.GetModder(player_name)[1] then
        PlayerLog.Modders[0][player_name][2] = PlayerLog.Config.Launches
        PlayerLog.Modders[PlayerLog.Modders[0][player_name][1]][2] = PlayerLog.Config.Launches
        return
    end
    PlayerLog.Modders[0][player_name] = {#PlayerLog.Modders + 1, PlayerLog.Config.Launches, reason}
    PlayerLog.Modders[#PlayerLog.Modders + 1] = {player_name, PlayerLog.Config.Launches, reason}
end

PlayerLog.RemoveModder = function(player)
    local index = player
    if type(player) == "string" then
        index = PlayerLog.Modders[0][player][1]
    end
    table.remove(PlayerLog.Players, index)
    PlayerLog.Modders[0][player] = nil
    for i = index, #PlayerLog.Modders do
        PlayerLog.Modders[0][PlayerLog.Modders[i][1]] = {i, PlayerLog.Modders[i][2], PlayerLog.Modders[i][3]}
    end
end

PlayerLog.EventLogger.SaveLog = function()
    json.savefile("./logs/playerlog_launch_"..tostring(PlayerLog.Config.Launches)..".json", PlayerLog.EventLogger.log)
end

PlayerLog.EventLogger.Log = function(text)
    local h = math.floor((PlayerLog.Time % 86400)/3600) 
    local m = math.floor((PlayerLog.Time % 3600)/60) 
    local s = math.floor((PlayerLog.Time % 60)) 
    local message = string.format("[%02d:%02d:%02d]: %s", h, m, s, text)
    PlayerLog.EventLogger.log[#PlayerLog.EventLogger.log + 1] = message
    if PlayerLog.Config.Log.EventLogger.LogToConsole then
        print(message)
    end
end

PlayerLog.EventLogger.LogJoin = function(player_name)
    local message = string.format("Player %s has joined.", player_name)
    PlayerLog.EventLogger.Log(message)
end

PlayerLog.EventLogger.LogLeave = function(player_name)
    local message = string.format("Player %s has left.", player_name)
    PlayerLog.EventLogger.Log(message)
end

PlayerLog.EventLogger.LogDeath = function(player_name)
    local message = string.format("Player %s died.", player_name)
    PlayerLog.EventLogger.Log(message)
end

PlayerLog.EventLogger.LogGodmode = function(player_name, bool)
    local message = string.format("Player %s has %s GodMode.", player_name, bool and "enabled" or "disabled")
    PlayerLog.EventLogger.Log(message)
end

PlayerLog.EventLogger.LogTeleport = function(player_name, vec1, vec2)
    local message = string.format("Player %s has teleported from (%.3f, %.3f, %.3f) to (%.3f, %.3f, %.3f) (travelled more than %d units).", player_name, vec1.x, vec1.y, vec1.z, vec2.x, vec2.y, vec2.z, PlayerLog.Config.Log.EventLogger.PlayerTeleportThreshold)
    PlayerLog.EventLogger.Log(message)
end

PlayerLog.EventLogger.CheckOnline = function()
    for k,v in pairs(PlayerLog.EventLogger.CachedPlayers) do
        if not PlayerLog.EventLogger.OnlinePlayers[k] then
            PlayerLog.EventLogger.LogLeave(k)
            PlayerLog.EventLogger.CachedPlayers[k] = nil
        end
    end
end

PlayerLog.EventLogger.Process = function(ply, name)
    if not PlayerLog.EventLogger.CachedPlayers[name] then
        if PlayerLog.Config.Log.EventLogger.PlayerJoins then
            PlayerLog.EventLogger.LogJoin(name)
        end
        local god = ply:get_godmode()
        local pos = ply:get_position()
        local health = ply:get_health()
        if god and PlayerLog.Config.Log.EventLogger.PlayerGodmodes then
            PlayerLog.EventLogger.LogGodmode(name, true)
        end
        if health and health < 100 and PlayerLog.Config.Log.EventLogger.PlayerDeaths then
            PlayerLog.EventLogger.LogDeath(name)
        end
        PlayerLog.EventLogger.CachedPlayers[name] = {god, pos, health < 100}
    else
        local god = ply:get_godmode()
        local pos = ply:get_position()
        local health = ply:get_health()
        if ((god and not PlayerLog.EventLogger.CachedPlayers[name][1]) or (not god and PlayerLog.EventLogger.CachedPlayers[name][1])) and PlayerLog.Config.Log.EventLogger.PlayerGodmodes then
            PlayerLog.EventLogger.LogGodmode(name, god)
        end
        if (health < 100 and not PlayerLog.EventLogger.CachedPlayers[name][3]) and PlayerLog.Config.Log.EventLogger.PlayerDeaths then
            PlayerLog.EventLogger.LogDeath(name)
            PlayerLog.EventLogger.CachedPlayers[name][3] = true
        elseif (health >= 100) then
            PlayerLog.EventLogger.CachedPlayers[name][3] = false
        end
        if PlayerLog.Config.Log.EventLogger.PlayerTeleports then
            local travelled = traveldisttosqr(PlayerLog.EventLogger.CachedPlayers[name][2], pos)
            if travelled >= PlayerLog.Config.Log.EventLogger.PlayerTeleportThreshold^2 then
                PlayerLog.EventLogger.LogTeleport(name, PlayerLog.EventLogger.CachedPlayers[name][2], pos)
            end
        end
        PlayerLog.EventLogger.CachedPlayers[name] = {god, pos, PlayerLog.EventLogger.CachedPlayers[name][3]}
    end
end

PlayerLog.IsModder = function(ply)
    if ply == nil then return nil end
    if ply:get_max_health() < 100 then return "Undead Offradar" end
    if ply:is_in_vehicle() and ply:get_godmode() then return "GodMode" end
    if ply:get_run_speed() > 1.0 or ply:get_swim_speed() > 1.0 then return "SpeedHack" end
 
    return nil
end

PlayerLog.BuildLoggedPlayersMenu = function(sub)
    local page = 1
    local maxpages = 1
    local c = 1
    local sort = true
    sub:add_bare_item("< Page 1 of 1 >", function() c = #PlayerLog.Players maxpages = math.ceil(c/15) page = clamp(page,1,maxpages) return "< Page "..page.." of "..maxpages.." >| Total Logged: "..c end, null, function() page = page - 1 return "< Page "..page.." of "..maxpages.." >| Total Logged: "..c end, function() page = page + 1 return "< Page "..page.." of "..maxpages.." >| Total Logged: "..c end)
    sub:add_bare_item("----------------------------------------------", null, null, null, null)
    sub:add_bare_item("Player Name | Seen Script Launches Ago", null, null, null, null)
    for i = 1, 15 do
        sub:add_bare_item(""..i,function()
            local info = PlayerLog.GetPlayer(sort and (#PlayerLog.Players + 1 - (((page - 1) * 15) + i)) or (((page - 1) * 15) + i))
            local name = info[1]
            if not name then return "" end
            local last_seen = info[2]
            local launches_ago = PlayerLog.Config.Launches - last_seen
            local s = name.."|"..launches_ago
        return s end, null, null, null)
    end
    sub:add_bare_item("----------------------------------------------", null, null, null, null)
    local func = function() sort = not sort return "Sorting |"..(sort and "< Newest To Oldest >" or "< Oldest To Newest >") end
    sub:add_bare_item("Sorting |", function() return "Sorting |"..(sort and "< Newest To Oldest >" or "< Oldest To Newest >") end, null, func, func)
end

PlayerLog.BuildLoggedModdersMenu = function(sub)
    local page = 1
    local maxpages = 1
    local c = 1
    local sort = true
    sub:add_bare_item("< Page 1 of 1 >", function() c = #PlayerLog.Modders maxpages = math.ceil(c/15) page = clamp(page,1,maxpages) return "< Page "..page.." of "..maxpages.." >| Total Logged: "..c end, null, function() page = page - 1 return "< Page "..page.." of "..maxpages.." >| Total Logged: "..c end, function() page = page + 1 return "< Page "..page.." of "..maxpages.." >| Total Logged: "..c end)
    sub:add_bare_item("----------------------------------------------", null, null, null, null)
    sub:add_bare_item("Modder Name | Reason / Launches Ago", null, null, null, null)
    for i = 1, 15 do
        sub:add_bare_item(""..i,function() 
            local info = PlayerLog.GetModder(sort and (#PlayerLog.Modders + 1 - (((page - 1) * 15) + i)) or (((page - 1) * 15) + i))
            local name = info[1]
            if not name then return "" end
            local last_seen = info[2]
            local reason = info[3]
            local launches_ago = PlayerLog.Config.Launches - last_seen
            local s = name.."|"..tostring(reason).." / "..launches_ago
        return s end, null, null, null)
    end
    sub:add_bare_item("----------------------------------------------", null, null, null, null)
    local func = function() sort = not sort return "Sorting |"..(sort and "< Newest To Oldest >" or "< Oldest To Newest >") end
    sub:add_bare_item("Sorting |", function() return "Sorting |"..(sort and "< Newest To Oldest >" or "< Oldest To Newest >") end, null, func, func)
end
 

PlayerLog.LaunchFile(true) -- Creating launch file to tell previous Loop() to end.
sleep(2) -- While we are sleeping we expect Loop() to end when checking for a launch file.
PlayerLog.LaunchFile(false) -- "Removing" launch file to start new Loop().
PlayerLog.LoadAll()
PlayerLog.Config.Launches = PlayerLog.Config.Launches + 1
PlayerLog.SaveConfig()
 
-- Building Menus
local PlayerLogMenu = menu.add_submenu("AppleVegas's PlayerLog")
 
local PlayerLogPlayers = PlayerLogMenu:add_submenu("Logged Players")
PlayerLog.BuildLoggedPlayersMenu(PlayerLogPlayers)
PlayerLogPlayers:add_action("Clear Logged Players", function()
    PlayerLog.Players = {}
    PlayerLog.SavePlayers()
    PlayerLog.Players[0] = {}
end)
 
local PlayerLogModders = PlayerLogMenu:add_submenu("Logged Modders")
PlayerLog.BuildLoggedModdersMenu(PlayerLogModders)
PlayerLogModders:add_action("Clear Logged Modders", function()
    PlayerLog.Modders = {}
    PlayerLog.SaveModders()
    PlayerLog.Modders[0] = {}
end)
 
local PlayerLogSettings = PlayerLogMenu:add_submenu("Settings")
PlayerLogSettings:add_toggle("Log Players", function() return PlayerLog.Config.Log.Players end, function(v) PlayerLog.Config.Log.Players = v end)
PlayerLogSettings:add_toggle("Log Modders", function() return PlayerLog.Config.Log.Modders end, function(v) PlayerLog.Config.Log.Modders = v end)
 
local EventLogger = PlayerLogSettings:add_submenu("Event Logger")
EventLogger:add_toggle("Enabled", function() return PlayerLog.Config.Log.EventLogger.Enabled end, function(v) PlayerLog.Config.Log.EventLogger.Enabled = v end)
EventLogger:add_toggle("Log To Console", function() return PlayerLog.Config.Log.EventLogger.LogToConsole end, function(v) PlayerLog.Config.Log.EventLogger.LogToConsole = v end)
EventLogger:add_int_range("Event Logs Saving Interval (Seconds)", 1, 1, 120, function() return PlayerLog.Config.Log.EventLogger.SaveInterval end, function(v) PlayerLog.Config.Log.EventLogger.SaveInterval = v end)
EventLogger:add_toggle("Log Player Joins", function() return PlayerLog.Config.Log.EventLogger.PlayerJoins end, function(v) PlayerLog.Config.Log.EventLogger.PlayerJoins = v end)
EventLogger:add_toggle("Log Player Leaves", function() return PlayerLog.Config.Log.EventLogger.PlayerLeaves end, function(v) PlayerLog.Config.Log.EventLogger.PlayerLeaves = v end)
EventLogger:add_toggle("Log Player Deaths", function() return PlayerLog.Config.Log.EventLogger.PlayerDeaths end, function(v) PlayerLog.Config.Log.EventLogger.PlayerDeaths = v end)
EventLogger:add_toggle("Log Player Teleports", function() return PlayerLog.Config.Log.EventLogger.PlayerTeleports end, function(v) PlayerLog.Config.Log.EventLogger.PlayerTeleports = v end)
EventLogger:add_int_range("Player Teleport Threshold (Units)", 1000, 1000, 10000, function() return PlayerLog.Config.Log.EventLogger.PlayerTeleportThreshold end, function(v) PlayerLog.Config.Log.EventLogger.PlayerTeleportThreshold = v end)
EventLogger:add_toggle("Log Player GodModes", function() return PlayerLog.Config.Log.EventLogger.PlayerGodmodes end, function(v) PlayerLog.Config.Log.EventLogger.PlayerGodmodes = v end)
 
PlayerLogSettings:add_int_range("Player Logs Saving Interval (Seconds)", 1, 1, 120, function() return PlayerLog.Config.SaveInterval end, function(v) PlayerLog.Config.SaveInterval = v end)
PlayerLogSettings:add_action("Save Config", function() PlayerLog.SaveConfig() end)
 
menu.add_player_action("Mark As Logged Modder", function() PlayerLog.AddModder(player.get_player_name(menu.get_selected_player_index()), "Manually Added") end)
menu.add_player_action("Remove from Modder Log", function() PlayerLog.RemoveModder(player.get_player_name(menu.get_selected_player_index())) end)

-- Main Loop
local LoopCallback = nil 
local function Loop()
    menu.remove_callback(LoopCallback)
    stop = false
    while (true) do
        if not stop then
            if PlayerLog.LoadLaunchFile() then PlayerLog.SavePlayers() PlayerLog.SaveModders() PlayerLog.EventLogger.SaveLog() stop = true end -- If launch file exists, Loop() "dies" (goes into empty infinite sleep because menu crashes otherwise).
            --PrintTable(PlayerLog.Players)
            PlayerLog.EventLogger.OnlinePlayers = {}
            for i = 0, 31 do
		        local ply = player.get_player_ped(i)
                if ply == nil or ply == localplayer then goto continue end
                local name = player.get_player_name(i)
                if PlayerLog.Config.Log.Players then
                    local logged = PlayerLog.GetPlayer(name)[2]
                    if not logged or logged < PlayerLog.Config.Launches then
                        PlayerLog.AddPlayer(name)
                    end
                end
                if PlayerLog.Config.Log.Modders then
                    local reason = PlayerLog.IsModder(ply)
                    if reason then
                        local logged = PlayerLog.GetModder(name)[2]
                        if not logged or logged < PlayerLog.Config.Launches then
                            PlayerLog.AddModder(name, reason)
                        end
                    end
                end
                if PlayerLog.Config.Log.EventLogger.Enabled then
                    PlayerLog.EventLogger.OnlinePlayers[name] = true 
                    PlayerLog.EventLogger.Process(ply, name)
                end
                ::continue::
            end
            if PlayerLog.SaveWait >= PlayerLog.Config.SaveInterval then
                if PlayerLog.Config.Log.Players then PlayerLog.SavePlayers() end
                if PlayerLog.Config.Log.Modders then PlayerLog.SaveModders() end
                
                PlayerLog.SaveWait = 0
            end
            PlayerLog.SaveWait = PlayerLog.SaveWait + 1
 
            if PlayerLog.EventLogger.SaveWait >= PlayerLog.Config.Log.EventLogger.SaveInterval then
                if PlayerLog.Config.Log.EventLogger.Enabled then PlayerLog.EventLogger.SaveLog() end
                
                PlayerLog.EventLogger.SaveWait = 0
            end
            PlayerLog.EventLogger.SaveWait = PlayerLog.EventLogger.SaveWait + 1
 
            PlayerLog.Time = PlayerLog.Time + 1
            sleep(0.5)
            if PlayerLog.Config.Log.EventLogger.Enabled then   
                PlayerLog.EventLogger.CheckOnline()
            end
            sleep(0.5)
        else
            sleep(1000) -- I HAD TO DO IT. Otherwise when Loop() ends, in case we reload scripts, the menu WILL crash.
        end
    end
end
 
LoopCallback = menu.register_callback("OnScriptsLoaded", Loop)