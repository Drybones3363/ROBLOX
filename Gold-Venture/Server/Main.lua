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
		workspace.Terrain:FillRegion(handle.Position-offset,5,air)
	end
end

local PackData --table of all packages to buy

local data = {
	{
		i = 535278127,
		n = 'Katana Pack',
		p = 750,
		pt = 'Gold' --price type ('Gold','Gems')
		d = {
			{"Katana","k",11442510,11442524,11444089,1},
			{"Golden Katana","gk",11442510,18776669,18776672,1},
			{"Blue Katana","bk",11442510,20577502,20577515,1},
			{"Crimson Katana","ck",11442510,18016060,18016099,1},
			{"Bombastic Katana","Bk",11442510,250281077,254661729,2},
			{"Bluesteel Katana","bK",11442510,240922991,240922927,2},
			{"Omega Katana","ok",11442510,340575861,340606193,3},
			{"Katana of the Dark Age","kda",86297695,86290910,86290987,4},
			
		}
	},
	{
		i = 535278110,
		n = 'Basic Sword Pack',
		p = 500,
		pt = 'Gold' --price type ('Gold','Gems')
		d = {
			{"Classic Sword","s",10467539,10467545,534736610,1},
			{"Claymore","c",11439778,11439794,11440361,1},
			{"Riptide","r",124121136,124121617,124122797,1},
			{"Fencing Foil","ff",10908449,10908412,10908579,2},
			{"Sword Breaker","sb",77353021,77353054,77353080,2},
			{"Sorcus' Sword","ss",53351910,53352041,53357857,3},
			{"8-Bit Sword","8",361629844,380257575,380257985,4},
		}
	},
	
	
}

PackData = data --Packdata will be a getasync from datastore, but for now use data

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
end

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
	ret.Received = {tt[1],tt[5]})
	--give player item tt[1]
	return ret
end
