TOOL.Category = "SpaceThing"
TOOL.Name = "Spawn Tool"
TOOL.Command = nil
TOOL.ConfigName = ""

AddCSLuaFile()

if CLIENT then
	language.Add("Tool.sm_link_tool.name", "Spawn  tool")
	language.Add("Tool.sm_link_tool.desc", "Use it to spawn life support devices.")
	language.Add("Tool.sm_link_tool.0", "Click to spawn the device.")
	
	function TOOL.BuildCPanel(CPanel)
		Cpanel:AddControl("Header", { Text = "Spawn tool", Description = "Left click to spawn a life support device" })
	end
end

function TOOL:LeftClick(tr)
end

function TOOL:RightClick(tr)

end

function TOOL:Think()

end

function TOOL:Reload(tr)

end

function TOOL:FreezeMovement()

end

function TOOL:Holster()

end
