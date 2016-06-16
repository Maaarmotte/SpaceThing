if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "Atmosphere creator"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

--ENT.Category		= "Life support"
--ENT.Spawnable       = true

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

	function ENT:getRequirements( res )

		res = res or {}
		res.energy = (res.energy or 0) + 20

		return res

	end

	function ENT:produce( res )

		if not self.active then

			self.atmo = SThing.AddNewAtmosphere( self:GetPos(), 1000 )
			self.atmo:Set("oxygen", 4/3*math.pi*1000^3*20)
			self.atmo:SetGravity(1)
			self.active = true

		end

		return res or {}

	end 


	function ENT:dontProduce( res ) 

		if self.active then

			self.atmo:Remove()
			self.active = false

		end

		return res or {}

	end

	function ENT:Think()

		if self.active then
			self.atmo:SetPos( self:GetPos() )
		end

	end


	function ENT:OnRemove()

		if self.active then

			self.atmo:Remove()

		end
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


if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_generator_atmosphere") end