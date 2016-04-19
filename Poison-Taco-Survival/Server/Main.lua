local ds = game:GetService("DataStoreService"):GetDataStore("Data")

local data = {}

local Survivors = {}

local Sizzle_Sounds = {261639534,100429993}

local Acid_Color = BrickColor.new("Br. yellowish green")

local In_Game = false

game.Players.PlayerAdded:connect(function(p)
	p.CharacterAdded:connect(function(c)
		c:WaitForChild("Humanoid").Died:connect(function()
			for i,k in pairs (Survivors) do
				if k == p.Name then
					table.remove(Survivors,i)
					workspace.Announcement.Value = tostring(#Survivors).." Survivors Left!"
					coroutine.resume(coroutine.create(function()
						game:GetService("PointsService"):AwardPoints(p.userId,1)
					end))
				end
			end
		end)
	end)
	local lead = Instance.new("Folder",p)
	lead.Name = "leaderstats"
	local wins = Instance.new("IntValue",lead)
	local total = Instance.new("IntValue",lead)
	wins.Name = "Wins"
	total.Name = "Total Wins"
	pcall(function()
		total.Value = ds:GetAsync(tostring(p.userId))
		data[tostring(p.userId)] = total.Value
	end)
	p:LoadCharacter()
	p.Character:Destroy()
end)

game.Players.PlayerRemoving:connect(function(p)
	for i,k in pairs (Survivors) do
		if k == p.Name then
			table.remove(Survivors,i)
			workspace.Announcement.Value = tostring(#Survivors).." Survivors Left!"
		end
	end
	ds:SetAsync(tostring(p.userId),data[tostring(p.userId)])
	data[tostring(p.userId)] = nil
end)

local function Announce(str)
	for i,k in pairs (game.Players:GetPlayers()) do
		coroutine.resume(coroutine.create(function()
			local lbl = k.PlayerGui.ScreenGui.Menu.Announcement
			if In_Game == false then
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
			end
			lbl.Text = str
			lbl.TextTransparency = 0
			lbl.TextStrokeTransparency = 0
		end))
	end
end

local function Note(str)
	for i,k in pairs (game.Players:GetPlayers()) do
		coroutine.resume(coroutine.create(function()
			local frame = k.PlayerGui.ScreenGui.Menu.Note
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
		end))
	end
end

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

local speed = 1

local function Change_Speed()
	if speed > 7 then return end
	speed = speed + 1
	workspace.Audio.Pitch = .8 + .1*speed
end

local function Get_Chance(num)
	if num > 30 then
		return 1
	elseif num > 20 then
		return 3
	elseif num > 10 then
		return 5
	elseif num > 5 then
		return 7
	elseif num > 0 then
		return 10
	else
		return 9e9
	end
end

local function Get_Position()
	if math.random(Get_Chance(#Survivors)) == 1 then
		local name = Survivors[math.random(#Survivors)]
		if workspace:FindFirstChild(name) and workspace[name]:FindFirstChild("Torso") then
			return workspace[name].Torso.Position + Vector3.new(0,85,0)
		else
			return Vector3.new(math.random(-.5*workspace.Baseplate.Size.X,.5*workspace.Baseplate.Size.X),100,math.random(-.5*workspace.Baseplate.Size.Z,.5*workspace.Baseplate.Size.Z))
		end
	else
		return Vector3.new(math.random(-.5*workspace.Baseplate.Size.X,.5*workspace.Baseplate.Size.X),100,math.random(-.5*workspace.Baseplate.Size.Z,.5*workspace.Baseplate.Size.Z))		
	end
end

local function Activate_Tacos()
	workspace.Audio.Volume = .5
	workspace.Audio:Play()
	Survivors = {}
	workspace.Baseplate.BrickColor = BrickColor.Random()
	for i,k in pairs (game.Players:GetPlayers()) do
		table.insert(Survivors,k.Name)
		k:LoadCharacter()
		coroutine.resume(coroutine.create(function()
			game:GetService("PointsService"):AwardPoints(k.userId,1)
		end))
	end
	In_Game = true
	workspace.Announcement.Value = tostring(#Survivors).." Survivors Left!"
	wait(1)
	coroutine.resume(coroutine.create(function()
		while In_Game do
			for i=1,30 do wait(.5) end
			Change_Speed()
		end
	end))
	repeat
		for e=1,speed do
			local taco = game.ServerStorage.Taco:Clone()
			local function Burst()
				local r = 2*math.pi/speed
				for i=1,speed do
					local part = Instance.new("Part",workspace)
					local sound = Instance.new("Sound",part)
					sound.SoundId = "rbxassetid://"..Sizzle_Sounds[math.random(#Sizzle_Sounds)]
					sound.Volume = 1
					part.Size = Vector3.new(1,1,1)
					part.CFrame = CFrame.new(taco.Position+Vector3.new(0,10*speed,0))
					part.TopSurface = Enum.SurfaceType.Smooth
					part.BottomSurface = Enum.SurfaceType.Smooth
					part.CanCollide = false
					part.Locked = true
					part.BrickColor = Acid_Color
					part.Material = Enum.Material.Pebble
					part.Parent = workspace
					part.Velocity = 75*Vector3.new(math.cos(r*i),0,math.sin(r*i)) + Vector3.new(0,25,0)
					local sizzled = false
					part.Touched:connect(function(h)
						sound:Play()
						if h.Parent and h.Parent:FindFirstChild("Humanoid") then
							h.Parent.Humanoid:TakeDamage(sizzled and 15 or 25)
						end
						if sizzled == false and (h.Parent and h.Parent:FindFirstChild("Humanoid") or h.Name == "Baseplate") then
							part.Anchored = true
							sizzled = true
							local mesh = Instance.new("CylinderMesh",part)
							mesh.Scale = Vector3.new(.1,.2,.1)
							coroutine.resume(coroutine.create(function()
								for i=.15,5,.05*speed do
									part.Size = Vector3.new(math.floor(i),1,math.floor(i))
									mesh.Scale = Vector3.new(i,.5,i)
									wait()
								end
								for i=1,10 do wait(.3) end
								part:Destroy()
							end))
						end
					end)
				end
				taco:Destroy()
			end
			taco.Touched:connect(function(hit)
				if hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
					hit.Parent.Humanoid:TakeDamage(50)
				end
				if hit.Parent and hit.Parent:FindFirstChild("Humanoid") or hit.Name == "Baseplate" then
					Burst()
				end
			end)
			taco.CFrame = CFrame.new(Get_Position())*CFrame.Angles(math.rad(math.random(360)),math.rad(math.random(360)),math.rad(math.random(360)))
			taco.Parent = workspace:FindFirstChild("Tacos") or workspace
		end
		wait(.25)
	until #Survivors <= 1
	In_Game = false
	workspace.Audio.Volume = 0
	workspace.Announcement.Value = #Survivors == 1 and Survivors[1].." Won!" or "Nobody Won :("
	if Survivors[1] then
		pcall(function()
			game.Players[Survivors[1]].leaderstats.Wins.Value = game.Players[Survivors[1]].leaderstats.Wins.Value + 1
			game.Players[Survivors[1]].leaderstats["Total Wins"].Value = game.Players[Survivors[1]].leaderstats["Total Wins"].Value + 1
		end)
		pcall(function()
			data[tostring(game.Players[Survivors[1]].userId)] = data[tostring(game.Players[Survivors[1]].userId)] + 1
		end)
		pcall(function()
			game:GetService("PointsService"):AwardPoints(game.Players[Survivors[1]].userId,15)
		end)
	end
end

while wait(5) do
	if game.Players.NumPlayers >= 2 then
		workspace.Announcement.Value = "It's about to RAIN!!!"
		wait(3)
		speed = 1
		Activate_Tacos()
	else
		workspace.Announcement.Value = "Need 2 Players To Play. Invite Your Friends!"
	end
end
