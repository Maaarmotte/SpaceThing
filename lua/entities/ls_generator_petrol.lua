--local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "Engine-generator"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Category		= "Life support"
ENT.Spawnable       = true


if SERVER then
		 
	AddCSLuaFile()

	function ENT:Initialize()
	 
		self:SetModel( "models/props_outland/generator_static01a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

	end

	function ENT:getRequirements()

		return {{ "petrol", 10 }}

	end
	
	function ENT:produce() 

		return {{ "energy", 10 }}

	end 

	function ENT:Think()

		self:SetNWInt("group", self:getGroup()) -- TODO: remove

	end

else

	function ENT:Think()
		if self:BeingLookedAtByLocalPlayer() then
			local str = "== ENGINE-GENERATOR ==\n"
			str = str .. "Group: " .. self:GetNWInt("group")

			AddWorldTip( self:EntIndex(), str, nil, nil, self)
		end

	end

end


--scripted_ents.Register(ENT, "ls_generator_solar")