wait(.5)
local tgui = script.Parent.TeleportGui
local plr = script.Parent.Parent

game:GetService("TeleportService").CustomizedTeleportUI = true

script.ChildAdded:connect(function(c)
	if c.ClassName == "IntValue" and c.Value > 0 then
		local id = c.Value
		tgui.Frame.Visible = true
		wait(.1)
		script.Parent.MatchGui.Finding.FindID.Reset.Disabled = false
		wait(.5)
		game:GetService("TeleportService"):Teleport(id,plr)
	end
end)
