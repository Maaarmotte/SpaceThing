if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_storage_easy"
 
ENT.PrintName		= "Battery"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then

	ENT.model = "models/props_junk/TrashDumpster01a.mdl"

	function ENT:getMaxResources()
		return { energy = { spawn = 0, max = 1000 } }
	end

end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_battery") end