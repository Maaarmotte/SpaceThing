local STAtmosphere = {}
local STAtmosphereMT = { __index = STAtmosphere }

function STAtmosphere.New(position, radius)
	local self = {}
	setmetatable(self, STAtmosphereMT)
	
	self.properties = {}
	
	self:SetPos(position)
	self:SetRadius(radius)

	self:Set("oxygen", 0)
	self:Set("gravity", 0)
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

function STAtmosphere:SetPos(pos)
	self:Set("position", pos)
end

function STAtmosphere:GetPos()
	return self:Get("position")
end

function STAtmosphere:SetRadius(radius)
	self:Set("radius", radius)
	self:Set("radius_sq", radius*radius)
	self:Set("radius_cub", radius*radius*radius)
	self:Set("volume", (4/3)*math.pi*self:Get("radius_cub"))
end

function STAtmosphere:GetRadius()
	return self:Get("radius")
end

function STAtmosphere:GetVolume()
	return self:Get("volume")
end

function STAtmosphere:SetGravity(gravity)
	self:Set("gravity", gravity)
end

function STAtmosphere:GetGravity()
	return self:Get("gravity")
end

function STAtmosphere:GetConcentration(resource)
	return self:Get(resource)/self:Get("volume")
end

function STAtmosphere:IsInside(position)
	return (position - self:Get("position")):Length() <= self:Get("radius")
end

function STAtmosphere:Remove()
	table.RemoveByValue(SThing.atmospheres, self)
end

function SThing.AddNewAtmosphere(position, radius)
	local atmo = STAtmosphere.New(position, radius)
	table.insert(SThing.atmospheres, atmo)
	return atmo
end

-- Return the entity's closest atmosphere
function SThing.GetEntityAtmosphere(ent)
	local closest = nil
	local shortestDist = 1000000000000
	for _,atmo in ipairs(SThing.atmospheres) do
		local distance = atmo:Get("position"):DistToSqr(ent:GetPos())
		if distance < atmo:Get("radius_sq") and distance < shortestDist then
			closest = atmo
			shortestDist = distance
		end
	end

	return closest
end

SThing.atmospheres = {}
