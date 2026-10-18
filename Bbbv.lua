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
main.AnchorPoint = Vector2.new(.5, .5)
main.Position, main.Size = UDim2.fromScale(.5, .53), UDim2.new(.84, 0, .62, 0)
main.BackgroundColor3, main.Visible = BLACK, false
main.Parent = gui
corner(main, 15)
outline(main, RED, 1.5)
local limit = Instance.new("UISizeConstraint", main)
limit.MinSize, limit.MaxSize = Vector2.new(280, 300), Vector2.new(520, 450)

local top = Instance.new("Frame")
top.Size, top.BackgroundColor3 = UDim2.new(1, 0, 0, 48), PANEL
top.Parent = main
corner(top, 14)
local cover = Instance.new("Frame")
cover.Position, cover.Size = UDim2.new(0, 0, 1, -13), UDim2.new(1, 0, 0, 13)
cover.BackgroundColor3, cover.BorderSizePixel = PANEL, 0
cover.Parent = top
local heading = label(top, "VLEX", 20, Enum.Font.GothamBlack, RED)
heading.Position, heading.Size = UDim2.new(0, 14, 0, 0), UDim2.new(1, -60, 1, 0)
heading.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton")
close.Size, close.Position = UDim2.fromOffset(34, 32), UDim2.new(1, -42, 0, 8)
close.BackgroundColor3, close.Text = Color3.fromRGB(100, 5, 14), "×"
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

local description = label(main, "VLEX esta listo.", 14, Enum.Font.Gotham, GRAY)
description.Position, description.Size = UDim2.new(0, 14, 0, 60), UDim2.new(1, -28, 0, 35)

local function addButton(text, y, callback)
    local b = Instance.new("TextButton")
    b.Position, b.Size = UDim2.new(0, 14, 0, y), UDim2.new(1, -28, 0, 40)
    b.BackgroundColor3, b.Text = PANEL, text
    b.TextColor3, b.TextSize, b.Font = WHITE, 13, Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = main
    corner(b, 10)
    outline(b, Color3.fromRGB(125, 8, 18), 1)
    b.Activated:Connect(function()
        TweenService:Create(b, TweenInfo.new(.1), {BackgroundColor3 = RED}):Play()
        task.delay(.18, function()
            if b.Parent then TweenService:Create(b, TweenInfo.new(.15), {BackgroundColor3 = PANEL}):Play() end
        end)
        if callback then
            local ok, err = pcall(callback)
            if not ok then warn("[VLEX] " .. tostring(err)) end
        end
    end)
end
addButton("RESTABLECER CAMARA", 105, function()
    local camera, character = workspace.CurrentCamera, player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if camera and humanoid then camera.CameraType = Enum.CameraType.Custom; camera.CameraSubject = humanoid end
end)
addButton("REAPARECER PERSONAJE", 153, function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

-- Boton flotante negro con borde rojo y letras rojas estilo gotico.
local badge = Instance.new("TextButton")
badge.Name, badge.Position, badge.Size = "VLEX_Button", UDim2.new(0, 100, 0, 104), UDim2.fromOffset(198, 62)
badge.AnchorPoint = Vector2.new(0, 0)
badge.ZIndex = 20
badge.BackgroundColor3, badge.Text = Color3.fromRGB(5, 5, 7), "𝖁𝕷𝕰𝖃"
badge.TextColor3, badge.TextSize, badge.Font = RED, 31, Enum.Font.Antique
badge.AutoButtonColor = false
badge.Parent = gui
corner(badge, 15)
outline(badge, RED, 1.8)
local glow = Instance.new("UIStroke", badge)
glow.Color, glow.Thickness, glow.Transparency = RED, 4, .75
badge.Activated:Connect(function()
    main.Visible = not main.Visible
    TweenService:Create(badge, TweenInfo.new(.12), {
        BackgroundColor3 = main.Visible and Color3.fromRGB(90, 4, 13) or Color3.fromRGB(5, 5, 7)
    }):Play()
end)
close.Activated:Connect(function() main.Visible = false end)

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
end)

print("[VLEX] Intro animada y boton listos.")