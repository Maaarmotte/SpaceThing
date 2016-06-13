local ENT = {}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Base LS device"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.lsEntity = true

function isLSEntity( e )

	return e.lsEntity or false

end

if SERVER then

	
	ST_Groups = ST_Groups or {}
	local groupID = #ST_Groups


	local DEBUG_ON = false

	local function debugPrint(...)
		if DEBUG_ON then
			return print(...)
		end
	end
	
	timer.Create("LifeSupport_Tick", 1, 0, function()

		--PrintTable(ST_Groups)


		for group, devices in pairs(ST_Groups) do
			
			debugPrint("Group", group)

			
			-- Groupe 0 -> pas linké
			if group == 0 then 
				continue
			end

			local resources = {}

			debugPrint("- Recuperation ressources storages")
			-- Premierement on prend toutes les ressources des storages 
			for entID, bool in pairs(devices) do

				if not IsValid(Entity(entID)) then
					
					ST_Groups[group][entID] = nil
					debugPrint("-- Entity " .. entID .. "n'existe plus... supression...")

				elseif bool and isnumber(entID) and Entity(entID):isStorage() then

					for k,v in pairs(Entity(entID):getCapacity()) do

						resources[ v[1] ] = (resources[ v[1] ] or 0) + v[2]

					end

				end

			end
			
			debugPrint("- Utilisation des ressources")			
			-- Ensuite on traite tous les générateurs 
			for entID, bool in pairs(devices) do

				if bool and isnumber(entID) and Entity(entID):isGenerator() then

					debugPrint("-- Generateur:", entID)

					-- On vérifie que le générateur peut pomper ce qu'il a besoin (meet requierements = meetReq) *
					local meetReq = true
					for k,v in pairs(Entity(entID):getRequirements()) do
						
						if (resources[ v[1] ] or 0) < v[2] then
							debugPrint("h")
							meetReq = false
							break
						end

					end

					if meetReq then
						debugPrint("-- Ce generateur peut produire.")
					else
						debugPrint("-- Ce generateur ne peut pas produire.")
					end

					-- Si il peut, on pompe les ressources et on le fait produire.
					if meetReq then
						for k,v in pairs(Entity(entID):getRequirements()) do
							
							resources[v[1]] = (resources[v[1]] or 0) - v[2]

						end

						for k,v in pairs(Entity(entID):getProduction()) do

							resources[v[1]] = (resources[v[1]] or 0) + v[2]

						end
					else

						Entity(entID):dontProduce() 

					end


				end

			end

			debugPrint("- Remise dans les storages")

			-- Enfin on remet les ressources en trop dans les storages
			for entID, bool in pairs(devices) do
			
				if bool and isnumber(entID) and Entity(entID):isStorage() then
					
					resources = Entity(entID):setCapacity( resources )

				end

			end
			debugPrint("- Fini.")


		end

	end)


	function getGroupByID( group )

		return ST_Groups[group]

	end

	/* 
	 * Permet d'attribuer un groupe à un ensemble de machines du LS 
	 * Groupe 0 = Pas de groupe
	 */
	function ENT:setGroup( group )

		if self:getGroup() ~= 0 then
			ST_Groups[self:getGroup()][self:EntIndex()] = nil
		end

		self.group = group or 0

		if self.group ~= 0 then
			ST_Groups[self.group][self:EntIndex()] = true
		end



	end

	function ENT:getGroup( )

		return self.group or 0

	end

	function ENT:createGroup( )

		groupID = groupID + 1
		ST_Groups[groupID] = {}
		self:setGroup( groupID )

	end

	function ENT:isStorage()

		return false

	end
	
	function ENT:isGenerator()

		return false

	end



else
	function ENT:beingLookedAtByLocalPlayer()

		local trace = LocalPlayer():GetEyeTrace()
		
		if trace.Entity ~= self then return false end
		if trace.HitPos:Distance(LocalPlayer():GetShootPos()) > 1000 then return false end

		return true
	end
end

scripted_ents.Register(ENT, "ls_base")
