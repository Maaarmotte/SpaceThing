if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "ls_storage"
 
ENT.PrintName		= "Storage easy"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

--ENT.Category		= "Life support"
--ENT.Spawnable       = true

if SERVER then

	AddCSLuaFile()


	ENT.model = "models/props_c17/FurnitureToilet001a.mdl"

	function ENT:getMaxResources()

		return { randomResource = { spawn = 0, max = 42 } }
	end

	function ENT:Initialize()
	 
		self:SetModel( self.model )
		self:PhysicsInit( SOLID_VPHYSICS )   
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS ) 
	 
	    local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end

		self.maxResources = self:getMaxResources()
		self.resource = {}

		for res, resTable in pairs(self.maxResources) do

			self.resource[res] = resTable.spawn
			

		end


	

		self:SetNWString( "capacity", util.TableToJSON(self.resource) )

		

	end

	function ENT:getCapacity( c )

		c = c or {}

		for k,v in pairs( self.resource ) do

			c[k] = (c[k] or 0) + v

		end

		return c

	end


	function ENT:addToCapacity( c ) 

		c = c or {}
		
		for k,v in pairs( self.resource ) do

			c[k] = (c[k] or 0) 

			local nextRes = math.min( c[k] + v, self.maxResources[k].max )
			c[k] = c[k] - (nextRes - self.resource[k])
			self.resource[k] = nextRes

		end

		self:SetNWString( "capacity", util.TableToJSON(self.resource) )

		return c

	end 

	function ENT:takeFromCapacity( c )


		c = c or {}

		for k,v in pairs( self.resource ) do

			c[k] = (c[k] or 0) 

			local nextRes = math.max( v - c[k], 0 )
			c[k] = c[k] - (self.resource[k] - nextRes)
			self.resource[k] = nextRes

		end

		self:SetNWString( "capacity", util.TableToJSON(self.resource) )

		return c

	end

else


	function ENT:Think()
		if self:BeingLookedAtByLocalPlayer() then
			local str = "== "..self.PrintName.." ==\n"
			str = str .. "Group: " .. self:GetNWInt("group") .. "\n"
			
			res = util.JSONToTable(self:GetNWString("capacity"))
			
			if res and istable(res) then
				for k,v in pairs(res) do

					str = str .. string.upper(k) ..": " .. v .. "\n"

				end
			end
			
			AddWorldTip( self:EntIndex(), str, nil, nil, self)

		end

	end

end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_storage_easy") end
