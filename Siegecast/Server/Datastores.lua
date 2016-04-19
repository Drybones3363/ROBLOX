local ds = game:GetService("DataStoreService"):GetDataStore(game.ServerStorage["Stats-DataStore"].Value)
local ods = game:GetService("DataStoreService"):GetDataStore("Names&IDs")
local startingids = {9,10,11,12}
local dsf = require(game.ServerScriptService.DatastoreFunctions)

game.Players.PlayerAdded:connect(function(plr)
wait(1.5)
local hats = game.ServerStorage:WaitForChild("Hats")
local tblohats = hats:WaitForChild("Table")
local stats = game.ServerStorage:WaitForChild("PlayerStats")
local fold = stats:WaitForChild(tostring(plr.userId))
local finv = Instance.new("Folder",fold)
finv.Name = "Items"
local thaz = dsf.PCallGetAsync(ds,tostring(plr.userId).."Inventory")
--local set = false
if thaz == nil then
	thaz = startingids
	--set = true
end
for n,i in pairs (tblohats:GetChildren()) do
	if i.ClassName == "StringValue" then
		local bool = Instance.new("BoolValue",finv)
		bool.Name = tostring(i.Value)
		bool.Value = false
		if thaz[tonumber(i.Name)] == nil then
			local start = false
			for n=1,#startingids do
				if tonumber(i.Name) == startingids[n] then
					start = true
					break
				end
			end
			thaz[tonumber(i.Name)] = start
			bool.Value = start
			--set = true
		elseif thaz[tonumber(i.Name)] == true then
			bool.Value = true
		end
	end
end
--[[if set then
	dsf.PCallSetAsync(ds,tostring(plr.userId).."Inventory",thaz)
end]]
wait(.337)
local fequ = Instance.new("Folder",fold)
fequ.Name = "Equipped"
local tb = dsf.PCallGetAsync(ds,tostring(plr.userId).."Equipped")
if tb == nil then
	tb = startingids
	--dsf.PCallSetAsync(ds,tostring(plr.userId).."Equipped",tb)
end
for i=1,#tb do
	local id = Instance.new("IntValue",fequ)
	id.Name = tostring(tb[i])
	id.Value = tb[i]
end
if plr.userId > 0 then
	local sy = dsf.PCallGetAsync(ods,plr.userId)
	if not (sy ~= nil and sy == plr.Name) then
		dsf.PCallSetAsync(ods,plr.userId,plr.Name)
	end
end
end)
