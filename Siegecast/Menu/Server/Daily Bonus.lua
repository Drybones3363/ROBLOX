repeat wait() until script.Parent.Parent.Name == "PlayerGui"

local frame = script.Parent.Frame
local plr = script.Parent.Parent.Parent
local xp = plr:WaitForChild("XP")
local lvl = _G.GetLvl(xp.Value)
local d = true

frame.Reward.CoinValue.Text = tostring(10*lvl+25)
frame.Reward.XPValue.Text = tostring(50*lvl+100)
script.Parent.Ching:Play()
script.Parent.Ching.Parent = script.Parent.Parent
frame:TweenPosition(UDim2.new(.4,0,.4,0))
frame.Collect.MouseButton1Down:connect(function()
	if d and plr:findFirstChild("Credits") and plr:findFirstChild("XP") then
		d = false
		script.Parent.Parent.Ching:Play()
		frame.Visible = false
		plr.Credits.Value = plr.Credits.Value + 10*lvl+25
		plr.XP.Value = plr.XP.Value + 50*lvl+100
		if game.ServerStorage:FindFirstChild("PlayerStats") and game.ServerStorage.PlayerStats:findFirstChild(tostring(plr.userId)) and game.ServerStorage.PlayerStats[tostring(plr.userId)]:findFirstChild("DailyBonus") then
			game.ServerStorage.PlayerStats[tostring(plr.userId)].DailyBonus.Value = os.time()+24*3600
		end
		wait(3.337)
		script.Parent.Parent.Ching:Destroy()
		script.Parent:Destroy()
	end
end)
