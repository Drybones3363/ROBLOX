local Y_Coordinate = 0;
local Center_Radius = 150;
local Terrain_Thickness = 3;
local Smoothness = 600; --length of map
local Extra_Length = 100;

local Loot = {Bronze = {
		Value = 2,
		Chance = 200
	},
	Silver = {
		Value = 5,
		Chance = 180
	},
	Gold = {
		Value = 25,
		Chance = 19
	},
	Diamond = {
		Value = 250,
		Chance = 1
	}
}

local Data = {}

local function angle(r)
	return (180/math.pi)*r
end

local function Generate_Map()
	math.randomseed(tick())
	local tbl = {}
	local function turn_Table_to_Terrain(tbl,speed)
		if speed == nil then speed = 25 end
		for i,k in pairs (tbl) do
			workspace.Terrain:FillBlock(CFrame.new(k[3])*CFrame.fromEulerAnglesXYZ(math.rad(k[4].x),math.rad(k[4].y),math.rad(k[4].z)),k[5],k[2])
			if i % speed == 0 then wait() end
		end
		tbl = {}
	end
	local function make_Center()
		for i=1,96 do
			table.insert(tbl,{"Part","Grass",Vector3.new(0,-7+Y_Coordinate,0),Vector3.new(0,angle(i*math.pi/96),0),Vector3.new(Center_Radius*2,Terrain_Thickness,5)})
		end
		turn_Table_to_Terrain(tbl)
	end
	local function make_Corner(corner,steepness)
		if not steepness then
			steepness = 0
			for i = 1,4 do
				if math.random(i) == 1 then
					steepness = steepness + math.random(23)-1
				else
					break
				end
			end
			steepness = steepness*({-1,1})[math.random(2)]
		end
		steepness = math.rad(steepness)
		local Angle_Per_Part,Steep_Per_Loop = math.pi/4/math.ceil(Smoothness/2),math.pi/math.ceil(Smoothness/2)
		local Corner_Angle = math.pi/2*(corner-1)+math.pi/4
		for i=0,math.ceil(Smoothness/2) do
			local steep = steepness*(math.cos(i*Steep_Per_Loop)/2+.5)
			for _,k in pairs ({Corner_Angle+Angle_Per_Part*i,Corner_Angle-Angle_Per_Part*i}) do
				table.insert(tbl,{
					"Part",
					"Grass",
					Vector3.new(Center_Radius*math.cos(k)+(math.cos(steep)*Smoothness/2)*math.cos(k), (Smoothness/2)*math.sin(steep)+Y_Coordinate-.5-10, Center_Radius*math.sin(k)+(math.cos(steep)*Smoothness/2)*math.sin(k)), --position
					Vector3.new(0,-angle(k),angle(steep)), --rotation
					Vector3.new(Smoothness,Terrain_Thickness,3) --size
				})
				local End_Point = Vector3.new(Center_Radius*math.cos(k)+(math.cos(steep)*Smoothness)*math.cos(k), (Smoothness)*math.sin(steep)+Y_Coordinate-.5-10, Center_Radius*math.sin(k)+(math.cos(steep)*Smoothness)*math.sin(k))
				table.insert(tbl,{
					"Part",
					"Grass",
					End_Point+Vector3.new(Extra_Length/2*math.cos(k),0,Extra_Length/2*math.sin(k)),
					Vector3.new(0,-angle(k),0),
					Vector3.new(Extra_Length,Terrain_Thickness,3)
				})
			end
		end
	end
	--make_Center()
	for i=1,4 do
		make_Corner(i)
		turn_Table_to_Terrain(tbl)
	end
end

local function Generate_Trees()
	local model = workspace:FindFirstChild("Trees") and workspace.Trees or Instance.new("Model",workspace)
	model.Name = "Trees"
	local trees = game.ServerStorage.Trees:GetChildren()
	for deg = 1,360 do
		local r = math.rad(deg)
		for i=1,1 do
			local tree = trees[math.random(#trees)]:Clone()
			local dist = math.random(Center_Radius+20,Center_Radius+Smoothness)
			local ray = Ray.new(Vector3.new(dist*math.cos(r),750,dist*math.sin(r)),Vector3.new(0,-1500))
			local part,pos = workspace:FindPartOnRay(ray,model)
			tree:SetPrimaryPartCFrame(CFrame.new(pos))
			tree.Parent = model
		end
		wait()
	end
end

local function Spawn_Loot()
	local total = (function() local i = 0 for _,k in pairs (Loot) do i = i + k.Chance end return i end)()
	local model = workspace:FindFirstChild("Loot") and workspace.Loot or Instance.new("Model",workspace)
	model.Name = "Loot"
	for i=1,50 do
	--for i=1,math.random(game.Players.NumPlayers*2,game.Players.NumPlayers*4) do
		local num = math.random(total)
		local typ = (function() for e,k in pairs (Loot) do num = num - k.Chance if num <= 0 then return e end end end)()
		local loot = game.ServerStorage.Loot:FindFirstChild(typ)
		if loot then
			loot = loot:Clone()
			local part,pos
			pcall(function()
				local tree = workspace.Trees:GetChildren()[math.random(#workspace.Trees:GetChildren())]
				local r = math.rad(math.random(360))
				local ray = Ray.new(tree.PrimaryPart.Position+Vector3.new(3*math.cos(r),750,3*math.sin(r)),Vector3.new(0,-1500))
				part,pos = workspace:FindPartOnRay(ray,workspace:FindFirstChild("Trees"))
			end)
			if pos == nil then
				local dist = math.random(Center_Radius+20,Center_Radius+Smoothness)
				local r = math.rad(math.random(360))
				local ray = Ray.new(Vector3.new(dist*math.cos(r),750,dist*math.sin(r)),Vector3.new(0,-1500))
				part,pos = workspace:FindPartOnRay(ray,workspace:FindFirstChild("Trees"))
			end
			loot.CFrame = CFrame.new(pos)
			loot.Parent = model
			loot.Touched:connect(function(h)
				local hum = h.Parent and h.Parent:FindFirstChild("Humanoid")
				local plr = h.Parent and game.Players:GetPlayerFromCharacter(h.Parent)
				if hum and plr then
					loot:Destroy()
					--[[pcall(function()
						plr.leaderstats.Cash.Value = plr.leaderstats.Cash.Value + Loot[typ].Value
					end)]]
					pcall(function()
						Data[tostring(plr.userId)].Cash = Data[tostring(plr.userId)].Cash + Loot[typ].Value
					end)
					workspace.RE:FireClient(plr,"AwardLabel",typ.." Collected!  +"..tostring(Loot[typ].Value))
				end
			end)
		end
	end
end

local function getCharPos(char)
	if char == nil then return end
	local t = {"Head","Torso","Right Leg","Left Leg","Right Arm","Left Arm","HumanoidRootPart"}
	for i=1,#t do
		if char:FindFirstChild(t[i]) then
			return char[t[i]].Position
		end
	end
end

local function Change_WalkSpeed(plr,num)
	local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = num
	end
end

local function Close_Doors()
	local a1 = Instance.new("Sound",workspace)
	a1.SoundId = "rbxassetid://403492983"
	a1.Volume = .75
	local a2 = Instance.new("Sound",workspace)
	a2.SoundId = "rbxassetid://438260635"
	a2.PlayOnRemove = true
	a2.Volume = 1
	a2.Pitch = .5
	a1:Play()
	local done = false
	for i,k in pairs (workspace.Doors:GetChildren()) do
		delay(0,function()
			for i=-11.5,2.5,.125*.5 do
				k.CFrame = CFrame.new(Vector3.new(k.Position.X,i,k.Position.Z))*CFrame.Angles(math.rad(k.Rotation.X),math.rad(k.Rotation.Y),math.rad(k.Rotation.Z))
				wait()
			end
			if done == false then
				done = true
				a1:Stop()
				a2:Destroy()
				delay(5,function() a1.Parent = nil end)
			end
		end)
	end
end

local function Open_Doors()
	local a1 = Instance.new("Sound",workspace)
	a1.SoundId = "rbxassetid://403492983"
	a1.Volume = .75
	local a2 = Instance.new("Sound",workspace)
	a2.SoundId = "rbxassetid://438260635"
	a2.PlayOnRemove = true
	a2.Volume = 1
	a2.Pitch = .5
	a1:Play()
	local done = false
	for i,k in pairs (workspace.Doors:GetChildren()) do
		delay(0,function()
			for i=2.5,-11.5,-.125*.5 do
				k.CFrame = CFrame.new(Vector3.new(k.Position.X,i,k.Position.Z))*CFrame.Angles(math.rad(k.Rotation.X),math.rad(k.Rotation.Y),math.rad(k.Rotation.Z))
				wait()
			end
			if done == false then
				done = true
				a1:Stop()
				a2:Destroy()
				delay(5,function() a1.Parent = nil end)
			end
		end)
	end
end

function workspace.RF.OnServerInvoke()
	
end

workspace.RE.OnServerEvent:connect(function(plr,typ,...)
	if typ == "Change WalkSpeed" then
		Change_WalkSpeed(plr,...)
	end
end)

game.Players.PlayerAdded:connect(function(plr)
	Data[tostring(plr.userId)] = {Cash = 0}
	local lead = Instance.new("Model",plr)
	lead.Name = 'leaderstats'
	local cash = Instance.new("IntValue",lead)
	cash.Name = "Cash"
	cash.Value = 0
end)

local function Give_Cash()
	for i,k in pairs (game.Players:GetPlayers()) do
		local pos = getCharPos(k.Character)
		if pos == nil then
			pcall(function()
				Data[tostring(k.userId)].Cash = 0
			end)
		elseif (pos-Vector3.new()).magnitude < 145 then
			pcall(function()
				k.leaderstats.Cash.Value = k.leaderstats.Cash.Value + Data[tostring(k.userId)].Cash
				Data[tostring(k.userId)].Cash = 0
			end)
		else
			pcall(function()
				Data[tostring(k.userId)].Cash = 0
			end)
			delay(math.random(5),function()
				workspace.RF:InvokeClient(k,"DeathLighting")
				if not pcall(function()
					k.Character.Humanoid.Health = 0
				end) then
					k:LoadCharacter()
				end
				wait(2.5)
				workspace.RE:FireClient(k,"ReturnLighting")
			end)
			delay(math.random(10,20),function()
				if not pcall(function()
					k.Character.Humanoid.Health = 0
				end) then
				 	wait(3)
					k:LoadCharacter()
				end
			end)
		end
	end
end

game.Lighting:SetMinutesAfterMidnight(350)

local Day = 0

local night,lootspawn = true,0

local hint = Instance.new("Hint",workspace)
hint.Text = "Generating Map... Please Wait..."

Generate_Map()
Generate_Trees()
Spawn_Loot()

hint:Destroy()

delay(0,function()
	while wait(.09) do
		local m = game.Lighting:GetMinutesAfterMidnight()
		if night == true and m >= 360 and m < 18*60 then
			night = false
			Open_Doors()
		elseif night == false and (m < 360 or m >= 18*60) then
			night = true
			Close_Doors()
			delay(5,Give_Cash)
		end
		if Day ~= lootspawn then
			pcall(function()
				workspace.Loot:ClearAllChildren()
			end)
			Spawn_Loot()
			lootspawn = Day
		end
		game.Lighting:SetMinutesAfterMidnight(m+math.random(3,5)*.1)
		if game.Lighting:GetMinutesAfterMidnight() < m then
			Day = Day + 1
			print("Day "..tostring(Day))
		end
	end
end)
