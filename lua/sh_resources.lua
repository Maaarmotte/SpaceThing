if SERVER then
	SThing.lastPlayersResourcesUpdate = CurTime()
	SThing.playersResourcesUpdateDelay = 1
	SThing.playerOxygenConsumption = 1
	SThing.playerTemperatureConsumption = 0.01

	function SThing.UpdatePlayersResources()
		if CurTime() - SThing.lastPlayersResourcesUpdate > SThing.playersResourcesUpdateDelay then
			for _,ply in ipairs(player.GetAll()) do
				local aPly = GetAdvPlayer(ply)

				if not aPly:Get("lifesupport") then continue end

				-- Consume oxygen
				local initialOxygen = aPly:Get("oxygen")
				aPly:Set("oxygen", math.max(initialOxygen - SThing.playerOxygenConsumption, 0))

				-- Get the player's atmosphere and try to refill
				local atmo = aPly:Get("atmosphere")

				if not atmo or not atmo:IsInside(ply:GetPos()) then
					atmo = SThing.GetPlayerAtmosphere(ply)
				end

				-- Was able to locate an atmosphere for the player
				if atmo then
					aPly:Set("atmosphere", atmo)
					if atmo:Get("oxygen") >= SThing.playerOxygenConsumption then
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
			end
			SThing.lastPlayersResourcesUpdate = CurTime()
		end
	end

	hook.Add("AP_PlayerReady", "STResources", function(aPly)
		aPly:Set("oxygen", 100, true)
		aPly:Set("temperature", 273, true)
		aPly:Set("lifesupport", true)
	end)	
elseif CLIENT then
	hook.Add("AP_PropertyChanged", "STOxygenUpdate", function(aPly, name, value, tpe)
		print("Oxygen: " .. value .."%")
	end)
	hook.Add("AP_PropertyChanged", "STTemperature", function(aPly, name, value, tpe)
		print("Temperature: " .. value .. "K")
	end)
	
	local sizex = 400
	local sizey = 20
	local gapy = 35
	
	hook.Add("HUDPaint", "STOxygen", function()
		local aPly = GetAdvPlayer(LocalPlayer())
		local oxygen = aPly:Get("oxygen") or 0
		local temperature = aPly:Get("temperature") or 0
		
		if oxygen < 100 then
			local len = sizex*oxygen/100
			
			surface.SetDrawColor(0, 0, 0, 180)
			surface.DrawRect(ScrW()/2 - sizex/2 - 2, ScrH() - sizey - gapy - 2, sizex + 4, sizey + 4)
			
			surface.SetDrawColor(51, 153, 255, 180)
			surface.DrawRect(ScrW()/2 - len/2, ScrH() - sizey - gapy, len, sizey)
		end
		
		local text = temperature .. " K"
		surface.SetFont( "Trebuchet24" )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( ScrW()/2  - surface.GetTextSize(text)/2, ScrH() - sizey - gapy - 2 )
		surface.DrawText(text)
	end)
end