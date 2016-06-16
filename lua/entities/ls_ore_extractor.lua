--[[
--Local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "Ore extractor"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""


if SERVER then

	AddCSLuaFile()
		 
	function ENT:Initialize()
	 
		self:SetModel( "models/props_combine/headcrabcannister01a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_NONE ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end


	end

	function ENT:getRequirements()

		return { {"energy", 20} }

	end
	
	function ENT:produce() 

		return { {"ore", 1} }

	end 

	function ENT:Think()

		self:SetNWInt("group", self:getGroup()) -- TODO: remove

	end




else

	function ENT:Think()
		if self:BeingLookedAtByLocalPlayer() then
			local str = "== Ore extractor ==\n"
			str = str .. "Group: " .. self:GetNWInt("group")

			AddWorldTip( self:EntIndex(), str, nil, nil, self)
		end

	end

end


--scripted_ents.Register(ENT, "ls_ore_extractor)
]]