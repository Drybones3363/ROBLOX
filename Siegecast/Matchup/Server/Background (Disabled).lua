local barkcolors = {{"Brown",3},{"Reddish brown",2}} --{color,chance}
local leavecolors = {{"Earth green",2},{"Dark green",4},{"Camo",5},{"Lime green",1}} --{color,chance}
local leafs = {}

local f = Instance.new("Folder",workspace)
f.Name = "BackgroundFunctions"

local rf = Instance.new("RemoteFunction",f)
rf.Name = "MakeTrees"

function bark(model,pos,height,thickness)
	for i=1,6 do
		local p = Instance.new("Part",model)
		p.Anchored = true
		p.Locked = true
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.TopSurface = Enum.SurfaceType.Smooth
		p.Material = Enum.Material.Wood
		local t = 0
		for e=1,#barkcolors do
			t = t + barkcolors[e][2]
		end
		local r = math.random(1,t)
		local c = nil
		for e=1,#barkcolors do
			if t > barkcolors[e][2] then
				t = t - barkcolors[e][2]
			else
				c = BrickColor.new(barkcolors[e][1])
				break
			end
		end
		p.BrickColor = c
		p.Size = Vector3.new(thickness,height,thickness)
		p.CFrame = CFrame.new(pos+Vector3.new(0,height/2,0))*CFrame.Angles(0,2*math.pi/i,0)
		if i == 8 then
			p.Name = "Center"
			model.PrimaryPart = p
		end
	end
end


function leaves(model,pos,height,length)
	for i=1,7 do
		local p = Instance.new("Part",model)
		p.Anchored = true
		p.Locked = true
		p.BottomSurface = Enum.SurfaceType.Smooth
		p.TopSurface = Enum.SurfaceType.Smooth
		p.Material = Enum.Material.Grass
		local t = 0
		for e=1,#leavecolors do
			t = t + leavecolors[e][2]
		end
		local r = math.random(1,t)
		local c = nil
		for e=1,#leavecolors do
			if t > leavecolors[e][2] then
				t = t - leavecolors[e][2]
			else
				c = BrickColor.new(leavecolors[e][1])
				break
			end
		end
		p.BrickColor = c
		p.Size = Vector3.new(1,1,1) --Vector3.new(length,length,length)
		p.CFrame = CFrame.new(pos+Vector3.new(0,height,0))*CFrame.Angles(math.rad(math.random(1,360)),math.rad(math.random(1,360)),math.rad(math.random(1,360)))
		table.insert(leafs,{p,length,p.CFrame})
	end
end

function rf.OnServerInvoke()
	local m = Instance.new("Model",workspace)
	m.Name = "Background"
	local flag = true
	while wait() and flag do
		local x,z
		local r
		local i = 0
		repeat
			x,z = math.random(-300,300),math.random(-250,-46)
			r = Ray.new(Vector3.new(x,100,z),Vector3.new(0,-110,0))
			i = i + 1
			if i >= 5 then
				flag = false
			end
			print(workspace:FindPartOnRay(r))
		until workspace:FindPartOnRay(r) == workspace.BasePlate
		local base,pos = workspace:FindPartOnRay(r)
		local model = Instance.new("Model",m)
		model.Name = "Tree"
		local height = math.random(15,math.ceil(math.abs(z)/3)+3)
		local thickness = math.ceil(height/5)-- + math.random(5,10)
		local length = thickness + math.random(5,8)
		bark(model,pos,height,thickness)
		leaves(model,pos,height,length)
	end
	for i=1,#leafs do
		local tbl = leafs[i]
		tbl[1].Size = Vector3.new(tbl[2],tbl[2],tbl[2])
		tbl[1].CFrame = tbl[3]
		if i % 3 == 0 then
			wait()
		end
	end
end
