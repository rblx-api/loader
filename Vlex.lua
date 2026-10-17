-- VLEX.VS CLEAN
-- Interfaz visual segura para Roblox Studio.
-- Coloca este archivo como LocalScript dentro de StarterPlayer > StarterPlayerScripts.
-- No descarga código, no envía datos, no accede a webhooks ni modifica mecánicas de otros jugadores.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("VLEX_VS_CLEAN")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(15, 15, 18),
    panel = Color3.fromRGB(25, 25, 30),
    panel2 = Color3.fromRGB(34, 34, 40),
    red = Color3.fromRGB(235, 45, 55),
    redDark = Color3.fromRGB(125, 20, 28),
    white = Color3.fromRGB(245, 245, 248),
    gray = Color3.fromRGB(160, 160, 170),
    green = Color3.fromRGB(80, 200, 130),
}

local gui = Instance.new("ScreenGui")
gui.Name = "VLEX_VS_CLEAN"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(520, 350)
main.Position = UDim2.new(0.5, -260, 0.5, -175)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = C.red
mainStroke.Thickness = 1.5
mainStroke.Parent = main

local top = Instance.new("Frame")
top.Name = "TopBar"
top.Size = UDim2.new(1, 0, 0, 52)
top.BackgroundColor3 = C.panel
top.BorderSizePixel = 0
top.Parent = main
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)

local cover = Instance.new("Frame")
cover.Size = UDim2.new(1, 0, 0, 12)
cover.Position = UDim2.new(0, 0, 1, -12)
cover.BackgroundColor3 = C.panel
cover.BorderSizePixel = 0
cover.Parent = top

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(16, 4)
title.Size = UDim2.new(1, -90, 0, 28)
title.Font = Enum.Font.GothamBlack
title.Text = "VLEX.VS"
title.TextColor3 = C.red
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(17, 30)
subtitle.Size = UDim2.new(1, -100, 0, 15)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "CLEAN EDITION  •  VISUAL SETTINGS"
subtitle.TextColor3 = C.gray
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(32, 30)
close.Position = UDim2.new(1, -42, 0, 11)
close.BackgroundColor3 = C.redDark
close.Text = "×"
close.TextColor3 = C.white
close.TextSize = 23
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = false
close.Parent = top
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.fromOffset(12, 64)
sidebar.Size = UDim2.fromOffset(142, 274)
sidebar.BackgroundColor3 = C.panel
sidebar.BorderSizePixel = 0
sidebar.Parent = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 9)

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(166, 64)
content.Size = UDim2.new(1, -178, 1, -76)
content.BackgroundColor3 = C.panel
content.BorderSizePixel = 0
content.Parent = main
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 9)

local navLayout = Instance.new("UIListLayout")
navLayout.Padding = UDim.new(0, 7)
navLayout.SortOrder = Enum.SortOrder.LayoutOrder
navLayout.Parent = sidebar

local navPadding = Instance.new("UIPadding")
navPadding.PaddingTop = UDim.new(0, 10)
navPadding.PaddingLeft = UDim.new(0, 9)
navPadding.PaddingRight = UDim.new(0, 9)
navPadding.Parent = sidebar

local pages = {}
local selected = nil

local function makePage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 15)
    pad.PaddingLeft = UDim.new(0, 14)
    pad.PaddingRight = UDim.new(0, 14)
    pad.Parent = page

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    pages[name] = page
    return page
end

local function addHeading(page, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 30)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = C.white
    label.TextSize = 17
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = page
    return label
end

local function addInfo(page, text, height)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, height or 42)
    label.BackgroundColor3 = C.panel2
    label.BorderSizePixel = 0
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = C.gray
    label.TextSize = 12
    label.TextWrapped = true
    label.Parent = page
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 7)
    return label
end

local function addButton(page, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 37)
    button.BackgroundColor3 = C.panel2
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamSemibold
    button.Text = text
    button.TextColor3 = C.white
    button.TextSize = 12
    button.AutoButtonColor = false
    button.Parent = page
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.12), {
            BackgroundColor3 = C.redDark
        }):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.12), {
            BackgroundColor3 = C.panel2
        }):Play()
    end)
    button.Activated:Connect(callback)
    return button
end

local function selectPage(name)
    if selected == name then return end
    selected = name
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
    for _, item in ipairs(sidebar:GetChildren()) do
        if item:IsA("TextButton") then
            item.BackgroundColor3 = item.Name == name and C.redDark or C.panel2
        end
    end
end

local function addTab(name, order)
    local button = Instance.new("TextButton")
    button.Name = name
    button.LayoutOrder = order
    button.Size = UDim2.new(1, 0, 0, 36)
    button.BackgroundColor3 = C.panel2
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamSemibold
    button.Text = "  " .. name
    button.TextColor3 = C.white
    button.TextSize = 12
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.Parent = sidebar
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)
    button.Activated:Connect(function() selectPage(name) end)
end

local home = makePage("HOME")
addHeading(home, "Welcome to VLEX.VS")
addInfo(home, "Interfaz limpia en rojo, negro y gris.", 38)
addInfo(home, "Esta edición no incluye cargadores remotos ni funciones de robo.", 52)
addInfo(home, "Úsala en tu propio proyecto de Roblox Studio.", 42)

local visual = makePage("VISUALS")
addHeading(visual, "Visual Settings")
local accentOn = false
local accentButton
accentButton = addButton(visual, "Acento rojo: OFF", function()
    accentOn = not accentOn
    accentButton.Text = "Acento rojo: " .. (accentOn and "ON" or "OFF")
    mainStroke.Color = accentOn and C.white or C.red
end)
addButton(visual, "Restablecer tema", function()
    accentOn = false
    accentButton.Text = "Acento rojo: OFF"
    mainStroke.Color = C.red
    title.TextColor3 = C.red
end)
addInfo(visual, "Estos controles solo cambian la apariencia de esta interfaz.", 48)

local settings = makePage("SETTINGS")
addHeading(settings, "Settings")
local compact = false
local compactButton
compactButton = addButton(settings, "Tamaño compacto: OFF", function()
    compact = not compact
    compactButton.Text = "Tamaño compacto: " .. (compact and "ON" or "OFF")
    local targetSize = compact and UDim2.fromOffset(440, 300) or UDim2.fromOffset(520, 350)
    TweenService:Create(main, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)
local visible = true
addButton(settings, "Ocultar / mostrar interfaz", function()
    visible = not visible
    main.Visible = visible
end)
addInfo(settings, "La configuración se mantiene durante esta sesión; no se guarda en archivos.", 50)

for i, name in ipairs({"HOME", "VISUALS", "SETTINGS"}) do
    addTab(name, i)
end
selectPage("HOME")

close.Activated:Connect(function()
    gui:Destroy()
end)

-- Arrastrar la ventana con ratón o pantalla táctil.
local dragging = false
local dragStart
local startPosition
local dragInput

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

top.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)