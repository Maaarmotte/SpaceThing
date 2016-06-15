TOOL.Category = "SpaceThing"
TOOL.Name = "Link tool"
TOOL.Command = nil
TOOL.ConfigName = ""

AddCSLuaFile()

if ( CLIENT ) then

	language.Add( "Tool.ls_link_tool.name", "Link  tool" )
	language.Add( "Tool.ls_link_tool.desc", "Use it to link machines together." )
	language.Add( "Tool.ls_link_tool.0", "Click on the device you want to link" )
	language.Add( "Tool.ls_link_tool.1", "Click on another device" )


	function TOOL.BuildCPanel(panel)
 
		panel:AddControl("Header", { Text = "Link tool", Description = "Left click on a device, then left click on another device." })
	 
	end


end


function TOOL:LeftClick( tr )

	if tr.Hit and isLSEntity(tr.Entity) then
	
		if self:GetStage() == 0 then
			
			self.selectedMachine = tr.Entity
			self:SetStage(1)

		elseif self:GetStage() == 1 then
			
			local a = self.selectedMachine
			local b = tr.Entity

			if SERVER and IsValid(a) and IsValid(b) and isLSEntity(a) and isLSEntity(b) then
				
				local g1 = a:getGroup()
				local g2 = b:getGroup()

				-- Si les deux n'ont pas de groupe il faut en créer un...
				if g1 == 0 and g2 == 0 then

					a:createGroup()
					b:setGroup( a:getGroup() )

				-- Si l'un des deux à un groupe, c'est plus simple d'assigner celui sans groupe au groupe 
				-- que de déplacer tous les autres vers un nouveau groupe
				elseif g1 == 0 then

					a:setGroup(g2)

				elseif g2 == 0 then

					b:setGroup(g1)

				-- Sinon on déplace tous les entités du groupe 1 vers le groupe 2
				else

					for k,v in pairs(ST_Groups[g1]) do

						Entity(k):setGroup( g2 )

					end
					
				end

			end

			self:SetStage(0)

		end
		return true

	end

end


function TOOL:RightClick( tr )

end

	 
