# modest-menu-scripts
 
This is a collection of the scripts I made from 2022 to 2024, back when modest menu was still alive and after Lua scripting was added.

AFAIK none of these work now because modest menu is outdated.

All of these were uploaded by me to UnknownCheats previously, this is a reupload to GitHub. 

## Contents

- [AppleVegas's PlayerList Script](#applevegass-playerlist-script)
- [AppleVegas's BountySuite](#applevegass-bountysuite)
- [AppleVegas's PlayerLog](#applevegass-playerlog)
- [AppleVegas's AutoHeal](#applevegass-autoheal)
- [Rainbow Car Script](#rainbow-car-script)
- [Noclip Script](#noclip-script)
- [Change Model Script](#change-model-script)
- [Trick or Treat Effects Script](#trick-or-treat-effects-script)

***
### AppleVegas's PlayerList Script

My first modest menu script.

As modest menu never really had a player list with trolling options to begin with, this script added that. 

***
### AppleVegas's BountySuite

Ever wanted to set bounty on yourself? To set a bounty with a custom amount? To set bounties without cooldown?
Got you covered!

Features:
- Setting a custom bounty
- Quick selection of "nice" numbers 
- Modifying bounty amount when calling Lester
- Setting bounty on yourself
- Player List to set bounties on players without any cooldowns
- Ability to set bounties for an entire lobby (only use if you are reckless modmenu user)

***
### AppleVegas's PlayerLog

It logs all players that you have happened to be in lobby with (although it is a lot more useful at logging modders). Also it logs all the modders that the script has detected and logs their player names as well.


**Event Logger features:**
- Logging to file
- Logging to Debug Console
- Logging Player Joins/Leaves
- Logging Player Deaths
- Logging Player Teleportations (huge distance travelled in a small amount of time, configurable in settings)
- Logging whenever player enabled or disabled GodMode.

***
### AppleVegas's AutoHeal

Simple auto-healing script that I wrote to prove my "threading" (actually just delayed function loop execution) works. (sleep() wasn't implemented in the API at the time)

***
### Rainbow Car Script

Simple smooth rainbow car paint effect. Speed is adjustable. Uses HSV to RGB conversion.
***
### Noclip Script

A little noclip script I made because i got bored of walking...
Can be activated either from the menu (speed canbe adjusted there too), or by pressing number 3 on the keyboard (at least that bind isconvenient for me ;P)

To activate it you should be on foot and stand still.

***
### Change Model Script

Simple external model changer. 

There was an issue with other model changers where they don't change your model at all, just reset it.

That's because these globals have to be changed very quickly, otherwise your model gets reset.

I attempted to make it work instantly each time, but the sleep() timing should be very precise as it's cpu dependent.

***
### Trick or Treat Effects Script

This script allows you to trigger halloween trick or treat effects. Also a potential money hack, if you press "Trigger Money" a lot of times. (it triggers 50k each time) But i don't recommend, because i haven't tested it for bans.

You can d r u g, explode, shock, up-n-atomize yoursef, which is fun.

