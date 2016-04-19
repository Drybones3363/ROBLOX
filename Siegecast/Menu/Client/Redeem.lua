local txt = script.Parent.Parent.txtCode
local plr = script.Parent.Parent.Parent.Parent.Parent
local codefolder = game.ServerStorage:WaitForChild("TwitterCodes")
local ps = game:GetService("PointsService")

function invisibilize()
	for i,k in pairs (script.Parent.Parent:children()) do
		if k.ClassName == "Frame" then
			k.Visible = false
		end
	end
end

function deactivate(code,plrid)
	local pstats = game.ServerStorage:FindFirstChild("PlayerStats")
	if pstats then
		if pstats:findFirstChild(tostring(plrid)) then
			local cfold = pstats[tostring(plrid)]:findFirstChild("Codes")
			if cfold then
				if cfold:findFirstChild(code) then
					cfold[code].Value = true
					if plrid > 0 then
						ps:AwardPoints(plrid,10)
					end
				end
			end
		end
	end
end

function ching()
	local s = Instance.new("Sound",script.Parent.Parent.Parent.Parent)
	s.SoundId = "rbxassetid://133647588"
	s.Pitch = math.random(80,110)/10
	s.Volume = 1
	s:Play()
	coroutine.resume(coroutine.create(function()
		for i=1,10 do
			wait(.337)
		end
		s:Destroy()
	end))
end

function codeerror()
	invisibilize()
	script.Parent.Parent.Error.Visible = true
	wait(5)
	invisibilize()
end

function success(type,amount,code)
	local f = script.Parent.Parent.Correct
	local pics = {} pics["Credits"] = "rbxassetid://230279984" pics["XP"] = "rbxassetid://230534685"
	f.Label.Text = "Code Contained "..tostring(amount).." "..type.."!"
	f.Reward.Pic.Image = pics[type]
	f.Reward.Amount.Text = tostring(amount)
	invisibilize()
	f.Visible = true
	ching()
	if game.ServerStorage:FindFirstChild("PlayerStats") and game.ServerStorage.PlayerStats:findFirstChild(tostring(plr.userId)) then
		if game.ServerStorage.PlayerStats[tostring(plr.userId)]:findFirstChild(type) and plr:findFirstChild(type) then
			local val = game.ServerStorage.PlayerStats[tostring(plr.userId)][type]
			val.Value = val.Value + amount
			plr[type].Value = plr[type].Value + amount
			deactivate(code,plr.userId)
		end
	end
	wait(5)
	invisibilize()
end

function incorrect()
	invisibilize()
	script.Parent.Parent.Incorrect.Visible = true
	wait(5)
	invisibilize()
end

function inactive()
	invisibilize()
	script.Parent.Parent.Inactive.Visible = true
	wait(5)
	invisibilize()
end

local d = true

script.Parent.MouseButton1Click:connect(function()
	if d == true then
		d = false
		local code = txt.Text
		if not(code == "" or code == "Code Here") then
			txt.Text = "Code Here"
			local pfold = game.ServerStorage:FindFirstChild("PlayerStats")
			if pfold == nil then
				codeerror()
			else
				local plrfold = pfold:findFirstChild(tostring(plr.userId))
				if plrfold == nil then
					codeerror()
				else
					local cfold = plrfold:findFirstChild("Codes")
					if cfold == nil then
						codeerror()
					else
						local bool = cfold:findFirstChild(code)
						if bool == nil then
							incorrect()
						else
							if bool.Value == true then
								inactive()
							else
								if game.ServerStorage:FindFirstChild("TwitterCodes") then
									for _,k in pairs (game.ServerStorage.TwitterCodes:children()) do
										if k.ClassName == "StringValue" and code == k.Value and k:children()[1] then
											success(k:children()[1].Name,k:children()[1].Value,code)
										end
									end
								end
							end
						end
					end
				end
			end
		end
		wait()
		d = true
	end
end)
