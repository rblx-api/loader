-- FUNHUB 5.5: new four-tab GUI, selectable Funhub 1.4 GUI, scrollable tabs, Instant Carpet, Grapple Semi TP, and existing hub features.
-- One-time compatibility with earlier branded builds; live names use FUNHUB/FH.
do
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local old = "iCollectPro"
    for _, scope in ipairs({ env, _G }) do
        scope[old .. "_SemiTP_Gen"] = (tonumber(scope[old .. "_SemiTP_Gen"]) or 0) + 1
        local cleanup = scope.__iCPAuroraUnload
        if type(cleanup) == "function" then pcall(cleanup) end
        scope.__iCPAuroraUnload = nil
    end
    pcall(function()
        if type(isfolder) ~= "function" or type(listfiles) ~= "function" or type(writefile) ~= "function" then return end
        local oldDir, newDir = old .. "_SemiTP_Configs", "FUNHUB_SemiTP_Configs"
        if not isfolder(oldDir) then return end
        if not isfolder(newDir) then makefolder(newDir) end
        for _, name in ipairs(listfiles(oldDir)) do
            local tail = name:match("([^/\\]+%.json)$")
            if tail and not isfile(newDir .. "/" .. tail) then writefile(newDir .. "/" .. tail, readfile(name)) end
        end
    end)
end

_G.FUNHUB_SemiTP_Executed = true

local FUNHUB_ENV = (type(getgenv) == "function" and getgenv()) or _G
FUNHUB_ENV.__semiTpGen = (tonumber(FUNHUB_ENV.__semiTpGen) or 0) + 1
FUNHUB_ENV.FUNHUB_SemiTP_Gen = (tonumber(FUNHUB_ENV.FUNHUB_SemiTP_Gen) or 0) + 1
local FUNHUB_GEN = FUNHUB_ENV.FUNHUB_SemiTP_Gen
local function FUNHUB_ALIVE()
    return FUNHUB_ENV.FUNHUB_SemiTP_Gen == FUNHUB_GEN
end

do
    local function neuter(t)
        if type(t) ~= "table" then return end
        t.debounce = true
        t.execute = function() end
        t.SSDoTeleport = function() end
    end
    pcall(neuter, rawget(_G, "FUNHUB"))
    pcall(neuter, rawget(_G, "FUNHUB_SemiTP"))
    pcall(neuter, FUNHUB_ENV.FUNHUB)
    pcall(neuter, FUNHUB_ENV.FUNHUB_SemiTP)
    for _, key in ipairs({ "__semiTpTables", "FUNHUB_SemiTP_Tables" }) do
        if type(FUNHUB_ENV[key]) == "table" then
            for _, t in ipairs(FUNHUB_ENV[key]) do pcall(neuter, t) end
        end
    end
    FUNHUB_ENV.__semiTpTables = nil
    FUNHUB_ENV.FUNHUB = nil
    FUNHUB_ENV.FUNHUB_SemiTP_Tables = {}
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
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
    local roots = { getGuiParent(), safeGuiTarget }
    for _, name in ipairs({"FUNHUB_SemiTP", "FUNHUB_SemiTP_Progress", "FUNHUB_SemiTP_Speed", "FUNHUB_SemiTP_AP", "FUNHUB_SemiTP_Allow", "FUNHUB_SemiTP_ESP"}) do
        for _, root in ipairs(roots) do
            while root and root:FindFirstChild(name) do
                root[name]:Destroy()
            end
        end
    end
end)

local T = {
    BG = Color3.fromRGB(10, 18, 31),
    SURF = Color3.fromRGB(15, 27, 45),
    SURF2 = Color3.fromRGB(22, 43, 68),
    HOVER = Color3.fromRGB(28, 57, 91),
    TEXT = Color3.fromRGB(234, 244, 255),
    DIM = Color3.fromRGB(137, 166, 203),
    ACCENT = Color3.fromRGB(43, 139, 255),
    ACCENT2 = Color3.fromRGB(27, 94, 205),
    STROKE = Color3.fromRGB(54, 145, 255),
    GREEN1 = Color3.fromRGB(18, 88, 58),
    GREEN2 = Color3.fromRGB(21, 120, 76),
    GREEN_STROKE = Color3.fromRGB(60, 185, 120),
    ON_TEXT = Color3.fromRGB(232, 255, 240),
    OFF_BG = Color3.fromRGB(23, 39, 61),
    OFF_TEXT = Color3.fromRGB(122, 157, 200),
    TRACK = Color3.fromRGB(17, 31, 51),
    TRACK2 = Color3.fromRGB(23, 45, 71),
    FILL1 = Color3.fromRGB(38, 129, 250),
    FILL2 = Color3.fromRGB(130, 206, 255),
}

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function gradient(obj, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2) })
    g.Rotation = rot or 0
    g.Parent = obj
    return g
end

local function addShadow(obj, pad, transparency)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.Position = UDim2.new(0.5, 0, 0.5, 2)
    s.Size = UDim2.new(1, pad or 24, 1, pad or 24)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = Color3.new(0, 0, 0)
    s.ImageTransparency = transparency or 0.72
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.ZIndex = math.max(obj.ZIndex - 1, 0)
    s.Parent = obj
    return s
end

local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function addHover(obj, normalColor, hoverColor, rowStroke)
    obj.MouseEnter:Connect(function()
        tween(obj, 0.14, { BackgroundColor3 = hoverColor })
        if rowStroke then tween(rowStroke, 0.14, { Transparency = 0.38 }) end
    end)
    obj.MouseLeave:Connect(function()
        tween(obj, 0.14, { BackgroundColor3 = normalColor })
        if rowStroke then tween(rowStroke, 0.14, { Transparency = 0.52 }) end
    end)
end

local function makeDraggable(handle, target, onEnd)
    local dragging, dragInput, startInputPos, startPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            startInputPos = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    if onEnd then onEnd() end
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == dragInput) then
            local d = input.Position - startInputPos
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local configFile = "FUNHUB.json"
pcall(function()
    if isfile and readfile and writefile and not isfile(configFile) and isfile("AURORA_REMAKE.json") then
        writefile(configFile, readfile("AURORA_REMAKE.json"))
    end
end)
local HubConfig = {
    stealBoostAutoOnSteal = true,
    speedValue = 25,
    hexSpeedVisible = false,
    speedPos = {ScaleX = 0.98, OffsetX = 0, ScaleY = 0.02, OffsetY = 0},
    stealKeybind = "None",
    potionEnabled = true,
    giantPotionEnabled = true,
    griefShieldEnabled = true,
    autoTPOnAllowEnabled = false,
    kickAfterStealEnabled = false,
    antiRagdollEnabled = true,
    antiRocketEnabled = true,
    antiBeeEnabled = true,
    antiGummyEnabled = true,
    antiDiscoEnabled = true,
    destroySentryEnabled = false,
    destroyDogeEnabled = false,
    selectedSlot = 1
}

do
    local decoded
    if type(isfile) == "function" and type(readfile) == "function" then
        local ok, value = pcall(function()
            if isfile(configFile) then return HttpService:JSONDecode(readfile(configFile)) end
        end)
        if ok and type(value) == "table" then decoded = value end
    end
    -- Keep re-execution settings even on executors without file access.
    if (not decoded or FUNHUB_ENV.__FHConfigUnsaved) and type(FUNHUB_ENV.__FHConfigJSON) == "string" then
        local ok, value = pcall(HttpService.JSONDecode, HttpService, FUNHUB_ENV.__FHConfigJSON)
        if ok and type(value) == "table" then decoded = value end
    end
    for k, v in pairs(decoded or {}) do HubConfig[k] = v end
end
HubConfig.funhub = type(HubConfig.funhub) == "table" and HubConfig.funhub
    or (type(HubConfig.aurora) == "table" and HubConfig.aurora or {})
HubConfig.aurora = nil -- legacy settings imported above
HubConfig.apOnStealEnabled = nil
HubConfig.autoActivateEnabled = nil
HubConfig.quickGrabEnabled = nil -- superseded by the saved Quick Grab toggle

-- Canonical keyboard/mouse bindings. No action gets a key on a fresh install.
local FUNHUBKeys = {}
function FUNHUBKeys.decode(name)
    if type(name) ~= "string" or name == "" or name == "None" then return nil end
    if name == "MouseButton1" or name == "MouseButton2" or name == "MouseButton3" then return Enum.UserInputType[name] end
    local ok, key = pcall(function() return Enum.KeyCode[name] end)
    return ok and key ~= Enum.KeyCode.Unknown and key or nil
end
function FUNHUBKeys.input(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then return input.KeyCode.Name end
    for _, name in ipairs({ "MouseButton1", "MouseButton2", "MouseButton3" }) do
        if input.UserInputType == Enum.UserInputType[name] then return name end
    end
    return nil
end
function FUNHUBKeys.consume(input)
    FUNHUBKeys.consumedInput, FUNHUBKeys.captureHeld = input, true
    FUNHUBKeys.blockUntil = os.clock() + 0.15
end
function FUNHUBKeys.blocked(input)
    return (input ~= nil and input == FUNHUBKeys.consumedInput) or FUNHUBKeys.captureHeld == true
        or os.clock() < (FUNHUBKeys.blockUntil or 0)
end
UserInputService.InputEnded:Connect(function(input)
    if not FUNHUB_ALIVE() then return end
    if input == FUNHUBKeys.consumedInput then
        FUNHUBKeys.captureHeld = false
        -- MouseButtonClick follows InputEnded; do not reopen a bind on that release.
        FUNHUBKeys.blockUntil = os.clock() + 0.15
        task.delay(0.15, function()
            if FUNHUBKeys.consumedInput == input and not FUNHUBKeys.captureHeld then FUNHUBKeys.consumedInput = nil end
        end)
    end
end)
UserInputService.WindowFocusReleased:Connect(function()
    FUNHUBKeys.captureHeld, FUNHUBKeys.consumedInput = false, nil
end)
function FUNHUBKeys.migrate()
    local ui = HubConfig.funhub
    ui.keys = type(ui.keys) == "table" and ui.keys or {}
    if ui.keybindSchema ~= 2 then
        if ui.keys.hide == "RightControl" then ui.keys.hide = nil end
        if HubConfig.stealKeybind == "E" and not ui.keys.semiSteal then HubConfig.stealKeybind = "None" end
        if not ui.keys.semiSteal and FUNHUBKeys.decode(HubConfig.stealKeybind) then ui.keys.semiSteal = HubConfig.stealKeybind end
    end
    if not ui.keys.menu then ui.keys.menu = "LeftControl" end
    for name, key in pairs(ui.keys) do if not FUNHUBKeys.decode(key) then ui.keys[name] = nil end end
    ui.keysInit, ui.keybindSchema = true, 2
    HubConfig.stealKeybind = ui.keys.semiSteal or "None"
end
FUNHUBKeys.migrate()

local function saveHubConfig()
    if not FUNHUB_ALIVE() then return false end
    local encoded, json = pcall(HttpService.JSONEncode, HttpService, HubConfig)
    if not encoded then warn("[FUNHUB settings] Could not encode settings: " .. tostring(json)) return false end
    FUNHUB_ENV.__FHConfigJSON = json
    FUNHUB_ENV.__FHConfigUnsaved = true
    if type(writefile) == "function" then
        local ok, err = pcall(writefile, configFile, json)
        if ok then FUNHUB_ENV.__FHConfigUnsaved = false return true end
        if not FUNHUB_ENV.__FHSaveWarned then
            FUNHUB_ENV.__FHSaveWarned = true
            warn("[FUNHUB settings] File save failed; settings kept for this session: " .. tostring(err))
        end
    elseif not FUNHUB_ENV.__FHSaveWarned then
        FUNHUB_ENV.__FHSaveWarned = true
        warn("[FUNHUB settings] File access unavailable; settings kept for this session only.")
    end
    return false
end

if type(HubConfig.positions) ~= "table" then HubConfig.positions = {} end

local function restorePos(frame, key)
    local p = HubConfig.positions[key]
    if type(p) == "table" and #p == 4 then
        frame.Position = UDim2.new(tonumber(p[1]) or 0, tonumber(p[2]) or 0, tonumber(p[3]) or 0, tonumber(p[4]) or 0)
    end
end

local function rememberPos(frame, key)
    return function()
        local q = frame.Position
        HubConfig.positions[key] = { q.X.Scale, q.X.Offset, q.Y.Scale, q.Y.Offset }
        saveHubConfig()
    end
end

_G.FUNHUB_SemiTP_SpeedBoost = HubConfig.stealBoostAutoOnSteal ~= false
local currentSpeed = HubConfig.speedValue or 25
local currentStealKey = FUNHUBKeys.decode(HubConfig.stealKeybind)
local PotionEnabled = HubConfig.potionEnabled
local AutoTPOnAllowEnabled = HubConfig.autoTPOnAllowEnabled or false
local KickAfterStealEnabled = HubConfig.kickAfterStealEnabled or false
local AntiRagdollEnabled = HubConfig.antiRagdollEnabled ~= false
local AntiRocketEnabled = HubConfig.antiRocketEnabled ~= false
local FUNHUBFx = {
    bee = HubConfig.antiBeeEnabled ~= false,
    gummy = HubConfig.antiGummyEnabled ~= false,
    disco = HubConfig.antiDiscoEnabled ~= false,
    paint = HubConfig.antiPaintEnabled ~= false,
    web = HubConfig.antiWebEnabled ~= false,
    swap = HubConfig.antiSwapEnabled ~= false,
    infJump = HubConfig.infJumpEnabled == true,
    unlockTP = HubConfig.autoTPOnUnlockEnabled == true,
    sentry = HubConfig.destroySentryEnabled ~= false,
    doge = HubConfig.destroyDogeEnabled ~= false,
    ghost = HubConfig.serverGhostEnabled == true,
    esp = HubConfig.playerEspEnabled == true,
    tracers = HubConfig.tracersEnabled == true,
    aim = HubConfig.aimbotEnabled == true,
    spam = HubConfig.autoSpamEnabled == true,
    xray = HubConfig.baseXrayEnabled == true,
    timerEsp = HubConfig.baseTimerEspEnabled == true,
    timerFloors = HubConfig.timerEveryFloorEnabled == true,
    tags = HubConfig.stealTagsEnabled == true,
    baseEsp = HubConfig.baseEspEnabled == true,
    thiefBar = HubConfig.thiefBarEnabled == true,
    rejoin2 = HubConfig.autoRejoinEnabled == true,
    speedOn = HubConfig.moveSpeedEnabled == true,
    carpet = HubConfig.carpetSpeedEnabled == true,
    grav = HubConfig.gravityEnabled == true,
    fps = HubConfig.fpsOptimizerEnabled == true,
    pillBar = HubConfig.pillBarEnabled ~= false,
    defBypass = HubConfig.defenderBypassEnabled == true,
    pubGrab = HubConfig.publicGrabEnabled == true,
    noWalkDelay = HubConfig.funhub.noWalkDelay ~= false,
    fov = HubConfig.customFovEnabled == true,
    xfps = HubConfig.extremeFpsEnabled == true,
    hideAP = HubConfig.hideApIconEnabled == true,
}
FUNHUBFx.semiPauses = {}
function FUNHUBFx.backgroundPaused()
    return next(FUNHUBFx.semiPauses) ~= nil or _G.FUNHUB_SemiTP_Busy == true
        or _G.FUNHUB_SemiTP_ResetBusy == true
end
function FUNHUBFx.syncBackground()
    local actions = FUNHUBFx.actions
    if not actions or not FUNHUB_ALIVE() then return end
    actions.lastBackgroundPaused = FUNHUBFx.backgroundPaused()
    if actions.autoGrabSync then pcall(actions.autoGrabSync) end
    if actions.autoPotionSync then pcall(actions.autoPotionSync) end
end
function FUNHUBFx.getSetting(key, fallback)
    local value = HubConfig.funhub[key]
    if value == nil then return fallback end
    return value
end
local selectedSlot = HubConfig.selectedSlot or 1
local targetPlot = nil

local STEAL_SPEED_MIN, STEAL_SPEED_MAX = 15, 25

local function stealSpeed()
    return math.clamp(tonumber(currentSpeed) or 25, STEAL_SPEED_MIN, STEAL_SPEED_MAX)
end

-- Carry-state aliases from the supplied DatShawn source.
local function isStealBoostLive()
    for _, object in ipairs({ player, player.Character }) do
        for _, name in ipairs({ "Stealing", "steal", "stolen", "isStealing", "IsSteal", "issteal", "Steal" }) do
            local value = object:GetAttribute(name)
            if value ~= nil and value ~= false and value ~= 0 and value ~= "" then return true end
        end
    end
    return false
end

local progressFill, percentLabel = nil, nil


local findMyBase
do
    local cached, checkedAt = nil, 0
    local function isMine(base)
        local sign = base and base.Parent and base:FindFirstChild("PlotSign")
        local yourBase = sign and sign:FindFirstChild("YourBase")
        return yourBase ~= nil and yourBase.Enabled
    end
    findMyBase = function()
        local now = os.clock()
        if cached and now - checkedAt < 2 and cached.Parent then return cached end
        if cached and isMine(cached) then checkedAt = now return cached end
        cached = nil
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, base in ipairs(plots:GetChildren()) do
            if isMine(base) then cached, checkedAt = base, now return base end
        end
        for _, base in ipairs(plots:GetChildren()) do
            if base:IsA("Model") then
                for _, d in ipairs(base:GetDescendants()) do
                    if d:IsA("TextLabel") and (string.find(d.Text, player.Name, 1, true) or string.find(d.Text, player.DisplayName, 1, true)) then
                        cached, checkedAt = base, now
                        return base
                    end
                end
            end
        end
        return nil
    end
end

local function isEnemyPlot(plot)
    if not plot or not plot:IsA("Model") then return false end
    local sign = plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase")
    if yourBase and yourBase.Enabled then return false end
    local sg = sign and sign:FindFirstChild("SurfaceGui")
    local frame = sg and sg:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return false end
    local owner = label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    return owner ~= player.Name and owner ~= player.DisplayName
end

pcall(function()
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Highlight") and d.Name == "FUNHUB_SemiTP_Podium_Highlight" then
            d:Destroy()
        end
    end
end)

local slotHasTarget = true
local podiumInfoText = ""

local function readPodiumInfo(podium)
    local sp = podium and podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")
    local debris = Workspace:FindFirstChild("Debris")
    if not sp or not debris then return "" end
    local base = sp.Position
    local best, bestD = nil, 7
    for _, o in ipairs(debris:GetChildren()) do
        if o.Name == "FastOverheadTemplate" and o:IsA("BasePart") then
            local p = o.Position
            local d = Vector3.new(p.X - base.X, 0, p.Z - base.Z).Magnitude
            if d < bestD and p.Y > base.Y - 2 and p.Y < base.Y + 25 then best, bestD = o, d end
        end
    end
    local bb = best and best:FindFirstChild("AnimalOverhead")
    if not bb then return "empty" end
    local function txt(name)
        local l = bb:FindFirstChild(name, true)
        return (l and l:IsA("TextLabel") and l.Visible and l.Text ~= "") and l.Text or nil
    end
    local name, gen, mut = txt("DisplayName"), txt("Generation"), txt("Mutation")
    if not name then return "empty" end
    return (mut and (mut .. " ") or "") .. name .. (gen and ("  " .. gen) or "")
end

local darkBlueHighlight = Instance.new("Highlight")
darkBlueHighlight.Name = "FUNHUB_SemiTP_Podium_Highlight"
darkBlueHighlight.FillColor = T.ACCENT2
darkBlueHighlight.OutlineColor = T.FILL2
darkBlueHighlight.FillTransparency = 0.35
darkBlueHighlight.OutlineTransparency = 0

local function getTargetPodiumForSlot(slot)
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local bestPodium, bestScore = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = (not targetPlot or plot == targetPlot) and isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(tostring(slot))
        local spawn = podium and podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")
        local pa = spawn and spawn:FindFirstChild("PromptAttachment")
        local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")
        if spawn and prompt then
            local score = (hrp.Position - spawn.Position).Magnitude
            if not prompt.Enabled then score = score + 100000 end
            if score < bestScore then
                bestScore = score
                bestPodium = podium
            end
        end
    end
    return bestPodium
end

task.spawn(function()
    while task.wait(0.25) do
        if not FUNHUB_ALIVE() then darkBlueHighlight:Destroy() return end
        local targetPodium = getTargetPodiumForSlot(selectedSlot)
        slotHasTarget = targetPodium ~= nil
        podiumInfoText = targetPodium and readPodiumInfo(targetPodium) or "no enemy base has this podium"
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

local setStealStatus = function() end

local CLAIM_WATCH = 10
local KICK_INVITE = "\n\ndiscord.gg/freescripts"

local function myFilledPodiums()
    local plot = findMyBase()
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local n = 0
    for _, p in ipairs(pods:GetChildren()) do
        local info = readPodiumInfo(p)
        if info ~= "" and info ~= "empty" then n = n + 1 end
    end
    return n
end

do
    local carrying, before, stolenName, stealChar = false, nil, nil, nil
    local claimToken, lastEnd, claimed = 0, 0, false

    local function onClaim(token)
        if token ~= claimToken or claimed then return end
        claimed = true
        claimToken = claimToken + 1
        setStealStatus("DELIVERED" .. (stolenName and (": " .. stolenName) or ""), true)
        if HubConfig.kickAfterStealEnabled == true then
            local deliveredCharacter = stealChar
            task.defer(function()
                if not FUNHUB_ALIVE() or HubConfig.kickAfterStealEnabled ~= true
                    or player.Character ~= deliveredCharacter or _G.FUNHUB_SemiTP_ResetBusy then return end
                pcall(function()
                    player:Kick("E01")
                end)
            end)
        end
    end

    local net = ReplicatedStorage:FindFirstChild("Packages")
    net = net and net:FindFirstChild("Net")
    local success = net and net:FindFirstChild("RE/StealService/StealingSuccess")
    if success then
        local conn
        conn = success.OnClientEvent:Connect(function()
            if not FUNHUB_ALIVE() then conn:Disconnect() return end
            if carrying or os.clock() - lastEnd < CLAIM_WATCH then onClaim(claimToken) end
        end)
    end

    local attrConn
    attrConn = player:GetAttributeChangedSignal("Stealing"):Connect(function()
        if not FUNHUB_ALIVE() then attrConn:Disconnect() return end
        if player:GetAttribute("Stealing") then
            carrying = true
            claimed = false
            claimToken = claimToken + 1
            stealChar = player.Character
            before = myFilledPodiums()
            local idx = player:GetAttribute("StealingIndex")
            stolenName = (idx ~= nil and idx ~= "") and tostring(idx) or nil
            local hs = _G.FUNHUB_SemiTP
            local took = hs and hs.pressedAt and (tick() - hs.pressedAt)
            local tookText = (took and took < 15) and string.format("  %.1fs", took) or ""
            setStealStatus("CARRYING" .. (stolenName and (": " .. stolenName) or "") .. tookText, nil)
            return
        end
        if not carrying then return end
        carrying = false
        if claimed then return end
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hit = hrp and getNearestDeliveryHitbox()
        local atBase = hit and Vector3.new(hrp.Position.X - hit.X, 0, hrp.Position.Z - hit.Z).Magnitude <= 40
        if ch ~= stealChar or not hum or hum.Health <= 0 or _G.FUNHUB_SemiTP_ResetBusy or not atBase then
            claimToken = claimToken + 1
            setStealStatus("DROPPED" .. (stolenName and (": " .. stolenName) or ""), false)
            return
        end
        lastEnd = os.clock()
        local mine = claimToken
        task.spawn(function()
            local t0 = os.clock()
            while os.clock() - t0 < CLAIM_WATCH do
                if mine ~= claimToken or not FUNHUB_ALIVE() then return end
                local now = myFilledPodiums()
                if now and before and now > before then onClaim(mine) return end
                task.wait(0.1)
            end
            if mine == claimToken then
                claimToken = claimToken + 1
                setStealStatus("DROPPED" .. (stolenName and (": " .. stolenName) or ""), false)
            end
        end)
    end)

    local idxConn
    idxConn = player:GetAttributeChangedSignal("StealingIndex"):Connect(function()
        if not FUNHUB_ALIVE() then idxConn:Disconnect() return end
        local idx = player:GetAttribute("StealingIndex")
        if idx ~= nil and idx ~= "" then stolenName = tostring(idx) end
    end)
end

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

local FLY_GEAR_KEYS ={ "carpet", "broom", "wings", "sleigh", "waverider", "jetpack", "hoverboard", "glider" }

local function findFlyGear()
    local want, fallback = HubConfig.flyTool, nil
    for _, cont in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
        if cont then
            for _, t in ipairs(cont:GetChildren()) do
                if t:IsA("Tool") then
                    if t.Name == want then return t end
                    local nm = t.Name:lower()
                    for _, k in ipairs(FLY_GEAR_KEYS) do
                        if not fallback and nm:find(k, 1, true) then fallback = t end
                    end
                end
            end
        end
    end
    return fallback
end

-- Shared tool ownership prevents the carpet loop from unequipping the potion.
pcall(function()
    if type(FUNHUB_ENV.__DiplexPotionSpeedCleanup) == "function" then
        FUNHUB_ENV.__DiplexPotionSpeedCleanup()
    end
end)
local potionState = { busy = false, status = "Ready", active = false, links = {}, lastUse = 0,
    timing = { equip = 0.1, settle = 0.3, cooldown = 2, observe = 5, effect = 20 },
    growthMath = { confirm = 1.3, retain = 1.1, giantScale = 2.5 } }
local flyGearToken = 0

-- Iftar carpet equip only: keep Flying Carpet equipped without activating it.
-- Shared potion ownership and the current character still belong to main Semi TP.
local function equipInstantCarpet(character)
    if not character or player.Character ~= character or not FUNHUB_ALIVE()
        or _G.FUNHUB_SemiTP_ResetBusy or potionState.busy then return nil end
    local tool = character:FindFirstChild("Flying Carpet")
    if tool and tool:IsA("Tool") then return tool end
    local backpack = player:FindFirstChild("Backpack")
    tool = backpack and backpack:FindFirstChild("Flying Carpet")
    local hum = character:FindFirstChildOfClass("Humanoid")
    if tool and tool:IsA("Tool") and hum and hum.Health > 0 then
        pcall(function() hum:EquipTool(tool) end)
        return tool
    end
    return nil
end

local function holdFlyGearUntilCarrying(instant)
    flyGearToken = flyGearToken + 1
    local mine, character = flyGearToken, player.Character
    local tool
    if not instant then tool = findFlyGear() end
    local function valid()
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        return mine == flyGearToken and FUNHUB_ALIVE() and player.Character == character
            and not _G.FUNHUB_SemiTP_ResetBusy and not player:GetAttribute("Stealing")
            and hum and hum.Health > 0, hum
    end
    local function equip()
        local ok, hum = valid()
        if not ok or potionState.busy then return false end
        if instant then return equipInstantCarpet(character) ~= nil end
        if not tool or not tool.Parent then tool = findFlyGear() end
        if tool and tool.Parent ~= character then pcall(function() hum:EquipTool(tool) end) end
        return tool ~= nil and tool.Parent == character
    end
    -- Early equip is optional; the normal Semi TP sequence must always continue.
    if instant then equip() end
    task.spawn(function()
        local t0 = os.clock()
        while valid() and os.clock() - t0 < 12 do
            equip()
            task.wait(0.3)
        end
    end)
    return true
end

local function stopFlyGear()
    flyGearToken = flyGearToken + 1
end

local walkTo = function(hrp, targetCords, desiredSpeed, precisionThreshold, stopWhen, instantCarpet)
    if not hrp or not hrp.Parent or not targetCords then return end
    desiredSpeed = desiredSpeed or 180
    local running = true
    local connection
    local threshold = precisionThreshold or 3
    local character = hrp.Parent
    local reached = false

    local _ctrls
    pcall(function() _ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls() end)
    if _ctrls then pcall(function() _ctrls:Disable() end) end
    if instantCarpet then equipInstantCarpet(character) end

    connection = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent or player.Character ~= character or not FUNHUB_ALIVE() or not running
            or (instantCarpet and _G.FUNHUB_SemiTP_ResetBusy) then
            running = false
            if connection then connection:Disconnect() end
            return
        end
        local currentPos  = hrp.Position
        local flatCurrent = Vector3.new(currentPos.X, targetCords.Y, currentPos.Z)
        local direction   = targetCords - flatCurrent
        local distance    = direction.Magnitude
        if distance <= threshold or (stopWhen and stopWhen()) then
            reached = true
            running = false
            connection:Disconnect()
            if instantCarpet then hrp.AssemblyLinearVelocity = Vector3.zero else hrp.Velocity = Vector3.zero end
            return
        end
        if instantCarpet then equipInstantCarpet(character) end
        local vel = direction.Unit * desiredSpeed
        if instantCarpet then
            -- Iftar VelocityMoveToCords: horizontal carpet movement, preserve vertical velocity.
            hrp.AssemblyLinearVelocity = Vector3.new(vel.X, hrp.AssemblyLinearVelocity.Y, vel.Z)
        else
            hrp.Velocity = Vector3.new(vel.X, hrp.Velocity.Y, vel.Z)
        end
    end)

    local startT = tick()
    while running do
        if tick() - startT > 6 then break end
        task.wait()
    end

    running = false
    if connection then connection:Disconnect() end
    if hrp.Parent then hrp.AssemblyLinearVelocity = Vector3.zero end
    if _ctrls and not _G.FUNHUB_SemiTP_InputLock then pcall(function() _ctrls:Enable() end) end
    return reached
end


local canDirectTp = function(HRP, targetPos)
    if not HRP or not targetPos then return false end
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

-- Adapted from Diplex_Giant_Potion_Speed and Cyber_PVP_Updated:
-- equip, settle for 0.1s, activate, then observe the potion attribute/growth.
-- The movement controller owns potion speed through LinearVelocity.
function potionState.restoreSpeed()
    FUNHUBFx.potionSpeedActive = false
    local motion = FUNHUBFx.motion
    if motion and motion.mode == "Giant" then motion.suspend() end
end
function potionState.updateSpeed()
    if not FUNHUBFx.potionSpeed or not potionState.active or potionState.stopped then potionState.restoreSpeed() end
end
function potionState.stop()
    potionState.stopped = true
    potionState.restoreSpeed()
    for _, link in pairs(potionState.links) do link:Disconnect() end
    table.clear(potionState.links)
    potionState.active = false
    if FUNHUB_ENV.__DiplexPotionSpeedCleanup == potionState.stop then
        FUNHUB_ENV.__DiplexPotionSpeedCleanup = nil
    end
end
FUNHUB_ENV.__DiplexPotionSpeedCleanup = potionState.stop

function potionState.scale(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    local height = hum:FindFirstChild("BodyHeightScale")
    return { model = char:GetScale(), root = root and root.Size.Y or 0,
        height = height and height:IsA("NumberValue") and height.Value or 0 }
end
function potionState.growth(now, base)
    local ratio = 1
    for key, value in pairs(now or {}) do
        if base and base[key] and base[key] > 0 then ratio = math.max(ratio, value / base[key]) end
    end
    return ratio
end
function potionState.hasAttribute(char)
    local function active(value)
        if type(value) == "boolean" then return value end
        if type(value) == "number" then
            if value == 1 then return true end
            return value > Workspace:GetServerTimeNow()
        end
        return type(value) == "string" and (value:lower() == "true" or value:lower() == "active")
    end
    for _, name in ipairs({ "Giant", "IsGiant", "GiantPotion", "GiantPotioned", "GiantPotionActive", "UsingGiantPotion" }) do
        if active(player:GetAttribute(name)) or active(char and char:GetAttribute(name)) then return true end
    end
    return false
end
function potionState.isGiant(char)
    if potionState.hasAttribute(char) then return true end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    -- Same already-grown check used by the supplied HEX Semi TP.
    for _, name in ipairs({"BodyHeightScale", "BodyDepthScale", "BodyWidthScale", "HeadScale"}) do
        local value = hum and hum:FindFirstChild(name)
        if value and value:IsA("NumberValue") and value.Value >= potionState.growthMath.giantScale then return true end
    end
    return char == potionState.char and potionState.untilTime ~= nil and os.clock() < potionState.untilTime
        and potionState.growth(potionState.scale(char), potionState.baseline) >= potionState.growthMath.retain
end
function potionState.bindCharacter(char, hum)
    if char == potionState.char and hum == potionState.hum then return end
    potionState.restoreSpeed()
    potionState.char, potionState.hum, potionState.idleScale = char, hum, nil
    potionState.attempt, potionState.baseline, potionState.untilTime = nil, nil, nil
    potionState.active, potionState.status = false, "Ready"
end
function potionState.observe(char)
    potionState.bindCharacter(char, char and char:FindFirstChildOfClass("Humanoid"))
    local attempt = potionState.attempt
    if attempt and (attempt.char ~= char or os.clock() >= attempt.expires) then potionState.attempt = nil end
    if potionState.isGiant(char) or potionState.attempt then return end
    local baseline = potionState.idleScale or potionState.scale(char)
    if baseline then
        potionState.attempt = { normal = baseline, expires = os.clock() + potionState.timing.observe, char = char }
        potionState.status = "Potion used; waiting for effect"
    end
end
function potionState.confirmEffect(char)
    if not char or char ~= player.Character then return false end
    local now = os.clock()
    local active = potionState.isGiant(char)
    local attempt = potionState.attempt
    if attempt and attempt.char == char then
        -- Same ratio/scale calculation used by the Semi TP potion observer.
        if active or (now <= attempt.expires
            and potionState.growth(potionState.scale(char), attempt.normal) >= potionState.growthMath.confirm) then
            potionState.baseline, potionState.untilTime = attempt.normal, now + potionState.timing.effect
            potionState.attempt = nil
            active = true
        elseif now >= attempt.expires then
            potionState.attempt = nil
            potionState.status = "No potion effect observed; check potion cooldown"
        end
    end
    local was = potionState.active
    potionState.active = active == true
    if active then potionState.status = "Giant Potion active"
    elseif was then potionState.status = "Potion effect ended" end
    return active == true
end
function potionState.find(name, char)
    local bp = player:FindFirstChild("Backpack")
    local containers = {}
    if char then containers[#containers + 1] = char end
    if bp then containers[#containers + 1] = bp end
    local names = name == "Giant Potion" and { "Giant Potion", "GiantPotion", "Grow Potion", "Super Grow", "Giant" } or { name }
    for _, container in ipairs(containers) do
        for _, alias in ipairs(names) do
            local tool = container:FindFirstChild(alias)
            if tool and tool:IsA("Tool") then return tool end
        end
    end
    if name == "Giant Potion" then
        for _, container in ipairs(containers) do
            for _, item in ipairs(container:GetDescendants()) do
                if item:IsA("Tool") then
                    local lower = item.Name:lower()
                    if table.find(names, item.Name) or (lower:find("giant", 1, true) and lower:find("potion", 1, true)) then return item end
                end
            end
        end
    end
end
local function FUNHUBAutoPotion(options)
    options = type(options) == "table" and options or {}
    local autoSteal = options.autoSteal == true
    local function enabled()
        if autoSteal then
            return HubConfig.funhub.autoPotionOnSteal == true and options.onGrab == true
                and not FUNHUBFx.backgroundPaused() and not isStealBoostLive()
        end
        return PotionEnabled == true
    end
    local function requested()
        return enabled() and not potionState.stopped and FUNHUB_ALIVE()
            and (not options.valid or options.valid() == true)
    end
    if not requested() then return false end
    -- All potion paths share one owner and DatShawn's two-second cooldown.
    if autoSteal and potionState.busy then return false end
    local waitUntil = os.clock() + potionState.timing.cooldown
    while potionState.busy and requested() and os.clock() < waitUntil do task.wait(0.03) end
    if potionState.busy or not requested() then return false end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local bp = player:FindFirstChild("Backpack")
    if not hum or hum.Health <= 0 or not bp then potionState.status = "No living character/backpack" return false end
    if os.clock() - potionState.lastUse < potionState.timing.cooldown then return potionState.confirmEffect(char) end
    potionState.busy = true
    local previous = char:FindFirstChildOfClass("Tool")
    local used, giantUsed, lastTool = false, false, nil
    local previousUse, reservedAt = potionState.lastUse, nil
    local function valid()
        return requested() and player.Character == char and char.Parent ~= nil and hum.Health > 0
            and not _G.FUNHUB_SemiTP_ResetBusy
    end
    local function settingEnabled(setting)
        if autoSteal and setting == "giantPotionEnabled" then return true end
        return HubConfig[setting] ~= false
    end
    local ok, err = pcall(function()
        local function activate(name, setting)
            if not settingEnabled(setting) or not valid() then return false end
            if name == "Giant Potion" and potionState.isGiant(char) then
                potionState.active, potionState.status = true, "Giant Potion already active"
                return true
            end
            local tool = potionState.find(name, char)
            if name == "Giant Potion" and not options.onGrab then
                local untilTime = os.clock() + 1
                while not tool and valid() and os.clock() < untilTime do
                    task.wait(0.05)
                    tool = potionState.find(name, char)
                end
            end
            if not tool then
                if name == "Giant Potion" then potionState.status = "Giant Potion missing from backpack" end
                return false
            end
            potionState.status = "Using " .. name
            if not valid() or not settingEnabled(setting) or not tool.Parent then return false end
            -- Attached source: reserve cooldown before equip, settle 0.1s, Activate.
            -- Normal grabs use the source's pre-pickup window so the tool is still usable.
            reservedAt = os.clock()
            potionState.lastUse = reservedAt
            lastTool = tool
            if tool.Parent ~= char then
                hum:EquipTool(tool)
                task.wait(potionState.timing.equip)
            end
            if not valid() or not settingEnabled(setting) then return false end
            if tool.Parent == char and tool.Enabled ~= false then
                if name == "Giant Potion" then potionState.observe(char) end
                tool:Activate()
                used = true
                if autoSteal and name == "Giant Potion" then
                    -- Source keeps the potion equipped so its own use animation can finish.
                    return true
                end
                task.wait(name == "Giant Potion" and potionState.timing.settle or 0.03)
                if name == "Giant Potion" and player.Character == char then potionState.confirmEffect(char) end
                return true
            end
            potionState.status = name .. " not ready; retry after cooldown"
            return false
        end
        if not autoSteal then activate("Grief Shield", "griefShieldEnabled") end
        giantUsed = activate("Giant Potion", "giantPotionEnabled")
    end)
    -- Keep successful normal-use potions equipped as in the supplied source.
    -- Cancelled equips restore the prior tool, except during reset.
    if autoSteal and not used and reservedAt and potionState.lastUse == reservedAt then
        potionState.lastUse = previousUse -- a cancelled equip did not consume a potion
    end
    if not (autoSteal and giantUsed) and not _G.FUNHUB_SemiTP_ResetBusy
        and not (autoSteal and FUNHUBFx.backgroundPaused())
        and player.Character == char and hum.Health > 0 then
        pcall(function()
            local equipped = char:FindFirstChildOfClass("Tool")
            if not equipped or equipped == lastTool then
                if lastTool and lastTool ~= previous and lastTool.Parent == char and bp.Parent then lastTool.Parent = bp end
                if previous and previous.Parent == bp and not (autoSteal and isStealBoostLive()) then
                    hum:EquipTool(previous)
                end
            end
        end)
    end
    potionState.busy = false
    if not ok then
        potionState.status = "Potion activation failed"
        warn("[FUNHUB Potion] " .. tostring(err))
    end
    return ok and (giantUsed or (not autoSteal and HubConfig.giantPotionEnabled == false and used))
end

task.spawn(function()
    while FUNHUB_ALIVE() and not potionState.stopped do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        potionState.bindCharacter(char, hum)
        for tool, link in pairs(potionState.links) do
            if not tool:IsDescendantOf(player) and not (char and tool:IsDescendantOf(char)) then
                link:Disconnect() potionState.links[tool] = nil
            end
        end
        if hum and hum.Health > 0 then
            local tool = potionState.find("Giant Potion", char)
            if tool and not potionState.links[tool] then
                potionState.links[tool] = tool.Activated:Connect(function()
                    if FUNHUB_ALIVE() and tool.Parent == player.Character then potionState.observe(player.Character) end
                end)
            end
            potionState.confirmEffect(char)
            if not potionState.active and not potionState.attempt then potionState.idleScale = potionState.scale(char) end
        else
            potionState.active, potionState.attempt = false, nil
        end
        potionState.updateSpeed(char, hum)
        task.wait(0.1)
    end
    potionState.stop()
    potionState.busy = false
end)

local FUNHUBStealCache = setmetatable({}, { __mode = "k" })
local FUNHUBHold = { lastHold = 0 }
local FUNHUBStealCallbacks = function(prompt, sourceAutograb)
    local getter = getconnections or FUNHUB_ENV.getconnections
    if type(getter) ~= "function" or not prompt or not prompt.Parent then return nil end
    local cached = FUNHUBStealCache[prompt]
    if cached and cached.sourceAutograb == sourceAutograb and tick() - cached.cachedAt < 1 then return cached end
    local data = { hold = {}, trigger = {}, release = {}, cachedAt = tick(), sourceAutograb = sourceAutograb }
    local function collect(signal, out, filterHold)
        local ok, connections = pcall(getter, signal)
        if not ok or type(connections) ~= "table" then return end
        for _, c in ipairs(connections) do
            local readable, fn = pcall(function() return c.Function end)
            if readable and type(fn) == "function" then
                local src = ""
                if filterHold and not sourceAutograb and debug and type(debug.info) == "function" then
                    local known, value = pcall(debug.info, fn, "s")
                    if known then src = tostring(value or "") end
                end
                if not filterHold or not (src:find("PlotClient", 1, true) and not src:find("AnimalPrompt", 1, true)) then
                    out[#out + 1] = filterHold and function(...)
                        FUNHUBHold.lastHold = tick()
                        return fn(...)
                    end or fn
                end
            end
        end
    end
    collect(prompt.PromptButtonHoldBegan, data.hold, true)
    collect(prompt.Triggered, data.trigger, false)
    collect(prompt.PromptButtonHoldEnded, data.release, false)
    -- Do not permanently cache a half-loaded prompt with no trigger callback.
    if #data.trigger == 0 then FUNHUBStealCache[prompt] = nil return nil end
    FUNHUBStealCache[prompt] = data
    return data
end

function FUNHUBHold.isStealAction(prompt)
    return prompt and prompt.Parent and prompt:IsA("ProximityPrompt")
        and tostring(prompt.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") == "steal"
end
function FUNHUBHold.valid(ctx)
    if not ctx or ctx.cancelled or not FUNHUB_ALIVE() or not ctx.prompt.Parent or not ctx.prompt.Enabled then return false end
    if not FUNHUBHold.isStealAction(ctx.prompt) then return false end
    if not ctx.semiSource and ctx.source ~= "Semi TP" and FUNHUBFx.backgroundPaused() then return false end
    local ch = player.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    return ch == ctx.character and hum and hum.Health > 0 and not _G.FUNHUB_SemiTP_ResetBusy
end
function FUNHUBHold.promptPosition(prompt)
    local parent = prompt and prompt.Parent
    return parent and (parent:IsA("Attachment") and parent.WorldPosition or (parent:IsA("BasePart") and parent.Position))
end
function FUNHUBHold.inRange(ctx)
    local ch = player.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local position = FUNHUBHold.promptPosition(ctx.prompt)
    return hrp and position and (hrp.Position - position).Magnitude <= ctx.range
end
function FUNHUBHold.dispatch(ctx, callbacks, release)
    for _, fn in ipairs(callbacks or {}) do
        task.spawn(function()
            if not release and not FUNHUBHold.valid(ctx) then return end
            local ok, err = pcall(fn)
            if not ok and not release then
                ctx.failed = tostring(err)
                FUNHUBStealCache[ctx.prompt] = nil
            end
        end)
    end
end
function FUNHUBHold.cancel(ctx)
    if not ctx or ctx.cancelled then return end
    if FUNHUBHold.confirm then FUNHUBHold.confirm(ctx) end
    ctx.cancelled = true
    if FUNHUBHold.onAutoPotionCancel then FUNHUBHold.onAutoPotionCancel(ctx) end
    if ctx.source and FUNHUBHold.progress.contexts[ctx.source] == ctx then
        FUNHUBHold.progress.contexts[ctx.source] = nil
    end
    if ctx.native then
        if ctx.nativeHolding then pcall(function() ctx.prompt:InputHoldEnd() end) end
    else
        FUNHUBHold.dispatch(ctx, ctx.cb.release, true)
    end
    if ctx.promptSettings then
        local saved = ctx.promptSettings
        pcall(function()
            if ctx.prompt.MaxActivationDistance == 9e9 then ctx.prompt.MaxActivationDistance = saved.distance end
            if ctx.prompt.RequiresLineOfSight == false then ctx.prompt.RequiresLineOfSight = saved.lineOfSight end
        end)
        ctx.promptSettings = nil
    end
    ctx.nativeHolding = false
end
function FUNHUBHold.restart(ctx)
    if not FUNHUBHold.valid(ctx) then return false end
    if ctx.native then
        if not FUNHUBHold.inRange(ctx) then ctx.holdBeganAt = nil return false end
        if ctx.nativeHolding then pcall(function() ctx.prompt:InputHoldEnd() end) end
        ctx.nativeHolding = pcall(function() ctx.prompt:InputHoldBegin() end)
    else
        if ctx.holdBeganAt then FUNHUBHold.dispatch(ctx, ctx.cb.release, true) end
        FUNHUBHold.dispatch(ctx, ctx.cb.hold)
    end
    ctx.holdBeganAt, ctx.holdDone = tick(), true
    FUNHUBHold.lastHold = ctx.holdBeganAt
    if FUNHUBHold.onAutoPotionHold then FUNHUBHold.onAutoPotionHold(ctx) end
    return true
end
function FUNHUBHold.startStealHold(prompt, sourceAutograb)
    if not FUNHUBHold.isStealAction(prompt) or not prompt.Enabled then return nil end
    local cb = FUNHUBStealCallbacks(prompt, sourceAutograb)
    local now = tick()
    local ctx = { prompt = prompt, cb = cb or { hold = {}, trigger = {}, release = {} },
        native = cb == nil, character = player.Character, range = math.min(tonumber(prompt.MaxActivationDistance) or 10, 30),
        ragdollFireTime = now, startedAt = now }
    if sourceAutograb then
        ctx.sourceAutograb, ctx.source = true, "Auto Grab"
        ctx.range = cb and 10 or math.min(ctx.range, 10)
        if cb then
            -- Supplied Autograb: 1.3s hold, then a full 2s window at 100%.
            ctx.holdDuration, ctx.progressDuration = 1.3, 1.3
            ctx.windowEnd = os.clock() + 3.3
            ctx.promptSettings = { distance = prompt.MaxActivationDistance, lineOfSight = prompt.RequiresLineOfSight }
            pcall(function() prompt.MaxActivationDistance = 9e9 prompt.RequiresLineOfSight = false end)
        end
    end
    FUNHUBHold.restart(ctx)
    return ctx
end
function FUNHUBHold.doHoldAndWait(ctx)
    if not ctx or ctx.holdDone then return end
    if FUNHUBHold.restart(ctx) then
        task.wait(math.max(0, tonumber(ctx.prompt.HoldDuration) or 1.3))
    end
end
function FUNHUBHold.waitForStealTime(ctx, sec)
    if not ctx then return false end
    local untilTime = (ctx.ragdollFireTime or tick()) + sec
    while tick() < untilTime do
        if not FUNHUBHold.valid(ctx) then return false end
        RunService.Heartbeat:Wait()
    end
    return true
end
function FUNHUBHold.trigger(ctx)
    if not FUNHUBHold.valid(ctx) or ctx.failed or ctx.firing then return false end
    local need = ctx.holdDuration or (math.max(0, tonumber(ctx.prompt.HoldDuration) or 1.3) + 0.05)
    if not ctx.holdBeganAt or tick() - ctx.holdBeganAt < need then return false end
    if FUNHUBHold.beforeAutoPotionTrigger and not FUNHUBHold.beforeAutoPotionTrigger(ctx) then return false end
    if ctx.sourceAutograb and (not FUNHUBHold.valid(ctx) or not FUNHUBHold.inRange(ctx) or isStealBoostLive()) then return false end
    if ctx.native and (ctx.lastTrigger or not FUNHUBHold.inRange(ctx)) then return false end
    ctx.lastTrigger = tick()
    if FUNHUBHold.noteSemiAttempt then FUNHUBHold.noteSemiAttempt(ctx) end
    if ctx.native then
        ctx.firing = true
        task.spawn(function()
            if FUNHUBHold.valid(ctx) and FUNHUBHold.inRange(ctx) then
                if ctx.nativeHolding then
                    pcall(function() ctx.prompt:InputHoldEnd() end)
                    ctx.nativeHolding = false
                elseif type(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, ctx.prompt, math.max(0, tonumber(ctx.prompt.HoldDuration) or 1.3))
                end
            end
            ctx.firing = false
        end)
    else
        FUNHUBHold.dispatch(ctx, ctx.cb.trigger)
    end
    return true -- attempted; the Stealing state confirms acceptance separately
end
function FUNHUBHold.finishStealHold(ctx)
    if not FUNHUBHold.valid(ctx) then return false end
    local need = math.max(0, tonumber(ctx.prompt.HoldDuration) or 1.3) + 0.05
    local age = ctx.holdBeganAt and tick() - ctx.holdBeganAt or math.huge
    if age > math.max(2.4, need + 0.5) then
        if not FUNHUBHold.restart(ctx) then return false end
    end
    while tick() - ctx.holdBeganAt < need do
        if not FUNHUBHold.valid(ctx) then return false end
        RunService.Heartbeat:Wait()
    end
    return FUNHUBHold.trigger(ctx)
end

local ROW_ROUTES = {
    { z = -14.5, inside = Vector3.new(12.89, 4.88, -17.06), green = Vector3.new(30.63, 2.98, -32.97) },
    { z = -7.0, inside = Vector3.new(11.95, 5.13, -9.17), green = Vector3.new(22.58, 2.98, -35.87) },
    { z = 0.5, inside = Vector3.new(14.39, 4.88, -2.44), green = Vector3.new(21.60, 2.98, -28.10) },
    { z = 8.0, inside = Vector3.new(14.62, 4.93, 5.65), green = Vector3.new(21.71, 5.08, -20.68), mid = Vector3.new(19.54, 2.98, -29.61) },
    { z = 15.5, inside = Vector3.new(11.60, 4.72, 13.31), green = Vector3.new(20.40, 4.92, -11.40), mid = Vector3.new(19.54, 2.98, -29.61) },
}
local CORRIDOR_Y, CORRIDOR_Z, CORRIDOR_REACH = 3.1, -35.9, 107
local MAX_TRIGGER_DIST = 30

local function clampToPodium(from, to, podiumPos)
    local function flatDist(p)
        return Vector3.new(p.X - podiumPos.X, 0, p.Z - podiumPos.Z).Magnitude
    end
    if flatDist(to) <= MAX_TRIGGER_DIST then return to end
    local best = from
    for i = 1, 40 do
        local p = from:Lerp(to, i / 40)
        if flatDist(p) > MAX_TRIGGER_DIST then break end
        best = p
    end
    return best
end

local GROUND_MAX_Y = 10
local MAX_PODIUM = 28
local function rowFor(localZ)
    local best, bestD = ROW_ROUTES[1], math.huge
    for _, r in ipairs(ROW_ROUTES) do
        local d = math.abs(r.z - localZ)
        if d < bestD then best, bestD = r, d end
    end
    return best
end

local function podiumParts(podium)
    local base = podium and podium:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    for _, prompt in ipairs(spawn and spawn:GetDescendants() or {}) do
        if prompt:IsA("ProximityPrompt") and prompt.Enabled
            and tostring(prompt.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") == "steal" then
            return spawn, prompt
        end
    end
    return spawn, nil
end

local function findPodiumTarget(podiumNo, hrp)
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local best, bestScore = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        local root = plot:FindFirstChild("MainRoot")
        local podiums = plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(tostring(podiumNo))
        if root and podium and (not targetPlot or plot == targetPlot) and isEnemyPlot(plot) then
            local spawn, prompt = podiumParts(podium)
            if spawn and prompt then
                local score = (hrp.Position - spawn.Position).Magnitude
                if not prompt.Enabled then score = score + 100000 end
                if score < bestScore then
                    bestScore = score
                    best = { plot = plot, podium = podium, rootCF = root.CFrame, spawn = spawn, prompt = prompt }
                end
            end
        end
    end
    return best
end

local FUNHUBUI = { maxPath = 90, state = { locked = false, lockText = "", inRange = true } }

function FUNHUBUI.fit(l, max, pad)
    l.TextScaled = false
    l.TextWrapped = false
    l.TextTruncate = Enum.TextTruncate.None
    local busy = false
    local function refit()
        if busy then return end
        busy = true
        l.TextSize = max
        local w, b = l.AbsoluteSize.X - (pad or 0), l.TextBounds.X
        if w > 0 and b > w then l.TextSize = math.max(6, math.floor(max * w / b)) end
        busy = false
    end
    refit()
    l:GetPropertyChangedSignal("Text"):Connect(refit)
    l:GetPropertyChangedSignal("AbsoluteSize"):Connect(refit)
end

function FUNHUBUI.lockInfo(plot)
    local pur = plot and plot:FindFirstChild("Purchases")
    local pb = pur and pur:FindFirstChild("PlotBlock")
    local main = pb and pb:FindFirstChild("Main")
    local bb = main and main:FindFirstChild("BillboardGui")
    local lockedLbl = bb and bb:FindFirstChild("Locked")
    if lockedLbl and lockedLbl.Visible then
        local rt = bb:FindFirstChild("RemainingTime")
        return true, rt and rt.Text or ""
    end
    return false, ""
end

function FUNHUBUI.flightPath(pod, hrp)
    local cf = pod.rootCF
    local podLocal = cf:PointToObjectSpace(pod.spawn.Position)
    local s = podLocal.X >= 0 and 1 or -1
    local row = rowFor(podLocal.Z)
    local here = cf:PointToObjectSpace(hrp.Position)
    local pts = {
        cf * Vector3.new(math.clamp(here.X, -CORRIDOR_REACH, CORRIDOR_REACH), CORRIDOR_Y, CORRIDOR_Z),
        cf * Vector3.new(0, CORRIDOR_Y, CORRIDOR_Z),
    }
    if podLocal.Y <= GROUND_MAX_Y then
        pts[#pts + 1] = cf * Vector3.new(row.inside.X * s, row.inside.Y, row.inside.Z)
    end
    local startIndex = 1
    for i = #pts, 1, -1 do
        if canDirectTp(hrp, pts[i]) then startIndex = i; break end
    end
    local len, from = 0, hrp.Position
    for i = startIndex, #pts do
        len = len + Vector3.new(pts[i].X - from.X, 0, pts[i].Z - from.Z).Magnitude
        from = pts[i]
    end
    return len
end

function FUNHUBUI.check(ignoreLock)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "NO CHARACTER" end
    local pod = findPodiumTarget(selectedSlot, hrp)
    if not pod then return false, "NO TARGET PODIUM" end
    local locked, t = FUNHUBUI.lockInfo(pod.plot)
    local upper = pod.rootCF:PointToObjectSpace(pod.spawn.Position).Y > GROUND_MAX_Y
    if locked and not upper and not ignoreLock and not (FUNHUBUI.friendsAllowed and FUNHUBUI.friendsAllowed(pod.plot)) then
        return false, "BASE LOCKED " .. t
    end
    if upper and FUNHUBUI.clonerState then
        local ready, why = FUNHUBUI.clonerState()
        if not ready then return false, why end
    end
    return true
end

FUNHUBUI.flash = function(msg) setStealStatus(msg, false) end

function FUNHUBUI.inputLock(on)
    local CAS = game:GetService("ContextActionService")
    local ACTION = "FUNHUB_SemiTP_InputLock"
    _G.FUNHUB_SemiTP_InputLock = on and true or nil
    local ctrls
    pcall(function() ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls() end)
    if on then
        if ctrls then pcall(function() ctrls:Disable() end) end
        local K = Enum.KeyCode
        pcall(function()
            CAS:BindActionAtPriority(ACTION, function(_, _, input)
                if input.KeyCode == currentStealKey or input.UserInputType == currentStealKey then return Enum.ContextActionResult.Pass end
                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value + 2000,
                K.W, K.A, K.S, K.D, K.Up, K.Down, K.Left, K.Right, K.Space, K.LeftShift, K.Backspace, K.Q,
                K.One, K.Two, K.Three, K.Four, K.Five, K.Six, K.Seven, K.Eight, K.Nine, K.Zero,
                K.ButtonA, K.ButtonB, K.ButtonX, K.ButtonY, K.ButtonL1, K.ButtonR1, K.ButtonR2, K.Thumbstick1,
                Enum.UserInputType.MouseButton1)
        end)
    else
        pcall(function() CAS:UnbindAction(ACTION) end)
        if ctrls then pcall(function() ctrls:Enable() end) end
    end
end

do
    pcall(function()
        for _, d in ipairs(Workspace:GetChildren()) do
            if d.Name == "FUNHUB_SemiTP_StandSpot" then d:Destroy() end
        end
    end)

    task.spawn(function()
        while task.wait(0.2) do
            if not FUNHUB_ALIVE() then return end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local pod = hrp and not _G.FUNHUB_SemiTP_Busy and not player:GetAttribute("Stealing") and findPodiumTarget(selectedSlot, hrp)
            if pod then
                local ok, len = pcall(FUNHUBUI.flightPath, pod, hrp)
                local locked, lockText = FUNHUBUI.lockInfo(pod.plot)
                FUNHUBUI.state.locked = locked and pod.rootCF:PointToObjectSpace(pod.spawn.Position).Y <= GROUND_MAX_Y
                FUNHUBUI.state.lockText = lockText
                FUNHUBUI.state.friends = FUNHUBUI.friendsAllowed ~= nil and FUNHUBUI.friendsAllowed(pod.plot)
                FUNHUBUI.state.inRange = ok and len <= FUNHUBUI.maxPath
            else
                FUNHUBUI.state.friends = false
                FUNHUBUI.state.locked = false
                FUNHUBUI.state.inRange = true
            end
        end
    end)
end

local FUNHUB = { debounce = false }

function FUNHUB.semiMode()
    local settings = HubConfig.funhub
    return settings.semiMode == "Grapple" and "Grapple" or "Normal"
end
function FUNHUB.semiSpeed()
    local speed = tonumber(HubConfig.funhub.semiSpeed)
    return (speed == 240 or speed == 210 or speed == 180) and speed or 180
end

function FUNHUB.beginSemiPause()
    local token = { character = player.Character, instantCarpet = HubConfig.funhub.instantCarpet == true,
        speed = FUNHUB.semiSpeed() }
    FUNHUBFx.semiPauses[token] = true
    if FUNHUBHold.clearAuto then pcall(FUNHUBHold.clearAuto) end
    local actions = FUNHUBFx.actions
    if actions and actions.autoPotion then actions.autoPotion.clear() end
    FUNHUBFx.syncBackground()
    return token
end
function FUNHUB.endSemiPause(token)
    if not token or not FUNHUBFx.semiPauses[token] then return end
    FUNHUBFx.semiPauses[token] = nil
    FUNHUBFx.syncBackground() -- use the latest settings, including changes made while paused
end
function FUNHUB.releaseSemiPause(token)
    if not token or not FUNHUBFx.semiPauses[token] then return end
    local attempt = FUNHUBHold.pendingSemiPickup
    local deadline = math.max(os.clock() + 0.6, attempt and attempt.expires or 0)
    task.spawn(function()
        while FUNHUBFx.semiPauses[token] and FUNHUB_ALIVE() and player.Character == token.character
            and not _G.FUNHUB_SemiTP_ResetBusy and not isStealBoostLive() and os.clock() < deadline do
            task.wait(0.05)
        end
        FUNHUB.endSemiPause(token)
    end)
end

-- Shared display state; each controller retains its own enable flag and hold.
FUNHUBHold.progress = { contexts = {} }
-- Remember the exact attempted Semi target before its callbacks run. Server confirmation
-- can arrive after the teleport clears Busy, so Busy is never the confirmation gate.
function FUNHUBHold.noteSemiAttempt(ctx)
    if not ctx or (not ctx.semiSource and ctx.source ~= "Semi TP") then return end
    local plot = ctx.prompt
    local plots = Workspace:FindFirstChild("Plots")
    while plot and plot.Parent ~= plots do plot = plot.Parent end
    if not plot or not plots then return end
    local attempt = ctx.semiPickup
    if not attempt then
        attempt = { character = ctx.character, plot = plot, ctx = ctx }
        local actions = FUNHUBFx.actions
        attempt.target = actions and actions.semiOwner and actions.semiOwner(plot) or nil
        ctx.semiPickup = attempt
    end
    if attempt.confirmed then return end
    attempt.expires = os.clock() + 4
    FUNHUBHold.pendingSemiPickup = attempt
end
function FUNHUBHold.checkSemiPickup()
    local attempt = FUNHUBHold.pendingSemiPickup
    if not attempt then return end
    local ch = player.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    if not FUNHUB_ALIVE() or ch ~= attempt.character or not hum or hum.Health <= 0
        or _G.FUNHUB_SemiTP_ResetBusy or os.clock() > attempt.expires then
        FUNHUBHold.pendingSemiPickup = nil
        return
    end
    if not isStealBoostLive() then return end
    FUNHUBHold.pendingSemiPickup = nil
    attempt.confirmed = true
    local actions = FUNHUBFx.actions
    if actions and actions.onSemiPickup then actions.onSemiPickup(attempt) end
end
function FUNHUBHold.track(ctx, source, label)
    if not ctx then return end
    ctx.source = source
    ctx.label = label or ctx.prompt.ObjectText or "Target"
    FUNHUBHold.progress.contexts[source] = ctx
end
function FUNHUBHold.confirm(ctx)
    FUNHUBHold.checkSemiPickup()
    if not ctx or ctx.confirmed then return end
    local st = player:GetAttribute("Stealing")
    if st == nil or st == false then return end
    if not (ctx.lastTrigger or ctx.nativeHolding) then return end
    ctx.confirmed = true
    FUNHUBHold.progress.result = { source = ctx.source, label = ctx.label, at = os.clock() }
end
function FUNHUBHold.progressView()
    local state = FUNHUBHold.progress
    for _, source in ipairs({ "Semi TP", "Public Grab", "Auto Grab" }) do
        local ctx = state.contexts[source]
        local valid = ctx and (ctx.semiSource and FUNHUB.semiSource.valid(ctx)
            or (not ctx.semiSource and FUNHUBHold.valid(ctx)))
        if valid then
            FUNHUBHold.confirm(ctx)
            local need = ctx.progressDuration or (math.max(0, tonumber(ctx.prompt.HoldDuration) or 1.3) + 0.05)
            local age = ctx.holdBeganAt and math.max(0, tick() - ctx.holdBeganAt) or 0
            local text = ctx.confirmed and "Grab confirmed" or (ctx.lastTrigger and "Confirming grab"
                or (age >= need and "Ready" or "Grabbing"))
            if source == "Semi TP" and not ctx.lastTrigger and not ctx.confirmed then text = "Teleporting" end
            if source == "Semi TP" and FUNHUBUI.bypassWaiting then text = "Waiting for owner" end
            return ctx.confirmed and 1 or math.min(ctx.sourceAutograb and 1 or 0.99, age / need), source, ctx.label, text, ctx.confirmed
        end
    end
    local pending = state.pendingSemi
    if pending then
        if pending.ctx.character == player.Character and os.clock() < pending.expires then
            FUNHUBHold.confirm(pending.ctx)
        else state.pendingSemi = nil end
    end
    local result = state.result
    if result and os.clock() - result.at < 1.5 then
        return 1, result.source or "FUNHUB", result.label, "Grab confirmed", true
    end
    if _G.FUNHUB_SemiTP_Busy or FUNHUB.debounce then return 0, "Semi TP", "", "Moving to target", false end
    return 0, "Autograb", "", "Waiting for target", false
end

-- Semi TP uses the supplied 28-slot timing independently of background Auto Grab.
FUNHUB.semiSource = {}
do
    local S = FUNHUB.semiSource
    function S.valid(ctx)
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        return ctx and not ctx.cancelled and FUNHUB_ALIVE() and FUNHUBHold.isStealAction(ctx.prompt)
            and ch == ctx.character and hum and hum.Health > 0
            and not _G.FUNHUB_SemiTP_ResetBusy and os.clock() < ctx.expires
    end
    function S.dispatch(ctx, callbacks)
        for _, fn in ipairs(callbacks or {}) do
            task.spawn(function()
                if S.valid(ctx) then
                    local ok, err = pcall(fn)
                    if not ok then ctx.failed = tostring(err) end
                end
            end)
        end
    end
    function S.restart(ctx)
        if not S.valid(ctx) then return false end
        S.dispatch(ctx, ctx.cb.hold)
        ctx.holdBeganAt, ctx.holdDone = tick(), true
        FUNHUBHold.lastHold = ctx.holdBeganAt
        return true
    end
    function S.fire(ctx)
        if not S.valid(ctx) then return false end
        if ctx.native and type(fireproximityprompt) ~= "function" then return false end
        ctx.lastTrigger = tick()
        FUNHUBHold.noteSemiAttempt(ctx)
        if ctx.native then
            pcall(fireproximityprompt, ctx.prompt, 0)
        else
            S.dispatch(ctx, ctx.cb.trigger)
        end
        return true
    end
    function S.startStealHold(prompt)
        if not FUNHUBHold.isStealAction(prompt) then return nil end
        local cb = FUNHUBStealCallbacks(prompt)
        local now = tick()
        local ctx = { prompt = prompt, cb = cb or {hold = {}, trigger = {}}, native = cb == nil,
            character = player.Character, semiSource = true, ragdollFireTime = now, startedAt = now,
            expires = os.clock() + 30, progressDuration = 1.3,
            originalLOS = prompt.RequiresLineOfSight, originalRange = prompt.MaxActivationDistance }
        -- The supplied Semi TPs configure the selected prompt before starting the route.
        prompt.RequiresLineOfSight = false
        prompt.MaxActivationDistance = math.huge
        S.restart(ctx)
        FUNHUBHold.track(ctx, "Semi TP", podiumInfoText ~= "" and podiumInfoText or nil)
        if ctx.native then
            task.spawn(function()
                if S.valid(ctx) and type(fireproximityprompt) == "function" then
                    ctx.lastTrigger = tick()
                    FUNHUBHold.noteSemiAttempt(ctx)
                    pcall(fireproximityprompt, prompt)
                end
            end)
        end
        return ctx
    end
    function S.waitForStealTime(ctx, seconds)
        -- Source behavior: only the short approach settle waits here.
        if not ctx or seconds >= 1 then return end
        local deadline = ctx.ragdollFireTime + seconds
        while S.valid(ctx) and tick() < deadline do RunService.Heartbeat:Wait() end
    end
    function S.finishStealHold(ctx)
        if not S.valid(ctx) then return false end
        if not ctx.holdBeganAt then S.restart(ctx) end
        -- Refresh only an expired source bank after a long walk/tool equip.
        if tick() - ctx.holdBeganAt > 2.5 then S.restart(ctx) end
        -- Ground grab uses the supplied 1.3-second bank, already running during movement.
        while S.valid(ctx) and tick() - ctx.holdBeganAt < 1.3 do RunService.Heartbeat:Wait() end
        if not S.valid(ctx) then return false end
        task.wait(0.02)
        return S.fire(ctx)
    end
    function S.stop(ctx)
        if not ctx then return end
        if ctx.lastTrigger then
            FUNHUBHold.progress.pendingSemi = { ctx = ctx, expires = os.clock() + 4 }
        end
        FUNHUBHold.cancel(ctx)
        pcall(function()
            ctx.prompt.RequiresLineOfSight = ctx.originalLOS
            ctx.prompt.MaxActivationDistance = ctx.originalRange
        end)
    end
end



function FUNHUB.maxPodium()
    local plots = Workspace:FindFirstChild("Plots")
    local best = 0
    for _, plot in ipairs(plots and plots:GetChildren() or {}) do
        if (not targetPlot or plot == targetPlot) and isEnemyPlot(plot) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            for _, p in ipairs(pods and pods:GetChildren() or {}) do
                local k = tonumber(p.Name)
                if k and k > best then best = k end
            end
        end
    end
    return best > 0 and best or MAX_PODIUM
end

function FUNHUB.setSlot(slot)
    slot = math.floor(tonumber(slot) or 1)
    if slot >= 1 and slot <= FUNHUB.maxPodium() then
        selectedSlot = slot
        HubConfig.selectedSlot = slot
        saveHubConfig()
    end
end

FUNHUB.CARPETS = { "Flying Carpet", "Cupid's Wings", "Santa's Sleigh", "Waverider", "Witch's Broom" }

function FUNHUB.findTool(name)
    local char, bp = player.Character, player:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end

FUNHUB.logT0 = os.clock()
function FUNHUB.debugEnabled()
    return _G.FUNHUB_SemiTP_Debug == true
end
function FUNHUB.log(msg)
    local line = string.format("+%.2fs %s", os.clock() - FUNHUB.logT0, msg)
    local buf = _G.FUNHUB_SemiTP_Log or {}
    _G.FUNHUB_SemiTP_Log = buf
    buf[#buf + 1] = line
    if #buf > 80 then table.remove(buf, 1) end
    if FUNHUB.debugEnabled() then print("[SEMI TP] " .. line) end
end

function FUNHUBUI.clonerState()
    local cl = FUNHUB.findTool("Quantum Cloner")
    if not cl then return false, "NO QUANTUM CLONER" end
    local cd = cl:GetAttribute("CooldownTime")
    if cd ~= nil then
        local n = tonumber(cd)
        return false, "CLONER COOLDOWN" .. (n and string.format(" %.1fs", n) or "")
    end
    return true
end

function FUNHUB.carpetOn()
    local char = player.Character
    if not char then return false end
    for _, n in ipairs(FUNHUB.CARPETS) do
        if char:FindFirstChild(n) then return true end
    end
    return false
end

function FUNHUB.equipCarpet()
    if _G.FUNHUB_SemiTP_ResetBusy then return false end
    if potionState.busy then return FUNHUB.carpetOn() end
    if FUNHUB.carpetOn() then return true end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local pick = HubConfig.flyTool and FUNHUB.findTool(HubConfig.flyTool)
    if not (pick and table.find(FUNHUB.CARPETS, pick.Name)) then pick = nil end
    for _, n in ipairs(FUNHUB.CARPETS) do
        if pick then break end
        pick = FUNHUB.findTool(n)
    end
    if pick then pcall(function() hum:EquipTool(pick) end) end
    return false
end

function FUNHUB.hushGrapple(g, secs)
    local char = player.Character
    local function ours(d)
        return (char and d:IsDescendantOf(char)) or d:IsDescendantOf(g)
    end
    local function hush(d)
        if d:IsA("Sound") then
            d.Volume = 0
            pcall(d.Stop, d)
        elseif d:IsA("Beam") or d:IsA("Trail") or d:IsA("ParticleEmitter") then
            d.Enabled = false
        elseif d:IsA("RopeConstraint") or d:IsA("RodConstraint") then
            d.Visible = false
        elseif d:IsA("BasePart") then
            d.LocalTransparencyModifier = 1
        end
    end
    for _, d in ipairs(g:GetDescendants()) do pcall(hush, d) end
    if not secs then return end
    local function added(d)
        local n = d.Name:lower()
        local named = n:find("hook", 1, true) or n:find("rope", 1, true) or n:find("grapple", 1, true)
        local linked = false
        if d:IsA("Beam") or d:IsA("RopeConstraint") or d:IsA("RodConstraint") then
            local a0, a1 = d.Attachment0, d.Attachment1
            linked = (a0 and ours(a0)) or (a1 and ours(a1))
        end
        local sound = d:IsA("Sound") and (d:IsDescendantOf(g) or tostring(d.SoundId):find("1621103", 1, true)
            or tostring(d.SoundId):find("16211041", 1, true))
        if named or linked or sound or d:IsDescendantOf(g) then pcall(hush, d) end
        if d:IsA("Constraint") then
            local a0, a1 = d.Attachment0, d.Attachment1
            local in0, in1 = a0 and char and a0:IsDescendantOf(char), a1 and char and a1:IsDescendantOf(char)
            if a0 and a1 and in0 ~= in1 then
                pcall(function() d.Enabled = false end)
                if FUNHUB.log then FUNHUB.log("  grapple pull cut: " .. d.ClassName .. " " .. d.Name) end
            elseif (in0 or in1) and FUNHUB.log then
                FUNHUB.log("  grapple window: " .. d.ClassName .. " " .. d.Name .. " (left on)")
            end
        elseif char and d:IsDescendantOf(char) and d:IsA("BodyMover") and d.Name == "FlightPower" then
            task.defer(function() pcall(function() d:Destroy() end) end)
            if FUNHUB.log then FUNHUB.log("  grapple pull removed: FlightPower") end
        elseif char and d:IsDescendantOf(char) and d:IsA("BodyMover") and FUNHUB.log then
            FUNHUB.log("  grapple window: " .. d.ClassName .. " " .. d.Name .. " in " .. d.Parent.Name .. " (left on)")
        end
    end
    local conn = Workspace.DescendantAdded:Connect(function(d) task.defer(added, d) end)
    task.delay(secs, function() conn:Disconnect() end)
end

function FUNHUB.grappleBoost()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local g = FUNHUB.findTool("Grapple Hook")
    if hum and g then
        pcall(FUNHUB.hushGrapple, g, 1.5)
        pcall(function() hum:EquipTool(g) end)
        local t0 = os.clock()
        while g.Parent ~= char and os.clock() - t0 < 0.35 do RunService.Heartbeat:Wait() end
        if g.Parent == char then task.spawn(pcall, g.Activate, g) end
        task.wait(0.06)
        pcall(function() hum:UnequipTools() end)
        RunService.Heartbeat:Wait()
    end
    local t0 = os.clock()
    while not FUNHUB.equipCarpet() and os.clock() - t0 < 2 do RunService.Heartbeat:Wait() end
end

function FUNHUB.glide(hrp, dest, speed, cap)
    local t0, revision = os.clock(), FUNHUB.flightRevision or 0
    while hrp.Parent and not _G.FUNHUB_SemiTP_ResetBusy and revision == (FUNHUB.flightRevision or 0)
        and os.clock() - t0 < (cap or 3) do
        local d = dest - hrp.Position
        if d.Magnitude <= 2 then break end
        FUNHUB.equipCarpet()
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.AssemblyLinearVelocity = d.Unit * math.min(speed, math.max(d.Magnitude * 8, 40))
        RunService.Heartbeat:Wait()
    end
    if hrp.Parent and not _G.FUNHUB_SemiTP_ResetBusy and revision == (FUNHUB.flightRevision or 0) then
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end

function FUNHUB.flyRoute(hrp, waypoints, speed)
    if not hrp or not hrp.Parent or #waypoints == 0 or _G.FUNHUB_SemiTP_ResetBusy then return end
    local revision = FUNHUB.flightRevision or 0
    speed = speed or 400
    local CLIMB = 120
    local idx, done, lastDist, stallSince = 1, false, math.huge, nil
    local total, prev = 0, hrp.Position
    for _, wp in ipairs(waypoints) do total = total + (wp - prev).Magnitude prev = wp end
    local function body()
        local ch = hrp.Parent
        return ch and (ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")) or hrp
    end
    local conn
    local function finish(cancelled)
        if done then return end
        done = true
        if conn then conn:Disconnect() end
        if hrp.Parent and not cancelled then
            hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
            local last = waypoints[#waypoints]
            if (hrp.Position - last).Magnitude <= 6 then
                local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
                hrp.CFrame = CFrame.new(last) * CFrame.Angles(0, yaw, 0)
            end
        end
    end
    conn = RunService.Heartbeat:Connect(function()
        if not hrp.Parent or not FUNHUB_ALIVE() or _G.FUNHUB_SemiTP_ResetBusy
            or revision ~= (FUNHUB.flightRevision or 0) then finish(true) return end
        FUNHUB.equipCarpet()
        local target = waypoints[idx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        local spd = speed
        local lastWp = idx == #waypoints
        if lastWp then spd = math.min(spd, math.max(40, mag * 12)) end
        if idx < #waypoints and mag < 26 then
            local turn = waypoints[idx + 1] - target
            if mag > 0.1 and turn.Magnitude > 0.1 and diff.Unit:Dot(turn.Unit) < 0.9 then spd = math.min(spd, 240) end
        end
        if mag < (lastWp and 1.5 or math.max(3, spd / 60 * 1.25)) then
            idx = idx + 1
            if idx > #waypoints then finish() return end
            lastDist, stallSince = math.huge, nil
            target = waypoints[idx]
            diff = target - hrp.Position
            mag = diff.Magnitude
        end
        if mag > lastDist - 0.05 then
            stallSince = stallSince or os.clock()
            if os.clock() - stallSince >= 0.4 then finish() return end
        else
            stallSince = nil
        end
        lastDist = mag
        if mag >= 0.1 then
            local dir = diff.Unit
            local sp = spd
            if dir.Y > 0 and dir.Y * sp > CLIMB then sp = CLIMB / dir.Y end
            hrp.AssemblyAngularVelocity = Vector3.zero
            body().AssemblyLinearVelocity = dir * sp
        end
    end)
    local timeout = os.clock() + total / math.min(125, speed) + 2
    local nextTrace, t0 = 0, os.clock()
    while not done and os.clock() < timeout and hrp.Parent do
        if os.clock() >= nextTrace and FUNHUB.log then
            nextTrace = os.clock() + 0.1
            local ch = hrp.Parent
            local tool = ch and ch:FindFirstChildOfClass("Tool")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            FUNHUB.log(string.format("  fly %.2fs  wp %d/%d  to end %.0f  vel %.0f  tool=%s  state=%s  anchored=%s",
                os.clock() - t0, idx, #waypoints, (waypoints[#waypoints] - hrp.Position).Magnitude,
                hrp.AssemblyLinearVelocity.Magnitude, tool and tool.Name or "-",
                hum and hum:GetState().Name or "?", tostring(hrp.Anchored)))
        end
        task.wait(0.03)
    end
    finish()
end

function FUNHUB.blocked(a, b, slackA, slackB)
    local d = b - a
    local len = d.Magnitude
    if len < 0.5 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or 0, len * 0.4)
    local b2 = b - u * math.min(slackB or 0, len * 0.4)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.RespectCanCollide = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    local clone = Workspace:FindFirstChild(tostring(player.UserId) .. "_Clone")
    if clone then skip[#skip + 1] = clone end
    rp.FilterDescendantsInstances = skip
    local ok, hit = pcall(Workspace.Spherecast, Workspace, a2, 3, b2 - a2, rp)
    if not ok then hit = Workspace:Raycast(a2, b2 - a2, rp) end
    return hit ~= nil
end

function FUNHUB.gridPath(from, goal, y)
    local CELL, R, MARGIN, MAXN, W = 6, 3, 90, 6000, 100000
    local op = OverlapParams.new()
    op.FilterType = Enum.RaycastFilterType.Exclude
    op.RespectCanCollide = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    local clone = Workspace:FindFirstChild(tostring(player.UserId) .. "_Clone")
    if clone then skip[#skip + 1] = clone end
    op.FilterDescendantsInstances = skip
    local x0 = math.min(from.X, goal.X) - MARGIN
    local z0 = math.min(from.Z, goal.Z) - MARGIN
    local nx = math.ceil((math.max(from.X, goal.X) + MARGIN - x0) / CELL)
    local nz = math.ceil((math.max(from.Z, goal.Z) + MARGIN - z0) / CELL)
    local function pos(k) return Vector3.new(x0 + (k // W) * CELL, y, z0 + (k % W) * CELL) end
    local function cellOf(p) return math.floor((p.X - x0) / CELL + 0.5), math.floor((p.Z - z0) / CELL + 0.5) end
    local open = {}
    local function isOpen(i, j)
        if i < 0 or j < 0 or i > nx or j > nz then return false end
        local k = i * W + j
        local v = open[k]
        if v == nil then
            v = #Workspace:GetPartBoundsInRadius(pos(k), R, op) == 0
            open[k] = v
        end
        return v
    end
    local si, sj = cellOf(from)
    local gi, gj = cellOf(goal)
    local sk, gk = si * W + sj, gi * W + gj
    open[sk], open[gk] = true, true
    local function h(i, j)
        local dx, dz = math.abs(i - gi), math.abs(j - gj)
        return math.max(dx, dz) + 0.414 * math.min(dx, dz)
    end
    local heap = {}
    local function push(f, k)
        heap[#heap + 1] = { f, k }
        local c = #heap
        while c > 1 do
            local p = c // 2
            if heap[p][1] <= heap[c][1] then break end
            heap[p], heap[c] = heap[c], heap[p]
            c = p
        end
    end
    local function pop()
        local top = heap[1]
        local last = table.remove(heap)
        if #heap > 0 then
            heap[1] = last
            local c = 1
            while true do
                local l, r, m = c * 2, c * 2 + 1, c
                if heap[l] and heap[l][1] < heap[m][1] then m = l end
                if heap[r] and heap[r][1] < heap[m][1] then m = r end
                if m == c then break end
                heap[m], heap[c] = heap[c], heap[m]
                c = m
            end
        end
        return top
    end
    local DIRS = { { 1, 0, 1 }, { -1, 0, 1 }, { 0, 1, 1 }, { 0, -1, 1 },
        { 1, 1, 1.414 }, { 1, -1, 1.414 }, { -1, 1, 1.414 }, { -1, -1, 1.414 } }
    local TURN = 0.5
    local g, came, closed, pdir = { [sk] = 0 }, {}, {}, {}
    push(h(si, sj), sk)
    local n, found = 0, false
    while #heap > 0 and n < MAXN do
        local k = pop()[2]
        if not closed[k] then
            closed[k] = true
            n = n + 1
            if k == gk then found = true break end
            local i, j = k // W, k % W
            local pd = pdir[k]
            for _, d in ipairs(DIRS) do
                local a, b = i + d[1], j + d[2]
                if isOpen(a, b) and (d[3] == 1 or (isOpen(a, j) and isOpen(i, b))) then
                    local nk, ng = a * W + b, g[k] + d[3] + ((pd and pd ~= d) and TURN or 0)
                    if not closed[nk] and (g[nk] == nil or ng < g[nk]) then
                        g[nk], came[nk], pdir[nk] = ng, k, d
                        push(ng + h(a, b), nk)
                    end
                end
            end
        end
    end
    if not found then return nil, n end
    local cells, k = {}, gk
    while k do cells[#cells + 1] = k k = came[k] end
    local pts = {}
    for idx = #cells, 1, -1 do pts[#pts + 1] = pos(cells[idx]) end
    pts[1], pts[#pts] = from, goal
    local out, cur = {}, 1
    while cur < #pts do
        local j = #pts
        while j > cur + 1 and FUNHUB.blocked(pts[cur], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        cur = j
    end
    return out, n
end

function FUNHUB.routeTime(from, pts, speed)
    local t, prev = 0, from
    for _, p in ipairs(pts) do
        local d = p - prev
        t = t + math.max(d.Magnitude / speed, math.max(d.Y, 0) / 120)
        prev = p
    end
    return t
end

function FUNHUB.planRoute(from, approach, spot, cruiseY, speed)
    local B = FUNHUB.blocked
    local SLACK = 6
    speed = speed or 360
    if not B(from, approach, SLACK, 2) then return { approach, spot }, "straight" end
    local best, bestT, bestKind = nil, math.huge, nil
    local function consider(route, kind)
        local t = FUNHUB.routeTime(from, route, speed)
        if t < bestT then best, bestT, bestKind = route, t, kind end
    end
    local t0 = os.clock()
    for _, lift in ipairs({ 0, 12, 25, 45 }) do
        local y = approach.Y + lift
        local rise = Vector3.new(from.X, y, from.Z)
        local goal = Vector3.new(approach.X, y, approach.Z)
        local up = math.abs(from.Y - y) > 2
        if (not up or not B(from, rise, SLACK, 0)) and (lift == 0 or not B(goal, approach, 0, 2)) then
            local pts = FUNHUB.gridPath(rise, goal, y)
            if pts then
                local route = {}
                if up and B(from, pts[1], SLACK, 0) then route[1] = rise end
                for _, p in ipairs(pts) do route[#route + 1] = p end
                if lift > 0 then route[#route + 1] = approach end
                route[#route + 1] = spot
                consider(route, "path" .. (lift > 0 and (" +" .. lift) or ""))
            end
        end
    end
    local function pull(pts)
        local out, i = {}, 0
        local cur = from
        while i < #pts do
            local j = #pts
            while j > i + 1 and B(cur, pts[j], i == 0 and SLACK or 0, 0) do j = j - 1 end
            out[#out + 1] = pts[j]
            cur, i = pts[j], j
        end
        return out
    end
    for _, lift in ipairs({ 12, 25, 45 }) do
        local cy = math.max(from.Y, approach.Y) + lift
        local up, over = Vector3.new(from.X, cy, from.Z), Vector3.new(approach.X, cy, approach.Z)
        if not B(from, up, SLACK, 0) and not B(up, over) and not B(over, approach, 0, 2) then
            local pts = pull({ up, over, approach })
            pts[#pts + 1] = spot
            consider(pts, "crest +" .. lift)
            break
        end
    end
    local flat = Vector3.new(approach.X - from.X, 0, approach.Z - from.Z)
    if flat.Magnitude > 1 then
        local perp = Vector3.new(-flat.Unit.Z, 0, flat.Unit.X)
        local mid0 = (from + approach) * 0.5
        for _, off in ipairs({ 14, -14, 24, -24, 38, -38, 56, -56, 76, -76 }) do
            local mid = mid0 + perp * off
            if not B(from, mid, SLACK, 0) and not B(mid, approach, 0, 2) then
                consider({ mid, approach, spot }, "bend " .. off)
                break
            end
        end
    end
    if best then
        return best, string.format("%s (%.2fs, planned in %.0fms)", bestKind, bestT, (os.clock() - t0) * 1000)
    end
    local high = Vector3.new(approach.X, cruiseY, approach.Z)
    local lift = from:Lerp(high, 0.25)
    return { Vector3.new(lift.X, cruiseY, lift.Z), high, approach, spot }, "high cruise"
end

function FUNHUB.drawPath(from, pts)
    local old = Workspace:FindFirstChild("FUNHUB_SemiTP_Path")
    if old then old:Destroy() end
    if HubConfig.showPathEnabled == false then return end
    local folder = Instance.new("Folder")
    folder.Name = "FUNHUB_SemiTP_Path"
    local function part(cf, size, ball)
        local p = Instance.new("Part")
        p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
        p.Material = Enum.Material.Neon
        p.Color = T.ACCENT
        if ball then p.Shape = Enum.PartType.Ball end
        p.Size, p.CFrame = size, cf
        p.Parent = folder
    end
    local prev = from
    for _, wp in ipairs(pts) do
        local d = wp - prev
        if d.Magnitude > 0.05 then
            part(CFrame.lookAt((prev + wp) * 0.5, wp), Vector3.new(0.3, 0.3, d.Magnitude), false)
        end
        prev = wp
    end
    part(CFrame.new(pts[#pts]), Vector3.new(1.6, 1.6, 1.6), true)
    folder.Parent = Workspace
    task.delay(6, function() if folder.Parent then folder:Destroy() end end)
end

function FUNHUB.quantumClone()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local cloner = FUNHUB.findTool("Quantum Cloner")
    if not hum or not hrp or not cloner then return false end
    local function stealing()
        local st = player:GetAttribute("Stealing")
        return st ~= nil and st ~= false
    end
    if FUNHUB.lastSwapAt and os.clock() - FUNHUB.lastSwapAt < 5 then
        FUNHUB.log("clone skipped - swapped under 5s ago")
        return false
    end
    if cloner.Parent ~= char then pcall(function() hum:EquipTool(cloner) end) end
    local t0 = os.clock()
    while cloner.Parent ~= char and os.clock() - t0 < 0.5 do RunService.Heartbeat:Wait() end
    pcall(function() hum:Move(Vector3.zero, false) end)
    hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
    local lockCF = hrp.CFrame
    hrp.Anchored = true
    task.delay(2.5, function() if hrp.Parent then hrp.Anchored = false end end)
    t0 = os.clock()
    while os.clock() - t0 < 0.15 do
        RunService.Heartbeat:Wait()
        if hrp.Parent then hrp.CFrame = lockCF end
    end
    local cloneName = tostring(player.UserId) .. "_Clone"
    pcall(function() cloner:Activate() end)
    t0 = os.clock()
    local clone
    repeat
        RunService.Heartbeat:Wait()
        clone = Workspace:FindFirstChild(cloneName)
        if clone and (clone:GetPivot().Position - hrp.Position).Magnitude > 12 then clone = nil end
    until clone or os.clock() - t0 > 1
    hrp.Anchored = false
    FUNHUB.log(string.format("clone %s after %.2fs  (%.1f studs away)  equipped=%s",
        clone and "spawned" or "NOT seen", os.clock() - t0,
        clone and (clone:GetPivot().Position - hrp.Position).Magnitude or -1, tostring(cloner.Parent == char)))
    local frames = player.PlayerGui:FindFirstChild("ToolsFrames")
    local qc = frames and frames:FindFirstChild("QuantumCloner")
    local btn = qc and qc:FindFirstChild("TeleportToClone")
    if not btn or not firesignal or not clone then pcall(function() hum:UnequipTools() end) return false end
    local cloneAt = clone:GetPivot().Position
    local target = FUNHUB.cloneTarget
    if target then
        local function flat(v) return Vector2.new(v.X - target.X, v.Z - target.Z).Magnitude end
        if flat(cloneAt) > flat(hrp.Position) + 10 then
            FUNHUB.log(string.format("clone landed BEHIND us (%.1f vs %.1f from the brainrot) - no swap",
                flat(cloneAt), flat(hrp.Position)))
            pcall(function() hum:UnequipTools() end)
            return false
        end
    end
    if stealing() then pcall(function() hum:UnequipTools() end) return "stole" end
    local from = hrp.Position
    local gapV = Vector3.new(cloneAt.X - from.X, 0, cloneAt.Z - from.Z)
    local gap = gapV.Magnitude
    local dir = gap > 0.01 and gapV / gap or Vector3.zero
    local function swapDone()
        local me = (hrp.Position - from):Dot(dir)
        local cl = clone.Parent and Vector2.new(clone:GetPivot().Position.X - cloneAt.X,
            clone:GetPivot().Position.Z - cloneAt.Z).Magnitude or gap
        return me >= gap * 0.5 and cl >= gap * 0.5
    end
    local lastPress, presses = 0, 0
    t0 = os.clock()
    repeat
        if os.clock() - lastPress >= 0.1 then
            lastPress = os.clock()
            presses = presses + 1
            btn.Visible = true
            pcall(firesignal, btn.MouseButton1Up)
            FUNHUB.lastSwapAt = os.clock()
        end
        RunService.Heartbeat:Wait()
        if stealing() then break end
    until player.Character ~= char or not hrp.Parent or (gap >= 1.25 and swapDone()) or os.clock() - t0 > 1.5
    local ok = gap >= 1.25 and hrp.Parent and swapDone()
    FUNHUB.log(string.format("swap: %d presses in %.2fs  moved %.1f studs (gap %.1f)  confirmed=%s  newChar=%s",
        presses, os.clock() - t0, (hrp.Position - from).Magnitude, gap, tostring(ok), tostring(player.Character ~= char)))
    pcall(function() hum:UnequipTools() end)
    if stealing() and not ok then return "stole" end
    return ok and true or false
end

function FUNHUB.petPos(pod)
    for _, d in ipairs(pod.podium:GetDescendants()) do
        if d:IsA("Model") and d.Name ~= "Claim" and d.Name ~= "Base" and d.Name ~= "Decorations"
            and d:FindFirstChildWhichIsA("MeshPart", true) then
            local ok, cf = pcall(d.GetBoundingBox, d)
            if ok then return cf.Position end
        end
    end
    return pod.spawn.Position
end

function FUNHUB.oneWayPlatform(pos)
    local old = Workspace:FindFirstChild("FUNHUB_SemiTP_Platform")
    if old then old:Destroy() end
    local plat = Instance.new("Part")
    plat.Name = "FUNHUB_SemiTP_Platform"
    plat.Size = Vector3.new(10, 1, 10)
    plat.Position = pos
    plat.Anchored, plat.CanCollide, plat.Transparency = true, false, 1
    plat.Parent = Workspace
    local conn, lastY
    conn = RunService.Stepped:Connect(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not plat.Parent or not hrp then conn:Disconnect() return end
        local y = hrp.Position.Y
        local up = hrp.AssemblyLinearVelocity.Y > 1 or (lastY and y - lastY > 0.01 and y - lastY < 5)
        plat.CanCollide = not up and y > plat.Position.Y + 0.1
        lastY = y
    end)
    task.delay(20, function() if plat.Parent then plat:Destroy() end end)
    return plat
end

function FUNHUB.upperSteal(pod, ctx)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cf = pod.rootCF
    local podLocal = cf:PointToObjectSpace(pod.spawn.Position)
    local s = podLocal.X >= 0 and 1 or -1
    local L = FUNHUB.log
    local function podDist()
        local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        return h and (h.Position - pod.spawn.Position).Magnitude or -1
    end
    L(string.format("UPPER podium %s  local(%.1f, %.1f, %.1f)  dist %.0f  hold=%s  prompt=%s",
        pod.podium.Name, podLocal.X, podLocal.Y, podLocal.Z, podDist(), tostring(ctx ~= nil), tostring(pod.prompt.Enabled)))
    if not pod.prompt.Enabled then
        L("podium prompt disabled - brainrot not grabbable yet, stopping")
        setStealStatus("BRAINROT NOT GRABBABLE YET - WAIT", false)
        return
    end
    if ctx then ctx.progressDuration = (tonumber(pod.prompt.HoldDuration) or 1.3) + 0.05 end
    stopFlyGear()

    FUNHUB.grappleBoost()
    L(string.format("grapple done  SpeedAllowance=%s  carpet=%s",
        tostring(char:GetAttribute("SpeedAllowance")), tostring(FUNHUB.carpetOn())))

    local flying = true
    if ctx then
        task.spawn(function()
            while flying and FUNHUB.semiSource.valid(ctx) do
                if tick() - (ctx.holdBeganAt or 0) >= 2.4 then
                    FUNHUB.semiSource.restart(ctx)
                end
                task.wait(0.05)
            end
        end)
    end

    local spotY = podLocal.Y + 5.4
    local spotZ = math.clamp(podLocal.Z, -18, 18)
    local spot = cf * Vector3.new(24.6 * s, spotY, spotZ)
    local approach = cf * Vector3.new(34 * s, spotY, spotZ)
    local route, kind = FUNHUB.planRoute(hrp.Position, approach, spot, (cf * Vector3.new(0, 85, 0)).Y, 360)
    FUNHUB.drawPath(hrp.Position, route)
    L(string.format("route: %s, %d points", kind, #route))
    local flyT = os.clock()
    FUNHUB.flyRoute(hrp, route, 360)
    flying = false
    local offSpot = hrp.Parent and (hrp.Position - spot).Magnitude or math.huge
    L(string.format("flight done in %.2fs  off spot %.1f  pod dist %.1f", os.clock() - flyT, offSpot, podDist()))
    if offSpot > 6 then
        flying = false
        L("FLIGHT FAILED - never reached the clone spot, stopping")
        setStealStatus("FLIGHT BLOCKED - TRY AGAIN", false)
        return
    end
    if ctx then
        FUNHUB.semiSource.restart(ctx)
        L(string.format("hold restarted at the wall (pod dist %.1f)", podDist()))
    end

    local function stealing()
        local st = player:GetAttribute("Stealing")
        return st ~= nil and st ~= false
    end
    local grabbing = true
    local function upperTrigger()
        local need = (tonumber(pod.prompt.HoldDuration) or 1.3) + 0.05
        while grabbing and FUNHUB.semiSource.valid(ctx) and not stealing() do
            local age = tick() - (ctx.holdBeganAt or 0)
            if age > 2.5 then
                FUNHUB.semiSource.restart(ctx)
                L("hold older than 2.5s - restarted")
            elseif age >= need then
                break
            end
            RunService.Heartbeat:Wait()
        end
        if not grabbing or not FUNHUB.semiSource.valid(ctx) or stealing() then return end
        if podDist() > 10 then L(string.format("grab held back - pod dist %.1f > 10", podDist())) return end
        L(string.format("grab fired  (hold age %.2fs, pod dist %.1f)", tick() - (ctx.holdBeganAt or 0), podDist()))
        FUNHUB.semiSource.fire(ctx)
    end
    FUNHUB.cloneTarget = pod.spawn.Position
    local grabGate = math.huge
    task.spawn(function()
        while grabbing and FUNHUB.semiSource.valid(ctx) and not stealing() do
            if os.clock() >= grabGate and fireproximityprompt and pod.prompt.Parent then ctx.lastTrigger = tick() pcall(fireproximityprompt, pod.prompt, 0) end
            RunService.Heartbeat:Wait()
        end
    end)

    local face = cf:VectorToWorldSpace(Vector3.new(-s, 0, 0))
    local hold = Instance.new("Part")
    hold.Name = "FUNHUB_SemiTP_ClonePad"
    hold.Size = Vector3.new(12, 1, 12)
    hold.Position = spot - Vector3.new(0, 3.5, 0)
    hold.Anchored, hold.CanCollide, hold.Transparency = true, true, 1
    hold.Parent = Workspace
    for _ = 1, 2 do
        hrp.CFrame = CFrame.lookAt(spot, spot + face)
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
        RunService.Heartbeat:Wait()
    end
    L(string.format("at the wall  pod dist %.1f  stealing=%s  cloner=%s", podDist(), tostring(stealing()),
        select(2, FUNHUBUI.clonerState()) or "ready"))
    local swapped = not stealing() and FUNHUB.quantumClone()
    local swapT = os.clock()
    hold:Destroy()
    L(string.format("clone result=%s  pod dist %.1f  stealing=%s", tostring(swapped), podDist(), tostring(stealing())))
    if stealing() or swapped == "stole" then
        grabbing = false
        L("GRABBED from the wall (no swap)")
        task.spawn(FUNHUBAutoPotion)
        return
    end
    if not swapped then
        grabbing = false
        L("CLONE FAILED - swap never moved us")
        setStealStatus("CLONE FAILED (Quantum Cloner on cooldown?)", false)
        return
    end

    char = player.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then grabbing = false return end
    hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
    task.spawn(function()
        local cl = Workspace:FindFirstChild(tostring(player.UserId) .. "_Clone")
        if not cl then return end
        local function off(p)
            if p:IsA("BasePart") then p.CanTouch, p.CanCollide, p.CanQuery = false, false, false end
        end
        for _, p in ipairs(cl:GetDescendants()) do pcall(off, p) end
        local c = cl.DescendantAdded:Connect(function(p) pcall(off, p) end)
        L("clone neutralized (no touch / collide on our side)")
        task.delay(30, function() c:Disconnect() end)
    end)
    -- Use the supplied potion routine before the under-podium snap and grab.
    -- The clone is finished; re-equipping the carpet happens after potion ownership ends.
    FUNHUBAutoPotion()
    if not FUNHUB.semiSource.valid(ctx) then grabbing = false return end
    local function qg(on)
        FUNHUB.semiQuickGrab = on == true and grabbing and FUNHUB.semiSource.valid(ctx) or false
    end
    local t0 = os.clock()
    while not FUNHUB.carpetOn() and os.clock() - t0 < 0.5 do FUNHUB.equipCarpet(); RunService.Heartbeat:Wait() end
    t0 = os.clock()
    while os.clock() - t0 < 0.08 do RunService.Heartbeat:Wait() end
    local to = pod.spawn.Position - Vector3.new(0, 8, 0)
    local old = Workspace:FindFirstChild("FUNHUB_SemiTP_Platform")
    if old then old:Destroy() end
    local plat = Instance.new("Part")
    plat.Name = "FUNHUB_SemiTP_Platform"
    plat.Size = Vector3.new(3, 1, 3)
    plat.Position = to - Vector3.new(0, 5, 0)
    plat.Anchored, plat.CanCollide, plat.Transparency = true, true, 1
    plat.Parent = Workspace
    task.spawn(function()
        task.wait(30)
        while plat.Parent and stealing() do task.wait(0.5) end
        if plat.Parent then plat:Destroy() end
    end)
    RunService.Heartbeat:Wait()
    local snapped = false
    for _ = 1, 2 do
        if not hrp.Parent then grabbing = false return end
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
        hrp.CFrame = CFrame.new(to) * hrp.CFrame.Rotation
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
        t0 = os.clock()
        while os.clock() - t0 < 0.05 do RunService.Heartbeat:Wait() end
        if hrp.Parent and (hrp.Position - to).Magnitude <= 3 then snapped = true break end
    end
    local snapT = os.clock()
    L(string.format("snapped under the podium %.2fs after the swap  ok=%s  pod dist %.1f",
        snapT - swapT, tostring(snapped), podDist()))

    local settleUntil = math.max(snapT + 0.35, swapT + 0.5)
    while os.clock() < settleUntil and not stealing() do RunService.Heartbeat:Wait() end
    grabGate = os.clock()
    L(string.format("settled %.2fs after the swap - grabbing  pod dist %.1f  hold age %.2fs",
        os.clock() - swapT, podDist(), ctx and tick() - (ctx.holdBeganAt or 0) or -1))
    qg(true)
    FUNHUB.upperGrab = true
    if ctx then task.spawn(upperTrigger) end
    local pulses = 0
    task.spawn(function()
        local t = os.clock()
        while not stealing() and FUNHUB.upperGrab and FUNHUB.semiSource.valid(ctx) and os.clock() - t < 1.5 do
            task.wait(0.1)
            if stealing() or not FUNHUB.upperGrab then break end
            qg(false)
            task.wait(0.03)
            qg(true)
            pulses = pulses + 1
        end
        qg(not stealing())
    end)
    local function grabFor(sec)
        local t = os.clock()
        while FUNHUB.semiSource.valid(ctx) and not stealing() and os.clock() - t < sec do RunService.Heartbeat:Wait() end
        return stealing()
    end
    local got = grabFor(2.5)
    grabbing = false
    FUNHUB.upperGrab = false
    FUNHUB.semiQuickGrab = false
    if got then
        qg(false)
        L(string.format("GRABBED under the podium %.2fs after the swap  (quick grab pulses %d, now OFF)",
            os.clock() - swapT, pulses))
        task.spawn(FUNHUBAutoPotion)
        return
    end
    L(string.format("NO GRAB under the podium (pod dist %.1f, prompt=%s, hold age %.2fs)",
        podDist(), tostring(pod.prompt.Enabled), ctx and tick() - (ctx.holdBeganAt or 0) or -1))
    setStealStatus("NO GRAB - TRY AGAIN", false)
end

function FUNHUB.SSDoTeleport(semiToken)
    if _G.FUNHUB_SemiTP_Busy then return end
    if FUNHUBUI.validateSelection then
        local valid, reason = FUNHUBUI.validateSelection()
        if not valid then FUNHUBUI.flash(reason) return end
    end
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    setFFlags()

    local pod = findPodiumTarget(selectedSlot, hrp)
    if not pod then return end

    local activeCtx
    local function doTpSequence(HRP)
        local cf = pod.rootCF
        local podLocal = cf:PointToObjectSpace(pod.spawn.Position)
        local s = podLocal.X >= 0 and 1 or -1
        local row = rowFor(podLocal.Z)
        local upper = podLocal.Y > GROUND_MAX_Y
        local function at(v) return cf * Vector3.new(v.X * s, v.Y, v.Z) end

        local inside = at(row.inside)

        local here = cf:PointToObjectSpace(HRP.Position)
        local waypoints = {
            cf * Vector3.new(math.clamp(here.X, -CORRIDOR_REACH, CORRIDOR_REACH), CORRIDOR_Y, CORRIDOR_Z),
            cf * Vector3.new(0, CORRIDOR_Y, CORRIDOR_Z),
            inside,
        }

        local function doApproachPath(HRP_, speed)
            local startIndex = 1
            for i = #waypoints, 1, -1 do
                if canDirectTp(HRP_, waypoints[i]) then startIndex = i; break end
            end
            for i = startIndex, #waypoints do
                if not walkTo(HRP_, waypoints[i], speed or 180, 3, nil,
                    semiToken and semiToken.instantCarpet) then return false end
            end
            return true
        end

        local ctx = FUNHUB.semiSource.startStealHold(pod.prompt)
        activeCtx = ctx
        if not ctx then setStealStatus("TARGET PROMPT IS NOT READY", false) return end

        if ctx and not upper then FUNHUB.semiSource.waitForStealTime(ctx, 0.8) end
        if upper then
            FUNHUB.upperSteal(pod, ctx)
        else
            if not doApproachPath(HRP, semiToken and semiToken.speed or FUNHUB.semiSpeed()) then setStealStatus("PATH BLOCKED - MOVE CLOSER AND RETRY", false) return end
            if not FUNHUB.semiSource.valid(ctx) then return end
            task.wait(0.25)

            FUNHUBAutoPotion()
            if semiToken and semiToken.instantCarpet then equipInstantCarpet(char) end

            if pod.prompt and pod.prompt.Parent then
                if ctx then FUNHUB.semiSource.waitForStealTime(ctx, 1.3) end
                if ctx and FUNHUBFx.defBypass and FUNHUBUI.waitOwnerLeave and not FUNHUBUI.waitOwnerLeave(pod, ctx) then return end
                local green = clampToPodium(inside, at(row.green), pod.spawn.Position)
                HRP.CFrame = CFrame.new(green)
                HRP.AssemblyLinearVelocity = Vector3.zero
                FUNHUB.log("ground grab (original green snap)")
                if ctx then FUNHUB.semiSource.finishStealHold(ctx) end
            end
        end
    end

    local ownsPause = semiToken == nil
    semiToken = semiToken or FUNHUB.beginSemiPause()
    _G.FUNHUB_SemiTP_Busy = true
    FUNHUBHold.progress.pendingSemi, FUNHUBHold.progress.result = nil, nil
    if FUNHUBHold.clearAuto then pcall(FUNHUBHold.clearAuto) end
    local ok, err = pcall(doTpSequence, hrp)
    FUNHUB.upperGrab, FUNHUB.semiQuickGrab = false, false
    pcall(FUNHUB.semiSource.stop, activeCtx)
    _G.FUNHUB_SemiTP_Busy = false
    pcall(stopFlyGear)
    pcall(function()
        local pad = Workspace:FindFirstChild("FUNHUB_SemiTP_ClonePad")
        if pad then pad:Destroy() end
    end)
    if ownsPause then FUNHUB.releaseSemiPause(semiToken) end
    if not ok then
        warn("[FUNHUB Semi TP] " .. tostring(err))
        setStealStatus("SEMI TP INTERRUPTED - TRY AGAIN", false)
    end
    return ok
end

local TeleportBtn = nil

function FUNHUB.execute(ignoreLock)
    if not FUNHUB_ALIVE() then return end
    if type(HubConfig.funhub) == "table" and HubConfig.funhub.semiInstant == false then return end
    if FUNHUB.semiMode() == "Grapple" then
        local grapple = FUNHUB.grappleSemi
        -- Automatic triggers must not turn a second request into a cancellation.
        if grapple and not grapple.Busy then return grapple.Run() end
        return
    end
    if FUNHUBUI.validateSelection then
        local valid, reason = FUNHUBUI.validateSelection()
        if not valid then FUNHUBUI.flash(reason) return end
    end
    if FUNHUBUI.bypassWaiting then FUNHUBUI.bypassWaiting = false return end
    if player:GetAttribute("Stealing") or FUNHUB.debounce or _G.FUNHUB_SemiTP_Busy then return end
    FUNHUB.logT0 = os.clock()
    FUNHUB.log("---- STEAL NOW  podium " .. tostring(selectedSlot))
    local ok, why = FUNHUBUI.check(ignoreLock == true)
    if not ok then
        FUNHUB.log("refused: " .. tostring(why))
        FUNHUBUI.flash(why)
        return
    end
    if FUNHUB.debugEnabled() then
        task.spawn(function()
            local ch = player.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            local conns = {}
            local grabPos
            local function state()
                local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if not h then return "no root" end
                return string.format("moved %.1f  vel %.0f  tool=%s  busy=%s", grabPos and (h.Position - grabPos).Magnitude or 0,
                    h.AssemblyLinearVelocity.Magnitude, tool and tool.Name or "-", tostring(_G.FUNHUB_SemiTP_Busy))
            end
            conns[1] = player:GetAttributeChangedSignal("Stealing"):Connect(function()
                FUNHUB.log("Stealing -> " .. tostring(player:GetAttribute("Stealing")) .. "  " .. tostring(player:GetAttribute("StealingIndex") or ""))
                local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if player:GetAttribute("Stealing") and h and not grabPos then
                    grabPos = h.Position
                    local seen, tconns = {}, {}
                    for _, p in ipairs(player.Character:GetChildren()) do
                        if p:IsA("BasePart") then
                            tconns[#tconns + 1] = p.Touched:Connect(function(o)
                                if o:IsDescendantOf(player.Character) or seen[o] then return end
                                seen[o] = true
                                FUNHUB.log(string.format("  touched %s  (%s, collide=%s)", o:GetFullName():sub(-70),
                                    o.ClassName, tostring(o.CanCollide)))
                            end)
                        end
                    end
                    task.delay(2, function() for _, c in ipairs(tconns) do c:Disconnect() end end)
                    task.spawn(function()
                        for _ = 1, 15 do
                            task.wait(0.1)
                            FUNHUB.log("  after grab: " .. state())
                        end
                    end)
                end
            end)
            if hum then
                local lastHp = hum.Health
                conns[2] = hum:GetPropertyChangedSignal("Health"):Connect(function()
                    if hum.Health < lastHp - 1 then FUNHUB.log(string.format("HP %.0f -> %.0f  %s", lastHp, hum.Health, state())) end
                    lastHp = hum.Health
                end)
            end
            conns[3] = player.CharacterAdded:Connect(function() FUNHUB.log("RESPAWNED (died / reset)") end)
            local net = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
            net = net and net:FindFirstChild("Net")
            for _, n in ipairs({ "RE/NotificationService/Notify", "RE/StealService/StealingFailure",
                "RE/StealService/StealingSuccess", "RE/StealService/Grab", "RE/QuantumCloner/OnTeleport" }) do
                local re = net and net:FindFirstChild(n)
                if re then
                    conns[#conns + 1] = re.OnClientEvent:Connect(function(...)
                        local a = {}
                        for i, v in ipairs({ ... }) do
                            a[i] = typeof(v) == "Instance" and v:GetFullName():sub(-40) or tostring(v):sub(1, 60)
                        end
                        FUNHUB.log("  server " .. n:match("[^/]+/[^/]+$") .. ": " .. table.concat(a, " | "))
                    end)
                end
            end
            task.wait(10)
            for _, c in ipairs(conns) do c:Disconnect() end
            FUNHUB.log("---- log window closed  busy=" .. tostring(_G.FUNHUB_SemiTP_Busy))
        end)
    end
    -- Take ownership before carpet setup, including potion requests already waiting to equip.
    local semiToken = FUNHUB.beginSemiPause()
    local ragdollChip = FUNHUBUI.cfgChips and FUNHUBUI.cfgChips.antiRagdollEnabled
    if ragdollChip then pcall(ragdollChip, true) end
    FUNHUB.debounce = true
    FUNHUB.pressedAt = tick()
    task.spawn(function()
        local ok, err = pcall(function()
            if not FUNHUB_ALIVE() or player.Character ~= semiToken.character
                or not FUNHUBFx.semiPauses[semiToken] then return end
            setFFlags()
            FUNHUBUI.inputLock(true)
            if not FUNHUB_ALIVE() or player.Character ~= semiToken.character
                or not FUNHUBFx.semiPauses[semiToken] or _G.FUNHUB_SemiTP_ResetBusy then return end
            holdFlyGearUntilCarrying(semiToken.instantCarpet)
            if player.Character == semiToken.character and FUNHUBFx.semiPauses[semiToken] then
                FUNHUB.SSDoTeleport(semiToken)
            end
        end)
        pcall(stopFlyGear)
        pcall(FUNHUBUI.inputLock, false)
        if not ok then warn("[FUNHUB Semi TP] " .. tostring(err)) end
        FUNHUB.releaseSemiPause(semiToken)
        task.wait(0.6)
        if player.Character == semiToken.character then FUNHUB.debounce = false end
    end)
    return true -- Accepted; movement and pickup continue in the worker.
end

-- Auto TP On Allow: track friend panels and consume an allow only after a run starts.
FUNHUBUI.friendPrompts = {}
function FUNHUBUI.friendPromptState(prompt)
    local function text(value)
        return tostring(value or ""):gsub("<[^>]+>", ""):lower():gsub("%s+", " ")
    end
    local action, object, name = text(prompt.ActionText), text(prompt.ObjectText), text(prompt.Name)
    local function friends(value) return value:match("%f[%a]friends?%f[%A]") ~= nil end
    if not friends(action) and not friends(object)
        and not name:gsub("[%s_%-]", ""):find("allowfriends", 1, true) then return nil end
    local function state(value)
        if value:match("%f[%a]disallow%f[%A]") then return true end
        if value:match("%f[%a]allow%f[%A]") then return false end
        return nil
    end
    local allowed = state(action)
    if allowed == nil then allowed = state(object) end
    return allowed -- "Disallow" is the available action when friends are already allowed.
end

function FUNHUBUI.promptPart(desc)
    local parent = desc and desc.Parent
    if not parent then return nil end
    if parent:IsA("BasePart") then return parent end
    if parent:IsA("Attachment") then return parent:FindFirstAncestorWhichIsA("BasePart") end
    return parent:FindFirstChildWhichIsA("BasePart", true)
end

function FUNHUBUI.friendsState(plot)
    if not plot then return nil end
    local found = false
    for prompt in pairs(FUNHUBUI.friendPrompts) do
        local part = prompt.Parent and FUNHUBUI.promptPart(prompt)
        if part and part:IsDescendantOf(plot) then
            local allowed = FUNHUBUI.friendPromptState(prompt)
            if allowed == true then return true end
            if allowed == false then found = true end
        end
    end
    if found then return false end
    return nil -- A streamed-out panel is unknown, not a new disallow/allow cycle.
end
function FUNHUBUI.friendsAllowed(plot)
    return FUNHUBUI.friendsState(plot) == true
end

do
    local S = { Alive = true }
    FUNHUB.autoAllow = S
    local state, watched, links = {}, {}, {}
    function S.Reset() state = {} end
    local function unwatch(prompt)
        FUNHUBUI.friendPrompts[prompt] = nil
        local connections = watched[prompt]
        watched[prompt] = nil
        for _, connection in ipairs(connections or {}) do connection:Disconnect() end
    end
    function S.Shutdown()
        if not S.Alive then return end
        S.Alive = false
        S.Reset()
        for _, connection in ipairs(links) do connection:Disconnect() end
        for prompt in pairs(watched) do unwatch(prompt) end
    end
    local function consider(prompt)
        if not S.Alive or watched[prompt] or not prompt:IsA("ProximityPrompt") then return end
        local function check()
            if not S.Alive or not FUNHUB_ALIVE() then return end
            local allowed = FUNHUBUI.friendPromptState(prompt)
            FUNHUBUI.friendPrompts[prompt] = allowed ~= nil and true or nil
            -- Remember a disallow even during an active run or a brief target stream-out.
            if allowed == false and state.plot and FUNHUBUI.friendsState(state.plot) == false then
                state.triggered, state.retryAt = false, 0
            end
        end
        watched[prompt] = {
            prompt:GetPropertyChangedSignal("ObjectText"):Connect(check),
            prompt:GetPropertyChangedSignal("ActionText"):Connect(check),
            prompt:GetPropertyChangedSignal("Name"):Connect(check),
        }
        check()
    end
    links[1] = Workspace.DescendantAdded:Connect(consider)
    links[2] = Workspace.DescendantRemoving:Connect(unwatch)
    for _, descendant in ipairs(Workspace:GetDescendants()) do consider(descendant) end

    function S.Step()
        if not S.Alive or not FUNHUB_ALIVE() then return end
        if not FUNHUBFx.getSetting("autoTPOnAllow", false)
            or not FUNHUBFx.getSetting("semiInstant", false) then S.Reset() return end
        local character, mode = player.Character, FUNHUB.semiMode()
        if state.character ~= character or state.selection ~= targetPlot
            or state.slot ~= selectedSlot or state.mode ~= mode then
            state = { character = character, selection = targetPlot, slot = selectedSlot, mode = mode }
        end
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 or root.Anchored then return end
        -- Do not interrupt a manual run, a defender wait, a reset, or a potion equip.
        if FUNHUB.debounce or _G.FUNHUB_SemiTP_Busy or _G.FUNHUB_SemiTP_ResetBusy
            or FUNHUBUI.bypassWaiting or isStealBoostLive() or potionState.busy then return end
        local pod = findPodiumTarget(selectedSlot, root)
        if not pod then return end -- Preserve the latch while a target temporarily streams out.
        if state.plot ~= pod.plot or state.podium ~= pod.podium then
            state.plot, state.podium, state.triggered, state.retryAt = pod.plot, pod.podium, false, 0
        end
        local allowed = FUNHUBUI.friendsState(pod.plot)
        if allowed == false then state.triggered, state.retryAt = false, 0 end
        if allowed ~= true or state.triggered or os.clock() < (state.retryAt or 0) then return end
        local attempt = state
        attempt.retryAt = os.clock() + 0.6
        -- Both modes return true only after accepting a run. Missing tools/cooldowns can retry.
        local accepted = FUNHUB.execute()
        if accepted == true and state == attempt then attempt.triggered = true end
    end
    task.spawn(function()
        local nextWarning = 0
        while S.Alive and FUNHUB_ALIVE() do
            task.wait(0.2)
            local ok, err = pcall(S.Step)
            if not ok and os.clock() >= nextWarning then
                nextWarning = os.clock() + 5
                warn("[FUNHUB Auto TP On Allow] " .. tostring(err))
            end
        end
        S.Shutdown()
    end)
end
-- End Auto TP On Allow.


task.spawn(function()
    local wasLocked = setmetatable({}, { __mode = "k" })
    local pg = player:WaitForChild("PlayerGui")
    local lastUnlockCheck = 0
    local function checkUnlockText(obj)
        if not obj:IsA("TextLabel") and not obj:IsA("TextButton") then return end
        local txt = obj.Text and obj.Text:lower() or ""
        if (txt:find("successfully broke into") or txt:find("broke into")) and FUNHUBFx.getSetting("autoTPOnUnlock", false) then
            if tick() - lastUnlockCheck > 2 and not FUNHUB.debounce and not player:GetAttribute("Stealing") then
                lastUnlockCheck = tick()
                task.delay(0.1, function()
                    if not FUNHUB.debounce and not player:GetAttribute("Stealing") then
                        task.spawn(FUNHUB.execute)
                    end
                end)
            end
        end
    end
    pg.DescendantAdded:Connect(function(d)
        checkUnlockText(d)
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            d:GetPropertyChangedSignal("Text"):Connect(function() checkUnlockText(d) end)
        end
    end)
    for _, d in ipairs(pg:GetDescendants()) do
        checkUnlockText(d)
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            d:GetPropertyChangedSignal("Text"):Connect(function() checkUnlockText(d) end)
        end
    end
    while FUNHUB_ALIVE() do
        task.wait(0.2)
        if not FUNHUBFx.getSetting("autoTPOnUnlock", false) then continue end
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then continue end
        for _, plot in ipairs(plots:GetChildren()) do
            if isEnemyPlot(plot) then
                local locked = FUNHUBUI.lockInfo(plot)
                if wasLocked[plot] == true and not locked and not FUNHUB.debounce and not player:GetAttribute("Stealing") then
                    targetPlot = plot
                    task.spawn(FUNHUB.execute)
                end
                wasLocked[plot] = locked
            end
        end
    end
end)

function FUNHUB.stopCarpetForReset()
    FUNHUB.flightRevision = (FUNHUB.flightRevision or 0) + 1
    stopFlyGear()
    FUNHUBFx.carpet = false
    HubConfig.carpetSpeedEnabled = false
    HubConfig.funhub.carpetEquip = false
    if FUNHUBFx.motion then FUNHUBFx.motion.release() end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local bp = player:FindFirstChild("Backpack")
    if char and hum then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local lower = tool.Name:lower()
                local fly = HubConfig.flyTool ~= "Auto" and tool.Name == HubConfig.flyTool
                for _, key in ipairs(FLY_GEAR_KEYS) do if lower:find(key, 1, true) then fly = true break end end
                if fly then
                    pcall(function() tool:Deactivate() end)
                    if bp then tool.Parent = bp else hum:UnequipTools() end
                end
            end
        end
    end
    saveHubConfig()
end

do
    local _RunService = RunService
    local LP          = player

    _G.FUNHUB_SemiTP_ResetBusy = false
    _G.FUNHUB_SemiTP_AntiDieDisabled = nil

    _G.FUNHUB_SemiTP_InstaReset = function()
        local _now = os.clock()
        if _G.FUNHUB_SemiTP_ResetBusy
            and (_now - (tonumber(_G.FUNHUB_SemiTP_ResetAt) or 0))
                < (tonumber(_G.FUNHUB_SemiTP_ResetCooldown) or 2.5) then
            return
        end
        _G.FUNHUB_SemiTP_ResetBusy = true
        _G.FUNHUB_SemiTP_ResetAt   = _now
        if FUNHUB.grappleSemi then FUNHUB.grappleSemi.Cancel("Resetting character", false) end
        FUNHUB.stopCarpetForReset()

        task.spawn(function()
            local _prevAntiDie = _G.FUNHUB_SemiTP_AntiDieDisabled
            _G.FUNHUB_SemiTP_AntiDieDisabled = true
            _G.FUNHUB_SemiTP_StealHold  = false
            if _G.FUNHUB_SemiTP_SoftenAntiDie then pcall(_G.FUNHUB_SemiTP_SoftenAntiDie) end

            local _restored, _holding = false, true
            local function _restore()
                if _restored then return end
                _restored = true
                _holding  = false
                _G.FUNHUB_SemiTP_AntiDieDisabled  = nil
                _G.FUNHUB_SemiTP_ResetBusy = false
            end

            local _conn
            _conn = LP.CharacterAdded:Connect(function(newChar)
                if _conn then _conn:Disconnect(); _conn = nil end
                task.defer(function()
                    pcall(function() newChar:WaitForChild("Humanoid", 12) end)
                    _RunService.Heartbeat:Wait()
                    _restore()
                end)
            end)
            task.delay(8, function()
                if _conn then _conn:Disconnect(); _conn = nil end
                _restore()
            end)

            pcall(function()
                local char = LP.Character
                if not char then return end

                local _origChar = char

                local bp = LP:FindFirstChild("Backpack")
                if bp then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:UnequipTools() end) end
                    for _, ch in ipairs(char:GetChildren()) do
                        if ch:IsA("Tool") then
                            pcall(function() ch.Parent = bp end)
                        end
                    end
                end

                local function _flingPart()
                    local c = LP.Character
                    if not c then return nil end
                    return c:FindFirstChild("UpperTorso")
                        or c:FindFirstChild("Torso")
                        or c:FindFirstChild("HumanoidRootPart")
                end

                local _t0 = os.clock()
                while os.clock() - _t0
                    < (tonumber(_G.FUNHUB_SemiTP_ResetFlingTime) or 5) do
                    if LP.Character ~= _origChar then break end
                    local _h = _origChar:FindFirstChildOfClass("Humanoid")
                    if not _h or _h.Health <= 0
                        or _h:GetState() == Enum.HumanoidStateType.Dead then
                        break
                    end
                    local part = _flingPart()
                    if not part then break end

                    pcall(function()
                        for _, o in ipairs(part:GetChildren()) do
                            if o:IsA("BodyPosition") or o:IsA("BodyVelocity")
                                or o:IsA("BodyGyro") or o:IsA("AlignPosition")
                                or o:IsA("LinearVelocity") then
                                o:Destroy()
                            end
                        end
                    end)

                    pcall(function()
                        part.Velocity = Vector3.new(0, 9999999, 0)
                    end)
                    _RunService.Heartbeat:Wait()
                end
            end)
        end)
    end
end

local FUNHUBAntiRagdoll = {}
do
    local RS = ReplicatedStorage
    local LP = player

    local connections = {}
    local character, humanoid, rootPart, animator

    local function antiDieOff()
        return not AntiRagdollEnabled or _G.FUNHUB_SemiTP_AntiDieDisabled == true or _G.FUNHUB_SemiTP_ResetBusy == true
    end

    local function isFlyingCarpetActive()
        if not character then return false end
        if not character:FindFirstChildWhichIsA("Tool") then return false end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    return true
                end
            end
        end
        return false
    end

    local function isRagdolled()
        if not humanoid then return false end
        local state = humanoid:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
    end

    local controls
    local function enableControls()
        if not controls then
            local ps = LP:FindFirstChild("PlayerScripts")
            local PlayerModule = ps and ps:FindFirstChild("PlayerModule")
            if not PlayerModule then return end
            pcall(function() controls = require(PlayerModule):GetControls() end)
        end
        if controls then pcall(function() controls:Enable() end) end
    end

    local function cleanupRagdoll()
        if not character then return end
        local carpetEquipped = isFlyingCarpetActive()
        pcall(function()
            for _, obj in ipairs(character:GetChildren()) do
                if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                    or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                    obj:Destroy()
                elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    if not carpetEquipped then obj:Destroy() end
                elseif obj:IsA("Motor6D") then
                    obj.Enabled = true
                elseif obj:IsA("BasePart") then
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("Motor6D") then
                            child.Enabled = true
                        elseif child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") then
                            child:Destroy()
                        elseif child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
                            child:Destroy()
                        end
                    end
                end
            end
        end)
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                local animName = track.Animation and track.Animation.Name:lower() or ""
                if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                    track:Stop(0)
                end
            end
        end
    end

    local function harden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
    end

    local function soften(hum)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
        pcall(function() hum.BreakJointsOnDeath = true end)
        pcall(function() hum.RequiresNeck = true end)
    end

    local function revive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end

    local function clear()
        for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
        connections = {}
    end

    local function bind(signal, fn)
        local c
        c = signal:Connect(function(...)
            if not FUNHUB_ALIVE() then c:Disconnect() return end
            return fn(...)
        end)
        table.insert(connections, c)
    end

    local function setup()
        clear()
        if not AntiRagdollEnabled or not humanoid or not rootPart then return end
        local hum = humanoid

        if not antiDieOff() then harden(hum) end

        bind(hum:GetPropertyChangedSignal("Health"), function()
            if antiDieOff() then return end
            if hum.Parent and hum.Health <= 0 then revive(hum) end
        end)

        bind(hum.Died, function()
            if antiDieOff() then return end
            if hum.Parent then revive(hum) end
        end)

        local lastHarden = 0
        bind(RunService.Heartbeat, function()
            if not hum.Parent or antiDieOff() then return end
            local now = os.clock()
            if now - lastHarden >= 1.0 then lastHarden = now; harden(hum) end
            if hum.Health <= 0 then revive(hum) end
        end)

        local HOLD_GRACE = 0.35
        local holdPos, holdUntil, lastSafe = nil, 0, nil

        local function myRoot()
            local ch = LP.Character
            return ch and ch:FindFirstChild("HumanoidRootPart")
        end

        local function ragLeft()
            local t = LP:GetAttribute("RagdollEndTime")
            if type(t) ~= "number" then return 0 end
            return t - workspace:GetServerTimeNow()
        end

        local function lockOff()
            return _G.FUNHUB_SemiTP_ResetBusy == true
                or _G.FUNHUB_SemiTP_Busy == true
                or isFlyingCarpetActive()
        end

        local function hitNow()
            if lockOff() then return end
            local rp = myRoot()
            if not rp then return end
            holdUntil = math.max(holdUntil, os.clock() + HOLD_GRACE)
            if not holdPos then holdPos = lastSafe or rp.Position end
            pcall(function()
                rp.AssemblyLinearVelocity = Vector3.zero
                rp.AssemblyAngularVelocity = Vector3.zero
            end)
        end

        local function holding()
            return holdPos ~= nil and (os.clock() < holdUntil or ragLeft() > 0)
        end

        local function pin(rp, dt)
            if dt then
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    holdPos = holdPos + Vector3.new(md.X, 0, md.Z) * hum.WalkSpeed * dt
                end
            end
            local _, yaw = rp.CFrame:ToEulerAnglesYXZ()
            rp.CFrame = CFrame.new(holdPos) * CFrame.Angles(0, yaw, 0)
            rp.AssemblyLinearVelocity = Vector3.zero
            rp.AssemblyAngularVelocity = Vector3.zero
        end

        bind(hum.StateChanged, function()
            if isRagdolled() then
                hitNow()
                if not isFlyingCarpetActive() then hum:ChangeState(Enum.HumanoidStateType.Running) end
                cleanupRagdoll()
                workspace.CurrentCamera.CameraSubject = hum
                enableControls()
            end
        end)

        bind(LP:GetAttributeChangedSignal("RagdollEndTime"), function()
            if ragLeft() > 0 then
                hitNow()
                enableControls()
            end
        end)

        local net = RS:FindFirstChild("Packages")
        net = net and net:FindFirstChild("Net")
        for _, nm in ipairs({ "RE/CombatService/ApplyImpulse", "RE/Ragdoll" }) do
            local re = net and net:FindFirstChild(nm)
            if re and re:IsA("RemoteEvent") then
                bind(re.OnClientEvent, function() hitNow() end)
            end
        end

        bind(character.DescendantAdded, function()
            if isRagdolled() then cleanupRagdoll() end
        end)

        bind(RunService.PreSimulation, function()
            if not holdPos or lockOff() or not holding() then return end
            local rp = myRoot()
            if rp then pcall(pin, rp) end
        end)

        bind(RunService.Heartbeat, function(dt)
            local rp = myRoot()
            if not rp then return end
            if ragLeft() > 0 then
                enableControls()
                if not holdPos then hitNow() end
            end
            if isRagdolled() then cleanupRagdoll() end
            if holdPos then
                if lockOff() then
                    holdPos = nil
                elseif holding() then
                    pcall(pin, rp, dt)
                else
                    holdPos = nil
                    pcall(function()
                        rp.AssemblyLinearVelocity = Vector3.zero
                        rp.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
            else
                lastSafe = rp.Position
            end
        end)

        local CAM_BIND = "FUNHUBSemiTPCamLock"
        pcall(RunService.UnbindFromRenderStep, RunService, CAM_BIND)
        pcall(function()
            RunService:BindToRenderStep(CAM_BIND, Enum.RenderPriority.Camera.Value - 1, function()
                if _G.FUNHUB_SemiTP_ResetBusy == true then return end
                local cam = workspace.CurrentCamera
                local ch = LP.Character
                if not cam or not ch or not hum.Parent then return end
                local sub = cam.CameraSubject
                if sub ~= hum and typeof(sub) == "Instance" and sub:IsDescendantOf(ch) then
                    cam.CameraSubject = hum
                end
            end)
        end)
        table.insert(connections, {
            Disconnect = function() pcall(RunService.UnbindFromRenderStep, RunService, CAM_BIND) end,
        })

        enableControls()
        cleanupRagdoll()
    end

    local function attach(char)
        character = char
        humanoid = char:WaitForChild("Humanoid", 10)
        rootPart = char:WaitForChild("HumanoidRootPart", 10)
        animator = humanoid and humanoid:WaitForChild("Animator", 10)
    end

    _G.FUNHUB_SemiTP_SoftenAntiDie = function()
        if humanoid then soften(humanoid) end
    end

    function FUNHUBAntiRagdoll.set(on)
        AntiRagdollEnabled = on and true or false
        if AntiRagdollEnabled then
            setup()
        else
            clear()
            if humanoid then soften(humanoid) end
        end
    end

    local arCharConn
    arCharConn = LP.CharacterAdded:Connect(function(char)
        if not FUNHUB_ALIVE() then arCharConn:Disconnect() return end
        clear()
        character, humanoid, rootPart, animator = nil, nil, nil, nil
        local h = char:WaitForChild("Humanoid", 10)
        local r = char:WaitForChild("HumanoidRootPart", 10)
        if not h or not r then return end
        task.wait(0.2)
        attach(char)
        setup()
    end)

    if LP.Character then
        task.spawn(function()
            attach(LP.Character)
            setup()
        end)
    end
end

local FUNHUBAntiRocket = {}
do
    local LP = player
    local charConn
    local nextTick = 0

    local function off()
        local char = LP.Character
        local motion = FUNHUBFx.motion
        return not AntiRocketEnabled or _G.FUNHUB_SemiTP_ResetBusy == true
            or (char and motion and motion.flyTool(char) ~= nil and not isStealBoostLive())
    end

    local function strip(char)
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("VectorForce") then pcall(function() d:Destroy() end) end
        end
    end

    local function hookChar(char)
        if charConn then charConn:Disconnect() charConn = nil end
        if not char then return end
        strip(char)
        charConn = char.DescendantAdded:Connect(function(d)
            if off() or not d:IsA("VectorForce") then return end
            task.defer(function() pcall(function() d:Destroy() end) end)
        end)
    end

    local hbConn
    hbConn = RunService.Heartbeat:Connect(function()
        if not FUNHUB_ALIVE() then
            hbConn:Disconnect()
            if charConn then charConn:Disconnect() end
            return
        end
        if off() then return end
        local now = os.clock()
        if now < nextTick then return end
        nextTick = now + 0.1

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) then return end

        strip(char)
        if hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.PlatformStanding then
            hum.PlatformStand = false
            local v = hrp.AssemblyLinearVelocity
            if v.Y > 5 then
                hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
            end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)

    ;(function()
        local function off()
            return not (AntiRocketEnabled or AntiRagdollEnabled) or _G.FUNHUB_SemiTP_ResetBusy == true
        end
        local guardUntil, anchor = 0, nil
        local function arm()
            if off() then return end
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if os.clock() > guardUntil then anchor = hrp.Position end
            guardUntil = os.clock() + 8
        end
        FUNHUB.rocketArm = arm
        local lastFree = nil
        local function step()
            local ch = LP.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not (hrp and hum) then return end
            local busy = _G.FUNHUB_SemiTP_Busy == true or _G.FUNHUB_SemiTP_ResetBusy == true
            local motion = FUNHUBFx.motion
            if motion and motion.flyTool(ch) and not isStealBoostLive() then
                guardUntil, anchor = 0, nil
                return
            end
            local v = hrp.AssemblyLinearVelocity
            if os.clock() < guardUntil and anchor and not busy and not off() then
                hum.PlatformStand = false
                local flat = Vector3.new(v.X, 0, v.Z)
                if flat.Magnitude > hum.WalkSpeed + 4 then flat = flat.Unit * hum.WalkSpeed end
                hrp.AssemblyLinearVelocity = Vector3.new(flat.X, math.min(v.Y, 0), flat.Z)
                hrp.AssemblyAngularVelocity = Vector3.zero
                local p = hrp.Position
                anchor = Vector3.new(p.X, anchor.Y, p.Z)
                if p.Y - anchor.Y > 3 then
                    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
                    hrp.CFrame = CFrame.new(anchor) * CFrame.Angles(0, yaw, 0)
                end
                return
            end
            if not busy and not off() and (Vector3.new(v.X, 0, v.Z).Magnitude > 150 or v.Y > 120)
                and not ch:FindFirstChildOfClass("Tool") then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                if lastFree then hrp.CFrame = lastFree end
                return
            end
            if v.Magnitude < 60 and hum.FloorMaterial ~= Enum.Material.Air then lastFree = hrp.CFrame end
        end
        local c1, c2, c3
        c1 = RunService.PreSimulation:Connect(function()
            if not FUNHUB_ALIVE() then c1:Disconnect() c2:Disconnect() c3:Disconnect() return end
            step()
        end)
        c2 = RunService.Heartbeat:Connect(step)
        local FX = { ParticleEmitter = true, Fire = true, Smoke = true, Sparkles = true, Trail = true, Beam = true, Sound = true }
        local function hideFx(d)
            pcall(function()
                if d:IsA("Sound") then d.Volume = 0; d:Stop() else d.Enabled = false end
            end)
        end
        c3 = Workspace.DescendantAdded:Connect(function(d)
            local ch = LP.Character
            if d:IsA("Explosion") then
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if hrp and not off() and (d.Position - hrp.Position).Magnitude <= math.max(d.BlastRadius, 12) + 6 then
                    arm()
                    pcall(function() d.BlastPressure = 0; d.DestroyJointRadiusPercent = 0; d.Visible = false end)
                end
            elseif ch and d:IsDescendantOf(ch) then
                if d:IsA("VectorForce") then
                    arm()
                    if not off() and not _G.FUNHUB_SemiTP_Busy then task.defer(function() pcall(function() d:Destroy() end) end) end
                elseif FX[d.ClassName] and os.clock() < guardUntil and not off() then
                    hideFx(d)
                end
            end
        end)
    end)()

    local rcCharConn
    rcCharConn = LP.CharacterAdded:Connect(function(char)
        if not FUNHUB_ALIVE() then rcCharConn:Disconnect() return end
        char:WaitForChild("HumanoidRootPart", 10)
        hookChar(char)
    end)
    if LP.Character then task.spawn(hookChar, LP.Character) end

    local VICTIMS = { "jumpscare", "balloon", "inverse", "nightvision" }
    local cmds = ReplicatedStorage:FindFirstChild("Datas")
    cmds = cmds and cmds:FindFirstChild("AdminCommands")
    for _, name in ipairs(VICTIMS) do
        pcall(function()
            local m = require(cmds[name])
            if type(m.effects) == "table" and type(m.effects.Victim) == "function" then
                local orig = rawget(m.effects, "__semiOrigVictim") or m.effects.Victim
                m.effects.__semiOrigVictim = orig
                m.effects.Victim = function(...)
                    if AntiRocketEnabled then return end
                    return orig(...)
                end
            end
        end)
    end

    local charCtrl
    pcall(function() charCtrl = require(ReplicatedStorage.Controllers.CharacterController) end)
    local adminConn, adminNext = nil, 0
    adminConn = RunService.Heartbeat:Connect(function()
        if not FUNHUB_ALIVE() then adminConn:Disconnect() return end
        if off() or os.clock() < adminNext then return end
        adminNext = os.clock() + 0.1
        if charCtrl and charCtrl.Controls and charCtrl.originalMoveFunction
            and charCtrl.Controls.moveFunction ~= charCtrl.originalMoveFunction then
            charCtrl.Controls.moveFunction = charCtrl.originalMoveFunction
        end
        if Workspace.Gravity < 150 then Workspace.Gravity = 196.2 end
        local char = LP.Character
        if char then
            for _, m in ipairs(char:GetChildren()) do
                if m:IsA("Model") then
                    for _, p in ipairs(m:GetDescendants()) do
                        if (p:IsA("BasePart") or p:IsA("Decal")) and p.LocalTransparencyModifier ~= 1 then
                            p.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end)

    function FUNHUBAntiRocket.set(on)
        AntiRocketEnabled = on and true or false
        if AntiRocketEnabled and LP.Character then strip(LP.Character) end
    end
end

local FUNHUBAntiFx = {}
do
    local LP = player
    local Lighting = game:GetService("Lighting")
    local net = ReplicatedStorage:FindFirstChild("Packages")
    net = net and net:FindFirstChild("Net")

    local charCtrl, camCtrl
    pcall(function() charCtrl = require(ReplicatedStorage.Controllers.CharacterController) end)
    pcall(function() camCtrl = require(ReplicatedStorage.Controllers.CameraController) end)
    local boomSound = ReplicatedStorage.Controllers:FindFirstChild("ItemController")
    boomSound = boomSound and boomSound:FindFirstChild("BoogieBombController")
    boomSound = boomSound and boomSound:FindFirstChild("BOOM")

    local function defaultFov()
        local ok, f = pcall(function() return camCtrl:GetDefaultFov() end)
        return ok and tonumber(f) or 70
    end

    local FX_SRC = { BeeLauncherController = "bee", BoogieBombController = "disco", PaintballGunController = "paint" }
    local fxConns, fxRemote = {}, nil

    local function scanRemote(r, into)
        local ok, cons = pcall(getconnections, r.OnClientEvent)
        if not ok or type(cons) ~= "table" then return end
        for _, c in ipairs(cons) do
            local fn = c.Function
            if type(fn) == "function" then
                local okS, src = pcall(debug.info, fn, "s")
                local kind = okS and FX_SRC[tostring(src):match("([^%.]+)$") or ""]
                if kind then
                    fxRemote = r
                    into[#into + 1] = { c = c, kind = kind }
                end
            end
        end
    end

    local function scanFx()
        if not net or type(getconnections) ~= "function" then return end
        local found = {}
        if fxRemote and fxRemote.Parent then
            scanRemote(fxRemote, found)
        else
            for _, r in ipairs(net:GetChildren()) do
                if r:IsA("RemoteEvent") then scanRemote(r, found) end
            end
        end
        fxConns = found
    end

    local function applyMute()
        for _, e in ipairs(fxConns) do
            local mute = FUNHUBFx[e.kind]
            pcall(function() if mute then e.c:Disable() else e.c:Enable() end end)
        end
    end

    pcall(scanFx)
    applyMute()

    pcall(function()
        local presets = require(ReplicatedStorage.Shared.ShakePresets)
        local orig = rawget(presets, "__semiOrigBind") or presets.BindShakeToCamera
        presets.__semiOrigBind = orig
        presets.BindShakeToCamera = function(...)
            if FUNHUBFx.disco then
                local ok, src = pcall(debug.info, 2, "s")
                if ok and tostring(src):find("BoogieBombController", 1, true) then
                    return function() end
                end
            end
            return orig(...)
        end
    end)

    local function undoBee()
        if charCtrl and charCtrl.Controls and charCtrl.originalMoveFunction then
            charCtrl.Controls.moveFunction = charCtrl.originalMoveFunction
        end
        for _, e in ipairs(Lighting:GetChildren()) do
            if e.Name == "BeeBlur" or (e:IsA("ColorCorrectionEffect") and e.Name == "ColorCorrection") then e:Destroy() end
        end
        local cam = Workspace.CurrentCamera
        if cam then cam.FieldOfView = 70 end
    end

    local discoUntil = 0
    local function discoOn() return FUNHUBFx.disco and os.clock() < discoUntil end

    local function undoDisco()
        for _, e in ipairs(Lighting:GetChildren()) do
            if e.Name == "DiscoEffect" or (e:IsA("BlurEffect") and e.Name == "Blur") then e:Destroy() end
        end
        local cc = Lighting:FindFirstChild("ColorCCorrection")
        if cc then cc.Enabled = true end
        if boomSound and boomSound.IsPlaying then boomSound:Stop() end
    end

    local function onUseItem(kind)
        if kind == "Bee Attack" and FUNHUBFx.bee then
            task.defer(undoBee)
            task.delay(0.1, undoBee)
        elseif kind == "Boogie" and FUNHUBFx.disco then
            discoUntil = os.clock() + 10.5
            undoDisco()
            task.defer(undoDisco)
        end
    end

    local hooked = {}
    local function hookRemote(r)
        if not r or hooked[r] then return end
        hooked[r] = true
        local conn
        conn = r.OnClientEvent:Connect(function(kind)
            if not FUNHUB_ALIVE() then conn:Disconnect() return end
            onUseItem(kind)
        end)
    end
    hookRemote(fxRemote)
    hookRemote(net and net:FindFirstChild("RE/UseItem"))

    task.spawn(function()
        while FUNHUB_ALIVE() do
            task.wait(10)
            pcall(scanFx)
            applyMute()
            hookRemote(fxRemote)
        end
    end)

    do
        local lConn
        lConn = Lighting.ChildAdded:Connect(function(e)
            if not FUNHUB_ALIVE() then lConn:Disconnect() return end
            if discoOn() and (e.Name == "DiscoEffect" or (e:IsA("BlurEffect") and e.Name == "Blur")) then
                task.defer(undoDisco)
            end
        end)

        local BIND = "FUNHUBSemiTPAntiDisco"
        pcall(RunService.UnbindFromRenderStep, RunService, BIND)
        RunService:BindToRenderStep(BIND, Enum.RenderPriority.Last.Value, function()
            if not FUNHUB_ALIVE() then pcall(RunService.UnbindFromRenderStep, RunService, BIND) return end
            if not discoOn() then return end
            local cam = Workspace.CurrentCamera
            if cam then cam.FieldOfView = defaultFov() end
            if boomSound and boomSound.IsPlaying then boomSound:Stop() end
        end)
    end

    local function unGummy()
        if not FUNHUBFx.gummy then return end
        if LP:GetAttribute("BlockTools") then LP:SetAttribute("BlockTools", false) end
        local ch = LP.Character
        if ch and ch:GetAttribute("BackpackReady") == false then ch:SetAttribute("BackpackReady", true) end
        local g = Workspace:FindFirstChild("GummyBear")
        if g then pcall(function() g:Destroy() end) end
    end

    local gConn1, gConn2
    gConn1 = LP:GetAttributeChangedSignal("BlockTools"):Connect(function()
        if not FUNHUB_ALIVE() then gConn1:Disconnect() return end
        unGummy()
    end)
    gConn2 = Workspace.ChildAdded:Connect(function(c)
        if not FUNHUB_ALIVE() then gConn2:Disconnect() return end
        if c.Name == "GummyBear" and FUNHUBFx.gummy then task.defer(unGummy) end
    end)

    function FUNHUBAntiFx.setBee(on) FUNHUBFx.bee = on and true or false; applyMute() end
    function FUNHUBAntiFx.setDisco(on) FUNHUBFx.disco = on and true or false; applyMute() end
    function FUNHUBAntiFx.setGummy(on) FUNHUBFx.gummy = on and true or false; unGummy() end
    function FUNHUBAntiFx.setPaint(on) FUNHUBFx.paint = on and true or false; applyMute() end
    function FUNHUBAntiFx.useRemote() return fxRemote end
    FUNHUB.fx = FUNHUBFx
    FUNHUB.cfg = HubConfig
    FUNHUB.antiDiscoTest = function() discoUntil = os.clock() + 10.5; undoDisco() end
    FUNHUB.antiFxState = function()
        local s = {}
        for _, e in ipairs(fxConns) do s[#s + 1] = e.kind .. "=" .. tostring(e.c.Enabled) end
        return (fxRemote and fxRemote.Name or "none"), s
    end
end

do
    local LP = player

    local webUsedAt = 0
    local function unWebOnce(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) then return end
        if LP:GetAttribute("Web") then LP:SetAttribute("Web", false) end
        if char:GetAttribute("Web") then char:SetAttribute("Web", false) end
        if LP:GetAttribute("BlockTools") then LP:SetAttribute("BlockTools", false) end
        local attach = hrp:FindFirstChild("WebTargetAttch")
        if attach then attach:Destroy() end
        local cut = 0
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local ok, joints = pcall(part.GetJoints, part)
                for _, j in ipairs(ok and joints or {}) do
                    if not j:IsA("Motor6D") and not j:IsA("AnimationConstraint") then
                        local a, b
                        if j:IsA("Constraint") then
                            a = j.Attachment0 and j.Attachment0.Parent
                            b = j.Attachment1 and j.Attachment1.Parent
                        else
                            a, b = j.Part0, j.Part1
                        end
                        local out = (a and not a:IsDescendantOf(char)) or (b and not b:IsDescendantOf(char))
                            or not j:IsDescendantOf(char)
                        if out then cut = cut + 1 pcall(j.Destroy, j) end
                    end
                end
            elseif (part:IsA("RopeConstraint") or part:IsA("SpringConstraint")) then
                cut = cut + 1
                pcall(part.Destroy, part)
            end
        end
        local gb = Workspace:FindFirstChild("GummyBear")
        if gb and (gb.Position - hrp.Position).Magnitude < 12 then pcall(gb.Destroy, gb) end
        if hum.PlatformStand then hum.PlatformStand = false end
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Physics or s == Enum.HumanoidStateType.PlatformStanding
            or s == Enum.HumanoidStateType.FallingDown then
            pcall(hum.ChangeState, hum, Enum.HumanoidStateType.GettingUp)
        end
        return cut
    end

    local webbing = false
    local function unWeb(char)
        if not FUNHUBFx.web or not char or webbing then return end
        if os.clock() - webUsedAt < 1.5 then return end
        webbing = true
        local t0, cuts = os.clock(), 0
        while FUNHUB_ALIVE() and os.clock() - t0 < 6 do
            local c = unWebOnce(char) or 0
            cuts = cuts + c
            local w = LP:GetAttribute("Web") or char:GetAttribute("Web")
            if not (w or c > 0) and os.clock() - t0 > 0.5 then break end
            RunService.Heartbeat:Wait()
        end
        webbing = false
        pcall(function() FUNHUB.log(string.format("ANTI WEBSLING: freed  (%d links cut, %.2fs)", cuts, os.clock() - t0)) end)
    end

    local function webHit(src)
        local v = src:GetAttribute("Web")
        if v ~= nil and v ~= false then task.spawn(unWeb, LP.Character) end
    end

    local webConns = {}
    local function hookWeb(char)
        for _, c in ipairs(webConns) do c:Disconnect() end
        webConns = { LP:GetAttributeChangedSignal("Web"):Connect(function() webHit(LP) end) }
        if char then
            table.insert(webConns, char:GetAttributeChangedSignal("Web"):Connect(function() webHit(char) end))
            local function ownTool(c)
                if c:IsA("Tool") and c.Name == "Web Slinger" then
                    table.insert(webConns, c.Activated:Connect(function() webUsedAt = os.clock() end))
                end
            end
            table.insert(webConns, char.ChildAdded:Connect(ownTool))
            local own = char:FindFirstChild("Web Slinger")
            if own then ownTool(own) end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                table.insert(webConns, hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
                    if hum.PlatformStand and (LP:GetAttribute("Web") or LP:GetAttribute("BlockTools")) then
                        task.spawn(unWeb, char)
                    end
                end))
            end
        end
    end
    hookWeb(LP.Character)
    local webCharConn
    webCharConn = LP.CharacterAdded:Connect(function(char)
        if not FUNHUB_ALIVE() then
            webCharConn:Disconnect()
            for _, c in ipairs(webConns) do c:Disconnect() end
            return
        end
        hookWeb(char)
    end)

    local SWAP_POTION = "Body Swap Potion"
    local threat, prevOthers, prevSelf, lastCounter = {}, {}, nil, 0

    local function myPotion()
        local ch, bp = LP.Character, LP:FindFirstChild("Backpack")
        return (ch and ch:FindFirstChild(SWAP_POTION)) or (bp and bp:FindFirstChild(SWAP_POTION))
    end

    local function swapBack(target, home)
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local potion = myPotion()
        local remote = FUNHUBAntiFx.useRemote()
        if not (hum and potion and remote) or potion:GetAttribute("CooldownTime") then
            FUNHUB.log(string.format("SWAPPED by %s but can't swap back (potion=%s remote=%s cooldown=%s)",
                target.Name, tostring(potion ~= nil), tostring(remote ~= nil),
                tostring(potion and potion:GetAttribute("CooldownTime"))))
            return
        end
        local homePrompt = home and FUNHUB.enemyPromptAt and FUNHUB.enemyPromptAt(home)
        local homeCtx = homePrompt and FUNHUBHold.startStealHold(homePrompt)
        FUNHUB.logT0 = os.clock()
        FUNHUB.log(string.format("---- SWAPPED by %s  home podium=%s  enabled=%s  hold banked=%s",
            target.Name, homePrompt and homePrompt:GetFullName():match("AnimalPodiums%.(%d+)") or "none",
            tostring(homePrompt and homePrompt.Enabled), tostring(homeCtx ~= nil and homeCtx ~= false)))
        local held = ch:FindFirstChildOfClass("Tool")
        pcall(function() hum:EquipTool(potion) end)
        local t0 = os.clock()
        while potion.Parent ~= ch and os.clock() - t0 < 0.5 do task.wait() end
        if potion.Parent == ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            local from = hrp and hrp.Position
            pcall(function() remote:FireServer(target) end)
            task.spawn(function()
                local t0 = os.clock()
                while hrp and hrp.Parent and from and (hrp.Position - from).Magnitude < 3 and os.clock() - t0 < 1.5 do
                    RunService.Heartbeat:Wait()
                end
                local moved = hrp and from and (hrp.Position - from).Magnitude or -1
                FUNHUB.log(string.format("swap-back landed=%s (moved %.1f)  off home %.1f  hold age %.2fs  prompt enabled=%s",
                    tostring(moved >= 3), moved, (hrp and home) and (hrp.Position - home).Magnitude or -1,
                    homeCtx and tick() - (homeCtx.holdBeganAt or 0) or -1, tostring(homePrompt and homePrompt.Enabled)))
                local lt = os.clock()
                local got = FUNHUB.grabUnderFeet and FUNHUB.grabUnderFeet(8, homePrompt, homeCtx or nil)
                FUNHUB.log(string.format("%s %.2fs after landing  (prompt enabled now=%s)", got and "GRABBED" or "NO GRAB",
                    os.clock() - lt, tostring(homePrompt and homePrompt.Enabled)))
            end)
        end
        task.wait(0.3)
        if held and held ~= potion and held.Parent then
            pcall(function() hum:EquipTool(held) end)
        else
            pcall(function() hum:UnequipTools() end)
        end
    end

    local swapConn, swapNext = nil, 0
    swapConn = RunService.Heartbeat:Connect(function()
        if not FUNHUB_ALIVE() then swapConn:Disconnect() return end
        local hrp = FUNHUBFx.swap and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if prevSelf then prevSelf = nil; table.clear(prevOthers) end
            return
        end
        local now = tick()
        if now < swapNext then return end
        swapNext = now + 0.05
        local me = hrp.Position
        local others = {}
        for _, p in ipairs(Players:GetPlayers()) do
            local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                others[p] = r.Position
                local tool = p.Character:FindFirstChildOfClass("Tool")
                if tool and tool.Name == SWAP_POTION then threat[p] = now end
            end
        end
        if prevSelf and (me - prevSelf).Magnitude >= 3 and now - lastCounter >= 2 and not _G.FUNHUB_SemiTP_Busy then
            for p, was in pairs(prevOthers) do
                local nowPos = others[p]
                if nowPos and (me - was).Magnitude <= 6 and (nowPos - prevSelf).Magnitude <= 6
                    and threat[p] and now - threat[p] <= 6 then
                    lastCounter = now
                    threat[p] = nil
                    task.spawn(swapBack, p, prevSelf)
                    break
                end
            end
        end
        prevSelf, prevOthers = me, others
    end)

    local held = false
    local function hop()
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower or 50, hrp.Velocity.Z)
    end
    local jumpConns = {}
    jumpConns[1] = UserInputService.JumpRequest:Connect(function()
        if FUNHUBFx.infJump then hop() end
    end)
    jumpConns[2] = UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.Space then held = true end
    end)
    jumpConns[3] = UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space then held = false end
    end)
    jumpConns[4] = RunService.Heartbeat:Connect(function()
        if not FUNHUB_ALIVE() then
            for _, c in ipairs(jumpConns) do c:Disconnect() end
            return
        end
        if held and FUNHUBFx.infJump then hop() end
    end)

    local function unJumpKill(ch)
        if type(getconnections) ~= "function" then return end
        local hum = ch and ch:WaitForChild("Humanoid", 10)
        if not hum then return end
        for _ = 1, 20 do
            local found = false
            for _, c in ipairs(getconnections(hum.StateChanged)) do
                local f = c.Function
                local src = type(f) == "function" and (debug.info(f, "s") or "") or ""
                if src:find("CharacterController", 1, true) then
                    found = true
                    pcall(function() c:Disable() end)
                end
            end
            if found then
                pcall(function() FUNHUB.log("jump-count kill switched off") end)
                return
            end
            task.wait(0.25)
        end
    end
    task.spawn(unJumpKill, LP.Character)
    table.insert(jumpConns, LP.CharacterAdded:Connect(function(ch) task.spawn(unJumpKill, ch) end))

    function FUNHUBAntiFx.setWeb(on) FUNHUBFx.web = on and true or false; if FUNHUBFx.web then unWeb(LP.Character) end end
    function FUNHUBAntiFx.setSwap(on) FUNHUBFx.swap = on and true or false end
    function FUNHUBAntiFx.setInfJump(on) FUNHUBFx.infJump = on and true or false end
end

do
    local LP = player

    local function canFight()
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) or hum.Health <= 0 then return nil end
        if LP:GetAttribute("Stealing") or _G.FUNHUB_SemiTP_Busy then return nil end
        return ch, hum, hrp
    end

    local function swing(ch, hum)
        local bat = ch:FindFirstChild("Bat") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Bat"))
        if not bat then return false end
        if bat.Parent ~= ch then pcall(function() hum:EquipTool(bat) end) end
        if bat.Parent == ch and bat.Enabled ~= false then pcall(function() bat:Activate() end) end
        return true
    end

    local function enemySentry(p)
        if not p:IsA("BasePart") then return false end
        local id = p.Name:match("^Sentry_(%d+)$") or p.Name:match("^SentryCandy_(%d+)$")
        return id ~= nil and id ~= tostring(LP.UserId)
    end

    local function enemyDoge(m)
        if not m:IsA("Model") then return false end
        local who = m.Name:match("^PlayerName_(.+)_Doge$")
        if not who or who == LP.Name or who == LP.DisplayName then return false end
        local h = m:FindFirstChildOfClass("Humanoid")
        return h ~= nil and h.Health > 0
    end

    local busyDefence = false
    local function breakIt(obj, isDoge)
        if busyDefence then return end
        busyDefence = true
        task.spawn(function()
            local limit = os.clock() + (isDoge and 10 or 3)
            while FUNHUB_ALIVE() and obj.Parent and os.clock() < limit do
                if isDoge and not (FUNHUBFx.doge and enemyDoge(obj)) then break end
                if not isDoge and not FUNHUBFx.sentry then break end
                local ch, hum, hrp = canFight()
                if not ch then break end
                local part = isDoge and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if not part or (part.Position - hrp.Position).Magnitude > 220 then break end
                local look = hrp.CFrame.LookVector
                local spot = hrp.Position + look * 4 + Vector3.new(0, isDoge and 0 or 1.2, 0)
                pcall(function()
                    for _, d in ipairs((isDoge and obj or part):GetDescendants()) do
                        if d:IsA("BasePart") then d.CanCollide = false end
                    end
                    part.CanCollide = false
                    part.AssemblyLinearVelocity = Vector3.zero
                    if isDoge then obj:PivotTo(CFrame.lookAt(spot, spot + look)) else part.CFrame = CFrame.lookAt(spot, spot + look) end
                end)
                if not swing(ch, hum) then break end
                task.wait(isDoge and 0.1 or 0.12)
            end
            busyDefence = false
        end)
    end

    local function scanDefences()
        for _, c in ipairs(Workspace:GetChildren()) do
            if FUNHUBFx.sentry and enemySentry(c) then breakIt(c, false)
            elseif FUNHUBFx.doge and enemyDoge(c) then breakIt(c, true) end
        end
    end
    local defConn
    defConn = Workspace.ChildAdded:Connect(function(c)
        if not FUNHUB_ALIVE() then defConn:Disconnect() return end
        task.delay(0.3, function()
            if FUNHUBFx.sentry and enemySentry(c) then breakIt(c, false)
            elseif FUNHUBFx.doge and enemyDoge(c) then breakIt(c, true) end
        end)
    end)
    task.spawn(function()
        while FUNHUB_ALIVE() do
            if FUNHUBFx.sentry or FUNHUBFx.doge then pcall(scanDefences) end
            task.wait(1)
        end
    end)

    local AIM_ITEMS = {}
    for _, n in ipairs({ "Blackhole Bomb", "BlowDryer", "Candy Launcher", "Candycane Bow", "Christmas Launcher",
        "Freeze Ray", "Gravity Gun", "Hunter Crossbow", "Jelly Gun", "Laser Cape", "Lava Blaster", "Paintball Gun",
        "Pumpkin Launcher", "Radioactive Airstrike", "Sabuk Bepak", "Sandal Jepit", "Slingshot", "Snowball",
        "Snowball Cannon", "Summer Soaker", "Super-GLS33", "Taser Gun", "Tripple Plungers", "Web Slinger",
        "Wormhole Tunneler", "Zombie Blaster" }) do AIM_ITEMS[n] = true end
    local mouse
    pcall(function() mouse = require(ReplicatedStorage.Packages.PlayerMouse) end)
    local aimAt, lastScan, lastShot = nil, 0, 0
    local function aimStep()
        if not (FUNHUBFx.aim and mouse) then aimAt = nil return end
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local tool = ch and ch:FindFirstChildOfClass("Tool")
        if not (hrp and tool and AIM_ITEMS[tool.Name]) then aimAt = nil return end
        if not aimAt or not aimAt.Parent or os.clock() - lastScan >= 0.05 then
            lastScan = os.clock()
            local best, bestD = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local h = r and p.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (r.Position - hrp.Position).Magnitude
                    if d < bestD then best, bestD = r, d end
                end
            end
            aimAt = best
        end
        if aimAt then
            pcall(function() mouse.Hit = CFrame.new(aimAt.Position); mouse.Target = aimAt end)
            if FUNHUBFx.spam and os.clock() - lastShot >= 0.1 then
                lastShot = os.clock()
                pcall(function() tool:Activate() end)
            end
        end
    end
    local aimConn1, aimConn2
    aimConn1 = RunService.Heartbeat:Connect(function()
        if not FUNHUB_ALIVE() then aimConn1:Disconnect() return end
        aimStep()
    end)
    aimConn2 = (RunService.PreRender or RunService.RenderStepped):Connect(function()
        if not FUNHUB_ALIVE() then aimConn2:Disconnect() return end
        if aimAt and aimAt.Parent and mouse then
            pcall(function() mouse.Hit = CFrame.new(aimAt.Position); mouse.Target = aimAt end)
        end
    end)

    pcall(function()
        for _, d in ipairs(Workspace:GetChildren()) do
            if d.Name == "FUNHUB_SemiTP_ServerGhost" then d:Destroy() end
        end
    end)
    local ghost = Instance.new("Model")
    ghost.Name = "FUNHUB_SemiTP_ServerGhost"
    local ghostHl = Instance.new("Highlight")
    ghostHl.FillColor = T.FILL2
    ghostHl.FillTransparency = 0.82
    ghostHl.OutlineColor = T.FILL2
    ghostHl.OutlineTransparency = 0
    ghostHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    ghostHl.Adornee = ghost
    ghostHl.Parent = ghost
    local ghostSrc, ghostParts, ghostCFs, ghostChar, ghostDirty = {}, {}, {}, nil, true
    local anchorPart, charConns = nil, {}
    local KEEP = { SpecialMesh = true, Decal = true, SurfaceAppearance = true }
    local function buildGhost(char)
        for _, p in ipairs(ghostParts) do p:Destroy() end
        for _, c in ipairs(charConns) do c:Disconnect() end
        table.clear(ghostSrc); table.clear(ghostParts); table.clear(ghostCFs); table.clear(charConns)
        ghostChar, ghostDirty, anchorPart = char, false, nil
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, src in ipairs(char:GetDescendants()) do
            if src:IsA("BasePart") and src ~= hrp and src.Transparency < 1 and not src:FindFirstAncestorOfClass("Tool") then
                local arch = src.Archivable
                src.Archivable = true
                local ok, p = pcall(function() return src:Clone() end)
                src.Archivable = arch
                if ok and p then
                    for _, d in ipairs(p:GetChildren()) do
                        if not KEEP[d.ClassName] then d:Destroy() end
                    end
                    p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
                    p.Massless = true
                    p.Transparency = math.max(src.Transparency, 0.72)
                    p.Parent = ghost
                    ghostSrc[#ghostSrc + 1] = src
                    ghostParts[#ghostParts + 1] = p
                    ghostCFs[#ghostCFs + 1] = src.CFrame
                    if src.Name == "Head" then anchorPart = p end
                end
            end
        end
        anchorPart = anchorPart or ghostParts[1]
        local function mark(d)
            if d:IsA("BasePart") and not d:FindFirstAncestorOfClass("Tool") then ghostDirty = true end
        end
        charConns[1] = char.DescendantAdded:Connect(mark)
        charConns[2] = char.DescendantRemoving:Connect(mark)
    end

    local ghostTag = Instance.new("BillboardGui")
    ghostTag.Size = UDim2.fromOffset(150, 30)
    ghostTag.StudsOffset = Vector3.new(0, 2.6, 0)
    ghostTag.AlwaysOnTop = true
    ghostTag.LightInfluence = 0
    ghostTag.MaxDistance = 100000
    ghostTag.Parent = ghost
    local tagPill = Instance.new("Frame")
    tagPill.Size = UDim2.fromScale(1, 1)
    tagPill.BackgroundColor3 = T.BG
    tagPill.BorderSizePixel = 0
    tagPill.Parent = ghostTag
    corner(tagPill, 15)
    local tagStroke = stroke(tagPill, T.ACCENT, 2, 0.1)
    gradient(tagPill, T.SURF2, T.BG, 90)
    local ghostLbl = Instance.new("TextLabel")
    ghostLbl.Size = UDim2.new(1, -12, 1, 0)
    ghostLbl.Position = UDim2.fromOffset(6, 0)
    ghostLbl.BackgroundTransparency = 1
    ghostLbl.Font = Enum.Font.GothamBlack
    ghostLbl.TextSize = 13
    ghostLbl.TextColor3 = T.TEXT
    ghostLbl.TextStrokeTransparency = 0.6
    ghostLbl.Parent = tagPill
    local COL_OK, COL_WARN, COL_BAD = Color3.fromRGB(110, 235, 160), Color3.fromRGB(255, 205, 90), Color3.fromRGB(255, 110, 130)
    local trail, ping, lastPingRead, lastTagMs = {}, 0.05, 0, -1
    local recConn, drawConn
    recConn = RunService.Heartbeat:Connect(function()
        if not FUNHUB_ALIVE() then recConn:Disconnect() return end
        local hrp = FUNHUBFx.ghost and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then if #trail > 0 then table.clear(trail) end return end
        local now = os.clock()
        local pose = {}
        if LP.Character == ghostChar then
            local rootCF = hrp.CFrame
            for i, src in ipairs(ghostSrc) do pose[i] = rootCF:ToObjectSpace(src.CFrame) end
        end
        trail[#trail + 1] = { t = now, cf = hrp.CFrame, pose = pose }
        while #trail > 2 and now - trail[1].t > 1.5 do table.remove(trail, 1) end
        if now - lastPingRead > 0.5 then
            lastPingRead = now
            pcall(function() ping = LP:GetNetworkPing() end)
        end
    end)
    drawConn = (RunService.PreRender or RunService.RenderStepped):Connect(function()
        if not FUNHUB_ALIVE() then
            drawConn:Disconnect()
            for _, c in ipairs(charConns) do c:Disconnect() end
            ghost:Destroy()
            return
        end
        if not FUNHUBFx.ghost or #trail == 0 then
            if ghost.Parent then ghost.Parent = nil end
            return
        end
        local at = os.clock() - (ping + 1 / 60)
        local cf = trail[1].cf
        local sa, sb, alpha = trail[1], trail[1], 0
        for i = #trail, 2, -1 do
            local a, b = trail[i - 1], trail[i]
            if a.t <= at then
                local span = b.t - a.t
                alpha = span > 0 and math.clamp((at - a.t) / span, 0, 1) or 1
                cf = a.cf:Lerp(b.cf, alpha)
                sa, sb = a, b
                break
            end
        end
        local char = LP.Character
        if char ~= ghostChar or ghostDirty or #ghostParts == 0 then
            buildGhost(char)
            table.clear(trail)
            return
        end
        if #ghostParts == 0 then return end
        local pa, pb = sa.pose, sb.pose
        for i = 1, #ghostParts do
            local oa, ob = pa[i], pb[i]
            if oa and ob then
                ghostCFs[i] = cf * oa:Lerp(ob, alpha)
            elseif oa or ob then
                ghostCFs[i] = cf * (oa or ob)
            end
        end
        Workspace:BulkMoveTo(ghostParts, ghostCFs, Enum.BulkMoveMode.FireCFrameChanged)
        if anchorPart and ghostTag.Adornee ~= anchorPart then ghostTag.Adornee = anchorPart end

        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local off = hrp and (hrp.Position - cf.Position).Magnitude or 0
        local col = off < 2 and COL_OK or (off < 6 and COL_WARN or COL_BAD)
        local ms = math.floor(ping * 1000 + 0.5)
        local key = ms * 1000 + math.floor(off * 10)
        if key ~= lastTagMs then
            lastTagMs = key
            ghostLbl.Text = string.format("SERVER  %dms  ·  %.1f", ms, off)
        end
        tagStroke.Color = col
        ghostLbl.TextColor3 = col
        ghostHl.OutlineColor = col
        if ghost.Parent ~= Workspace then ghost.Parent = Workspace end
    end)

    local espFolder = Instance.new("ScreenGui")
    espFolder.Name = "FUNHUB_SemiTP_ESP"
    espFolder.ResetOnSpawn = false
    espFolder.Parent = safeGuiTarget
    local esp = {}
    local function clearEsp(p)
        local e = esp[p]
        if e then pcall(function() e.hl:Destroy(); e.tag:Destroy() end) esp[p] = nil end
    end
    task.spawn(function()
        while FUNHUB_ALIVE() do
            if not FUNHUBFx.esp and next(esp) == nil then task.wait(0.5) continue end
            local me = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            for _, p in ipairs(Players:GetPlayers()) do
                local ch = p.Character
                local head = ch and ch:FindFirstChild("Head")
                local r = ch and ch:FindFirstChild("HumanoidRootPart")
                if FUNHUBFx.esp and p ~= LP and head and r then
                    local e = esp[p]
                    if not e or e.char ~= ch then
                        clearEsp(p)
                        local hl = Instance.new("Highlight")
                        hl.FillColor = T.ACCENT2
                        hl.OutlineColor = T.FILL2
                        hl.FillTransparency = 0.75
                        hl.OutlineTransparency = 0
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = ch
                        hl.Parent = espFolder
                        local tag = Instance.new("BillboardGui")
                        tag.Size = UDim2.fromOffset(160, 16)
                        tag.StudsOffset = Vector3.new(0, -3.6, 0)
                        tag.AlwaysOnTop = true
                        tag.MaxDistance = 100000
                        tag.Adornee = r
                        tag.Parent = espFolder
                        local l = Instance.new("TextLabel")
                        l.Size = UDim2.fromScale(1, 1)
                        l.BackgroundTransparency = 1
                        l.Font = Enum.Font.GothamBold
                        l.TextSize = 11
                        l.TextColor3 = T.TEXT
                        l.TextStrokeTransparency = 0.4
                        l.Parent = tag
                        e = { hl = hl, tag = tag, lbl = l, char = ch }
                        esp[p] = e
                    end
                    local dist = me and math.floor((r.Position - me.Position).Magnitude) or 0
                    if e.dist ~= dist then
                        e.dist = dist
                        e.lbl.Text = p.Name .. "  " .. dist .. "m"
                    end
                else
                    clearEsp(p)
                end
            end
            for p in pairs(esp) do
                if not p.Parent then clearEsp(p) end
            end
            task.wait(0.2)
        end
        espFolder:Destroy()
    end)

    function FUNHUBAntiFx.setSentry(on) FUNHUBFx.sentry = on and true or false end
    function FUNHUBAntiFx.setDoge(on) FUNHUBFx.doge = on and true or false end
    function FUNHUBAntiFx.setAim(on) FUNHUBFx.aim = on and true or false end
    function FUNHUBAntiFx.setSpam(on) FUNHUBFx.spam = on and true or false end
    function FUNHUBAntiFx.setGhost(on) FUNHUBFx.ghost = on and true or false end
    function FUNHUBAntiFx.setEsp(on) FUNHUBFx.esp = on and true or false end
end

function FUNHUB.activate()
    task.spawn(function()
        setFFlags()
        _G.FUNHUB_SemiTP_InstaReset()
    end)
end

local AllowDisallowGui = Instance.new("ScreenGui")
AllowDisallowGui.Name = "FUNHUB_SemiTP_Allow"
AllowDisallowGui.ResetOnSpawn = false
AllowDisallowGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AllowDisallowGui.Parent = safeGuiTarget

local MainAllowBtn = Instance.new("TextButton")
MainAllowBtn.Size = UDim2.new(0, 100, 0, 34)
MainAllowBtn.Position = UDim2.new(0.65, 36, 0, 15)
MainAllowBtn.BackgroundColor3 = T.SURF
MainAllowBtn.AutoButtonColor = false
MainAllowBtn.BorderSizePixel = 0
MainAllowBtn.Text = "WAITING"
MainAllowBtn.TextColor3 = T.TEXT
MainAllowBtn.Font = Enum.Font.GothamBlack
MainAllowBtn.TextSize = 12
MainAllowBtn.ZIndex = 20
MainAllowBtn.Parent = AllowDisallowGui
corner(MainAllowBtn, 11)
stroke(MainAllowBtn, T.STROKE, 1.2, 0.35)
addShadow(MainAllowBtn, 20)
addHover(MainAllowBtn, T.SURF, T.HOVER)
restorePos(MainAllowBtn, "allow")
makeDraggable(MainAllowBtn, MainAllowBtn, rememberPos(MainAllowBtn, "allow"))

local activeHubs = {}
local function createFloatingHub(parent, statusText)
    if activeHubs[parent] then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.fromOffset(96, 20)
    billboard.Adornee = parent
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = AllowDisallowGui

    local HubFrame = Instance.new("Frame")
    HubFrame.Name = "Frame"
    HubFrame.Size = UDim2.new(1, 0, 1, 0)
    HubFrame.BackgroundColor3 = T.BG
    HubFrame.BackgroundTransparency = 0.12
    HubFrame.BorderSizePixel = 0
    HubFrame.Parent = billboard
    corner(HubFrame, 10)
    gradient(HubFrame, T.SURF2, T.BG, 90)
    stroke(HubFrame, T.STROKE, 1.5, 0.1)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "TextLabel"
    statusLabel.Size = UDim2.new(1, -8, 1, 0)
    statusLabel.Position = UDim2.fromOffset(4, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = statusText
    statusLabel.TextColor3 = T.TEXT
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.GothamBlack
    statusLabel.Parent = HubFrame

    activeHubs[parent] = billboard
end

task.spawn(function()
    while task.wait(0.5) do
        if not FUNHUB_ALIVE() then return end
        local currentObjects = {}
        local myBase = findMyBase()
        local nearestPrompt = nil
        local minDist = math.huge

        for desc in pairs(FUNHUBUI.friendPrompts) do
            if desc.Parent then
                local allowed = FUNHUBUI.friendPromptState(desc)
                local isDisallow, isAllow = allowed == true, allowed == false
                if isAllow or isDisallow then
                    local part = FUNHUBUI.promptPart(desc)
                    if part then
                        currentObjects[part] = true
                        local status = isAllow and "FRIENDS OFF" or "FRIENDS ON"
                        if not activeHubs[part] then createFloatingHub(part, status) end
                        local frame = activeHubs[part].Frame
                        local label = frame.TextLabel
                        if label.Text ~= status then label.Text = status end
                        local col = isAllow and Color3.fromRGB(255, 110, 130) or Color3.fromRGB(110, 235, 160)
                        label.TextColor3 = col
                        local st = frame:FindFirstChildOfClass("UIStroke")
                        if st then st.Color = col end

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

        MainAllowBtn.Text = nearestPrompt and (FUNHUBUI.friendPromptState(nearestPrompt) == true and "DISALLOW" or "ALLOW") or "NO BASE"

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

    for desc in pairs(FUNHUBUI.friendPrompts) do
        if desc.Parent then
            local part = FUNHUBUI.promptPart(desc)
            if part and hrp and myBase and part:IsDescendantOf(myBase) then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = desc
                end
            end
        end
    end
    if target then fireproximityprompt(target) end
end)

local ProgressGui = Instance.new("ScreenGui")
ProgressGui.Name = "FUNHUB_SemiTP_Progress"
ProgressGui.ResetOnSpawn = false
ProgressGui.IgnoreGuiInset = true
ProgressGui.DisplayOrder = 998
ProgressGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ProgressGui.Parent = safeGuiTarget

local PBarMain = Instance.new("Frame")
PBarMain.AnchorPoint = Vector2.new(0.5, 1)
PBarMain.Size = UDim2.new(0, 230, 0, 46)
PBarMain.Position = UDim2.new(0.5, 0, 1, -160)
PBarMain.BackgroundColor3 = T.SURF
PBarMain.BackgroundTransparency = 0.02
PBarMain.BorderSizePixel = 0
PBarMain.ZIndex = 70
PBarMain.Parent = ProgressGui
corner(PBarMain, 12)
stroke(PBarMain, T.STROKE, 1, 0.35)
stroke(PBarMain, T.ACCENT, 3, 0.84)
addShadow(PBarMain, 20)
restorePos(PBarMain, "progress")
makeDraggable(PBarMain, PBarMain, rememberPos(PBarMain, "progress"))

local PBarTitle = Instance.new("TextLabel")
PBarTitle.Size = UDim2.new(1, -12, 0, 13)
PBarTitle.Position = UDim2.fromOffset(6, 3)
PBarTitle.BackgroundTransparency = 1
PBarTitle.Font = Enum.Font.GothamBold
PBarTitle.TextSize = 11
PBarTitle.TextColor3 = T.TEXT
PBarTitle.Text = "SEMI TP"
PBarTitle.ZIndex = 72
FUNHUBUI.fit(PBarTitle, 11)
PBarTitle.Parent = PBarMain

local statusStamp = 0
setStealStatus = function(text, ok)
    local stamp = os.clock()
    statusStamp = stamp
    PBarTitle.Text = text
    PBarTitle.TextColor3 = (ok == true and Color3.fromRGB(110, 235, 160))
        or (ok == false and Color3.fromRGB(255, 110, 130))
        or T.TEXT
    if ok ~= nil then
        task.delay(4, function()
            if statusStamp == stamp and PBarTitle.Parent then
                PBarTitle.Text = "SEMI TP"
                PBarTitle.TextColor3 = T.TEXT
            end
        end)
    end
end

local PBarTrack = Instance.new("Frame")
PBarTrack.Size = UDim2.new(1, -10, 0, 18)
PBarTrack.Position = UDim2.fromOffset(5, 18)
PBarTrack.BackgroundColor3 = T.TRACK
PBarTrack.BorderSizePixel = 0
PBarTrack.ZIndex = 72
PBarTrack.Parent = PBarMain
corner(PBarTrack, 8)
stroke(PBarTrack, T.STROKE, 1, 0.55)

local PBarInner = Instance.new("Frame")
PBarInner.Size = UDim2.new(1, -2, 1, -2)
PBarInner.Position = UDim2.fromOffset(1, 1)
PBarInner.BackgroundColor3 = T.TRACK2
PBarInner.BackgroundTransparency = 0.15
PBarInner.BorderSizePixel = 0
PBarInner.ZIndex = 72
PBarInner.Parent = PBarTrack
corner(PBarInner, 7)

progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = T.FILL1
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 73
progressFill.Parent = PBarTrack
corner(progressFill, 8)
gradient(progressFill, T.FILL1, T.FILL2)
stroke(progressFill, Color3.fromRGB(143, 209, 255), 1, 0.45)

percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 1, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextSize = 12
percentLabel.TextColor3 = T.TEXT
percentLabel.TextStrokeTransparency = 0.7
percentLabel.Text = "0%"
percentLabel.ZIndex = 74
percentLabel.Parent = PBarTrack

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FUNHUB_SemiTP"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = safeGuiTarget

local panelWidth = IsMobile and 276 or 262

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, panelWidth, 0, 0)
MainFrame.AutomaticSize = Enum.AutomaticSize.Y
MainFrame.AnchorPoint = Vector2.new(1, 0)
MainFrame.Position = IsMobile and UDim2.new(0.88, 0, 0.05, 0) or UDim2.new(0.84, 0, 0.04, 0)
MainFrame.BackgroundColor3 = T.BG
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ZIndex = 100
MainFrame.Parent = ScreenGui
corner(MainFrame, 18)
stroke(MainFrame, T.STROKE, 1.2, 0.4)
addShadow(MainFrame)

local MainPad = Instance.new("UIPadding")
MainPad.PaddingBottom = UDim.new(0, 10)
MainPad.Parent = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 36)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.ZIndex = 101
HeaderFrame.Parent = MainFrame
restorePos(MainFrame, "main")
makeDraggable(HeaderFrame, MainFrame, rememberPos(MainFrame, "main"))

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -28, 0, 22)
TitleText.Position = UDim2.new(0, 14, 0, 7)
TitleText.BackgroundTransparency = 1
TitleText.Text = "SEMI TP"
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 18
TitleText.TextColor3 = T.TEXT
TitleText.ZIndex = 102
TitleText.Parent = HeaderFrame

local TitleRule = Instance.new("Frame")
TitleRule.AnchorPoint = Vector2.new(0.5, 0)
TitleRule.Position = UDim2.new(0.5, 0, 0, 32)
TitleRule.Size = UDim2.new(0, 124, 0, 1)
TitleRule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleRule.BackgroundTransparency = 0.15
TitleRule.BorderSizePixel = 0
TitleRule.ZIndex = 101
TitleRule.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 28)
TabContainer.Position = UDim2.fromOffset(10, 42)
TabContainer.BackgroundColor3 = T.SURF
TabContainer.BorderSizePixel = 0
TabContainer.ZIndex = 101
TabContainer.Parent = MainFrame
corner(TabContainer, 10)
stroke(TabContainer, T.STROKE, 1, 0.48)

local TabPad = Instance.new("UIPadding")
TabPad.PaddingLeft, TabPad.PaddingRight = UDim.new(0, 3), UDim.new(0, 3)
TabPad.PaddingTop, TabPad.PaddingBottom = UDim.new(0, 3), UDim.new(0, 3)
TabPad.Parent = TabContainer

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)

local function createTabButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / 6, -4, 1, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.LayoutOrder = order
    btn.ZIndex = 103
    btn.Parent = TabContainer

    local pill = Instance.new("Frame")
    pill.Name = "Pill"
    pill.Size = UDim2.new(1, 0, 1, 0)
    pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pill.BackgroundTransparency = 1
    pill.BorderSizePixel = 0
    pill.ZIndex = 103
    pill.Parent = btn
    corner(pill, 8)
    gradient(pill, T.FILL1, T.ACCENT2, 90)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = T.DIM
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    FUNHUBUI.fit(label, 10)
    label.ZIndex = 104
    label.Parent = btn
    return btn
end

local MainTabBtn = createTabButton("Main", 1)
local UtilsTabBtn = createTabButton("Steal", 2)
FUNHUBUI.tabBtns = { Main = MainTabBtn, Steal = UtilsTabBtn, Protect = createTabButton("Anti", 3),
    Extras = createTabButton("Visual", 4), Move = createTabButton("Move", 5), Misc = createTabButton("Misc", 6) }

local ContentCard = Instance.new("Frame")
ContentCard.AutomaticSize = Enum.AutomaticSize.Y
ContentCard.Size = UDim2.new(1, -20, 0, 0)
ContentCard.Position = UDim2.fromOffset(10, 78)
ContentCard.BackgroundColor3 = T.SURF
ContentCard.BorderSizePixel = 0
ContentCard.ZIndex = 101
ContentCard.Parent = MainFrame
corner(ContentCard, 16)
stroke(ContentCard, T.STROKE, 1, 0.48)

local ContentLayout = Instance.new("Frame")
ContentLayout.AutomaticSize = Enum.AutomaticSize.Y
ContentLayout.Size = UDim2.new(1, -8, 0, 0)
ContentLayout.Position = UDim2.fromOffset(4, 4)
ContentLayout.BackgroundTransparency = 1
ContentLayout.ZIndex = 102
ContentLayout.Parent = ContentCard

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingBottom = UDim.new(0, 8)
ContentPad.Parent = ContentCard

local List = Instance.new("UIListLayout", ContentLayout)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Padding = UDim.new(0, 6)

local function createRowFrame(height, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, math.max(height, 30))
    card.BackgroundColor3 = T.SURF2
    card.BackgroundTransparency = 0.02
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 1
    card.ZIndex = 103
    card.Parent = ContentLayout
    corner(card, 11)
    local rowStroke = stroke(card, T.STROKE, 1, 0.52)
    addHover(card, T.SURF2, T.HOVER, rowStroke)
    return card
end

local function rowLabel(parent, text, widthScale)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(widthScale or 0.55, 0, 1, 0)
    lbl.Position = UDim2.fromOffset(12, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.TEXT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    FUNHUBUI.fit(lbl, 12)
    lbl.ZIndex = 104
    lbl.Parent = parent
    return lbl
end

local function pillButton(parent, width, text)
    local btn = Instance.new("TextButton")
    btn.AutoButtonColor = false
    btn.Size = UDim2.fromOffset(width, 22)
    btn.Position = UDim2.new(1, -(width + 10), 0.5, -11)
    btn.BackgroundColor3 = T.OFF_BG
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = T.TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    FUNHUBUI.fit(btn, 11)
    btn.ZIndex = 104
    btn.Parent = parent
    corner(btn, 7)
    local s = stroke(btn, T.STROKE, 1, 0.55)
    btn.MouseEnter:Connect(function() tween(s, 0.14, { Transparency = 0.12 }) end)
    btn.MouseLeave:Connect(function() tween(s, 0.14, { Transparency = 0.55 }) end)
    return btn, s
end

local function createModernToggle(parentCard, textLabel, initialState, onClick)
    rowLabel(parentCard, textLabel, 0.6)

    local btn = Instance.new("TextButton")
    btn.AutoButtonColor = false
    btn.Size = UDim2.fromOffset(62, 22)
    btn.Position = UDim2.new(1, -70, 0.5, -11)
    btn.BackgroundColor3 = T.OFF_BG
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 104
    btn.Parent = parentCard
    corner(btn, 7)
    local btnStroke = stroke(btn, T.STROKE, 1, 0.55)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(1, 0, 1, 0)
    knob.BackgroundTransparency = 1
    knob.BorderSizePixel = 0
    knob.ZIndex = 104
    knob.Parent = btn
    corner(knob, 7)
    gradient(knob, T.GREEN1, T.GREEN2)

    local stateLabel = Instance.new("TextLabel")
    stateLabel.BackgroundTransparency = 1
    stateLabel.Size = UDim2.fromScale(1, 1)
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.TextSize = 11
    stateLabel.ZIndex = 105
    stateLabel.Parent = btn

    local state = initialState and true or false
    local function paint()
        if state then
            btn.BackgroundColor3 = T.GREEN1
            knob.BackgroundTransparency = 0
            stateLabel.Text = "ON"
            stateLabel.TextColor3 = T.ON_TEXT
            btnStroke.Color = T.GREEN_STROKE
            btnStroke.Transparency = 0.22
        else
            btn.BackgroundColor3 = T.OFF_BG
            knob.BackgroundTransparency = 1
            stateLabel.Text = "OFF"
            stateLabel.TextColor3 = T.OFF_TEXT
            btnStroke.Color = T.STROKE
            btnStroke.Transparency = 0.55
        end
    end
    paint()

    btn.MouseButton1Click:Connect(function()
        state = not state
        paint()
        onClick(state)
    end)
    return btn, paint
end

local function actionButton(parentCard, text, primary)
    local bg
    if primary then
        bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bg.BorderSizePixel = 0
        bg.ZIndex = 104
        bg.Parent = parentCard
        corner(bg, 11)
        gradient(bg, T.FILL1, T.ACCENT2, 90)
        stroke(bg, Color3.fromRGB(143, 209, 255), 1, 0.45)
    end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.AutoButtonColor = false
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextStrokeTransparency = primary and 0.6 or 1
    btn.Font = primary and Enum.Font.GothamBlack or Enum.Font.GothamBold
    btn.TextSize = primary and 14 or 12
    btn.ZIndex = 105
    btn.Parent = parentCard
    return btn, bg
end

;(function()
    FUNHUBUI.cfgChips, FUNHUBUI.cfgRefresh = {}, {}
    local function box(row, right, spec)
        local holder = Instance.new("Frame")
        holder.Size = right == nil and UDim2.new(1, -16, 0, 22) or UDim2.new(0.5, -12, 0, 22)
        holder.Position = right and UDim2.new(0.5, 4, 0.5, -11) or UDim2.new(0, 8, 0.5, -11)
        holder.BackgroundColor3 = T.OFF_BG
        holder.BorderSizePixel = 0
        holder.ZIndex = 104
        holder.Parent = row
        corner(holder, 7)
        stroke(holder, T.STROKE, 1, 0.55)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, -44, 1, 0)
        l.Position = UDim2.fromOffset(6, 0)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        FUNHUBUI.fit(l, 10)
        l.TextColor3 = T.OFF_TEXT
        l.Text = string.upper(spec[1])
        l.ZIndex = 105
        l.Parent = holder
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(0, 36, 1, -6)
        tb.Position = UDim2.new(1, -39, 0, 3)
        tb.BackgroundColor3 = T.TRACK
        tb.BorderSizePixel = 0
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 10
        tb.TextColor3 = T.TEXT
        tb.ClearTextOnFocus = false
        tb.ZIndex = 106
        tb.Parent = holder
        corner(tb, 5)
        local key, def, lo, hi = spec[2], spec[3], spec[4], spec[5]
        local function get() return math.clamp(tonumber(HubConfig[key]) or def, lo, hi) end
        tb.Text = tostring(get())
        FUNHUBUI.cfgRefresh[#FUNHUBUI.cfgRefresh + 1] = function() tb.Text = tostring(get()) end
        tb.FocusLost:Connect(function()
            local n = tonumber(tb.Text)
            if n then
                HubConfig[key] = math.clamp(math.floor(n * 10 + 0.5) / 10, lo, hi)
                saveHubConfig()
            end
            tb.Text = tostring(get())
        end)
    end

    function FUNHUBUI.num(key, def, lo, hi)
        return math.clamp(tonumber(HubConfig[key]) or def, lo, hi)
    end

    function FUNHUBUI.numPair(order, a, b)
        local r = createRowFrame(30, order)
        if b then
            box(r, false, a)
            box(r, true, b)
        else
            box(r, nil, a)
        end
        return r
    end

    function FUNHUBUI.cycleRow(order, text, options, key, onSet)
        local r = createRowFrame(30, order)
        rowLabel(r, text, 0.4)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.fromOffset(120, 22)
        holder.Position = UDim2.new(1, -128, 0.5, -11)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 104
        holder.Parent = r
        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -52, 1, 0)
        val.Position = UDim2.fromOffset(26, 0)
        val.BackgroundColor3 = T.GREEN1
        val.BorderSizePixel = 0
        val.Font = Enum.Font.GothamBold
        val.TextSize = 11
        val.TextColor3 = T.ON_TEXT
        val.ZIndex = 105
        val.Parent = holder
        FUNHUBUI.fit(val, 11, 6)
        corner(val, 7)
        stroke(val, T.GREEN_STROKE, 1, 0.22)
        local idx = table.find(options, HubConfig[key]) or 1
        local function show()
            val.Text = string.upper(options[idx])
            HubConfig[key] = options[idx]
            if onSet then onSet(options[idx]) end
        end
        show()
        FUNHUBUI.cfgRefresh[#FUNHUBUI.cfgRefresh + 1] = function()
            idx = table.find(options, HubConfig[key]) or idx
            show()
        end
        local function step(d)
            idx = (idx - 1 + d) % #options + 1
            show()
            saveHubConfig()
        end
        for i, spec in ipairs({ { "<", 0, 0, -1 }, { ">", 1, -22, 1 } }) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(22, 22)
            b.Position = UDim2.new(spec[2], spec[3], 0, 0)
            b.AutoButtonColor = false
            b.BackgroundColor3 = T.OFF_BG
            b.BorderSizePixel = 0
            b.Text = spec[1]
            b.TextColor3 = T.TEXT
            b.Font = Enum.Font.GothamBlack
            b.TextSize = 12
            b.ZIndex = 105
            b.Parent = holder
            corner(b, 7)
            stroke(b, T.STROKE, 1, 0.55)
            addHover(b, T.OFF_BG, T.HOVER)
            b.MouseButton1Click:Connect(function() step(spec[4]) end)
        end
        return r
    end

    function FUNHUBUI.textRow(order, text, key, hint)
        local r = createRowFrame(30, order)
        rowLabel(r, text, 0.3)
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(0.62, -8, 0, 22)
        tb.Position = UDim2.new(0.38, 0, 0.5, -11)
        tb.BackgroundColor3 = T.OFF_BG
        tb.BorderSizePixel = 0
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 10
        tb.TextColor3 = T.TEXT
        tb.PlaceholderText = hint or ""
        tb.PlaceholderColor3 = T.OFF_TEXT
        tb.TextTruncate = Enum.TextTruncate.AtEnd
        tb.ClearTextOnFocus = false
        tb.Text = tostring(HubConfig[key] or "")
        tb.ZIndex = 105
        tb.Parent = r
        corner(tb, 7)
        stroke(tb, T.STROKE, 1, 0.55)
        tb.FocusLost:Connect(function()
            HubConfig[key] = tb.Text
            saveHubConfig()
        end)
        FUNHUBUI.cfgRefresh[#FUNHUBUI.cfgRefresh + 1] = function() tb.Text = tostring(HubConfig[key] or "") end
        return r
    end

    function FUNHUBUI.slider(order, text, key, def, lo, hi)
        local r = createRowFrame(30, order)
        local lbl = rowLabel(r, string.upper(text), 0.2)
        FUNHUBUI.fit(lbl, 10)
        lbl.TextColor3 = T.OFF_TEXT
        local val = Instance.new("TextLabel")
        val.Size = UDim2.fromOffset(34, 22)
        val.Position = UDim2.new(1, -42, 0.5, -11)
        val.BackgroundColor3 = T.TRACK
        val.BorderSizePixel = 0
        val.Font = Enum.Font.GothamBold
        val.TextSize = 11
        val.TextColor3 = T.TEXT
        val.ZIndex = 105
        val.Parent = r
        corner(val, 6)
        local track = Instance.new("TextButton")
        track.AutoButtonColor = false
        track.Text = ""
        track:SetAttribute("__semiNoPop", true)
        track.Size = UDim2.new(0.8, -62, 0, 8)
        track.Position = UDim2.new(0.2, 8, 0.5, -4)
        track.BackgroundColor3 = T.TRACK
        track.BorderSizePixel = 0
        track.ZIndex = 105
        track.Parent = r
        corner(track, 4)
        stroke(track, T.STROKE, 1, 0.55)
        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.BorderSizePixel = 0
        fill.ZIndex = 106
        fill.Parent = track
        corner(fill, 4)
        gradient(fill, T.GREEN1, T.GREEN2)
        local knob = Instance.new("Frame")
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Size = UDim2.fromOffset(14, 14)
        knob.BackgroundColor3 = T.ON_TEXT
        knob.BorderSizePixel = 0
        knob.ZIndex = 107
        knob.Parent = track
        corner(knob, 7)
        stroke(knob, T.GREEN_STROKE, 1.5, 0)
        local function get() return math.clamp(tonumber(HubConfig[key]) or def, lo, hi) end
        local function show()
            local a = (get() - lo) / (hi - lo)
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            val.Text = tostring(math.floor(get() + 0.5))
        end
        local function setFromX(x)
            local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            HubConfig[key] = math.floor(lo + a * (hi - lo) + 0.5)
            show()
        end
        local dragging = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(i.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
                saveHubConfig()
            end
        end)
        show()
        FUNHUBUI.cfgRefresh[#FUNHUBUI.cfgRefresh + 1] = show
        return r
    end
end)()

;(function()
    local DIR = "FUNHUB_SemiTP_Configs"
    local PREFIX = "FUNHUB-"
    local SKIP = { positions = true, speedPos = true, selectedSlot = true, cfgActive = true }
    local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    local function b64enc(data)
        local out = {}
        for i = 1, #data, 3 do
            local a, b, c = data:byte(i, i + 2)
            local n = a * 65536 + (b or 0) * 256 + (c or 0)
            for j = 1, 4 do
                if j == 3 and not b or j == 4 and not c then
                    out[#out + 1] = "="
                else
                    local k = math.floor(n / 64 ^ (4 - j)) % 64
                    out[#out + 1] = B64:sub(k + 1, k + 1)
                end
            end
        end
        return table.concat(out)
    end

    local function b64dec(data)
        data = data:gsub("[^%w%+/]", "")
        local out, n, bits = {}, 0, 0
        for i = 1, #data do
            n = n * 64 + (B64:find(data:sub(i, i), 1, true) - 1)
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                out[#out + 1] = string.char(math.floor(n / 2 ^ bits) % 256)
                n = n % 2 ^ bits
            end
        end
        return table.concat(out)
    end

    local function snapshot()
        local t = {}
        for k, v in pairs(HubConfig) do
            if not SKIP[k] then t[k] = v end
        end
        return t
    end

    local function clean(name)
        name = tostring(name or ""):gsub("[^%w%s_%-]", ""):match("^%s*(.-)%s*$")
        return name:sub(1, 24)
    end

    local function path(name) return DIR .. "/" .. name .. ".json" end

    local function list()
        local names = {}
        pcall(function()
            if not isfolder(DIR) then makefolder(DIR) end
            for _, f in ipairs(listfiles(DIR)) do
                local n = tostring(f):match("([^/\\]+)%.json$")
                if n then names[#names + 1] = n end
            end
        end)
        table.sort(names, function(a, b) return a:lower() < b:lower() end)
        return names
    end

    local function apply(cfg)
        if type(cfg) ~= "table" then return false end
        for k, v in pairs(cfg) do
            if not SKIP[k] then HubConfig[k] = v end
        end
        for key, set in pairs(FUNHUBUI.cfgChips) do
            if cfg[key] ~= nil then pcall(set, cfg[key]) end
        end
        for _, f in ipairs(FUNHUBUI.cfgRefresh) do pcall(f) end
        saveHubConfig()
        return true
    end

    local function actionBtn(row, right, text, fn)
        local b = Instance.new("TextButton")
        b.AutoButtonColor = false
        b.Size = UDim2.new(0.5, -12, 0, 22)
        b.Position = right and UDim2.new(0.5, 4, 0.5, -11) or UDim2.new(0, 8, 0.5, -11)
        b.BackgroundColor3 = T.OFF_BG
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.TextColor3 = T.TEXT
        b.Text = text
        b.ZIndex = 104
        b.Parent = row
        corner(b, 7)
        local s = stroke(b, T.STROKE, 1, 0.55)
        addHover(b, T.OFF_BG, T.HOVER)
        b.MouseButton1Click:Connect(function()
            b.BackgroundColor3 = T.GREEN1
            s.Color = T.GREEN_STROKE
            task.delay(0.25, function()
                b.BackgroundColor3 = T.OFF_BG
                s.Color = T.STROKE
            end)
            local ok, err = pcall(fn)
            if not ok then setStealStatus("CONFIG ERROR", false) warn("[SEMI TP] config:", err) end
        end)
        return b
    end

    local function textBox(parent, hint)
        local tb = Instance.new("TextBox")
        tb.BackgroundColor3 = T.OFF_BG
        tb.BorderSizePixel = 0
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 10
        tb.TextColor3 = T.TEXT
        tb.PlaceholderText = hint
        tb.PlaceholderColor3 = T.OFF_TEXT
        tb.TextTruncate = Enum.TextTruncate.AtEnd
        tb.ClearTextOnFocus = false
        tb.Text = ""
        tb.ZIndex = 105
        tb.Parent = parent
        corner(tb, 7)
        stroke(tb, T.STROKE, 1, 0.55)
        return tb
    end

    function FUNHUBUI.configRows(order)
        local rows = {}
        local r1 = createRowFrame(30, order)
        rowLabel(r1, "Profile", 0.3)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(0.66, -8, 0, 22)
        holder.Position = UDim2.new(0.34, 0, 0.5, -11)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 104
        holder.Parent = r1
        local nameBox = textBox(holder, "profile name")
        nameBox.Size = UDim2.new(1, -52, 1, 0)
        nameBox.Position = UDim2.fromOffset(26, 0)
        nameBox.TextXAlignment = Enum.TextXAlignment.Center
        nameBox.Text = tostring(HubConfig.cfgActive or "")
        local selected = clean(nameBox.Text)
        local function step(d)
            local names = list()
            if #names == 0 then setStealStatus("NO SAVED PROFILES", false) return end
            local i = table.find(names, selected) or (d > 0 and 0 or 1)
            i = (i - 1 + d) % #names + 1
            selected = names[i]
            nameBox.Text = selected
        end
        for _, spec in ipairs({ { "<", 0, 0, -1 }, { ">", 1, -22, 1 } }) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(22, 22)
            b.Position = UDim2.new(spec[2], spec[3], 0, 0)
            b.AutoButtonColor = false
            b.BackgroundColor3 = T.OFF_BG
            b.BorderSizePixel = 0
            b.Text = spec[1]
            b.TextColor3 = T.TEXT
            b.Font = Enum.Font.GothamBlack
            b.TextSize = 12
            b.ZIndex = 105
            b.Parent = holder
            corner(b, 7)
            stroke(b, T.STROKE, 1, 0.55)
            addHover(b, T.OFF_BG, T.HOVER)
            b.MouseButton1Click:Connect(function() step(spec[4]) end)
        end
        rows[1] = r1

        local function typed()
            local n = clean(nameBox.Text)
            if n == "" then setStealStatus("TYPE A PROFILE NAME", false) return nil end
            return n
        end
        local function exists(n) return table.find(list(), n) ~= nil end

        local r2 = createRowFrame(30, order + 1)
        actionBtn(r2, false, "SAVE", function()
            local n = typed()
            if not n then return end
            if not isfolder(DIR) then makefolder(DIR) end
            HubConfig.cfgActive = n
            writefile(path(n), HttpService:JSONEncode(snapshot()))
            saveHubConfig()
            selected = n
            setStealStatus("SAVED PROFILE: " .. n, true)
        end)
        actionBtn(r2, true, "LOAD", function()
            local n = typed()
            if not n then return end
            if not exists(n) then setStealStatus("NO PROFILE: " .. n, false) return end
            local cfg = HttpService:JSONDecode(readfile(path(n)))
            HubConfig.cfgActive = n
            selected = n
            apply(cfg)
            setStealStatus("LOADED PROFILE: " .. n, true)
        end)
        rows[2] = r2

        local r3 = createRowFrame(30, order + 2)
        actionBtn(r3, false, "RENAME", function()
            local n = typed()
            if not n then return end
            if not selected or selected == "" or not exists(selected) then setStealStatus("PICK A PROFILE WITH < >", false) return end
            if n == selected then return end
            writefile(path(n), readfile(path(selected)))
            delfile(path(selected))
            if HubConfig.cfgActive == selected then HubConfig.cfgActive = n saveHubConfig() end
            setStealStatus("RENAMED " .. selected .. " TO " .. n, true)
            selected = n
        end)
        actionBtn(r3, true, "DELETE", function()
            local n = typed()
            if not n then return end
            if not exists(n) then setStealStatus("NO PROFILE: " .. n, false) return end
            delfile(path(n))
            if HubConfig.cfgActive == n then HubConfig.cfgActive = nil saveHubConfig() end
            selected = nil
            nameBox.Text = ""
            setStealStatus("DELETED PROFILE: " .. n, true)
        end)
        rows[3] = r3

        local r5 = createRowFrame(30, order + 4)
        local codeBox = textBox(r5, "paste a share code here")
        codeBox.Size = UDim2.new(1, -16, 0, 22)
        codeBox.Position = UDim2.new(0, 8, 0.5, -11)
        local realCode = ""
        local MASK = PREFIX .. "********"
        local function showCode(code)
            realCode = code
            codeBox.Text = code ~= "" and MASK or ""
        end
        codeBox.Focused:Connect(function()
            if codeBox.Text == MASK then codeBox.Text = "" end
        end)
        codeBox.FocusLost:Connect(function()
            local raw = codeBox.Text:gsub("%s", "")
            if raw == "" then
                showCode(realCode)
            else
                showCode(raw)
            end
        end)

        local r4 = createRowFrame(30, order + 3)
        actionBtn(r4, false, "COPY CODE", function()
            local code = PREFIX .. b64enc(HttpService:JSONEncode({ name = clean(nameBox.Text), data = snapshot() }))
            if setclipboard then
                setclipboard(code)
                setStealStatus("SHARE CODE COPIED", true)
            else
                setStealStatus("CODE IN THE BOX (NO CLIPBOARD)", true)
            end
            showCode(code)
        end)
        actionBtn(r4, true, "IMPORT CODE", function()
            local raw = realCode
            local body
            for _, pre in ipairs({ PREFIX, "SEMITP-", "iCollectPro-" }) do
                if raw:sub(1, #pre) == pre then body = raw:sub(#pre + 1) break end
            end
            if not body then setStealStatus("NOT A FUNHUB CODE", false) return end
            local ok, pack = pcall(function() return HttpService:JSONDecode(b64dec(body)) end)
            if not ok or type(pack) ~= "table" or type(pack.data) ~= "table" then setStealStatus("BROKEN CODE", false) return end
            apply(pack.data)
            showCode("")
            local n = clean(pack.name)
            if n ~= "" then nameBox.Text = n end
            setStealStatus("IMPORTED" .. (n ~= "" and (": " .. n) or "") .. " (SAVE TO KEEP)", true)
        end)
        rows[4] = r4
        rows[5] = r5
        return rows
    end
end)()

local Row1 = createRowFrame(30, 1)
FUNHUBUI.podiumLbl = rowLabel(Row1, "Podium (1-" .. MAX_PODIUM .. ")", 0.45)

local SelectorFrame = Instance.new("Frame")
SelectorFrame.Size = UDim2.fromOffset(100, 22)
SelectorFrame.Position = UDim2.new(1, -110, 0.5, -11)
SelectorFrame.BackgroundTransparency = 1
SelectorFrame.ZIndex = 104
SelectorFrame.Parent = Row1

local function arrowButton(text, xScale, xOffset, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(22, 22)
    b.Position = UDim2.new(xScale, xOffset, 0, 0)
    b.AutoButtonColor = false
    b.BackgroundColor3 = T.OFF_BG
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = T.TEXT
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 12
    b.ZIndex = 105
    b.Parent = parent or SelectorFrame
    corner(b, 7)
    stroke(b, T.STROKE, 1, 0.55)
    addHover(b, T.OFF_BG, T.HOVER)
    return b
end

local LeftBtn = arrowButton("<", 0, 0)
local RightBtn = arrowButton(">", 1, -22)

local SlotDisplay = Instance.new("TextBox")
SlotDisplay.Size = UDim2.new(1, -52, 1, 0)
SlotDisplay.Position = UDim2.fromOffset(26, 0)
SlotDisplay.BackgroundColor3 = T.GREEN1
SlotDisplay.BorderSizePixel = 0
SlotDisplay.Text = tostring(selectedSlot)
SlotDisplay.TextColor3 = T.ON_TEXT
SlotDisplay.Font = Enum.Font.GothamBold
SlotDisplay.TextSize = 12
SlotDisplay.ClearTextOnFocus = true
SlotDisplay.ZIndex = 105
SlotDisplay.Parent = SelectorFrame
corner(SlotDisplay, 7)
stroke(SlotDisplay, T.GREEN_STROKE, 1, 0.22)

local function updateSlot(newSlot)
    selectedSlot = newSlot
    SlotDisplay.Text = tostring(selectedSlot)
    FUNHUB.setSlot(selectedSlot)
end

local slotStroke = SlotDisplay:FindFirstChildOfClass("UIStroke")
task.spawn(function()
    local was = nil
    while FUNHUB_ALIVE() and SlotDisplay.Parent do
        local max = FUNHUB.maxPodium()
        local text = "Podium (1-" .. max .. ")"
        if FUNHUBUI.podiumLbl.Text ~= text then FUNHUBUI.podiumLbl.Text = text end
        if slotHasTarget ~= was then
            was = slotHasTarget
            SlotDisplay.BackgroundColor3 = was and T.GREEN1 or Color3.fromRGB(120, 30, 50)
            SlotDisplay.TextColor3 = was and T.ON_TEXT or Color3.fromRGB(255, 200, 210)
            if slotStroke then slotStroke.Color = was and T.GREEN_STROKE or Color3.fromRGB(220, 80, 110) end
        end
        task.wait(0.25)
    end
end)

SlotDisplay.FocusLost:Connect(function()
    local n = math.floor(tonumber(SlotDisplay.Text) or selectedSlot)
    updateSlot(math.clamp(n, 1, FUNHUB.maxPodium()))
end)

LeftBtn.MouseButton1Click:Connect(function()
    local nextSlot = selectedSlot - 1
    if nextSlot < 1 then nextSlot = 1 end
    updateSlot(nextSlot)
end)

RightBtn.MouseButton1Click:Connect(function()
    local nextSlot = selectedSlot + 1
    if nextSlot > FUNHUB.maxPodium() then nextSlot = FUNHUB.maxPodium() end
    updateSlot(nextSlot)
end)

Row1.LayoutOrder = 0

local RowBase = createRowFrame(30, -1)
rowLabel(RowBase, "Target", 0.3)

local BaseSelector = Instance.new("Frame")
BaseSelector.Size = UDim2.fromOffset(136, 22)
BaseSelector.Position = UDim2.new(1, -144, 0.5, -11)
BaseSelector.BackgroundTransparency = 1
BaseSelector.ZIndex = 104
BaseSelector.Parent = RowBase

local BaseLeft = arrowButton("<", 0, 0, BaseSelector)
local BaseRight = arrowButton(">", 1, -22, BaseSelector)

local BaseName = Instance.new("TextLabel")
BaseName.Size = UDim2.new(1, -52, 1, 0)
BaseName.Position = UDim2.fromOffset(26, 0)
BaseName.BackgroundColor3 = T.OFF_BG
BaseName.BorderSizePixel = 0
BaseName.Text = "Nearest"
BaseName.TextColor3 = T.TEXT
BaseName.Font = Enum.Font.GothamBold
BaseName.TextSize = 11
FUNHUBUI.fit(BaseName, 11)
BaseName.ZIndex = 105
BaseName.Parent = BaseSelector
corner(BaseName, 7)
stroke(BaseName, T.STROKE, 1, 0.55)

local function plotOwnerName(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local sg = sign and sign:FindFirstChild("SurfaceGui")
    local lbl = sg and sg:FindFirstChild("Frame") and sg.Frame:FindFirstChild("TextLabel")
    return lbl and (lbl.Text:gsub("'s [Bb]ase$", "")) or "?"
end

local function enemyPlotList()
    local list = {}
    local plots = Workspace:FindFirstChild("Plots")
    for _, plot in ipairs(plots and plots:GetChildren() or {}) do
        if isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums") then
            list[#list + 1] = plot
        end
    end
    table.sort(list, function(a, b)
        return (tonumber(a:GetAttribute("Order")) or 0) < (tonumber(b:GetAttribute("Order")) or 0)
    end)
    return list
end

local function refreshBaseName()
    BaseName.Text = targetPlot and plotOwnerName(targetPlot) or "Nearest"
end

local function cycleBase(dir)
    local list = enemyPlotList()
    local idx = 0
    for i, p in ipairs(list) do
        if p == targetPlot then idx = i break end
    end
    idx = (idx + dir) % (#list + 1)
    targetPlot = list[idx]
    refreshBaseName()
end

BaseLeft.MouseButton1Click:Connect(function() cycleBase(-1) end)
BaseRight.MouseButton1Click:Connect(function() cycleBase(1) end)

task.spawn(function()
    while FUNHUB_ALIVE() and BaseName.Parent do
        if targetPlot and (not targetPlot.Parent or not isEnemyPlot(targetPlot)) then
            targetPlot = nil
        end
        refreshBaseName()
        task.wait(0.5)
    end
end)

local InfoRow = createRowFrame(26, 1)
InfoRow.BackgroundTransparency = 0.35
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -16, 1, 0)
InfoLabel.Position = UDim2.fromOffset(8, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 11
InfoLabel.TextColor3 = T.DIM
FUNHUBUI.fit(InfoLabel, 11)
InfoLabel.Text = ""
InfoLabel.ZIndex = 104
InfoLabel.Parent = InfoRow

task.spawn(function()
    local last
    while FUNHUB_ALIVE() and InfoLabel.Parent do
        if podiumInfoText ~= last then
            last = podiumInfoText
            InfoLabel.Text = last
            InfoLabel.TextColor3 = (last == "empty" or last:find("no enemy")) and T.OFF_TEXT or T.TEXT
        end
        task.wait(0.25)
    end
end)

local Row6 = createRowFrame(36, 2)
local StealBg
TeleportBtn, StealBg = actionButton(Row6, "STEAL NOW", true)
FUNHUBUI.fit(TeleportBtn, 14, 16)
TeleportBtn.MouseButton1Click:Connect(function() FUNHUB.execute() end)

do
    local flashUntil, flashText = 0, ""
    FUNHUBUI.flash = function(msg)
        setStealStatus(msg, false)
        flashText = msg
        flashUntil = os.clock() + 1.2
    end
    task.spawn(function()
        while FUNHUB_ALIVE() and TeleportBtn.Parent do
            local st = FUNHUBUI.state
            local flashing = os.clock() < flashUntil
            if flashing then
                TeleportBtn.Text = flashText
                StealBg.BackgroundColor3 = Color3.fromRGB(255, 120, 140)
            elseif st.locked and st.friends then
                TeleportBtn.Text = "STEAL NOW (FRIENDS ALLOWED)"
                StealBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            elseif st.locked then
                TeleportBtn.Text = "LOCKED  " .. st.lockText
                StealBg.BackgroundColor3 = Color3.fromRGB(110, 110, 120)
            else
                TeleportBtn.Text = "STEAL NOW"
                StealBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            TeleportBtn.TextColor3 = (st.locked and not st.friends and not flashing) and Color3.fromRGB(200, 200, 210) or Color3.fromRGB(255, 255, 255)
            task.wait(0.1)
        end
    end)
end

local Row5 = createRowFrame(30, 3)
local ActivateBtn = actionButton(Row5, "Instant Reset", false)
ActivateBtn.MouseButton1Click:Connect(function() FUNHUB.activate() end)

local isSpeedVisible = HubConfig.hexSpeedVisible or false
local HexSpeedFrameRef = nil
local SettingsRows = { Steal = {}, Protect = {}, Extras = {}, Move = {}, Misc = {} }
do
    local bucket = SettingsRows.Steal
    local function tab(name) bucket = SettingsRows[name] end
    local function header(text, order)
        local h = Instance.new("TextLabel")
        h.Size = UDim2.new(1, 0, 0, 14)
        h.BackgroundTransparency = 1
        h.Font = Enum.Font.GothamBlack
        h.TextSize = 10
        h.TextColor3 = T.DIM
        h.TextXAlignment = Enum.TextXAlignment.Left
        h.Text = "   " .. text
        h.LayoutOrder = order
        h.ZIndex = 104
        h.Parent = ContentLayout
        bucket[#bucket + 1] = h
    end

    local function pairRow(order)
        local r = createRowFrame(30, order)
        bucket[#bucket + 1] = r
        return r
    end

    local function chip(row, right, text, initial, onToggle)
        local btn = Instance.new("TextButton")
        btn.AutoButtonColor = false
        btn.Size = right == nil and UDim2.new(1, -16, 0, 22) or UDim2.new(0.5, -12, 0, 22)
        btn.Position = right and UDim2.new(0.5, 4, 0.5, -11) or UDim2.new(0, 8, 0.5, -11)
        btn.BackgroundColor3 = T.OFF_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.ZIndex = 104
        btn.Parent = row
        corner(btn, 7)
        local s = stroke(btn, T.STROKE, 1, 0.55)
        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromScale(1, 1)
        knob.BackgroundTransparency = 1
        knob.BorderSizePixel = 0
        knob.ZIndex = 104
        knob.Parent = btn
        corner(knob, 7)
        gradient(knob, T.GREEN1, T.GREEN2)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, -10, 1, -8)
        l.Position = UDim2.fromOffset(5, 4)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.Text = string.upper(text)
        l.ZIndex = 105
        l.Parent = btn
        FUNHUBUI.fit(l, 10)
        local state = initial and true or false
        local cfgKey = FUNHUBUI.lastKey
        FUNHUBUI.lastKey = nil
        local function paint()
            knob.BackgroundTransparency = state and 0 or 1
            btn.BackgroundColor3 = state and T.GREEN1 or T.OFF_BG
            s.Color = state and T.GREEN_STROKE or T.STROKE
            s.Transparency = state and 0.22 or 0.55
            l.TextColor3 = state and T.ON_TEXT or T.OFF_TEXT
        end
        paint()
        btn.MouseButton1Click:Connect(function()
            state = not state
            paint()
            onToggle(state)
        end)
        if cfgKey then
            FUNHUBUI.cfgChips[cfgKey] = function(v)
                v = v and true or false
                if v == state then return end
                state = v
                paint()
                onToggle(state)
            end
        end
    end

    local function single(order, text, initial, onToggle)
        local r = createRowFrame(30, order)
        bucket[#bucket + 1] = r
        createModernToggle(r, text, initial, onToggle)
        return r
    end

    local function saved(key, apply)
        FUNHUBUI.lastKey = key
        return function(on)
            HubConfig[key] = on
            saveHubConfig()
            if apply then apply(on) end
        end
    end

    tab("Steal")
    header("STEAL", 10)
    local r = pairRow(11)
    chip(r, false, "Potion + Shield", PotionEnabled, saved("potionEnabled", function(on) PotionEnabled = on end))
    chip(r, true, "Show Path", HubConfig.showPathEnabled ~= false, saved("showPathEnabled"))
    bucket[#bucket + 1] = FUNHUBUI.cycleRow(13, "Fly Tool",
        { "Auto", "Flying Carpet", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh" }, "flyTool")
    header("AUTO", 14)
    r = pairRow(15)
    chip(r, false, "TP on Allow", AutoTPOnAllowEnabled, saved("autoTPOnAllowEnabled", function(on) AutoTPOnAllowEnabled = on end))
    chip(r, true, "TP on Unlock", FUNHUBFx.unlockTP, saved("autoTPOnUnlockEnabled", function(on) FUNHUBFx.unlockTP = on end))
    r = pairRow(16)
    chip(r, false, "Base Auto Leave", FUNHUBFx.rejoin2, saved("autoRejoinEnabled", function(on) FUNHUBFx.rejoin2 = on end))
    chip(r, true, "Kick on Deliver", KickAfterStealEnabled, saved("kickAfterStealEnabled", function(on) KickAfterStealEnabled = on end))
    header("GRAB MODES", 17)
    r = pairRow(18)
    chip(r, true, "Public Grab", FUNHUBFx.pubGrab, saved("publicGrabEnabled", function(on) FUNHUBFx.pubGrab = on end))
    r = pairRow(19)
    chip(r, nil, "Defender Bypass", FUNHUBFx.defBypass, saved("defenderBypassEnabled", function(on) FUNHUBFx.defBypass = on end))

    tab("Protect")
    header("PROTECTION", 10)
    r = pairRow(11)
    chip(r, false, "Anti Admin", AntiRocketEnabled, saved("antiRocketEnabled", FUNHUBAntiRocket.set))
    chip(r, true, "Anti Bee", FUNHUBFx.bee, saved("antiBeeEnabled", FUNHUBAntiFx.setBee))
    r = pairRow(12)
    chip(r, false, "Anti Gummy", FUNHUBFx.gummy, saved("antiGummyEnabled", FUNHUBAntiFx.setGummy))
    chip(r, true, "Anti Disco", FUNHUBFx.disco, saved("antiDiscoEnabled", FUNHUBAntiFx.setDisco))
    r = pairRow(13)
    chip(r, false, "Anti Paintball", FUNHUBFx.paint, saved("antiPaintEnabled", FUNHUBAntiFx.setPaint))
    chip(r, true, "Anti Web", FUNHUBFx.web, saved("antiWebEnabled", FUNHUBAntiFx.setWeb))
    r = pairRow(14)
    chip(r, false, "Anti Body Swap", FUNHUBFx.swap, saved("antiSwapEnabled", FUNHUBAntiFx.setSwap))
    chip(r, true, "Anti Ragdoll", AntiRagdollEnabled, saved("antiRagdollEnabled", FUNHUBAntiRagdoll.set))
    header("COMBAT", 15)
    r = pairRow(16)
    chip(r, false, "Destroy Sentry", FUNHUBFx.sentry, saved("destroySentryEnabled", FUNHUBAntiFx.setSentry))
    chip(r, true, "Destroy Doge", FUNHUBFx.doge, saved("destroyDogeEnabled", FUNHUBAntiFx.setDoge))
    r = pairRow(17)
    chip(r, false, "Aimbot", FUNHUBFx.aim, saved("aimbotEnabled", FUNHUBAntiFx.setAim))
    chip(r, true, "Auto Spam", FUNHUBFx.spam, saved("autoSpamEnabled", FUNHUBAntiFx.setSpam))

    tab("Extras")
    header("PLAYERS", 20)
    r = pairRow(21)
    chip(r, false, "Player ESP", FUNHUBFx.esp, saved("playerEspEnabled", FUNHUBAntiFx.setEsp))
    chip(r, true, "Tracers", FUNHUBFx.tracers, saved("tracersEnabled", function(on) FUNHUBFx.tracers = on end))
    r = pairRow(22)
    chip(r, false, "Server Ghost", FUNHUBFx.ghost, saved("serverGhostEnabled", FUNHUBAntiFx.setGhost))
    chip(r, true, "Steal Tags", FUNHUBFx.tags, saved("stealTagsEnabled", function(on) FUNHUBFx.tags = on end))
    header("BASES", 23)
    r = pairRow(24)
    chip(r, false, "Base Timers", FUNHUBFx.timerEsp, saved("baseTimerEspEnabled", function(on) FUNHUBFx.timerEsp = on end))
    chip(r, true, "Every Floor", FUNHUBFx.timerFloors, saved("timerEveryFloorEnabled", function(on) FUNHUBFx.timerFloors = on end))
    r = pairRow(25)
    chip(r, false, "Base ESP", FUNHUBFx.baseEsp, saved("baseEspEnabled", function(on) FUNHUBFx.baseEsp = on end))
    chip(r, true, "Base X-Ray", FUNHUBFx.xray, saved("baseXrayEnabled", function(on) FUNHUBFx.xray = on end))

    tab("Move")
    header("SPEED", 60)
    r = pairRow(61)
    chip(r, false, "Walk Speed", FUNHUBFx.speedOn, saved("moveSpeedEnabled", function(on) FUNHUBFx.speedOn = on end))
    FUNHUBUI.lastKey = "carpetSpeedEnabled"
    chip(r, true, "Carpet Speed", FUNHUBFx.carpet, function(on)
        FUNHUBFx.carpet = on
        HubConfig.carpetSpeedEnabled = on
        saveHubConfig()
        local actions = FUNHUBFx.actions
        if actions and actions.actionsCarpet then actions.actionsCarpet() end
    end)
    bucket[#bucket + 1] = FUNHUBUI.numPair(62, { "Walk", "walkSpeedValue", 28, 16, 80 }, { "Carpet", "carpetSpeedValue", 130, 16, 500 })
    bucket[#bucket + 1] = FUNHUBUI.numPair(63, { "Potion Carry", "giantSpeedValue", 34.8, 16, 40 })
    header("JUMP & GRAVITY", 64)
    r = pairRow(65)
    chip(r, false, "Infinite Jump", FUNHUBFx.infJump, saved("infJumpEnabled", FUNHUBAntiFx.setInfJump))
    chip(r, true, "Gravity", FUNHUBFx.grav, saved("gravityEnabled", function(on) FUNHUBFx.grav = on end))
    bucket[#bucket + 1] = FUNHUBUI.numPair(66, { "Gravity", "gravityValue", 196.2, 0, 300 })
    header("CAMERA", 67)
    r = pairRow(68)
    chip(r, nil, "Custom FOV", FUNHUBFx.fov, saved("customFovEnabled", function(on) FUNHUBFx.fov = on end))
    bucket[#bucket + 1] = FUNHUBUI.slider(69, "FOV", "fovValue", 80, 30, 120)

    tab("Misc")
    header("HUD", 30)
    r = pairRow(31)
    chip(r, false, "Thief Bar", FUNHUBFx.thiefBar, saved("thiefBarEnabled", function(on) FUNHUBFx.thiefBar = on end))
    chip(r, true, "Speed Panel", isSpeedVisible, function(on)
        if HexSpeedFrameRef then
            HexSpeedFrameRef.Visible = on
            HubConfig.hexSpeedVisible = on
            saveHubConfig()
        end
    end)
    r = pairRow(32)
    chip(r, false, "Pill Bar", FUNHUBFx.pillBar, saved("pillBarEnabled", function(on) FUNHUBFx.pillBar = on end))
    chip(r, true, "Hide AP Icon", FUNHUBFx.hideAP, saved("hideApIconEnabled", function(on) FUNHUBFx.hideAP = on end))
    header("PERFORMANCE", 33)
    r = pairRow(34)
    chip(r, false, "FPS Boost", FUNHUBFx.fps, saved("fpsOptimizerEnabled", function(on) FUNHUBFx.fps = on end))
    chip(r, true, "Extreme FPS", FUNHUBFx.xfps, saved("extremeFpsEnabled", function(on) FUNHUBFx.xfps = on end))
    if not IsMobile then header("CONTROLS", 38) end

    header("CONFIGS", 42)
    if FUNHUBUI.configRows then
        for _, row in ipairs(FUNHUBUI.configRows(43)) do bucket[#bucket + 1] = row end
    end
end

local Row4 = createRowFrame(30, 40)
if IsMobile then Row4.Visible = false end
rowLabel(Row4, "Steal Keybind", 0.5)

local KeybindBtn = pillButton(Row4, 56, currentStealKey and currentStealKey.Name or "None")

local isBinding = false
KeybindBtn.MouseButton1Click:Connect(function()
    if FUNHUBKeys.blocked() then return end
    if FUNHUBUI.beginStealBinding then FUNHUBUI.beginStealBinding() return end
    isBinding, FUNHUBUI.bindingInput = true, true
    KeybindBtn.Text = "..."
end)

local ContextActionService = game:GetService("ContextActionService")
local STEAL_ACTION = "FUNHUB_SemiTP_StealKey"

local function bindStealKey()
    pcall(function() ContextActionService:UnbindAction(STEAL_ACTION) end)
    if not currentStealKey then return end
    ContextActionService:BindActionAtPriority(STEAL_ACTION, function(_, state, input)
        if not FUNHUB_ALIVE() then
            pcall(function() ContextActionService:UnbindAction(STEAL_ACTION) end)
            return Enum.ContextActionResult.Pass
        end
        if isBinding or FUNHUBUI.bindingInput or FUNHUBKeys.blocked(input) or UserInputService:GetFocusedTextBox()
            or (FUNHUBUI.pointerInHub and FUNHUBUI.pointerInHub(input)) then
            return Enum.ContextActionResult.Pass
        end
        -- Let the game's normal prompt key handle manual Grab/Place.
        if FUNHUBUI.passQuickGrabKey and FUNHUBUI.passQuickGrabKey(currentStealKey) then
            return Enum.ContextActionResult.Pass
        end
        if state == Enum.UserInputState.Begin and not player:GetAttribute("Stealing") then
            local actions = FUNHUBFx.actions
            if actions and actions.runSemi then actions.runSemi()
            elseif not FUNHUB.debounce then task.spawn(FUNHUB.execute) end
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value + 1000, currentStealKey)
end
bindStealKey()

UserInputService.InputBegan:Connect(function(input)
    if not FUNHUB_ALIVE() or not isBinding then return end
    local key = FUNHUBKeys.input(input)
    if not key then return end
    FUNHUBKeys.consume(input)
    isBinding, FUNHUBUI.bindingInput = false, false
    if key ~= "Escape" then
        HubConfig.funhub.keys.semiSteal = (key ~= "Backspace" and key ~= "Delete") and key or nil
        HubConfig.funhub.keybindSchema = 2
        HubConfig.stealKeybind = HubConfig.funhub.keys.semiSteal or "None"
        currentStealKey = FUNHUBKeys.decode(HubConfig.stealKeybind)
        saveHubConfig()
        bindStealKey()
    end
    KeybindBtn.Text = currentStealKey and currentStealKey.Name or "None"
end)

local mainRows = { RowBase, Row1, InfoRow, Row6, Row5 }
local settingsRows = SettingsRows
settingsRows.Main = mainRows
settingsRows.Misc[#settingsRows.Misc + 1] = Row4

local function paintTab(btn, active)
    tween(btn.Pill, 0.2, { BackgroundTransparency = active and 0 or 1 })
    btn.Label.TextColor3 = active and Color3.fromRGB(255, 255, 255) or T.DIM
    btn.Label.Font = active and Enum.Font.GothamBlack or Enum.Font.GothamBold
end

local function switchTab(tabName)
    for name, btn in pairs(FUNHUBUI.tabBtns) do
        paintTab(btn, name == tabName)
        for _, r in ipairs(settingsRows[name]) do r.Visible = name == tabName end
    end
    if IsMobile then Row4.Visible = false end
end

for name, btn in pairs(FUNHUBUI.tabBtns) do
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end
switchTab("Main")

local SpeedScreenGui = Instance.new("ScreenGui")
SpeedScreenGui.Name = "FUNHUB_SemiTP_Speed"
SpeedScreenGui.ResetOnSpawn = false
SpeedScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SpeedScreenGui.IgnoreGuiInset = true
SpeedScreenGui.DisplayOrder = 999
SpeedScreenGui.Parent = safeGuiTarget

local HexSpeed = Instance.new("Frame")
HexSpeed.Name = "SpeedPanel"
HexSpeed.Size = UDim2.new(0, 210, 0, 0)
HexSpeed.AutomaticSize = Enum.AutomaticSize.Y
HexSpeed.BackgroundColor3 = T.BG
HexSpeed.BorderSizePixel = 0
HexSpeed.Visible = isSpeedVisible
HexSpeed.ZIndex = 100
HexSpeed.Parent = SpeedScreenGui
HexSpeedFrameRef = HexSpeed
corner(HexSpeed, 18)
stroke(HexSpeed, T.STROKE, 1.2, 0.4)
addShadow(HexSpeed)

local SpeedPad = Instance.new("UIPadding")
SpeedPad.PaddingBottom = UDim.new(0, 10)
SpeedPad.Parent = HexSpeed

HexSpeed.AnchorPoint = Vector2.new(1, 0)
if HubConfig.speedPos and HubConfig.speedPos.ScaleX ~= 0.5 then
    HexSpeed.Position = UDim2.new(HubConfig.speedPos.ScaleX, HubConfig.speedPos.OffsetX, HubConfig.speedPos.ScaleY, HubConfig.speedPos.OffsetY)
else
    HexSpeed.Position = UDim2.new(0.98, 0, 0.04, 0)
end

local SpeedHeader = Instance.new("Frame")
SpeedHeader.Size = UDim2.new(1, 0, 0, 36)
SpeedHeader.BackgroundTransparency = 1
SpeedHeader.ZIndex = 101
SpeedHeader.Parent = HexSpeed

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(1, -28, 0, 22)
SpeedTitle.Position = UDim2.new(0, 14, 0, 7)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "STEAL SPEED"
SpeedTitle.Font = Enum.Font.GothamBlack
SpeedTitle.TextSize = 16
SpeedTitle.TextColor3 = T.TEXT
SpeedTitle.ZIndex = 102
SpeedTitle.Parent = SpeedHeader

local SpeedRule = Instance.new("Frame")
SpeedRule.AnchorPoint = Vector2.new(0.5, 0)
SpeedRule.Position = UDim2.new(0.5, 0, 0, 32)
SpeedRule.Size = UDim2.new(0, 110, 0, 1)
SpeedRule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedRule.BackgroundTransparency = 0.15
SpeedRule.BorderSizePixel = 0
SpeedRule.ZIndex = 101
SpeedRule.Parent = HexSpeed

local SpeedCard = Instance.new("Frame")
SpeedCard.AutomaticSize = Enum.AutomaticSize.Y
SpeedCard.Size = UDim2.new(1, -20, 0, 0)
SpeedCard.Position = UDim2.fromOffset(10, 40)
SpeedCard.BackgroundColor3 = T.SURF
SpeedCard.BorderSizePixel = 0
SpeedCard.ZIndex = 101
SpeedCard.Parent = HexSpeed
corner(SpeedCard, 16)
stroke(SpeedCard, T.STROKE, 1, 0.48)

local SpeedCardPad = Instance.new("UIPadding")
SpeedCardPad.PaddingTop, SpeedCardPad.PaddingBottom = UDim.new(0, 4), UDim.new(0, 4)
SpeedCardPad.PaddingLeft, SpeedCardPad.PaddingRight = UDim.new(0, 4), UDim.new(0, 4)
SpeedCardPad.Parent = SpeedCard

local SpeedList = Instance.new("UIListLayout", SpeedCard)
SpeedList.SortOrder = Enum.SortOrder.LayoutOrder
SpeedList.Padding = UDim.new(0, 6)

local function speedRow(order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = T.SURF2
    row.BackgroundTransparency = 0.02
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 103
    row.Parent = SpeedCard
    corner(row, 11)
    local rs = stroke(row, T.STROKE, 1, 0.52)
    addHover(row, T.SURF2, T.HOVER, rs)
    return row
end

local BoostRow = speedRow(1)
createModernToggle(BoostRow, "Auto on Steal", _G.FUNHUB_SemiTP_SpeedBoost, function(newState)
    _G.FUNHUB_SemiTP_SpeedBoost = newState
    HubConfig.stealBoostAutoOnSteal = newState
    saveHubConfig()
end)

local SpeedValueRow = speedRow(2)
rowLabel(SpeedValueRow, "Speed (max " .. STEAL_SPEED_MAX .. ")", 0.6)

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.fromOffset(56, 22)
InputBox.Position = UDim2.new(1, -66, 0.5, -11)
InputBox.BackgroundColor3 = T.OFF_BG
InputBox.BorderSizePixel = 0
InputBox.Text = tostring(stealSpeed())
InputBox.TextColor3 = T.TEXT
InputBox.Font = Enum.Font.GothamBold
InputBox.TextSize = 11
InputBox.ClearTextOnFocus = false
InputBox.ZIndex = 104
InputBox.Parent = SpeedValueRow
corner(InputBox, 7)
stroke(InputBox, T.STROKE, 1, 0.55)

InputBox.FocusLost:Connect(function()
    local num = tonumber(InputBox.Text)
    if num then
        num = math.clamp(math.floor(num + 0.5), STEAL_SPEED_MIN, STEAL_SPEED_MAX)
        currentSpeed = num
        HubConfig.speedValue = num
        saveHubConfig()
    end
    InputBox.Text = tostring(stealSpeed())
end)

makeDraggable(SpeedHeader, HexSpeed, function()
    HubConfig.speedPos = { ScaleX = HexSpeed.Position.X.Scale, OffsetX = HexSpeed.Position.X.Offset, ScaleY = HexSpeed.Position.Y.Scale, OffsetY = HexSpeed.Position.Y.Offset }
    saveHubConfig()
end)

do
    local function makePill(name, titleText)
        local bb = Instance.new("BillboardGui")
        bb.Name = name
        bb.Size = UDim2.fromOffset(120, 32)
        bb.StudsOffset = Vector3.new(0, 2.6, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 100000
        bb.Enabled = false
        bb.Parent = AllowDisallowGui

        local pill = Instance.new("Frame")
        pill.Size = UDim2.fromScale(1, 1)
        pill.BackgroundColor3 = T.BG
        pill.BorderSizePixel = 0
        pill.Parent = bb
        pill.BackgroundTransparency = 0.12
        corner(pill, 16)
        local pillStroke = stroke(pill, T.ACCENT, 1.5, 0.1)
        gradient(pill, T.SURF2, T.BG, 90)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -14, 0, 15)
        title.Position = UDim2.fromOffset(7, 3)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 13
        title.TextScaled = false
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.TextColor3 = T.TEXT
        title.TextStrokeTransparency = 0.6
        title.Text = titleText
        title.Parent = pill

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -14, 0, 11)
        sub.Position = UDim2.fromOffset(7, 18)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 9
        sub.TextColor3 = T.DIM
        sub.TextTruncate = Enum.TextTruncate.AtEnd
        sub.Text = ""
        sub.Parent = pill
        return { bb = bb, title = title, sub = sub, stroke = pillStroke }
    end

    local target = makePill("FUNHUB_SemiTP_TargetPill", "TARGET")
    local bb, sub, pillStroke = target.bb, target.sub, target.stroke
    local intruders = {}
    local tracers, myAtt = {}, nil

    local COL_STEAL = Color3.fromRGB(255, 110, 130)
    local COL_IN = Color3.fromRGB(110, 235, 160)

    local function ownerOf(plot)
        local name = plotOwnerName(plot)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == name or p.DisplayName == name then return p end
        end
        return nil
    end

    local boxes = setmetatable({}, { __mode = "k" })
    local function insidePlot(plot, pos)
        if not plot then return false end
        local box = boxes[plot]
        if not box then
            local ok, cf, size = pcall(plot.GetBoundingBox, plot)
            box = ok and { cf, size } or false
            boxes[plot] = box
        end
        if not box then return false end
        local l = box[1]:PointToObjectSpace(pos)
        return math.abs(l.X) <= box[2].X / 2 and math.abs(l.Z) <= box[2].Z / 2
    end

    task.spawn(function()
        while FUNHUB_ALIVE() and bb.Parent do
            local podium = getTargetPodiumForSlot(selectedSlot)
            local plot = targetPlot or (podium and podium.Parent and podium.Parent.Parent)
            local owner = plot and ownerOf(plot)
            local head = owner and owner.Character and owner.Character:FindFirstChild("Head")
            local root = owner and owner.Character and owner.Character:FindFirstChild("HumanoidRootPart")
            if head and root then
                bb.Adornee = head
                bb.Enabled = true
                local idx = owner:GetAttribute("StealingIndex")
                local col
                if owner:GetAttribute("Stealing") then
                    sub.Text = (idx ~= nil and idx ~= "") and ('STEALING "' .. string.upper(tostring(idx)) .. '"') or "STEALING"
                    col = COL_STEAL
                elseif insidePlot(findMyBase(), root.Position) then
                    sub.Text = "INSIDE YOUR BASE !!"
                    col = COL_STEAL
                elseif insidePlot(plot, root.Position) then
                    sub.Text = "INSIDE HIS BASE"
                    col = COL_IN
                else
                    sub.Text = "OUTSIDE BASE"
                    col = T.ACCENT
                end
                sub.TextColor3 = col
                pillStroke.Color = col
                pillStroke.Transparency = (col == COL_STEAL and (os.clock() % 0.6 < 0.3)) and 0.6 or 0.1
            else
                bb.Enabled = false
                bb.Adornee = nil
            end

            local myPlot = findMyBase()
            local seen = {}
            for _, p in ipairs(Players:GetPlayers()) do
                local ch = p.Character
                local h = ch and ch:FindFirstChild("Head")
                local r = ch and ch:FindFirstChild("HumanoidRootPart")
                if p ~= player and p ~= owner and h and r and insidePlot(myPlot, r.Position) then
                    seen[p] = true
                    local pl = intruders[p]
                    if not pl then
                        pl = makePill("FUNHUB_SemiTP_IntruderPill", p.Name)
                        intruders[p] = pl
                    end
                    pl.title.Text = p.Name
                    pl.bb.Adornee = h
                    pl.bb.Enabled = true
                    local pidx = p:GetAttribute("StealingIndex")
                    if p:GetAttribute("Stealing") then
                        pl.sub.Text = (pidx ~= nil and pidx ~= "") and ('STEALING "' .. string.upper(tostring(pidx)) .. '"') or "STEALING"
                    else
                        pl.sub.Text = "INSIDE YOUR BASE !!"
                    end
                    pl.sub.TextColor3 = COL_STEAL
                    pl.stroke.Color = COL_STEAL
                    pl.stroke.Transparency = (os.clock() % 0.6 < 0.3) and 0.6 or 0.1
                end
            end
            for p, pl in pairs(intruders) do
                if not seen[p] then
                    pl.bb:Destroy()
                    intruders[p] = nil
                end
            end

            local want = {}
            local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if FUNHUBFx.tracers and myHrp then
                if owner and root then want[owner] = { root, T.ACCENT } end
                for p in pairs(seen) do
                    local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if r then want[p] = { r, COL_STEAL } end
                end
                if not myAtt or myAtt.Parent ~= myHrp then
                    if myAtt then myAtt:Destroy() end
                    myAtt = Instance.new("Attachment")
                    myAtt.Name = "FUNHUB_SemiTP_Tracer"
                    myAtt.Parent = myHrp
                end
            end
            for p, tr in pairs(tracers) do
                local w = want[p]
                if not w or tr.att.Parent ~= w[1] or tr.beam.Attachment0 ~= myAtt then
                    tr.att:Destroy()
                    tracers[p] = nil
                end
            end
            for p, w in pairs(want) do
                local tr = tracers[p]
                if not tr then
                    local att = Instance.new("Attachment")
                    att.Name = "FUNHUB_SemiTP_Tracer"
                    att.Parent = w[1]
                    local beam = Instance.new("Beam")
                    beam.Attachment0, beam.Attachment1 = myAtt, att
                    beam.Width0, beam.Width1 = 0.12, 0.12
                    beam.FaceCamera = true
                    beam.LightEmission = 1
                    beam.Segments = 1
                    beam.Parent = att
                    tr = { att = att, beam = beam }
                    tracers[p] = tr
                end
                tr.beam.Color = ColorSequence.new(w[2])
            end
            if not FUNHUBFx.tracers and myAtt then myAtt:Destroy(); myAtt = nil end
            task.wait(0.15)
        end
        bb:Destroy()
        for _, pl in pairs(intruders) do pl.bb:Destroy() end
        for _, tr in pairs(tracers) do tr.att:Destroy() end
        if myAtt then myAtt:Destroy() end
    end)
end

do
    local FADE = 0.9
    local FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases" }
    local faded, queue, conns = {}, {}, {}
    local on = false

    local function one(d)
        if d:IsA("BasePart") and not faded[d] then
            faded[d] = true
            d.LocalTransparencyModifier = FADE
        end
    end

    local function track(root)
        if not root then return end
        one(root)
        for _, d in ipairs(root:GetDescendants()) do one(d) end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(d) queue[#queue + 1] = d end)
    end

    local function doPlot(plot)
        for _, name in ipairs(FOLDERS) do track(plot:FindFirstChild(name)) end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(c)
            if table.find(FOLDERS, c.Name) then task.defer(track, c) end
        end)
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return end
        local function pod(pd)
            track(pd:FindFirstChild("Claim"))
            local b = pd:FindFirstChild("Base")
            track(b and b:FindFirstChild("Decorations"))
        end
        for _, pd in ipairs(pods:GetChildren()) do pod(pd) end
        conns[#conns + 1] = pods.ChildAdded:Connect(function(pd) task.delay(0.1, pod, pd) end)
    end

    local function enable()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return false end
        for _, p in ipairs(plots:GetChildren()) do pcall(doPlot, p) end
        conns[#conns + 1] = plots.ChildAdded:Connect(function(p) task.delay(0.2, function() if on then pcall(doPlot, p) end end) end)
        return true
    end

    local function disable()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        table.clear(conns); table.clear(queue)
        for p in pairs(faded) do pcall(function() if p.Parent then p.LocalTransparencyModifier = 0 end end) end
        table.clear(faded)
    end

    task.spawn(function()
        while FUNHUB_ALIVE() do
            if FUNHUBFx.xray and not on then
                on = enable()
            elseif not FUNHUBFx.xray and on then
                on = false
                disable()
            end
            if on and #queue > 0 then
                local batch = queue
                queue = {}
                for _, d in ipairs(batch) do if d.Parent then pcall(one, d) end end
            end
            task.wait(0.2)
        end
        disable()
    end)
end

_G.FUNHUB_SemiTP = FUNHUB
FUNHUB_ENV.FUNHUB_SemiTP = FUNHUB
table.insert(FUNHUB_ENV.FUNHUB_SemiTP_Tables, FUNHUB)
_G.FUNHUB_SemiTP_Steal = function() pcall(FUNHUB.execute) end
_G.FUNHUB_SemiTP_SetPodium = function(slot) FUNHUB.setSlot(slot) end

FUNHUB.debounce = false

;(function()
    local function viewport()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize
        if not vp or vp.X < 2 or vp.Y < 2 then vp = Vector2.new(1920, 1080) end
        return vp
    end
    function FUNHUBUI.uiFactor()
        local vp = viewport()
        if IsMobile then
            local short = math.min(vp.X, vp.Y)
            return math.clamp(short / (short < 500 and 430 or 650), 0.6, 1.15)
        end
        return math.clamp(math.min(vp.X / 1920, vp.Y / 1080), 0.7, 1.35)
    end

    local fitted = { { MainFrame, 1.2 }, { HexSpeed, 1.2 }, { PBarMain, 1 }, { MainAllowBtn, 1 } }
    local scalers = {}
    for i, e in ipairs(fitted) do
        local s = e[1]:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        s.Parent = e[1]
        scalers[i] = s
    end

    local function keepOnScreen(frame)
        local sg = frame:FindFirstAncestorOfClass("ScreenGui")
        if not sg or not frame.Visible then return end
        local bounds, pos, size = sg.AbsoluteSize, frame.AbsolutePosition, frame.AbsoluteSize
        local dx, dy = 0, 0
        if pos.X < 0 then dx = -pos.X elseif pos.X + size.X > bounds.X then dx = bounds.X - (pos.X + size.X) end
        if pos.Y < 0 then dy = -pos.Y elseif pos.Y + size.Y > bounds.Y then dy = bounds.Y - (pos.Y + size.Y) end
        if math.abs(dx) > 0.5 or math.abs(dy) > 0.5 then
            frame.Position = frame.Position + UDim2.fromOffset(math.floor(dx), math.floor(dy))
        end
    end

    local busy = false
    local function update()
        if busy or not FUNHUB_ALIVE() then return end
        busy = true
        local f, vp = FUNHUBUI.uiFactor(), viewport()
        for i, e in ipairs(fitted) do
            local s = f * e[2]
            if e[1] == MainFrame then
                local cur = scalers[i].Scale
                local baseH = cur > 0 and MainFrame.AbsoluteSize.Y / cur or 0
                if baseH > 0 then s = math.min(s, vp.Y * 0.8 / baseH) end
            end
            s = math.clamp(s, 0.5, 1.6)
            if math.abs(scalers[i].Scale - s) > 0.01 then scalers[i].Scale = s end
        end
        task.defer(function()
            for _, e in ipairs(fitted) do pcall(keepOnScreen, e[1]) end
            busy = false
        end)
    end
    FUNHUBUI.fitUI = update

    update()
    local camConn
    local function watchCam()
        if camConn then camConn:Disconnect() end
        local cam = Workspace.CurrentCamera
        if cam then camConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(update) end
        update()
    end
    watchCam()
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCam)
    MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() task.defer(update) end)

    local function fitBillboard(bb)
        if not bb:IsA("BillboardGui") then return end
        task.defer(function()
            if not bb.Parent then return end
            local w, h = bb:GetAttribute("__semiW"), bb:GetAttribute("__semiH")
            if not w then
                if bb.Size.X.Scale ~= 0 or bb.Size.Y.Scale ~= 0 then return end
                w, h = bb.Size.X.Offset, bb.Size.Y.Offset
                bb:SetAttribute("__semiW", w)
                bb:SetAttribute("__semiH", h)
            end
            local f = FUNHUBUI.uiFactor()
            bb.Size = UDim2.fromOffset(w * f, h * f)
            local sc = bb:FindFirstChild("__semiScale") or Instance.new("UIScale")
            sc.Name = "__semiScale"
            sc.Scale = f
            sc.Parent = bb
        end)
    end
    for _, d in ipairs(AllowDisallowGui:GetDescendants()) do fitBillboard(d) end
    AllowDisallowGui.DescendantAdded:Connect(fitBillboard)
    local lastF = FUNHUBUI.uiFactor()
    task.spawn(function()
        while FUNHUB_ALIVE() do
            task.wait(1)
            local f = FUNHUBUI.uiFactor()
            if math.abs(f - lastF) > 0.01 then
                lastF = f
                for _, d in ipairs(AllowDisallowGui:GetDescendants()) do fitBillboard(d) end
            end
        end
    end)
end)()

;(function()
    local POP_ID = "rbxassetid://102289499477049"
    local HOVER_IDS = { "rbxassetid://95003901725897", "rbxassetid://72335876826381", "rbxassetid://82122230376488" }
    local sounds = {}
    local function play(id, vol)
        local s = sounds[id]
        if not s or not s.Parent then
            local ok, made = pcall(function()
                local n = Instance.new("Sound")
                n.Name = "__SemiTPUISound"
                n.SoundId = id
                n.Volume = vol
                n.Parent = ScreenGui
                return n
            end)
            s = ok and made or nil
            sounds[id] = s
        end
        if s then pcall(function() s.TimePosition = 0; s:Play() end) end
    end
    task.defer(function()
        for _, id in ipairs({ POP_ID, table.unpack(HOVER_IDS) }) do
            play(id, 0)
            if sounds[id] then pcall(function() sounds[id]:Stop() end) end
        end
    end)
    local hooked = setmetatable({}, { __mode = "k" })
    local function hook(b)
        if hooked[b] or not b:IsA("GuiButton") then return end
        hooked[b] = true
        local sc
        if not b:GetAttribute("__semiNoPop") and not (b.Text == "" and b:FindFirstChildWhichIsA("GuiObject") == nil) then
            sc = b:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
            sc.Parent = b
        end
        local over = false
        local function to(s, t, style)
            if sc then
                TweenService:Create(sc, TweenInfo.new(t, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = s }):Play()
            end
        end
        b.Activated:Connect(function()
            play(POP_ID, 0.6)
            if sc then
                sc.Scale = 0.92
                to(over and 1.04 or 1, 0.22, Enum.EasingStyle.Back)
            end
        end)
        b.MouseEnter:Connect(function()
            over = true
            play(HOVER_IDS[math.random(1, #HOVER_IDS)], 0.12)
            to(1.04, 0.12)
        end)
        b.MouseLeave:Connect(function()
            over = false
            to(1, 0.12)
        end)
    end
    for _, gui in ipairs({ ScreenGui, SpeedScreenGui, AllowDisallowGui, ProgressGui }) do
        for _, d in ipairs(gui:GetDescendants()) do hook(d) end
        gui.DescendantAdded:Connect(hook)
    end
end)()

;(function()
local FUNHUBAur = {
    RED = Color3.fromRGB(255, 110, 130),
    GREEN = Color3.fromRGB(110, 235, 160),
    YELLOW = Color3.fromRGB(255, 205, 90),
    INVIS = Color3.fromRGB(195, 135, 255),
}

function FUNHUBAur.pill()
    local t = FUNHUBAur.tag(120, 32)
    t.lbl.Size = UDim2.new(1, -14, 0, 15)
    t.lbl.Position = UDim2.fromOffset(7, 3)
    t.lbl.TextSize = 13
    t.lbl.TextStrokeTransparency = 0.6
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -14, 0, 11)
    sub.Position = UDim2.fromOffset(7, 18)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 9
    sub.TextTruncate = Enum.TextTruncate.AtEnd
    sub.Parent = t.lbl.Parent
    t.sub = sub
    return t
end

function FUNHUBAur.paint2(t, title, status, col)
    if t.lbl.Text ~= title then t.lbl.Text = title end
    if t.sub.Text ~= status then t.sub.Text = status end
    t.lbl.TextColor3 = T.TEXT
    t.sub.TextColor3 = col
    t.stroke.Color = col
    t.bb.Enabled = true
end

function FUNHUBAur.tag(w, h)
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.fromOffset(w, h)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 100000
    bb.Enabled = false
    bb.Parent = AllowDisallowGui
    local f = Instance.new("Frame")
    f.Size = UDim2.fromScale(1, 1)
    f.BackgroundColor3 = T.BG
    f.BackgroundTransparency = 0.12
    f.BorderSizePixel = 0
    f.Parent = bb
    corner(f, h // 2)
    gradient(f, T.SURF2, T.BG, 90)
    local s = stroke(f, T.ACCENT, 1.5, 0.1)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 1, 0)
    l.Position = UDim2.fromOffset(5, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBlack
    l.TextSize = 11
    l.TextColor3 = T.TEXT
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = f
    return { bb = bb, lbl = l, stroke = s }
end

function FUNHUBAur.paint(t, text, col)
    if t.lbl.Text ~= text then t.lbl.Text = text end
    t.lbl.TextColor3 = col
    t.stroke.Color = col
    t.bb.Enabled = true
end

function FUNHUBAur.timerState(plot)
    local pur = plot:FindFirstChild("Purchases")
    local pb = pur and pur:FindFirstChild("PlotBlock")
    local main = pb and pb:FindFirstChild("Main")
    local gui = main and main:FindFirstChild("BillboardGui")
    if not gui then return nil end
    local rt = gui:FindFirstChild("RemainingTime")
    if not rt or not rt.Visible then return "UNLOCKED", FUNHUBAur.GREEN, main, nil end
    local n = tonumber(rt.Text:match("(%d+)"))
    local ts = n and (n >= 60 and string.format("%d:%02d", n // 60, n % 60) or (n .. "s")) or ""
    local delay = gui:FindFirstChild("Delay")
    if delay and delay.Visible then return "RELOCK IN " .. ts, FUNHUBAur.YELLOW, main, n end
    return "LOCKED " .. ts, FUNHUBAur.RED, main, n
end

function FUNHUBAur.hitbox(plot)
    local h = plot and plot:FindFirstChild("StealHitbox", true)
    return h and h:IsA("BasePart") and h or nil
end

function FUNHUBAur.inBox(part, pos)
    if not part then return false end
    local l = part.CFrame:PointToObjectSpace(pos)
    return math.abs(l.X) <= part.Size.X / 2 and math.abs(l.Z) <= part.Size.Z / 2
end

;(function()
    local boards, boxes = {}, {}
    local function clearBoards(plot)
        for _, t in ipairs(boards[plot] or {}) do t.bb:Destroy() end
        boards[plot] = nil
    end
    local function floorsOf(plot)
        local list = {}
        local un = plot:FindFirstChild("Unlock")
        for _, c in ipairs(un and un:GetChildren() or {}) do
            local ub = c:FindFirstChild("UnlockBase")
            if c:IsA("BasePart") and ub and ub:GetAttribute("Floor") then list[#list + 1] = c end
        end
        table.sort(list, function(a, b) return a.Position.Y < b.Position.Y end)
        return list
    end
    local function unlockPrompt(plot, anchor)
        local un = plot and plot:FindFirstChild("Unlock")
        if not un then return nil end
        if anchor and anchor.Parent == un then
            local pp = anchor:FindFirstChild("UnlockBase")
            return pp and pp:IsA("ProximityPrompt") and pp or nil
        end
        local best
        for _, c in ipairs(un:GetChildren()) do
            local pp = c:FindFirstChild("UnlockBase")
            if pp and pp:IsA("ProximityPrompt") and pp.Enabled and c:IsA("BasePart")
                and (not best or c.Position.Y < best.Parent.Position.Y) then
                best = pp
            end
        end
        return best
    end
    local function openUnlock(t)
        if not t.plot or t.plot == findMyBase() then return end
        local pp = unlockPrompt(t.plot, t.anchor)
        if not pp or not pp.Enabled then
            setStealStatus("THAT FLOOR ISN'T LOCKED", false)
            return
        end
        setStealStatus("OPENING UNLOCK...", nil)
        if firesignal then
            pcall(firesignal, pp.Triggered, player)
        elseif fireproximityprompt then
            pcall(fireproximityprompt, pp)
        end
    end
    local function clickable(t)
        t.bb.Active = true
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromScale(1, 1)
        b.BackgroundTransparency = 1
        b.Text = ""
        b.ZIndex = 5
        b.Parent = t.lbl.Parent
        local last = 0
        b.MouseButton1Click:Connect(function()
            local now = os.clock()
            if now - last <= 0.4 then
                last = 0
                openUnlock(t)
            else
                last = now
            end
        end)
    end
    task.spawn(function()
        while FUNHUB_ALIVE() do
            local plots = Workspace:FindFirstChild("Plots")
            local mine = findMyBase()
            local seen = {}
            for _, plot in ipairs(plots and plots:GetChildren() or {}) do
                local owner = plotOwnerName(plot)
                local empty = owner == "?" or owner == "Empty Base"
                local text, col, main = FUNHUBAur.timerState(plot)
                if FUNHUBFx.timerEsp and text and not empty then
                    seen[plot] = true
                    local anchors = FUNHUBFx.timerFloors and floorsOf(plot) or {}
                    if #anchors == 0 then anchors = { main } end
                    local list = boards[plot]
                    if not list or #list ~= #anchors then
                        clearBoards(plot)
                        list = {}
                        for _ = 1, #anchors do
                            local t = FUNHUBAur.pill()
                            clickable(t)
                            list[#list + 1] = t
                        end
                        boards[plot] = list
                    end
                    local who = plot == mine and "YOUR BASE" or owner
                    for i, t in ipairs(list) do
                        t.plot, t.anchor = plot, anchors[i]
                        t.bb.Adornee = anchors[i]
                        t.bb.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
                        FUNHUBAur.paint2(t, who, (#list > 1 and ("FLOOR " .. i .. "  ·  ") or "") .. text, col)
                    end
                end
                local hb = FUNHUBFx.baseEsp and not empty and FUNHUBAur.hitbox(plot)
                if hb then
                    local sb = boxes[plot]
                    if not sb or not sb.Parent then
                        sb = Instance.new("SelectionBox")
                        sb.LineThickness = 0.12
                        sb.SurfaceTransparency = 1
                        sb.Parent = AllowDisallowGui
                        boxes[plot] = sb
                    end
                    sb.Adornee = hb
                    sb.Color3 = plot == mine and FUNHUBAur.GREEN or (col == FUNHUBAur.RED and FUNHUBAur.RED or T.ACCENT)
                elseif boxes[plot] then
                    boxes[plot]:Destroy()
                    boxes[plot] = nil
                end
            end
            for plot in pairs(boards) do
                if not seen[plot] then clearBoards(plot) end
            end
            for plot, sb in pairs(boxes) do
                if not plot.Parent then sb:Destroy() boxes[plot] = nil end
            end
            task.wait(0.25)
        end
        for plot in pairs(boards) do clearBoards(plot) end
        for _, sb in pairs(boxes) do sb:Destroy() end
    end)
end)()

;(function()
    local tags, lights = {}, {}
    local function invisible(ch)
        local lvl = ch:GetAttribute("InvisibilityLevel")
        if type(lvl) ~= "number" or lvl <= 0 then return false end
        for _, m in ipairs(ch:GetChildren()) do
            if m:IsA("Model") then
                local n = 0
                for _, d in ipairs(m:GetDescendants()) do
                    if d:IsA("BasePart") then n = n + 1 if n >= 2 then return false end end
                end
            end
        end
        return true
    end
    task.spawn(function()
        while FUNHUB_ALIVE() do
            local seen = {}
            if FUNHUBFx.tags then
                for _, p in ipairs(Players:GetPlayers()) do
                    local ch = p ~= player and p.Character
                    local head = ch and ch:FindFirstChild("Head")
                    if head then
                        local st = p:GetAttribute("Stealing")
                        local stealing = st ~= nil and st ~= false
                        local inv = invisible(ch)
                        if stealing or inv then
                            seen[p] = true
                            local t = tags[p]
                            if not t then
                                t = FUNHUBAur.tag(130, 18)
                                t.bb.StudsOffset = Vector3.new(0, 2.6, 0)
                                t.bb.SizeOffset = Vector2.new(0, 1.7)
                                tags[p] = t
                            end
                            t.bb.Adornee = head
                            local idx = p:GetAttribute("StealingIndex")
                            local s = stealing and ((idx ~= nil and idx ~= "") and ('STEALING "' .. string.upper(tostring(idx)) .. '"') or "STEALING") or nil
                            FUNHUBAur.paint(t, inv and (s and ("INVISIBLE · " .. s) or "INVISIBLE") or s, inv and FUNHUBAur.INVIS or FUNHUBAur.RED)
                            if inv then
                                local hl = lights[p]
                                if not hl or not hl.Parent then
                                    hl = Instance.new("Highlight")
                                    hl.FillColor = FUNHUBAur.INVIS
                                    hl.OutlineColor = FUNHUBAur.INVIS
                                    hl.FillTransparency = 0.6
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Parent = AllowDisallowGui
                                    lights[p] = hl
                                end
                                hl.Adornee = ch
                            elseif lights[p] then
                                lights[p]:Destroy()
                                lights[p] = nil
                            end
                        end
                    end
                end
            end
            for p, t in pairs(tags) do
                if not seen[p] then t.bb:Destroy() tags[p] = nil end
            end
            for p, hl in pairs(lights) do
                if not seen[p] then hl:Destroy() lights[p] = nil end
            end
            task.wait(0.15)
        end
        for _, t in pairs(tags) do t.bb:Destroy() end
        for _, hl in pairs(lights) do hl:Destroy() end
    end)
end)()

;(function()
    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(0.5, 0)
    bar.Position = UDim2.new(0.5, 0, 0, 70)
    bar.Size = UDim2.fromOffset(320, 50)
    bar.BackgroundColor3 = T.SURF
    bar.BackgroundTransparency = 0.02
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.ZIndex = 80
    bar.Parent = ProgressGui
    corner(bar, 12)
    gradient(bar, T.SURF2, T.BG, 90)
    stroke(bar, T.STROKE, 1, 0.35)
    local barStroke = stroke(bar, T.ACCENT, 3, 0.6)
    addShadow(bar, 20)
    local barScale = Instance.new("UIScale")
    barScale.Parent = bar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 0, 14)
    title.Position = UDim2.fromOffset(7, 4)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 11
    title.TextColor3 = T.TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    FUNHUBUI.fit(title, 11)
    title.ZIndex = 82
    title.Parent = bar
    local hitBtn = Instance.new("TextButton")
    hitBtn.AnchorPoint = Vector2.new(1, 0.5)
    hitBtn.Position = UDim2.new(1, -6, 0.5, 0)
    hitBtn.Size = UDim2.fromOffset(76, 40)
    hitBtn.AutoButtonColor = false
    hitBtn.BackgroundTransparency = 1
    hitBtn.BorderSizePixel = 0
    hitBtn.Text = ""
    hitBtn.ZIndex = 85
    hitBtn.Parent = bar
    local hitFace = Instance.new("Frame")
    hitFace.Size = UDim2.fromScale(1, 1)
    hitFace.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hitFace.BorderSizePixel = 0
    hitFace.ZIndex = 85
    hitFace.Parent = hitBtn
    corner(hitFace, 10)
    gradient(hitFace, Color3.fromRGB(255, 70, 90), Color3.fromRGB(185, 15, 45), 90)
    local hitStroke = stroke(hitFace, Color3.fromRGB(255, 255, 255), 2, 0)
    local hitLbl = Instance.new("TextLabel")
    hitLbl.Size = UDim2.new(1, -8, 1, 0)
    hitLbl.Position = UDim2.fromOffset(4, 0)
    hitLbl.BackgroundTransparency = 1
    hitLbl.Font = Enum.Font.GothamBlack
    hitLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    hitLbl.TextStrokeColor3 = Color3.fromRGB(60, 0, 15)
    hitLbl.TextStrokeTransparency = 0
    hitLbl.Text = "HIT"
    hitLbl.ZIndex = 86
    hitLbl.Parent = hitBtn
    FUNHUBUI.fit(hitLbl, 22, 4)
    hitBtn:GetPropertyChangedSignal("Text"):Connect(function()
        if hitBtn.Text ~= "" then hitLbl.Text = hitBtn.Text hitBtn.Text = "" end
    end)
    hitBtn.MouseEnter:Connect(function() tween(hitStroke, 0.14, { Color = Color3.fromRGB(255, 230, 120) }) end)
    hitBtn.MouseLeave:Connect(function() tween(hitStroke, 0.14, { Color = Color3.fromRGB(255, 255, 255) }) end)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -94, 0, 20)
    track.Position = UDim2.fromOffset(6, 22)
    track.BackgroundColor3 = T.TRACK
    track.BorderSizePixel = 0
    track.ZIndex = 82
    track.Parent = bar
    corner(track, 8)
    stroke(track, T.STROKE, 1, 0.55)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(0, 1)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 83
    fill.Parent = track
    corner(fill, 8)
    gradient(fill, T.FILL1, T.FILL2)
    local pct = Instance.new("TextLabel")
    pct.Size = UDim2.fromScale(1, 1)
    pct.BackgroundTransparency = 1
    pct.Font = Enum.Font.GothamBold
    pct.TextSize = 11
    pct.TextColor3 = T.TEXT
    pct.TextStrokeTransparency = 0.7
    pct.Text = ""
    pct.ZIndex = 84
    pct.Parent = track

    local lastIn, thieves = {}, {}
    local shown, hunting = nil, false
    local pendingHome, pendingUntil = nil, 0

    local RANGED = {}
    for _, n in ipairs({ "Laser Cape", "Taser Gun", "Freeze Ray", "Web Slinger", "Paintball Gun", "Slingshot",
        "Snowball", "Jelly Gun", "Hunter Crossbow", "Candycane Bow", "Gravity Gun", "Tripple Plungers",
        "Zombie Blaster", "Lava Blaster", "Summer Soaker", "Candy Launcher", "Pumpkin Launcher" }) do RANGED[n] = true end
    local function pickWeapon()
        local ch, bp = player.Character, player:FindFirstChild("Backpack")
        local melee, ranged
        for _, cont in ipairs({ ch, bp }) do
            for _, t in ipairs(cont and cont:GetChildren() or {}) do
                if t:IsA("Tool") then
                    if t.Name == "Bat" or t.Name:find("Slap", 1, true) then melee = melee or t
                    elseif RANGED[t.Name] then ranged = ranged or t end
                end
            end
        end
        return melee or ranged, melee ~= nil
    end
    local mouse
    pcall(function() mouse = require(ReplicatedStorage.Packages.PlayerMouse) end)
    local steerRp = RaycastParams.new()
    steerRp.FilterType = Enum.RaycastFilterType.Exclude
    steerRp.RespectCanCollide = true
    local function steer(hrp, dest, speed, ignore)
        local d = dest - hrp.Position
        local dist = d.Magnitude
        if dist < 0.05 then return Vector3.zero end
        local dir = d.Unit
        steerRp.FilterDescendantsInstances = { player.Character, ignore }
        local look = math.min(dist, 14)
        local o = hrp.Position
        local ahead = Workspace:Raycast(o, dir * look, steerRp)
            or Workspace:Raycast(o + Vector3.new(0, -2.2, 0), dir * look, steerRp)
        if not ahead then return dir * speed end
        local flat = Vector3.new(dir.X, 0, dir.Z)
        flat = flat.Magnitude > 0.01 and flat.Unit or Vector3.zero
        if not Workspace:Raycast(o, Vector3.new(0, 7, 0), steerRp) then
            return (Vector3.new(0, 1, 0) * 0.85 + flat * 0.3).Unit * speed
        end
        local side = flat:Cross(Vector3.new(0, 1, 0))
        if side.Magnitude < 0.01 then side = Vector3.new(1, 0, 0) end
        for _, s in ipairs({ side, -side }) do
            if not Workspace:Raycast(o, s * 8, steerRp) then return (s * 0.8 + flat * 0.2).Unit * speed end
        end
        return -flat * speed * 0.5
    end
    local function inLockedBase(hrp)
        local plots = Workspace:FindFirstChild("Plots")
        local mine = findMyBase()
        for _, plot in ipairs(plots and plots:GetChildren() or {}) do
            if plot ~= mine then
                local hb = FUNHUBAur.hitbox(plot)
                if hb and FUNHUBAur.inBox(hb, hrp.Position) and FUNHUBUI.lockInfo(plot) then return true end
            end
        end
        return false
    end
    local function flyTo(hrp, getPos, stopDist, maxTime, onStep)
        local t0 = os.clock()
        while FUNHUB_ALIVE() and os.clock() - t0 < maxTime do
            local pos = getPos()
            if not pos or not hrp.Parent then return false end
            local d = pos - hrp.Position
            if onStep and onStep(d.Magnitude) then return true end
            if d.Magnitude <= stopDist then
                hrp.AssemblyLinearVelocity = Vector3.zero
                if not onStep then return true end
            else
                hrp.AssemblyLinearVelocity = steer(hrp, pos, math.clamp(d.Magnitude * 8, 30, 160))
            end
            RunService.Heartbeat:Wait()
        end
        return false
    end
    local function theirRoot(target)
        local st = target:GetAttribute("Stealing")
        if st == nil or st == false then return nil end
        return target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    end
    local function wear(hum, t)
        if t and t.Parent and t.Parent ~= player.Character then pcall(function() hum:EquipTool(t) end) end
    end
    local function adminHit(ch, hum, hrp)
        if not hum.Parent or hum.Health <= 0 or not hrp.Parent then return true end
        local t = player:GetAttribute("RagdollEndTime")
        if type(t) == "number" and t > Workspace:GetServerTimeNow() then return true end
        if player:GetAttribute("Ragdoll") == true or hrp.Anchored then return true end
        local held = ch:FindFirstChildOfClass("Tool")
        if held and held == findFlyGear() then return false end
        return hum.PlatformStand or ch:FindFirstChildWhichIsA("VectorForce", true) ~= nil
    end
    local function chase(target, ch, hum, hrp, tool, isMelee, gear)
        local range = isMelee and 4 or 30
        local t0, lastSwing = os.clock(), 0
        local bestD, bestAt = math.huge, os.clock()
        wear(hum, gear or tool)
        while FUNHUB_ALIVE() and os.clock() - t0 < 15 do
            local r = theirRoot(target)
            if not r then return "done" end
            if adminHit(ch, hum, hrp) then return "hit" end
            if inLockedBase(hrp) then return "locked" end
            local pos = r.Position + r.AssemblyLinearVelocity * 0.1
            local d = pos - hrp.Position
            local dist = d.Magnitude
            if dist < bestD - 3 or dist <= range + 4 then bestD, bestAt = dist, os.clock() end
            if os.clock() - bestAt > 2.5 then return "hit" end
            if dist > range + 8 then wear(hum, gear or tool) else wear(hum, tool) end
            if dist <= range then
                hrp.AssemblyLinearVelocity = Vector3.zero
            else
                hrp.AssemblyLinearVelocity = steer(hrp, pos, math.clamp(dist * 8, 30, 160), target.Character)
            end
            local flat = Vector3.new(r.Position.X, hrp.Position.Y, r.Position.Z)
            if (flat - hrp.Position).Magnitude > 0.1 then hrp.CFrame = CFrame.lookAt(hrp.Position, flat) end
            if mouse then pcall(function() mouse.Hit = CFrame.new(r.Position); mouse.Target = r end) end
            if dist <= range + 2 and os.clock() - lastSwing >= 0.12 then
                lastSwing = os.clock()
                pcall(function() tool:Activate() end)
            end
            RunService.Heartbeat:Wait()
        end
        return "timeout"
    end
    local function hunt(target)
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) or player:GetAttribute("Stealing") then return end
        if not pickWeapon() then setStealStatus("NO BAT / SLAP / WEAPON", false) return end
        hunting = true
        hitBtn.Text = "HUNTING"
        local home = hrp.CFrame
        _G.FUNHUB_SemiTP_Busy = true
        local resets = 0
        while FUNHUB_ALIVE() do
            ch = player.Character
            hum = ch and ch:FindFirstChildOfClass("Humanoid")
            hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local tool, isMelee = pickWeapon()
            if not (hum and hrp and tool) then break end
            local result = chase(target, ch, hum, hrp, tool, isMelee, findFlyGear())
            if (result ~= "hit" and result ~= "locked") or resets >= 3 or not theirRoot(target) then break end
            resets = resets + 1
            hitBtn.Text = "RESETTING"
            setStealStatus((result == "locked" and "STUCK IN A LOCKED BASE" or "ADMIN PANELLED")
                .. " - RESETTING (" .. resets .. "/3)", false)
            local old = player.Character
            pcall(_G.FUNHUB_SemiTP_InstaReset)
            local t0 = os.clock()
            while player.Character == old and os.clock() - t0 < 8 do task.wait(0.1) end
            if player.Character == old then break end
            local nc = player.Character
            if not (nc and nc:WaitForChild("HumanoidRootPart", 6) and nc:WaitForChild("Humanoid", 6)) then break end
            task.wait(0.35)
            if not theirRoot(target) then break end
            setStealStatus("BACK ON " .. string.upper(target.Name), nil)
            hitBtn.Text = "HUNTING"
        end
        pcall(function() player.Character:FindFirstChildOfClass("Humanoid"):UnequipTools() end)
        _G.FUNHUB_SemiTP_Busy = false
        hunting = false
        pendingHome, pendingUntil = home, os.clock() + 3
        hitBtn.Text = "RETURN"
    end
    local function goHome()
        local home = pendingHome
        pendingHome = nil
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (home and hum and hrp) or player:GetAttribute("Stealing") then hitBtn.Text = "HIT" return end
        hunting = true
        hitBtn.Text = "RETURNING"
        _G.FUNHUB_SemiTP_Busy = true
        wear(hum, findFlyGear())
        pcall(flyTo, hrp, function() return home.Position end, 2.5, 8)
        pcall(function()
            hrp.CFrame = home
            hrp.AssemblyLinearVelocity = Vector3.zero
            hum:UnequipTools()
        end)
        _G.FUNHUB_SemiTP_Busy = false
        hunting = false
        hitBtn.Text = "HIT"
    end
    hitBtn.MouseButton1Click:Connect(function()
        if hunting then return end
        if pendingHome then task.spawn(goHome) return end
        if shown then task.spawn(hunt, shown) end
    end)

    task.spawn(function()
        while FUNHUB_ALIVE() do
            local show = false
            local mine = FUNHUBFx.thiefBar and findMyBase()
            local myHb = mine and FUNHUBAur.hitbox(mine)
            if myHb then
                local now = os.clock()
                local plots = Workspace:FindFirstChild("Plots")
                for _, p in ipairs(Players:GetPlayers()) do
                    local r = p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if r then
                        if FUNHUBAur.inBox(myHb, r.Position) then lastIn[p] = now end
                        local st = p:GetAttribute("Stealing")
                        local stealing = st ~= nil and st ~= false
                        if stealing and (thieves[p] or now - (lastIn[p] or -99) < 5) then
                            thieves[p] = true
                        elseif not stealing then
                            thieves[p] = nil
                        end
                        if thieves[p] and not show then
                            show = true
                            shown = p
                            local theirHb
                            for _, pl in ipairs(plots and plots:GetChildren() or {}) do
                                local o = plotOwnerName(pl)
                                if o == p.Name or o == p.DisplayName then theirHb = FUNHUBAur.hitbox(pl) break end
                            end
                            local total = theirHb and (theirHb.Position - myHb.Position).Magnitude or 150
                            local done = (r.Position - myHb.Position).Magnitude
                            local frac = math.clamp(done / math.max(total, 1), 0, 1)
                            fill.Size = UDim2.fromScale(frac, 1)
                            pct.Text = math.floor(frac * 100) .. "% TO THEIR BASE"
                            local idx = p:GetAttribute("StealingIndex")
                            title.Text = p.Name .. " STOLE " .. ((idx ~= nil and idx ~= "") and string.upper(tostring(idx)) or "YOUR BRAINROT")
                            barStroke.Transparency = (now % 0.6 < 0.3) and 0.85 or 0.3
                        end
                    end
                end
            end
            if not show and not hunting then shown = nil end
            if pendingHome and not hunting and os.clock() > pendingUntil then
                pendingHome = nil
                hitBtn.Text = "HIT"
            end
            if pendingHome and not show and not hunting then
                title.Text = "TAP RETURN TO FLY BACK"
                pct.Text = ""
            end
            bar.Visible = show or hunting or pendingHome ~= nil
            barScale.Scale = FUNHUBUI.uiFactor()
            task.wait(0.1)
        end
        bar:Destroy()
    end)
end)()

-- The base timer below owns Auto Leave, including the legacy toggle.

-- DatShawn potion LinearVelocity and SABCOM carpet velocity from the supplied source.
-- Each mode has one owner; native vertical flight/jump/fall velocity stays untouched.
do
    if type(FUNHUB_ENV.__FHMovementCleanup) == "function" then pcall(FUNHUB_ENV.__FHMovementCleanup) end
    local S = { mode = "Off", links = {}, stopped = false,
        delivery = { plots = nil, parts = {}, links = {} } }
    FUNHUBFx.motion = S
    -- Whyhzzea delivery fix: 15 studs/s only inside your own delivery box while carrying as a giant.
    -- Reuse this controller's horizontal force; index streamed zones only once.
    function S.clearDelivery()
        for _, link in ipairs(S.delivery.links) do link:Disconnect() end
        table.clear(S.delivery.links)
        table.clear(S.delivery.parts)
        S.delivery.plots = nil
    end
    function S.syncDelivery()
        local plots = not S.stopped and FUNHUBFx.getSetting("antiDeliveryFailed", false) == true
            and Workspace:FindFirstChild("Plots") or nil
        if plots == S.delivery.plots then return end
        S.clearDelivery()
        S.delivery.plots = plots
        if not plots then return end
        local function consider(part)
            if part:IsA("BasePart") and part.Name == "DeliveryHitbox" then
                S.delivery.parts[part] = true
            end
        end
        S.delivery.links[1] = plots.DescendantAdded:Connect(consider)
        S.delivery.links[2] = plots.DescendantRemoving:Connect(function(part) S.delivery.parts[part] = nil end)
        for _, part in ipairs(plots:GetDescendants()) do consider(part) end
    end
    function S.inDelivery(root)
        local plots = S.delivery.plots
        if not (root and plots) then return false end
        local owner, ownerResolved
        for part in pairs(S.delivery.parts) do
            if not part.Parent or part.Name ~= "DeliveryHitbox" or not part:IsDescendantOf(plots) then
                S.delivery.parts[part] = nil
            else
                local relative = part.CFrame:PointToObjectSpace(root.Position)
                local half = part.Size * 0.5
                if math.abs(relative.X) <= half.X and math.abs(relative.Y) <= half.Y + 3
                    and math.abs(relative.Z) <= half.Z then
                    if not ownerResolved then
                        -- Resolve only while inside a zone, using the strict own-base
                        -- resolver even when Quick Grab is off. Never use a nearest base.
                        local actions = FUNHUBFx.actions
                        local quickGrab = actions and actions.quickGrab
                        local ok, plot = pcall(function() return quickGrab and quickGrab.OwnPlot() end)
                        owner, ownerResolved = ok and plot or nil, true
                        if not owner or not owner:IsDescendantOf(plots) then return false end
                    end
                    if part:IsDescendantOf(owner) then return true end
                end
            end
        end
        return false
    end
    function S.release()
        if S.force then S.force:Destroy() S.force = nil end
        if S.attachment then S.attachment:Destroy() S.attachment = nil end
        S.root, S.mode = nil, "Off"
        FUNHUBFx.potionSpeedActive = false
    end
    function S.suspend()
        if S.force and S.force.Parent then S.force.Enabled = false end
        S.mode = "Paused"
        FUNHUBFx.potionSpeedActive = false
    end
    function S.build(root)
        if S.root == root and S.force and S.force.Parent == root
            and S.attachment and S.attachment.Parent == root then return end
        S.release()
        S.root = root
        S.attachment = Instance.new("Attachment")
        S.attachment.Name, S.attachment.Parent = "FHMovementAttachment", root
        S.force = Instance.new("LinearVelocity")
        S.force.Name = "FHMovementVelocity"
        S.force.Enabled = false
        S.force.Attachment0 = S.attachment
        S.force.RelativeTo = Enum.ActuatorRelativeTo.World
        S.force.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        S.force.ForceLimitsEnabled = true
        S.force.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        S.force.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
        S.force.VectorVelocity = Vector3.zero
        S.force.Parent = root
    end
    function S.flyTool(char)
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if HubConfig.flyTool and HubConfig.flyTool ~= "Auto" and tool.Name == HubConfig.flyTool then return tool end
                for _, key in ipairs(FLY_GEAR_KEYS) do
                    if name:find(key, 1, true) then return tool end
                end
            end
        end
    end
    function S.number(key, fallback, low, high)
        local value = tonumber(HubConfig[key])
        if not value or value ~= value or math.abs(value) == math.huge then value = fallback end
        return math.clamp(value, low, high)
    end
    function S.choose(char, hum, flying, carrying)
        if carrying then
            if FUNHUBFx.getSetting("antiDeliveryFailed", false) == true and not potionState.stopped then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and (root.Size.Y > 2.5 or potionState.isGiant(char)) and S.inDelivery(root) then
                    return 15, "Delivery"
                end
            end
            if FUNHUBFx.potionSpeed and not potionState.stopped and potionState.isGiant(char) then
                return S.number("giantSpeedValue", 34.8, 16, 40), "Giant"
            elseif _G.FUNHUB_SemiTP_SpeedBoost then
                return stealSpeed(), "Steal"
            end
            return -- Carrying never falls through into walk/carpet speed.
        elseif flying then
            if FUNHUBFx.carpet then return S.number("carpetSpeedValue", 130, 16, 500), "Carpet" end
            return
        elseif FUNHUBFx.speedOn then
            return S.number("walkSpeedValue", 30, 16, 80), "Walk"
        end
        local state = hum:GetState()
        if FUNHUBFx.noWalkDelay and hum.FloorMaterial ~= Enum.Material.Air
            and hum.WalkSpeed > 0 and (state == Enum.HumanoidStateType.Running
                or state == Enum.HumanoidStateType.RunningNoPhysics or state == Enum.HumanoidStateType.Landed) then
            return hum.WalkSpeed, "Instant Walk"
        end
    end
    function S.step(dt)
        if S.stopped then return end
        if not FUNHUB_ALIVE() then S.stop() return end
        S.syncDelivery()
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not (root and hum) or hum.Health <= 0 then S.release() return end
        local flying = S.flyTool(char) ~= nil
        local state = hum:GetState()
        if root.Anchored or hum.Sit or _G.FUNHUB_SemiTP_Busy or _G.FUNHUB_SemiTP_ResetBusy
            or _G.FUNHUB_SemiTP_InputLock or (not flying and (hum.PlatformStand
                or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown
                or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.GettingUp)) then
            S.release() return
        end
        local speed, mode = S.choose(char, hum, flying, isStealBoostLive())
        if not speed then
            -- Drop the carpet's last horizontal boost once when it is disabled.
            if S.mode == "Carpet" and S.root == root and flying then
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            end
            S.release() return
        end
        local flat = Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)
        if mode == "Carpet" then
            -- DatShawn/SABCOM carpet path: boost an equipped fly tool without
            -- adding a second constraint that fights its native flight controller.
            if S.force or S.root ~= root then S.release() end
            S.root, S.mode = root, mode
            FUNHUBFx.potionSpeedActive = false
            local velocity = flat.Magnitude > 0.001 and flat.Unit * math.min(flat.Magnitude, 1) * speed or Vector3.zero
            root.AssemblyLinearVelocity = Vector3.new(velocity.X, root.AssemblyLinearVelocity.Y, velocity.Z)
            return
        end
        if mode == "Steal" then
            -- Preserve this build's regular-steal movement and delivery-box guard.
            S.release()
            if flat.Magnitude <= 0.001 or hum.FloorMaterial == Enum.Material.Air then return end
            local myBase = findMyBase()
            if myBase and myBase:FindFirstChild("DeliveryHitbox") then
                local box = Workspace:FindFirstChild("SpeedRestoreBox")
                if box and box:IsA("BasePart") then
                    local rel, half = box.CFrame:PointToObjectSpace(root.Position), box.Size / 2
                    if math.abs(rel.X) < half.X and math.abs(rel.Z) < half.Z then return end
                end
            end
            local extra = math.max(speed - hum.WalkSpeed, 0)
            if extra > 0 then root.CFrame = root.CFrame + flat * extra * math.clamp(dt, 0, 0.1) end
            S.mode = mode
            return
        end
        if mode == "Delivery" then
            if hum.WalkSpeed <= 0 then S.suspend() return end
            S.build(root)
            S.force.VectorVelocity = flat.Magnitude > 0.1 and flat.Unit * speed or Vector3.zero
            S.force.Enabled = true
            S.mode = mode
            FUNHUBFx.potionSpeedActive = true
            return
        end
        if flat.Magnitude <= 0.001 or hum.WalkSpeed <= 0 then S.suspend() return end
        S.build(root)
        S.force.VectorVelocity = flat.Unit * math.min(flat.Magnitude, 1) * speed
        S.force.Enabled = true
        S.mode = mode
        FUNHUBFx.potionSpeedActive = mode == "Giant"
    end
    function S.stop()
        if S.stopped then return end
        S.stopped = true
        S.release()
        S.clearDelivery()
        for _, link in ipairs(S.links) do link:Disconnect() end
        table.clear(S.links)
        if FUNHUB_ENV.__FHMovementCleanup == S.stop then FUNHUB_ENV.__FHMovementCleanup = nil end
    end
    FUNHUB_ENV.__FHMovementCleanup = S.stop
    S.links[#S.links + 1] = RunService.Heartbeat:Connect(function(dt)
        local ok, err = pcall(S.step, dt)
        if not ok then
            S.release()
            if not S.warned then S.warned = true warn("[FUNHUB movement] " .. tostring(err)) end
        end
    end)
    S.links[#S.links + 1] = player.CharacterRemoving:Connect(S.release)
    S.links[#S.links + 1] = player.CharacterAdded:Connect(S.release)
end


;(function()
    local Lighting = game:GetService("Lighting")
    local on, saved, parts, addConn = false, nil, {}, nil
    local FX = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true }
    local function hide(d)
        if FX[d.ClassName] and d.Enabled then
            parts[d] = true
            d.Enabled = false
        end
    end
    local function enable()
        saved = {
            shadows = Lighting.GlobalShadows,
            spec = Lighting.EnvironmentSpecularScale,
            diff = Lighting.EnvironmentDiffuseScale,
        }
        pcall(function() saved.quality = UserSettings():GetService("UserGameSettings").SavedQualityLevel end)
        Lighting.GlobalShadows = false
        Lighting.EnvironmentSpecularScale = 0
        Lighting.EnvironmentDiffuseScale = 0
        pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
        for _, d in ipairs(Workspace:GetDescendants()) do pcall(hide, d) end
        addConn = Workspace.DescendantAdded:Connect(function(d) pcall(hide, d) end)
    end
    local function disable()
        if addConn then addConn:Disconnect() addConn = nil end
        if saved then
            Lighting.GlobalShadows = saved.shadows
            Lighting.EnvironmentSpecularScale = saved.spec
            Lighting.EnvironmentDiffuseScale = saved.diff
            if saved.quality then pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = saved.quality end) end
        end
        for d in pairs(parts) do pcall(function() if d.Parent then d.Enabled = true end end) end
        table.clear(parts)
    end
    task.spawn(function()
        while FUNHUB_ALIVE() do
            if FUNHUBFx.fps and not on then on = true pcall(enable)
            elseif not FUNHUBFx.fps and on then on = false pcall(disable) end
            if on then Lighting.GlobalShadows = false end
            task.wait(1)
        end
        if on then pcall(disable) end
    end)
end)()

;(function()
    local W, H = 520, 46
    local bar = Instance.new("Frame")
    bar.Name = "PillBar"
    bar.AnchorPoint = Vector2.new(0.5, 1)
    bar.Size = UDim2.fromOffset(W, H)
    bar.Position = UDim2.new(0.5, 0, 1, -100)
    bar.BackgroundColor3 = Color3.fromRGB(9, 18, 32)
    bar.BorderSizePixel = 0
    bar.ZIndex = 60
    bar.Parent = ProgressGui
    local scale = Instance.new("UIScale")
    scale.Parent = bar
    local function rescale()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local s = math.min(FUNHUBUI.uiFactor(), vp.X * 0.94 / W)
        scale.Scale = math.clamp(s, 0.4, 1.25)
    end
    rescale()
    if Workspace.CurrentCamera then Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale) end

    corner(bar, 13)
    stroke(bar, T.STROKE, 1, 0.18)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 29, 48)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(12, 23, 40)),
        ColorSequenceKeypoint.new(0.72, Color3.fromRGB(8, 17, 31)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 25, 43)),
    })
    g.Parent = bar

    local function make(class, props)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = bar
        return o
    end
    make("Frame", { Name = "Sheen", Position = UDim2.new(0, 14, 0, 3), Size = UDim2.new(1, -28, 0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.95, BorderSizePixel = 0, ZIndex = 63 })
    local dot = make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 22, 0.5, 0), Size = UDim2.fromOffset(9, 9),
        BackgroundColor3 = T.STROKE, BorderSizePixel = 0, ZIndex = 62 })
    corner(dot, 5)
    stroke(dot, Color3.fromRGB(107, 187, 255), 1, 0.35)
    local function label(x, y, w, h, text, size, font, col, align)
        local l = make("TextLabel", { BackgroundTransparency = 1, Position = UDim2.new(0, x, 0, y), Size = UDim2.new(0, w, h == 0 and 1 or 0, h),
            Font = font, Text = text, TextSize = size, TextColor3 = col, TextXAlignment = align or Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 62 })
        l.AutoLocalize = false
        return l
    end
    local title = label(38, 0, 130, 0, "FUNHUB", 15, Enum.Font.GothamBold, Color3.fromRGB(245, 246, 248))
    title.TextStrokeTransparency = 0.92
    local invite = label(186, 0, 182, 0, "DISCORD.GG/FREESCRIPTS", 15, Enum.Font.GothamBlack, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Center)
    invite.TextScaled = true
    local cap = Instance.new("UITextSizeConstraint")
    cap.MaxTextSize = 15
    cap.Parent = invite
    invite.TextStrokeColor3 = Color3.fromRGB(10, 39, 78)
    invite.TextStrokeTransparency = 0.4
    local shine = Instance.new("UIGradient")
    shine.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 122, 234)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(117, 198, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(117, 198, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 122, 234)),
    })
    shine.Parent = invite
    for _, x in ipairs({ 180, 374, 450 }) do
        make("Frame", { Position = UDim2.new(0, x, 0.5, -11), Size = UDim2.fromOffset(1, 22),
            BackgroundColor3 = Color3.fromRGB(39, 110, 200), BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 62 })
    end
    label(388, 8, 50, 10, "FPS", 9.5, Enum.Font.GothamBold, T.DIM)
    local fps = label(388, 20, 52, 17, "0", 15, Enum.Font.GothamBold, Color3.fromRGB(107, 187, 255))
    label(462, 8, 50, 10, "PING", 9.5, Enum.Font.GothamBold, T.DIM)
    local ping = label(462, 20, 52, 17, "0ms", 15, Enum.Font.GothamBold, Color3.fromRGB(107, 187, 255))

    local GOOD, OK, BAD = Color3.fromRGB(56, 214, 110), Color3.fromRGB(255, 165, 0), Color3.fromRGB(220, 60, 60)
    local frames, lastT, t0 = 0, os.clock(), os.clock()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not FUNHUB_ALIVE() then conn:Disconnect() bar:Destroy() return end
        bar.Visible = FUNHUBFx.pillBar
        if not FUNHUBFx.pillBar then return end
        frames = frames + 1
        local now = os.clock()
        shine.Offset = Vector2.new((now - t0) * 0.35 % 2 - 1, 0)
        if now - lastT >= 1 then
            fps.Text = tostring(frames)
            fps.TextColor3 = frames >= 60 and GOOD or (frames >= 30 and OK or BAD)
            frames, lastT = 0, now
            local okP, p = pcall(function() return math.floor(player:GetNetworkPing() * 1000) end)
            if okP then
                ping.Text = p .. "ms"
                ping.TextColor3 = p < 80 and GOOD or (p < 150 and OK or BAD)
            end
        end
    end)
end)()
end)()

;(function()
    function FUNHUBUI.waitOwnerLeave(pod, ctx)
        local name = plotOwnerName(pod.plot)
        local owner
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == name or p.DisplayName == name then owner = p end
        end
        if not owner then return true end
        setStealStatus("WAITING FOR " .. string.upper(owner.Name) .. " TO LEAVE", nil)
        local left = false
        local conn = Players.PlayerRemoving:Connect(function(p) if p == owner then left = true end end)
        FUNHUBUI.bypassWaiting = true
        if ctx.semiSource then ctx.expires = os.clock() + 125 end
        local t0 = os.clock()
        while FUNHUB_ALIVE() and not left and FUNHUBUI.bypassWaiting and FUNHUBFx.defBypass and os.clock() - t0 < 120 do
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 or not pod.prompt.Parent or not owner.Parent then
                left = not owner.Parent
                break
            end
            if tick() - (ctx.holdBeganAt or 0) >= 2.4 then
                if ctx.semiSource then FUNHUB.semiSource.restart(ctx) else FUNHUBHold.restart(ctx) end
                ctx.ragdollFireTime = ctx.holdBeganAt
            end
            task.wait()
        end
        conn:Disconnect()
        FUNHUBUI.bypassWaiting = false
        if not left then setStealStatus("BYPASS CANCELLED", false) end
        return left
    end

    local function blocked()
        local t = player:GetAttribute("RagdollEndTime")
        return player:GetAttribute("BlockTools") == true or player:GetAttribute("Ragdoll") == true
            or (type(t) == "number" and t > Workspace:GetServerTimeNow())
    end
    local function nearestPrompt(hrp, maxD)
        if FUNHUBHold.selectAutoPrompt then
            local prompt, distance, handled = FUNHUBHold.selectAutoPrompt(hrp, maxD)
            if handled then return prompt, distance end
        end
        local plots = Workspace:FindFirstChild("Plots")
        local best, bestD = nil, maxD
        for _, plot in ipairs(plots and plots:GetChildren() or {}) do
            local pods = isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums")
            for _, pd in ipairs(pods and pods:GetChildren() or {}) do
                local spawn, prompt = podiumParts(pd)
                if spawn and prompt and prompt.Enabled
                    and tostring(prompt.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") == "steal" then
                    local position = FUNHUBHold.promptPosition(prompt) or spawn.Position
                    local d = (position - hrp.Position).Magnitude
                    if d <= bestD then best, bestD = prompt, d end
                end
            end
        end
        return best, bestD
    end
    local BANK, RANGE = 25, 9.5
    local bank = { prompt = nil, ctx = nil, inRange = false, lastFire = 0 }
    function FUNHUBHold.clearPublic()
        FUNHUBHold.cancel(bank.ctx)
        bank.prompt, bank.ctx, bank.inRange = nil, nil, false
        FUNHUBHold.publicContext = nil
    end
    function FUNHUBHold.publicTick()
        local st = player:GetAttribute("Stealing")
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (FUNHUBFx.pubGrab and hrp and hum and hum.Health > 0)
            or not FUNHUBHold.normalEnabled
            or (st ~= nil and st ~= false) or blocked() or FUNHUB.debounce
            or FUNHUBFx.backgroundPaused() then
            FUNHUBHold.clearPublic()
            return
        end
        local prompt, distance = nearestPrompt(hrp, BANK)
        local inRange = prompt ~= nil and distance <= math.min(RANGE, tonumber(prompt.MaxActivationDistance) or RANGE)
        if prompt ~= bank.prompt or (bank.ctx and (not FUNHUBHold.valid(bank.ctx) or bank.ctx.failed)) then
            FUNHUBHold.clearPublic()
            bank.prompt = prompt
        end
        if not prompt then return end
        if not bank.ctx then
            if FUNHUBHold.clearNormal then FUNHUBHold.clearNormal() end
            bank.ctx = FUNHUBHold.startStealHold(prompt)
            bank.inRange = inRange
            FUNHUBHold.publicContext = bank.ctx
            FUNHUBHold.track(bank.ctx, "Public Grab")
        end
        local ctx = bank.ctx
        if not ctx then return end -- late prompt callbacks are retried next tick
        -- A streamed-in callback can replace the native fallback without changing target.
        if ctx.native and os.clock() >= (bank.nextCallbackCheck or 0) then
            bank.nextCallbackCheck = os.clock() + 0.5
            if FUNHUBStealCallbacks(prompt) then
                FUNHUBHold.cancel(ctx)
                ctx = FUNHUBHold.startStealHold(prompt)
                bank.ctx, FUNHUBHold.publicContext = ctx, ctx
                FUNHUBHold.track(ctx, "Public Grab")
            end
        end
        local need = math.max(0, tonumber(prompt.HoldDuration) or 1.3) + 0.05
        local age = ctx.holdBeganAt and tick() - ctx.holdBeganAt or math.huge
        if (inRange and not bank.inRange) or age >= math.max(2.4, need + 0.5)
            or (ctx.native and ctx.lastTrigger and tick() - ctx.lastTrigger >= 0.35) then
            FUNHUBHold.restart(ctx)
            ctx.lastTrigger = nil
            age = ctx.holdBeganAt and tick() - ctx.holdBeganAt or 0
        end
        if inRange and age >= need and os.clock() - bank.lastFire >= 0.15 then
            bank.lastFire = os.clock()
            FUNHUBHold.trigger(ctx)
        end
        bank.inRange = inRange
    end
    -- Autograb from the supplied 20261014 source: MIN_HOLD 1.3, WAIT_STOP 3.3,
    -- ten-stud pickup range and 0.3s entry delay after reaching 100% out of range.
    -- Public Grab keeps its separate method and owns the hold while active.
    local normal = { scanAt = 0 }
    function FUNHUBHold.clearNormal()
        FUNHUBHold.cancel(normal.ctx)
        normal.ctx, normal.prompt = nil, nil
        normal.scanAt, normal.callbackAt = 0, 0
        FUNHUBHold.normalContext = nil
    end
    function FUNHUBHold.normalTick()
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not FUNHUBHold.normalEnabled or FUNHUBFx.pubGrab or not (hrp and hum and hum.Health > 0)
            or isStealBoostLive() or blocked()
            or FUNHUBHold.publicContext or FUNHUB.debounce
            or FUNHUBFx.backgroundPaused() then
            FUNHUBHold.clearNormal()
            return
        end
        local now = os.clock()
        if now >= normal.scanAt then
            local prompt = nearestPrompt(hrp, math.huge)
            if prompt ~= normal.prompt then
                FUNHUBHold.clearNormal()
                normal.prompt = prompt
            end
            normal.scanAt = now + 0.15
        end
        local prompt = normal.prompt
        if not prompt then return end
        if normal.ctx and (not FUNHUBHold.valid(normal.ctx) or normal.ctx.failed) then
            FUNHUBHold.clearNormal()
            return
        end
        if not normal.ctx then
            normal.ctx = FUNHUBHold.startStealHold(prompt, true)
            FUNHUBHold.normalContext = normal.ctx
            FUNHUBHold.track(normal.ctx, "Auto Grab")
        end
        local ctx = normal.ctx
        if not ctx then return end
        if ctx.native and now >= (normal.callbackAt or 0) then
            normal.callbackAt = now + 0.5
            if FUNHUBStealCallbacks(prompt, true) then
                FUNHUBHold.cancel(ctx)
                ctx = FUNHUBHold.startStealHold(prompt, true)
                normal.ctx, FUNHUBHold.normalContext = ctx, ctx
                FUNHUBHold.track(ctx, "Auto Grab")
            end
        end
        if not ctx then return end
        if ctx.lastTrigger then
            -- One trigger per hold. Let the carry state settle before a failed attempt retries.
            if tick() - ctx.lastTrigger >= 0.2 then FUNHUBHold.clearNormal() end
            return
        end
        local inRange = FUNHUBHold.inRange(ctx)
        if ctx.native then
            -- Missing executor callbacks use the real prompt timing and activation distance.
            if not inRange then
                if ctx.nativeHolding then FUNHUBHold.clearNormal() end
                return
            end
            if not ctx.holdBeganAt then FUNHUBHold.restart(ctx) end
            local need = math.max(0, tonumber(prompt.HoldDuration) or 1.3) + 0.05
            if ctx.holdBeganAt and tick() - ctx.holdBeganAt >= need then FUNHUBHold.trigger(ctx) end
            return
        end
        local age = ctx.holdBeganAt and tick() - ctx.holdBeganAt or 0
        if age < ctx.holdDuration then return end
        if not ctx.windowOpened then
            ctx.windowOpened = true
            if inRange then ctx.triggerAt = now end
        elseif not inRange and ctx.triggerAt then
            ctx.triggerAt, ctx.commitUntil = nil, nil
            if FUNHUBHold.onAutoPotionCancel then FUNHUBHold.onAutoPotionCancel(ctx) end
        elseif inRange and not ctx.triggerAt and now <= ctx.windowEnd then
            ctx.triggerAt = now + 0.3
        end
        -- A pickup entered inside the window may finish its entry delay and bounded potion equip.
        if ctx.triggerAt and not ctx.commitUntil then ctx.commitUntil = ctx.triggerAt + 0.55 end
        if now > ctx.windowEnd and (not ctx.commitUntil or now > ctx.commitUntil) then
            FUNHUBHold.clearNormal()
            return
        end
        if inRange and ctx.triggerAt and now >= ctx.triggerAt then
            FUNHUBHold.trigger(ctx) -- The shared potion bridge completes before this callback fires.
        end
    end
    function FUNHUBHold.clearAuto()
        FUNHUBHold.clearPublic()
        FUNHUBHold.clearNormal()
    end

    task.spawn(function()
        while FUNHUB_ALIVE() do
            task.wait((not FUNHUBHold.normalEnabled or FUNHUBFx.backgroundPaused()) and 0.2 or 0.03)
            local ok, err = pcall(function()
                FUNHUBHold.publicTick()
                FUNHUBHold.normalTick()
            end)
            if not ok then
                FUNHUBHold.clearAuto()
                if os.clock() >= (bank.warnAt or 0) then
                    bank.warnAt = os.clock() + 5
                    warn("[FUNHUB Auto Grab] " .. tostring(err))
                end
            end
        end
        FUNHUBHold.clearAuto()
    end)

    ;(function()
        local REACH, ENTRY_WINDOW, GATE, REGRAB_WINDOW = 12, 1.0, 0.06, 12
        local ARM, RANGE = 40, 10
        FUNHUB.qgMaxAge = FUNHUB.qgMaxAge or 2.4
        local qgFired, qgBegan, fellBack = nil, "OUT OF", false
        local info = setmetatable({}, { __mode = "k" })
        local target, since, lastPress, holdPrompt = nil, 0, 0, nil
        local dropPrompt, dropAt, wasStealing = nil, 0, false
        local underSlot, underAt, cands, candAt = nil, 0, {}, 0
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude

        local function infoOf(prompt)
            if not FUNHUBHold.isStealAction(prompt) then return nil end
            local i = info[prompt]
            if i then return i end
            local spawn = prompt.Parent and prompt.Parent.Parent
            local pod = spawn and spawn.Parent and spawn.Parent.Parent
            local plot = pod and pod.Parent and pod.Parent.Parent
            local root = plot and plot:FindFirstChild("MainRoot")
            if not (spawn and spawn:IsA("BasePart") and root) then return nil end
            i = { spawn = spawn, pod = pod, plot = plot, root = root, relZ = root.CFrame:PointToObjectSpace(spawn.Position).Z }
            info[prompt] = i
            return i
        end
        local function scan()
            table.clear(cands)
            local plots = Workspace:FindFirstChild("Plots")
            for _, plot in ipairs(plots and plots:GetChildren() or {}) do
                local pods = isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums")
                for _, pd in ipairs(pods and pods:GetChildren() or {}) do
                    local _, prompt = podiumParts(pd)
                    if prompt then cands[#cands + 1] = prompt end
                end
            end
        end
        local function slotUnder(ch, hrp)
            rp.FilterDescendantsInstances = { ch }
            local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -7, 0), rp)
            local p = hit and hit.Instance
            while p and p ~= Workspace do
                if p.Parent and p.Parent.Name == "AnimalPodiums" then return p end
                p = p.Parent
            end
            return nil
        end
        local function press(p)
            lastPress = os.clock()
            pcall(fireproximityprompt, p, 0)
        end

        local spotRp = RaycastParams.new()
        spotRp.FilterType = Enum.RaycastFilterType.Exclude
        function FUNHUB.enemyPromptAt(pos)
            local skip = {}
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl.Character then skip[#skip + 1] = pl.Character end
            end
            spotRp.FilterDescendantsInstances = skip
            local hit = Workspace:Raycast(pos, Vector3.new(0, -7, 0), spotRp)
            local p = hit and hit.Instance
            while p and p ~= Workspace do
                if p.Parent and p.Parent.Name == "AnimalPodiums" then break end
                p = p.Parent
            end
            local plot = p and p ~= Workspace and p.Parent and p.Parent.Parent
            local _, prompt = podiumParts(p ~= Workspace and p or nil)
            if prompt and isEnemyPlot(plot) then return prompt end
            return nil
        end

        function FUNHUB.grabUnderFeet(secs, prompt, ctx)
            local started, lastFire = os.clock(), 0
            local character = player.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
            local anchor = hrp.Position
            prompt = prompt or FUNHUB.enemyPromptAt(anchor)
            if not prompt then return false end
            if not ctx or not FUNHUBHold.valid(ctx) or ctx.failed then
                FUNHUBHold.cancel(ctx)
                ctx = FUNHUBHold.startStealHold(prompt)
            end
            if not ctx then return false end
            FUNHUBHold.track(ctx, "Semi TP", podiumInfoText ~= "" and podiumInfoText or nil)
            local ownContext = ctx
            local success = false
            while FUNHUB_ALIVE() and os.clock() - started < (secs or 3) do
                local st = player:GetAttribute("Stealing")
                if st ~= nil and st ~= false then success = true break end
                if player.Character ~= character or not hrp.Parent or (hrp.Position - anchor).Magnitude > 6
                    or not FUNHUBHold.valid(ctx) then break end
                local need = math.max(0, tonumber(prompt.HoldDuration) or 1.3) + 0.05
                local age = ctx.holdBeganAt and tick() - ctx.holdBeganAt or math.huge
                if age >= math.max(2.4, need + 0.5) or (ctx.native and ctx.lastTrigger and tick() - ctx.lastTrigger >= 0.35) then
                    FUNHUBHold.restart(ctx)
                    ctx.lastTrigger = nil
                elseif age >= need and os.clock() - lastFire >= 0.15 then
                    lastFire = os.clock()
                    FUNHUBHold.trigger(ctx)
                end
                if ctx.failed then
                    FUNHUBHold.cancel(ctx)
                    ctx = FUNHUBHold.startStealHold(prompt)
                    if not ctx then break end
                    FUNHUBHold.track(ctx, "Semi TP", podiumInfoText ~= "" and podiumInfoText or nil)
                end
                RunService.Heartbeat:Wait()
            end
            FUNHUBHold.cancel(ctx)
            if ownContext ~= ctx then FUNHUBHold.cancel(ownContext) end
            return success
        end

        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not FUNHUB_ALIVE() then conn:Disconnect() return end
            local st = player:GetAttribute("Stealing")
            local stealing = st ~= nil and st ~= false
            local now = os.clock()
            if stealing and not wasStealing then
                holdPrompt = target
                if qgFired then
                    local age = qgFired.age
                    FUNHUB.log(string.format("QUICK GRAB: grabbed %.2fs after the grab fired  (hold %.2fs old, begun %s range)",
                        now - qgFired.at, age, tostring(qgFired.began)))
                    if age > FUNHUB.qgMaxAge then FUNHUB.qgMaxAge = math.min(age, 6) end
                end
                qgFired = nil
            end
            if not stealing and wasStealing and holdPrompt then dropPrompt, dropAt = holdPrompt, now end
            wasStealing = stealing
            if not FUNHUB.semiQuickGrab then target, qgFired = nil, nil return end
            if stealing or ((_G.FUNHUB_SemiTP_Busy or FUNHUB.debounce) and not FUNHUB.upperGrab) then target = nil return end
            local ch = player.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if dropPrompt and now - dropAt < REGRAB_WINDOW and dropPrompt.Parent and not dropPrompt.Enabled then
                local i = infoOf(dropPrompt)
                if i and (i.spawn.Position - hrp.Position).Magnitude <= REACH and firesignal then
                    pcall(firesignal, dropPrompt.Triggered, player)
                    return
                end
            elseif dropPrompt and (now - dropAt >= REGRAB_WINDOW or dropPrompt.Enabled) then
                dropPrompt = nil
            end

            if now - candAt > 1 then candAt = now scan() end
            if now - underAt > 0.05 then underAt = now underSlot = slotUnder(ch, hrp) end
            local best, bestD, arm, armD = nil, REACH, nil, ARM
            for _, p in ipairs(cands) do
                local i = p.Parent and p.Enabled and infoOf(p)
                if i then
                    local d = (i.spawn.Position - hrp.Position).Magnitude
                    if d <= armD then arm, armD = p, d end
                    if (underSlot == nil or i.pod == underSlot) and d <= bestD then best, bestD = p, d end
                end
            end
            if best ~= target then target, since, fellBack, qgFired = best, now, false, nil end
            local cb = arm and FUNHUBStealCallbacks(arm)
            local tcb = target and FUNHUBStealCallbacks(target)
            if not (cb and tcb) then
                if target and fireproximityprompt and now - lastPress >= ((now - since < ENTRY_WINDOW) and 0 or GATE) then press(target) end
                return
            end
            local age = tick() - FUNHUBHold.lastHold
            local need = (tonumber(target and target.HoldDuration) or 1.5) + 0.05
            local upper = FUNHUB.upperGrab
            if not upper then
                local eta = 0
                if bestD > RANGE or not target then
                    local sp = infoOf(target or arm)
                    local dir = sp and (sp.spawn.Position - hrp.Position) or Vector3.zero
                    local v = hrp.AssemblyLinearVelocity
                    local toward = dir.Magnitude > 0 and v:Dot(dir.Unit) or 0
                    eta = (((target and bestD) or armD) - RANGE) / math.max(toward, 8)
                end
                if age + eta > FUNHUB.qgMaxAge then
                    for _, fn in ipairs(cb.hold) do task.spawn(fn) end
                    age, qgBegan = 0, (bestD <= RANGE and target) and "IN" or "OUT OF"
                end
            end
            if not target then return end
            if age >= need and age <= FUNHUB.qgMaxAge + 0.3 and now - lastPress >= 0.1 then
                lastPress = now
                if not qgFired then qgFired = { at = now, age = age, began = qgBegan } end
                for _, fn in ipairs(tcb.trigger) do task.spawn(fn) end
            end
            if not upper and not fellBack and bestD <= 8.5 and qgFired and now - qgFired.at >= 0.35 then
                fellBack = true
                for _, fn in ipairs(tcb.hold) do task.spawn(fn) end
                qgBegan, qgFired = "IN (fallback)", nil
                FUNHUB.log("QUICK GRAB: banked hold didn't take - hold begun again in range")
            end
        end)
    end)()

    local FOV_BIND = "FUNHUBSemiTPFov"
    local fovWas = false
    pcall(RunService.UnbindFromRenderStep, RunService, FOV_BIND)
    RunService:BindToRenderStep(FOV_BIND, Enum.RenderPriority.Camera.Value + 1, function()
        if not FUNHUB_ALIVE() then pcall(RunService.UnbindFromRenderStep, RunService, FOV_BIND) return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        if FUNHUBFx.fov then
            fovWas = true
            cam.FieldOfView = FUNHUBUI.num("fovValue", 80, 30, 120)
        elseif fovWas then
            fovWas = false
            cam.FieldOfView = 70
        end
    end)

    ;(function()
        local Lighting = game:GetService("Lighting")
        local saved, conns, on = {}, {}, false
        local POST = { BloomEffect = true, BlurEffect = true, SunRaysEffect = true, DepthOfFieldEffect = true, ColorCorrectionEffect = true, Atmosphere = false }
        local function keep(d, prop, value)
            local s = saved[d]
            if not s then s = {} saved[d] = s end
            if s[prop] == nil then s[prop] = d[prop] end
            d[prop] = value
        end
        local function ours(d)
            local p = d
            for _ = 1, 3 do
                if not p then return false end
                if p.Name:sub(1, 6) == "FUNHUB" then return true end
                p = p.Parent
            end
            return false
        end
        local function strip(d)
            if ours(d) then return end
            if d:IsA("Decal") then keep(d, "Transparency", 1)
            elseif d:IsA("SurfaceAppearance") then
                local s = saved[d] or {}
                saved[d] = s
                if s.Parent == nil then s.Parent = d.Parent end
                d.Parent = nil
            elseif d:IsA("MeshPart") then
                if d.TextureID ~= "" then keep(d, "TextureID", "") end
                if d.Material ~= Enum.Material.SmoothPlastic then keep(d, "Material", Enum.Material.SmoothPlastic) end
            elseif d:IsA("SpecialMesh") then
                if d.TextureId ~= "" then keep(d, "TextureId", "") end
            elseif d:IsA("BasePart") then
                if d.Material ~= Enum.Material.SmoothPlastic then keep(d, "Material", Enum.Material.SmoothPlastic) end
            elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
                if d.Enabled then keep(d, "Enabled", false) end
            elseif POST[d.ClassName] and d.Parent == Lighting then
                keep(d, "Enabled", false)
            end
        end
        local function quiet(char)
            if not on or not char or char == player.Character or not FUNHUB_ALIVE() then return end
            local hum = char:WaitForChild("Humanoid", 5)
            if not on or char == player.Character or not FUNHUB_ALIVE() then return end
            local anim = hum and hum:WaitForChild("Animator", 5)
            if not anim or not on or char == player.Character or not FUNHUB_ALIVE() then return end
            for _, tr in ipairs(anim:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
            conns[#conns + 1] = anim.AnimationPlayed:Connect(function(tr)
                if on and char ~= player.Character and FUNHUB_ALIVE() then pcall(function() tr:Stop(0) end) end
            end)
        end
        local function enable()
            keep(Lighting, "GlobalShadows", false)
            keep(Lighting, "EnvironmentDiffuseScale", 0)
            keep(Lighting, "EnvironmentSpecularScale", 0)
            pcall(function()
                local gs = UserSettings():GetService("UserGameSettings")
                saved.__quality = saved.__quality or gs.SavedQualityLevel
                gs.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)
            for _, d in ipairs(Lighting:GetChildren()) do pcall(strip, d) end
            local all = Workspace:GetDescendants()
            for i, d in ipairs(all) do
                pcall(strip, d)
                if i % 4000 == 0 then task.wait() end
            end
            conns[#conns + 1] = Workspace.DescendantAdded:Connect(function(d)
                if on then task.defer(function() pcall(strip, d) end) end
            end)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    task.spawn(quiet, p.Character)
                    conns[#conns + 1] = p.CharacterAdded:Connect(function(c) if on then quiet(c) end end)
                end
            end
            conns[#conns + 1] = Players.PlayerAdded:Connect(function(p)
                conns[#conns + 1] = p.CharacterAdded:Connect(function(c) if on then quiet(c) end end)
            end)
        end
        local function disable()
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            table.clear(conns)
            local q = saved.__quality
            saved.__quality = nil
            if q then pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = q end) end
            for d, props in pairs(saved) do
                for prop, v in pairs(props) do
                    pcall(function() d[prop] = v end)
                end
            end
            table.clear(saved)
        end
        task.spawn(function()
            while FUNHUB_ALIVE() do
                if FUNHUBFx.fps and not on then on = true pcall(enable)
                elseif not FUNHUBFx.fps and on then on = false pcall(disable) end
                task.wait(1)
            end
            if on then on = false pcall(disable) end
        end)
    end)()

    ;(function()
        local hidden = {}
        local function widgetOf(img)
            local g = img
            while g.Parent and g.Parent.Parent and g.Parent.Parent.Name ~= "Holders" do g = g.Parent end
            return (g.Parent and g.Parent.Parent and g.Parent.Parent.Name == "Holders") and g or nil
        end
        task.spawn(function()
            while FUNHUB_ALIVE() do
                local tb = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("TopbarStandard")
                if FUNHUBFx.hideAP and tb then
                    for _, d in ipairs(tb:GetDescendants()) do
                        if d.Name == "IconImage" and (d:IsA("ImageLabel") or d:IsA("ImageButton"))
                            and tostring(d.Image):find("95529031547606", 1, true) then
                            local w = widgetOf(d)
                            if w and w:IsA("GuiObject") then
                                if hidden[w] == nil then hidden[w] = w.Visible end
                                w.Visible = false
                            end
                        end
                    end
                elseif not FUNHUBFx.hideAP and next(hidden) then
                    for w, v in pairs(hidden) do pcall(function() w.Visible = v end) end
                    table.clear(hidden)
                end
                task.wait(0.5)
            end
            for w, v in pairs(hidden) do pcall(function() w.Visible = v end) end
        end)
    end)()
end)()

;(function()
if not FUNHUB_ALIVE() then return end

local LP = player
local ENV = FUNHUB_ENV
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local PPS = game:GetService("ProximityPromptService")
local StatsService = game:GetService("Stats")
local MB1, TOUCH, MOVE = Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.MouseMovement

for _, g in ipairs({ ScreenGui, ProgressGui, SpeedScreenGui, AllowDisallowGui }) do
    pcall(function() g.Enabled = false end)
end
pcall(function() if ENV.__FHAuroraUnload then ENV.__FHAuroraUnload() end end)
ENV.__FHAuroraUnload = nil
pcall(function() if ENV.__FHUnload then ENV.__FHUnload() end end)

local AC = HubConfig.funhub
HubConfig.funhub = AC
AC.pos = type(AC.pos) == "table" and AC.pos or {}
AC.keys = type(AC.keys) == "table" and AC.keys or {}
FUNHUBKeys.migrate()

if not AC.funhubCompactSemi then
    AC.size = type(AC.size) == "table" and AC.size or {}
    AC.size.sub_semi = { 240, 290 }
    AC.size.sub_semiPicker = { 330, 390 }
    AC.size.sub_semimore = { 240, 280 }
    AC.funhubCompactSemi = true
end

if not AC.funhubBlueV1 then
    AC.accent1, AC.accent2 = { 40, 128, 255 }, { 78, 192, 255 }
    AC.funhubBlueV1 = true
end

local U, F = {}, {}
FUNHUBFx.actions = F
-- Migrate names without losing saved colors or positions for the previous GUI.
function U.migrateGuiNames()
    if AC.guiTheme == "Funhub Main" then AC.guiTheme = "Funhub 1.4 GUI" end
    for _, key in ipairs({ "themeLayouts", "themeAccents", "themeColors" }) do
        local values = AC[key]
        if type(values) == "table" and values["Funhub Main"] then
            if not values["Funhub 1.4 GUI"] then values["Funhub 1.4 GUI"] = values["Funhub Main"] end
            values["Funhub Main"] = nil
        end
    end
end
U.migrateGuiNames()
if not AC.funhub55GuiMigrated then
    AC.guiTheme, AC.funhub55GuiMigrated = "Funhub 5.5", true
end
if AC.guiTheme ~= "Funhub 5.5" and AC.guiTheme ~= "Funhub 1.4 GUI" and AC.guiTheme ~= "Aurora Hub" and AC.guiTheme ~= "og funhub" then AC.guiTheme = "Funhub 5.5" end
function U.compactTheme(name)
    name = name or U.activeTheme
    return name == "Funhub 5.5" or name == "Funhub 1.4 GUI"
end
AC.themeLayouts = type(AC.themeLayouts) == "table" and AC.themeLayouts or {}
U.activeTheme = "Aurora Hub"
local R = { sg = {}, tg = {}, fg = {}, bg1 = {}, bg2 = {}, tx1 = {}, tx2 = {}, bars = {},
    texts = setmetatable({}, { __mode = "k" }), wins = {}, rows = {}, conns = {}, cleanup = {},
    themed = setmetatable({}, { __mode = "k" }), skins = {}, switches = {}, cards = {}, panelScales = {}, windows = setmetatable({}, { __mode = "k" }), windowKeys = setmetatable({}, { __mode = "k" }) }

function U.get(k, d) local v = AC[k] if v == nil then return d end return v end
function U.set(k, v) AC[k] = v saveHubConfig() end
function U.on(sig, fn) local c = sig:Connect(fn) R.conns[#R.conns + 1] = c return c end

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local function toT(c) return { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) } end
local function fromT(t, d) if type(t) == "table" and #t == 3 then return rgb(t[1], t[2], t[3]) end return d end

local C = {
    WIN = rgb(12, 20, 33), CARD = rgb(18, 30, 47), ELEM = rgb(24, 41, 63), SEP = rgb(36, 58, 83),
    TEXT = rgb(236, 237, 242), DIM = rgb(161, 164, 176), WHITE = rgb(255, 255, 255),
    A1 = rgb(40, 128, 255), A2 = rgb(78, 192, 255),
    GOOD = rgb(96, 214, 138), WARN = rgb(255, 205, 90), BAD = rgb(255, 110, 130),
    GOLD = rgb(255, 219, 115), OPEN = rgb(120, 255, 150),
    BORDER = rgb(40, 128, 255), TAB = rgb(24, 41, 63), OFF = rgb(24, 41, 63),
}
C.A1 = fromT(AC.accent1, C.A1)
C.A2 = fromT(AC.accent2, C.A2)

U.themes = {
    ["Funhub 5.5"] = {
        WIN = rgb(25, 25, 25), CARD = rgb(25, 25, 25), ELEM = rgb(23, 26, 36), SEP = rgb(57, 64, 89),
        TEXT = rgb(210, 225, 255), DIM = rgb(170, 182, 210), A1 = rgb(57, 64, 89), A2 = rgb(255, 255, 255),
        BORDER = rgb(57, 64, 89), TAB = rgb(23, 26, 36), OFF = rgb(17, 19, 27),
    },
    ["Aurora Hub"] = {
        WIN = rgb(12, 20, 33), CARD = rgb(18, 30, 47), ELEM = rgb(24, 41, 63), SEP = rgb(36, 58, 83),
        TEXT = rgb(236, 237, 242), DIM = rgb(161, 164, 176), A1 = rgb(40, 128, 255), A2 = rgb(78, 192, 255),
        BORDER = rgb(40, 128, 255), TAB = rgb(24, 41, 63), OFF = rgb(24, 41, 63),
    },
    ["Funhub 1.4 GUI"] = {
        WIN = rgb(0, 0, 0), CARD = rgb(8, 12, 22), ELEM = rgb(14, 26, 52), SEP = rgb(25, 45, 85),
        TEXT = rgb(210, 225, 255), DIM = rgb(162, 175, 210), A1 = rgb(23, 55, 115), A2 = rgb(38, 85, 170),
        BORDER = rgb(23, 55, 115), TAB = rgb(14, 26, 52), OFF = rgb(14, 26, 52),
    },
    ["og funhub"] = {
        WIN = rgb(18, 8, 8), CARD = rgb(22, 10, 10), ELEM = rgb(40, 12, 12), SEP = rgb(120, 20, 20),
        TEXT = rgb(240, 240, 240), DIM = rgb(160, 160, 160), A1 = rgb(200, 30, 30), A2 = rgb(230, 40, 40),
        BORDER = rgb(180, 25, 25), TAB = rgb(35, 15, 15), OFF = rgb(50, 20, 20),
    },
}
AC.themeAccents = type(AC.themeAccents) == "table" and AC.themeAccents or {}
if type(AC.themeAccents["Aurora Hub"]) ~= "table" then
    AC.themeAccents["Aurora Hub"] = { toT(C.A1), toT(C.A2) }
end
AC.themeColors = type(AC.themeColors) == "table" and AC.themeColors or {}
if not AC.funhubV14Colors then
    AC.themeAccents["Funhub 1.4 GUI"] = { { 23, 55, 115 }, { 38, 85, 170 } }
    AC.funhubV14Colors = true
end
function U.bindTheme(o, props)
    local bindings = {}
    for property, value in pairs(props or {}) do
        if typeof(value) == "Color3" then
            for _, role in ipairs({ "WIN", "CARD", "ELEM", "SEP", "TEXT", "DIM", "A1", "A2", "BORDER", "TAB", "OFF" }) do
                if value == C[role] then bindings[property] = { role = role, value = value } break end
            end
        end
    end
    if next(bindings) then R.themed[o] = bindings end
end
function U.skinValue(skin)
    if U.activeTheme == "og funhub" and skin.og ~= nil then return skin.og end
    return U.compactTheme() and skin.main or skin.aurora
end
function U.skin(o, property, mainValue, auroraValue, ogValue)
    local skin = { o = o, property = property, main = mainValue, aurora = auroraValue, og = ogValue }
    R.skins[#R.skins + 1] = skin
    o[property] = U.skinValue(skin)
end

local function new(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    U.bindTheme(o, props)
    return o
end

function U.seq2() return ColorSequence.new(C.A1, C.A2) end
function U.seq3()
    return ColorSequence.new({ ColorSequenceKeypoint.new(0, C.A1), ColorSequenceKeypoint.new(0.5, C.A2), ColorSequenceKeypoint.new(1, C.A1) })
end
function U.round(o, r, scale) return new("UICorner", { CornerRadius = scale and UDim.new(r, 0) or UDim.new(0, r) }, o) end
function U.stroke(o, t, ogRole)
    local s = new("UIStroke", { Color = C.WHITE, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
    local g = new("UIGradient", { Color = U.activeTheme == "og funhub" and ColorSequence.new(C[ogRole or "BORDER"]) or U.seq2() }, s)
    g:SetAttribute("OgColorRole", ogRole or "BORDER")
    R.sg[#R.sg + 1] = g
    return s
end
function U.tgrad(o)
    local og = U.activeTheme == "og funhub"
    local g = new("UIGradient", { Color = U.seq3(), Enabled = not og }, o)
    if og then o.TextColor3 = C[o:GetAttribute("OgTextRole") or "TEXT"] end
    R.tg[#R.tg + 1] = g
    return g
end
function U.pad(o, l, r, t, b)
    return new("UIPadding", { PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or l or 0),
        PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or t or 0) }, o)
end
function U.list(o, gap, dir)
    return new("UIListLayout", { Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = dir or Enum.FillDirection.Vertical }, o)
end

local FONTS = {
    { "Gotham", Enum.Font.Gotham }, { "Source Sans", Enum.Font.SourceSans }, { "Arial", Enum.Font.Arial },
    { "Roboto", Enum.Font.Roboto }, { "Roboto Mono", Enum.Font.RobotoMono }, { "Ubuntu", Enum.Font.Ubuntu },
    { "Nunito", Enum.Font.Nunito }, { "Merriweather", Enum.Font.Merriweather }, { "Oswald", Enum.Font.Oswald },
    { "Code", Enum.Font.Code }, { "Highway", Enum.Font.Highway }, { "Garamond", Enum.Font.Garamond },
    { "Fantasy", Enum.Font.Fantasy }, { "Antique", Enum.Font.Antique },
}
local WR, WM, WB = Enum.FontWeight.Regular, Enum.FontWeight.Medium, Enum.FontWeight.Bold
U.family = Font.fromEnum(Enum.Font.Gotham).Family
function U.setFont(name)
    local e = Enum.Font.Gotham
    for _, f in ipairs(FONTS) do if f[1] == name then e = f[2] end end
    U.family = Font.fromEnum(e).Family
    for o, w in pairs(R.texts) do pcall(function() o.FontFace = Font.new(U.family, w) end) end
end
U.setFont(U.get("font", "Gotham"))

function U.text(class, parent, text, size, weight, color, xa)
    local o = new(class, { BackgroundTransparency = 1, BorderSizePixel = 0, Text = text or "", TextSize = size or 13,
        TextColor3 = color or C.TEXT, TextXAlignment = xa or Enum.TextXAlignment.Left,
        FontFace = Font.new(U.family, weight or WR) }, parent)
    if class == "TextButton" then o.AutoButtonColor = false end
    R.texts[o] = weight or WR
    return o
end
function U.hit(parent, z)
    return new("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), AutoButtonColor = false, ZIndex = z or 2 }, parent)
end

local gui = new("ScreenGui", { Name = HttpService:GenerateGUID(false), ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000 })
if not pcall(function() gui.Parent = gethui() end) or not gui.Parent then gui.Parent = safeGuiTarget end
local root = new("Frame", { Name = "Root", BackgroundTransparency = 1, Size = UDim2.fromOffset(1745, 960) }, gui)
local uiScale = new("UIScale", {}, root)
function U.scalePercent(value)
    value = tonumber(value) or 100
    if value ~= value then value = 100 end
    return math.clamp(value, 50, 150)
end
function U.panelScale(f)
    local state = R.windows[f]
    if state and state.running then return state.baseScale end
    local scale = f:FindFirstChild("FHPanelScale")
    return scale and scale.Scale or 1
end
function U.registerScale(f, key)
    local saved = type(AC.uiPanelScales) == "table" and AC.uiPanelScales or {}
    local scale = new("UIScale", { Name = "FHPanelScale", Scale = U.scalePercent(saved[key]) / 100 }, f)
    R.panelScales[key] = { f = f, scale = scale }
end
if AC.uiScaleTarget == "Base Timer" then AC.uiScaleTarget = "Leave Timer" end
U.scaleTargets = { ["Main Menu"] = "main", ["Autograb"] = "bar", ["Actions"] = "actions",
    ["Admin Spammer"] = "adminspam", ["Leave Timer"] = "mybase", ["Watermark"] = "watermark" }
function U.getSelectedScale()
    local key = U.scaleTargets[U.get("uiScaleTarget", "All UI")]
    if not key then return U.scalePercent(U.get("uiScalePercent", 100)) end
    return U.scalePercent(type(AC.uiPanelScales) == "table" and AC.uiPanelScales[key])
end
function U.applyPanelScales()
    U.fit()
    if U.clampWindows then U.clampWindows() end
end
function U.setSelectedScale(value)
    local key = U.scaleTargets[U.get("uiScaleTarget", "All UI")]
    if key then
        AC.uiPanelScales = type(AC.uiPanelScales) == "table" and AC.uiPanelScales or {}
        AC.uiPanelScales[key] = U.scalePercent(value)
    else AC.uiScalePercent = U.scalePercent(value) end
    U.applyPanelScales()
    saveHubConfig()
end
function U.fit()
    if U.finishWindows then U.finishWindows() end
    local saved = type(AC.uiPanelScales) == "table" and AC.uiPanelScales or {}
    for key, entry in pairs(R.panelScales) do
        if entry.f.Parent then entry.scale.Scale = U.scalePercent(saved[key]) / 100 end
    end
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local s = math.max(vp.Y / 960, 0.45)
    if U.activeTheme == "og funhub" then
        s = math.clamp(vp.X / 1920, IsMobile and 0.6 or 0.5, IsMobile and 0.9 or 1.2)
        s = math.min(s, (vp.X - 16) / (IsMobile and 420 or 380), (vp.Y - 16) / (IsMobile and 520 or 480))
    elseif U.activeTheme == "Funhub 5.5" then
        s = IsMobile and math.min((vp.X - 24) / 350, (vp.Y - 24) / 400, 1.15)
            or math.clamp(vp.Y / 1080, 0.85, 1.15)
    elseif U.activeTheme == "Funhub 1.4 GUI" and IsMobile then
        s = math.min(vp.X / 390, vp.Y / 620)
    elseif vp.X / s < 760 then s = vp.X / 760 end
    uiScale.Scale = math.max(s * U.scalePercent(U.get("uiScalePercent", 100)) / 100, 0.1)
    root.Size = UDim2.fromOffset(vp.X / uiScale.Scale, vp.Y / uiScale.Scale)
    if U.clampWindows then task.defer(U.clampWindows) end
end
U.fit()
U.on(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    U.fit()
    if Workspace.CurrentCamera then U.on(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), U.fit) end
end)
if Workspace.CurrentCamera then U.on(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), U.fit) end
function U.toRoot(v) return (v - root.AbsolutePosition) / uiScale.Scale end

U.locked = U.get("guiLock", false)
function U.savePos(key, f)
    local p = f.Position
    AC.pos[key] = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
    if key == "main" and U.themeStarted then
        AC.themeLayouts[U.activeTheme] = { pos = AC.pos[key], size = { f.Size.X.Offset, f.Size.Y.Offset } }
    end
    saveHubConfig()
end
function U.loadPos(key, f)
    local p = AC.pos[key]
    if type(p) == "table" and #p == 4 then f.Position = UDim2.new(p[1], p[2], p[3], p[4]) end
end
function U.drag(handle, target, key, onClick, onHold)
    handle.InputBegan:Connect(function(i)
        if i.UserInputType ~= MB1 and i.UserInputType ~= TOUCH then return end
        if FUNHUBUI.bindingInput or FUNHUBKeys.blocked(i) then return end
        local start, pos, moved, held, finished = i.Position, target.Position, false, false, false
        if onHold and i.UserInputType == TOUCH then
            task.delay(0.5, function()
                if not finished and not moved and target.Parent and FUNHUB_ALIVE()
                    and not FUNHUBUI.bindingInput and not FUNHUBKeys.blocked() then
                    held = true
                    onHold()
                    FUNHUBKeys.consume(i) -- A held menu button must not click again on release.
                end
            end)
        end
        local mv = UserInputService.InputChanged:Connect(function(j)
            if not held and (j.UserInputType == MOVE or j == i) then
                local d = (j.Position - start) / uiScale.Scale
                if math.abs(d.X) + math.abs(d.Y) > 4 then moved = true end
                if moved and not U.locked then
                    target.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
                end
            end
        end)
        local ec
        ec = i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End or i.UserInputState == Enum.UserInputState.Cancel then
                finished = true
                mv:Disconnect() ec:Disconnect()
                if moved and key and not U.locked then U.savePos(key, target) end
                if not moved and not held and onClick and i.UserInputState == Enum.UserInputState.End then onClick() end
            end
        end)
    end)
end

function U.panel(parent, size, pos, anchor, bgT, radius, key, strokeT)
    local f = new("Frame", { Size = size, Position = pos, AnchorPoint = anchor or Vector2.zero, BackgroundColor3 = C.WIN,
        BackgroundTransparency = bgT or 0, BorderSizePixel = 0, Active = true }, parent or root)
    U.skin(U.round(f, radius or 16), "CornerRadius", UDim.new(0, radius or 16), UDim.new(0, radius or 16), UDim.new(0, 12))
    U.stroke(f, strokeT or 1.4)
    R.wins[#R.wins + 1] = { f = f, base = bgT or 0,
        minBase = key == "quickPanel" and 0.55 or nil }
    if f.Parent == root and key then U.registerScale(f, key) R.windowKeys[f] = key end
    if key then U.loadPos(key, f) end
    return f
end
-- Keep target visibility separate while a close animation is still playing.
function U.windowOpen(f)
    local state = R.windows[f]
    if state then return state.open end
    return f.Visible
end
function U.finishWindow(f)
    local state = R.windows[f]
    if not state or not state.running then return end
    state.version += 1
    if state.tween then state.tween:Cancel() end
    state.running = false
    if f.Parent then state.scale.Scale = state.baseScale f.Visible = state.open end
end
function U.finishWindows()
    for f in pairs(R.windows) do U.finishWindow(f) end
end
function U.showWindow(f, visible, setting)
    visible = visible == true
    local state = R.windows[f]
    if not state then
        local scale = f:FindFirstChild("FHPanelScale") or new("UIScale", { Name = "FHPanelScale", Scale = 1 }, f)
        state = { open = f.Visible, scale = scale, version = 0 }
        R.windows[f] = state
    end
    U.finishWindow(f)
    local changed = state.open ~= visible
    state.open, state.baseScale = visible, state.scale.Scale
    local key = R.windowKeys[f]
    if key then
        AC.windows = type(AC.windows) == "table" and AC.windows or {}
        AC.windows[key] = visible
    end
    if setting then AC[setting] = visible end
    saveHubConfig()
    if not changed then f.Visible = visible return end
    state.version += 1
    local version = state.version
    state.running = true
    if visible then state.scale.Scale = state.baseScale * 0.88 end
    f.Visible = true
    local duration = visible and 0.22 or 0.16
    state.tween = TweenService:Create(state.scale, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Scale = state.baseScale * (visible and 1 or 0.88) })
    state.tween:Play()
    task.delay(duration, function()
        if state.version ~= version or not f.Parent then return end
        state.running = false
        state.scale.Scale, f.Visible = state.baseScale, state.open
    end)
end
function U.restoreWindow(f)
    local saved = type(AC.windows) == "table" and AC.windows[R.windowKeys[f]]
    if type(saved) == "boolean" then f.Visible = saved end
end
function U.applyWindowSettings()
    for f, key in pairs(R.windowKeys) do
        if f.Parent and (key:sub(1, 4) == "sub_" or key:sub(1, 4) == "pop_") then
            local saved = type(AC.windows) == "table" and AC.windows[key]
            if type(saved) == "boolean" then U.showWindow(f, saved) end
        end
    end
end
R.cleanup[#R.cleanup + 1] = U.finishWindows

function U.applyTransparency()
    local p = math.clamp((tonumber(U.get("guiT", 0)) or 0) / 100, 0, 0.95)
    for _, w in ipairs(R.wins) do
        if w.f.Parent then
            local base = U.activeTheme == "og funhub" and 0.02
                or U.compactTheme() and (w.mainBase or math.max(w.base, 0.18)) or w.base
            base = math.max(base, w.minBase or 0)
            w.f.BackgroundTransparency = base + (1 - base) * p
        end
    end
    if MENU then
        MENU.BackgroundTransparency = 0.5 + 0.5 * p
        local stroke = MENU:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Transparency = 0.3 + 0.7 * p end
    end
end

function U.header(f, title, h, ts, key)
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1 }, f)
    U.pad(hd, 10, 10)
    local t = U.text("TextLabel", hd, title, ts, WB, C.WHITE)
    t.Size = UDim2.new(1, -110, 1, 0)
    U.tgrad(t)
    local btns = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(168, 30), BackgroundTransparency = 1 }, hd)
    local l = U.list(btns, 7, Enum.FillDirection.Horizontal)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Right
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    U.drag(hd, f, key)
    return hd, btns, t
end
function U.hbtn(btns, text, order, fn)
    local b = U.text("TextButton", btns, text, 14, WB, C.DIM, Enum.TextXAlignment.Center)
    b.Size = UDim2.fromOffset(22, 22)
    b.LayoutOrder = order
    b.MouseButton1Click:Connect(fn)
    return b
end
function U.resizer(f, minW, minH, key, size)
    local b = new("TextButton", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(size or 16, size or 16),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 6 }, f)
    for _, s in ipairs({ { (size or 16) - 4, 2 }, { 2, (size or 16) - 4 } }) do
        U.round(new("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), Size = UDim2.fromOffset(s[1], s[2]),
            BackgroundColor3 = C.DIM, BorderSizePixel = 0 }, b), 1)
    end
    if type(AC.size) == "table" and type(AC.size[key]) == "table" then
        f.Size = UDim2.fromOffset(AC.size[key][1], AC.size[key][2])
    end
    b.InputBegan:Connect(function(i)
        if i.UserInputType ~= MB1 and i.UserInputType ~= TOUCH then return end
        local start, sz = i.Position, f.Size
        local mv = UserInputService.InputChanged:Connect(function(j)
            if (j.UserInputType == MOVE or j == i) and not U.locked then
                local d = (j.Position - start) / (uiScale.Scale * U.panelScale(f))
                f.Size = UDim2.fromOffset(math.max(minW, sz.X.Offset + d.X), math.max(minH, sz.Y.Offset + d.Y))
            end
        end)
        local ec
        ec = i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                mv:Disconnect() ec:Disconnect()
                if key then
                    AC.size = type(AC.size) == "table" and AC.size or {}
                    AC.size[key] = { f.Size.X.Offset, f.Size.Y.Offset }
                    if key == "main" then U.savePos(key, f) end
                    saveHubConfig()
                end
            end
        end)
    end)
    return b
end

function U.scroller(parent, pos, size, pad, gap)
    local s = new("ScrollingFrame", { Position = pos, Size = size, BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = C.A1, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, Active = true, ScrollingEnabled = true,
        ClipsDescendants = true }, parent)
    R.bars[#R.bars + 1] = s
    U.pad(s, pad or 10, pad or 10, pad or 10, pad or 10)
    U.list(s, gap or 8)
    return s
end

local ORDER = 0
local function nxt() ORDER = ORDER + 1 return ORDER end

function U.styleCard(card)
    if not card.f.Parent then return end
    local og, modern = U.activeTheme == "og funhub", U.activeTheme == "Funhub 5.5"
    if card.title then
        card.title.Parent = (og or modern) and card.outer or card.f
        card.title.Size = UDim2.new(1, 0, 0, (og or modern) and 24 or 16)
        card.title.TextSize = modern and 15 or 11
        local names = { ["AUTO STEAL"] = "Stealing", ASSIST = "Instant Steal", ["BASE HUDS"] = "Base HUDs",
            ESP = "ESP", MOVEMENT = "Movement", MISC = "Settings", ADMIN = "Admin Panel" }
        card.title.Text = modern and (names[card.heading] or card.heading) or card.heading
    end
    card.list.Padding = UDim.new(0, og and 0 or modern and 4 or 7)
    card.pad.PaddingTop, card.pad.PaddingBottom = UDim.new(0, og and 2 or modern and 6 or 10), UDim.new(0, og and 2 or modern and 6 or 10)
    card.pad.PaddingLeft, card.pad.PaddingRight = UDim.new(0, og and 0 or modern and 8 or 10), UDim.new(0, og and 0 or modern and 8 or 10)
end
function U.card(parent, title)
    -- Keep the same content frame/callbacks; OG places its heading above the section body.
    local outer = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = nxt() }, parent)
    U.list(outer, 0)
    local f = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.CARD,
        BorderSizePixel = 0, LayoutOrder = 1 }, outer)
    U.skin(U.round(f, 10), "CornerRadius", UDim.new(0, 10), UDim.new(0, 10), UDim.new(0, 8))
    local stroke = U.stroke(f, 1, "SEP")
    U.skin(stroke, "Transparency", 0, 0, 0.5)
    local card = { f = f, outer = outer, home = parent, heading = title, list = U.list(f, 7), pad = U.pad(f, 10, 10, 10, 10) }
    U.skin(f, "BackgroundTransparency", 0.35, 0, 0.3)
    if title then
        local l = U.text("TextLabel", f, title, 11, WB, C.WHITE)
        l.Size = UDim2.new(1, 0, 0, 16)
        l.LayoutOrder = 0
        l:SetAttribute("OgTextRole", "DIM")
        U.tgrad(l)
        card.title = l
    end
    R.cards[#R.cards + 1] = card
    U.styleCard(card)
    return f
end
function U.row(parent, h, bg)
    local r = new("Frame", { Size = UDim2.new(1, 0, 0, h or 34), BackgroundColor3 = bg or C.CARD, BorderSizePixel = 0, LayoutOrder = nxt() }, parent)
    U.round(r, 10)
    local rowStroke = U.stroke(r, 1)
    U.pad(r, 10, 10)
    U.skin(r, "BackgroundTransparency", 1, 0, 1)
    U.skin(rowStroke, "Transparency", 1, 0, 1)
    r:SetAttribute("FHRowHeight", h or 34)
    R.controlRows = R.controlRows or setmetatable({}, { __mode = "k" })
    R.controlRows[r] = true
    if U.activeTheme == "Funhub 5.5" then r.Size = UDim2.new(1, 0, 0, math.max(h or 34, IsMobile and 40 or 32)) end
    U.on(r.MouseEnter, function()
        if U.activeTheme ~= "Aurora Hub" then tween(r, 0.15, { BackgroundTransparency = 0.85 }) end
    end)
    U.on(r.MouseLeave, function()
        if U.activeTheme ~= "Aurora Hub" then tween(r, 0.15, { BackgroundTransparency = 1 }) end
    end)
    return r
end
function U.switch(parent, on)
    local sw = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(40, 20),
        BackgroundColor3 = C.ELEM, BorderSizePixel = 0 }, parent)
    U.round(sw, 10)
    local g = new("UIGradient", { Color = U.seq2() }, sw)
    R.fg[#R.fg + 1] = g
    local st = new("UIStroke", { Color = C.DIM, Thickness = 1, Transparency = 0.6 }, sw)
    local knob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = C.TEXT, BorderSizePixel = 0 }, sw)
    U.round(knob, 10)
    U.skin(sw, "Size", UDim2.fromOffset(42, 22), UDim2.fromOffset(40, 20), UDim2.fromOffset(38, 20))
    U.skin(knob, "Size", UDim2.fromOffset(18, 18), UDim2.fromOffset(16, 16))
    local current = on
    local function paint(v, instant)
        current = v
        local main = U.compactTheme()
        local og = U.activeTheme == "og funhub"
        TweenService:Create(knob, TweenInfo.new(instant and 0 or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Position = v and UDim2.new(1, main and -20 or -18, 0.5, 0) or UDim2.new(0, og and 3 or 2, 0.5, 0),
              BackgroundColor3 = og and (v and C.WHITE or rgb(140, 140, 140)) or main and (v and C.WHITE or rgb(180, 200, 255)) or C.TEXT }):Play()
        local modern = U.activeTheme == "Funhub 5.5"
        sw.BackgroundColor3 = modern and Color3.new(C.A1.R * (v and 0.4 or 0.3), C.A1.G * (v and 0.4 or 0.3), C.A1.B * (v and 0.4 or 0.3))
            or (v and C.A1 or (og and C.OFF or C.ELEM))
        g.Enabled = not main and not og and v and true or false
        st.Color = og and C.SEP or C.DIM
        st.Transparency = og and 0.5 or main and 1 or (v and 1 or 0.6)
    end
    R.switches[#R.switches + 1] = function() if sw.Parent then paint(current, true) end end
    return paint
end

local binds, listening = {}, nil
function U.contains(frame, position)
    if not frame or not frame.Parent or not frame.Visible or not gui.Enabled then return false end
    local pos, size = frame.AbsolutePosition, frame.AbsoluteSize
    return position.X >= pos.X and position.Y >= pos.Y and position.X <= pos.X + size.X and position.Y <= pos.Y + size.Y
end
FUNHUBUI.pointerInHub = function(input)
    if not input or input.UserInputType == Enum.UserInputType.Keyboard then return false end
    for _, frame in ipairs(root:GetChildren()) do
        if frame:IsA("GuiObject") and U.contains(frame, input.Position) then return true end
    end
    return false
end
function U.shortKey(k)
    local m = { LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift",
        LeftAlt = "LAlt", RightAlt = "RAlt", Backquote = "`", MouseButton1 = "LMB", MouseButton2 = "RMB", MouseButton3 = "MMB" }
    return m[k] or k
end
function U.commitBinding(name, value)
    AC.keys[name] = FUNHUBKeys.decode(value) and value or nil
    AC.keybindSchema = 2
    if name == "semiSteal" then
        HubConfig.stealKeybind = AC.keys[name] or "None"
        currentStealKey = FUNHUBKeys.decode(HubConfig.stealKeybind)
        KeybindBtn.Text = currentStealKey and U.shortKey(currentStealKey.Name) or "None"
        bindStealKey()
    end
    saveHubConfig()
end
function U.beginBinding(name, show)
    if FUNHUBKeys.blocked() then return false end
    isBinding = false
    local previous = listening
    listening = nil
    if previous then previous.show() end
    listening = { name = name, show = show }
    FUNHUBUI.bindingInput = true
    return true
end
FUNHUBUI.beginStealBinding = function()
    if U.beginBinding("semiSteal", function()
        KeybindBtn.Text = currentStealKey and U.shortKey(currentStealKey.Name) or "None"
    end) then KeybindBtn.Text = "..." end
end
function U.chip(parent, name, fn)
    local b = U.text("TextButton", parent, "", 10, WB, C.DIM, Enum.TextXAlignment.Center)
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, -46, 0.5, 0)
    b.Size = UDim2.fromOffset(30, 18)
    b.BackgroundTransparency, b.BackgroundColor3, b.ZIndex = 0, C.ELEM, 3
    U.round(b, 0.5, true) U.stroke(b, 1)
    binds[name] = fn
    local function show()
        if listening and listening.name == name then return end
        b.Text = AC.keys[name] and U.shortKey(AC.keys[name]) or "—"
    end
    show()
    b.MouseButton1Click:Connect(function() if U.beginBinding(name, show) then b.Text = "..." end end)
    -- Right click is an assignable input. Backspace clears; Escape cancels.
    R.rows[#R.rows + 1] = show
    return b
end
U.on(UserInputService.InputBegan, function(input, processed)
    if FUNHUBKeys.blocked(input) then return end
    local key = FUNHUBKeys.input(input)
    if listening then
        if not key then return end
        local pending = listening
        FUNHUBKeys.consume(input)
        listening, FUNHUBUI.bindingInput = nil, false
        if key == "Backspace" or key == "Delete" then U.commitBinding(pending.name, nil)
        elseif key ~= "Escape" then U.commitBinding(pending.name, key) end
        pending.show()
        return
    end
    if not key or isBinding or FUNHUBUI.bindingInput or UserInputService:GetFocusedTextBox()
        or FUNHUBUI.pointerInHub(input) then return end
    if FUNHUBUI.passQuickGrabKey and FUNHUBUI.passQuickGrabKey(FUNHUBKeys.decode(key)) then return end
    for name, assigned in pairs(AC.keys) do
        if name ~= "semiSteal" and assigned == key and binds[name]
            and (not processed or (input.UserInputType == Enum.UserInputType.Keyboard
                and (name == "menu" or name == "hide"))) then task.spawn(binds[name]) end
    end
end)
R.cleanup[#R.cleanup + 1] = function()
    listening, isBinding, FUNHUBUI.bindingInput = nil, false, false
    FUNHUBUI.beginStealBinding, FUNHUBUI.pointerInHub = nil, nil
    FUNHUBKeys.captureHeld = false
end

function U.toggle(parent, text, opt)
    local r = U.row(parent)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Size = UDim2.new(1, opt.chip and -86 or (opt.dots and -78 or -48), 1, 0)
    l.TextTruncate = Enum.TextTruncate.AtEnd
    local state = opt.get() and true or false
    local paint = U.switch(r, state)
    paint(state, true)
    local hit = U.hit(r, 2)
    local function set(v, silent)
        state = v and true or false
        paint(state)
        if not silent then
            local ok, err = pcall(opt.set, state)
            if not ok then warn("[FUNHUB] " .. text .. ": " .. tostring(err)) end
        end
    end
    hit.MouseButton1Click:Connect(function()
        if not FUNHUBUI.bindingInput and not FUNHUBKeys.blocked() then set(not state) end
    end)
    if opt.dots then
        local d = U.text("TextLabel", r, "⋯", 15, WB, C.DIM, Enum.TextXAlignment.Center)
        d.AnchorPoint = Vector2.new(1, 0.5)
        d.Position = UDim2.new(1, -50, 0.5, 0)
        d.Size = UDim2.new(0, 14, 1, 0)
        local b = U.hit(r, 3)
        b.AnchorPoint = Vector2.new(1, 0.5)
        b.Position = UDim2.new(1, -45, 0.5, 0)
        b.Size = UDim2.new(0, 28, 1, 0)
        b.MouseButton1Click:Connect(function() opt.dots(r) end)
    end
    if opt.chip then U.chip(r, opt.chip, function() set(not state) end) end
    if opt.keyName then
        binds[opt.keyName] = function() set(not state) end
        hit.MouseButton2Click:Connect(function()
            if U.beginBinding(opt.keyName, function()
                local key = AC.keys[opt.keyName]
                l.Text = key and (text .. " (" .. U.shortKey(key) .. ")") or text
            end) then l.Text = text .. " (...)" end
        end)
    end
    if opt.tip then U.tip(r, opt.tip) end
    R.rows[#R.rows + 1] = function() local v = opt.get() and true or false if v ~= state then set(v, true) end end
    return set, r
end

function U.slider(parent, text, lo, hi, step, get, setv)
    local r = U.row(parent, 44)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Position = UDim2.fromOffset(0, 6)
    l.Size = UDim2.new(1, -56, 0, 16)
    local box = U.text("TextBox", r, "", 12, WB, C.DIM, Enum.TextXAlignment.Right)
    box.Position = UDim2.new(1, -52, 0, 6)
    box.Size = UDim2.fromOffset(52, 16)
    box.ClearTextOnFocus = false
    local track = new("Frame", { Position = UDim2.new(0, 0, 1, -16), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = C.ELEM, BorderSizePixel = 0 }, r)
    U.round(track, 3)
    local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.A2, BorderSizePixel = 0 }, track)
    U.round(fill, 3)
    R.bg2[#R.bg2 + 1] = fill
    local knob = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(13, 13), BackgroundColor3 = C.TEXT, BorderSizePixel = 0 }, track)
    U.round(knob, 10)
    local grab = new("TextButton", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 2 }, track)
    local dec = step >= 1 and 0 or (step >= 0.1 and 1 or 2)
    local function fmt(v)
        if dec == 0 then return tostring(math.floor(v + 0.5)) end
        local s = string.format("%." .. dec .. "f", v)
        s = s:gsub("0+$", ""):gsub("%.$", "")
        return s
    end
    local function show(v)
        local p = math.clamp((v - lo) / (hi - lo), 0, 1)
        fill.Size = UDim2.fromScale(p, 1)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        box.Text = fmt(v)
    end
    local function apply(v)
        v = math.clamp(math.floor(v / step + 0.5) * step, lo, hi)
        show(v)
        local ok, err = pcall(setv, v)
        if not ok then warn("[FUNHUB] " .. text .. ": " .. tostring(err)) end
    end
    local sliding = nil
    local function at(x)
        apply(lo + (hi - lo) * math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1))
    end
    grab.InputBegan:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then sliding = i at(i.Position.X) end
    end)
    U.on(UserInputService.InputChanged, function(i)
        if sliding and (i.UserInputType == MOVE or i == sliding) then at(i.Position.X) end
    end)
    U.on(UserInputService.InputEnded, function(i)
        if sliding and (i.UserInputType == MB1 or i == sliding) then sliding = nil end
    end)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then apply(n) else show(tonumber(get()) or lo) end
    end)
    show(tonumber(get()) or lo)
    R.rows[#R.rows + 1] = function() if not sliding and not box:IsFocused() then show(tonumber(get()) or lo) end end
    return r
end

function U.drop(parent, text, options, opt)
    local outer = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.CARD,
        BorderSizePixel = 0, LayoutOrder = nxt() }, parent)
    U.round(outer, 10) U.stroke(outer, 1) U.list(outer, 0)
    local head = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = 0 }, outer)
    U.pad(head, 10, 10)
    local n = U.text("TextLabel", head, text, 13, WM)
    n.Size = UDim2.new(0.48, -8, 1, 0)
    local v = U.text("TextLabel", head, "", 12, WR, C.DIM, Enum.TextXAlignment.Right)
    v.AnchorPoint = Vector2.new(1, 0.5)
    v.Position = UDim2.new(1, -18, 0.5, 0)
    v.Size = UDim2.new(0.52, -18, 1, 0)
    v.TextTruncate = Enum.TextTruncate.AtEnd
    local a = U.text("TextLabel", head, "v", 11, WB, C.DIM, Enum.TextXAlignment.Center)
    a.AnchorPoint = Vector2.new(1, 0.5)
    a.Position = UDim2.new(1, 0, 0.5, 0)
    a.Size = UDim2.new(0, 14, 1, 0)
    local hit = U.hit(head, 2)
    local list = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        Visible = false, LayoutOrder = 1 }, outer)
    U.pad(list, 10, 10, 0, 8)
    U.list(list, 2)
    local btns = {}
    local function opts() return type(options) == "function" and options() or options end
    local function isSel(o)
        local g = opt.get()
        if opt.multi then return type(g) == "table" and table.find(g, o) ~= nil end
        return g == o
    end
    local function refresh()
        if opt.multi then
            local s = {}
            for _, o in ipairs(opts()) do if isSel(o) then s[#s + 1] = o end end
            v.Text = #s > 0 and table.concat(s, ", ") or (opt.none or "None")
        else
            v.Text = tostring(opt.get() or "")
        end
        for o, b in pairs(btns) do b.TextColor3 = isSel(o) and C.TEXT or C.DIM end
    end
    local function build()
        for _, b in pairs(btns) do b:Destroy() end
        table.clear(btns)
        for i, o in ipairs(opts()) do
            local b = U.text("TextButton", list, o, 12, WR, C.DIM)
            b.Size = UDim2.new(1, 0, 0, 26)
            b.LayoutOrder = i
            b.MouseButton1Click:Connect(function()
                if opt.multi then
                    local g = table.clone(type(opt.get()) == "table" and opt.get() or {})
                    local idx = table.find(g, o)
                    if idx then table.remove(g, idx) else g[#g + 1] = o end
                    opt.set(g)
                else
                    opt.set(o)
                    list.Visible = false
                    a.Rotation = 0
                end
                refresh()
            end)
            btns[o] = b
        end
        refresh()
    end
    hit.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
        a.Rotation = list.Visible and 180 or 0
        if list.Visible then build() end
    end)
    build()
    R.rows[#R.rows + 1] = refresh
    return refresh
end

function U.sep(parent)
    local f = new("Frame", { Size = UDim2.new(1, -16, 0, 1), Position = UDim2.new(0, 8, 0, 0),
        BackgroundColor3 = C.STROKE or Color3.fromRGB(80, 80, 80), BorderSizePixel = 0, LayoutOrder = nxt() }, parent)
    return f
end
function U.button(parent, text, fn, bg, keyName)
    local r = U.row(parent, 34, bg or C.ELEM)
    local l = U.text("TextLabel", r, text, 13, WM, C.WHITE, Enum.TextXAlignment.Center)
    l.Size = UDim2.fromScale(1, 1)
    local h = U.hit(r, 2)
    local baseText = text
    local bindName = keyName or ("btn_" .. text:gsub("%s+", "_"):lower())
    local function show()
        if listening and listening.name == bindName then
            l.Text = baseText .. " (...)"
            return
        end
        local key = AC.keys[bindName]
        l.Text = key and (baseText .. " (" .. U.shortKey(key) .. ")") or baseText
    end
    show()
    h.MouseButton1Click:Connect(function()
        if FUNHUBUI.bindingInput or FUNHUBKeys.blocked() then return end
        local ok, err = pcall(fn, l)
        if not ok then warn("[FUNHUB] " .. text .. ": " .. tostring(err)) end
    end)
    binds[bindName] = fn
    h.MouseButton2Click:Connect(function()
        if U.beginBinding(bindName, show) then l.Text = baseText .. " (...)" end
    end)
    R.rows[#R.rows + 1] = show
    return l, r
end
function U.stepper(parent, textf, dec, inc)
    local l, r = U.button(parent, textf(), function() end)
    for _, s in ipairs({ { "-", 0, 6, dec }, { "+", 1, -6, inc } }) do
        local b = U.text("TextButton", r, s[1], 18, WB, C.TEXT, Enum.TextXAlignment.Center)
        b.BackgroundTransparency = 0
        b.BackgroundColor3 = C.CARD
        b.AnchorPoint = Vector2.new(s[2], 0.5)
        b.Position = UDim2.new(s[2], s[3], 0.5, 0)
        b.Size = UDim2.fromOffset(26, 20)
        b.ZIndex = 3
        U.round(b, 6)
        b.MouseButton1Click:Connect(function() pcall(s[4]) l.Text = textf() end)
    end
    R.rows[#R.rows + 1] = function() l.Text = textf() end
    return l
end
function U.keyRow(parent, text, name, fn)
    local r = U.row(parent)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Size = UDim2.new(1, -86, 1, 0)
    local b = U.text("TextButton", r, "", 12, WB, C.DIM, Enum.TextXAlignment.Center)
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, 0, 0.5, 0)
    b.Size = UDim2.fromOffset(74, 22)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.ELEM
    U.round(b, 10) U.stroke(b, 1)
    binds[name] = fn
    local function show()
        if listening and listening.name == name then return end
        b.Text = AC.keys[name] and U.shortKey(AC.keys[name]) or "None"
    end
    show()
    b.MouseButton1Click:Connect(function() if U.beginBinding(name, show) then b.Text = "..." end end)
    R.rows[#R.rows + 1] = show
end
function U.input(parent, text, ph, init, onDone, readOnly)
    local r = U.row(parent)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Size = UDim2.new(1, -124, 1, 0)
    local b = U.text("TextBox", r, init or "", 12, WR, C.TEXT)
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, 0, 0.5, 0)
    b.Size = UDim2.fromOffset(116, 20)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.ELEM
    b.PlaceholderText = ph or ""
    b.PlaceholderColor3 = C.DIM
    b.ClearTextOnFocus = false
    b.TextEditable = not readOnly
    b.TextTruncate = Enum.TextTruncate.AtEnd
    U.round(b, 6) U.pad(b, 6, 6)
    if onDone then b.FocusLost:Connect(function() onDone(b.Text) end) end
    return b
end

local TIP = U.panel(root, UDim2.fromOffset(224, 0), UDim2.new(), nil, 0, 10, nil, 1)
TIP.AutomaticSize = Enum.AutomaticSize.Y
TIP.Visible = false
TIP.ZIndex = 60
U.pad(TIP, 9, 9, 7, 8)
local TIPL = U.text("TextLabel", TIP, "", 12, WR, C.DIM)
TIPL.Size = UDim2.new(1, 0, 0, 0)
TIPL.AutomaticSize = Enum.AutomaticSize.Y
TIPL.TextWrapped = true
TIPL.ZIndex = 61
function U.tip(obj, text)
    obj.MouseEnter:Connect(function()
        TIPL.Text = text
        local p = U.toRoot(obj.AbsolutePosition)
        TIP.Position = UDim2.fromOffset(p.X + obj.AbsoluteSize.X / uiScale.Scale + 10, p.Y)
        TIP.Visible = true
    end)
    obj.MouseLeave:Connect(function() TIP.Visible = false end)
end

local TOASTS = new("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.fromOffset(250, 420),
    BackgroundTransparency = 1 }, root)
do
    local l = U.list(TOASTS, 6)
    l.VerticalAlignment = Enum.VerticalAlignment.Bottom
end
function U.notify(title, text, dur)
    local t = U.panel(TOASTS, UDim2.new(1, 0, 0, 0), UDim2.new(), nil, 0, 12, nil, 1)
    t.AutomaticSize = Enum.AutomaticSize.Y
    t.LayoutOrder = nxt()
    U.pad(t, 12, 12, 9, 10)
    U.list(t, 3)
    local a = U.text("TextLabel", t, title, 13, WB, C.WHITE)
    a.Size = UDim2.new(1, 0, 0, 16)
    U.tgrad(a)
    if text and text ~= "" then
        local b = U.text("TextLabel", t, text, 12, WR, C.DIM)
        b.Size = UDim2.new(1, 0, 0, 0)
        b.AutomaticSize = Enum.AutomaticSize.Y
        b.TextWrapped = true
        b.LayoutOrder = 1
    end
    task.delay(dur or 3, function() pcall(function() t:Destroy() end) end)
end

local MAIN = U.panel(root, UDim2.fromOffset(320, 420), UDim2.new(0.5, 420, 0.5, 0), Vector2.new(0.5, 0.5), 0, 16, "main")
MAIN.Visible = U.get("mainOpen", true)
for _, w in ipairs(R.wins) do if w.f == MAIN then w.mainBase = 0.3 end end
local mainHd, mainBtns, mainTitle = U.header(MAIN, "FUNHUB", 34, 14, "main")
mainTitle.Size, mainTitle.TextTruncate = UDim2.new(1, -168, 1, 0), Enum.TextTruncate.AtEnd
U.resizer(MAIN, 280, 260, "main")
function U.setMainOpen(visible)
    if visible then U.finishWindow(MAIN) U.clampWindows() end
    U.showWindow(MAIN, visible, "mainOpen")
end
function U.toggleMain() U.setMainOpen(not U.windowOpen(MAIN)) end

function U.repaintAccent()
    for o, bindings in pairs(R.themed) do
        if o.Parent then
            for property, binding in pairs(bindings) do
                if C[binding.role] and o[property] == binding.value then
                    o[property], binding.value = C[binding.role], C[binding.role]
                end
            end
        end
    end
    local og = U.activeTheme == "og funhub"
    for _, g in ipairs(R.sg) do
        g.Color = og and ColorSequence.new(C[g:GetAttribute("OgColorRole") or "BORDER"]) or U.seq2()
        if og then g.Rotation = 0 elseif U.activeTheme == "Funhub 5.5" then g.Rotation = 205.421 end
    end
    for _, g in ipairs(R.fg) do g.Color = U.seq2() end
    for _, g in ipairs(R.tg) do
        g.Color, g.Enabled = U.seq3(), not og and U.activeTheme ~= "Funhub 5.5"
        if g.Parent then g.Parent.TextColor3 = og and C[g.Parent:GetAttribute("OgTextRole") or "TEXT"] or C.WHITE end
    end
    for _, o in ipairs(R.bg1) do o.BackgroundColor3 = C.A1 end
    for _, o in ipairs(R.bg2) do o.BackgroundColor3 = C.A2 end
    for _, o in ipairs(R.tx1) do o.TextColor3 = C.A1 end
    for _, o in ipairs(R.tx2) do o.TextColor3 = C.A2 end
    for _, s in ipairs(R.bars) do s.ScrollBarImageColor3 = C.A1 end
    for _, f in ipairs(R.rows) do pcall(f) end
    AC.accent1, AC.accent2 = toT(C.A1), toT(C.A2)
    AC.themeAccents = type(AC.themeAccents) == "table" and AC.themeAccents or {}
    AC.themeAccents[U.activeTheme] = { AC.accent1, AC.accent2 }
    for _, paint in ipairs(R.switches) do paint() end
    saveHubConfig()
end
for i, which in ipairs({ "A1", "A2" }) do
    local dot = new("TextButton", { Size = UDim2.fromOffset(13, 13), BackgroundColor3 = C[which], Text = "", AutoButtonColor = false,
        LayoutOrder = i, BorderSizePixel = 0 }, mainBtns)
    U.round(dot, 0.5, true)
    R[which == "A1" and "bg1" or "bg2"][#R[which == "A1" and "bg1" or "bg2"] + 1] = dot
    dot.MouseButton1Click:Connect(function()
        U.openThemeColor(which)
    end)
end
local lockBtn = U.hbtn(mainBtns, U.locked and "🔒" or "🔓", 3, function() end)
lockBtn.MouseButton1Click:Connect(function()
    U.locked = not U.locked
    lockBtn.Text = U.locked and "🔒" or "🔓"
    U.set("guiLock", U.locked)
end)
U.hbtn(mainBtns, "X", 4, function() U.setMainOpen(false) end)

local mainBody = new("Frame", { Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34), BackgroundTransparency = 1 }, MAIN)
local tabBar = new("ScrollingFrame", { Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 28),
    BackgroundTransparency = 1, BorderSizePixel = 0, CanvasSize = UDim2.new(), ScrollBarThickness = 2,
    ScrollingDirection = Enum.ScrollingDirection.X, AutomaticCanvasSize = Enum.AutomaticSize.None,
    ScrollBarImageColor3 = C.A1, ClipsDescendants = true, Active = true, ScrollingEnabled = true }, mainBody)
U.list(tabBar, 0, Enum.FillDirection.Horizontal)
local pageHolder = new("Frame", { Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 1, -38), BackgroundTransparency = 1, ClipsDescendants = true }, mainBody)
local TABS, PAGES, tabOrder = {}, {}, { "Stealing", "Player", "Visuals", "Admin", "Misc", "Configs" }
local TAB_W = { Stealing = 0.20408164, Player = 0.163265303, Visuals = 0.183673471, Admin = 0.142857149, Misc = 0.122448981, Configs = 0.183673471 }
function U.refreshTabScroll(selected)
    local width = math.max(0, MAIN.Size.X.Offset + tabBar.Size.X.Offset)
    if not tabBar.ScrollingEnabled then
        tabBar.CanvasSize, tabBar.CanvasPosition = UDim2.new(), Vector2.zero
        return
    end
    local visible = {}
    for name, tab in pairs(TABS) do
        if tab.btn.Visible then visible[#visible + 1] = { name = name, btn = tab.btn } end
    end
    table.sort(visible, function(a, b) return a.btn.LayoutOrder < b.btn.LayoutOrder end)
    local gap = tabBar:FindFirstChildOfClass("UIListLayout").Padding.Offset
    local total, selectedLeft, selectedRight = 0, nil, nil
    for i, tab in ipairs(visible) do
        if i > 1 then total = total + gap end
        local itemWidth = tab.btn.Size.X.Scale * width + tab.btn.Size.X.Offset
        if tab.name == selected then selectedLeft, selectedRight = total, total + itemWidth end
        total = total + itemWidth
    end
    tabBar.CanvasSize = UDim2.fromOffset(math.ceil(total), 0)
    local scroll = tabBar.CanvasPosition.X
    if selectedLeft then
        if selectedLeft < scroll then scroll = selectedLeft
        elseif selectedRight > scroll + width then scroll = selectedRight - width end
    end
    tabBar.CanvasPosition = Vector2.new(math.clamp(scroll, 0, math.max(0, total - width)), 0)
end
function U.selectTab(name)
    local modern = U.activeTheme == "Funhub 5.5"
    if modern and (name == "Admin" or name == "Configs") then name = "Misc" end
    if not TABS[name] then name = "Stealing" end
    for n, t in pairs(TABS) do
        local on = n == name
        t.btn.TextColor3 = on and C.TEXT or C.DIM
        local filled = U.activeTheme ~= "Aurora Hub"
        t.line.Visible = on and not filled
        t.btn.BackgroundTransparency = filled and 0 or 1
        t.btn.BackgroundColor3 = modern and (on and Color3.new(C.A2.R * 0.6, C.A2.G * 0.6, C.A2.B * 0.6)
            or Color3.new(C.A1.R * 0.4, C.A1.G * 0.4, C.A1.B * 0.4))
            or (on and C.A1 or (U.activeTheme == "og funhub" and C.TAB or C.ELEM))
        if modern and on then
            local c = t.btn.BackgroundColor3
            t.btn.TextColor3 = (c.R * 0.2126 + c.G * 0.7152 + c.B * 0.0722) > 0.45 and rgb(15, 18, 26) or rgb(245, 247, 255)
        end
        PAGES[n].Visible = on
    end
    U.refreshTabScroll(name)
    U.set("tab", name)
end
for i, name in ipairs(tabOrder) do
    local b = U.text("TextButton", tabBar, name, 13, WM, C.DIM, Enum.TextXAlignment.Center)
    b.Size = UDim2.new(TAB_W[name], 0, 1, 0)
    U.round(b, 12)
    b.LayoutOrder = i
    local line = new("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(1, -8, 0, 2),
        BackgroundColor3 = C.A1, BorderSizePixel = 0, Visible = false }, b)
    U.round(line, 1)
    R.bg1[#R.bg1 + 1] = line
    TABS[name] = { btn = b, line = line }
    PAGES[name] = U.scroller(pageHolder, UDim2.new(), UDim2.fromScale(1, 1), 10, 8)
    PAGES[name].Visible = false
    b.MouseButton1Click:Connect(function() U.selectTab(name) end)
end

U.on(tabBar:GetPropertyChangedSignal("AbsoluteSize"), function()
    U.refreshTabScroll(U.get("tab", "Stealing"))
end)

function U.clampWindows()
    if not gui.Parent then return end
    local size = Vector2.new(root.Size.X.Offset, root.Size.Y.Offset)
    for _, w in ipairs(R.wins) do
        local f = w.f
        if f ~= F.themeWatermark and f.Parent == root and f.AutomaticSize == Enum.AutomaticSize.None then
            local scale = U.panelScale(f)
            local fw = math.min(f.Size.X.Offset * scale, size.X - 16)
            local fh = math.min(f.Size.Y.Offset * scale, size.Y - 16)
            f.Size = UDim2.fromOffset(math.max(40, fw / scale), math.max(20, fh / scale))
            local x = f.Position.X.Scale * size.X + f.Position.X.Offset - fw * f.AnchorPoint.X
            local y = f.Position.Y.Scale * size.Y + f.Position.Y.Offset - fh * f.AnchorPoint.Y
            x = math.clamp(x, 8, math.max(8, size.X - fw - 8))
            y = math.clamp(y, 8, math.max(8, size.Y - fh - 8))
            f.Position = UDim2.fromOffset(x + fw * f.AnchorPoint.X, y + fh * f.AnchorPoint.Y)
        end
    end
    if U.pinWatermark then U.pinWatermark() end
end
function U.applyTheme(name, startup)
    U.migrateGuiNames()
    if name == "Funhub Main" then name = "Funhub 1.4 GUI" end
    if not U.themes[name] then name = "Funhub 5.5" end
    if not startup and U.activeTheme == name then return end
    AC.themeLayouts = type(AC.themeLayouts) == "table" and AC.themeLayouts or {}
    local p = MAIN.Position
    if U.themeStarted or not AC.themeLayouts[U.activeTheme] then
        AC.themeLayouts[U.activeTheme] = { pos = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset },
            size = { MAIN.Size.X.Offset, MAIN.Size.Y.Offset } }
    end
    U.themeStarted = true
    U.activeTheme, AC.guiTheme = name, name
    local compact, modern = U.compactTheme(name), name == "Funhub 5.5"
    local og = name == "og funhub"
    for role, value in pairs(U.themes[name]) do C[role] = value end
    AC.themeAccents = type(AC.themeAccents) == "table" and AC.themeAccents or {}
    local accents = AC.themeAccents[name]
    if type(accents) == "table" then C.A1, C.A2 = fromT(accents[1], C.A1), fromT(accents[2], C.A2) end
    local custom = type(AC.themeColors) == "table" and AC.themeColors[name]
    if type(custom) == "table" then
        for _, role in ipairs({ "WIN", "CARD", "ELEM", "A1", "A2" }) do C[role] = fromT(custom[role], C[role]) end
    end
    for o, bindings in pairs(R.themed) do
        if o.Parent then
            for property, binding in pairs(bindings) do
                if o[property] == binding.value then o[property] = C[binding.role] binding.value = C[binding.role] end
            end
        end
    end
    for _, skin in ipairs(R.skins) do
        if skin.o.Parent then skin.o[skin.property] = U.skinValue(skin) end
    end
    for _, card in ipairs(R.cards) do
        if card.home == PAGES.Admin or card.home == PAGES.Configs then
            card.outer.Parent = modern and PAGES.Misc or card.home
        end
        U.styleCard(card)
    end
    for row in pairs(R.controlRows or {}) do
        if row.Parent then
            local original = row:GetAttribute("FHRowHeight") or 34
            row.Size = UDim2.new(1, 0, 0, modern and math.max(original, IsMobile and 40 or 32) or original)
        end
    end
    mainTitle.Text = modern and "FUNHUB 5.5" or og and "Fun Hub v1.4" or compact and "Funhub 1.4 GUI" or "AURORA HUB"
    MAIN:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, (modern or og) and 12 or 16)
    mainTitle.TextSize = (og or compact) and 18 or 14
    mainHd.Size = UDim2.new(1, 0, 0, og and 46 or compact and 42 or 34)
    mainBody.Position = UDim2.fromOffset(0, og and 46 or compact and 42 or 34)
    mainBody.Size = UDim2.new(1, 0, 1, og and -46 or compact and -42 or -34)
    tabBar.Position = UDim2.fromOffset((og or compact) and 12 or 10, (og or modern) and 0 or compact and 6 or 10)
    tabBar.Size = UDim2.new(1, (og or compact) and -24 or -20, 0, og and (IsMobile and 38 or 34) or compact and 36 or 28)
    tabBar.ScrollingEnabled = og or compact
    tabBar.ScrollBarImageColor3 = C.A1
    tabBar:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, og and 8 or compact and 6 or 0)
    tabBar.CanvasPosition = Vector2.zero
    pageHolder.Position = UDim2.fromOffset(0, (og or modern) and 42 or compact and 48 or 38)
    pageHolder.Size = UDim2.new(1, 0, 1, (og or modern) and -42 or compact and -48 or -38)
    for n, tab in pairs(TABS) do
        local labels = { Stealing = "Main", Visuals = "Visual", Player = "Player", Misc = "Utils" }
        local order = { Stealing = 1, Visuals = 2, Player = 3, Misc = 4 }
        tab.btn.Visible = not modern or labels[n] ~= nil
        tab.btn.Text = modern and (labels[n] or n) or n
        tab.btn.LayoutOrder = modern and (order[n] or 99) or table.find(tabOrder, n)
        tab.btn.Size = modern and UDim2.new(0, IsMobile and 100 or 90, 1, -3) or og and UDim2.new(0, 80, 1, -4) or compact and UDim2.new(0, n == "Stealing" and 82 or 72, 1, -3) or UDim2.new(TAB_W[n], 0, 1, 0)
        tab.btn.TextSize = og and 12 or compact and 14 or 13
        tab.btn:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, og and 7 or 12)
        PAGES[n]:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, og and 12 or 8)
    end
    U.fit()
    local layout = AC.themeLayouts[name]
    if layout and type(layout.pos) == "table" and #layout.pos == 4 then
        MAIN.Position = UDim2.new(layout.pos[1], layout.pos[2], layout.pos[3], layout.pos[4])
        if type(layout.size) == "table" then MAIN.Size = UDim2.fromOffset(layout.size[1], layout.size[2]) end
    else
        MAIN.Position = (og or modern) and UDim2.new(0.5, 0, 0.5, 0) or compact and UDim2.new(0.5, 0, 0.5, 39) or UDim2.new(0.5, 420, 0.5, 0)
        MAIN.Size = og and UDim2.fromOffset(IsMobile and 420 or 380, IsMobile and 520 or 480)
            or compact and UDim2.fromOffset(350, 400) or UDim2.fromOffset(320, 420)
    end
    U.applyTransparency()
    U.repaintAccent()
    for _, paint in ipairs(R.switches) do paint() end
    U.selectTab(U.get("tab", "Stealing"))
    if U.themeExtras then U.themeExtras() end
    U.clampWindows()
    U.savePos("main", MAIN)
    saveHubConfig()
end

local POP = {}
function U.popup(title, key)
    local f = U.panel(root, UDim2.fromOffset(226, 50), UDim2.fromOffset(1182, 300), nil, 0, 16, "pop_" .. key, 1)
    f.Visible = false
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, f)
    U.pad(hd, 10, 10)
    local t = U.text("TextLabel", hd, title, 12, WB, C.WHITE)
    t.Size = UDim2.new(1, -28, 1, 0)
    U.tgrad(t)
    local x = U.text("TextButton", hd, "X", 12, WB, C.DIM, Enum.TextXAlignment.Center)
    x.AnchorPoint = Vector2.new(1, 0.5)
    x.Position = UDim2.new(1, 0, 0.5, 0)
    x.Size = UDim2.fromOffset(28, 28)
    x.MouseButton1Click:Connect(function() U.showWindow(f, false) end)
    U.drag(hd, f, "pop_" .. key)
    local body = U.scroller(f, UDim2.fromOffset(0, 30), UDim2.new(1, 0, 1, -30), 10, 7)
    local lay = body:FindFirstChildOfClass("UIListLayout")
    local function resize()
        f.Size = UDim2.fromOffset(226, math.min(30 + lay.AbsoluteContentSize.Y / uiScale.Scale + 22, 480))
    end
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)
    task.defer(resize)
    local p = { f = f, body = body, key = "pop_" .. key }
    POP[key] = p
    U.restoreWindow(f)
    return p
end
function U.openPop(p, row)
    if U.windowOpen(p.f) then U.showWindow(p.f, false) return end
    if not AC.pos[p.key] and MAIN.Visible then
        local wl = U.toRoot(MAIN.AbsolutePosition).X
        local ry = row and U.toRoot(row.AbsolutePosition).Y or 100
        local maxY = root.AbsoluteSize.Y / uiScale.Scale - p.f.Size.Y.Offset - 8
        p.f.Position = UDim2.fromOffset(math.max(wl - 226 - 8, 4), math.clamp(ry - 8, 4, math.max(maxY, 4)))
    end
    U.showWindow(p.f, true)
end
-- Theme dots open this editor without changing a color. Values persist per theme.
do
    local picker = U.popup("Theme Colors", "themeColors")
    local roles = { Background = "WIN", Panels = "CARD", Controls = "ELEM", ["Accent 1"] = "A1", ["Accent 2"] = "A2" }
    local target, hexBox, preview = "Accent 1", nil, nil
    local function selected() return C[roles[target]] end
    local function refresh()
        local value = selected()
        local channels = toT(value)
        if preview then
            preview.BackgroundColor3 = value
            preview.TextColor3 = (value.R * 0.299 + value.G * 0.587 + value.B * 0.114) > 0.55 and rgb(0, 0, 0) or C.WHITE
            preview.Text = target .. " preview"
        end
        if hexBox and not hexBox:IsFocused() then hexBox.Text = string.format("#%02X%02X%02X", channels[1], channels[2], channels[3]) end
    end
    function U.setThemeColor(role, value)
        if role ~= "WIN" and role ~= "CARD" and role ~= "ELEM" and role ~= "A1" and role ~= "A2" then return end
        C[role] = value
        AC.themeColors = type(AC.themeColors) == "table" and AC.themeColors or {}
        local custom = AC.themeColors[U.activeTheme]
        if type(custom) ~= "table" then custom = {} AC.themeColors[U.activeTheme] = custom end
        custom[role] = toT(value)
        U.repaintAccent()
        U.selectTab(U.get("tab", "Stealing"))
        refresh()
    end
    U.drop(picker.body, "Edit", { "Background", "Panels", "Controls", "Accent 1", "Accent 2" }, {
        get = function() return target end,
        set = function(value) target = value for _, show in ipairs(R.rows) do pcall(show) end end,
    })
    for index, channel in ipairs({ "Red", "Green", "Blue" }) do
        U.slider(picker.body, channel, 0, 255, 1,
            function() return toT(selected())[index] end,
            function(value)
                local channels = toT(selected())
                channels[index] = value
                U.setThemeColor(roles[target], rgb(channels[1], channels[2], channels[3]))
            end)
    end
    hexBox = U.input(picker.body, "Hex Color", "#000000", "", function(text)
        local hex = tostring(text):match("^%s*#?(%x%x%x%x%x%x)%s*$")
        if not hex then U.notify("Theme Colors", "Use six hex digits, such as #001A40.") refresh() return end
        U.setThemeColor(roles[target], rgb(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)))
    end)
    local row = U.row(picker.body, 32)
    preview = U.text("TextLabel", row, "", 12, WB, C.WHITE, Enum.TextXAlignment.Center)
    preview.Size, preview.BackgroundTransparency = UDim2.fromScale(1, 1), 0
    U.round(preview, 6)
    U.button(picker.body, "Black + Dark Blue", function()
        local colors = { WIN = { 0, 0, 0 }, CARD = { 8, 12, 22 }, ELEM = { 14, 26, 52 }, A1 = { 23, 55, 115 }, A2 = { 38, 85, 170 } }
        AC.themeColors = type(AC.themeColors) == "table" and AC.themeColors or {}
        AC.themeColors[U.activeTheme] = colors
        for role, channels in pairs(colors) do C[role] = fromT(channels, C[role]) end
        U.repaintAccent()
        U.selectTab(U.get("tab", "Stealing"))
        refresh()
    end)
    R.rows[#R.rows + 1] = refresh
    function U.openThemeColor(role)
        for label, key in pairs(roles) do if key == role then target = label break end end
        for _, show in ipairs(R.rows) do pcall(show) end
        if not picker.f.Visible then U.openPop(picker) end
        U.clampWindows()
    end
    refresh()
end

local SUB = {}
function U.sub(title, key)
    local f = U.panel(root, UDim2.fromOffset(260, 320), UDim2.new(0.66, 0, 0.5, 0), Vector2.new(0.5, 0.5), 0, 16, "sub_" .. key)
    f.Visible = false
    local _, btns = U.header(f, title, 34, 14, "sub_" .. key)
    local body = new("Frame", { Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34), BackgroundTransparency = 1, ClipsDescendants = true }, f)
    local sc = U.scroller(body, UDim2.new(), UDim2.fromScale(1, 1), 10, 8)
    local mini, full = false, nil
    U.hbtn(btns, "-", 1, function()
        mini = not mini
        if mini then full = f.Size end
        body.Visible = not mini
        f.Size = mini and UDim2.fromOffset(f.Size.X.Offset, 34) or (full or UDim2.fromOffset(260, 320))
    end)
    U.hbtn(btns, "X", 2, function() U.showWindow(f, false) end)
    U.resizer(f, 220, 140, "sub_" .. key)
    local p = { f = f, body = sc, card = U.card(sc), key = key }
    SUB[key] = p
    U.restoreWindow(f)
    return p
end
function U.openSub(p) U.showWindow(p.f, not U.windowOpen(p.f)) end

local ANIMALS, RARITIES = {}, {}
pcall(function() ANIMALS = require(ReplicatedStorage.Datas.Animals) end)
pcall(function() RARITIES = require(ReplicatedStorage.Datas.Rarities) end)

function F.char()
    local c = LP.Character
    return c, c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
end
function F.myPlot() local ok, p = pcall(findMyBase) return ok and p or nil end
function F.stealing() return isStealBoostLive() end
function F.money(n)
    n = tonumber(n) or 0
    local units = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
    for _, u in ipairs(units) do
        if n >= u[1] then
            local v = n / u[1]
            return "$" .. (v >= 100 and string.format("%d", v) or (string.format("%.1f", v):gsub("%.0$", ""))) .. u[2] .. "/s"
        end
    end
    return "$" .. math.floor(n) .. "/s"
end
function F.rarity(name) local d = ANIMALS[name] return d and d.Rarity or "Common" end
function F.rarityColor(r)
    local d = RARITIES[r]
    if d and typeof(d.Color) == "Color3" then return d.Color end
    return C.TEXT
end
function F.genOf(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text:match("^%$[%d%.]+[KMBT]?/s$") then return d.Text, nil end
    end
    local data = ANIMALS[model.Name]
    return F.money(data and data.Generation or 0), data and data.Generation or 0
end
function F.genValue(text)
    local n, u = tostring(text):match("%$([%d%.]+)([KMBT]?)/s")
    n = tonumber(n) or 0
    return n * (({ K = 1e3, M = 1e6, B = 1e9, T = 1e12 })[u] or 1)
end
function F.ownerName(plot) local ok, n = pcall(plotOwnerName, plot) return ok and n or "?" end
function F.enemyPlots() local ok, l = pcall(enemyPlotList) return ok and l or {} end

function F.brainrots(force)
    local now = os.clock()
    local function snapshot(items)
        local copy = {}
        for _, item in ipairs(items) do
            if item.plot.Parent and item.model.Parent and item.model:IsDescendantOf(item.plot) then
                copy[#copy + 1] = table.clone(item)
            end
        end
        return copy
    end
    if not force and F.brainrotCache and now < F.brainrotCache.expires then
        return snapshot(F.brainrotCache.items)
    end
    local out = {}
    for _, plot in ipairs(F.enemyPlots()) do
        local pods = plot:FindFirstChild("AnimalPodiums")
        local spots, models, edges = {}, {}, {}
        for _, pod in ipairs(pods and pods:GetChildren() or {}) do
            local base = pod:FindFirstChild("Base")
            local spawn = base and base:FindFirstChild("Spawn")
            if spawn and spawn:IsA("BasePart") and tonumber(pod.Name) then
                spots[#spots + 1] = { slot = tonumber(pod.Name), part = spawn, pod = pod }
            end
        end
        table.sort(spots, function(a, b) return a.slot < b.slot end)
        for _, model in ipairs(plot:GetDescendants()) do
            if model:IsA("Model") and ANIMALS[model.Name] then
                local parent, nested = model.Parent, false
                while parent and parent ~= plot do
                    if parent:IsA("Model") and ANIMALS[parent.Name] then nested = true break end
                    parent = parent.Parent
                end
                if not nested then
                    local ok, pivot = pcall(model.GetPivot, model)
                    if ok then
                        local text, value = F.genOf(model)
                        local item = { model = model, plot = plot, name = model.Name, gen = value or F.genValue(text),
                            genText = text, owner = F.ownerName(plot), rarity = F.rarity(model.Name) }
                        models[#models + 1] = item
                        for _, spot in ipairs(spots) do
                            local distance = (spot.part.Position - pivot.Position).Magnitude
                            if distance < 14 then
                                edges[#edges + 1] = { item = item, spot = spot, distance = distance,
                                    inside = model:IsDescendantOf(spot.pod) }
                            end
                        end
                    end
                end
            end
        end
        table.sort(edges, function(a, b)
            if a.inside ~= b.inside then return a.inside end
            if a.distance ~= b.distance then return a.distance < b.distance end
            if a.spot.slot ~= b.spot.slot then return a.spot.slot < b.spot.slot end
            return a.item.name < b.item.name
        end)
        local used = {}
        for _, edge in ipairs(edges) do
            if not edge.item.slot and not used[edge.spot.pod] then
                edge.item.slot, edge.item.spawn = edge.spot.slot, edge.spot.part
                used[edge.spot.pod] = true
            end
        end
        for _, item in ipairs(models) do out[#out + 1] = item end
    end
    F.brainrotCache = { items = out, expires = os.clock() + (IsMobile and 0.6 or 0.2) }
    return snapshot(out)
end
R.cleanup[#R.cleanup + 1] = function() F.brainrotCache = nil end

local CHIPS = FUNHUBUI.cfgChips or {}
local DEF_ON = { antiBeeEnabled = true, antiGummyEnabled = true, antiDiscoEnabled = true, antiPaintEnabled = true, antiWebEnabled = true,
    antiSwapEnabled = true, destroySentryEnabled = true, destroyDogeEnabled = true, antiRagdollEnabled = true, antiRocketEnabled = true,
    pillBarEnabled = true, potionEnabled = true, showPathEnabled = true }
function F.cfg(key)
    local v = HubConfig[key]
    if v == nil then return DEF_ON[key] == true end
    return v == true
end
function F.setCfg(key, v)
    v = v == true
    HubConfig[key] = v
    if CHIPS[key] then CHIPS[key](v) end
    if key == "kickAfterStealEnabled" then KickAfterStealEnabled = v end
    if key == "autoRejoinEnabled" then
        AC.ownBaseTimer = v -- compatibility with older profiles; never read as a second switch
        if F.baseLeave then F.baseLeave.left = false end
        if not v and F.stopBaseRejoin then F.stopBaseRejoin() end
        if not v and F.closeBaseLeave then F.closeBaseLeave() end
        if F.baseHud then F.baseHud() end
    end
    if key == "publicGrabEnabled" then
        FUNHUBFx.pubGrab = v
        if F.autoGrabSync then F.autoGrabSync() end
    end
    saveHubConfig()
end
function F.setLeaveTimer(v) F.setCfg("autoRejoinEnabled", v) end
-- A saved display-only flag must never silently arm the leave action.
if AC.ownBaseTimer ~= F.cfg("autoRejoinEnabled") then
    AC.ownBaseTimer = F.cfg("autoRejoinEnabled")
    saveHubConfig()
end
function F.num(key, def) return tonumber(HubConfig[key]) or def end
function F.setNum(key, v) HubConfig[key] = v saveHubConfig() end
local function chipOpt(key) return { get = function() return F.cfg(key) end, set = function(v) F.setCfg(key, v) end } end
local function acOpt(key, def, after)
    return { get = function() return U.get(key, def) end, set = function(v) U.set(key, v) if after then after(v) end end }
end

-- Autograb/Best/Priority owns enablement; Public selects its saved alternate method.
function F.autoGrabSync()
    -- Keep the saved Nearest setting from earlier versions under the single Autograb toggle.
    if AC.autoNearest ~= nil then
        if AC.autoGrab == nil then AC.autoGrab = AC.autoNearest == true and not AC.autoBest and not AC.autoPriority end
        AC.autoNearest = nil
        saveHubConfig()
    end
    if AC.autoGrab == true and (AC.autoBest == true or AC.autoPriority == true) then
        AC.autoGrab = false
        saveHubConfig()
    end
    local paused = FUNHUBFx.backgroundPaused()
    FUNHUBHold.normalEnabled = not paused and (AC.autoGrab == true or AC.autoBest == true or AC.autoPriority == true)
    FUNHUBHold.sourceGrabEnabled = not paused and AC.autoGrab == true
    FUNHUBFx.pubGrab = F.cfg("publicGrabEnabled")
    if not FUNHUBHold.normalEnabled then FUNHUBHold.clearNormal() end
    if not FUNHUBFx.pubGrab or not FUNHUBHold.normalEnabled then FUNHUBHold.clearPublic() end
    if F.invalidateAutoTarget then F.invalidateAutoTarget() end
end
function F.backgroundPauseTick()
    if F.lastBackgroundPaused ~= FUNHUBFx.backgroundPaused() then FUNHUBFx.syncBackground() end
end
function F.setAutoGrab(v)
    AC.autoGrab, AC.autoNearest, AC.autoBest, AC.autoPriority = v == true, nil, false, false
    saveHubConfig()
    F.autoGrabSync()
    if F.priorityShow then F.priorityShow(false) end
end
function F.setAutoMode(key, enabled)
    if key == "autoNearest" then F.setAutoGrab(enabled) return end
    if enabled then
        AC.autoGrab, AC.autoNearest = false, nil
        for _, name in ipairs({ "autoBest", "autoPriority" }) do AC[name] = name == key end
    else AC[key] = false end
    saveHubConfig()
    F.autoGrabSync()
    if F.priorityShow then F.priorityShow(AC.autoPriority == true) end
end
U.on(LP.CharacterRemoving, function()
    table.clear(FUNHUBFx.semiPauses)
    FUNHUB.debounce = false
    FUNHUBHold.clearAuto()
    if F.autoPotion then F.autoPotion.clear() end
    FUNHUBFx.syncBackground()
end)
U.on(LP.CharacterAdded, function() FUNHUBFx.syncBackground() end)
R.cleanup[#R.cleanup + 1] = function()
    table.clear(FUNHUBFx.semiPauses)
    FUNHUBHold.normalEnabled = false
    FUNHUBHold.clearAuto()
    FUNHUB.semiQuickGrab = false
    local ctx = FUNHUBHold.progress.contexts["Semi TP"]
    if ctx then FUNHUB.semiSource.stop(ctx) end
    table.clear(FUNHUBHold.progress.contexts)
    FUNHUBHold.progress.result, FUNHUBHold.progress.pendingSemi = nil, nil
end

function F.instaReset()
    if F.smallSpeed then F.smallSpeed.Cancel(false) end
    pcall(function() _G.FUNHUB_SemiTP_InstaReset() end)
end

F.CMDS = { "ragdoll", "jumpscare", "morph", "jail", "tiny", "nightvision", "control", "balloon", "inverse", "rocket" }
-- Supplied DatShawn AP dispatcher: one command/player pair at a time, shared with Quick Panel.
F.AP = { alive = true, busy = false, lastUse = {},
    order = { "balloon", "tiny", "rocket", "inverse", "ragdoll", "jail", "morph", "jumpscare", "control", "nightvision" },
    cooldowns = { rocket = 120, ragdoll = 30, balloon = 30, inverse = 60, jail = 60,
        control = 60, tiny = 60, jumpscare = 60, morph = 60 } }
R.cleanup[#R.cleanup + 1] = function() F.AP.alive = false end
function F.adminGui()
    local pg = LP:FindFirstChild("PlayerGui")
    local g = pg and pg:FindFirstChild("AdminPanel")
    return g, g and g:FindFirstChild("AdminPanel")
end
function F.cmdButton(cmd)
    local _, panel = F.adminGui()
    if not panel then return nil end
    local content = panel:FindFirstChild("Content")
    local scope = content and content:FindFirstChild("ScrollingFrame") or panel
    for _, b in ipairs(scope:GetDescendants()) do
        if b:IsA("GuiButton") and b.Name ~= "Template" then
            if b.Name:lower() == cmd then return b end
            local c = b:FindFirstChild("Command")
            if c and c:IsA("TextLabel") and c.Text:lower():gsub("^;", ""):match("^%s*(.-)%s*$") == cmd then return b end
        end
    end
end
function F.cmdCooldown(cmd)
    local b = F.cmdButton(cmd)
    local t = b and b:FindFirstChild("Timer")
    local remote = 0
    if t and t:IsA("GuiObject") and t.Visible then
        local label = (t:IsA("TextLabel") or t:IsA("TextButton") or t:IsA("TextBox")) and t
            or t:FindFirstChildWhichIsA("TextLabel", true)
        local text = label and tostring(label.Text) or ""
        local m, s = text:match("(%d+):(%d+)")
        remote = m and (tonumber(m) * 60 + tonumber(s)) or (tonumber(text:match("%d+")) or 1)
    end
    local used = F.AP.lastUse[cmd]
    local cached = used and math.max(0, (F.AP.cooldowns[cmd] or 0) - (os.clock() - used)) or 0
    return math.max(remote, cached)
end
function F.cooldownText(seconds)
    seconds = tonumber(seconds) or 0
    return seconds > 0 and (tostring(math.ceil(seconds)) .. "s") or "ready"
end
function F.pressAdmin(b)
    if not b or not b.Parent then return false end
    if type(getconnections) == "function" then
        for _, signal in ipairs({ b.Activated, b.MouseButton1Click }) do
            local ok, connections = pcall(getconnections, signal)
            if ok and type(connections) == "table" then
                for _, connection in ipairs(connections) do
                    local fired, handled = pcall(function()
                        if connection.Enabled == false then return false end
                        if type(connection.Fire) == "function" then connection:Fire() return true end
                        if type(connection.Function) == "function" then connection.Function() return true end
                        return false
                    end)
                    if fired and handled then return true end
                end
            end
        end
    end
    -- Fire one click event, not both: double firing can change the shared selection twice.
    if type(firesignal) == "function" then
        return pcall(firesignal, b.MouseButton1Click)
    end
    return false
end
function F.adminPlayerButton(scope, target)
    if not scope then return nil end
    local fallback, rank, displayUnique = nil, 0, true
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= target and p.DisplayName == target.DisplayName then displayUnique = false break end
    end
    for _, b in ipairs(scope:GetDescendants()) do
        if b:IsA("GuiButton") and b.Name ~= "Template" then
            if b.Name == tostring(target.UserId) or b.Name == target.Name
                or tonumber(b:GetAttribute("UserId")) == target.UserId then return b end
            local score = 0
            local function check(text)
                if text == target.Name or text == "@" .. target.Name then score = 2
                elseif score < 1 and displayUnique and text == target.DisplayName then score = 1 end
            end
            if b:IsA("TextButton") then check(b.Text) end
            for _, label in ipairs(b:GetDescendants()) do
                if label:IsA("TextLabel") then check(label.Text) end
            end
            if score > rank then fallback, rank = b, score end
        end
    end
    return fallback
end
function F.runAdminPair(cmd, target)
    local g, panel = F.adminGui()
    if not panel or not F.AP.alive or not FUNHUB_ALIVE() or not target or not target.Parent then return false end
    local b = F.cmdButton(cmd)
    if not b or F.cmdCooldown(cmd) > 0 then return false end
    local was = panel.Visible
    local ok, fired = pcall(function()
        panel.Visible = true
        if not F.pressAdmin(b) then return false end
        task.wait(0.03)
        if not F.AP.alive or not FUNHUB_ALIVE() or not target.Parent then return false end
        local profiles = panel:FindFirstChild("Profiles")
        local scope = profiles and (profiles:FindFirstChild("ScrollingFrame") or profiles) or g
        local button = F.adminPlayerButton(scope, target)
        if button and button ~= b and F.pressAdmin(button) then
            F.AP.lastUse[cmd] = os.clock()
            task.wait(0.03) -- Let the player callback finish before selecting the next command.
            return true
        end
        return false
    end)
    pcall(function() panel.Visible = was end)
    return ok and fired == true
end
function F.adminCmd(cmd, target)
    if F.AP.busy or not F.AP.alive then return false end
    F.AP.busy = true
    local ok, fired = pcall(F.runAdminPair, tostring(cmd):lower(), target)
    F.AP.busy = false
    return ok and fired == true
end
function F.nearestPlayer(maxD)
    local _, _, hrp = F.char()
    if not hrp then return nil end
    local best, bd = nil, maxD or math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if r then
            local d = (r.Position - hrp.Position).Magnitude
            if d < bd then best, bd = p, d end
        end
    end
    return best
end
-- One public chat message after an AP batch, never one message per command.
F.tauntState = { busy = false, nextAt = 0 }
function F.tauntAfterAP(used)
    if (tonumber(used) or 0) <= 0 or not U.get("taunt", false)
        or not F.AP.alive or not FUNHUB_ALIVE() then return false end
    local state = F.tauntState
    if state.busy or os.clock() < state.nextAt then return false end
    state.busy, state.nextAt = true, os.clock() + 10
    task.spawn(function()
        if not U.get("taunt", false) or not F.AP.alive or not FUNHUB_ALIVE() then
            state.busy = false
            return
        end
        local ok, sent = pcall(function()
            local chat = game:GetService("TextChatService")
            if chat.ChatVersion == Enum.ChatVersion.TextChatService then
                local channels = chat:FindFirstChild("TextChannels")
                local general = channels and channels:FindFirstChild("RBXGeneral")
                if not general or not general:IsA("TextChannel") then return false end
                -- Always use public chat, even if the user is currently whispering.
                local message = general:SendAsync("funhub on top")
                return message ~= nil and message.Status == Enum.TextChatMessageStatus.Success
            end
            local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local remote = events and events:FindFirstChild("SayMessageRequest")
            if not remote or not remote:IsA("RemoteEvent") then return false end
            remote:FireServer("funhub on top", "All")
            return true
        end)
        state.busy = false
        if (not ok or not sent) and F.AP.alive and FUNHUB_ALIVE() and U.get("taunt", false) then
            U.notify("Taunt", "Could not send in public chat. Check that chat is available.")
        end
    end)
    return true
end


function F.spamCmds(list, target, mode)
    if not F.AP.alive or not FUNHUB_ALIVE() or not target or not target.Parent or type(list) ~= "table" then return false end
    if F.AP.busy then
        if mode then U.notify("AP Spammer", "A command batch is already running") end
        return false
    end
    local selected, commands = {}, {}
    for _, cmd in ipairs(list) do if type(cmd) == "string" then selected[cmd:lower()] = true end end
    for _, cmd in ipairs(F.AP.order) do if selected[cmd] then commands[#commands + 1] = cmd end end
    if #commands == 0 then
        if mode then U.notify("AP Spammer", "Select commands for " .. mode .. " first") end
        return false
    end
    F.AP.busy = true -- Acquire before spawning so two clicks cannot interleave batches.
    task.spawn(function()
        local used = 0
        for _, cmd in ipairs(commands) do
            if not F.AP.alive or not FUNHUB_ALIVE() or not target.Parent then break end
            local ok, fired = pcall(F.runAdminPair, cmd, target)
            if ok and fired then used = used + 1 end
        end
        F.AP.busy = false
        if used > 0 and F.AP.alive and FUNHUB_ALIVE() then F.tauntAfterAP(used) end
        if mode and F.AP.alive and FUNHUB_ALIVE() then
            U.notify("AP " .. mode, used > 0 and (target.DisplayName .. " · " .. used .. " commands sent")
                or "No commands sent · check cooldowns and Admin Panel")
        end
    end)
    return true
end

F.SPAM1_DEF = { "balloon", "tiny", "rocket", "inverse" }
F.SPAM2_DEF = { "balloon", "rocket", "inverse", "ragdoll", "jail", "morph", "jumpscare" }
if AC.spamAfter == nil then AC.spamAfter = AC.adminSpam == true end
if AC.spam1Cmds == nil and type(AC.spamCmds) == "table" then AC.spam1Cmds = table.clone(AC.spamCmds) end
function F.semiOwner(plot)
    local name = plot and F.ownerName(plot)
    if not name or name == "?" then return nil end
    local display, count
    count = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            if p.Name == name then return p end
            if p.DisplayName == name then display, count = p, count + 1 end
        end
    end
    return count == 1 and display or nil
end
function F.onSemiPickup(attempt)
    if attempt.handled then return end
    attempt.handled = true
    if U.get("autoActivate", false) then task.defer(function()
        if LP.Character == attempt.character and not _G.FUNHUB_SemiTP_ResetBusy then FUNHUB.activate() end
    end) end
    if U.get("autoRagTech", false) then task.delay(0.2, function()
        if LP.Character == attempt.character and not _G.FUNHUB_SemiTP_ResetBusy then F.selfRagdoll(0.25) end
    end) end
    if not U.get("spamAfter", false) then return end
    local target = attempt.target
    if not target or not target.Parent then U.notify("Semi Spam", "The base owner is unavailable") return end
    local selected = U.get("spam1Cmds", F.SPAM1_DEF)
    if type(selected) ~= "table" or #selected == 0 then U.notify("Semi Spam", "Select Semi commands first") return end
    local commands = table.clone(selected)
    task.spawn(function()
        local deadline = os.clock() + 2.5
        local function valid()
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            return F.AP.alive and FUNHUB_ALIVE() and U.get("spamAfter", false) and target.Parent
                and LP.Character == attempt.character and hum and hum.Health > 0 and not _G.FUNHUB_SemiTP_ResetBusy
        end
        while F.AP.busy and valid() and os.clock() < deadline do task.wait(0.03) end
        if not valid() then return end
        if F.AP.busy then U.notify("Semi Spam", "Admin Panel is busy") return end
        F.spamCmds(commands, target, "Semi")
    end)
end

function F.setGiantPotion(v)
    v = v == true
    HubConfig.giantPotionEnabled = v
    F.setCfg("potionEnabled", v)
    PotionEnabled = v
    if v then U.set("autoRagTech", false) end
    saveHubConfig()
end
function F.migrateSemiSettings(imported)
    if type(imported) == "table" then
        -- An old profile must not inherit the currently selected new mode/speed.
        for _, key in ipairs({ "semiMode", "semiSpeed", "semiInstant", "grappleSemiTP", "grappleSemiSpeed", "grappleSemiPotion" }) do
            AC[key] = imported[key]
        end
    end
    if AC.semiMode ~= "Normal" and AC.semiMode ~= "Grapple" then
        AC.semiMode = AC.grappleSemiTP == true and "Grapple" or "Normal"
        AC.semiInstant = AC.semiInstant == true or AC.grappleSemiTP == true
        if AC.semiMode == "Grapple" and type(AC.grappleSemiPotion) == "boolean" then
            F.setGiantPotion(AC.grappleSemiPotion)
        end
    end
    local speed = tonumber(AC.semiSpeed)
    if not speed then
        speed = AC.semiMode == "Grapple" and (tonumber(AC.grappleSemiSpeed) or 240) or 180
    end
    AC.semiSpeed = speed >= 225 and 240 or speed >= 195 and 210 or 180
    if type(AC.windows) == "table" then
        if AC.windows.sub_grappleSemi or AC.windows.sub_semimore then AC.windows.sub_semi = true end
        AC.windows.sub_grappleSemi, AC.windows.sub_semimore = nil, nil
    end
    if AC.keys.grappleSemiSteal and (not AC.keys.semiSteal or AC.keys.semiSteal == AC.keys.grappleSemiSteal) then
        AC.keys.semiSteal, AC.keys.grappleSemiSteal = AC.keys.grappleSemiSteal, nil
    end
    AC.grappleSemiTP, AC.grappleSemiPotion, AC.grappleSemiSpeed = nil, nil, nil
end
function F.setSemiMode(mode)
    if mode ~= "Normal" and mode ~= "Grapple" then return false end
    if mode == FUNHUB.semiMode() then return true end
    if FUNHUB.debounce or _G.FUNHUB_SemiTP_Busy or _G.FUNHUB_SemiTP_ResetBusy then
        U.notify("Semi TP", "Finish or cancel the current run before switching modes")
        return false
    end
    U.set("semiMode", mode)
    FUNHUB.autoAllow.Reset()
    return true
end
function F.setSemiTP(v)
    v = v == true
    U.set("semiInstant", v)
    FUNHUB.autoAllow.Reset()
    if F.grappleSemi then
        if not v then F.grappleSemi.Cancel("Disabled")
        elseif not F.grappleSemi.Busy then
            F.grappleSemi.Status, F.grappleSemi.Failed = "Ready - ground floor only", false
        end
    end
    if v then pcall(bindStealKey)
    else pcall(function() ContextActionService:UnbindAction(STEAL_ACTION) end) end
end
function F.runSemi()
    if F.grappleSemi and F.grappleSemi.Busy then F.grappleSemi.Cancel() return end
    task.spawn(FUNHUB.execute)
end
function F.semiSync()
    F.migrateSemiSettings()
    FUNHUBKeys.migrate()
    currentStealKey = FUNHUBKeys.decode(HubConfig.stealKeybind)
    KeybindBtn.Text = currentStealKey and U.shortKey(currentStealKey.Name) or "None"
    F.setGiantPotion(F.cfg("potionEnabled") and HubConfig.giantPotionEnabled ~= false)
    F.setSemiTP(U.get("semiInstant", false))
end
-- DatShawn potion-on-grab timing: manual/native holds at 90%, callback grabs before trigger.
do
    local S = { alive = true, enabled = false, requests = {}, nextPotionAt = 0 }
    F.autoPotion = S
    function S.clear()
        table.clear(S.requests) -- invalidates delayed equips as well as timers
    end
    function S.isSteal(prompt)
        return prompt and prompt.Parent and prompt:IsA("ProximityPrompt") and prompt.Enabled
            and tostring(prompt.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") == "steal"
    end
    function S.inRange(record)
        local root = record.char and record.char:FindFirstChild("HumanoidRootPart")
        local parent = record.prompt.Parent
        local position = parent and (parent:IsA("Attachment") and parent.WorldPosition
            or (parent:IsA("BasePart") and parent.Position))
        return root and position and (root.Position - position).Magnitude <= record.range
    end
    function S.valid(record)
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        return S.alive and S.enabled and FUNHUB_ALIVE() and S.requests[record.prompt] == record
            and not record.cancelled and char ~= nil and char == record.char and char.Parent ~= nil and hum and hum.Health > 0
            and not isStealBoostLive() and not FUNHUBFx.backgroundPaused()
            and S.isSteal(record.prompt) and (not record.ctx or (record.ctx.source ~= "Semi TP"
                and not record.ctx.semiSource and FUNHUBHold.valid(record.ctx)))
    end
    function S.use(record)
        if record.running or record.finished or not S.valid(record) or not S.inRange(record) then return end
        if potionState.confirmEffect(record.char) then record.finished = true return end
        if potionState.busy or os.clock() < S.nextPotionAt
            or os.clock() - potionState.lastUse < potionState.timing.cooldown then return end
        if not potionState.find("Giant Potion", record.char) then
            record.finished = true
            potionState.status = "Giant Potion missing from backpack"
            return
        end
        record.running = true
        task.spawn(function()
            local ok, used = pcall(FUNHUBAutoPotion, { autoSteal = true, onGrab = true,
                valid = function() return S.valid(record) and S.inRange(record) end })
            record.running, record.finished = false, true
            if ok and used == true then
                S.nextPotionAt = os.clock() + 5 -- supplied grab bridge throttle
                potionState.confirmEffect(record.char)
            elseif not ok then warn("[FUNHUB potion on grab] " .. tostring(used)) end
        end)
    end
    function S.newRecord(prompt, ctx)
        local duration = ctx and ctx.holdDuration or math.max(0, tonumber(prompt.HoldDuration) or 1.3)
        local record = { prompt = prompt, char = LP.Character, ctx = ctx,
            range = math.min(tonumber(prompt.MaxActivationDistance) or 10, ctx and ctx.range or 10),
            fireAt = os.clock() + duration * 0.9,
            expires = ctx and ctx.windowEnd or (os.clock() + duration + 2),
            running = false, finished = false }
        S.requests[prompt] = record
        return record
    end
    function S.onHold(ctx)
        if not S.enabled or not ctx or not S.isSteal(ctx.prompt) or ctx.semiSource
            or ctx.source == "Semi TP" or FUNHUBFx.backgroundPaused() then return end
        local record = S.newRecord(ctx.prompt, ctx)
        if ctx.native then
            task.delay(math.max(0, record.fireAt - os.clock()), function() S.use(record) end)
        end
    end
    function S.cancelContext(ctx)
        local record = ctx and S.requests[ctx.prompt]
        if record and record.ctx == ctx then S.requests[ctx.prompt] = nil end
    end
    function S.beforeTrigger(ctx)
        if not S.enabled or not ctx or ctx.semiSource or ctx.source == "Semi TP"
            or FUNHUBFx.backgroundPaused() or not S.isSteal(ctx.prompt) then return true end
        local record = S.requests[ctx.prompt]
        if not record or record.ctx ~= ctx then record = S.newRecord(ctx.prompt, ctx) end
        if ctx.commitUntil then record.expires = math.max(record.expires, ctx.commitUntil + 0.05) end
        if not S.valid(record) or not S.inRange(record) then return true end
        record.gateAt = record.gateAt or os.clock()
        S.use(record)
        if record.running then
            if os.clock() - record.gateAt < 0.45 then return false end
            record.cancelled = true -- a late equip must not drink after the grab
        end
        return true -- missing gear/cooldown must never block the grab
    end
    FUNHUBHold.onAutoPotionHold = S.onHold
    FUNHUBHold.onAutoPotionCancel = S.cancelContext
    FUNHUBHold.beforeAutoPotionTrigger = S.beforeTrigger
    function F.autoPotionSync()
        local enabled = U.get("autoPotionOnSteal", false) == true and not FUNHUBFx.backgroundPaused()
        if enabled ~= S.enabled then S.clear() end
        S.enabled = enabled
    end
    U.on(PPS.PromptButtonHoldBegan, function(prompt, who)
        if (who ~= nil and who ~= LP) or not S.isSteal(prompt) then return end
        if S.enabled and not isStealBoostLive() and not FUNHUBFx.backgroundPaused() then
            local ctx = FUNHUBHold.normalContext or FUNHUBHold.publicContext
            local record = S.requests[prompt]
            if not (record and record.ctx and record.ctx == ctx) then
                record = S.newRecord(prompt, nil)
                task.delay(math.max(0, record.fireAt - os.clock()), function() S.use(record) end)
            end
        end
        -- Keep the separate ragdoll option's hold timing.
        if U.get("autoRagTech", false) then
            local char = LP.Character
            task.delay(math.max(0, (tonumber(prompt.HoldDuration) or 1) - 0.1), function()
                if S.alive and U.get("autoRagTech", false) and LP.Character == char
                    and S.isSteal(prompt) and not isStealBoostLive() then F.selfRagdoll(0.25) end
            end)
        end
    end)
    local function endManual(prompt, who)
        if who ~= nil and who ~= LP then return end
        local record = S.requests[prompt]
        if record and (not record.ctx or record.ctx.native) then S.requests[prompt] = nil end
    end
    U.on(PPS.PromptButtonHoldEnded, endManual)
    U.on(PPS.PromptTriggered, endManual)
    U.on(PPS.PromptHidden, function(prompt)
        local record = S.requests[prompt]
        if record and not record.ctx then S.requests[prompt] = nil end
    end)
    U.on(LP.CharacterRemoving, S.clear)
    U.on(LP.CharacterAdded, S.clear)
    U.on(RunService.Heartbeat, function()
        if not S.alive or not FUNHUB_ALIVE() then S.clear() return end
        for prompt, record in pairs(S.requests) do
            if not S.valid(record) or os.clock() > record.expires then S.requests[prompt] = nil end
        end
    end)
    R.cleanup[#R.cleanup + 1] = function()
        S.alive, S.enabled = false, false
        S.clear()
        if FUNHUBHold.onAutoPotionHold == S.onHold then FUNHUBHold.onAutoPotionHold = nil end
        if FUNHUBHold.onAutoPotionCancel == S.cancelContext then FUNHUBHold.onAutoPotionCancel = nil end
        if FUNHUBHold.beforeAutoPotionTrigger == S.beforeTrigger then FUNHUBHold.beforeAutoPotionTrigger = nil end
    end
end

local moreSet = U.sub("More Settings", "more")
F.speedMasterDef = F.cfg("moveSpeedEnabled") or HubConfig.stealBoostAutoOnSteal ~= false
F.speedSync = function()
    local giantSpeed = tonumber(U.get("giantSpeed", F.num("giantSpeedValue", 34.8)))
    if not giantSpeed or giantSpeed ~= giantSpeed or math.abs(giantSpeed) == math.huge then giantSpeed = 34.8 end
    AC.giantSpeed = math.clamp(giantSpeed, 16, 40)
    local master = U.get("speedMaster", F.speedMasterDef)
    local walk = U.get("speedWalk", F.cfg("moveSpeedEnabled"))
    FUNHUBFx.speedOn = master and walk
    HubConfig.moveSpeedEnabled = master and walk
    _G.FUNHUB_SemiTP_SpeedBoost = master and U.get("speedSteal", true)
    HubConfig.stealBoostAutoOnSteal = _G.FUNHUB_SemiTP_SpeedBoost
    FUNHUBFx.potionSpeed = U.get("speedGiant", true) == true
    HubConfig.giantSpeedValue = AC.giantSpeed
    local char = player.Character
    potionState.updateSpeed(char, char and char:FindFirstChildOfClass("Humanoid"))
    currentSpeed = math.clamp(F.num("speedValue", 27), STEAL_SPEED_MIN, STEAL_SPEED_MAX)
    HubConfig.speedValue = currentSpeed
    FUNHUBFx.grav = master and U.get("speedGravity", F.cfg("gravityEnabled"))
    HubConfig.gravityEnabled = FUNHUBFx.grav
    saveHubConfig()
end
R.cleanup[#R.cleanup + 1] = potionState.stop
R.cleanup[#R.cleanup + 1] = function() if FUNHUBFx.motion then FUNHUBFx.motion.stop() end end
U.toggle(moreSet.card, "Walk", acOpt("speedWalk", F.cfg("moveSpeedEnabled"), F.speedSync))
U.slider(moreSet.card, "Walk Speed", 16, 80, 1, function() return F.num("walkSpeedValue", 30) end, function(v) F.setNum("walkSpeedValue", math.max(v, 16)) end)
U.toggle(moreSet.card, "Stealing", acOpt("speedSteal", true, F.speedSync))
U.slider(moreSet.card, "Steal Speed", STEAL_SPEED_MIN, STEAL_SPEED_MAX, 1, function() return F.num("speedValue", 27) end, function(v)
    currentSpeed = v
    F.setNum("speedValue", v)
end)
U.toggle(moreSet.card, "Gravity", acOpt("speedGravity", F.cfg("gravityEnabled"), F.speedSync))
U.slider(moreSet.card, "Gravity", 0, 300, 0.1, function() return F.num("gravityValue", 196.2) end, function(v) F.setNum("gravityValue", v) end)

local speedWin = U.sub("Speed", "speed")
U.toggle(speedWin.card, "Enabled", { chip = "speed", get = function() return U.get("speedMaster", F.speedMasterDef) end,
    set = function(v) U.set("speedMaster", v) F.speedSync() end })
U.toggle(speedWin.card, "More Settings", { get = function() return moreSet.f.Visible end, set = function(v) U.showWindow(moreSet.f, v) end,
    dots = function() U.openSub(moreSet) end })

local carpetWin = U.sub("Carpet Speed", "carpet")
U.toggle(carpetWin.card, "Enabled", { chip = "carpet", get = function() return F.cfg("carpetSpeedEnabled") end,
    set = function(v) F.setCfg("carpetSpeedEnabled", v) FUNHUBFx.carpet = v if F.actionsCarpet then F.actionsCarpet() end end })
U.toggle(carpetWin.card, "Auto Equip", acOpt("carpetEquip", false))
U.slider(carpetWin.card, "Carpet Speed", 16, 500, 1, function() return F.num("carpetSpeedValue", 130) end, function(v) F.setNum("carpetSpeedValue", math.max(v, 16)) end)

local potionWin = U.sub("Potion Speed", "potionSpeed")
U.toggle(potionWin.card, "Enabled", acOpt("speedGiant", true, F.speedSync))
U.slider(potionWin.card, "Carry Speed", 16, 40, 0.1, function() return U.get("giantSpeed", 34.8) end, function(v)
    U.set("giantSpeed", v)
    F.speedSync()
end)
U.toggle(potionWin.card, "Auto Potion on Grab", acOpt("autoPotionOnSteal", false, F.autoPotionSync))



-- Retire the old independent controller while preserving its opt-in choice.
if AC.instantCarpet == nil and AC.instaSemiTP ~= nil then AC.instantCarpet = AC.instaSemiTP == true end
AC.instaSemiTP, AC.instaSemiPotion = nil, nil
AC.keys.instaSemiSteal, AC.keys.cancelInstaSemi = nil, nil
F.migrateSemiSettings()
local semiWin = U.sub("Semi TP", "semi")
U.toggle(semiWin.card, "Enabled", { get = function() return U.get("semiInstant", false) end, set = F.setSemiTP })
do
    local function choices(items, get, set)
        local row = U.row(semiWin.card, IsMobile and 44 or 38)
        local buttons = {}
        for i, item in ipairs(items) do
            local value = item
            local button = U.text("TextButton", row, tostring(value), 13, WB, C.TEXT, Enum.TextXAlignment.Center)
            button.Position = UDim2.new((i - 1) / #items, 2, 0, 0)
            button.Size = UDim2.new(1 / #items, -4, 1, 0)
            U.round(button, 8)
            local stroke = U.stroke(button, 1)
            buttons[#buttons + 1] = { button = button, stroke = stroke, value = value }
            U.on(button.Activated, function()
                if not FUNHUBUI.bindingInput and not FUNHUBKeys.blocked() then set(value) end
            end)
        end
        R.rows[#R.rows + 1] = function()
            if not semiWin.f.Visible then return end
            local selected = get()
            for _, item in ipairs(buttons) do
                local active = item.value == selected
                item.button.BackgroundColor3 = active and C.A1 or C.ELEM
                item.button.BackgroundTransparency = active and 0.12 or 0.6
                item.button.TextColor3 = active and C.WHITE or C.DIM
                item.stroke.Transparency = active and 0.15 or 0.8
            end
        end
    end
    choices({ "Normal", "Grapple" }, FUNHUB.semiMode, F.setSemiMode)
    local label = U.text("TextLabel", semiWin.card, "Speed", 12, WM, C.DIM)
    label.Size, label.LayoutOrder = UDim2.new(1, 0, 0, 18), nxt()
    choices({ 240, 210, 180 }, FUNHUB.semiSpeed, function(v) U.set("semiSpeed", v) end)
end
local function semiBtn(text, fn, key, getText)
    local r = U.row(semiWin.card, 36, C.ELEM)
    r.BackgroundTransparency = 0.5
    U.stroke(r, 1)
    local l = U.text("TextLabel", r, text, 13, WM, C.WHITE, Enum.TextXAlignment.Center)
    l.Size = UDim2.fromScale(1, 1)
    local h = U.hit(r, 2)
    local bindName = key or ("btn_" .. text:gsub("%s+", "_"):lower())
    local function show()
        local caption = getText and getText() or text
        if listening and listening.name == bindName then
            l.Text = caption .. " (...)"
            return
        end
        local k = AC.keys[bindName]
        l.Text = k and (caption .. " (" .. U.shortKey(k) .. ")") or caption
    end
    show()
    h.MouseButton1Click:Connect(function()
        if not FUNHUBUI.bindingInput and not FUNHUBKeys.blocked() then pcall(fn) end
    end)
    binds[bindName] = fn
    h.MouseButton2Click:Connect(function()
        if U.beginBinding(bindName, show) then l.Text = text .. " (...)" end
    end)
    R.rows[#R.rows + 1] = show
    return l, r
end
semiBtn("Activate", function() FUNHUB.activate() end)
semiBtn("Run Semi TP", F.runSemi, "semiSteal", function()
    if F.grappleSemi and F.grappleSemi.Busy then return "Cancel Grapple" end
    return FUNHUB.semiMode() == "Grapple" and "Run Grapple Semi TP" or "Run Semi TP"
end)
do
    local _, row = U.toggle(semiWin.card, "Instant Carpet", {
        get = function() return U.get("instantCarpet", false) end,
        set = function(v) U.set("instantCarpet", v == true) end,
        tip = "Uses Flying Carpet during the normal ground approach and re-equips after potion use. Keeps the same target, route and grab timing." })
    R.rows[#R.rows + 1] = function() row.Visible = FUNHUB.semiMode() == "Normal" end
end
U.stepper(semiWin.card, function() return "Target Slot: " .. tostring(selectedSlot) end, function()
    if F.clearSemiSelection and not F.clearSemiSelection() then return end
    local n = selectedSlot - 1
    if n < 1 then n = 1 end
    updateSlot(n)
end, function()
    if F.clearSemiSelection and not F.clearSemiSelection() then return end
    local n = selectedSlot + 1
    if n > FUNHUB.maxPodium() then n = FUNHUB.maxPodium() end
    updateSlot(n)
end)
U.button(semiWin.card, "Choose Brainrot", function() F.openSemiPicker() end, nil, "grappleChooseBrainrot")

-- Exact-instance selection: duplicate names in different bases stay separate.
do
    local picker = U.sub("Choose Brainrot", "semiPicker")
    F.semiPicker = picker
    local selected, query, lastRefresh = nil, "", 0
    local rows = {}
    local function busy()
        return FUNHUB.debounce or _G.FUNHUB_SemiTP_Busy or F.stealing()
    end
    local function selectionValid(item)
        if not item then return false, "Choose a brainrot first" end
        if not item.plot.Parent or not isEnemyPlot(item.plot) then return false, "Selected owner/base is gone" end
        if F.ownerName(item.plot) ~= item.owner then return false, "Selected base changed owner" end
        if not item.model.Parent or not item.model:IsDescendantOf(item.plot) then return false, "Selected brainrot is gone" end
        if item.model.Name ~= item.name then return false, "Selected brainrot changed" end
        local pods = item.plot:FindFirstChild("AnimalPodiums")
        local pod = pods and pods:FindFirstChild(tostring(item.slot))
        local base = pod and pod:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        if spawn ~= item.spawn then return false, "Selected podium changed" end
        if (item.model:GetPivot().Position - spawn.Position).Magnitude > 14 then return false, "Selected brainrot moved" end
        local _, prompt = podiumParts(pod)
        if not prompt or not prompt.Enabled then return false, "Selected brainrot is not available" end
        return true
    end
    FUNHUBUI.validateSelection = function()
        if not selected then return true end -- preserve the manual-slot mode
        local ok, reason = selectionValid(selected)
        if not ok then return false, reason end
        if targetPlot ~= selected.plot or selectedSlot ~= selected.slot then return false, "Selection changed; choose the brainrot again" end
        return true
    end
    local summary, summaryRow = U.button(picker.card, "Choose a brainrot below", function() end)
    summaryRow.Size = UDim2.new(1, 0, 0, 58)
    summary.TextWrapped = true
    summary.TextSize = 12
    local potionLabel, potionRow = U.button(picker.card, "Potion: Ready", function() end)
    potionLabel.TextSize = 11
    potionLabel.TextWrapped = true
    potionRow.Size = UDim2.new(1, 0, 0, 40)
    local function choose(item)
        if busy() then U.notify("Semi TP", "Wait for the current steal to finish") return end
        local ok, reason = selectionValid(item)
        if not ok then U.notify("Semi TP", reason) return end
        selected = item
        targetPlot = item.plot
        updateSlot(item.slot)
        refreshBaseName()
        -- Manual selection stops any background Autograb hold and pending potion equip.
        F.setAutoGrab(false)
        lastRefresh = 0
        F.refreshSemiPicker(true)
    end
    function F.clearSemiSelection()
        if busy() then return false end
        selected, targetPlot = nil, nil
        refreshBaseName()
        lastRefresh = 0
        return true
    end
    function F.runSelectedSemi()
        if busy() then U.notify("Semi TP", "A steal is already running") return end
        local ok, reason = selectionValid(selected)
        if not ok then U.notify("Semi TP", reason) return end
        targetPlot = selected.plot
        updateSlot(selected.slot)
        F.setSemiTP(true)
        if U.get("semiAlignCam", false) and F.alignCam then F.alignCam() end
        task.spawn(FUNHUB.execute)
    end
    U.button(picker.card, "STEAL SELECTED", F.runSelectedSemi, C.A1)
    U.button(picker.card, "Clear Selection / Manual Slot", function()
        if not F.clearSemiSelection() then U.notify("Semi TP", "Wait for the current steal to finish") end
        F.refreshSemiPicker(true)
    end)
    U.toggle(picker.card, "Semi TP GP", { get = function()
        return F.cfg("potionEnabled") and HubConfig.giantPotionEnabled ~= false
    end, set = F.setGiantPotion })
    U.button(picker.card, "Use Potion Now", function()
        if busy() then U.notify("Potion", "Wait for the current steal to finish") return end
        F.setGiantPotion(true)
        task.spawn(FUNHUBAutoPotion)
    end)
    local search = U.input(picker.card, "Search", "Brainrot / owner", "", nil)
    U.on(search:GetPropertyChangedSignal("Text"), function()
        query = search.Text:lower()
        lastRefresh = 0
    end)
    U.drop(picker.card, "Sort", { "Income", "Distance", "Name", "Owner" }, {
        get = function() return U.get("semiPickerSort", "Income") end,
        set = function(v) U.set("semiPickerSort", v) lastRefresh = 0 end })
    U.button(picker.card, "Refresh Brainrots", function() F.refreshSemiPicker(true) end)
    local list = U.card(picker.body, "SERVER BRAINROTS")
    local empty, emptyRow = U.button(list, "Scanning brainrots...", function() end)
    function F.refreshSemiPicker(force)
        if not picker.f.Visible and not force then return end
        if not force and os.clock() - lastRefresh < 1 then return end
        lastRefresh = os.clock()
        potionLabel.Text = "Potion: " .. potionState.status
        local valid, reason = selectionValid(selected)
        if selected then
            summary.Text = (valid and "Selected: " or "Unavailable: ") .. selected.name .. "\n"
                .. selected.owner .. "  /  slot " .. tostring(selected.slot)
                .. (valid and "" or ("\n" .. reason))
            summary.TextColor3 = valid and C.GOOD or C.WARN
        else
            summary.Text, summary.TextColor3 = "Choose a brainrot below", C.TEXT
        end
        local items, seen = {}, {}
        local _, _, rootPart = F.char()
        for _, item in ipairs(F.brainrots(force)) do
            if item.slot and item.spawn and not seen[item.model] then
                seen[item.model] = true
                local haystack = (item.name .. " " .. item.owner):lower()
                if query == "" or haystack:find(query, 1, true) then
                    item.distance = rootPart and (rootPart.Position - item.spawn.Position).Magnitude or math.huge
                    items[#items + 1] = item
                end
            end
        end
        local sort = U.get("semiPickerSort", "Income")
        table.sort(items, function(a, b)
            if sort == "Distance" and a.distance ~= b.distance then return a.distance < b.distance end
            if sort == "Income" and a.gen ~= b.gen then return a.gen > b.gen end
            if sort == "Name" and a.name ~= b.name then return a.name < b.name end
            if a.owner ~= b.owner then return a.owner < b.owner end
            if a.plot.Name ~= b.plot.Name then return a.plot.Name < b.plot.Name end
            return a.slot < b.slot
        end)
        local wanted = {}
        for index, item in ipairs(items) do
            local key = item.model
            wanted[key] = true
            local row = rows[key]
            if not row then
                row = {}
                local record = row
                row.label, row.frame = U.button(list, "", function() choose(record.item) end)
                row.frame.Size = UDim2.new(1, 0, 0, 80)
                row.label.TextSize = 12
                row.label.TextWrapped = true
                row.label.TextXAlignment = Enum.TextXAlignment.Left
                row.label.Position = UDim2.fromOffset(8, 0)
                row.label.Size = UDim2.new(1, -16, 1, 0)
                if F.thumb then
                    local ok, thumb = pcall(F.thumb, item.model)
                    if ok and thumb then
                        thumb.Position = UDim2.fromOffset(6, 12)
                        thumb.Parent = row.frame
                        row.label.Position = UDim2.fromOffset(70, 0)
                        row.label.Size = UDim2.new(1, -78, 1, 0)
                    end
                end
                rows[key] = row
            end
            row.item = item
            row.frame.LayoutOrder = index
            local picked = selected and selected.model == key and selected.plot == item.plot and selected.slot == item.slot
            local ready = selectionValid(item)
            row.label.Text = (picked and "[SELECTED] " or "") .. item.name .. "\n"
                .. item.owner .. "  /  slot " .. tostring(item.slot) .. "\n"
                .. item.genText .. "  |  " .. (item.distance == math.huge and "?" or tostring(math.floor(item.distance))) .. " studs"
                .. (ready and "" or "  | unavailable")
            row.label.TextColor3 = picked and C.GOOD or (ready and C.TEXT or C.DIM)
        end
        for key, row in pairs(rows) do
            if not wanted[key] then row.frame:Destroy() rows[key] = nil end
        end
        emptyRow.Visible = #items == 0
        empty.Text = query ~= "" and "No matching brainrots" or "No enemy brainrots found; try Refresh"
    end
    function F.openSemiPicker()
        U.showWindow(picker.f, true)
        F.refreshSemiPicker(true)
    end
    R.cleanup[#R.cleanup + 1] = function() FUNHUBUI.validateSelection = nil end
end

-- Grapple Semi TP: optional grapple flight, carpet landing and selected-target grab.
do
local LocalPlayer, Environment = LP, ENV
local Config = {
    HookName = "",
    HookNames = {"Grapple Hook", "Grappling Hook", "GrapplingHook", "GrappleHook", "Grapple"},
    CarpetNames = {"Flying Carpet", "Magic Carpet", "Rainbow Carpet"},
    PotionNames = {"Giant Potion", "Giant", "Grow Potion", "Super Grow", "Potion"},
    GroundMaxY = 10,
    CorridorY = 3.1,
    CorridorZ = -35.9,
    CorridorReach = 107,
    MaxTriggerDistance = 30,
    ApproachHoldTime = 0.8,
    GrabDuration = 1.3,
    GrabExpiry = 2.5,
    PotionPause = 0.25,
    PotionEquipDelay = 0.1,
    PotionSettle = 0.3,
    PotionCooldown = 2,
    UseSourceFlags = true,
    EquipTimeout = 0.6,
    ToolReadyTimeout = 0.8,
    ActivationTimeout = 0.75,
    ManualActivationTimeout = 6,
    MoveTimeout = 8,
    PulseInterval = 0,
    PullSuppressionWindow = 0.8,
    FloatStep = 1 / 120,
    FloatMaxSteps = 4,
    FloatResponse = 25,
    FloatVerticalSpeed = 60,
    WaypointTolerance = 2,
    HeightTolerance = 2,
    StuckTimeout = 1,
    SettleTime = 0.16,
    ArrivalTolerance = 10,
    ClickCooldown = 0.6,
    RestorePreviousTool = true,
}

local Runtime = {Alive = true, Busy = false, MoveId = 0, GrabId = 0, NextRun = 0}
F.grappleSemi, FUNHUB.grappleSemi = Runtime, Runtime
local statusLabel
local function setStatus(message, failed)
    -- Movement and tool callbacks only publish Lua data, never GUI instances.
    Runtime.Status, Runtime.Failed = tostring(message), failed == true
end
function Runtime.RenderStatus()
    if not Runtime.Alive or not FUNHUB_ALIVE() then return end
    local message, failed = Runtime.Status, Runtime.Failed
    if message == nil or (Runtime.RenderedStatus == message and Runtime.RenderedFailed == failed) then return end
    -- Event threads may not have access to the GUI host. Retry from the hub's
    -- existing refresh loop; even Parent must stay inside the protected call.
    local ok, painted = pcall(function()
        if not statusLabel or not statusLabel.Parent then return false end
        statusLabel.Text = message
        statusLabel.TextColor3 = failed and C.WARN or C.DIM
        return true
    end)
    if ok and painted then
        Runtime.RenderedStatus, Runtime.RenderedFailed = message, failed
    end
end
function Runtime.CancelGrab(moveId)
    if moveId and Runtime.GrabMoveId ~= moveId then return end
    for _, thread in ipairs(Runtime.GrabReleaseThreads or {}) do
        if thread ~= coroutine.running() and type(task.cancel) == "function" then
            pcall(task.cancel, thread)
        end
    end
    Runtime.GrabReleaseThreads = {}
    Runtime.GrabId = Runtime.GrabId + 1
    Runtime.GrabMoveId = nil
    local context = Runtime.GrabContext
    Runtime.GrabContext = nil
    if context then
        local progress = context.Progress
        if progress then
            if progress.lastTrigger then
                FUNHUBHold.progress.pendingSemi = {ctx = progress, expires = os.clock() + 4}
            end
            FUNHUBHold.cancel(progress)
        end
        for _, thread in ipairs(context.GrabThreads or {}) do
            if not context.Succeeded and thread ~= coroutine.running() and type(task.cancel) == "function" then
                pcall(task.cancel, thread)
            end
        end
        context.GrabThreads = {}
        if context.GrabCallbacks and not context.GrabReleased then
            context.GrabReleased = true
            for _, callback in ipairs(context.GrabRelease or {}) do
                local thread = task.spawn(function() pcall(callback, LocalPlayer) end)
                Runtime.GrabReleaseThreads[#Runtime.GrabReleaseThreads + 1] = thread
            end
        end
        if context.GrabProgress then
            pcall(function() context.GrabProgress:Disconnect() end)
            context.GrabProgress = nil
        end
        if context.OriginalPrompt then
            pcall(function()
                context.Target.prompt.RequiresLineOfSight = context.OriginalPrompt.LOS
                context.Target.prompt.MaxActivationDistance = context.OriginalPrompt.Range
            end)
        end
    end
    if Runtime.HeldPrompt then
        pcall(function() Runtime.HeldPrompt:InputHoldEnd() end)
        Runtime.HeldPrompt = nil
    end
end
local function getHRP()
    local character = LocalPlayer.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function findTool(names, override)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local containers = {}
    if character then containers[#containers + 1] = character end
    if backpack then containers[#containers + 1] = backpack end
    local wanted = {}
    if override and override ~= "" then
        wanted[override:lower():gsub("[^%w]", "")] = true
    else
        for _, name in ipairs(names) do
            wanted[name:lower():gsub("[^%w]", "")] = true
        end
    end
    for _, container in ipairs(containers) do
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and wanted[item.Name:lower():gsub("[^%w]", "")] then
                return item
            end
        end
    end
end
local function isStealPrompt(prompt, allowDisabled)
    return prompt and prompt.Parent and prompt:IsA("ProximityPrompt") and (allowDisabled or prompt.Enabled)
        and tostring(prompt.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") == "steal"
end
local RowRoutes = {
    {z = -14.5, inside = Vector3.new(12.89, 4.88, -17.06), green = Vector3.new(30.63, 2.98, -32.97)},
    {z = -7.0, inside = Vector3.new(11.95, 5.13, -9.17), green = Vector3.new(22.58, 2.98, -35.87)},
    {z = 0.5, inside = Vector3.new(14.39, 4.88, -2.44), green = Vector3.new(21.60, 2.98, -28.10)},
    {z = 8.0, inside = Vector3.new(14.62, 4.93, 5.65), green = Vector3.new(21.71, 5.08, -20.68)},
    {z = 15.5, inside = Vector3.new(11.60, 4.72, 13.31), green = Vector3.new(20.40, 4.92, -11.40)},
}

local function rowFor(localZ)
    local best, bestDistance = RowRoutes[1], math.huge
    for _, row in ipairs(RowRoutes) do
        local distance = math.abs(row.z - localZ)
        if distance < bestDistance then best, bestDistance = row, distance end
    end
    return best
end

local function clampToPodium(from, to, podiumPosition)
    local function flatDistance(point)
        return Vector3.new(point.X - podiumPosition.X, 0, point.Z - podiumPosition.Z).Magnitude
    end
    if flatDistance(to) <= Config.MaxTriggerDistance then return to end
    local best = from
    for index = 1, 40 do
        local point = from:Lerp(to, index / 40)
        if flatDistance(point) > Config.MaxTriggerDistance then break end
        best = point
    end
    return best
end

local function buildRoute(target, root)
    local cf = target.rootCF
    local podLocal = cf:PointToObjectSpace(target.spawn.Position)
    if podLocal.Y > Config.GroundMaxY then
        return nil, "Upper-floor path needs Quantum Cloner"
    end
    local side = podLocal.X >= 0 and 1 or -1
    local row = rowFor(podLocal.Z)
    local function at(point) return cf * Vector3.new(point.X * side, point.Y, point.Z) end
    local inside = at(row.inside)
    local here = cf:PointToObjectSpace(root.Position)
    return {
        cf * Vector3.new(math.clamp(here.X, -Config.CorridorReach, Config.CorridorReach),
            Config.CorridorY, Config.CorridorZ),
        cf * Vector3.new(0, Config.CorridorY, Config.CorridorZ),
        inside,
        clampToPodium(inside, at(row.green), target.spawn.Position),
    }
end

local function canDirectTp(root, targetPosition)
    local origin = root.Position
    local ignored = {LocalPlayer.Character}
    for _ = 1, 12 do
        local direction = targetPosition - origin
        if direction.Magnitude <= 0.05 then return true end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = ignored
        params.IgnoreWater = true
        local result = workspace:Raycast(origin, direction, params)
        if not result or not result.Instance then return true end
        if result.Instance:IsA("BasePart") and not result.Instance.CanCollide then
            ignored[#ignored + 1] = result.Instance
            origin = result.Position + direction.Unit * 0.1
        else
            return (result.Position - targetPosition).Magnitude <= 3
        end
    end
    return false
end
local function requireLive(context)
    if not Runtime.Alive or not FUNHUB_ALIVE() or context.Cleaned or Runtime.MoveId ~= context.Id then
        error("Cancelled", 0)
    end
    if LocalPlayer.Character ~= context.Character or not context.Root.Parent
        or not context.Humanoid.Parent or context.Humanoid.Health <= 0 then
        error("Character reset - try again", 0)
    end
    if context.Pause and not FUNHUBFx.semiPauses[context.Pause] then error("Cancelled", 0) end
    if context.Target and not context.GrabFinishing and not context.GrabTriggered then
        if not context.Target.plot.Parent or not isEnemyPlot(context.Target.plot)
            or plotOwnerName(context.Target.plot) ~= context.TargetOwner then
            error("Target base changed", 0)
        end
        if FUNHUBUI.validateSelection then
            local valid, reason = FUNHUBUI.validateSelection()
            if not valid then error(reason or "Selected brainrot changed", 0) end
        end
    end
    if context.Root.Anchored then error("Character is anchored", 0) end
    if os.clock() > context.Deadline then error("Flight timed out - try again", 0) end
    if _G.FUNHUB_SemiTP_ResetBusy then error("Character reset is running", 0) end
    if context.Target and not context.GrabFinishing and not context.GrabTriggered then
        if not context.Target.spawn.Parent or not isStealPrompt(context.Target.prompt, true) then
            error("Target changed or is no longer grabbable", 0)
        end
    end
end

local function waitFrames(context, count)
    local deltaTime = 1 / 60
    for _ = 1, count do
        requireLive(context)
        deltaTime = RunService.Heartbeat:Wait()
        requireLive(context)
    end
    return tonumber(deltaTime) or 1 / 60
end

local function waitSeconds(context, duration)
    local untilTime = os.clock() + duration
    repeat waitFrames(context, 1) until os.clock() >= untilTime
end

local function equipTool(context, tool)
    requireLive(context)
    if not tool or not tool.Parent then error("Tool is no longer available", 0) end
    if tool.RequiresHandle and not tool:FindFirstChild("Handle") then
        error("Tool handle is not loaded", 0)
    end
    if tool.Parent ~= context.Character then
        context.Humanoid:EquipTool(tool)
        local deadline = math.min(context.Deadline, os.clock() + Config.EquipTimeout)
        while tool.Parent ~= context.Character and os.clock() < deadline do
            waitFrames(context, 1)
        end
        if tool.Parent ~= context.Character then error("Could not equip " .. tool.Name, 0) end
        waitFrames(context, 1)
    end
    context.LastEquipped = tool
end

local GrappleFlight = {}

function GrappleFlight.IsRunning(context)
    return Runtime.Alive and FUNHUB_ALIVE() and context.FlightActive and not context.Cleaned
        and Runtime.MoveId == context.Id and LocalPlayer.Character == context.Character
        and context.Humanoid.Health > 0 and context.Tool.Parent == context.Character
end

function GrappleFlight.GetCallerBridge()
    local bridge = Environment.__FUNHUBGrappleCallerBridge
    if type(bridge) == "table" and bridge.Installed then return bridge end
    bridge = {Installed = false, Threads = setmetatable({}, {__mode = "k"})}
    if type(hookfunction) == "function" and type(checkcaller) == "function"
        and type(newcclosure) == "function" then
        local original
        local ok, result = pcall(function()
            return hookfunction(checkcaller, newcclosure(function()
                local owner = bridge.Threads[coroutine.running()]
                if owner and owner.FlightActive and not owner.Cleaned then return false end
                return original()
            end))
        end)
        if ok and type(result) == "function" then
            original = result
            bridge.Installed = true
        end
    end
    Environment.__FUNHUBGrappleCallerBridge = bridge
    return bridge
end

function GrappleFlight.QuietEffect(context, object)
    if object:IsA("Beam") then
        if context.BeamStates[object] then return end
        context.BeamStates[object] = {
            Enabled = object.Enabled, Attachment0 = object.Attachment0, Attachment1 = object.Attachment1,
        }
        object.Enabled = false
        object.Attachment0 = nil
        local connection = object:GetPropertyChangedSignal("Enabled"):Connect(function()
            if GrappleFlight.IsRunning(context) and object.Enabled then object.Enabled = false end
        end)
        context.FlightConnections[#context.FlightConnections + 1] = connection
    elseif object:IsA("Sound") and context.SoundStates[object] == nil then
        context.SoundStates[object] = object.Volume
        object.Volume = 0
    end
end

function GrappleFlight.IsPullMover(object)
    return object:IsA("BodyMover") or object:IsA("AlignPosition")
        or object:IsA("AlignOrientation") or object:IsA("LinearVelocity")
        or object:IsA("AngularVelocity") or object:IsA("VectorForce")
        or object:IsA("LineForce") or object:IsA("Torque")
        or object:IsA("RopeConstraint") or object:IsA("SpringConstraint")
end

function GrappleFlight.MarkActivation(context)
    if not GrappleFlight.IsRunning(context) then return end
    context.ActivationSeen = true
    context.ActivationCount = (context.ActivationCount or 0) + 1
    context.SuppressUntil = os.clock() + Config.PullSuppressionWindow
end

function GrappleFlight.CancelPulse(context)
    if context.CallerBridge then
        for thread, owner in pairs(context.CallerBridge.Threads) do
            if owner == context then context.CallerBridge.Threads[thread] = nil end
        end
    end
    if context.PulseThread and type(task.cancel) == "function"
        and context.PulseThread ~= coroutine.running() then
        pcall(task.cancel, context.PulseThread)
    end
    context.PulseThread = nil
    context.Pulsing = false
    context.AwaitingNativeEvent = false
end

function GrappleFlight.Pulse(context)
    if not GrappleFlight.IsRunning(context) or context.Pulsing or context.WaitingForInput then return end
    local tool = context.Tool
    if tool:GetAttribute("CooldownTime") ~= nil or not tool.Enabled then return end
    local now = os.clock()
    if now < context.NextPulse then return end
    context.NextPulse = now + Config.PulseInterval
    context.SuppressUntil = now + Config.PullSuppressionWindow
    context.Pulsing = true
    context.Activated = true
    context.ControlledMotion = true
    context.PulseThread = task.spawn(function()
        local bridge = context.CallerBridge
        local thread = coroutine.running()
        if bridge and bridge.Installed then bridge.Threads[thread] = context end
        local ok, failure = pcall(function()
            if not GrappleFlight.IsRunning(context) then return end
            context.AwaitingNativeEvent = true
            pcall(function() tool:Deactivate() end)
            local nativeOK, nativeError = pcall(function() tool:Activate() end)
            if not nativeOK then context.LastActivationError = tostring(nativeError) end
            context.AwaitingNativeEvent = false
            if not GrappleFlight.IsRunning(context) then return end
            if tool:GetAttribute("CooldownTime") ~= nil then return end
            if type(firesignal) == "function" then
                pcall(firesignal, tool.Activated)
            end
            if not GrappleFlight.IsRunning(context) or tool:GetAttribute("CooldownTime") ~= nil then return end
            if type(getconnections) == "function" then
                local got, connections = pcall(getconnections, tool.Activated)
                if got and type(connections) == "table" then
                    for _, connection in ipairs(connections) do
                        if not GrappleFlight.IsRunning(context)
                            or tool:GetAttribute("CooldownTime") ~= nil then break end
                        local readable, callback, enabled = pcall(function()
                            return connection.Function, connection.Enabled
                        end)
                        if not readable or enabled ~= false then
                            local called = false
                            if readable and type(callback) == "function"
                                and callback ~= context.ActivatedObserver then
                                called = pcall(callback)
                            end
                            if not called and callback ~= context.ActivatedObserver then
                                pcall(function()
                                    if type(connection.Fire) == "function" then connection:Fire() end
                                end)
                            end
                        end
                    end
                end
            end
            if not GrappleFlight.IsRunning(context) then return end
            if tool:GetAttribute("CooldownTime") ~= nil then GrappleFlight.MarkActivation(context) end
        end)
        if bridge then bridge.Threads[thread] = nil end
        context.AwaitingNativeEvent = false
        context.Pulsing = false
        if not ok then context.PulseError = tostring(failure) end
    end)
end

function GrappleFlight.Start(context)
    context.FlightConnections = {}
    context.BeamStates = {}
    context.SoundStates = {}
    context.PullMovers = {}
    context.FlightActive = true
    context.NextPulse = 0
    context.SuppressUntil = 0
    context.CallerBridge = GrappleFlight.GetCallerBridge()
    context.ActivatedObserver = function()
        if not GrappleFlight.IsRunning(context) then return end
        if context.AwaitingNativeEvent or context.WaitingForInput then
            GrappleFlight.MarkActivation(context)
        end
    end
    context.FlightConnections[#context.FlightConnections + 1] =
        context.Tool.Activated:Connect(context.ActivatedObserver)
    context.FlightConnections[#context.FlightConnections + 1] =
        context.Tool:GetPropertyChangedSignal("Enabled"):Connect(function()
            if GrappleFlight.IsRunning(context) and not context.Tool.Enabled then
                GrappleFlight.MarkActivation(context)
            end
        end)
    context.FlightConnections[#context.FlightConnections + 1] =
        context.Character.DescendantAdded:Connect(function(object)
            if not GrappleFlight.IsRunning(context) then return end
            if object:IsDescendantOf(context.Tool) then
                pcall(GrappleFlight.QuietEffect, context, object)
            end
            if (os.clock() <= context.SuppressUntil or context.WaitingForInput)
                and GrappleFlight.IsPullMover(object) then
                GrappleFlight.MarkActivation(context)
                context.PullMovers[object] = true
                task.defer(function()
                    if context.PullMovers[object] and object.Parent
                        and object:IsDescendantOf(context.Character) then
                        pcall(function() object:Destroy() end)
                    end
                    context.PullMovers[object] = nil
                end)
            end
        end)
    for _, object in ipairs(context.Tool:GetDescendants()) do
        GrappleFlight.QuietEffect(context, object)
    end
    context.FlightConnections[#context.FlightConnections + 1] =
        context.Tool:GetAttributeChangedSignal("CooldownTime"):Connect(function()
            if not GrappleFlight.IsRunning(context) then return end
            if context.Tool:GetAttribute("CooldownTime") ~= nil then
                GrappleFlight.MarkActivation(context)
            else
                context.NextPulse = 0
                task.defer(GrappleFlight.Pulse, context)
            end
        end)
    GrappleFlight.Pulse(context)
end

function GrappleFlight.Stop(context)
    context.FlightActive = false
    context.WaitingForInput = false
    for _, connection in ipairs(context.FlightConnections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    context.FlightConnections = {}
    GrappleFlight.CancelPulse(context)
    if context.Activated then pcall(function() context.Tool:Deactivate() end) end
    context.Activated = false
    for object in pairs(context.PullMovers or {}) do
        if object.Parent and object:IsDescendantOf(context.Character) then
            pcall(function() object:Destroy() end)
        end
    end
    context.PullMovers = {}
    for object, state in pairs(context.BeamStates or {}) do
        pcall(function()
            object.Attachment0 = state.Attachment0
            object.Attachment1 = state.Attachment1
            object.Enabled = state.Enabled
        end)
    end
    for object, volume in pairs(context.SoundStates or {}) do
        pcall(function() object.Volume = volume end)
    end
    context.BeamStates, context.SoundStates = {}, {}
end
local function cleanupMove(context, restore)
    if not context or context.Cleaned then return end
    context.Cleaned = true
    if context.Guard then context.Guard:Disconnect() context.Guard = nil end
    if context.Thread and context.Thread ~= coroutine.running() and type(task.cancel) == "function" then
        pcall(task.cancel, context.Thread)
    end
    context.Thread = nil
    Runtime.CancelGrab(context.Id)
    GrappleFlight.Stop(context)
    Runtime.SetInputLock(context, false)
    if context.ActivePotion then
        pcall(function() context.ActivePotion:Deactivate() end)
        context.ActivePotion = nil
    end
    if context.Moving or context.ControlledMotion then
        pcall(function()
            if context.Root.Parent then
                context.Root.AssemblyLinearVelocity = Vector3.zero
                context.Root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
    if context.Moving then pcall(function() context.Humanoid.AutoRotate = context.AutoRotate end) end
    if restore and not context.Succeeded and Config.RestorePreviousTool
        and not _G.FUNHUB_SemiTP_ResetBusy and LocalPlayer.Character == context.Character
        and context.Humanoid.Parent and context.Humanoid.Health > 0 then
        pcall(function()
            local equipped = context.Character:FindFirstChildOfClass("Tool")
            if not equipped or equipped == context.Tool or equipped == context.LastEquipped then
                local previous, backpack = context.PreviousTool, LocalPlayer:FindFirstChild("Backpack")
                if previous and (previous.Parent == backpack or previous.Parent == context.Character) then
                    context.Humanoid:EquipTool(previous)
                elseif equipped == context.Tool or equipped == context.LastEquipped then
                    context.Humanoid:UnequipTools()
                end
            end
        end)
    end
    if context.OwnsPotion then potionState.busy = false context.OwnsPotion = false end
    if Runtime.ActiveMove == context then
        Runtime.ActiveMove = nil
        if context.OwnsSourcePause then
            _G.FUNHUB_SemiTP_Busy = context.PreviousSourceBusy
            FUNHUB.debounce = context.PreviousDebounce
            context.OwnsSourcePause = false
        end
    end
    if context.Pause then
        if context.Progress and context.Progress.lastTrigger and not _G.FUNHUB_SemiTP_ResetBusy then
            FUNHUB.releaseSemiPause(context.Pause)
        else
            FUNHUB.endSemiPause(context.Pause)
        end
        context.Pause = nil
    end
end

function Runtime.Cancel(message, restore)
    Runtime.MoveId = Runtime.MoveId + 1
    cleanupMove(Runtime.ActiveMove, restore ~= false)
    Runtime.Busy = false
    Runtime.NextRun = os.clock() + Config.ClickCooldown
    setStatus(message or "Cancelled")
end

function Runtime.Shutdown()
    if not Runtime.Alive then return end
    Runtime.Alive = false
    Runtime.Cancel("Stopped", false)
    for _, thread in ipairs(Runtime.GrabReleaseThreads or {}) do
        if thread ~= coroutine.running() and type(task.cancel) == "function" then pcall(task.cancel, thread) end
    end
    Runtime.GrabReleaseThreads = {}
    if FUNHUB.grappleSemi == Runtime then FUNHUB.grappleSemi = nil end
end
local function flyTo(context, destination)
    local bestDistance = (destination - context.Root.Position).Magnitude
    local progressedAt = os.clock()
    local accumulator = 0
    while true do
        requireLive(context)
        if context.Tool.Parent ~= context.Character then error("Grapple Hook unequipped", 0) end
        if context.PulseError then error("Grapple activation failed", 0) end
        GrappleFlight.Pulse(context)
        local offset = destination - context.Root.Position
        local horizontal = Vector3.new(offset.X, 0, offset.Z)
        if horizontal.Magnitude <= Config.WaypointTolerance
            and math.abs(offset.Y) <= Config.HeightTolerance then return end
        local distance = offset.Magnitude
        if distance < bestDistance - 0.25 then
            bestDistance = distance
            progressedAt = os.clock()
        elseif os.clock() - progressedAt >= Config.StuckTimeout then
            error("Flight blocked or corrected - retry", 0)
        end
        local deltaTime = math.clamp(context.LastDelta or 1 / 60, 1 / 240, 0.1)
        local speed = math.min(context.Speed, horizontal.Magnitude * 0.7 / deltaTime)
        local flatVelocity = Vector3.zero
        if horizontal.Magnitude > 0.01 then flatVelocity = horizontal.Unit * speed end
        local desiredY = math.clamp(offset.Y * 12, -Config.FloatVerticalSpeed, Config.FloatVerticalSpeed)
        accumulator = accumulator + deltaTime
        local steps = math.floor(accumulator / Config.FloatStep)
        if steps > Config.FloatMaxSteps then
            steps, accumulator = Config.FloatMaxSteps, 0
        else
            accumulator = accumulator - steps * Config.FloatStep
        end
        local velocityY = context.Root.AssemblyLinearVelocity.Y
        local blend = 1 - math.exp(-Config.FloatResponse * Config.FloatStep)
        for _ = 1, steps do velocityY = velocityY + (desiredY - velocityY) * blend end
        velocityY = velocityY + workspace.Gravity * deltaTime
        context.Root.AssemblyLinearVelocity = Vector3.new(flatVelocity.X, velocityY, flatVelocity.Z)
        context.Root.AssemblyAngularVelocity = Vector3.zero
        context.LastDelta = waitFrames(context, 1)
    end
end
function Runtime.SetInputLock(context, on)
    local function current()
        return Runtime.Alive and FUNHUB_ALIVE() and not context.Cleaned and Runtime.MoveId == context.Id
            and LocalPlayer.Character == context.Character
    end
    if on then
        if context.InputLocked or not current() then return end
        context.InputLocked = true
        context.PreviousInputLock = _G.FUNHUB_SemiTP_InputLock
        _G.FUNHUB_SemiTP_InputLock = true
        pcall(function()
            local actions = game:GetService("ContextActionService")
            context.InputService = actions
            context.InputAction = "FUNHUB_GrappleSemiTP_InputLock_" .. context.Id
            local keys = {}
            for _, name in ipairs({"W", "A", "S", "D", "Up", "Down", "Left", "Right", "Space", "LeftShift",
                "Backspace", "Q", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Zero",
                "ButtonA", "ButtonB", "ButtonX", "ButtonY", "ButtonL1", "ButtonR1", "ButtonR2", "Thumbstick1"}) do
                keys[#keys + 1] = Enum.KeyCode[name]
            end
            actions:BindActionAtPriority(context.InputAction, function()
                return context.Cleaned and Enum.ContextActionResult.Pass or Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value + 2000, table.unpack(keys))
        end)
        if not current() or not context.InputLocked then return end
        local thread = task.spawn(function()
            pcall(function()
                if not current() or not context.InputLocked then return end
                local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
                local module = scripts and scripts:FindFirstChild("PlayerModule")
                if module then
                    local playerModule = require(module)
                    if not current() or not context.InputLocked then return end
                    local controls = playerModule:GetControls()
                    if not current() or not context.InputLocked then return end
                    context.Controls = controls
                    context.RestoreControls = controls.controlsEnabled ~= false
                    controls:Disable()
                end
            end)
            if context.InputThread == coroutine.running() then context.InputThread = nil end
        end)
        if coroutine.status(thread) ~= "dead" then context.InputThread = thread end
    elseif context.InputLocked then
        context.InputLocked = false
        _G.FUNHUB_SemiTP_InputLock = context.PreviousInputLock
        local thread = context.InputThread
        context.InputThread = nil
        if thread and thread ~= coroutine.running() and type(task.cancel) == "function" then
            pcall(task.cancel, thread)
        end
        if context.InputService and context.InputAction then
            pcall(function() context.InputService:UnbindAction(context.InputAction) end)
        end
        if context.Controls and context.RestoreControls then pcall(function() context.Controls:Enable() end) end
        context.Controls = nil
    end
end
local function performGrapple(context)
    requireLive(context)
    local hook = context.Tool
    if hook.RequiresHandle and not hook:FindFirstChild("Handle") then
        error("Grapple Hook handle is not loaded", 0)
    end
    if not hook.Enabled or hook:GetAttribute("CooldownTime") ~= nil then
        error("Grapple Hook is on cooldown", 0)
    end
    setFFlags()
    requireLive(context)
    Runtime.SetInputLock(context, true)
    Runtime.StartGrab(context)
    setStatus("Starting grapple fly")
    equipTool(context, hook)
    local readyUntil = math.min(context.Deadline, os.clock() + Config.ToolReadyTimeout)
    while (not hook.Enabled or hook:GetAttribute("CooldownTime") ~= nil) and os.clock() < readyUntil do
        waitFrames(context, 1)
    end
    if not hook.Enabled or hook:GetAttribute("CooldownTime") ~= nil then
        error("Grapple Hook is on cooldown", 0)
    end
    GrappleFlight.Start(context)
    local activationUntil = math.min(context.Deadline, os.clock() + Config.ActivationTimeout)
    while not context.ActivationSeen and os.clock() < activationUntil do
        if context.PulseError then error("Grapple activation failed", 0) end
        GrappleFlight.Pulse(context)
        waitFrames(context, 1)
    end
    if not context.ActivationSeen then
        GrappleFlight.CancelPulse(context)
        context.WaitingForInput = true
        local manualUntil = os.clock() + Config.ManualActivationTimeout
        context.Deadline = math.max(context.Deadline, manualUntil + 0.5)
        setStatus("Click / tap the world once to fire hook")
        while not context.ActivationSeen and os.clock() < manualUntil do
            if hook.Parent ~= context.Character then error("Keep the Grapple Hook equipped", 0) end
            waitFrames(context, 1)
        end
        context.WaitingForInput = false
        if not context.ActivationSeen then
            if context.LastActivationError then
                warn("[FUNHUB Grapple Semi TP] Auto fire: " .. context.LastActivationError)
            end
            error("Hook did not fire - retry and click the world", 0)
        end
    end
    context.Deadline = os.clock() + Config.MoveTimeout
    context.AutoRotate = context.Humanoid.AutoRotate
    context.Moving = true
    context.Humanoid.AutoRotate = false
    context.LastDelta = 1 / 60
    local approachCount = #context.Route - 1
    local startIndex = 1
    for index = approachCount, 1, -1 do
        if canDirectTp(context.Root, context.Route[index]) then startIndex = index break end
    end
    context.RouteStart = startIndex
    for index = startIndex, approachCount do
        setStatus("Grapple slot " .. context.Target.slot .. " - " .. index .. "/" .. approachCount)
        flyTo(context, context.Route[index])
    end
    GrappleFlight.Stop(context)
    context.Root.AssemblyLinearVelocity = Vector3.zero
    context.Root.AssemblyAngularVelocity = Vector3.zero
    setStatus("Switching to Flying Carpet")
    equipTool(context, context.Carpet)
    if os.clock() - context.HoldBeganAt < Config.ApproachHoldTime then
        setStatus("At brainrot - preparing grab")
        while os.clock() - context.HoldBeganAt < Config.ApproachHoldTime do
            waitFrames(context, 1)
        end
    end
    waitSeconds(context, Config.PotionPause)
    local shield = context.Shield
    if shield and shield.Parent and shield.Enabled and shield:GetAttribute("CooldownTime") == nil then
        setStatus("Using Grief Shield")
        equipTool(context, shield)
        waitSeconds(context, Config.PotionEquipDelay)
        context.ActivePotion = shield
        shield:Activate()
        waitSeconds(context, 0.03)
        context.ActivePotion = nil
    end
    if context.UsePotion and not potionState.isGiant(context.Character) then
        local potion = context.Potion
        if not potion or not potion.Parent then error("Giant Potion is no longer available", 0) end
        if not potion.Enabled or os.clock() - potionState.lastUse < Config.PotionCooldown then
            error("Giant Potion is on cooldown", 0)
        end
        setStatus("Using Giant Potion")
        equipTool(context, potion)
        waitSeconds(context, Config.PotionEquipDelay)
        context.ActivePotion = potion
        potionState.lastUse = os.clock()
        potionState.observe(context.Character)
        potion:Activate()
        waitSeconds(context, Config.PotionSettle)
        context.ActivePotion = nil
        potionState.confirmEffect(context.Character)
    end
    setStatus("Carpet final TP")
    equipTool(context, context.Carpet)
    requireLive(context)
    local final = context.Route[#context.Route]
    context.Root.AssemblyLinearVelocity = Vector3.zero
    context.Root.AssemblyAngularVelocity = Vector3.zero
    context.Root.CFrame = CFrame.new(final)
    Runtime.FinishGrab(context)
    local settleUntil = os.clock() + Config.SettleTime
    repeat waitFrames(context, 1) until os.clock() >= settleUntil
    if (context.Root.Position - final).Magnitude > Config.ArrivalTolerance then
        error("Landing corrected - retry at a lower speed", 0)
    end
    return os.clock() - context.StartedAt
end
function Runtime.Run()
    if not Runtime.Alive or not FUNHUB_ALIVE() then return end
    if Runtime.Busy then Runtime.Cancel() return end
    if not U.get("semiInstant", false) or FUNHUB.semiMode() ~= "Grapple" then
        setStatus("Enable Semi TP and select Grapple", true) return
    end
    if os.clock() < Runtime.NextRun then return end
    if FUNHUB.debounce or _G.FUNHUB_SemiTP_Busy or _G.FUNHUB_SemiTP_ResetBusy then
        setStatus("Wait for the current Semi TP or reset", true) return
    end
    if isStealBoostLive() then setStatus("Already carrying a brainrot", true) return end
    if potionState.busy then setStatus("Wait for the current potion to finish", true) return end
    if FUNHUBUI.validateSelection then
        local valid, reason = FUNHUBUI.validateSelection()
        if not valid then setStatus(reason or "Choose the brainrot again", true) return end
    end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = getHRP()
    if not humanoid or humanoid.Health <= 0 or not root or root.Anchored then
        setStatus("Wait for your character to load", true) return
    end
    local target = findPodiumTarget(selectedSlot, root)
    if not target or not isStealPrompt(target.prompt) then
        setStatus("No ready enemy brainrot in slot " .. tostring(selectedSlot), true) return
    end
    target.slot = selectedSlot
    local route, routeError = buildRoute(target, root)
    if not route then setStatus("Grapple Semi TP supports ground-floor targets", true) return end
    local hook = findTool(Config.HookNames, Config.HookName)
    if not hook then setStatus("Get a Grapple Hook first", true) return end
    local carpet = findTool(Config.CarpetNames)
    if not carpet then setStatus("Get a Flying Carpet first", true) return end
    if not hook.Enabled or hook:GetAttribute("CooldownTime") ~= nil then
        setStatus("Grapple Hook is on cooldown", true) return
    end
    local usePotion = PotionEnabled == true and HubConfig.giantPotionEnabled ~= false and not potionState.isGiant(character)
    local shield = PotionEnabled == true and HubConfig.griefShieldEnabled ~= false and findTool({ "Grief Shield" }) or nil
    local potion = usePotion and findTool(Config.PotionNames) or nil
    if usePotion and not potion then setStatus("Get a Giant Potion or turn Auto Potion off", true) return end
    if usePotion and (not potion.Enabled or os.clock() - potionState.lastUse < Config.PotionCooldown) then
        setStatus("Giant Potion is on cooldown", true) return
    end
    Runtime.MoveId = Runtime.MoveId + 1
    local context = {
        Id = Runtime.MoveId, Character = character, Humanoid = humanoid, Root = root,
        Tool = hook, Carpet = carpet, Potion = potion, UsePotion = usePotion, Shield = shield,
        PreviousTool = character:FindFirstChildOfClass("Tool"), Target = target,
        TargetOwner = plotOwnerName(target.plot), Route = route, StartedAt = os.clock(),
        Speed = FUNHUB.semiSpeed(),
        Deadline = os.clock() + Config.MoveTimeout,
        PreviousSourceBusy = _G.FUNHUB_SemiTP_Busy, PreviousDebounce = FUNHUB.debounce,
        OwnsSourcePause = true, OwnsPotion = true,
    }
    Runtime.ActiveMove, Runtime.Busy = context, true
    FUNHUB.debounce, _G.FUNHUB_SemiTP_Busy, potionState.busy = true, true, true
    context.Pause = FUNHUB.beginSemiPause()
    stopFlyGear()
    if FUNHUBFx.motion then pcall(FUNHUBFx.motion.suspend) end
    context.Guard = RunService.Heartbeat:Connect(function()
        if context.Cleaned then return end
        if not Runtime.Alive or not FUNHUB_ALIVE() or LocalPlayer.Character ~= character
            or not root.Parent or not humanoid.Parent or humanoid.Health <= 0
            or _G.FUNHUB_SemiTP_ResetBusy or not FUNHUBFx.semiPauses[context.Pause] then
            Runtime.Cancel("Run stopped - character changed or reset", false)
        elseif os.clock() > context.Deadline then
            Runtime.Cancel("Run timed out - retry")
        end
    end)
    local thread = task.spawn(function()
        local ok, result = pcall(performGrapple, context)
        context.Succeeded = ok
        cleanupMove(context, true)
        if not Runtime.Alive or Runtime.MoveId ~= context.Id then return end
        Runtime.Busy = false
        Runtime.NextRun = os.clock() + Config.ClickCooldown
        if ok then setStatus(string.format("Path complete - grab requested (%.2fs)", result))
        else setStatus(tostring(result), true) end
    end)
    if coroutine.status(thread) ~= "dead" then context.Thread = thread end
    return true -- Accepted; automatic triggers must not consume a refused attempt.
end
local function collectCallbacks(signal, filterHold)
    local result = {}
    local getter = getconnections or Environment.getconnections
    if type(getter) == "function" and signal then
        local ok, connections = pcall(getter, signal)
        if ok and type(connections) == "table" then
            for _, connection in ipairs(connections) do
                pcall(function()
                    local callback = connection.Function
                    if type(callback) ~= "function" then return end
                    local source = ""
                    if filterHold and debug and type(debug.info) == "function" then
                        local known, value = pcall(debug.info, callback, "s")
                        if known then source = tostring(value or "") end
                    end
                    if not filterHold or not (source:find("PlotClient", 1, true)
                        and not source:find("AnimalPrompt", 1, true)) then
                        result[#result + 1] = callback
                    end
                end)
            end
        end
    end
    return result
end

local function callGrabHandlers(context, callbacks)
    local batch = {Pending = #callbacks, Succeeded = 0}
    context.GrabThreads = context.GrabThreads or {}
    for _, callback in ipairs(callbacks) do
        requireLive(context)
        local thread = task.spawn(function()
            local ok, failure = pcall(function()
                requireLive(context)
                return callback()
            end)
            if ok then batch.Succeeded = batch.Succeeded + 1
            else context.GrabError = tostring(failure) end
            batch.Pending = batch.Pending - 1
        end)
        context.GrabThreads[#context.GrabThreads + 1] = thread
    end
    return batch
end

local function restartGrabHold(context)
    requireLive(context)
    context.HoldBeganAt = os.clock()
    if context.Progress then context.Progress.holdBeganAt = tick() end
    if context.GrabCallbacks then
        context.HoldBatch = nil
        context.HoldBatch = callGrabHandlers(context, context.GrabHold)
        requireLive(context)
    end
end

function Runtime.StartGrab(context)
    requireLive(context)
    if not Runtime.Busy or Runtime.ActiveMove ~= context then error("Cancelled", 0) end
    Runtime.CancelGrab()
    local prompt = context.Target.prompt
    context.OriginalPrompt = {LOS = prompt.RequiresLineOfSight, Range = prompt.MaxActivationDistance}
    context.GrabHold = collectCallbacks(prompt.PromptButtonHoldBegan, true)
    context.GrabTrigger = collectCallbacks(prompt.Triggered, false)
    context.GrabRelease = collectCallbacks(prompt.PromptButtonHoldEnded, false)
    context.GrabCallbacks = #context.GrabTrigger > 0
    context.NativePromptFire = fireproximityprompt or Environment.fireproximityprompt
    Runtime.GrabMoveId = context.Id
    Runtime.GrabContext = context
    context.Progress = {prompt = prompt, character = context.Character, semiSource = true,
        native = true, cb = {hold = {}, trigger = {}, release = {}},
        expires = os.clock() + 30, startedAt = tick(), progressDuration = Config.GrabDuration,
        originalLOS = prompt.RequiresLineOfSight, originalRange = prompt.MaxActivationDistance}
    FUNHUBHold.track(context.Progress, "Semi TP", "Grapple / slot " .. tostring(context.Target.slot))
    prompt.RequiresLineOfSight = false
    prompt.MaxActivationDistance = math.huge
    restartGrabHold(context)
    if not context.GrabCallbacks and type(context.NativePromptFire) == "function" then
        local thread = task.spawn(function()
            local ok, failure = pcall(function()
                requireLive(context)
                context.Progress.lastTrigger = tick()
                FUNHUBHold.noteSemiAttempt(context.Progress)
                context.NativePromptFire(prompt)
            end)
            if not ok then context.GrabError = tostring(failure) end
        end)
        context.GrabThreads = context.GrabThreads or {}
        context.GrabThreads[#context.GrabThreads + 1] = thread
    end

end

function Runtime.FinishGrab(context)
    requireLive(context)
    local prompt = context.Target.prompt
    setStatus("Finishing slot " .. context.Target.slot .. " grab")
    if context.GrabCallbacks or type(context.NativePromptFire) == "function" then
        if os.clock() - context.HoldBeganAt > Config.GrabExpiry then restartGrabHold(context) end
        while os.clock() - context.HoldBeganAt < Config.GrabDuration do waitFrames(context, 1) end
        waitSeconds(context, 0.02)
        requireLive(context)
        context.GrabFinishing = true
        context.Progress.lastTrigger = tick()
        FUNHUBHold.noteSemiAttempt(context.Progress)
        if context.GrabCallbacks then
            callGrabHandlers(context, context.GrabTrigger)
        else
            local ok, failure = pcall(context.NativePromptFire, prompt, 0)
            if not ok then error("Native prompt fire failed: " .. tostring(failure), 0) end
        end
    else
        context.GrabFinishing = true
        context.HoldBeganAt = os.clock()
        context.Progress.holdBeganAt = tick()
        FUNHUBHold.noteSemiAttempt(context.Progress)
        context.Progress.lastTrigger = tick()
        context.GrabDuration = math.max(tonumber(prompt.HoldDuration) or Config.GrabDuration, 0.05)
        Runtime.HeldPrompt = prompt
        context.Progress.progressDuration = context.GrabDuration
        prompt:InputHoldBegin()
        waitSeconds(context, context.GrabDuration)
        prompt:InputHoldEnd()
        Runtime.HeldPrompt = nil
    end
    context.GrabTriggered = true
end
-- Both methods use the same panel, target picker, potion options and pickup actions.
Runtime.window = semiWin
binds.grappleSemiSteal = F.runSemi -- preserve an additional saved legacy binding
binds.cancelGrappleSemi = function() Runtime.Cancel() end
local statusRow = U.row(semiWin.card, 58)
statusLabel = U.text("TextLabel", statusRow, "Ready - ground floor only", 12, WR, C.DIM)
statusLabel.Position, statusLabel.Size = UDim2.fromOffset(8, 0), UDim2.new(1, -16, 1, 0)
statusLabel.TextWrapped = true
setStatus("Ready - ground floor only")
R.rows[#R.rows + 1] = function()
    statusRow.Visible = FUNHUB.semiMode() == "Grapple"
    Runtime.RenderStatus()
end
U.on(LocalPlayer.CharacterRemoving, function() Runtime.Cancel("Respawn then run Grapple Semi TP", false) end)
R.cleanup[#R.cleanup + 1] = Runtime.Shutdown
end
-- End Grapple Semi TP.

local manageWin = U.sub("Manage", "manage")
local shareWin = U.popup("Share & Import", "share")
local aimPop = U.popup("Aimbot", "aim")
U.toggle(aimPop.body, "Auto Spam", chipOpt("autoSpamEnabled"))

local safetyPop = U.popup("Safety Kick", "safety")
U.toggle(safetyPop.body, "Kick If No Cmds", acOpt("kickNoCmds", false))
U.toggle(safetyPop.body, "Leave After Balloon", acOpt("leaveBalloon", false))
U.toggle(safetyPop.body, "Kick 3rd Player", acOpt("kick3rd", false))

local defSetWin = U.sub("Settings", "defset")
local function cmdDrop(text, key, def)
    U.drop(defSetWin.card, text, F.CMDS, { multi = true, get = function() return U.get(key, def) end, set = function(v) U.set(key, v) end })
end
cmdDrop("Single Cmds 1", "defCmds1", { "balloon" })
cmdDrop("Single Cmds 2", "defCmds2", { "ragdoll", "rocket", "inverse", "tiny", "jumpscare" })
cmdDrop("Multi Cmds 1", "defMulti1", { "balloon" })
cmdDrop("Multi Cmds 2", "defMulti2", { "ragdoll", "rocket", "inverse", "tiny" })
cmdDrop("Intruder Cmds", "intruderCmds", { "balloon" })
local defWin = U.sub("Auto Defense", "defense")
U.toggle(defWin.card, "Enabled", acOpt("autoDefense", false))
U.toggle(defWin.card, "Safety Kick", { get = function() return U.get("safetyKick", true) end, set = function(v) U.set("safetyKick", v) end,
    dots = function(r) U.openPop(safetyPop, r) end })
U.toggle(defWin.card, "Settings", { get = function() return defSetWin.f.Visible end, set = function(v) defSetWin.f.Visible = v end,
    dots = function() U.openSub(defSetWin) end })
U.toggle(defWin.card, "Anti Intruder", acOpt("antiIntruder", false))

local spamPop = U.popup("Semi Spam After TP", "spamsteal")
U.drop(spamPop.body, "Semi Commands", { "balloon", "ragdoll", "rocket", "inverse", "tiny", "jail", "jumpscare", "morph" },
    { multi = true, get = function() return U.get("spam1Cmds", F.SPAM1_DEF) end, set = function(v) U.set("spam1Cmds", v) end })

F.semiMore = semiWin
U.toggle(F.semiMore.card, "Auto Giant Potion", { get = function()
    return F.cfg("potionEnabled") and HubConfig.giantPotionEnabled ~= false
end, set = F.setGiantPotion })
U.toggle(F.semiMore.card, "Use Grief Shield", { get = function() return HubConfig.griefShieldEnabled ~= false end,
    set = function(v) HubConfig.griefShieldEnabled = v saveHubConfig() end })
U.toggle(F.semiMore.card, "AP Spam", { get = function() return U.get("spamAfter", false) end,
    set = function(v) U.set("spamAfter", v) end, dots = function(r) U.openPop(spamPop, r) end,
    tip = "Sends your chosen Semi commands to the target base owner after a confirmed pickup. Shared by Normal and Grapple Semi TP." })
R.cleanup[#R.cleanup + 1] = FUNHUB.autoAllow.Shutdown
U.toggle(F.semiMore.card, "Auto TP On Allow", acOpt("autoTPOnAllow", false, FUNHUB.autoAllow.Reset))
U.toggle(F.semiMore.card, "Auto TP On Unlock", acOpt("autoTPOnUnlock", false))

local BOX_MODES = { "Corner", "2D", "3D", "Triangle", "Circle", "Square", "Star" }
local brESPPop = U.popup("Brainrot ESP", "bresp")
-- Brainrot appearance is independent of UI-theme and player-ESP colors.
function F.brColor(rarity)
    if U.get("brColorMode", "Custom") == "Rarity" then
        local c = F.rarityColor(rarity)
        if F.forceVisible and F.forceVisible() then
            local h, s, v = c:ToHSV()
            if v < 0.7 then c = Color3.fromHSV(h, math.min(s, 0.8), 0.95) end
        end
        return c
    end
    return fromT(AC.brColor, rgb(60, 225, 255))
end
do
    local function refreshESP() if F.espTick then pcall(F.espTick) end end
    U.drop(brESPPop.body, "Color Mode", { "Custom", "Rarity" }, {
        get = function() return U.get("brColorMode", "Custom") end,
        set = function(v) U.set("brColorMode", v) refreshESP() end })
    local palettes = { Cyan = { 60, 225, 255 }, White = { 255, 255, 255 }, Pink = { 255, 100, 220 },
        Lime = { 120, 255, 100 }, Yellow = { 255, 230, 80 }, Red = { 255, 85, 105 } }
    U.drop(brESPPop.body, "Color Preset", { "Cyan", "White", "Pink", "Lime", "Yellow", "Red" }, {
        get = function() return U.get("brColorPreset", "Cyan") end,
        set = function(v)
            AC.brColor, AC.brColorMode, AC.brColorPreset = table.clone(palettes[v]), "Custom", v
            saveHubConfig() refreshESP()
        end })
    local function hexValue()
        local c = toT(fromT(AC.brColor, rgb(60, 225, 255)))
        return string.format("#%02X%02X%02X", c[1], c[2], c[3])
    end
    local hex = U.input(brESPPop.body, "Custom Hex", "#3CE1FF", hexValue(), function(value)
        local cleaned = value:gsub("%s", ""):gsub("^#", "")
        if #cleaned == 6 and cleaned:match("^%x+$") then
            AC.brColor = { tonumber(cleaned:sub(1, 2), 16), tonumber(cleaned:sub(3, 4), 16), tonumber(cleaned:sub(5, 6), 16) }
            AC.brColorMode, AC.brColorPreset = "Custom", "Custom"
            saveHubConfig() refreshESP()
        else U.notify("Brainrot ESP", "Enter six hex digits, for example #3CE1FF.") end
    end)
    R.rows[#R.rows + 1] = function()
        if not hex:IsFocused() then hex.Text = hexValue() end
    end
    U.slider(brESPPop.body, "Text Size", 12, 30, 1, function() return U.get("brTextSize", 18) end,
        function(v) U.set("brTextSize", v) refreshESP() end)
    U.slider(brESPPop.body, "Box Thickness", 1, 6, 0.5, function() return U.get("brThickness", 2.5) end,
        function(v) U.set("brThickness", v) F.espReset() end)
    U.slider(brESPPop.body, "Chams Opacity (%)", 5, 90, 5, function() return U.get("brOpacity", 55) end,
        function(v) U.set("brOpacity", v) refreshESP() end)
    U.toggle(brESPPop.body, "Label Backdrop", acOpt("brLabelBackdrop", false, refreshESP))
end

U.drop(brESPPop.body, "Rarities", { "OG", "Secret", "Brainrot God", "Mythic", "Legendary", "Epic", "Rare", "Common" },
    { multi = true, get = function() return U.get("brRarities", { "OG", "Secret" }) end, set = function(v) U.set("brRarities", v) end })
U.toggle(brESPPop.body, "Boxes", acOpt("brBoxes", true))
U.drop(brESPPop.body, "Box Mode", BOX_MODES, { get = function() return U.get("brBoxMode", "Corner") end, set = function(v) U.set("brBoxMode", v) F.espReset() end })
U.toggle(brESPPop.body, "Chams", acOpt("brChams", true))
U.toggle(brESPPop.body, "Name", acOpt("brName", true))
U.toggle(brESPPop.body, "Generation", acOpt("brGen", true))
U.toggle(brESPPop.body, "Distance", acOpt("brDist", true))

local footPop = U.popup("Footstep ESP", "foot")
U.slider(footPop.body, "Lifetime (seconds)", 1, 8, 1, function() return U.get("footLife", 4) end, function(v) U.set("footLife", v) end)
local FOOT_COLORS = { rgb(78, 192, 255), rgb(255, 255, 255), rgb(255, 60, 90), rgb(60, 220, 140), rgb(255, 205, 90), rgb(0, 190, 255) }
U.button(footPop.body, "Footstep Color", function(l)
    local cur = toT(fromT(AC.footColor, FOOT_COLORS[1]))
    local idx = 1
    for k, c in ipairs(FOOT_COLORS) do local t = toT(c) if t[1] == cur[1] and t[2] == cur[2] and t[3] == cur[3] then idx = k end end
    AC.footColor = toT(FOOT_COLORS[idx % #FOOT_COLORS + 1])
    saveHubConfig()
    l.TextColor3 = fromT(AC.footColor, C.WHITE)
end)
local iconPop = U.popup("Icons", "icons")
U.toggle(iconPop.body, "Admin", acOpt("iconAdmin", true))
U.toggle(iconPop.body, "Giant Potion", acOpt("iconGiant", true))
U.toggle(iconPop.body, "Flash Teleport", acOpt("iconFlash", true))

local plESPPop = U.popup("Player ESP", "plesp")
U.toggle(plESPPop.body, "Boxes", acOpt("plBoxes", true))
U.drop(plESPPop.body, "Box Mode", BOX_MODES, { get = function() return U.get("plBoxMode", "Corner") end, set = function(v) U.set("plBoxMode", v) F.espReset() end })
U.toggle(plESPPop.body, "Chams", acOpt("plChams", true))
U.toggle(plESPPop.body, "Name", acOpt("plName", true))
U.toggle(plESPPop.body, "Use Display Name", acOpt("plDisplay", true))
U.toggle(plESPPop.body, "Distance", acOpt("plDist", true))
U.toggle(plESPPop.body, "Stealing Tag", acOpt("plStealTag", true))
U.toggle(plESPPop.body, "Invisible Tag", acOpt("plInvisTag", true))
U.toggle(plESPPop.body, "Footstep ESP", { get = function() return U.get("plFoot", false) end, set = function(v) U.set("plFoot", v) end,
    dots = function(r) U.openPop(footPop, r) end })
U.toggle(plESPPop.body, "Icons", { get = function() return U.get("plIcons", true) end, set = function(v) U.set("plIcons", v) end,
    dots = function(r) U.openPop(iconPop, r) end })

local timerPop = U.popup("Timer", "timer")
U.toggle(timerPop.body, "Repeat On Every Floor", acOpt("timerFloors", false))
U.toggle(timerPop.body, "Screen HUD", acOpt("timerHud", true, function() if F.baseHud then F.baseHud() end end))

-- Delivery ESP shares one saved toggle across Stealing, Visuals and Base ESP.
do
    local pop = U.popup("Delivery ESP", "deliveryesp")
    local function refresh() if F.deliveryESPTick then F.deliveryESPTick() end end
    function F.setDeliveryESP(v) U.set("delivery", v == true) refresh() end
    function F.openDeliveryESPSettings(row) U.openPop(pop, row) end
    U.toggle(pop.body, "Enabled", { get = function() return U.get("delivery", false) end, set = F.setDeliveryESP })
    U.toggle(pop.body, "Distance", acOpt("deliveryDistance", true, refresh))
    U.toggle(pop.body, "Direction Guide", acOpt("deliveryGuide", true, refresh))
    U.toggle(pop.body, "Nearest Fallback", { get = function() return U.get("deliveryFallback", true) end,
        set = function(v) U.set("deliveryFallback", v) refresh() end,
        tip = "If your base is unknown, marks the nearest delivery as OWNER UNCONFIRMED. Never substitutes another zone for a known base." })
    U.slider(pop.body, "Label Size", 12, 22, 1, function() return U.get("deliveryTextSize", IsMobile and 14 or 17) end,
        function(v) U.set("deliveryTextSize", v) refresh() end)
    U.slider(pop.body, "Fill Opacity (%)", 5, 60, 5, function() return U.get("deliveryOpacity", 20) end,
        function(v) U.set("deliveryOpacity", v) refresh() end)
    local palettes = { Orange = { 255, 155, 45 }, Cyan = { 65, 225, 255 }, Pink = { 255, 100, 220 },
        Lime = { 145, 255, 85 }, White = { 255, 255, 255 }, Purple = { 185, 125, 255 } }
    U.drop(pop.body, "Color Preset", { "Orange", "Cyan", "Pink", "Lime", "White", "Purple" }, {
        get = function() return U.get("deliveryColorPreset", "Orange") end,
        set = function(v)
            if not palettes[v] then return end
            AC.deliveryColor, AC.deliveryColorPreset = table.clone(palettes[v]), v
            saveHubConfig() refresh()
        end })
    local function hexValue()
        local c = toT(fromT(AC.deliveryColor, rgb(255, 155, 45)))
        return string.format("#%02X%02X%02X", c[1], c[2], c[3])
    end
    local hex = U.input(pop.body, "Custom Hex", "#FF9B2D", hexValue(), function(value)
        local clean = value:gsub("%s", ""):gsub("^#", "")
        if #clean ~= 6 or not clean:match("^%x+$") then
            U.notify("Delivery ESP", "Enter six hex digits, for example #FF9B2D.") return
        end
        AC.deliveryColor = { tonumber(clean:sub(1, 2), 16), tonumber(clean:sub(3, 4), 16), tonumber(clean:sub(5, 6), 16) }
        AC.deliveryColorPreset = "Custom"
        saveHubConfig() refresh()
    end)
    R.rows[#R.rows + 1] = function() if not hex:IsFocused() then hex.Text = hexValue() end end
end

local baseESPPop = U.popup("Base ESP", "baseesp")
U.toggle(baseESPPop.body, "Xray", acOpt("xray", false, function(v) if not v and F.xrayClear then F.xrayClear() end end))
U.slider(baseESPPop.body, "Xray Transparency", 0, 1, 0.05, function() return U.get("xrayT", 0.7) end, function(v) U.set("xrayT", v) end)
U.toggle(baseESPPop.body, "Allowed", acOpt("allowedTag", true))
U.toggle(baseESPPop.body, "Timer", { get = function() return U.get("baseTimer", true) end,
    set = function(v) U.set("baseTimer", v) if F.baseHud then F.baseHud() end end, dots = function(r) U.openPop(timerPop, r) end })
U.toggle(baseESPPop.body, "Delivery ESP", { get = function() return U.get("delivery", false) end,
    set = F.setDeliveryESP, dots = F.openDeliveryESPSettings })

local miscESPPop = U.popup("Misc ESP", "miscesp")
F.miscSync = function()
    local on = U.get("miscEsp", false)
    F.setCfg("tracersEnabled", on and U.get("tracers", false))
    F.setCfg("serverGhostEnabled", on and U.get("serverPos", false))
end
U.toggle(miscESPPop.body, "Bullet Tracers", acOpt("tracers", false, F.miscSync))
U.toggle(miscESPPop.body, "Server Position", acOpt("serverPos", false, F.miscSync))
U.toggle(miscESPPop.body, "Self Chams", { get = function() return U.get("selfChams", false) end, set = function(v) U.set("selfChams", v) end,
    tip = "Reversible; keeps clothing, textures and animations" })
U.toggle(miscESPPop.body, "Clone ESP", acOpt("cloneEsp", false))

function F.publicOption(key)
    return { get = function() return U.get("pubMethod", false) and U.get(key, false) end,
        set = function(v)
            U.set(key, v)
            if v then U.set("pubMethod", true) end
            if F.publicSync then F.publicSync() end
        end }
end
local pubPop = U.popup("Pub Method", "pub")
U.toggle(pubPop.body, "Slot ESP", F.publicOption("slotEsp"))
U.toggle(pubPop.body, "Next Base", F.publicOption("nextBase"))

local fovPop = U.popup("Custom FOV/Stretch", "fov")
U.slider(fovPop.body, "FOV", 30, 120, 1, function() return F.num("fovValue", 80) end, function(v) F.setNum("fovValue", v) end)
U.slider(fovPop.body, "Stretch", 0.3, 1, 0.05, function() return U.get("stretch", 1) end, function(v) U.set("stretch", v) end)

local espLookWin = U.sub("ESP Look", "esplook")
U.drop(espLookWin.card, "Renderer", { "Auto", "Drawing", "GUI" },
    { get = function() return U.get("espRenderer", "Auto") end, set = function(v) U.set("espRenderer", v) F.espReset() end })
U.slider(espLookWin.card, "Text Size", 8, 32, 1, function() return U.get("espText", 16) end, function(v) U.set("espText", v) end)
U.slider(espLookWin.card, "Box Thickness", 1, 6, 1, function() return U.get("espThick", 2) end, function(v) U.set("espThick", v) F.espReset() end)
U.toggle(espLookWin.card, "Force Visible Colors", acOpt("forceVisible", true, function() F.espReset() end))

-- Reversible local trade controls from the supplied region blocker.
do
local playerGui = player:FindFirstChild("PlayerGui")
local StarterGui = game:GetService("StarterGui")
local PLAZA_MESSAGE = "Trading Plaza is not available in your region."
local TRADE_MESSAGE = "Trading is not available."
local BUTTON_TEXT = TRADE_MESSAGE
local UNAVAILABLE_RED = Color3.fromRGB(255, 0, 0)
local running = true
local lastNotification = -math.huge
local notificationController, soundController
local function showUnavailable(message, title)
    if not running or os.clock() - lastNotification < 0.8 then return end
    lastNotification = os.clock()
    local controllers = ReplicatedStorage:FindFirstChild("Controllers")
    if controllers then
        if not notificationController then
            local module = controllers:FindFirstChild("NotificationController")
            if module then
                local ok, result = pcall(require, module)
                if ok then notificationController = result end
            end
        end
        if not soundController then
            local module = controllers:FindFirstChild("SoundController")
            if module then
                local ok, result = pcall(require, module)
                if ok then soundController = result end
            end
        end
    end
    if soundController then
        pcall(function() soundController:PlaySound("Sounds.Sfx.Activated") end)
        pcall(function() soundController:PlaySound("Sounds.Sfx.Error") end)
    end
    if notificationController then
        local ok = pcall(function() notificationController:Error(message) end)
        if ok then return end
        notificationController = nil
    end
    -- Only used if the game's notification module cannot be required.
    local ok = pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = 4,
        })
    end)
    if not ok then warn("[FUNHUB] " .. message) end
end
local function findPath(root, ...)
    for _, name in ipairs({...}) do
        root = root and root:FindFirstChild(name)
        if not root then return nil end
    end
    return root
end
local function isText(object)
    return object and (object:IsA("TextLabel") or object:IsA("TextButton")
        or object:IsA("TextBox"))
end
local function newScope()
    local scope = {connections = {}, restore = {}, created = {}, alive = true}
    function scope:connect(signal, callback)
        table.insert(self.connections, signal:Connect(callback))
    end
    function scope:force(object, property, value)
        local original = object[property]
        table.insert(self.restore, function() object[property] = original end)
        object[property] = value
        self:connect(object:GetPropertyChangedSignal(property), function()
            if self.alive and object[property] ~= value then
                object[property] = value
            end
        end)
    end
    function scope:close()
        if not self.alive then return end
        self.alive = false
        for _, connection in ipairs(self.connections) do connection:Disconnect() end
        for _, object in ipairs(self.created) do object:Destroy() end
        for index = #self.restore, 1, -1 do pcall(self.restore[index]) end
    end
    return scope
end
local function makeTextRed(label, scope)
    scope:force(label, "TextColor3", UNAVAILABLE_RED)
    -- Keep an existing text gradient from tinting the red.
    for _, child in ipairs(label:GetChildren()) do
        if child:IsA("UIGradient") then scope:force(child, "Enabled", false) end
    end
end
local function bindShop(shop, scope)
    if not isText(shop) then return end
    scope:force(shop, "Text", PLAZA_MESSAGE)
    makeTextRed(shop, scope)
    scope:force(shop, "AutoLocalize", false)
    scope:force(shop, "TextWrapped", true)
    scope:force(shop, "TextScaled", true)
end
local function bindPrompt(original, scope)
    if not original:IsA("ProximityPrompt") then return end
    -- A fresh local prompt has none of the original prompt's direct handlers,
    -- scripts, tags, or attributes. The real trade prompt stays disabled.
    local replacement = Instance.new("ProximityPrompt")
    replacement.Name = "FHRegionUnavailablePrompt"
    replacement.Enabled = false
    replacement.ActionText = "Unavailable"
    replacement.ObjectText = "Trading Plaza"
    replacement.AutoLocalize = false
    replacement.KeyboardKeyCode = original.KeyboardKeyCode
    replacement.GamepadKeyCode = original.GamepadKeyCode
    replacement.MaxActivationDistance = original.MaxActivationDistance
    replacement.RequiresLineOfSight = original.RequiresLineOfSight
    replacement.UIOffset = original.UIOffset
    replacement.Exclusivity = original.Exclusivity
    replacement.ClickablePrompt = true
    replacement.HoldDuration = 0
    replacement.Style = Enum.ProximityPromptStyle.Default
    table.insert(scope.created, replacement)
    scope:force(original, "Enabled", false)
    scope:connect(replacement.Triggered, function(who)
        if who == nil or who == player then
            showUnavailable(PLAZA_MESSAGE, "Trading Plaza")
        end
    end)
    replacement.Parent = original.Parent
    replacement.Enabled = true
end
local function bindButton(original, scope)
    if not original:IsA("GuiButton") then return end
    -- Cloning preserves the existing design without copying signal connections.
    local wasArchivable = original.Archivable
    original.Archivable = true
    local copied, replacement = pcall(function() return original:Clone() end)
    original.Archivable = wasArchivable
    assert(copied and replacement, "Could not copy the trade button.")
    table.insert(scope.created, replacement)
    replacement.Name = "FHRegionUnavailableButton"
    -- Remove embedded behavior before parenting the copy into PlayerGui.
    for _, object in ipairs(replacement:GetDescendants()) do
        if object:IsA("LuaSourceContainer") then object:Destroy() end
    end
    for _, object in ipairs(replacement:GetDescendants()) do
        for _, tag in ipairs(object:GetTags()) do object:RemoveTag(tag) end
        for attribute in pairs(object:GetAttributes()) do object:SetAttribute(attribute, nil) end
        if object:IsA("GuiButton") then
            object.Active = false
            object.Interactable = false
            object.Selectable = false
        end
    end
    for _, tag in ipairs(replacement:GetTags()) do replacement:RemoveTag(tag) end
    for attribute in pairs(replacement:GetAttributes()) do
        replacement:SetAttribute(attribute, nil)
    end
    local originalText = original:FindFirstChild("Txt") or original:FindFirstChildWhichIsA("TextLabel", true)
    if not originalText and original:IsA("TextButton") then originalText = original end
    if isText(originalText) then
        scope:force(originalText, "Text", BUTTON_TEXT)
        makeTextRed(originalText, scope)
    end
    local replacementText = replacement:FindFirstChild("Txt") or replacement:FindFirstChildWhichIsA("TextLabel", true)
    if isText(replacementText) then
        replacementText.Text = BUTTON_TEXT
        makeTextRed(replacementText, scope)
        replacementText.AutoLocalize = false
        replacementText.TextWrapped = true
        replacementText.TextScaled = true
    elseif replacement:IsA("TextButton") then
        replacement.Text = BUTTON_TEXT
        makeTextRed(replacement, scope)
        replacement.AutoLocalize = false
        replacement.TextWrapped = true
        replacement.TextScaled = true
    end
    replacement.Visible = true
    replacement.Active = true
    replacement.Interactable = true
    replacement.Selectable = true
    scope:force(original, "Active", false)
    scope:force(original, "Interactable", false)
    scope:force(original, "Selectable", false)
    scope:force(original, "Visible", false)
    scope:connect(replacement.Activated, function()
        showUnavailable(TRADE_MESSAGE, "Trading")
    end)
    replacement.Parent = original.Parent
end

local slots = {}
local function refresh(key, target, binder)
    local old = slots[key]
    if old and old.target == target and target.Parent then return end
    if old then old.scope:close() end
    slots[key] = nil
    if not target then return end
    local scope = newScope()
    local ok, err = pcall(binder, target, scope)
    if ok then slots[key] = { target = target, scope = scope }
    else scope:close() warn("[FUNHUB Trade Blocker] " .. tostring(err)) end
end
function F.tradeSync()
    if not running then return end
    playerGui = player:FindFirstChild("PlayerGui")
    local trade, plaza = U.get("tradeBlock", false), U.get("plazaBlock", false)
    refresh("shop", plaza and findPath(Workspace, "TradePlazaPortal", "Portal", "Portal",
        "Attachment", "BillboardGui", "Shop") or nil, bindShop)
    refresh("prompt", plaza and findPath(Workspace, "TradePlazaPortal", "Portal", "Prompt",
        "ProximityPrompt") or nil, bindPrompt)
    refresh("button", trade and findPath(playerGui, "LeftCenter", "LeftCenter", "Buttons",
        "TradePlayerList") or nil, bindButton)
    -- HEX's extra coverage: Send and Accept in already-open trade windows.
    local active = {}
    if U.get("tradeBlockV2", false) then
        local list = findPath(playerGui, "TradePlayerList", "TradePlayerList", "Sections", "Players", "List")
        for _, row in ipairs(list and list:GetChildren() or {}) do
            local send = findPath(row, "Fill", "Send")
            if send and send:IsA("GuiButton") then
                active[send] = true
                refresh(send, send, bindButton)
            end
        end
        local yes = findPath(playerGui, "TradePrompts", "Prompt", "Yes")
        if yes and yes:IsA("GuiButton") then active[yes] = true refresh(yes, yes, bindButton) end
    end
    local stale = {}
    for key in pairs(slots) do
        if typeof(key) == "Instance" and not active[key] then stale[#stale + 1] = key end
    end
    for _, key in ipairs(stale) do refresh(key, nil, bindButton) end
end
function F.setTradeBlock(key, enabled)
    U.set(key, enabled == true)
    F.tradeSync()
end
R.cleanup[#R.cleanup + 1] = function()
    running = false
    for _, slot in pairs(slots) do slot.scope:close() end
    table.clear(slots)
end
end

local function blockerInfo(title, key, description)
    local p = U.popup(title, key)
    U.input(p.body, "Effect", "", description, nil, true)
    return p
end
local rtbPop = blockerInfo("Region Trade Block", "rtb", "Blocks the Trade button locally")
local tpbPop = blockerInfo("Trading Plaza Block", "tpb", "Blocks the plaza portal locally")
local rtb2Pop = blockerInfo("Region Trade Block V2", "rtb2", "Blocks Send and Accept in trade windows")


-- Read-only ownership resolver retained for the leave timer, delivery slowdown and base HUDs.
function F.verifiedOwnPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local marked, fallback = {}, {}
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local sign = plot:FindFirstChild("PlotSign")
            local yours = sign and sign:FindFirstChild("YourBase")
            if yours then
                -- The game's local YourBase marker is authoritative, including when false.
                local ok, enabled = pcall(function() return yours.Enabled end)
                if ok and enabled == true then marked[#marked + 1] = plot end
            else
                local surface = sign and sign:FindFirstChild("SurfaceGui")
                local frame = surface and surface:FindFirstChild("Frame")
                local label = frame and frame:FindFirstChild("TextLabel")
                local text = label and label.Text or ""
                local owner = text:gsub("<[^>]+>", ""):gsub("%s+$", ""):gsub("'s [Bb]ase$", "")
                if owner == LP.Name or owner == LP.DisplayName then
                    local unique = true
                    for _, other in ipairs(Players:GetPlayers()) do
                        if other ~= LP and (other.Name == owner or other.DisplayName == owner) then unique = false break end
                    end
                    if unique then fallback[#fallback + 1] = plot end
                end
            end
        end
    end
    if #marked == 1 then return marked[1] end
    if #marked == 0 and #fallback == 1 then return fallback[1] end
    return nil -- Unknown or ambiguous ownership.
end


-- Quick Grab / Place: the attached feature runs unchanged behind the existing hub toggle.
do
    for _, key in ipairs({ "DiplexQuickGrab", "FunhubQuickGrab" }) do
        local previous = ENV[key]
        if type(previous) == "table" and type(previous.Destroy) == "function" then pcall(previous.Destroy) end
    end
    local sourceEnv = (getgenv and getgenv()) or shared or _G
    if type(sourceEnv.QuickGrabPlace_Stop) == "function" then pcall(sourceEnv.QuickGrabPlace_Stop) end

    local function startSource()
        -- BEGIN ATTACHED QUICK GRAB PLACE
        -- Quick Grab + Place
        -- Execute on the client, then press or tap the normal Grab / Place prompt.
        -- Removes the local hold delay. Server-side timers can still apply.
        -- To stop and restore durations: getgenv().QuickGrabPlace_Stop()

        local env = (getgenv and getgenv()) or shared or _G
        if type(env.QuickGrabPlace_Stop) == "function" then
            pcall(env.QuickGrabPlace_Stop)
        end

        local prompts = game:GetService("ProximityPromptService")
        local tracked = {}
        local connections = {}
        local running = true

        local function matches(prompt)
            local action = prompt.ActionText:gsub("<[^>]*>", ""):lower()
            if action:match("%S") then
                return action:find("%f[%a]grab%f[%A]") ~= nil
                    or action:find("%f[%a]place%f[%A]") ~= nil
            end
            local name = prompt.Name:lower():gsub("[%s_%-%p]", "")
            return name == "grab" or name == "place" or name == "placedown"
                or name == "grabprompt" or name == "placeprompt"
        end

        local function watch(prompt)
            if not running or not prompt:IsA("ProximityPrompt") or tracked[prompt] then
                return
            end

            local state = {
                duration = prompt.HoldDuration,
                patched = false,
                editing = false,
                connections = {},
            }
            tracked[prompt] = state

            local function refresh()
                if not running or state.editing then return end
                state.editing = true

                if matches(prompt) then
                    if not state.patched or prompt.HoldDuration ~= 0 then
                        state.duration = prompt.HoldDuration
                    end
                    state.patched = true
                    if prompt.HoldDuration ~= 0 then
                        prompt.HoldDuration = 0
                    end
                elseif state.patched then
                    state.patched = false
                    prompt.HoldDuration = state.duration
                else
                    state.duration = prompt.HoldDuration
                end

                state.editing = false
            end

            for _, property in ipairs({ "ActionText", "Name", "HoldDuration" }) do
                table.insert(state.connections,
                    prompt:GetPropertyChangedSignal(property):Connect(refresh))
            end
            table.insert(state.connections, prompt.Destroying:Connect(function()
                for _, connection in ipairs(state.connections) do
                    connection:Disconnect()
                end
                tracked[prompt] = nil
            end))
            refresh()
        end

        local function stop()
            if not running then return end
            running = false
            for _, connection in ipairs(connections) do
                connection:Disconnect()
            end
            for prompt, state in pairs(tracked) do
                for _, connection in ipairs(state.connections) do
                    connection:Disconnect()
                end
                if state.patched then
                    pcall(function() prompt.HoldDuration = state.duration end)
                end
            end
            tracked = {}
            if env.QuickGrabPlace_Stop == stop then
                env.QuickGrabPlace_Stop = nil
            end
        end
        env.QuickGrabPlace_Stop = stop

        table.insert(connections, workspace.DescendantAdded:Connect(watch))
        table.insert(connections, prompts.PromptShown:Connect(watch))
        for _, instance in ipairs(workspace:GetDescendants()) do
            watch(instance)
        end
        -- END ATTACHED QUICK GRAB PLACE
        return { stop = stop, tracked = tracked, isRunning = function() return running end }
    end

    local api = {}
    local state = { alive = true, source = nil, links = {}, shown = setmetatable({}, { __mode = "k" }) }
    F.quickGrab, ENV.FunhubQuickGrab = api, api
    AC.baseQuickGrab = U.get("baseQuickGrab", true) == true
    function api.IsEnabled()
        return state.alive and state.source ~= nil and state.source.isRunning() == true
    end
    function api.SetEnabled(value)
        if not state.alive then return end
        if value == true then
            if api.IsEnabled() then return end
            if state.source then state.source.stop() state.source = nil end
            state.source = startSource()
        elseif state.source then
            state.source.stop()
            state.source = nil
        end
    end
    function api.Status()
        return api.IsEnabled() and "Grab / Place  |  normal key or tap" or "Off"
    end
    api.OwnPlot = F.verifiedOwnPlot

    -- Let a matching native prompt keep its own key when a hub shortcut shares it.
    -- This only reads the attached feature's state; it never triggers or edits prompts.
    function api.HasNearbyPrompt(key)
        if key == nil or not api.IsEnabled() or not FUNHUB_ALIVE() then return false end
        local character = LP.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not rootPart or not humanoid or humanoid.Health <= 0 then return false end
        for prompt, record in pairs(state.source.tracked) do
            if record.patched and prompt.Parent and prompt.Enabled and state.shown[prompt] ~= false
                and (prompt.KeyboardKeyCode == key or prompt.GamepadKeyCode == key) then
                local parent = prompt.Parent
                local part = FUNHUBUI.promptPart(prompt)
                local position = parent:IsA("Attachment") and parent.WorldPosition or part and part.Position
                if position and (position - rootPart.Position).Magnitude <= prompt.MaxActivationDistance then return true end
            end
        end
        return false
    end
    FUNHUBUI.passQuickGrabKey = api.HasNearbyPrompt
    if PPS.PromptShown then
        state.links[#state.links + 1] = PPS.PromptShown:Connect(function(prompt) state.shown[prompt] = true end)
    end
    if PPS.PromptHidden then
        state.links[#state.links + 1] = PPS.PromptHidden:Connect(function(prompt) state.shown[prompt] = false end)
    end
    function api.Destroy()
        if not state.alive then return end
        api.SetEnabled(false)
        state.alive = false
        for _, connection in ipairs(state.links) do connection:Disconnect() end
        table.clear(state.links)
        if ENV.FunhubQuickGrab == api then ENV.FunhubQuickGrab = nil end
        if FUNHUBUI.passQuickGrabKey == api.HasNearbyPrompt then FUNHUBUI.passQuickGrabKey = nil end
    end
    R.cleanup[#R.cleanup + 1] = api.Destroy
    function F.quickGrabSync() api.SetEnabled(U.get("baseQuickGrab", true)) end
end
-- End attached Quick Grab / Place integration.

function F.quickGrabControls(parent)
    local c = U.card(parent, "QUICK GRAB / PLACE")
    U.toggle(c, "Quick Grab", { get = F.quickGrab.IsEnabled, set = function(v)
        U.set("baseQuickGrab", v) F.quickGrabSync()
    end, tip = "Removes the local hold delay on Grab / Place prompts. Use the normal key or tap. Saves on/off; disabling restores hold times." })
    local row = U.row(c, 34)
    local status = U.text("TextLabel", row, F.quickGrab.Status(), 11, WR, C.DIM)
    status.Size, status.TextWrapped = UDim2.fromScale(1, 1), true
    R.rows[#R.rows + 1] = function() status.Text = F.quickGrab.Status() end
end

-- No camera collision: preserve the standard camera controller and zoom input.
-- Roblox's occlusion Update takes/returns the desired camera CFrame and Focus.
-- Reference: https://github.com/Roblox/Core-Scripts/tree/master/PlayerScripts/StarterPlayerScripts_NewStructure/RobloxPlayerScript/CameraScript
do
    local S = { enabled = false, dead = false, patches = {}, nextTry = 0, busy = false, token = 0 }
    F.camera = S
    local function passThrough(_, _, desiredCFrame, desiredFocus)
        return desiredCFrame, desiredFocus
    end
    local function restore()
        for object, saved in pairs(S.patches) do
            pcall(function()
                -- Leave a later change made by the game/another script alone.
                if rawget(object, "Update") == passThrough then object.Update = saved.raw end
            end)
        end
        table.clear(S.patches)
    end
    local function patch(object, token)
        if S.dead or not S.enabled or token ~= S.token or type(object) ~= "table" then return false end
        if type(object.Update) ~= "function" then return false end
        local saved = S.patches[object]
        if saved and object.Update == passThrough then return true end
        local old = rawget(object, "Update")
        local ok = pcall(function() object.Update = passThrough end)
        if ok and object.Update == passThrough then
            S.patches[object] = { raw = old }
            return true
        end
        return false
    end
    local function discover(token)
        local scripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = scripts and scripts:FindFirstChild("PlayerModule")
        local cameraModule = playerModule and playerModule:FindFirstChild("CameraModule")
        local cameraRoot = cameraModule or (scripts and scripts:FindFirstChild("CameraScript"))
        local ready = false
        -- Requiring the concrete occlusion class also works when GetCameras is hidden.
        for _, name in ipairs({ "Poppercam", "Poppercam_Classic" }) do
            local module = cameraRoot and cameraRoot:FindFirstChild(name)
            if module and module:IsA("ModuleScript") then
                local ok, value = pcall(require, module)
                if ok then ready = patch(value, token) or ready end
            end
        end
        if cameraModule and cameraModule:IsA("ModuleScript") then
            local ok, cameras = pcall(require, cameraModule)
            if ok and type(cameras) == "table" then
                local active = cameras.activeOcclusionModule
                if type(active) == "table" and type(active.GetOcclusionMode) == "function" then
                    local modeOK, mode = pcall(active.GetOcclusionMode, active)
                    if modeOK and mode == Enum.DevCameraOcclusionMode.Zoom then
                        ready = patch(active, token) or ready
                    elseif modeOK and mode == Enum.DevCameraOcclusionMode.Invisicam then
                        ready = true -- This mode already keeps the camera out of walls' way.
                    end
                end
            end
        end
        if S.dead or not S.enabled or token ~= S.token then return end
        S.status = ready and "On" or "Waiting for the standard camera"
        if not ready and not S.warned and os.clock() - S.started > 5 then
            S.warned = true
            U.notify("No Camera Collision", "Standard camera module unavailable; waiting for it to load.")
        end
    end
    function S.setEnabled(value)
        if S.dead then return end
        local enabled = value == true
        if S.enabled == enabled then return end
        S.enabled, S.token = enabled, S.token + 1
        S.nextTry, S.started, S.warned = 0, os.clock(), false
        S.status = enabled and "Waiting for the camera" or "Off"
        if not enabled then restore() end
    end
    function F.cameraSync() S.setEnabled(U.get("noCameraCollision", true)) end
    U.on(RunService.Heartbeat, function()
        if S.dead or not S.enabled or S.busy or os.clock() < S.nextTry then return end
        S.nextTry, S.busy = os.clock() + 0.5, true
        local token = S.token
        task.spawn(function()
            local ok, err = pcall(discover, token)
            S.busy = false
            if not ok and not S.dead and S.enabled and token == S.token then
                S.status = "Waiting for the standard camera"
                if not S.warned then S.warned = true warn("[FUNHUB camera] " .. tostring(err)) end
            end
        end)
    end)
    U.on(LP.CharacterAdded, function() S.nextTry = 0 end)
    U.on(Workspace:GetPropertyChangedSignal("CurrentCamera"), function() S.nextTry = 0 end)
    R.cleanup[#R.cleanup + 1] = function()
        S.dead, S.enabled, S.token = true, false, S.token + 1
        restore()
    end
end

function F.movementSync()
    FUNHUBFx.noWalkDelay = U.get("noWalkDelay", true) == true
    local motion = FUNHUBFx.motion
    if motion then
        motion.syncDelivery()
        if not U.get("antiDeliveryFailed", false) and motion.mode == "Delivery" then motion.release() end
    end
end
R.cleanup[#R.cleanup + 1] = function() FUNHUBFx.noWalkDelay = false end

-- DatShawn source: base timer and in-base player cards, integrated with this UI.
-- Shared ownership resolution is strict; missing streamed data displays WAITING.
do
    local function visible(object, limit)
        local p = object
        while p and p ~= limit do
            if (p:IsA("GuiObject") and not p.Visible) or (p:IsA("LayerCollector") and not p.Enabled) then return false end
            p = p.Parent
        end
        return true
    end
    function F.parseBaseTime(text)
        text = tostring(text or ""):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$")
        if text == "open" or text == "unlocked" then return 0 end
        local mm, ss = text:match("(%d+):(%d+)")
        if mm and ss then return tonumber(mm) * 60 + tonumber(ss) end
        local m, s = text:match("(%d+)%s*m"), text:match("(%d+)%s*s")
        if m or s then return (tonumber(m) or 0) * 60 + (tonumber(s) or 0) end
        return tonumber(text:match("^(%d+)$")) or tonumber(text:match("(%d+)%s*seconds?"))
    end
    local timerIndex = { plot = nil, objects = {}, conns = {} }
    local function clearTimerIndex()
        for _, connection in ipairs(timerIndex.conns) do connection:Disconnect() end
        table.clear(timerIndex.conns)
        table.clear(timerIndex.objects)
        timerIndex.plot = nil
    end
    local function timerObjects(plot)
        if timerIndex.plot ~= plot then
            clearTimerIndex()
            timerIndex.plot = plot
            if plot then
                local function consider(object)
                    if object:IsA("TextLabel") or object:IsA("TextBox")
                        or ((object.Name == "Open" or object.Name == "Unlocked") and object:IsA("GuiObject")) then
                        timerIndex.objects[object] = true
                    end
                end
                timerIndex.conns[1] = plot.DescendantAdded:Connect(consider)
                timerIndex.conns[2] = plot.DescendantRemoving:Connect(function(object) timerIndex.objects[object] = nil end)
                for _, object in ipairs(plot:GetDescendants()) do consider(object) end
            end
        end
        return timerIndex.objects
    end
    R.cleanup[#R.cleanup + 1] = clearTimerIndex
    function F.baseTimerRead(plot)
        local objects = timerObjects(plot)
        if not plot then return "WAITING FOR BASE", nil, false end
        local best, relock, explicitOpen = nil, false, false
        for object in pairs(objects) do
            if object.Name == "RemainingTime" and (object:IsA("TextLabel") or object:IsA("TextBox"))
                and visible(object, plot) then
                local value = F.parseBaseTime(object.Text)
                if value ~= nil then
                    local delay = object.Parent and object.Parent:FindFirstChild("Delay")
                    local isRelock = delay and visible(delay, plot) or false
                    if best == nil or value > best then best, relock = value, isRelock end
                end
            elseif (object.Name == "Unlocked" or object.Name == "Open")
                and object:IsA("GuiObject") and visible(object, plot) then
                explicitOpen = true
            end
        end
        if best == nil then
            for _, key in ipairs({ "LockTime", "Timer", "BaseTimer" }) do
                local value = tonumber(plot:GetAttribute(key))
                if value and value >= 0 and value < 86400 then best = value break end
            end
        end
        if best == nil and explicitOpen then best = 0 end
        if best == nil then
            local locked = plot:GetAttribute("Locked")
            if locked == nil then locked = plot:GetAttribute("IsLocked") end
            if locked == false then best = 0 end
        end
        if best == nil then return "WAITING FOR TIMER", nil, false end
        best = math.max(0, math.floor(best))
        if best == 0 then return relock and "RELOCKING" or "OPEN", best, relock end
        return (relock and "RELOCK " or "LOCKED ") .. string.format("%d:%02d", best // 60, best % 60), best, relock
    end

    local panel = U.panel(root, UDim2.fromOffset(224, 68), UDim2.new(0.5, -112, 1, -184), nil, 0, 12, "basePlayers")
    panel.Visible = false
    local title = U.text("TextLabel", panel, "IN YOUR BASE", 11, WB, C.DIM)
    title.Position, title.Size = UDim2.fromOffset(10, 6), UDim2.new(1, -20, 0, 18)
    U.drag(title, panel, "basePlayers")
    local list = new("ScrollingFrame", { Position = UDim2.fromOffset(8, 30), Size = UDim2.new(1, -16, 1, -38),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        CanvasSize = UDim2.fromOffset(0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y }, panel)
    U.list(list, 5)
    local empty = U.text("TextLabel", list, "Your base is clear", 12, WM, C.DIM, Enum.TextXAlignment.Center)
    empty.Size = UDim2.new(1, -4, 0, 26)
    local cards = {}
    local function clear()
        for id, card in pairs(cards) do card:Destroy() cards[id] = nil end
    end
    local function bounds(plot)
        if not plot then return nil end
        local box = plot:FindFirstChild("StealHitbox", true)
        if box and box:IsA("BasePart") then return box.CFrame, box.Size end
        local ok, cf, size = pcall(plot.GetBoundingBox, plot)
        if ok then return cf, size end
    end
    function F.baseContains(cf, size, position)
        if not cf or not size then return false end
        local rel = cf:PointToObjectSpace(position)
        return math.abs(rel.X) <= size.X * 0.5 + 2 and math.abs(rel.Z) <= size.Z * 0.5 + 2
            and math.abs(rel.Y) <= size.Y * 0.5 + 10
    end
    function F.basePlayersTick()
        panel.Visible = U.get("basePlayers", false) == true
        if not panel.Visible then clear() return end
        local plot = F.quickGrab.OwnPlot()
        local cf, size = bounds(plot)
        local seen, count = {}, 0
        for _, plr in ipairs(Players:GetPlayers()) do
            local ch = plr.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if plr ~= LP and hrp and hum and hum.Health > 0 and F.baseContains(cf, size, hrp.Position) then
                count = count + 1
                seen[plr.UserId] = true
                local row = cards[plr.UserId]
                if not row then
                    row = new("Frame", { Size = UDim2.new(1, -5, 0, 43), BackgroundColor3 = C.ELEM, BorderSizePixel = 0 }, list)
                    U.round(row, 8)
                    local portrait = new("ImageLabel", { Size = UDim2.fromOffset(32, 32), Position = UDim2.fromOffset(5, 5),
                        BackgroundTransparency = 1, Image = "" }, row)
                    U.round(portrait, 8)
                    local display = U.text("TextLabel", row, plr.DisplayName, 12, WB, C.TEXT)
                    display.Position, display.Size = UDim2.fromOffset(43, 4), UDim2.new(1, -49, 0, 17)
                    display.TextTruncate = Enum.TextTruncate.AtEnd
                    local name = U.text("TextLabel", row, "@" .. plr.Name, 10, WM, C.DIM)
                    name.Position, name.Size = UDim2.fromOffset(43, 23), UDim2.new(1, -49, 0, 14)
                    name.TextTruncate = Enum.TextTruncate.AtEnd
                    cards[plr.UserId] = row
                    task.spawn(function()
                        local ok, url = pcall(Players.GetUserThumbnailAsync, Players, plr.UserId,
                            Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                        if ok and portrait.Parent and cards[plr.UserId] == row then portrait.Image = url end
                    end)
                end
                row.LayoutOrder = count
            end
        end
        for id, card in pairs(cards) do if not seen[id] then card:Destroy() cards[id] = nil end end
        title.Text = "IN YOUR BASE  ·  " .. count
        empty.Visible = count == 0
        empty.Text = cf and "Your base is clear" or "Waiting for your base"
        panel.Size = UDim2.fromOffset(224, 38 + math.max(28, math.min(count, 3) * 48 - 5))
    end
    R.cleanup[#R.cleanup + 1] = clear
end

do
    local pg = PAGES.Stealing
    local c = U.card(pg, "AUTO STEAL")
    U.toggle(c, "Auto Potion on Grab", { get = function() return U.get("autoPotionOnSteal", false) end,
        set = function(v) U.set("autoPotionOnSteal", v) HubConfig.funhub.autoPotionOnSteal = v F.autoPotionSync() end })
    U.toggle(c, "Potion Speed", { get = function() return U.get("speedGiant", true) end,
        set = function(v) U.set("speedGiant", v) F.speedSync() end,
        dots = function() U.openSub(potionWin) end,
        tip = "DatShawn carry boost while Giant Potion is active. Open settings to change the speed." })
    local potionStatusRow = U.row(c, 28)
    local potionStatusLabel = U.text("TextLabel", potionStatusRow, "Potion: Ready", 11, WR, C.DIM)
    potionStatusLabel.Size = UDim2.fromScale(1, 1)
    potionStatusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    R.rows[#R.rows + 1] = function()
        local status = U.get("autoPotionOnSteal", false)
            and (FUNHUBFx.backgroundPaused() and "Paused for Semi TP" or potionState.status) or "Auto use off"
        potionStatusLabel.Text = "Potion: " .. status
    end
    U.toggle(c, "Auto Steal Best", { get = function() return U.get("autoBest", false) end,
        set = function(v) F.setAutoMode("autoBest", v) end })
    U.toggle(c, "Autograb", { chip = "autograb", get = function() return U.get("autoGrab", false) end,
        set = F.setAutoGrab,
        tip = "Nearest brainrot using the supplied grab timing. Auto Potion on Grab drinks just before pickup." })
    U.toggle(c, "Anti Delivery Failed", { get = function() return U.get("antiDeliveryFailed", false) end,
        set = function(v) U.set("antiDeliveryFailed", v) F.movementSync() end,
        tip = "Slows giant carry movement to 15 only inside your own base delivery zone. Your regular speed stays active everywhere else." })
    U.toggle(c, "Delivery ESP", { get = function() return U.get("delivery", false) end,
        set = F.setDeliveryESP, dots = F.openDeliveryESPSettings,
        tip = "Your delivery zone through walls, distance and an off-screen guide. Works independently of Base ESP." })
    U.toggle(c, "Auto Steal Priority", { get = function() return U.get("autoPriority", false) end,
        set = function(v) F.setAutoMode("autoPriority", v) end,
        dots = function() if F.priorityShow then F.priorityShow(true) end end })
    U.toggle(c, "Defender Bypass Grab", chipOpt("defenderBypassEnabled"))
    U.toggle(c, "Public Method Grab", { get = function() return F.cfg("publicGrabEnabled") end,
        set = function(v) F.setCfg("publicGrabEnabled", v) end,
        tip = "Alternate method for Autograb, Best or Priority. Does nothing when all three are off." })
    c = U.card(pg, "ASSIST")
    U.toggle(c, "Semi TP", { get = function() return U.get("semiInstant", false) end,
        set = function(v) F.setSemiTP(v) U.showWindow(semiWin.f, v) end,
        dots = function() U.openSub(semiWin) end })
    U.toggle(c, "Auto Ragdoll Tech", acOpt("autoRagTech", false))
    U.toggle(c, "Auto Leave on Steal", { get = function() return F.cfg("kickAfterStealEnabled") end, set = function(v)
        F.setCfg("kickAfterStealEnabled", v)
        KickAfterStealEnabled = v
    end })
    U.toggle(c, "Auto Leave / Rejoin", { get = function() return F.cfg("autoRejoinEnabled") end,
        set = F.setLeaveTimer,
        dots = function() if F.openBaseLeave then F.openBaseLeave() end end,
        tip = "Open the timer menu to choose Leave or Rejoin and the seconds left." })
end

do
    local pg = PAGES.Player
    local c = U.card(pg, "MOVEMENT")
    U.toggle(c, "No Walking Delay", acOpt("noWalkDelay", true, F.movementSync))
    U.toggle(c, "No Camera Collision", { get = function() return U.get("noCameraCollision", true) end,
        set = function(v) U.set("noCameraCollision", v) F.cameraSync() end,
        tip = "Stops the standard camera pushing in at walls; keeps normal zoom and orbit." })
    U.toggle(c, "Speed", { get = function() return U.get("speedMaster", F.speedMasterDef) end,
        set = function(v) U.set("speedMaster", v) F.speedSync() U.showWindow(speedWin.f, v) end, dots = function() U.openSub(speedWin) end })
    U.toggle(c, "Carpet Speed", { get = function() return FUNHUBFx.carpet end,
        set = function(v) FUNHUBFx.carpet = v HubConfig.carpetSpeedEnabled = v saveHubConfig() U.showWindow(carpetWin.f, v) if F.actionsCarpet then F.actionsCarpet() end end,
        dots = function() U.openSub(carpetWin) end })
    U.toggle(c, "Infinite Jump", chipOpt("infJumpEnabled"))
    U.drop(c, "Auto Instant Reset", { "tiny", "balloon", "control", "inverse", "jail", "jumpscare", "morph", "nightvision", "ragdoll", "rocket" },
        { multi = true, none = "None", get = function() return U.get("autoResetCmds", {}) end, set = function(v) U.set("autoResetCmds", v) end })
    U.toggle(c, "Auto Reset On Ragdoll", acOpt("resetRagdoll", false))
    c = U.card(pg, "MISC")
    U.toggle(c, "Aimbot", { get = function() return F.cfg("aimbotEnabled") end, set = function(v) F.setCfg("aimbotEnabled", v) end,
        dots = function(r) U.openPop(aimPop, r) end })
    U.toggle(c, "Auto Destroy Sentry", { chip = "sentry", get = function() return F.cfg("destroySentryEnabled") end, set = function(v) F.setCfg("destroySentryEnabled", v) end })
    U.toggle(c, "Auto Destroy Doge", { chip = "doge", get = function() return F.cfg("destroyDogeEnabled") end, set = function(v) F.setCfg("destroyDogeEnabled", v) end })
    U.toggle(c, "Anti Bee", chipOpt("antiBeeEnabled"))
    U.toggle(c, "Anti Paintball", chipOpt("antiPaintEnabled"))
    U.toggle(c, "Anti Boogie Bomb", chipOpt("antiDiscoEnabled"))
    U.toggle(c, "Anti GummyBear", chipOpt("antiGummyEnabled"))
    U.toggle(c, "Anti WebSling", chipOpt("antiWebEnabled"))
    U.toggle(c, "Mute Walk Sound", acOpt("muteWalk", false))
    U.toggle(c, "Anti Ragdoll V2", { chip = "antiragdoll", get = function() return F.cfg("antiRagdollEnabled") end, set = function(v)
        F.setCfg("antiRagdollEnabled", v)
        AntiRagdollEnabled = v
    end })
    U.toggle(c, "Anti Admin Panel", { get = function() return F.cfg("antiRocketEnabled") end, set = function(v)
        F.setCfg("antiRocketEnabled", v)
        AntiRocketEnabled = v
    end })
    U.toggle(c, "Anti Body Swap", chipOpt("antiSwapEnabled"))
end

do
    local c = U.card(PAGES.Visuals, "BASE HUDS")
    U.toggle(c, "Leave Timer", { get = function() return F.cfg("autoRejoinEnabled") end,
        set = F.setLeaveTimer,
        dots = function() if F.openBaseLeave then F.openBaseLeave() end end,
        tip = "Enables the timer and selected Leave/Rejoin action. Turn off here to stop it and hide the counter. Dots change its settings." })
    U.toggle(c, "In-Base Player Cards", acOpt("basePlayers", false, F.basePlayersTick))
    U.toggle(c, "Performance Counter", { get = function() return U.get("performanceHud", true) end,
        set = function(v) F.setPerformanceHud(v) end,
        tip = "Small FPS/ping counter. Tap it for charts; × closes it. Re-enable it here." })
    c = U.card(PAGES.Visuals, "ESP")
    U.toggle(c, "Brainrot ESP", { get = function() return U.get("brEsp", false) end, set = function(v) U.set("brEsp", v) end,
        dots = function(r) U.openPop(brESPPop, r) end })
    U.toggle(c, "Line to Base", { get = function() return U.get("baseLine", false) end, set = function(v)
        U.set("baseLine", v)
        if not v then
            local line = Workspace:FindFirstChild("BaseLine")
            if line then line:Destroy() end
        end
    end })
    U.toggle(c, "Player ESP", { get = function() return U.get("plEsp", false) end, set = function(v) U.set("plEsp", v) end,
        dots = function(r) U.openPop(plESPPop, r) end })
    U.toggle(c, "Base ESP", { get = function() return U.get("baseEsp", false) end, set = function(v)
        U.set("baseEsp", v)
        if not v and F.xrayClear then F.xrayClear() end
        if F.baseHud then F.baseHud() end
    end, dots = function(r) U.openPop(baseESPPop, r) end })
    U.toggle(c, "Delivery ESP", { get = function() return U.get("delivery", false) end,
        set = F.setDeliveryESP, dots = F.openDeliveryESPSettings,
        tip = "Your delivery zone through walls, distance and an off-screen guide. Works independently of Base ESP." })
    U.toggle(c, "Misc ESP", { get = function() return U.get("miscEsp", false) end, set = function(v) U.set("miscEsp", v) F.miscSync() end,
        dots = function(r) U.openPop(miscESPPop, r) end })
    U.toggle(c, "Tripmine ESP", { get = function() return U.get("mineEsp", false) end,
        set = function(v) U.set("mineEsp", v) if F.tripmineTick then F.tripmineTick() end end,
        tip = "Marks deployed tripmines through walls with owner and distance. Blue is yours; red is another player's mine." })
    U.toggle(c, "Slot ESP", F.publicOption("slotEsp"))
    U.toggle(c, "Next Base", F.publicOption("nextBase"))
    U.toggle(c, "Pub Method", { get = function() return U.get("pubMethod", false) end, set = function(v)
        U.set("pubMethod", v)
        if F.publicSync then F.publicSync() end
    end, dots = function(r) U.openPop(pubPop, r) end })
    U.toggle(c, "Custom FOV/Stretch", { get = function() return F.cfg("customFovEnabled") end, set = function(v)
        F.setCfg("customFovEnabled", v)
        if not v and Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 70 end
    end, dots = function(r) U.openPop(fovPop, r) end })
end

-- Quick Panel: keep the player list current independently of other features.
do
    local Q = { alive = true, open = false, dirty = true, nextRefresh = 0, rows = {},
        leaving = setmetatable({}, { __mode = "k" }) }
    local panel = U.panel(root, UDim2.fromOffset(260, 260), UDim2.new(1, -280, 0.5, -130), nil, 0.55, 10, "quickPanel")
    panel.Visible = false
    local header = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1 }, panel)
    local title = U.text("TextLabel", header, "Quick Panel", 13, WB, C.WHITE)
    title.Position, title.Size = UDim2.fromOffset(10, 0), UDim2.new(1, -48, 1, 0)
    U.tgrad(title)
    U.drag(title, panel, "quickPanel")
    local close = U.text("TextButton", header, "X", 13, WB, C.TEXT, Enum.TextXAlignment.Center)
    close.Position, close.Size = UDim2.new(1, -34, 0, 2), UDim2.fromOffset(30, 30)
    local scroll = U.scroller(panel, UDim2.fromOffset(4, 34), UDim2.new(1, -8, 1, -38), 4, 5)
    scroll.Name = "QuickPlayers"
    local empty = U.text("TextLabel", scroll, "Waiting for other players", 12, WR, C.TEXT, Enum.TextXAlignment.Center)
    empty.Name, empty.Size, empty.TextWrapped = "EmptyPlayers", UDim2.new(1, 0, 0, 52), true
    local commands = { { "Balloon", "balloon" }, { "Jail", "jail" }, { "Tiny", "tiny" },
        { "Inverse", "inverse" }, { "Rocket", "rocket" } }

    local function remove(p)
        local row = Q.rows[p]
        if not row then return end
        for _, connection in ipairs(row.connections) do connection:Disconnect() end
        row.frame:Destroy()
        Q.rows[p] = nil
    end
    local function add(p)
        local row = Q.rows[p]
        if row and row.ready and row.frame.Parent == scroll then return row end
        if row then remove(p) end
        row = { connections = {}, frame = new("Frame", { Size = UDim2.new(1, 0, 0, IsMobile and 70 or 62),
            BackgroundTransparency = 1 }, scroll) }
        Q.rows[p] = row -- incomplete rows are rebuilt if GUI access is temporarily unavailable
        row.name = U.text("TextLabel", row.frame, "", 12, WM, C.TEXT)
        row.name.Size, row.name.TextTruncate = UDim2.new(1, 0, 0, 20), Enum.TextTruncate.AtEnd
        for i, item in ipairs(commands) do
            local command, target = item[2], p
            local button = U.text("TextButton", row.frame, item[1], 10, WM, C.WHITE, Enum.TextXAlignment.Center)
            button.Name = command
            button.Position, button.Size = UDim2.new((i - 1) / #commands, 1, 0, 22), UDim2.new(1 / #commands, -3, 0, IsMobile and 42 or 34)
            button.BackgroundColor3, button.BackgroundTransparency = C.ELEM, 0.35
            U.round(button, 6)
            row.connections[#row.connections + 1] = button.Activated:Connect(function()
                if not Q.alive or not Q.open or FUNHUBUI.bindingInput or FUNHUBKeys.blocked()
                    or Q.leaving[target] or target.Parent ~= Players then return end
                F.adminCmd(command, target)
            end)
        end
        row.ready = true
        return row
    end
    local function refresh()
        local present, players = {}, {}
        local function collect(list)
            for _, p in ipairs(list) do
                if p ~= LP and p:IsA("Player") and p.Parent == Players and not Q.leaving[p] and not present[p] then
                    present[p] = true
                    players[#players + 1] = p
                end
            end
        end
        local ok, list = pcall(Players.GetPlayers, Players)
        if ok then collect(list) end
        -- Match the existing Admin Spammer fallback for incomplete executor snapshots.
        local childrenOK, children = pcall(Players.GetChildren, Players)
        if childrenOK then collect(children) end
        if not ok and not childrenOK then
            empty.Text, empty.Visible = "Players not ready yet\nRetrying automatically", next(Q.rows) == nil
            Q.dirty = true
            return
        end
        table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
        for p in pairs(Q.rows) do if not present[p] then remove(p) end end
        for i, p in ipairs(players) do
            local row = add(p)
            row.frame.LayoutOrder = i
            row.name.Text = p.DisplayName .. "  @" .. p.Name
        end
        title.Text = "Quick Panel (" .. tostring(#players) .. ")"
        empty.Text, empty.Visible = "No other players in this server\nPlayers appear here when they join", #players == 0
        Q.dirty, Q.nextRefresh = false, os.clock() + 1
    end
    local function render()
        if not Q.alive or not FUNHUB_ALIVE() then return end
        local wanted = U.get("quickPanelOpen", false) == true
        if Q.open ~= wanted then Q.open, Q.visibilityDirty, Q.dirty = wanted, true, true end
        if Q.visibilityDirty then
            U.finishWindow(panel)
            if Q.open then
                scroll.CanvasPosition = Vector2.zero
                pcall(U.clampWindows)
            end
            -- Keep this panel independent of failures while painting unrelated windows.
            local transparency = math.clamp((tonumber(U.get("guiT", 0)) or 0) / 100, 0, 0.95)
            panel.BackgroundTransparency = 0.55 + 0.45 * transparency
            U.showWindow(panel, Q.open, "quickPanelOpen")
            Q.visibilityDirty = false
        end
        if Q.open and (Q.dirty or os.clock() >= Q.nextRefresh) then refresh() end
    end
    F.qpShow = function(v)
        if not Q.alive then return end
        Q.open, Q.visibilityDirty, Q.dirty = v == true, true, true
        U.set("quickPanelOpen", Q.open)
        pcall(render) -- the GUI loop retries if this caller cannot access the GUI host
    end
    U.on(close.Activated, function()
        if not FUNHUBUI.bindingInput and not FUNHUBKeys.blocked() then F.qpShow(false) end
    end)
    U.on(Players.PlayerAdded, function(p) Q.leaving[p], Q.dirty = nil, true end)
    U.on(Players.PlayerRemoving, function(p) Q.leaving[p], Q.dirty = true, true end)
    R.rows[#R.rows + 1] = render
    local elapsed = 0
    U.on(RunService.Heartbeat, function(dt)
        if not Q.open and not Q.visibilityDirty and U.get("quickPanelOpen", false) ~= true then return end
        elapsed = elapsed + dt
        if elapsed < 0.25 then return end
        elapsed = 0
        pcall(render)
    end)
    R.cleanup[#R.cleanup + 1] = function()
        Q.alive = false
        for p in pairs(Q.rows) do remove(p) end
    end
    F.qpShow(U.get("quickPanelOpen", false))
end
-- End Quick Panel.

do
    local c = U.card(PAGES.Admin, "ADMIN")
    U.toggle(c, "Auto Defense", { get = function() return defWin.f.Visible end, set = function(v) U.showWindow(defWin.f, v) end,
        dots = function() U.openSub(defWin) end })
    U.toggle(c, "Quick Panel", { get = function() return U.get("quickPanelOpen", false) end,
        set = function(v)
            U.set("quickPanelOpen", v)
            if F.qpShow then F.qpShow(v) end
        end })
    U.toggle(c, "Admin Spammer", { get = function() return U.get("adminSpamOpen", false) end,
        set = function(v) U.set("adminSpamOpen", v) if F.asShow then F.asShow(v) end end })
    U.toggle(c, "Taunt", { get = function() return U.get("taunt", false) end,
        set = function(v) U.set("taunt", v) end,
        tip = "Sends 'funhub on top' in public chat after a successful AP spam batch. One message per batch, with a 10 second cooldown." })
    U.toggle(c, "Command Cooldowns", acOpt("cooldownHud", false, function(v) if F.cdShow then F.cdShow(v) end end))
    U.toggle(c, "Intruder Alarm", acOpt("intruder", false))
end

local ACT = U.panel(root, UDim2.fromOffset(150, 332), UDim2.new(0, 16, 0.5, -60), nil, 0, 12, "actions")
ACT.AutomaticSize = Enum.AutomaticSize.Y
ACT.Visible = U.get("actions", false)
U.pad(ACT, 6, 6, 6, 8)
U.list(ACT, 5)
do
    local t = U.text("TextLabel", ACT, "Actions", 12, WB, C.WHITE, Enum.TextXAlignment.Center)
    t.Size = UDim2.new(1, 0, 0, 19)
    U.tgrad(t)
    U.drag(t, ACT, "actions")
end
-- Actions share the hub's GUI refresh and saved keybinds.
function F.actionNotice(title, message)
    F.pendingActionNotice = {title = title, message = message}
end
R.rows[#R.rows + 1] = function()
    local notice = F.pendingActionNotice
    if notice then
        U.notify(notice.title, notice.message)
        if F.pendingActionNotice == notice then F.pendingActionNotice = nil end
    end
end
function F.actionButton(text, fn, keyName, getLabel)
    local bindName = keyName or ("act_" .. text:gsub("%s+", "_"):lower())
    local b = U.text("TextButton", ACT, text, 12, WB, C.TEXT, Enum.TextXAlignment.Center)
    b.Name = bindName
    b.Size = UDim2.new(1, -4, 0, 25)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.ELEM
    b.LayoutOrder = nxt()
    b.TextScaled = true
    new("UITextSizeConstraint", {MinTextSize = 8, MaxTextSize = 12}, b)
    U.round(b, 8) U.stroke(b, 1)
    local busy = false
    local function show()
        local label = getLabel and getLabel() or text
        if listening and listening.name == bindName then
            b.Text = label .. " (...)"
            return
        end
        local key = AC.keys[bindName]
        b.Text = key and (label .. " (" .. U.shortKey(key) .. ")") or label
    end
    local function run()
        if not FUNHUB_ALIVE() or busy or listening or FUNHUBUI.bindingInput or FUNHUBKeys.blocked() then return end
        busy = true
        local ok, err = pcall(fn, b)
        busy = false
        if not ok then F.actionNotice(text, tostring(err)) end
    end
    show()
    U.on(b.MouseButton1Click, run)
    binds[bindName] = run
    U.on(b.MouseButton2Click, function()
        if U.beginBinding(bindName, show) then pcall(show) end
    end)
    R.rows[#R.rows + 1] = show
    return b, show
end
function F.selfRagdoll(t)
    local _, hum = F.char()
    if not hum then return end
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    task.delay(t or 1.2, function() if hum.Parent then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end end)
end
function F.equipUse(name)
    local ch, hum = F.char()
    local function valid()
        return FUNHUB_ALIVE() and LP.Character == ch and hum and hum.Parent and hum.Health > 0
            and not potionState.busy and not FUNHUB.debounce and not FUNHUBFx.backgroundPaused()
    end
    if not valid() then return false end
    local bp = LP:FindFirstChild("Backpack")
    local tool = (ch and ch:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
    if not tool or not tool:IsA("Tool") or tool.Enabled == false then return false end
    if tool.Parent ~= ch then
        hum:EquipTool(tool)
        local deadline = os.clock() + 0.6
        while valid() and tool.Parent ~= ch and os.clock() < deadline do RunService.Heartbeat:Wait() end
        if not valid() or tool.Parent ~= ch then return false end
        task.wait(0.1)
    end
    if not valid() or tool.Parent ~= ch or tool.Enabled == false then return false end
    tool:Activate()
    return true
end
do
    local lastRagdoll = -math.huge
    function F.selfRagdollCommand()
        if os.clock() - lastRagdoll < 30 then return end
        lastRagdoll = os.clock()
        local ok, sent = pcall(function()
            local message = "/ragdoll " .. LP.Name
            local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            local remote = events and events:FindFirstChild("SayMessageRequest")
            if remote then remote:FireServer(message, "All") return true end
            local channels = game:GetService("TextChatService"):FindFirstChild("TextChannels")
            local general = channels and channels:FindFirstChild("RBXGeneral")
            if general then general:SendAsync(message) return true end
            return false
        end)
        if not ok or not sent then
            lastRagdoll = -math.huge
            F.actionNotice("Self Ragdoll", "Chat is unavailable; try again when chat is ready")
        end
    end
end
-- Small Speed is a one-shot potion then reset action; it stores no enabled toggle.
do
    local S = {alive = true, active = nil, nextRun = 0}
    F.smallSpeed = S
    local function valid(ctx)
        return S.alive and FUNHUB_ALIVE() and S.active == ctx and not ctx.closed
            and LP.Character == ctx.character and ctx.character.Parent and ctx.humanoid.Parent
            and ctx.humanoid.Health > 0 and not _G.FUNHUB_SemiTP_ResetBusy
            and not potionState.stopped and FUNHUBFx.semiPauses[ctx.pause] == true
    end
    local function finish(ctx, restore)
        if not ctx or ctx.closed then return end
        ctx.closed = true
        if ctx.guard then ctx.guard:Disconnect() ctx.guard = nil end
        if ctx.thread and ctx.thread ~= coroutine.running() and type(task.cancel) == "function" then
            pcall(task.cancel, ctx.thread)
        end
        ctx.thread = nil
        if ctx.activePotion then pcall(function() ctx.activePotion:Deactivate() end) end
        if restore and not ctx.resetRequested and not _G.FUNHUB_SemiTP_ResetBusy
            and LP.Character == ctx.character and ctx.humanoid.Parent and ctx.humanoid.Health > 0 then
            pcall(function()
                local equipped = ctx.character:FindFirstChildOfClass("Tool")
                if not equipped or equipped == ctx.potion then
                    local backpack = LP:FindFirstChild("Backpack")
                    if ctx.previousTool and (ctx.previousTool.Parent == backpack or ctx.previousTool.Parent == ctx.character) then
                        ctx.humanoid:EquipTool(ctx.previousTool)
                    elseif equipped == ctx.potion then ctx.humanoid:UnequipTools() end
                end
            end)
        end
        if S.active == ctx then
            S.active = nil
            potionState.busy = false
            FUNHUB.debounce = ctx.previousDebounce
        end
        FUNHUB.endSemiPause(ctx.pause)
        S.nextRun = os.clock() + 0.6
    end
    function S.Cancel(restore)
        finish(S.active, restore ~= false)
    end
    function S.Shutdown()
        S.alive = false
        S.Cancel(false)
    end
    local function requireCurrent(ctx)
        if not valid(ctx) then error("Small Speed cancelled", 0) end
        if os.clock() >= ctx.deadline then error("Potion use timed out", 0) end
    end
    local function waitFor(ctx, seconds)
        local untilTime = os.clock() + seconds
        repeat
            requireCurrent(ctx)
            RunService.Heartbeat:Wait()
        until os.clock() >= untilTime
        requireCurrent(ctx)
    end
    function S.Run()
        if not S.alive or not FUNHUB_ALIVE() or S.active or os.clock() < S.nextRun then return end
        if potionState.busy or potionState.stopped or FUNHUB.debounce or FUNHUBFx.backgroundPaused() then
            F.actionNotice("Small Speed", "Wait for the current potion, Semi TP or reset")
            return
        end
        local character, humanoid = F.char()
        if not character or not humanoid or humanoid.Health <= 0 then
            F.actionNotice("Small Speed", "Wait for your character to load")
            return
        end
        local reset = _G.FUNHUB_SemiTP_InstaReset
        if type(reset) ~= "function" then F.actionNotice("Small Speed", "Instant Reset is unavailable") return end
        local alreadyGiant = potionState.isGiant(character)
        local potion = not alreadyGiant and potionState.find("Giant Potion", character) or nil
        if not alreadyGiant then
            if not potion then F.actionNotice("Small Speed", "Get a Giant Potion first") return end
            if potion.Enabled == false or potion:GetAttribute("CooldownTime") ~= nil
                or os.clock() - potionState.lastUse < potionState.timing.cooldown then
                F.actionNotice("Small Speed", "Giant Potion is on cooldown")
                return
            end
            if potion.RequiresHandle and not potion:FindFirstChild("Handle") then
                F.actionNotice("Small Speed", "Giant Potion is still loading")
                return
            end
        end
        local ctx = {character = character, humanoid = humanoid, potion = potion,
            previousTool = character:FindFirstChildOfClass("Tool"), previousDebounce = FUNHUB.debounce,
            deadline = os.clock() + 3}
        S.active, potionState.busy, FUNHUB.debounce = ctx, true, true
        ctx.pause = FUNHUB.beginSemiPause()
        ctx.guard = RunService.Heartbeat:Connect(function()
            if ctx.closed or ctx.resetRequested then return end
            if not valid(ctx) then finish(ctx, false)
            elseif os.clock() >= ctx.deadline then
                finish(ctx, true)
                F.actionNotice("Small Speed", "Potion use timed out; try again")
            end
        end)
        local thread = task.spawn(function()
            local ok, reason = pcall(function()
                requireCurrent(ctx)
                if potion then
                    if potion.Parent ~= character then
                        humanoid:EquipTool(potion)
                        local equipUntil = os.clock() + 0.6
                        while potion.Parent ~= character and os.clock() < equipUntil do
                            requireCurrent(ctx)
                            RunService.Heartbeat:Wait()
                        end
                    end
                    requireCurrent(ctx)
                    if potion.Parent ~= character then error("Could not equip Giant Potion", 0) end
                    waitFor(ctx, potionState.timing.equip)
                    if potion.Parent ~= character or potion.Enabled == false
                        or potion:GetAttribute("CooldownTime") ~= nil then
                        error("Giant Potion is not ready", 0)
                    end
                    ctx.activePotion = potion
                    potionState.lastUse = os.clock()
                    potionState.observe(character)
                    potion:Activate()
                    waitFor(ctx, potionState.timing.settle)
                    potionState.confirmEffect(character)
                end
                requireCurrent(ctx)
                ctx.resetRequested = true
                local resetOK, resetError = pcall(reset)
                if not resetOK then
                    ctx.resetRequested = _G.FUNHUB_SemiTP_ResetBusy == true
                    error("Instant Reset failed: " .. tostring(resetError), 0)
                end
            end)
            local cancelled = ctx.closed
            finish(ctx, not ctx.resetRequested)
            if not ok and not cancelled and S.alive and FUNHUB_ALIVE() then
                F.actionNotice("Small Speed", tostring(reason))
            end
        end)
        if coroutine.status(thread) ~= "dead" then ctx.thread = thread end
    end
    U.on(LP.CharacterRemoving, function() S.Cancel(false) end)
    R.cleanup[#R.cleanup + 1] = S.Shutdown
end
-- End Small Speed.

F.actionButton("Self Ragdoll", F.selfRagdollCommand)
F.actionButton("Instant Reset", function() F.instaReset() end)
F.actionButton("Small Speed", F.smallSpeed.Run, "act_small_speed", function()
    return F.smallSpeed.active and "Small Speed..." or "Small Speed"
end)
function F.rejoin()
    if game.PrivateServerId == "" and #Players:GetPlayers() > 1 then
        local failed
        failed = TeleportService.TeleportInitFailed:Connect(function(p)
            if p ~= LP then return end
            failed:Disconnect()
            LP:Kick("Rejoining...")
            TeleportService:Teleport(game.PlaceId, LP)
        end)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    else
        LP:Kick("Rejoining...")
        TeleportService:Teleport(game.PlaceId, LP)
    end
end
F.actionButton("Rejoin", function() TeleportService:Teleport(game.PlaceId, LP) end)
F.actionButton("Leave", function()
    if not pcall(function() game:Shutdown() end) then LP:Kick("Left the game (FUNHUB)") end
end)
F.actionButton("Ragdoll Tech", function() F.selfRagdoll(0.25) end)
F.actionButton("Flash + Invis", function()
    local used = false
    for _, name in ipairs({"Flash Teleport", "Flash", "FlashTeleport"}) do
        if F.equipUse(name) then used = true break end
    end
    if used then
        task.wait()
        if FUNHUB_ALIVE() and not F.equipUse("Invisibility Cloak") then
            F.actionNotice("Flash + Invis", "Flash used; Invisibility Cloak is not ready")
        end
    else
        F.actionNotice("Flash + Invis", "Flash is not ready; check your tools or wait for the current action")
    end
end)
do
    local _, refresh = F.actionButton("Carpet Speed: OFF", function()
        FUNHUBFx.carpet = not FUNHUBFx.carpet
        HubConfig.carpetSpeedEnabled = FUNHUBFx.carpet
        saveHubConfig()
    end, "carpet", function()
        return "Carpet Speed: " .. (FUNHUBFx.carpet and "ON" or "OFF")
    end)
    F.actionsCarpet = function() pcall(refresh) end
end
F.actionButton("AP Semi", function()
    local t = F.nearestPlayer()
    if t then F.spamCmds(U.get("spam1Cmds", F.SPAM1_DEF), t, "Semi") end
end, "act_spam_1")
F.actionButton("AP Full", function()
    local t = F.nearestPlayer()
    if t then F.spamCmds(U.get("spam2Cmds", F.SPAM2_DEF), t, "Full") end
end, "act_spam_2")

do
    local pg = PAGES.Misc
    F.quickGrabControls(pg)
    local c = U.card(pg)
    U.toggle(c, "Actions", { get = function() return ACT.Visible end, set = function(v) U.showWindow(ACT, v, "actions") end,
        dots = function() U.showWindow(ACT, not U.windowOpen(ACT), "actions") end })
    U.toggle(c, "ESP Look", { get = function() return espLookWin.f.Visible end, set = function(v) U.showWindow(espLookWin.f, v) end,
        dots = function() U.openSub(espLookWin) end })
    c = U.card(pg, "MISC")
    U.keyRow(c, "Menu Keybind", "menu", U.toggleMain)
    U.keyRow(c, "Hide Keybind", "hide", function() gui.Enabled = not gui.Enabled end)
    local fontNames = {}
    for _, f in ipairs(FONTS) do fontNames[#fontNames + 1] = f[1] end
    U.drop(c, "GUI Theme", { "Funhub 5.5", "Funhub 1.4 GUI", "Aurora Hub", "og funhub" }, {
        get = function() return AC.guiTheme or "Funhub 5.5" end,
        set = function(v) U.applyTheme(v) end })
    U.button(c, "Theme Colors", function() U.openThemeColor("WIN") end)
    U.drop(c, "UI Font", fontNames, { get = function() return U.get("font", "Gotham") end, set = function(v) U.set("font", v) U.setFont(v) end })
    U.slider(c, "GUI Transparency (%)", 0, 90, 1, function() return U.get("guiT", 0) end, function(v) U.set("guiT", v) U.applyTransparency() end)
    U.drop(c, "Scale Target", { "All UI", "Main Menu", "Autograb", "Actions", "Admin Spammer", "Leave Timer", "Watermark" },
        { get = function() return U.get("uiScaleTarget", "All UI") end, set = function(v) U.set("uiScaleTarget", v) end })
    U.slider(c, "UI Scale (%)", 50, 150, 5, U.getSelectedScale, U.setSelectedScale)
    U.button(c, "Reset UI Scales", function()
        AC.uiScalePercent, AC.uiPanelScales = 100, {}
        U.applyPanelScales() saveHubConfig()
    end)
    U.drop(c, "Fly Tool", { "Auto", "Flying Carpet", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh" },
        { get = function() return HubConfig.flyTool or "Auto" end, set = function(v) HubConfig.flyTool = v saveHubConfig() end })
    U.toggle(c, "Anti Logger", acOpt("antiLogger", false, function(v) if F.antiLogger then F.antiLogger(v) end end))
    U.toggle(c, "Hide AP Icon", chipOpt("hideApIconEnabled"))
    U.toggle(c, "FPS Optimizer", chipOpt("fpsOptimizerEnabled"))
    U.toggle(c, "Region Trade Block", { get = function() return U.get("tradeBlock", false) end,
        set = function(v) F.setTradeBlock("tradeBlock", v) end, dots = function(r) U.openPop(rtbPop, r) end })
    U.toggle(c, "Trading Plaza Block", { get = function() return U.get("plazaBlock", false) end,
        set = function(v) F.setTradeBlock("plazaBlock", v) end, dots = function(r) U.openPop(tpbPop, r) end })
    U.toggle(c, "Region Trade Block V2", { get = function() return U.get("tradeBlockV2", false) end,
        set = function(v) F.setTradeBlock("tradeBlockV2", v) end, dots = function(r) U.openPop(rtb2Pop, r) end })
    U.button(c, "Reset Config", function() F.resetConfig() end)
    U.button(c, "Panic (Unload Hub)", function() F.panic() end)
end

local PROFILE_FILE = "FUNHUB_Profiles.json"
pcall(function()
    if isfile and readfile and writefile and not isfile(PROFILE_FILE) and isfile("AURORA_REMAKE_Profiles.json") then
        writefile(PROFILE_FILE, readfile("AURORA_REMAKE_Profiles.json"))
    end
end)
local PROF = { active = "Default", autoload = "Default", list = {}, gallery = {} }
pcall(function()
    if isfile and isfile(PROFILE_FILE) then
        local d = HttpService:JSONDecode(readfile(PROFILE_FILE))
        if type(d) == "table" then for k, v in pairs(d) do PROF[k] = v end end
    end
end)
if type(PROF.list) ~= "table" then PROF.list = {} end
if type(PROF.gallery) ~= "table" then PROF.gallery = {} end
local function saveProfiles() pcall(function() writefile(PROFILE_FILE, HttpService:JSONEncode(PROF)) end) end
function F.snapshot()
    local s = HttpService:JSONDecode(HttpService:JSONEncode(HubConfig))
    s.positions = nil
    if type(s.funhub) == "table" then
        s.funhub.pos = nil s.funhub.size = nil s.funhub.themeLayouts = nil
    end
    return s
end
function F.applySnapshot(s)
    if type(s) ~= "table" then return false end
    F.grappleSemi.Cancel("Profile changed")
    F.smallSpeed.Cancel()
    F.quickGrab.SetEnabled(false)
    -- Older profiles omit Base Quick Grab; preserve the current saved value.
    local settings = type(s.funhub) == "table" and s.funhub or s.aurora
    local keepPos, keepHubPos, keepSize = HubConfig.positions, AC.pos, AC.size
    for k, v in pairs(s) do
        if k ~= "funhub" and k ~= "aurora" and k ~= "positions" and k ~= "quickGrabEnabled" then
            if CHIPS[k] and type(v) == "boolean" then F.setCfg(k, v) else HubConfig[k] = v end
        end
    end
    if type(settings) == "table" then
        for k, v in pairs(settings) do
            if k ~= "pos" and k ~= "size" and k ~= "themeLayouts" then AC[k] = v end
        end
        if settings.autoGrab == nil and type(settings.autoNearest) == "boolean" then AC.autoGrab = settings.autoNearest end
    end
    AC.keys = type(settings) == "table" and type(settings.keys) == "table" and table.clone(settings.keys) or {}
    AC.keybindSchema = type(settings) == "table" and settings.keybindSchema or nil
    HubConfig.stealKeybind = s.stealKeybind or "None"
    if type(settings) == "table" and settings.funhubBlueV1 ~= true then
        AC.accent1, AC.accent2 = { 40, 128, 255 }, { 78, 192, 255 }
        AC.funhubBlueV1 = true
    end
    HubConfig.positions, AC.pos, AC.size = keepPos, keepHubPos, keepSize
    F.migrateSemiSettings(settings)
    currentSpeed = HubConfig.speedValue or currentSpeed
    pcall(function() for _, f in ipairs(FUNHUBUI.cfgRefresh or {}) do pcall(f) end end)
    saveHubConfig()
    F.speedSync() F.miscSync() F.semiSync()
    U.showWindow(semiWin.f, U.get("semiInstant", false))
    F.quickGrabSync() F.cameraSync() F.movementSync() F.basePlayersTick() F.autoPotionSync()
    F.autoGrabSync()
    F.tradeSync()
    if F.publicSync then F.publicSync() end
    C.A1, C.A2 = fromT(AC.accent1, C.A1), fromT(AC.accent2, C.A2)
    U.setFont(U.get("font", "Gotham"))
    U.applyTransparency()
    U.applyTheme(AC.guiTheme or "Funhub 5.5", true)
    U.applyWindowSettings()
    U.setMainOpen(U.get("mainOpen", true))
    U.showWindow(ACT, U.get("actions", false), "actions")
    if F.asShow then F.asShow(U.get("adminSpamOpen", false)) end
    if F.cdShow then F.cdShow(U.get("cooldownHud", false)) end
    if F.qpShow then F.qpShow(U.get("quickPanelOpen", false)) end
    if F.baseHud then F.baseHud() end
    return true
end
function F.profileNames()
    local t = {}
    for n in pairs(PROF.list) do t[#t + 1] = n end
    if #t == 0 then t = { "Default" } end
    table.sort(t)
    return t
end
function F.encode(s)
    local json = HttpService:JSONEncode(s)
    local ok, b = pcall(function() return crypt.base64encode(json) end)
    if ok and type(b) == "string" then return "FH01:" .. b end
    ok, b = pcall(function() return base64_encode(json) end)
    if ok and type(b) == "string" then return "FH01:" .. b end
    return "FH00:" .. json
end
function F.decode(code)
    code = tostring(code or ""):gsub("%s", "")
    local body
    if code:sub(1, 5) == "FH01:" or code:sub(1, 5) == "ICP1:" then
        local ok, j = pcall(function() return crypt.base64decode(code:sub(6)) end)
        if not ok then ok, j = pcall(function() return base64_decode(code:sub(6)) end) end
        body = ok and j or nil
    elseif code:sub(1, 5) == "FH00:" or code:sub(1, 5) == "ICP0:" then
        body = code:sub(6)
    end
    if not body then return nil end
    local ok, t = pcall(function() return HttpService:JSONDecode(body) end)
    return ok and t or nil
end
local exploreHolder
function F.renderExplore()
    if not exploreHolder then return end
    for _, ch in ipairs(exploreHolder:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    local items = {}
    for _, g in ipairs(PROF.gallery) do items[#items + 1] = g end
    for _, n in ipairs(F.profileNames()) do
        if #items >= 5 then break end
        items[#items + 1] = { name = n, data = PROF.list[n], likes = 0, dislikes = 0, local_ = true }
    end
    for i = 1, math.min(#items, 5) do
        local it = items[i]
        local f = new("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = C.ELEM, BorderSizePixel = 0, LayoutOrder = i }, exploreHolder)
        U.round(f, 10) U.stroke(f, 1)
        local n = U.text("TextLabel", f, "#" .. i, 12, WB, C.DIM)
        n.Position = UDim2.fromOffset(11, 7) n.Size = UDim2.fromOffset(22, 16)
        local nm = U.text("TextLabel", f, tostring(it.name), 13, WB, C.TEXT)
        nm.Position = UDim2.fromOffset(33, 7) nm.Size = UDim2.new(1, -44, 0, 16) nm.TextTruncate = Enum.TextTruncate.AtEnd
        local function small(text, pos, w, fn)
            local b = U.text("TextButton", f, text, 12, WM, C.DIM, Enum.TextXAlignment.Center)
            b.BackgroundTransparency = 0 b.BackgroundColor3 = C.CARD
            b.AnchorPoint = Vector2.new(pos.X.Scale, 0)
            b.Position = pos b.Size = UDim2.fromOffset(w, 18)
            U.round(b, 10)
            b.MouseButton1Click:Connect(function() pcall(fn, b) end)
            return b
        end
        small("♥ " .. tostring(it.likes or 0), UDim2.new(0, 11, 1, -23), 52, function(b) it.likes = (it.likes or 0) + 1 b.Text = "♥ " .. it.likes saveProfiles() end)
        small("👎 " .. tostring(it.dislikes or 0), UDim2.new(0, 67, 1, -23), 52, function(b) it.dislikes = (it.dislikes or 0) + 1 b.Text = "👎 " .. it.dislikes saveProfiles() end)
        small("Import", UDim2.new(1, -11, 1, -23), 60, function()
            local d = it.data or (it.code and F.decode(it.code))
            if F.applySnapshot(d) then U.notify("Configs", "Imported " .. tostring(it.name)) else U.notify("Configs", "Nothing to import") end
        end)
    end
end
do
    local pg = PAGES.Configs
    local c = U.card(pg, "PROFILES")
    U.drop(c, "Active Config", F.profileNames, { get = function() return PROF.active end, set = function(v) PROF.active = v saveProfiles() end })
    U.button(c, "Load", function()
        local d = PROF.list[PROF.active]
        if d and F.applySnapshot(d) then U.notify("Configs", "Loaded " .. PROF.active) else U.notify("Configs", "'" .. PROF.active .. "' has nothing saved yet") end
    end)
    U.button(c, "Save Current", function()
        PROF.list[PROF.active] = F.snapshot()
        saveProfiles()
        F.renderExplore()
        U.notify("Configs", "Saved " .. PROF.active)
    end)
    U.toggle(c, "Manage", { get = function() return manageWin.f.Visible end, set = function(v) U.showWindow(manageWin.f, v) end,
        dots = function() U.openSub(manageWin) end })
    U.toggle(c, "Share & Import", { get = function() return shareWin.f.Visible end, set = function(v) U.showWindow(shareWin.f, v) end,
        dots = function(r) U.openPop(shareWin, r) end })
    c = U.card(pg, "EXPLORE")
    exploreHolder = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nxt() }, c)
    U.list(exploreHolder, 7)
    F.renderExplore()
end
do
    local nameBox = U.input(manageWin.card, "Name", "config name", "")
    local function nm() local t = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "") return t end
    U.button(manageWin.card, "Create New", function()
        local n = nm()
        if n == "" then U.notify("Configs", "Type a name first") return end
        local base, k = n, 2
        while PROF.list[n] do n = base .. " (" .. k .. ")" k = k + 1 end
        PROF.list[n] = F.snapshot()
        PROF.active = n
        saveProfiles()
        for _, f in ipairs(R.rows) do pcall(f) end
        F.renderExplore()
        U.notify("Configs", "Created " .. n)
    end)
    U.button(manageWin.card, "Rename Active", function()
        local n = nm()
        if n == "" or PROF.list[n] then U.notify("Configs", "Pick a new, unused name") return end
        PROF.list[n] = PROF.list[PROF.active] or F.snapshot()
        PROF.list[PROF.active] = nil
        if PROF.autoload == PROF.active then PROF.autoload = n end
        PROF.active = n
        saveProfiles()
        for _, f in ipairs(R.rows) do pcall(f) end
        F.renderExplore()
    end)
    local auto
    auto = U.button(manageWin.card, "Autoload: " .. tostring(PROF.autoload), function(l)
        PROF.autoload = PROF.autoload == PROF.active and "None" or PROF.active
        saveProfiles()
        l.Text = "Autoload: " .. tostring(PROF.autoload)
    end)
    U.button(manageWin.card, "Delete Active", function()
        PROF.list[PROF.active] = nil
        if PROF.autoload == PROF.active then PROF.autoload = "None" auto.Text = "Autoload: None" end
        PROF.active = F.profileNames()[1]
        saveProfiles()
        for _, f in ipairs(R.rows) do pcall(f) end
        F.renderExplore()
    end)
end
do
    local codeBox
    U.button(shareWin.body, "Get Share Code", function()
        local code = F.encode(F.snapshot())
        if setclipboard then setclipboard(code) U.notify("Share & Import", "Share code copied to clipboard") end
        if codeBox then codeBox.Text = code end
    end)
    U.button(shareWin.body, "Post to Gallery", function()
        table.insert(PROF.gallery, 1, { name = PROF.active, data = F.snapshot(), likes = 0, dislikes = 0 })
        while #PROF.gallery > 5 do table.remove(PROF.gallery) end
        saveProfiles()
        F.renderExplore()
        U.notify("Share & Import", "Posted " .. PROF.active .. " to Explore")
    end)
    codeBox = U.input(shareWin.body, "Import Code", "paste code", "")
    U.button(shareWin.body, "Import From Code", function()
        local d = F.decode(codeBox.Text)
        if d and F.applySnapshot(d) then U.notify("Share & Import", "Config imported") else U.notify("Share & Import", "That code isn't valid") end
    end)
end

local PILL = new("Frame", { Position = UDim2.fromOffset(16, 64), Size = UDim2.fromOffset(378, 48), BackgroundTransparency = 1 }, root)
U.loadPos("pill", PILL)
local statsPanel
if IsMobile then AC.statsOpen = false end -- always start with the compact badge on touch devices
function F.setStatsOpen(v)
    statsPanel.Visible = v == true and U.get("performanceHud", true) == true
    U.set("statsOpen", statsPanel.Visible)
    if F.layoutStats then F.layoutStats() end
end
function F.setPerformanceHud(v)
    U.set("performanceHud", v == true)
    if not v then F.setStatsOpen(false) end
    if U.themeExtras then U.themeExtras() end
end
function F.layoutStats()
    if not statsPanel then return end
    local vp = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
    local zoom = math.max(0.1, math.min(1, (vp.X - 16) / 320, (vp.Y - 16) / 180))
    if IsMobile then zoom = math.min(zoom, vp.Y * 0.45 / 180) end
    statsPanel.FHPanelScale.Scale = zoom / uiScale.Scale
    statsPanel.Size = UDim2.fromOffset(320, 180)
    local width, height = 320 * zoom, 180 * zoom
    local x, y = (vp.X - width) * 0.5, IsMobile and 60 or 110
    if not IsMobile then
        local host = F.themeWatermark and F.themeWatermark.Visible and F.themeWatermark or PILL
        x, y = host.AbsolutePosition.X - root.AbsolutePosition.X,
            host.AbsolutePosition.Y - root.AbsolutePosition.Y + host.AbsoluteSize.Y + 6
    end
    x = math.clamp(x, 8, math.max(8, vp.X - width - 8))
    y = math.clamp(y, 8, math.max(8, vp.Y - height - 8))
    statsPanel.Position = UDim2.fromOffset(x / uiScale.Scale, y / uiScale.Scale)
end
do
    local logo = new("Frame", { Size = UDim2.fromOffset(48, 48), BackgroundColor3 = C.CARD, BackgroundTransparency = 0.06, BorderSizePixel = 0 }, PILL)
    U.round(logo, 18) U.stroke(logo, 1.4)
    R.wins[#R.wins + 1] = { f = logo, base = 0.06 }
    local lt = U.text("TextLabel", logo, "FH", 18, WB, C.WHITE, Enum.TextXAlignment.Center)
    lt.Size = UDim2.fromScale(1, 1)
    U.tgrad(lt)
    local info = new("Frame", { Position = UDim2.fromOffset(53, 0), Size = UDim2.new(1, -53, 0, 48), BackgroundColor3 = C.CARD,
        BackgroundTransparency = 0.06, BorderSizePixel = 0 }, PILL)
    U.round(info, 20) U.stroke(info, 1.4)
    R.wins[#R.wins + 1] = { f = info, base = 0.06 }
    local t = U.text("TextLabel", info, "FUNHUB", 16, WB, C.WHITE)
    t.Position = UDim2.fromOffset(13, 7) t.Size = UDim2.fromOffset(92, 21)
    U.tgrad(t)
    local v = U.text("TextLabel", info, "v1.5.7", 10, WM, C.DIM)
    v.Position = UDim2.fromOffset(13, 28) v.Size = UDim2.fromOffset(78, 13)
    local stats = new("Frame", { Position = UDim2.fromOffset(108, 0), Size = UDim2.new(1, -112, 1, 0), BackgroundTransparency = 1 }, info)
    local function cell(x)
        local b = new("TextButton", { Position = UDim2.fromScale(x, 0), Size = UDim2.fromScale(0.5, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, stats)
        new("Frame", { Position = UDim2.new(0, 0, 0.3, 0), Size = UDim2.new(0, 1, 0.4, 0), BackgroundColor3 = C.SEP, BackgroundTransparency = 0.5, BorderSizePixel = 0 }, b)
        local icon = new("Frame", { Position = UDim2.new(0, 8, 0.5, -8), Size = UDim2.fromOffset(17, 17), BackgroundTransparency = 1 }, b)
        local l = U.text("TextLabel", b, "--", 12, WB, C.GOOD)
        l.Position = UDim2.fromOffset(30, 0) l.Size = UDim2.new(1, -31, 1, 0)
        return b, icon, l
    end
    local fb, fIcon, fLbl = cell(0)
    local pb, pIcon, pLbl = cell(0.5)
    local mon = new("Frame", { Position = UDim2.fromOffset(1, 2), Size = UDim2.fromOffset(14, 9), BackgroundTransparency = 1 }, fIcon)
    U.round(mon, 1)
    local ms = new("UIStroke", { Color = C.A1, Thickness = 1.4 }, mon)
    for _, s in ipairs({ { 8, 14, 7 }, { 8, 13, 4 } }) do
        local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset(s[1], s[2]), Size = UDim2.fromOffset(s[3], 1),
            BackgroundColor3 = C.A1, BorderSizePixel = 0 }, fIcon)
        R.bg1[#R.bg1 + 1] = f
    end
    for _, s in ipairs({ { 3, 12, 5 }, { 8, 10, 9 }, { 13, 8, 14 } }) do
        local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset(s[1], s[2]), Size = UDim2.fromOffset(s[3], 1),
            BackgroundColor3 = C.A2, BorderSizePixel = 0 }, pIcon)
        R.bg2[#R.bg2 + 1] = f
    end
    F.statsLabels = { fps = fLbl, ping = pLbl, monStroke = ms }

    statsPanel = new("Frame", { Size = UDim2.fromOffset(320, 180), BackgroundColor3 = C.WIN,
        BackgroundTransparency = 0.06, BorderSizePixel = 0, ZIndex = 40,
        Visible = U.get("performanceHud", true) and U.get("statsOpen", false), ClipsDescendants = true }, root)
    new("UIScale", { Name = "FHPanelScale" }, statsPanel)
    local heading = U.text("TextLabel", statsPanel, "Performance", 13, WB, C.TEXT)
    heading.Position, heading.Size = UDim2.fromOffset(12, 4), UDim2.new(1, -52, 0, 28)
    local close = U.text("TextButton", statsPanel, "×", 22, WB, C.DIM, Enum.TextXAlignment.Center)
    close.Position, close.Size = UDim2.new(1, -36, 0, 0), UDim2.fromOffset(36, 36)
    close.MouseButton1Click:Connect(function() F.setStatsOpen(false) end)
    U.round(statsPanel, 18) U.stroke(statsPanel, 1.4)
    R.wins[#R.wins + 1] = { f = statsPanel, base = 0.06 }
    local inner = new("Frame", { Position = UDim2.fromOffset(12, 36), Size = UDim2.new(1, -24, 1, -48), BackgroundTransparency = 1 }, statsPanel)
    local graph = new("Frame", { Position = UDim2.fromOffset(0, 58), Size = UDim2.new(1, -4, 1, -58), BackgroundTransparency = 1 }, inner)
    local N = IsMobile and 16 or 38
    local function column(x, title, accentKey)
        local col = new("Frame", { Position = UDim2.new(x, x > 0 and 3 or 0, 0, 0), Size = UDim2.new(0.5, -3, 0, 52), BackgroundTransparency = 1 }, inner)
        local h = U.text("TextLabel", col, title, 11, WB, C[accentKey])
        h.Size = UDim2.new(1, 0, 0, 15)
        R[accentKey == "A1" and "tx1" or "tx2"][#R[accentKey == "A1" and "tx1" or "tx2"] + 1] = h
        local lo = U.text("TextLabel", col, "--", 10, WM, C[accentKey])
        lo.Position = UDim2.fromOffset(16, 19) lo.Size = UDim2.new(0.5, -16, 0, 17)
        local hi = U.text("TextLabel", col, "--", 10, WM, C[accentKey])
        hi.Position = UDim2.new(0.5, 16, 0, 19) hi.Size = UDim2.new(0.5, -16, 0, 17)
        for _, l in ipairs({ lo, hi }) do R[accentKey == "A1" and "tx1" or "tx2"][#R[accentKey == "A1" and "tx1" or "tx2"] + 1] = l end
        for k, ax in ipairs({ 0, 0.5 }) do
            local ic = new("Frame", { Position = UDim2.new(ax, 0, 0, 22), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1 }, col)
            local spec = k == 1 and { { 6, 6, 8 }, { 7, 7, 5 }, { 4, 7, 5 } } or { { 4, 4, 5 }, { 7, 4, 5 }, { 6, 6, 8 } }
            for _, s in ipairs(spec) do
                local f = new("Frame", { Position = UDim2.fromOffset(s[1] - math.floor(s[3] / 2), s[2]), Size = UDim2.fromOffset(s[3], 1),
                    BackgroundColor3 = C[accentKey], BorderSizePixel = 0 }, ic)
                R[accentKey == "A1" and "bg1" or "bg2"][#R[accentKey == "A1" and "bg1" or "bg2"] + 1] = f
            end
        end
        local st = U.text("TextLabel", col, "Waiting for samples", 9, WM, C.DIM)
        st.Position = UDim2.fromOffset(0, 38) st.Size = UDim2.new(1, 0, 0, 12)
        local bars = {}
        for i = 1, N do
            local b = new("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(x + (i - 1) / N * 0.5, 0, 1, 0), Size = UDim2.new(0.5 / N, -1, 0, 0),
                BackgroundColor3 = C[accentKey], BorderSizePixel = 0 }, graph)
            U.round(b, 1)
            R[accentKey == "A1" and "bg1" or "bg2"][#R[accentKey == "A1" and "bg1" or "bg2"] + 1] = b
            bars[i] = b
        end
        return { lo = lo, hi = hi, st = st, bars = bars, samples = {} }
    end
    F.fpsCol = column(0, "FPS", "A1")
    F.pingCol = column(0.5, "Data ping", "A2")
    local toggleBtn = new("TextButton", { Size = UDim2.fromOffset(145, 48), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 3 }, PILL)
    U.drag(toggleBtn, PILL, "pill", function()
        F.setStatsOpen(not statsPanel.Visible)
    end)
    for _, b in ipairs({ fb, pb }) do
        b.MouseButton1Click:Connect(function()
            F.setStatsOpen(not statsPanel.Visible)
        end)
    end
end

local MENU = new("ImageButton", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 0), Size = UDim2.fromOffset(44, 44),
    BackgroundColor3 = C.CARD, BackgroundTransparency = 0.5, BorderSizePixel = 0, Image = "", AutoButtonColor = false }, root)
U.round(MENU, 0.5, true) U.stroke(MENU, 1.4)
U.loadPos("menuBtn", MENU)
do
    local l = U.text("TextLabel", MENU, "FH", 15, WB, C.WHITE, Enum.TextXAlignment.Center)
    l.Size = UDim2.fromScale(1, 1)
    U.tgrad(l)
    U.drag(MENU, MENU, "menuBtn", U.toggleMain)
end

do
    local watermark = U.panel(root, UDim2.fromOffset(354, 80), UDim2.new(0.5, 0, 0, 14), Vector2.new(0.5, 0), 0.2, 10)
    U.registerScale(watermark, "watermark")
    watermark.Active = false
    AC.pos.funhubWatermark = nil
    local title = U.text("TextLabel", watermark, "FUNHUB V1.4", 26, Enum.FontWeight.Heavy, C.WHITE, Enum.TextXAlignment.Center)
    title.Position, title.Size = UDim2.fromOffset(10, 6), UDim2.new(1, -20, 0, 28)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.A1),
        ColorSequenceKeypoint.new(0.5, C.A2),
        ColorSequenceKeypoint.new(1, C.A1)
    })
    grad.Parent = title
    if not IsMobile then task.spawn(function()
        while FUNHUB_ALIVE() and title.Parent do
            if watermark.Visible and grad.Enabled then grad.Offset = Vector2.new((os.clock() * 0.3) % 2 - 1, 0) end
            task.wait(0.08)
        end
    end) end
    local subtitle = U.text("TextLabel", watermark, "discord.gg/funhub", 14, WB, C.A1, Enum.TextXAlignment.Center)
    subtitle.Position, subtitle.Size = UDim2.fromOffset(10, 35), UDim2.new(1, -20, 0, 18)
    local sgrad = Instance.new("UIGradient")
    sgrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.A2),
        ColorSequenceKeypoint.new(1, C.A1)
    })
    sgrad.Parent = subtitle
    if not IsMobile then task.spawn(function()
        while FUNHUB_ALIVE() and subtitle.Parent do
            if watermark.Visible and sgrad.Enabled then sgrad.Offset = Vector2.new((os.clock() * 0.2) % 2 - 1, 0) end
            task.wait(0.08)
        end
    end) end
    local stats = U.text("TextLabel", watermark, "FPS: --   PING: --", 15, WB, C.TEXT, Enum.TextXAlignment.Center)
    stats.Position, stats.Size = UDim2.fromOffset(10, 55), UDim2.new(1, -20, 0, 19)
    local credits = U.text("TextLabel", watermark, "SheeshV2 | DatShawn | Headless", 13, WB, C.DIM, Enum.TextXAlignment.Center)
    credits.Size, credits.Visible = UDim2.new(1, -20, 0, 18), false
    U.hit(watermark, 3).MouseButton1Click:Connect(function()
        if FUNHUBUI.bindingInput or FUNHUBKeys.blocked() then return end
        F.setStatsOpen(not statsPanel.Visible)
    end)
    local hide = U.text("TextButton", watermark, "×", 20, WB, C.DIM, Enum.TextXAlignment.Center)
    hide.ZIndex, hide.Visible = 4, IsMobile
    hide.Position, hide.Size = UDim2.new(1, -36, 0, 0), UDim2.fromOffset(36, 44)
    hide.MouseButton1Click:Connect(function() F.setPerformanceHud(false) end)
    F.themeWatermark, F.themeStats = watermark, stats
    function U.pinWatermark()
        local og = U.activeTheme == "og funhub"
        local width, height = og and (IsMobile and 280 or 340) or 354, og and (IsMobile and 80 or 110) or 80
        if IsMobile then
            local saved = type(AC.uiPanelScales) == "table" and AC.uiPanelScales.watermark or 100
            R.panelScales.watermark.scale.Scale = math.clamp(U.scalePercent(saved) / 100, 0.85, 1) / uiScale.Scale
            width, height = 220, 44
        end
        watermark.AnchorPoint = Vector2.new(0.5, 0)
        watermark.Position = UDim2.new(0.5, 0, 0, IsMobile and (8 / uiScale.Scale) or (og and 50 or 14))
        watermark.Size = UDim2.fromOffset(math.min(width, math.max(80, (root.Size.X.Offset - 16 / uiScale.Scale) / U.panelScale(watermark))), height)
        F.layoutStats()
    end
    U.pinWatermark()
    local menuLabel = MENU:FindFirstChildWhichIsA("TextLabel")
    U.themeExtras = function()
        local compact = U.compactTheme()
        local og = U.activeTheme == "og funhub"
        local enabled = U.get("performanceHud", true)
        PILL.Visible = enabled and not IsMobile and not compact and not og
        watermark.Visible = enabled and (IsMobile or compact or og)
        if not enabled then statsPanel.Visible = false end
        title.Text, title.TextSize = U.activeTheme == "Funhub 5.5" and "FUNHUB 5.5" or og and "Fun Hub V1.4" or "FUNHUB V1.4", og and (IsMobile and 13 or 18) or 26
        title.TextColor3, subtitle.TextColor3 = C.WHITE, og and C.DIM or C.A1
        grad.Color, sgrad.Color = U.seq3(), ColorSequence.new(C.A2, C.A1)
        grad.Enabled, sgrad.Enabled = not og, not og
        credits.Visible, credits.TextSize = og, IsMobile and 9 or 13
        credits.Position = UDim2.fromOffset(10, IsMobile and 26 or 36)
        subtitle.Position = UDim2.fromOffset(10, og and (IsMobile and 43 or 56) or 35)
        subtitle.TextSize = og and IsMobile and 11 or 14
        stats.Position = UDim2.fromOffset(10, og and (IsMobile and 60 or 78) or 55)
        stats.TextSize = og and (IsMobile and 12 or 14) or 15
        subtitle.Visible = not IsMobile
        if IsMobile then
            title.TextSize, title.Position, title.Size = 12, UDim2.fromOffset(8, 3), UDim2.new(1, -44, 0, 16)
            stats.TextSize, stats.Position, stats.Size = 12, UDim2.fromOffset(8, 21), UDim2.new(1, -44, 0, 17)
            grad.Enabled, sgrad.Enabled, credits.Visible = false, false, false
        end
        U.pinWatermark()
        MENU.Size = compact and UDim2.fromOffset(60, 34) or UDim2.fromOffset(44, 44)
        MENU:FindFirstChildOfClass("UICorner").CornerRadius = compact and UDim.new(0, 18) or UDim.new(0.5, 0)
        if menuLabel then menuLabel.Text = compact and "Fun" or "FH" end
    end
end

local BAR = new("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0.78, 10), Size = UDim2.fromOffset(280, 46),
    BackgroundColor3 = C.CARD, BorderSizePixel = 0, Active = true }, root)
U.round(BAR, 10) U.stroke(BAR, 1.2)
U.registerScale(BAR, "bar")
BAR.Visible = false
R.wins[#R.wins + 1] = { f = BAR, base = 0 }
U.loadPos("bar", BAR)
if not AC.fullGrabLine then
    AC.size = type(AC.size) == "table" and AC.size or {}
    local previous = type(AC.size.bar) == "table" and tonumber(AC.size.bar[1]) or 280
    AC.size.bar, AC.fullGrabLine = { math.max(280, previous or 280), 46 }, true
end
do
    local track = new("Frame", { Position = UDim2.fromOffset(5, 5), Size = UDim2.new(1, -10, 1, -10),
        BackgroundColor3 = C.ELEM, BorderSizePixel = 0, ClipsDescendants = true }, BAR)
    U.round(track, 7)
    local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.A1,
        BackgroundTransparency = 0.2, BorderSizePixel = 0 }, track)
    U.round(fill, 7)
    R.fg[#R.fg + 1] = new("UIGradient", { Color = U.seq2() }, fill)
    R.bg1[#R.bg1 + 1] = fill
    local title = U.text("TextLabel", track, "Autograb", 12, WB, C.TEXT)
    title.Position, title.Size, title.ZIndex = UDim2.fromOffset(9, 2), UDim2.new(1, -68, 0, 16), 2
    local pct = U.text("TextLabel", track, "0%", 12, WB, C.TEXT, Enum.TextXAlignment.Right)
    pct.Position, pct.Size, pct.ZIndex = UDim2.new(1, -56, 0, 2), UDim2.fromOffset(46, 16), 2
    local detail = U.text("TextLabel", track, "Waiting for target", 10, WR, C.TEXT)
    detail.Position, detail.Size, detail.ZIndex = UDim2.fromOffset(9, 18), UDim2.new(1, -18, 1, -18), 2
    detail.TextTruncate = Enum.TextTruncate.AtEnd
    U.drag(BAR, BAR, "bar")
    U.resizer(BAR, 220, 46, "bar", 12)
    F.bar = { title = title, fill = fill, pct = pct, detail = detail, track = track }
end
function F.grabProgressVisible()
    if U.get("autoGrab", false) or U.get("autoBest", false) or U.get("autoPriority", false) then return true end
    local progress = FUNHUBHold.progress or {}
    local semi = progress.contexts and progress.contexts["Semi TP"]
    local result = progress.result
    return _G.FUNHUB_SemiTP_Busy == true or FUNHUB.debounce == true
        or (semi ~= nil and not semi.cancelled)
        or (progress.pendingSemi ~= nil and os.clock() < progress.pendingSemi.expires)
        or (result ~= nil and result.source == "Semi TP" and os.clock() - result.at < 1.5)
end
function F.renderGrabProgress(ratio, source, label, phase, confirmed)
    BAR.Visible = F.grabProgressVisible() == true
    if not BAR.Visible then return end
    ratio = math.clamp(tonumber(ratio) or 0, 0, 1)
    F.bar.fill.Size = UDim2.fromScale(ratio, 1)
    F.bar.title.Text, F.bar.pct.Text = "Autograb", tostring(math.floor(ratio * 100 + 0.5)) .. "%"
    F.bar.title.TextColor3 = confirmed and C.GOOD or C.TEXT
    local target = label and label ~= "" and (label .. " · ") or ""
    F.bar.detail.Text = (source == "Semi TP" and "Semi TP · " or "") .. target .. (phase or "Waiting for target")
end

local ALLOW = U.text("TextButton", root, "Allow / Disallow", 13, WB, C.TEXT, Enum.TextXAlignment.Center)
ALLOW.AnchorPoint = Vector2.new(0.5, 0.5)
ALLOW.Position = UDim2.new(0.5, 0, 0.9, 0)
ALLOW.Size = UDim2.fromOffset(150, 36)
ALLOW.BackgroundTransparency = 0
ALLOW.BackgroundColor3 = C.CARD
U.round(ALLOW, 10) U.stroke(ALLOW, 1.2)
U.loadPos("allow", ALLOW)
U.drag(ALLOW, ALLOW, "allow", function()
    local _, _, hrp = F.char()
    local my = F.myPlot()
    local target, md = nil, math.huge
    for desc in pairs(FUNHUBUI.friendPrompts or {}) do
        if desc.Parent then
            local part = FUNHUBUI.promptPart(desc)
            if part and hrp and my and part:IsDescendantOf(my) then
                local d = (hrp.Position - part.Position).Magnitude
                if d < md then target, md = desc, d end
            end
        end
    end
    if target and fireproximityprompt then fireproximityprompt(target) else U.notify("Allow / Disallow", "Your base's friend panel wasn't found") end
end)

local FLOORS = new("Frame", { Position = UDim2.fromOffset(865, 40), Size = UDim2.fromOffset(190, 42), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Active = true }, root)
U.round(FLOORS, 10) U.stroke(FLOORS, 1.2)
R.wins[#R.wins + 1] = { f = FLOORS, base = 0 }
U.loadPos("floors", FLOORS)
do
    local l = U.list(FLOORS, 6, Enum.FillDirection.Horizontal)
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    U.pad(FLOORS, 6, 6)
    local grip = U.text("TextLabel", FLOORS, ":", 14, WB, C.DIM, Enum.TextXAlignment.Center)
    grip.Size = UDim2.fromOffset(10, 42)
    grip.LayoutOrder = 0
    grip.Active = true
    U.drag(grip, FLOORS, "floors")
    for n = 1, 3 do
        local b = U.text("TextButton", FLOORS, tostring(n), 17, WB, C.TEXT, Enum.TextXAlignment.Center)
        b.Size = UDim2.fromOffset(48, 34)
        b.LayoutOrder = n
        b.BackgroundTransparency = 0
        b.BackgroundColor3 = C.ELEM
        U.round(b, 8)
        b.MouseButton1Click:Connect(function()
            local _, _, hrp = F.char()
            if not hrp then return end
            local plots = Workspace:FindFirstChild("Plots")
            if not plots then U.notify("Unlock", "No plots found") return end
            local best, bestD = nil, 1e9
            for _, plot in ipairs(plots:GetChildren()) do
                if isEnemyPlot(plot) then
                    local d = (plot:GetPivot().Position - hrp.Position).Magnitude
                    if d < bestD then best, bestD = plot, d end
                end
            end
            if not best then U.notify("Unlock", "No enemy base nearby") return end
            local un = best:FindFirstChild("Unlock")
            if not un then U.notify("Unlock", "No unlock folder") return end
            local floors = {}
            for _, c in ipairs(un:GetChildren()) do
                local ub = c:FindFirstChild("UnlockBase")
                if c:IsA("BasePart") and ub and ub:IsA("ProximityPrompt") and ub.Enabled then
                    floors[#floors + 1] = { part = c, prompt = ub, y = c.Position.Y }
                end
            end
            table.sort(floors, function(a, b) return a.y < b.y end)
            local fl = floors[n]
            if not fl then U.notify("Unlock", "Floor " .. n .. " already unlocked or not found") return end
            if fireproximityprompt then
                pcall(fireproximityprompt, fl.prompt)
                if U.get("autoTPOnUnlock", false) then
                    task.delay(0.5, function()
                        if not FUNHUB.debounce and not player:GetAttribute("Stealing") then
                            task.spawn(FUNHUB.execute)
                        end
                    end)
                end
            elseif firesignal then
                pcall(firesignal, fl.prompt.Triggered, player)
            else
                U.notify("Unlock", "No prompt fire method")
            end
        end)
    end
end
function F.floors(plot)
    local spawns = {}
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    for _, pod in ipairs(pods and pods:GetChildren() or {}) do
        local sp = pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
        if sp then spawns[#spawns + 1] = sp end
    end
    table.sort(spawns, function(a, b) return a.Position.Y < b.Position.Y end)
    local floors = {}
    for _, sp in ipairs(spawns) do
        local last = floors[#floors]
        if not last or sp.Position.Y - last[1].Position.Y > 8 then floors[#floors + 1] = { sp } else last[#last + 1] = sp end
    end
    return floors
end
function F.goFloor(n)
    if F.stealing() then U.notify("Floors", "Not while carrying a brainrot") return end
    local plot = F.myPlot()
    local _, _, hrp = F.char()
    if not (plot and hrp) then return end
    local floors = F.floors(plot)
    local fl = floors[n]
    if not fl then U.notify("Floors", "Your base has no floor " .. n) return end
    local sum = Vector3.zero
    for _, sp in ipairs(fl) do sum = sum + sp.Position end
    local centre = sum / #fl
    if n == 1 and plot:FindFirstChild("Spawn") then
        hrp.CFrame = plot.Spawn.CFrame + Vector3.new(0, 4, 0)
    else
        hrp.CFrame = CFrame.new(centre + Vector3.new(0, 4, 0))
    end
end

local MYBASE = new("Frame", { Position = UDim2.fromOffset(14, 220), Size = UDim2.fromOffset(196, 56), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Active = true }, root)
U.round(MYBASE, 12) U.stroke(MYBASE, 1.2)
R.wins[#R.wins + 1] = { f = MYBASE, base = 0 }
U.loadPos("mybase", MYBASE)
U.registerScale(MYBASE, "mybase")
F.baseLeave = { left = false, rejoin = nil }
function F.baseLeaveAction()
    return U.get("baseLeaveAction", "Leave") == "Rejoin" and "Rejoin" or "Leave"
end
function F.stopBaseRejoin()
    local pending = F.baseLeave.rejoin
    F.baseLeave.rejoin = nil
    if pending and pending.failed then pending.failed:Disconnect() end
end
function F.baseTimerRejoin()
    if F.baseLeave.rejoin then return end
    local pending = { fallback = false }
    F.baseLeave.rejoin = pending
    local function tryFallback()
        if F.baseLeave.rejoin ~= pending then return end
        if not FUNHUB_ALIVE() or not F.cfg("autoRejoinEnabled") or F.baseLeaveAction() ~= "Rejoin" then
            F.stopBaseRejoin()
            return
        end
        if pending.fallback then
            F.stopBaseRejoin()
            U.notify("Leave Timer", "Rejoin failed. Turn Timer Enabled off and on to retry.", 5)
            return
        end
        pending.fallback = true
        -- Never Kick before a teleport: a failed rejoin must leave the player connected.
        local ok = pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
        if not ok then tryFallback() end
    end
    pending.failed = TeleportService.TeleportInitFailed:Connect(function(p, _, _, placeId)
        if p == LP and placeId == game.PlaceId then tryFallback() end
    end)
    if game.JobId == "" then tryFallback() return end
    local ok = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end)
    if not ok then tryFallback() end
end
R.cleanup[#R.cleanup + 1] = F.stopBaseRejoin
function F.baseLeaveSeconds()
    local n = tonumber(U.get("baseLeaveSeconds", 2))
    if not n or n ~= n or math.abs(n) == math.huge then n = 2 end
    return math.clamp(math.floor(n + 0.5), 1, 600)
end
function F.baseLeaveTick()
    if not F.cfg("autoRejoinEnabled") then
        F.baseLeave.left = false
        F.stopBaseRejoin()
        return
    end
    if F.baseLeave.left or F.baseLeave.rejoin or not FUNHUB_ALIVE() then return end
    local plot = F.quickGrab.OwnPlot()
    local _, seconds, relock = F.baseTimerRead(plot)
    -- Never leave on an unknown/open/relocking timer or another player's base.
    if not plot or not seconds or seconds <= 0 or relock or seconds > F.baseLeaveSeconds() then return end
    F.baseLeave.left = true
    if F.baseLeaveAction() == "Rejoin" then
        F.baseTimerRejoin()
    else
        pcall(function() LP:Kick("Base Auto Leave\nYour base unlocks in " .. seconds .. "s\nLeave threshold: " .. F.baseLeaveSeconds() .. "s") end)
    end
end
do
    local a = U.text("TextLabel", MYBASE, "LEAVE TIMER", 11, WB, C.DIM)
    a.Position = UDim2.fromOffset(9, 5) a.Size = UDim2.new(1, -70, 0, 14)
    local b = U.text("TextLabel", MYBASE, "WAITING FOR BASE", 17, WB, C.DIM)
    b.Position = UDim2.fromOffset(9, 22) b.Size = UDim2.new(1, -18, 0, 26)
    F.baseLbl, F.baseTitle = b, a
    local menu = U.text("TextButton", MYBASE, "⋯", 18, WB, C.DIM, Enum.TextXAlignment.Center)
    menu.Position, menu.Size = UDim2.new(1, -62, 0, 0), UDim2.fromOffset(30, 30)
    local off = U.text("TextButton", MYBASE, "×", 20, WB, C.DIM, Enum.TextXAlignment.Center)
    off.Position, off.Size = UDim2.new(1, -32, 0, 0), UDim2.fromOffset(32, 32)
    off.MouseButton1Click:Connect(function() F.setLeaveTimer(false) end)
    local popup = U.popup("Leave Timer", "baseLeave")
    F.closeBaseLeave = function()
        if U.windowOpen(popup.f) then U.showWindow(popup.f, false) end
    end
    popup.f.ZIndex = 50
    U.toggle(popup.body, "Timer Enabled", { get = function() return F.cfg("autoRejoinEnabled") end,
        set = F.setLeaveTimer })
    U.drop(popup.body, "Timer Action", { "Leave", "Rejoin" }, {
        get = F.baseLeaveAction,
        set = function(v)
            U.set("baseLeaveAction", v == "Rejoin" and "Rejoin" or "Leave")
            if not F.baseLeave.rejoin then F.baseLeave.left = false end
            if F.baseHud then F.baseHud() end
        end })
    U.slider(popup.body, "Seconds Left", 1, 600, 1, F.baseLeaveSeconds, function(v) U.set("baseLeaveSeconds", v) end)
    local hint = U.text("TextLabel", popup.body, "Leave or rejoin when your base lock reaches the selected seconds", 11, WR, C.DIM)
    hint.Size, hint.TextWrapped, hint.LayoutOrder = UDim2.new(1, 0, 0, 34), true, nxt()
    F.openBaseLeave = function()
        if FUNHUBUI.bindingInput or FUNHUBKeys.blocked() then return end
        if U.windowOpen(popup.f) then U.showWindow(popup.f, false) return end
        local pos = U.toRoot(MYBASE.AbsolutePosition)
        local width, height = root.AbsoluteSize.X / uiScale.Scale, root.AbsoluteSize.Y / uiScale.Scale
        local x = pos.X + MYBASE.AbsoluteSize.X / uiScale.Scale + 8
        if x + popup.f.Size.X.Offset > width - 4 then x = pos.X - popup.f.Size.X.Offset - 8 end
        popup.f.Position = UDim2.fromOffset(math.clamp(x, 4, math.max(4, width - popup.f.Size.X.Offset - 4)),
            math.clamp(pos.Y, 4, math.max(4, height - popup.f.Size.Y.Offset - 4)))
        U.showWindow(popup.f, true)
    end
    menu.MouseButton1Click:Connect(F.openBaseLeave)
    U.drag(MYBASE, MYBASE, "mybase", nil, F.openBaseLeave)
    U.on(MYBASE.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then F.openBaseLeave() end
    end)
    U.on(UserInputService.InputBegan, function(input)
        if not popup.f.Visible or FUNHUBUI.bindingInput or FUNHUBKeys.blocked(input) then return end
        if input.KeyCode == Enum.KeyCode.Escape then U.showWindow(popup.f, false) return end
        if input.UserInputType == MB1 or input.UserInputType == TOUCH or input.UserInputType == Enum.UserInputType.MouseButton2 then
            if not U.contains(popup.f, input.Position) and not U.contains(MYBASE, input.Position) then U.showWindow(popup.f, false) end
        end
    end)
end
F.baseHud = function()
    MYBASE.Visible = F.cfg("autoRejoinEnabled")
    local title = F.baseLeaveAction() == "Rejoin" and "REJOIN TIMER" or "LEAVE TIMER"
    F.baseTitle.Text = F.cfg("autoRejoinEnabled") and (title .. " · " .. F.baseLeaveSeconds() .. "s") or title
end
F.baseHud()

local CD = U.panel(root, UDim2.fromOffset(150, 0), UDim2.new(0, 172, 0.5, -60), nil, 0, 12, "cooldowns", 1)
CD.AutomaticSize = Enum.AutomaticSize.Y
CD.Visible = U.get("cooldownHud", false)
U.pad(CD, 8, 8, 6, 8)
U.list(CD, 2)
do
    local t = U.text("TextLabel", CD, "Cooldowns", 12, WB, C.WHITE, Enum.TextXAlignment.Center)
    t.Size = UDim2.new(1, 0, 0, 18)
    U.tgrad(t)
    U.drag(t, CD, "cooldowns")
    F.cdRows = {}
    for i, cmd in ipairs(F.CMDS) do
        local r = new("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = i }, CD)
        local n = U.text("TextLabel", r, cmd, 11, WM, C.TEXT)
        n.Size = UDim2.fromScale(0.65, 1)
        local v = U.text("TextLabel", r, "ready", 11, WB, C.GOOD, Enum.TextXAlignment.Right)
        v.Position = UDim2.fromScale(0.65, 0) v.Size = UDim2.fromScale(0.35, 1)
        F.cdRows[cmd] = v
    end
end
F.cdShow = function(v) U.showWindow(CD, v, "cooldownHud") end

local AS = U.panel(root, UDim2.fromOffset(320, 360), UDim2.new(0.5, 180, 0.5, -180), nil, 0, 16, "adminspam")
AS.Visible = U.get("adminSpamOpen", false)
do
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1 }, AS)
    local t = U.text("TextLabel", hd, "Admin Spammer", 13, WB, C.WHITE)
    t.Position = UDim2.fromOffset(11, 0) t.Size = UDim2.new(1, -40, 1, 0)
    U.tgrad(t)
    local x = U.text("TextButton", hd, "X", 12, WB, C.DIM, Enum.TextXAlignment.Center)
    x.Position = UDim2.new(1, -34, 0, 6) x.Size = UDim2.fromOffset(24, 24)
    x.MouseButton1Click:Connect(function() U.showWindow(AS, false, "adminSpamOpen") for _, f in ipairs(R.rows) do pcall(f) end end)
    U.drag(hd, AS, "adminspam")
    U.resizer(AS, 260, 200, "adminspam")
    local body = new("Frame", { Position = UDim2.fromOffset(10, 36), Size = UDim2.new(1, -20, 1, -46),
        BackgroundTransparency = 1, ClipsDescendants = true }, AS)

    local function selected(cmd, n)
        local list = U.get(n == 1 and "spam1Cmds" or "spam2Cmds", n == 1 and F.SPAM1_DEF or F.SPAM2_DEF)
        return type(list) == "table" and table.find(list, cmd) ~= nil
    end
    local function assign(cmd, n)
        local key, defaults = n == 1 and "spam1Cmds" or "spam2Cmds", n == 1 and F.SPAM1_DEF or F.SPAM2_DEF
        local old = U.get(key, defaults)
        local list = type(old) == "table" and table.clone(old) or table.clone(defaults)
        local index = table.find(list, cmd)
        if index then table.remove(list, index) else list[#list + 1] = cmd end
        U.set(key, list) -- Semi and Full may both include the same command.
    end
    local cfgBtn = U.text("TextButton", body, "Configure Commands  v", 11, WB, C.DIM, Enum.TextXAlignment.Center)
    cfgBtn.Size = UDim2.new(1, 0, 0, 28) cfgBtn.BackgroundTransparency = 0 cfgBtn.BackgroundColor3 = C.ELEM cfgBtn.LayoutOrder = 1
    U.round(cfgBtn, 8) U.stroke(cfgBtn, 1)
    local cfgList = U.scroller(body, UDim2.fromOffset(0, 34), UDim2.new(1, 0, 0, 0), 0, 3)
    cfgList.Visible = false
    for i, cmd in ipairs(F.CMDS) do
        local r = new("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = i }, cfgList)
        local l = U.text("TextLabel", r, cmd, 12, WM, C.TEXT)
        l.Position = UDim2.fromOffset(8, 0) l.Size = UDim2.new(1, -102, 1, 0)
        local bs = {}
        local function paint()
            for n, b in pairs(bs) do b.BackgroundColor3 = selected(cmd, n) and C.A1 or C.ELEM end
        end
        for n, xo in ipairs({ -50, -2 }) do
            local b = U.text("TextButton", r, n == 1 and "Semi" or "Full", 10, WB, C.TEXT, Enum.TextXAlignment.Center)
            b.AnchorPoint = Vector2.new(1, 0.5) b.Position = UDim2.new(1, xo, 0.5, 0) b.Size = UDim2.fromOffset(44, 20)
            b.BackgroundTransparency = 0
            U.round(b, 4)
            bs[n] = b
            b.MouseButton1Click:Connect(function() assign(cmd, n) paint() end)
        end
        paint()
        R.rows[#R.rows + 1] = paint
    end
    local layoutPanel = function() end
    cfgBtn.MouseButton1Click:Connect(function()
        cfgList.Visible = not cfgList.Visible
        cfgBtn.Text = cfgList.Visible and "Configure Commands  ^" or "Configure Commands  v"
        layoutPanel()
    end)
    local playerCount = U.text("TextLabel", body, "Players (0)", 11, WB, C.DIM)
    local refreshPlayers = U.text("TextButton", body, "Refresh", 11, WB, C.A2, Enum.TextXAlignment.Right)
    local plist = U.scroller(body, UDim2.fromOffset(0, 58), UDim2.new(1, 0, 1, -58), 0, 4)
    plist.Name = "FHPlayerList"
    plist.AutomaticCanvasSize = Enum.AutomaticSize.None
    local empty = U.text("TextLabel", plist, "No other players in this server", 12, WM, C.DIM, Enum.TextXAlignment.Center)
    empty.Size = UDim2.new(1, -5, 0, 36) empty.TextWrapped = true
    layoutPanel = function()
        local available = math.max(140, AS.Size.Y.Offset - 46)
        local configHeight = cfgList.Visible and math.min(#F.CMDS * 27, math.floor(available * 0.45)) or 0
        cfgList.Size = UDim2.new(1, 0, 0, configHeight)
        local y = 34 + (cfgList.Visible and (configHeight + 6) or 0)
        playerCount.Position = UDim2.fromOffset(0, y)
        playerCount.Size = UDim2.new(1, -65, 0, 20)
        refreshPlayers.Position = UDim2.new(1, -60, 0, y)
        refreshPlayers.Size = UDim2.fromOffset(55, 20)
        plist.Position = UDim2.fromOffset(0, y + 24)
        plist.Size = UDim2.new(1, 0, 1, -(y + 24))
    end
    U.on(AS:GetPropertyChangedSignal("Size"), layoutPanel)
    layoutPanel()

    -- Direct scrolling rows, as in the supplied HEX player panel.
    local joinN, joinOf, rows = 0, {}, {}
    local leaving = {}
    local function playerKey(p)
        local ok, id = pcall(function() return p.UserId end)
        return ok and tonumber(id) or nil
    end
    local localId = playerKey(LP)
    local function resizePlayers()
        local count = 0
        for _, record in pairs(rows) do if record.row.Parent == plist then count = count + 1 end end
        empty.Visible = count == 0
        playerCount.Text = "Players (" .. count .. ")"
        local height = count == 0 and 36 or count * 62 - 4
        plist.CanvasSize = UDim2.fromOffset(0, height + 4)
        if count == 0 then plist.CanvasPosition = Vector2.new(0, 0) end
    end
    local function addRow(p)
        local id = playerKey(p)
        if not id or id == localId or leaving[id] == p then return end
        if rows[id] then rows[id].player = p return end
        if not joinOf[id] then joinN = joinN + 1 joinOf[id] = joinN end
        local b = new("Frame", { Name = "FHPlayer_" .. id, Size = UDim2.new(1, -5, 0, 58),
            BackgroundColor3 = C.CARD, BorderSizePixel = 0, Active = true,
            LayoutOrder = joinOf[id], Visible = true }, plist)
        -- Register first, so a failed decoration can be retried without orphaned duplicate rows.
        local record = { row = b, player = p, ready = false }
        rows[id] = record
        U.round(b, 8) U.stroke(b, 1)
        local av = new("ImageLabel", { Size = UDim2.fromOffset(34, 34), Position = UDim2.new(0, 8, 0.5, -17),
            BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit }, b)
        U.round(av, 17)
        local dot = new("Frame", { Size = UDim2.fromOffset(9, 9), Position = UDim2.new(0, 31, 0.5, 6),
            BackgroundColor3 = rgb(110, 110, 118), BorderSizePixel = 0, ZIndex = 3 }, b)
        U.round(dot, 5)
        local n = U.text("TextLabel", b, p.DisplayName, 14, WB, C.TEXT)
        n.Position = UDim2.fromOffset(46, 3) n.Size = UDim2.new(1, -104, 0, 15) n.TextTruncate = Enum.TextTruncate.AtEnd
        local u = U.text("TextLabel", b, "@" .. p.Name, 11, WR, C.DIM)
        u.Position = UDim2.fromOffset(46, 16) u.Size = UDim2.new(1, -104, 0, 11) u.TextTruncate = Enum.TextTruncate.AtEnd
        local badge = U.text("TextLabel", b, "", 10, WB, C.A2)
        badge.Position = UDim2.fromOffset(46, 27) badge.Size = UDim2.new(1, -104, 0, 11) badge.TextTruncate = Enum.TextTruncate.AtEnd
        local jo = U.text("TextLabel", b, "Joined #" .. joinOf[id], 11, WM, C.TEXT)
        jo.Position = UDim2.fromOffset(46, 39) jo.Size = UDim2.new(1, -104, 0, 13)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = C.ELEM end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = C.CARD end)
        for mode, label in ipairs({ "Semi", "Full" }) do
            local action = U.text("TextButton", b, label, 10, WB, C.WHITE, Enum.TextXAlignment.Center)
            action.Position = UDim2.new(1, -54, 0, mode == 1 and 5 or 31)
            action.Size = UDim2.fromOffset(48, 22)
            action.BackgroundTransparency, action.BackgroundColor3 = 0, C.ELEM
            U.round(action, 6) U.stroke(action, 1)
            action.MouseButton1Click:Connect(function()
                if FUNHUBUI.bindingInput or FUNHUBKeys.blocked() then return end
                F.spamCmds(U.get(mode == 1 and "spam1Cmds" or "spam2Cmds",
                    mode == 1 and F.SPAM1_DEF or F.SPAM2_DEF), record.player, label)
            end)
        end
        record.dot, record.badge, record.name, record.username, record.ready = dot, badge, n, u, true
        -- Thumbnail work never blocks names, counts, or later rows.
        task.spawn(function()
            local ok, img = pcall(Players.GetUserThumbnailAsync, Players, id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            if ok and av.Parent then av.Image = img end
        end)
    end
    local function removeRowById(id)
        local record = rows[id]
        if record then record.row:Destroy() rows[id] = nil end
    end
    local function removeRow(p)
        local id = playerKey(p)
        if not id then return end
        leaving[id] = p
        removeRowById(id)
        joinOf[id] = nil
        resizePlayers()
    end
    local function reconcilePlayers()
        local present, snapshot = {}, {}
        local function collect(list)
            for _, p in ipairs(list) do
                local id = playerKey(p)
                if id and id ~= localId and leaving[id] ~= p and not present[id] then
                    if not joinOf[id] then joinN = joinN + 1 joinOf[id] = joinN end
                    present[id], snapshot[id] = true, p
                end
            end
        end
        local ok, all = pcall(function() return Players:GetPlayers() end)
        if ok then collect(all) end
        -- Also recover Player children when an executor returns an incomplete snapshot.
        local childrenOk, children = pcall(function() return Players:GetChildren() end)
        if childrenOk then
            for _, p in ipairs(children) do if p:IsA("Player") then collect({ p }) end end
        end
        if not ok and not childrenOk then return end
        for id, p in pairs(snapshot) do
            if rows[id] and (rows[id].row.Parent ~= plist or not rows[id].ready) then removeRowById(id) end
            local added, err = pcall(addRow, p)
            if not added then warn("[FUNHUB players] " .. tostring(err)) end
        end
        for id in pairs(rows) do if not present[id] then removeRowById(id) end end
        resizePlayers()
    end
    U.on(Players.PlayerAdded, function(p)
        local id = playerKey(p)
        if id then leaving[id] = nil end
        pcall(addRow, p)
        resizePlayers()
        task.defer(reconcilePlayers)
    end)
    U.on(Players.PlayerRemoving, removeRow)
    U.on(AS:GetPropertyChangedSignal("Visible"), function()
        if AS.Visible then plist.CanvasPosition = Vector2.new(0, 0) task.defer(reconcilePlayers) end
    end)
    U.on(refreshPlayers.Activated, reconcilePlayers)
    F.asRefresh = function()
        reconcilePlayers()
        local my = F.myPlot()
        local centre = my and my:GetPivot().Position
        for _, r in pairs(rows) do
            if r.ready then
                local p = r.player
                r.name.Text, r.username.Text = p.DisplayName, "@" .. p.Name
                local root_ = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local moving = root_ and Vector3.new(root_.AssemblyLinearVelocity.X, 0, root_.AssemblyLinearVelocity.Z).Magnitude > 1
                r.dot.BackgroundColor3 = moving and rgb(80, 225, 120) or rgb(110, 110, 118)
                local inBase = centre and root_ and (root_.Position - centre).Magnitude < 70
                r.badge.Text = p:GetAttribute("Stealing") and inBase and "STEALING FROM YOU" or (inBase and "IN YOUR BASE" or "")
            end
        end
    end
    -- This panel refreshes independently of statistics, ESP, and other feature loops.
    local elapsed = 0
    U.on(RunService.Heartbeat, function(dt)
        elapsed = elapsed + dt
        if elapsed < (AS.Visible and 0.5 or 3) then return end
        elapsed = 0
        pcall(F.asRefresh)
    end)
    reconcilePlayers()

end
F.asShow = function(v) U.showWindow(AS, v, "adminSpamOpen") end

local PRI = U.panel(root, UDim2.fromOffset(320, 360), UDim2.new(0.5, 534, 0.5, -141), nil, 0.72, 16, "priority")
PRI.Visible = U.get("autoPriority", false)
local priList
do
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1 }, PRI)
    local t = U.text("TextLabel", hd, "Priority Steal", 13, WB, C.WHITE)
    t.Position = UDim2.fromOffset(9, 0) t.Size = UDim2.new(1, -38, 1, 0)
    U.tgrad(t)
    F.priorityTitle = t
    local x = U.text("TextButton", hd, "X", 14, WB, C.DIM, Enum.TextXAlignment.Center)
    x.Position = UDim2.new(1, -36, 0, 0) x.Size = UDim2.fromOffset(36, 36)
    x.MouseButton1Click:Connect(function() PRI.Visible = false end)
    U.drag(hd, PRI, "priority")
    priList = U.scroller(PRI, UDim2.fromOffset(0, 36), UDim2.new(1, 0, 1, -36), 8, 6)
    U.resizer(PRI, 260, 200, "priority")
end
F.priorityEmpty = U.text("TextLabel", priList, "Waiting for brainrots to load", 12, WM, C.DIM, Enum.TextXAlignment.Center)
F.priorityEmpty.Size = UDim2.new(1, 0, 0, 50)
F.priorityEmpty.TextWrapped = true
F.priorityShow = function(v)
    PRI.Visible = v
    if v and F.renderPriority then F.renderPriority() end
end
AC.priority = type(AC.priority) == "table" and AC.priority or {}
local priCards, priThumbs = {}, {}
function F.thumb(model)
    if priThumbs[model.Name] then return priThumbs[model.Name]:Clone() end
    local vf = new("ViewportFrame", { Size = UDim2.fromOffset(56, 56), BackgroundColor3 = C.ELEM, BorderSizePixel = 0, Ambient = rgb(200, 200, 200),
        LightColor = rgb(255, 255, 255) })
    U.round(vf, 8)
    pcall(function()
        local arch = model.Archivable
        model.Archivable = true
        local m = model:Clone()
        model.Archivable = arch
        for _, d in ipairs(m:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("BillboardGui") or d:IsA("Sound") then d:Destroy() end
        end
        m:PivotTo(CFrame.new())
        m.Parent = vf
        local cam = new("Camera", {}, vf)
        local cf, size = m:GetBoundingBox()
        local r = math.max(size.X, size.Y, size.Z)
        cam.CFrame = CFrame.lookAt(cf.Position + Vector3.new(r * 0.9, r * 0.45, r * 0.9), cf.Position)
        vf.CurrentCamera = cam
    end)
    priThumbs[model.Name] = vf
    return vf:Clone()
end
function F.renderPriority()
    if not PRI.Visible then return end
    local groups, items, ranks = {}, {}, {}
    local saved = F.priorityList and F.priorityList() or AC.priority
    for index, name in ipairs(saved) do ranks[name] = index end
    for _, item in ipairs(F.brainrots()) do
        local group = groups[item.name]
        if not group then group = { name = item.name, count = 0, gen = 0 } groups[item.name] = group end
        group.count = group.count + 1
        if not group.item or item.gen > group.gen then group.item, group.gen = item, item.gen end
    end
    for _, name in ipairs(saved) do
        if not groups[name] then groups[name] = { name = name, count = 0, gen = 0 } end
    end
    for _, group in pairs(groups) do items[#items + 1] = group end
    F.priorityEmpty.Visible = #items == 0
    F.priorityTitle.Text = "Priority Steal · " .. #saved .. " selected"
    table.sort(items, function(a, b)
        local ra, rb = ranks[a.name] or math.huge, ranks[b.name] or math.huge
        if ra ~= rb then return ra < rb end
        if a.gen ~= b.gen then return a.gen > b.gen end
        return a.name < b.name
    end)
    local want = {}
    for index, item in ipairs(items) do
        local key = item.name
        want[key] = true
        local card = priCards[key]
        if not card then
            card = {}
            local record = card
            local frame = new("Frame", { Size = UDim2.new(1, 0, 0, 100), BackgroundColor3 = C.CARD, BorderSizePixel = 0 }, priList)
            U.round(frame, 10) U.stroke(frame, 1)
            card.f = frame
            card.st = U.text("TextLabel", frame, "Tap to select", 11, WB, C.DIM)
            card.st.Position, card.st.Size = UDim2.fromOffset(6, 3), UDim2.new(1, -60, 0, 20)
            card.nm = U.text("TextLabel", frame, key, 12, WB, C.TEXT)
            card.nm.Position, card.nm.Size = UDim2.fromOffset(66, 27), UDim2.new(1, -120, 0, 28)
            card.nm.TextTruncate = Enum.TextTruncate.AtEnd
            card.gn = U.text("TextLabel", frame, "", 10, WR, C.DIM)
            card.gn.Position, card.gn.Size = UDim2.fromOffset(66, 57), UDim2.new(1, -120, 0, 17)
            card.ow = U.text("TextLabel", frame, "", 10, WR, C.DIM)
            card.ow.Position, card.ow.Size = UDim2.fromOffset(66, 76), UDim2.new(1, -120, 0, 17)
            card.ow.TextTruncate = Enum.TextTruncate.AtEnd
            local hit = U.hit(frame, 2)
            local function changed()
                saveHubConfig()
                if F.invalidateAutoTarget then F.invalidateAutoTarget() end
                F.renderPriority()
            end
            hit.MouseButton1Click:Connect(function()
                local at = table.find(AC.priority, record.name)
                if at then table.remove(AC.priority, at) else AC.priority[#AC.priority + 1] = record.name end
                changed()
            end)
            local function move(dir)
                local at = table.find(AC.priority, record.name)
                local dest = at and at + dir
                if dest and dest >= 1 and dest <= #AC.priority then
                    AC.priority[at], AC.priority[dest] = AC.priority[dest], AC.priority[at]
                    changed()
                end
            end
            card.up = U.text("TextButton", frame, "Up", 11, WB, C.TEXT, Enum.TextXAlignment.Center)
            card.up.Position, card.up.Size = UDim2.new(1, -48, 0, 5), UDim2.fromOffset(42, 42)
            card.up.BackgroundTransparency, card.up.BackgroundColor3, card.up.ZIndex = 0, C.ELEM, 3
            U.round(card.up, 8)
            card.up.MouseButton1Click:Connect(function() move(-1) end)
            card.dn = U.text("TextButton", frame, "Down", 11, WB, C.TEXT, Enum.TextXAlignment.Center)
            card.dn.Position, card.dn.Size = UDim2.new(1, -48, 0, 53), UDim2.fromOffset(42, 42)
            card.dn.BackgroundTransparency, card.dn.BackgroundColor3, card.dn.ZIndex = 0, C.ELEM, 3
            U.round(card.dn, 8)
            card.dn.MouseButton1Click:Connect(function() move(1) end)
            priCards[key] = card
        end
        card.name, card.f.LayoutOrder = key, index
        if not card.thumb and item.item then
            local ok, thumb = pcall(F.thumb, item.item.model)
            if ok and thumb then thumb.Position, thumb.Parent = UDim2.fromOffset(6, 31), card.f card.thumb = thumb end
        end
        local rank = ranks[key]
        card.st.Text = rank and ("#" .. rank .. "  Selected") or "Tap to select"
        card.st.TextColor3 = rank and C.GOLD or C.DIM
        card.gn.Text = item.item and item.item.genText or "Not in this server"
        card.ow.Text = item.count > 0 and (tostring(item.count) .. " found · " .. item.item.owner) or "Saved · waiting for a match"
        card.up.Visible, card.dn.Visible = rank ~= nil and rank > 1, rank ~= nil and rank < #saved
    end
    for key, card in pairs(priCards) do
        if not want[key] then card.f:Destroy() priCards[key] = nil end
    end
end
R.cleanup[#R.cleanup + 1] = function()
    for _, thumb in pairs(priThumbs) do thumb:Destroy() end
    table.clear(priThumbs)
end

function F.menuTool()
    local bp = LP:FindFirstChild("Backpack")
    if not bp or bp:FindFirstChild("FUNHUB Menu") or (LP.Character and LP.Character:FindFirstChild("FUNHUB Menu")) then return end
    local t = new("Tool", { Name = "FUNHUB Menu", RequiresHandle = false, CanBeDropped = false })
    t.Equipped:Connect(function()
        U.toggleMain()
        task.defer(function() local _, hum = F.char() if hum then hum:UnequipTools() end end)
    end)
    t.Parent = bp
    R.cleanup[#R.cleanup + 1] = function() t:Destroy() end
end
if IsMobile then
    F.menuTool()
    U.on(LP.CharacterAdded, function() task.wait(1) F.menuTool() end)
end

local ESPF = new("Folder", { Name = "ESP" }, gui)
local WORLD = new("Folder", { Name = "FH_World" }, Workspace)
R.cleanup[#R.cleanup + 1] = function() WORLD:Destroy() end
-- Delivery ESP: supplied own-base / nearest-zone logic with cached tracking.
do
    local D = { objects = {}, links = {}, active = false, stopped = false, nextOwner = 0 }
    F.deliveryESP = D

    local function clearMark()
        if not D.mark then return end
        -- All objects here belong to Funhub; the actual hitbox is never changed.
        for _, name in ipairs({ "fill", "outline", "billboard", "guide" }) do
            local object = D.mark[name]
            if object then object:Destroy() end
        end
        D.mark, D.target = nil, nil
    end

    local function stop()
        clearMark()
        for _, link in ipairs(D.links) do link:Disconnect() end
        table.clear(D.links) table.clear(D.objects)
        D.active, D.worldIndexed, D.plots, D.owner, D.nextOwner = false, false, nil, nil, 0
    end

    local function add(object)
        if object.Name == "DeliveryHitbox" and (object:IsA("BasePart") or object:IsA("Model") or object:IsA("Folder")) then
            D.objects[object] = D.objects[object] or {}
        end
        local ancestor = object.Parent
        while ancestor and ancestor ~= Workspace do
            if D.objects[ancestor] then D.objects[ancestor].part = nil end
            ancestor = ancestor.Parent
        end
    end

    local function scan(scope)
        for _, object in ipairs(scope:GetDescendants()) do
            if object.Name == "DeliveryHitbox" then add(object) end
        end
    end

    local function syncIndex()
        if not D.active then
            D.active = true
            D.links[#D.links + 1] = Workspace.DescendantAdded:Connect(add)
            D.links[#D.links + 1] = Workspace.DescendantRemoving:Connect(function(object)
                if D.target == object or (D.mark and D.mark.part == object) then clearMark() end
                D.objects[object] = nil
                local ancestor = object.Parent
                while ancestor and ancestor ~= Workspace do
                    if D.objects[ancestor] then D.objects[ancestor].part = nil end
                    ancestor = ancestor.Parent
                end
            end)
        end
        local plots = Workspace:FindFirstChild("Plots")
        if plots ~= D.plots then
            D.plots, D.owner, D.nextOwner = plots, nil, 0
            if plots and not D.worldIndexed then scan(plots) end
        end
    end

    local function uniqueOwnerName(text)
        text = tostring(text):gsub("<[^>]*>", ""):match("^%s*(.-)%s*$")
        text = text:gsub("'s%s+[Bb][Aa][Ss][Ee]$", ""):gsub("’s%s+[Bb][Aa][Ss][Ee]$", ""):match("^%s*(.-)%s*$"):lower()
        if text ~= LP.Name:lower() and text ~= LP.DisplayName:lower() then return false end
        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= LP and (other.Name:lower() == text or other.DisplayName:lower() == text) then return false end
        end
        return true
    end

    local function findOwner()
        if not D.plots then return nil end
        local marked, named = {}, {}
        for _, plot in ipairs(D.plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            if sign then
                local marker = sign:FindFirstChild("YourBase", true)
                local known, isMine = false, false
                if marker then
                    if marker:IsA("BoolValue") then known, isMine = true, marker.Value == true
                    else
                        local ok, value = pcall(function() return marker.Enabled end)
                        if ok and type(value) == "boolean" then known, isMine = true, value end
                    end
                end
                if known then
                    if isMine then marked[#marked + 1] = plot end
                else
                    -- Match the owner sign exactly; a name in a pet tag/chat is not ownership.
                    for _, label in ipairs(sign:GetDescendants()) do
                        if (label:IsA("TextLabel") or label:IsA("TextButton") or label:IsA("TextBox"))
                            and uniqueOwnerName(label.Text) then named[#named + 1] = plot break end
                    end
                end
            end
        end
        if #marked == 1 then return marked[1] end
        if #marked == 0 and #named == 1 then return named[1] end
        return nil
    end

    local function geometry(object, entry)
        if object:IsA("BasePart") then return object, object.CFrame, object.Size end
        local part = entry.part
        if not part or not part.Parent or not part:IsDescendantOf(object) then
            part = object:FindFirstChildWhichIsA("BasePart", true)
            entry.part = part
        end
        if not part then return nil end
        if object:IsA("Model") then
            local ok, cf, size = pcall(function() return object:GetBoundingBox() end)
            if ok then return part, cf, size end
        end
        return part, part.CFrame, part.Size
    end

    local function choose(rootPart)
        local owner = D.owner
        if owner and (not D.plots or not owner:IsDescendantOf(D.plots)) then D.owner, owner, D.nextOwner = nil, nil, 0 end
        if not owner and not U.get("deliveryFallback", true) then return nil end
        if not owner and not D.worldIndexed then
            -- Only the unresolved-owner fallback needs a one-time world scan.
            D.worldIndexed = true scan(Workspace)
        end
        local best, distance
        for object, entry in pairs(D.objects) do
            if not object.Parent or not object:IsDescendantOf(Workspace) or object.Name ~= "DeliveryHitbox" then
                D.objects[object] = nil
            elseif not owner or object:IsDescendantOf(owner) then
                local part, cf, size = geometry(object, entry)
                if part then
                    local delta = (cf.Position - rootPart.Position).Magnitude
                    if not distance or delta < distance then
                        best, distance = { object = object, part = part, cf = cf, size = size, own = owner ~= nil }, delta
                    end
                end
            end
        end
        -- If a known base is still streaming, wait instead of pointing to somebody else's zone.
        return best, distance
    end

    local function createMark(target)
        clearMark()
        local m = {}
        D.mark, D.target = m, target.object
        m.part = target.part
        m.fill = new("BoxHandleAdornment", { Name = "FH_Delivery_Fill", Adornee = target.part,
            AlwaysOnTop = true, ZIndex = 3, Transparency = 0.8, Size = target.size }, ESPF)
        m.outline = new("SelectionBox", { Name = "FH_Delivery_Outline", LineThickness = 0.06,
            SurfaceTransparency = 1, Adornee = target.object:IsA("Model") and target.object or target.part }, ESPF)
        m.billboard = new("BillboardGui", { Name = "FH_Delivery_Label", Adornee = target.part,
            AlwaysOnTop = true, LightInfluence = 0, MaxDistance = 1e9, Size = UDim2.fromOffset(220, 52) }, ESPF)
        local panel = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(12, 16, 22),
            BackgroundTransparency = 0.16, BorderSizePixel = 0 }, m.billboard)
        U.round(panel, 8)
        m.border = new("UIStroke", { Thickness = 1.4 }, panel)
        m.title = U.text("TextLabel", panel, "", 17, WB, rgb(255, 155, 45), Enum.TextXAlignment.Center)
        m.title.Position, m.title.Size = UDim2.fromOffset(6, 3), UDim2.new(1, -12, 0.55, 0)
        m.title.TextTruncate = Enum.TextTruncate.AtEnd
        m.detail = U.text("TextLabel", panel, "", 13, WM, rgb(240, 244, 250), Enum.TextXAlignment.Center)
        m.detail.Position, m.detail.Size = UDim2.new(0, 6, 0.55, 0), UDim2.new(1, -12, 0.4, 0)
        m.detail.TextTruncate = Enum.TextTruncate.AtEnd
        m.guide = new("Frame", { Name = "FH_Delivery_Guide", AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(196, 42), BackgroundColor3 = rgb(12, 16, 22), BackgroundTransparency = 0.18,
            BorderSizePixel = 0, Visible = false, ZIndex = 0 }, ESPF)
        U.round(m.guide, 8)
        m.arrow = U.text("TextLabel", m.guide, "▲", 22, WB, rgb(255, 155, 45), Enum.TextXAlignment.Center)
        m.arrow.AnchorPoint, m.arrow.Position, m.arrow.Size = Vector2.new(0.5, 0.5), UDim2.new(0, 20, 0.5, 0), UDim2.fromOffset(28, 28)
        m.caption = U.text("TextLabel", m.guide, "", 12, WB, rgb(240, 244, 250), Enum.TextXAlignment.Center)
        m.caption.Position, m.caption.Size = UDim2.fromOffset(38, 2), UDim2.new(1, -44, 1, -4)
        m.caption.TextTruncate = Enum.TextTruncate.AtEnd
        return m
    end

    function F.deliveryESPTick()
        if D.stopped or not FUNHUB_ALIVE() or not U.get("delivery", false) then stop() return end
        syncIndex()
        local now = os.clock()
        if now >= D.nextOwner then
            D.owner, D.nextOwner = findOwner(), now + (IsMobile and 0.8 or 0.5)
        end
        local _, _, rootPart = F.char()
        if not rootPart or not rootPart.Parent then clearMark() return end
        local target, distance = choose(rootPart)
        if not target then clearMark() return end
        local m = D.mark
        if not m or D.target ~= target.object or m.part ~= target.part then m = createMark(target) end
        local localPoint, half = target.cf:PointToObjectSpace(rootPart.Position), target.size * 0.5
        local inside = target.own and math.abs(localPoint.X) <= half.X and math.abs(localPoint.Z) <= half.Z
            and math.abs(localPoint.Y) <= half.Y + 3
        local color = inside and rgb(80, 255, 145) or fromT(AC.deliveryColor, rgb(255, 155, 45))
        local title = target.own and (inside and "IN DELIVERY ZONE" or "YOUR DELIVERY") or "NEAREST DELIVERY"
        local detail = target.own and (inside and "Zone reached" or "Return here") or "OWNER UNCONFIRMED"
        if U.get("deliveryDistance", true) then detail = detail .. " · " .. math.floor(distance + 0.5) .. " studs" end
        m.fill.CFrame, m.fill.Size = target.part.CFrame:ToObjectSpace(target.cf), target.size
        m.fill.Color3 = color
        m.fill.Transparency = 1 - math.clamp(tonumber(U.get("deliveryOpacity", 20)) or 20, 5, 60) / 100
        m.outline.Color3, m.border.Color, m.title.TextColor3, m.arrow.TextColor3 = color, color, color, color
        m.title.Text, m.detail.Text = title, detail
        local camera = Workspace.CurrentCamera
        local textSize = math.clamp(tonumber(U.get("deliveryTextSize", IsMobile and 14 or 17)) or 17, 12, 22)
        local width = textSize * 16
        if camera then width = math.min(width, math.max(100, camera.ViewportSize.X - 24)) end
        m.billboard.Size = UDim2.fromOffset(width, textSize * 2 + 18)
        m.title.TextSize, m.detail.TextSize = textSize, math.max(10, textSize - 4)
        -- Model bounds may be offset from their first part; align the marker with the actual zone.
        local up = target.cf.UpVector
        local verticalHalf = math.abs(target.cf.RightVector.Y) * half.X + math.abs(up.Y) * half.Y + math.abs(target.cf.LookVector.Y) * half.Z
        m.billboard.StudsOffsetWorldSpace = target.cf.Position - target.part.Position + Vector3.new(0, verticalHalf + 2.5, 0)
        m.guide.Visible = false
        if camera and not inside and U.get("deliveryGuide", true) then
            local viewport = camera.ViewportSize
            local projected, onScreen = camera:WorldToViewportPoint(target.cf.Position)
            if viewport.X >= 240 and viewport.Y >= 160 and (not onScreen or projected.Z <= 0) then
                local offset = camera.CFrame:PointToObjectSpace(target.cf.Position)
                local dx, dy = offset.X, -offset.Y
                if math.abs(dx) + math.abs(dy) < 0.001 then dy = 1 end
                local cx, cy = viewport.X * 0.5, viewport.Y * 0.5
                local scale = math.min((cx - 106) / math.max(math.abs(dx), 0.001), (cy - 52) / math.max(math.abs(dy), 0.001))
                m.guide.Position = UDim2.fromOffset(cx + dx * scale, cy + dy * scale)
                m.arrow.Rotation = math.deg(math.atan2(dy, dx)) + 90
                m.caption.Text = target.own and "YOUR DELIVERY" or "NEAREST · UNCONFIRMED"
                if U.get("deliveryDistance", true) then m.caption.Text = m.caption.Text .. "\n" .. math.floor(distance + 0.5) .. " studs" end
                m.guide.Visible = true
            end
        end
    end

    R.cleanup[#R.cleanup + 1] = function() D.stopped = true stop() end
end
-- End Delivery ESP.

-- Public-hub Slot ESP and ordered next-empty-base pointer.
do
    local slotCleanup, nextCleanup, attachedPlots
        local positions = {
            Vector3.new(-342.439,10.399,113.107), Vector3.new(-342.439,10.465,6.107),
            Vector3.new(-476.752,10.465,114.107), Vector3.new(-476.752,10.465,7.107),
            Vector3.new(-342.440,10.464,220.107), Vector3.new(-476.752,10.465,221.107),
            Vector3.new(-342.439,10.465,-100.893), Vector3.new(-476.752,10.465,-99.893),
        }
        F.findNextBase = function()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return nil end
            local best
            for _, plot in ipairs(plots:GetChildren()) do
                local sign = plot:FindFirstChild("PlotSign")
                local model = sign and sign:FindFirstChild("Model")
                local gui = sign and sign:FindFirstChild("SurfaceGui")
                local frame = gui and gui:FindFirstChild("Frame")
                local label = frame and frame:FindFirstChild("TextLabel")
                if model and model:IsA("Model") and label and label:IsA("TextLabel")
                    and label.Text:match("^%s*(.-)%s*$") == "Empty Base" then
                    local ok, cf = pcall(function() return model:GetBoundingBox() end)
                    if ok then
                        for index, pos in ipairs(positions) do
                            local delta = cf.Position - pos
                            if Vector2.new(delta.X, delta.Z).Magnitude <= 6 and (not best or index < best.index) then
                                best = { plot = plot, label = label, cf = cf, index = index }
                            end
                        end
                    end
                end
            end
            return best
        end

    local function startNextBase()
        if nextCleanup then pcall(nextCleanup) end
        local CoreGui = WORLD
        local Plots = workspace:FindFirstChild("Plots")
        if not Plots then return end
        local BASE_POSITIONS = {
            Vector3.new(-342.439, 10.399, 113.107),
            Vector3.new(-342.439, 10.465,   6.107),
            Vector3.new(-476.752, 10.465, 114.107),
            Vector3.new(-476.752, 10.465,   7.107),
            Vector3.new(-342.440, 10.464, 220.107),
            Vector3.new(-476.752, 10.465, 221.107),
            Vector3.new(-342.439, 10.465,-100.893),
            Vector3.new(-476.752, 10.465, -99.893),
        }
        local MATCH_TOL = 6
        local EMPTY_TEXT = "Empty Base"
        local ARROW = utf8.char(0x2B07)
        local function baseIndexFor(model)
            local ok, cf = pcall(function() return (model:GetBoundingBox()) end)
            if not ok then return nil end
            local p, bestI, bestD = cf.Position
            for i, bp in ipairs(BASE_POSITIONS) do
                local dx, dz = p.X - bp.X, p.Z - bp.Z
                local d = math.sqrt(dx * dx + dz * dz)
                if not bestD or d < bestD then bestI, bestD = i, d end
            end
            return (bestD and bestD <= MATCH_TOL) and bestI or nil
        end
        local bases = {}
        local connected = {}
        local conns = {}
        local anchor = Instance.new("Part")
        anchor.Name = "__NextBaseAnchor"
        anchor.Anchored, anchor.CanCollide, anchor.CanQuery, anchor.CanTouch = true, false, false, false
        anchor.Transparency = 1
        anchor.Size = Vector3.new(1, 1, 1)
        anchor.Parent = CoreGui
        local bb = Instance.new("BillboardGui")
        bb.Name = "NextBaseBillboard"
        bb.Adornee = anchor
        bb.Size = UDim2.fromScale(32, 13)
        bb.StudsOffset = Vector3.new(0, 10, 0)
        bb.MaxDistance = math.huge
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.Enabled = false
        bb.Parent = gui
        local top = Instance.new("TextLabel", bb)
        top.BackgroundTransparency = 1
        top.AnchorPoint = Vector2.new(0.5, 0.5)
        top.Position = UDim2.fromScale(0.5, 0.30)
        top.Size = UDim2.fromScale(0.95, 0.50)
        top.Font = Enum.Font.GothamBlack
        top.Text = ARROW .. "  NEXT  " .. ARROW
        top.TextScaled = true
        top.TextColor3 = Color3.fromRGB(65, 137, 245)
        top.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        top.TextStrokeTransparency = 0
        local bottom = Instance.new("TextLabel", bb)
        bottom.BackgroundTransparency = 1
        bottom.AnchorPoint = Vector2.new(0.5, 0.5)
        bottom.Position = UDim2.fromScale(0.5, 0.72)
        bottom.Size = UDim2.fromScale(0.95, 0.42)
        bottom.Font = Enum.Font.GothamBlack
        bottom.Text = "EMPTY BASE"
        bottom.TextScaled = true
        bottom.TextColor3 = Color3.fromRGB(151, 197, 255)
        bottom.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        bottom.TextStrokeTransparency = 0
        local function isEmpty(label)
            return (label.Text:gsub("^%s+", ""):gsub("%s+$", "")) == EMPTY_TEXT
        end
        local function recompute()
            local target = F.findNextBase()
            bb.Enabled = target ~= nil
            if target then anchor.CFrame = target.cf end
        end
        local function connectLabel(label)
            if connected[label] then return end
            connected[label] = true
            table.insert(conns, label:GetPropertyChangedSignal("Text"):Connect(recompute))
        end
        local function scan()
            for _, plot in ipairs(Plots:GetChildren()) do
                local sign  = plot:FindFirstChild("PlotSign")
                local model = sign and sign:FindFirstChild("Model")
                local gui   = sign and sign:FindFirstChild("SurfaceGui")
                local fr    = gui and gui:FindFirstChild("Frame")
                local label = fr and fr:FindFirstChild("TextLabel")
                if model and label then
                    local idx = baseIndexFor(model)
                    if idx then
                        bases[idx] = { label = label, cf = (select(1, model:GetBoundingBox())) }
                        connectLabel(label)
                    end
                end
            end
            recompute()
        end
        scan()
        table.insert(conns, Plots.ChildRemoved:Connect(function() task.defer(scan) end))
        table.insert(conns, Plots.DescendantAdded:Connect(function(d)
            if d:IsA("TextLabel") then task.defer(scan) end
        end))
        table.insert(conns, Plots.ChildAdded:Connect(function() task.defer(scan) end))
        nextCleanup = function()
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            if bb then bb:Destroy() end
            if anchor then anchor:Destroy() end
            nextCleanup = nil
        end
    end


    local function startPodiumESP()
        if slotCleanup then pcall(slotCleanup) end
        local RS = game:GetService("RunService")
        local hui = gui
        local C = LP
        local Plots = workspace:FindFirstChild("Plots")
        if not Plots then return end
        local function cam() return workspace.CurrentCamera end
        if not cam() then return end

        local MARK = Color3.fromRGB(65, 137, 245)
        local WHITE = Color3.fromRGB(255, 255, 255)
        local SHOW_NUMBERS = true
        local COLLIDE = true
        local FILL_T, INNER_T, THICK = 0.55, 0.42, 0.05
        local PULSE_SPEED, PULSE_AMOUNT = 2, 0.12
        local OUTER = Vector3.new(6, 0.25, 6)
        local INNER_SZ = Vector3.new(4, 0.25, 4)
        local INNER_UP = 0.25

        local TEMPLATE = {
            { 18.500,  1.531, -14.476,  90}, { 18.500,  1.531,  -6.976,  90}, { 18.500,  1.531,   0.524,  90},
            { 18.500,  1.531,   8.024,  90}, { 18.500,  1.531,  15.524,  90},
            {-18.536,  1.531,  15.524, -90}, {-18.536,  1.531,   8.024, -90}, {-18.536,  1.531,   0.524, -90},
            {-18.536,  1.531,  -6.976, -90}, {-18.536,  1.531, -14.476, -90},
            { 18.500, 19.531, -14.476,  90}, { 18.500, 19.531,  -6.976,  90}, { 18.500, 19.531,   0.524,  90},
            { 18.500, 19.531,   8.024,  90}, { 18.500, 19.531,  15.524,  90},
            {-18.380, 19.531, -14.452, -90}, {-18.380, 19.531,  -6.952, -90}, {-18.380, 19.531,   0.548, -90},
            { 18.500, 36.531, -12.476,  90}, { 18.500, 36.531,  -4.976,  90}, { 18.500, 36.531,   2.524,  90},
            { 18.500, 36.531,  10.024,  90}, { 18.500, 36.531,  17.524,  90},
            {-18.472, 36.531, -12.501, -90}, {-18.471, 36.531,  -5.001, -90}, {-18.471, 36.531,   2.499, -90},
            {-18.471, 36.531,   9.999, -90}, {-18.471, 36.531,  17.499, -90},
        }

        local _rng = Random.new(os.clock() * 1e6)
        local _POOL = { "Part", "Mesh", "MeshPart", "Union", "Wedge", "Cylinder", "Model", "Frame", "Handle", "Body", "Root" }
        local function fakeName() return _POOL[_rng:NextInteger(1, #_POOL)] end

        local markers, fills, conns = {}, {}, {}
        local collideParts, labelAnchors, labelsByPlot = {}, {}, {}
        local currentPlot, alive, pending = nil, true, false

        local function keep(x) markers[#markers + 1] = x; x.Parent = hui; return x end

        local function clear()
            for _, m in ipairs(markers) do pcall(function() m:Destroy() end) end
            table.clear(markers); table.clear(fills)
            for _, p in ipairs(collideParts) do pcall(function() p:Destroy() end) end
            table.clear(collideParts)
            for _, p in ipairs(labelAnchors) do pcall(function() p:Destroy() end) end
            table.clear(labelAnchors); table.clear(labelsByPlot)
            currentPlot = nil
        end

        local function box(adornee, cf, size, color, trans, isFill)
            local a = Instance.new("BoxHandleAdornment")
            a.Adornee = adornee
            a.Size = size
            a.CFrame = cf
            a.Color3 = color
            a.Transparency = trans
            a.AlwaysOnTop = true
            a.ZIndex = 0
            keep(a)
            if isFill then fills[#fills + 1] = { a = a, base = trans } end
            return a
        end

        local function edges(root, cf, size, color)
            local t = THICK * 1.6
            local hx, hz, y = size.X * 0.5, size.Z * 0.5, size.Y * 0.5
            box(root, cf * CFrame.new(0, y,  hz), Vector3.new(size.X, t, t), color, 0)
            box(root, cf * CFrame.new(0, y, -hz), Vector3.new(size.X, t, t), color, 0)
            box(root, cf * CFrame.new( hx, y, 0), Vector3.new(t, t, size.Z), color, 0)
            box(root, cf * CFrame.new(-hx, y, 0), Vector3.new(t, t, size.Z), color, 0)
        end

        local function anchorAt(worldCF, collidable)
            local c = cam()
            if not c then return nil end
            local a = Instance.new("Part")
            a.Name = fakeName()
            a.Anchored = true
            a.CanCollide = collidable and true or false
            a.CanQuery = false
            a.CanTouch = false
            a.CastShadow = false
            a.Massless = true
            a.Transparency = 1
            a.Size = collidable and OUTER or Vector3.new(0.1, 0.1, 0.1)
            a.CFrame = worldCF
            a.Parent = c
            if collidable then
                collideParts[#collideParts + 1] = a
            else
                labelAnchors[#labelAnchors + 1] = a
            end
            return a
        end

        local function labelFor(plot, adornee, slotNum, color)
            if not SHOW_NUMBERS then return end
            local bg = Instance.new("BillboardGui")
            bg.Adornee = adornee
            bg.Size = UDim2.new(2.2, 20, 1.35, 12)
            bg.StudsOffset = Vector3.new(0, 3.2, 0)
            bg.AlwaysOnTop = true
            bg.LightInfluence = 0
            bg.MaxDistance = 400
            bg.Enabled = false

            local panel = Instance.new("Frame", bg)
            panel.Size = UDim2.fromScale(1, 1)
            panel.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
            panel.BackgroundTransparency = 0.55
            panel.BorderSizePixel = 0
            Instance.new("UICorner", panel).CornerRadius = UDim.new(0.3, 0)

            local glow = Instance.new("UIStroke", panel)
            glow.Color = color
            glow.Thickness = 4
            glow.Transparency = 0.7
            glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local num = Instance.new("TextLabel", panel)
            num.Size = UDim2.fromScale(1, 1)
            num.BackgroundTransparency = 1
            num.Text = tostring(slotNum)
            num.Font = Enum.Font.GothamBlack
            num.TextScaled = true
            num.TextColor3 = Color3.fromRGB(174, 211, 255)

            local pad = Instance.new("UIPadding", num)
            pad.PaddingLeft = UDim.new(0.1, 0)
            pad.PaddingRight = UDim.new(0.1, 0)
            pad.PaddingTop = UDim.new(0.08, 0)
            pad.PaddingBottom = UDim.new(0.08, 0)

            local cons = Instance.new("UITextSizeConstraint", num)
            cons.MaxTextSize = 500
            cons.MinTextSize = 6

            local ns = Instance.new("UIStroke", num)
            ns.Color = color
            ns.Thickness = 2
            ns.LineJoinMode = Enum.LineJoinMode.Round

            keep(bg)
            labelsByPlot[plot] = labelsByPlot[plot] or {}
            table.insert(labelsByPlot[plot], bg)
        end

        local function build()
            if not alive then return end
            clear()
            for _, plot in ipairs(Plots:GetChildren()) do
                local root = plot:FindFirstChild("MainRoot")
                if root then
                    for idx = 1, #TEMPLATE do
                        local e = TEMPLATE[idx]
                        local worldCF = root.CFrame * (CFrame.new(e[1], e[2], e[3]) * CFrame.Angles(0, math.rad(e[4]), 0))
                        local a = anchorAt(worldCF, false)
                        if a then
                            box(a, CFrame.new(), OUTER, MARK, FILL_T, true)
                            box(a, CFrame.new(0, INNER_UP, 0), INNER_SZ, MARK, INNER_T, true)
                            edges(a, CFrame.new(), OUTER, MARK)
                            if COLLIDE then anchorAt(worldCF, true) end
                            labelFor(plot, a, idx, MARK)
                        end
                    end
                end
            end
        end

        local function findCurrentPlot()
            local char = C.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return nil end
            local pos = hrp.Position
            local best, bestDist = nil, math.huge
            for _, plot in ipairs(Plots:GetChildren()) do
                local root = plot:FindFirstChild("MainRoot")
                if root then
                    local d = (root.Position - pos).Magnitude
                    if d < bestDist then best, bestDist = plot, d end
                end
            end
            if bestDist > 100 then return nil end
            return best
        end

        local function updateVisibility()
            local newPlot = findCurrentPlot()
            if newPlot == currentPlot then return end
            currentPlot = newPlot
            for plot, list in pairs(labelsByPlot) do
                local show = (plot == currentPlot)
                for _, bg in ipairs(list) do
                    if bg and bg.Parent then bg.Enabled = show end
                end
            end
        end

        local function rebuild()
            if pending or not alive then return end
            pending = true
            task.delay(0.4, function()
                pending = false
                if not alive then return end
                pcall(build)
                pcall(updateVisibility)
            end)
        end

        build()
        updateVisibility()

        local function watch(plot)
            if not plot:FindFirstChild("MainRoot") then
                local root = plot:WaitForChild("MainRoot", 30)
                if root and alive then rebuild() end
            end
        end
        for _, plot in ipairs(Plots:GetChildren()) do task.spawn(watch, plot) end

        table.insert(conns, Plots.ChildAdded:Connect(function(plot)
            task.spawn(watch, plot)
            rebuild()
        end))
        table.insert(conns, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if alive then rebuild() end
        end))

        table.insert(conns, Plots.ChildRemoved:Connect(rebuild))
        table.insert(conns, Plots.DescendantAdded:Connect(function(d)
            if d.Name == "MainRoot" then rebuild() end
        end))
        local acc, visAcc = 0, 0
        table.insert(conns, RS.Heartbeat:Connect(function(dt)
            acc, visAcc = acc + dt, visAcc + dt
            if acc >= 0.05 then
                acc = 0
                local w = math.sin(os.clock() * PULSE_SPEED) * PULSE_AMOUNT
                for _, f in ipairs(fills) do
                    if f.a.Parent then f.a.Transparency = math.clamp(f.base + w, 0, 1) end
                end
            end
            if visAcc >= 0.5 then
                visAcc = 0
                updateVisibility()
            end
        end))

        slotCleanup = function()
            alive = false
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            table.clear(conns)
            clear()
            slotCleanup = nil
        end
    end


    function F.publicSync()
        local plots = Workspace:FindFirstChild("Plots")
        local camera = Workspace.CurrentCamera
        if plots ~= attachedPlots then
            if slotCleanup then slotCleanup() end
            if nextCleanup then nextCleanup() end
            attachedPlots = plots
        end
        local enabled = U.get("pubMethod", false)
        if enabled and U.get("slotEsp", false) and plots and camera then
            if not slotCleanup then startPodiumESP() end
        elseif slotCleanup then slotCleanup() end
        if enabled and U.get("nextBase", false) and plots then
            if not nextCleanup then startNextBase() end
        elseif nextCleanup then nextCleanup() end
    end
    R.cleanup[#R.cleanup + 1] = function()
        if slotCleanup then slotCleanup() end
        if nextCleanup then nextCleanup() end
    end
end

local espObjs = {}
do
    local ids, serial = setmetatable({}, { __mode = "k" }), 0
    function F.espKey(prefix, object)
        if not ids[object] then serial = serial + 1 ids[object] = serial end
        return prefix .. ids[object]
    end
end
function F.espKill(e)
    -- model/adorn are live game objects, borrowed only to position the ESP.
    -- Destroy only the overlay roots we created; their GUI children go with them.
    for _, key in ipairs({ "hl", "tag", "box" }) do
        local overlay = e[key]
        e[key] = nil
        if overlay then pcall(function() overlay:Destroy() end) end
    end
    for _, key in ipairs({ "dText", "dBox", "dPlate" }) do
        local drawing = e[key]
        e[key] = nil
        if drawing then pcall(function() drawing:Remove() end) end
    end
    e.model, e.adorn = nil, nil
end
function F.espReset()
    for k, o in pairs(espObjs) do
        F.espKill(o)
        espObjs[k] = nil
    end
end
R.cleanup[#R.cleanup + 1] = function() F.espReset() end
function F.espColor(c) return c end
function F.useDrawing()
    local r = U.get("espRenderer", "Auto")
    return not F.drawingUnavailable and r ~= "GUI" and type(Drawing) == "table" and type(Drawing.new) == "function"
end
function F.forceVisible() return U.get("forceVisible", true) end
function F.espEntry(key, model, adorn, mode, color, kind)
    local e = espObjs[key]
    local drawing = F.useDrawing()
    if e and (e.model ~= model or e.adorn ~= adorn or e.mode ~= mode or e.drawing ~= drawing) then
        espObjs[key] = nil
        F.espKill(e)
        e = nil
    end
    if not e then
        e = { model = model, mode = mode, drawing = drawing, adorn = adorn, kind = kind }
        local fv = F.forceVisible()
        -- Allocate Highlights only inside the visible budget, not for every hidden entry.
        local th = kind == "brainrot" and U.get("brThickness", 2.5) or U.get("espThick", 2)
        if drawing then
            local ok = pcall(function()
                e.dText = Drawing.new("Text")
                e.dText.Center, e.dText.Outline, e.dText.Visible = true, true, false
                e.dText.OutlineColor, e.dText.Transparency = rgb(0, 0, 0), 1
                e.dText.ZIndex = 3
                if kind == "brainrot" then
                    e.dPlate = Drawing.new("Square")
                    e.dPlate.Filled, e.dPlate.Color, e.dPlate.Transparency = true, rgb(8, 12, 20), 0.78
                    e.dPlate.Visible, e.dPlate.ZIndex = false, 1
                end
                e.dBox = Drawing.new("Square")
                e.dBox.ZIndex = 2
                e.dBox.Filled, e.dBox.Thickness, e.dBox.Visible = false, th, false
            end)
            if not ok then
                if e.dText then pcall(function() e.dText:Remove() end) end
                if e.dBox then pcall(function() e.dBox:Remove() end) end
                if e.dPlate then pcall(function() e.dPlate:Remove() end) end
                e.dText, e.dBox, e.dPlate, e.drawing = nil, nil, nil, false
                F.drawingUnavailable = true
                drawing = false
            end
        end
        if not drawing then
            e.tag = new("BillboardGui", { Size = UDim2.fromOffset(220, 70), StudsOffset = Vector3.new(0, 3.2, 0), AlwaysOnTop = fv,
                LightInfluence = 0, MaxDistance = 100000, Adornee = adorn }, ESPF)
            e.lbl = U.text("TextLabel", e.tag, "", 16, WB, color, Enum.TextXAlignment.Center)
            e.lbl.Size = UDim2.fromScale(1, 1)
            e.lbl.TextYAlignment = Enum.TextYAlignment.Bottom
            e.lbl.TextStrokeTransparency = kind == "brainrot" and 0 or 0.4
            e.lbl.TextStrokeColor3 = rgb(0, 0, 0)
            if kind == "brainrot" then U.round(e.lbl, 6) end
            if mode == "3D" then
                e.box = new("SelectionBox", { Adornee = model, LineThickness = 0.02 * th, SurfaceTransparency = 1 }, ESPF)
            else
                e.box = new("BillboardGui", { AlwaysOnTop = fv, LightInfluence = 0, MaxDistance = 100000, Adornee = adorn, Size = UDim2.fromScale(4, 5) }, ESPF)
                if mode == "2D" or mode == "Square" or mode == "Circle" then
                    local f = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, e.box)
                    if mode == "Circle" then U.round(f, 0.5, true) end
                    if mode == "Square" then f.SizeConstraint = Enum.SizeConstraint.RelativeYY f.AnchorPoint = Vector2.new(0.5, 0) f.Position = UDim2.fromScale(0.5, 0) end
                    e.boxStroke = new("UIStroke", { Thickness = th, Color = color }, f)
                elseif mode == "Corner" then
                    e.corners = {}
                    for _, s in ipairs({ { 0, 0, 1, 0 }, { 0, 0, 0, 1 }, { 1, 0, -1, 0 }, { 1, 0, 0, 1 }, { 0, 1, 1, 0 }, { 0, 1, 0, -1 }, { 1, 1, -1, 0 }, { 1, 1, 0, -1 } }) do
                        local horiz = s[3] ~= 0
                        local f = new("Frame", { BorderSizePixel = 0, BackgroundColor3 = color,
                            AnchorPoint = Vector2.new(s[1], s[2]), Position = UDim2.fromScale(s[1], s[2]),
                            Size = horiz and UDim2.new(0.28, 0, 0, th) or UDim2.new(0, th, 0.28, 0) }, e.box)
                        e.corners[#e.corners + 1] = f
                    end
                else
                    local g = U.text("TextLabel", e.box, mode == "Star" and "☆" or "△", 12, WB, color, Enum.TextXAlignment.Center)
                    g.Size = UDim2.fromScale(1, 1) g.TextScaled = true
                    e.glyph = g
                end
            end
        end
        espObjs[key] = e
    end
    return e
end
function F.espPaint(e, color, chams, boxOn, text, sizeX, sizeY)
    local brainrot = e.kind == "brainrot"
    if chams then
        if not e.hl then
            e.hl = new("Highlight", { Adornee = e.model }, ESPF)
        end
        e.hl.Enabled = true
        e.hl.DepthMode = F.forceVisible() and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        e.hl.FillColor, e.hl.OutlineColor = color, color
        e.hl.FillTransparency = brainrot and 1 - math.clamp(U.get("brOpacity", 55), 5, 90) / 100 or 0.75
        e.hl.OutlineTransparency = 0
    elseif e.hl then e.hl:Destroy() e.hl = nil end
    e.color, e.text, e.boxOn, e.sizeX, e.sizeY = color, text, boxOn, sizeX or 4, sizeY or 5
    e.fontSize = brainrot and U.get("brTextSize", 18) or U.get("espText", 16)
    e.thickness = brainrot and U.get("brThickness", 2.5) or U.get("espThick", 2)
    e.backdrop = false
    local longest, lines = 0, 0
    for line in (text .. "\n"):gmatch("(.-)\n") do longest = math.max(longest, #line) lines = lines + 1 end
    e.labelWidth, e.labelHeight = math.clamp(longest * e.fontSize * 0.62 + 18, 100, 420), math.max(lines, 1) * (e.fontSize + 2) + 10
    if e.drawing then return end
    e.lbl.Text, e.lbl.TextColor3, e.lbl.TextSize = text, color, e.fontSize
    e.tag.Enabled = text ~= ""
    if brainrot then
        e.tag.Size = UDim2.fromOffset(e.labelWidth, e.labelHeight)
        e.tag.StudsOffset = Vector3.zero
        e.tag.StudsOffsetWorldSpace = Vector3.new(0, e.sizeY * 0.5 + 2, 0)
        e.lbl.TextYAlignment = Enum.TextYAlignment.Center
        e.lbl.BackgroundColor3 = rgb(8, 12, 20)
        e.lbl.BackgroundTransparency = e.backdrop and 0.22 or 1
    end
    if e.box then
        if e.box:IsA("SelectionBox") then
            e.box.Visible = boxOn
            e.box.Color3 = color
        else
            e.box.Enabled = boxOn
            if sizeX then e.box.Size = UDim2.fromScale(sizeX, sizeY) end
        end
    end
    if e.boxStroke then e.boxStroke.Color = color e.boxStroke.Thickness = e.thickness end
    if e.corners then for _, f in ipairs(e.corners) do f.BackgroundColor3 = color end end
    if e.glyph then e.glyph.TextColor3 = color end
end
function F.drawTick()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    for _, e in pairs(espObjs) do
        if e.drawing and e.dText then
            local a = e.adorn
            local ok = a and a.Parent
            local top, onTop, bot, onBot
            if ok then
                local up = Vector3.new(0, (e.sizeY or 5) / 2, 0)
                local t3, v1 = cam:WorldToViewportPoint(a.Position + up)
                local b3, v2 = cam:WorldToViewportPoint(a.Position - up)
                top, onTop, bot, onBot = t3, v1, b3, v2
            end
            if ok and onTop and onBot then
                local h = math.abs(bot.Y - top.Y)
                local w = h * math.clamp((e.sizeX or 4) / math.max(e.sizeY or 5, 0.1), 0.3, 2)
                e.dBox.Position = Vector2.new(top.X - w / 2, top.Y)
                e.dBox.Size = Vector2.new(w, h)
                e.dBox.Color = e.color or C.WHITE
                e.dBox.Thickness = e.thickness or U.get("espThick", 2)
                e.dBox.Visible = e.boxOn and true or false
                e.dText.Text = e.text or ""
                e.dText.Size = e.fontSize or U.get("espText", 16)
                e.dText.Color = e.color or C.WHITE
                local lines = select(2, (e.text or ""):gsub("\n", "")) + 1
                e.dText.Position = Vector2.new(top.X, top.Y - lines * ((e.fontSize or 16) + 2) - 6)
                e.dText.Visible = (e.text or "") ~= ""
                if e.dPlate then
                    e.dPlate.Position = Vector2.new(top.X - (e.labelWidth or 220) * 0.5, e.dText.Position.Y - 4)
                    e.dPlate.Size = Vector2.new(e.labelWidth or 220, e.labelHeight or 70)
                    e.dPlate.Visible = e.dText.Visible and e.backdrop == true
                end
            else
                e.dBox.Visible = false
                e.dText.Visible = false
                if e.dPlate then e.dPlate.Visible = false end
            end
        end
    end
end
U.on(RunService.RenderStepped, function() pcall(F.drawTick) end)
function F.espSweep(alive)
    for k, e in pairs(espObjs) do
        if not alive[k] then
            F.espKill(e)
            espObjs[k] = nil
        end
    end
end

-- Supplied source: deployed mines are ToolsAdds.SubspaceTripmine<username>.
-- Track new/removing objects; no repeated full-workspace scan while enabled.
F.tripmines = { active = false, objects = {}, marks = {}, conns = {}, nextScan = 0 }
function F.tripmineRoot(object)
    if not object or not object:IsDescendantOf(Workspace) then return nil end
    local candidate, current = nil, object
    while current and current ~= Workspace do
        -- Held gear and character parts are not deployed tripmines.
        if current:IsA("Tool") or (current:IsA("Model") and current:FindFirstChildOfClass("Humanoid")) then return nil end
        if current:IsA("BasePart") or current:IsA("Model") then
            local name = current.Name:lower()
            if name:match("^subspacetripmine") or name:match("^tripmine") then candidate = current end
        end
        current = current.Parent
    end
    return candidate
end
function F.tripmineUnmark(mine)
    local mark = F.tripmines.marks[mine]
    if not mark then return end
    if mark.box then mark.box:Destroy() end
    if mark.tag then mark.tag:Destroy() end
    F.tripmines.marks[mine] = nil
end
function F.tripmineStop()
    local state = F.tripmines
    state.active = false
    for _, connection in ipairs(state.conns) do connection:Disconnect() end
    table.clear(state.conns)
    for mine in pairs(state.marks) do F.tripmineUnmark(mine) end
    table.clear(state.objects)
end
function F.tripmineTrack(object)
    if not F.tripmines.active or not FUNHUB_ALIVE() then return end
    local mine = F.tripmineRoot(object)
    if mine then F.tripmines.objects[mine] = true end
end
function F.tripmineOwner(mine)
    local name = mine.Name
    local prefix = name:lower():match("^(subspacetripmine)") or name:lower():match("^(tripmine)")
    local username = prefix and name:sub(#prefix + 1):gsub("^[%s_%-]+", "") or ""
    for _, owner in ipairs(Players:GetPlayers()) do
        if owner.Name:lower() == username:lower() or tostring(owner.UserId) == username then
            return "@" .. owner.Name, owner == LP
        end
    end
    return username ~= "" and ("@" .. username) or "Owner unknown", false
end
function F.tripmineSync()
    local state = F.tripmines
    if not U.get("mineEsp", false) or not FUNHUB_ALIVE() then
        if state.active then F.tripmineStop() end
        return false
    end
    if state.active then return true end
    state.active, state.nextScan = true, 0
    state.conns[#state.conns + 1] = Workspace.DescendantAdded:Connect(function(object)
        F.tripmineTrack(object)
        task.defer(function() F.tripmineTrack(object) end)
    end)
    state.conns[#state.conns + 1] = Workspace.DescendantRemoving:Connect(function(object)
        if state.objects[object] then
            state.objects[object] = nil
            F.tripmineUnmark(object)
        end
    end)
    for _, object in ipairs(Workspace:GetDescendants()) do F.tripmineTrack(object) end
    return true
end
function F.tripmineTick()
    if not F.tripmineSync() then return end
    local state = F.tripmines
    if os.clock() >= state.nextScan then
        state.nextScan = os.clock() + 2
        -- Catch mines named after parenting and replacement ToolsAdds folders.
        local folder = Workspace:FindFirstChild("ToolsAdds")
        for _, object in ipairs(folder and folder:GetDescendants() or {}) do F.tripmineTrack(object) end
        for _, object in ipairs(Workspace:GetChildren()) do F.tripmineTrack(object) end
    end
    local _, _, me = F.char()
    for mine in pairs(state.objects) do
        if F.tripmineRoot(mine) ~= mine then
            state.objects[mine] = nil
            F.tripmineUnmark(mine)
        else
            local part = mine:IsA("BasePart") and mine or mine:FindFirstChildWhichIsA("BasePart", true)
            if not part then
                F.tripmineUnmark(mine)
            else
                local mark = state.marks[mine]
                if mark and mark.part ~= part then F.tripmineUnmark(mine) mark = nil end
                if not mark then
                    mark = { part = part }
                    -- A handle adornment also marks fully transparent armed mines.
                    mark.box = new("BoxHandleAdornment", { Name = "FHTripmineMarker", Adornee = part,
                        AlwaysOnTop = true, ZIndex = 4, Transparency = 0.38 }, ESPF)
                    mark.tag = new("BillboardGui", { Name = "FHTripmineLabel", Adornee = part,
                        AlwaysOnTop = true, LightInfluence = 0, MaxDistance = 100000,
                        Size = UDim2.fromOffset(248, 46), StudsOffsetWorldSpace = Vector3.new(0, 2.2, 0) }, ESPF)
                    local card = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = rgb(10, 15, 23),
                        BackgroundTransparency = 0.18, BorderSizePixel = 0 }, mark.tag)
                    U.round(card, 7)
                    mark.stroke = new("UIStroke", { Thickness = 1, Transparency = 0.2 }, card)
                    mark.title = U.text("TextLabel", card, "TRIPMINE", 14, WB, C.BAD, Enum.TextXAlignment.Center)
                    mark.title.Position, mark.title.Size = UDim2.fromOffset(4, 3), UDim2.new(1, -8, 0, 20)
                    mark.detail = U.text("TextLabel", card, "", 12, WM, C.WHITE, Enum.TextXAlignment.Center)
                    mark.detail.Position, mark.detail.Size = UDim2.fromOffset(4, 24), UDim2.new(1, -8, 0, 18)
                    mark.detail.TextTruncate = Enum.TextTruncate.AtEnd
                    state.marks[mine] = mark
                end
                local owner, own = F.tripmineOwner(mine)
                local color = own and C.A2 or C.BAD
                mark.box.Size = Vector3.new(math.max(part.Size.X + 0.15, 0.7), math.max(part.Size.Y + 0.15, 0.25), math.max(part.Size.Z + 0.15, 0.7))
                mark.box.Color3, mark.stroke.Color, mark.title.TextColor3 = color, color, color
                mark.title.Text = own and "YOUR TRIPMINE" or "TRIPMINE"
                mark.detail.Text = owner .. (me and (" · " .. math.floor((part.Position - me.Position).Magnitude + 0.5) .. " studs") or "")
            end
        end
    end
end
R.cleanup[#R.cleanup + 1] = F.tripmineStop


local footNext, lastSteps = 0, {}
function F.espTick()
    F.tripmineTick()
    local alive = {}
    local _, _, me = F.char()
    local mePos = me and me.Position or Vector3.zero
    local chamBudget = 28
    if U.get("brEsp", false) then
        local rar = U.get("brRarities", { "OG", "Secret" })
        local list = F.brainrots()
        table.sort(list, function(a, b) return (a.model:GetPivot().Position - mePos).Magnitude < (b.model:GetPivot().Position - mePos).Magnitude end)
        for _, b in ipairs(list) do
            if table.find(rar, b.rarity) then
                local key = F.espKey("br", b.model)
                alive[key] = true
                local adorn = b.model.PrimaryPart or b.model:FindFirstChildWhichIsA("BasePart")
                if adorn then
                    local col = F.brColor(b.rarity)
                    local e = F.espEntry(key, b.model, adorn, U.get("brBoxMode", "Corner"), col, "brainrot")
                    local parts = {}
                    if U.get("brName", true) then parts[#parts + 1] = b.name end
                    if U.get("brGen", true) then parts[#parts + 1] = b.genText end
                    if U.get("brDist", true) then parts[#parts + 1] = math.floor((adorn.Position - mePos).Magnitude) .. "m" end
                    local _, size = b.model:GetBoundingBox()
                    local chams = U.get("brChams", true) and chamBudget > 0
                    if chams then chamBudget = chamBudget - 1 end
                    F.espPaint(e, col, chams, U.get("brBoxes", true), table.concat(parts, "\n"), math.max(size.X, size.Z), size.Y)
                end
            end
        end
    end
    if U.get("plEsp", false) then
        for _, p in ipairs(Players:GetPlayers()) do
            local ch = p ~= LP and p.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local key = "pl" .. p.UserId
                alive[key] = true
                local col = F.espColor(rgb(255, 255, 255))
                if p:GetAttribute("Stealing") then col = F.espColor(C.BAD) end
                local e = F.espEntry(key, ch, hrp, U.get("plBoxMode", "Corner"), col)
                local top = {}
                if U.get("plIcons", true) then
                    if U.get("iconAdmin", true) and (p:GetAttribute("Role") and p:GetAttribute("Role") ~= "Member") then top[#top + 1] = "👑" end
                    if U.get("iconGiant", true) and p:GetAttribute("GiantPotion") ~= nil then top[#top + 1] = "🧪" end
                    if U.get("iconFlash", true) and ch:FindFirstChild("Flash Teleport") then top[#top + 1] = "⚡" end
                end
                local lines = {}
                if #top > 0 then lines[#lines + 1] = table.concat(top, " ") end
                if U.get("plName", true) then lines[#lines + 1] = U.get("plDisplay", true) and p.DisplayName or p.Name end
                if U.get("plDist", true) then lines[#lines + 1] = math.floor((hrp.Position - mePos).Magnitude) .. "m" end
                if U.get("plStealTag", true) and p:GetAttribute("Stealing") then lines[#lines + 1] = "STEALING" end
                if U.get("plInvisTag", true) then
                    local head = ch:FindFirstChild("Head")
                    if head and (head.Transparency >= 0.95 or head.LocalTransparencyModifier >= 0.95) then lines[#lines + 1] = "INVISIBLE" end
                end
                local chams = U.get("plChams", true) and chamBudget > 0
                if chams then chamBudget = chamBudget - 1 end
                F.espPaint(e, col, chams, U.get("plBoxes", true), table.concat(lines, "\n"), 4, 5.5)
            end
        end
        if U.get("plFoot", false) and os.clock() >= footNext then
            footNext = os.clock() + 0.3
            local col = fromT(AC.footColor, rgb(78, 192, 255))
            for _, p in ipairs(Players:GetPlayers()) do
                local ch = p ~= LP and p.Character
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air then
                    local pos = hrp.Position - Vector3.new(0, hum.HipHeight + hrp.Size.Y / 2 - 0.05, 0)
                    if not lastSteps[p] or (lastSteps[p] - pos).Magnitude > 2 then
                        lastSteps[p] = pos
                        local s = new("Part", { Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, CastShadow = false,
                            Material = Enum.Material.Neon, Color = col, Size = Vector3.new(0.7, 0.08, 0.7), CFrame = CFrame.new(pos),
                            Shape = Enum.PartType.Cylinder }, WORLD)
                        s.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
                        s.Size = Vector3.new(0.08, 0.8, 0.8)
                        game:GetService("Debris"):AddItem(s, U.get("footLife", 4))
                    end
                end
            end
        end
    end
    if U.get("miscEsp", false) then
        for _, m in ipairs(Workspace:GetChildren()) do
            local isClone = U.get("cloneEsp", false) and m:IsA("Model") and m.Name:match("_Clone$") and not m.Name:find(tostring(LP.UserId), 1, true)
            if isClone then
                local adorn = m:IsA("BasePart") and m or m:FindFirstChildWhichIsA("BasePart", true)
                if adorn then
                    local key = F.espKey("misc", m)
                    alive[key] = true
                    local col = C.GOLD
                    local e = F.espEntry(key, m, adorn, "2D", col)
                    local chams = chamBudget > 0
                    if chams then chamBudget = chamBudget - 1 end
                    F.espPaint(e, col, chams, false, "CLONE")
                end
            end
        end
    end
    F.espSweep(alive)
end

local xrayed = {}
function F.xrayClear()
    F.xrayScanAt = 0
    for p in pairs(xrayed) do pcall(function() p.LocalTransparencyModifier = 0 end) end
    table.clear(xrayed)
end
function F.isAnimalPart(p)
    local m = p:FindFirstAncestorOfClass("Model")
    while m do
        if ANIMALS[m.Name] then return true end
        m = m.Parent and m.Parent:FindFirstAncestorOfClass("Model")
    end
    return false
end
function F.lockSecs(plot)
    local best = 0
    local pur = plot and plot:FindFirstChild("Purchases")
    for _, d in ipairs(pur and pur:GetDescendants() or {}) do
        if d:IsA("TextLabel") and d.Name == "RemainingTime" then
            local shown, p = d.Visible, d.Parent
            while shown and p and p ~= pur do
                if (p:IsA("GuiObject") and not p.Visible) or (p:IsA("LayerCollector") and not p.Enabled) then shown = false end
                p = p.Parent
            end
            local s = shown and tonumber(d.Text:match("(%d+)")) or 0
            if s > best then best = s end
        end
    end
    return best
end
local baseTags = {}
do
    local box = Instance.new("Part")
    box.Name = "SpeedRestoreBox"
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Size = Vector3.new(50, 10, 80)
    box.Parent = Workspace
    R.cleanup[#R.cleanup + 1] = function() pcall(function() box:Destroy() end) end
    R.rows[#R.rows + 1] = function()
        local my = findMyBase()
        local dh = my and my:FindFirstChild("DeliveryHitbox")
        if dh and box.Position ~= dh.Position then box.Position = dh.Position end
    end
end
function F.baseTick()
    local baseOn = U.get("baseEsp", false)
    local tAlive = {}
    if baseOn and U.get("baseTimer", true) then
        local plots = Workspace:FindFirstChild("Plots")
        for _, plot in ipairs(plots and plots:GetChildren() or {}) do
            local owner = F.ownerName(plot)
            local pur = owner ~= "?" and owner ~= "Empty Base" and plot:FindFirstChild("Purchases")
            local blocks = {}
            for _, b in ipairs(pur and pur:GetChildren() or {}) do
                local main = b.Name == "PlotBlock" and b:FindFirstChild("Main")
                if main and main:IsA("BasePart") then blocks[#blocks + 1] = main end
            end
            table.sort(blocks, function(a, b) return a.Position.Y < b.Position.Y end)
            if not U.get("timerFloors", false) then blocks = { blocks[1] } end
            for _, main in ipairs(blocks) do
                local gui = main:FindFirstChild("BillboardGui")
                local rt = gui and gui:FindFirstChild("RemainingTime")
                local shown, p = rt and rt.Visible, rt and rt.Parent
                while shown and p and p ~= main do
                    if (p:IsA("GuiObject") and not p.Visible) or (p:IsA("LayerCollector") and not p.Enabled) then shown = false end
                    p = p.Parent
                end
                local secs = shown and (tonumber(rt.Text:match("(%d+)")) or 0) or 0
                tAlive[main] = true
                local bb = baseTags[main]
                if not bb then
                    bb = new("BillboardGui", { Size = UDim2.fromOffset(120, 26), StudsOffsetWorldSpace = Vector3.new(0, 3, 0), AlwaysOnTop = true,
                        LightInfluence = 0, MaxDistance = 1e9, Adornee = main }, ESPF)
                    local l = U.text("TextLabel", bb, "", 20, WB, C.OPEN, Enum.TextXAlignment.Center)
                    l.Name = "L"
                    l.Size = UDim2.fromScale(1, 1)
                    l.TextStrokeTransparency = 0.4
                    baseTags[main] = bb
                end
                local l = bb.L
                if secs > 0 then
                    l.Text = string.format("LOCKED  %d:%02d", secs // 60, secs % 60)
                    l.TextColor3 = C.A2
                else
                    l.Text = "UNLOCKED"
                    l.TextColor3 = C.OPEN
                end
            end
        end
    end
    if baseOn and U.get("allowedTag", true) then
        for desc in pairs(FUNHUBUI.friendPrompts or {}) do
            local part = desc.Parent and FUNHUBUI.promptPart(desc)
            local allowed = part and FUNHUBUI.friendPromptState(desc) == true
            if allowed then
                tAlive[part] = true
                if not baseTags[part] then
                    local bb = new("BillboardGui", { Size = UDim2.fromOffset(16, 16), StudsOffsetWorldSpace = Vector3.new(0, 9, 0), AlwaysOnTop = true,
                        LightInfluence = 0, MaxDistance = 1e9, Adornee = part }, ESPF)
                    local f = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.OPEN, BorderSizePixel = 0 }, bb)
                    U.round(f, 0.5, true)
                    local t = U.text("TextLabel", f, "✓", 12, WB, C.WIN, Enum.TextXAlignment.Center)
                    t.Size = UDim2.fromScale(1, 1)
                    baseTags[part] = bb
                end
            end
        end
    end
    for k, bb in pairs(baseTags) do if not tAlive[k] then bb:Destroy() baseTags[k] = nil end end
    if baseOn and U.get("xray", false) then
        local t = U.get("xrayT", 0.7)
        if os.clock() >= (F.xrayScanAt or 0) then
            F.xrayScanAt = os.clock() + (IsMobile and 1.5 or 0.5)
            for _, plot in ipairs(F.enemyPlots()) do
                for _, d in ipairs(plot:GetDescendants()) do
                    if d:IsA("BasePart") and d.Transparency < 1 and not xrayed[d] and not d:IsDescendantOf(plot.AnimalPodiums)
                        and d.Name ~= "Spawn" and not F.isAnimalPart(d) then
                        xrayed[d] = true
                    end
                end
            end
        end
        for p in pairs(xrayed) do
            if not p.Parent then xrayed[p] = nil
            elseif p.LocalTransparencyModifier ~= t then p.LocalTransparencyModifier = t end
        end
    elseif next(xrayed) then
        F.xrayClear()
    end
    local ch = LP.Character
    if U.get("miscEsp", false) and U.get("selfChams", false) and ch then
        if not F.selfHl or F.selfHl.Adornee ~= ch then
            if F.selfHl then F.selfHl:Destroy() end
            F.selfHl = new("Highlight", { Adornee = ch, FillColor = C.A2, OutlineColor = C.A1, FillTransparency = 0.6,
                DepthMode = Enum.HighlightDepthMode.Occluded }, ESPF)
        end
    elseif F.selfHl then
        F.selfHl:Destroy() F.selfHl = nil
    end
    F.baseHud()
    if MYBASE.Visible then
        local text, secs, relock = F.baseTimerRead(F.quickGrab.OwnPlot())
        F.baseLbl.Text = text
        F.baseLbl.TextSize = secs == nil and 12 or 17
        F.baseLbl.TextColor3 = secs == nil and C.DIM or relock and C.WARN or secs == 0 and C.OPEN
            or secs <= 15 and C.BAD or secs <= 60 and C.WARN or C.TEXT
    end
end

pcall(function()
    darkBlueHighlight.FillTransparency = 1
    darkBlueHighlight.OutlineColor = rgb(255, 45, 45)
    darkBlueHighlight.OutlineTransparency = 0
    darkBlueHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end)
local petMark = new("Highlight", { FillTransparency = 1, OutlineColor = rgb(255, 205, 45), OutlineTransparency = 0,
    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Enabled = false }, ESPF)
function F.targetTick()
    local pod = darkBlueHighlight and darkBlueHighlight.Adornee
    local sp = pod and pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
    local plot = pod and pod.Parent and pod.Parent.Parent
    local best, bd = nil, 14
    if sp and plot then
        for _, m in ipairs(plot:GetChildren()) do
            if m:IsA("Model") and ANIMALS[m.Name] then
                local d = (m:GetPivot().Position - sp.Position).Magnitude
                if d < bd then best, bd = m, d end
            end
        end
    end
    petMark.Adornee = best
    petMark.Enabled = best ~= nil
end

function F.alignCam()
    local pod = darkBlueHighlight and darkBlueHighlight.Adornee
    local cam, _, _, hrp = Workspace.CurrentCamera, F.char()
    if not (pod and cam and hrp) then return end
    local focus = hrp.Position
    local dir = pod:GetPivot().Position - focus
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 0.1 then return end
    local back = (cam.CFrame.Position - focus)
    local dist, height = Vector3.new(back.X, 0, back.Z).Magnitude, back.Y
    local pos = focus - dir.Unit * math.max(dist, 4) + Vector3.new(0, height, 0)
    cam.CFrame = CFrame.lookAt(pos, focus + dir.Unit * 8)
end

local STRETCH_BIND = "FUNHUBStretch"
pcall(RunService.UnbindFromRenderStep, RunService, STRETCH_BIND)
RunService:BindToRenderStep(STRETCH_BIND, Enum.RenderPriority.Camera.Value + 1, function()
    local s = U.get("stretch", 1)
    if F.cfg("customFovEnabled") and s < 0.999 then
        local cam = Workspace.CurrentCamera
        if cam then cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, s, 0, 0, 0, 1) end
    end
end)
R.cleanup[#R.cleanup + 1] = function() pcall(RunService.UnbindFromRenderStep, RunService, STRETCH_BIND) end

function F.muteTick()
    local _, _, hrp = F.char()
    local s = hrp and hrp:FindFirstChild("Running")
    if s and s:IsA("Sound") then
        if U.get("muteWalk", false) then
            if s.Volume > 0 then s:SetAttribute("FHVol", s.Volume) s.Volume = 0 end
        elseif s:GetAttribute("FHVol") then
            s.Volume = s:GetAttribute("FHVol")
            s:SetAttribute("FHVol", nil)
        end
    end
end

pcall(function()
    local cmds = ReplicatedStorage:FindFirstChild("AdminCommands", true)
    for _, name in ipairs(F.CMDS) do
        local mod = cmds and cmds:FindFirstChild(name)
        if mod then
            local m = require(mod)
            if type(m.effects) == "table" and type(m.effects.Victim) == "function" then
                local prev = m.effects.Victim
                m.effects.Victim = function(...)
                    if FUNHUB_ALIVE() and table.find(U.get("autoResetCmds", {}), name) then
                        task.spawn(F.instaReset)
                    end
                    return prev(...)
                end
            end
        end
    end
end)

local lastRagReset = 0
function F.ragdollTick()
    if not U.get("resetRagdoll", false) or os.clock() - lastRagReset < 3 then return end
    local _, hum = F.char()
    local ended = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
    local now = workspace:GetServerTimeNow()
    if (hum and hum:GetState() == Enum.HumanoidStateType.Physics) or ended > now then
        lastRagReset = os.clock()
        F.instaReset()
    end
end

local autoSpeedArmed = false
U.on(LP:GetAttributeChangedSignal("Stealing"), function()
    if not FUNHUB_ALIVE() then return end
    if F.stealing() then
        if U.get("autoSpeed", false) and not U.get("speedMaster", F.speedMasterDef) then
            autoSpeedArmed = true
            U.set("speedMaster", true) F.speedSync()
            for _, f in ipairs(R.rows) do pcall(f) end
        end
    elseif autoSpeedArmed then
        autoSpeedArmed = false
        U.set("speedMaster", false) F.speedSync()
        for _, f in ipairs(R.rows) do pcall(f) end
    end
    FUNHUBHold.checkSemiPickup()
end)
U.on(RunService.Heartbeat, FUNHUBHold.checkSemiPickup)
U.on(LP.CharacterRemoving, function() FUNHUBHold.pendingSemiPickup = nil end)
R.cleanup[#R.cleanup + 1] = function() FUNHUBHold.pendingSemiPickup = nil end

function F.goBaseTick()
    if not (U.get("autoGoBase", false) or U.get("autoWalkSteal", false)) or not F.stealing() or _G.FUNHUB_SemiTP_Busy then return end
    local my = F.myPlot()
    local dh = my and my:FindFirstChild("DeliveryHitbox")
    local _, hum = F.char()
    if dh and hum then hum:MoveTo(dh.Position) end
end

-- One selection owns the exact prompt used by normal and public auto grab.
do
    local S = { items = {}, scanAt = 0, mode = nil, pick = nil }
    F.autoTarget = S
    function F.autoMode()
        if U.get("autoPriority", false) then return "Priority" end
        if U.get("autoBest", false) then return "Best" end
        if U.get("autoGrab", false) or U.get("autoNearest", false) then return "Nearest" end
    end
    -- Supplied DatShawn scanner: follow the podium's prompt/attachment directly.
    -- Streamed animal models and sign text are not required for nearest Autograb.
    function F.scanSourceGrab()
        local out, plots = {}, Workspace:FindFirstChild("Plots")
        for _, plot in ipairs(plots and plots:GetChildren() or {}) do
            local sign = plot:FindFirstChild("PlotSign")
            local marker = sign and sign:FindFirstChild("YourBase")
            local own = marker and marker.Enabled == true
            local pods = not own and plot:FindFirstChild("AnimalPodiums")
            for _, pod in ipairs(pods and pods:GetChildren() or {}) do
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                for _, prompt in ipairs(spawn and spawn:GetDescendants() or {}) do
                    if prompt:IsA("ProximityPrompt") and prompt.Enabled and prompt.ObjectText ~= ""
                        and tostring(prompt.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") == "steal" then
                        out[#out + 1] = { sourcePrompt = prompt, plot = plot, podium = pod, spawn = spawn,
                            name = prompt.ObjectText, slot = tonumber(pod.Name) or 0, gen = 0 }
                        break
                    end
                end
            end
        end
        return out
    end
    function F.priorityList()
        local clean, seen = {}, {}
        for _, name in ipairs(type(AC.priority) == "table" and AC.priority or {}) do
            if type(name) == "string" and name ~= "" and not seen[name] then
                clean[#clean + 1], seen[name] = name, true
            end
        end
        AC.priority = clean
        return clean
    end
    function F.targetPrompt(item)
        if item and item.sourcePrompt then
            local p = item.sourcePrompt
            local sign = item.plot and item.plot:FindFirstChild("PlotSign")
            local marker = sign and sign:FindFirstChild("YourBase")
            if not item.plot or not item.plot.Parent or (marker and marker.Enabled)
                or not item.spawn or not item.spawn:IsDescendantOf(item.plot)
                or not p.Parent or not p:IsDescendantOf(item.spawn) or not p.Enabled
                or p.ObjectText ~= item.name
                or tostring(p.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") ~= "steal" then return nil end
            return p
        end
        if not item or not item.plot or not item.plot.Parent or not isEnemyPlot(item.plot)
            or not item.model or not item.model.Parent or not item.model:IsDescendantOf(item.plot)
            or item.model.Name ~= item.name or not item.slot then return nil end
        local pods = item.plot:FindFirstChild("AnimalPodiums")
        local pod = pods and pods:FindFirstChild(tostring(item.slot))
        local spawn, prompt = podiumParts(pod)
        if spawn ~= item.spawn or not prompt or not prompt.Enabled
            or tostring(prompt.ActionText):gsub("<[^>]+>", ""):lower():match("^%s*(.-)%s*$") ~= "steal"
            or (item.model:GetPivot().Position - spawn.Position).Magnitude > 14 then return nil end
        return prompt
    end
    function F.invalidateAutoTarget()
        S.pick, S.scanAt, S.mode = nil, 0, nil
        FUNHUBHold.clearAuto()
    end
    function F.selectAutoPrompt(hrp, maxD)
        local mode = F.autoMode()
        if FUNHUBFx.backgroundPaused() then return nil, math.huge, true end
        if not mode then S.pick, S.mode = nil, nil return nil, math.huge, false end
        local ranks = {}
        for rank, name in ipairs(F.priorityList()) do ranks[name] = rank end
        local function eligible(item)
            if mode == "Priority" and not ranks[item.name] then return nil end
            local prompt = F.targetPrompt(item)
            if not prompt then return nil end
            local position = FUNHUBHold.promptPosition(prompt) or item.spawn.Position
            local distance = (position - hrp.Position).Magnitude
            if distance > maxD then return nil end
            return prompt, distance
        end
        if mode ~= "Nearest" and S.mode == mode and S.pick then
            local prompt, distance = eligible(S.pick)
            local ctx = FUNHUBHold.publicContext or FUNHUBHold.normalContext
            if prompt and ctx and ctx.prompt == prompt and FUNHUBHold.valid(ctx) and FUNHUBHold.inRange(ctx) then
                return prompt, distance, true
            end
        end
        local now = os.clock()
        if now >= S.scanAt or S.mode ~= mode then
            S.items, S.scanAt = mode == "Nearest" and F.scanSourceGrab() or F.brainrots(), now + (IsMobile and 0.45 or (mode == "Nearest" and 0.3 or 0.2))
        end
        local pick, pickedPrompt, pickedDistance, pickedNear, pickedRank
        for _, item in ipairs(S.items) do
            local prompt, distance = eligible(item)
            if prompt then
                local near = distance <= math.min(9, tonumber(prompt.MaxActivationDistance) or 9)
                local rank = ranks[item.name] or math.huge
                local better = pick == nil
                if pick then
                    if near ~= pickedNear then better = near
                    elseif mode == "Priority" and rank ~= pickedRank then better = rank < pickedRank
                    elseif mode == "Best" and item.gen ~= pick.gen then better = item.gen > pick.gen
                    elseif math.abs(distance - pickedDistance) > 0.05 then better = distance < pickedDistance
                    elseif item.gen ~= pick.gen then better = item.gen > pick.gen
                    elseif item.plot.Name ~= pick.plot.Name then better = item.plot.Name < pick.plot.Name
                    else better = item.slot < pick.slot end
                end
                if better then pick, pickedPrompt, pickedDistance, pickedNear, pickedRank = item, prompt, distance, near, rank end
            end
        end
        S.pick, S.mode = pick, mode
        -- No selected match means wait, never steal a random non-selected brainrot.
        return pickedPrompt, pickedDistance or math.huge, true
    end
    FUNHUBHold.selectAutoPrompt = F.selectAutoPrompt
    function F.autoStealTick()
        if not F.autoMode() or F.stealing() or FUNHUB.debounce or FUNHUBFx.backgroundPaused() then return end
        local _, hum, hrp = F.char()
        if not (hum and hrp) or hum.Health <= 0 then return end
        F.selectAutoPrompt(hrp, 2000)
    end
    R.cleanup[#R.cleanup + 1] = function()
        if FUNHUBHold.selectAutoPrompt == F.selectAutoPrompt then FUNHUBHold.selectAutoPrompt = nil end
        S.items, S.pick = {}, nil
    end
end

local lastDefense, lastAlarm, lastIntruder, knownPlayers, defBusy = 0, {}, {}, #Players:GetPlayers(), false
local function allOnCooldown(list)
    if type(list) ~= "table" or #list == 0 then return false end
    for _, c in ipairs(list) do if F.cmdCooldown(c) <= 0 then return false end end
    return true
end
local function fireList(list, target)
    local any = false
    for _, c in ipairs(list or {}) do
        if not target.Parent then break end
        if F.adminCmd(c, target) then any = true end
        task.wait(0.35)
    end
    return any
end
local function safety(k) return U.get("safetyKick", true) and U.get(k, false) end
function F.defenseTick()
    local my = F.myPlot()
    if not my then return end
    local centre = my:GetPivot().Position
    local on = U.get("autoDefense", false)
    local thieves, inBase = {}, {}
    for _, p in ipairs(Players:GetPlayers()) do
        local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if r then
            local d = (r.Position - centre).Magnitude
            if d < 70 then
                inBase[#inBase + 1] = p
                if U.get("intruder", false) and (not lastAlarm[p] or os.clock() - lastAlarm[p] > 15) then
                    lastAlarm[p] = os.clock()
                    U.notify("Intruder Alarm", p.DisplayName .. " is in your base")
                    local flash = Instance.new("ScreenGui")
                    flash.Name = "IntruderFlash"
                    flash.DisplayOrder = 100
                    flash.Parent = LP:FindFirstChild("PlayerGui") or root
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 0, 50)
                    lbl.Position = UDim2.new(0, 0, 0, 80)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "⚠ " .. p.DisplayName .. " IS IN YOUR BASE ⚠"
                    lbl.TextColor3 = Color3.fromRGB(255, 30, 30)
                    lbl.Font = Enum.Font.GothamBlack
                    lbl.TextSize = 32
                    lbl.TextStrokeTransparency = 0.5
                    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    lbl.Parent = flash
                    task.delay(4, function() if flash then flash:Destroy() end end)
                end
                if p:GetAttribute("Stealing") then thieves[#thieves + 1] = { p = p, d = d } end
            end
        end
    end
    if on and not defBusy and #thieves > 0 and os.clock() - lastDefense > 2 then
        lastDefense = os.clock()
        table.sort(thieves, function(a, b) return a.d < b.d end)
        defBusy = true
        task.spawn(function()
            local t1, t2 = thieves[1].p, thieves[2] and thieves[2].p
            if not t2 then
                local c1 = U.get("defCmds1", { "balloon" })
                if not allOnCooldown(c1) then
                    if fireList(c1, t1) and table.find(c1, "balloon") and safety("leaveBalloon") then
                        task.delay(0.3, function() LP:Kick("Left because balloon has been used (FUNHUB Safety Kick)") end)
                    end
                else
                    fireList(U.get("defCmds2", { "ragdoll", "rocket", "inverse", "tiny", "jumpscare" }), t1)
                    if safety("kickNoCmds") then
                        task.delay(0.3, function() LP:Kick("No balloon/ragdoll available (FUNHUB Safety Kick)") end)
                    end
                end
            else
                task.spawn(fireList, U.get("defMulti1", { "balloon" }), t1)
                fireList(U.get("defMulti2", { "ragdoll", "rocket", "inverse", "tiny" }), t2)
            end
            defBusy = false
        end)
    end
    if on and U.get("antiIntruder", false) and not defBusy then
        for _, p in ipairs(inBase) do
            if not lastIntruder[p] or os.clock() - lastIntruder[p] > 3 then
                lastIntruder[p] = os.clock()
                task.spawn(fireList, U.get("intruderCmds", { "balloon" }), p)
            end
        end
    end
    local n = #Players:GetPlayers()
    if on and safety("kick3rd") and n >= 3 and knownPlayers < 3 then
        LP:Kick("A 3rd player joined (FUNHUB Safety Kick)")
    end
    knownPlayers = n
end

function F.carpetTick()
    if potionState.busy or _G.FUNHUB_SemiTP_ResetBusy then return end
    if not (U.get("carpetEquip", false) and F.cfg("carpetSpeedEnabled")) or F.stealing() or _G.FUNHUB_SemiTP_Busy then return end
    local ch, hum = F.char()
    if not (ch and hum) or ch:FindFirstChildOfClass("Tool") then return end
    local ok, t = pcall(findFlyGear)
    if ok and t and t.Parent ~= ch then pcall(function() hum:EquipTool(t) end) end
end

function F.antiLogger(on)
    local env = ENV
    if on and not F.realRequest then
        for _, n in ipairs({ "request", "http_request" }) do
            local orig = env[n]
            if type(orig) == "function" then
                F.realRequest = F.realRequest or {}
                F.realRequest[n] = orig
                env[n] = function(opts)
                    local url = type(opts) == "table" and tostring(opts.Url or opts.url or "") or ""
                    if url:find("discord", 1, true) and url:find("webhook", 1, true) or url:find("ipify", 1, true) or url:find("grabify", 1, true) then
                        return { StatusCode = 403, Success = false, Body = "" }
                    end
                    return orig(opts)
                end
            end
        end
    elseif not on and F.realRequest then
        for n, f in pairs(F.realRequest) do env[n] = f end
        F.realRequest = nil
    end
end
if U.get("antiLogger", false) then F.antiLogger(true) end
R.cleanup[#R.cleanup + 1] = function() F.antiLogger(false) end

local frames, frameTime = 0, 0
U.on(RunService.RenderStepped, function(dt) frames = frames + 1 frameTime = frameTime + dt end)
function F.dataPing()
    local ok, v = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    if ok and tonumber(v) then return v end
    local ok2, p = pcall(function() return LP:GetNetworkPing() * 2000 end)
    return ok2 and p or 0
end
function F.pushSample(col, v, fmt, goodHigh)
    local s = col.samples
    s[#s + 1] = v
    while #s > #col.bars do table.remove(s, 1) end
    local lo, hi, sum = math.huge, 0, 0
    for _, x in ipairs(s) do lo = math.min(lo, x) hi = math.max(hi, x) sum = sum + x end
    col.lo.Text = string.format(fmt, math.floor(lo + 0.5))
    col.hi.Text = string.format(fmt, math.floor(hi + 0.5))
    col.st.Text = string.format("Avg " .. fmt .. "  ·  %d samples", math.floor(sum / #s + 0.5), #s)
    for i, b in ipairs(col.bars) do
        local x = s[#s - #col.bars + i]
        b.Size = UDim2.new(b.Size.X.Scale, -1, x and math.clamp(x / math.max(hi, 1), 0.04, 1) or 0, 0)
    end
end
function F.statColor(v, good, ok, higherIsBetter)
    if higherIsBetter then return v >= good and C.GOOD or (v >= ok and C.WARN or C.BAD) end
    return v <= good and C.GOOD or (v <= ok and C.WARN or C.BAD)
end

local alive = true
local function unload()
    if not alive then return end
    alive = false
    for _, c in ipairs(R.conns) do pcall(function() c:Disconnect() end) end
    for _, f in ipairs(R.cleanup) do pcall(f) end
    F.espReset()
    F.xrayClear()
    pcall(function() gui:Destroy() end)
end
ENV.__FHUnload = unload

function F.resetConfig()
    F.smallSpeed.Cancel()
    F.setSemiTP(false)
    F.quickGrab.SetEnabled(false)
    F.setCfg("autoRejoinEnabled", false)
    F.stopBaseRejoin()
    F.setCfg("kickAfterStealEnabled", false)
    F.setCfg("publicGrabEnabled", false)
    F.baseLeave.left = false
    for k in pairs(AC) do if k ~= "pos" and k ~= "keys" and k ~= "keysInit" then AC[k] = nil end end
    AC.keys, AC.keysInit, AC.keybindSchema = {}, true, 2
    HubConfig.stealKeybind = "None"
    currentStealKey = nil
    AC.funhubV14Colors = true
    C.A1, C.A2 = rgb(40, 128, 255), rgb(78, 192, 255)
    U.setFont("Gotham")
    U.applyTransparency()
    F.speedSync() F.miscSync() F.semiSync()
    F.quickGrabSync() F.cameraSync() F.movementSync() F.basePlayersTick() F.autoPotionSync()
    F.autoGrabSync()
    F.tradeSync()
    if F.publicSync then F.publicSync() end
    AC.funhub55GuiMigrated = true
    U.applyTheme("Funhub 5.5", true)
    U.notify("Reset Config", "Hub settings are back to default")
end
function F.panic()
    F.smallSpeed.Shutdown()
    F.grappleSemi.Shutdown()
    F.setAutoGrab(false)
    for _, key in ipairs({ "moveSpeedEnabled", "carpetSpeedEnabled", "infJumpEnabled", "gravityEnabled", "aimbotEnabled", "autoSpamEnabled",
        "destroySentryEnabled", "destroyDogeEnabled", "customFovEnabled", "baseXrayEnabled", "playerEspEnabled", "tracersEnabled",
        "serverGhostEnabled", "publicGrabEnabled", "defenderBypassEnabled" }) do
        pcall(function() if F.cfg(key) then F.setCfg(key, false) end end)
    end
    _G.FUNHUB_SemiTP_SpeedBoost = false
    FUNHUBFx.potionSpeed = false
    potionState.stop()
    Workspace.Gravity = 196.2
    if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 70 end
    ENV.FUNHUB_SemiTP_Gen = (tonumber(ENV.FUNHUB_SemiTP_Gen) or 0) + 1
    pcall(function() game:GetService("ContextActionService"):UnbindAction("FUNHUB_SemiTP_StealKey") end)
    for _, g in ipairs({ ScreenGui, ProgressGui, SpeedScreenGui, AllowDisallowGui }) do pcall(function() g:Destroy() end) end
    unload()
end

U.on(RunService.Heartbeat, function()
    if U.get("baseLine", false) then
        local my = findMyBase()
        local dh = my and my:FindFirstChild("DeliveryHitbox")
        local _, _, hrp = F.char()
        if dh and hrp then
            local line = Workspace:FindFirstChild("BaseLine")
            if not line then
                line = Instance.new("Part")
                line.Name = "BaseLine"
                line.Anchored = true
                line.CanCollide = false
                line.Material = Enum.Material.Neon
                line.Color = Color3.new(1, 1, 1)
                line.Parent = Workspace
            end
            local mid = (hrp.Position + dh.Position) / 2
            local dist = (hrp.Position - dh.Position).Magnitude
            line.Size = Vector3.new(0.3, 0.3, dist)
            line.CFrame = CFrame.lookAt(mid, dh.Position)
        end
    end
    if not alive then return end
    local now = os.clock()
    if not IsMobile and (R.lastGradientTheme ~= U.activeTheme
        or (U.activeTheme == "Aurora Hub" and now >= (R.gradientAt or 0))) then
        R.gradientAt, R.lastGradientTheme = now + 0.1, U.activeTheme
        local rot = U.activeTheme == "Aurora Hub" and (now * 45) % 360 or U.activeTheme == "Funhub 5.5" and 205.421 or 0
        for _, g in ipairs(R.sg) do if g.Parent then g.Rotation = rot end end
    end
    if now < (R.progressAt or 0) then return end
    R.progressAt = now + (IsMobile and 1 / 15 or 1 / 30)
    local ratio, source, label, phase, confirmed = FUNHUBHold.progressView()
    F.renderGrabProgress(ratio, source, label, phase, confirmed)
    if ProgressGui.Enabled then
        if progressFill then progressFill.Size = UDim2.fromScale(ratio, 1) end
        if percentLabel then percentLabel.Text = math.floor(ratio * 100) .. "%" end
    end
    if source == "Autograb" and F.stealing() then F.bar.detail.Text = "Carrying" end

end)

task.spawn(function()
    local tick5, tick1, visualTick = 0, 0, 0
    while alive do
        if not FUNHUB_ALIVE() or not gui.Parent then unload() break end
        F.backgroundPauseTick()
        local now = os.clock()
        if now - tick5 >= 0.2 then
            tick5 = now
            pcall(F.baseLeaveTick)
            pcall(F.ragdollTick)
            pcall(F.carpetTick)
        end
        if now - visualTick >= (IsMobile and 0.4 or 0.2) then
            visualTick = now
            pcall(F.deliveryESPTick)
            pcall(F.espTick)
            pcall(F.targetTick)
            pcall(F.muteTick)
            pcall(F.refreshSemiPicker)
        end
        if now - tick1 >= (IsMobile and 0.75 or 0.5) then
            local dt = now - tick1
            tick1 = now
            local fps = frameTime > 0 and frames / frameTime or 0
            frames, frameTime = 0, 0
            local ping = F.dataPing()
            if F.themeStats then F.themeStats.Text = string.format("FPS: %d   PING: %dms", math.floor(fps + 0.5), math.floor(ping + 0.5)) end
            F.statsLabels.fps.Text = math.floor(fps + 0.5) .. " fps"
            F.statsLabels.fps.TextColor3 = F.statColor(fps, 50, 30, true)
            F.statsLabels.ping.Text = math.floor(ping + 0.5) .. " ms"
            F.statsLabels.ping.TextColor3 = F.statColor(ping, 120, 250, false)
            if statsPanel.Visible and U.get("performanceHud", true) then
                F.pushSample(F.fpsCol, fps, "%d", true)
                F.pushSample(F.pingCol, ping, "%d", false)
            end
            pcall(F.publicSync)
            pcall(F.tradeSync)
            pcall(F.baseTick)
            pcall(F.basePlayersTick)
            pcall(F.goBaseTick)
            pcall(F.autoStealTick)
            pcall(F.defenseTick)
            pcall(F.renderPriority)
            for _, f in ipairs(R.rows) do pcall(f) end
            if CD.Visible then
                for cmd, l in pairs(F.cdRows) do
                    local s = F.cmdCooldown(cmd)
                    l.Text = F.cooldownText(s)
                    l.TextColor3 = s > 0 and C.WARN or C.GOOD
                end
            end
            local _ = dt
        end
        task.wait(0.05)
    end
end)

if not AC.firstRun then
    AC.firstRun = true
    pcall(F.setCfg, "pillBarEnabled", false)
    pcall(F.setCfg, "thiefBarEnabled", false)
end
U.applyTransparency()
F.speedSync()
F.miscSync()
F.semiSync()
F.quickGrabSync()
F.cameraSync()
F.autoPotionSync()
F.movementSync()
F.autoGrabSync()
F.tradeSync()
F.publicSync()
U.applyTheme(AC.guiTheme or "Funhub 5.5", true)
for _, f in ipairs(R.rows) do pcall(f) end
if PROF.autoload and PROF.autoload ~= "None" and PROF.list[PROF.autoload] and not ENV.__FHAutoloaded then
    ENV.__FHAutoloaded = true
    task.defer(function() F.applySnapshot(PROF.list[PROF.autoload]) PROF.active = PROF.autoload end)
end
U.notify("FUNHUB V1.4", "Loaded. Left Ctrl toggles the menu. Right-click buttons to set keybinds.", 5)
print("[FUNHUB] loaded")

-- Recover paused/missing locomotion without stopping carry or tool animations.
do
    local W = { links = {}, stopped = false, nextCheck = 0 }
    F.walkAnimation = W
    function W.release()
        if W.fallback then
            pcall(function() W.fallback:Stop(0.12) W.fallback:Destroy() end)
            W.fallback, W.source = nil, nil
        end
        W.missingSince = nil
    end
    function W.clear()
        W.release()
        W.char, W.hum, W.animator, W.animate = nil, nil, nil, nil
        W.ids, W.walk, W.run, W.scanAt = {}, nil, nil, 0
    end
    function W.scan(animate)
        W.ids, W.walk, W.run = {}, nil, nil
        for _, group in ipairs(animate:GetChildren()) do
            local name = group.Name:lower()
            if name == "walk" or name == "run" then
                for _, anim in ipairs(group:GetDescendants()) do
                    if anim:IsA("Animation") and anim.AnimationId ~= "" then
                        W.ids[anim.AnimationId] = true
                        if name == "walk" then W.walk = W.walk or anim else W.run = W.run or anim end
                    end
                end
            end
        end
    end
    function W.isLocomotion(track)
        local anim = track.Animation
        local name = tostring(track.Name):lower()
        local animName = anim and anim.Name:lower() or ""
        return (anim and W.ids[anim.AnimationId]) or name == "walk" or name == "run"
            or animName == "walkanim" or animName == "runanim"
    end
    function W.step()
        if W.stopped then return end
        if not FUNHUB_ALIVE() then W.stop() return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        local animate = char and char:FindFirstChild("Animate")
        if char ~= W.char or hum ~= W.hum or animator ~= W.animator or animate ~= W.animate then
            W.clear()
            W.char, W.hum, W.animator, W.animate = char, hum, animator, animate
        end
        if not (char and hum and hrp and animator and animate) or hum.Health <= 0
            or animate.Disabled or hrp.Anchored or hum.Sit or hum.PlatformStand
            or _G.FUNHUB_SemiTP_Busy or _G.FUNHUB_SemiTP_ResetBusy or _G.FUNHUB_SemiTP_InputLock
            or hum.FloorMaterial == Enum.Material.Air then W.release() return end
        local state = hum:GetState()
        if state ~= Enum.HumanoidStateType.Running and state ~= Enum.HumanoidStateType.RunningNoPhysics
            and state ~= Enum.HumanoidStateType.Landed then W.release() return end
        local motion = FUNHUBFx.motion
        if motion and motion.flyTool(char) and not isStealBoostLive() then W.release() return end
        local vel = hrp.AssemblyLinearVelocity
        local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
        if hum.MoveDirection.Magnitude < 0.05 or hum.WalkSpeed <= 0 or speed < 2 then W.release() return end
        local now = os.clock()
        if now >= W.scanAt then W.scan(animate) W.scanAt = now + 0.5 end
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if track ~= W.fallback and track.IsPlaying and W.isLocomotion(track)
                and (track.Priority == Enum.AnimationPriority.Core or track.Priority == Enum.AnimationPriority.Movement) then
                if track.Speed <= 0.01 then track:AdjustSpeed(1) end
                if track.WeightCurrent > 0.01 then W.release() return end
            end
        end
        W.missingSince = W.missingSince or now
        if now - W.missingSince < 0.35 then return end
        local source = speed >= 16 and (W.run or W.walk) or (W.walk or W.run)
        if not source then return end -- Use the avatar's own animation assets only.
        if W.fallback and W.source ~= source then W.release() W.missingSince = now end
        if not W.fallback then
            W.fallback = animator:LoadAnimation(source)
            W.source = source
            W.fallback.Looped = true
            W.fallback.Priority = Enum.AnimationPriority.Movement
        end
        local rate = math.clamp(speed / 16, 0.25, 2)
        if not W.fallback.IsPlaying then W.fallback:Play(0.12, 1, rate)
        else W.fallback:AdjustSpeed(rate) end
    end
    function W.stop()
        if W.stopped then return end
        W.stopped = true
        W.clear()
        for _, link in ipairs(W.links) do link:Disconnect() end
        table.clear(W.links)
    end
    W.clear()
    W.links[#W.links + 1] = RunService.Heartbeat:Connect(function()
        if os.clock() < W.nextCheck then return end
        W.nextCheck = os.clock() + 0.15
        local ok, err = pcall(W.step)
        if not ok then
            W.release()
            if not W.warned then W.warned = true warn("[FUNHUB walk animation] " .. tostring(err)) end
        end
    end)
    W.links[#W.links + 1] = LP.CharacterRemoving:Connect(W.clear)
    W.links[#W.links + 1] = LP.CharacterAdded:Connect(W.clear)
    R.cleanup[#R.cleanup + 1] = W.stop
end

end)()