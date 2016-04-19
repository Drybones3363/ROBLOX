--repeat wait(.1) until script:FindFirstChild("Ready")

local buttons = {script.Parent.Knight,script.Parent.Archer,script.Parent.Extra,script.Parent.Miner}
lockedcolor = Color3.new(125/255,125/255,125/255)
unlockedcolor = Color3.new(.9,.9,.9)
local gold = script.Parent.Parent.Parent.Parent:WaitForChild("Gold")

for i=1,#buttons do
	coroutine.resume(coroutine.create(function()
		repeat wait() until (workspace.GamesOn.Value == true)
		buttons[i].MouseEnter:connect(function()
			buttons[i].lblName.Visible = true
			if buttons[i].BackgroundColor3 == unlockedcolor and buttons[i].Recharge.Visible == false then
				buttons[i].BackgroundColor3 = Color3.new(1,1,1/2)
			end
		end)
		buttons[i].MouseLeave:connect(function()
			buttons[i].lblName.Visible = false
			if gold.Value >= buttons[i].Price.Value then
				buttons[i].BackgroundColor3 = unlockedcolor
			else
				buttons[i].BackgroundColor3 = lockedcolor
			end
		end)
		buttons[i].MouseButton1Click:connect(function()
			if gold.Value >= buttons[i].Price.Value and buttons[i].Recharge.Visible == false then
				gold.Value = gold.Value - buttons[i].Price.Value
				coroutine.resume(coroutine.create(function()
					buttons[i].Recharge.Visible = true
					local dtime = buttons[i].Recharge.RCTime.Value
					local r = 1
					repeat
						r = r - 1/30
						buttons[i].Recharge.Size = UDim2.new(1,0,r,0)
						wait(dtime/30)
					until r <= 0
					buttons[i].Recharge.Size = UDim2.new(1,0,0,0)
					buttons[i].Recharge.Visible = false
				end))
				_G.Hire(script.Parent.Parent.Parent.Parent,buttons[i].Name)
			end
		end)
	end))
	buttons[i].lblPrice.Text = tostring(buttons[i].Price.Value)
	buttons[i].Price.Changed:connect(function(val)
		if val >= 0 then
			buttons[i].lblPrice.Text = tostring(buttons[i].Price.Value)
		end
	end)
	gold.Changed:connect(function(v)
		if buttons[i].Price.Value <= v then
			buttons[i].BackgroundColor3 = unlockedcolor
		else
			buttons[i].BackgroundColor3 = lockedcolor
		end
	end)
	coroutine.resume(coroutine.create(function()
		local model = nil
		repeat
			wait(.2)
			model = game.ServerStorage:findFirstChild(script.Parent.Parent.Parent.Parent.Name.."Soldiers")
		until model
		wait(1)
		for e,k in pairs (model:children()) do
			if k:findFirstChild("Data") and k.Data:findFirstChild("Type") then
				if k.Data.Type.Value == buttons[i].Name then
					buttons[i].Image = "rbxassetid://"..tostring(k.Data.PicIDs.Value)
					buttons[i].Price.Value = k.Data.Cost.Value
					local bool = nil
					repeat
						if game.ServerStorage:FindFirstChild("GotSoldiers") then
							bool = Instance.new("BoolValue",game.ServerStorage.GotSoldiers)
							bool.Name = script.Parent.Parent.Parent.Parent.Name
							bool.Value = true
						else
							local fold = Instance.new("Folder",game.ServerStorage)
							fold.Name = "GotSoldiers"
						end
						wait()
					until bool
				end
			end
		end
	end))
end
