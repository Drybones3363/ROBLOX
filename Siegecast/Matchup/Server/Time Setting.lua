local times = {{"5:00:00",Color3.new(.9,.9,.9),236730554},{"6:10:00",Color3.new(.75,.75,.75),236730554},{"1:00:00",Color3.new(1,1,1),236730554},{"12:00:00",Color3.new(.7,.7,.7),236798167},{"2:00:00",Color3.new(.7,.7,.7),236798167}} --{time,ambient,soundID}
local pitch = {[236730554]=(1/2.666),[236798167]=.5}

wait(3.337)
local l = game.Lighting
local tbl = times[1]--math.random(1,#times)]
l.TimeOfDay = tbl[1]
l.Ambient = tbl[2]
repeat wait() until workspace.GamesOn.Value
print(tbl[3])
if tbl[3] ~= nil then
	for i,k in pairs (game.Players:GetPlayers()) do
		print(k)
		if k:findFirstChild("PlayerGui") then
			local c = game.ServerStorage.SoundGui:clone()
			c.Track.SoundId = "rbxassetid://"..tostring(tbl[3])
			if pitch[tbl[3]] ~= nil then
				c.Track.Pitch = pitch[tbl[3]]
			end
			c.Track:Play()
			c.Parent = k.PlayerGui
		end
	end
end
