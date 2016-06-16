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

-- In GMod unit
function STAtmosphere:SetRadius(radius)
	self:Set("radius", radius)
	self:Set("radius_sq", radius*radius)
	self:Set("radius_cub", radius*radius*radius)
	self:Set("radius_m", radius*0.01905)
	self:Set("radius_m_sq", self:Get("radius_m")*self:Get("radius_m"))
	self:Set("radius_m_cub", self:Get("radius_m")*self:Get("radius_m")*self:Get("radius_m"))
	self:Set("volume", (4/3)*math.pi*self:Get("radius_cub"))
	self:Set("volume_m_cub", (4/3)*math.pi*self:Get("radius_m_cub"))
end

-- In GMod unit
function STAtmosphere:GetRadius()
	return self:Get("radius")
end

-- In m^3
function STAtmosphere:GetVolume()
	return self:Get("volume_m_cub")
end

function STAtmosphere:SetGravity(gravity)
	self:Set("gravity", gravity)
end

function STAtmosphere:GetGravity()
	return self:Get("gravity")
end

function STAtmosphere:GetConcentration(resource)
	return self:Get(resource)/self:GetVolume()
end

function STAtmosphere:IsInside(position)
	return (position - self:GetPos()):Length() <= self:GetRadius()
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
	local smallest = 10^10
	for _,atmo in ipairs(SThing.atmospheres) do
		local distance = atmo:GetPos():DistToSqr(ent:GetPos())
		if distance < atmo:Get("radius_sq") and atmo:Get("radius") < smallest then
			closest = atmo
			smallest = atmo:Get("radius")
		end
	end

	return closest
end

function SThing.GetEntityAtmospheres(ent)
	local atmospheres = {}
	for _,atmo in ipairs(SThing.atmospheres) do
		local distance = atmo:GetPos():DistToSqr(ent:GetPos())
		if distance < atmo:Get("radius_sq") then
			table.insert(atmospheres, atmo)
		end
	end

	return atmospheres
end

SThing.atmospheres = {}
