-- VLEXUS BYPASS - interfaz visual
-- Esta versión solo crea la interfaz y alterna el estado visual del botón.
-- No incluye funciones de bypass ni envía spam de eventos al servidor.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("BYPASS VLEXUS")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "BYPASS VLEXUS"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.AnchorPoint = Vector2.new(1, 0)
panel.Position = UDim2.new(1, -24, 0, 28)
panel.Size = UDim2.new(0, 360, 0, 154)
panel.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
panel.BorderSizePixel = 0
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 18)

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(95, 95, 105)
panelStroke.Thickness = 1.5
panelStroke.Transparency = 0.15
panelStroke.Parent = panel

local bgGradient = Instance.new("UIGradient")
bgGradient.Rotation = 90
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
bgGradient.Parent = panel

local logo = Instance.new("Frame")
logo.Name = "VLogoCircle"
logo.Position = UDim2.new(0, 16, 0, 17)
logo.Size = UDim2.new(0, 64, 0, 64)
logo.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
logo.BorderSizePixel = 0
logo.Parent = panel
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(245, 245, 250)
logoStroke.Thickness = 2
logoStroke.Parent = logo

local v = Instance.new("TextLabel")
v.Name = "V"
v.BackgroundTransparency = 1
v.Size = UDim2.fromScale(1, 1)
v.Font = Enum.Font.GothamBlack
v.Text = "V"
v.TextColor3 = Color3.fromRGB(255, 255, 255)
v.TextScaled = true
v.Parent = logo

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 92, 0, 13)
title.Size = UDim2.new(1, -108, 0, 44)
title.Font = Enum.Font.GothamBlack
title.Text = "VLEXUS BYPASS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

local titleConstraint = Instance.new("UITextSizeConstraint")
titleConstraint.MinTextSize = 17
titleConstraint.MaxTextSize = 28
titleConstraint.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 94, 0, 56)
subtitle.Size = UDim2.new(1, -110, 0, 18)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "VLEXUS HUB  •  CONTROL PANEL"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 160)
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = panel

local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Position = UDim2.new(0, 16, 0, 91)
divider.Size = UDim2.new(1, -32, 0, 1)
divider.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
divider.BackgroundTransparency = 0.2
divider.BorderSizePixel = 0
divider.Parent = panel

local button = Instance.new("TextButton")
button.Name = "ActivateButton"
button.Position = UDim2.new(0, 16, 0, 105)
button.Size = UDim2.new(1, -32, 0, 36)
button.BackgroundColor3 = Color3.fromRGB(15, 65, 35)
button.BorderSizePixel = 0
button.AutoButtonColor = false
button.Font = Enum.Font.GothamBlack
button.Text = "ACTIVATE"
button.TextColor3 = Color3.fromRGB(0, 255, 100)
button.TextSize = 15
button.Parent = panel
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 9)

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = Color3.fromRGB(0, 255, 100)
buttonStroke.Thickness = 1.3
buttonStroke.Transparency = 0.15
buttonStroke.Parent = button

local enabled = false
button.Activated:Connect(function()
    enabled = not enabled
    if enabled then
        button.Text = "DESACTIVE"
        button.TextColor3 = Color3.fromRGB(255, 75, 90)
        button.BackgroundColor3 = Color3.fromRGB(65, 18, 24)
        buttonStroke.Color = Color3.fromRGB(255, 75, 90)
        logoStroke.Color = Color3.fromRGB(255, 75, 90)
    else
        button.Text = "ACTIVATE"
        button.TextColor3 = Color3.fromRGB(0, 255, 100)
        button.BackgroundColor3 = Color3.fromRGB(15, 65, 35)
        buttonStroke.Color = Color3.fromRGB(0, 255, 100)
        logoStroke.Color = Color3.fromRGB(245, 245, 250)
    end
end)

-- Ajuste sencillo para pantallas pequeñas.
local function resizeForViewport()
    local camera = workspace.CurrentCamera
    if camera and camera.ViewportSize.X < 430 then
        panel.Size = UDim2.new(0, math.min(360, camera.ViewportSize.X - 24), 0, 154)
        panel.Position = UDim2.new(1, -12, 0, 18)
    else
        panel.Size = UDim2.new(0, 360, 0, 154)
        panel.Position = UDim2.new(1, -24, 0, 28)
    end
end

resizeForViewport()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resizeForViewport)
end

return gui