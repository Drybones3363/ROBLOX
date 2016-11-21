local ds = game:GetService("DataStoreService"):GetDataStore("Pre-Alpha")

local Data = {}

local Animations = {
	Down = Instance.new("Animation")
	Swing = Instance.new("Animation")
}
Animations.Down.AnimationID = ""
Animations.Swing.AnimationID = ""

local function Swing(plr,handle,pos)
	local offset = handle.Position-pos
	if handle.Position.Y - pos.Y > 3 then
		plr.Character.Humanoid:PlayAnimation(Animations.Down)
	else
		plr.Character.Humanoid:PlayAnimation(Animations.Swing)
	end
	wait(.25)
	if handle:IsDescendentOf(workspace) then
		workspace.Terrain:FillRegion(handle.Position-offset,5,Enum.Material.Air)
	end
end

local PackData --table of all packages to buy

local function Update_Data()
	local p
	repeat
		p = pcall(function()
			ds:SetAsync("PackData",data)
		end)
	until p == true
	print"Successfully Updated Data"
end

local function Load_Data()
	local p
	repeat
		p = pcall(function()
			PackData = ds:GetAsync("PackData")
		end)
	until p == true and PackData
	ds.OnUpdate("PackData",function(d)
		PackData = d
		workspace.RemoteEvent:FireAllClients("Shop has been updated! Check out the new items!")
	end)
end

delay(0,Load_Data)

local function Get_Pack_Data(n)
	for i,k in pairs (PackData) do
		if k.n and k.n == n then
			return k
		end
	end
end

local function Get_Pack_Items(pack,level)
	local ret = {}
	pack = type(pack) == "table" and pack or Get_Pack_Data(pack)
	for i,k in pairs (pack.d or {}) do
		if k[6] and k[6] == level then
			table.insert(ret,k)
		end
	end
	return ret
end

local function Open_Pack_Server(n)
	local ret = {}
	local d = Get_Pack_Data(n)
	for i=1,math.random(10,20) do
		local level = 1
		math.randomseed(os.time())
		if math.random(500) == 1 then
			level = 4
		elseif math.random(20) == 1 then
			level = 3
		elseif math.random(3) == 1 then
			level = 2
		end
		local tt = Get_Pack_Items(d,level)
		table.insert(ret,{tt[1],tt[5]})
	end
	local level = 1
	math.randomseed(os.time())
	if math.random(500) == 1 then
		level = 4
	elseif math.random(20) == 1 then
		level = 3
	elseif math.random(3) == 1 then
		level = 2
	end
	local tt = Get_Pack_Items(d,level)
	tt = tt[math.random(#tt)]
	--set return array to the item name and image
	ret.Received = {tt[1],tt[5]}
	--below gives player the item--
	if Data[tostring(plr.userId)].Inventory[tt[2]] then
		Data[tostring(plr.userId)].Inventory[tt[2]] = Data[tostring(plr.userId)].Inventory[tt[2]] + 1
	else
		Data[tostring(plr.userId)].Inventory[tt[2]] = 1
	end
	return ret
end
