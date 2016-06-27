local ds,ps = game:GetService("DataStoreService"):GetDataStore("Data"),game:GetService("PointsService")

local anstbl = {}
local questtbl = {}

local categories = {
	[1] = "Web",
	[2] = "In-Game",
	[3] = "Cryptography",
	[4] = "Studio",
	[5] = "Trivia",
	[6] = "Catalog",
	[7] = "Forum",
	[8] = "Games",
	[9] = "Miscellaneous",
	[10] = "Users"
}

local Data = {}

local Default_Data = {
	Points = 0,
	Solved = 0,
	Attempts = 0
}

local function Encode(str)
	local t = {}
	for i=1,string.len(str) do
		local char = str:sub(i,i)
		table.insert(t,2*char:byte()+1)
	end
	return t
end

local function Encode_Table(t)
	for i=1,#t do
		t[i] = 2*t[i]+1
	end
	return t
end

local function Decode(t)
	local str = ""
	for i,k in pairs (t) do
		local num = (k-1)*.5
		str = str..string.char(num)
	end
	return str
end

local function Decode_Easy(t)
	local str = ""
	for i,k in pairs (t) do
		str = str..string.char(k)
	end
	return str
end

local function Add_Question(t) --t = {category number,points,title,desc,answer,solvers}
	local ds = game:GetService("DataStoreService"):GetDataStore("Data")
	--if #t ~= 6 then print("Invalid Table") return end
	local tbl = {t[1],t[2],{},{},{},{}}
	for i=3,5 do
		local str = t[i]
		for e=1,string.len(str) do
			table.insert(tbl[i],string.byte(str:sub(e,e)))
		end
	end
	local tab = ds:GetAsync("Answers")
	local function Decode_Easy(t)
		local str = ""
		for i,k in pairs (t) do
			str = str..string.char(k)
		end
		return str
	end
	local function Legal()
		for i,k in pairs (tab) do
			if Decode_Easy(k[3]) == t[3] then
				return false
			end
		end
		return true
	end
	if Legal() then
		table.insert(tab,tbl)
		print("Added "..t[3].." Problem")
		for i,k in pairs (tab) do
			print(i,Decode_Easy(k[3]))
		end
		ds:SetAsync("Answers",tab)
	else
		print(t[3].." Problem has already been added.")
	end
end
--Add_Question({9,175,"QR Code","Scan this: 318204386","Key{Queue_Argh}"})
--Add_Question({2,100,"Tutorial","If you read the tutorial, you would know. :)","Key{R3ad 1T}"})

local function Remove_Question(title,all)
	local ds = game:GetService("DataStoreService"):GetDataStore("Data")
	local tbl = {}
	local tab = ds:GetAsync("Answers")	
	local function Decode_Easy(t)
		local str = ""
		for i,k in pairs (t) do
			str = str..string.char(k)
		end
		return str
	end
	for i,k in pairs (tab) do
		print(i,Decode_Easy(k[3]))
		if Decode_Easy(k[3]) == title then
			table.remove(tab,i)
			print("Removed "..title.." Problem")
			if not all then
				break
			end
		end
	end
	ds:SetAsync("Answers",tab)
end
--Remove_Question("Memes",true)

coroutine.resume(coroutine.create(function()
	local tbl = ds:GetAsync("Answers")
	if #tbl > 0 then
		for i=1,#tbl do
			--for e,r in pairs (tbl[i]) do
				local r = tbl[i]
				anstbl[i] = {Encode_Table(r[3]),Encode_Table(r[5])}
				questtbl[i] = {categories[r[1]],r[2],Decode(r[3]),Decode_Easy(r[4]),r[6]}
			--end
		end
		print("Answers Loaded")
		workspace.Loaded.Value = true
	end
	for i,k in pairs (tbl or {}) do
		print(i,Decode(k[3]))
	end
	tbl = nil
end))

game.Players.PlayerAdded:connect(function(plr)
	wait()
	local tbl = ds:GetAsync(tostring(plr.userId))
	Data[tostring(plr.userId)] = tbl or Default_Data
	local points = ps:GetGamePointBalance(plr.userId)
	if points == 0 then
		Data[tostring(plr.userId)].Points = Data[tostring(plr.userId)].Points + 10
		pcall(function() ps:AwardPoints(plr.userId,10) end)
		coroutine.resume(coroutine.create(function()
			for i=1,3 do wait(.337) end
			workspace.Remotes.Event:FireClient(plr,"Tutorial")
		end))
	end
	local lead = Instance.new("Model",plr)
	lead.Name = "leaderstats"
	local points = Instance.new("IntValue",lead)
	points.Name = "Points"
	points.Value = Data[tostring(plr.userId)].Points
end)

game.Players.PlayerRemoving:connect(function(plr)
	local id = plr.userId
	ds:SetAsync(tostring(id),Data[tostring(id)])
end)

local function Invisible(plr)
	if plr.Character then
		for i,k in pairs (plr.Character:GetChildren()) do
			pcall(function()
				if k.Name ~= "HumanoidRootPart" then
					k.Transparency = .5
				end
			end)
		end
	end
end

local function Visible(plr)
	if plr.Character then
		for i,k in pairs (plr.Character:GetChildren()) do
			pcall(function()
				if k.Name ~= "HumanoidRootPart" then
					k.Transparency = 0
				end
			end)
		end
	end
end

local function Find_Question_Value(question)
	for i,k in pairs (questtbl) do
		if k[3] == question then
			return k[2]
		end
	end
end

local function Check_Key(plr,question,key)
	for i,k in pairs (anstbl) do
		if Decode(k[1]) == question then
			if Decode(k[2]):lower() == key:lower() then
				local tbl = Data[tostring(plr.userId)]
				for i,k in pairs (questtbl) do
					if k[3] == question then
						for e,r in pairs (k[5]) do
							if plr.userId == r then
								return "Already Answered"
							end
						end
					end
				end
				for e,r in pairs (questtbl) do
					if r[3] == question then
						table.insert(r[5],plr.userId)
					end
				end
				local p = Find_Question_Value(question)
				pcall(function()
					Data[tostring(plr.userId)].Points = Data[tostring(plr.userId)].Points + p
				end)
				pcall(function() ps:AwardPoints(plr.userId,p) end)
				pcall(function()
					plr.leaderstats.Points.Value = Data[tostring(plr.userId)].Points
				end)
				pcall(function() Data[tostring(plr.userId)].Attempts = Data[tostring(plr.userId)].Attempts + 1 end)
				pcall(function() Data[tostring(plr.userId)].Solves = Data[tostring(plr.userId)].Solves + 1 end)
				return "Correct"
			else
				pcall(function() Data[tostring(plr.userId)].Attempts = Data[tostring(plr.userId)].Attempts + 1 end)
				return "Incorrect"
			end
		end
	end
	return "An Error Has Occurred"
end

coroutine.resume(coroutine.create(function()
	local remotes = workspace:WaitForChild("Remotes")
	remotes:WaitForChild("Event").OnServerEvent:connect(function(plr,typ,...)
		if typ == "Invisible" then
			Invisible(plr)
		elseif typ == "Visible" then
			Visible(plr)
		end
	end)
	local funct = remotes:WaitForChild("Function")
	function funct.OnServerInvoke(plr,typ,...)
		if typ == "Check" then
			return Check_Key(plr,...)
		elseif typ == "Questtbl" then
			return questtbl
		elseif typ == "CategoryTbl" then
			return categories
		end
	end
end))

local function Save()
	local async = ds:GetAsync("Answers")
	for i,k in pairs (async) do
		for e,r in pairs (questtbl) do
			if Decode_Easy(k[3]) == r[3] then
				for u,o in pairs (r[5]) do
					local function inthetbl()
						for t,y in pairs (async[i][6]) do
							if o == y then
								return true
							end
						end
						return false
					end
					if inthetbl() == false then
						table.insert(async[i][6],o)
					end
				end
			end
		end
	end
	ds:SetAsync("Answers",async)
end

coroutine.resume(coroutine.create(function()
	while wait(60) do
		Save()
	end
end))

game.OnClose = function()
	Save()
	wait(5)
end
