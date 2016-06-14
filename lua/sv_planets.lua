-- Add default atmospheres

--[[if game.GetMap() == "SB_Forlorn_SB3_R3" then
	local atmo = SThing.AddNewAtmosphere(Vector(8536.486328125, -7700.4086914062, -9223.96875), 5048)	-- Main planet
	atmo:Set("oxygen", 100000)
	atmo:Set("gravity", 1)
	
	atmo = SThing.AddNewAtmosphere(Vector(65.182899475098, -8607.6376953125, 10528.03125), 300)			-- Spawn
	atmo:Set("oxygen", 100000)
	atmo:Set("gravity", 1)
end]]--

-- Retrive atmospheres from maps

hook.Add("InitPostEntity", "STFindPlanets", function()
	for k,v in ipairs(ents.GetAll()) do
		if v:GetClass() == "logic_case" then
			local kv = v:GetKeyValues()
			if kv.Case01 == "planet2" then
				local radius = tonumber(kv.Case02) or 0
				local atmo = SThing.AddNewAtmosphere(v:GetPos(), radius)
				atmo:Set("gravity", tonumber(kv.Case03) or 0)
				atmo:Set("oxygen", (tonumber(kv.Case09)/100)*(4/3)*math.pi*radius*radius*radius)
			end
		end
	end
end)
