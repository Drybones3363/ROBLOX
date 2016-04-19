game.Players.PlayerAdded:connect(function(plr)
	local pgui = plr:WaitForChild("PlayerGui")
	for i,k in pairs (game.StarterGui:GetChildren()) do
		k:Clone().Parent = pgui
	end
end)

--completely client-sided with all the work ive done so far ;)
