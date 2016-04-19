local plr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local data
local CP = game:GetService("ContentProvider")
local pics = {
	Buy_Static = "rbxassetid://260943509",
	Buy_Pressed = "rbxassetid://260943520",
	cmd100_Static = "rbxassetid://260945511",
	cmd100_Pressed = "rbxassetid://260945523",
	cmd500_Static = "rbxassetid://260945497",
	cmd500_Pressed = "rbxassetid://260945506",
	cmd1000_Static = "rbxassetid://260945484",
	cmd1000_Pressed = "rbxassetid://260945489",
	cmd2500_Static = "rbxassetid://260945475",
	cmd2500_Pressed = "rbxassetid://260945479",
}
local MS = game:GetService("MarketplaceService")
local Dev_Products = {
	cmd100 = 24414565,
	cmd500 = 24414569,
	cmd1000 = 24414570,
	cmd2500 = 24414574
}

for _,k in pairs (pics) do
	CP:Preload(k)
end

coroutine.resume(coroutine.create(function()
	local funct = workspace:WaitForChild("Remotes"):WaitForChild("CtoS"):WaitForChild("ReceiveData")
	print("Attempting to find Your Data...")
	repeat
		data = funct:InvokeServer()
	until data or game.Players.LocalPlayer == nil
	print("Found Your Data!")
end))

wait(.337)
cam.CameraType = Enum.CameraType.Scriptable
cam.CameraSubject = nil
cam.CoordinateFrame = CFrame.new(Vector3.new(0,150,0))*CFrame.Angles(3*math.pi/2,0,0)

wait(1)
local bg = Instance.new("Part")
bg.Name = "Theme"
bg.Anchored = true
bg.BrickColor = BrickColor.new("Black")
bg.Size = Vector3.new(1,1,1)
bg.CFrame = CFrame.new(Vector3.new(0,-25,0))
bg.CanCollide = false
bg.Locked = true
bg.Transparency = 1
bg.Material = Enum.Material.SmoothPlastic
bg.TopSurface = Enum.SurfaceType.Smooth
bg.BackSurface = Enum.SurfaceType.Smooth
local m = Instance.new("BlockMesh",bg)
m.Scale = Vector3.new(2048*2,1,2048*2)
bg.Parent = cam
coroutine.resume(coroutine.create(function()
	local se = workspace:WaitForChild("Remotes"):WaitForChild("CtoS"):WaitForChild("SetEvent")
	se:FireServer("DarkTheme")
end))
coroutine.resume(coroutine.create(function()
	repeat wait(.337) until data or game.Players.LocalPlayer == nil
	local settings = data.Settings
	bg.Transparency = (settings and settings.DarkTheme and settings.DarkTheme == true) and 0 or 1
	--[[settings = data:WaitForChild("Settings") --USE A REMOTE FUNCTION!!!
	settings:WaitForChild("BlackTheme").Changed:connect(function(v)
		bg.Transparency = v == true and 0 or 1
	end)]]
end))
coroutine.resume(coroutine.create(function()
	repeat wait() until _G.Ready == true
	script.Parent.ScreenGui.Frame.cmdPlay.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
end))
coroutine.resume(coroutine.create(function()
	local img = script.Parent.ScreenGui.imgBuyCoins
	img.MouseEnter:connect(function()
		img.BackgroundTransparency = .75
	end)
	img.MouseLeave:connect(function()
		img.BackgroundTransparency = 1
		img.Image = pics.Buy_Static
	end)
	img.MouseButton1Down:connect(function()
		img.Image = pics.Buy_Pressed
	end)
	img.MouseButton1Up:connect(function()
		img.Image = pics.Buy_Static
	end)
	img.MouseButton1Click:connect(function()
		script.Parent.ScreenGui.Shop:TweenPosition(UDim2.new(.3,0,-1,0))
		script.Parent.ScreenGui.Frame:TweenPosition(UDim2.new(1,0,1,0))
		script.Parent.ScreenGui.BuyMore:TweenPosition(UDim2.new(.4,0,.375,0))
	end)
	local frame = script.Parent.ScreenGui.BuyMore
	for i,k in pairs (frame:GetChildren()) do
		if pics[k.Name.."_Pressed"] and pics[k.Name.."_Static"] then
			k.MouseEnter:connect(function()
				k.BackgroundTransparency = .75
			end)
			k.MouseLeave:connect(function()
				k.BackgroundTransparency = 1
				k.Image = pics[k.Name.."_Static"]
			end)
			k.MouseButton1Down:connect(function()
				k.Image = pics[k.Name.."_Pressed"]
			end)
			k.MouseButton1Up:connect(function()
				k.Image = pics[k.Name.."_Static"]
			end)
			k.MouseButton1Click:connect(function()
				if plr.userId > 0 then
					MS:PromptProductPurchase(plr,Dev_Products[k.Name])
				end
			end)
		end
	end
	frame.cmdExit.MouseEnter:connect(function()
		frame.cmdExit.BackgroundTransparency = .25
	end)
	frame.cmdExit.MouseLeave:connect(function()
		frame.cmdExit.BackgroundTransparency = .5
	end)
	frame.cmdExit.MouseButton1Down:connect(function()
		frame.cmdExit.BackgroundTransparency = 0
	end)
	frame.cmdExit.MouseButton1Up:connect(function()
		frame.cmdExit.BackgroundTransparency = .25
	end)
	frame.cmdExit.MouseButton1Click:connect(function()
		frame:TweenPosition(UDim2.new(-.2,0,-.4,0))
		script.Parent.ScreenGui.Frame:TweenPosition(UDim2.new(0,0,0,0))
	end)
end))
