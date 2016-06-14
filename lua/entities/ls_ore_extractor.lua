--local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "LifeSupport atmosphere creator"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.Category		= "Life support"
ENT.Spawnable       = true

if SERVER then

	AddCSLuaFile()
		 
	function ENT:Initialize()
	 
		self:SetModel( "models/props_wasteland/laundry_washer003.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self.atmo = SThing.AddNewAtmosphere( self:GetPos(), 1000 )
		self.atmo:Set("oxygen", 4000)

	end

	function ENT:getRequirements()

		return { {"energy", 20} }

	end
	
	function ENT:getProduction() 

		return {}

	end 

	function ENT:Think()

		self.atmo:SetPos( self:GetPos() )
		self:SetNWInt("group", self:getGroup()) -- TODO: remove

	end



else

	function ENT:Think()
		if self:BeingLookedAtByLocalPlayer() then
			local str = "== Atmophere creator ==\n"
			str = str .. "Group: " .. self:GetNWInt("group")

			AddWorldTip( self:EntIndex(), str, nil, nil, self)
		end

	end

end


--scripted_ents.Register(ENT, "ls_generator_atmosphere")