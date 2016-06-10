---- Input Variables ----

-- Pre Games --

local ods = game:GetService("DataStoreService"):GetOrderedDataStore("LeaderboardData1")
local killOds = game:GetService("DataStoreService"):GetOrderedDataStore("KillsData")
local ps = game:GetService("PointsService")
--local currentData = {}
local Players_Required = 2

---------------

-- Game Settings --

local Character_Repetition = true
local XP_Per_Kill = 100
local XP_Per_Wolf_Kill = 75
local XP_Per_Win = {
	Per_Player = 75,
	Starting = 175
}
local XP_Per_Day = {
	Per_Day = 75,
	Starting = 75
}
local xpPerWin = XP_Per_Win.Starting
local XP_Per_Games = 75
local Disaster_Rewards = {
	Drought = 200,
	Rain = 25,
	Famine = 200,
	["Intoxicate Water"] = 150,
	["Tracker Jackers"] = 250,
	["Mosquito Mutts"] = 200
}

-------------------

-- Test Settings --

local Auto_Pick_Disasters = {}

-------------------


-- Main Map Generation --

local Y_Coordinate = 100
local Length_of_Map = 800
local Extra_Length = 150

-------------------------

-- Pedestals --

local Pedestal_Length_From_Corn = 150
local Total_Angle_of_Pedestals = 165
local Pedestal_Y_Coordinate = 3

---------------

-- Cornucopia Area --

local Center = Vector2.new(1140,1186)
local Length_of_Area = 1.5 --multiplied by Pedestal_Length_From_Corn to get radius
local Cornucopia_Square = {Vector2.new(1127,1171),Vector2.new(1154,1201.404)}
local Supply_Spread = 4 --multiplied by Pedestal_Length_From_Corn

---------------------

-- Supplies --

local Number_of_Weapons = {
	Per_Player = .25,
	Starting = 10
}

local Number_of_Quenchers = {
	Per_Player = 1,
	Starting = 7
}

--------------

-- Biomes --

local Biomes = {{"Grassland",25},{"Forest",22},{"Desert",20},{"Tundra",18},{"Autumn",15}} --chances ,{"Ruins",15},{"Jungle",15}

-------------------

-- Bodies of Water --

local Width_of_Rivers = 100

---------------------

-- Fish Size Chances --

local Fish_Sizes = {{1,50},{2,25},{3,13},{4,7},{5,4},{6,1}}

-------------------------

local ds = game:GetService("DataStoreService"):GetDataStore("Data-Released")

local Equipped_Characters = {}

local Default_Equipped_Characters = {
	Male = {
		"Ned",
		"Oscar"
	},
	Female = {
		"Olivia",
		"Beth"
	}
}

local Testing = false --keep this false at all times

local Data = {}

local Default_Data = {
	XP = 5,
	Kills = 0,
	Wins = 0,
	SP = 0,
	Hat1 = 0,
	Hat2 = 0,
	Hat3 = 0,
	Class1 = 323573605,
	Class2 = 323574122,
	Class3 = 323575926,
	Face = 144075659,
	Package = 319453625,
	Jacket = 152355316,
	Pants = 157605701,
	Skin = 255204153,
	Axe = "No-Skin",
	Trident = "No-Skin",
	Bow = "No-Skin",
	Sword = "No-Skin",
	Knife = "No-Skin",
	Mace = "No-Skin",
	Machete = "No-Skin",
	Badges = {},
	D = 0
}

local Stage = "Waiting For Players"

local Picked_Character = {}

_G.Dead_Tributes_To_Show = {}

_G.Character_Data = {}

local Games_Data = {} --{Player Died,Killed By,Weapon}
_G.Games_Player_Data = {} --{Player Died,Killed By,Weapon}

local function Wait(n)
	if type(n) ~= "number" then
		n = 0
	end
	local t = 0
	repeat
		t = t + wait()
	until t >= n
	return t
end

local function getPrestige(level)
	if level == 10 then
		return 268679976
	elseif level == 9 then
		return 268679883
	elseif level == 8 then
		return 268037612
	elseif level == 7 then
		return 268679841
	elseif level == 6 then
		return 280704093
	elseif level == 5 then
		return 268679807
	elseif level == 4 then 
		return 268679734
	elseif level == 3 then
		return 268679715
	elseif level == 2 then
		return 268037548
	elseif level == 1 then
		return 280676072
	elseif level == 0 then
		return 268037497
	end
end

local function Get_Tributes(status)
	local tbl = {}
	if type(status) == "string" then
		for i,k in pairs (_G.Tributes) do
			if k[1] and k[2]:lower() == status:lower() then
				table.insert(tbl,k[1])
			end
		end
	else
		for i,k in pairs (_G.Tributes) do
			if k[1] then
				table.insert(tbl,k[1])
			end
		end
	end
	return tbl
end

local function Get_Ancestor(instance,name)
	repeat
		instance = instance.Parent
		if instance.Name == name then
			return instance
		end
	until instance == game
end

local function Get_Num_Tributes(status)
	local n = 0
	if type(status) == "string" then
		for i,k in pairs (_G.Tributes) do
			if k[1] and k[2]:lower() == status:lower() then
				n = n + 1
			end
		end
	else
		for i,k in pairs (_G.Tributes) do
			if k[1] then
				n = n + 1
			end
		end
	end
	return n
end

_G.Votes = {0,0,0}
_G.Options = {nil,nil,nil}
_G.Disaster = nil

local Disaster_Table = {
	{
		Title = "Rain",
		Pic = "rbxassetid://206092225",
		Desc = "Covers the entire arena with rain cloud."	
	},
	{
		Title = "Drought",
		Pic = "rbxassetid://206458376",
		Desc = "Water in Arena dries out for a period of time. Everyone will get thirsty!"
	},
	{
		Title = "Famine",
		Pic = "rbxassetid://206102436",
		Desc = "Food becomes scarce! Everyone will get more hungry!"
	},
	{
		Title = "Intoxicate Water",
		Pic = "rbxassetid://328362561",
		Desc = "Water becomes intoxicated! Water will damage anyone who attempts to drink it!"
	},
	{
		Title = "Tracker Jackers",
		Pic = "rbxassetid://328362457",
		Desc = "Spawns Tracker Jackers, deadly mutts that make you hallucinate when stung, in Trees across the entire Map."
		Flag = "flag{no1_c@n_surv1ve_the_j@ckers}"
	},
	{
		Title = "Mosquito Mutts",
		Pic = "rbxassetid://328356511",
		Desc = "Sends a deadly Mosquito Mutt to every tribute on the map giving the tribute dehydration and famine"
	}
}

local function Disaster_Reward_XP(disaster)
	for i,k in pairs (Get_Tributes("Alive")) do
		local plr = game.Players:FindFirstChild(k)
		Data[tostring(plr.userId)].XP = Data[tostring(plr.userId)].XP + (Disaster_Rewards[disaster] or 10)
		workspace.Remotes.Event:FireClient(plr,"Awarded XP",Disaster_Rewards[disaster],"Surviving the "..disaster.." Disaster.")
		workspace.Remotes.Event:FireClient(plr,"Changed XP",Data[tostring(plr.userId)].XP)
		_G.Games_Player_Data[plr.Name].XP = _G.Games_Player_Data[plr.Name].XP + Disaster_Rewards[disaster]
		coroutine.resume(coroutine.create(function() ps:AwardPoints(plr.userId,Disaster_Rewards[disaster]) end))
		workspace.Remotes.Event:FireClient(plr,"Level Change",returnFromXP(Data[tostring(plr.userId)].XP))
	end
end

local function playAnnounceSound(id)
	coroutine.resume(coroutine.create(function()
		pcall(function()
			local sound = Instance.new("Sound",game.Workspace)
			sound.SoundId = "rbxassetid://"..id
			sound:Play()
			sound:Destroy()
		end)
	end))
end

local Disasters = {

	Drought = function(length)
		playAnnounceSound(331596156)
		if length == nil then length = math.random(45,60) end
		for i,k in pairs (workspace:GetChildren()) do
			if k.ClassName == "Part" and k.Name == "Water Part" then
				k.BrickColor = BrickColor.new("Black")
				k.Material = Enum.Material.Slate
				k.CanCollide = true
				k.Transparency = 0
			elseif game.Players:GetPlayerFromCharacter(k) and k:FindFirstChild("Torso") then
				if k.Torso.Position.Y <= -17.5 then
					k:MoveTo(Vector3.new(k.Torso.Position.X,21,k.Torso.Position.Z))
				end
			end
		end
		_G.Disaster = "Drought"
		Wait(length)
		for i,k in pairs (workspace:GetChildren()) do
			if k.ClassName == "Part" and k.Name == "Water Part" then
				k.CanCollide = false
				k.Transparency = 1
			end
		end
		Disaster_Reward_XP(_G.Disaster)
		_G.Disaster = nil
	end
	,
	["Intoxicate Water"] = function(length)
		playAnnounceSound(331595832)
		if length == nil then length = math.random(45,60) end
		workspace.Terrain.WaterColor = Color3.new(0,.45,0)
		_G.Disaster = "Intoxicate Water"
		Wait(length)
		workspace.Terrain.WaterColor = Color3.new(12/255,84/255,91/255)
		Disaster_Reward_XP(_G.Disaster)
		_G.Disaster = nil
	end
	,
	["Tracker Jackers"] = function(length)
		playAnnounceSound(331595157)
		if length == nil then length = math.random(45,60) end
		_G.Disaster = "Tracker Jackers"
		local model = workspace:FindFirstChild("Trees")
		local c = model:GetChildren()
		local nests = Instance.new("Model",workspace)
		for i=1,10 do
			local tree = c[math.random(#c)]
			local ch = tree:GetChildren()
			pcall(function()
				local nest = game.ServerStorage["Tracker Jacker Nest"]:Clone()
				nest.CFrame = CFrame.new(ch[math.random(#ch)].Position)
				nest.Parent = nests
				nest.Audio:Play()
				coroutine.resume(coroutine.create(function()
					while wait(.75) and _G.Disaster == "Tracker Jackers" do
						for i=1,3 do wait(.75) end
						local tribs = Get_Tributes("Alive")
						for _,k in pairs (tribs) do
							local p = game.Players:FindFirstChild(k)
							if p and p.Character and p.Character.PrimaryPart then
								if (p.Character.PrimaryPart.Position-nest.Position).magnitude < 150 then
									local bees = game.ServerStorage["Tracker Jackers"]:Clone()
									bees.Position = nest.Position
									bees.Parent = workspace
									local y = -2
									bees.Audio:Play()
									coroutine.resume(coroutine.create(function()
										while wait(.75) do
											y = y == -2 and 2 or -2
										end
									end))
									
									local not_stung = true
									bees.Touched:connect(function(h)
										local p = h.Parent and game.Players:GetPlayerFromCharacter(h.Parent)
										if p then
											bees.Sting:Play()
											if not_stung then
												not_stung = false
												wait()
												local sgui = Instance.new("ScreenGui",p.PlayerGui)
												sgui.Name = "StungBackground"
												local lbl = Instance.new("ImageLabel",sgui)
												lbl.Size = UDim2.new(1,0,1,0)
												lbl.BackgroundTransparency = 1
												lbl.Image = "rbxassetid://328371453"
												lbl.ZIndex = 3
												workspace.Remotes.Event:FireClient(p,"Hallucinate")
												for i=1,50 do
													pcall(function()
														h.Parent.Humanoid:TakeDamage(math.random(750,1500)*.001)
													end)
													wait(.5)
												end
												workspace.Remotes.Event:FireClient(p,"End Hallucination")
												sgui:Destroy()
											end
										end
									end)
									coroutine.resume(coroutine.create(function()
										while bees and bees.Parent and not_stung do
											pcall(function()
												bees.BodyPosition.Position = p.Character.PrimaryPart.Position
												local d = 100*(bees.Position-p.Character.PrimaryPart.Position).magnitude + 100
												if d > 3000 then d = 3000 end
												bees.BodyPosition.D = d
											end)
											wait()
										end
										bees.BodyPosition.Position = nest.Position
										bees.BodyPosition.D = 2000
										for i=1,15 do
											wait(.5)
										end
										bees:Destroy()
									end))
								end
							end
						end
					end
				end))
			end)
		end
		Wait(length)
		Disaster_Reward_XP(_G.Disaster)
		nests:Destroy()
		_G.Disaster = nil
	end
	,
	["Mosquito Mutts"] = function(length)
		playAnnounceSound(331595968)
		if length == nil then length = math.random(55,75) end
		_G.Disaster = "Mosquito Mutts"
		for i,k in pairs (Get_Tributes("Alive")) do
			local p = game.Players:FindFirstChild(k)
			if p and p.Character then
				local mos = game.ServerStorage.Mosquito:Clone()
				mos:SetPrimaryPartCFrame(CFrame.new(Vector3.new(Center.x,100,Center.y)))
				--mos.Body:WaitForChildBodyPosition = mos.Body.Position
				mos.Parent = workspace
				coroutine.resume(coroutine.create(function()
					local y = -1
					mos.Body.Audio:Play()
					coroutine.resume(coroutine.create(function()
						while wait(.75) do
							y = y == -1 and 1 or -1
						end
					end))
					mos.Body.Touched:connect(function(h)
						local plr = game.Players:GetPlayerFromCharacter(h.Parent) 
						if plr then
							local died = false
							if plr.Character and plr.Character:FindFirstChild("Humanoid") then
								plr.Character.Humanoid.Died:connect(function()
									died = true
								end)
							end
							if plr:FindFirstChild("PlayerGui") then
								local sgui = Instance.new("ScreenGui",plr.PlayerGui)
								sgui.Name = "StungBackground"
								local lbl = Instance.new("ImageLabel",sgui)
								lbl.Size = UDim2.new(1,0,1,0)
								lbl.BackgroundTransparency = 1
								lbl.Image = "rbxassetid://328371453"
								lbl.ZIndex = 3
								coroutine.resume(coroutine.create(function()
									local data
									for i=1,75 do
										if not data then data = game.ServerStorage.PlayerValues:FindFirstChild(tostring(plr.userId)) end
										if died == false then
											if data and data:FindFirstChild("Hunger") and data:FindFirstChild("Thirst") then
												data.Hunger.Value = data.Hunger.Value - .5
												data.Thirst.Value = data.Thirst.Value - .5
											end
										end
										wait(.5)
									end
									sgui:Destroy()
									workspace.Remotes.Event:FireClient(plr,"End Hallucination")
								end))
							end
							workspace.Remotes.Event:FireClient(plr,"Hallucinate")
							mos.Body.Audio.Volume = 0
							mos.Body.Audio:Destroy()
							mos.Body.Sting:Play()
							mos:Destroy()
						end
					end)
					while wait() and mos and mos.Parent do
						pcall(function()
							mos.Body.BodyPosition.Position = p.Character.PrimaryPart.Position + Vector3.new(0,y,0)
							local d = 100*(mos.Body.Position-p.Character.PrimaryPart.Position).magnitude + 100
							if d > 3000 then d = 3000 end
							mos.Body.BodyPosition.D = d
						end)
					end
				end))
			end
		end
		Wait(length)
		Disaster_Reward_XP(_G.Disaster)
		_G.Disaster = nil
		for i,k in pairs (workspace:GetChildren()) do
			if k.Name == "Mosquito" and k.ClassName == "Model" then
				k:Destroy()
			end
		end
	end
	,
	Rain = function(length)
		playAnnounceSound(331595891)
		if length == nil then length = math.random(45,60) end
		local cloud = Instance.new("Part",workspace)
		cloud.Material = Enum.Material.SmoothPlastic
		cloud.Anchored = false
		cloud.Locked = true
		cloud.CanCollide = false
		cloud.Transparency = .0337
		local bodypos = Instance.new("BodyPosition",cloud)
		bodypos.position = Vector3.new(100,347,100)
		bodypos.maxForce = Vector3.new(4000,9e99,4000)
		bodypos.D = 1337
		bodypos.P = 137
		local mesh = Instance.new("SpecialMesh",cloud)
		mesh.MeshId = "http://www.roblox.com/asset/?id=1095708"
		mesh.MeshType = Enum.MeshType.FileMesh
		mesh.TextureId = "http://www.roblox.com/asset/?id=1095709"
		mesh.VertexColor = Vector3.new(0.75, 0.75, 0.85)
		mesh.Scale = Vector3.new(5000,1,5000)
		cloud.CFrame = CFrame.new(Vector3.new(3337,347,3337))
		repeat wait(.5) until (bodypos.position-cloud.Position).magnitude <= 137
		_G.Disaster = "Rain"
		for i,k in pairs (Get_Tributes("Alive")) do
			local plr = game.Players:FindFirstChild(k)
			if plr and plr:FindFirstChild("PlayerGui") then
				local ui = script.RainUI:Clone()
				ui.Parent = plr.PlayerGui
				ui.LocalScript.Disabled = false
			end
		end
		local sound = Instance.new("Sound",workspace)
		sound.SoundId = "rbxassetid://236148388"
		sound.Volume = .25
		sound.Looped = true
		sound:Play()
		Wait(length)
		Disaster_Reward_XP(_G.Disaster)
		_G.Disaster = nil
		cloud:Destroy()
		sound:Destroy()
		for i,k in pairs (game.Players:GetPlayers()) do
			pcall(function()
				k.PlayerGui.RainUI:Destroy()
			end)
		end
	end
	,
	Famine = function(length)
		playAnnounceSound(331596067)
		if length == nil then length = math.random(45,60) end
		_G.Disaster = "Famine"
		pcall(function() workspace.TreeFruit:ClearAllChildren() end)
		Wait(length)
		Disaster_Reward_XP(_G.Disaster)
		_G.Disaster = nil
	end
}

local function weldIfHat(hat)
	if not hat:IsA("Hat") then return end
	local handle = hat:findFirstChild("Handle")
	if not handle then return end
	local character = hat.Parent
	local head = character:findFirstChild("Head")
	if not head then return end
	handle.Parent = character
	local weld = Instance.new("Weld",handle)
	weld.Part0,weld.Part1 = head,handle
	weld.C0 = CFrame.new(0,0.5,0)
	weld.C1 = hat.AttachmentPoint
	hat:Destroy()
end

local organization = {
	"CurrencyType", --{1 = Level,2 = Twitter Code,3 = Robux}
	"CurrencyAmount",
	"Strength",
	"Speed",
	"Stamina",
	"Survival",
	"Reputation",
	"PicID",
	"CharMeshTorso",
	"CharMeshRightArm",
	"CharMeshLeftArm",
	"CharMeshRightLeg",
	"CharMeshLeftLeg",
	"HatID1",
	"HatID2",
	"HatID3",
	"Face",
	"HeadColor",
	"TorsoColor",
	"RightArmColor",
	"LeftArmColor",
	"RightLegColor",
	"LeftLegColor",
	"Animation1",
	"Animation2",
	"Animation3",
	"Animation4",
	"Animation5",
	"Spear",
	"Axe",
	"Bow",
	"Kunai",
	"Sword",
	"Knife",
	"Machete",
	"Mace",
	"Trident",
	"Gender",
	"BodyOverlay"
}

--[[coroutine.resume(coroutine.create(function()
	local tbl = ds:GetAsync("CharacterData")
	for char,tab in pairs (tbl) do
		local t = {}
		for i,k in pairs (tab) do
			t[organization[i]]--[[ = k --index is nil?
		end
		_G.Character_Data[char] = t
	end
end))
--]]

local function Weld(model)
	local prev
	local parts = model:GetChildren()
	for i = 1,#parts do
		if (prev ~= nil) then
			local weld = Instance.new("Weld")
			weld.Part0 = prev
			weld.Part1 = parts[i]
			weld.C0 = prev.CFrame:inverse()
			weld.C1 = parts[i].CFrame:inverse()
			weld.Parent = prev
			parts[i].Anchored = false
		end
		prev = parts[i]
	end
end

local function Wait(n)
	local t = 0
	repeat
		t = t + wait()
	until t >= n
	return t
end

local function angle(r)
	return (180/math.pi)*r
end

local function Studs_To_Km(studs)
	return .00005*studs
end

local function playerDied(p,tab)
	for a,b in pairs(tab) do
		if b.Name == p.Name then
			table.remove(tab,a)
			local boom = Instance.new("Sound",game.Workspace)
			boom.Volume = 1
			boom.Pitch = 1
			boom.SoundId = "http://www.roblox.com/asset/?id=138186576"
			boom:Play()
			boom:Destroy()
		end
	end
end

local function Sponser_Tribute(trib,item)
	local function find_item()
		for i,k in pairs (game.ServerStorage.Supplies:GetChildren()) do
			for e,r in pairs (k:GetChildren()) do
				if r.Name == item then
					return r
				end
			end
		end
	end
	local para = game.ServerStorage.Parachute:Clone()
	para.Position = trib.Character.Head.Position + Vector3.new(0,200,0)
	para.BodyPosition.Position = trib.Character.Head.Position
	para.Parent = workspace
	coroutine.resume(coroutine.create(function()
		while wait(.1) and para.Parent == workspace do
			pcall(function()
				para.BodyPosition.Position = trib.Character.Head.Position
			end)
		end
	end))
	coroutine.resume(coroutine.create(function()
		for i=1,80 do wait(.5) end
		para:Destroy()
	end))
	para.Touched:connect(function(hit)
		local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
		if plr then
			local function alive()
				for _,k in pairs (Get_Tributes("Alive")) do
					if k == plr.Name then
						return true
					end
				end
			end
			if alive() then
				local it = find_item():Clone()
				it.Parent = plr.Backpack
				para:Destroy()
				wait()
				if it:FindFirstChild("Poison") then
					it.Poison:Destroy()
				end
			end
		end
	end)
end

local function Get_Random_Positions(Tree_Pos,Y_Height_of_Branch,Thickness,Length_of_Branch)
	local tbl = {}
	local old = math.rad(math.random(1,360))
	local r = old
	repeat
		table.insert(tbl,Tree_Pos + Vector3.new(math.cos(r)*Thickness,Y_Height_of_Branch,math.sin(r)*Thickness))
		table.insert(tbl,Tree_Pos + Vector3.new(math.cos(r)*(Thickness+Length_of_Branch),Y_Height_of_Branch,math.sin(r)*(Thickness+Length_of_Branch)))
		r = r + math.pi/2
	until math.cos(r)-math.cos(old) < .1 and math.sin(r) - math.sin(old) < .1
	return tbl
end

local textures = {
	{"No-Skin","None","None","None","None",0,0},
	{"Bloodshed","Crimson","Really black","Granite","Slate",0,0},
	{"Void","Really black","Really black","Neon","Neon",0,0},
	{"Contrast","Really black","Lily white","Slate","Metal",0,0},
	{"Cataclysm","Really black","Bright red","Granite","Neon",0,0},
	{"Diamond","Baby blue","Baby blue","Foil","Foil",0,0},
	{"Master","Maroon","Really red","Granite","Metal",0,0},
	{"Emerald","Earth green","Bright green","Pebble","Cobblestone",0,0},
	{"Sapphire","Navy blue","Bright blue","Pebble","Cobblestone",0,0},
	{"Pink Panther","Hot pink","Pink","Pebble","Cobblestone",0,0},
	{"Red Surge","Really black","Bright red","Pebble","Cobblestone",0,0},
	{"Orange Surge","Really black","Bright orange","Pebble","Cobblestone",0,0},
	{"Yellow Surge","Really black","Bright yellow","Pebble","Cobblestone",0,0},
	{"Green Surge","Really black","Bright green","Pebble","Cobblestone",0,0},
	{"Blue Surge","Really black","Really blue","Pebble","Cobblestone",0,0},
	{"Purple Surge","Really black","Bright violet","Pebble","Cobblestone",0,0},
	{"Pink Surge","Really black","Hot pink","Pebble","Cobblestone",0,0},
	{"Creamsicle","White","Bright orange","Metal","Cobblestone",0,0},
	{"Gold","Pine Cone","Bronze","Metal","Metal",0.5,0.5},
	{"Fabulous","Hot pink","Pink","Fabric","Grass",0,0},
	{"Neon Red","Bright red","Cocoa","Neon","Neon",0,0},
	{"Neon Orange","CGA brown","Reddish brown","Neon","Neon",0,0},
	{"Neon Yellow","Neon orange","New Yeller","Neon","Neon",0,0},	
	{"Neon Green","Parsley green","Lime green","Neon","Neon",0,0},
	{"Neon Blue","Navy blue","Really blue","Neon","Neon",0,0},
	{"Neon Purple","Mulberry","Magenta","Neon","Neon",0,0},
	{"Neon Pink","Magenta","Hot pink","Neon","Neon",0,0},
	{"Super Hero","Really blue","Really red","Slate","Metal",0,0},
	{"Industrial","Dark stone grey","Light stone grey","DiamondPlate","DiamondPlate",0,0},
	{"Frost","Institutional White","Baby blue","Plastic","Slate",0,0},
}
	
local function Find_Tbl(n) --silly isaac, making me do extra -- oopsies :3
	for i=1,#textures do
		if textures[i][1] == n then
			return textures[i]
		end
	end
end
	
local function Texture(weapon,skin)
	local tbl = Find_Tbl(skin)
	if not tbl then return end
	for a,b in pairs(weapon:GetChildren()) do
		if b:IsA("BasePart") then
			if tbl[2] ~= "None" and tbl[3] ~= "None" and tbl[4] ~= "None" and tbl[5] ~= "None" then
				pcall(function()
					b.UsePartColor = true
				end)
				if b:FindFirstChild("Primary") then
					b.BrickColor = BrickColor.new(tbl[2])
					b.Material = tbl[4]
					b.Reflectance = tbl[6]
				end
				if b:FindFirstChild("Secondary") then
					b.BrickColor = BrickColor.new(tbl[3])
					b.Material = tbl[5]
					b.Reflectance = tbl[7]
				end
			else
				pcall(function()
					b.UsePartColor = false
					b.Material = "Plastic"
					b.Reflectance = 0
				end)
			end
		end
	end
end

local function Activate_Textures(weapon,start_client_sided)
	local scs = start_client_sided or false
	weapon.AncestryChanged:connect(function(child,parent)
		if child == weapon then
			if (scs and weapon:IsDescendantOf(workspace)) or (not scs and weapon:IsDescendantOf(game.Players)) then
				scs = not scs
				return
			end
			if weapon:IsDescendantOf(workspace) then
				local plr = game.Players:GetPlayerFromCharacter(weapon.Parent)
				if plr then
					Texture(weapon,Data[tostring(plr.userId)][weapon.Name] or "No-Skin")
				else
					Texture(weapon,"No-Skin")
				end
			elseif weapon:IsDescendantOf(game.Players) then
				local plr = weapon.Parent.Parent
				if plr then
					Texture(weapon,Data[tostring(plr.userId)][weapon.Name] or "No-Skin")
				end
			end
		end
	end)
end

--[[coroutine.resume(coroutine.create(function()
	while wait(30) do
		for a,b in pairs(game.Players:GetChildren()) do
			pcall(function()
			ods:SetAsync(b.userId.."XP",game.Workspace.HeldXP:FindFirstChild(b.Name).Value)
			end)
		end
	end
end))]]
--[[
-- turn_Table_to_Terrain Manipulation --

table
[1] = classname
[2] = material
[3] = position
[4] = rotation
[5] = size


----------------------------------------
--]]

--[[
-- Map Generation --	


--------------------	
--]]

local function Get_Random_from_Table(tbl)
	local total = 0
	for _,k in pairs (tbl) do
		total = total + k[2]
	end
	local rand = math.random(total)
	for i,k in pairs (tbl) do
		rand = rand - k[2]
		if rand <= 0 then
			return k[1]
		end
	end
	return Biomes[1][1]
end

local function Put_in_ForceField()
	local ff = game.ServerStorage.Forcefield:clone()
	ff.Position = Vector3.new(0,Y_Coordinate+50,0)
	ff.Parent = workspace
end

local function Connect_Water_Touch_Event(part)
	part.Touched:connect(function(h)
		local plr = game.Players:GetPlayerFromCharacter(h.Parent)
		if plr and _G.Disaster ~= "Drought" and _G.Disaster ~= "Intoxicate Water" then
			local data = game.ServerStorage.PlayerValues[tostring(plr.userId)]
			if data then
				pcall(function()
					data.Thirst.Value = data.Thirst.Value + math.random(3)
				end)
			end
			--fill water bottles
		elseif plr and _G.Disaster == "Intoxicate Water" and h.Parent:FindFirstChild("Humanoid") then
			h.Parent.Humanoid:TakeDamage(math.random(3))
		end
	end)
end
local function Triangle_Gen(biomename)	
	local mapLen = 68
	local segmentLen = 50
	local cornRadius = 400
	
	local mapData = {}
	local map = Instance.new("Model",game.Workspace)
	map.Name = "Arena"
	local middle = "None"
	
	local biomes = {
		--{"Biome","treeChance","multiplier","smoothness"},
		{"Forest",200,250,22},
		{"Desert",300,375,40},
		{"Grassland",300,375,40},
		{"Autumn",225,200,24},
		{"Winter",200,250,22},
		{"Tundra",200,250,22},
	}
	biome = (function()
		for _,e in pairs (biomes) do
			if e[1] == biomename then
				return e
			end
		end
		return biomes[3]
	end)()
	
	print("Generating the "..biome[1].." biome...")
	
	local d
	local function createTriangle(n1,n2,n3,sign)
	local w1=Instance.new("WedgePart");
	w1.Name="TerrainPiece";
	w1.formFactor="Symmetric";
	w1.Anchored=true;
	local findingSolution=true;
	while findingSolution do
	local r=Ray.new(n1,(n3-n1).unit);
	d=r:ClosestPoint(n2);
	if (n1-d).magnitude>=(n1-n3).magnitude or (n3-d).magnitude>=(n3-n1).magnitude then
	local n=n1;
	n1=n3;
	n3=n2;
	n2=n;
	else
	findingSolution=false;
	end
	end
	local pos=(n1:lerp(n2,.5));
	local v2=(n1:lerp(d,.5)-pos).unit*-1;
	local v3=(n2:lerp(d,.5)-pos).unit;
	local v1=(v2:Cross(v3));
	local y=(n2-d).magnitude;
	local z=(n1-d).magnitude;
	w1.Size=Vector3.new(1,y,z);
	w1.CFrame=CFrame.new(pos.x,pos.y,pos.z,v1.x,v2.x,v3.x,v1.y,v2.y,v3.y,v1.z,v2.z,v3.z)*CFrame.new(sign*-.5,0,0);
	local highestVal=0;
	local m=Instance.new("SpecialMesh");
	m.MeshType="Wedge";
	m.Scale=Vector3.new(1,y/w1.Size.y,z/w1.Size.z);
	m.Parent=w1;
	local w2=Instance.new("WedgePart");
	w2.Name="TerrainPiece";
	w2.formFactor="Symmetric";
	w2.Anchored=true;
	local pos=(n3:lerp(n2,.5));
	local v2=(n3:lerp(d,.5)-pos).unit*-1;
	local v3=(n2:lerp(d,.5)-pos).unit;
	local v1=(v2:Cross(v3));
	local y=(n2-d).magnitude;
	local z=(n3-d).magnitude;
	w2.Size=Vector3.new(1,y,z);
	w2.CFrame=CFrame.new(pos.x,pos.y,pos.z,v1.x,v2.x,v3.x,v1.y,v2.y,v3.y,v1.z,v2.z,v3.z)*CFrame.new(sign*.5,0,0);
	local m=Instance.new("SpecialMesh");
	m.MeshType="Wedge";
	m.Scale=Vector3.new(1,y/w2.Size.y,z/w2.Size.z);
	m.Parent=w2;
	return w1,w2;
	end
	
	local function noiseHeight(x,z,ran,num,height,root)
		local noise = -math.noise((x+root)/ran,(z+root)/ran,num)
		local noise2 = -math.noise((x+root)/(ran*2),(z+root)/(ran*2),num)
		local noise3 = -math.noise((x+root)/(ran*0.75),(z+root)/(ran*0.75),num)
		local rootHeight = ((noise*height)+(math.sin(noise2)*(height/2))+(noise3*height)) + 100
		return rootHeight
	end
	
	local function getColor(biome,part)
		local colors = {
			{"Forest",{ {"Dark green","Grass",200}, {"Sea green","Grass",150}, {"Bright green","Grass",100}, {"Shamrock","Grass",-20}}},
			{"Autumn",{ {"Dark green","Grass",200}, {"Sea green","Grass",150}, {"Bright green","Grass",100}, {"Shamrock","Grass",-20}}},
			{"Winter",{ {"Ghost grey","Sand",200}, {"Mid gray","Sand",150}, {"Pearl","Sand",50}, {"Bright green","Grass",-20}}}
		}
		local color = nil
		local material = nil
		if part:FindFirstChild("Part") then
			for i = 1,#colors do
				if colors[i][1] == biome[1] then
					for i2 = 1,#colors[i][2] do
						if colors[i][2][i2][3] <= part.Position.Y then
							color = BrickColor.new(colors[i][2][i2][1])
							material = colors[i][2][i2][2]
							break
						end
					end
					if color == nil then
						color = BrickColor.new(colors[i][2][#colors[i][2]][1])
						material = colors[i][2][#colors[i][2]][2]
					end
				end
			end
		end
		return color,material
	end
	
	local function createLayout()
		local root = (segmentLen/2)
			
		for x = 1,mapLen do
			for z = 1,mapLen do
				local base = Vector3.new(x*segmentLen,0,z*segmentLen)
				local p1 = base + Vector3.new(root,0,root)
				local p2 = base + Vector3.new(-root,0,root)
				local p3 = base + Vector3.new(-root,0,-root)
				local p4 = base + Vector3.new(root,0,-root)
				
				if x == (mapLen/2) and z == (mapLen/2) then
					table.insert(mapData,{p1,p2,p3,p4,"Middle",base})
					middle = #mapData
				else
					table.insert(mapData,{p1,p2,p3,p4,"Part",base})
				end
			end
		end
	end
	
	local function createMountains()
		local smoothness = math.random((biome[4]-2),(biome[4]+20))
		local heightMult = math.random((biome[3]-50),(biome[3]+30))
		local rootNum = math.random(-1000,1000)
		
		for i = 1,#mapData do
			for i2 = 1,#mapData[i] do
				local Distance = (mapData[i][i2] - mapData[middle][6]).magnitude
				local Height_Dampen = (Distance < cornRadius*2 and (Distance-cornRadius)/cornRadius or 1)
				if (Distance < cornRadius) then
					Height_Dampen = 0
					mapData[i][5] = "CornPart"
				end
				local x = mapData[i][i2].X
				local z = mapData[i][i2].Z
				
				local height = (noiseHeight(x/segmentLen,z/segmentLen,smoothness,10000,heightMult,rootNum))*Height_Dampen
				
				mapData[i][i2] = Vector3.new(x,height,z)

				if i2 == 4 then break end
			end
			if i % mapLen == 0 then wait() end
		end
	end
	
	local function createCornucopia()
		local corn = game.ServerStorage.Cornucopia:Clone()
		corn.Parent = workspace
		corn:SetPrimaryPartCFrame(CFrame.new(mapData[middle][1].X,mapData[middle][1].Y+0.5,mapData[middle][1].Z))
		
		local radius = cornRadius - 100
		local peds = Instance.new("Model",workspace)
		peds.Name = "Pedestals"
		for i = 1, 24 do
			local ped = game.ServerStorage.Pedestal:Clone()
			local angle = math.rad(180/24) * i
			ped:SetPrimaryPartCFrame(CFrame.new(mapData[middle][1].X,mapData[middle][1].Y+0.025,mapData[middle][1].Z) + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius))
			ped.Name = "Pedestal"..tostring(i)
			ped.Parent = peds
			wait()
		end
	end
	
	local function createFromData()
		local num = 0
		for i = 1,#mapData do
			if mapData[i][6] ~= "Void" then
				num = num + 1
				if num % mapLen == 0 then
					wait(0.1)
				end
				local parts = {}
				local part1,part2 = createTriangle(mapData[i][1],mapData[i][2],mapData[i][3],0)
				local part3,part4 = createTriangle(mapData[i][1],mapData[i][4],mapData[i][3],0)
				table.insert(parts,part1)
				table.insert(parts,part2)
				table.insert(parts,part3)
				table.insert(parts,part4)
				for c = 1,#parts do
					parts[c].Parent = map
					parts[c].Name = mapData[i][5]
					if parts[c].Position.Y > -20 then
						Instance.new("IntValue",parts[c]).Name = "Part"
						local color,material = getColor(biome,parts[c])
						parts[c].Material = material or "Grass"
						parts[c].BrickColor = color or BrickColor.new("Bright Green")
					else
						parts[c].Material = "Sand"
						parts[c].BrickColor = BrickColor.new("Light orange")
					end
					if parts[c].Position.Y <= -10 then
						local dis = math.floor((parts[c].Position - Vector3.new(parts[c].Position.X,0,parts[c].Position.Z)).magnitude)
						local wPart = Instance.new("Part",game.Workspace)
						wPart.Anchored = true
						wPart.Transparency = 1
						wPart.CanCollide = false
						local y = 0-math.floor(parts[c].Position.Y)-36
						if y > 0.5 then
							wPart.Size = Vector3.new(segmentLen*1.5,math.floor(y),segmentLen*1.5)
							wPart.CFrame = CFrame.new(parts[c].Position + Vector3.new(0,y/2,0))
							--[[
							game.Workspace.Terrain:FillBlock(wPart.CFrame,wPart.Size*.4,"Water")
							wait(.5)
							game.Workspace.Terrain:FillBlock(wPart.CFrame,wPart.Size*.666,"Water")
							wait(.5)
							game.Workspace.Terrain:FillBlock(wPart.CFrame,wPart.Size,"Water")
							wait(.5)
							--]]
							game.Workspace.Terrain:FillBlock(wPart.CFrame,wPart.Size,"Water")
							local water_part = Instance.new("Part",workspace)
							water_part.Name = "Water Part"
							water_part.Anchored = true
							water_part.CanCollide = false
							water_part.Locked = true
							water_part.Size = Vector3.new(wPart.Size.X,1,wPart.Size.Z)
							water_part.CFrame = CFrame.new(wPart.Position + Vector3.new(0,math.floor(y)*.5,0))
							water_part.Transparency = 1
							Connect_Water_Touch_Event(water_part)
							wPart:Destroy()
						end
					end
					local part = parts[c]
					local autumnColors = {
						"Really red",
						"Crimson",
						"Bright orange",
						"Neon orange",
						"New Yeller",
						"Gold",
					}
					local model = game.ServerStorage.Trees:FindFirstChild(biome[1])
					local chance = math.random(1,biome[2])
					if part.BrickColor ~= BrickColor.new("Light orange") and chance <= 2 and part.Name ~= "CornPart" then
						local spawn = Instance.new("Part",game.Workspace)
						spawn.Anchored = true
						spawn.CFrame = CFrame.new(part.Position.X,part.Position.Y,part.Position.Z)
						local tree = model:GetChildren()[math.random(1,#model:GetChildren())]:Clone()
						tree.Parent = workspace:FindFirstChild("Trees") or (function() Instance.new("Model",workspace).Name = "Trees" return workspace.Trees end)()
						tree:SetPrimaryPartCFrame(spawn.CFrame * CFrame.Angles(0,math.random(-360,360),0) + Vector3.new(0,tree.PrimaryPart.Size.Y/2,0))
						spawn:Destroy()
						local color = part.BrickColor
						if biome[1] == "Autumn" then
							color = BrickColor.new(autumnColors[math.random(1,#autumnColors)])
						end
						for a,b in pairs(tree:GetChildren()) do
							if b.Name == "Leaves" and b:IsA("BasePart") then
								b.BrickColor = color
							end
						end
					end
				end
			end
		end
	end
	createLayout()
	
	createCornucopia()
	
	createMountains()	
	
	createFromData()
end

local function Add_ForceField()
	local ff = game.ServerStorage.ForceField:Clone()
	ff.Parent = workspace
	for i,k in pairs (ff:GetChildren()) do
		if k.ClassName == "Part" then
			k.Touched:connect(function(hit)
				local hum = hit.Parent:FindFirstChild("Humanoid")
				if hum and hum:FindFirstChild("HitFF") == nil then
					Instance.new("Folder",hum).Name = "HitFF"
					coroutine.resume(coroutine.create(function()
						wait()
						for e,r in pairs (hum:GetChildren()) do
							if r.Name == "HitFF" then
								
							end
						end
					end))
					hum:TakeDamage(50)
					hum.Sit = true
					if hit.Parent:FindFirstChild("Torso") then
						hit.Parent.Torso.Velocity = Vector3.new(0,75,0)
					end
				end
			end)
		end
	end
end

local function Generate_Arena()
	local biome = Get_Random_from_Table(Biomes)
	print("Biome: "..biome)
	_G.Biome = biome
	Triangle_Gen(biome)
	--[[
	if workspace:FindFirstChild("Arena") then workspace.Arena:Destroy() end
	local model = Instance.new("Model")
	for i=1,10 do
		local part,pos
		repeat
			part,pos = workspace:FindPartOnRay(Ray.new(Vector3.new(math.random(-Length_of_Map,Length_of_Map),200,math.random(-Length_of_Map,Length_of_Map)),Vector3.new(0,-400,0)))
			wait()
		until part and part.Parent
		local arenacam = game.ServerStorage.ArenaCam:Clone()
		arenacam:SetPrimaryPartCFrame(CFrame.new(pos+Vector3.new(0,10,0),Vector3.new(0,Y_Coordinate,0)))
		arenacam.Parent = model
	end
	model.Name = "Arena"
	model.Parent = workspace
	--]]
	--Add_ForceField()
	return true
end

local function Clear_Arena()
	pcall(function()
		workspace.Cornucopia:Destroy()
	end)
	pcall(function()
		workspace.Pedestals:Destroy()
	end)
	pcall(function()
		workspace.Trees:Destroy()
	end)
	pcall(function()
		workspace.Shrubs:Destroy()
	end)
	pcall(function()
		workspace.Arena:Destroy()
	end)
	pcall(function()
		workspace.Countdown:Destroy()
	end)
	_G.Biome = nil
	wait(5)
	pcall(function()
		workspace.Map:Destroy()
	end)
	pcall(function()
		workspace.Fallen:Destroy()
	end)
	pcall(function()
		for i,k in pairs (workspace:GetChildren()) do
			if k.Name == "Water Part" then
				k:Destroy()
			end
		end
	end)
	workspace.Terrain:Clear()
	for i,k in pairs (workspace:GetChildren()) do
		if k.Name:sub(1,6) == "Corpse" or game.ServerStorage["Lagless Weapons"]:FindFirstChild(k.Name) or k.ClassName == "Tool" then
			k:Destroy()
		end
	end
end

function returnNextXP(level,prestige)
	if level < 24 then
		return math.ceil(math.floor((((((level*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
	else
		return math.ceil(math.floor((((((1*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
	end
end
--[[
game.Players.PlayerAdded:connect(function(player)
	table.insert(currentData,{player.Name,0,0,0})
end)
--]]
--[[
function callLeaderboard(plr)
	pcall(function()
			coroutine.resume(coroutine.create(function()
				local tab = {}
				local function correctColor(level)
					if level == 10 then
						return Color3.new(1,0,0)
					elseif level == 9 then
						return Color3.new(50/255,115/255,160/255)
					elseif level == 8 then
						return Color3.new(1,1,0)
					elseif level == 7 then
						return Color3.new(160/255,60/255,135/255)
					elseif level == 6 then
						return Color3.new(50/255,115/255,160/255)
					elseif level == 5 then
						return Color3.new(1,0,1)
					elseif level == 4 then
						return Color3.new(110/255,255,65)
					elseif level == 3 then
						return Color3.new(1,1,1)
					elseif level == 2 then
						return Color3.new(125/255,125/255,125/255)
					elseif level == 1 then
						return Color3.new(1,125/255,60/255)
					elseif level == 0 then
						return Color3.new(1,1,1)
					end
				end
				
				local function setUp()
					local leaderboard = script.Leaderboard:Clone()
					--for a,b in pairs(game.Players:GetChildren()) do
						if plr:FindFirstChild("PlayerGui") and plr.PlayerGui:FindFirstChild("Leaderboard") then 
							plr.PlayerGui.Leaderboard:Destroy()
						end
						for c,d in pairs(leaderboard:GetChildren()) do
							if d:IsA("Frame") then d:Destroy() end
						end
						for i = 1,#tab do
							local frame = script.Player:Clone()
							repeat wait() until leaderboard
							frame.Name = tab[i].Name
							frame.Position = UDim2.new(0.8,0,(0.025*i)-0.025,0)
							pcall(function() if type(tab[i]) == "Player" and tab[i]:IsFriendsWith(plr.userId) and tab[i].Name ~= plr.Name then
								frame.Friend.Visible = true
							end end)
							local r = math.floor((math.floor(frame.PlayerLevel.TextColor3.r*255)-155)/255)
							local g = math.floor((math.floor(frame.PlayerLevel.TextColor3.g*255)-155)/255)
							local b = math.floor((math.floor(frame.PlayerLevel.TextColor3.b*255)-155)/255)
							wait()
							local strokeColor = Color3.new(r,g,b)
							frame.PlayerLevel.TextStrokeColor3 = strokeColor
							coroutine.resume(coroutine.create(function()
								while wait() do
									if updated == true then break end
									local number = Data[tostring(tab[i].userId)] and Data[tostring(tab[i].userId)].XP
									if not number then number = 0 end
									local Prestige,Level,XP = returnFromXP(number)
									if frame:FindFirstChild("PlayerLevel") and frame:FindFirstChild("Prestige") then
										frame.PlayerLevel.Text = Level
										frame.PlayerLevel.TextColor3 = correctColor(Prestige)
										if Prestige == 10 then
											frame.PlayerLevel.Visible = false
										else
											frame.PlayerLevel.Visible = true
										end
										frame.Prestige.Image = "http://www.roblox.com/asset/?id="..tostring(getPrestige(Prestige))
									end
									wait(1)
								end
							end))
							frame.PlayerName.Text = tab[i].Name
							if tab[i].Name == "ObscureEntity" or tab[i].Name == "FutureWebsiteOwner" then
								if tab[i].Name == plr.Name then				
									frame.PlayerName.TextColor3 = Color3.new(1,0,0)
									frame.PlayerName.Text = frame.PlayerName.Text.."(THG:R Dev) (You)"
								else
									frame.PlayerName.TextColor3 = Color3.new(1,0,0)
									frame.PlayerName.Text = frame.PlayerName.Text.."(THG:R Dev)"
								end
							elseif tab[i].Name == "ThisUserSecret" then
								if tab[i].Name == plr.Name then				
									frame.PlayerName.TextColor3 = Color3.new(1,0,1)
									frame.PlayerName.Text = frame.PlayerName.Text.."(THG:R GFX) (You)"
								else
									frame.PlayerName.TextColor3 = Color3.new(1,0,1)
									frame.PlayerName.Text = frame.PlayerName.Text.."(THG:R GFX)"
								end
							else
								if tab[i].Name == plr.Name then				
									frame.PlayerName.TextColor3 = Color3.new(1,0,0)
									frame.PlayerName.Text = frame.PlayerName.Text.."(You)"
								end
							end
							frame.Parent = leaderboard
						end
						leaderboard.Parent = plr.PlayerGui
					--end
				end
				
				local function update()
					tab = {}
					updated = true
					wait()
					updated = false
					for a,b in pairs(script.Parent:GetChildren()) do 
						if b:FindFirstChild("LeaderboardFrame") then
							b:Destroy()
						end
					end
					wait(1)
					for a,b in pairs(game.Players:GetChildren()) do
						table.insert(tab,b)
					end
					setUp()
				end
				
				update() 
			end))
	end)
end

game.Players.PlayerAdded:connect(function(player)
	for a,b in pairs(game.Players:GetPlayers()) do
		wait(0.5)
		callLeaderboard(b)
	end
end)

game.Workspace.ChildAdded:connect(function(obj)
	if game.Players:FindFirstChild(obj.Name) then
		callLeaderboard(game.Players:FindFirstChild(obj.Name))
	end
end)

game.Players.PlayerRemoving:connect(function(player)
	for a,b in pairs(game.Players:GetPlayers()) do
		wait(0.5)
		callLeaderboard(b)
	end
end)

--]]

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

local function Find_Tool(name)
	for i,k in pairs (game.ServerStorage.Supplies:GetChildren()) do
		if k:FindFirstChild(name) then
			return k[name]
		end
	end
end

local touched_tbl = {}

local speed_pick_up = { --1/30 is about a second
	Axe = .075,
	Bow = .1,
	Knife = .15,
	Mace = .0575,
	Machete = .075,
	Spear = .075,
	Sword = .075,
	Trident = .06,
	Default = 0.15
}

local function Connect_Touch_Tool(tool,corn)
	if corn == nil then corn = false end
	local name = tool.Name
	local touched = false
	for i,k in pairs (tool:GetChildren()) do
		if k.ClassName == "UnionOperation" or k.ClassName == "Part" then
			k.Touched:connect(function(h)
				local pl = game.Players:GetPlayerFromCharacter(h.Parent)
				if pl and touched_tbl[pl.Name] == nil and pl:FindFirstChild("Backpack") and touched == false then
					touched = true
					touched_tbl[pl.Name] = true
					local clone = Find_Tool(tool.Name):Clone()
					Activate_Textures(clone,true)
					if clone:FindFirstChild("Poison") and corn then
						clone.Poison:Destroy()
					end
					tool:Destroy()
					coroutine.resume(coroutine.create(function()
						local sgui = Instance.new("ScreenGui",pl.PlayerGui)
						local img = Instance.new("ImageLabel",sgui)
						local bar = Instance.new("Frame",img)
						local lbl = Instance.new("TextLabel",img)
						sgui.Name = "D3b0unc3Gui"
						img.Name = "imgTool"
						bar.Name = "Bar"
						lbl.Name = "lblPick"
						img.BackgroundColor3 = Color3.new(.2,.2,.2)
						img.BackgroundTransparency = .5
						img.Position = UDim2.new(.6,0,.62,0)
						img.Size = UDim2.new(.1,0,.2,0)
						img.ZIndex = 2
						img.Image = clone.TextureId
						img.ScaleType = Enum.ScaleType.Slice
						bar.BackgroundColor3 = Color3.new(0,1,0)
						bar.BackgroundTransparency = .5
						bar.Size = UDim2.new(0,0,1,0)
						lbl.BackgroundTransparency = 1
						lbl.Position = UDim2.new(0,0,-.25,0)
						lbl.Size = UDim2.new(1,0,.25,0)
						lbl.Text = "Picking Up:"
						lbl.TextColor3 = Color3.new(0,1,0)
						lbl.Font = Enum.Font.SourceSansItalic
						lbl.TextScaled = true
						lbl.TextStrokeTransparency = 0
						for e=0,1.5,((speed_pick_up[name] or speed_pick_up["Default"])*.5) do
							if e > 1 then e = 1 end
							bar.Size = UDim2.new(e,0,1,0)
							if e == 1 then break end
							wait()
						end
						clone.Parent = pl.Backpack
						sgui:Destroy()
						touched_tbl[pl.Name] = nil
					end))
				end
			end)
		end
	end
end

local function Spawn_Weapons(n)
	--[[
	local Weapons = {{"Machete",10},{"Mace",10},{"Bow",18},{"Axe",12},{"Knife",22},{"Spear",10},{"Sword",13},{"Trident",5},{"Kunai",15}}
	if n == nil then n = math.floor(#Get_Tributes("alive")*Number_of_Weapons.Per_Player+Number_of_Weapons.Starting) end
	local storage = game.ServerStorage["Lagless Weapons"]:GetChildren()
	if #storage == 0 then return end
	--[[for i,k in pairs (storage) do
		if k.Name == "Bow" then
			for i=1,2 do
				table.insert(storage,k)
			end
		end
	end
	--]] --[[
	for i,k in pairs (workspace:GetChildren()) do
		if k.Name == "Weapons" then
			k:Destroy()
		end
	end
	local weapons = Instance.new("Model",workspace)
	weapons.Name = "Weapons"
	pcall(function() for i=1,n do
		local In_Corn = math.random(3) == 1
		local r = math.rad(math.random(Total_Angle_of_Pedestals)+90)
		local x,z = In_Corn and math.random(Cornucopia_Square[1].x,Cornucopia_Square[2].x) or 1151 + math.cos(r)*math.random(math.ceil(Supply_Spread*Pedestal_Length_From_Corn)),In_Corn and math.random(Cornucopia_Square[1].y,Cornucopia_Square[2].y) or 1212 + math.sin(r)*math.random(math.ceil(Supply_Spread*Pedestal_Length_From_Corn))
		--x = x + workspace.Cornucopia.Root.Position.X
		--z = z + workspace.Cornucopia.Root.Position.Z
		local randweap =  Get_Random_from_Table(Weapons) or "Knife"
		local weap = game.ServerStorage["Lagless Weapons"]:FindFirstChild(randweap or "Knife")
		if weap then
			local model = Instance.new("Model")
			model.Name = weap.Name
			for i,k in pairs (weap:GetChildren()) do
				if k.ClassName == "UnionOperation" or k.ClassName == "Part" then
					local clone = k:Clone()
					clone.Name = k.Name
					clone.CanCollide = true
					clone.Parent = model
				end
			end
			model.PrimaryPart = model:FindFirstChild("Handle")
			local rootPos = game.Workspace.Cornucopia.Root.Position
			model:SetPrimaryPartCFrame(CFrame.new(Vector3.new(rootPos.X+math.random(-75,75),7,rootPos.Z+75+math.random(-30,30))))
			coroutine.resume(coroutine.create(function()
				Connect_Touch_Tool(model,false)
			end))
			Weld(model)
			model.Parent = weapons
			wait()
		end
	end end)
	--]]
	local model = game.ServerStorage.Corn_Weapons:Clone()
	model.Parent = workspace
	model:SetPrimaryPartCFrame(workspace.Cornucopia.PrimaryPart.CFrame)
	local toolIds = {
		{"Trident",285223268},
		{"Backpack",389407102},
		{"Bow",278209630},
		{"Knife",285223512},
		{"Spear",325014511},
		{"Machete",285223891},
		{"Kunai",210600756},
		{"Sword",285223293},
		{"Mace",278209586},
		{"Axe",285223472},
		{"Empty Bottle",389704874},
		{"Bottle",389704874},
		{"Flashlight",389682961},
		{"Black Apple",324642329},
		{"Cyan Apple",324642329},
		{"Green Apple",324642329},
		{"Red Apple",324642329},
		{"Black Berries",324610046},
		{"Cyan Berries",324610046},
		{"Purple Berries",324610046},
		{"Red Berries",324610046},
		{"Yellow Berries",324610046},
	}
	for a,b in pairs(model:GetChildren()) do
		if b:IsA("Model") then
			for c,d in pairs(b:GetChildren()) do
				pcall(function()
					d.Touched:connect(function(t)
						if game.Players:FindFirstChild(t.Parent.Name) then
							if d.Parent:FindFirstChild("HasTouched") == nil and d.Parent:FindFirstChild("Stand") == nil then
								local plr = game.Players:FindFirstChild(t.Parent.Name)
								local id = nil
								local name = d.Parent.Name
								local items = nil
								Instance.new("IntValue",d.Parent).Name = "HasTouched"
								if d.Parent.Name == "Backpack" then
									items = {}
									for i = 1,#d.Parent.Items:GetChildren() do
										local item = d.Parent.Items:GetChildren()[1]
										table.insert(items,{item.Value,item.Id.Value})
									end
								end
								d.Parent:Destroy()
								for i = 1,#toolIds do
									if toolIds[i][1] == name then
										id = toolIds[i][2]
										break
									end
								end	
								if plr.Character:FindFirstChild("Backpack") == nil then
									if items ~= nil then
										for i = 1,#items do
											game.Workspace.InventoryEvent:FireClient(plr,"AddItem",items[i][1],items[i][2])
										end
									end
								end
								game.Workspace.InventoryEvent:FireClient(plr,"AddItem",name,id)
							end
						end
					end)
				end)		
			end
		end
	end
end



local function Spawn_Fruit(n,otherfood)
	if n == nil then n = #Get_Tributes("Alive")*Number_of_Quenchers.Per_Player+Number_of_Quenchers.Starting end
	if otherfood == nil then otherfood = true end
	local storage = game.ServerStorage.Supplies.Fruit:GetChildren()
	if otherfood then
		for i,k in pairs (game.ServerStorage.Supplies.Food:GetChildren()) do
			table.insert(storage,k)
		end
	end
	if #storage == 0 then return end
	for i,k in pairs (workspace:GetChildren()) do
		if k.Name == "Fruit" then
			k:Destroy()
		end
	end
	local weapons = Instance.new("Model",workspace)
	weapons.Name = "Fruit"
	for i=1,n do
		local In_Corn = math.random(3) == 1
		local r = math.rad(math.random(Total_Angle_of_Pedestals)+90)
		local x,z = In_Corn and math.random(Cornucopia_Square[1].x,Cornucopia_Square[2].x) or 1151 + math.cos(r)*math.random(math.ceil(Supply_Spread*Pedestal_Length_From_Corn)),In_Corn and math.random(Cornucopia_Square[1].y,Cornucopia_Square[2].y) or 1212 + math.sin(r)*math.random(math.ceil(Supply_Spread*Pedestal_Length_From_Corn))
		--x = x + workspace.Cornucopia.Root.Position.X
		--z = z + workspace.Cornucopia.Root.Position.Z
		local weap = storage[math.random(#storage)]
		local model = Instance.new("Model")
		model.Name = weap.Name
		for i,k in pairs (weap:GetChildren()) do
			if k.ClassName == "UnionOperation" or k.ClassName == "Part" then
				local clone = k:Clone()
				clone.Name = k.Name
				clone.CanCollide = true
				clone.Parent = model
			end
		end
		model.PrimaryPart = model:FindFirstChild("Handle")
		model:SetPrimaryPartCFrame(CFrame.new(Vector3.new(x,10,z)))
		coroutine.resume(coroutine.create(function()
			Connect_Touch_Tool(model,true)
		end))
		Weld(model)
		model.Parent = weapons
		wait()
	end
end

local function Find_Status(plr)
	if type(plr) ~= "string" then plr = plr.Name end
	for i,k in pairs (_G.Tributes) do
		if k[1] == plr then
			return k[2]
		end
	end
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

local function find_Gender(plr)
	if type(plr) ~= "string" then plr = plr.Name end
	local function find_Index()
		for i,k in pairs (_G.Tributes) do
			if k[1] == plr then
				return i
			end
		end
	end
	return find_Index() % 2 == 0 and "Female" or "Male"
end

local function pick_Character(plr,chosen)
	local gender = find_Gender(plr)
	local fold,tbl = Equipped_Characters[tostring(plr.userId)] and Equipped_Characters[tostring(plr.userId)][gender] or Default_Equipped_Characters[gender],{}
	if fold then
		for i,k in pairs (fold) do
			if Character_Repetition or #chosen == 0 then
				table.insert(tbl,k)
			else
				local function init()
					for e,r in pairs (chosen) do
						if k == r then
							return true
						end
					end
					return false
				end
				if not init() then
					table.insert(tbl,k)
				end
			end
		end
		local chose = tbl[math.random(#tbl)]
		Picked_Character[plr.Name] = chose
		pcall(function()
			_G.Games_Player_Data[plr.Name].Character = chose
		end)
		table.insert(chosen,chose)
		return chosen
	end
end

local ins = game:GetService("InsertService")

local function Get_Online_Item(id)
	local model = game.ServerStorage:FindFirstChild("OnlineModels")
	if model == nil then model = Instance.new("Folder",game.ServerStorage) model.Name = "OnlineModels" end
	for i,k in pairs (model:GetChildren()) do
		if tonumber(k.Name) == id then
			return k:Clone()
		end
	end
	local item = ins:LoadAsset(id)
	item = #item:GetChildren() > 0 and item:GetChildren()[1] or item
	item.Name = tostring(id)
	pcall(function()
		item.Handle.CanCollide = false
	end)
	item.Parent = model
	return item:Clone()
end

local function pick_Class(plr)
	if _G.Games_Player_Data[plr.Name] and Data[tostring(plr.userId)] then
		_G.Games_Player_Data[plr.Name].Class = Data[tostring(plr.userId)]["Class"..tostring(math.random(3))]
	end
	if _G.Games_Player_Data[plr.Name].Class == nil or _G.Games_Player_Data[plr.Name].Class == 0 then --something screwed up
		_G.Games_Player_Data[plr.Name].Class = Default_Data["Class"..tostring(math.random(3))]
	end
	local class = _G.Games_Player_Data[plr.Name].Class
	_G.Character_Data[plr.Name] = {}
	local model = Get_Online_Item(class)
	if model:FindFirstChild("Data") then
		for i,k in pairs (model.Data:GetChildren()) do
			_G.Character_Data[plr.Name][k.Name] = k.Value
		end
	end
end

local function Select_Characters(plrs)
	math.randomseed(tick() + 1)
	Picked_Character = {}
	local chosen = {}
	for i,k in pairs (plrs) do
		chosen = pick_Character(k,chosen)
	end
end

local function Select_Classes(plrs)
	_G.Character_Data = {}
	math.randomseed(tick() + 1)
	for i,k in pairs (plrs) do
		pick_Class(k)
	end
end

local function pick_Tributes()
	math.randomseed(tick() + 1)
	local plrs = game.Players:GetPlayers()
	local return_plrs = game.Players:GetPlayers()
	--[[for i,k in pairs (plrs) do
		if not k:FindFirstChild("Tribute") then
			table.remove(plrs,i)
			table.remove(return_plrs,i)
		end
	end]]
	local Num_of_Tributes = #plrs
	for i=1,Num_of_Tributes do
		local rand = math.random(#plrs)
		local plr = plrs[rand]
		_G.Tributes[i] = {plr.Name,"Alive"}
		_G.Games_Player_Data[plr.Name] = {Kills = 0,XP = 0}
		--plr.Tribute.Value = i
		table.remove(plrs,rand)
	end
	return return_plrs,Num_of_Tributes
end

local function Tribute_Died()
	local sound = Instance.new("Sound",workspace)
	sound.SoundId = "rbxassetid://138186576" --140284623
	sound.Volume = .666
	sound.Pitch = 1
	sound:Play()
	coroutine.resume(coroutine.create(function()
		for i=1,6 do
			wait(.75)
		end
		sound:Destroy()
	end))
end

local function Explode_Tribute(plr_name,checktribute)
	local plr = game.Players:FindFirstChild(plr_name)
	if plr then
		if plr.Character then
			--[[
			local ex = Instance.new("Explosion",plr.Character:FindFirstChild("Torso"))
			pcall(function()
				ex.Position = plr.Character:FindFirstChild("Torso").Position
			end)
			--]]
			pcall(function()
				plr.Character.Humanoid.Health = 0
			end)
			--[[
			for i,k in pairs (plr.Character:GetChildren()) do
				if k.Name == "Head" then
					k:Destroy()
				elseif k.ClassName == "Part" then
					k.Velocity = Vector3.new(math.random(-100,100),math.random(-100,100),math.random(-100,100))
				end
			end
			--]]
			if checktribute then
				local function indas()
					for i,k in pairs (_G.Tributes) do
						if k[1] == plr.Name and k[2]:lower() == "alive" then
							return true,i
						end
					end
				end
				local intbl,index = indas()
				if intbl then
					Tribute_Died()
					_G.Tributes[index][2] = "Dead"
					table.insert(_G.Dead_Tributes_To_Show,{math.ceil(.5*index),_G.Tributes[index][1],(index%2) == 0 and "Female" or "Male"})
				end
			end
		end
	end
end

local function Find_Tribute_Character(plr)
	if type(plr) ~= "string" then
		plr = plr.Name
	end
	return Picked_Character[plr]
end

local function Find_Tribute_Class(plr)
	if type(plr) == "string" then
		return _G.Games_Player_Data[plr] and _G.Games_Player_Data[plr].Class
	else
		return _G.Games_Player_Data[plr.Name] and _G.Games_Player_Data[plr.Name].Class
	end
end

function createTree(typ,pos)
	local function createBranch(pos1, pos2, thick)
		local a = Instance.new("Part", workspace)
		a.FormFactor = "Custom"
		a.BackSurface = "SmoothNoOutlines"
		a.BottomSurface = "SmoothNoOutlines"
		a.FrontSurface = "SmoothNoOutlines"
		a.LeftSurface = "SmoothNoOutlines"
		a.RightSurface = "SmoothNoOutlines"
		a.TopSurface = "SmoothNoOutlines"
		a.Anchored = true
		local mag = (pos2-pos1).magnitude
		a.Size = Vector3.new(thick, mag, thick)
		a.CFrame = CFrame.new((pos1 + pos2)/2,pos2)*CFrame.Angles(math.rad(-90),0 ,0)
		return a
	end

	if typ == "PineTree" then
	local function getBranchPoints(Tree_Pos,Y_Height_of_Branch,Thickness,Length_of_Branch)
		local tbl = {}
		local old = math.rad(math.random(1,360))
		local r = old
		repeat
			local Thick = Thickness - 1.337
			table.insert(tbl,{Tree_Pos + Vector3.new(math.cos(r)*Thick,Y_Height_of_Branch,math.sin(r)*Thick),Tree_Pos + Vector3.new(math.cos(r)*(Thick+Length_of_Branch),Y_Height_of_Branch,math.sin(r)*(Thick+Length_of_Branch))})
			r = r + math.pi/2
		until math.cos(r)-math.cos(old) < .1 and math.sin(r) - math.sin(old) < .1
		return tbl
	end
		local size = math.random(8,16)
		local thick = math.floor(size/5)
		local mult = math.random(1000, 2500) / 1000
		local last = pos
		for i = 1,4 do --math.random(4,5) do
			createBranch(last,pos + Vector3.new(0,size+(size*i),0),thick-(i/5))
			last = pos + Vector3.new(0,size+(size*i),0)
			local branchPoints = getBranchPoints(last-Vector3.new(0,math.random(1,5),0),thick-(i/4),thick-(i/4),5)
			for i2 = 1,#branchPoints do
				local branch1 = branchPoints[i2][2]-Vector3.new(0,math.random(1,2),0)
				createBranch(branchPoints[i2][1],branch1,thick-(i/4))
			end
			wait()
		end
	end
end

local function Activate_Invis_FF()
	coroutine.resume(coroutine.create(function()
		local flag = true
		while flag do
			local tribs = Get_Tributes("Alive")
			if #tribs == 0 then flag = false end
			if #tribs > 0 then
				for _,k in pairs (tribs) do
					local plr = game.Players:FindFirstChild(k)
					if plr and plr.Character and plr.Character:FindFirstChild("Torso") then
						if (Vector2.new(plr.Character.Torso.Position.x,plr.Character.Torso.Position.z)-Center).magnitude > (math.sqrt(2)*1150/(.6*(_G.Day-1)+.4)) and plr.Character:FindFirstChild("Humanoid") then
							plr.Character.Humanoid.PlatformStand = true 
							local b = Instance.new("BodyPosition",plr.Character.Torso) 
							b.D = 100000 
							b.position = Vector3.new(Center.x,plr.Character.Torso.Position.Y,Center.y) 
							b.P = 100000 
							b.maxForce = Vector3.new(15000, 10000, 15000)
							plr.Character.Humanoid:TakeDamage(math.random(500,1000)*.01)
							coroutine.resume(coroutine.create(function()
								wait(.5)
								b:Destroy()
								for i=1,4 do wait(.5) end
								plr.Character.Humanoid.PlatformStand = false
							end))
							coroutine.resume(coroutine.create(function()
								local gui = Instance.new("ScreenGui",plr.PlayerGui)
								local t = Instance.new("TextLabel",gui)
								t.BackgroundTransparency = 1
								t.Text = "Hit Forcefield!!!"
								t.TextColor3 = Color3.new(1,0,0)
								t.TextScaled = true
								t.TextStrokeColor3 = Color3.new()
								t.TextStrokeTransparency = 0
								t.Font = Enum.Font.SourceSansBold
								t.Size = UDim2.new(.2,0,.075,0)
								for i=.775,.5,-.025/2 do
									t.Position = UDim2.new(.1,0,i,0)
									wait()
								end
								gui:Destroy()
							end))
						end
					end
				end
			end
			for i=1,5 do wait(.5) end
		end
	end))
end

workspace.ChildAdded:connect(function(c)
	if c.ClassName == "Hat" then
		wait(5)
		c:Destroy()
	end
end)

local function Activate_Survival(tributes)
	if tributes == nil then
		tributes = Get_Tributes("Alive")
	end
	for i,k in pairs (tributes) do
		local plr = type(k) == "string" and game.Players:FindFirstChild(k) or k
		if plr then
			--local char = Find_Tribute_Character(plr)
			--if char == nil then char = "Default" end
			local val = 50
			pcall(function() val = _G.Character_Data[plr.Name].Survival end)
			local factor = 1/val
			local died = false
			coroutine.resume(coroutine.create(function()
				local hum
				local function gethum()
					if plr.Character then
						hum = plr.Character:FindFirstChild("Humanoid")
					end
				end
				gethum()
				if hum then
					local c = hum.Died:connect(function()
						died = true
					end)
					hum.MaxHealth = 80+1.00*(_G.Character_Data[plr.Name] and _G.Character_Data[plr.Name].Strength or 50)
					hum.Health = hum.MaxHealth
				end
				local data
				local function getdata()
					if game.ServerStorage:FindFirstChild("PlayerValues") then
						data = game.ServerStorage.PlayerValues:FindFirstChild(tostring(plr.userId))
					end
				end
				local val = 0
				getdata()
				if hum then
					hum.Changed:connect(function(type)
						if type == "Jump" then
							if data and data.Energy.Value < factor*350 then
								hum.Jump = false
							end
						end
					end)
					local c2 = hum.Jumping:connect(function(is)
						hum.Jump = false
						if is then
							if data and data.Energy.Value >= factor*350 then
								data.Energy.Value = data.Energy.Value - factor*350
							end
						end
					end)
					local c3 = hum.Changed:connect(function()
						if data.Energy.Value <= 10 then
							hum.Jump = false
						end
					end)
					local deb = false
					local c4 = hum.HealthChanged:connect(function()
						if deb == false then
							deb = true
							local t = wait(.1)
							deb = false
							pcall(function()
								local health,maxhealth = plr.Character.Humanoid.Health,plr.Character.Humanoid.MaxHealth
								if health ~= maxhealth then
									plr.Character.Humanoid.Health = plr.Character.Humanoid.Health + 2.1*t
									data.Hunger.Value = data.Hunger.Value - .75*t
								end
							end)
						end
					end)
				end
				local torso
				local function gettorso()
					if plr.Character then
						torso = plr.Character:FindFirstChild("Torso")
						if torso == nil then
							torso = plr.Character:FindFirstChild("Head")
						end
					end
				end
				gettorso()
				if torso then
					local old = torso.Position
					coroutine.resume(coroutine.create(function()
						local distance = 0
						repeat
							while wait(.1) and died == false and Stage == "Games" do
								local give = .45
								local pos = torso.Position
								if old ~= pos then
									distance = distance + (pos-old).magnitude
									local vec = Vector3.new(math.abs(old.x-pos.x),old.y-pos.y,math.abs(old.z-pos.z))
									give = give - vec.x*.1 - vec.z*.1 + (vec.y <= 0 and vec.y*.4 or vec.y <= 5 and vec.y*.07 or .35)
								end
								old = pos
								data.Energy.Value = data.Energy.Value + give  --Dont make them lose energy for walking :/. Fuck off, ill fix it
							end
							wait(.5)
						until died == true or Stage ~= "Games"
						_G.Games_Player_Data[plr.Name].Distance = Studs_To_Km(distance)
					end))
				end
				local t = 0
				local ch = plr.Character
				repeat
					if data then
						data.Hunger.Value = data.Hunger.Value - t*factor*33*.3 - (_G.Disaster == "Famine" and t*factor*37*4 or 0)
						data.Thirst.Value = data.Thirst.Value - t*factor*33*.7 - ((_G.Disaster == "Drought" and t*factor*37*4) or (_G.Disaster == "Intoxicate Water" and t*factor*37*3) or 0)
						if data.Energy.Value <= 3.337 then
							--data.Hunger.Value = data.Hunger.Value - t*factor*37*.5*4 --5 times more What are you doing that's soooooooo much hunger loss
						end
						pcall(function()
							plr.Character.Humanoid:TakeDamage((data.Hunger.Value <= 7 and .337 or 0)+(data.Thirst.Value <= 7 and .5 or 0))
						end)
						pcall(function()
							plr.Character.Humanoid.JumpPower = 30*math.log10(.5*data.Energy.Value)
						end)
						t = wait()
					else
						wait(1)
						getdata()
					end
				until died == true or plr.Character ~= ch
				pcall(function()
					data.Hunger.Value = 100
					data.Thirst.Value = 100
				end)
			end))
		end
	end
end

local function Remove_Character_Appearence(char)
	for i,k in pairs (char:GetChildren()) do
		if k:IsA("Hat") then
			k:Destroy()
		elseif k.ClassName == "CharacterMesh" then
			k:Destroy()
		end
	end
	pcall(function()
		char.Head.face:Destroy()
	end)
end

local function Load_Custom_Character(plr)
	local t = Data[tostring(plr.userId)]
	if t == nil then return end
	for _,i in pairs ({"Hat1","Hat2","Hat3","Package","Jacket","Pants","Skin","Face"}) do
		local id = t[i]
		if i == "Skin" or i == "Face" or i == "Pants" or i == "Jacket" then
			if i == "Skin" then
				id = tostring(id)
				local color = BrickColor.new(Color3.new(.004*tonumber(id:sub(1,id:len()-6)),.004*tonumber(id:sub(id:len()-5,id:len()-3)),.004*tonumber(id:sub(id:len()-2))))
				for _,k in pairs (plr.Character:GetChildren()) do
					if k.ClassName == "Part" then
						k.BrickColor = color
					end
				end
			elseif i == "Face" then
				local head = plr.Character:FindFirstChild("Head")
				if head then
					for q,w in pairs (head:GetChildren()) do
						if w.ClassName == "Decal" then
							w:Destroy()
						end
					end
					local decal = Instance.new("Decal",head)
					decal.Texture = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(id)
				end
			elseif i == "Pants" then
				for _,k in pairs (plr.Character:GetChildren()) do
					if k.ClassName == "Pants" then
						k:Destroy()
					end
				end
				local pants = Instance.new("Pants",plr.Character)
				pants.PantsTemplate = "rbxassetid://"..tostring(id-1)
			elseif i == "Jacket" then
				for _,k in pairs (plr.Character:GetChildren()) do
					if k.ClassName == "Shirt" then
						k:Destroy()
					end
				end
				local shirt = Instance.new("Shirt",plr.Character)
				shirt.ShirtTemplate = "rbxassetid://"..tostring(id-1)
			end
		else
			local item = Get_Online_Item(id)
			if i:sub(1,3) == "Hat" then
				coroutine.resume(coroutine.create(function()
					pcall(function()
						local hand = item:WaitForChild("Handle")
						hand.Name = tostring(id)
						hand.CanCollide = false
						hand.Anchored = false
						local weld = Instance.new("Weld",hand)
						weld.Part0 = hand
						weld.Part1 = plr.Character.Head		
						weld.C0 = CFrame.new(0,-.5,0)
						weld.C1 = item.AttachmentPoint:inverse()
						hand.Parent = plr.Character
					end)
				end))
			elseif i == "Package" then
				for _,k in pairs (item:GetChildren()) do
					if k.ClassName == "CharacterMesh" then
						k:Clone().Parent = plr.Character
					end
				end
			end
		end
	end
end

--[[local function Load_Character_Appearence(char,tbl)
	if not tbl then print("Table is "..type(tbl)) return end
	for i=1,3 do
		if tbl["HatID"..tostring(i)] ~= nil then
			local hat = ins:LoadAsset(tbl["HatID"..tostring(i)]):GetChildren()[1]
			hat.Parent = char
			coroutine.resume(coroutine.create(function()
				weldIfHat(hat)
			end))
		end
	end
	for i,k in pairs ({"Torso","RightArm","RightLeg","LeftArm","LeftLeg","Head"}) do
		if tbl["CharMesh"..k] then
			local mesh = Instance.new("CharacterMesh",char)
			mesh.BodyPart = Enum.BodyPart[k]
			mesh.MeshId = tbl["CharMesh"..k]
			mesh.OverlayTextureId = tbl["BodyOverlay"]
		end
		if tbl[k.."Color"] then
			local bodypart = char:FindFirstChild(k)
			if bodypart then
				local str = tostring(tbl[k.."Color"])
				bodypart.BrickColor = BrickColor.new(tonumber(str:sub(1,3))/255,tonumber(str:sub(4,6))/255,tonumber(str:sub(7,9))/255)
			end
		end
	end
	local faceid = tbl["Face"]
	if faceid then
		local decal = Instance.new("Decal",char.Head)
		decal.Texture = "rbxassetid://"..tostring(faceid)
	end
	for i,k in pairs (char:GetChildren()) do
		if k.ClassName == "ShirtGraphic" or k.ClassName == "Pants" or k.ClassName == "Shirt" then
			k:Destroy()
		end
	end
	local shirt = Instance.new("Shirt",char)
	local pants = Instance.new("Pants",char)
	shirt.ShirtTemplate = "rbxassetid://281868355"
	pants.PantsTemplate = "rbxassetid://281868754"
end]]

local function Get_District(plr)
	for i,k in pairs (_G.Tributes) do
		if k[1] == plr then
			return math.ceil(.5*i)
		end
	end
end

function chatted(msg,player)
	for a,b in pairs(game.Players:GetPlayers()) do
		if ((Find_Status(b.Name) and Find_Status(b.Name):lower()) ~= "alive") or Stage == "Entering Tubes" or Stage == "Reaping" then
			workspace.Remotes.Event:FireClient(b,"ChatEvent1",player,msg,Get_District(player.Name))
		end
	end
	for a,b in pairs(game.Players:GetPlayers()) do
		coroutine.resume(coroutine.create(function()
			if ((Find_Status(b.Name) and Find_Status(b.Name):lower()) ~= "alive") or Stage == "Entering Tubes" or Stage == "Reaping" then
				workspace.Remotes.Event:FireClient(b,"ChatEvent2",player,msg,Get_District(player.Name))
			end
		end))
	end
end

local function Get_Speed(plr,typ)
	--local char = Find_Tribute_Character(plr)
	--if not char then return 20 end
	local skill = _G.Character_Data[plr.Name] and _G.Character_Data[plr.Name].Speed or 50
	local walking = .1*skill + 15
	if typ:lower() == "sprint" then
		return 1.337*walking
	else
		return walking
	end
end

_G.gameChat = function(msg,computer)
	chatted(msg,computer)
end

coroutine.resume(coroutine.create(function()
	local pc = workspace:WaitForChild("PlayerChatted")
	pc.OnServerEvent:connect(function(plr,msg)
		if plr.Character then
			pcall(function()
			if plr.Character:FindFirstChild("Head") then
				game:GetService("Chat"):Chat(plr.Character.Head,msg,"Green")
			end
			end)
		end
		_G.gameChat(msg,plr)
	end)
end))

local function Find_Plr_Num(name)
	for i,k in pairs (_G.Tributes) do
		if k[1] == name then
			return i
		end
	end
end

local function Save_Data(plr)
	ds:SetAsync(tostring(plr.userId).."Data",Data[tostring(plr.userId)])
end

game.Players.PlayerAdded:connect(function(plr)
	plr.CharacterAdded:connect(function(char)
		wait()
		local function Destroy_If_Health_Script(k)
			if k.ClassName == "Script" or k.ClassName == "LocalScript" and string.find(k.Name:lower(),"health") then
				wait(.5)
				k:Destroy()
			end
		end
		char.ChildAdded:connect(function(c)
			Destroy_If_Health_Script(c)
		end)
		for i,k in pairs (char:GetChildren()) do
			Destroy_If_Health_Script(k)
		end
		if (Find_Status(plr.Name) and Find_Status(plr.Name):lower()) == "alive" then
			if Stage == "Arena Entry" then
				pcall(function()
					char:MoveTo(workspace.Pedestals["Pedestal"..tostring(plr.Tribute.Value)].Part.Position + Vector3.new(0,5,0))
				end)
				Activate_Survival({plr.Name})
			elseif Stage == "Entering Tubes" then
				pcall(function()
					char:MoveTo(Vector3.new(200*Find_Plr_Num(plr.Name)-200*12,666+5,0))
				end)
				Remove_Character_Appearence(char)
				Load_Custom_Character(plr)
				--Load_Character_Appearence(char,_G.Character_Data[Find_Tribute_Character(plr)])
				char.Humanoid.WalkSpeed = Get_Speed(plr,"Walk")
			else
				--char:Destroy()
				Instance.new("Folder",plr.PlayerGui).Name = "CharDestroyed"
			end
		else
			--char:Destroy()
			Instance.new("Folder",plr.PlayerGui).Name = "CharDestroyed"
		end
		if char then
			local bill = Instance.new("BillboardGui", char)
			bill.Active = false
			bill.Adornee = char:FindFirstChild("Head")
			bill.AlwaysOnTop = false
			bill.Enabled = true
			bill.Size = UDim2.new(1, 0, 1, 0)
			bill.StudsOffset = Vector3.new(-0.5, 3, 0)
			char:WaitForChild("Humanoid")
			local current = char.Humanoid.Health
			char.Humanoid.HealthChanged:connect(function()
				if char.Humanoid.Health - current <= -1 then
					local text = Instance.new("TextLabel", bill)
					text.BackgroundTransparency = 1
					text.Name = "ObtainHealth"
					text.Size = UDim2.new(2.25, 0, 2, 0)
					text.Font = "SourceSansBold"
					text.FontSize = "Size48"
					text.Text = tostring(math.ceil(100*(char.Humanoid.Health-current))*.01)
					text.TextColor3 = Color3.new(1, 0, 0)
					text.TextScaled = true
					text.TextStrokeColor3 = Color3.new(115 / 255, 0, 0)
					text.TextStrokeTransparency = 0
					text.TextWrapped = true
					coroutine.resume(coroutine.create(function()
						local t = 0
						while t <= 1 do
							local curt = wait()
							t = t + curt
							text.Position = text.Position - UDim2.new(0, 0, 30*curt*0.04, 0)
							text.TextTransparency = text.TextTransparency + 30*curt*0.04
							text.TextStrokeTransparency = text.TextStrokeTransparency + 30*curt*0.04
						end
					end))
				end
				current = char.Humanoid.Health
			end)
		end
		--wait(.337)
		--workspace.Remotes.Event:FireClient(plr,"Changed XP",Data[tostring(plr.userId)] and Data[tostring(plr.userId)].XP or 0)
	end)
	coroutine.resume(coroutine.create(function()
		local pc
		repeat
			wait(.5)
			pc = pcall(function()
				Equipped_Characters[tostring(plr.userId)] = ds:GetAsync(tostring(plr.userId).."Characters")
			end)
		until pc == true
		if Equipped_Characters[tostring(plr.userId)] == nil or type(Equipped_Characters[tostring(plr.userId)]) ~= "table" then
			Equipped_Characters[tostring(plr.userId)] = Default_Equipped_Characters
		end
		pc = nil
		repeat
			wait(.5)
			pc = pcall(function()
				Data[tostring(plr.userId)] = ds:GetAsync(tostring(plr.userId).."Data")
			end)
		until pc == true
		if Data[tostring(plr.userId)] == nil or type(Data[tostring(plr.userId)]) ~= "table" or Data[tostring(plr.userId)].Male or Data[tostring(plr.userId)].Female or Data[tostring(plr.userId)].Level then
			Data[tostring(plr.userId)] = Default_Data
		end
		for i,k in pairs (Default_Data) do
			if Data[tostring(plr.userId)][i] == nil then
				Data[tostring(plr.userId)][i] = k
			end
		end
		--[[for i,k in pairs (Data[tostring(plr.userId)]) do
			print(i,k)
		end]]
		workspace.Remotes.Event:FireClient(plr,"Changed XP",Data[tostring(plr.userId)].XP)
		while true and Data[tostring(plr.userId)] and Data[tostring(plr.userId)].SP do
			Data[tostring(plr.userId)].SP = Data[tostring(plr.userId)].SP+math.random(4)
			workspace.Remotes.Event:FireClient(plr,"Changed SP",Data[tostring(plr.userId)].SP)
			for i=1,5 do
				wait(.5)
			end
		end
	end))
	local trib = Instance.new("IntValue",plr)
	trib.Name = "Tribute"
	trib.Value = 0
	coroutine.resume(coroutine.create(function()
		local values = {
			{"Hunger",0,100,100},
			{"Thirst",0,100,100},
			{"Energy",0,100,100},
		}
		local fold = game.ServerStorage:WaitForChild("PlayerValues")
		local plrfold = Instance.new("Folder",fold)
		plrfold.Name = tostring(plr.userId)
		for i,k in pairs (values) do
			local val = Instance.new("DoubleConstrainedValue",plrfold)
			val.Name = k[1]
			val.MinValue = k[2]
			val.MaxValue = k[3]
			val.Value = k[4]
			val.Changed:connect(function(value)
				workspace.Remotes.Event:FireClient(plr,3,k[1],value,k[3])
			end)
			workspace.Remotes.Event:FireClient(plr,3,k[1],k[4],k[3])
			plr.CharacterAdded:connect(function()
				val.Value = k[4]
			end)
		end
	end))
	wait()
	plr:LoadCharacter()
	coroutine.resume(coroutine.create(function()
		while wait(60) and plr do
			pcall(function()
				Save_Data(plr)
				coroutine.resume(coroutine.create(function()
					local gui = Instance.new("ScreenGui",plr.PlayerGui)
					local t = Instance.new("TextLabel",gui)
					t.BackgroundTransparency = 1
					t.Text = "Data/Stats Saved"
					t.TextColor3 = Color3.new(0,1,0)
					t.TextScaled = true
					t.TextStrokeColor3 = Color3.new()
					t.TextStrokeTransparency = 0
					t.Font = Enum.Font.SourceSansBold
					t.Size = UDim2.new(.2,0,.075,0)
					for i=.775,.68,-.025/12 do
						t.Position = UDim2.new(.1,0,i,0)
						wait()
					end
					gui:Destroy()
				end))
			end)
		end
	end))
end)


local products = {
	["SP_30139622"] = 10000,
	["SP_30139586"] = 2500,
	["SP_30139570"] = 1000,
	["SP_30139546"] = 250,
	["D_30806888"] = 10,
	["D_30806894"] = 100,
	["D_30806910"] = 1000
}

local function get_plr_from_id(id)
	for i,k in pairs (game.Players:GetPlayers()) do
		if k.userId == id then
			return k
		end
	end
end

game:GetService("MarketplaceService").ProcessReceipt = function(info)
	if Data[tostring(info.PlayerId)] and products["SP_"..tostring(info.ProductId)] and Data[tostring(info.PlayerId)].SP then
		Data[tostring(info.PlayerId)].SP = Data[tostring(info.PlayerId)].SP + products["SP_"..tostring(info.ProductId)]
		return Enum.ProductPurchaseDecision.PurchaseGranted
	elseif Data[tostring(info.PlayerId)] and products["D_"..tostring(info.ProductId)] and Data[tostring(info.PlayerId)].D then
		Data[tostring(info.PlayerId)].D = Data[tostring(info.PlayerId)].D + products["D_"..tostring(info.ProductId)]
		pcall(function() workspace.Remotes.Event:FireClient(get_plr_from_id(info.PlayerId),"Donation Change",Data[tostring(info.PlayerId)].D) end)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	else
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

_G.Year = 0
_G.GamesOn = false
_G.GenerateArena = false
_G.Tributes = {}
_G.Day = 0
for i=1,24 do
	table.insert(_G.Tributes,{nil,"Dead"})
end

local function Get_Time_Alive(t)
	local h,m,s = tonumber(t:sub(1,2)),t:sub(4,5),t:sub(7,8)
	local hs,ms,ss = (_G.Day-2)*24+12+h,m,s
	return tostring(hs)..":"..ms..":"..ss
end

local function Show_Fallen()
	local clone = game.ServerStorage.Fallen:Clone()
	clone.Parent = workspace
	for i,k in pairs (clone:GetChildren()) do
		pcall(function()
			k.SurfaceGui.Script.Disabled = false
		end)
	end
end

local function Ragdoll(char)
	char.Archivable = true
	local corpse = char:Clone()
	corpse.Parent = workspace
	corpse.Name = "Corpse " .. char.Name
	corpse:FindFirstChild("HumanoidRootPart"):Destroy()
	for k, v in pairs(corpse:GetChildren()) do
		if v:IsA("Script") then
			v:Destroy()
		end
	end
	for k, v in pairs(corpse.Torso:GetChildren()) do
		v:Destroy()
	end
	
	local Character = corpse
	local Humanoid = Character.Humanoid
	local Torso = Character.Torso
	
	for k, v in pairs(Character:GetChildren()) do
		if v.Name == "FakeHead" then
			v:Destroy()
		end
	end
	
	--[[if not Character:FindFirstChild("Mutt") then
		Character.Head.Transparency = 1
		Character.Head.face.Transparency = 1
		local head2 = Character.Head:clone()
		head2.Parent = Character
		head2.Name = "FakeHead"
		head2.Transparency = 0
		head2.BrickColor = Character.Head.BrickColor
		local head2face = Character.Head.face.Texture
		head2.face.Texture = head2face
		local h2w = Instance.new("Weld")
		h2w.Parent = Character.Torso
		h2w.Part0 = h2w.Parent
		h2w.Part1 = head2
		h2w.C1 = CFrame.new(0,-1.5,0)
	end]]
	
	local function Join(type,p0,p1,c0,c1,nam)
		local w = Instance.new(type)
		w.Parent = p0 --game.JointsService
		w.Part0 = p0
		w.Part1 = p1
		w.C0 = c0
		w.C1 = c1
		w.Name = nam
		w.Changed:connect(function()
			w.Parent = nil
			Join(type, p0, p1, c0, c1, nam)
		end)
	end
	
	if Torso then
		local Head = Character:FindFirstChild("Head")
		if Head then
			local Neck = Instance.new("Weld")
			Neck.Name = "Neck"
			Neck.Part0 = Torso
			Neck.Part1 = Head
			Neck.C0 = CFrame.new(0, 1.5, 0)
			Neck.C1 = CFrame.new()
			Neck.Parent = Torso
		end
		local Limb = Character:FindFirstChild("Right Arm")
		if Limb then
			Limb.CFrame = Torso.CFrame * CFrame.new(1.5, 0, 0)
			Limb.CanCollide = true
			local Joint = Instance.new("Glue")
			Joint.Name = "RightShoulder"
			Joint.Part0 = Torso
			Joint.Part1 = Limb
			Joint.C0 = CFrame.new(1.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
			Joint.C1 = CFrame.new(-0, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
			Joint.Parent = Torso
			local B = Instance.new("Part")
			B.TopSurface = 0
			B.BottomSurface = 0
			B.formFactor = "Symmetric"
			B.Size = Vector3.new(1, 1, 1)
			B.Transparency = 1
			B.CFrame = Limb.CFrame * CFrame.new(0, -0.5, 0)
			B.Parent = Character
			Join("Weld", Limb, B, CFrame.new(0, -0.5, 0), CFrame.new(0, 0, 0), "MassWeld")
		end
		local Limb = Character:FindFirstChild("Left Arm")
		if Limb then
			Limb.CFrame = Torso.CFrame * CFrame.new(-1.5, 0, 0)
			Limb.CanCollide = true
			local Joint = Instance.new("Glue")
			Joint.Name = "LeftShoulder"
			Joint.Part0 = Torso
			Joint.Part1 = Limb
			Joint.C0 = CFrame.new(-1.5, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
			Joint.C1 = CFrame.new(0, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
			Joint.Parent = Torso
			local B = Instance.new("Part")
			B.TopSurface = 0
			B.BottomSurface = 0
			B.formFactor = "Symmetric"
			B.Size = Vector3.new(1, 1, 1)
			B.Transparency = 1
			B.CFrame = Limb.CFrame * CFrame.new(0, -0.5, 0)
			B.Parent = Character
			Join("Weld", Limb, B, CFrame.new(0, -0.5, 0), CFrame.new(0, 0, 0), "MassWeld")
		end
		local Limb = Character:FindFirstChild("Right Leg")
		if Limb then
			Limb.CFrame = Torso.CFrame * CFrame.new(0.5, -2, 0)
			Limb.CanCollide = true
			local Joint = Instance.new("Glue")
			Joint.Name = "RightHip"
			Joint.Part0 = Torso
			Joint.Part1 = Limb
			Joint.C0 = CFrame.new(0.5, -1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
			Joint.C1 = CFrame.new(0, 1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0)
			Joint.Parent = Torso
			local B = Instance.new("Part")
			B.TopSurface = 0
			B.BottomSurface = 0
			B.formFactor = "Symmetric"
			B.Size = Vector3.new(1, 1, 1)
			B.Transparency = 1
			B.CFrame = Limb.CFrame * CFrame.new(0, -0.5, 0)
			B.Parent = Character
			Join("Weld", Limb, B, CFrame.new(0, -0.5, 0), CFrame.new(0, 0, 0), "MassWeld")
		end
		local Limb = Character:FindFirstChild("Left Leg")
		if Limb then
			Limb.CFrame = Torso.CFrame * CFrame.new(-0.5, -2, 0)
			Limb.CanCollide = true
			local Joint = Instance.new("Glue")
			Joint.Name = "LeftHip"
			Joint.Part0 = Torso
			Joint.Part1 = Limb
			Joint.C0 = CFrame.new(-0.5, -1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
			Joint.C1 = CFrame.new(-0, 1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0)
			Joint.Parent = Torso
			local B = Instance.new("Part")
			B.TopSurface = 0
			B.BottomSurface = 0
			B.formFactor = "Symmetric"
			B.Size = Vector3.new(1, 1, 1)
			B.Transparency = 1
			B.CFrame = Limb.CFrame * CFrame.new(0, -0.5, 0)
			B.Parent = Character
			Join("Weld", Limb, B, CFrame.new(0, -0.5, 0), CFrame.new(0, 0, 0), "MassWeld")
		end
	end
	char:Destroy()
	for i,k in pairs (Character:FindFirstChild("Head") and Character.Head:GetChildren() or {}) do
		if k.ClassName == "BillboardGui" then
			k:Destroy()
		end
	end
end

workspace.ChildAdded:connect(function(c)
	local p = game.Players:GetPlayerFromCharacter(c)
	if p then
		c:WaitForChild("Humanoid").Died:connect(function()
			local center = c:FindFirstChild("Torso") and c.Torso.Position or Vector3.new()
			coroutine.resume(coroutine.create(function()
				for i,k in pairs (c:GetChildren()) do
					if k.ClassName == "Tool" then
						k.Parent = workspace
					end
				end
				for i,k in pairs (p.Backpack:GetChildren()) do
					if k.ClassName == "Tool" then
						local weap = game.ServerStorage["Lagless Weapons"]:FindFirstChild(k.Name)
						if weap then
							weap = weap:Clone()
							weap.PrimaryPart = weap:FindFirstChild("Handle")
							weap:SetPrimaryPartCFrame(CFrame.new(center+Vector3.new(0,math.random(1,20),0)))
							pcall(function()
								Connect_Touch_Tool(weap,false)
							end)
							Weld(weap)
							weap.Parent = workspace
							wait()
							k:Destroy()
						else
							k.Parent = workspace
							k.Handle.CFrame = CFrame.new(center+Vector3.new(0,math.random(1,20),0))
						end
					end
				end
			end))
			for i=1,#_G.Tributes do
				if p.Name == _G.Tributes[i][1] and _G.Tributes[i][2]:lower() == "alive" then
					local tbl = {p.Name}
					if c.Humanoid:FindFirstChild("creator") then
						tbl[2] = c.Humanoid.creator.Value
						local function find_plr()
							for i,k in pairs (game.Players:GetPlayers()) do
								if tbl[2] == k.Name then
									return k
								end
							end
						end
						local pl = find_plr()
						pcall(function()
							Data[tostring(pl.userId)].Kills = Data[tostring(pl.userId)].Kills + 1
						end)
						pcall(function()
							_G.Games_Player_Data[tbl[2]].Kills = _G.Games_Player_Data[tbl[2]].Kills + 1
						end)
						pcall(function()
							Data[tostring(pl.userId)].XP = Data[tostring(pl.userId)].XP + XP_Per_Kill
							workspace.Remotes.Event:FireClient(pl,"Awarded XP",XP_Per_Kill,"Killed a Tribute!")
							workspace.Remotes.Event:FireClient(pl,"Changed XP",Data[tostring(pl.userId)].XP)
							coroutine.resume(coroutine.create(function() ps:AwardPoints(pl.userId,XP_Per_Kill) end))
							workspace.Remotes.Event:FireClient(pl,"Level Change",returnFromXP(Data[tostring(pl.userId)].XP))
						end)
						pcall(function()
							_G.Games_Player_Data[tbl[2]].XP = _G.Games_Player_Data[tbl[2]].XP + XP_Per_Kill
						end)
						if c.Humanoid:FindFirstChild("creator") and c.Humanoid.creator:FindFirstChild("Cause") then
							tbl[3] = c.Humanoid.creator.Cause.Value
						end
						local num = nil
						--[[
						for i = 1,#currentData do
							if currentData[i][1] == p.Name then
								num = i
								break
							end
							table.insert(currentData,{p.Name,0,0,0})
							num = #currentData
						end
						currentData[num][2] = currentData[num][2] + XP_Per_Kill
						currentData[num][3] = currentData[num][3] + 1
						currentData[num][4] = currentData[num][4] + math.floor(XP_Per_Kill/3.5)
						--]]
					end
					table.insert(Games_Data,tbl)
					pcall(function()
						_G.Games_Player_Data[p.Name].Time = Get_Time_Alive(game.Lighting.TimeOfDay)
					end)
					coroutine.resume(coroutine.create(function()
						Ragdoll(c)
					end))
					_G.Tributes[i][2] = "Dead"
					Tribute_Died()
					table.insert(_G.Dead_Tributes_To_Show,{math.ceil(.5*i),_G.Tributes[i][1],(i%2) == 0 and "Female" or "Male"})
				end
			end
			wait(5)
			if Stage ~= "Overview" then
				p:LoadCharacter()
			end
		end)
	end
end)

local function Eaten(plr,h,t,e,health)
	local fold = game.ServerStorage.PlayerValues:FindFirstChild(tostring(plr.userId))
	if fold then
		fold.Hunger.Value = fold.Hunger.Value + h
		fold.Thirst.Value = fold.Thirst.Value + t
		fold.Energy.Value = fold.Energy.Value + e
	end
	if health and health ~= 0 and plr.Character and plr.Character:FindFirstChild("Humanoid") then
		plr.Character.Humanoid.Health = plr.Character.Humanoid.Health + health
	end
end

local function untag_Humanoid(hum)
	if hum:FindFirstChild("creator") then
		hum.creator:Destroy()
	end
end

local function tag_Humanoid(hum,plr,weap)
	untag_Humanoid(hum)
	local creator = Instance.new("StringValue",hum)
	creator.Name = "creator"
	creator.Value = type(plr) == "string" and plr or plr.Name
	if weap then
		local cause = Instance.new("StringValue",creator)
		cause.Name = "Cause"
		cause.Value = weap
	end
end

local function Play_Sound(part,id,volume,pitch,length)
	local s = Instance.new("Sound",part)
	s.Volume = volume or .5
	s.Pitch = pitch or 1
	s.SoundId = "rbxassetid://"..tostring(id)
	s:Play()
	coroutine.resume(coroutine.create(function()
		for i=1,(length or 10) do wait(.5) end
		s:Destroy()
	end))
end

local function play_Animation(hum,animationID,speed)
	if hum == nil then return end
	if speed == nil then speed = 1 end
	local anim = Instance.new("Animation")
	anim.AnimationId = "http://www.roblox.com/Asset?ID="..tostring(animationID)
	local load = hum:LoadAnimation(anim)
	load:Play(.1,1,speed)
end

local function swing_Weapon(plr,char,partkillers,damage,animationID,weapon)
	local damaged = false
	pcall(function() for i,k in pairs (partkillers) do
		local function alive()
			for i,k in pairs (Get_Tributes("Alive")) do
				if k == plr.Name then
					return true
				end
			end
		end
		coroutine.resume(coroutine.create(function()
			local c = k.Touched:connect(function(h)
				if Stage ~= "Games" then return end
				if not alive() then return end
				if damaged then return end
				local hum =  h.Parent:FindFirstChild("Humanoid")
				if hum and hum ~= char.Humanoid then
					damaged = true
					local creator = tag_Humanoid(hum,plr,weapon)
					hum:TakeDamage(damage)
					if hum.Health > 0 then
						coroutine.resume(coroutine.create(function()
							wait(.2)
							--if creator and creator.Parent then
								untag_Humanoid(hum)
							--end
						end))
					end
				elseif Get_Ancestor(h,"Mutt") then
					local model = Get_Ancestor(h,"Mutt")
					if model:FindFirstChild("Health") then
						damaged = true
						model.Health.Value = model.Health.Value - damage
						coroutine.resume(coroutine.create(function()
							local bill = Instance.new("BillboardGui", model.Wolf)
							bill.Active = false
							bill.Adornee = model.Wolf.Head
							bill.AlwaysOnTop = false
							bill.Enabled = true
							bill.Size = UDim2.new(1, 0, 1, 0)
							bill.StudsOffset = Vector3.new(-0.5, 3, 0)
							local text = Instance.new("TextLabel", bill)
							text.BackgroundTransparency = 1
							text.Name = "ObtainHealth"
							text.Size = UDim2.new(2.25, 0, 2, 0)
							text.Font = "SourceSansBold"
							text.FontSize = "Size48"
							text.Text = "-"..tostring(math.ceil(100*damage)*.01)
							text.TextColor3 = Color3.new(1, 0, 0)
							text.TextScaled = true
							text.TextStrokeColor3 = Color3.new(115 / 255, 0, 0)
							text.TextStrokeTransparency = 0
							text.TextWrapped = true
							coroutine.resume(coroutine.create(function()
								local t = 0
								while t <= 1 do
									local curt = wait()
									t = t + curt
									text.Position = text.Position - UDim2.new(0, 0, 30*curt*0.04, 0)
									text.TextTransparency = text.TextTransparency + 30*curt*0.04
									text.TextStrokeTransparency = text.TextStrokeTransparency + 30*curt*0.04
								end
								bill:Destroy()
							end))
						end))
						if model.Health.Value == 0 then
							model:Destroy()
							pcall(function()
								Data[tostring(plr.userId)].XP = Data[tostring(plr.userId)].XP + XP_Per_Wolf_Kill
								workspace.Remotes.Event:FireClient(plr,"Awarded XP",XP_Per_Wolf_Kill,"Killing a Wolf Mutt")
								workspace.Remotes.Event:FireClient(plr,"Changed XP",Data[tostring(plr.userId)].XP)
								coroutine.resume(coroutine.create(function() ps:AwardPoints(plr.userId,XP_Per_Wolf_Kill) end))
								workspace.Remotes.Event:FireClient(plr,"Level Change",returnFromXP(Data[tostring(plr.userId)].XP))
								_G.Games_Player_Data[plr.Name].XP = _G.Games_Player_Data[plr.Name].XP + XP_Per_Wolf_Kill
							end)
						end
					end
				end
			end)
			for e=1,3 do wait(.6) end
			c:disconnect()
		end))
	end end)
	pcall(function()
		play_Animation(char.Humanoid,animationID)
	end)
end

local function shoot_Arrow(plr,char,direction,handle,damage,animationID,Hit_Sound,meshid,txtid)
	local done = false
	coroutine.resume(coroutine.create(play_Animation,char:FindFirstChild("Humanoid"),animationID))
	local arrow,mesh = Instance.new("Part"),Instance.new("SpecialMesh")
	arrow.Name = "Arrow"
	arrow.CFrame = CFrame.new(handle.Position,handle.Position+direction)
	arrow.Position = handle.Position
	arrow.Size = Vector3.new(.2,.2,.5)
	arrow.Anchored = false
	arrow.CanCollide = false
	arrow.Locked = true
	mesh.MeshId = "http://www.roblox.com/asset/?id="..tostring(meshid or 220376619)
	mesh.Scale = Vector3.new(.7,.7,.7)
	mesh.TextureId = "http://www.roblox.com/asset/?id="..tostring(txtid or 220376769)
	mesh.Parent = arrow
	local function alive()
		for i,k in pairs (Get_Tributes("Alive")) do
			if k == plr.Name then
				return true
			end
		end
	end
	arrow.Touched:connect(function(h)
		if Stage ~= "Games" then return end
		if not alive() then return end
		if done then return end
		local old_cframe = arrow.CFrame
		if h.Parent and h.ClassName == "Part" and h.CanCollide == true and done == false then
			local p = h.Parent.ClassName == "Hat" and game.Players:GetPlayerFromCharacter(h.Parent.Parent) or game.Players:GetPlayerFromCharacter(h.Parent)
			if (h.Parent.ClassName == "Hat" and h.Parent.Parent or h.Parent) ~= char and (h.CanCollide or h.Parent:FindFirstChild("Humanoid")) and not h:IsDescendantOf(handle.Parent) then
				arrow.Velocity = Vector3.new(0,0,0)
				arrow.CFrame = old_cframe
				done = true
				if h.Name == "Head" then
					damage = damage*1.5
				end
				if p then
					pcall(function()
						tag_Humanoid(p.Character.Humanoid,plr.Name,"Bow")
						coroutine.resume(coroutine.create(function()
							wait(.337)
							untag_Humanoid(p.Character.Humanoid)
						end))
						p.Character.Humanoid:TakeDamage(damage)
						coroutine.resume(coroutine.create(function()
							Play_Sound(arrow,Hit_Sound,.8,math.random(80,120)*.01,5)
						end))
						local w = Instance.new("Weld",arrow)
						w.Part0 = arrow
						w.Part1 = p.Character.Torso
						if (w.Part1.Position-old_cframe.p).magnitude > 3 then
							old_cframe = w.Part1.CFrame * CFrame.fromEulerAnglesXYZ(0,math.pi,0)
						end
						w.C0 = old_cframe:inverse()*CFrame.new(old_cframe.p)
						w.C1 = w.Part1.CFrame:inverse()*CFrame.new(old_cframe.p)
					end)
				elseif h.Parent:FindFirstChild("Humanoid") then
					pcall(function()
						tag_Humanoid(h.Parent.Humanoid,plr.Name,"Bow")
						coroutine.resume(coroutine.create(function()
							wait(.337)
							untag_Humanoid(h.Parent.Humanoid)
						end))
						h.Parent.Humanoid:TakeDamage(damage)
						coroutine.resume(coroutine.create(function()
							Play_Sound(arrow,Hit_Sound,.8,math.random(80,120)*.01,5)
						end))
						local w = Instance.new("Weld",arrow)
						w.Part0 = arrow
						w.Part1 = h.Parent.Torso
						if (w.Part1.Position-old_cframe.p).magnitude > 3 then
							old_cframe = w.Part1.CFrame * CFrame.fromEulerAnglesXYZ(0,math.pi,0)
						end
						w.C0 = old_cframe:inverse()*CFrame.new(old_cframe.p)
						w.C1 = w.Part1.CFrame:inverse()*CFrame.new(old_cframe.p)
					end)
				elseif Get_Ancestor(h,"Mutt") then
					local model = Get_Ancestor(h,"Mutt")
					if model:FindFirstChild("Health") then
						done = true
						model.Health.Value = model.Health.Value - damage
						coroutine.resume(coroutine.create(function()
							local bill = Instance.new("BillboardGui", model.Wolf)
							bill.Active = false
							bill.Adornee = model.Wolf.Head
							bill.AlwaysOnTop = false
							bill.Enabled = true
							bill.Size = UDim2.new(1, 0, 1, 0)
							bill.StudsOffset = Vector3.new(-0.5, 3, 0)
							local text = Instance.new("TextLabel", bill)
							text.BackgroundTransparency = 1
							text.Name = "ObtainHealth"
							text.Size = UDim2.new(2.25, 0, 2, 0)
							text.Font = "SourceSansBold"
							text.FontSize = "Size48"
							text.Text = "-"..tostring(math.ceil(100*damage)*.01)
							text.TextColor3 = Color3.new(1, 0, 0)
							text.TextScaled = true
							text.TextStrokeColor3 = Color3.new(115 / 255, 0, 0)
							text.TextStrokeTransparency = 0
							text.TextWrapped = true
							coroutine.resume(coroutine.create(function()
								local t = 0
								while t <= 1 do
									local curt = wait()
									t = t + curt
									text.Position = text.Position - UDim2.new(0, 0, 30*curt*0.04, 0)
									text.TextTransparency = text.TextTransparency + 30*curt*0.04
									text.TextStrokeTransparency = text.TextStrokeTransparency + 30*curt*0.04
								end
								bill:Destroy()
							end))
						end))
						if model.Health.Value == 0 then
							model:Destroy()
							pcall(function()
								Data[tostring(plr.userId)].XP = Data[tostring(plr.userId)].XP + XP_Per_Wolf_Kill
								workspace.Remotes.Event:FireClient(plr,"Awarded XP",XP_Per_Wolf_Kill,"Killing a Wolf Mutt")
								workspace.Remotes.Event:FireClient(plr,"Changed XP",Data[tostring(plr.userId)].XP)
								coroutine.resume(coroutine.create(function() ps:AwardPoints(plr.userId,XP_Per_Wolf_Kill) end))
								workspace.Remotes.Event:FireClient(plr,"Level Change",returnFromXP(Data[tostring(plr.userId)].XP))
								_G.Games_Player_Data[plr.Name].XP = _G.Games_Player_Data[plr.Name].XP + XP_Per_Wolf_Kill
							end)
						end
					end
					arrow:Destroy()
				else
					arrow.Anchored = true
					arrow.CFrame = old_cframe
				end
			end
		end
	end)
	arrow.Velocity = direction
	arrow.Parent = workspace
	coroutine.resume(coroutine.create(function()
		while wait() and not done and arrow do
			local ray
			arrow.CFrame = CFrame.new(arrow.Position,arrow.Position+arrow.Velocity)
		end
	end))
	coroutine.resume(coroutine.create(function()
		for i=1,25 do
			wait(.9)
		end
		if arrow then
			arrow:Destroy()
		end
	end))
end

local sprinting = {}

local function Change_Speed(plr,typ)
	local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
	if not hum then return end
	--local char = Find_Tribute_Character(plr)
	local skill = _G.Character_Data[plr.Name] and _G.Character_Data[plr.Name].Stamina or 50
	skill = math.abs(skill - 101)
	local data = game.ServerStorage.PlayerValues:WaitForChild(tostring(plr.userId))
	if data.Energy.Value >= 10 or typ:lower() ~= "sprint" then
		hum.WalkSpeed = Get_Speed(plr,typ)
		sprinting[plr.Name] = typ:lower() == "sprint" and true or nil
	end
	if typ:lower() == "sprint" then
		while sprinting[plr.Name] and data.Energy.Value >= 5 do
			data.Energy.Value = data.Energy.Value - (.008*skill+.2)
			wait()
		end
		hum.WalkSpeed = Get_Speed(plr,"Walk")
	end
end

local Players_In_Tube = {}

local function Explode_If_Cheating(char,ped)
	repeat
		pcall(function()
			--if char:FindFirstChild("Torso") == nil then Explode_Tribute(game.
			if (Vector2.new(char.Torso.Position.x,char.Torso.Position.z)-Vector2.new(ped.PrimaryPart.Position.x,ped.PrimaryPart.Position.z)).magnitude > 4.82 then
				Explode_Tribute(game.Players:GetPlayerFromCharacter(char).Name)
			end
		end)
		wait()
	until Stage == "Games"
	--Change_Speed(game.Players:GetPlayerFromCharacter(char),"Walk")
end

local function Move_Char(plr)
	if plr == nil then return end
	num = Find_Plr_Num(plr.Name)
	if num > 24 then return end
	if num <= 0 then return end
	local char = plr.Character
	char:MoveTo(workspace.Pedestals["Pedestal"..tostring(num)].PrimaryPart.Position + Vector3.new(0,5,0))
	char.Humanoid.WalkSpeed = 0
	table.insert(Players_In_Tube,plr.Name)
	coroutine.resume(coroutine.create(function()
		Explode_If_Cheating(char,workspace.Pedestals["Pedestal"..tostring(num)])
	end))
	Data[tostring(plr.userId)].XP = Data[tostring(plr.userId)].XP + XP_Per_Games
	workspace.Remotes.Event:FireClient(plr,"Awarded XP",XP_Per_Games,"Playing in the Games.")
	workspace.Remotes.Event:FireClient(plr,"Changed XP",Data[tostring(plr.userId)].XP)
	coroutine.resume(coroutine.create(function() ps:AwardPoints(plr.userId,XP_Per_Games) end))
	workspace.Remotes.Event:FireClient(plr,"Level Change",returnFromXP(Data[tostring(plr.userId)].XP))
	_G.Games_Player_Data[plr.Name].XP = _G.Games_Player_Data[plr.Name].XP + XP_Per_Games
	coroutine.resume(coroutine.create(function()
		for i=1,25 do
			coroutine.resume(coroutine.create(function()
				local gui = Instance.new("ScreenGui",plr.PlayerGui)
				local t = Instance.new("TextLabel",gui)
				t.BackgroundTransparency = 1
				t.Text = "Don't Step off your Pedestal!!!"
				t.TextColor3 = Color3.new(1,0,0)
				t.TextScaled = true
				t.TextStrokeColor3 = Color3.new()
				t.TextStrokeTransparency = 0
				t.Font = Enum.Font.SourceSansBold
				t.Size = UDim2.new(.3,0,.075,0)
				for y=.775,.6,-.025/8 do
					t.Position = UDim2.new(.05,0,y,0)
					wait()
				end
				gui:Destroy()
			end))
			for e=1,2 do wait(.5) end
		end
	end))
	Wait(5)
	if Data[tostring(plr.userId)].XP > 1767 then --more than prestige 1
		Change_Speed(plr,"Walk")
	else
		coroutine.resume(coroutine.create(function()
			repeat wait() until Stage == "Games"
			Change_Speed(plr,"Walk")
		end))
	end
end

local function Include_Vote(i)
	if i == nil then return end
	_G.Votes[i] = _G.Votes[i] + 1
end

local function Eligible_Sponsor(plr,name,item,Cost)
	if not(Data[tostring(plr.userId)] and Data[tostring(plr.userId)].SP) then return end
	if (Data[tostring(plr.userId)].SP < Cost) then return end
	local trib = game.Players:FindFirstChild(name)
	if trib == nil then return end
	Data[tostring(plr.UserId)].SP = Data[tostring(plr.UserId)].SP - Cost
	Sponser_Tribute(trib,item)
end

game.Workspace.ReturnLevels.OnServerEvent:connect(function(plr)
	pcall(function()
		local tab = {}
		for a,b in pairs(game.Players:GetChildren()) do
			local number = Data[tostring(b.userId)] and Data[tostring(b.userId)].XP
			if not number then number = 0 end
			local Prestige,Level,XP = returnFromXP(number)
			table.insert(tab,{b.Name,getPrestige(Prestige)})
		end
		game.Workspace.ReturnLevels:FireClient(plr,tab)
	end)
end)

local letter_key = "j"

function bits(n)
    local t={}
    while n>0 do
        local rest=n%2
        table.insert(t,1,rest)
        n=(n-rest)/2
    end
	return t
end

local t_key = bits(string.byte(letter_key))
if #t_key < 8 then repeat table.insert(t_key,1,0) until #t_key == 8 end
local key_now = {0,0,0,0,0,0,0,0}

local colors = {
	[0] = BrickColor.new("Fossil"),
	[1] = BrickColor.new("New Yeller")
}

local function Check_Key()
	for i=1,8 do
		if t_key[i] ~= key_now[i] then
			return
		end
	end
	return true
end

local function Reset_Key()
	key_now = {0,0,0,0,0,0,0,0}
	workspace.Lobby.DoorFar.Transparency = 0
	for i=1,8 do
		local model = workspace.Lobby:FindFirstChild("CapitolSymbol"..tostring(i))
		if model then
			for _,k in pairs (model:GetChildren()) do
				if k.ClassName == "UnionOperation" or k.ClassName == "Part" then
					k.BrickColor = colors[key_now[i]]
				end
			end
		end
	end
end

local function Capitol_Symbol_Change(n)
	key_now[n] = key_now[n] == 0 and 1 or 0
	local model = workspace.Lobby:FindFirstChild("CapitolSymbol"..tostring(n))
	if model then
		for i,k in pairs (model:GetChildren()) do
			if k.ClassName == "UnionOperation" or k.ClassName == "Part" then
				k.BrickColor = colors[key_now[n]]
			end
		end
	end
	if Check_Key() then
		workspace.Lobby.DoorFar.Transparency = .5
		wait(20)
		if Check_Key() then
			Reset_Key()
		end
	else
		workspace.Lobby.DoorFar.Transparency = 0
	end
end

local function Give_Easter_Egg(pl,egg)
	if egg == "Mockingjay" then
		local id = 336714860
		for i,k in pairs (Data[tostring(pl.userId)].Badges) do
			if id == k then
				return
			end
		end
		if id > 0 then table.insert(Data[tostring(pl.userId)].Badges,id) end
		Data[tostring(pl.userId)].XP = Data[tostring(pl.userId)].XP + 1000
		workspace.Remotes.Event:FireClient(pl,"Awarded XP",1000,"Discovering the Egg of the Mockingjay")
		workspace.Remotes.Event:FireClient(pl,"Changed XP",Data[tostring(pl.userId)].XP)
		coroutine.resume(coroutine.create(function() ps:AwardPoints(pl.userId,1000) end))
		workspace.Remotes.Event:FireClient(pl,"Level Change",returnFromXP(Data[tostring(pl.userId)].XP))
	end
end

workspace.Remotes.Event.OnServerEvent:connect(function(plr,kind,...)
	if kind == 1 then
		Eaten(plr,...)
	elseif kind == "Swing" then
		pcall(swing_Weapon,plr,...)
	elseif kind == "Shoot" then
		pcall(shoot_Arrow,plr,...)
	elseif kind == "Play Animation" then
		play_Animation(...)
	elseif kind == "Play Sound" then
		Play_Sound(...)
	elseif kind == "Change Speed" then
		Change_Speed(plr,...)
	elseif kind == "Move Char" then
		Move_Char(plr,...)
	elseif kind == "Include Vote" then
		Include_Vote(...)
	elseif kind == "Sponsor Tribute" then
		Eligible_Sponsor(plr,...)
	elseif kind == "Capitol Symbol Change" then
		Capitol_Symbol_Change(...)
	elseif kind == "Give Easter Egg" then
		Give_Easter_Egg(plr,...)
	end
end)

--[[local function Find_Character_Pic(char)
	if _G.Character_Data[char] and _G.Character_Data[char].PicID then
		return "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(_G.Character_Data[char].PicID)
	else
		return ""
	end
end]]

local function Find_Skill(plr,item)
	--local char = Find_Tribute_Character(plr)
	return _G.Character_Data[plr.Name] and _G.Character_Data[plr.Name][item] or 50
end

local classtbl = {}
coroutine.resume(coroutine.create(function()
	local async = game:GetService("DataStoreService"):GetDataStore("Data-Released"):GetAsync("Customization")
	if async and async.Classes and type(async.Classes) == "table" then
		for i,k in pairs (async.Classes) do
			classtbl[tostring(k[1])] = game:GetService("MarketplaceService"):GetProductInfo(k[1])
			Get_Online_Item(k[1])
		end
	end
end))

local function Get_Book_Data()
	local ret = {}
	for i=1,#_G.Tributes do
		local k = _G.Tributes[i]
		if k[1] then
			ret[i] = {Name = k[1],Gender = find_Gender(k[1])}
			ret[i].CharacterData = _G.Character_Data[k[1]]
			ret[i].CharacterData.Class = Find_Tribute_Class(k[1])
		end
	end
	return ret
end

local function Get_Item_Data()
	local ret = {}
	for i,k in pairs (game.ServerStorage.Supplies:GetChildren()) do
		for e,r in pairs (k:GetChildren()) do
			pcall(function()
				ret[r.Name] = r.TextureId
			end)
		end
	end
	return ret
end

local function Get_Day()
	return _G.Day
end

local function Activate_Life_in_Arena() --trees give food, tracker jackers, etc.
	coroutine.resume(coroutine.create(function() --fruit
		for i,k in pairs (workspace:GetChildren()) do
			if k.Name == "TreeFruit" and k.ClassName == "Model" then
				k:Destroy()
			end
		end
		local fruit_model = Instance.new("Model",workspace)
		fruit_model.Name = "TreeFruit"
		repeat
			local n = math.random(math.random(3)*_G.Day)
			if n <= 2 then
				if workspace:FindFirstChild("TreeFruit") == nil then
					fruit_model = Instance.new("Model",workspace)
					fruit_model.Name = "TreeFruit"
				end
				pcall(function()
					local fruits = game.ServerStorage.Supplies.Fruit:GetChildren()
					local fruit = fruits[math.random(#fruits)]:Clone()
					local ang = math.random(360)
					local trees = workspace.Trees:GetChildren()
					local tree = trees[math.random(#trees)]
					local ray = Ray.new(tree.PrimaryPart.Position+Vector3.new(math.cos(math.rad(ang))*7,0,math.sin(math.rad(ang))*7),Vector3.new(0,-137,0))
					local part,pos = workspace:FindPartOnRay(ray)
					fruit.Handle.CFrame = CFrame.new(pos)
					fruit.Parent = fruit_model
				end)
			end
			wait(.9)
		until Stage ~= "Games"
	end))
end

local con = {
	{"00", {0, 0, 0}, 1900, {60, 60, 60}},
	{"01", {0, 0, 0}, 1900, {60, 60, 60}},
	{"02", {10, 10, 0}, 2000, {75, 75, 75}},
	{"03", {30, 30, 30}, 2000, {75, 75, 75}},
	{"04", {60, 40, 0}, 2000, {150, 120, 0}},
	{"05", {90, 60, 0}, 2200, {155, 130, 0}},
	{"06", {100, 80, 0}, 2300, {151, 189, 189}},
	{"07", {191, 229, 229}, 2700, {150,150,150}},
	{"08", {191, 229, 229}, 3000, {150,150,150}},
	{"09", {191, 229, 229}, 3200, {175,175,175}},
	{"10", {191, 229, 229}, 3500, {175,175,175}},
	{"11", {191, 229, 229}, 3500, {175,175,175}},
	{"12", {191, 229, 229}, 3500, {175,175,175}},
	{"13", {191, 229, 229}, 3200, {175,175,175}},
	{"14", {191, 229, 229}, 3100, {175,175,175}},
	{"15", {191, 229, 229}, 3000, {175,175,175}},
	{"16", {191, 229, 229}, 2900, {175,175,175}},
	{"17", {191, 229, 229}, 2750, {175,175,175}},
	{"18", {90, 40, 0}, 2400, {150, 110, 0}},
	{"19", {61, 34, 0}, 2200, {130, 100, 0}},
	{"20", {0,0,0}, 2000, {75, 75, 75}},
	{"21", {0,0,0}, 2000, {75, 75, 75}},
	{"22", {0,0,0}, 2000, {75, 75, 75}},
	{"23", {0,0,0}, 1900, {60, 60, 60}},
	{"24", {0,0,0}, 1900, {60, 60, 60}}
}

local function Change_Fog()
	for k, v in pairs(con) do
		if string.sub(game.Lighting.TimeOfDay, 1, 2) == v[1] then
			local post = k - 1
			if post == 0 then post = 23 end
			post = con[post]	
			local endoar, endoag, endoab, oar, oag, oab = v[4][1], v[4][2], v[4][3], post[4][1], post[4][2], post[4][3]
			local endfr, endfg, endfb, fr, fg, fb = v[2][1], v[2][2], v[2][3], post[2][1], post[2][2], post[2][3]
			local endfe, fe = v[3], post[3]	
			local time = (tonumber(string.sub(game.Lighting.TimeOfDay, 4, 5) * 60) + tonumber(string.sub(game.Lighting.TimeOfDay, 7, 8))) / 3600	
			local coar, coag, coab = (oar - ((oar - endoar) * time)), (oag - ((oag - endoag) * time)), (oab - ((oab - endoab) * time))
			local cfr, cfg, cfb = (fr - ((fr - endfr) * time)), (fg - ((fg - endfg) * time)), (fb - ((fb - endfb) * time))
			local cfe = (fe - ((fe - endfe) * time))
			game.Lighting.OutdoorAmbient = _G.Disaster == "Rain" and Color3.new(75/255,75/255,75/255) or Color3.new(coar / 255, coag / 255, coab / 255)
			game.Lighting.FogColor = _G.Disaster == "Rain" and Color3.new(.2,.2,.2) or Color3.new(cfr / 255, cfg / 255, cfb / 255)
			game.Lighting.FogEnd = _G.Disaster == "Rain" and 150 or cfe
		end
	end
end

local function Pay_SP(plr,n)
	if Data[tostring(plr.userId)].SP >= n then
		Data[tostring(plr.userId)].SP = Data[tostring(plr.userId)].SP - n
		return true
	else
		return
	end
end


function workspace.Remotes.Function.OnServerInvoke(plr,kind,...)
	if kind == "Find Character Pic" then
		--return Find_Character_Pic(...)
	elseif kind == "Find Skill" then
		return Find_Skill(plr,...)
	elseif kind == "Get Tributes" then
		return Get_Tributes(...)
	elseif kind == "Get Data" then
		return Data[tostring(plr.userId)]
	elseif kind == "Get All Data" then
		return Data
	elseif kind == "Get Class Data" then
		return classtbl
	elseif kind == "Get Book Data" then
		return Get_Book_Data()
	elseif kind == "Get Item Data" then
		return Get_Item_Data()
	elseif kind == "Get Day" then
		return Get_Day()
	elseif kind == "Pay SP" then
		return Pay_SP(plr,...)
	elseif kind == "Get Prestige" then
		return returnFromXP(Data[tostring(plr.userId)].XP)
	end
end

local function Find_Player_Pic(plr)
	if plr.userId <= 0 then
		return "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=ROBLOX"
	end
	return "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..plr.Name
end

wait(2)

local function Activate_Time()
	local tim = game.Lighting:GetMinutesAfterMidnight()
	repeat
		local t = wait()
		game.Lighting:SetMinutesAfterMidnight(game.Lighting:GetMinutesAfterMidnight() + t*0.25*22.5)
		Change_Fog()
		if game.Lighting:GetMinutesAfterMidnight() < tim then
			_G.Day = _G.Day + 1
			workspace.Remotes.Event:FireAllClients("Day Changed",_G.Day)
			coroutine.resume(coroutine.create(Show_Fallen))
			local tribs = Get_Tributes("Alive")
			for i,k in pairs (tribs) do
				local pl = game.Players:FindFirstChild(k)
				if pl then
					local added = (_G.Day - 2)*XP_Per_Day.Per_Day + XP_Per_Day.Starting
					Data[tostring(pl.userId)].XP = Data[tostring(pl.userId)].XP + added
					workspace.Remotes.Event:FireClient(pl,"Awarded XP",added,"Surviving Day "..tostring(_G.Day - 1))
					workspace.Remotes.Event:FireClient(pl,"Changed XP",Data[tostring(pl.userId)].XP)
					coroutine.resume(coroutine.create(function() ps:AwardPoints(pl.userId,added) end))
					workspace.Remotes.Event:FireClient(pl,"Level Change",returnFromXP(Data[tostring(pl.userId)].XP))
					_G.Games_Player_Data[pl.Name].XP = _G.Games_Player_Data[pl.Name].XP + added
				end
			end
			--coroutine.resume(coroutine.create(function()
				local voting = pcall(function() local tbl = {}
				tbl.Title = "Attention Gamemakers, Vote for a Disaster. Click To Vote."
				tbl.Options = {}
				local distbl = {}
				for e,r in pairs (Disaster_Table) do
					distbl[e] = r
				end
				local num = #distbl
				for i=1,3 do
					local rand = math.random(#distbl)
					tbl.Options[i] = distbl[rand]
					if num >= 3 then
						table.remove(distbl,rand)
					end
					_G.Options[i] = tbl.Options[i].Title
				end
				tbl.Length = 30
				_G.Votes = {0,0,0}
				workspace.Remotes.Event:FireAllClients("Broadcast",tbl)
				end)
				Wait(32.5)
				if Stage == "Games" then
					local disaster
					if voting then
						local function Find_Most_Votes()
							local maximum,place = 0
							for i=1,3 do
								if _G.Votes[i] >= maximum then
									maximum = _G.Votes[i]
									place = i
								end
							end
							return place
						end
							
						local index = Find_Most_Votes()
						disaster = _G.Options[index]
						--[[
						local function find_index()
							for i,k in pairs (Disaster_Table) do
								if k[1] == disaster then
									return i
								end
							end
						end
						]]
						if Auto_Pick_Disasters and type(Auto_Pick_Disasters) == "table" and #Auto_Pick_Disasters > 0 then
							disaster = Auto_Pick_Disasters[math.random(#Auto_Pick_Disasters)]
						end
					else
						local disasterNames = {
							"Mosquito Mutts",
							"Drought",
							"Famine",
							"Intoxicate Water",
							"Tracker Jackers",
							"Rain"
						}
						disaster = disasterNames[math.random(#disasterNames)]
					end
					--workspace.Remotes.Event:FireAllClients("Broadcast",{Title = "Disaster Activated: "..disaster,Pic = Disaster_Table[find_index()] and Disaster_Table[find_index()].Pic})
					workspace.Announcement.Value = "Attention Tributes... The "..disaster.." Disaster has been activated!"
					Wait(6.66)
					if Stage == "Games" then
						Disasters[disaster]()
					end
					Wait(6.66)
					workspace.Announcement.Value = ""
				end
			--end))
		end
		tim = game.Lighting:GetMinutesAfterMidnight()
	until Stage ~= "Games"
end

local con = {
	{"00", {0, 0, 0}, 1900, {60, 60, 60}},
	{"01", {0, 0, 0}, 1900, {60, 60, 60}},
	{"02", {10, 10, 0}, 2000, {75, 75, 75}},
	{"03", {30, 30, 30}, 2000, {75, 75, 75}},
	{"04", {60, 40, 0}, 2000, {150, 120, 0}},
	{"05", {90, 60, 0}, 2200, {155, 130, 0}},
	{"06", {100, 80, 0}, 2300, {151, 189, 189}},
	{"07", {191, 229, 229}, 2700, {150,150,150}},
	{"08", {191, 229, 229}, 3000, {150,150,150}},
	{"09", {191, 229, 229}, 3200, {175,175,175}},
	{"10", {191, 229, 229}, 3500, {175,175,175}},
	{"11", {191, 229, 229}, 3500, {175,175,175}},
	{"12", {191, 229, 229}, 3500, {175,175,175}},
	{"13", {191, 229, 229}, 3200, {175,175,175}},
	{"14", {191, 229, 229}, 3100, {175,175,175}},
	{"15", {191, 229, 229}, 3000, {175,175,175}},
	{"16", {191, 229, 229}, 2900, {175,175,175}},
	{"17", {191, 229, 229}, 2750, {175,175,175}},
	{"18", {90, 40, 0}, 2400, {150, 110, 0}},
	{"19", {61, 34, 0}, 2200, {130, 100, 0}},
	{"20", {0,0,0}, 2000, {75, 75, 75}},
	{"21", {0,0,0}, 2000, {75, 75, 75}},
	{"22", {0,0,0}, 2000, {75, 75, 75}},
	{"23", {0,0,0}, 1900, {60, 60, 60}},
	{"24", {0,0,0}, 1900, {60, 60, 60}}
}

local function Change_Fog()
	for k, v in pairs(con) do
		if string.sub(game.Lighting.TimeOfDay, 1, 2) == v[1] then
			local post = k - 1
			if post == 0 then post = 23 end
			post = con[post]	
			local endoar, endoag, endoab, oar, oag, oab = v[4][1], v[4][2], v[4][3], post[4][1], post[4][2], post[4][3]
			local endfr, endfg, endfb, fr, fg, fb = v[2][1], v[2][2], v[2][3], post[2][1], post[2][2], post[2][3]
			local endfe, fe = v[3], post[3]	
			local time = (tonumber(string.sub(game.Lighting.TimeOfDay, 4, 5) * 60) + tonumber(string.sub(game.Lighting.TimeOfDay, 7, 8))) / 3600	
			local coar, coag, coab = (oar - ((oar - endoar) * time)), (oag - ((oag - endoag) * time)), (oab - ((oab - endoab) * time))
			local cfr, cfg, cfb = (fr - ((fr - endfr) * time)), (fg - ((fg - endfg) * time)), (fb - ((fb - endfb) * time))
			local cfe = (fe - ((fe - endfe) * time))
			game.Lighting.OutdoorAmbient = _G.Disaster == "Rain" and Color3.new(75/255,75/255,75/255) or Color3.new(coar / 255, coag / 255, coab / 255)
			game.Lighting.FogColor = _G.Disaster == "Rain" and Color3.new(.2,.2,.2) or Color3.new(cfr / 255, cfg / 255, cfb / 255)
			game.Lighting.FogEnd = _G.Disaster == "Rain" and 150 or cfe
		end
	end
end

game.Players.PlayerRemoving:connect(function(player)
	local id,name = player.userId,player.Name
	for i=1,#_G.Tributes do
		if name == _G.Tributes[i][1] and _G.Tributes[i][2]:lower() == "alive" then
			local tbl = {name,"Quit"}
			table.insert(Games_Data,tbl)
			pcall(function()
				_G.Games_Player_Data[name].Time = Get_Time_Alive(game.Lighting.TimeOfDay)
			end)
			_G.Tributes[i][2] = "Dead"
			Tribute_Died()
			table.insert(_G.Dead_Tributes_To_Show,{math.ceil(.5*i),_G.Tributes[i][1],(i%2) == 0 and "Female" or "Male"})
		end
	end
	pcall(function()
		game.ServerStorage.PlayerValues[tostring(id)]:Destroy()
	end)
	ds:SetAsync(tostring(id).."Data",Data[tostring(id)])
	pcall(function()
		ods:SetAsync(tostring(player.userId).."XP",Data[tostring(id)].XP)
	end)
	pcall(function()
		killOds:SetAsync(tostring(player.userId).."Kills",Data[tostring(id)].Kills)
	end)
	Data[tostring(id)] = nil
end)

math.randomseed(tick() + 1)

coroutine.resume(coroutine.create(function()
	while true do
		Games_Data = {} --{Player Died,Killed By,Weapon}
		_G.Games_Player_Data = {} --{Player Died,Killed By,Weapon}
		game.Lighting:SetMinutesAfterMidnight(720)
		Change_Fog()
		repeat
			if game.Players.NumPlayers < Players_Required then
				workspace.Announcement.Value = tostring(Players_Required).." Players are required to start the "..Format_Number(_G.Year+1).." Annual Hunger Games."
			end
			wait(20)
		until game.Players.NumPlayers >= Players_Required
		_G.Dead_Tributes_To_Show = {}
		_G.Year = _G.Year + 1
		workspace.Announcement.Value = "Happy "..Format_Number(_G.Year).." Annual Hunger Games!"
		wait(math.random(4,5))
		workspace.Announcement.Value = "And may the odds be ever in your favor!"
		wait(5)
		workspace.Announcement.Value = "This year's tributes are now being reaped!"
		local plrs,num_Tributes = pick_Tributes() --sort players in districts
		--print(pcall(function()
		Select_Classes(plrs)
		local Map_Gen_Done = false
		xpPerWin = num_Tributes * XP_Per_Win.Per_Player + XP_Per_Win.Starting
		Stage = "Reaping"
		local tribtbl = {} --{district number = {1 = {male name,character,pic},2 = {female name,character,pic}}}
		for i=1,num_Tributes,2 do
			local districtnum = math.floor(.5*i)+1
			tribtbl[districtnum] = {{},{}}
			for e=1,2 do
				if _G.Tributes[i+e-1] and _G.Tributes[i+e-1][1] then
					local pl = game.Players:FindFirstChild(_G.Tributes[i+e-1][1])
					table.insert(tribtbl[districtnum][e],{_G.Tributes[i+e-1][1],Find_Tribute_Class(pl),Find_Player_Pic(pl)})
				end
			end
		end
		workspace.Announcement.Value = ""
		workspace.Remotes.Event:FireAllClients("Reaping",tribtbl)
		--end))
		--[[for i=1,num_Tributes,2 do
			local p1,p2 = game.Players:FindFirstChild(_G.Tributes[i][1]),(_G.Tributes[i+1] and _G.Tributes[i+1][1]) and game.Players:FindFirstChild(_G.Tributes[i+1][1])
			local districtnum = math.floor(.5*i)+1
			workspace.Announcement.Value = "For District "..tostring(districtnum)..":"
			Wait(.5)
			if p1 then
				if p2 then
					workspace.Remotes.Event:FireAllClients(2,{p1.Name,p2.Name},{Find_Tribute_Character(p1),Find_Tribute_Character(p2)},{Find_Player_Pic(p1),Find_Player_Pic(p2)},districtnum)
					Wait(12)
				else
					workspace.Remotes.Event:FireAllClients(2,{p1.Name},{Find_Tribute_Character(p1)},{Find_Player_Pic(p1)},districtnum)
					Wait(7)
				end
			end
		end]]
		Wait(1.5*num_Tributes+3)
		workspace.Announcement.Value = ""
		Map_Gen_Done = nil
		coroutine.resume(coroutine.create(function()
			Map_Gen_Done = Generate_Arena()
		end))
		workspace.Note.Value = "Capitol Architectures and Engineers are Building the Arena; Excuse any lag."
		--coroutine.resume(coroutine.create(function()
		local function find_plr(i)
			for e,k in pairs (game.Players:GetPlayers()) do
				if k:FindFirstChild("Tribute") and k.Tribute.Value == i then
					return k
				end
			end
			if _G.Tributes[i][1] and game.Players:FindFirstChild(_G.Tributes[i][1]) then
				return game.Players:FindFirstChild(_G.Tributes[i][1])
			end
		end
			for i=1,num_Tributes do
				--if _G.Tributes[i][1] then
				pcall(function()
					workspace.Remotes.Event:FireClient(find_plr(i),"Create Tube",CFrame.new(Vector3.new(200*i-200*12,666,0)))
				end)
				--local room = game.ServerStorage.TubeRoom:Clone()
				--room:SetPrimaryPartCFrame(CFrame.new(Vector3.new(200*i-200*12,666,0)))
				--room.Name = "TubeRoom"..tostring(i)
				--room.Parent = workspace.Rooms
				--for i=1,6 do wait(.7) end
				--end
			end
			Stage = "Entering Tubes"
			wait(1)
			for i,k in pairs (game.Players:GetPlayers()) do
				for e,r in pairs (k.PlayerGui:GetChildren()) do
					if r.ClassName == "Sound" then
						r.Volume = 0
						r:Destroy()
					end
				end
				k:LoadCharacter()
			end
		--end))
		coroutine.resume(coroutine.create(function()
			repeat wait() until Map_Gen_Done
			workspace.Note.Value = ""
			coroutine.resume(coroutine.create(Spawn_Weapons))
			coroutine.resume(coroutine.create(Spawn_Fruit))
			workspace.Remotes.Event:FireAllClients("In Tube")
			local t = Wait(32.5)
			Players_In_Tube = {}
			workspace.Remotes.Event:FireAllClients("Close Tube")
			wait(20)
			for i,k in pairs (_G.Tributes) do
				local pname = k[1]
				if pname and pname ~= "" then
					local function indas()
						for i,k in pairs (Players_In_Tube) do
							if pname == k then
								return true
							end
						end
					end
					if not indas() then
						local t,bool = Get_Tributes("Dead"),false
						for i,k in pairs (t) do
							if pname == k then
								bool = true
							end
						end
						if not bool then
							Move_Char(game.Players:FindFirstChild(pname))
						end
						--game.Players:FindFirstChild(pname).Character:MoveTo(workspace.Pedestals["Pedestal"..tostring(i)].PrimaryPart.Position + Vector3.new(0,5,0))						
						--Explode_Tribute(pname,true)
						--[[
						WTF ISAAC, TELEPORTING THEM IF THEY AINT IN TUBE???
						--]]
					end
				end
			end
			for i,k in pairs (Get_Tributes("Alive")) do
				local plr = game.Players:FindFirstChild(k)
				workspace.Remotes.Event:FireClient(plr,"Countdown")
			end
			--coroutine.resume(coroutine.create(function()
				local function playTick()
					local soundT = Instance.new("Sound", workspace)
					soundT.SoundId = "rbxassetid://141252315"
					soundT:Play()
					soundT:Destroy()
				end
				local cd = game.ServerStorage.Countdown:Clone()
				pcall(function() cd:SetPrimaryPartCFrame(CFrame.new(workspace.Cornucopia.CountdownPos.Position+Vector3.new(0,80,0))) end)
				cd.Parent = workspace
				local label = cd.Text.TextLabel
				Wait(6)
				for c = 1, 31 do
					wait(1)
					local count = 30 - c + 1
					local startColor = CFrame.new(0, 255, 0)
					local startColorS = CFrame.new(0, 125, 0)
					local endColor = CFrame.new(255, 0, 0)
					local endColorS = CFrame.new(125, 0, 0)
					local color = startColor:lerp(endColor, c / 31)
					local color = Color3.new(color.X / 255, color.Y / 255, color.Z / 255)
					local colorS = startColorS:lerp(endColorS, c / 31)
					local colorS = Color3.new(colorS.X / 255, colorS.Y / 255, colorS.Z / 255)
					label.TextTransparency = 0
					label.TextStrokeTransparency = 0.5
					label.TextColor3 = color
					label.TextStrokeColor3 = colorS
					label.Text = tostring(count)
					playTick()
					if count == 0 then
						local soundT = Instance.new("Sound", workspace)
						soundT.SoundId = "rbxassetid://154281509"
						soundT:Play()
						soundT:Destroy()
						for a,b in pairs(Get_Tributes("Alive")) do
							pcall(function()
								local player = game.Players:FindFirstChild(b)
								player.PlayerGui.Chat.ChatHolder.Visible = false
							end)
						end
					end
				end
				cd:Destroy()
			--end))
			coroutine.resume(coroutine.create(function()
				Wait(5.5)
				workspace.Rooms:ClearAllChildren()
			end))
			Stage = "Games"
			_G.Day = 1
			workspace.Remotes.Event:FireAllClients("Day Changed",_G.Day)
			coroutine.resume(coroutine.create(Activate_Survival))
			coroutine.resume(coroutine.create(Activate_Life_in_Arena))
			coroutine.resume(coroutine.create(Activate_Time))
			Activate_Invis_FF()
		end))
		coroutine.resume(coroutine.create(function()
			repeat wait(0.7) until Stage == "Games"
			wait(10)
			local tribs_left = math.random(3,5)
			while wait(0.7) do
				if Get_Num_Tributes("Alive") <= tribs_left and game.Players.NumPlayers >= 7 then
					--[[game.Workspace.Announcement.Value = "The Cornucopia is being removed... May the odds be ever in your favor..."
					for a,b in pairs(game.Workspace.Cornucopia:GetChildren()) do
						if b.Name ~= "Root" then
							b:Destroy()
						end
					end]] --- this was a stupid idea tbh I only added it because mutts were glitching out
					local t = Get_Tributes("Alive")
					local chars = {}
					for i=1,#t do
						if game.Players:FindFirstChild(t[i]) and game.Players[t[i]].Character then
							table.insert(chars,game.Players[t[i]].Character)
						end
					end
					game.Workspace.Announcement.Value = "The Capitol has added a special surprise to the arena... This will be the final announcement."
					for i = 1,Get_Num_Tributes("Dead") do
						local mutt = game.ServerStorage.Mutt:Clone()
						mutt.Name = "Mutt"
						mutt.Parent = workspace
						mutt:MoveTo(game.Workspace.Cornucopia.Root.Position + Vector3.new(math.random(-100,100),7.5,math.random(-100,100)))
						coroutine.resume(coroutine.create(function()
							local char = chars[i%tribs_left+1]
							while wait(.1) and mutt and mutt.Parent do
								if Stage == "Games" and char and char:FindFirstChild("Humanoid") and (char:FindFirstChild("Torso") or char:FindFirstChild("Head")) then
									pcall(function()
										mutt.AI.Humanoid:MoveTo(char:FindFirstChild("Torso") and char.Torso.Position or char.Head.Position)
									end)
								else
									for n,q in pairs (chars) do
										if q == char then
											table.remove(chars,n)
										end
									end
									if #chars == 0 then 
										mutt:Destroy()
									else
										char = chars[math.random(#chars)]
									end
								end
							end
							coroutine.resume(coroutine.create(function()
								local hit = false
								mutt:WaitForChild("Base")
								for i,k in pairs (mutt.Base:GetChildren()) do
									if k:IsA("BasePart") then
										k.Touched:connect(function(part)
											if hit == false and part.Parent and part.Parent:FindFirstChild("Humanoid") then
												hit = true
												part.Parent.Humanoid.Health = part.Parent.Humanoid.Health - (math.random(2000,4000)*.01)
												wait(.75)
												hit = false
											end
										end)
									end
								end
							end))
							coroutine.resume(coroutine.create(function()
								while wait() and mutt and mutt.Parent and Stage == "Games" do
									script.Parent.Humanoid.Jump = true
									wait(math.random(3))
								end
								if mutt and mutt.Parent and Stage ~= "Games" then
									mutt:Destroy()
								end
							end))
						end))
						wait(0.5)
					end
					coroutine.resume(coroutine.create(function()
						wait(10)
						game.Workspace.Announcement.Value = ""
					end))
					break
				end
			end
		end))
		repeat
			wait(.7)
		until Stage == "Games" and (Testing and Get_Num_Tributes("Alive") == 0 or (Get_Num_Tributes("Alive") <= ((Players_Required == 1 and game.Players.NumPlayers < 2) and 0 or 1)))
		wait(2)
		Stage = "Conclusion"
		local tribs = Get_Tributes("Alive")
		if #tribs == 1 then
			pcall(function()
				for a,b in pairs(workspace:GetChildren()) do
					if b.Name == "Mutt" then
						b:Destroy()
					end
				end
			end)
			workspace.Announcement.Value = "The Victor of the "..Format_Number(_G.Year).." Annual Hunger Games is "..tribs[1].."!"
			local function find_plr()
				for i,k in pairs (game.Players:GetPlayers()) do
					if tribs[1] == k.Name then
						return k
					end
				end
			end
			local pl = find_plr()
			Data[tostring(pl.userId)].Wins = Data[tostring(pl.userId)].Wins + 1
			Data[tostring(pl.userId)].XP = Data[tostring(pl.userId)].XP + xpPerWin
			workspace.Remotes.Event:FireClient(pl,"Awarded XP",xpPerWin,"Winning The Games!")
			workspace.Remotes.Event:FireClient(pl,"Changed XP",Data[tostring(pl.userId)].XP)
			coroutine.resume(coroutine.create(function() ps:AwardPoints(pl.userId,xpPerWin) end))
			workspace.Remotes.Event:FireClient(pl,"Level Change",returnFromXP(Data[tostring(pl.userId)].XP))
			_G.Games_Player_Data[pl.Name].Time = Get_Time_Alive(game.Lighting.TimeOfDay)
			_G.Games_Player_Data[pl.Name].XP = _G.Games_Player_Data[pl.Name].XP + xpPerWin
		else
			workspace.Announcement.Value = "There was no Victor for the "..Format_Number(_G.Year).." Annual Hunger Games."
		end
		Stage = "Overview"
		_G.Day = 0
		wait(3)
		if #tribs > 0 then
			local pl = game.Players:FindFirstChild(tribs[1])
			if pl then
				--pl:LoadCharacter()
			end
		end
		table.insert(Games_Data,{tribs[1],"Nobody","Winner"})
		wait(1)
		for i,k in pairs (game.Players:GetPlayers()) do
			k:LoadCharacter()
		end
		wait(3)
		workspace.Remotes.Event:FireAllClients("Show Overview",Games_Data,_G.Games_Player_Data)
		wait(1)
		workspace.Note.Value = "Removing Last Year's Arena; Please Excuse Any Lag"
		_G.Tributes = {}
		workspace.Remotes.Event:FireAllClients("Day Changed",_G.Day)
		Clear_Arena()
		wait(30)
		Stage = "Reaping"
		for i,k in pairs (game.Players:GetPlayers()) do
			k:LoadCharacter()
		end
		workspace.Note.Value = ""
	end
end))

--spins tools in lobby
--[[
local Speed_of_Rotation = 1.337

local function Spin_Tool(tool)
	coroutine.resume(coroutine.create(function()
		wait(math.random(150)/30)
		repeat
			tool.CFrame = tool.CFrame*CFrame.Angles(Speed_of_Rotation*math.rad(.8944),Speed_of_Rotation*math.rad(.445),Speed_of_Rotation*math.rad(0)) 
			wait()
		until not tool:IsDescendantOf(workspace)
	end))
end

coroutine.resume(coroutine.create(function()
	local lobby = workspace:WaitForChild("Lobby")
	local inn = lobby:WaitForChild("InnerTables")
	Spin_Tool(inn:WaitForChild("Table1"):WaitForChild("Axe"))
	Spin_Tool(inn:WaitForChild("Table1"):WaitForChild("Knife"))
	Spin_Tool(inn:WaitForChild("Table2"):WaitForChild("Axe"))
	Spin_Tool(inn:WaitForChild("Table2"):WaitForChild("Knife"))
	local out = lobby:WaitForChild("OutsideTables")
	Spin_Tool(out:WaitForChild("Table1"):WaitForChild("Axe"))
	Spin_Tool(out:WaitForChild("Table1"):WaitForChild("Knife"))
	Spin_Tool(out:WaitForChild("Table2"):WaitForChild("Axe"))
	Spin_Tool(out:WaitForChild("Table2"):WaitForChild("Knife"))
end))
--]]
coroutine.resume(coroutine.create(function()
	local t = game:GetService("MarketplaceService"):GetProductInfo(265496283)
	local sgui = Instance.new("ScreenGui",game.StarterGui)
	sgui.Name = "VersionUI"
	local lbl = Instance.new("TextLabel",sgui)
	lbl.Size = UDim2.new(.1,0,.05,0)
	lbl.Position = UDim2.new(.0,0,.925,0)
	lbl.BackgroundTransparency = 1
	lbl.Text = t.Name:sub(t.Name:find("V") or t.Name:len(),nil)
	lbl.TextColor3 = Color3.new(1,1,0)
	lbl.TextStrokeTransparency = 0
	lbl.Font = Enum.Font.SourceSansItalic
	lbl.TextScaled = true
	lbl.Name = "Version"
end))

coroutine.resume(coroutine.create(function()
	local t = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
	if t.Name:find("Test") then
		Testing = true
		Players_Required = 1
		local txt = [[ATTENTION
This Server is for testing purposes! Shutdowns and Bugs will happen here quite frequently. This server to all just to test upcoming updates.

Thanks,
FutureWebsiteOwner]]
		local sgui = Instance.new("ScreenGui",game.StarterGui)
		sgui.Name = "TestUI"
		local lbl = Instance.new("TextLabel",sgui)
		lbl.BackgroundColor3 = Color3.new(0,0,0)
		lbl.BackgroundTransparency = .5
		lbl.Position = UDim2.new(.35,0,.4,0)
		lbl.Size = UDim2.new(.3,0,.2,0)
		lbl.Text = txt
		lbl.TextColor3 = Color3.new(1,1,1)
		lbl.Font = Enum.Font.SourceSansItalic
		lbl.TextScaled = true
		local x = Instance.new("TextButton",lbl)
		x.BackgroundColor3 = Color3.new(1,0,0)
		x.Position = UDim2.new(0,0,-.15,0)
		x.Size = UDim2.new(.05,0,.15,0)
		x.Font = Enum.Font.SourceSansBold
		x.Text = "X"
		x.TextColor3 = Color3.new(1,1,1)
		x.TextScaled = true
		x.TextStrokeTransparency = 0
		local ls = script["Local (Test)"]:Clone()
		ls.Parent = x
		ls.Disabled = false
	end
end))

local Message_Receiver = Instance.new("RemoteEvent", game.ReplicatedStorage)
Message_Receiver.Name = "MessageReceiver" -- Receive messages from players
local Message_Sender = Instance.new("RemoteEvent", game.ReplicatedStorage)
Message_Sender.Name = "MessageSender" -- Send received messages to players
local Assign_ColorCode = Instance.new("RemoteEvent", game.ReplicatedStorage)
Assign_ColorCode.Name = "AssignColorCode" -- Assigns a user a new color code
local Prompt_Purchase = Instance.new("RemoteEvent", game.ReplicatedStorage)
Prompt_Purchase.Name = "ClientPromptPurchase" -- Allow clients to purchase things "locally"

local Marketplace = game:GetService("MarketplaceService")
local ColorCodes = game.ReplicatedStorage:WaitForChild("ColorCodes")

local Level_Images = { -- MAKE SURE THESE ARE SORTED BY LEVEL!!!!
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

Prompt_Purchase.OnServerEvent:connect(function(Player, ProductID)
	Marketplace:PromptPurchase(Player, ProductID)
end)

local function Is_Alive(t,n)
	for i,k in pairs (t) do
		if n == k then
			return true
		end
	end
end

Message_Receiver.OnServerEvent:connect(function(Player, Message)
	if Message:len() > 50 then Message = Message:sub(1,50) end
	local message = {
		Speaker = Player.Name;
		Message = Message;
		Image = "http://www.roblox.com/asset/?id="..Level_Images[returnFromXP(Data[tostring(Player.userId)].XP)+1];
	}
	local Speaker = game.Players:FindFirstChild(message.Speaker)
	if (Speaker ~= nil) then
		local tribs = Get_Tributes("Alive")
		for _, player in pairs(game.Players:GetPlayers()) do
			if not (Stage == "Games" and Is_Alive(tribs,player.Name)) then
				Message_Sender:FireClient(player, message.Speaker, message.Message, message.Image, ColorCodes:FindFirstChild(Speaker.ColorCode:GetChildren()[1].Name))
			end
		end
	end
	return true -- Let the client know everything has been processed
end)

Assign_ColorCode.OnServerEvent:connect(function(Player, CodeName)
	Player.ColorCode:ClearAllChildren()
	game.ReplicatedStorage.ColorCodes:FindFirstChild(CodeName):Clone().Parent = Player.ColorCode
end)

coroutine.resume(coroutine.create(function()
	local StandardColorCode
	game.Players.PlayerAdded:connect(function(Player)
		local ColorCode = Instance.new("Folder", Player)
		ColorCode.Name = "ColorCode"
		while StandardColorCode == nil do wait() end
		StandardColorCode:Clone().Parent = ColorCode
		local tribs = Get_Tributes("Alive")
		for _, player in pairs(game.Players:GetPlayers()) do
			if not (Stage == "Games" and Is_Alive(tribs,player.Name)) then
				Message_Sender:FireClient(player, "SERVER", Player.Name.." has entered the server.", "")
			end
		end
		----------------------
		
		--STUFF TO COPY INTO LEADERBOARD--
	end)
	StandardColorCode = game.ReplicatedStorage:WaitForChild("ColorCodes"):WaitForChild("White1")
	
	game.Players.PlayerRemoving:connect(function(Player)
		local tribs = Get_Tributes("Alive")
		for _, player in pairs(game.Players:GetPlayers()) do
			if not (Stage == "Games" and Is_Alive(tribs,player.Name)) then
				Message_Sender:FireClient(player, "SERVER", Player.Name.." has left the server.", "")
			end
		end
	end)
	while true do
		wait(120)
		pcall(function()
			local Top_Donator = nil
			local Amount = 0
			for _, player in pairs(game.Players:GetPlayers()) do
				if (Data[tostring(player.userId)].D) then
					if (Data[tostring(player.userId)].D > Amount) then
						Top_Donator = player
						Amount = Data[tostring(player.userId)].D
					end
				end
			end
			local tribs = Get_Tributes("Alive")
			for _, player in pairs(game.Players:GetPlayers()) do
				if not (Stage == "Games" and Is_Alive(tribs,player.Name)) then
					Message_Sender:FireClient(player, "SERVER", "The top donator in the server is "..Top_Donator.Name.."! R$"..Amount, "")
				end
			end
		end)
	end
end))

local function Lock(datamodel)
	for i,k in pairs (datamodel:GetChildren()) do
		pcall(function()
			k.Locked = true
		end)
		Lock(k)
	end
end

Lock(workspace)
workspace.ChildAdded:connect(function(c)
	Lock(c)
end)

game.OnClose = function()
	wait(15)
end

--Generate_Arena()

wait(10)
