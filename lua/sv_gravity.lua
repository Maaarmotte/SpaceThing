-- Manage gravity for the other entities
local iter = 0
local index = 1
local entities = {}
local ignored = {}
local step = 0
function SThing.CalcPartialEntsGravity(ticks)
	if iter == ticks then
		iter = 0
		index = 1
	end
	if iter == 0 then
		entities = ents.GetAll()
		step = math.ceil(#entities/(ticks - 1))	-- TODO: Find a better repartition...
	else
		for i = 1, step do
			local ent = entities[index]
			if IsValid(ent) and not ignored[ent] then
				local atmo = SThing.GetEntityAtmosphere(ent)

				if not ent:IsPlayer() then
					local phys = ent:GetPhysicsObject()

					if IsValid(phys) then
						if atmo and atmo:Get("gravity") and atmo:Get("gravity") > 0 then
							phys:EnableGravity(true)
						else
							phys:EnableGravity(false)
						end
					else
						ignored[ent] = true	-- Ignore if it has no physics object...
					end
				else -- if ent:IsPlayer()
					if atmo and atmo:Get("gravity") then
						ent:SetGravity(atmo:Get("gravity") + 0.000000000001)
					else
						ent:SetGravity(0.000000000001)
					end
				end
			end
			index = index + 1
		end
	end
	iter = iter + 1
end

-- Hooks
hook.Add("AP_PlayerReady", "STGravity", function(aPly)
	aPly:GetPlayer():SetGravity(0.00000000001)
end)

hook.Add("InitPostEntity", "STGravity", function()
	local count = 0
	for _,ent in pairs(ents.GetAll()) do
		ignored[ent] = true
		count = count + 1
	end
	print("[SpaceThing] " .. count .. " entities will ignore gravity")
end)