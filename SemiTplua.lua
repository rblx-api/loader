_G.leakedbySticky_Executed = true

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat task.wait() until Players.LocalPlayer
    LocalPlayer = Players.LocalPlayer
end
local player = LocalPlayer

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local safeGuiTarget = nil
local successCore, _ = pcall(function()
    local test = Instance.new("Folder")
    test.Parent = CoreGui
    test:Destroy()
end)
safeGuiTarget = successCore and CoreGui or (player:WaitForChild("PlayerGui", 5) or player.PlayerGui)

local function getGuiParent()
    if gethui then return gethui() end
    return safeGuiTarget
end

pcall(function()
    for _, name in ipairs({"leakedbySticky_Remake", "leakedbySticky_ProgressBar", "leakedbySticky_Speed_Only", "leakedbyStickyAPSpamGui", "AllowDisallow"}) do
        if getGuiParent():FindFirstChild(name) then
            getGuiParent()[name]:Destroy()
        end
    end
end)

local MAIN_FONT = Enum.Font.FredokaOne
local COLOR_BG_DARK = Color3.fromRGB(0, 0, 0)
local COLOR_CARD_BG = Color3.fromRGB(10, 0, 0)
local COLOR_BORDER = Color3.fromRGB(255, 0, 0)
local COLOR_ACCENT = Color3.fromRGB(255, 0, 0)
local COLOR_TEXT_LIGHT = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_DARK = Color3.fromRGB(150, 0, 0)

local HEX_TEXT_PATTERN = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})

local function applyTextGradient(textObject)
    if not textObject then return end
    local stroke = textObject:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Transparency = 0.2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.Parent = textObject

    local grad = textObject:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    grad.Color = HEX_TEXT_PATTERN
    grad.Rotation = 45
    grad.Parent = textObject

    RunService.RenderStepped:Connect(function(deltaTime)
        if grad and grad.Parent then
            grad.Rotation = (grad.Rotation + 35 * deltaTime) % 360
        end
    end)
    return grad
end

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function addHoverAnimation(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = normalColor}):Play()
    end)
end

local configFile = "leakedbyStickyHUB_FlashTP_Config.json"
local HubConfig = {
    speedBoostEnabled = false,
    speedValue = 25,
    hexSpeedVisible = false,
    speedPos = {ScaleX = 0.98, OffsetX = 0, ScaleY = 0.02, OffsetY = 0},
    stealKeybind = "E",
    potionEnabled = true,
    autoWalkEnabled = false,
    apOnStealEnabled = false,
    autoTPOnAllowEnabled = false,
    autoActivateEnabled = false,
    kickAfterStealEnabled = false,
    selectedSlot = 1,
    selectedGear = "Auto"
}

if isfile and isfile(configFile) then
    local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(configFile)) end)
    if success and decoded then
        for k, v in pairs(decoded) do
            if k ~= "selectedSlot" then HubConfig[k] = v end
        end
    end
end
HubConfig.selectedSlot = 1

local function saveHubConfig()
    if writefile then pcall(function() writefile(configFile, HttpService:JSONEncode(HubConfig)) end) end
end

_G.speedBoostEnabled = HubConfig.speedBoostEnabled
local currentSpeed = HubConfig.speedValue or 25
local currentStealKey = Enum.KeyCode[HubConfig.stealKeybind or "E"]
local PotionEnabled = HubConfig.potionEnabled
local AutoWalkEnabled = HubConfig.autoWalkEnabled
local APOnStealEnabled = HubConfig.apOnStealEnabled
local AutoTPOnAllowEnabled = HubConfig.autoTPOnAllowEnabled or false
local AutoActivateEnabled = HubConfig.autoActivateEnabled or false
local KickAfterStealEnabled = HubConfig.kickAfterStealEnabled or false
local selectedSlot = 1

local ALL_CMDS = {"rocket", "tiny", "jumpscare", "morph", "inverse"}
local selectedCmds = {}
for _, cmd in ipairs(ALL_CMDS) do selectedCmds[cmd] = true end

local function getAdminPanelButtons()
    local ap = LocalPlayer.PlayerGui:FindFirstChild("AdminPanel")
    if not ap then return nil, nil end
    local inner = ap:FindFirstChild("AdminPanel")
    if not inner then return nil, nil end
    local content, profiles = inner:FindFirstChild("Content"), inner:FindFirstChild("Profiles")
    if not content or not profiles then return nil, nil end
    return content:FindFirstChild("ScrollingFrame"), profiles:FindFirstChild("ScrollingFrame")
end

local fireCmd = function(targetPlayer, cmd)
    local csf, psf = getAdminPanelButtons()
    if not csf or not psf then return end
    local pb, cb = psf:FindFirstChild(targetPlayer.Name), csf:FindFirstChild(cmd)
    if not pb or not cb then return end

    if firesignal then
        firesignal(cb.Activated)
        firesignal(pb.Activated)
    elseif getconnections then
        for _, c in ipairs(getconnections(cb.Activated)) do if c.Function then task.spawn(c.Function) end end
        for _, c in ipairs(getconnections(pb.Activated)) do if c.Function then task.spawn(c.Function) end end
    end
end

local lastSpam, COOLDOWN = 0, 0.15
local doSpam = function()
    if tick() - lastSpam < COOLDOWN then return end
    lastSpam = tick()
    local toFire = {}
    for _, cmd in ipairs(ALL_CMDS) do if selectedCmds[cmd] then table.insert(toFire, cmd) end end
    if #toFire == 0 then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            for _, cmd in ipairs(toFire) do fireCmd(p, cmd) end
        end
    end
end

local activeSpeedConnections = {}
local function clearSpeedConnections()
    for _, conn in ipairs(activeSpeedConnections) do if conn then conn:Disconnect() end end
    activeSpeedConnections = {}
end

local function initSpeedFeatures(char)
    clearSpeedConnections()
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not (hum and hrp) then return end

    local wasSpeedEnabled = false
    local speedConn = RunService.Heartbeat:Connect(function()
        if not char or not char.Parent or not hum or not hrp then return end
        if _G.speedBoostEnabled then
            wasSpeedEnabled = true
            hum.UseJumpPower = true
            hum.JumpPower = 40
            if hum.MoveDirection.Magnitude > 0 then
                local flat = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z).Unit
                hrp.Velocity = Vector3.new(flat.X * currentSpeed, hrp.Velocity.Y, flat.Z * currentSpeed)
            end
        elseif wasSpeedEnabled then
            wasSpeedEnabled = false
            hum.JumpPower = 50
        end
    end)
    table.insert(activeSpeedConnections, speedConn)
end

if player.Character then task.spawn(initSpeedFeatures, player.Character) end
player.CharacterAdded:Connect(function(char) task.wait(0.2); initSpeedFeatures(char) end)

local STEAL_DURATION = 1.3
local progressFill, percentLabel = nil, nil

local function updateProgressBar(p)
    if progressFill then
        TweenService:Create(progressFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0)
        }):Play()
    end
    if percentLabel then percentLabel.Text = math.floor(math.clamp(p, 0, 1) * 100) .. "%" end
end

local function detectStealAndWait()
    local startTime = tick()
    while player:GetAttribute("Stealing") == nil do
        if tick() - startTime >= 3 then break end
        task.wait(0.1)
    end
    if player:GetAttribute("Stealing") ~= nil then task.wait(0.5) end
end

local function findMyBase()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, base in pairs(plots:GetChildren()) do
        if base:IsA("Model") then
            for _, d in pairs(base:GetDescendants()) do
                if d:IsA("TextLabel") and (string.find(d.Text, player.Name) or string.find(d.Text, player.DisplayName)) then
                    return base
                end
            end
        end
    end
    return nil
end

local function isEnemyPlot(plot)
    if not plot or not plot:IsA("Model") then return false end
    local sign = plot:FindFirstChild("PlotSign")
    local sg = sign and sign:FindFirstChild("SurfaceGui")
    local frame = sg and sg:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return false end
    local owner = label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    return owner ~= player.Name and owner ~= player.DisplayName
end

local darkBlueHighlight = Instance.new("Highlight")
darkBlueHighlight.Name = "leakedbySticky_DarkBlue_Podium_Highlight"
darkBlueHighlight.FillColor = Color3.fromRGB(90, 0, 0)
darkBlueHighlight.OutlineColor = Color3.fromRGB(255, 0, 0)
darkBlueHighlight.FillTransparency = 0.35
darkBlueHighlight.OutlineTransparency = 0

local function getTargetPodiumForSlot(slot)
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    local slotMap = {
        [1] = {"1", "10"},
        [2] = {"2", "9"},
        [3] = {"3", "8"},
        [4] = {"4", "7"},
        [5] = {"5", "6"}
    }
    local searchSlots = slotMap[slot] or {"1", "10"}
    local bestPodium = nil
    local minDist = math.huge

    for _, plot in ipairs(plots:GetChildren()) do
        local isEnemy = false
        if slot == 1 then
            local myName = player.DisplayName
            local sign = plot:FindFirstChild("PlotSign")
            local label = sign and sign:FindFirstChild("SurfaceGui")
                and sign.SurfaceGui:FindFirstChild("Frame")
                and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
            if label and label.Text ~= "Empty Base" then
                local owner = label.Text:gsub("'s Base$",""):gsub("'s base$",""):gsub("%s+$","")
                if owner ~= myName and owner ~= player.Name then isEnemy = true end
            end
        else
            isEnemy = isEnemyPlot(plot)
        end

        if isEnemy then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, pname in ipairs(searchSlots) do
                    local podium = podiums:FindFirstChild(pname)
                    if podium then
                        local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main")
                        if cm then
                            local dist = hrp and (hrp.Position - cm.Position).Magnitude or 0
                            if dist < minDist then
                                minDist = dist
                                bestPodium = podium
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPodium
end

task.spawn(function()
    while task.wait(0.25) do
        local targetPodium = getTargetPodiumForSlot(selectedSlot)
        if targetPodium then
            if darkBlueHighlight.Adornee ~= targetPodium or darkBlueHighlight.Parent ~= targetPodium then
                darkBlueHighlight.Adornee = targetPodium
                darkBlueHighlight.Parent = targetPodium
            end
        else
            darkBlueHighlight.Adornee = nil
            darkBlueHighlight.Parent = nil
        end
    end
end)

local function getNearestDeliveryHitbox()
    local myBase = findMyBase()
    if not myBase then return nil end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local refPos = hrp and hrp.Position or myBase:GetPivot().Position

    local nearestPos = nil
    local minDist = math.huge
    for _, d in pairs(myBase:GetDescendants()) do
        if d.Name == "DeliveryHitbox" then
            local pos = d:IsA("BasePart") and d.Position or (d:IsA("Model") and d:GetPivot().Position)
            if pos then
                local dist = (pos - refPos).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPos = pos
                end
            end
        end
    end

    if not nearestPos then
        for _, d in pairs(Workspace:GetDescendants()) do
            if d.Name == "DeliveryHitbox" then
                local pos = d:IsA("BasePart") and d.Position or (d:IsA("Model") and d:GetPivot().Position)
                if pos then
                    local dist = (pos - refPos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestPos = pos
                    end
                end
            end
        end
    end

    return nearestPos
end

local function isInsideHitbox(part, pos)
    if not part or not pos then return false end
    local rel = part.CFrame:PointToObjectSpace(pos)
    local s = part.Size
    return math.abs(rel.X) <= s.X/2
        and math.abs(rel.Y) <= s.Y/2
        and math.abs(rel.Z) <= s.Z/2
end

RunService.Heartbeat:Connect(function()
    if not KickAfterStealEnabled then return end
    if not player:GetAttribute("Stealing") then return end

    local myPlot = findMyBase()
    local hitbox = myPlot and myPlot:FindFirstChild("DeliveryHitbox", true)
    if not hitbox then return end

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and isInsideHitbox(hitbox, hrp.Position) then
        task.wait(0.2)
        LocalPlayer:Destroy()
    end
end)

local FFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000, LargeReplicatorWrite5 = true,
    LargeReplicatorEnabled9 = true, AngularVelociryLimit = 360,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646, S2PhysicsSenderRate = 15000,
    DisableDPIScale = true, MaxDataPacketPerSend = 2147483647, PhysicsSenderMaxBandwidthBps = 20000,
    TimestepArbiterHumanoidLinearVelThreshold = 21, MaxMissedWorldStepsRemembered = -2147483648,
    PlayerHumanoidPropertyUpdateRestrict = true, SimDefaultHumanoidTimestepMultiplier = 0,
    StreamJobNOUVolumeLengthCap = 2147483647, DebugSendDistInSteps = -2147483648,
    GameNetDontSendRedundantNumTimes = 1, CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
    LargeReplicatorSerializeRead3 = true, ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
    CheckPVCachedVelThresholdPercent = 10, CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
    GameNetDontSendRedundantDeltaPositionMillionth = 1, InterpolationFrameVelocityThresholdMillionth = 5,
    StreamJobNOUVolumeCap = 2147483647, InterpolationFrameRotVelocityThresholdMillionth = 5,
    CheckPVCachedRotVelThresholdPercent = 10, WorldStepMax = 30,
    InterpolationFramePositionThresholdMillionth = 5, TimestepArbiterHumanoidTurningVelThreshold = 1,
    SimOwnedNOUCountThresholdMillionth = 2147483647, GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    NextGenReplicatorEnabledWrite4 = true, TimestepArbiterOmegaThou = 1073741823, MaxAcceptableUpdateDelay = 1,
    LargeReplicatorSerializeWrite4 = true
}

local setFFlags = function()
    if type(setfflag) ~= "function" then return end
    for name, value in pairs(FFlags) do pcall(function() setfflag(tostring(name), tostring(value)) end) end
end

local ALLOWED_GEARS = {"FlyingCarpet", "Witch'sBroom", "Cupid'sWings", "Santa'sSleigh", "Waverider"}
local MOUNT_PRIORITY = {"Flying Carpet", "FlyingCarpet", "Witch's Broom", "Witch'sBroom", "WitchBroom", "Cupid's Wings", "Cupid'sWings", "CupidWings", "Santa's Sleigh", "Santa'sSleigh", "SantaSleigh", "Waverider"}

local function isAllowedGear(gearName)
    local cleanName = gearName:lower():gsub("[%s'%_%-]", "")
    for _, allowed in ipairs(ALLOWED_GEARS) do
        if cleanName == allowed:lower():gsub("[%s'%_%-]", "") then return true end
    end
    return false
end

local function getPriorityIndex(gearName)
    local cleanName = gearName:lower():gsub("[%s'%_%-]", "")
    for index, priorityName in ipairs(MOUNT_PRIORITY) do
        if cleanName == priorityName:lower():gsub("[%s'%_%-]", "") then return index end
    end
    return 9999
end

local function getInventoryGears()
    local gears, added = {}, {}
    local function scan(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and isAllowedGear(item.Name) and not added[item.Name] then
                added[item.Name] = true
                table.insert(gears, item.Name)
            end
        end
    end
    scan(LocalPlayer:FindFirstChild("Backpack"))
    scan(LocalPlayer.Character)
    table.sort(gears, function(a, b)
        local pA, pB = getPriorityIndex(a), getPriorityIndex(b)
        return pA ~= pB and pA < pB or a < b
    end)
    return gears
end

local function getDefaultGearFromInventory()
    local inventory = getInventoryGears()
    return #inventory > 0 and inventory[1] or "Sin Gear"
end

local function findToolFlexible(container, toolName)
    if not container or not toolName then return nil end
    local exact = container:FindFirstChild(toolName)
    if exact and exact:IsA("Tool") then return exact end
    local cleanTarget = toolName:lower():gsub("[%s'%_%-]", "")
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("Tool") and child.Name:lower():gsub("[%s'%_%-]", "") == cleanTarget then return child end
    end
    return nil
end

local function EquipTargetTool(toolName)
    local character = LocalPlayer.Character
    if not character or not toolName then return nil end
    local equipped = findToolFlexible(character, toolName)
    if equipped then return equipped end
    local toolInBackpack = findToolFlexible(LocalPlayer:FindFirstChild("Backpack"), toolName)
    if toolInBackpack then
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then hum:EquipTool(toolInBackpack) end
        return toolInBackpack
    end
    return nil
end

local function EquipBestMount()
    local chosenGear = HubConfig.selectedGear
    if not chosenGear or chosenGear == "Auto" or chosenGear == "" then
        chosenGear = getDefaultGearFromInventory()
    end
    if chosenGear and chosenGear ~= "Sin Gear" and chosenGear ~= "Auto" then
        local equipped = EquipTargetTool(chosenGear)
        if equipped then return equipped end
    end
    for _, mountName in ipairs(MOUNT_PRIORITY) do
        local equipped = EquipTargetTool(mountName)
        if equipped then return equipped end
    end
    return nil
end

local function SSEquipGrapple() EquipBestMount() end

local walkTo = function(hrp, targetCords, desiredSpeed, precisionThreshold, noGear)
    if not hrp or not hrp.Parent or not targetCords then return end
    desiredSpeed = desiredSpeed