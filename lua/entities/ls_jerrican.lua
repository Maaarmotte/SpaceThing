if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_storage_easy"
 
ENT.PrintName		= "Jerrican"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then

	ENT.model = "models/props_junk/gascan001a.mdl"

	function ENT:getMaxResources()
		return { petrol = { spawn = 300, max = 300 }  }
	end

end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_jerrican") end