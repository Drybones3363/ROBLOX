local lbl = game.ServerStorage.lbl
local plr = script.Parent.Parent.Parent.Parent

function addfightertoradar(char)
	if char:findFirstChild("Torso") and char:findFirstChild("Leader") and char:findFirstChild("Humanoid") then
		local c = lbl:clone()
		if char.Leader.Value == plr.Name then
			c.BackgroundColor3 = Color3.new(0,.5,1)
		else
			c.BackgroundColor3 = Color3.new(1,0,0)
		end
		c.Position = UDim2.new(_G.XFactorToRadar(char.Torso.Position.x),0,_G.ZFactorToRadar(char.Torso.Position.z))
		c.Parent = script.Parent.Fighters
		coroutine.resume(coroutine.create(function()
			repeat wait(.2) until char.Humanoid.Health <= 0 or char == nil
			c:Destroy()
		end))
		coroutine.resume(coroutine.create(function()
		while wait() do
			if char:findFirstChild("Humanoid") and char.Humanoid.Health > 0 then
				c.Position = UDim2.new(_G.XFactorToRadar(char.Torso.Position.x),0,_G.ZFactorToRadar(char.Torso.Position.z))
			end
		end
		end))
	end
end

workspace.ChildAdded:connect(function(o)
	if o.ClassName == "Model" then
		addfightertoradar(o)
	end
end)

for num,f in pairs (workspace:children()) do
	if f.ClassName == "Model" then
		addfightertoradar(f)
	end
end
