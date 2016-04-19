local VIPs = {65789033}
local Murder_Chance_ID = 1

local Gamepasses = {Murder_Chance_ID}

local pstats = game.ServerStorage:WaitForChild("PlayerData")
local dataDS = game:GetService("DataStoreService"):GetDataStore("Data_Alpha")
local xpDS = game:GetService("DataStoreService"):GetOrderedDataStore("XP_Alpha")
local killsDS = game:GetService("DataStoreService"):GetOrderedDataStore("Kills_Alpha")
local noobdata = {Credits = 50}

local audio = {160381423,186105947} --168746862 = shirk-haunted

game:GetService("InsertService"):LoadAsset(244422988):children()[1].Parent = game.ServerStorage --packages
game:GetService("InsertService"):LoadAsset(243856531):children()[1].Parent = game.ServerStorage --maps
game:GetService("InsertService"):LoadAsset(245651535):children()[1].Parent = game.ServerStorage --knives/guns

--Destroy Work Audio--
if workspace:FindFirstChild("WorkAudio") then workspace.WorkAudio:Destroy() end
----------------------

game.Players.PlayerAdded:connect(function(plr)
	plr.CharacterAdded:connect(function(c)
		c:WaitForChild("Head")
		for _,s in pairs (c.Head:children()) do
			if s.ClassName == "Sound" then
				if s.SoundId == "rbxasset://sounds/splat.wav" then
					s.Volume = 0
				end
			end
		end
		--[[if workspace:FindFirstChild("Announce") == nil then return end
		if workspace.Announce:FindFirstChild("Msg") == nil or workspace.Announce:FindFirstChild("Time") == nil then return end
		if workspace.Announce.Msg.Value == "" or workspace.Announce.Time.Value <= 1 then return end
		workspace.Remotes.ServerToClient.Announce:FireClient(plr,workspace.Announce.Msg.Value,workspace.Announce.Time.Value)]]
	end)
	local function IsVIP()
		for u=1,#VIPs do
			if type(VIPs[u]) == "number" then
				if plr.userId == VIPs[u] then
					return true
				end
			elseif type(VIPs[u]) == "string" then
				if plr.Name == VIPs[u] then
					return true
				end
			end
		end
	end
	local mc = game.ServerStorage:WaitForChild("MurderChance")
	local data = dataDS:GetAsync(tostring(plr.userId))
	local xp = xpDS:GetAsync(tostring(plr.userId))
	if data == nil then
		repeat wait() until (noobdata.Knives ~= nil and noobdata.Guns ~= nil)
		data = noobdata --first visit here
	end
	if xp == nil then
		xp = 0
	end
	data.NAME = plr.Name
	local ps = Instance.new("Folder",pstats) ps.Name = tostring(plr.userId)
	local ti = Instance.new("IntValue",ps) ti.Name = "TimeOn" ti.Value = os.time()
	local xp = Instance.new("IntValue",ps) xp.Name = "XP" xp.Value = xp
	local cred = Instance.new("IntValue",ps) cred.Name = "Credits" cred.Value = data.Credits
	local knives,guns = Instance.new("Folder",ps),Instance.new("Folder",ps) knives.Name = "Knives" guns.Name = "Guns"
	for _,k in pairs ({"Knives","Guns"}) do
		for e,r in pairs (data[k]) do
			local int = Instance.new("IntValue",ps[k]) int.Name = e int.Value = r
		end
	end
	local gp = Instance.new("Folder",ps) gp.Name = "GamePasses"
	if plr.userId > 0 then
		for i=1,#Gamepasses do
			if game:GetService("MarketplaceService"):PlayerOwnsAsset(plr,Gamepasses[i]) or IsVIP() then
				Instance.new("BoolValue",gp).Name = tostring(Gamepasses[i])
			end
		end
	end
	local mchance = Instance.new("IntValue",mc)
	mchance.Name = plr.Name
	mchance.Value = 1
	if gp:findFirstChild(tostring(Murder_Chance_ID)) then
		mchance.Value = 3
	end
end)

game.Players.PlayerRemoving:connect(function(plr)
	local m = require(script.Functions)
	local n = plr.Name
	if game.ServerStorage.MurderChance:FindFirstChild(n) then
		game.ServerStorage.MurderChance[n]:Destroy()
	end
	local ps = m.PlrStats(plr)
	if ps then
		if ps:findFirstChild("TimeOn") then
			if os.time() - ps.TimeOn.Value > 5 then
				--save stuff
			end
		end
	end
end)

if game.ServerStorage:FindFirstChild("Maps") then
	for i,k in pairs (game.ServerStorage.Maps:children()) do
		if k:findFirstChild("Primary") then
			k.PrimaryPart = k.Primary
		end
	end
end

--- Get Noob Weapon Data ---
if game.ServerStorage:FindFirstChild("Weapons") then
	local bags = game.ServerStorage.Weapons.Bags
	for _,k in pairs ({"Guns","Knives"}) do
		noobdata[k] = {}
		for _,u in pairs (bags[k]:children()) do
			for e,r in pairs (u:children()) do
				noobdata[k][r.Name] = 0
			end
		end
	end
end
---------------------------

------ Gameplay Code ------
_G.GamesPlayed = 0
local deb,finding = true,false

workspace:WaitForChild("GamesOn").Changed:connect(function(v)
	if v == false and deb then
		local m = require(script.Functions)
		if game.Players.NumPlayers < 2 then
			finding = true
			m.Announce("Need At Least 2 Players To Start",1337,true)
			workspace.GamesOn.Value = true
			return
		end
		deb = false
		local round = "Classic" --default round
		m.EndofRound()
		local waittime = math.random(10,25)
		m.Announce(tostring(waittime).." Second Intermission",waittime,true)
		m.PlaySound(audio[math.random(1,#audio)],waittime)
		wait(waittime)
		if (_G.GamesPlayed+1)%4 == 3 then
			m.Announce("Special Gamemode!",10,true)
			m.playSound(1337,3,false)
			wait(3)
			round = m.pickSpecial()
		end
		m.Announce("Vote for next Map!",10,true)
		m.PlaySound(168746862,18)
		m.OpenMapVote(round)
		wait(15)
		local tbl = m.GetMapVoted()
		m.CloseMapVote()
		if tbl ~= nil and game.ServerStorage:FindFirstChild("Maps") then
			m.Announce(tbl[1].." Voted",5,true)
			wait(5)
			if game.ServerStorage.Maps:findFirstChild(tbl[1]) then
				local clone = game.ServerStorage.Maps[tbl[1]]:clone()
				clone:SetPrimaryPartCFrame(CFrame.new(0,0,0))
				clone.Name = "Map"
				clone.PrimaryPart = clone:findFirstChild("Primary")
				clone.Parent = workspace
				--[[local function findparts(model) --loading functions (wait for load map)
					for _,y in pairs (model:children()) do
						if #y:children() > 0 then
							findparts(y)
						end
						print(y.ClassName,y:IsA("BasePart"))
						if y:IsA("BasePart") then
							wait()
						end
					end
				end
				findparts(game.ServerStorage.Maps[tbl[1]]--]]
				m.Announce("Loading Gameplay Data...",9,true)
				wait(9)
			end
		end
		local playin = m.GetPlrs()
		m.Spawn(playin)
		m.ViewMap(playin)
		m.RemoveAnnouncements(playin)
		m.PreGame(playin)
		deb = true
	elseif v == true then --if game started then
		if finding then
			repeat wait(1) until game.Players.NumPlayers >= 2
			finding = false
			for i,k in pairs (game.Players:GetPlayers()) do
				workspace.Remotes.ServerToClient.RemoveAnnouncements:FireClient(k)
			end
			wait(3)
			workspace.GamesOn.Value = false
		else
			_G.GamesPlayed = _G.GamesPlayed + 1
			--start games
		end
	end
end)

workspace:WaitForChild("Announce")
local tinstance = workspace.Announce:WaitForChild("Time")
while wait(1) do
	if tinstance.Value > 0  then
		tinstance.Value = tinstance.Value - 1
	end
end
