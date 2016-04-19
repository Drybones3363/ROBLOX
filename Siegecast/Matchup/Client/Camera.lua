wait(1)
local p = game.Players.LocalPlayer
local center = Vector3.new(0,20,0)
local cam = workspace.CurrentCamera
cam.CameraType = Enum.CameraType.Scriptable
local sub = Instance.new("Part",workspace)
sub.CanCollide = false
sub.Anchored = true
sub.Locked = true
sub.Transparency = 1
sub.CFrame = CFrame.new(Vector3.new(0,10,0))
cam.CameraSubject = sub
local cf = CFrame.new(center + Vector3.new(0,0,69)) * CFrame.Angles(0,0,0)
cam.CoordinateFrame = cf
local m = nil
repeat m = p:GetMouse() until m
local a = false
local d = false
local view = script.Parent.RadarGui.Frame.Data.CameraView

m.KeyDown:connect(function(k)
	if k == "a" then
		a = true
		local i = .1
		repeat if cf.x-i >= -150 then cf = cf - Vector3.new(i,0,0) view.Value = cf.x i = i + .05 end wait() until a == false
	elseif k == "d" then
		d = true
		local i = .1
		repeat if cf.x+i <= 150 then cf = cf + Vector3.new(i,0,0) view.Value = cf.x i = i + .05 end wait() until d == false
	end
end)
m.KeyUp:connect(function(k)
	if k == "a" then
		a = false
	elseif k == "d" then
		d = false
	end
end)
while wait() do
	cam.CoordinateFrame = cf
end
