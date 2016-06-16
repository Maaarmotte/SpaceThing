if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_storage"
 
ENT.PrintName		= "Battery"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

--ENT.Category		= "Life support"
--ENT.Spawnable       = true

if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()
	 
		self:SetModel( "models/props_junk/TrashDumpster01a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self.energy = 0
		self:SetNWInt("energy", self.energy)

	end

	function ENT:getCapacity( c )

		c = c or {}
		c.energy = c.energy or 0

		c.energy = c.energy + self.energy

		return c

	end
	
	function ENT:setCapacity( c ) 


		print("FONCTION DEPRECIEE OMG")
		c = c or {}
		c.energy = c.energy or 0

		self.energy = math.min(c.energy, 1000)
		self:SetNWInt("energy", self.energy)

		c.energy = c.energy - self.energy

		return c

	end 


	function ENT:addToCapacity( c ) 

		c = c or {}
		c.energy = c.energy or 0

		local nextEnergy = math.min( c.energy + self.energy, 1000)
		self:SetNWInt("energy", nextEnergy)

		c.energy = c.energy - (nextEnergy - self.energy)

		self.energy = nextEnergy


		return c

	end 

	function ENT:takeFromCapacity( c )


		
		c = c or {}
		c.energy = c.energy or 0

		local nextEnergy = math.max( self.energy - c.energy , 0)
		self:SetNWInt("energy", nextEnergy)

		c.energy = c.energy - (self.energy - nextEnergy)

		self.energy = nextEnergy

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
			str = str .. "Energy: " .. self:GetNWInt("energy")
			
			AddWorldTip( self:EntIndex(), str, nil, nil, self)

		end

	end

end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_battery") end
