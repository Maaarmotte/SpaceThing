SThing = {}
-- Load the different modules
-- Advanced Player Library

AddCSLuaFile("autorun/client/cl_main.lua")
AddCSLuaFile("sh_advplayer.lua")
AddCSLuaFile("sh_atmosphere.lua")

include("sh_advplayer.lua")
include("sh_atmosphere.lua")
include("sv_planets.lua")

local function main()
	SThing.UpdatePlayersResources()
end

hook.Add("Tick", "STTick", main)