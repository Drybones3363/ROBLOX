function effect(b)
	b.MouseEnter:connect(function()
		b.BackgroundTransparency = .5
		b.BackgroundColor3 = Color3.new(1,1,1)
	end)
	b.MouseLeave:connect(function()
		b.BackgroundTransparency = 1
		b.BackgroundColor3 = Color3.new(1,1,1)
	end)
	b.MouseButton1Down:connect(function()
		b.BackgroundColor3 = Color3.new(0,1,.25)
	end)
	b.MouseButton1Up:connect(function()
		b.BackgroundColor3 = Color3.new(1,1,1)
	end)
end

script.Parent.ChildAdded:connect(function(c)
	if c.ClassName == "TextButton" then
		effect(c)
	end
end)


for _,k in pairs (script.Parent:children()) do
	if k.ClassName == "TextButton" then
		effect(k)
	end
end
