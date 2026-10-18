-- VLESS | Base desde cero
-- Interfaz para móvil y PC

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

if not player then return end

local old = player:WaitForChild("PlayerGui"):FindFirstChild("VLESS_UI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "VLESS_UI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local RED = Color3.fromRGB(220, 30, 45)
local BLACK = Color3.fromRGB(12, 12, 14)
local PANEL = Color3.fromRGB(27, 27, 32)
local WHITE = Color3.new(1, 1, 1)
local GRAY = Color3.fromRGB(175, 175, 185)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
end

local function label(parent, text, size, color)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or WHITE
    l.TextSize = size or 14
    l.Font = Enum.Font.GothamBold
    l.Parent = parent
    return l
end

-- Intro animada
local intro = Instance.new("Frame")
intro.Size = UDim2.fromOffset(300, 125)
intro.AnchorPoint = Vector2.new(.5, .5)
intro.Position = UDim2.fromScale(.5, .45)
intro.BackgroundColor3 = BLACK
intro.Parent = gui
corner(intro, 16)

local border = Instance.new("UIStroke", intro)
border.Color = RED
border.Thickness = 2

local introTitle = label(intro, "VLESS", 35, WHITE)
introTitle.Size = UDim2.new(1, 0, 0, 70)
introTitle.Position = UDim2.fromOffset(0, 8)

local introSub = label(intro, "INICIANDO...", 12, GRAY)
introSub.Size = UDim2.new(1, 0, 0, 25)
introSub.Position = UDim2.fromOffset(0, 80)

task.spawn(function()
    for i = 1, 22 do
        introTitle.Position = UDim2.fromOffset(0, 8 + math.sin(i / 2) * 4)
        introTitle.TextColor3 = i % 2 == 0 and WHITE
            or Color3.fromRGB(255, 150, 160)
        task.wait(.06)
    end
    intro:Destroy()
end)

-- Ventana principal
local main = Instance.new("Frame")
main.Name = "VLESS_Menu"
main.Size = UDim2.new(.85, 0, .62, 0)
main.Position = UDim2.fromScale(.075, .2)
main.BackgroundColor3 = BLACK
main.Visible = false
main.Parent = gui
corner(main, 14)

local limit = Instance.new("UISizeConstraint", main)
limit.MinSize = Vector2.new(285, 300)
limit.MaxSize = Vector2.new(520, 480)

local outline = Instance.new("UIStroke", main)
outline.Color = RED
outline.Thickness = 1.5

local top = Instance.new("TextButton")
top.Size = UDim2.new(1, 0, 0, 48)
top.BackgroundColor3 = PANEL
top.Text = "   VLESS                         —"
top.TextColor3 = WHITE
top.TextSize = 20
top.Font = Enum.Font.GothamBlack
top.Parent = main
corner(top, 12)

-- Ventana movible con ratón o dedo
do
    local dragging, start, origin
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            origin = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - start
            main.Position = UDim2.new(
                origin.X.Scale, origin.X.Offset + delta.X,
                origin.Y.Scale, origin.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local body = Instance.new("Frame")
body.Position = UDim2.fromOffset(12, 60)
body.Size = UDim2.new(1, -24, 1, -72)
body.BackgroundColor3 = PANEL
body.Parent = main
corner(body, 10)

local layout = Instance.new("UIListLayout", body)
layout.Padding = UDim.new(0, 9)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", body)
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)

local welcome = label(body, "BIENVENIDO A VLESS", 16, RED)
welcome.Size = UDim2.new(1, 0, 0, 35)

local info = label(body, "Jugador: " .. player.Name, 13, GRAY)
info.Size = UDim2.new(1, 0, 0, 28)

local function makeButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = BLACK
    b.Text = text
    b.TextColor3 = WHITE
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.AutoButtonColor = false
    b.Parent = body
    corner(b, 9)

    local line = Instance.new("UIStroke", b)
    line.Color = RED

    b.Activated:Connect(function()
        b.BackgroundColor3 = RED
        task.delay(.18, function()
            if b.Parent then b.BackgroundColor3 = BLACK end
        end)
        callback()
    end)
    return b
end

makeButton("RESTABLECER CÁMARA", function()
    local camera = workspace.CurrentCamera
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if camera and humanoid then
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = humanoid
    end
end)

makeButton("REAPARECER", function()
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.Health = 0 end
end)

makeButton("OCULTAR MENÚ", function()
    main.Visible = false
end)

-- Botón flotante para volver a abrirlo
local reopen = Instance.new("TextButton")
reopen.Size = UDim2.fromOffset(52, 45)
reopen.Position = UDim2.new(0, 12, .5, 0)
reopen.BackgroundColor3 = BLACK
reopen.Text = "V"
reopen.TextColor3 = WHITE
reopen.TextSize = 22
reopen.Font = Enum.Font.GothamBlack
reopen.Visible = false
reopen.Parent = gui
corner(reopen, 10)

local reopenStroke = Instance.new("UIStroke", reopen)
reopenStroke.Color = RED

makeButton -- conservar constructor para futuras categorías

reopen.Activated:Connect(function()
    main.Visible = true
    reopen.Visible = false
end)

-- Mostrar menú al terminar la intro
task.delay(1.5, function()
    if gui.Parent then
        main.Visible = true
        reopen.Visible = true
    end
end)

-- Cerrar el menú con el botón superior
top.Activated:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

print("[VLESS] Interfaz iniciada")