local ENT = {}

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "LS Generator"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

if SERVER then
		 
	function ENT:Initialize()
	 
		self:SetModel( "models/props_junk/TrashDumpster01a.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

	end

	function ENT:getRequirements()

		return {}

	end
	
	function ENT:getProduction() 

		return {{ "energy", 10 }}

	end 

	function ENT:Think()

		self:SetNWInt("group", self:getGroup()) -- TODO: remove

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


scripted_ents.Register(ENT, "ls_generator_solar")