-- ============================================================
--                      WINTER.VS - AUTO STEAL + ANTI-LAG
--                 Full UI / Mini Pill (toggle with X)
--                 Pause at 75% until un‑ragdolled
-- ============================================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

-- ============================================================
--                      CONFIGURATION
-- ============================================================
local STEAL_RADIUS = 61
local STEAL_DURATION = 1.3
local UI_LOCKED = false
local UI_MODE = "full"   -- "full" or "mini"
local PAUSE_THRESHOLD = 0.75  -- pause at 75% (0.3s remaining)

-- ============================================================
--                      ANTI-LAG (AUTO-EXECUTE)
-- ============================================================
local antiLagConnections = {}
local State = { antiLagLoaded = false }

local function clearConnections()
    for _, conn in ipairs(antiLagConnections) do
        pcall(function() conn:Disconnect() end)
    end
    antiLagConnections = {}
end

local function applyAntiLagToDescendant(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
        pcall(function() obj.Enabled = false end)
    end
    if obj:IsA("Decal") or obj:IsA("Texture") then
        pcall(function() obj.Transparency = 1 end)
    end
    if obj:IsA("BasePart") then
        pcall(function()
            if obj:IsA("MeshPart") and obj.TextureID ~= "" then
                obj.TextureID = ""
            end
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        end)
    end
    if obj:IsA("Accessory") or obj:IsA("Hat") then
        pcall(function() obj:Destroy() end)
    end
    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        pcall(function() obj.Enabled = false end)
    end
    if obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
        pcall(function() obj.Enabled = false end)
    end
end

local function applyAllAntiLag()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
    end)
    for _, child in pairs(Lighting:GetChildren()) do
        if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or
           child:IsA("ColorCorrectionEffect") or child:IsA("DepthOfFieldEffect") then
            pcall(function() child.Enabled = false end)
        end
    end
    for _, descendant in pairs(Workspace:GetDescendants()) do
        applyAntiLagToDescendant(descendant)
    end
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    pcall(function()
        local UserSettings = UserSettings()
        local GameSettings = UserSettings:GetService("UserGameSettings")
        if GameSettings then
            GameSettings:SetFpsCap(1000)
        end
    end)
    pcall(function()
        HttpService:SetThrottlingEnabled(false)
        Workspace:SetAttribute("ReplicationPriority", 10)
    end)
end

local function loadAntiLag()
    if State.antiLagLoaded then return end
    clearConnections()
    applyAllAntiLag()

    local conn1 = Workspace.DescendantAdded:Connect(function(descendant)
        if State.antiLagLoaded then
            applyAntiLagToDescendant(descendant)
        end
    end)
    table.insert(antiLagConnections, conn1)

    local conn2 = Lighting.DescendantAdded:Connect(function(descendant)
        if State.antiLagLoaded then
            if descendant:IsA("BloomEffect") or descendant:IsA("BlurEffect") or
               descendant:IsA("SunRaysEffect") or descendant:IsA("ColorCorrectionEffect") then
                pcall(function() descendant.Enabled = false end)
            end
        end
    end)
    table.insert(antiLagConnections, conn2)

    local conn3 = Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if State.antiLagLoaded then
                for _, obj in ipairs(char:GetDescendants()) do
                    if obj:IsA("Accessory") or obj:IsA("Hat") then
                        pcall(function() obj:Destroy() end)
                    end
                end
            end
        end)
    end)
    table.insert(antiLagConnections, conn3)

    State.antiLagLoaded = true
    print("✅ Anti-Lag loaded!")
end

-- Auto-execute anti-lag
loadAntiLag()

-- ============================================================
--                      STEAL STATE
-- ============================================================
local Steal = {
    AutoStealEnabled = true,
    StealRadius = STEAL_RADIUS,
    StealDuration = STEAL_DURATION,
    Mode = "half",
    HalfFireRange = 10,
    HalfHoldMin = STEAL_DURATION,
    HalfHoldMax = 2.6,
    HalfEntryDelay = 0.3,
    Data = {}
}
local isStealing = false
local stealStartTime = nil
local autoConn = nil
local progressFill = nil
local statusLabel = nil
local pill = nil
local topRow = nil
local bottomRow = nil
local barBg = nil
local hideBtn = nil
local lockBtn = nil

-- Pause state
local isPaused = false
local pausedProgress = 0

-- ============================================================
--                      RAGDOLL DETECTION
-- ============================================================
local function isRagdolled()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local platformStand = char:FindFirstChild("PlatformStand")
    if platformStand then return true end
    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll then
        return true
    end
    return false
end

-- ============================================================
--                      STEAL FUNCTIONS
-- ============================================================
local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= Steal.StealRadius and d < dist then
                            local found = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then
                                        found = pr
                                    end
                                end
                            end
                            if not found then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then
                                        found = pr
                                    end
                                end
                            end
                            if found then nearest, dist = found, d end
                        end
                    end
                end
            end
        end
    end
    return nearest
end

local function _promptDist(prompt)
    local char = LP.Character
    if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    if part and part:IsA("BasePart") then return (part.Position - root.Position).Magnitude end
    local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf - root.Position).Magnitude end
    return math.huge
end

local function executeSteal(prompt)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
            end
        end
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    isPaused = false
    stealStartTime = tick()
    
    if Steal.Mode == "half" then
        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            task.wait(Steal.HalfHoldMin)
            local inRange = _promptDist(prompt) <= Steal.HalfFireRange
            while true do
                local el = tick() - stealStartTime
                if el > Steal.HalfHoldMax or not prompt.Parent then break end
                
                local progress = el / Steal.StealDuration
                if progress >= PAUSE_THRESHOLD and isRagdolled() then
                    isPaused = true
                    pausedProgress = PAUSE_THRESHOLD
                    while isRagdolled() and prompt.Parent do
                        task.wait(0.05)
                    end
                    isPaused = false
                    stealStartTime = tick() - (PAUSE_THRESHOLD * Steal.StealDuration)
                end
                
                if _promptDist(prompt) <= Steal.HalfFireRange then
                    if not inRange then task.wait(Steal.HalfEntryDelay) end
                    local currentProgress = (tick() - stealStartTime) / Steal.StealDuration
                    if currentProgress >= PAUSE_THRESHOLD then
                        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                        break
                    end
                end
                task.wait()
            end
            task.wait(0.05)
            data.ready = true
            isStealing = false
            isPaused = false
        end)
    else
        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local el = 0
            while el < Steal.StealDuration do
                el = el + task.wait()
                if el / Steal.StealDuration >= PAUSE_THRESHOLD and isRagdolled() then
                    isPaused = true
                    while isRagdolled() do task.wait(0.05) end
                    isPaused = false
                end
            end
            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            task.wait(0.05)
            data.ready = true
            isStealing = false
            isPaused = false
        end)
    end
end

local function startAutoSteal()
    if autoConn then return end
    autoConn = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p = findNearestPrompt()
        if p then executeSteal(p) end
    end)
end

local function stopAutoSteal()
    if autoConn then autoConn:Disconnect() autoConn = nil end
    isStealing = false
    isPaused = false
end

-- ============================================================
--                      UI CONSTRUCTION
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "WinterStealGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 200
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP.PlayerGui

pill = Instance.new("Frame", gui)
pill.Size = UDim2.new(0, 280, 0, 100)
pill.Position = UDim2.new(0.5, -140, 0.5, -50)
pill.BackgroundColor3 = Color3.fromRGB(10, 25, 50)
pill.BackgroundTransparency = 0.1
pill.BorderSizePixel = 0
pill.Active = true
pill.ClipsDescendants = true
local corner = Instance.new("UICorner", pill)
corner.CornerRadius = UDim.new(1, 0)
local border = Instance.new("UIStroke", pill)
border.Color = Color3.fromRGB(100, 180, 255)
border.Thickness = 2
border.Transparency = 0.2

-- ===== TOP ROW =====
topRow = Instance.new("Frame", pill)
topRow.Size = UDim2.new(1, -10, 0, 24)
topRow.Position = UDim2.new(0, 5, 0, 4)
topRow.BackgroundTransparency = 1

local nameLabel = Instance.new("TextLabel", topRow)
nameLabel.Size = UDim2.new(0.35, 0, 1, 0)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "❄ winter.vs"
nameLabel.TextColor3 = Color3.fromRGB(200, 230, 255)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

local fpsLabel = Instance.new("TextLabel", topRow)
fpsLabel.Size = UDim2.new(0.22, 0, 1, 0)
fpsLabel.Position = UDim2.new(0.35, 0, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(180, 215, 255)
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 11
fpsLabel.TextXAlignment = Enum.TextXAlignment.Center

local pingLabel = Instance.new("TextLabel", topRow)
pingLabel.Size = UDim2.new(0.22, 0, 1, 0)
pingLabel.Position = UDim2.new(0.57, 0, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: N/A"
pingLabel.TextColor3 = Color3.fromRGB(180, 215, 255)
pingLabel.Font = Enum.Font.Gotham
pingLabel.TextSize = 11
pingLabel.TextXAlignment = Enum.TextXAlignment.Center

lockBtn = Instance.new("TextButton", topRow)
lockBtn.Size = UDim2.new(0, 20, 1, 0)
lockBtn.Position = UDim2.new(0.82, 0, 0, 0)
lockBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 255)
lockBtn.BackgroundTransparency = 0.3
lockBtn.Text = "🔓"
lockBtn.TextSize = 12
lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockBtn.Font = Enum.Font.GothamBold
lockBtn.BorderSizePixel = 0
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(1, 0)
lockBtn.AutoButtonColor = false

hideBtn = Instance.new("TextButton", topRow)
hideBtn.Size = UDim2.new(0, 20, 1, 0)
hideBtn.Position = UDim2.new(1, -22, 0, 0)
hideBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
hideBtn.BackgroundTransparency = 0.3
hideBtn.Text = "−"
hideBtn.TextSize = 14
hideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hideBtn.Font = Enum.Font.GothamBold
hideBtn.BorderSizePixel = 0
Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(1, 0)
hideBtn.AutoButtonColor = false

-- ===== PROGRESS BAR =====
barBg = Instance.new("Frame", pill)
barBg.Size = UDim2.new(0.9, 0, 0, 22)
barBg.Position = UDim2.new(0.05, 0, 0, 34)
barBg.BackgroundColor3 = Color3.fromRGB(15, 35, 70)
barBg.BorderSizePixel = 0
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

progressFill = Instance.new("Frame", barBg)
progressFill.Size = UDim2.new(0, 0, 1, -4)
progressFill.Position = UDim2.new(0, 2, 0, 2)
progressFill.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
progressFill.BackgroundTransparency = 0.15
progressFill.BorderSizePixel = 0
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

statusLabel = Instance.new("TextLabel", barBg)
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "0%"
statusLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
statusLabel.Font = Enum.Font.GothamBlack
statusLabel.TextSize = 14
statusLabel.TextStrokeTransparency = 0.15
statusLabel.TextStrokeColor3 = Color3.fromRGB(10, 30, 60)
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.TextYAlignment = Enum.TextYAlignment.Center

-- ===== BOTTOM ROW =====
bottomRow = Instance.new("Frame", pill)
bottomRow.Size = UDim2.new(0.9, 0, 0, 22)
bottomRow.Position = UDim2.new(0.05, 0, 0, 62)
bottomRow.BackgroundTransparency = 1

local durLabel = Instance.new("TextLabel", bottomRow)
durLabel.Size = UDim2.new(0.08, 0, 1, 0)
durLabel.BackgroundTransparency = 1
durLabel.Text = "D:"
durLabel.TextColor3 = Color3.fromRGB(180, 215, 255)
durLabel.Font = Enum.Font.GothamBold
durLabel.TextSize = 11
durLabel.TextXAlignment = Enum.TextXAlignment.Left

local durBox = Instance.new("TextBox", bottomRow)
durBox.Size = UDim2.new(0.15, 0, 1, 0)
durBox.Position = UDim2.new(0.1, 0, 0, 0)
durBox.BackgroundColor3 = Color3.fromRGB(15, 35, 70)
durBox.TextColor3 = Color3.fromRGB(220, 240, 255)
durBox.Font = Enum.Font.Gotham
durBox.TextSize = 11
durBox.Text = string.format("%.1f", STEAL_DURATION)
durBox.TextXAlignment = Enum.TextXAlignment.Center
durBox.BorderSizePixel = 0
Instance.new("UICorner", durBox).CornerRadius = UDim.new(0, 4)
local durStroke = Instance.new("UIStroke", durBox)
durStroke.Color = Color3.fromRGB(100, 180, 255)
durStroke.Thickness = 1

local radLabel = Instance.new("TextLabel", bottomRow)
radLabel.Size = UDim2.new(0.08, 0, 1, 0)
radLabel.Position = UDim2.new(0.32, 0, 0, 0)
radLabel.BackgroundTransparency = 1
radLabel.Text = "R:"
radLabel.TextColor3 = Color3.fromRGB(180, 215, 255)
radLabel.Font = Enum.Font.GothamBold
radLabel.TextSize = 11
radLabel.TextXAlignment = Enum.TextXAlignment.Left

local radBox = Instance.new("TextBox", bottomRow)
radBox.Size = UDim2.new(0.15, 0, 1, 0)
radBox.Position = UDim2.new(0.4, 0, 0, 0)
radBox.BackgroundColor3 = Color3.fromRGB(15, 35, 70)
radBox.TextColor3 = Color3.fromRGB(220, 240, 255)
radBox.Font = Enum.Font.Gotham
radBox.TextSize = 11
radBox.Text = tostring(STEAL_RADIUS)
radBox.TextXAlignment = Enum.TextXAlignment.Center
radBox.BorderSizePixel = 0
Instance.new("UICorner", radBox).CornerRadius = UDim.new(0, 4)
local radStroke = Instance.new("UIStroke", radBox)
radStroke.Color = Color3.fromRGB(100, 180, 255)
radStroke.Thickness = 1

-- ============================================================
--                      UI MODE SWITCH (full / mini)
-- ============================================================
local function setUIMode(mode)
    UI_MODE = mode
    if mode == "full" then
        pill.Size = UDim2.new(0, 280, 0, 100)
        pill.Position = UDim2.new(0.5, -140, 0.5, -50)
        topRow.Visible = true
        bottomRow.Visible = true
        barBg.Size = UDim2.new(0.9, 0, 0, 22)
        barBg.Position = UDim2.new(0.05, 0, 0, 34)
        barBg.BackgroundTransparency = 0
        statusLabel.TextSize = 14
        hideBtn.Text = "−"
    else -- mini
        pill.Size = UDim2.new(0, 180, 0, 22)
        pill.Position = UDim2.new(0.5, -90, 1, -30)
        topRow.Visible = false
        bottomRow.Visible = false
        barBg.Size = UDim2.new(1, -4, 1, -2)
        barBg.Position = UDim2.new(0, 2, 0, 1)
        barBg.BackgroundTransparency = 0
        statusLabel.TextSize = 12
        hideBtn.Text = "+"
    end
end

setUIMode("full")

local function toggleUIMode()
    if UI_MODE == "full" then
        setUIMode("mini")
    else
        setUIMode("full")
    end
end

hideBtn.MouseButton1Click:Connect(toggleUIMode)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        toggleUIMode()
    end
end)

-- ============================================================
--                      LOCK BUTTON LOGIC
-- ============================================================
local function updateLock()
    if UI_LOCKED then
        lockBtn.Text = "🔒"
        lockBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    else
        lockBtn.Text = "🔓"
        lockBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 255)
    end
end
updateLock()

lockBtn.MouseButton1Click:Connect(function()
    UI_LOCKED = not UI_LOCKED
    updateLock()
end)

-- ============================================================
--                      DRAG SYSTEM
-- ============================================================
local dragging, dragStart, startPos = false, nil, nil
pill.InputBegan:Connect(function(input)
    if UI_LOCKED or UI_MODE == "mini" then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = pill.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1000, 1000)
        local sz = pill.AbsoluteSize
        local newXScalePx = startPos.X.Scale * vp.X
        local newX = math.clamp(newXScalePx + startPos.X.Offset + delta.X, 0, vp.X - sz.X)
        local newY = math.clamp(startPos.Y.Scale * vp.Y + startPos.Y.Offset + delta.Y, 0, vp.Y - sz.Y)
        pill.Position = UDim2.new(startPos.X.Scale, newX - newXScalePx, startPos.Y.Scale, newY - startPos.Y.Scale * vp.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ============================================================
--                      INPUT VALIDATION
-- ============================================================
local function clampDuration(val)
    local num = tonumber(val)
    if not num then return STEAL_DURATION end
    num = math.max(num, 1.3)
    return num
end

durBox.FocusLost:Connect(function()
    local newDur = clampDuration(durBox.Text)
    STEAL_DURATION = newDur
    Steal.StealDuration = newDur
    Steal.HalfHoldMin = newDur
    durBox.Text = string.format("%.1f", newDur)
    print("✅ Duration set to: " .. newDur)
end)

durBox:GetPropertyChangedSignal("Text"):Connect(function()
    local raw = durBox.Text
    local cleaned = raw:gsub("[^%d.]", "")
    if cleaned ~= raw then durBox.Text = cleaned end
end)

radBox.FocusLost:Connect(function()
    local num = tonumber(radBox.Text)
    if num and num > 0 then
        STEAL_RADIUS = math.floor(num)
        Steal.StealRadius = STEAL_RADIUS
        radBox.Text = tostring(STEAL_RADIUS)
        print("✅ Radius set to: " .. STEAL_RADIUS)
    else
        radBox.Text = tostring(STEAL_RADIUS)
    end
end)

radBox:GetPropertyChangedSignal("Text"):Connect(function()
    local raw = radBox.Text
    local cleaned = raw:gsub("[^%d]", "")
    if cleaned ~= raw then radBox.Text = cleaned end
end)

-- ============================================================
--                      FPS & PING UPDATERS
-- ============================================================
local frameCount = 0
local lastTick = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTick >= 0.5 then
        local fps = math.round(frameCount / (now - lastTick))
        fpsLabel.Text = "FPS: " .. tostring(fps)
        frameCount = 0
        lastTick = now
    end
end)

task.spawn(function()
    local stats = Stats
    local network = stats:FindFirstChild("Network")
    while gui and gui.Parent do
        local ping = "N/A"
        if network and network:FindFirstChild("ServerStatsItem") then
            local dataPing = network.ServerStatsItem:FindFirstChild("Data Ping")
            if dataPing then
                ping = tostring(math.floor(dataPing:GetValue()))
            end
        else
            local p = LP:GetNetworkPing()
            if p and p > 0 then ping = tostring(math.round(p * 1000)) end
        end
        pingLabel.Text = "Ping: " .. ping .. "ms"
        task.wait(2)
    end
end)

-- ============================================================
--                      PROGRESS BAR UPDATER (PERCENTAGE)
-- ============================================================
local lastPct = 0
RunService.RenderStepped:Connect(function()
    if not pill.Visible then return end
    local pct = 0
    if isStealing and stealStartTime then
        local dur = Steal.StealDuration
        pct = math.clamp((tick() - stealStartTime) / math.max(dur, 0.01), 0, 1)
        if isPaused then
            pct = math.min(pct, PAUSE_THRESHOLD)
        end
    elseif Steal.AutoStealEnabled then
        pct = (findNearestPrompt() and 1 or 0)
    end
    lastPct = lastPct + (pct - lastPct) * 0.2
    local f = math.clamp(lastPct, 0, 1)
    progressFill.Size = UDim2.new(f, -4 * f, 1, -4)
    
    local percent = math.floor(f * 100)
    statusLabel.Text = percent .. "%"
    
    if f >= 0.75 then
        statusLabel.TextColor3 = Color3.fromRGB(70, 235, 110)
    elseif f >= 0.5 then
        statusLabel.TextColor3 = Color3.fromRGB(255, 225, 60)
    else
        statusLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    end
end)

-- ============================================================
--                      START AUTO STEAL
-- ============================================================
Steal.AutoStealEnabled = true
pcall(startAutoSteal)

print("✅ Winter.vs Auto Steal + Anti-Lag loaded!")
print("❄️ Pause at 75% – resumes when un‑ragdolled!")

_G.__Cleanup = function()
    if autoConn then autoConn:Disconnect() end
    clearConnections()
    _G.__Cleanup = nil
end