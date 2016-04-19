local pgui = script.Parent

local buttons = pgui:WaitForChild("MainGui"):WaitForChild("LevelFrame"):WaitForChild("Buttons")

print"Data Activated"

buttons:WaitForChild("cmdShop").MouseButton1Click:connect(function()
	if workspace:FindFirstChild("Remotes") == nil then return end
	if workspace.Remotes.ClientToServer:FindFirstChild("GetData") == nil then return end
	local data = workspace.Remotes.ClientToServer.GetData:InvokeServer({"Knives","Guns"})
	if data == nil then data = {} end
	for i,k in pairs (data) do
		print(i,k)
	end
end)
