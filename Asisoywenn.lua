--[[
    OR'S CODE SNIPER
    Professional Combined UI • Redeem + Riddle
    Clean Black / White / Gray
]]

local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

-- ═══════════════════════════════════════════════════════════════
-- THEME
-- ═══════════════════════════════════════════════════════════════
local T = {
    Bg          = Color3.fromRGB(9, 9, 11),
    Surface     = Color3.fromRGB(14, 14, 17),
    Surface2    = Color3.fromRGB(20, 20, 24),
    Surface3    = Color3.fromRGB(28, 28, 34),
    Border      = Color3.fromRGB(38, 38, 46),
    BorderLight = Color3.fromRGB(55, 55, 65),
    Text        = Color3.fromRGB(245, 245, 250),
    TextDim     = Color3.fromRGB(160, 160, 175),
    TextMuted   = Color3.fromRGB(100, 100, 115),
    White       = Color3.fromRGB(255, 255, 255),
    Success     = Color3.fromRGB(52, 199, 89),
    Error       = Color3.fromRGB(255, 69, 58),
    Warn        = Color3.fromRGB(255, 184, 0),
    Accent      = Color3.fromRGB(255, 255, 255),
}

local ToggleKey = Enum.KeyCode.RightControl

-- ═══════════════════════════════════════════════════════════════
-- UTILITIES
-- ═══════════════════════════════════════════════════════════════
local function Create(class, props, parent)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do inst[k] = v end
    end
    if parent then inst.Parent = parent end
    return inst
end

local function Corner(parent, r)
    return Create("UICorner", { CornerRadius = UDim.new(0, r or 8) }, parent)
end

local function Stroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or T.Border,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, parent)
end

local function Pad(parent, l, t, r, b)
    return Create("UIPadding", {
        PaddingLeft   = UDim.new(0, l or 0),
        PaddingTop    = UDim.new(0, t or 0),
        PaddingRight  = UDim.new(0, r or 0),
        PaddingBottom = UDim.new(0, b or 0),
    }, parent)
end

local function Tween(obj, ti, props)
    local t = TweenService:Create(obj, ti or TweenInfo.new(0.2, Enum.EasingStyle.Quint), props)
    t:Play()
    return t
end

-- ═══════════════════════════════════════════════════════════════
-- SETTINGS
-- ═══════════════════════════════════════════════════════════════
local Settings = {
    AutoRedeem   = true,
    AutoType     = true,
    AutoListen   = true,
    IgnoreSystem = true,
    WordMode     = false,
    DuoMode      = false,
    ShowTimers   = true,
    Secure       = false,
    AutoCopy     = true,
    OpenFeed     = true,
    SpamOnListen = true,
    ShowKeybinds = true,
    UISize       = "MEDIUM",
}

local function LoadSettings()
    if not (readfile and isfile) then return end
    pcall(function()
        if isfile("ors_sniper_settings.txt") then
            for line in readfile("ors_sniper_settings.txt"):gmatch("[^\n]+") do
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

-- ═══════════════════════════════════════════════════════════════
-- HEAD BILLBOARD
-- ═══════════════════════════════════════════════════════════════
local function CreateHeadText()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local head = char:FindFirstChild("Head")
    if not head then return end

    local old = head:FindFirstChild("ORS_SNIPER_BB")
    if old then old:Destroy() end

    local bb = Create("BillboardGui", {
        Name = "ORS_SNIPER_BB",
        Adornee = head,
        Size = UDim2.fromOffset(200, 42),
        StudsOffset = Vector3.new(0, 2.7, 0),
        AlwaysOnTop = true,
        MaxDistance = 35,
    }, head)

    local title = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.fromOffset(0, 2),
        BackgroundTransparency = 1,
        Text = "OR'S CODE SNIPER",
        Font = Enum.Font.GothamBlack,
        TextSize = 15,
        TextColor3 = T.White,
        TextStrokeTransparency = 0.5,
        TextStrokeColor = Color3.new(0, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Center,
    }, bb)

    local line = Create("Frame", {
        Size = UDim2.new(0.65, 0, 0, 1.5),
        Position = UDim2.new(0.175, 0, 0, 26),
        BackgroundColor3 = T.White,
        BorderSizePixel = 0,
    }, bb)
    Corner(line, 1)
end

task.spawn(function()
    CreateHeadText()
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1.2)
        CreateHeadText()
    end)
end)

-- ═══════════════════════════════════════════════════════════════
-- SCREEN GUI
-- ═══════════════════════════════════════════════════════════════
local ScreenGui = Create("ScreenGui", {
    Name = "ORS_CodeSniper",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 1000,
}, (gethui and gethui()) or CoreGui or PlayerGui)

-- ═══════════════════════════════════════════════════════════════
-- FLOATING TOGGLE BUTTON
-- ═══════════════════════════════════════════════════════════════
local ToggleBtn = Create("TextButton", {
    Name = "Toggle",
    Size = UDim2.fromOffset(196, 36),
    Position = UDim2.new(0, 18, 0.5, -18),
    BackgroundColor3 = T.Surface,
    Text = "OR'S CODE SNIPER",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = T.Text,
    AutoButtonColor = false,
    BorderSizePixel = 0,
}, ScreenGui)

Corner(ToggleBtn, 9)
local ToggleStroke = Stroke(ToggleBtn, T.BorderLight, 1, 0.35)

ToggleBtn.MouseEnter:Connect(function()
    Tween(ToggleBtn, TweenInfo.new(0.18), { BackgroundColor3 = T.Surface2 })
    Tween(ToggleStroke, TweenInfo.new(0.18), { Transparency = 0.1 })
end)
ToggleBtn.MouseLeave:Connect(function()
    if not Main or not Main.Visible then
        Tween(ToggleBtn, TweenInfo.new(0.18), { BackgroundColor3 = T.Surface })
        Tween(ToggleStroke, TweenInfo.new(0.18), { Transparency = 0.35 })
    end
end)

-- Drag toggle
do
    local dragging, startPos, startInput
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = ToggleBtn.Position
            startInput = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startInput
            ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════
local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(400, 510),
    Position = UDim2.new(0.5, -200, 0.5, -255),
    BackgroundColor3 = T.Bg,
    BorderSizePixel = 0,
    Visible = false,
    ClipsDescendants = true,
}, ScreenGui)

Corner(Main, 12)
Stroke(Main, T.Border, 1, 0.25)

-- Top accent line
Create("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = T.White,
    BackgroundTransparency = 0.85,
    BorderSizePixel = 0,
    ZIndex = 5,
}, Main)

-- ── Title Bar ──
local TitleBar = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = T.Surface,
    BorderSizePixel = 0,
}, Main)
Corner(TitleBar, 12)
Create("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = T.Surface,
    BorderSizePixel = 0,
}, TitleBar)

local TitleText = Create("TextLabel", {
    Size = UDim2.new(1, -70, 0, 22),
    Position = UDim2.fromOffset(16, 10),
    BackgroundTransparency = 1,
    Text = "OR'S CODE SNIPER",
    Font = Enum.Font.GothamBlack,
    TextSize = 15,
    TextColor3 = T.White,
    TextXAlignment = Enum.TextXAlignment.Left,
}, TitleBar)

local TitleLine = Create("Frame", {
    Size = UDim2.fromOffset(118, 1.5),
    Position = UDim2.fromOffset(16, 34),
    BackgroundColor3 = T.White,
    BorderSizePixel = 0,
}, TitleBar)
Corner(TitleLine, 1)

local CloseBtn = Create("TextButton", {
    Size = UDim2.fromOffset(28, 28),
    Position = UDim2.new(1, -40, 0.5, -14),
    BackgroundColor3 = T.Surface2,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = T.TextDim,
    AutoButtonColor = false,
    BorderSizePixel = 0,
}, TitleBar)
Corner(CloseBtn, 7)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), { BackgroundColor3 = T.Error, TextColor3 = T.White })
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, TweenInfo.new(0.15), { BackgroundColor3 = T.Surface2, TextColor3 = T.TextDim })
end)

-- Drag main
do
    local dragging, startPos, startInput
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = Main.Position
            startInput = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - startInput
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ── Tabs ──
local TabContainer = Create("Frame", {
    Size = UDim2.new(1, -24, 0, 34),
    Position = UDim2.fromOffset(12, 58),
    BackgroundColor3 = T.Surface,
    BorderSizePixel = 0,
}, Main)
Corner(TabContainer, 9)
Stroke(TabContainer, T.Border, 1, 0.4)
Pad(TabContainer, 3, 3, 3, 3)

local TabLayout = Create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 3),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, TabContainer)

local Tabs = {}
local CurrentTab = nil

local function MakeTab(name)
    local btn = Create("TextButton", {
        Size = UDim2.new(0.333, -3, 1, 0),
        BackgroundColor3 = T.Surface,
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = T.TextMuted,
        AutoButtonColor = false,
        BorderSizePixel = 0,
    }, TabContainer)
    Corner(btn, 7)

    local content = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.new(1, -24, 1, -108),
        Position = UDim2.fromOffset(12, 100),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = T.BorderLight,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Visible = false,
    }, Main)

    content:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if content.CanvasPosition.X ~= 0 then
            content.CanvasPosition = Vector2.new(0, content.CanvasPosition.Y)
        end
    end)

    Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)
    Pad(content, 0, 2, 0, 16)

    Tabs[name] = { Btn = btn, Content = content }

    btn.MouseButton1Click:Connect(function()
        if CurrentTab == name then return end
        if CurrentTab and Tabs[CurrentTab] then
            local old = Tabs[CurrentTab]
            Tween(old.Btn, TweenInfo.new(0.15), { BackgroundTransparency = 1, TextColor3 = T.TextMuted })
            old.Content.Visible = false
        end
        CurrentTab = name
        Tween(btn, TweenInfo.new(0.15), { BackgroundTransparency = 0, BackgroundColor3 = T.Surface3, TextColor3 = T.White })
        content.Visible = true
    end)

    return content
end

local RedeemContent  = MakeTab("REDEEM")
local RiddleContent  = MakeTab("RIDDLE")
local SettingsContent = MakeTab("SETTINGS")

task.defer(function()
    Tabs["REDEEM"].Btn.MouseButton1Click:Fire()
end)

-- ═══════════════════════════════════════════════════════════════
-- UI COMPONENTS
-- ═══════════════════════════════════════════════════════════════
local function Card(parent, title, order)
    local card = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.Surface,
        BorderSizePixel = 0,
        LayoutOrder = order or 1,
    }, parent)
    Corner(card, 10)
    Stroke(card, T.Border, 1, 0.35)
    Pad(card, 14, 12, 14, 14)

    Create("UIListLayout", {
        Padding = UDim.new(0, 9),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, card)

    if title then
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            BackgroundTransparency = 1,
            Text = title,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = T.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 0,
        }, card)
    end
    return card
end

local function ToggleRow(parent, label, default, callback, order)
    local row = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        LayoutOrder = order or 1,
    }, parent)

    Create("TextLabel", {
        Size = UDim2.new(1, -54, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, row)

    local track = Create("Frame", {
        Size = UDim2.fromOffset(42, 22),
        Position = UDim2.new(1, -42, 0.5, -11),
        BackgroundColor3 = default and T.Success or T.Surface3,
        BorderSizePixel = 0,
    }, row)
    Corner(track, 11)

    local knob = Create("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(0, default and 23 or 3, 0.5, -8),
        BackgroundColor3 = T.White,
        BorderSizePixel = 0,
    }, track)
    Corner(knob, 8)

    local state = default
    local hit = Create("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
    }, row)

    hit.MouseButton1Click:Connect(function()
        state = not state
        Tween(track, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
            BackgroundColor3 = state and T.Success or T.Surface3
        })
        Tween(knob, TweenInfo.new(0.22, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, state and 23 or 3, 0.5, -8)
        })
        if callback then callback(state) end
        SaveSettings()
    end)

    return function() return state end
end

local function ActionBtn(parent, text, callback, order, style)
    local bg = style == "danger" and T.Error or style == "success" and T.Success or T.Surface2
    local btn = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = bg,
        Text = text,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = (style == "danger" or style == "success") and T.White or T.Text,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = order or 1,
    }, parent)
    Corner(btn, 8)

    local originalBg = bg
    btn.MouseEnter:Connect(function()
        Tween(btn, TweenInfo.new(0.12), { BackgroundColor3 = T.White, TextColor3 = T.Bg })
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, TweenInfo.new(0.12), {
            BackgroundColor3 = originalBg,
            TextColor3 = (style == "danger" or style == "success") and T.White or T.Text
        })
    end)
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return btn
end

local function TextInput(parent, placeholder, order)
    local box = Create("TextBox", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = T.Surface2,
        Text = "",
        PlaceholderText = placeholder or "",
        PlaceholderColor3 = T.TextMuted,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = T.Text,
        ClearTextOnFocus = false,
        BorderSizePixel = 0,
        LayoutOrder = order or 1,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, parent)
    Corner(box, 8)
    Stroke(box, T.Border, 1, 0.4)
    Pad(box, 12, 0, 12, 0)

    box.Focused:Connect(function()
        Tween(box:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.15), { Color = T.White, Transparency = 0.3 })
    end)
    box.FocusLost:Connect(function()
        Tween(box:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.15), { Color = T.Border, Transparency = 0.4 })
    end)
    return box
end

local function StatusText(parent, order)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = "Ready",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = T.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = order or 1,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
end

-- ═══════════════════════════════════════════════════════════════
-- REDEEM TAB
-- ═══════════════════════════════════════════════════════════════
do
    local card = Card(RedeemContent, "CODE REDEEMER", 1)

    local codeBox = TextInput(card, "Enter or capture code...", 1)
    local status  = StatusText(card, 2)

    ToggleRow(card, "Auto Redeem", Settings.AutoRedeem, function(v) Settings.AutoRedeem = v end, 3)
    ToggleRow(card, "Auto Type", Settings.AutoType, function(v) Settings.AutoType = v end, 4)
    ToggleRow(card, "Auto Listen", Settings.AutoListen, function(v) Settings.AutoListen = v end, 5)
    ToggleRow(card, "Spam On Listen", Settings.SpamOnListen, function(v) Settings.SpamOnListen = v end, 6)
    ToggleRow(card, "Ignore System Phrases", Settings.IgnoreSystem, function(v) Settings.IgnoreSystem = v end, 7)
    ToggleRow(card, "Word Mode", Settings.WordMode, function(v) Settings.WordMode = v end, 8)

    ActionBtn(card, "REDEEM CODE", function()
        local code = codeBox.Text:match("^%s*(.-)%s*$") or ""
        if code == "" then
            status.Text = "Nothing to redeem"
            status.TextColor3 = T.Error
            return
        end
        status.Text = "Sending: " .. code
        status.TextColor3 = T.Warn

        pcall(function()
            local codes = PlayerGui:FindFirstChild("Codes")
            if codes then
                local tb = codes:FindFirstChildWhichIsA("TextBox", true)
                if tb then
                    tb.Text = code
                    if getconnections then
                        for _, conn in ipairs(getconnections(tb.FocusLost)) do
                            pcall(function() conn:Fire() end)
                        end
                    end
                end
            end
        end)

        status.Text = "Sent → " .. code
        status.TextColor3 = T.Success
    end, 9)

    ActionBtn(card, "CLEAR", function()
        codeBox.Text = ""
        status.Text = "Cleared"
        status.TextColor3 = T.TextMuted
    end, 10)

    -- Feed card
    local feedCard = Card(RedeemContent, "LIVE FEED", 2)
    local feedLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = T.Surface2,
        Text = "Waiting for codes...",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = T.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 1,
    }, feedCard)
    Corner(feedLabel, 8)
    Pad(feedLabel, 10, 8, 10, 8)

    _G.ORS_Redeem = {
        SetCode   = function(c) codeBox.Text = c end,
        GetCode   = function() return codeBox.Text end,
        SetStatus = function(t, c) status.Text = t status.TextColor3 = c or T.TextMuted end,
        AddFeed   = function(msg) feedLabel.Text = msg .. "\n" .. feedLabel.Text end,
    }
end

-- ═══════════════════════════════════════════════════════════════
-- RIDDLE TAB
-- ═══════════════════════════════════════════════════════════════
do
    local card = Card(RiddleContent, "AI RIDDLE SOLVER", 1)

    local riddleBox = TextInput(card, "Paste riddle or drop text...", 1)
    local status    = StatusText(card, 2)

    ToggleRow(card, "AI Enabled", true, function() end, 3)
    ToggleRow(card, "Auto Redeem Answers", Settings.AutoRedeem, function(v) Settings.AutoRedeem = v end, 4)
    ToggleRow(card, "Auto Listen", Settings.AutoListen, function(v) Settings.AutoListen = v end, 5)
    ToggleRow(card, "Duo Mode", Settings.DuoMode, function(v)
        Settings.DuoMode = v
        _G.__RiddlerDuo = v
        _G.__RdmDuo = v
    end, 6)
    ToggleRow(card, "Show Timers", Settings.ShowTimers, function(v) Settings.ShowTimers = v end, 7)

    ActionBtn(card, "SOLVE RIDDLE", function()
        local txt = riddleBox.Text:match("^%s*(.-)%s*$") or ""
        if txt == "" then
            status.Text = "Nothing to solve"
            status.TextColor3 = T.Error
            return
        end
        status.Text = "Analyzing..."
        status.TextColor3 = T.Warn

        local kind = _G.__SabClassifyDrop and _G.__SabClassifyDrop(txt) or "unknown"
        status.Text = "Type: " .. tostring(kind)
        status.TextColor3 = T.Success

        if _G.AskRiddle then
            pcall(_G.AskRiddle, txt)
        end
    end, 8)

    ActionBtn(card, "CLEAR", function()
        riddleBox.Text = ""
        status.Text = "Cleared"
        status.TextColor3 = T.TextMuted
    end, 9)

    -- Samples
    local sampleCard = Card(RiddleContent, "QUICK SAMPLES", 2)
    ActionBtn(sampleCard, "Load Random Sample", function()
        local list = {
            "Riddle: the candy mutation plus my age plus my name",
            "Riddle: the divine mutation plus the cursed mutation",
            "Riddle: the highest income brainrot in the game",
            "Riddle: the cheapest secret brainrot",
            "Riddle: my name plus 67",
            "Riddle: who is my top programmer",
            "Riddle: the rarest og",
        }
        riddleBox.Text = list[math.random(#list)]
    end, 1)

    -- Detector
    local detCard = Card(RiddleContent, "DETECTOR / EXTREMES", 3)
    local detLabel = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = T.Surface2,
        Text = "Status will appear here...",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = T.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 1,
    }, detCard)
    Corner(detLabel, 8)
    Pad(detLabel, 10, 8, 10, 8)

    ActionBtn(detCard, "REFRESH STATUS", function()
        if _G.RiddlerDetectorStatus then
            detLabel.Text = _G.RiddlerDetectorStatus()
        elseif _G.__RiddlerExtremeSummary then
            detLabel.Text = _G.__RiddlerExtremeSummary()
        else
            detLabel.Text = "Detector not loaded"
        end
    end, 2)

    _G.ORS_Riddle = {
        SetText   = function(t) riddleBox.Text = t end,
        SetStatus = function(t, c) status.Text = t status.TextColor3 = c or T.TextMuted end,
    }
end

-- ═══════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════
do
    local card = Card(SettingsContent, "GENERAL", 1)
    ToggleRow(card, "Secure Mode", Settings.Secure, function(v) Settings.Secure = v end, 1)
    ToggleRow(card, "Auto Copy", Settings.AutoCopy, function(v) Settings.AutoCopy = v end, 2)
    ToggleRow(card, "Open Feed", Settings.OpenFeed, function(v) Settings.OpenFeed = v end, 3)
    ToggleRow(card, "Show Keybinds", Settings.ShowKeybinds, function(v) Settings.ShowKeybinds = v end, 4)

    local sizeCard = Card(SettingsContent, "UI SIZE", 2)
    local sizeRow = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, sizeCard)

    local sizes = {"BIG", "MEDIUM", "SMALL"}
    local sizeBtns = {}
    for i, s in ipairs(sizes) do
        local b = Create("TextButton", {
            Size = UDim2.new(0.32, -3, 1, 0),
            Position = UDim2.new((i-1) * 0.34, 0, 0, 0),
            BackgroundColor3 = Settings.UISize == s and T.White or T.Surface2,
            Text = s,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = Settings.UISize == s and T.Bg or T.TextDim,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        }, sizeRow)
        Corner(b, 7)
        sizeBtns[s] = b
        b.MouseButton1Click:Connect(function()
            Settings.UISize = s
            for name, btn in pairs(sizeBtns) do
                btn.BackgroundColor3 = name == s and T.White or T.Surface2
                btn.TextColor3 = name == s and T.Bg or T.TextDim
            end
            SaveSettings()
        end)
    end

    local actCard = Card(SettingsContent, "ACTIONS", 3)
    ActionBtn(actCard, "SAVE SETTINGS", function()
        SaveSettings()
    end, 1, "success")

    ActionBtn(actCard, "DESTROY UI", function()
        if ScreenGui then ScreenGui:Destroy() end
        if getgenv and getgenv().StopORS then getgenv().StopORS() end
    end, 2, "danger")

    local infoCard = Card(SettingsContent, "INFO", 4)
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
        Text = "OR'S CODE SNIPER\nRedeem + Riddle combined\nClean professional interface",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = T.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = 1,
    }, infoCard)
end

-- ═══════════════════════════════════════════════════════════════
-- OPEN / CLOSE
-- ═══════════════════════════════════════════════════════════════
local isOpen = false

local function SetOpen(state)
    isOpen = state
    if state then
        Main.Visible = true
        Main.Size = UDim2.fromOffset(400, 30)
        Tween(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(400, 510) })
        Tween(ToggleBtn, TweenInfo.new(0.2), { BackgroundColor3 = T.White, TextColor3 = T.Bg })
        Tween(ToggleStroke, TweenInfo.new(0.2), { Transparency = 0 })
    else
        local tw = Tween(Main, TweenInfo.new(0.2, Enum.EasingStyle.Quint), { Size = UDim2.fromOffset(400, 30) })
        tw.Completed:Connect(function()
            if not isOpen then Main.Visible = false end
        end)
        Tween(ToggleBtn, TweenInfo.new(0.2), { BackgroundColor3 = T.Surface, TextColor3 = T.Text })
        Tween(ToggleStroke, TweenInfo.new(0.2), { Transparency = 0.35 })
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    SetOpen(not isOpen)
end)

CloseBtn.MouseButton1Click:Connect(function()
    SetOpen(false)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == ToggleKey then
        SetOpen(not isOpen)
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- SHARED + API
-- ═══════════════════════════════════════════════════════════════
_G.ORS_Sniper = {
    Open     = function() SetOpen(true) end,
    Close    = function() SetOpen(false) end,
    Toggle   = function() SetOpen(not isOpen) end,
    Settings = Settings,
}

if getgenv then
    getgenv().StopORS = function()
        if ScreenGui then ScreenGui:Destroy() end
        getgenv().StopORS = nil
    end
end

_G.__SabClassifyDrop = _G.__SabClassifyDrop or function(arg)
    local s = tostring(arg or ""):lower()
    local words = {}
    for w in tostring(arg or ""):gmatch("[%w']+") do words[#words+1] = w end
    local n = #words
    if n == 0 then return nil end
    local p = " " .. s:gsub("[^%w]", " ") .. " "
    if s:find("?", 1, true) then return "riddle" end
    for _, k in ipairs({" what "," how "," which "," when "," who "," where "," why "," guess "," riddle "}) do
        if p:find(k, 1, true) then return "riddle" end
    end
    if p:find(" my ", 1, true) then return "riddle" end
    if n >= 2 and (p:find(" plus ", 1, true) or s:find("+", 1, true)) then return "riddle" end
    if n >= 4 and p:find(" and ", 1, true) then return "riddle" end
    if s:find("code", 1, true) then return "code" end
    for _, k in ipairs({" redeem "," type "," enter "," claim "}) do
        if p:find(k, 1, true) then return "code" end
    end
    if n >= 7 then return "riddle" end
    if n == 1 then return "code" end
    return nil
end

print("[OR'S CODE SNIPER] Ready • RightControl to toggle")