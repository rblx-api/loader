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
local Stats = game:GetService("Stats")

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
    for _, name in ipairs({"StickSemiTP_Main", "StickAPSpamGui", "AllowDisallow", "Stick_HelperV1", "Stick_SpeedBooster", "StickAutoStealProgress"}) do
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
    speedStealValue = 61,
    semiTpVisible = true,
    autoStealEnabled = false,
    antiDieEnabled = false,
    stealRadius = 55,
    stealDuration = 0.2
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
local SemiTpVisible = HubConfig.semiTpVisible ~= false
local AutoStealEnabled = HubConfig.autoStealEnabled or false
local AntiDieEnabled = HubConfig.antiDieEnabled or false
local StealRadius = HubConfig.stealRadius or 55
local StealDuration = HubConfig.stealDuration or 0.2
_G.SemiTpVisible = SemiTpVisible

local HexDefenseState = {
    AP = HubConfig.apDefenseEnabled or false,
    Laser = HubConfig.laserDefenseEnabled or false,
    Aimbot = HubConfig.aimbotEnabled or false
}

local selectedSlot = 1
local TargetBarLabel, refreshTargetBar, setStealingStatus
local manualStealingUntil = 0

-- ==========================================
-- SPEED BOOSTER
-- ==========================================
local speedNoStealEnabled = HubConfig.speedNoStealEnabled and true or false
local speedNoStealValue   = HubConfig.speedNoStealValue or 40
local speedStealEnabled   = HubConfig.speedStealEnabled and true or false
local speedStealValue     = HubConfig.speedStealValue or 61
_G.SpeedBoostPaused = false

local function startNoDropBoost()
    local BOOST_LV = "StickNoDropLV"
    local BOOST_ATT = "StickNoDropAtt"
    RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        local lv = hrp:FindFirstChild(BOOST_LV)
        if not lv then
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
        end
        if _G.SpeedBoostPaused then
            lv.PlaneVelocity = Vector2.zero
            return
        end
        local stealing = player:GetAttribute("Stealing") and true or false
        local spd = 0
        if speedNoStealEnabled then
            spd = speedNoStealValue
        elseif speedStealEnabled then
            if stealing then spd = speedStealValue end
        end
        if spd <= 0 then
            lv.PlaneVelocity = Vector2.zero
            return
        end
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
-- AUTO STEAL
-- ==========================================
local AutoSteal = {
    Enabled = AutoStealEnabled,
    Radius = StealRadius,
    Duration = StealDuration,
    Data = {},
    isStealing = false,
    startTime = nil,
    conn = nil
}

local function isMyPlotByName(plotName)
    local plots = Workspace:FindFirstChild("Plots")
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
    local char = player.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = Workspace:FindFirstChild("Plots")
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
                        if d <= AutoSteal.Radius and d < dist then
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

local function executeAutoSteal(prompt)
    if AutoSteal.isStealing then return end
    if not AutoSteal.Data[prompt] then
        AutoSteal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(AutoSteal.Data[prompt].hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(AutoSteal.Data[prompt].trigger, c.Function) end
            end
        end
    end
    local data = AutoSteal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    AutoSteal.isStealing = true
    AutoSteal.startTime = tick()
    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end
        local el = 0
        while el < AutoSteal.Duration do el = el + task.wait() end
        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
        task.wait(0.05)
        data.ready = true
        AutoSteal.isStealing = false
    end)
end

local function startAutoSteal()
    if AutoSteal.conn then return end
    AutoSteal.conn = RunService.Heartbeat:Connect(function()
        if not AutoSteal.Enabled or AutoSteal.isStealing then return end
        local p = findNearestPrompt()
        if p then executeAutoSteal(p) end
    end)
end

local function stopAutoSteal()
    if AutoSteal.conn then AutoSteal.conn:Disconnect(); AutoSteal.conn = nil end
    AutoSteal.isStealing = false
end

if AutoSteal.Enabled then startAutoSteal() end

-- ==========================================
-- ANTI-DIE
-- ==========================================
local AntiDie = { HealthConn = nil, DiedConn = nil }
local function enableAntiDie()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    AntiDie.HealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then hum.Health = hum.MaxHealth end
    end)
    AntiDie.DiedConn = hum.Died:Connect(function()
        task.wait()
        pcall(function()
            local newHum = Instance.new("Humanoid")
            newHum.Name = "Humanoid"
            newHum.Parent = char
            if Workspace.CurrentCamera then Workspace.CurrentCamera.CameraSubject = newHum end
            hum:Destroy()
        end)
    end)
end
local function disableAntiDie()
    if AntiDie.HealthConn then AntiDie.HealthConn:Disconnect(); AntiDie.HealthConn = nil end
    if AntiDie.DiedConn then AntiDie.DiedConn:Disconnect(); AntiDie.DiedConn = nil end
end
local function refreshAntiDie()
    disableAntiDie()
    if AntiDieEnabled then enableAntiDie() end
end
refreshAntiDie()
player.CharacterAdded:Connect(function()
    task.wait(0.2)
    refreshAntiDie()
end)

-- ==========================================
-- KICK AFTER STEAL
-- ==========================================
local kickKeyword = "you stole"
local function hasKickKeyword(text)
    if typeof(text) ~= "string" then return false end
    return string.find(string.lower(text), kickKeyword) ~= nil
end
local function checkAndKickObject(obj)
    if not KickAfterStealEnabled then return end
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
        if not _G.SemiTpVisible then
            darkBlueHighlight.Adornee = nil
            darkBlueHighlight.Parent = nil
        else
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
    if PotionEnabled or APOnStealEnabled then
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
            if AutoWalkEnabled then
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
    if APOnStealEnabled then task.spawn(doSpam) end
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
            if AutoTPOnAllowEnabled and not hasAutoTPTriggered and not HalfwaySteal.debounce and not player:GetAttribute("Stealing") then
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
local MainPanelFrameRef

do
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StickSemiTP_Main"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = safeGuiTarget

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
        local btn = Instance.new("TextButton")
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
        local overlay = Instance.new("Frame")
        overlay.Name = "PanelOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.35
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 2
        overlay.Active = false
        overlay.Parent = frame
        local stroke = Instance.new("UIStroke", frame)
        stroke.Thickness = 1.5
        stroke.Color = COLOR_ACCENT
        stroke.Transparency = 0.2
        return frame
    end

    local function createHeader(parent, title)
        local HeaderFrame = Instance.new("Frame")
        HeaderFrame.Size = UDim2.new(1, 0, 0, 38)
        HeaderFrame.BackgroundColor3 = Color3.fromRGB(8, 2, 4)
        HeaderFrame.BackgroundTransparency = 0
        HeaderFrame.BorderSizePixel = 0
        HeaderFrame.ZIndex = 3
        HeaderFrame.Parent = parent
        local HeaderLine = Instance.new("Frame")
        HeaderLine.Size = UDim2.new(1, 0, 0, 2)
        HeaderLine.Position = UDim2.new(0, 0, 1, 0)
        HeaderLine.BackgroundColor3 = COLOR_ACCENT
        HeaderLine.BorderSizePixel = 0
        HeaderLine.ZIndex = 3
        HeaderLine.Parent = HeaderFrame
        local TitleText = Instance.new("TextLabel")
        TitleText.Size = UDim2.new(1, -8, 1, 0)
        TitleText.Position = UDim2.new(0, 4, 0, 0)
        TitleText.BackgroundTransparency = 1
        TitleText.Text = title
        TitleText.TextColor3 = COLOR_TEXT_LIGHT
        TitleText.Font = MAIN_FONT
        TitleText.TextSize = 13
        TitleText.ZIndex = 4
        TitleText.Parent = HeaderFrame
        applyTextGradient(TitleText)
        return HeaderFrame
    end

    local function createRowFrame(parent, height, order)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -4, 0, height)
        card.BackgroundColor3 = COLOR_CARD_BG
        card.BackgroundTransparency = 0
        card.BorderSizePixel = 0
        card.ZIndex = 4
        card.Active = true
        card.LayoutOrder = order or 1
        card.Parent = parent
        local stroke = Instance.new("UIStroke", card)
        stroke.Thickness = 1
        stroke.Color = COLOR_BORDER
        return card
    end

    local function createModernToggle(parentCard, textLabel, initialState, onClick)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = textLabel
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = MAIN_FONT
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 25
        lbl.Parent = parentCard

        local track = Instance.new("TextButton")
        track.Size = UDim2.new(0, 36, 0, 18)
        track.Position = UDim2.new(1, -44, 0.5, -9)
        track.BackgroundColor3 = initialState and COLOR_ACCENT or Color3.fromRGB(40, 15, 18)
        track.BorderSizePixel = 0
        track.Text = ""
        track.ZIndex = 21
        track.Active = true
        track.AutoButtonColor = false
        track.Parent = parentCard
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local pin = Instance.new("Frame")
        pin.Size = UDim2.new(0, 14, 0, 14)
        pin.Position = initialState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        pin.BackgroundColor3 = initialState and COLOR_BG_DARK or Color3.fromRGB(180, 180, 180)
        pin.BorderSizePixel = 0
        pin.ZIndex = 22
        pin.Parent = track
        Instance.new("UICorner", pin).CornerRadius = UDim.new(1, 0)

        local state = initialState
        track.MouseButton1Click:Connect(function()
            state = not state
            if state then
                track.BackgroundColor3 = COLOR_ACCENT
                pin.Position = UDim2.new(1, -16, 0.5, -7)
                pin.BackgroundColor3 = COLOR_BG_DARK
            else
                track.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
                pin.Position = UDim2.new(0, 2, 0.5, -7)
                pin.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            end
            pcall(onClick, state)
        end)
        return track, pin
    end

    -- ===== PANEL MAIN =====
    local MainFrame = createPanelFrame("MainPanel", panelWidth, mainPanelHeight,
        IsMobile and UDim2.new(0.88, 0, 0.05, 0) or UDim2.new(0.84, 0, 0.02, 0))
    MainPanelFrameRef = MainFrame
    local MainHeader = createHeader(MainFrame, "STICK SEMI TP")
    makeDraggable(MainHeader, MainFrame)

    local MainContent = Instance.new("Frame")
    MainContent.Size = UDim2.new(1, -16, 1, -48)
    MainContent.Position = UDim2.new(0, 8, 0, 44)
    MainContent.BackgroundTransparency = 1
    MainContent.ZIndex = 3
    MainContent.Parent = MainFrame

    local MainList = Instance.new("UIListLayout", MainContent)
    MainList.SortOrder = Enum.SortOrder.LayoutOrder
    MainList.Padding = UDim.new(0, 6)

    local Row1 = createRowFrame(MainContent, 28, 1)
    local Label1 = Instance.new("TextLabel")
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

    local SelectorFrame = Instance.new("Frame")
    SelectorFrame.Size = UDim2.new(0, 95, 0, 20)
    SelectorFrame.Position = UDim2.new(1, -103, 0.5, -10)
    SelectorFrame.BackgroundTransparency = 1
    SelectorFrame.ZIndex = 5
    SelectorFrame.Parent = Row1

    local LeftBtn = Instance.new("TextButton")
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

    local SlotDisplay = Instance.new("TextLabel")
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

    local RightBtn = Instance.new("TextButton")
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

    local Row5 = createRowFrame(MainContent, 30, 2)
    local ActivateBtn = Instance.new("TextButton")
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

    local Row6 = createRowFrame(MainContent, 34, 3)
    local TeleportBtn = Instance.new("TextButton")
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
    local UtilsFrame = createPanelFrame("UtilsPanel", panelWidth, utilsPanelHeight,
        IsMobile and UDim2.new(0.88, 0, 0.05, mainPanelHeight + 12) or UDim2.new(0.84, 0, 0.02, mainPanelHeight + 12))
    local UtilsHeader = createHeader(UtilsFrame, "SETTINGS")
    makeDraggable(UtilsHeader, UtilsFrame)

    do
        local t = UtilsHeader:FindFirstChildOfClass("TextLabel")
        if t then t.Size = UDim2.new(1, -40, 1, 0) end
    end

    local CatBar = Instance.new("Frame")
    CatBar.Name = "CategoryBar"
    CatBar.Size = UDim2.new(1, -12, 0, 28)
    CatBar.Position = UDim2.new(0, 6, 0, 40)
    CatBar.BackgroundTransparency = 1
    CatBar.ZIndex = 3
    CatBar.Parent = UtilsFrame

    local CatLayout = Instance.new("UIListLayout", CatBar)
    CatLayout.FillDirection = Enum.FillDirection.Horizontal
    CatLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    CatLayout.Padding = UDim.new(0, 3)
    CatLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local catPages = {}
    local catButtons = {}
    local currentCat = "Semi TP"

    local function createCategoryBtn(text, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, (panelWidth - 30) / 3, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = COLOR_TEXT_LIGHT
        btn.Font = MAIN_FONT
        btn.TextSize = 10
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.ZIndex = 5
        btn.LayoutOrder = order
        btn.Parent = CatBar
        local st = Instance.new("UIStroke", btn)
        st.Color = COLOR_BORDER
        st.Thickness = 1
        return btn
    end

    local function createCatPage(name)
        local page = Instance.new("ScrollingFrame")
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
        local list = Instance.new("UIListLayout", page)
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 6)
        catPages[name] = page
        return page
    end

    local pageSemi = createCatPage("Semi TP")
    local pageFlash = createCatPage("Flash TP Block")
    local pageTPBlock = createCatPage("TP Block")

    do
        local emptyTP = Instance.new("TextLabel")
        emptyTP.Size = UDim2.new(1, 0, 0, 40)
        emptyTP.BackgroundTransparency = 1
        emptyTP.Text = "Proximamente..."
        emptyTP.TextColor3 = COLOR_TEXT_DARK
        emptyTP.Font = MAIN_FONT
        emptyTP.TextSize = 11
        emptyTP.ZIndex = 5
        emptyTP.Parent = pageTPBlock
    end

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

    for i, name in ipairs({"Semi TP", "Flash TP Block", "TP Block"}) do
        local btn = createCategoryBtn(name, i)
        catButtons[name] = btn
        btn.MouseButton1Click:Connect(function()
            switchCategory(name)
        end)
    end

    switchCategory("Semi TP")

    local RowAutoActivate = createRowFrame(pageFlash, 28, 10)
    createModernToggle(RowAutoActivate, "Auto Activate", AutoActivateEnabled, function(ns)
        AutoActivateEnabled = ns
        HubConfig.autoActivateEnabled = ns
        saveHubConfig()
        if ns then task.spawn(function() HalfwaySteal.activate() end) end
    end)

    local Row2 = createRowFrame(pageFlash, 28, 11)
    createModernToggle(Row2, "Auto Potion", PotionEnabled, function(ns)
        PotionEnabled = ns
        HubConfig.potionEnabled = ns
        saveHubConfig()
    end)

    local RowAutoWalk = createRowFrame(pageFlash, 28, 13)
    createModernToggle(RowAutoWalk, "Auto Walk", AutoWalkEnabled, function(ns)
        AutoWalkEnabled = ns
        HubConfig.autoWalkEnabled = ns
        saveHubConfig()
    end)

    local RowAutoTPAllow = createRowFrame(pageFlash, 28, 17)
    createModernToggle(RowAutoTPAllow, "Auto TP on Allow", AutoTPOnAllowEnabled, function(ns)
        AutoTPOnAllowEnabled = ns
        HubConfig.autoTPOnAllowEnabled = ns
        saveHubConfig()
    end)

    local RowAPOnSteal = createRowFrame(pageFlash, 28, 14)
    createModernToggle(RowAPOnSteal, "AP on Steal", APOnStealEnabled, function(ns)
        APOnStealEnabled = ns
        HubConfig.apOnStealEnabled = ns
        saveHubConfig()
    end)

    local RowKickAfterSteal = createRowFrame(pageFlash, 28, 18)
    createModernToggle(RowKickAfterSteal, "Kick After Steal", KickAfterStealEnabled, function(ns)
        KickAfterStealEnabled = ns
        HubConfig.kickAfterStealEnabled = ns
        saveHubConfig()
        if ns then scanGuiForKick(PlayerGui) end
    end)

    local RowGear = createRowFrame(pageFlash, 28, 20)
    local LabelGear = Instance.new("TextLabel")
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

    local GearCycleBtn = Instance.new("TextButton")
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

    local Row4 = createRowFrame(pageFlash, 28, 21)
    if IsMobile then Row4.Visible = false end

    local Label4 = Instance.new("TextLabel")
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

    local KeybindBtn = Instance.new("TextButton")
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

    local RowAPDefense = createRowFrame(pageFlash, 28, 15)
    createModernToggle(RowAPDefense, "AP Defense", HexDefenseState.AP, function(ns)
        HexDefenseState.AP = ns
        HubConfig.apDefenseEnabled = ns
        saveHubConfig()
    end)

    local RowLaserDefense = createRowFrame(pageFlash, 28, 16)
    createModernToggle(RowLaserDefense, "Laser Defense", HexDefenseState.Laser, function(ns)
        HexDefenseState.Laser = ns
        HubConfig.laserDefenseEnabled = ns
        saveHubConfig()
    end)

    local RowAimbot = createRowFrame(pageFlash, 28, 12)
    createModernToggle(RowAimbot, "Aimbot", HexDefenseState.Aimbot, function(ns)
        HexDefenseState.Aimbot = ns
        HubConfig.aimbotEnabled = ns
        saveHubConfig()
        if _G.HexAimbotRefresh then pcall(_G.HexAimbotRefresh) end
    end)

    -- PageAutoSteal
    local RowASEnabled = createRowFrame(pageFlash, 28, 1)
    createModernToggle(RowASEnabled, "Auto Steal", AutoStealEnabled, function(ns)
        AutoStealEnabled = ns
        AutoSteal.Enabled = ns
        HubConfig.autoStealEnabled = ns
        saveHubConfig()
        if ns then startAutoSteal() else stopAutoSteal() end
    end)

    local RowASRadius = createRowFrame(pageFlash, 28, 2)
    local ASRadiusLabel = Instance.new("TextLabel")
    ASRadiusLabel.Size = UDim2.new(0.5, 0, 1, 0)
    ASRadiusLabel.Position = UDim2.new(0, 10, 0, 0)
    ASRadiusLabel.BackgroundTransparency = 1
    ASRadiusLabel.Text = "Radius"
    ASRadiusLabel.TextColor3 = COLOR_TEXT_LIGHT
    ASRadiusLabel.Font = MAIN_FONT
    ASRadiusLabel.TextSize = 10
    ASRadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
    ASRadiusLabel.ZIndex = 5
    ASRadiusLabel.Parent = RowASRadius

    local ASRadiusBox = Instance.new("TextBox")
    ASRadiusBox.Size = UDim2.new(0, 55, 0, 20)
    ASRadiusBox.Position = UDim2.new(1, -63, 0.5, -10)
    ASRadiusBox.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
    ASRadiusBox.Text = tostring(StealRadius)
    ASRadiusBox.TextColor3 = COLOR_TEXT_LIGHT
    ASRadiusBox.Font = MAIN_FONT
    ASRadiusBox.TextSize = 10
    ASRadiusBox.ClearTextOnFocus = false
    ASRadiusBox.ZIndex = 6
    ASRadiusBox.Parent = RowASRadius
    Instance.new("UICorner", ASRadiusBox).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", ASRadiusBox).Color = COLOR_BORDER
    ASRadiusBox.FocusLost:Connect(function()
        local n = tonumber(ASRadiusBox.Text)
        if n then
            n = math.clamp(math.floor(n), 10, 200)
            StealRadius = n
            AutoSteal.Radius = n
            HubConfig.stealRadius = n
            ASRadiusBox.Text = tostring(n)
            saveHubConfig()
        else
            ASRadiusBox.Text = tostring(StealRadius)
        end
    end)

    local RowASDuration = createRowFrame(pageFlash, 28, 3)
    local ASDurLabel = Instance.new("TextLabel")
    ASDurLabel.Size = UDim2.new(0.5, 0, 1, 0)
    ASDurLabel.Position = UDim2.new(0, 10, 0, 0)
    ASDurLabel.BackgroundTransparency = 1
    ASDurLabel.Text = "Duration (s)"
    ASDurLabel.TextColor3 = COLOR_TEXT_LIGHT
    ASDurLabel.Font = MAIN_FONT
    ASDurLabel.TextSize = 10
    ASDurLabel.TextXAlignment = Enum.TextXAlignment.Left
    ASDurLabel.ZIndex = 5
    ASDurLabel.Parent = RowASDuration

    local ASDurBox = Instance.new("TextBox")
    ASDurBox.Size = UDim2.new(0, 55, 0, 20)
    ASDurBox.Position = UDim2.new(1, -63, 0.5, -10)
    ASDurBox.BackgroundColor3 = Color3.fromRGB(16, 8, 10)
    ASDurBox.Text = tostring(StealDuration)
    ASDurBox.TextColor3 = COLOR_TEXT_LIGHT
    ASDurBox.Font = MAIN_FONT
    ASDurBox.TextSize = 10
    ASDurBox.ClearTextOnFocus = false
    ASDurBox.ZIndex = 6
    ASDurBox.Parent = RowASDuration
    Instance.new("UICorner", ASDurBox).CornerRadius = UDim.new(0, 5)
    Instance.new("UIStroke", ASDurBox).Color = COLOR_BORDER
    ASDurBox.FocusLost:Connect(function()
        local n = tonumber(ASDurBox.Text)
        if n then
            n = math.clamp(n, 0.05, 5)
            StealDuration = n
            AutoSteal.Duration = n
            HubConfig.stealDuration = n
            ASDurBox.Text = tostring(n)
            saveHubConfig()
        else
            ASDurBox.Text = tostring(StealDuration)
        end
    end)

    local RowAntiDie = createRowFrame(pageFlash, 28, 4)
    createModernToggle(RowAntiDie, "Anti-Die", AntiDieEnabled, function(ns)
        AntiDieEnabled = ns
        HubConfig.antiDieEnabled = ns
        saveHubConfig()
        refreshAntiDie()
    end)

    -- PageFlash
    local RowFlashShow = createRowFrame(pageSemi, 30, 1)
    local FlashShowBtn = Instance.new("TextButton")
    FlashShowBtn.Size = UDim2.new(1, 0, 1, 0)
    FlashShowBtn.BackgroundColor3 = Color3.fromRGB(32, 12, 15)
    FlashShowBtn.BorderSizePixel = 0
    FlashShowBtn.Text = "Show Semi TP"
    FlashShowBtn.TextColor3 = COLOR_TEXT_LIGHT
    FlashShowBtn.Font = MAIN_FONT
    FlashShowBtn.TextSize = 12
    FlashShowBtn.ZIndex = 6
    FlashShowBtn.Parent = RowFlashShow
    addHoverAnimation(FlashShowBtn, Color3.fromRGB(32, 12, 15), Color3.fromRGB(60, 18, 22))
    FlashShowBtn.MouseButton1Click:Connect(function()
        SemiTpVisible = true
        _G.SemiTpVisible = true
        HubConfig.semiTpVisible = true
        saveHubConfig()
        if MainPanelFrameRef then MainPanelFrameRef.Visible = true end
    end)

    local RowFlashClose = createRowFrame(pageSemi, 30, 2)
    local FlashCloseBtn = Instance.new("TextButton")
    FlashCloseBtn.Size = UDim2.new(1, 0, 1, 0)
    FlashCloseBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 30)
    FlashCloseBtn.BorderSizePixel = 0
    FlashCloseBtn.Text = "Close Semi TP"
    FlashCloseBtn.TextColor3 = COLOR_TEXT_LIGHT
    FlashCloseBtn.Font = MAIN_FONT
    FlashCloseBtn.TextSize = 12
    FlashCloseBtn.ZIndex = 6
    FlashCloseBtn.Parent = RowFlashClose
    addHoverAnimation(FlashCloseBtn, Color3.fromRGB(180, 20, 30), Color3.fromRGB(220, 40, 50))
    FlashCloseBtn.MouseButton1Click:Connect(function()
        SemiTpVisible = false
        _G.SemiTpVisible = false
        HubConfig.semiTpVisible = false
        saveHubConfig()
        if MainPanelFrameRef then MainPanelFrameRef.Visible = false end
        darkBlueHighlight.Adornee = nil
        darkBlueHighlight.Parent = nil
    end)

    if not SemiTpVisible and MainPanelFrameRef then MainPanelFrameRef.Visible = false end

    do
        local settingsContents = {CatBar}
        for _, pg in pairs(catPages) do table.insert(settingsContents, pg) end
        addCollapseToggle(UtilsHeader, UtilsFrame, utilsPanelHeight, settingsContents, function()
            CatBar.Visible = true
            switchCategory(currentCat or "Semi TP")
        end)
    end

    -- ===== PANEL SPEED BOOSTER =====
    local speedBoostHeight = 200
    local SpeedFrame = createPanelFrame("SpeedBoosterPanel", panelWidth, speedBoostHeight,
        IsMobile and UDim2.new(0.88, -(panelWidth + 12), 0.05, 0)
            or UDim2.new(0.84, -(panelWidth + 12), 0.02, 0))
    SpeedFrame.AnchorPoint = Vector2.new(1, 0)
    local SpeedHeader = createHeader(SpeedFrame, "SPEED BOOSTER")
    makeDraggable(SpeedHeader, SpeedFrame)

    local SpeedContent = Instance.new("Frame")
    SpeedContent.Size = UDim2.new(1, -16, 1, -48)
    SpeedContent.Position = UDim2.new(0, 8, 0, 44)
    SpeedContent.BackgroundTransparency = 1
    SpeedContent.ZIndex = 3
    SpeedContent.Parent = SpeedFrame

    local SpeedList = Instance.new("UIListLayout", SpeedContent)
    SpeedList.SortOrder = Enum.SortOrder.LayoutOrder
    SpeedList.Padding = UDim.new(0, 6)

    local function createSpeedValueRow(parent, order, labelText, initialValue, minV, maxV, onChanged)
        local row = createRowFrame(parent, 28, order)
        local lbl = Instance.new("TextLabel")
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
            pin.Position = UDim2.new(1, -16, 0.5, -7)
            pin.BackgroundColor3 = COLOR_BG_DARK
        else
            track.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
            pin.Position = UDim2.new(0, 2, 0.5, -7)
            pin.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        end
    end

    local rowNS = createRowFrame(SpeedContent, 28, 1)
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

    local rowS = createRowFrame(SpeedContent, 28, 3)
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
    local apSpamHeight = math.floor(utilsPanelHeight * 0.65) + 30
    local APSpamFrame = createPanelFrame("APSpamPanel", panelWidth, apSpamHeight,
        IsMobile and UDim2.new(0.88, -(panelWidth + 12), 0.05, speedBoostHeight + 12)
            or UDim2.new(0.84, -(panelWidth + 12), 0.02, speedBoostHeight + 12))
    APSpamFrame.AnchorPoint = Vector2.new(1, 0)
    local APSpamHeader = createHeader(APSpamFrame, "AP SPAMMER")
    makeDraggable(APSpamHeader, APSpamFrame)

    local APSpamContent = Instance.new("Frame")
    APSpamContent.Size = UDim2.new(1, -16, 1, -48)
    APSpamContent.Position = UDim2.new(0, 8, 0, 44)
    APSpamContent.BackgroundTransparency = 1
    APSpamContent.ZIndex = 3
    APSpamContent.Parent = APSpamFrame

    local APSubLabel = Instance.new("TextLabel")
    APSubLabel.Size = UDim2.new(1, 0, 0, 16)
    APSubLabel.BackgroundTransparency = 1
    APSubLabel.Text = "Choose a player to spam:"
    APSubLabel.TextColor3 = COLOR_TEXT_DARK
    APSubLabel.Font = MAIN_FONT
    APSubLabel.TextSize = 10
    APSubLabel.TextXAlignment = Enum.TextXAlignment.Left
    APSubLabel.ZIndex = 5
    APSubLabel.Parent = APSpamContent

    local APPlayerScroll = Instance.new("ScrollingFrame")
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

    local APPlayerList = Instance.new("UIListLayout", APPlayerScroll)
    APPlayerList.SortOrder = Enum.SortOrder.Name
    APPlayerList.Padding = UDim.new(0, 3)
    local APPlayerPad = Instance.new("UIPadding", APPlayerScroll)
    APPlayerPad.PaddingTop = UDim.new(0, 3)
    APPlayerPad.PaddingBottom = UDim.new(0, 3)
    APPlayerPad.PaddingLeft = UDim.new(0, 3)
    APPlayerPad.PaddingRight = UDim.new(0, 3)

    local apSpamTarget = nil
    local apBalloonEnabled = false
    local apPlayerButtons = {}

    local function apCreatePlayerButton(plr)
        if apPlayerButtons[plr.Name] then return end
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
        btn.BorderSizePixel = 0
        btn.Text = plr.Name
        btn.TextColor3 = COLOR_TEXT_LIGHT
        btn.Font = MAIN_FONT
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.ZIndex = 6
        btn.Parent = APPlayerScroll
        Instance.new("UIStroke", btn).Color = COLOR_BORDER
        btn.MouseEnter:Connect(function()
            if apSpamTarget ~= plr then btn.BackgroundColor3 = Color3.fromRGB(70, 20, 25) end
        end)
        btn.MouseLeave:Connect(function()
            if apSpamTarget ~= plr then btn.BackgroundColor3 = Color3.fromRGB(40, 15, 18) end
        end)
        btn.MouseButton1Click:Connect(function()
            apSpamTarget = plr
            for _, b in pairs(apPlayerButtons) do
                if b and b.Parent then
                    b.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
                    b.TextColor3 = COLOR_TEXT_LIGHT
                end
            end
            btn.BackgroundColor3 = COLOR_ACCENT
            btn.TextColor3 = COLOR_BG_DARK
        end)
        apPlayerButtons[plr.Name] = btn
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
        local btn = apPlayerButtons[plr.Name]
        if btn then btn:Destroy() end
        apPlayerButtons[plr.Name] = nil
        if apSpamTarget == plr then apSpamTarget = nil end
    end)

    local BalloonToggle = Instance.new("TextButton")
    BalloonToggle.Size = UDim2.new(0.48, 0, 0, 26)
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

    local SpamAllBtn = Instance.new("TextButton")
    SpamAllBtn.Size = UDim2.new(0.48, 0, 0, 26)
    SpamAllBtn.Position = UDim2.new(0.52, 0, 1, -28)
    SpamAllBtn.BackgroundColor3 = COLOR_ACCENT
    SpamAllBtn.BorderSizePixel = 0
    SpamAllBtn.Text = "Spam All"
    SpamAllBtn.TextColor3 = COLOR_BG_DARK
    SpamAllBtn.Font = MAIN_FONT
    SpamAllBtn.TextSize = 11
    SpamAllBtn.ZIndex = 6
    SpamAllBtn.Parent = APSpamContent
    addHoverAnimation(SpamAllBtn, COLOR_ACCENT, Color3.fromRGB(255, 80, 100))

    SpamAllBtn.MouseButton1Click:Connect(function() pcall(doSpam) end)

    task.spawn(function()
        while task.wait(0.12) do
            if apSpamTarget and apSpamTarget.Parent then
                local cache = collectAdminButtons()
                local pb = findPlayerBtn(cache, apSpamTarget)
                if pb then
                    clickGuiButton(pb)
                    task.wait()
                    for _, cmd in ipairs(ALL_CMDS) do
                        if selectedCmds[cmd] and cache.cmds[cmd] then
                            clickGuiButton(cache.cmds[cmd])
                            task.wait()
                        end
                    end
                    if apBalloonEnabled and cache.cmds["balloon"] then
                        clickGuiButton(cache.cmds["balloon"])
                    end
                else
                    for _, cmd in ipairs(ALL_CMDS) do
                        if selectedCmds[cmd] then pcall(fireCmd, apSpamTarget, cmd) end
                    end
                end
            end
        end
    end)

    addCollapseToggle(APSpamHeader, APSpamFrame, apSpamHeight, {APSpamContent})

    -- ===== PANEL HELPER V1 =====
    local helperHeight = 260
    local HelperFrame = createPanelFrame("HelperPanel", panelWidth, helperHeight,
        IsMobile and UDim2.new(0.88, -(panelWidth + 12), 0.05, speedBoostHeight + apSpamHeight + 24)
            or UDim2.new(0.84, -(panelWidth + 12), 0.02, speedBoostHeight + apSpamHeight + 24))
    HelperFrame.AnchorPoint = Vector2.new(1, 0)
    local HelperHeader = createHeader(HelperFrame, "HELPER V1")
    makeDraggable(HelperHeader, HelperFrame)

    local HelperContent = Instance.new("Frame")
    HelperContent.Size = UDim2.new(1, -16, 1, -48)
    HelperContent.Position = UDim2.new(0, 8, 0, 44)
    HelperContent.BackgroundTransparency = 1
    HelperContent.ZIndex = 3
    HelperContent.Parent = HelperFrame

    local HelperList = Instance.new("UIListLayout", HelperContent)
    HelperList.SortOrder = Enum.SortOrder.LayoutOrder
    HelperList.Padding = UDim.new(0, 6)

    local helperResetCooldown = false

    local function createHelperBtn(text, order, bgColor, textColor, onClick)
        local row = createRowFrame(HelperContent, 28, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = bgColor
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = textColor
        btn.Font = MAIN_FONT
        btn.TextSize = 11
        btn.ZIndex = 6
        btn.Parent = row
        addHoverAnimation(btn, bgColor, Color3.fromRGB(
            math.min(255, math.floor(bgColor.R * 255) + 40),
            math.min(255, math.floor(bgColor.G * 255) + 20),
            math.min(255, math.floor(bgColor.B * 255) + 20)
        ))
        btn.MouseButton1Click:Connect(onClick)
        return btn
    end

    createHelperBtn("Insta Reset (H)", 1, Color3.fromRGB(40, 15, 18), COLOR_TEXT_LIGHT, function()
        if helperResetCooldown then return end
        helperResetCooldown = true
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
        task.delay(0.5, function() helperResetCooldown = false end)
    end)

    createHelperBtn("Rejoin PS", 2, Color3.fromRGB(40, 15, 18), COLOR_TEXT_LIGHT, function()
        task.spawn(function()
            pcall(function() TeleportService:Teleport(game.PlaceId, player) end)
        end)
    end)

    createHelperBtn("Rejoin Job ID (J)", 3, Color3.fromRGB(40, 15, 18), COLOR_TEXT_LIGHT, function()
        task.spawn(function()
            local jobId = game.JobId
            if jobId and #tostring(jobId) > 0 then
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player) end)
            end
        end)
    end)

    createHelperBtn("Kick (Y)", 4, Color3.fromRGB(180, 20, 30), COLOR_TEXT_LIGHT, function()
        pcall(function() player:Kick("Kicked by HELPER V1") end)
    end)

    createHelperBtn("Kick To Private", 5, Color3.fromRGB(180, 20, 30), COLOR_TEXT_LIGHT, function()
        task.spawn(function()
            pcall(function()
                local code = TeleportService:ReserveServer(game.PlaceId)
                TeleportService:TeleportToPrivateServer(game.PlaceId, code, {player})
            end)
        end)
    end)

    createHelperBtn("Grapple TP", 6, COLOR_ACCENT, COLOR_BG_DARK, function()
        if HalfwaySteal and HalfwaySteal.SSDoTeleport then
            task.spawn(function() pcall(HalfwaySteal.SSDoTeleport) end)
        end
    end)

    addCollapseToggle(HelperHeader, HelperFrame, helperHeight, {HelperContent})

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

    local BottomBar = Instance.new("Frame")
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

    -- UISCALE
    local Camera = workspace.CurrentCamera
    local scales = {}
    local function addUIScale(el)
        if not el then return end
        local s = el:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        s.Parent = el
        table.insert(scales, s)
    end
    addUIScale(MainFrame)
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
end -- END GUI

-- ==========================================
-- BARRA DE PROGRESO AUTO STEAL
-- ==========================================
do
    local progScreenGui = Instance.new("ScreenGui")
    progScreenGui.Name = "StickAutoStealProgress"
    progScreenGui.ResetOnSpawn = false
    progScreenGui.DisplayOrder = 200
    progScreenGui.IgnoreGuiInset = true
    progScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    progScreenGui.Parent = safeGuiTarget

    local progFrame = Instance.new("Frame")
    progFrame.Size = UDim2.new(0, 380, 0, 34)
    progFrame.Position = UDim2.new(0.5, 0, 1, -65)
    progFrame.AnchorPoint = Vector2.new(0.5, 1)
    progFrame.BackgroundColor3 = COLOR_BG_DARK
    progFrame.BackgroundTransparency = 0.1
    progFrame.BorderSizePixel = 0
    progFrame.ZIndex = 300
    progFrame.ClipsDescendants = true
    progFrame.Parent = progScreenGui
    Instance.new("UICorner", progFrame).CornerRadius = UDim.new(0, 14)
    local progStroke = Instance.new("UIStroke", progFrame)
    progStroke.Color = COLOR_ACCENT
    progStroke.Thickness = 1.5
    progStroke.Transparency = 0.2

    local stealLabel = Instance.new("TextLabel")
    stealLabel.Size = UDim2.new(0, 55, 1, 0)
    stealLabel.Position = UDim2.new(0, 6, 0, 0)
    stealLabel.BackgroundTransparency = 1
    stealLabel.Text = "STEAL"
    stealLabel.TextColor3 = COLOR_TEXT_LIGHT
    stealLabel.Font = MAIN_FONT
    stealLabel.TextSize = 14
    stealLabel.TextXAlignment = Enum.TextXAlignment.Left
    stealLabel.Parent = progFrame

    local pctLabel = Instance.new("TextLabel")
    pctLabel.Size = UDim2.new(0, 45, 1, 0)
    pctLabel.Position = UDim2.new(0, 62, 0, 0)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Text = "0%"
    pctLabel.TextColor3 = COLOR_TEXT_LIGHT
    pctLabel.Font = MAIN_FONT
    pctLabel.TextSize = 14
    pctLabel.Parent = progFrame

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 100, 0, 18)
    barBg.Position = UDim2.new(0, 112, 0.5, -9)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 15, 18)
    barBg.BorderSizePixel = 0
    barBg.ClipsDescendants = true
    barBg.Parent = progFrame
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = COLOR_ACCENT
    progressFill.BorderSizePixel = 0
    progressFill.Parent = barBg
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(0, 60, 1, 0)
    fpsLabel.Position = UDim2.new(0, 248, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: 0"
    fpsLabel.TextColor3 = COLOR_TEXT_LIGHT
    fpsLabel.Font = MAIN_FONT
    fpsLabel.TextSize = 12
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.Parent = progFrame

    local pingLabel = Instance.new("TextLabel")
    pingLabel.Size = UDim2.new(0, 65, 1, 0)
    pingLabel.Position = UDim2.new(0, 312, 0, 0)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Text = "PING: 0ms"
    pingLabel.TextColor3 = COLOR_TEXT_LIGHT
    pingLabel.Font = MAIN_FONT
    pingLabel.TextSize = 12
    pingLabel.TextXAlignment = Enum.TextXAlignment.Right
    pingLabel.Parent = progFrame

    local frameCount = 0
    local lastFPSUpdate = tick()
    RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = tick()
        if now - lastFPSUpdate >= 1 then
            local fps = math.floor(frameCount / (now - lastFPSUpdate))
            fpsLabel.Text = "FPS: " .. tostring(fps)
            frameCount = 0
            lastFPSUpdate = now
            local ping = 0
            pcall(function()
                ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0)
            end)
            pingLabel.Text = "PING: " .. tostring(ping) .. "ms"
        end
    end)

    local progress = 0
    RunService.RenderStepped:Connect(function(dt)
        if AutoSteal.Enabled and AutoSteal.isStealing then
            progress = progress + (dt / math.max(AutoSteal.Duration, 0.05))
            if progress >= 1 then progress = 0 end
        else
            progress = 0
        end
        progressFill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
        pctLabel.Text = math.floor(progress * 100 + 0.5) .. "%"
    end)

    local dragging, dragStart, startPos = false, nil, nil
    progFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = progFrame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local delta = inp.Position - dragStart
            progFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- KEYBINDS HELPER
-- ==========================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.H then
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        end
    elseif input.KeyCode == Enum.KeyCode.J then
        task.spawn(function()
            local jobId = game.JobId
            if jobId and #tostring(jobId) > 0 then
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player) end)
            end
        end)
    elseif input.KeyCode == Enum.KeyCode.Y then
        pcall(function() player:Kick("Kicked by HELPER V1") end)
    end
end)

-- Compat
local GUI = Instance.new("ScreenGui")
GUI.Name = "StickAPSpamGui"
GUI.ResetOnSpawn = false
GUI.Enabled = false
GUI.Parent = getGuiParent()

_G.HalfwaySteal = HalfwaySteal
_G.SSExecute = function() pcall(HalfwaySteal.execute) end
_G.SetSlot = function(slot) HalfwaySteal.setSlot(slot) end
_G.AutoSteal = AutoSteal
_G.StickDoSpam = doSpam

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