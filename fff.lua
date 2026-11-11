-- made by zephyx .gg/blindhub
-- made by zephyx .gg/blindhub

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")
local HttpService  = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

-- made by zephyx .gg/blindhub

local LP = Players.LocalPlayer
local CONFIG_FILE = "RTZPacketLggar_Config.json"

-- made by zephyx .gg/blindhub

-- ============ THEME ============
local RED_MAIN   = Color3.fromRGB(220, 30, 30)
local RED_BRIGHT = Color3.fromRGB(255, 60, 60)
local RED_DEEP   = Color3.fromRGB(140, 10, 10)
local RED_GLOW   = Color3.fromRGB(255, 90, 90)
local BG_BLACK   = Color3.fromRGB(8, 6, 6)
local BG_PANEL   = Color3.fromRGB(18, 10, 10)
local BG_INPUT   = Color3.fromRGB(28, 14, 14)
local BG_HOVER   = Color3.fromRGB(55, 22, 22)
local TEXT_WHITE = Color3.fromRGB(255, 245, 245)
local TEXT_DIM   = Color3.fromRGB(160, 110, 110)
local STROKE_RED = Color3.fromRGB(120, 30, 30)

-- ============ SFX ============
local sfxFolder = Instance.new("Folder")
sfxFolder.Name  = "RTZPacketSFX"
sfxFolder.Parent = SoundService

local function makeSfx(name, id, vol, pitch)
    local s = Instance.new("Sound")
    s.Name          = name
    s.SoundId       = "rbxassetid://" .. tostring(id)
    s.Volume        = vol   or 0.5
    s.PlaybackSpeed = pitch or 1
    s.Parent        = sfxFolder
    return s
end

local SFX = {
    Click   = makeSfx("Click",   9114282417, 0.35, 1.0),
    Hover   = makeSfx("Hover",   9114294822, 0.15, 1.4),
    Start   = makeSfx("Start",   9114300981, 0.55, 0.9),
    Stop    = makeSfx("Stop",    9114303932, 0.45, 0.75),
    Toggle  = makeSfx("Toggle",  9114307441, 0.40, 1.2),
    Keybind = makeSfx("Keybind", 9114310303, 0.40, 1.6),
    Saved   = makeSfx("Saved",   9114313755, 0.40, 1.3),
    Error   = makeSfx("Error",   9114316718, 0.40, 0.6),
}

local function playSfx(name)
    local s = SFX[name]
    if not s then return end
    s:Stop(); s:Play()
end

-- ============ GUI ROOT ============
local gui = Instance.new("ScreenGui")
gui.Name             = "RTZPacketLggar"
gui.ResetOnSpawn     = false
gui.IgnoreGuiInset   = true
gui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder     = 999
gui.Parent           = LP:WaitForChild("PlayerGui")

-- FULL_H حسبناها:
-- TopBar=52, PaddingTop=16, sections end at 232 (pad input bottom),
-- gap=14, StartBtn=52, PaddingBottom=16
-- Total body content = 16 + 232 + 14 + 52 + 16 = 330
-- Main = 52 (topbar) + 330 (body) = 382
local FULL_H = 390
local MINI_H = 124  -- 52 (topbar) + 246 (موضع START) + 52 (ارتفاع START) + 16 (padding)
local WIDE   = 340

-- START يبدأ بعد آخر عنصر مباشرة: 232 + 14 = 246
local START_Y = 246

-- ============ MAIN FRAME ============
local Main = Instance.new("Frame", gui)
Main.Size                = UDim2.new(0, WIDE, 0, FULL_H)
Main.Position            = UDim2.new(0.5, -WIDE/2, 0.5, -FULL_H/2)
Main.BackgroundColor3    = BG_BLACK
Main.BorderSizePixel     = 0
Main.ClipsDescendants    = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color          = STROKE_RED
MainStroke.Thickness      = 1.8
MainStroke.Transparency   = 0.05
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

Instance.new("UIGradient", Main).Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 8, 8)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6,  4, 4)),
}

-- ============ TOP BAR ============
local TopBar = Instance.new("Frame", Main)
TopBar.Size               = UDim2.new(1, 0, 0, 52)
TopBar.BackgroundColor3   = BG_PANEL
TopBar.BackgroundTransparency = 0.1
TopBar.BorderSizePixel    = 0
TopBar.ZIndex             = 2
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local TBMask = Instance.new("Frame", TopBar)
TBMask.Size               = UDim2.new(1, 0, 0, 20)
TBMask.Position           = UDim2.new(0, 0, 1, -20)
TBMask.BackgroundColor3   = BG_PANEL
TBMask.BackgroundTransparency = 0.1
TBMask.BorderSizePixel    = 0
TBMask.ZIndex             = 2

local Stripe = Instance.new("Frame", TopBar)
Stripe.Size               = UDim2.new(1, 0, 0, 2)
Stripe.Position           = UDim2.new(0, 0, 1, -2)
Stripe.BorderSizePixel    = 0
Stripe.BackgroundColor3   = RED_MAIN
Stripe.ZIndex             = 3
local StripeGrad = Instance.new("UIGradient", Stripe)
StripeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   RED_DEEP),
    ColorSequenceKeypoint.new(0.5, RED_BRIGHT),
    ColorSequenceKeypoint.new(1,   RED_DEEP),
}

-- ============ LOCK BADGE ============
local dragLocked = false

local LockBadge = Instance.new("TextButton", TopBar)
LockBadge.Position = UDim2.new(1, -76, 0.5, -14)
LockBadge.Size              = UDim2.new(0, 32, 0, 28)
LockBadge.BorderSizePixel   = 0
LockBadge.Text              = ""
LockBadge.AutoButtonColor   = false
LockBadge.ZIndex            = 4
Instance.new("UICorner", LockBadge).CornerRadius = UDim.new(0, 8)
local LockBadgeStroke = Instance.new("UIStroke", LockBadge)
LockBadgeStroke.Color       = RED_MAIN
LockBadgeStroke.Thickness   = 1
LockBadgeStroke.Transparency = 0.2

local LockIcon = Instance.new("TextLabel", LockBadge)
LockIcon.BackgroundTransparency = 1
LockIcon.Size               = UDim2.new(1, 0, 1, 0)
LockIcon.Text               = "🔓"
LockIcon.Font               = Enum.Font.GothamBlack
LockIcon.TextSize           = 15
LockIcon.TextXAlignment     = Enum.TextXAlignment.Center
LockIcon.TextYAlignment     = Enum.TextYAlignment.Center
LockIcon.TextColor3         = RED_GLOW
LockIcon.ZIndex             = 5

-- Title
local Title = Instance.new("TextLabel", TopBar)
Title.BackgroundTransparency = 1
Title.Position              = UDim2.new(0, 14, 0, 0)
Title.Size                  = UDim2.new(1, -100, 1, 0)
Title.Text                  = "RTZ PACKET Lggar"
Title.Font                  = Enum.Font.GothamBlack
Title.TextSize              = 15
Title.TextXAlignment        = Enum.TextXAlignment.Left
Title.TextYAlignment        = Enum.TextYAlignment.Center
Title.TextColor3            = TEXT_WHITE
Title.ZIndex                = 3

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   TEXT_WHITE),
    ColorSequenceKeypoint.new(0.5, RED_GLOW),
    ColorSequenceKeypoint.new(1,   TEXT_WHITE),
}
task.spawn(function()
    local t = 0
    while TitleGrad.Parent do
        t = t + 0.03
        TitleGrad.Offset = Vector2.new(math.sin(t) * 0.3, 0)
        task.wait(0.03)
    end
end)

-- Collapse button
local CollapseBtn = Instance.new("TextButton", TopBar)
CollapseBtn.Size              = UDim2.new(0, 28, 0, 28)
CollapseBtn.Position          = UDim2.new(1, -38, 0.5, -14)
CollapseBtn.BackgroundColor3  = BG_INPUT
CollapseBtn.BorderSizePixel   = 0
CollapseBtn.Text              = "−"
CollapseBtn.Font              = Enum.Font.GothamBlack
CollapseBtn.TextSize          = 20
CollapseBtn.TextColor3        = TEXT_WHITE
CollapseBtn.AutoButtonColor   = false
CollapseBtn.ZIndex            = 4
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(0, 8)
local CollStroke = Instance.new("UIStroke", CollapseBtn)
CollStroke.Color       = STROKE_RED
CollStroke.Thickness   = 1
CollStroke.Transparency = 0.3

-- ============ BODY ============
local Body = Instance.new("Frame", Main)
Body.Position            = UDim2.new(0, 0, 0, 52)
Body.Size                = UDim2.new(1, 0, 1, -52)
Body.BackgroundTransparency = 1
Body.ZIndex              = 2

local Pad = Instance.new("UIPadding", Body)
Pad.PaddingTop    = UDim.new(0, 16)
Pad.PaddingBottom = UDim.new(0, 16)
Pad.PaddingLeft   = UDim.new(0, 14)
Pad.PaddingRight  = UDim.new(0, 14)

local function makeLabel(parent, text, posY)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.Position               = UDim2.new(0, 0, 0, posY)
    l.Size                   = UDim2.new(1, 0, 0, 14)
    l.Text                   = text
    l.Font                   = Enum.Font.GothamBold
    l.TextSize               = 10
    l.TextXAlignment         = Enum.TextXAlignment.Left
    l.TextColor3             = TEXT_DIM
    l.ZIndex                 = 3
    return l
end

local function makeInputRow(parent, posY, h, mainText, iconText, isTextBox)
    local row = Instance.new("Frame", parent)
    row.Position            = UDim2.new(0, 0, 0, posY)
    row.Size                = UDim2.new(1, 0, 0, h)
    row.BackgroundTransparency = 1

    local iconBtn = Instance.new("TextButton", row)
    iconBtn.Size             = UDim2.new(0, 40, 1, 0)
    iconBtn.Position         = UDim2.new(1, -40, 0, 0)
    iconBtn.BackgroundColor3 = BG_INPUT
    iconBtn.BorderSizePixel  = 0
    iconBtn.Text             = (iconText == "box") and "" or iconText
    iconBtn.Font             = Enum.Font.GothamBlack
    iconBtn.TextSize         = 15
    iconBtn.TextColor3       = TEXT_DIM
    iconBtn.AutoButtonColor  = false
    iconBtn.ZIndex           = 3
    Instance.new("UICorner", iconBtn).CornerRadius = UDim.new(0, 10)
    local is = Instance.new("UIStroke", iconBtn)
    is.Color       = STROKE_RED
    is.Thickness   = 1
    is.Transparency = 0.3

    if iconText == "box" then
    local box = Instance.new("Frame", iconBtn)
    box.Size             = UDim2.new(0, 14, 0, 16)
    box.AnchorPoint      = Vector2.new(0.5, 0.5)
    box.Position         = UDim2.new(0.5, 0, 0.5, 0)
    box.BackgroundColor3 = BG_BLACK
    box.BorderSizePixel  = 0
    box.ZIndex           = 4
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color       = RED_MAIN
    boxStroke.Thickness   = 1.5
    boxStroke.Transparency = 0
end

    local mainEl
    if isTextBox then
        mainEl = Instance.new("TextBox", row)
        mainEl.ClearTextOnFocus = false
        mainEl.PlaceholderText  = "omahad power"
        mainEl.PlaceholderColor3 = TEXT_DIM
    else
        mainEl = Instance.new("TextButton", row)
        mainEl.AutoButtonColor = false
    end
    mainEl.Size             = UDim2.new(1, -48, 1, 0)
    mainEl.Position         = UDim2.new(0, 0, 0, 0)
    mainEl.BackgroundColor3 = BG_INPUT
    mainEl.BorderSizePixel  = 0
    mainEl.Text             = mainText
    mainEl.Font             = Enum.Font.GothamBlack
    mainEl.TextSize         = 16
    mainEl.TextColor3       = RED_GLOW
    mainEl.ZIndex           = 3
    Instance.new("UICorner", mainEl).CornerRadius = UDim.new(0, 10)
    local ms = Instance.new("UIStroke", mainEl)
    ms.Color       = STROKE_RED
    ms.Thickness   = 1
    ms.Transparency = 0.2

    return row, mainEl, iconBtn
end

-- ============ SECTIONS ============
makeLabel(Body, "CHANGE OMAHAD POWER", 0)
local _, IntBox, IntIconBtn = makeInputRow(Body, 20, 44, "10000", "none", true)
IntIconBtn.Visible = false
IntBox.Size        = UDim2.new(1, 0, 1, 0)

local function makeDivider(parent, posY)
    local d = Instance.new("Frame", parent)
    d.Position            = UDim2.new(0, 0, 0, posY)
    d.Size                = UDim2.new(1, 0, 0, 1)
    d.BackgroundColor3    = STROKE_RED
    d.BackgroundTransparency = 0.3
    d.BorderSizePixel     = 0
    d.ZIndex              = 3
end
makeDivider(Body, 74)

makeLabel(Body, "TOGGLE KEYBIND", 84)
local _, KeyBtn, KeyIconBtn = makeInputRow(Body, 104, 44, "V", "↻", false)

makeDivider(Body, 158)

makeLabel(Body, "CONTROLLER KEYBIND (GAMEPAD)", 168)
local _, PadBtn, PadIconBtn = makeInputRow(Body, 188, 44, "⊞  Pad: DPadDown", "↻", false)

-- ============ START BUTTON (موضع ثابت بعد آخر عنصر) ============
-- Pad input ends at 188+44=232, gap=14 → START at 246
local StartBtn = Instance.new("TextButton", Body)
StartBtn.Position = UDim2.new(0, 0, 0, START_Y)
StartBtn.Size               = UDim2.new(1, 0, 0, 52)
StartBtn.BackgroundColor3   = RED_DEEP
StartBtn.BorderSizePixel    = 0
StartBtn.Text               = "START"
StartBtn.Font               = Enum.Font.GothamBlack
StartBtn.TextSize            = 20
StartBtn.TextColor3         = TEXT_WHITE
StartBtn.AutoButtonColor    = false
StartBtn.ZIndex             = 3
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 12)
local StartStroke = Instance.new("UIStroke", StartBtn)
StartStroke.Color       = RED_BRIGHT
StartStroke.Thickness   = 1.5
StartStroke.Transparency = 0.15
local StartGrad = Instance.new("UIGradient", StartBtn)
StartGrad.Rotation = 90
StartGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 20, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 5,  5)),
}

-- ============ STATE ============
local lagging        = false
local lagThread      = nil
local intensity      = 10000
local toggleKey      = Enum.KeyCode.V
local toggleKeyName  = "V"
local padKey         = Enum.KeyCode.DPadDown
local padKeyName     = "DPadDown"
local listeningForKey = false
local listeningForPad = false

local function tween(obj, props, t)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props):Play()
end

local function clampIntensity(v)
    v = tonumber(v)
    if not v then return intensity end
    return math.clamp(math.floor(v), 1, 100000)
end

local function updateIntensity()
    intensity    = clampIntensity(IntBox.Text)
    IntBox.Text  = tostring(intensity)
end

local function keyToName(kc) return kc and kc.Name or "V" end
local function nameToKey(n, def)
    local ok, k = pcall(function() return Enum.KeyCode[n] end)
    return (ok and k) or def
end

local function applyKeybind(name)
    toggleKeyName = name or "V"
    toggleKey     = nameToKey(toggleKeyName, Enum.KeyCode.V)
    KeyBtn.Text   = toggleKeyName
end

local function applyPadBind(name)
    padKeyName = name or "DPadDown"
    padKey     = nameToKey(padKeyName, Enum.KeyCode.DPadDown)
    PadBtn.Text = "Pad: " .. padKeyName
end

-- ============ SAVE / LOAD ============
local function saveConfig()
    updateIntensity()
    local cfg = {
        Intensity  = intensity,
        Keybind    = toggleKeyName,
        PadKeybind = padKeyName,
        DragLocked = dragLocked,
        PX_S = Main.Position.X.Scale, PX_O = Main.Position.X.Offset,
        PY_S = Main.Position.Y.Scale, PY_O = Main.Position.Y.Offset,
    }
    if writefile then
        local ok = pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
        end)
        if ok then playSfx("Saved") else playSfx("Error") end
    else
        playSfx("Error")
    end
end

local function loadConfig()
    if not readfile or not isfile then return end
    if not isfile(CONFIG_FILE) then return end
    local ok, cfg = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not (ok and type(cfg) == "table") then return end
    if tonumber(cfg.Intensity) then
        intensity   = clampIntensity(cfg.Intensity)
        IntBox.Text = tostring(intensity)
    end
    if type(cfg.Keybind)    == "string" and cfg.Keybind    ~= "" then applyKeybind(cfg.Keybind)    end
    if type(cfg.PadKeybind) == "string" and cfg.PadKeybind ~= "" then applyPadBind(cfg.PadKeybind) end
    if type(cfg.DragLocked) == "boolean" then dragLocked = cfg.DragLocked end
    if tonumber(cfg.PX_S) and tonumber(cfg.PX_O)
    and tonumber(cfg.PY_S) and tonumber(cfg.PY_O) then
        Main.Position = UDim2.new(cfg.PX_S, cfg.PX_O, cfg.PY_S, cfg.PY_O)
    end
end

-- ============ EVENT ============
local Event
do
    local ok, net = pcall(function()
        return RS:WaitForChild("Packages"):WaitForChild("Net")
    end)
    if ok and net then Event = net:GetChildren()[230] end
end

-- ============ PAINT ============
local function paintRunning()
    tween(StartBtn, {BackgroundColor3  = RED_DEEP}, 0.15)
    StartGrad.Color = ColorSequence.new{
       ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100,  5,  5)),
    }
    tween(StartStroke, {Transparency = 0}, 0.15)
    StartBtn.Text = "STOP"
end

local function paintIdle()
    tween(StartBtn, {BackgroundColor3 = RED_DEEP}, 0.15)
    StartGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(210, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100,  5,  5)),
    }
    tween(StartStroke, {Transparency = 0.15}, 0.15)
    StartBtn.Text = "START"
end

-- ============ LAG ============
local function startLagging()
    if lagging then return end
    if not Event then playSfx("Error") return end
    updateIntensity()
    lagging = true
    paintRunning()
    playSfx("Start")
    local payload = table.create(intensity, function() end)
    lagThread = task.spawn(function()
        while lagging do
            for _ = 1, 3 do pcall(function() Event:FireServer(payload) end) end
            task.wait(0.01)
        end
    end)
end

local function stopLagging()
    if not lagging then return end
    lagging = false
    if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
    paintIdle()
    playSfx("Stop")
end

-- ============ LOCK LOGIC ============
local function updateLockVisual()
    LockIcon.Text              = dragLocked and "🔒" or "🔓"
    LockIcon.TextColor3        = RED_GLOW
    LockBadge.BackgroundColor3 = Color3.fromRGB(90, 10, 10)
    LockBadgeStroke.Color      = RED_MAIN
end

LockBadge.MouseButton1Click:Connect(function()
    dragLocked = not dragLocked
    playSfx("Toggle")
    updateLockVisual()
    saveConfig()
end)



-- ============ HOVER ============
local function hover(b, onC, offC)
    offC = offC or BG_INPUT
    b.MouseEnter:Connect(function() tween(b, {BackgroundColor3 = onC  }, 0.12); playSfx("Hover") end)
    b.MouseLeave:Connect(function() tween(b, {BackgroundColor3 = offC }, 0.12) end)
end

hover(KeyBtn,    BG_HOVER)
hover(KeyIconBtn,BG_HOVER)
hover(PadBtn,    BG_HOVER)
hover(PadIconBtn,BG_HOVER)
hover(CollapseBtn, BG_HOVER)

StartBtn.MouseEnter:Connect(function()
    tween(StartBtn, {Size = UDim2.new(1, 0, 0, 54)}, 0.12)
    playSfx("Hover")
end)
StartBtn.MouseLeave:Connect(function()
    tween(StartBtn, {Size = UDim2.new(1, 0, 0, 52)}, 0.12)
end)

-- ============ CONNECTIONS ============
IntBox.FocusLost:Connect(function()
    updateIntensity(); playSfx("Click"); saveConfig()
end)

StartBtn.MouseButton1Click:Connect(function()
    playSfx("Click")
    if lagging then stopLagging() else startLagging() end
end)

local function beginListenKey()
    if listeningForKey then return end
    listeningForKey = true
    KeyBtn.Text = "press a key..."
    tween(KeyBtn, {BackgroundColor3 = Color3.fromRGB(80, 20, 20)}, 0.15)
    playSfx("Keybind")
end
KeyBtn.MouseButton1Click:Connect(beginListenKey)
KeyIconBtn.MouseButton1Click:Connect(beginListenKey)

local function beginListenPad()
    if listeningForPad then return end
    listeningForPad = true
    PadBtn.Text = "press a pad button..."
    tween(PadBtn, {BackgroundColor3 = Color3.fromRGB(80, 20, 20)}, 0.15)
    playSfx("Keybind")
end
PadBtn.MouseButton1Click:Connect(beginListenPad)
PadIconBtn.MouseButton1Click:Connect(beginListenPad)

-- ============ INPUT ============
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if listeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            listeningForKey = false
            applyKeybind(keyToName(input.KeyCode))
            tween(KeyBtn, {BackgroundColor3 = BG_INPUT}, 0.15)
            playSfx("Keybind"); saveConfig()
        end
        return
    end

    if listeningForPad then
        if input.UserInputType == Enum.UserInputType.Gamepad1
        or input.UserInputType == Enum.UserInputType.Gamepad2 then
            listeningForPad = false
            applyPadBind(keyToName(input.KeyCode))
            tween(PadBtn, {BackgroundColor3 = BG_INPUT}, 0.15)
            playSfx("Keybind"); saveConfig()
        end
        return
    end

    if input.KeyCode == toggleKey or input.KeyCode == padKey then
        playSfx("Toggle")
        if lagging then stopLagging() else startLagging() end
    end
end)

-- ============ COLLAPSE ============
-- ============ COLLAPSE ============
local collapsed = false
CollapseBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    playSfx("Click")

    for _, child in ipairs(Body:GetChildren()) do
        if child ~= StartBtn and child:IsA("GuiObject") then
            child.Visible = not collapsed
        end
    end

    if collapsed then
        CollapseBtn.Text = "+"
        StartBtn.Position = UDim2.new(0, 0, 0, 4)
        tween(Main, {Size = UDim2.new(0, WIDE, 0, MINI_H)}, 0.28)
    else
        CollapseBtn.Text = "−"
        StartBtn.Position = UDim2.new(0, 0, 0, START_Y)
        tween(Main, {Size = UDim2.new(0, WIDE, 0, FULL_H)}, 0.28)
    end
end)

-- ============ DRAG ============
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if dragLocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false; saveConfig()
            end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and not dragLocked and (
        input.UserInputType == Enum.UserInputType.MouseMovement
     or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- made by zephyx .gg/blindhub

-- ============ INTRO ============
Main.Size               = UDim2.new(0, WIDE, 0, 0)
Main.BackgroundTransparency = 1
task.defer(function()
    loadConfig()
    updateLockVisual()
end)
tween(Main, {Size = UDim2.new(0, WIDE, 0, FULL_H), BackgroundTransparency = 0}, 0.4)
paintIdle()
updateLockVisual()

-- made by zephyx .gg/blindhub