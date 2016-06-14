SThing.playersResourcesUpdateDelay = 1
SThing.playerOxygenConsumption = 5
SThing.playerTemperatureConsumption = 5
SThing.playerTemperature = 273
SThing.playerTemperatureTolerance = 50

if SERVER then
	SThing.lastPlayersResourcesUpdate = CurTime()

	function SThing.UpdatePlayersResources()
		for _,ply in ipairs(player.GetAll()) do
			local aPly = GetAdvPlayer(ply)

			if not aPly:Get("lifesupport") then continue end

			-- Consume oxygen
			local initialOxygen = aPly:Get("oxygen")
			aPly:Set("oxygen", math.max(initialOxygen - SThing.playerOxygenConsumption, 0))

			-- Get the player's atmosphere and try to refill
			local atmo = SThing.GetEntityAtmosphere(ply)

			-- Was able to locate an atmosphere for the player
			if atmo then
				aPly:Set("atmosphere", atmo)

				if atmo:Get("oxygen") >= SThing.playerOxygenConsumption and atmo:GetConcentration("oxygen") > 0.17 then
					needed = 100 - aPly:Get("oxygen")
					takeable = math.min(atmo:Get("oxygen"), needed)

					-- Can only take oxygen if not in water !
					if ply:WaterLevel() < 3 then
						atmo:Dec("oxygen", takeable)
						aPly:Inc("oxygen", takeable)
					end
				end
			else
				aPly:Set("atmosphere", nil)
			end

			-- If couldn't refill, damage !
			if aPly:Get("oxygen") <= 0 then
				ply:TakeDamage(10)
			end

			-- Send new level to the player, if necessary
			if aPly:Get("oxygen") != initialOxygen then
				aPly:Sync("oxygen")
			end

			-- Compute the new temperature
			local temperature = 0
			if atmo then
				temperature = atmo:Get("temperature") or 0
			end

			aPly:Inc("temperature", math.Clamp(temperature - aPly:Get("temperature"), -SThing.playerTemperatureConsumption, SThing.playerTemperatureConsumption), true)

			if math.abs(aPly:Get("temperature") - SThing.playerTemperature) > SThing.playerTemperatureTolerance then
				ply:TakeDamage(10)
			end
		end
		SThing.lastPlayersResourcesUpdate = CurTime()
	end

	hook.Add("AP_PlayerReady", "STResources", function(aPly)
		aPly:Set("oxygen", 100, true)
		aPly:Set("temperature", 273, true)
		aPly:Set("lifesupport", true)
	end)

	hook.Add("PlayerSpawn", "STResources", function(ply)
		local aPly = GetAdvPlayer(ply)
		aPly:Set("oxygen", 100, true)
		aPly:Set("temperature", 273, true)
	end)
elseif CLIENT then
	hook.Add("AP_PropertyChanged", "STOxygenUpdate", function(aPly, name, value, tpe)
		print("Oxygen: " .. value .."%")
	end)
	hook.Add("AP_PropertyChanged", "STTemperature", function(aPly, name, value, tpe)
		print("Temperature: " .. value .. "K")
	end)
	
	local sizex = 400
	local sizey = 25
	local gapy = 35
	
	hook.Add("HUDPaint", "STOxygen", function()
		local aPly = GetAdvPlayer(LocalPlayer())
		local oxygen = aPly:Get("oxygen") or 0
		local temperature = aPly:Get("temperature") or 0
		
		if oxygen < 100 or math.abs(temperature - SThing.playerTemperature) > SThing.playerTemperatureTolerance/2 then
			local len = sizex*oxygen/100
			local textColor = Color(0, 0, 0, 255)
			
			surface.SetDrawColor(0, 0, 0, 200)
			surface.DrawRect(ScrW()/2 - sizex/2 - 2, ScrH() - sizey - gapy - 2, sizex + 4, sizey + 4)
			
			surface.SetDrawColor(255, 255, 255, 200)

			if temperature < SThing.playerTemperature - SThing.playerTemperatureTolerance/2 then
				surface.SetDrawColor(30, 168, 227, 200)
				textColor = Color(255, 255, 255, 255)
			elseif temperature > SThing.playerTemperature + SThing.playerTemperatureTolerance/2 then
				surface.SetDrawColor(224, 60, 60, 200)
				textColor = Color(255, 255, 255, 255)
			end

			surface.DrawRect(ScrW()/2 - len/2, ScrH() - sizey - gapy, len, sizey)

			local text = "Oxygen / " .. math.Round(temperature) .. " K"
			surface.SetFont("Trebuchet24")
			surface.SetTextColor(textColor)
			surface.SetTextPos(ScrW()/2  - surface.GetTextSize(text)/2, ScrH() - sizey - gapy - 1)
			surface.DrawText(text)
		end
	end)
end