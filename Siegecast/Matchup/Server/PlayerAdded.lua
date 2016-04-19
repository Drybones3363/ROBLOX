local ds = game:GetService("DataStoreService"):GetDataStore("Stats-Alpha3")
local odsw = game:GetService("DataStoreService"):GetOrderedDataStore("Wins")
local odslo = game:GetService("DataStoreService"):GetOrderedDataStore("Loses")
local odsle = game:GetService("DataStoreService"):GetOrderedDataStore("Levels-Alpha")
local ins = game:GetService("InsertService")

function makeint(name,fold)
	local int = Instance.new("IntValue",fold)
	int.Name = name
	return int
end

game.Players.PlayerAdded:connect(function(plr)
	plr.CharacterAdded:connect(function(char)
		--plr:ClearCharacterAppearence()
	end)
	--plr.CanLoadCharacterAppearence = false
	local gold = Instance.new("IntValue",plr)
	gold.Name = "Gold"
	gold.Value = workspace.Settings.StartingGold.Value
	plr:LoadCharacter()
	plr.Character:MoveTo(Vector3.new(1337,1337,1337))
	for num,p in pairs (plr.Character:children()) do
		if p.ClassName == "Part" then
			p.Anchored = true
		elseif p.ClassName == "Hat" then
			p:Destroy()		
		end
	end
	local fold = Instance.new("Folder",game.ServerStorage)
	fold.Name = plr.Name.."Data"
	local wins = makeint("Wins",fold)
	local loses = makeint("Loses",fold)
	local level = makeint("Level",fold)
	local bool = Instance.new("BoolValue",fold)
	bool.Name = "GotData"
	bool.Value = false
	local numwin = nil
	repeat
		local s = pcall(function()
			numwin = odsw:GetAsync(plr.userId)
		end)
		wait(.5)
	until numwin or s
	if numwin == nil then
		numwin = 0
	end
	wins.Value = numwin
	local numloss = nil
	repeat
		local s = pcall(function()
			numloss = odslo:GetAsync(plr.userId)
		end)
		wait(.5)
	until numloss or s
	if numloss == nil then
		numloss = 0
	end
	loses.Value = numloss
	local numlev = nil
	repeat
		local s = pcall(function()
			numlev = odsle:GetAsync(plr.userId)
		end)
		wait(.5)
	until numlev or s
	if numlev == nil then
		numlev = 1
	end
	level.Value = numlev
	bool.Value = true
		--[[tbl = {}
		tbl["Wins"] = 0
		tbl["Loses"] = 0
		tbl["Level"] = 1
	end
	if tbl["Wins"] then
		wins.Value = tbl["Wins"]
	end
	if tbl["Loses"] then
		loses.Value = tbl["Loses"]
	end
	if tbl["Level"] then
		level.Value = tbl["Level"]
	end]]
	wait(.5)
	local tb = nil
	repeat
		local s = pcall(function()
			tb = ds:GetAsync(plr.userId.."Equipped")
		end)
		wait(.5)
	until tb or s
	if tb == nil then
		tb = {9,10,11,12}
	end
	local fold2 = Instance.new("Folder",game.ServerStorage)
	fold2.Name = plr.Name.."Soldiers"
	local names = _G.GetNames()
	local modids = _G.GetModelIDs()
	for i=1,#tb do
		local item = _G.GetName(tb[i])
		local soldier = 0
		for e=1,#names do
			if names[e] == item then
				soldier = e
				break
			end
		end
		if soldier > 0 then
			ins:LoadAsset(modids[soldier]):children()[1].Parent = fold2
		end
	end
	for num,sol in pairs (fold2:children()) do
		if sol:findFirstChild("Leader") then
			sol.Leader.Value = plr.Name
		end
	end
	local red = Instance.new("BoolValue",workspace.Prepared)
	red.Name = plr.Name
	red.Value = true
	--workspace:WaitForChild("Ready")
	_G.MakeStatue(plr,tb)
end)
