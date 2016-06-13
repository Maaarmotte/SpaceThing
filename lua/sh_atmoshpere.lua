local STAtmosphere = {}
local STAtmosphereMT = { __index = STAtmosphere }

function STAtmosphere.New(position, radius)
	local self = {}
	setmetatable(self, STAtmosphereMT)
	
	self.properties = {}
	
	self:Set("position", position)
	self:Set("radius", radius)
	self:Set("oxygen", 0)
	self:Set("temperature", 273.15)
	
	return self
end

function STAtmosphere:Set(name, value)
	self.properties[name] = value
end

function STAtmosphere:Get(name)
	return self.properties[name]
end

function STAtmosphere:Dec(name, value)
	self:Set(name, self:Get(name) - value)
end

function STAtmosphere:Inc(name, value)
	self:Set(name, self:Get(name) + value)
end

function STAtmosphere:IsInside(position)
	return (position - self:Get("position")):Length() <= self:Get("radius")
end

function SThing.AddNewAtmosphere(position, radius)
	local atmo = STAtmosphere.New(position, radius)
	table.insert(SThing.atmospheres, atmo)
	return atmo
end

-- Return the player's closest atmosphere
function SThing.GetPlayerAtmosphere(ply)
	local closest = nil
	local shortestDist = 100000
	for _,atmo in ipairs(SThing.atmospheres) do
		local distance = atmo:Get("position"):Distance(ply:GetPos())
		if distance < atmo:Get("radius") and distance < shortestDist then
			closest = atmo
			shortestDist = distance
		end
	end
	return closest
end

SThing.atmospheres = {}
