-- ============================================
-- COLOR DICE - SIN ESPACIO BLANCO ABAJO
-- ============================================
local Players = game:GetService("Players")
local Tween = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

pcall(function() if CoreGui:FindFirstChild("ColorDicePanel") then CoreGui.ColorDicePanel:Destroy() end end)

local COLORES = {
    {Nombre = "Red", Color = Color3.fromRGB(255, 45, 45)},
    {Nombre = "Orange", Color = Color3.fromRGB(255, 145, 0)},
    {Nombre = "Yellow", Color = Color3.fromRGB(255, 235, 0)},
    {Nombre = "Green", Color = Color3.fromRGB(0, 175, 0)},
    {Nombre = "Blue", Color = Color3.fromRGB(0, 85, 255)},
    {Nombre = "Purple", Color = Color3.fromRGB(155, 0, 155)}
}

local listaCuadros = {}
local COLOR_INICIAL = Color3.fromRGB(180, 180, 180)

local Gui = Instance.new("ScreenGui")
Gui.Name = "ColorDicePanel"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = CoreGui

-- Panel reducido SIN espacio sobrante: 260 x 195
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 260, 0, 195)
Panel.Position = UDim2.new(0.5, -130, 0.5, -97)
Panel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Panel.Active = true
Panel.Draggable = true
Panel.Parent = Gui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 18)

-- Título
local Titulo = Instance.new("TextLabel")
Titulo.Size = UDim2.new(1, 0, 0, 26)
Titulo.Position = UDim2.new(0, 0, 0, 2)
Titulo.BackgroundTransparency = 1
Titulo.Text = "🎨 COLOR DICE"
Titulo.TextColor3 = Color3.fromRGB(20, 20, 20)
Titulo.TextSize = 24
Titulo.Font = Enum.Font.GothamBold
Titulo.Parent = Panel

-- Contenedor de cuadros
local ContenedorCuadros = Instance.new("Frame")
ContenedorCuadros.Size = UDim2.new(0.92, 0, 0, 62)
ContenedorCuadros.Position = UDim2.new(0.04, 0, 0, 32)
ContenedorCuadros.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
ContenedorCuadros.Parent = Panel
Instance.new("UICorner", ContenedorCuadros).CornerRadius = UDim.new(0, 10)

-- Cuadros con borde negro y punto negro
for i = 0, 3 do
    local cuadro = Instance.new("Frame")
    cuadro.Size = UDim2.new(0.20, 0, 0.55, 0)
    cuadro.Position = UDim2.new(0.05 + i * 0.237, 0, 0.225, 0)
    cuadro.BackgroundColor3 = COLOR_INICIAL
    cuadro.BackgroundTransparency = 0
    cuadro.BorderSizePixel = 1
    cuadro.BorderColor3 = Color3.fromRGB(0, 0, 0)
    cuadro.Parent = ContenedorCuadros
    Instance.new("UICorner", cuadro).CornerRadius = UDim.new(0, 6)
    table.insert(listaCuadros, cuadro)

    local PuntoCuadro = Instance.new("Frame")
    PuntoCuadro.Size = UDim2.new(0, 5, 0, 5)
    PuntoCuadro.Position = UDim2.new(0.5, -2.5, 0.5, -2.5)
    PuntoCuadro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    PuntoCuadro.ZIndex = 5
    PuntoCuadro.Parent = cuadro
    Instance.new("UICorner", PuntoCuadro).CornerRadius = UDim.new(1, 0)
end

-- Texto
local TextoColores = Instance.new("TextLabel")
TextoColores.Size = UDim2.new(0.92, 0, 0, 13)
TextoColores.Position = UDim2.new(0.04, 0, 0, 100)
TextoColores.BackgroundTransparency = 1
TextoColores.Text = "Possible colors are: Red, Orange, Yellow, Green, Blue, and Purple."
TextoColores.TextColor3 = Color3.fromRGB(80, 80, 80)
TextoColores.TextSize = 9
TextoColores.Font = Enum.Font.Gotham
TextoColores.Parent = Panel

-- Botón justo al final SIN espacio vacío
local BtnRoll = Instance.new("TextButton")
BtnRoll.Size = UDim2.new(0.92, 0, 0, 38)
BtnRoll.Position = UDim2.new(0.04, 0, 0, 118)
BtnRoll.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
BtnRoll.Text = "✅ ROLL AGAIN !"
BtnRoll.TextColor3 = Color3.fromRGB(20, 20, 20)
BtnRoll.TextSize = 20
BtnRoll.Font = Enum.Font.GothamBold
BtnRoll.Parent = Panel
Instance.new("UICorner", BtnRoll).CornerRadius = UDim.new(0, 10)

-- Animación
function TirarColores()
    for _ = 1, 7 do
        local tareas = {}
        for _, cuadro in next, listaCuadros do
            local colorRapido = COLORES[math.random(#COLORES)]
            table.insert(tareas, Tween:Create(cuadro, TweenInfo.new(0.07), {BackgroundColor3 = colorRapido.Color}))
        end
        for _, t in next, tareas do t:Play() end
        task.wait(0.07)
    end
    local ocultar = {}
    for _, c in next, listaCuadros do
        table.insert(ocultar, Tween:Create(c, TweenInfo.new(0.15), {BackgroundTransparency = 1}))
    end
    for _, t in next, ocultar do t:Play() end
    task.wait(0.15)
    local mostrar = {}
    for _, c in next, listaCuadros do
        local fin = COLORES[math.random(#COLORES)]
        c.BackgroundColor3 = fin.Color
        table.insert(mostrar, Tween:Create(c, TweenInfo.new(0.3), {BackgroundTransparency = 0}))
    end
    for _, t in next, mostrar do t:Play() end
end

BtnRoll.MouseButton1Click:Connect(TirarColores)

print("✅ COLOR DICE sin espacio vacío listo")