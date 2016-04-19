_G.GamesOn = false

_G["FactorToRadar"] = function(v)
	v = v + 150
	v = v/461.5
	return v
end

_G["XFactorToRadar"] = function(v)
	v = v + 175
	v = v/353.53
	return v
end

_G["ZFactorToRadar"] = function(v)
	--v = -v
	v = v + 46
	v = v/102.22 --(333+(1/3))
	return v
end

local names = {"Knight","Archer","Miner","Allan"}
local ids = {220345628,220346274,220348070,222021730}
local modelids = {218208504,219501658,220182296,222021584}

_G["GetNames"] = function()
	return names
end

_G["GetIDs"] = function()
	return ids
end

_G["GetModelIDs"] = function()
	return modelids
end

_G["Hire"] = function(plr,type)
	local function getsol(model,type)
		for i,k in pairs (model) do
			if k:findFirstChild("Data") then
				if k.Data.Type.Value == type then
					return k
				end
			end
		end
		return nil
	end
	local function givedata(sol)
		local tbl = {{["type"]="IntValue",["name"]="Damage",["value"]=0}}
		if type == "Miner" then
			for i,k in pairs (tbl) do
				if k["name"] == "Damage" then
					k["name"] = "Gold"
				end
			end
		end
		local f = Instance.new("Folder",sol)
		f.Name = "Stats"
		for i,k in pairs (tbl) do
			local val = Instance.new(k["type"],f)
			val.Name = k["name"]
			val.Value = k["value"]
		end
	end
	local m = require(game.ServerScriptService.GameFunctions)
	local n = 1
	if m.GetSideFromPlr(plr) == "Left" then
		n = -1
	end
	local model = game.ServerStorage:FindFirstChild(plr.Name.."Soldiers")
	if model then
		local fighter = getsol(model:children(),type)
		if fighter then
			local c = fighter:clone()
			c:SetPrimaryPartCFrame(CFrame.new(Vector3.new(n*220,25,math.random(-30,30))))
			givedata(c)
			c.Parent = workspace
		end
	end
end

_G["GetName"] = function(id)
	if game.ServerStorage:FindFirstChild("Hats") then
		if game.ServerStorage.Hats:findFirstChild("Table") then
			for i,k in pairs (game.ServerStorage.Hats.Table:children()) do
				if tonumber(k.Name) == id then
					return k.Value
				end
			end
		end
	end
	return nil
end

_G["MakeMine"] = function(pos,top,left)
	local colors = {"Really black","New Yeller"}
	local num = {8,2}
	local hazmain = false
	local model = Instance.new("Model",workspace)
	model.Name = "GoldMine"
	for i=1,#colors do
		for e=1,num[i] do
			local p = Instance.new("Part",model)
			p.Size = Vector3.new(4,3,3)
			p.BackSurface = "Smooth"
			p.BottomSurface = "Smooth"
			p.FrontSurface = "Smooth"
			p.LeftSurface = "Smooth"
			p.RightSurface = "Smooth"
			p.TopSurface = "Smooth"
			p.Anchored = true
			p.CanCollide = false
			p.Locked = true
			p.Material = "Slate"
			p.BrickColor = BrickColor.new(colors[i])
			if p.BrickColor == BrickColor.new("New Yeller") then
				p.Name = "Gold"
			end
			if not hazmain and p.BrickColor ~= BrickColor.new("NewYeller") then
				hazmain = true
				p.Name = "Main"
				model.PrimaryPart = p
			end
			p.CFrame = CFrame.Angles(math.rad(math.random(1,180)),math.rad(math.random(1,180)),math.rad(math.random(1,180)))
		end
	end
	local xval = -1
	if left == true then
		xval = 1
	end
	local zval = 0
	if top == true then
		zval = math.random(5,20)
	else
		zval = math.random(-20,-5)
	end
	model:SetPrimaryPartCFrame(CFrame.new(Vector3.new(pos.x+xval*49+math.random(-3,3),2.5,zval)))
end

_G["MakeStatue"] = function(plr,tbl)
	local x = -166
	local rot = -90
	for num,p in pairs (game.Players:GetPlayers()) do
		if p ~= plr and workspace:FindFirstChild(p.Name.."'s Statue") then
			x = 166
			rot = 90
			break
		end
	end
	local model = Instance.new("Model",workspace)
	model.Name = plr.Name.."'s Statue"
	local base = game.ServerStorage.StatueStuff.Statue1:clone()
	base.Parent = model
	base:SetPrimaryPartCFrame(CFrame.new(Vector3.new(x,.5,0)))
	local pers = game.ServerStorage.StatueStuff.StatueP:clone()
	pers.Name = plr.Name.."'s Human"
	pers:SetPrimaryPartCFrame(CFrame.new(Vector3.new(x,14.155,0))*CFrame.Angles(0,math.rad(rot),0))
	if game.ServerStorage:FindFirstChild("Hats") then
		for i=1,#tbl do
			local item = _G.GetName(tbl[i])
			for r,k in pairs (game.ServerStorage.Hats:children()) do
				if k.ClassName == "Hat" and k.Name == item then
					local cl = k:clone()
					cl.Parent = pers
					cl.Handle.CFrame = pers.Head.CFrame * CFrame.new(0, pers.Head.Size.Y / 2, 0) * cl.AttachmentPoint:inverse()
				end
			end
		end
	end
	pers.Leader.Value = plr.Name
	pers.Parent = workspace
	for i,k in pairs (pers:children()) do
		if k.ClassName == "Part" then
			k.Anchored = true
		end
	end
	local top = {true,false}
	local left = false
	if pers.Torso.Position.x < 0 then
		left = true
	else
		left = false
	end
	for i=1,2 do
		_G.MakeMine(pers.Torso.Position,top[i],left)
	end
end

_G.Error = function()
	
end

_G.PlrRemoved = function(plr,type)
	local n = plr.Name
	if type == 1 then
		
	end
end
