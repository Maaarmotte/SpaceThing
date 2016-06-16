if(CurTime() > 120) then ENT = {} end

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Base LS device"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.lsEntity = true

ENT.runningSound = nil

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

	local function getAllRessourcesAvailable( group, devices )

		local resourcesAvailable = {}
		

		debugPrint("- Recuperation ressources storages")
		-- Premierement on prend toutes les ressources des storages pour vérifier que chaque gen peut 
		-- produire sans avoir à reboucler à travers tous les storages.
		for entID, bool in pairs(devices) do

			if not IsValid(Entity(entID)) then
				
				ST_Groups[group][entID] = nil
				debugPrint("-- Entity " .. entID .. "n'existe plus... supression...")

			elseif bool and isnumber(entID) and Entity(entID):isStorage() then

				resourcesAvailable = Entity(entID):getCapacity( resourcesAvailable )

			end

		end

		return resourcesAvailable

	end

	local function makeTheGeneratorProcessTheRessources( resourcesAvailable, ressourcesGenerated, entID, devices  )

		debugPrint("-- Generateur:", entID)

		-- On vérifie que le générateur peut pomper ce qu'il a besoin (meet requierements = meetReq) *
		local meetReq = true

		for res, amount in pairs(Entity(entID):getRequirements()) do -- On vérifie chaque type de ressource
			
			if (resourcesAvailable[res] or 0) < amount then
				meetReq = false
				break
			end

		end

		-- Si il peut produire, on pompe les ressources et on le fait produire.
		if meetReq then

			debugPrint("-- Ce generateur peut produire.")

			-- On parcours tous les types de ressources nécessaires
			local ressourceToTake = Entity(entID):getRequirements()

			for res, amount in pairs(ressourceToTake) do

				resourcesAvailable[res] = (resourcesAvailable[res] or 0) - amount -- On diminue ressources pour les futurs checks de meetReq
			
			end

			-- On va parcourir toutes les storages pour prendre leur ressource un à un.
			for batID, batBool in pairs( devices ) do

				if batBool and isnumber(batID) and Entity(batID):isStorage() then

					Entity(batID):takeFromCapacity( ressourceToTake )

					if table.Count(ressourceToTake) == 0 then
						break -- Si il n'y a plus de ressource à prendre, pas besoin de parcourir les batteries.
					end
					
				end

			end


			-- On produit et on ajoute dans une variable qui sera déchargée plus tard
			-- dans les storages
			ressourcesGenerated = Entity(entID):produce( ressourcesGenerated )

		else

			ressourcesGenerated = Entity(entID):dontProduce( ressourcesGenerated ) 
			debugPrint("-- Ce generateur ne peut pas produire.")

		end

		local shouldStartPlaying = !Entity(entID).active and meetReq

		if shouldStartPlaying and Entity(entID).runningSound then
			Entity(entID):EmitSound(Entity(entID).runningSound)
		elseif not meetReq and Entity(entID).runningSound then
			Entity(entID):StopSound(Entity(entID).runningSound)
		end
		
		Entity(entID).active = meetReq
	end
	
	local function processGroup( group, devices )

		-- Si il n'y a pas de machine dans le groupe ou que c'est le groupe 0 on passe.
		if group == 0 or table.Count(devices) == 0 then 

			return

		end
		debugPrint("Group: ", group)


		local ressourcesGenerated = {}
		local resourcesAvailable = getAllRessourcesAvailable( group, devices )
		
		debugPrint("- Utilisation des ressources")			
		-- Ensuite on va utiliser les ressources dans les générateurs
		for entID, bool in pairs(devices) do

			if bool and isnumber(entID) and Entity(entID):isGenerator() then

				makeTheGeneratorProcessTheRessources( resourcesAvailable, ressourcesGenerated, entID, devices )

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

	timer.Create("LifeSupport_Tick", 1, 0, function()

		for group, devices in pairs(ST_Groups) do
			
			processGroup( group, devices )

		end

	end)


	function getGroupByID( group )

		return ST_Groups[group]

	end

	 
	-- Permet d'attribuer un groupe à un ensemble de machines du LS 
	-- Groupe 0 = Pas de groupe

	function ENT:setGroup( group )

		if self:getGroup() ~= 0 then
			ST_Groups[self:getGroup()][self:EntIndex()] = nil
		end

		self.group = group or 0
		self:SetNWInt("group", self.group)

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

	function ENT:Remove()
		if self.active and self.runningSound then
			self:StopSound(self.runningSound)
		end
	end
else
	function ENT:beingLookedAtByLocalPlayer()

		local trace = LocalPlayer():GetEyeTrace()
		
		if trace.Entity ~= self then return false end
		if trace.HitPos:Distance(LocalPlayer():GetShootPos()) > 1000 then return false end

		return true
	end
end

if(CurTime() > 120) then scripted_ents.Register(ENT, "ls_base") end

