--local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_storage"
 
ENT.PrintName		= "Jerrican"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

--ENT.Category		= "Life support"
--ENT.Spawnable       = true

if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()
	 
		self:SetModel( "models/props_junk/gascan001a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self.petrol = 300
		self:SetNWInt("petrol", elf.petrol)

	end

	function ENT:getCapacity()

		return { {"petrol", self.petrol or 0} }

	end
	
	function ENT:setCapacity( c ) 

		self.petrol = math.min(c.petrol or 0, 1000)
		self:SetNWInt("petrol", self.petrol)

		c.petrol = c.petrol - self.petrol

		return c

	end 


	function ENT:addToCapacity( c ) 

		self.petrol = self.petrol or 0
		c.petrol = c.petrol or 0

		local nextPetrol = math.min( (c.petrol or 0) + self.petrol, 1000)
		self:SetNWInt("petrol", nextPetrol)

		c.petrol = c.petrol - (nextPetrol - self.petrol)

		self.petrol = nextPetrol

		return c

	end 

	

	function ENT:Think()

		self:SetNWInt("group", self:getGroup()) -- TODO: remove

	end



else


	function ENT:Think()
		if self:BeingLookedAtByLocalPlayer() then
			local str = "== BATTERY ==\n"
			str = str .. "Group: " .. self:GetNWInt("group") .. "\n"
			str = str .. "Petrol: " .. self:GetNWInt("petrol")
			
			AddWorldTip( self:EntIndex(), str, nil, nil, self)

		end

	end

end

--scripted_ents.Register(ENT, "ls_battery")
