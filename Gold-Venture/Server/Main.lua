local Animations = {
	Down = Instance.new("Animation")
	Swing = Instance.new("Animation")
}
Animations.Down.AnimationID = ""
Animations.Swing.AnimationID = ""

local function Swing(plr,handle,pos)
	local offset = handle.Position-pos
	if handle.Position.Y - pos.Y > 3 then
		plr.Character.Humanoid:PlayAnimation(Animations.Down)
	else
		plr.Character.Humanoid:PlayAnimation(Animations.Swing)
	end
	wait(.25)
	if handle:IsDescendentOf(workspace) then
		workspace.Terrain:FillRegion(handle.Position-offset,5,air)
	end
