-- Ghoxt Hub | Confuser
-- Discord: https://discord.gg/DhyJ3N6pP

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local CONFIG_FILE = "GhoxtHubConfig.json"
local DISCORD_LINK = "https://discord.gg/DhyJ3N6pP"

-- Fuentes
local FONT_TITLE = Enum.Font.Michroma
local FONT_LABEL = Enum.Font.Jura
local FONT_VALUE = Enum.Font.Oswald

-- Paleta rojo oscuro
local COLORS = {
    bg          = Color3.fromRGB(10, 3, 4),
    bgDark      = Color3.fromRGB(4, 1, 2),
    panel       = Color3.fromRGB(22, 6, 8),
    stroke      = Color3.fromRGB(120, 12, 20),
    text        = Color3.fromRGB(255, 235, 235),
    textDim     = Color3.fromRGB(200, 90, 95),
    accent      = Color3.fromRGB(185, 18, 28),
    accentHi    = Color3.fromRGB(235, 35, 45),
    toggleOn    = Color3.fromRGB(220, 30, 40),
    toggleOff   = Color3.fromRGB(45, 14, 16),
    statusOff   = Color3.fromRGB(90, 25, 28)}

-- Fondos
local backgroundIds = {
    "106897611019941",
    "79999011724260",
    "115940405819747",
    "78950507792542"}
local selectedBackgroundId = backgroundIds[1]

local SCALE_MIN, SCALE_MAX, SCALE_STEP = 0.5, 1.5, 0.1

local State = {
    confuserOn    = false,
    speed         = 50,
    lockGui       = false,
    activeOnSteal = false,
    guiScale      = 1,
    guiPos        = {XScale = 0.5, XOffset = -135, YScale = 0.5, YOffset = -212}}

local toggleKey = Enum.KeyCode.X

local function saveConfig()
    local cfg = {
        toggleKey     = toggleKey.Name,
        speed         = State.speed,
        lockGui       = State.lockGui,
        activeOnSteal = State.activeOnSteal,
        guiScale      = State.guiScale,
        guiPos        = State.guiPos}
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
        end
    end)
end

local function loadConfig()
    local hasFile = false
    pcall(function() hasFile = isfile(CONFIG_FILE) end)
    if not hasFile then return end
    local ok, cfg = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not ok or not cfg then return end
    if cfg.toggleKey and Enum.KeyCode[cfg.toggleKey] then
        toggleKey = Enum.KeyCode[cfg.toggleKey]
    end
    if cfg.speed then State.speed = math.max(0, tonumber(cfg.speed) or 50) end
    if cfg.lockGui ~= nil then State.lockGui = cfg.lockGui end
    if cfg.activeOnSteal ~= nil then State.activeOnSteal = cfg.activeOnSteal end
    if cfg.guiScale then
        State.guiScale = math.clamp(tonumber(cfg.guiScale) or 1, SCALE_MIN, SCALE_MAX)
    end
    if cfg.guiPos and type(cfg.guiPos) == "table" then
        State.guiPos = cfg.guiPos
    end
end
loadConfig()

----------------------------------------------------------------
-- SPIN
----------------------------------------------------------------
local Spin = {
    enabled = false,
    conn    = nil,
    angle   = 0}

local function startSpin()
    if Spin.conn then return end
    Spin.angle = 0

    Spin.conn = RunService.Heartbeat:Connect(function(dt)
        if not Spin.enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.AutoRotate = false end)
        end

        local step = State.speed * dt * 60
        Spin.angle = (Spin.angle + step) % 360
        local yaw = math.rad(Spin.angle)

        local pos = root.Position
        root.CFrame = CFrame.new(pos) * CFrame.Angles(0, yaw, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

local function stopSpin()
    if Spin.conn then
        Spin.conn:Disconnect()
        Spin.conn = nil
    end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function() hum.AutoRotate = true end)
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end
end

----------------------------------------------------------------
-- ANTI DIE
----------------------------------------------------------------
local antiDieEnabled = false
local antiDieCharConns = {}
local antiDieCharAddedConn = nil
local antiDieHeartbeat = nil

local function clearCharEntry(char, restore)
    local entry = antiDieCharConns[char]
    if entry then
        if entry.healthConn then pcall(function() entry.healthConn:Disconnect() end) end
        if entry.diedConn then pcall(function() entry.diedConn:Disconnect() end) end
        if entry.cleanupConn then pcall(function() entry.cleanupConn:Disconnect() end) end
        antiDieCharConns[char] = nil
    end
    if restore and char and char.Parent then
        pcall(function()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.BreakJointsOnDeath = true
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            end
        end)
    end
end

local function applyAntiDieToCharacter(char)
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    clearCharEntry(char, false)

    hum.BreakJointsOnDeath = false
    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    local entry = { humanoid = hum }
    entry.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if antiDieEnabled and antiDieCharConns[char] == entry and hum.Health <= 0 then
            hum.Health = hum.MaxHealth
        end
    end)
    entry.diedConn = hum.Died:Connect(function()
        task.defer(function()
            if antiDieEnabled and antiDieCharConns[char] == entry and hum and hum.Parent then
                hum.BreakJointsOnDeath = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum.Health = hum.MaxHealth
            end
        end)
    end)
    entry.cleanupConn = char.AncestryChanged:Connect(function()
        if not char.Parent then clearCharEntry(char, false) end
    end)
    antiDieCharConns[char] = entry
end

local function setAntiDieEnabled(enabled)
    enabled = enabled == true
    if enabled == antiDieEnabled then return end
    antiDieEnabled = enabled
    if enabled then
        if not antiDieCharAddedConn then
            antiDieCharAddedConn = LP.CharacterAdded:Connect(function(char)
                task.wait(0.2)
                if antiDieEnabled and char and char.Parent then
                    applyAntiDieToCharacter(char)
                end
            end)
        end
        local char = LP.Character
        if char and char.Parent and not antiDieCharConns[char] then
            applyAntiDieToCharacter(char)
        end
        if not antiDieHeartbeat then
            antiDieHeartbeat = RunService.Heartbeat:Connect(function()
                if not antiDieEnabled then return end
                local c = LP.Character
                local hum = c and c.Parent and c:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local entry = antiDieCharConns[c]
                if not entry or entry.humanoid ~= hum then applyAntiDieToCharacter(c) end
                if hum.BreakJointsOnDeath then hum.BreakJointsOnDeath = false end
                if hum:GetStateEnabled(Enum.HumanoidStateType.Dead) then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end
                if hum.Health <= 0 then hum.Health = hum.MaxHealth end
            end)
        end
    else
        if antiDieHeartbeat then antiDieHeartbeat:Disconnect(); antiDieHeartbeat = nil end
        for char in pairs(antiDieCharConns) do
            clearCharEntry(char, true)
        end
    end
end

local function setConfuser(on)
    Spin.enabled = on
    setAntiDieEnabled(on)
    if on then startSpin() else stopSpin() end
end

----------------------------------------------------------------
-- LIMPIEZA DE GUIS ANTERIORES
----------------------------------------------------------------
for _, name in pairs({"BakiBypass", "BakiwareConfuser", "BakiAntiDie", "VynxConfuser", "GhoxtHub"}) do
    local old = CoreGui:FindFirstChild(name)
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        local o = pg:FindFirstChild(name)
        if o then o:Destroy() end
    end
end

----------------------------------------------------------------
-- GUI
----------------------------------------------------------------
local function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

local function stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local FRAME_W, FRAME_H = 270, 424
local CORNER = 18
local HEADER_H = 50

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GhoxtHub"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- El panel principal ES la imagen de fondo (así siempre queda detrás de todo)
local mainFrame = Instance.new("ImageLabel")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, FRAME_W, 0, FRAME_H)
mainFrame.Position = UDim2.new(State.guiPos.XScale, State.guiPos.XOffset, State.guiPos.YScale, State.guiPos.YOffset)
mainFrame.BackgroundColor3 = COLORS.bg
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.Image = "rbxassetid://" .. selectedBackgroundId
mainFrame.ImageColor3 = Color3.fromRGB(215, 215, 215)
mainFrame.ImageTransparency = 0
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
corner(mainFrame, CORNER)

local backgroundImage = mainFrame

-- Escala de la GUI (aumentar / disminuir)
local uiScale = Instance.new("UIScale")
uiScale.Scale = State.guiScale
uiScale.Parent = mainFrame

-- Borde rojo animado
local borderStroke = Instance.new("UIStroke")
borderStroke.Thickness = 2
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.Parent = mainFrame

local borderGradient = Instance.new("UIGradient")
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 35, 45)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(90, 8, 14)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(190, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 35, 45))})
borderGradient.Parent = borderStroke
TweenService:Create(borderGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

-- Brasas que suben
local emberContainer = Instance.new("Frame")
emberContainer.Size = UDim2.new(1, 0, 1, 0)
emberContainer.BackgroundTransparency = 1
emberContainer.ClipsDescendants = true
emberContainer.ZIndex = 1
emberContainer.Parent = mainFrame

local function createEmber()
    local ember = Instance.new("Frame")
    ember.BackgroundColor3 = Color3.fromRGB(math.random(200, 255), math.random(20, 50), math.random(25, 45))
    ember.BorderSizePixel = 0
    ember.ZIndex = 1
    local size = math.random(2, 3)
    ember.Size = UDim2.new(0, size, 0, size)
    ember.BackgroundTransparency = math.random(4, 8) / 10
    local x = math.random()
    ember.Position = UDim2.new(x, 0, 1.05, 0)
    corner(ember, 3)
    ember.Parent = emberContainer
    local tween = TweenService:Create(ember, TweenInfo.new(math.random(4, 7), Enum.EasingStyle.Linear), {
        Position = UDim2.new(x, 0, -0.05, 0),
        BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function() ember:Destroy() end)
end

task.spawn(function()
    while mainFrame and mainFrame.Parent do
        createEmber()
        task.wait(0.6)
    end
end)

-- Cabecera
local topBar = Instance.new("Frame")
topBar.Name = "Header"
topBar.Size = UDim2.new(1, 0, 0, HEADER_H)
topBar.BackgroundColor3 = COLORS.bgDark
topBar.BackgroundTransparency = 0.35
topBar.BorderSizePixel = 0
topBar.ZIndex = 2
topBar.Parent = mainFrame
corner(topBar, CORNER)

local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, -36, 0, 2)
headerLine.Position = UDim2.new(0, 18, 1, -2)
headerLine.BackgroundColor3 = COLORS.accentHi
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 3
headerLine.Parent = topBar
local lineGradient = Instance.new("UIGradient")
lineGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1)})
lineGradient.Parent = headerLine

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, -60, 0, 24)
titleLabel.Position = UDim2.new(0, 14, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "GHOXT HUB"
titleLabel.TextColor3 = COLORS.accentHi
titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextStrokeTransparency = 0.3
titleLabel.Font = FONT_TITLE
titleLabel.TextSize = 17
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 3
titleLabel.Parent = topBar

local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -60, 0, 14)
subtitleLabel.Position = UDim2.new(0, 14, 0, 30)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "CONFUSER  //  v3"
subtitleLabel.TextColor3 = COLORS.textDim
subtitleLabel.Font = FONT_LABEL
subtitleLabel.TextSize = 11
subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
subtitleLabel.ZIndex = 3
subtitleLabel.Parent = topBar

local minBtn = Instance.new("TextButton")
minBtn.Name = "MinimizeButton"
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -38, 0.5, -14)
minBtn.BackgroundColor3 = COLORS.panel
minBtn.BackgroundTransparency = 0.2
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = COLORS.text
minBtn.Font = FONT_VALUE
minBtn.TextSize = 18
minBtn.AutoButtonColor = false
minBtn.ZIndex = 4
minBtn.Parent = topBar
corner(minBtn, 14)
stroke(minBtn, COLORS.accent, 1)

-- Cuerpo
local body = Instance.new("Frame")
body.Name = "Body"
body.Size = UDim2.new(1, 0, 1, -HEADER_H)
body.Position = UDim2.new(0, 0, 0, HEADER_H)
body.BackgroundTransparency = 1
body.ZIndex = 2
body.Parent = mainFrame

local function makeRow(name, y, h)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(0.92, 0, 0, h)
    row.Position = UDim2.new(0.04, 0, 0, y)
    row.BackgroundColor3 = COLORS.panel
    row.BackgroundTransparency = 0.45
    row.BorderSizePixel = 0
    row.ZIndex = 3
    row.Parent = body
    corner(row, h >= 30 and 14 or 12)
    return row
end

local function makeRowLabel(parent, text, width)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, width or 90, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = COLORS.text
    l.Font = FONT_LABEL
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 4
    l.Parent = parent
    return l
end

-- Estado (punto + texto)
local statusRow = makeRow("StatusRow", 10, 24)
stroke(statusRow, COLORS.stroke, 1)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 10, 0.5, -4)
statusDot.BackgroundColor3 = COLORS.statusOff
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 4
statusDot.Parent = statusRow
corner(statusDot, 4)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -30, 1, 0)
statusLabel.Position = UDim2.new(0, 26, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "STATUS: OFFLINE"
statusLabel.TextColor3 = COLORS.textDim
statusLabel.Font = FONT_LABEL
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 4
statusLabel.Parent = statusRow

-- Botón principal
local activateBtn = Instance.new("TextButton")
activateBtn.Size = UDim2.new(0.92, 0, 0, 42)
activateBtn.Position = UDim2.new(0.04, 0, 0, 42)
activateBtn.BackgroundColor3 = COLORS.accent
activateBtn.BackgroundTransparency = 0.55
activateBtn.Text = "ACTIVATE"
activateBtn.TextColor3 = COLORS.text
activateBtn.Font = FONT_TITLE
activateBtn.TextSize = 12
activateBtn.AutoButtonColor = false
activateBtn.ZIndex = 3
activateBtn.Parent = body
corner(activateBtn, 14)
stroke(activateBtn, COLORS.accentHi, 1.5)

-- Fila de velocidad
local speedRow = makeRow("SpeedRow", 92, 32)
stroke(speedRow, COLORS.stroke, 1)
makeRowLabel(speedRow, "SPEED", 70)

local speedBox = Instance.new("TextBox")
speedBox.Name = "SpeedValue"
speedBox.Size = UDim2.new(1, -92, 1, -10)
speedBox.Position = UDim2.new(0, 82, 0, 5)
speedBox.BackgroundColor3 = COLORS.bgDark
speedBox.BackgroundTransparency = 0.2
speedBox.BorderSizePixel = 0
speedBox.Text = tostring(State.speed)
speedBox.TextColor3 = COLORS.accentHi
speedBox.Font = FONT_VALUE
speedBox.TextSize = 15
speedBox.ClearTextOnFocus = false
speedBox.TextXAlignment = Enum.TextXAlignment.Center
speedBox.ZIndex = 4
speedBox.Parent = speedRow
corner(speedBox, 11)
stroke(speedBox, COLORS.accent, 1)

-- Fila de Active on Steal
local stealRow = makeRow("ActiveOnStealRow", 132, 32)
stroke(stealRow, COLORS.stroke, 1)
makeRowLabel(stealRow, "ACTIVE ON STEAL", 150)

local stealToggle = Instance.new("TextButton")
stealToggle.Size = UDim2.new(0, 42, 0, 20)
stealToggle.Position = UDim2.new(1, -52, 0.5, -10)
stealToggle.BorderSizePixel = 0
stealToggle.Text = ""
stealToggle.AutoButtonColor = false
stealToggle.ZIndex = 4
stealToggle.Parent = stealRow
corner(stealToggle, 10)
local stealKnob = Instance.new("Frame")
stealKnob.Size = UDim2.new(0, 14, 0, 14)
stealKnob.BackgroundColor3 = COLORS.text
stealKnob.BorderSizePixel = 0
stealKnob.ZIndex = 5
stealKnob.Parent = stealToggle
corner(stealKnob, 7)

local function renderStealToggle()
    stealToggle.BackgroundColor3 = State.activeOnSteal and COLORS.toggleOn or COLORS.toggleOff
    stealKnob.Position = State.activeOnSteal and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
end
renderStealToggle()

-- Fila de tecla (keybind)
local keyRow = makeRow("KeybindRow", 172, 32)
stroke(keyRow, COLORS.stroke, 1)
makeRowLabel(keyRow, "KEYBIND", 80)

local keyBtn = Instance.new("TextButton")
keyBtn.Name = "KeybindButton"
keyBtn.Size = UDim2.new(0, 124, 0, 22)
keyBtn.Position = UDim2.new(1, -134, 0.5, -11)
keyBtn.BackgroundColor3 = COLORS.bgDark
keyBtn.BackgroundTransparency = 0.2
keyBtn.BorderSizePixel = 0
keyBtn.Text = toggleKey.Name
keyBtn.TextColor3 = COLORS.accentHi
keyBtn.Font = FONT_VALUE
keyBtn.TextSize = 14
keyBtn.AutoButtonColor = false
keyBtn.ZIndex = 4
keyBtn.Parent = keyRow
corner(keyBtn, 11)
stroke(keyBtn, COLORS.accent, 1)

local listeningForKey = false
local function renderKeybind()
    if listeningForKey then
        keyBtn.Text = "PRESIONA UNA TECLA"
        keyBtn.TextColor3 = COLORS.text
    else
        keyBtn.Text = toggleKey.Name
        keyBtn.TextColor3 = COLORS.accentHi
    end
end
renderKeybind()

keyBtn.Activated:Connect(function()
    listeningForKey = not listeningForKey
    renderKeybind()
end)

-- Fila de tamaño (aumentar / disminuir GUI)
local sizeRow = makeRow("SizeRow", 212, 32)
stroke(sizeRow, COLORS.stroke, 1)
makeRowLabel(sizeRow, "SIZE", 80)

local function makeSizeButton(text, xOffset)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 28, 0, 22)
    b.Position = UDim2.new(1, xOffset, 0.5, -11)
    b.BackgroundColor3 = COLORS.bgDark
    b.BackgroundTransparency = 0.2
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = COLORS.accentHi
    b.Font = FONT_VALUE
    b.TextSize = 18
    b.AutoButtonColor = false
    b.ZIndex = 4
    b.Parent = sizeRow
    corner(b, 11)
    stroke(b, COLORS.accent, 1)
    return b
end

local sizeMinus = makeSizeButton("–", -122)
local sizePlus = makeSizeButton("+", -38)

local sizeValue = Instance.new("TextLabel")
sizeValue.Size = UDim2.new(0, 50, 0, 22)
sizeValue.Position = UDim2.new(1, -92, 0.5, -11)
sizeValue.BackgroundTransparency = 1
sizeValue.Text = "100%"
sizeValue.TextColor3 = COLORS.text
sizeValue.Font = FONT_VALUE
sizeValue.TextSize = 15
sizeValue.ZIndex = 4
sizeValue.Parent = sizeRow

local function setScale(v)
    v = math.clamp(math.floor(v * 10 + 0.5) / 10, SCALE_MIN, SCALE_MAX)
    State.guiScale = v
    uiScale.Scale = v
    sizeValue.Text = math.floor(v * 100 + 0.5) .. "%"
    saveConfig()
end
sizeValue.Text = math.floor(State.guiScale * 100 + 0.5) .. "%"

sizeMinus.Activated:Connect(function() setScale(State.guiScale - SCALE_STEP) end)
sizePlus.Activated:Connect(function() setScale(State.guiScale + SCALE_STEP) end)

-- Selector de fondo
local backgroundTitle = Instance.new("TextLabel")
backgroundTitle.Name = "BackgroundSelectorTitle"
backgroundTitle.Size = UDim2.new(0.92, 0, 0, 16)
backgroundTitle.Position = UDim2.new(0.04, 0, 0, 252)
backgroundTitle.BackgroundTransparency = 1
backgroundTitle.Text = "BACKGROUND"
backgroundTitle.TextColor3 = COLORS.textDim
backgroundTitle.TextStrokeTransparency = 0.5
backgroundTitle.Font = FONT_LABEL
backgroundTitle.TextSize = 12
backgroundTitle.TextXAlignment = Enum.TextXAlignment.Left
backgroundTitle.ZIndex = 3
backgroundTitle.Parent = body

local backgroundPreview = Instance.new("ImageLabel")
backgroundPreview.Name = "BackgroundPreview"
backgroundPreview.Size = UDim2.new(0, 72, 0, 48)
backgroundPreview.Position = UDim2.new(0.04, 0, 0, 272)
backgroundPreview.BackgroundColor3 = COLORS.bgDark
backgroundPreview.BorderSizePixel = 0
backgroundPreview.Image = "rbxassetid://" .. selectedBackgroundId
backgroundPreview.ScaleType = Enum.ScaleType.Crop
backgroundPreview.ZIndex = 3
backgroundPreview.Parent = body
corner(backgroundPreview, 12)
stroke(backgroundPreview, COLORS.accentHi, 1.5)

local selectorButtons = {}
for i, assetId in ipairs(backgroundIds) do
    local button = Instance.new("ImageButton")
    button.Name = "BackgroundOption" .. i
    button.Size = UDim2.new(0, 34, 0, 34)
    button.Position = UDim2.new(0, 98 + (i - 1) * 38, 0, 279)
    button.BackgroundColor3 = COLORS.bgDark
    button.BorderSizePixel = 0
    button.Image = "rbxassetid://" .. assetId
    button.ScaleType = Enum.ScaleType.Crop
    button.AutoButtonColor = true
    button.ZIndex = 4
    button.Parent = body
    corner(button, 17)

    local optionStroke = stroke(button,
        assetId == selectedBackgroundId and COLORS.accentHi or COLORS.stroke,
        assetId == selectedBackgroundId and 2 or 1)

    button.Activated:Connect(function()
        selectedBackgroundId = assetId
        backgroundPreview.Image = "rbxassetid://" .. assetId
        backgroundImage.Image = "rbxassetid://" .. assetId
        backgroundImage.ImageTransparency = 0.85
        TweenService:Create(backgroundImage, TweenInfo.new(0.4), {ImageTransparency = 0}):Play()
        for _, entry in ipairs(selectorButtons) do
            entry.stroke.Color = entry.id == selectedBackgroundId and COLORS.accentHi or COLORS.stroke
            entry.stroke.Thickness = entry.id == selectedBackgroundId and 2 or 1
        end
    end)
    table.insert(selectorButtons, {button = button, stroke = optionStroke, id = assetId})
end

-- Botón de Discord (un tap copia el link)
local discordBtn = Instance.new("TextButton")
discordBtn.Name = "DiscordButton"
discordBtn.Size = UDim2.new(0.92, 0, 0, 34)
discordBtn.Position = UDim2.new(0.04, 0, 1, -44)
discordBtn.BackgroundColor3 = COLORS.bgDark
discordBtn.BackgroundTransparency = 0.25
discordBtn.Text = "DISCORD  •  discord.gg/DhyJ3N6pP"
discordBtn.TextColor3 = COLORS.text
discordBtn.Font = FONT_LABEL
discordBtn.TextSize = 13
discordBtn.AutoButtonColor = false
discordBtn.ZIndex = 4
discordBtn.Parent = mainFrame
corner(discordBtn, 17)
stroke(discordBtn, COLORS.accent, 1)

local function copyToClipboard(text)
    local methods = {
        function() setclipboard(text) end,
        function() toclipboard(text) end,
        function() set_clipboard(text) end,
        function() Clipboard.set(text) end}
    for _, fn in ipairs(methods) do
        if pcall(fn) then return true end
    end
    return false
end

local DISCORD_TEXT = "DISCORD  •  discord.gg/DhyJ3N6pP"
local discordTick = 0
discordBtn.Activated:Connect(function()
    local ok = copyToClipboard(DISCORD_LINK)
    discordTick = discordTick + 1
    local myTick = discordTick
    if ok then
        discordBtn.Text = "LINK COPIADO"
        discordBtn.BackgroundColor3 = COLORS.accent
        discordBtn.BackgroundTransparency = 0.3
    else
        discordBtn.Text = "NO SE PUDO COPIAR"
        print("[GHOXT HUB] Copia este link: " .. DISCORD_LINK)
    end
    task.delay(1.5, function()
        if myTick ~= discordTick then return end
        if discordBtn and discordBtn.Parent then
            discordBtn.Text = DISCORD_TEXT
            discordBtn.BackgroundColor3 = COLORS.bgDark
            discordBtn.BackgroundTransparency = 0.25
        end
    end)
end)

-- Minimizar
local isCollapsed = false
minBtn.Activated:Connect(function()
    isCollapsed = not isCollapsed
    body.Visible = not isCollapsed
    discordBtn.Visible = not isCollapsed
    mainFrame.Size = isCollapsed and UDim2.new(0, FRAME_W, 0, HEADER_H) or UDim2.new(0, FRAME_W, 0, FRAME_H)
    minBtn.Text = isCollapsed and "+" or "–"
end)

----------------------------------------------------------------
-- LÓGICA
----------------------------------------------------------------
local function updateUI()
    if State.confuserOn then
        activateBtn.Text = "ON"
        activateBtn.BackgroundTransparency = 0.1
        activateBtn.TextColor3 = COLORS.text
        statusDot.BackgroundColor3 = COLORS.accentHi
        statusLabel.Text = "STATUS: ACTIVE"
        statusLabel.TextColor3 = COLORS.accentHi
    else
        activateBtn.Text = "ACTIVATE"
        activateBtn.BackgroundTransparency = 0.55
        activateBtn.TextColor3 = COLORS.text
        statusDot.BackgroundColor3 = COLORS.statusOff
        statusLabel.Text = "STATUS: OFFLINE"
        statusLabel.TextColor3 = COLORS.textDim
    end
    local n = tonumber(speedBox.Text) or State.speed
    n = math.max(0, n)
    State.speed = n
end

speedBox.FocusLost:Connect(function()
    local n = tonumber(speedBox.Text)
    if not n then n = State.speed end
    n = math.max(0, n)
    State.speed = n
    speedBox.Text = tostring(n)
    saveConfig()
end)

local function toggleConfuser()
    State.confuserOn = not State.confuserOn
    setConfuser(State.confuserOn)
    updateUI()
    saveConfig()
end

activateBtn.Activated:Connect(toggleConfuser)

local stealActive = false

local function isCarryingBrainrot()
    local char = LP.Character
    return LP:GetAttribute("Stealing") == true
        or (char ~= nil and char:GetAttribute("Stealing") == true)
end

local function endSteal()
    if not stealActive then return end
    stealActive = false
    State.confuserOn = false
    setConfuser(false)
    updateUI()
end

stealToggle.Activated:Connect(function()
    State.activeOnSteal = not State.activeOnSteal
    renderStealToggle()
    if not State.activeOnSteal then endSteal() end
    saveConfig()
end)

task.spawn(function()
    while screenGui and screenGui.Parent do
        task.wait(0.15)
        if State.activeOnSteal then
            local carrying = isCarryingBrainrot()
            if carrying and not stealActive and not State.confuserOn then
                stealActive = true
                State.confuserOn = true
                setConfuser(true)
                updateUI()
            elseif not carrying and stealActive then
                endSteal()
            end
        end
    end
end)

-- Teclas: asignar keybind (modo escucha) y activar/desactivar con la tecla
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if listeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
                toggleKey = input.KeyCode
                saveConfig()
            end
            listeningForKey = false
            renderKeybind()
        end
        return
    end
    if gameProcessed then return end
    if input.KeyCode == toggleKey and (input.UserInputType == Enum.UserInputType.Keyboard
        or input.UserInputType == Enum.UserInputType.Gamepad1
        or input.UserInputType == Enum.UserInputType.Gamepad2) then
        toggleConfuser()
    end
end)

-- Arrastrar desde la cabecera
local isDragging = false
local dragInput, mousePos, framePos

topBar.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not State.lockGui then
        isDragging = true
        mousePos = input.Position
        framePos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                local pos = mainFrame.Position
                State.guiPos = {XScale = pos.X.Scale, XOffset = pos.X.Offset, YScale = pos.Y.Scale, YOffset = pos.Y.Offset}
                saveConfig()
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and isDragging then
        local delta = input.Position - mousePos
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

updateUI()
print("[GHOXT HUB] Loaded — " .. DISCORD_LINK)