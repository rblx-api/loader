-- ==============================================
--  NOXTRIX HUB · ESTILO ANIME / AZUL NEÓN
--  Discord: discord.gg/tvAkYe7Uq
--  Al ejecutar: SE VE EXACTAMENTE IGUAL QUE LA FOTO
-- ==============================================

if _G.NoxtrixHubRunning then return end
_G.NoxtrixHubRunning = true

-- SERVICIOS
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- 🎨 ESTILO — IGUAL QUE LA FOTO
local THEME = {
    PanelBg       = Color3.fromRGB(10, 12, 28),
    TitleTop      = Color3.fromRGB(0, 180, 255),
    TitleMain     = Color3.fromRGB(255, 255, 255),
    TextColor     = Color3.fromRGB(200, 220, 255),
    NeonBlue      = Color3.fromRGB(0, 200, 255),
    NeonPurple    = Color3.fromRGB(180, 0, 255),
    BorderGlow    = Color3.fromRGB(0, 190, 255),
    DiscordColor  = Color3.fromRGB(80, 200, 255),
    ButtonOn      = Color3.fromRGB(0, 180, 255),
    ButtonOff     = Color3.fromRGB(30, 50, 90),
    Font          = Enum.Font.GothamBold,
}

-- 🖼️ INTERFAZ — AL EJECUTAR SE VE ASÍ
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoxtrixHub_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- ==============================================
-- PANEL PRINCIPAL
-- ==============================================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = THEME.PanelBg
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = THEME.BorderGlow
mainFrame.Size = UDim2.new(0, 300, 0, 420)
mainFrame.Position = UDim2.new(0.02, 0, 0.3, 0)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- EFECTO DE LIQUIDO NEGRO EN BORDE SUPERIOR
local liquidTop = Instance.new("Frame", mainFrame)
liquidTop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
liquidTop.Size = UDim2.new(1, 0, 0, 45)
liquidTop.Position = UDim2.new(0, 0, 0, 0)
Instance.new("UICorner", liquidTop).CornerRadius = UDim.new(0, 16)

-- TÍTULO ARRIBA: Noxtrix HUB
local topTitle = Instance.new("TextLabel", mainFrame)
topTitle.BackgroundTransparency = 1
topTitle.Position = UDim2.new(0, 15, 0, 8)
topTitle.Size = UDim2.new(1, -30, 0, 30)
topTitle.Font = Enum.Font.GothamBlack
topTitle.Text = "Noxtrix HUB"
topTitle.TextColor3 = THEME.TitleTop
topTitle.TextSize = 24
topTitle.TextXAlignment = Enum.TextXAlignment.Left

-- BOTÓN MINIMIZAR
local minBtn = Instance.new("TextButton", mainFrame)
minBtn.BackgroundTransparency = 1
minBtn.Position = UDim2.new(1, -30, 0, 5)
minBtn.Size = UDim2.new(0, 20, 0, 25)
minBtn.Font = Enum.Font.GothamBlack
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 18
minBtn.Parent = mainFrame

-- ==============================================
-- BARRA LATERAL IZQUIERDA
-- ==============================================
local sidebar = Instance.new("Frame", mainFrame)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
sidebar.BorderSizePixel = 0
sidebar.Size = UDim2.new(0, 70, 1, -45)
sidebar.Position = UDim2.new(0, 0, 0, 45)

local sidebarBtns = {"Moment", "Combat", "Main", "Keybinds"}
for i, name in ipairs(sidebarBtns) do
    local btn = Instance.new("TextButton", sidebar)
    btn.BackgroundTransparency = 1
    btn.Position = UDim2.new(0, 5, 0, 15 + (i-1)*45)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = THEME.TextColor
    btn.TextSize = 11
    btn.AutoButtonColor = false
end

-- FOTO DEL PERSONAJE CON RAYOS NEÓN
local charBg = Instance.new("Frame", mainFrame)
charBg.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
charBg.Size = UDim2.new(0, 220, 0, 220)
charBg.Position = UDim2.new(0, 75, 0, 50)
Instance.new("UICorner", charBg).CornerRadius = UDim.new(0, 12)

-- RAYOS NEÓN AZUL/MORADO ANIMADOS
task.spawn(function()
    while charBg and charBg.Parent do
        local t = os.clock()
        local glow = 0.5 + math.sin(t * 3) * 0.3
        charBg.BorderSizePixel = 2
        charBg.BorderColor3 = Color3.fromRGB(
            0,
            150 + glow * 100,
            250
        )
        task.wait(0.05)
    end
end)

-- TÍTULO DENTRO DEL PANEL
local mainTitle = Instance.new("TextLabel", mainFrame)
mainTitle.BackgroundTransparency = 1
mainTitle.Position = UDim2.new(0, 80, 0, 55)
mainTitle.Size = UDim2.new(1, -90, 0, 25)
mainTitle.Font = Enum.Font.GothamBlack
mainTitle.Text = "Noxtrix Hub"
mainTitle.TextColor3 = THEME.TitleMain
mainTitle.TextSize = 20
mainTitle.TextXAlignment = Enum.TextXAlignment.Left

-- ==============================================
-- ENLACE DISCORD — ARRIBA, TAL COMO EN LA FOTO
-- ==============================================
local discordLabel = Instance.new("TextLabel", mainFrame)
discordLabel.BackgroundTransparency = 1
discordLabel.Position = UDim2.new(0, 80, 0, 280)
discordLabel.Size = UDim2.new(1, -90, 0, 18)
discordLabel.Font = Enum.Font.GothamBold
discordLabel.Text = "discord.gg/tvAkYe7Uq"
discordLabel.TextColor3 = THEME.DiscordColor
discordLabel.TextSize = 11
discordLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ==============================================
-- BOTONES DE CONTROL (con rayos neón)
-- ==============================================
local function createNeonButton(text, x, y, isActive)
    local btn = Instance.new("TextButton", mainFrame)
    btn.BackgroundColor3 = isActive and THEME.ButtonOn or THEME.ButtonOff
    btn.BorderSizePixel = 2
    btn.BorderColor3 = THEME.NeonBlue
    btn.Size = UDim2.new(0, 190, 0, 26)
    btn.Position = UDim2.new(0, x, 0, y)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 10
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    -- Brillo al pasar cursor
    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {
            BorderColor3 = THEME.NeonPurple,
            BackgroundColor3 = THEME.NeonBlue
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {
            BorderColor3 = THEME.NeonBlue,
            BackgroundColor3 = isActive and THEME.ButtonOn or THEME.ButtonOff
        }):Play()
    end)
    return btn
end

-- Colocar todos los botones como en la foto
createNeonButton("Normal Speed        60", 80, 95, false)
createNeonButton("Carry Speed         29", 80, 128, false)
createNeonButton("Lagger 1 Speed     20", 80, 161, false)
createNeonButton("Lagger 2 Speed     10", 80, 194, false)
createNeonButton("Current Mode    Carry Mode", 80, 227, true)
createNeonButton("Unwalk", 80, 260, false)
createNeonButton("DROP", 80, 310, false)
createNeonButton("Drop Brainrot", 80, 343, false)

-- ==============================================
-- BOTÓN ONLINE / FOTO DE PERFIL
-- ==============================================
local profileFrame = Instance.new("Frame", mainFrame)
profileFrame.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
profileFrame.Size = UDim2.new(0, 50, 0, 50)
profileFrame.Position = UDim2.new(0, 12, 0, 350)
Instance.new("UICorner", profileFrame).CornerRadius = UDim.new(1,0)

local onlineLabel = Instance.new("TextLabel", mainFrame)
onlineLabel.BackgroundTransparency = 1
onlineLabel.Position = UDim2.new(0, 10, 0, 405)
onlineLabel.Size = UDim2.new(0, 55, 0, 18)
onlineLabel.Font = Enum.Font.GothamBold
onlineLabel.Text = "Online"
onlineLabel.TextColor3 = THEME.TextColor
onlineLabel.TextSize = 10

-- ==============================================
-- BOTONES INFERIORES
-- ==============================================
local btnScambio = Instance.new("TextButton", mainFrame)
btnScambio.BackgroundColor3 = Color3.fromRGB(25, 40, 70)
btnScambio.Position = UDim2.new(0, 10, 0, 370)
btnScambio.Size = UDim2.new(0, 60, 0, 28)
btnScambio.Font = Enum.Font.GothamBold
btnScambio.Text = "Scambio"
btnScambio.TextColor3 = THEME.TextColor
btnScambio.TextSize = 10
Instance.new("UICorner", btnScambio).CornerRadius = UDim.new(0, 6)

local btnCodici = Instance.new("TextButton", mainFrame)
btnCodici.BackgroundColor3 = Color3.fromRGB(25, 40, 70)
btnCodici.Position = UDim2.new(0, 80, 0, 370)
btnCodici.Size = UDim2.new(0, 60, 0, 28)
btnCodici.Font = Enum.Font.GothamBold
btnCodici.Text = "Codici"
btnCodici.TextColor3 = THEME.TextColor
btnCodici.TextSize = 10
Instance.new("UICorner", btnCodici).CornerRadius = UDim.new(0, 6)

-- ==============================================
-- ARRASTRAR VENTANA
-- ==============================================
local isDragging, dragStart, startPos = false, nil, nil
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if isDragging then
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- ==============================================
-- BOTONES LATERALES DERECHOS (hexagonales con rayos neón)
-- ==============================================
local rightButtons = {
    {"CARRY\nSPD", 0.78, 0.15},
    {"AUTO\nRIGHT", 0.84, 0.15},
    {"ANTI\nDESYNC", 0.78, 0.28},
    {"LAGGER\n1", 0.78, 0.41},
    {"RESET", 0.78, 0.54},
    {"BAT\nV2", 0.84, 0.54},
    {"AUTO\nLEFT", 0.84, 0.28},
    {"LAGGER\n2", 0.84, 0.41},
}

for _, btnData in ipairs(rightButtons) do
    local text, x, y = unpack(btnData)
    local btn = Instance.new("TextButton", screenGui)
    btn.BackgroundColor3 = Color3.fromRGB(10, 30, 60)
    btn.BorderSizePixel = 3
    btn.BorderColor3 = THEME.NeonBlue
    btn.Size = UDim2.new(0, 70, 0, 70)
    btn.Position = UDim2.new(x, -35, y, -35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 11
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    -- Brillo neón
    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = THEME.NeonBlue,
            BorderColor3 = THEME.NeonPurple
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(10, 30, 60),
            BorderColor3 = THEME.NeonBlue
        }):Play()
    end)
end

print("[Noxtrix Hub] ✅ Cargado — Se ve igual que la foto")
print("[Noxtrix Hub] 📍 Discord: discord.gg/tvAkYe7Uq")