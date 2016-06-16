if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_base"
 
ENT.PrintName		= "LS Storage"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then

	AddCSLuaFile()

	-- Will return the current capacity of the storage (or add it to the variable provided)
	function ENT:getCapacity( c )

		return c or {}

	end
	
	-- Will set the ressources in c to the storage
	-- and will eventualy return the ressources that could not be stored
	function ENT:setCapacity( c ) 

		return c or {}

	end 

	-- Will add the ressources in c to the storage
	-- and will eventualy return the ressources that could not be stored
	function ENT:addToCapacity( c ) 

		return c or {}

	end 

	function ENT:takeFromCapacity( c )

		return c or {}

	end

	function ENT:isStorage()

		return true

	end
	

end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_storage") end
