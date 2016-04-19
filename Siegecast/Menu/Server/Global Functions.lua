local ds = game:GetService("DataStoreService"):GetDataStore(game.ServerStorage["Stats-DataStore"].Value)
local ods = game:GetService("DataStoreService"):GetOrderedDataStore("XP-Alpha")


_G["Find"] = function(type,plrgui)
local plr = plrgui.Parent
--ds stuffs here
plrgui.MatchGui.Frame.Position = game.StarterGui.MatchGui.Frame.Position
plrgui.MatchGui.Finding.Visible = true
plrgui.LevelGui.Frame.Visible = false
plrgui.MatchGui.Frame.Outlining.Visible = false
local set = Instance.new("BoolValue")
set.Value = false
set.Name = "Set"
set.Parent = plrgui.ChatGuis
for i=.25,.05,-.005 do
plrgui.Theme.Volume = i
wait(.1)
end
plrgui.Theme.Volume = .05
plrgui.MatchGui.Finding.Load.Visible = true
plrgui.MatchGui.Finding.Load.Spin.Disabled = false
plrgui.MatchGui.Finding.FindID.Disabled = false
local newsearch = Instance.new("StringValue",workspace.Searching)
newsearch.Value = plrgui.Parent.Name.."=1#"..type
newsearch.Name = plrgui.Parent.Name
end

_G["GetLvl"] = function(xp)
	local lvl = math.floor(5*math.log(xp/2500))+1
	return lvl
end

_G["GetXPForNext"] = function(lvl)
	lvl = lvl
	local xp = math.ceil(2500*math.exp(lvl/5))
	return xp
end

_G["GetXPForPrev"] = function(lvl)
	lvl = lvl - 1
	local xp = math.ceil(2500*math.exp(lvl/5))
	return xp
end

_G["Buy"] = function(plr,cost,item,details)
	print(plr,cost,item,details)
	local f = game.ServerStorage.PlayerStats
	local fo = f:findFirstChild(tostring(plr.userId))
	if fo and fo:findFirstChild("Credits") and plr:findFirstChild("Credits") and fo:findFirstChild("Items") then
		if fo.Credits.Value >= cost then
			if fo["Items"]:findFirstChild(item) then
				--[[local tbl = nil
				local success = false
				repeat
					success = pcall(function()
						 tbl = ds:GetAsync(plr.userId.."Inventory")
					end)
					wait(.1)
				until success == true
				local tab = game.ServerStorage.Hats.Table
				for i,k in pairs (tab:children()) do
					print(k.Value,item,k.Name)
					if k.Value == item then
						tbl[tonumber(k.Name)] = true
						break
					end
				end
				success = false
				repeat 
					success = pcall(function()
						ds:SetAsync(plr.userId.."Inventory",tbl)
					end)
					wait(.1)
				until success == true]]
				fo["Items"][item].Value = true
				plr.Credits.Value = plr.Credits.Value - cost
				fo.Credits.Value = plr.Credits.Value
				details.Bought.Visible = true
				details.Buy.Visible = false
				if plr:findFirstChild("PlayerGui") then
					coroutine.resume(coroutine.create(function()
						local s = Instance.new("Sound",plr.PlayerGui)
						s.SoundId = "rbxassetid://131886985"
						s.Volume = 1
						s:Play()
						for i=1,4 do
							wait(1)
						end
						s:Destroy()
					end))
				end
			end
		end
	end
end

_G["GetID"] = function(item)
	if game.ServerStorage:FindFirstChild("Hats") then
		if game.ServerStorage.Hats:findFirstChild("Table") then
			for i,k in pairs (game.ServerStorage.Hats.Table:children()) do
				if k.Value == item then
					return tonumber(k.Name)
				end
			end
		end
	end
	return nil
end

_G["GetName"] = function(id)
	if game.ServerStorage:FindFirstChild("Hats") then
		if game.ServerStorage.Hats:findFirstChild("Table") then
			for i,k in pairs (game.ServerStorage.Hats.Table:children()) do
				if tonumber(k.Name) == id then
					return k.Value
				end
			end
		end
	end
	return nil
end

local m = require(game.ServerScriptService.DatastoreFunctions)

_G["SaveStats"] = function(plr,a)
	local id = plr.userId
	local fold = game.ServerStorage:FindFirstChild("PlayerStats")
	local tbl = {}
	if fold then
		local plrfold = fold:findFirstChild(tostring(plr.userId)) --get player folder
		for i,k in pairs (plrfold:children()) do
			if k.ClassName == "IntValue" then
				if k.Name == "XP" then
					if k.Value >= 100 then
						m.PCallSetAsync(ods,plrfold.Name,k.Value)
					end
				else
					tbl[k.Name] = k.Value
				end
			elseif k.ClassName == "Folder" and k.Name == "Codes" then
				local t = {}
				for _,e in pairs (k:children()) do
					if e.ClassName == "BoolValue" then
						if e.Value == true then
							table.insert(t,e.Name)
						end
					end
				end
				tbl[k.Name] = t
			end
		end
		if tbl.Credits and tbl.DailyBonus and tbl.Codes then
			m.PCallSetAsync(ds,id,tbl)
		end
		--local tbl = m.PCallGetAsync(ds,id)
		--[[if plr:findFirstChild("Credits") and plr:findFirstChild("XP") then
			tbl["Credits"] = plr.Credits.Value
			tbl["XP"] = plr.XP.Value
			m.PCallSetAsync(ds,id,tbl)
		end]]
		tbl = {}
		if a >= 2 and plrfold:findFirstChild("Equipped") and plrfold:findFirstChild("Items") and game.ServerStorage:FindFirstChild("Hats") and game.ServerStorage:FindFirstChild("Hats"):findFirstChild("Table") then
			for i,k in pairs (plrfold.Items:children()) do
				for e,r in pairs (game.ServerStorage.Hats.Table:children()) do
					if r.Value == k.Name then
						tbl[tonumber(r.Name)] = k.Value
						break
					end
				end
			end
			m.PCallSetAsync(ds,id.."Inventory",tbl)
			local tb = {}
			for i,k in pairs (plrfold.Equipped:children()) do
				if k.ClassName == "IntValue" then
					table.insert(tb,k.Value)
				end
			end
			m.PCallSetAsync(ds,id.."Equipped",tb)
		end	
		workspace.SavedData.Value = true
		print("Successfully Saved "..plr.Name.."'s Stats!")
		wait()
		workspace.SavedData.Value = false
		plrfold:Destroy()
	end
end
