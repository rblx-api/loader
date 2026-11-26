--[[
    OR'S CODE SNIPER
    Combined Redeem + Riddle UI
    Black / White / Gray theme • Smooth animations
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

-- ====================== CONFIG ======================
local CFG = {
    ToggleKey = Enum.KeyCode.RightControl,
    Theme = {
        Bg          = Color3.fromRGB(12, 12, 14),
        Panel       = Color3.fromRGB(18, 18, 22),
        Panel2      = Color3.fromRGB(26, 26, 32),
        Accent      = Color3.fromRGB(255, 255, 255),
        Accent2     = Color3.fromRGB(180, 180, 190),
        Text        = Color3.fromRGB(240, 240, 245),
        SubText     = Color3.fromRGB(140, 140, 155),
        Success     = Color3.fromRGB(80, 200, 120),
        Error       = Color3.fromRGB(220, 70, 70),
        Warn        = Color3.fromRGB(240, 190, 50),
        Line        = Color3.fromRGB(40, 40, 48),
        Input       = Color3.fromRGB(22, 22, 28),
    }
}

-- ====================== UTILITIES ======================
local function Create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    if parent then obj.Parent = parent end
    return obj
end

local function Corner(obj, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8)}, obj)
end

local function Stroke(obj, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or CFG.Theme.Line,
        Thickness = thickness or 1,
        Transparency = transparency or 0
    }, obj)
end

local function Tween(obj, time, props, style, dir)
    local info = TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Padding(obj, l, t, r, b)
    return Create("UIPadding", {
        PaddingLeft = UDim.new(0, l or 0),
        PaddingTop = UDim.new(0, t or 0),
        PaddingRight = UDim.new(0, r or 0),
        PaddingBottom = UDim.new(0, b or 0)
    }, obj)
end

-- ====================== SETTINGS STORAGE ======================
local Settings = {
    AutoRedeem = true,
    AutoType = true,
    AutoListen = true,
    IgnoreSystem = true,
    WordMode = false,
    DuoMode = false,
    ShowTimers = true,
    Secure = false,
    AutoCopy = true,
    OpenFeed = true,
    SpamOnListen = true,
    ShowKeybinds = true,
    UISize = "MEDIUM",
    Speed = "MAX",
}

local function LoadSettings()
    if not (readfile and isfile) then return end
    pcall(function()
        if isfile("ors_sniper_settings.txt") then
            local data = readfile("ors_sniper_settings.txt")
            for line in data:gmatch("[^\n]+") do
                local k, v = line:match("^(%w+)=(.*)$")
                if k and Settings[k] ~= nil then
                    if v == "1" then Settings[k] = true
                    elseif v == "0" then Settings[k] = false
                    else Settings[k] = v end
                end
            end
        end
    end)
end

local function SaveSettings()
    if not writefile then return end
    local lines = {}
    for k, v in pairs(Settings) do
        lines[#lines+1] = k .. "=" .. (type(v) == "boolean" and (v and "1" or "0") or tostring(v))
    end
    table.sort(lines)
    pcall(writefile, "ors_sniper_settings.txt", table.concat(lines, "\n"))
end

LoadSettings()

-- ====================== HEAD BILLBOARD ======================
local function CreateHeadText()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:WaitForChild("Head", 5)
    if not head then return end

    -- Remove old
    local old = head:FindFirstChild("ORS_SNIPER_BILLBOARD")
    if old then old:Destroy() end

    local billboard = Create("BillboardGui", {
        Name = "ORS_SNIPER_BILLBOARD",
        Adornee = head,
        Size = UDim2.fromOffset(220, 50),
        StudsOffset = Vector3.new(0, 2.8, 0),
        AlwaysOnTop = true,
        MaxDistance = 40,
    }, head)

    local container = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
    }, billboard)

    local title = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.fromOffset(0, 4),
        BackgroundTransparency = 1,
        Text = "OR'S CODE SNIPER",
        Font = Enum.Font.GothamBlack,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextStrokeTransparency = 0.4,
        TextStrokeColor = Color3.fromRGB(0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center,
    }, container)

    local line = Create("Frame", {
        Size = UDim2.new(0.7, 0, 0, 2),
        Position = UDim2.new(0.15, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    }, container)
    Corner(line, 1)

    -- Keep alive on character respawn
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        CreateHeadText()
    end)
end

task.spawn(CreateHeadText)

-- ====================== MAIN SCREEN GUI ======================
local ScreenGui = Create("ScreenGui", {
    Name = "ORS_CodeSniper",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 999,
}, (gethui and gethui()) or CoreGui or PlayerGui)

-- ====================== TOGGLE BUTTON ======================
local ToggleBtn = Create("TextButton", {
    Name = "ToggleButton",
    Size = UDim2.fromOffset(210, 38),
    Position = UDim2.new(0, 20, 0.5, -19),
    BackgroundColor3 = CFG.Theme.Panel,
    Text = "OR'S CODE SNIPER",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = CFG.Theme.Text,
    AutoButtonColor = false,
    BorderSizePixel = 0,
}, ScreenGui)

Corner(ToggleBtn, 10)
local ToggleStroke = Stroke(ToggleBtn, CFG.Theme.Accent, 1.5, 0.6)
local TogglePad = Padding(ToggleBtn, 12, 0, 12, 0)

-- Hover effects
ToggleBtn.MouseEnter:Connect(function()
    Tween(ToggleBtn, 0.18, {BackgroundColor3 = CFG.Theme.Panel2})
    Tween(ToggleStroke, 0.18, {Transparency = 0.2})
end)
ToggleBtn.MouseLeave:Connect(function()
    Tween(ToggleBtn, 0.18, {BackgroundColor3 = CFG.Theme.Panel})
    Tween(ToggleStroke, 0.18, {Transparency = 0.6})
end)

-- Drag the toggle button
do
    local dragging, dragStart, startPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ====================== MAIN WINDOW ======================
local Main = Create("Frame", {
    Name = "MainWindow",
    Size = UDim2.fromOffset(420, 520),
    Position = UDim2.new(0.5, -210, 0.5, -260),
    BackgroundColor3 = CFG.Theme.Bg,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
}, ScreenGui)

Corner(Main, 14)
Stroke(Main, CFG.Theme.Accent, 1.5, 0.55)

-- Soft gradient
Create("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 28)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 12))
    },
    Rotation = 90
}, Main)

-- Title bar
local TitleBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = CFG.Theme.Panel,
    BorderSizePixel = 0,
}, Main)
Corner(TitleBar, 14)
Create("Frame", { -- bottom fill so corner doesn't cut
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 1, -16),
    BackgroundColor3 = CFG.Theme.Panel,
    BorderSizePixel = 0,
}, TitleBar)

local TitleLabel = Create("TextLabel", {
    Size = UDim2.new(1, -60, 1, 0),
    Position = UDim2.fromOffset(16, 0),
    BackgroundTransparency = 1,
    Text = "OR'S CODE SNIPER",
    Font = Enum.Font.GothamBlack,
    TextSize = 16,
    TextColor3 = CFG.Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
}, TitleBar)

local Underline = Create("Frame", {
    Size = UDim2.fromOffset(140, 2),
    Position = UDim2.new(0, 16, 1, -10),
    BackgroundColor3 = CFG.Theme.Accent,
    BorderSizePixel = 0,
}, TitleBar)
Corner(Underline, 1)

local CloseBtn = Create("TextButton", {
    Size = UDim2.fromOffset(30, 30),
    Position = UDim2.new(1, -40, 0.5, -15),
    BackgroundColor3 = CFG.Theme.Panel2,
    Text = "×",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = CFG.Theme.Text,
    AutoButtonColor = false,
    BorderSizePixel = 0,
}, TitleBar)
Corner(CloseBtn, 8)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, 0.15, {BackgroundColor3 = CFG.Theme.Error})
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, 0.15, {BackgroundColor3 = CFG.Theme.Panel2})
end)

-- Drag main window
do
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ====================== TABS ======================
local TabBar = Create("Frame", {
    Size = UDim2.new(1, -24, 0, 36),
    Position = UDim2.fromOffset(12, 56),
    BackgroundTransparency = 1,
}, Main)

local TabLayout = Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, TabBar)

local Tabs = {}
local CurrentTab = nil
local ContentFrames = {}

local function CreateTab(name)
    local btn = Create("TextButton", {
        Size = UDim2.new(0.32, -4, 1, 0),
        BackgroundColor3 = CFG.Theme.Panel2,
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = CFG.Theme.SubText,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, TabBar)
    Corner(btn, 8)
    local stroke = Stroke(btn, CFG.Theme.Line, 1, 0.4)

    local content = Create("ScrollingFrame", {
        Name = name .. "Content",
        Size = UDim2.new(1, -24, 1, -110),
        Position = UDim2.fromOffset(12, 100),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = CFG.Theme.Accent2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, -- ONLY vertical
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Visible = false,
    }, Main)

    -- Prevent horizontal scroll
    content:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if content.CanvasPosition.X ~= 0 then
            content.CanvasPosition = Vector2.new(0, content.CanvasPosition.Y)
        end
    end)

    local list = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)
    Padding(content, 2, 4, 2, 12)

    Tabs[name] = {Button = btn, Stroke = stroke, Content = content}
    ContentFrames[name] = content

    btn.MouseButton1Click:Connect(function()
        if CurrentTab == name then return end
        -- Deselect old
        if CurrentTab and Tabs[CurrentTab] then
            Tween(Tabs[CurrentTab].Button, 0.15, {BackgroundColor3 = CFG.Theme.Panel2})
            Tabs[CurrentTab].Button.TextColor3 = CFG.Theme.SubText
            Tween(Tabs[CurrentTab].Stroke, 0.15, {Color = CFG.Theme.Line, Transparency = 0.4})
            Tabs[CurrentTab].Content.Visible = false
        end
        -- Select new
        CurrentTab = name
        Tween(btn, 0.15, {BackgroundColor3 = CFG.Theme.Accent})
        btn.TextColor3 = Color3.fromRGB(10, 10, 12)
        Tween(stroke, 0.15, {Color = CFG.Theme.Accent, Transparency = 0})
        content.Visible = true
    end)

    return content
end

local RedeemContent = CreateTab("REDEEM")
local RiddleContent = CreateTab("RIDDLE")
local SettingsContent = CreateTab("SETTINGS")

-- Default tab
task.defer(function()
    Tabs["REDEEM"].Button.MouseButton1Click:Fire()
end)

-- ====================== UI HELPERS ======================
local function Section(parent, title, order)
    local frame = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = CFG.Theme.Panel,
        BorderSizePixel = 0,
        LayoutOrder = order or 1,
    }, parent)
    Corner(frame, 10)
    Stroke(frame, CFG.Theme.Line, 1, 0.35)
    Padding(frame, 12, 10, 12, 12)

    local list = Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, frame)

    if title then
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBlack,
            TextSize = 12,
            TextColor3 = CFG.Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 0,
        }, frame)
    end
    return frame
end

local function Toggle(parent, text, default, callback, order)
    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = order or 1,
    }, parent)

    Create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = CFG.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local track = Create("Frame", {
        Size = UDim2.fromOffset(44, 22),
        Position = UDim2.new(1, -44, 0.5, -11),
        BackgroundColor3 = default and CFG.Theme.Success or CFG.Theme.Line,
        BorderSizePixel = 0,
    }, row)
    Corner(track, 11)

    local knob = Create("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0, default and 24 or 2, 0.5, -9),
        BackgroundColor3 = CFG.Theme.Text,
        BorderSizePixel = 0,
    }, track)
    Corner(knob, 9)

    local state = default
    local btn = Create("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
    }, row)

    btn.MouseButton1Click:Connect(function()
        state = not state
        Tween(track, 0.18, {BackgroundColor3 = state and CFG.Theme.Success or CFG.Theme.Line})
        Tween(knob, 0.18, {Position = UDim2.new(0, state and 24 or 2, 0.5, -9)}, Enum.EasingStyle.Back)
        if callback then callback(state) end
        SaveSettings()
    end)

    return function() return state end, function(v)
        state = v
        track.BackgroundColor3 = v and CFG.Theme.Success or CFG.Theme.Line
        knob.Position = UDim2.new(0, v and 24 or 2, 0.5, -9)
    end
end

local function Button(parent, text, callback, order, color)
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = color or CFG.Theme.Panel2,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = CFG.Theme.Text,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = order or 1,
    }, parent)
    Corner(btn, 8)
    local s = Stroke(btn, CFG.Theme.Line, 1, 0.3)

    btn.MouseEnter:Connect(function()
        Tween(btn, 0.12, {BackgroundColor3 = CFG.Theme.Accent})
        btn.TextColor3 = Color3.fromRGB(10, 10, 12)
        Tween(s, 0.12, {Transparency = 0})
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, 0.12, {BackgroundColor3 = color or CFG.Theme.Panel2})
        btn.TextColor3 = CFG.Theme.Text
        Tween(s, 0.12, {Transparency = 0.3})
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

local function InputBox(parent, placeholder, order)
    local box = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = CFG.Theme.Input,
        Text = "",
        PlaceholderText = placeholder or "",
        PlaceholderColor3 = CFG.Theme.SubText,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = CFG.Theme.Text,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        LayoutOrder = order or 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
    Corner(box, 8)
    Stroke(box, CFG.Theme.Line, 1, 0.3)
    Padding(box, 10, 0, 10, 0)
    return box
end

local function StatusLabel(parent, order)
    local lbl = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "Ready",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = CFG.Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = order or 1,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
    return lbl
end

-- ====================== REDEEM TAB ======================
do
    local sec = Section(RedeemContent, "CODE REDEEMER", 1)

    local codeBox = InputBox(sec, "Paste code or listen...", 1)
    local status = StatusLabel(sec, 2)

    local getStateAutoRedeem, setStateAutoRedeem = Toggle(sec, "Auto Redeem", Settings.AutoRedeem, function(v)
        Settings.AutoRedeem = v
    end, 3)

    local getStateAutoType, setStateAutoType = Toggle(sec, "Auto Type", Settings.AutoType, function(v)
        Settings.AutoType = v
    end, 4)

    local getStateAutoListen, setStateAutoListen = Toggle(sec, "Auto Listen", Settings.AutoListen, function(v)
        Settings.AutoListen = v
    end, 5)

    local getStateSpam, setStateSpam = Toggle(sec, "Spam On Listen", Settings.SpamOnListen, function(v)
        Settings.SpamOnListen = v
    end, 6)

    local getStateIgnore, setStateIgnore = Toggle(sec, "Ignore System Phrases", Settings.IgnoreSystem, function(v)
        Settings.IgnoreSystem = v
    end, 7)

    local getStateWord, setStateWord = Toggle(sec, "Word Mode", Settings.WordMode, function(v)
        Settings.WordMode = v
    end, 8)

    Button(sec, "REDEEM CODE", function()
        local code = codeBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if code == "" then
            status.Text = "Nothing to redeem"
            status.TextColor3 = CFG.Theme.Error
            return
        end
        status.Text = "Redeeming: " .. code
        status.TextColor3 = CFG.Theme.Warn
        -- Integration point for actual redeem logic
        -- (uses the same remote / code box methods from original)
        pcall(function()
            local codesGui = PlayerGui:FindFirstChild("Codes")
            if codesGui then
                local tb = codesGui:FindFirstChildWhichIsA("TextBox", true)
                if tb then
                    tb.Text = code
                    -- Fire connections if available
                    if getconnections then
                        for _, c in ipairs(getconnections(tb.FocusLost)) do
                            pcall(function() c:Fire( end)
                        end
                    end
                end
            end
        end)
        status.Text = "Sent: " .. code
        status.TextColor3 = CFG.Theme.Success
    end, 9)

    Button(sec, "CLEAR", function()
        codeBox.Text = ""
        status.Text = "Cleared"
        status.TextColor3 = CFG.Theme.SubText
    end, 10)

    -- Status section
    local sec2 = Section(RedeemContent, "STATUS & FEED", 2)
    local feed = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = CFG.Theme.Input,
        Text = "Listening feed will appear here...",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = CFG.Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 1,
    }, sec2)
    Corner(feed, 8)
    Padding(feed, 8, 6, 8, 6)

    -- Expose for external calls
    _G.ORS_Redeem = {
        SetCode = function(c) codeBox.Text = c end,
        GetCode = function() return codeBox.Text end,
        SetStatus = function(t, col)
            status.Text = t
            status.TextColor3 = col or CFG.Theme.SubText
        end,
        AddFeed = function(msg)
            feed.Text = msg .. "\n" .. feed.Text
        end
    }
end

-- ====================== RIDDLE TAB ======================
do
    local sec = Section(RiddleContent, "AI RIDDLE SOLVER", 1)

    local riddleBox = InputBox(sec, "Riddle or drop text...", 1)
    local status = StatusLabel(sec, 2)

    local getAI, setAI = Toggle(sec, "AI Enabled", true, function(v)
        -- AI toggle
    end, 3)

    local getAutoRedeemR, setAutoRedeemR = Toggle(sec, "Auto Redeem Answers", Settings.AutoRedeem, function(v)
        Settings.AutoRedeem = v
    end, 4)

    local getAutoListenR, setAutoListenR = Toggle(sec, "Auto Listen", Settings.AutoListen, function(v)
        Settings.AutoListen = v
    end, 5)

    local getDuo, setDuo = Toggle(sec, "Duo Mode (with Redeemer)", Settings.DuoMode, function(v)
        Settings.DuoMode = v
        _G.__RiddlerDuo = v
        _G.__RdmDuo = v
    end, 6)

    local getTimers, setTimers = Toggle(sec, "Show Timers", Settings.ShowTimers, function(v)
        Settings.ShowTimers = v
    end, 7)

    Button(sec, "SOLVE RIDDLE", function()
        local txt = riddleBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if txt == "" then
            status.Text = "Nothing to solve"
            status.TextColor3 = CFG.Theme.Error
            return
        end
        status.Text = "Solving..."
        status.TextColor3 = CFG.Theme.Warn
        -- Integration: classify + solve
        local kind = _G.__SabClassifyDrop and _G.__SabClassifyDrop(txt) or "unknown"
        status.Text = "Detected: " .. tostring(kind)
        status.TextColor3 = CFG.Theme.Success
        if _G.AskRiddle then
            pcall(_G.AskRiddle, txt)
        end
    end, 8)

    Button(sec, "CLEAR", function()
        riddleBox.Text = ""
        status.Text = "Cleared"
        status.TextColor3 = CFG.Theme.SubText
    end, 9)

    -- Sample riddles section
    local sec2 = Section(RiddleContent, "QUICK TEST", 2)
    Button(sec2, "Load Random Sample Riddle", function()
        local samples = {
            "Riddle: the candy mutation plus my age plus my name",
            "Riddle: the divine mutation plus the cursed mutation",
            "Riddle: this month plus meowl plus jandel",
            "Riddle: the highest income brainrot in the game",
            "Riddle: the cheapest secret brainrot",
            "Riddle: my name plus 67",
            "Riddle: who is my top programmer",
        }
        riddleBox.Text = samples[math.random(#samples)]
    end, 1)

    local sec3 = Section(RiddleContent, "LIVE EXTREMES / DETECTOR", 3)
    local extremesLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 90),
        BackgroundColor3 = CFG.Theme.Input,
        Text = "Extremes & detector status will show here...",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = CFG.Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 1,
    }, sec3)
    Corner(extremesLabel, 8)
    Padding(extremesLabel, 8, 6, 8, 6)

    Button(sec3, "REFRESH STATUS", function()
        if _G.RiddlerDetectorStatus then
            extremesLabel.Text = _G.RiddlerDetectorStatus()
        elseif _G.__RiddlerExtremeSummary then
            extremesLabel.Text = _G.__RiddlerExtremeSummary()
        else
            extremesLabel.Text = "Detector not fully loaded yet"
        end
    end, 2)

    _G.ORS_Riddle = {
        SetText = function(t) riddleBox.Text = t end,
        SetStatus = function(t, col)
            status.Text = t
            status.TextColor3 = col or CFG.Theme.SubText
        end
    }
end

-- ====================== SETTINGS TAB ======================
do
    local sec = Section(SettingsContent, "GENERAL", 1)

    Toggle(sec, "Secure Mode", Settings.Secure, function(v) Settings.Secure = v end, 1)
    Toggle(sec, "Auto Copy", Settings.AutoCopy, function(v) Settings.AutoCopy = v end, 2)
    Toggle(sec, "Open Feed", Settings.OpenFeed, function(v) Settings.OpenFeed = v end, 3)
    Toggle(sec, "Show Keybinds", Settings.ShowKeybinds, function(v) Settings.ShowKeybinds = v end, 4)

    local sec2 = Section(SettingsContent, "UI SIZE", 2)
    local sizeRow = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, sec2)

    local sizes = {"BIG", "MEDIUM", "SMALL"}
    local sizeBtns = {}
    for i, s in ipairs(sizes) do
        local b = Create("TextButton", {
            Size = UDim2.new(0.32, -4, 1, 0),
            Position = UDim2.new((i-1)*0.34, 0, 0, 0),
            BackgroundColor3 = Settings.UISize == s and CFG.Theme.Accent or CFG.Theme.Panel2,
            Text = s,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Settings.UISize == s and Color3.fromRGB(10,10,12) or CFG.Theme.SubText,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        }, sizeRow)
        Corner(b, 7)
        sizeBtns[s] = b
        b.MouseButton1Click:Connect(function()
            Settings.UISize = s
            for name, btn in pairs(sizeBtns) do
                btn.BackgroundColor3 = name == s and CFG.Theme.Accent or CFG.Theme.Panel2
                btn.TextColor3 = name == s and Color3.fromRGB(10,10,12) or CFG.Theme.SubText
            end
            SaveSettings()
        end)
    end

    local sec3 = Section(SettingsContent, "ACTIONS", 3)
    Button(sec3, "SAVE SETTINGS", function()
        SaveSettings()
    end, 1, CFG.Theme.Success)

    Button(sec3, "DESTROY UI", function()
        if ScreenGui then ScreenGui:Destroy() end
        if getgenv and getgenv().StopORS then getgenv().StopORS() end
    end, 2, CFG.Theme.Error)

    local sec4 = Section(SettingsContent, "INFO", 4)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Text = "OR'S CODE SNIPER\nCombined Redeemer + Riddle AI\nBlack / White / Gray Theme",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = CFG.Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 1,
    }, sec4)
end

-- ====================== OPEN / CLOSE LOGIC ======================
local isOpen = false

local function SetOpen(state)
    isOpen = state
    if state then
        Main.Visible = true
        Main.Size = UDim2.fromOffset(420, 20)
        Tween(Main, 0.25, {Size = UDim2.fromOffset(420, 520)}, Enum.EasingStyle.Back)
        Tween(ToggleBtn, 0.2, {BackgroundColor3 = CFG.Theme.Accent})
        ToggleBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    else
        local t = Tween(Main, 0.2, {Size = UDim2.fromOffset(420, 20)})
        t.Completed:Connect(function()
            if not isOpen then Main.Visible = false end
        end)
        Tween(ToggleBtn, 0.2, {BackgroundColor3 = CFG.Theme.Panel})
        ToggleBtn.TextColor3 = CFG.Theme.Text
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    SetOpen(not isOpen)
end)

CloseBtn.MouseButton1Click:Connect(function()
    SetOpen(false)
end)

-- Keybind
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == CFG.ToggleKey then
        SetOpen(not isOpen)
    end
end)

-- ====================== INTEGRATION HOOKS ======================
-- These allow the original systems (if loaded) to talk to the new UI
_G.ORS_Sniper = {
    Open = function() SetOpen(true) end,
    Close = function() SetOpen(false) end,
    Toggle = function() SetOpen(not isOpen) end,
    Settings = Settings,
}

if getgenv then
    getgenv().StopORS = function()
        if ScreenGui then ScreenGui:Destroy() end
        getgenv().StopORS = nil
    end
end

-- ====================== CLASSIFY DROP (shared) ======================
_G.__SabClassifyDrop = _G.__SabClassifyDrop or function(arg)
    local str8 = tostring(arg or "")
    local str9 = str8:lower()
    local words = {}
    for match in str8:gmatch("[%w']+") do
        words[#words + 1] = match
    end
    local count = #words
    if count == 0 then return nil end

    local padded = " " .. str9:gsub("[^%w]", " ") .. " "
    if str9:find("?", 1, true) then return "riddle" end

    for _, w in ipairs({" what ", " how ", " which ", " when ", " who ", " where ", " why ", " guess ", " riddle "}) do
        if padded:find(w, 1, true) then return "riddle" end
    end
    if padded:find(" my ", 1, true) then return "riddle" end
    if count >= 2 and (padded:find(" plus ", 1, true) or str9:find("+", 1, true)) then return "riddle" end
    if count >= 4 and padded:find(" and ", 1, true) then return "riddle" end
    if str9:find("code", 1, true) then return "code" end
    for _, w in ipairs({" redeem ", " type ", " enter ", " claim "}) do
        if padded:find(w, 1, true) then return "code" end
    end
    if count >= 7 then return "riddle" end
    if count == 1 then return "code" end
    return nil
end

print("[OR'S CODE SNIPER] Loaded successfully • Press RightControl or click the button")