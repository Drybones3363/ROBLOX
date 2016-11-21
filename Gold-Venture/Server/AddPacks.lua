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
