local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

local stamina,sprinting = 100,false

coroutine.resume(coroutine.create(function()
	while wait(.4) do
		print(stamina)
	end
end))

local function Slow_Down()
	sprinting = false
	coroutine.resume(coroutine.create(function()
			repeat
				stamina = stamina + 1
				if stamina >= 100 then
					stamina = 100
					break
				end
				wait(.1)
			until sprinting == true
		end))
	workspace.RE:FireServer("Change WalkSpeed",16)
	for i=workspace.Camera.FieldOfView,70,-1 do
		workspace.Camera.FieldOfView = i
		wait()
		if sprinting == true then
			break
		end
	end
end

mouse.KeyDown:connect(function(key)
	if key:byte() == 48 and sprinting == false then
		sprinting = true
		workspace.RE:FireServer("Change WalkSpeed",27)
		coroutine.resume(coroutine.create(function()
			repeat
				stamina = stamina - 1
				if stamina <= 0 then
					stamina = 0
					Slow_Down()
				end
				wait(.1)
			until sprinting == false
		end))
		for i=workspace.Camera.FieldOfView,100 do
			workspace.Camera.FieldOfView = i
			wait()
			if sprinting == false then
				break
			end
		end
	end
end)

mouse.KeyUp:connect(function(key)
	if key:byte() == 48 and sprinting == true then
		Slow_Down()
	end
end)

local function AwardLabel(txt)
	local gui = plr.PlayerGui.ScreenGui
	local lbl = Instance.new("TextLabel")
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(.3,0,.05)
	lbl.Position = UDim2.new(.6,0,.9)
	lbl.Text = txt
	lbl.TextStrokeTransparency = 0
	lbl.TextScaled = true
	lbl.TextColor3 = Color3.new(1,1)
	lbl.Parent = gui
	for i=.9,.7,-.002 do
		lbl.Position = UDim2.new(.6,0,i)
		wait()
	end
	lbl:Destroy()
end

local function DeathLighting()
	local fogend = game.Lighting.FogEnd
	--game.Lighting.FogColor = Color3.new()
	for fog = fogend,100,-100 do
		game.Lighting.FogEnd = fog
		wait()
	end
	game.Lighting.FogEnd = 5
	wait(1)
	return 
end

local function ReturnLighting()
	game.Lighting.FogEnd = 50000
end

function workspace.RF.OnClientInvoke(typ,...)
	if typ == "DeathLighting" then
		return DeathLighting()
	end
end

workspace.RE.OnClientEvent:connect(function(typ,...)
	if typ == "AwardLabel" then
		AwardLabel(...)
	elseif typ == "ReturnLighting" then
		ReturnLighting()
	end
end)
