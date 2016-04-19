local Num_of_Bots = 100
local Bot_Name_Prefix = "Bot "

local Bot_Starting_Bux = 1.337e6
local Average_Bot_Check_Item_Time = 25

local Name_of_Currency= "Bux"

-- ROBLOX Services --

local ms = game:GetService("MarketplaceService")

local ds = game:GetService("DataStoreService"):GetDataStore("Data:Pre-Alpha")

local Items_To_Use --{item ID,price,limited,demand (1-100),stock}

---------------------


-- tables for keeping data --
local items = {} --[[name = {
{username,sell price},
Price = starting price,
Limited = is a limited or not,
Demand = demand,
Stock = stock,
ID = id
Rap = *rap of item*,
New = os.time of when released,
Total_Sales = total number of sales,PurchaseHistory = {
{sold price,os.time of sale},
...},
Price = Price of a non-limited item}
--]]

local Bux = {} --name = Bux (robux)

-----------------------------

-- Helpful Functions --

local Keep_History = 600 --amount of time in seconds to keep a purchase in it's history

--[[
local function Cleanse_Purchase_History(item)
	if items[item] == nil then return end
	if type(items[item].PurchaseHistory) ~= "table" then return end
	local t = os.time()
	for i,k in pairs (items[item].PurchaseHistory) do
		if k.Time and k.Time + Keep_History < os.time() then
			table.remove(items[item].PurchaseHistory,i)
		end
	end
end
--]]

local function Get_Wanted_Price(item,p,d) --35 is where item cost will be lower than
	if p and d then
		return (p/(75000+p)*(d-35)^3)+p
	end
	if items[item] == nil then return end
	if items[item].Demand == nil or items[item].Price == nil then return end
	p = items[item].Price
	d = items[item].Demand
	return (p/(75000+p)*(d-35)^3)+p
end

local function Get_Username(plr) --works for name,id,or userdata value for plr
	if type(plr) == "string" then return plr end
	if type(plr) == "number" then
		for i,k in pairs (game.Players:GetPlayers()) do
			if k.userId == plr then
				return k.Name
			end
		end
	end
	if type(plr) == "userdata" then
		return plr.Name
	end
end

-----------------------

-- Items_To_Use Functions --

--[[
local function Find_Stock(tbl,mstbl)
	if tbl.Stock == nil then
		return mstbl.Sold
	end
	return tbl.Stock
end

local function Find_Price(tbl,mstbl)
	if tbl.Price == nil then
		return mstbl.Price
	end
	return tbl.Price
end
--]]

----------------------------

-- Item Functions --

local function Strip_Scripts(i) --used for gears
	for _,k in pairs (i:GetChildren()) do
		if i.ClassName == "Script" or i.ClassName == "LocalScript" then
			i:Destroy()
		elseif #i:GetChildren() > 1 then
			Strip_Scripts(i)
		end
	end
end

local function Get_Num_Items()
	local n = 0
	for i,k in pairs (items) do
		n = n + 1
	end
	return n
end

local function Get_Random_Item()
	local n = math.random(Get_Num_Items())
	for i,k in pairs (items) do
		n = n - 1
		if n == 0 then
			return i
		end
	end
end

local function Item_Added(item,stock)
	local t = {}
	if stock and stock > 0 then
		for i=1,stock do
			t[i] = items[item][i]
		end
	end
	delay(0,function()
		local d = items[item].Demand
		while items[item][stock][1] == nil do
			wait()
			
		end
	end)
	workspace.Remotes.Event:FireAllClients("New Item",item,t,items[item].Price,items[item].ID,items[item].New)
end

local function Load_More_Items_To_Use()
	Items_To_Use = ds:GetAsync("Item Data")
	for i=#Items_To_Use,1,-1 do
		local k = Items_To_Use[i]
		for e,item in pairs (workspace.Items:GetChildren()) do
			if item:FindFirstChild("ID") and item.ID.Value == k[1] then
				table.remove(Items_To_Use,i)
			end
		end
	end
	local t = {"ID","Price","Limited","Demand","Stock"}
	for i,k in pairs (Items_To_Use) do
		for e=1,#t do
			k[t[e]] = k[e]
			k[e] = nil
		end
	end
end

local function Add_Random_Item()
	if not Items_To_Use then Load_More_Items_To_Use() end
	if math.random(5) == 1 then
		Load_More_Items_To_Use()
	end
	if #Items_To_Use == 0 then
		print("All Items are Available in the Virtual Catalog")
		return
	end
	local num = math.random(#Items_To_Use)
	local item = Items_To_Use[num]
	if item == nil then return end
	local tbl = {}
	local mstbl = ms:GetProductInfo(item.ID)
	tbl.ID = item.ID
	tbl.Price = item.Price -- or Find_Price(item,mstbl)
	tbl.Limited = item.Limited
	tbl.Demand = item.Demand
	tbl.Stock = item.Stock -- or (item.Limited and Find_Stock(item,mstbl))
	tbl.New = os.time()
	tbl.Rap = 0
	tbl.Total_Sales = 0
	local fold = Instance.new("Folder",workspace:FindFirstChild("Items"))
	fold.Name = mstbl.Name
	for i,k in pairs (tbl) do
		local int = Instance.new(i == "Limited" and "BoolValue" or "IntValue",fold)
		int.Name = i
		int.Value = k
	end
	if tbl.Stock and tbl.Stock > 0 then
		for i=1,tbl.Stock do
			tbl[i] = {}
		end
	end
	items[mstbl.Name] = tbl
	table.remove(Items_To_Use,num)
	Item_Added(mstbl.Name,tbl.Stock)
	return true
end

local function Get_Serial_Numbers(user,item)
	local tbl = items[item]
	if tbl == nil then return end
	local t = {}
	user = Get_Username(user)
	for i,k in pairs (tbl) do
		if k[1] == user then
			table.insert(t,i)
		end
	end
	return t
end

local function Get_Lowest_Price(item)
	if items[item] == nil then return end
	local fold = workspace.Items:FindFirstChild(item)
	if fold == nil then return end
	if fold:FindFirstChild("Stock") == nil and fold:FindFirstChild("Price") then return fold.Price.Value end
	if fold:FindFirstChild("Stock") == nil then return end
	local stock = fold.Stock.Value
	local i,lowest,serial = 1,math.huge
	while items[item][i] and items[item][i][1] do
		if items[item][i][2] and items[item][i][2] <= lowest then
			serial = i
			lowest = items[item][i][2]
		end
		i = i + 1
	end
	if i <= stock then
		return fold.Price.Value
	end
	return lowest,serial
end

local function Get_Num_of_Private_Sellers(item)
	if items[item] == nil then return end
	local i,n = 1,0
	while items[item][i] do
		if items[item][i][2] then
			n = n + 1
		end
		i = i + 1
	end
	return n
end



--------------------

-- Market Functions --

local function Handle_Purchase(user,item,serial)
	local name = item
	local tbl = items[item]
	user = Get_Username(user)
	if tbl.Limited then
		local serialtbl = tbl[serial]
		if serialtbl[2] == nil then return "Error" end
		if Bux[user] < serialtbl[2] then return "Not Enough "..Name_of_Currency end
		Bux[user] = Bux[user] - serialtbl[2]
		if serialtbl[1] ~= nil then
			if Bux[serialtbl[1]] then
				Bux[serialtbl[1]] = Bux[serialtbl[1]] + .7*serialtbl[2]
			end
		end
		print(user.." just bought #"..tostring(serial).." "..name.." from "..serialtbl[1])
		items[item][serial] = {user}
		return "Success"
	elseif not serial then
		if Bux[user] > tbl.Price then
			Bux[user] = Bux[user] - tbl.Price
			local haz = (function()
				if #tbl == 0 then return end
				for i=1,#tbl do
					if tbl[i][1] == user then return true end
				end
			end)()
			if not haz then
				local serial = #tbl + 1
				items[item][serial] = {user}
				print(user.." Bought #"..tostring(serial).." "..name)
				return "Success"
			else
				return "Already Owned"
			end
		else
			return "Not Enough "..Name_of_Currency
		end
	end
end

local function Sell_Serials(plr,item,serials,price)
	local changed = false
	local name = Get_Username(plr)
	for _,k in pairs (serials) do
		local t = items[item][k]
		if t[1] == name then
			items[item][k] = {name,price}
			changed = true
		end
	end
	if changed then
		workspace.Remotes.Event:FireAllClients("Upload Page",item)
	end
end

game.Players.PlayerAdded:connect(function(plr)
	Bux[plr.Name] = 10000000
end)

----------------------

-- Remotes --

local function Get_Item_Data(name)
	if not items[name] then return end
	local t = {}
	local i = 1
	while items[name][i] do
		t[i] = items[name][i]
		i = i + 1
	end
	return t
end

local funct,event = workspace.Remotes:WaitForChild("Function"),workspace.Remotes:WaitForChild("Event")

funct.OnServerInvoke = function(plr,typ,...)
	if typ == "Get Item Data" then
		return Get_Item_Data(...)
	elseif typ == "Get Lowest Price" then
		return Get_Lowest_Price(...)
	elseif typ == "Get Serials" then
		return Get_Serial_Numbers(plr,...)
	elseif typ == "Buy Item" then
		return Handle_Purchase(plr,...)
	end
end

event.OnServerEvent:connect(function(plr,typ,...)
	if typ == "Sell Serials" then
		Sell_Serials(plr,...)	
	end
end)


-------------

-- Load Bots --
local robots = {}

for i=1,Num_of_Bots do
	table.insert(robots,Bot_Name_Prefix..tostring(i))
end

--------------

-- Activate Bots --

local function Activate_Bot(bot)
	if string.sub(bot,1,string.len(Bot_Name_Prefix)) ~= Bot_Name_Prefix then return end
	local botnum = tonumber(string.sub(bot,string.len(Bot_Name_Prefix)+1))
	if botnum <= 0 or botnum > Num_of_Bots then return end
	while wait(1) do
		for i,k in pairs (items) do
			if math.random(1,Average_Bot_Check_Item_Time) == 1 then
				local serials = Get_Serial_Numbers(bot,i)
				if #serials > 0 then
					
				end
			end
		end
	end
end

math.randomseed(os.time())
wait()
for i=1,Num_of_Bots do
	Bux[Bot_Name_Prefix..tostring(i)] = Bot_Starting_Bux
	coroutine.resume(coroutine.create(Activate_Bot,Bot_Name_Prefix..tostring(i)))
end

--when new actions occurs
local range = .337 --percent of price

local function Check_Item(item)
	if items[item] == nil then return end
	local price,serial = Get_Lowest_Price(item)
	if serial == nil then return end
	local data = items[item][serial]
	local p = Get_Wanted_Price(item)
	local std_dev = range*p
	local percentile = .5+.5*math.tanh((data[2]-p)/(2*std_dev))
	if math.random() > percentile then
		local bot_num = math.random(Num_of_Bots)
		Handle_Purchase(Bot_Name_Prefix..tostring(bot_num),item,serial)
		if math.random(2) == 1 then
			items[item][serial] = {Bot_Name_Prefix..tostring(bot_num),math.ceil(p/(math.random(5,7)*.1))}
		end
		workspace.Remotes.Event:FireAllClients("Update Item",items)
	end
end

delay(0,function()
	while wait(5) do
		Add_Random_Item()
		--wait(math.random(40,75))
	end
end)

while wait(1) do
	if math.random(Get_Num_Items()+4) <= Get_Num_Items() then
		--Check_Item(Get_Random_Item())
	end
end


-------------------
