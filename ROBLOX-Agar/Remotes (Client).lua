local plr = game.Players.LocalPlayer

workspace:WaitForChild("Remotes")
local stoc = workspace.Remotes:WaitForChild("StoC")

local cs = stoc:WaitForChild("ChangeSetting")
cs.OnClientEvent:connect(function(stat,v)
	if stat == "DarkTheme" then
		if workspace.CurrentCamera:FindFirstChild("Theme") == nil then return end
		workspace.CurrentCamera.Theme.Transparency = v == true and 0 or 1
	end
end)

local cd = stoc:WaitForChild("ChangedData")
cd.OnClientEvent:connect(function(stat,v)
	if stat:lower() == "coins" then
		local lbl = script.Parent.ScreenGui:WaitForChild("lblCoins")
		coroutine.resume(coroutine.create(function()
			local s = Instance.new("Sound",script.Parent)
			s.SoundId = "rbxassetid://131323304"
			s.Volume = 1
			s:Play()
			for i=1,3 do
				wait(.5)
			end
			s:Destroy()
		end))
		lbl.Text = "Coins: "..tostring(v)
		lbl.Position = UDim2.new(0.9,0,0.96,0)
		wait(.1)
		lbl.Position = UDim2.new(.9,0,.975,0)
		pcall(function()
			local l = script.Parent.ScreenGui.Shop.lblCoins
			l.Text = "x "..tostring(v)
		end)
	end
end)

local cr = stoc:WaitForChild("ConnectRepel")
cr.OnClientEvent:connect(function(cell)
	local c = game:GetService("RunService").RenderStepped:connect(function()
		for _,k in pairs (workspace.Cells:children()) do
			if k.Name == plr.Name.."'s Cell" and k:findFirstChild("Dot") and cell ~= k then
				local radius = (cell.Dot.Mesh.Scale.x+k.Dot.Mesh.Scale.x)
				if (k.Dot.Position-cell.Dot.Position).magnitude <= radius then
					local ang = math.atan((cell.Dot.Position.z-k.Dot.Position.z)/(cell.Dot.Position.x-k.Dot.Position.x))
					if (cell.Dot.Position.x-k.Dot.Position.x) < 0 then ang = ang + math.pi end
					workspace.Remotes.CtoS.ChangeMovement:FireServer(cell,k.Dot.Position + radius*Vector3.new(math.cos(ang),0,math.sin(ang)))
					--cell.Dot.Position = k.Dot.Position + radius*Vector3.new(math.cos(ang),0,math.sin(ang))
				end
			end
		end
	end)
	repeat wait(.337) until cell == nil or cell.Parent == nil c:disconnect()
end)
