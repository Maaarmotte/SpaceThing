if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "Solar panel"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

--ENT.Category		= "Life support"
--ENT.Spawnable       = true


if SERVER then
		 
	AddCSLuaFile()

	function ENT:Initialize()
	 
		self:SetModel( "models/props_interiors/Radiator01a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

	end

	function ENT:getRequirements( res )

		return res or {}

	end
	
	function ENT:produce( res ) 

		res = res or {}
		res.energy = (res.energy or 0) + 10

		return res

	end 


else

	function ENT:Think()
		if self:BeingLookedAtByLocalPlayer() then
			local str = "== SOLAR PANEL ==\n"
			str = str .. "Group: " .. self:GetNWInt("group")

			AddWorldTip( self:EntIndex(), str, nil, nil, self)
		end

	end

end


if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_generator_solar") end