function findPlr(plrname)
	return game.Players:FindFirstChild(plrname)
end

game.Players.PlayerAdded:connect(function(p)
	p.CharacterAdded:connect(function(c)
		c:WaitForChild("Humanoid").Died:connect(function()
			if c.Humanoid:findFirstChild("creator") == nil then return end
			if findPlr((type(c.Humanoid.creator.Value)=="string" and c.Humanoid.creator.Value) or c.Humanoid.creator.Value.Name) == nil then return end
			local killer = findPlr((type(c.Humanoid.creator.Value)=="string" and c.Humanoid.creator.Value) or c.Humanoid.creator.Value.Name)
			--add kills here
		end)
	end)
end)
