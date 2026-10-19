-- VLEX | Intro animada + boton personalizado (movil y PC)
-- GUI local de ejemplo. No incluye exploits ni automatizacion del servidor.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
if not player then return end

local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("VLEX_UI")
if old then old:Destroy() end

local RED = Color3.fromRGB(255, 15, 30)
local BLACK = Color3.fromRGB(7, 7, 9)
local PANEL = Color3.fromRGB(23, 23, 27)
local WHITE = Color3.new(1, 1, 1)
local GRAY = Color3.fromRGB(175, 175, 185)

local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 12)
    c.Parent = o
end
local function outline(o, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color, s.Thickness = color or RED, thickness or 1.5
    s.Parent = o
end
local function label(parent, text, size, font, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text, l.TextSize = text, size or 14
    l.Font, l.TextColor3 = font or Enum.Font.GothamBold, color or WHITE
    l.Parent = parent
    return l
end

local gui = Instance.new("ScreenGui")
gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "VLEX_UI", false, 9999
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = pg

-- Intro: letras separadas se juntan para formar VLEX y luego hacen olas rojas.
local intro = Instance.new("Frame")
intro.Name = "VLEX_Intro"
intro.Position = UDim2.fromScale(0, 0)
intro.Size = UDim2.fromScale(1, 1)
intro.BackgroundColor3 = Color3.new(0, 0, 0)
intro.BorderSizePixel = 0
intro.ZIndex = 50
intro.Parent = gui

-- Hojas rojas cayendo por toda la pantalla durante la intro.
local leavesActive = true
local leafRandom = Random.new()
task.spawn(function()
    while leavesActive and intro.Parent do
        local leaf = Instance.new("TextLabel")
        leaf.BackgroundTransparency = 1
        leaf.Text = "◆"
        leaf.TextColor3 = leafRandom:NextNumber() > 0.5 and RED or Color3.fromRGB(255, 75, 85)
        leaf.TextSize = leafRandom:NextInteger(12, 25)
        leaf.Font = Enum.Font.GothamBlack
        leaf.AnchorPoint = Vector2.new(.5, .5)
        leaf.Position = UDim2.new(leafRandom:NextNumber(), 0, 0, -25)
        leaf.Size = UDim2.fromOffset(28, 28)
        leaf.Rotation = leafRandom:NextInteger(0, 360)
        leaf.ZIndex = 55
        leaf.Parent = intro
        local duration = leafRandom:NextNumber(2, 3.8)
        local drift = leafRandom:NextInteger(-110, 110)
        local tween = TweenService:Create(leaf, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.new(leaf.Position.X.Scale, drift, 1, 35),
            Rotation = leaf.Rotation + leafRandom:NextInteger(180, 540),
            TextTransparency = .1
        })
        tween:Play()
        tween.Completed:Connect(function() if leaf.Parent then leaf:Destroy() end end)
        task.wait(.12)
    end
end)

local holder = Instance.new("Frame")
holder.BackgroundTransparency = 1
holder.AnchorPoint = Vector2.new(.5, .5)
holder.Position, holder.Size = UDim2.fromScale(.5, .46), UDim2.new(1, 0, 0, 100)
holder.ZIndex = 51
holder.Parent = intro
local chars = {"V", "L", "E", "X"}
local finalX = {-68, -22, 24, 70}
local startX = {-190, -75, 90, 190}
local letterLabels = {}
for i, ch in ipairs(chars) do
    local l = label(holder, ch, 48, Enum.Font.GothamBlack, RED)
    l.AnchorPoint = Vector2.new(.5, .5)
    l.Size = UDim2.fromOffset(52, 68)
    l.Position = UDim2.new(.5, (i <= 2) and -1000 or 1000, .5, (i % 2 == 0) and 50 or -50)
    l.ZIndex = 52
    l.TextTransparency = 1
    l.Rotation = (i % 2 == 0) and 25 or -25
    letterLabels[i] = l
end
local underline = Instance.new("Frame")
underline.AnchorPoint = Vector2.new(.5, 0)
underline.Position = UDim2.new(.5, 0, .5, 52)
underline.Size = UDim2.new(0, 0, 0, 3)
underline.BackgroundColor3 = RED
underline.ZIndex = 52
underline.Parent = holder
corner(underline, 3)
local subtitle = label(intro, " ", 12, Enum.Font.GothamMedium, GRAY)
subtitle.AnchorPoint = Vector2.new(.5, 0)
subtitle.Position, subtitle.Size = UDim2.new(.5, 0, .5, 68), UDim2.new(.8, 0, 0, 24)
subtitle.ZIndex = 52

-- Menu principal.
local main = Instance.new("Frame")
main.Name = "VLEX_Menu"
main.AnchorPoint = Vector2.new(0, .5)
main.Position, main.Size = UDim2.new(0, 18, .5, 0), UDim2.new(.29, 0, .92, 0)
main.BackgroundColor3, main.Visible = BLACK, false
main.Parent = gui
corner(main, 15)
outline(main, RED, 1.5)
local limit = Instance.new("UISizeConstraint", main)
limit.MinSize, limit.MaxSize = Vector2.new(280, 420), Vector2.new(520, 900)

local top = Instance.new("Frame")
top.Size, top.BackgroundColor3 = UDim2.new(1, 0, 0, 174), PANEL
top.BackgroundTransparency = 1
top.Parent = main
corner(top, 14)
local cover = Instance.new("Frame")
cover.Position, cover.Size = UDim2.new(0, 0, 1, -13), UDim2.new(1, 0, 0, 13)
cover.BackgroundColor3, cover.BorderSizePixel = PANEL, 0
cover.Parent = top
local heading = label(top, "VLEX", 52, Enum.Font.Antique, WHITE)
heading.Position, heading.Size = UDim2.new(0, 12, 0, 0), UDim2.new(1, -24, 0, 105)
heading.TextXAlignment = Enum.TextXAlignment.Center
local headerLine = Instance.new("Frame")
headerLine.Position, headerLine.Size = UDim2.new(0, 14, 0, 125), UDim2.new(1, -28, 0, 2)
headerLine.BackgroundColor3, headerLine.BorderSizePixel = RED, 0
headerLine.Parent = top
local tabs = Instance.new("Frame")
tabs.Position, tabs.Size = UDim2.new(0, 8, 0, 135), UDim2.new(1, -16, 0, 32)
tabs.BackgroundTransparency = 1
tabs.Parent = top
local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.Parent = tabs
local pageTitle
for i, tabName in ipairs({"Speed", "Custom", "Visual", "Settings", "Keybinds"}) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(.2, -4, 1, 0)
    tab.BackgroundColor3 = i == 1 and RED or PANEL
    tab.Text = tabName
    tab.TextColor3 = WHITE
    tab.TextSize = 10
    tab.Font = Enum.Font.GothamBold
    tab.AutoButtonColor = false
    tab.Parent = tabs
    corner(tab, 9)
    tab.Activated:Connect(function()
        for _, other in ipairs(tabs:GetChildren()) do
            if other:IsA("TextButton") then
                other.BackgroundColor3 = other == tab and RED or PANEL
            end
        end
        pageTitle.Text = tabName
    end)
end

local close = Instance.new("TextButton")
close.Size, close.Position = UDim2.fromOffset(28, 28), UDim2.new(1, -34, 0, 4)
close.BackgroundColor3, close.Text = Color3.fromRGB(100, 5, 14), "-"
close.TextColor3, close.TextSize, close.Font = WHITE, 23, Enum.Font.GothamBold
close.Parent = top
corner(close, 9)

-- Arrastrar ventana con dedo o raton.
do
    local dragging, startPos, origin = false, nil, nil
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, startPos, origin = true, input.Position, main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startPos
            main.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

-- El panel queda vacío debajo de las pestañas: sin opciones ni controles extra.

-- Boton flotante negro con borde rojo y letras rojas estilo gotico.
local badge = Instance.new("TextButton")
badge.Name, badge.Position, badge.Size = "VLEX_Button", UDim2.new(0, 100, 0, 104), UDim2.fromOffset(112, 38) -- boton mas pequeno
badge.AnchorPoint = Vector2.new(0, 0)
badge.ZIndex = 20
badge.BackgroundColor3, badge.Text = Color3.fromRGB(5, 5, 7), "VLEX"
badge.TextColor3, badge.TextSize, badge.Font = RED, 18, Enum.Font.Antique
badge.AutoButtonColor = false
badge.Parent = gui
corner(badge, 15)
-- Estilo de la referencia: fondo negro limpio y letras rojas góticas.
outline(badge, Color3.fromRGB(5, 5, 7), 1)
-- Arrastrar el boton flotante con raton o dedo; un toque/clic sin arrastrar abre el menu.
local badgeDragging = false
local badgeMoved = false
local badgeDragStart = nil
local badgeStartPos = nil
local badgeDragInput = nil

badge.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        badgeDragging = true
        badgeMoved = false
        badgeDragStart = input.Position
        badgeStartPos = badge.Position
        badgeDragInput = input

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                badgeDragging = false
            end
        end)
    end
end)

badge.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        badgeDragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if badgeDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - badgeDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            badgeMoved = true
        end
        if badgeMoved then
            badge.Position = UDim2.new(
                badgeStartPos.X.Scale, badgeStartPos.X.Offset + delta.X,
                badgeStartPos.Y.Scale, badgeStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

badge.Activated:Connect(function()
    if badgeMoved then
        badgeMoved = false
        return
    end
    if main.Visible then
        main.Visible = false
        badge.Visible = true
    else
        -- El menú entra rápidamente desde la izquierda sin cambiar el botón.
        main.Visible = true
        badge.Visible = false
        local finalPosition = UDim2.new(0, 18, .5, 0)
        main.Position = UDim2.new(0, -main.AbsoluteSize.X - 20, .5, 0)
        TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = finalPosition
        }):Play()
    end
end)
close.Activated:Connect(function() main.Visible = false; badge.Visible = true end)

task.spawn(function()
    task.wait(.15)
    for i, l in ipairs(letterLabels) do
        l.TextTransparency = 0
        TweenService:Create(l, TweenInfo.new(.62, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(.5, finalX[i], .5, 0), Rotation = 0
        }):Play()
        task.wait(.12)
    end
    TweenService:Create(underline, TweenInfo.new(.3), {Size = UDim2.new(.45, 0, 0, 3)}):Play()
    subtitle.Text = "VLEX"
    task.wait(.25)
    local t0 = os.clock()
    while os.clock() - t0 < 1.7 and intro.Parent do
        local t = os.clock() - t0
        for i, l in ipairs(letterLabels) do
            local wave = math.sin(t * 7 - i * .85)
            l.Position = UDim2.new(.5, finalX[i], .5, wave * 7)
            l.TextColor3 = (wave > 0) and RED or Color3.fromRGB(255, 85, 95)
        end
        task.wait(.035)
    end
    local fade = TweenInfo.new(.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, l in ipairs(letterLabels) do TweenService:Create(l, fade, {TextTransparency = 1}):Play() end
    TweenService:Create(subtitle, fade, {TextTransparency = 1}):Play()
    TweenService:Create(underline, fade, {BackgroundTransparency = 1}):Play()
    TweenService:Create(intro, fade, {BackgroundTransparency = 1}):Play()
    task.wait(.4)
    leavesActive = false
    if intro.Parent then intro:Destroy() end
    main.Visible = true
    badge.Visible = false
end)

print("[VLEX] Intro animada y boton listos.")