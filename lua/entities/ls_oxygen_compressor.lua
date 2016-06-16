if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_generator"
 
ENT.PrintName		= "Oxygen compressor"
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

	end

	function ENT:getRequirements( res )

		res = res or {}
		res.energy = (res.energy or 0) + 10

		return res

	end

	function ENT:produce( res )

		local atmo = SThing.GetEntityAtmosphere( self )

		local ox = atmo:Get("oxygen")
		local nextOx = math.max(ox-1000,0)
		atmo:Set("oxygen", nextOx)

		res.oxygen = (res.oxygen or 0) + (ox-nextOx)


		return res or {}

	end 


	function ENT:dontProduce( res ) 

		return res or {}

	end




else

	function ENT:Think()
		if self:BeingLookedAtByLocalPlayer() then
			local str = "== Oxygen compressor ==\n"
			str = str .. "Group: " .. self:GetNWInt("group")

			AddWorldTip( self:EntIndex(), str, nil, nil, self)
		end

	end

end


if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_oxygen_compressor") end