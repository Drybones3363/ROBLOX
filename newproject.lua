--[[axes and weapons
	
	
	katana pack
	axe pack
	
{} --main pack data table	
	
	
	d = data
	n = name
	p = price
	
{d = {*subtables here*},n = 'Katana Pack',p = 100} --main individual pack table	

sub-table:
{name,meshid,textureid,picid,level of rarity}


Can change amount per rarity

Rarity:
1: Common - Cyan
2: Uncommon - Yellow
3: Rare - Red
4: Heroic - Green

--]]

local data = {
	{
		n = 'Katana Pack',
		p = 100,
		d = {
			{"Katana",11442510,11442524,11444089,1},
			{"Golden Katana",11442510,18776669,18776672,1},
			{"Blue Katana",11442510,20577502,20577515,1},
			{"Crimson Katana",11442510,18016060,18016099,1},
			{"Bombastic Katana",11442510,250281077,254661729,2},
			{"Bluesteel Katana",11442510,240922991,240922927,2},
			{"Omega Katana",11442510,340575861,340606193,3},
			{"Katana of the Dark Age",86297695,86290910,86290987,4},
			
		}
	},
	{
		n = 'Basic Sword Pack',
		p = 100,
		d = {
			{"Classic Sword",10467539,10467545,534736610,1},
			{"Claymore",11439778,11439794,11440361,1},
			{"Riptide",124121136,124121617,124122797,1},
			{"Fencing Foil",10908449,10908412,10908579,2},
			{"Sword Breaker",77353021,77353054,77353080,2},
			{"Sorcus' Sword",53351910,53352041,53357857,3},
			{"8-Bit Sword",361629844,380257575,380257985,4},
			
		}
	},
	
	
}



local PackData --table of all packages to buy










local ds = game:GetService("DatastoreService")

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
























