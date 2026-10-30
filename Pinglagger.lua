local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local CONFIG_FILE = "mustpinglagger.json"
local DEFAULT_CFG = {
    power1 = 100000,
    power2 = 97200,
    interval1 = 0.111,
    interval2 = 0.12,
    activePower = 1,
    keybindKb = "F",
    keybindGp = "ButtonR2",
    autoBrainrot = true,
}

local savedUi = {}
local customStroke = nil
local captureUiState

local cfg = {
    power1 = DEFAULT_CFG.power1,
    power2 = DEFAULT_CFG.power2,
    interval1 = DEFAULT_CFG.interval1,
    interval2 = DEFAULT_CFG.interval2,
    activePower = DEFAULT_CFG.activePower,
    power = DEFAULT_CFG.power1,
    interval = DEFAULT_CFG.interval1,
    keybindKb = DEFAULT_CFG.keybindKb,
    keybindGp = DEFAULT_CFG.keybindGp,
    autoBrainrot = DEFAULT_CFG.autoBrainrot,
}

local function resolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function saveConfig()
    if captureUiState then captureUiState() end
    local data = {}
    for k, v in pairs(cfg) do data[k] = v end
    data.ui = savedUi
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if ok and encoded and writefile then pcall(writefile, CONFIG_FILE, encoded) end
end

local function loadConfig()
    if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if not ok or type(data) ~= "table" then return end
    savedUi = type(data.ui) == "table" and data.ui or {}
    
    cfg.power1 = tonumber(data.power1) or DEFAULT_CFG.power1
    cfg.power2 = tonumber(data.power2) or DEFAULT_CFG.power2
    cfg.interval1 = tonumber(data.interval1) or DEFAULT_CFG.interval1
    cfg.interval2 = tonumber(data.interval2) or DEFAULT_CFG.interval2
    cfg.activePower = (tonumber(data.activePower) == 2) and 2 or 1
    cfg.power = cfg.activePower == 2 and cfg.power2 or cfg.power1
    cfg.interval = cfg.activePower == 2 and cfg.interval2 or cfg.interval1
    cfg.keybindKb = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
    cfg.keybindGp = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
    cfg.autoBrainrot = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
end
loadConfig()

local active = false
local listeningFor = nil
local remote = nil
local brainrotMode = false
local lastBrainrotState = false
local manualOverride = false
local pingLoopRunning = false

local PHOTO_ACCENT = Color3.fromRGB(220, 220, 220)
local WHITE = Color3.fromRGB(255,255,255)
local GREEN = Color3.fromRGB(0,220,110)
local RED = Color3.fromRGB(255,110,130)
local TOGGLE_OFF = Color3.fromRGB(40,40,40)
local TOGGLE_KNOB = Color3.fromRGB(240,240,240)

for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "MustPingLaggerGui" then kid:Destroy() end
end

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function makeDraggable(frame, lockFlag)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if lockFlag and lockFlag() then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if captureUiState then captureUiState(); saveConfig() end
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i)
        if lockFlag and lockFlag() then dragging = false; return end
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function isGamepadKeyCode(kc)
    if not kc then return false end
    local name = kc.Name
    return name:find("Button") == 1 or name == "DPadUp" or name == "DPadDown" or name == "DPadLeft" or name == "DPadRight" or name == "ButtonSelect" or name == "ButtonStart" or name == "Thumbstick1" or name == "Thumbstick2"
end

local BLACKLISTED = {[Enum.KeyCode.Escape] = true, [Enum.KeyCode.LeftControl] = true, [Enum.KeyCode.Unknown] = true}

local screen = Instance.new("ScreenGui")
screen.Name = "MustPingLaggerGui"
screen.ResetOnSpawn = false
screen.DisplayOrder = 18
screen.IgnoreGuiInset = true
local okParent = false
if gethui then okParent = pcall(function() screen.Parent = gethui() end) end
if not okParent then pcall(function() screen.Parent = plrGui end) end

local uiLocked = false
local pingMinimized = false
local MAIN_W = 240 
local MAIN_H = 165 
local MIN_HEIGHT = 36

local accent0 = PHOTO_ACCENT
local stroke0 = PHOTO_ACCENT
local rowBg0 = Color3.fromRGB(25,25,25)
local rowBoxBg0 = Color3.fromRGB(15,15,15)

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Name = "CypherMain"
mainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
mainFrame.Position = UDim2.new(0.5, -MAIN_W/2, 0.22, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screen
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 18)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = stroke0
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.2
makeDraggable(mainFrame, function() return uiLocked end)

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,32)
header.BackgroundTransparency = 1
header.ZIndex = 3

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(0, 195, 1, 0)
titleLbl.Position = UDim2.new(0, 14, 0, 0)
titleLbl.BackgroundTransparency = 1
-- NOMBRE ARREGLADO
titleLbl.Text = "MUST PING LAGGER"
titleLbl.TextColor3 = WHITE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 4

local btnContainer = Instance.new("Frame", header)
btnContainer.Size = UDim2.new(0, 60, 0, 20)
btnContainer.Position = UDim2.new(1, -72, 0.5, -10)
btnContainer.BackgroundTransparency = 1
btnContainer.ZIndex = 4
local btnLayout = Instance.new("UIListLayout", btnContainer)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
btnLayout.Padding = UDim.new(0, 6)

local function addStroke(obj, thickness, transparency)
    local s = Instance.new("UIStroke", obj)
    s.Color = stroke0
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.3
    return s
end

local function mkHeaderBtn(text, order, size, textSize)
    local btn = Instance.new("TextButton", btnContainer)
    btn.Size = UDim2.new(0, size or 20, 0, size or 20)
    btn.BackgroundColor3 = rowBg0
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = WHITE
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = textSize or 10
    btn.ZIndex = 5
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    addStroke(btn)
    return btn
end

local minimizeBtn = mkHeaderBtn("—", 1, 20, 11)
local gearBtn = mkHeaderBtn("⚙", 2, 20, 11)

local statusPill = Instance.new("Frame", header)
statusPill.Name = "statusPill"
statusPill.Size = UDim2.new(0, 50, 0, 18)
statusPill.Position = UDim2.new(1, -135, 0.5, -9)
statusPill.BackgroundColor3 = Color3.fromRGB(50,20,40)
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 4
Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size = UDim2.new(1,0,1,0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = RED
statusLbl.Font = Enum.Font.GothamBlack
statusLbl.TextSize = 8
statusLbl.ZIndex = 5

local mainContent = Instance.new("Frame", mainFrame)
mainContent.Size = UDim2.new(1,0,1,-32)
mainContent.Position = UDim2.new(0,0,0,32)
mainContent.BackgroundTransparency = 1
mainContent.ZIndex = 3

-- ==========================================
-- BOTÓN PRINCIPAL TIPO TOGGLE (MÁS GUAPO)
-- ==========================================
local activateBtn = Instance.new("TextButton", mainContent)
activateBtn.Size = UDim2.new(1,-20,0,46) -- Más alto para que se vea mejor
activateBtn.Position = UDim2.new(0,10,0,8)
activateBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
activateBtn.BorderSizePixel = 0
activateBtn.Text = ""
activateBtn.AutoButtonColor = false
activateBtn.ZIndex = 4
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 12)

-- Degradado para que no se vea plano
local btnGradient = Instance.new("UIGradient", activateBtn)
btnGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45,45,45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,15))
}
btnGradient.Rotation = 90

local aStroke = Instance.new("UIStroke", activateBtn)
aStroke.Color = stroke0
aStroke.Thickness = 1.2
aStroke.Transparency = 0.4

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.new(1,-50,1,0)
activateLbl.Position = UDim2.new(0, 16, 0, 0) -- Más espacio a la izquierda
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "PING LAGGER"
activateLbl.TextColor3 = WHITE
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 13 -- Letra un poco más grande
activateLbl.TextXAlignment = Enum.TextXAlignment.Left
activateLbl.ZIndex = 5

-- Toggle visual (Más grande y parecido a iOS)
local toggleDot = Instance.new("Frame", activateBtn)
toggleDot.Size = UDim2.new(0, 26, 0, 16) -- Forma de píldora
toggleDot.Position = UDim2.new(1, -38, 0.5, -8)
toggleDot.BackgroundColor3 = TOGGLE_OFF
toggleDot.BorderSizePixel = 0
toggleDot.ZIndex = 5
Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1,0)

local toggleKnob = Instance.new("Frame", toggleDot)
toggleKnob.Size = UDim2.new(0, 12, 0, 12) -- Círculo interior
toggleKnob.Position = UDim2.new(0, 2, 0.5, -6)
toggleKnob.BackgroundColor3 = TOGGLE_KNOB
toggleKnob.BorderSizePixel = 0
toggleKnob.ZIndex = 6
Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1,0)

-- BOTONES UNLOCK Y LOCK ABAJO
local bottomBtnContainer = Instance.new("Frame", mainContent)
bottomBtnContainer.Size = UDim2.new(1,-20,0,38)
bottomBtnContainer.Position = UDim2.new(0,10,1,-48)
bottomBtnContainer.BackgroundTransparency = 1
bottomBtnContainer.ZIndex = 4
local bottomLayout = Instance.new("UIListLayout", bottomBtnContainer)
bottomLayout.FillDirection = Enum.FillDirection.Horizontal
bottomLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
bottomLayout.Padding = UDim.new(0, 10)

local unlockBtn = Instance.new("TextButton", bottomBtnContainer)
unlockBtn.Size = UDim2.new(0.48,0,1,0)
unlockBtn.BackgroundColor3 = Color3.fromRGB(30,100,50)
unlockBtn.Text = "🔓 UNLOCK"
unlockBtn.TextColor3 = WHITE
unlockBtn.Font = Enum.Font.GothamBlack
unlockBtn.TextSize = 11
unlockBtn.ZIndex = 5
Instance.new("UICorner", unlockBtn).CornerRadius = UDim.new(0, 10)

local lockBtn = Instance.new("TextButton", bottomBtnContainer)
lockBtn.Size = UDim2.new(0.48,0,1,0)
lockBtn.BackgroundColor3 = Color3.fromRGB(100,30,30)
lockBtn.Text = "🔒 LOCK"
lockBtn.TextColor3 = WHITE
lockBtn.Font = Enum.Font.GothamBlack
lockBtn.TextSize = 11
lockBtn.ZIndex = 5
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 10)

local function updateToggleButton()
    if active then
        activateLbl.Text = "PING LAGGER"
        aStroke.Transparency = 0.1
        aStroke.Color = GREEN
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 60, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 20))
        } -- Degradado verde cuando está ON
        statusLbl.Text = "ON"
        statusLbl.TextColor3 = GREEN
        statusPill.BackgroundColor3 = Color3.fromRGB(20,50,35)
        toggleDot.BackgroundColor3 = GREEN
        tw(toggleKnob, {Position = UDim2.new(1,-14,0.5,-6)}, 0.15)
    else
        activateLbl.Text = "PING LAGGER"
        aStroke.Transparency = 0.4
        aStroke.Color = stroke0
        btnGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(45,45,45)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,15))
        } -- Degradado gris cuando está OFF
        statusLbl.Text = "OFF"
        statusLbl.TextColor3 = RED
        statusPill.BackgroundColor3 = Color3.fromRGB(50,20,40)
        toggleDot.BackgroundColor3 = TOGGLE_OFF
        tw(toggleKnob, {Position = UDim2.new(0,2,0.5,-6)}, 0.15)
    end
end

-- VENTANA DE AJUSTES
local SET_W, SET_H = 220, 310
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "CypherSettings"
settingsFrame.Size = UDim2.new(0, SET_W, 0, SET_H)
settingsFrame.Position = UDim2.new(0.5, -SET_W/2, 0.22, MAIN_H + 12)
settingsFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
settingsFrame.BackgroundTransparency = 0.1
settingsFrame.BorderSizePixel = 0
settingsFrame.Active = true
settingsFrame.ClipsDescendants = true
settingsFrame.Visible = false
settingsFrame.ZIndex = 20
settingsFrame.Parent = screen
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 18)
local ss = Instance.new("UIStroke", settingsFrame)
ss.Color = stroke0
ss.Thickness = 1.3
ss.Transparency = 0.2
makeDraggable(settingsFrame)

captureUiState = function()
    local function posOf(obj) return {xs=obj.Position.X.Scale, xo=obj.Position.X.Offset, ys=obj.Position.Y.Scale, yo=obj.Position.Y.Offset} end
    savedUi.mainPos = posOf(mainFrame)
    savedUi.settingsPos = posOf(settingsFrame)
end

local function restorePos(obj, value)
    if type(value) == "table" then obj.Position = UDim2.new(tonumber(value.xs) or obj.Position.X.Scale, tonumber(value.xo) or obj.Position.X.Offset, tonumber(value.ys) or obj.Position.Y.Scale, tonumber(value.yo) or obj.Position.Y.Offset) end
end
restorePos(mainFrame, savedUi.mainPos)
restorePos(settingsFrame, savedUi.settingsPos)

local setHeader = Instance.new("Frame", settingsFrame)
setHeader.Size = UDim2.new(1,0,0,32)
setHeader.BackgroundTransparency = 1
setHeader.ZIndex = 21

local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size = UDim2.new(1,-30,1,0)
setTitle.Position = UDim2.new(0,14,0,0)
setTitle.BackgroundTransparency = 1
setTitle.Text = "AJUSTES"
setTitle.TextColor3 = stroke0
setTitle.Font = Enum.Font.GothamBlack
setTitle.TextSize = 12
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.ZIndex = 22

local setCloseBtn = Instance.new("TextButton", setHeader)
setCloseBtn.Size = UDim2.new(0,20,0,20)
setCloseBtn.Position = UDim2.new(1,-26,0.5,-10)
setCloseBtn.BackgroundColor3 = rowBg0
setCloseBtn.Text = "X"
setCloseBtn.TextColor3 = WHITE
setCloseBtn.Font = Enum.Font.GothamBlack
setCloseBtn.TextSize = 10
setCloseBtn.ZIndex = 23
setCloseBtn.BorderSizePixel = 0
Instance.new("UICorner", setCloseBtn).CornerRadius = UDim.new(1, 0)
addStroke(setCloseBtn)
setCloseBtn.MouseButton1Click:Connect(function() settingsFrame.Visible = false end)

local content = Instance.new("Frame", settingsFrame)
content.Size = UDim2.new(1,-16,1,-40)
content.Position = UDim2.new(0,8,0,38)
content.BackgroundTransparency = 1
content.ZIndex = 21

-- 1. Botones V1 y V2
local versionRow = Instance.new("Frame", content)
versionRow.Size = UDim2.new(1,0,0,30)
versionRow.Position = UDim2.new(0,0,0,0)
versionRow.BackgroundColor3 = rowBg0
versionRow.BackgroundTransparency = 0.3
versionRow.BorderSizePixel = 0
versionRow.ZIndex = 22
Instance.new("UICorner", versionRow).CornerRadius = UDim.new(0, 10)

local v1Btn = Instance.new("TextButton", versionRow)
v1Btn.Size = UDim2.new(0.5,-2,1,-4)
v1Btn.Position = UDim2.new(0,2,0,2)
v1Btn.BackgroundColor3 = rowBoxBg0
v1Btn.Text = "V1"
v1Btn.TextColor3 = WHITE
v1Btn.Font = Enum.Font.GothamBlack
v1Btn.TextSize = 11
v1Btn.ZIndex = 23
Instance.new("UICorner", v1Btn).CornerRadius = UDim.new(0, 8)

local v2Btn = Instance.new("TextButton", versionRow)
v2Btn.Size = UDim2.new(0.5,-2,1,-4)
v2Btn.Position = UDim2.new(0.5,2,0,2)
v2Btn.BackgroundColor3 = rowBoxBg0
v2Btn.Text = "V2"
v2Btn.TextColor3 = WHITE
v2Btn.Font = Enum.Font.GothamBlack
v2Btn.TextSize = 11
v2Btn.ZIndex = 23
Instance.new("UICorner", v2Btn).CornerRadius = UDim.new(0, 8)

-- 2. Cajas de Texto (Power y Delay)
local function mkInput(y, placeholder, value)
    local box = Instance.new("TextBox", content)
    box.Size = UDim2.new(1,0,0,28)
    box.Position = UDim2.new(0,0,0,y)
    box.BackgroundColor3 = rowBg0
    box.BackgroundTransparency = 0.3
    box.BorderSizePixel = 0
    box.PlaceholderText = placeholder
    box.Text = tostring(value)
    box.TextColor3 = stroke0
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    box.ClearTextOnFocus = false
    box.ZIndex = 22
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    addStroke(box, 1, 0.3)
    return box
end

local powerBox = mkInput(36, "POWER", cfg.power1)
local delayBox = mkInput(68, "DELAY", cfg.interval1)

-- 3. Auto Brainrot Toggle
local brainrotRow = Instance.new("Frame", content)
brainrotRow.Size = UDim2.new(1,0,0,28)
brainrotRow.Position = UDim2.new(0,0,0,100)
brainrotRow.BackgroundColor3 = rowBg0
brainrotRow.BackgroundTransparency = 0.3
brainrotRow.BorderSizePixel = 0
brainrotRow.ZIndex = 22
Instance.new("UICorner", brainrotRow).CornerRadius = UDim.new(0, 8)

local brainrotLbl = Instance.new("TextLabel", brainrotRow)
brainrotLbl.Size = UDim2.new(0.7,0,1,0)
brainrotLbl.Position = UDim2.new(0,10,0,0)
brainrotLbl.BackgroundTransparency = 1
brainrotLbl.Text = "AUTO BRAINROT"
brainrotLbl.TextColor3 = WHITE
brainrotLbl.Font = Enum.Font.GothamBold
brainrotLbl.TextSize = 9
brainrotLbl.TextXAlignment = Enum.TextXAlignment.Left
brainrotLbl.ZIndex = 23

local brainrotToggle = Instance.new("TextButton", brainrotRow)
brainrotToggle.Size = UDim2.new(0,40,0,20)
brainrotToggle.Position = UDim2.new(1,-50,0.5,-10)
brainrotToggle.BackgroundColor3 = cfg.autoBrainrot and GREEN or TOGGLE_OFF
brainrotToggle.BorderSizePixel = 0
brainrotToggle.Text = ""
brainrotToggle.AutoButtonColor = false
brainrotToggle.ZIndex = 24
Instance.new("UICorner", brainrotToggle).CornerRadius = UDim.new(1, 0)

local brKnob = Instance.new("Frame", brainrotToggle)
brKnob.Size = UDim2.new(0,16,0,16)
brKnob.Position = cfg.autoBrainrot and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
brKnob.BackgroundColor3 = TOGGLE_KNOB
brKnob.BorderSizePixel = 0
brKnob.ZIndex = 26
Instance.new("UICorner", brKnob).CornerRadius = UDim.new(1, 0)

-- 4. Texto de Versión Elegida
local versionStatus = Instance.new("TextLabel", content)
versionStatus.Size = UDim2.new(1, 0, 0, 22)
versionStatus.Position = UDim2.new(0, 0, 0, 136)
versionStatus.BackgroundColor3 = rowBg0
versionStatus.BackgroundTransparency = 0.5
versionStatus.BorderSizePixel = 0
versionStatus.Text = "VERSIÓN ELEGIDA: V1"
versionStatus.TextColor3 = stroke0
versionStatus.Font = Enum.Font.GothamBlack
versionStatus.TextSize = 9
versionStatus.ZIndex = 22
Instance.new("UICorner", versionStatus).CornerRadius = UDim.new(0, 8)

-- Lógica de actualización de cajas y versiones
local function updateVersionUI()
    if cfg.activePower == 1 then
        v1Btn.BackgroundColor3 = PHOTO_ACCENT
        v1Btn.TextColor3 = Color3.fromRGB(0,0,0)
        v2Btn.BackgroundColor3 = rowBoxBg0
        v2Btn.TextColor3 = WHITE
        versionStatus.Text = "VERSIÓN ELEGIDA: V1"
        powerBox.Text = tostring(cfg.power1)
        delayBox.Text = tostring(cfg.interval1)
    else
        v1Btn.BackgroundColor3 = rowBoxBg0
        v1Btn.TextColor3 = WHITE
        v2Btn.BackgroundColor3 = PHOTO_ACCENT
        v2Btn.TextColor3 = Color3.fromRGB(0,0,0)
        versionStatus.Text = "VERSIÓN ELEGIDA: V2"
        powerBox.Text = tostring(cfg.power2)
        delayBox.Text = tostring(cfg.interval2)
    end
    cfg.power = cfg.activePower == 2 and cfg.power2 or cfg.power1
    cfg.interval = cfg.activePower == 2 and cfg.interval2 or cfg.interval1
end

v1Btn.MouseButton1Click:Connect(function()
    cfg.activePower = 1
    updateVersionUI()
    saveConfig()
end)

v2Btn.MouseButton1Click:Connect(function()
    cfg.activePower = 2
    updateVersionUI()
    saveConfig()
end)

powerBox.FocusLost:Connect(function()
    local val = tonumber(powerBox.Text)
    if val then
        if cfg.activePower == 1 then cfg.power1 = val else cfg.power2 = val end
        cfg.power = cfg.activePower == 2 and cfg.power2 or cfg.power1
        saveConfig()
    end
end)

delayBox.FocusLost:Connect(function()
    local val = tonumber(delayBox.Text)
    if val then
        if cfg.activePower == 1 then cfg.interval1 = val else cfg.interval2 = val end
        cfg.interval = cfg.activePower == 2 and cfg.interval2 or cfg.interval1
        saveConfig()
    end
end)

brainrotToggle.MouseButton1Click:Connect(function()
    cfg.autoBrainrot = not cfg.autoBrainrot
    if cfg.autoBrainrot then
        tw(brainrotToggle, {BackgroundColor3 = GREEN}, 0.15)
        tw(brKnob, {Position = UDim2.new(1,-18,0.5,-8)}, 0.15)
    else
        tw(brainrotToggle, {BackgroundColor3 = TOGGLE_OFF}, 0.15)
        tw(brKnob, {Position = UDim2.new(0,2,0.5,-8)}, 0.15)
        if active then flipLag(false, false) end
    end
    saveConfig()
end)

-- 5. Keybinds
local function mkKeybindRow(y, label, current)
    local row = Instance.new("Frame", content)
    row.Size = UDim2.new(1,0,0,28)
    row.Position = UDim2.new(0,0,0,y)
    row.BackgroundColor3 = rowBg0
    row.BackgroundTransparency = 0.3
    row.BorderSizePixel = 0
    row.ZIndex = 22
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.5,0,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23

    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0,84,0,20)
    btn.Position = UDim2.new(1,-94,0.5,-10)
    btn.BackgroundColor3 = rowBoxBg0
    btn.BackgroundTransparency = 0.25
    btn.BorderSizePixel = 0
    btn.Text = current
    btn.TextColor3 = stroke0
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.ZIndex = 24
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    addStroke(btn, 1, 0.3)
    return btn
end

local kbBtn = mkKeybindRow(166, "KEYBOARD", cfg.keybindKb)
local gpBtn = mkKeybindRow(200, "CONTROLLER", cfg.keybindGp)

kbBtn.MouseButton1Click:Connect(function()
    listeningFor = (listeningFor == "kb") and nil or "kb"
    kbBtn.Text = listeningFor == "kb" and "[?]" or cfg.keybindKb
end)

gpBtn.MouseButton1Click:Connect(function()
    listeningFor = (listeningFor == "gp") and nil or "gp"
    gpBtn.Text = listeningFor == "gp" and "[?]" or cfg.keybindGp
end)

-- BOTÓN DE RESET
local resetBtn = Instance.new("TextButton", content)
resetBtn.Size = UDim2.new(1,0,0,26)
resetBtn.Position = UDim2.new(0,0,0,236)
resetBtn.BackgroundColor3 = rowBg0
resetBtn.BackgroundTransparency = 0.3
resetBtn.BorderSizePixel = 0
resetBtn.AutoButtonColor = false
resetBtn.Text = "RESET DEFAULTS"
resetBtn.TextColor3 = WHITE
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 9
resetBtn.ZIndex = 22
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 8)
addStroke(resetBtn, 1, 0.3)
resetBtn.MouseButton1Click:Connect(function()
    cfg.power1 = DEFAULT_CFG.power1
    cfg.power2 = DEFAULT_CFG.power2
    cfg.interval1 = DEFAULT_CFG.interval1
    cfg.interval2 = DEFAULT_CFG.interval2
    cfg.activePower = DEFAULT_CFG.activePower
    cfg.keybindKb = DEFAULT_CFG.keybindKb
    cfg.keybindGp = DEFAULT_CFG.keybindGp
    cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
    kbBtn.Text = cfg.keybindKb
    gpBtn.Text = cfg.keybindGp
    brainrotToggle.BackgroundColor3 = cfg.autoBrainrot and GREEN or TOGGLE_OFF
    brKnob.Position = cfg.autoBrainrot and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    updateVersionUI()
    saveConfig()
end)

-- LÓGICA DEL JUEGO (REMOTE Y LOOP)
local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local found = nil
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent") or r:IsA("RemoteFunction")) then found = r break end
    end
    if not found then
        for _, c in ipairs(rrs:GetChildren()) do
            if (c:IsA("RemoteEvent") or c:IsA("UnreliableRemoteEvent") or c:IsA("RemoteFunction")) and c.Name:find("Block") then found = c break end
        end
    end
    return found
end
remote = findRemote()

local function buildPayload(power)
    local safePower = tonumber(power) or DEFAULT_CFG.power1
    if safePower < 1 then safePower = 1 end
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(safePower / 188), 10000)
    if maxRep < 1 then maxRep = 1 end
    for _ = 1, maxRep do table.insert(main, nested) end
    return main
end

local function runPingLoop()
    if not active or not remote then pingLoopRunning = false return end
    pingLoopRunning = true
    local currentDelay = tonumber(cfg.interval) or DEFAULT_CFG.interval1
    while active and remote and pingLoopRunning do
        local payload = buildPayload(cfg.power)
        local ok = pcall(function()
            if remote:IsA("RemoteFunction") then remote:InvokeServer(payload) else remote:FireServer(payload) end
        end)
        if not ok then
            currentDelay = math.min(currentDelay * 1.5, 0.5)
        else
            currentDelay = math.max(currentDelay * 0.995, 0.05)
        end
        task.wait(currentDelay)
    end
    pingLoopRunning = false
end

local function flipLag(state, isManual)
    if not state and pingLoopRunning then pingLoopRunning = false end
    active = state
    if isManual then
        if brainrotMode then manualOverride = not state else manualOverride = false end
    end
    if active then
        if not remote then
            remote = findRemote()
            if not remote then active = false updateToggleButton() return end
        end
        updateToggleButton()
        task.spawn(runPingLoop)
    else
        updateToggleButton()
    end
end

activateBtn.MouseButton1Click:Connect(function() flipLag(not active, true) end)

-- LÓGICA DE LOS BOTONES DE ABAJO
unlockBtn.MouseButton1Click:Connect(function()
    uiLocked = false
    mainStroke.Transparency = 0.2
    unlockBtn.BackgroundColor3 = Color3.fromRGB(30,100,50)
    lockBtn.BackgroundColor3 = Color3.fromRGB(100,30,30)
end)

lockBtn.MouseButton1Click:Connect(function()
    uiLocked = true
    mainStroke.Transparency = 0.05
    lockBtn.BackgroundColor3 = Color3.fromRGB(150,40,40)
    unlockBtn.BackgroundColor3 = Color3.fromRGB(40,60,40)
end)

minimizeBtn.MouseButton1Click:Connect(function()
    if pingMinimized then
        pingMinimized = false
        mainContent.Visible = true
        mainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
        minimizeBtn.Text = "—"
    else
        pingMinimized = true
        mainContent.Visible = false
        mainFrame.Size = UDim2.new(0, MAIN_W, 0, MIN_HEIGHT)
        minimizeBtn.Text = "+"
    end
end)

gearBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

-- AUTO BRAINROT LOOP
RunService.Heartbeat:Connect(function()
    if not cfg.autoBrainrot then
        if brainrotMode then
            brainrotMode = false
            lastBrainrotState = false
            if active then flipLag(false, false) end
        end
        return
    end
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local currentSpeed = hum.WalkSpeed
    if currentSpeed < 25 then
        if not lastBrainrotState then
            brainrotMode = true
            lastBrainrotState = true
            manualOverride = false
            if not active then flipLag(true, false) end
        end
    else
        if lastBrainrotState then
            brainrotMode = false
            lastBrainrotState = false
            manualOverride = false
            if active then flipLag(false, false) end
        end
    end
end)

-- INPUTS (Keybinds)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard
    local isGp = isGamepadKeyCode(kc)

    if listeningFor then
        local newKey = nil
        if isKb then newKey = kc elseif isGp then newKey = kc end
        if newKey and not BLACKLISTED[kc] then
            if listeningFor == "gp" then
                cfg.keybindGp = newKey.Name
                gpBtn.Text = newKey.Name
            else
                cfg.keybindKb = newKey.Name
                kbBtn.Text = newKey.Name
            end
            listeningFor = nil
            saveConfig()
        end
        return
    end

    if kc == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible then settingsFrame.Visible = false end
        return
    end

    local kbEnum = resolveKb(cfg.keybindKb)
    local gpEnum = resolveKb(cfg.keybindGp)
    if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
        flipLag(not active, true)
    end
end)

updateToggleButton()
updateVersionUI()