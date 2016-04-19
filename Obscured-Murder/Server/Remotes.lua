local saveitems = {"XP","Credits","Knives","Guns"}

local r = workspace:WaitForChild("Remotes")
local cts = r:WaitForChild("ClientToServer")

cts:WaitForChild("GetData")
function cts.GetData.OnServerInvoke(plr,tbl)
	if game.ServerStorage:FindFirstChild("PlayerData") == nil then return end
	if game.ServerStorage:FindFirstChild(tostring(plr.userId)) == nil then return end
	local fold = game.ServerStorage[tostring(plr.userId)]
	local t = {}
	local function init(k)
		for i=1,#tbl do
			if tbl[i]:lower() == k:lower() then
				return true
			end
		end
	end
	for _,k in pairs (saveitems) do
		if init(k) and fold:findFirstChild(k) then
			if fold[k].ClassName == "Folder" then
				for e,r in pairs (fold[k]:children()) do
					t[r.Name] = r.Value
				end
			else
				t[k] = fold[k].Value
			end
		end
	end
	return t
end

cts:WaitForChild("GetWeapon")
function cts.GetWeapon.OnServerInvoke(plr,type,name,kname)
	if game.ServerStorage:FindFirstChild("Weapons") == nil then return end
	if game.ServerStorage.Weapons:findFirstChild(type) == nil then return end
	if plr:findFirstChild("PlayerGui") == nil then return end
	local fold = plr.PlayerGui:FindFirstChild("WeapStorage")
	if fold == nil then fold = Instance.new("Folder",plr.PlayerGui) fold.Name = "WeapStorage" end
	local weap = game.ServerStorage.Weapons[type]:findFirstChild(name,true)
	if weap == nil then return end
	if weap:findFirstChild(kname) == nil then return end
	local c = weap[kname]:clone() c.Parent = fold c.Anchored = true c.CanCollide = false
	return c
end

cts:WaitForChild("GetBagData")
function cts.GetBagData.OnServerInvoke(plr,type,name,knife)
	if game.ServerStorage:FindFirstChild("Weapons") == nil then return end
	if game.ServerStorage.Weapons.Bags:findFirstChild(type) == nil then return end
	if plr:findFirstChild("PlayerGui") == nil then return end
	local fold = plr.PlayerGui:FindFirstChild("WeapStorage")
	if fold == nil then fold = Instance.new("Folder",plr.PlayerGui) fold.Name = "WeapStorage" end
	local weap = game.ServerStorage.Weapons.Bags[type]:findFirstChild(name)
	if weap == nil then return end
	local c = weap:clone() c.Parent = fold
	if knife then
		return c:findFirstChild(knife).Rarity.Value
	end
	return c
end

--[[cts:WaitForChild("TransferData").OnServerEvent:connect(function(plr,tbl)
	if game.ServerStorage:FindFirstChild(tostring(plr.userId)) == nil then return end
	local fold = game.ServerStorage[tostring(plr.userId)]
	for _,k in pairs (saveitems) do
		if tbl[k] and fold:findFirstChild(k) then
			if fold[k].ClassName == "Folder" then
				for e,r in pairs (tbl[k]) do
					if fold:findFirstChild(e) then
						fold[e].Value = r
					end
				end
			else
				fold[k].Value = tbl[k]
			end			
		end
	end
end)]]

cts:WaitForChild("Attack").OnServerEvent:connect(function(plr,s,t,cframe)
	local bool = Instance.new("CFrameValue")
	bool.Value = cframe
	bool.Name = t
	bool.Parent = s
end)
