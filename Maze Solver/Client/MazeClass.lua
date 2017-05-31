local width,height = script.Parent.Parent.ScreenGui.Frame.Maze.AbsoluteSize.X,script.Parent.Parent.ScreenGui.Frame.Maze.AbsoluteSize.Y
local inc = script.Parent.Parent.ScreenGui.Frame.Maze.BorderSizePixel
local c = math.floor(width/inc)


local Maze = {__type = "maze"};
local mt = {__index = Maze};

local function TypeOf(m)
	if type(m) == "maze" then
		return m.__type
	else
		return type(m)
	end
end


function mt.__index(m,index)
	if index == "AddWalls" then
		
	elseif Maze[index] then
		return Maze[index]
	elseif rawget(m,"proxy")[index] then
		return rawget(m,"proxy")[index];
	else
		return 1 --return wall
	end
end


function mt.__newindex(m, index, value)
	rawset(m,index,value) --error(index.." cannot be assigned to "..TypeOf(m))
end

function mt.__unm(m) --invert the maze's walls and paths
	for i,k in pairs (m) do
		m[i] = k == 1 and 0 or 1
	end
end

function mt.__tostring(m)
	local s = ''
	local i = 0
	for h=1,math.floor(height/inc) do
		s = s.."HEIGHT "..tostring(h)
		for w=1,c do
			i = i + 1
			s = s..tostring(w)..":"..tostring(m[i]).." "
		end
		s = s..'\n'
	end
	return s
end

mt.__metatable = false


function getIndex(x,y)
	return c*(y-1)+x
end

function validPoint(x,y)
	local lblsize = script.Parent.Parent.ScreenGui.Frame.Maze.lblStart.AbsoluteSize
	local lblsizeend = script.Parent.Parent.ScreenGui.Frame.Maze.lblEnd.AbsoluteSize
	if x < math.ceil(lblsize.X/inc) and y < math.ceil(lblsize.Y/inc) then
		return nil
	end
	if x > c - math.ceil(lblsize.X/inc) and y > c - math.ceil(lblsize.Y/inc) then
		return nil
	end
	return true
end

function Maze.new()
	local self = {}
	local t = {}
	for h=1,math.ceil(height/inc) do
		for w=1,math.ceil(width/inc) do
			t[getIndex(w,h)] = 0
		end
	end
	self.proxy = t
	return setmetatable(self, mt)
end

function Maze:Add(index,indexend)
	for h = math.ceil(index/c),math.ceil(indexend/c) do
		for w = (index-1)%c+1,(indexend-1)%c+1 do
			print(w,h)
			self[getIndex(w,h)] = 1
		end
	end
	return self
end

function Maze:Remove(index,indexend)
	for h = math.ceil(index/c),math.ceil(indexend/c) do
		for w = (index-1)%c+1,(indexend-1)%c+1 do
			self[getIndex(w,h)] = 0
		end
	end
	return self
end

local function Critical_Point(m,w,h)
	if m[getIndex(w,h)] == 1 then
		return
	end
	local top,bottom,left,right = m[getIndex(w,h-1)],m[getIndex(w,h+1)],m[getIndex(w-1,h)],m[getIndex(w+1,h)]
	if w-1 == 0 then
		left = 1
	end
	if w+1 == c+1 then
		right = 1
	end
	if top == 1 and bottom == 1 and left == 0 and right == 0 then --hallway
		return false
	elseif top == 0 and bottom == 0 and left == 1 and right == 1 then --hallway
		return false
	elseif top == 0 and bottom == 0 and left == 0 and right == 0 then --open_space
		return true
	elseif top+bottom+left+right == 3 then --can only go one way
		return true
	else
		return true
	end
end

local function Find_Critical_Point(m,pos,nodes)
	for i,k in pairs (nodes) do
		if pos.x == k.x and pos.y == k.y then
			return i
		end
	end
	if m[getIndex(pos.x,pos.y)] == 1 then
		return
	else
		return false
	end
end

--0 means check horizontal, 1 means check vertical

function Add_Point(pos,color)
	local abspos = script.Parent.Parent.ScreenGui.Frame.Maze.AbsolutePosition
	local new = Instance.new("Frame")
	new.Parent = script.Parent.Parent.ScreenGui.Frame.Maze
	new.Size = UDim2.new(0,inc,0,inc)
	new.Position = UDim2.new(0,inc*(pos.x-1),0,inc*(pos.y-1))
	new.BackgroundColor3 = color
	new.BackgroundTransparency = .5
	new.BorderSizePixel = 0
	delay(3,function()
		new:Destroy()
	end)
end

function Add_Path(pos,pos2,color)
	local abspos = script.Parent.Parent.ScreenGui.Frame.Maze.AbsolutePosition
	local d = "x"
	if pos.x == pos2.x then
		d = "y"
	end
	local incre = 1
	if pos[d] > pos2[d] then
		incre = -1
	end
	if pos[d] == pos2[d] then
		return
	end
	repeat
		pos[d] = pos[d] + incre
		local new = Instance.new("Frame")
		new.Parent = script.Parent.Parent.ScreenGui.Frame.Maze
		new.Size = UDim2.new(0,inc,0,inc)
		new.Position = UDim2.new(0,inc*(pos.x-1),0,inc*(pos.y-1))
		new.BackgroundColor3 = color
		new.BackgroundTransparency = .5
		new.BorderSizePixel = 0
		delay(3,function()
			new:Destroy()
		end)
	until pos[d] == pos2[d]
end

function Maze:Solve()
	local t = tick()
	local nodes = {}
	local pathdata = {}
	for h=1,math.floor(height/inc) do
		for w=1,c do
			local cp = Critical_Point(self,w,h)
			if w == 1 and h == 1 and cp == nil then
				return "The computer found the start point to be blocked!!!"
			end
			if w == c and h == math.floor(height/inc) and cp == nil then
				return "The computer found the end point to be blocked!!!"
			end
			--if cp then Add_Point({x=w,y=h},Color3.new(1,1,0)) end
			if cp then
				local t = {}
				table.insert(nodes,{x=w,y=h}) --add node to table
				
				--check left path
				local fact = w
				local iscrit
				repeat
					fact = fact - 1
					iscrit = Find_Critical_Point(self,{x=fact,y=h},nodes)
					if type(iscrit) == "number" then
						table.insert(t,iscrit)
						table.insert(pathdata[iscrit],#nodes)
					end
				until iscrit ~= false or fact == 0 --hits another critical point or hits a wall
				
				--check up path
				local fact = h
				local iscrit
				repeat
					fact = fact - 1
					iscrit = Find_Critical_Point(self,{x=w,y=fact},nodes)
					if type(iscrit) == "number" then
						table.insert(t,iscrit)
						table.insert(pathdata[iscrit],#nodes)
					end
				until iscrit ~= false or fact == 0 --hits another critical point or hits a wall
				
				pathdata[#nodes] = t
				--ptbl(t)
			end
		end
	end
	
	local solvedpath
	local paths = {{#nodes}}
	local usednodes = {}
	local continue
	repeat
		local newpaths = {}
		continue = false
		for e,tbl in pairs (paths) do
			local index = tbl[#tbl]
			for i,k in pairs (pathdata[index]) do
				if not usednodes[tostring(k)] then
					local newt = (function()
						local ret = {}
						for q,w in pairs (tbl) do
							ret[q] = w
						end
						return ret
					end)()
					table.insert(newt,k)
					if k == 1 then
						solvedpath = newt
					end
					table.insert(newpaths,newt)
					usednodes[tostring(k)] = true
					continue = true
				end
			end
		end
		paths = newpaths
	until continue == false or solvedpath
	if solvedpath then
		for i=1,#solvedpath-1 do
			Add_Path(nodes[solvedpath[i] ],nodes[solvedpath[i+1] ],Color3.new(1,0,0))
		end
		return tick()-t
	else
		return "The computer found your maze unsolvable!"
	end
end


return Maze

--Q29kZWQgYnkgRnV0dXJlV2Vic2l0ZU93bmVyIQ==
