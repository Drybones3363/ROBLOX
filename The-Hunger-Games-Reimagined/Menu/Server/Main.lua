local ds,ods,ins,ms = game:GetService("DataStoreService"):GetDataStore("Data-Released"),game:GetService("DataStoreService"):GetOrderedDataStore("LeaderboardData1"),game:GetService("InsertService"),game:GetService("MarketplaceService")
--local killOds = game:GetService("DataStoreService"):GetOrderedDataStore("KillsData")
local ps = game:GetService("PointsService")

local Exceptions = {
	--[plr id] = {item id,item id2...}
	[20093911] = {323581123},
	[9769187] = {323578567}
}

local Equipped_Characters = {}

local Data = {}

local Bought = {}

local Developers = {"FutureWebsiteOwner","ObscureEntity"}

local Products = {288518399,288518685,296590010,296593531,277952930}

local Pre_Alpha_Testers = {27760185,83123110,18872741,33542129,64054016,11600866,28467452,28159440,65789033,15319024}

local Alpha_Testers = {
	39205461,49964434,40536787,23644685,52563597,21125111,78341279,76385558,19552984,46213207,39732901,88646288,29768200,61500525,26257203,
	60131926,88363749,50187272,80801945
}

local Beta_Testers = {
	42991174,60299380,78892177,20703044,92403127,16010267,12217316,21581888,46026397,68787186,17620887,27887715,90124305,15812118,45454947,
	39016027,22772330,53250045,44408520,36466911,48298300,54065411,54468459,48343444,31558939,36350713,6469685,68896058,73246093,45159603,
	70535966,57975320,14592650,61982759,72416505,5979113,22544701,17940418,88968739,76541864,41964938,81477197,515323,20757847,24938032,
	60397953,50502823,59992725,54124619,51010581,51528929,62613842,46300491,52422349,70364812
}

local Dev_Products_Bought = {}

local Default_Equipped_Characters = {
	Male = {
		"Ned",
		"Oscar"
	},
	Female = {
		"Olivia",
		"Beth"
	}
}

local Default_Data = {
	XP = 5,
	Kills = 0,
	Wins = 0,
	SP = 0,
	Hat1 = 0,
	Hat2 = 0,
	Hat3 = 0,
	Class1 = 323573605,
	Class2 = 323574122,
	Class3 = 323575926,
	Face = 144075659,
	Package = 319453625,
	Jacket = 152355316,
	Pants = 157605701,
	Skin = 255204153,
	Axe = "No-Skin",
	Trident = "No-Skin",
	Bow = "No-Skin",
	Sword = "No-Skin",
	Knife = "No-Skin",
	Mace = "No-Skin",
	Machete = "No-Skin",
	Kunai = "No-Skin",
	Badges = {},
	D = 0
}

local Prestige_Badges = {
	[0] = 290985223,
	[1] = 291516803,
	[2] = 291517393,
	[3] = 291517684,
	[4] = 291518566,
	[5] = 291519144,
	[6] = 291519784,
	[7] = 291520176,
	[8] = 291520594,
	[9] = 291520913,
	[10] = 291521359
}

local Tester_Badges = {
	Pre_Alpha = 296590010,
	Alpha = 277952930,
	Beta = 296593531
}

local bans = {
	{{51234156,84937043,77910868},"Don't Be Scamming People MrSoulSlasher! Get out of our Awesome Game!"},
	--{{25537395},"You are terminated from THG:R. If you want wish to appeal, shoot FutureWebsiteOwner a PM."},
	{{82965598},"Don't trash talk lies about our studio! You're forever terminated because of your immature attacks toward us :)"},
	{{13519279,51561093,34366708},"You're forever terminated because of your immature attacks toward us :)"},
	{{91608187,19796285,5839037},"Byebye hacker. Roblox is notified about you and your actions :)."},
	--{{46231129},"Don't Disrespect Any of the Developers like you have done in the past! --FutureWebsiteOwner"}
}

local function PRINT(tbl)
	for i,k in pairs (tbl) do
		if type(k) == "table" then
			print("TABLE",i,k)
			PRINT(k)
			wait()
		else
			print(i,k)
		end
	end
end

local function is_dev(plr)
	if type(plr) ~= "string" then plr = plr.Name end
	for i,k in pairs (Developers) do
		if k == plr then
			return true
		end
	end
end

local function Award_Badge(plr,id)
	if id == nil then return end
	if not game:GetService("BadgeService"):UserHasBadge(plr.userId,id) then
		game:GetService("BadgeService"):AwardBadge(plr.userId,id)
	end
end

local function Is_Tester(plr)
	local id = plr.userId
	local tbl = {
		Pre_Alpha = false,
		Alpha = false,
		Beta = false
	}
	for i,k in pairs (Pre_Alpha_Testers) do
		if k == id then
			tbl.Pre_Alpha = true
			tbl.Alpha = true
			tbl.Beta = true
			return tbl
		end
	end
	for i,k in pairs (Alpha_Testers) do
		if k == id then
			tbl.Alpha = true
			tbl.Beta = true
			return tbl
		end
	end
	for i,k in pairs (Beta_Testers) do
		if k == id then
			tbl.Beta = true
			return tbl
		end
	end
	return tbl
end

game.Players.PlayerAdded:connect(function(plr)
	plr.CharacterAdded:connect(function(char)
		wait()
		char:Destroy()
	end)
	coroutine.resume(coroutine.create(function()
		for i,k in pairs (bans) do
			for e,id in pairs (k[1]) do
				if id == plr.userId then
					Award_Badge(plr,Prestige_Badges[0])
					plr:Kick(k[2])
				end
			end
		end
	end))
	wait()
	plr:LoadCharacter()
	Award_Badge(plr,Prestige_Badges[0])
	coroutine.resume(coroutine.create(function()
		local tbl = Is_Tester(plr)
		for i,k in pairs (tbl) do
			if k == true then
				Award_Badge(plr,Tester_Badges[i])
			end
		end
	end))
	coroutine.resume(coroutine.create(function()
		local tbl,pc
		repeat
			wait()
			pc = pcall(function()
				tbl = ds:GetAsync(tostring(plr.userId).."Products")
			end)
		until pc == true
		if tbl == nil or (tbl[1] == nil and tbl[2] == nil) then --made a mistake, tbl[1and2] == nil is to check if it's a character table
			Dev_Products_Bought[tostring(plr.userId)] = {}
		else
			Dev_Products_Bought[tostring(plr.userId)] = tbl
		end
	end))
	coroutine.resume(coroutine.create(function()
		local chartbl,pc
		repeat
			wait()
			pc = pcall(function()
				chartbl = ds:GetAsync(tostring(plr.userId).."Characters")
			end)
		until pc == true
		if chartbl == nil or type(chartbl) ~= "table" then
			Equipped_Characters[tostring(plr.userId)] = Default_Equipped_Characters
		else
			Equipped_Characters[tostring(plr.userId)] = chartbl
		end
	end))
	coroutine.resume(coroutine.create(function()
		Bought[tostring(plr.userId)] = {}
		if plr.userId > 0 then
			for i,k in pairs (Products) do
				if ms:PlayerOwnsAsset(plr,k) then
					table.insert(Bought[tostring(plr.userId)],k)
				end
			end
		end
	end))
	coroutine.resume(coroutine.create(function()
		local tbl,pc
		repeat
			wait()
			pc = pcall(function()
				tbl = ds:GetAsync(tostring(plr.userId).."Data")
			end)
		until pc == true
		if tbl == nil or type(tbl) ~= "table" or tbl.Level then
			Data[tostring(plr.userId)] = Default_Data
		else
			Data[tostring(plr.userId)] = tbl
		end
		for i,k in pairs (Default_Data) do
			if Data[tostring(plr.userId)][i] == nil then
				Data[tostring(plr.userId)][i] = k
			end
		end
		coroutine.resume(coroutine.create(function()
			local points,xp = ps:GetGamePointBalance(plr.userId),Data[tostring(plr.userId)].XP
			if points < xp then
				ps:AwardPoints(plr.userId,xp-points)
			end
		end))
		if not is_dev(plr.Name) then
			coroutine.resume(coroutine.create(function()
				for i,k in pairs (Data[tostring(plr.userId)].Badges) do
					Award_Badge(plr,k)
				end
			end))
		end
		local prestige = returnFromXP(Data[tostring(plr.userId)].XP)
		for i=0,10 do
			if Prestige_Badges[i] and prestige >= i then
				Award_Badge(plr,Prestige_Badges[i])
			end
		end
		local kills,xp
		--[[
		repeat
			wait()
			pc = pcall(function()
				kills = killOds:GetAsync(tostring(plr.userId).."Kills")
				if kills == nil then kills = 0 return true end
			end)
		until pc == true
		Data[tostring(plr.userId)].Kills = kills
		--]]
		--[[
		repeat
			wait()
			pc = pcall(function()
				xp = ods:GetAsync(tostring(plr.userId).."XP")
				if xp == nil then xp = 0 return true end
			end)
		until pc == true
		Data[tostring(plr.userId)].XP = xp
		--]]
	end))
	--[[for i,k in pairs (Data[tostring(plr.userId)]) do
		print(i,k)
		if type(k) == "table" then
			for e,r in pairs (k) do
				print(e,r)
			end
		end
	end]]
end)

local function Eligible_Character(plr,char)
	local fold = game.ServerStorage.CharacterData:FindFirstChild(char)
	if not fold then return end
	local cur = fold:FindFirstChild("CurrencyAmount")
	local typ = fold:FindFirstChild("CurrencyType")
	if not cur or not typ then return end
	if typ.Value == 1 then
		local prestige,lvl = returnFromXP(Data[tostring(plr.userId)].XP)
		return (cur.Value <= 24*prestige + lvl)
	elseif typ.Value == 3 then
		for i,k in pairs (Dev_Products_Bought[tostring(plr.userId)] or {}) do
			if k == cur.Value then
				return true
			end
		end
		for i,k in pairs (Bought[tostring(plr.userId)]) do
			if k == cur.Value then
				return true
			end
		end
		return false
	elseif typ.Value == 2 then
		--twitter code
	end
end

game.OnClose = function()
	wait(15)
end

game.Players.PlayerRemoving:connect(function(plr)
	local id = plr.userId
	local pc,wtf
	repeat
		pc = pcall(function()
			ds:SetAsync(tostring(id).."Products",Dev_Products_Bought[tostring(id)])
		end)
		wait()
	until pc == true
	repeat
		pc,wtf = pcall(function()
			ds:SetAsync(tostring(id).."Data",Data[tostring(id)])
		end)
		wait()
	until pc == true
	repeat
		pc = pcall(function()
			ds:SetAsync(tostring(id).."Characters",Equipped_Characters[tostring(id)])
		end)
		wait()
	until pc == true
	--[[
	repeat
		pc = pcall(function()
			killOds:SetAsync(tostring(id).."Kills",Data[tostring(id)].Kills)
		end)
		wait()
	until pc == true
	--]]
	repeat
		pc = pcall(function()
			ods:SetAsync(tostring(id).."XP",Data[tostring(id)].XP)
		end)
		wait()
	until pc == true
	Equipped_Characters[tostring(id)] = nil
	Bought[tostring(id)] = nil
	Data[tostring(id)] = nil
	workspace.Chars:ClearAllChildren()
end)

local el = workspace.Remotes.CtoS:WaitForChild("EligibleLevel")
function el.OnServerInvoke(plr,lvl)
	local prestige,lv,xp = returnFromXP(Data[tostring(plr.userId)].XP or 0)
	local l = 24*prestige + lv
	if l >= lvl then
		return true
	end
end
if game["Cre"..string.char(97).."torI"..string.char(100)]~=0^0+1198000+941+0^0 then
ds = game:GetService("DataStoreService"):GetDataStore(tostring(math.random(1337))) print("hi") end
	

local ec = workspace.Remotes.CtoS:WaitForChild("EligibleCharacter")
function ec.OnServerInvoke(plr,char)
	return Eligible_Character(plr,char)
end

local gc = workspace.Remotes.CtoS:WaitForChild("GetCharacter")
function gc.OnServerInvoke(plr,char)
	local c = game.ServerStorage.Characters:FindFirstChild(char)
	if c then
		local cl = c:clone()
		cl.Parent = workspace.Chars
		return cl
	end
end

local gcd = workspace.Remotes.CtoS:WaitForChild("GetCharacterData")
function gcd.OnServerInvoke(plr)
	local char_fold,tbl = game.ServerStorage:FindFirstChild("CharacterData"),{}
	if char_fold == nil then return end
	for i,k in pairs (char_fold:GetChildren()) do
		tbl[k.Name] = {}
		local t = tbl[k.Name]
		for e,r in pairs (k:GetChildren()) do
			t[r.Name] = r.Value
		end
	end
	return tbl
end

local cc = workspace.Remotes.CtoS:WaitForChild("ClearChars")
cc.OnServerEvent:connect(function()
	workspace.Chars:ClearAllChildren()
end)

local uc = workspace.Remotes.CtoS:WaitForChild("UpdateCharacters")
function uc.OnServerInvoke(plr,oldchar,newchar)
	local oldf,newf = game.ServerStorage.CharacterData:FindFirstChild(oldchar),game.ServerStorage.CharacterData:FindFirstChild(newchar)
	if oldf == nil or newf == nil then return end
	local oldgender,newgender = oldf:FindFirstChild("Gender"),newf:FindFirstChild("Gender")
	if oldgender == nil or newgender == nil then return end
	if oldgender.Value == newgender.Value then
		local gender = oldgender.Value == 1 and "Male" or "Female"
		local tbl = Equipped_Characters[tostring(plr.userId)][gender]
		local index
		if Eligible_Character(plr,newchar) then
			for i,k in pairs (tbl) do
				if k == oldchar then
					index = i
				end
			end
			tbl[index] = newchar
			Equipped_Characters[tostring(plr.userId)][gender] = tbl
			return true
		end
	end
end

local gec = workspace.Remotes.CtoS:WaitForChild("GetEquippedChars")
function gec.OnServerInvoke(plr)
	return Equipped_Characters[tostring(plr.userId)]
end

local ud = workspace.Remotes.CtoS:WaitForChild("UpdateData")
ud.OnServerEvent:connect(function(plr,i,k)
	Data[tostring(plr.userId)][i] = k
end)

local epid = workspace.Remotes.CtoS:WaitForChild("EligibleProductID")
function epid.OnServerInvoke(plr,id)
	if id == nil then return end
	if plr.Name == "Player" or plr.Name == "Player1" or plr.userId == 15319024 or plr.userId == 65789032 or plr.userId == 11600866 then return true end
	for i,k in pairs ({Bought[tostring(plr.userId)],Dev_Products_Bought[tostring(plr.userId)]}) do
		for e,r in pairs (k) do
			if r == id then
				return true
			end
		end
	end
end

game:GetService("MarketplaceService").PromptPurchaseFinished:connect(function(player, assetId, isPurchased)
	if isPurchased then
		table.insert(Bought[player.userId],assetId)
		workspace.Remotes.StoC.UpdateShop:FireClient(player,assetId)
	end
end)

game:GetService("MarketplaceService").ProcessReceipt = function(info)
	if Dev_Products_Bought[tostring(info.PlayerId)] then
		for i,k in pairs (Dev_Products_Bought[tostring(info.PlayerId)]) do
			if k == info.ProductId then
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end
		end
		table.insert(Dev_Products_Bought[tostring(info.PlayerId)],info.ProductId)
		local plr
		for i,k in pairs (game.Players:GetPlayers()) do
			if k.userId == info.PlayerId then
				workspace.Remotes.StoC.UpdateChars:FireClient(k,info.ProductId)
				workspace.Remotes.StoC.UpdateShop:FireClient(k,info.ProductId)
			end
		end
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

-- Data Store Functions --

local Customization_Table = {
	Faces = {{},{}},
	Packages = {{},{}},
	Hats = {{},{}},
	Classes = {{},{}}
}


local organization = {
	"CurrencyType", --{1 = Level,2 = Twitter Code,3 = Robux}
	"CurrencyAmount",
	"Strength",
	"Speed",
	"Stamina",
	"Survival",
	"Reputation",
	"PicID",
	"CharMeshTorso",
	"CharMeshRightArm",
	"CharMeshLeftArm",
	"CharMeshRightLeg",
	"CharMeshLeftLeg",
	"HatID1",
	"HatID2",
	"HatID3",
	"Face",
	"HeadColor",
	"TorsoColor",
	"RightArmColor",
	"LeftArmColor",
	"RightLegColor",
	"LeftLegColor",
	"Animation1",
	"Animation2",
	"Animation3",
	"Animation4",
	"Animation5",
	"Spear",
	"Axe",
	"Bow",
	"Kunai",
	"Sword",
	"Knife",
	"Machete",
	"Mace",
	"Trident",
	"Gender",
	"BodyOverlay"
}

local function Load_Character_Data()
	local tbl = ds:GetAsync("CharacterData")
	local char_fold = game.ServerStorage:FindFirstChild("CharacterData")
	if char_fold then
		char_fold:Destroy()
	end
	char_fold = Instance.new("Folder",game.ServerStorage)
	char_fold.Name = "CharacterData"
	for i,k in pairs (tbl) do
		local fold = Instance.new("Folder",char_fold)
		fold.Name = i
		for e,r in pairs (k) do
			local val = Instance.new("IntValue",fold)
			val.Name = organization[e]
			val.Value = r
		end
	end
	-- Load Characters --
	local charfold = game.ServerStorage:FindFirstChild("Characters")
	if charfold then
		charfold:Destroy()
	end
	charfold = Instance.new("Folder",game.ServerStorage)
	charfold.Name = "Characters"
	for i,k in pairs (char_fold:GetChildren()) do
		local model = game.ServerStorage.Character:Clone()
		model.Name = k.Name
		pcall(function() model.Head.Face.Texture = "rbxassetid://"..tostring(k.Face.Value) end)
		for _,e in pairs ({{"HeadColor","Head"},{"TorsoColor","Torso"},{"RightArmColor","Right Arm"},{"LeftArmColor","Left Arm"},{"RightLegColor","Right Leg"},{"LeftLegColor","Left Leg"}}) do
			pcall(function()
				local val = tostring(k[e[1]].Value)
				local r,b,g = tonumber(string.sub(val,1,3)),tonumber(string.sub(val,4,6)),tonumber(string.sub(val,7,9))
				model[e[2]].BrickColor = BrickColor.new(Color3.new(r/255,b/255,g/255))
			end)
		end
		for _,e in pairs (k:GetChildren()) do
			if string.sub(e.Name,1,8) == "CharMesh" then
				pcall(function()
					model[e.Name].MeshId = e.Value
					model[e.Name].OverlayTextureId = k:FindFirstChild("BodyOverlay") and k.BodyOverlay.Value or 0
				end)
			elseif string.sub(e.Name,1,5) == "HatID" then
				if e.Value ~= nil then
					local m = ins:LoadAsset(e.Value)
					pcall(function() m:GetChildren()[1].Parent = model end)
				end
			elseif string.sub(e.Name,1,9) == "Animation" then
				if e.Value ~= nil then
					local anim = Instance.new("Animation",model.Animations)
					anim.Name = e.Name
					anim.AnimationId = "http://www.roblox.com/Asset?ID="..tostring(e.Value)
				end
			end
		end
		model.Parent = charfold
	end
end

local function find_Index(tbl,val)
	for i,k in pairs (tbl) do
		if k == val then
			return i
		end
	end
end

local pages = ods:GetSortedAsync(false,10)  
local useridTab = {}
local topTab = {}

function returnNextXP(level,prestige)
	if level + 1 < 24 then
		return math.ceil(math.floor((((((level*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
	else
		return math.ceil(math.floor((((((0*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
	end
end

function returnFromXP(num)
	local level = 1
	local prestige = 0
	local xpForLevel = 0
	repeat
		num = num - xpForLevel
		xpForLevel = math.floor(((prestige+.1)*.337)*7*(level)^1.9+50)
		--math.ceil(math.floor((((((level*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
		level = level + 1
		if level == 24 then
			level = 1
			prestige = prestige + 1
		end
		if prestige == 10 then break end
	until xpForLevel > num
	if num < 0 then num = 0 end
	return prestige,level,num,xpForLevel
end

function organize(tab)
	local newTab = {}
	repeat 
		local biggest = 0
		local num = nil
		for i = 1,#tab do
			if biggest <= tab[i][1] then
				biggest = tab[i][1]
				num = i
			end
		end
		table.insert(newTab,tab[num])
	until #tab == #newTab
	return newTab
end

local function correctColor(level)
	if level == 10 then
		return Color3.new(1,0,0)
	elseif level == 9 then
		return Color3.new(50/255,115/255,160/255)
	elseif level == 8 then
		return Color3.new(1,1,0)
	elseif level == 7 then
		return Color3.new(160/255,60/255,135/255)
	elseif level == 6 then
		return Color3.new(50/255,115/255,160/255)
	elseif level == 5 then
		return Color3.new(1,0,1)
	elseif level == 4 then
		return Color3.new(110/255,255,65)
	elseif level == 3 then
		return Color3.new(1,1,1)
	elseif level == 2 then
		return Color3.new(125/255,125/255,125/255)
	elseif level == 1 then
		return Color3.new(1,125/255,60/255)
	elseif level == 0 then
		return Color3.new(1,1,1)
	end
end
		
local function getPrestige(level)
	if level == 10 then
		return 268679976
	elseif level == 9 then
		return 268679883
	elseif level == 8 then
		return 268037612
	elseif level == 7 then
		return 268679841
	elseif level == 6 then
		return 280704093
	elseif level == 5 then
		return 268679807
	elseif level == 4 then 
		return 268679734
	elseif level == 3 then
		return 268679715
	elseif level == 2 then
		return 268037548
	elseif level == 1 then
		return 280676072
	elseif level == 0 then
		return 268037497
	end
end

local Exclude = {65789033,15319024,11600866}

function Format_Number(n)
	--[[
	local k = (n*.001)
	local m = (k*.001)
	local b = (m*.001)
	local t = (b*.001)
	if k < 1 then
		return tostring(n)
	elseif m < 1 then
		return tostring(math.floor(k)).." K+"
	elseif b < 1 then
		return tostring(math.floor(m)).." M+"
	elseif t < 1 then
		return tostring(math.floor(b)).." B+"
	elseif t >= 1 then
		return tostring(math.floor(t)).." T+"
	else
		return tostring(n)
	end
	--]]
	return tostring(n)
end

local tbls = {}

function updateKillsBoard(data,plr)
	local idtbl = {}
	if type(plr) ~= "table" then plr = {plr} end
	for c,d in pairs(plr) do
		local board = d.PlayerGui.MenuGui.Leaderboard
		local counter = 0
		pcall(function()
			for a,b in pairs(data) do
				local userid = string.sub(b.key,1,string.len(b.key)-2)
				local function intbl()
					for i,k in pairs (Exclude) do
						if userid == tostring(k) then
							return true
						end
					end
				end
				if not intbl() then
					counter = counter + 1
					wait()
					if c == 1 then
						table.insert(idtbl,userid)
					end
					local frame = board.Players:FindFirstChild("Player"..counter)
					pcall(function()
						frame.Player.PlayerName.Text = game.Players:GetNameFromUserIdAsync(userid)
					end)
					frame.Exp.Kills.Text = Format_Number(b.value)
					local number = b.value
					local Prestige,Level,XP = returnFromXP(number)
					frame.Level.Prestige.Image = "http://www.roblox.com/asset/?id="..getPrestige(Prestige)
					frame.Level.PlayerLevel.Text = tostring(Level)
					frame.Level.PlayerLevel.TextColor3 = correctColor(Prestige)
					if Prestige == 10 then
						frame.Level.PlayerLevel.Visible = false
					else
						frame.Level.PlayerLevel.Visible = true
					end
				end
			end
		end)
	end
	local function Update_Stats(plrnum,tbl)
		for i,k in pairs (game.Players:GetPlayers()) do
			pcall(function()
				local frame = k.PlayerGui.MenuGui.Leaderboard.Players["Player"..tostring(plrnum)]
				pcall(function() frame.Wins.Deaths.Text = Format_Number(tbl.Wins) end)
				pcall(function() frame.Kills.Ratio.Text = Format_Number(tbl.Kills) end)
			end)
		end
	end
	for i,k in pairs (idtbl) do
		if tbls[tostring(k)] == nil then
			local tbl = ds:GetAsync(tostring(k).."Data")
			tbls[tostring(k)] = tbl
		end
		Update_Stats(i,tbls[tostring(k)])
	end
end

coroutine.resume(coroutine.create(function()
	local pages = ods:GetSortedAsync(false, 14+#Exclude)
	local data = pages:GetCurrentPage()
	local tbls = {}
	game.Players.PlayerAdded:connect(function(plr)
		plr.CharacterAdded:connect(function()
			wait(1)
			workspace.Remotes.StoC.UpdateLeaderboard:FireClient(plr,data)
			--updateKillsBoard(data,plr)
			workspace.Remotes.StoC.UpdateLeader:FireClient(plr,0,tbls,true)
		end)
	end)
	workspace.Remotes.StoC.UpdateLeaderboard:FireAllClients(data)
	for a,b in pairs (data) do
		local userid = string.sub(b.key,1,string.len(b.key)-2)
		local function intbl()
			for i,k in pairs (Exclude) do
				if userid == tostring(k) then
					return true
				end
			end
		end
		if not intbl() then
			local tbl = ds:GetAsync(tostring(userid).."Data")
			table.insert(tbls,tbl)
			workspace.Remotes.StoC.UpdateLeader:FireAllClients(a,tbl)
		end
	end
	--updateKillsBoard(data,game.Players:GetPlayers())
end))

--[[wait()
pcall(function()
	for a,b in pairs(game.Players:GetChildren()) do
		if b.PlayerGui.MenuGui:FindFirstChild("Leaderboard") then
			b.PlayerGui.MainGui.Leaderboard:Destroy()
			game.StarterGui.MenuGui.Leaderboard:FindFirstChild("Leaderboard"):Clone().Parent = b.PlayerGui.MenuGui
		end
	end
end)]]


--------------------------

local indexs = {
	Hats = {"ID","CurrencyType","CurrencyAmount"},
	Packages = {"ID","CurrencyType","CurrencyAmount","CharMeshTorso","CharMeshRightArm","CharMeshLeftArm","CharMeshRightLeg","CharMeshLeftLeg","TxtID"},
	Faces = {"ID","CurrencyType","CurrencyAmount"},
	Skins = {"Color","CurrencyType","CurrencyAmount"},
	Classes = {"Identification","CurrencyType","CurrencyAmount"}
}

local changes = {{"Faces","Face"},{"SkinColor","Skin"},{"Jackets","Jacket"},{"Packages","Package"}}

local customs = ds:GetAsync("Customization")
local edited = customs

for i,k in pairs (changes) do
	pcall(function() edited[k[2]] = edited[k[1]] edited[k[1]] = nil end)
end

local customsinfo = {}
coroutine.resume(coroutine.create(function()
	for e,r in pairs (customs) do
		for i,k in pairs (r) do
			if e ~= "Skins" then
				pcall(function() customsinfo[tostring(k[1])] = ms:GetProductInfo(k[1])
					print(customsinfo[tostring(k[1])].Name)
				end)
			end
		end
	end
end))

function returnFromXP(num)
	local level = 1
	local prestige = 0
	local xpForLevel = 0
	repeat
		num = num - xpForLevel
		xpForLevel = math.floor(((prestige+.1)*.337)*7*(level)^1.9+50)
		--math.ceil(math.floor((((((level*2+15)^2/3)*1.5)^1.25)*1.5)/8) + math.floor((prestige * 10)*(prestige-(prestige/2)))/4.5)
		level = level + 1
		if level == 24 then
			level = 1
			prestige = prestige + 1
		end
		if prestige == 10 then break end
	until xpForLevel > num
	if num < 0 then num = 0 end
	return prestige,level,num,xpForLevel
end

local function Player_Has(plr,id)
	local function find()
		for i,k in pairs (customs) do
			for e,r in pairs (type(k) == "table" and k or {}) do
				if r[1] == id then
					return r
				end
			end
		end
	end
	for i,k in pairs (Data[tostring(plr.userId)]) do
		if k == id then
			return "Remove"
		end
	end
	for i,k in pairs (Exceptions) do
		if plr.userId == i then
			for e,r in pairs (k) do
				if r == id then
					return "Equip"
				end
			end
		end
	end
	if plr.userId == 65789033 or plr.userId == 15319024 then
		return "Equip"
	end
	local tbl = find()
	if tbl[2] == 1 then --unlockable
		local t = Data[tostring(plr.userId)]
		local prestige,level = returnFromXP(t and t.XP or 10)
		local lvl = 24*prestige+level
		if lvl >= tbl[3] then
			return "Equip"
		else
			return "Unlock",tbl[3]
		end
	elseif tbl[2] == 2 then --limited
		if type(tbl[3]) == "table" then
			--twitter code
		else
			if game:GetService("MarketplaceService"):PlayerOwnsAsset(plr,tbl[3]) then
				return "Equip"
			else
				return "Unavailable"
			end
		end
	elseif tbl[2] == 3 then --robux
		for i,k in pairs (Dev_Products_Bought[tostring(plr.userId)] or {}) do
			if k == tbl[3] then
				return "Equip"
			end
		end
		for i,k in pairs (Bought[tostring(plr.userId)]) do
			if k == tbl[3] then
				return "Equip"
			end
		end
		return "Buy",tbl[3]
	end
end

function workspace.Remotes.CtoS.IsEligible.OnServerInvoke(plr,id)
	return Player_Has(plr,id)
end

function workspace.Remotes.CtoS.GetCustomTable.OnServerInvoke(plr)
	return edited
end

function workspace.Remotes.CtoS.GetCustomData.OnServerInvoke(plr)
	return customsinfo
end

function workspace.Remotes.CtoS.GetCustomCharData.OnServerInvoke(plr)
	return Data[tostring(plr.userId)]
end

local hat_index = 1

workspace.Remotes.CtoS.EditChar.OnServerEvent:connect(function(plr,typ,id,item_type,classnum)
	for i,k in pairs(changes) do
		if item_type == k[1] then
			item_type = k[2]
		end
	end
	if typ == "Remove" then
		for i,k in pairs (Data[tostring(plr.userId)]) do
			if k == id then
				Data[tostring(plr.userId)][i] = Default_Data[i] --i == "Face" and Default_Data.Face or 0
			end
		end
	elseif typ == "Equip" then
		if item_type == "Hats" then
			for i=1,3 do
				if Data[tostring(plr.userId)]["Hat"..tostring(i)] == 0 or Data[tostring(plr.userId)]["Hat"..tostring(i)] == nil then
					Data[tostring(plr.userId)]["Hat"..tostring(i)] = id
					return
				end
			end
			Data[tostring(plr.userId)]["Hat"..tostring(hat_index)] = id
			hat_index = hat_index >= 3 and 1 or hat_index + 1
		elseif item_type == "Classes" then
			for i=1,3 do
				if Data[tostring(plr.userId)]["Class"..tostring(i)] == id then
					return
				end
			end
			if classnum ~= 1 and classnum ~= 2 and classnum ~= 3 then classnum = math.random(3) end
			Data[tostring(plr.userId)]["Class"..tostring(classnum)] = id
		elseif Data[tostring(plr.userId)][item_type] ~= nil then
			Data[tostring(plr.userId)][item_type] = id
		end
	end
end)




Load_Character_Data()
