local boundaries,bound2 = Vector2.new(-995,995),Vector3.new(-985,985)
local cellslimit,spikes = 3750,19
local tinycellsize = 2

local vips = {{"FutureWebsiteOwner",20},{"Player1",420},{"Player",250}}
local shopds = game:GetService("DataStoreService"):GetDataStore("Shop")

local ps,ms,bs = game:GetService("PointsService"),game:GetService("MarketplaceService"),game:GetService("BadgeService")

local r = workspace:WaitForChild("Remotes")
local ctos = r:WaitForChild("CtoS")


--:::::: Functions For Settings New Shop Items ::::::--

-- items = table of items to add {name,id,cost}

local ds = game:GetService("DataStoreService"):GetDataStore("Shop")

local function setNewItem(items,typ)
	local s = pcall(function() local GBED = items[1][1] end)
	if not s then items = {items} end
	local function Set(async)
		local tbl = ds:GetAsync(async)
		if type(tbl) ~= "table" then tbl = {} end
		for _,k in pairs (items) do
			table.insert(tbl,k)
			print("Inserted "..k[1].." with the ID of "..tostring(k[2]).." with the cost of "..tostring(k[3]).." successfully into table")
		end
		ds:SetAsync(async,tbl)
		print("Data has Successfully Saved!")
	end
	if typ:lower() == "audio" or typ:lower() == "sound" or typ:lower() == "music" then
		Set("Music")
	elseif typ:lower() == "particle" or typ:lower() == "particles" then
		Set("Particles")
	else
		Set("Textures")
	end
end
--[[setNewItem({{"Bloxxer",168439260,-2},
	{"Circle O Fire",261780604,-2},
	{"Circle O Blue Fire",261780623,-2},
	{"Crystal Epic",60831247,-2},
	{"Lava",120622442,-2},
	{"Test Dummy",84140473,-2},
	{"Orange Storm",260818024,-2}
	},"textures")
setNewItem({{"Plus Health",181012711,-2},
	{"Splat",179462422,-2},
	{"Atom",102769242,-2},
	{"Stacks of Dollars",120877485,-2},
	{"Cash",14057019,-2}
	},"particles")]]

local function giveItem(items,plrs)
	
end

local function removeItem(items,typ)
	local ds = game:GetService("DataStoreService"):GetDataStore("Shop")
	if type(items) ~= "table" then items = {items} end
	local function RemoveFrom(async)
		local tbl = ds:GetAsync(async)
		if type(tbl) ~= "table" then tbl = {} end
		for _,item in pairs (items) do
			for i,k in pairs (tbl) do
				if item == k[1] then
					print("Removed "..k[1].." From Shop Data")
					table.remove(tbl,i)
				end
			end
		end
		print("Data has Successfully Saved!")
		ds:SetAsync(async,tbl)
	end
	if typ:lower() == "audio" or typ:lower() == "sound" or typ:lower() == "music" then
		RemoveFrom("Music")
	elseif typ:lower() == "particle" or typ:lower() == "particles" then
		RemoveFrom("Particles")
	else
		RemoveFrom("Textures")
	end
end

local function changePrice(item,typ,newprice)
	local dss = game:GetService("DataStoreService"):GetDataStore("Shop")
	local function ChangePrice(async)
		local tbl = dss:GetAsync(async)
		if type(tbl) ~= "table" then tbl = {} end
		for i,k in pairs (tbl) do
			if item:lower() == k[1]:lower() then
				local oldprice = k[3]
				k[3] = newprice
				print("Changed "..k[1].."'s From "..tostring(oldprice).." To "..tostring(newprice).." in the Shop Data")
			end
		end
		print("Data has Successfully Saved!")
		dss:SetAsync(async,tbl)
	end
	if typ:lower() == "audio" or typ:lower() == "sound" or typ:lower() == "music" then
		ChangePrice("Music")
	elseif typ:lower() == "particle" or typ:lower() == "particles" then
		ChangePrice("Particles")
	else
		ChangePrice("Textures")
	end
end

local function print_Data(userId)
	local dss = game:GetService("DataStoreService"):GetDataStore("Shop")
	local tbl = dss:GetAsync(tostring(userId))
	local function P(tbl)
		for i,k in pairs (tbl) do
			print(i,k)
			if type(k) == "table" then
				P(k)
			end
		end
	end
	P(tbl)
end

--[[
	Textures table: 0x5b917d0
1 0
2 0
3 0
4 0
5 0
6 0
7 0
8 0
9 0
10 0
11 0
12 0
13 0
14 0
15 0
16 0
17 0
18 0
19 0
20 0
21 0
22 0
23 0
24 1
25 0
26 2
27 0
28 0
29 0
30 1
31 0
32 0
33 0
34 0
35 0
36 0
37 0
38 0
39 0
40 0
41 1
42 0
43 0
44 0
45 0
46 0
47 1
48 1
49 0
50 0
51 0
52 0
Music table: 0xeede320
1 0
2 0
3 0
4 0
5 0
6 0
7 0
8 0
9 0
10 0
11 0
12 0
13 0
14 0
15 0
16 0
17 0
18 0
19 0
20 0
21 0
22 0
23 0
24 0
25 0
Particles table: 0x21416190
1 0
2 0
3 0
4 0
5 0
6 0
7 0
8 2
9 0
10 0
11 0
12 0
13 1
14 1
15 0
16 1
17 0
18 0
19 0
20 0
21 0
22 0
23 1
24 0
Coins 4179
--]]


local function SetCoins(userid,val,inc)
	local ds = game:GetService("DataStoreService"):GetDataStore("Shop")
	local tbl = ds:GetAsync(tostring(userid))
	if inc then
		tbl.Coins = tbl.Coins + val
	else
		tbl.Coins = val
	end
	print("Set "..tostring(userid).."'s Coins to "..tostring(tbl.Coins)..".")
	ds:SetAsync(tostring(userid),tbl)
end

--[[
	Twitter Codes:
	
	table of codes
	
	Code Table:
	[1] = code
	[2] = type of reward {1=coins,2=texture,3=audio,4=particle}
	[3] = amount/name of reward
	[4] = expired

--]]

local function setCode(code,reward,amount,expired)
	if expired == nil then expired = false end
	local ds = game:GetService("DataStoreService"):GetDataStore("Shop")
	local tbl = {code,reward,amount,expired}
	local t = ds:GetAsync("TwitterCodes")
	table.insert(t,tbl)
	ds:SetAsync("TwitterCodes",t)
	print("Successfully Added and Saved Code: "..code.." with a reward type of "..tostring(reward).." of the name/amount of "..tostring(amount).." to Twitter Code Database.")
end

local function expireCode(code)
	
end


--:::::::::::::::::::::::::::::::::::::::::::::::::::--

local function findDirection(p1,p2,typevector) --returns a unit vector2
	local v = pcall(function() local mahna_mahna = p1.z end)
	local x,z
	if v == true then --if vector3 then
		x,z = p1.x-p2.x,p1.z-p2.z
	else --elseif vector2 then
		x,z = p1.x-p2.x,p1.y-p2.y
	end
	local h = math.max(math.abs(x),math.abs(z))
	if typevector == 3 then
		return Vector3.new(x/h,-24,z/h)
	else
		return Vector2.new(x/h,z/h)
	end		
end

local function findPlrfromCell(cell)
	local n = cell.Name
	for _,k in pairs (game.Players:GetPlayers()) do
		if string.sub(n,1,string.len(k.Name)) == k.Name then
			return k
		end
	end
end

local t = 0

local function incrementPP(plr,val)
	pcall(function() if type(plr) == "string" then plr = game.Players:FindFirstChild(plr) end end)
	pcall(function() if type(plr) ~= "number" then plr = plr.userId end end)
	if plr then
		local v = game.ServerStorage.PointData:FindFirstChild(tostring(plr))
		if v then
			v.Value = v.Value + val
			--[[if math.floor(v.Value/10) >= 1 then
				local oldval = v.Value
				v.Value = v.Value - 10*math.floor(v.Value/10)
				ps:AwardPoints(plr,math.floor(oldval/10))
			end]]
		end
	end
end

local function giveCoins(plr,amount)
	if type(plr) == "string" then plr = game.Players:FindFirstChild(plr) if plr then plr = plr.userId else return end end
	if type(plr) ~= "number" then pcall(function() plr = plr.userId end) end
	if plr == nil then return end
	if game.ServerStorage.PlayerData:FindFirstChild(tostring(plr)) == nil then return end
	local fold = game.ServerStorage.PlayerData[tostring(plr)]
	if fold:findFirstChild("Coins") then
		pcall(function()
			if game.ServerStorage.ObscureInnovations[tostring(plr)].Value == true then
				amount = 2*amount
			end
		end)
		fold.Coins.Value = fold.Coins.Value + amount
	end
end

local function getTotalMass(model)
	local m = 0
	for _,k in pairs (model) do
		if k.ClassName == "Part" then
			m = m + k:GetMass()
		end
	end
	return m
end

local function changeSpeed(cell,speed,u)
	if cell:findFirstChild("Dot") == nil then return end
	if u == nil then
		u = (cell.Dot.Velocity).unit
	end
	local isVector3 = pcall(function() local GBED = u.z end)
	if isVector3 == false then u = Vector3.new(u.x,0,u.y) end
	cell.Dot.Velocity = speed*u
end

local function getSpeed(cell)
	if cell:findFirstChild("Dot") == nil then return end
	local u = cell.Dot.Velocity.unit
	return cell.Dot.Velocity.x/u.x
end

local function changeSize(cell,size,inc)
	if cell:findFirstChild("Dot") == nil then return end
	if cell.Dot.Mesh.Scale.x == size/5 then return end
	if inc then
		cell.Dot.BGui.lblMass.Text = tostring(tonumber(cell.Dot.BGui.lblMass.Text)+size)
	else	
		cell.Dot.BGui.lblMass.Text = tostring(size)
	end
	local size2 = size/5
	if inc then
		size2 = (tonumber(cell.Dot.BGui.lblMass.Text)+size)/5
	end
	if (inc and (tonumber(cell.Dot.BGui.lblMass.Text)+size) > 4000) or size > 4000 then
		size2 = 4000/5
	end
	cell.Dot.Mesh.Scale = Vector3.new(size2,size2,1)
	local s = Vector3.new(math.floor(size2/2),math.floor(size2/2),10)
	if s ~= cell.Dot.Size then
		cell.Dot.Size = s
		cell.Dot.CFrame = CFrame.new(cell.Dot.Position.x,-24,cell.Dot.Position.z)*CFrame.Angles(math.pi/2,0,0)
	end
end

local function addParticleSizeChanges(cell,part)
	coroutine.resume(coroutine.create(function()
		while wait(.8) and part ~= nil do
			local s = pcall(function()
				part.Size = NumberSequence.new((cell.Size.Value/10 + 5)/5)
			end)
			if s == false then
				part.Size = NumberSequence.new(1)
			end
		end
	end))
end

local function findSpawnSpot()
	local spot
	repeat
		local r = Ray.new(Vector3.new(math.random(boundaries.x,boundaries.y),-10,math.random(boundaries.x,boundaries.y)),Vector3.new(0,-20,0))
		local part,pos = workspace:FindPartOnRay(r)
		if part and part.Parent == workspace.Boundaries then
			spot = pos + Vector3.new(0,-pos.y-24,0)
		end
	until spot
	return spot
end

local function spawnCell(cell,pos,ang)
	if ang == nil then ang = {math.pi/2,0,0} end
	if pos == nil then pos = findSpawnSpot() end
	if cell:findFirstChild("Dot") then
		cell.Dot.CFrame = CFrame.new(pos)*CFrame.Angles(ang[1],ang[2],ang[3])
	else
		cell.CFrame = CFrame.new(pos)*CFrame.Angles(ang[1],ang[2],ang[3])
	end
	return pos
end

local function connect_Virus_Events(virus)
	virus:WaitForChild("Touch").Touched:connect(function(hit)
		if hit.Parent and hit.Parent.Name == "CellMass" then
			local vel = hit.Velocity.unit
			virus.Touch.BGui.lblMass.Text = tostring(tonumber(virus.Touch.BGui.lblMass.Text) + math.random(14,17))
			hit.Parent:Destroy()
			if tonumber(virus.Touch.BGui.lblMass.Text) >= 200 then
				virus.Touch.BGui.lblMass.Text = "100"
				local new = virus:clone()
				new.Anchored = false
				new.Touch.Anchored = false
				new.Velocity = 100*vel
				new.Touch.Velocity = 100*vel
				new.Parent = workspace.Cells.Spikes
				coroutine.resume(coroutine.create(function()
					wait(.8)
					new.Anchored = true
					new.Touch.Anchored = true
					new.Velocity,new.Touch.Velocity = Vector3.new(0,0,0),Vector3.new(0,0,0)
					--wait(1)
					--new.Touch.CFrame = CFrame.new(new.Position)
				end))
				connect_Virus_Events(new)
			end
		end
	end)
end

local function makeTinyCell(coin)
	local p = Instance.new("Part")
	p.Anchored = true
	p.CanCollide = false
	p.Locked = true
	p.BrickColor = BrickColor.Random()
	p.Material = Enum.Material.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Size = Vector3.new(tinycellsize/2.5,tinycellsize/2.5,1)
	local l = Instance.new("PointLight",p)
	l.Brightness = 1337
	l.Range = 30
	local m = Instance.new("SpecialMesh",p)
	m.MeshType = Enum.MeshType.FileMesh
	m.MeshId = "http://www.roblox.com/asset/?id=1185246"
	if coin == true then
		p.BrickColor = BrickColor.new("New Yeller")
		m.TextureId = "rbxassetid://254242798"
	else
		m.TextureId = ""
	end
	m.Scale = Vector3.new(tinycellsize,tinycellsize,1)
	return p
end

local function DoCell(coin) --makes tiny cell thingies
	local c
	pcall(function() 
		c = makeTinyCell(coin)
		c.Parent = workspace.Cells.TinyCells
		spawnCell(c)
		c.CFrame = CFrame.new(Vector3.new(c.Position.x,-24,c.Position.z))*CFrame.Angles(math.pi/2,0,0)
	end)
	if c then
		if coin then
			Instance.new("Folder",c).Name = "Coin"
		end
		--[[local eaten = false
		c.Touched:connect(function(hit)
			if hit.Parent.Parent == workspace.Cells and hit.Name == "Dot" then
				local pl = findPlrfromCell(hit.Parent)
				if coin == true and pl then
					coin = false
					giveCoins(pl,1)
				end
				if eaten == false then
					eaten = true
					DoCell(math.random(1,7) == 1)
				end
			end
		end)]]
	end
	return c
end

local function getCells(plr)
	if type(plr) ~= "string" then plr = plr.Name end
	local t = {}
	for _,k in pairs (workspace.Cells:children()) do
		if k.Name == plr.."'s Cell" and k:findFirstChild("Dot") and k.Dot:findFirstChild("BGui") then
			table.insert(t,k)
		end
	end
	return t
end

local function DoSpike()
	local spike = game.ServerStorage.Spike:clone()
	local pos = spawnCell(spike,nil,{0,0,0})
	spawnCell(spike:WaitForChild("Touch"),pos,{0,0,0})
	spike.Parent = workspace.Cells.Spikes
	connect_Virus_Events(spike)
end

local function canCollide(cell)
	cell.Dot.CanCollide = true
end

local function connectTouchEvents(plr,cell)
	local size = cell:findFirstChild("Size")
	if size == nil then
		size = Instance.new("IntValue",cell)
		size.Name = "Size"
		size.Value = tonumber(cell.Dot.BGui.lblMass.Text)
	end
	size.Changed:connect(function()
		changeSize(cell,size.Value)
	end)
	changeSize(cell,size.Value)
	cell:WaitForChild("Dot").Touched:connect(function(h)
		if h and h.Parent and h.Parent.Parent and h.Parent.Parent == workspace.Cells and h.Parent.Name ~= plr.Name.."'s Cell" and h.Parent:FindFirstChild("Eaten") == nil and h:FindFirstChild("BGui") then
			local k = h.Parent
			pcall(function()
				if tonumber(cell.Dot.BGui.lblMass.Text) > 1.07*tonumber(k.Dot.BGui.lblMass.Text) then
					Instance.new("Folder",k).Name = "Eaten"
					size.Value = size.Value + tonumber(k.Dot.BGui.lblMass.Text)--changeSize(cell,tonumber(k.Dot.BGui.lblMass.Text),true)
					incrementPP(plr,tonumber(k.Dot.BGui.lblMass.Text))
					pcall(function() --owner termination badge
						if k.Name == "FutureWebsiteOwner's Cell" then
							if not ms:PlayerOwnsAsset(plr,259896586) then
								bs:AwardBadge(plr.userId,259896586)
							end
						end
					end)
					k:Destroy()
				end
			end)
			pcall(function()
				wait()
				if k:FindFirstChild("Eaten") then
					k.Eaten:Destroy()
				end
			end)
		elseif h and h.Parent and h.Parent.Parent and h.Parent.Parent == workspace.Cells and h.Parent.Name == plr.Name.."'s Cell" and h.Parent:FindFirstChild("Connect") and h:FindFirstChild("BGui") then
			local k = h.Parent
			pcall(function()
				if tonumber(cell.Dot.BGui.lblMass.Text) > tonumber(k.Dot.BGui.lblMass.Text) then
					size.Value = size.Value + tonumber(k.Dot.BGui.lblMass.Text)--changeSize(cell,tonumber(k.Dot.BGui.lblMass.Text),true)
					k:Destroy()
				end
			end)
		elseif h and h.Name == "Touch" and h.Parent and h.Parent.Parent and h.Parent.Parent == workspace.Cells.Spikes then
			local k = h.Parent
			pcall(function()
				if 1.07*tonumber(cell.Dot.BGui.lblMass.Text) > tonumber(k.Touch.BGui.lblMass.Text) then
					local n = #getCells(plr)
					if n < 8 then
						for _,k in pairs (workspace.Cells:children()) do
							if k.Name == plr.Name.."'s Cell" then
								pcall(function()
									k.Connect:Destroy()
								end)
								pcall(function()
									k.Dot.CanCollide = true
								end)
							end
						end
						n = 8 - n
						local function EjectCell(c)
							local ang = math.random(1,360)
							local r = math.rad(ang)
							pcall(function()
								c.Dot.CFrame = CFrame.new(cell.Dot.Position+tonumber(c.Dot.BGui.lblMass.Text)/3*Vector3.new(math.cos(r),0,math.sin(r)))
							end)
						end
						local s = tonumber(cell.Dot.BGui.lblMass.Text)
						s = math.ceil(s/3)
						local spercell = s/n
						size.Value = math.ceil(size.Value/2)--changeSize(cell,math.ceil(tonumber(cell.Dot.BGui.lblMass.Text)/2))
						for i=1,n do
							local c = cell:clone()
							c.Size.Value = math.ceil(spercell)--changeSize(c,math.ceil(spercell))
							connectTouchEvents(plr,c)
							pcall(function() addParticleSizeChanges(cell,cell.Dot.ParticleEmitter) end)
							EjectCell(c)
							c.Parent = workspace.Cells
						end
						workspace.Remotes.StoC.DisconnectedCells:FireClient(plr)
					end
					size.Value = math.ceil(size.Value/1.5)--changeSize(cell,math.ceil(tonumber(cell.Dot.BGui.lblMass.Text)/1.5))
					k:Destroy()
					coroutine.resume(coroutine.create(function()
						if #workspace.Cells.Spikes:children() < spikes then
							DoSpike()
						end
					end))
				end
			end)
		elseif h and h.Parent and h.Parent == workspace.Cells.TinyCells then
			pcall(function()
				if plr.leaderstats.Size.Value < 500 or math.random(1,math.ceil((plr.leaderstats.Size.Value^1.337)/1000)) <= 2 then
					size.Value = size.Value + 1--changeSize(cell,1,true)
					incrementPP(plr,1)
				end
			end)
			if h:FindFirstChild("Coin") then
				pcall(function() giveCoins(plr,1) end)
			end
			h:Destroy()
		elseif h and h.Parent and h.Parent.Parent and h.Parent.Parent == workspace.Cells and h.Parent.Name == "CellMass" and h.Parent:FindFirstChild("MassEaten") == nil then
			Instance.new("Folder",h.Parent).Name = "MassEaten"
			size.Value = size.Value + math.random(14,17)
			h.Parent:Destroy()
		end
	end)
end

--[[local function connectTouchEvents(plr,cell)
	local size = cell:findFirstChild("Size")
	if size == nil then
		size = Instance.new("IntValue",cell)
		size.Name = "Size"
		size.Value = tonumber(cell.Dot.BGui.lblMass.Text)
	end
	size.Changed:connect(function()
		changeSize(cell,size.Value)
	end)
	changeSize(cell,size.Value)
	coroutine.resume(coroutine.create(function()
		local tbl = {}
		cell:WaitForChild("Dot").Touched:connect(function(h)
			if h.Parent == workspace.Cells and h.Name ~= plr.."'s Cell" and h:findFirstChild("BGui") then
				local you,other
				pcall(function() you,other = tonumber(cell.Dot.BGui.lblMass.Text),tonumber(h.Parent.Dot.BGui.lblMass.Text) end)
				if you == nil or other == nil or (you and other and 1.05*you < other) then
					table.insert(tbl,h.Parent)
					pcall(function() cell.Dot.CanCollide = false end)
				end
			end
		end)
		cell.Dot.TouchEnded:connect(function(h)
			for i,k in pairs (tbl) do
				if k == h.Parent then
					table.remove(tbl,i)
				end
			end
			if #tbl == 0 then
				canCollide(cell)
			end
		end)
	end))
	coroutine.resume(coroutine.create(function()
		local touching = {}
		local function init(h)
			for i,k in pairs (touching) do
				if h == k then
					return true,i
				end
			end
		end
		cell:WaitForChild("Dot").Touched:connect(function(h)
			if h.Parent == workspace.Cells.TinyCells then
				pcall(function()
					if plr.leaderstats.Size.Value < 500 or math.random(1,math.ceil((plr.leaderstats.Size.Value^1.337)/1000)) <= 2 then
						size.Value = size.Value + 1--changeSize(cell,1,true)
						incrementPP(plr,1)
					end
				end)
				if h:FindFirstChild("Coin") then
					pcall(function() giveCoins(plr,1) end)
				end
				h:Destroy()
			elseif h.Parent and h.Parent.Parent and h.Parent.Parent == workspace.Cells and h.Parent.Name == "CellMass" then
				size.Value = size.Value + math.random(14,17)--pcall(function() changeSize(cell,math.random(14,17),true) end)
				h.Parent:Destroy()
			elseif h and h.Name == "Dot" and h.Parent and h.Parent.Parent and h.Parent.Parent == workspace.Cells or h.Parent.Parent == workspace.Cells.Spikes then
				if not init(h.Parent) then
					table.insert(touching,h.Parent)
				end
			end
		end)
		cell.Dot.TouchEnded:connect(function(h)
			local i,v = init(h.Parent)
			if i then
				table.remove(touching,v)
			end
		end)
		repeat
			for i,k in pairs (touching) do
				--local doit = false
				--pcall(function() if (k.Dot.Position-cell.Dot.Position).magnitude < tonumber(cell.Dot.BGui.lblMass.Text)/9 then doit = true end end)
				--pcall(function() if (k.Position-cell.Dot.Position).magnitude < tonumber(cell.Dot.BGui.lblMass.Text)/9 then doit = true end end)
				--if doit == true then
				if k.Name == plr.Name.."'s Cell" and k:findFirstChild("Connect") then
					pcall(function()
						if tonumber(cell.Dot.BGui.lblMass.Text) > tonumber(k.Dot.BGui.lblMass.Text) then
							size.Value = size.Value + tonumber(k.Dot.BGui.lblMass.Text)--changeSize(cell,tonumber(k.Dot.BGui.lblMass.Text),true)
							k:Destroy()
							table.remove(touching,i)
						end
					end)
				elseif k.Parent == workspace.Cells and k.Name ~= plr.Name.."'s Cell" then
					pcall(function()
						if tonumber(cell.Dot.BGui.lblMass.Text) > 1.07*tonumber(k.Dot.BGui.lblMass.Text) then
							size.Value = size.Value + tonumber(k.Dot.BGui.lblMass.Text)--changeSize(cell,tonumber(k.Dot.BGui.lblMass.Text),true)
							incrementPP(plr,tonumber(k.Dot.BGui.lblMass.Text))
							pcall(function() --owner termination badge
								if k.Name == "FutureWebsiteOwner's Cell" then
									if not bs:UserHasBadge(plr.userId,259896586) then
										bs:AwardBadge(plr.userId,259896586)
									end
								end
							end)
							k:Destroy()
							table.remove(touching,i)
						end
					end)
				elseif k.Parent == workspace.Cells.Spikes then
					pcall(function()
						if 1.07*tonumber(cell.Dot.BGui.lblMass.Text) > tonumber(k.Touch.BGui.lblMass.Text) then
							local n = #getCells(plr)
							if n < 8 then
								for _,k in pairs (workspace.Cells:children()) do
									if k.Name == plr.Name.."'s Cell" then
										pcall(function()
											k.Connect:Destroy()
										end)
										pcall(function()
											k.Dot.CanCollide = true
										end)
									end
								end
								n = 8 - n
								local function EjectCell(c)
									local ang = math.random(1,360)
									local r = math.rad(ang)
									pcall(function()
										c.Dot.CFrame = CFrame.new(cell.Dot.Position+tonumber(c.Dot.BGui.lblMass.Text)/3*Vector3.new(math.cos(r),0,math.sin(r)))
									end)
								end
								local s = tonumber(cell.Dot.BGui.lblMass.Text)
								s = math.ceil(s/3)
								local spercell = s/n
								size.Value = math.ceil(size.Value/2)--changeSize(cell,math.ceil(tonumber(cell.Dot.BGui.lblMass.Text)/2))
								for i=1,n do
									local c = cell:clone()
									c.Size.Value = math.ceil(spercell)--changeSize(c,math.ceil(spercell))
									connectTouchEvents(plr,c)
									pcall(function() addParticleSizeChanges(cell,cell.Dot.ParticleEmitter) end)
									EjectCell(c)
									c.Parent = workspace.Cells
								end
								workspace.Remotes.StoC.DisconnectedCells:FireClient(plr)
							end
							size.Value = math.ceil(size.Value/1.5)--changeSize(cell,math.ceil(tonumber(cell.Dot.BGui.lblMass.Text)/1.5))
							k:Destroy()
							table.remove(touching,i)
							coroutine.resume(coroutine.create(function()
								if #workspace.Cells.Spikes:children() < spikes then
									DoSpike()
								end
							end))
						end
					end)
				elseif k == nil or k.Parent == nil then
					table.remove(touching,i)
				end
				--end --magnitude stuff
			end			
			wait(.1)
		until cell == nil or cell.Parent == nil
	end))
end]]

local ctc = ctos:WaitForChild("CheckTwitterCode")
function ctc.OnServerInvoke(plr,code)
	local tdata = game.ServerStorage.PlayerCodesUsed:FindFirstChild(tostring(plr.userId))
	local itemdata = game.ServerStorage.PlayerData:FindFirstChild(tostring(plr.userId))
	for _,k in pairs (tdata:children()) do
		if code == k.Name then
			return "Used"
		end
	end
	for i,k in pairs(game.ServerStorage.TwitterCodes:children()) do
		if k.Name == code then
			local ex = false
			pcall(function()
				if k.Expired.Value == true then
					ex = true
				end
			end)
			if ex == true then
				return "Expired"
			end
			local tbl = {}
			table.insert(tbl,k.Reward.Value)
			table.insert(tbl,k.Amount.Value)
			Instance.new("Folder",tdata).Name = code
			return tbl
		end
	end
end

local ci = ctos:WaitForChild("CheckItem")
function ci.OnServerInvoke(plr,typ,item)
	typ = typ == 2 and "Textures" or typ == 3 and "Music" or "Particles"
	pcall(function()
		local data = game.ServerStorage.PlayerData[tostring(plr.userId)][typ]
		return data[item].Value
	end)
end

local gt = ctos:WaitForChild("GiveItem")
gt.OnServerEvent:connect(function(plr,typ,item)
	typ = typ == 2 and "Textures" or typ == 3 and "Music" or "Particles"
	pcall(function()
		local data = game.ServerStorage.PlayerData[tostring(plr.userId)][typ]
		data[item].Value = 1
	end)
end)

local gsd = ctos:WaitForChild("GetShopData")
function gsd.OnServerInvoke(plr,addvalues)
	--[[
		t1
		[1] = {item name,id,cost}
	--]]
	local t1 = shopds:GetAsync("Textures")
	_G["Textures"] = t1
	wait(1)
	local t2 = shopds:GetAsync("Music")
	_G["Music"] = t2
	wait(1)
	local t3 = shopds:GetAsync("Particles")
	_G["Particles"] = t3
	wait(1)
	local t4 = shopds:GetAsync(tostring(plr.userId))
	if addvalues then
		local tbl,changed = t4,false
		if tbl == nil then tbl = {} changed = true end
		coroutine.resume(coroutine.create(function()
			local fold = game.ServerStorage.PlayerData:WaitForChild(tostring(plr.userId))
			for _,k in pairs ({{"Textures",t1},{"Music",t2},{"Particles",t3}}) do
				local f = Instance.new("Folder",fold)
				f.Name = k[1]
				for n,i in pairs (k[2]) do
					local b = Instance.new("IntValue",f)
					b.Name = i[1]
					if tbl[k[1]] == nil then tbl[k[1]] = {} changed = true end
					if tbl[k[1]][n] and type(tbl[k[1]][n]) == "number" then
						b.Value = tbl[k[1]][n]
					else
						tbl[k[1]][n] = 0
						changed = true
					end
				end
			end
			if changed == true then
				shopds:SetAsync(tostring(plr.userId),tbl)
			end
			if plr.userId > 0 or plr.Name == "Player1" then
				if plr.Name == "Player1" or plr.Name == "IntellectualBeing" or game:GetService("BadgeService"):UserHasBadge(plr.userId,253657270) then
					print("Has Beta Badge")
					if fold.Textures:FindFirstChild("Beta Tester") and fold.Textures:FindFirstChild("Crimson Catseye") and fold.Particles:FindFirstChild("Beta") and fold.Particles:FindFirstChild("Epic Face") and fold.Textures:FindFirstChild("Doge") and fold.Particles:FindFirstChild("Illuminati") then
					print("HI")	if fold.Textures["Beta Tester"].Value == 0 or fold.Textures["Crimson Catseye"].Value == 0 or fold.Particles["Beta"].Value == 0 or fold.Particles["Epic Face"].Value == 0 or fold.Textures["Doge"].Value == 0 or fold.Particles["Illuminati"].Value == 0 then
							local ui = game.ServerStorage.BetaTesterGui:clone()
							ui.Parent = plr.PlayerGui
							ui.Main.Disabled = false
						end
					end
				end
			end
		end))
	end
	return t1,t2,t3,t4
end

local gv = ctos:WaitForChild("GetValue")
function gv.OnServerInvoke(plr,tbl)
	local data,val = game.ServerStorage.PlayerData:FindFirstChild(tostring(plr.userId))
	if data then
		for i,k in pairs (tbl) do
			data = data:findFirstChild(k)
			if data == nil then break end
		end
	end
	pcall(function()
		val = data.Value
	end)
	return val
end

local tab = {"Textures","Music","Particles"}
local ge = ctos:WaitForChild("GetEquipped")
function ge.OnServerInvoke(plr)
	local function findIDfromItem(typ,item)
		local t = _G[typ]
		for i,k in pairs (t) do
			if item == k[1] then
				return k[2]
			end
		end
	end
	local customs,tbl = game.ServerStorage.CustomStuff:FindFirstChild(tostring(plr.userId)),{}
	local data = game.ServerStorage.PlayerData:FindFirstChild(tostring(plr.userId))
	if customs then
		for i,k in pairs (tab) do
			pcall(function()
				tbl[k] = {}
				local f = customs[k]
				for e,r in pairs (f:children()) do
					print(r.Name,r.Value)
					table.insert(tbl[k],{r.Name,r.Value})
				end
			end)
		end
	end
	if data then
		for i,k in pairs (tab) do
			pcall(function()
				local f = data[k]
				for e,r in pairs (f:children()) do
					if k ~= "Particles" or tbl[k][1] == nil then --limit particle count, 1 is amount
						if r.Value == 2 then
							table.insert(tbl[k],{r.Name,findIDfromItem(k,r.Name)})
						end
					end
				end
			end)
		end
	end
	return tbl
end

local uc = ctos:WaitForChild("UnequipCustoms")
function uc.OnServerInvoke(plr,typ)
	pcall(function()
		game.ServerStorage.CustomStuff[tostring(plr.userId)][typ]:ClearAllChildren()
	end)
end

local uc = ctos:WaitForChild("EquipCustom")
function uc.OnServerInvoke(plr,typ,id)
	if typ ~= "Music" then
		pcall(function()
			game.ServerStorage.CustomStuff[tostring(plr.userId)][typ]:ClearAllChildren()
		end)
	end
	pcall(function()
		local tbl = ms:GetProductInfo(tonumber(id))
		local int = Instance.new("IntValue",game.ServerStorage.CustomStuff[tostring(plr.userId)][typ])
		int.Name = tbl.Name
		int.Value = math.floor(tonumber(id))
	end)
end

local hcgp = ctos:WaitForChild("HasCustomGamepass")
function hcgp.OnServerInvoke(plr,typ)
	local ret
	pcall(function()
		ret = game.ServerStorage.CustomStuff[tostring(plr.userId)]:findFirstChild(typ)
	end)
	if ret then
		return true
	end
end

local be = ctos:WaitForChild("Buy/Equip")
function be.OnServerInvoke(plr,cmd,c)
	local f = game.ServerStorage.PlayerData:FindFirstChild(tostring(plr.userId))
	local typ = c.picID == nil and "Textures" or c.picID == 254700923 and "Music" or "Particles"
	if c == nil or f == nil or c.ItemName == nil or f:findFirstChild(typ) == nil or f[typ]:findFirstChild(c.ItemName) == nil then return end
	local val = f[typ]:findFirstChild(c.ItemName)
	if cmd == "cmdBuy" then
		local cost = c.Cost
		if cost == nil then return end
		if f:findFirstChild("Coins") == nil then return end
		if f.Coins.Value < cost then return end
		f.Coins.Value = f.Coins.Value - cost
		f[typ][c.ItemName].Value = 1
	elseif cmd == "cmdEquip" then
		if typ ~= "Music" then
			for i,k in pairs (f[typ]:children()) do
				if k ~= val then
					if k.Value == 2 then
						k.Value = 1
					end
				end
			end
		end
		val.Value = val.Value == 2 and 1 or 2
	end
	return true
end

local gsc = ctos:WaitForChild("GetShopCell")
function gsc.OnServerInvoke(plr)
	local sc = game.ServerStorage:WaitForChild("ShopCell")
	local clone = sc:clone()
	clone.Parent = plr.PlayerGui
	return clone
end

local givecoins = ctos:WaitForChild("GiveCoins")
function givecoins.OnServerInvoke(plr,amount)
	giveCoins(plr,amount)
end


local se = ctos:WaitForChild("SetEvent")
se.OnServerEvent:connect(function(plr,stat)
	local pstats = game.ServerStorage:FindFirstChild("PlayerData")
	if pstats == nil then return end
	if pstats:findFirstChild(tostring(plr.userId)) == nil then return end
	if pstats[tostring(plr.userId)].Settings:findFirstChild(stat) == nil then return end
	pstats[tostring(plr.userId)].Settings[stat].Changed:connect(function(val)
		workspace.Remotes.StoC.ChangeSetting:FireClient(plr,stat,val)
	end)
end)

local rd = ctos:WaitForChild("ReceiveData")
function rd.OnServerInvoke(plr)
	if game.ServerStorage:FindFirstChild("PlayerData") == nil then return end
	local data = game.ServerStorage.PlayerData:FindFirstChild(tostring(plr.userId))
	if data == nil then return end
	local tbl = {}
	local function add(d,t)
		for _,k in pairs (d:children()) do
			if k.ClassName == "Folder" then
				tbl[k.Name] = {}
				add(k,tbl[k.Name])
			elseif k.ClassName == "IntValue" or k.ClassName == "NumberValue" or k.ClassName == "StringValue" or k.ClassName == "BoolValue" then
				t[k.Name] = k.Value
			end
		end
	end
	add(data,tbl)
	return tbl
end

local sc = ctos:WaitForChild("SetCoins")
sc.OnServerEvent:connect(function(plr,val,inc)
	local data = game.ServerStorage.PlayerData:FindFirstChild(tostring(plr.userId))
	if data and data:findFirstChild("Coins") then
		if inc then
			val = data.Coins.Value + val
		end
		data.Coins.Value = val
	end
end)

local sd = ctos:WaitForChild("SetData")
sd.OnServerEvent:connect(function(plr,stat,val)
	if type(stat) ~= "table" then stat = {stat} end
	if type(val) ~= "table" then val = {val} end
	if game.ServerStorage.PlayerData:FindFirstChild(tostring(plr.userId)) == nil then return end
	if game.ServerStorage.PlayerData[tostring(plr.userId)]:findFirstChild("Settings") == nil then return end
	for i,k in pairs (stat) do
		game.ServerStorage.PlayerData[tostring(plr.userId)].Settings[k].Value = val[i]
	end
end)

local cc = ctos:WaitForChild("CreateCell")
function cc.OnServerInvoke(plr,texture,particles,color,size)
	pcall(function() if not ms:PlayerOwnsAsset(plr,259670746) then bs:AwardBadge(plr.userId,259670746) end end)
	if size == nil then size = 30 end
	for _,k in pairs (vips) do
		if plr.Name == k[1] then
			size = k[2]
		end
	end
	if texture == nil then texture = "" end
	if color == nil then repeat color = BrickColor.Random() until color ~= BrickColor.new("Institutional white") and color ~= BrickColor.White() and color ~= BrickColor.new("Really Black") and color ~= BrickColor.Black() end
	local cell = game.ServerStorage.StartingDot:clone()
	cell.Name = plr.Name.."'s Cell"
	cell.Dot.BGui.lblName.Text = plr.Name
	changeSize(cell,size)
	cell.Dot.BGui.lblMass.Text = tostring(size)
	cell.Dot.Mesh.TextureId = "rbxassetid://"..tostring(texture)
	if texture == "" then cell.Dot.Mesh.TextureId = "" end
	cell.Dot.BrickColor = color
	cell.Size.Value = size
	spawnCell(cell,findSpawnSpot())
	for _,k in pairs (particles) do
		local pe = Instance.new("ParticleEmitter",cell.Dot)
		pe.Texture = "rbxassetid://"..tostring(k[2])
		pe.Acceleration = Vector3.new(0,1,0)
		pe.Lifetime = NumberRange.new(1,2)
		pe.Rate = 8*1.337
		pe.RotSpeed = NumberRange.new(0,360)
		pe.Speed = NumberRange.new(7,14)
		addParticleSizeChanges(cell,pe)
	end
	cell.Parent = workspace.Cells
	connectTouchEvents(plr,cell)
	local isRainbow = false
	pcall(function()
		isRainbow = game.ServerStorage.PlayerData[tostring(plr.userId)].Settings.RainbowDot.Value
	end)
	if isRainbow == true then
		coroutine.resume(coroutine.create(function()
			repeat
				pcall(function()
					cell.Dot.BrickColor = BrickColor.Random()
				end)
				wait(.337)
			until cell == nil
		end))
	end
	return cell
end

local cte = ctos:WaitForChild("ConnectTouchEvents")
cte.OnServerEvent:connect(function(plr,cell)
	connectTouchEvents(plr,cell)
end)

local cm = ctos:WaitForChild("ChangeMovement")
cm.OnServerEvent:connect(function(plr,cell,pos,speed)
	local start_ms = tick()
	if cell == nil or cell:FindFirstChild("Dot") == nil then return end
	pos = Vector3.new(pos.x,0,pos.z)
	local size,v2,vo = tonumber(cell.Dot.BGui.lblMass.Text),Vector2.new(pos.x,pos.z),Vector2.new(cell.Dot.Position.x,cell.Dot.Position.z)
	local dif = v2-vo
	local mag = dif.magnitude
	if math.abs(dif.x) < 0.001*size or math.abs(dif.y) == 0.001*size then cell.Dot.Velocity = Vector3.new(0,0,0) return end
	if speed == nil then --well with bigger sizes, .05 is really damn small :P
		speed = 28 --i used to have an equation for finding speed with magnitude, but just ended up having it full speed whereever you go
		if speed > 28 then speed = 28 end
		pcall(function() if mag <= cell.Dot.Size.x then speed = 0 end end)
		speed = speed*(math.exp(-.01*size+1)+.337)
	end
	speed = speed*1.5
	if cell:findFirstChild("Ejected") then --when you eject or split, it adds instance
		speed = speed*3
	end
	changeSpeed(cell,speed,dif/mag) --less time if i dont use unit?
	--if math.random(1000) == 1 then print("Server: ",tick()-start_ms) end
end)

local us = ctos:WaitForChild("UpdateStat")
us.OnServerEvent:connect(function(plr,n)
	if type(plr) == "string" then plr = game.Players:FindFirstChild(plr) end
	if plr == nil then return end
	if plr:findFirstChild("leaderstats") == nil then return end
	plr.leaderstats.Size.Value = n
end)

local cs = ctos:WaitForChild("ChangeSize")
cs.OnServerEvent:connect(function(plr,cell,size,inc)
	if inc then
		cell.Size.Value = cell.Size.Value + size
	else
		cell.Size.Value = size --changeSize(cell,size)
	end
end)

local combine = ctos:WaitForChild("CombineCells")
combine.OnServerEvent:connect(function(plr)
	coroutine.resume(coroutine.create(function()
		for _,k in pairs (workspace.Cells:children()) do
			if k.Name == plr.Name.."'s Cell" then
				pcall(function() k.Dot.CanCollide = false end)
				Instance.new("Folder",k).Name = "Connect"
			end
		end
	end))
end)

local done = ctos:WaitForChild("DoneCombining")
done.OnServerEvent:connect(function(plr)
	for _,k in pairs (workspace.Cells:children()) do
		if k.Name == plr.Name.."'s Cell" then
			pcall(function()
				k.Connect:Destroy()
			end)
			pcall(function()
				k.Dot.CanCollide = true
			end)
		end
	end
end)

local em = ctos:WaitForChild("EjectMass")
function em.OnServerInvoke(plr,pos)
	local cells = getCells(plr)
	if #cells == 0 then return end
	for _,k in pairs (cells) do
		coroutine.resume(coroutine.create(function()
			pcall(function()
				if tonumber(k.Dot.BGui.lblMass.Text) > 50 then
					local cell = k:clone()
					local size = math.random(14,17)
					--cell.Dot.Mesh.TextureId = ""
					changeSize(cell,size+10)
					pcall(function()
						local ang = math.atan((pos.z-cell.Dot.Position.z)/(pos.x-cell.Dot.Position.x))
						if (pos.x-cell.Dot.Position.x) < 0 then ang = ang + math.pi end --don't forget Mrs. Reynolds' rule!!!
						local size = k.Dot.Size.x
						cell.Dot.CFrame = CFrame.new(k.Dot.Position+Vector3.new(size*math.cos(ang),0,size*math.sin(ang))) * CFrame.Angles(math.pi/2,0,0)
					end)
					pcall(function()
						k.Size.Value = k.Size.Value - size--changeSize(k,-size,true)
					end)
					coroutine.resume(coroutine.create(function()
						cell.Dot:WaitForChild("BGui"):Destroy()
					end))
					cell.Name = "CellMass"
					cell.Dot.CanCollide = false
					cell.Parent = workspace.Cells
					local sp = math.ceil(tonumber(k.Dot.BGui.lblMass.Text)/2)+50
					coroutine.resume(coroutine.create(function()
						local t = 0
						repeat
							changeSpeed(cell,sp-1)
							sp = sp - 1
							t = t + wait()
						until sp <= 0 or t > 1
						changeSpeed(cell,0)
					end))
				end
			end)
		end))
	end
end

local ec = ctos:WaitForChild("EjectCell")
function ec.OnServerInvoke(plr,cells,pos)
	for i,k in pairs (cells) do
		pcall(function()
			k.Connect:Destroy()
		end)
		pcall(function()
			k.CanCollide = true
		end)
		pcall(function()
			if tonumber(k.Dot.BGui.lblMass.Text) >= 70 then
				k.Size.Value = math.floor(k.Size.Value/2)--changeSize(k,math.floor(tonumber(k.Dot.BGui.lblMass.Text)/2))
				local ang = math.atan((pos.z-k.Dot.Position.z)/(pos.x-k.Dot.Position.x))
				if (pos.x-k.Dot.Position.x) < 0 then ang = ang + math.pi end
				local extravec = k.Dot.Size.x*math.sqrt(2)*Vector3.new(math.cos(ang),0,math.sin(ang))
				local cell = k:clone()
				cell.Dot.CFrame = CFrame.new(k.Dot.Position+extravec)
				connectTouchEvents(plr,cell)
				pcall(function() addParticleSizeChanges(cell,cell.Dot.ParticleEmitter) end)
				cell.Parent = workspace.Cells
				local ef = Instance.new("Folder",cell)
				ef.Name = "Ejected"
				coroutine.resume(coroutine.create(function()
					for i=1,2 do
						wait(.45)
					end
					for _,k in pairs (cell:children()) do
						if k.ClassName == "Folder" and k.Name == "Ejected" then
							k:Destroy()
						end
					end
				end))
			end
		end)
	end
end

workspace.Cells.TinyCells.ChildRemoved:connect(function(c)
	if c.ClassName == "Part" then
		DoCell(math.random(1,7) == 1)
	end
end)

for i=1,cellslimit do
	DoCell(math.random(1,7) == 1)
	if i % 50 == 0 then wait() end
end
for i=1,spikes do
	DoSpike()
	if i % 5 == 0 then wait() end
end
workspace.GameReady.Value = true
