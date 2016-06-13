local AdvPlayer = {}
local AdvPlayerMT = { __index = AdvPlayer }

function AdvPlayer.New(ply)
	local self = {}
	setmetatable(self, AdvPlayerMT)
	
	self.ply = ply
	self.properties = {}
	
	return self
end

function AdvPlayer:Set(name, value, sync)
	self.properties[name] = value
	if sync then
		self:Sync(name, type(value))
	end
end

function AdvPlayer:Get(name)
	return self.properties[name]
end

function AdvPlayer:Dec(name, value, sync)
	self:Set(name, self:Get(name) - value, sync)
end

function AdvPlayer:Inc(name, value, sync)
	self:Set(name, self:Get(name) + value, sync)
end

function AdvPlayer:Sync(name)
	local tpe = type(self.properties[name])
	net.Start("AP_PropertyChanged")
		net.WriteString(tpe)
		net.WriteString(name)
		if tpe == "string" then
			net.WriteString(self.properties[name])
		elseif tpe == "number" then
			net.WriteFloat(self.properties[name])
		elseif tpe == "boolean" then
			net.WriteBool(self.properties[name])
		elseif tpe == "Player" or tpe == "Entity" then
			net.WriteEntity(self.properties[name])
		elseif tpe == "Vector" then
			net.WriteVector(self.properties[name])
		elseif tpe == "Angle" then
			net.WriteAngle(self.properties[name])
		else
			print("[AdvPlayer] Couldn't sync the variable")
		end
	net.Send(self.ply)
end

function AdvPlayer:GetPlayer()
	return self.ply
end

-- Global functions
function GetAdvPlayer(ply)
	if ply.advPlayer then
		return ply.advPlayer
	else
		local aPly = AdvPlayer.New(ply)

		-- Save a reference on the player
		ply.advPlayer = aPly
		
		return aPly
	end
end

-- Hooks
if SERVER then
	util.AddNetworkString("AP_PlayerReady")
	util.AddNetworkString("AP_PropertyChanged")
	
	net.Receive("AP_PlayerReady", function(len, ply)
		hook.Call("AP_PlayerReady", GAMEMODE, GetAdvPlayer(ply))
	end)
elseif CLIENT then	
	net.Receive("AP_PropertyChanged", function(len)
		local tpe = net.ReadString()
		local name = net.ReadString()
		local value = nil
		
		if tpe == "string" then
			value = net.ReadString()
		elseif tpe == "number" then
			value = net.ReadFloat()
		elseif tpe == "boolean" then
			value = net.ReadBool()
		elseif tpe == "Player" or tpe == "Entity" then
			value = net.ReadEntity()
		elseif tpe == "Vector" then
			value = net.ReadVector()
		elseif tpe == "Angle" then
			value = net.ReadAngle()
		else
			print("[AdvPlayer] Couldn't sync the variable")
			return
		end
		
		GetAdvPlayer(LocalPlayer()).properties[name] = value
		hook.Call("AP_PropertyChanged", GAMEMODE, GetAdvPlayer(LocalPlayer()), name, value, tpe)
	end)
	
	
	hook.Add("InitPostEntity", "AP_Loaded", function()
		net.Start("AP_PlayerReady")
		net.SendToServer()
		
		hook.Call("AP_PlayerReady", GAMEMODE, GetAdvPlayer(LocalPlayer()))
	end)
end