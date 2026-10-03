local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LOCAL_PLAYER = Players.LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")

local GUI_NAME = "WeeklyPingLaggerGui"
local TITLE_IMAGE = "rbxassetid://93667150116606"

local DEFAULT_POWER = 100000
local DEFAULT_DELAY = 0.125
local DEFAULT_KEYBOARD_BIND = Enum.KeyCode.F
local DEFAULT_CONTROLLER_BIND = Enum.KeyCode.ButtonR2

local MAIN_BACKGROUND = Color3.fromRGB(10, 10, 10)
local HEADER_BACKGROUND = Color3.fromRGB(16, 16, 16)
local PANEL_BACKGROUND = Color3.fromRGB(24, 24, 24)
local INPUT_BACKGROUND = Color3.fromRGB(14, 14, 14)
local PRIMARY_RED = Color3.fromRGB(200, 30, 30)
local HOT_RED = Color3.fromRGB(240, 45, 45)
local TEXT_RED = Color3.fromRGB(255, 85, 85)
local TEXT_WHITE = Color3.fromRGB(245, 245, 245)
local TEXT_MUTED = Color3.fromRGB(140, 140, 140)
local STROKE_GREY = Color3.fromRGB(90, 90, 90)
local SWITCH_OFF = Color3.fromRGB(40, 40, 40)
local CLEAR_BUTTON_BACKGROUND = Color3.fromRGB(45, 18, 22)

local ACTIVATE_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, PANEL_BACKGROUND),
    ColorSequenceKeypoint.new(1, HEADER_BACKGROUND),

local ACTIVATED_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, HOT_RED),
    ColorSequenceKeypoint.new(1, TEXT_RED),

local TWEEN_FAST = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MEDIUM = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local existingGui = PLAYER_GUI:FindFirstChild(GUI_NAME)
if existingGui then
    existingGui:Destroy()
end

local weeklyPingLaggerGui = Instance.new("ScreenGui")
weeklyPingLaggerGui.Name = GUI_NAME
weeklyPingLaggerGui.ResetOnSpawn = false
weeklyPingLaggerGui.DisplayOrder = 15
weeklyPingLaggerGui.Parent = PLAYER_GUI

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 248, 0, 352)
mainFrame.Position = UDim2.new(0.5, -124, 0.5, -176)
mainFrame.BackgroundColor3 = MAIN_BACKGROUND
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = weeklyPingLaggerGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 14)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Color = PRIMARY_RED
mainFrameStroke.Thickness = 1.2
mainFrameStroke.Transparency = 0.45
mainFrameStroke.Parent = mainFrame

local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 42)
headerFrame.BackgroundColor3 = HEADER_BACKGROUND
headerFrame.BorderSizePixel = 0
headerFrame.ZIndex = 5
headerFrame.Parent = mainFrame

local headerBottomFrame = Instance.new("Frame")
headerBottomFrame.Size = UDim2.new(1, 0, 0, 14)
headerBottomFrame.Position = UDim2.new(0, 0, 0, 28)
headerBottomFrame.BackgroundColor3 = HEADER_BACKGROUND
headerBottomFrame.BorderSizePixel = 0
headerBottomFrame.ZIndex = 4
headerBottomFrame.Parent = headerFrame

local titleImage = Instance.new("ImageLabel")
titleImage.Name = "TSTitle"
titleImage.Size = UDim2.new(0, 168, 0, 32)
titleImage.Position = UDim2.new(0, 12, 0.5, -16)
titleImage.BackgroundTransparency = 1
titleImage.Image = TITLE_IMAGE
titleImage.ScaleType = Enum.ScaleType.Fit
titleImage.ZIndex = 10
titleImage.Parent = headerFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 26, 0, 26)
minimizeButton.Position = UDim2.new(1, -34, 0.5, -13)
minimizeButton.BackgroundColor3 = PANEL_BACKGROUND
minimizeButton.BorderSizePixel = 0
minimizeButton.AutoButtonColor = false
minimizeButton.Text = "−"
minimizeButton.TextColor3 = TEXT_WHITE
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.ZIndex = 20
minimizeButton.Parent = headerFrame

local minimizeButtonCorner = Instance.new("UICorner")
minimizeButtonCorner.CornerRadius = UDim.new(1, 0)
minimizeButtonCorner.Parent = minimizeButton

local minimizeButtonStroke = Instance.new("UIStroke")
minimizeButtonStroke.Color = STROKE_GREY
minimizeButtonStroke.Thickness = 1
minimizeButtonStroke.Transparency = 0.3
minimizeButtonStroke.Parent = minimizeButton

local miniFrame = Instance.new("Frame")
miniFrame.Name = "MiniFrame"
miniFrame.Size = UDim2.new(0, 198, 0, 46)
miniFrame.Position = UDim2.new(0.5, -99, 0.5, -23)
miniFrame.BackgroundColor3 = MAIN_BACKGROUND
miniFrame.BorderSizePixel = 0
miniFrame.Active = true
miniFrame.Visible = false
miniFrame.ZIndex = 50
miniFrame.Parent = weeklyPingLaggerGui

local miniFrameCorner = Instance.new("UICorner")
miniFrameCorner.CornerRadius = UDim.new(0, 16)
miniFrameCorner.Parent = miniFrame

local miniFrameStroke = Instance.new("UIStroke")
miniFrameStroke.Color = HOT_RED
miniFrameStroke.Thickness = 1.2
miniFrameStroke.Transparency = 0.25
miniFrameStroke.Parent = miniFrame

local miniTitleImage = Instance.new("ImageLabel")
miniTitleImage.Name = "TSTitle"
miniTitleImage.Size = UDim2.new(0, 148, 0, 30)
miniTitleImage.Position = UDim2.new(0, 12, 0.5, -15)
miniTitleImage.BackgroundTransparency = 1
miniTitleImage.Image = TITLE_IMAGE
miniTitleImage.ScaleType = Enum.ScaleType.Fit
miniTitleImage.ZIndex = 51
miniTitleImage.Parent = miniFrame

local restoreButton = Instance.new("TextButton")
restoreButton.Name = "RestoreButton"
restoreButton.Size = UDim2.new(0, 28, 0, 28)
restoreButton.Position = UDim2.new(1, -36, 0.5, -14)
restoreButton.BackgroundColor3 = PANEL_BACKGROUND
restoreButton.BorderSizePixel = 0
restoreButton.AutoButtonColor = false
restoreButton.Text = "+"
restoreButton.TextColor3 = TEXT_WHITE
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 16
restoreButton.ZIndex = 52
restoreButton.Parent = miniFrame

local restoreButtonCorner = Instance.new("UICorner")
restoreButtonCorner.CornerRadius = UDim.new(1, 0)
restoreButtonCorner.Parent = restoreButton

local restoreButtonStroke = Instance.new("UIStroke")
restoreButtonStroke.Color = STROKE_GREY
restoreButtonStroke.Thickness = 1
restoreButtonStroke.Transparency = 0.2
restoreButtonStroke.Parent = restoreButton

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -24, 0, 28)
tabBar.Position = UDim2.new(0, 12, 0, 48)
tabBar.BackgroundColor3 = PANEL_BACKGROUND
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 8
tabBar.Parent = mainFrame

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 8)
tabBarCorner.Parent = tabBar

local tabIndicator = Instance.new("Frame")
tabIndicator.Name = "Indicator"
tabIndicator.Size = UDim2.new(0.5, -2, 1, -4)
tabIndicator.Position = UDim2.new(0, 2, 0, 2)
tabIndicator.BackgroundColor3 = PRIMARY_RED
tabIndicator.BorderSizePixel = 0
tabIndicator.ZIndex = 9
tabIndicator.Parent = tabBar

local tabIndicatorCorner = Instance.new("UICorner")
tabIndicatorCorner.CornerRadius = UDim.new(0, 6)
tabIndicatorCorner.Parent = tabIndicator

local mainTab = Instance.new("TextButton")
mainTab.Name = "MAINTab"
mainTab.Size = UDim2.new(0.5, 0, 1, 0)
mainTab.Position = UDim2.new(0, 0, 0, 0)
mainTab.BackgroundTransparency = 1
mainTab.AutoButtonColor = false
mainTab.Text = "MAIN"
mainTab.TextColor3 = TEXT_WHITE
mainTab.Font = Enum.Font.GothamBold
mainTab.TextSize = 11
mainTab.ZIndex = 10
mainTab.Parent = tabBar

local configTab = Instance.new("TextButton")
configTab.Name = "CONFIGTab"
configTab.Size = UDim2.new(0.5, 0, 1, 0)
configTab.Position = UDim2.new(0.5, 0, 0, 0)
configTab.BackgroundTransparency = 1
configTab.AutoButtonColor = false
configTab.Text = "CONFIG"
configTab.TextColor3 = TEXT_MUTED
configTab.Font = Enum.Font.GothamBold
configTab.TextSize = 11
configTab.ZIndex = 10
configTab.Parent = tabBar

local mainContent = Instance.new("Frame")
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1, -24, 1, -88)
mainContent.Position = UDim2.new(0, 12, 0, 84)
mainContent.BackgroundTransparency = 1
mainContent.ZIndex = 2
mainContent.Parent = mainFrame

local configContent = Instance.new("Frame")
configContent.Name = "ConfigContent"
configContent.Size = UDim2.new(1, -24, 1, -88)
configContent.Position = UDim2.new(0, 12, 0, 84)
configContent.BackgroundTransparency = 1
configContent.Visible = false
configContent.ZIndex = 2
configContent.Parent = mainFrame

local activateButton = Instance.new("TextButton")
activateButton.Size = UDim2.new(1, 0, 0, 34)
activateButton.BackgroundColor3 = PANEL_BACKGROUND
activateButton.BorderSizePixel = 0
activateButton.AutoButtonColor = false
activateButton.Text = ""
activateButton.ZIndex = 3
activateButton.Parent = mainContent

local activateButtonCorner = Instance.new("UICorner")
activateButtonCorner.CornerRadius = UDim.new(0, 8)
activateButtonCorner.Parent = activateButton

local activateButtonGradient = Instance.new("UIGradient")
activateButtonGradient.Color = ACTIVATE_GRADIENT
activateButtonGradient.Rotation = 90
activateButtonGradient.Parent = activateButton

local activateButtonStroke = Instance.new("UIStroke")
activateButtonStroke.Color = PRIMARY_RED
activateButtonStroke.Thickness = 1.3
activateButtonStroke.Transparency = 0.5
activateButtonStroke.Parent = activateButton

local activateButtonLabel = Instance.new("TextLabel")
activateButtonLabel.Size = UDim2.new(1, 0, 1, 0)
activateButtonLabel.BackgroundTransparency = 1
activateButtonLabel.Text = "ACTIVATE LAG"
activateButtonLabel.TextColor3 = TEXT_WHITE
activateButtonLabel.Font = Enum.Font.GothamBlack
activateButtonLabel.TextSize = 13
activateButtonLabel.ZIndex = 5
activateButtonLabel.Parent = activateButton

local function createSettingLabel(parent, text, widthScale)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(widthScale, 0, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TEXT_MUTED
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = parent

    return label
end

local function createRow(parent, yOffset)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.Position = UDim2.new(0, 0, 0, yOffset)
    row.BackgroundTransparency = 1
    row.ZIndex = 3
    row.Parent = parent

    return row
end

local powerRow = createRow(mainContent, 42)
local powerLabel = createSettingLabel(powerRow, "Power", 0.45)

local powerTextBox = Instance.new("TextBox")
powerTextBox.Size = UDim2.new(0, 88, 0, 24)
powerTextBox.Position = UDim2.new(1, -100, 0.5, -12)
powerTextBox.BackgroundColor3 = INPUT_BACKGROUND
powerTextBox.BorderSizePixel = 0
powerTextBox.Text = tostring(DEFAULT_POWER)
powerTextBox.TextColor3 = TEXT_RED
powerTextBox.Font = Enum.Font.GothamBold
powerTextBox.TextSize = 12
powerTextBox.ClearTextOnFocus = false
powerTextBox.ZIndex = 5
powerTextBox.Parent = powerRow

local powerTextBoxCorner = Instance.new("UICorner")
powerTextBoxCorner.CornerRadius = UDim.new(0, 6)
powerTextBoxCorner.Parent = powerTextBox

local powerTextBoxStroke = Instance.new("UIStroke")
powerTextBoxStroke.Color = Color3.fromRGB(160, 25, 25)
powerTextBoxStroke.Transparency = 0.55
powerTextBoxStroke.Parent = powerTextBox

local delayRow = createRow(mainContent, 84)
local delayLabel = createSettingLabel(delayRow, "Delay (s)", 0.45)

local delayTextBox = Instance.new("TextBox")
delayTextBox.Size = UDim2.new(0, 88, 0, 24)
delayTextBox.Position = UDim2.new(1, -100, 0.5, -12)
delayTextBox.BackgroundColor3 = INPUT_BACKGROUND
delayTextBox.BorderSizePixel = 0
delayTextBox.Text = tostring(DEFAULT_DELAY)
delayTextBox.TextColor3 = TEXT_RED
delayTextBox.Font = Enum.Font.GothamBold
delayTextBox.TextSize = 12
delayTextBox.ClearTextOnFocus = false
delayTextBox.ZIndex = 5
delayTextBox.Parent = delayRow

local delayTextBoxCorner = Instance.new("UICorner")
delayTextBoxCorner.CornerRadius = UDim.new(0, 6)
delayTextBoxCorner.Parent = delayTextBox

local delayTextBoxStroke = Instance.new("UIStroke")
delayTextBoxStroke.Color = Color3.fromRGB(160, 25, 25)
delayTextBoxStroke.Transparency = 0.55
delayTextBoxStroke.Parent = delayTextBox

local activeOnStealRow = createRow(mainContent, 126)
local activeOnStealLabel = createSettingLabel(activeOnStealRow, "Active on Steal", 0.7)

local activeOnStealTrack = Instance.new("Frame")
activeOnStealTrack.Size = UDim2.new(0, 40, 0, 20)
activeOnStealTrack.Position = UDim2.new(1, -52, 0.5, -10)
activeOnStealTrack.BackgroundColor3 = SWITCH_OFF
activeOnStealTrack.BorderSizePixel = 0
activeOnStealTrack.ZIndex = 5
activeOnStealTrack.Parent = activeOnStealRow

local activeOnStealTrackCorner = Instance.new("UICorner")
activeOnStealTrackCorner.CornerRadius = UDim.new(1, 0)
activeOnStealTrackCorner.Parent = activeOnStealTrack

local activeOnStealKnob = Instance.new("Frame")
activeOnStealKnob.Size = UDim2.new(0, 16, 0, 16)
activeOnStealKnob.Position = UDim2.new(0, 2, 0.5, -8)
activeOnStealKnob.BackgroundColor3 = TEXT_WHITE
activeOnStealKnob.BorderSizePixel = 0
activeOnStealKnob.ZIndex = 6
activeOnStealKnob.Parent = activeOnStealTrack

local activeOnStealKnobCorner = Instance.new("UICorner")
activeOnStealKnobCorner.CornerRadius = UDim.new(1, 0)
activeOnStealKnobCorner.Parent = activeOnStealKnob

local activeOnStealButton = Instance.new("TextButton")
activeOnStealButton.Size = UDim2.new(1, 0, 1, 0)
activeOnStealButton.BackgroundTransparency = 1
activeOnStealButton.Text = ""
activeOnStealButton.ZIndex = 7
activeOnStealButton.Parent = activeOnStealRow

local keyboardRow = createRow(mainContent, 168)
local keyboardLabel = createSettingLabel(keyboardRow, "Keyboard", 0.38)

local keyboardBindButton = Instance.new("TextButton")
keyboardBindButton.Size = UDim2.new(0, 78, 0, 24)
keyboardBindButton.Position = UDim2.new(1, -114, 0.5, -12)
keyboardBindButton.BackgroundColor3 = INPUT_BACKGROUND
keyboardBindButton.BorderSizePixel = 0
keyboardBindButton.AutoButtonColor = false
keyboardBindButton.Text = DEFAULT_KEYBOARD_BIND.Name
keyboardBindButton.TextColor3 = TEXT_RED
keyboardBindButton.Font = Enum.Font.GothamBold
keyboardBindButton.TextSize = 12
keyboardBindButton.ZIndex = 5
keyboardBindButton.Parent = keyboardRow

local keyboardBindCorner = Instance.new("UICorner")
keyboardBindCorner.CornerRadius = UDim.new(0, 6)
keyboardBindCorner.Parent = keyboardBindButton

local clearKeyboardBindButton = Instance.new("TextButton")
clearKeyboardBindButton.Size = UDim2.new(0, 24, 0, 24)
clearKeyboardBindButton.Position = UDim2.new(1, -30, 0.5, -12)
clearKeyboardBindButton.BackgroundColor3 = CLEAR_BUTTON_BACKGROUND
clearKeyboardBindButton.BorderSizePixel = 0
clearKeyboardBindButton.AutoButtonColor = false
clearKeyboardBindButton.Text = "×"
clearKeyboardBindButton.TextColor3 = TEXT_RED
clearKeyboardBindButton.Font = Enum.Font.GothamBold
clearKeyboardBindButton.TextSize = 14
clearKeyboardBindButton.ZIndex = 5
clearKeyboardBindButton.Parent = keyboardRow

local clearKeyboardBindCorner = Instance.new("UICorner")
clearKeyboardBindCorner.CornerRadius = UDim.new(0, 6)
clearKeyboardBindCorner.Parent = clearKeyboardBindButton

local controllerRow = createRow(mainContent, 210)
local controllerLabel = createSettingLabel(controllerRow, "Controller", 0.38)

local controllerBindButton = Instance.new("TextButton")
controllerBindButton.Size = UDim2.new(0, 108, 0, 24)
controllerBindButton.Position = UDim2.new(1, -120, 0.5, -12)
controllerBindButton.BackgroundColor3 = INPUT_BACKGROUND
controllerBindButton.BorderSizePixel = 0
controllerBindButton.AutoButtonColor = false
controllerBindButton.Text = DEFAULT_CONTROLLER_BIND.Name
controllerBindButton.TextColor3 = TEXT_RED
controllerBindButton.Font = Enum.Font.GothamBold
controllerBindButton.TextSize = 12
controllerBindButton.ZIndex = 5
controllerBindButton.Parent = controllerRow

local controllerBindCorner = Instance.new("UICorner")
controllerBindCorner.CornerRadius = UDim.new(0, 6)
controllerBindCorner.Parent = controllerBindButton

local antiCrasherRow = createRow(configContent, 0)
local antiCrasherLabel = createSettingLabel(antiCrasherRow, "Anti Crasher", 0.7)

local antiLagRow = createRow(configContent, 42)
local antiLagLabel = createSettingLabel(antiLagRow, "Anti Lag", 0.7)

local noFpsDropsRow = createRow(configContent, 84)
local noFpsDropsLabel = createSettingLabel(noFpsDropsRow, "No FPS Drops", 0.7)

local function createToggleControl(row)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 40, 0, 20)
    track.Position = UDim2.new(1, -52, 0.5, -10)
    track.BackgroundColor3 = SWITCH_OFF
    track.BorderSizePixel = 0
    track.ZIndex = 5
    track.Parent = row

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = TEXT_WHITE
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.ZIndex = 7
    button.Parent = row

    return track, knob, button
end

local antiCrasherTrack, antiCrasherKnob, antiCrasherButton = createToggleControl(antiCrasherRow)
local antiLagTrack, antiLagKnob, antiLagButton = createToggleControl(antiLagRow)
local noFpsDropsTrack, noFpsDropsKnob, noFpsDropsButton = createToggleControl(noFpsDropsRow)

local resetDefaultsButton = Instance.new("TextButton")
resetDefaultsButton.Size = UDim2.new(1, 0, 0, 30)
resetDefaultsButton.Position = UDim2.new(0, 0, 0, 136)
resetDefaultsButton.BackgroundTransparency = 1
resetDefaultsButton.AutoButtonColor = false
resetDefaultsButton.Text = "Reset Defaults"
resetDefaultsButton.TextColor3 = TEXT_MUTED
resetDefaultsButton.Font = Enum.Font.GothamMedium
resetDefaultsButton.TextSize = 12
resetDefaultsButton.Parent = configContent

local state = {
    activated = false,
    activeOnSteal = false,
    antiCrasher = false,
    antiLag = false,
    noFpsDrops = false,
    power = DEFAULT_POWER,
    delay = DEFAULT_DELAY,
    keyboardBind = DEFAULT_KEYBOARD_BIND,
    controllerBind = DEFAULT_CONTROLLER_BIND,
    awaitingKeyboardBind = false,
    awaitingControllerBind = false,

local originalEffectSettings = {}

local function tween(instance, properties, tweenInfo)
    local tweenObject = TweenService:Create(instance, tweenInfo or TWEEN_FAST, properties)
    tweenObject:Play()
    return tweenObject
end

local function keyCodeToText(keyCode)
    return keyCode and keyCode.Name or "None"
end

local function sanitizeIntegerTextBox(textBox, fallback, minValue, maxValue)
    local parsed = tonumber(textBox.Text)
    if not parsed then
        textBox.Text = tostring(fallback)
        return fallback
    end

    parsed = math.floor(parsed)
    parsed = math.clamp(parsed, minValue, maxValue)
    textBox.Text = tostring(parsed)
    return parsed
end

local function sanitizeNumberTextBox(textBox, fallback, minValue, maxValue)
    local parsed = tonumber(textBox.Text)
    if not parsed then
        textBox.Text = tostring(fallback)
        return fallback
    end

    parsed = math.clamp(parsed, minValue, maxValue)
    textBox.Text = tostring(parsed)
    return parsed
end

local function setToggle(track, knob, enabled, animated)
    local trackColor = enabled and PRIMARY_RED or SWITCH_OFF
    local knobPosition = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)

    if animated then
        tween(track, { BackgroundColor3 = trackColor }, TWEEN_FAST)
        tween(knob, { Position = knobPosition }, TWEEN_FAST)
    else
        track.BackgroundColor3 = trackColor
        knob.Position = knobPosition
    end
end

local function setActivated(enabled)
    state.activated = enabled

    if enabled then
        activateButtonGradient.Color = ACTIVATED_GRADIENT
        activateButtonLabel.Text = "ACTIVATED"
        activateButtonStroke.Transparency = 0.15
    else
        activateButtonGradient.Color = ACTIVATE_GRADIENT
        activateButtonLabel.Text = "ACTIVATE LAG"
        activateButtonStroke.Transparency = 0.5
    end
end

local function rememberEffect(instance)
    if originalEffectSettings[instance] then
        return
    end

    if instance:IsA("ParticleEmitter") then
        originalEffectSettings[instance] = {
            Rate = instance.Rate,
            Enabled = instance.Enabled,
    elseif instance:IsA("Trail") or instance:IsA("Beam") or instance:IsA("Smoke") or instance:IsA("Fire") or instance:IsA("Sparkles") then
        originalEffectSettings[instance] = {
            Enabled = instance.Enabled,
    end
end

local function applyPerformanceToDescendant(descendant)
    if descendant:IsA("ParticleEmitter") then
        rememberEffect(descendant)

        if state.antiLag or state.antiCrasher then
            descendant.Rate = math.min(descendant.Rate, 15)
        end

        if state.noFpsDrops then
            descendant.Enabled = false
        end
    elseif descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
        rememberEffect(descendant)

        if state.noFpsDrops then
            descendant.Enabled = false
        end
    end
end

local function restoreEffects()
    for instance, settings in pairs(originalEffectSettings) do
        if instance and instance.Parent then
            for property, value in pairs(settings) do
                instance[property] = value
            end
        end
    end

    originalEffectSettings = {}
end

local function applyPerformanceSettings()
    if not state.antiCrasher and not state.antiLag and not state.noFpsDrops then
        restoreEffects()
        return
    end

    for _, descendant in ipairs(workspace:GetDescendants()) do
        applyPerformanceToDescendant(descendant)
    end
end

local function safeActivationHook()
    print("prince"):format(
        GUI_NAME,
        state.power,
        state.delay,
        tostring(state.activeOnSteal)
end

local function toggleActivation()
    if not state.activated then
        setActivated(true)
        safeActivationHook()
    else
        setActivated(false)
    end
end

local function showTab(tabName)
    local showingMain = tabName == "MAIN"

    mainContent.Visible = showingMain
    configContent.Visible = not showingMain
    mainTab.TextColor3 = showingMain and TEXT_WHITE or TEXT_MUTED
    configTab.TextColor3 = showingMain and TEXT_MUTED or TEXT_WHITE

    tween(tabIndicator, {
        Position = showingMain and UDim2.new(0, 2, 0, 2) or UDim2.new(0.5, 0, 0, 2),
    }, TWEEN_MEDIUM)
end

local function setMainMinimized(minimized)
    if minimized then
        miniFrame.Position = UDim2.new(
            mainFrame.Position.X.Offset + 25,
    else
        mainFrame.Position = UDim2.new(
            miniFrame.Position.X.Offset - 25,
    end

    mainFrame.Visible = not minimized
    miniFrame.Visible = minimized
end

local function makeDraggable(handle, target)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        dragStart = input.Position
        startPosition = target.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input ~= dragInput or not dragging or not dragStart or not startPosition then
            return
        end

        local delta = input.Position - dragStart
        target.Position = UDim2.new(
            startPosition.X.Offset + delta.X,
            startPosition.Y.Offset + delta.Y
    end)
end

local function resetDefaults()
    state.power = DEFAULT_POWER
    state.delay = DEFAULT_DELAY
    state.keyboardBind = DEFAULT_KEYBOARD_BIND
    state.controllerBind = DEFAULT_CONTROLLER_BIND
    state.activeOnSteal = false
    state.antiCrasher = false
    state.antiLag = false
    state.noFpsDrops = false

    powerTextBox.Text = tostring(DEFAULT_POWER)
    delayTextBox.Text = tostring(DEFAULT_DELAY)
    keyboardBindButton.Text = keyCodeToText(DEFAULT_KEYBOARD_BIND)
    controllerBindButton.Text = keyCodeToText(DEFAULT_CONTROLLER_BIND)

    setToggle(activeOnStealTrack, activeOnStealKnob, state.activeOnSteal, true)
    setToggle(antiCrasherTrack, antiCrasherKnob, state.antiCrasher, true)
    setToggle(antiLagTrack, antiLagKnob, state.antiLag, true)
    setToggle(noFpsDropsTrack, noFpsDropsKnob, state.noFpsDrops, true)

    applyPerformanceSettings()
end

powerTextBox.Focused:Connect(function()
    powerTextBoxStroke.Transparency = 0.25
end)

powerTextBox.FocusLost:Connect(function()
    state.power = sanitizeIntegerTextBox(powerTextBox, DEFAULT_POWER, 1, 100000)
    powerTextBoxStroke.Transparency = 0.55
end)

delayTextBox.Focused:Connect(function()
    delayTextBoxStroke.Transparency = 0.25
end)

delayTextBox.FocusLost:Connect(function()
    state.delay = sanitizeNumberTextBox(delayTextBox, DEFAULT_DELAY, 0.01, 10)
    delayTextBoxStroke.Transparency = 0.55
end)

activeOnStealButton.MouseButton1Click:Connect(function()
    state.activeOnSteal = not state.activeOnSteal
    setToggle(activeOnStealTrack, activeOnStealKnob, state.activeOnSteal, true)
end)

antiCrasherButton.MouseButton1Click:Connect(function()
    state.antiCrasher = not state.antiCrasher
    setToggle(antiCrasherTrack, antiCrasherKnob, state.antiCrasher, true)
    applyPerformanceSettings()
end)

antiLagButton.MouseButton1Click:Connect(function()
    state.antiLag = not state.antiLag
    setToggle(antiLagTrack, antiLagKnob, state.antiLag, true)
    applyPerformanceSettings()
end)

noFpsDropsButton.MouseButton1Click:Connect(function()
    state.noFpsDrops = not state.noFpsDrops
    setToggle(noFpsDropsTrack, noFpsDropsKnob, state.noFpsDrops, true)
    applyPerformanceSettings()
end)

workspace.DescendantAdded:Connect(function(descendant)
    if state.antiCrasher or state.antiLag or state.noFpsDrops then
        RunService.Heartbeat:Wait()
        applyPerformanceToDescendant(descendant)
    end
end)

minimizeButton.MouseButton1Click:Connect(function()
    setMainMinimized(true)
end)

restoreButton.MouseButton1Click:Connect(function()
    setMainMinimized(false)
end)

minimizeButton.MouseEnter:Connect(function()
    tween(minimizeButton, { BackgroundColor3 = CLEAR_BUTTON_BACKGROUND }, TWEEN_FAST)
end)

minimizeButton.MouseLeave:Connect(function()
    tween(minimizeButton, { BackgroundColor3 = PANEL_BACKGROUND }, TWEEN_FAST)
end)

restoreButton.MouseEnter:Connect(function()
    tween(restoreButton, { BackgroundColor3 = CLEAR_BUTTON_BACKGROUND }, TWEEN_FAST)
end)

restoreButton.MouseLeave:Connect(function()
    tween(restoreButton, { BackgroundColor3 = PANEL_BACKGROUND }, TWEEN_FAST)
end)

mainTab.MouseButton1Click:Connect(function()
    showTab("MAIN")
end)

configTab.MouseButton1Click:Connect(function()
    showTab("CONFIG")
end)

activateButton.MouseButton1Click:Connect(toggleActivation)

activateButton.MouseEnter:Connect(function()
    activateButtonStroke.Transparency = state.activated and 0.1 or 0.35
end)

activateButton.MouseLeave:Connect(function()
    activateButtonStroke.Transparency = state.activated and 0.15 or 0.5
end)

keyboardBindButton.MouseButton1Click:Connect(function()
    state.awaitingKeyboardBind = true
    state.awaitingControllerBind = false
    keyboardBindButton.Text = "..."
end)

clearKeyboardBindButton.MouseButton1Click:Connect(function()
    state.keyboardBind = nil
    state.awaitingKeyboardBind = false
    keyboardBindButton.Text = "None"
end)

controllerBindButton.MouseButton1Click:Connect(function()
    state.awaitingControllerBind = true
    state.awaitingKeyboardBind = false
    controllerBindButton.Text = "..."
end)

resetDefaultsButton.MouseEnter:Connect(function()
    resetDefaultsButton.TextColor3 = TEXT_WHITE
end)

resetDefaultsButton.MouseLeave:Connect(function()
    resetDefaultsButton.TextColor3 = TEXT_MUTED
end)

resetDefaultsButton.MouseButton1Click:Connect(resetDefaults)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if state.awaitingKeyboardBind then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            state.keyboardBind = input.KeyCode
            keyboardBindButton.Text = keyCodeToText(input.KeyCode)
            state.awaitingKeyboardBind = false
        end
        return
    end

    if state.awaitingControllerBind then
        if input.UserInputType.Name:match("Gamepad") then
            state.controllerBind = input.KeyCode
            controllerBindButton.Text = keyCodeToText(input.KeyCode)
            state.awaitingControllerBind = false
        end
        return
    end

    if state.keyboardBind and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == state.keyboardBind then
        toggleActivation()
        return
    end

    if state.controllerBind and input.UserInputType.Name:match("Gamepad") and input.KeyCode == state.controllerBind then
        toggleActivation()
    end
end)

makeDraggable(mainFrame, mainFrame)
makeDraggable(miniFrame, miniFrame)
showTab("MAIN")
resetDefaults()