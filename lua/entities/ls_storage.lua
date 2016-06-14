local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_base"
 
ENT.PrintName		= "LS Storage"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then

	AddCSLuaFile()

	function ENT:getCapacity()

		return {}

	end
	
	function ENT:setCapacity() 

		return {}

	end 


	function ENT:isStorage()

		return true

	end
	

end

scripted_ents.Register(ENT, "ls_storage")
