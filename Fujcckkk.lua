--[[
    OR'S CODE SNIPER
    Combined: Weekly Code Sniper + Traced Code Redeemer + Traced Riddle AI
    Theme: Professional Black / Gray / White
]]


local success, err = pcall(function()


print("[OR'S] Initialising OR'S CODE SNIPER...")


--// Services
local cloneref = cloneref or function(o) return o end
local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local HttpService       = cloneref(game:GetService("HttpService"))
local Lighting          = cloneref(game:GetService("Lighting"))
local Workspace         = cloneref(game:GetService("Workspace"))
local TweenService      = cloneref(game:GetService("TweenService"))
local ProximityPromptService = cloneref(game:GetService("ProximityPromptService"))


local player = Players.LocalPlayer
if not player then warn("[OR'S] No LocalPlayer"); return end
local playerGui = player:WaitForChild("PlayerGui")


--// Stop previous versions
if getgenv then
    pcall(function() if getgenv().StopAura then getgenv().StopAura() end end)
    pcall(function() if getgenv().StopTraced then getgenv().StopTraced() end end)
    pcall(function() if getgenv().StopRiddler then getgenv().StopRiddler() end end)
    pcall(function() if getgenv().StopORS then getgenv().StopORS() end end)
end


--// Config
local CONFIG_FILE = "ors_code_sniper_config.json"
local DEFAULT_BG_ID = "117278680774265"


local savedConfig = {
    codeSniper = true,
    autoSubmit = true,
    submitAfter = 1,
    spamRedeem = true,
    spamCount = 20,
    antiLag = false,
    antiRagdoll = false,
    anchor = false,
    autoTurnOnRedeem = false,
    autoTurnOnListen = true,
    autoTurnOnSubmit = false,
    autoTurnOffSubmit = false,
    autoTurnOffRedeem = false,
    manualMode = false,
    listenKeybind = "C",
    guiScale = 90,
    ezCodeNotify = true,
    bgImage = DEFAULT_BG_ID,
    autoRedeem = true,
    autoType = true,
    wordMode = false,
    ignoreSystem = true,
    spamOnListen = true,
    showKeybinds = true,
    duo = false,
    autoListen = true,
}


pcall(function()
    if isfile and readfile and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            for k,v in pairs(decoded) do
                if savedConfig[k] \~= nil then
                    savedConfig[k] = v
                end
            end
        end
    end
end)


local function saveConfig()
    if writefile then
        pcall(function()
            writefile(CONFIG_FILE, HttpService:JSONEncode(savedConfig))
        end)
    end
end


--// State
local _enabled = savedConfig.codeSniper
local _autoAccept = savedConfig.autoSubmit
local _submitAfter = math.clamp(tonumber(savedConfig.submitAfter) or 1, 1, 4)
local _spamRedeem = savedConfig.spamRedeem
local _spamCount = savedConfig.spamCount or 20
local _guiScale = math.clamp(math.floor((savedConfig.guiScale or 90)/10 + 0.5)*10, 10, 100)
local _listenKeybind = savedConfig.listenKeybind or "C"
local _manualMode = savedConfig.manualMode
local _antiLag = savedConfig.antiLag
local _antiRagdoll = savedConfig.antiRagdoll
local _anchor = savedConfig.anchor
local _autoRedeem = savedConfig.autoRedeem
local _autoType = savedConfig.autoType
local _wordMode = savedConfig.wordMode
local _ignoreSystem = savedConfig.ignoreSystem
local _spamOnListen = savedConfig.spamOnListen
local _autoListen = savedConfig.autoListen
local _duo = savedConfig.duo


local _seen = {}
local _capturedParts = {}
local _manualBuffer = ""
local _lastBox = nil
local _isCollapsed = false


--// Colors - Professional Black Theme
local COLORS = {
    Window      = Color3.fromRGB(8, 8, 10),
    Section     = Color3.fromRGB(16, 16, 20),
    Row         = Color3.fromRGB(22, 22, 28),
    Control     = Color3.fromRGB(32, 32, 40),
    Border      = Color3.fromRGB(55, 55, 65),
    Accent      = Color3.fromRGB(180, 180, 195),
    Accent2     = Color3.fromRGB(120, 140, 255),
    Text        = Color3.fromRGB(240, 240, 245),
    Dim         = Color3.fromRGB(150, 150, 160),
    Ok          = Color3.fromRGB(90, 200, 120),
    Err         = Color3.fromRGB(220, 80, 80),
    Warn        = Color3.fromRGB(230, 180, 70),
    White       = Color3.fromRGB(255, 255, 255),
}


local FONT_TITLE  = Enum.Font.GothamBold
local FONT_BOLD   = Enum.Font.GothamBold
local FONT_MEDIUM = Enum.Font.GothamMedium


--// Utility
local function addCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
    return c
end


local function addStroke(parent, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or COLORS.Border
    s.Thickness = thick or 1
    s.Transparency = trans or 0.4
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end


local function tween(obj, props, t, style)
    local tw = TweenService:Create(obj, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end


local function makeLabel(parent, text, size, pos, textSize, color, font, xAlign)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.Size = size
    l.Position = pos or UDim2.new()
    l.TextSize = textSize or 12
    l.TextColor3 = color or COLORS.Text
    l.Font = font or FONT_MEDIUM
    l.TextXAlignment = xAlign or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Parent = parent
    return l
end


--// Destroy old GUIs
pcall(function()
    for _, name in ipairs({"WeeklyCodeSniperUI","WeeklySettingsUI","ORSCodeSniper","TracedRedeemer","RiddlerUI"}) do
        local o = game.CoreGui:FindFirstChild(name) or playerGui:FindFirstChild(name)
        if o then o:Destroy() end
    end
end)


--// Main GUI
local GUI = Instance.new("ScreenGui")
GUI.Name = "ORSCodeSniper"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() GUI.Parent = game.CoreGui end)
if not GUI.Parent then GUI.Parent = playerGui end


local WINDOW_W, WINDOW_H = 280, 420
local COLLAPSED_H = 48


local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
Window.AnchorPoint = Vector2.new(1, 0)
Window.Position = UDim2.new(1, -12, 0, 12)
Window.BackgroundColor3 = COLORS.Window
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = GUI
addCorner(Window, 12)
addStroke(Window, COLORS.Border, 1, 0.35)


local UIScale = Instance.new("UIScale")
UIScale.Scale = _guiScale / 100
UIScale.Parent = Window


-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = COLORS.Section
Header.BorderSizePixel = 0
Header.Parent = Window
addCorner(Header, 12)


local Title = makeLabel(Header, "OR'S CODE SNIPER", UDim2.new(1, -80, 1, 0), UDim2.fromOffset(14, 0), 15, COLORS.White, FONT_TITLE)
Title.TextXAlignment = Enum.TextXAlignment.Left


local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(28, 28)
MinimizeBtn.Position = UDim2.new(1, -38, 0.5, -14)
MinimizeBtn.BackgroundColor3 = COLORS.Control
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = COLORS.Text
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = FONT_BOLD
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = Header
addCorner(MinimizeBtn, 6)
addStroke(MinimizeBtn, COLORS.Border, 1, 0.5)


-- Status bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 26)
StatusBar.Position = UDim2.fromOffset(10, 50)
StatusBar.BackgroundColor3 = COLORS.Row
StatusBar.BorderSizePixel = 0
StatusBar.Parent = Window
addCorner(StatusBar, 6)


local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.fromOffset(8, 8)
StatusDot.Position = UDim2.fromOffset(10, 9)
StatusDot.BackgroundColor3 = COLORS.Dim
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusBar
addCorner(StatusDot, 4)


local StatusText = makeLabel(StatusBar, "Ready", UDim2.new(1, -30, 1, 0), UDim2.fromOffset(24, 0), 12, COLORS.Dim, FONT_MEDIUM)


local function setStatus(msg, kind)
    StatusText.Text = tostring(msg or "")
    local col = COLORS.Dim
    if kind == "ok" then col = COLORS.Ok
    elseif kind == "err" then col = COLORS.Err
    elseif kind == "busy" or kind == "wait" then col = COLORS.Warn
    elseif kind == "accent" then col = COLORS.Accent2 end
    StatusText.TextColor3 = col
    StatusDot.BackgroundColor3 = col
end


-- Tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -20, 0, 32)
TabBar.Position = UDim2.fromOffset(10, 84)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Window


local function createTab(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.33, -4, 1, 0)
    btn.Position = UDim2.new(order * 0.33, 2, 0, 0)
    btn.BackgroundColor3 = COLORS.Control
    btn.Text = name
    btn.TextColor3 = COLORS.Dim
    btn.TextSize = 11
    btn.Font = FONT_BOLD
    btn.AutoButtonColor = false
    btn.Parent = TabBar
    addCorner(btn, 6)
    addStroke(btn, COLORS.Border, 1, 0.6)
    return btn
end


local MainTab = createTab("MAIN", 0)
local SettingsTab = createTab("SETTINGS", 1)
local UtilsTab = createTab("UTILS", 2)


local function setActiveTab(active)
    for _, b in ipairs({MainTab, SettingsTab, UtilsTab}) do
        local on = b == active
        tween(b, {BackgroundColor3 = on and COLORS.Accent2 or COLORS.Control, TextColor3 = on and COLORS.White or COLORS.Dim}, 0.15)
    end
end


-- Pages
local MainPage = Instance.new("Frame")
MainPage.Size = UDim2.new(1, -20, 1, -130)
MainPage.Position = UDim2.fromOffset(10, 124)
MainPage.BackgroundTransparency = 1
MainPage.Visible = true
MainPage.Parent = Window


local SettingsPage = Instance.new("Frame")
SettingsPage.Size = MainPage.Size
SettingsPage.Position = MainPage.Position
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = Window


local UtilsPage = Instance.new("Frame")
UtilsPage.Size = MainPage.Size
UtilsPage.Position = MainPage.Position
UtilsPage.BackgroundTransparency = 1
UtilsPage.Visible = false
UtilsPage.Parent = Window


-- MAIN PAGE CONTENT
local function createToggleRow(parent, y, label, initial, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.Position = UDim2.fromOffset(0, y)
    row.BackgroundColor3 = COLORS.Row
    row.BorderSizePixel = 0
    row.Parent = parent
    addCorner(row, 7)


    makeLabel(row, label, UDim2.new(1, -70, 1, 0), UDim2.fromOffset(12, 0), 12, COLORS.Text, FONT_MEDIUM)


    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(52, 24)
    btn.Position = UDim2.new(1, -60, 0.5, -12)
    btn.BackgroundColor3 = COLORS.Control
    btn.Text = initial and "ON" or "OFF"
    btn.TextColor3 = initial and COLORS.White or COLORS.Dim
    btn.TextSize = 11
    btn.Font = FONT_BOLD
    btn.AutoButtonColor = false
    btn.Parent = row
    addCorner(btn, 6)
    local stroke = addStroke(btn, COLORS.Border, 1, initial and 0.2 or 0.7)


    local state = initial
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.TextColor3 = state and COLORS.White or COLORS.Dim
        stroke.Transparency = state and 0.2 or 0.7
        tween(btn, {BackgroundColor3 = state and Color3.fromRGB(40, 50, 80) or COLORS.Control}, 0.15)
        if callback then callback(state) end
    end)
    return btn, function(v)
        state = v
        btn.Text = v and "ON" or "OFF"
        btn.TextColor3 = v and COLORS.White or COLORS.Dim
        stroke.Transparency = v and 0.2 or 0.7
    end
end


-- Listen / Redeem buttons
local ListenBtn = Instance.new("TextButton")
ListenBtn.Size = UDim2.new(0.48, -4, 0, 40)
ListenBtn.Position = UDim2.fromOffset(0, 0)
ListenBtn.BackgroundColor3 = COLORS.Control
ListenBtn.Text = "LISTEN  OFF"
ListenBtn.TextColor3 = COLORS.Dim
ListenBtn.TextSize = 13
ListenBtn.Font = FONT_BOLD
ListenBtn.AutoButtonColor = false
ListenBtn.Parent = MainPage
addCorner(ListenBtn, 8)
addStroke(ListenBtn, COLORS.Border, 1, 0.4)


local RedeemBtn = Instance.new("TextButton")
RedeemBtn.Size = UDim2.new(0.48, -4, 0, 40)
RedeemBtn.Position = UDim2.new(0.52, 0, 0, 0)
RedeemBtn.BackgroundColor3 = COLORS.Control
RedeemBtn.Text = "REDEEM"
RedeemBtn.TextColor3 = COLORS.Text
RedeemBtn.TextSize = 13
RedeemBtn.Font = FONT_BOLD
RedeemBtn.AutoButtonColor = false
RedeemBtn.Parent = MainPage
addCorner(RedeemBtn, 8)
addStroke(RedeemBtn, COLORS.Border, 1, 0.4)


local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(1, 0, 0, 36)
CodeBox.Position = UDim2.fromOffset(0, 50)
CodeBox.BackgroundColor3 = COLORS.Section
CodeBox.Text = ""
CodeBox.PlaceholderText = "Code appears here..."
CodeBox.PlaceholderColor3 = COLORS.Dim
CodeBox.TextColor3 = COLORS.White
CodeBox.TextSize = 14
CodeBox.Font = FONT_MEDIUM
CodeBox.ClearTextOnFocus = false
CodeBox.Parent = MainPage
addCorner(CodeBox, 7)
addStroke(CodeBox, COLORS.Border, 1, 0.4)


local ClearBtn = Instance.new("TextButton")
ClearBtn.Size = UDim2.new(0.48, -4, 0, 32)
ClearBtn.Position = UDim2.fromOffset(0, 96)
ClearBtn.BackgroundColor3 = COLORS.Control
ClearBtn.Text = "CLEAR"
ClearBtn.TextColor3 = COLORS.Dim
ClearBtn.TextSize = 12
ClearBtn.Font = FONT_BOLD
ClearBtn.AutoButtonColor = false
ClearBtn.Parent = MainPage
addCorner(ClearBtn, 7)


local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.48, -4, 0, 32)
CopyBtn.Position = UDim2.new(0.52, 0, 0, 96)
CopyBtn.BackgroundColor3 = COLORS.Control
CopyBtn.Text = "COPY"
CopyBtn.TextColor3 = COLORS.Dim
CopyBtn.TextSize = 12
CopyBtn.Font = FONT_BOLD
CopyBtn.AutoButtonColor = false
CopyBtn.Parent = MainPage
addCorner(CopyBtn, 7)


-- Toggles on Main
local autoSubmitBtn, setAutoSubmitVis = createToggleRow(MainPage, 140, "Auto Submit", _autoAccept, function(v)
    _autoAccept = v
    savedConfig.autoSubmit = v
    saveConfig()
end)


local spamBtn, setSpamVis = createToggleRow(MainPage, 180, "Spam Redeem", _spamRedeem, function(v)
    _spamRedeem = v
    savedConfig.spamRedeem = v
    saveConfig()
end)


local manualBtn = createToggleRow(MainPage, 220, "Manual Mode", _manualMode, function(v)
    _manualMode = v
    savedConfig.manualMode = v
    saveConfig()
end)


-- Console
local Console = Instance.new("TextLabel")
Console.Size = UDim2.new(1, 0, 0, 70)
Console.Position = UDim2.fromOffset(0, 270)
Console.BackgroundColor3 = COLORS.Section
Console.Text = ""
Console.TextColor3 = COLORS.Dim
Console.TextSize = 11
Console.Font = FONT_MEDIUM
Console.TextXAlignment = Enum.TextXAlignment.Left
Console.TextYAlignment = Enum.TextYAlignment.Top
Console.TextWrapped = true
Console.Parent = MainPage
addCorner(Console, 7)


local function log(msg)
    Console.Text = tostring(msg)
end


-- SETTINGS PAGE
local y = 0
local function nextY(h)
    local cy = y
    y = y + (h or 40)
    return cy
end


createToggleRow(SettingsPage, nextY(), "Auto Redeem", _autoRedeem, function(v)
    _autoRedeem = v; savedConfig.autoRedeem = v; saveConfig()
end)
createToggleRow(SettingsPage, nextY(), "Auto Type", _autoType, function(v)
    _autoType = v; savedConfig.autoType = v; saveConfig()
end)
createToggleRow(SettingsPage, nextY(), "Word Mode", _wordMode, function(v)
    _wordMode = v; savedConfig.wordMode = v; saveConfig()
end)
createToggleRow(SettingsPage, nextY(), "Ignore System", _ignoreSystem, function(v)
    _ignoreSystem = v; savedConfig.ignoreSystem = v; saveConfig()
end)
createToggleRow(SettingsPage, nextY(), "Auto Listen", _autoListen, function(v)
    _autoListen = v; savedConfig.autoListen = v; saveConfig()
end)
createToggleRow(SettingsPage, nextY(), "Spam on Listen", _spamOnListen, function(v)
    _spamOnListen = v; savedConfig.spamOnListen = v; saveConfig()
end)
createToggleRow(SettingsPage, nextY(), "Duo Mode", _duo, function(v)
    _duo = v; savedConfig.duo = v; saveConfig()
end)


-- UTILS PAGE
y = 0
createToggleRow(UtilsPage, nextY(), "Anti Lag", _antiLag, function(v)
    _antiLag = v; savedConfig.antiLag = v; saveConfig()
    -- anti lag logic can be expanded
end)
createToggleRow(UtilsPage, nextY(), "Anti Ragdoll", _antiRagdoll, function(v)
    _antiRagdoll = v; savedConfig.antiRagdoll = v; saveConfig()
end)
createToggleRow(UtilsPage, nextY(), "Anchor Character", _anchor, function(v)
    _anchor = v; savedConfig.anchor = v; saveConfig()
end)


local AutoBuyBtn = Instance.new("TextButton")
AutoBuyBtn.Size = UDim2.new(1, 0, 0, 36)
AutoBuyBtn.Position = UDim2.fromOffset(0, nextY(44))
AutoBuyBtn.BackgroundColor3 = COLORS.Control
AutoBuyBtn.Text = "AUTO BUY  -  OFF"
AutoBuyBtn.TextColor3 = COLORS.Dim
AutoBuyBtn.TextSize = 13
AutoBuyBtn.Font = FONT_BOLD
AutoBuyBtn.AutoButtonColor = false
AutoBuyBtn.Parent = UtilsPage
addCorner(AutoBuyBtn, 8)


local BlockEventsBtn = Instance.new("TextButton")
BlockEventsBtn.Size = UDim2.new(1, 0, 0, 36)
BlockEventsBtn.Position = UDim2.fromOffset(0, nextY(44))
BlockEventsBtn.BackgroundColor3 = COLORS.Control
BlockEventsBtn.Text = "BLOCK EVENTS  -  OFF"
BlockEventsBtn.TextColor3 = COLORS.Dim
BlockEventsBtn.TextSize = 13
BlockEventsBtn.Font = FONT_BOLD
BlockEventsBtn.AutoButtonColor = false
BlockEventsBtn.Parent = UtilsPage
addCorner(BlockEventsBtn, 8)


-- Tab switching
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
    MinimizeBtn.Text = _isCollapsed and "+" or "-"
    TabBar.Visible = not _isCollapsed
    MainPage.Visible = not _isCollapsed and MainTab.TextColor3 == COLORS.White
    SettingsPage.Visible = false
    UtilsPage.Visible = false
    StatusBar.Visible = not _isCollapsed
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


-- ========================
-- CORE LOGIC (merged)
-- ========================


local getconns = getconnections or (debug and debug.getconnections)
local setclipboard = setclipboard or toclipboard or (syn and syn.write_clipboard)


local function stripRich(t)
    if type(t) \~= "string" then return tostring(t) end
    return (t:gsub("<[^>]->", ""))
end


local function tokenize(t)
    local w = {}
    for word in t:gmatch("[%w_]+") do w[#w+1] = word end
    return w
end


-- Redeem function (from Weekly + Traced)
local function findCodeBox()
    local pg = playerGui
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and d.Visible then
                    local n = d.Name:lower()
                    local p = (d.Parent and d.Parent.Name or ""):lower()
                    if n:find("code") or p:find("code") or n:find("redeem") or p:find("redeem") then
                        return d
                    end
                end
            end
        end
    end
    -- fallback first visible
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and d.Visible then return d end
            end
        end
    end
end


local function clickBtn(btn)
    if not btn then return false end
    if firesignal then
        pcall(firesignal, btn.MouseButton1Click)
        pcall(firesignal, btn.Activated)
    end
    if getconns then
        for _, sig in ipairs({btn.MouseButton1Click, btn.Activated}) do
            local ok, cs = pcall(getconns, sig)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do
                    pcall(function() if c.Enabled \~= false then c:Fire() end end)
                end
            end
        end
    end
    return true
end


local function submitCode(code)
    if not code or code == "" then return false, "empty" end
    code = code:match("^%s*(.-)%s*$") or code


    local pg = playerGui
    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        pcall(function() if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end end)
        local frame = codesGui:FindFirstChild("Codes") or codesGui
        local box, submit
        for _, d in ipairs(frame:GetDescendants()) do
            if d:IsA("TextBox") then box = d end
            if (d:IsA("TextButton") or d:IsA("ImageButton")) then
                local n = d.Name:lower()
                local t = ""
                pcall(function() t = d.Text:lower() end)
                if n:find("confirm") or n:find("submit") or n:find("redeem") or t:find("confirm") or t:find("redeem") then
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
                        task.wait(0.0005)
                    end
                else
                    clickBtn(submit)
                end
            end
            if getconns then
                pcall(function()
                    local ok, cs = pcall(getconns, box.FocusLost)
                    if ok then for _,c in ipairs(cs) do pcall(function() c:Fire(true) end) end end
                end)
            end
            return true, "submitted"
        end
    end


    -- dynamic search
    local box = findCodeBox()
    if not box then return false, "no box" end
    pcall(function() box.Text = code end)
    local redeemBtn
    local p = box.Parent
    for _=1,6 do
        if not p then break end
        for _, d in ipairs(p:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and d \~= box then
                local n = d.Name:lower()
                local t = ""
                pcall(function() t = d.Text:lower() end)
                for _, sn in ipairs({"submit","redeem","claim","confirm","enter","send"}) do
                    if n:find(sn) or t:find(sn) then redeemBtn = d; break end
                end
                if redeemBtn then break end
            end
        end
        if redeemBtn then break end
        p = p.Parent
    end
    if redeemBtn then
        if _spamRedeem then
            for i=1,_spamCount do clickBtn(redeemBtn); task.wait(0.0005) end
        else
            clickBtn(redeemBtn)
        end
    end
    return true, "dynamic"
end


local function doRedeem(code, prefix)
    prefix = prefix or ""
    setStatus(prefix .. "Redeeming: " .. code, "busy")
    log(prefix .. "Redeeming → " .. code)
    local ok, msg = submitCode(code)
    if ok then
        setStatus(prefix .. "Sent: " .. code, "ok")
        log("✓ Sent: " .. code)
    else
        setStatus(prefix .. "Failed: " .. tostring(msg), "err")
        log("✗ Failed: " .. tostring(msg))
    end
    return ok
end


-- Listen state
local listening = false
local function setListening(on)
    listening = on
    ListenBtn.Text = on and "LISTEN  ON" or "LISTEN  OFF"
    ListenBtn.TextColor3 = on and COLORS.White or COLORS.Dim
    tween(ListenBtn, {BackgroundColor3 = on and Color3.fromRGB(40, 55, 90) or COLORS.Control}, 0.18)
    if on then
        setStatus("Listening...", "wait")
        _capturedParts = {}
    else
        setStatus("Idle", "idle")
    end
end


ListenBtn.MouseButton1Click:Connect(function()
    setListening(not listening)
end)


RedeemBtn.MouseButton1Click:Connect(function()
    local t = CodeBox.Text
    if t and t \~= "" then doRedeem(t) end
end)


ClearBtn.MouseButton1Click:Connect(function()
    CodeBox.Text = ""
    _capturedParts = {}
    _manualBuffer = ""
    setStatus(listening and "Listening (cleared)" or "Cleared", listening and "wait" or "idle")
end)


CopyBtn.MouseButton1Click:Connect(function()
    local t = CodeBox.Text
    if t == "" then setStatus("Nothing to copy", "err"); return end
    if setclipboard then
        pcall(setclipboard, t)
        setStatus("Copied: " .. t, "ok")
    else
        setStatus("Clipboard not available", "err")
    end
end)


-- Notification listener (merged logic)
local function isSystemMsg(text)
    if not _ignoreSystem then return false end
    local t = text:lower()
    local bad = {
        "base is full","sold out","already redeemed","already used","code redeemed",
        "you have already","sammy activated","event has started","brainrot express",
        "trade has been","your base is already locked","someone is stealing"
    }
    for _,b in ipairs(bad) do
        if t:find(b,1,true) then return true end
    end
    return false
end


local function extractCode(text)
    -- simple extraction from Traced + Weekly
    local words = tokenize(text)
    if #words == 0 then return nil end
    -- prefer last word that looks like code
    for i = #words, 1, -1 do
        local w = words[i]
        if #w >= 4 and (w:match("%u") or w:match("%d")) then
            return w
        end
    end
    return words[#words]
end


local function onAnnouncement(...)
    local raw = ""
    for i=1, select("#",...) do
        local a = select(i,...)
        if type(a) == "string" and a \~= "" then
            raw = stripRich(a)
            break
        end
    end
    raw = raw:match("^%s*(.-)%s*$") or ""
    if raw == "" then return end
    if isSystemMsg(raw) then return end


    -- auto enable listen
    if _autoListen and not listening then
        local lower = raw:lower()
        if lower:find("use code") or lower:find("code is") or lower:find("type code") or lower:find("redeem") then
            setListening(true)
        end
    end


    if not listening and not _enabled then return end


    local code = extractCode(raw)
    if not code or code == "" then return end


    local key = "c:"..code:lower()
    if _seen[key] then return end
    _seen[key] = true
    task.delay(2, function() _seen[key] = nil end)


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
        if _autoRedeem then
            task.spawn(function() doRedeem(_manualBuffer, "[MAN] ") end)
        end
        return
    end


    -- normal mode
    table.insert(_capturedParts, code)
    local combined = table.concat(_capturedParts, " ")
    CodeBox.Text = combined
    setStatus("Captured ("..#_capturedParts.."/".._submitAfter.."):"..combined, "wait")
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


-- Attach to notification remote
local function resolveNotifyRemote()
    local ok, packages = pcall(function() return ReplicatedStorage:WaitForChild("Packages", 8) end)
    if not ok or not packages then return nil end
    local ok2, net = pcall(function() return packages:WaitForChild("Net", 8) end)
    if not ok2 or not net then return nil end


    local getinfo = debug and (debug.getinfo or debug.info)
    if getgc and getinfo and getconns then
        for _, d in ipairs(net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local okc, cs = pcall(getconns, d.OnClientEvent)
                if okc and type(cs)=="table" then
                    for _, c in ipairs(cs) do
                        local f, fn = pcall(function() return c.Function end)
                        if f and type(fn)=="function" then
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
    -- fallback first few remotes
    for _, d in ipairs(net:GetChildren()) do
        if d:IsA("RemoteEvent") or d:IsA("UnreliableRemoteEvent") then
            return d
        end
    end
end


local notifyRemote = resolveNotifyRemote()
local notifyConn
if notifyRemote then
    notifyConn = notifyRemote.OnClientEvent:Connect(function(...)
        pcall(onAnnouncement, ...)
    end)
    setStatus("Ready • Notify linked", "ok")
    log("Notification remote found")
else
    setStatus("Notify remote not found (fallback)", "warn")
    -- broad fallback
    task.spawn(function()
        local packages = ReplicatedStorage:FindFirstChild("Packages")
        local net = packages and packages:FindFirstChild("Net")
        if net then
            for _, child in ipairs(net:GetChildren()) do
                if child:IsA("RemoteEvent") or child:IsA("UnreliableRemoteEvent") then
                    child.OnClientEvent:Connect(function(...)
                        pcall(onAnnouncement, ...)
                    end)
                end
            end
        end
    end)
end


-- Keybind
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode.Name == _listenKeybind then
        setListening(not listening)
    end
end)


-- Stop function
if getgenv then
    getgenv().StopORS = function()
        if notifyConn then pcall(function() notifyConn:Disconnect() end) end
        if GUI then GUI:Destroy() end
        getgenv().StopORS = nil
    end
end


setStatus("OR'S CODE SNIPER ready", "ok")
print("[OR'S] GUI ready. Use LISTEN to start capturing codes.")


end)


if not success then
    warn("[OR'S] Error: " .. tostring(err))
end