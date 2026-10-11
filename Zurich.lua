-- ==================== SERVICIOS ====================
local game = game
local workspace = workspace
local math = math
local task = task
local string = string
local table = table
local coroutine = coroutine
local pcall = pcall
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local tostring = tostring
local setmetatable = setmetatable
local Vector3 = Vector3
local Vector2 = Vector2
local CFrame = CFrame
local Color3 = Color3
local UDim2 = UDim2
local UDim = UDim
local Enum = Enum
local Instance = Instance

task.wait(0.1)
repeat task.wait() until game:IsLoaded()

local Players             = game:GetService("Players")
local UserInputService    = game:GetService("UserInputService")
local TweenService        = game:GetService("TweenService")
local RunService          = game:GetService("RunService")
local Lighting            = game:GetService("Lighting")
local Player              = Players.LocalPlayer
local CONFIG_FILE         = "ZurichHub_Config.txt"
local _skipNextCtrlToggle = false

local function isStreamerModeEnabledAtBoot()
    local data = nil
    local ok, result = pcall(readfile, CONFIG_FILE)
    if ok and result and #result > 0 then
        data = result
    elseif _G["_ZurichHub_Data"] and #tostring(_G["_ZurichHub_Data"]) > 0 then
        data = tostring(_G["_ZurichHub_Data"])
    end
    if not data then return false end
    for line in data:gmatch("[^\n]+") do
        if line == "F:StreamerMode=true" then
            return true
        end
    end
    return false
end

if isStreamerModeEnabledAtBoot() then
    local isTouchOnly = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    if not isTouchOnly then
        local unlocked = false
        local unlockConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.RightControl then
                unlocked = true
                _skipNextCtrlToggle = true
                if unlockConn then unlockConn:Disconnect() end
            end
        end)
        -- ESPERA INDEFINIDA hasta que se pulse RightControl
        repeat task.wait() until unlocked
    else
        -- En móvil no existe RightControl, permitimos carga normal (sin bloqueo)
        _skipNextCtrlToggle = true
    end
end
-- ==================== FPS BOOST ====================
do
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        pcall(function()
            terrain.WaterWaveSize     = 0
            terrain.WaterWaveSpeed    = 0
            terrain.WaterReflectance  = 0
            terrain.WaterTransparency = 0
        end)
    end
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() Lighting.FogEnd = 100000 end)
end
-- ==================== FIN FPS BOOST ====================

-- ==================== VARIABLES GLOBALES ====================
isMobile = false
isTablet = false
function checkDevice()
    isMobile = UserInputService.TouchEnabled
end

checkDevice()
guiScale  = 1
menuScale = 1
VP        = workspace.CurrentCamera.ViewportSize
ROW_H     = 44
SLIDER_H  = 56
function clampUiPos(x, y, w, h)
    local vp = workspace.CurrentCamera.ViewportSize
    local maxX = math.max(0, vp.X - (w or 0))
    local maxY = math.max(0, vp.Y - (h or 0))
    return math.clamp(math.floor(x or 0), 0, maxX), math.clamp(math.floor(y or 0), 0, maxY)
end

_activeDragId         = nil
_restoringConfig      = false

Features              = {
    SpeedBoost         = true,
    AntiRagdoll        = false,
    SpeedWhileStealing = true,
    GalaxyMode         = false,
    Unwalk             = false,
    Float              = false,
    Optimizer          = false,
    RightSteal         = false,
    RagdollDefender    = false,
    LeftSteal          = false,
    AutoPlayPanel      = false,
    AutoDrop           = false,
    BatAimbot          = false,
    LaggerAimbot       = false,
    AutoBat            = false,
    QuickHUDPanel      = false,
    RagdollTP          = false,
    AutoSteal          = false,
    ShowFPS            = false,
    ESPPlayers         = false,
    MedusaCounter      = false,
    FloatDodge         = false,
    HeadlessBooster    = false,
    AutoPlay           = false,
    AutoLeft           = false,
    Float = false,
    AutoRight          = false,
    BoosterAntiLag     = false,
    BoosterNightMode   = false,
    BoosterXray        = false,
    StreamerMode       = false,
    KeybindsToggle     = false,
    LaggerSpeed        = false,
    DesyncSemi         = false,
    RagdollDefender    = false,
    TPDown = false,
    AutoTPDown = false,
    Optimizer = false,
    StretchRez = false,
    GroundCircle = false,
}
Values                = {
    BoostSpeed           = 59,
    DEFAULT_GRAVITY      = 196.2,
    GalaxyGravityPercent = 100,
    StealingSpeedValue   = 29,
    HOP_POWER            = 35,
    HOP_COOLDOWN         = 0.08,
    BatAimbotSpeed       = 60,
    FloatHeight          = 5,
    FloatDodgeHeight     = 18,
    FOV                  = 120,
    StealRadius          = 8,
    StealDuration        = 2,
    BarResetDelay        = 0.3,
    QuickHUDScale        = 100,
    AutoPlayScale        = 100,
    LaggerBoostSpeed     = 59,
    LaggerStealSpeed     = 29,
    NormalBoostSpeed     = 59,
    NormalStealSpeed     = 29,
    JukerHeight          = 8,
    JukerDelay           = 0.15,
    FloatHeight = 18,
    FreezeTime = 0.1,
    AutoTPHeight = 25,
    AutoTPForce = 65,
    AutoTPDelay = 0.3,
    AutoTPCheckSpeed = 0.05,
    AutoTPJumpPower = 65,
}

-- ==================== PERSISTENCIA ====================
FeatureKeybinds       = {}
FeatureToggles        = {}
FeatureSetters        = {}
FeatureBindBtns       = {}
_allBindBtns          = {}
listeningBindBtn      = nil
listeningFeature      = nil

SAVE_FILE             = CONFIG_FILE

_boosterActivators    = {}
_boosterDeactivators  = {}
_boosterStates        = {}
FloatingButtons       = {}
FloatingButtonPos     = {}
FloatingButtonEnabled = {}
SpeedMiniPos          = nil
FloatingFeatureSet = {
    AutoPlay = true,
    Float = true,
    TPDown = true,        -- ← Agregar
    BatAimbot = true,
    LaggerAimbot = true,
    MeleeAimbot = true,
    AutoDrop = true,
    JukerActive = true,
    DesyncSemi = true,
    AutoTPDown = true,
}

FloatingLabels = {
    AutoPlay = "AUTOPLAY",
    Float = "FLOAT",
    TPDown = "TP DOWN",   -- ← Agregar
    BatAimbot = "AIMBOT",
    LaggerAimbot = "LAGGER AIM",
    MeleeAimbot = "MELEE AIM",
    AutoDrop = "DROP",
    JukerActive = "JUKER",
    DesyncSemi = "DESYNC",
    AutoTPDown = "AUTO TP",
}
SpeedSyncKeys         = {
    BoostSpeed = true,
    StealingSpeedValue = true,
    LaggerBoostSpeed = true,
    LaggerStealSpeed = true,
}
SpeedMainBoxes        = {}
SpeedMiniRefreshers   = {}
_speedSyncCache       = {}

function _fmtSpeedVal(v)
    return tostring(math.floor((tonumber(v) or 0) * 10 + 0.5) / 10)
end

function registerSpeedMainBox(valueKey, box)
    if not SpeedSyncKeys[valueKey] or not box then return end
    SpeedMainBoxes[valueKey] = SpeedMainBoxes[valueKey] or {}
    table.insert(SpeedMainBoxes[valueKey], box)
end

function registerSpeedMiniRefresher(valueKey, cb)
    if not SpeedSyncKeys[valueKey] or type(cb) ~= "function" then return end
    SpeedMiniRefreshers[valueKey] = SpeedMiniRefreshers[valueKey] or {}
    table.insert(SpeedMiniRefreshers[valueKey], cb)
end

function refreshSpeedSyncKey(valueKey)
    if not SpeedSyncKeys[valueKey] then return end
    local val = _fmtSpeedVal(Values[valueKey])
    local boxes = SpeedMainBoxes[valueKey]
    if boxes then
        for _, box in ipairs(boxes) do
            if box and box.Parent and not box:IsFocused() then
                box.Text = val
            end
        end
    end
    local refreshers = SpeedMiniRefreshers[valueKey]
    if refreshers then
        for _, cb in ipairs(refreshers) do
            pcall(cb)
        end
    end
end

_lastSavedData    = nil

_normalBoostSpeed = Values.BoostSpeed
_normalStealSpeed = Values.StealingSpeedValue

function saveConfig()
    if _restoringConfig then return end
    local lines = {}
    for k, v in pairs(Features) do
        if k ~= "BatAimbot" and k ~= "LeftSteal" and k ~= "RightSteal" and k ~= "FloatDodge" and k ~= "AutoLeft" and k ~= "AutoRight" then
            table.insert(lines, "F:" .. k .. "=" .. tostring(v))
        end
    end
    for name, state in pairs(_boosterStates) do
        table.insert(lines, "B:" .. name .. "=" .. tostring(state))
    end
    for k, v in pairs(Values) do
        -- ============ AGREGAR ESTAS LÍNEAS ============
        if k == "LaggerBoostSpeed" or k == "LaggerStealSpeed" or k == "NormalBoostSpeed" or k == "NormalStealSpeed" or k == "AutoTPHeight" or k == "AutoTPForce" or k == "AutoTPDelay" then
            table.insert(lines, "V:" .. k .. "=" .. tostring(v))
            -- ============================================
        elseif (k == "BoostSpeed" or k == "StealingSpeedValue") and Features["LaggerSpeed"] then
            if k == "BoostSpeed" then
                table.insert(lines, "V:" .. k .. "=" .. tostring(_normalBoostSpeed))
            else
                table.insert(lines, "V:" .. k .. "=" .. tostring(_normalStealSpeed))
            end
        else
            table.insert(lines, "V:" .. k .. "=" .. tostring(v))
        end
    end
    -- ... el resto del código sigue igual
    for k, v in pairs(FeatureKeybinds) do
        local name = tostring(v):match("KeyCode%.(.+)") or tostring(v)
        if name and name ~= "" then
            table.insert(lines, "K:" .. k .. "=" .. name)
        end
    end
    if _G["_ZurichHub_GamepadKeybinds"] then
        for k, v in pairs(_G["_ZurichHub_GamepadKeybinds"]) do
            if v ~= nil then
                local name = tostring(v):match("KeyCode%.(.+)") or tostring(v)
                if name and name ~= "" and name ~= "nil" then
                    table.insert(lines, "GP:" .. k .. "=" .. name)
                end
            end
        end
    end
    if toggleBtn then
        local vp = workspace.CurrentCamera.ViewportSize
        local bx = math.floor(toggleBtn.Position.X.Scale * vp.X + toggleBtn.Position.X.Offset)
        local by = math.floor(toggleBtn.Position.Y.Scale * vp.Y + toggleBtn.Position.Y.Offset)
        table.insert(lines, "P:toggleBtn=" .. bx .. "," .. by)
    end
    if main then
        local mx = math.floor(main.Position.X.Offset)
        local my = math.floor(main.Position.Y.Offset)
        table.insert(lines, "P:menuPos=" .. mx .. "," .. my)
    end
    if SpeedMiniPos then
        table.insert(lines, "P:speedMini=" .. math.floor(SpeedMiniPos.x) .. "," .. math.floor(SpeedMiniPos.y))
    end
    for feat in pairs(FloatingFeatureSet) do
        table.insert(lines, "FB:" .. feat .. "=" .. tostring(FloatingButtonEnabled[feat] == true))
    end
    for feat, btn in pairs(FloatingButtons) do
        if btn and btn.host and btn.host.Parent then
            local pos = btn.host.Position
            table.insert(lines, "P:fb_" .. feat .. "=" .. math.floor(pos.X.Offset) .. "," .. math.floor(pos.Y.Offset))
        end
    end
    local data = table.concat(lines, "\n")

    if data == _lastSavedData then return end

    local ok, err = pcall(writefile, SAVE_FILE, data)
    if ok then
        _lastSavedData = data
        _G["_ZurichHub_Data"] = data
    else
        warn("[Zurich] Error al guardar: " .. tostring(err))
    end
end

function loadConfig()
    local data = nil
    local ok, result = pcall(readfile, SAVE_FILE)
    if ok and result and #result > 0 then
        data = result
    elseif _G["_ZurichHub_Data"] and #tostring(_G["_ZurichHub_Data"]) > 0 then
        data = _G["_ZurichHub_Data"]
    end
    if not data then return end
    local pendingKeybinds = {}
    for line in data:gmatch("[^\n]+") do
        if line:sub(1, 3) == "FB:" then
            local k, v = line:sub(4):match("([^=]+)=(.+)")
            if k and FloatingFeatureSet[k] then
                FloatingButtonEnabled[k] = (v == "true")
            end
        else
            local prefix = line:sub(1, 2)
            local rest   = line:sub(3)
            local k, v   = rest:match("([^=]+)=(.+)")
            if k and v then
                if prefix == "F:" then
                  if k ~= "SpeedBoost" and k ~= "SpeedWhileStealing" then
                        if Features[k] ~= nil then Features[k] = (v == "true") end
                    end
                elseif prefix == "B:" then
                    _boosterStates[k] = (v == "true")
                elseif prefix == "V:" then
                    if Values[k] ~= nil then
                        local num = tonumber(v)
                        if num then Values[k] = num end
                    end
                elseif prefix == "K:" then
                    pendingKeybinds[k] = v
                elseif prefix == "P:" then
                    if k == "toggleBtn" then
                        local bx, by = v:match("(-?%d+),(-?%d+)")
                        if bx and by then
                            _G["_ZurichHub_BtnPos"] = { x = tonumber(bx), y = tonumber(by) }
                        end
                    elseif k == "menuPos" then
                        local mx, my = v:match("(-?%d+),(-?%d+)")
                        if mx and my then
                            _G["_ZurichHub_MenuPos"] = { x = tonumber(mx), y = tonumber(my) }
                        end
                        local ax, ay = v:match("(-?%d+),(-?%d+)")
                        if ax and ay then
                            _G["_ZurichHub_AutoplayPanelPos"] = { x = tonumber(ax), y = tonumber(ay) }
                        end
                    elseif k == "autoplayKey" then
                        local ok2, kc = pcall(function() return Enum.KeyCode[v] end)
                        if ok2 and kc then
                            _G["_ZurichHub_AutoplayKeybindPending"] = kc
                        end
                    elseif k == "speedMini" then
                        local sx, sy = v:match("(-?%d+),(-?%d+)")
                        if sx and sy then
                            SpeedMiniPos = { x = tonumber(sx), y = tonumber(sy) }
                        end
                    elseif k:sub(1, 3) == "fb_" then
                        local feat = k:sub(4)
                        local fx, fy = v:match("(-?%d+),(-?%d+)")
                        if feat and fx and fy then
                            FloatingButtonPos[feat] = { x = tonumber(fx), y = tonumber(fy) }
                        end
                    end
                end
            end
        end
    end
    _G["_ZurichHub_PendingKeybinds"] = pendingKeybinds
end

loadConfig()

-- Actualizar las velocidades normales con los valores cargados del config
_normalBoostSpeed = Values.BoostSpeed
_normalStealSpeed = Values.StealingSpeedValue

-- ==================== AUTOPLAY VARIABLES ====================
local autoplayActive = false
local autoplayMode = "none"
local autoplayWPIdx = 1
local autoplayConn = nil
local noclipConn = nil
local noclipCache = {}

-- ===== waypoints (mismos del original) =====
local autoLeftWaypoints = {
    Vector3.new(-475.86, -7, 91.97),
    Vector3.new(-485.83, -7, 97.37),
    Vector3.new(-475.86, -7, 91.97),
    Vector3.new(-476.35, -7, 27.88),
    Vector3.new(-477.09, -7, 19.85),
}

local autoRightWaypoints = {
    Vector3.new(-475.84, -7, 28.81),
    Vector3.new(-486.04, -7, 23.32),
    Vector3.new(-475.51, -7, 29.01),
    Vector3.new(-476.43, -7, 91.61),
    Vector3.new(-476.27, -7, 98.86),
}

-- ===== notificación simple =====
local function notify(msg, isGood)
    print(msg)
end

-- ===== detectar base izquierda/derecha =====
local function getAutoplayModeForMyBase()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return "left" end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local yourBase = sign and sign:FindFirstChild("YourBase")
        if yourBase and yourBase.Enabled then
            local target = plot:FindFirstChild("AnimalTarget", true)
            local refPos = target and target.Position
            if not refPos then
                local delivery = plot:FindFirstChild("DeliveryHitbox")
                refPos = delivery and delivery.Position
            end
            if refPos then
                local leftDist = (refPos - autoLeftWaypoints[1]).Magnitude
                local rightDist = (refPos - autoRightWaypoints[1]).Magnitude
                return (leftDist <= rightDist) and "right" or "left"
            end
            local plotPos = plot:GetPivot().Position
            return (plotPos.Z >= 60) and "right" or "left"
        end
    end
    return "left"
end

-- ===== noclip =====
local function startNoclip()
    if noclipConn then return end
    local char = Player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            noclipCache[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    local elapsed = 0
    noclipConn = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        if elapsed < 0.1 then return end
        elapsed = 0
        if not autoplayActive then
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
            for part, val in pairs(noclipCache) do
                if part and part.Parent then part.CanCollide = val end
            end
            noclipCache = {}
            return
        end
        local newChar = Player.Character
        if newChar then
            for _, part in ipairs(newChar:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character then
                    for _, p in ipairs(plr.Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
        end
    end)
end

-- ===== detener =====
local function stopAutoplay()
    if not autoplayActive then return end
    autoplayActive = false
    autoplayMode = "none"
    autoplayWPIdx = 1
    if autoplayConn then
        autoplayConn:Disconnect()
        autoplayConn = nil
    end
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
    end
    notify("Autoplay detenido", false)
end

-- ===== iniciar =====
local function startAutoplay()
    if autoplayActive then stopAutoplay() end
    local mode = getAutoplayModeForMyBase()
    autoplayMode = mode
    autoplayWPIdx = 1
    autoplayActive = true

    -- Usar velocidades basadas en LaggerSpeed
    local boostSpeed = Features.LaggerSpeed and Values.LaggerBoostSpeed or Values.BoostSpeed
    local stealSpeed = Features.LaggerSpeed and Values.LaggerStealSpeed or Values.StealingSpeedValue

    startNoclip()

    if autoplayConn then autoplayConn:Disconnect() end
    autoplayConn = RunService.Heartbeat:Connect(function()
        if not autoplayActive then return end
        local waypoints = (autoplayMode == "left") and autoLeftWaypoints or autoRightWaypoints
        if not waypoints then return end
        local wp = waypoints[autoplayWPIdx]
        if not wp then return end

        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local myPos = hrp.Position
        local targetXZ = Vector3.new(wp.X, 0, wp.Z)
        local myXZ = Vector3.new(myPos.X, 0, myPos.Z)
        local distXZ = (targetXZ - myXZ).Magnitude
        local velFlat = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
        local isNearEnough = distXZ <= 1.1
        local isSlowEnough = velFlat.Magnitude < 28 or distXZ <= 0.4

        if isNearEnough and isSlowEnough then
            hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0)
            if autoplayWPIdx >= #waypoints then
                notify("✅ Autoplay completado", true)
                stopAutoplay()
                return
            end
            autoplayWPIdx = autoplayWPIdx + 1
        else
            local dir = (targetXZ - myXZ)
            if dir.Magnitude > 0.001 then dir = dir.Unit end
            local speed = (autoplayWPIdx <= 2) and boostSpeed or stealSpeed
            if distXZ < 1.5 then
                speed = speed * math.clamp(distXZ / 1.5, 0.6, 1)
            end
            hrp.Velocity = Vector3.new(dir.X * speed, hrp.Velocity.Y, dir.Z * speed)
        end
    end)

    notify(string.format("Autoplay iniciado (%s)", autoplayMode == "left" and "IZQUIERDA" or "DERECHA"), true)
end

Player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if autoplayActive then
        startAutoplay()
    end
end)



local RAGDOLL_COORDS = {
    right = {
        Vector3.new(-464.46, -5.85, 23.38),
        Vector3.new(-481.9, -5.1, 21.9)
    },
    left = {
        Vector3.new(-469.95, -5.85, 90.99),
        Vector3.new(-482, -5.1, 98.5),
        Vector3.new(-470.395, -7.002, 90.118)
    }
}

local accentColors = {
    Color3.fromRGB(180, 180, 180),
    Color3.fromRGB(140, 140, 140),
    Color3.fromRGB(200, 200, 200),
    Color3.fromRGB(120, 120, 120),
}
local accentObjects = {}
function addAccent(obj, prop)
    table.insert(accentObjects, { obj = obj, prop = prop })
end

local existingGui  = Player.PlayerGui:FindFirstChild("ZurichHub_UI")
local existingSnow = Player.PlayerGui:FindFirstChild("SnowEffect")
if existingGui then existingGui:Destroy() end
if existingSnow then existingSnow:Destroy() end

local C_BG           = Color3.fromRGB(8, 8, 10)
local C_HEADER       = Color3.fromRGB(14, 14, 18)
local C_ROW          = Color3.fromRGB(18, 18, 22)
local C_SEP          = Color3.fromRGB(210, 210, 220)
local C_TEXT         = Color3.fromRGB(247, 247, 250)
local C_SUBTEXT      = Color3.fromRGB(170, 170, 180)
local C_ACCENT       = Color3.fromRGB(255, 255, 255)
local C_ON           = Color3.fromRGB(236, 236, 242)
local C_OFF          = Color3.fromRGB(36, 36, 42)

local MW             = math.min(270, VP.X * 0.55)
local MH             = math.min(440, VP.Y * 0.78)
local HDR_H          = 56

local sg             = Instance.new("ScreenGui")
sg.Name              = "ZurichHub_UI"
sg.ResetOnSpawn      = false
sg.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset    = true
sg.DisplayOrder      = 50
sg.Parent            = Player.PlayerGui

sg.Parent            = Player.PlayerGui

-- ==================== WATCHDOG DE CARGA (MÓVIL) ====================
local _toggleMenuRef = nil
local bootWatch      = {
    enabled = UserInputService.TouchEnabled,
    ready = false,
    overlay = nil,
    status = nil,
}
function markBootReady()
    if bootWatch.ready then return end
    bootWatch.ready = true
    if bootWatch.status then
        bootWatch.status.Text = "UI cargada"
    end
    if bootWatch.overlay and bootWatch.overlay.Parent then
        task.delay(0.25, function()
            if bootWatch.overlay and bootWatch.overlay.Parent then
                bootWatch.overlay:Destroy()
            end
        end)
    end
end

if bootWatch.enabled then
    local bootGui = Instance.new("ScreenGui")
    bootGui.Name = "ZurichBootWatchdog"
    bootGui.ResetOnSpawn = false
    bootGui.IgnoreGuiInset = true
    bootGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bootGui.DisplayOrder = 9999
    bootGui.Parent = Player.PlayerGui
    bootWatch.overlay = bootGui

    local box = Instance.new("Frame", bootGui)
    box.Size = UDim2.new(0, 210, 0, 84)
    box.Position = UDim2.new(0.5, -105, 0.08, 0)
    box.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    box.BackgroundTransparency = 0.08
    box.BorderSizePixel = 0
    box.ZIndex = 10000
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
    local bStroke = Instance.new("UIStroke", box)
    bStroke.Color = Color3.fromRGB(230, 230, 236)
    bStroke.Thickness = 1.2
    bStroke.Transparency = 0.25

    local title = Instance.new("TextLabel", box)
    title.AutoLocalize = false
    title.Size = UDim2.new(1, -12, 0, 22)
    title.Position = UDim2.new(0, 6, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "Zurich cargando..."
    title.TextColor3 = Color3.fromRGB(245, 245, 248)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.ZIndex = 10001

    local status = Instance.new("TextLabel", box)
    status.AutoLocalize = false
    status.Size = UDim2.new(1, -12, 0, 18)
    status.Position = UDim2.new(0, 6, 0, 28)
    status.BackgroundTransparency = 1
    status.Text = "Inicializando UI..."
    status.TextColor3 = Color3.fromRGB(200, 200, 210)
    status.Font = Enum.Font.Gotham
    status.TextSize = 10
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.ZIndex = 10001
    bootWatch.status = status

    local retryBtn = Instance.new("TextButton", box)
    retryBtn.AutoLocalize = false
    retryBtn.Size = UDim2.new(1, -12, 0, 24)
    retryBtn.Position = UDim2.new(0, 6, 1, -30)
    retryBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 236)
    retryBtn.TextColor3 = Color3.fromRGB(12, 12, 16)
    retryBtn.Font = Enum.Font.GothamBold
    retryBtn.TextSize = 11
    retryBtn.Text = "REINTENTAR UI"
    retryBtn.BorderSizePixel = 0
    retryBtn.ZIndex = 10001
    Instance.new("UICorner", retryBtn).CornerRadius = UDim.new(0, 6)
    retryBtn.MouseButton1Click:Connect(function()
        if bootWatch.status then
            bootWatch.status.Text = "Reintentando montaje..."
        end
        pcall(function()
            sg.Enabled = false
            task.wait(0.08)
            sg.Enabled = true
            if main and mainBorderFrame then
                local rx, ry = clampUiPos(workspace.CurrentCamera.ViewportSize.X * 0.5 - MW * 0.5, 40, MW, MH)
                main.Position = UDim2.new(0, rx, 0, ry)
                mainBorderFrame.Position = UDim2.new(0, rx, 0, ry)
                main.Visible = true
                mainBorderFrame.Visible = true
            end
        end)
        if _toggleMenuRef then
            pcall(_toggleMenuRef)
        end
    end)

    task.spawn(function()
        local t0 = tick()
        while bootWatch.overlay and bootWatch.overlay.Parent and not bootWatch.ready and (tick() - t0) < 15 do
            task.wait(0.25)
        end
        if bootWatch.ready then return end
        if bootWatch.status then
            bootWatch.status.Text = "Carga lenta detectada. Recovery..."
        end
        pcall(function()
            sg.Enabled = false
            task.wait(0.12)
            sg.Enabled = true
            if main and mainBorderFrame then
                local rx, ry = clampUiPos(workspace.CurrentCamera.ViewportSize.X * 0.5 - MW * 0.5, 40, MW, MH)
                main.Position = UDim2.new(0, rx, 0, ry)
                mainBorderFrame.Position = UDim2.new(0, rx, 0, ry)
                main.Visible = true
                mainBorderFrame.Visible = true
            end
        end)
    end)
end

function recolorGrayToRed(c)
    local r, g, b = c.R * 255, c.G * 255, c.B * 255
    local maxDiff = math.max(math.abs(r - g), math.abs(g - b), math.abs(r - b))
    if maxDiff > 20 then
        return c
    end
    local lum = (r + g + b) / 3
    local nr = math.clamp(lum + 8, 0, 255)
    local ng = math.clamp(lum + 8, 0, 255)
    local nb = math.clamp(lum + 14, 0, 255)
    return Color3.fromRGB(math.floor(nr + 0.5), math.floor(ng + 0.5), math.floor(nb + 0.5))
end

local COLOR_PROPS = {
    "BackgroundColor3",
    "TextColor3",
    "ImageColor3",
    "BorderColor3",
    "ScrollBarImageColor3",
    "PlaceholderColor3",
    "Color",
}

function applyRedThemeToInstance(inst)
    for _, prop in ipairs(COLOR_PROPS) do
        local okRead, color = pcall(function() return inst[prop] end)
        if okRead and typeof(color) == "Color3" then
            pcall(function()
                inst[prop] = recolorGrayToRed(color)
            end)
        end
    end
end

function hookGlobalRedTheme(root)
    for _, inst in ipairs(root:GetDescendants()) do
        applyRedThemeToInstance(inst)
    end
    root.DescendantAdded:Connect(applyRedThemeToInstance)
end

hookGlobalRedTheme(sg)

local ragdollIndicator = { Visible = false }

function addSoftGlow(parent, color, transparency, padding)
    local glow = Instance.new("ImageLabel")
    glow.Name = "SoftGlow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or C_ACCENT
    glow.ImageTransparency = transparency or 0.82
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(24, 24, 276, 276)
    glow.Size = UDim2.new(1, padding or 30, 1, padding or 30)
    glow.Position = UDim2.new(0, -math.floor((padding or 30) / 2), 0, -math.floor((padding or 30) / 2))
    glow.ZIndex = math.max((parent.ZIndex or 1) - 1, 0)
    glow.Parent = parent
    return glow
end

function addSheen(target, topColor, bottomColor, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, topColor),
        ColorSequenceKeypoint.new(0.55, bottomColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 8))
    })
    grad.Rotation = rotation or 135
    grad.Parent = target
    return grad
end

-- ==================== ICONO DE CABEZA ====================
do
    local headIcon = Instance.new("ImageLabel", sg)
    headIcon.Name = "PlayerHeadIcon"
    headIcon.Size = UDim2.new(0, 44, 0, 44)
    headIcon.Position = UDim2.new(1, -52, 0, 8)
    headIcon.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    headIcon.BackgroundTransparency = 0.12
    headIcon.BorderSizePixel = 0
    headIcon.ZIndex = 300
    headIcon.ScaleType = Enum.ScaleType.Crop
    Instance.new("UICorner", headIcon).CornerRadius = UDim.new(0, 10)
    local iconStroke = Instance.new("UIStroke", headIcon)
    iconStroke.Color = Color3.fromRGB(245, 245, 250)
    iconStroke.Thickness = 1.5
    iconStroke.Transparency = 0.1
    iconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    task.spawn(function()
        local ok, content = pcall(function()
            return Players:GetUserThumbnailAsync(
                Player.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok and content then
            headIcon.Image = content
        end
    end)
end
-- ==================== FIN ICONO DE CABEZA ====================

main = Instance.new("Frame", sg)


main.Name                                   = "Main"
main.Size                                   = UDim2.new(0, MW, 0, MH)
main.Position                               = UDim2.new(0, 18, 0, 18)
main.BackgroundColor3                       = Color3.fromRGB(10, 10, 12)
main.BackgroundTransparency                 = 0.06
main.BorderSizePixel                        = 0
main.Active                                 = true
main.Draggable                              = false
main.ClipsDescendants                       = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
addSheen(main, Color3.fromRGB(30, 30, 34), Color3.fromRGB(15, 15, 18), 135)

local mainBorderFrame                                  = Instance.new("Frame", sg)
mainBorderFrame.Name                                   = "MainBorder"
mainBorderFrame.Size                                   = UDim2.new(0, MW, 0, MH)
mainBorderFrame.Position                               = UDim2.new(0, 18, 0, 18)
mainBorderFrame.BackgroundTransparency                 = 1
mainBorderFrame.BorderSizePixel                        = 0
mainBorderFrame.ZIndex                                 = main.ZIndex + 1
mainBorderFrame.Active                                 = false
Instance.new("UICorner", mainBorderFrame).CornerRadius = UDim.new(0, 18)

local mainShadow                                       = Instance.new("ImageLabel", sg)
mainShadow.Name                                        = "MainShadow"
mainShadow.Size                                        = UDim2.new(0, MW + 30, 0, MH + 34)
mainShadow.Position                                    = UDim2.new(0, 3, 0, 3)
mainShadow.BackgroundTransparency                      = 1
mainShadow.Image                                       = "rbxassetid://5028857084"
mainShadow.ImageColor3                                 = Color3.fromRGB(255, 255, 255)
mainShadow.ImageTransparency                           = 0.84
mainShadow.ScaleType                                   = Enum.ScaleType.Slice
mainShadow.SliceCenter                                 = Rect.new(24, 24, 276, 276)
mainShadow.ZIndex                                      = main.ZIndex - 1

function syncMainShadow()
    mainShadow.Position = UDim2.new(0, main.Position.X.Offset - 15, 0, main.Position.Y.Offset - 17)
end

syncMainShadow()
main:GetPropertyChangedSignal("Position"):Connect(syncMainShadow)

local innerGradient                  = Instance.new("Frame", main)
innerGradient.Size                   = UDim2.new(1, 0, 1, 0)
innerGradient.BackgroundTransparency = 1
innerGradient.BorderSizePixel        = 0
innerGradient.ZIndex                 = 0

local panelGrad                      = Instance.new("UIGradient", innerGradient)
panelGrad.Color                      = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 18)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 10)),
})
panelGrad.Rotation                   = 132

local mainStroke                     = Instance.new("UIStroke", mainBorderFrame)
mainStroke.Thickness                 = 1
mainStroke.ApplyStrokeMode           = Enum.ApplyStrokeMode.Border
mainStroke.Color                     = Color3.fromRGB(235, 235, 242)
mainStroke.Transparency              = 0.12
addAccent(mainStroke, "Color")

local glowStroke                                  = Instance.new("UIStroke", mainBorderFrame)
glowStroke.ApplyStrokeMode                        = Enum.ApplyStrokeMode.Border
glowStroke.Color                                  = Color3.fromRGB(255, 255, 255)
glowStroke.Thickness                              = 3
glowStroke.Transparency                           = 0.9

local sideAccent                                  = Instance.new("Frame", main)
sideAccent.Name                                   = "SideAccent"
sideAccent.Size                                   = UDim2.new(0, 4, 1, -24)
sideAccent.Position                               = UDim2.new(0, 8, 0, 10)
sideAccent.BackgroundColor3                       = Color3.fromRGB(255, 255, 255)
sideAccent.BorderSizePixel                        = 0
sideAccent.ZIndex                                 = 3
Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(1, 0)

local sideAccentGrad                              = Instance.new("UIGradient", sideAccent)
sideAccentGrad.Color                              = ColorSequence.new(Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(110, 110, 120))
sideAccentGrad.Rotation                           = 90

-- ==================== HEADER ====================
local header                                      = Instance.new("Frame", main)
header.Size                                       = UDim2.new(1, -20, 0, 68)
header.Position                                   = UDim2.new(0, 14, 0, 10)
header.BackgroundColor3                           = Color3.fromRGB(16, 16, 20)
header.BackgroundTransparency                     = 0.03
header.BorderSizePixel                            = 0
header.ZIndex                                     = 5
header.Active                                     = true
Instance.new("UICorner", header).CornerRadius     = UDim.new(0, 14)
addSheen(header, Color3.fromRGB(28, 28, 32), Color3.fromRGB(12, 12, 15), 120)
addSoftGlow(header, Color3.fromRGB(255, 255, 255), 0.9, 18)

local headerPatch                             = Instance.new("Frame", header)
headerPatch.Size                              = UDim2.new(1, 0, 0.5, 0)
headerPatch.Position                          = UDim2.new(0, 0, 0.5, 0)
headerPatch.BackgroundColor3                  = Color3.fromRGB(10, 10, 12)
headerPatch.BackgroundTransparency            = 0.2
headerPatch.BorderSizePixel                   = 0
headerPatch.ZIndex                            = 3

local headerStroke                            = Instance.new("UIStroke", header)
headerStroke.Color                            = Color3.fromRGB(230, 230, 238)
headerStroke.Thickness                        = 1.4
headerStroke.Transparency                     = 0.12
headerStroke.ApplyStrokeMode                  = Enum.ApplyStrokeMode.Border

local headerLine                              = Instance.new("Frame", main)
headerLine.Size                               = UDim2.new(1, -28, 0, 1)
headerLine.Position                           = UDim2.new(0, 14, 0, 84)
headerLine.BackgroundColor3                   = Color3.fromRGB(92, 92, 102)
headerLine.BorderSizePixel                    = 0
headerLine.ZIndex                             = 5

local starBg                                  = Instance.new("Frame", header)
starBg.Size                                   = UDim2.new(0, 42, 0, 42)
starBg.Position                               = UDim2.new(0, 10, 0.5, -21)
starBg.BackgroundColor3                       = Color3.fromRGB(24, 24, 28)
starBg.BackgroundTransparency                 = 0
starBg.BorderSizePixel                        = 0
starBg.ZIndex                                 = 6
Instance.new("UICorner", starBg).CornerRadius = UDim.new(0, 12)
local starBgStroke                            = Instance.new("UIStroke", starBg)
starBgStroke.Color                            = Color3.fromRGB(242, 242, 248)
starBgStroke.Thickness                        = 1.2
starBgStroke.Transparency                     = 0.05
starBgStroke.ApplyStrokeMode                  = Enum.ApplyStrokeMode.Border

local starLogo                                = Instance.new("TextLabel", starBg)
starLogo.AutoLocalize                         = false
starLogo.Size                                 = UDim2.new(1, 0, 1, 0)
starLogo.Position                             = UDim2.new(0, 0, 0, 0)
starLogo.BackgroundTransparency               = 1
starLogo.Text                                 = "ZH"
starLogo.Font                                 = Enum.Font.GothamBlack
starLogo.TextSize                             = 14
starLogo.TextColor3                           = Color3.fromRGB(250, 250, 252)
starLogo.TextXAlignment                       = Enum.TextXAlignment.Center
starLogo.TextYAlignment                       = Enum.TextYAlignment.Center
starLogo.ZIndex                               = 7

for k, v in pairs({ TextColor3 = Color3.fromRGB(250, 250, 252) }) do starLogo[k] = v end

local title                                      = Instance.new("TextLabel", header)
title.AutoLocalize                               = false
title.Size                                       = UDim2.new(1, -160, 0, 30)
title.Position                                   = UDim2.new(0, 62, 0, 10)
title.BackgroundTransparency                     = 1
title.Text                                       = "Zurich Hub"
title.Font                                       = Enum.Font.GothamBlack
title.TextSize                                   = 19
title.TextColor3                                 = Color3.fromRGB(248, 248, 252)
title.TextXAlignment                             = Enum.TextXAlignment.Left
title.TextYAlignment                             = Enum.TextYAlignment.Bottom
title.ZIndex                                     = 6

local subtitle                                   = Instance.new("TextLabel", header)
subtitle.Size                                    = UDim2.new(1, -160, 0, 16)
subtitle.Position                                = UDim2.new(0, 62, 0, 38)
subtitle.BackgroundTransparency                  = 1
subtitle.Text                                    = "Combat Control Panel"
subtitle.Font                                    = Enum.Font.GothamMedium
subtitle.TextSize                                = 11
subtitle.TextColor3                              = Color3.fromRGB(165, 165, 176)
subtitle.TextXAlignment                          = Enum.TextXAlignment.Left
subtitle.ZIndex                                  = 6

local statusDot                                  = Instance.new("Frame", header)
statusDot.Size                                   = UDim2.new(0, 8, 0, 8)
statusDot.Position                               = UDim2.new(0, 52, 0, 43)
statusDot.BackgroundColor3                       = Color3.fromRGB(255, 255, 255)
statusDot.BorderSizePixel                        = 0
statusDot.ZIndex                                 = 6
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

-- Arrastre del menu desde el header
do
    local drag, ds, sp = false, nil, nil
    header.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true; ds = inp.Position; sp = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not drag then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = inp.Position - ds
        local nx = math.clamp(sp.X.Offset + d.X, 0, VP.X - MW)
        local ny = math.clamp(sp.Y.Offset + d.Y, 0, VP.Y - HDR_H)
        main.Position = UDim2.new(0, nx, 0, ny)
        mainBorderFrame.Position = UDim2.new(0, nx, 0, ny)
        mainShadow.Position = UDim2.new(0, nx - 15, 0, ny - 17)
        hubTargetPos = UDim2.new(0, nx, 0, ny)
        mainBorderFrame.Position = UDim2.new(0, nx, 0, ny)
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

-- ==================== AREA DE CONTENIDO ====================
local contentArea                                  = Instance.new("Frame", main)
contentArea.Size                                   = UDim2.new(1, -28, 1, -100)
contentArea.Position                               = UDim2.new(0, 14, 0, 90)
contentArea.BackgroundColor3                       = Color3.fromRGB(12, 12, 15)
contentArea.BackgroundTransparency                 = 0.08
contentArea.BorderSizePixel                        = 0
contentArea.ClipsDescendants                       = true
contentArea.ZIndex                                 = 3
Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 12)

local contentStroke                                = Instance.new("UIStroke", contentArea)
contentStroke.Color                                = Color3.fromRGB(78, 78, 88)
contentStroke.Thickness                            = 1
contentStroke.Transparency                         = 0.28

local mainScroll                                   = Instance.new("ScrollingFrame", contentArea)
mainScroll.Size                                    = UDim2.new(1, 0, 1, 0)
mainScroll.BackgroundTransparency                  = 1
mainScroll.BorderSizePixel                         = 0
mainScroll.ScrollBarThickness                      = 4
mainScroll.ScrollBarImageColor3                    = Color3.fromRGB(215, 215, 225)
mainScroll.CanvasSize                              = UDim2.new(0, 0, 0, 0)
mainScroll.ScrollingDirection                      = Enum.ScrollingDirection.Y
mainScroll.ZIndex                                  = 3

local mainLayout                                   = Instance.new("UIListLayout", mainScroll)
mainLayout.Padding                                 = UDim.new(0, 0)
mainLayout.FillDirection                           = Enum.FillDirection.Vertical
mainLayout.SortOrder                               = Enum.SortOrder.LayoutOrder
mainLayout.HorizontalAlignment                     = Enum.HorizontalAlignment.Center

mainLayout.Changed:Connect(function()
    mainScroll.CanvasSize = UDim2.new(0, 0, 0, mainLayout.AbsoluteContentSize.Y + 10)
end)

local scrollMovimiento = mainScroll
local scrollCombate    = mainScroll
local scrollRobo       = mainScroll
local scrollConfig     = mainScroll
local leftScroll       = mainScroll
local rightScroll      = mainScroll

function spawnBubbles(frame, isOn) end

-- ==================== FABRICA DE COMPONENTES UI ====================
local rowOrder   = 0

local _C_BG      = Color3.fromRGB(12, 12, 14)
local _C_ROW     = Color3.fromRGB(20, 20, 24)
local _C_ROW2    = Color3.fromRGB(30, 30, 36)
local _C_SEP2    = Color3.fromRGB(78, 78, 88)
local _C_TEXT2   = Color3.fromRGB(242, 242, 247)
local _C_SUB2    = Color3.fromRGB(165, 165, 176)
local _C_ACCENT2 = Color3.fromRGB(255, 255, 255)
local _C_ON2     = Color3.fromRGB(235, 235, 242)
local _C_OFF2    = Color3.fromRGB(36, 36, 42)

function makeRowFrame(parent, height)
    height                                       = height or ROW_H
    local frame                                  = Instance.new("Frame", parent)
    frame.Size                                   = UDim2.new(1, 0, 0, height)
    frame.BackgroundColor3                       = _C_ROW
    frame.BackgroundTransparency                 = 0.08
    frame.BorderSizePixel                        = 0
    frame.LayoutOrder                            = rowOrder
    frame.ClipsDescendants                       = true
    rowOrder                                     = rowOrder + 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
    addSheen(frame, Color3.fromRGB(28, 28, 32), Color3.fromRGB(14, 14, 18), 135)
    local rowStroke            = Instance.new("UIStroke", frame)
    rowStroke.Color            = Color3.fromRGB(62, 62, 72)
    rowStroke.Thickness        = 1
    rowStroke.Transparency     = 0.48
    local div                  = Instance.new("Frame", frame)
    div.Size                   = UDim2.new(1, -14, 0, 1)
    div.Position               = UDim2.new(0, 7, 1, -1)
    div.BackgroundColor3       = _C_SEP2
    div.BorderSizePixel        = 0
    div.ZIndex                 = 3
    div.BackgroundTransparency = 0.45
    return frame, div
end

-- ==================== NOTIFICACIONES (DESACTIVADAS) ====================
function showFeatureNotif(label, isOn) end

-- ==================== makeToggle ====================
function getFeatureKeyName(featureName)
    local gpBinds = _G["_ZurichHub_GamepadKeybinds"]
    local key = (gpBinds and gpBinds[featureName]) or FeatureKeybinds[featureName]
    if not key then return "BIND" end
    return tostring(key):match("KeyCode%.(.+)") or tostring(key)
end

function makeFloatingButton(featureName, onToggle)
    if FloatingButtons[featureName] and FloatingButtons[featureName].host and FloatingButtons[featureName].host.Parent then
        return FloatingButtons[featureName]
    end

    local host = Instance.new("Frame", sg)
    host.Name = "Floating_" .. featureName
    host.Size = UDim2.new(0, 148, 0, 42)
    host.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    host.BackgroundTransparency = 0.12
    host.BorderSizePixel = 0
    host.ZIndex = 255
    host.Active = true
    Instance.new("UICorner", host).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", host)
    stroke.Thickness = 1.2
    stroke.Color = Color3.fromRGB(88, 88, 100)
    stroke.Transparency = 0.2

    local vp = workspace.CurrentCamera.ViewportSize
    local idx = 0
    for _ in pairs(FloatingButtons) do idx = idx + 1 end
    local defaultX = math.floor(vp.X - 162)
    local defaultY = math.floor(vp.Y * 0.28 + idx * 50)
    local savedPos = FloatingButtonPos[featureName]
    local sx, sy = clampUiPos(savedPos and savedPos.x or defaultX, savedPos and savedPos.y or defaultY, 148, 42)
    host.Position = UDim2.new(0, sx, 0, sy)

    local nameLbl = Instance.new("TextLabel", host)
    nameLbl.AutoLocalize = false
    nameLbl.Size = UDim2.new(1, -8, 0, 20)
    nameLbl.Position = UDim2.new(0, 8, 0, 2)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = FloatingLabels[featureName] or featureName
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 11
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextColor3 = Color3.fromRGB(240, 240, 246)
    nameLbl.ZIndex = 257

    local statusLbl = Instance.new("TextLabel", host)
    statusLbl.AutoLocalize = false
    statusLbl.Size = UDim2.new(1, -56, 0, 16)
    statusLbl.Position = UDim2.new(0, 8, 0, 22)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Font = Enum.Font.GothamSemibold
    statusLbl.TextSize = 10
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.ZIndex = 257

    local keyLbl = Instance.new("TextLabel", host)
    keyLbl.AutoLocalize = false
    keyLbl.Size = UDim2.new(0, 40, 0, 16)
    keyLbl.Position = UDim2.new(1, -44, 0, 22)
    keyLbl.BackgroundColor3 = Color3.fromRGB(34, 34, 42)
    keyLbl.BorderSizePixel = 0
    keyLbl.Font = Enum.Font.GothamBold
    keyLbl.TextSize = 9
    keyLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
    keyLbl.ZIndex = 257
    Instance.new("UICorner", keyLbl).CornerRadius = UDim.new(0, 4)

    local function refresh()
        local on = Features[featureName] == true
        statusLbl.Text = on and "ON" or "OFF"
        statusLbl.TextColor3 = on and Color3.fromRGB(190, 255, 190) or Color3.fromRGB(255, 190, 190)
        keyLbl.Text = getFeatureKeyName(featureName)
        host.BackgroundColor3 = on and Color3.fromRGB(58, 38, 76) or Color3.fromRGB(24, 24, 30)
    end

    local dragStart, frameStart, dragging, moved = nil, nil, false, false
    local dragInput = nil
    local dragMode = nil
    local DRAG_T = 8
    local hit = Instance.new("TextButton", host)
    hit.AutoLocalize = false
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.ZIndex = 258
    hit.AutoButtonColor = false

    hit.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        moved = false
        dragInput = inp
        dragMode = (inp.UserInputType == Enum.UserInputType.Touch) and "touch" or "mouse"
        dragStart = inp.Position
        frameStart = host.Position
    end)
    hit.InputEnded:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local shouldFinish = false
        if dragging then
            if dragMode == "touch" and inp == dragInput then
                shouldFinish = true
            elseif dragMode == "mouse" and inp.UserInputType == Enum.UserInputType.MouseButton1 then
                shouldFinish = true
            end
        end
        if shouldFinish then
            dragging = false
            dragInput = nil
            dragMode = nil
            local pos = host.Position
            FloatingButtonPos[featureName] = { x = math.floor(pos.X.Offset), y = math.floor(pos.Y.Offset) }
            task.defer(saveConfig)
            if not moved and onToggle then onToggle() end
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if dragMode == "touch" and inp ~= dragInput then return end
        if dragMode == "mouse" and inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local delta = inp.Position - dragStart
        if math.abs(delta.X) > DRAG_T or math.abs(delta.Y) > DRAG_T then
            moved = true
        end
        if moved then
            local vp2 = workspace.CurrentCamera.ViewportSize
            local nx = math.clamp(frameStart.X.Offset + delta.X, 0, vp2.X - host.AbsoluteSize.X)
            local ny = math.clamp(frameStart.Y.Offset + delta.Y, 0, vp2.Y - host.AbsoluteSize.Y)
            host.Position = UDim2.new(0, nx, 0, ny)
        end
    end)

    local prevBindRefresh = FeatureBindBtns[featureName]
    FeatureBindBtns[featureName] = function()
        if prevBindRefresh then pcall(prevBindRefresh) end
        refresh()
    end

    local entry = {
        host = host,
        refresh = refresh,
        destroy = function()
            if host and host.Parent then host:Destroy() end
            FloatingButtons[featureName] = nil
        end
    }
    FloatingButtons[featureName] = entry
    refresh()
    return entry
end

function makeSpeedMiniUI()
    local panel = Instance.new("Frame", sg)
    panel.Name = "SpeedMiniUI"
    panel.Size = UDim2.new(0, 180, 0, 160)
    panel.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.ZIndex = 240
    panel.Active = true
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", panel)
    st.Thickness = 1.2
    st.Color = Color3.fromRGB(84, 84, 98)
    st.Transparency = 0.2

    local vp = workspace.CurrentCamera.ViewportSize
    local startX = SpeedMiniPos and SpeedMiniPos.x or math.floor(vp.X - 198)
    local startY = SpeedMiniPos and SpeedMiniPos.y or math.floor(vp.Y * 0.62)
    local sx, sy = clampUiPos(startX, startY, 180, 160)
    panel.Position = UDim2.new(0, sx, 0, sy)

    local title = Instance.new("TextLabel", panel)
    title.AutoLocalize = false
    title.Size = UDim2.new(1, -10, 0, 20)
    title.Position = UDim2.new(0, 8, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "SPEEDS"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextColor3 = Color3.fromRGB(236, 236, 244)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 242

    local modeBtn = Instance.new("TextButton", panel)
    modeBtn.AutoLocalize = false
    modeBtn.Size = UDim2.new(1, -10, 0, 22)
    modeBtn.Position = UDim2.new(0, 5, 0, 24)
    modeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    modeBtn.BorderSizePixel = 0
    modeBtn.Font = Enum.Font.GothamBold
    modeBtn.TextSize = 10
    modeBtn.TextColor3 = Color3.fromRGB(235, 235, 242)
    modeBtn.ZIndex = 242
    Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)

    local function refreshModeBtn()
        local lagOn = Features["LaggerSpeed"] == true
        modeBtn.Text = lagOn and "MODE: LAGGER" or "MODE: NORMAL"
        modeBtn.BackgroundColor3 = lagOn and Color3.fromRGB(62, 40, 78) or Color3.fromRGB(28, 28, 34)
    end
    modeBtn.MouseButton1Click:Connect(function()
        if FeatureSetters["LaggerSpeed"] then
            FeatureSetters["LaggerSpeed"](not (Features["LaggerSpeed"] == true))
        elseif FeatureToggles["LaggerSpeed"] then
            FeatureToggles["LaggerSpeed"]()
        end
        refreshModeBtn()
        refreshSpeedSyncKey("BoostSpeed")
        refreshSpeedSyncKey("StealingSpeedValue")
        task.defer(saveConfig)
    end)
    refreshModeBtn()

    local function addRow(order, key, label)
        local y = 50 + (order - 1) * 25
        local row = Instance.new("Frame", panel)
        row.Size = UDim2.new(1, -10, 0, 22)
        row.Position = UDim2.new(0, 5, 0, y)
        row.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
        row.BorderSizePixel = 0
        row.ZIndex = 241
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel", row)
        lbl.AutoLocalize = false
        lbl.Size = UDim2.new(0, 96, 1, 0)
        lbl.Position = UDim2.new(0, 6, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextColor3 = Color3.fromRGB(220, 220, 230)
        lbl.ZIndex = 242
        lbl.Text = label

        local valBox = Instance.new("TextBox", row)
        valBox.AutoLocalize = false
        valBox.Size = UDim2.new(0, 30, 0, 16)
        valBox.Position = UDim2.new(1, -78, 0.5, -8)
        valBox.BackgroundColor3 = Color3.fromRGB(34, 34, 42)
        valBox.BorderSizePixel = 0
        valBox.ClearTextOnFocus = false
        valBox.Font = Enum.Font.GothamBold
        valBox.TextSize = 10
        valBox.TextColor3 = Color3.fromRGB(236, 236, 244)
        valBox.PlaceholderText = "0"
        valBox.ZIndex = 243
        Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)

        local minus = Instance.new("TextButton", row)
        minus.AutoLocalize = false
        minus.Size = UDim2.new(0, 16, 0, 16)
        minus.Position = UDim2.new(1, -44, 0.5, -8)
        minus.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
        minus.BorderSizePixel = 0
        minus.Text = "-"
        minus.Font = Enum.Font.GothamBold
        minus.TextSize = 11
        minus.TextColor3 = Color3.fromRGB(230, 230, 238)
        minus.ZIndex = 243
        Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 4)

        local plus = minus:Clone()
        plus.Parent = row
        plus.Position = UDim2.new(1, -24, 0.5, -8)
        plus.Text = "+"
        minus.Parent = row

        local function formatSpeed(v)
            return tostring(math.floor((tonumber(v) or 0) * 10 + 0.5) / 10)
        end

        local function refresh()
            valBox.Text = formatSpeed(Values[key])
        end
        registerSpeedMiniRefresher(key, refresh)
        minus.MouseButton1Click:Connect(function()
            Values[key] = math.max(0, (Values[key] or 0) - 1)
            refreshSpeedSyncKey(key)
            task.defer(saveConfig)
        end)
        plus.MouseButton1Click:Connect(function()
            Values[key] = (Values[key] or 0) + 1
            refreshSpeedSyncKey(key)
            task.defer(saveConfig)
        end)
        valBox.FocusLost:Connect(function(enterPressed)
            if not enterPressed then
                refresh()
                return
            end
            local num = tonumber(valBox.Text)
            if not num then
                refresh()
                return
            end
            Values[key] = math.max(0, math.floor(num * 10 + 0.5) / 10)
            refreshSpeedSyncKey(key)
            task.defer(saveConfig)
        end)
        refresh()
    end

    addRow(1, "BoostSpeed", "Boost")
    addRow(2, "StealingSpeedValue", "Steal")
    addRow(3, "LaggerBoostSpeed", "Lag Boost")
    addRow(4, "LaggerStealSpeed", "Lag Steal")

    local dragging, dragInput, dragStart, frameStart = false, nil, nil, nil
    panel.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragInput = inp
        dragStart = inp.Position
        frameStart = panel.Position
    end)
    panel.InputEnded:Connect(function(inp)
        if not dragging or inp ~= dragInput then return end
        dragging = false
        dragInput = nil
        SpeedMiniPos = { x = math.floor(panel.Position.X.Offset), y = math.floor(panel.Position.Y.Offset) }
        task.defer(saveConfig)
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging or inp ~= dragInput then return end
        local d = inp.Position - dragStart
        local vp2 = workspace.CurrentCamera.ViewportSize
        local nx = math.clamp(frameStart.X.Offset + d.X, 0, vp2.X - panel.AbsoluteSize.X)
        local ny = math.clamp(frameStart.Y.Offset + d.Y, 0, vp2.Y - panel.AbsoluteSize.Y)
        panel.Position = UDim2.new(0, nx, 0, ny)
    end)
end

function makeToggle(parent, labelText, featureName, onToggle, noBind)
    local frame, _             = makeRowFrame(parent, ROW_H)
    local controlsFloatingBtn  = FloatingFeatureSet[featureName] == true
    local isOn                 = controlsFloatingBtn and (FloatingButtonEnabled[featureName] == true)
        or (Features[featureName] == true)

    local lbl                  = Instance.new("TextLabel", frame)
    lbl.AutoLocalize           = false
    lbl.Size                   = UDim2.new(0.52, 0, 1, 0)
    lbl.Position               = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = labelText
    lbl.TextColor3             = _C_TEXT2
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextSize               = 12
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.ZIndex                 = 4

    local bindBtn              = nil
    local bindStrokeRef        = nil

    local function shouldShowBindButtons()
        local hasGamepadNow = UserInputService.GamepadEnabled or #UserInputService:GetConnectedGamepads() > 0
        if UserInputService.TouchEnabled and not hasGamepadNow then
            return false
        end
        local kbOn = _G["_ZurichHub_KeybindsOn"]
        if kbOn == nil then kbOn = true end
        return kbOn
    end
    if not noBind then
        bindBtn                                        = Instance.new("TextButton", frame)
        bindBtn.AutoLocalize                           = false
        bindBtn.Size                                   = UDim2.new(0, 40, 0, 18)
        bindBtn.Position                               = UDim2.new(1, -96, 0.5, -9)
        bindBtn.BackgroundColor3                       = Color3.fromRGB(24, 24, 28)
        bindBtn.TextColor3                             = _C_SUB2
        bindBtn.Font                                   = Enum.Font.GothamBold
        bindBtn.TextSize                               = 9
        bindBtn.Text                                   = "BIND"
        bindBtn.BorderSizePixel                        = 0
        bindBtn.ZIndex                                 = 7
        bindBtn.AutoButtonColor                        = false
        bindBtn.ClipsDescendants                       = true
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 6)
        local bStroke                                  = Instance.new("UIStroke", bindBtn)
        bStroke.Thickness                              = 1
        bStroke.ApplyStrokeMode                        = Enum.ApplyStrokeMode.Border
        bStroke.Color                                  = Color3.fromRGB(74, 74, 84)
        bStroke.Transparency                           = 0.2
        bindStrokeRef                                  = bStroke

        local function refreshBindVisual()
            local gpBinds = _G["_ZurichHub_GamepadKeybinds"]
            local gpKey   = gpBinds and gpBinds[featureName]
            local kbKey   = FeatureKeybinds[featureName]
            local key     = gpKey or kbKey
            if key then
                local name               = (GP_NAMES and GP_NAMES[key])
                    or tostring(key):match("KeyCode%.(.+)")
                    or tostring(key)
                bindBtn.Text             = name
                bindBtn.BackgroundColor3 = Color3.fromRGB(236, 236, 242)
                bindBtn.TextColor3       = Color3.fromRGB(14, 14, 18)
                bStroke.Color            = Color3.fromRGB(255, 255, 255)
            else
                bindBtn.Text             = "BIND"
                bindBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
                bindBtn.TextColor3       = _C_SUB2
                bStroke.Color            = Color3.fromRGB(74, 74, 84)
            end
        end

        FeatureBindBtns[featureName] = refreshBindVisual
        table.insert(_allBindBtns, bindBtn)
        bindBtn.Visible = shouldShowBindButtons()
        UserInputService.GamepadConnected:Connect(function()
            bindBtn.Visible = shouldShowBindButtons()
            refreshBindVisual()
        end)
        UserInputService.GamepadDisconnected:Connect(function()
            bindBtn.Visible = shouldShowBindButtons()
            refreshBindVisual()
        end)

        local function stopListening()
            listeningBindBtn = nil
            listeningFeature = nil
            refreshBindVisual()
        end

        bindBtn.MouseButton1Click:Connect(function()
            if listeningBindBtn == bindBtn then
                stopListening(); return
            end
            if listeningBindBtn then
                listeningBindBtn.Text             = "BIND"
                listeningBindBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
                listeningBindBtn.TextColor3       = _C_SUB2
            end
            listeningBindBtn         = bindBtn
            listeningFeature         = featureName
            bindBtn.Text             = "..."
            bindBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            bindBtn.TextColor3       = Color3.fromRGB(10, 10, 12)
            bStroke.Color            = Color3.fromRGB(255, 255, 255)
        end)
        bindBtn.MouseEnter:Connect(function()
            if listeningBindBtn ~= bindBtn then
                local gpBinds = _G["_ZurichHub_GamepadKeybinds"]
                local hasAssignedKey = (gpBinds and gpBinds[featureName]) or FeatureKeybinds[featureName]
                if hasAssignedKey then
                    refreshBindVisual()
                else
                    for k, v in pairs({ BackgroundColor3 = Color3.fromRGB(36, 36, 42) }) do bindBtn[k] = v end
                end
            end
        end)
        bindBtn.MouseLeave:Connect(function()
            if listeningBindBtn ~= bindBtn then
                refreshBindVisual()
            end
        end)
    end

    local pillW                                   = 36
    local pillH                                   = 20
    local circleD                                 = pillH - 4

    local pill                                    = Instance.new("Frame", frame)
    pill.Size                                     = UDim2.new(0, pillW, 0, pillH)
    pill.Position                                 = UDim2.new(1, -(pillW + 10), 0.5, -pillH / 2)
    pill.BackgroundColor3                         = Color3.fromRGB(40, 40, 46)
    pill.BorderSizePixel                          = 0
    pill.ZIndex                                   = 4
    pill.BackgroundTransparency                   = 0.4
    Instance.new("UICorner", pill).CornerRadius   = UDim.new(1, 0)
    local pillStroke                              = Instance.new("UIStroke", pill)
    pillStroke.Color                              = Color3.fromRGB(70, 70, 80)
    pillStroke.Thickness                          = 1
    pillStroke.Transparency                       = 0

    local circle                                  = Instance.new("Frame", pill)
    circle.Size                                   = UDim2.new(0, circleD, 0, circleD)
    circle.Position                               = UDim2.new(0, 2, 0.5, -circleD / 2)
    circle.BackgroundColor3                       = Color3.fromRGB(225, 225, 232)
    circle.BorderSizePixel                        = 0
    circle.ZIndex                                 = 5
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local function updateVisual()
        if isOn then
            for k, v in pairs({ BackgroundColor3 = Color3.fromRGB(235, 235, 242) }) do pill[k] = v end
            pillStroke.Color = Color3.fromRGB(255, 255, 255)
            for k, v in pairs({ Position = UDim2.new(1, -(circleD + 2), 0.5, -circleD / 2),
                BackgroundColor3 = Color3.fromRGB(16, 16, 20) }) do circle[k] = v end
        else
            for k, v in pairs({ BackgroundColor3 = Color3.fromRGB(36, 36, 42) }) do pill[k] = v end
            pillStroke.Color = Color3.fromRGB(70, 70, 80)
            for k, v in pairs({ Position = UDim2.new(0, 2, 0.5, -circleD / 2),
                BackgroundColor3 = Color3.fromRGB(225, 225, 232) }) do circle[k] = v end
        end
    end

    local locked                  = false

    local hitbox                  = Instance.new("TextButton", frame)
    hitbox.AutoLocalize           = false
    hitbox.Size                   = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text                   = ""
    hitbox.ZIndex                 = 6
    hitbox.MouseEnter:Connect(function()
        if locked then return end
        for k, v in pairs({ BackgroundColor3 = _C_ROW2, BackgroundTransparency = 0.02 }) do frame[k] = v end
    end)
    hitbox.MouseLeave:Connect(function()
        for k, v in pairs({ BackgroundColor3 = _C_ROW, BackgroundTransparency = 0.08 }) do frame[k] = v end
    end)

    local _tapStart   = nil
    local _tapMoved   = false
    local _tapScrollY = nil
    local TAP_THRESH  = isMobile and 20 or 6

    local function doToggle()
        if locked then return end
        if controlsFloatingBtn then
            isOn = not isOn
            FloatingButtonEnabled[featureName] = isOn
            updateVisual()
            if isOn then
                makeFloatingButton(featureName, function()
                    if FeatureToggles[featureName] then FeatureToggles[featureName]() end
                end)
            else
                local btn = FloatingButtons[featureName]
                if btn and btn.destroy then btn.destroy() end
                if Features[featureName] == true and FeatureSetters[featureName] then
                    FeatureSetters[featureName](false)
                end
            end
            task.defer(saveConfig)
            spawnBubbles(frame, isOn)
            showFeatureNotif(labelText, isOn)
            return
        end

        isOn = not isOn
        updateVisual()
        if Features[featureName] ~= nil then
            Features[featureName] = isOn
        end
        spawnBubbles(frame, isOn)
        showFeatureNotif(labelText, isOn)
        if onToggle then onToggle(isOn) end
        task.defer(saveConfig)
    end

    if not isMobile then
        hitbox.MouseButton1Click:Connect(doToggle)
    else
        hitbox.InputBegan:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Touch then return end
            _tapStart   = inp.Position
            _tapMoved   = false
            _tapScrollY = mainScroll.CanvasPosition.Y
        end)
        hitbox.InputChanged:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Touch then return end
            if not _tapStart or _tapMoved then return end
            local dx = math.abs(inp.Position.X - _tapStart.X)
            local dy = math.abs(inp.Position.Y - _tapStart.Y)
            if dx > TAP_THRESH or dy > TAP_THRESH then
                _tapMoved = true
            end
        end)
        hitbox.InputEnded:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Touch then return end
            if _tapStart and not _tapMoved then
                local scrollDelta = math.abs(mainScroll.CanvasPosition.Y - (_tapScrollY or 0))
                if scrollDelta <= 5 then
                    doToggle()
                end
            end
            _tapStart   = nil
            _tapMoved   = false
            _tapScrollY = nil
        end)
    end

    local function setV(state)
        if controlsFloatingBtn then
            if Features[featureName] ~= nil then
                Features[featureName] = state
            end
            if onToggle then onToggle(state) end
            local btn = FloatingButtons[featureName]
            if btn and btn.refresh then btn.refresh() end
            return
        end

        isOn = state
        if Features[featureName] ~= nil then
            Features[featureName] = isOn
        end
        updateVisual()
        if onToggle then onToggle(isOn) end
    end
    FeatureSetters[featureName] = setV
    local function getV()
        if controlsFloatingBtn then
            return Features[featureName] == true
        end
        return isOn
    end

    FeatureToggles[featureName] = function()
        if controlsFloatingBtn then
            if not isOn then return end
            local runtimeOn = not (Features[featureName] == true)
            if Features[featureName] ~= nil then
                Features[featureName] = runtimeOn
            end
            if onToggle then onToggle(runtimeOn) end
            local btn = FloatingButtons[featureName]
            if btn and btn.refresh then btn.refresh() end
            spawnBubbles(frame, runtimeOn)
            showFeatureNotif(labelText, runtimeOn)
            return
        end
        isOn = not isOn
        if Features[featureName] ~= nil then
            Features[featureName] = isOn
        end
        updateVisual()
        spawnBubbles(frame, isOn)
        showFeatureNotif(labelText, isOn)
        if onToggle then
            onToggle(isOn)
        end
    end

    local function setLocked(state)
        locked = state
        if state then
            lbl.TextTransparency    = 0.55
            pill.BackgroundColor3   = Color3.fromRGB(24, 24, 28)
            pillStroke.Color        = Color3.fromRGB(48, 48, 56)
            circle.BackgroundColor3 = Color3.fromRGB(96, 96, 108)
            if bindBtn then
                bindBtn.BackgroundTransparency = 0.6
                bindBtn.TextTransparency       = 0.6
                bindBtn.Active                 = false
            end
            hitbox.Active = false
        else
            lbl.TextTransparency = 0
            hitbox.Active        = true
            if bindBtn then
                bindBtn.BackgroundTransparency = 0.1
                bindBtn.TextTransparency       = 0
                bindBtn.Active                 = true
            end
            updateVisual()
        end
    end

    updateVisual()
    if controlsFloatingBtn and isOn then
        FloatingButtonEnabled[featureName] = true
        makeFloatingButton(featureName, function()
            if FeatureToggles[featureName] then FeatureToggles[featureName]() end
        end)
    end

    return hitbox, setV, getV, featureName, setLocked
end

task.defer(makeSpeedMiniUI)
task.spawn(function()
    while true do
        task.wait(0.2)
        for valueKey in pairs(SpeedSyncKeys) do
            local now = Values[valueKey]
            if _speedSyncCache[valueKey] ~= now then
                _speedSyncCache[valueKey] = now
                refreshSpeedSyncKey(valueKey)
            end
        end
    end
end)

-- ==================== makeSlider ====================
function makeSlider(parent, labelText, minVal, maxVal, valueKey, onChange)
    local frame, _               = makeRowFrame(parent, SLIDER_H)
    local useDecimals            = (minVal < 1)

    local label                  = Instance.new("TextLabel", frame)
    label.AutoLocalize           = false
    label.Size                   = UDim2.new(0.6, 0, 0, 20)
    label.Position               = UDim2.new(0, 14, 0, 4)
    label.BackgroundTransparency = 1
    label.Text                   = labelText
    label.TextColor3             = _C_TEXT2
    label.Font                   = Enum.Font.GothamBold
    label.TextSize               = 12
    label.TextXAlignment         = Enum.TextXAlignment.Left
    label.ZIndex                 = 4

    local trackH                 = isMobile and 5 or 3
    local thumbD                 = isMobile and 22 or 11
    local trackY                 = isMobile and 32 or 30
    local INTENT_THRESH          = isMobile and 14 or 8

    local initVal                = math.clamp(Values[valueKey] or minVal, minVal, maxVal)
    local initPct                = (initVal - minVal) / math.max(maxVal - minVal, 1)

    local function formatVal(v)
        return useDecimals and string.format("%.1f", v) or tostring(v)
    end

    local valLabel = nil
    local valBox   = nil

    if useDecimals then
        valBox                                        = Instance.new("TextBox", frame)
        valBox.AutoLocalize                           = false
        valBox.Size                                   = UDim2.new(0, 46, 0, 20)
        valBox.Position                               = UDim2.new(1, -52, 0, 4)
        valBox.BackgroundColor3                       = Color3.fromRGB(22, 22, 26)
        valBox.BackgroundTransparency                 = 0.12
        valBox.Text                                   = formatVal(initVal)
        valBox.Font                                   = Enum.Font.GothamBold
        valBox.TextSize                               = 12
        valBox.TextColor3                             = _C_SUB2
        valBox.TextXAlignment                         = Enum.TextXAlignment.Center
        valBox.ZIndex                                 = 9
        valBox.ClearTextOnFocus                       = true
        valBox.BorderSizePixel                        = 0
        Instance.new("UICorner", valBox).CornerRadius = UDim.new(0, 4)
        local vbStroke                                = Instance.new("UIStroke", valBox)
        vbStroke.Color                                = Color3.fromRGB(86, 86, 98)
        vbStroke.Thickness                            = 1
        vbStroke.Transparency                         = 0.4
        addAccent(valBox, "TextColor3")

        valBox.Focused:Connect(function()
            for k, v in pairs({ BackgroundColor3 = Color3.fromRGB(28, 28, 34), BackgroundTransparency = 0 }) do
                valBox[k] =
                    v
            end
            vbStroke.Color        = Color3.fromRGB(255, 255, 255)
            vbStroke.Transparency = 0
        end)
        valBox.FocusLost:Connect(function()
            for k, v in pairs({ BackgroundColor3 = Color3.fromRGB(22, 22, 26), BackgroundTransparency = 0.12 }) do
                valBox[k] =
                    v
            end
            vbStroke.Color        = Color3.fromRGB(86, 86, 98)
            vbStroke.Transparency = 0.4
        end)
    else
        valLabel                        = Instance.new("TextLabel", frame)
        valLabel.AutoLocalize           = false
        valLabel.Size                   = UDim2.new(0, 46, 0, 20)
        valLabel.Position               = UDim2.new(1, -52, 0, 4)
        valLabel.BackgroundTransparency = 1
        valLabel.Text                   = formatVal(initVal)
        valLabel.Font                   = Enum.Font.GothamBold
        valLabel.TextSize               = 12
        valLabel.TextColor3             = _C_SUB2
        valLabel.TextXAlignment         = Enum.TextXAlignment.Right
        valLabel.ZIndex                 = 4
        addAccent(valLabel, "TextColor3")
    end

    local track                                  = Instance.new("Frame", frame)
    track.Size                                   = UDim2.new(1, -20, 0, trackH)
    track.Position                               = UDim2.new(0, 10, 0, trackY)
    track.BackgroundColor3                       = Color3.fromRGB(34, 34, 40)
    track.BorderSizePixel                        = 0
    track.ZIndex                                 = 4
    track.BackgroundTransparency                 = 0.5
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill                                   = Instance.new("Frame", track)
    fill.Size                                    = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3                        = Color3.fromRGB(236, 236, 242)
    fill.BorderSizePixel                         = 0
    fill.ZIndex                                  = 5
    Instance.new("UICorner", fill).CornerRadius  = UDim.new(1, 0)
    addAccent(fill, "BackgroundColor3")

    local thumb                                  = Instance.new("Frame", track)
    thumb.Size                                   = UDim2.new(0, thumbD, 0, thumbD)
    thumb.Position                               = UDim2.new(initPct, -thumbD / 2, 0.5, -thumbD / 2)
    thumb.BackgroundColor3                       = Color3.fromRGB(255, 255, 255)
    thumb.BorderSizePixel                        = 0
    thumb.ZIndex                                 = 6
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local hitbox                                 = Instance.new("TextButton", frame)
    hitbox.AutoLocalize                          = false
    hitbox.Size                                  = UDim2.new(1, -20, 0, SLIDER_H)
    hitbox.Position                              = UDim2.new(0, 10, 0, 0)
    hitbox.BackgroundTransparency                = 1
    hitbox.Text                                  = ""
    hitbox.ZIndex                                = 8
    hitbox.AutoButtonColor                       = false

    local dragging                               = false
    local touching                               = false
    local startPos                               = nil
    local intentDetermined                       = false

    local function applyValue(val)
        if useDecimals then
            val = math.floor(val * 10 + 0.5) / 10
        else
            val = math.round(val)
        end
        val = math.clamp(val, minVal, maxVal)
        if valueKey and Values[valueKey] ~= nil then Values[valueKey] = val end
        local pct = (val - minVal) / math.max(maxVal - minVal, 1)
        if valBox then valBox.Text = formatVal(val) end
        if valLabel then valLabel.Text = formatVal(val) end
        fill.Size      = UDim2.new(pct, 0, 1, 0)
        thumb.Position = UDim2.new(pct, -thumbD / 2, 0.5, -thumbD / 2)
        if onChange then onChange(val) end
    end

    local function update(relX)
        relX = math.clamp(relX, 0, 1)
        applyValue(minVal + (maxVal - minVal) * relX)
    end

    update(initPct)

    hitbox.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; touching = false; startPos = nil; intentDetermined = true
        elseif inp.UserInputType == Enum.UserInputType.Touch then
            touching = true; dragging = false; intentDetermined = false; startPos = inp.Position
        end
    end)
    hitbox.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false; touching = false; startPos = nil; intentDetermined = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging and intentDetermined then
            local ax = track.AbsolutePosition.X
            local aw = track.AbsoluteSize.X
            if aw <= 0 then return end
            update((inp.Position.X - ax) / aw)
            return
        end
        if not intentDetermined and touching and startPos and inp.UserInputType == Enum.UserInputType.Touch then
            local dx = math.abs(inp.Position.X - startPos.X)
            local dy = math.abs(inp.Position.Y - startPos.Y)
            if dx > INTENT_THRESH or dy > INTENT_THRESH then
                intentDetermined = true
                if dx > dy then
                    dragging = true
                else
                    dragging = false; touching = false; startPos = nil
                end
            end
        end
        if not dragging then return end
        local ax = track.AbsolutePosition.X
        local aw = track.AbsoluteSize.X
        if aw <= 0 then return end
        update((inp.Position.X - ax) / aw)
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging or touching then
                dragging = false; touching = false; startPos = nil; intentDetermined = false
            end
        end
    end)

    if valBox then
        valBox.Focused:Connect(function() hitbox.Active = false end)
        valBox.FocusLost:Connect(function()
            hitbox.Active = true
            local num = tonumber(valBox.Text)
            if num then
                applyValue(num)
            else
                valBox.Text = formatVal(math.clamp(Values[valueKey] or minVal, minVal, maxVal))
            end
        end)
    end

    return frame
end

-- ==================== makeValueBox ====================
function makeValueBox(parent, labelText, valueKey, minVal, maxVal, onChange)
    local frame, _                             = makeRowFrame(parent, ROW_H)

    local lbl                                  = Instance.new("TextLabel", frame)
    lbl.AutoLocalize                           = false
    lbl.Size                                   = UDim2.new(0.58, 0, 1, 0)
    lbl.Position                               = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency                 = 1
    lbl.Text                                   = labelText
    lbl.TextColor3                             = _C_TEXT2
    lbl.Font                                   = Enum.Font.GothamBold
    lbl.TextSize                               = 12
    lbl.TextXAlignment                         = Enum.TextXAlignment.Left
    lbl.ZIndex                                 = 4

    local box                                  = Instance.new("TextBox", frame)
    box.AutoLocalize                           = false
    box.Size                                   = UDim2.new(0, 58, 0, 24)
    box.Position                               = UDim2.new(1, -66, 0.5, -12)
    box.BackgroundColor3                       = Color3.fromRGB(22, 22, 26)
    box.BackgroundTransparency                 = 0.1
    box.Text                                   = tostring(Values[valueKey] or 29)
    box.Font                                   = Enum.Font.GothamBold
    box.TextSize                               = 13
    box.TextColor3                             = _C_TEXT2
    box.TextXAlignment                         = Enum.TextXAlignment.Center
    box.ZIndex                                 = 7
    box.ClearTextOnFocus                       = true
    box.BorderSizePixel                        = 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    local bStroke                              = Instance.new("UIStroke", box)
    bStroke.Color                              = Color3.fromRGB(92, 92, 102)
    bStroke.Thickness                          = 1.2
    bStroke.Transparency                       = 0.3
    bStroke.ApplyStrokeMode                    = Enum.ApplyStrokeMode.Border

    box.Focused:Connect(function()
        for k, v in pairs({ BackgroundColor3 = Color3.fromRGB(30, 30, 36), BackgroundTransparency = 0 }) do box[k] = v end
        bStroke.Transparency = 0
        bStroke.Color = Color3.fromRGB(255, 255, 255)
    end)
    box.FocusLost:Connect(function(enterPressed)
        for k, v in pairs({ BackgroundColor3 = Color3.fromRGB(22, 22, 26), BackgroundTransparency = 0.1 }) do box[k] = v end
        bStroke.Transparency = 0.3
        bStroke.Color = Color3.fromRGB(92, 92, 102)
        local num = tonumber(box.Text)
        if num then
            local clamped = math.clamp(math.floor(num * 10 + 0.5) / 10, minVal, maxVal)
            Values[valueKey] = clamped
            box.Text = tostring(clamped)
            if onChange then onChange(clamped) end
            refreshSpeedSyncKey(valueKey)
            task.defer(saveConfig)
        else
            box.Text = tostring(Values[valueKey] or minVal)
        end
    end)

    frame.MouseEnter:Connect(function()
        for k, v in pairs({ BackgroundColor3 = _C_ROW2, BackgroundTransparency = 0.02 }) do frame[k] = v end
    end)
    frame.MouseLeave:Connect(function()
        for k, v in pairs({ BackgroundColor3 = _C_ROW, BackgroundTransparency = 0.08 }) do frame[k] = v end
    end)

    registerSpeedMainBox(valueKey, box)
    refreshSpeedSyncKey(valueKey)
    return frame, box
end

-- ==================== LAGGER MODE TOGGLE (CON KEYBIND) ====================
do
    -- Verificar si ya existe un toggle para LaggerSpeed (por si acaso)
    if not FeatureToggles["LaggerSpeed"] then
        -- Crear el toggle en la UI principal
        local _, setLagger, getLagger, _, _ = makeToggle(mainScroll, "Lagger Mode", "LaggerSpeed", function(on)
            -- Esta función se ejecuta cuando se togglea desde la UI o keybind
            Features.LaggerSpeed = on
            -- Actualizar el botón del SpeedMiniUI si existe
            local miniModeBtn = nil
            -- Buscar el botón de modo en SpeedMiniUI (está dentro de un Frame llamado SpeedMiniUI)
            for _, child in ipairs(sg:GetDescendants()) do
                if child.Name == "SpeedMiniUI" then
                    for _, btn in ipairs(child:GetDescendants()) do
                        if btn.Name == "modeBtn" or (btn:IsA("TextButton") and btn.Text and btn.Text:find("MODE:")) then
                            miniModeBtn = btn
                            break
                        end
                    end
                    break
                end
            end
            if miniModeBtn then
                miniModeBtn.Text = on and "MODE: LAGGER" or "MODE: NORMAL"
                miniModeBtn.BackgroundColor3 = on and Color3.fromRGB(62, 40, 78) or Color3.fromRGB(28, 28, 34)
            end
            -- También refrescar los valores de velocidad en la UI mini
            refreshSpeedSyncKey("BoostSpeed")
            refreshSpeedSyncKey("StealingSpeedValue")
            task.defer(saveConfig)
        end)

        -- Sincronizar el estado inicial
        if Features.LaggerSpeed then
            setLagger(true)
        end
    else
    end
end


-- ==================== NO ANIM ====================
do
    local noAnimActive = false
    local noAnimConnection = nil

    local function toggleNoAnim(state)
        local char = Player.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        if state then
            if noAnimConnection then return end
            noAnimConnection = RunService.Heartbeat:Connect(function()
                for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                    track:Stop()
                    track:AdjustSpeed(0)
                end
            end)
        else
            if noAnimConnection then
                noAnimConnection:Disconnect()
                noAnimConnection = nil
            end
        end
    end

    Player.CharacterAdded:Connect(function(newChar)
        task.wait(1.5)
        if noAnimActive then
            if noAnimConnection then
                noAnimConnection:Disconnect()
                noAnimConnection = nil
            end
            toggleNoAnim(true)
        end
    end)

    makeToggle(mainScroll, "No Animation", "Unwalk", function(on)
        noAnimActive = on
        toggleNoAnim(on)
    end, true)
end

    -- ==================== ANTI RAGDOLL (sin BIND) ====================
    do
        local antiRagdollEnabled = false
        local antiRagdollConn    = nil

        local function startAntiRagdoll()
            if antiRagdollConn then return end
            local _arElapsed = 0
            antiRagdollConn = RunService.Heartbeat:Connect(function(dt)
                _arElapsed = _arElapsed + dt
                if _arElapsed < 0.05 then return end
                _arElapsed = 0
                if not antiRagdollEnabled then return end
                local character = Player.Character
                if not character then return end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local root     = character:FindFirstChild("HumanoidRootPart")
                if humanoid then
                    local st = humanoid:GetState()
                    if st == Enum.HumanoidStateType.Physics or
                        st == Enum.HumanoidStateType.Ragdoll or
                        st == Enum.HumanoidStateType.FallingDown then
                        humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        workspace.CurrentCamera.CameraSubject = humanoid
                        pcall(function()
                            local PM = Player.PlayerScripts:FindFirstChild("PlayerModule")
                            if PM then
                                local C = require(PM:FindFirstChild("ControlModule"))
                                if C then C:Enable() end
                            end
                        end)
                        if root then
                            root.Velocity = Vector3.new(0, 0, 0); root.RotVelocity = Vector3.new(0, 0, 0)
                        end
                        for _, obj in ipairs(character:GetDescendants()) do
                            pcall(function()
                                if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end
                            end)
                        end
                    end
                end
            end)
        end

        local function stopAntiRagdoll()
            if antiRagdollConn then
                antiRagdollConn:Disconnect(); antiRagdollConn = nil
            end
        end

        makeToggle(mainScroll, "Anti Ragdoll", "AntiRagdoll", function(on)
            antiRagdollEnabled = on
            if on then startAntiRagdoll() else stopAntiRagdoll() end
        end, true)
    end



    -- ==================== MEDUSA COUNTER ====================
    do
        local _medusaConn   = nil
        local _medusaFiring = false

        local function findMyMedusa()
            local char = Player.Character
            local bp   = Player:FindFirstChildOfClass("Backpack")
            if char then
                for _, tool in ipairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("medusa") then return tool end
                end
            end
            if bp then
                for _, tool in ipairs(bp:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("medusa") then return tool end
                end
            end
            return nil
        end

        local function activateMyMedusa()
            if _medusaFiring then return end
            local med = findMyMedusa()
            if not med then return end
            _medusaFiring = true
            task.spawn(function()
                local char = Player.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") and tool ~= med then
                            tool.Parent = Player.Backpack
                        end
                    end
                    if med.Parent ~= char then
                        med.Parent = char
                        task.wait(0.1)
                    end
                end
                pcall(function() med:Activate() end)
                task.wait(1)
                _medusaFiring = false
            end)
        end

        local function startMedusaCounter()
            if _medusaConn then return end
            _medusaConn = RunService.Heartbeat:Connect(function()
                if _medusaFiring then return end
                for _, sound in ipairs(workspace:GetDescendants()) do
                    if sound:IsA("Sound") and sound.Name == "Scream" and sound.IsPlaying then
                        local owner = sound.Parent
                        while owner and owner ~= workspace do
                            if owner:IsA("Model") then
                                local plr = Players:FindFirstChild(owner.Name)
                                if plr and plr ~= Player then
                                    local char = Player.Character
                                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                    local enemyHrp = owner:FindFirstChild("HumanoidRootPart")
                                    if hrp and enemyHrp then
                                        local dist = (hrp.Position - enemyHrp.Position).Magnitude
                                        if dist <= 17 then
                                            activateMyMedusa()
                                        end
                                    end
                                    break
                                end
                            end
                            owner = owner.Parent
                        end
                    end
                end
            end)
        end

        local function stopMedusaCounter()
            if _medusaConn then
                _medusaConn:Disconnect(); _medusaConn = nil
            end
        end

        makeToggle(mainScroll, "Medusa Counter", "MedusaCounter", function(on)
            if on then startMedusaCounter() else stopMedusaCounter() end
        end, true)
    end
    -- ==================== FIN MEDUSA COUNTER ====================



    -- ==================== DROP ====================
    local _dbFlingActive = false
    local _dbConns = {}

    local function doDropBrainrot()
        if _dbFlingActive then
            _dbFlingActive = false
            for _, conn in ipairs(_dbConns) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                elseif typeof(conn) == "thread" then
                    pcall(task.cancel, conn)
                end
            end
            _dbConns = {}
            local ch = Player.Character
            if ch then
                local root = ch:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Anchored = true; task.wait(0.5); root.Anchored = false
                end
            end
            Features.AutoDrop = false
            if dropSetV then dropSetV(false) end
            return
        end
        _dbFlingActive = true
        Features.AutoDrop = true
        local walkflinging = false
        local _flingNoclipCounter = 0
        local collConn = RunService.Stepped:Connect(function()
            if not _dbFlingActive then return end
            _flingNoclipCounter = _flingNoclipCounter + 1
            if _flingNoclipCounter < 3 then return end
            _flingNoclipCounter = 0
            local myChar = Player.Character
            if not myChar then return end
            for _, part in ipairs(myChar:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.CanTouch = false
                end
            end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character then
                    for _, part in ipairs(plr.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                            part.CanTouch = false
                        end
                    end
                end
            end
        end)
        table.insert(_dbConns, collConn)
        local character = Player.Character or Player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            local diedConn = humanoid.Died:Connect(function() walkflinging = false end)
            table.insert(_dbConns, diedConn)
        end
        walkflinging = true
        local movel = 0.1
        local flingThread = coroutine.create(function()
            repeat
                RunService.Heartbeat:Wait()
                if not _dbFlingActive then break end
                character = Player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                while not (character and character.Parent and root and root.Parent) do
                    RunService.Heartbeat:Wait()
                    if not _dbFlingActive then break end
                    character = Player.Character
                    root = character and character:FindFirstChild("HumanoidRootPart")
                end
                if not _dbFlingActive then break end
                local vel = root.Velocity
                root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if character and character.Parent and root and root.Parent then root.Velocity = vel end
                RunService.Stepped:Wait()
                if character and character.Parent and root and root.Parent then
                    root.Velocity = vel + Vector3.new(0, movel, 0)
                    movel = movel * -1
                end
            until walkflinging == false or not _dbFlingActive
        end)
        table.insert(_dbConns, flingThread)
        coroutine.resume(flingThread)
        task.delay(0.2, function()
            if not _dbFlingActive then return end
            _dbFlingActive = false
            for _, conn in ipairs(_dbConns) do
                if typeof(conn) == "RBXScriptConnection" then
                    conn:Disconnect()
                elseif typeof(conn) == "thread" then
                    pcall(task.cancel, conn)
                end
            end
            _dbConns = {}
            local ch = Player.Character
            if ch then
                local root = ch:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Anchored = true; task.wait(0.1); root.Anchored = false
                end
            end
            Features.AutoDrop = false
            if dropSetV then dropSetV(false) end
        end)
    end

    local dropSetV = nil
    local _, _dropSetV, _, _, _ = makeToggle(mainScroll, "Drop", "AutoDrop", function(on)
        if not on then return end
        task.delay(0.2, function()
            Features.AutoDrop = false
            if dropSetV then dropSetV(false) end
        end)
        if _dbFlingActive then return end
        if _G["_ZurichHub_AutoplayIsActive"] then
            if _G["_ZurichHub_AutoplayForceStop"] then _G["_ZurichHub_AutoplayForceStop"]() end
            showFeatureNotif("Autoplay cancelado (drop)", false)
        end
        if _G["_ZurichHub_StopAutoplayFloat"] then _G["_ZurichHub_StopAutoplayFloat"]() end
        _G["_ZurichHub_AutoplayIsActive"] = false
        doDropBrainrot()
    end)
    dropSetV = _dropSetV
-- ==================== AUTOPLAY ====================
do
    local autoplaySetV = nil
    local _, _autoplaySetV, _, _, _ = makeToggle(mainScroll, "Autoplay", "AutoPlay", function(on)
        if on then
            startAutoplay()
        else
            stopAutoplay()
        end
    end)
    autoplaySetV = _autoplaySetV

    -- Keybind
    FeatureToggles["AutoPlay"] = function()
        if Features.AutoPlay then
            stopAutoplay()
            Features.AutoPlay = false
            if autoplaySetV then autoplaySetV(false) end
            showFeatureNotif("Autoplay", false)
        else
            startAutoplay()
            Features.AutoPlay = true
            if autoplaySetV then autoplaySetV(true) end
            showFeatureNotif("Autoplay", true)
        end
    end

    -- Botón flotante
    local function setupFloatingButton()
        local btn = FloatingButtons["AutoPlay"]
        if btn and btn.host then
            local hit = btn.host:FindFirstChildOfClass("TextButton")
            if hit then
                hit.MouseButton1Click:Connect(function()
                    FeatureToggles["AutoPlay"]()
                end)
            end
        end
    end
    setupFloatingButton()
end
-- ==================== TP DOWN (DELAY 10ms - SIN REBOTE) ====================
do
    local tpDownEnabled = false
    local tpDownCooldown = false
    local tpDownHitbox = nil
    local tpDownSetV = nil
    
    -- Variables para congelación
    local isFrozen = false
    local currentFreezeThread = nil
    
    -- Cancelar salto
    local function cancelJump()
        local char = Player.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local state = hum:GetState()
        
        if state == Enum.HumanoidStateType.Jumping or
           state == Enum.HumanoidStateType.Freefall then
            
            hum:ChangeState(Enum.HumanoidStateType.Running)
            
            local currentVel = root.AssemblyLinearVelocity
            if currentVel.Y > 0 then
                root.AssemblyLinearVelocity = Vector3.new(currentVel.X, 0, currentVel.Z)
            end
            
            task.wait(0.01)
        end
    end
    
    -- Aplicar TP Down con raycast y teletransporte
    local function applyTPDown()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")

        -- Parámetros del raycast
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude

        -- Raycast hacia abajo (600 estudios)
        local origin = hrp.Position
        local direction = Vector3.new(0, -600, 0)
        local result = workspace:Raycast(origin, direction, raycastParams)

        if result then
            local groundPoint = result.Position
            local newPosition = Vector3.new(hrp.Position.X, groundPoint.Y + 3, hrp.Position.Z)
            hrp.CFrame = CFrame.new(newPosition)
            print("TP Down completado | Suelo en Y:", groundPoint.Y)
        else
            hrp.CFrame = hrp.CFrame - Vector3.new(0, 50, 0)
            print("No se encontró suelo, bajando 50 estudios")
        end
    end

    -- CONGELAR ULTRARRÁPIDO (10ms)
    local function freezeCharacter()
        if isFrozen then return end
        isFrozen = true
        
        if currentFreezeThread then
            task.cancel(currentFreezeThread)
            currentFreezeThread = nil
        end
        
        local char = Player.Character
        if not char then
            isFrozen = false
            return
        end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if root then
            _G["_TPDown_SavedVel"] = {
                X = root.AssemblyLinearVelocity.X,
                Y = root.AssemblyLinearVelocity.Y,
                Z = root.AssemblyLinearVelocity.Z
            }
            
            -- Congelar instantáneo
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            root.Anchored = true
        end
        
        if hum then
            _G["_TPDown_SavedWalkSpeed"] = hum.WalkSpeed
            _G["_TPDown_SavedJumpPower"] = hum.JumpPower
            
            hum.PlatformStand = true
            hum.AutoRotate = false
            hum.WalkSpeed = 0
            hum.JumpPower = 0
        end
        
        -- DESCONGELAR DESPUÉS DE 10 MILISEGUNDOS
        currentFreezeThread = task.spawn(function()
            task.wait(0.01)  -- ← 10 MILISEGUNDOS (suficiente para cancelar movimiento)
            
            local char2 = Player.Character
            if char2 then
                local root2 = char2:FindFirstChild("HumanoidRootPart")
                local hum2 = char2:FindFirstChildOfClass("Humanoid")
                
                if root2 then
                    root2.Anchored = false  -- ← DESANCLAR
                    
                    if _G["_TPDown_SavedVel"] then
                        root2.AssemblyLinearVelocity = Vector3.new(
                            _G["_TPDown_SavedVel"].X,
                            math.max(0, _G["_TPDown_SavedVel"].Y),
                            _G["_TPDown_SavedVel"].Z
                        )
                        _G["_TPDown_SavedVel"] = nil
                    end
                end
                
                if hum2 then
                    hum2.PlatformStand = false
                    hum2.AutoRotate = true
                    
                    if Features.SpeedBoost then
                        if Features.LaggerSpeed then
                            hum2.WalkSpeed = Values.LaggerBoostSpeed
                        else
                            hum2.WalkSpeed = Values.BoostSpeed
                        end
                    else
                        hum2.WalkSpeed = 16
                    end
                    hum2.JumpPower = 50
                end
            end
            
            _G["_TPDown_SavedVel"] = nil
            _G["_TPDown_SavedWalkSpeed"] = nil
            _G["_TPDown_SavedJumpPower"] = nil
            
            isFrozen = false
            currentFreezeThread = nil
        end)
    end
    
    -- DESCONGELAR FORZADO
    local function forceUnfreeze()
        if currentFreezeThread then
            task.cancel(currentFreezeThread)
            currentFreezeThread = nil
        end
        
        local char = Player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if root then
                root.Anchored = false
            end
            
            if hum then
                hum.PlatformStand = false
                hum.AutoRotate = true
                
                if Features.SpeedBoost then
                    if Features.LaggerSpeed then
                        hum.WalkSpeed = Values.LaggerBoostSpeed
                    else
                        hum.WalkSpeed = Values.BoostSpeed
                    end
                else
                    hum.WalkSpeed = 16
                end
                hum.JumpPower = 50
            end
        end
        
        _G["_TPDown_SavedVel"] = nil
        isFrozen = false
    end
    
    -- Raycast para detectar suelo
    local function checkGroundAndFreeze()
        if isFrozen then return end
        
        local char = Player.Character
        if not char then return end
        
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = { char }
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        
        local rayResult = workspace:Raycast(root.Position, Vector3.new(0, -2.5, 0), rayParams)
        
        if rayResult then
            local distanceToGround = root.Position.Y - rayResult.Position.Y
            local isFalling = root.AssemblyLinearVelocity.Y < 0
            
            if distanceToGround <= 1.5 and isFalling then
                freezeCharacter()
            end
        end
    end
    
    -- Monitoreo
    local fallMonitorConn = nil
    
    local function startFallMonitor()
        if fallMonitorConn then return end
        fallMonitorConn = RunService.Heartbeat:Connect(function()
            if not tpDownEnabled then return end
            checkGroundAndFreeze()
        end)
    end
    
    local function stopFallMonitor()
        if fallMonitorConn then
            fallMonitorConn:Disconnect()
            fallMonitorConn = nil
        end
    end
    
    -- Activar TP Down
    local function activateTPDown()
        if tpDownCooldown then return end
        if not tpDownEnabled then return end
        
        tpDownCooldown = true
        
        forceUnfreeze()
        cancelJump()
        
        task.wait(0.01)
        
        applyTPDown()
        startFallMonitor()
        
        -- Feedback visual
        local btn = FloatingButtons["TPDown"]
        if btn and btn.host then
            local originalColor = btn.host.BackgroundColor3
            TweenService:Create(btn.host, TweenInfo.new(0.05), {
                BackgroundColor3 = Color3.fromRGB(120, 30, 30)
            }):Play()
            task.delay(0.05, function()
                if btn and btn.host then
                    TweenService:Create(btn.host, TweenInfo.new(0.05), {
                        BackgroundColor3 = originalColor
                    }):Play()
                end
            end)
        end
        
        -- Cooldown muy corto
        task.delay(0.15, function()
            tpDownCooldown = false
        end)
    end
    
    -- Toggle
    local function onTPDownToggle(state)
        tpDownEnabled = state
        Features.TPDown = state
        
        if not state then
            stopFallMonitor()
            forceUnfreeze()
        end
    end
    
    -- Crear toggle
    local hitbox, setV, getV = makeToggle(mainScroll, "TP Down", "TPDown", function(on)
        onTPDownToggle(on)
    end)
    tpDownHitbox = hitbox
    tpDownSetV = setV
    
    -- Keybind
    FeatureToggles["TPDown"] = function()
        if Features.TPDown then
            activateTPDown()
        else
            local newState = true
            Features.TPDown = newState
            onTPDownToggle(newState)
            if tpDownSetV then tpDownSetV(newState) end
            showFeatureNotif("TP Down", newState)
        end
    end
    
    -- Botón flotante
    local function setupFloatingButton()
        local btn = FloatingButtons["TPDown"]
        if btn and btn.host then
            local hit = btn.host:FindFirstChildOfClass("TextButton")
            if hit then
                hit.MouseButton1Click:Connect(function()
                    if Features.TPDown then
                        activateTPDown()
                    end
                end)
            end
        end
    end
    
    -- Inicializar
    if Features.TPDown then
        task.spawn(function()
            task.wait(0.5)
            tpDownEnabled = true
            if tpDownSetV then tpDownSetV(true) end
        end)
    end
    
    -- Hook
    local oldMakeFloating = makeFloatingButton
    makeFloatingButton = function(featureName, onToggle)
        local result = oldMakeFloating(featureName, onToggle)
        if featureName == "TPDown" and result then
            task.spawn(setupFloatingButton)
        end
        return result
    end
    
    task.delay(1, setupFloatingButton)
    
    -- Limpiar al morir
    Player.CharacterAdded:Connect(function()
        forceUnfreeze()
        if tpDownEnabled then
            stopFallMonitor()
        end
    end)
end
-- ==================== FIN TP DOWN ====================
-- ==================== AUTO TP DOWN LOOP (CORREGIDO - SE PUEDE APAGAR) ====================
do
    local autoTPEnabled = false
    local autoTPActive = false
    local autoTPCoroutine = nil
    local TARGET_HEIGHT = 25
    local UPWARD_FORCE = 65
    local LOOP_DELAY = 0.3

    -- Elementos para la subida
    local upwardLV = nil
    local upwardAtt = nil

    local function getHeightAboveGround()
        local char = Player.Character
        if not char then return 0 end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return 0 end
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = { char }
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rayParams)
        return result and (hrp.Position.Y - result.Position.Y) or 0
    end

    local function startAscend()
        if upwardLV then upwardLV:Destroy() end
        if upwardAtt then upwardAtt:Destroy() end
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        upwardAtt = Instance.new("Attachment", hrp)
        upwardAtt.Name = "AutoTPAtt"
        upwardLV = Instance.new("LinearVelocity", hrp)
        upwardLV.Name = "AutoTPLV"
        upwardLV.Attachment0 = upwardAtt
        upwardLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
        upwardLV.LineDirection = Vector3.new(0, 1, 0)
        upwardLV.RelativeTo = Enum.ActuatorRelativeTo.World
        upwardLV.MaxForce = math.huge
        upwardLV.LineVelocity = UPWARD_FORCE
    end

    local function stopAscend()
        if upwardLV then upwardLV:Destroy() end
        if upwardAtt then upwardAtt:Destroy() end
        upwardLV = nil
        upwardAtt = nil
    end

    local function executeTPDown()
        local wasEnabled = Features.TPDown
        if not wasEnabled then
            if FeatureToggles["TPDown"] then FeatureToggles["TPDown"]() end
        end
        if FeatureToggles["TPDown"] then FeatureToggles["TPDown"]() end
        if not wasEnabled then
            task.delay(0.2, function()
                if FeatureToggles["TPDown"] and Features.TPDown then
                    FeatureToggles["TPDown"]()
                end
            end)
        end
    end

    local function waitForLanding()
        task.wait(0.1)
        local timeout = tick() + 2
        repeat
            task.wait(0.03)
            local char = Player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then break end
            local velY = math.abs(hrp.AssemblyLinearVelocity.Y)
            if velY < 2 then break end
        until tick() > timeout
    end

    -- Bucle principal con verificación constante de estado
    local function runLoop()
        while autoTPEnabled and autoTPActive do
            -- Verificar antes de cada acción si debe continuar
            if not autoTPEnabled or not autoTPActive then break end

            -- Subir
            startAscend()
            local startTime = tick()
            repeat
                task.wait(0.05)
                if not autoTPEnabled or not autoTPActive then 
                    stopAscend()
                    return
                end
                local h = getHeightAboveGround()
                if h >= TARGET_HEIGHT then break end
                if tick() - startTime > 8 then break end
            until false
            stopAscend()

            if not autoTPEnabled or not autoTPActive then break end
            task.wait(0.1)

            -- TP Down
            executeTPDown()
            waitForLanding()
            if not autoTPEnabled or not autoTPActive then break end
            task.wait(LOOP_DELAY)
        end
        autoTPActive = false
    end

    local function startAutoTP()
        if autoTPActive then return end
        if not autoTPEnabled then return end
        autoTPActive = true
        if autoTPCoroutine then task.cancel(autoTPCoroutine) end
        autoTPCoroutine = task.spawn(runLoop)
    end

    local function cancelAutoTP()
        -- Detener el bucle marcando las variables
        autoTPActive = false
        autoTPEnabled = false  -- Asegurar que también se desactiva el estado
        if autoTPCoroutine then
            task.cancel(autoTPCoroutine)
            autoTPCoroutine = nil
        end
        stopAscend()
        -- Restaurar el estado del toggle visualmente
        if FeatureSetters["AutoTPDown"] then
            FeatureSetters["AutoTPDown"](false)
        end
        Features.AutoTPDown = false
    end

    local function onToggle(state)
        autoTPEnabled = state
        Features.AutoTPDown = state
        if state then
            startAutoTP()
        else
            cancelAutoTP()
        end
    end

    local function activate()
        if not autoTPEnabled then 
            -- Si está desactivado, lo activamos temporalmente
            onToggle(true)
        else
            if autoTPActive then
                -- Si ya está activo, no hacemos nada (o podemos reiniciar)
                cancelAutoTP()
                task.wait(0.1)
                startAutoTP()
            else
                startAutoTP()
            end
        end
    end

    -- Crear toggle en el menú
    makeToggle(mainScroll, "Auto TP Loop", "AutoTPDown", function(on)
        onToggle(on)
    end)

    -- Sliders
    makeSlider(mainScroll, "Loop Height", 10, 50, "AutoTPHeight", function(v)
        TARGET_HEIGHT = v
        Values.AutoTPHeight = v
    end)

    makeSlider(mainScroll, "Up Force", 30, 120, "AutoTPForce", function(v)
        UPWARD_FORCE = v
        Values.AutoTPForce = v
        if upwardLV then upwardLV.LineVelocity = UPWARD_FORCE end
    end)

    makeSlider(mainScroll, "Loop Delay", 0.1, 1, "AutoTPDelay", function(v)
        LOOP_DELAY = v
        Values.AutoTPDelay = v
    end)

    -- Valores por defecto
    if Values.AutoTPHeight == nil then Values.AutoTPHeight = 25 end
    if Values.AutoTPForce == nil then Values.AutoTPForce = 65 end
    if Values.AutoTPDelay == nil then Values.AutoTPDelay = 0.3 end
    TARGET_HEIGHT = Values.AutoTPHeight
    UPWARD_FORCE = Values.AutoTPForce
    LOOP_DELAY = Values.AutoTPDelay

    -- Keybind: si está activo, al presionar se apaga; si está apagado, se enciende
    FeatureToggles["AutoTPDown"] = function()
        if Features.AutoTPDown then
            onToggle(false)   -- Apagar
        else
            onToggle(true)    -- Encender
        end
    end

    -- Botón flotante (sin errores)
    if FloatingFeatureSet then FloatingFeatureSet["AutoTPDown"] = true end
    if FloatingLabels then FloatingLabels["AutoTPDown"] = "AUTO TP" end

    if FloatingButtons then
        task.delay(1, function()
            local btn = FloatingButtons["AutoTPDown"]
            if btn and btn.host then
                local hit = btn.host:FindFirstChildOfClass("TextButton")
                if hit then
                    hit.MouseButton1Click:Connect(function()
                        if Features.AutoTPDown then
                            onToggle(false)   -- Apagar si está encendido
                        else
                            onToggle(true)    -- Encender si está apagado
                        end
                    end)
                end
            end
        end)
    end

    Player.CharacterAdded:Connect(function()
        cancelAutoTP()
    end)

    print("[Auto TP Loop] Listo. Activa/desactiva con el toggle o keybind.")
end
-- ==================== AUTO STEAL ====================
do
    local _wait  = (task and task.wait) or wait
    local _spawn = (task and task.spawn) or spawn

    local function try(fn, ...)
        local ok, err = pcall(fn, ...); return ok
    end

    local getconn = nil
    local _gcand  = { "getconnections", "get_signal_connections", "get_signal_cons", "getconnects",
        "getsignalconnections" }
    for _, n in ipairs(_gcand) do
        local ok, fn = pcall(function()
            local env = getfenv and getfenv() or {}
            return env[n]
        end)
        if ok and fn then
            getconn = fn; break
        end
    end
    if not getconn then
        local ok2, env2 = pcall(function() return getfenv and getfenv(0) or {} end)
        if ok2 and env2 then
            for _, n in ipairs(_gcand) do
                if env2[n] then
                    getconn = env2[n]; break
                end
            end
        end
    end

    local _fireProximity = nil
    for _, n in ipairs({ "fireproximityprompt", "fire_proximity_prompt", "FireProximityPrompt" }) do
        local ok, fn = pcall(function()
            local env = getfenv and getfenv() or {}
            return env[n]
        end)
        if ok and fn then
            _fireProximity = fn; break
        end
    end

    local STEAL_METHOD                            = getconn and "getconn" or
        (_fireProximity and "fireproximity" or "native")

    local isStealing                              = false
    local stealStartTime                          = nil
    local autoStealEnabled                        = false
    local autoStealConn                           = nil
    local progressConn                            = nil
    local StealData                               = {}

    local PBC                                     = Instance.new("Frame", sg)
    PBC.Name                                      = "VoidStealBar"
    PBC.Size                                      = UDim2.new(0, 240, 0, 44)
    PBC.Position                                  = UDim2.new(0.5, -120, 1, -120)
    PBC.BackgroundColor3                          = Color3.fromRGB(30, 30, 30)
    PBC.BackgroundTransparency                    = 0.25
    PBC.BorderSizePixel                           = 0; PBC.ClipsDescendants = true; PBC.Visible = false
    Instance.new("UICorner", PBC).CornerRadius    = UDim.new(0, 10)
    local pStr                                    = Instance.new("UIStroke", PBC)
    pStr.Thickness                                = 1.5; pStr.Color = Color3.fromRGB(200, 200, 200)

    local PPL                                     = Instance.new("TextLabel", PBC)
    PPL.AutoLocalize                              = false
    PPL.Size                                      = UDim2.new(0, 36, 0, 16); PPL.Position = UDim2.new(0, 8, 0, 4)
    PPL.BackgroundTransparency                    = 1; PPL.Text = "0%"
    PPL.TextColor3                                = Color3.fromRGB(215, 215, 220)
    PPL.Font                                      = Enum.Font.GothamBold; PPL.TextSize = 8
    PPL.TextXAlignment                            = Enum.TextXAlignment.Left; PPL.ZIndex = 3

    local PNL                                     = Instance.new("TextLabel", PBC)
    PNL.AutoLocalize                              = false
    PNL.Size                                      = UDim2.new(0, 90, 0, 16); PNL.Position = UDim2.new(0, 46, 0, 4)
    PNL.BackgroundTransparency                    = 1; PNL.Text = ""
    PNL.TextColor3                                = Color3.fromRGB(160, 160, 175)
    PNL.Font                                      = Enum.Font.GothamBold; PNL.TextSize = 8
    PNL.TextXAlignment                            = Enum.TextXAlignment.Left; PNL.ZIndex = 3

    -- BotÃ³n âˆ’ radio
    local RMinus                                  = Instance.new("TextButton", PBC)
    RMinus.AutoLocalize                           = false
    RMinus.Size                                   = UDim2.new(0, 16, 0, 16)
    RMinus.Position                               = UDim2.new(1, -72, 0, 4)
    RMinus.BackgroundColor3                       = Color3.fromRGB(45, 45, 45)
    RMinus.BackgroundTransparency                 = 0.2
    RMinus.BorderSizePixel                        = 0
    RMinus.Text                                   = "âˆ’"
    RMinus.Font                                   = Enum.Font.GothamBlack
    RMinus.TextSize                               = 10
    RMinus.TextColor3                             = Color3.fromRGB(200, 200, 200)
    RMinus.ZIndex                                 = 4
    RMinus.AutoButtonColor                        = false
    Instance.new("UICorner", RMinus).CornerRadius = UDim.new(0, 4)
    local rMinusStroke                            = Instance.new("UIStroke", RMinus)
    rMinusStroke.Color                            = Color3.fromRGB(200, 200, 200)
    rMinusStroke.Thickness                        = 1
    rMinusStroke.Transparency                     = 0.4
    rMinusStroke.ApplyStrokeMode                  = Enum.ApplyStrokeMode.Border

    -- Label del valor de radio
    local RI                                      = Instance.new("TextLabel", PBC)
    RI.AutoLocalize                               = false
    RI.Size                                       = UDim2.new(0, 32, 0, 16)
    RI.Position                                   = UDim2.new(1, -54, 0, 4)
    RI.BackgroundTransparency                     = 1
    RI.Text                                       = tostring(Values.StealRadius)
    RI.TextColor3                                 = Color3.fromRGB(200, 200, 200)
    RI.Font                                       = Enum.Font.GothamBlack
    RI.TextSize                                   = 9
    RI.TextXAlignment                             = Enum.TextXAlignment.Center
    RI.TextYAlignment                             = Enum.TextYAlignment.Center
    RI.ZIndex                                     = 3

    -- BotÃ³n + radio
    local RPlus                                   = Instance.new("TextButton", PBC)
    RPlus.AutoLocalize                            = false
    RPlus.Size                                    = UDim2.new(0, 16, 0, 16)
    RPlus.Position                                = UDim2.new(1, -20, 0, 4)
    RPlus.BackgroundColor3                        = Color3.fromRGB(45, 45, 45)
    RPlus.BackgroundTransparency                  = 0.2
    RPlus.BorderSizePixel                         = 0
    RPlus.Text                                    = "+"
    RPlus.Font                                    = Enum.Font.GothamBlack
    RPlus.TextSize                                = 10
    RPlus.TextColor3                              = Color3.fromRGB(200, 200, 200)
    RPlus.ZIndex                                  = 4
    RPlus.AutoButtonColor                         = false
    Instance.new("UICorner", RPlus).CornerRadius  = UDim.new(0, 4)
    local rPlusStroke                             = Instance.new("UIStroke", RPlus)
    rPlusStroke.Color                             = Color3.fromRGB(200, 200, 200)
    rPlusStroke.Thickness                         = 1
    rPlusStroke.Transparency                      = 0.4
    rPlusStroke.ApplyStrokeMode                   = Enum.ApplyStrokeMode.Border

    local function updateRadiusDisplay()
        RI.Text = tostring(Values.StealRadius)
    end

    RMinus.MouseButton1Click:Connect(function()
        Values.StealRadius = math.clamp(Values.StealRadius - 1, 5, 200)
        updateRadiusDisplay()
    end)
    RPlus.MouseButton1Click:Connect(function()
        Values.StealRadius = math.clamp(Values.StealRadius + 1, 5, 200)
        updateRadiusDisplay()
    end)

    -- Soporte tÃ¡ctil para mÃ³vil
    RMinus.InputEnded:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.Touch then return end
        Values.StealRadius = math.clamp(Values.StealRadius - 1, 5, 200)
        updateRadiusDisplay()
    end)
    RPlus.InputEnded:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.Touch then return end
        Values.StealRadius = math.clamp(Values.StealRadius + 1, 5, 200)
        updateRadiusDisplay()
    end)

    local pTrack = Instance.new("Frame", PBC)
    pTrack.Size = UDim2.new(0.88, 0, 0, 10); pTrack.Position = UDim2.new(0.06, 0, 1, -16)
    pTrack.BackgroundColor3 = Color3.fromRGB(22, 22, 28); pTrack.ZIndex = 2
    pTrack.BorderSizePixel = 0; pTrack.BackgroundTransparency = 0.3
    Instance.new("UICorner", pTrack).CornerRadius = UDim.new(0, 5)

    local PBF = Instance.new("Frame", pTrack)
    PBF.Size = UDim2.new(0, 0, 1, 0); PBF.BackgroundColor3 = Color3.fromRGB(160, 160, 175)
    PBF.ZIndex = 2; PBF.BorderSizePixel = 0; PBF.BackgroundTransparency = 0.5
    Instance.new("UICorner", PBF).CornerRadius = UDim.new(0, 5)

    local function ResetBar()
        local rd = Values.BarResetDelay or 0
        if rd > 0 then
            task.delay(rd, function()
                for k, v in pairs({ Size = UDim2.new(0, 0, 1, 0) }) do PBF[k] = v end
                task.wait(0.15)
                PNL.Text = autoStealEnabled and "Zurich Hub" or ""
                PPL.Text = "0%"; PBC.Visible = autoStealEnabled
            end)
        else
            PNL.Text = autoStealEnabled and "Zurich Hub" or ""
            PPL.Text = "0%"; PBF.Size = UDim2.new(0, 0, 1, 0); PBC.Visible = autoStealEnabled
        end
    end

    local function isMyPlot(pn)
        local plots = workspace:FindFirstChild("Plots"); if not plots then return false end
        local plot = plots:FindFirstChild(pn); if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
        end
        return false
    end

    local function findNearest()
        local c = Player.Character; if not c then return nil end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return nil end
        local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
        local np, nd, nn = nil, math.huge, nil
        for _, plot in ipairs(plots:GetChildren()) do
            if isMyPlot(plot.Name) then continue end
            local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then continue end
            for _, pod in ipairs(podiums:GetChildren()) do
                try(function()
                    local base  = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local dist = (spawn.Position - root.Position).Magnitude
                        if dist < nd and dist <= Values.StealRadius then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then
                                for _, ch in ipairs(att:GetChildren()) do
                                    if ch:IsA("ProximityPrompt") then
                                        np, nd, nn = ch, dist, pod.Name; break
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
        return np, nd, nn
    end

    local function executeSteal(prompt, name)
        if isStealing then return end
        if STEAL_METHOD == "getconn" and not StealData[prompt] then
            StealData[prompt] = { hold = {}, trigger = {}, ready = true }
            try(function()
                for _, c in ipairs(getconn(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(StealData[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconn(prompt.Triggered)) do
                    if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
                end
            end)
        end
        if STEAL_METHOD == "getconn" then
            local data = StealData[prompt]
            if not data or not data.ready then return end
            data.ready = false
        end

        isStealing = true; stealStartTime = tick()
        PBC.Visible = true; PNL.Text = name or "STEALING..."

        if progressConn then
            progressConn:Disconnect(); progressConn = nil
        end
        progressConn = RunService.Heartbeat:Connect(function()
            if not isStealing then
                if progressConn then
                    progressConn:Disconnect(); progressConn = nil
                end; return
            end
            local prog = math.clamp((tick() - stealStartTime) / math.max(Values.StealDuration / 10, 0.01), 0, 1)
            PBF.Size = UDim2.new(prog, 0, 1, 0); PPL.Text = math.floor(prog * 100) .. "%"
        end)
        _spawn(function()
            local function finishAndReset(onDone)
                if progressConn then
                    progressConn:Disconnect(); progressConn = nil
                end
                PBF.Size = UDim2.new(1, 0, 1, 0); PPL.Text = "100%"
                local rd = Values.BarResetDelay or 0
                if rd > 0 then _wait(rd) end
                PNL.Text = autoStealEnabled and "Zurich Hub" or ""
                PPL.Text = "0%"
                for k, v in pairs({ Size = UDim2.new(0, 0, 1, 0) }) do PBF[k] = v end
                task.wait(0.15); PBC.Visible = autoStealEnabled
                if onDone then onDone() end
            end

            if STEAL_METHOD == "getconn" then
                local data = StealData[prompt]
                for _, f in ipairs(data.hold) do _spawn(f) end
                _wait(Values.StealDuration / 10)
                for _, f in ipairs(data.trigger) do _spawn(f) end
                finishAndReset(function()
                    data.ready = true; isStealing = false
                end)
            elseif STEAL_METHOD == "fireproximity" then
                try(function() _fireProximity(prompt) end)
                _wait(Values.StealDuration / 10)
                finishAndReset(function() isStealing = false end)
            else
                try(function()
                    local origMaxDist            = prompt.MaxActivationDistance
                    local origHoldTime           = prompt.HoldDuration
                    local origEnabled            = prompt.Enabled
                    prompt.MaxActivationDistance = 999; prompt.HoldDuration = 0; prompt.Enabled = true
                    local PPS                    = pcall(function()
                        local svc = game:GetService("ProximityPromptService")
                        if svc then
                            local trigger = svc.TriggerPrompt; if trigger then trigger(svc, prompt) end
                        end
                    end)
                    if not PPS then
                        try(function()
                            prompt:InputHoldBegin(); _wait(Values.StealDuration / 10); prompt:InputHoldEnd()
                        end)
                    end
                    _wait(0.1)
                    try(function()
                        prompt.MaxActivationDistance = origMaxDist
                        prompt.HoldDuration = origHoldTime; prompt.Enabled = origEnabled
                    end)
                end)
                _wait(Values.StealDuration / 10)
                finishAndReset(function() isStealing = false end)
            end
        end)
    end

    local _lastStealAttempt = 0
    local STEAL_FAIL_CD     = 0.2

    local function startAS()
        if autoStealConn then return end
        autoStealConn = RunService.Heartbeat:Connect(function()
            if not autoStealEnabled or isStealing then return end
            local now = tick()
            if now - _lastStealAttempt < STEAL_FAIL_CD then return end
            local p, _, n = findNearest()
            if p then
                _lastStealAttempt = now; executeSteal(p, n)
            end
        end)
    end

    local function stopAS()
        if autoStealConn then
            autoStealConn:Disconnect(); autoStealConn = nil
        end
        isStealing = false
        if progressConn then
            progressConn:Disconnect(); progressConn = nil
        end
        ResetBar()
    end

    makeToggle(mainScroll, "Insta Grab", "AutoSteal", function(on)
        autoStealEnabled = on
        if on then
            startAS(); PBC.Visible = true; PNL.Text = "Zurich Hub"; PPL.Text = "0%"; PBF.Size = UDim2.new(0, 0, 1, 0)
        else
            stopAS(); PBC.Visible = false
        end
    end, true)

    -- Activar Insta Grab y mostrar barra automÃ¡ticamente al cargar
    task.defer(function()
        task.wait(0.5)
        autoStealEnabled = true
        Features["AutoSteal"] = true
        if FeatureSetters["AutoSteal"] then FeatureSetters["AutoSteal"](true) end
        startAS()
        PBC.Visible = true
        PNL.Text = "Zurich Hub"
        PPL.Text = "0%"
        PBF.Size = UDim2.new(0, 0, 1, 0)
    end)

    makeSlider(mainScroll, "Steal Duration", 0.1, 10, "StealDuration", function(v) Values.StealDuration = v end)
end

-- ==================== SHOW FPS (sin BIND) ====================
local fpsOverlay                                  = Instance.new("Frame", sg)
fpsOverlay.Name                                   = "FpsOverlay"
fpsOverlay.Size                                   = UDim2.new(0, 208, 0, 64)
fpsOverlay.AnchorPoint                            = Vector2.new(0.5, 0)
fpsOverlay.Position                               = UDim2.new(0.5, 0, 0, 96)
fpsOverlay.BackgroundColor3                       = Color3.fromRGB(18, 6, 6)
fpsOverlay.BackgroundTransparency                 = 0.08
fpsOverlay.BorderSizePixel                        = 0
fpsOverlay.ClipsDescendants                       = true
fpsOverlay.Visible                                = false
fpsOverlay.ZIndex                                 = 150
Instance.new("UICorner", fpsOverlay).CornerRadius = UDim.new(0, 12)

local fpsOverlayStroke                            = Instance.new("UIStroke", fpsOverlay)
fpsOverlayStroke.Color                            = Color3.fromRGB(230, 230, 238)
fpsOverlayStroke.Thickness                        = 1.3
fpsOverlayStroke.Transparency                     = 0.1
fpsOverlayStroke.ApplyStrokeMode                  = Enum.ApplyStrokeMode.Border

local fpsGrad                                     = Instance.new("UIGradient", fpsOverlay)
fpsGrad.Color                                     = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 26, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 12)),
})
fpsGrad.Rotation                                  = 90

local fpsDivider                                  = Instance.new("Frame", fpsOverlay)
fpsDivider.Size                                   = UDim2.new(1, -20, 0, 1)
fpsDivider.Position                               = UDim2.new(0, 10, 0, 24)
fpsDivider.BackgroundColor3                       = Color3.fromRGB(92, 92, 102)
fpsDivider.BackgroundTransparency                 = 0.2
fpsDivider.BorderSizePixel                        = 0
fpsDivider.ZIndex                                 = 152

local fpsLabel                                    = Instance.new("TextLabel", fpsOverlay)
fpsLabel.AutoLocalize                             = false
fpsLabel.Size                                     = UDim2.new(0.5, 0, 0, 14)
fpsLabel.Position                                 = UDim2.new(0, 0, 0, 6)
fpsLabel.BackgroundTransparency                   = 1
fpsLabel.Text                                     = "FPS"
fpsLabel.Font                                     = Enum.Font.GothamBold
fpsLabel.TextSize                                 = 10
fpsLabel.TextColor3                               = Color3.fromRGB(205, 205, 214)
fpsLabel.TextXAlignment                           = Enum.TextXAlignment.Center
fpsLabel.TextYAlignment                           = Enum.TextYAlignment.Center
fpsLabel.ZIndex                                   = 154

local fpsValue                                    = Instance.new("TextLabel", fpsOverlay)
fpsValue.AutoLocalize                             = false
fpsValue.Size                                     = UDim2.new(0.5, 0, 0, 30)
fpsValue.Position                                 = UDim2.new(0, 0, 0, 26)
fpsValue.BackgroundTransparency                   = 1
fpsValue.Text                                     = "0"
fpsValue.Font                                     = Enum.Font.GothamBlack
fpsValue.TextSize                                 = 21
fpsValue.TextColor3                               = Color3.fromRGB(255, 240, 240)
fpsValue.TextXAlignment                           = Enum.TextXAlignment.Center
fpsValue.TextYAlignment                           = Enum.TextYAlignment.Center
fpsValue.ZIndex                                   = 154

local pingLabel                                   = Instance.new("TextLabel", fpsOverlay)
pingLabel.AutoLocalize                            = false
pingLabel.Size                                    = UDim2.new(0.5, 0, 0, 14)
pingLabel.Position                                = UDim2.new(0.5, 0, 0, 6)
pingLabel.BackgroundTransparency                  = 1
pingLabel.Text                                    = "PING"
pingLabel.Font                                    = Enum.Font.GothamBold
pingLabel.TextSize                                = 10
pingLabel.TextColor3                              = Color3.fromRGB(205, 205, 214)
pingLabel.TextXAlignment                          = Enum.TextXAlignment.Center
pingLabel.TextYAlignment                          = Enum.TextYAlignment.Center
pingLabel.ZIndex                                  = 154

local pingValue                                   = Instance.new("TextLabel", fpsOverlay)
pingValue.AutoLocalize                            = false
pingValue.Size                                    = UDim2.new(0.5, 0, 0, 30)
pingValue.Position                                = UDim2.new(0.5, 0, 0, 26)
pingValue.BackgroundTransparency                  = 1
pingValue.Text                                    = "0"
pingValue.Font                                    = Enum.Font.GothamBlack
pingValue.TextSize                                = 21
pingValue.TextColor3                              = Color3.fromRGB(255, 240, 240)
pingValue.TextXAlignment                          = Enum.TextXAlignment.Center
pingValue.TextYAlignment                          = Enum.TextYAlignment.Center
pingValue.ZIndex                                  = 154

do
    local fpsConn = nil
    local pingConn = nil
    local elapsed = 0
    local frameCount = 0

    local function getPing()
        local ok, ping = pcall(function() return Players.LocalPlayer:GetNetworkPing() * 1000 end)
        return ok and math.floor(ping) or 0
    end

    local function startFpsLoop()
        if fpsConn then return end
        elapsed = 0; frameCount = 0
        fpsConn = RunService.RenderStepped:Connect(function(dt)
            frameCount += 1; elapsed += dt
            if elapsed >= 1 then
                local fps = math.floor(frameCount / elapsed)
                frameCount = 0; elapsed = 0
                fpsValue.Text = tostring(fps)
            end
        end)
        local _pingElapsed = 0
        pingConn = RunService.Heartbeat:Connect(function(dt)
            _pingElapsed = _pingElapsed + dt
            if _pingElapsed < 1 then return end
            _pingElapsed = 0
            pingValue.Text = tostring(getPing())
        end)
    end

    local function stopFpsLoop()
        if fpsConn then
            fpsConn:Disconnect(); fpsConn = nil
        end
        if pingConn then
            pingConn:Disconnect(); pingConn = nil
        end
        fpsValue.Text  = "0"
        pingValue.Text = "0"
    end

    makeToggle(mainScroll, "Show FPS", "ShowFPS", function(on)
        fpsOverlay.Visible = on
        if on then startFpsLoop() else stopFpsLoop() end
    end, true)
end

-- ==================== ESP PLAYERS ====================
do
    local espEnabled = false
    local espActivePlayers = {}

    -- TamaÃ±o del cubo 3D
    local BOX_W = 4
    local BOX_H = 5.5
    local BOX_D = 4

    -- Colores del hub en escala de grises
    local HUB_COLORS = {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(140, 140, 140),
        Color3.fromRGB(180, 180, 180)
    }

    local function getPlayerColor(plr)
        local hash = 0
        for i = 1, #plr.Name do
            hash = hash + string.byte(plr.Name, i)
        end
        return HUB_COLORS[(hash % #HUB_COLORS) + 1]
    end

    local function createESPBox(plr)
        local folder = Instance.new("Folder")
        folder.Name = "_ESP3DBox_" .. plr.Name

        local parentGui
        local _cgOk, _cgResult = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
        if _cgOk and _cgResult then
            parentGui = _cgResult
        else
            parentGui = Player:FindFirstChildOfClass("PlayerGui")
        end
        if not parentGui then parentGui = Player:FindFirstChildOfClass("PlayerGui") or sg end
        folder.Parent = parentGui

        local boxFace = Instance.new("BoxHandleAdornment")
        boxFace.Name = "ESP_Face"
        boxFace.Adornee = workspace.Terrain
        boxFace.AlwaysOnTop = true
        boxFace.ZIndex = 4
        boxFace.Size = Vector3.new(BOX_W, BOX_H, BOX_D)
        boxFace.Color3 = Color3.fromRGB(120, 120, 120) -- Gris translucido
        boxFace.Transparency = 0.65
        boxFace.Parent = folder

        local lineOffsets = {
            { Vector3.new(-BOX_W / 2, -BOX_H / 2, -BOX_D / 2), Vector3.new(BOX_W / 2, -BOX_H / 2, -BOX_D / 2) },
            { Vector3.new(BOX_W / 2, -BOX_H / 2, -BOX_D / 2),  Vector3.new(BOX_W / 2, -BOX_H / 2, BOX_D / 2) },
            { Vector3.new(BOX_W / 2, -BOX_H / 2, BOX_D / 2),   Vector3.new(-BOX_W / 2, -BOX_H / 2, BOX_D / 2) },
            { Vector3.new(-BOX_W / 2, -BOX_H / 2, BOX_D / 2),  Vector3.new(-BOX_W / 2, -BOX_H / 2, -BOX_D / 2) },
            { Vector3.new(-BOX_W / 2, BOX_H / 2, -BOX_D / 2),  Vector3.new(BOX_W / 2, BOX_H / 2, -BOX_D / 2) },
            { Vector3.new(BOX_W / 2, BOX_H / 2, -BOX_D / 2),   Vector3.new(BOX_W / 2, BOX_H / 2, BOX_D / 2) },
            { Vector3.new(BOX_W / 2, BOX_H / 2, BOX_D / 2),    Vector3.new(-BOX_W / 2, BOX_H / 2, BOX_D / 2) },
            { Vector3.new(-BOX_W / 2, BOX_H / 2, BOX_D / 2),   Vector3.new(-BOX_W / 2, BOX_H / 2, -BOX_D / 2) },
            { Vector3.new(-BOX_W / 2, -BOX_H / 2, -BOX_D / 2), Vector3.new(-BOX_W / 2, BOX_H / 2, -BOX_D / 2) },
            { Vector3.new(BOX_W / 2, -BOX_H / 2, -BOX_D / 2),  Vector3.new(BOX_W / 2, BOX_H / 2, -BOX_D / 2) },
            { Vector3.new(BOX_W / 2, -BOX_H / 2, BOX_D / 2),   Vector3.new(BOX_W / 2, BOX_H / 2, BOX_D / 2) },
            { Vector3.new(-BOX_W / 2, -BOX_H / 2, BOX_D / 2),  Vector3.new(-BOX_W / 2, BOX_H / 2, BOX_D / 2) }
        }

        local lines = {}
        for i, offsets in ipairs(lineOffsets) do
            local line = Instance.new("LineHandleAdornment")
            line.Name = "ESP_Line_" .. i
            line.Adornee = workspace.Terrain
            line.AlwaysOnTop = true
            line.ZIndex = 5
            line.Color3 = Color3.fromRGB(255, 255, 255) -- Contorno blanco
            line.Thickness = 2
            line.Parent = folder
            table.insert(lines, { line = line, offset0 = offsets[1], offset1 = offsets[2] })
        end

        return folder, boxFace, lines
    end

    local function removeESP(plr)
        local data = espActivePlayers[plr]
        if data then
            if data.folder and data.folder.Parent then
                pcall(function() data.folder:Destroy() end)
            end
            if data.charConn then
                pcall(function() data.charConn:Disconnect() end)
            end
            if data.loopConn then
                pcall(function() data.loopConn:Disconnect() end)
            end
            espActivePlayers[plr] = nil
        end
    end

    local function createESPForPlayer(plr)
        if plr == Player then return end

        removeESP(plr)

        local character = plr.Character
        if not character then return end

        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local folder, boxFace, lines = createESPBox(plr)

        local loopConn = RunService.Heartbeat:Connect(function()
            if hrp and hrp.Parent and boxFace and boxFace.Parent then
                local center = hrp.Position
                boxFace.CFrame = CFrame.new(center)
                for _, lData in ipairs(lines) do
                    local p0 = center + lData.offset0
                    local p1 = center + lData.offset1
                    lData.line.CFrame = CFrame.new(p0, p1)
                    lData.line.Length = (p1 - p0).Magnitude
                end
            end
        end)

        local charConn = plr.CharacterAdded:Connect(function()
            task.wait(0.3)
            if espEnabled then
                createESPForPlayer(plr)
            end
        end)

        espActivePlayers[plr] = {
            folder = folder,
            loopConn = loopConn,
            charConn = charConn
        }
    end

    local function enableESP()
        if espEnabled then return end
        espEnabled = true

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player then
                task.spawn(function() createESPForPlayer(plr) end)
            end
        end

        local joinConn = Players.PlayerAdded:Connect(function(plr)
            if not espEnabled or plr == Player then return end
            task.wait(0.3)
            createESPForPlayer(plr)
        end)

        local leaveConn = Players.PlayerRemoving:Connect(function(plr)
            removeESP(plr)
        end)

        espActivePlayers._joinConn = joinConn
        espActivePlayers._leaveConn = leaveConn
    end

    local function disableESP()
        espEnabled = false

        if espActivePlayers._joinConn then
            pcall(function() espActivePlayers._joinConn:Disconnect() end)
            espActivePlayers._joinConn = nil
        end
        if espActivePlayers._leaveConn then
            pcall(function() espActivePlayers._leaveConn:Disconnect() end)
            espActivePlayers._leaveConn = nil
        end

        for plr in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= Player then
                removeESP(plr)
            end
        end
    end

    makeToggle(mainScroll, "ESP Players", "ESPPlayers", function(on)
        if on then enableESP() else disableESP() end
    end, true)

    Player.CharacterAdded:Connect(function()
        task.wait(0.8)
        if not espEnabled then return end
        for plr in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= Player then
                if not (espActivePlayers[plr] and espActivePlayers[plr].folder and espActivePlayers[plr].folder.Parent) then
                    task.spawn(function() createESPForPlayer(plr) end)
                end
            end
        end
    end)
end
-- ==================== FIN ESP PLAYERS ====================
-- ==================== INFINITE JUMP (RESPETA BLOQUEO GLOBAL) ====================
do
    local infJumpEnabled = false
    local infJumpConn = nil
    local lastJumpTime = 0
    local HOP_POWER = 45
    local HOP_COOLDOWN = 0.08
    
    -- Verificar si el salto está bloqueado por TP Down
    local function isJumpBlocked()
        return _G["_ZurichHub_JumpBlocked"] == true
    end
    
    -- Detectar entrada de teclado (salto)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if isJumpBlocked() then
            if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
                return
            end
        end
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
            if not isJumpBlocked() then
                lastJumpTime = tick() - HOP_COOLDOWN
            end
        end
    end)
    
    -- Función principal del Infinite Jump
    local function startInfJump()
        if infJumpConn then
            infJumpConn:Disconnect()
            infJumpConn = nil
        end
        
        infJumpConn = RunService.Heartbeat:Connect(function()
            if not infJumpEnabled then return end
            
            -- 🔥 SI EL SALTO ESTÁ BLOQUEADO, NO HACER NADA
            if isJumpBlocked() then
                return
            end
            
            pcall(function()
                local char = Player.Character
                if not char then return end
                
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local now = tick()
                
                local wantsToJump = UserInputService:IsKeyDown(Enum.KeyCode.Space) or
                                   UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) or
                                   hum.Jump == true
                
                if wantsToJump and (now - lastJumpTime) >= HOP_COOLDOWN then
                    lastJumpTime = now
                    
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        HOP_POWER,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end)
        end)
    end
    
    local function stopInfJump()
        if infJumpConn then
            infJumpConn:Disconnect()
            infJumpConn = nil
        end
    end
    
    -- Crear toggle en el menú
    makeToggle(mainScroll, "Infinite Jump", "GalaxyMode", function(on)
        infJumpEnabled = on
        if on then
            startInfJump()
        else
            stopInfJump()
        end
    end)
    
    -- Recuperar después de morir
    Player.CharacterAdded:Connect(function()
        if infJumpEnabled then
            task.wait(0.5)
            stopInfJump()
            startInfJump()
        end
    end)
end
-- ==================== FIN INFINITE JUMP ====================
-- ==================== TAUNT ====================
do
    local tauntConn = nil

    local function startTaunt()
        if tauntConn then return end
        tauntConn = task.spawn(function()
            while Features.Taunt do
                pcall(function()
                    local channel = game:GetService("TextChatService").TextChannels:FindFirstChild("RBXGeneral")
                    if channel then
                        channel:SendAsync("/Zurich")
                    end
                end)
                task.wait(0.2)
            end
            tauntConn = nil
        end)
    end

    local function stopTaunt()
        Features.Taunt = false
        tauntConn = nil
    end

    Features["Taunt"] = false
    makeToggle(mainScroll, "Taunt", "Taunt", function(on)
        if on then startTaunt() else stopTaunt() end
    end, true)
end
-- ==================== FIN TAUNT ====================

-- ==================== SEPARADOR BOOSTER ====================
do
    local sepFrame, _               = makeRowFrame(mainScroll, 22)
    sepFrame.BackgroundTransparency = 1
    local sepLine                   = Instance.new("Frame", sepFrame)
    sepLine.Size                    = UDim2.new(0.85, 0, 0, 1)
    sepLine.Position                = UDim2.new(0.075, 0, 0.5, 0)
    sepLine.BackgroundColor3        = Color3.fromRGB(200, 200, 200)
    sepLine.BackgroundTransparency  = 0.4
    sepLine.BorderSizePixel         = 0
    sepLine.ZIndex                  = 4
    local sepLbl                    = Instance.new("TextLabel", sepFrame)
    sepLbl.AutoLocalize             = false
    sepLbl.Size                     = UDim2.new(1, 0, 1, 0)
    sepLbl.BackgroundTransparency   = 1
    sepLbl.Text                     = "â€” BOOSTER â€”"
    sepLbl.Font                     = Enum.Font.GothamBold
    sepLbl.TextSize                 = 10
    sepLbl.TextColor3               = Color3.fromRGB(200, 200, 200)
    sepLbl.TextXAlignment           = Enum.TextXAlignment.Center
    sepLbl.ZIndex                   = 5
end

-- ==================== BOOSTER PANEL ====================
do
    -- local hlAntiLagEnabled          = _boosterStates["AntiLag"] == true
    local hlNightEnabled            = _boosterStates["NightMode"] == true
    local hlXrayEnabled             = _boosterStates["XrayBase"] == true

    local defBrightness             = Lighting.Brightness
    local defClock                  = Lighting.ClockTime
    local defAmbient                = Lighting.OutdoorAmbient

    -- local _antiLagOriginals         = {}
    -- local _antiLagLightingOriginals = {}
    -- local _antiLagDescAddedConn     = nil

    -- local function activateAntiLag()
    --     ...
    -- end

    -- local function deactivateAntiLag()
    --     ...
    -- end

    local function activateNightMode()
        hlNightEnabled = true
        _boosterStates["NightMode"] = true
        local sky = Lighting:FindFirstChild("GalaxySky") or Instance.new("Sky")
        sky.Name = "GalaxySky"
        sky.SkyboxBk = "rbxassetid://159454299"
        sky.SkyboxDn = "rbxassetid://159454296"
        sky.SkyboxFt = "rbxassetid://159454293"
        sky.SkyboxLf = "rbxassetid://159454286"
        sky.SkyboxRt = "rbxassetid://159454289"
        sky.SkyboxUp = "rbxassetid://159454291"
        sky.Parent = Lighting
        Lighting.Brightness = 0
        Lighting.ClockTime = 0
        Lighting.ExposureCompensation = -2
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    end

    local function deactivateNightMode()
        hlNightEnabled = false
        _boosterStates["NightMode"] = false
        local sky = Lighting:FindFirstChild("GalaxySky")
        if sky then sky:Destroy() end
        Lighting.Brightness = defBrightness
        Lighting.ClockTime = defClock
        Lighting.ExposureCompensation = 0
        Lighting.OutdoorAmbient = defAmbient
    end

    local xrayOg = {}
    local xrayConns = {}

    local function activateXray()
        hlXrayEnabled = true
        _boosterStates["XrayBase"] = true
        for _, c in pairs(xrayConns) do if c then c:Disconnect() end end
        xrayConns = {}; xrayOg = {}
        local function isBase(o)
            if not (o:IsA("BasePart") or o:IsA("MeshPart") or o:IsA("UnionOperation")) then return false end
            local n = o.Name:lower()
            local p = o.Parent and o.Parent.Name:lower() or ""
            return string.find(n, "base") or string.find(n, "claim") or string.find(p, "base") or string.find(p, "claim")
        end
        for _, o in pairs(workspace:GetDescendants()) do
            if isBase(o) then
                xrayOg[o] = o.LocalTransparencyModifier
                o.LocalTransparencyModifier = 0.8
            end
        end
        table.insert(xrayConns, workspace.DescendantAdded:Connect(function(o)
            if isBase(o) then
                xrayOg[o] = o.LocalTransparencyModifier
                o.LocalTransparencyModifier = 0.8
            end
        end))
        table.insert(xrayConns, Player.CharacterAdded:Connect(function()
            task.wait(0.5)
            for _, o in pairs(workspace:GetDescendants()) do
                if isBase(o) then
                    if not xrayOg[o] then xrayOg[o] = o.LocalTransparencyModifier end
                    o.LocalTransparencyModifier = 0.8
                end
            end
        end))
    end

    local function deactivateXray()
        hlXrayEnabled = false
        _boosterStates["XrayBase"] = false
        for o, t in pairs(xrayOg) do
            if o and o.Parent then pcall(function() o.LocalTransparencyModifier = t end) end
        end
        for _, c in pairs(xrayConns) do if c then c:Disconnect() end end
        xrayConns = {}; xrayOg = {}
    end

    -- _boosterActivators["AntiLag"]     = activateAntiLag
    _boosterActivators["NightMode"]   = activateNightMode
    _boosterActivators["XrayBase"]    = activateXray
    -- _boosterDeactivators["AntiLag"]   = deactivateAntiLag
    _boosterDeactivators["NightMode"] = deactivateNightMode
    _boosterDeactivators["XrayBase"]  = deactivateXray

    local function makeBoosterRow(labelText, boosterKey, onActivate, onDeactivate)
        local frame, _ = makeRowFrame(mainScroll, ROW_H)
        local isOn = _boosterStates[boosterKey] == true

        local lbl = Instance.new("TextLabel", frame)
        lbl.AutoLocalize = false
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = _C_TEXT2
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 4

        local pillW = 36
        local pillH = 20
        local circleD = pillH - 4

        local pill = Instance.new("Frame", frame)
        pill.Size = UDim2.new(0, pillW, 0, pillH)
        pill.Position = UDim2.new(1, -(pillW + 10), 0.5, -pillH / 2)
        pill.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        pill.BorderSizePixel = 0
        pill.ZIndex = 4
        pill.BackgroundTransparency = 0.4
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Color = Color3.fromRGB(48, 48, 58)
        pillStroke.Thickness = 1
        pillStroke.Transparency = 0

        local circle = Instance.new("Frame", pill)
        circle.Size = UDim2.new(0, circleD, 0, circleD)
        circle.Position = UDim2.new(0, 2, 0.5, -circleD / 2)
        circle.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
        circle.BorderSizePixel = 0
        circle.ZIndex = 5
        Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

        local function updateVisual()
            if isOn then
                pill.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
                pillStroke.Color = Color3.fromRGB(180, 180, 200)
                circle.Position = UDim2.new(1, -(circleD + 2), 0.5, -circleD / 2)
                circle.BackgroundColor3 = Color3.fromRGB(230, 230, 235)
            else
                pill.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
                pillStroke.Color = Color3.fromRGB(48, 48, 58)
                circle.Position = UDim2.new(0, 2, 0.5, -circleD / 2)
                circle.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
            end
        end

        local hitbox = Instance.new("TextButton", frame)
        hitbox.AutoLocalize = false
        hitbox.Size = UDim2.new(1, 0, 1, 0)
        hitbox.BackgroundTransparency = 1
        hitbox.Text = ""
        hitbox.ZIndex = 6

        local _tapStart = nil
        local _tapMoved = false
        local _tapScrollY = nil
        local TAP_THRESH = isMobile and 20 or 6

        local function doToggle()
            isOn = not isOn
            _boosterStates[boosterKey] = isOn
            updateVisual()
            showFeatureNotif(labelText, isOn)
            if isOn then onActivate() else onDeactivate() end
        end

        if not isMobile then
            hitbox.MouseButton1Click:Connect(doToggle)
        else
            hitbox.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Touch then return end
                _tapStart = inp.Position
                _tapMoved = false
                _tapScrollY = mainScroll.CanvasPosition.Y
            end)
            hitbox.InputChanged:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Touch then return end
                if not _tapStart or _tapMoved then return end
                if math.abs(inp.Position.X - _tapStart.X) > TAP_THRESH or math.abs(inp.Position.Y - _tapStart.Y) > TAP_THRESH then
                    _tapMoved = true
                end
            end)
            hitbox.InputEnded:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Touch then return end
                if _tapStart and not _tapMoved then
                    if math.abs(mainScroll.CanvasPosition.Y - (_tapScrollY or 0)) <= 5 then
                        doToggle()
                    end
                end
                _tapStart = nil
                _tapMoved = false
                _tapScrollY = nil
            end)
        end

        hitbox.MouseEnter:Connect(function()
            frame.BackgroundColor3 = _C_ROW2
            frame.BackgroundTransparency = 0.2
        end)
        hitbox.MouseLeave:Connect(function()
            frame.BackgroundColor3 = _C_ROW
            frame.BackgroundTransparency = 0.35
        end)

        updateVisual()

        if isOn then
            task.defer(onActivate)
        end

        return frame
    end

    -- makeBoosterRow("Anti Lag", "AntiLag", activateAntiLag, deactivateAntiLag)
    makeBoosterRow("Night Mode", "NightMode", activateNightMode, deactivateNightMode)
    makeBoosterRow("X-Ray Base", "XrayBase", activateXray, deactivateXray)
end
-- ==================== FIN BOOSTER PANEL ====================
-- ==================== OPTIMIZER (NUEVA LÓGICA) ====================
do
    -- ============================================================
    -- ESTADO
    -- ============================================================
    local optimizerEnabled = false
    local originalTransparency = {}
    local xrayEnabled = false
    local optimizerConn = nil

    -- ============================================================
    -- FUNCIONES DEL OPTIMIZER
    -- ============================================================

    local function enableOptimizer()
        if optimizerEnabled then return end
        optimizerEnabled = true
        
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            Lighting.Brightness = 3
            Lighting.FogEnd = 9000000000
        end)
        
        -- Aplicar cambios a TODO el workspace (con un pequeño delay para asegurar)
        task.spawn(function()
            -- Pequeña espera para asegurar que el workspace está listo
            task.wait(0.1)
            
            local count = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                        obj:Destroy()
                        count = count + 1
                    elseif obj:IsA("BasePart") then
                        obj.CastShadow = false
                        if obj.Material ~= Enum.Material.Neon and obj.Material ~= Enum.Material.ForceField then
                            obj.Material = Enum.Material.Plastic
                        end
                    end
                end)
            end
        end)
        
        xrayEnabled = true
        task.spawn(function()
            task.wait(0.15)
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Anchored and 
                   (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                    if not originalTransparency[obj] then
                        originalTransparency[obj] = obj.LocalTransparencyModifier
                    end
                    obj.LocalTransparencyModifier = 0.85
                end
            end
        end)
        
        -- Vigilar nuevos objetos que se añadan
        if optimizerConn then optimizerConn:Disconnect() end
        optimizerConn = workspace.DescendantAdded:Connect(function(obj)
            if not optimizerEnabled then return end
            task.defer(function()
                pcall(function()
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                        obj:Destroy()
                    elseif obj:IsA("BasePart") then
                        obj.CastShadow = false
                        if obj.Material ~= Enum.Material.Neon and obj.Material ~= Enum.Material.ForceField then
                            obj.Material = Enum.Material.Plastic
                        end
                        if xrayEnabled and obj.Anchored and 
                           (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                            if not originalTransparency[obj] then
                                originalTransparency[obj] = obj.LocalTransparencyModifier
                            end
                            obj.LocalTransparencyModifier = 0.85
                        end
                    end
                end)
            end)
        end)
        
        showFeatureNotif("Optimizer ON", true)
    end

    local function disableOptimizer()
        if not optimizerEnabled then return end
        optimizerEnabled = false
        
        if xrayEnabled then
            for part, originalValue in pairs(originalTransparency) do
                pcall(function()
                    if part and part.Parent then
                        part.LocalTransparencyModifier = originalValue
                    end
                end)
            end
            originalTransparency = {}
            xrayEnabled = false
        end
        
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            Lighting.GlobalShadows = true
            Lighting.Brightness = 2
            Lighting.FogEnd = 100000
        end)
        
        -- Nota: NO restauramos los materiales ni sombras porque eso sería muy pesado
        -- Simplemente dejamos de aplicar los cambios a objetos nuevos
        
        if optimizerConn then
            optimizerConn:Disconnect()
            optimizerConn = nil
        end
        
        showFeatureNotif("Optimizer OFF", false)
    end

    local function toggleOptimizer()
        if optimizerEnabled then
            disableOptimizer()
        else
            enableOptimizer()
        end
    end

    -- ============================================================
    -- REGISTRAR EN EL SISTEMA DEL HUB
    -- ============================================================
    
    -- Asegurar que el feature existe
    if Features["Optimizer"] == nil then
        Features["Optimizer"] = false
    end
    
    -- Eliminar el viejo AntiLag si existe
    local oldRowsToRemove = {}
    for _, child in ipairs(mainScroll:GetChildren()) do
        if child:IsA("Frame") then
            for _, lbl in ipairs(child:GetDescendants()) do
                if lbl:IsA("TextLabel") and (lbl.Text == "Anti Lag" or lbl.Text == "Optimizer") then
                    table.insert(oldRowsToRemove, child)
                    break
                end
            end
        end
    end
    for _, row in ipairs(oldRowsToRemove) do
        pcall(function() row:Destroy() end)
    end
    
    -- Crear el nuevo toggle
    local _, setOptimizer, _, _, _ = makeToggle(mainScroll, "Optimizer", "Optimizer", function(on)
        if on then
            enableOptimizer()
        else
            disableOptimizer()
        end
    end, false)
    
    -- Registrar en FeatureToggles para keybind
    FeatureToggles["Optimizer"] = function()
        local newState = not Features["Optimizer"]
        Features["Optimizer"] = newState
        if newState then
            enableOptimizer()
        else
            disableOptimizer()
        end
        if setOptimizer then setOptimizer(newState) end
    end
    
    -- INICIALIZACIÓN CON RETRASO PARA ASEGURAR QUE SE APLIQUE
    if Features["Optimizer"] then
        -- Pequeño retraso para que el workspace esté completamente cargado
        task.spawn(function()
            task.wait(0.5)
            enableOptimizer()
            if setOptimizer then setOptimizer(true) end
        end)
    end
    
    -- También escuchar cuando el personaje respawnea para reaplicar X-ray
    Player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if optimizerEnabled and xrayEnabled then
            task.spawn(function()
                task.wait(0.3)
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Anchored and 
                       (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                        if not originalTransparency[obj] then
                            originalTransparency[obj] = obj.LocalTransparencyModifier
                        end
                        obj.LocalTransparencyModifier = 0.85
                    end
                end
            end)
        end
    end)
end
-- ==================== FIN OPTIMIZER ====================
-- ==================== STRETCH REZ TOGGLE ====================
do
    local stretchEnabled = false
    local defaultFOV = 70
    local stretchFOV = 120
    local cameraConnections = {}

    local function enableStretchRez()
        if stretchEnabled then return end
        stretchEnabled = true
        Features["StretchRez"] = true
        
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.FieldOfView = stretchFOV
            end
            -- Monitorear cambios de cámara
            for _, conn in ipairs(cameraConnections) do
                if conn then conn:Disconnect() end
            end
            cameraConnections = {}
            table.insert(cameraConnections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
                local c = workspace.CurrentCamera
                if c and stretchEnabled then
                    c.FieldOfView = stretchFOV
                end
            end))
        end)
        showFeatureNotif("Stretch Rez ON", true)
        task.defer(saveConfig)
    end

    local function disableStretchRez()
        if not stretchEnabled then return end
        stretchEnabled = false
        Features["StretchRez"] = false
        
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.FieldOfView = defaultFOV
            end
            for _, conn in ipairs(cameraConnections) do
                if conn then conn:Disconnect() end
            end
            cameraConnections = {}
        end)
        showFeatureNotif("Stretch Rez OFF", false)
        task.defer(saveConfig)
    end

    if Features["StretchRez"] == nil then
        Features["StretchRez"] = false
    end

    makeToggle(mainScroll, "Stretch Rez", "StretchRez", function(on)
        if on then
            enableStretchRez()
        else
            disableStretchRez()
        end
    end)

    FeatureToggles["StretchRez"] = function()
        local newState = not Features["StretchRez"]
        Features["StretchRez"] = newState
        if newState then
            enableStretchRez()
        else
            disableStretchRez()
        end
    end

    if Features["StretchRez"] then
        task.defer(enableStretchRez)
    end
end
-- ==================== FIN STRETCH REZ ====================
-- ==================== GROUND CIRCLE TOGGLE ====================
do
    local groundCircleEnabled = false
    local circle = nil
    local originalTransparency = {}

    local function enableGroundCircle()
        if groundCircleEnabled then return end
        groundCircleEnabled = true
        Features["GroundCircle"] = true

        task.spawn(function()
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:WaitForChild("Humanoid")

            local DIAMETER = 16
            local THICKNESS = 0.05
            local COLOR = Color3.fromRGB(255, 255, 255)
            local TRANSPARENCY = 0

            circle = Instance.new("Part")
            circle.Name = "GroundCircle"
            circle.Shape = Enum.PartType.Cylinder
            circle.Size = Vector3.new(THICKNESS, DIAMETER, DIAMETER)
            circle.Color = COLOR
            circle.Transparency = TRANSPARENCY
            circle.Material = Enum.Material.SmoothPlastic
            circle.Anchored = true
            circle.CanCollide = false   -- sin colisión física
            circle.CanTouch = false     -- no activa eventos Touched
            circle.CanQuery = false     -- no es detectado por raycasts
            circle.CastShadow = false
            circle.TopSurface = Enum.SurfaceType.Smooth
            circle.BottomSurface = Enum.SurfaceType.Smooth
            circle.Parent = workspace

            local FLAT_ROT = CFrame.Angles(0, 0, math.pi / 2)
            local SMOOTHNESS = 1
            local targetPosition = nil

            local function getCirclePosition()
                local leftFoot = character:FindFirstChild("LeftFoot")
                local rightFoot = character:FindFirstChild("RightFoot")

                if leftFoot and rightFoot then
                    if humanoid.FloorMaterial ~= Enum.Material.Air then
                        local function raycastDown(part)
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {character, circle}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local result = workspace:Raycast(part.Position, Vector3.new(0,-5,0), rayParams)
                            if result then
                                return result.Position.Y
                            end
                            return part.Position.Y - 0.5
                        end
                        local leftY = raycastDown(leftFoot)
                        local rightY = raycastDown(rightFoot)
                        local groundY = (leftY + rightY) / 2 + 0.03
                        return Vector3.new(
                            (leftFoot.Position.X + rightFoot.Position.X) / 2,
                            groundY,
                            (leftFoot.Position.Z + rightFoot.Position.Z) / 2
                        )
                    else
                        local midFoot = (leftFoot.Position + rightFoot.Position) / 2
                        return midFoot + Vector3.new(0, -0.5, 0)
                    end
                else
                    if humanoid.FloorMaterial ~= Enum.Material.Air then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {character, circle}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local rayResult = workspace:Raycast(hrp.Position, Vector3.new(0,-10,0), rayParams)
                        if rayResult then
                            return rayResult.Position + Vector3.new(0,0.03,0)
                        end
                        return hrp.Position - Vector3.new(0,3.1,0)
                    else
                        return hrp.Position - Vector3.new(0,3.1,0)
                    end
                end
            end

            targetPosition = getCirclePosition()
            circle.CFrame = CFrame.new(targetPosition) * FLAT_ROT

            local heartbeatConn = nil
            heartbeatConn = RunService.Heartbeat:Connect(function(dt)
                if not groundCircleEnabled or not character or not character.Parent then
                    if heartbeatConn then heartbeatConn:Disconnect() end
                    if circle then circle:Destroy() end
                    return
                end

                local goalPos = getCirclePosition()

                if SMOOTHNESS >= 1 then
                    targetPosition = goalPos
                else
                    local t = math.min(SMOOTHNESS * dt * 60, 1)
                    targetPosition = targetPosition:Lerp(goalPos, t)
                end

                circle.CFrame = CFrame.new(targetPosition) * FLAT_ROT
            end)

            player.CharacterRemoving:Connect(function()
                disableGroundCircle()
            end)
        end)

        showFeatureNotif("Ground Circle ON", true)
        task.defer(saveConfig)
    end

    local function disableGroundCircle()
        if not groundCircleEnabled then return end
        groundCircleEnabled = false
        Features["GroundCircle"] = false

        if circle then
            circle:Destroy()
            circle = nil
        end
        showFeatureNotif("Ground Circle OFF", false)
        task.defer(saveConfig)
    end

    if Features["GroundCircle"] == nil then
        Features["GroundCircle"] = false
    end

    makeToggle(mainScroll, "Ground Circle", "GroundCircle", function(on)
        if on then
            enableGroundCircle()
        else
            disableGroundCircle()
        end
    end)

    FeatureToggles["GroundCircle"] = function()
        local newState = not Features["GroundCircle"]
        Features["GroundCircle"] = newState
        if newState then
            enableGroundCircle()
        else
            disableGroundCircle()
        end
    end

    if Features["GroundCircle"] then
        task.defer(enableGroundCircle)
    end
end
-- ==================== FIN GROUND CIRCLE ====================
-- ==================== KEYBINDS TOGGLE (SOLO MOBILE) ====================
makeToggle(mainScroll, "Streamer Mode", "StreamerMode", nil, true)

if UserInputService.TouchEnabled then
    makeToggle(mainScroll, "Keybinds", "KeybindsToggle", function(on)
        for _, btn in ipairs(_allBindBtns) do
            if btn and btn.Parent then
                btn.Visible = on
            end
        end
    end, true)

    task.defer(function()
        for _, btn in ipairs(_allBindBtns) do
            if btn and btn.Parent then
                btn.Visible = false
            end
        end
    end)
end
-- ==================== FIN KEYBINDS TOGGLE ====================

-- Espaciado final
do
    local endSpacer                  = Instance.new("Frame", mainScroll)
    endSpacer.Size                   = UDim2.new(1, 0, 0, 10)
    endSpacer.BackgroundTransparency = 1
    endSpacer.BorderSizePixel        = 0
    endSpacer.LayoutOrder            = rowOrder
    rowOrder                         = rowOrder + 1
end

-- ==================== RESTAURAR CONFIG ====================
-- Restaurar keybinds INMEDIATAMENTE
do
    local pending = _G["_ZurichHub_PendingKeybinds"]
    if pending then
        for feat, keyName in pairs(pending) do
            local ok, kc = pcall(function() return Enum.KeyCode[keyName] end)
            if ok and kc then
                FeatureKeybinds[feat] = kc
                if FeatureBindBtns[feat] then pcall(FeatureBindBtns[feat]) end
            end
        end
        _G["_ZurichHub_PendingKeybinds"] = nil
    end
    if _G["_ZurichHub_GamepadKeybinds"] then
        for feat, kc in pairs(_G["_ZurichHub_GamepadKeybinds"]) do
            if kc ~= nil and FeatureBindBtns[feat] then pcall(FeatureBindBtns[feat]) end
        end
    end
end

task.spawn(function()
    task.wait(0.3)
    _restoringConfig = true

    local pending = _G["_ZurichHub_PendingKeybinds"]
    if pending then
        for feat, keyName in pairs(pending) do
            local ok, kc = pcall(function() return Enum.KeyCode[keyName] end)
            if ok and kc then
                FeatureKeybinds[feat] = kc
                if FeatureBindBtns[feat] then pcall(FeatureBindBtns[feat]) end
            end
        end
        _G["_ZurichHub_PendingKeybinds"] = nil
    end

    local firstPass = { "AntiRagdoll", "GalaxyMode", "Unwalk", "BatAimbot", "ShowFPS", "ESPPlayers", "MedusaCounter",
        "RagdollDefender" }
    for _, feat in ipairs(firstPass) do
        if Features[feat] and FeatureSetters[feat] then
            FeatureSetters[feat](true); task.wait(0.02)
        end
    end
    if Features["Float"] and FeatureSetters["Float"] then
        task.spawn(function()
            task.wait(0.5)
            local c = Player.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                local timeout = 0
                while hum:GetState() ~= Enum.HumanoidStateType.Running and timeout < 3 do
                    task.wait(0.1); timeout = timeout + 0.1
                end
                timeout = 0
                while math.abs(hrp.AssemblyLinearVelocity.Y) > 0.5 and timeout < 2 do
                    task.wait(0.1); timeout = timeout + 0.1
                end
                task.wait(0.2)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = { c }
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                local result = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rayParams)
                local groundY = result and (result.Position.Y + 3.0) or hrp.Position.Y
                _G["_ZurichHub_FloatBaseOverride"] = groundY
            end
            FeatureSetters["Float"](true)
            _G["_ZurichHub_FloatBaseOverride"] = nil
        end)
    end
    task.wait(0.1)
    local secondPass = { "AutoSteal" }
    for _, feat in ipairs(secondPass) do
        if Features[feat] and FeatureSetters[feat] then
            FeatureSetters[feat](true); task.wait(0.05)
        end
    end
    task.wait(0.1)
    _restoringConfig = false
end)

-- ==================== POSICIÃ“N INICIAL Y TOGGLE SIN ANIMACIÃ“N ====================
local savedMenuPos          = _G["_ZurichHub_MenuPos"]
local initMenuX             = savedMenuPos and savedMenuPos.x or math.floor(VP.X * 0.65)
local initMenuY             = savedMenuPos and savedMenuPos.y or math.floor(VP.Y * 0.5 - MH / 2)
initMenuX, initMenuY        = clampUiPos(initMenuX, initMenuY, MW, MH)
main.Position               = UDim2.new(0, initMenuX, 0, initMenuY)
mainBorderFrame.Position    = UDim2.new(0, initMenuX, 0, initMenuY)
main.BackgroundTransparency = 0.25
main.Visible                = false
mainBorderFrame.Visible     = false

toggleBtn                   = nil

local hubTargetPos          = main.Position

-- ==================== TOGGLE MENÃš SIN ANIMACIÃ“N NI SOMBRA ====================
function toggleMenu()
    if main.Visible then
        main.Visible = false
        mainBorderFrame.Visible = false
    else
        local cx, cy = clampUiPos(hubTargetPos.X.Offset, hubTargetPos.Y.Offset, MW, MH)
        hubTargetPos = UDim2.new(0, cx, 0, cy)
        main.Position = hubTargetPos
        mainBorderFrame.Position = hubTargetPos
        main.BackgroundTransparency = 0.25
        main.Visible = true
        mainBorderFrame.Visible = true
    end
end

_toggleMenuRef = toggleMenu

-- Botón flotante para abrir/cerrar UI (PC + móvil)
do
    local savedBtnPos = _G["_ZurichHub_BtnPos"]
    local bX = savedBtnPos and savedBtnPos.x or math.floor(VP.X - 64)
    local bY = savedBtnPos and savedBtnPos.y or math.floor(VP.Y * 0.2)
    bX, bY = clampUiPos(bX, bY, 48, 48)

    toggleBtn = Instance.new("TextButton", sg)
    toggleBtn.AutoLocalize = false
    toggleBtn.Name = "HubToggleBtn"
    toggleBtn.Size = UDim2.new(0, 48, 0, 48)
    toggleBtn.Position = UDim2.new(0, bX, 0, bY)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    toggleBtn.BackgroundTransparency = 0.1
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = "UI"
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 14
    toggleBtn.TextColor3 = Color3.fromRGB(240, 240, 246)
    toggleBtn.ZIndex = 500
    toggleBtn.AutoButtonColor = false
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 10)
    local btnStroke = Instance.new("UIStroke", toggleBtn)
    btnStroke.Color = Color3.fromRGB(92, 92, 104)
    btnStroke.Thickness = 1.2
    btnStroke.Transparency = 0.2

    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local frameStart = nil
    local moved = false
    local DRAG_T = 8

    toggleBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        dragInput = inp
        dragStart = inp.Position
        frameStart = toggleBtn.Position
        moved = false
    end)
    toggleBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        local finish = false
        if dragging then
            if inp == dragInput then
                finish = true
            elseif inp.UserInputType == Enum.UserInputType.MouseButton1 and dragInput and dragInput.UserInputType == Enum.UserInputType.MouseButton1 then
                finish = true
            end
        end
        if not finish then return end
        dragging = false
        dragInput = nil
        local px, py = clampUiPos(toggleBtn.Position.X.Offset, toggleBtn.Position.Y.Offset, 48, 48)
        toggleBtn.Position = UDim2.new(0, px, 0, py)
        _G["_ZurichHub_BtnPos"] = { x = px, y = py }
        task.defer(saveConfig)
        if not moved then
            toggleMenu()
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if not dragging then return end
        if dragInput and dragInput.UserInputType == Enum.UserInputType.Touch and inp ~= dragInput then return end
        if dragInput and dragInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local d = inp.Position - dragStart
        if math.abs(d.X) > DRAG_T or math.abs(d.Y) > DRAG_T then
            moved = true
        end
        if moved then
            local nx, ny = clampUiPos(frameStart.X.Offset + d.X, frameStart.Y.Offset + d.Y, 48, 48)
            toggleBtn.Position = UDim2.new(0, nx, 0, ny)
        end
    end)
end

-- Mostrar menÃº al inicio sin animaciÃ³n
task.spawn(function()
    task.wait(0.3)
    toggleMenu()
    markBootReady()
end)

-- ==================== INPUT: CTRL toggle + KEYBINDS ====================
local isGamepad = UserInputService.GamepadEnabled
    or #UserInputService:GetConnectedGamepads() > 0
function shouldShowBindButtonsGlobal()
    local hasGamepadNow = UserInputService.GamepadEnabled or #UserInputService:GetConnectedGamepads() > 0
    if UserInputService.TouchEnabled and not hasGamepadNow then
        return false
    end
    local kbOn = _G["_ZurichHub_KeybindsOn"]
    if kbOn == nil then kbOn = true end
    return kbOn
end

function refreshAllBindButtonsVisibility()
    local show = shouldShowBindButtonsGlobal()
    for _, btn in ipairs(_allBindBtns) do
        if btn and btn.Parent then
            btn.Visible = show
        end
    end
end

local _gpConnectLock = false
UserInputService.GamepadConnected:Connect(function()
    isGamepad = true
    _gpConnectLock = true
    task.delay(1, function() _gpConnectLock = false end)
    refreshAllBindButtonsVisibility()
end)
UserInputService.GamepadDisconnected:Connect(function()
    isGamepad = #UserInputService:GetConnectedGamepads() > 0
    refreshAllBindButtonsVisibility()
end)
-- En móvil, a veces no llega el evento de conexión; polling liviano de respaldo.
task.spawn(function()
    while true do
        task.wait(1.0)
        refreshAllBindButtonsVisibility()
    end
end)

local GP_BUTTONS = {
    Enum.KeyCode.ButtonA, Enum.KeyCode.ButtonB, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonL1, Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL2, Enum.KeyCode.ButtonR2,
    Enum.KeyCode.ButtonL3, Enum.KeyCode.ButtonR3, Enum.KeyCode.ButtonStart, Enum.KeyCode.ButtonSelect,
    Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight,
}

local GP_NAMES = {
    [Enum.KeyCode.ButtonA] = "A/Cross/B",
    [Enum.KeyCode.ButtonB] = "B/Circle/A",
    [Enum.KeyCode.ButtonX] = "X/Square/Y",
    [Enum.KeyCode.ButtonY] = "Y/Tri/X",
    [Enum.KeyCode.ButtonL1] = "LB/L1/L",
    [Enum.KeyCode.ButtonR1] = "RB/R1/R",
    [Enum.KeyCode.ButtonL2] = "LT/L2/ZL",
    [Enum.KeyCode.ButtonR2] = "RT/R2/ZR",
    [Enum.KeyCode.ButtonL3] = "LS/L3",
    [Enum.KeyCode.ButtonR3] = "RS/R3",
    [Enum.KeyCode.ButtonStart] = "Start/Opt/+",
    [Enum.KeyCode.ButtonSelect] = "Sel/TP/-",
    [Enum.KeyCode.DPadUp] = "D-Up",
    [Enum.KeyCode.DPadDown] = "D-Down",
    [Enum.KeyCode.DPadLeft] = "D-Left",
    [Enum.KeyCode.DPadRight] = "D-Right",
}

local _gpSet = {}
for _, kc in ipairs(GP_BUTTONS) do _gpSet[kc] = true end
function isGamepadKey(kc) return _gpSet[kc] == true end

local GAMEPAD_MODIFIER = Enum.KeyCode.ButtonL1

local GamepadKeybinds = {
    SpeedBoost = nil,
    Float = nil,
    TPDown = nil,         -- ← Agregar
    BatAimbot = nil,
    LaggerAimbot = nil,
    AutoSteal = nil,
    RightSteal = nil,
    LeftSteal = nil,
    AntiRagdoll = nil,
    GalaxyMode = nil,
    Unwalk = nil,
    AutoDrop = nil,
    SpeedWhileStealing = nil,
    AutoPlay = nil,
    AutoLeft = nil,
    AutoRight = nil,
}

do
    local data = nil
    local ok, result = pcall(readfile, SAVE_FILE)
    if ok and result and #result > 0 then
        data = result
    elseif _G["_ZurichHub_Data"] then
        data = tostring(_G["_ZurichHub_Data"])
    end
    if data then
        for line in data:gmatch("[^\n]+") do
            if line:sub(1, 3) == "GP:" then
                local k, v = line:sub(4):match("([^=]+)=(.+)")
                if k and v then
                    local ok2, kc = pcall(function() return Enum.KeyCode[v] end)
                    if ok2 and kc then GamepadKeybinds[k] = kc end
                end
            end
        end
    end
    _G["_ZurichHub_GamepadKeybinds"] = GamepadKeybinds
end

local _origSaveConfig = saveConfig
saveConfig = function()
    if _restoringConfig then return end
    _G["_ZurichHub_GamepadKeybinds"] = GamepadKeybinds
    _origSaveConfig()
end

function keyDisplayName(kc)
    if not kc then return "BIND" end
    return GP_NAMES[kc] or tostring(kc):match("KeyCode%.(.+)") or tostring(kc)
end

local ctrlHeld = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    local t    = input.UserInputType
    local isKB = t == Enum.UserInputType.Keyboard
    local isGP = t == Enum.UserInputType.Gamepad1 or t == Enum.UserInputType.Gamepad2
        or t == Enum.UserInputType.Gamepad3 or t == Enum.UserInputType.Gamepad4

    if isKB and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
        ctrlHeld = true
    end

    if not isKB and not isGP then return end

    local _inListenMode = listeningBindBtn ~= nil and listeningFeature ~= nil

    if isGP and (input.KeyCode == Enum.KeyCode.Thumbstick1
            or input.KeyCode == Enum.KeyCode.Thumbstick2) then
        return
    end

    if not _inListenMode then
        if isKB and gameProcessed then return end
    end

    if listeningBindBtn and listeningFeature then
        if isKB then
            if input.KeyCode == Enum.KeyCode.Escape then
                FeatureKeybinds[listeningFeature] = nil
                if _G["_ZurichHub_GamepadKeybinds"] then
                    _G["_ZurichHub_GamepadKeybinds"][listeningFeature] = nil
                end
                GamepadKeybinds[listeningFeature] = nil
                listeningBindBtn.Text = "BIND"
            elseif input.KeyCode ~= Enum.KeyCode.LeftControl and input.KeyCode ~= Enum.KeyCode.RightControl then
                FeatureKeybinds[listeningFeature] = input.KeyCode
                if _G["_ZurichHub_GamepadKeybinds"] then
                    _G["_ZurichHub_GamepadKeybinds"][listeningFeature] = nil
                end
                GamepadKeybinds[listeningFeature] = nil
                listeningBindBtn.Text = keyDisplayName(input.KeyCode)
            end
            listeningBindBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            listeningBindBtn.TextColor3       = Color3.fromRGB(200, 200, 215)
            if FeatureBindBtns[listeningFeature] then pcall(FeatureBindBtns[listeningFeature]) end
            task.defer(saveConfig)
        elseif isGP then
            if input.KeyCode == GAMEPAD_MODIFIER then return end
            if input.KeyCode == Enum.KeyCode.ButtonSelect then
                GamepadKeybinds[listeningFeature] = nil
                if _G["_ZurichHub_GamepadKeybinds"] then
                    _G["_ZurichHub_GamepadKeybinds"][listeningFeature] = nil
                end
                FeatureKeybinds[listeningFeature] = nil
                listeningBindBtn.Text = "BIND"
            else
                GamepadKeybinds[listeningFeature] = input.KeyCode
                if _G["_ZurichHub_GamepadKeybinds"] then
                    _G["_ZurichHub_GamepadKeybinds"][listeningFeature] = input.KeyCode
                end
                FeatureKeybinds[listeningFeature] = nil
                listeningBindBtn.Text = keyDisplayName(input.KeyCode)
            end
            listeningBindBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
            listeningBindBtn.TextColor3       = Color3.fromRGB(200, 200, 215)
            if FeatureBindBtns[listeningFeature] then pcall(FeatureBindBtns[listeningFeature]) end
            task.defer(saveConfig)
        end
        listeningBindBtn = nil; listeningFeature = nil
        return
    end

    if isKB then
        for feat, key in pairs(FeatureKeybinds) do
            if input.KeyCode == key and FeatureToggles[feat] then
                FeatureToggles[feat]()
            end
        end
    elseif isGP then
        if input.KeyCode == GAMEPAD_MODIFIER then return end
        if _gpConnectLock then return end
        local GP_KC = input.KeyCode
        local isAssigned = false
        for feat, key in pairs(GamepadKeybinds) do
            if key == GP_KC then
                isAssigned = true; break
            end
        end
        if not isAssigned then
            for feat, key in pairs(FeatureKeybinds) do
                if key == GP_KC then
                    isAssigned = true; break
                end
            end
        end
        if not isAssigned then
            if GP_KC == Enum.KeyCode.ButtonA or GP_KC == Enum.KeyCode.ButtonB
                or GP_KC == Enum.KeyCode.ButtonX or GP_KC == Enum.KeyCode.ButtonL2
                or GP_KC == Enum.KeyCode.ButtonR2 or GP_KC == Enum.KeyCode.ButtonL3
                or GP_KC == Enum.KeyCode.ButtonR3 or GP_KC == Enum.KeyCode.ButtonStart
                or GP_KC == Enum.KeyCode.DPadUp or GP_KC == Enum.KeyCode.DPadDown
                or GP_KC == Enum.KeyCode.DPadLeft or GP_KC == Enum.KeyCode.DPadRight
            then
                return
            end
        end
        local _alreadyFired = {}
        for feat, key in pairs(GamepadKeybinds) do
            if GP_KC == key and key ~= nil and FeatureToggles[feat] then
                FeatureToggles[feat](); _alreadyFired[feat] = true
            end
        end
        for feat, key in pairs(FeatureKeybinds) do
            if GP_KC == key and key ~= nil and FeatureToggles[feat] and not _alreadyFired[feat] then
                FeatureToggles[feat]()
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        ctrlHeld = false
        if _skipNextCtrlToggle then
            _skipNextCtrlToggle = false
            return
        end
        if not listeningBindBtn then
            toggleMenu()
        end
    end
end)

task.defer(function()
    if not isGamepad then return end
    for feat, kc in pairs(GamepadKeybinds) do
        if kc ~= nil and FeatureBindBtns[feat] then pcall(FeatureBindBtns[feat]) end
    end
    for feat, kc in pairs(FeatureKeybinds) do
        if kc ~= nil and FeatureBindBtns[feat] then pcall(FeatureBindBtns[feat]) end
    end
end)

-- ==================== VARIABLES GLOBALES DE PATH ====================
local _pathIsActive  = false
local _pathCurrentWP = 1

-- ==================== BOTONES MOVILES EXTERNOS ====================
-- ==================== SPEED TRACKER (SOBRE LA CABEZA) ====================
do
    local speedTrackerEnabled      = true
    local speedConn                = nil
    local speedLabels              = {}

    local speedTrackerGui          = Instance.new("ScreenGui")
    speedTrackerGui.Name           = "ZurichSpeedTrackerGui"
    speedTrackerGui.ResetOnSpawn   = false
    speedTrackerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    speedTrackerGui.IgnoreGuiInset = true
    speedTrackerGui.DisplayOrder   = 999
    speedTrackerGui.Parent         = Player.PlayerGui

    local Camera                   = workspace.CurrentCamera

    local speedCache               = {}
    local posCache                 = {}

    local function getOrCreateLabel(playerName)
        if speedLabels[playerName] then return speedLabels[playerName] end

        local lbl = Instance.new("TextLabel", speedTrackerGui)
        lbl.AutoLocalize = false
        lbl.Name = "_ST_" .. playerName
        lbl.Size = UDim2.new(0, 120, 0, 30)
        lbl.BackgroundTransparency = 1
        lbl.Text = "0 st/s"
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 22
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.TextYAlignment = Enum.TextYAlignment.Center
        lbl.ZIndex = 999
        lbl.TextStrokeTransparency = 0.3
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Visible = false

        local stroke = Instance.new("UIStroke", lbl)
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.Transparency = 0

        speedLabels[playerName] = lbl
        return lbl
    end

    -- Heartbeat: solo calcula velocidad, NO posiciÃ³n ni UI
    local _stDataElapsed = 0
    RunService.Heartbeat:Connect(function(dt)
        if not speedTrackerEnabled then return end
        _stDataElapsed = _stDataElapsed + dt
        if _stDataElapsed < 0.1 then return end
        _stDataElapsed = 0

        for _, p in ipairs(Players:GetPlayers()) do
            local c = p.Character
            if c then
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.AssemblyLinearVelocity
                    local flatSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude
                    speedCache[p.Name] = string.format("%g st/s", math.floor(flatSpeed * 10 + 0.5) / 10)
                end
            end
        end
    end)

    -- RenderStepped: mueve labels sincronizado con el render, sin vibraciÃ³n
    speedConn = RunService.RenderStepped:Connect(function()
        if not speedTrackerEnabled then return end

        local seen = {}

        for _, p in ipairs(Players:GetPlayers()) do
            local c = p.Character
            if not c then continue end

            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then continue end

            local worldPos

            if p == Player then
                -- TU personaje: label encima de la cabeza
                local head = c:FindFirstChild("Head")
                if head then
                    worldPos = head.Position + Vector3.new(0, 2.5, 0)
                else
                    worldPos = hrp.Position + Vector3.new(0, 3.5, 0)
                end
            else
                -- OTROS jugadores: fijo en el torso, sin ningÃºn offset
                worldPos = hrp.Position
            end

            seen[p.Name] = true
            local lbl = getOrCreateLabel(p.Name)

            if speedCache[p.Name] then
                lbl.Text = speedCache[p.Name]
            end

            local screenPos, onScreen = Camera:WorldToScreenPoint(worldPos)
            if onScreen then
                lbl.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
                lbl.Visible = true
            else
                lbl.Visible = false
            end
        end

        for name, lbl in pairs(speedLabels) do
            if not seen[name] then
                lbl.Visible = false
            end
        end
    end)

    Features["SpeedTracker"] = false
end
-- ==================== FIN SPEED TRACKER ====================

task.spawn(function()
    while true do
        task.wait(1.5)
        if not _restoringConfig then
            pcall(saveConfig)
        end
    end
end)


-- ==================== VELOCITY BOOST (VERX STYLE) ====================
-- Reemplaza el boost tradicional (WalkSpeed) por Velocity,
-- usando las variables existentes: SpeedBoost, BoostSpeed, LaggerSpeed, LaggerBoostSpeed.
do
    local velocityConn = nil

    function getCurrentBoostSpeed()
        -- Detectar automáticamente si el jugador está robando
        local isStealing = Player:GetAttribute("Stealing")

        -- Si está robando, usar steal speed automáticamente
        if isStealing then
            if Features.LaggerSpeed then
                return Values.LaggerStealSpeed
            else
                return Values.StealingSpeedValue
            end
        end

        -- Si no está robando, usar boost speed
        if Features.LaggerSpeed then
            return Values.LaggerBoostSpeed
        else
            return Values.BoostSpeed
        end
    end

    function startVelocityBoost()
        if velocityConn then return end
        velocityConn = RunService.Heartbeat:Connect(function()
            -- Solo actuar si SpeedBoost está activado
            if not Features.SpeedBoost then return end

            local char = Player.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum or not root then return end

            -- Aplicar velocidad solo cuando el jugador se mueve manualmente (no en automático)
            if hum.MoveDirection.Magnitude > 0 then
                local speed = getCurrentBoostSpeed()
                root.Velocity = Vector3.new(
                    hum.MoveDirection.X * speed,
                    root.Velocity.Y,
                    hum.MoveDirection.Z * speed
                )
            end
        end)
    end

    function stopVelocityBoost()
        if velocityConn then
            velocityConn:Disconnect()
            velocityConn = nil
        end
    end

    -- Conectar el inicio/parada según el estado de SpeedBoost
    function onSpeedBoostChanged()
        if Features.SpeedBoost then
            startVelocityBoost()
        else
            stopVelocityBoost()
        end
    end

    -- Escuchar cambios en SpeedBoost (cuando se togglea desde UI o keybind)
    -- Como ya existe FeatureSetters["SpeedBoost"], la sobrescribimos para añadir nuestra lógica
    local originalSpeedBoostSetter = FeatureSetters["SpeedBoost"]
    FeatureSetters["SpeedBoost"] = function(state)
        if originalSpeedBoostSetter then
            originalSpeedBoostSetter(state)
        end
        Features.SpeedBoost = state
        onSpeedBoostChanged()
    end

    -- También escuchar cambios en LaggerSpeed (por si cambia mientras SpeedBoost está activo)
    local originalLaggerSetter = FeatureSetters["LaggerSpeed"]
    FeatureSetters["LaggerSpeed"] = function(state)
        if originalLaggerSetter then
            originalLaggerSetter(state)
        end
        -- Si SpeedBoost está activo, reiniciamos el loop para que use la nueva velocidad
        if Features.SpeedBoost then
            stopVelocityBoost()
            startVelocityBoost()
        end
    end

    -- Inicializar según el estado actual
    onSpeedBoostChanged()
end

-- ==================== FIN VELOCITY BOOST ====================

-- ==================== AIMBOTS (VERX STYLE - VELOCIDAD FIJA) ====================
-- Todos usan LinearVelocity con velocidades propias, sin tocar Values.BoostSpeed
-- ni Values.LaggerBoostSpeed, para no interferir con el movimiento manual.
-- ==================== BAT AIMBOT (solo movimiento, sin rotación) ====================
do
    local RANGE = 70
    local SPEED = 58.76

    local enabled = false
    local connections = {}
    local currentTarget = nil

    function getBat()
        local char = Player.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("bat") then
                    return tool
                end
            end
        end
        for _, tool in ipairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("bat") then
                return tool
            end
        end
        return nil
    end

    function getNearestEnemy(hrp)
        local nearest, minDist = nil, RANGE
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                if targetHRP and targetHum and targetHum.Health > 0 then
                    local d = (targetHRP.Position - hrp.Position).Magnitude
                    if d < minDist then
                        nearest = targetHRP
                        minDist = d
                    end
                end
            end
        end
        return nearest
    end

    function startAimbot()
        if connections.aimbot then return end
        _G["_ZurichHub_AimbotActive"] = true

        local char = Player.Character or Player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        local attach = Instance.new("Attachment", hrp)
        local linVel = Instance.new("LinearVelocity", hrp)
        linVel.Attachment0 = attach
        linVel.MaxForce = 1e9
        linVel.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        linVel.MaxAxesForce = Vector3.new(1e9, 1e9, 1e9)
        linVel.RelativeTo = Enum.ActuatorRelativeTo.World
        linVel.Enabled = false

        currentTarget = nil

        connections.aimbot = RunService.Heartbeat:Connect(function()
            if not enabled then return end
            char = Player.Character
            if not char then return end
            hrp = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            if currentTarget and currentTarget.Parent then
                local tHum = currentTarget.Parent:FindFirstChildOfClass("Humanoid")
                if not tHum or tHum.Health <= 0 then
                    currentTarget = nil
                end
            else
                currentTarget = nil
            end

            if not currentTarget then
                currentTarget = getNearestEnemy(hrp)
            end

            if not currentTarget then
                linVel.Enabled = false
                hum.AutoRotate = true
                return
            end

            -- NO forzamos rotación, solo movimiento
            -- Dejamos que hum.AutoRotate = true haga la rotación naturalmente
            hum.AutoRotate = true

            local targetPos = currentTarget.Position + currentTarget.CFrame.LookVector * 0.4
            local dir = targetPos - hrp.Position
            linVel.Enabled = true
            linVel.VectorVelocity = dir.Magnitude > 0.1
                and Vector3.new(dir.Unit.X * SPEED, dir.Unit.Y * SPEED, dir.Unit.Z * SPEED)
                or Vector3.zero

            local bat = getBat()
            if bat then
                if bat.Parent ~= char then
                    hum:EquipTool(bat)
                end
                bat:Activate()
                local handle = bat:FindFirstChild("Handle")
                if handle then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= Player and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            if tHRP and (tHRP.Position - hrp.Position).Magnitude <= 8 then
                                for _, part in ipairs(p.Character:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        pcall(function()
                                            firetouchinterest(handle, part, 0)
                                            firetouchinterest(handle, part, 1)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        connections.attach = attach
        connections.linVel = linVel
    end

    function stopAimbot()
        _G["_ZurichHub_AimbotActive"] = false
        if connections.aimbot then
            connections.aimbot:Disconnect()
            connections.aimbot = nil
        end
        if connections.attach then
            connections.attach:Destroy()
            connections.attach = nil
        end
        if connections.linVel then
            connections.linVel:Destroy()
            connections.linVel = nil
        end
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
    end

    makeToggle(mainScroll, "Aimbot", "BatAimbot", function(on)
        enabled = on
        if on then startAimbot() else stopAimbot() end
    end)

    Player.CharacterAdded:Connect(function()
        if enabled then
            task.wait(0.5)
            stopAimbot()
            startAimbot()
        end
    end)
end
-- ==================== LAGGER AIMBOT (solo movimiento, sin rotación) ====================
do
    local RANGE = 70
    local LAGGER_SPEED = 24

    local laggerEnabled = false
    local laggerConnections = {}
    local laggerCurrentTarget = nil

    function getBat()
        local char = Player.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("bat") then return tool end
            end
        end
        for _, tool in ipairs(Player.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("bat") then return tool end
        end
        return nil
    end

    function getNearestEnemy(hrp)
        local nearest, minDist = nil, RANGE
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local targetHRP = p.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                if targetHRP and targetHum and targetHum.Health > 0 then
                    local d = (targetHRP.Position - hrp.Position).Magnitude
                    if d < minDist then
                        nearest = targetHRP
                        minDist = d
                    end
                end
            end
        end
        return nearest
    end

    function startLaggerAimbot()
        if laggerConnections.aimbot then return end
        _G["_ZurichHub_LaggerAimbotActive"] = true

        local char = Player.Character or Player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")

        local attach = Instance.new("Attachment", hrp)
        local linVel = Instance.new("LinearVelocity", hrp)
        linVel.Attachment0 = attach
        linVel.MaxForce = 1e9
        linVel.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        linVel.MaxAxesForce = Vector3.new(1e9, 1e9, 1e9)
        linVel.RelativeTo = Enum.ActuatorRelativeTo.World
        linVel.Enabled = false

        laggerCurrentTarget = nil

        laggerConnections.aimbot = RunService.Heartbeat:Connect(function()
            if not laggerEnabled then return end
            char = Player.Character
            if not char then return end
            hrp = char:FindFirstChild("HumanoidRootPart")
            hum = char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            if laggerCurrentTarget and laggerCurrentTarget.Parent then
                local tHum = laggerCurrentTarget.Parent:FindFirstChildOfClass("Humanoid")
                if not tHum or tHum.Health <= 0 then
                    laggerCurrentTarget = nil
                end
            else
                laggerCurrentTarget = nil
            end

            if not laggerCurrentTarget then
                laggerCurrentTarget = getNearestEnemy(hrp)
            end

            if not laggerCurrentTarget then
                linVel.Enabled = false
                hum.AutoRotate = true
                return
            end

            hum.AutoRotate = true

            local targetPos = laggerCurrentTarget.Position + laggerCurrentTarget.CFrame.LookVector * 0.4
            local dir = targetPos - hrp.Position
            linVel.Enabled = true
            linVel.VectorVelocity = dir.Magnitude > 0.1
                and Vector3.new(dir.Unit.X * LAGGER_SPEED, dir.Unit.Y * LAGGER_SPEED, dir.Unit.Z * LAGGER_SPEED)
                or Vector3.zero

            local bat = getBat()
            if bat then
                if bat.Parent ~= char then hum:EquipTool(bat) end
                bat:Activate()
                local handle = bat:FindFirstChild("Handle")
                if handle then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= Player and p.Character then
                            local tHRP = p.Character:FindFirstChild("HumanoidRootPart")
                            if tHRP and (tHRP.Position - hrp.Position).Magnitude <= 8 then
                                for _, part in ipairs(p.Character:GetChildren()) do
                                    if part:IsA("BasePart") then
                                        pcall(function()
                                            firetouchinterest(handle, part, 0)
                                            firetouchinterest(handle, part, 1)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        laggerConnections.attach = attach
        laggerConnections.linVel = linVel
    end

    function stopLaggerAimbot()
        _G["_ZurichHub_LaggerAimbotActive"] = false
        if laggerConnections.aimbot then
            laggerConnections.aimbot:Disconnect()
            laggerConnections.aimbot = nil
        end
        if laggerConnections.attach then
            laggerConnections.attach:Destroy()
            laggerConnections.attach = nil
        end
        if laggerConnections.linVel then
            laggerConnections.linVel:Destroy()
            laggerConnections.linVel = nil
        end
        local char = Player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
    end

    makeToggle(mainScroll, "Lagger Aimbot", "LaggerAimbot", function(on)
        laggerEnabled = on
        if on then
            startLaggerAimbot()
            if not Features["EnableLagger"] and FeatureToggles["EnableLagger"] then
                FeatureToggles["EnableLagger"]()
            end
        else
            stopLaggerAimbot()
            if Features["EnableLagger"] and FeatureToggles["EnableLagger"] then
                FeatureToggles["EnableLagger"]()
            end
        end
    end)

    Player.CharacterAdded:Connect(function()
        if laggerEnabled then
            task.wait(0.5)
            stopLaggerAimbot()
            startLaggerAimbot()
        end
    end)
end


-- ==================== FIN AIMBOTS ====================



-- =====================================================
-- ==================== LAGGER INTEGRADO ====================
-- =====================================================

do
    -- Configuración del lagger según dispositivo
    local isMobileLagger = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

    local LAGGER_CONFIG = isMobileLagger and {
        TableIncrease = 270,
        Tries = 1,
        LoopWaitTime = 0.3
    } or {
        TableIncrease = 265,
        Tries = 1,
        LoopWaitTime = 0.3
    }

    local CUSTOM_REMOTE_PATH = "RobloxReplicatedStorage.SetPlayerBlockList"

    -- Función para resolver la ruta del remote
    local function resolveRemote(path)
        if not path or path == "" then return nil end
        local obj = game
        local cleaned = path:gsub("^game%.", "")
        for segment in cleaned:gmatch("[^%.]+") do
            if obj then
                obj = obj[segment]
            else
                return nil
            end
        end
        return obj
    end

    -- Función para calcular el valor máximo
    local function getmaxvalue(val)
        local mainvalueifonetable = 499999
        if type(val) ~= "number" then return nil end
        return mainvalueifonetable / (val + 2)
    end

    -- Función principal del lagger
    local function bomb(tableincrease, tries)
        local maintable = {}
        local spammedtable = {}
        table.insert(spammedtable, {})
        local z = spammedtable[1]
        for i = 1, tableincrease do
            local tableins = {}
            table.insert(z, tableins)
            z = tableins
        end
        local maximum = getmaxvalue(tableincrease) or 9999999
        for i = 1, maximum do
            table.insert(maintable, spammedtable)
            if i % 5000 == 0 then task.wait() end
        end
        local remote = resolveRemote(CUSTOM_REMOTE_PATH)
        if remote then
            for i = 1, tries do
                pcall(function()
                    if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                        remote:FireServer(maintable)
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(maintable)
                    end
                end)
            end
        end
    end

    -- Variables de control del lagger
    local laggerEnabled = false
    local laggerThread = nil
    local laggerRunning = false

    -- Función del bucle principal
    local function startLaggerLoop()
        while laggerRunning do
            pcall(function()
                game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
            end)
            task.spawn(function()
                bomb(LAGGER_CONFIG.TableIncrease, LAGGER_CONFIG.Tries)
            end)
            task.wait(math.max(LAGGER_CONFIG.LoopWaitTime, 0.15))
        end
    end

    -- Iniciar lagger
    local function startLagger()
        if laggerRunning then return end
        laggerRunning = true
        laggerThread = task.spawn(startLaggerLoop)
    end

    -- Detener lagger
    local function stopLagger()
        laggerRunning = false
        if laggerThread then
            coroutine.close(laggerThread)
            laggerThread = nil
        end
    end

    -- Optimización inicial del workspace (chunked para no congelar móvil).
    task.defer(function()
        local all = workspace:GetDescendants()
        for i, v in ipairs(all) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            elseif v:IsA("Part") and v.Material ~= Enum.Material.Neon and v.Material ~= Enum.Material.ForceField then
                v.Material = Enum.Material.SmoothPlastic
            end
            if i % 300 == 0 then
                task.wait()
            end
        end
    end)

    -- AÑADIR EL FEATURE "EnableLagger" AL SISTEMA EXISTENTE
    -- Esto automáticamente hará que funcione con los keybinds del hub

    -- Primero, agregamos EnableLagger a la tabla Features si no existe
    if Features["EnableLagger"] == nil then
        Features["EnableLagger"] = false
    end

    -- Función que se ejecutará cuando se togglee desde UI o keybind
    local function onLaggerToggled(state)
        laggerEnabled = state
        if laggerEnabled then
            startLagger()
        else
            stopLagger()
        end
    end

    -- Crear el toggle en la UI usando makeToggle (el mismo sistema que los demás)
    -- Esto automáticamente crea el toggle con su botón BIND incluido
    local _, setLagger, _, _, _ = makeToggle(mainScroll, "Enable Lagger", "EnableLagger", function(on)
        onLaggerToggled(on)
    end, false) -- false = permitir bind (igual que los otros toggles)

    -- También añadir al FeatureToggles para que el keybind lo controle
    FeatureToggles["EnableLagger"] = function()
        local newState = not Features["EnableLagger"]
        Features["EnableLagger"] = newState
        onLaggerToggled(newState)
        if setLagger then setLagger(newState) end
        showFeatureNotif("Enable Lagger", newState)
    end

    -- Sincronizar el estado inicial
    if Features["EnableLagger"] then
        onLaggerToggled(true)
        if setLagger then setLagger(true) end
    end

    -- =====================================================
    -- =====================================================
    -- FIN DE TU SCRIPT
    -- =====================================================

    -- Reorganiza visualmente las filas del main GUI por secciones lógicas.
    do
        local desiredOrder = {
            -- Movimiento
            ["Lagger Mode"] = 10,
            ["Inf Jump"] = 20,
            ["No Animation"] = 30,
            ["Float"] = 40,
            ["Float Height"] = 50,
            ["TP Down"] = 60,
            ["Bypass Speed+Lag"] = 70,
            ["Bypass Speed Val"] = 80,
            ["Bypass Lag Val"] = 90,
            ["Juker"] = 100,
            ["Juker Height"] = 110,
            ["Juker Delay"] = 120,

            -- Combate / defensa
            ["Anti Ragdoll"] = 200,
            ["Medusa Counter"] = 210,
            ["Aimbot"] = 220,
            ["Lagger Aimbot"] = 230,

            -- Robo
            ["Autoplay"] = 300,
            ["Drop"] = 310,
            ["Insta Grab"] = 320,
            ["Steal Duration"] = 330,

            -- Red / desync
            ["Enable Lagger"] = 400,
            ["Desync Bypass"] = 410,
            ["Desync Cat"] = 420,

            -- Visual / utilidades
            ["ESP Players"] = 500,
            ["Show FPS"] = 510,
            ["Streamer Mode"] = 520,
            ["Keybinds"] = 530,
            ["Taunt"] = 540,
        }

        local function getRowLabel(frame)
            local bestText = nil
            for _, child in ipairs(frame:GetChildren()) do
                if child:IsA("TextLabel") then
                    local txt = tostring(child.Text or "")
                    if txt ~= "" then
                        if not bestText or #txt > #bestText then
                            bestText = txt
                        end
                    end
                end
            end
            if not bestText then return nil end
            -- Normaliza labels tipo "Nombre: valor" para sliders/rows dinámicas.
            local normalized = bestText:match("^(.-):") or bestText
            return normalized
        end

        local rows = {}
        for _, child in ipairs(mainScroll:GetChildren()) do
            if child:IsA("Frame") then
                table.insert(rows, child)
            end
        end

        for _, row in ipairs(rows) do
            local currentOrder = tonumber(row.LayoutOrder) or 0
            local label = getRowLabel(row)
            local wanted = label and desiredOrder[label] or nil
            if wanted then
                row.LayoutOrder = wanted
            else
                row.LayoutOrder = 1000 + currentOrder
            end
        end
    end

    -- Helpers UI
    function corner(p, r)
        local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, r or 12); return c
    end

    function stroke(p, color, t, thick)
        local s = Instance.new("UIStroke", p)
        s.Color = color; s.Transparency = t or 0.4; s.Thickness = thick or 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        return s
    end

    function gradient(p, c1, c2, rot)
        local g = Instance.new("UIGradient", p)
        g.Color = ColorSequence.new(c1, c2)
        g.Rotation = rot or 90
        return g
    end

    -- GUI: KEY ENTRY
    function makeKeyGui()
        local redMain = Color3.fromRGB(220, 45, 45)
        local redGlow = Color3.fromRGB(255, 95, 95)
        local redDeep = Color3.fromRGB(140, 20, 20)

        local gui = Instance.new("ScreenGui")
        gui.Name = "ZurichHubKeyGui"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.Parent = PG

        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0, 400, 0, 260)
        frame.Position = UDim2.new(0.5, -200, 0.5, -130)
        frame.BackgroundColor3 = C.bg
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        corner(frame, 16)
        gradient(frame, C.bg, C.bgDeep, 135)
        stroke(frame, redMain, 0.55, 1)

        local glow = Instance.new("ImageLabel", frame)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://5028857084"
        glow.ImageColor3 = redDeep
        glow.ImageTransparency = 0.5
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(24, 24, 276, 276)
        glow.Size = UDim2.new(1, 40, 1, 40)
        glow.Position = UDim2.new(0, -20, 0, -20)
        glow.ZIndex = 0

        local petal = Instance.new("TextLabel", frame)
        petal.BackgroundTransparency = 1
        petal.Size = UDim2.new(0, 32, 0, 32)
        petal.Position = UDim2.new(0, 14, 0, 12)
        petal.Text = "*"; petal.TextSize = 26
        petal.Font = Enum.Font.GothamBold

        local title = Instance.new("TextLabel", frame)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, -20, 0, 38)
        title.Position = UDim2.new(0, 10, 0, 22)
        title.Font = Enum.Font.GothamBlack
        title.Text = "Zurich HUB KEY"
        title.TextColor3 = C.text
        title.TextSize = 22
        gradient(title, redGlow, redDeep, 90)

        local sub = Instance.new("TextLabel", frame)
        sub.BackgroundTransparency = 1
        sub.Size = UDim2.new(1, 0, 0, 14); sub.Position = UDim2.new(0, 0, 0, 64)
        sub.Font = Enum.Font.Gotham; sub.TextSize = 11
        sub.TextColor3 = C.textDim
        sub.Text = "buyZurich.lovable.app"

        local box = Instance.new("TextBox", frame)
        box.Size = UDim2.new(1, -40, 0, 46); box.Position = UDim2.new(0, 20, 0, 96)
        box.BackgroundColor3 = C.surface; box.BackgroundTransparency = 0.05
        box.TextColor3 = C.text
        box.PlaceholderText = "Enter your Zurich Hub key"
        box.PlaceholderColor3 = C.textDim
        box.Font = Enum.Font.GothamMedium; box.TextSize = 14
        box.ClearTextOnFocus = false; box.Text = ""
        corner(box, 10)
        stroke(box, C.border, 0.5, 1)

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, -40, 0, 46); btn.Position = UDim2.new(0, 20, 0, 156)
        btn.BackgroundColor3 = redMain
        btn.TextColor3 = Color3.fromRGB(255, 240, 240)
        btn.Text = "VERIFY KEY"
        btn.Font = Enum.Font.GothamBlack; btn.TextSize = 16
        btn.AutoButtonColor = false
        corner(btn, 10)
        gradient(btn, redGlow, redDeep, 110)
        stroke(btn, redDeep, 0.3, 1)

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18),
                { Size = UDim2.new(1, -36, 0, 46), Position = UDim2.new(0, 18, 0, 156) }):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.18),
                { Size = UDim2.new(1, -40, 0, 46), Position = UDim2.new(0, 20, 0, 156) }):Play()
        end)

        local status = Instance.new("TextLabel", frame)
        status.BackgroundTransparency = 1
        status.Size = UDim2.new(1, -20, 0, 18); status.Position = UDim2.new(0, 10, 1, -32)
        status.Font = Enum.Font.GothamMedium; status.TextSize = 12
        status.TextColor3 = C.textDim; status.Text = ""

        frame.Size = UDim2.new(0, 400, 0, 0)
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size = UDim2.new(0, 400, 0, 260) }):Play()

        return gui, box, btn, status, frame
    end

    -- GUI: TIMER
    function makeTimerGui(expiresAt)
        local redMain = Color3.fromRGB(220, 45, 45)
        local redGlow = Color3.fromRGB(255, 95, 95)
        local redDeep = Color3.fromRGB(140, 20, 20)

        local gui = Instance.new("ScreenGui")
        gui.Name = "ZurichHubTimerGui"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true
        gui.Parent = PG

        -- Ajustes de tamano y posicion del timer.
        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.new(0, 150, 0, 44)
        frame.AnchorPoint = Vector2.new(1, 1)
        frame.Position = UDim2.new(1, -160, 1, -10)
        frame.BackgroundColor3 = C.bg
        frame.BackgroundTransparency = 0.15
        frame.Active = false; frame.Selectable = false
        corner(frame, 10)
        gradient(frame, C.bg, C.bgDeep, 135)
        stroke(frame, redMain, 0.55, 1)

        local glow = Instance.new("ImageLabel", frame)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://5028857084"
        glow.ImageColor3 = redDeep
        glow.ImageTransparency = 0.7
        glow.ScaleType = Enum.ScaleType.Slice
        glow.SliceCenter = Rect.new(24, 24, 276, 276)
        glow.Size = UDim2.new(1, 20, 1, 20)
        glow.Position = UDim2.new(0, -10, 0, -10)
        glow.ZIndex = 0

        local petal = Instance.new("TextLabel", frame)
        petal.BackgroundTransparency = 1
        petal.Size = UDim2.new(0, 22, 0, 22); petal.Position = UDim2.new(0, 6, 0, 11)
        petal.Text = "*"; petal.TextSize = 16
        petal.Font = Enum.Font.GothamBold

        local label = Instance.new("TextLabel", frame)
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -32, 0, 14); label.Position = UDim2.new(0, 32, 0, 5)
        label.Font = Enum.Font.GothamBlack; label.TextSize = 10
        label.TextColor3 = C.text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = "Zurich HUB - KEY ACTIVE"
        gradient(label, redGlow, redDeep, 90)

        local timer = Instance.new("TextLabel", frame)
        timer.BackgroundTransparency = 1
        timer.Size = UDim2.new(1, -32, 0, 20); timer.Position = UDim2.new(0, 32, 0, 20)
        timer.Font = Enum.Font.GothamMedium; timer.TextSize = 12
        timer.TextColor3 = C.text
        timer.TextXAlignment = Enum.TextXAlignment.Left

        local function fmt(s)
            s = math.max(0, math.floor(s))
            local d = math.floor(s / 86400); s = s % 86400
            local h = math.floor(s / 3600); s = s % 3600
            local m = math.floor(s / 60); local sec = s % 60
            return string.format("%dd %02dh %02dm %02ds", d, h, m, sec)
        end

        local expEpoch
        do
            local y, mo, d, h, mi, se = expiresAt:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
            expEpoch = os.time({
                year = tonumber(y),
                month = tonumber(mo),
                day = tonumber(d),
                hour = tonumber(h),
                min =
                    tonumber(mi),
                sec = tonumber(se)
            })
        end

        task.spawn(function()
            while gui.Parent do
                local left = expEpoch - os.time()
                timer.Text = fmt(left)
                timer.TextColor3 = (left < 3600) and C.danger or C.text
                task.wait(1)
            end
        end)

        task.spawn(function()
            while gui.Parent do
                TweenService:Create(petal, TweenInfo.new(1.2, Enum.EasingStyle.Sine), { TextTransparency = 0.4 }):Play()
                task.wait(1.2)
                TweenService:Create(petal, TweenInfo.new(1.2, Enum.EasingStyle.Sine), { TextTransparency = 0 }):Play()
                task.wait(1.2)
            end
        end)

        return gui
    end
end