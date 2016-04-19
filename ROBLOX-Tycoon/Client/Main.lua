local plr = game.Players.LocalPlayer
local items = {}
local ordered_items = {}
local Item_Viewing = ""

-- Useful Tables --

local Navigation_Images = {
	Menu = {0},
	Robux = {1},
	Tix = {2},
	Settings = {3},
	Search = {4},
	Home = {5,Color3.new(0x02/255,0xb7/255,0x57/255)},
	Profile = {6,Color3.new(0xf6/255,0x88/255,0x02/255)},
	Messages = {7,Color3.new(0,0xa2/255,0xff/255)},
	Friends = {8,Color3.new(0,0xa2/255,0xff/255)},
	Character = {9,Color3.new(0xf6/255,0x88/255,0x02/255)},
	Inventory = {10,Color3.new(0x02/255,0xb7/255,0x57/255)},
	Trade = {11,Color3.new(0,0xa2/255,0xff/255)},
	Groups = {12,Color3.new(0,0xa2/255,0xff/255)},
	Forum = {13,Color3.new(0,0xa2/255,0xff/255)},
	Blog = {14,Color3.new(0,0xa2/255,0xff/255)},
	Shop = {16,Color3.new(0,0xa2/255,0xff/255)}
}

local m
coroutine.resume(coroutine.create(function()
	m = require(workspace:WaitForChild("Global Functions"))
end))








-------------------


-- Effects Functions --

local function Add_Transparent_Effects(button,typ)
	button.AutoButtonColor = false
	button.MouseEnter:connect(function()
		button.BackgroundTransparency = typ == 2 and .875 or .25
	end)
	button.MouseLeave:connect(function()
		button.BackgroundTransparency = typ == 2 and 1 or .5
	end)
	button.MouseButton1Down:connect(function()
		button.BackgroundTransparency = typ == 2 and .75 or 0
	end)
	button.MouseButton1Up:connect(function()
		button.BackgroundTransparency = typ == 2 and .875 or .25
	end)
end

local function Add_Sell_Effects(button)
	button.AutoButtonColor = false
	button.MouseEnter:connect(function()
		if not button:FindFirstChild("Choosen") then
			button.BackgroundTransparency = .875
		end
	end)
	button.MouseLeave:connect(function()
		if not button:FindFirstChild("Choosen") then
			button.BackgroundTransparency = 1
		end
	end)
	button.MouseButton1Down:connect(function()
		if not button:FindFirstChild("Choosen") then
			button.BackgroundTransparency = .75
		end
	end)
	button.MouseButton1Up:connect(function()
		if not button:FindFirstChild("Choosen") then
			button.BackgroundTransparency = .875
		end
	end)
end

local function Add_Item_Button_Effects(button)
	button.AutoButtonColor = false
	button.MouseEnter:connect(function()
		button.BackgroundTransparency = .75
	end)
	button.MouseLeave:connect(function()
		button.BackgroundTransparency = .9
	end)
	button.MouseButton1Down:connect(function()
		button.BackgroundTransparency = .5
	end)
	button.MouseButton1Up:connect(function()
		button.BackgroundTransparency = .75
	end)
end

local function Add_Navigation_Effects(img)
	if img.ClassName ~= "ImageButton" then return end
	img.MouseEnter:connect(function()
		img.ImageRectOffset = Vector2.new(49,img.ImageRectOffset.y)
	end)
	img.MouseLeave:connect(function()
		img.ImageRectOffset = Vector2.new(0,img.ImageRectOffset.y)
	end)
end

local function Add_Nav_Button_Effects(button)
	if button.ClassName ~= "TextButton" then return end
	if button:FindFirstChild("Nav_Image") == nil then return end
	if Navigation_Images[button.Name] == nil then return end
	button.MouseEnter:connect(function()
		button.TextColor3 = Navigation_Images[button.Name][2] or Color3.new(1,1,1)
		button.Nav_Image.ImageRectOffset = Vector2.new(49,button.Nav_Image.ImageRectOffset.y)
	end)
	button.MouseLeave:connect(function()
		button.TextColor3 = Color3.new()
		button.Nav_Image.ImageRectOffset = Vector2.new(0,button.Nav_Image.ImageRectOffset.y)
	end)
	button.MouseButton1Click:connect(function()
		
	end)
end

-----------------------

-- Load Assets --

local Images = {
	LimitedU = "rbxassetid://28577114",
	Limited = "rbxassetid://28577308",
	Bot_Image = "rbxassetid://272081472",
	Navigation = "rbxassetid://340001892",
	New = "rbxassetid://340062751"
}

local CP = game:GetService("ContentProvider")

for i,k in pairs (Images) do
	CP:Preload(k)
end

-----------------

-- Remotes --

local function Get_User_Image(name)
	if not name or type(name) ~= "string" then return end
	if name:sub(1,4) == "Bot " then
		return Images.Bot_Image
	elseif name:sub(1,6) == "Guest " then
		return "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username=ROBLOX"
	else
		return "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..name
	end
end


local function Make_Item_UI()
	local ui = Instance.new("ImageButton")
	ui["Active"] = true
	ui["BackgroundColor3"] = Color3.new(0, 0, 0)
	ui["BackgroundTransparency"] = 0.89999997615814
	ui["BorderColor3"] = Color3.new(0.501961, 0.501961, 0.501961)
	ui["BorderSizePixel"] = 0
	ui["Name"] = "Item"
	ui["Position"] = UDim2.new(0.0250000004, 0,0, 0)
	ui["Rotation"] = 0
	ui["Selectable"] = true
	ui["Size"] = UDim2.new(0.200000003, 0,0.224999994, 0)
	ui["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	ui["Visible"] = true
	ui["ZIndex"] = 1
	ui["Draggable"] = false
	ui["Image"] = "rbxassetid://293007689"
	ui["ImageColor3"] = Color3.new(1, 1, 1)
	ui["ImageRectOffset"] = Vector2.new(0, 0)
	ui["ImageRectSize"] = Vector2.new(0, 0)
	ui["ImageTransparency"] = 0
	ui["ScaleType"] = Enum.ScaleType.Stretch
	ui["SliceCenter"] = Rect.new(0, 0, 0, 0)
	ui["AutoButtonColor"] = true
	ui["Selected"] = false
	ui["Style"] = Enum.ButtonStyle.Custom
	local LimSign = Instance.new("ImageLabel",ui)
	LimSign["Active"] = false
	LimSign["BackgroundColor3"] = Color3.new(1, 1, 1)
	LimSign["BackgroundTransparency"] = 1
	LimSign["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	LimSign["BorderSizePixel"] = 1
	LimSign["Name"] = "LimSign"
	LimSign["Position"] = UDim2.new(0, 0,0, 0)
	LimSign["Rotation"] = 0
	LimSign["Selectable"] = false
	LimSign["Size"] = UDim2.new(1, 0,1, 0)
	LimSign["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	LimSign["Visible"] = false
	LimSign["ZIndex"] = 1
	LimSign["Draggable"] = false
	LimSign["Image"] = ""
	LimSign["ImageColor3"] = Color3.new(1, 1, 1)
	LimSign["ImageRectOffset"] = Vector2.new(0, 0)
	LimSign["ImageRectSize"] = Vector2.new(0, 0)
	LimSign["ImageTransparency"] = 0
	LimSign["ScaleType"] = Enum.ScaleType.Stretch
	LimSign["SliceCenter"] = Rect.new(0, 0, 0, 0)
	local lblName = Instance.new("TextLabel",ui)
	lblName["Active"] = false
	lblName["BackgroundColor3"] = Color3.new(1, 1, 1)
	lblName["BackgroundTransparency"] = 1
	lblName["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	lblName["BorderSizePixel"] = 1
	lblName["Name"] = "lblName"
	lblName["Position"] = UDim2.new(0, 0,1, 0)
	lblName["Rotation"] = 0
	lblName["Selectable"] = false
	lblName["Size"] = UDim2.new(1, 0,0.150000006, 0)
	lblName["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	lblName["Visible"] = true
	lblName["ZIndex"] = 1
	lblName["Font"] = Enum.Font.SourceSansBold
	lblName["FontSize"] = Enum.FontSize.Size14
	lblName["Text"] = ""
	lblName["TextColor3"] = Color3.new(1, 1, 1)
	lblName["TextScaled"] = true
	lblName["TextStrokeColor3"] = Color3.new(0, 0, 0)
	lblName["TextStrokeTransparency"] = 0
	lblName["TextTransparency"] = 0
	lblName["TextWrapped"] = true
	lblName["TextXAlignment"] = Enum.TextXAlignment.Center
	lblName["TextYAlignment"] = Enum.TextYAlignment.Center
	lblName["Draggable"] = false
	local lblPrice = Instance.new("TextLabel",ui)
	lblPrice["Active"] = false
	lblPrice["BackgroundColor3"] = Color3.new(1, 1, 1)
	lblPrice["BackgroundTransparency"] = 1
	lblPrice["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	lblPrice["BorderSizePixel"] = 1
	lblPrice["Name"] = "lblPrice"
	lblPrice["Position"] = UDim2.new(0, 0,1.14999998, 0)
	lblPrice["Rotation"] = 0
	lblPrice["Selectable"] = false
	lblPrice["Size"] = UDim2.new(1, 0,0.150000006, 0)
	lblPrice["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	lblPrice["Visible"] = true
	lblPrice["ZIndex"] = 1
	lblPrice["Font"] = Enum.Font.SourceSansBold
	lblPrice["FontSize"] = Enum.FontSize.Size14
	lblPrice["Text"] = ""
	lblPrice["TextColor3"] = Color3.new(0, 1, 0)
	lblPrice["TextScaled"] = true
	lblPrice["TextStrokeColor3"] = Color3.new(0, 0, 0)
	lblPrice["TextStrokeTransparency"] = 0
	lblPrice["TextTransparency"] = 0
	lblPrice["TextWrapped"] = true
	lblPrice["TextXAlignment"] = Enum.TextXAlignment.Center
	lblPrice["TextYAlignment"] = Enum.TextYAlignment.Center
	lblPrice["Draggable"] = false
	local NewSign = Instance.new("ImageLabel",ui)
	NewSign["Active"] = false
	NewSign["BackgroundColor3"] = Color3.new(1, 1, 1)
	NewSign["BackgroundTransparency"] = 1
	NewSign["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	NewSign["BorderSizePixel"] = 1
	NewSign["Name"] = "NewSign"
	NewSign["Position"] = UDim2.new(0, 0,0, 0)
	NewSign["Rotation"] = 0
	NewSign["Selectable"] = false
	NewSign["Size"] = UDim2.new(1, 0,1, 0)
	NewSign["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	NewSign["Visible"] = false
	NewSign["ZIndex"] = 1
	NewSign["Draggable"] = false
	NewSign["Image"] = "rbxassetid://340062751"
	NewSign["ImageColor3"] = Color3.new(1, 1, 1)
	NewSign["ImageRectOffset"] = Vector2.new(0, 0)
	NewSign["ImageRectSize"] = Vector2.new(0, 0)
	NewSign["ImageTransparency"] = 0
	NewSign["ScaleType"] = Enum.ScaleType.Stretch
	NewSign["SliceCenter"] = Rect.new(0, 0, 0, 0)
	return ui
end

local function Sell_Serial_Button()
	local ui = Instance.new("TextButton")
	ui["Active"] = true
	ui["BackgroundColor3"] = Color3.new(1, 1, 0)
	ui["BackgroundTransparency"] = 1
	ui["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	ui["BorderSizePixel"] = 0
	ui["Name"] = "Num"
	ui["Position"] = UDim2.new(0, 0,0, 0)
	ui["Rotation"] = 0
	ui["Selectable"] = true
	ui["Size"] = UDim2.new(1, -10,0.0329999998, 0)
	ui["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	ui["Visible"] = true
	ui["ZIndex"] = 1
	ui["Font"] = Enum.Font.SourceSans
	ui["FontSize"] = Enum.FontSize.Size14
	ui["Text"] = ""
	ui["TextColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	ui["TextScaled"] = false
	ui["TextStrokeColor3"] = Color3.new(0, 0, 0)
	ui["TextStrokeTransparency"] = 1
	ui["TextTransparency"] = 0
	ui["TextWrapped"] = false
	ui["TextXAlignment"] = Enum.TextXAlignment.Center
	ui["TextYAlignment"] = Enum.TextYAlignment.Center
	ui["Draggable"] = false
	ui["AutoButtonColor"] = true
	ui["Selected"] = false
	ui["Style"] = Enum.ButtonStyle.Custom
	return ui
end

local function Get_Item_Table(item)
	if item == nil then return end
	local t = {}
	for i,k in pairs (workspace.Items:FindFirstChild(item) and workspace.Items[item]:GetChildren() or {}) do
		t[k.Name] = k.Value
	end
	t["Name"] = item
	return t
end

local function Sort_Seller_Table(t)
	if not type(t) == "table" then return end
	local sellers = {}
	for i=1,#t do
		if t[i][2] then
			table.insert(sellers,{t[i][1],t[i][2],i})
		end
	end
	table.sort(sellers,function(a,b) if a[2] < b[2] then return true elseif a[2] == b[2] then return a[3] < b[3] else return false end end)
	return sellers
end

local function Update_Page(item)
	
end

local sellers,stock

local function Load_Page(n)
	local itemviewer = script.Parent.WebUI.ItemViewer
	for i=5*n+1,5*n+5 do
		if sellers[i][2] then
			local ui = itemviewer.PS.Sellers["Seller"..tostring(i)]
			ui.UserImage.Image = Get_User_Image(sellers[i][1])
			ui.Price.Text = "$ "..tostring(m.Format_Number(sellers[i][2]))
			ui.Serial.Text = "Serial #"..tostring(sellers[i][3]).." of "..tostring(stock)
			ui.User.Text = sellers[i][1]
			ui.Buy.Visible = true
		else
			local ui = itemviewer.PS.Sellers["Seller"..tostring(i)]
			ui.UserImage.Image = ""
			ui.Price.Text = ""
			ui.Serial.Text = ""
			ui.User.Text = ""
			ui.Buy.Visible = false
		end
	end
end

local function Load_New_Item_Page(item)
	local itemviewer = script.Parent.WebUI.ItemViewer
	local tbl = Get_Item_Table(item)
	Item_Viewing = item
	itemviewer.PS.Visible = false
	local sellers = workspace.Remotes.Function:InvokeServer("Get Item Data",item)
	if tbl.Limited then
		--for i,k in pairs (sellers) do print(k[1],k[2]) end
		--Sort_Seller_Table(workspace.Remotes.Function:InvokeServer("Get Item Data",item))
		if tbl.Stock > #sellers then
			sellers = Sort_Seller_Table({{"FutureWebsiteOwner",499},{"FutureWebsiteOwner",499},{"Terratronic",499},{"Player",499},{"Bot 25",499}
			,{"Bot 1337",499}})
			local page_total = math.ceil(#sellers/5)
			for i=1,5 do
				if sellers[i] and sellers[i][2] then
					local ui = itemviewer.PS.Sellers["Seller"..tostring(i)]
					ui.UserImage.Image = Get_User_Image(sellers[i][1])
					ui.Price.Text = "$ "..tostring(m.Format_Number(sellers[i][2]))
					ui.Serial.Text = "Serial #"..tostring(sellers[i][3]).." of "..tostring(stock)
					ui.User.Text = sellers[i][1]
					if sellers[i][1] == game.Players.LocalPlayer.Name then
						ui.Buy.Text = "Take Off Sale"
						ui.Buy.BackgroundColor3 = Color3.new(.5,0,0)
						ui.Buy.FontSize = Enum.FontSize.Size14
					else
						ui.Buy.Text = "Buy"
						ui.Buy.BackgroundColor3 = Color3.new(0,.5,0)
						ui.Buy.FontSize = Enum.FontSize.Size24
					end
					ui.Buy.Visible = true
				else
					local ui = itemviewer.PS.Sellers["Seller"..tostring(i)]
					ui.UserImage.Image = ""
					ui.Price.Text = ""
					ui.Serial.Text = ""
					ui.User.Text = ""
					ui.Buy.Visible = false
				end
			end
			itemviewer.Buy.Text = "Buy For "..itemviewer.PS.Sellers.Seller1.Price.Text
			itemviewer.Sold.Text = "Sold: "..tostring(tbl.Stock)
			itemviewer.Sold.TextXAlignment = Enum.TextXAlignment.Center
			itemviewer.Sold.Remaining.Text = ""
			itemviewer.PS.Visible = true
		else
			itemviewer.Buy.Text = "Buy For $ "..m.Format_Number(tbl.Price)
			itemviewer.Sold.Text = "Sold: "..tostring(#sellers)
			itemviewer.Sold.TextXAlignment = Enum.TextXAlignment.Left
			itemviewer.Sold.Remaining.Text = "Remaining: "..tostring(tbl.Stock-#sellers)
			
		end
		local serials = {1,3,7}--workspace.Remotes.Function:InvokeServer("Get Serials",item)
		if serials and #serials > 0 then
			for i,k in pairs (serials) do
				local ui = Sell_Serial_Button()
				ui.Position = UDim2.new(0,0,(1/30)*(i-1))
				ui.Text = "#"..tostring(k)
				ui.Parent = itemviewer.Sell.Serials
				Add_Sell_Effects(ui)
				ui.MouseButton1Click:connect(function()
					if ui:FindFirstChild("Choosen") then
						ui.Choosen:Destroy()
						ui.BackgroundTransparency = 1
					else
						Instance.new("Folder",ui).Name = "Choosen"
						ui.BackgroundTransparency = .75
					end
				end)
			end
			itemviewer.Sell.Visible = true
		end
	else
		itemviewer.Buy.Text = "Buy For $ "..m.Format_Number(tbl.Price)
		itemviewer.Sold.Text = "Sold: "..tostring(#sellers)
		itemviewer.Sold.TextXAlignment = Enum.TextXAlignment.Center
		itemviewer.Sold.Remaining.Text = ""
	end
	itemviewer.Item.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(tbl.ID)
	itemviewer.Item.Limited.Visible = tbl.Limited
	itemviewer.Item.name.Text = tbl.Name
	itemviewer.Sell.Serials:ClearAllChildren()
	itemviewer.Visible = true
end

local function Clear_Catalog()
	local catalog = script.Parent.WebUI.Catalog
	for i,k in pairs (catalog:GetChildren()) do
		if k.Name == "Item" and k.ClassName == "ImageButton" then
			k:Destroy()
		end
	end
end

local function View_Catalog(page)
	if page == nil then page = 1 end
	local catalog = script.Parent.WebUI.Catalog
	Clear_Catalog()
	for i=(page-1)*12+1,(page-1)*12+12 do
		local tbl = Get_Item_Table(ordered_items[i])
		if tbl == nil then break end
		local n = i-(page-1)*12
		local ui = Make_Item_UI()
		ui.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(tbl.ID)
		ui.lblName.Text = tbl.Name
		if os.time() <= tbl.New + 300 then
			ui.NewSign.Visible = true
		end
		if tbl.Limited then
			ui.LimSign.Visible = true
			if tbl.Stock then
				ui.LimSign.Image = Images.LimitedU
			else
				ui.LimSign.Image = Images.Limited
			end
		end
		coroutine.resume(coroutine.create(function()
			local price = workspace.Remotes.Function:InvokeServer("Get Lowest Price",tbl.Name)
			ui.lblPrice.Text = "Price: "..tostring(m.Format_Number(price))
		end))
		ui.Position = UDim2.new(((n-1)%4)*.25+.025,0,math.floor((n-1)/4)*.3+.01)
		ui.Parent = catalog
		Add_Item_Button_Effects(ui)
		ui.MouseButton1Click:connect(function()
			catalog.Visible = false
			Load_New_Item_Page(tbl.Name)
		end)
	end
	catalog.Visible = true
end

local function Alert(typ,item)
	local ui = Instance.new("TextButton")
	ui["Active"] = true
	ui["BackgroundColor3"] = Color3.new(1, 1, 1)
	ui["BackgroundTransparency"] = 0.5
	ui["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	ui["BorderSizePixel"] = 0
	ui["Name"] = "Alert"
	ui["Position"] = UDim2.new(1, 0,0.800000012, 0)
	ui["Rotation"] = 0
	ui["Selectable"] = true
	ui["Size"] = UDim2.new(0.150000006, 0,0.100000001, 0)
	ui["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	ui["Visible"] = true
	ui["ZIndex"] = 1
	ui["Font"] = Enum.Font.SourceSans
	ui["FontSize"] = Enum.FontSize.Size14
	ui["Text"] = ""
	ui["TextColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	ui["TextScaled"] = false
	ui["TextStrokeColor3"] = Color3.new(0, 0, 0)
	ui["TextStrokeTransparency"] = 1
	ui["TextTransparency"] = 0
	ui["TextWrapped"] = false
	ui["TextXAlignment"] = Enum.TextXAlignment.Center
	ui["TextYAlignment"] = Enum.TextYAlignment.Center
	ui["Draggable"] = false
	ui["AutoButtonColor"] = true
	ui["Selected"] = false
	ui["Style"] = Enum.ButtonStyle.Custom
	local ItemPic = Instance.new("ImageLabel",ui)
	ItemPic["Active"] = false
	ItemPic["BackgroundColor3"] = Color3.new(1, 1, 1)
	ItemPic["BackgroundTransparency"] = 1
	ItemPic["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	ItemPic["BorderSizePixel"] = 1
	ItemPic["Name"] = "ItemPic"
	ItemPic["Position"] = UDim2.new(0, 0,0, 0)
	ItemPic["Rotation"] = 0
	ItemPic["Selectable"] = false
	ItemPic["Size"] = UDim2.new(0.349999994, 0,1, 0)
	ItemPic["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	ItemPic["Visible"] = true
	ItemPic["ZIndex"] = 1
	ItemPic["Draggable"] = false
	ItemPic["Image"] = ""
	ItemPic["ImageColor3"] = Color3.new(1, 1, 1)
	ItemPic["ImageRectOffset"] = Vector2.new(0, 0)
	ItemPic["ImageRectSize"] = Vector2.new(0, 0)
	ItemPic["ImageTransparency"] = 0
	ItemPic["ScaleType"] = Enum.ScaleType.Stretch
	ItemPic["SliceCenter"] = Rect.new(0, 0, 0, 0)
	local Title = Instance.new("TextLabel",ui)
	Title["Active"] = false
	Title["BackgroundColor3"] = Color3.new(1, 1, 1)
	Title["BackgroundTransparency"] = 1
	Title["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	Title["BorderSizePixel"] = 1
	Title["Name"] = "Title"
	Title["Position"] = UDim2.new(0.349999994, 0,0, 0)
	Title["Rotation"] = 0
	Title["Selectable"] = false
	Title["Size"] = UDim2.new(0.649999976, 0,0.5, 0)
	Title["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	Title["Visible"] = true
	Title["ZIndex"] = 1
	Title["Font"] = Enum.Font.ArialBold
	Title["FontSize"] = Enum.FontSize.Size14
	Title["Text"] = typ
	Title["TextColor3"] = Color3.new(0, 1, 0)
	Title["TextScaled"] = true
	Title["TextStrokeColor3"] = Color3.new(0, 0, 0)
	Title["TextStrokeTransparency"] = 0
	Title["TextTransparency"] = 0
	Title["TextWrapped"] = true
	Title["TextXAlignment"] = Enum.TextXAlignment.Center
	Title["TextYAlignment"] = Enum.TextYAlignment.Center
	Title["Draggable"] = false
	local Price = Instance.new("TextLabel",ui)
	Price["Active"] = false
	Price["BackgroundColor3"] = Color3.new(1, 1, 1)
	Price["BackgroundTransparency"] = 1
	Price["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	Price["BorderSizePixel"] = 1
	Price["Name"] = "Price"
	Price["Position"] = UDim2.new(0.349999994, 0,0.5, 0)
	Price["Rotation"] = 0
	Price["Selectable"] = false
	Price["Size"] = UDim2.new(0.649999976, 0,0.25, 0)
	Price["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	Price["Visible"] = true
	Price["ZIndex"] = 1
	Price["Font"] = Enum.Font.ArialBold
	Price["FontSize"] = Enum.FontSize.Size14
	Price["Text"] = ""
	Price["TextColor3"] = Color3.new(1, 1, 0)
	Price["TextScaled"] = true
	Price["TextStrokeColor3"] = Color3.new(0, 0, 0)
	Price["TextStrokeTransparency"] = 0
	Price["TextTransparency"] = 0
	Price["TextWrapped"] = true
	Price["TextXAlignment"] = Enum.TextXAlignment.Center
	Price["TextYAlignment"] = Enum.TextYAlignment.Center
	Price["Draggable"] = false
	local Stock = Instance.new("TextLabel",ui)
	Stock["Active"] = false
	Stock["BackgroundColor3"] = Color3.new(1, 1, 1)
	Stock["BackgroundTransparency"] = 1
	Stock["BorderColor3"] = Color3.new(0.105882, 0.164706, 0.207843)
	Stock["BorderSizePixel"] = 1
	Stock["Name"] = "Stock"
	Stock["Position"] = UDim2.new(0.349999994, 0,0.75, 0)
	Stock["Rotation"] = 0
	Stock["Selectable"] = false
	Stock["Size"] = UDim2.new(0.649999976, 0,0.25, 0)
	Stock["SizeConstraint"] = Enum.SizeConstraint.RelativeXY
	Stock["Visible"] = true
	Stock["ZIndex"] = 1
	Stock["Font"] = Enum.Font.ArialBold
	Stock["FontSize"] = Enum.FontSize.Size14
	Stock["Text"] = "Stock: 420"
	Stock["TextColor3"] = Color3.new(1, 1, 0)
	Stock["TextScaled"] = true
	Stock["TextStrokeColor3"] = Color3.new(0, 0, 0)
	Stock["TextStrokeTransparency"] = 0
	Stock["TextTransparency"] = 0
	Stock["TextWrapped"] = true
	Stock["TextXAlignment"] = Enum.TextXAlignment.Center
	Stock["TextYAlignment"] = Enum.TextYAlignment.Center
	Stock["Draggable"] = false
	--ui.Parent = script.Parent.WebUI.Alerts
	ui.MouseButton1Click:connect(function()
		for i,k in pairs (script.Parent.WebUI.Alerts:GetChildren()) do
			if k.Position.Y.Scale < ui.Position.Y.Scale then
			k:TweenPosition(k.Position+UDim2.new(0,0,.1))
			end
		end
		ui:Destroy()
		Load_New_Item_Page(item)
	end)
	return ui
end

local function in_ordered_tbl(item)
	for i,k in pairs (ordered_items) do
		if k.Name == item then
			return true
		end
	end
end

local function New_Item(name,tbl,price,id,new)
	tbl.Price = price
	tbl.ID = id
	tbl.Stock = #tbl
	tbl.New = new
	items[name] = tbl
	table.insert(ordered_items,name)
	--[[
	coroutine.resume(coroutine.create(function()
		for i,k in pairs (items) do
			if not in_ordered_tbl(i) then
				local t = (function() local v = {} for e,r in pairs (k) do v[e] = r end return v end)()
				t.Name = i
			end
		end
	end))
	--]]
	local ui = Alert("New Item",name)
	ui.Stock.Text = tbl.Stock > 0 and ("Stock: "..tostring(tbl.Stock)) or ""
	ui.Price.Text = "Price: "..m.Format_Number(tbl.Price)
	ui.ItemPic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(tbl.ID)
	ui.Parent = script.Parent.WebUI.Alerts
	coroutine.resume(coroutine.create(function()
		local s = Instance.new("Sound",script.Parent)
		s.SoundId = "rbxassetid://182750827"
		s.Volume = .9
		s:Play()
		wait(.75)
		s:Destroy()
	end))
	for i,k in pairs (script.Parent.WebUI.Alerts:GetChildren()) do
		if k ~= ui then
			k:TweenPosition(k.Position-UDim2.new(0,0,.1))
		else
			k:TweenPosition(k.Position-UDim2.new(.15))
		end
	end
end


local function Update_Item(tbl)
	items = tbl
	Update_Page(Item_Viewing)
end

coroutine.resume(coroutine.create(function()
	
	local funct,event = workspace.Remotes:WaitForChild("Function"),workspace.Remotes:WaitForChild("Event")
	
	funct.OnClientInvoke = function(typ,...)
		if typ == "" then
			
		end
	end
	
	event.OnClientEvent:connect(function(typ,...)
		if typ == "New Item" then
			New_Item(...)
		elseif typ == "Update Item" then
			Update_Item(...)
		end
	end)

end))

-------------

-- Activate Effects --

delay(.03,function()

	for i,k in pairs (script.Parent.WebUI.SideBar:GetChildren()) do
		if k.ClassName == "TextButton" and k:FindFirstChild("Nav_Image") then
			Add_Nav_Button_Effects(k)
		end
	end

	for _,k in pairs ({"Robux","Tix","Settings"}) do
		Add_Navigation_Effects(script.Parent.WebUI.TopBar:FindFirstChild(k))
	end

	script.Parent.WebUI.ItemViewer.Exit.MouseButton1Click:connect(function()
		script.Parent.WebUI.ItemViewer.Visible = false
	end)
	
	local itemviewer = script.Parent.WebUI.ItemViewer
	
	local deb = true
	itemviewer.Buy.MouseButton1Click:connect(function()
		if deb then
			deb = false
			local serial = (function()
				if itemviewer.PS.Visible == false then return end
				return tonumber(itemviewer.PS.Sellers.Seller1.Serial.Text:sub(9,itemviewer.PS.Sellers.Seller1.Serial.Text:find('o')-2))
			end)()
			workspace.Remotes.Function:InvokeServer("Buy Item",Item_Viewing,serial)
			wait()
			deb = true
		end
	end)
	
	Add_Item_Button_Effects(itemviewer.Sell.cmdSell)
	itemviewer.Sell.cmdSell.MouseButton1Click:connect(function()
		local price = tonumber(itemviewer.Sell.txtPrice.Text)
		if not price then return end
		if price > (2^63)-1 then return end
		local serials = (function()
			local ret = {}
			for i,k in pairs (itemviewer.Sell.Serials:GetChildren()) do
				if k:FindFirstChild("Choosen") then
					table.insert(ret,tonumber(k.Text:sub(2)))
				end
			end
			return ret
		end)()
		if #serials > 0 then
			workspace.Remotes.Event:FireServer("Sell Serials",Item_Viewing,serials,price)
		end
	end)

end)

delay(.03,function()
	Add_Transparent_Effects(script.Parent.WebUI.TopBar.Catalog,2)
	script.Parent.WebUI.TopBar.Catalog.MouseButton1Click:connect(function()
		View_Catalog()
	end)
end)

--[[
delay(.03,function()
	items = workspace.Remotes.Function:InvokeServer("Get Item Table")
	coroutine.resume(coroutine.create(function()
		for i,k in pairs (items) do
			if not in_ordered_tbl(i) then
				local t = (function() local v = {} for e,r in pairs (k) do v[e] = r end return v end)()
				t.Name = i
			end
		end
	end))
	
	
	
end)
--]]



----------------------




--http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId=
