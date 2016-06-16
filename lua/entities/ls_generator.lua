if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_base"
 
ENT.PrintName		= "LS Generator"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then

	AddCSLuaFile()
		 
	-- Returns the requirements of the generator
	function ENT:getRequirements( res )

		return res or {}

	end

	-- Will add the production to res and return it
	function ENT:produce( res )

		return res or {}

	end
	
	-- May add some ressources like ENT:produce( res )
	function ENT:dontProduce( res ) 

		return res or {}

	end

	function ENT:isGenerator()

		return true

	end



end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_generator") end