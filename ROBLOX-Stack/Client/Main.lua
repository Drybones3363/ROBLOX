local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

local Base_CFrame = CFrame.new(Vector3.new(-53,112,-53),Vector3.new(50, 28, 50))

local Playing,Color,Score,Stack,Last_Stack = false,{},0

local cam = workspace.CurrentCamera
cam.CameraType = Enum.CameraType.Scriptable
cam.FieldOfView = 35
cam.CFrame = Base_CFrame

local function Get_Starting_Color()
	local t = {"r","g","b"}
	local c = math.random(3)
	Color = {}
	for i=1,#t do
		Color[t[i]] = c == i and math.random(200,255) or math.random(50,225)
	end
end

Get_Starting_Color()

local Side_Colors = {["Left"]=25,["Top"]=0,["Front"]=50}

local function Setup()
	for i,k in pairs (Side_Colors) do
		pcall(function()
			workspace.Tower.Base[i.."UI"].Frame.BackgroundColor3 = Color3.new((Color.r-k)/255,(Color.g-k)/255,(Color.b-k)/255)
		end)
	end
	for i,k in pairs (Side_Colors) do
		pcall(function()
			workspace.Tower.BelowBase[i.."UI"].Frame.BackgroundColor3 = Color3.new((Color.r-60)/255,(Color.g-60)/255,(Color.b-60)/255)
		end)
	end
	Score = 0
	Last_Stack = workspace.Tower.Base
end

Setup()
print("Game Ready")

local function New_Stack()
	workspace.Walls:MoveTo(Vector3.new(-51.5, Score*5+23.5, 49.5))
	local stack = game.Lighting.Stack:Clone()
	stack.BodyPosition.Position = Vector3.new(0,Score*5+23.5)
	stack.Size = Vector3.new(Last_Stack.Size.x,5,Last_Stack.Size.z)
	local even = Score % 2 == 0
	stack.Position = Vector3.new(even and 125 or 50,Score*5+23.5,even and 50 or 125)
	stack.Velocity = Vector3.new(even and 0 or -50,0,even and -50 or 0)
	stack.Parent = workspace.Tower
	Last_Stack = Stack
	Stack = stack
end

local function Round_Position(pos)
	local t = {}
	for i,k in pairs ({"x","y","z"}) do
		local f,e = math.floor(pos[k]),0
		if pos[k] - f >= .5 then e = 1 end
		t[k] = f + e
	end
	return Vector3.new(t.x,t.y,t.z)
end

local function round(n)
	local n2 = math.floor(n)
	return n2 + ((n-n2) >= .5 and 1 or 0)
end

local function Play_Click()
	if Stack == nil or Stack.ClassName ~= "Part" then return end
	local bool = Score % 2 == 0
	local pos = round(bool and Stack.Position.x or Stack.Position.z)
	local last_pos = round(bool and Last_Stack.Position.x or Last_Stack.Position.z)
	if pos == last_pos then
		Stack.Anchored = true
		Stack.Position = pos
		local p = Instance.new("ParticleEmitter",Stack)
		p.Size = 2
		p.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		p.EmissionDirection = "Left"
		p.Lifetime = NumberSequence.new(2)
		p.Rate = 100
		p.Speed = 75
		p.VelocitySpread = 90
		p.Enabled = true
		delay(.337,function()
			p.Enabled = false
			wait(2)
			p:Destroy()
		end)
		Score = Score + 1
		New_Stack()
		cam:Interpolate(CFrame.new(Vector3.new(-53,112+5*Score,-53),Vector3.new(50,28+Score*5,50)),CFrame.new(Vector3.new(50,28+Score*5,50)),.33)	
	elseif math.abs(pos-last_pos) >= (bool and Last_Stack.Size.x or Last_Stack.Size.z) then
		--game over
		
	else
		local s2 = game.Lighting.Stack:Clone()
		local t = {}
		t["Lastx"] = round(Last_Stack.Position.x)
		t["Lastz"] = round(Last_Stack.Position.z)
		t["Currentx"] = round(Stack.Position.x)
		t["Currentz"] = round(Stack.Position.z)
		s2.Size = Vector3.new(math.abs(t.Lastx-t.Currentx),5,math.abs(t.Lastz-t.Currentz))
		local factor = pos - last_pos < 0 and -1 or 1
		s2.Position = Vector3.new(((t.Currentx + factor*Stack.Size.x)+(t.Lastx + factor*Last_Stack.Size.x))*.5,
			Score*5+23.5,((t.Currentz + factor*Stack.Size.z)+(t.Lastz + factor*Last_Stack.Size.z))*.5)
		Stack.Anchored = true
		Stack.Size = Vector3.new(Last_Stack.Size.x - math.abs(t.Lastx-t.Currentx),5,Last_Stack.Size.z - math.abs(t.Lastz-t.Currentz))
		Stack.Position = s2.Position + Vector3.new(bool and Stack.Size.x*.5 or 0,0,bool and Stack.Size.z*.5 or 0)
		s2.Parent = workspace
		s2.Velocity = Vector3.new(0,-10)
		Score = Score + 1
		New_Stack()
		cam:Interpolate(CFrame.new(Vector3.new(-53,112+5*Score,-53),Vector3.new(50,28+Score*5,50)),CFrame.new(Vector3.new(50,28+Score*5,50)),.33)
	end
end

local Play_Keys = {'w','a','s','d','1'}

local function Is_Play_Key(key)
	for i,k in pairs (Play_Keys) do
		if key == k then 
			return true
		end
	end 
	return false
end

mouse.Button1Down:connect(function()
	if Playing then
		Play_Click()
	end
end)

mouse.KeyDown:connect(function(key)
	if Is_Play_Key(key) then
		Play_Click()
	end
end)

script.Parent.MainGui.cmdPlay.MouseButton1Click:connect(function()
	script.Parent.MainGui.cmdPlay:Destroy()
	Playing = true
	New_Stack()
	--cam:Interpolate(CFrame.new(Vector3.new(-53,112+5*Score,-53),Vector3.new(50,28+Score*5,50)),CFrame.new(Vector3.new(50,28+Score*5,50)),.33)
end)
