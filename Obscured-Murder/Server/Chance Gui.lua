local mc = game.ServerStorage:WaitForChild("MurderChance")
local plr = script.Parent.Parent.Parent.Parent

wait(.337)
repeat
	local total = 0
	local self = 0
	for i,k in pairs (mc:children()) do
		if k.ClassName == "IntValue" then
			if game.Players:FindFirstChild(k.Name) then
				total = total + k.Value
				if game.Players[k.Name] == plr then
					self = k.Value
				end
			end
		end
	end
	print(self,total)
	script.Parent.Text = "Chance of being Murderer: "..tostring(math.ceil(100*(self/total))).."%"
	wait(7.337)
until nil
