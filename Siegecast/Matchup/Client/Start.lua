local ins = game:GetService("InsertService")
local d = true
local names = _G.GetNames()
local ids = _G.GetIDs()

script.ChildAdded:connect(function(c)
	if c.Name == "Start" and d then
		d = false		
		local tbl = {}
		repeat
			tbl = {}
			for i,k in pairs (game.Players:GetPlayers()) do
				if game.ServerStorage:FindFirstChild(k.Name.."Data") then
					if game.ServerStorage[k.Name.."Data"].GotData.Value == true then
						table.insert(tbl,game.ServerStorage[k.Name.."Data"])
					end
				end
			end
			--[[for i,k in pairs (game.Players:GetPlayers()) do
				if game.ServerStorage:FindFirstChild(k.Name.."Data") then
					local intbl = false
					if #tbl > 0 then
						for e=1,#tbl do
							if tbl[e] == game.ServerStorage[k.Name.."Data"] then
								intbl = true
								break
							end
						end
					end
					if intbl == false and game.ServerStorage[k.Name.."Data"]:FindFirstChild("GotData") then
						if game.ServerStorage[k.Name.."Data"].GotData.Value == true then
							table.insert(tbl,game.ServerStorage[k.Name.."Data"])
						end
					end
				end
			end]]
			wait(.337)
		until #tbl == 2
		local t = {"Left","Right"}
		local m = require(game.ServerScriptService.GameFunctions)
		print(#tbl)
		wait(1)
		for i=1,#tbl do
			local data = tbl[i]
			local pname = string.sub(string.match(data.Name,"%w+D"),1,string.len(string.match(data.Name,"%w+D"))-1)
			if game.Players:FindFirstChild(pname) then
				local side = m.GetSideFromPlr(game.Players:FindFirstChild(pname))
				local num = 0
				if side then
					for e=1,#t do
						if t[e] == side then
							num = e
						end
					end
					print(num)
					if num > 0 then
						script.Parent.TeleportGui.MatchDetails["p"..tostring(num).."Pic"].Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&username="..pname
						script.Parent.TeleportGui.MatchDetails["p"..tostring(num).."Level"].Text = "Level "..tostring(data.Level.Value)
						script.Parent.TeleportGui.MatchDetails["p"..tostring(num).."Wins"].Text = tostring(data.Wins.Value)
						script.Parent.TeleportGui.MatchDetails["p"..tostring(num).."Loses"].Text = tostring(data.Loses.Value)
						script.Parent.TeleportGui.MatchDetails["p"..tostring(num).."Name"].Text = pname
					end
				end
			end
		end
		wait(3.337)
		script.Parent.TeleportGui.MatchDetails.Visible = true
		script.Parent.TeleportGui.Frame.Visible = false
		wait()
		coroutine.resume(coroutine.create(function()
			local s = Instance.new("Sound",script.Parent)
			s.SoundId = "rbxassetid://155827029"
			s.Volume = 1
			s:Play()
			for i=1,3 do
				wait(1)
			end
			s:Destroy()
		end))
		wait(3.337)
		script.Parent.TeleportGui.MatchDetails.Loading.Visible = true
		wait(math.random(7,17))
		local n = 0 repeat wait(.337) local s = game.ServerStorage n = 0 for i,k in pairs (s:children()) do if string.sub(k.Name,string.len(k.Name)-string.len("Soldiers")+1) == "Soldiers" then for e,r in pairs (k:children()) do n = n + 1 end end end until n >= 8
		Instance.new("Folder",workspace).Name = "Ready"
		wait(5)
		workspace.Ready:Destroy()
	end
end)
