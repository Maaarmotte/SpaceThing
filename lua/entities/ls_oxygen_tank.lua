if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_storage_easy"
 
ENT.PrintName		= "Oxygen tank"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then

	AddCSLuaFile()


	ENT.model = "models/props_c17/canister01a.mdl"

	function ENT:getMaxResources()
		return { oxygen = { spawn = 0, max = 100000 }  }
	end

end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_oxygen_tank") end