repeat wait() until workspace.GamesOn.Value == true
local m = require(game.ServerScriptService.GameFunctions)
m.Countdown()
--Gameplay--
local int = Instance.new("IntValue",workspace)
int.Value = 0
int.Name = "MatchTime"
coroutine.resume(coroutine.create(function()
	while wait(1) do
		int.Value = int.Value + 1
		for num,p in pairs (game.Players:GetPlayers()) do
			if p:findFirstChild("PlayerGui") then
				local lbl = p.PlayerGui.ButtonGui.BuyFrame.Clock
				local extra = ""
				if int.Value % 60 < 10 then
					extra = "0"
				end
				lbl.Text = tostring(math.floor(int.Value/60))..":"..extra..tostring(int.Value%60)
			end
			if int.Value % 7 == 0 then
				m.GiveIncome(p,50)
			end
		end
	end
end))
print("Started Match")
m.GetOnDeath()
