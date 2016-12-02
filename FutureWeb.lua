local sgui = Instance.new("ScreenGui")
sgui.Name = "FutureWeb"
local imgWeb = Instance.new("ImageLabel")
imgWeb.Image = ""
imgWeb.BackgroundTransparency = 1
imgWeb.Size = UDim2.new(0,200,0,200)
imgWeb.Position = UDim2.new(.5,-100,.5,-100)
imgWeb.Parent = sgui
local imgSpider = Instance.new("ImageLabel")
imgSpider.BackgroundTransparency = 1
imgSpider.Size = UDim2.new(0,50,0,50)
imgSpider.Position = UDim2.new(.5,25,.5,0)

coroutine.resume(coroutine.create(function()
  local deg = 0
  while wait() do
    --sprite frame++
    deg = deg + 5
    if deg > 360 then deg = deg - 360 end
    imgSpider.Position = UDim2.new(.5,25*math.cos(math.rad(deg)),.5,-25*math.sin(math.rad(deg)))
    imgSpider.Rotation = deg --+ rotation
  end
end))


imgSpider.Parent = sgui
