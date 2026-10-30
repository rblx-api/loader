-- VLEXUS BYPASS - interfaz visual compacta
-- Interfaz únicamente visual: no ejecuta funciones de bypass ni acciones contra el servidor.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local previous = playerGui:FindFirstChild("BYPASS VLEXUS")
if previous then previous:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "BYPASS VLEXUS"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(1, 0)
panel.Position = UDim2.new(1, -24, 0, 28)
panel.Size = UDim2.new(0, 290, 0, 96)
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.Parent = gui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)

local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(42, 42, 48)
outline.Thickness = 1
outline.Parent = panel

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
header.BorderSizePixel = 0
header.Parent = panel
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local logo = Instance.new("Frame")
logo.Name = "VLogoCircle"
logo.Position = UDim2.new(0, 14, 0, 13)
logo.Size = UDim2.new(0, 27, 0, 27)
logo.BackgroundColor3 = Color3.fromRGB(5, 5, 6)
logo.BorderSizePixel = 0
logo.Parent = header
Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(235, 235, 240)
logoStroke.Thickness = 1.4
logoStroke.Parent = logo

local v = Instance.new("TextLabel")
v.BackgroundTransparency = 1
v.Size = UDim2.fromScale(1, 1)
v.Font = Enum.Font.GothamBlack
v.Text = "V"
v.TextColor3 = Color3.fromRGB(255, 255, 255)
v.TextSize = 19
v.Parent = logo

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 50, 0, 8)
title.Size = UDim2.new(1, -100, 0, 22)
title.Font = Enum.Font.GothamBlack
title.Text = "VLEXUS BYPASS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 51, 0, 29)
subtitle.Size = UDim2.new(1, -100, 0, 14)
subtitle.Font = Enum.Font.GothamMedium
subtitle.Text = "SPEED BYPASS"
subtitle.TextColor3 = Color3.fromRGB(145, 145, 155)
subtitle.TextSize = 8
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

local plus = Instance.new("TextButton")
plus.Name = "MenuToggle"
plus.Position = UDim2.new(1, -31, 0, 13)
plus.Size = UDim2.new(0, 22, 0, 22)
plus.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
plus.BorderSizePixel = 0
plus.AutoButtonColor = true
plus.Font = Enum.Font.GothamBold
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(255, 255, 255)
plus.TextSize = 16
plus.Parent = header
Instance.new("UICorner", plus).CornerRadius = UDim.new(1, 0)

local activate = Instance.new("TextButton")
activate.Name = "ActivateButton"
activate.Position = UDim2.new(0, 14, 0, 62)
activate.Size = UDim2.new(1, -28, 0, 26)
activate.BackgroundColor3 = Color3.fromRGB(15, 55, 32)
activate.BorderSizePixel = 0
activate.AutoButtonColor = false
activate.Font = Enum.Font.GothamBlack
activate.Text = "ACTIVATE"
activate.TextColor3 = Color3.fromRGB(0, 255, 100)
activate.TextSize = 12
activate.Parent = panel
Instance.new("UICorner", activate).CornerRadius = UDim.new(0, 7)

local activateStroke = Instance.new("UIStroke")
activateStroke.Color = Color3.fromRGB(0, 255, 100)
activateStroke.Thickness = 1
activateStroke.Parent = activate

-- Menú desplegable compacto con los controles visuales de la interfaz anterior.
local menu = Instance.new("Frame")
menu.Name = "PreviousMenu"
menu.Position = UDim2.new(0, 0, 0, 96)
menu.Size = UDim2.new(1, 0, 0, 184)
menu.BackgroundTransparency = 1
menu.Visible = false
menu.Parent = panel

local function addRow(y, labelText, valueText)
    local row = Instance.new("Frame")
    row.Position = UDim2.new(0, 12, 0, y)
    row.Size = UDim2.new(1, -24, 0, 26)
    row.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    row.BorderSizePixel = 0
    row.Parent = menu
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 7)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(235, 235, 240)
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local value = Instance.new("TextLabel")
    value.BackgroundTransparency = 1
    value.Position = UDim2.new(0.55, 0, 0, 0)
    value.Size = UDim2.new(0.4, -5, 1, 0)
    value.Font = Enum.Font.GothamBold
    value.Text = valueText
    value.TextColor3 = Color3.fromRGB(180, 180, 190)
    value.TextSize = 10
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Parent = row
    return value
end

local autoValue = addRow(6, "Auto Brainrot", "OFF")
local modeValue = addRow(36, "Modo", "Móvil")
local powerValue = addRow(66, "Power", "65000")
local keyValue = addRow(96, "Keybind", "V")
local lockValue = addRow(126, "Lock UI", "UNLOCK")

local autoOn = false
autoValue.Parent.Active = true
local function makeRowClickable(valueLabel, callback)
    local row = valueLabel.Parent
    local click = Instance.new("TextButton")
    click.BackgroundTransparency = 1
    click.Text = ""
    click.Size = UDim2.fromScale(1, 1)
    click.Parent = row
    click.Activated:Connect(callback)
end

makeRowClickable(autoValue, function()
    autoOn = not autoOn
    autoValue.Text = autoOn and "ON" or "OFF"
    autoValue.TextColor3 = autoOn and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(180, 180, 190)
end)

local mobile = true
makeRowClickable(modeValue, function()
    mobile = not mobile
    modeValue.Text = mobile and "Móvil" or "PC"
end)

local locked = false
makeRowClickable(lockValue, function()
    locked = not locked
    lockValue.Text = locked and "LOCKED" or "UNLOCK"
end)

local expanded = false
plus.Activated:Connect(function()
    expanded = not expanded
    plus.Text = expanded and "−" or "+"
    menu.Visible = expanded
    panel.Size = expanded and UDim2.new(0, 290, 0, 286) or UDim2.new(0, 290, 0, 96)
end)

local enabled = false
activate.Activated:Connect(function()
    enabled = not enabled
    if enabled then
        activate.Text = "DESACTIVE"
        activate.TextColor3 = Color3.fromRGB(255, 75, 90)
        activate.BackgroundColor3 = Color3.fromRGB(60, 18, 24)
        activateStroke.Color = Color3.fromRGB(255, 75, 90)
    else
        activate.Text = "ACTIVATE"
        activate.TextColor3 = Color3.fromRGB(0, 255, 100)
        activate.BackgroundColor3 = Color3.fromRGB(15, 55, 32)
        activateStroke.Color = Color3.fromRGB(0, 255, 100)
    end
end)

-- Al abrirse, el panel mantiene un tamaño similar al de la interfaz original.
return gui