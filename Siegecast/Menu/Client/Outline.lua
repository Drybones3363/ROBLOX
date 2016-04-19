out = script.Parent.Outlining

for num,b in pairs (script.Parent:GetChildren()) do
	if b.ClassName == "ImageButton" then
		b.MouseEnter:connect(function()
			out.Position = b.Position
			out.Visible = true
		end)
		b.MouseLeave:connect(function()
			out.Visible = false
		end)
	end
end
