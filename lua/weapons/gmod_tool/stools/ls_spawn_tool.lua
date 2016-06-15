TOOL.Category = "SpaceThing"
TOOL.Name = "Spawn Tool"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.ClientConVar["selected"] = "models/error.mdl"

AddCSLuaFile()

local generators = { ls_generator_solar = "Solar panel",  }
local storages = { ls_battery = "Battery" }

if CLIENT then
	language.Add("Tool.ls_spawn_tool.name", "Spawn  tool")
	language.Add("Tool.ls_spawn_tool.desc", "Use it to spawn life support devices.")
	language.Add("Tool.ls_spawn_tool.0", "Click to spawn the device.")
	
	function TOOL.BuildCPanel(CPanel)
		SUPERPANEL = CPanel
		
		CPanel:AddControl("Header", { Text = "Spawn tool", Description = "Left click to spawn a life support device" })
		
		local dtree = vgui.Create("DTree", SUPERPANEL)
		CPanel:AddPanel(dtree)
		dtree.OnNodeSelected = function(self, node)
			if node.path then
				LocalPlayer():ConCommand("ls_spawn_tool_selected " .. node.path)
			end
		end

		local sx, sy = CPanel:GetSize()
		local xmargin = 15
		
		dtree:SetPos(xmargin, 60)
		dtree:SetSize(sx - 2*xmargin, 240)
		
		-- Append generators
		local gen = dtree:AddNode("Generators")
		for k,v in pairs(generators) do
			local node = gen:AddNode(v)
			node.Icon:SetImage("materials/icon16/cog.png")
			node.path = k
		end
		
		-- Append storages
		local stor = dtree:AddNode("Storages")
		for k,v in pairs(storages) do
			local node = stor:AddNode(v)
			node.Icon:SetImage("materials/icon16/database.png")
			node.path = k
		end
	end
end

function TOOL:LeftClick(trace)
	if trace.Entity && trace.Entity:IsPlayer() then return false end
	
	if CLIENT then return true end

	local selected = self:GetClientInfo("selected")
	if not selected then return end
		
	local entity = ents.Create(selected)
	entity:Spawn()
	entity:Activate()
	entity:SetPos(trace.HitPos - Vector(0, 0, entity:OBBMins().z))
	
	local ply = self:GetOwner()

	undo.Create("Life Support")
		undo.AddEntity(entity)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCleanup("Life Support", entity)

	return true
end

function TOOL:RightClick(trace)

end

function TOOL:Think()

end

function TOOL:Reload(trace)

end

function TOOL:FreezeMovement()

end

function TOOL:Holster()

end
