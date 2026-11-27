-- OR'S CODE SNIPER
-- Unified black / white / gray interface shell.
-- Safe integration build: original game-remote automation, executor hooks,
-- external proxy requests, embedded credentials, and anti-inspection/kick
-- behavior are intentionally not executed by this interface.
-- The original source files are not modified.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ORSCodeSniper")
if old then old:Destroy() end

local COLORS = {
    bg = Color3.fromRGB(12, 12, 14),
    panel = Color3.fromRGB(21, 21, 24),
    panel2 = Color3.fromRGB(30, 30, 34),
    line = Color3.fromRGB(65, 65, 72),
    white = Color3.fromRGB(245, 245, 247),
    gray = Color3.fromRGB(165, 165, 173),
    muted = Color3.fromRGB(105, 105, 114),
}

local gui = Instance.new("ScreenGui")
gui.Name = "ORSCodeSniper"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = parent
    return c
end

local function stroke(parent, color, transparency, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.line
    s.Transparency = transparency or 0
    s.Thickness = thickness or 1
    s.Parent = parent
    return s
end

local function tween(obj, duration, props)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(570, 390)
main.Position = UDim2.new(0.5, -285, 0.5, -195)
main.BackgroundColor3 = COLORS.bg
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 15)
stroke(main, COLORS.line, 0.12, 1.2)

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.35
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.Size = UDim2.new(1, 42, 1, 42)
shadow.Position = UDim2.fromOffset(-21, -21)
shadow.ZIndex = 0
shadow.Parent = main
main.ZIndex = 1

local top = Instance.new("Frame")
top.Name = "TopBar"
top.Size = UDim2.new(1, 0, 0, 58)
top.BackgroundColor3 = COLORS.panel
top.BorderSizePixel = 0
top.Parent = main
corner(top, 15)

local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 16)
topFix.Position = UDim2.new(0, 0, 1, -16)
topFix.BackgroundColor3 = COLORS.panel
topFix.BorderSizePixel = 0
topFix.Parent = top

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(18, 7)
title.Size = UDim2.new(1, -100, 0, 25)
title.Font = Enum.Font.GothamBold
title.Text = "OR'S CODE SNIPER"
title.TextColor3 = COLORS.white
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(19, 32)
subtitle.Size = UDim2.new(1, -100, 0, 15)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "UNIFIED CONTROL PANEL"
subtitle.TextColor3 = COLORS.gray
subtitle.TextSize = 9
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(30, 30)
close.Position = UDim2.new(1, -43, 0, 14)
close.BackgroundColor3 = COLORS.panel2
close.BorderSizePixel = 0
close.Text = "×"
close.TextColor3 = COLORS.white
close.TextSize = 20
close.Font = Enum.Font.Gotham
close.AutoButtonColor = false
close.Parent = top
corner(close, 8)
close.MouseButton1Click:Connect(function()
    tween(main, 0.18, {Size = UDim2.fromOffset(540, 0)})
    task.wait(0.19)
    gui:Destroy()
end)

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Position = UDim2.fromOffset(12, 70)
sidebar.Size = UDim2.fromOffset(150, 306)
sidebar.BackgroundColor3 = COLORS.panel
sidebar.BorderSizePixel = 0
sidebar.Parent = main
corner(sidebar, 11)
stroke(sidebar, COLORS.line, 0.35, 1)

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 7)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 12)
sidePad.PaddingLeft = UDim.new(0, 9)
sidePad.PaddingRight = UDim.new(0, 9)
sidePad.Parent = sidebar

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.fromOffset(174, 70)
content.Size = UDim2.new(1, -186, 1, -84)
content.BackgroundColor3 = COLORS.panel
content.BorderSizePixel = 0
content.Parent = main
corner(content, 11)
stroke(content, COLORS.line, 0.35, 1)

local pages = {}
local tabs = {}
local currentTab

local function makePage(name, heading, description, rows)
    local page = Instance.new("Frame")
    page.Name = name:gsub("%W", "") .. "Page"
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content
    pages[name] = page

    local h = Instance.new("TextLabel")
    h.BackgroundTransparency = 1
    h.Position = UDim2.fromOffset(18, 16)
    h.Size = UDim2.new(1, -36, 0, 27)
    h.Font = Enum.Font.GothamBold
    h.Text = heading
    h.TextColor3 = COLORS.white
    h.TextSize = 16
    h.TextXAlignment = Enum.TextXAlignment.Left
    h.Parent = page

    local d = Instance.new("TextLabel")
    d.BackgroundTransparency = 1
    d.Position = UDim2.fromOffset(18, 45)
    d.Size = UDim2.new(1, -36, 0, 34)
    d.Font = Enum.Font.Gotham
    d.Text = description
    d.TextColor3 = COLORS.gray
    d.TextSize = 10
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.TextYAlignment = Enum.TextYAlignment.Top
    d.Parent = page

    local y = 91
    for _, row in ipairs(rows or {}) do
        local card = Instance.new("Frame")
        card.Position = UDim2.fromOffset(16, y)
        card.Size = UDim2.new(1, -32, 0, 48)
        card.BackgroundColor3 = COLORS.panel2
        card.BorderSizePixel = 0
        card.Parent = page
        corner(card, 8)
        stroke(card, COLORS.line, 0.55, 1)

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.fromOffset(12, 0)
        label.Size = UDim2.new(1, -24, 1, 0)
        label.Font = Enum.Font.GothamMedium
        label.Text = row
        label.TextColor3 = COLORS.white
        label.TextSize = 11
        label.TextWrapped = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card
        y = y + 57
    end
end

makePage("CODE SNIPER", "CODE SNIPER", "Panel para las opciones del módulo Code Sniper.", {
    "Módulo original pendiente de integración segura",
    "Las acciones de automatización remota no se ejecutan en esta versión",
})
makePage("RIDDLE AI", "RIDDLE AI", "Panel para las opciones del módulo Riddle AI.", {
    "Interfaz preparada para conectar funciones locales compatibles",
    "No se incluye ninguna clave API incrustada",
})
makePage("SETTINGS", "SETTINGS", "Ajustes visuales de la interfaz.", {
    "Tema: negro / blanco / gris",
    "Ventana movible y diseño adaptable a pantallas táctiles",
})
makePage("ABOUT", "ABOUT OR'S", "OR'S CODE SNIPER — Unified Interface.", {
    "Diseño minimalista con sombras y transiciones",
    "Build de interfaz segura",
})

local function selectTab(name)
    if currentTab == name then return end
    currentTab = name
    for tabName, page in pairs(pages) do
        page.Visible = (tabName == name)
    end
    for tabName, button in pairs(tabs) do
        local selected = tabName == name
        tween(button, 0.16, {
            BackgroundColor3 = selected and COLORS.panel2 or COLORS.panel,
            TextColor3 = selected and COLORS.white or COLORS.gray,
        })
        local bar = button:FindFirstChild("ActiveBar")
        if bar then
            tween(bar, 0.16, {BackgroundTransparency = selected and 0 or 1})
        end
    end
end

for index, name in ipairs({"CODE SNIPER", "RIDDLE AI", "SETTINGS", "ABOUT"}) do
    local button = Instance.new("TextButton")
    button.Name = name:gsub("%W", "") .. "Tab"
    button.LayoutOrder = index
    button.Size = UDim2.new(1, 0, 0, 42)
    button.BackgroundColor3 = COLORS.panel
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Font = Enum.Font.GothamSemibold
    button.Text = name
    button.TextColor3 = COLORS.gray
    button.TextSize = 10
    button.Parent = sidebar
    corner(button, 8)
    tabs[name] = button

    local active = Instance.new("Frame")
    active.Name = "ActiveBar"
    active.Size = UDim2.fromOffset(3, 20)
    active.Position = UDim2.fromOffset(0, 11)
    active.BackgroundColor3 = COLORS.white
    active.BackgroundTransparency = 1
    active.BorderSizePixel = 0
    active.Parent = button
    corner(active, 2)

    button.MouseButton1Click:Connect(function()
        selectTab(name)
    end)
end

local footer = Instance.new("TextLabel")
footer.BackgroundTransparency = 1
footer.Position = UDim2.new(0, 10, 1, -25)
footer.Size = UDim2.new(1, -20, 0, 15)
footer.Font = Enum.Font.Gotham
footer.Text = "OR'S  •  PRIVATE UI"
footer.TextColor3 = COLORS.muted
footer.TextSize = 8
footer.Parent = sidebar

-- Drag support (mouse and touch).
local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Small entrance animation.
local finalSize = main.Size
main.Size = UDim2.fromOffset(finalSize.X - 24, finalSize.Y - 18)
main.BackgroundTransparency = 0.12
tween(main, 0.24, {Size = finalSize, BackgroundTransparency = 0})

selectTab("CODE SNIPER")