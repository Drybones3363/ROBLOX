local plr = game.Players.LocalPlayer
plrfound = false
wait(.5)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat,true)
script.Parent.TeleportGui.Frame.Visible = true
for i=1,50 do wait(.5) if #game.Players:GetPlayers() > 1 then plrfound = true break end end
print(plrfound)
if plrfound == nil or plrfound == false then
	--forfeit/nobody showed up
else
	local start = Instance.new("BoolValue")
	start.Name = "Start"
	start.Parent = script.Parent.StartScript
	workspace:WaitForChild("Ready")
	for i,k in pairs (script.Parent.TeleportGui.MatchDetails:children()) do
		if k.ClassName == "Frame" or k.ClassName == "ImageLabel" or k.ClassName == "TextLabel" then
			k.Visible = false
		end
	end
	for i=0,1,0.01 do
		wait()
		script.Parent.TeleportGui.MatchDetails.BackgroundTransparency = i
	end
	script.Parent.TeleportGui.MatchDetails.Visible = false
	script.Parent.TeleportGui.Countdown.Visible = true
	script.Parent.TeleportGui.Background.Visible = true
	workspace.StartCountdown.Disabled = false
end
