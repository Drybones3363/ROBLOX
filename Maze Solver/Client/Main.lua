--repeat wait() until game.Players.LocalPlayer
--game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Maze = require(script.MazeClass)

local max_boxes = 64

local maze = Maze.new()
local abssize = script.Parent.ScreenGui.Frame.Maze.AbsoluteSize
local abspos = script.Parent.ScreenGui.Frame.Maze.AbsolutePosition
local inc = script.Parent.ScreenGui.Frame.Maze.BorderSizePixel
local c = math.ceil(script.Parent.ScreenGui.Frame.Maze.AbsoluteSize.X/inc)
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

local boxes = {}

function inMazeArea()
	local xfact = mouse.X - script.Parent.ScreenGui.Frame.Maze.AbsolutePosition.X
	local yfact = mouse.Y - script.Parent.ScreenGui.Frame.Maze.AbsolutePosition.Y
	local lblsize = script.Parent.ScreenGui.Frame.Maze.lblStart.AbsoluteSize
	local lblsizeend = script.Parent.ScreenGui.Frame.Maze.lblEnd.AbsoluteSize
	if (xfact > 0 and xfact < lblsize.X and yfact > 0 and yfact < lblsize.Y) then
		return nil
	end
	if (xfact > abssize.X - lblsizeend.X and xfact < abssize.X and yfact > abssize.Y - lblsizeend.Y and yfact < abssize.Y) then
		return nil
	end
	if xfact > 0 and xfact < abssize.X and yfact > 0 and yfact < abssize.Y then
		return true
	end
end

function getIndexFromPixels(x,y)
	x = x - abspos.X
	y = y - abspos.Y
	local xnum,ynum = math.ceil(x/inc),math.ceil(y/inc)
	return c*(ynum-1)+xnum
end

local buttondown = false

mouse.Button1Down:connect(function()
	if buttondown then return end
	buttondown = true
	if inMazeArea() then
		local abspos = script.Parent.ScreenGui.Frame.Maze.AbsolutePosition
		local startpoint = Vector2.new(mouse.X - (mouse.X%inc) - (abspos.X - (abspos.X%inc)),mouse.Y - (mouse.Y%inc) - (abspos.Y - (abspos.Y%inc)))
		local new = Instance.new("Frame")
		new.Size = UDim2.new()
		new.Position = UDim2.new(0,startpoint.X,0,startpoint.Y)
		new.BackgroundColor3 = Color3.new()
		new.BorderSizePixel = 0
		new.Parent = script.Parent.ScreenGui.Frame.Maze
		local absx,absy = abspos.X,abspos.Y
		repeat
			local xsize = mouse.X - (mouse.X%inc) - (abspos.X - (abspos.X%inc)) - startpoint.X
			local ysize = mouse.Y - (mouse.Y%inc) - (abspos.Y - (abspos.Y%inc)) - startpoint.Y
			if xsize + startpoint.X > abssize.X then
				xsize = abssize.X - startpoint.X
			end
			if xsize + startpoint.X < 0 then
				xsize = -startpoint.X
			end
			if ysize + startpoint.Y > abssize.Y then
				ysize = abssize.Y - startpoint.Y
			end
			if ysize + startpoint.Y < 0 then
				ysize = -startpoint.Y
			end
			new.Size = UDim2.new(0,xsize,0,ysize)
			game["Run Service"].RenderStepped:wait()
		until not buttondown
		if math.abs(new.AbsoluteSize.X) < inc or math.abs(new.AbsoluteSize.Y) < inc then
			new:Destroy()
			return
		end
		if new.Size.X.Offset < 0 then
			new.Position = new.Position + UDim2.new(0,new.Size.X.Offset)
			new.Size = UDim2.new(0,math.abs(new.Size.X.Offset),0,new.Size.Y.Offset)
		end
		if new.Size.Y.Offset < 0 then
			new.Position = new.Position + UDim2.new(0,0,0,new.Size.Y.Offset)
			new.Size = UDim2.new(0,new.Size.X.Offset,0,math.abs(new.Size.Y.Offset))
		end
		local index = getIndexFromPixels(new.AbsolutePosition.X+inc,new.AbsolutePosition.Y+inc)
		local index2 = getIndexFromPixels(new.AbsolutePosition.X+new.AbsoluteSize.X,new.AbsolutePosition.Y+new.AbsoluteSize.Y)
		table.insert(boxes,new)
		maze:Add(index,index2)
	end
end)

mouse.Button1Up:connect(function()
	buttondown = false
end)

mouse.Button2Down:connect(function()
	for i,k in pairs (boxes) do
		if mouse.X > k.AbsolutePosition.X and mouse.X < k.AbsolutePosition.X + k.AbsoluteSize.X then
			if mouse.Y > k.AbsolutePosition.Y and mouse.Y < k.AbsolutePosition.Y + k.AbsoluteSize.Y then
				local index = getIndexFromPixels(k.AbsolutePosition.X+inc,k.AbsolutePosition.Y+inc)
				local index2 = getIndexFromPixels(k.AbsolutePosition.X+k.AbsoluteSize.X,k.AbsolutePosition.Y+k.AbsoluteSize.Y)
				maze:Remove(index,index2)
				k:Destroy()
				boxes[i] = nil
			end
		end
	end
end)

function Announce(msg)
	for i=1,msg:len() do
		script.Parent.ScreenGui.Frame.Msg.Text = msg:sub(1,i)
		game["Run Service"].RenderStepped:wait()
	end
end

script.Parent.ScreenGui.Frame.Erase.MouseButton1Click:connect(function()
	for i,k in pairs (boxes) do
		k:Destroy()
		boxes[i] = nil
	end
	maze = Maze.new()
end)

script.Parent.ScreenGui.Frame.Solve.MouseButton1Click:connect(function()
	local success = maze:Solve()
	if type(success) == "string" then
		Announce(success)
	elseif type(success) == "number" then
		Announce("The computer found a path through your maze in "..tostring(success).." seconds!")
	end
end)

local msgs = {"Left Click on the Maze to add walls!","Right Click on the Maze to remove walls!"}

local i = 0
while wait(30) do
	Announce(msgs[i%#msgs+1])
	i = i + 1
end

--Q29kZWQgYnkgRnV0dXJlV2Vic2l0ZU93bmVyIQ==
