SThing = {}
-- Load the different modules
-- Advanced Player Library

AddCSLuaFile("autorun/client/cl_main.lua")
AddCSLuaFile("sh_advplayer.lua")
AddCSLuaFile("sh_atmosphere.lua")
AddCSLuaFile("sh_resources.lua")

include("sh_advplayer.lua")
include("sh_atmosphere.lua")
include("sv_planets.lua")
include("sh_resources.lua")
include("sv_gravity.lua")

local tick = 0
local function main()
	tick = (tick + 1) % 66

	if tick == 0 then
		SThing.UpdatePlayersResources()
	else
		SThing.CalcPartialEntsGravity(65)
	end
end

hook.Add("Tick", "STTick", main)