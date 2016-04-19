plr = script.Parent.Parent.Parent

function finished()
	local val = Instance.new("BoolValue")
	val.Name = "DoneIntro"
	val.Parent = script.Parent.Parent
	script.Parent:Destroy()
end

if plr:findFirstChild("DoneIntro") then
	finished()
	return
end
script.Parent.Frame.Visible = true
wait(.4)
script.Parent.Music:Play()
coroutine.resume(coroutine.create(function()
	for i=0,0.3,0.005 do
		script.Parent.Music.Volume = i
		wait()
	end
	script.Parent.Music.Volume = .3
end))
local title = script.Parent.Frame.Title
title.Visible = true
for i=6,.4,-0.05 do
	title.Size = UDim2.new(i,0,.75*i,0)
	title.Position = UDim2.new(-1*(i/2-.5),0,.1,0)
	wait()
end
wait(2)
local by = script.Parent.Frame.By
for i=-.25,.375,.0125 do
	by.Position = UDim2.new(i,0,.525,0)
	wait()
end
by.Position = UDim2.new(.375,0,.525,0)
local owner = script.Parent.Frame.Owner
owner.Visible = true
for i=.125,.65,.0125 do
	owner.Position = UDim2.new(0.3125,0,i,0)
	wait()
end
owner.Position = UDim2.new(0.3125,0,.65,0)
coroutine.resume(coroutine.create(function()
	local arch = script.Parent.Frame.Archer
	for i=1,0,-.05 do
		arch.ImageTransparency = i
		wait()
	end
	arch.ImageTransparency = 0
end))
coroutine.resume(coroutine.create(function()
	local arch = script.Parent.Frame.Knight
	for i=1,0,-.05 do
		arch.ImageTransparency = i
		wait()
	end
	arch.ImageTransparency = 0
end))
wait(5)
local start = script.Parent.Frame.Start
for i=1,0,-0.05 do
	start.ImageTransparency = i
	wait()
end
start.ImageTransparency = 0
start.Click.Disabled = false
local bool = Instance.new("BoolValue")
bool.Name = "Set"
bool.Value = true
bool.Parent = script.Parent.Parent.ChatGuis
