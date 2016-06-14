-- Retrive atmospheres from maps
hook.Add("InitPostEntity", "STFindPlanets", function()
	for k,v in ipairs(ents.GetAll()) do
		if v:GetClass() == "logic_case" then
			local kv = v:GetKeyValues()
			if kv.Case01 == "planet2" then
				local radius = tonumber(kv.Case02) or 0
				local atmo = SThing.AddNewAtmosphere(v:GetPos(), radius)
				atmo:Set("gravity", tonumber(kv.Case03) or 0)
				atmo:Set("oxygen", (tonumber(kv.Case09)/100)*atmo:GetVolume())
				atmo:Set("temperature", (tonumber(kv.Case06) + tonumber(kv.Case07))/2)
			end
		end
	end
end)
