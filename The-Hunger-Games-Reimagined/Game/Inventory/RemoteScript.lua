function equipItem(plr,tool)
	local parent = nil
	plr.Backpack:ClearAllChildren()
	if game.ServerStorage.Supplies.Food:FindFirstChild(tool) then
		parent = game.ServerStorage.Supplies.Food
	end
	if game.ServerStorage.Supplies.Fruit:FindFirstChild(tool) then
		parent = game.ServerStorage.Supplies.Fruit
	end
	if game.ServerStorage.Supplies.Weapons:FindFirstChild(tool) then
		parent = game.ServerStorage.Supplies.Weapons
	end
	if parent ~= nil then
		local item = parent:FindFirstChild(tool):Clone()
		item.Parent = plr.Backpack
		plr.Character.Humanoid:EquipTool(item)
	end
end

function clearTools(plr)
	plr.Backpack:ClearAllChildren()
	for a,b in pairs(plr.Character:GetChildren()) do
		if b:IsA("Tool") then
			b:Destroy()
		end
	end
end

function dropItem(plr,itemType)
	local item = game.ServerStorage.ItemModels:FindFirstChild(itemType):Clone()
	item.Parent = game.Workspace.Weapons
	item:SetPrimaryPartCFrame(plr.Character.Torso.CFrame-Vector3.new(math.random(-8,8),2.5,math.random(-8,8)))
	for i,k in pairs (item:GetChildren()) do
		pcall(function()
			k.Anchored = false
		end)
	end
end

function addBackpack(plr)
	local pack = game.ServerStorage.Supplies.Backpack:Clone()
	pack.Parent = plr.Character
	local weld = Instance.new("Weld",pack.Root)
	weld.Part0 = pack.Root
	weld.Part1 = plr.Character.Torso
	weld.C0 = CFrame.new(-0.75,0,0)*CFrame.Angles(math.rad(180),math.rad(90),math.rad(90))
end

function changeItem(plr,item,newItem,id)
	script.Parent:FireClient(plr,"RemoveItem",item)
	script.Parent:FireClient(plr,"AddItem",newItem,id)
end

script.Parent.OnServerEvent:connect(function(plr,typ,...)
	if typ == "EquipItem" then
		equipItem(plr,...)
	elseif typ == "ClearTools" then
		clearTools(plr)
	elseif typ == "DropItem" then
		dropItem(plr,...)
	elseif typ == "AddBackpack" then
		addBackpack(plr)
	elseif typ == "ChangeItem" then
		changeItem(plr,...)
	end
end)
