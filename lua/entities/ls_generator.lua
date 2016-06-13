local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_base"
 
ENT.PrintName		= "LS Generator"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then
		 
	function ENT:getRequirements()

		return {}

	end
	
	function ENT:getProduction() 

		return {}

	end 

	function ENT:isGenerator()

		return true

	end



end


scripted_ents.Register(ENT, "ls_generator")