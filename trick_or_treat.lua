-- All globals are up to date for 1.64!

function null() end
 
function MPx()
	return "MP"..stats.get_int("MPPLY_LAST_MP_CHAR").."_"
end
 
function TrickOrTreat(c)
    local index = 34253
    local value = false
    i = math.floor((index - 34251) / 64)
	bit = (index - 34251) % 64
	stathash = MPx().."DLC12022PSTAT_BOOL"..i -- 34251-34763
    stats.set_bool_masked(stathash, value, bit) -- with this stat set to true nothing works... lmao?
 
    globals.set_int(2764906 + 498, 1) -- Timer. Never actually changes. But it is in the code, so we reset it to be safe.
    globals.set_int(262145 + 32759, 0) -- Tunable amount collected.
    globals.set_int(2764906 + 591, c) -- Amount collected. Any value but 10 and 200 will give trick/treat randomly. 10 gives 50k (money method?). 1 should display help text.
    globals.set_int(262145 + 32760, 1) -- Tunable (is halloween enabled?)
    globals.set_int(2765539, 1) -- one of triggers, should be anything but -1
    globals.set_int(2765538, 1)  -- does nothing but maybe important so here for flex
    globals.set_int(2764906 + 564, 8) -- 8 is required for halloween collectibles, can be changed to 17 for buried stash (type of collectible collected maybe?...)
    globals.set_int(2764906 + 512, 1) -- something to do with sound, does maybe nothing but maybe important so here for flex
    globals.set_int(2764906 + 214, 1 << 17) -- Trigger Collect
end
 
menu.add_action("Trigger TrickOrTreat", function()
    TrickOrTreat(5) -- Normal collect
end)
 
menu.add_action("Trigger TrickOrTreat 2", function()
    TrickOrTreat(11) -- No full screen text
end)
 
menu.add_action("Trigger Money", function()
    TrickOrTreat(10) -- 50k
end)
 
menu.add_action("Trigger Treat", function()
    TrickOrTreat(200) -- Only treat
end)
 
menu.add_action("Trigger Help", function()
    TrickOrTreat(0) -- Help text
end)
 
menu.add_action("Trigger Up-n-Atomizer Trick", function()
    globals.set_int(2764906 + 579, 0) -- Trick type (0-3)
    globals.set_int(2764906 + 581, 1000000) -- Time. Does nothing? afaik
    globals.set_int(2764906 + 581 + 1, 1) -- Trigger. Should be 1
end)
 
menu.add_action("Trigger Explosion Trick", function()
    globals.set_int(2764906 + 579, 1) -- Trick type (0-3)
    globals.set_int(2764906 + 581, 1000000) -- Time. Does nothing? afaik
    globals.set_int(2764906 + 581 + 1, 1) -- Trigger. Should be 1
end)
 
menu.add_action("Trigger Drugs Trick", function()
    globals.set_int(2764906 + 579, 2) -- Trick type (0-3)
    globals.set_int(2764906 + 581, 1000000) -- Time. Does nothing? afaik
    globals.set_int(2764906 + 581 + 1, 1) -- Trigger. Should be 1
end)
 
menu.add_action("Trigger Shocker Trick", function()
    globals.set_int(2764906 + 579, 3) -- Trick type (0-3)
    globals.set_int(2764906 + 581, 1000000) -- Time. Does nothing? afaik
    globals.set_int(2764906 + 581 + 1, 1) -- Trigger. Should be 1
end)
 
-- No further comments, scripts are long, im tired, you should read them yourself dammit.
-- Made by AppleVegas