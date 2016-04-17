--This is for the old easter egg I made, not in game anymore

local t = {
	[[Hello! I am Adam, I see you've passed my first test! Good Job!]],
	[[To get to know me some more, I live in the capitol and I am the head programmer for the hunger games arenas]],
	[[I program everything such as muttations, disasters, special packages, and more!]],
	[[So anyway, the room ahead is extremely confidential...]],
	[[Some Crazy Old Man once lived in the capitol and kept going in this room in search of a mockingjay.]],
	[[Although, I don't quite know what a mockingjay is...]],
	[[Also, from the capitols commands, it will cost you 100 capitol cash for me to open these doors to you...]],
	[[Deal?]],
	Cancel = [[Ok, well I can't let you advance then, sorry.]],
	Not_Enough = [[You don't have enough Capitol Cash to advance, sorry I can't let you through.]],
	Pay = [[Pleasure doing business with you, I'll open the doors soon. :)]]
}


local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local n = 1

local function Advance(i)
	if n > #t then script.Parent.Visible = false return end
	if i == nil then i = n end
	local str = t[i]
	if str == nil then return end
	for e=1,str:len() do
		script.Parent.Parent.TextLabel.Text = string.sub(str,1,e)
		wait()
	end
	if str == t[8] then
		script.Parent.Parent.Pay.Visible = true
		script.Parent.Parent.Cancel.Visible = true
	else
		script.Parent.Parent.Continue.Visible = true
	end
end

mouse.Button1Down:connect(function()
	if script.Parent.Parent.Continue.Visible then
		script.Parent.Parent.Continue.Visible = false
		n = n + 1
		Advance()
	end
end)

script.Parent.Parent.Cancel.MouseButton1Click:connect(function()
	script.Parent.Parent.Pay.Visible = false
	script.Parent.Parent.Cancel.Visible = false
	Advance("Cancel")
end)

script.Parent.Parent.Pay.MouseButton1Click:connect(function()
	script.Parent.Parent.Pay.Visible = false
	script.Parent.Parent.Cancel.Visible = false
	local payed = workspace.Remotes.Function:InvokeServer("Pay SP",100)
	if payed then
		Advance("Pay")
		wait(3)
		for i=1,8 do
			coroutine.resume(coroutine.create(function()
				local wall = workspace["Hidden Place 1"]:FindFirstChild("Wall"..tostring(i))
				print(wall)
				if wall then
					for trans=0,1,.033 do
						wall.Transparency = trans
						wait()
					end
					wall:Destroy()
				end
				if i == 8 then script.Parent.Parent:Destroy() end
			end))
			wait(1)
		end
	else
		Advance("Not_Enough")
	end
end)

Advance()
