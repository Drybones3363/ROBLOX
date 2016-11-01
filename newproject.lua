local ds = game:GetService("DataStoreService"):GetDataStore("Data")

local Data = {}



local PackData --table of all packages to buy

local data = {
	{
		i = 535278127,
		n = 'Katana Pack',
		p = 100,
		d = {
			{"Katana","k",11442510,11442524,11444089,1},
			{"Golden Katana","gk",11442510,18776669,18776672,1},
			{"Blue Katana","bk",11442510,20577502,20577515,1},
			{"Crimson Katana","ck",11442510,18016060,18016099,1},
			{"Bombastic Katana","Bk",11442510,250281077,254661729,2},
			{"Bluesteel Katana","bK",11442510,240922991,240922927,2},
			{"Omega Katana","ok",11442510,340575861,340606193,3},
			{"Katana of the Dark Age","kda",86297695,86290910,86290987,4},
			
		}
	},
	{
		i = 535278110,
		n = 'Basic Sword Pack',
		p = 100,
		d = {
			{"Classic Sword","s",10467539,10467545,534736610,1},
			{"Claymore","c",11439778,11439794,11440361,1},
			{"Riptide","r",124121136,124121617,124122797,1},
			{"Fencing Foil","ff",10908449,10908412,10908579,2},
			{"Sword Breaker","sb",77353021,77353054,77353080,2},
			{"Sorcus' Sword","ss",53351910,53352041,53357857,3},
			{"8-Bit Sword","8",361629844,380257575,380257985,4},
			
		}
	},
	
	
}

PackData = data

local function Get_Pack_Data(n)
	for i,k in pairs (PackData) do
		if k.n and k.n == n then
			return k
		end
	end
end
local function Get_Pack_Items(pack,level)
	local ret = {}
	pack = type(pack) == "table" and pack or Get_Pack_Data(pack)
	for i,k in pairs (pack.d or {}) do
		if k[6] and k[6] == level then
			table.insert(ret,k)
		end
	end
	return ret
end




local Market_Data = {} --includes all data from the market (selling of items)








local ds = game:GetService("DataStoreService")

local function Update_Data()
	local p
	repeat
		p = pcall(function()
			ds:SetAsync("PackData",data)
		end)
	until p == true
	print"Successfully Updated Data"
end

local function Load_Data()
	local p
	repeat
		p = pcall(function()
			PackData = ds:GetAsync("PackData")
		end)
	until p == true and PackData
end

local function Open_Pack_Server(n)
	local ret = {}
	local d = Get_Pack_Data(n)
	for i=1,math.random(10,20) do
		Get_Pack_Items(d,level)
	end
end

local ps = game:GetService("PointsService")

local chosen_game_slot = math.random(5)

function Player_Added(plr)
	delay(0,function()
		local t = ds:GetAsync(tostring(plr.userId).."_Slot"..tostring(chosen_game_slot))
		if not t then
			print("No data in game slot #"..tostring(chosen_game_slot))
			t = {}
			t.Map = math.random(-9999,9999)
		end
		if t.Map == nil then
			print("Failed to load slot map")
			t = {}
			t.Map = math.random(-9999,9999)
		end
		delay(0,function()
			Generate_Map(t.Map)
		end)
		Data[tostring(plr.userId)] = t
	end)
	plr.CharacterAdded:connect(function(c)
		c:WaitForChild("Humanoid").Died:connect(function()
			wait(3)
			plr:LoadCharacter()
		end)
		--local ray = Ray.new(Vector3.new(0,500,0),Vector3.new(0,-500,0))
		--local part,pos = workspace:FindPartOnRay(ray)
		--c:SetPrimaryPartCFrame(CFrame.new(pos))
		c.Humanoid.WalkSpeed = 35
	end)
	wait(1)
	plr:LoadCharacter()
	if plr.Name ~= "FutureWebsiteOwner" then
		ps:AwardPoints(plr.userId,1)
	end
	while wait(3) do
		Open_Pack_Server()
		--workspace.RE:FireClient(plr,"Open Pack",
		wait(10)
	end
end

game.Players.PlayerRemoving:connect(function(plr)
	local id = plr.userId
	ds:SetAsync(tostring(id).."_Slot"..tostring(chosen_game_slot),Data[tostring(id)])
	
end)

game.Players.PlayerAdded:connect(function(plr)
	Player_Added(plr)
end)

for _,plr in pairs (game.Players:GetPlayers()) do
	Player_Added(plr)
end

--birds
delay(0,function()
	local bird_sounds = {
		"rbxassetid://152900523",
		"rbxassetid://152900531",
		"rbxassetid://152900480",
	}
	while wait(.2) do
		if math.random(3) == 1 then
			local sound = Instance.new("Sound",workspace)
			sound.PlayOnRemove = true
			sound.Volume = .01
			sound.SoundId = bird_sounds[math.random(#bird_sounds)]
			sound:Destroy()
		end
	end
end)
