local m = {}

local OMassets = game.ServerStorage:FindFirstChild("Packages")
local mapmodel = game.ServerStorage:FindFirstChild("Maps")
local extrarounds = {{"Normal",90},{"Double XP",5},{"Double Credits",4},{"Double XP and Credits",1}}
local specialrounds = {{"Massacre",30},{"Gunslinger",25},{"Hunted Man",15}} specialrounds[0] = {"Classic"}
local OMnames = {}

if OMassets then
	for i,k in pairs (OMassets:children()) do
		if k.ClassName == "Model" then
			table.insert(OMnames,k.Name)
		end
	end
end

local maps = {}

if mapmodel ~= nil then
	for e=0,#specialrounds do
		maps[specialrounds[e][1]] = {}
		for i,k in pairs (mapmodel:children()) do
			if k:findFirstChild(specialrounds[e][1]) then
				table.insert(maps[specialrounds[e][1]],k.Name)
			end
		end
	end
end

m.GetPlrs = function()
	local tbl = {}
	for i,k in pairs (game.Players:GetPlayers()) do
		if k:findFirstChild("PlayerGui") and k.PlayerGui:findFirstChild("IntroGui") == nil then
			table.insert(tbl,k)
		end
	end
	return tbl
end

m.PlrStats = function(plr) --returns a plr's stats folder
	if type(plr) ~= "number" then
		if type(plr) == "string" then
			plr = game.Players:FindFirstChild(plr).userId
		else
			plr = plr.userId
		end
	end
	if game.ServerStorage:findFirstChild("PlayerStats") == nil then return end
	return game.ServerStorage.PlayerStats:findFirstChild(plr)
end

m.PreGame = function(plrs)
	if workspace:FindFirstChild("Remotes") == nil then return end
	if workspace.Remotes.ServerToClient:FindFirstChild("PreGame") == nil then return end
	if type(plrs) ~= "table" then plrs = {plrs} end
	for _,k in pairs (plrs) do
		
	end
end

m.GetMurderer = function(n) --returns a string of the player's name
	if n == nil then
		n = 1
	end
	if game.ServerStorage:findFirstChild("MurderChance") == nil then return end
	local tbl = {}
	for _,k in pairs (game.ServerStorage.MurderChance:children()) do
		if k.ClassName == "IntValue" and game.Players:FindFirstChild(k.Name) then
			for i=1,k.Value do
				table.insert(tbl,k.Name)
			end
		end
	end
	if #tbl == 0 then return end
	math.randomseed(tick())
	return tbl[math.random(1,#tbl)]	
end

m.MakeMurderer = function(plr)
	if type(plr) == "string" then
		plr = game.Players:findFirstChild(plr)
	end
	local stats = m.PlrStats(plr)
	if plr == nil or plr:findFirstChild("Backpack") == nil or not stats then return end
	local knife = game.ServerStorage.Knife:clone()
	knife.KnifeMesh.MeshId = stats.Knife.MeshId.Value
	knife.KnifeMesh.TextureId = stats.Knife.TextureId.Value
	knife.Parent = plr.Backpack
end

m.Return = function(t) --returns a table of player instances that are t (Default: Innocent)
	if game.ServerStorage:FindFirstChild("RoundData") == nil then return end
	if #game.ServerStorage.RoundData:children() == 0 then return end
	if t == nil or (t ~= "Innocent" or t ~= "Murderer" or t ~= "Sheriff") then t = "Innocent" end
	local tbl = {}
	for i,k in pairs (game.ServerStorage.RoundData:children()) do
		if k.ClassName == "StringValue" then
			if game.Players:findFirstChild(k.Name) and k.Value == t then
				table.insert(tbl,game.Players[k.Name])
			end
		end
	end
	return tbl
end

m.GetSheriff = function() --returns a player instance
	local tbl = m.Return("Innocent")
	if #tbl == 0 then return end
	return tbl[math.random(1,#tbl)]
end

m.SetAll = function(t) --Sets everyone in server to t (Default: Innocent)
	if game.ServerStorage:FindFirstChild("RoundData") == nil then return end
	if t == nil or (t ~= "Innocent" or t ~= "Murderer" or t ~= "Sheriff") then t = "Innocent" end
	game.ServerStorage.RoundData:ClearAllChildren()
	for i,k in pairs (game.Players:GetPlayers()) do
		local s = Instance.new("StringValue",game.ServerStorage.RoundData)
		s.Name = k.Name
		s.Value = t
	end
end


m.FindMurderers = function() --returns a table of players with their name and character's name
	if game.ServerStorage:findFirstChild("RoundData") == nil then return end
	local tbl = {}
	for i,k in pairs (game.ServerStorage["RoundData"]:children()) do
		if k.ClassName == "StringValue" then
			if k.Value == "Murderer" then
				local p = k.Name
				if game.Players:findFirstChild(p) then
					--get char name here
					table.insert(tbl,{p})
				end
			end
		end
	return tbl
	end
end

m.printMurderers = function()
	local tbl = m.FindMurderers()
	if tbl == nil or #tbl == 0 then print("No Murderer's or Error") return end
	print("Murderers: ")
	for i=1,#tbl do
		print(tbl[i][1],tbl[i][2])
	end
end

m.AssignName = function(plr,name,color)
	if plr.Character == nil or plr.Character:findFirstChild("Head") == nil then return end
	local b = Instance.new("BillboardGui",plr.Character.Head)
	b.Name = "NameGui"
	b.AlwaysOnTop = false
	b.Size = UDim2.new(10,0,10,0)
	b.StudsOffset = Vector3.new(0,3,0)
	local t = Instance.new("TextLabel",b)
	t.BackgroundTransparency = 1
	t.Size = UDim2.new(1,0,1,0)
	t.Font = math.random(0,4)
	t.TextScaled = true
	t.Text = name
	t.TextColor3 = color
	t.TextStrokeTransparency = 0
end

m.AssignPackage = function(plr,name)
	if OMassets == nil then return end
	if OMassets:findFirstChild(name) == nil then return end
	if plr.Character == nil then return end
	for _,k in pairs (plr.Character:children()) do
		if k.ClassName == "Shirt" or k.ClassName == "Pants" or k:IsA("Hat") or k.ClassName == "CharacterMesh" then
			k:Destroy()
		end
	end
	for _,k in pairs (OMassets[name]:children()) do
		if k.ClassName == "IntValue" then
			if k.Name == "Face" then
				if plr.Character:findFirstChild("Head") and plr.Character.Head:findFirstChild("face") then
					plr.Character.Head.face.Texture = "rbxassetid://"..tostring(k.Value)
				end
			elseif k.Name == "Shirt" or k.Name == "Pants" then
				local p = Instance.new(k.Name,plr.Character)
				p[k.Name.."Template"] = "rbxassetid://"..tostring(k.Value)
			end
		elseif k.ClassName == "Hat" or k.ClassName == "CharacterMesh" then
			k:clone().Parent = plr.Character
		end
	end
end

m.RemoveName = function(plr)
	if plr.Character == nil or plr.Character:findFirstChild("Head") == nil then return end
	if plr.Character.Head:findFirstChild("NameGui") then
		plr.Character.Head.NameGui:Destroy()
	end
end

m.EndofRound = function()
	
end

m.AssignNames = function(plrs) --plrs = table of players to assign names to
	if type(plrs) ~= "table" then
		plrs = {plrs}
	end
	if #OMnames < #plrs then return end
	math.randomseed(tick())
	local tbl = OMnames
	for _,k in pairs (plrs) do
		if k.Parent == game.Players then
			local s,val = Instance.new("StringValue"),math.random(1,#tbl)
			s.Value = tbl[val]
			table.remove(tbl,val)
		end
	end
end

m.BlackScreen = function(plrs)
	if type(plrs) ~= "table" then plrs = {plrs} end
	if workspace:FindFirstChild("Remotes") == nil then return end
	if workspace.Remotes.ServerToClient:FindFirstChild("BlackScreen") == nil then return end
	for _,k in pairs (plrs) do
		workspace.Remotes.ServerToClient.BlackScreen:FireClient(k)
	end
end

m.RemoveBlackScreen = function(plrs)
	if type(plrs) ~= "table" then plrs = {plrs} end
	if workspace:FindFirstChild("Remotes") == nil then return end
	if workspace.Remotes.ServerToClient:FindFirstChild("RemoveBlackScreen") == nil then return end
	for _,k in pairs (plrs) do
		workspace.Remotes.ServerToClient.RemoveBlackScreen:FireClient(k)
	end
end

m.RemoveAnnouncements = function(plrs)
	if type(plrs) ~= "table" then plrs = {plrs} end
	for _,k in pairs (plrs) do
		if k:findFirstChild("PlayerGui") then
			if k.PlayerGui:findFirstChild("Announcement") then
				workspace.Remotes.ServerToClient.RemoveAnnouncements:FireClient(k)
			end
		end
	end
end

m.Announce = function(msg,t) --t = time to show
	if t == nil then t = 30 end
	if workspace:findFirstChild("Announce") and workspace.Announce:FindFirstChild("Msg") and workspace.Announce:FindFirstChild("Time") then
		workspace.Announce.Msg.Value = msg
		workspace.Announce.Time.Value = t
	end
	m.RemoveAnnouncements(m.GetPlrs())
	for _,k in pairs (m.GetPlrs()) do
		workspace.Remotes.ServerToClient.Announce:FireClient(k,msg,t)
	end
end

m.ReceiveAnnounce = function(ty,color,plr,t)
	if t == nil then t = 5 end
	if type(plr) ~= "table" then plr = {plr} end
	for _,k in pairs (plr) do
		workspace.Remotes.ServerToClient.ReceiveAnnounce:FireClient(k,ty,color,t)
	end
end

m.getMaps = function(round) --returns a table of 3 tables {mapname,special round}
	local t = {{},{},{}}
	local tbl = maps[round]
	local total = 0 for i,k in pairs (extrarounds) do total = total + k[2] end
	local numtbl = #tbl
	if numtbl == 0 then return end
	for i=1,3 do
		local v = math.random(1,#tbl)
		t[i][1] = tbl[v]
		--extra rounds for Classic mode--
		if round == "Classic" then
			local val,type = math.random(1,total),""
			for _,k in pairs (extrarounds) do
				val = val - k[2]
				if val <= 0 then
					type = k[1]
					break
				end
			end
			t[i][2] = type
		end
		---------------------------------
		if numtbl >= 3 then --no repetition
			table.remove(tbl,v)
		end
	end
	return t
end

m.OpenMapVote = function(round)
	if workspace:FindFirstChild("Lobby") == nil then return end
	if workspace.Lobby:FindFirstChild("Bottom") == nil then return end
	if workspace.Lobby.Bottom:FindFirstChild("SurfaceGui") == nil then return end
	local tbl = m.getMaps(round)
	for i=1,#tbl do
		local frame = workspace.Lobby.Bottom.SurfaceGui:FindFirstChild("Map"..tostring(i))
		if frame then
			frame.Title.Text = tbl[i][1]
			frame.Special.Text = tbl[i][2]
		end
	end
	for _,k in pairs (workspace.Lobby.Bottom.SurfaceGui:children()) do
		if k.ClassName == "Frame" then
			k.Visible = true
		end
	end
end

m.CloseMapVote = function()
	if workspace:FindFirstChild("Lobby") == nil then return end
	if workspace.Lobby:FindFirstChild("Bottom") == nil then return end
	if workspace.Lobby.Bottom:FindFirstChild("SurfaceGui") == nil then return end
	for _,k in pairs (workspace.Lobby.Bottom.SurfaceGui:children()) do
		if k.ClassName == "Frame" then
			k.Visible = false
		end
	end
end

m.GetMapVoted = function() --returns a string of the name of the map
	if workspace:FindFirstChild("Lobby") == nil then return end
	if workspace.Lobby:FindFirstChild("Bottom") == nil then return end
	if workspace.Lobby.Bottom:FindFirstChild("SurfaceGui") == nil then return end
	local t,tbl,highest,votes = {},{},0,0
	for i=1,3 do
		local frame = workspace.Lobby.Bottom.SurfaceGui:FindFirstChild("Map"..tostring(i))
		if frame and frame:findFirstChild("Votes") then
			t[i] = frame.Votes.Value
		end
	end
	for i=1,3 do
		if t[i] and votes <= t[i] then
			highest = i
			votes = t[i]
		end
	end
	local picked = workspace.Lobby.Bottom.SurfaceGui:FindFirstChild("Map"..tostring(highest))
	if picked == nil then return end
	tbl[1] = picked.Title.Text
	tbl[2] = picked.Special.Text
	return tbl
end

m.pickSpecial = function() --returns a string of the name of the special round
	local function getTotal(t)
		local total = 0
		for i,k in pairs (t) do
			total = total + k[2]
		end
		return total
	end
	local val = math.random(1,getTotal(specialrounds))
	for e,tbl in pairs (specialrounds) do
		val = val - tbl[2]
		if val <= 0 then
			return tbl[1]
		end
	end
	return "Massacre" --if all nil
end

m.Spawn = function(plrs)
	if type(plrs) ~= "table" then plrs = {plrs} end
	if workspace:FindFirstChild("Map") == nil then return end
	if workspace:FindFirstChild("Map").PrimaryPart == nil then return end
	if workspace.Map:findFirstChild("BasePlate") == nil then return end
	local cframe = workspace.Map.PrimaryPart.CFrame
	local base = workspace.Map.BasePlate
	for _,k in pairs (plrs) do
		if k.Character and k.Character:findFirstChild("Humanoid") and k.Character:findFirstChild("Torso") and k.Character.Humanoid.Health > 0 then
			coroutine.resume(coroutine.create(function()
				local found = false
				repeat
					local ray = Ray.new(cframe.p+Vector3.new(math.random(-math.floor(base.Size.x/2),math.floor(base.Size.x/2)),200,math.random(-math.floor(base.Size.z/2),math.floor(base.Size.z/2))),Vector3.new(0,-500,0))
					local part,pos = workspace:FindPartOnRay(ray)
					if part and pos and pos.y > base.Position.y and pos.y < cframe.p.y + 1 then
						pos = pos + Vector3.new(0,7,0)
						k.Character:MoveTo(pos)
						found = true
						wait(.337)
						if k.Character.Torso.Position.y > cframe.p.y + 1 then
							found = false
						end
					end
				until found == true
			end))
		end
	end
end

m.PlaySound = function(id,t,looped,parent)
	if parent == nil then parent = workspace end
	if looped == nil then looped = true end
	if t == nil then t = 120 end
	coroutine.resume(coroutine.create(function()
		local s = Instance.new("Sound",parent)
		s.SoundId = "rbxassetid://"..tostring(id)
		s.Looped = looped
		s.Volume = .75
		s:Play()
		for i=1,math.floor(2*(t-3)) do
			wait(.5)
		end
		for i=.75,0,-.025 do
			s.Volume = i
			wait(.1)
		end
		s:Destroy()
	end))
end

m.ViewMap = function(plrs)
	if workspace.Remotes:FindFirstChild("ViewMap") == nil then return end
	if workspace:FindFirstChild("Map") == nil then return nil end
	if workspace.Map.PrimaryPart == nil then return nil end
	if workspace.Map:findFirstChild("BasePlate") == nil then return end
	local center = workspace.Map.PrimaryPart.Position - Vector3.new(0,10,0)
	local length = (workspace.Map.BasePlate.Size.x+workspace.Map.BasePlate.Size.z)/4
	for _,k in pairs (plrs) do
		workspace.Remotes.ServerToClient.ViewMap:FireClient(k,center,length)
	end
end

m.SaveData = function(plr)
	local ds = game:GetService("DataStoreService"):GetDataStore("Data_Alpha")
end

return m
