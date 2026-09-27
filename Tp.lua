local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer

local function getGuiParent()
    if localPlayer:FindFirstChild("PlayerGui") then
        return localPlayer.PlayerGui
    end
    return CoreGui
end

local guiParent = getGuiParent()

local versionConfigs = {
    V1 = {
        range = 250,
        tpOffset = Vector3.new(0, 0, 0),
        loopDelay = 0.08,
        smartRotation = true,
        resetVelocity = true,
        predictMovement = true,
        predictionFactor = 0.15,
        healthCheck = true,
        teamCheck = false,
        behindTarget = false,
        behindDistance = 4,
        antiFling = true,
        sideOffset = 2.5,
    },
    V2 = {
        range = 250,
        tpOffset = Vector3.new(0, 3, 0),
        loopDelay = 0.08,
        smartRotation = false,
        resetVelocity = true,
        predictMovement = false,
        predictionFactor = 0,
        healthCheck = true,
        teamCheck = false,
        behindTarget = false,
        behindDistance = 0,
        antiFling = false,
        sideOffset = 0,
    },
}

local settings = {
    toggleKey = Enum.KeyCode.Y,
    antiDieKey = Enum.KeyCode.G,
    autoBatEnabled = true,
    autoBatDelay = 0.08,
    currentVersion = "V1",
}

local programState = {
    isTpBatActive = false,
    isAntiDieActive = false,
    isRunning = false,
    tpLoopThread = nil,
    isWaitingForKey = false,
    hittingCooldown = false,
    uiReferences = {},
}

local function getActiveConfig()
    return versionConfigs[settings.currentVersion]
end

local function getMyRootPart()
    local character = localPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

local function getMyHumanoid()
    local character = localPlayer.Character
    if not character then return nil end
    return character:FindFirstChildOfClass("Humanoid")
end

local function getBat()
    local character = localPlayer.Character
    if not character then return nil end
    local tool = character:FindFirstChild("Bat")
    if tool then return tool end
    local backpack = localPlayer:FindFirstChild("Backpack")
    if backpack then
        tool = backpack:FindFirstChild("Bat")
        if tool then
            tool.Parent = character
            return tool
        end
    end
    return nil
end

local function tryHitBat()
    if programState.hittingCooldown then return end
    programState.hittingCooldown = true
    pcall(function()
        local bat = getBat()
        if bat then
            bat:Activate()
            local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remoteEvent then remoteEvent:FireServer() end
        end
    end)
    task.delay(settings.autoBatDelay, function() programState.hittingCooldown = false end)
end

local function isValidEnemy(player)
    local config = getActiveConfig()
    if player == localPlayer then return false end
    if not player.Character then return false end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if config.healthCheck and humanoid.Health <= 0 then return false end

    if config.teamCheck then
        if player.Team == localPlayer.Team and player.Team ~= nil then
            return false
        end
    end

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end

    return true, rootPart, humanoid
end

local function predictPosition(rootPart)
    local config = getActiveConfig()
    if not config.predictMovement then return rootPart.Position end
    return rootPart.Position + (rootPart.AssemblyLinearVelocity * config.predictionFactor)
end

local function findNearestEnemy()
    local config = getActiveConfig()
    local myRootPart = getMyRootPart()
    if not myRootPart then return nil end

    local nearestRootPart = nil
    local shortestDist = config.range

    for _, player in ipairs(Players:GetPlayers()) do
        local valid, rootPart = isValidEnemy(player)
        if valid then
            local dist = (rootPart.Position - myRootPart.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearestRootPart = rootPart
            end
        end
    end
    return nearestRootPart
end

local function teleportTo(targetRootPart)
    local config = getActiveConfig()
    local myRootPart = getMyRootPart()
    local myHumanoid = getMyHumanoid()
    if not myRootPart then return end

    local targetPos = predictPosition(targetRootPart)
    local finalPos

    if config.behindTarget then
        local direction = (targetPos - myRootPart.Position).Unit
        finalPos = targetPos + (direction * -config.behindDistance)
        finalPos = finalPos + Vector3.new(0, 2, 0)
    else
        if config.sideOffset and config.sideOffset > 0 then
            local dir = (myRootPart.Position - targetPos)
            dir = Vector3.new(dir.X, 0, dir.Z)
            if dir.Magnitude < 0.1 then
                dir = Vector3.new(1, 0, 0)
            else
                dir = dir.Unit
            end
            finalPos = targetPos + (dir * config.sideOffset)
        else
            finalPos = targetPos + config.tpOffset
        end
    end

    local newCFrame
    if config.smartRotation then
        newCFrame = CFrame.new(finalPos, targetPos)
    else
        newCFrame = CFrame.new(finalPos)
    end

    myRootPart.CFrame = newCFrame

    if config.resetVelocity then
        myRootPart.Velocity = Vector3.new(0, 0, 0)
        myRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        myRootPart.RotVelocity = Vector3.new(0, 0, 0)
        myRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end

    if config.antiFling and myHumanoid then
        myHumanoid.PlatformStand = false
        myHumanoid.Sit = false
    end
end

local function updateStatusUI(isActive)
    if programState.uiReferences.StatusLabel then
        if isActive then
            programState.uiReferences.StatusLabel.Text = 'ACTIVE'
            programState.uiReferences.StatusLabel.TextColor3 = Color3.new(0.392157, 1, 0.470588)
            if programState.uiReferences.StatusDot then
                programState.uiReferences.StatusDot.BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)
            end
        else
            programState.uiReferences.StatusLabel.Text = 'INACTIVE'
            programState.uiReferences.StatusLabel.TextColor3 = Color3.new(1, 0.313726, 0.392157)
            if programState.uiReferences.StatusDot then
                programState.uiReferences.StatusDot.BackgroundColor3 = Color3.new(1, 0.313726, 0.392157)
            end
        end
    end
end

local function startTpBat()
    if programState.isRunning then return end
    programState.isRunning = true
    programState.isTpBatActive = true
    programState.tpLoopThread = task.spawn(function()
        while programState.isTpBatActive do
            local target = findNearestEnemy()
            if target then
                teleportTo(target)
                if settings.autoBatEnabled then
                    tryHitBat()
                end
            end
            task.wait(getActiveConfig().loopDelay)
        end
    end)
    updateStatusUI(true)
end

local function stopTpBat()
    if not programState.isRunning then return end
    programState.isRunning = false
    programState.isTpBatActive = false
    if programState.tpLoopThread then
        pcall(function() task.cancel(programState.tpLoopThread) end)
        programState.tpLoopThread = nil
    end
    updateStatusUI(false)
end

local function toggleTpBat()
    if programState.isTpBatActive then stopTpBat() else startTpBat() end
end

local antiDieEnabled = false
local antiDieBillboard = nil

local function createAntiDieBillboard(character)
    if not character then return end
    local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 5)
    if not head then return end

    if antiDieBillboard then antiDieBillboard:Destroy() antiDieBillboard = nil end
    local oldTag = head:FindFirstChild("AntiDieTag")
    if oldTag then oldTag:Destroy() end

    antiDieBillboard = Instance.new("BillboardGui")
    antiDieBillboard.Name = "AntiDieTag"
    antiDieBillboard.Size = UDim2.new(0, 200, 0, 60)
    antiDieBillboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
    antiDieBillboard.AlwaysOnTop = true
    antiDieBillboard.LightInfluence = 0
    antiDieBillboard.MaxDistance = math.huge
    antiDieBillboard.ResetOnSpawn = false
    antiDieBillboard.Parent = head

    local frame = Instance.new("Frame", antiDieBillboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local txt1 = Instance.new("TextLabel", frame)
    txt1.Size = UDim2.new(1, 0, 0.5, 0)
    txt1.BackgroundTransparency = 1
    txt1.Text = "ANTI DIE"
    txt1.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt1.Font = Enum.Font.GothamBlack
    txt1.TextSize = 20
    txt1.TextXAlignment = Enum.TextXAlignment.Center
    txt1.TextYAlignment = Enum.TextYAlignment.Bottom

    local txt2 = Instance.new("TextLabel", frame)
    txt2.Size = UDim2.new(1, 0, 0.5, 0)
    txt2.Position = UDim2.new(0, 0, 0.5, 0)
    txt2.BackgroundTransparency = 1
    txt2.Text = "debofed by fa4e7xx"
    txt2.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt2.Font = Enum.Font.GothamBold
    txt2.TextSize = 14
    txt2.TextXAlignment = Enum.TextXAlignment.Center
    txt2.TextYAlignment = Enum.TextYAlignment.Top
end

local function destroyAntiDieBillboard()
    if antiDieBillboard then
        antiDieBillboard:Destroy()
        antiDieBillboard = nil
    end
    local character = localPlayer.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            local oldTag = head:FindFirstChild("AntiDieTag")
            if oldTag then oldTag:Destroy() end
        end
    end
end

local heartBeatConnection = nil
local deathConnections = {}
local characterAddedConnection = nil

local function protectCharacter(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    local stateChanged = humanoid.StateChanged:Connect(function(_, newState)
        if not antiDieEnabled then return end
        if newState == Enum.HumanoidStateType.Dead then
            humanoid.Health = math.huge
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)
    table.insert(deathConnections, stateChanged)

    local healthChanged = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if not antiDieEnabled then return end
        if humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = math.huge
        end
    end)
    table.insert(deathConnections, healthChanged)

    if heartBeatConnection then heartBeatConnection:Disconnect() end
    heartBeatConnection = RunService.Heartbeat:Connect(function()
        if not antiDieEnabled then return end
        if humanoid and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = math.huge
        end
    end)

    createAntiDieBillboard(character)
end

local function startAntiDie()
    antiDieEnabled = true
    programState.isAntiDieActive = true

    for _, conn in ipairs(deathConnections) do pcall(function() conn:Disconnect() end) end
    deathConnections = {}
    if heartBeatConnection then heartBeatConnection:Disconnect(); heartBeatConnection = nil end
    if characterAddedConnection then characterAddedConnection:Disconnect(); characterAddedConnection = nil end

    local character = localPlayer.Character
    if character then protectCharacter(character) end

    characterAddedConnection = localPlayer.CharacterAdded:Connect(function(newChar)
        if not antiDieEnabled then return end
        task.wait(0.2)
        for _, conn in ipairs(deathConnections) do pcall(function() conn:Disconnect() end) end
        deathConnections = {}
        protectCharacter(newChar)
    end)
end

local function stopAntiDie()
    antiDieEnabled = false
    programState.isAntiDieActive = false

    for _, conn in ipairs(deathConnections) do pcall(function() conn:Disconnect() end) end
    deathConnections = {}
    if heartBeatConnection then heartBeatConnection:Disconnect(); heartBeatConnection = nil end
    if characterAddedConnection then characterAddedConnection:Disconnect(); characterAddedConnection = nil end

    destroyAntiDieBillboard()

    local character = localPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

local function toggleAntiDie()
    if antiDieEnabled then stopAntiDie() else startAntiDie() end
end

local function startKeybindListener()
    if programState.isWaitingForKey then return end
    programState.isWaitingForKey = true

    if programState.uiReferences.KeyLabel then
        programState.uiReferences.KeyLabel.Text = '...'
        programState.uiReferences.KeyLabel.TextColor3 = Color3.new(1, 0.8, 0.2)
    end

    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

        if input.KeyCode == Enum.KeyCode.Escape then
            programState.isWaitingForKey = false
            if programState.uiReferences.KeyLabel then
                programState.uiReferences.KeyLabel.Text = settings.toggleKey.Name
                programState.uiReferences.KeyLabel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
            end
            connection:Disconnect()
            return
        end

        settings.toggleKey = input.KeyCode
        programState.isWaitingForKey = false

        if programState.uiReferences.KeyLabel then
            programState.uiReferences.KeyLabel.Text = input.KeyCode.Name
            programState.uiReferences.KeyLabel.TextColor3 = Color3.new(0.392157, 1, 0.470588)
            task.wait(0.3)
            programState.uiReferences.KeyLabel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
        end

        connection:Disconnect()
    end)
end

local function buildUI()
    local oldUI = guiParent:FindFirstChild("SpaceTpBatUI")
    if oldUI then oldUI:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = 'SpaceTpBatUI'
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 10
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = guiParent

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = 'Main'
    mainFrame.Size = UDim2.new(0, 250, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -125, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 1
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 16)
    mainCorner.Parent = mainFrame

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, 16, 0, 12)
    dot.BackgroundColor3 = Color3.new(0.705882, 0.705882, 0.705882)
    dot.BorderSizePixel = 0
    dot.ZIndex = 5
    dot.Parent = mainFrame

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 180, 0, 18)
    title.Position = UDim2.new(0, 36, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = 'Space Tp Bat'
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 5
    title.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -32, 0, 10)
    closeBtn.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
    closeBtn.BackgroundTransparency = 0.5
    closeBtn.Text = '-'
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 16
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 5
    closeBtn.Parent = mainFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    local statusBox = Instance.new("Frame")
    statusBox.Size = UDim2.new(1, -24, 0, 32)
    statusBox.Position = UDim2.new(0, 12, 0, 62)
    statusBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    statusBox.BackgroundTransparency = 0.5
    statusBox.BorderSizePixel = 0
    statusBox.ZIndex = 4
    statusBox.Parent = mainFrame

    local statusBoxCorner = Instance.new("UICorner")
    statusBoxCorner.CornerRadius = UDim.new(0, 12)
    statusBoxCorner.Parent = statusBox

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(0, 14, 0.5, -4)
    statusDot.BackgroundColor3 = Color3.new(1, 0.313726, 0.392157)
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 6
    statusDot.Parent = statusBox

    local statusDotCorner = Instance.new("UICorner")
    statusDotCorner.CornerRadius = UDim.new(1, 0)
    statusDotCorner.Parent = statusDot

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 120, 1, 0)
    statusLabel.Position = UDim2.new(1, -124, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = 'INACTIVE'
    statusLabel.TextColor3 = Color3.new(1, 0.313726, 0.392157)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.ZIndex = 6
    statusLabel.Parent = statusBox

    local tpBox = Instance.new("Frame")
    tpBox.Size = UDim2.new(1, -24, 0, 50)
    tpBox.Position = UDim2.new(0, 12, 0, 102)
    tpBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    tpBox.BackgroundTransparency = 0.5
    tpBox.BorderSizePixel = 0
    tpBox.ZIndex = 4
    tpBox.Parent = mainFrame

    local tpBoxCorner = Instance.new("UICorner")
    tpBoxCorner.CornerRadius = UDim.new(0, 12)
    tpBoxCorner.Parent = tpBox

    local tpText = Instance.new("TextLabel")
    tpText.Size = UDim2.new(0, 90, 0, 18)
    tpText.Position = UDim2.new(0, 14, 0, 16)
    tpText.BackgroundTransparency = 1
    tpText.Text = 'TP Bat'
    tpText.TextColor3 = Color3.new(1, 1, 1)
    tpText.Font = Enum.Font.GothamBold
    tpText.TextSize = 14
    tpText.TextXAlignment = Enum.TextXAlignment.Left
    tpText.ZIndex = 6
    tpText.Parent = tpBox

    local keyLabel = Instance.new("TextButton")
    keyLabel.Size = UDim2.new(0, 34, 0, 20)
    keyLabel.Position = UDim2.new(1, -100, 0.5, -10)
    keyLabel.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    keyLabel.BackgroundTransparency = 0.3
    keyLabel.Text = settings.toggleKey.Name
    keyLabel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.TextSize = 12
    keyLabel.AutoButtonColor = false
    keyLabel.BorderSizePixel = 0
    keyLabel.ZIndex = 6
    keyLabel.Parent = tpBox

    local keyLabelCorner = Instance.new("UICorner")
    keyLabelCorner.CornerRadius = UDim.new(0, 6)
    keyLabelCorner.Parent = keyLabel

    local tpSwitch = Instance.new("TextButton")
    tpSwitch.Size = UDim2.new(0, 44, 0, 22)
    tpSwitch.Position = UDim2.new(1, -58, 0.5, -11)
    tpSwitch.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    tpSwitch.Text = ''
    tpSwitch.BorderSizePixel = 0
    tpSwitch.ZIndex = 6
    tpSwitch.Parent = tpBox

    local tpSwitchCorner = Instance.new("UICorner")
    tpSwitchCorner.CornerRadius = UDim.new(0, 11)
    tpSwitchCorner.Parent = tpSwitch

    local tpKnob = Instance.new("Frame")
    tpKnob.Size = UDim2.new(0, 16, 0, 16)
    tpKnob.Position = UDim2.new(0, 3, 0.5, -8)
    tpKnob.BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    tpKnob.BorderSizePixel = 0
    tpKnob.ZIndex = 7
    tpKnob.Parent = tpSwitch

    local tpKnobCorner = Instance.new("UICorner")
    tpKnobCorner.CornerRadius = UDim.new(1, 0)
    tpKnobCorner.Parent = tpKnob

    local antiBox = Instance.new("Frame")
    antiBox.Size = UDim2.new(1, -24, 0, 50)
    antiBox.Position = UDim2.new(0, 12, 0, 160)
    antiBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    antiBox.BackgroundTransparency = 0.5
    antiBox.BorderSizePixel = 0
    antiBox.ZIndex = 4
    antiBox.Parent = mainFrame

    local antiBoxCorner = Instance.new("UICorner")
    antiBoxCorner.CornerRadius = UDim.new(0, 12)
    antiBoxCorner.Parent = antiBox

    local antiText = Instance.new("TextLabel")
    antiText.Size = UDim2.new(0, 150, 0, 18)
    antiText.Position = UDim2.new(0, 14, 0, 16)
    antiText.BackgroundTransparency = 1
    antiText.Text = 'Anti Die'
    antiText.TextColor3 = Color3.new(1, 1, 1)
    antiText.Font = Enum.Font.GothamBold
    antiText.TextSize = 14
    antiText.TextXAlignment = Enum.TextXAlignment.Left
    antiText.ZIndex = 6
    antiText.Parent = antiBox

    local antiSwitch = Instance.new("TextButton")
    antiSwitch.Size = UDim2.new(0, 44, 0, 22)
    antiSwitch.Position = UDim2.new(1, -58, 0.5, -11)
    antiSwitch.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    antiSwitch.Text = ''
    antiSwitch.BorderSizePixel = 0
    antiSwitch.ZIndex = 6
    antiSwitch.Parent = antiBox

    local antiSwitchCorner = Instance.new("UICorner")
    antiSwitchCorner.CornerRadius = UDim.new(0, 11)
    antiSwitchCorner.Parent = antiSwitch

    local antiKnob = Instance.new("Frame")
    antiKnob.Size = UDim2.new(0, 16, 0, 16)
    antiKnob.Position = UDim2.new(0, 3, 0.5, -8)
    antiKnob.BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)
    antiKnob.BorderSizePixel = 0
    antiKnob.ZIndex = 7
    antiKnob.Parent = antiSwitch

    local antiKnobCorner = Instance.new("UICorner")
    antiKnobCorner.CornerRadius = UDim.new(1, 0)
    antiKnobCorner.Parent = antiKnob

    local versionBox = Instance.new("Frame")
    versionBox.Size = UDim2.new(1, -24, 0, 50)
    versionBox.Position = UDim2.new(0, 12, 0, 218)
    versionBox.BackgroundColor3 = Color3.new(0.0588235, 0.0588235, 0.0588235)
    versionBox.BackgroundTransparency = 0.5
    versionBox.BorderSizePixel = 0
    versionBox.ZIndex = 4
    versionBox.Parent = mainFrame

    local versionBoxCorner = Instance.new("UICorner")
    versionBoxCorner.CornerRadius = UDim.new(0, 12)
    versionBoxCorner.Parent = versionBox

    local versionText = Instance.new("TextLabel")
    versionText.Size = UDim2.new(0, 150, 0, 18)
    versionText.Position = UDim2.new(0, 14, 0, 16)
    versionText.BackgroundTransparency = 1
    versionText.Text = 'Version'
    versionText.TextColor3 = Color3.new(1, 1, 1)
    versionText.Font = Enum.Font.GothamBold
    versionText.TextSize = 14
    versionText.TextXAlignment = Enum.TextXAlignment.Left
    versionText.ZIndex = 6
    versionText.Parent = versionBox

    local v1Btn = Instance.new("TextButton")
    v1Btn.Size = UDim2.new(0, 44, 0, 22)
    v1Btn.Position = UDim2.new(1, -104, 0.5, -11)
    v1Btn.BackgroundColor3 = Color3.new(0.313726, 0.313726, 0.313726)
    v1Btn.Text = 'V1'
    v1Btn.TextColor3 = Color3.new(1, 1, 1)
    v1Btn.TextSize = 11
    v1Btn.Font = Enum.Font.GothamBold
    v1Btn.AutoButtonColor = false
    v1Btn.BorderSizePixel = 0
    v1Btn.ZIndex = 6
    v1Btn.Parent = versionBox

    local v1Corner = Instance.new("UICorner")
    v1Corner.CornerRadius = UDim.new(0, 6)
    v1Corner.Parent = v1Btn

    local v2Btn = Instance.new("TextButton")
    v2Btn.Size = UDim2.new(0, 44, 0, 22)
    v2Btn.Position = UDim2.new(1, -56, 0.5, -11)
    v2Btn.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
    v2Btn.Text = 'V2'
    v2Btn.TextColor3 = Color3.new(1, 1, 1)
    v2Btn.TextSize = 11
    v2Btn.Font = Enum.Font.GothamBold
    v2Btn.AutoButtonColor = false
    v2Btn.BorderSizePixel = 0
    v2Btn.ZIndex = 6
    v2Btn.Parent = versionBox

    local v2Corner = Instance.new("UICorner")
    v2Corner.CornerRadius = UDim.new(0, 6)
    v2Corner.Parent = v2Btn

    programState.uiReferences.Main = mainFrame
    programState.uiReferences.StatusLabel = statusLabel
    programState.uiReferences.StatusDot = statusDot
    programState.uiReferences.TpSwitch = tpSwitch
    programState.uiReferences.TpKnob = tpKnob
    programState.uiReferences.AntiSwitch = antiSwitch
    programState.uiReferences.AntiKnob = antiKnob
    programState.uiReferences.KeyLabel = keyLabel

    local isMinimized = false
    local originalSize = UDim2.new(0, 250, 0, 300)
    local miniSize = UDim2.new(0, 250, 0, 60)

    closeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = miniSize}):Play()
            closeBtn.Text = '+'
            statusBox.Visible = false
            tpBox.Visible = false
            antiBox.Visible = false
            versionBox.Visible = false
        else
            TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = originalSize}):Play()
            closeBtn.Text = '-'
            statusBox.Visible = true
            tpBox.Visible = true
            antiBox.Visible = true
            versionBox.Visible = true
        end
    end)

    keyLabel.MouseButton1Click:Connect(startKeybindListener)

    tpSwitch.MouseButton1Click:Connect(function()
        toggleTpBat()
        if programState.isTpBatActive then
            TweenService:Create(tpKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)}):Play()
            TweenService:Create(tpSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)}):Play()
        else
            TweenService:Create(tpKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)}):Play()
            TweenService:Create(tpSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)}):Play()
        end
    end)

    antiSwitch.MouseButton1Click:Connect(function()
        toggleAntiDie()
        if antiDieEnabled then
            TweenService:Create(antiKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)}):Play()
            TweenService:Create(antiSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)}):Play()
        else
            TweenService:Create(antiKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)}):Play()
            TweenService:Create(antiSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)}):Play()
        end
    end)

    v1Btn.MouseButton1Click:Connect(function()
        v1Btn.BackgroundColor3 = Color3.new(0.313726, 0.313726, 0.313726)
        v2Btn.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        settings.currentVersion = "V1"
    end)

    v2Btn.MouseButton1Click:Connect(function()
        v2Btn.BackgroundColor3 = Color3.new(0.313726, 0.313726, 0.313726)
        v1Btn.BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)
        settings.currentVersion = "V2"
    end)

    local dragging = false
    local dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return screenGui
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if programState.isWaitingForKey then return end
    if input.KeyCode == settings.toggleKey then
        toggleTpBat()
        if programState.uiReferences.TpSwitch and programState.uiReferences.TpKnob then
            if programState.isTpBatActive then
                TweenService:Create(programState.uiReferences.TpKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)}):Play()
                TweenService:Create(programState.uiReferences.TpSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)}):Play()
            else
                TweenService:Create(programState.uiReferences.TpKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)}):Play()
                TweenService:Create(programState.uiReferences.TpSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)}):Play()
            end
        end
    end
    if input.KeyCode == settings.antiDieKey then
        toggleAntiDie()
        if programState.uiReferences.AntiSwitch and programState.uiReferences.AntiKnob then
            if antiDieEnabled then
                TweenService:Create(programState.uiReferences.AntiKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = Color3.new(0.392157, 1, 0.470588)}):Play()
                TweenService:Create(programState.uiReferences.AntiSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.235294, 0.392157, 0.235294)}):Play()
            else
                TweenService:Create(programState.uiReferences.AntiKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = Color3.new(0.784314, 0.784314, 0.784314)}):Play()
                TweenService:Create(programState.uiReferences.AntiSwitch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.new(0.156863, 0.156863, 0.156863)}):Play()
            end
        end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    if programState.isTpBatActive then
        stopTpBat()
        task.wait(0.5)
        if programState.isAntiDieActive then
            startAntiDie()
        end
        startTpBat()
    end
end)

localPlayer.CharacterRemoving:Connect(function()
    stopTpBat()
    stopAntiDie()
end)

pcall(buildUI)