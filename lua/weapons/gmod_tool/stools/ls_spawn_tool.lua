TOOL.Category = "SpaceThing"
TOOL.Name = "Spawn Tool"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.ClientConVar["selected"] = "prop_physics"

AddCSLuaFile()

local generators = { ls_generator_solar = "Solar panel", ls_generator_petrol = "Engine-generator" }
local storages = { ls_battery = "Battery", ls_jerrican = "Fuel jerrican" }
local climreg = { ls_generator_atmosphere = "Atmosphere generator" }

if CLIENT then
	language.Add("Tool.ls_spawn_tool.name", "Spawn  tool")
	language.Add("Tool.ls_spawn_tool.desc", "Use it to spawn life support devices.")
	language.Add("Tool.ls_spawn_tool.0", "Click to spawn the device.")

	local function BuildSubNode(tree, name, arr, icon)
		local sub = tree:AddNode(name)
		sub:SetExpanded(true)

		for k,v in pairs(arr) do
			local node = sub:AddNode(v)
			node.Icon:SetImage(icon)
			node.path = k
		end
	end
	
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
		BuildSubNode(dtree, "Generators", generators, "materials/icon16/cog.png")
		
		-- Append storages
		BuildSubNode(dtree, "Storages", storages, "materials/icon16/database.png")

		-- Append atmospheres devices
		BuildSubNode(dtree, "Atmosphere", climreg, "materials/icon16/world.png")
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
	entity:SetPos(trace.HitPos - trace.HitNormal*entity:OBBMins().z)
	entity:SetAngles(trace.HitNormal:Angle() + Angle(90,0,0))
	
	local ply = self:GetOwner()

	undo.Create("Life Support")
		undo.AddEntity(entity)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone " .. (generators[selected] or storages[selected] or climreg[selected]))
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
