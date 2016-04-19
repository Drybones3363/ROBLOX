math.randomseed(tick())
local raretbl,rarecolors = {50,25,math.random(12,13),5,3,1},{Color3.new(1,1,1),Color3.new(.5,.5,1),Color3.new(1,1,0),Color3.new(0,1,0),Color3.new(1,.5,0),Color3.new(1,0,0)}
local plr = game.Players.LocalPlayer
local gui = script.Parent
local frame = gui.Frame
local bagframe = frame.Bag
local data = gui:WaitForChild("Data")
local type = data:WaitForChild("WeaponType").Value
local bagname = data.BagName.Value
local m = require(gui.Module3D)
local bagpart = gui:WaitForChild("Bag")
local p = m:Attach3D(bagframe,bagpart)
p:SetActive(true)
local r = 0
coroutine.resume(coroutine.create(function()
	for _=1,math.floor(96*2) do
		p:SetCFrame(CFrame.fromEulerAnglesXYZ(0,r-math.pi/2,0))
		r = r + math.pi/96
		wait()
	end
end))
local th = tick()
local waitt = math.floor(96*2)/30
local tblfold,tbl = workspace.Remotes.ClientToServer.GetBagData:InvokeServer(type,bagname),{}
for _,k in pairs (tblfold:children()) do
	if k:findFirstChild("Rarity") then
		table.insert(tbl,{k.Name,raretbl[k.Rarity.Value]})
	end
end
local t = {}
for i=1,#tbl do
	for e=1,tbl[i][2] do
		table.insert(t,tbl[i][1])
	end
end
wait(waitt-(tick()-th))
r = 0
coroutine.resume(coroutine.create(function()
	for _=1,250 do
		p:SetCFrame(CFrame.fromEulerAnglesXYZ(0,3*math.pi/2,0)*CFrame.fromEulerAnglesXYZ((math.pi/4)*math.sin(.175*r),0,0))
		r = r + 1
		wait()
	end
	for i=1,5 do
		wait(.1)
	end
	for i=0,5 do
		bagframe.Position = UDim2.new(.25,0,.5-i*.01,0)
		wait()
	end
	for i=5,0,-1 do
		bagframe.Position = UDim2.new(.25,0,.5-i*.01,0)
		wait()
	end
end))

local function makelbl(k,rareness)
	local lbl = Instance.new("TextLabel",script.Parent)
	lbl.BackgroundTransparency = 1
	lbl.TextYAlignment = Enum.TextYAlignment.Bottom
	lbl.Text = k
	lbl.TextStrokeTransparency = 1
	lbl.TextColor3 = rarecolors[rareness]
	lbl.FontSize = Enum.FontSize.Size24
	lbl.Font = Enum.Font.ArialBold
	lbl.Size = UDim2.new(.15,0,.25,0)
	local sinval = .25*math.sin(.175*r)
	lbl.Position = UDim2.new(sinval+.25,0,.5,0)
	return lbl
end

local function makeknife(k,final)
	local weap = workspace.Remotes.ClientToServer.GetWeapon:InvokeServer(type,bagname,k)
	local lbl = makelbl(k,workspace.Remotes.ClientToServer.GetBagData:InvokeServer(type,bagname,k))
	local iiid = m:Attach3D(lbl,weap)
	iiid:SetActive(true)
	if final == nil then
		coroutine.resume(coroutine.create(function()
			local e,x = r,0
			for i=1,50 do
				local fx = math.sin(.175*e)*x*.1*.2
				print(math.sin(math.rad((360*x/25)+10)))
				lbl.Position = UDim2.new(fx+.425,0,-.5*math.sin(math.rad((180*x/25)+6))+.666,0)---math.abs(math.sin(.175*e))*(x^2)+
				x = x + .5
				wait()
			end
			iiid:End()
			lbl:Destroy()
			weap:Destroy()
		end))
	else
		coroutine.resume(coroutine.create(function()
			local e,x = r,0
			lbl.Position = UDim2.new(.425,0,.5,0)
			lbl:TweenPosition(UDim2.new(.425,0,.3,0))
			for i=1,2 do
				wait(.55)
			end
			lbl:TweenSizeAndPosition(UDim2.new(.4,0,.55,0),UDim2.new(.3,0,.25,0))
			for i=1,10 do
				wait(.5)
			end
			iiid:End()
			lbl:Destroy()
			weap:Destroy()
		end))
	end
end

for _=1,20 do
	makeknife(t[math.random(1,#t)])
	wait(.25)
end

wait(.5)
makeknife(t[math.random(1,#t)],true)

p:End()
