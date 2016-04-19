--[[
This is basically a code I wrote to write lua code for me ;)
--]]

local tbl = {
	"Active",
	"BackgroundColor3",
	"BackgroundTransparency",
	"BorderColor3",
	"BorderSizePixel",
	"Name",
	"Position",
	"Rotation",
	"Selectable",
	"Size",
	"SizeConstraint",
	"Visible",
	"ZIndex",
	"Font",
	"FontSize",
	"Text",
	"TextColor3",
	"TextScaled",
	"TextStrokeColor3",
	"TextStrokeTransparency",
	"TextTransparency",
	"TextWrapped",
	"TextXAlignment",
	"TextYAlignment",
	"ClipDescendants",
	"Draggable",
	"Image",
	"ImageColor3",
	"ImageRectOffset",
	"ImageRectSize",
	"ImageTransparency",
	"ScaleType",
	"SliceCenter",
	"AutoButtonColor",
	"Selected",
	"Style"
}

local function convert_to_code(ui)
	local str = ""
	local function nl()
		str = str..string.char(13)
	end
	local function add_prop_code(ui,i,k,n)
		if n == nil then n = "ui" else n = tostring(n) end
		local good = pcall(function() if ui[k] then return true end end)
		if not good then return end
		if ui[k] == nil then return end
		if type(ui[k]) == "number" or type(ui[k]) == "boolean" then
			str = str..n..'["'..k..'"] = '..tostring(ui[k])
			nl()
		elseif type(ui[k]) == "userdata" then
			if tonumber(tostring(ui[k]):sub(1,1)) then
				if pcall(function() if ui[k].x then return true end end) then
					str = str..n..'["'..k..'"] = Vector2.new('..tostring(ui[k])..")"
				elseif pcall(function() if ui[k].Min then return true end end) then
					str = str..n..'["'..k..'"] = Rect.new('..tostring(ui[k])..")"
				else
					str = str..n..'["'..k..'"] = Color3.new('..tostring(ui[k])..")"
				end
			elseif tostring(ui[k]):sub(1,1) == "{" then
				str = str..n..'["'..k..'"] = UDim2.new('..tostring(ui[k].X)..","..tostring(ui[k].Y)..")"
			else
				str = str..n..'["'..k..'"] = '..tostring(ui[k])
			end
			nl()
		elseif type(ui[k]) == "string" then
			str = str..n..'["'..k..'"] = "'..ui[k]..'"'
			nl()
		end
	end
	str = str..'local ui = Instance.new("'..ui.ClassName..'")'
	nl()
	for i,k in pairs (tbl) do
		add_prop_code(ui,i,k)
	end
	for e,r in pairs (ui:GetChildren()) do
		local n = r.Name
		str = str..'local '..n..' = Instance.new("'..r.ClassName..'",ui)'
		nl()
		for i,k in pairs (tbl) do
			add_prop_code(r,i,k,n)
		end
	end
	return str
end

print(convert_to_code(game.StarterGui.WebUI.Catalog.Item))
