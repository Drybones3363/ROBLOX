-- Input Variables --
local Allow_Testing = false
local Center_of_Arena = Vector3.new(0,100,0)
local Radius_of_Bloodbath = 250
local Camera_Length = 2
local Height_of_View = 150
local Time_Per_View = 25
---------------------

script.Parent.Parent:SetTopbarTransparency(0)
local plr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local Character_View = CFrame.new(925.368164, 1100, 95.1495056, -0.691142678, 0.0749866143, -0.718817711, 7.45058149e-09, 0.994602859, 0.103756323, 0.722718418, 0.0717104152, -0.687412381)
local On_Menu = true
local TS = game:GetService("TeleportService")
TS.CustomizedTeleportUI = true
local CP = game:GetService("ContentProvider")
local ms = game:GetService("MarketplaceService")

local Products = {29816749,30069987,30072038,30224052,30224123,30374446,30462727}

local Sounds = {"rbxassetid://180550430","rbxassetid://180550530","rbxassetid://180570610","rbxassetid://236506714"}

local ButtonImages = {
	Play = {
		Pressed = "rbxassetid://258883101",
		Static = "rbxassetid://258883159"
	},
	Settings = {
		Pressed = "rbxassetid://258883182",
		Static = "rbxassetid://258883197"
	},
	Leaderboards = {
		Pressed = "rbxassetid://258883124",
		Static = "rbxassetid://258883136"
	},
	Shop = {
		Pressed = "rbxassetid://258883225",
		Static = "rbxassetid://258883246"
	},
	Characters = {
		Pressed = "rbxassetid://258867650",
		Static = "rbxassetid://258893255"
	},
	UpdateLog = {
		Pressed = "rbxassetid://258883271",
		Static = "rbxassetid://258883261"
	},
	BuyNow = {
		Pressed = "rbxassetid://266327039",
		Static = "rbxassetid://266327019"
	},
	Customization = {
		Pressed = "rbxassetid://303200093",
		Static = "rbxassetid://303200073"
	}
}

local Title_Images = {
	[0] = "rbxassetid://260370662",
	[1] = "rbxassetid://260370757",
	[2] = "rbxassetid://260370832",
	[3] = "rbxassetid://260370875",
	[4] = "rbxassetid://260370922",
	[5] = "rbxassetid://260370947",
	[6] = "rbxassetid://260370995",
	[7] = "rbxassetid://260371055",
	[8] = "rbxassetid://260371096",
	[9] = "rbxassetid://260371156",
	[10] = "rbxassetid://260371257",
	[11] = "rbxassetid://260371536",
	[12] = "rbxassetid://260371796",
	[13] = "rbxassetid://260371843",
	[14] = "rbxassetid://260371893",
	[15] = "rbxassetid://260371935"
}

local Arena_Images = {
	[1] = "rbxassetid://272165054",
	[2] = "rbxassetid://272165220",
	[3] = "rbxassetid://272165396",
	[4] = "rbxassetid://272165881"
}

local Bars = {
	Red = "rbxassetid://264634920",
	Orange = "rbxassetid://264639364",
	Yellow = "rbxassetid://264639316",
	Cyan = "rbxassetid://264639407",
	Blue = "rbxassetid://264639448"
}

local Product_Information = {}

local function Add_Character(char,img,index)
	if index == nil or index < 0 then index = #script.Parent.Characters.Selection:GetChildren() end
	local Canvas_Size = math.ceil(index/8) - 1
	local b = Instance.new("ImageButton",script.Parent.Characters.Selection)
	local pic = Instance.new("ImageLabel",b)
	local lbl = Instance.new("TextLabel",b)
	b.Name = char
	b.Image = "rbxassetid://190398671"
	b.AutoButtonColor = true
	b.BackgroundTransparency = 1
	b.ZIndex = 5
	b.Size = UDim2.new(.2/(index+2),0,.9,-10)
	b.Position = UDim2.new()
	pic.BackgroundTransparency = 1
	pic.Image = img
	pic.Size = UDim2.new(.8,0,.8,0)
	pic.ZIndex = 5
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1,0,1,0)
	lbl.Text = char
	lbl.FontSize = Enum.FontSize.Size18
	lbl.Font = Enum.Font.SourceSansBold
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextStrokeTransparency = 0
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.TextYAlignment = Enum.TextYAlignment.Bottom
end

local function Get_Online_Item(id)
	local model = game.Lighting:FindFirstChild("OnlineModels")
	if model == nil then model = Instance.new("Folder",game.Lighting) model.Name = "OnlineModels" end
	for i,k in pairs (model:GetChildren()) do
		if tonumber(k.Name) == id then
			return k:Clone()
		end
	end
	local item = game:GetService("InsertService"):LoadAsset(id):GetChildren()[1]
	item.Name = tostring(id)
	pcall(function()
		item.Handle.CanCollide = false
	end)
	item.Parent = model
	return item:Clone()
end

local function Update_Char()
	local char = workspace:FindFirstChild("CharacterDummy")
	if char then
		local idtbl = {}
		local tbl = workspace.Remotes.CtoS.GetCustomCharData:InvokeServer()
		for _,i in pairs ({"Hat1","Hat2","Hat3","Package","Jacket","Pants","Skin","Face"}) do
			local k = tbl[i]
			if k ~= nil and k > 0 then
				table.insert(idtbl,k)
				if char:FindFirstChild(tostring(k)) == nil then
					if i:sub(1,3) == "Hat" then
						--[[
						local item = Get_Online_Item(k)
						item.Parent = char
						--]]
						coroutine.resume(coroutine.create(function()
							
							local item = Get_Online_Item(k)
							if item.ClassName == "Hat" then
								local hand = item:WaitForChild("Handle")
								hand.Name = tostring(k)
								hand.CanCollide = false
								hand.Anchored = false
								local weld = Instance.new("Weld",hand)
								weld.Part0 = hand
								weld.Part1 = char.Head		
								weld.C0 = CFrame.new(0,-.5,0)
								weld.C1 = item.AttachmentPoint:inverse()
								hand.Parent = char
							end
						end))
						--]]
					elseif i == "Package" then
						for e,r in pairs (char:GetChildren()) do
							if r.ClassName == "CharacterMesh" then
								r:Destroy()
							end
						end
						local model = Get_Online_Item(k)
						for e,r in pairs (model:GetChildren()) do
							if r.ClassName == "CharacterMesh" then
								r.Parent = char
							end
						end
					elseif i == "Jacket" then
						char.Shirt.ShirtTemplate = "http://www.roblox.com/asset/?id="..tostring(k-1)
					elseif i == "Pants" then
						char.Pants.PantsTemplate = "http://www.roblox.com/asset/?id="..tostring(k-1)
					elseif i == "Skin" then
						for e,r in pairs (char:GetChildren()) do
							if r.ClassName == "Part" then
								r.BrickColor = BrickColor.new(Color3.new(tonumber(tostring(k):sub(1,tostring(k):len()-6))/255,tonumber(tostring(k):sub(tostring(k):len()-5,tostring(k):len()-3))/255,tonumber(tostring(k):sub(tostring(k):len()-2))/255))
							end
						end
					end					
				end
			end
			pcall(function()
				if char.Head.face.Texture ~= "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(tbl.Face) then
					char.Head.face.Texture = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(tbl.Face)
				end
			end)
		end
		local function intbl(id)
			for i,k in pairs (idtbl) do
				if id == k then return true end
			end
		end
		for i,k in pairs(char:GetChildren()) do
			if tonumber(k.Name) then
				if not intbl(tonumber(k.Name)) then
					k:Destroy()
				end
			end
		end
	end
end

function intro()
	local color = nil
	
	local function returnColors(obj,r,g,b,endR,endG,endB,type,speed)
		--coroutine.resume(coroutine.create(function()
			for time = 0, 1, speed do
				wait()
				local r = ((r - (r - endR) * time))
				local g = ((g - (g - endG) * time))
				local b = ((b - (b - endB) * time))
				   
				if type == "Frame" then
					obj.BackgroundColor3 = Color3.new(r/255,g/255,b/255)
				elseif type == "Image" then
					obj.ImageColor3 = Color3.new(r/255,g/255,b/255)
				end
			end
		--end))
	end
		
	local function addPulse(duration)
		coroutine.resume(coroutine.create(function()
			local pulse = script.Pulse:Clone()
			pulse.Parent = script.Parent.Background1
			pulse.ImageColor3 = color
			pulse:TweenSizeAndPosition(UDim2.new(0.4,0,0.8,0),UDim2.new(0.3,0,0.1,0),"Out","Linear",duration)
			wait(duration-0.5)
			for i = 1,50 do
				pulse.ImageTransparency = pulse.ImageTransparency + 0.025
				wait()
			end
		end))
	end
	
	local function addBlip(duration,duration2)
		local r = script.Parent.Background1.BackgroundColor3.r*255
		local g = script.Parent.Background1.BackgroundColor3.g*255
		local b = script.Parent.Background1.BackgroundColor3.b*255
		returnColors(script.Parent.Background1,r,g,b,150,0,0,"Frame",duration)
		
		wait(duration2)
		local r2 = script.Parent.Background1.BackgroundColor3.r*255
		local g2 = script.Parent.Background1.BackgroundColor3.g*255
		local b2 = script.Parent.Background1.BackgroundColor3.b*255
		returnColors(script.Parent.Background1,0,0,0,r,g,b,"Frame",duration)
	end
	
	local function addColorBlip(duration,duration2,color)
		local r = script.Parent.Background1.BackgroundColor3.r*255
		local g = script.Parent.Background1.BackgroundColor3.g*255
		local b = script.Parent.Background1.BackgroundColor3.b*255
		returnColors(script.Parent.Background1,r,g,b,color.r*255,color.g*255,color.b*255,"Frame",duration)
		
		wait(duration2)
		returnColors(script.Parent.Background1,color.r*255,color.g*255,color.b*255,0,0,0,"Frame",duration)
	end
	
	local function addBeat(duration,duration2,ran)
		local r = script.Parent.Background1.BackgroundColor3.r*255
		local g = script.Parent.Background1.BackgroundColor3.g*255
		local b = script.Parent.Background1.BackgroundColor3.b*255
		returnColors(script.Parent.Background1,r,g,b,ran.r*255,ran.g*255,ran.b*255,"Frame",duration)
		wait(duration2)
	end
	
	script.Parent.Background1.BackgroundTransparency = 0
	wait(2)
	script.Parent.Music:Play()
	wait(0.1)
	script.Parent.Background1.The.Visible = true
	addBlip(0.15,0.05)
	script.Parent.Background1.The.Visible = false
	script.Parent.Background1.Entity.Visible = true
	addBlip(0.15,0.7)
	script.Parent.Background1.Entity.Visible = false
	script.Parent.Background1.Its.Visible = true
	addBlip(0.3,0)
	script.Parent.Background1.Its.Visible = false
	script.Parent.Background1.Behind.Visible = true
	addBlip(0.3,0)
	script.Parent.Background1.Behind.Visible = false
	script.Parent.Background1.You.Visible = true
	addBlip(0.2,0.05)
	script.Parent.Background1.You.Visible = false
	
	local num = 0
	local colors = {
		Color3.new(0.75,0,0),
		Color3.new(0,0.75,0),
		Color3.new(0,0,0.75),
	}
	local lastColor = nil
	script.Parent.Background1.ObsInno.Visible = true
	while wait(0.25) do
		num = num + 1
		color = colors[math.random(1,#colors)]
		if color == lastColor then
			repeat color = colors[math.random(1,#colors)] until color ~= lastColor
		end
		lastColor = color
		if num == 8 or num == 16 or num == 23 or num == 35 or num == 43 or num == 50 then
			pcall(function()
				addPulse(0.75)
				addBeat(0.1,0.15,Color3.new(0.75,0.25,0))
				addPulse(0.25)
				addBeat(0.3,0.075,Color3.new(0.75,0,0.75))
			end)
		elseif num == 26 then
			pcall(function()
				addPulse(0.5)
				addBeat(0.15,0.2,Color3.new(0,0.75,0.75))
				addPulse(0.25)
				addBeat(0.15,0.2,Color3.new(0.75,0.75,0))
			end)
		elseif num == 28 then
			for i = 1,7 do 
				addPulse(0.25)
				addColorBlip(0.9,0,Color3.new(0.75,0,0))
			end
		elseif num == 29 then
			script.Parent.Background1.ObsInno.Visible = false
			coroutine.resume(coroutine.create(function()
				local delay = 0
				for i = 1,50 do
					delay = delay + 1
					script.Parent.Music.Volume = script.Parent.Music.Volume - 0.01
					if delay % 3 == 0 then
						wait()
					end
				end
			end))
			addColorBlip(0.075,0,Color3.new(0.75,0,0))
			wait(0.5)
			script.Parent.Background1.BackgroundColor3 = Color3.new(0.75,0,0)
			script.Parent.Background1.Enjoy.Visible = true
			addBlip(0.15,0.05)
			script.Parent.Background1.Enjoy.Visible = false
			script.Parent.Background1.The2.Visible = true
			addBlip(0.15,0.05)
			script.Parent.Background1.The2.Visible = false
			script.Parent.Background1.Game.Visible = true
			addBlip(0.15,0.05)
			script.Parent.Background1.Game.Visible = false
			script.Parent.Background1:Destroy()
		else
			if num < 29 then
				pcall(function()
					addBeat(0.3,0,color)
					addPulse(0.2)
				end)
			end
		end
	end
end

--[[game.Workspace.CurrentCamera.CameraType = "Scriptable"
game.Workspace.CurrentCamera:Interpolate(CFrame.new(100,1000,100),CFrame.new(100,10000,100),0.5)
coroutine.resume(coroutine.create(intro))

wait(20)]]

for _,t in pairs (ButtonImages) do
	for _,k in pairs (t) do
		CP:Preload(k)
	end
end

for _,k in pairs (Title_Images) do
	CP:Preload(k)
end

for _,k in pairs (Arena_Images) do
	CP:Preload(k)
end

for _,k in pairs (Bars) do
	CP:Preload(k)
end

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)

local function Transition(half)
	for i=1,0,(-1/30) do
		script.Parent.Transition.Transparency = i
		wait()
	end
	script.Parent.Transition.Transparency = 0
	if half == nil or half == false then
		for i=0,1,(1/30) do
			script.Parent.Transition.Transparency = i
			wait()
		end
		script.Parent.Transition.Transparency = 1
	end
end

local function p_t(t)
	for i,k in pairs (t) do
		print(i,k)
		if type(k) == "table" then
			p_t(k)
		end
	end
end

local On_Custom,Class_Selected,Item_Type = false,0

coroutine.resume(coroutine.create(function()
	local frame = script.Parent.Parent:WaitForChild('CustomGui'):WaitForChild('Items'):WaitForChild('ClassFrame'):WaitForChild('Frame')
	for i,k in pairs (frame:GetChildren()) do
		if k:FindFirstChild("Button") then
			k.Button.MouseButton1Click:connect(function()
				if Class_Selected == tonumber(k.Name:sub(5)) then
					Class_Selected = 0
					for e,r in pairs (frame:GetChildren()) do
						r.BackgroundColor3 = Color3.new(1,1,1)
					end
				else
					Class_Selected = tonumber(k.Name:sub(5))
					for e,r in pairs (frame:GetChildren()) do
						r.BackgroundColor3 = Color3.new(1,1,1)
					end
					k.BackgroundColor3 = Color3.new(0,1,0)
				end
			end)
		end
	end
end))

coroutine.resume(coroutine.create(function()
	script.Parent.Parent:WaitForChild("CustomGui").Exit.MouseButton1Click:connect(function()
		script.Parent.Parent.CustomGui.Exit.Visible = false
		script.Parent.Parent.CustomGui.Items.Visible = false
		pcall(function()
			workspace.CharacterDummy:Destroy()
		end)
		pcall(function()
			script.Parent.Parent.CustomGui.Buttons:Destroy()
		end)
		for i=1,0,(-1/30) do
			script.Parent.Background.BackgroundTransparency = i
		end
		script.Parent.Background.BackgroundTransparency = 0
		script.Parent.Title.Visible = true
		script.Parent.Title.Backup.Visible = true
		On_Custom = false
		On_Menu = true
		coroutine.resume(coroutine.create(function()
			for i=1,0,(-1/30) do
				script.Parent.CharacterTheme.Volume = .337*i
				wait()
			end
			script.Parent.CharacterTheme.Volume = 0
			for i=0,1,(1/30) do
				script.Parent.Theme.Volume = .75*i
				wait()
			end
			script.Parent.Theme.Volume = .75
		end))
		script.Parent.Transition.BackgroundTransparency = 1
		script.Parent.Buttons:TweenPosition(UDim2.new(0,0,0,0))
		script.Parent.Background.BackgroundTransparency = 1
	end)
end))

coroutine.resume(coroutine.create(function()
	local frame = script.Parent.Parent:WaitForChild("CustomGui").Items
	
	local customdata = {}
	
	local customtbl = {}
	
	local function Update_Data()
		pcall(function()
			customdata = workspace.Remotes.CtoS.GetCustomData:InvokeServer()
		end)
	end
	
	local function Get_ID_From_Image(image)
		return tonumber(image:sub(70))
	end
	
	local function Create_Image_Button()
		local button = Instance.new("ImageButton")
		button.BackgroundColor3 = Color3.new(1,0,0)
		button.BackgroundTransparency = .75
		button.Size = UDim2.new(.175,0,.175,0)
		button.ScaleType = Enum.ScaleType.Stretch
		return button
	end
	
	local function Get_Data(typ)
		local ret = {}
		for i,k in pairs (customtbl[typ]) do
			if #k > 1 then
				ret[k[1]] = {}
				for e=2,#k do
					table.insert(ret[k[1]],k[e])
				end
			end
		end
		return ret
	end
	
	local function Get_Cur_Type_Data(typ) --returns {}
		if type(typ) == "string" then typ = typ == "Unlockable" and 1 or typ == "Buyable" and 3 or 2 end
		local ret = {}
		local i_typ = (Item_Type == "SkinColor" and "Skins") or (Item_Type == "Faces" and "Face") or Item_Type
		for i,k in pairs (i_typ and customtbl[i_typ] or {}) do
			if k[2] and k[2] == typ then
				local num = #ret
				if num < 1 then
					ret[1] = k
				else
					local done = false
					for e=1,num do
						if k[3] <= ret[e][3] then
							table.insert(ret,e,k)
							done = true
							break
						end
					end
					if done == false then
						ret[#ret+1] = k
					end
				end
			end
		end
		return ret
	end
	
	local function Return_Prestige_String(lvl)
		local str = ""
		if lvl/24 >= 1 then
			str = str.."Prestige "..tostring(math.floor(lvl/24))
			if lvl-24*math.floor(lvl/24) > 0 then
				str = str..", "
			end
		end
		lvl = lvl - 24*math.floor(lvl/24)
		if lvl > 0 then
			str = str.."Level "..tostring(lvl)
		end
		return str
	end
	
	local function Update_Classes(first)
		local f = script.Parent.Parent.CustomGui.Items.ClassFrame.Frame
		local tab = workspace.Remotes.CtoS.GetCustomCharData:InvokeServer()
		if first then
			repeat wait() tab = workspace.Remotes.CtoS.GetCustomCharData:InvokeServer() until tab ~= nil
		end
		for i=1,3 do
			local id = tab and tab["Class"..tostring(i)]
			local fr = f["Char"..tostring(i)]
			pcall(function()
				fr.BackgroundColor3 = Color3.new(1,1,1)
				fr.CharPic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(id)
				Update_Data()
				fr.lblName.Text = customdata[tostring(id)] and customdata[tostring(id)].Name or ""
			end)
		end
		Class_Selected = 0
	end
	coroutine.resume(coroutine.create(function()
		Update_Classes(true)
	end))
	
	local Button,C_Button,ID,ProductID = script.Parent.Parent.CustomGui.Items.Details.Action,script.Parent.Parent.CustomGui.Items.ClassDetails.Action,0,0
	
	local C_Action = {
		Buy = function(id)
			C_Button.BackgroundColor3 = Color3.new(1,1,0)
			C_Button.BackgroundTransparency = 0
			C_Button.Text = "Buy"
			ProductID = id
		end,
		Equip = function()
			C_Button.BackgroundColor3 = Color3.new(0,1,0)
			C_Button.BackgroundTransparency = 0
			C_Button.Text = "Equip"
			ProductID = 0
		end,
		Remove = function()
			C_Button.BackgroundColor3 = Color3.new(1,0,0)
			C_Button.BackgroundTransparency = 0
			C_Button.Text = "Remove"
			ProductID = 0
		end,
		Unavailable = function()
			C_Button.BackgroundColor3 = Color3.new(1,1,1)
			C_Button.BackgroundTransparency = 1
			C_Button.Text = "Unavailable"
			ProductID = 0
		end,
		Unlock = function(lvl)
			if lvl == nil then lvl = 1 end
			C_Button.BackgroundColor3 = Color3.new(1,1,1)
			C_Button.BackgroundTransparency = 1
			C_Button.Text = Return_Prestige_String(lvl)
			ProductID = 0
		end
	}
	
	C_Button.MouseButton1Click:connect(function()
		if C_Button.Text == "Buy" and ProductID > 0 then
			local function is_product()
				for _,k in pairs (Products) do 
					if k == ProductID then
						return true
					end
				end
			end
			if is_product() then
				pcall(function() ms:PromptProductPurchase(game.Players.LocalPlayer,ProductID) end)
			else
				pcall(function() ms:PromptPurchase(game.Players.LocalPlayer,ProductID) end)
			end
		elseif C_Button.Text == "Equip" or C_Button.Text == "Remove" then
			workspace.Remotes.CtoS.EditChar:FireServer(C_Button.Text,ID,Item_Type,Class_Selected)
			C_Action[C_Button.Text == "Equip" and "Remove" or "Equip"]()
			Update_Classes()
		end
	end)
	
	local Action = {
		Buy = function(id)
			Button.BackgroundColor3 = Color3.new(1,1,0)
			Button.BackgroundTransparency = 0
			Button.Text = "Buy"
			ProductID = id
		end,
		Equip = function()
			Button.BackgroundColor3 = Color3.new(0,1,0)
			Button.BackgroundTransparency = 0
			Button.Text = "Equip"
			ProductID = 0
		end,
		Remove = function()
			Button.BackgroundColor3 = Color3.new(1,0,0)
			Button.BackgroundTransparency = 0
			Button.Text = "Remove"
			ProductID = 0
		end,
		Unavailable = function()
			Button.BackgroundColor3 = Color3.new(1,1,1)
			Button.BackgroundTransparency = 1
			Button.Text = "Unavailable"
			ProductID = 0
		end,
		Unlock = function(lvl)
			if lvl == nil then lvl = 1 end
			Button.BackgroundColor3 = Color3.new(1,1,1)
			Button.BackgroundTransparency = 1
			Button.Text = Return_Prestige_String(lvl)
			ProductID = 0
		end
	}
	
	Button.MouseButton1Click:connect(function()
		if Button.Text == "Buy" and ProductID > 0 then
			local function is_product()
				for _,k in pairs (Products) do 
					if k == ProductID then
						return true
					end
				end
			end
			if is_product() then
				pcall(function() ms:PromptProductPurchase(game.Players.LocalPlayer,ProductID) end)
			else
				pcall(function() ms:PromptPurchase(game.Players.LocalPlayer,ProductID) end)
			end
		elseif Button.Text == "Equip" or Button.Text == "Remove" then
			workspace.Remotes.CtoS.EditChar:FireServer(Button.Text,ID,Item_Type)
			Update_Char()
			Action[Button.Text == "Equip" and "Remove" or "Equip"]()
		end
	end)
	
	script.Parent.Parent.CustomGui.Items.Details.SitePurchase.MouseButton1Click:connect(function()
		if ID == nil or type(ID) ~= "number" or ID == 0 then return end
		ms:PromptPurchase(game.Players.LocalPlayer,ID,false)
	end)
	
	frame.Down.MouseButton1Click:connect(function()
		local pos = frame.Frame.Selection.Position
		local function Legal()
			for i,k in pairs (frame.Frame.Selection:GetChildren()) do
				if k.Position.Y.Scale + pos.Y.Scale >= 1 then
					return true
				end
			end
		end
		if Legal() then
			frame.Frame.Selection:TweenPosition(pos+UDim2.new(0,0,-1,0))
		end
	end)
	
	frame.Up.MouseButton1Click:connect(function()
		local pos = frame.Frame.Selection.Position
		local function Legal()
			for i,k in pairs (frame.Frame.Selection:GetChildren()) do
				if -(pos.Y.Scale + k.Position.Y.Scale) >= 0 then
					return true
				end
			end
		end
		if Legal() then
			frame.Frame.Selection:TweenPosition(pos+UDim2.new(0,0,1,0))
		end
	end)
	
	local function Get_Class_Data(id)
		local model = game.Lighting:FindFirstChild("ClassModels")
		if model == nil then model = Instance.new("Model",game.Lighting) model.Name = "ClassModels" end
		if model:FindFirstChild(tostring(id)) and model[tostring(id)]:FindFirstChild("Data") then
			local t = {}
			for i,k in pairs (model[tostring(id)].Data:GetChildren()) do
				t[k.Name] = k.Value
			end
			return t
		end
		local i = game:GetService("InsertService"):LoadAsset(id):GetChildren()[1]
		i.Name = tostring(id)
		i.Parent = model
		local t = {}
		for _,k in pairs (i:FindFirstChild("Data") and i.Data:GetChildren() or {}) do
			t[k.Name] = k.Value
		end
		return t
	end
	
	wait(3)
	local custom = workspace.Remotes.CtoS:WaitForChild("GetCustomTable")
	customtbl = custom:InvokeServer()
	
	local connection = {}
	
	function Load_Items()
		for i,k in pairs (connection) do
			k:disconnect()
		end
		for _,e in pairs ({"Unlockable","Buyable","Limited"}) do
			script.Parent.Parent.CustomGui.Items[e].TextStrokeTransparency = .75
			script.Parent.Parent.CustomGui.Items[e].TextTransparency = .5
			script.Parent.Parent.CustomGui.Items[e].BackgroundColor3 = Color3.new(.2,.2,.2)
		end
		script.Parent.Parent.CustomGui.Items.Frame.Selection:ClearAllChildren()
		for n,k in pairs ({"Unlockable","Buyable","Limited"}) do
			local button = script.Parent.Parent.CustomGui.Items[k]
			connection[n] = button.MouseButton1Click:connect(function()
				for _,e in pairs ({"Unlockable","Buyable","Limited"}) do
					script.Parent.Parent.CustomGui.Items[e].TextStrokeTransparency = .75
					script.Parent.Parent.CustomGui.Items[e].TextTransparency = .5
					script.Parent.Parent.CustomGui.Items[e].BackgroundColor3 = Color3.new(.2,.2,.2)
				end
				button.TextStrokeTransparency = .25
				button.TextTransparency = 0
				button.BackgroundColor3 = Color3.new(.4,.4,.4)
				script.Parent.Parent.CustomGui.Items.Details.Visible = false
				script.Parent.Parent.CustomGui.Items.ClassDetails.Visible = false
				script.Parent.Parent.CustomGui.Items.Frame.Selection:ClearAllChildren()
				script.Parent.Parent.CustomGui.Items.Frame.Selection.Position = UDim2.new(0,0,0,0)
				script.Parent.Parent.CustomGui.Items.Frame.Visible = true
				local data = Get_Cur_Type_Data(k)
				if Item_Type == "SkinColor" then
					for i=1,#data do
						local b = Instance.new("TextButton")
						b.Position = UDim2.new(.2*((i-1)%5),0,.2*(math.ceil(i/5)-1)+.001,0)
						b.BackgroundTransparency = .1
						b.BorderSizePixel = 0
						b.Size = UDim2.new(.175,0,.175,0)
						b.Text = ""
						b.BackgroundColor3 = Color3.new(.004*tonumber(tostring(data[i][1]):sub(1,tostring(data[i][1]):len()-6)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-5,tostring(data[i][1]):len()-3)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-2)))
						b.Parent = script.Parent.Parent.CustomGui.Items.Frame.Selection
						b.MouseEnter:connect(function()
							b.BackgroundTransparency = .25
						end)
						b.MouseLeave:connect(function()
							b.BackgroundTransparency = .1
						end)
						b.MouseButton1Up:connect(function()
							b.BackgroundTransparency = .25
						end)
						b.MouseButton1Down:connect(function()
							b.BackgroundTransparency = .5
						end)
						b.MouseButton1Click:connect(function()
							script.Parent.Parent.CustomGui.Items.Frame.Visible = false
							script.Parent.Parent.CustomGui.Items.Details.Action.Visible = false
							script.Parent.Parent.CustomGui.Items.Details.Visible = true
							ID = data[i][1]
							pcall(function()
								local sel = script.Parent.Parent.CustomGui.Items.Details.Selection
								sel.Pic.Image = ""
								sel.Pic.BackgroundTransparency = .1
								sel.Parent.SitePurchase.Visible = false
								sel.Pic.BackgroundColor3 = Color3.new(.004*tonumber(tostring(data[i][1]):sub(1,tostring(data[i][1]):len()-6)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-5,tostring(data[i][1]):len()-3)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-2)))
								sel.Desc.Text = BrickColor.new(.004*tonumber(tostring(data[i][1]):sub(1,tostring(data[i][1]):len()-6)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-5,tostring(data[i][1]):len()-3)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-2))).Name.." Skin Color :)"
								sel.Item.Text = BrickColor.new(.004*tonumber(tostring(data[i][1]):sub(1,tostring(data[i][1]):len()-6)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-5,tostring(data[i][1]):len()-3)),.004*tonumber(tostring(data[i][1]):sub(tostring(data[i][1]):len()-2))).Name
							end)
							local eligible,arg2 = workspace.Remotes.CtoS.IsEligible:InvokeServer(data[i][1])
							Action[eligible](arg2)
							script.Parent.Parent.CustomGui.Items.Details.Action.Visible = true
						end)
					end
				else
					for i=1,#data do
						local r = data[i]
						local b = script.Pic:Clone()
						b.Position = UDim2.new(.2*((i-1)%5),0,.2*(math.ceil(i/5)-1)+.001,0)
						b.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(r[1])
						b.Parent = script.Parent.Parent.CustomGui.Items.Frame.Selection
						b.MouseEnter:connect(function()
							b.BackgroundTransparency = .5
						end)
						b.MouseLeave:connect(function()
							b.BackgroundTransparency = .75
						end)
						b.MouseButton1Up:connect(function()
							b.BackgroundTransparency = .5
						end)
						b.MouseButton1Down:connect(function()
							b.BackgroundTransparency = .25
						end)
						b.MouseButton1Click:connect(function()
							if Item_Type == "Classes" then
								script.Parent.Parent.CustomGui.Items.Frame.Visible = false
								local c_det = script.Parent.Parent.CustomGui.Items.ClassDetails
								ID = r[1]
								Update_Data()
								local tbl = customdata[tostring(r[1])]
								local t = Get_Class_Data(r[1])
								for i,k in pairs (t) do
									pcall(function()
										local x = k*.01
										c_det[i].bar.Size = UDim2.new(x,0,1,0)
										if x <= .225 then
											c_det[i].bar.Image = Bars.Blue
										elseif x <= .45 then
											c_det[i].bar.Image = Bars.Cyan
										elseif x <= .675 then
											c_det[i].bar.Image = Bars.Yellow
										elseif x <= .9 then
											c_det[i].bar.Image = Bars.Orange
										else
											c_det[i].bar.Image = Bars.Red
										end
									end)
								end
								pcall(function()
									c_det.Pic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(r[1])
									c_det.lblName.Text = tbl.Name
								end)
								local eligible,arg2 = workspace.Remotes.CtoS.IsEligible:InvokeServer(r[1])
								C_Action[eligible](arg2)
								c_det.Visible = true
							else
								script.Parent.Parent.CustomGui.Items.Frame.Visible = false
								ID = r[1]
								Update_Data()
								local tbl = customdata[tostring(r[1])]
								pcall(function()
									local sel = script.Parent.Parent.CustomGui.Items.Details.Selection
									sel.Parent.SitePurchase.Visible = true
									sel.Pic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(r[1])
									sel.Pic.BackgroundTransparency = 1
									sel.Desc.Text = tbl.Description
									sel.Item.Text = tbl.Name
								end)
								script.Parent.Parent.CustomGui.Items.Details.Action.Visible = false
								script.Parent.Parent.CustomGui.Items.Details.Visible = true
								local eligible,arg2 = workspace.Remotes.CtoS.IsEligible:InvokeServer(r[1])
								Action[eligible](arg2)
								script.Parent.Parent.CustomGui.Items.Details.Action.Visible = true
							end
						end)
					end
				end
			end)
		end
	end
end))

local function View_Custom()
	local cam = game.Workspace.CurrentCamera
	cam.CameraType = "Scriptable"
	
	cam.CoordinateFrame = game.Workspace.CamPos.CFrame
	cam.Focus = game.Workspace.LookPoint.CFrame
	cam:Interpolate(game.Workspace.CamPos.CFrame,game.Workspace.LookPoint.CFrame,1.337)
	
	local fr = script.Buttons:Clone()
	fr.Parent = script.Parent.Parent.CustomGui
	local gui = fr.Parent
	gui.Exit.Visible = true
	local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
	local rotate = false
	local lastX = 0
	local dummy = script.CharacterDummy:Clone()
	dummy.Parent = workspace
	
	repeat wait() until script:FindFirstChild("Idle")
	
	local tweenData = {
		Position = UDim2.new(0.05,0,0.1,0),
		Size = UDim2.new(0.3,0,0.05,0),
	}
	local positions = {}
	local idle = dummy.Humanoid:LoadAnimation(script.Idle)
	local scratch = dummy.Humanoid:LoadAnimation(script.Scratch)
	local head = dummy.Head:Clone()
	local weld = Instance.new("Weld",head)
	weld.Part0 = head
	weld.Part1 = dummy.Head
	dummy.Head.Transparency = 1
	head.Parent = dummy
	head.Name = "FakeHead"
	
	local clicked = false
	local clickedType = ""
	
	Update_Char()
	
	for a,b in pairs(gui.Buttons:GetChildren()) do
		if b:IsA("TextButton") then
			table.insert(positions,{Name = b.Name,Position = b.Position,Size = b.Size,Text = b.Text})
		end
	end
	
	for a,b in pairs(gui.Buttons:GetChildren()) do
		if b:IsA("TextButton") then
			b.MouseButton1Down:connect(function()
				Item_Type = b.Name
				Load_Items()
				coroutine.resume(coroutine.create(function()
					if clicked == false then
						clicked = true
						clickedType = b.Name
						for c,d in pairs(gui.Buttons:GetChildren()) do
							pcall(function()
								if d.Name ~= clickedType then
									pcall(function() d.Arrow.Visible = false end)
									d:TweenPosition(UDim2.new(d.Position.X.Scale,0,d.Position.Y.Scale-1,0),"Out","Linear",0.5)
									wait(0.5)
								end
							end)
						end
						for c,d in pairs(gui.Buttons:GetChildren()) do
							pcall(function()
								if d.Name == clickedType then
									for e,f in pairs(game.Workspace:GetChildren()) do
										if f:FindFirstChild("CurrentItem") then
											f:Destroy()
										end
									end
									for e,f in pairs(script.Parent.Parent:GetChildren()) do
										if f:IsA("TextButton") then
											f.Visible = false
										end
									end
									if gui:FindFirstChild(clickedType) then
										gui:FindFirstChild(clickedType):TweenPosition(UDim2.new(0.05,0,0.175,0),"Out","Linear",0.5)
									end
									pcall(function() d.Arrow.Visible = false end)
									d:TweenPosition(tweenData.Position,"Out","Linear",0.5)
									d:TweenSize(tweenData.Size,"Out","Linear",0.5)
									wait(0.5)
									d.Text = "Click to return to Customization Options"
									gui.Items.Visible = true
									if clickedType == "Classes" then
										gui.Items.ClassFrame.Visible = true
									end
									local newClick = false
									
									d.MouseButton1Down:connect(function()
										if newClick == false then
											gui.Items.Details.Visible = false
											gui.Items.Visible = false
											gui.Items.ClassFrame.Visible = false
											gui.Items.ClassDetails.Visible = false
											if gui:FindFirstChild(clickedType) then
												gui:FindFirstChild(clickedType):TweenPosition(UDim2.new(-3,0,0.175,0),"Out","Linear",0.5)
											end
											newClick = true
											for e,f in pairs(gui.Buttons:GetChildren()) do
												for i = 1,#positions do
													if positions[i].Name == f.Name then
														f:TweenPosition(positions[i].Position,"Out","Linear",0.5)
														f:TweenSize(positions[i].Size,"Out","Linear",0.5)
														wait(0.5)
														f.Text = positions[i].Text
														pcall(function() f.Arrow.Visible = true end)
													end
												end
											end
											clicked = false
										end
									end)
								end
							end)
						end
					end
				end))
			end)
		end
	end
	
	mouse.Button1Down:connect(function()
		rotate = true
	end)
	
	mouse.Button1Up:connect(function()
		rotate = false
	end)
	
	idle:Play()
	
	coroutine.resume(coroutine.create(function()
		while wait() and On_Custom do
			wait(math.random(4,15))
			scratch:Play()
		end
	end))
	
	coroutine.resume(coroutine.create(function()
		while wait() and On_Custom do
			if rotate == true then
				local disp = lastX - math.abs(mouse.X)
				lastX = math.abs(mouse.X)
				local rotNum = disp*.01
				if rotNum > .5 then
					rotNum = .5
				end
				if rotNum < -.5 then
					rotNum = -.5
				end
				if mouse.X < 400 then
					rotNum = 0
				end
				dummy:SetPrimaryPartCFrame(dummy.Torso.CFrame * CFrame.fromEulerAnglesXYZ(0,-rotNum,0))
				if rotNum == 0 then
					dummy:SetPrimaryPartCFrame(dummy.Torso.CFrame * CFrame.fromEulerAnglesXYZ(0,-0.005,0))
				end
			else
				dummy:SetPrimaryPartCFrame(dummy.Torso.CFrame * CFrame.fromEulerAnglesXYZ(0,-0.005,0))
			end
		end
	end))
end

local function add_Background_Effects(button)
	button.MouseEnter:connect(function()
		button.BackgroundTransparency = .75
	end)
	button.MouseLeave:connect(function()
		button.BackgroundTransparency = 1
	end)
	button.MouseButton1Down:connect(function()
		button.BackgroundTransparency = .5
	end)
	button.MouseButton1Up:connect(function()
		button.BackgroundTransparency = .75
	end)
end

local function addButtonEffects(button)
	button.MouseLeave:connect(function()
		button.Image = ButtonImages[button.Name].Static
	end)
	button.MouseButton1Down:connect(function()
		button.Image = ButtonImages[button.Name].Pressed
	end)
	button.MouseButton1Up:connect(function()
		button.Image = ButtonImages[button.Name].Static
	end)
	if button.Name ~= "BuyNow" then
		button.MouseButton1Click:connect(function()
			script.Parent.Buttons:TweenPosition(UDim2.new(0,0,1,0))
			if button.Name == "Characters" then
				for i=1,0,(-1/30) do
					--script.Parent.Transition.BackgroundTransparency = i
					script.Parent.Theme.Volume = i*.5
					wait()
				end
				--script.Parent.Transition.BackgroundTransparency = 0
				script.Parent.Theme.Volume = 0
				script.Parent.Characters.Visible = true
				script.Parent.Title.Visible = false
				script.Parent.Title.Backup.Visible = false
				On_Menu = false
				cam:Interpolate(Character_View,workspace.Backboard.CFrame,.01)
				script.Parent.CharacterTheme:Play()
				for i=0,.337,(1/90) do
					script.Parent.CharacterTheme.Volume = i
					wait()
				end
				script.Parent.CharacterTheme.Volume = .337
			elseif button.Name == "UpdateLog" then
				script.Parent.UpdateLog:TweenPosition(UDim2.new(0,0,0,0),"Out","Linear",1)
				script.Parent.Title:TweenPosition(UDim2.new(0,0,-1.125,0),"Out","Linear",1)
				wait(1)
				script.Parent.UpdateLog.Back.Visible = true
				script.Parent.UpdateLog.Back.MouseButton1Down:connect(function()
					script.Parent.UpdateLog.Back.Visible = false
					script.Parent.UpdateLog:TweenPosition(UDim2.new(0,0,-1,0),"Out","Linear",1)
					script.Parent.Buttons:TweenPosition(UDim2.new(0,0,0,0),"Out","Linear",1)
					script.Parent.Title:TweenPosition(UDim2.new(0.125,0,0,0),"Out","Linear",1)
				end)
			elseif button.Name == "Leaderboards" then
				script.Parent.Title:TweenPosition(UDim2.new(0,0,-1.125,0),"Out","Linear",1)
				wait(0.5)
				script.Parent.Leaderboard:TweenPosition(UDim2.new(0.25,0,0.25,0),"Out","Linear",1)
				script.Parent.Leaderboard.Back.Visible = true
				script.Parent.Leaderboard.Back.MouseButton1Down:connect(function()
					script.Parent.Leaderboard.Back.Visible = false
					script.Parent.Leaderboard:TweenPosition(UDim2.new(0.25,0,1.25,0),"Out","Linear",1)
					wait(0.5)
					script.Parent.Buttons:TweenPosition(UDim2.new(0,0,0,0),"Out","Linear",1)
					script.Parent.Title:TweenPosition(UDim2.new(0.125,0,0,0),"Out","Linear",1)
				end)
			elseif button.Name == "Shop" then
				for i=1,0,(-1/30) do
					script.Parent.Theme.Volume = i*.5
					wait()
				end
				script.Parent.Theme.Volume = 0
				script.Parent.Skins.Visible = true
				script.Parent.Title.Visible = false
				script.Parent.Title.Backup.Visible = false
				script.Parent.Background.Visible = false
				On_Menu = false
				cam:Interpolate(workspace.TextureModel.CamPos.CFrame,workspace.TextureModel.CamFocus.CFrame,0.03)
				script.Parent.ShopTheme:Play()
				script.Parent.ShopTheme.Volume = .6
			elseif button.Name == "Customization" then				
				for i=1,0,(-1/30) do
					--script.Parent.Transition.BackgroundTransparency = i
					script.Parent.Theme.Volume = i*.5
					wait()
				end
				--script.Parent.Transition.BackgroundTransparency = 0
				script.Parent.Theme.Volume = 0
				script.Parent.Title.Visible = false
				script.Parent.Title.Backup.Visible = false
				On_Menu = false
				On_Custom = true
				View_Custom()
				script.Parent.CharacterTheme:Play()
				for i=0,.337,(1/90) do
					script.Parent.CharacterTheme.Volume = i
					wait()
				end
				script.Parent.CharacterTheme.Volume = .337
			end
		end)
	end
end


coroutine.resume(coroutine.create(function()
	local buynow
	repeat
		pcall(function()
			buynow = script.Parent.Characters.Details.Requirement.BuyNow
		end)
		wait()
	until buynow
	addButtonEffects(buynow)
	buynow.MouseButton1Click:connect(function()
	
	end)
end))

--[[coroutine.resume(coroutine.create(function()
	while wait(30) do
		local smoothPlayers = serverds:GetAsync("SmoothPlayers")
		local trianglePlayers = serverds:GetAsync("TrianglePlayers")
		if trianglePlayers == nil then trianglePlayers = 0 end
		if smoothPlayers == nil then smoothPlayers = 0 end
		
		script.Parent.ArenaType.Background.Smooth.PlayerCount.Text = "Player Count: "..smoothPlayers
		script.Parent.ArenaType.Background.Triangle.PlayerCount.Text = "Player Count: "..trianglePlayers
	end
end))]]

local bframe = script.Parent:WaitForChild("Buttons")
bframe.ChildAdded:connect(function(c)
	if c.ClassName == "ImageButton" then
		addButtonEffects(c)
	end
end)
for _,k in pairs (bframe:children()) do
	if k.ClassName == "ImageButton" then
		addButtonEffects(k)
	end
end

local hgData = {
	{332461990,UDim2.new(0,0,0,0),UDim2.new(-2,0,-1,0),5},
	{332462087,UDim2.new(-2,0,0,0),UDim2.new(0,0,-0.5,0),6},
	{272289745,UDim2.new(0,0,-1,0),UDim2.new(-2,0,0,0),5},
	{272289891,UDim2.new(0,0,0,0),UDim2.new(-2,0,-0.5,0),6},
}

local data = {
	{"ObscureEntity & FutureWebsiteOwner","8/30/2015","These games are modeled after the 74th Annual Hunger games, an open world survival. Survive the odds, against the Game Makers and against the other tributes. Be the last to survive and be crowned Victor!"},
	{"FutureWebsiteOwner & ObscureEntity","?/??/????","These games are modeled after the 74th Annual Hunger games, an open world survival. Survive the odds, against the Game Makers and against the other tributes. Be the last to survive and be crowned Victor! Maps are in Smooth Terrain thanks to FutureWebsiteOwner!"},
	{"ObscureEntity & ???","??/??/????","These games are modeled after the 75th Annual Hunger games, a quarter quell. These arenas contain a major twist to the games. Survive against the disasters to emerge the Victor!"},
}
local hgPos = script.Parent.ArenaType.HG.Position
local cfPos = script.Parent.ArenaType.CF.Position
local mjPos = script.Parent.ArenaType.SG.Position
local clickCheck = false
local lastClicked = nil

function addEffect(obj,effect)
	coroutine.resume(coroutine.create(function()
		local pic = script.Picture:Clone()
		local image = "rbxassetid://"..effect[1]
		local startPos = effect[2]
		local endPos = effect[3]
		local tim = effect[4]
		
		pic.Image = image
		pic.Position = startPos
		pic.Parent = obj
		pic:TweenPosition(endPos,"Out","Linear",tim)
		coroutine.resume(coroutine.create(function()
			for i = 1,30 do
				pic.ImageTransparency = pic.ImageTransparency - 0.033
				wait()
			end
			wait(tim)
			pic:Destroy()
		end))
	end))
end

function showInfo(info,obj)
	local names = info[1]
	local dat = info[2]
	local desc = info[3]
	local info = script.Parent.ArenaType.InfoPage
	info.Creator.Text = "Created by: "..names
	info.Released.Text = "Released on: "..dat
	info.Desc.Text = desc
	script.Parent.ArenaType:TweenPosition(UDim2.new(-0.6,0,0.3,0),"Out","Linear",0.5)
	obj:TweenPosition(UDim2.new(2.1,0,-0.45,0),"Out","Linear",0.5)
	for a,b in pairs(info:GetChildren()) do
		if string.sub(b.Name,1,2) == string.sub(obj.Name,1,2) then
			b.Visible = true
			break
		end
	end
end

function hideInfo(obj)
	local pos = nil
	if obj.Name == "HG" then
		pos = hgPos
	elseif obj.Name == "CF" then
		pos = cfPos
	elseif obj.Name == "SG" then
		pos = mjPos
	end
	script.Parent.ArenaType:TweenPosition(UDim2.new(0.25,0,0.3,0),"Out","Linear",0.5)
	obj:TweenPosition(pos,"Out","Linear",0.5)
end

script.Parent.ArenaType.InfoPage.Back.MouseButton1Down:connect(function()
	if clickCheck == true then
		clickCheck = false
		hideInfo(lastClicked)
	end
end)

script.Parent.ArenaType.HG.MouseButton1Down:connect(function()
	if clickCheck == false then
		script.Parent.ArenaType.InfoPage.CFPlay.Visible = false
		script.Parent.ArenaType.InfoPage.MJPlay.Visible = false
		clickCheck = true
		lastClicked = script.Parent.ArenaType.HG
		showInfo(data[1],lastClicked)
	end
end)

script.Parent.ArenaType.CF.MouseButton1Down:connect(function()
	if clickCheck == false then
		script.Parent.ArenaType.InfoPage.HGPlay.Visible = false
		script.Parent.ArenaType.InfoPage.MJPlay.Visible = false
		clickCheck = true
		lastClicked = script.Parent.ArenaType.CF
		showInfo(data[3],lastClicked)
	end
end)


script.Parent.ArenaType.SG.MouseButton1Down:connect(function()
	if clickCheck == false then
		script.Parent.ArenaType.InfoPage.HGPlay.Visible = false
		script.Parent.ArenaType.InfoPage.CFPlay.Visible = false
		clickCheck = true
		lastClicked = script.Parent.ArenaType.SG
		showInfo(data[2],lastClicked)
	end
end)

coroutine.resume(coroutine.create(function()
	while wait() do
		for i = 1,#hgData do
			local time = hgData[i][4]
			addEffect(script.Parent.ArenaType.HG.PictureHolder,hgData[i])
			wait(time-1)
		end
	end
end))

bframe.Play.MouseButton1Click:connect(function()
	script.Parent.Title:TweenPosition(UDim2.new(0.125,0,-1,0),"Out","Linear",0.25)
	script.Parent.Buttons:TweenPosition(UDim2.new(0,0,1,0),"Out","Linear",0.25)
	wait(0.2)
	script.Parent.ArenaType:TweenPosition(UDim2.new(0.25,0,0.3,0),"Out","Linear",0.25)
	wait(1)
	--[[script.Parent.ArenaType.Background.Smooth.Button.MouseButton1Down:connect(function()
		script.Parent.ArenaType.Background.TriangleInfo.Visible = false
		if script.Parent.ArenaType.Background.SmoothInfo.Visible == false then
			script.Parent.ArenaType.Background.SmoothInfo.Visible = true
		end
	end)
	--]]
	script.Parent.ArenaType.InfoPage.HGPlay.MouseButton1Down:connect(function()
		script.Parent.ArenaType.InfoPage.HGPlay.Visible = false
		script.Parent.ArenaType.InfoPage.Back.Visible = false
		Transition(true)
		wait(.2)
		TS:Teleport(294256267)
	end)
end)

local function Add_Button_Effects(button)
	button.MouseButton1Down:connect(function()
		if button.Style ~= Enum.ButtonStyle.RobloxRoundButton then
			button.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
		end
	end)
	button.MouseButton1Up:connect(function()
		if button.Style ~= Enum.ButtonStyle.RobloxRoundButton then
			button.Style = Enum.ButtonStyle.RobloxRoundDropdownButton
		end
	end)
end

coroutine.resume(coroutine.create(function()
	local char = script.Parent.Characters
	local function Check_Characters(side)
		if side:lower() == "forward" then
			for i,k in pairs (char.Selection:GetChildren()) do
				if k.Position.X.Scale >= .99 then
					return true
				end
			end
		elseif side:lower() == "back" or side:lower() == "backward" then
			for i,k in pairs (char.Selection:GetChildren()) do
				if k.Position.X.Scale < 0 then
					return true
				end
			end
		end
	end
	local forward,back = char:WaitForChild("Forward"),char:WaitForChild("Back")
	Add_Button_Effects(forward)
	Add_Button_Effects(back)
	local deb = true
	forward.MouseButton1Click:connect(function()
		if deb then
			deb = false
			if not Check_Characters("forward") then
				forward.Style = Enum.ButtonStyle.RobloxRoundButton
				deb = true
				return
			end
			for i,k in pairs (char.Selection:GetChildren()) do
				pcall(function() k:TweenPosition(k.Position - UDim2.new(1,0,0,0)) end)
			end
			wait(1)
			forward.Style = Check_Characters(forward.Name) and Enum.ButtonStyle.RobloxRoundDropdownButton or Enum.ButtonStyle.RobloxRoundButton
			back.Style = Check_Characters(back.Name) and Enum.ButtonStyle.RobloxRoundDropdownButton or Enum.ButtonStyle.RobloxRoundButton
			deb = true
		end
	end)
	back.MouseButton1Click:connect(function()
		if deb then
			deb = false
			if not Check_Characters("back") then
				back.Style = Enum.ButtonStyle.RobloxRoundButton
				deb = true
				return
			end
			for i,k in pairs (char.Selection:GetChildren()) do
				pcall(function() k:TweenPosition(k.Position + UDim2.new(1,0,0,0)) end)
			end
			wait(1)
			forward.Style = Check_Characters(forward.Name) and Enum.ButtonStyle.RobloxRoundDropdownButton or Enum.ButtonStyle.RobloxRoundButton
			back.Style = Check_Characters(back.Name) and Enum.ButtonStyle.RobloxRoundDropdownButton or Enum.ButtonStyle.RobloxRoundButton
			deb = true
		end
	end)
	--[[for i,k in pairs (Character_IDs) do
		pcall(function()
			local char = game:GetService("InsertService"):LoadAsset(k):children()[1]
			char.Name = i
			char.Parent = script.Parent.Parent.Characters
			--char.Selection
		end)
	end]]
	if not Check_Characters("forward") then
		forward.Style = Enum.ButtonStyle.RobloxRoundDropdownButton
	end
end))

script.Parent.Background.BackgroundTransparency = 0
wait(3)

coroutine.resume(coroutine.create(function()
	local data = {
		"August 18th, 2015 - Added Basic Shop UI",
		"August 21st, 2015 - Remade weapons. Remade Shop UI.",
		"November 27th, 2015 - Removed Characters, Added Character Customization",
		"November 28th, 2015 - Major Update Release (Customization, Sponsoring, Arena FF, Gameplay Fixes)"
	}
	
	local x = 0.05
	local y = 0
	local maxY = 0
	local minY = y
	local first = nil
	local last = nil
	local firstscroll = true
	
	local function reverseTab(tbl)
		local tab = {}
		for i = 1,#tbl do
			table.insert(tab,tbl[#data-(i-1)])
		end
		return tab
	end
	
	data = reverseTab(data)
	
	for i = 1,#data do
		local label = script.Update:Clone()
		label.Parent = script.Parent.UpdateLog.Background.InfoHolder
		label.Position = UDim2.new(x,0,y,0)
		label.Name = "Update"..i
		label.Text = data[i]
		if i ~= #data then
			y = y + 0.2 + 0.025
		end
		if i == 1 then
			first = label
		end
		if i == #data then
			last = label
		end
	end
end))

coroutine.resume(coroutine.create(function()
	script.Parent.Background.BackgroundTransparency = 0
	cam.CameraType = Enum.CameraType.Scriptable
	local subject = Instance.new("Part",cam)
	subject.Anchored = true
	subject.Transparency = 1
	subject.CanCollide = false
	subject.CFrame = CFrame.new(Center_of_Arena)
	cam.CameraSubject = subject
	repeat
		while On_Menu do
			local r = math.rad(math.random(1,360))
			local ray = Ray.new(Center_of_Arena+Vector3.new(math.cos(math.rad(r))*Radius_of_Bloodbath*Camera_Length,100,math.sin(math.rad(r))*Radius_of_Bloodbath*Camera_Length),Vector3.new(0,-200,0))
			local part,pos = workspace:FindPartOnRay(ray,nil,true,false)
			if part == nil then
				pos = Vector3.new(0,0,0)
			end
			cam.CoordinateFrame = CFrame.new(Center_of_Arena)*CFrame.Angles(0,r,0)*CFrame.new(0,pos.y+10,Radius_of_Bloodbath*Camera_Length)
			wait()
			cam:Interpolate(CFrame.new(Center_of_Arena)*CFrame.Angles(0,r,0)*CFrame.new(0,Height_of_View,Radius_of_Bloodbath),CFrame.new(Center_of_Arena),Time_Per_View+5)
			if On_Menu then
				for i=0,1,(1/30) do
					script.Parent.Background.BackgroundTransparency = i
					wait()
				end
				script.Parent.Background.BackgroundTransparency = 1
				for i=1,math.ceil(Time_Per_View-2) do
					if On_Menu then
						wait(1)
					end
				end
				if On_Menu then
					for i=1,0,(-1/30) do
						script.Parent.Background.BackgroundTransparency = i
						wait()
					end
					script.Parent.Background.BackgroundTransparency = 0
				else
					script.Parent.Background.BackgroundTransparency = 1
				end
			end
		end
		wait(.337)
	until nil
end))

coroutine.resume(coroutine.create(function()
	local index,img,inc = 0,script.Parent.Title,1
	repeat
		wait(5)
		repeat
			img.Image = Title_Images[index]
			index = index + inc
			if index > #Title_Images then
				index = #Title_Images
				inc = -1
			elseif index < 0 then
				index = 0
				inc = 1
			end
			wait()
		until index == 0
	until nil
end))

coroutine.resume(coroutine.create(function()
	local index = 1
	local theme = script.Parent.Theme
	repeat
		theme.SoundId = Sounds[index]
		--theme.Volume = .75
		theme.Pitch = .95
		theme:Play()
		wait(3)
		wait(theme.TimeLength)
		index = index + 1
		if index > #Sounds then index = 1 end
	until nil
end))

coroutine.resume(coroutine.create(function()
	local tbl = workspace.Remotes.CtoS.GetCharacterData:InvokeServer()
end))

local genders = {"Male","Female"}

local function Find_Frame_from_Char(char)
	local equipped = script.Parent.Characters.Equipped
	for _,gender in pairs (genders) do
		for i,k in pairs (equipped[gender]:GetChildren()) do
			if k:FindFirstChild("lblName") then
				if k.lblName.Text == char then
					return k
				end
			end
		end
	end
end

local function Is_Equipped(char)
	local e = script.Parent.Characters.Equipped
	for _,gender in pairs (genders) do
		for i,k in pairs (e[gender]:GetChildren()) do
			if k:FindFirstChild("lblName") then
				if k.lblName.Text == char then
					return true
				end
			end
		end
	end
	return false
end

local product

script.Parent.Characters.Details.Requirement.BuyNow.MouseButton1Click:connect(function()
	if product and product > 0 then
		local t = Product_Information[product]
		if t then
			local typ = t.PriceInRobux and "Robux" or "Tix"
			game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer,product,false,Enum.CurrencyType[typ])
		end
	end
end)

workspace.Remotes.StoC.UpdateChars.OnClientEvent:connect(function(id)
	if product == id then
		local det = script.Parent.Characters.Details
		det.Requirement.Visible = false
		det.cmdEquip.Visible = true
	end
end)

coroutine.resume(coroutine.create(function()
	wait(.75)
	local model = nil
	coroutine.resume(coroutine.create(function()
		local b = script.Parent.Characters:WaitForChild("Exit")
		add_Background_Effects(b)
		b.MouseButton1Click:connect(function()
			script.Parent.Characters.Visible = false
			for i=1,0,(-1/30) do
				script.Parent.Background.BackgroundTransparency = i
			end
			script.Parent.Background.BackgroundTransparency = 0
			script.Parent.Title.Visible = true
			script.Parent.Title.Backup.Visible = true
			On_Menu = true
			coroutine.resume(coroutine.create(function()
				for i=1,0,(-1/30) do
					script.Parent.CharacterTheme.Volume = .337*i
					wait()
				end
				script.Parent.CharacterTheme.Volume = 0
				for i=0,1,(1/30) do
					script.Parent.Theme.Volume = .75*i
					wait()
				end
				script.Parent.Theme.Volume = .75
			end))
			--[[for i=0,1,(1/30) do
				script.Parent.Transition.BackgroundTransparency = i
				wait()
			end]]
			script.Parent.Transition.BackgroundTransparency = 1
			script.Parent.Buttons:TweenPosition(UDim2.new(0,0,0,0))
			b.BackgroundTransparency = 1
		end)
	end))
	local det = script.Parent.Characters:WaitForChild("Details")
	det.ChildAdded:connect(function(c)
		if c.ClassName == "Folder" and c.Name == "Data" then
			pcall(function() det.OldData:Destroy() end)
			c.Name = "OldData"
			local character = c.Character.Value
			for i,k in pairs (c:GetChildren()) do
				pcall(function()
					local x = k.Value*.01
					det[k.Name].bar.Size = UDim2.new(x,0,1,0)
					if x <= .225 then
						det[k.Name].bar.Image = Bars.Blue
					elseif x <= .45 then
						det[k.Name].bar.Image = Bars.Cyan
					elseif x <= .675 then
						det[k.Name].bar.Image = Bars.Yellow
					elseif x <= .9 then
						det[k.Name].bar.Image = Bars.Orange
					else
						det[k.Name].bar.Image = Bars.Red
					end
				end)
			end
			det.lblName.Text = character
			det.lblGender.Text = "Gender: "..(c.Gender.Value == 1 and "Male" or "Female")
			if not workspace.Remotes.CtoS.EligibleCharacter:InvokeServer(character) then 
				det.cmdEquip.Visible = false
				det.Requirement.BuyNow.Visible = false
				product = nil
				pcall(function()
					local kind,value = c.CurrencyType.Value,c.CurrencyAmount.Value
					kind = kind == 3 and "Robux" or kind == 2 and "Twitter Code" or "Level"
					if kind == "Robux" then
						product = value
						local s = false
						if Product_Information[value] == nil then
							local s = pcall(function()
								Product_Information[value] = game:GetService("MarketplaceService"):GetProductInfo(value,Enum.InfoType.Product)
							end)
						end
						local pi = Product_Information[value]
						det.Requirement.TextColor3 = Color3.new(.25,1,.25)
						if s == false or (pi.PriceInRobux == nil and pi.PriceInTickets == nil) then
							det.Requirement.Text = "Unavailable"
						else
							det.Requirement.Text = tostring(pi.PriceInRobux or pi.PriceInTickets).." "..(pi.PriceInRobux and "Robux" or "Tickets")	
							det.Requirement.BuyNow.Visible = true
						end
					elseif kind == "Twitter Code" then
						det.Requirement.TextColor3 = Color3.new(.75,.75,1)
						det.Requirement.Text = "Twitter Code Required"
					elseif kind == "Level" then
						local prestige,lvl = math.floor(value/24),value - 24*math.floor(value/24)
						det.Requirement.TextColor3 = Color3.new(1,0,0)
						if prestige > 0 then
							if lvl > 0 then
								det.Requirement.Text = "Prestige "..tostring(prestige)..", Level "..tostring(lvl).." Required"
							else
								det.Requirement.Text = "Prestige "..tostring(prestige).." Required"
							end
						else
							det.Requirement.Text = "Level "..tostring(lvl).." Required"
						end
					end
				end)
			elseif Is_Equipped(character) then
				det.Requirement.TextColor3 = Color3.new(0,1,0)
				det.Requirement.Text = "Equipped"
				det.cmdEquip.Visible = false
			else
				det.Requirement.Text = ""
				det.cmdEquip.Visible = true
			end				
		end
	end)
	local sel = script.Parent.Characters:WaitForChild("Selection")
	local t = workspace.Remotes.CtoS.GetCharacterData:InvokeServer()
	local num = 0
	if t == nil then
		return
	end
	local organized_table,tblofnames,tblofvals = {},{},{}
	for i,k in pairs (t) do
		table.insert(tblofvals,k.CurrencyType <= 2 and k.CurrencyAmount or 13337)
	end
	table.sort(tblofvals)
	local num = #tblofvals
	for i,k in pairs (t) do
		local val = (k.CurrencyType <= 2 and k.CurrencyAmount or 13337)
		for e=1,num do
			local r = tblofvals[e]
			if r == val then
				tblofnames[e] = i
				tblofvals[e] = nil
				break
			end
		end
	end
	for e=1,#tblofnames do
		local i = tblofnames[e]
		local k = t[i]
		local ib,pic,n,data = Instance.new("ImageButton"),Instance.new("ImageLabel"),Instance.new("TextLabel"),Instance.new("Folder")
		pic.Parent,n.Parent,data.Parent = ib,ib,ib
		ib.ZIndex,pic.ZIndex,n.ZIndex = 5,5,5
		ib.Name = i
		ib.Size = UDim2.new(0.075,0,.9,0)
		ib.BackgroundTransparency = 1
		ib.Position = UDim2.new((e-1)*.08333,0,.05,0)
		ib.Image = "rbxassetid://190398671"
		pic.BackgroundTransparency = 1
		pic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(k.PicID)
		pic.Size = UDim2.new(.8,0,.8,0)
		pic.Position = UDim2.new(.1,0,.1,0)
		n.BackgroundTransparency = 1
		n.Size = UDim2.new(1,0,1,0)
		n.FontSize = Enum.FontSize.Size18
		n.Font = Enum.Font.SourceSansBold
		n.Text = i
		n.TextColor3 = Color3.new(1,1,1)
		n.TextStrokeTransparency = 0
		n.TextYAlignment = Enum.TextYAlignment.Bottom
		data.Name = "Data"
		for e,r in pairs (k) do
			local inst = Instance.new("IntValue",data)
			inst.Name = e
			inst.Value = r
		end
		local str = Instance.new("StringValue",data)
		str.Name = "Character"
		str.Value = i
		ib.MouseButton1Click:connect(function()
			data:Clone().Parent = det
			if workspace.Chars:FindFirstChild(i) then return end
			workspace.Remotes.CtoS.ClearChars:FireServer()
			local char = workspace.Remotes.CtoS.GetCharacter:InvokeServer(i)
			pcall(function() char:SetPrimaryPartCFrame(CFrame.new(939.289673, 1099.93188, 98.3804321, 0, 0, 1, 0, 1, 0, -1, 0, 0)) end)
			local playing = false
			coroutine.resume(coroutine.create(function()
				local hum = char:WaitForChild("Humanoid")
				coroutine.resume(coroutine.create(function()
					local idles = {char:WaitForChild("IdleAnim2")} --char:WaitForChild("IdleAnim1"),
					while wait(2) do
						if playing == false then
							hum:LoadAnimation(idles[math.random(#idles)]):Play(.1,1,1)
						end
					end
				end))
				for i=1,3 do wait(.7) end
				repeat
					pcall(function()
						local anims = char.Animations:GetChildren()
						local picked = anims[math.random(#anims)]
						local animTrack = hum:LoadAnimation(picked)
						animTrack:Play(.1,1,1)
						playing = true
					end)
					coroutine.resume(coroutine.create(function()
						for i=1,4 do
							wait(.49)
						end
						playing = false
					end))
					for i=1,math.random(14,20) do wait(.5) end
				until char == nil or char.Parent == nil
			end))
		end)
		ib.Parent = sel
		num = num + 1
	end
	--[[for i,k in pairs (sel:GetChildren()) do
		if k.ClassName == "ImageButton" then
			k.MouseButton1Click:connect(function()
				pcall(function()
					k.Data:Clone().Parent = det
				end)
			end)
		end
	end]]
end))

local Char_Picked,Equipped_Picked

local function Add_Change_Char_Effects(button,chardata)
	if not button then return end
	button.AutoButtonColor = false
	button.MouseEnter:connect(function()
		button.Parent.BackgroundTransparency = .25
	end)
	button.MouseLeave:connect(function()
		button.Parent.BackgroundTransparency = .5
	end)
	button.MouseButton1Down:connect(function()
		button.Parent.BackgroundTransparency = 0
	end)
	button.MouseButton1Up:connect(function()
		button.Parent.BackgroundTransparency = .25
	end)
	button.MouseButton1Click:connect(function()
		button.Parent.BackgroundColor3 = button.Parent.BackgroundColor3 == Color3.new(1,1,1) and Color3.new(1,1,0) or Color3.new(1,1,1)
		if button.Parent.BackgroundColor3 == Color3.new(1,1,0) then
			for i,k in pairs (button.Parent.Parent:GetChildren()) do
				if k ~= button.Parent then
					pcall(function()
						k.BackgroundColor3 = Color3.new(1,1,1)
					end)
				end
			end
			local oppo = button.Parent.Parent.Name == "Male" and button.Parent.Parent.Parent.Female or button.Parent.Parent.Parent.Male
			for i,k in pairs (oppo:GetChildren()) do
				if k ~= button.Parent then
					pcall(function()
						k.BackgroundColor3 = Color3.new(1,1,1)
					end)
				end
			end
			Equipped_Picked = button.Parent.lblName.Text
			if Char_Picked then
				button.Parent.BackgroundColor3 = Color3.new(1,1,1)
				pcall(function()
					script.Parent.Characters.Details.cmdEquip.Visible = false
					script.Parent.Characters.Details.cmdEquip.BackgroundColor3 = Color3.new(1,1,1)
					script.Parent.Characters.Details.Requirement.TextColor3 = Color3.new(0,1,0)
					script.Parent.Characters.Details.Requirement.Text = "Equipped"
				end)
				if workspace.Remotes.CtoS.UpdateCharacters:InvokeServer(Equipped_Picked,Char_Picked) then
					button.Parent.lblName.Text = Char_Picked
					button.Parent.CharPic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(chardata[Char_Picked].PicID)
				end
				Char_Picked,Equipped_Picked = nil,nil
			end
		end
	end)
end

coroutine.resume(coroutine.create(function()
	for i=1,6 do wait() end
	local chars = workspace.Remotes.CtoS.GetEquippedChars:InvokeServer()
	local chardata = workspace.Remotes.CtoS.GetCharacterData:InvokeServer()
	for _,gender in pairs (genders) do
		for i,k in pairs (script.Parent.Characters.Equipped[gender]:GetChildren()) do
			Add_Change_Char_Effects(k:FindFirstChild("Button"),chardata)
		end
	end
	local t = workspace.Remotes.CtoS.GetEquippedChars:InvokeServer()
	for gender,tbl in pairs (t or {}) do
		for i,k in pairs (tbl) do
			local frame = script.Parent.Characters.Equipped[gender]["Char"..tostring(i)]
			frame.CharPic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(chardata[k].PicID or 0)
			frame.lblName.Text = k
		end
	end
	local button = script.Parent.Characters.Details.cmdEquip
	button.MouseButton1Click:connect(function()
		button.BackgroundColor3 = button.BackgroundColor3 == Color3.new(1,1,1) and Color3.new(1,1,0) or Color3.new(1,1,1)		
		if button.BackgroundColor3 == Color3.new(1,1,0) then
			Char_Picked = script.Parent.Characters.Details.lblName.Text
			if Char_Picked and Equipped_Picked then
				local frame = Find_Frame_from_Char(Equipped_Picked)
				frame.BackgroundColor3 = Color3.new(1,1,1)
				button.BackgroundColor3 = Color3.new(1,1,1)
				button.Visible = false
				button.Parent.Requirement.TextColor3 = Color3.new(0,1,0)
				button.Parent.Requirement.Text = "Equipped"
				if workspace.Remotes.CtoS.UpdateCharacters:InvokeServer(Equipped_Picked,Char_Picked) then
					frame.lblName.Text = Char_Picked
					frame.CharPic.Image = "http://www.roblox.com/Thumbs/Asset.ashx?width=512&height=512&assetId="..tostring(chardata[Char_Picked].PicID)
				end
				Char_Picked,Equipped_Picked = nil,nil
			end
		else
			Char_Picked = nil
		end
	end)
	for i,k in pairs (button.Parent.Parent.Selection:GetChildren()) do
		if k.ClassName == "ImageButton" then
			k.MouseButton1Click:connect(function()
				button.BackgroundColor3 = Color3.new(1,1,1)
				Char_Picked = nil
			end)
		end
	end
	script.Parent.Characters.Equipped.Visible = true
end))

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

local function Show_Customization()
	
end

local ul = workspace.Remotes.StoC:WaitForChild("UpdateLeaderboard")
ul.OnClientEvent:connect(function(data)
	local d = plr
	local board = script.Parent.Leaderboard
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
				local frame = board.Players:FindFirstChild("Player"..counter)
				if frame then
					pcall(function()
						frame.Player.PlayerName.Text = game.Players:GetNameFromUserIdAsync(userid)
					end)
					pcall(function()
						frame.Exp.Kills.Text = Format_Number(b.value)
					end)
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
		end
	end)
end)

local uleader = workspace.Remotes.StoC:WaitForChild("UpdateLeader")
uleader.OnClientEvent:connect(function(plrnum,tbl,nested)
	if nested then
		for i,k in pairs (tbl) do
			pcall(function()
				local frame = script.Parent.Leaderboard.Players["Player"..tostring(i)]
				pcall(function() frame.Wins.Deaths.Text = Format_Number(k.Wins) end)
				pcall(function() frame.Kills.Ratio.Text = Format_Number(k.Kills) end)
			end)
		end
	else
		pcall(function()
			local frame = script.Parent.Leaderboard.Players["Player"..tostring(plrnum)]
			pcall(function() frame.Wins.Deaths.Text = Format_Number(tbl.Wins) end)
			pcall(function() frame.Kills.Ratio.Text = Format_Number(tbl.Kills) end)
		end)
	end
end)

coroutine.resume(coroutine.create(function()
	local weapons = {
		"Trident",
		"Mace",
		"Axe",
		"Knife",
		"Machete",
		"Sword",
		"Bow",
		"Spear",
		"Kunai"
	}
	
	local buyable = {
		{"No-Skin","Light stone grey",0},
		{"Creamsicle","Bright ornage",24},
		{"Super Hero","Really blue",50},
		{"Contrast","Lily white",50},
		{"Frost","Baby blue",74},
		{"Fabulous","Hot pink",74},
		{"Industrial","Dark stone grey",74},
		{"Emerald","Bright green",100},
		{"Sapphire","Bright blue",100},
		{"Pink Panther","Pink",100},
		{"Bloodshed","Crimson",250},
		{"Void","Really black",250},
		{"Cataclysm","Bright red",5000}
	}
	
	local neonPack = {
		{"No-Skin","Light stone grey",0},
		{"Neon Red","Really red",0},
		{"Neon Orange","Bright orange",0},
		{"Neon Yellow","New Yeller",0},
		{"Neon Green","Lime green",0},
		{"Neon Blue","Really blue",0},
		{"Neon Purple","Magenta",0},
		{"Neon Pink","Hot pink",0}
	}
	
	local surgePack = {
		{"No-Skin","Light stone grey",0},
		{"Red Surge","Really red",0},
		{"Orange Surge","Bright orange",0},
		{"Yellow Surge","New Yeller",0},
		{"Green Surge","Lime green",0},
		{"Blue Surge","Really blue",0},
		{"Purple Surge","Magenta",0},
		{"Pink Surge","Hot pink",0}
	}
	
	local earned = {
		{"No-Skin","Light stone grey",0,"None"},
		{"Gold","Gold",72,"Level"},
		{"Master","Really red",144,"Level"},
		{"Diamond","Baby blue",240,"Level"}
	}
	
	local textures = {
		{"No-Skin","None","None","None","None",0,0},
		{"Bloodshed","Crimson","Really black","Granite","Slate",0,0},
		{"Void","Really black","Really black","Neon","Neon",0,0},
		{"Contrast","Really black","Lily white","Slate","Metal",0,0},
		{"Cataclysm","Really black","Bright red","Granite","Neon",0,0},
		{"Diamond","Baby blue","Baby blue","Foil","Foil",0,0},
		{"Master","Maroon","Really red","Granite","Metal",0,0},
		{"Emerald","Earth green","Bright green","Pebble","Cobblestone",0,0},
		{"Sapphire","Navy blue","Bright blue","Pebble","Cobblestone",0,0},
		{"Pink Panther","Hot pink","Pink","Pebble","Cobblestone",0,0},
		{"Red Surge","Really black","Bright red","Pebble","Cobblestone",0,0},
		{"Orange Surge","Really black","Bright orange","Pebble","Cobblestone",0,0},
		{"Yellow Surge","Really black","Bright yellow","Pebble","Cobblestone",0,0},
		{"Green Surge","Really black","Bright green","Pebble","Cobblestone",0,0},
		{"Blue Surge","Really black","Really blue","Pebble","Cobblestone",0,0},
		{"Purple Surge","Really black","Bright violet","Pebble","Cobblestone",0,0},
		{"Pink Surge","Really black","Hot pink","Pebble","Cobblestone",0,0},
		{"Creamsicle","White","Bright orange","Metal","Cobblestone",0,0},
		{"Gold","Pine Cone","Bronze","Metal","Metal",0.5,0.5},
		{"Fabulous","Hot pink","Pink","Fabric","Grass",0,0},
		{"Neon Red","Bright red","Cocoa","Neon","Neon",0,0},
		{"Neon Orange","CGA brown","Reddish brown","Neon","Neon",0,0},
		{"Neon Yellow","Neon orange","New Yeller","Neon","Neon",0,0},	
		{"Neon Green","Parsley green","Lime green","Neon","Neon",0,0},
		{"Neon Blue","Navy blue","Really blue","Neon","Neon",0,0},
		{"Neon Purple","Mulberry","Magenta","Neon","Neon",0,0},
		{"Neon Pink","Magenta","Hot pink","Neon","Neon",0,0},
		{"Super Hero","Really blue","Really red","Slate","Metal",0,0},
		{"Industrial","Dark stone grey","Light stone grey","DiamondPlate","DiamondPlate",0,0},
		{"Frost","Institutional White","Baby blue","Plastic","Slate",0,0}
	}
	
	local Product_Table = {
		["No-Skin"] = 0,
		["Creamsicle"] = 25725819,
		["Super Hero"] = 25725823,
		["Contrast"] = 25725837,
		["Frost"] = 25725840,
		["Fabulous"] = 25725846,
		["Industrial"] = 25725851,
		["Emerald"] = 25725854,
		["Sapphire"] = 25725859,
		["Pink Panther"] = 1337,
		["Bloodshed"] = 25725869,
		["Void"] = 25725872,
		["Cataclysm"] = 25725877,
		["Pink Panther"] = 25725863,
		[" Surge"] = 288518685,
		["Neon "] = 288518399
	}
	
	function addTexture(tool,color1,color2,texture1,texture2,reflectance1,reflectance2)
		for a,b in pairs(tool:GetChildren()) do
			if b:IsA("BasePart") then
				if color1 ~= "None" and color2 ~= "None" and texture1 ~= "None" and texture2 ~= "None" then
					pcall(function()
						b.UsePartColor = true
					end)
					b.Anchored = true
					if b:FindFirstChild("Primary") then
						b.BrickColor = color1
						b.Material = texture1
						b.Reflectance = reflectance1
					end
					if b:FindFirstChild("Secondary") then
						b.BrickColor = color2
						b.Material = texture2
						b.Reflectance = reflectance2
					end
				else
					pcall(function()
						b.UsePartColor = false
						b.Material = "Plastic"
						b.Reflectance = 0
					end)
				end
			end
		end
	end
	
	local current = 1
	local model,tex = nil,"No-Skin"
	script.Parent.Skins.Weapon.Weapon.Text = weapons[current]
	local item = game.Lighting.TextureWeap:FindFirstChild(weapons[current]):Clone()
	item.Parent = game.Workspace.TextureModel
	model = item
	model:SetPrimaryPartCFrame(game.Workspace.TextureModel.ItemPos.CFrame)
	coroutine.resume(coroutine.create(function()
		while wait() do
			pcall(function()
				model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame * CFrame.Angles(math.rad(0.05), math.rad(1), math.rad(0.1)))
			end)
		end
	end))
	
	local function addNeon()
		local y = 0
		local x = 0.1
		for i = 1,#neonPack do
			local owned = false
			local item = script.Item:Clone()
			item.Parent = script.Parent.Skins.Textures.Pack2
			item.Position = UDim2.new(.1*((i-1)%10),0,.2*math.floor((i-1)*.1),0)
			item.BackgroundColor3 = BrickColor.new(neonPack[i][2]).Color
			item.ItemName.Text = neonPack[i][1]
			item.MouseButton1Down:connect(function()
				tex = item.ItemName.Text
				if Product_Table["Neon "] == 0 or workspace.Remotes.CtoS.EligibleProductID:InvokeServer(Product_Table["Neon "]) then
					owned = true
				end
				if model ~= nil then
					for i = 1,#textures do
						if textures[i][1] == item.ItemName.Text then
							addTexture(model,BrickColor.new(textures[i][2]),BrickColor.new(textures[i][3]),textures[i][4],textures[i][5],textures[i][6])
						end
					end
				end
				if owned == false then
					script.Parent.Skins.Buy.Visible = true
					script.Parent.Skins.Equip.Visible = false
					script.Parent.Skins.Buy.Text = "Buy Neon Pack for 500 R$"
				else
					script.Parent.Skins.Equip.Visible = true
					script.Parent.Skins.Equip.Text = "Equip "..item.ItemName.Text.." for "..model.Name 
					script.Parent.Skins.Buy.Visible = false
				end
			end)
			if owned == false then
				item.Cost.Text = "Neon Pack"
			else
				item.Cost.Text = "Owned"
			end
		end
	end
	
	local function addSurge()
		local y = 0
		local x = 0.1
		for i = 1,#neonPack do
			local owned = false
			local item = script.Item:Clone()
			item.Parent = script.Parent.Skins.Textures.Pack1
			item.Position = UDim2.new(.1*((i-1)%10),0,.2*math.floor((i-1)*.1),0)
			item.BackgroundColor3 = BrickColor.new(surgePack[i][2]).Color
			item.ItemName.Text = surgePack[i][1]
			item.MouseButton1Down:connect(function()
				tex = item.ItemName.Text
				if Product_Table[" Surge"] == 0 or workspace.Remotes.CtoS.EligibleProductID:InvokeServer(Product_Table[" Surge"]) then
					owned = true
				end
				if model ~= nil then
					for i = 1,#textures do
						if textures[i][1] == item.ItemName.Text then
							addTexture(model,BrickColor.new(textures[i][2]),BrickColor.new(textures[i][3]),textures[i][4],textures[i][5],textures[i][6])
						end
					end
				end
				if owned == false then
					script.Parent.Skins.Buy.Visible = true
					script.Parent.Skins.Equip.Visible = false
					script.Parent.Skins.Buy.Text = "Buy Surge Pack for 350 R$"
				else
					script.Parent.Skins.Equip.Visible = true
					script.Parent.Skins.Equip.Text = "Equip "..item.ItemName.Text.." for "..model.Name 
					script.Parent.Skins.Buy.Visible = false
				end
			end)
			if owned == false then
				item.Cost.Text = "Surge Pack"
			else
				item.Cost.Text = "Owned"
			end
		end
	end
	
	local function addBuyables()
		local y = 0
		local x = 0.1
		for i = 1,#buyable do
			local owned = false
			local item = script.Item:Clone()
			item.Parent = script.Parent.Skins.Textures.Buyable
			item.Position = UDim2.new(.1*((i-1)%10),0,.2*math.floor((i-1)*.1),0)
			item.BackgroundColor3 = BrickColor.new(buyable[i][2]).Color
			item.ItemName.Text = buyable[i][1]
			item.MouseButton1Down:connect(function()
				tex = item.ItemName.Text
				if Product_Table[buyable[i][1]] == 0 or workspace.Remotes.CtoS.EligibleProductID:InvokeServer(Product_Table[buyable[i][1]]) then
					owned = true
				end
				if model ~= nil then
					for i = 1,#textures do
						if textures[i][1] == item.ItemName.Text then
							addTexture(model,BrickColor.new(textures[i][2]),BrickColor.new(textures[i][3]),textures[i][4],textures[i][5],textures[i][6])
						end
					end
				end
				if owned == false then
					script.Parent.Skins.Buy.Visible = true
					script.Parent.Skins.Equip.Visible = false
					script.Parent.Skins.Buy.Text = "Buy for "..buyable[i][3].." R$"
				else
					script.Parent.Skins.Equip.Visible = true
					script.Parent.Skins.Equip.Text = "Equip "..item.ItemName.Text.." for "..model.Name 
					script.Parent.Skins.Buy.Visible = false
				end
			end)
			if owned == false then
				item.Cost.Text = buyable[i][3].." R$"
			else
				item.Cost.Text = "Owned"
			end
		end
	end
	
	local function addEarned()
		local y = 0
		for i = 1,#earned do
			local owned = false
			local item = script.Item:Clone()
			item.Parent = script.Parent.Skins.Textures.Earned
			item.Position = UDim2.new(.1*((i-1)%10),0,.2*math.floor((i-1)*.1),0)
			item.BackgroundColor3 = BrickColor.new(earned[i][2]).Color
			item.ItemName.Text = earned[i][1]
			local prestige,lvl = math.floor(earned[i][3]/24),earned[i][3]%24
			item.MouseButton1Down:connect(function()
				tex = item.ItemName.Text
				if earned[i][4] == "None" or workspace.Remotes.CtoS.EligibleLevel:InvokeServer(earned[i][3]) then
					owned = true
				end
				if model ~= nil then
					for i = 1,#textures do
						if textures[i][1] == item.ItemName.Text then
							addTexture(model,BrickColor.new(textures[i][2]),BrickColor.new(textures[i][3]),textures[i][4],textures[i][5],textures[i][6])
						end
					end
				end
				if owned == false then
					script.Parent.Skins.Buy.Visible = true
					script.Parent.Skins.Equip.Visible = false
					script.Parent.Skins.Buy.Text = "Unlock with "..(prestige > 0 and "Prestige "..prestige or "")..((lvl > 0 and prestige > 0) and ", " or "")..(lvl > 0 and "Level "..lvl or "")
				else
					script.Parent.Skins.Equip.Visible = true
					script.Parent.Skins.Equip.Text = "Equip "..item.ItemName.Text.." for "..model.Name 
					script.Parent.Skins.Buy.Visible = false
				end
			end)
			if owned == false then
				item.Cost.Text = (prestige > 0 and "Prestige "..prestige or "")..((lvl > 0 and prestige > 0) and ", " or "")..(lvl > 0 and "Level "..lvl or "")
			else
				item.Cost.Text = "Unlocked"
			end
		end
	end
	
	addSurge()
	
	addEarned()
	
	addBuyables()
	
	addNeon()
	
	local active_id,active_item
	
	local function Buy_Texture(texture)
		if texture == nil then return end
		local t
		for i,k in pairs (Product_Table) do
			if i == texture then
				t = k
			end
		end
		if t == nil or t == 0 then return end
		if texture:sub(1,1) == " " or texture:sub(string.len(texture)) == " " then
			active_item = texture
			active_id = t
			game:GetService("MarketplaceService"):PromptPurchase(game.Players.LocalPlayer,t)
		else
			active_item = texture
			active_id = t
			game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer,t,false,Enum.CurrencyType.Robux)
		end
	end
	
	workspace.Remotes.StoC.UpdateShop.OnClientEvent:connect(function(id)
		if active_id == id then
			local skins = script.Parent.Skins
			skins.Buy.Visible = false
			skins.Equip.Text = "Equip "..(active_item or "").." for "..(model and model.Name or "")
			skins.Equip.Visible = true
		end
	end)
	
	script.Parent.Skins.Buy.MouseButton1Click:connect(function()
		Buy_Texture(tex)
	end)
	
	script.Parent.Skins.Equip.MouseButton1Click:connect(function()
		workspace.Remotes.CtoS.UpdateData:FireServer(model.Name,tex)
		script.Parent.Skins.Equip.Text = "Equipped"
	end)
	
	local function Find_Tbl(n) --silly isaac, making me do extra -- oopsies :3
		for i=1,#textures do
			if textures[i][1] == n then
				return textures[i]
			end
		end
	end
	
	script.Parent.Skins.Weapon.Right.MouseButton1Down:connect(function()
		current = current + 1
		if current > #weapons then
			current = 1
		end
		model:Destroy()
		local item = game.Lighting.TextureWeap:FindFirstChild(weapons[current]):Clone()
		item.Parent = game.Workspace.TextureModel
		model = item			
		script.Parent.Skins.Weapon.Weapon.Text = weapons[current]
		script.Parent.Skins.Equip.Text = "Equip "..(tex or "").." for "..(model and model.Name or "")
		local tb = Find_Tbl(tex)
		addTexture(model,BrickColor.new(tb[2]),BrickColor.new(tb[3]),tb[4],tb[5],tb[6])
		model:SetPrimaryPartCFrame(game.Workspace.TextureModel.ItemPos.CFrame)
	end)
	
	script.Parent.Skins.Weapon.Left.MouseButton1Down:connect(function()
		current = current - 1
		if current == 0 then
			current = #weapons
		end
		model:Destroy()
		script.Parent.Skins.Equip.Text = "Equip "..(tex or "").." for "..(model and model.Name or "")
		local item = game.Lighting.TextureWeap:FindFirstChild(weapons[current]):Clone()
		item.Parent = game.Workspace.TextureModel
		model = item
		local tb = Find_Tbl(tex)
		script.Parent.Skins.Weapon.Weapon.Text = weapons[current]
		addTexture(model,BrickColor.new(tb[2]),BrickColor.new(tb[3]),tb[4],tb[5],tb[6])
		model:SetPrimaryPartCFrame(game.Workspace.TextureModel.ItemPos.CFrame)
	end)
	
	for a,b in pairs(script.Parent.Skins.Textures.Sections:GetChildren()) do
		b.MouseButton1Down:connect(function()
			local frame = script.Parent.Skins.Textures:FindFirstChild(b.Name)
			if frame then
				if frame.Visible == false then
					for c,d in pairs(script.Parent.Skins.Textures:GetChildren()) do
						if d.Name ~= "Sections" then
							d.Visible = false
						end
					end
					frame.Visible = true
					for c,d in pairs(script.Parent.Skins.Textures.Sections:GetChildren()) do
						d.TextColor3 = Color3.new(1,1,1)
					end
					b.TextColor3 = Color3.new(1,0.5,0)
				end
			end
		end)
	end
	local b = script.Parent.Skins:WaitForChild("Exit")
	add_Background_Effects(b)
	b.MouseButton1Click:connect(function()
		script.Parent.Skins.Visible = false
		for i=1,0,(-1/30) do
			script.Parent.Background.BackgroundTransparency = i
		end
		script.Parent.Background.BackgroundTransparency = 0
		script.Parent.Background.Visible = true
		script.Parent.Title.Visible = true
		script.Parent.Title.Backup.Visible = true
		On_Menu = true
		coroutine.resume(coroutine.create(function()
			for i=1,0,(-1/30) do
				script.Parent.ShopTheme.Volume = .6*i
				wait()
			end
			script.Parent.ShopTheme.Volume = 0
			for i=0,1,(1/30) do
				script.Parent.Theme.Volume = .75*i
				wait()
			end
			script.Parent.Theme.Volume = .75
		end))
		script.Parent.Transition.BackgroundTransparency = 1
		script.Parent.Buttons:TweenPosition(UDim2.new(0,0,0,0))
		b.BackgroundTransparency = 1
	end)
end))

--[[
coroutine.resume(coroutine.create(function()
	if Allow_Testing == true then
		script.Parent.ArenaType.Testing.Visible = true
		script.Parent.ArenaType.Testing.MouseButton1Click:connect(function()
			game:GetService("TeleportService"):Teleport(324031166,game.Players.LocalPlayer)
		end)
	end
end))
--]]

local testers = {"FutureWebsiteOwner","Terratronic","ObscureEntity"}

local function a_tester(n)
	for i,k in pairs (testers) do
		if k == n then
			return true
		end
	end
end

coroutine.resume(coroutine.create(function() --testing place
	if a_tester(game.Players.LocalPlayer.Name) then
		local mouse = game.Players.LocalPlayer:GetMouse()
		mouse.KeyDown:connect(function(k)
			if k == "t" then
				game:GetService("TeleportService"):Teleport(324031166,game.Players.LocalPlayer)
			end
		end)
	end
end))

coroutine.resume(coroutine.create(function()
	local function set_data_to_ui(tbl)
		for i,k in pairs (tbl) do
			pcall(function()
				local lbl = script.Parent.ArenaType.Background[k[1]].PlayerCount
				lbl.Text = "Player Count: "..tostring(k[2])
			end)
		end
	end
	local us = workspace.Remotes.StoC:WaitForChild("UpdateServers")
	us.OnClientEvent:connect(function(tbl)
		set_data_to_ui(tbl)
	end)
	set_data_to_ui(workspace.Remotes.CtoS:WaitForChild("GetServerData"):InvokeServer())
end))

local m = game.Players.LocalPlayer:GetMouse()

m.KeyDown:connect(function(key)
	local newKey = key
	if key == "[" then newKey = "{" end
	if newKey == "{" then
		script.Parent.CodeFrame.Visible = true
	end
end)

m.KeyUp:connect(function(key)
	local newKey = key
	if key == "[" then newKey = "{" end
	if newKey == "{" then
		script.Parent.CodeFrame.Visible = false
	end
end)

local code = "123"

script.Parent.CodeFrame.Enter.MouseButton1Down:connect(function()
	if script.Parent.CodeFrame.TextBox.Text == code then
		script.Parent.CodeFrame.TextBox.Text = "Correct! Please wait while we teleport you."
		game:GetService("TeleportService"):Teleport(339107183,game.Players.LocalPlayer)
	else
		script.Parent.CodeFrame.TextBox.Text = "Not the valid code"
	end
end)
