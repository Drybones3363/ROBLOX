local ds = game:GetService("DataStoreService"):GetDataStore("MatchData")
local m = require(game.ServerScriptService.DatastoreFunctions)

local update = ds:OnUpdate("p"..script.Parent.Parent.Parent.Parent.userId.."PlaceID",function(val)	
	if val > 0 then
		pcall(function()
			local tbl = m.PCallGetAsync(ds,"p"..script.Parent.Parent.Parent.Parent.userId.."Items")
			local equipped = script.Parent.Parent.Parent.ShopGui.Frame.Stuff.Inve.Equipped
			if tbl == nil then
				tbl = {}
			end
			for i=1,#equipped:children() do
				if equipped:children()[i]:findFirstChild("Pic") then
					tbl[1] = equipped:children()[i].Pic.HatID.Value
				end
			end
			m.PCallSetAsync(ds,"p"..script.Parent.Parent.Parent.Parent.userId.."Items",tbl)
		end)
		local new = Instance.new("IntValue")
		new.Value = val
		new.Parent = script.Parent.Parent.Parent.Teleport
		script.Disabled = true
	end
end)
