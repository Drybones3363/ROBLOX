local bans = {28704965,641139,61190438,37998759,10390103,40088614,9420953,25800799,83335320,60809723,49713163,43949412,6784581,38018671,15499235,23677739,77030667,71209663,77104779,19473129,20041028,17198781,8975156,67117851,25739203,25656892,24665617,37809289,46100020,51234156,50743516,6305766}
--61190438 faved cube eat cube in comments,37998759 said buy just to dislike,10390103 said go to jail in the real world for making this game
local ms,ps,bs,ds = game:GetService("MarketplaceService"),game:GetService("PointsService"),game:GetService("BadgeService"),game:GetService("DataStoreService"):GetDataStore("Shop")
local place
if game.PlaceId and game.PlaceId > 0 then
	place = ms:GetProductInfo(game.PlaceId)
end
local Points_On_Entry = 25
local starterdata = {Coins = 25}
local admins = {65789033,68896058}

local Dev_Products = {
	[100] = 24414565,
	[500] = 24414569,
	[1000] = 24414570,
	[2500] = 24414574
}

game.Players.PlayerAdded:connect(function(p)
	p.CharacterAdded:connect(function(c)
		c:WaitForChild("Humanoid")
		c.Humanoid.Health = 0
	end)
	coroutine.resume(coroutine.create(function()
		local isAdmin
		for _,k in pairs (admins) do
			if p.userId == k then
				isAdmin = true
			end
		end
		if isAdmin then
			p.Chatted:connect(function(msg)
				if msg:sub(1,3) == ":k " and msg:len() > 3 then
					local plr = msg:sub(4,msg:len())
					local kicker
					for _,k in pairs (game.Players:GetPlayers()) do
						if k.Name:sub(1,plr:len()) == plr then
							kicker = k
						end
					end
					if kicker then
						kicker:Kick()
					end
				elseif msg:sub(1,3) == ":b " and msg:len() > 3 then --bans from server
					local plr = msg:sub(4,msg:len())
					local banner
					for _,k in pairs (game.Players:GetPlayers()) do
						if k.Name:sub(1,plr:len()) == plr then
							banner = k
						end
					end
					if banner then
						table.insert(bans,banner.userId)
						banner:Kick()
					end
				end
			end)
		end
	end))
	coroutine.resume(coroutine.create(function()
		for _,k in pairs (bans) do
			if p.userId == k then
				p:Kick()
			end
		end
	end))
	coroutine.resume(coroutine.create(function() --Beta Testing Badge
		if place.IsForSale == true then
			--bs:AwardBadge(p.userId,253657270)
		end
	end))
	coroutine.resume(coroutine.create(function()
		if ps:GetGamePointBalance(p.userId) == 0 then
			if place.IsForSale == true then
				ps:AwardPoints(p.userId,4*Points_On_Entry)
			else
				ps:AwardPoints(p.userId,Points_On_Entry)
			end
		end
	end))
	local sgui = Instance.new("ScreenGui",p.PlayerGui)
	local fra = Instance.new("Frame",sgui)
	fra.Size = UDim2.new(2,0,2,0)
	fra.Position = UDim2.new(-.5,0,-.5,0)
	fra.BackgroundColor3 = Color3.new(0,0,0)
	local load = Instance.new("TextLabel",fra)
	load.Size = UDim2.new(1,0,1,0)
	load.Text = "Loading..."
	load.TextScaled = true
	load.Font = Enum.Font.SourceSansBold
	load.TextColor3 = Color3.new(1,1,1)
	load.BackgroundTransparency = 1
	repeat wait(.5) until workspace.GameReady.Value
	local lead = Instance.new("Folder",p)
	lead.Name = "leaderstats"
	local int = Instance.new("IntValue",lead)
	int.Value = 0
	int.Name = "Size"
	coroutine.resume(coroutine.create(function()
		while wait(.05) and p ~= nil do
			local val = 0
			for _,k in pairs (workspace.Cells:children()) do
				if k.Name == p.Name.."'s Cell" then
					pcall(function()
						val = val + tonumber(k.Dot.BGui.lblMass.Text)
					end)
				end
			end
			int.Value = val
			if val >= 500 then
				if not ms:PlayerOwnsAsset(p,259896452) then
					bs:AwardBadge(p.userId,259896452)
				end
				if val >= 1000 then
					if not ms:PlayerOwnsAsset(p,259896510) then
						bs:AwardBadge(p.userId,259896510)
					end
					if val >= 3000 then
						if not ms:PlayerOwnsAsset(p,264968856) then
							bs:AwardBadge(p.userId,264968856)
						end
					end
				end
			end
		end
	end))
	coroutine.resume(coroutine.create(function()
		Instance.new("Folder",game.ServerStorage.CustomStuff).Name = tostring(p.userId)
		if (p.userId > 0 and ms:PlayerOwnsAsset(p,258749259)) or p.Name == "Player1" then
			Instance.new("Folder",game.ServerStorage.CustomStuff[tostring(p.userId)]).Name = "Textures"
		end
		if (p.userId > 0 and ms:PlayerOwnsAsset(p,258749492)) or p.Name == "Player1" or p.Name == "ObscureEntity" then
			Instance.new("Folder",game.ServerStorage.CustomStuff[tostring(p.userId)]).Name = "Music"
		end
		if (p.userId > 0 and ms:PlayerOwnsAsset(p,258749387)) or p.Name == "Player1" then
			Instance.new("Folder",game.ServerStorage.CustomStuff[tostring(p.userId)]).Name = "Particles"
		end
	end))
	coroutine.resume(coroutine.create(function()
		local bool = Instance.new("BoolValue",game.ServerStorage.ObscureInnovations)
		bool.Name = tostring(p.userId)
		if p:IsInGroup(1198943) then
			bool.Value = true
		else
			bool.Value = false
		end
	end))
	if game.ServerStorage:FindFirstChild("PointData") == nil then
		local f = Instance.new("Folder",game.ServerStorage) f.Name = "PointData"
	end
	local pp = Instance.new("IntValue",game.ServerStorage.PointData)
	pp.Name = tostring(p.userId)
	pp.Value = 0
	if p.userId > 0 then
		coroutine.resume(coroutine.create(function()
			repeat
				if math.floor(pp.Value/10) >= 1 then
					local oldval = pp.Value
					local s = pcall(function() ps:AwardPoints(p.userId,math.floor(oldval/10)) end)
					if s then
						pp.Value = pp.Value - 10*math.floor(pp.Value/10)
					end
				end
				for i=1,10 do
					wait(.666)
				end
			until pp == nil
		end))
	end
	if game.ServerStorage:FindFirstChild("PlayerData") == nil then
		local f = Instance.new("Folder",game.ServerStorage) f.Name = "PlayerData"
	end
	local pdata = game.ServerStorage.PlayerData
	local f = Instance.new("Folder",pdata)
	f.Name = tostring(p.userId)
	local settings = Instance.new("Folder",f)
	settings.Name = "Settings"
	local b1,b2 = Instance.new("BoolValue",settings),Instance.new("BoolValue",settings)
	b1.Name = "DarkTheme" b2.Name = "RainbowDot"
	local data = ds:GetAsync(tostring(p.userId))
	if data == nil then
		data = starterdata
	end
	for i,k in pairs (starterdata) do
		if data[i] == nil then
			data[i] = k
		end
	end
	local coins = Instance.new("IntValue",f)
	coins.Name = "Coins"
	coins.Value = data.Coins
	coins.Changed:connect(function(v)
		workspace.Remotes.StoC.ChangedData:FireClient(p,"Coins",v)
	end)
	local fol = Instance.new("Folder",game.ServerStorage.PlayerCodesUsed)
	fol.Name = tostring(p.userId)
	local tdata = ds:GetAsync("t"..tostring(p.userId))
	if tdata == nil then
		ds:SetAsync("t"..tostring(p.userId),{})
		tdata = {}
	end
	for i,k in pairs (tdata) do
		local fo = Instance.new("Folder",fol)
		fo.Name = k
	end
	wait(1)
	p:LoadCharacter()
	sgui:Destroy()
	wait(.337)
	pcall(function()
		workspace.Remotes.StoC.ChangedData:FireClient(p,"Coins",coins.Value)
	end)
end)

local function check_Table(tbl)
	for i,k in pairs (tbl) do
		if type(k) == "table" then
			local bool = check_Table(k)
			if bool == true then
				return true
			end
		else
			if type(k) == "number" and (k == 1) then
				return true
			end
		end
	end
	return false
end

game.Players.PlayerRemoving:connect(function(p)
	local n,id = p.Name,p.userId
	for _,k in pairs (workspace.Cells:children()) do
		if k.Name == n.."'s Cell" then
			k:Destroy()
		end
	end
	coroutine.resume(coroutine.create(function()
		game.ServerStorage.ObscureInnovations[tostring(id)]:Destroy()
	end))
	local data,t,tdata,tt = game.ServerStorage.PlayerData:FindFirstChild(tostring(id)),{},game.ServerStorage.PlayerCodesUsed:FindFirstChild(tostring(id)),{}
	if data then
		for _,k in pairs (data:children()) do
			if k.Name ~= "Settings" then
				if #k:children() == nil or #k:children() == 0 then
					t[k.Name] = k.Value
				else
					t[k.Name] = {}
					local tb = ds:GetAsync(k.Name)
					for i,e in pairs (tb) do
						if e[1] ~= nil then
							if k:FindFirstChild(e[1]) then
								t[k.Name][i] = k[e[1]].Value
							end
						end
					end
				end
			end
		end
	end
	--print(check_Table(t))
	--if check_Table(t) == true then
		ds:SetAsync(tostring(id),t)
	--end
	data:Destroy()
	if tdata then
		for _,k in pairs (tdata:children()) do
			table.insert(tt,k.Name)
		end
	end
	ds:SetAsync("t"..tostring(id),tt)
	pcall(function() game.ServerStorage.PointData[tostring(id)]:Destroy() end)
	pcall(function() game.ServerStorage.CustomStuff[tostring(id)]:Destroy() end)
end)



ms.ProcessReceipt = function(tbl)
	local function findReward(id)
		for i,k in pairs (Dev_Products) do
			if k == id then
				return i
			end
		end
	end
	local reward = findReward(tbl.ProductId)
	print(reward)
	if reward then
		local fold = game.ServerStorage.PlayerData:WaitForChild(tostring(tbl.PlayerId))
		local coins = fold:WaitForChild("Coins")
		coins.Value = coins.Value + reward
	end
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

--[[
	Twitter Codes:
	
	Code Table:
	[1] = code
	[2] = type of reward {1=coins,2=texture,3=audio,4=particle}
	[3] = amount/name of reward
	[4] = expired

--]]

_G.Updated = ""

repeat
	local tab = ms:GetProductInfo(game.PlaceId)
	if _G.Updated ~= tab.Updated then
		game.ServerStorage.TwitterCodes:ClearAllChildren()
		local tbl = ds:GetAsync("TwitterCodes")
		if tbl == nil then tbl = {} end
		for i,k in pairs (tbl) do
			local f = Instance.new("Folder",game.ServerStorage.TwitterCodes)
			f.Name = k[1]
			local r = Instance.new("IntValue",f)
			r.Name = "Reward"
			r.Value = k[2]
			if type(k[3]) == "number" then
				local a = Instance.new("IntValue",f)
				a.Name = "Amount"
				a.Value = k[3]
			else
				local a = Instance.new("StringValue",f)
				a.Name = "Amount"
				a.Value = k[3]
			end
			local e = Instance.new("BoolValue",f)
			e.Name = "Expired"
			e.Value = k[4]
		end
		_G.Updated = tab.Updated
	end
	wait(14)
until nil
