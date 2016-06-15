--local ENT = {}

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Base LS device"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.lsEntity = true

function isLSEntity( e )

	return (IsValid(e) and e.lsEntity) or false

end

if SERVER then

	AddCSLuaFile()

	
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
			
			--if table.Count(devices) == 0 then return end

			debugPrint("Group", group)

			
			-- Groupe 0 -> pas linké
			if group == 0 then 
				continue
			end

			local resources = {}
			local ressourcesGenerated = {}

			debugPrint("- Recuperation ressources storages")
			-- Premierement on prend toutes les ressources des storages pour vérifier que chaque gen peut 
			-- produire sans avoir à reboucler à travers tous les storages.
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
			-- Ensuite on va utiliser les ressources dans les générateurs
			for entID, bool in pairs(devices) do

				if bool and isnumber(entID) and Entity(entID):isGenerator() then

					debugPrint("-- Generateur:", entID)

					-- On vérifie que le générateur peut pomper ce qu'il a besoin (meet requierements = meetReq) *
					local meetReq = true

					for k,v in pairs(Entity(entID):getRequirements()) do -- On vérifie chaque type de ressource
						
						if (resources[ v[1] ] or 0) < v[2] then
							debugPrint("h")
							meetReq = false
							break
						end

					end


					-- Si il peut produire, on pompe les ressources et on le fait produire.
					if meetReq then

						debugPrint("-- Ce generateur peut produire.")

						-- On parcours tous les types de ressources nécessaires
						for k,v in pairs(Entity(entID):getRequirements()) do
							
							resources[v[1]] = (resources[v[1]] or 0) - v[2] -- On diminue ressources pour les futurs checks de meetReq

							-- On va parcourir toutes les storages pour prendre leur ressource un à un.
							local ressourceToTake = v[2]

							for batID, batBool in pairs( devices ) do

								if batBool and isnumber(batID) and Entity(batID):isStorage() then

									local cap = Entity(batID):getCapacity()[v[1]] or 0
									local take = math.min(ressourceToTake, cap) -- ce qui sera pris dans le conteneur (pas plus que sa capacité maxi)
									ressourceToTake = ressourceToTake - take
								
									Entity(batID):setCapacity( {v[1], (Entity(batID):getCapacity()[v[1]] or 0) - take} )

									if ressourceToTake == 0 then
										break -- Si il n'y a plus de ressource à prendre, pas besoin de parcourir les batteries.
									end
									
								end

							end

						end

						-- On produit et on ajoute dans une variable qui sera déchargée plus tard
						-- dans les storages
						for k,v in pairs(Entity(entID):produce()) do

							ressourcesGenerated[v[1]] = (ressourcesGenerated[v[1]] or 0) + v[2]

						end


					else

						Entity(entID):dontProduce() 
						debugPrint("-- Ce generateur ne peut pas produire.")

					end


				end

			end

			debugPrint("- Remise dans les storages")

			-- Enfin on remet les ressources en trop dans les storages
			for entID, bool in pairs(devices) do
			
				if bool and isnumber(entID) and Entity(entID):isStorage() then
					
					ressourcesGenerated = Entity(entID):addToCapacity( ressourcesGenerated )

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

--scripted_ents.Register(ENT, "ls_base")
