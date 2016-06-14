local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_storage"
 
ENT.PrintName		= "Battery"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

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

	end

	function ENT:getCapacity()

		return { {"energy", self.energy or 0} }

	end
	
	function ENT:setCapacity( c ) 

		self.energy = math.min(c.energy or 0, 1000)
		self:SetNWInt("energy", self.energy)

		c.energy = c.energy - self.energy

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

scripted_ents.Register(ENT, "ls_battery")
