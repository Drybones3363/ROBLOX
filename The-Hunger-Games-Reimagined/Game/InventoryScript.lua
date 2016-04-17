-- Coded by ObscureEntity, edited and fit into game by me

------------------------------------------------------------------------------------------
-- Variables and SetUp
------------------------------------------------------------------------------------------
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local toolbar = {}
local inventory = {}
local selected = nil
local input = game:GetService("UserInputService")
local backpack = false

function setUpBaseOfInventory()
	for i = 1,5 do
		table.insert(toolbar,{"",0})
		table.insert(inventory,{"",0})
	end
end

setUpBaseOfInventory()

script.Parent.Inventory.Background.InventoryLabel.Text = player.Name.."'s Inventory"
game:GetService("StarterGui"):SetCoreGuiEnabled("Backpack",false)

repeat wait() until player.Character
------------------------------------------------------------------------------------------
-- Update inventory
------------------------------------------------------------------------------------------

function updateInventory()
	if script.Parent == nil then return end
	local frame = script.Parent.Inventory.Background
	
	-- setting new data
	for a,b in pairs(frame:GetChildren()) do
		if string.sub(b.Name,1,7) == "Toolbar" and b:IsA("ImageButton") then
			local num = tonumber(string.sub(b.Name,8))
			toolbar[num][1] = b.ItemType.Value
			toolbar[num][2] = tonumber(string.sub(b.Item.Image,14))
		end
	end
	
	for a,b in pairs(frame:GetChildren()) do
		if string.sub(b.Name,1,4) == "Slot" and b:IsA("ImageButton") then
			local num = tonumber(string.sub(b.Name,5))
			inventory[num][1] = b.ItemType.Value
			inventory[num][2] = tonumber(string.sub(b.Item.Image,14))
		end
	end
	-- clearing old stuff
	for a,b in pairs(frame:GetChildren()) do
		if string.sub(b.Name,1,4) == "Slot" and b:IsA("ImageButton") then
			local num = tonumber(string.sub(b.Name,5))
			b.ItemType.Value = ""
			b.Item.Image = ""
		end
	end
	
	for a,b in pairs(frame:GetChildren()) do
		if string.sub(b.Name,1,7) == "Toolbar" and b:IsA("ImageButton") then
			local num = tonumber(string.sub(b.Name,5))
			b.ItemType.Value = ""
			b.Item.Image = ""
		end
	end
	
	for a,b in pairs(script.Parent.Toolbar:GetChildren()) do
		if string.sub(b.Name,1,4) == "Slot" then
			local num = tonumber(string.sub(b.Name,5))
			b.ItemType.Value = ""
			b.Item.Image = ""
		end
	end
	-- implementing new stuff
	for i = 1,#inventory do
		if inventory[i][1] ~= "" then
			local slot = frame:FindFirstChild("Slot"..i)
			slot.ItemType.Value = inventory[i][1]
			slot.Item.Image = "rbxassetid://"..inventory[i][2]
		end
	end
	
	for i = 1,#toolbar do
		if toolbar[i][1] ~= "" then
			local slot = frame:FindFirstChild("Toolbar"..i)
			slot.ItemType.Value = toolbar[i][1]
			slot.Item.Image = "rbxassetid://"..toolbar[i][2]
			local slot1 = script.Parent.Toolbar:FindFirstChild("Slot"..i)
			slot1.ItemType.Value = toolbar[i][1]
			slot1.Item.Image = "rbxassetid://"..toolbar[i][2]
		end
	end
	
	game.Workspace.InventoryEvent:FireServer("ClearTools")
	game.Workspace.InventoryEvent:FireServer("EquipItem",selected.ItemType.Value)
end

function addItem(item,id)
	local toolbarOpen = false
	local inventoryOpen = false
	
	for i = 1,#toolbar do
		if toolbar[i][1] == "" then
			toolbarOpen = true
			local slot = script.Parent.Inventory.Background:FindFirstChild("Toolbar"..i)
			slot.ItemType.Value = item
			slot.Item.Image = "rbxassetid://"..id
			break
		end
	end
	
	if toolbarOpen == false then
		for i = 1,#inventory do
			if inventory[i][1] == "" then
				local slot = script.Parent.Inventory.Background:FindFirstChild("Slot"..i)
				if slot.Visible == true then
					inventoryOpen = true
					slot.ItemType.Value = item
					slot.Item.Image = "rbxassetid://"..id
					break
				end
			end
		end
	end
	
	if inventoryOpen == false and toolbarOpen == false then
		return false
	end
	
	updateInventory()
end

function removeItem(item)
	for a,b in pairs(script.Parent.Inventory.Background:GetChildren()) do
		if b.ItemValue == item then
			b.Item.Image = ""
			b.ItemType.Value = ""
			break
		end
	end
end
------------------------------------------------------------------------------------------
-- Other Functions
------------------------------------------------------------------------------------------
function wordToNum(word)
	if word == "One" then return 1 end
	if word == "Two" then return 2 end
	if word == "Three" then return 3 end
	if word == "Four" then return 4 end
	if word == "Five" then return 5 end
end

function announce(msg,color)
	coroutine.resume(coroutine.create(function()
		local ann = script.Announcement:Clone()
		ann.Parent = script.Parent
		ann.Text = msg
		ann.TextColor3 = color
		ann.TextStrokeColor3 = Color3.new(((color.r*255)-155)/255,((color.g*255)-155)/255,((color.b*255)-155)/255)
		ann:TweenPosition(UDim2.new(0,0,0.2,0),"Out","Quart",0.4,true)
		wait(1.5)
		ann:TweenPosition(UDim2.new(1,0,0.2,0),"Out","Quart",0.4,true)
		wait(string.len(msg)/18)
		ann:Destroy()
	end))
end
------------------------------------------------------------------------------------------
-- Inventory Moving System
------------------------------------------------------------------------------------------
coroutine.resume(coroutine.create(function()
	local frame = script.Parent.Inventory.Background
	local slotPositions = {}
	
	local function setUpPositions()
		for a,b in pairs(frame:GetChildren()) do
			table.insert(slotPositions,{b.Name,b.Position,b.Size})
		end
	end
	
	local function swap(b,d)
		for i = 1,#slotPositions do
			if slotPositions[i][1] == b.Name then
				d.Position = slotPositions[i][2]
				d.Size = slotPositions[i][3]
				break
			end
		end
		for i = 1,#slotPositions do
			if slotPositions[i][1] == d.Name then
				b.Position = slotPositions[i][2]
				b.Size = slotPositions[i][3]
				break
			end
		end
	end
	
	local function findClosestSlot(selected)
		local smallest = math.huge
		local current = nil
		local name = selected.Name
		local originalPos = selected.Position
		
		for a,b in pairs(script.Parent.Inventory.Background:GetChildren()) do
			if b:IsA("ImageButton") and b ~= selected and b.Visible == true then
				local dis = (Vector2.new(b.Position.X.Offset,b.Position.Y.Offset) - Vector2.new(selected.Position.X.Offset,selected.Position.Y.Offset)).magnitude
				if dis <= smallest then
					smallest = dis
					current = b
				end
			end
		end
		
		swap(selected,current)
		swap(current,selected)
		selected.Name = current.Name
		current.Name = name
		updateInventory()
	end
	
	for a,b in pairs(script.Parent.Inventory.Background:GetChildren()) do
		if b:IsA("ImageButton") then
			local position = b.Position
			
			b.MouseButton1Up:connect(function()
				b.ZIndex = 3
				b.Item.ZIndex = 4
				findClosestSlot(b)
			end)
			
			b.MouseButton1Down:connect(function()
				b.ZIndex = 4
				b.Item.ZIndex = 5
			end)
		end
	end
	
	setUpPositions()
end))

------------------------------------------------------------------------------------------
-- Toggle Inventory
------------------------------------------------------------------------------------------
local changed = false
local open = false

function lerpTransparency(current,new,speed)
	coroutine.resume(coroutine.create(function()
		changed = true
		wait()
		changed = false
		for i = 0, 1, speed do
			wait()
			if changed == true then break end
			if changed == false then
				local newNum = (current - ((current - new) * i))
				script.Parent.InventoryOverlay.BackgroundTransparency = newNum
			end
		end
	end))
end

function toggleInventory()
	open = not open
	if open == true then
		lerpTransparency(script.Parent.InventoryOverlay.BackgroundTransparency,0.5,0.25)
		script.Parent.Inventory:TweenPosition(UDim2.new(0,0,0,0),"Out","Quart",0.4,true)
		script.Parent.Toolbar:TweenPosition(UDim2.new(0,0,0.15,0),"Out","Quart",0.4,true)
		script.Parent.Toolbar.Open.TextLabel.Text = "Close Inventory [G]"
	else
		lerpTransparency(script.Parent.InventoryOverlay.BackgroundTransparency,1,0.25)
		script.Parent.Inventory:TweenPosition(UDim2.new(0,0,-1,0),"Out","Quart",0.4,true)
		script.Parent.Toolbar:TweenPosition(UDim2.new(0,0,0,0),"Out","Quart",0.4,true)
		script.Parent.Toolbar.Open.TextLabel.Text = "Open Inventory [G]"
	end
end

mouse.KeyDown:connect(function(key)
	if key == "g" then
		toggleInventory()
	end
end)

script.Parent.Toolbar.Open.MouseButton1Down:connect(function()
	toggleInventory()
end)

------------------------------------------------------------------------------------------
-- Toolbar keys
------------------------------------------------------------------------------------------

local selected_num

function toggleBar(num)
	for a,b in pairs(script.Parent.Toolbar:GetChildren()) do 
		if string.sub(b.Name,1,4) == "Slot" then
			b.Equiped.ImageTransparency = 1
			b.ImageTransparency = 0
			b.Item.ZIndex = 2
			b.KeyNumber.ZIndex = 2
			b.KeyNumber.TextColor3 = Color3.new(1,1,1)
			b.KeyNumber.TextStrokeColor3 = Color3.new(100/255,100/255,100/255)
			b.Item.ImageColor3 = Color3.new(1,1,1)
		end
	end
	if selected_num ~= num then
		selected_num = num
		local slot = script.Parent.Toolbar:FindFirstChild("Slot"..num)
		slot.Equiped.ImageTransparency = 0
		slot.ImageTransparency = 1
		slot.Item.ZIndex = 3
		slot.Equiped.ZIndex = 2
		slot.KeyNumber.ZIndex = 3
		slot.KeyNumber.TextColor3 = Color3.new(0,1,0)
		slot.KeyNumber.TextStrokeColor3 = Color3.new(0,100/255,0)
		slot.Item.ImageColor3 = Color3.new(0,1,0)
		selected = slot
		game.Workspace.InventoryEvent:FireServer("ClearTools")
		game.Workspace.InventoryEvent:FireServer("EquipItem",selected.ItemType.Value)
	else		
		game.Workspace.InventoryEvent:FireServer("ClearTools")
		selected_num = nil
	end
end

input.InputBegan:connect(function(input)
	local key = input.KeyCode
	local sub = wordToNum(string.sub(tostring(key),14))
	if sub ~= nil then
		if script.Parent.Toolbar:FindFirstChild("Slot"..sub) then
			toggleBar(sub)
		end
	end
end)

for a,b in pairs(script.Parent.Toolbar:GetChildren()) do
	b.MouseButton1Down:connect(function()
		toggleBar(tonumber(string.sub(b.Name,5)))
	end)
end

toggleBar(1)
------------------------------------------------------------------------------------------
-- Add a new item / removing items
------------------------------------------------------------------------------------------
game.Workspace.InventoryEvent.OnClientEvent:connect(function(typ,itemName,itemId)
	if typ == "AddItem" then
		if itemName == "Backpack" then
			if player.Character:FindFirstChild("Backpack") == nil then
				game.Workspace.InventoryEvent:FireServer("AddBackpack")
				backpack = true
				announce("You have picked up a "..itemName,Color3.new(0,1,0))
			else
				announce("You already have a backpack!",Color3.new(1,0,0))
				game.Workspace.InventoryEvent:FireServer("DropItem","Backpack")
			end
		else
			local added = addItem(itemName,itemId)
			if added == false then
				game.Workspace.InventoryEvent:FireServer("DropItem",itemName)
				announce("Your inventory is full. Right click on items in your inventory to drop them, or press backspace on your selected item.",Color3.new(1,0,0))
			else
				announce("You have picked up a "..itemName,Color3.new(0,1,0))
			end
		end
	elseif typ == "RemoveItem" then
		removeItem(itemName)
	end
end)

for a,b in pairs(script.Parent.Inventory.Background:GetChildren()) do
	if b:IsA("ImageButton") then
		b.MouseButton2Down:connect(function()
			if b.ItemType.Value ~= "" then
				announce("You have dropped your "..b.ItemType.Value..".",Color3.new(0.15,0.15,1))
				game.Workspace.InventoryEvent:FireServer("DropItem",b.ItemType.Value)
				b.ItemType.Value = ""
				b.Item.Image = ""
				updateInventory()
			end
		end)
	end
end

for a,b in pairs(script.Parent.Toolbar:GetChildren()) do
	if b:IsA("ImageButton") then
		b.MouseButton2Down:connect(function()
			if b.ItemType.Value ~= "" then
				local num = tonumber(string.sub(b.Name,5))
				local slot = script.Parent.Inventory.Background:FindFirstChild("Toolbar"..num)
				announce("You have dropped your "..slot.ItemType.Value..".",Color3.new(0.15,0.15,1))
				game.Workspace.InventoryEvent:FireServer("DropItem",b.ItemType.Value)
				slot.ItemType.Value = ""
				slot.Item.Image = ""
				updateInventory()
			end
		end)
	end
end

mouse.KeyDown:connect(function(key)
	if string.byte(key) == 8 then
		if selected.ItemType.Value ~= "" then
			local num = tonumber(string.sub(selected.Name,5))
			local slot = script.Parent.Inventory.Background:FindFirstChild("Toolbar"..num)
			announce("You have dropped your "..selected.ItemType.Value..".",Color3.new(0.15,0.15,1))
			game.Workspace.InventoryEvent:FireServer("DropItem",selected.ItemType.Value)
			slot.ItemType.Value = ""
			slot.Item.Image = ""
			updateInventory()
		end
	end
end)
------------------------------------------------------------------------------------------
-- Update Inventory's Space
------------------------------------------------------------------------------------------
coroutine.resume(coroutine.create(function()
	local updated = false
	while wait(0.5) do
		if backpack == true and updated == false then
			updated = true
			for a,b in pairs(script.Parent.Inventory.Background:GetChildren()) do
				if string.sub(b.Name,1,4) == "Slot" and b.Name ~= "SlotBackground" then
					b.Visible = true
				elseif b.Name == "Background" then
					if b:FindFirstChild("Note") then
						b.Note:Destroy()
					end
				end
			end
		end
	end
end))
