--[[
╔══════════════════════════════════════════════════════════════╗
║                    OR'S CODE SNIPER                          ║
║         Combined: Weekly + Traced Redeemer + Riddle AI       ║
║              Professional Black Theme                        ║
║                                                              ║
║  Features:                                                   ║
║  • Code Listener + Auto Redeem + Spam                        ║
║  • Manual Mode + Word Mode                                   ║
║  • Auto Type / Auto Listen / Ignore System                   ║
║  • Anti Lag / Anti Ragdoll / Anchor                          ║
║  • Auto Buy (ProximityPrompt)                                ║
║  • Block Events                                              ║
║  • Keybinds + Config Save                                    ║
║  • Clean Dark UI with animations                             ║
╚══════════════════════════════════════════════════════════════╝
]]

local success, err = pcall(function()

print("[OR'S] Initialising OR'S CODE SNIPER...")

-- ══════════════════════════════════════
-- SERVICES
-- ══════════════════════════════════════
local cloneref = cloneref or function(o) return o end
local Players              = cloneref(game:GetService("Players"))
local ReplicatedStorage    = cloneref(game:GetService("ReplicatedStorage"))
local RunService           = cloneref(game:GetService("RunService"))
local UserInputService     = cloneref(game:GetService("UserInputService"))
local HttpService          = cloneref(game:GetService("HttpService"))
local Lighting             = cloneref(game:GetService("Lighting"))
local Workspace            = cloneref(game:GetService("Workspace"))
local TweenService         = cloneref(game:GetService("TweenService"))
local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))

local player = Players.LocalPlayer
if not player then
    warn("[OR'S] No LocalPlayer")
    return
end
local playerGui = player:WaitForChild("PlayerGui")

-- ══════════════════════════════════════
-- STOP PREVIOUS VERSIONS
-- ══════════════════════════════════════
if getgenv then
    pcall(function() if getgenv().StopAura then getgenv().StopAura() end end)
    pcall(function() if getgenv().StopTraced then getgenv().StopTraced() end end)
    pcall(function() if getgenv().StopRiddler then getgenv().StopRiddler() end end)
    pcall(function() if getgenv().StopORS then getgenv().StopORS() end end)
end

-- Destroy old GUIs
pcall(function()
    for _, name in ipairs({
        "WeeklyCodeSniperUI", "WeeklySettingsUI", "ORSCodeSniper",
        "TracedRedeemer", "RiddlerUI", "SourcesHubRedeemerGui"
    }) do
        local o = game.CoreGui:FindFirstChild(name) or playerGui:FindFirstChild(name)
        if o then o:Destroy() end
    end
end)

-- ══════════════════════════════════════
-- CONFIG
-- ══════════════════════════════════════
local CONFIG_FILE = "ors_code_sniper_config.json"

local savedConfig = {
    codeSniper       = true,
    autoSubmit       = true,
    submitAfter      = 1,
    spamRedeem       = true,
    spamCount        = 25,
    antiLag          = false,
    antiRagdoll      = false,
    anchor           = false,
    autoTurnOnRedeem = false,
    autoTurnOnListen = true,
    autoTurnOnSubmit = false,
    autoTurnOffSubmit= false,
    autoTurnOffRedeem= false,
    manualMode       = false,
    listenKeybind    = "C",
    guiScale         = 92,
    autoRedeem       = true,
    autoType         = true,
    wordMode         = false,
    ignoreSystem     = true,
    spamOnListen     = true,
    autoListen       = true,
    duo              = false,
    showKeybinds     = true,
}

pcall(function()
    if type(isfile) == "function" and type(readfile) == "function" and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            for k, v in pairs(decoded) do
                if savedConfig[k] ~= nil then
                    savedConfig[k] = v
                end
            end
        end
    end
end)

local function saveConfig()
    if type(writefile) == "function" then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(savedConfig))
        end)
    end
end

-- ══════════════════════════════════════
-- STATE
-- ══════════════════════════════════════
local _enabled          = savedConfig.codeSniper
local _autoAccept       = savedConfig.autoSubmit
local _submitAfter      = math.clamp(tonumber(savedConfig.submitAfter) or 1, 1, 6)
local _spamRedeem       = savedConfig.spamRedeem
local _spamCount        = math.clamp(tonumber(savedConfig.spamCount) or 25, 1, 100)
local _guiScale         = math.clamp(math.floor((savedConfig.guiScale or 92) / 10 + 0.5) * 10, 50, 120)
local _listenKeybind    = savedConfig.listenKeybind or "C"
local _manualMode       = savedConfig.manualMode
local _antiLag          = savedConfig.antiLag
local _antiRagdoll      = savedConfig.antiRagdoll
local _anchor           = savedConfig.anchor
local _autoRedeem       = savedConfig.autoRedeem
local _autoType         = savedConfig.autoType
local _wordMode         = savedConfig.wordMode
local _ignoreSystem     = savedConfig.ignoreSystem
local _spamOnListen     = savedConfig.spamOnListen
local _autoListen       = savedConfig.autoListen
local _duo              = savedConfig.duo

local _seen             = {}
local _capturedParts    = {}
local _manualBuffer     = ""
local _listening        = false
local _isCollapsed      = false
local _autoBuyOn        = false
local _blockEventsOn    = false
local _lastRedeemTime   = 0

-- ══════════════════════════════════════
-- COLORS (Professional Black Theme)
-- ══════════════════════════════════════
local C = {
    Window   = Color3.fromRGB(9, 9, 12),
    Section  = Color3.fromRGB(15, 15, 20),
    Row      = Color3.fromRGB(20, 20, 26),
    Control  = Color3.fromRGB(30, 30, 38),
    Border   = Color3.fromRGB(50, 50, 60),
    Accent   = Color3.fromRGB(130, 145, 255),
    Accent2  = Color3.fromRGB(90, 110, 255),
    Text     = Color3.fromRGB(235, 235, 242),
    Dim      = Color3.fromRGB(140, 140, 155),
    Ok       = Color3.fromRGB(85, 200, 120),
    Err      = Color3.fromRGB(220, 75, 75),
    Warn     = Color3.fromRGB(230, 175, 60),
    White    = Color3.fromRGB(255, 255, 255),
}

local FONT_TITLE  = Enum.Font.GothamBold
local FONT_BOLD   = Enum.Font.GothamBold
local FONT_MEDIUM = Enum.Font.GothamMedium

-- ══════════════════════════════════════
-- UTILS
-- ══════════════════════════════════════
local function addCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end

local function addStroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or C.Border
    s.Thickness = thick or 1
    s.Transparency = trans or 0.45
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function tween(obj, props, t, style, dir)
    local tw = TweenService:Create(obj,
        TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        props)
    tw:Play()
    return tw
end

local function makeLabel(parent, text, size, pos, textSize, color, font, xAlign)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.Size = size or UDim2.new(1, 0, 0, 20)
    l.Position = pos or UDim2.new()
    l.TextSize = textSize or 12
    l.TextColor3 = color or C.Text
    l.Font = font or FONT_MEDIUM
    l.TextXAlignment = xAlign or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end

local function stripRich(t)
    if type(t) ~= "string" then return tostring(t or "") end
    return (t:gsub("<[^>]->", ""))
end

local function tokenize(t)
    local w = {}
    for word in tostring(t):gmatch("[%w_]+") do
        w[#w + 1] = word
    end
    return w
end

local getconns = getconnections or (debug and debug.getconnections)
local setclip  = setclipboard or toclipboard or (syn and syn.write_clipboard)

-- ══════════════════════════════════════
-- GUI CREATION
-- ══════════════════════════════════════
local GUI = Instance.new("ScreenGui")
GUI.Name = "ORSCodeSniper"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() GUI.Parent = game.CoreGui end)
if not GUI.Parent then GUI.Parent = playerGui end

local WINDOW_W, WINDOW_H = 290, 460
local COLLAPSED_H = 48

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
Window.AnchorPoint = Vector2.new(1, 0)
Window.Position = UDim2.new(1, -14, 0, 14)
Window.BackgroundColor3 = C.Window
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = GUI
addCorner(Window, 14)
addStroke(Window, C.Border, 1.2, 0.3)

local UIScale = Instance.new("UIScale")
UIScale.Scale = _guiScale / 100
UIScale.Parent = Window

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundColor3 = C.Section
Header.BorderSizePixel = 0
Header.Parent = Window
addCorner(Header, 14)

-- fix bottom corners of header
local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 16)
headerFix.Position = UDim2.new(0, 0, 1, -16)
headerFix.BackgroundColor3 = C.Section
headerFix.BorderSizePixel = 0
headerFix.Parent = Header

local Title = makeLabel(Header, "OR'S CODE SNIPER", UDim2.new(1, -90, 1, 0), UDim2.fromOffset(16, 0), 15, C.White, FONT_TITLE)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(30, 30)
MinimizeBtn.Position = UDim2.new(1, -40, 0.5, -15)
MinimizeBtn.BackgroundColor3 = C.Control
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = C.Text
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = FONT_BOLD
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header
addCorner(MinimizeBtn, 7)
addStroke(MinimizeBtn, C.Border, 1, 0.5)

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 28)
StatusBar.Position = UDim2.fromOffset(10, 54)
StatusBar.BackgroundColor3 = C.Row
StatusBar.BorderSizePixel = 0
StatusBar.Parent = Window
addCorner(StatusBar, 8)

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.fromOffset(8, 8)
StatusDot.Position = UDim2.fromOffset(11, 10)
StatusDot.BackgroundColor3 = C.Dim
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusBar
addCorner(StatusDot, 4)

local StatusText = makeLabel(StatusBar, "Ready", UDim2.new(1, -32, 1, 0), UDim2.fromOffset(26, 0), 12, C.Dim, FONT_MEDIUM)

local function setStatus(msg, kind)
    StatusText.Text = tostring(msg or "")
    local col = C.Dim
    if kind == "ok" then col = C.Ok
    elseif kind == "err" then col = C.Err
    elseif kind == "busy" or kind == "wait" then col = C.Warn
    elseif kind == "accent" then col = C.Accent end
    StatusText.TextColor3 = col
    StatusDot.BackgroundColor3 = col
end

-- Tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 34)
TabBar.Position = UDim2.fromOffset(10, 90)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Window

local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.333, -4, 1, 0)
    btn.Position = UDim2.new(order * 0.333, 2, 0, 0)
    btn.BackgroundColor3 = C.Control
    btn.Text = name
    btn.TextColor3 = C.Dim
    btn.TextSize = 11
    btn.Font = FONT_BOLD
    btn.AutoButtonColor = false
    btn.Parent = TabBar
    addCorner(btn, 7)
    addStroke(btn, C.Border, 1, 0.55)
    return btn
end

local MainTab     = createTab("MAIN", 0)
local SettingsTab = createTab("SETTINGS", 1)
local UtilsTab    = createTab("UTILS", 2)

local function setActiveTab(active)
    for _, b in ipairs({MainTab, SettingsTab, UtilsTab}) do
        local on = (b == active)
        tween(b, {
            BackgroundColor3 = on and C.Accent2 or C.Control,
            TextColor3 = on and C.White or C.Dim
        }, 0.15)
    end
end

-- Pages
local function makePage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, -20, 1, -138)
    p.Position = UDim2.fromOffset(10, 132)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = Window
    return p
end

local MainPage     = makePage()
local SettingsPage = makePage()
local UtilsPage    = makePage()
MainPage.Visible = true

-- ══════════════════════════════════════
-- TOGGLE ROW HELPER
-- ══════════════════════════════════════
local function createToggleRow(parent, y, label, initial, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.Position = UDim2.fromOffset(0, y)
    row.BackgroundColor3 = C.Row
    row.BorderSizePixel = 0
    row.Parent = parent
    addCorner(row, 8)

    makeLabel(row, label, UDim2.new(1, -70, 1, 0), UDim2.fromOffset(12, 0), 12, C.Text, FONT_MEDIUM)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(54, 26)
    btn.Position = UDim2.new(1, -62, 0.5, -13)
    btn.BackgroundColor3 = initial and Color3.fromRGB(40, 50, 90) or C.Control
    btn.Text = initial and "ON" or "OFF"
    btn.TextColor3 = initial and C.White or C.Dim
    btn.TextSize = 11
    btn.Font = FONT_BOLD
    btn.AutoButtonColor = false
    btn.Parent = row
    addCorner(btn, 6)
    local stroke = addStroke(btn, C.Border, 1, initial and 0.15 or 0.65)

    local state = initial
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.TextColor3 = state and C.White or C.Dim
        stroke.Transparency = state and 0.15 or 0.65
        tween(btn, {BackgroundColor3 = state and Color3.fromRGB(40, 50, 90) or C.Control}, 0.15)
        if callback then callback(state) end
    end)

    return btn, function(v)
        state = v
        btn.Text = v and "ON" or "OFF"
        btn.TextColor3 = v and C.White or C.Dim
        stroke.Transparency = v and 0.15 or 0.65
        btn.BackgroundColor3 = v and Color3.fromRGB(40, 50, 90) or C.Control
    end
end

-- ══════════════════════════════════════
-- MAIN PAGE
-- ══════════════════════════════════════
local ListenBtn = Instance.new("TextButton")
ListenBtn.Size = UDim2.new(0.48, -3, 0, 42)
ListenBtn.Position = UDim2.fromOffset(0, 0)
ListenBtn.BackgroundColor3 = C.Control
ListenBtn.Text = "LISTEN  OFF"
ListenBtn.TextColor3 = C.Dim
ListenBtn.TextSize = 13
ListenBtn.Font = FONT_BOLD
ListenBtn.AutoButtonColor = false
ListenBtn.Parent = MainPage
addCorner(ListenBtn, 9)
addStroke(ListenBtn, C.Border, 1, 0.4)

local RedeemBtn = Instance.new("TextButton")
RedeemBtn.Size = UDim2.new(0.48, -3, 0, 42)
RedeemBtn.Position = UDim2.new(0.52, 0, 0, 0)
RedeemBtn.BackgroundColor3 = C.Control
RedeemBtn.Text = "REDEEM"
RedeemBtn.TextColor3 = C.Text
RedeemBtn.TextSize = 13
RedeemBtn.Font = FONT_BOLD
RedeemBtn.AutoButtonColor = false
RedeemBtn.Parent = MainPage
addCorner(RedeemBtn, 9)
addStroke(RedeemBtn, C.Border, 1, 0.4)

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(1, 0, 0, 38)
CodeBox.Position = UDim2.fromOffset(0, 52)
CodeBox.BackgroundColor3 = C.Section
CodeBox.Text = ""
CodeBox.PlaceholderText = "Code appears here..."
CodeBox.PlaceholderColor3 = C.Dim
CodeBox.TextColor3 = C.White
CodeBox.TextSize = 14
CodeBox.Font = FONT_MEDIUM
CodeBox.ClearTextOnFocus = false
CodeBox.TextXAlignment = Enum.TextXAlignment.Center
CodeBox.Parent = MainPage
addCorner(CodeBox, 8)
addStroke(CodeBox, C.Border, 1, 0.35)

local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.48, -3, 0, 34)
ClearBtn.Position = UDim2.fromOffset(0, 100)
ClearBtn.BackgroundColor3 = C.Control
ClearBtn.Text = "CLEAR"
ClearBtn.TextColor3 = C.Dim
ClearBtn.TextSize = 12
ClearBtn.Font = FONT_BOLD
ClearBtn.AutoButtonColor = false
ClearBtn.Parent = MainPage
addCorner(ClearBtn, 8)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.48, -3, 0, 34)
CopyBtn.Position = UDim2.new(0.52, 0, 0, 100)
CopyBtn.BackgroundColor3 = C.Control
CopyBtn.Text = "COPY"
CopyBtn.TextColor3 = C.Dim
CopyBtn.TextSize = 12
CopyBtn.Font = FONT_BOLD
CopyBtn.AutoButtonColor = false
CopyBtn.Parent = MainPage
addCorner(CopyBtn, 8)

local autoSubmitBtn = createToggleRow(MainPage, 148, "Auto Submit", _autoAccept, function(v)
    _autoAccept = v
    savedConfig.autoSubmit = v
    saveConfig()
end)

local spamBtn = createToggleRow(MainPage, 190, "Spam Redeem", _spamRedeem, function(v)
    _spamRedeem = v
    savedConfig.spamRedeem = v
    saveConfig()
end)

local manualBtn = createToggleRow(MainPage, 232, "Manual Mode", _manualMode, function(v)
    _manualMode = v
    savedConfig.manualMode = v
    saveConfig()
end)

local Console = Instance.new("TextLabel")
Console.Size = UDim2.new(1, 0, 0, 72)
Console.Position = UDim2.fromOffset(0, 280)
Console.BackgroundColor3 = C.Section
Console.Text = "Waiting for codes..."
Console.TextColor3 = C.Dim
Console.TextSize = 11
Console.Font = FONT_MEDIUM
Console.TextXAlignment = Enum.TextXAlignment.Left
Console.TextYAlignment = Enum.TextYAlignment.Top
Console.TextWrapped = true
Console.Parent = MainPage
addCorner(Console, 8)

local function log(msg)
    Console.Text = tostring(msg)
end

-- ══════════════════════════════════════
-- SETTINGS PAGE
-- ══════════════════════════════════════
local sy = 0
local function nextSY(h)
    local cy = sy
    sy = sy + (h or 42)
    return cy
end

createToggleRow(SettingsPage, nextSY(), "Auto Redeem", _autoRedeem, function(v)
    _autoRedeem = v; savedConfig.autoRedeem = v; saveConfig()
end)
createToggleRow(SettingsPage, nextSY(), "Auto Type", _autoType, function(v)
    _autoType = v; savedConfig.autoType = v; saveConfig()
end)
createToggleRow(SettingsPage, nextSY(), "Word Mode", _wordMode, function(v)
    _wordMode = v; savedConfig.wordMode = v; saveConfig()
end)
createToggleRow(SettingsPage, nextSY(), "Ignore System Msgs", _ignoreSystem, function(v)
    _ignoreSystem = v; savedConfig.ignoreSystem = v; saveConfig()
end)
createToggleRow(SettingsPage, nextSY(), "Auto Listen", _autoListen, function(v)
    _autoListen = v; savedConfig.autoListen = v; saveConfig()
end)
createToggleRow(SettingsPage, nextSY(), "Spam on Listen", _spamOnListen, function(v)
    _spamOnListen = v; savedConfig.spamOnListen = v; saveConfig()
end)
createToggleRow(SettingsPage, nextSY(), "Duo Mode", _duo, function(v)
    _duo = v; savedConfig.duo = v; saveConfig()
end)

-- ══════════════════════════════════════
-- UTILS PAGE
-- ══════════════════════════════════════
local uy = 0
local function nextUY(h)
    local cy = uy
    uy = uy + (h or 42)
    return cy
end

createToggleRow(UtilsPage, nextUY(), "Anti Lag", _antiLag, function(v)
    _antiLag = v; savedConfig.antiLag = v; saveConfig()
    if v then startAntiLag() else stopAntiLag() end
end)
createToggleRow(UtilsPage, nextUY(), "Anti Ragdoll", _antiRagdoll, function(v)
    _antiRagdoll = v; savedConfig.antiRagdoll = v; saveConfig()
    if v then startAntiRagdoll() else stopAntiRagdoll() end
end)
createToggleRow(UtilsPage, nextUY(), "Anchor Character", _anchor, function(v)
    _anchor = v; savedConfig.anchor = v; saveConfig()
    if v then startAnchor() else stopAnchor() end
end)

local AutoBuyBtn = Instance.new("TextButton")
AutoBuyBtn.Size = UDim2.new(1, 0, 0, 38)
AutoBuyBtn.Position = UDim2.fromOffset(0, nextUY(48))
AutoBuyBtn.BackgroundColor3 = C.Control
AutoBuyBtn.Text = "AUTO BUY  •  OFF"
AutoBuyBtn.TextColor3 = C.Dim
AutoBuyBtn.TextSize = 13
AutoBuyBtn.Font = FONT_BOLD
AutoBuyBtn.AutoButtonColor = false
AutoBuyBtn.Parent = UtilsPage
addCorner(AutoBuyBtn, 9)
addStroke(AutoBuyBtn, C.Border, 1, 0.4)

local BlockEventsBtn = Instance.new("TextButton")
BlockEventsBtn.Size = UDim2.new(1, 0, 0, 38)
BlockEventsBtn.Position = UDim2.fromOffset(0, nextUY(48))
BlockEventsBtn.BackgroundColor3 = C.Control
BlockEventsBtn.Text = "BLOCK EVENTS  •  OFF"
BlockEventsBtn.TextColor3 = C.Dim
BlockEventsBtn.TextSize = 13
BlockEventsBtn.Font = FONT_BOLD
BlockEventsBtn.AutoButtonColor = false
BlockEventsBtn.Parent = UtilsPage
addCorner(BlockEventsBtn, 9)
addStroke(BlockEventsBtn, C.Border, 1, 0.4)

local InfoLabel = makeLabel(UtilsPage, "Auto Buy / Block Events ready", UDim2.new(1, 0, 0, 40), UDim2.fromOffset(0, nextUY(50)), 11, C.Dim, FONT_MEDIUM)
InfoLabel.TextWrapped = true

-- ══════════════════════════════════════
-- TAB SWITCHING
-- ══════════════════════════════════════
MainTab.MouseButton1Click:Connect(function()
    setActiveTab(MainTab)
    MainPage.Visible = true
    SettingsPage.Visible = false
    UtilsPage.Visible = false
end)
SettingsTab.MouseButton1Click:Connect(function()
    setActiveTab(SettingsTab)
    MainPage.Visible = false
    SettingsPage.Visible = true
    UtilsPage.Visible = false
end)
UtilsTab.MouseButton1Click:Connect(function()
    setActiveTab(UtilsTab)
    MainPage.Visible = false
    SettingsPage.Visible = false
    UtilsPage.Visible = true
end)
setActiveTab(MainTab)

-- Minimize
MinimizeBtn.MouseButton1Click:Connect(function()
    _isCollapsed = not _isCollapsed
    local h = _isCollapsed and COLLAPSED_H or WINDOW_H
    tween(Window, {Size = UDim2.fromOffset(WINDOW_W, h)}, 0.22)
    MinimizeBtn.Text = _isCollapsed and "+" or "−"
    TabBar.Visible = not _isCollapsed
    StatusBar.Visible = not _isCollapsed
    MainPage.Visible = not _isCollapsed
    SettingsPage.Visible = false
    UtilsPage.Visible = false
end)

-- Dragging
do
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ══════════════════════════════════════
-- CORE: REDEEM LOGIC
-- ══════════════════════════════════════
local function clickBtn(btn)
    if not btn then return false end
    local fired = false
    if typeof(firesignal) == "function" then
        pcall(function() firesignal(btn.MouseButton1Click) end)
        pcall(function() firesignal(btn.Activated) end)
        fired = true
    end
    if getconns then
        for _, sig in ipairs({btn.MouseButton1Click, btn.Activated}) do
            local ok, cs = pcall(getconns, sig)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do
                    pcall(function()
                        if c.Enabled ~= false then
                            if c.Function then
                                task.spawn(c.Function)
                            else
                                c:Fire()
                            end
                        end
                    end)
                    fired = true
                end
            end
        end
    end
    return fired
end

local function findCodeBox()
    local pg = playerGui
    -- Prefer Codes GUI
    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        for _, d in ipairs(codesGui:GetDescendants()) do
            if d:IsA("TextBox") then return d end
        end
    end
    -- Search all
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "ORSCodeSniper" then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") then
                    local n = d.Name:lower()
                    local p = (d.Parent and d.Parent.Name or ""):lower()
                    if n:find("code") or p:find("code") or n:find("redeem") or p:find("redeem") or n:find("input") then
                        return d
                    end
                end
            end
        end
    end
    return nil
end

local function submitCode(code)
    if type(code) ~= "string" or code == "" then return false, "empty" end
    code = code:match("^%s*(.-)%s*$") or code

    local pg = playerGui
    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        pcall(function()
            if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
        end)
        local frame = codesGui:FindFirstChild("Codes") or codesGui
        local box, submit
        for _, d in ipairs(frame:GetDescendants()) do
            if d:IsA("TextBox") then box = d end
            if d:IsA("TextButton") or d:IsA("ImageButton") then
                local n = d.Name:lower()
                local t = ""
                pcall(function() t = d.Text:lower() end)
                if n:find("confirm") or n:find("submit") or n:find("redeem") or n:find("enter")
                    or t:find("confirm") or t:find("redeem") or t:find("submit") then
                    submit = d
                end
            end
        end
        if box then
            pcall(function() box.Text = code end)
            if submit then
                if _spamRedeem then
                    for i = 1, _spamCount do
                        clickBtn(submit)
                        task.wait(0.0004)
                    end
                else
                    clickBtn(submit)
                end
            end
            -- FocusLost
            if getconns then
                pcall(function()
                    local ok, cs = pcall(getconns, box.FocusLost)
                    if ok and type(cs) == "table" then
                        for _, c in ipairs(cs) do
                            pcall(function() c:Fire(true) end)
                        end
                    end
                end)
            end
            return true, "Codes GUI"
        end
    end

    -- Dynamic fallback
    local box = findCodeBox()
    if not box then return false, "no code box" end
    pcall(function() box.Text = code end)

    local redeemBtn
    local p = box.Parent
    for _ = 1, 7 do
        if not p then break end
        for _, d in ipairs(p:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and d ~= box then
                local n = d.Name:lower()
                local t = ""
                pcall(function() t = d.Text:lower() end)
                for _, sn in ipairs({"submit", "redeem", "claim", "confirm", "enter", "send", "apply"}) do
                    if n:find(sn) or t:find(sn) then
                        redeemBtn = d
                        break
                    end
                end
                if redeemBtn then break end
            end
        end
        if redeemBtn then break end
        p = p.Parent
    end

    if redeemBtn then
        if _spamRedeem then
            for i = 1, _spamCount do
                clickBtn(redeemBtn)
                task.wait(0.0004)
            end
        else
            clickBtn(redeemBtn)
        end
    end
    return true, "dynamic"
end

local function doRedeem(code, prefix)
    prefix = prefix or ""
    if os.clock() - _lastRedeemTime < 0.15 then return false end
    _lastRedeemTime = os.clock()

    setStatus(prefix .. "Redeeming: " .. code, "busy")
    log(prefix .. "→ " .. code)

    local ok, msg = submitCode(code)
    if ok then
        setStatus(prefix .. "Sent: " .. code, "ok")
        log("✓ Sent: " .. code)
    else
        setStatus(prefix .. "Failed (" .. tostring(msg) .. ")", "err")
        log("✗ Failed: " .. tostring(msg))
    end
    return ok
end

-- ══════════════════════════════════════
-- LISTEN LOGIC
-- ══════════════════════════════════════
local function setListening(on)
    _listening = on
    ListenBtn.Text = on and "LISTEN  ON" or "LISTEN  OFF"
    ListenBtn.TextColor3 = on and C.White or C.Dim
    tween(ListenBtn, {
        BackgroundColor3 = on and Color3.fromRGB(35, 50, 95) or C.Control
    }, 0.18)
    if on then
        setStatus("Listening for codes...", "wait")
        _capturedParts = {}
        log("Listening started")
    else
        setStatus("Idle", nil)
        log("Listening stopped")
    end
end

ListenBtn.MouseButton1Click:Connect(function()
    setListening(not _listening)
end)

RedeemBtn.MouseButton1Click:Connect(function()
    local t = CodeBox.Text
    if t and t ~= "" then
        doRedeem(t)
    else
        setStatus("No code to redeem", "err")
    end
end)

ClearBtn.MouseButton1Click:Connect(function()
    CodeBox.Text = ""
    _capturedParts = {}
    _manualBuffer = ""
    setStatus(_listening and "Listening (cleared)" or "Cleared", _listening and "wait" or nil)
end)

CopyBtn.MouseButton1Click:Connect(function()
    local t = CodeBox.Text
    if t == "" then
        setStatus("Nothing to copy", "err")
        return
    end
    if setclip then
        pcall(setclip, t)
        setStatus("Copied!", "ok")
    else
        setStatus("Clipboard unavailable", "err")
    end
end)

-- ══════════════════════════════════════
-- ANNOUNCEMENT HANDLER
-- ══════════════════════════════════════
local SYSTEM_KEYWORDS = {
    "base is full", "sold out", "already redeemed", "already used",
    "code redeemed", "you have already", "sammy activated",
    "event has started", "brainrot express", "trade has been",
    "your base is already locked", "someone is stealing",
    "request failed", "out of stock", "you locked your base"
}

local function isSystemMsg(text)
    if not _ignoreSystem then return false end
    local t = text:lower()
    for _, k in ipairs(SYSTEM_KEYWORDS) do
        if t:find(k, 1, true) then return true end
    end
    return false
end

local function extractCode(text)
    local words = tokenize(text)
    if #words == 0 then return nil end

    -- Prefer words that look like codes (uppercase + numbers or long mixed)
    for i = #words, 1, -1 do
        local w = words[i]
        if #w >= 4 and (w:match("%u") or w:match("%d")) and not w:match("^[aeiouAEIOU]+$") then
            return w
        end
    end
    -- fallback last word
    return words[#words]
end

local function containsTrigger(text)
    local t = text:lower()
    return t:find("use code") or t:find("code is") or t:find("type code")
        or t:find("redeem code") or t:find("enter code") or t:find("claim code")
        or t:find("new code") or t:find("free code")
end

local function onAnnouncement(...)
    local raw = ""
    for i = 1, select("#", ...) do
        local a = select(i, ...)
        if type(a) == "string" and a ~= "" then
            raw = stripRich(a)
            break
        end
    end
    raw = (raw:match("^%s*(.-)%s*$") or "")
    if raw == "" then return end
    if isSystemMsg(raw) then return end

    -- Auto enable listen
    if _autoListen and not _listening and containsTrigger(raw) then
        setListening(true)
    end

    if not _listening and not _enabled then return end

    local code = extractCode(raw)
    if not code or #code < 3 then return end

    local key = "c:" .. code:lower()
    if _seen[key] then return end
    _seen[key] = true
    task.delay(1.8, function() _seen[key] = nil end)

    if _autoType then
        CodeBox.Text = code
    end

    if _manualMode then
        if _manualBuffer == "" then
            _manualBuffer = code
        else
            _manualBuffer = _manualBuffer .. " " .. code
        end
        CodeBox.Text = _manualBuffer
        setStatus("Manual: " .. _manualBuffer, "wait")
        log("Manual buffer → " .. _manualBuffer)
        if _autoRedeem then
            task.spawn(function()
                task.wait(0.05)
                doRedeem(_manualBuffer, "[MAN] ")
            end)
        end
        return
    end

    -- Normal capture
    table.insert(_capturedParts, code)
    local combined = table.concat(_capturedParts, " ")
    if _autoType then
        CodeBox.Text = combined
    end
    setStatus(string.format("Captured %d/%d: %s", #_capturedParts, _submitAfter, combined), "wait")
    log("Captured → " .. combined)

    if #_capturedParts >= _submitAfter then
        _capturedParts = {}
        if _autoRedeem or _autoAccept then
            task.spawn(function()
                doRedeem(combined, "[AUTO] ")
            end)
        end
    end
end

-- ══════════════════════════════════════
-- NOTIFY REMOTE
-- ══════════════════════════════════════
local function resolveNotifyRemote()
    local ok, packages = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 6)
    end)
    if not ok or not packages then return nil end

    local ok2, net = pcall(function()
        return packages:WaitForChild("Net", 6)
    end)
    if not ok2 or not net then return nil end

    local getinfo = debug and (debug.getinfo or debug.info)
    if getgc and getinfo and getconns then
        for _, d in ipairs(net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local okc, cs = pcall(getconns, d.OnClientEvent)
                if okc and type(cs) == "table" then
                    for _, c in ipairs(cs) do
                        local f, fn = pcall(function() return c.Function end)
                        if f and type(fn) == "function" then
                            local i, info = pcall(getinfo, fn)
                            local src = i and tostring(info.short_src or info.source or "") or ""
                            if src:find("NotificationController", 1, true) then
                                return d
                            end
                        end
                    end
                end
            end
        end
    end

    -- Fallback: first remote
    for _, d in ipairs(net:GetChildren()) do
        if d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent") then
            return d
        end
    end
    return nil
end

local notifyRemote = resolveNotifyRemote()
local notifyConn

if notifyRemote then
    notifyConn = notifyRemote.OnClientEvent:Connect(function(...)
        pcall(onAnnouncement, ...)
    end)
    setStatus("Ready • Notify linked", "ok")
    log("Notification remote connected")
else
    setStatus("Notify not found – using fallback", "warn")
    log("Using broad remote fallback")
    task.spawn(function()
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        local net = packages and packages:FindFirstChild("Net")
        if net then
            local count = 0
            for _, child in ipairs(net:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                    child.OnClientEvent:Connect(function(...)
                        pcall(onAnnouncement, ...)
                    end)
                    count = count + 1
                    if count >= 80 then break end
                end
            end
            net.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                    child.OnClientEvent:Connect(function(...)
                        pcall(onAnnouncement, ...)
                    end)
                end
            end)
        end
    end)
end

-- ══════════════════════════════════════
-- KEYBIND
-- ══════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == _listenKeybind then
            setListening(not _listening)
        end
    end
end)

-- ══════════════════════════════════════
-- ANTI LAG / RAGDOLL / ANCHOR
-- ══════════════════════════════════════
local antiLagConn, ragdollConn, anchorConn

function startAntiLag()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
    end)
    if antiLagConn then antiLagConn:Disconnect() end
    antiLagConn = Workspace.DescendantAdded:Connect(function(obj)
        if not _antiLag then return end
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end)
    end)
end

function stopAntiLag()
    if antiLagConn then antiLagConn:Disconnect() antiLagConn = nil end
end

function startAntiRagdoll()
    if ragdollConn then return end
    ragdollConn = RunService.Heartbeat:Connect(function()
        if not _antiRagdoll then return end
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end
                hum.PlatformStand = false
                hum.Sit = false
            end)
        end
    end)
end

function stopAntiRagdoll()
    if ragdollConn then ragdollConn:Disconnect() ragdollConn = nil end
end

function startAnchor()
    if anchorConn then anchorConn:Disconnect() end
    anchorConn = RunService.Heartbeat:Connect(function()
        if not _anchor then return end
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
    end)
end

function stopAnchor()
    if anchorConn then anchorConn:Disconnect() anchorConn = nil end
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
    end
end

if _antiLag then startAntiLag() end
if _antiRagdoll then startAntiRagdoll() end
if _anchor then startAnchor() end

-- ══════════════════════════════════════
-- AUTO BUY
-- ══════════════════════════════════════
local AB = {
    models = {},
    conns = {},
    last = nil,
    lastAt = 0,
    count = 0,
}

local function abTrack(ch)
    if ch:IsA("Model") and ch:GetAttribute("Index") ~= nil then
        AB.models[ch] = true
    end
end

local function abPromptOf(model)
    local pp = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not pp then return nil end
    for _, d in ipairs(pp:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.Enabled and (d.ActionText == "Purchase" or d.ActionText:lower():find("buy") or d.ActionText:lower():find("purchase")) then
            return d, pp
        end
    end
    return nil
end

local function abNearest()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local best, bestPrompt, bestDist = nil, nil, math.huge
    for m in pairs(AB.models) do
        if m.Parent then
            local p, part = abPromptOf(m)
            if p then
                local dist = (part.Position - root.Position).Magnitude
                if dist < bestDist then
                    best, bestPrompt, bestDist = m, p, dist
                end
            end
        else
            AB.models[m] = nil
        end
    end
    return best, bestPrompt, bestDist
end

local function abBuy(prompt)
    pcall(function()
        prompt.HoldDuration = 0
        prompt.RequiresLineOfSight = false
    end)
    if type(fireproximityprompt) == "function" then
        return pcall(fireproximityprompt, prompt)
    end
    return pcall(function()
        prompt:InputHoldBegin()
        task.wait(0.05)
        prompt:InputHoldEnd()
    end)
end

local function setAutoBuy(on)
    _autoBuyOn = on
    AutoBuyBtn.Text = on and "AUTO BUY  •  ON" or "AUTO BUY  •  OFF"
    AutoBuyBtn.TextColor3 = on and C.White or C.Dim
    tween(AutoBuyBtn, {
        BackgroundColor3 = on and Color3.fromRGB(35, 55, 40) or C.Control
    }, 0.15)

    for _, c in ipairs(AB.conns) do pcall(function() c:Disconnect() end) end
    AB.conns = {}
    AB.models = {}

    if on then
        for _, ch in ipairs(Workspace:GetChildren()) do abTrack(ch) end
        AB.conns[#AB.conns + 1] = Workspace.ChildAdded:Connect(abTrack)
        AB.conns[#AB.conns + 1] = RunService.Heartbeat:Connect(function()
            if not _autoBuyOn then return end
            local m, p, d = abNearest()
            if p and d <= (p.MaxActivationDistance or 10) + 2 then
                local now = os.clock()
                if p ~= AB.last or now - AB.lastAt > 0.9 then
                    AB.last = p
                    AB.lastAt = now
                    if abBuy(p) then
                        AB.count = AB.count + 1
                        InfoLabel.Text = "Bought! Total: " .. AB.count
                        setStatus("Auto Buy success", "ok")
                    end
                end
            end
        end)
        InfoLabel.Text = "Auto Buy scanning..."
    else
        InfoLabel.Text = "Auto Buy off"
    end
end

AutoBuyBtn.MouseButton1Click:Connect(function()
    setAutoBuy(not _autoBuyOn)
end)

-- ══════════════════════════════════════
-- BLOCK EVENTS
-- ══════════════════════════════════════
local function blockEvents()
    pcall(function()
        local folder = ReplicatedStorage:FindFirstChild("Controllers")
        local m = folder and folder:FindFirstChild("EventController", true)
        if m then
            local Events = require(m)
            if type(Events) == "table" and type(Events.Events) == "table" then
                for k, ev in pairs(Events.Events) do
                    if type(ev) == "table" and rawget(ev, "Active") then
                        rawset(ev, "Active", false)
                    end
                end
                if type(Events.Execute) == "function" then
                    Events.Execute = function() return false end
                end
            end
        end
        local fx = folder and folder:FindFirstChild("EffectController", true)
        if fx then
            local Effects = require(fx)
            if type(Effects) == "table" then
                if type(Effects.ActiveEffects) == "table" then
                    for k in pairs(Effects.ActiveEffects) do
                        Effects.ActiveEffects[k] = nil
                    end
                end
                if type(Effects.Run) == "function" then
                    Effects.Run = function() return false, false end
                end
            end
        end
    end)
    -- Stop looped sounds
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Sound") and d.Looped and d.Playing then
            pcall(function() d:Stop() end)
        end
    end
end

local blockThread
local function setBlockEvents(on)
    _blockEventsOn = on
    BlockEventsBtn.Text = on and "BLOCK EVENTS  •  ON" or "BLOCK EVENTS  •  OFF"
    BlockEventsBtn.TextColor3 = on and C.White or C.Dim
    tween(BlockEventsBtn, {
        BackgroundColor3 = on and Color3.fromRGB(70, 30, 30) or C.Control
    }, 0.15)

    if on then
        blockThread = task.spawn(function()
            while _blockEventsOn do
                blockEvents()
                task.wait(1.2)
            end
        end)
        setStatus("Events blocked", "ok")
    else
        setStatus("Events unblocked", nil)
    end
end

BlockEventsBtn.MouseButton1Click:Connect(function()
    setBlockEvents(not _blockEventsOn)
end)

-- ══════════════════════════════════════
-- STOP FUNCTION
-- ══════════════════════════════════════
if getgenv then
    getgenv().StopORS = function()
        _listening = false
        _autoBuyOn = false
        _blockEventsOn = false
        if notifyConn then pcall(function() notifyConn:Disconnect() end) end
        stopAntiLag()
        stopAntiRagdoll()
        stopAnchor()
        for _, c in ipairs(AB.conns) do pcall(function() c:Disconnect() end) end
        if GUI then GUI:Destroy() end
        getgenv().StopORS = nil
        print("[OR'S] Stopped")
    end
end

-- Final
setStatus("OR'S CODE SNIPER ready", "ok")
log("Ready. Press LISTEN or keybind [" .. _listenKeybind .. "]")
print("[OR'S] GUI ready • Theme: Professional Black")

end)

if not success then
    warn("[OR'S] Critical error: " .. tostring(err))
    print("[OR'S] Script failed to load – check executor console")
end