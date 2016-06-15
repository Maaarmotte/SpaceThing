--local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "Atmosphere creator"
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

		self.active = false

	end

	function ENT:getRequirements()

		return { {"energy", 20} }

	end

	function ENT:produce()

		if not self.active then

			self.atmo = SThing.AddNewAtmosphere( self:GetPos(), 4/3*math.pi*1000^3*20 )
			self.atmo:Set("oxygen", 4000)
			self.atmo:SetGravity(1)
			self.active = true

		end

		return {}

	end 


	function ENT:dontProduce() 

		if self.active then

			self.atmo:Remove()
			self.active = false

		end

		return {}

	end

	function ENT:Think()

		if self.active then
			self.atmo:SetPos( self:GetPos() )
		end
		self:SetNWInt("group", self:getGroup()) -- TODO: remove

	end


	function ENT:OnRemove()

		self:dontProduce()

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