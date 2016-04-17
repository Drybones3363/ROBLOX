local plr = game.Players.LocalPlayer
local char = plr.Character

local remotes = workspace.Remotes
local funct = remotes:WaitForChild("Function")
local event = remotes:WaitForChild("Event")

local CP = game:GetService("ContentProvider")

local Day = workspace.Remotes.Function:InvokeServer("Get Day")

local function Update_Day(n)
	Day = n
end

local Products = {
	["250"] = 30139546,
	["1000"] = 30139570,
	["2500"] = 30139586,
	["10000"] = 30139622
}


pcall(function()
	wait(2)
	game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	game.Workspace.CurrentCamera.CameraType = "Custom"
end)

coroutine.resume(coroutine.create(function()
	local mouse = game.Players.LocalPlayer:GetMouse()
	mouse.Button1Down:connect(function()
		local target = mouse.Target
		if target.Parent.Name:sub(1,13) == "CapitolSymbol" and target.Parent:FindFirstChild("Torso") then
			workspace.Remotes.Event:FireServer("Capitol Symbol Change",tonumber(target.Parent.Name:sub(14)))
		end
	end)
end))

local Health_Fades = {
	[0] = "rbxassetid://267718107"
	--[[[10] = "rbxassetid://267720623",
	[20] = "rbxassetid://267721007",
	[30] = "rbxassetid://267721304",
	[40] = "rbxassetid://267721452",
	[50] = "rbxassetid://267721640",
	[60] = "rbxassetid://267721849",
	[70] = "rbxassetid://267721992",
	[80] = "rbxassetid://267722140",
	[90] = "rbxassetid://267722270",
	[100] = "rbxassetid://267722453",]]
}

local District_Images = {
	[1] = "rbxassetid://83212859",
	[2] = "rbxassetid://83212865",
	[3] = "rbxassetid://83212867",
	[4] = "rbxassetid://83212872",
	[5] = "rbxassetid://83212876",
	[6] = "rbxassetid://83212878",
	[7] = "rbxassetid://83212883",
	[8] = "rbxassetid://83212892",
	[9] = "rbxassetid://83212894",
	[10] = "rbxassetid://83212897",
	[11] = "rbxassetid://83212901",
	[12] = "rbxassetid://83212909",
	[13] = "rbxassetid://154281509",
	["C"] = "rbxassetid://83212915",
}

local Weapon_Images = {
	Winner = "rbxassetid://216177480",
	Mace = "rbxassetid://278209586",
	Machete = "rbxassetid://285223891",
	Axe = "rbxassetid://285223472",
	Trident = "rbxassetid://285223268",
	Sword = "rbxassetid://285223293",
	Knife = "rbxassetid://285223512",
	Bow = "rbxassetid://278209630"
}

local Bars = {
	Red = "rbxassetid://264634920",
	Orange = "rbxassetid://264639364",
	Yellow = "rbxassetid://264639316",
	Cyan = "rbxassetid://264639407",
	Blue = "rbxassetid://264639448"
}

for i,k in pairs (Health_Fades) do
	CP:Preload(k)
end

for i,k in pairs (District_Images) do
	CP:Preload(k)
end

for i,k in pairs (Bars) do
	CP:Preload(k)
end

local On_Menu = false

function Click_Spectate_Button(plr)
	if game.Workspace:FindFirstChild(plr) then
		game.Workspace.CurrentCamera.CameraType = "Scriptable"
		On_Menu = false
		workspace.CurrentCamera:Interpolate(CFrame.new(workspace[plr].Torso.Position),CFrame.new(workspace[plr].Torso.Position),3)
		wait(3)
		workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
		workspace.CurrentCamera.CameraSubject = workspace[plr].Humanoid
		script.Parent.SpectateGui.Stop.Visible = true
		script.Parent.SpectateGui.Selection.Visible = false
	end
end

function End_Spectate()
	workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
	workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	On_Menu = true
end

function returnNextXP(level,prestige)
	if level + 1 < 24 then
		return math.ceil(math.floor((((((level*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
	else
		return math.ceil(math.floor((((((0*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
	end
end

function returnFromXP(num)
	local level = 1
	local prestige = 0
	local xpForLevel = 0
	repeat
		num = num - xpForLevel
		xpForLevel = math.floor(((prestige+.1)*.337)*7*(level)^1.9+50)
		--math.ceil(math.floor((((((level*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
		level = level + 1
		if level == 24 then
			level = 1
			prestige = prestige + 1
		end
		if prestige == 10 then break end
	until xpForLevel > num
	if num < 0 then num = 0 end
	return prestige,level,num,xpForLevel
end

local function Enable_Lobby_Menu()
	On_Menu = true
	local model = workspace:WaitForChild("Lobby")
	local camera = game.Workspace.CurrentCamera
	repeat wait() until model:FindFirstChild("Center")
	local viewing = false
	local gui = script.Parent:FindFirstChild("LobbyGui")
	
	local num = 1
	camera.CameraType = "Scriptable"
	camera.Focus = model.Center.CFrame
	
	local cams = {}
	local camPoints = {}
	local arenaCams = {}
	
	math.randomseed(tick() + 1)
	coroutine.resume(coroutine.create(function()
		workspace:WaitForChild("Arena")
		wait(1)
		for a,b in pairs(workspace.Arena:GetChildren()) do 
			if b.Name == "ArenaCam" then
				table.insert(arenaCams,b)
			end
		end
	end))
	
	for a,b in pairs(model:GetChildren()) do
		if b.Name == "TVCamera" then
			table.insert(cams,b)
		end
		if b.Name == "CameraRot" then
			table.insert(camPoints,b)
		end
	end
	
	local lastCam = nil
	coroutine.resume(coroutine.create(function()
		local num = 0
		local selectedNum = math.random(5,12)
		local function camMovement(pos,delay)
			num = num + 1
			--[[if num == selectedNum then
				num = 0
				wait()
				selectedNum = math.random(2,4)
				local selected = cams[math.random(#cams)]
				camera:Interpolate(selected.Cam.CFrame,model.Center.CFrame,5)
				wait(5)
				camera:Interpolate(selected.Cam.CFrame,selected.Root.CFrame,1)
				wait(1)
				camera:Interpolate(selected.Root.CFrame,selected.Root.CFrame,1)
				wait(0.5)
				for i = 1,50 do
					wait()
					gui.Overlay.BackgroundTransparency = gui.Overlay.BackgroundTransparency - 0.025
				end
				if #arenaCams > 0 then
					local camGui = game.Lighting.CamGui:Clone()
					camGui.Parent = script.Parent
					local camPos = arenaCams[math.random(#arenaCams)]
					camera.CoordinateFrame = camPos.CamCenter.CFrame
					camera.Focus = camPos.CamRight.CFrame
					camera:Interpolate(camPos.CamCenter.CFrame,camPos.CamRight.CFrame,1)
					gui.Overlay.BackgroundTransparency = 1
					for i = 1,50 do
						wait()
						camGui.Overlay.BackgroundTransparency = camGui.Overlay.BackgroundTransparency + 0.025
					end
					wait(2)
					local ranNum = math.random(4,6)
					camera:Interpolate(camPos.CamCenter.CFrame,camPos.CamLeft.CFrame,ranNum)
					wait(ranNum)
					wait(math.random(2,4))
					local ranNum2 = math.random(4,6)
					camera:Interpolate(camPos.CamCenter.CFrame,camPos.CamRight.CFrame,ranNum2)
					for i = 1,50 do
						wait()
						camGui.Overlay.BackgroundTransparency = camGui.Overlay.BackgroundTransparency - 0.025
					end
					wait(ranNum - 1)
					gui.Overlay.BackgroundTransparency = 0
					camGui.Overlay.BackgroundTransparency = 1
					camGui:Destroy()
				end
				camera.CoordinateFrame = selected.Cam.CFrame
				camera.Focus = selected.Root.CFrame
				camera:Interpolate(selected.Cam.CFrame,selected.Root.CFrame,1)
				wait(1)
				for i = 1,50 do
					wait()
					gui.Overlay.BackgroundTransparency = gui.Overlay.BackgroundTransparency + 0.025
				end
				camera:Interpolate(selected.Cam.CFrame,model.Center.CFrame,1)
				wait(1)
			else]]
				camera:Interpolate(pos,model.Center.CFrame,delay)
				wait(delay)
			--end
		end
		repeat
			while wait() and On_Menu do
				local selectedCam = camPoints[math.random(1,#camPoints)]
				if selectedCam ~= lastCam then
					local waitTime = math.random(5,10)
					camMovement(selectedCam.CFrame,waitTime)
					lastCam = selectedCam
				else
					repeat selectedCam = camPoints[math.random(1,#camPoints)] until selectedCam ~= lastCam
					local waitTime = math.random(5,10)
					camMovement(selectedCam.CFrame,waitTime)
					lastCam = selectedCam
				end
			end
			for i=1,3 do wait(.7) end
		until not script:IsDescendantOf(game)
	end))
	
	local songs = {
		{236506714,90},
		{180550530,87},
		{180550430,72},
		{180570610,80},
	}
	
	local current = nil
	local lastSong = nil
	local playing = false
	
	function music(song,len)
		playing = true
		local sound = Instance.new("Sound",script.Parent)
		sound.SoundId = "rbxassetid://"..song
		sound.Volume = 0
		sound:Play()
		current = sound
		lastSong = song
		for i = 1,25 do
			sound.Volume = sound.Volume + 0.025
			wait()
		end
		wait(len-3)
		for i = 1,25 do
			sound.Volume = sound.Volume - 0.025
			wait()
		end
		sound:Stop()
		sound:Destroy()
		playing = false
	end
	
	coroutine.resume(coroutine.create(function()
		while wait(0.1) and On_Menu do
			if playing == false then
				local num = math.random(1,#songs)
				local song = songs[num][1]
				local len = songs[num][2]
				if song == lastSong then
					repeat 
						local newnum = math.random(1,#songs)
						song = songs[newnum][1]
						len = songs[newnum][2]
					until song ~= lastSong
					music(song,len)
				else
					music(song,len)
				end
			end
		end
	end))
end

--tbl = {Title,Options,Length}
--Optiontbl = {{Title,pic,desc},{Title,pic,desc},{Title,pic,desc}}

local function Broadcast(tbl)
	if tbl == nil then print("No table") return end
	print("Table found")
	local t = tbl.Length
	local title = tbl.Title
	local options = tbl.Options
	if t == nil then t = 30 end
	if title == nil then title = "" end
	local board = game.Lighting.Broadcast:Clone()
	board.Parent = workspace
	board.CFrame = CFrame.new(Vector3.new(1, 705.4, 0))
	coroutine.resume(coroutine.create(function()
		for i=1,t*2+5 do wait(.5) end
		board:Destroy()
	end))
	board.SurfaceGui.lblCommand.Text = title
	board.SurfaceGui.lblCommand.Visible = true
	if options then
		for i=1,#options do
			pcall(function()
				local frame = board.SurfaceGui["Option"..tostring(i)]
				local opt = options[i]
				frame.Title.Text = opt.Title
				frame.Desc.Text = opt.Desc
				frame.Pic.Image = opt.Pic
				frame.Button.MouseButton1Click:connect(function()
					for i,k in pairs (frame.Parent:GetChildren()) do
						if k.Name:sub(1,6) == "Option" then
							pcall(function()
								k.Button.BackgroundTransparency = 1
							end)
						end
					end
					frame.Button.BackgroundTransparency = .75
				end)
				frame.Visible = true
			end)
		end
	elseif tbl.Pic then
		local frame = board.SurfaceGui.Frame
		frame.Pic.Image = tbl.Pic
		frame.Visible = true
	end
	coroutine.resume(coroutine.create(function()
		local t = 0
		repeat
			board.CFrame = board.CFrame*CFrame.Angles(0,t*30*math.rad(.666),0)
			t = wait()
		until board == nil or board.Parent == nil
	end))
	wait(t)
	if options then 
		local function Find_Vote()
			for i,k in pairs (board.SurfaceGui:GetChildren()) do
				if k.Name:sub(1,6) == "Option" then
					if k.Button.BackgroundTransparency < 1 then
						return tonumber(k.Name:sub(7))
					end
				end
			end
		end
		workspace.Remotes.Event:FireServer("Include Vote",Find_Vote())
	end
	board:Destroy()
end

local function Announce(str)
	local lbl = script.Parent.ScreenGui.Menu.Announcement
	for i=0,1,(1/30) do
		lbl.TextTransparency = i
		lbl.TextStrokeTransparency = i
		wait()
	end
	lbl.TextTransparency = 1
	lbl.TextStrokeTransparency = 1
	lbl.Text = str
	for i=1,0,(-1/30) do
		lbl.TextTransparency = i
		lbl.TextStrokeTransparency = i
		wait()
	end
	lbl.TextTransparency = 0
	lbl.TextStrokeTransparency = 0
end

local function Note(str)
	local frame = script.Parent.ScreenGui.Menu.Note
	local lbl = frame.NoteText
	for i=0,1,(1/30) do
		lbl.TextTransparency = i
		lbl.TextStrokeTransparency = i
		wait()
	end
	lbl.TextTransparency = 1
	lbl.TextStrokeTransparency = 1
	lbl.Text = str
	if str == "" then
		frame.BackgroundTransparency = 1
	end
	for i=1,0,(-1/30) do
		lbl.TextTransparency = i
		lbl.TextStrokeTransparency = i
		wait()
	end
	lbl.TextTransparency = 0
	lbl.TextStrokeTransparency = 0
end

local classtbl = {}

local function Update_Classtbl()
	classtbl = workspace.Remotes.Function:InvokeServer("Get Class Data")
end

local function Show_Tributes(names,chars,pics,districtnum)
	Update_Classtbl()
	game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	game.Workspace.CurrentCamera.CameraType = "Custom"
	local frame = script.Parent.ScreenGui.Menu.District
	frame.Parent.BackgroundTransparency = 0
	local function Show_Tribute(gender,name,char,pic)
		local f = frame[gender]
		f.CharPic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(char)--workspace.Remotes.Function:InvokeServer("Find Character Pic",char)
		f.UserPic.Image = pic or ""
		f.UserPrestige.Image = "" --get prestige
		f.Charname.Text = classtbl[tostring(char)] and classtbl[tostring(char)].Name or "Loading..."
		f.Username.Text = name
		f.Username.TextTransparency = 0
		f.UserPic.ImageTransparency = 0
		f.UserPrestige.ImageTransparency = 0
		f.Label.TextTransparency = 0
		f.Label.TextStrokeTransparency = 0
		for i=1,0,(-1/50) do
			f.Charname.TextTransparency = i
			f.CharPic.ImageTransparency = i
			wait()
		end
		f.Charname.TextTransparency = 0
		f.CharPic.ImageTransparency = 0
		wait()
	end
	local function invisibilize(frame)
		if frame.ClassName == "ImageLabel" then
			frame.ImageTransparency = 1
		end
		if frame.ClassName == "TextLabel" then
			frame.TextTransparency = 1
		end
		if #frame:GetChildren() > 0 then
			for i,k in pairs (frame:GetChildren()) do
				invisibilize(k)
			end
		end
	end
	invisibilize(frame)
	frame.Visible = true
	frame.Emblem.Image = District_Images[districtnum]
	for i=1,0,(-1/75) do
		frame.Emblem.ImageTransparency = i
		wait()
	end
	frame.Emblem.ImageTransparency = 0
	Show_Tribute("Male",names[1],chars[1],pics[1])
	if names[2] and chars[2] and pics[2] then
		Show_Tribute("Female",names[2],chars[2],pics[2])
	end
	local t = 0
	repeat
		t = t + wait()
	until t >= 1
	invisibilize(frame)
end

local function Reaping(tribtbl)
	for i,k in pairs (tribtbl) do
		local trib1,trib2 = k[1],k[2]
		Show_Tributes({trib1[1][1],trib2[1] and trib2[1][1]},{trib1[1][2],trib2[1] and trib2[1][2]},{trib1[1][3],trib2[1] and trib2[1][3]},i)
	end
end

local valtbl = {Hunger = {"http://www.roblox.com/asset/?id=264639364",false},Thirst = {"http://www.roblox.com/asset/?id=264639407",false},Energy = {"http://www.roblox.com/asset/?id=264639316",false}} --{old_pic,running}
local warn = coroutine.create(function(bar,kind)
	repeat
		while valtbl[kind][2] == true and wait(.8) do
			for i=0,1,(1/50) do
				bar.ImageTransparency = i
				wait()
			end
			bar.ImageTransparency = 1
			for i=1,0,(-1/50) do
				bar.ImageTransparency = i
				wait()
			end
			bar.ImageTransparency = 0
		end
		wait(.5)
	until nil
end)

local function Check(bar,kind)
	if bar.Size.X.Scale < .175 and valtbl[kind][2] == false then
		coroutine.resume(warn,bar,kind)
		valtbl[kind][2] = true
		bar.Image = "http://www.roblox.com/asset/?id=264634920"
		bar:ClearAllChildren()
	elseif bar.Size.X.Scale >= .175 and valtbl[kind][2] == true then
		coroutine.yield(warn,bar,kind)
		valtbl[kind][2] = false
		bar.Image = valtbl[kind][1]
		bar.ImageTransparency = 0
	end
end

local function Change_Value(kind,value,maxvalue)
	local bar = script.Parent.ScreenGui.SurvivalBars[kind].bar
	bar.Size = UDim2.new(.96*(value/maxvalue),0,.8,0)
	Check(bar,kind)
end

local function In_Tube()
	local function announceText(text,label,speed)
		label.Text = text
	end
	local function announce(text)
		coroutine.resume(coroutine.create(function()
			local ann = Instance.new("TextLabel")
			ann.BackgroundColor3 = Color3.new(0,0,0)
			ann.BackgroundTransparency = .5
			ann.BorderSizePixel = 0
			ann.Name = "TubeAnnouncment"
			ann.Position = UDim2.new(0,0,.1,0)
			ann.Size = UDim2.new(0,0,.05,0)
			ann.TextColor3 = Color3.new(1,1,1)
			ann.TextScaled = true
			ann.TextStrokeColor3 = Color3.new(.39,0,0)
			ann.TextStrokeTransparency = 0
			ann.TextWrapped = true
			ann.Text = ""
			ann.Parent = script.Parent.ScreenGui
			ann:TweenSize(UDim2.new(1,0,0.05,0),"Out","Linear",0.25)
			announceText(text,ann,0.05)
			wait(2)
			ann:TweenPosition(UDim2.new(0,0,-0.5,0),"Out","Linear",1)
			for i=1,6 do
				wait(.5)
			end
			ann:Destroy()
		end))
	end
	local function playDing()
		local soundT = Instance.new("Sound",script.Parent)
		soundT.SoundId = "rbxassetid://138222365"
		soundT:Play()
		soundT:Destroy()
	end
	announce("You have 30 seconds to be in your tube...")
	playDing()
	wait(12)
	announce("You have 15 seconds to be in your tube...")
	playDing()
	wait(7)
	announce("You have 5 seconds to be in your tube...")
	playDing()
	--wait(3)
	--playDing()
	--announce("If you are not in your tube, you will be killed by the Gamemakers actions...")
end

local data = {
	{5,Color3.new(1,1,0)},
	{4,Color3.new(1,0.75,0)},
	{3,Color3.new(1,0.5,0)},
	{2,Color3.new(1,0.25,0)},
	{1,Color3.new(1,0,0)},
}

function returnColors(label,r,g,b,endR,endG,endB)
	for time = 0, 1, 0.5 do
		coroutine.resume(coroutine.create(function()
			wait()
			local r = ((r - (r - endR) * time))
			local g = ((g - (g - endG) * time))
			local b = ((b - (b - endB) * time))
			   
			label.TextColor3 = Color3.new(r/255,g/255,b/255)
			label.TextStrokeColor3 = Color3.new((r-155)/255,(g-155)/255,(b-155)/255)
		end))
	end
end

function announce(label,text)
	local delay = 1
	local pre = label:Clone()
	pre.Parent = script.Parent
	pre.TextColor3 = Color3.new(1,1,0)
	pre.TextStrokeColor3 = Color3.new((1*255-155)/255,(1*255-155)/255,0)
	pre.TextTransparency = 0.5
	pre.TextStrokeTransparency = 0.5
	pre.BackgroundTransparency = 1
	pre:TweenPosition(label.Position + UDim2.new(0,0,-0.25,0),"Out","Linear",delay)
	label.Text = text
	coroutine.resume(coroutine.create(function()
		for i = 1,25 do
			pre.TextTransparency = pre.TextTransparency + 0.025
			pre.TextStrokeTransparency = pre.TextStrokeTransparency + 0.025
			wait()
		end
		pre:Destroy()
	end))
end

local function Format_Number(n)
	if n > 10 and n < 20 then
		return tostring(n).."th"
	end
	if n % 10 == 1 then
		return tostring(n).."st"
	elseif n % 10 == 2 then
		return tostring(n).."nd"
	elseif n % 10 == 3 then
		return tostring(n).."rd"
	end
	return tostring(n).."th"
end

local function Play_Audio(id,volume,pitch)
	local audio = script.Parent.Audio
	audio.SoundId = type(id) == "number" and "rbxassetid://"..tostring(id) or id
	audio.Volume = volume
	audio.Pitch = pitch
	audio:Play()
end

function Countdown()
	--[[script.Parent.ScreenGui.Timer:TweenSize(UDim2.new(1,0,0.05,0),"Out","Linear",0.25)
	local countdownTime = 30
	local function playTick()
		local soundT = Instance.new("Sound",script.Parent)
		soundT.SoundId = "rbxassetid://141252315"
		soundT:Play()
		soundT:Destroy()
	end
	local function makeTimer(t)
		for i = 1,t+1 do
			wait(1)
			playTick()
			announce(script.Parent.ScreenGui.Timer,tostring(t-i+1))
			for i2 = 1,#data do
				if data[i2][1] == t-i+1 then
					local r = script.Parent.ScreenGui.Timer.TextColor3.r*255
					local g = script.Parent.ScreenGui.Timer.TextColor3.g*255
					local b = script.Parent.ScreenGui.Timer.TextColor3.b*255
					returnColors(script.Parent.ScreenGui.Timer,r,g,b,data[i2][2].r*255,data[i2][2].g*255,data[i2][2].b*255)
				end
				if t-i+1 == 0 then
					local soundT = Instance.new("Sound",script.Parent)
					soundT.SoundId = "rbxassetid://154281509"
					soundT:Play()
					soundT:Destroy()
					coroutine.resume(coroutine.create(function()
						for i = 1,50 do
							script.Parent.ScreenGui.Timer.BackgroundTransparency = script.Parent.ScreenGui.Timer.BackgroundTransparency + 0.01
							wait()
						end
					end))
					for i = 1,100 do
						script.Parent.ScreenGui.Timer.TextTransparency = script.Parent.ScreenGui.Timer.TextTransparency + 0.01
						script.Parent.ScreenGui.Timer.TextStrokeTransparency = script.Parent.ScreenGui.Timer.TextStrokeTransparency + 0.01
						wait()
					end
					break
				end
			end
		end
	end]]
	
	announce(script.Parent.ScreenGui.Timer,"Welcome to the games...")
	wait(2)
	announce(script.Parent.ScreenGui.Timer,"We thank you for your sacrifice...")
	wait(2)
	announce(script.Parent.ScreenGui.Timer,"and may the odds be in your favor...")
	--makeTimer(countdownTime)
end

local function Fade_Audio_Out(audio,destroy)
	coroutine.resume(coroutine.create(function()
		for i=audio.Volume,0,-(audio.Volume*.05) do
			audio.Volume = i
			wait()
		end
		if destroy then
			audio:Destroy()
		end
	end))
end

local function Play_Looped_Audio(id,volume,pitch)
	local audio = Instance.new("Sound",script.Parent)
	audio.Name = "Looped_Audio"
	audio.SoundId = type(id) == "number" and "rbxassetid://"..tostring(id) or id
	audio.Volume = volume or .5
	audio.Pitch = pitch or 1
	audio:Play()
	return audio
end

local function Overview(tbl,plrtbl)
	local frame = script.Parent.ScreenGui.Overview.Frame
	local Time = 0
	local audio = Play_Looped_Audio(278178103,.5,1)
	frame.Parent.Visible = true
	for p=#tbl,1,-1 do
		local i = #tbl-(p-1)
		local t = tbl[i]
		local clone = frame.Example:Clone()
		clone.Name = "Place"..tostring(i)
		clone.Example.Weapon.Image = Weapon_Images[t[3]] or ""
		clone.Example.UserPic.Image = t[1] and "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..t[1] or ""
		clone.Example.Username.Text = t[1] or ""
		clone.Example.Place.Text = Format_Number(p)
		clone.Example.Killer.Text = (t[2] == nil and "From Nature") or (t[2] ~= "Nobody" and "From "..t[2]) or "Survived"
		clone.Stats.Username.Text = t[1]
		pcall(function()
			clone.Stats.Alive.Text = "Time Alive: "..tostring(plrtbl[t[1]].Time)
			clone.Stats.Character.Text = "Character: "..tostring(plrtbl[t[1]].Character)
			clone.Stats.Distance.Text = "Distance: "..tostring(math.ceil(100*plrtbl[t[1]].Distance)*.01).." km."
			clone.Stats.Kills.Text = "Kills: "..tostring(plrtbl[t[1]].Kills)
			clone.Stats.XP.Text = "XP Gained: "..tostring(plrtbl[t[1]].XP)			
		end)
		clone.Position = UDim2.new((1/6)*((p-1)%6),0,.25*math.floor((p-1)/6),0)
		clone.Visible = true
		clone.Parent = frame
		clone.Example.Place.TextTransparency = 0
		clone.Example.Place.TextStrokeTransparency = 0
		clone.Example.Username.TextTransparency = 0
		clone.Example.Username.TextStrokeTransparency = 0
		clone.Example.UserPic.ImageTransparency = 0
		clone.Example.Weapon.ImageTransparency = 0
		clone.Example.Killer.TextTransparency = 0
		clone.Example.Killer.TextStrokeTransparency = 0
		local shown = "Default"
		clone.Button.MouseButton1Click:connect(function()
			shown = shown == "Default" and "Stats" or "Default"
			if shown == "Stats" then
				clone.Example:TweenPosition(UDim2.new(-1,0,0,0),"Out","Linear",1.337)
				clone.Stats:TweenPosition(UDim2.new(0,0,0,0),"Out","Linear",1.337)
			else
				clone.Stats:TweenPosition(UDim2.new(1,0,0,0),"Out","Linear",1.337)
				clone.Example:TweenPosition(UDim2.new(0,0,0,0),"Out","Linear",1.337)
			end
		end)
		Time = Time + wait(1)
	end
	wait(90)
	Fade_Audio_Out(audio,true)
	frame.Parent.Visible = false
	for i,k in pairs (frame:GetChildren()) do
		if k.Name:sub(1,5) == "Place" then
			k:Destroy()
		end
	end
end

local function Awarded_XP(xp,msg)
	pcall(function()
	Play_Audio(291551145,.9,.95)
	local frame = script.Reward:Clone()
	frame.Pic.ImageTransparency = 1
	frame.Reason.TextStrokeTransparency = 1
	frame.Reason.TextTransparency = 1
	frame.XP.TextStrokeTransparency = 1
	frame.XP.TextTransparency = 1
	frame.XP.Text = "+ "..tostring(xp).." XP"
	frame.Reason.Text = msg
	frame.Visible = true
	frame.Parent = script.Parent.XPGui
	local t,done = 0,false
	coroutine.resume(coroutine.create(function()
		while done == false do
			if t > 7 then
				frame:Destroy()
				done = true
			end
			t = t + wait()
		end
	end))
	for i=1,0,-(1/30) do
		frame.Pic.ImageTransparency = i
		frame.Reason.TextStrokeTransparency = i
		frame.Reason.TextTransparency = i
		frame.XP.TextStrokeTransparency = i
		frame.XP.TextTransparency = i
		wait()
	end end)
end


local Chat = { 
	ChatColors = {
		BrickColor.new("Bright red"),
		BrickColor.new("Bright blue"),
		BrickColor.new("Earth green"),
		BrickColor.new("Bright violet"),
		BrickColor.new("Bright orange"),
		BrickColor.new("Bright yellow"),
		BrickColor.new("Light reddish violet"),
		BrickColor.new("Brick yellow"),
	};

	Gui = nil,
	Frame = nil,
	RenderFrame = nil,
	TapToChatLabel = nil,
	ClickToChatButton = nil,
	Templates = nil,
	EventListener = nil,
	MessageQueue = {},
	
	Configuration = {								
		FontSize = Enum.FontSize.Size12,	
		NumFontSize = 12,
		HistoryLength = 20,
		Size = UDim2.new(0.38, 0, 0.20, 0),
		MessageColor = Color3.new(1, 1, 1),
		AdminMessageColor = Color3.new(1, 215/255, 0),
		XScale = 0.025,
		LifeTime = 45,
		Position = UDim2.new(0, 2, 0.05, 0),
		DefaultTweenSpeed = 0.15,							
	};
	
	CachedSpaceStrings_List = {},
	Messages_List = {},
	MessageThread = nil,
	TempSpaceLabel = nil,
}

function Chat:ComputeChatColor(pName)
	return self.ChatColors[GetNameValue(pName) + 1].Color
end 

function GetNameValue(pName)
	local value = 0
	for index = 1, #pName do 
		local cValue = string.byte(string.sub(pName, index, index))
		local reverseIndex = #pName - index + 1
		if #pName%2 == 1 then 
			reverseIndex = reverseIndex - 1			
		end
		if reverseIndex%4 >= 2 then 
			cValue = -cValue 			
		end 
		value = value + cValue 
	end 
	return value%8
end

local prestigeIds = {}

local function Chat_Event(n,player,msg,district)
	if n == 1 then
		coroutine.resume(coroutine.create(function()
			for c,d in pairs(script.Parent.ChatGui.ChatHolder:GetChildren()) do
				local num = (tonumber(d.Value.Value)-0.05)
				d.Value.Value = num
				d.Position = UDim2.new(0,0,num,0)
				if num == -0.1 then
					d:Destroy()
				end
			end
		end))
	elseif n == 2 then
		for i,k in pairs (script.Parent.ChatGui.ChatHolder:children()) do
			if k.Position.Y.Scale <= .025 then
				k:Destroy()
			elseif k.Position.Y.Scale > .025 then
				k.Position = k.Position - UDim2.new(0,0,.025,0)
			end
		end
		local chat = script.ChatFrame:Clone()
		chat.Parent = script.Parent.ChatGui.ChatHolder
		if player.Name ~= "Game" and player.Name ~= "Gamemakers" and player.Name ~= "Capitol" then
			local color1 = Color3.new(math.floor(Chat:ComputeChatColor(player.Name).r*255)/255,math.floor(Chat:ComputeChatColor(player.Name).g*255)/255,math.floor(Chat:ComputeChatColor(player.Name).b*255)/255)
			local color2 = Color3.new((math.floor(color1.r*255)-100)/255,(math.floor(color1.g*255)-100)/255,(math.floor(color1.b*255)-100)/255)
			if not district then
				if player.Name == "ObscureEntity" or player.Name == "FutureWebsiteOwner" then
					chat.Player.TextColor3 = color1
					chat.Player.TextStrokeColor3 = color2
					chat.Player.Text = "[THG:R Dev]"..player.Name..":"
				else
					chat.Player.TextColor3 = color1
					chat.Player.TextStrokeColor3 = color2
					chat.Player.Text = player.Name..":"
				end
			else
				if player.Name == "ObscureEntity" or player.Name == "FutureWebsiteOwner" then
					chat.Player.TextColor3 = Color3.new(1,0,0)
					chat.Player.TextStrokeColor3 = Color3.new(100/255,0,0)
					chat.Player.Text = "[District "..tostring(district).."][THG:R Dev]["..player.Name.."]:"
				else
					chat.Player.TextColor3 = Color3.new(1,0,0)
					chat.Player.TextStrokeColor3 = Color3.new(100/255,0,0)
					chat.Player.Text = "[District "..tostring(district).."]["..player.Name.."]:"
				end
			end
		end
		chat.Message.Text = msg
		local id = nil
		for i = 1,#prestigeIds do
			if prestigeIds[i][1] == player.Name then
				id = prestigeIds[i][2]
				break
			end
		end
		chat.Prestige.Image = "rbxassetid://"..(id or "")
	end
end

game.Workspace.ReturnLevels:FireServer()

game.Workspace.ReturnLevels.OnClientEvent:connect(function(tab)
	prestigeIds = tab
end)

game.Players.PlayerAdded:connect(function(plr)
	game.Workspace.ReturnLevels:FireServer()
end)

game.Players.PlayerRemoving:connect(function(plr)
	game.Workspace.ReturnLevels:FireServer()
end)

function Get_Tributes(typ)
	return workspace.Remotes.Function:InvokeServer("Get Tributes",typ)
end

function Changed_XP(XP)
	local prestige,level,xp,nextxp = returnFromXP(XP)
	if prestige ~= 10 then
		script.Parent.XPGui.Background.CurrentXP.Text = tostring(xp).." XP"
		script.Parent.XPGui.Background.NeededXP.Text = tostring(nextxp).." XP"
		script.Parent.XPGui.Background.Bar.Size = UDim2.new(xp/nextxp,0,1,0)
	else
		script.Parent.XPGui.Background.Bar.BackgroundColor3 = Color3.new(1,50/255,50/255)
		script.Parent.XPGui.Background.CurrentXP.Text = tostring(xp).." XP"
		script.Parent.XPGui.Background.Bar.Size = UDim2.new(1,0,1,0)
		script.Parent.XPGui.Background.NeededXP.Text = "Max Prestige"
	end
end

--[[local function Activate_Book(book)
	local cd = book:WaitForChild("ClickDetector")
	cd.MouseClick:connect(function()
		local plr = game.Players.LocalPlayer
		if not plr.PlayerGui:FindFirstChild("StatsGui") then
			local char = _G.Games_Player_Data[plr.Name].Character
			local tbl = _G.Character_Data[plr.Name]
			if tbl then
				local cl = script.Parent.StatsGui:Clone()
				local det = cl:WaitForChild("Details")
				for i,k in pairs (tbl) do
					if det:FindFirstChild(i) and det[i]:FindFirstChild("bar") then
						pcall(function()
							local x = k*.01
							det[i].bar.Size = UDim2.new(x,0,1,0)
							if x <= .225 then
								det[i].bar.Image = Bars.Blue
							elseif x <= .45 then
								det[i].bar.Image = Bars.Cyan
							elseif x <= .675 then
								det[i].bar.Image = Bars.Yellow
							elseif x <= .9 then
								det[i].bar.Image = Bars.Orange
							else
								det[i].bar.Image = Bars.Red
							end
						end)
					elseif i == "Gender" then
						det.lblGender.Text = "Gender: "..(k == 1 and "Male" or "Female")
					elseif i == "PicID" then
						det.Pic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(k)
					end
				end
				det.lblName.Text = char
				cl:WaitForChild("Exit").MouseButton1Click:connect(function()
					cl:Destroy()
				end)
				cl.Parent = plr.PlayerGui
				wait(30)
				cl:Destroy()
			end
		end
	end)
end]]

local function Find_Player_Pic(plr)
	if plr == nil then return "" end
	if plr:sub(1,6) == "Guest " then
		return "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=ROBLOX"
	end
	return "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..plr
end

coroutine.resume(coroutine.create(function()
	local plr = game.Players.LocalPlayer
	local mouse = plr:GetMouse()
	mouse.KeyDown:connect(function(key)
		local function get_dist()
			local char = plr.Character
			if char:FindFirstChild("Torso") and workspace:FindFirstChild("TubeRoom") and workspace.TubeRoom:FindFirstChild("StatsBook") then
				return (char.Torso.Position-workspace.TubeRoom.StatsBook.Position).magnitude
			end
			return 50
		end
		if key == "q" and get_dist() < 15 and plr.PlayerGui:FindFirstChild("StatsGui") == nil then
			local gui = game.Lighting.StatsGui:Clone()
			gui.Parent = script.Parent
			local data = workspace.Remotes.Function:InvokeServer("Get Book Data")
			for i,k in pairs (data) do print(i,k) end 
			local index = 1
			local frame = gui:WaitForChild("Frame")
			local function change_Page()
				--Update_Classtbl()
				local t = data[index] or {}
				local chartbl = t.CharacterData or {}
				frame.First.UserPic.Image = Find_Player_Pic(t.Name)
				frame.First.Username.Text = t.Name or ""
				frame.First.Charname.Text = classtbl[tostring(chartbl.Class)] and classtbl[tostring(chartbl.Class)].Name or ""
				frame.First.CharPic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(chartbl.Class)
				frame.First.District.Text = "District "..tostring(math.ceil(index/2))
				frame.First.Gender.Text = index%2 == 0 and "Female" or "Male"
				local det = frame.Second
				for i,k in pairs (det:GetChildren()) do
					if k:FindFirstChild("bar") and chartbl[k.Name] then
						pcall(function()
							local x = chartbl[k.Name]*.01
							k.bar.Size = UDim2.new(x,0,1,0)
							if x <= .225 then
								k.bar.Image = Bars.Blue
							elseif x <= .45 then
								k.bar.Image = Bars.Cyan
							elseif x <= .675 then
								k.bar.Image = Bars.Yellow
							elseif x <= .9 then
								k.bar.Image = Bars.Orange
							else
								k.bar.Image = Bars.Red
							end
						end)
					end
				end
			end
			frame.Left.MouseButton1Click:connect(function()
				index = index - 1
				if index <= 0 then
					index = #data
				end
				change_Page()
			end)
			frame.Right.MouseButton1Click:connect(function()
				index = index + 1
				if index > #data then
					index = 1
				end
				change_Page()
			end)
			frame.X.MouseButton1Click:connect(function()
				gui:Destroy()
			end)
			change_Page()
		end
	end)
end))

local map_done,room = false

local function Create_Tube(cf)
	room = game.Lighting.TubeRoom:Clone()
	room:SetPrimaryPartCFrame(cf)
	room.Parent = workspace
end

local function Wait(n)
	local t = 0
	repeat
		t = t + wait()
	until t >= n
	return t
end

local function Close_Tube()
	local k = room or workspace:FindFirstChild("TubeRoom")
	if not k then return end
	local function movePart(part,pos,speed)
		coroutine.resume(coroutine.create(function()
			for i = 0, 1, speed do
				wait()
				local X = (part.Position.X - ((part.Position.X - pos.X) * i))
				local Y = (part.Position.Y - ((part.Position.Y - pos.Y) * i))
				local Z = (part.Position.Z - ((part.Position.Z - pos.Z) * i))
				local x,y,z = part.CFrame:toEulerAnglesXYZ()
				part.CFrame = CFrame.new(X, Y, Z) * CFrame.Angles(x,y,z)
			end
		end))
	end
	local deb = true
	k.GuiTrigger.Touched:connect(function(part)
		local gui = k.GuiTrigger.ScreenGui
		if part.Parent and deb then
			if part.Parent:FindFirstChild("Humanoid") then
				local player = game.Players:GetPlayerFromCharacter(part.Parent)
				if player then
					deb = false
					local blind = gui:Clone()
					blind.Parent = player.PlayerGui
					local blindscrn = blind.BlindingFrame
					Play_Audio("rbxassetid://154168898",.5,1)
					--[[
					local t = 0
					repeat
						t = t + wait()
						blindscrn.Transparency = blindscrn.Transparency - 30*t*0.05
					until t > .666
					--]]
					blindscrn.Transparency = 0
					workspace.Remotes.Event:FireServer("Move Char",plr.Tribute.Value)
					Wait(3)
					for i = 1, 50 do
						wait()
						blindscrn.Transparency = blindscrn.Transparency + 0.05
					end
					wait(.337)
					workspace.Remotes.Event:FireServer("Change Speed","Walk")
				end
			end
		end
	end)
	--coroutine.resume(coroutine.create(function()
		pcall(function() movePart(k.Door1,k.Door1.Position + Vector3.new(0,18.25,0),0.002)
		movePart(k.Door2,k.Door2.Position + Vector3.new(0,18.25,0),0.002)
		Wait(2)
		movePart(k.Pad,k.Pad.Position + Vector3.new(0,36,0),0.0001)
		Wait(10)
		movePart(k.Pad,k.Pad.Position + Vector3.new(0,36,0),0.0001)
		Wait(3) end)
	--end))
	Wait(10)
	k:Destroy()
	room = nil
end

local function Changed_SP(sp)
	script.Parent.SponserGui.Selection.SP.Text = "Capitol Cash: "..tostring(sp).." "
end

local spon_not_vis = false

local hallucinating = 0

local function Hallucinate()
	hallucinating = hallucinating + 1
	if hallucinating > 1 then return end
	local start = 70
	local n = start
	local neg = 1
	while wait() and hallucinating > 0 do
		n = n + neg*math.random(2) if n > start+40 then neg = -1 elseif n < start-40 then neg = 1 end
		workspace.CurrentCamera.FieldOfView = n
	end
end

local function Make_Hidden_Place()
	local done = false
	On_Menu = false
	for i,k in pairs (workspace:GetChildren()) do
		if k.Name == "Hidden Place 1" then
			k:Destroy()
		end
	end
	for i,k in pairs (script.Parent:GetChildren()) do
		if k.ClassName == "Sound" then
			k.Volume = 0
			k:Destroy()
		end
	end
	for i=1,2 do --for tunnel effect
		local sound = Instance.new("Sound",script.Parent)
		sound.SoundId = "rbxassetid://228355634"
		sound.Volume = .5
		sound.Looped = true
		sound.Pitch = 1
		sound:Play()
		if i == 2 then
			coroutine.resume(coroutine.create(function()
				sound.Pitch = .75
				wait()
				sound.Pitch = 1
			end))
		end
	end
	local place = game.Lighting["Hidden Place 1"]:Clone()
	place.Parent = workspace
	local function Blow_Up_1()
		if done == true then return end
		done = true
		--coroutine.resume(coroutine.create(function()
		local start = place.Cannon.Position
		for i=0,4,.1 do
			place.Cannon.CFrame = CFrame.new(start+Vector3.new(0,0,i))*CFrame.fromEulerAnglesXYZ(-math.rad(90),math.rad(90),math.rad(90))
			wait()
		end
		coroutine.resume(coroutine.create(function()
			wait(.9)
			local died = false
			game.Players.LocalPlayer.Character.Humanoid.Died:connect(function()
				died = true
			end)
			repeat
				game.Players.LocalPlayer.Character.Humanoid:TakeDamage(7)
				wait(.4)
			until died
			for i=1,10 do wait(.5) end place:Destroy()
		end))
		for i=1,200 do
			local ray = Ray.new(place.Cannon.Position+Vector3.new(0,0,place.Cannon.Size.Z*.5),200*Vector3.new(math.random(-1000,1000)*.01,math.random(-1000,1000)*.001,math.random(100,1000)*.01))
			local part,position = workspace:FindPartOnRay(ray)
			local beam = Instance.new("Part", workspace)
			beam.BrickColor = BrickColor.new("Bright red")
			beam.FormFactor = "Custom"
			beam.Material = "Neon"
			beam.Transparency = 0.25
			beam.Anchored = true
			beam.Locked = true
			beam.CanCollide = false
			local distance = (place.Cannon.Position - position).magnitude
			beam.Size = Vector3.new(0.3, 0.3, distance)
			beam.CFrame = CFrame.new(place.Cannon.Position, position) * CFrame.new(0, 0, -distance / 2)
			if part then
				Instance.new("Fire",part).Size = 30
				part.BrickColor = BrickColor.Black()
				if part.Parent and part.Parent:FindFirstChild("Humanoid") then
					part.Parent.Humanoid.Health = 0
				end
			end
			wait()
			coroutine.resume(coroutine.create(function()
				wait(.1)
				beam:Destroy()
			end))
		end
		--end))
	end
	local function Show_Egg()
		if done == true then return end
		done = true
		for i,k in pairs (place:GetChildren()) do
			for e,r in pairs (k:GetChildren()) do
				if r.ClassName == "SurfaceGui" then
					r:Destroy()
				end
			end
		end
		local egg = game.Lighting.Jegg:Clone()
		egg.Parent = place
		egg.BodyPosition.Position = egg.BodyPosition.Position - Vector3.new(0,110,0)
		wait(10)
		local rot = .25
		coroutine.resume(coroutine.create(function()
			while wait() and egg and egg.Parent do
				egg.CFrame = egg.CFrame*CFrame.fromEulerAnglesXYZ(0,rot,0)
				if rot <= .05 then rot = .05 else rot = rot - .0005 end
			end
		end))
		local ex = Instance.new("Explosion")
		ex.ExplosionType = Enum.ExplosionType.NoCraters
		ex.BlastPressure = 0
		ex.BlastRadius = 0
		ex.Position = egg.Position
		ex.Parent = egg
		egg.Anchored = false
		local audio = egg.Audio:Clone()
		audio.Parent = game.Players.LocalPlayer.PlayerGui
		audio:Play()
		egg.Touched:connect(function(h)
			if h.Parent and game.Players:GetPlayerFromCharacter(h.Parent) then
				local p = game.Players:GetPlayerFromCharacter(h.Parent)
				egg:Destroy()
				workspace.Remotes.Event:FireServer("Give Easter Egg","Mockingjay")
				for i=1,10 do wait(.5) end
				if h.Parent == p.Character then
					p:LoadCharacter()
				end
				place:Destroy()
			end
		end)
	end
	local on_j = false
	local mouse = game.Players.LocalPlayer:GetMouse()
	mouse.KeyDown:connect(function(k)
		if k == "j" then
			on_j = true
		end
	end)
	mouse.KeyUp:connect(function(k)
		if k == "j" then
			on_j = false
		end
	end)
	mouse.Button1Down:connect(function()
		if place then
			local target = mouse.Target
			if target == place:FindFirstChild"Button" then
				if on_j then
					Show_Egg()
				else
					Blow_Up_1()
				end
			end
		end
	end)
	coroutine.resume(coroutine.create(function()
		local there = false
		repeat
			wait()
			pcall(function()
				if (game.Players.LocalPlayer.Character.Torso.Position-place.Adam.Torso.Position).magnitude <= 25 then
					there = true
				end
			end)
		until there
		local gui = place.ChatGui:Clone()
		gui.Parent = game.Players.LocalPlayer.PlayerGui
		gui.TextLabel["Chat (Local)"].Disabled = false
	end))
end

event.OnClientEvent:connect(function(typ,...)
	if typ == 1 then
		Announce(...)
	elseif typ == "Reaping" then
		Reaping(...)
	elseif typ == 3 then
		Change_Value(...)
	elseif typ == "In Tube" then
		In_Tube()
	elseif typ == "Countdown" then
		Countdown()
	elseif typ == "Play Audio" then
		Play_Audio(...)
	elseif typ == "Show Overview" then
		Overview(...)
	elseif typ:sub(1,9) == "ChatEvent" then
		Chat_Event(tonumber(typ:sub(10)),...)
	elseif typ == "Changed XP" then
		Changed_XP(...)
	elseif typ == "Changed SP" then
		Changed_SP(...)
	elseif typ == "Activate Stats Book" then
		--Activate_Book(...)
	elseif typ == "Awarded XP" then
		Awarded_XP(...)
	elseif typ == "Create Tube" then
		Create_Tube(...)
	elseif typ == "Map Done" then
		map_done = true
	elseif typ == "Close Tube" then
		Close_Tube()
	elseif typ == "Broadcast" then
		Broadcast(...)
	elseif typ == "Day Changed" then
		Update_Day(...)
		if spon_not_vis == true then
			if Day > 0 then
				script.Parent.SponserGui.Button.Visible = true
			end
		end
	elseif typ == "Hallucinate" then
		Hallucinate()
	elseif typ == "End Hallucination" then
		hallucinating = hallucinating - 1
		workspace.CurrentCamera.FieldOfView = 70
	elseif typ == "Make Hidden Place" then
		Make_Hidden_Place()
	end
end)

coroutine.resume(coroutine.create(function()
	workspace:WaitForChild("Announcement").Changed:connect(function(val)
		if type(val) == "string" then
			Announce(val)
		end
	end)
	Announce(workspace.Announcement.Value)
	workspace:WaitForChild("Note").Changed:connect(function(val)
		if type(val) == "string" then
			Note(val)
		end
	end)
	Note(workspace.Note.Value)
end))

local function Activate(thing)
	local running,old_pic = false
	local warn = coroutine.create(function(bar)
		repeat
			while running == true and wait(.8) do
				for i=0,1,(1/50) do
					bar.ImageTransparency = i
					wait()
				end
				bar.ImageTransparency = 1
				for i=1,0,(-1/50) do
					bar.ImageTransparency = i
					wait()
				end
				bar.ImageTransparency = 0
			end
			wait(.5)
		until nil
	end)
	local health_fade = script.Parent.ScreenGui.HealthFade
	health_fade.Image = Health_Fades[0]
	local function Check(bar)
		coroutine.resume(coroutine.create(function()
			local size = bar.Size.X.Scale
			health_fade.ImageTransparency = size > .85 and 1 or size
			--[[if bar.Size.X.Scale > .3 then --bar.Size.X.Scale > .75 then
				health_fade.Visible = false
			else
				--local val = 10*math.ceil(bar.Size.X.Scale*(4/3)*10)
				local val = 10*math.ceil(bar.Size.X.Scale*10)
				health_fade.Image = Health_Fades[val]
				health_fade.Visible = true
			end]]
		end))
		if bar.Size.X.Scale < .175 and running == false then
			coroutine.resume(warn,bar)
			running = true
			bar.Image = "http://www.roblox.com/asset/?id=264634920"
			bar:ClearAllChildren()
		elseif bar.Size.X.Scale >= .175 and running == true then
			coroutine.yield(warn)
			running = false
			bar.Image = old_pic
			bar.ImageTransparency = 0
		end
	end
	if thing == "Health" then
		local f = script.Parent.ScreenGui.SurvivalBars:WaitForChild(thing)
		local hum = char:WaitForChild("Humanoid")
		old_pic = f.bar.Image
		hum.HealthChanged:connect(function(health)
			f.bar.Size = UDim2.new(.96*(health/hum.MaxHealth),0,.8,0)
			Check(f.bar)
		end)
		f.bar.Size = UDim2.new(.96*(hum.Health/hum.MaxHealth),0,.8,0)
		Check(f.bar)
	end
end

coroutine.resume(coroutine.create(function()
	wait(.337)
	local data
	repeat
		data = workspace.Remotes.Function:InvokeServer("Get Data")
	until data
	Changed_XP(data.XP)
end))

coroutine.resume(coroutine.create(function()
	for i,k in pairs ({{"Health",{35229304}},{"Hunger",{95415121,264682882,175824224}},{"Thirst",{70182781,70182781,90612983}},{"Energy",{264777148,264777087,264777009}}}) do
		local f = script.Parent.ScreenGui.SurvivalBars:FindFirstChild(k[1])
		if f and f:FindFirstChild("bar") then
			local function create_Particle()
				local p = Instance.new("ImageLabel")
				p.BackgroundTransparency = 1
				p.Image = "http://www.roblox.com/asset/?id="..tostring(k[2][math.random(#k[2])])
				p.Position = UDim2.new(math.random(-10,90)*0.01,0,1,0)
				p.Size = UDim2.new(0,12,0,12)
				p.ZIndex = 3
				p.Parent = f.bar
				local x_vel = math.random(-5,5)*.001
				local y_vel = math.random(5)*.02
				--local rot_vel = math.random(-5,5)*.2
				coroutine.resume(coroutine.create(function()
					repeat
						--p.Rotation = p.Rotation + rot_vel
						p.Position = p.Position - UDim2.new(x_vel,0,y_vel,0)
						wait()
					until p.Position.Y.Scale <= -1 or p.Position.X.Scale > 1 or p.Position.X.Scale <= -.25
					p:Destroy()
				end))
			end
			f.bar.ClipsDescendants = true
			coroutine.resume(coroutine.create(function()
				repeat
					while f and f:FindFirstChild("bar") and f.bar.Image ~= "http://www.roblox.com/asset/?id=264634920" and wait() do
						local chance = f.bar.Size.X.Scale == 0 and 999 or math.ceil(.96/f.bar.Size.X.Scale)
						if math.random(chance) == 1 then
							create_Particle()
						end
					end
					wait(.5)
				until nil
			end))
			coroutine.resume(coroutine.create(function()
				Activate(k[1])
			end))
		end
	end
end))

coroutine.resume(coroutine.create(function()
	repeat wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
	game.Workspace.Leaderboard:FireServer(game.Players.LocalPlayer)
end))

--spectating
coroutine.resume(coroutine.create(function()
	script.Parent.SpectateGui.Button.MouseButton1Click:connect(function()
		local sel = script.Parent.SpectateGui.Selection
		for a,b in pairs(sel:GetChildren()) do
			if b.Name ~= "Example" and b.Name ~= "X" then
				print(b.Name.." Destroyed")
				b:Destroy()
			end
		end
		local tribs = Get_Tributes("Alive")
		for i,k in pairs (tribs) do
			local lbl = sel.Example:Clone()
			pcall(function()
				lbl.Parent = script.Parent.SpectateGui.Selection
			end)
			lbl.Name = "Trib"..tostring(i)
			lbl.Position = UDim2.new((1/6)*((i-1)%6),0,.25*math.ceil((i-6)/6),0)
			lbl.Text = k
			lbl.Visible = true
			lbl.MouseButton1Click:connect(function()
				Click_Spectate_Button(k)
			end)
		end
		sel.Visible = true
		script.Parent.SpectateGui.Button.Visible = false
	end)
	script.Parent.SpectateGui.Button.MouseButton1Down:connect(function()
		script.Parent.SpectateGui.Button.Image = "rbxassetid://331205162"
	end)
	script.Parent.SpectateGui.Button.MouseButton1Up:connect(function()
		script.Parent.SpectateGui.Button.Image = "rbxassetid://331205162"
	end)
	script.Parent.SpectateGui.Button.MouseEnter:connect(function()
		--script.Parent.SpectateGui.Button.BackgroundTransparency = .75
	end)
	script.Parent.SpectateGui.Button.MouseLeave:connect(function()
		--script.Parent.SpectateGui.Button.BackgroundTransparency = 1
		script.Parent.SpectateGui.Button.Image = "rbxassetid://331205162"
	end)
	script.Parent.SpectateGui.Stop.MouseButton1Click:connect(function()
		End_Spectate()
		script.Parent.SpectateGui.Stop.Visible = false
		wait(1)
		script.Parent.SpectateGui.Button.Visible = true
	end)
	script.Parent.SpectateGui:WaitForChild("Selection"):WaitForChild("X").MouseButton1Click:connect(function()
		script.Parent.SpectateGui.Selection.Visible = false
		script.Parent.SpectateGui.Button.Visible = true
	end)
end))

local Lowest_Cost = {
	Spear = 175,
	Axe = 150,
	Bow = 175,
	Kunai = 170,
	Knife = 50,
	Mace = 185,
	Machete = 155,
	Sword = 95,
	Trident = 200,
	["Purple Berries"] = 55,
	["Yellow Berries"] = 60,
	["Red Berries"] = 75,
	["Black Berries"] = 120,
	["Cyan Berries"] = 45,
	["Green Apple"] = 75,
	["Red Apple"] = 65,
	["Black Apple"] = 115,
	["Cyan Apple"] = 40,
	Fish = 100
}

--sponsering
coroutine.resume(coroutine.create(function()
	local index,Item_Selected,data = 0,""
	local function create_item_button(item)
		local b = Instance.new("ImageButton")
		b.BackgroundColor3 = Color3.new(1,1,1)
		b.BackgroundTransparency = .5
		b.BorderSizePixel = 0
		b.Position = UDim2.new(.1425*((index-1)%7)+.01,0,.24*math.floor((index-1)/7)+.02,0)
		b.Size = UDim2.new(.125,0,.225,0)
		b.Image = data[item]
		b.ZIndex = 2
		b.Name = item
		b.Parent = script.Parent.SponserGui.Selection.Items
		b.MouseEnter:connect(function()
			b.BackgroundTransparency = .25
		end)
		b.MouseLeave:connect(function()
			b.BackgroundTransparency = .5
		end)
		b.MouseButton1Down:connect(function()
			b.BackgroundTransparency = .1
		end)
		b.MouseButton1Up:connect(function()
			b.BackgroundTransparency = .25
		end)
		b.MouseButton1Click:connect(function()
			Item_Selected = item
			script.Parent.SponserGui.Selection.Items.Visible = false
			local tribs = Get_Tributes("Alive")
			local bookdata = workspace.Remotes.Function:InvokeServer("Get Book Data")
			local function get_cost(name)
				for i=1,#bookdata do
					if bookdata[i].Name == name then
						return math.ceil(100/(.5*(bookdata[i].CharacterData.Reputation or 33)+5)*(Lowest_Cost[item] or 13337)*100/55*(.5*(Day-1)+.5))
					end
				end
			end
			local function make_trib(ind,name)
				local Cost = get_cost(name)
				local tb = Instance.new("ImageButton")
				tb.BackgroundColor3 = Color3.new(1,1,1)
				tb.BackgroundTransparency = .5
				tb.BorderSizePixel = 0
				tb.Position = UDim2.new(.1425*((ind-1)%7)+.01,0,.24*math.floor((ind-1)/7)+.02,0)
				tb.Size = UDim2.new(.125,0,.225,0)
				tb.Image = Find_Player_Pic(name)
				pcall(function()
					local playersName = Instance.new("TextLabel",tb)
					playersName.Size = UDim2.new(1,0,0.2,0)
					playersName.TextColor3 = Color3.new(1,1,1)
					playersName.BackgroundTransparency = 1
					playersName.TextStrokeTransparency = 0.5
					playersName.TextStrokeColor3 = Color3.new(0.4,0.4,0.4)
					playersName.ZIndex = 4
					playersName.Text = name
					playersName.TextWrapped = true
					playersName.TextScaled = true
				end)
				local cost = Instance.new("TextLabel",tb)
				cost.BackgroundTransparency = 1
				cost.Size = UDim2.new(1,0,1,0)
				cost.Font = Enum.Font.SourceSansBold
				cost.FontSize = Enum.FontSize.Size18
				cost.TextXAlignment = Enum.TextXAlignment.Right
				cost.TextYAlignment = Enum.TextYAlignment.Bottom
				cost.Text = tostring(Cost)
				tb.Name = item
				tb.ZIndex = 2
				cost.ZIndex = 3
				tb.Parent = script.Parent.SponserGui.Selection.Tribs
				tb.MouseEnter:connect(function()
					tb.BackgroundTransparency = .25
				end)
				tb.MouseLeave:connect(function()
					tb.BackgroundTransparency = .5
				end)
				tb.MouseButton1Down:connect(function()
					tb.BackgroundTransparency = .1
				end)
				tb.MouseButton1Up:connect(function()
					tb.BackgroundTransparency = .25
				end)
				tb.MouseButton1Click:connect(function()
					script.Parent.SponserGui.Selection.Visible = false
					script.Parent.SponserGui.Selection.Items.Visible = true
					script.Parent.SponserGui.Selection.Tribs.Visible = false
					script.Parent.SponserGui.Button.Visible = true
					workspace.Remotes.Event:FireServer("Sponsor Tribute",name,item,Cost)
				end)
			end
			script.Parent.SponserGui.Selection.Tribs:ClearAllChildren()
			for i=1,#tribs do
				make_trib(i,tribs[i])
			end
			script.Parent.SponserGui.Selection.Tribs.Visible = true
		end)
	end
	script.Parent.SponserGui.Button.MouseButton1Down:connect(function()
		script.Parent.SponserGui.Button.Image = "rbxassetid://331204830"
	end)
	script.Parent.SponserGui.Button.MouseButton1Up:connect(function()
		script.Parent.SponserGui.Button.Image = "rbxassetid://331204830"
	end)
	script.Parent.SponserGui.Button.MouseEnter:connect(function()
		--script.Parent.SponserGui.Button.BackgroundTransparency = .75
	end)
	script.Parent.SponserGui.Button.MouseLeave:connect(function()
		--script.Parent.SponserGui.Button.BackgroundTransparency = 1
		script.Parent.SponserGui.Button.Image = "rbxassetid://331204830"
	end)
	script.Parent.SponserGui.Button.MouseButton1Click:connect(function()
		script.Parent.SponserGui.Selection.Visible = true
		script.Parent.SponserGui.Button.Visible = false
	end)
	script.Parent.SponserGui.Selection.X.MouseButton1Click:connect(function()
		script.Parent.SponserGui.Button.Visible = true
		script.Parent.SponserGui.Selection.Visible = false
		script.Parent.SponserGui.Selection.Items.Visible = true
		script.Parent.SponserGui.Selection.Tribs.Visible = false
	end)
	script.Parent.SponserGui.Selection.BuyMore.MouseButton1Click:connect(function()
		script.Parent.SponserGui.Selection.Visible = false
		script.Parent.SponserGui.Buy.Visible = true
	end)
	script.Parent.SponserGui.Buy.cmdExit.MouseButton1Click:connect(function()
		script.Parent.SponserGui.Buy.Visible = false
		script.Parent.SponserGui.Selection.Visible = true
	end)
	local images = {
		s250 = "rbxassetid://324652635",
		s1000 = "rbxassetid://324652584",
		s2500 = "rbxassetid://324652526",
		s10000 = "rbxassetid://324652448",
		p250 = "rbxassetid://324652657",
		p1000 = "rbxassetid://324652600",
		p2500 = "rbxassetid://324652556",
		p10000 = "rbxassetid://324652487"
	}
	for i,k in pairs (script.Parent.SponserGui.Buy:GetChildren()) do
		if k.ClassName == "ImageButton" then
			k.MouseButton1Down:connect(function()
				k.Image = images["p"..k.Name]
			end)
			k.MouseLeave:connect(function()
				k.Image = images["s"..k.Name]
			end)
			k.MouseButton1Up:connect(function()
				k.Image = images["s"..k.Name]
			end)
			k.MouseButton1Click:connect(function()
				game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer,Products[k.Name],false,Enum.CurrencyType.Robux)
			end)
		end
	end
	data = workspace.Remotes.Function:InvokeServer("Get Item Data")
	for i,k in pairs (data) do
		index = index + 1
		create_item_button(i)
	end
	script.Parent.SponserGui.Selection.Items.Visible = true
end))

--sprinting
coroutine.resume(coroutine.create(function()
	local mouse = plr:GetMouse()
	mouse.KeyDown:connect(function(key)
		local speed = plr.Character.Humanoid.WalkSpeed
		if key:byte() == 48 and not On_Menu then
			workspace.Remotes.Event:FireServer("Change Speed","Sprint")
			for i = 1, 5 do
				game.Workspace.CurrentCamera.FieldOfView = (70 + (i * 2))
				wait()
			end
			wait(.337)
			if plr.Character.Humanoid.WalkSpeed <= speed then
				for i = 1, 5 do
					game.Workspace.CurrentCamera.FieldOfView = (80 - (i * 2))
					wait()
				end
			end
		end
	end)
	mouse.KeyUp:connect(function(key)
		if key:byte() == 48 and not On_Menu then
			workspace.Remotes.Event:FireServer("Change Speed","Walk")
			wait()
			coroutine.resume(coroutine.create(function()
				for i = 1, 5 do
					game.Workspace.CurrentCamera.FieldOfView = (80 - (i * 2))
					wait()
				end
			end))
		end
	end)
end))

coroutine.resume(coroutine.create(function()
	for i,k in pairs (workspace:GetChildren()) do
		if k.Name == "Broadcast" then
			k:Destroy()
		end
	end
end))

coroutine.resume(coroutine.create(function()
	local Developers = {
		"Terratronic";
		"ObscureEntity";
		"FutureWebsiteOwner";
	}
	
	local Player = game.Players.LocalPlayer
	local Frame = script.Parent:WaitForChild("Leaderboard"):WaitForChild("Frame")
	
	local PlayerLabel = script:WaitForChild("PlayerLabel"):Clone()
	script.PlayerLabel:Destroy()
	
	local Prestige_Images = { -- MAKE SURE THESE ARE SORTED BY PRESTIGE LEVEL!!!!
		268037497; -- 0
		280676072; -- 1
		268037548; -- 2
		268679715; -- 3
		268679734; -- 4
		268679807; -- 5
		280704093; -- 6
		268679841; -- 7
		268037612; -- 8
		268679883; -- 9
		268679976; -- 10
	}
	
	local function returnFromXP(num)
		local level = 1
		local prestige = 0
		local xpForLevel = 0
		repeat
			num = num - xpForLevel
			xpForLevel = math.floor(((prestige+.1)*.337)*7*(level)^1.9+50)
			level = level + 1
			if level == 24 then
				level = 1
				prestige = prestige + 1
			end
			if prestige == 10 then break end
		until xpForLevel > num
		if num < 0 then num = 0 end
		return prestige,level,num,xpForLevel
	end
	
	local function UpdateList()
		local NewFrame = Frame:Clone()
		NewFrame:ClearAllChildren()
		NewFrame.Visible = false
		NewFrame.Parent = script.Parent.Leaderboard
		local Data
		coroutine.resume(coroutine.create(function()
			Data = workspace.Remotes.Function:InvokeServer("Get All Data")
		end))
		for iter, player in pairs(game.Players:GetPlayers()) do
			pcall(function()
				local Label = PlayerLabel:Clone()
				Label.PlayerName.Text = player.Name
				Label.Position = UDim2.new(0,0,iter-1,0)
				Label.Friend.Visible = (Player:IsFriendsWith(player.userId))
				
				for _, dev in pairs(Developers) do
					if (player.Name == dev) then
						Label.PlayerName.TextColor3 = Color3.new(1, 55/255, 55/255)
						Label.PlayerName.Text = "Dev   "..Label.PlayerName.Text
					end
				end
				if (player.Name == Player.Name) then
					Label.PlayerName.TextColor3 = Color3.new(55/255, .8, 55/255)
				end
				
				Label.PlayerName.Shadow.Text = Label.PlayerName.Text
				Label.Parent = NewFrame
				coroutine.resume(coroutine.create(function()
					repeat wait() until Data or not(Label and Label.Parent)
					pcall(function()
						local PlayerPrestige,PlayerLevel = returnFromXP(Data[tostring(player.userId)].XP)
						Label.PlayerLevel.Text = PlayerLevel
						Label.Prestige.Image = "http://www.roblox.com/asset/?id="..tostring(Prestige_Images[PlayerPrestige+1])
					end)
				end))
			end)
		end
		
		NewFrame.Visible = true
		Frame:Destroy()
		Frame = NewFrame
	end
	
	game.Players.PlayerAdded:connect(function()
		UpdateList()
	end)
	game.Players.PlayerRemoving:connect(function()
		UpdateList()
	end)
	while wait() do
		UpdateList() -- In case of level changes, friend status changes
		wait(60)
	end
end))

script.Parent.ScreenGui.MenuPlace.MouseButton1Click:connect(function()
	game:GetService("TeleportService"):Teleport(265496283,game.Players.LocalPlayer)
end)

script.Parent.ScreenGui.Menu.BackgroundTransparency = 0
wait(1.337)
script.Parent.ScreenGui.Menu.BackgroundTransparency = 1
workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
coroutine.resume(coroutine.create(function()
	workspace.CurrentCamera.CameraSubject = plr.Character:WaitForChild("Humanoid")
end))
script.Parent:WaitForChild("CharDestroyed")
if Day ~= 0 then
	script.Parent.SponserGui.Button.Visible = true
else
	spon_not_vis = true
end
script.Parent.SpectateGui.Button.Visible = true
--Enable_Lobby_Menu()	
	local songs = {
		{236506714,90},
		{180550530,87},
		{180550430,72},
		{180570610,80},
	}
	
	local current = nil
	local lastSong = nil
	local playing = false
	
	function music(song,len)
		playing = true
		local sound = Instance.new("Sound",script.Parent)
		sound.SoundId = "rbxassetid://"..tostring(song)
		sound.Volume = 0
		sound:Play()
		current = sound
		lastSong = song
		for i = 1,25 do
			sound.Volume = On_Menu and sound.Volume + 0.025 or 0
			wait()
		end
		wait(len-3)
		for i = 1,25 do
			sound.Volume = On_Menu and sound.Volume - 0.025 or 0
			wait()
		end
		sound:Stop()
		sound:Destroy()
		playing = false
	end
	On_Menu = true
coroutine.resume(coroutine.create(function()
		while wait(0.1) and On_Menu do
			if playing == false then
				local num = math.random(1,#songs)
				local song = songs[num][1]
				local len = songs[num][2]
				if song == lastSong then
					repeat 
						local newnum = math.random(1,#songs)
						song = songs[newnum][1]
						len = songs[newnum][2]
					until song ~= lastSong
					music(song,len)
				else
					music(song,len)
				end
			end
		end
end))
