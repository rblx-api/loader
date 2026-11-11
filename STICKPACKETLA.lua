local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")
local HttpService  = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local LP = Players.LocalPlayer
local CONFIG_FILE = "ZyroxPacketLagger_Config.json"

-- ============ THEME (BLACK & WHITE) ============
local PURE_WHITE = Color3.fromRGB(255, 255, 255)
local OFF_WHITE  = Color3.fromRGB(225, 225, 225)
local BG_BLACK   = Color3.fromRGB(8, 8, 8)
local BG_PANEL   = Color3.fromRGB(18, 18, 18)
local BG_INPUT   = Color3.fromRGB(30, 30, 30)
local BG_HOVER   = Color3.fromRGB(48, 48, 48)
local TEXT_WHITE = Color3.fromRGB(245, 245, 245)
local TEXT_DIM   = Color3.fromRGB(140, 140, 140)
local STROKE_W   = Color3.fromRGB(70, 70, 70)

-- ============ SFX ============
local sfxFolder = Instance.new("Folder")
sfxFolder.Name = "ZyroxSFX"
sfxFolder.Parent = SoundService

local function makeSfx(name, id, vol, pitch)
    local s = Instance.new("Sound")
    s.Name = name
    s.SoundId = "rbxassetid://" .. tostring(id)
    s.Volume = vol or 0.5
    s.PlaybackSpeed = pitch or 1
    s.Parent = sfxFolder
    return s
end

local SFX = {
    Click     = makeSfx("Click",     9114282417, 0.35, 1.0),
    Hover     = makeSfx("Hover",     9114294822, 0.15, 1.4),
    Start     = makeSfx("Start",     9114300981, 0.55, 0.9),
    Stop      = makeSfx("Stop",      9114303932, 0.45, 0.75),
    Toggle    = makeSfx("Toggle",    9114307441, 0.40, 1.2),
    Keybind   = makeSfx("Keybind",   9114310303, 0.40, 1.6),
    Saved     = makeSfx("Saved",     9114313755, 0.40, 1.3),
    Error     = makeSfx("Error",     9114316718, 0.40, 0.6),
}

local function playSfx(name)
    local s = SFX[name]
    if not s then return end
    s:Stop()
    s:Play()
end

-- ============ SIZES ============
local W           = 280
local FULL_H      = 120
local MINI_H      = 48
local SETTINGS_H  = 250

-- ============ GUI ============
local gui = Instance.new("ScreenGui")
gui.Name = "ZyroxPacketLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = LP:WaitForChild("PlayerGui")

local Main = Instance.new("Frame", gui)
Main.Size = UDim2.new(0, W, 0, FULL_H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -FULL_H/2)
Main.BackgroundColor3 = BG_BLACK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = STROKE_W
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.1
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainGrad = Instance.new("UIGradient", Main)
MainGrad.Rotation = 135
MainGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(14, 14, 14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 4)),
}

-- ============ PARTICLES ============
local Particles = Instance.new("Frame", Main)
Particles.Size = UDim2.new(1, 0, 1, 0)
Particles.BackgroundTransparency = 1
Particles.ZIndex = 0
Particles.ClipsDescendants = true
Instance.new("UICorner", Particles).CornerRadius = UDim.new(0, 14)

local function spawnFlake()
    local dot = Instance.new("Frame", Particles)
    local size = math.random(1, 3)
    dot.Size = UDim2.new(0, size, 0, size)
    dot.BackgroundColor3 = PURE_WHITE
    dot.BackgroundTransparency = math.random(65, 92) / 100
    dot.BorderSizePixel = 0
    dot.ZIndex = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local startX = math.random() * 1.1 - 0.05
    local drift = (math.random(-20, 20)) / 100
    local dur = math.random(5, 11) / 1

    dot.Position = UDim2.new(startX, 0, -0.05, 0)

    local info = TweenInfo.new(dur, Enum.EasingStyle.Linear)
    local fall = TweenService:Create(dot, info, {
        Position = UDim2.new(startX + drift, 0, 1.05, 0),
        BackgroundTransparency = 1,
    })
    fall:Play()
    fall.Completed:Connect(function()
        dot:Destroy()
    end)
end

task.spawn(function()
    while Particles.Parent do
        spawnFlake()
        task.wait(math.random(10, 24) / 100)
    end
end)

-- ============ TOP BAR ============
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 48)
TopBar.BackgroundColor3 = BG_PANEL
TopBar.BackgroundTransparency = 0.35
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 2
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

local TopBarMask = Instance.new("Frame", TopBar)
TopBarMask.Size = UDim2.new(1, 0, 0, 20)
TopBarMask.Position = UDim2.new(0, 0, 1, -20)
TopBarMask.BackgroundColor3 = BG_PANEL
TopBarMask.BackgroundTransparency = 0.35
TopBarMask.BorderSizePixel = 0
TopBarMask.ZIndex = 2

local Stripe = Instance.new("Frame", TopBar)
Stripe.Size = UDim2.new(1, -24, 0, 2)
Stripe.Position = UDim2.new(0, 12, 1, -2)
Stripe.BorderSizePixel = 0
Stripe.BackgroundColor3 = PURE_WHITE
Stripe.ZIndex = 3
Instance.new("UICorner", Stripe).CornerRadius = UDim.new(1, 0)
local StripeGrad = Instance.new("UIGradient", Stripe)
StripeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
    ColorSequenceKeypoint.new(0.5, PURE_WHITE),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80)),
}

local Title = Instance.new("TextLabel", TopBar)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 14, 0, 0)
Title.Size = UDim2.new(1, -92, 1, 0)
Title.Text = "ZYROX"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.TextColor3 = TEXT_WHITE
Title.ZIndex = 3

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, TEXT_WHITE),
    ColorSequenceKeypoint.new(0.5, OFF_WHITE),
    ColorSequenceKeypoint.new(1, TEXT_WHITE),
}

task.spawn(function()
    local t = 0
    while TitleGrad.Parent do
        t = t + 0.03
        TitleGrad.Offset = Vector2.new(math.sin(t) * 0.3, 0)
        task.wait(0.03)
    end
end)

local SettingsBtn = Instance.new("TextButton", TopBar)
SettingsBtn.Size = UDim2.new(0, 24, 0, 24)
SettingsBtn.Position = UDim2.new(1, -56, 0.5, -12)
SettingsBtn.BackgroundColor3 = BG_INPUT
SettingsBtn.BorderSizePixel = 0
SettingsBtn.Text = "⚙"
SettingsBtn.Font = Enum.Font.GothamBlack
SettingsBtn.TextSize = 13
SettingsBtn.TextColor3 = TEXT_WHITE
SettingsBtn.AutoButtonColor = false
SettingsBtn.ZIndex = 4
Instance.new("UICorner", SettingsBtn).CornerRadius = UDim.new(0, 7)
local SettingsStroke = Instance.new("UIStroke", SettingsBtn)
SettingsStroke.Color = STROKE_W
SettingsStroke.Thickness = 1
SettingsStroke.Transparency = 0.3

local CollapseBtn = Instance.new("TextButton", TopBar)
CollapseBtn.Size = UDim2.new(0, 24, 0, 24)
CollapseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CollapseBtn.BackgroundColor3 = BG_INPUT
CollapseBtn.BorderSizePixel = 0
CollapseBtn.Text = "−"
CollapseBtn.Font = Enum.Font.GothamBlack
CollapseBtn.TextSize = 16
CollapseBtn.TextColor3 = TEXT_WHITE
CollapseBtn.AutoButtonColor = false
CollapseBtn.ZIndex = 4
Instance.new("UICorner", CollapseBtn).CornerRadius = UDim.new(0, 7)

-- ============ BODY ============
local Body = Instance.new("Frame", Main)
Body.Position = UDim2.new(0, 0, 0, 48)
Body.Size = UDim2.new(1, 0, 1, -48)
Body.BackgroundTransparency = 1
Body.ZIndex = 2

-- ============ MAIN VIEW ============
local MainView = Instance.new("Frame", Body)
MainView.Size = UDim2.new(1, 0, 1, 0)
MainView.BackgroundTransparency = 1
MainView.ZIndex = 2

local PadM = Instance.new("UIPadding", MainView)
PadM.PaddingTop = UDim.new(0, 10)
PadM.PaddingBottom = UDim.new(0, 10)
PadM.PaddingLeft = UDim.new(0, 16)
PadM.PaddingRight = UDim.new(0, 16)

local ToggleRow = Instance.new("Frame", MainView)
ToggleRow.Size = UDim2.new(1, 0, 1, 0)
ToggleRow.BackgroundTransparency = 1

local ToggleLabel = Instance.new("TextLabel", ToggleRow)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Size = UDim2.new(1, -68, 1, 0)
ToggleLabel.Text = "PACKET LAGGER"
ToggleLabel.Font = Enum.Font.GothamBlack
ToggleLabel.TextSize = 16
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.TextYAlignment = Enum.TextYAlignment.Center
ToggleLabel.TextColor3 = TEXT_WHITE

local ToggleBtn = Instance.new("TextButton", ToggleRow)
ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
ToggleBtn.Position = UDim2.new(1, 0, 0.5, 0)
ToggleBtn.Size = UDim2.new(0, 56, 0, 26)
ToggleBtn.Text = ""
ToggleBtn.BackgroundColor3 = BG_INPUT
ToggleBtn.BorderSizePixel = 0
ToggleBtn.AutoButtonColor = false
ToggleBtn.ZIndex = 3
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Color = STROKE_W
ToggleStroke.Thickness = 1.5
ToggleStroke.Transparency = 0.3

local Knob = Instance.new("Frame", ToggleBtn)
Knob.Size = UDim2.new(0, 20, 0, 20)
Knob.Position = UDim2.new(0, 3, 0.5, -10)
Knob.BackgroundColor3 = TEXT_WHITE
Knob.BorderSizePixel = 0
Knob.ZIndex = 4
Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

-- ============ SETTINGS VIEW ============
local SettingsView = Instance.new("Frame", Body)
SettingsView.Size = UDim2.new(1, 0, 1, 0)
SettingsView.BackgroundTransparency = 1
SettingsView.Visible = false
SettingsView.ZIndex = 2

local PadS = Instance.new("UIPadding", SettingsView)
PadS.PaddingTop = UDim.new(0, 14)
PadS.PaddingBottom = UDim.new(0, 14)
PadS.PaddingLeft = UDim.new(0, 16)
PadS.PaddingRight = UDim.new(0, 16)

local PowerLabel = Instance.new("TextLabel", SettingsView)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Size = UDim2.new(1, 0, 0, 14)
PowerLabel.Text = "POWER"
PowerLabel.Font = Enum.Font.GothamBold
PowerLabel.TextSize = 10
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.TextColor3 = TEXT_DIM

local PowerRow = Instance.new("Frame", SettingsView)
PowerRow.Position = UDim2.new(0, 0, 0, 22)
PowerRow.Size = UDim2.new(1, 0, 0, 44)
PowerRow.BackgroundTransparency = 1

local function makeBtn(parent, text, w)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, w, 1, 0)
    b.BackgroundColor3 = BG_INPUT
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 20
    b.TextColor3 = TEXT_WHITE
    b.AutoButtonColor = false
    b.ZIndex = 3
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b)
    s.Color = STROKE_W
    s.Thickness = 1
    s.Transparency = 0.4
    return b
end

local Minus = makeBtn(PowerRow, "−", 44)
Minus.Position = UDim2.new(0, 0, 0, 0)

local Plus = makeBtn(PowerRow, "+", 44)
Plus.Position = UDim2.new(1, -44, 0, 0)

local IntBox = Instance.new("TextBox", PowerRow)
IntBox.Position = UDim2.new(0, 52, 0, 0)
IntBox.Size = UDim2.new(1, -104, 1, 0)
IntBox.BackgroundColor3 = BG_INPUT
IntBox.BorderSizePixel = 0
IntBox.Text = "10000"
IntBox.PlaceholderText = "tu power"
IntBox.Font = Enum.Font.GothamBlack
IntBox.TextSize = 20
IntBox.TextColor3 = PURE_WHITE
IntBox.PlaceholderColor3 = TEXT_DIM
IntBox.ClearTextOnFocus = false
IntBox.ZIndex = 3
Instance.new("UICorner", IntBox).CornerRadius = UDim.new(0, 10)
local IntStroke = Instance.new("UIStroke", IntBox)
IntStroke.Color = STROKE_W
IntStroke.Thickness = 1
IntStroke.Transparency = 0.3

local Div = Instance.new("Frame", SettingsView)
Div.Position = UDim2.new(0, 0, 0, 78)
Div.Size = UDim2.new(1, 0, 0, 1)
Div.BackgroundColor3 = STROKE_W
Div.BackgroundTransparency = 0.4
Div.BorderSizePixel = 0
Div.ZIndex = 3

local KeyLabel = Instance.new("TextLabel", SettingsView)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Position = UDim2.new(0, 0, 0, 90)
KeyLabel.Size = UDim2.new(1, 0, 0, 14)
KeyLabel.Text = "TOGGLE KEYBIND"
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextSize = 10
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.TextColor3 = TEXT_DIM

local KeyBtn = Instance.new("TextButton", SettingsView)
KeyBtn.Position = UDim2.new(0, 0, 0, 110)
KeyBtn.Size = UDim2.new(1, 0, 0, 40)
KeyBtn.BackgroundColor3 = BG_INPUT
KeyBtn.BorderSizePixel = 0
KeyBtn.Text = "G"
KeyBtn.Font = Enum.Font.GothamBlack
KeyBtn.TextSize = 15
KeyBtn.TextColor3 = PURE_WHITE
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 3
Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 10)
local KeyStroke = Instance.new("UIStroke", KeyBtn)
KeyStroke.Color = STROKE_W
KeyStroke.Thickness = 1
KeyStroke.Transparency = 0.3

local BackBtn = Instance.new("TextButton", SettingsView)
BackBtn.Position = UDim2.new(0, 0, 1, -36)
BackBtn.Size = UDim2.new(1, 0, 0, 36)
BackBtn.BackgroundColor3 = BG_INPUT
BackBtn.BorderSizePixel = 0
BackBtn.Text = "← BACK"
BackBtn.Font = Enum.Font.GothamBlack
BackBtn.TextSize = 13
BackBtn.TextColor3 = TEXT_WHITE
BackBtn.AutoButtonColor = false
BackBtn.ZIndex = 3
Instance.new("UICorner", BackBtn).CornerRadius = UDim.new(0, 10)
local BackStroke = Instance.new("UIStroke", BackBtn)
BackStroke.Color = PURE_WHITE
BackStroke.Thickness = 1
BackStroke.Transparency = 0.5

-- ============ STATE ============
local lagging = false
local lagThread
local intensity = 10000
local toggleKey = Enum.KeyCode.G
local toggleKeyName = "G"
local settingsOpen = false
local collapsed = false

local function tween(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function clampIntensity(v)
    v = tonumber(v)
    if not v then return intensity end
    return math.clamp(math.floor(v), 1, 100000)
end

local function updateIntensity()
    intensity = clampIntensity(IntBox.Text)
    IntBox.Text = tostring(intensity)
end

local function setIntensity(v, silent)
    intensity = clampIntensity(v)
    IntBox.Text = tostring(intensity)
    if not silent then playSfx("Click") end
end

-- ============ KEY HELPERS ============
local function keyToName(keyCode)
    if not keyCode then return "G" end
    return keyCode.Name
end

local function nameToKey(name)
    if not name then return Enum.KeyCode.G end
    local ok, key = pcall(function() return Enum.KeyCode[name] end)
    if ok and key then return key end
    return Enum.KeyCode.G
end

local function applyKeybind(name)
    toggleKeyName = name or "G"
    toggleKey = nameToKey(toggleKeyName)
    KeyBtn.Text = toggleKeyName
end

-- ============ SAVE / LOAD ============
local function saveConfig()
    updateIntensity()
    local cfg = {
        Intensity = intensity,
        Keybind   = toggleKeyName,
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
    if ok and type(cfg) == "table" then
        if tonumber(cfg.Intensity) then
            intensity = clampIntensity(cfg.Intensity)
            IntBox.Text = tostring(intensity)
        end
        if type(cfg.Keybind) == "string" and cfg.Keybind ~= "" then
            applyKeybind(cfg.Keybind)
        end
        if tonumber(cfg.PX_S) and tonumber(cfg.PX_O) and tonumber(cfg.PY_S) and tonumber(cfg.PY_O) then
            Main.Position = UDim2.new(cfg.PX_S, cfg.PX_O, cfg.PY_S, cfg.PY_O)
        end
    end
end

-- ============ EVENT ============
local Event
do
    local ok, net = pcall(function()
        return RS:WaitForChild("Packages"):WaitForChild("Net")
    end)
    if ok and net then
        local kids = net:GetChildren()
        Event = kids[230]
    end
end

-- ============ TOGGLE VISUAL ============
local function updateToggleVisual(on)
    if on then
        tween(Knob, {Position = UDim2.new(1, -23, 0.5, -10), BackgroundColor3 = BG_BLACK}, 0.2)
        tween(ToggleBtn, {BackgroundColor3 = PURE_WHITE}, 0.2)
        tween(ToggleStroke, {Color = PURE_WHITE, Transparency = 0}, 0.2)
    else
        tween(Knob, {Position = UDim2.new(0, 3, 0.5, -10), BackgroundColor3 = TEXT_WHITE}, 0.2)
        tween(ToggleBtn, {BackgroundColor3 = BG_INPUT}, 0.2)
        tween(ToggleStroke, {Color = STROKE_W, Transparency = 0.3}, 0.2)
    end
end

-- ============ LAGGER ============
local function startLagging()
    if lagging then return end
    if not Event then playSfx("Error"); return end
    updateIntensity()
    lagging = true
    playSfx("Start")

    local payload = table.create(intensity, function() end)

    lagThread = task.spawn(function()
        while lagging do
            for _ = 1, 3 do
                pcall(function() Event:FireServer(payload) end)
            end
            task.wait(0.01)
        end
    end)
end

local function stopLagging()
    if not lagging then return end
    lagging = false
    if lagThread then
        pcall(task.cancel, lagThread)
        lagThread = nil
    end
    playSfx("Stop")
end

local function toggleLagger()
    if not Event then playSfx("Error"); return end
    if lagging then
        stopLagging()
        updateToggleVisual(false)
    else
        startLagging()
        updateToggleVisual(true)
    end
end

-- ============ SETTINGS / VIEWS ============
local function openSettings()
    if settingsOpen then return end
    if collapsed then
        collapsed = false
        CollapseBtn.Text = "−"
    end
    settingsOpen = true
    MainView.Visible = false
    SettingsView.Visible = true
    tween(Main, {Size = UDim2.new(0, W, 0, SETTINGS_H)}, 0.25)
    tween(SettingsStroke, {Color = PURE_WHITE, Transparency = 0}, 0.15)
    playSfx("Click")
end

local function closeSettings()
    if not settingsOpen then return end
    settingsOpen = false
    MainView.Visible = true
    SettingsView.Visible = false
    tween(Main, {Size = UDim2.new(0, W, 0, FULL_H)}, 0.25)
    tween(SettingsStroke, {Color = STROKE_W, Transparency = 0.3}, 0.15)
    playSfx("Click")
end

-- ============ HOVER ============
local function attachHover(b)
    b.MouseEnter:Connect(function()
        tween(b, {BackgroundColor3 = BG_HOVER}, 0.12)
        playSfx("Hover")
    end)
    b.MouseLeave:Connect(function()
        tween(b, {BackgroundColor3 = BG_INPUT}, 0.12)
    end)
end

for _, b in ipairs({Minus, Plus, KeyBtn, CollapseBtn, SettingsBtn, BackBtn}) do
    attachHover(b)
end

-- ============ CONNECTIONS ============
IntBox.FocusLost:Connect(function()
    updateIntensity()
    playSfx("Click")
    saveConfig()
end)
Minus.MouseButton1Click:Connect(function()
    updateIntensity(); setIntensity(intensity - 1000); saveConfig()
end)
Plus.MouseButton1Click:Connect(function()
    updateIntensity(); setIntensity(intensity + 1000); saveConfig()
end)

ToggleBtn.MouseButton1Click:Connect(function()
    playSfx("Click")
    toggleLagger()
end)

SettingsBtn.MouseButton1Click:Connect(function()
    if settingsOpen then closeSettings() else openSettings() end
end)
BackBtn.MouseButton1Click:Connect(closeSettings)

-- ============ KEYBIND LISTEN ============
local listeningForKey = false

KeyBtn.MouseButton1Click:Connect(function()
    if listeningForKey then return end
    listeningForKey = true
    KeyBtn.Text = "press a key..."
    tween(KeyBtn, {BackgroundColor3 = PURE_WHITE, TextColor3 = BG_BLACK}, 0.15)
    playSfx("Keybind")
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end

    if listeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            listeningForKey = false
            applyKeybind(keyToName(input.KeyCode))
            tween(KeyBtn, {BackgroundColor3 = BG_INPUT, TextColor3 = PURE_WHITE}, 0.15)
            playSfx("Keybind")
            saveConfig()
        end
        return
    end

    if input.KeyCode == toggleKey then
        playSfx("Toggle")
        toggleLagger()
    end
end)

-- ============ MINIMIZE ============
CollapseBtn.MouseButton1Click:Connect(function()
    playSfx("Click")
    if settingsOpen then
        closeSettings()
        return
    end
    collapsed = not collapsed
    if collapsed then
        CollapseBtn.Text = "+"
        tween(Main, {Size = UDim2.new(0, W, 0, MINI_H)}, 0.3)
    else
        CollapseBtn.Text = "−"
        tween(Main, {Size = UDim2.new(0, W, 0, FULL_H)}, 0.3)
    end
end)

-- ============ DRAG ============
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                saveConfig()
            end
        end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ============ INTRO ============
Main.Size = UDim2.new(0, W, 0, 0)
Main.BackgroundTransparency = 1
task.defer(loadConfig)
tween(Main, {Size = UDim2.new(0, W, 0, FULL_H), BackgroundTransparency = 0}, 0.4)
updateToggleVisual(false)