-- Add default atmospheres

if game.GetMap() == "SB_Forlorn_SB3_R3" then
	local atmo = SThing.AddNewAtmosphere(Vector(8536.486328125, -7700.4086914062, -9223.96875), 5048)	-- Main planet
	atmo:Set("oxygen", 100000)
	
	atmo = SThing.AddNewAtmosphere(Vector(65.182899475098, -8607.6376953125, 10528.03125), 300)			-- Spawn
	atmo:Set("oxygen", 100000)
end
