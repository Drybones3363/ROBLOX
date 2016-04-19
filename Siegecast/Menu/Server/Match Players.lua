local ds = game:GetService("DataStoreService"):GetDataStore("MatchData")
local asset = game:GetService("AssetService")
local dsf = require(game.ServerScriptService.DatastoreFunctions)
local setted = true
local plrstoremove = {}
--"plrname=level#type"

local function match(plr1,plr2,type)
	--print(type(plr1),type(plr2))
	local description = plr1.." vs "..plr2
	print(description)
	local matchnum = dsf.PCallIncrementAsync(ds,"MatchNumber",1)
	local placeid = asset:CreatePlaceAsync("Siegecast Matchup Game #"..tostring(matchnum),211481450,description)
	local plra = ""
	local plrb = ""
	if type == "Random" then
		plra = plr1
		plrb = plr2
	elseif type == "Rank" then
		plr1 = string.match(plr1,"%w+=")
		plr2 = string.match(plr1,"%w+=")
		plra = string.sub(plr1,1,string.len(plr1)-1)
		plrb = string.sub(plr2,1,string.len(plr2)-1)
	end
	print(plra,plrb)
	print(game.Players:FindFirstChild(plra),game.Players:FindFirstChild(plrb))
	if game.Players:FindFirstChild(plra) then
		local plr = game.Players:FindFirstChild(plra)
		--coroutine.resume(coroutine.create(function()
			dsf.PCallSetAsync(ds,"p"..plr.userId.."PlaceID",placeid)
		--end))
		--[[local setid = pcall(function()
			ds:SetAsync("p"..plr.userId.."PlaceID",placeid)
		end)
		if setid then
			print("Set!")
		else
			error("Error in setting place ID to "..plr)
		end]]
	end
	print(placeid)
	if game.Players:FindFirstChild(plrb) then
		local plr = game.Players:FindFirstChild(plrb)
		--coroutine.resume(coroutine.create(function()
			dsf.PCallSetAsync(ds,"p"..plr.userId.."PlaceID",placeid)
		--end))
		--[[local setid = pcall(function()
			ds:SetAsync("p"..plr.userId.."PlaceID",placeid)
		end)
		if setid then
			print("Set!")
		else
			error("Error in setting place ID to "..plr)
		end]]
	end
end

local function removeplr(name)
	table.insert(plrstoremove,name)
end

local function printtbl(tbl)
	for i=1,#tbl do
		print(i,": ",tbl[i])
	end
end

game.Players.PlayerRemoving:connect(function(p)
	removeplr(p.Name)
end)

workspace.Searching.ChildRemoved:connect(function(c)
	removeplr(c.Name)
end)

game.OnClose = function()
	ds:IncrementAsync("Servers",-1)
	local tbl = ds:GetAsync("Table")
	if #tbl > 0 then
	for w=1,#plrstoremove do
		for q=1,#tbl do
			if string.sub(tbl[q],1,string.len(plrstoremove[w])) == plrstoremove[w] then
				table.remove(tbl,q)
			end
		end
		table.remove(plrstoremove,w)
	end
	end
	local set = false
	repeat
	set = pcall(function()
		ds:SetAsync("Table",tbl)
	end)
	wait(.337)
	until set
	local done = false
	workspace.SavedData.Changed:connect(function(v)
		if v == true then
			done = true
		end
	end)
	repeat
		wait(.25)
	until done == true
end

coroutine.resume(coroutine.create(function()
	local servers = ds:IncrementAsync("Servers",1)
	print("Servers: ",servers)
	if servers == 1 then
		ds:SetAsync("Table",{})
	end
end))

repeat wait(.1) until math.fmod(os.time(),15) == 0
while wait(15) do
	local tbl = ds:GetAsync("Table")
	print(#plrstoremove)
	for w=1,#plrstoremove do
		print(plrstoremove[w])
		for q=1,#tbl do
			if string.sub(tbl[q],1,string.len(plrstoremove[w])) == plrstoremove[w] then --here
				table.remove(tbl,q)
			end
		end
		table.remove(plrstoremove,w)
	end
	wait(3)
	for num,p in pairs (workspace.Searching:GetChildren()) do
		pname = p.Name
		local flag = true
		for e=1,#tbl do
			local plry = string.match(tbl[e],"%w+=")
			plry = string.sub(plry,1,string.len(plry)-1)
			if plry == pname then
				flag = false
				break
			end
		end
		if flag then
			table.insert(tbl,p.Value)
		end
	end
	local numremove = {}
	local rand = {}
	local rank = {}
	if #tbl >= 1 then
		for i=1,#tbl do
			local plr = string.match(tbl[i],"%w+=")
			plr = string.sub(plr,1,string.len(plr)-1)
			if game.Players:FindFirstChild(plr) and workspace.Searching:FindFirstChild(plr) == nil then
				table.insert(numremove,i)
			else
				local lvl = string.match(tbl[i],"=%d+")
				lvl = tonumber(string.sub(lvl,2))
				if lvl then
					local type = string.match(tbl[i],"#%w+")
					type = string.sub(type,2)
					print(type)
					if type then
						if type == "Random" then
							table.insert(rand,plr)
						elseif type == "Ranked" then
							table.insert(rank,plr.."="..lvl)
						end
					end
				end
			end
		end
	end
	for i=1,#rand,2 do
		if rand[i] and rand[i+1] then
			--match up the two
			if workspace.Searching:FindFirstChild(rand[i]) then --here?
				workspace.Searching:FindFirstChild(rand[i]):Destroy()
			end
			if workspace.Searching:FindFirstChild(rand[i+1]) then
				workspace.Searching:FindFirstChild(rand[i+1]):Destroy()
			end
			match(rand[i],rand[i+1],"Random")
		end
	end
	local lvls = {}
	local rankremove = {}
	for i=1,#rank do
		local lvl = tonumber(string.sub(string.match(rank[i],"=%d+"),2))
		if lvl then
			table.insert(lvls,lvl)
		else
			table.insert(rankremove,i)
		end
	end
	for i=1,#rankremove do
		table.remove(rank,rankremove[i])
	end
	while (lvls[1] and lvls[2]) do
		local closest = 1337
		local num = nil
		for i=2,#lvls do
			local dif = math.abs(lvls[i]-lvls[1])
			if dif < closest then
				closest = dif
				num = i
			end
		end
		match(rank[num],rank[1],"Rank")
	end
	if #tbl >= 1 then
		for i=1,#tbl do
			local plr = string.match(tbl[i],"%w+=")
			plr = string.sub(plr,1,string.len(plr)-1)
			if game.Players:FindFirstChild(plr) and workspace.Searching:FindFirstChild(plr) == nil then
				table.insert(numremove,i)
			end
		end
	end
	if #numremove > 0 then
		for i=#numremove,1,-1 do
			table.remove(tbl,numremove[i])
		end
	end
	printtbl(tbl)
	local success = pcall(function()
	ds:SetAsync("Table",tbl)
	end)
	if success then
		print("Success")
	else
		error("Error in setting Table to Database")
	end
end


--[[
local d = game:GetService("DataStoreService"):GetDataStore("MatchData")
local tbl = d:GetAsync("Table")
if #tbl > 0 then
	for i=1,#tbl do
		print(tbl[i])
	end
else
	print'nil'
end
]]
