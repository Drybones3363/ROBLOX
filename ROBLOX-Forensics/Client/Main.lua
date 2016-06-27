print("Key{L00king at the c0ns0le}")
script.Parent:SetTopbarTransparency(0)

local plr = game.Players.LocalPlayer
local id = plr.userId

local Exclude = {65789033}

local categories = workspace.Remotes.Function:InvokeServer("CategoryTbl")

local tutorial_data = {
	[1] = {"ROBLOX Forensics","A game where you compete against other robloxians in many harsh probleming solving challenges."},
	[2] = {"Problems","The problems in this game are questions you won't normally have off the top of your head. You have to use your problem solving skills to find the answers. The harder the question, the better the reward. \nKeep in mind that some questions are supposed to be extremely hard. This is so we can find the best problem solvers on ROBLOX!"},
	[3] = {"Answers","The answers to these questions come in a specific format 'Key{*answer*}'. Some questions will give you the answer in this format while others will not so keep this format in mind when answering."},
	[4] = {"Categories","Each question is put under a specific category. Each category has problems that relate in some way. This means you will be doing the same kind of thing for each question in the category to solve the problem"},
	[5] = {"First Answer","Well, that's about all you need to know for this game! Here's a free answer for reading the tutorial... if you did \n Key{R3ad 1T} *Copy this down on paper! The Question is worth 100 points!*"}
}

local function Activate_Tutorial()
	script.Parent.ScreenGui.Open.Visible = false
	script.Parent.ScreenGui.Menu.Visible = false
	script.Parent.TutorialGui.Menu.Visible = true
	local loaded,i = false,1
	local function Load()
		loaded = false
		script.Parent.TutorialGui.Menu.Frame.Click.Visible = false
		for e=1,string.len(tutorial_data[i][1]) do
			script.Parent.TutorialGui.Menu.Frame.Title.Text = string.sub(tutorial_data[i][1],1,e)
			wait()
		end
		for e=1,string.len(tutorial_data[i][2]) do
			script.Parent.TutorialGui.Menu.Frame.Desc.Text = string.sub(tutorial_data[i][2],1,e)
			wait()
		end
		wait(.337)
		loaded = true
		script.Parent.TutorialGui.Menu.Frame.Click.Visible = true
	end
	local mouse = plr:GetMouse()
	local c = mouse.Button1Down:connect(function()
		if loaded == true then
			i = i + 1
			if i > #tutorial_data then
				script.Parent.TutorialGui.Menu.Visible = false
				script.Parent.ScreenGui.Open.Visible = true
			else
				Load()
			end
		end
	end)
	Load()
	repeat wait(.5) until i > #tutorial_data
end

coroutine.resume(coroutine.create(function()
	local remotes = workspace:WaitForChild("Remotes")
	remotes:WaitForChild("Event").OnClientEvent:connect(function(typ,...)
		if typ == "Tutorial" then
			Activate_Tutorial()
		end
	end)
	local funct = remotes:WaitForChild("Function")
	function funct.OnClientInvoke(typ,...)
		
		
		return
	end
end))

coroutine.resume(coroutine.create(function()
	local menu = script.Parent.ScreenGui.Menu
	local function make_Question(quest,desc,button)
		for i,k in pairs (menu:GetChildren()) do
			if k.Name == "Question" or k.Name == "Solvers" then
				k:Destroy()
			end
		end
		local frame = game.Lighting.Question:Clone()
		local questtbl = workspace.Remotes.Function:InvokeServer("Questtbl")
		local function get_solvers()
			for i=1,#questtbl do
				if questtbl[i][3] == quest then
					return questtbl[i][5]
				end
			end
		end
		local function make_Solvers()
			local solves = game.Lighting.Solvers:Clone()
			solves.Exit.MouseButton1Click:connect(function()
				solves:Destroy()
				frame.Visible = true
			end)
			local t = get_solvers()
			coroutine.resume(coroutine.create(function()
				local done,i = 0,1
				while done < 10 or t[i] == nil do
					local function Excluded()
						for _,k in pairs (Exclude) do
							if t[i] == k then
								return true
							end
						end
					end
					if not Excluded() then
						done = done + 1
						pcall(function() solves.Frame["S"..tostring(done)].Text = game.Players:GetNameFromUserIdAsync(t[i]) end)
					end
					i = i + 1
					if i%12 == 11 then wait() end
				end
			end))
			solves.Parent = menu
		end
		frame.Exit.MouseButton1Click:connect(function()
			frame:Destroy()
		end)
		frame.Solves.MouseEnter:connect(function()
			frame.Solves.TextStrokeColor3 = Color3.new(.5,.5,.5)
		end)
		frame.Solves.MouseLeave:connect(function()
			frame.Solves.TextStrokeColor3 = Color3.new(0,0,0)
		end)
		frame.Solves.MouseButton1Click:connect(function()
			frame.Visible = false
			make_Solvers()
		end)
		frame.Key.Changed:connect(function(prop)
			if prop ~= "Text" then return end
			if frame.Key.Text == "Correct" or frame.Key.Text == "Incorrect" or frame.Key.Text == "An Error Has Occurred" then return end
			frame.Key.BorderColor3 = Color3.new(0,0,1)
		end)
		frame.Submit.MouseButton1Click:connect(function()
			local txt = frame.Key.Text
			if txt:sub(1,3):lower() == "key" then
				local status = workspace.Remotes.Function:InvokeServer("Check",quest,txt)
				if status == "Correct" then
					frame.Key.BorderColor3 = Color3.new(0,1,0)
					button.Style = Enum.ButtonStyle.RobloxRoundButton
				else
					frame.Key.BorderColor3 = Color3.new(1,0,0)
				end
				frame.Key.Text = status
			else
				frame.Key.Text = "Improper Format"
			end
		end)
		local solvers = get_solvers()
		local function get_num()
			local ret = 0
			for i,k in pairs (solvers) do
				local function exclude()
					for _,y in pairs (Exclude) do
						if y == k then
							return true
						end
					end
				end
				if not exclude() then
					ret = ret + 1
				end
			end
			return ret
		end
		frame.Solves.Text = tostring(get_num()).." Solves"
		frame.Title.Text = quest
		frame.Desc.Text = desc
		frame.Parent = menu
		frame.Visible = true
	end
	local function make_Category(title,index)
		local frame = game.Lighting.Category:Clone()
		frame.Name = title
		frame.Title.Text = title
		frame.Parent = menu.Frame.Selection
		frame.Position = UDim2.new(0,0,.2*(index-1),0)
		frame.Visible = true
		frame.Left.MouseButton1Down:connect(function()
			local pos = frame.Frame.Selection.Position
			local function Legal()
				for i,k in pairs (frame.Frame.Selection:GetChildren()) do
					if -(pos.X.Scale + k.Position.X.Scale) > 0 then
						return true
					end
				end
			end
			if Legal() then
				frame.Frame.Selection:TweenPosition(pos+UDim2.new(1,0,0,0))
			end
		end)
		frame.Right.MouseButton1Down:connect(function()
			local pos = frame.Frame.Selection.Position
			local function Legal()			
				for i,k in pairs (frame.Frame.Selection:GetChildren()) do
					if k.Position.X.Scale + pos.X.Scale >= 1 then
						return true
					end
				end
			end
			if Legal() then
				frame.Frame.Selection:TweenPosition(pos+UDim2.new(-1,0,0,0))
			end
		end)
		local questtbl,tb = workspace.Remotes.Function:InvokeServer("Questtbl"),{}
		for _,k in pairs (questtbl) do
			if k[1] == title then
				if #tb == 0 then
					table.insert(tb,k)
				else
					local inserted = false
					for i=1,#tb do
						if k[2] <= tb[i][2] then
							table.insert(tb,i,k)
							inserted = true
							break
						end
					end
					if not inserted then
						tb[#tb+1] = k
					end
				end
			end
		end
		for i,k in pairs (tb) do
			local function Solved()
				for e,r in pairs (k[5]) do
					if id == r then
						return true
					end
				end
				return false
			end
			local button = game.Lighting.Button:Clone()
			button.Text = k[2]
			if Solved() == false then
				button.Style = Enum.ButtonStyle.RobloxRoundDefaultButton

			end
			button.Position = UDim2.new(.175*(i-1),0,.1,0)
			button.MouseButton1Click:connect(function()
				--if button.Style == Enum.ButtonStyle.RobloxRoundDefaultButton then
					make_Question(k[3],k[4],button)
				--end
			end)
			button.Parent = frame.Frame.Selection
		end
	end
	local open = script.Parent.ScreenGui.Open
	open.MouseButton1Click:connect(function()
		open.Visible = false
		menu.Visible = true
		workspace.Remotes.Event:FireServer("Invisible")
	end)
	local ex = menu.Exit
	ex.MouseButton1Click:connect(function()
		menu.Visible = false
		open.Visible = true
		workspace.Remotes.Event:FireServer("Visible")
	end)
	local up,down = menu.Up,menu.Down
	up.MouseButton1Click:connect(function()
		local pos = menu.Frame.Selection.Position
		local function Legal()
			for i,k in pairs (menu.Frame.Selection:GetChildren()) do
				if -(pos.Y.Scale + k.Position.Y.Scale) >= 0 then
					return true
				end
			end
		end
		if Legal() then
			menu.Frame.Selection:TweenPosition(pos+UDim2.new(0,0,1,0))
		end
	end)
	down.MouseButton1Click:connect(function()
		local pos = menu.Frame.Selection.Position
		local function Legal()
			for i,k in pairs (menu.Frame.Selection:GetChildren()) do
				if k.Position.Y.Scale + pos.Y.Scale >= 1 then
					return true
				end
			end
		end
		if Legal() then
			menu.Frame.Selection:TweenPosition(pos+UDim2.new(0,0,-1,0))
		end
	end)
	repeat wait() until workspace.Loaded.Value == true
	for i,k in pairs (categories) do
		make_Category(k,i)
	end
end))
