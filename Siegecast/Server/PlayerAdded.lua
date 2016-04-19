local ds = game:GetService("DataStoreService"):GetDataStore(game.ServerStorage["Stats-DataStore"].Value)
local ods = game:GetService("DataStoreService"):GetOrderedDataStore("XP-Alpha")
local points = game:GetService("PointsService")
local plrtbl = Instance.new("Folder",game.ServerStorage)
plrtbl.Name = "PlayerStats"
local m = require(game.ServerScriptService.DatastoreFunctions)

function newint(p,n,v)
	local int = Instance.new("IntValue",p)
	int.Name = n
	int.Value = v
	return int
end

game.Players.PlayerAdded:connect(function(plr)
	local xp = Instance.new("IntValue",plr)
	xp.Name = "XP"
	local cred = Instance.new("IntValue",plr)
	cred.Name = "Credits"
	local plrfold = Instance.new("Folder",plrtbl)
	plrfold.Name = tostring(plr.userId)
	
	--[[plr.ChildAdded:connect(function(c)
		if c.ClassName == "BoolValue" and c.Name == "DailyBonus" then
			--reward daily bonus here--
			print"Rewarded Daily Bonus"
		end
	end)]]
	
	plr.CharacterAdded:connect(function(char)
		local hum = char:WaitForChild("Humanoid")
		hum.Died:connect(function()
			if workspace.Searching:FindFirstChild(plr.Name) then
				workspace.Searching[plr.Name]:Destroy()
			end
		end)
	end)
	local serv = Instance.new("Model",game.ServerStorage)
	serv.Name = plr.Name
	--[[local statue = game.ServerStorage.StatueStarter:clone()
	statue.Name = "Statue"
	statue.Parent = serv]]
	wait(.5)
	local credint = newint(plrfold,"Credits",0)
	local xpint = newint(plrfold,"XP",2500)
	local dailyint = newint(plrfold,"DailyBonus",0)
	xp.Changed:connect(function(val)
		xpint.Value = xp.Value
	end)
	cred.Changed:connect(function(val)
		credint.Value = cred.Value
	end)
	local xpvalue = m.PCallGetAsync(ods,tostring(plr.userId))
	if xpvalue == nil or xpvalue < 2500 then
		xpvalue = 2500
	end
	xp.Value = xpvalue
	local tbl = m.PCallGetAsync(ds,plr.userId)
	if tbl == nil then
		tbl = {}
		tbl["DailyBonus"] = os.time() + 24*60*60
		tbl["Credits"] = 50
		cred.Value = 50
		--[[repeat
			local s = pcall(function()
				ds:SetAsync(plr.userId,tbl)
			end)
		until s]]
	else
		if tbl["Credits"] then
			cred.Value = tbl["Credits"]
		end
	end
	credint.Value = cred.Value
	xpint.Value = xp.Value
	if tbl["DailyBonus"] then
		dailyint.Value = tbl["DailyBonus"]
	else
		tbl["DailyBonus"] = os.time() + 24*60*60
		dailyint.Value = tbl["DailyBonus"]
	end
	local codesfold = game.ServerStorage:WaitForChild("TwitterCodes")
	local codes = Instance.new("Folder",plrfold)
	codes.Name = "Codes"
	if tbl["Codes"] == nil then
		tbl["Codes"] = {}
	end
	for _,k in pairs (codesfold:children()) do
		if k.ClassName == "StringValue" then
			local bool = Instance.new("BoolValue",codes)
			bool.Name = k.Value
			bool.Value = false
			print(#tbl["Codes"])
			if #tbl["Codes"] > 0 then
				for i=1,#tbl["Codes"] do
					if tbl.Codes[i] == k.Value then
						bool.Value = true
						break
					end
				end
			end
		end
	end
	if plr.userId > 0 and points:GetGamePointBalance(plr.userId) == 0 then
		points:AwardPoints(plr.userId,100)
	end
end)

game.Players.PlayerRemoving:connect(function(p)
	print(p.Name.." Removing!!!")
	if workspace.Searching:FindFirstChild(p.Name) then
		workspace.Searching[p.Name]:Destroy()
	end
	if game.ServerStorage:FindFirstChild(p.Name) then
		game.ServerStorage[p.Name]:Destroy()
	end
	_G.SaveStats(p,2)
end)
