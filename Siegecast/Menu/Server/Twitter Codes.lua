local ds = game:GetService("DataStoreService"):GetDataStore("TwitterCodes")
local m = require(game.ServerScriptService.DatastoreFunctions)

local fold = Instance.new("Folder",game.ServerStorage)
fold.Name = "TwitterCodes"

function insertcode(code,type,amount)
	local tbltoinsert = {code,type,amount}
	local d = game:GetService("DataStoreService"):GetDataStore("TwitterCodes")
	local tb = d:GetAsync("Codes")
	if tb == nil then
		tb = {}
	end
	table.insert(tb,tbltoinsert)
	d:SetAsync("Codes",tb)
end

--[[function startingcodes()
	game:GetService("DataStoreService"):GetDataStore("TwitterCodes"):SetAsync("Codes",{{"AlphaAwesomeness","Credits",100}})
end]]

function gettbl()
	local t = {}
	for i,k in pairs (fold:children()) do
		if k.ClassName == "StringValue" then
			table.insert(t,k.Value)
		end
	end
	return t
end

function equaltables(t1,t2)
	if #t1 ~= #t2 then
		return false
	end
	for i=1,#t1 do
		if t1[i] ~= t2[i] then
			return false
		end
	end
	return true
end

repeat
	local tbl = m.PCallGetAsync(ds,"Codes")
	if tbl == nil then
		tbl = {}
		m.PCallSetAsync(ds,"Codes",tbl)
	end
	if #tbl ~= 0 and equaltables(tbl,gettbl()) == false then
		fold:ClearAllChildren()
		for i=1,#tbl do
			local str = Instance.new("StringValue")
			str.Value = tbl[i][1]
			str.Name = tostring(i)
			local rew = Instance.new("IntValue",str)
			rew.Name = tbl[i][2]
			rew.Value = tbl[i][3]
			str.Parent = fold
			if game.ServerStorage:FindFirstChild("PlayerStats") then
				for _,k in pairs (game.ServerStorage.PlayerStats:children()) do
					if k:findFirstChild("Codes") then
						local haz = false
						for _,y in pairs (k.Codes:children()) do
							if y.Name == tbl[i][1] then
								haz = true
								break
							end
						end
						if haz == false then
							local newstr = Instance.new("BoolValue")
							newstr.Name = tbl[i][1]
							newstr.Value = false
							newstr.Parent = k.Codes
						end
					end
				end
			end
		end
		wait(60)
	end
until nil
