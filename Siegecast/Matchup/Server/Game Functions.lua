local module = {}

local wods = game:GetService("DataStoreService"):GetOrderedDataStore("Wins")
local lods = game:GetService("DataStoreService"):GetOrderedDataStore("Loses")

module.Countdown = function()
	for i=5,1,-1 do
		for num,plr in pairs (game.Players:GetPlayers()) do
			if plr:findFirstChild("PlayerGui") then
				--plr.PlayerGui
				--countdown here
			end
		end
		wait(1)
	end
end


module.GetOnDeath = function()
	local n = 0
	local done = false
	for i,k in pairs (workspace:children()) do
		if string.match(k.Name,"H%w+") == "Human" and k.ClassName == "Model" and k:findFirstChild("Humanoid") then
			local locplr = nil
			for i,r in pairs (game.Players:GetPlayers()) do
				if string.sub(k.Name,1,string.len(r.Name)) == r.Name then
					locplr = r
					break
				end
			end
			k.Humanoid.Died:connect(function()
				local m = Instance.new("Model",game.ServerStorage)
				m.Name = "Results"
				--[[local locplr
				for e,r in pairs (game.Players:GetPlayers()) do
					if r.Name == string.sub(k.Name,1,r.Name:len()) then
						locplr = r
					end
				end]]
				local function won(plr)
					wods:IncrementAsync(plr.userId,1)
					local sv = Instance.new("StringValue",m)
					sv.Name = "Winner"
					sv.Value = plr.Name
				end
				local function loss(plr)
					lods:IncrementAsync(plr.userId,1)
					local sv = Instance.new("StringValue",m)
					sv.Name = "Loser"
					sv.Value = plr.Name
				end
				for e,r in pairs (k:children()) do
					if r.ClassName == "Part" then
						for y=-2,2,2 do --num of parts
							local p = Instance.new("Part",workspace)
							p.BrickColor = r.BrickColor
							p.Material = r.Material
							p.CanCollide = false
							p.Anchored = false
							p.Locked = true
							p.CFrame = CFrame.new(r.Position+Vector3.new(0,y,0))
							p.Velocity = Vector3.new(math.random(-100,100),math.random(-100,100),math.random(-100,100))
						end
					end
					r:Destroy()
				end
				if workspace:FindFirstChild(locplr.Name.."'s Statue") then
					for e,r in pairs (workspace[locplr.Name.."'s Statue"]:children()) do
						if r.ClassName == "Part" then
							for y=-2,2,2 do --num of parts
								local p = Instance.new("Part",workspace)
								p.BrickColor = r.BrickColor
								p.Material = r.Material
								p.CanCollide = false
								p.Anchored = false
								p.Locked = true
								p.CFrame = CFrame.new(r.Position+Vector3.new(0,y,0))
								p.Velocity = Vector3.new(math.random(-100,100),math.random(-100,100),math.random(-100,100))
							end
						end
						r:Destroy()
					end
				end
				for _,p in pairs (game.Players:GetPlayers()) do
					if p.Name ~= string.sub(k.Name,1,p.Name:len()) then
						if workspace:FindFirstChild(p.Name.."'s Human") and workspace[p.Name.."'s Human"]:findFirstChild("Humanoid") then
							if workspace[p.Name.."'s Human"].Humanoid.Health > 0 then
								won(p)
							elseif workspace[p.Name.."'s Human"].Humanoid.Health <= 0 then
								loss(p)
							else
								won(p)
							end
						end
					elseif p.Name == string.sub(k.Name,1,p.Name:len()) then
						loss(p)
					end
				end
			end)
			n = n + 1
		end
	end
	return n
end

module.GiveIncome = function(plr,income)
	if plr:findFirstChild("Gold") then
		plr.Gold.Value = plr.Gold.Value + income
	end
end

module.GetPlrFromSide = function(side)
	for i,k in pairs (workspace:children()) do
		if string.match(k.Name,"H%w+") == "Human" and k.ClassName == "Model" and k:findFirstChild("Humanoid") then
			if side == "Left" then
				if k.Torso.Position.x < 0 then
					for n,p in pairs (game.Players:GetPlayers()) do
						if string.sub(k.Name,1,string.len(p.Name)) == p.Name then
							return p
						end
					end
				end
			elseif side == "Right" then
				if k.Torso.Position.x > 0 then
					for n,p in pairs (game.Players:GetPlayers()) do
						if string.sub(k.Name,1,string.len(p.Name)) == p.Name then
							return p
						end
					end
				end
			end
		end
	end
end

module.GetSideFromPlr = function(plr)
	if workspace:FindFirstChild(plr.Name.."'s Human") then
		local x = workspace[plr.Name.."'s Human"].Torso.Position.x
		if x < 0 then
			return "Left"
		else
			return "Right"
		end
	end
end

return module
