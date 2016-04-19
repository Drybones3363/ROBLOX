local plr = game.Players.LocalPlayer
local cell --for shop 3D model

_G.Ready = false

local tab = {"Music","Particles","Textures"}

local d = script.Parent:WaitForChild("Details")
d.ChildAdded:connect(function(c)
	if c.ClassName == "Folder" and c.Name == "Data" then
		pcall(function() cell:SetActive(false) end)
		local typ = c:findFirstChild("picID") == nil and "Textures" or c.picID.Value == 254700923 and "Music" or "Particles"
		d.cmdBuy.Visible = false
		d.cmdEquip.Visible = false
		local s = pcall(function()
			local val = workspace.Remotes.CtoS.GetValue:InvokeServer({typ,c.ItemName.Value})
			if val > 0 then
				if val == 2 then
					d.cmdEquip.BackgroundColor3 = Color3.new(1,0,0)
					if typ == "Music" then
						d.cmdEquip.Text = "Remove from Music List"
					else
						d.cmdEquip.Text = "Unequip"
					end
				else
					d.cmdEquip.BackgroundColor3 = Color3.new(0,1,0)
					if typ == "Music" then
						d.cmdEquip.Text = "Add to Music List"
					else
						d.cmdEquip.Text = "Equip"
					end
				end
				d.cmdEquip.Visible = true
			else
				if c.Cost.Value >= 0 then
					d.cmdBuy.Visible = true
				end
			end
		end)
		if s == false then
			d.cmdBuy.Visible = false
			d.cmdEquip.Visible = false
		end
		d.Item.Text = c:findFirstChild("ItemName") and c.ItemName.Value or "Failed To Load..."
		if c.Cost.Value >= 0 then
			d.Cost.TextColor3 = Color3.new(1,1,1)
			d.Cost.Text = "Cost: "..tostring(c.Cost.Value).." Coins"
		elseif c.Cost.Value == -1 then
			d.Cost.TextColor3 = Color3.new(.55,.55,1)
			d.Cost.Text = "Twitter Code Required"
		else
			d.Cost.TextColor3 = Color3.new(1,.3,.3)
			d.Cost.Text = "Cannot Be Bought"
		end
		d.MusicPlay.cmdPause.Visible = false
		d.MusicPlay.cmdPlay.Visible = true
		if c:findFirstChild("picID") then
			d.MusicPlay.Visible = (c.picID.Value == 254700923)
			d.Pic.Image = "rbxassetid://"..tostring(c.picID.Value)
		else
			d.Pic.Image = ""
			d.MusicPlay.Visible = false
			if cell then
				pcall(function() d.ShopCellID.Value = c.ID.Value end)--cell.Mesh.TextureId = "rbxassetid://"..tostring(c.ID.Value)
				cell:SetActive(true)
				--d.Pic.Image = "rbxassetid://"..tostring(c.ID.Value)
			end
		end
		for _,k in pairs (d:children()) do
			if k.Name ~= "MusicPlay" and k.Name ~= "cmdBuy" and k.Name ~= "cmdEquip" then
				pcall(function()
					k.Visible = true
				end)
			end
		end
	end
end)

coroutine.resume(coroutine.create(function()
	local tryaudio = script.Parent.Parent.Parent:WaitForChild("TryAudio")
	local musicplay = d:WaitForChild("MusicPlay")
	musicplay:WaitForChild("cmdPlay").MouseButton1Click:connect(function()
		musicplay.cmdPlay.Visible = false
		musicplay.cmdPause.Visible = true
		tryaudio:Pause()
		tryaudio.SoundId = "rbxassetid://"..tostring(d.Data.ID.Value)
		tryaudio:Play()
	end)
	musicplay:WaitForChild("cmdPause").MouseButton1Click:connect(function()
		musicplay.cmdPause.Visible = false
		musicplay.cmdPlay.Visible = true
		tryaudio:Pause()
	end)
end))

coroutine.resume(coroutine.create(function()
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
	for i,k in pairs (tab) do
		pcall(function()
			local f = script.Parent["Custom"..k]
			addEffects(f.cmdUnequip)
			addEffects(f.cmdEquip)
			f.cmdUnequip.MouseButton1Click:connect(function()
				coroutine.resume(coroutine.create(function()
					f.cmdUnequip.Visible = false
					wait(.777)
					f.cmdUnequip.Visible = true
				end))
				workspace.Remotes.CtoS.UnequipCustoms:InvokeServer(k)
			end)
			f.cmdEquip.MouseButton1Click:connect(function()
				local txt = f.txtID.Text
				if txt:lower() == "id here" or txt:lower() == "" or tonumber(txt) == nil or tonumber(txt) <= 0 then return end
				coroutine.resume(coroutine.create(function()
					f.cmdEquip.Visible = false
					wait(.777)
					f.cmdEquip.Visible = true
				end))
				workspace.Remotes.CtoS.EquipCustom:InvokeServer(k,txt)
			end)
		end)
	end
end))

coroutine.resume(coroutine.create(function()
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
	addEffects(script.Parent.Twitter.cmdRedeem)
	script.Parent.Twitter.cmdRedeem.MouseButton1Click:connect(function()
		local txtbox = script.Parent.Twitter.txtCode
		local txt = txtbox.Text
		if txt == "" or txt:lower() == "code" or txt:lower() == "code has expired" or txt:lower() == "invalid code" or txt:lower() == "already used" or txt:lower() == "redeemed!" then return end
		local cashedin = workspace.Remotes.CtoS.CheckTwitterCode:InvokeServer(txt)
		if cashedin == nil then
			coroutine.resume(coroutine.create(function()
				txtbox.BackgroundColor3 = Color3.new(1,0,0)
				txtbox.Text = "Invalid Code"
				for i=1,3 do
					wait(.75)
				end
				txtbox.BackgroundColor3 = Color3.new(1,1,1)
			end))
		elseif cashedin == "Expired" then
			coroutine.resume(coroutine.create(function()
				txtbox.BackgroundColor3 = Color3.new(1,0,0)
				txtbox.Text = "Code Has Expired"
				for i=1,3 do
					wait(.75)
				end
				txtbox.BackgroundColor3 = Color3.new(1,1,1)
			end))
		elseif cashedin == "Used" then
			coroutine.resume(coroutine.create(function()
				txtbox.BackgroundColor3 = Color3.new(1,0,0)
				txtbox.Text = "Already Used"
				for i=1,3 do
					wait(.75)
				end
				txtbox.BackgroundColor3 = Color3.new(1,1,1)
			end))
		elseif type(cashedin) == "table" then
			coroutine.resume(coroutine.create(function()
				txtbox.BackgroundColor3 = Color3.new(0,1,0)
				txtbox.Text = "Redeemed!"
				for i=1,3 do
					wait(.75)
				end
				txtbox.BackgroundColor3 = Color3.new(1,1,1)
			end))
			if cashedin[1] == 1 then
				workspace.Remotes.CtoS.SetCoins:FireServer(cashedin[2],true)
			else
				workspace.Remotes.CtoS.GiveItem:FireServer(cashedin[1],cashedin[2])
			end
		end
	end)
end))

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
	local deb = true
	buy.MouseButton1Click:connect(function()
		if deb then
			deb = false
			if d:findFirstChild("Data") == nil then return end
			local c = {}
			for _,k in pairs (d.Data:children()) do
				c[k.Name] = k.Value
			end
			local bought = workspace.Remotes.CtoS["Buy/Equip"]:InvokeServer(buy.Name,c)
			local typ = c.picID == nil and "Textures" or c.picID == 254700923 and "Music" or "Particles"
			if bought then
				if buy.Name == "cmdBuy" then
					coroutine.resume(coroutine.create(function()
						local s = Instance.new("Sound",script.Parent.Parent.Parent)
						s.SoundId = "rbxassetid://133001536"
						s.Volume = 1
						s.Pitch = 1.1
						s:Play()
						for i=1,3 do
							wait(.666)
						end
						s:Destroy()
					end))
					buy.Visible = false
					buy.Parent.cmdEquip.BackgroundColor3 = Color3.new(0,1,0)
					buy.Parent.cmdEquip.Text = typ == "Music" and "Add to Music List" or "Equip"
					buy.Parent.cmdEquip.Visible = true
				elseif buy.Name == "cmdEquip" then
					local equipped = buy.BackgroundColor3 == Color3.new(1,0,0) and true or false
					buy.BackgroundColor3 = equipped and Color3.new(0,1,0) or Color3.new(1,0,0)
					buy.Text = typ == "Music" and equipped and "Add to Music List" or typ ~= "Music" and equipped and "Equip" or typ == "Music" and not equipped and "Remove from Music List" or typ ~= "Music" and not equipped and "Unequip"
				end
			end
			wait(.2)
			deb = true
		end
	end)
end

local buy = d:WaitForChild("cmdBuy")
addEffects(buy)
local equip = d:WaitForChild("cmdEquip")
addEffects(equip)

local lblcoins = script.Parent:WaitForChild("lblCoins")
lblcoins.Changed:connect(function()
	local l = string.len(lblcoins.Text)
	lblcoins.CoinPic.Position = UDim2.new(-.0375*l+.8375,0,-.25,0)
end)

for _,k in pairs (tab) do
	coroutine.resume(coroutine.create(function()
		local b = script.Parent:WaitForChild("cmd"..k)
		b.MouseButton1Click:connect(function()
			for _,e in pairs (tab) do
				if e ~= k then
					pcall(function()
						script.Parent[e.."Frame"].Visible = false
					end)
					pcall(function()
						script.Parent["cmd"..e].Style = Enum.ButtonStyle.RobloxRoundDropdownButton
					end)
					pcall(function()
						script.Parent["Custom"..e].Visible = false
					end)
				else
					pcall(function()
						script.Parent[e.."Frame"].Visible = true
					end)
					pcall(function()
						script.Parent["cmd"..e].Style = Enum.ButtonStyle.RobloxRoundDefaultButton
					end)
					pcall(function()
						if workspace.Remotes.CtoS.HasCustomGamepass:InvokeServer(e) then
							script.Parent["Custom"..e].Visible = true
						end
					end)
				end
			end
		end)
	end))
end

pcall(function()
	if workspace.Remotes.CtoS.HasCustomGamepass:InvokeServer("Textures") then
		script.Parent["CustomTextures"].Visible = true
	end
end)

local textures,music,particles
textures,music,particles,tbl = workspace.Remotes.CtoS.GetShopData:InvokeServer(true)
while (textures == nil or music == nil or particles == nil) do
	wait(math.random(7,10))
	pcall(function() textures,music,particles = workspace.Remotes.CtoS.GetShopData:InvokeServer() end)
	--print(textures,music,particles)
end

if textures and music and particles then
	print(#textures,#music,#particles)
	if #textures > 0 then
		local tfactor = math.ceil(#textures/25) - 1
		for i,k in pairs (textures) do
			script.Parent.TexturesFrame.CanvasSize = UDim2.new(0,0,tfactor,0)
			local ib = Instance.new("ImageButton")
			local back = Instance.new("TextLabel",ib)
			local f = Instance.new("Folder",ib)
			local i1,i2,str = Instance.new("IntValue",f),Instance.new("IntValue",f),Instance.new("StringValue",f)
			ib.Name = k[1]
			ib.AutoButtonColor = false
			ib.BackgroundTransparency = 1
			ib.Image = "rbxassetid://"..tostring(k[2])
			ib.Position = UDim2.new(.175*((i-1)%5)+.025,0,(.175*math.floor((i-1)/5)+.05)/(tfactor+1),0)
			ib.Size = UDim2.new(.15,0,.15/(tfactor+1),0)
			ib.ZIndex = 2
			back.BackgroundTransparency = .75
			back.BackgroundColor3 = Color3.new(0,0,0)
			back.BorderSizePixel = 0
			back.Size = UDim2.new(1,0,1,0)
			back.Visible = false
			back.Text = ""
			f.Name = "Data"
			i1.Name = "Cost"
			i1.Value = k[3]
			i2.Name = "ID"
			i2.Value = k[2]
			str.Name = "ItemName"
			str.Value = k[1]
			ib.MouseEnter:connect(function()
				back.Visible = true
			end)
			ib.MouseLeave:connect(function()
				back.Visible = false
				back.Transparency = .75
			end)
			ib.MouseButton1Down:connect(function()
				back.Transparency = .5
			end)
			ib.MouseButton1Up:connect(function()
				back.Transparency = .75
			end)
			ib.MouseButton1Click:connect(function()
				for _,k in pairs (d:children()) do
					if k.ClassName == "Folder" and k.Name == "Data" then
						k:Destroy()
					end
				end
				f:clone().Parent = d
			end)
			ib.Parent = script.Parent.TexturesFrame
		end
	end
	if #music > 0 then
		local mfactor = math.ceil(#music/25) - 1
		for i,k in pairs (music) do
			script.Parent.MusicFrame.CanvasSize = UDim2.new(0,0,mfactor,0)
			local ib = Instance.new("ImageButton")
			local lbl = Instance.new("TextLabel",ib)
			local back = Instance.new("TextLabel",ib)
			local f = Instance.new("Folder",ib)
			local i1,i2,i3,str = Instance.new("IntValue",f),Instance.new("IntValue",f),Instance.new("IntValue",f),Instance.new("StringValue",f)
			ib.Name = "Audio"..tostring(i)
			ib.AutoButtonColor = false
			ib.BackgroundTransparency = 1
			ib.Image = "rbxassetid://254700923"
			ib.Position = UDim2.new(.175*((i-1)%5)+.025,0,(.175*math.floor((i-1)/5)+.05)/(mfactor+1),0)
			ib.Size = UDim2.new(.15,0,.15/(mfactor+1),0)
			ib.ZIndex = 2
			lbl.BackgroundTransparency = 1
			lbl.Size = UDim2.new(1,0,1,0)
			lbl.Font = Enum.Font.SourceSansBold
			lbl.FontSize = Enum.FontSize.Size14
			lbl.Text = tostring(i)
			lbl.TextColor3 = Color3.new(1,1,1)
			lbl.TextStrokeTransparency = 0
			lbl.TextXAlignment = Enum.TextXAlignment.Right
			lbl.TextYAlignment = Enum.TextYAlignment.Bottom
			lbl.ZIndex = 3
			back.BackgroundTransparency = .75
			back.BackgroundColor3 = Color3.new(0,0,0)
			back.BorderSizePixel = 0
			back.Size = UDim2.new(1,0,1,0)
			back.Visible = false
			back.Text = ""
			f.Name = "Data"
			i1.Name = "Cost"
			i1.Value = k[3]
			i2.Name = "ID"
			i2.Value = k[2]
			i3.Name = "picID"
			i3.Value = 254700923 --audio pic
			str.Name = "ItemName"
			str.Value = k[1]
			ib.MouseEnter:connect(function()
				back.Visible = true
			end)
			ib.MouseLeave:connect(function()
				back.Visible = false
				back.Transparency = .75
			end)
			ib.MouseButton1Down:connect(function()
				back.Transparency = .5
			end)
			ib.MouseButton1Up:connect(function()
				back.Transparency = .75
			end)
			ib.MouseButton1Click:connect(function()
				for _,k in pairs (d:children()) do
					if k.ClassName == "Folder" and k.Name == "Data" then
						k:Destroy()
					end
				end
				f:clone().Parent = d
			end)
			ib.Parent = script.Parent.MusicFrame
		end
	end
	if #particles > 0 then
		local pfactor = math.ceil(#particles/25) - 1
		for i,k in pairs (particles) do
			script.Parent.ParticlesFrame.CanvasSize = UDim2.new(0,0,pfactor,0)
			local ib = Instance.new("ImageButton")
			local back = Instance.new("TextLabel",ib)
			local f = Instance.new("Folder",ib)
			local i1,i2,i3,str = Instance.new("IntValue",f),Instance.new("IntValue",f),Instance.new("IntValue",f),Instance.new("StringValue",f)
			ib.Name = "Particle"..tostring(i)
			ib.AutoButtonColor = false
			ib.BackgroundTransparency = 1
			ib.Image = "rbxassetid://"..tostring(k[2])
			ib.Position = UDim2.new(.175*((i-1)%5)+.025,0,(.175*math.floor((i-1)/5)+.05)/(pfactor+1),0)
			ib.Size = UDim2.new(.15,0,.15/(pfactor+1),0)
			ib.ZIndex = 2
			back.BackgroundTransparency = .75
			back.BackgroundColor3 = Color3.new(0,0,0)
			back.BorderSizePixel = 0
			back.Size = UDim2.new(1,0,1,0)
			back.Visible = false
			back.Text = ""
			f.Name = "Data"
			i1.Name = "Cost"
			i1.Value = k[3]
			i2.Name = "ID"
			i2.Value = k[2]
			i3.Name = "picID"
			i3.Value = k[2] --for not show shopcell
			str.Name = "ItemName"
			str.Value = k[1]			
			ib.MouseEnter:connect(function()
				back.Visible = true
			end)
			ib.MouseLeave:connect(function()
				back.Visible = false
				back.Transparency = .75
			end)
			ib.MouseButton1Down:connect(function()
				back.Transparency = .5
			end)
			ib.MouseButton1Up:connect(function()
				back.Transparency = .75
			end)
			ib.MouseButton1Click:connect(function()
				for _,k in pairs (d:children()) do
					if k.ClassName == "Folder" and k.Name == "Data" then
						k:Destroy()
					end
				end
				f:clone().Parent = d
			end)
			ib.Parent = script.Parent.ParticlesFrame
		end
	end
end

_G.Ready = true

-- Get 3D Cell in Shop Ready --
local module = require(script.Module3D)
cell = module:Attach3D(script.Parent.Details.Cell,workspace.Remotes.CtoS.GetShopCell:InvokeServer())
cell:SetCFrame(CFrame.Angles(math.pi/2,math.pi/2,0))
