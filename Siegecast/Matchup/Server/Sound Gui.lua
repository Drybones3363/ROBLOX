local gui = script.Parent
local frame = gui.Frame
local sound = gui.Track

--repeat wait(.25) until workspace.GamesOn.Value == true
frame.Visible = true
frame.Volume.Value = sound.Volume

local d = true

frame.OnOff.MouseButton1Click:connect(function()
	if d then
		d = false
		if frame.OnOff.Visible == true then
			frame.OnOff.Visible = false
			sound.Volume = frame.Volume.Value
		else
			frame.OnOff.Visible = true
			sound.Volume = 0
		end
		d = true
	end
end)


local d2 = true

frame.Volume.Changed:connect(function(val)
	frame.VFrame.Button.Text = tostring(val)
end)

frame.VFrame.Button.MouseButton1Down:connect(function(x)
	if d2 then
		d2 = false
		local xsize = frame.VFrame.Button.AbsoluteSize.x
		local xpos = frame.VFrame.Button.AbsolutePosition.x
		x = x - xpos
		local volume = x/xsize
		frame.Volume.Value = volume
		sound.Volume = volume
		frame.VFrame.Bar.Size = UDim2.new(volume,0,1,0)
		d2 = true
	end
end)
