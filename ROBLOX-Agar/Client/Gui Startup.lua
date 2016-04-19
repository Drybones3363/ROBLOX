local f = script.Parent.Frame
local cam = workspace.CurrentCamera
local plr = game.Players.LocalPlayer
local boundaries,bound2 = Vector2.new(-740,740),Vector3.new(-745,745)

f.Visible = true
f.BackgroundTransparency = 0
workspace:WaitForChild("Remotes")
workspace.Remotes.CtoS:WaitForChild("CreateCell")
wait(.337)
for i=0,1,.025 do
	f.BackgroundTransparency = i
	wait()
end
f.BackgroundTransparency = 1

local mouse = game.Players.LocalPlayer:GetMouse()
local e = true

local function getCells()
	local tbl = {}
	for i,k in pairs (workspace.Cells:children()) do
		if k.Name == plr.Name.."'s Cell" then
			table.insert(tbl,k)
		end
	end
	return tbl
end

f.cmdShop.MouseButton1Click:connect(function()
	f:TweenPosition(UDim2.new(1,0,1,0))
	script.Parent.Shop:TweenPosition(UDim2.new(.3,0,.2,0))
end)

script.Parent.Shop.cmdBack.MouseButton1Click:connect(function()
	script.Parent.Parent.TryAudio:Pause()
	script.Parent.Shop:TweenPosition(UDim2.new(.3,0,-1,0))
	f:TweenPosition(UDim2.new(0,0,0,0))
end)

local connected_music_events = false
local musictbl = {}

local function changeSpeed(cell,speed,u)
	if cell:findFirstChild("Dot") == nil then return end
	if u == nil then
		u = (cell.Dot.Velocity).unit
	end
	local isVector3 = pcall(function() local GBED = u.z end)
	if isVector3 == false then u = Vector3.new(u.x,0,u.y) end
	cell.Dot.Velocity = speed*u
end

local function changeMovement(cell,pos,speed)
	local start_ms = tick()
	if cell == nil or cell:FindFirstChild("Dot") == nil then return end
	pos = Vector3.new(pos.x,0,pos.z)
	local size,v2,vo = tonumber(cell.Dot.BGui.lblMass.Text),Vector2.new(pos.x,pos.z),Vector2.new(cell.Dot.Position.x,cell.Dot.Position.z)
	local dif = v2-vo
	local mag = dif.magnitude
	if math.abs(dif.x) < 0.001*size or math.abs(dif.y) == 0.001*size then cell.Dot.Velocity = Vector3.new(0,0,0) return end
	if speed == nil then
		speed = 28
		if speed > 28 then speed = 28 end
		pcall(function() if mag <= cell.Dot.Size.x then speed = 0 end end)
		speed = speed*(math.exp(-.01*size+1)+.337)
	end
	speed = speed*1.5
	if cell:findFirstChild("Ejected") then
		speed = speed*3
	end
	changeSpeed(cell,speed,dif/mag)
	--if math.random(1000) == 1 then print("Client: ",tick()-start_ms) end
end

f.cmdPlay.MouseButton1Click:connect(function()
	if e and f.cmdPlay.Style ~= Enum.ButtonStyle.RobloxRoundButton then
		e = false
		for _,k in pairs (f:children()) do
			if k.ClassName == "Frame" or k.ClassName == "TextButton" then
				k.Visible = false
			end
		end
		local equipped = workspace.Remotes.CtoS.GetEquipped:InvokeServer()
		coroutine.resume(coroutine.create(function()
			pcall(function()
			musictbl = equipped["Music"] 
			if #musictbl > 0 then
				local index = 0
				local f = script.Parent:WaitForChild("MusicFrame")
				local s = script.Parent.Parent:WaitForChild("GameplayAudio")
				local function incrementSong(n)
					if n == nil then n = 1 end
					index = index + n
					if musictbl[index] == nil then
						if n < 0 then
							index = #musictbl
						else
							index = 1
						end
					end
					s:Pause()
					s.SoundId = "rbxassetid://"..tostring(musictbl[index][2])
					f.lblSong.Text = musictbl[index][1]
					s:Play()
					if f.Buttons.Play.Visible == true then
						s:Pause()
					end
				end
				f:TweenPosition(UDim2.new(.005,0,.6,0))
				f.cmdShown.Text = "Hide"
				f.cmdShown.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
				if connected_music_events == false then
					local deb = true
					local function addEffects(buy)
						buy.MouseEnter:connect(function()
							buy.BackgroundTransparency = .25
						end)
						buy.MouseLeave:connect(function()
							buy.BackgroundTransparency = .5
						end)
						buy.MouseButton1Down:connect(function()
							buy.BackgroundTransparency = 0
						end)
						buy.MouseButton1Up:connect(function()
							buy.BackgroundTransparency = .25
						end)
					end
					f.Buttons.Skip.MouseButton1Click:connect(function()
						if deb == true then
							deb = false
							coroutine.resume(coroutine.create(function()
								f.Buttons.Skip.Visible = false
								incrementSong()
								wait(.1337)
								f.Buttons.Skip.Visible = true
							end))
							wait()
							deb = true
						end
					end)
					f.Buttons.Goback.MouseButton1Click:connect(function()
						if deb == true then
							deb = false
							coroutine.resume(coroutine.create(function()
								f.Buttons.Goback.Visible = false
								incrementSong(-1)
								wait(.1337)
								f.Buttons.Goback.Visible = true
							end))
							wait()
							deb = true
						end
						
					end)
					f.Buttons.Play.MouseButton1Click:connect(function()
						if deb == true then
							deb = false
							coroutine.resume(coroutine.create(function()
								f.Buttons.Play.Visible = false
								f.Buttons.Pause.Visible = true
								s:Play()
							end))
							wait()
							deb = true
						end
					end)
					f.Buttons.Pause.MouseButton1Click:connect(function()
						if deb == true then
							deb = false
							coroutine.resume(coroutine.create(function()
								f.Buttons.Pause.Visible = false
								f.Buttons.Play.Visible = true
								s:Pause()
							end))
							wait()
							deb = true
						end
					end)
					f.cmdShown.MouseButton1Click:connect(function()
						if f.Position.X.Scale > -.05 then
							f:TweenPosition(UDim2.new(-.15,0,.6,0))
							f.cmdShown.Text = "Show"
							f.cmdShown.Style = Enum.ButtonStyle.RobloxRoundDropdownButton
						else
							f:TweenPosition(UDim2.new(.005,0,.6,0))
							f.cmdShown.Text = "Hide"
							f.cmdShown.Style = Enum.ButtonStyle.RobloxRoundDefaultButton
						end
					end)
					addEffects(f.cmdAddVolume)
					addEffects(f.cmdRemoveVolume)
					f.cmdAddVolume.MouseButton1Click:connect(function()
						if deb == true then
							deb = false
							coroutine.resume(coroutine.create(function()
								local v = s.Volume
								v = v + .05
								if v > 1 then
									v = 1
								elseif v < 0 then
									v = 0
								end
								if v == 0 then
									f.Volume.Bar.Visible = false
								else
									f.Volume.Bar.Visible = true
								end
								f.Volume.Bar.Size = UDim2.new(v,0,1,0)
								s.Volume = v
							end))
							wait()
							deb = true
						end
					end)
					f.cmdRemoveVolume.MouseButton1Click:connect(function()
						if deb == true then
							deb = false
							coroutine.resume(coroutine.create(function()
								local v = s.Volume
								v = v - .05
								if v > 1 then
									v = 1
								elseif v < 0 then
									v = 0
								end
								if v == 0 then
									f.Volume.Bar.Visible = false
								else
									f.Volume.Bar.Visible = true
								end
								f.Volume.Bar.Size = UDim2.new(v,0,1,0)
								s.Volume = v
							end))
							wait()
							deb = true
						end
					end)
					coroutine.resume(coroutine.create(function()
						while wait() and #getCells() > 0 do
							local prop = s.TimePosition/s.TimeLength
							f.Progress.Bar.Size = UDim2.new(prop,0,1,0)
							if prop >= 1-(1/30) then
								incrementSong()
							end
						end
					end))
					connected_music_events = true
				end
				incrementSong()
			end
			end) --print(pcall(function() for second end
		end))
		local text
		pcall(function() text = equipped["Textures"][1][2] end)
		local cell = workspace.Remotes.CtoS.CreateCell:InvokeServer(text,equipped["Particles"])
		local i = 0
		local function changeMain()
			local l,obj = 0
			for i,k in pairs (getCells()) do
				pcall(function()
					if tonumber(k.Dot.BGui.lblMass.Text) > l then
						l = tonumber(k.Dot.BGui.lblMass.Text)
						obj = k
					end
				end)
			end
			cell = obj
			return obj
		end
		local c = game:GetService("RunService").RenderStepped:connect(function()
			if cell == nil or cell.Parent == nil then
				changeMain()
			end
			pcall(function()
				cam:Interpolate(CFrame.new(cell.Dot.Position+Vector3.new(0,45+10*cell.Dot.Size.x/3,0))*CFrame.Angles(3*math.pi/2,0,0),cell.Dot.CFrame,.2)
			end)
			i = i + 1
			if i % 1 == 0 then
				for _,k in pairs (getCells()) do
					--if k:findFirstChild("Ejected") == nil then
						pcall(function()
							changeMovement(k,mouse.Hit.p)
						end)
						pcall(function()
							workspace.Remotes.CtoS.ChangeMovement:FireServer(k,mouse.Hit.p)
						end)
					--end
				end
			end
		end)
		local progress = 0
		local dc = workspace.Remotes.StoC:WaitForChild("DisconnectedCells")
		dc.OnClientEvent:connect(function()
			progress = 0
		end)
		coroutine.resume(coroutine.create(function()
			repeat
				while progress < 1 do
					progress = progress + math.random(3,7)/750
					if progress >= 1 then
						workspace.Remotes.CtoS.CombineCells:FireServer()
					end
					wait(.2)
				end
				wait(.337)
			until game.Players.LocalPlayer == nil
		end))
		coroutine.resume(coroutine.create(function()
			repeat
				while progress >= 1 do
					if #getCells() <= 1 then
						workspace.Remotes.CtoS.DoneCombining:FireServer()
					end
					wait(.05)
				end
				wait(.2)
			until game.Players.LocalPlayer == nil
		end))
		coroutine.resume(coroutine.create(function()
			repeat
				local t = wait(.25)
				if t > 5 then t = 5 end --just incase ;)
				for _,k in pairs (getCells()) do
					if k:findFirstChild("Dot") and k.Dot:findFirstChild("DeSize") and k.Dot:findFirstChild("BGui") then
						local v,x = k.Dot.DeSize,tonumber(k.Dot.BGui.lblMass.Text)
						if x then
							v.Value = v.Value + ((x^math.exp(1))/(1000^math.exp(1)))/(1/t)
						end
						if math.floor(v.Value) >= 1 then
							workspace.Remotes.CtoS.ChangeSize:FireServer(k,-math.floor(v.Value),true)
							v.Value = v.Value - math.floor(v.Value)
						end
					end
				end
			until game.Players.LocalPlayer == nil
		end))
		local spacedeb = true
		local c2 = mouse.KeyDown:connect(function(key)
			if key:byte() == 32 then
				if spacedeb == true and #getCells() < 5 then
					spacedeb = false
					workspace.Remotes.CtoS.EjectCell:InvokeServer(getCells(),mouse.Hit.p)
					progress = 0
					workspace.Remotes.CtoS.DoneCombining:FireServer()
					wait(.337)
					spacedeb = true
				end
			elseif key:byte() == 119 then
				workspace.Remotes.CtoS.EjectMass:InvokeServer(mouse.Hit.p)
			end
		end)
		coroutine.resume(coroutine.create(function()
			repeat wait(.4) changeMain() until cell == nil or cell.Parent == nil
			c:disconnect()
			c2:disconnect()
			e = true
			pcall(function() script.Parent.MusicFrame:TweenPosition(UDim2.new(-.2,0,.6,0)) end)
			script.Parent.Parent.GameplayAudio:Pause()
			for _,k in pairs (f:children()) do
				if k.ClassName == "Frame" or k.ClassName == "TextButton" then
					if k.Name ~= "Settings" then
						k.Visible = true
					end
				end
			end
		end))
	end
end)

local d = false

f.Image.cmdGear.MouseButton1Click:connect(function()
	d = not d
	f.Info.Position = d and UDim2.new(.4125,0,0.75,0) or UDim2.new(.4125,0,0.475,0)
	f.Settings.Visible = d and true or false
end)
