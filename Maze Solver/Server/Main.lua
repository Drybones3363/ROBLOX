function Add_Leaderstats(plr)
	local lead = Instance.new("Model")
	lead.Name = "leaderstats"
	lead.Parent = plr
	local int = Instance.new("IntValue")
	int.Name = "Difficulty"
	int.Value = 0
	int.Parent = lead
end

game.Players.PlayerAdded:connect(function(plr)
	plr.CharacterAdded:connect(function(char)
		--char:Destroy()
	end)
	pcall(function()
		game.PointsService:AwardPoints(plr.userId,1)
	end)
	--Add_Leaderstats(plr)
end)

for i,k in pairs (game.Players:GetPlayers()) do
	--Add_Leaderstats(k)
end

workspace.RemoteEvent.OnServerEvent:connect(function(plr,typ,...)
	
end)

function workspace.RemoteFunction.OnServerInvoke(plr,typ,...)
	
end

--Q29kZWQgYnkgRnV0dXJlV2Vic2l0ZU93bmVyIQ==


--Essentially No Server Code, All is run on Client's Side
