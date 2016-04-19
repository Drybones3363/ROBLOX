local function show(k,msg,t) --k = player
	if k:findFirstChild("PlayerGui") and t > 1 then
		local sgui = Instance.new("ScreenGui",script.Parent)
		sgui.Name = "Announcement"
		local txt = Instance.new("TextLabel")
		txt.BackgroundTransparency = 1
		txt.Name = "Message"
		txt.Position = UDim2.new(.15,0,0,0)
		txt.Size = UDim2.new(.7,0,.1,0)
		txt.Font = Enum.Font.Legacy
		txt.FontSize = Enum.FontSize.Size24
		txt.TextColor3 = Color3.new(1,0,0)
		txt.TextTransparency = 1
		txt.Text = msg
		txt.Parent = sgui
		if t > 3 then
			for i=1,0,-.025 do
				txt.TextTransparency = i
				txt.TextStrokeTransparency = i
				t = t - wait()
			end
		end
		txt.TextTransparency = 0
		txt.TextStrokeTransparency = 0
		wait(t-1.337)
		for i=0,1,.025 do
			txt.TextTransparency = i
			txt.TextStrokeTransparency = i
			wait()
		end
		sgui:Destroy()
	end
end

wait(.337)
show(game.Players.LocalPlayer,workspace.Announce.Msg.Value,workspace.Announce.Time.Value)
