_G.PutDataIn = false
local ins = game:GetService("InsertService")
wait(1)
ins:LoadAsset(220987055):children()[1].Parent = game.ServerStorage
--[[while wait(15) do
	game.ServerStorage:FindFirstChild("Hats"):Destroy()
	ins:LoadAsset(220987055):children()[1].Parent = game.ServerStorage
	for num,it in pairs (game.ServerStorage.Hats.TableOHats:children()) do
		print(num,": ",it.Value)
	end
	print"changed"
end]]
