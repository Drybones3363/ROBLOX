workspace:WaitForChild("Remotes")
workspace.Remotes:WaitForChild("ServerToClient")

workspace.Remotes.ServerToClient:WaitForChild("ViewMap").OnClientEvent:connect(function(center,length)
	local cam = workspace.CurrentCamera
	local oldcam = cam.CameraType
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CameraSubject = nil
	for i=1,360 do
		cam.CoordinateFrame = CFrame.new(center+Vector3.new(length/1.337*math.sin(math.rad(i)),10,length/1.337*math.cos(math.rad(i)))) * CFrame.Angles(0,math.rad(i),-math.pi/1.5)
		wait()
	end
	wait(.337)
	cam.CameraType = oldcam
	cam.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
end)

workspace.Remotes.ServerToClient:WaitForChild("Announce").OnClientEvent:connect(function(msg,t)
	local function show(k) --k = player
		if k:findFirstChild("PlayerGui") then
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
	show(game.Players.LocalPlayer)
end)

workspace.Remotes.ServerToClient:WaitForChild("RemoveAnnouncements").OnClientEvent:connect(function()
	for _,k in pairs (script.Parent:children()) do
		if k.Name == "Announcement" then
			k:Destroy()
		end
	end
end)

workspace.Remotes.ServerToClient:WaitForChild("ReceiveAnnounce").OnClientEvent:connect(function(ty,color,t)
	if game.Players.LocalPlayer:findFirstChild("PlayerGui") == nil then return end
	if ty ~= "Murderer" and ty ~= "Sheriff" then return end
	local startstr = "Receiving Knife in x Second" and type == "Murderer" or "Receiving Knife in x Second"
	local sgui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
	sgui.Name = "ReceiveAnnouncement"
	local txt = Instance.new("TextLabel")
	txt.BackgroundTransparency = 1
	txt.Name = "Message"
	txt.Position = UDim2.new(.15,0,0,0)
	txt.Size = UDim2.new(.7,0,.1,0)
	txt.Font = Enum.Font.ArialBold
	txt.FontSize = Enum.FontSize.Size18
	txt.TextColor3 = color
	txt.TextTransparency = 0
	txt.TextStrokeTransparency = 0
	txt.Text = ""
	txt.Parent = sgui
	for i=t,1,-1 do
		local extra = i == 1 and "" or "s"
		txt.Text = (startstr..extra):gsub("x",tostring(i))
		wait(1)
	end
	sgui:Destroy()
end)

workspace.Remotes.ServerToClient:WaitForChild("BlackScreen").OnClientEvent:connect(function()
	local sg = Instance.new("ScreenGui",script.Parent)
	sg.Name = "BlackScreen"
	local bs = Instance.new("Frame",sg)
	bs.Size = UDim2.new(1,0,1,0)
	bs.BackgroundColor3 = Color3.new(0,0,0)
end)

workspace.Remotes.ServerToClient:WaitForChild("RemoveBlackScreen").OnClientEvent:connect(function()
	for _,k in pairs (script.Parent:children()) do
		if k.Name == "BlackScreen" then
			k:Destroy()
		end
	end
end)
