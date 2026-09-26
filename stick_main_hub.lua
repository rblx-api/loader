_G.StickSemiTP_Executed = true

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat task.wait() until Players.LocalPlayer
    LocalPlayer = Players.LocalPlayer
end
local player = LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ==========================================
-- GRADIENTES ANIMADOS
-- ==========================================
local animatedGradients = setmetatable({}, { __mode = "k" })
task.spawn(function()
    while task.wait(0.05) do
        for grad, speed in pairs(animatedGradients) do
            if grad and grad.Parent then
                grad.Rotation = (grad.Rotation + speed * 0.05) % 360
            else
                animatedGradients[grad] = nil
            end
        end
    end
end)

-- ==========================================
-- CONFIG
-- ==========================================
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local safeGuiTarget = nil
pcall(function()
    local test = Instance.new("Folder")
    test.Parent = CoreGui
    test:Destroy()
    safeGuiTarget = CoreGui
end)
if not safeGuiTarget then
    safeGuiTarget = player:WaitForChild("PlayerGui", 5) or player.PlayerGui
end

local function getGuiParent()
    if gethui then return gethui() end
    return safeGuiTarget
end

pcall(function()
    for _, name in ipairs({"StickSemiTP_Main", "StickAPSpamGui", "AllowDisallow", "Stick_HelperV1"}) do
        local g = getGuiParent()
        if g:FindFirstChild(name) then g[name]:Destroy() end
    end
end)

local MAIN_FONT = Enum.Font.FredokaOne
local COLOR_BG_DARK = Color3.fromRGB(12, 8, 10)
local COLOR_CARD_BG = Color3.fromRGB(22, 12, 14)
local COLOR_BORDER = Color3.fromRGB(80, 20, 25)
local COLOR_ACCENT = Color3.fromRGB(255, 25, 45)
local COLOR_TEXT_LIGHT = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_DARK = Color3.fromRGB(180, 120, 130)

local HEX_TEXT_PATTERN = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 80, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 40))
})

local function applyTextGradient(textObject)
    if not textObject then return end
    local stroke = textObject:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
    stroke.Thickness = 2.2
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    stroke.Parent = textObject
    local grad = textObject:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient")
    grad.Color = HEX_TEXT_PATTERN
    grad.Rotation = 45
    grad.Parent = textObject
    animatedGradients[grad] = 35
    return grad
end

local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function addHoverAnimation(btn, normalColor, hoverColor)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
    end)
end

local configFile = "StickSemiTP_Config.json"
local HubConfig = {
    stealKeybind = "E",
    potionEnabled = true,
    autoWalkEnabled = false,
    apOnStealEnabled = false,
    autoTPOnAllowEnabled = false,
    autoActivateEnabled = false,
    kickAfterStealEnabled = false,
    apDefenseEnabled = false,
    laserDefenseEnabled = false,
    aimbotEnabled = false,
    selectedSlot = 1,
    selectedGear = "Auto",
    speedNoStealEnabled = false,
    speedNoStealValue = 40,
    speedStealEnabled = false,
    speedStealValue = 61
}

if isfile and isfile(configFile) then
    local ok, decoded = pcall(function() return HttpService:JSONDecode(readfile(configFile)) end)
    if ok and decoded then
        for k, v in pairs(decoded) do
            if k ~= "selectedSlot" then HubConfig[k] = v end
        end
    end
end
HubConfig.selectedSlot = 1

local function saveHubConfig()
    if writefile then pcall(function() writefile(configFile, HttpService:JSONEncode(HubConfig)) end) end
end

local currentStealKey = Enum.KeyCode[HubConfig.stealKeybind or "E"]
local PotionEnabled = HubConfig.potionEnabled
local AutoWalkEnabled = HubConfig.autoWalkEnabled
local APOnStealEnabled = HubConfig.apOnStealEnabled
local AutoTPOnAllowEnabled = HubConfig.autoTPOnAllowEnabled or false
local AutoActivateEnabled = HubConfig.autoActivateEnabled or false
local KickAfterStealEnabled = HubConfig.kickAfterStealEnabled or false

HexDefenseState = _G.HexDefenseState or {
    AP = HubConfig.apDefenseEnabled or false,
    Laser = HubConfig.laserDefenseEnabled or false,
    Aimbot = HubConfig.aimbotEnabled or false
}

local selectedSlot = 1
local TargetBarLabel, refreshTargetBar, setStealingStatus
local manualStealingUntil = 0

-- ==========================================
-- SPEED BOOSTER (mutually exclusive)
-- ==========================================
local speedNoStealEnabled = HubConfig.speedNoStealEnabled and true or false
local speedNoStealValue   = HubConfig.speedNoStealValue or 40
local speedStealEnabled   = HubConfig.speedStealEnabled and true or false
local speedStealValue     = HubConfig.speedStealValue or 61
_G.SpeedBoostPaused = false

local function startNoDropBoost()
    local BOOST_LV = "StickNoDropLV"
    local BOOST_ATT = "StickNoDropAtt"

    local function destroyBoostLV(hrp)
        if not hrp then return end
        local lv = hrp:FindFirstChild(BOOST_LV)
        if lv then pcall(function() lv:Destroy() end) end
        local att = hrp:FindFirstChild(BOOST_ATT)
        if att then pcall(function() att:Destroy() end) end
    end

    local function ensureBoostLV(hrp)
        local lv = hrp:FindFirstChild(BOOST_LV)
        if lv and lv.Parent then return lv end
        destroyBoostLV(hrp)
        local att = Instance.new("Attachment")
        att.Name = BOOST_ATT
        att.Parent = hrp
        lv = Instance.new("LinearVelocity")
        lv.Name = BOOST_LV
        lv.Attachment0 = att
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
        lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
        lv.MaxForce = math.huge
        lv.PlaneVelocity = Vector2.zero
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.Parent = hrp
        return lv
    end

    RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        -- Sin speed activo: DESTROY LV para no bloquear movimiento normal
        if _G.SpeedBoostPaused or (not speedNoStealEnabled and not speedStealEnabled) then
            destroyBoostLV(hrp)
            return
        end

        local stealing = player:GetAttribute("Stealing") and true or false
        local spd = 0
        if speedNoStealEnabled then
            spd = tonumber(speedNoStealValue) or 40
        elseif speedStealEnabled then
            if stealing then
                spd = tonumber(speedStealValue) or 61
            else
                -- steal speed on pero no stealeando = caminar normal
                destroyBoostLV(hrp)
                return
            end
        end

        if spd <= 0 then
            destroyBoostLV(hrp)
            return
        end

        local lv = ensureBoostLV(hrp)
        local md = hum.MoveDirection
        if md.Magnitude > 0.1 then
            local flat = Vector3.new(md.X, 0, md.Z).Unit
            lv.PlaneVelocity = Vector2.new(flat.X * spd, flat.Z * spd)
        else
            lv.PlaneVelocity = Vector2.zero
        end
    end)
end
startNoDropBoost()

-- ==========================================
-- KICK AFTER STEAL
-- ==========================================
local kickKeyword = "you stole"
local function hasKickKeyword(text)
    if typeof(text) ~= "string" then return false end
    return string.find(string.lower(text), kickKeyword) ~= nil
end
local function checkAndKickObject(obj)
    if not KickAfterStealEnabled and not _G.StickKickAfterSteal then return end
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        if hasKickKeyword(obj.Text) then pcall(function() player:Kick("You stole brainrot!") end) end
    end
end
local function scanGuiForKick(parent)
    for _, obj in ipairs(parent:GetDescendants()) do
        checkAndKickObject(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj:GetPropertyChangedSignal("Text"):Connect(function() checkAndKickObject(obj) end)
        end
    end
end
PlayerGui.DescendantAdded:Connect(function(desc)
    checkAndKickObject(desc)
    if desc:IsA("TextLabel") or desc:IsA("TextButton") or desc:IsA("TextBox") then
        desc:GetPropertyChangedSignal("Text"):Connect(function() checkAndKickObject(desc) end)
    end
end)
scanGuiForKick(PlayerGui)

-- ==========================================
-- ADMIN PANEL SPAM
-- ==========================================
local ALL_CMDS = {"rocket", "tiny", "jumpscare", "morph", "inverse", "balloon", "ragdoll"}
local selectedCmds = {}
for _, cmd in ipairs(ALL_CMDS) do selectedCmds[cmd] = true end

local function clickGuiButton(button)
    if not button then return false end
    local ok = false
    pcall(function()
        if typeof(firesignal) == "function" then
            for _, ev in ipairs({button.MouseButton1Click, button.Activated, button.MouseButton1Down, button.MouseButton1Up, button.InputBegan}) do
                pcall(firesignal, ev); ok = true
            end
        end
        if typeof(getconnections) == "function" then
            for _, evName in ipairs({"MouseButton1Click", "Activated", "MouseButton1Down", "MouseButton1Up"}) do
                local okE, ev = pcall(function() return button[evName] end)
                if okE and ev then
                    local okC, conns = pcall(getconnections, ev)
                    if okC and type(conns) == "table" then
                        for _, c in ipairs(conns) do
                            if c and type(c.Function) == "function" then task.spawn(c.Function); ok = true
                            elseif c and c.Fire then pcall(function() c:Fire() end); ok = true end
                        end
                    end
                end
            end
        end
        if button.Activate then pcall(function() button:Activate() end) ok = true end
    end)
    return ok
end

local function collectAdminButtons()
    local result = { players = {}, cmds = {} }
    local ap = PlayerGui:FindFirstChild("AdminPanel")
    if not ap then
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            local n = string.lower(gui.Name)
            if n:find("admin") or n:find("command") or n:find("modpanel") then ap = gui; break end
        end
    end
    if not ap then return result, nil end
    for _, desc in ipairs(ap:GetDescendants()) do
        if desc:IsA("TextButton") or desc:IsA("ImageButton") then
            local txt = ""
            if desc:IsA("TextButton") then txt = tostring(desc.Text or "") end
            if txt == "" then
                local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
                if lbl then txt = tostring(lbl.Text or "") end
            end
            local low = string.lower(txt)
            local instName = string.lower(desc.Name)
            local isCmd = false
            for _, cmd in ipairs(ALL_CMDS) do
                if low == cmd or low == ":" .. cmd or low == ";" .. cmd or low:find(cmd, 1, true) or instName == cmd or instName:find(cmd, 1, true) then
                    result.cmds[cmd] = result.cmds[cmd] or desc
                    isCmd = true; break
                end
            end
            if not isCmd and txt ~= "" then
                table.insert(result.players, { btn = desc, text = low, name = desc.Name })
            end
        end
    end
    return result, ap
end

local function findPlayerBtn(cache, targetPlayer)
    if not targetPlayer then return nil end
    local names = { string.lower(targetPlayer.Name), string.lower(targetPlayer.DisplayName) }
    for _, data in ipairs(cache.players) do
        local t = data.text
        local n = string.lower(data.name or "")
        for _, want in ipairs(names) do
            if t == want or n == want or t:find(want, 1, true) or n:find(want, 1, true) then return data.btn end
        end
    end
    return nil
end

local function fireCmd(targetPlayer, cmd)
    if not targetPlayer or not cmd then return false end
    local cache = collectAdminButtons()
    local pb = findPlayerBtn(cache, targetPlayer)
    local cb = cache.cmds[string.lower(cmd)]
    if not pb or not cb then return false end
    clickGuiButton(pb); task.wait(); clickGuiButton(cb)
    return true
end

local lastSpam = 0
local function doSpam()
    if tick() - lastSpam < 0.1 then return end
    lastSpam = tick()
    local cache = collectAdminButtons()
    if not next(cache.cmds) then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local pb = findPlayerBtn(cache, p)
            if pb then
                for _, cmd in ipairs(ALL_CMDS) do
                    if selectedCmds[cmd] and cache.cmds[cmd] then
                        task.spawn(function()
                            clickGuiButton(pb); task.wait(); clickGuiButton(cache.cmds[cmd])
                        end)
                    end
                end
            end
        end
    end
end

-- ==========================================
-- ACCESORIOS
-- ==========================================
local ACCESSORIES_TO_REMOVE = {"Black Shield", "MechHorseHelmet_AccAccessory", "Glasses", "MeshPartAccessory", "LeftShoeAccessory", "RightShoeAccessory"}
local function cleanAccessories(char)
    if not char then return end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") then
            for _, name in ipairs(ACCESSORIES_TO_REMOVE) do
                if item.Name == name or string.find(item.Name, name) then
                    pcall(function() item:Destroy() end)
                end
            end
        end
    end
end
if player.Character then task.spawn(cleanAccessories, player.Character) end
player.CharacterAdded:Connect(function(char) task.wait(0.2); cleanAccessories(char) end)

-- ==========================================
-- BASES / PLOTS
-- ==========================================
local function detectStealAndWait()
    local startTime = tick()
    while player:GetAttribute("Stealing") == nil do
        if tick() - startTime >= 3 then break end
        task.wait(0.1)
    end
    if player:GetAttribute("Stealing") ~= nil then task.wait(0.5) end
end

local cachedMyBase = nil
local function findMyBase()
    if cachedMyBase and cachedMyBase.Parent then return cachedMyBase end
    local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Bases") or Workspace:FindFirstChild("Tycoons") or Workspace
    for _, base in pairs(plots:GetChildren()) do
        if base:IsA("Model") then
            local sign = base:FindFirstChild("PlotSign")
            local label = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame") and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
            if label and (string.find(label.Text, player.Name) or string.find(label.Text, player.DisplayName)) then
                cachedMyBase = base
                return base
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

local BASE_REF_B1 = Vector3.new(-337, -5, 100)
local BASE_REF_B2 = Vector3.new(-335, -5, 20)

local function plotSide(plot)
    if not plot then return nil end
    local pos = plot.PrimaryPart and plot.PrimaryPart.Position or plot:GetPivot().Position
    if (pos - BASE_REF_B1).Magnitude < (pos - BASE_REF_B2).Magnitude then return "b1" end
    return "b2"
end

local function getMySide()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local sign = plot:FindFirstChild("PlotSign")
            local sg = sign and sign:FindFirstChild("SurfaceGui")
            local frame = sg and sg:FindFirstChild("Frame")
            local label = frame and frame:FindFirstChild("TextLabel")
            if label and label.Text ~= "Empty Base" then
                local owner = label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
                if owner == player.Name or owner == player.DisplayName then return plotSide(plot) end
            end
        end
    end
    return nil
end

local function getEnemySide()
    local mine = getMySide()
    if mine == "b1" then return "b2" end
    if mine == "b2" then return "b1" end
    return nil
end

local function isTargetPlot(plot)
    if not isEnemyPlot(plot) then return false end
    local enemySide = getEnemySide()
    if not enemySide then return true end
    return plotSide(plot) == enemySide
end

local darkBlueHighlight = Instance.new("Highlight")
darkBlueHighlight.Name = "Stick_NeonRed_Podium_Highlight"
darkBlueHighlight.FillColor = Color3.fromRGB(80, 0, 10)
darkBlueHighlight.OutlineColor = Color3.fromRGB(255, 30, 50)
darkBlueHighlight.FillTransparency = 0.35
darkBlueHighlight.OutlineTransparency = 0

local function pickPodiumForPlot(plot, cfg)
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local side = plotSide(plot)
    local podSlots = cfg.podSlots
    local grabRef = cfg.grab
    if not podSlots and not grabRef then podSlots = {"1", "10"} end
    if podSlots then
        local primary = (side == "b1") and podSlots[1] or (podSlots[2] or podSlots[1])
        local secondary = (side == "b1") and (podSlots[2] or podSlots[1]) or podSlots[1]
        return podiums:FindFirstChild(primary) or podiums:FindFirstChild(secondary)
    end
    local ref = (side == "b1") and grabRef.b1 or grabRef.b2
    local nearest, nd = nil, math.huge
    for _, podium in ipairs(podiums:GetChildren()) do
        local cm = podium:FindFirstChild("Claim") and podium.Claim:FindFirstChild("Main")
        if cm then
            local d = (cm.Position - ref).Magnitude
            if d < nd then nd, nearest = d, podium end
        end
    end
    return nearest
end

local function getTargetPodiumForSlot(slot)
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local cfg = SLOT_CONFIGS and (SLOT_CONFIGS[slot] or SLOT_CONFIGS[1])
    if not cfg then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if isTargetPlot(plot) then
            local podium = pickPodiumForPlot(plot, cfg)
            if podium and podium:FindFirstChildWhichIsA("ProximityPrompt", true) then return podium end
        end
    end
    return nil
end

local function getSlotTargetName()
    local podium = getTargetPodiumForSlot(selectedSlot)
    if not podium then return "None" end
    local GENERIC = { [""] = true, ["steal"] = true, ["steal brainrot"] = true, ["brainrot"] = true, ["interact"] = true, ["claim"] = true, ["collect"] = true,
        ["base"] = true, ["empty base"] = true, ["empty"] = true, ["podium"] = true, ["animalpodium"] = true, ["spawn"] = true, ["platform"] = true, ["none"] = true }
    local IGNORED_PARTS = { ["base"] = true, ["claim"] = true, ["podium"] = true, ["platform"] = true, ["spawn"] = true, ["hitbox"] = true,
        ["main"] = true, ["stand"] = true, ["display"] = true, ["decorations"] = true, ["decoration"] = true, ["decor"] = true,
        ["effects"] = true, ["effect"] = true, ["particles"] = true, ["lights"] = true, ["light"] = true, ["model"] = true,
        ["part"] = true, ["mesh"] = true, ["meshpart"] = true, ["union"] = true, ["folder"] = true, ["gui"] = true,
        ["billboard"] = true, ["attachment"] = true, ["sign"] = true, ["sound"] = true, ["animals"] = true, ["animal"] = true,
        ["overhead"] = true, ["info"] = true, ["glow"] = true, ["floor"] = true, ["cover"] = true, ["lock"] = true, ["locked"] = true }
    local prompt = podium:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        for _, field in ipairs({ "ObjectText", "ActionText" }) do
            local t = prompt[field]
            if typeof(t) == "string" then
                local stripped = t:gsub("^%s*[Ss]teal%s+", ""):gsub("%s+$", "")
                if stripped ~= "" and not GENERIC[stripped:lower()] then return stripped end
            end
        end
    end
    for _, c in ipairs(podium:GetChildren()) do
        if (c:IsA("Model") or c:IsA("Tool") or c:IsA("MeshPart")) and c.Name ~= podium.Name
            and not IGNORED_PARTS[c.Name:lower()] and not GENERIC[c.Name:lower()] then return c.Name end
    end
    return "None"
end

task.spawn(function()
    while task.wait(0.4) do
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

-- ==========================================
-- FFLAGS
-- ==========================================
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
    CheckPVCachedRotVelocityThresholdPercent = 10, WorldStepMax = 30,
    InterpolationFramePositionThresholdMillionth = 5, TimestepArbiterHumanoidTurningVelThreshold = 1,
    SimOwnedNOUCountThresholdMillionth = 2147483647, GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    NextGenReplicatorEnabledWrite4 = true, TimestepArbiterOmegaThou = 1073741823, MaxAcceptableUpdateDelay = 1,
    LargeReplicatorSerializeWrite4 = true
}
local function setFFlags()
    if type(setfflag) ~= "function" then return end
    for name, value in pairs(FFlags) do pcall(function() setfflag(tostring(name), tostring(value)) end) end
end

-- ==========================================
-- GEARS
-- ==========================================
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

-- ==========================================
-- MOVIMIENTO
-- ==========================================
local function walkTo(hrp, targetCords, desiredSpeed, precisionThreshold, noGear)
    if not hrp or not hrp.Parent or not targetCords then return end
    desiredSpeed = desiredSpeed or 180
    _G.SpeedBoostPaused = true
    local running = true
    local connection
    local threshold = precisionThreshold or 3
    local _ctrls
    pcall(function() _ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls() end)
    if _ctrls then pcall(function() _ctrls:Disable() end) end
    connection = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent or not running then
            if connection then connection:Disconnect() end
            return
        end
        local currentPos = hrp.Position
        local flatCurrent = Vector3.new(currentPos.X, targetCords.Y, currentPos.Z)
        local direction = targetCords - flatCurrent
        local distance = direction.Magnitude
        if distance <= threshold then
            running = false
            connection:Disconnect()
            hrp.Velocity = Vector3.zero
            return
        end
        if not noGear then EquipBestMount() end
        local vel = direction.Unit * desiredSpeed
        hrp.Velocity = Vector3.new(vel.X, hrp.Velocity.Y, vel.Z)
    end)
    local startT = tick()
    while running do
        if tick() - startT > 6 then break end
        task.wait()
    end
    if _ctrls then pcall(function() _ctrls:Enable() end) end
    _G.SpeedBoostPaused = false
end

local function flyTo(hrp, targetPos, speed)
    if not hrp or not hrp.Parent or not targetPos then return end
    speed = speed or 160
    _G.SpeedBoostPaused = true
    local _ctrls
    pcall(function() _ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls() end)
    if _ctrls then pcall(function() _ctrls:Disable() end) end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        local carpet = findToolFlexible(char, "flying carpet") or findToolFlexible(player:FindFirstChild("Backpack"), "flying carpet")
        if carpet then
            pcall(function() hum:UnequipTools() end)
            task.wait(0.03)
            pcall(function() hum:EquipTool(carpet) end)
        else
            EquipBestMount()
        end
    end
    local oldV = hrp:FindFirstChild("LinearVelocity"); if oldV then oldV:Destroy() end
    local oldA = hrp:FindFirstChild("Attachment"); if oldA then oldA:Destroy() end
    local attachment = Instance.new("Attachment")
    attachment.Parent = hrp
    local velocity = Instance.new("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.MaxForce = 50000
    velocity.Parent = hrp
    local running = true
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent or not running then
            if connection then connection:Disconnect() end
            return
        end
        local dir = targetPos - hrp.Position
        local dist = dir.Magnitude
        if dist <= 3.5 then
            running = false
            connection:Disconnect()
            velocity.VectorVelocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(targetPos)
            return
        end
        local speedMult = dist < 12 and math.max(0.15, dist / 12) or 1
        velocity.VectorVelocity = dir.Unit * speed * speedMult
    end)
    local startT = tick()
    while running do
        if tick() - startT > 8 then break end
        task.wait()
    end
    if velocity and velocity.Parent then velocity:Destroy() end
    if attachment and attachment.Parent then attachment:Destroy() end
    if hrp and hrp.Parent then hrp.AssemblyLinearVelocity = Vector3.zero end
    if _ctrls then pcall(function() _ctrls:Enable() end) end
    _G.SpeedBoostPaused = false
end

local function walkToLinear(HRP, targetPos, speed, arriveDist, timeout)
    if not HRP or not HRP.Parent or not targetPos then return end
    speed = speed or 28
    arriveDist = arriveDist or 6
    timeout = timeout or 6
    _G.SpeedBoostPaused = true
    local attachment = Instance.new("Attachment")
    attachment.Parent = HRP
    local linearVelocity = Instance.new("LinearVelocity")
    linearVelocity.MaxForce = 100000
    linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
    linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    linearVelocity.Attachment0 = attachment
    linearVelocity.Parent = HRP
    local start = tick()
    while HRP and HRP.Parent do
        local d = targetPos - HRP.Position
        local flat = Vector3.new(d.X, 0, d.Z)
        local mag = flat.Magnitude
        if mag < arriveDist or tick() - start > timeout then break end
        local dir = flat.Unit
        linearVelocity.VectorVelocity = Vector3.new(dir.X * speed, 0, dir.Z * speed)
        task.wait()
    end
    linearVelocity.VectorVelocity = Vector3.zero
    linearVelocity:Destroy()
    attachment:Destroy()
    if HRP and HRP.Parent then HRP.AssemblyLinearVelocity = Vector3.zero end
    _G.SpeedBoostPaused = false
end

local function runAutoWalkLogic(HRP, midPos)
    if not HRP or not HRP.Parent then return end
    detectStealAndWait()
    pcall(function()
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:UnequipTools() end
    end)
    local speedVal = PotionEnabled and 33 or 28
    if midPos then walkToLinear(HRP, midPos, speedVal, 3, 6) end
    local myBase = findMyBase()
    if myBase then
        local basePos = myBase:GetPivot().Position
        local closestHitbox = nil
        local shortestDistance = math.huge
        for _, obj in pairs(myBase:GetDescendants()) do
            if obj.Name == "DeliveryHitbox" and obj:IsA("BasePart") then
                local dist = (obj.Position - basePos).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestHitbox = obj
                end
            end
        end
        if closestHitbox then walkToLinear(HRP, closestHitbox.Position, speedVal, 6, 6) end
    end
end

local function canDirectTp(HRP, targetPos)
    if not HRP or not targetPos then return false end
    if math.abs(targetPos.Y - HRP.Position.Y) > 6 then return false end
    local origin = HRP.Position
    local ignored = { player.Character }
    for _ = 1, 12 do
        local direction = targetPos - origin
        if direction.Magnitude <= 0.05 then return true end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = ignored
        params.IgnoreWater = true
        local result = Workspace:Raycast(origin, direction, params)
        if not result then return true end
        local hit = result.Instance
        if not hit then return true end
        if hit:IsA("BasePart") and not hit.CanCollide then
            table.insert(ignored, hit)
            origin = result.Position + direction.Unit * 0.1
        else
            return (result.Position - targetPos).Magnitude <= 3
        end
    end
    return false
end

local function ExecuteAutoPotion()
    if PotionEnabled or _G.StickPotionEnabled or APOnStealEnabled then
        local potion = player.Backpack:FindFirstChild("Giant Potion") or player.Character:FindFirstChild("Giant Potion")
        if potion then
            player.Character.Humanoid:EquipTool(potion)
            potion:Activate()
        end
    end
end

-- ==========================================
-- STEAL CALLBACKS
-- ==========================================
local __stealCbCache_v2 = setmetatable({}, { __mode = "k" })
local function __buildStealCallbacks_v2(prompt)
    if type(getconnections) ~= "function" then return nil end
    if __stealCbCache_v2[prompt] then return __stealCbCache_v2[prompt] end
    local data = { hold = {}, trigger = {} }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 then for _, c in ipairs(c1) do if type(c.Function) == "function" then table.insert(data.hold, c.Function) end end end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 then for _, c in ipairs(c2) do if type(c.Function) == "function" then table.insert(data.trigger, c.Function) end end end
    if #data.hold == 0 and #data.trigger == 0 then return nil end
    __stealCbCache_v2[prompt] = data
    return data
end

local __FH_v2 = {}
function __FH_v2.startStealHold(prompt)
    if not prompt or not prompt.Parent then return nil end
    local cb = __buildStealCallbacks_v2(prompt)
    if not cb then return nil end
    for _, fn in ipairs(cb.hold) do task.spawn(fn) end
    local now = tick()
    return { prompt = prompt, cb = cb, ragdollFireTime = now, startedAt = now, holdBeganAt = now, holdDone = true }
end
function __FH_v2.waitForStealTime(ctx, sec)
    if not ctx or sec >= 1.0 then return end
    local elapsed = tick() - ctx.ragdollFireTime
    if elapsed < sec then task.wait(sec - elapsed) end
end
function __FH_v2.finishStealHold(ctx)
    if not ctx then return false end
    local heldFor = tick() - (ctx.holdBeganAt or tick())
    if heldFor < 1.3 then task.wait(1.3 - heldFor) end
    task.wait(0.02)
    for _, fn in ipairs(ctx.cb.trigger) do task.spawn(fn) end
    return true
end

-- ==========================================
-- SLOT CONFIGS
-- ==========================================
local SLOT_CONFIGS
SLOT_CONFIGS = {
    [1] = { podSlots = {"1", "10"},
        b1 = { waypoints = { Vector3.new(-352.51, -6.35, 6.89), Vector3.new(-353.11, -6.46, 113.28), Vector3.new(-333.95, -4.62, 100.70) }, greenPos = Vector3.new(-349.87, -6.52, 82.97) },
        b2 = { waypoints = { Vector3.new(-352.76, -6.38, 114.06), Vector3.new(-351.49, -6.38, 7.00), Vector3.new(-334.80, -5.04, 18.90) }, greenPos = Vector3.new(-349.42, -6.52, 37.47) } },
    [2] = { grab = { b1 = Vector3.new(-323.62, -4.87, 94.83), b2 = Vector3.new(-323.81, -4.76, 24.58) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-327.32, -5.37, 95.53) }, greenPos = Vector3.new(-347.00, -7.27, 96.85) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-327.74, -5.26, 23.78) }, greenPos = Vector3.new(-344.99, -7.16, 26.28) } },
    [3] = { podSlots = {"3", "8"},
        b1 = { waypoints = { Vector3.new(-352.56, -6.35, 6.43), Vector3.new(-352.50, -6.35, 113.92), Vector3.new(-319.34, -4.62, 99.20) }, greenPos = Vector3.new(-345.00, -6.52, 92.00) },
        b2 = { waypoints = { Vector3.new(-352.76, -6.38, 114.06), Vector3.new(-352.72, -6.38, 6.30), Vector3.new(-319.81, -4.62, 20.98) }, greenPos = Vector3.new(-344.00, -6.52, 29.00) } },
    [4] = { podSlots = {"4", "7"},
        b1 = { waypoints = { Vector3.new(-352.70, -6.38, 6.47), Vector3.new(-352.59, -6.35, 113.35), Vector3.new(-311.25, -4.57, 98.98) }, greenPos = Vector3.new(-337.58, -4.42, 91.88) },
        b2 = { waypoints = { Vector3.new(-352.76, -6.38, 114.06), Vector3.new(-352.75, -6.38, 6.15), Vector3.new(-312.58, -4.62, 20.83) }, greenPos = Vector3.new(-336.70, -4.62, 28.20) } },
    [5] = { podSlots = {"5", "6"},
        b1 = { waypoints = { Vector3.new(-352.76, -6.74, 7.06), Vector3.new(-352.76, -6.74, 114.06), Vector3.new(-303.58, -4.78, 102.00) }, greenPos = Vector3.new(-331.30, -4.58, 93.20) },
        b2 = { waypoints = { Vector3.new(-352.76, -6.74, 114.06), Vector3.new(-352.76, -6.74, 7.06), Vector3.new(-303.48, -4.83, 17.91) }, greenPos = Vector3.new(-330.40, -4.53, 26.60) } },
    [6] = { grab = { b1 = Vector3.new(-301.05, -4.87, 131.80), b2 = Vector3.new(-331.58, -4.76, -11.37) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-301.45, -5.12, 126.61) }, greenPos = Vector3.new(-311.91, -5.37, 116.65) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-335.76, -5.26, -9.52) }, greenPos = Vector3.new(-345.10, -6.86, -0.77) } },
    [7] = { grab = { b1 = Vector3.new(-308.95, -4.87, 132.27), b2 = Vector3.new(-324.12, -4.76, -10.94) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-310.69, -5.12, 126.77) }, greenPos = Vector3.new(-318.30, -5.37, 117.26) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-326.93, -5.26, -7.11) }, greenPos = Vector3.new(-330.14, -5.26, 3.02) } },
    [8] = { grab = { b1 = Vector3.new(-316.43, -4.87, 131.69), b2 = Vector3.new(-316.07, -4.76, -11.31) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-318.12, -5.12, 125.58) }, greenPos = Vector3.new(-325.05, -5.37, 117.70) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-316.66, -5.06, -5.03) }, greenPos = Vector3.new(-323.05, -5.26, 4.12) } },
    [9] = { grab = { b1 = Vector3.new(-323.99, -4.87, 131.62), b2 = Vector3.new(-308.89, -4.76, -11.27) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-325.46, -5.12, 125.92) }, greenPos = Vector3.new(-335.57, -5.37, 116.43) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-310.28, -5.01, -5.47) }, greenPos = Vector3.new(-316.93, -5.26, 1.19) } },
    [10] = { grab = { b1 = Vector3.new(-331.34, -4.87, 131.85), b2 = Vector3.new(-301.45, -4.76, -11.07) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-333.38, -5.12, 126.12) }, greenPos = Vector3.new(-345.51, -6.87, 118.15) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-303.55, -5.11, -5.47) }, greenPos = Vector3.new(-310.47, -5.26, 0.60) } },
    [11] = { grab = { b1 = Vector3.new(-331.20, 13.13, 95.86), b2 = Vector3.new(-331.29, 13.24, -10.88) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-330.78, 6, 94.89) }, greenPos = Vector3.new(-343.47, -7.27, 97.07) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-331.92, 5.24, -15.30) }, greenPos = Vector3.new(-344.39, -7.16, -15.11) } },
    [12] = { grab = { b1 = Vector3.new(-331.20, 13.13, 95.86), b2 = Vector3.new(-323.97, 13.24, -10.87) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-323.71, 6, 94.51) }, greenPos = Vector3.new(-344.05, -7.27, 98.61) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-324.16, 5.24, -15.10) }, greenPos = Vector3.new(-345.10, -7.16, -10.35) } },
    [13] = { grab = { b1 = Vector3.new(-316.21, 13.13, 96.09), b2 = Vector3.new(-316.60, 13.24, -10.95) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-316.75, 6, 96.26) }, greenPos = Vector3.new(-325.61, -4.87, 96.06) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-317.35, 5.24, -14.98) }, greenPos = Vector3.new(-328.77, -5.01, -12.06) } },
    [14] = { grab = { b1 = Vector3.new(-309.03, 13.13, 95.84), b2 = Vector3.new(-308.94, 13.24, -11.24) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-312.86, 5.24, 97.53) }, greenPos = Vector3.new(-328.82, -5.12, 96.22) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-309.42, 5.24, -15.15) }, greenPos = Vector3.new(-319.79, -5.26, -11.06) } },
    [15] = { grab = { b1 = Vector3.new(-301.03, 13.13, 95.45), b2 = Vector3.new(-301.38, 13.24, -11.37) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-301.73, 6, 99.70) }, greenPos = Vector3.new(-314.93, -4.87, 96.29) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-302.82, 5.24, -14.83) }, greenPos = Vector3.new(-314.20, -5.01, -11.40) } },
    [16] = { grab = { b1 = Vector3.new(-331.54, 13.08, 130.61), b2 = Vector3.new(-331.39, 13.19, 23.74) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-331.48, 6, 129.46) }, greenPos = Vector3.new(-344.41, -7.27, 131.44) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-331.34, 5.24, 28.39) }, greenPos = Vector3.new(-345.52, -7.16, 24.30) } },
    [17] = { grab = { b1 = Vector3.new(-324.14, 13.13, 130.98), b2 = Vector3.new(-323.67, 13.24, 24.91) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-323.83, 6, 129.60) }, greenPos = Vector3.new(-343.86, -7.27, 132.08) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-323.28, 5.24, 28.10) }, greenPos = Vector3.new(-337.32, -5.26, 24.37) } },
    [18] = { grab = { b1 = Vector3.new(-316.62, 13.13, 131.50), b2 = Vector3.new(-316.54, 13.24, 24.40) },
        b1 = { waypoints = { Vector3.new(-352.76, -7.18, 7.06), Vector3.new(-353.03, -7.18, 113.20), Vector3.new(-315.83, 6, 132.49) }, greenPos = Vector3.new(-331.34, -4.87, 132.05) },
        b2 = { waypoints = { Vector3.new(-352.76, -7.18, 114.06), Vector3.new(-352.59, -7.12, 13.95), Vector3.new(-316.85, 5.24, 27.92) }, greenPos = Vector3.new(-328.71, -5.01, 24.78) } }
}

local HalfwaySteal = { debounce = false }

function HalfwaySteal.setSlot(slot)
    if slot >= 1 and slot <= 18 then
        selectedSlot = slot
        HubConfig.selectedSlot = slot
        saveHubConfig()
    end
end

function HalfwaySteal.SSDoTeleport()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    setFFlags()
    SSEquipGrapple()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return end
    local slotCfg = SLOT_CONFIGS[selectedSlot] or SLOT_CONFIGS[1]
    local enemyPlots = {}
    for _, plot in ipairs(plots:GetChildren()) do
        if isTargetPlot(plot) then table.insert(enemyPlots, plot) end
    end
    if #enemyPlots == 0 then return end
    local podium = nil
    for _, plot in ipairs(enemyPlots) do
        local p = pickPodiumForPlot(plot, slotCfg)
        if p and p:FindFirstChildWhichIsA("ProximityPrompt", true) then
            local cm = p:FindFirstChild("Claim") and p.Claim:FindFirstChild("Main")
            podium = { plot = plot, prompt = p:FindFirstChildWhichIsA("ProximityPrompt", true), position = cm and cm.Position or p:GetPivot().Position, isEnemyBase1 = (plotSide(plot) == "b1") }
            break
        end
    end
    if not podium then return end
    task.spawn(function()
        pcall(function()
            local pod = podium
            local config = pod.isEnemyBase1 and slotCfg.b1 or slotCfg.b2
            local greenPos = config and config.greenPos
            local waypoints = config and config.waypoints
            if not waypoints then return end
            local SKIP_MAX_DIST = 40
            local function computeStartIndex(HRP_)
                if not HRP_ or not HRP_.Parent then return 1 end
                for i = #waypoints - 1, 1, -1 do
                    local wp = waypoints[i]
                    if (wp - HRP_.Position).Magnitude <= SKIP_MAX_DIST and canDirectTp(HRP_, wp) then return i end
                end
                return 1
            end
            local ctx = nil
            if pod.prompt and pod.prompt.Parent then
                pod.prompt.RequiresLineOfSight = false
                pod.prompt.MaxActivationDistance = math.huge
                if type(getconnections) == "function" then
                    ctx = __FH_v2.startStealHold(pod.prompt)
                else
                    task.spawn(function() if fireproximityprompt then fireproximityprompt(pod.prompt) end end)
                end
            end
            if ctx then __FH_v2.waitForStealTime(ctx, 0.1) end
            local SEMI_TP_TARGET = 1.2
            local timingStart = tick()
            local syncStartIndex = computeStartIndex(hrp)
            local estTravel = 0
            local prevPos = hrp.Position
            for i = syncStartIndex, #waypoints do
                local wp = waypoints[i]
                local segDist = (wp - prevPos).Magnitude
                local isFly = (wp.Y - prevPos.Y) > 3
                estTravel = estTravel + segDist / (isFly and 160 or 180)
                prevPos = wp
            end
            local startDelay = SEMI_TP_TARGET - estTravel - (tick() - timingStart)
            if startDelay > 0 then task.wait(startDelay) end
            for i = syncStartIndex, #waypoints do
                local wp = waypoints[i]
                if wp.Y - hrp.Position.Y > 3 then
                    flyTo(hrp, wp, 160)
                    -- slots 11-18: al subir espera 2s y baja
                    if selectedSlot >= 11 and selectedSlot <= 18 then
                        task.wait(2)
                        local downY = (greenPos and greenPos.Y) or (wp.Y - 18)
                        local downPos = Vector3.new(wp.X, downY, wp.Z)
                        if hrp and hrp.Parent then
                            if (hrp.Position.Y - downY) > 3 then
                                flyTo(hrp, downPos, 160)
                            else
                                walkTo(hrp, downPos, 180)
                            end
                        end
                    end
                else
                    walkTo(hrp, wp, 180)
                end
            end
            task.wait(0.25)
            ExecuteAutoPotion()
            SSEquipGrapple()
            if pod.prompt and pod.prompt.Parent then
                if greenPos then
                    if ctx then __FH_v2.waitForStealTime(ctx, 1.3) end
                    hrp.CFrame = CFrame.new(greenPos)
                end
                if ctx then __FH_v2.finishStealHold(ctx) end
            end
            if AutoWalkEnabled or _G.StickAutoWalk then
                local midPos = (selectedSlot == 4 or selectedSlot == 5) and (pod.isEnemyBase1 and Vector3.new(-346.51, -6.52, 94.05) or Vector3.new(-345.94, -6.52, 26.71)) or nil
                runAutoWalkLogic(hrp, midPos)
            end
        end)
    end)
end

function HalfwaySteal.execute()
    if player:GetAttribute("Stealing") or HalfwaySteal.debounce then return end
    HalfwaySteal.debounce = true
    if setStealingStatus then setStealingStatus(true) end
    if APOnStealEnabled or _G.StickAPOnSteal then task.spawn(doSpam) end
    task.spawn(function()
        setFFlags()
        HalfwaySteal.SSDoTeleport()
        task.wait(0.1)
        HalfwaySteal.debounce = false
        if setStealingStatus then setStealingStatus(false) end
    end)
end

local function checkEnemyBaseOpen()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _, plot in ipairs(plots:GetChildren()) do
        if isEnemyPlot(plot) then
            for _, desc in ipairs(plot:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and string.find(desc.ObjectText, "Disallow") then return true end
            end
        end
    end
    return false
end

local hasAutoTPTriggered = false
task.spawn(function()
    while task.wait(1.5) do
        if checkEnemyBaseOpen() then
            if (AutoTPOnAllowEnabled or _G.StickAutoTPAllow) and not hasAutoTPTriggered and not HalfwaySteal.debounce and not player:GetAttribute("Stealing") then
                hasAutoTPTriggered = true
                HalfwaySteal.execute()
            end
        else
            hasAutoTPTriggered = false
        end
    end
end)

-- ==========================================
-- INSTANT RESET
-- ==========================================
local resetLockConn = nil
local function doReset()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local tool = EquipBestMount()
    if not tool then return end
    local lockedCFrame = hrp.CFrame + Vector3.new(0, 1000000000, 0)
    if resetLockConn then pcall(function() resetLockConn:Disconnect() end) resetLockConn = nil end
    resetLockConn = RunService.Heartbeat:Connect(function()
        local curChar = player.Character
        if not curChar then
            if resetLockConn then resetLockConn:Disconnect() resetLockConn = nil end
            return
        end
        local curHrp = curChar:FindFirstChild("HumanoidRootPart")
        local curHum = curChar:FindFirstChildOfClass("Humanoid")
        if curHrp and curHrp ~= hrp then
            if resetLockConn then resetLockConn:Disconnect() resetLockConn = nil end
            return
        end
        if curHrp and curHum and curHum.Health > 0 then
            curHrp.CFrame = lockedCFrame
        else
            if resetLockConn then resetLockConn:Disconnect() resetLockConn = nil end
        end
    end)
end
function HalfwaySteal.activate()
    task.spawn(function()
        setFFlags()
        doReset()
    end)
end

-- ==========================================
-- ALLOW / DISALLOW
-- ==========================================
do
    local AllowDisallowGui = Instance.new("ScreenGui")
    AllowDisallowGui.Name = "AllowDisallow"
    AllowDisallowGui.ResetOnSpawn = false
    AllowDisallowGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    AllowDisallowGui.Parent = safeGuiTarget

    local function ApplyFastEffects(parentFrame)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Thickness = 1.2
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Color = COLOR_BORDER
        uiStroke.Parent = parentFrame
        local grad = Instance.new("UIGradient")
        grad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, COLOR_ACCENT),
            ColorSequenceKeypoint.new(1, COLOR_BORDER)
        }
        grad.Parent = uiStroke
        animatedGradients[grad] = 500
    end

    local MainAllowBtn = Instance.new("TextButton")
    MainAllowBtn.Size = UDim2.new(0, 84, 0, 48)
    MainAllowBtn.Position = UDim2.new(0.65, 36, 0, 15)
    MainAllowBtn.BackgroundColor3 = COLOR_BG_DARK
    MainAllowBtn.BackgroundTransparency = 0.2
    MainAllowBtn.Text = "WAITING"
    MainAllowBtn.TextColor3 = COLOR_TEXT_LIGHT
    MainAllowBtn.Font = Enum.Font.GothamBold
    MainAllowBtn.TextSize = 10
    MainAllowBtn.Parent = AllowDisallowGui
    createUICorner(MainAllowBtn, 8)
    ApplyFastEffects(MainAllowBtn)

    local draggingAllow, dragStartAllow, startPosAllow, dragIdAllow
    MainAllowBtn.InputBegan:Connect(function(input)
        if not draggingAllow and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            draggingAllow = true
            dragIdAllow = input
            dragStartAllow = input.Position
            startPosAllow = MainAllowBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    draggingAllow = false
                    dragIdAllow = nil
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingAllow and input == dragIdAllow and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartAllow
            MainAllowBtn.Position = UDim2.new(startPosAllow.X.Scale, startPosAllow.X.Offset + delta.X, startPosAllow.Y.Scale, startPosAllow.Y.Offset + delta.Y)
        end
    end)

    local activeHubs = {}
    local function createFloatingHub(parent, statusText)
        if activeHubs[parent] then return end
        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0, 40, 0, 10)
        billboard.Adornee = parent
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = AllowDisallowGui
        local HubFrame = Instance.new("Frame")
        HubFrame.Size = UDim2.new(1, 0, 1, 0)
        HubFrame.BackgroundColor3 = COLOR_BG_DARK
        HubFrame.BackgroundTransparency = 0.2
        HubFrame.BorderSizePixel = 0
        HubFrame.Parent = billboard
        createUICorner(HubFrame, 6)
        ApplyFastEffects(HubFrame)
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Size = UDim2.new(1, 0, 1, 0)
        statusLabel.BackgroundTransparency = 1
        statusLabel.Text = statusText
        statusLabel.TextColor3 = COLOR_TEXT_LIGHT
        statusLabel.TextSize = 18
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.Parent = HubFrame
        applyTextGradient(statusLabel)
        activeHubs[parent] = billboard
    end

    task.spawn(function()
        while task.wait(2) do
            local currentObjects = {}
            local myBase = findMyBase()
            local nearestPrompt = nil
            local minDist = math.huge
            local plots = Workspace:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    for _, desc in ipairs(plot:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") then
                            local isAllow = string.find(desc.ObjectText, "Allow Friends")
                            local isDisallow = string.find(desc.ObjectText, "Disallow Friends")
                            if isAllow or isDisallow then
                                local part = desc.Parent:IsA("BasePart") and desc.Parent or desc.Parent:FindFirstChildWhichIsA("BasePart", true)
                                if part then
                                    currentObjects[part] = true
                                    local status = isAllow and "X" or "☑️"
                                    if activeHubs[part] then
                                        local label = activeHubs[part].Frame.TextLabel
                                        if label.Text ~= status then label.Text = status end
                                    else
                                        createFloatingHub(part, status)
                                    end
                                    if myBase and part:IsDescendantOf(myBase) then
                                        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                        if hrp then
                                            local dist = (hrp.Position - part.Position).Magnitude
                                            if dist < minDist then
                                                minDist = dist
                                                nearestPrompt = desc
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            MainAllowBtn.Text = nearestPrompt and (string.find(nearestPrompt.ObjectText, "Disallow") and "DISALLOW" or "ALLOW") or "NO BASE"
            for part, bbg in pairs(activeHubs) do
                if not currentObjects[part] then
                    bbg:Destroy()
                    activeHubs[part] = nil
                end
            end
        end
    end)

    MainAllowBtn.MouseButton1Click:Connect(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local myBase = findMyBase()
        local target = nil
        local minDist = math.huge
        if myBase then
            for _, desc in pairs(myBase:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and (string.find(desc.ObjectText, "Allow") or string.find(desc.ObjectText, "Disallow")) then
                    local part = desc.Parent:IsA("BasePart") and desc.Parent or desc.Parent:FindFirstChildWhichIsA("BasePart", true)
                    if part and hrp then
                        local dist = (hrp.Position - part.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            target = desc
                        end
                    end
                end
            end
        end
        if target then fireproximityprompt(target) end
    end)
end

-- ==========================================
-- GUI PRINCIPAL
-- ==========================================


-- ===== AUTO GRAB (steal bar) =====
local AutoGrabEnabled = false
local _AG = {
    StealRadius = 55, Mode = "half",
    HalfFireRange = 10, HalfHoldMin = 1.3, HalfHoldMax = 2.6, HalfEntryDelay = 0.3,
    StealDuration = 0.2, Data = {}, isStealing = false, stealStartTime = nil, autoConn = nil,
    gui = nil, renderConn = nil, inputConn = nil,
}

local function _AG_isMyPlot(plotName)
    local plots = Workspace:FindFirstChild("Plots"); if not plots then return false end
    local plot = plots:FindFirstChild(plotName); if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function _AG_findNearestPrompt()
    local char = player.Character; if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = Workspace:FindFirstChild("Plots"); if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not _AG_isMyPlot(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= _AG.StealRadius and d < dist then
                            local found = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then found = pr end
                                end
                            end
                            if not found then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and string.find(pr.ActionText, "Steal") then found = pr end
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

local function _AG_promptDist(prompt)
    local char = player.Character; if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    if part and part:IsA("BasePart") then return (part.Position - root.Position).Magnitude end
    local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf - root.Position).Magnitude end
    return math.huge
end

local function _AG_executeSteal(prompt)
    if _AG.isStealing then return end
    if not _AG.Data[prompt] then
        _AG.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(_AG.Data[prompt].hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(_AG.Data[prompt].trigger, c.Function) end
            end
        end
    end
    local data = _AG.Data[prompt]
    if not data.ready then return end
    data.ready = false
    _AG.isStealing = true
    _AG.stealStartTime = tick()
    if _AG.Mode == "half" then
        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            task.wait(_AG.HalfHoldMin)
            local inRange = _AG_promptDist(prompt) <= _AG.HalfFireRange
            while true do
                local el = tick() - _AG.stealStartTime
                if el > _AG.HalfHoldMax or not prompt.Parent then break end
                if _AG_promptDist(prompt) <= _AG.HalfFireRange then
                    if not inRange then task.wait(_AG.HalfEntryDelay) end
                    for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                    break
                end
                task.wait()
            end
            task.wait(0.05)
            data.ready = true
            _AG.isStealing = false
        end)
    else
        task.spawn(function()
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local el = 0
            while el < _AG.StealDuration do el = el + task.wait() end
            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            task.wait(0.05)
            data.ready = true
            _AG.isStealing = false
        end)
    end
end

local function _AG_startLoop()
    if _AG.autoConn then return end
    _AG.autoConn = RunService.Heartbeat:Connect(function()
        if not AutoGrabEnabled or _AG.isStealing then return end
        local p = _AG_findNearestPrompt()
        if p then _AG_executeSteal(p) end
    end)
end

local function _AG_stopLoop()
    if _AG.autoConn then
        pcall(function() _AG.autoConn:Disconnect() end)
        _AG.autoConn = nil
    end
    _AG.isStealing = false
end

local function _AG_destroyGui()
    if _AG.renderConn then pcall(function() _AG.renderConn:Disconnect() end) _AG.renderConn = nil end
    if _AG.inputConn then pcall(function() _AG.inputConn:Disconnect() end) _AG.inputConn = nil end
    if _AG.gui then pcall(function() _AG.gui:Destroy() end) _AG.gui = nil end
    pcall(function()
        local g = player.PlayerGui:FindFirstChild("StealProgressScreenGui")
        if g then g:Destroy() end
    end)
end

local function _AG_createGui()
    _AG_destroyGui()
    local sg = Instance.new("ScreenGui")
    sg.Name = "StealProgressScreenGui"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 200
    sg.IgnoreGuiInset = true
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = player:WaitForChild("PlayerGui")
    _AG.gui = sg

    local NEGRO = Color3.fromRGB(8, 0, 0)
    local NEON = Color3.fromRGB(255, 0, 0)
    local NEON_OSC = Color3.fromRGB(180, 0, 0)
    local NEON_GLOW = Color3.fromRGB(255, 60, 60)
    local BORDE = Color3.fromRGB(200, 0, 0)

    local frame = Instance.new("Frame", sg)
    frame.Name = "StealBar"
    frame.Size = UDim2.new(0, 210, 0, 26)
    frame.Position = UDim2.new(0.5, 0, 1, -50)
    frame.AnchorPoint = Vector2.new(0.5, 1)
    frame.BackgroundColor3 = NEGRO
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ZIndex = 300
    frame.ClipsDescendants = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = BORDE
    stroke.Thickness = 1.5

    local stealLbl = Instance.new("TextLabel", frame)
    stealLbl.Size = UDim2.new(0, 50, 1, 0)
    stealLbl.Position = UDim2.new(0, 6, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "STEAL"
    stealLbl.TextColor3 = NEON
    stealLbl.Font = Enum.Font.GothamBold
    stealLbl.TextSize = 12
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    stealLbl.ZIndex = 301

    local pctLbl = Instance.new("TextLabel", frame)
    pctLbl.Size = UDim2.new(0, 36, 1, 0)
    pctLbl.Position = UDim2.new(0, 54, 0, 0)
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = "0%"
    pctLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    pctLbl.Font = Enum.Font.GothamBold
    pctLbl.TextSize = 12
    pctLbl.TextXAlignment = Enum.TextXAlignment.Center
    pctLbl.ZIndex = 301

    local sep = Instance.new("Frame", frame)
    sep.Size = UDim2.new(0, 1, 0, 16)
    sep.Position = UDim2.new(0, 93, 0.5, -8)
    sep.BackgroundColor3 = BORDE
    sep.BorderSizePixel = 0
    sep.ZIndex = 301

    local barBg = Instance.new("Frame", frame)
    barBg.Size = UDim2.new(0, 105, 0, 12)
    barBg.Position = UDim2.new(0, 98, 0.5, -6)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
    barBg.BorderSizePixel = 0
    barBg.ClipsDescendants = true
    barBg.ZIndex = 301
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barStroke = Instance.new("UIStroke", barBg)
    barStroke.Color = NEON_OSC
    barStroke.Thickness = 1
    barStroke.Transparency = 0.4

    local fill = Instance.new("Frame", barBg)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = NEON
    fill.BorderSizePixel = 0
    fill.ZIndex = 302
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local grad = Instance.new("UIGradient", fill)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, NEON_OSC),
        ColorSequenceKeypoint.new(0.5, NEON),
        ColorSequenceKeypoint.new(1, NEON_GLOW)
    }
    grad.Rotation = 90

    local progress = 0
    _AG.renderConn = RunService.RenderStepped:Connect(function(dt)
        if not AutoGrabEnabled then return end
        progress = progress + (dt / 0.5)
        if progress >= 1 then progress = 0 end
        local f = math.clamp(progress, 0, 1)
        fill.Size = UDim2.new(f, 0, 1, 0)
        pctLbl.Text = math.floor(f * 100 + 0.5) .. "%"
    end)

    -- drag
    local wasDragged, dragging, dragStart, startPos = false, false, nil, nil
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            wasDragged = false
            dragStart = inp.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    _AG.inputConn = UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local dx = inp.Position.X - dragStart.X
            local dy = inp.Position.Y - dragStart.Y
            if math.abs(dx) > 4 or math.abs(dy) > 4 then wasDragged = true end
            local cam = Workspace.CurrentCamera
            local vp = cam and cam.ViewportSize or Vector2.new(1000, 1000)
            local basePx = startPos.X.Scale * vp.X
            local newX = basePx + startPos.X.Offset + dx
            local newY = startPos.Y.Scale * vp.Y + startPos.Y.Offset + dy
            frame.Position = UDim2.new(0, newX - frame.AbsoluteSize.X / 2, 0, newY - frame.AbsoluteSize.Y)
        end
    end)

    -- border shows active
    stroke.Color = NEON
    stroke.Thickness = 2
end

local function setAutoGrab(on)
    AutoGrabEnabled = on and true or false
    _G.StickAutoGrab = AutoGrabEnabled
    if AutoGrabEnabled then
        _AG_createGui()
        _AG_startLoop()
    else
        _AG_stopLoop()
        _AG_destroyGui()
    end
end


-- ===== NEXT BASE (empty base indicator) =====
local NextBaseEnabled = false
local _NB = {
    bases = {},
    connectedLabels = {},
    signalConnections = {},
    anchorPart = nil,
    billboard = nil,
    plotsConn = nil,
    childConn = nil,
}

local _NB_BASE_POSITIONS = {
    Vector3.new(-342.439, 10.399, 113.107),
    Vector3.new(-342.439, 10.465, 6.107),
    Vector3.new(-476.752, 10.465, 114.107),
    Vector3.new(-476.752, 10.465, 7.107),
    Vector3.new(-342.440, 10.464, 220.107),
    Vector3.new(-476.752, 10.465, 221.107),
    Vector3.new(-342.439, 10.465, -100.893),
    Vector3.new(-476.752, 10.465, -99.893),
}
local _NB_MATCH_TOLERANCE = 6
local _NB_EMPTY_TEXT = "Empty Base"
local _NB_ARROW = utf8.char(0x2B07)

local function _NB_getBaseIndex(model)
    local success, cframe = pcall(function() return model:GetBoundingBox() end)
    if not success or not cframe then return nil end
    local position = cframe.Position
    local bestIndex, bestDistance = nil, nil
    for i, basePos in ipairs(_NB_BASE_POSITIONS) do
        local dx, dz = position.X - basePos.X, position.Z - basePos.Z
        local distance = math.sqrt(dx * dx + dz * dz)
        if not bestDistance or distance < bestDistance then
            bestIndex, bestDistance = i, distance
        end
    end
    return (bestDistance and bestDistance <= _NB_MATCH_TOLERANCE) and bestIndex or nil
end

local function _NB_isBaseEmpty(label)
    if not label then return false end
    local t = tostring(label.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    return t == _NB_EMPTY_TEXT
end

local function _NB_updateAnchor()
    if not _NB.billboard or not _NB.anchorPart then return end
    local targetIdx
    for i = 1, #_NB_BASE_POSITIONS do
        local b = _NB.bases[i]
        if b and b.label and _NB_isBaseEmpty(b.label) then
            targetIdx = i
            break
        end
    end
    if targetIdx and _NB.bases[targetIdx] then
        _NB.anchorPart.CFrame = _NB.bases[targetIdx].cf
        _NB.billboard.Enabled = true
    else
        _NB.billboard.Enabled = false
    end
end

local function _NB_connectLabel(label)
    if not label or _NB.connectedLabels[label] then return end
    _NB.connectedLabels[label] = true
    local c = label:GetPropertyChangedSignal("Text"):Connect(_NB_updateAnchor)
    table.insert(_NB.signalConnections, c)
end

local function _NB_scanPlots()
    if not NextBaseEnabled then return end
    local Plots = Workspace:FindFirstChild("Plots")
    if not Plots then return end
    for _, plot in ipairs(Plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local model = sign and sign:FindFirstChild("Model")
        local gui = sign and sign:FindFirstChild("SurfaceGui")
        local frame = gui and gui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if model and label then
            local idx = _NB_getBaseIndex(model)
            if idx then
                local ok, cf = pcall(function() return select(1, model:GetBoundingBox()) end)
                if ok and cf then
                    _NB.bases[idx] = { label = label, cf = cf }
                    _NB_connectLabel(label)
                end
            end
        end
    end
    _NB_updateAnchor()
end

local function _NB_createBillboard()
    if _NB.anchorPart then return end
    local parentGui = safeGuiTarget or player:FindFirstChild("PlayerGui")
    local anchorPart = Instance.new("Part")
    anchorPart.Name = "__StickNextBaseAnchor"
    anchorPart.Anchored = true
    anchorPart.CanCollide = false
    anchorPart.CanQuery = false
    anchorPart.CanTouch = false
    anchorPart.Transparency = 1
    anchorPart.Size = Vector3.new(1, 1, 1)
    anchorPart.Parent = Workspace
    _NB.anchorPart = anchorPart

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NextBaseBillboard"
    billboard.Adornee = anchorPart
    billboard.Size = UDim2.fromScale(32, 13)
    billboard.StudsOffset = Vector3.new(0, 10, 0)
    billboard.MaxDistance = math.huge
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Enabled = false
    billboard.Parent = anchorPart
    _NB.billboard = billboard

    local topLabel = Instance.new("TextLabel", billboard)
    topLabel.BackgroundTransparency = 1
    topLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    topLabel.Position = UDim2.fromScale(0.5, 0.30)
    topLabel.Size = UDim2.fromScale(0.95, 0.50)
    topLabel.Font = Enum.Font.GothamBlack
    topLabel.Text = _NB_ARROW .. "  NEXT  " .. _NB_ARROW
    topLabel.TextScaled = true
    topLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
    topLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    topLabel.TextStrokeTransparency = 0

    local bottomLabel = Instance.new("TextLabel", billboard)
    bottomLabel.BackgroundTransparency = 1
    bottomLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    bottomLabel.Position = UDim2.fromScale(0.5, 0.72)
    bottomLabel.Size = UDim2.fromScale(0.95, 0.42)
    bottomLabel.Font = Enum.Font.GothamBlack
    bottomLabel.Text = "EMPTY BASE"
    bottomLabel.TextScaled = true
    bottomLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    bottomLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    bottomLabel.TextStrokeTransparency = 0
end

local function _NB_destroy()
    for _, c in ipairs(_NB.signalConnections) do
        pcall(function() c:Disconnect() end)
    end
    _NB.signalConnections = {}
    _NB.connectedLabels = {}
    _NB.bases = {}
    if _NB.plotsConn then pcall(function() _NB.plotsConn:Disconnect() end) _NB.plotsConn = nil end
    if _NB.childConn then pcall(function() _NB.childConn:Disconnect() end) _NB.childConn = nil end
    if _NB.anchorPart then pcall(function() _NB.anchorPart:Destroy() end) _NB.anchorPart = nil end
    _NB.billboard = nil
    pcall(function()
        local p = Workspace:FindFirstChild("__StickNextBaseAnchor")
        if p then p:Destroy() end
    end)
end

local function setNextBase(on)
    NextBaseEnabled = on and true or false
    _G.StickNextBase = NextBaseEnabled
    if NextBaseEnabled then
        _NB_createBillboard()
        _NB_scanPlots()
        local Plots = Workspace:FindFirstChild("Plots")
        if Plots and not _NB.plotsConn then
            _NB.plotsConn = Plots.DescendantAdded:Connect(function(d)
                if d:IsA("TextLabel") then task.defer(_NB_scanPlots) end
            end)
            _NB.childConn = Plots.ChildAdded:Connect(function()
                task.defer(_NB_scanPlots)
            end)
        end
    else
        _NB_destroy()
    end
end

-- ===== FLASH BLOCK SCRIPT (embedded) =====
local _StickFlashBlockSrc = [=====[
-- flash block init
task.wait(0.05)
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local TweenService=game:GetService("TweenService")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local Stats=game:GetService("Stats")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local StarterGui=game:GetService("StarterGui")
local GuiService=game:GetService("GuiService")
local CoreGui=game:GetService("CoreGui")
local Workspace=game:GetService("Workspace")
local LocalPlayer=Players.LocalPlayer
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
local VirtualInputManager = nil
pcall(function()
    VirtualInputManager = Instance.new("VirtualInputManager")
end)
if VirtualInputManager then
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end)
end

if _G.Formega_Script_Purge then pcall(function() _G.Formega_Script_Purge() end) task.wait(0.2) end
local ActiveConnections={}
local thisScriptStopped=false

-- ===== QUICK PICKUP (HoldDuration bajo en tu plot) =====
local QuickPickup = (function()
    local enabled = false
    local orig = {}
    local hooked = false
    local function isMyPlotQP(plot)
        if not plot or not plot:IsA("Model") then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled then return true end
        return false
    end
    local function inMyPlotQP(inst)
        if not inst or not inst.Parent then return false end
        local node = inst.Parent
        for _ = 1, 12 do
            if not node then return false end
            if node:IsA("Model") and node.Parent and node.Parent.Name == "Plots" then
                return isMyPlotQP(node)
            end
            node = node.Parent
        end
        return false
    end
    local function installHook()
        if hooked then return end
        local ok, mt = pcall(getrawmetatable, game)
        if not ok or not mt then return end
        pcall(setreadonly, mt, false)
        local oldNewIndex = mt.__newindex
        local nc = newcclosure or function(f) return f end
        mt.__newindex = nc(function(self, key, value)
            if not thisScriptStopped and key == "HoldDuration" and enabled
                and typeof(self) == "Instance" and self:IsA("ProximityPrompt") and inMyPlotQP(self) then
                value = 0.05
            end
            return oldNewIndex(self, key, value)
        end)
        pcall(setreadonly, mt, true)
        hooked = true
    end
    local M = {}
    function M.set(v)
        enabled = v and true or false
        _G.QuickPickup = enabled
        if enabled then
            installHook()
            task.spawn(function()
                local root = Workspace:FindFirstChild("Plots") or Workspace
                local stack = { root }
                local visited = 0
                while #stack > 0 and enabled do
                    local cur = table.remove(stack)
                    for _, d in ipairs(cur:GetChildren()) do
                        if d:IsA("ProximityPrompt") and inMyPlotQP(d) then
                            if orig[d] == nil then orig[d] = d.HoldDuration end
                            pcall(function() d.HoldDuration = 0.05 end)
                        end
                        table.insert(stack, d)
                    end
                    visited = visited + 1
                    if visited % 50 == 0 then task.wait() end
                end
            end)
        else
            for p, o in pairs(orig) do
                if p and p.Parent then pcall(function() p.HoldDuration = o end) end
            end
            orig = {}
        end
    end
    return M
end)()
_G._175_QuickPickup = QuickPickup

local AntiRagdollConns={}
local lastRagdollClean=0
local antiRagdollEnabled=false
_G.RagdollBypass=false
_G.AutoResetOnBalloon=true
_G.AutoGiant=false
_G.AutoBlock=false
_G.APESPEnabled=false
_G.BackpackESP=false
_G.ShowGiantPotion=true
_G.ShowFlashTeleport=true
_G.ShowFlyingCarpet=true
_G.BrainrotHighlight=false
_G.FPSBoostEnabled=false
_G.IPESPEnabled=false
_G.AutoSelectBrainrot=false
_G.AutoSelectBrainrotName=""
_G.AutoSelectBrainrotSlot=0
_G.QuickAP=false
_G.DropBrainrotEnabled=false
_G.ESPBaseEnabled=false
_G.ESPBestEnabled=false
_G.LaggerOnFlash=false
_G.LaggerPower=50
_G.LaggerBypass=false
_G.LaggerVersion="v1"
_G.antiGummyEnabled=false
_G.AutoTurretEnabled=false
_G.AutoReturnBase=false
_G.FlashSpeed=180
_G.TransportIndex=1
_G.AntiSteal=false
_G.QuickPickup=false
_G.AntiStealMode="laser" -- "laser" | "ap"
_G.AntiStealDelay=1.8
_G.AntiStealAP = { balloon=true, tiny=false, jail=false, rocket=false, ragdoll=false }
local aimbotEnabled=false

local dropPosition = {X = 0.5, Y = 0.5}
local dropAutoOff = true
local DROP_ACTIVE_TIME = 0.85

-- VARIABLES VAMPIRE RESET
_G.VampireResetRemote = nil
_G.VampireResetGuid = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local RESET_COOLDOWN = false
local resetAttempts = 0
local maxResetAttempts = 20

local imageCache = {}
local assetCache = {}
local function getRequestFn()
    return (syn and syn.request) or (http and http.request) or http_request or request
end

local function toWikiName(displayName)
    local clean = (displayName or ""):match("^(.-)%s*%(") or displayName or ""
    return clean:gsub(" ", "_")
end

local function fetchFandomImageUrl(displayName)
    if not displayName or displayName == "" then return nil end
    if imageCache[displayName] ~= nil then
        return imageCache[displayName] ~= false and imageCache[displayName] or nil
    end

    local requestFn = getRequestFn()
    if not requestFn then
        imageCache[displayName] = false
        return nil
    end

    local url = "https://stealabrainrot.fandom.com/wiki/" .. toWikiName(displayName)
    local ok, response = pcall(function()
        return requestFn({
            Url = url,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Mozilla/5.0",
                ["Accept"] = "text/html",
            },
        })
    end)

    if not ok or not response then
        imageCache[displayName] = false
        return nil
    end

    local code = response.StatusCode or response.status or response.Status or 0
    local body = response.Body or response.body or response.Data or ""
    if code ~= 200 or body == "" then
        imageCache[displayName] = false
        return nil
    end

    local ogImage = body:match('property="og:image"%s+content="([^"]+)"')
        or body:match('content="([^"]+)"%s+property="og:image"')
        or body:match('property=%s*"og:image"%s+content=%s*"([^"]+)"')

    if ogImage and ogImage ~= "" then
        ogImage = ogImage:gsub("&amp;", "&")
        if ogImage:find("^https?://") then
            imageCache[displayName] = ogImage
            return ogImage
        end
    end

    local img = body:match('src="(https://static%.wikia%.nocookie%.net[^"]+%.png[^"]*)"')
        or body:match('src="(https://static%.wikia%.nocookie%.net[^"]+%.jpg[^"]*)"')
        or body:match('data%-src="(https://static%.wikia%.nocookie%.net[^"]+)"')

    if img and img ~= "" then
        img = img:gsub("/revision/latest.*", "")
        imageCache[displayName] = img
        return img
    end

    imageCache[displayName] = false
    return nil
end

local function loadImageAsAsset(imageUrl, name)
    if not imageUrl or imageUrl == "" then return "" end
    local safeName = tostring(name or "pet"):gsub("[^%w]", "_"):sub(1, 40)
    local fileName = "br_" .. safeName .. ".png"

    -- cache en memoria
    if assetCache and assetCache[name] and assetCache[name] ~= "" then
        return assetCache[name]
    end

    local okExist, exists = pcall(function()
        return isfile and isfile(fileName)
    end)
    if okExist and exists then
        local ok2, asset = pcall(function() return getcustomasset(fileName) end)
        if ok2 and asset and asset ~= "" then
            if assetCache then assetCache[name] = asset end
            return asset
        end
    end

    local data = nil
    local requestFn = getRequestFn()

    if requestFn then
        local ok, res = pcall(function()
            return requestFn({
                Url = imageUrl,
                Method = "GET",
                Headers = {
                    ["User-Agent"] = "Mozilla/5.0",
                    ["Accept"] = "image/png,image/jpeg,image/*,*/*",
                },
            })
        end)
        if ok and res then
            local code = res.StatusCode or res.status or res.Status or 200
            if code == 200 or code == 0 then
                data = res.Body or res.body or res.Data
            end
        end
    end

    if (not data or #tostring(data) < 200) then
        pcall(function()
            data = game:HttpGet(imageUrl)
        end)
    end

    if not data or #tostring(data) < 200 then return "" end

    -- evitar guardar HTML de error
    local head = tostring(data):sub(1, 50):lower()
    if head:find("<!doctype") or head:find("<html") or head:find("<?xml") then
        return ""
    end

    local okWrite = pcall(function()
        writefile(fileName, data)
    end)
    if not okWrite then return "" end

    local okAsset, asset = pcall(function()
        return getcustomasset(fileName)
    end)
    if okAsset and asset and asset ~= "" then
        if assetCache then assetCache[name] = asset end
        return asset
    end
    return ""
end

local function parseGenNumber(text)
    if not text then return 0 end
    text = tostring(text):gsub(",", ""):gsub("%s", ""):upper()
    local num = text:match("([%d%.]+)")
    if not num then return 0 end
    num = tonumber(num) or 0
    if text:find("T") then return num * 1e12 end
    if text:find("B") then return num * 1e9 end
    if text:find("M") then return num * 1e6 end
    if text:find("K") then return num * 1e3 end
    return num
end

local function getRarityScoreBest(name)
    name = (name or ""):lower()
    if name:find("secret") or name:find("og") or name:find("exclusive") then return 100 end
    if name:find("mythic") or name:find("mitico") then return 80 end
    if name:find("legendary") or name:find("legendario") then return 60 end
    if name:find("epic") or name:find("epico") then return 40 end
    if name:find("rare") or name:find("raro") then return 25 end
    if name:find("uncommon") then return 15 end
    return 5
end

local function getPetValueBest(prompt, podium)
    if not prompt then return "?", 0 end
    local val = prompt:GetAttribute("Value") or prompt:GetAttribute("Price") or prompt:GetAttribute("Cash") or prompt:GetAttribute("Generation")
    if val then
        local s = tostring(val)
        return s, parseGenNumber(s)
    end
    local searchIn = podium
    if not searchIn and prompt.Parent then searchIn = prompt.Parent.Parent end
    if searchIn then
        for _, d in ipairs(searchIn:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = tostring(d.Text or "")
                if t:find("%$") or t:find("/s") or t:find("/S") or t:find("M/s") or t:find("K/s") or t:find("B/s") then
                    return t, parseGenNumber(t)
                end
            end
        end
    end
    return "?", 0
end

local function drawClickDot(x, y)
    if not Drawing then return end
    local dot = Drawing.new("Circle")
    dot.Radius = 5
    dot.Position = Vector2.new(x, y)
    dot.Color = Color3.fromRGB(255, 80, 80)
    dot.Filled = true
    dot.Visible = true
    dot.Transparency = 0.6
    task.delay(0.25, function() dot:Remove() end)
end

local function getNearestPlayer()
    local chr = LocalPlayer and LocalPlayer.Character
    local hrp = chr and chr:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local c = p.Character
            local h = c and c:FindFirstChild("HumanoidRootPart")
            if h then
                local dist = (h.Position - hrp.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = p
                end
            end
        end
    end
    return nearest
end

-- Block Delay: fast (0) / normal (0.50) / slow (1.00) — del script Wins Hub
_G.BlockDelay = _G.BlockDelay or "fast"

local function getBlockDelay()
    if _G.BlockDelay == "normal" then return 0.50
    elseif _G.BlockDelay == "slow" then return 1.00
    else return 0 end -- fast
end

local function PromptClick()
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vp = cam.ViewportSize
    local centerX = vp.X / 2
    local centerY = (vp.Y / 2) + 30
    local vim = VirtualInputManager
    if not vim then
        pcall(function() vim = Instance.new("VirtualInputManager") end)
    end
    if not vim then return end
    for _ = 1, 4 do
        pcall(function()
            vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
            vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
        end)
        task.wait(0.001)
    end
end

local function blockPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == LocalPlayer then return end
    pcall(function()
        task.wait(getBlockDelay())
        StarterGui:SetCore("PromptBlockPlayer", targetPlayer)
        PromptClick()
    end)
end

local function triggerAutoBlock()
    if not _G.AutoBlock then return end
    task.spawn(function()
        local target = getNearestPlayer()
        if target then
            pcall(blockPlayer, target)
        end
    end)
end

local dropEnabled = false
local dropConns = {}
local dropActiveTimer = nil

local dropBusy = false

local function stopDropEffect()
    dropEnabled = false
    for _, dc in ipairs(dropConns) do
        if typeof(dc) == "RBXScriptConnection" then pcall(function() dc:Disconnect() end) end
    end
    dropConns = {}
    if dropActiveTimer then
        pcall(function() task.cancel(dropActiveTimer) end)
        dropActiveTimer = nil
    end
    -- Restaurar personaje YA para poder agarrar brainrot al instante
    pcall(function()
        local ch = LocalPlayer.Character
        if ch then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            local root = ch:FindFirstChild("HumanoidRootPart")
            if hum then
                hum.PlatformStand = false
                hum.Sit = false
                if hum.Health > 0 and hum:GetState() ~= Enum.HumanoidStateType.Freefall then
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                end
            end
            if root then
                root.Anchored = false
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, math.min(root.AssemblyLinearVelocity.Y, 50), root.AssemblyLinearVelocity.Z)
            end
        end
    end)
    if dropBtn then
        dropBtn.BackgroundColor3 = Color3.fromRGB(140,35,35)
        dropBtn.Text = "DROP"
    end
    dropBusy = false
end

local function toggleDrop()
    if dropEnabled then
        stopDropEffect()
        return
    end
    if dropBusy then
        stopDropEffect()
        return
    end
    dropBusy = true
    dropEnabled = true

    local colConn = RunService.Stepped:Connect(function()
        if not dropEnabled then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    table.insert(dropConns, colConn)

    task.spawn(function()
        local endAt = tick() + (DROP_ACTIVE_TIME or 3)
        while dropEnabled and tick() < endAt do
            RunService.Heartbeat:Wait()
            local c = LocalPlayer.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if root and root.Parent then
                    root.Velocity = vel + Vector3.new(0, 0.1, 0)
                end
            else
                RunService.Heartbeat:Wait()
            end
        end
        stopDropEffect()
    end)

    if dropBtn then
        dropBtn.BackgroundColor3 = Color3.fromRGB(60,200,120)
        dropBtn.Text = "DROP ✓"
    end
end

local dropGUI = nil
local dropMain = nil
local dropShadow = nil
local dropBtn = nil
local dropGuiVisible = false

local function createDropGui()
    local existing = PlayerGui:FindFirstChild("DropBrainrotGui")
    if existing then existing:Destroy() end
    local GUI = Instance.new("ScreenGui")
    GUI.Name = "DropBrainrotGui"
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.DisplayOrder = 16
    GUI.Parent = PlayerGui
    dropGUI = GUI
    local Shadow = Instance.new("Frame", GUI)
    Shadow.Size = UDim2.new(0, 96, 0, 48)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(dropPosition.X or 0.5, 0, dropPosition.Y or 0.5, 0)
    Shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    Shadow.BackgroundTransparency = 0.5
    Shadow.BorderSizePixel = 0
    local c = Instance.new("UICorner", Shadow); c.CornerRadius = UDim.new(0, 8)
    dropShadow = Shadow
    local Main = Instance.new("Frame", GUI)
    Main.Size = UDim2.new(0, 88, 0, 40)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(dropPosition.X or 0.5, 0, dropPosition.Y or 0.5, 0)
    Main.BackgroundColor3 = Color3.fromRGB(20,6,6)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    local mc = Instance.new("UICorner", Main); mc.CornerRadius = UDim.new(0, 6)
    local ms = Instance.new("UIStroke", Main); ms.Color = Color3.fromRGB(220,25,45); ms.Thickness = 1.5
    dropMain = Main
    local DropBtn = Instance.new("TextButton", Main)
    DropBtn.Size = UDim2.new(1,-4,1,-4)
    DropBtn.Position = UDim2.new(0,2,0,2)
    DropBtn.BackgroundColor3 = Color3.fromRGB(140,35,35)
    DropBtn.Text = "DROP"
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.TextSize = 12
    DropBtn.TextColor3 = Color3.fromRGB(255,255,255)
    DropBtn.BorderSizePixel = 0
    local dbc = Instance.new("UICorner", DropBtn); dbc.CornerRadius = UDim.new(0, 4)
    dropBtn = DropBtn
    local dragging, dragStart, startPos
    local cam = workspace.CurrentCamera
    DropBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=Main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState==Enum.UserInputState.End then
                    dragging=false
                    dropPosition.X = Main.Position.X.Scale
                    dropPosition.Y = Main.Position.Y.Scale
                    pcall(saveSettings)
                end
            end)
        end
    end)
    Main.InputBegan:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType~=Enum.UserInputType.MouseMovement and inp.UserInputType~=Enum.UserInputType.Touch then return end
        local d = inp.Position - dragStart
        local vx = (cam and cam.ViewportSize.X) or 800
        local vy = (cam and cam.ViewportSize.Y) or 600
        local newX = startPos.X.Scale + d.X / vx
        local newY = startPos.Y.Scale + d.Y / vy
        Main.Position = UDim2.new(newX, 0, newY, 0)
        Shadow.Position = UDim2.new(newX, 0, newY, 0)
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if dragging and (inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch) then
            dragging=false
            dropPosition.X = Main.Position.X.Scale
            dropPosition.Y = Main.Position.Y.Scale
            pcall(saveSettings)
        end
    end)
    DropBtn.MouseButton1Click:Connect(function()
        if not dragging then toggleDrop() end
    end)
end

local function toggleDropGui(desired)
    if desired == nil then
        desired = not _G.DropBrainrotEnabled
    end
    _G.DropBrainrotEnabled = desired
    if _G.DropBrainrotEnabled then
        createDropGui()
        dropGuiVisible = true
    else
        if dropGUI then dropGUI:Destroy(); dropGUI=nil; dropMain=nil; dropShadow=nil; dropBtn=nil end
        dropGuiVisible = false
        if dropEnabled then 
            dropEnabled = false
            for _, c in ipairs(dropConns) do
                if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
            end
            dropConns = {}
        end
    end
    saveSettings()
end

local SETTINGS_FILE = "flash_block_settings.json"
local UI_LAYOUT_FILE = "flash_block_ui_layout.json"
local function loadUILayout()
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(UI_LAYOUT_FILE))
    end)
    if ok and type(data) == "table" then return data end
    return {}
end
local uiLayout = loadUILayout()
local saveUILayoutQueued = false
local function saveUILayout()
    if saveUILayoutQueued then return end
    saveUILayoutQueued = true
    task.delay(0.35, function()
        saveUILayoutQueued = false
        pcall(function()
            writefile(UI_LAYOUT_FILE, game:GetService("HttpService"):JSONEncode(uiLayout))
        end)
    end)
end
local function applySavedPos(frame, key, defaultPos)
    local s = uiLayout[key]
    if s and type(s.sx) == "number" then
        pcall(function()
            frame.Position = UDim2.new(s.sx, s.ox or 0, s.sy, s.oy or 0)
        end)
    elseif defaultPos then
        frame.Position = defaultPos
    end
end
local function persistPos(frame, key)
    uiLayout[key] = {
        sx = frame.Position.X.Scale,
        ox = frame.Position.X.Offset,
        sy = frame.Position.Y.Scale,
        oy = frame.Position.Y.Offset,
    }
    saveUILayout()
end
local function loadSettings()
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(SETTINGS_FILE))
    end)
    if ok and type(data) == "table" then return data end
    return {}
end
local function saveSettings()
    pcall(function()
        if not writefile then return end
        writefile(SETTINGS_FILE, game:GetService("HttpService"):JSONEncode({
            AutoResetOnBalloon = _G.AutoResetOnBalloon,
            AutoGiant = _G.AutoGiant,
            AutoBlock = _G.AutoBlock,
            BlockDelay = _G.BlockDelay,
            APESPEnabled = _G.APESPEnabled,
            BackpackESP = _G.BackpackESP,
            BrainrotHighlight = _G.BrainrotHighlight,
            FPSBoostEnabled = _G.FPSBoostEnabled == true,
            IPESPEnabled = _G.IPESPEnabled == true,
            AutoSelectBrainrot = _G.AutoSelectBrainrot == true,
            AutoSelectBrainrotName = tostring(_G.AutoSelectBrainrotName or ""),
            AutoSelectBrainrotSlot = tonumber(_G.AutoSelectBrainrotSlot) or 0,
            QuickAP = _G.QuickAP,
            Aimbot = aimbotEnabled,
            antiRagdollEnabled = antiRagdollEnabled,
            RagdollBypass = _G.RagdollBypass,
            AntiGummy = _G.antiGummyEnabled,
            DropBrainrotEnabled = _G.DropBrainrotEnabled,
            ESPBaseEnabled = _G.ESPBaseEnabled,
            ESPBestEnabled = _G.ESPBestEnabled,
            LaggerOnFlash = _G.LaggerOnFlash,
            LaggerPower = _G.LaggerPower,
            LaggerBypass = _G.LaggerBypass,
            LaggerVersion = _G.LaggerVersion,
            AutoTurret = _G.AutoTurretEnabled,
            AutoReturnBase = _G.AutoReturnBase,
            FlashSpeed = _G.FlashSpeed,
            TransportIndex = _G.TransportIndex,
            AntiSteal = _G.AntiSteal,
            QuickPickup = _G.QuickPickup,
            AntiStealMode = _G.AntiStealMode,
        AntiStealDelay = _G.AntiStealDelay,
            AntiStealAP = _G.AntiStealAP,
            dropPositionX = dropPosition.X,
            dropPositionY = dropPosition.Y,
            dropAutoOff = dropAutoOff,
        }))
    end)
end
local savedSettings = loadSettings()
if savedSettings.AutoResetOnBalloon ~= nil then _G.AutoResetOnBalloon = savedSettings.AutoResetOnBalloon end
if savedSettings.AutoGiant ~= nil then _G.AutoGiant = savedSettings.AutoGiant end
if savedSettings.AutoBlock ~= nil then _G.AutoBlock = savedSettings.AutoBlock end
if savedSettings.BlockDelay ~= nil then _G.BlockDelay = savedSettings.BlockDelay end
if savedSettings.APESPEnabled ~= nil then _G.APESPEnabled = savedSettings.APESPEnabled end
if savedSettings.Aimbot ~= nil then aimbotEnabled = savedSettings.Aimbot end
if savedSettings.antiRagdollEnabled ~= nil then antiRagdollEnabled = savedSettings.antiRagdollEnabled end
if savedSettings.RagdollBypass ~= nil then _G.RagdollBypass = savedSettings.RagdollBypass end
if savedSettings.ESPBaseEnabled ~= nil then _G.ESPBaseEnabled = savedSettings.ESPBaseEnabled end
if savedSettings.ESPBestEnabled ~= nil then _G.ESPBestEnabled = savedSettings.ESPBestEnabled end
if savedSettings.BackpackESP ~= nil then _G.BackpackESP = savedSettings.BackpackESP end
if savedSettings.BrainrotHighlight ~= nil then _G.BrainrotHighlight = savedSettings.BrainrotHighlight end
if savedSettings.FPSBoostEnabled ~= nil then _G.FPSBoostEnabled = savedSettings.FPSBoostEnabled == true end
if savedSettings.IPESPEnabled ~= nil then _G.IPESPEnabled = savedSettings.IPESPEnabled == true end
if savedSettings.AutoSelectBrainrot ~= nil then _G.AutoSelectBrainrot = savedSettings.AutoSelectBrainrot == true end
if savedSettings.AutoSelectBrainrotName ~= nil then _G.AutoSelectBrainrotName = tostring(savedSettings.AutoSelectBrainrotName) end
if savedSettings.AutoSelectBrainrotSlot ~= nil then _G.AutoSelectBrainrotSlot = tonumber(savedSettings.AutoSelectBrainrotSlot) or 0 end
if savedSettings.QuickAP ~= nil then _G.QuickAP = savedSettings.QuickAP end
if savedSettings.AntiGummy ~= nil then _G.antiGummyEnabled = savedSettings.AntiGummy end
if savedSettings.LaggerOnFlash ~= nil then _G.LaggerOnFlash = savedSettings.LaggerOnFlash end
if savedSettings.LaggerPower ~= nil then _G.LaggerPower = savedSettings.LaggerPower end
if _G.LaggerPower == nil then _G.LaggerPower = 50 end
if savedSettings.LaggerBypass ~= nil then _G.LaggerBypass = savedSettings.LaggerBypass end
if savedSettings.LaggerVersion ~= nil then _G.LaggerVersion = savedSettings.LaggerVersion end
if _G.LaggerVersion ~= "v1" and _G.LaggerVersion ~= "v2" then _G.LaggerVersion = "v1" end
if savedSettings.AutoTurret ~= nil then _G.AutoTurretEnabled = savedSettings.AutoTurret end
if savedSettings.AutoReturnBase ~= nil then _G.AutoReturnBase = savedSettings.AutoReturnBase end
if savedSettings.FlashSpeed ~= nil then _G.FlashSpeed = tonumber(savedSettings.FlashSpeed) or 180 end
if savedSettings.TransportIndex ~= nil then _G.TransportIndex = tonumber(savedSettings.TransportIndex) or 1 end
if savedSettings.AntiSteal ~= nil then _G.AntiSteal = savedSettings.AntiSteal end
    if savedSettings.QuickPickup ~= nil then _G.QuickPickup = savedSettings.QuickPickup end
    if _G.QuickPickup and _G._175_QuickPickup then task.defer(function() _G._175_QuickPickup.set(true) end) end
if savedSettings.AntiStealMode ~= nil then _G.AntiStealMode = savedSettings.AntiStealMode end
    if savedSettings.AntiStealDelay ~= nil then _G.AntiStealDelay = tonumber(savedSettings.AntiStealDelay) or 1.8 end
if type(savedSettings.AntiStealAP) == "table" then
    for k,v in pairs(savedSettings.AntiStealAP) do _G.AntiStealAP[k] = v end
end
if savedSettings.dropPositionX ~= nil then dropPosition.X = savedSettings.dropPositionX end
if savedSettings.dropPositionY ~= nil then dropPosition.Y = savedSettings.dropPositionY end
if savedSettings.dropAutoOff ~= nil then dropAutoOff = savedSettings.dropAutoOff end

if savedSettings.DropBrainrotEnabled ~= nil then
    _G.DropBrainrotEnabled = savedSettings.DropBrainrotEnabled
    if _G.DropBrainrotEnabled then
        task.spawn(function() createDropGui(); dropGuiVisible = true end)
    end
end

local activeHighlights = {}
local activeBillboards = {}

local function removeESP(targetPlayer)
    local char = targetPlayer.Character
    if char then
        local hl = char:FindFirstChild("AdminESP")
        if hl then pcall(function() hl:Destroy() end) end
        local tag = char:FindFirstChild("AdminTag")
        if tag then pcall(function() tag:Destroy() end) end
        local head = char:FindFirstChild("Head")
        if head then
            local t2 = head:FindFirstChild("AdminTag")
            if t2 then pcall(function() t2:Destroy() end) end
        end
    end
    if activeBillboards[targetPlayer] then
        pcall(function() activeBillboards[targetPlayer]:Destroy() end)
    end
    activeHighlights[targetPlayer] = nil
    activeBillboards[targetPlayer] = nil
end

local function createESP(targetPlayer, isAdmin)
    local char = targetPlayer.Character
    if not char or targetPlayer == LocalPlayer then return end
    removeESP(targetPlayer)
    if not isAdmin then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not hrp then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "AdminTag"
    bb.Size = UDim2.new(0, 52, 0, 52)
    bb.StudsOffset = Vector3.new(3.5, 7, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = hrp
    bb.MaxDistance = 200
    bb.Parent = char
    activeBillboards[targetPlayer] = bb
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://95529031547606"
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = bb
end


local function checkPlayerESP(targetPlayer)
    if not _G.APESPEnabled then return end
    if targetPlayer == LocalPlayer then return end
    if targetPlayer.Character then
        local isAdmin = targetPlayer:GetAttribute("AdminCommands") == true
        createESP(targetPlayer, isAdmin)
    else
        removeESP(targetPlayer)
    end
end

local function setupPlayerESP(targetPlayer)
    if targetPlayer == LocalPlayer then return end
    task.wait(0.5)
    checkPlayerESP(targetPlayer)
    targetPlayer.CharacterAdded:Connect(function()
        task.wait(0.5)
        checkPlayerESP(targetPlayer)
    end)
    targetPlayer:GetAttributeChangedSignal("AdminCommands"):Connect(function()
        checkPlayerESP(targetPlayer)
    end)
end

local function enableAPESP()
    for _, p in ipairs(Players:GetPlayers()) do
        setupPlayerESP(p)
    end
    _G.APESPEnabled = true
end

local function disableAPESP()
    _G.APESPEnabled = false
    for _, p in ipairs(Players:GetPlayers()) do
        removeESP(p)
    end
    for k in pairs(activeHighlights) do activeHighlights[k] = nil end
    for k in pairs(activeBillboards) do activeBillboards[k] = nil end
end

Players.ChildAdded:Connect(function(child)
    if child:IsA("Player") then
        task.wait(2)
        if _G.APESPEnabled then setupPlayerESP(child) end
    end
end)

RunService.Heartbeat:Connect(function()
    if _G.APESPEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local currentIsAdmin = p:GetAttribute("AdminCommands") == true
                local hl = activeHighlights[p]
                local existingIsAdmin = hl and (hl.FillColor == Color3.fromRGB(180, 30, 30))
                if currentIsAdmin ~= existingIsAdmin then
                    checkPlayerESP(p)
                end
            end
        end
    end
end)

-- No bloquear el script si aún no hay personaje (para que la GUI siempre cargue)
local Character = LocalPlayer.Character
local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
local Root = Character and Character:FindFirstChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera
if not Character then
    task.spawn(function()
        local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Character = c
        Humanoid = c:WaitForChild("Humanoid", 10)
        Root = c:WaitForChild("HumanoidRootPart", 10)
        Camera = Workspace.CurrentCamera
    end)
end
local autoStealEnabled=false
local stealDelay=0.3
local isStealing=false
local currentMovement=nil
local selectedPrompt=nil
local selectedSlotNumber=nil
local player=LocalPlayer
local maxVelocity=40
local clampVelocity=25
local maxClamp=15

local function connectAntiRagdollToChar(c)
local humanoid=c:WaitForChild("Humanoid")
local root=c:WaitForChild("HumanoidRootPart")
local animator=humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 2)
local lastVelocity = Vector3.zero
local lastClean = 0
local isRag = false

-- Desactivar estados de ragdoll para que el golpe no te tire
pcall(function()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
end)

local function isFlyingToolEquipped()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("carpet") or n:find("fly") or n:find("cloud") or n:find("broom")
                or n:find("jet") or n:find("wing") or n:find("hover") or n:find("glider")
                or n:find("flying") then
                return true
            end
        end
    end
    return false
end

local function fixCamera()
    pcall(function()
        if resetCooldown then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        if cam.CameraType == Enum.CameraType.Scriptable then
            cam.CameraType = Enum.CameraType.Custom
        end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            cam.CameraSubject = hum
        end
    end)
end

local function IsRagdollState()
    local state = humanoid:GetState()
    return state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
        or state == Enum.HumanoidStateType.GettingUp
end

local function CleanRagdollConstraints()
    local now = tick()
    if now - lastClean < 0.05 then return end
    lastClean = now
    pcall(function()
        local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
        end
    end)
    for _, obj in pairs(c:GetDescendants()) do
        if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint") then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B" or tostring(obj.Name):find("Ragdoll")) then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro")
            or obj:IsA("LinearVelocity") and obj.Name:lower():find("rag") then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("Motor6D") then
            obj.Enabled = true
        end
    end
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            local animName = track.Animation and track.Animation.Name:lower() or ""
            if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                pcall(function() track:Stop(0) end)
            end
        end
    end
end

local function ReEnableControls()
    pcall(function()
        local ps = LocalPlayer:FindFirstChild("PlayerScripts")
        local pm = ps and ps:FindFirstChild("PlayerModule")
        if pm then
            local ok, mod = pcall(require, pm)
            if ok and mod and mod.GetControls then
                mod:GetControls():Enable()
            end
        end
    end)
end

local function AdvancedReset()
    if isFlyingToolEquipped() then return end
    root.Anchored = false
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    for _, obj in ipairs(c:GetDescendants()) do
        if obj:IsA("Motor6D") then obj.Enabled = true end
    end
    pcall(function()
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end)
    humanoid.PlatformStand = false
    humanoid.Sit = false
    if humanoid.Health > 0 then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    fixCamera()
    ReEnableControls()
end

local conn1 = humanoid.StateChanged:Connect(function(_, newState)
    if not antiRagdollEnabled then return end
    if isFlyingToolEquipped() then return end
    if IsRagdollState() or newState == Enum.HumanoidStateType.Physics
        or newState == Enum.HumanoidStateType.Ragdoll
        or newState == Enum.HumanoidStateType.FallingDown then
        isRag = true
        CleanRagdollConstraints()
        AdvancedReset()
    else
        isRag = false
        fixCamera()
    end
end)
table.insert(AntiRagdollConns, conn1)
table.insert(ActiveConnections, conn1)

-- Si el server pone PlatformStand=true (típico de ragdoll)
local connPS = humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
    if not antiRagdollEnabled or isFlyingToolEquipped() then return end
    if humanoid.PlatformStand then
        task.defer(function()
            if antiRagdollEnabled then
                AdvancedReset()
                CleanRagdollConstraints()
            end
        end)
    end
end)
table.insert(AntiRagdollConns, connPS)
table.insert(ActiveConnections, connPS)

-- Heartbeat rápido: limpia y te deja mover al instante
local conn2 = RunService.Heartbeat:Connect(function()
    if not antiRagdollEnabled then return end
    if isFlyingToolEquipped() then return end
    local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
    if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
        isRag = true
        pcall(function() LocalPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
    end
    if IsRagdollState() or humanoid.PlatformStand then
        isRag = true
    end
    if isRag then
        CleanRagdollConstraints()
        pcall(function()
            humanoid.PlatformStand = false
            humanoid.Sit = false
            if root and root.Parent then
                root.Anchored = false
                local vel = root.AssemblyLinearVelocity
                -- suaviza el impulso del golpe para no salir volando
                if (vel - lastVelocity).Magnitude > 40 and vel.Magnitude > 25 then
                    root.AssemblyLinearVelocity = vel.Unit * math.min(vel.Magnitude, 18)
                end
                lastVelocity = root.AssemblyLinearVelocity
            end
            if humanoid.Health > 0 and IsRagdollState() then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
        fixCamera()
        ReEnableControls()
        if not IsRagdollState() and not humanoid.PlatformStand then
            isRag = false
        end
    end
end)
table.insert(AntiRagdollConns, conn2)
table.insert(ActiveConnections, conn2)

local conn3 = c.DescendantAdded:Connect(function(obj)
    if not antiRagdollEnabled or isFlyingToolEquipped() then return end
    if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint")
        or obj:IsA("HingeConstraint")
        or (obj:IsA("Attachment") and tostring(obj.Name):find("Ragdoll")) then
        task.defer(function()
            if antiRagdollEnabled and obj.Parent then
                pcall(function() obj:Destroy() end)
            end
        end)
    end
end)
table.insert(AntiRagdollConns, conn3)
table.insert(ActiveConnections, conn3)

-- Limpieza inicial
CleanRagdollConstraints()
AdvancedReset()
end

function startAntiRagdoll()
for _,conn in pairs(AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
AntiRagdollConns={}
task.spawn(function()
    local c=player.Character or player.CharacterAdded:Wait()
    if c then connectAntiRagdollToChar(c) end
end)
end

local function stopAntiRagdoll()
for _,conn in pairs(AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
AntiRagdollConns={}
pcall(function()
    local c = LocalPlayer.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
    end
end)
end

local arCharConn=player.CharacterAdded:Connect(function(newChar)
if not antiRagdollEnabled then return end
for _,conn in pairs(AntiRagdollConns) do pcall(function() conn:Disconnect() end) end
AntiRagdollConns={}
task.spawn(function()
connectAntiRagdollToChar(newChar)
end)
end)
table.insert(ActiveConnections, arCharConn)

local aimbotRemote = nil
local aimbotFireRemote = nil
local aimbotLaserConnection = nil
local aimbotWebConnection = nil
local aimbotBackpackConn = nil
local aimbotRange = 100

local cloneref = cloneref or function(o) return o end
local clonefunction = clonefunction or function(f) return f end
local getconstants = (debug and debug.getconstants) or getconstants

local function getNearestPlayerAimbot(maxRange)
    maxRange = maxRange or aimbotRange
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
    local nearest, shortest = nil, maxRange
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
            local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - myPos).Magnitude
                if dist < shortest then
                    shortest = dist
                    nearest = pl
                end
            end
        end
    end
    return nearest
end

local function useLaserCapeAimbot(targetPart)
    if not targetPart or not aimbotRemote or not aimbotFireRemote then return end
    local args = {targetPart.Position, targetPart}
    pcall(function() aimbotFireRemote(aimbotRemote, unpack(args)) end)
end

local function useWebSlingerAimbot(targetPart)
    if not targetPart or not aimbotRemote or not aimbotFireRemote then return end
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local tool = (bp and bp:FindFirstChild("Web Slinger")) or (char and char:FindFirstChild("Web Slinger"))
    if tool and tool:FindFirstChild("Handle") then
        local args = {
            Vector3.new(targetPart.Position.X, targetPart.Position.Y, targetPart.Position.Z),
            targetPart,
            tool.Handle
        }
        pcall(function() aimbotFireRemote(aimbotRemote, unpack(args)) end)
    end
end

local function setupLaserAimAimbot()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local laserTool = (bp and bp:FindFirstChild("Laser Cape")) or (char and char:FindFirstChild("Laser Cape"))
    if not laserTool then return end
    if aimbotLaserConnection then pcall(function() aimbotLaserConnection:Disconnect() end) end
    aimbotLaserConnection = laserTool.Activated:Connect(function()
        if not aimbotEnabled then return end
        local target = getNearestPlayerAimbot(aimbotRange)
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then useLaserCapeAimbot(targetPart) end
        end
    end)
end

local function setupWebAimAimbot()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local webTool = (bp and bp:FindFirstChild("Web Slinger")) or (char and char:FindFirstChild("Web Slinger"))
    if not webTool then return end
    if aimbotWebConnection then pcall(function() aimbotWebConnection:Disconnect() end) end
    aimbotWebConnection = webTool.Activated:Connect(function()
        if not aimbotEnabled then return end
        local target = getNearestPlayerAimbot(aimbotRange)
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then useWebSlingerAimbot(targetPart) end
        end
    end)
end

local function refrescarAimbot()
    if aimbotEnabled then
        pcall(setupLaserAimAimbot)
        pcall(setupWebAimAimbot)
    else
        if aimbotLaserConnection then pcall(function() aimbotLaserConnection:Disconnect() end); aimbotLaserConnection = nil end
        if aimbotWebConnection then pcall(function() aimbotWebConnection:Disconnect() end); aimbotWebConnection = nil end
    end
end

-- Detección async del remote (John Aimbot style)
task.spawn(function()
    local packages = ReplicatedStorage:WaitForChild("Packages", 30)
    if not packages then return end
    local netFolder = packages:WaitForChild("Net", 30)
    if not netFolder then return end
    while not aimbotRemote and not thisScriptStopped do
        if getconnections and getconstants then
            local found = false
            for _, r in ipairs(netFolder:GetChildren()) do
                if r:IsA("RemoteEvent") then
                    local ok, conns = pcall(getconnections, r.OnClientEvent)
                    if ok and type(conns) == "table" then
                        for _, conn in ipairs(conns) do
                            if conn and type(conn.Function) == "function" then
                                local okc, consts = pcall(getconstants, conn.Function)
                                if okc and type(consts) == "table" then
                                    for _, k in ipairs(consts) do
                                        if k == "PaintballHitted" then
                                            aimbotRemote = cloneref(r)
                                            aimbotFireRemote = clonefunction(aimbotRemote.FireServer)
                                            found = true
                                            break
                                        end
                                    end
                                end
                            end
                            if found then break end
                        end
                    end
                end
                if found then break end
            end
        end
        if aimbotRemote then
            refrescarAimbot()
            break
        end
        task.wait(1)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    refrescarAimbot()
    if char then
        char.ChildAdded:Connect(function()
            task.wait(0.1)
            refrescarAimbot()
        end)
    end
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function()
        task.wait(0.1)
        refrescarAimbot()
    end)
end

if LocalPlayer.Backpack then
    aimbotBackpackConn = LocalPlayer.Backpack.ChildAdded:Connect(function()
        task.wait(0.1)
        refrescarAimbot()
    end)
    table.insert(ActiveConnections, aimbotBackpackConn)
end


-- ===== INSTANT RESET (Funny Hub style) =====
local isResettingFast = false
local CAM_BIND_175 = "175_InstaResetCam"

-- Funny Hub Instant Reset — botón RESET + Reset on Balloon
local FLING_TIME = 0.4
local FLING_POWER = 50000
local USE_VOID = true
local VOID_TIME = 0.6
local RESET_TIMEOUT = 6
local resetting = false
local CAM_BIND_FUNNY = "175_FunnyHubInstaResetCam"

local function hide_locally(obj)
    if obj:IsA("BasePart") or obj:IsA("Decal") then
        obj.LocalTransparencyModifier = 1
    end
end

local function performReset()
    if resetting then return end
    local char = LocalPlayer.Character
    if not char or not char.Parent then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
    resetting = true
    isResettingFast = true

    pcall(function()
        LocalPlayer:SetAttribute("Balloon", false)
        char:SetAttribute("Balloon", false)
    end)

    task.spawn(function()
        local cam = workspace.CurrentCamera
        local frozen = cam and cam.CFrame or CFrame.new()
        local old_type = cam and cam.CameraType or Enum.CameraType.Custom
        pcall(function()
            cam.CameraType = Enum.CameraType.Scriptable
            RunService:BindToRenderStep(CAM_BIND_FUNNY, Enum.RenderPriority.Camera.Value + 1, function()
                if cam then cam.CFrame = frozen end
            end)
        end)

        local added
        pcall(function()
            for _, obj in ipairs(char:GetDescendants()) do pcall(hide_locally, obj) end
            added = char.DescendantAdded:Connect(function(obj) pcall(hide_locally, obj) end)
        end)

        local new_char
        local respawned = LocalPlayer.CharacterAdded:Connect(function(c) new_char = c end)

        local function unlock()
            pcall(function() hum.PlatformStand = false end)
            pcall(function() hum.Sit = false end)
            pcall(function() hum.AutoRotate = true end)
        end
        unlock()
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                pcall(function() obj.Anchored = false end)
                pcall(function() obj.CanCollide = false end)
            elseif obj.Name == "SeatWeld" then
                pcall(function() obj:Destroy() end)
            end
        end

        local started = os.clock()
        local function alive_hrp()
            if hrp and hrp.Parent then return hrp end
            hrp = hum.RootPart or char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Parent then return hrp end
            return nil
        end

        -- Fling held cada frame
        local fling_until = os.clock() + FLING_TIME
        while not new_char and os.clock() < fling_until and hum.Parent do
            unlock()
            pcall(function() hum.HipHeight = 1e30 end)
            local root = alive_hrp()
            if root then
                pcall(function() root.Anchored = false end)
                pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, FLING_POWER, 0) end)
                pcall(function() root.Velocity = Vector3.new(0, FLING_POWER, 0) end)
            end
            RunService.Heartbeat:Wait()
        end

        -- Void held
        if USE_VOID and not new_char then
            local floor = -500
            pcall(function() floor = workspace.FallenPartsDestroyHeight end)
            local void_until = os.clock() + VOID_TIME
            while not new_char and os.clock() < void_until do
                local root = alive_hrp()
                if not root then break end
                pcall(function() root.CFrame = CFrame.new(0, floor - 500, 0) end)
                pcall(function() root.AssemblyLinearVelocity = Vector3.new(0, -FLING_POWER, 0) end)
                RunService.Heartbeat:Wait()
            end
        end

        -- Backstop kill
        while not new_char and os.clock() - started < RESET_TIMEOUT do
            if hum.Parent then
                pcall(function() hum.Health = 0 end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Dead) end)
            end
            if char.Parent then pcall(function() char:BreakJoints() end) end
            task.wait(0.1)
        end

        pcall(function() respawned:Disconnect() end)
        if added then pcall(function() added:Disconnect() end) end
        pcall(function() RunService:UnbindFromRenderStep(CAM_BIND_FUNNY) end)
        pcall(function()
            if cam then
                cam.CameraType = (old_type == Enum.CameraType.Scriptable) and Enum.CameraType.Custom or old_type
                if new_char then
                    local new_hum = new_char:FindFirstChildOfClass("Humanoid")
                        or new_char:WaitForChild("Humanoid", 5)
                    if new_hum then cam.CameraSubject = new_hum end
                end
            end
        end)
        resetting = false
        isResettingFast = false
    end)
end

local function instantReset()
    pcall(performReset)
end

local function doReset()
    pcall(performReset)
end

_G.VampireInstaReset = performReset
_G.ResetPlayer = performReset

local balloonConnection
balloonConnection = LocalPlayer:GetAttributeChangedSignal("Balloon"):Connect(function()
    if thisScriptStopped then 
        pcall(function() balloonConnection:Disconnect() end) 
        return 
    end
    
    if _G.AutoResetOnBalloon == true and LocalPlayer:GetAttribute("Balloon") == true then
        pcall(function()
            LocalPlayer:SetAttribute("Balloon", false)
            local ch = LocalPlayer.Character
            if ch then ch:SetAttribute("Balloon", false) end
        end)
        task.spawn(function() doReset() end)
        if _G.AutoGiant then
            task.spawn(function()
                task.wait(0.25)
                local giant = findTool("giant potion")
                local ch = LocalPlayer.Character
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                if giant and hum then
                    hum:EquipTool(giant)
                    task.wait(0.05)
                    giant:Activate()
                    task.wait(0.05)
                    hum:UnequipTools()
                end
            end)
        end
    end
end)
table.insert(ActiveConnections, balloonConnection)

local function checkDeath()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local deathConn
        deathConn = humanoid.Died:Connect(function()
            if _G.AutoResetOnBalloon then
                task.spawn(function()
                    doReset()
                end)
            end
        end)
        table.insert(ActiveConnections, deathConn)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.3)
    checkDeath()
end)

checkDeath()

LocalPlayer.CharacterAdded:Connect(function(newChar)
    isResettingFast = false
    task.spawn(function()
        local newHum = newChar:WaitForChild("Humanoid", 5)
        local newHrp = newChar:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.05)
        pcall(function()
            LocalPlayer:SetAttribute("Balloon", false)
            newChar:SetAttribute("Balloon", false)
            if newHum then
                newHum.PlatformStand = false
                newHum.Sit = false
                newHum.HipHeight = 2
            end
            if newHrp then
                newHrp.Anchored = false
                newHrp.CanCollide = true
            end
            local cam = workspace.CurrentCamera
            if cam and newHum then
                cam.CameraType = Enum.CameraType.Custom
                cam.CameraSubject = newHum
            end
        end)
    end)
end)

local function firePromptConnections(prompt, signalName)
    if not getconnections then return end
    local connections = getconnections(prompt[signalName])
    for _, conn in ipairs(connections) do
        if conn.Function then task.spawn(conn.Function) end
    end
end

-- Lógica original Kay Hub (la que funcionaba)
local function executeSteal(prompt)
    if isStealing or not prompt or not prompt.Parent then return end
    isStealing = true
    local hold = 0.1
    pcall(function()
        if prompt.HoldDuration and prompt.HoldDuration > 0 then
            hold = math.clamp(prompt.HoldDuration, 0.05, 1.5)
        else
            hold = stealDelay or 0.3
        end
    end)

    -- Metodo 1: fireproximityprompt
    pcall(function()
        if fireproximityprompt then
            fireproximityprompt(prompt, hold)
        end
    end)

    -- Metodo 2: getconnections
    pcall(function()
        firePromptConnections(prompt, "PromptButtonHoldBegan")
    end)
    task.wait(hold)
    pcall(function()
        firePromptConnections(prompt, "PromptButtonHoldEnded")
        firePromptConnections(prompt, "Triggered")
    end)

    -- Metodo 3: reintento fireproximityprompt
    pcall(function()
        if fireproximityprompt and prompt and prompt.Parent and prompt.Enabled then
            fireproximityprompt(prompt)
        end
    end)

    task.wait(0.05)
    isStealing = false
end

local function waitForStealPrompt()
for _,v in ipairs(CoreGui:GetDescendants()) do
if v:IsA("TextLabel") and v.Text and string.find(v.Text,"Steal") then return true end
end
local found=false
local connection
connection=CoreGui.DescendantAdded:Connect(function(v)
if v:IsA("TextLabel") and v.Text and string.find(v.Text,"Steal") then found=true end
end)
table.insert(ActiveConnections, connection)
while not found and not thisScriptStopped do task.wait(0.05) end
if connection then pcall(function() connection:Disconnect() end) end
return true
end

local charAddedConn=LocalPlayer.CharacterAdded:Connect(function(newChar)
if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement=nil end
Character=newChar
Humanoid=newChar:WaitForChild("Humanoid")
Root=newChar:WaitForChild("HumanoidRootPart")
Camera=Workspace.CurrentCamera
autoStealEnabled=false isStealing=false
task.wait()
if Root then
local oldVelocity=Root:FindFirstChild("LinearVelocity")
if oldVelocity then oldVelocity:Destroy() end
local oldAttachment=Root:FindFirstChild("Attachment")
if oldAttachment then oldAttachment:Destroy() end
end
end)
table.insert(ActiveConnections, charAddedConn)

local SlotsConfig={
[1]={Positions={Vector3.new(-345.4766,-6.0291,1.5014)},CamOffset=Vector3.new(-354.1492,4.0350,9.3823)-Vector3.new(-345.4766,-6.0291,1.5014),CamAngles={-0.827500,-0.640100,-0.576243}},
[2]={Positions={Vector3.new(-349.9259,-6.2791,-1.5767)},CamOffset=Vector3.new(-363.2081,2.9403,3.3074)-Vector3.new(-349.9259,-6.2791,-1.5767),CamAngles={-1.007271,-0.967909,-0.916433}},
[3]={Positions={Vector3.new(-349.9259,-6.2791,-1.5758)},CamOffset=Vector3.new(-367.7556,4.3232,3.4983)-Vector3.new(-349.9259,-6.2791,-1.5758),CamAngles={-1.062718,-1.041500,-0.997864}},
[4]={Positions={Vector3.new(-343.4199,-5.9197,10.5505)},CamOffset=Vector3.new(-359.0885,4.0544,21.0001)-Vector3.new(-343.4199,-5.9197,10.5505),CamAngles={-0.681953,-0.861073,-0.551998}},
[5]={Positions={Vector3.new(-343.7608,-6.3272,-9.7994)},CamOffset=Vector3.new(-363.9226,-0.3924,-9.1459)-Vector3.new(-343.7608,-6.3272,-9.7994),CamAngles={-1.424811,-1.351549,-1.421283}},
[6]={
Positions={
Vector3.new(-353.820709,-7.3017997,56.7122993),
Vector3.new(-317.9427,-7.002,60.7723)
},
CamOffset=Vector3.new(-298.584991,3.38974237,49.2246361)-Vector3.new(-300.422119,-7.30179977,34.2573051),
CamAngles={0,0.06,0},
FixedCFrame=CFrame.new(-323.0857,-2.2188,71.682)*CFrame.Angles(0,math.atan2(-0.4114,0.8728),0)
},
[7]={Positions={Vector3.new(-344.4383,-6.4281,41.8672)},CamOffset=Vector3.new(-362.8094,-3.2299,51.1552)-Vector3.new(-344.4383,-6.4281,41.8672),CamAngles={-0.181885,-1.095968,-0.162135}},
[8]={Positions={Vector3.new(-348.5228,-6.4281,48.1022)},CamOffset=Vector3.new(-369.4075,-0.1123,63.3763)-Vector3.new(-348.5228,-6.4281,48.1022),CamAngles={-0.306020,-0.916511,-0.245634}},
[9]={Positions={Vector3.new(-339.6349,-6.4281,60.4164)},CamOffset=Vector3.new(-349.9293,-1.6218,84.4119)-Vector3.new(-339.6349,-6.4281,60.4164),CamAngles={-0.137335,-0.401849,-0.054002}},
[10]={Positions={Vector3.new(-355.3322,-6.4281,25.3526)},CamOffset=Vector3.new(-377.7117,8.9106,25.7208)-Vector3.new(-355.3322,-6.4281,25.3526),CamAngles={-1.544218,-1.016502,-1.539540}},
[11]={Positions={Vector3.new(-354.9932,-6.4281,-47.3879),Vector3.new(-331.5262,-6.4281,-47.3607)},CamOffset=Vector3.new(-333.2372,-9.9613,-64.2099)-Vector3.new(-331.5262,-6.4281,-47.3607),CamAngles={2.851853,-0.097011,3.112724}},
[12]={Positions={Vector3.new(-354.9584,-6.4208,-42.6520),Vector3.new(-338.7290,-6.4281,-43.4713)},CamOffset=Vector3.new(-346.9807,-9.9578,-60.5865)-Vector3.new(-338.7290,-6.4281,-43.4713),CamAngles={2.856299,-0.433315,3.019061}},
[13]={Positions={Vector3.new(-354.8862,-6.2793,-37.9787),Vector3.new(-334.5183,-6.4281,-41.6819)},CamOffset=Vector3.new(-343.9747,-9.9590,-57.3332)-Vector3.new(-334.5183,-6.4281,-41.6819),CamAngles={2.831168,-0.522070,2.982964}},
[14]={Positions={Vector3.new(-351.8463,-6.5022,-37.0529),Vector3.new(-319.8298,-6.4281,-45.1476)},CamOffset=Vector3.new(-325.1408,-9.9618,-60.9837)-Vector3.new(-319.8298,-6.4281,-45.1476),CamAngles={2.834406,-0.309406,3.045298}},
[15]={Positions={Vector3.new(-351.0894,-6.2833,-32.7751),Vector3.new(-317.9170,-6.4281,-41.9999)},CamOffset=Vector3.new(-327.9996,-9.9581,-57.8876)-Vector3.new(-317.9170,-6.4281,-41.9999),CamAngles={2.835549,-0.544183,2.979445}},
[16]={Positions={Vector3.new(-338.2857,-6.4281,57.2060)},CamOffset=Vector3.new(-341.5551,-9.9642,72.3530)-Vector3.new(-338.2857,-6.4281,57.2060),CamAngles={0.320392,-0.202067,0.066497}},
[17]={Positions={Vector3.new(-337.9285,-6.4281,55.1757)},CamOffset=Vector3.new(-344.4950,-9.9637,69.4787)-Vector3.new(-337.9285,-6.4281,55.1757),CamAngles={0.337895,-0.408747,0.138758}},
[18]={Positions={Vector3.new(-332.1088,-6.4281,53.1675)},CamOffset=Vector3.new(-338.8290,-9.9674,65.6692)-Vector3.new(-332.1088,-6.4281,53.1675),CamAngles={0.382481,-0.462609,0.177644}},
[19]={Positions={Vector3.new(-347.9923,-6.2933,-34.0232),Vector3.new(-328.5790,-6.4281,-35.0857)},CamOffset=Vector3.new(-328.6130,-10.0174,-40.4923)-Vector3.new(-328.5790,-6.4281,-35.0857),CamAngles={2.387391,-0.004579,3.137291}},
[20]={Positions={Vector3.new(-355.0801,-6.4404,-33.2302),Vector3.new(-321.5783,-6.4281,-33.5778)},CamOffset=Vector3.new(-321.6123,-10.0174,-38.9844)-Vector3.new(-321.5783,-6.4281,-33.5778),CamAngles={2.387391,-0.004579,3.137291}},
[21]={Positions={Vector3.new(-351.5396,-7.5033,-41.797),Vector3.new(-314.088,-7.5033,-32.1806)},CamOffset=Vector3.new(-314.1147,-10.0174,-36.4214)-Vector3.new(-314.088,-7.5033,-32.1806),CamAngles={2.387391,-0.004579,3.137291},NeedJump=true},
[22]={Positions={Vector3.new(-351.5396,-7.5033,-41.797),Vector3.new(-306.8919,-7.5033,-33.9124)},CamOffset=Vector3.new(-306.923,-10.008,-38.86)-Vector3.new(-306.8919,-7.5033,-33.9124),CamAngles={2.4648,-0.004898,3.137657},NeedJump=true},
[23]={Positions={Vector3.new(-351.5396,-7.5033,-41.797),Vector3.new(-300.2759,-7.5033,-32.7047)},CamOffset=Vector3.new(-300.4669,-10.016,-37.044)-Vector3.new(-300.2759,-7.5033,-32.7047),CamAngles={2.399014,-0.032413,3.111857},NeedJump=true},
[24]={Positions={Vector3.new(-348.2407,-7.5033,74.3719),Vector3.new(-330.0484,-7.5033,48.183)},CamOffset=Vector3.new(-330.1124,-10.0063,53.2779)-Vector3.new(-330.0484,-7.5033,48.183),CamAngles={0.662308,-0.00991,0.007727},NeedJump=true},
[25]={Positions={Vector3.new(-348.2407,-7.5033,74.3719),Vector3.new(-325.4576,-7.5033,46.8182)},CamOffset=Vector3.new(-326.0541,-10.0104,51.5397)-Vector3.new(-325.4576,-7.5033,46.8182),CamAngles={0.700033,-0.09632,0.080833},NeedJump=true},
[26]={Positions={Vector3.new(-348.2407,-7.5033,74.3719),Vector3.new(-324.6721,-7.5033,47.2033)},CamOffset=Vector3.new(-326.6859,-10.0057,51.9385)-Vector3.new(-324.6721,-7.5033,47.2033),CamAngles={0.698024,-0.314979,0.254268},NeedJump=true},
[27]={Positions={Vector3.new(-348.2407,-7.5033,74.3719),Vector3.new(-320.4196,-7.5033,44.1)},CamOffset=Vector3.new(-322.9213,-10.0122,49.5157)-Vector3.new(-320.4196,-7.5033,44.1),CamAngles={0.876985,-0.422603,0.397417}}
}

local function findTool(name)
if not Character then return nil end
for _,tool in ipairs(Character:GetChildren()) do
if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
end
for _,tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
end
return nil
end

-- Transporte volador (lógica Honey Tracker)
local TRANSPORT_OPTIONS = {
    "Flying Carpet",
    "Cupid's Wings",
    "Waverider",
    "Witch's Broom",
    "Santa's Sleigh",
}
_G.TransportIndex = tonumber(_G.TransportIndex) or 1
_G.FlashSpeed = tonumber(_G.FlashSpeed) or 180

local function equipTransport()
    local char = LocalPlayer.Character or Character
    local hum = char and char:FindFirstChildOfClass("Humanoid") or Humanoid
    if not char or not hum then return false end
    local idx = math.clamp(tonumber(_G.TransportIndex) or 1, 1, #TRANSPORT_OPTIONS)
    local selectedName = TRANSPORT_OPTIONS[idx]
    local tool = nil
    local function matchName(n, sel)
        local a, b = string.lower(n or ""), string.lower(sel or "")
        return a:find(b, 1, true) or b:find(a, 1, true)
            or (a:find("carpet") and b:find("carpet"))
            or (a:find("wing") and b:find("wing"))
            or (a:find("broom") and b:find("broom"))
            or (a:find("waverider") and b:find("waverider"))
            or (a:find("sleigh") and b:find("sleigh"))
    end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and matchName(t.Name, selectedName) then tool = t break end
    end
    if not tool then
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and matchName(t.Name, selectedName) then tool = t break end
            end
        end
    end
    -- fallback: cualquier transport conocido
    if not tool then
        for _, nombre in ipairs(TRANSPORT_OPTIONS) do
            tool = findTool(nombre) or findTool((nombre:match("^(%S+)") or nombre))
            if tool then break end
        end
        if not tool then tool = findTool("carpet") or findTool("broom") or findTool("wing") end
    end
    if not tool then return false end
    pcall(function()
        hum:UnequipTools()
        task.wait(0.03)
        hum:EquipTool(tool)
    end)
    task.wait(0.08)
    return tool.Parent == char
end

local function isMyPlot(plot)
if not plot then return false end
local sign=plot:FindFirstChild("PlotSign")
if sign then
local yourBase=sign:FindFirstChild("YourBase")
if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then return true end
end
return false
end

local baseEspInstances = {}
local espBaseConn = nil

local function createBaseESP(plot, mainPart)
    if baseEspInstances[plot.Name] then
        baseEspInstances[plot.Name]:Destroy()
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "rznnq" .. plot.Name
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = mainPart
    billboard.MaxDistance = 1000
    billboard.Parent = plot
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.Arcade
    label.TextColor3 = Color3.fromRGB(255, 40, 40)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Parent = billboard
    baseEspInstances[plot.Name] = billboard
    return billboard
end

local function clearAllBaseESP()
    for name, billboard in pairs(baseEspInstances) do
        if billboard then
            pcall(function() billboard:Destroy() end)
        end
        baseEspInstances[name] = nil
    end
end

-- Solo bases de jugadores reales (no plots vacíos / todos los slots)
local function plotHasPlayerOwner(plot)
    if not plot then return false end
    -- Atributos comunes de ownership
    local ownerAttr = plot:GetAttribute("Owner") or plot:GetAttribute("OwnerName") or plot:GetAttribute("Player")
    if type(ownerAttr) == "string" and ownerAttr ~= "" then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name == ownerAttr or plr.DisplayName == ownerAttr then
                return true
            end
        end
    elseif typeof(ownerAttr) == "Instance" and ownerAttr:IsA("Player") then
        return ownerAttr.Parent ~= nil
    end
    -- PlotSign: busca texto con nombre de jugador
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local texts = {}
        for _, d in ipairs(sign:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextBox") then
                local t = tostring(d.Text or "")
                if t ~= "" and t:lower() ~= "your base" and not t:find("empty") and not t:find("claim") then
                    table.insert(texts, t)
                end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local n, dn = plr.Name, plr.DisplayName
            for _, t in ipairs(texts) do
                if t == n or t == dn or t:find(n, 1, true) or (dn and dn ~= "" and t:find(dn, 1, true)) then
                    return true
                end
            end
        end
    end
    return false
end

local function updateBaseESP()
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return end

    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if isMyPlot(plot) or not plotHasPlayerOwner(plot) then
            -- No ESP en tu base ni en plots vacíos (sin jugador)
            if baseEspInstances[plot.Name] then
                pcall(function() baseEspInstances[plot.Name]:Destroy() end)
                baseEspInstances[plot.Name] = nil
            end
        else
            local purchases = plot:FindFirstChild("Purchases")
            local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
            local mainPart = plotBlock and plotBlock:FindFirstChild("Main")
            local billboard = baseEspInstances[plot.Name]

            local timeLabel = mainPart
                and mainPart:FindFirstChild("BillboardGui")
                and mainPart.BillboardGui:FindFirstChild("RemainingTime")

            if timeLabel and mainPart then
                billboard = billboard or createBaseESP(plot, mainPart)
                local label = billboard:FindFirstChildWhichIsA("TextLabel")
                if label then
                    label.Text = timeLabel.Text
                    label.TextColor3 = Color3.fromRGB(255, 40, 40)
                end
            elseif billboard then
                pcall(function() billboard:Destroy() end)
                baseEspInstances[plot.Name] = nil
            end
        end
    end
end

local function enableESPBase()
    if espBaseConn then return end
    _G.ESPBaseEnabled = true
    espBaseConn = RunService.RenderStepped:Connect(updateBaseESP)
end

local function disableESPBase()
    _G.ESPBaseEnabled = false
    if espBaseConn then
        espBaseConn:Disconnect()
        espBaseConn = nil
    end
    clearAllBaseESP()
end

local function isValidStealPrompt(prompt)
if not prompt or not prompt.Parent or not prompt.Enabled then return false end
local state=prompt:GetAttribute("State")
local actionText=prompt.ActionText
if state=="Steal" or state=="Grab" or actionText=="Steal" or actionText=="Grab" then return true end
return false
end

local STOP_DIST=5
local SLOW_DIST=20

-- ===== FUNCIÓN CORREGIDA startTripToPetSlot =====
local function startTripToPetSlot(prompt, slotNumber)
local config=SlotsConfig[slotNumber] or SlotsConfig[1]
local targetPositions=config.Positions or {config.Position}
local needJump=config.NeedJump==true
if slotNumber>=19 and slotNumber<=27 then needJump=true end
if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement=nil end
if not Root or not Humanoid then return end
autoStealEnabled=true
if type(_G._175_StartFlashLagger)=="function" then
    pcall(_G._175_StartFlashLagger)
end
-- Auto Return Base: vigilar robo durante y un poco después del flash
if _G.AutoReturnBase then
    task.spawn(function()
        local deadline = tick() + 12
        while tick() < deadline and not thisScriptStopped do
            local stealing = false
            pcall(function()
                stealing = LocalPlayer:GetAttribute("Stealing") == true
                    or LocalPlayer:GetAttribute("IsStealing") == true
            end)
            if stealing then
                -- No volver si estás en tu propio plot (agarrando tuyo)
                local onOwn = false
                pcall(function()
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not root then return end
                    local plots = Workspace:FindFirstChild("Plots")
                    if plots then
                        for _, plot in ipairs(plots:GetChildren()) do
                            local sign = plot:FindFirstChild("PlotSign")
                            local yb = sign and sign:FindFirstChild("YourBase")
                            if yb and yb.Enabled then
                                local ok, piv = pcall(function() return plot:GetPivot().Position end)
                                if ok and piv and (root.Position - piv).Magnitude < 90 then
                                    onOwn = true
                                end
                            end
                        end
                    end
                end)
                if onOwn then
                    -- ignorar: es brainrot propio
                else
                    if currentMovement then
                        pcall(function() currentMovement:Disconnect() end)
                        currentMovement = nil
                    end
                    autoStealEnabled = false
                    if type(_G._175_StartReturnBase)=="function" then
                        pcall(_G._175_StartReturnBase)
                    end
                    return
                end
            end
            task.wait(0.05)
        end
    end)
end
local Speed=tonumber(_G.FlashSpeed) or 180
if Speed < 20 then Speed = 20 end
if Speed > 500 then Speed = 500 end
local grabStartDistance=70
local grabStarted=false
pcall(equipTransport)
if Root:FindFirstChild("LinearVelocity") then Root.LinearVelocity:Destroy() end
if Root:FindFirstChild("Attachment") then Root.Attachment:Destroy() end
local Attachment=Instance.new("Attachment")
Attachment.Parent=Root
local Velocity=Instance.new("LinearVelocity")
Velocity.Attachment0=Attachment
Velocity.RelativeTo=Enum.ActuatorRelativeTo.World
Velocity.MaxForce=math.huge
Velocity.Parent=Root
local currentPosIndex=1
local intermediatePauseActive=false
currentMovement=RunService.Heartbeat:Connect(function()
if thisScriptStopped then
if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement=nil end
return
end
if not Root or not Humanoid or not Root.Parent or Humanoid.Health<=0 then
if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement=nil end
return
end
if intermediatePauseActive then Velocity.VectorVelocity=Vector3.zero return end
local TargetPosition=targetPositions[currentPosIndex]
if not TargetPosition then return end
local rootPos=Root.Position
local dir=Vector3.new(TargetPosition.X-rootPos.X,0,TargetPosition.Z-rootPos.Z)
local dist=dir.Magnitude
-- Auto grab Kay Hub: distancia a la posición FINAL
local finalPosition = targetPositions[#targetPositions]
local finalDist = Vector3.new(finalPosition.X - rootPos.X, 0, finalPosition.Z - rootPos.Z).Magnitude
if finalDist <= grabStartDistance and not grabStarted then
    grabStarted = true
    task.spawn(function()
        -- varios intentos de grab mientras se acerca / llega
        for i = 1, 10 do
            if thisScriptStopped or not prompt or not prompt.Parent then break end
            if not isStealing then
                executeSteal(prompt)
            end
            task.wait(0.4)
        end
    end)
end
local speedMult=1
if dist<SLOW_DIST then speedMult=math.max(0.15,dist/SLOW_DIST) end
if dist<=STOP_DIST then
if currentPosIndex<#targetPositions then
intermediatePauseActive=true
Velocity.VectorVelocity=Vector3.zero
Root.AssemblyLinearVelocity=Vector3.zero
task.spawn(function()
currentPosIndex=currentPosIndex+1
intermediatePauseActive=false
end)
return
end
Velocity.VectorVelocity=Vector3.zero
Root.AssemblyLinearVelocity=Vector3.zero
Velocity:Destroy()
Attachment:Destroy()
Root.CFrame=CFrame.new(TargetPosition)
if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement=nil end
task.wait(0.1)
Camera.CameraType=Enum.CameraType.Scriptable
if config.FixedCFrame then
Camera.CFrame=config.FixedCFrame
else
Camera.CFrame=CFrame.new(Root.Position+config.CamOffset)*CFrame.Angles(unpack(config.CamAngles))
end
Humanoid:UnequipTools()
task.wait(0.05)
if needJump then
Root.AssemblyLinearVelocity=Vector3.new(0,55,0)
task.wait(0.06)
end
local flash=findTool("flash")
if flash then
Humanoid:EquipTool(flash)
task.wait(0.06)
flash:Activate()
if slotNumber==6 then
pcall(function()
workspace.CurrentCamera.CFrame=CFrame.new(-299.38,-3.06,29.14,0.914,-0.035,0.405,0,0.996,0.086,-0.407,-0.078,0.910)
end)
end
end
task.wait(0.08)
if _G.AutoGiant then
local giant=findTool("giant potion")
if giant then
Humanoid:EquipTool(giant) task.wait(0.08) giant:Activate()
-- Bypass Ragdoll: primero toma la potion, después tira ragdoll
if _G.RagdollBypass then
task.spawn(function()
task.wait(0.35)
pcall(function()
local tb=PlayerGui:FindFirstChild("AdminPanel")
tb=tb and tb:FindFirstChild("AdminPanel")
tb=tb and tb:FindFirstChild("CommandBox")
tb=tb and tb:FindFirstChild("TextBox")
if tb then
local ov=tb.Visible
tb.Visible=false
tb.Text=";ragdoll "..LocalPlayer.Name
task.wait(0.04)
if firesignal then pcall(firesignal,tb.FocusLost,true)
elseif getconnections then
for _,c in pairs(getconnections(tb.FocusLost)) do pcall(function() c:Fire(true) end) end
end
task.wait(0.04)
tb.Text=""
tb.Visible=ov
end
end)
end)
end
task.wait(0.05) Humanoid:UnequipTools()
end
end
Camera.CameraType=Enum.CameraType.Custom
if _G.AutoBlock then
task.spawn(function()
task.wait(0.15)
triggerAutoBlock()
end)
end
task.spawn(function() task.wait(1.0) autoStealEnabled=false end)
return
end
Velocity.VectorVelocity=Vector3.new(dir.Unit.X*Speed*speedMult,0,dir.Unit.Z*Speed*speedMult)
end)
table.insert(ActiveConnections, currentMovement)
end

local scrollListRef=nil
local livePetPrompts = {} -- rowKey -> {prompt, slot, name} (siempre fresco)

-- assetCache ya declarado arriba

local function updatePetList()
if thisScriptStopped then return end
if not scrollListRef then return end

local plotsFolder=Workspace:FindFirstChild("Plots")
if not plotsFolder then return end
local tempPets={}
for _,plot in ipairs(plotsFolder:GetChildren()) do
if not isMyPlot(plot) then
local podiums=plot:FindFirstChild("AnimalPodiums")
if podiums then
for _,podium in ipairs(podiums:GetChildren()) do
local slotNumber=tonumber(podium.Name:match("%d+")) or 1
local base=podium:FindFirstChild("Base") or podium
local spawnPoint=base:FindFirstChild("Spawn")
local attachment=spawnPoint and spawnPoint:FindFirstChild("PromptAttachment")
if attachment then
for _,child in ipairs(attachment:GetChildren()) do
if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
local petName=child.ObjectText or "Pet"
petName=tostring(petName):gsub("%s*%[.-%]%s*",""):gsub("^%s+",""):gsub("%s+$","")
local spawnPos=nil
pcall(function()
if attachment:IsA("Attachment") then spawnPos=attachment.WorldPosition
elseif spawnPoint and spawnPoint:IsA("BasePart") then spawnPos=spawnPoint.Position end
end)
table.insert(tempPets,{prompt=child,slot=slotNumber,name=petName,plot=plot,podium=podium,spawnPos=spawnPos})
end
end
end
end
end
end
end
table.sort(tempPets,function(a,b) return a.slot<b.slot end)

-- Mapa fresco de prompts (para clicks y auto-select)
livePetPrompts = {}
for _,petData in ipairs(tempPets) do
    local rk = tostring(petData.slot) .. "_" .. tostring(petData.name)
    livePetPrompts[rk] = petData
end

-- Auto Select Brainrot: re-selecciona por nombre cuando el jugador vuelve
if _G.AutoSelectBrainrot and type(_G.AutoSelectBrainrotName)=="string" and _G.AutoSelectBrainrotName ~= "" then
    local wantName = tostring(_G.AutoSelectBrainrotName):lower():gsub("^%s+",""):gsub("%s+$","")
    local wantSlot = tonumber(_G.AutoSelectBrainrotSlot) or 0
    local matchPrompt, matchSlot = nil, nil
    for _, petData in ipairs(tempPets) do
        local n = tostring(petData.name or ""):lower()
        if n == wantName or (wantName ~= "" and (n:find(wantName, 1, true) or wantName:find(n, 1, true))) then
            if wantSlot > 0 and petData.slot == wantSlot then
                matchPrompt = petData.prompt
                matchSlot = petData.slot
                break
            elseif not matchPrompt then
                matchPrompt = petData.prompt
                matchSlot = petData.slot
            end
        end
    end
    if matchPrompt then
        local stillOk = selectedPrompt and selectedPrompt.Parent and selectedPrompt == matchPrompt
        if not stillOk then
            selectedPrompt = matchPrompt
            selectedSlotNumber = matchSlot
        end
    end
elseif selectedPrompt and not selectedPrompt.Parent then
    -- prompt viejo inválido
    selectedPrompt = nil
end

local C_list={
card=Color3.fromRGB(40,14,14),
accent=Color3.fromRGB(220,25,45),
stroke=Color3.fromRGB(100,30,30),
bright=Color3.fromRGB(255,255,255),
mute=Color3.fromRGB(170,80,80)
}

-- Reutilizar filas existentes para que el giro 3D nunca se reinicie
local wanted = {}
for _,petData in ipairs(tempPets) do
    wanted[tostring(petData.slot) .. "_" .. tostring(petData.name)] = petData
end

-- Quitar solo las que ya no existen
for _,child in ipairs(scrollListRef:GetChildren()) do
    if child:IsA("Frame") then
        if child.Name == "EmptyCard" then
            child:Destroy()
        elseif not wanted[child.Name] then
            child:Destroy()
        end
    end
end

if #tempPets == 0 then
    return
end

for i,petData in ipairs(tempPets) do
    if thisScriptStopped then break end
    local rowKey = tostring(petData.slot) .. "_" .. tostring(petData.name)
    local isSelected = (selectedPrompt == petData.prompt)
    local existing = scrollListRef:FindFirstChild(rowKey)

    if existing then
        -- Solo actualizar selección (el Viewport sigue girando en bucle)
        existing.BackgroundColor3 = isSelected and Color3.fromRGB(80,10,10) or C_list.card
        local st = existing:FindFirstChildOfClass("UIStroke")
        if st then
            st.Color = isSelected and C_list.accent or C_list.stroke
            st.Thickness = isSelected and 1.5 or 1
        end
        existing.LayoutOrder = i
        existing:SetAttribute("SlotNum", petData.slot)
        existing:SetAttribute("PetName", petData.name)
        -- Rehacer botón de click con prompt fresco (evita prompt muerto)
        for _, ch in ipairs(existing:GetChildren()) do
            if ch:IsA("TextButton") and ch.Text == "" and ch.BackgroundTransparency == 1 then
                ch:Destroy()
            end
        end
        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.BorderSizePixel = 0
        clickBtn.ZIndex = 10
        clickBtn.Parent = existing
        local rk = rowKey
        clickBtn.MouseButton1Click:Connect(function()
            local data = livePetPrompts[rk]
            if not data or not data.prompt or not data.prompt.Parent then return end
            selectedPrompt = data.prompt
            selectedSlotNumber = data.slot
            pcall(function() if type(_G._175_UpdatePreview) == "function" then _G._175_UpdatePreview(data.name, data.slot) end end)
            if _G.AutoSelectBrainrot then
                _G.AutoSelectBrainrotName = tostring(data.name or "")
                _G.AutoSelectBrainrotSlot = tonumber(data.slot) or 0
                pcall(function() saveSettings() end)
            end
            updatePetList()
        end)
    else
        -- Crear fila nueva + viewport 3D con giro infinito
        local row = Instance.new("Frame")
        row.Name = rowKey
        row.Size = UDim2.new(1, -6, 0, 70)
        row.BackgroundColor3 = isSelected and Color3.fromRGB(80,10,10) or C_list.card
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        row.Parent = scrollListRef
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
        local rStroke = Instance.new("UIStroke")
        rStroke.Color = isSelected and C_list.accent or C_list.stroke
        rStroke.Thickness = isSelected and 1.5 or 1
        rStroke.Parent = row

        local VP_SIZE = 58
        local vp = Instance.new("ViewportFrame")
        vp.Size = UDim2.new(0, VP_SIZE, 0, VP_SIZE)
        vp.Position = UDim2.new(0, 4, 0.5, -VP_SIZE / 2)
        vp.BackgroundTransparency = 1
        vp.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        vp.BorderSizePixel = 0
        vp.ZIndex = 5
        vp.Parent = row

        local vpCam = Instance.new("Camera")
        vpCam.Parent = vp
        vp.CurrentCamera = vpCam

        local petNameCopy = petData.name
        local spawnPosCopy = petData.spawnPos
        local plotCopy = petData.plot
        task.spawn(function()
            -- Busca el modelo EN ESE PODIUM (no el de tu base / otra mutación)
            local playerNames = {}
            for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end
            local foundModel = nil
            local bestDist = 10
            local searchRoot = plotCopy
            if not searchRoot or not searchRoot.Parent then
                searchRoot = Workspace:FindFirstChild("Plots")
            end
            if not searchRoot then return end
            for _, v in ipairs(searchRoot:GetDescendants()) do
                if v:IsA("Model") and not playerNames[v.Name] then
                    local sameName = (v.Name == petNameCopy)
                        or (tostring(v.Name):lower():find(tostring(petNameCopy):lower(), 1, true))
                    if sameName then
                        local rp = v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChildWhichIsA("BasePart")
                        if rp and spawnPosCopy then
                            local d = (rp.Position - spawnPosCopy).Magnitude
                            if d < bestDist then
                                bestDist = d
                                foundModel = v
                            end
                        elseif not spawnPosCopy and not foundModel and sameName then
                            foundModel = v
                        end
                    end
                end
            end
            if not foundModel or not vp.Parent then return end

            local clone = foundModel:Clone()
            for _, d in ipairs(clone:GetDescendants()) do
                if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Highlight") then
                    d:Destroy()
                end
            end
            clone.Parent = vp

            local cf, size = clone:GetBoundingBox()
            local centerPos = cf.Position
            local dist = math.max(size.Magnitude * 1.3, 2.2)
            local height = size.Y * 0.12

            pcall(function()
                for _, part in ipairs(clone:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                        part.CFrame = part.CFrame - centerPos
                    end
                end
                local pivot = Instance.new("Part")
                pivot.Name = "_VPPivot"
                pivot.Size = Vector3.new(0.05, 0.05, 0.05)
                pivot.Transparency = 1
                pivot.Anchored = true
                pivot.CanCollide = false
                pivot.CanQuery = false
                pivot.CanTouch = false
                pivot.CFrame = CFrame.new()
                pivot.Parent = clone
                clone.PrimaryPart = pivot
            end)

            vpCam.CFrame = CFrame.new(Vector3.new(0, height, dist), Vector3.new(0, 0, 0))

            local angle = 0
            local rotConn
            rotConn = RunService.Heartbeat:Connect(function(dt)
                if not vp.Parent then
                    if rotConn then rotConn:Disconnect() end
                    return
                end
                -- Bucle infinito de giro (círculo completo siempre)
                angle = (angle + dt * 80) % 360
                if clone and clone.Parent and clone.PrimaryPart then
                    pcall(function()
                        clone:PivotTo(CFrame.Angles(0, math.rad(angle), 0))
                    end)
                end
            end)
            table.insert(ActiveConnections, rotConn)
        end)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = petData.name
        nameLabel.Size = UDim2.new(1, -(VP_SIZE + 12), 0, 28)
        nameLabel.Position = UDim2.new(0, VP_SIZE + 8, 0, 10)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = C_list.bright
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center
        nameLabel.TextWrapped = true
        nameLabel.TextTruncate = Enum.TextTruncate.None
        nameLabel.Parent = row

        local slotLabel = Instance.new("TextLabel")
        slotLabel.Text = "Slot " .. tostring(petData.slot)
        slotLabel.Size = UDim2.new(1, -(VP_SIZE + 12), 0, 16)
        slotLabel.Position = UDim2.new(0, VP_SIZE + 8, 0, 40)
        slotLabel.BackgroundTransparency = 1
        slotLabel.TextColor3 = C_list.accent or Color3.fromRGB(255, 90, 100)
        slotLabel.Font = Enum.Font.GothamBold
        slotLabel.TextSize = 11
        slotLabel.TextXAlignment = Enum.TextXAlignment.Left
        slotLabel.Parent = row

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.BorderSizePixel = 0
        clickBtn.ZIndex = 10
        clickBtn.Parent = row

        local rk = rowKey
        local rowBtnConn = clickBtn.MouseButton1Click:Connect(function()
            local data = livePetPrompts[rk]
            if not data or not data.prompt or not data.prompt.Parent then return end
            selectedPrompt = data.prompt
            selectedSlotNumber = data.slot
            pcall(function() if type(_G._175_UpdatePreview) == "function" then _G._175_UpdatePreview(data.name, data.slot) end end)
            if _G.AutoSelectBrainrot then
                _G.AutoSelectBrainrotName = tostring(data.name or "")
                _G.AutoSelectBrainrotSlot = tonumber(data.slot) or 0
                pcall(function() saveSettings() end)
            end
            updatePetList()
        end)
        table.insert(ActiveConnections, rowBtnConn)
    end
end
end


-- GUI en función aparte para no pasar el límite de 200 locals del chunk principal
local function __build175GUI()

local old=PlayerGui:FindFirstChild("FlashBlock")
if old then old:Destroy() end
local oldB=PlayerGui:FindFirstChild("HugoHubBanner") or PlayerGui:FindFirstChild("DnkPvpBanner")
if oldB then oldB:Destroy() end

local C={
accent=Color3.fromRGB(220,25,45),
accentHi=Color3.fromRGB(255,60,80),
deepRed=Color3.fromRGB(60,10,10),
body=Color3.fromRGB(18,8,8),
panel=Color3.fromRGB(24,12,12),
tabBar=Color3.fromRGB(20,9,9),
card=Color3.fromRGB(40,14,14),
iconBg=Color3.fromRGB(55,14,14),
stroke=Color3.fromRGB(100,30,30),
strokeDim=Color3.fromRGB(65,20,20),
textBright=Color3.fromRGB(255,220,220),
textRed=Color3.fromRGB(255,100,100),
textMute=Color3.fromRGB(170,80,80),
textDim=Color3.fromRGB(130,50,50),
knobOn=Color3.fromRGB(255,200,200),
knobOff=Color3.fromRGB(110,60,60),
trackOff=Color3.fromRGB(50,18,18)
}

local borderGradientSeq=ColorSequence.new({
ColorSequenceKeypoint.new(0,C.accentHi),
ColorSequenceKeypoint.new(0.25,C.deepRed),
ColorSequenceKeypoint.new(0.5,C.accent),
ColorSequenceKeypoint.new(0.75,C.deepRed),
ColorSequenceKeypoint.new(1,C.accentHi)
})

local function getDevice()
local screen=workspace.CurrentCamera.ViewportSize
local w,h=screen.X,screen.Y
local isMobile=UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
if isMobile then
if w>=900 or h>=900 then return "ipad" end
return "mobile"
end
return "pc"
end

local DEVICE=getDevice()
-- Barra compacta: solo header + FLASH/BLOCK/RESET (Settings=B, Brainrots=S en floats)
local LAYOUT={
pc={winW=230,winH=100,posX=UDim2.new(0.5,0,0.5,0),bannerW=190,bannerH=52,bannerPos=UDim2.new(0.5,-95,0,6),btnSize=68,btnH=28,tabH=28,headerH=34,actionXs={6,80,154},textSize={header=10,btn=11,tab=11}},
ipad={winW=210,winH=94,posX=UDim2.new(0.5,0,0.5,0),bannerW=170,bannerH=48,bannerPos=UDim2.new(0.5,-85,0,6),btnSize=62,btnH=26,tabH=26,headerH=32,actionXs={5,72,139},textSize={header=10,btn=10,tab=10}},
mobile={winW=185,winH=88,posX=UDim2.new(0.5,0,0.5,0),bannerW=155,bannerH=46,bannerPos=UDim2.new(0.5,-78,0,4),btnSize=54,btnH=24,tabH=24,headerH=28,actionXs={4,64,124},textSize={header=9,btn=9,tab=9}}
}
local L=LAYOUT[DEVICE]

local HUGO_SCRIPT_GUI=Instance.new("ScreenGui")
HUGO_SCRIPT_GUI.Name="FlashBlock"
HUGO_SCRIPT_GUI.SelectionGroup=false
HUGO_SCRIPT_GUI.ResetOnSpawn=false
HUGO_SCRIPT_GUI.DisplayOrder=999999
HUGO_SCRIPT_GUI.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
HUGO_SCRIPT_GUI.IgnoreGuiInset=true
pcall(function()
    if syn and syn.protect_gui then syn.protect_gui(HUGO_SCRIPT_GUI) end
end)
do
    local parented = false
    pcall(function()
        if gethui then
            HUGO_SCRIPT_GUI.Parent = gethui()
            parented = true
        end
    end)
    if not parented then
        pcall(function()
            HUGO_SCRIPT_GUI.Parent = CoreGui
            parented = HUGO_SCRIPT_GUI.Parent ~= nil
        end)
    end
    if not parented then
        HUGO_SCRIPT_GUI.Parent = PlayerGui
    end
end


local BorderFrame=Instance.new("Frame")
BorderFrame.Name="BorderFrame"
BorderFrame.SelectionGroup=false
BorderFrame.Size=UDim2.new(0,L.winW+4,0,L.winH+4)
BorderFrame.Position=L.posX
BorderFrame.AnchorPoint=Vector2.new(0.5,0.5)
BorderFrame.BackgroundColor3=C.accent
BorderFrame.BorderSizePixel=0
BorderFrame.ClipsDescendants=true
BorderFrame.Active=false
BorderFrame.Selectable=false
BorderFrame.Parent=HUGO_SCRIPT_GUI

local BorderCorner=Instance.new("UICorner")
BorderCorner.CornerRadius=UDim.new(0,11)
BorderCorner.Parent=BorderFrame

local UIGradient=Instance.new("UIGradient")
UIGradient.Color=borderGradientSeq
UIGradient.Rotation=308.077
UIGradient.Parent=BorderFrame

local Win=Instance.new("Frame")
Win.Name="Win"
Win.SelectionGroup=false
Win.Size=UDim2.new(0,L.winW,0,L.winH)
Win.Position=L.posX
Win.AnchorPoint=Vector2.new(0.5,0.5)
Win.BackgroundTransparency=1
Win.BorderSizePixel=0
Win.ZIndex=2
Win.ClipsDescendants=true
Win.Active=false
Win.Selectable=false
Win.Parent=HUGO_SCRIPT_GUI
applySavedPos(Win, "MainWin", L.posX)
BorderFrame.Position = Win.Position
BorderFrame.Size = UDim2.new(0, L.winW + 4, 0, L.winH + 4)

local Frame=Instance.new("Frame")
Frame.Name="Frame"
Frame.SelectionGroup=false
Frame.Size=UDim2.new(1,0,1,0)
Frame.BackgroundColor3=C.body
Frame.BackgroundTransparency=0.15
Frame.BorderSizePixel=0
Frame.ClipsDescendants=true
Frame.Active=false
Frame.Selectable=false
Frame.Parent=Win
Instance.new("UICorner",Frame).CornerRadius=UDim.new(0,11)

-- Fondo VTRX Vs en toda la GUI
do
    local VTRX_BGS = {
        "rbxassetid://93596272337297",
        "rbxassetid://138569542128921",
        "rbxassetid://133247950444776",
    }
    local bgImg = Instance.new("ImageLabel")
    bgImg.Name = "VTRXBg"
    bgImg.Size = UDim2.fromScale(1, 1)
    bgImg.BackgroundTransparency = 1
    bgImg.Image = VTRX_BGS[1]
    bgImg.ImageTransparency = 0.25
    bgImg.ScaleType = Enum.ScaleType.Crop
    bgImg.ZIndex = 0
    bgImg.Parent = Frame
    Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 11)
    local overlay = Instance.new("Frame")
    overlay.Name = "VTRXOverlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 0
    overlay.Parent = Frame
    Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 11)
    local redTint = Instance.new("Frame")
    redTint.Name = "VTRXRedTint"
    redTint.Size = UDim2.fromScale(1, 1)
    redTint.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    redTint.BackgroundTransparency = 0.75
    redTint.BorderSizePixel = 0
    redTint.ZIndex = 0
    redTint.Parent = Frame
    Instance.new("UICorner", redTint).CornerRadius = UDim.new(0, 11)
end

local Frame2=Instance.new("Frame")
Frame2.Name="Frame"
Frame2.Size=UDim2.new(1,0,0,0)
Frame2.Position=UDim2.new(0,0,0,84)
Frame2.BackgroundColor3=C.panel
Frame2.BorderSizePixel=0
Frame2.ClipsDescendants=true
Frame2.Visible=false
Frame2.Parent=Frame
Instance.new("UICorner",Frame2).CornerRadius=UDim.new(0,13)

local Frame3=Instance.new("Frame")
Frame3.Name="Frame"
Frame3.Size=UDim2.new(1,0,0,L.headerH)
Frame3.Position=UDim2.new(0,0,0,0)
Frame3.BackgroundTransparency=1
Frame3.BorderSizePixel=0
Frame3.ZIndex=3
Frame3.ClipsDescendants=false
Frame3.Active=false
Frame3.Selectable=false
Frame3.Parent=Frame

local Frame4=Instance.new("Frame")
Frame4.Size=UDim2.new(1,0,0,1)
Frame4.Position=UDim2.new(0,0,1,-1)
Frame4.BackgroundColor3=C.stroke
Frame4.BorderSizePixel=0
Frame4.ZIndex=4
Frame4.Parent=Frame3

local Frame5=Instance.new("Frame")
Frame5.Size=UDim2.new(0,5,0,5)
Frame5.Position=UDim2.new(0,8,0.5,-2.5)
Frame5.BackgroundColor3=C.accent
Frame5.BorderSizePixel=0
Frame5.ZIndex=5
Frame5.Parent=Frame3
Instance.new("UICorner",Frame5).CornerRadius=UDim.new(0,3)

local TextLabel=Instance.new("TextLabel")
TextLabel.Size=UDim2.new(1,-130,1,0)
TextLabel.Position=UDim2.new(0,16,0,0)
TextLabel.BackgroundTransparency=1
TextLabel.ZIndex=5
TextLabel.Text="FLASH BLOCK"
TextLabel.TextColor3=C.textBright
TextLabel.TextSize=11
TextLabel.Font=Enum.Font.GothamBold
TextLabel.TextXAlignment=Enum.TextXAlignment.Left
TextLabel.TextTruncate=Enum.TextTruncate.AtEnd
TextLabel.Parent=Frame3

local HB=DEVICE=="mobile" and 18 or 20

local function headerButton(name,txt,xOff)
local b=Instance.new("TextButton")
b.Name=name
b.Size=UDim2.new(0,HB,0,HB)
b.Position=UDim2.new(1,xOff,0.5,-HB/2)
b.BackgroundColor3=C.card
b.BorderSizePixel=0
b.ZIndex=6
b.Text=txt
b.TextColor3=C.textMute
b.TextSize=9
b.Font=Enum.Font.GothamBold
b.AutoButtonColor=false
b.Parent=Frame3
Instance.new("UICorner",b).CornerRadius=UDim.new(0,4)
local s=Instance.new("UIStroke"); s.Color=C.stroke; s.Parent=b
return b
end

local hbOff=DEVICE=="mobile" and {-118,-98,-78,-58,-38,-18} or {-130,-108,-86,-64,-42,-20}
local RecoverHdrBtn=headerButton("RecoverR","R",hbOff[1])
local BrainrotsHdrBtn=headerButton("BrainrotsB","B",hbOff[2])
local SettingsHdrBtn=headerButton("SettingsS","S",hbOff[3])
local LockBtn=headerButton("Lock","🔓",hbOff[4])
local MinBtn=headerButton("Min","–",hbOff[5])
local CloseBtn=headerButton("Close","X",hbOff[6])

local Frame7=Instance.new("Frame")
Frame7.Size=UDim2.new(1,0,0,62)
Frame7.Position=UDim2.new(0,0,0,32)
Frame7.BackgroundTransparency=1
Frame7.BorderSizePixel=0
Frame7.ZIndex=4
Frame7.Parent=Frame

local Frame8=Instance.new("Frame")
Frame8.Size=UDim2.new(1,0,0,1)
Frame8.Position=UDim2.new(0,0,0,50)
Frame8.BackgroundColor3=C.stroke
Frame8.BorderSizePixel=0
Frame8.ZIndex=4
Frame8.Parent=Frame7

local function actionButton(name,label,xPos,bW)
local btn=Instance.new("TextButton")
btn.Name=name
btn.Size=UDim2.new(0,bW,0,L.btnH)
btn.Position=UDim2.new(0,xPos,0,6)
btn.BackgroundColor3=C.card
btn.BorderSizePixel=0
btn.ZIndex=5
btn.Text=""
btn.AutoButtonColor=false
btn.Parent=Frame7
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
local s=Instance.new("UIStroke"); s.Color=C.stroke; s.Parent=btn
local top=Instance.new("Frame")
top.Size=UDim2.new(1,-8,0,1.5)
top.Position=UDim2.new(0,4,0,0)
top.BackgroundColor3=C.stroke
top.BorderSizePixel=0
top.ZIndex=6
top.Parent=btn
Instance.new("UICorner",top).CornerRadius=UDim.new(0,1)
local lbl=Instance.new("TextLabel")
lbl.Size=UDim2.new(1,0,1,0)
lbl.BackgroundTransparency=1
lbl.ZIndex=7
lbl.Text=label
lbl.TextColor3=C.textBright
lbl.TextSize=L.textSize.btn
lbl.Font=Enum.Font.GothamBold
lbl.Parent=btn
return btn,top
end

local FLASHTP,flashAccent=actionButton("FLASH TP","FLASH",L.actionXs[1],L.btnSize)
local BLOCK,blockAccent=actionButton("BLOCK","BLOCK",L.actionXs[2],L.btnSize)
local RESET,resetAccent=actionButton("RESET","RESET",L.actionXs[3],L.btnSize)

local Frame12=Instance.new("Frame")
Frame12.Size=UDim2.new(1,0,0,L.tabH)
Frame12.Position=UDim2.new(0,0,0,84)
Frame12.BackgroundColor3=C.tabBar
Frame12.BorderSizePixel=0
Frame12.ZIndex=5
Frame12.Visible=false
Frame12.Parent=Frame

local UIListLayout=Instance.new("UIListLayout")
UIListLayout.SortOrder=Enum.SortOrder.LayoutOrder
UIListLayout.FillDirection=Enum.FillDirection.Horizontal
UIListLayout.VerticalAlignment=Enum.VerticalAlignment.Center
UIListLayout.Parent=Frame12

local TextButton4=Instance.new("TextButton")
TextButton4.Size=UDim2.new(1,0,1,0)
TextButton4.BackgroundColor3=C.tabBar
TextButton4.BorderSizePixel=0
TextButton4.ZIndex=5
TextButton4.LayoutOrder=1
TextButton4.Text=""
TextButton4.AutoButtonColor=false
TextButton4.Parent=Frame12

local TextLabel7=Instance.new("TextLabel")
TextLabel7.Size=UDim2.new(1,0,1,0)
TextLabel7.BackgroundTransparency=1
TextLabel7.ZIndex=6
TextLabel7.Text="Brainrots"
TextLabel7.TextColor3=C.textRed
TextLabel7.TextSize=L.textSize.tab
TextLabel7.Font=Enum.Font.GothamMedium
TextLabel7.Parent=TextButton4

local Frame13=Instance.new("Frame")
Frame13.Size=UDim2.new(1,-14,0,1.5)
Frame13.Position=UDim2.new(0,7,1,-1.5)
Frame13.BackgroundColor3=C.accent
Frame13.BorderSizePixel=0
Frame13.ZIndex=7
Frame13.Parent=TextButton4
Instance.new("UICorner",Frame13).CornerRadius=UDim.new(0,1)

local TextButton5=Instance.new("TextButton")
TextButton5.Size=UDim2.new(0.5,0,1,0)
TextButton5.BackgroundColor3=C.tabBar
TextButton5.BorderSizePixel=0
TextButton5.ZIndex=5
TextButton5.LayoutOrder=2
TextButton5.Text=""
TextButton5.AutoButtonColor=false
TextButton5.Visible=false
TextButton5.Parent=Frame12

local TextLabel8=Instance.new("TextLabel")
TextLabel8.Size=UDim2.new(1,0,1,0)
TextLabel8.BackgroundTransparency=1
TextLabel8.ZIndex=6
TextLabel8.Text="Settings"
TextLabel8.TextColor3=C.textDim
TextLabel8.TextSize=L.textSize.tab
TextLabel8.Font=Enum.Font.GothamMedium
TextLabel8.Parent=TextButton5

local Frame14=Instance.new("Frame")
Frame14.Size=UDim2.new(1,-14,0,1.5)
Frame14.Position=UDim2.new(0,7,1,-1.5)
Frame14.BackgroundColor3=C.accent
Frame14.BackgroundTransparency=1
Frame14.BorderSizePixel=0
Frame14.ZIndex=7
Frame14.Parent=TextButton5
Instance.new("UICorner",Frame14).CornerRadius=UDim.new(0,1)

local Frame15=Instance.new("Frame")
Frame15.Size=UDim2.new(1,0,0,1)
Frame15.Position=UDim2.new(0,0,0,113)
Frame15.BackgroundColor3=C.stroke
Frame15.BorderSizePixel=0
Frame15.ZIndex=6
Frame15.Visible=false
Frame15.Parent=Frame

local Frame16=Instance.new("Frame")
Frame16.Size=UDim2.new(1,0,1,-118)
Frame16.Position=UDim2.new(0,0,0,114)
Frame16.BackgroundTransparency=1
Frame16.BorderSizePixel=0
Frame16.ZIndex=2
Frame16.ClipsDescendants=true
Frame16.Visible=false
Frame16.Parent=Frame

local Frame17=Instance.new("Frame")
Frame17.Name="Frame"
Frame17.Size=UDim2.new(1,0,1,0)
Frame17.BackgroundTransparency=1
Frame17.BorderSizePixel=0
Frame17.ZIndex=3
Frame17.Parent=Frame16

local ScrollingFrame=Instance.new("ScrollingFrame")
ScrollingFrame.Name="ScrollingFrame"
ScrollingFrame.Size=UDim2.new(1,0,1,0)
ScrollingFrame.BackgroundTransparency=1
ScrollingFrame.BorderSizePixel=0
ScrollingFrame.Active=false
ScrollingFrame.CanvasSize=UDim2.new(0,0,0,0)
ScrollingFrame.ScrollBarThickness=3
ScrollingFrame.ScrollBarImageColor3=C.accent
ScrollingFrame.ScrollingDirection=Enum.ScrollingDirection.Y
ScrollingFrame.AutomaticCanvasSize=Enum.AutomaticSize.Y
ScrollingFrame.Parent=Frame17

local UIListLayout2=Instance.new("UIListLayout")
UIListLayout2.SortOrder=Enum.SortOrder.LayoutOrder
UIListLayout2.HorizontalAlignment=Enum.HorizontalAlignment.Center
UIListLayout2.Padding=UDim.new(0,4)
UIListLayout2.Parent=ScrollingFrame

local UIPaddingList=Instance.new("UIPadding")
UIPaddingList.PaddingTop=UDim.new(0,6)
UIPaddingList.PaddingBottom=UDim.new(0,6)
UIPaddingList.PaddingLeft=UDim.new(0,4)
UIPaddingList.PaddingRight=UDim.new(0,4)
UIPaddingList.Parent=ScrollingFrame

scrollListRef=ScrollingFrame

local Frame21=Instance.new("Frame")
Frame21.Name="Frame"
Frame21.Size=UDim2.new(1,0,1,0)
Frame21.Position=UDim2.new(1,0,0,0)
Frame21.BackgroundTransparency=1
Frame21.BorderSizePixel=0
Frame21.Visible=false
Frame21.ZIndex=3
Frame21.Parent=Frame16

local ScrollingFrame2=Instance.new("ScrollingFrame")
ScrollingFrame2.Size=UDim2.new(1,0,1,0)
ScrollingFrame2.BackgroundTransparency=1
ScrollingFrame2.BorderSizePixel=0
ScrollingFrame2.CanvasSize=UDim2.new(0,0,0,0)
ScrollingFrame2.ScrollBarThickness=3
ScrollingFrame2.ScrollBarImageColor3=C.accent
ScrollingFrame2.ScrollingDirection=Enum.ScrollingDirection.Y
ScrollingFrame2.AutomaticCanvasSize=Enum.AutomaticSize.Y
ScrollingFrame2.Parent=Frame21

local UIListLayout3=Instance.new("UIListLayout")
UIListLayout3.SortOrder=Enum.SortOrder.LayoutOrder
UIListLayout3.HorizontalAlignment=Enum.HorizontalAlignment.Center
UIListLayout3.Padding=UDim.new(0,2)
UIListLayout3.Parent=ScrollingFrame2

local UIPadding=Instance.new("UIPadding")
UIPadding.PaddingTop=UDim.new(0,3)
UIPadding.PaddingBottom=UDim.new(0,3)
UIPadding.PaddingLeft=UDim.new(0,6)
UIPadding.PaddingRight=UDim.new(0,6)
UIPadding.Parent=ScrollingFrame2

local sectionOrder=0
local toggleRefs={}

local function sectionHeader(text)
sectionOrder=sectionOrder+1
local wrap=Instance.new("Frame")
wrap.Size=UDim2.new(1,0,0,20)
wrap.BackgroundTransparency=1
wrap.BorderSizePixel=0
wrap.ZIndex=4
wrap.LayoutOrder=sectionOrder
wrap.Parent=ScrollingFrame2
local line=Instance.new("Frame")
line.Size=UDim2.new(1,0,0,1)
line.Position=UDim2.new(0,0,0.5,0)
line.BackgroundColor3=C.stroke
line.BorderSizePixel=0
line.ZIndex=5
line.Parent=wrap
local pill=Instance.new("Frame")
pill.Size=UDim2.new(0,0,1,0)
pill.Position=UDim2.new(0.5,0,0,0)
pill.AnchorPoint=Vector2.new(0.5,0)
pill.BackgroundColor3=C.panel
pill.BorderSizePixel=0
pill.ZIndex=6
pill.AutomaticSize=Enum.AutomaticSize.X
pill.Parent=wrap
local lbl=Instance.new("TextLabel")
lbl.Size=UDim2.new(1,0,1,0)
lbl.BackgroundTransparency=1
lbl.ZIndex=7
lbl.Text=text
lbl.TextColor3=C.textMute
lbl.TextSize=9
lbl.Font=Enum.Font.GothamBold
lbl.Parent=pill
return wrap
end

local function toggleRow(title,desc,defaultOn,onToggle)
sectionOrder=sectionOrder+1
local row=Instance.new("Frame")
row.Size=UDim2.new(1,0,0,44)
row.BackgroundColor3=C.card
row.BorderSizePixel=0
row.ZIndex=4
row.LayoutOrder=sectionOrder
row.Parent=ScrollingFrame2
Instance.new("UICorner",row)
local s=Instance.new("UIStroke"); s.Color=C.stroke; s.Parent=row
local accentBar=Instance.new("Frame")
accentBar.Size=UDim2.new(0,2.5,1,-8)
accentBar.Position=UDim2.new(0,0,0,4)
accentBar.BackgroundColor3=C.accent
accentBar.BorderSizePixel=0
accentBar.ZIndex=5
accentBar.Parent=row
Instance.new("UICorner",accentBar).CornerRadius=UDim.new(0,2)

local t1=Instance.new("TextLabel")
t1.Size=UDim2.new(1,-46,0,20)
t1.Position=UDim2.new(0,10,0,0)
t1.BackgroundTransparency=1
t1.ZIndex=5
t1.Text=title
t1.TextColor3=C.textBright
t1.TextSize=12
t1.Font=Enum.Font.GothamMedium
t1.TextXAlignment=Enum.TextXAlignment.Left
t1.Parent=row

local t2=Instance.new("TextLabel")
t2.Size=UDim2.new(1,-46,0,16)
t2.Position=UDim2.new(0,10,0,18)
t2.BackgroundTransparency=1
t2.ZIndex=5
t2.Text=desc
t2.TextColor3=C.textMute
t2.TextSize=10
t2.Font=Enum.Font.Gotham
t2.TextWrapped=true
t2.TextXAlignment=Enum.TextXAlignment.Left
t2.Parent=row

local track=Instance.new("Frame")
track.Size=UDim2.new(0,30,0,16)
track.Position=UDim2.new(1,-36,0.5,-8)
track.BackgroundColor3=C.accent
track.BorderSizePixel=0
track.ZIndex=6
track.Parent=row
Instance.new("UICorner",track).CornerRadius=UDim.new(0,8)
local ts=Instance.new("UIStroke"); ts.Color=C.accent; ts.Parent=track
local knob=Instance.new("Frame")
knob.Size=UDim2.new(0,12,0,12)
knob.Position=UDim2.new(0,16,0.5,-6)
knob.BackgroundColor3=C.knobOn
knob.BorderSizePixel=0
knob.ZIndex=7
knob.Parent=track
Instance.new("UICorner",knob).CornerRadius=UDim.new(0,6)

local hit=Instance.new("TextButton")
hit.Size=UDim2.new(1,0,1,0)
hit.BackgroundTransparency=1
hit.ZIndex=8
hit.Text=""
hit.Parent=row

local ref={on=defaultOn~=false,track=track,stroke=ts,knob=knob, toggleName=title}

local function render(animate)
local info=TweenInfo.new(animate and 0.16 or 0,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
if ref.on then
TweenService:Create(track,info,{BackgroundColor3=C.accent}):Play()
TweenService:Create(ts,info,{Color=C.accent}):Play()
TweenService:Create(knob,info,{Position=UDim2.new(0,16,0.5,-6),BackgroundColor3=C.knobOn}):Play()
else
TweenService:Create(track,info,{BackgroundColor3=C.trackOff}):Play()
TweenService:Create(ts,info,{Color=C.stroke}):Play()
TweenService:Create(knob,info,{Position=UDim2.new(0,2,0.5,-6),BackgroundColor3=C.knobOff}):Play()
end
end
ref.render = render
render(false)

hit.MouseButton1Click:Connect(function()
    ref.on=not ref.on
    render(true)
    if onToggle then pcall(onToggle,ref.on) end
    saveSettings()
end)

table.insert(toggleRefs,ref)
return row,ref
end

toggleRow("Reset On Balloon","Reset quand tu es ballonné",_G.AutoResetOnBalloon,function(v) 
    _G.AutoResetOnBalloon=v
    saveSettings()
end)

toggleRow("Auto Block","Block auto le plus proche",_G.AutoBlock,function(v) 
    _G.AutoBlock=v
    saveSettings()
end)
-- Block Delay: FAST / NORMAL / SLOW (justo debajo de Auto Block, bonito)
do
    sectionOrder = sectionOrder + 1
    local bdContainer = Instance.new("Frame")
    bdContainer.Size = UDim2.new(1, 0, 0, 58)
    bdContainer.BackgroundColor3 = C.card
    bdContainer.BorderSizePixel = 0
    bdContainer.ZIndex = 4
    bdContainer.LayoutOrder = sectionOrder
    bdContainer.Parent = ScrollingFrame2
    Instance.new("UICorner", bdContainer).CornerRadius = UDim.new(0, 8)
    local bds = Instance.new("UIStroke")
    bds.Color = C.stroke
    bds.Thickness = 1
    bds.Parent = bdContainer

    local bdLeftBar = Instance.new("Frame")
    bdLeftBar.Size = UDim2.new(0, 3, 1, -10)
    bdLeftBar.Position = UDim2.new(0, 0, 0, 5)
    bdLeftBar.BackgroundColor3 = C.accent
    bdLeftBar.BorderSizePixel = 0
    bdLeftBar.ZIndex = 5
    bdLeftBar.Parent = bdContainer
    Instance.new("UICorner", bdLeftBar).CornerRadius = UDim.new(0, 3)

    local bdLabel = Instance.new("TextLabel")
    bdLabel.Size = UDim2.new(1, -14, 0, 16)
    bdLabel.Position = UDim2.new(0, 10, 0, 4)
    bdLabel.BackgroundTransparency = 1
    bdLabel.Text = "Block Speed"
    bdLabel.TextColor3 = C.textBright
    bdLabel.TextSize = 11
    bdLabel.Font = Enum.Font.GothamBold
    bdLabel.TextXAlignment = Enum.TextXAlignment.Left
    bdLabel.ZIndex = 5
    bdLabel.Parent = bdContainer

    local btnRow = Instance.new("Frame")
    btnRow.Size = UDim2.new(1, -14, 0, 24)
    btnRow.Position = UDim2.new(0, 7, 0, 24)
    btnRow.BackgroundTransparency = 1
    btnRow.ZIndex = 5
    btnRow.Parent = bdContainer

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    btnLayout.Padding = UDim.new(0, 3)
    btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
    btnLayout.Parent = btnRow

    local delayBtns = {}
    local function refreshDelayBtns()
        for key, b in pairs(delayBtns) do
            local on = (_G.BlockDelay == key)
            b.BackgroundColor3 = on and C.accent or Color3.fromRGB(35, 12, 12)
            b.TextColor3 = on and Color3.fromRGB(255, 255, 255) or C.textMute
            local st = b:FindFirstChildOfClass("UIStroke")
            if st then st.Color = on and C.accentHi or C.strokeDim end
        end
    end

    local function makeDelayBtn(text, key, order)
        local btn = Instance.new("TextButton")
        btn.Name = "Delay_" .. key
        btn.Size = UDim2.new(0, 42, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = C.textMute
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.LayoutOrder = order
        btn.ZIndex = 6
        btn.Parent = btnRow
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke")
        st.Color = C.strokeDim
        st.Thickness = 1
        st.Parent = btn
        btn.MouseButton1Click:Connect(function()
            _G.BlockDelay = key
            saveSettings()
            refreshDelayBtns()
        end)
        delayBtns[key] = btn
        return btn
    end
    makeDelayBtn("FAST", "fast", 1)
    makeDelayBtn("NORMAL", "normal", 2)
    makeDelayBtn("SLOW", "slow", 3)
    refreshDelayBtns()
end
toggleRow("Auto Giant","Giant potion après flash",_G.AutoGiant,function(v) 
    _G.AutoGiant=v
    saveSettings()
end)
-- Transporte arriba + Speed Carpet abajo (1 card compacta)
do
    sectionOrder = sectionOrder + 1
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 52)
    box.BackgroundColor3 = C.card
    box.BorderSizePixel = 0
    box.LayoutOrder = sectionOrder
    box.Parent = ScrollingFrame2
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke"); st.Color = C.stroke; st.Parent = box
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, -8)
    bar.Position = UDim2.new(0, 0, 0, 4)
    bar.BackgroundColor3 = C.accent
    bar.BorderSizePixel = 0
    bar.Parent = box
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 3)

    -- Arriba: < nombre >
    local leftA = Instance.new("TextButton")
    leftA.Size = UDim2.new(0, 20, 0, 20)
    leftA.Position = UDim2.new(0, 8, 0, 3)
    leftA.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
    leftA.Text = "<"
    leftA.TextColor3 = C.textBright
    leftA.Font = Enum.Font.GothamBold
    leftA.TextSize = 11
    leftA.BorderSizePixel = 0
    leftA.Parent = box
    Instance.new("UICorner", leftA).CornerRadius = UDim.new(0, 4)

    local rightA = Instance.new("TextButton")
    rightA.Size = UDim2.new(0, 20, 0, 20)
    rightA.Position = UDim2.new(1, -28, 0, 3)
    rightA.BackgroundColor3 = Color3.fromRGB(35, 12, 12)
    rightA.Text = ">"
    rightA.TextColor3 = C.textBright
    rightA.Font = Enum.Font.GothamBold
    rightA.TextSize = 11
    rightA.BorderSizePixel = 0
    rightA.Parent = box
    Instance.new("UICorner", rightA).CornerRadius = UDim.new(0, 4)

    local trName = Instance.new("TextLabel")
    trName.Size = UDim2.new(1, -56, 0, 20)
    trName.Position = UDim2.new(0, 28, 0, 3)
    trName.BackgroundTransparency = 1
    trName.Text = TRANSPORT_OPTIONS[math.clamp(tonumber(_G.TransportIndex) or 1, 1, #TRANSPORT_OPTIONS)] or "Flying Carpet"
    trName.TextColor3 = C.textBright
    trName.TextSize = 10
    trName.Font = Enum.Font.GothamBold
    trName.TextXAlignment = Enum.TextXAlignment.Center
    trName.TextTruncate = Enum.TextTruncate.AtEnd
    trName.Parent = box

    -- Abajo: Speed Carpet | [valor]
    local spdLbl = Instance.new("TextLabel")
    spdLbl.Size = UDim2.new(0, 78, 0, 20)
    spdLbl.Position = UDim2.new(0, 8, 0, 27)
    spdLbl.BackgroundTransparency = 1
    spdLbl.Text = "Speed Carpet"
    spdLbl.TextColor3 = C.textMute
    spdLbl.TextSize = 10
    spdLbl.Font = Enum.Font.GothamMedium
    spdLbl.TextXAlignment = Enum.TextXAlignment.Left
    spdLbl.Parent = box

    local spdBox = Instance.new("TextBox")
    spdBox.Size = UDim2.new(1, -94, 0, 20)
    spdBox.Position = UDim2.new(0, 86, 0, 27)
    spdBox.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    spdBox.Text = tostring(_G.FlashSpeed or 180)
    spdBox.TextColor3 = C.textBright
    spdBox.PlaceholderText = "180"
    spdBox.PlaceholderColor3 = C.textMute
    spdBox.Font = Enum.Font.GothamBold
    spdBox.TextSize = 11
    spdBox.ClearTextOnFocus = false
    spdBox.BorderSizePixel = 0
    spdBox.Parent = box
    Instance.new("UICorner", spdBox).CornerRadius = UDim.new(0, 4)

    local function applySpeed()
        local v = tonumber(spdBox.Text)
        if v and v > 0 then
            _G.FlashSpeed = math.clamp(v, 20, 500)
            spdBox.Text = tostring(_G.FlashSpeed)
            saveSettings()
        else
            spdBox.Text = tostring(_G.FlashSpeed or 180)
        end
    end
    spdBox.FocusLost:Connect(applySpeed)

    local function refreshTransport()
        local i = math.clamp(tonumber(_G.TransportIndex) or 1, 1, #TRANSPORT_OPTIONS)
        _G.TransportIndex = i
        trName.Text = TRANSPORT_OPTIONS[i]
        saveSettings()
    end
    leftA.MouseButton1Click:Connect(function()
        local i = (tonumber(_G.TransportIndex) or 1) - 1
        if i < 1 then i = #TRANSPORT_OPTIONS end
        _G.TransportIndex = i
        refreshTransport()
    end)
    rightA.MouseButton1Click:Connect(function()
        local i = (tonumber(_G.TransportIndex) or 1) + 1
        if i > #TRANSPORT_OPTIONS then i = 1 end
        _G.TransportIndex = i
        refreshTransport()
    end)
end
toggleRow("Auto Return Base","Vuelve a base al robar",_G.AutoReturnBase==true,function(v)
    _G.AutoReturnBase=v
    if not v and type(_G._175_StopReturnBase)=="function" then pcall(_G._175_StopReturnBase) end
    saveSettings()
end)
toggleRow("Anti Ragdoll","No te tira ragdoll al golpearte",antiRagdollEnabled,function(v)
    antiRagdollEnabled=v
    if v then startAntiRagdoll() else stopAntiRagdoll() end
    saveSettings()
end)
toggleRow("Bypass Ragdoll","Te tira ragdoll (tecnica flash/giant)",_G.RagdollBypass,function(v)
    _G.RagdollBypass = v and true or false
    saveSettings()
end)

toggleRow("AP ESP","Tag les joueurs avec AP (En Rojo)",_G.APESPEnabled,function(v)
    if v then enableAPESP() else disableAPESP() end
    saveSettings()
end)
toggleRow("FPS Boost","Stretch + Anti Lag + Nuke optimiser",_G.FPSBoostEnabled==true,function(v)
    _G.FPSBoostEnabled = v
    pcall(function()
        if _G.AceFPSBoost then
            if v then _G.AceFPSBoost.EnableAll() else _G.AceFPSBoost.DisableAll() end
        end
    end)
    saveSettings()
end)
toggleRow("IP","Linea ESP + avatar en la cabeza",_G.IPESPEnabled==true,function(v)
    _G.IPESPEnabled = v
    pcall(function()
        if _G._175_SetIPESP then _G._175_SetIPESP(v) end
    end)
    saveSettings()
end)
toggleRow("Backpack ESP","Muestra Flash/Giant/Carpet del jugador",_G.BackpackESP,function(v)
    _G.BackpackESP = v
    if type(_G._175_SetBackpackESP)=="function" then _G._175_SetBackpackESP(v) end
    saveSettings()
end)
toggleRow("Brainrot Highlight","Highlight amarillo en brainrots",_G.BrainrotHighlight,function(v)
    _G.BrainrotHighlight = v
    if type(_G._175_SetBrainrotHL)=="function" then _G._175_SetBrainrotHL(v) end
    saveSettings()
end)
toggleRow("Auto Select Brainrot","Re-selecciona al volver el jugador",_G.AutoSelectBrainrot==true,function(v)
    _G.AutoSelectBrainrot = v
    if v and selectedPrompt then
        pcall(function()
            _G.AutoSelectBrainrotName = tostring(selectedPrompt.ObjectText or _G.AutoSelectBrainrotName or "")
            _G.AutoSelectBrainrotName = _G.AutoSelectBrainrotName:gsub("%s*%[.-%]%s*",""):gsub("^%s+",""):gsub("%s+$","")
            _G.AutoSelectBrainrotSlot = tonumber(selectedSlotNumber) or 0
        end)
    end
    saveSettings()
end)
toggleRow("Quick AP","GUI roja admin rapido (arrastrable)",_G.QuickAP,function(v)
    _G.QuickAP = v
    if type(_G._175_SetQuickAP)=="function" then _G._175_SetQuickAP(v) end
    saveSettings()
end)
toggleRow("Aimbot","Auto aim avec Laser Cape et Web Slinger",aimbotEnabled,function(v)
    aimbotEnabled=v
    refrescarAimbot()
    saveSettings()
end)
toggleRow("DROP BRAINROT","Activa Drop Brainrot (GUI)",_G.DropBrainrotEnabled,function(v)
    toggleDropGui(v)
    saveSettings()
end)
toggleRow("ESP Base","Muestra timer de bases del servidor",_G.ESPBaseEnabled,function(v)
    if v then enableESPBase() else disableESPBase() end
    saveSettings()
end)
toggleRow("Lagger on Flash TP","Bypass Anti Base Protector (Lagger)",_G.LaggerOnFlash,function(v)
    _G.LaggerOnFlash = v
    if not v and type(_G._175_StopFlashLagger)=="function" then pcall(_G._175_StopFlashLagger) end
    saveSettings()
end)

toggleRow("Lagger Bypass","ON con Flash en mano, OFF al usarlo",_G.LaggerBypass,function(v)
    _G.LaggerBypass = v
    if not v and type(_G._175_StopLagger)=="function" then pcall(_G._175_StopLagger) end
    saveSettings()
end)

-- Bypass Lagger V1 / V2
do
    sectionOrder = sectionOrder + 1
    local lagVerRow = Instance.new("Frame")
    lagVerRow.Size = UDim2.new(1, 0, 0, 36)
    lagVerRow.BackgroundColor3 = C.card
    lagVerRow.BorderSizePixel = 0
    lagVerRow.ZIndex = 4
    lagVerRow.LayoutOrder = sectionOrder
    lagVerRow.Parent = ScrollingFrame2
    Instance.new("UICorner", lagVerRow)
    local lvs = Instance.new("UIStroke"); lvs.Color = C.stroke; lvs.Parent = lagVerRow

    local function makeVerBtn(text, ver, xScale)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.46, 0, 0, 26)
        b.Position = UDim2.new(xScale, 4, 0.5, -13)
        b.BackgroundColor3 = (_G.LaggerVersion == ver) and C.accent or Color3.fromRGB(40, 14, 14)
        b.BorderSizePixel = 0
        b.ZIndex = 6
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 10
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.Parent = lagVerRow
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end
    local v1Btn = makeVerBtn("Bypass Lagger V1", "v1", 0.02)
    local v2Btn = makeVerBtn("Bypass Lagger V2", "v2", 0.52)
    local function refreshVer()
        v1Btn.BackgroundColor3 = (_G.LaggerVersion == "v1") and C.accent or Color3.fromRGB(40, 14, 14)
        v2Btn.BackgroundColor3 = (_G.LaggerVersion == "v2") and C.accent or Color3.fromRGB(40, 14, 14)
    end
    v1Btn.MouseButton1Click:Connect(function()
        _G.LaggerVersion = "v1"
        refreshVer()
        if _G._175_LaggerPowerRow then _G._175_LaggerPowerRow.Visible = true end
        saveSettings()
    end)
    v2Btn.MouseButton1Click:Connect(function()
        _G.LaggerVersion = "v2"
        refreshVer()
        if _G._175_LaggerPowerRow then _G._175_LaggerPowerRow.Visible = false end
        saveSettings()
    end)
end

-- Slider Lagger Power (solo V1 / Flash — V2 no usa barra)
do
    sectionOrder = sectionOrder + 1
    local lagRow = Instance.new("Frame")
    lagRow.Name = "LaggerPowerRow"
    lagRow.Size = UDim2.new(1, 0, 0, 52)
    lagRow.BackgroundColor3 = C.card
    lagRow.BorderSizePixel = 0
    lagRow.ZIndex = 4
    lagRow.LayoutOrder = sectionOrder
    lagRow.Visible = (_G.LaggerVersion ~= "v2")
    lagRow.Parent = ScrollingFrame2
    Instance.new("UICorner", lagRow)
    local ls = Instance.new("UIStroke"); ls.Color = C.stroke; ls.Parent = lagRow
    _G._175_LaggerPowerRow = lagRow

    local lagTitle = Instance.new("TextLabel")
    lagTitle.Size = UDim2.new(1, -16, 0, 16)
    lagTitle.Position = UDim2.new(0, 10, 0, 4)
    lagTitle.BackgroundTransparency = 1
    lagTitle.ZIndex = 5
    lagTitle.Text = "LAGGER POWER (V1 / Flash)"
    lagTitle.TextColor3 = C.textMute
    lagTitle.Font = Enum.Font.GothamBold
    lagTitle.TextSize = 10
    lagTitle.TextXAlignment = Enum.TextXAlignment.Left
    lagTitle.Parent = lagRow

    local lagVal = Instance.new("TextLabel")
    lagVal.Size = UDim2.new(0, 40, 0, 16)
    lagVal.Position = UDim2.new(1, -48, 0, 4)
    lagVal.BackgroundTransparency = 1
    lagVal.ZIndex = 5
    lagVal.Text = tostring(math.floor(_G.LaggerPower or 50))
    lagVal.TextColor3 = C.accent
    lagVal.Font = Enum.Font.GothamBold
    lagVal.TextSize = 12
    lagVal.TextXAlignment = Enum.TextXAlignment.Right
    lagVal.Parent = lagRow

    local lagTrack = Instance.new("Frame")
    lagTrack.Size = UDim2.new(1, -20, 0, 10)
    lagTrack.Position = UDim2.new(0, 10, 0, 28)
    lagTrack.BackgroundColor3 = Color3.fromRGB(40, 12, 12)
    lagTrack.BorderSizePixel = 0
    lagTrack.ZIndex = 5
    lagTrack.Parent = lagRow
    Instance.new("UICorner", lagTrack).CornerRadius = UDim.new(1, 0)

    local lagFill = Instance.new("Frame")
    lagFill.Size = UDim2.new(math.clamp((_G.LaggerPower or 50) / 100, 0, 1), 0, 1, 0)
    lagFill.BackgroundColor3 = C.accent
    lagFill.BorderSizePixel = 0
    lagFill.ZIndex = 6
    lagFill.Parent = lagTrack
    Instance.new("UICorner", lagFill).CornerRadius = UDim.new(1, 0)

    local lagKnob = Instance.new("Frame")
    lagKnob.Size = UDim2.new(0, 16, 0, 16)
    lagKnob.AnchorPoint = Vector2.new(0.5, 0.5)
    lagKnob.Position = UDim2.new(math.clamp((_G.LaggerPower or 50) / 100, 0, 1), 0, 0.5, 0)
    lagKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    lagKnob.BorderSizePixel = 0
    lagKnob.ZIndex = 7
    lagKnob.Parent = lagTrack
    Instance.new("UICorner", lagKnob).CornerRadius = UDim.new(1, 0)

    local function updateLaggerUI(pct)
        pct = math.clamp(pct, 0, 1)
        _G.LaggerPower = math.floor(pct * 100 + 0.5)
        lagFill.Size = UDim2.new(pct, 0, 1, 0)
        lagKnob.Position = UDim2.new(pct, 0, 0.5, 0)
        lagVal.Text = tostring(_G.LaggerPower)
        saveSettings()
    end

    local draggingLag = false
    lagTrack.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingLag = true
            local pct = (inp.Position.X - lagTrack.AbsolutePosition.X) / math.max(lagTrack.AbsoluteSize.X, 1)
            updateLaggerUI(pct)
        end
    end)
    lagKnob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingLag = true
        end
    end)
    table.insert(ActiveConnections, UserInputService.InputChanged:Connect(function(inp)
        if not draggingLag then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local pct = (inp.Position.X - lagTrack.AbsolutePosition.X) / math.max(lagTrack.AbsoluteSize.X, 1)
        updateLaggerUI(pct)
    end))
    table.insert(ActiveConnections, UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingLag = false
        end
    end))
end

toggleRow("Anti Gummy","Quita bloqueo gummy",_G.antiGummyEnabled==true,function(v)
    _G.antiGummyEnabled=v
    saveSettings()
end)

-- ===== ANTI STEAL =====
toggleRow("Quick Pickup","Agarra brainrots casi al instante en tu base",_G.QuickPickup==true,function(v)
    _G.QuickPickup = v
    if _G._175_QuickPickup then _G._175_QuickPickup.set(v) end
    saveSettings()
end)

toggleRow("Anti Steal","Protege tu base si alguien se acerca a robar",_G.AntiSteal==true,function(v)
    _G.AntiSteal = v
    saveSettings()
end)

-- Delay editable (escribir segundos)
do
    sectionOrder = sectionOrder + 1
    local delayRow = Instance.new("Frame")
    delayRow.Size = UDim2.new(1, 0, 0, 36)
    delayRow.BackgroundColor3 = C.card
    delayRow.BorderSizePixel = 0
    delayRow.ZIndex = 4
    delayRow.LayoutOrder = sectionOrder
    delayRow.Parent = ScrollingFrame2
    Instance.new("UICorner", delayRow)
    local ds = Instance.new("UIStroke")
    ds.Color = C.stroke
    ds.Parent = delayRow

    local dTitle = Instance.new("TextLabel")
    dTitle.Size = UDim2.new(0, 90, 1, 0)
    dTitle.Position = UDim2.new(0, 10, 0, 0)
    dTitle.BackgroundTransparency = 1
    dTitle.ZIndex = 5
    dTitle.Text = "Delay (seg)"
    dTitle.TextColor3 = C.textBright
    dTitle.TextSize = 11
    dTitle.Font = Enum.Font.GothamBold
    dTitle.TextXAlignment = Enum.TextXAlignment.Left
    dTitle.Parent = delayRow

    local dBox = Instance.new("TextBox")
    dBox.Size = UDim2.new(0, 70, 0, 24)
    dBox.Position = UDim2.new(1, -80, 0.5, -12)
    dBox.BackgroundColor3 = C.iconBg
    dBox.BorderSizePixel = 0
    dBox.ZIndex = 6
    dBox.Text = string.format("%.1f", tonumber(_G.AntiStealDelay) or 1.8)
    dBox.PlaceholderText = "1.8"
    dBox.TextColor3 = C.textBright
    dBox.PlaceholderColor3 = C.textDim
    dBox.TextSize = 12
    dBox.Font = Enum.Font.GothamBold
    dBox.ClearTextOnFocus = false
    dBox.Parent = delayRow
    Instance.new("UICorner", dBox).CornerRadius = UDim.new(0, 6)
    local dbs = Instance.new("UIStroke")
    dbs.Color = C.accent
    dbs.Thickness = 1
    dbs.Parent = dBox

    local function applyDelay(fromType)
        local n = tonumber(dBox.Text)
        if not n then
            if fromType then return end -- mientras escribe, no forzar
            n = tonumber(_G.AntiStealDelay) or 1.8
        end
        n = math.clamp(n, 0.3, 60)
        _G.AntiStealDelay = n
        if not fromType then
            dBox.Text = string.format("%.1f", n)
            pcall(saveSettings)
        end
    end
    dBox.FocusLost:Connect(function()
        applyDelay(false)
    end)
    dBox:GetPropertyChangedSignal("Text"):Connect(function()
        local t = dBox.Text:gsub("[^%d%.]", "")
        if t ~= dBox.Text then
            dBox.Text = t
            return
        end
        -- Actualizar delay en vivo al escribir (ej: 2.8)
        local n = tonumber(t)
        if n and n >= 0.3 and n <= 60 then
            _G.AntiStealDelay = n
        end
    end)
end

do
    sectionOrder = sectionOrder + 1
    local modeRow = Instance.new("Frame")
    modeRow.Size = UDim2.new(1, 0, 0, 36)
    modeRow.BackgroundColor3 = C.card
    modeRow.BorderSizePixel = 0
    modeRow.ZIndex = 4
    modeRow.LayoutOrder = sectionOrder
    modeRow.Parent = ScrollingFrame2
    Instance.new("UICorner", modeRow)
    local ms = Instance.new("UIStroke"); ms.Color = C.stroke; ms.Parent = modeRow

    local function makeModeBtn(text, modeKey, xScale)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.46, 0, 0, 26)
        b.Position = UDim2.new(xScale, 4, 0.5, -13)
        b.BackgroundColor3 = (_G.AntiStealMode == modeKey) and C.accent or Color3.fromRGB(40, 14, 14)
        b.BorderSizePixel = 0
        b.ZIndex = 6
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.TextSize = 11
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.Parent = modeRow
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        return b
    end
    local laserBtn = makeModeBtn("Laser Protector", "laser", 0.02)
    local apBtn = makeModeBtn("AP Protector", "ap", 0.52)

    local function refreshModeBtns()
        laserBtn.BackgroundColor3 = (_G.AntiStealMode == "laser") and C.accent or Color3.fromRGB(40, 14, 14)
        apBtn.BackgroundColor3 = (_G.AntiStealMode == "ap") and C.accent or Color3.fromRGB(40, 14, 14)
    end
    laserBtn.MouseButton1Click:Connect(function()
        _G.AntiStealMode = "laser"
        refreshModeBtns()
        saveSettings()
    end)
    apBtn.MouseButton1Click:Connect(function()
        _G.AntiStealMode = "ap"
        refreshModeBtns()
        saveSettings()
    end)

    -- AP command checkboxes (solo visibles en modo conceptual; siempre en settings)
    sectionOrder = sectionOrder + 1
    local apCmdsRow = Instance.new("Frame")
    apCmdsRow.Size = UDim2.new(1, 0, 0, 78)
    apCmdsRow.BackgroundColor3 = C.card
    apCmdsRow.BorderSizePixel = 0
    apCmdsRow.ZIndex = 4
    apCmdsRow.LayoutOrder = sectionOrder
    apCmdsRow.Parent = ScrollingFrame2
    Instance.new("UICorner", apCmdsRow)
    local acs = Instance.new("UIStroke"); acs.Color = C.stroke; acs.Parent = apCmdsRow

    local apTitle = Instance.new("TextLabel")
    apTitle.Size = UDim2.new(1, -12, 0, 16)
    apTitle.Position = UDim2.new(0, 8, 0, 4)
    apTitle.BackgroundTransparency = 1
    apTitle.ZIndex = 5
    apTitle.Text = "AP Protector — comandos al acercarse"
    apTitle.TextColor3 = C.textMute
    apTitle.Font = Enum.Font.GothamBold
    apTitle.TextSize = 10
    apTitle.TextXAlignment = Enum.TextXAlignment.Left
    apTitle.Parent = apCmdsRow

    local apCmds = {
        { key = "balloon", label = "Balloon" },
        { key = "tiny", label = "Tiny" },
        { key = "jail", label = "Jail" },
        { key = "rocket", label = "Rocket" },
        { key = "ragdoll", label = "Ragdoll" },
    }
    for i, cmd in ipairs(apCmds) do
        local col = ((i - 1) % 3)
        local row = math.floor((i - 1) / 3)
        local cb = Instance.new("TextButton")
        cb.Size = UDim2.new(0, 72, 0, 22)
        cb.Position = UDim2.new(0, 8 + col * 78, 0, 24 + row * 26)
        cb.BackgroundColor3 = (_G.AntiStealAP[cmd.key] and C.accent) or Color3.fromRGB(40, 14, 14)
        cb.BorderSizePixel = 0
        cb.ZIndex = 6
        cb.Text = cmd.label
        cb.TextColor3 = Color3.fromRGB(255, 255, 255)
        cb.TextSize = 10
        cb.Font = Enum.Font.GothamMedium
        cb.AutoButtonColor = false
        cb.Parent = apCmdsRow
        Instance.new("UICorner", cb).CornerRadius = UDim.new(0, 5)
        cb.MouseButton1Click:Connect(function()
            _G.AntiStealAP[cmd.key] = not _G.AntiStealAP[cmd.key]
            cb.BackgroundColor3 = (_G.AntiStealAP[cmd.key] and C.accent) or Color3.fromRGB(40, 14, 14)
            saveSettings()
        end)
    end
end

toggleRow("Auto Destroy Turrets","Deletes enemy turrets",_G.AutoTurretEnabled == true,function(v)
    _G.AutoTurretEnabled = v
    if type(_G._175_AT) == "function" then pcall(_G._175_AT, v) end
    saveSettings()
end)

toggleRow("ESP Best","Muestra el mejor brainrot del servidor",_G.ESPBestEnabled,function(v)
    _G.ESPBestEnabled = v
    if v then
        if type(_G._175_ClearBestNotify)=="function" then pcall(_G._175_ClearBestNotify) end
        _G.__bestPendingName = nil
        _G.__bestPendingTicks = 0
        _G.__bestLastNotifyTime = 0
        task.spawn(function()
            if type(_G._175_UpdateBestESP)=="function" then pcall(_G._175_UpdateBestESP) end
        end)
    else
        pcall(function() if clearBestESP then clearBestESP() end end)
        if type(_G._175_ClearBestNotify)=="function" then pcall(_G._175_ClearBestNotify) end
        _G.__bestPendingName = nil
        _G.__bestPendingTicks = 0
    end
    saveSettings()
end)


-- ===== SETTINGS FLOAT (botón S → UI centrada independiente) =====
do
    local settingsOpen = false
    local SF_W = 165
    local SF_H = 195

    local FloatGui = Instance.new("ScreenGui")
    FloatGui.Name = "175SettingsFloat"
    FloatGui.ResetOnSpawn = false
    FloatGui.DisplayOrder = 1001
    FloatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FloatGui.Parent = PlayerGui

    local Border = Instance.new("Frame")
    Border.Name = "Border"
    Border.Size = UDim2.new(0, SF_W + 4, 0, SF_H + 4)
    Border.Position = UDim2.new(0.5, 0, 0.5, 0)
    Border.AnchorPoint = Vector2.new(0.5, 0.5)
    Border.BackgroundColor3 = C.accent
    Border.BorderSizePixel = 0
    Border.ClipsDescendants = true
    Border.Visible = false
    Border.Parent = FloatGui
    Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 12)
    applySavedPos(Border, "SettingsFloat", UDim2.new(0.5, 0, 0.5, 0))

    local Win = Instance.new("Frame")
    Win.Size = UDim2.new(0, SF_W, 0, SF_H)
    Win.Position = UDim2.new(0.5, 0, 0.5, 0)
    Win.AnchorPoint = Vector2.new(0.5, 0.5)
    Win.BackgroundColor3 = C.body
    Win.BorderSizePixel = 0
    Win.Parent = Border
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 11)
    Win.BackgroundTransparency = 0.2
    Win.ClipsDescendants = true
    do
        local bgImg = Instance.new("ImageLabel")
        bgImg.Name = "VTRXBg"
        bgImg.Size = UDim2.fromScale(1, 1)
        bgImg.BackgroundTransparency = 1
        bgImg.Image = "rbxassetid://120361169727304"
        bgImg.ImageTransparency = 0.25
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 0
        bgImg.Parent = Win
        Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 11)
        local overlay = Instance.new("Frame")
        overlay.Name = "VTRXOverlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        overlay.BackgroundTransparency = 0.45
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 0
        overlay.Parent = Win
        Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 11)
        local redTint = Instance.new("Frame")
        redTint.Name = "VTRXRedTint"
        redTint.Size = UDim2.fromScale(1, 1)
        redTint.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        redTint.BackgroundTransparency = 0.75
        redTint.BorderSizePixel = 0
        redTint.ZIndex = 0
        redTint.Parent = Win
        Instance.new("UICorner", redTint).CornerRadius = UDim.new(0, 11)
    end

    local Hdr = Instance.new("Frame")
    Hdr.Size = UDim2.new(1, 0, 0, 30)
    Hdr.BackgroundColor3 = C.panel
    Hdr.BorderSizePixel = 0
    Hdr.Parent = Win
    Instance.new("UICorner", Hdr).CornerRadius = UDim.new(0, 13)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -40, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Settings"
    Title.TextColor3 = C.textBright
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Hdr

    local CloseS = Instance.new("TextButton")
    CloseS.Size = UDim2.new(0, 24, 0, 24)
    CloseS.Position = UDim2.new(1, -30, 0.5, -12)
    CloseS.BackgroundColor3 = C.card
    CloseS.Text = "X"
    CloseS.TextColor3 = C.textMute
    CloseS.TextSize = 12
    CloseS.Font = Enum.Font.GothamBold
    CloseS.BorderSizePixel = 0
    CloseS.Parent = Hdr
    Instance.new("UICorner", CloseS).CornerRadius = UDim.new(0, 4)

    -- Mover el scroll de settings al panel flotante
    pcall(function()
        ScrollingFrame2.Parent = Win
        ScrollingFrame2.Size = UDim2.new(1, 0, 1, -34)
        ScrollingFrame2.Position = UDim2.new(0, 0, 0, 32)
        Frame21.Visible = false
    end)

    local function setSettingsOpen(v, skipSave)
        settingsOpen = v and true or false
        Border.Visible = settingsOpen
        pcall(function()
            SettingsHdrBtn.TextColor3 = settingsOpen and C.accent or C.textMute
        end)
        if not skipSave then
            uiLayout.SettingsOpen = settingsOpen
            saveUILayout()
        end
    end

    CloseS.MouseButton1Click:Connect(function()
        setSettingsOpen(false)
    end)

    SettingsHdrBtn.MouseButton1Click:Connect(function()
        setSettingsOpen(not settingsOpen)
    end)

    -- Restaurar abierta si la dejaste así
    if uiLayout.SettingsOpen == true then
        task.defer(function() setSettingsOpen(true, true) end)
    end

    -- Arrastrar + guardar posición
    local dragging, dragStart, startPos
    Hdr.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Border.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    persistPos(Border, "SettingsFloat")
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Border.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            persistPos(Border, "SettingsFloat")
        end
    end)

    print("[175] Settings float listo (botón S)")
end


-- ===== BRAINROTS FLOAT (botón B) =====
do
    local brainOpen = true
    local BF_W = 280
    local BF_H = 225

    local BFloatGui = Instance.new("ScreenGui")
    BFloatGui.Name = "175BrainrotsFloat"
    BFloatGui.ResetOnSpawn = false
    BFloatGui.DisplayOrder = 1000
    BFloatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BFloatGui.Parent = PlayerGui

    local BBorder = Instance.new("Frame")
    BBorder.Name = "Border"
    BBorder.Size = UDim2.new(0, BF_W + 4, 0, BF_H + 4)
    BBorder.Position = UDim2.new(0.5, -90, 0.35, 0)
    -- Anchor top-center: al minimizar se contrae hacia arriba
    BBorder.AnchorPoint = Vector2.new(0.5, 0)
    BBorder.BackgroundColor3 = C.accent
    BBorder.BorderSizePixel = 0
    BBorder.ClipsDescendants = true
    BBorder.Visible = true
    BBorder.Parent = BFloatGui
    Instance.new("UICorner", BBorder).CornerRadius = UDim.new(0, 12)
    applySavedPos(BBorder, "BrainrotsFloat", UDim2.new(0.5, -90, 0.35, 0))

    local BWin = Instance.new("Frame")
    BWin.Size = UDim2.new(0, BF_W, 0, BF_H)
    BWin.Position = UDim2.new(0, 2, 0, 2)
    BWin.BackgroundColor3 = C.body
    BWin.BorderSizePixel = 0
    BWin.ClipsDescendants = true
    BWin.Parent = BBorder
    Instance.new("UICorner", BWin).CornerRadius = UDim.new(0, 11)
    BWin.BackgroundTransparency = 0.2
    BWin.ClipsDescendants = true
    do
        local bgImg = Instance.new("ImageLabel")
        bgImg.Name = "VTRXBg"
        bgImg.Size = UDim2.fromScale(1, 1)
        bgImg.BackgroundTransparency = 1
        bgImg.Image = "rbxassetid://120361169727304"
        bgImg.ImageTransparency = 0.25
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 0
        bgImg.Parent = BWin
        Instance.new("UICorner", bgImg).CornerRadius = UDim.new(0, 11)
        local overlay = Instance.new("Frame")
        overlay.Name = "VTRXOverlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
        overlay.BackgroundTransparency = 0.45
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 0
        overlay.Parent = BWin
        Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 11)
        local redTint = Instance.new("Frame")
        redTint.Name = "VTRXRedTint"
        redTint.Size = UDim2.fromScale(1, 1)
        redTint.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        redTint.BackgroundTransparency = 0.75
        redTint.BorderSizePixel = 0
        redTint.ZIndex = 0
        redTint.Parent = BWin
        Instance.new("UICorner", redTint).CornerRadius = UDim.new(0, 11)
    end

    local BHdr = Instance.new("Frame")
    BHdr.Size = UDim2.new(1, 0, 0, 30)
    BHdr.BackgroundColor3 = C.panel
    BHdr.BorderSizePixel = 0
    BHdr.Parent = BWin
    Instance.new("UICorner", BHdr).CornerRadius = UDim.new(0, 13)

    local BTitle = Instance.new("TextLabel")
    BTitle.Size = UDim2.new(1, -70, 1, 0)
    BTitle.Position = UDim2.new(0, 12, 0, 0)
    BTitle.BackgroundTransparency = 1
    BTitle.Text = "Brainrots"
    BTitle.TextColor3 = C.textBright
    BTitle.TextSize = 12
    BTitle.Font = Enum.Font.GothamBold
    BTitle.TextXAlignment = Enum.TextXAlignment.Left
    BTitle.Parent = BHdr
    BTitle.Visible = false
    local categoryBrain = Instance.new("TextButton")
    categoryBrain.Name = "CategoryBrainrots"
    categoryBrain.Size = UDim2.new(0, 100, 0, 24)
    categoryBrain.Position = UDim2.new(0, 8, 0.5, -12)
    categoryBrain.BackgroundColor3 = C.accent
    categoryBrain.BorderSizePixel = 0
    categoryBrain.Text = "BRAINROTS"
    categoryBrain.TextColor3 = C.textBright
    categoryBrain.TextSize = 11
    categoryBrain.Font = Enum.Font.GothamBold
    categoryBrain.AutoButtonColor = false
    categoryBrain.Parent = BHdr
    Instance.new("UICorner", categoryBrain).CornerRadius = UDim.new(0, 6)
    local categoryConfig = categoryBrain:Clone()
    categoryConfig.Name = "CategoryConfig"
    categoryConfig.Size = UDim2.new(0, 100, 0, 24)
    categoryConfig.Position = UDim2.new(0, 112, 0.5, -12)
    categoryConfig.BackgroundColor3 = C.card
    categoryConfig.Text = "CONFIG"
    categoryConfig.Visible = true
    categoryConfig.Parent = BHdr
    categoryBrain.Size = UDim2.new(0, 100, 0, 24)

    local brainMin = false
    local BF_FULL_H = BF_H + 4
    local BF_MIN_H = 34

    local BMin = Instance.new("TextButton")
    BMin.Size = UDim2.new(0, 24, 0, 24)
    BMin.Position = UDim2.new(1, -56, 0.5, -12)
    BMin.BackgroundColor3 = C.card
    BMin.Text = "–"
    BMin.TextColor3 = C.textMute
    BMin.TextSize = 14
    BMin.Font = Enum.Font.GothamBold
    BMin.BorderSizePixel = 0
    BMin.Parent = BHdr
    Instance.new("UICorner", BMin).CornerRadius = UDim.new(0, 4)

    local BClose = Instance.new("TextButton")
    BClose.Size = UDim2.new(0, 24, 0, 24)
    BClose.Position = UDim2.new(1, -30, 0.5, -12)
    BClose.BackgroundColor3 = C.card
    BClose.Text = "X"
    BClose.TextColor3 = C.textMute
    BClose.TextSize = 12
    BClose.Font = Enum.Font.GothamBold
    BClose.BorderSizePixel = 0
    BClose.Parent = BHdr
    Instance.new("UICorner", BClose).CornerRadius = UDim.new(0, 4)

    pcall(function()
        -- Selector en la mitad izquierda; la derecha es la previsualización 3D.
        local splitLine = Instance.new("Frame")
        splitLine.Name = "SelectorPreviewDivider"
        splitLine.Size = UDim2.new(0, 1, 1, -34)
        splitLine.Position = UDim2.new(0.5, 0, 0, 34)
        splitLine.BackgroundColor3 = C.stroke
        splitLine.BorderSizePixel = 0
        splitLine.ZIndex = 4
        splitLine.Parent = BWin
        local preview = Instance.new("ViewportFrame")
        preview.Name = "BrainrotPreview"
        preview.Size = UDim2.new(0.5, -16, 0, 115)
        preview.Position = UDim2.new(0.5, 8, 0, 48)
        preview.BackgroundColor3 = Color3.fromRGB(30, 8, 8)
        preview.BackgroundTransparency = 0.15
        preview.BorderSizePixel = 0
        preview.ZIndex = 3
        preview.Ambient = Color3.fromRGB(180, 180, 180)
        preview.LightColor = Color3.fromRGB(255, 220, 220)
        preview.LightDirection = Vector3.new(-1, -1, -1)
        preview.Parent = BWin
        Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 10)
        local previewCamera = Instance.new("Camera")
        previewCamera.Parent = preview
        preview.CurrentCamera = previewCamera
        local previewName = Instance.new("TextLabel")
        previewName.Name = "BrainrotPreviewName"
        previewName.Size = UDim2.new(0.5, -16, 0, 32)
        previewName.Position = UDim2.new(0.5, 6, 0, 172)
        previewName.BackgroundTransparency = 1
        previewName.Text = "Selecciona un brainrot"
        previewName.TextColor3 = C.textBright
        previewName.TextSize = 12
        previewName.Font = Enum.Font.GothamBold
        previewName.TextXAlignment = Enum.TextXAlignment.Center
        previewName.TextTruncate = Enum.TextTruncate.AtEnd
        previewName.ZIndex = 3
        previewName.Parent = BWin
        local previewRotation
        local previewToken = 0
        local function updatePreview(name, slot)
            previewToken = previewToken + 1
            local token = previewToken
            previewName.Text = tostring(name or "") ~= "" and tostring(name) or "Selecciona un brainrot"
            if previewRotation then pcall(function() previewRotation:Disconnect() end) previewRotation = nil end
            for _, child in ipairs(preview:GetChildren()) do
                if child:IsA("Model") or child:IsA("BasePart") then child:Destroy() end
            end
            if not name then return end
            task.spawn(function()
                for _ = 1, 25 do
                    if token ~= previewToken or not preview.Parent then return end
                    for _, row in ipairs(ScrollingFrame:GetChildren()) do
                        if row:IsA("Frame") and row:GetAttribute("PetName") == name and tonumber(row:GetAttribute("SlotNum")) == tonumber(slot) then
                            local source = row:FindFirstChildOfClass("ViewportFrame")
                            if source then
                                local sourceModel
                                for _, child in ipairs(source:GetChildren()) do
                                    if child:IsA("Model") or child:IsA("BasePart") then sourceModel = child break end
                                end
                                if sourceModel then
                                    local copy = sourceModel:Clone()
                                    copy.Parent = preview
                                    if source.CurrentCamera then previewCamera.CFrame = source.CurrentCamera.CFrame previewCamera.FieldOfView = source.CurrentCamera.FieldOfView end
                                    local angle = 0
                                    previewRotation = RunService.Heartbeat:Connect(function(dt)
                                        if token ~= previewToken or not copy.Parent then
                                            if previewRotation then pcall(function() previewRotation:Disconnect() end) previewRotation = nil end
                                            return
                                        end
                                        angle = (angle + dt * 80) % 360
                                        pcall(function() copy:PivotTo(CFrame.Angles(0, math.rad(angle), 0)) end)
                                    end)
                                    return
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
        _G._175_UpdatePreview = updatePreview
        ScrollingFrame.Parent = BWin
        ScrollingFrame.Size = UDim2.new(0.5, -8, 1, -38)
        ScrollingFrame.Position = UDim2.new(0, 0, 0, 34)
        Frame17.Visible = false
    end)

    local function setCategory(category)
        categoryBrain.BackgroundColor3 = category == "brainrots" and C.accent or C.card
        categoryConfig.BackgroundColor3 = category == "config" and C.accent or C.card
        local divider = BWin:FindFirstChild("SelectorPreviewDivider")
        local previewFrame = BWin:FindFirstChild("BrainrotPreview")
        local previewLabel = BWin:FindFirstChild("BrainrotPreviewName")
        if category == "config" then
            ScrollingFrame.Visible = false
            if divider then divider.Visible = false end
            if previewFrame then previewFrame.Visible = false end
            if previewLabel then previewLabel.Visible = false end
            ScrollingFrame2.Parent = BWin
            ScrollingFrame2.Position = UDim2.new(0, 0, 0, 34)
            ScrollingFrame2.Size = UDim2.new(1, 0, 1, -38)
            ScrollingFrame2.Visible = true
        else
            ScrollingFrame2.Visible = false
            ScrollingFrame2.Parent = Win
            ScrollingFrame.Visible = true
            if divider then divider.Visible = true end
            if previewFrame then previewFrame.Visible = true end
            if previewLabel then previewLabel.Visible = true end
        end
    end
    categoryBrain.MouseButton1Click:Connect(function() setCategory("brainrots") end)
    categoryConfig.MouseButton1Click:Connect(function() setCategory("config") end)
    setCategory("brainrots")
    local function setBrainOpen(v, skipSave)
        brainOpen = v and true or false
        BBorder.Visible = brainOpen
        pcall(function()
            BrainrotsHdrBtn.TextColor3 = brainOpen and C.accent or C.textMute
        end)
        if brainOpen and not brainMin then
            pcall(function() updatePetList() end)
        end
        if not skipSave then
            uiLayout.BrainrotsOpen = brainOpen
            saveUILayout()
        end
    end

    BMin.MouseButton1Click:Connect(function()
        brainMin = not brainMin
        if brainMin then
            -- Minimiza hacia arriba (AnchorPoint top)
            BBorder.Size = UDim2.new(0, BF_W + 4, 0, BF_MIN_H)
            BWin.Size = UDim2.new(0, BF_W, 0, BF_MIN_H - 4)
            ScrollingFrame.Visible = false
            ScrollingFrame2.Visible = false
            BMin.Text = "+"
        else
            BBorder.Size = UDim2.new(0, BF_W + 4, 0, BF_FULL_H)
            BWin.Size = UDim2.new(0, BF_W, 0, BF_H)
            if ScrollingFrame2.Parent == BWin then ScrollingFrame2.Visible = true else ScrollingFrame.Visible = true end
            BMin.Text = "–"
            pcall(function() updatePetList() end)
        end
    end)

    BClose.MouseButton1Click:Connect(function()
        setBrainOpen(false)
    end)

    BrainrotsHdrBtn.MouseButton1Click:Connect(function()
        setBrainOpen(not brainOpen)
        if brainOpen and brainMin then
            brainMin = false
            BBorder.Size = UDim2.new(0, BF_W + 4, 0, BF_FULL_H)
            BWin.Size = UDim2.new(0, BF_W, 0, BF_H)
            ScrollingFrame.Visible = true
            BMin.Text = "–"
        end
    end)

    -- Si la dejaste abierta, vuelve a aparecer sola en su sitio
    if uiLayout.BrainrotsOpen == true then
        task.defer(function() setBrainOpen(true, true) end)
    end

    local dragging, dragStart, startPos
    BHdr.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = BBorder.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    persistPos(BBorder, "BrainrotsFloat")
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            BBorder.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            persistPos(BBorder, "BrainrotsFloat")
        end
    end)

    print("[175] Brainrots float listo (botón B)")
end


-- Actions independiente: Flash arriba, Block en medio y Reset abajo.
do
    local ActionGui = Instance.new("ScreenGui")
    ActionGui.Name = "175ActionsFloat"
    ActionGui.ResetOnSpawn = false
    ActionGui.DisplayOrder = 1002
    ActionGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ActionGui.Parent = PlayerGui
    local actionPanel = Instance.new("Frame")
    actionPanel.Size = UDim2.new(0, 138, 0, 206)
    actionPanel.Position = UDim2.new(0.5, 210, 0.5, -20)
    actionPanel.AnchorPoint = Vector2.new(0.5, 0.5)
    actionPanel.BackgroundColor3 = C.body
    actionPanel.BorderSizePixel = 0
    actionPanel.ZIndex = 2
    local actionBg = Instance.new("ImageLabel")
    actionBg.Name = "MoneyBackground"
    actionBg.Size = actionPanel.Size
    actionBg.Position = actionPanel.Position
    actionBg.AnchorPoint = actionPanel.AnchorPoint
    actionBg.BackgroundTransparency = 1
    actionBg.Image = "rbxassetid://120361169727304"
    actionBg.ImageTransparency = 0.18
    actionBg.ScaleType = Enum.ScaleType.Crop
    actionBg.ZIndex = 1
    actionBg.Parent = ActionGui
    Instance.new("UICorner", actionBg).CornerRadius = UDim.new(0, 12)
    local moneyStroke = Instance.new("UIStroke")
    moneyStroke.Color = C.accent
    moneyStroke.Thickness = 2
    moneyStroke.Parent = actionBg
    actionPanel.Parent = ActionGui
    Instance.new("UICorner", actionPanel).CornerRadius = UDim.new(0, 12)
    local actionStroke = Instance.new("UIStroke")
    actionStroke.Color = C.accent
    actionStroke.Thickness = 1.5
    actionStroke.Parent = actionPanel
    local scriptTitle = Instance.new("TextLabel")
    scriptTitle.Name = "ScriptTitle"
    scriptTitle.Size = UDim2.new(1, -16, 0, 22)
    scriptTitle.BackgroundTransparency = 1
    scriptTitle.Text = "FLASH BLOCK"
    scriptTitle.TextColor3 = C.textBright
    scriptTitle.TextSize = 11
    scriptTitle.Font = Enum.Font.GothamBold
    scriptTitle.TextXAlignment = Enum.TextXAlignment.Center
    scriptTitle.Visible = false
    scriptTitle.LayoutOrder = -3
    scriptTitle.ZIndex = 3
    scriptTitle.Parent = actionPanel
    local actionTitle = Instance.new("TextLabel")
    actionTitle.Size = UDim2.new(1, -16, 0, 28)
    actionTitle.BackgroundColor3 = C.panel
    actionTitle.BorderSizePixel = 0
    actionTitle.Text = "ACTIONS"
    actionTitle.TextColor3 = C.textBright
    actionTitle.TextSize = 13
    actionTitle.Font = Enum.Font.GothamBlack
    actionTitle.LayoutOrder = -2
    actionTitle.ZIndex = 3
    actionTitle.Parent = actionPanel
    Instance.new("UICorner", actionTitle).CornerRadius = UDim.new(0, 7)
    local actionDivider = Instance.new("Frame")
    actionDivider.Name = "ActionDivider"
    actionDivider.Size = UDim2.new(1, -20, 0, 2)
    actionDivider.BackgroundColor3 = C.accent
    actionDivider.BorderSizePixel = 0
    actionDivider.LayoutOrder = -1
    actionDivider.ZIndex = 3
    actionDivider.Parent = actionPanel
    Instance.new("UICorner", actionDivider).CornerRadius = UDim.new(0, 2)
    local actionLayout = Instance.new("UIListLayout")
    actionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    actionLayout.Padding = UDim.new(0, 7)
    actionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    actionLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    actionLayout.Parent = actionPanel
    local actionPadding = Instance.new("UIPadding")
    actionPadding.PaddingTop = UDim.new(0, 8)
    actionPadding.PaddingBottom = UDim.new(0, 8)
    actionPadding.Parent = actionPanel
    local function action(text, fn)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -16, 0, 38)
        b.BackgroundColor3 = C.card
        b.BorderSizePixel = 0
        b.Text = text
        b.TextColor3 = C.textBright
        b.TextSize = 12
        b.Font = Enum.Font.GothamBold
        b.LayoutOrder = 0
        b.AutoButtonColor = true
        b.Parent = actionPanel
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        b.MouseButton1Click:Connect(fn)
    end
    action("FLASH", function() if selectedPrompt and selectedSlotNumber and not isStealing and not autoStealEnabled then startTripToPetSlot(selectedPrompt, selectedSlotNumber) end end)
    action("BLOCK", function() triggerAutoBlock() end)
    action("RESET", function() doReset() end)
    -- Arrastre del panel Actions desde su encabezado.
    actionTitle.Active = true
    local actionDragging, actionDragStart, actionStartPos = false, nil, nil
    actionTitle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            actionDragging = true
            actionDragStart = input.Position
            actionStartPos = actionPanel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then actionDragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if actionDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - actionDragStart
            actionPanel.Position = UDim2.new(actionStartPos.X.Scale, actionStartPos.X.Offset + delta.X, actionStartPos.Y.Scale, actionStartPos.Y.Offset + delta.Y)
            actionBg.Position = actionPanel.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if actionDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            actionDragging = false
        end
    end)
    Frame7.Visible = false
    Frame5.Visible = false
    TextLabel.Visible = false
end
-- Título general independiente del script.
do
    local titleGui = Instance.new("ScreenGui")
    titleGui.Name = "StickFlashTPTitle"
    titleGui.ResetOnSpawn = false
    titleGui.DisplayOrder = 1003
    titleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    titleGui.Parent = PlayerGui
    local titlePanel = Instance.new("Frame")
    titlePanel.Name = "TitlePanel"
    titlePanel.Size = UDim2.new(0, 300, 0, 58)
    titlePanel.Position = UDim2.new(0.5, 0, 0, 18)
    titlePanel.AnchorPoint = Vector2.new(0.5, 0)
    titlePanel.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
    titlePanel.BackgroundTransparency = 0.08
    titlePanel.BorderSizePixel = 0
    titlePanel.Parent = titleGui
    Instance.new("UICorner", titlePanel).CornerRadius = UDim.new(0, 12)
    local titleStroke = Instance.new("UIStroke")
    titleStroke.Color = Color3.fromRGB(255, 25, 25)
    titleStroke.Thickness = 2
    titleStroke.Parent = titlePanel
    local titleText = Instance.new("TextLabel")
    titleText.Name = "ScriptName"
    titleText.Size = UDim2.new(1, -16, 1, 0)
    titleText.Position = UDim2.new(0, 8, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "FLASH BLOCK"
    titleText.TextColor3 = Color3.fromRGB(255, 35, 35)
    titleText.TextSize = 24
    titleText.Font = Enum.Font.GothamBlack
    titleText.TextXAlignment = Enum.TextXAlignment.Center
    titleText.TextYAlignment = Enum.TextYAlignment.Center
    titleText.TextStrokeColor3 = Color3.fromRGB(20, 0, 0)
    titleText.TextStrokeTransparency = 0.25
    titleText.Parent = titlePanel
end
local HugoHubBanner=Instance.new("ScreenGui")
HugoHubBanner.Name="HugoHubBanner"
HugoHubBanner.SelectionGroup=false
HugoHubBanner.ResetOnSpawn=false
HugoHubBanner.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
HugoHubBanner.IgnoreGuiInset=false
do
    local parented=false
    pcall(function()
        if gethui then HugoHubBanner.Parent=gethui() parented=true end
    end)
    if not parented then
        pcall(function() HugoHubBanner.Parent=CoreGui parented=HugoHubBanner.Parent~=nil end)
    end
    if not parented then HugoHubBanner.Parent=PlayerGui end
end

local BFrame=Instance.new("Frame")
BFrame.Size=UDim2.new(0,L.bannerW,0,L.bannerH)
BFrame.Position=L.bannerPos
BFrame.BackgroundColor3=C.accent
BFrame.BorderSizePixel=0
BFrame.ClipsDescendants=true
BFrame.Parent=HugoHubBanner
Instance.new("UICorner",BFrame).CornerRadius=UDim.new(0,10)

local BUIGradient=Instance.new("UIGradient")
BUIGradient.Color=borderGradientSeq
BUIGradient.Rotation=224.297
BUIGradient.Parent=BFrame

local BFrame2=Instance.new("Frame")
BFrame2.Size=UDim2.new(0,L.bannerW-4,0,L.bannerH-4)
BFrame2.Position=UDim2.new(0,2,0,2)
BFrame2.BackgroundColor3=C.panel
BFrame2.BackgroundTransparency=0.35
BFrame2.BorderSizePixel=0
BFrame2.ClipsDescendants=true
BFrame2.Parent=BFrame
Instance.new("UICorner",BFrame2).CornerRadius=UDim.new(0,8)

do
    local bg = Instance.new("ImageLabel")
    bg.Name = "VTRXBg"
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundTransparency = 1
    bg.Image = "rbxassetid://93596272337297"
    bg.ImageTransparency = 0.35
    bg.ScaleType = Enum.ScaleType.Crop
    bg.ZIndex = 0
    bg.Parent = BFrame2
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)
    local tint = Instance.new("Frame")
    tint.Size = UDim2.fromScale(1, 1)
    tint.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    tint.BackgroundTransparency = 0.5
    tint.BorderSizePixel = 0
    tint.ZIndex = 0
    tint.Parent = BFrame2
    Instance.new("UICorner", tint).CornerRadius = UDim.new(0, 8)
end

local BTitle=Instance.new("TextLabel")
BTitle.Size=UDim2.new(1,-4,0,16)
BTitle.Position=UDim2.new(0,2,0,2)
BTitle.BackgroundTransparency=1
BTitle.Text='<font color="rgb(255,220,220)">FLASH BLOCK</font>'
BTitle.TextSize=12
BTitle.Font=Enum.Font.GothamBold
BTitle.RichText=true
BTitle.TextXAlignment=Enum.TextXAlignment.Center
BTitle.ZIndex=2
BTitle.Parent=BFrame2

local BDiscord=Instance.new("TextLabel")
BDiscord.Size=UDim2.new(1,-6,0,12)
BDiscord.Position=UDim2.new(0,3,0,18)
BDiscord.BackgroundTransparency=1
BDiscord.Text=""
BDiscord.TextColor3=C.textBright
BDiscord.TextSize=8
BDiscord.Font=Enum.Font.GothamMedium
BDiscord.RichText=true
BDiscord.TextXAlignment=Enum.TextXAlignment.Center
BDiscord.TextTruncate=Enum.TextTruncate.AtEnd
BDiscord.ZIndex=2
BDiscord.Visible=false
BDiscord.Parent=BFrame2

local BStats=Instance.new("TextLabel")
BStats.Size=UDim2.new(1,-4,0,12)
BStats.Position=UDim2.new(0,2,0,32)
BStats.BackgroundTransparency=1
BStats.Text='<font color="rgb(255,50,50)">FPS:</font> 60   <font color="rgb(255,50,50)">PING:</font> 35ms'
BStats.TextColor3=C.textBright
BStats.TextSize=8
BStats.Font=Enum.Font.GothamMedium
BStats.RichText=true
BStats.TextXAlignment=Enum.TextXAlignment.Center
BStats.Parent=BFrame2

-- Borde rojo giratorio clásico (Discord)
task.spawn(function()
local base1,base2=UIGradient.Rotation,BUIGradient.Rotation
while UIGradient.Parent and BUIGradient.Parent do
local t=os.clock()
UIGradient.Rotation=(base1+t*18)%360
BUIGradient.Rotation=(base2+t*18)%360
RunService.RenderStepped:Wait()
end
end)

do
local frameTimes={}
local fpsConn
fpsConn=RunService.RenderStepped:Connect(function()
if not BStats.Parent then fpsConn:Disconnect() return end
local now=os.clock()
table.insert(frameTimes,now)
while frameTimes[1] and now-frameTimes[1]>1 do table.remove(frameTimes,1) end
end)
task.spawn(function()
while BStats.Parent do
local fps=#frameTimes
if fps<2 and frameTimes[1] then
local span=os.clock()-frameTimes[1]
if span>0 then fps=math.floor(#frameTimes/span+0.5) end
end
local ping=0
pcall(function() ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()+0.5) end)
BStats.Text=string.format('<font color="rgb(255,50,50)">FPS:</font> %d   <font color="rgb(255,50,50)">PING:</font> %dms',fps,ping)
task.wait(0.25)
end
end)
end

local function syncBorder()
BorderFrame.Position = Win.Position
BorderFrame.Size = UDim2.new(0, Win.AbsoluteSize.X + 4, 0, Win.AbsoluteSize.Y + 4)
end

do
local dragging,dragStart,startPos
local function begin(input)
dragging=true
dragStart=input.Position
startPos=Win.Position
input.Changed:Connect(function()
if input.UserInputState==Enum.UserInputState.End then
dragging=false
persistPos(Win, "MainWin")
syncBorder()
end
end)
end
Frame3.Active=true
Frame3.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then begin(input) end
end)
UserInputService.InputChanged:Connect(function(input)
if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
local d=input.Position-dragStart
Win.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
syncBorder()
end
end)
UserInputService.InputEnded:Connect(function(input)
if dragging and (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) then
dragging=false
persistPos(Win, "MainWin")
syncBorder()
end
end)
end

local activeTab="brainrots"
local function setTab(tab)
if tab==activeTab then return end
activeTab=tab
local info=TweenInfo.new(0.22,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
if tab=="settings" then
Frame21.Visible=true
Frame21.Position=UDim2.new(1,0,0,0)
TweenService:Create(Frame17,info,{Position=UDim2.new(-1,0,0,0)}):Play()
TweenService:Create(Frame21,info,{Position=UDim2.new(0,0,0,0)}):Play()
TextLabel7.TextColor3=C.textDim
TextLabel8.TextColor3=C.textRed
TweenService:Create(Frame13,info,{BackgroundTransparency=1}):Play()
TweenService:Create(Frame14,info,{BackgroundTransparency=0}):Play()
else
Frame17.Visible=true
Frame17.Position=UDim2.new(-1,0,0,0)
TweenService:Create(Frame17,info,{Position=UDim2.new(0,0,0,0)}):Play()
TweenService:Create(Frame21,info,{Position=UDim2.new(1,0,0,0)}):Play()
TextLabel7.TextColor3=C.textRed
TextLabel8.TextColor3=C.textDim
TweenService:Create(Frame13,info,{BackgroundTransparency=0}):Play()
TweenService:Create(Frame14,info,{BackgroundTransparency=1}):Play()
task.delay(0.22,function() if activeTab=="brainrots" then Frame21.Visible=false end end)
end
end

Frame17.Position=UDim2.new(0,0,0,0)
TextButton4.MouseButton1Click:Connect(function() setTab("brainrots") end)
TextButton5.MouseButton1Click:Connect(function() setTab("settings") end)

-- Candado = Rejoin (Kay Hub)
local function doRejoin()
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end
_G._175_Rejoin = doRejoin
LockBtn.Text = "🔒"
LockBtn.TextColor3 = C.textMute
LockBtn.MouseButton1Click:Connect(function()
    LockBtn.TextColor3 = C.accent
    task.delay(0.15, function()
        pcall(function() LockBtn.TextColor3 = C.textMute end)
    end)
    doRejoin()
end)

local minimised=false
local fullSize=Win.Size
local fullBorder=BorderFrame.Size
local MIN_WIN_H=L.headerH+36
local MIN_BORDER_H=MIN_WIN_H+4

MinBtn.MouseButton1Click:Connect(function()
minimised=not minimised
local info=TweenInfo.new(0.25,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
if minimised then
TweenService:Create(Win,info,{Size=UDim2.new(0,L.winW,0,MIN_WIN_H)}):Play()
TweenService:Create(BorderFrame,info,{Size=UDim2.new(0,L.winW+4,0,MIN_BORDER_H)}):Play()
else
TweenService:Create(Win,info,{Size=fullSize}):Play()
TweenService:Create(BorderFrame,info,{Size=fullBorder}):Play()
end
end)

CloseBtn.MouseButton1Click:Connect(function()
local info=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
local t1=TweenService:Create(Win,info,{Size=UDim2.new(0,0,0,0)})
local t2=TweenService:Create(BorderFrame,info,{Size=UDim2.new(0,0,0,0)})
t1:Play(); t2:Play()
t1.Completed:Connect(function() HUGO_SCRIPT_GUI:Destroy() end)
end)

local function hookButton(btn,normal,hover)
btn.MouseEnter:Connect(function()
TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=hover}):Play()
end)
btn.MouseLeave:Connect(function()
TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=normal}):Play()
end)
btn.MouseButton1Down:Connect(function()
TweenService:Create(btn,TweenInfo.new(0.06),{BackgroundColor3=C.deepRed}):Play()
end)
btn.MouseButton1Up:Connect(function()
TweenService:Create(btn,TweenInfo.new(0.1),{BackgroundColor3=hover}):Play()
end)
end

hookButton(FLASHTP,C.card,C.iconBg)
hookButton(BLOCK,C.card,C.iconBg)
hookButton(RESET,C.card,C.iconBg)
for _,b in ipairs({RecoverHdrBtn,BrainrotsHdrBtn,SettingsHdrBtn,LockBtn,MinBtn,CloseBtn}) do hookButton(b,C.card,C.iconBg) end

local function flashBar(bar)
bar.BackgroundColor3=C.accentHi
TweenService:Create(bar,TweenInfo.new(0.4),{BackgroundColor3=C.stroke}):Play()
end

local flashBlinkActive=false
local BLINK_HI=Color3.fromRGB(255,40,40)
local BLINK_LO=Color3.fromRGB(110,10,10)
local BLINK_T=TweenInfo.new(0.3,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut)

local function startFlashBlink()
if flashBlinkActive then return end
flashBlinkActive=true
task.spawn(function()
while flashBlinkActive and not thisScriptStopped do
TweenService:Create(FLASHTP,BLINK_T,{BackgroundColor3=BLINK_HI}):Play()
TweenService:Create(flashAccent,BLINK_T,{BackgroundColor3=BLINK_HI}):Play()
TweenService:Create(Frame13,BLINK_T,{BackgroundColor3=BLINK_HI,BackgroundTransparency=0}):Play()
task.wait(0.3)
if not flashBlinkActive then break end
TweenService:Create(FLASHTP,BLINK_T,{BackgroundColor3=BLINK_LO}):Play()
TweenService:Create(flashAccent,BLINK_T,{BackgroundColor3=BLINK_LO}):Play()
TweenService:Create(Frame13,BLINK_T,{BackgroundColor3=BLINK_LO}):Play()
task.wait(0.3)
end
end)
end

local function stopFlashBlink()
if not flashBlinkActive then return end
flashBlinkActive=false
TweenService:Create(FLASHTP,TweenInfo.new(0.2),{BackgroundColor3=C.card}):Play()
TweenService:Create(flashAccent,TweenInfo.new(0.2),{BackgroundColor3=C.stroke}):Play()
TweenService:Create(Frame13,TweenInfo.new(0.2),{BackgroundColor3=C.accent,BackgroundTransparency=0}):Play()
end

startFlashBlink()

FLASHTP.MouseButton1Click:Connect(function()
if selectedPrompt and selectedSlotNumber then
if not isStealing and not autoStealEnabled then
flashBar(flashAccent)
startTripToPetSlot(selectedPrompt,selectedSlotNumber)
end
end
end)

BLOCK.MouseButton1Click:Connect(function()
flashBar(blockAccent)
triggerAutoBlock()
end)

RESET.MouseButton1Click:Connect(function()
flashBar(resetAccent)
doReset()
end)

task.spawn(function()
while task.wait(1.0) do
if thisScriptStopped then break end
-- desbloquear selección si se quedó pegado
if autoStealEnabled and not isStealing then
    -- si no hay movimiento activo, liberar
    if not currentMovement then
        autoStealEnabled = false
    end
end
if selectedPrompt and not selectedPrompt.Parent then
    selectedPrompt = nil
end
pcall(updatePetList)
if selectedPrompt and selectedSlotNumber then
stopFlashBlink()
else
startFlashBlink()
end
end
end)

updatePetList()

if _G.APESPEnabled then enableAPESP() end
if aimbotEnabled then refrescarAimbot() end
if antiRagdollEnabled then startAntiRagdoll() end
if _G.ESPBaseEnabled then enableESPBase() end

if _G.DropBrainrotEnabled then
    task.spawn(function() createDropGui(); dropGuiVisible = true end)
end

task.spawn(function()
local target=L.posX
Win.Position=UDim2.new(target.X.Scale,target.X.Offset,target.Y.Scale,target.Y.Offset-40)
BorderFrame.Position=Win.Position
Win.Visible=true
TweenService:Create(Win,TweenInfo.new(0.45,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=target}):Play()
local bt=TweenService:Create(BorderFrame,TweenInfo.new(0.45,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=target})
bt:Play()
bt.Completed:Wait()
RunService.RenderStepped:Connect(syncBorder)
end)

_G.Formega_Script_Purge=function()
thisScriptStopped=true
stopAntiRagdoll()
disableAPESP()
disableESPBase()
if aimbotLaserConnection then aimbotLaserConnection:Disconnect(); aimbotLaserConnection = nil end
if aimbotWebConnection then aimbotWebConnection:Disconnect(); aimbotWebConnection = nil end
if aimbotBackpackConn then aimbotBackpackConn:Disconnect(); aimbotBackpackConn = nil end
if dropGUI then dropGUI:Destroy(); dropGUI=nil end
if dropEnabled then 
    dropEnabled = false
    for _, c in ipairs(dropConns) do
        if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
    end
    dropConns = {}
end
for _,conn in ipairs(ActiveConnections) do
if conn then pcall(function() conn:Disconnect() end) end
end
pcall(function()
    local g = PlayerGui:FindFirstChild("FlashBlock") or (gethui and gethui():FindFirstChild("FlashBlock"))
    if g then g:Destroy() end
end)
_G.Formega_Script_Purge=nil
end

    pcall(function() HUGO_SCRIPT_GUI.Enabled = false end)
    pcall(function() HugoHubBanner.Enabled = false end)
end -- fin __build175GUI
local okGUI, errGUI = pcall(__build175GUI)
if not okGUI then
    warn("[175] Error GUI:", errGUI)
else
    print("[175] GUI construida OK")
end

-- ===== ESP BEST MEJORADO =====
task.spawn(function()
local lastNotifyNameBest = nil
local bestEsp = nil
local isNotifyingBest = false
local bestEspConn = nil

local function findBestBrainrotBest()
    local plotsFolder = Workspace:FindFirstChild("Plots")
    if not plotsFolder then return nil, nil, nil end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position
    if not myPos then return nil, nil, nil end
    local bestPrompt, bestName, bestValue = nil, nil, nil
    local bestGen, bestRarity, bestDist = -1, -1, 99999
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        if not isMyPlot(plot) then
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if podiums then
                for _, podium in ipairs(podiums:GetChildren()) do
                    local base = podium:FindFirstChild("Base") or podium
                    local spawn = base and base:FindFirstChild("Spawn")
                    local att = spawn and spawn:FindFirstChild("PromptAttachment")
                    if att then
                        for _, child in ipairs(att:GetChildren()) do
                            if child:IsA("ProximityPrompt") and isValidStealPrompt(child) then
                                local petName = child.ObjectText or "Pet"
                                local valStr, genNum = getPetValueBest(child, podium)
                                local rarity = getRarityScoreBest(petName)
                                local pos = att:IsA("Attachment") and att.WorldPosition or (att:IsA("BasePart") and att.Position)
                                if pos then
                                    local dist = (pos - myPos).Magnitude
                                    local better = false
                                    if genNum > bestGen then
                                        better = true
                                    elseif genNum == bestGen then
                                        if rarity > bestRarity then
                                            better = true
                                        elseif rarity == bestRarity and dist < bestDist then
                                            better = true
                                        end
                                    end
                                    if better then
                                        bestGen = genNum
                                        bestRarity = rarity
                                        bestDist = dist
                                        bestPrompt = child
                                        bestName = petName
                                        bestValue = valStr
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestPrompt, bestName, bestValue
end

function clearBestESP()
    if bestEsp then
        pcall(function() bestEsp:Destroy() end)
        bestEsp = nil
    end
end

local soundIdBest = nil
pcall(function()
    local data = game:HttpGet("https://files.catbox.moe/5o5zso.mp3")
    writefile("best_notify_sound.mp3", data)
    soundIdBest = getcustomasset("best_notify_sound.mp3")
end)
if not soundIdBest then
    soundIdBest = "https://files.catbox.moe/5o5zso.mp3"
end

local function playNotifySoundBest()
    pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = soundIdBest
        sound.Volume = 2
        sound.Parent = Workspace
        sound:Play()
        sound.Ended:Connect(function() sound:Destroy() end)
        task.delay(5, function() if sound then sound:Destroy() end end)
    end)
end

local function showTopNotifyBest(name, value)
    if isNotifyingBest then return end
    isNotifyingBest = true
    for _, g in ipairs(PlayerGui:GetChildren()) do
        if g.Name == "BestBrainrotNotify" then
            pcall(function() g:Destroy() end)
        end
    end
    playNotifySoundBest()

    local gui = Instance.new("ScreenGui")
    gui.Name = "BestBrainrotNotify"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 9999
    gui.IgnoreGuiInset = true
    gui.Parent = PlayerGui

    -- Compact card
    local W, H = 250, 72
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, W, 0, H)
    frame.Position = UDim2.new(0.5, -W/2, 0, -70)
    frame.BackgroundColor3 = Color3.fromRGB(18, 6, 8)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 55, 70)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.15
    stroke.Parent = frame

    -- soft gradient
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 12, 22)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(22, 8, 10)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 12, 22)),
    })
    grad.Rotation = 90
    grad.Parent = frame

    -- left accent bar
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 1, 0)
    accent.BackgroundColor3 = Color3.fromRGB(255, 50, 65)
    accent.BorderSizePixel = 0
    accent.ZIndex = 2
    accent.Parent = frame

    -- preview 3D más grande
    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(0, 58, 0, 58)
    preview.Position = UDim2.new(0, 7, 0.5, -29)
    preview.BackgroundColor3 = Color3.fromRGB(32, 10, 12)
    preview.BorderSizePixel = 0
    preview.ZIndex = 3
    preview.ClipsDescendants = true
    preview.Parent = frame
    Instance.new("UICorner", preview).CornerRadius = UDim.new(0, 10)
    local pStroke = Instance.new("UIStroke")
    pStroke.Color = Color3.fromRGB(255, 90, 100)
    pStroke.Thickness = 1
    pStroke.Transparency = 0.35
    pStroke.Parent = preview

    local vp = Instance.new("ViewportFrame")
    vp.Name = "PetViewport"
    vp.Size = UDim2.new(1, -2, 1, -2)
    vp.Position = UDim2.new(0, 1, 0, 1)
    vp.BackgroundTransparency = 1
    vp.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    vp.BorderSizePixel = 0
    vp.ZIndex = 4
    vp.Parent = preview

    local vpCam = Instance.new("Camera")
    vpCam.Parent = vp
    vp.CurrentCamera = vpCam

    task.spawn(function()
        local plotsFolder = Workspace:FindFirstChild("Plots")
        if not plotsFolder or not name then return end
        local playerNames = {}
        for _, p in pairs(Players:GetPlayers()) do playerNames[p.Name] = true end

        local foundModel = nil
        for _, v in ipairs(plotsFolder:GetDescendants()) do
            if v:IsA("Model") and v.Name == name and not playerNames[v.Name] then
                foundModel = v
                break
            end
        end
        if not foundModel or not vp.Parent then return end

        local clone = foundModel:Clone()
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Highlight") then
                d:Destroy()
            end
        end
        clone.Parent = vp

        local cf, size = clone:GetBoundingBox()
        local dist = math.max(size.Magnitude * 1.35, 2.5)
        local height = size.Y * 0.15

        pcall(function()
            for _, part in ipairs(clone:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
            if clone.PrimaryPart then
                clone:PivotTo(CFrame.new())
            else
                local primary = clone:FindFirstChildWhichIsA("BasePart")
                if primary then
                    clone.PrimaryPart = primary
                    clone:PivotTo(CFrame.new())
                end
            end
        end)

        local angle = 0
        local rotConn
        rotConn = RunService.Heartbeat:Connect(function(dt)
            if not vp.Parent or not gui.Parent then
                if rotConn then rotConn:Disconnect() end
                return
            end
            -- Órbita completa 360° sin voltearse (eje Y)
            angle = (angle + dt * 90) % 360
            local rad = math.rad(angle)
            if clone and clone.Parent then
                pcall(function()
                    clone:PivotTo(CFrame.Angles(0, rad, 0))
                end)
            end
            vpCam.CFrame = CFrame.new(Vector3.new(0, height, dist), Vector3.new(0, height * 0.3, 0))
        end)
        table.insert(ActiveConnections, rotConn)
    end)

    -- badge
    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.new(1, -78, 0, 12)
    badge.Position = UDim2.new(0, 72, 0, 10)
    badge.BackgroundTransparency = 1
    badge.Text = "BEST BRAINROT"
    badge.TextColor3 = Color3.fromRGB(255, 110, 120)
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 9
    badge.TextXAlignment = Enum.TextXAlignment.Left
    badge.ZIndex = 4
    badge.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -78, 0, 20)
    title.Position = UDim2.new(0, 72, 0, 24)
    title.BackgroundTransparency = 1
    title.Text = name or "Pet"
    title.TextColor3 = Color3.fromRGB(255, 235, 235)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextWrapped = true
    title.TextTruncate = Enum.TextTruncate.None
    title.ZIndex = 4
    title.Parent = frame

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(1, -78, 0, 14)
    valLabel.Position = UDim2.new(0, 72, 0, 48)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = "Valor: " .. tostring(value or "?")
    valLabel.TextColor3 = Color3.fromRGB(255, 150, 155)
    valLabel.Font = Enum.Font.Gotham
    valLabel.TextSize = 11
    valLabel.TextXAlignment = Enum.TextXAlignment.Left
    valLabel.ZIndex = 4
    valLabel.Parent = frame

    local down = TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -W/2, 0, 14)
    })
    down:Play()
    down.Completed:Wait()
    task.wait(2.2)
    local up = TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -W/2, 0, -70)
    })
    up:Play()
    up.Completed:Wait()
    if gui then gui:Destroy() end
    isNotifyingBest = false
end

local function updateBestESP()
    if not _G.ESPBestEnabled then
        clearBestESP()
        return
    end
    local prompt, name, value = findBestBrainrotBest()
    if not prompt or not prompt.Parent then
        clearBestESP()
        return
    end
    local adornee = prompt.Parent
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position
    local dist = 0
    if myPos and adornee then
        local pos = adornee:IsA("Attachment") and adornee.WorldPosition or (adornee:IsA("BasePart") and adornee.Position)
        if pos then dist = math.floor((pos - myPos).Magnitude) end
    end

    -- Solo 1 notificacion del que mas dinero da
    if name == _G.__bestPendingName then
        _G.__bestPendingTicks = (_G.__bestPendingTicks or 0) + 1
    else
        _G.__bestPendingName = name
        _G.__bestPendingTicks = 1
    end
    if (_G.__bestPendingTicks or 0) >= 60 and name ~= lastNotifyNameBest and not isNotifyingBest then
        local now = tick()
        if now - (_G.__bestLastNotifyTime or 0) >= 12 then
            lastNotifyNameBest = name
            _G.__bestLastNotifyTime = now
            task.spawn(function()
                showTopNotifyBest(name, value)
            end)
        end
    end

    if not bestEsp or bestEsp.Adornee ~= adornee then
        clearBestESP()
        bestEsp = Instance.new("BillboardGui")
        bestEsp.Name = "BestPetESP"
        bestEsp.Size = UDim2.new(0, 160, 0, 55)
        bestEsp.StudsOffset = Vector3.new(0, 4, 0)
        bestEsp.AlwaysOnTop = true
        bestEsp.MaxDistance = 500
        bestEsp.Adornee = adornee
        bestEsp.Parent = Workspace
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = (name or "Pet") .. "\n" .. (value or "?") .. "\n[" .. dist .. "m]"
        label.TextColor3 = Color3.fromRGB(255, 50, 50)
        label.TextStrokeTransparency = 0.15
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.Parent = bestEsp
    else
        local label = bestEsp:FindFirstChildWhichIsA("TextLabel")
        if label then
            label.Text = (name or "Pet") .. "\n" .. (value or "?") .. "\n[" .. dist .. "m]"
            label.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
end

if bestEspConn then pcall(function() bestEspConn:Disconnect() end) end
bestEspConn = RunService.Heartbeat:Connect(updateBestESP)
_G._175_UpdateBestESP = updateBestESP
_G._175_ClearBestNotify = function()
    lastNotifyNameBest = nil
end

if _G.ESPBestEnabled then
    task.spawn(function() updateBestESP() end)
end
end)



-- ===================== EXTRA FEATURES =====================
task.spawn(function()
local okExtra, errExtra = pcall(function()

-- Backpack ESP
local backpackEspInstances = {}
local function clearBackpackESP()
    for uid, bb in pairs(backpackEspInstances) do
        pcall(function() bb:Destroy() end)
        backpackEspInstances[uid] = nil
    end
end
local function buildBPBillboard(char, hrp, found)
    local ICON, GAP = 40, 3
    local bb = Instance.new("BillboardGui")
    bb.Name = "_BackpackESP"
    bb.Size = UDim2.new(0, ICON, 0, ICON * #found + GAP * math.max(0, #found - 1))
    bb.StudsOffset = Vector3.new(3.2, 0, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = hrp
    bb.MaxDistance = 200
    bb.Parent = char
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Vertical
    lay.HorizontalAlignment = Enum.HorizontalAlignment.Center
    lay.Padding = UDim.new(0, GAP)
    lay.Parent = bb
    for _, data in ipairs(found) do
        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(0, ICON, 0, ICON)
        img.BackgroundTransparency = 1
        img.Image = (data.texture and data.texture ~= "") and data.texture or ""
        img.ScaleType = Enum.ScaleType.Fit
        img.Parent = bb
    end
    return bb
end
local function updateBackpackESP()
    if not _G.BackpackESP then clearBackpackESP() return end
    local active = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                active[plr.UserId] = true
                local found = {}
                local function collect(cont)
                    if not cont then return end
                    for _, tool in ipairs(cont:GetChildren()) do
                        if tool:IsA("Tool") then
                            local n = tool.Name
                            if n == "Giant Potion" and _G.ShowGiantPotion then
                                table.insert(found, {texture = tool.TextureId or ""})
                            elseif (n == "Flash Teleport" or string.find(string.lower(n), "flash")) and _G.ShowFlashTeleport then
                                table.insert(found, {texture = tool.TextureId or ""})
                            elseif (n == "Flying Carpet" or string.find(string.lower(n), "carpet")) and _G.ShowFlyingCarpet then
                                table.insert(found, {texture = tool.TextureId or ""})
                            end
                        end
                    end
                end
                collect(plr:FindFirstChild("Backpack"))
                collect(char)
                if #found == 0 then
                    if backpackEspInstances[plr.UserId] then
                        pcall(function() backpackEspInstances[plr.UserId]:Destroy() end)
                        backpackEspInstances[plr.UserId] = nil
                    end
                else
                    local ex = backpackEspInstances[plr.UserId]
                    if (not ex) or (ex.Parent == nil) or (ex.Adornee ~= hrp) then
                        if ex then pcall(function() ex:Destroy() end) end
                        backpackEspInstances[plr.UserId] = buildBPBillboard(char, hrp, found)
                    end
                end
            end
        end
    end
    for uid, bb in pairs(backpackEspInstances) do
        if not active[uid] then
            pcall(function() bb:Destroy() end)
            backpackEspInstances[uid] = nil
        end
    end
end
_G._175_SetBackpackESP = function(v)
    _G.BackpackESP = v
    if not v then clearBackpackESP() end
end
task.spawn(function()
    while not thisScriptStopped do
        pcall(updateBackpackESP)
        task.wait(1.2)
    end
end)

-- Brainrot Highlight
local brainrotHighlights = {}
local function clearBrainrotHL()
    for k, h in pairs(brainrotHighlights) do
        pcall(function() h:Destroy() end)
        brainrotHighlights[k] = nil
    end
end
local function updateBrainrotHL()
    if not _G.BrainrotHighlight then clearBrainrotHL() return end
    -- Solo el brainrot SELECCIONADO (no todos los slots)
    local prompt = selectedPrompt
    if not prompt or not prompt.Parent then
        clearBrainrotHL()
        return
    end
    local attachment = prompt.Parent
    local spawnPoint = attachment and attachment.Parent
    local podium = spawnPoint and spawnPoint.Parent
    if podium and podium.Name == "Base" then podium = podium.Parent end
    local plot = podium and podium.Parent and podium.Parent
    local slotNumber = selectedSlotNumber or (podium and tonumber(string.match(podium.Name or "", "%d+"))) or 0
    local key = "selected_" .. tostring(slotNumber) .. "_" .. tostring(prompt:GetFullName())
    local seen = { [key] = true }

    local model = nil
    pcall(function()
        local spawnPos = (attachment:IsA("Attachment") and attachment.WorldPosition)
            or (spawnPoint and spawnPoint:IsA("BasePart") and spawnPoint.Position)
        if not spawnPos then return end
        local playerNames = {}
        for _, pl in pairs(Players:GetPlayers()) do playerNames[pl.Name] = true end
        local searchRoot = plot or Workspace
        local bestDist = 8
        for _, v in ipairs(searchRoot:GetDescendants()) do
            if v:IsA("Model") and not playerNames[v.Name] then
                local rp = v.PrimaryPart or v:FindFirstChild("RootPart") or v:FindFirstChildWhichIsA("BasePart")
                if rp then
                    local d = (rp.Position - spawnPos).Magnitude
                    if d < bestDist then
                        bestDist = d
                        model = v
                    end
                end
            end
        end
    end)

    if model then
        local h = brainrotHighlights[key]
        if h and h.Parent and h.Adornee == model then
            -- ok
        else
            if h then pcall(function() h:Destroy() end) end
            h = Instance.new("Highlight")
            h.Name = "_BrainrotHL"
            h.Adornee = model
            h.FillColor = Color3.fromRGB(40, 140, 255)
            h.OutlineColor = Color3.fromRGB(80, 180, 255)
            h.FillTransparency = 0.45
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = model
            brainrotHighlights[key] = h
        end
    end

    for k, h in pairs(brainrotHighlights) do
        if not seen[k] then
            pcall(function() h:Destroy() end)
            brainrotHighlights[k] = nil
        end
    end
end
_G._175_SetBrainrotHL = function(v)
    _G.BrainrotHighlight = v
    if not v then clearBrainrotHL() end
end
task.spawn(function()
    while not thisScriptStopped do
        pcall(updateBrainrotHL)
        task.wait(0.6)
    end
end)

-- Quick AP
local qapGui, qapTextBox, qapMinimized = nil, nil, false
task.spawn(function()
    pcall(function()
        qapTextBox = LocalPlayer.PlayerGui:WaitForChild("AdminPanel", 20)
            :WaitForChild("AdminPanel", 10)
            :WaitForChild("CommandBox", 10)
            :WaitForChild("TextBox", 10)
    end)
end)
local function execCmd(cmd, playerName)
    if not playerName then return end
    if not qapTextBox then
        pcall(function()
            qapTextBox = LocalPlayer.PlayerGui.AdminPanel.AdminPanel.CommandBox.TextBox
        end)
    end
    if not qapTextBox then return end
    local full = ";" .. cmd .. " " .. playerName
    local vis = qapTextBox.Visible
    qapTextBox.Visible = false
    qapTextBox.Text = full
    task.wait(0.04)
    pcall(function()
        if firesignal then firesignal(qapTextBox.FocusLost, true)
        elseif getconnections then
            for _, c in pairs(getconnections(qapTextBox.FocusLost)) do
                if c.Fire then c:Fire(true) elseif c.Function then c.Function(true) end
            end
        else
            qapTextBox:CaptureFocus()
            task.wait(0.02)
            qapTextBox:ReleaseFocus(true)
        end
    end)
    task.wait(0.04)
    qapTextBox.Text = ""
    qapTextBox.Visible = vis
end
local function destroyQAP()
    if qapGui then pcall(function() qapGui:Destroy() end) end
    qapGui = nil
    qapMinimized = false
end
local function createQAP()
    destroyQAP()
    local gui = Instance.new("ScreenGui")
    gui.Name = "175QuickAP"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 1200
    gui.IgnoreGuiInset = true
    pcall(function()
        if gethui then gui.Parent = gethui() else gui.Parent = CoreGui end
    end)
    if not gui.Parent then gui.Parent = PlayerGui end
    qapGui = gui

    -- Morado + azul ligado
    local COL_BG = Color3.fromRGB(28, 10, 18)
    local COL_HDR = Color3.fromRGB(70, 12, 22)
    local COL_ROW = Color3.fromRGB(45, 14, 22)
    local COL_BTN = Color3.fromRGB(90, 22, 35)
    local COL_STROKE = Color3.fromRGB(255, 60, 80)
    local COL_STROKE2 = Color3.fromRGB(255, 255, 255)
    local COL_TEXT = Color3.fromRGB(255, 255, 255)

    local PANEL_W = 168
    local HDR_H = 26
    local ROW_H = 24
    local PAD = 4
    local MIN_H = HDR_H

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, PANEL_W, 0, MIN_H)
    panel.Position = (_G.QapPos) or UDim2.new(0.02, 0, 0.32, 0)
    panel.BackgroundColor3 = COL_BG
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.ClipsDescendants = true
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 8)
    local st = Instance.new("UIStroke")
    st.Thickness = 1.5
    st.Parent = panel
    local stGrad = Instance.new("UIGradient")
    stGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COL_STROKE),
        ColorSequenceKeypoint.new(1, COL_STROKE2)
    })
    stGrad.Parent = st

    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, HDR_H)
    hdr.BackgroundColor3 = COL_HDR
    hdr.BorderSizePixel = 0
    hdr.Parent = panel
    Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 8)
    local hdrGrad = Instance.new("UIGradient")
    hdrGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 12, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 20, 30))
    })
    hdrGrad.Parent = hdr

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -56, 1, 0)
    title.Position = UDim2.new(0, 8, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Quick AP"
    title.TextColor3 = COL_TEXT
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = hdr

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 20, 0, 20)
    minBtn.Position = UDim2.new(1, -46, 0.5, -10)
    minBtn.BackgroundColor3 = Color3.fromRGB(100, 25, 40)
    minBtn.Text = "–"
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 13
    minBtn.BorderSizePixel = 0
    minBtn.Parent = hdr
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -24, 0.5, -10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(100, 25, 40)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 11
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = hdr
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)
    closeBtn.MouseButton1Click:Connect(function()
        _G.QuickAP = false
        destroyQAP()
        pcall(saveSettings)
    end)

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -6, 1, -(HDR_H + 2))
    body.Position = UDim2.new(0, 3, 0, HDR_H + 1)
    body.BackgroundTransparency = 1
    body.Parent = panel

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 3)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = body

    local cmds = {
        {name = "tiny", emoji = "🧍"},
        {name = "jail", emoji = "🔒"},
        {name = "rocket", emoji = "🚀"},
        {name = "ragdoll", emoji = "😵"},
        {name = "balloon", emoji = "🎈"},
    }

    local function resizePanel(nPlayers)
        if qapMinimized then
            panel.Size = UDim2.new(0, PANEL_W, 0, MIN_H)
            body.Visible = false
            return
        end
        body.Visible = true
        if nPlayers <= 0 then
            -- Solo header, sin espacio negro vacío
            panel.Size = UDim2.new(0, PANEL_W, 0, MIN_H)
            body.Visible = false
        else
            local h = HDR_H + 4 + nPlayers * (ROW_H + 3)
            panel.Size = UDim2.new(0, PANEL_W, 0, h)
            body.Visible = true
        end
    end

    local refresh
    minBtn.MouseButton1Click:Connect(function()
        qapMinimized = not qapMinimized
        if qapMinimized then
            minBtn.Text = "+"
            body.Visible = false
            panel.Size = UDim2.new(0, PANEL_W, 0, MIN_H)
        else
            minBtn.Text = "–"
            if refresh then refresh() end
        end
    end)

    local dragging, dragStart, startPos = false, nil, nil
    hdr.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = panel.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            _G.QapPos = panel.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then dragging = false; _G.QapPos = panel.Position; pcall(saveSettings) end
        end
    end)

    refresh = function()
        for _, ch in ipairs(body:GetChildren()) do
            if ch:IsA("Frame") then ch:Destroy() end
        end
        local n = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                n = n + 1
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, ROW_H)
                row.BackgroundColor3 = COL_ROW
                row.BorderSizePixel = 0
                row.LayoutOrder = n
                row.Parent = body
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

                local av = Instance.new("ImageLabel")
                av.Size = UDim2.new(0, 18, 0, 18)
                av.Position = UDim2.new(0, 3, 0.5, -9)
                av.BackgroundColor3 = Color3.fromRGB(60, 20, 30)
                av.BorderSizePixel = 0
                av.Parent = row
                Instance.new("UICorner", av).CornerRadius = UDim.new(1, 0)
                task.spawn(function()
                    pcall(function()
                        av.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    end)
                end)

                local nl = Instance.new("TextLabel")
                nl.Size = UDim2.new(0, 50, 1, 0)
                nl.Position = UDim2.new(0, 24, 0, 0)
                nl.BackgroundTransparency = 1
                nl.Text = plr.DisplayName
                nl.TextColor3 = COL_TEXT
                nl.Font = Enum.Font.Gotham
                nl.TextSize = 10
                nl.TextXAlignment = Enum.TextXAlignment.Left
                nl.TextTruncate = Enum.TextTruncate.AtEnd
                nl.Parent = row

                for ci, cmd in ipairs(cmds) do
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(0, 18, 0, 18)
                    b.Position = UDim2.new(1, -((#cmds - ci + 1) * 20) - 2, 0.5, -9)
                    b.BackgroundColor3 = COL_BTN
                    b.Text = cmd.emoji
                    b.TextColor3 = Color3.new(1,1,1)
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = 11
                    b.BorderSizePixel = 0
                    b.Parent = row
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    b.MouseButton1Click:Connect(function()
                        task.spawn(function() execCmd(cmd.name, plr.Name) end)
                    end)
                end
            end
        end
        resizePanel(n)
    end

    refresh()
    Players.PlayerAdded:Connect(function() task.wait(0.3); if qapGui then refresh() end end)
    Players.PlayerRemoving:Connect(function() task.wait(0.2); if qapGui then refresh() end end)
end
_G._175_SetQuickAP = function(v)
    _G.QuickAP = v
    if v then createQAP() else destroyQAP() end
end

-- Lagger on Flash TP (sistema Kay Hub)
-- Toggle + potencia arrastrable (default 50). Se activa al iniciar Flash TP.
local laggerConn = nil
_G.LaggerPower = _G.LaggerPower or 50

local function startFlashLagger()
    if not _G.LaggerOnFlash then return end
    -- V1 Kay Hub style
    local strength = math.clamp((_G.LaggerPower or 50) / 40, 0.3, 3.0)
    pcall(function()
        settings().Network.IncomingReplicationLag = strength
    end)
    if laggerConn then
        pcall(function() task.cancel(laggerConn) end)
        laggerConn = nil
    end
    laggerConn = task.delay(2.5, function()
        pcall(function() settings().Network.IncomingReplicationLag = 0 end)
        laggerConn = nil
    end)
end

local function stopFlashLagger()
    if laggerConn then
        pcall(function() task.cancel(laggerConn) end)
        laggerConn = nil
    end
    pcall(function() settings().Network.IncomingReplicationLag = 0 end)
end

_G._175_StartFlashLagger = startFlashLagger
_G._175_StopFlashLagger = stopFlashLagger

-- Lagger Bypass V1/V2 (del script con block list)
local laggerBypassRemote, laggerBypassLoop = nil, nil
local flashEquippedBypass, laggerBypassActive = false, false
local function findBlockRemote()
    local names = {
        "SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList",
        "PlayerBlockList","BlockListUpdate","SetBlockedUsers","UpdateBlockedUsers",
        "BlockPlayer","UnblockPlayer"
    }
    local function scan(folder)
        if not folder then return nil end
        for _, name in ipairs(names) do
            local r = folder:FindFirstChild(name)
            if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then return r end
        end
        for _, child in ipairs(folder:GetDescendants()) do
            if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) then
                local n = tostring(child.Name):lower()
                if n:find("block") or n:find("blocklist") then return child end
            end
        end
        return nil
    end
    return scan(game:FindFirstChild("RobloxReplicatedStorage"))
        or scan(ReplicatedStorage)
        or scan(game:GetService("ReplicatedFirst"))
end

local function setIncomingLag(amount)
    pcall(function() settings().Network.IncomingReplicationLag = amount or 0 end)
end

local function buildBlockPayload(power)
    local blockedUsers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(blockedUsers, player.UserId)
        end
    end
    -- Rellenar si hay pocos jugadores
    while #blockedUsers < 8 do
        table.insert(blockedUsers, math.random(1e8, 2e9))
    end
    local main = { BlockedIds = blockedUsers, UserIds = blockedUsers }
    local depth = math.clamp(math.floor((_G.LaggerPower or 80) / 1.5), 50, 250)
    local nested = {{}}
    local current = nested[1]
    for _ = 1, depth do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.clamp(math.floor((power or 80000) / 150), 80, 12000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local function stopLaggerBypass()
    laggerBypassActive = false
    if laggerBypassLoop then pcall(function() task.cancel(laggerBypassLoop) end); laggerBypassLoop = nil end
    setIncomingLag(0)
end

local function startLaggerBypass(duration)
    if not _G.LaggerBypass then return end
    duration = duration or 2.5

    if not laggerBypassRemote then
        laggerBypassRemote = findBlockRemote()
    end

    -- V2: más agresivo (spam rápido + lag alto + payload grande)
    if _G.LaggerVersion == "v2" then
        local powerMul = math.clamp((_G.LaggerPower or 80) / 20, 1.0, 5.0)
        local strength = math.clamp((_G.LaggerPower or 80) / 18, 1.0, 6.0)
        setIncomingLag(strength)
        pcall(function() settings().Network.IncomingReplicationLag = strength end)
        if laggerBypassActive then return end
        laggerBypassActive = true
        if laggerBypassLoop then pcall(function() task.cancel(laggerBypassLoop) end) end
        laggerBypassLoop = task.spawn(function()
            local power = 180000 + math.floor((_G.LaggerPower or 80) * 2500)
            local startTime = tick()
            local waitT = math.clamp(0.04 / powerMul, 0.02, 0.05)
            while laggerBypassActive and _G.LaggerBypass and (tick() - startTime) < duration do
                if laggerBypassRemote then
                    local payload = buildBlockPayload(power)
                    pcall(function()
                        if laggerBypassRemote:IsA("RemoteEvent") then
                            laggerBypassRemote:FireServer(payload)
                            laggerBypassRemote:FireServer(payload)
                        elseif laggerBypassRemote:IsA("RemoteFunction") then
                            laggerBypassRemote:InvokeServer(payload)
                        end
                    end)
                end
                setIncomingLag(strength)
                task.wait(waitT)
            end
            laggerBypassActive = false
            laggerBypassLoop = nil
            setIncomingLag(0)
        end)
        return
    end

    -- V1: controlado por barra de potencia (más estable, potencia variable)
    local pwr = _G.LaggerPower or 50
    local strength = math.clamp(pwr / 35, 0.5, 4.0)
    setIncomingLag(strength)
    if laggerBypassActive then return end
    laggerBypassActive = true
    if laggerBypassLoop then pcall(function() task.cancel(laggerBypassLoop) end) end
    laggerBypassLoop = task.spawn(function()
        local power = 90000 + math.floor(pwr * 1500)
        local startTime = tick()
        local waitT = math.clamp(0.07 - (pwr / 2000), 0.03, 0.07)
        while laggerBypassActive and _G.LaggerBypass and (tick() - startTime) < duration do
            if laggerBypassRemote then
                local payload = buildBlockPayload(power)
                pcall(function()
                    if laggerBypassRemote:IsA("RemoteEvent") then
                        laggerBypassRemote:FireServer(payload)
                    elseif laggerBypassRemote:IsA("RemoteFunction") then
                        laggerBypassRemote:InvokeServer(payload)
                    end
                end)
            end
            setIncomingLag(strength)
            task.wait(waitT)
        end
        laggerBypassActive = false
        laggerBypassLoop = nil
        setIncomingLag(0)
    end)
end
_G._175_StartLagger = startLaggerBypass
_G._175_StopLagger = stopLaggerBypass
local flashToolConn, lastFlashTool = nil, nil
local function hookFlashTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    local n = tool.Name:lower()
    if not (n:find("flash") or n:find("teleport")) then return end
    if lastFlashTool == tool and flashToolConn then return end
    if flashToolConn then pcall(function() flashToolConn:Disconnect() end) end
    lastFlashTool = tool
    flashToolConn = tool.Activated:Connect(function()
        if not _G.LaggerBypass then return end
        task.spawn(function()
            task.wait(0.15)
            stopLaggerBypass()
            flashEquippedBypass = false
        end)
    end)
end
task.spawn(function()
    while not thisScriptStopped do
        task.wait(0.1)
        if not _G.LaggerBypass then
            if laggerBypassActive then stopLaggerBypass() end
            flashEquippedBypass = false
            lastFlashTool = nil
        else
            local char = LocalPlayer.Character
            local equippedTool = nil
            if char then
                for _, child in ipairs(char:GetChildren()) do
                    if child:IsA("Tool") then
                        local n = child.Name:lower()
                        if n:find("flash") or n:find("teleport") then equippedTool = child break end
                    end
                end
            end
            if equippedTool then
                hookFlashTool(equippedTool)
                if not flashEquippedBypass then
                    flashEquippedBypass = true
                    startLaggerBypass(10)
                end
            else
                if flashEquippedBypass then
                    flashEquippedBypass = false
                    stopLaggerBypass()
                end
            end
        end
    end
end)

-- ============================================================
-- ANTI STEAL: texto "Someone is stealing your ..." + delay real + sin lag
-- ============================================================
task.spawn(function()
    local function as_isLaserCape(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        if n:find("gun") or n:find("pistol") or n:find("rifle") then return false end
        if tool.Name == "Laser Cape" then return true end
        if n:find("laser") and n:find("cape") then return true end
        return false
    end

    local function as_findLaserCape()
        local char = LocalPlayer.Character
        local bp = LocalPlayer:FindFirstChild("Backpack")
        for _, container in ipairs({bp, char}) do
            if container then
                local t = container:FindFirstChild("Laser Cape")
                if t and t:IsA("Tool") then return t end
            end
        end
        for _, container in ipairs({bp, char}) do
            if container then
                for _, t in ipairs(container:GetChildren()) do
                    if as_isLaserCape(t) then return t end
                end
            end
        end
        return nil
    end

    local useItemRemote = nil
    local function as_getUseItemRemote()
        if useItemRemote and useItemRemote.Parent then return useItemRemote end
        pcall(function()
            local net = ReplicatedStorage:FindFirstChild("Packages")
            net = net and net:FindFirstChild("Net")
            local re = net and net:FindFirstChild("RE")
            local r = re and re:FindFirstChild("UseItem")
            if r then useItemRemote = r end
        end)
        return useItemRemote
    end

    local function as_fireLaser(targetPlayer)
        if not targetPlayer or not targetPlayer.Character then return end
        local targetPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetPart then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local laserTool = as_findLaserCape()
        if not laserTool then return end
        if laserTool.Parent ~= char then
            pcall(function() hum:UnequipTools() end)
            task.wait(0.05)
            pcall(function() hum:EquipTool(laserTool) end)
            task.wait(0.12)
        end
        if not as_isLaserCape(char:FindFirstChildOfClass("Tool")) then return end
        local pos = targetPart.Position
        local ur = as_getUseItemRemote()
        if ur then
            pcall(function()
                if ur:IsA("RemoteEvent") then ur:FireServer(pos, targetPart)
                elseif ur:IsA("RemoteFunction") then ur:InvokeServer(pos, targetPart) end
            end)
        end
        if aimbotRemote and aimbotFireRemote then
            pcall(function() aimbotFireRemote(aimbotRemote, pos, targetPart) end)
        end
        pcall(function()
            if laserTool.Parent == char then laserTool:Activate() end
        end)
    end

    local function as_fireAP(targetPlayer)
        if not targetPlayer then return end
        local name = targetPlayer.Name
        local ap = _G.AntiStealAP
        if type(ap) ~= "table" then ap = { balloon = true } end
        local order = {"balloon", "ragdoll", "rocket", "jail", "tiny", "inverse", "jumpscare", "morph"}
        local fired = false
        for _, cmd in ipairs(order) do
            if ap[cmd] == true then
                fired = true
                pcall(function()
                    if type(execCmd) == "function" then execCmd(cmd, name) end
                end)
                task.wait(0.12)
            end
        end
        if not fired then
            pcall(function()
                if type(execCmd) == "function" then execCmd("balloon", name) end
            end)
        end
    end

    local function as_getMyBasePos()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local mine = false
            pcall(function()
                if isMyPlot(plot) then mine = true end
            end)
            if not mine then
                pcall(function()
                    local sign = plot:FindFirstChild("PlotSign")
                    if not sign then return end
                    local yb = sign:FindFirstChild("YourBase")
                    if yb and yb:IsA("BillboardGui") and yb.Enabled then mine = true end
                end)
            end
            if mine then
                local ok, cf = pcall(function() return plot:GetBoundingBox() end)
                if ok and cf then return cf.Position end
            end
        end
        return nil
    end

    local function as_findThief()
        local basePos = as_getMyBasePos()
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local stealing = false
                    pcall(function()
                        stealing = p:GetAttribute("Stealing") == true
                            or p:GetAttribute("IsStealing") == true
                            or p.Character:GetAttribute("Stealing") == true
                    end)
                    if stealing then return p end
                    if basePos then
                        local d = (root.Position - basePos).Magnitude
                        if d < bestDist then bestDist = d; best = p end
                    end
                end
            end
        end
        if best and bestDist < 120 then return best end
        return best
    end

    local asBusy = false
    local lastTrigger = 0
    local lastMsg = ""

    local function as_runProtection(srcText)
        if not _G.AntiSteal or thisScriptStopped then return end
        if asBusy then return end
        local now = tick()
        if now - lastTrigger < 3.0 then return end -- anti spam
        -- Evitar re-disparar el mismo mensaje
        if srcText and srcText == lastMsg and (now - lastTrigger) < 8 then return end
        if srcText then lastMsg = srcText end
        lastTrigger = now
        asBusy = true

        -- Capturar delay AHORA (el valor actual del setting)
        local dly = tonumber(_G.AntiStealDelay)
        if not dly or dly ~= dly or dly < 0.3 then dly = 1.8 end
        dly = math.clamp(dly, 0.3, 60)

        task.spawn(function()
            task.wait(dly) -- delay real exacto
            if thisScriptStopped or not _G.AntiSteal then
                asBusy = false
                return
            end
            local thief = as_findThief()
            if thief then
                local mode = tostring(_G.AntiStealMode or "laser"):lower()
                if mode == "ap" then
                    as_fireAP(thief)
                    task.wait(0.15)
                    as_fireAP(thief)
                else
                    as_fireLaser(thief)
                    task.wait(0.25)
                    as_fireLaser(thief)
                end
            end
            task.wait(2)
            asBusy = false
        end)
    end

    local function as_isStealMessage(text)
        if type(text) ~= "string" or #text < 10 then return false end
        local t = text:lower()
        if t:find("someone is stealing your", 1, true) then return true end
        if t:find("is stealing your", 1, true) then return true end
        return false
    end

    local hooked = setmetatable({}, {__mode = "k"})
    local function as_hookLabel(label)
        if not label or hooked[label] then return end
        if not (label:IsA("TextLabel") or label:IsA("TextButton")) then return end
        hooked[label] = true
        pcall(function()
            label:GetPropertyChangedSignal("Text"):Connect(function()
                if not _G.AntiSteal then return end
                local tx = label.Text
                if as_isStealMessage(tx) then
                    as_runProtection(tx)
                end
            end)
            if _G.AntiSteal and as_isStealMessage(label.Text) then
                as_runProtection(label.Text)
            end
        end)
    end

    local function as_scanOnce(root)
        if not root then return end
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                as_hookLabel(d)
            end
        end
    end

    pcall(function() as_scanOnce(PlayerGui) end)
    PlayerGui.DescendantAdded:Connect(function(d)
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            task.defer(as_hookLabel, d)
        end
    end)

    -- Backup MUY ligero cada 1.5s (no cada 0.2s)
    task.spawn(function()
        while not thisScriptStopped do
            task.wait(1.5)
            if _G.AntiSteal then
                pcall(function()
                    for _, d in ipairs(PlayerGui:GetDescendants()) do
                        if d:IsA("TextLabel") and as_isStealMessage(d.Text) then
                            as_runProtection(d.Text)
                            break
                        end
                    end
                end)
            end
        end
    end)
end)

-- Anti Gummy
task.spawn(function()
    task.wait(0.5)
    local function clearGummy(char)
        if not char then return end
        pcall(function()
            if LocalPlayer:GetAttribute("BlockTools") then LocalPlayer:SetAttribute("BlockTools", false) end
            if LocalPlayer:GetAttribute("Web") then LocalPlayer:SetAttribute("Web", false) end
            if char:GetAttribute("BlockTools") then char:SetAttribute("BlockTools", false) end
            if char:GetAttribute("Web") then char:SetAttribute("Web", false) end
            if char:GetAttribute("BackpackReady") == false then char:SetAttribute("BackpackReady", true) end
        end)
    end
    pcall(function()
        workspace.ChildAdded:Connect(function(child)
            if _G.antiGummyEnabled and child.Name == "GummyBear" then
                pcall(function() child:Destroy() end)
            end
        end)
    end)
    while true do
        task.wait(0.2)
        if _G.antiGummyEnabled then
            pcall(clearGummy, LocalPlayer.Character)
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj.Name == "GummyBear" then pcall(function() obj:Destroy() end) end
                end
            end)
        end
    end
end)

if _G.BackpackESP then _G._175_SetBackpackESP(true) end
if _G.BrainrotHighlight then _G._175_SetBrainrotHL(true) end
if _G.QuickAP then task.defer(function() _G._175_SetQuickAP(true) end) end

print("[175] Extra features OK")
end)
if not okExtra then warn("[175] Extra error:", errExtra) end
end)

-- Auto Turret
task.spawn(function()
    local src = [=[
local autoTurretEnabled = _G.AutoTurretEnabled == true
local lp = game:GetService("Players").LocalPlayer
local Workspace = game:GetService("Workspace")
local turretConns = {}
local turretLoopRunning = false
local turretAttackBusy, turretAttackQueued, turretAttackCD = {}, {}, {}
local turretAttackActive = false
local RETRY_DELAY = 0.3
local function isEnemyTurret(obj)
    if not obj or not obj:IsA("BasePart") then return false end
    local ownerId = obj.Name:match("^Sentry_(%d+)$")
    return ownerId ~= nil and ownerId ~= tostring(lp.UserId)
end
local function setTurretNoClip(turret)
    if isEnemyTurret(turret) then pcall(function() turret.CanCollide = false end) end
end
local function getTurretTimeLabel(turret)
    local sf = turret and turret:FindFirstChild("SetupFrame")
    local mf = sf and sf:FindFirstChild("MainFrame")
    local lbl = mf and mf:FindFirstChild("Time")
    return (lbl and lbl:IsA("TextLabel")) and lbl or nil
end
local function shouldAttackTurret(turret)
    if not lp or lp:GetAttribute("Stealing") ~= nil then return false end
    if not isEnemyTurret(turret) then return false end
    setTurretNoClip(turret)
    local lbl = getTurretTimeLabel(turret)
    if not lbl then return false end
    local ok, text = pcall(function() return lbl.Text end)
    if not ok then return false end
    text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
    return text ~= "" and string.find(text, "^%d+s!$") ~= nil
end
local function bringTurretInFront(turret, hrp)
    if not turret or not hrp then return end
    local fwd = hrp.CFrame.LookVector
    local pos = hrp.Position + fwd * 4 + Vector3.new(0, 1.2, 0)
    pcall(function()
        if hrp.AssemblyLinearVelocity ~= nil then hrp.AssemblyLinearVelocity = Vector3.zero end
        turret.CFrame = CFrame.lookAt(pos, pos + fwd)
    end)
end
local function attackTurret(turret)
    local now = tick()
    if turretAttackBusy[turret] or turretAttackQueued[turret] or turretAttackActive then return end
    if not shouldAttackTurret(turret) then return end
    if (turretAttackCD[turret] or 0) > now then return end
    turretAttackQueued[turret] = true
    turretAttackCD[turret] = now + RETRY_DELAY
    task.spawn(function()
        turretAttackQueued[turret] = nil
        if turretAttackActive or turretAttackBusy[turret] then return end
        if not shouldAttackTurret(turret) then return end
        turretAttackActive = true
        turretAttackBusy[turret] = true
        pcall(function()
            local attempts = 0
            while attempts < 12 and autoTurretEnabled do
                if not turret or not turret.Parent or not shouldAttackTurret(turret) then break end
                local char = lp.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum or hum.Health <= 0 then break end
                local okD, dist = pcall(function() return (turret.Position - hrp.Position).Magnitude end)
                if okD and dist > 220 then break end
                setTurretNoClip(turret)
                bringTurretInFront(turret, hrp)
                local bp = lp:FindFirstChild("Backpack")
                local bat = char:FindFirstChild("Bat") or (bp and bp:FindFirstChild("Bat"))
                if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                bat = char:FindFirstChild("Bat") or bat
                if bat then pcall(function() bat:Activate() end) end
                task.wait(0.03)
                attempts = attempts + 1
                task.wait(0.09)
            end
        end)
        turretAttackBusy[turret] = nil
        turretAttackActive = false
    end)
end
local function disconnectAll()
    for i = 1, #turretConns do pcall(function() turretConns[i]:Disconnect() end) end
    turretConns = {}
end
local function startAutoTurret()
    disconnectAll()
    table.insert(turretConns, Workspace.DescendantAdded:Connect(function(obj)
        if isEnemyTurret(obj) then setTurretNoClip(obj) end
        if autoTurretEnabled and shouldAttackTurret(obj) then
            task.spawn(function() attackTurret(obj) end)
        end
    end))
    if not turretLoopRunning then
        turretLoopRunning = true
        task.spawn(function()
            while autoTurretEnabled do
                task.wait(0.4)
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if isEnemyTurret(obj) then setTurretNoClip(obj) end
                    if autoTurretEnabled and shouldAttackTurret(obj) then attackTurret(obj) end
                end
            end
            turretLoopRunning = false
        end)
    end
end
_G._175_AT = function(state)
    autoTurretEnabled = state and true or false
    _G.AutoTurretEnabled = autoTurretEnabled
    if autoTurretEnabled then startAutoTurret() else disconnectAll() end
end
if _G.AutoTurretEnabled == true then _G._175_AT(true) end
print("[175] AutoTurret ready")
]=]
    local fn, err = loadstring(src)
    if fn then pcall(fn) end
end)


-- Auto Return to Base (robusto)
task.spawn(function()
    local BASE_TARGET = Vector3.new(-350.8919, -6.6011, 108.6947)
    local BASE_SPEED = 22
    local BASE_STOP_DIST = 5
    local BASE_SLOW_DIST = 22
    local returnMovement = nil
    local returnActive = false

    local function stopReturnToBase()
        returnActive = false
        if returnMovement then
            pcall(function() returnMovement:Disconnect() end)
            returnMovement = nil
        end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, n in ipairs({"ReturnVelocity", "LinearVelocity", "ReturnAttachment", "Attachment"}) do
                local o = root:FindFirstChild(n)
                if o then pcall(function() o:Destroy() end) end
            end
        end
    end

    local function startReturnToBase()
        if returnActive then return end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum or hum.Health <= 0 then return end

        -- Parar cualquier movimiento de flash
        if currentMovement then
            pcall(function() currentMovement:Disconnect() end)
            currentMovement = nil
        end
        autoStealEnabled = false
        stopReturnToBase()
        returnActive = true

        local savedWalkSpeed = hum.WalkSpeed
        local savedJumpPower = hum.JumpPower
        pcall(function()
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.AutoRotate = false
        end)

        -- Equipar carpet / walk item
        local carpet = nil
        local function findCarpet(container)
            if not container then return nil end
            for _, t in ipairs(container:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("carpet") or n:find("broom") or n:find("waverider") or n:find("sleigh") or n:find("wings") then
                        return t
                    end
                end
            end
            return nil
        end
        carpet = findCarpet(char) or findCarpet(LocalPlayer:FindFirstChild("Backpack"))
        if carpet then
            pcall(function() hum:UnequipTools() end)
            task.wait(0.05)
            pcall(function() hum:EquipTool(carpet) end)
        end

        -- Limpiar velocities viejas
        for _, n in ipairs({"ReturnVelocity", "LinearVelocity", "ReturnAttachment", "Attachment"}) do
            local o = root:FindFirstChild(n)
            if o then pcall(function() o:Destroy() end) end
        end

        local Attachment = Instance.new("Attachment")
        Attachment.Name = "ReturnAttachment"
        Attachment.Parent = root

        local Velocity = Instance.new("LinearVelocity")
        Velocity.Name = "ReturnVelocity"
        Velocity.Attachment0 = Attachment
        Velocity.RelativeTo = Enum.ActuatorRelativeTo.World
        Velocity.MaxForce = math.huge
        Velocity.VectorVelocity = Vector3.zero
        Velocity.Parent = root

        local floatStartTime = os.clock()
        local function restore()
            pcall(function()
                if hum and hum.Parent then
                    hum.WalkSpeed = savedWalkSpeed
                    hum.JumpPower = savedJumpPower
                    hum.AutoRotate = true
                end
            end)
            pcall(function() if Velocity then Velocity:Destroy() end end)
            pcall(function() if Attachment then Attachment:Destroy() end end)
        end

        local WAYPOINT = Vector3.new(-348.2184, -6.6011, 7.1711)
        local slot = selectedSlotNumber
        local useWaypoint = slot and slot >= 1 and slot <= 10
        local waypointReached = not useWaypoint

        returnMovement = RunService.Heartbeat:Connect(function()
            if thisScriptStopped or not returnActive then
                restore(); stopReturnToBase(); return
            end
            if not root or not root.Parent or not hum or hum.Health <= 0 then
                restore(); stopReturnToBase(); return
            end

            local rootPos = root.Position

            -- Fase 1: waypoint (slots 1-10)
            if not waypointReached then
                local wpDir = Vector3.new(WAYPOINT.X - rootPos.X, 0, WAYPOINT.Z - rootPos.Z)
                local wpDist = wpDir.Magnitude
                if wpDist <= BASE_STOP_DIST then
                    waypointReached = true
                else
                    local floatY = math.sin((os.clock() - floatStartTime) * 2) * 1.5
                    local targetY = WAYPOINT.Y + 3 + floatY
                    local vertVel = math.clamp((targetY - rootPos.Y) * 3, -8, 8)
                    local sm = wpDist < BASE_SLOW_DIST and math.max(0.25, wpDist / BASE_SLOW_DIST) or 1
                    if wpDir.Magnitude > 0.1 then
                        Velocity.VectorVelocity = Vector3.new(wpDir.Unit.X * BASE_SPEED * sm, vertVel, wpDir.Unit.Z * BASE_SPEED * sm)
                    end
                    return
                end
            end

            -- Fase 2: base
            local dir2D = Vector3.new(BASE_TARGET.X - rootPos.X, 0, BASE_TARGET.Z - rootPos.Z)
            local dist = dir2D.Magnitude
            if dist <= BASE_STOP_DIST then
                Velocity.VectorVelocity = Vector3.zero
                pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
                pcall(function() root.CFrame = CFrame.new(BASE_TARGET) end)
                restore()
                stopReturnToBase()
                return
            end

            local floatY = math.sin((os.clock() - floatStartTime) * 2) * 1.5
            local targetY = BASE_TARGET.Y + 3 + floatY
            local vertVel = math.clamp((targetY - rootPos.Y) * 3, -8, 8)
            local sm = dist < BASE_SLOW_DIST and math.max(0.25, dist / BASE_SLOW_DIST) or 1
            if dir2D.Magnitude > 0.1 then
                Velocity.VectorVelocity = Vector3.new(dir2D.Unit.X * BASE_SPEED * sm, vertVel, dir2D.Unit.Z * BASE_SPEED * sm)
            end
        end)
    end

    _G._175_StartReturnBase = startReturnToBase
    _G._175_StopReturnBase = stopReturnToBase

    -- Watcher global del atributo Stealing (por si el del trip no lo captura)
    local function isOnOwnPlotRough()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        -- cerca de la base propia (BASE_TARGET)
        local d = (root.Position - BASE_TARGET).Magnitude
        if d < 55 then return true end
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return false end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local yb = sign and sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then
                local ok, cf = pcall(function() return plot:GetPivot() end)
                if ok and cf and (root.Position - cf.Position).Magnitude < 90 then
                    return true
                end
            end
        end
        return false
    end

    local function shouldAutoReturn()
        if not _G.AutoReturnBase or thisScriptStopped then return false end
        local stealing = false
        pcall(function()
            stealing = LocalPlayer:GetAttribute("Stealing") == true
                or LocalPlayer:GetAttribute("IsStealing") == true
        end)
        if not stealing then return false end
        -- NO volver si estás agarrando de tu propio plot
        if isOnOwnPlotRough() then return false end
        return true
    end

    table.insert(ActiveConnections, LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
        if not shouldAutoReturn() then return end
        task.defer(function()
            if shouldAutoReturn() and not returnActive then
                startReturnToBase()
            end
        end)
    end))
end)

-- Recover GUIs (R) — resetea posiciones a las originales
task.spawn(function()
    task.wait(0.3)

    -- Posiciones originales
    local MAIN_POS = UDim2.new(0.5, 0, 0.5, 0)          -- centro
    local SETTINGS_POS = UDim2.new(0.5, 0, 0.5, 0)      -- centro
    local BRAINROTS_POS = UDim2.new(0.5, -120, 0.5, 0)  -- un poco a la izquierda
    local RBTN_POS = UDim2.new(1, -36, 0.5, -14)        -- derecha centro

    local function recoverAll()
        pcall(function()
            -- Main GUI
            local main = PlayerGui:FindFirstChild("HUGO_SCRIPT_GUI")
            if main then
                main.Enabled = true
                for _, fr in ipairs(main:GetDescendants()) do
                    if fr:IsA("Frame") and fr.Name == "Border" then
                        fr.Visible = true
                        fr.AnchorPoint = Vector2.new(0.5, 0.5)
                        fr.Position = MAIN_POS
                    end
                end
            end

            -- Settings float
            local sf = PlayerGui:FindFirstChild("175SettingsFloat")
            if sf then
                sf.Enabled = true
                local b = sf:FindFirstChild("Border")
                if b then
                    b.Visible = true
                    b.AnchorPoint = Vector2.new(0.5, 0.5)
                    b.Position = SETTINGS_POS
                end
            end

            -- Brainrots float
            local bf = PlayerGui:FindFirstChild("175BrainrotsFloat")
            if bf then
                bf.Enabled = true
                local b = bf:FindFirstChild("Border")
                if b then
                    b.Visible = true
                    b.AnchorPoint = Vector2.new(0.5, 0.5)
                    b.Position = BRAINROTS_POS
                end
            end

            -- Recover button itself
            local rg = PlayerGui:FindFirstChild("175RecoverBtn")
            if rg then
                local rb = rg:FindFirstChildWhichIsA("TextButton")
                if rb then rb.Position = RBTN_POS end
            end

            -- Banner si existe
            local banner = PlayerGui:FindFirstChild("HugoHubBanner")
            if banner then
                banner.Enabled = true
            end
        end)
        print("[175] GUIs restablecidas a posición original (R)")
    end

    _G._175_RecoverGUIs = recoverAll

    pcall(function()
        if RecoverHdrBtn then
            RecoverHdrBtn.MouseButton1Click:Connect(recoverAll)
        end
    end)

    -- Botón R flotante siempre visible
    local RGui = Instance.new("ScreenGui")
    RGui.Name = "175RecoverBtn"
    RGui.ResetOnSpawn = false
    RGui.DisplayOrder = 2000
    RGui.Parent = PlayerGui
    local RBtn = Instance.new("TextButton")
    RBtn.Size = UDim2.new(0, 28, 0, 28)
    RBtn.Position = RBTN_POS
    RBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    RBtn.Text = "R"
    RBtn.TextColor3 = Color3.fromRGB(224, 198, 100)
    RBtn.TextSize = 14
    RBtn.Font = Enum.Font.GothamBold
    RBtn.BorderSizePixel = 0
    RBtn.Parent = RGui
    Instance.new("UICorner", RBtn).CornerRadius = UDim.new(0, 8)
    local rs = Instance.new("UIStroke", RBtn)
    rs.Color = Color3.fromRGB(196, 168, 60)
    rs.Thickness = 1.2
    RBtn.MouseButton1Click:Connect(recoverAll)

    local dragging, dragStart, startPos
    RBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = RBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            RBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end)




-- ============================================================




-- Sangre goteando en paneles GUI tras la intro
local function dripBloodOnGuiRoot(root, duration)
    if not root or not root.Parent then return end
    duration = duration or 3.2
    pcall(function()
        local old = root:FindFirstChild("175_BloodDrip")
        if old then old:Destroy() end
        local layer = Instance.new("Frame")
        layer.Name = "175_BloodDrip"
        layer.Size = UDim2.fromScale(1, 1)
        layer.BackgroundTransparency = 1
        layer.ClipsDescendants = true
        layer.ZIndex = 100
        layer.BorderSizePixel = 0
        layer.Parent = root

        -- velo rojo suave
        local veil = Instance.new("Frame")
        veil.Size = UDim2.fromScale(1, 1)
        veil.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        veil.BackgroundTransparency = 1
        veil.BorderSizePixel = 0
        veil.ZIndex = 100
        veil.Parent = layer
        TweenService:Create(veil, TweenInfo.new(0.35), { BackgroundTransparency = 0.72 }):Play()

        -- borde superior goteando (línea de sangre)
        local topBleed = Instance.new("Frame")
        topBleed.Size = UDim2.new(1, 0, 0, 4)
        topBleed.Position = UDim2.new(0, 0, 0, 0)
        topBleed.BackgroundColor3 = Color3.fromRGB(160, 0, 15)
        topBleed.BorderSizePixel = 0
        topBleed.ZIndex = 101
        topBleed.Parent = layer
        Instance.new("UIGradient", topBleed).Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 0.3),
        })

        local n = 14
        for i = 1, n do
            local drop = Instance.new("Frame")
            local w = math.random(2, 6)
            local h = math.random(10, 28)
            local x = (i - 0.5) / n + (math.random() - 0.5) * 0.04
            drop.Size = UDim2.new(0, w, 0, h)
            drop.AnchorPoint = Vector2.new(0.5, 0)
            drop.Position = UDim2.new(math.clamp(x, 0.03, 0.97), 0, 0, -2)
            drop.BackgroundColor3 = Color3.fromRGB(math.random(130, 190), math.random(0, 12), math.random(0, 20))
            drop.BorderSizePixel = 0
            drop.ZIndex = 102
            drop.Parent = layer
            Instance.new("UICorner", drop).CornerRadius = UDim.new(1, 0)

            local fall = 0.9 + math.random() * 1.6
            local yEnd = 0.55 + math.random() * 0.5
            task.delay(math.random() * 0.45, function()
                if not drop.Parent then return end
                TweenService:Create(drop, TweenInfo.new(fall, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(drop.Position.X.Scale, 0, yEnd, 0),
                    Size = UDim2.new(0, w, 0, h + math.random(4, 14)),
                    BackgroundTransparency = 0.4
                }):Play()
            end)
        end

        -- manchas en esquinas
        for _, corner in ipairs({
            UDim2.new(0.05, 0, 0.08, 0),
            UDim2.new(0.92, 0, 0.1, 0),
            UDim2.new(0.1, 0, 0.85, 0),
            UDim2.new(0.88, 0, 0.8, 0),
        }) do
            local blot = Instance.new("Frame")
            blot.AnchorPoint = Vector2.new(0.5, 0.5)
            blot.Position = corner
            blot.Size = UDim2.new(0, math.random(10, 18), 0, math.random(8, 14))
            blot.BackgroundColor3 = Color3.fromRGB(140, 0, 10)
            blot.BackgroundTransparency = 0.35
            blot.BorderSizePixel = 0
            blot.Rotation = math.random(-30, 30)
            blot.ZIndex = 101
            blot.Parent = layer
            Instance.new("UICorner", blot).CornerRadius = UDim.new(1, 0)
            TweenService:Create(blot, TweenInfo.new(duration * 0.9), { BackgroundTransparency = 1 }):Play()
        end

        task.delay(duration * 0.75, function()
            if not layer.Parent then return end
            for _, d in ipairs(layer:GetDescendants()) do
                if d:IsA("Frame") then
                    TweenService:Create(d, TweenInfo.new(0.7), { BackgroundTransparency = 1 }):Play()
                end
            end
            TweenService:Create(veil, TweenInfo.new(0.7), { BackgroundTransparency = 1 }):Play()
        end)
        task.delay(duration + 0.2, function()
            pcall(function() layer:Destroy() end)
        end)
    end)
end

local function bloodDripAllPanels()
    task.spawn(function()
        local parents = {}
        pcall(function() table.insert(parents, PlayerGui) end)
        pcall(function() if gethui then table.insert(parents, gethui()) end end)
        pcall(function() table.insert(parents, CoreGui) end)
        local names = {
            "FlashBlock",
            "HugoHubBanner",
            "175SettingsFloat",
            "175BrainrotsFloat",
            "DropBrainrotGui",
        }
        for _, parent in ipairs(parents) do
            if parent then
                for _, name in ipairs(names) do
                    local g = parent:FindFirstChild(name)
                    if g then
                        -- aplicar al frame principal si existe
                        local target = g
                        local win = g:FindFirstChild("Win") or g:FindFirstChild("Frame") or g:FindFirstChildWhichIsA("Frame")
                        if win then target = win end
                        -- también en border frames
                        dripBloodOnGuiRoot(target, 3.4)
                        for _, ch in ipairs(g:GetChildren()) do
                            if ch:IsA("Frame") and (ch.Name == "Border" or ch.Name == "BorderFrame" or ch.Name == "BBorder" or ch.Name == "Win" or ch.Name == "BWin") then
                                dripBloodOnGuiRoot(ch, 3.4)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- 175 W STEAL (webhook fiable + foto Fandom + gen $)
-- ============================================================
task.spawn(function()
    local HttpService = game:GetService("HttpService")
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local HttpRequest = (syn and syn.request) or (http and http.request) or http_request or request
    local MUSIC_TRACKS = {
        { url = "https://files.catbox.moe/qlr4z3.mp3", file = "175_steal_01.mp3" },
        { url = "https://files.catbox.moe/37hakk.mp3", file = "175_steal_02.mp3" },
        { url = "https://files.catbox.moe/9ojmn8.mp3", file = "175_steal_03.mp3" },
        { url = "https://files.catbox.moe/n1gj2a.mp3", file = "175_steal_04.mp3" },
        { url = "https://files.catbox.moe/k5776i.mp3", file = "175_steal_05.mp3" },
        { url = "https://files.catbox.moe/qet7lp.mp3", file = "175_steal_06.mp3" },
        { url = "https://files.catbox.moe/07eyu5.mp3", file = "175_steal_07.mp3" },
        { url = "https://files.catbox.moe/d44vwl.mp3", file = "175_steal_08.mp3" },
        { url = "https://files.catbox.moe/5opsou.mp3", file = "175_steal_09.mp3" },
        { url = "https://files.catbox.moe/4v2g64.mp3", file = "175_steal_10.mp3" },
    }
    local MUSIC_DURATION = 20
    local lastMusicIndex = 0
    local MUSIC_STATE_FILE = "175_steal_last_music.json"
    pcall(function()
        if isfile and isfile(MUSIC_STATE_FILE) and readfile then
            local d = HttpService:JSONDecode(readfile(MUSIC_STATE_FILE))
            if type(d) == "table" and tonumber(d.last) then
                lastMusicIndex = tonumber(d.last) or 0
            end
        end
    end)
    local COOLDOWN = 10
    local FANDOM_BASE = "https://stealabrainrot.fandom.com/wiki/"

    local ready = false
    local busy = false
    local introPlaying = false
    local lastSentTick = 0
    local lastKey = ""
    local imgCache = {}

    -- Animals data (gen $)
    local AnimalsData, AnimalsShared
    pcall(function()
        AnimalsData = require(ReplicatedStorage:WaitForChild("Datas"):WaitForChild("Animals"))
        AnimalsShared = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Animals"))
    end)

    local function getParent()
        local ok, r = pcall(function()
            if gethui then return gethui() end
            return CoreGui
        end)
        if ok and r then return r end
        return PlayerGui
    end

    local function cleanName(name)
        if not name then return nil end
        name = tostring(name):gsub("<[^>]+>", "")
        name = name:gsub("→", ""):gsub("←", ""):gsub("⇒", "")
        name = name:gsub("[%z\1-\31]", "")
        name = name:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
        name = name:gsub("[%.%!%?]+$", "")
        if #name < 2 then return nil end
        return name
    end

    local function parseYouStole(text)
        if type(text) ~= "string" or #text < 9 then return nil end
        local lower = text:lower()
        if lower:find("stealing your", 1, true) or lower:find("someone is stealing", 1, true) then
            return nil
        end
        if not lower:find("you stole", 1, true) and not lower:find("robaste", 1, true) then
            return nil
        end
        local name = text:match("[Yy]ou%s+[Ss]tole%s+(.+)") or text:match("[Rr]obaste%s+(.+)")
        if not name then return nil end
        return cleanName(name:match("([^\n\r]+)") or name)
    end

    local function formatNumber(n)
        if not n or n == 0 then return "?" end
        local function clean(s) return s:gsub("%.?0+$", "") end
        if n >= 1e12 then return "$" .. clean(string.format("%.2f", n/1e12)) .. "T/s" end
        if n >= 1e9  then return "$" .. clean(string.format("%.2f", n/1e9))  .. "B/s" end
        if n >= 1e6  then return "$" .. clean(string.format("%.2f", n/1e6))  .. "M/s" end
        if n >= 1e3  then return "$" .. clean(string.format("%.2f", n/1e3))  .. "K/s" end
        return "$" .. tostring(math.floor(n)) .. "/s"
    end

    local function findAnimalIndex(displayName)
        if not AnimalsData or not displayName then return nil end
        local lower = displayName:lower()
        for index, info in pairs(AnimalsData) do
            if type(info) == "table" and info.DisplayName then
                if info.DisplayName == displayName or tostring(info.DisplayName):lower() == lower then
                    return index, info
                end
            end
        end
        -- partial
        for index, info in pairs(AnimalsData) do
            if type(info) == "table" and info.DisplayName then
                if tostring(info.DisplayName):lower():find(lower, 1, true) or lower:find(tostring(info.DisplayName):lower(), 1, true) then
                    return index, info
                end
            end
        end
        return nil, nil
    end

    local function getGenString(displayName)
        local index, info = findAnimalIndex(displayName)
        if not index then return "?", nil end
        local genVal = 0
        pcall(function()
            if AnimalsShared and AnimalsShared.GetGeneration then
                genVal = AnimalsShared:GetGeneration(index, nil, nil, nil) or 0
            end
        end)
        if (not genVal or genVal == 0) and info then
            genVal = info.Generation or info.Income or info.Cash or 0
        end
        return formatNumber(genVal), index
    end

    -- Misma lógica Fandom del logger (3 reintentos)
    local function fetchFandomImageUrl(displayName)
        if not displayName or not HttpRequest then return nil end
        if imgCache[displayName] ~= nil then
            local v = imgCache[displayName]
            return v ~= false and v or nil
        end
        local wikiName = (displayName:match("^(.-)%s*%(") or displayName):gsub(" ", "_")
        local url = FANDOM_BASE .. wikiName
        for attempt = 1, 3 do
            local ok, response = pcall(function()
                return HttpRequest({
                    Url = url,
                    Method = "GET",
                    Headers = {
                        ["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                        ["Accept"] = "text/html,application/xhtml+xml",
                        ["Accept-Language"] = "en-US,en;q=0.5",
                        ["Cache-Control"] = "no-cache",
                    },
                })
            end)
            if ok and response then
                local code = response.StatusCode or response.status or response.Status or 0
                local body = response.Body or response.body or response.Data or ""
                if (code == 200 or code == 0) and body ~= "" then
                    local ogImage = body:match('property="og:image"%s+content="([^"]+)"')
                        or body:match('content="([^"]+)"%s+property="og:image"')
                        or body:match('<meta%s+property="og:image"%s+content="([^"]+)"')
                    if ogImage and ogImage ~= "" then
                        ogImage = ogImage:gsub("&amp;", "&")
                        if ogImage:find("^https?://") then
                            imgCache[displayName] = ogImage
                            return ogImage
                        end
                    end
                    -- static.wikia fallback
                    local found = body:match('src="(https://static%.wikia%.nocookie%.net[^"]+%.png[^"]*)"')
                        or body:match('data%-src="(https://static%.wikia%.nocookie%.net[^"]+)"')
                    if found then
                        found = found:gsub("/revision/latest.*", "")
                        imgCache[displayName] = found
                        return found
                    end
                    break
                end
            end
            if attempt < 3 then task.wait(0.4 * attempt) end
        end
        imgCache[displayName] = false
        return nil
    end

    local currentStealSound = nil
    local function loadTrackAsset(track)
        if not track then return nil end
        local MUSIC_URL = track.url
        local MUSIC_FILE = track.file
        -- Si el archivo cache está roto/pequeño, borrar y re-descargar
        pcall(function()
            if isfile and isfile(MUSIC_FILE) and getfsize then
                local sz = getfsize(MUSIC_FILE)
                if type(sz) == "number" and sz < 5000 then
                    if delfile then delfile(MUSIC_FILE) end
                end
            end
        end)
        local asset
        pcall(function()
            if isfile and isfile(MUSIC_FILE) and getcustomasset then
                asset = getcustomasset(MUSIC_FILE)
            end
        end)
        if asset and asset ~= "" then return asset end
        local data
        -- Varios métodos de descarga
        for _ = 1, 2 do
            data = nil
            pcall(function()
                if HttpRequest then
                    local r = HttpRequest({
                        Url = MUSIC_URL,
                        Method = "GET",
                        Headers = { ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "*/*" },
                    })
                    local code = r and (r.StatusCode or r.status or r.Status or 0) or 0
                    if code == 200 or code == 0 then
                        data = r.Body or r.body or r.Data
                    end
                end
            end)
            if (not data or #tostring(data) < 5000) then
                pcall(function() data = game:HttpGet(MUSIC_URL) end)
            end
            if data and #tostring(data) > 5000 then
                -- evitar HTML de error
                local head = tostring(data):sub(1, 40):lower()
                if not (head:find("<!doctype") or head:find("<html") or head:find("<?xml")) then
                    pcall(function() if writefile then writefile(MUSIC_FILE, data) end end)
                    pcall(function() if getcustomasset then asset = getcustomasset(MUSIC_FILE) end end)
                    if asset and asset ~= "" then return asset end
                end
            end
            task.wait(0.15)
        end
        -- Fallback: URL directa (algunos executors la aceptan en SoundId)
        return MUSIC_URL
    end
    local function playMusic()
        -- Orden fijo 1→10 y reinicia; si falla una pista, prueba la siguiente
        local n = #MUSIC_TRACKS
        local tries = 0
        local s = nil
        while tries < n do
            tries = tries + 1
            local idx = (tonumber(lastMusicIndex) or 0) + 1
            if idx > n then idx = 1 end
            lastMusicIndex = idx
            pcall(function()
                if writefile then
                    writefile(MUSIC_STATE_FILE, HttpService:JSONEncode({ last = idx }))
                end
            end)
            local track = MUSIC_TRACKS[idx]
            local asset = loadTrackAsset(track)
            if not asset or asset == "" then
                -- salta a la siguiente
            else
                pcall(function()
                    local o = SoundService:FindFirstChild("175_StealMusic")
                    if o then o:Stop() o:Destroy() end
                    local o2 = Workspace:FindFirstChild("175_StealMusic")
                    if o2 then o2:Stop() o2:Destroy() end
                end)
                s = Instance.new("Sound")
                s.Name = "175_StealMusic"
                s.SoundId = asset
                s.Volume = 3
                s.Looped = false
                s.PlaybackSpeed = 1
                -- Parent a Workspace a veces suena mejor que SoundService
                s.Parent = Workspace
                currentStealSound = s
                local played = false
                pcall(function()
                    if not s.IsLoaded then
                        local t0 = os.clock()
                        while not s.IsLoaded and os.clock() - t0 < 0.8 do
                            task.wait(0.04)
                        end
                    end
                    s.Volume = 3.5
                    s:Play()
                    -- Si no suena, reintenta con URL directa
                    task.wait(0.12)
                    if not s.IsPlaying and track and track.url then
                        s.SoundId = track.url
                        s:Play()
                    end
                    played = s.IsPlaying or true
                end)
                if played then
                    -- Deja que suene hasta el final natural (no cortar a 20s)
                    pcall(function()
                        s.Ended:Connect(function()
                            pcall(function() if s and s.Parent then s:Destroy() end end)
                            if currentStealSound == s then currentStealSound = nil end
                        end)
                    end)
                    -- Safety si Ended no dispara
                    task.delay(math.max(MUSIC_DURATION, 90), function()
                        pcall(function()
                            if s and s.Parent and not s.IsPlaying then
                                s:Destroy()
                            elseif s and s.Parent and s.TimeLength > 0 and s.TimePosition >= s.TimeLength - 0.2 then
                                s:Stop()
                                s:Destroy()
                            end
                        end)
                        if currentStealSound == s and (not s or not s.Parent or not s.IsPlaying) then
                            currentStealSound = nil
                        end
                    end)
                    return s
                else
                    pcall(function() if s then s:Destroy() end end)
                    s = nil
                end
            end
        end
        return s
    end

local function playIntro(brainrotName)
        if introPlaying then return end
        introPlaying = true
        -- Música en paralelo para que la intro salga YA
        local musicSound = nil
        task.spawn(function()
            musicSound = playMusic()
        end)
        local parent = getParent()
        pcall(function()
            local old = parent:FindFirstChild("175_StealIntro")
            if old then old:Destroy() end
        end)

        -- Misma foto de la boca (centrada como en panel Brainrots)
        local IMAGE_ID = "rbxassetid://120361169727304"

        local sg = Instance.new("ScreenGui")
        sg.Name = "175_StealIntro"
        sg.IgnoreGuiInset = true
        sg.DisplayOrder = 9999
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        pcall(function()
            if syn and syn.protect_gui then syn.protect_gui(sg) end
        end)
        local parented = false
        pcall(function() if gethui then sg.Parent = gethui() parented = true end end)
        if not parented then pcall(function() sg.Parent = game:GetService("CoreGui") parented = sg.Parent ~= nil end) end
        if not parented then sg.Parent = parent end

        -- Fondo ROJO + boca VTRX en el CENTRO
        local background = Instance.new("Frame")
        background.Size = UDim2.fromScale(1, 1)
        background.BackgroundColor3 = Color3.fromRGB(12, 0, 0)
        background.BorderSizePixel = 0
        background.ClipsDescendants = true
        background.Parent = sg

        -- Sombra 3D detrás
        local shadow = Instance.new("ImageLabel")
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.Position = UDim2.fromScale(0.52, 0.54)
        shadow.Size = UDim2.fromScale(1.08, 1.08)
        shadow.BackgroundTransparency = 1
        shadow.Image = IMAGE_ID
        shadow.ImageColor3 = Color3.fromRGB(80, 0, 0)
        shadow.ImageTransparency = 1
        shadow.ScaleType = Enum.ScaleType.Crop
        shadow.Rotation = -6
        shadow.ZIndex = 1
        shadow.Parent = background

        local image = Instance.new("ImageLabel")
        image.AnchorPoint = Vector2.new(0.5, 0.5)
        image.Position = UDim2.fromScale(0.5, 0.5)
        image.Size = UDim2.fromScale(1.05, 1.05)
        image.BackgroundTransparency = 1
        image.Image = IMAGE_ID
        image.ImageTransparency = 1
        image.ScaleType = Enum.ScaleType.Crop
        image.Rotation = -3
        image.ZIndex = 2
        image.Parent = background

        local dark = Instance.new("Frame")
        dark.Size = UDim2.fromScale(1, 1)
        dark.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
        dark.BackgroundTransparency = 0.4
        dark.BorderSizePixel = 0
        dark.ZIndex = 3
        dark.Parent = background

        local function label(text, size, y, color, z)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.94, 0, 0, size + 14)
            lbl.Position = UDim2.new(0.03, 0, y, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = size
            lbl.TextColor3 = color
            lbl.TextTransparency = 1
            lbl.TextStrokeTransparency = 0.25
            lbl.ZIndex = z or 10
            lbl.Parent = sg
            return lbl
        end
        local function deepText(text, size, y, color)
            local back = label(text, size, y, Color3.fromRGB(120, 0, 20), 8)
            back.Position = UDim2.new(0.03, 4, y, 4)
            local mid = label(text, size, y, Color3.fromRGB(220, 25, 45), 9)
            mid.Position = UDim2.new(0.03, 2, y, 2)
            return label(text, size, y, color, 10), mid, back
        end

        local w1, w2, w3 = deepText("W  STEAL", 50, 0.22, Color3.fromRGB(255, 220, 220))
        local you = label("YOU STOLE", 24, 0.34, Color3.fromRGB(255, 90, 90), 10)
        local nm = label(tostring(brainrotName or ""), 36, 0.42, Color3.fromRGB(255, 255, 255), 10)
        nm.TextScaled = true
        nm.Size = UDim2.new(0.9, 0, 0, 50)
        nm.Position = UDim2.new(0.05, 0, 0.42, 0)
        local m1 = label("175 ON TOP  ·  GGS", 18, 0.54, Color3.fromRGB(255, 180, 100), 10)
        local m2 = label("LOCKED  ·  COOKED  ·  DONE", 16, 0.60, Color3.fromRGB(255, 140, 140), 10)
        local m3 = label("KEEP GOING  ·  STAY DANGEROUS", 15, 0.66, Color3.fromRGB(255, 200, 180), 10)
        local m4 = label("175  ·  NEVER MISS  ·  ALWAYS WIN", 14, 0.72, Color3.fromRGB(220, 100, 110), 10)

        -- Fade-in lento (no de golpe)
        local FADE = 2.4
        local allLabels = {w3, w2, w1, you, nm, m1, m2, m3, m4}
        background.BackgroundTransparency = 1
        image.ImageTransparency = 1
        shadow.ImageTransparency = 1
        dark.BackgroundTransparency = 1
        for _, lbl in ipairs(allLabels) do
            lbl.TextTransparency = 1
            lbl.TextStrokeTransparency = 1
        end
        TweenService:Create(background, TweenInfo.new(FADE * 0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(image, TweenInfo.new(FADE, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ImageTransparency = 0.1
        }):Play()
        TweenService:Create(shadow, TweenInfo.new(FADE, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            ImageTransparency = 0.55
        }):Play()
        TweenService:Create(dark, TweenInfo.new(FADE * 0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.35
        }):Play()
        for i, lbl in ipairs(allLabels) do
            task.delay((i - 1) * 0.08, function()
                TweenService:Create(lbl, TweenInfo.new(FADE * 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    TextTransparency = 0,
                    TextStrokeTransparency = 0.25
                }):Play()
            end)
        end

        -- Botón SKIP pequeño (esquina)
        local skipBtn = Instance.new("TextButton")
        skipBtn.Size = UDim2.new(0, 56, 0, 26)
        skipBtn.Position = UDim2.new(1, -68, 0, 18)
        skipBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
        skipBtn.BackgroundTransparency = 0.25
        skipBtn.BorderSizePixel = 0
        skipBtn.Text = "SKIP"
        skipBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
        skipBtn.TextSize = 12
        skipBtn.Font = Enum.Font.GothamBold
        skipBtn.ZIndex = 50
        skipBtn.Parent = sg
        Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 6)
        local skipStroke = Instance.new("UIStroke")
        skipStroke.Color = Color3.fromRGB(255, 80, 90)
        skipStroke.Thickness = 1
        skipStroke.Parent = skipBtn

        -- Vibración al ritmo de la música (PlaybackLoudness)
        local introAlive = true
        -- Se va lento (fade-out ~2.2s); la música SIGUE hasta el final
        local FADE_OUT = 2.2
        local function spawnBloodRain()
            -- Sangre cayendo al cerrar la intro (detalle gore rojo)
            pcall(function()
                local layer = Instance.new("Frame")
                layer.Name = "BloodRain"
                layer.Size = UDim2.fromScale(1, 1)
                layer.BackgroundTransparency = 1
                layer.ClipsDescendants = true
                layer.ZIndex = 40
                layer.Parent = sg

                -- velo rojo suave
                local veil = Instance.new("Frame")
                veil.Size = UDim2.fromScale(1, 1)
                veil.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
                veil.BackgroundTransparency = 1
                veil.BorderSizePixel = 0
                veil.ZIndex = 39
                veil.Parent = layer
                TweenService:Create(veil, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 0.55
                }):Play()

                for i = 1, 28 do
                    local drop = Instance.new("Frame")
                    local w = math.random(3, 9)
                    local h = math.random(18, 55)
                    drop.Size = UDim2.new(0, w, 0, h)
                    drop.AnchorPoint = Vector2.new(0.5, 0)
                    drop.Position = UDim2.new(math.random() * 0.96 + 0.02, 0, -0.08 - math.random() * 0.25, 0)
                    drop.BackgroundColor3 = Color3.fromRGB(
                        math.random(120, 200),
                        math.random(0, 18),
                        math.random(0, 25)
                    )
                    drop.BorderSizePixel = 0
                    drop.BackgroundTransparency = 0.05
                    drop.Rotation = math.random(-8, 8)
                    drop.ZIndex = 41
                    drop.Parent = layer
                    Instance.new("UICorner", drop).CornerRadius = UDim.new(1, 0)

                    -- gota más brillante encima
                    local shine = Instance.new("Frame")
                    shine.Size = UDim2.new(0.35, 0, 0.25, 0)
                    shine.Position = UDim2.new(0.15, 0, 0.08, 0)
                    shine.BackgroundColor3 = Color3.fromRGB(255, 80, 90)
                    shine.BackgroundTransparency = 0.45
                    shine.BorderSizePixel = 0
                    shine.Parent = drop
                    Instance.new("UICorner", shine).CornerRadius = UDim.new(1, 0)

                    local fallTime = 1.1 + math.random() * 1.4
                    local targetY = 1.05 + math.random() * 0.2
                    TweenService:Create(drop, TweenInfo.new(fallTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Position = UDim2.new(drop.Position.X.Scale, 0, targetY, 0),
                        BackgroundTransparency = 0.35,
                        Rotation = drop.Rotation + math.random(-12, 12)
                    }):Play()

                    -- splash al llegar abajo (simulado)
                    task.delay(fallTime * 0.92, function()
                        if not drop.Parent then return end
                        local splash = Instance.new("Frame")
                        splash.AnchorPoint = Vector2.new(0.5, 0.5)
                        splash.Position = UDim2.new(drop.Position.X.Scale, 0, 0.92, 0)
                        splash.Size = UDim2.new(0, 4, 0, 4)
                        splash.BackgroundColor3 = drop.BackgroundColor3
                        splash.BorderSizePixel = 0
                        splash.ZIndex = 42
                        splash.Parent = layer
                        Instance.new("UICorner", splash).CornerRadius = UDim.new(1, 0)
                        TweenService:Create(splash, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Size = UDim2.new(0, math.random(22, 40), 0, math.random(6, 12)),
                            BackgroundTransparency = 1
                        }):Play()
                        task.delay(0.4, function() pcall(function() splash:Destroy() end) end)
                    end)
                end

                -- chorros laterales
                for i = 1, 6 do
                    local streak = Instance.new("Frame")
                    streak.Size = UDim2.new(0, math.random(2, 4), 0, math.random(80, 160))
                    streak.AnchorPoint = Vector2.new(0.5, 0)
                    streak.Position = UDim2.new(math.random() * 0.9 + 0.05, 0, -0.2, 0)
                    streak.BackgroundColor3 = Color3.fromRGB(160, 0, 10)
                    streak.BackgroundTransparency = 0.2
                    streak.BorderSizePixel = 0
                    streak.ZIndex = 40
                    streak.Parent = layer
                    Instance.new("UICorner", streak).CornerRadius = UDim.new(1, 0)
                    TweenService:Create(streak, TweenInfo.new(1.5 + math.random() * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Position = UDim2.new(streak.Position.X.Scale, 0, 1.1, 0),
                        BackgroundTransparency = 0.7
                    }):Play()
                end
            end)
        end

        local function closeIntroVisual()
            if not introAlive then return end
            introAlive = false
            if not sg or not sg.Parent then introPlaying = false return end
            spawnBloodRain()
            pcall(bloodDripAllPanels)
            for _, c in ipairs(sg:GetDescendants()) do
                if c:IsA("TextLabel") then
                    TweenService:Create(c, TweenInfo.new(FADE_OUT * 0.85, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1
                    }):Play()
                elseif c:IsA("TextButton") then
                    TweenService:Create(c, TweenInfo.new(FADE_OUT * 0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                        TextTransparency = 1,
                        BackgroundTransparency = 1
                    }):Play()
                end
            end
            TweenService:Create(image, TweenInfo.new(FADE_OUT, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                ImageTransparency = 1
            }):Play()
            TweenService:Create(shadow, TweenInfo.new(FADE_OUT, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                ImageTransparency = 1
            }):Play()
            TweenService:Create(dark, TweenInfo.new(FADE_OUT * 0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(background, TweenInfo.new(FADE_OUT, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            task.delay(FADE_OUT + 0.55, function()
                pcall(function() sg:Destroy() end)
                introPlaying = false
            end)
        end
        -- SKIP: corta intro + música
        local function endIntro(stopMusic)
            closeIntroVisual()
            if stopMusic then
                pcall(function()
                    local snd = musicSound or currentStealSound
                    if snd and snd.Parent then
                        snd:Stop()
                        snd:Destroy()
                    end
                    currentStealSound = nil
                    musicSound = nil
                end)
            end
        end
        skipBtn.MouseButton1Click:Connect(function()
            endIntro(true)
        end)

        task.spawn(function()
            local t0 = tick()
            while introAlive and sg.Parent do
                local t = tick() - t0
                local loud = 0
                pcall(function()
                    local snd = musicSound or currentStealSound
                    if snd and snd.Parent and snd.IsPlaying then
                        loud = math.clamp(snd.PlaybackLoudness / 1000, 0, 1)
                    end
                end)
                -- Si aún no hay loudness, usa un beat sintético ~128 BPM
                if loud < 0.02 then
                    local beat = math.max(0, math.sin(t * (math.pi * 2) * (128 / 60)))
                    loud = beat * beat * 0.55
                end
                local base = (t < 0.8) and 1.4 or 0.85
                local shakeAmp = base + loud * 6.5
                local shakeX = (math.noise(t * 22) - 0.5) * shakeAmp * 0.006
                local shakeY = (math.noise(t * 22 + 50) - 0.5) * shakeAmp * 0.006
                local rot = math.sin(t * 3.2) * (2.2 + loud * 5) + (math.noise(t * 14) - 0.5) * shakeAmp * 0.9
                local zoom = 1.05 + loud * 0.08 + math.sin(t * 2.1) * 0.02
                pcall(function()
                    image.Rotation = rot
                    image.Position = UDim2.fromScale(0.5 + shakeX, 0.5 + shakeY)
                    image.Size = UDim2.fromScale(zoom, zoom)
                    shadow.Rotation = rot - 4
                    shadow.Position = UDim2.fromScale(0.52 + shakeX * 1.4, 0.54 + shakeY * 1.4)
                    shadow.Size = UDim2.fromScale(zoom + 0.03, zoom + 0.03)
                end)
                task.wait(0.03)
            end
        end)

        -- Auto-cierra la intro visual; música sigue sonando hasta su final
        task.delay(5.5, function()
            endIntro(false)
        end)
    end






local function trigger(brainrotName)
        if not ready then return end
        if not brainrotName or brainrotName == "" then return end
        local now = tick()
        local key = brainrotName:lower()
        if (now - lastSentTick) < COOLDOWN and key == lastKey then return end
        busy = true
        lastKey = key
        lastSentTick = now
        task.spawn(function() pcall(playIntro, brainrotName) end)
        task.delay(COOLDOWN, function() busy = false end)
    end

    local function handleText(text)
        local name = parseYouStole(text)
        if name then trigger(name) end
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local function hook(obj)
        if not obj or hooked[obj] then return end
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
        hooked[obj] = true
        pcall(function()
            obj:GetPropertyChangedSignal("Text"):Connect(function()
                if ready then handleText(obj.Text) end
            end)
        end)
        task.defer(function() if ready then handleText(obj.Text) end end)
    end

    pcall(function()
        -- hook inicial solo en roots comunes (evita miles de labels)
        local seeded = 0
        for _, d in ipairs(PlayerGui:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                hook(d)
                seeded = seeded + 1
                if seeded % 80 == 0 then task.wait() end
            end
        end
        PlayerGui.DescendantAdded:Connect(function(d)
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                task.defer(function() hook(d) end)
            end
        end)
    end)

    -- Backup: cada 2s revisa labels con "you stole" / "robaste" (barato)
    task.spawn(function()
        while not thisScriptStopped do
            task.wait(2)
            if not ready then continue end
            pcall(function()
                for _, d in ipairs(PlayerGui:GetDescendants()) do
                    if d:IsA("TextLabel") then
                        local t = d.Text
                        if t and #t > 9 then
                            local low = t:lower()
                            if low:find("you stole", 1, true) or low:find("robaste", 1, true) then
                                handleText(t)
                            end
                        end
                    end
                end
            end)
        end
    end)

    task.delay(0.4, function()
        ready = true
    end)
end)



-- ============================================================
-- ACE FPS BOOST PACK (Stretch Rez + Anti Lag + Nuke Optimiser)
-- ============================================================
task.spawn(function()
    local okFPS, errFPS = pcall(function()
        local Lighting = game:GetService("Lighting")
        local MaterialService = game:GetService("MaterialService")

        local fpsBoostEnabled = false
        local antiLagEnabled = false
        local nukeEnabled = false
        local _nukeConns = {}
        local _nukeThreads = {}
        local antiLagDescConn = nil

        local function enableStretchRez()
            fpsBoostEnabled = true
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    local current = cam.ViewportSize
                    cam.ViewportSize = Vector2.new(math.floor(current.X * 0.7), math.floor(current.Y * 0.7))
                end
                if setfpscap then setfpscap(999) end
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
        end

        local function disableStretchRez()
            fpsBoostEnabled = false
            pcall(function()
                local cam = workspace.CurrentCamera
                if cam then
                    cam.ViewportSize = Vector2.new(1920, 1080)
                end
            end)
        end

        local function processAntiLagDescendant(obj)
            pcall(function()
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                    obj:Destroy()
                elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                    obj:Destroy()
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                        obj:Destroy()
                    end
                elseif obj:IsA("SpecialMesh") then
                    obj.TextureId = ""
                end
            end)
        end

        local function enableAntiLag()
            antiLagEnabled = true
            for _, obj in ipairs(Workspace:GetDescendants()) do
                processAntiLagDescendant(obj)
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    for _, obj in ipairs(plr.Character:GetDescendants()) do
                        processAntiLagDescendant(obj)
                    end
                end
            end
            if antiLagDescConn then antiLagDescConn:Disconnect() end
            antiLagDescConn = Workspace.DescendantAdded:Connect(function(obj)
                if antiLagEnabled then
                    task.defer(processAntiLagDescendant, obj)
                end
            end)
        end

        local function disableAntiLag()
            antiLagEnabled = false
            if antiLagDescConn then
                antiLagDescConn:Disconnect()
                antiLagDescConn = nil
            end
        end

        local function enableNukeOptimizer()
            if nukeEnabled then return end
            nukeEnabled = true

            local ClothingClasses = {
                "Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory",
                "FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory",
                "BackAccessory","WaistAccessory"
            }

            local function SafeDestroy(obj)
                if obj and obj.Name == "Overhead" then return end
                pcall(function() obj:Destroy() end)
            end

            local function IsClothing(obj)
                for _, className in ipairs(ClothingClasses) do
                    if obj:IsA(className) then return true end
                end
                return false
            end

            local function IsCharacterPart(obj)
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
                end
                return false
            end

            local function CleanObject(obj)
                pcall(function()
                    if obj:IsA("SurfaceAppearance") or obj:IsA("Decal") or obj:IsA("Texture") then
                        if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then
                            SafeDestroy(obj)
                        end
                    elseif obj:IsA("SpecialMesh") then
                        obj.TextureId = ""
                    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                    or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight")
                    or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
                        SafeDestroy(obj)
                    elseif obj:IsA("BasePart") then
                        obj.CastShadow = false
                        obj.Material = Enum.Material.Plastic
                        obj.MaterialVariant = ""
                        obj.Reflectance = 0
                    end
                end)
            end

            local function ApplyGreySky()
                pcall(function()
                    for _, obj in ipairs(Lighting:GetChildren()) do
                        if obj:IsA("Sky") then obj:Destroy() end
                    end
                    local sky = Instance.new("Sky")
                    sky.SkyboxBk = ""
                    sky.SkyboxDn = ""
                    sky.SkyboxFt = ""
                    sky.SkyboxLf = ""
                    sky.SkyboxRt = ""
                    sky.SkyboxUp = ""
                    sky.CelestialBodiesShown = false
                    sky.Name = "_AceNukeSky"
                    sky.Parent = Lighting
                end)
            end

            local function OptimizeLighting()
                pcall(function()
                    Lighting.GlobalShadows = false
                    Lighting.FogEnd = 9e9
                    Lighting.FogStart = 9e9
                    Lighting.EnvironmentDiffuseScale = 0
                    Lighting.EnvironmentSpecularScale = 0
                    Lighting.Brightness = 1.5
                    Lighting.Ambient = Color3.fromRGB(60, 60, 60)
                    for _, v in ipairs(Lighting:GetChildren()) do
                        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect")
                        or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect")
                        or v:IsA("Atmosphere") or v:IsA("Clouds") then
                            v:Destroy()
                        end
                    end
                    ApplyGreySky()
                end)
            end

            local function ApplyTerrain()
                pcall(function()
                    local terrain = workspace:FindFirstChildOfClass("Terrain")
                    if terrain then
                        terrain.Decoration = false
                        terrain.WaterWaveSize = 0
                        terrain.WaterWaveSpeed = 0
                        terrain.WaterReflectance = 0
                        terrain.WaterTransparency = 1
                    end
                end)
            end

            local function OptimizeCharacter(char)
                if not char then return end
                task.spawn(function()
                    task.wait(0.3)
                    if not nukeEnabled then return end
                    for _, obj in ipairs(char:GetDescendants()) do
                        if IsClothing(obj) then
                            SafeDestroy(obj)
                        else
                            CleanObject(obj)
                        end
                    end
                end)
            end

            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
            end)
            pcall(function() if setfpscap then setfpscap(999) end end)

            table.insert(_nukeThreads, task.spawn(function()
                if not game:IsLoaded() then game.Loaded:Wait() end
                OptimizeLighting()
                ApplyTerrain()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not nukeEnabled then return end
                    if IsClothing(obj) then
                        SafeDestroy(obj)
                    elseif IsCharacterPart(obj) then
                    else
                        CleanObject(obj)
                    end
                end
            end))

            table.insert(_nukeConns, workspace.DescendantAdded:Connect(function(obj)
                if not nukeEnabled then return end
                task.defer(function()
                    if not nukeEnabled then return end
                    if IsClothing(obj) then SafeDestroy(obj)
                    elseif IsCharacterPart(obj) then
                    else CleanObject(obj) end
                end)
            end))

            table.insert(_nukeConns, Lighting.DescendantAdded:Connect(function(obj)
                if not nukeEnabled then return end
                if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then
                    SafeDestroy(obj)
                end
            end))

            table.insert(_nukeConns, MaterialService.DescendantAdded:Connect(function(obj)
                if not nukeEnabled then return end
                SafeDestroy(obj)
            end))

            for _, plr in ipairs(Players:GetPlayers()) do
                OptimizeCharacter(plr.Character)
                table.insert(_nukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
            end

            table.insert(_nukeConns, Players.PlayerAdded:Connect(function(plr)
                table.insert(_nukeConns, plr.CharacterAdded:Connect(OptimizeCharacter))
            end))

            table.insert(_nukeThreads, task.spawn(function()
                while nukeEnabled and not thisScriptStopped do
                    task.wait(15)
                    pcall(function() collectgarbage("collect") end)
                end
            end))
        end

        local function disableNukeOptimizer()
            nukeEnabled = false
            for _, c in ipairs(_nukeConns) do
                pcall(function() c:Disconnect() end)
            end
            _nukeConns = {}
            _nukeThreads = {}
        end

        local FPSBoost = {}
        function FPSBoost.EnableAll()
            enableStretchRez()
            enableAntiLag()
            enableNukeOptimizer()
        end
        function FPSBoost.DisableAll()
            disableStretchRez()
            disableAntiLag()
            disableNukeOptimizer()
        end
        function FPSBoost.GetStatus()
            return { StretchRez = fpsBoostEnabled, AntiLag = antiLagEnabled, Nuke = nukeEnabled }
        end

        _G.AceFPSBoost = FPSBoost

        if _G.FPSBoostEnabled then
            task.defer(function()
                pcall(function() FPSBoost.EnableAll() end)
            end)
        end
    end)
    if not okFPS then
        warn("[175] FPS Boost error:", tostring(errFPS))
    end
end)



-- ============================================================
-- IP ESP: linea roja + circulo avatar en la cabeza
-- ============================================================
do
    local ipEnabled = false
    local ipObjects = {} -- [Player] = data
    local drawingOk = false
    pcall(function()
        drawingOk = Drawing and type(Drawing.new) == "function"
    end)
    local ACCENT = Color3.fromRGB(220, 25, 45)
    local localAtt = nil -- Attachment en tu HRP para Beams

    local function ensureLocalAtt()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        if localAtt and localAtt.Parent == hrp then return localAtt end
        if localAtt then pcall(function() localAtt:Destroy() end) end
        local att = Instance.new("Attachment")
        att.Name = "175_IP_LocalAtt"
        att.Parent = hrp
        localAtt = att
        return att
    end

    local function getThumb(userId)
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(
                userId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok and content then return content end
        return "rbxasset://textures/ui/GuiImagePlaceholder.png"
    end

    local function removeIP(plr)
        local d = ipObjects[plr]
        if not d then return end
        if d.conn then pcall(function() d.conn:Disconnect() end) end
        if d.bb then pcall(function() d.bb:Destroy() end) end
        if d.beam then pcall(function() d.beam:Destroy() end) end
        if d.att then pcall(function() d.att:Destroy() end) end
        if d.line then
            pcall(function()
                if d.line.Remove then d.line:Remove() end
            end)
        end
        ipObjects[plr] = nil
    end

    local function clearAllIP()
        for plr, _ in pairs(ipObjects) do
            removeIP(plr)
        end
        if localAtt then
            pcall(function() localAtt:Destroy() end)
            localAtt = nil
        end
    end

    local function addIP(plr)
        if not plr or plr == LocalPlayer then return end
        if ipObjects[plr] then
            local d = ipObjects[plr]
            local char = plr.Character
            local head = char and char:FindFirstChild("Head")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if d.bb and head and d.bb.Adornee ~= head then
                d.bb.Adornee = head
                d.bb.Parent = head
            end
            if d.att and hrp and d.att.Parent ~= hrp then
                d.att.Parent = hrp
            end
            return
        end
        local char = plr.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not head or not hrp then return end

        local old = head:FindFirstChild("175_IP_AvatarESP")
        if old then pcall(function() old:Destroy() end) end

        local size = 56
        local bb = Instance.new("BillboardGui")
        bb.Name = "175_IP_AvatarESP"
        bb.Size = UDim2.fromOffset(size, size)
        bb.StudsOffset = Vector3.new(0, 3.4, 0)
        bb.AlwaysOnTop = true
        bb.MaxDistance = 400
        bb.Adornee = head
        bb.Parent = head

        local ring = Instance.new("Frame")
        ring.Name = "Ring"
        ring.Size = UDim2.fromScale(1, 1)
        ring.BackgroundColor3 = Color3.fromRGB(18, 8, 8)
        ring.BackgroundTransparency = 0.12
        ring.BorderSizePixel = 0
        ring.Parent = bb
        Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke")
        stroke.Color = ACCENT
        stroke.Thickness = 2.2
        stroke.Transparency = 0.1
        stroke.Parent = ring

        local avatar = Instance.new("ImageLabel")
        avatar.Name = "Avatar"
        avatar.AnchorPoint = Vector2.new(0.5, 0.5)
        avatar.Position = UDim2.fromScale(0.5, 0.5)
        avatar.Size = UDim2.fromScale(0.82, 0.82)
        avatar.BackgroundTransparency = 1
        avatar.BorderSizePixel = 0
        avatar.ScaleType = Enum.ScaleType.Crop
        avatar.Image = getThumb(plr.UserId)
        avatar.Parent = ring
        Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

        local nameTag = Instance.new("TextLabel")
        nameTag.Name = "NameTag"
        nameTag.AnchorPoint = Vector2.new(0.5, 0)
        nameTag.Position = UDim2.new(0.5, 0, 1, 2)
        nameTag.Size = UDim2.new(0, 100, 0, 14)
        nameTag.BackgroundTransparency = 1
        nameTag.Text = plr.DisplayName or plr.Name
        nameTag.TextColor3 = Color3.fromRGB(255, 220, 220)
        nameTag.TextStrokeTransparency = 0.35
        nameTag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameTag.Font = Enum.Font.GothamBold
        nameTag.TextSize = 11
        nameTag.Parent = bb

        -- Attachment + Beam (linea 3D roja siempre visible)
        local att = Instance.new("Attachment")
        att.Name = "175_IP_Att"
        att.Parent = hrp

        local beam = Instance.new("Beam")
        beam.Name = "175_IP_Beam"
        beam.Color = ColorSequence.new(ACCENT)
        beam.Width0 = 0.18
        beam.Width1 = 0.12
        beam.FaceCamera = true
        beam.LightEmission = 0.6
        beam.LightInfluence = 0
        beam.Transparency = NumberSequence.new(0.15)
        beam.Segments = 4
        beam.Enabled = true
        beam.Parent = hrp

        local lAtt = ensureLocalAtt()
        if lAtt then
            beam.Attachment0 = lAtt
            beam.Attachment1 = att
        end

        -- Drawing line extra (pantalla) si el executor lo soporta
        local line = nil
        if drawingOk then
            pcall(function()
                line = Drawing.new("Line")
                line.Visible = false
                line.Thickness = 2.5
                line.Color = ACCENT
                line.Transparency = 1
            end)
        end

        local conn = plr.CharacterAdded:Connect(function()
            task.wait(0.35)
            if not ipEnabled then return end
            removeIP(plr)
            if ipEnabled then addIP(plr) end
        end)

        ipObjects[plr] = {
            bb = bb, ring = ring, avatar = avatar, stroke = stroke,
            nameTag = nameTag, line = line, beam = beam, att = att, conn = conn
        }
    end

    local function setIPESP(on)
        ipEnabled = on and true or false
        if ipEnabled then
            ensureLocalAtt()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    pcall(addIP, plr)
                end
            end
        else
            clearAllIP()
        end
    end
    _G._175_SetIPESP = setIPESP

    Players.PlayerAdded:Connect(function(p)
        if not ipEnabled or p == LocalPlayer then return end
        p.CharacterAdded:Connect(function()
            task.wait(0.4)
            if ipEnabled then addIP(p) end
        end)
        if p.Character then
            task.delay(0.4, function()
                if ipEnabled then addIP(p) end
            end)
        end
    end)
    Players.PlayerRemoving:Connect(function(p)
        removeIP(p)
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.3)
        if not ipEnabled then return end
        localAtt = nil
        ensureLocalAtt()
        for plr, d in pairs(ipObjects) do
            if d.beam and d.att then
                local lAtt = ensureLocalAtt()
                if lAtt then
                    d.beam.Attachment0 = lAtt
                    d.beam.Attachment1 = d.att
                end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if not ipEnabled then return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        local lAtt = ensureLocalAtt()
        local lc = LocalPlayer.Character
        local lr = lc and lc:FindFirstChild("HumanoidRootPart")
        local lineStart = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.82)
        if lr then
            local rp, rv = cam:WorldToViewportPoint(lr.Position)
            if rv and rp.Z > 0 then
                lineStart = Vector2.new(rp.X, rp.Y)
            end
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                if not ipObjects[p] then
                    pcall(addIP, p)
                end
                local d = ipObjects[p]
                if d then
                    local ch = p.Character
                    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                    local root = ch and ch:FindFirstChild("HumanoidRootPart")
                    local head = ch and ch:FindFirstChild("Head")
                    local alive = ch and hum and root and hum.Health > 0
                    if not alive then
                        if d.line then d.line.Visible = false end
                        if d.beam then d.beam.Enabled = false end
                        if d.bb then d.bb.Enabled = false end
                    else
                        if d.bb then
                            d.bb.Enabled = true
                            if head and d.bb.Adornee ~= head then
                                d.bb.Adornee = head
                                d.bb.Parent = head
                            end
                        end
                        -- Beam 3D (siempre)
                        if d.beam and d.att and lAtt then
                            if d.att.Parent ~= root then
                                d.att.Parent = root
                            end
                            d.beam.Attachment0 = lAtt
                            d.beam.Attachment1 = d.att
                            d.beam.Enabled = true
                            d.beam.Color = ColorSequence.new(ACCENT)
                        end
                        -- Drawing 2D extra
                        if d.line then
                            local tp, tv = cam:WorldToViewportPoint(root.Position)
                            if tv and tp.Z > 0 then
                                d.line.From = lineStart
                                d.line.To = Vector2.new(tp.X, tp.Y)
                                d.line.Color = ACCENT
                                d.line.Thickness = 2.5
                                d.line.Visible = true
                            else
                                d.line.Visible = false
                            end
                        end
                    end
                end
            end
        end
    end)

    if _G.IPESPEnabled then
        task.defer(function() setIPESP(true) end)
    end
end

-- flash block loaded
]=====]
local _StickFlashBlockLoaded = false

local function showFlashBlock()
    if _StickFlashBlockLoaded then
        pcall(function()
            local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            local g = pg and pg:FindFirstChild("FlashBlock")
            if g then g.Enabled = true end
            if gethui then
                local h = gethui():FindFirstChild("FlashBlock")
                if h then h.Enabled = true end
            end
        end)
        return
    end
    local ok, err = pcall(function()
        local fn, compileErr = loadstring(_StickFlashBlockSrc)
        if not fn then error(compileErr or "compile fail") end
        fn()
    end)
    if ok then
        _StickFlashBlockLoaded = true
    else
        warn("[STICK] Flash Block load error:", tostring(err))
    end
end

local function closeFlashBlock()
    pcall(function()
        if _G.Formega_Script_Purge then _G.Formega_Script_Purge() end
    end)
    pcall(function()
        local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            local g = pg:FindFirstChild("FlashBlock")
            if g then g:Destroy() end
            local d = pg:FindFirstChild("DropBrainrotGui")
            if d then d:Destroy() end
        end
        if gethui then
            local h = gethui():FindFirstChild("FlashBlock")
            if h then h:Destroy() end
        end
        local cg = game:GetService("CoreGui")
        local c = cg:FindFirstChild("FlashBlock")
        if c then c:Destroy() end
    end)
    _StickFlashBlockLoaded = false
end

(function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StickSemiTP_Main"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = safeGuiTarget
    local SpeedFrame, APSpamFrame, MainFrame, UtilsFrame, HubFrame, HelperFrame


    local panelWidth = IsMobile and 255 or 240
    local mainPanelHeight = IsMobile and 175 or 165
    local utilsPanelHeight = IsMobile and 420 or 400
    local PANEL_BG_IMAGE = "rbxassetid://120361169727304"

    local function makeDraggable(header, frame)
        local dragging, dragStart, startPos = false, nil, nil
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    local function addCollapseToggle(header, frame, fullHeight, contentElements, onExpand)
        local expanded = true
        btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 26, 0, 26)
        btn.Position = UDim2.new(1, -32, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
        btn.BorderSizePixel = 0
        btn.Text = "-"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = MAIN_FONT
        btn.TextSize = 18
        btn.ZIndex = 50
        btn.Active = true
        btn.Parent = header
        Instance.new("UIStroke", btn).Color = COLOR_ACCENT
        local t = header:FindFirstChildOfClass("TextLabel")
        if t then t.Size = UDim2.new(1, -40, 1, 0) end
        btn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                btn.Text = "-"
                frame.Size = UDim2.new(0, panelWidth, 0, fullHeight)
                if type(onExpand) == "function" then pcall(onExpand)
                else for _, el in ipairs(contentElements) do if el then el.Visible = true end end end
            else
                btn.Text = "+"
                frame.Size = UDim2.new(0, panelWidth, 0, 38)
                for _, el in ipairs(contentElements) do if el then el.Visible = false end end
            end
        end)
        return btn
    end

    local function createPanelFrame(name, width, height, pos)
        local frame = Instance.new("Frame")
        frame.Name = name
        frame.Size = UDim2.new(0, width, 0, height)
        frame.AnchorPoint = Vector2.new(1, 0)
        frame.Position = pos
        frame.BackgroundColor3 = COLOR_BG_DARK
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ClipsDescendants = true
        frame.Parent = ScreenGui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

        local bg = Instance.new("ImageLabel")
        bg.Name = "PanelBg"
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundTransparency = 1
        bg.BorderSizePixel = 0
        bg.Image = PANEL_BG_IMAGE
        bg.ScaleType = Enum.ScaleType.Crop
        bg.ImageTransparency = 0
        bg.ZIndex = 1
        bg.Active = false
        bg.Parent = frame
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 16)

        local overlay = Instance.new("Frame")
        overlay.Name = "PanelOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.28
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 2
        overlay.Active = false
        overlay.Parent = frame
        Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 16)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Thickness = 2
        stroke.Color = COLOR_ACCENT
        stroke.Transparency = 0.15
        return frame
    end
    local function createHeader(parent, title)
        local HeaderFrame = Instance.new("Frame")
        HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
        HeaderFrame.BackgroundColor3 = Color3.fromRGB(8, 2, 4)
        HeaderFrame.BackgroundTransparency = 0.1
        HeaderFrame.BorderSizePixel = 0
        HeaderFrame.ZIndex = 3
        HeaderFrame.Parent = parent
        Instance.new("UICorner", HeaderFrame).CornerRadius = UDim.new(0, 16)

        local HeaderFix = Instance.new("Frame")
        HeaderFix.Size = UDim2.new(1, 0, 0, 16)
        HeaderFix.Position = UDim2.new(0, 0, 1, -16)
        HeaderFix.BackgroundColor3 = Color3.fromRGB(8, 2, 4)
        HeaderFix.BackgroundTransparency = 0.1
        HeaderFix.BorderSizePixel = 0
        HeaderFix.ZIndex = 3
        HeaderFix.Parent = HeaderFrame

        local HeaderLine = Instance.new("Frame")
        HeaderLine.Size = UDim2.new(1, -24, 0, 2)
        HeaderLine.Position = UDim2.new(0, 12, 1, 0)
        HeaderLine.BackgroundColor3 = COLOR_ACCENT
        HeaderLine.BorderSizePixel = 0
        HeaderLine.ZIndex = 4
        HeaderLine.Parent = HeaderFrame

        local TitleText = Instance.new("TextLabel")
        TitleText.Size = UDim2.new(1, -44, 1, 0)
        TitleText.Position = UDim2.new(0, 12, 0, 0)
        TitleText.BackgroundTransparency = 1
        TitleText.Text = title
        TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleText.Font = MAIN_FONT
        TitleText.TextSize = 14
        TitleText.TextXAlignment = Enum.TextXAlignment.Left
        TitleText.TextStrokeTransparency = 0
        TitleText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        TitleText.ZIndex = 5
        TitleText.Parent = HeaderFrame
        applyTextGradient(TitleText)
        return HeaderFrame
    end
    local function createRowFrame(parent, height, order)
        card = Instance.new("Frame")
        card.Size = UDim2.new(1, -4, 0, height)
        card.BackgroundColor3 = Color3.fromRGB(20, 10, 12)
        card.BackgroundTransparency = 0.05
        card.BorderSizePixel = 0
        card.ZIndex = 4
        card.Active = true
        card.LayoutOrder = order or 1
        card.Parent = parent
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
        local stroke = Instance.new("UIStroke", card)
        stroke.Thickness = 1.2
        stroke.Color = COLOR_ACCENT
        stroke.Transparency = 0.45
        return card
    end

    local function createModernToggle(parentCard, textLabel, initialState, onClick)
        local ON_BG = COLOR_ACCENT -- rojo
        local OFF_BG = Color3.fromRGB(70, 70, 75) -- gris
        local ON_PIN = Color3.fromRGB(255, 255, 255)
        local OFF_PIN = Color3.fromRGB(200, 200, 205)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.58, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = textLabel
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = MAIN_FONT
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextStrokeTransparency = 0
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.ZIndex = 25
        lbl.Parent = parentCard

        local track = Instance.new("TextButton")
        track.Name = "ToggleTrack"
        track.Size = UDim2.new(0, 44, 0, 24)
        track.Position = UDim2.new(1, -52, 0.5, -12)
        track.BackgroundColor3 = initialState and ON_BG or OFF_BG
        track.BorderSizePixel = 0
        track.Text = ""
        track.ZIndex = 26
        track.Active = true
        track.AutoButtonColor = false
        track.Parent = parentCard
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
        local trackStroke = Instance.new("UIStroke", track)
        trackStroke.Thickness = 1.5
        trackStroke.Color = initialState and Color3.fromRGB(255, 100, 120) or Color3.fromRGB(100, 100, 105)
        trackStroke.Transparency = 0.15

        local pin = Instance.new("Frame")
        pin.Name = "TogglePin"
        pin.Size = UDim2.new(0, 20, 0, 20)
        pin.Position = initialState and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        pin.BackgroundColor3 = initialState and ON_PIN or OFF_PIN
        pin.BorderSizePixel = 0
        pin.ZIndex = 27
        pin.Parent = track
        Instance.new("UICorner", pin).CornerRadius = UDim.new(1, 0)

        local state = initialState and true or false
        local busy = false

        local function applyVisual(on)
            if on then
                track.BackgroundColor3 = ON_BG
                trackStroke.Color = Color3.fromRGB(255, 100, 120)
                pin.Position = UDim2.new(1, -22, 0.5, -10)
                pin.BackgroundColor3 = ON_PIN
            else
                track.BackgroundColor3 = OFF_BG
                trackStroke.Color = Color3.fromRGB(100, 100, 105)
                pin.Position = UDim2.new(0, 2, 0.5, -10)
                pin.BackgroundColor3 = OFF_PIN
            end
        end
        applyVisual(state)

        track.MouseButton1Click:Connect(function()
            if busy then return end
            busy = true
            state = not state
            applyVisual(state)
            pcall(onClick, state)
            task.delay(0.12, function() busy = false end)
        end)

        return track, pin
    end



    -- ===== PANEL MAIN (oculto; funciones siguen en keybind / _G / settings) =====
    MainFrame = createPanelFrame("MainPanel", panelWidth, mainPanelHeight,
        IsMobile and UDim2.new(0.88, 0, 0.05, 0) or UDim2.new(0.84, 0, 0.02, 0))
    MainFrame.Visible = false
    MainHeader = createHeader(MainFrame, "STICK SEMI TP")
    makeDraggable(MainHeader, MainFrame)

    MainContent = Instance.new("Frame")
    MainContent.Size = UDim2.new(1, -16, 1, -48)
    MainContent.Position = UDim2.new(0, 8, 0, 44)
    MainContent.BackgroundTransparency = 1
    MainContent.ZIndex = 3
    MainContent.Parent = MainFrame

    MainList = Instance.new("UIListLayout", MainContent)
    MainList.SortOrder = Enum.SortOrder.LayoutOrder
    MainList.Padding = UDim.new(0, 6)

    Row1 = createRowFrame(MainContent, 28, 1)
    Label1 = Instance.new("TextLabel")
    Label1.Size = UDim2.new(0.4, 0, 1, 0)
    Label1.Position = UDim2.new(0, 10, 0, 0)
    Label1.BackgroundTransparency = 1
    Label1.Text = "Select Slot"
    Label1.TextColor3 = COLOR_TEXT_LIGHT
    Label1.Font = MAIN_FONT
    Label1.TextSize = 11
    Label1.TextXAlignment = Enum.TextXAlignment.Left
    Label1.ZIndex = 5
    Label1.Parent = Row1

    SelectorFrame = Instance.new("Frame")
    SelectorFrame.Size = UDim2.new(0, 95, 0, 20)
    SelectorFrame.Position = UDim2.new(1, -103, 0.5, -10)
    SelectorFrame.BackgroundTransparency = 1
    SelectorFrame.ZIndex = 5
    SelectorFrame.Parent = Row1

    LeftBtn = Instance.new("TextButton")
    LeftBtn.Size = UDim2.new(0, 20, 1, 0)
    LeftBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
    LeftBtn.Text = "<"
    LeftBtn.TextColor3 = COLOR_TEXT_LIGHT
    LeftBtn.Font = MAIN_FONT
    LeftBtn.TextSize = 12
    LeftBtn.ZIndex = 6
    LeftBtn.Parent = SelectorFrame
    Instance.new("UIStroke", LeftBtn).Color = COLOR_BORDER
    addHoverAnimation(LeftBtn, Color3.fromRGB(40, 15, 18), Color3.fromRGB(70, 20, 25))

    SlotDisplay = Instance.new("TextLabel")
    SlotDisplay.Size = UDim2.new(0, 47, 1, 0)
    SlotDisplay.Position = UDim2.new(0, 24, 0, 0)
    SlotDisplay.BackgroundColor3 = Color3.fromRGB(30, 12, 14)
    SlotDisplay.Text = "Slot " .. tostring(selectedSlot)
    SlotDisplay.TextColor3 = COLOR_TEXT_LIGHT
    SlotDisplay.Font = MAIN_FONT
    SlotDisplay.TextSize = 10
    SlotDisplay.ZIndex = 6
    SlotDisplay.Parent = SelectorFrame
    Instance.new("UIStroke", SlotDisplay).Color = COLOR_BORDER

    RightBtn = Instance.new("TextButton")
    RightBtn.Size = UDim2.new(0, 20, 1, 0)
    RightBtn.Position = UDim2.new(1, -20, 0, 0)
    RightBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
    RightBtn.Text = ">"
    RightBtn.TextColor3 = COLOR_TEXT_LIGHT
    RightBtn.Font = MAIN_FONT
    RightBtn.TextSize = 12
    RightBtn.ZIndex = 6
    RightBtn.Parent = SelectorFrame
    Instance.new("UIStroke", RightBtn).Color = COLOR_BORDER
    addHoverAnimation(RightBtn, Color3.fromRGB(40, 15, 18), Color3.fromRGB(70, 20, 25))

    local function updateSlot(newSlot)
        selectedSlot = newSlot
        SlotDisplay.Text = "Slot " .. tostring(selectedSlot)
        HalfwaySteal.setSlot(selectedSlot)
        if refreshTargetBar then refreshTargetBar() end
    end

    LeftBtn.MouseButton1Click:Connect(function()
        local n = selectedSlot - 1
        if n < 1 then n = 18 end
        updateSlot(n)
    end)
    RightBtn.MouseButton1Click:Connect(function()
        local n = selectedSlot + 1
        if n > 18 then n = 1 end
        updateSlot(n)
    end)

    Row5 = createRowFrame(MainContent, 30, 2)
    ActivateBtn = Instance.new("TextButton")
    ActivateBtn.Size = UDim2.new(1, 0, 1, 0)
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(32, 12, 15)
    ActivateBtn.BorderSizePixel = 0
    ActivateBtn.Text = "Activate (Reset)"
    ActivateBtn.TextColor3 = COLOR_TEXT_LIGHT
    ActivateBtn.Font = MAIN_FONT
    ActivateBtn.TextSize = 11
    ActivateBtn.ZIndex = 6
    ActivateBtn.Parent = Row5
    addHoverAnimation(ActivateBtn, Color3.fromRGB(32, 12, 15), Color3.fromRGB(60, 18, 22))
    ActivateBtn.MouseButton1Click:Connect(function() HalfwaySteal.activate() end)

    Row6 = createRowFrame(MainContent, 34, 3)
    TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Size = UDim2.new(1, 0, 1, 0)
    TeleportBtn.BackgroundColor3 = COLOR_ACCENT
    TeleportBtn.BorderSizePixel = 0
    TeleportBtn.Text = "Execute"
    TeleportBtn.TextColor3 = COLOR_BG_DARK
    TeleportBtn.Font = MAIN_FONT
    TeleportBtn.TextSize = 13
    TeleportBtn.ZIndex = 6
    TeleportBtn.Parent = Row6
    addHoverAnimation(TeleportBtn, COLOR_ACCENT, Color3.fromRGB(255, 80, 100))
    TeleportBtn.MouseButton1Click:Connect(function() HalfwaySteal.execute() end)
    addCollapseToggle(MainHeader, MainFrame, mainPanelHeight, {MainContent})

    -- ===== PANEL SETTINGS =====
    UtilsFrame = createPanelFrame("UtilsPanel", panelWidth, utilsPanelHeight,
        IsMobile and UDim2.new(0.88, 0, 0.05, mainPanelHeight + 12) or UDim2.new(0.84, 0, 0.02, mainPanelHeight + 12))
    UtilsHeader = createHeader(UtilsFrame, "SETTINGS")
    makeDraggable(UtilsHeader, UtilsFrame)

    do
        local t = UtilsHeader:FindFirstChildOfClass("TextLabel")
        if t then t.Size = UDim2.new(1, -40, 1, 0) end
    end

    CatBar = Instance.new("Frame")
    CatBar.Name = "CategoryBar"
    CatBar.Size = UDim2.new(1, -12, 0, 28)
    CatBar.Position = UDim2.new(0, 6, 0, 40)
    CatBar.BackgroundTransparency = 1
    CatBar.ZIndex = 3
    CatBar.Parent = UtilsFrame

    CatLayout = Instance.new("UIListLayout", CatBar)
    CatLayout.FillDirection = Enum.FillDirection.Horizontal
    CatLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CatLayout.Padding = UDim.new(0, 4)
    CatLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local catPages = {}
    local catButtons = {}
    local currentCat = "Main"

    local function createCategoryBtn(text, order)
        btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, (panelWidth - 24) / 2, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = COLOR_TEXT_LIGHT
        btn.Font = MAIN_FONT
        btn.TextSize = 9
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.ZIndex = 5
        btn.LayoutOrder = order
        btn.Parent = CatBar
        st = Instance.new("UIStroke", btn)
        st.Color = COLOR_BORDER
        st.Thickness = 1
        return btn
    end

    local function createCatPage(name)
        page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. name:gsub("%s", "")
        page.Size = UDim2.new(1, -16, 1, -76)
        page.Position = UDim2.new(0, 8, 0, 72)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = COLOR_ACCENT
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ClipsDescendants = true
        page.Visible = false
        page.ZIndex = 15
        page.Active = true
        page.Parent = UtilsFrame
        list = Instance.new("UIListLayout", page)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 6)
        catPages[name] = page
        return page
    end

    pageMain = createCatPage("Main")
    pageConfig = createCatPage("Config")
    pageSemi = pageMain -- alias
    pagePub = pageConfig -- alias para toggles pub

    -- Pub Method toggles se crean despues de SpeedFrame/APSpamFrame

    local function switchCategory(name)
        currentCat = name
        for n, page in pairs(catPages) do
            page.Visible = (n == name)
        end
        for n, btn in pairs(catButtons) do
            if n == name then
                btn.BackgroundColor3 = COLOR_ACCENT
                btn.TextColor3 = COLOR_BG_DARK
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
                btn.TextColor3 = COLOR_TEXT_LIGHT
            end
        end
    end

    for i, name in ipairs({"Main", "Config"}) do
        btn = createCategoryBtn(name, i)
        catButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            switchCategory(name)
        end)
    end

    switchCategory("Main")

    RowAutoActivate = createRowFrame(pageSemi, 28, 10)
    createModernToggle(RowAutoActivate, "Auto Activate", AutoActivateEnabled, function(ns)
        AutoActivateEnabled = ns
        HubConfig.autoActivateEnabled = ns
        saveHubConfig()
        if ns then task.spawn(function() HalfwaySteal.activate() end) end
    end)

    Row2 = createRowFrame(pageSemi, 28, 11)
    createModernToggle(Row2, "Auto Potion", PotionEnabled, function(ns)
        PotionEnabled = ns
        HubConfig.potionEnabled = ns
        _G.StickPotionEnabled = ns
        saveHubConfig()
    end)

    RowAutoWalk = createRowFrame(pageSemi, 28, 13)
    createModernToggle(RowAutoWalk, "Auto Walk", AutoWalkEnabled, function(ns)
        AutoWalkEnabled = ns
        HubConfig.autoWalkEnabled = ns
        _G.StickAutoWalk = ns
        saveHubConfig()
    end)

    RowAutoTPAllow = createRowFrame(pageSemi, 28, 17)
    createModernToggle(RowAutoTPAllow, "Auto TP on Allow", AutoTPOnAllowEnabled, function(ns)
        AutoTPOnAllowEnabled = ns
        HubConfig.autoTPOnAllowEnabled = ns
        _G.StickAutoTPAllow = ns
        saveHubConfig()
    end)

    RowAPOnSteal = createRowFrame(pageSemi, 28, 14)
    createModernToggle(RowAPOnSteal, "AP on Steal", APOnStealEnabled, function(ns)
        APOnStealEnabled = ns
        HubConfig.apOnStealEnabled = ns
        _G.StickAPOnSteal = ns
        saveHubConfig()
    end)

    RowKickAfterSteal = createRowFrame(pageSemi, 28, 18)
    createModernToggle(RowKickAfterSteal, "Kick After Steal", KickAfterStealEnabled, function(ns)
        KickAfterStealEnabled = ns
        HubConfig.kickAfterStealEnabled = ns
        _G.StickKickAfterSteal = ns
        saveHubConfig()
        if ns then scanGuiForKick(PlayerGui) end
    end)

    RowGear = createRowFrame(pageConfig, 28, 20)
    LabelGear = Instance.new("TextLabel")
    LabelGear.Size = UDim2.new(0.45, 0, 1, 0)
    LabelGear.Position = UDim2.new(0, 10, 0, 0)
    LabelGear.BackgroundTransparency = 1
    LabelGear.Text = "Select Gear"
    LabelGear.TextColor3 = COLOR_TEXT_LIGHT
    LabelGear.Font = MAIN_FONT
    LabelGear.TextSize = 11
    LabelGear.TextXAlignment = Enum.TextXAlignment.Left
    LabelGear.ZIndex = 5
    LabelGear.Parent = RowGear

    local initialGears = getInventoryGears()
    if #initialGears > 0 then
        local found = false
        for _, g in ipairs(initialGears) do
            if g == HubConfig.selectedGear then found = true break end
        end
        if not found then
            HubConfig.selectedGear = initialGears[1]
            saveHubConfig()
        end
    else
        HubConfig.selectedGear = "Sin Gear"
    end

    GearCycleBtn = Instance.new("TextButton")
    GearCycleBtn.Size = UDim2.new(0, 95, 0, 20)
    GearCycleBtn.Position = UDim2.new(1, -103, 0.5, -10)
    GearCycleBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
    GearCycleBtn.BorderSizePixel = 0
    GearCycleBtn.Text = HubConfig.selectedGear
    GearCycleBtn.TextColor3 = COLOR_TEXT_LIGHT
    GearCycleBtn.Font = MAIN_FONT
    GearCycleBtn.TextSize = 9
    GearCycleBtn.ZIndex = 8
    GearCycleBtn.Parent = RowGear
    Instance.new("UICorner", GearCycleBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", GearCycleBtn).Color = COLOR_BORDER
    addHoverAnimation(GearCycleBtn, Color3.fromRGB(40, 15, 18), Color3.fromRGB(70, 20, 25))

    GearCycleBtn.MouseButton1Click:Connect(function()
        local inventory = getInventoryGears()
        if #inventory == 0 then
            GearCycleBtn.Text = "Sin Gear"
            HubConfig.selectedGear = "Sin Gear"
            saveHubConfig()
            return
        end
        local idx = 0
        for i, g in ipairs(inventory) do
            if g == HubConfig.selectedGear then idx = i break end
        end
        local nextGear = inventory[(idx % #inventory) + 1]
        GearCycleBtn.Text = nextGear
        HubConfig.selectedGear = nextGear
        saveHubConfig()
    end)

    Row4 = createRowFrame(pageConfig, 28, 21)
    if IsMobile then Row4.Visible = false end

    Label4 = Instance.new("TextLabel")
    Label4.Size = UDim2.new(0.5, 0, 1, 0)
    Label4.Position = UDim2.new(0, 10, 0, 0)
    Label4.BackgroundTransparency = 1
    Label4.Text = "Steal Keybind"
    Label4.TextColor3 = COLOR_TEXT_LIGHT
    Label4.Font = MAIN_FONT
    Label4.TextSize = 11
    Label4.TextXAlignment = Enum.TextXAlignment.Left
    Label4.ZIndex = 5
    Label4.Parent = Row4

    KeybindBtn = Instance.new("TextButton")
    KeybindBtn.Size = UDim2.new(0, 50, 0, 20)
    KeybindBtn.Position = UDim2.new(1, -58, 0.5, -10)
    KeybindBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
    KeybindBtn.Text = currentStealKey.Name
    KeybindBtn.TextColor3 = COLOR_TEXT_LIGHT
    KeybindBtn.Font = MAIN_FONT
    KeybindBtn.TextSize = 10
    KeybindBtn.ZIndex = 6
    KeybindBtn.Parent = Row4
    Instance.new("UICorner", KeybindBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", KeybindBtn).Color = COLOR_BORDER

    local isBinding = false
    KeybindBtn.MouseButton1Click:Connect(function()
        isBinding = true
        KeybindBtn.Text = "..."
    end)
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
            isBinding = false
            currentStealKey = input.KeyCode
            KeybindBtn.Text = input.KeyCode.Name
            HubConfig.stealKeybind = input.KeyCode.Name
            saveHubConfig()
        elseif not isBinding and input.KeyCode == currentStealKey then
            if not HalfwaySteal.debounce and not player:GetAttribute("Stealing") then
                HalfwaySteal.execute()
            end
        end
    end)

    RowAPDefense = createRowFrame(pageConfig, 28, 15)
    createModernToggle(RowAPDefense, "AP Defense", HexDefenseState.AP, function(ns)
        HexDefenseState.AP = ns
        HubConfig.apDefenseEnabled = ns
        saveHubConfig()
    end)

    RowLaserDefense = createRowFrame(pageConfig, 28, 16)
    createModernToggle(RowLaserDefense, "Laser Defense", HexDefenseState.Laser, function(ns)
        HexDefenseState.Laser = ns
        HubConfig.laserDefenseEnabled = ns
        saveHubConfig()
    end)

    RowAimbot = createRowFrame(pageConfig, 28, 12)
    createModernToggle(RowAimbot, "Aimbot", HexDefenseState.Aimbot, function(ns)
        HexDefenseState.Aimbot = ns
        HubConfig.aimbotEnabled = ns
        saveHubConfig()
        if _G.HexAimbotRefresh then pcall(_G.HexAimbotRefresh) end
    end)

    do
        local settingsContents = {CatBar}
        for _, pg in pairs(catPages) do table.insert(settingsContents, pg) end
        addCollapseToggle(UtilsHeader, UtilsFrame, utilsPanelHeight, settingsContents, function()
            CatBar.Visible = true
            switchCategory(currentCat or "Main")
        end)
    end

    
    -- ===== PANEL STICK HUB =====
    local hubHeight = 220
    HubFrame = createPanelFrame("StickHubPanel", panelWidth + 20, hubHeight,
        IsMobile and UDim2.new(0.12, 0, 0.05, 0) or UDim2.new(0.16, 0, 0.02, 0))
    HubFrame.AnchorPoint = Vector2.new(0, 0)
    local HubHeader = createHeader(HubFrame, "STICK HUB")
    makeDraggable(HubHeader, HubFrame)

    -- layout: categorias IZQUIERDA (vertical) | raya | funciones DERECHA
    local HubBody = Instance.new("Frame")
    HubBody.Size = UDim2.new(1, -16, 1, -52)
    HubBody.Position = UDim2.new(0, 8, 0, 46)
    HubBody.BackgroundTransparency = 1
    HubBody.ZIndex = 3
    HubBody.Parent = HubFrame

    -- IZQUIERDA: categorias hacia abajo
    local HubCatBar = Instance.new("Frame")
    HubCatBar.Size = UDim2.new(0, 88, 1, 0)
    HubCatBar.Position = UDim2.new(0, 0, 0, 0)
    HubCatBar.BackgroundTransparency = 1
    HubCatBar.ZIndex = 4
    HubCatBar.Parent = HubBody

    local HubCatList = Instance.new("UIListLayout", HubCatBar)
    HubCatList.FillDirection = Enum.FillDirection.Vertical
    HubCatList.Padding = UDim.new(0, 5)
    HubCatList.SortOrder = Enum.SortOrder.LayoutOrder

    -- RAYA separadora
    local HubDivider = Instance.new("Frame")
    HubDivider.Size = UDim2.new(0, 2, 1, -4)
    HubDivider.Position = UDim2.new(0, 94, 0, 2)
    HubDivider.BackgroundColor3 = COLOR_ACCENT
    HubDivider.BorderSizePixel = 0
    HubDivider.ZIndex = 4
    HubDivider.Parent = HubBody
    Instance.new("UICorner", HubDivider).CornerRadius = UDim.new(1, 0)

    -- DERECHA: contenido de la categoria
    local HubRight = Instance.new("Frame")
    HubRight.Size = UDim2.new(1, -104, 1, 0)
    HubRight.Position = UDim2.new(0, 102, 0, 0)
    HubRight.BackgroundTransparency = 1
    HubRight.ZIndex = 4
    HubRight.Parent = HubBody

    local hubPages = {}
    local hubCatBtns = {}
    local hubCurrent = "Semi TP"

    local function createHubCatBtn(text, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = COLOR_TEXT_LIGHT
        btn.Font = MAIN_FONT
        btn.TextSize = 10
        btn.ZIndex = 5
        btn.LayoutOrder = order
        btn.AutoButtonColor = false
        btn.Parent = HubCatBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", btn)
        st.Color = COLOR_BORDER
        st.Thickness = 1
        return btn
    end

    local function createHubPage(name)
        local page = Instance.new("Frame")
        page.Name = "HubPage_" .. name:gsub("%s", "")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.ZIndex = 5
        page.Parent = HubRight
        local list = Instance.new("UIListLayout", page)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 6)
        hubPages[name] = page
        return page
    end

    local function switchHubCat(name)
        hubCurrent = name
        for n, page in pairs(hubPages) do
            page.Visible = (n == name)
        end
        for n, btn in pairs(hubCatBtns) do
            if n == name then
                btn.BackgroundColor3 = COLOR_ACCENT
                btn.TextColor3 = COLOR_BG_DARK
            else
                btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
                btn.TextColor3 = COLOR_TEXT_LIGHT
            end
        end
    end

    for idx, name in ipairs({"Semi TP", "Flash Block", "TP Block"}) do
        local btn = createHubCatBtn(name, idx)
        hubCatBtns[name] = btn
        btn.MouseButton1Click:Connect(function()
            switchHubCat(name)
        end)
    end

    local pageSemiHub = createHubPage("Semi TP")
    local pageFlashHub = createHubPage("Flash Block")
    local pageTPHub = createHubPage("TP Block")

    local function hubPrettyBtn(parent, text, order, bg, onClick)
        local row = createRowFrame(parent, 30, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = bg or Color3.fromRGB(40, 15, 18)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = (bg == COLOR_ACCENT) and COLOR_BG_DARK or COLOR_TEXT_LIGHT
        btn.Font = MAIN_FONT
        btn.TextSize = 11
        btn.ZIndex = 6
        btn.AutoButtonColor = false
        btn.Parent = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", btn)
        st.Color = COLOR_ACCENT
        st.Thickness = 1
        st.Transparency = 0.4
        addHoverAnimation(btn, btn.BackgroundColor3, Color3.fromRGB(70, 20, 25))
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end

    hubPrettyBtn(pageSemiHub, "Show Semi TP", 1, COLOR_ACCENT, function()
        if MainFrame then MainFrame.Visible = true end
    end)
    hubPrettyBtn(pageSemiHub, "Close Semi TP", 2, Color3.fromRGB(40, 15, 18), function()
        if MainFrame then MainFrame.Visible = false end
    end)

    hubPrettyBtn(pageFlashHub, "Show Flash Block", 1, COLOR_ACCENT, function()
        showFlashBlock()
    end)
    hubPrettyBtn(pageFlashHub, "Close Flash Block", 2, Color3.fromRGB(40, 15, 18), function()
        closeFlashBlock()
    end)

    local emptyT = Instance.new("TextLabel")
    emptyT.Size = UDim2.new(1, 0, 0, 30)
    emptyT.BackgroundTransparency = 1
    emptyT.Text = "Proximamente..."
    emptyT.TextColor3 = COLOR_TEXT_DARK
    emptyT.Font = MAIN_FONT
    emptyT.TextSize = 11
    emptyT.ZIndex = 5
    emptyT.Parent = pageTPHub

    switchHubCat("Semi TP")
    addCollapseToggle(HubHeader, HubFrame, hubHeight, {HubBody}, function()
        if HubBody then HubBody.Visible = true end
        switchHubCat(hubCurrent or "Semi TP")
    end)

-- ===== PANEL SPEED BOOSTER =====
    local speedBoostHeight = 200
    SpeedFrame = createPanelFrame("SpeedBoosterPanel", panelWidth, speedBoostHeight,
        IsMobile and UDim2.new(0.88, -(panelWidth + 12), 0.05, 0)
            or UDim2.new(0.84, -(panelWidth + 12), 0.02, 0))
    SpeedFrame.AnchorPoint = Vector2.new(1, 0)
    SpeedHeader = createHeader(SpeedFrame, "SPEED BOOSTER")
    makeDraggable(SpeedHeader, SpeedFrame)

    SpeedContent = Instance.new("Frame")
    SpeedContent.Size = UDim2.new(1, -16, 1, -48)
    SpeedContent.Position = UDim2.new(0, 8, 0, 44)
    SpeedContent.BackgroundTransparency = 1
    SpeedContent.ZIndex = 3
    SpeedContent.Parent = SpeedFrame

    SpeedList = Instance.new("UIListLayout", SpeedContent)
    SpeedList.SortOrder = Enum.SortOrder.LayoutOrder
    SpeedList.Padding = UDim.new(0, 6)

    local function createSpeedValueRow(parent, order, labelText, initialValue, minV, maxV, onChanged)
        row = createRowFrame(parent, 28, order)
        lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = COLOR_TEXT_LIGHT
        lbl.Font = MAIN_FONT
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
        lbl.Parent = row

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 55, 0, 20)
        box.Position = UDim2.new(1, -63, 0.5, -10)
        box.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
        box.Text = tostring(initialValue)
        box.TextColor3 = COLOR_TEXT_LIGHT
        box.Font = MAIN_FONT
        box.TextSize = 10
        box.ClearTextOnFocus = false
        box.ZIndex = 6
        box.Parent = row
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", box).Color = COLOR_BORDER

        local val = initialValue
        box.FocusLost:Connect(function()
            local n = tonumber(box.Text)
            if n then
                n = math.clamp(math.floor(n), minV, maxV)
                val = n
                box.Text = tostring(n)
                pcall(onChanged, n)
            else
                box.Text = tostring(val)
            end
        end)
        return row
    end

    local trackNS, pinNS, trackS, pinS

    local function setToggleVisual(track, pin, state)
        if not track or not pin then return end
        if state then
            track.BackgroundColor3 = COLOR_ACCENT
            pin.Position = UDim2.new(1, -22, 0.5, -10)
            pin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            local st = track:FindFirstChildOfClass("UIStroke")
            if st then st.Color = Color3.fromRGB(255, 100, 120) end
        else
            track.BackgroundColor3 = Color3.fromRGB(70, 70, 75)
            pin.Position = UDim2.new(0, 2, 0.5, -10)
            pin.BackgroundColor3 = Color3.fromRGB(200, 200, 205)
            local st = track:FindFirstChildOfClass("UIStroke")
            if st then st.Color = Color3.fromRGB(100, 100, 105) end
        end
    end

    rowNS = createRowFrame(SpeedContent, 28, 1)
    trackNS, pinNS = createModernToggle(rowNS, "Speed No Stealing", speedNoStealEnabled, function(ns)
        speedNoStealEnabled = ns
        HubConfig.speedNoStealEnabled = ns
        if ns and speedStealEnabled then
            speedStealEnabled = false
            HubConfig.speedStealEnabled = false
            setToggleVisual(trackS, pinS, false)
        end
        saveHubConfig()
    end)

    createSpeedValueRow(SpeedContent, 2, "No Steal Speed", speedNoStealValue, 5, 300, function(v)
        speedNoStealValue = v
        HubConfig.speedNoStealValue = v
        saveHubConfig()
    end)

    rowS = createRowFrame(SpeedContent, 28, 3)
    trackS, pinS = createModernToggle(rowS, "Speed Stealing", speedStealEnabled, function(ns)
        speedStealEnabled = ns
        HubConfig.speedStealEnabled = ns
        if ns and speedNoStealEnabled then
            speedNoStealEnabled = false
            HubConfig.speedNoStealEnabled = false
            setToggleVisual(trackNS, pinNS, false)
        end
        saveHubConfig()
    end)

    createSpeedValueRow(SpeedContent, 4, "Steal Speed", speedStealValue, 5, 300, function(v)
        speedStealValue = v
        HubConfig.speedStealValue = v
        saveHubConfig()
    end)

    addCollapseToggle(SpeedHeader, SpeedFrame, speedBoostHeight, {SpeedContent})

    -- ===== PANEL AP SPAMMER =====
    local apSpamHeight = math.floor(utilsPanelHeight * 0.55) + 20
    APSpamFrame = createPanelFrame("APSpamPanel", panelWidth, apSpamHeight,
        IsMobile and UDim2.new(0.88, -(panelWidth + 12), 0.05, speedBoostHeight + 12)
            or UDim2.new(0.84, -(panelWidth + 12), 0.02, speedBoostHeight + 12))
    APSpamFrame.AnchorPoint = Vector2.new(1, 0)
    APSpamHeader = createHeader(APSpamFrame, "AP SPAMMER")
    makeDraggable(APSpamHeader, APSpamFrame)

    APSpamContent = Instance.new("Frame")
    APSpamContent.Size = UDim2.new(1, -16, 1, -48)
    APSpamContent.Position = UDim2.new(0, 8, 0, 44)
    APSpamContent.BackgroundTransparency = 1
    APSpamContent.ZIndex = 3
    APSpamContent.Parent = APSpamFrame

    APSubLabel = Instance.new("TextLabel")
    APSubLabel.Size = UDim2.new(1, 0, 0, 16)
    APSubLabel.BackgroundTransparency = 1
    APSubLabel.Text = "Choose a player to spam:"
    APSubLabel.TextColor3 = COLOR_TEXT_DARK
    APSubLabel.Font = MAIN_FONT
    APSubLabel.TextSize = 10
    APSubLabel.TextXAlignment = Enum.TextXAlignment.Left
    APSubLabel.ZIndex = 5
    APSubLabel.Parent = APSpamContent

    APPlayerScroll = Instance.new("ScrollingFrame")
    APPlayerScroll.Size = UDim2.new(1, 0, 1, -52)
    APPlayerScroll.Position = UDim2.new(0, 0, 0, 18)
    APPlayerScroll.BackgroundColor3 = COLOR_CARD_BG
    APPlayerScroll.BackgroundTransparency = 0.2
    APPlayerScroll.BorderSizePixel = 0
    APPlayerScroll.ScrollBarThickness = 3
    APPlayerScroll.ScrollBarImageColor3 = COLOR_ACCENT
    APPlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    APPlayerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    APPlayerScroll.ZIndex = 5
    APPlayerScroll.Parent = APSpamContent
    Instance.new("UIStroke", APPlayerScroll).Color = COLOR_BORDER

    APPlayerList = Instance.new("UIListLayout", APPlayerScroll)
    APPlayerList.SortOrder = Enum.SortOrder.Name
    APPlayerList.Padding = UDim.new(0, 3)
    APPlayerPad = Instance.new("UIPadding", APPlayerScroll)
    APPlayerPad.PaddingTop = UDim.new(0, 3)
    APPlayerPad.PaddingBottom = UDim.new(0, 3)
    APPlayerPad.PaddingLeft = UDim.new(0, 3)
    APPlayerPad.PaddingRight = UDim.new(0, 3)

    local apSpamTarget = nil
    local apBalloonEnabled = false
    local apPlayerButtons = {}

    local function apCreatePlayerButton(plr)
        if apPlayerButtons[plr.Name] then return end
        row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, 24)
        row.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
        row.BorderSizePixel = 0
        row.ZIndex = 6
        row.Parent = APPlayerScroll
        Instance.new("UIStroke", row).Color = COLOR_BORDER

        nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -58, 1, 0)
        nameLbl.Position = UDim2.new(0, 6, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = plr.Name
        nameLbl.TextColor3 = COLOR_TEXT_LIGHT
        nameLbl.Font = MAIN_FONT
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex = 7
        nameLbl.Parent = row

        spamBtn = Instance.new("TextButton")
        spamBtn.Size = UDim2.new(0, 48, 0, 18)
        spamBtn.Position = UDim2.new(1, -52, 0.5, -9)
        spamBtn.BackgroundColor3 = COLOR_ACCENT
        spamBtn.BorderSizePixel = 0
        spamBtn.Text = "Spam"
        spamBtn.TextColor3 = COLOR_BG_DARK
        spamBtn.Font = MAIN_FONT
        spamBtn.TextSize = 10
        spamBtn.ZIndex = 8
        spamBtn.AutoButtonColor = false
        spamBtn.Parent = row
        Instance.new("UICorner", spamBtn).CornerRadius = UDim.new(0, 4)

        spamBtn.MouseButton1Click:Connect(function()
            if _G.APSpamMasterEnabled == false then return end
            apSpamTarget = plr
            task.spawn(function()
                pcall(apSpamPlayer, plr)
            end)
        end)

        apPlayerButtons[plr.Name] = row
    end

    local function apRefreshPlayers()
        for name, btn in pairs(apPlayerButtons) do
            local still = Players:FindFirstChild(name)
            if not still or still == player then
                if btn then btn:Destroy() end
                apPlayerButtons[name] = nil
                if apSpamTarget and apSpamTarget.Name == name then apSpamTarget = nil end
            end
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then apCreatePlayerButton(plr) end
        end
    end

    apRefreshPlayers()
    Players.PlayerAdded:Connect(function(plr) task.wait(0.1); if plr ~= player then apCreatePlayerButton(plr) end end)
    Players.PlayerRemoving:Connect(function(plr)
        btn = apPlayerButtons[plr.Name]
        if btn then btn:Destroy() end
        apPlayerButtons[plr.Name] = nil
        if apSpamTarget == plr then apSpamTarget = nil end
    end)

    BalloonToggle = Instance.new("TextButton")
    BalloonToggle.Size = UDim2.new(1, 0, 0, 26)
    BalloonToggle.Position = UDim2.new(0, 0, 1, -28)
    BalloonToggle.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
    BalloonToggle.BorderSizePixel = 0
    BalloonToggle.Text = "Balloon OFF"
    BalloonToggle.TextColor3 = COLOR_TEXT_LIGHT
    BalloonToggle.Font = MAIN_FONT
    BalloonToggle.TextSize = 11
    BalloonToggle.ZIndex = 6
    BalloonToggle.Parent = APSpamContent
    Instance.new("UIStroke", BalloonToggle).Color = COLOR_BORDER
    addHoverAnimation(BalloonToggle, Color3.fromRGB(40, 15, 18), Color3.fromRGB(70, 20, 25))

    BalloonToggle.MouseButton1Click:Connect(function()
        apBalloonEnabled = not apBalloonEnabled
        BalloonToggle.Text = apBalloonEnabled and "Balloon ON" or "Balloon OFF"
        if apBalloonEnabled then
            BalloonToggle.BackgroundColor3 = COLOR_ACCENT
            BalloonToggle.TextColor3 = COLOR_BG_DARK
        else
            BalloonToggle.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
            BalloonToggle.TextColor3 = COLOR_TEXT_LIGHT
        end
    end)

    
    addCollapseToggle(APSpamHeader, APSpamFrame, apSpamHeight, {APSpamContent})



    -- ===== PANEL HELPER V1 =====
    local helperHeight = 160
    HelperFrame = createPanelFrame("HelperPanel", panelWidth, helperHeight,
        IsMobile and UDim2.new(0.12, 0, 0.05, 240) or UDim2.new(0.16, 0, 0.02, 250))
    HelperFrame.AnchorPoint = Vector2.new(0, 0)
    HelperHeader = createHeader(HelperFrame, "HELPER V1")
    makeDraggable(HelperHeader, HelperFrame)

    HelperContent = Instance.new("Frame")
    HelperContent.Name = "HelperContent"
    HelperContent.Size = UDim2.new(1, -16, 1, -52)
    HelperContent.Position = UDim2.new(0, 8, 0, 46)
    HelperContent.BackgroundTransparency = 1
    HelperContent.ZIndex = 5
    HelperContent.Parent = HelperFrame

    local helperLayout = Instance.new("UIListLayout")
    helperLayout.Parent = HelperContent
    helperLayout.SortOrder = Enum.SortOrder.LayoutOrder
    helperLayout.Padding = UDim.new(0, 6)

    local helperResetCooldown = false

    local function createHelperBtn(text, order, bgColor, textColor, onClick)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundTransparency = 1
        row.LayoutOrder = order
        row.ZIndex = 6
        row.Parent = HelperContent

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = bgColor
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = textColor
        btn.Font = MAIN_FONT
        btn.TextSize = 13
        btn.ZIndex = 7
        btn.AutoButtonColor = false
        btn.Parent = row
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", btn)
        st.Color = Color3.fromRGB(255, 255, 255)
        st.Thickness = 1
        st.Transparency = 0.7
        addHoverAnimation(btn, bgColor, Color3.fromRGB(
            math.min(255, math.floor(bgColor.R * 255) + 40),
            math.min(255, math.floor(bgColor.G * 255) + 25),
            math.min(255, math.floor(bgColor.B * 255) + 25)
        ))
        btn.MouseButton1Click:Connect(function()
            pcall(onClick)
        end)
        return btn
    end

    createHelperBtn("Kick", 1, Color3.fromRGB(160, 25, 40), Color3.fromRGB(255, 255, 255), function()
        pcall(function() player:Kick("Kicked by HELPER V1") end)
    end)

    createHelperBtn("Rejoin", 2, Color3.fromRGB(50, 30, 120), Color3.fromRGB(255, 255, 255), function()
        task.spawn(function()
            local ts = game:GetService("TeleportService")
            local placeId = game.PlaceId
            local jobId = game.JobId
            local lp = player
            pcall(function() ts:TeleportToPlaceInstance(placeId, jobId, lp) end)
            task.wait(0.4)
            pcall(function() ts:TeleportToPlaceInstance(placeId, jobId) end)
            task.wait(0.4)
            pcall(function() ts:Teleport(placeId, lp) end)
            task.wait(0.4)
            pcall(function() ts:Teleport(placeId) end)
        end)
    end)

    createHelperBtn("Reset", 3, COLOR_ACCENT, Color3.fromRGB(255, 255, 255), function()
        if helperResetCooldown then return end
        helperResetCooldown = true
        local char = player.Character
        if not char then helperResetCooldown = false return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then helperResetCooldown = false return end
        local cam = Workspace.CurrentCamera
        if cam then
            cam.CameraType = Enum.CameraType.Scriptable
            cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 5, 10), hrp.Position)
            task.delay(0.15, function()
                if cam then
                    cam.CameraType = Enum.CameraType.Custom
                    if hum then cam.CameraSubject = hum end
                end
            end)
        end
        if hum then
            hum.BreakJointsOnDeath = true
            hum.PlatformStand = true
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)
        end
        hrp.AssemblyLinearVelocity = Vector3.new(0, 1000000, 0)
        task.delay(0.6, function() helperResetCooldown = false end)
    end)

    addCollapseToggle(HelperHeader, HelperFrame, helperHeight, {HelperContent})

    -- Pub Method: activar/desactivar funcion + mostrar/ocultar panel
    do
        local rowGrab = createRowFrame(pagePub, 28, 0)
        createModernToggle(rowGrab, "Auto Grab", AutoGrabEnabled, function(ns)
            setAutoGrab(ns)
            HubConfig.autoGrabEnabled = ns
            saveHubConfig()
        end)

        local rowNext = createRowFrame(pagePub, 28, 3)
        createModernToggle(rowNext, "Next Base", NextBaseEnabled, function(ns)
            setNextBase(ns)
            HubConfig.nextBaseEnabled = ns
            saveHubConfig()
        end)

        local rowSpeed = createRowFrame(pagePub, 28, 1)
        local speedOn = (speedNoStealEnabled or speedStealEnabled) and true or false
        if SpeedFrame then SpeedFrame.Visible = speedOn end
        createModernToggle(rowSpeed, "Speed Booster", speedOn, function(ns)
            if SpeedFrame then SpeedFrame.Visible = ns and true or false end
            if not ns then
                speedNoStealEnabled = false
                speedStealEnabled = false
                HubConfig.speedNoStealEnabled = false
                HubConfig.speedStealEnabled = false
                saveHubConfig()
                pcall(function()
                    if setToggleVisual and trackNS and pinNS then setToggleVisual(trackNS, pinNS, false) end
                    if setToggleVisual and trackS and pinS then setToggleVisual(trackS, pinS, false) end
                end)
            else
                speedNoStealEnabled = true
                HubConfig.speedNoStealEnabled = true
                saveHubConfig()
                pcall(function()
                    if setToggleVisual and trackNS and pinNS then setToggleVisual(trackNS, pinNS, true) end
                end)
            end
        end)

        local rowAP = createRowFrame(pagePub, 28, 2)
        if _G.APSpamMasterEnabled == nil then _G.APSpamMasterEnabled = true end
        local apOn = _G.APSpamMasterEnabled ~= false
        if APSpamFrame then APSpamFrame.Visible = apOn end
        createModernToggle(rowAP, "AP Spammer", apOn, function(ns)
            _G.APSpamMasterEnabled = ns and true or false
            if APSpamFrame then APSpamFrame.Visible = ns and true or false end
        end)
    end


    -- ===== TARGET BAR =====
    refreshTargetBar = function()
        if not TargetBarLabel then return end
        local stealing = (HalfwaySteal and HalfwaySteal.debounce) or (tick() < manualStealingUntil)
        if stealing then
            TargetBarLabel.Text = "Stealing..."
        else
            TargetBarLabel.Text = "Target: " .. tostring(getSlotTargetName())
        end
    end

    setStealingStatus = function(isStealing)
        if isStealing then
            manualStealingUntil = math.max(manualStealingUntil, tick() + 1.3)
            if refreshTargetBar then refreshTargetBar() end
            task.delay(1.3, function()
                if refreshTargetBar and tick() >= manualStealingUntil then refreshTargetBar() end
            end)
        elseif tick() >= manualStealingUntil and refreshTargetBar then
            refreshTargetBar()
        end
    end

    BottomBar = Instance.new("Frame")
    BottomBar.Name = "StickTargetBar"
    BottomBar.Size = UDim2.new(0, IsMobile and 280 or 300, 0, 30)
    BottomBar.AnchorPoint = Vector2.new(0.5, 1)
    BottomBar.Position = UDim2.new(0.5, 0, 1, -10)
    BottomBar.BackgroundColor3 = COLOR_CARD_BG
    BottomBar.BorderSizePixel = 0
    BottomBar.Active = false
    BottomBar.Parent = ScreenGui
    Instance.new("UICorner", BottomBar).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", BottomBar).Color = COLOR_ACCENT
    TargetBarLabel = Instance.new("TextLabel")
    TargetBarLabel.Size = UDim2.new(1, 0, 1, 0)
    TargetBarLabel.BackgroundTransparency = 1
    TargetBarLabel.Text = "Target: None"
    TargetBarLabel.TextColor3 = COLOR_TEXT_LIGHT
    TargetBarLabel.Font = MAIN_FONT
    TargetBarLabel.TextSize = 13
    TargetBarLabel.Parent = BottomBar
    applyTextGradient(TargetBarLabel)
    refreshTargetBar()

    task.spawn(function()
        while task.wait(0.5) do
            if not (HalfwaySteal and HalfwaySteal.debounce) and tick() >= manualStealingUntil then
                refreshTargetBar()
            end
        end
    end)

    -- ===== UISCALE =====
    local Camera = workspace.CurrentCamera
    local scales = {}
    local function addUIScale(el)
        if not el then return end
        local s = el:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        s.Parent = el
        table.insert(scales, s)
    end
    addUIScale(MainFrame)
    addUIScale(HubFrame)
    addUIScale(UtilsFrame)
    addUIScale(SpeedFrame)
    addUIScale(APSpamFrame)
    addUIScale(HelperFrame)

    local function UpdateScale()
        if not Camera then return end
        local v = Camera.ViewportSize
        local scale = math.min(v.X / 800, v.Y / 450)
        local clamped = IsMobile and math.clamp(scale * 1.15, 0.95, 1.4) or math.clamp(scale * 0.85, 0.75, 1.2)
        for _, s in ipairs(scales) do s.Scale = clamped end
    end
    UpdateScale()
    if Camera then Camera:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateScale) end
end)() -- END GUI

-- Compat
local GUI = Instance.new("ScreenGui")
GUI.Name = "StickAPSpamGui"
GUI.ResetOnSpawn = false
GUI.Enabled = false
GUI.Parent = getGuiParent()

_G.HalfwaySteal = HalfwaySteal
_G.SSExecute = function() pcall(HalfwaySteal.execute) end
_G.SetSlot = function(slot) HalfwaySteal.setSlot(slot) end

if AutoActivateEnabled then
    task.spawn(function()
        task.wait(0.5)
        HalfwaySteal.activate()
    end)
end

-- ==========================================
-- HEX DEFENSES
-- ==========================================
do
    local HexD = {}
    cloneref = cloneref or function(o) return o end
    local clonefunction = clonefunction or function(f) return f end
    local getconstants_shim = (debug and debug.getconstants) or getconstants

    HexD.hexTargetRemote, HexD.hexFireRemote = nil, function() end
    HexD.hexAimbotRange = 100
    HexD.hexLaserConn, HexD.hexWebConn = nil, nil

    task.spawn(function()
        local packages = ReplicatedStorage:WaitForChild("Packages", 20)
        local netFolder = packages and packages:WaitForChild("Net", 20)
        if not netFolder then return end
        while not HexD.hexTargetRemote do
            if getconnections and getconstants_shim then
                local found = false
                for _, r in ipairs(netFolder:GetChildren()) do
                    if r:IsA("RemoteEvent") then
                        local ok, conns = pcall(getconnections, r.OnClientEvent)
                        if ok and type(conns) == "table" then
                            for _, c in ipairs(conns) do
                                if c and type(c.Function) == "function" then
                                    local okc, consts = pcall(getconstants_shim, c.Function)
                                    if okc and type(consts) == "table" then
                                        for _, k in ipairs(consts) do
                                            if k == "PaintballHitted" then
                                                HexD.hexTargetRemote = cloneref(r)
                                                HexD.hexFireRemote = clonefunction(HexD.hexTargetRemote.FireServer)
                                                found = true
                                                break
                                            end
                                        end
                                    end
                                end
                                if found then break end
                            end
                        end
                    end
                    if found then break end
                end
            end
            if HexD.hexTargetRemote then break end
            task.wait(1)
        end
    end)

    function HexD.hexGetNearestPlayer(maxRange)
        maxRange = maxRange or math.huge
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
        local myPos, nearest, shortest = player.Character.HumanoidRootPart.Position, nil, maxRange
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local h = pl.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    local dist = (pl.Character.HumanoidRootPart.Position - myPos).Magnitude
                    if dist < shortest then shortest, nearest = dist, pl end
                end
            end
        end
        return nearest
    end

    function HexD.hexFireLaserAt(targetPart)
        if not targetPart or not HexD.hexTargetRemote then return end
        pcall(function() HexD.hexFireRemote(HexD.hexTargetRemote, targetPart.Position, targetPart) end)
    end

    function HexD.hexFireWebAt(targetPart)
        if not targetPart or not HexD.hexTargetRemote then return end
        local char, bp = player.Character, player:FindFirstChild("Backpack")
        local tool = (bp and bp:FindFirstChild("Web Slinger")) or (char and char:FindFirstChild("Web Slinger"))
        if tool and tool:FindFirstChild("Handle") then
            pcall(function()
                HexD.hexFireRemote(HexD.hexTargetRemote, Vector3.new(targetPart.Position.X, targetPart.Position.Y, targetPart.Position.Z), targetPart, tool.Handle)
            end)
        end
    end

    function HexD.hexFindLaserCape()
        local char, bp = player.Character, player:FindFirstChild("Backpack")
        return (char and char:FindFirstChild("Laser Cape")) or (bp and bp:FindFirstChild("Laser Cape")) or nil
    end

    function HexD.hexGetLaserCape()
        local char = player.Character
        local tool = HexD.hexFindLaserCape()
        if tool and char and tool.Parent ~= char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(tool) end) end
        end
        return tool
    end

    function HexD.hexSetupLaserAim()
        local tool = HexD.hexFindLaserCape()
        if not tool then return end
        if HexD.hexLaserTool == tool and HexD.hexLaserConn and HexD.hexLaserConn.Connected then return end
        if HexD.hexLaserConn then HexD.hexLaserConn:Disconnect() end
        HexD.hexLaserTool = tool
        HexD.hexLaserConn = tool.Activated:Connect(function()
            if not HexDefenseState.Aimbot then return end
            local target = HexD.hexGetNearestPlayer(HexD.hexAimbotRange)
            if target and target.Character then
                local tp = target.Character:FindFirstChild("HumanoidRootPart")
                if tp then HexD.hexFireLaserAt(tp) end
            end
        end)
    end

    function HexD.hexSetupWebAim()
        local char, bp = player.Character, player:FindFirstChild("Backpack")
        local tool = (bp and bp:FindFirstChild("Web Slinger")) or (char and char:FindFirstChild("Web Slinger"))
        if not tool then return end
        if HexD.hexWebTool == tool and HexD.hexWebConn and HexD.hexWebConn.Connected then return end
        if HexD.hexWebConn then HexD.hexWebConn:Disconnect() end
        HexD.hexWebTool = tool
        HexD.hexWebConn = tool.Activated:Connect(function()
            if not HexDefenseState.Aimbot then return end
            local target = HexD.hexGetNearestPlayer(HexD.hexAimbotRange)
            if target and target.Character then
                local tp = target.Character:FindFirstChild("HumanoidRootPart")
                if tp then HexD.hexFireWebAt(tp) end
            end
        end)
    end

    function HexD.hexRefreshAimbot()
        if HexDefenseState.Aimbot then
            pcall(HexD.hexSetupLaserAim)
            pcall(HexD.hexSetupWebAim)
        else
            if HexD.hexLaserConn then HexD.hexLaserConn:Disconnect(); HexD.hexLaserConn = nil end
            if HexD.hexWebConn then HexD.hexWebConn:Disconnect(); HexD.hexWebConn = nil end
            HexD.hexLaserTool, HexD.hexWebTool = nil, nil
        end
    end
    _G.HexAimbotRefresh = HexD.hexRefreshAimbot

    if player.Backpack then
        player.Backpack.ChildAdded:Connect(function() task.wait(0.1) HexD.hexRefreshAimbot() end)
    end
    player.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(function() task.wait(0.1) HexD.hexRefreshAimbot() end)
    end)
    if player.Character then
        player.Character.ChildAdded:Connect(function() task.wait(0.1) HexD.hexRefreshAimbot() end)
    end

    HexD.hexGlobalCooldowns = { balloon = 0, ragdoll = 0, rocket = 0 }
    HexD.hexLastCommandTime = 0
    HexD.hexProcessedTexts = setmetatable({}, { __mode = "k" })
    HexD.hexAdminButtonsCache = {}
    HexD.hexLastCacheTime = 0
    HexD.hexLaserLastShot = 0

    function HexD.hexClickAdminButton(button)
        pcall(function()
            if firesignal then
                firesignal(button.MouseButton1Click)
                firesignal(button.Activated)
            else
                for _, c in ipairs(getconnections(button.MouseButton1Click)) do pcall(c.Function) end
                for _, c in ipairs(getconnections(button.Activated)) do pcall(c.Function) end
            end
        end)
    end

    function HexD.hexUpdateAdminCache()
        local now = tick()
        if now - HexD.hexLastCacheTime < 3 and #HexD.hexAdminButtonsCache > 0 then return end
        HexD.hexLastCacheTime = now
        table.clear(HexD.hexAdminButtonsCache)
        local adminPanel = PlayerGui:FindFirstChild("AdminPanel")
        if not adminPanel then return end
        for _, desc in ipairs(adminPanel:GetDescendants()) do
            if desc:IsA("TextButton") or desc:IsA("ImageButton") then
                local txt = (desc:IsA("TextButton") and desc.Text) or ""
                if txt == "" then
                    local lbl = desc:FindFirstChildWhichIsA("TextLabel", true)
                    if lbl then txt = lbl.Text end
                end
                if txt ~= "" then
                    table.insert(HexD.hexAdminButtonsCache, { btn = desc, text = txt:lower() })
                end
            end
        end
    end

    function HexD.hexFindPlayerButton(targetPlayer)
        HexD.hexUpdateAdminCache()
        local displayName = targetPlayer.DisplayName:lower()
        local userName = targetPlayer.Name:lower()
        for _, data in ipairs(HexD.hexAdminButtonsCache) do
            local txt = data.text
            if txt == displayName or txt:find(displayName, 1, true) or txt == userName or txt:find(userName, 1, true) then
                return data.btn
            end
        end
        return nil
    end

    function HexD.hexGetCommandButton(cmdName)
        HexD.hexUpdateAdminCache()
        for _, data in ipairs(HexD.hexAdminButtonsCache) do
            local txt = data.text
            if (txt:match("^:") or txt:match("^;")) and txt:find(cmdName, 1, true) then
                return data.btn
            end
        end
        return nil
    end

    function HexD.hexPunishWithAP(target)
        if not HexDefenseState.AP or not target then return end
        local now = tick()
        if now - HexD.hexLastCommandTime < 1.5 then return end
        local playerBtn = HexD.hexFindPlayerButton(target)
        if not playerBtn then return end
        local cmd = nil
        if now - HexD.hexGlobalCooldowns.balloon >= 30 then cmd = "balloon"
        elseif now - HexD.hexGlobalCooldowns.ragdoll >= 30 then cmd = "ragdoll"
        elseif now - HexD.hexGlobalCooldowns.rocket >= 120 then cmd = "rocket" end
        if cmd then
            local cmdBtn = HexD.hexGetCommandButton(cmd)
            if cmdBtn then
                HexD.hexGlobalCooldowns[cmd] = now
                HexD.hexLastCommandTime = now
                HexD.hexClickAdminButton(playerBtn)
                HexD.hexClickAdminButton(cmdBtn)
            end
        end
    end

    function HexD.hexPunishWithLaser(target)
        if not HexDefenseState.Laser or not target then return end
        if not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
        local now = tick()
        if now - HexD.hexLaserLastShot < 1 then return end
        local tool = HexD.hexGetLaserCape()
        if not tool then return end
        HexD.hexLaserLastShot = now
        task.spawn(function()
            task.wait(0.1)
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                HexD.hexFireLaserAt(target.Character.HumanoidRootPart)
            end
        end)
    end

    function HexD.hexGetPlayerInMyBase()
        local base = findMyBase()
        if not base then return nil end
        local baseCFrame, baseSize = base:GetBoundingBox()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local localPoint = baseCFrame:PointToObjectSpace(p.Character.HumanoidRootPart.Position)
                if math.abs(localPoint.X) <= (baseSize.X / 2)
                   and math.abs(localPoint.Y) <= (baseSize.Y / 2)
                   and math.abs(localPoint.Z) <= (baseSize.Z / 2) then
                    return p
                end
            end
        end
        return nil
    end

    function HexD.hexCheckStealText(desc)
        if not HexDefenseState.AP and not HexDefenseState.Laser then return end
        local text = desc.Text
        if not text or text == "" then return end
        if text:lower():find("stealing") then
            if desc.Visible and desc.AbsoluteSize.X > 0 and desc.AbsoluteSize.Y > 0 then
                if HexD.hexProcessedTexts[desc] ~= text then
                    HexD.hexProcessedTexts[desc] = text
                    local intruder = HexD.hexGetPlayerInMyBase()
                    if intruder then
                        HexD.hexPunishWithAP(intruder)
                        HexD.hexPunishWithLaser(intruder)
                    end
                end
            end
        end
    end

    function HexD.hexSetupLabel(desc)
        if desc:IsA("TextLabel") or desc:IsA("TextBox") then
            HexD.hexCheckStealText(desc)
            desc:GetPropertyChangedSignal("Text"):Connect(function() HexD.hexCheckStealText(desc) end)
            desc:GetPropertyChangedSignal("Visible"):Connect(function() HexD.hexCheckStealText(desc) end)
        end
    end

    for _, desc in ipairs(PlayerGui:GetDescendants()) do
        task.spawn(HexD.hexSetupLabel, desc)
    end
    PlayerGui.DescendantAdded:Connect(HexD.hexSetupLabel)
end

warn("[STICK] Script cargado correctamente.")