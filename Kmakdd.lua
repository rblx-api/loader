-- ============================================================
-- RLM DUELS + AUTO GRAB — EJECUCIÓN INDEPENDIENTE
-- Cada sistema se ejecuta en su propio bloque para evitar interferencias.
-- ============================================================

task.spawn(function()
    local ok, err = xpcall(function()
-- Anti doble ejecución (si se trabó, libera; re-ejecutar limpia GUI vieja)
do
    local running = _G.__CATALYST_DUELS_RUNNING == true
    local loaded = _G.__CATALYST_DUELS_LOADED == true
    local bootT = tonumber(_G.__CATALYST_BOOT_T) or 0
    if running and not loaded and bootT > 0 and (tick() - bootT) > 3 then
        _G.__CATALYST_DUELS_RUNNING = false
        running = false
    end
    -- permitir re-ejecutar si ya estaba cargado (reemplaza instancia)
    if running and loaded then
        _G.__CATALYST_DUELS_RUNNING = false
        running = false
        pcall(function()
            local cg = game:GetService("CoreGui")
            local old = cg:FindFirstChild("CatalystDuelsGUI") or cg:FindFirstChild("CatalystGUI")
            if old then old:Destroy() end
        end)
    end
    if running then
        warn("[RLM DUELS] ya se está ejecutando, ignorado")
        return
    end
end
_G.__CATALYST_DUELS_RUNNING = true
_G.__CATALYST_DUELS_LOADED = false
_G.__CATALYST_BOOT_T = tick()
_G._catalystShuttingDown = false

-- LuauProtect macros (fallback si el executor no las tiene)
do
    local function _lptId(fn) return fn end
    if type(LPT_FAST) ~= "function" then LPT_FAST = _lptId end
    if type(LPT_NO_VIRTUALIZE) ~= "function" then LPT_NO_VIRTUALIZE = _lptId end
    if type(LPT_VIRTUALIZE) ~= "function" then LPT_VIRTUALIZE = _lptId end
end

-- si el script falla a mitad, liberar el lock
task.delay(12, function()
    if _G.__CATALYST_DUELS_RUNNING and not _G.__CATALYST_DUELS_LOADED then
        _G.__CATALYST_DUELS_RUNNING = false
        warn("[RLM DUELS] lock liberado (timeout)")
    end
end)

print("[RLM DUELS] BOOT")
do
    local t0 = os.clock()
    while not game:IsLoaded() and (os.clock() - t0) < 30 do
        task.wait(0.1)
    end
    print("[RLM DUELS] game loaded")
end
-- estabilizar FPS al ejecutar (evita spike de 1-2s)
pcall(function()
    if setfpscap then setfpscap(60) end
end)
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
end)
pcall(function()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = Lighting.GlobalShadows -- no-op touch
end)

-- limpiar GUI / restos de una ejecución anterior
pcall(function()
    local names = {

        "InternalAntiRagdoll","CatalystPerfWarn","CatalystVisualControls","Catalyst_MusicPlayer",
        "CatalystRadar"
    }
    for _, n in ipairs(names) do
        pcall(function()
            local x = game:GetService("CoreGui"):FindFirstChild(n)
            if x then x:Destroy() end
        end)
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            if lp and lp:FindFirstChild("PlayerGui") then
                local x = lp.PlayerGui:FindFirstChild(n)
                if x then x:Destroy() end
            end
        end)
    end
end)

_G.__CATALYST_BOOTING = true
task.delay(5.5, function()
    _G.__CATALYST_BOOTING = false
    pcall(function()
        if setfpscap then setfpscap(60) end
    end)
end)

local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")

local _hitFxLast = 0
local _hitFxActive = 0
local HIT_FX_COOLDOWN = 0.12
local HIT_FX_MAX = 4

function playHitEffect(pos, intensity)
    return
end


function playHitEffectOnTarget(targetRoot, intensity)
    if not targetRoot then return end
    local pos = targetRoot.Position
    pcall(function()
        local head = targetRoot.Parent and targetRoot.Parent:FindFirstChild("Head")
        if head then pos = head.Position end
    end)
    playHitEffect(pos, intensity or 1)
end

local HttpService   = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local Stats         = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer


-- ====== PERF: cache de jugadores / character ======
local _cachedPlayers = {}
local _cachedPlayersAt = 0
local function getPlayersCached()
    local now = tick()
    if now - _cachedPlayersAt > 0.12 then
        _cachedPlayers = Players:GetPlayers()
        _cachedPlayersAt = now
    end
    return _cachedPlayers
end
local _charCache, _humCache, _hrpCache, _charCacheAt = nil, nil, nil, 0
local function getCharCached()
    local now = tick()
    if now - _charCacheAt > 0.05 then
        _charCache = LP.Character
        _humCache = _charCache and _charCache:FindFirstChildOfClass("Humanoid")
        _hrpCache = _charCache and _charCache:FindFirstChild("HumanoidRootPart")
        _charCacheAt = now
    end
    return _charCache, _humCache, _hrpCache
end

_G._catalystShuttingDown = false
function _catalystIsAlive()
    if _G._catalystShuttingDown then return false end
    if not game or not game.Parent then return false end
    if not LP or not LP.Parent then return false end
    return true
end
pcall(function()
    if game and typeof(game.BindToClose) == "function" then
        game:BindToClose(function()
            _G._catalystShuttingDown = true
            pcall(function() if _G.CatalystStopTpBat then _G.CatalystStopTpBat() end end)
            pcall(function() if stopBypassAimbot then stopBypassAimbot() end end)
            pcall(function() if _G.CatalystStopBat then _G.CatalystStopBat() end end)
            pcall(function() if stopAntiDie then stopAntiDie() end end)
        end)
    end
end)
pcall(function()
    Players.PlayerRemoving:Connect(function(plr)
        if plr == LP then
            _G._catalystShuttingDown = true
        end
    end)
end)

if not table.clone then
    function table.clone(t)
        local n = {}
        for k, v in pairs(t) do n[k] = v end
        return n
    end
end

print("[RLM DUELS] iniciando...")

local FileName = "KzsHubConfig_" .. LP.UserId .. ".json"
local DefaultConfig = {
    normalSpeed      = 60, carrySpeed     = 30,
    laggerSpeed1     = 17,
    laggerSpeed2     = 11,
    laggerLevel      = 0,
    speedType        = "normal",
    autoCarryEnabled = false,
    autoBatToggled   = false,
    infJumpEnabled   = false, infJumpMode = "manual",
    antiRagdollV1Enabled = false,
    antiRagdollV2Enabled = false,
    antiRagdollActiveVersion = 0,
    fpsBoostEnabled  = false,
    nukeEnabled = false,
    nukeLevel = 0,
    medusaCounterEnabled = false,
    animEnabled      = false, unwalkEnabled = false,
    animPack = "Off", -- disabled
    autoLeftEnabled  = false, autoRightEnabled = false,
    keyAutoLeft  = "Unknown", keyAutoRight = "Unknown",
    keyDropBR    = "Unknown", keyTpDown = "Unknown", keyAutoBat = "Unknown",
    keySpeedToggle = "Unknown",
    keyLagger = "Unknown",
    keyLagger1 = "Unknown",
    keyLagger2 = "Unknown",
    keyBatAim2 = "Unknown",
    keyTpBat = "Unknown",
    keyBatV2 = "Unknown",
    skyEnabled      = false, skyColorIndex = 1,
    noFogEnabled = false,
    stretchRezEnabled = false,
    stretchFov = 120,
    equipBatEnabled = false,
    equipBatSkin = "Default",
    bodyLockEnabled = false,
    bodyLockRange = 25,
    antiDieEnabled = false,
    tpBatMode = 2,
    tpBatStuds = 12,
    darkModeEnabled = false,
    particlesEnabled = false,
    particleStyle = 1,
    batCounterEnabled = false,
    mbButtonScale = 1.0,
    waypointESPEnabled = false,
    visualControlsEnabled = false,
    alternateMenuEnabled = false,
    lastMenuTab = "Move",
    guiVisible = true,
    musicVolume = 0.5,
    titleColor = "blue",
    menuTheme = "blue",
    floatBtnShape = "Square",
    autoGrabEnabled = true,
    autoGrabBarVisible = true,
    controllerEnabled = false, controllerBinds = {},
    mobileLocked = true,
    medusaResetEnabled = false,
    batAim2Enabled = false,
    batAim2Mode = "normal",
    dropEnabled = false,
    antiPlayerCollision = false,
                bypassToggled = false,
    bypassMode = 1,
    bypassSpeed = 55,
    spinEnabled = false,
    spinSpeed = 80,
    autoSpinBrainrot = false,

    guiScale = 0.8,
    playerSPEnabled = false,
    uiLocked = true,
    hiddenButtons = {},
    aimbotMode = "new",
    batAimbotZombie = false,
    autoSwingEnabled = true,
    korbloxEnabled = false,
    headlessEnabled = false,
    keyInstaReset = "Unknown",
    accessoryPack = "Off",
    bgFondoIndex = 1,
    miniStyle = 1,
    bgImageId = "74477110625593",
    e01Enabled = false,   -- NUEVO
    btnOffBg   = {0, 0, 0},
    btnOnBg    = {235, 235, 235},
    btnOffText = {160, 160, 160},
    btnOnText  = {255, 255, 255},
    guiAccent  = {255, 255, 255},
    speedColor = {180, 180, 180},
    hitboxColor = {180, 180, 180},
}

local Config = {}
local SaveCooldown = false

function LoadConfig()
    Config = {}
    for key, value in pairs(DefaultConfig) do
        Config[key] = value
    end
    local okFile = false
    pcall(function()
        if isfile and isfile(FileName) then
            okFile = true
        end
    end)
    if okFile then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(FileName))
        end)
        if ok and type(data) == "table" then
            for key, value in pairs(DefaultConfig) do
                if data[key] ~= nil then
                    Config[key] = data[key]
                end
            end
        end
    end
end

function SaveConfig()
    pcall(function() writefile(FileName, HttpService:JSONEncode(Config)) end)
end

function AutoSave()
    if SaveCooldown then return end
    SaveCooldown = true
    task.delay(1, function() SaveConfig(); SaveCooldown = false end)
end

function SetSetting(key, value)
    if not Config then return end
    if Config[key] == value then return end
    Config[key] = value
    AutoSave()
end

LoadConfig()
-- Mantener bloqueadas las posiciones de los botones al iniciar cada ejecución.
Config.mobileLocked = true

local State = {
    normalSpeed      = Config.normalSpeed,
    carrySpeed       = Config.carrySpeed,
    laggerSpeed1     = Config.laggerSpeed1,
    laggerSpeed2     = Config.laggerSpeed2,
    laggerLevel      = Config.laggerLevel,
    speedType        = Config.speedType,
    autoCarryEnabled = Config.autoCarryEnabled or false,
    autoBatToggled   = Config.autoBatToggled,
    infJumpEnabled   = Config.infJumpEnabled,
    infJumpMode      = Config.infJumpMode,
    antiRagdollV1Enabled = Config.antiRagdollV1Enabled or false,
    antiRagdollV2Enabled = Config.antiRagdollV2Enabled or false,
    antiRagdollActiveVersion = Config.antiRagdollActiveVersion or 0,
    fpsBoostEnabled  = Config.fpsBoostEnabled,
    nukeEnabled = Config.nukeEnabled or false,
    nukeLevel = Config.nukeLevel or 0,
    guiVisible       = Config.guiVisible ~= false,
    alternateMenuEnabled = Config.alternateMenuEnabled == true,
    lastMenuTab = tostring(Config.lastMenuTab or "Move"),
    musicVolume = math.clamp(tonumber(Config.musicVolume) or 0.5, 0, 1),
    guiScale         = tonumber(Config.guiScale) or 1.0,
    medusaLastUsed   = 0, medusaDebounce = false,
    medusaCounterEnabled = Config.medusaCounterEnabled,
    dropBrainrotActive = false,
    autoLeftEnabled  = false,
    autoRightEnabled = false,
    autoLeftPhase    = 1, autoRightPhase = 1,
    lastMoveDir      = Vector3.zero,
    animEnabled      = Config.animEnabled or false,
    animPack = Config.animPack or "Off",
    unwalkEnabled    = Config.unwalkEnabled,
    _tpInProgress    = false,
    keyAutoLeft  = Enum.KeyCode[Config.keyAutoLeft] or Enum.KeyCode.Unknown,
    keyAutoRight = Enum.KeyCode[Config.keyAutoRight] or Enum.KeyCode.Unknown,
    keyDropBR    = Enum.KeyCode[Config.keyDropBR] or Enum.KeyCode.Unknown,
    keyTpDown    = Enum.KeyCode[Config.keyTpDown] or Enum.KeyCode.Unknown,
    keyAutoBat   = Enum.KeyCode[Config.keyAutoBat] or Enum.KeyCode.Unknown,
    keySpeedToggle = Enum.KeyCode[Config.keySpeedToggle] or Enum.KeyCode.Unknown,
    keyLagger = Enum.KeyCode[Config.keyLagger] or Enum.KeyCode.Unknown,
    keyLagger1 = Enum.KeyCode[Config.keyLagger1] or Enum.KeyCode.Unknown,
    keyLagger2 = Enum.KeyCode[Config.keyLagger2] or Enum.KeyCode.Unknown,
    keyBatAim2 = Enum.KeyCode[Config.keyBatAim2] or Enum.KeyCode.Unknown,
    keyTpBat = Enum.KeyCode[Config.keyTpBat] or Enum.KeyCode.Unknown,
    keyBatV2 = Enum.KeyCode[Config.keyBatV2] or Enum.KeyCode.Unknown,
    keyInstaReset = Enum.KeyCode[Config.keyInstaReset] or Enum.KeyCode.Unknown,
    skyEnabled = Config.skyEnabled,
    skyColorIndex = Config.skyColorIndex,
    noFogEnabled = Config.noFogEnabled or false,
    stretchRezEnabled = Config.stretchRezEnabled,
    stretchFov = tonumber(Config.stretchFov) or 120,
    equipBatEnabled = Config.equipBatEnabled or false,
    equipBatSkin = tostring(Config.equipBatSkin or "Default"),
    bodyLockEnabled = Config.bodyLockEnabled or false,
    bodyLockRange = tonumber(Config.bodyLockRange) or 25,
    antiDieEnabled = Config.antiDieEnabled or false,
    tpBatMode = tonumber(Config.tpBatMode) or 2,
    tpBatStuds = tonumber(Config.tpBatStuds) or 12,
    darkModeEnabled = Config.darkModeEnabled or false,
    particlesEnabled = Config.particlesEnabled or false,
    particleStyle = tonumber(Config.particleStyle) or 1,
    batCounterEnabled = Config.batCounterEnabled,
    batCounterDebounce = false,
    waypointESPEnabled = Config.waypointESPEnabled,
    visualControlsEnabled = Config.visualControlsEnabled or false,
    titleColor = Config.menuTheme or Config.titleColor or "blue",
    controllerEnabled = Config.controllerEnabled,
    controllerBinds = Config.controllerBinds,
    mobileLocked = Config.mobileLocked,
    antiPlayerCollision = Config.antiPlayerCollision or false,
                medusaResetEnabled = Config.medusaResetEnabled,
    bypassToggled = Config.bypassToggled or false,
    bypassMode = Config.bypassMode or 1,
    bypassSpeed = Config.bypassSpeed or 55,
    spinEnabled = Config.spinEnabled or false,
    spinSpeed = tonumber(Config.spinSpeed) or 80,
    autoSpinBrainrot = Config.autoSpinBrainrot or false,

    playerSPEnabled = Config.playerSPEnabled or false,
    uiLocked = Config.uiLocked ~= false,
    miniStyle = tonumber(Config.miniStyle) or 1,
    hiddenButtons = (type(Config.hiddenButtons)=="table" and Config.hiddenButtons) or {},
    aimbotMode = Config.aimbotMode or "new",
    batAimbotZombie = Config.batAimbotZombie or false,
    autoSwingEnabled = Config.autoSwingEnabled ~= nil and Config.autoSwingEnabled or true,
    korbloxEnabled = Config.korbloxEnabled or false,
    headlessEnabled = Config.headlessEnabled or false,
    accessoryPack = Config.accessoryPack or "Off",
    originalOutfit = {},
    originalAccessories = {},
    e01Enabled = Config.e01Enabled or false,  -- NUEVO
}

function startFloat() end
function stopFloat() end

local resetCooldown = false
local CONFIG = {
    ResetCooldown = 0.12
}

function getCharacter()
    return LP.Character
end

function getHRP()
    local char = getCharacter()
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    end
    return nil
end

function performReset()
    if resetCooldown then return end
    resetCooldown = true

    local char = getCharacter()
    if not char then
        resetCooldown = false
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = getHRP()
    if not hrp then
        resetCooldown = false
        return
    end

    -- kill + hipheight al instante (sin escaneo pesado)
    if hum then
        pcall(function()
            hum.HipHeight = 1e30
            hum.BreakJointsOnDeath = true
            hum.PlatformStand = true
            hum.Health = 0
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        end)
    end
    pcall(function()
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.AssemblyLinearVelocity = Vector3.new(0, 1e7, 0)
        hrp.CanCollide = false
    end)

    -- remotes rápidos (solo raíz, sin GetDescendants)
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        for _, name in ipairs({"Reset", "LoadCharacter", "Respawn", "CharacterReset"}) do
            local rem = rs:FindFirstChild(name)
            if rem then
                if rem:IsA("RemoteEvent") then pcall(function() rem:FireServer() end)
                elseif rem:IsA("RemoteFunction") then pcall(function() rem:InvokeServer() end) end
            end
        end
        local sg = game:GetService("StarterGui")
        pcall(function()
            sg:SetCore("ResetButtonCallback", false)
            sg:SetCore("ResetButtonCallback", true)
        end)
    end)

    -- limpiar ragdoll en paralelo (no bloquea el kill)
    task.defer(function()
        local c = char
        if not c or not c.Parent then return end
        pcall(function()
            for _, obj in ipairs(c:GetDescendants()) do
                if obj:IsA("BallSocketConstraint") or (obj:IsA("Attachment") and tostring(obj.Name):find("Ragdoll")) then
                    obj:Destroy()
                end
            end
        end)
    end)

    local cam = workspace.CurrentCamera
    if cam then
        task.delay(0.03, function()
            if not cam then return end
            cam.CameraType = Enum.CameraType.Custom
            local c2 = LP.Character
            local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
            if h2 then cam.CameraSubject = h2 end
        end)
    end

    task.delay(0.12, function()
        resetCooldown = false
    end)
end

function instaReset()
    performReset()
end

function instareset(resetType)
    performReset()
end

_G.StopResetSequence = function() end

local antiRagV1Conn = nil
local antiRagV2 = { Connection = nil, ResetCooldown = 0, Enabled = false }

function startAntiRagdollV1()
    if antiRagV1Conn then return end
    local _ar1Acc = 0
    antiRagV1Conn = RunService.Heartbeat:Connect(function(dt)
        if not State.antiRagdollV1Enabled then return end
        if _G.__CATALYST_BOOTING then return end
        _ar1Acc = _ar1Acc + (dt or 0.016)
        if _ar1Acc < 0.05 then return end
        _ar1Acc = 0
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        local s = hum:GetState()
        -- no tratar salto/caída normal como ragdoll (evita matarte al "flotar" con Inf Jump)
        local ragdolled = hum.PlatformStand == true
            or s == Enum.HumanoidStateType.Ragdoll
            or (s == Enum.HumanoidStateType.Physics and hum.PlatformStand)
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then ragdolled = true end
        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") then
                    d:Destroy()
                elseif d:IsA("Attachment") and d.Name:find("Ragdoll") then
                    d:Destroy()
                elseif d:IsA("Motor6D") and d.Enabled == false then
                    d.Enabled = true
                end
            end
            hum.PlatformStand = false
            hum.Sit = false
            if root.Anchored then root.Anchored = false end
            if hum.Health > 0 and not State.infJumpEnabled then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            elseif hum.Health > 0 then
                -- con Inf Jump: solo quitar ragdoll, no forzar Running en el aire
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end
            if workspace.CurrentCamera and workspace.CurrentCamera.CameraSubject ~= hum then
                workspace.CurrentCamera.CameraSubject = hum
            end
            if root.AssemblyAngularVelocity.Magnitude > 8 and not State.spinEnabled then
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end)
end

function stopAntiRagdollV1()
    if antiRagV1Conn then
        antiRagV1Conn:Disconnect()
        antiRagV1Conn = nil
    end
end

function forceNoSplatterReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        if hum.PlatformStand then hum.PlatformStand = false end
        if root.Anchored then root.Anchored = false end
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        task.defer(function()
            pcall(function()
                if hum and hum.Parent then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end)
        local v = root.AssemblyLinearVelocity
        -- no cortar el salto si Inf Jump está activo
        if v.Magnitude > 90 and not State.infJumpEnabled then
            root.AssemblyLinearVelocity = Vector3.new(v.X * 0.35, math.clamp(v.Y, -35, 55), v.Z * 0.35)
        end
        if root.AssemblyAngularVelocity.Magnitude > 10 and not State.spinEnabled then
            root.AssemblyAngularVelocity = Vector3.zero
        end

        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("BallSocketConstraint") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("Constraint") and obj.Name ~= "InfJumpVelocity" and obj.Name ~= "KzLinearVelocity" and obj.Name ~= "CatalystBatLinearVelocity" then
                -- no tocar LinearVelocity del bat
                if not obj:IsA("LinearVelocity") and not obj:IsA("AngularVelocity") then
                    obj.Enabled = true
                end
            end
        end

        if workspace.CurrentCamera then
            workspace.CurrentCamera.CameraSubject = hum
        end

        pcall(function()
            local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
            if PM then
                local cmObj = PM:FindFirstChild("ControlModule")
                if cmObj then
                    local ok, CM = pcall(require, cmObj)
                    if ok and CM and CM.Enable then
                        CM:Enable()
                    end
                end
            end
        end)

        if not State.bodyLockEnabled then
            hum.AutoRotate = true
        end
        hum.PlatformStand = false
        hum.Sit = false
        if root.Anchored then root.Anchored = false end
        if sethiddenproperty then
            pcall(sethiddenproperty, root, "PhysicsRepRootPart", nil)
        end
    end)
end

function startAntiRagdollV2()
    -- Clean Duels V2: no destruye constraints, te deja mover
    if antiRagV2.Connection then return end
    antiRagV2.Enabled = true
    antiRagV2.ResetCooldown = 0
    antiRagV2.Connection = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollV2Enabled then return end
        if antiRagV2.Enabled == false then return end
        if _G.__CATALYST_BOOTING then return end
        -- No mezclar con Anti Bat propio ni Clean Anti Bat
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end

        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
        then
            local now = tick()
            if now - (antiRagV2.ResetCooldown or 0) <= 0.15 then return end
            antiRagV2.ResetCooldown = now
            pcall(function()
                if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end

                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                -- limpiar velocidades de fling sin anclar ni romper el personage
                pcall(function()
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                end)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero

                -- Clean: RE-ENABLE joints/constraints (no destroy)
                for _, d in ipairs(char:GetDescendants()) do
                    if d:IsA("Motor6D") then
                        d.Enabled = true
                    elseif d:IsA("Constraint") then
                        d.Enabled = true
                    end
                end

                if workspace.CurrentCamera then
                    workspace.CurrentCamera.CameraSubject = hum
                end
                pcall(function()
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local cmObj = PM:FindFirstChild("ControlModule")
                        if cmObj then
                            local ok, CM = pcall(require, cmObj)
                            if ok and CM and CM.Enable then
                                CM:Enable()
                            end
                        end
                    end
                end)
                if not State.bodyLockEnabled and not State.spinEnabled and not (_G.CatalystBat and _G.CatalystBat.active) then
                    hum.AutoRotate = true
                end
                hum.PlatformStand = false
                hum.Sit = false
            end)
        end
    end)
end

function stopAntiRagdollV2()
    antiRagV2.Enabled = false
    if antiRagV2.Connection then
        pcall(function() antiRagV2.Connection:Disconnect() end)
        antiRagV2.Connection = nil
    end
    antiRagV2.ResetCooldown = 0
end

function setAntiRagdollVersion(version)
    if version == 1 then
        State.antiRagdollV1Enabled = true
        State.antiRagdollV2Enabled = false
        State.antiRagdollActiveVersion = 1
        stopAntiRagdollV2()
        startAntiRagdollV1()
    elseif version == 2 then
        State.antiRagdollV1Enabled = false
        State.antiRagdollV2Enabled = true
        State.antiRagdollActiveVersion = 2
        stopAntiRagdollV1()
        startAntiRagdollV2()
    else
        State.antiRagdollV1Enabled = false
        State.antiRagdollV2Enabled = false
        State.antiRagdollActiveVersion = 0
        stopAntiRagdollV1()
        stopAntiRagdollV2()
    end
    SetSetting("antiRagdollV1Enabled", State.antiRagdollV1Enabled)
    SetSetting("antiRagdollV2Enabled", State.antiRagdollV2Enabled)
    SetSetting("antiRagdollActiveVersion", State.antiRagdollActiveVersion)
    if _G.updateAntiRagdollUI then
        pcall(_G.updateAntiRagdollUI, State.antiRagdollActiveVersion)
    end
end

-- watchdog: si el toggle está ON pero se cortó la conexión, la reabre
task.spawn(function()
    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        if _G.__CATALYST_BOOTING then return end
        acc = acc + (dt or 0.016)
        if acc < 4.0 then return end
        acc = 0
        pcall(function()
            if State.antiRagdollV2Enabled then
                if not antiRagV2.Connection then
                    startAntiRagdollV2()
                end
            elseif State.antiRagdollV1Enabled then
                if not antiRagV1Conn then
                    startAntiRagdollV1()
                end
            end
        end)
    end)
end)

LP.CharacterAdded:Connect(function()
    task.delay(0.35, function()
        pcall(function()
            if State.antiRagdollV2Enabled then
                startAntiRagdollV2()
            elseif State.antiRagdollV1Enabled then
                startAntiRagdollV1()
            end
        end)
    end)
end)


_G.CatalystBatOn = false
_G.CatalystBat = {
    conn = nil,
    target = nil,
    lastScan = 0,
    attachment = nil,
    linearVelocity = nil,
    swingCooldown = false,
    active = false,
}

local function _CatalystBatEnsureLV(root)
    local S = _G.CatalystBat

    if S.linearVelocity and S.linearVelocity.Parent and S.attachment and S.attachment.Parent == root then
        S.linearVelocity.Enabled = true
        return S.linearVelocity
    end

    if S.linearVelocity then pcall(function() S.linearVelocity:Destroy() end) end
    if S.attachment then pcall(function() S.attachment:Destroy() end) end

    local att = Instance.new("Attachment")
    att.Name = "CatalystBatAttachment"
    att.Parent = root

    local lv = Instance.new("LinearVelocity")
    lv.Name = "CatalystBatLinearVelocity"
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.ForceLimitMode = Enum.ForceLimitMode.Magnitude
    lv.MaxForce = math.huge
    lv.VectorVelocity = Vector3.zero
    lv.Enabled = true
    lv.Parent = att

    S.attachment = att
    S.linearVelocity = lv
    return lv
end

local function _CatalystBatReleaseLV()
    local S = _G.CatalystBat
    if S.linearVelocity and S.linearVelocity.Parent then
        S.linearVelocity.VectorVelocity = Vector3.zero
        S.linearVelocity.Enabled = false
    end
end

function _G.CatalystFindBat()
    local char = LP.Character
    if not char then return nil end

    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
            return t
        end
    end

    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
                return t
            end
        end
    end
    return nil
end

function _G.CatalystStartBat()
    if State.bypassToggled then return end -- Bat V2 activo: no Auto Bat
    -- Bat Aimbot = misma logica que Bat V2 Mode V2 (prediccion), independiente del boton Bat V2
    pcall(function()
        if _G.CatalystTpBatOn and _G.CatalystStopTpBat then
            _G.CatalystStopTpBat()
            if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
        end
    end)
    pcall(function()
        if State.autoLeftEnabled then
            State.autoLeftEnabled = false
            if setAutoLeft then setAutoLeft(false) end
            if setMB_AL then setMB_AL(false) end
            if stopAutoLeft then stopAutoLeft() end
        end
        if State.autoRightEnabled then
            State.autoRightEnabled = false
            if setAutoRight then setAutoRight(false) end
            if setMB_AR then setMB_AR(false) end
            if stopAutoRight then stopAutoRight() end
        end
    end)

    _G.CatalystStopBat()

    local S = _G.CatalystBat
    S.active = true
    _G.CatalystBatOn = true
    S.target = nil
    S.nextSwingAt = 0
    S._prevAutoRotate = nil
    S._swingCd = false

    local AIM = {
        speed = 58,
        activateDistance = 8,
        predictTime = 0.14,
        swingDelay = 0.08,
        showDot = true,
        dotPart = nil,
        dotColor = Color3.fromRGB(220, 30, 45),
        dotSize = 1.5,
    }

    local function hideDot()
        if AIM.dotPart then
            pcall(function() AIM.dotPart:Destroy() end)
            AIM.dotPart = nil
        end
    end
    S._hideAimDot = hideDot

    local function updateDot(pos)
        if not AIM.showDot then
            if AIM.dotPart then AIM.dotPart.Transparency = 1 end
            return
        end
        if not AIM.dotPart or not AIM.dotPart.Parent then
            local dot = Instance.new("Part")
            dot.Name = "CatalystAimbotPredDot"
            dot.Shape = Enum.PartType.Ball
            dot.Size = Vector3.new(AIM.dotSize, AIM.dotSize, AIM.dotSize)
            dot.Color = AIM.dotColor
            dot.Material = Enum.Material.Neon
            dot.CanCollide = false
            dot.CanTouch = false
            dot.CanQuery = false
            dot.Anchored = true
            dot.CastShadow = false
            dot.Parent = workspace
            local hl = Instance.new("Highlight", dot)
            hl.FillColor = AIM.dotColor
            hl.FillTransparency = 0.25
            hl.OutlineColor = Color3.fromRGB(255, 140, 150)
            hl.OutlineTransparency = 0.1
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            AIM.dotPart = dot
        end
        AIM.dotPart.CFrame = CFrame.new(pos)
        AIM.dotPart.Transparency = 0
    end

    local BAT_LIST = {
        "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
        "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
        "Nuclear Slap","Galaxy Slap","Glitched Slap"
    }
    local function findBat()
        local char = LP.Character
        if not char then return nil end
        for _, name in ipairs(BAT_LIST) do
            local t = char:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, name in ipairs(BAT_LIST) do
                local t = bp:FindFirstChild(name)
                if t and t:IsA("Tool") then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(t) end) end
                    return t
                end
            end
        end
        for _, ch in ipairs(char:GetChildren()) do
            if ch:IsA("Tool") then
                local n = ch.Name:lower()
                if n:find("bat") or n:find("slap") then return ch end
            end
        end
        return nil
    end

    local function closestRoot()
        local char = LP.Character
        local myRoot = char and char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local best, bestD = nil, math.huge
        for _, plr in ipairs(getPlayersCached and getPlayersCached() or Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                local th = plr.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.Health > 0 then
                    local d = (tr.Position - myRoot.Position).Magnitude
                    if d < bestD then bestD, best = d, tr end
                end
            end
        end
        return best
    end

    local function trySwing(targetRoot)
        if S._swingCd then return end
        S._swingCd = true
        pcall(function()
            local char = LP.Character
            if not char then return end
            local bat = findBat()
            if not bat then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if bat.Parent ~= char and hum then
                pcall(function() hum:EquipTool(bat) end)
            end
            pcall(function() bat:Activate() end)
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
            if remote then pcall(function() remote:FireServer() end) end
            local handle = bat:FindFirstChild("Handle")
            local tChar = targetRoot and targetRoot.Parent
            if handle and tChar and firetouchinterest then
                pcall(function() handle.CanTouch = true end)
                for _, pn in ipairs({"HumanoidRootPart", "UpperTorso", "Torso"}) do
                    local tp = tChar:FindFirstChild(pn)
                    if tp then
                        pcall(firetouchinterest, handle, tp, 0)
                        pcall(firetouchinterest, handle, tp, 1)
                    end
                end
            end
        end)
        task.delay(AIM.swingDelay, function() S._swingCd = false end)
    end

    S.conn = RunService.RenderStepped:Connect(function()
        if not _G.CatalystBatOn or not S.active then return end
        if _G._catalystShuttingDown then return end

        local char = LP.Character
        if not char then hideDot(); return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then
            if AIM.dotPart then AIM.dotPart.Transparency = 1 end
            return
        end

        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            return
        end

        hum.AutoRotate = false
        local bat = findBat()
        if bat and bat.Parent ~= char then
            pcall(function() hum:EquipTool(bat) end)
        end

        local targetRoot = closestRoot()
        if not targetRoot then
            if not State.spinEnabled then
                root.AssemblyAngularVelocity = Vector3.zero
            end
            if AIM.dotPart then AIM.dotPart.Transparency = 1 end
            return
        end
        S.target = targetRoot

        local targetVel = targetRoot.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = targetRoot.Position

        local predictPos = targetPos
            + targetVel * AIM.predictTime
            + targetRoot.CFrame.LookVector * 0.3

        updateDot(predictPos)

        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.new(0, 0, 1)
        end

        -- Clean Hub aimbot motion
        local chaseSpeed = 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        pcall(function() _G._catalystBatVelWrite = tick() end)

        local predictTime2 = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local fullPredict = targetPos + targetVel * predictTime2
        if (fullPredict - myPos).Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, fullPredict)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            if not State.spinEnabled then
                root.AssemblyAngularVelocity =
                    root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
            end
        end

        local distToTarget = (myPos - targetPos).Magnitude
        if distToTarget <= AIM.activateDistance then
            trySwing(targetRoot)
        end
    end)

    if not State.bypassToggled then
        if setAutoBat then pcall(setAutoBat, true) end
        if setMB_AB then pcall(setMB_AB, true) end
        State.autoBatToggled = true
        SetSetting("autoBatToggled", true)
    end
end

function _G.CatalystStopBat()
    _G.CatalystBatOn = false
    pcall(function()
        local S = _G.CatalystBat
        if S and S._hideAimDot then S._hideAimDot() end
    end)
    local S = _G.CatalystBat
    if S then
        S.active = false
        if S.conn then
            pcall(function() S.conn:Disconnect() end)
            S.conn = nil
        end
        if S.safetyConn then
            pcall(function() S.safetyConn:Disconnect() end)
            S.safetyConn = nil
        end
        S.target = nil
        S.swingCooldown = false
        S.intendedVelocity = Vector3.zero
        S._cleanZ = nil
    end
    pcall(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if r then r.AssemblyAngularVelocity = Vector3.zero end
        if h then
            local prev = S and S._prevAutoRotate
            h.AutoRotate = (prev == nil) and true or prev
        end
    end)
    if not State.bypassToggled then
        if setAutoBat then pcall(setAutoBat, false) end
        if setMB_AB then pcall(setMB_AB, false) end
        State.autoBatToggled = false
        SetSetting("autoBatToggled", false)
    end
end

-- Clean Bat V2 API (lo que usa Bat V2 / bypass mode)
_G.CatalystCleanBatV2Start = function() end
_G.CatalystCleanBatV2Stop = function() end



function _G.CatalystToggleBat()
    if State.aimbotMode == "new" then
        if State.batAimbotZombie then
            if _G._7upStopZombieBatAimbot then
                pcall(_G._7upStopZombieBatAimbot)
            end
        else
            if _G.CatalystBat.active then
                _G.CatalystStopBat()
            else
                if _G._7upStartZombieBatAimbot then
                    pcall(_G._7upStartZombieBatAimbot)
                end
            end
        end
    else
        if _G.CatalystBat.active then
            _G.CatalystStopBat()
        else
            if State.batAimbotZombie and _G._7upStopZombieBatAimbot then
                pcall(_G._7upStopZombieBatAimbot)
            end
            _G.CatalystStartBat()
        end
    end
end

local BAT_COUNTER_SLAP_LIST = {"Bat", "BaseballBat", "Club", "Stick"}

local function findBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end

local function swingBatForCounter(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if not bat or not char then return end
    if bat.Parent ~= char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end
        task.wait(0.03)
    end
    for _ = 1, 3 do
        pcall(function() bat:Activate() end)
        local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildWhichIsA("RemoteEvent", true)
        if remote and remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer() end)
        end
        task.wait(0.06)
    end
end

local setInstaGrab

local _isStealingAttr = false
pcall(function()
    task.spawn(function()
        task.wait(0.5)
        _isStealingAttr = (LP:GetAttribute("Stealing") == true)
    end)
end)

local function isPlayerStealing()
    return _isStealingAttr or (LP:GetAttribute("Stealing") == true)
end

local _pausedBySteal = {
    autoLeft = false,
    autoRight = false,
    autoBat = false,
}
pcall(function()
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        local stealing = (LP:GetAttribute("Stealing") == true)
        _isStealingAttr = stealing
        if stealing then
            if State.autoLeftEnabled or (Conns and Conns.autoLeft) then
                _pausedBySteal.autoLeft = true
                pcall(function()
                    if Conns and Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
                end)
            end
            if State.autoRightEnabled or (Conns and Conns.autoRight) then
                _pausedBySteal.autoRight = true
                pcall(function()
                    if Conns and Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
                end)
            end
            if _G.CatalystBat.active then
                _pausedBySteal.autoBat = true
                _G.CatalystStopBat()
            end
        else
            task.defer(function()
                task.wait(0.1)
                if isPlayerStealing() then return end
                if (_pausedBySteal.autoLeft or State.autoLeftEnabled) and State.autoLeftEnabled then
                    _pausedBySteal.autoLeft = false
                    pcall(function()
                        local fn = _G._startAutoLeft or startAutoLeft
                        if fn then fn() end
                    end)
                    pcall(function() if setAutoLeft then setAutoLeft(true) end end)
                    pcall(function() if setMB_AL then setMB_AL(true) end end)
                end
                if (_pausedBySteal.autoRight or State.autoRightEnabled) and State.autoRightEnabled then
                    _pausedBySteal.autoRight = false
                    pcall(function()
                        local fn = _G._startAutoRight or startAutoRight
                        if fn then fn() end
                    end)
                    pcall(function() if setAutoRight then setAutoRight(true) end end)
                    pcall(function() if setMB_AR then setMB_AR(true) end end)
                end
                if _pausedBySteal.autoBat then
                    _pausedBySteal.autoBat = false
                    if State.autoBatToggled then
                        _G.CatalystStartBat()
                    end
                end
            end)
        end
    end)
end)

local function getCurrentSpeed()
    if State.laggerLevel > 0 then
        if State.laggerLevel == 1 then
            return State.laggerSpeed1
        else
            return State.laggerSpeed2
        end
    else
        local useCarry = false
        if State.autoCarryEnabled then
            useCarry = isPlayerStealing()
        else
            useCarry = (State.speedType == "carry")
        end
        return useCarry and State.carrySpeed or State.normalSpeed
    end
end

local function getSpeedModeLabel()
    if (State.laggerLevel or 0) == 1 then return "lagger 1" end
    if (State.laggerLevel or 0) == 2 then return "lagger 2" end
    if State.speedType == "carry" then return "carry" end
    return "normal"
end

local function getAdjustedSpeed(visual)
    return tonumber(visual) or 0
end

local function getOrCreateSpeedVectorForce(root)
    if not root or not root.Parent then return nil end
    local att = root:FindFirstChild("SpeedAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "SpeedAttachment"
        att.Parent = root
    end
    local vf = root:FindFirstChild("SpeedVectorForce")
    if not vf then
        vf = Instance.new("VectorForce")
        vf.Name = "SpeedVectorForce"
        vf.Attachment0 = att
        vf.RelativeTo = Enum.ActuatorRelativeTo.World
        vf.ApplyAtCenterOfMass = true
        vf.Enabled = false
        vf.Force = Vector3.zero
        vf.Parent = root
    end
    return vf
end

local function clearSpeedVectorForce(root)
    if not root then return end
    local vf = root:FindFirstChild("SpeedVectorForce")
    if vf then
        vf.Force = Vector3.zero
        vf.Enabled = false
    end
end

local function getAutoMoveSpeed()
    return State.normalSpeed
end

local function getOrCreateLinearVelocity(root)
    if not root or not root.Parent then return nil end
    local att = root:FindFirstChild("RootAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "RootAttachment"
        att.Parent = root
    end
    local lv = root:FindFirstChild("KzLinearVelocity")
    if not lv then
        lv = Instance.new("LinearVelocity")
        lv.Name = "KzLinearVelocity"
        lv.Attachment0 = att
        lv.MaxForce = 1e9
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.ForceLimitsEnabled = false
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.Parent = root
    end
    return lv
end

local function setLinearVelocity(root, vel)
    if not root then return end
    pcall(function() clearSpeedVectorForce(root) end)
    pcall(function()
        local lv = root:FindFirstChild("KzLinearVelocity")
        if lv then lv.Enabled = false end
    end)
    root.AssemblyLinearVelocity = vel
end

local LOOK_POWER = 55
local LOOK_MAX_ANG_VEL = 12
local LOOK_DEADZONE = 0.08
local function lookAtWithLinearVelocity(root, targetPos, moveSpeed)
    if not root or not targetPos then return end
    local char = root.Parent
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local delta = targetPos - root.Position
    local flat = Vector3.new(delta.X, 0, delta.Z)
    if flat.Magnitude < 0.15 then
        root.AssemblyAngularVelocity = Vector3.new(0, root.AssemblyAngularVelocity.Y * 0.5, 0)
        return
    end
    local direction = flat.Unit
    if hum then hum.AutoRotate = false end

    local targetYaw = math.atan2(direction.X, direction.Z)
    local look = root.CFrame.LookVector
    local currentYaw = math.atan2(look.X, look.Z)

    local angleDiff = targetYaw - currentYaw
    if angleDiff > math.pi then angleDiff = angleDiff - (math.pi * 2) end
    if angleDiff < -math.pi then angleDiff = angleDiff + (math.pi * 2) end

    if math.abs(angleDiff) < LOOK_DEADZONE then
        local curY = root.AssemblyAngularVelocity.Y
        root.AssemblyAngularVelocity = Vector3.new(0, curY * 0.35, 0)
        return
    end

    local angVel = angleDiff * LOOK_POWER
    if angVel > LOOK_MAX_ANG_VEL then angVel = LOOK_MAX_ANG_VEL end
    if angVel < -LOOK_MAX_ANG_VEL then angVel = -LOOK_MAX_ANG_VEL end

    local blended = root.AssemblyAngularVelocity.Y * 0.25 + angVel * 0.75
    root.AssemblyAngularVelocity = Vector3.new(0, blended, 0)
end

local function clearLookRotation(root)
    if not root then return end
    root.AssemblyAngularVelocity = Vector3.zero
    local hum = root.Parent and root.Parent:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

local function setLinearVelocityXZ(root, x, z)
    if not root then return end
    pcall(function() clearSpeedVectorForce(root) end)
    local lv = getOrCreateLinearVelocity(root)
    if not lv then
        local curY = root.AssemblyLinearVelocity.Y
        root.AssemblyLinearVelocity = Vector3.new(x, curY, z)
        return
    end
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.MaxForce = 1e9
    lv.ForceLimitsEnabled = false
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    lv.PlaneVelocity = Vector2.new(x, z)
    lv.Enabled = true
end

local function clearLinearVelocity(root)
    if not root then return end
    local lv = root:FindFirstChild("KzLinearVelocity")
    if lv then
        pcall(function()
            lv.Enabled = false
            lv.VectorVelocity = Vector3.zero
            if lv.VelocityConstraintMode == Enum.VelocityConstraintMode.Plane then
                lv.PlaneVelocity = Vector2.zero
            end
        end)
    end
end

local function hardStopMovement(root, hum)
    if root then
        pcall(function() clearLinearVelocity(root) end)
        pcall(function() clearSpeedVectorForce(root) end)
        pcall(function()
            -- NO tocar AssemblyLinearVelocity aquí: rompe anti-bat externos y el salto
            if not State.spinEnabled then
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
    if hum then
        pcall(function()
            if not (_G.CatalystBat and _G.CatalystBat.active) and not State.spinEnabled then
                hum.AutoRotate = true
            end
        end)
    end
    State.lastMoveDir = Vector3.zero
end

-- Solo ragdoll REAL. FallingDown/Physics solos = salto o anti-bat externo
local function isRagdolledState(hum)
    if not hum then return false end
    if hum.Health <= 0 then return true end
    if hum.PlatformStand == true then return true end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Ragdoll then return true end
    -- Physics solo cuenta si también hay PlatformStand (anti-bat usa Physics un frame)
    return false
end

setFloat = function() end
State.dropEnabled = false
local dropConns = {}
local _dropAutoOffToken = 0

function toggleDropGlitch(state)
    State.dropEnabled = state
    pcall(function() SetSetting("dropEnabled", state) end)
    if state then
        if #dropConns == 0 then
            local _dropColAcc = 0
            local colConn = RunService.Heartbeat:Connect(function(dt)
                if not State.dropEnabled then return end
                _dropColAcc = _dropColAcc + (dt or 0.016)
                if _dropColAcc < 0.15 then return end
                _dropColAcc = 0
                for _, p in ipairs(getPlayersCached()) do
                    if p ~= LP and p.Character then
                        for _, part in ipairs(p.Character:GetChildren()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end
            end)
            table.insert(dropConns, colConn)

            task.spawn(function()
                while State.dropEnabled do
                    RunService.Heartbeat:Wait()
                    local c = LP.Character
                    local root = c and c:FindFirstChild("HumanoidRootPart")
                    if root then
                    local vel = root.Velocity
                    root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                    RunService.RenderStepped:Wait()
                    if root and root.Parent then root.Velocity = vel end
                    RunService.Stepped:Wait()
                    if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
                    end
                end
            end)
        end
    else
        for _, c in ipairs(dropConns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        dropConns = {}
        for _, p in ipairs(getPlayersCached()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z) end
    end
end

function runDropBrainrot()
    if State.dropEnabled then
        toggleDropGlitch(false)
        if setMB_BR then setMB_BR(false) end
        if dropRowSetters then
            for _, fn in ipairs(dropRowSetters) do pcall(fn, false) end
        end
        return
    end

    toggleDropGlitch(true)
    if setMB_BR then setMB_BR(true) end
    if dropRowSetters then
        for _, fn in ipairs(dropRowSetters) do pcall(fn, true) end
    end

    _dropAutoOffToken = _dropAutoOffToken + 1
    local token = _dropAutoOffToken
    task.delay(0.18, function()
        if token ~= _dropAutoOffToken then return end
        toggleDropGlitch(false)
        if setMB_BR then setMB_BR(false) end
        if dropRowSetters then
            for _, fn in ipairs(dropRowSetters) do pcall(fn, false) end
        end
    end)
end

function syncDropButtons()
end

local POS = {
    L1 = Vector3.new(-476.48,-6.28,92.73), L2 = Vector3.new(-483.12,-4.95,94.80),
    R1 = Vector3.new(-476.16,-6.52,25.62), R2 = Vector3.new(-483.04,-5.09,23.14),
}
local AP_L_FACE = Vector3.new(-482.25,-4.96,92.09)
local AP_R_FACE = Vector3.new(-482.06,-6.93,35.47)

local Conns = { antiRag=nil, autoLeft=nil, autoRight=nil, anchor={}, float=nil, batCounter=nil, fpsBoostMonitor=nil, nukeMonitor=nil, nukeHeartbeat=nil }
local h, hrp, speedLbl
local setMB_AL, setMB_AR, setMB_AB, setMB_CS, setMB_BR, setMB_TD
local dropRowSetters = {}
local floatingBtnRefs = {}
local mbButtonFrames = {}
local mbGroup, QW, QH
local setAutoBat, setAutoLeft, setAutoRight
local modeValLbl, normalBox, carryBox, lagger1Box, lagger2Box, progressRadLbl

local setL1, setL2

local stretchRezConn = nil
local function getStretchFov()
    return math.clamp(tonumber(State.stretchFov) or 120, 70, 120)
end
function enableStretchRez()
    State.stretchRezEnabled = true
    local fov = getStretchFov()
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = fov end
    if stretchRezConn then stretchRezConn:Disconnect() end
    local acc = 0
    stretchRezConn = RunService.Heartbeat:Connect(function(dt)
        if not State.stretchRezEnabled then return end
        acc = acc + (dt or 0.016)
        if acc < 0.2 then return end
        acc = 0
        local cam = workspace.CurrentCamera
        if cam then cam.FieldOfView = getStretchFov() end
    end)
end
function disableStretchRez()
    State.stretchRezEnabled = false
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView = 70 end
end

local SKY_THEMES = {
    {name="Midnight",   dot=Color3.fromRGB(70,80,140),  lt={Brightness=0.55,ClockTime=0.8,Ambient=Color3.fromRGB(40,45,70),OutdoorAmbient=Color3.fromRGB(35,40,65),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.02,Contrast=0.12,Saturation=0.1,TintColor=Color3.fromRGB(200,205,255)}, atm={Density=0.18,Color=Color3.fromRGB(60,70,110),Decay=Color3.fromRGB(35,40,70),Offset=0.1,Glare=0.05,Haze=0.6}},
    {name="Violet",     dot=Color3.fromRGB(255, 255, 255), lt={Brightness=0.85,ClockTime=20,Ambient=Color3.fromRGB(80,40,120),OutdoorAmbient=Color3.fromRGB(70,35,110),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.04,Contrast=0.15,Saturation=0.45,TintColor=Color3.fromRGB(220,180,255)}, atm={Density=0.22,Color=Color3.fromRGB(255, 255, 255),Decay=Color3.fromRGB(70,30,120),Offset=0.12,Glare=0.12,Haze=1.0}},
    {name="Ocean",      dot=Color3.fromRGB(60,160,255), lt={Brightness=1.8,ClockTime=14,Ambient=Color3.fromRGB(90,140,200),OutdoorAmbient=Color3.fromRGB(100,150,210),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.06,Contrast=0.1,Saturation=0.35,TintColor=Color3.fromRGB(170,210,255)}, atm={Density=0.16,Color=Color3.fromRGB(70,140,220),Decay=Color3.fromRGB(40,90,170),Offset=0.08,Glare=0.25,Haze=1.2}},
    {name="Crimson",    dot=Color3.fromRGB(255,70,80),  lt={Brightness=0.7,ClockTime=21,Ambient=Color3.fromRGB(90,25,30),OutdoorAmbient=Color3.fromRGB(80,20,25),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.02,Contrast=0.18,Saturation=0.5,TintColor=Color3.fromRGB(255,180,175)}, atm={Density=0.28,Color=Color3.fromRGB(160,40,45),Decay=Color3.fromRGB(100,20,25),Offset=0.15,Glare=0.08,Haze=1.5}},
    {name="Sunset",     dot=Color3.fromRGB(255,150,60), lt={Brightness=1.6,ClockTime=17.8,Ambient=Color3.fromRGB(180,100,50),OutdoorAmbient=Color3.fromRGB(200,110,55),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.05,Contrast=0.14,Saturation=0.45,TintColor=Color3.fromRGB(255,220,170)}, atm={Density=0.24,Color=Color3.fromRGB(230,120,50),Decay=Color3.fromRGB(170,70,30),Offset=0.18,Glare=0.28,Haze=2.0}},
    {name="Forest",     dot=Color3.fromRGB(60,200,110), lt={Brightness=1.1,ClockTime=15,Ambient=Color3.fromRGB(45,90,60),OutdoorAmbient=Color3.fromRGB(40,85,55),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.04,Contrast=0.12,Saturation=0.35,TintColor=Color3.fromRGB(180,255,200)}, atm={Density=0.2,Color=Color3.fromRGB(50,120,70),Decay=Color3.fromRGB(30,80,45),Offset=0.1,Glare=0.08,Haze=1.0}},
    {name="Void",       dot=Color3.fromRGB(120,130,180),lt={Brightness=0.5,ClockTime=2,Ambient=Color3.fromRGB(30,35,55),OutdoorAmbient=Color3.fromRGB(25,30,50),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.05,Contrast=0.16,Saturation=-0.05,TintColor=Color3.fromRGB(200,205,240)}, atm={Density=0.12,Color=Color3.fromRGB(40,45,75),Decay=Color3.fromRGB(25,30,50),Offset=0.06,Glare=0.05,Haze=0.4}},
    {name="Neon",       dot=Color3.fromRGB(100,120,255),lt={Brightness=0.9,ClockTime=21,Ambient=Color3.fromRGB(50,60,120),OutdoorAmbient=Color3.fromRGB(45,55,110),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.06,Contrast=0.16,Saturation=0.5,TintColor=Color3.fromRGB(180,190,255)}, atm={Density=0.18,Color=Color3.fromRGB(255, 255, 255),Decay=Color3.fromRGB(40,50,140),Offset=0.1,Glare=0.15,Haze=0.9}},
    {name="Galaxy",     dot=Color3.fromRGB(190,120,255),lt={Brightness=1.2,ClockTime=19.5,Ambient=Color3.fromRGB(90,60,140),OutdoorAmbient=Color3.fromRGB(80,50,130),FogEnd=9e9,GlobalShadows=true}, cc={Brightness=0.06,Contrast=0.14,Saturation=0.4,TintColor=Color3.fromRGB(230,200,255)}, atm={Density=0.2,Color=Color3.fromRGB(255, 255, 255),Decay=Color3.fromRGB(90,50,150),Offset=0.1,Glare=0.2,Haze=1.1}},
}

function applyFPSBoost()
    if not State.fpsBoostEnabled then return end

    pcall(function() setfpscap(1e9) end)
    pcall(function() sethiddenproperty(game, "RenderFidelity", Enum.RenderFidelity.Performance) end)
    pcall(function() sethiddenproperty(game, "RenderQuality", 0) end)
    pcall(function() sethiddenproperty(game, "TextureQuality", Enum.TextureQuality.Performance) end)

    pcall(function() sethiddenproperty(game:GetService("Lighting"), "GlobalShadows", false) end)

    local Lighting = game:GetService("Lighting")
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect") then
            v:Destroy()
        end
    end

    pcall(function() sethiddenproperty(Lighting, "Technology", Enum.Technology.Legacy) end)

    Lighting.FogStart = 9e9
    Lighting.FogEnd = 9e9

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        pcall(function() sethiddenproperty(terrain, "Decoration", false) end)
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        for _, dec in pairs(terrain:GetDescendants()) do
            if dec:IsA("Decal") or dec:IsA("Texture") or dec:IsA("TerrainDetail") then
                dec:Destroy()
            end
        end
    end

    local function optimizePart(part)
        pcall(function()
            if part:IsA("BasePart") then
                part.CastShadow = false
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0
                if part:IsA("MeshPart") then
                    part.RenderFidelity = Enum.RenderFidelity.Performance
                    part.DoubleSided = false
                end
            elseif part:IsA("Decal") or part:IsA("Texture") then
                part.Transparency = 1
            elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") or part:IsA("Fire") or
                   part:IsA("Smoke") or part:IsA("Sparkles") or part:IsA("Explosion") then
                part.Enabled = false
            elseif part:IsA("Clothing") or part:IsA("Shirt") or part:IsA("Pants") then
                part:Destroy()
            elseif part:IsA("SpecialMesh") then
                part.TextureId = ""
            elseif part:IsA("SurfaceAppearance") then
                part:Destroy()
            end
        end)
    end

    task.spawn(function()
        local list = workspace:GetDescendants()
        local i = 1
        while i <= #list do
            local jmax = math.min(i + 80, #list)
            for j = i, jmax do
                pcall(optimizePart, list[j])
            end
            i = jmax + 1
            task.wait()
        end
        for _, light in pairs(workspace:GetDescendants()) do
            if light:IsA("Light") then
                pcall(function()
                    light.Shadows = false
                    if light:IsA("PointLight") or light:IsA("SpotLight") then
                        light.Enabled = false
                    end
                end)
            end
        end
    end)

    local function stripCharacter(char)
        if not char then return end

        if char == LP.Character then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    if part:IsA("MeshPart") then
                        part.RenderFidelity = Enum.RenderFidelity.Performance
                    end
                end
            end
            return
        end

        for _, acc in pairs(char:GetChildren()) do
            if acc:IsA("Accessory") or acc:IsA("Clothing") then
                acc:Destroy()
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local shirt = hum:FindFirstChild("Shirt")
            if shirt then shirt:Destroy() end
            local pants = hum:FindFirstChild("Pants")
            if pants then pants:Destroy() end
            local tshirt = hum:FindFirstChild("TShirt")
            if tshirt then tshirt:Destroy() end
            local bodyColors = char:FindFirstChild("BodyColors")
            if bodyColors then bodyColors:Destroy() end
        end

        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            hum2.AutoRotate = false
            hum2.PlatformStand = true
            hum2.WalkSpeed = 0
            hum2.JumpPower = 0
            local animate = char:FindFirstChild("Animate")
            if animate then animate:Destroy() end
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("LocalScript") or child:IsA("Script") then
                    if child.Name:lower():find("anim") or child.Name:lower():find("move") then
                        child.Disabled = true
                    end
                end
            end
        end

        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CastShadow = false
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0
                if part:IsA("MeshPart") then
                    part.RenderFidelity = Enum.RenderFidelity.Performance
                end
            end
        end
    end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            if char then
                stripCharacter(char)
            end
        end
    end

    if Conns.fpsBoostMonitor then Conns.fpsBoostMonitor:Disconnect() end
    Conns.fpsBoostMonitor = game:GetService("Players").PlayerAdded:Connect(function(plr)
        if plr == LP then return end
        plr.CharacterAdded:Connect(function(char)
            if State.fpsBoostEnabled then
                stripCharacter(char)
            end
        end)
        if plr.Character and State.fpsBoostEnabled then
            stripCharacter(plr.Character)
        end
    end)

    local newObjectConn
    newObjectConn = workspace.DescendantAdded:Connect(function(obj)
        if not State.fpsBoostEnabled then
            newObjectConn:Disconnect()
            return
        end
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("Light") then
            obj.Shadows = false
        elseif obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            if obj:IsA("MeshPart") then
                obj.RenderFidelity = Enum.RenderFidelity.Performance
            end
        end
    end)
end

local function isLocalCharPart(obj)
    local char = LP.Character
    if not char then return false end
    return obj == char or obj:IsDescendantOf(char)
end

local function isAnyPlayerChar(obj)
    for _, plr in pairs(Players:GetPlayers()) do
        local ch = plr.Character
        if ch and (obj == ch or obj:IsDescendantOf(ch)) then
            return true
        end
    end
    return false
end

local function isNukeUnsafe(obj)
    if not obj or not obj.Parent then return true end
    if isAnyPlayerChar(obj) then return true end
    local char = LP.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and (obj == t or obj:IsDescendantOf(t)) then
                return true
            end
        end
    end
    if obj:IsA("Constraint") or obj:IsA("Weld") or obj:IsA("WeldConstraint")
        or obj:IsA("Motor6D") or obj:IsA("Attachment")
        or obj:IsA("BodyMover") or obj:IsA("LinearVelocity")
        or obj:IsA("AlignPosition") or obj:IsA("AlignOrientation")
        or obj:IsA("VectorForce") or obj:IsA("AngularVelocity")
        or obj:IsA("Humanoid") or obj:IsA("ControllerManager") then
        return true
    end
    return false
end

function applyNuke()
    if _G.__CATALYST_BOOTING then
        task.delay(2.0, function()
            if (State.nukeLevel or 0) > 0 and not _G.__CATALYST_BOOTING then
                pcall(applyNuke)
            elseif (State.nukeLevel or 0) > 0 then
                task.delay(1.5, function() pcall(applyNuke) end)
            end
        end)
        return
    end
    local level = State.nukeLevel or 0
    if level <= 0 then
        State.nukeEnabled = false
        return
    end
    State.nukeEnabled = true

    pcall(function() setfpscap(240) end)
    pcall(function()
        if level >= 3 then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        elseif level >= 2 then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level04
        else
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level08
        end
    end)
    pcall(function() sethiddenproperty(game, "RenderFidelity", Enum.RenderFidelity.Performance) end)
    if level >= 2 then
        pcall(function() sethiddenproperty(game, "TextureQuality", Enum.TextureQuality.Performance) end)
    end

    local Lighting = game:GetService("Lighting")
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogStart = 0
        Lighting.FogEnd = 9e9
        Lighting.Brightness = level >= 2 and 1 or 2
        Lighting.Ambient = Color3.fromRGB(140, 140, 140)
        Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
        pcall(function() Lighting.Technology = Enum.Technology.Legacy end)
    end)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
            or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect")
            or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Clouds") or v:IsA("PostEffect") then
            pcall(function() v:Destroy() end)
        end
    end

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        pcall(function() sethiddenproperty(terrain, "Decoration", false) end)
        pcall(function()
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
        end)
    end

    local function nukeObject(obj)
        if isNukeUnsafe(obj) then return end
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                obj.Enabled = false
                if level >= 2 then pcall(function() obj.Rate = 0 end) end
                return
            end
            if obj:IsA("Light") then
                obj.Enabled = false
                return
            end
            if level < 2 then return end
            if obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            elseif obj:IsA("BasePart") then
                obj.CastShadow = false
                if level >= 3 then
                    obj.Reflectance = 0
                    obj.Material = Enum.Material.SmoothPlastic
                end
            end
            if level < 3 then return end
            if obj:IsA("SurfaceAppearance") then
                pcall(function() obj:Destroy() end)
            elseif obj:IsA("SpecialMesh") then
                obj.TextureId = ""
            elseif obj:IsA("MeshPart") then
                obj.TextureID = ""
                obj.CastShadow = false
                pcall(function() obj.RenderFidelity = Enum.RenderFidelity.Performance end)
            end
        end)
    end

    -- lotes para no congelar el frame (mejor FPS al activar)
    task.spawn(function()
        local list = workspace:GetDescendants()
        local i = 1
        while i <= #list do
            local batchEnd = math.min(i + 140, #list)
            for j = i, batchEnd do
                nukeObject(list[j])
            end
            i = batchEnd + 1
            if i <= #list then task.wait() end
        end
    end)

    if level >= 2 then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                for _, acc in pairs(plr.Character:GetChildren()) do
                    if acc:IsA("Accessory") then
                        pcall(function()
                            for _, d in ipairs(acc:GetDescendants()) do
                                if d:IsA("BasePart") then
                                    d.Transparency = 1
                                    d.CanCollide = false
                                elseif d:IsA("Decal") or d:IsA("Texture") then
                                    d.Transparency = 1
                                elseif d:IsA("ParticleEmitter") then
                                    d.Enabled = false
                                end
                            end
                        end)
                    end
                end
            end
        end
    end

    if Conns.nukeMonitor then Conns.nukeMonitor:Disconnect() end
    Conns.nukeMonitor = workspace.DescendantAdded:Connect(function(obj)
        if not State.nukeEnabled or (State.nukeLevel or 0) <= 0 then return end
        task.defer(function()
            if not State.nukeEnabled then return end
            if isNukeUnsafe(obj) then return end
            nukeObject(obj)
        end)
    end)

    if Conns.nukeHeartbeat then Conns.nukeHeartbeat:Disconnect(); Conns.nukeHeartbeat = nil end
end

function setNukeLevel(level)
    level = math.clamp(tonumber(level) or 0, 0, 3)
    State.nukeLevel = level
    State.nukeEnabled = level > 0
    SetSetting("nukeLevel", level)
    SetSetting("nukeEnabled", level > 0)
    if level > 0 then
        applyNuke()
        -- re-aplicar cada 8s para que no se “apague” solo
        if Conns.nukeHeartbeat then
            pcall(function() Conns.nukeHeartbeat:Disconnect() end)
            Conns.nukeHeartbeat = nil
        end
        local acc = 0
        Conns.nukeHeartbeat = RunService.Heartbeat:Connect(function(dt)
            if not State.nukeEnabled or (State.nukeLevel or 0) <= 0 then return end
            acc = acc + (dt or 0.016)
            if acc < 8 then return end
            acc = 0
            pcall(applyNuke)
        end)
    else
        disableNuke()
    end
end

function disableNuke()
    State.nukeEnabled = false
    State.nukeLevel = 0
    if Conns.nukeMonitor then Conns.nukeMonitor:Disconnect(); Conns.nukeMonitor = nil end
    if Conns.nukeHeartbeat then Conns.nukeHeartbeat:Disconnect(); Conns.nukeHeartbeat = nil end
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)
end

function saveOriginalLighting()
    if _skyOriginals then return end
    local L = game:GetService("Lighting")
    _skyOriginals = {Brightness=L.Brightness, Ambient=L.Ambient, OutdoorAmbient=L.OutdoorAmbient, TimeOfDay=L.TimeOfDay, ClockTime=L.ClockTime, FogEnd=L.FogEnd, GlobalShadows=L.GlobalShadows}
end
function clearAllSkyEffects()
    local L = game:GetService("Lighting")
    for _,v in pairs(L:GetChildren()) do
        if v.Name ~= "CatalystDarkCC" and v.Name ~= "CatalystDarkBloom" then
            if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") then
                v:Destroy()
            end
        end
    end
end
function applySky(idx)
    idx = math.clamp(idx,1,#SKY_THEMES)
    local theme = SKY_THEMES[idx]
    pcall(function()
        local L = game:GetService("Lighting")
        saveOriginalLighting()
        clearAllSkyEffects()
        local lt=theme.lt; L.Brightness=lt.Brightness; L.ClockTime=lt.ClockTime; L.Ambient=lt.Ambient; L.OutdoorAmbient=lt.OutdoorAmbient; L.FogEnd=lt.FogEnd; L.GlobalShadows=lt.GlobalShadows
        local cc=Instance.new("ColorCorrectionEffect",L); cc.Name="NovaSkyCC"; cc.Brightness=theme.cc.Brightness; cc.Contrast=theme.cc.Contrast; cc.Saturation=theme.cc.Saturation; cc.TintColor=theme.cc.TintColor
        local atm=Instance.new("Atmosphere",L); atm.Name="NovaSkyAtm"; atm.Density=theme.atm.Density; atm.Color=theme.atm.Color; atm.Decay=theme.atm.Decay; atm.Offset=theme.atm.Offset; atm.Glare=theme.atm.Glare; atm.Haze=theme.atm.Haze
        if State.darkModeEnabled and applyDarkMode then
            pcall(applyDarkMode)
        end
    end)
end
function enableSky(idx)
    State.skyEnabled = true; applySky(idx or State.skyColorIndex)
    SetSetting("skyEnabled",true); SetSetting("skyColorIndex",State.skyColorIndex)
end
function disableSky()
    State.skyEnabled = false
    pcall(function()
        local L=game:GetService("Lighting"); clearAllSkyEffects()
        if _skyOriginals then L.Brightness=_skyOriginals.Brightness; L.Ambient=_skyOriginals.Ambient; L.OutdoorAmbient=_skyOriginals.OutdoorAmbient; L.TimeOfDay=_skyOriginals.TimeOfDay; L.ClockTime=_skyOriginals.ClockTime; L.FogEnd=_skyOriginals.FogEnd; L.GlobalShadows=_skyOriginals.GlobalShadows end
    end)
    SetSetting("skyEnabled",false)
end

local waypointMarker = nil; local waypointConn = nil
function getWaypointTarget()
    if State.autoLeftEnabled then
        if State.autoLeftPhase == 1 then return POS.L1 end
        if State.autoLeftPhase == 2 then return POS.L2 end
    end
    if State.autoRightEnabled then
        if State.autoRightPhase == 1 then return POS.R1 end
        if State.autoRightPhase == 2 then return POS.R2 end
    end
    return nil
end
function createWaypointMarker()
    if waypointMarker then return end
    local marker = Instance.new("Part"); marker.Name="KzWaypoint"; marker.Size=Vector3.new(2.5,2.5,2.5); marker.Shape=Enum.PartType.Ball; marker.Anchored=true; marker.CanCollide=false; marker.CastShadow=false; marker.Material=Enum.Material.Neon; marker.Color = Color3.fromRGB(255, 255, 255)
    marker.Transparency=0.15; marker.Parent=workspace
    local bb=Instance.new("BillboardGui",marker); bb.Size=UDim2.new(0,90,0,22); bb.StudsOffset=Vector3.new(0,2.8,0); bb.AlwaysOnTop=true; bb.Adornee=marker
    local label=Instance.new("TextLabel",bb); label.Size=UDim2.new(1,0,1,0); label.BackgroundTransparency=1; label.Text="WAYPOINT"; label.TextColor3 = Color3.fromRGB(180, 180, 180); label.TextStrokeColor3=Color3.fromRGB(0,0,0); label.TextStrokeTransparency=0.4; label.Font=Enum.Font.GothamBold; label.TextSize=13; label.TextScaled=true
    waypointMarker=marker
end
function removeWaypointMarker() if waypointMarker then pcall(function() waypointMarker:Destroy() end); waypointMarker=nil end end
function startWaypointESP()
    if waypointConn then waypointConn:Disconnect() end
    createWaypointMarker()
    local _wpAcc = 0
    waypointConn = RunService.Heartbeat:Connect(function(dt)
        if not State.waypointESPEnabled then removeWaypointMarker(); if waypointConn then waypointConn:Disconnect(); waypointConn=nil end; return end
        _wpAcc = _wpAcc + (dt or 0.016)
        if _wpAcc < 0.1 then return end
        _wpAcc = 0
        local target = getWaypointTarget()
        if target then
            if not waypointMarker then createWaypointMarker() end
            waypointMarker.Position = target; waypointMarker.Transparency = 0.15
        else
            if waypointMarker then waypointMarker.Transparency = 1 end
        end
    end)
end
function stopWaypointESP() State.waypointESPEnabled=false; if waypointConn then waypointConn:Disconnect(); waypointConn=nil end; removeWaypointMarker() end

local _respawnLock = false
local function fullMovementCleanup(char)
    _respawnLock = true
    pcall(function()
        if Conns and Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft = nil end
        if Conns and Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight = nil end
    end)
    State.autoLeftPhase = 1
    State.autoRightPhase = 1
    _pausedBySteal.autoLeft = false
    _pausedBySteal.autoRight = false
    local c = char or LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if root then
            pcall(function() clearLinearVelocity(root) end)
            pcall(function() clearSpeedVectorForce(root) end)
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Velocity = Vector3.zero
            end)
            for _, name in ipairs({"KzLinearVelocity", "SpeedVectorForce", "InfJumpVelocity", "SpeedAttachment", "RootAttachment", "InfJumpAttachment"}) do
                local obj = root:FindFirstChild(name)
                if obj then pcall(function() obj:Destroy() end) end
            end
        end
        if hum2 then
            pcall(function()
                hum2:Move(Vector3.zero, false)
                hum2.AutoRotate = true
                hum2.PlatformStand = false
            end)
        end
    end
    task.delay(0.4, function() _respawnLock = false end)
end

local function startAutoLeft()
    if _respawnLock then return end
    if isPlayerStealing() then
        _pausedBySteal.autoLeft = true
        return
    end

    if State.bypassToggled then
        toggleBypass(false)
    end

    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
        if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
    end

    local c0 = LP.Character
    local h0 = c0 and c0:FindFirstChildOfClass("Humanoid")
    if not (c0 and h0 and h0.Health > 0) then return end
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end
    State.autoLeftPhase = 1
    Conns.autoLeft = RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        if _respawnLock then return end
        if isPlayerStealing() then
            _pausedBySteal.autoLeft = true
            if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
            return
        end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd = getAutoMoveSpeed()
        pcall(function() clearSpeedVectorForce(root) end)
        local function goXZ(tgtPos, isFinal)
            local d = Vector3.new(tgtPos.X - root.Position.X, 0, tgtPos.Z - root.Position.Z)
            local dist = d.Magnitude
            if dist < 0.05 then return 0 end
            local mv = d.Unit
            local useSpd = spd
            if isFinal and dist < 3 then
                useSpd = math.clamp(math.max(dist * 10, 10), 10, useSpd)
            end
            hum2:Move(mv, false)
            setLinearVelocityXZ(root, mv.X * useSpd, mv.Z * useSpd)
            return dist
        end
        if State.autoLeftPhase == 1 then
            local tgt = POS.L1
            local dist = (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude
            if dist < 1.5 then
                State.autoLeftPhase = 2
                goXZ(POS.L2, true)
            else
                goXZ(POS.L1, false)
            end
        else
            local tgt = POS.L2
            local dist = (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude
            if dist < 1.25 then
                hum2:Move(Vector3.zero,false)
                clearLinearVelocity(root)
                if (AP_L_FACE-root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, Vector3.new(AP_L_FACE.X,root.Position.Y,AP_L_FACE.Z))
                end
                State.autoLeftEnabled = false
                Conns.autoLeft:Disconnect(); Conns.autoLeft=nil
                State.autoLeftPhase=1
                if setAutoLeft then setAutoLeft(false) end
                if setMB_AL then setMB_AL(false) end
                pcall(function() if _G.CatalystUpdateAutoRouteHUD then _G.CatalystUpdateAutoRouteHUD() end end)
                return
            end
            goXZ(POS.L2, true)
        end
    end)
end

local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end
    State.autoLeftPhase = 1
    local char = LP.Character
    if char then
        hardStopMovement(char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid"))
    end
    pcall(function() if _G.CatalystUpdateAutoRouteHUD then _G.CatalystUpdateAutoRouteHUD() end end)
end

local function startAutoRight()
    if _respawnLock then return end
    if isPlayerStealing() then
        _pausedBySteal.autoRight = true
        return
    end

    if State.bypassToggled then
        toggleBypass(false)
    end

    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
        if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
    end

    local c0 = LP.Character
    local h0 = c0 and c0:FindFirstChildOfClass("Humanoid")
    if not (c0 and h0 and h0.Health > 0) then return end
    if Conns.autoRight then Conns.autoRight:Disconnect() end
    State.autoRightPhase = 1
    Conns.autoRight = RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        if _respawnLock then return end
        if isPlayerStealing() then
            _pausedBySteal.autoRight = true
            if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
            return
        end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum2 then return end
        local spd = getAutoMoveSpeed()
        pcall(function() clearSpeedVectorForce(root) end)
        local function goXZ(tgtPos, isFinal)
            local d = Vector3.new(tgtPos.X - root.Position.X, 0, tgtPos.Z - root.Position.Z)
            local dist = d.Magnitude
            if dist < 0.05 then return 0 end
            local mv = d.Unit
            local useSpd = spd
            if isFinal and dist < 3 then
                useSpd = math.clamp(math.max(dist * 10, 10), 10, useSpd)
            end
            hum2:Move(mv, false)
            setLinearVelocityXZ(root, mv.X * useSpd, mv.Z * useSpd)
            return dist
        end
        if State.autoRightPhase == 1 then
            local tgt = POS.R1
            local dist = (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude
            if dist < 1.5 then
                State.autoRightPhase = 2
                goXZ(POS.R2, true)
            else
                goXZ(POS.R1, false)
            end
        else
            local tgt = POS.R2
            if (Vector3.new(tgt.X,root.Position.Y,tgt.Z)-root.Position).Magnitude < 1.25 then
                hum2:Move(Vector3.zero,false)
                clearLinearVelocity(root)
                if (AP_R_FACE-root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, Vector3.new(AP_R_FACE.X,root.Position.Y,AP_R_FACE.Z))
                end
                State.autoRightEnabled = false
                Conns.autoRight:Disconnect(); Conns.autoRight=nil
                State.autoRightPhase=1
                if setAutoRight then setAutoRight(false) end
                if setMB_AR then setMB_AR(false) end
                pcall(function() if _G.CatalystUpdateAutoRouteHUD then _G.CatalystUpdateAutoRouteHUD() end end)
                return
            end
            goXZ(POS.R2, true)
        end
    end)
end

local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end
    State.autoRightPhase = 1
    local char = LP.Character
    if char then
        hardStopMovement(char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid"))
    end
    pcall(function() if _G.CatalystUpdateAutoRouteHUD then _G.CatalystUpdateAutoRouteHUD() end end)
end

do
    local _arGui, _arPill, _arLbl, _arPulse
    local function ensureAutoRouteHUD()
        if _arGui and _arGui.Parent then return end
        local pg = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui", 5)
        if not pg then return end
        local old = pg:FindFirstChild("CatalystAutoRouteHUD")
        if old then old:Destroy() end
        _arGui = Instance.new("ScreenGui")
        _arGui.Name = "CatalystAutoRouteHUD"
        _arGui.ResetOnSpawn = false
        _arGui.IgnoreGuiInset = true
        _arGui.DisplayOrder = 80
        _arGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        _arGui.Parent = pg

        _arPill = Instance.new("Frame")
        _arPill.Name = "Pill"
        _arPill.Size = UDim2.new(0, 118, 0, 28)
        _arPill.Position = UDim2.new(0.5, -59, 0.12, 0)
        _arPill.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        _arPill.BackgroundTransparency = 0.08
        _arPill.BorderSizePixel = 0
        _arPill.Visible = false
        _arPill.ZIndex = 50
        _arPill.Parent = _arGui
        Instance.new("UICorner", _arPill).CornerRadius = UDim.new(1, 0)
        local st = Instance.new("UIStroke", _arPill)
        st.Color = ACCENT
        st.Thickness = 1.2
        st.Transparency = 0.25
        local stg = Instance.new("UIGradient", st)
        stg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(0.5, ACCENT),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
        })
        local bg = Instance.new("UIGradient", _arPill)
        bg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(28, 12, 42)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
        })
        bg.Rotation = 90

        _arLbl = Instance.new("TextLabel", _arPill)
        _arLbl.Size = UDim2.new(1, -8, 1, 0)
        _arLbl.Position = UDim2.new(0, 4, 0, 0)
        _arLbl.BackgroundTransparency = 1
        _arLbl.Text = "AUTO LEFT"
        _arLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        _arLbl.Font = Enum.Font.Gotham
        _arLbl.TextSize = 12
        _arLbl.ZIndex = 51

        local dot = Instance.new("Frame", _arPill)
        dot.Name = "Dot"
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0, 10, 0.5, -3)
        dot.BackgroundColor3 = ACCENT
        dot.BorderSizePixel = 0
        dot.ZIndex = 52
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        _arPulse = dot
    end

    function _G.CatalystUpdateAutoRouteHUD()
        pcall(ensureAutoRouteHUD)
        if not _arPill then return end
        local left = State.autoLeftEnabled == true
        local right = State.autoRightEnabled == true
        if left or right then
            _arPill.Visible = true
            if left then
                _arLbl.Text = "  ◀  AUTO LEFT"
                _arPill.Position = UDim2.new(0, 14, 0.14, 0)
            else
                _arLbl.Text = "AUTO RIGHT  ▶  "
                _arPill.Position = UDim2.new(1, -132, 0.14, 0)
            end
            if _arPulse then
                _arPulse.BackgroundColor3 = ACCENT
                pcall(function()
                    TweenService:Create(_arPulse, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                        BackgroundTransparency = 0.55
                    }):Play()
                end)
            end
        else
            _arPill.Visible = false
            if _arPulse then
                pcall(function() TweenService:Create(_arPulse, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play() end)
            end
        end
    end
end

_G._startAutoLeft = startAutoLeft
_G._startAutoRight = startAutoRight
_G._stopAutoLeft = stopAutoLeft
_G._stopAutoRight = stopAutoRight

if not _G.AutoLR_ResumeWatch then
    _G.AutoLR_ResumeWatch = true
    task.spawn(function()
        while true do
            task.wait(0.25)
            if _respawnLock or isPlayerStealing() then
            else
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not (char and hum and root and hum.Health > 0) then
                else
                    if State.autoLeftEnabled and not (Conns and Conns.autoLeft) then
                        pcall(function() local fn = _G._startAutoLeft or startAutoLeft; if fn then fn() end end)
                    end
                    if State.autoRightEnabled and not (Conns and Conns.autoRight) then
                        pcall(function() local fn = _G._startAutoRight or startAutoRight; if fn then fn() end end)
                    end
                end
            end
        end
    end)
end

function createAntiRagdollButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InternalAntiRagdoll"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false

    local success, _ = pcall(function()
        screenGui.Parent = CoreGui
    end)

    if not success then
        screenGui.Parent = LP:WaitForChild("PlayerGui")
    end

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 160, 0, 35)
    toggleButton.Position = UDim2.new(0, 10, 0, 50)
    toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.RobotoMono
    toggleButton.TextSize = 14
    toggleButton.Text = "ANTIRAGDOLL: OFF"
    toggleButton.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 4)
    uiCorner.Parent = toggleButton

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(255, 0, 0)
    uiStroke.Thickness = 1
    uiStroke.Transparency = 0.7
    uiStroke.Parent = toggleButton

    local dragging = false
    local dragStart, startPos = nil, nil
    toggleButton.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = toggleButton.Position
        end
    end)
    toggleButton.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            local factor = 1.0
            toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X * factor,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y * factor)
        end
    end)

    toggleButton.MouseButton1Click:Connect(function()
        if State.antiRagdollActiveVersion == 0 then
            setAntiRagdollVersion(1)
        else
            setAntiRagdollVersion(0)
        end
        local isOn = State.antiRagdollActiveVersion ~= 0
        toggleButton.Text = isOn and "ANTIRAGDOLL: ON" or "ANTIRAGDOLL: OFF"
        toggleButton.TextColor3 = isOn and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 255, 255)
        uiStroke.Color = isOn and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 0, 0)
    end)

    local isOn = State.antiRagdollActiveVersion ~= 0
    toggleButton.Text = isOn and "ANTIRAGDOLL: ON" or "ANTIRAGDOLL: OFF"
    toggleButton.TextColor3 = isOn and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 255, 255)
    uiStroke.Color = isOn and Color3.fromRGB(0, 255, 140) or Color3.fromRGB(255, 0, 0)
end

task.spawn(createAntiRagdollButton)

local setupMedusaCounter, stopMedusaCounter
function findMedusa()
    local char = LP.Character; if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and tool.Name:lower():find("medusa") then return tool end end
    local bp = LP:FindFirstChild("Backpack"); if bp then for _, tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and tool.Name:lower():find("medusa") then return tool end end end
    return nil
end
function useMedusaCounter()
    if State.medusaDebounce then return end
    if tick()-State.medusaLastUsed < 25 then return end
    local char = LP.Character; if not char then return end
    State.medusaDebounce = true
    local med = findMedusa()
    if not med then State.medusaDebounce=false; return end
    local bp = LP:FindFirstChild("Backpack")
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t ~= med then
            local n = t.Name:lower()
            if n:find("bat") or n:find("slap") then
                if bp then t.Parent = bp end
            end
        end
    end
    if med.Parent ~= char then
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) else med.Parent = char end
    end
    pcall(function() med:Activate() end)
    State.medusaLastUsed = tick()
    State.medusaDebounce = false
end
function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 and State.medusaCounterEnabled then useMedusaCounter() end
    end)
end
setupMedusaCounter = function(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end))
end

stopMedusaCounter = function() for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor={} end

-- Anti-Medusa ligero (cuando TE usan Medusa): no te traba, bajo costo
local _antiMedConn, _antiMedProp = nil, nil
local _antiMedAcc = 0
local function _cataAntiMedusaClear()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if root and root.Anchored then root.Anchored = false end
    if hum then
        if hum.PlatformStand then hum.PlatformStand = false end
        if hum.Sit then hum.Sit = false end
    end
    for _, name in ipairs({"Head", "Torso", "UpperTorso", "LowerTorso"}) do
        local p = char:FindFirstChild(name)
        if p and p:IsA("BasePart") and p.Anchored then
            p.Anchored = false
        end
    end
    if root then
        for _, obj in ipairs(root:GetChildren()) do
            if obj:IsA("AlignPosition") or obj:IsA("BodyPosition") or obj:IsA("BodyVelocity") then
                local n = string.lower(tostring(obj.Name or ""))
                if n:find("medusa") or n:find("freeze") or n:find("stone") or n:find("stun") or n:find("lock") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end

local function _cataStartAntiMedusaPassive()
    if _antiMedConn then return end
    _antiMedAcc = 0
    _antiMedConn = RunService.Heartbeat:Connect(function(dt)
        if _G._catalystShuttingDown or _G.__CATALYST_BOOTING then return end
        _antiMedAcc = _antiMedAcc + (dt or 0.016)
        if _antiMedAcc < 0.1 then return end
        _antiMedAcc = 0
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local frozen = root.Anchored or hum.PlatformStand
        if not frozen then
            local h = char:FindFirstChild("Head")
            local t = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if (h and h.Anchored) or (t and t.Anchored) then frozen = true end
        end
        if frozen then
            _cataAntiMedusaClear()
        end
    end)
    pcall(function()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            if _antiMedProp then pcall(function() _antiMedProp:Disconnect() end) end
            _antiMedProp = root:GetPropertyChangedSignal("Anchored"):Connect(function()
                if root.Anchored then _cataAntiMedusaClear() end
            end)
        end
    end)
end

pcall(_cataStartAntiMedusaPassive)
LP.CharacterAdded:Connect(function()
    task.defer(function()
        pcall(_cataStartAntiMedusaPassive)
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            if _antiMedProp then pcall(function() _antiMedProp:Disconnect() end) end
            _antiMedProp = root:GetPropertyChangedSignal("Anchored"):Connect(function()
                if root.Anchored then _cataAntiMedusaClear() end
            end)
        end
    end)
end)


function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(getPlayersCached()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function swingCurrentBat()
    if not State.autoSwingEnabled then return end
    if isPlayerStealing() then return end
    local bat = findBat()
    if bat and bat.Parent == LP.Character and bat:IsA("Tool") then
        pcall(function() bat:Activate() end)
    end
end

function startBatAimbot()
    _G.CatalystStartBat()
end

function stopBatAimbot()
    _G.CatalystStopBat()
end

function resetAutoBatMotion()
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        clearLinearVelocity(hrp)
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then hum.AutoRotate = true end
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char = LP.Character
        if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        local hrp2 = char:FindFirstChild("HumanoidRootPart")
        if not hum2 or not hrp2 then return end
        local st = hum2:GetState()
        local isRealRagdoll = hum2.PlatformStand == true
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
        if not isRealRagdoll then return end
        State.batCounterDebounce = true
        task.spawn(function()
            local bat = findBatForCounter()
            if bat then pcall(function() swingBatForCounter(bat, char) end) end
            task.wait(0.05)
            pcall(function()
                if hum2 and hum2.Parent then
                    hum2.PlatformStand = false
                    hum2.AutoRotate = true
                    local st2 = hum2:GetState()
                    if st2 == Enum.HumanoidStateType.Physics or st2 == Enum.HumanoidStateType.Ragdoll then
                        hum2:ChangeState(Enum.HumanoidStateType.GettingUp)
                        task.wait(0.05)
                        hum2:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
                if hrp2 and hrp2.Parent then
                    hrp2.AssemblyAngularVelocity = Vector3.zero
                end
            end)
            task.wait(0.45)
            State.batCounterDebounce = false
        end)
    end)
end

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    State.batCounterDebounce = false
end


local Anims = {
    idle1="rbxassetid://10921326949",
    idle2="rbxassetid://10921326949",
    walk="rbxassetid://10921326949",
    run="rbxassetid://616163682",
    jump="rbxassetid://109996626521204",
    fall="rbxassetid://94788218468396",
    climb="rbxassetid://656114359",
    swim="rbxassetid://656119721",
    swimidle="rbxassetid://656121397",
}

task.spawn(function() pcall(function() ContentProvider:PreloadAsync({Anims.idle1,Anims.idle2,Anims.walk,Anims.run,Anims.jump,Anims.fall,Anims.climb,Anims.swim,Anims.swimidle}) end) end)
local animHeartbeatConn, savedAnimate, originalAnims = nil, nil, nil
function isPackAnim(id) if not id then return false end; for _,v in pairs(Anims) do if v==id then return true end end; return false end
function saveOriginalAnims(char)
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids={idle1=g(animate.idle and animate.idle.Animation1),idle2=g(animate.idle and animate.idle.Animation2),walk=g(animate.walk and animate.walk.WalkAnim),run=g(animate.run and animate.run.RunAnim),jump=g(animate.jump and animate.jump.JumpAnim),fall=g(animate.fall and animate.fall.FallAnim),climb=g(animate.climb and animate.climb.ClimbAnim),swim=g(animate.swim and animate.swim.Swim),swimidle=g(animate.swimidle and animate.swimidle.SwimIdle)}
    if not isPackAnim(ids.walk) then originalAnims=ids end
end
function applyAnimPack(char)
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function s(obj,id) if obj then obj.AnimationId=id end end
    s(animate.idle and animate.idle.Animation1,Anims.idle1); s(animate.idle and animate.idle.Animation2,Anims.idle2); s(animate.walk and animate.walk.WalkAnim,Anims.walk); s(animate.run and animate.run.RunAnim,Anims.run); s(animate.jump and animate.jump.JumpAnim,Anims.jump); s(animate.fall and animate.fall.FallAnim,Anims.fall); s(animate.climb and animate.climb.ClimbAnim,Anims.climb); s(animate.swim and animate.swim.Swim,Anims.swim); s(animate.swimidle and animate.swimidle.SwimIdle,Anims.swimidle)
end
function restoreOriginalAnims(char)
    if not originalAnims then return end
    local animate=char:FindFirstChild("Animate"); if not animate then return end
    local function s(obj,id) if obj and id then obj.AnimationId=id end end
    s(animate.idle and animate.idle.Animation1,originalAnims.idle1); s(animate.idle and animate.idle.Animation2,originalAnims.idle2); s(animate.walk and animate.walk.WalkAnim,originalAnims.walk); s(animate.run and animate.run.RunAnim,originalAnims.run); s(animate.jump and animate.jump.JumpAnim,originalAnims.jump); s(animate.fall and animate.fall.FallAnim,originalAnims.fall); s(animate.climb and animate.climb.ClimbAnim,originalAnims.climb); s(animate.swim and animate.swim.Swim,originalAnims.swim); s(animate.swimidle and animate.swimidle.SwimIdle,originalAnims.swimidle)
    local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then for _,track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end; hum2:ChangeState(Enum.HumanoidStateType.Running) end
end
function startAnimToggle()
    if animHeartbeatConn then animHeartbeatConn:Disconnect(); animHeartbeatConn=nil end
    local char=LP.Character
    if char then saveOriginalAnims(char); applyAnimPack(char); local hum2=char:FindFirstChildOfClass("Humanoid"); if hum2 then for _,track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end; hum2:ChangeState(Enum.HumanoidStateType.Running) end end
    local _animAcc = 0
    animHeartbeatConn=RunService.Heartbeat:Connect(function(dt)
        if not State.animEnabled then return end
        _animAcc = _animAcc + (dt or 0.016)
        if _animAcc < 0.6 then return end
        _animAcc = 0
        local c = LP.Character
        if c then pcall(applyAnimPack, c) end
    end)
end
function stopAnimToggle() if animHeartbeatConn then animHeartbeatConn:Disconnect(); animHeartbeatConn=nil end; local char=LP.Character; if char then restoreOriginalAnims(char) end end

function startUnwalk()
    if State.unwalkEnabled then return end
    State.unwalkEnabled=true
    local c=LP.Character; if not c then return end
    local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then for _,t in ipairs(hum2:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim=c:FindFirstChild("Animate"); if anim then savedAnimate=anim:Clone(); anim:Destroy() end
end
function stopUnwalk()
    if not State.unwalkEnabled then return end
    State.unwalkEnabled=false
    local c=LP.Character
    if c and savedAnimate then savedAnimate.Parent=c; savedAnimate.Disabled=false; savedAnimate=nil end
    task.spawn(function() task.wait(0.15); local char=LP.Character; if not char then return end; if State.animEnabled then saveOriginalAnims(char); applyAnimPack(char) else restoreOriginalAnims(char) end end)
end

function tpToGround()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local aimOn = _G.CatalystBatOn or State.autoBatToggled or State.bypassToggled or _G.CatalystTpBatOn
    local oldVel = hrp.AssemblyLinearVelocity

    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
        * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)

    if aimOn then
        -- no matar la velocidad del aimbot (solo cortar Y)
        local hx = oldVel.X
        local hz = oldVel.Z
        local hmag = math.sqrt(hx * hx + hz * hz)
        if hmag < 25 then
            local look = hrp.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            if flat.Magnitude > 0.05 then
                flat = flat.Unit
                local spd = math.clamp(tonumber(State.bypassSpeed) or 55, 45, 60)
                hx, hz = flat.X * spd, flat.Z * spd
            end
        end
        hrp.AssemblyLinearVelocity = Vector3.new(hx, 0, hz)
    else
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end


local GP_ACT = {}
local gpLastFire = {}
local GP_DEBOUNCE = 0.25
local gpEnabled = false

function saveGPBinds()
    local t = {}
    for _, act in ipairs(GP_ACT) do if act.key then t[act.id] = act.key.Name end end
    Config.controllerBinds = t
    AutoSave()
end

function xboxName(kc)
    local map = {
        [Enum.KeyCode.ButtonA]="A",
        [Enum.KeyCode.ButtonB]="B",
        [Enum.KeyCode.ButtonX]="X",
        [Enum.KeyCode.ButtonY]="Y",
        [Enum.KeyCode.ButtonL1]="LB",
        [Enum.KeyCode.ButtonR1]="RB",
        [Enum.KeyCode.ButtonL2]="LT",
        [Enum.KeyCode.ButtonR2]="RT",
        [Enum.KeyCode.ButtonL3]="LS",
        [Enum.KeyCode.ButtonR3]="RS",
        [Enum.KeyCode.ButtonSelect]="View",
        [Enum.KeyCode.ButtonStart]="Menu",
        [Enum.KeyCode.DPadUp]="D-Up",
        [Enum.KeyCode.DPadDown]="D-Down",
        [Enum.KeyCode.DPadLeft]="D-Left",
        [Enum.KeyCode.DPadRight]="D-Right",
    }
    return map[kc] or (kc and kc.Name) or "None"
end

function loadGPKey(id, default)
    local saved = Config.controllerBinds[id]
    if saved then
        local ok, kc = pcall(function() return Enum.KeyCode[saved] end)
        if ok and kc and kc ~= Enum.KeyCode.Unknown then return kc end
    end
    return default
end

GP_ACT = {
    {id="TPDown",      label="TP Down",      key=loadGPKey("TPDown",      Enum.KeyCode.ButtonR2)},
    {id="CarryMode",   label="Carry Mode",   key=loadGPKey("CarryMode",   Enum.KeyCode.ButtonL2)},
    {id="AutoLeft",    label="Auto Left",    key=loadGPKey("AutoLeft",    Enum.KeyCode.ButtonR1)},
    {id="AutoRight",   label="Auto Right",   key=loadGPKey("AutoRight",   Enum.KeyCode.ButtonL1)},
    {id="Drop",        label="Drop BR",      key=loadGPKey("Drop",        Enum.KeyCode.ButtonY)},
    {id="Lagger", label="Lagger", key=loadGPKey("Lagger", Enum.KeyCode.ButtonA)},
    {id="AutoBat",     label="Auto Bat",     key=loadGPKey("AutoBat",     Enum.KeyCode.DPadUp)},
    {id="InstaReset",  label="Insta Reset",  key=loadGPKey("InstaReset",  Enum.KeyCode.Unknown)},
    {id="BatV2",       label="Bat V2",       key=loadGPKey("BatV2",       Enum.KeyCode.DPadRight)},
}

function doAutoLeft()
    State.autoLeftEnabled = not State.autoLeftEnabled
    if State.autoLeftEnabled then
        if State.autoRightEnabled then stopAutoRight(); if setAutoRight then setAutoRight(false) end; if setMB_AR then setMB_AR(false) end end
        if State.autoBatToggled then stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
        startAutoLeft()
    else
        stopAutoLeft()
    end
    if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end
    if setMB_AL then setMB_AL(State.autoLeftEnabled) end
    SetSetting("autoLeftEnabled", State.autoLeftEnabled)
    pcall(function() if _G.CatalystUpdateAutoRouteHUD then _G.CatalystUpdateAutoRouteHUD() end end)
end

function doAutoRight()
    State.autoRightEnabled = not State.autoRightEnabled
    if State.autoRightEnabled then
        if State.autoLeftEnabled then stopAutoLeft(); if setAutoLeft then setAutoLeft(false) end; if setMB_AL then setMB_AL(false) end end
        if State.autoBatToggled then stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
        startAutoRight()
    else
        stopAutoRight()
    end
    if setAutoRight then setAutoRight(State.autoRightEnabled) end
    if setMB_AR then setMB_AR(State.autoRightEnabled) end
    SetSetting("autoRightEnabled", State.autoRightEnabled)
    pcall(function() if _G.CatalystUpdateAutoRouteHUD then _G.CatalystUpdateAutoRouteHUD() end end)
end

function doCarryMode()
    if State.laggerLevel > 0 then
        State.laggerLevel = 0
        SetSetting("laggerLevel", 0)
        refreshUIToggles()
        updateLaggerButtons()
    end
    State.speedType = (State.speedType == "carry") and "normal" or "carry"
    SetSetting("speedType", State.speedType)
    if modeValLbl then modeValLbl.Text = State.speedType == "carry" and "Carry" or "Normal" end
    if setMB_CS then setMB_CS(State.speedType == "carry") end
end

function doLaggerSpeed()
    if State.laggerLevel == 1 then
        State.laggerLevel = 2
    else
        State.laggerLevel = 1
    end
    State.speedType = "normal"

    if State.laggerLevel == 0 then
        if setMB_CS then setMB_CS(State.speedType == "carry") end
    else
        if setMB_CS then setMB_CS(false) end
    end

    SetSetting("laggerLevel", State.laggerLevel)
    SetSetting("speedType", State.speedType)
    refreshUIToggles()
    updateLaggerButtons()

    for _, child in ipairs(pageMove:GetChildren()) do
        if child:IsA("Frame") then
            local laggerBtn = child:FindFirstChildWhichIsA("TextButton")
            if laggerBtn and laggerBtn.Text:match("^L%d?$") then
                if State.laggerLevel == 0 then
                    laggerBtn.Text = "L"
                    laggerBtn.BackgroundColor3 = PITCH_BLACK
                elseif State.laggerLevel == 1 then
                    laggerBtn.Text = "L1"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                else
                    laggerBtn.Text = "L2"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                end
                break
            end
        end
    end
end

function cycleLagger12()
    -- ciclo Lagger1 <-> Lagger2 (solo se apaga con Normal/Carry)
    if State.laggerLevel == 1 then
        State.laggerLevel = 2
    else
        State.laggerLevel = 1
    end
    State.speedType = "normal"
    SetSetting("laggerLevel", State.laggerLevel)
    SetSetting("speedType", State.speedType)
    if setMB_CS then
        setMB_CS(false)
    end
    pcall(function()
        if refreshUIToggles then refreshUIToggles() end
    end)
    pcall(function()
        if updateLaggerButtons then updateLaggerButtons() end
    end)
    if setL1 then pcall(setL1, State.laggerLevel == 1) end
    if setL2 then pcall(setL2, State.laggerLevel == 2) end
    if modeValLbl then
        modeValLbl.Text = State.laggerLevel == 1 and "Lagger 1" or "Lagger 2"
    end
end

function doLagger1()
    cycleLagger12()
end

function doLagger2()
    cycleLagger12()
end

function doAutoBat()
    if State.bypassToggled then
        toggleBypass(false)
    end

    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
        if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
    end

    if _G.CatalystBatOn or State.autoBatToggled then
        _G.CatalystStopBat()
        State.autoBatToggled = false
    else
        if State.bypassToggled then
            pcall(function() toggleBypass(false) end)
        end
        if _G.CatalystTpBatOn then
            pcall(function() _G.CatalystStopTpBat() end)
        end
        _G.CatalystStartBat()
        State.autoBatToggled = true
    end
    if setAutoBat then setAutoBat(State.autoBatToggled) end
    if setMB_AB then setMB_AB(State.autoBatToggled) end
    SetSetting("autoBatToggled", State.autoBatToggled)
    if _G._batAimbotBtn then pcall(function() _G._batAimbotBtn.setActive(State.autoBatToggled) end) end
end

function doTpBat()
    _G.CatalystToggleTpBat()
    if _G._tpBatBtn then
        _G._tpBatBtn.setActive(_G.CatalystTpBatOn)
    end
end

function doBatV2()
    -- Toggle Bat V2 de Clean (mismo motor que Clean Duels)
    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
        if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
    end
    if State.autoBatToggled and not State.bypassToggled then
        -- auto bat clásico aparte; al prender Bat V2 se apaga en toggleBypass
        if setAutoBat then setAutoBat(false) end
        if setMB_AB then setMB_AB(false) end
    end
    toggleBypass(not State.bypassToggled)
    if _G._batV2Btn then
        _G._batV2Btn.setActive(State.bypassToggled)
    end
    if ZenToast then
        ZenToast(State.bypassToggled and "Bat V2 Clean ON" or "Bat V2 Clean OFF", ACCENT)
    end
end

function updateSpeedFloatButtons()
end

function startControllerSupport()
    gpEnabled = true
    if _G._catalystCtrlBound then return end
    _G._catalystCtrlBound = true

    local dispatch = {
        TPDown = function() tpToGround() end,
        CarryMode = doCarryMode,
        AutoLeft = doAutoLeft,
        AutoRight = doAutoRight,
        Drop = function() runDropBrainrot() end,
        Lagger = cycleLagger12,
        AutoBat = doAutoBat,
        TpBat = doTpBat,
        InstaReset = function()
            instaReset()
        end,
        BatV2 = doBatV2,
    }

    UIS.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        local isGP = inp.UserInputType == Enum.UserInputType.Gamepad1
            or inp.UserInputType == Enum.UserInputType.Gamepad2
        if not isGP then return end
        local kc = inp.KeyCode
        local now = tick()

        if State.keyTpBat and State.keyTpBat ~= Enum.KeyCode.Unknown and kc == State.keyTpBat then
            local last = gpLastFire["keyTpBat"] or 0
            if now - last < GP_DEBOUNCE then return end
            gpLastFire["keyTpBat"] = now
            pcall(doTpBat)
            return
        end
        if (State.keyBatV2 and State.keyBatV2 ~= Enum.KeyCode.Unknown and kc == State.keyBatV2)
            or (State.keyBatAim2 and State.keyBatAim2 ~= Enum.KeyCode.Unknown and kc == State.keyBatAim2) then
            local last = gpLastFire["keyBatV2"] or 0
            if now - last < GP_DEBOUNCE then return end
            gpLastFire["keyBatV2"] = now
            pcall(doBatV2)
            return
        end

        for _, act in ipairs(GP_ACT) do
            if act.key ~= Enum.KeyCode.Unknown and act.key == kc then
                local allow = State.controllerEnabled or act.id == "TpBat" or act.id == "BatV2"
                if allow then
                    local last = gpLastFire[act.id] or 0
                    if now - last < GP_DEBOUNCE then return end
                    gpLastFire[act.id] = now
                    local fn = dispatch[act.id]
                    if fn then pcall(fn) end
                    return
                end
            end
        end
    end)
end

local function updateLaggerButtons()
    local lvl = State.laggerLevel
    if setL1 then setL1(lvl == 1) end
    if setL2 then setL2(lvl == 2) end
end

local function attachKorbloxLeg(legName, config)
    local char = LP.Character
    if not char then return false, "No character" end

    local targetPart = char:FindFirstChild(config.targetBodyPart)
    if not targetPart then return false, "Target part missing" end

    local oldAsset = char:FindFirstChild("Korblox_" .. legName:gsub("%s+", ""))
    if oldAsset then oldAsset:Destroy() end

    for _, partName in ipairs(config.partsToHide) do
        local limb = char:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then
            limb.Transparency = 1
        end
    end

    local success, objects = pcall(function()
        return game:GetObjects(config.id)
    end)
    if not success or not objects or #objects == 0 then
        return false, "Asset fetch failed"
    end

    local assetModel = objects[1]
    assetModel.Name = "Korblox_" .. legName:gsub("%s+", "")

    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        return false, "No MeshPart in asset"
    end

    mainMesh.Size = mainMesh.Size * config.scale
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame * config.offset

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    assetModel.Parent = char
    return true
end

local function attachHeadless()
    local char = LP.Character
    if not char then return false, "No character" end

    local targetPart = char:FindFirstChild("Head")
    if not targetPart then return false, "Head missing" end

    local oldAsset = char:FindFirstChild("Headless_Headless")
    if oldAsset then oldAsset:Destroy() end

    targetPart.Transparency = 1

    local success, objects = pcall(function()
        return game:GetObjects("rbxassetid://134082579")
    end)
    if not success or not objects or #objects == 0 then
        return false, "Asset fetch failed"
    end

    local assetModel = objects[1]
    assetModel.Name = "Headless_Headless"

    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        return false, "No MeshPart in asset"
    end

    mainMesh.Size = mainMesh.Size * Vector3.new(1,1,1)
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    assetModel.Parent = char
    return true
end

local speedLabels = {}
local SPEED_BASE_COLOR = Color3.fromRGB(255, 255, 255)

local function ensureSpeedLabelGradient(lbl)
    if not lbl or not lbl.Parent then return end
    local g = lbl:FindFirstChildOfClass("UIGradient")
    if not g then
        g = Instance.new("UIGradient")
        g.Parent = lbl
        g.Rotation = 90
    end
    local c = SPEED_BASE_COLOR or ACCENT
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 30)),
    })
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
end

task.spawn(function()
    local t = 0
    while true do
        task.wait(1.0)
        t = t + 1.0
        local brightness = 0.7 + 0.3 * (0.5 + 0.5 * math.sin(t * 1.4))
        local c = SPEED_BASE_COLOR or ACCENT
        local bright = Color3.new(
            math.clamp(c.R * brightness * 1.1, 0, 1),
            math.clamp(c.G * brightness, 0, 1),
            math.clamp(c.B * brightness * 1.1, 0, 1)
        )
        for i = #speedLabels, 1, -1 do
            local lbl = speedLabels[i]
            if lbl and lbl.Parent then
                local g = lbl:FindFirstChildOfClass("UIGradient")
                if not g then
                    ensureSpeedLabelGradient(lbl)
                    g = lbl:FindFirstChildOfClass("UIGradient")
                end
                if g then
                    g.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(0.45, bright),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
                    })
                end
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                table.remove(speedLabels, i)
            end
        end
    end
end)

local v1SelectBtn, v2SelectBtn
local C_ON_BG = Color3.fromRGB(100, 100, 100)
local PITCH_BLACK = Color3.fromRGB(0, 0, 0)

local ANIM_PACK_ORDER = {"Off", "Tryhard", "Crazy", "Zombie", "Ninja", "Knight", "Elder", "Levitate", "Astronaut", "Pirate", "Toy", "Vampire", "Werewolf", "Rthro", "Stylish"}
local ANIM_PACKS = {
    ["Tryhard"] = {
        idle1 = "rbxassetid://10921268909", idle2 = "rbxassetid://10921271542",
        walk = "rbxassetid://10921301576", run = "rbxassetid://10921306264",
        jump = "rbxassetid://10921322154", fall = "rbxassetid://10921316402",
        climb = "rbxassetid://10921298891", swim = "rbxassetid://10921315367",
        swimidle = "rbxassetid://10921313679",
    },
    ["Crazy"] = {
        idle1 = "rbxassetid://891621366", idle2 = "rbxassetid://891621366",
        walk = "rbxassetid://891636393", run = "rbxassetid://891636393",
        jump = "rbxassetid://891627522", fall = "rbxassetid://891617961",
        climb = "rbxassetid://891609353", swim = "rbxassetid://891621366",
        swimidle = "rbxassetid://891621366",
    },
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

local ACCESSORY_PACK_ORDER = {"Off", "Outfit 1", "Outfit 2", "Outfit 3", "Outfit 4", "Fuego"}
local BLEED_PACKS = {
    ["Outfit 1"] = {
        accessory = 10159600649,
        offset = Vector3.new(0, 1, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=9683332638",
        pants = "http://www.roblox.com/asset/?id=93182020184041",
        korblox = "right",
        headless = true,
    },
    ["Outfit 2"] = {
        accessory = 1744060292,
        offset = Vector3.new(0, 1.3, -0.2),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=9683332638",
        pants = "http://www.roblox.com/asset/?id=93182020184041",
        korblox = "right",
        headless = true,
    },
    ["Outfit 3"] = {
        accessory = 8349240186,
        offset = Vector3.new(0, 0.9, 0),
        headMesh = "http://www.roblox.com/asset/?id=16673245747",
        headTexture = nil,
        shirt = "http://www.roblox.com/asset/?id=11926549070",
        pants = "http://www.roblox.com/asset/?id=13189494471",
        korblox = "right",
        headless = true,
    },
    ["Outfit 4"] = {
        accessory = 121097973925756,
        offset = Vector3.new(0, 0.9, 0),
        headMesh = "http://www.roblox.com/asset/?id=134079402",
        headTexture = "http://www.roblox.com/asset/?id=133940918",
        shirt = "http://www.roblox.com/asset/?id=123181702116947",
        pants = "http://www.roblox.com/asset/?id=93330291631062",
        korblox = "right",
        headless = true,
    },
    ["Fuego"] = {
        fireBody = true,
        headless = false,
    },
}

local originalAccessoryPack = nil
local unwalkEnabled = false
local unwalkSavedAnimate = nil

local function saveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    State.originalOutfit = State.originalOutfit or {}
    State.originalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    State.originalOutfit.pants = pants and pants.PantsTemplate or nil
end

local function restoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
    local orig = State.originalOutfit or {}
    if orig.shirt then
        local s = Instance.new("Shirt")
        s.ShirtTemplate = orig.shirt
        s.Parent = char
    end
    if orig.pants then
        local p = Instance.new("Pants")
        p.PantsTemplate = orig.pants
        p.Parent = char
    end
end

local function clearAllOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end
end

local function saveOriginalAccessories(char)
    State.originalAccessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            table.insert(State.originalAccessories, child:Clone())
        end
    end
end

local function restoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
            child:Destroy()
        end
    end
    for _, clone in ipairs(State.originalAccessories or {}) do
        if clone and clone.Parent == nil then
            local newAcc = clone:Clone()
            newAcc.Parent = char
            for _, weld in ipairs(newAcc:GetDescendants()) do
                if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                    if weld:IsA("Weld") then
                        local p0 = weld.Part0 and weld.Part0.Name
                        local p1 = weld.Part1 and weld.Part1.Name
                        if p0 then weld.Part0 = char:FindFirstChild(p0) end
                        if p1 then weld.Part1 = char:FindFirstChild(p1) end
                    elseif weld:IsA("WeldConstraint") then
                        local p0 = weld.Part0 and weld.Part0.Name
                        local p1 = weld.Part1 and weld.Part1.Name
                        if p0 then weld.Part0 = char:FindFirstChild(p0) end
                        if p1 then weld.Part1 = char:FindFirstChild(p1) end
                    end
                end
            end
        end
    end
    State.originalAccessories = {}
end

local function clearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then
            child:Destroy()
        end
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then
            child:Destroy()
        end
    end
    local partsToHide = {"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    for _, partName in ipairs(partsToHide) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") then
        head.Transparency = 0
    end
end

local _aufFollowItems = {}
local _aufFollowConn = nil
local function _aufClearFollow()
    for _, it in ipairs(_aufFollowItems) do
        pcall(function()
            if it.H then it.H:Destroy() end
        end)
    end
    _aufFollowItems = {}
end
local function _aufEnsureFollow()
    if _aufFollowConn then return end
    local _lastCheck = 0
    _aufFollowConn = RunService.Heartbeat:Connect(function()
        if #_aufFollowItems == 0 then return end
        local now = tick()
        if now - _lastCheck < 1.5 then return end
        _lastCheck = now
        local char = LP.Character
        if not char then return end
        for i = #_aufFollowItems, 1, -1 do
            local it = _aufFollowItems[i]
            local H = it.H
            if not H or not H.Parent then
                table.remove(_aufFollowItems, i)
            else
                local target = char:FindFirstChild(it.targetName)
                if target then
                    if not (it.weld and it.weld.Parent == H and it.weld.Part0 == target) then
                        pcall(function()
                            if it.weld then it.weld:Destroy() end
                            H.Anchored = false
                            H.CanCollide = false
                            H.Massless = true
                            local w = Instance.new("Weld")
                            w.Name = "AuFfitWeld"
                            w.Part0 = target
                            w.Part1 = H
                            w.C0 = it.c0
                            w.C1 = it.c1
                            w.Parent = H
                            it.weld = w
                        end)
                    end
                end
            end
        end
    end)
end
local function _aufAddFollow(char, H, targetName, c0, c1)
    local target = char:FindFirstChild(targetName)
    if not target then
        pcall(function() H:Destroy() end)
        return false
    end
    H.CanCollide = false
    H.Massless = true
    H.Anchored = false
    H.Parent = char
    local w = Instance.new("Weld")
    w.Name = "AuFfitWeld"
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0 or CFrame.new()
    w.C1 = c1 or CFrame.new()
    w.Parent = H
    table.insert(_aufFollowItems, {
        H = H, targetName = targetName, c0 = w.C0, c1 = w.C1, weld = w
    })
    _aufEnsureFollow()
    return true
end

local function clearFireBody(char)
    if not char then return end
    for _, d in ipairs(char:GetDescendants()) do
        if d.Name == "CatalystFireFX" or d:GetAttribute("CatalystFire") == true then
            pcall(function() d:Destroy() end)
        end
    end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name == "CatalystFireFX" then
            pcall(function() d:Destroy() end)
        end
    end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p:GetAttribute("CatalystFireColor") then
            local c = p:GetAttribute("CatalystFireColor")
            if typeof(c) == "Color3" then
                pcall(function() p.Color = c end)
            end
            p:SetAttribute("CatalystFireColor", nil)
        end
    end
    for _, p in ipairs(char:GetChildren()) do
        if p:IsA("BasePart") and p:GetAttribute("CatalystFireColor") then
            local c = p:GetAttribute("CatalystFireColor")
            if typeof(c) == "Color3" then
                pcall(function() p.Color = c end)
            end
            p:SetAttribute("CatalystFireColor", nil)
        end
    end
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc and bc:GetAttribute("CatalystFireSaved") then
        pcall(function()
            if bc:GetAttribute("CF_Head") then bc.HeadColor3 = bc:GetAttribute("CF_Head") end
            if bc:GetAttribute("CF_Torso") then bc.TorsoColor3 = bc:GetAttribute("CF_Torso") end
            if bc:GetAttribute("CF_LA") then bc.LeftArmColor3 = bc:GetAttribute("CF_LA") end
            if bc:GetAttribute("CF_RA") then bc.RightArmColor3 = bc:GetAttribute("CF_RA") end
            if bc:GetAttribute("CF_LL") then bc.LeftLegColor3 = bc:GetAttribute("CF_LL") end
            if bc:GetAttribute("CF_RL") then bc.RightLegColor3 = bc:GetAttribute("CF_RL") end
            bc:SetAttribute("CatalystFireSaved", nil)
        end)
    end
end

local function applyFireBody(char)
    -- avatar fuego/partículas desactivado (rendimiento)
    pcall(function() clearFireBody(char) end)
end

local function applyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end
    local char = LP.Character
    if not char then return false end
    char:WaitForChild("Head", 10)
    local head = char:FindFirstChild("Head")
    if not head then return false end

    if config.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
                d:Destroy()
            end
        end
        if head:IsA("MeshPart") then
            pcall(function()
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            end)
        else
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head
            sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = config.headMesh
            sm.TextureId = config.headTexture or ""
        end
    end

    local function extractAssetId(src)
        if type(src) == "number" then return src end
        if type(src) ~= "string" then return nil end
        local n = tonumber(src)
        if n then return n end
        local id = string.match(src, "(%d+)")
        return id and tonumber(id) or nil
    end

    local function loadClothingTemplate(src, className)
        local direct = src
        if type(src) == "number" then
            direct = "http://www.roblox.com/asset/?id=" .. tostring(src)
        elseif type(src) == "string" and not src:find("asset") and tonumber(src) then
            direct = "http://www.roblox.com/asset/?id=" .. tostring(src)
        end
        local assetId = extractAssetId(src)
        if assetId then
            local objs = nil
            local ok, res = pcall(function()
                return game:GetObjects("rbxassetid://" .. tostring(assetId))
            end)
            if ok and typeof(res) == "table" and #res > 0 then
                objs = res
            else
                ok, res = pcall(function()
                    return game:GetService("InsertService"):LoadAsset(assetId)
                end)
                if ok and res then objs = { res } end
            end
            if objs then
                for _, o in ipairs(objs) do
                    if o:IsA(className) then
                        if className == "Shirt" then return o.ShirtTemplate end
                        if className == "Pants" then return o.PantsTemplate end
                    end
                    local found = o:FindFirstChildWhichIsA(className, true)
                    if found then
                        if className == "Shirt" then return found.ShirtTemplate end
                        if className == "Pants" then return found.PantsTemplate end
                    end
                end
            end
        end
        return direct
    end

    if config.shirt then
        local template = loadClothingTemplate(config.shirt, "Shirt")
        if template and template ~= "" then
            local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
            s.Name = "Shirt"
            pcall(function() s.ShirtTemplate = template end)
            s.Parent = char
        end
    end
    if config.pants then
        local appliedPants = false
        local template = loadClothingTemplate(config.pants, "Pants")
        if template and template ~= "" then
            local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
            p.Name = "Pants"
            local okT = pcall(function() p.PantsTemplate = template end)
            p.Parent = char
            appliedPants = okT and true or false
        end
        if not appliedPants or type(config.pants) == "number" then
            local pantsId = extractAssetId(config.pants)
            if pantsId then
                local objs = nil
                local ok, res = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(pantsId))
                end)
                if ok and typeof(res) == "table" and #res > 0 then objs = res
                else
                    ok, res = pcall(function()
                        return game:GetService("InsertService"):LoadAsset(pantsId)
                    end)
                    if ok and res then objs = { res } end
                end
                if objs then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    for _, o in ipairs(objs) do
                        local acc = o
                        if not o:IsA("Accessory") and not o:IsA("Pants") then
                            acc = o:FindFirstChildWhichIsA("Accessory", true) or o:FindFirstChildWhichIsA("Pants", true)
                        end
                        if acc then
                            if acc:IsA("Pants") then
                                local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
                                p.Name = "Pants"
                                pcall(function() p.PantsTemplate = acc.PantsTemplate end)
                                p.Parent = char
                                appliedPants = true
                            elseif acc:IsA("Accessory") and hum then
                                local clone = acc:Clone()
                                clone.Name = "AuFfitPants"
                                pcall(function() hum:AddAccessory(clone) end)
                                appliedPants = true
                            end
                        end
                    end
                    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
                end
            end
        end
    end

    if config.accessory and head then
        for _, ch in ipairs(char:GetChildren()) do
            if type(ch.Name) == "string" and (ch.Name:find("AuFfit") or ch.Name == "AuFfitHat" or ch.Name == "AuFfitAccessory") then
                pcall(function() ch:Destroy() end)
            end
        end
        pcall(_aufClearFollow)

        local function loadObjs(assetId)
            local objs = nil
            for attempt = 1, 5 do
                local ok, res = pcall(function()
                    return game:GetObjects("rbxassetid://" .. tostring(assetId))
                end)
                if ok and typeof(res) == "table" and #res > 0 then
                    objs = res
                    break
                end
                ok, res = pcall(function()
                    return game:GetService("InsertService"):LoadAsset(assetId)
                end)
                if ok and res then
                    objs = { res }
                    break
                end
                task.wait(0.3 * attempt)
            end
            return objs
        end

        local function collectParts(objs)
            local out = {}
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then out[#out + 1] = o end
                for _, d in ipairs(o:GetDescendants()) do
                    if d:IsA("BasePart") then out[#out + 1] = d end
                end
            end
            return out
        end

        local objs = loadObjs(config.accessory)
        if objs then
            local parts = collectParts(objs)
            local handle = nil
            for _, p in ipairs(parts) do
                if p.Name == "Handle" then handle = p; break end
            end
            if not handle and #parts > 0 then handle = parts[1] end

            local off = config.offset or Vector3.zero
            local c0 = CFrame.new(off)

            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Massless = true
                h.Anchored = false
                _aufAddFollow(char, h, "Head", c0, CFrame.new())
            end

            for _, p in ipairs(parts) do
                if p ~= handle and p.Name ~= "Handle" then
                    local sz = p.Size
                    if sz.Magnitude > 0.15 then
                        local extra = p:Clone()
                        extra.Name = "AuFfitAccessory_Part"
                        extra.CanCollide = false
                        extra.Massless = true
                        extra.Anchored = false
                        _aufAddFollow(char, extra, "Head", c0, CFrame.new())
                    end
                end
            end

            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, o in ipairs(objs) do
                    local acc = (o:IsA("Accessory") or o:IsA("Hat")) and o
                        or o:FindFirstChildWhichIsA("Accessory", true)
                    if acc then
                        local clone = acc:Clone()
                        clone.Name = "AuFfitHat"
                        pcall(function() hum:AddAccessory(clone) end)
                        if not clone.Parent then
                            pcall(function() clone.Parent = char end)
                        end
                        local hnd = clone:FindFirstChild("Handle")
                        if hnd then
                            pcall(function()
                                for _, w in ipairs(hnd:GetChildren()) do
                                    if w:IsA("Weld") or w:IsA("WeldConstraint") then
                                        if w:IsA("Weld") then
                                            w.C0 = w.C0 * CFrame.new(off)
                                        end
                                    end
                                end
                            end)
                        end
                        break
                    end
                end
            end

            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        else
            warn("[RLM DUELS] No se pudo cargar accessory id " .. tostring(config.accessory))
        end
    end

    if config.korblox and config.korblox ~= "none" then
        local function attachKorblox(side)
            local ids = { left = 139607673, right = 139607718 }
            local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
            local hides = {
                left = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
                right = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}
            }
            local targetPart = char:FindFirstChild(targets[side])
            if not targetPart then return false end
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local success, objects = pcall(function()
                return game:GetObjects("rbxassetid://" .. ids[side])
            end)
            if not success or not objects or #objects == 0 then return false end
            local assetModel = objects[1]
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if not mainMesh then assetModel:Destroy(); return false end
            mainMesh.CanCollide = false
            mainMesh.Massless = true
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart
            weld.Part1 = mainMesh
            weld.Parent = mainMesh
            assetModel.Parent = char
            return true
        end
        if config.korblox == "left" then
            attachKorblox("left")
        elseif config.korblox == "right" then
            attachKorblox("right")
        elseif config.korblox == "both" then
            attachKorblox("left")
            attachKorblox("right")
        end
    end

    if config.headless then
        local hasHeadAcc = char:FindFirstChild("AuFfitHat") or char:FindFirstChild("AuFfitAccessory")
        if hasHeadAcc then
            local h = char:FindFirstChild("Head")
            if h and h:IsA("BasePart") then
                h.Transparency = 1
                h.LocalTransparencyModifier = 1
                local face = h:FindFirstChild("face") or h:FindFirstChildOfClass("Decal")
                if face then face.Transparency = 1 end
            end
            for _, v in ipairs(char:GetChildren()) do
                if v:IsA("Accessory") and v.Name ~= "AuFfitHat" and v.Name ~= "AuFfitAccessory" and v.Name ~= "AuFfitFace" and v.Name ~= "AuFfitHair" then
                    local handle = v:FindFirstChild("Handle")
                    if handle then
                        local w = handle:FindFirstChildWhichIsA("Weld") or handle:FindFirstChildWhichIsA("WeldConstraint")
                        if w and ((w.Part0 and w.Part0.Name == "Head") or (w.Part1 and w.Part1.Name == "Head")) then
                            pcall(function() v:Destroy() end)
                        end
                    end
                end
            end
        end
    end

    return true
end

local function applyAccessoryPack(packName)
    local char = LP.Character
    if not char then return end
    if not packName or packName == "Off" then
        pcall(_aufClearFollow)
        clearFireBody(char)
        clearAllAccessories(char)
        restoreOriginalOutfit(char)
        restoreOriginalAccessories(char)
        local head = char:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            head.Transparency = 0
            head.LocalTransparencyModifier = 0
            local face = head:FindFirstChild("face") or head:FindFirstChildOfClass("Decal")
            if face then face.Transparency = 0 end
        end
        for _, n in ipairs({"LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
            local p = char:FindFirstChild(n)
            if p and p:IsA("BasePart") then p.Transparency = 0 end
        end
        State.accessoryPack = "Off"
        return
    end
    if not State.originalOutfit or not State.originalOutfit.shirt then
        saveOriginalOutfit(char)
    end
    if not State.originalAccessories or #State.originalAccessories == 0 then
        saveOriginalAccessories(char)
    end
    clearAllOutfit(char)
    clearAllAccessories(char)
    clearFireBody(char)
    if packName == "Fuego" then
        pcall(applyFireBody, char)
        State.accessoryPack = packName
        return
    end
    pcall(applyBleedOutfit, packName)
    State.accessoryPack = packName
end

local function getAccPackDisplay(packName)
    if packName == "Off" then return "Off" end
    for i, name in ipairs(ACCESSORY_PACK_ORDER) do
        if name == packName then
            return tostring(i - 1)
        end
    end
    return "Off"
end

local originalAnimPack = nil
local animPackSelectorLabel = nil
local animPackHeartbeatConn = nil

local function isLustPackAnim(id)
    if not id then return false end
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

local function saveOriginalAnimsLust(char)
    local animate = char and char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isLustPackAnim(ids.walk) then
        originalAnimPack = ids
    end
end

local function setAnimId(obj, id)
    if not obj or not id then return end
    pcall(function()
        if obj:IsA("Animation") then
            obj.AnimationId = id
        end
    end)
end

local function applyAnimPackLust(packName)
    local char = LP.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    local function s(folderName, animName, id)
        local folder = animate:FindFirstChild(folderName)
        if not folder then return end
        local anim = folder:FindFirstChild(animName)
        if anim then setAnimId(anim, id) end
        for _, child in ipairs(folder:GetChildren()) do
            if child:IsA("Animation") then
                setAnimId(child, id)
                break
            end
        end
    end

    if packName == "Off" then
        if originalAnimPack then
            s("idle", "Animation1", originalAnimPack.idle1)
            s("idle", "Animation2", originalAnimPack.idle2)
            s("walk", "WalkAnim", originalAnimPack.walk)
            s("run", "RunAnim", originalAnimPack.run)
            s("jump", "JumpAnim", originalAnimPack.jump)
            s("fall", "FallAnim", originalAnimPack.fall)
            s("climb", "ClimbAnim", originalAnimPack.climb)
            s("swim", "Swim", originalAnimPack.swim)
            s("swimidle", "SwimIdle", originalAnimPack.swimidle)
        end
        return
    end

    local pack = ANIM_PACKS[packName]
    if not pack then return end
    s("idle", "Animation1", pack.idle1)
    s("idle", "Animation2", pack.idle2)
    s("walk", "WalkAnim", pack.walk)
    s("run", "RunAnim", pack.run)
    s("jump", "JumpAnim", pack.jump)
    s("fall", "FallAnim", pack.fall)
    s("climb", "ClimbAnim", pack.climb)
    s("swim", "Swim", pack.swim)
    s("swimidle", "SwimIdle", pack.swimidle)
end

local function stopAnimPackHeartbeat()
    if animPackHeartbeatConn then
        animPackHeartbeatConn:Disconnect()
        animPackHeartbeatConn = nil
    end
end

local function applyAnimPackWithHeartbeat(packName)
    if not packName then packName = "Off" end
    stopAnimPackHeartbeat()
    local char = LP.Character
    if char then
        saveOriginalAnimsLust(char)
        applyAnimPackLust(packName)
    end
    State.animPack = packName
    SetSetting("animPack", packName)
    if packName ~= "Off" then
        local _lastAnimApply = 0
        animPackHeartbeatConn = RunService.Heartbeat:Connect(function()
            if State.animPack ~= packName then return end
            local t = tick()
            if t - _lastAnimApply < 4.0 then return end
            _lastAnimApply = t
            local c = LP.Character
            if c then applyAnimPackLust(packName) end
        end)
    end
    if animPackSelectorLabel then
        local t = "Off"
        for i = 2, #ANIM_PACK_ORDER do
            if ANIM_PACK_ORDER[i] == packName then
                t = tostring(i - 1)
                break
            end
        end
        animPackSelectorLabel.Text = t
    end
    if _G._refreshAnimBtns then pcall(_G._refreshAnimBtns) end
end

local function stopAnimPackLust()
    stopAnimPackHeartbeat()
    State.animPack = "Off"
    SetSetting("animPack", "Off")
    if animPackSelectorLabel then animPackSelectorLabel.Text = "Off" end
    applyAnimPackLust("Off")
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                    track:Stop(0.1)
                end
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
                task.defer(function()
                    if hum and hum.Parent then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end)
        end
    end
    if _G._refreshAnimBtns then pcall(_G._refreshAnimBtns) end
end

local function updateAccessorySelector(direction)
    local idx = 1
    for i, name in ipairs(ACCESSORY_PACK_ORDER) do
        if name == State.accessoryPack then idx = i; break end
    end
    local newIdx = idx + (direction or 1)
    if newIdx < 1 then newIdx = #ACCESSORY_PACK_ORDER end
    if newIdx > #ACCESSORY_PACK_ORDER then newIdx = 1 end
    local packName = ACCESSORY_PACK_ORDER[newIdx]
    State.accessoryPack = packName
    SetSetting("accessoryPack", packName)
    applyAccessoryPack(packName)
    if accPackSelectorLabel then
        accPackSelectorLabel.Text = (packName == "Off") and "Off" or tostring(newIdx - 1)
    end
    if _G._refreshAccBtns then pcall(_G._refreshAccBtns) end
end

local accPackSelectorLabel = nil

_G.CatalystTpBat = _G.CatalystTpBat or {
    conn = nil,
    hittingCooldown = false,
    h = nil,
    hrp = nil,
}

local TP_VERSIONS = {
    [1] = {
        Range = 2000,
        TPOffset = Vector3.new(0, 1.1, 0),
        LoopDelay = 0,
        SmartRotation = true,
        PredictMovement = true,
        PredictionFactor = 0.05,
        AntiFling = true,
        Orbit = true,
        OrbitSpeed = 48,
        OrbitRadius = 0.04,
    },
    [2] = {
        Range = 2500,
        TPOffset = Vector3.new(0, 0.95, 0),
        LoopDelay = 0,
        SmartRotation = true,
        PredictMovement = true,
        PredictionFactor = 0.05,
        AntiFling = true,
        Orbit = true,
        OrbitSpeed = 60,
        OrbitRadius = 0.02,
    },
}

local XLU0_TP_BAT_NAMES = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap","Rainbow Slap",
    "Plasmatic Slap","Plasma Slap","Admin Slap","Ban Hammer",
    "Taco Slap","Ghost Slap","Frost Slap","Thunder Slap"
}

local _tpLastSwing = 0
local _tpConn = nil
local _tpRenderConn = nil
local _aimbotTargetPlr = nil
local _tpAutoBatDelay = 0.045
local _tpOrbitAngle = 0
local _tpPinkMarker = nil
local _tpPinkAdornee = nil

function _tpGetMode()
    local m = tonumber(State and State.tpBatMode) or 2
    if m == 1 then return 1 end
    return 2
end

function _tpGetCfg()
    return TP_VERSIONS[_tpGetMode()] or TP_VERSIONS[2]
end

function _G.CatalystTpBatGetBat()
    local char = LP.Character
    if not char then return nil end
    local function isBatTool(t)
        if not t or not t:IsA("Tool") then return false end
        local n = t.Name:lower()
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil or n:find("hammer", 1, true) ~= nil
    end
    for _, t in ipairs(char:GetChildren()) do
        if isBatTool(t) then return t end
    end
    for _, name in ipairs(XLU0_TP_BAT_NAMES) do
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if isBatTool(t) then
                pcall(function()
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(t) else t.Parent = char end
                end)
                return t
            end
        end
        for _, name in ipairs(XLU0_TP_BAT_NAMES) do
            local tool = bp:FindFirstChild(name)
            if tool and tool:IsA("Tool") then
                pcall(function()
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then hum:EquipTool(tool) else tool.Parent = char end
                end)
                return tool
            end
        end
    end
    return nil
end

function _G.CatalystTpBatGetClosestPlayer()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local cfg = _tpGetCfg()
    local maxRange = (cfg and cfg.Range) or 600
    local best, bestDist = nil, maxRange
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local c = plr.Character
            if c then
                local hum = c:FindFirstChildOfClass("Humanoid")
                local hrp = c:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = plr
                    end
                end
            end
        end
    end
    return best
end

function clearTpPinkMarker()
    if _tpPinkMarker then pcall(function() _tpPinkMarker:Destroy() end) end
    _tpPinkMarker = nil
    _tpPinkAdornee = nil
end

function setTpPinkMarker(targetRoot)
    if not targetRoot or not targetRoot.Parent then
        clearTpPinkMarker()
        return
    end
    if _tpPinkAdornee == targetRoot and _tpPinkMarker and _tpPinkMarker.Parent then
        return
    end
    clearTpPinkMarker()
    local adornee = targetRoot
    pcall(function()
        local head = targetRoot.Parent and targetRoot.Parent:FindFirstChild("Head")
        if head then adornee = head end
    end)
    local bb = Instance.new("BillboardGui")
    bb.Name = "CatalystTpBatMark"
    bb.Size = UDim2.new(0, 18, 0, 18)
    bb.AlwaysOnTop = true
    bb.StudsOffset = Vector3.new(0, 2.2, 0)
    bb.Adornee = adornee
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then bb.Parent = pg else bb.Parent = game:GetService("CoreGui") end
    end)
    if not bb.Parent then
        pcall(function() bb.Parent = game:GetService("CoreGui") end)
    end
    local d = Instance.new("Frame", bb)
    d.Size = UDim2.new(1, 0, 1, 0)
    d.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    d.BorderSizePixel = 0
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    _tpPinkMarker = bb
    _tpPinkAdornee = targetRoot
end

function _G.CatalystTpBatTrySwing(targetPlayer)
    if tick() - _tpLastSwing < _tpAutoBatDelay then return end
    _tpLastSwing = tick()

    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local meRoot = char:FindFirstChild("HumanoidRootPart")
    if not hum or not meRoot then return end

    local bat = _G.CatalystTpBatGetBat()
    if not bat then return end
    if bat.Parent ~= char then
        pcall(function() hum:EquipTool(bat) end)
        bat = char:FindFirstChildOfClass("Tool") or _G.CatalystTpBatGetBat()
        if not bat or bat.Parent ~= char then return end
    end

    local tChar = targetPlayer and targetPlayer.Character
    if not tChar then return end
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    local tTorso = tChar:FindFirstChild("UpperTorso") or tChar:FindFirstChild("Torso") or tRoot
    if not tRoot or not tTorso then return end

    -- overlap fuerte en el torso (mejora registro)
    pcall(function()
        local p = tTorso.Position
        meRoot.CFrame = CFrame.new(p + Vector3.new(0, 0.15, 0), p + tRoot.CFrame.LookVector)
        meRoot.AssemblyLinearVelocity = Vector3.zero
        meRoot.AssemblyAngularVelocity = Vector3.zero
    end)

    local handle = bat:FindFirstChild("Handle")
    local parts = { tTorso, tRoot }
    local head = tChar:FindFirstChild("Head")
    if head then parts[#parts+1] = head end

    if handle then
        pcall(function()
            handle.CanTouch = true
            handle.CanQuery = true
            handle.CanCollide = false
            handle.Massless = true
            handle.CFrame = tTorso.CFrame * CFrame.new(0, 0, -0.05)
        end)
        if firetouchinterest then
            for i = 1, 2 do
                for _, p in ipairs(parts) do
                    pcall(firetouchinterest, handle, p, 0)
                    pcall(firetouchinterest, handle, p, 1)
                end
            end
        end
    end

    for _ = 1, 12 do
        pcall(function() bat:Activate() end)
    end

    pcall(function()
        if getconnections then
            for _, c in ipairs(getconnections(bat.Activated)) do
                pcall(function()
                    if c.Function then c.Function() end
                end)
            end
        end
    end)

    pcall(function()
        local n = 0
        for _, rem in ipairs(bat:GetDescendants()) do
            if n >= 8 then break end
            if rem:IsA("RemoteEvent") then
                pcall(function() rem:FireServer() end)
                pcall(function() rem:FireServer(tRoot) end)
                n = n + 2
            end
        end
    end)

    task.defer(function()
        if not _G.CatalystTpBatOn or not bat or not bat.Parent then return end
        if handle and tTorso and tTorso.Parent then
            pcall(function() handle.CFrame = tTorso.CFrame end)
            if firetouchinterest then
                pcall(firetouchinterest, handle, tTorso, 0)
                pcall(firetouchinterest, handle, tTorso, 1)
                if tRoot then
                    pcall(firetouchinterest, handle, tRoot, 0)
                    pcall(firetouchinterest, handle, tRoot, 1)
                end
            end
        end
        for _ = 1, 6 do
            pcall(function() bat:Activate() end)
        end
    end)
end

function _tpTeleportTo(targetRoot, meRoot, meHum, dt)
    if not targetRoot or not meRoot then return end
    local cfg = _tpGetCfg() or {}
    local targetPos = targetRoot.Position
    if cfg.PredictMovement then
        local vel = Vector3.zero
        pcall(function() vel = targetRoot.AssemblyLinearVelocity end)
        targetPos = targetPos + vel * (tonumber(cfg.PredictionFactor) or 0.05)
    end

    local finalPos
    if cfg.Orbit then
        _tpOrbitAngle = (_tpOrbitAngle + (cfg.OrbitSpeed or 50) * (dt or 0.016)) % (math.pi * 2)
        local r = math.min(cfg.OrbitRadius or 0.04, 0.12)
        finalPos = targetPos + Vector3.new(math.cos(_tpOrbitAngle) * r, 0, math.sin(_tpOrbitAngle) * r)
    else
        finalPos = targetPos
    end
    finalPos = finalPos + (cfg.TPOffset or Vector3.new(0, 1.0, 0))
    finalPos = Vector3.new(finalPos.X, targetRoot.Position.Y + 1.05, finalPos.Z)

    if cfg.SmartRotation ~= false then
        meRoot.CFrame = CFrame.new(finalPos, targetRoot.Position + Vector3.new(0, 0.8, 0))
    else
        meRoot.CFrame = CFrame.new(finalPos)
    end
    meRoot.AssemblyLinearVelocity = Vector3.zero
    meRoot.AssemblyAngularVelocity = Vector3.zero

    if meHum then
        meHum.AutoRotate = false
        if cfg.AntiFling then
            meHum.PlatformStand = false
            meHum.Sit = false
        end
    end
end

function _tpMainLoop(dt)
    if not _G.CatalystTpBatOn then return end

    local char = LP.Character
    if not char then return end
    local meRoot = char:FindFirstChild("HumanoidRootPart")
    local meHum = char:FindFirstChildOfClass("Humanoid")
    if not meRoot or not meHum or meHum.Health <= 0 then return end

    -- refs frescas siempre (evita que se “apague” el TP)
    _G.CatalystTpBat.hrp = meRoot
    _G.CatalystTpBat.h = meHum

    local target = _G.CatalystTpBatGetClosestPlayer()
    _aimbotTargetPlr = target
    _G.CatalystCurrentAimTarget = target
    _G.CatalystTpBatBatTarget = target

    if not target or not target.Character then
        clearTpPinkMarker()
        return
    end

    local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then
        clearTpPinkMarker()
        return
    end
    local tHum = target.Character:FindFirstChildOfClass("Humanoid")
    if tHum and tHum.Health <= 0 then return end

    setTpPinkMarker(targetRoot)

    -- equip bat si hace falta
    if not char:FindFirstChildOfClass("Tool") then
        _G.CatalystTpBatGetBat()
    end

    -- TP CONTINUO cada frame
    _tpTeleportTo(targetRoot, meRoot, meHum, dt)

    -- overlap extra
    local mid = targetRoot.Position + Vector3.new(0, 0.2, 0)
    meRoot.CFrame = CFrame.new(mid, mid + targetRoot.CFrame.LookVector)

    -- golpear
    _G.CatalystTpBatTrySwing(target)
end

function _G.CatalystStartTpBat()
    -- Solo pausa auto-routes; NO apaga Bat V2 / bypass
    pcall(function()
        if State.autoLeftEnabled then
            if stopAutoLeft then stopAutoLeft() end
            State.autoLeftEnabled = false
        end
        if State.autoRightEnabled then
            if stopAutoRight then stopAutoRight() end
            State.autoRightEnabled = false
        end
    end)

    -- limpiar conns viejas
    if _tpConn then pcall(function() _tpConn:Disconnect() end) _tpConn = nil end
    if _tpRenderConn then pcall(function() _tpRenderConn:Disconnect() end) _tpRenderConn = nil end
    if _G.CatalystTpBat.conn then
        pcall(function() _G.CatalystTpBat.conn:Disconnect() end)
        _G.CatalystTpBat.conn = nil
    end

    _G.CatalystTpBatOn = true
    _G.CatalystTpBat.hittingCooldown = false
    _tpLastSwing = 0
    _G._tpBatLastLoop = 0

    local char = LP.Character
    if char then
        _G.CatalystTpBat.h = char:FindFirstChildOfClass("Humanoid")
        _G.CatalystTpBat.hrp = char:FindFirstChild("HumanoidRootPart")
        pcall(function()
            local bat = _G.CatalystTpBatGetBat()
            local hum = _G.CatalystTpBat.h
            if bat and hum and bat.Parent ~= char then
                hum:EquipTool(bat)
            end
        end)
    end

    -- Heartbeat throttled (menos lag que RenderStepped cada frame)
    local _tpAcc = 0
    _tpRenderConn = RunService.Heartbeat:Connect(function(dt)
        if not _G.CatalystTpBatOn then return end
        _tpAcc = _tpAcc + (dt or 0.016)
        if _tpAcc < 0.03 then return end -- ~33 TPS
        local step = _tpAcc
        _tpAcc = 0
        pcall(_tpMainLoop, step)
    end)
    _tpConn = _tpRenderConn
    _G.CatalystTpBat.conn = _tpRenderConn

    if _G.CatalystTpBatSetVisual then
        pcall(function() _G.CatalystTpBatSetVisual(true) end)
    end
    if _G._tpBatBtn then
        pcall(function() _G._tpBatBtn.setActive(true) end)
    end
    if ZenToast then
        pcall(function() ZenToast("TP Bat ON - continuo", ACCENT) end)
    end
    return true
end

function _G.CatalystStopTpBat()
    _G.CatalystTpBatOn = false
    clearTpPinkMarker()

    if _tpConn then pcall(function() _tpConn:Disconnect() end) _tpConn = nil end
    if _tpRenderConn then pcall(function() _tpRenderConn:Disconnect() end) _tpRenderConn = nil end
    if _G.CatalystTpBat and _G.CatalystTpBat.conn then
        pcall(function() _G.CatalystTpBat.conn:Disconnect() end)
        _G.CatalystTpBat.conn = nil
    end
    if _G.CatalystTpBat then
        _G.CatalystTpBat.hittingCooldown = false
    end

    local char = LP.Character
    local meRoot = char and char:FindFirstChild("HumanoidRootPart")
    local meHum = char and char:FindFirstChildOfClass("Humanoid")
    if meRoot then
        meRoot.AssemblyLinearVelocity = Vector3.zero
        meRoot.AssemblyAngularVelocity = Vector3.zero
    end
    if meHum then
        pcall(function()
            meHum.AutoRotate = true
            meHum.PlatformStand = false
        end)
    end

    _G.CatalystTpBatBatTarget = nil
    if _G.CatalystCurrentAimTarget == _aimbotTargetPlr then
        _G.CatalystCurrentAimTarget = nil
    end
    _aimbotTargetPlr = nil

    if _G.CatalystTpBatSetVisual then
        pcall(function() _G.CatalystTpBatSetVisual(false) end)
    end
    if _G._tpBatBtn then
        pcall(function() _G._tpBatBtn.setActive(false) end)
    end
end


function _G.CatalystToggleTpBat()
    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
    else
        _G.CatalystStartTpBat()
    end
    if _G._tpBatBtn then
        pcall(function() _G._tpBatBtn.setActive(_G.CatalystTpBatOn == true) end)
    end
end




local AdaptReset = {
    Cooldown = false,
    Thread = nil,
    Character = nil,
    Successful = false,
    StopSequence = false,
    CameraLocked = false,
    LockedCameraCFrame = nil,
    MaxDuration = 0.01,
}

local CatalystParticles = {
    folder = nil,
    conns = {},
}

local function zenParticleColor()
    local a = ACCENT or Color3.fromRGB(180, 180, 180)
    local bright = Color3.new(
        math.clamp(a.R * 1.35 + 0.15, 0, 1),
        math.clamp(a.G * 1.35 + 0.15, 0, 1),
        math.clamp(a.B * 1.35 + 0.15, 0, 1)
    )
    local dark = Color3.new(
        math.clamp(a.R * 0.4, 0, 1),
        math.clamp(a.G * 0.4, 0, 1),
        math.clamp(a.B * 0.4, 0, 1)
    )
    return bright, a, dark
end

local function zenClearParticles()
    for _, c in ipairs(CatalystParticles.conns) do
        pcall(function() c:Disconnect() end)
    end
    CatalystParticles.conns = {}
    if CatalystParticles.folder then
        pcall(function() CatalystParticles.folder:Destroy() end)
        CatalystParticles.folder = nil
    end
    local char = LP.Character
    if char then
        local old = char:FindFirstChild("CatalystParticleFX")
        if old then pcall(function() old:Destroy() end) end
        local hl = char:FindFirstChild("CatalystHighlight")
        if hl then pcall(function() hl:Destroy() end) end
        local head = char:FindFirstChild("Head")
        if head then
            local hlgt = head:FindFirstChild("CatalystHeadLight")
            if hlgt then pcall(function() hlgt:Destroy() end) end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local light = root:FindFirstChild("CatalystAuraLight")
            if light then pcall(function() light:Destroy() end) end
            for _, n in ipairs({"CatalystPFeet", "CatalystPBody", "CatalystPHead"}) do
                local a = root:FindFirstChild(n)
                if a then pcall(function() a:Destroy() end) end
            end
            for _, a in ipairs(root:GetChildren()) do
                if a:IsA("Attachment") and (a.Name:find("TrailA") or a.Name:find("ZenP") or a.Name:find("CatalystP")) then
                    pcall(function() a:Destroy() end)
                end
            end
        end
    end
end

local function zenBuildParticles(char)
    -- desactivado por rendimiento (sin aura / partículas)
    pcall(zenClearParticles)
end

function startCatalystParticles()
    pcall(zenClearParticles)
end

_G.CatalystStartParticles = startCatalystParticles
_G.ZenRebuildParticles = function()
    pcall(zenClearParticles)
end

local function catalystBurstFX()
    return
end


local function hookCatalystActionFX(char)
    task.wait(0.2)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local wasFalling = false
    local stConn = hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Jumping then
            catalystBurstFX(root, "jump")
            wasFalling = true
        elseif new == Enum.HumanoidStateType.Freefall then
            wasFalling = true
        elseif new == Enum.HumanoidStateType.Landed or new == Enum.HumanoidStateType.Running then
            if wasFalling then
                catalystBurstFX(root, "land")
                wasFalling = false
            end
        end
    end)

    local function hookTool(tool)
        if not tool:IsA("Tool") then return end
        if tool:GetAttribute("CatalystFXHooked") then return end
        tool:SetAttribute("CatalystFXHooked", true)
        tool.Activated:Connect(function()
            catalystBurstFX(root, "bat")
        end)
    end

    for _, t in ipairs(char:GetChildren()) do hookTool(t) end
    char.ChildAdded:Connect(hookTool)

    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do hookTool(t) end
        bp.ChildAdded:Connect(hookTool)
    end

    char.AncestryChanged:Connect(function(_, parent)
        if not parent and stConn then
            pcall(function() stConn:Disconnect() end)
        end
    end)
end

LP.CharacterAdded:Connect(function(char)
    task.spawn(function() pcall(hookCatalystActionFX, char) end)
end)
if LP.Character then
    task.spawn(function() pcall(hookCatalystActionFX, LP.Character) end)
end

local AntiDie = {
    enabled = false,
    loop = nil,
    lastHeal = 0,
    invUntil = 0,
    healthConn = nil,
}

local function antiDieSuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxH = hum.MaxHealth or 100
    if hum.Health <= 0 or hum.Health < maxH then
        hum.Health = maxH
    end
    AntiDie.invUntil = tick() + 0.45
    AntiDie.lastHeal = tick()
    pcall(function()
        for _, child in ipairs(hum.Parent:GetChildren()) do
            if child:IsA("NumberValue") then
                local n = child.Name:lower()
                if n:find("health") or n:find("hp") or n:find("life") then
                    child.Value = maxH
                end
            end
        end
    end)
end

local function antiDieProtectChar(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if AntiDie.healthConn then
        pcall(function() AntiDie.healthConn:Disconnect() end)
        AntiDie.healthConn = nil
    end
    AntiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if _G._catalystShuttingDown then return end
        if not AntiDie.enabled then return end
        if hum.Health <= 25 or hum.Health <= 0 then
            antiDieSuperHeal(hum)
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            if root and root.Parent then
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X,
                    math.max(root.AssemblyLinearVelocity.Y, 2),
                    root.AssemblyLinearVelocity.Z
                )
            end
        end
    end)
end

function startAntiDie()
    if AntiDie.enabled then return end
    AntiDie.enabled = true
    State.antiDieEnabled = true
    if AntiDie.loop then
        pcall(function() AntiDie.loop:Disconnect() end)
        AntiDie.loop = nil
    end
    AntiDie.loop = RunService.Heartbeat:Connect(function()
        if _G._catalystShuttingDown then return end
        if not AntiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 25 then
            antiDieSuperHeal(hum)
        end
        if tick() < AntiDie.invUntil and root then
            if hum.PlatformStand then
                hum.PlatformStand = false
            end
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
            end
        end
    end)
    if LP.Character then
        antiDieProtectChar(LP.Character)
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then antiDieSuperHeal(hum) end
    end
end

function stopAntiDie()
    AntiDie.enabled = false
    State.antiDieEnabled = false
    if AntiDie.loop then
        pcall(function() AntiDie.loop:Disconnect() end)
        AntiDie.loop = nil
    end
    if AntiDie.healthConn then
        pcall(function() AntiDie.healthConn:Disconnect() end)
        AntiDie.healthConn = nil
    end
end

function setAntiDie(on)
    if on then startAntiDie() else stopAntiDie() end
    SetSetting("antiDieEnabled", AntiDie.enabled)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.15)
    if AntiDie.enabled then
        antiDieProtectChar(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then antiDieSuperHeal(hum) end
    end
end)

local EquipBat = { enabled = false, conns = {} }

local BAT_SKINS = {
    ["Default"] = {
        label = "Default", kind = "procedural",
        fxColor = Color3.fromRGB(180, 200, 255),
    },
    ["DiamondSword"] = {
        label = "Diamond Sword", kind = "mesh",
        mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969",
        scale = Vector3.new(0.2, 0.2, 0.2),
        c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), math.rad(300)),
        fxColor = Color3.fromRGB(80, 220, 255),
    },
    ["Katana"] = {
        label = "Katana", kind = "mesh",
        mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373",
        scale = Vector3.new(1.4, 1.4, 1.4),
        c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
        fxColor = Color3.fromRGB(255, 140, 160),
    },
}

local _catalystSwingLast = 0

function _G.ZenPlaySwordSlash(handle, tool)
    return
end


local function isZenBatTool(tool)
    if not tool then return false end
    local n = tool.Name:lower()
    return n:find("bat") ~= nil or n:find("slap") ~= nil
end

local function isZenMedusaTool(tool)
    if not tool then return false end
    return tool.Name:lower():find("medusa") ~= nil
end

local function equipBatAplicarEfecto(tool)
    if not tool or not tool:IsA("Tool") then return end
    if tool:GetAttribute("YaEsEspadaAzul") then return end

    local handle = tool:FindFirstChild("Handle")
    if not handle then return end

    if isZenMedusaTool(tool) then
        tool:SetAttribute("YaEsEspadaAzul", true)
        local originalTransparency = handle.Transparency
        local visualFolder = nil

        local function crearCazuela()
            if not EquipBat.enabled then return end
            handle.Transparency = 1
            visualFolder = Instance.new("Folder")
            visualFolder.Name = "EspadaAzulVisual"
            visualFolder.Parent = handle

            local col = ACCENT or Color3.fromRGB(160, 100, 50)
            local colDark = Color3.fromRGB(40, 28, 18)

            local pot = Instance.new("Part")
            pot.Name = "Cazuela"
            pot.Shape = Enum.PartType.Cylinder
            pot.Size = Vector3.new(1.6, 1.35, 1.35)
            pot.CanCollide = false
            pot.Massless = true
            pot.Color = Color3.fromRGB(55, 40, 28)
            pot.Material = Enum.Material.Metal
            pot.Parent = visualFolder
            local w1 = Instance.new("Weld")
            w1.Part0 = handle
            w1.Part1 = pot
            w1.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, math.rad(90))
            w1.Parent = pot

            local rim = Instance.new("Part")
            rim.Name = "Borde"
            rim.Shape = Enum.PartType.Cylinder
            rim.Size = Vector3.new(0.18, 1.55, 1.55)
            rim.CanCollide = false
            rim.Massless = true
            rim.Color = col
            rim.Material = Enum.Material.Metal
            rim.Parent = visualFolder
            local w2 = Instance.new("Weld")
            w2.Part0 = pot
            w2.Part1 = rim
            w2.C0 = CFrame.new(0.75, 0, 0)
            w2.Parent = rim

            local asaL = Instance.new("Part")
            asaL.Name = "AsaL"
            asaL.Size = Vector3.new(0.18, 0.55, 0.35)
            asaL.CanCollide = false
            asaL.Massless = true
            asaL.Color = colDark
            asaL.Material = Enum.Material.Metal
            asaL.Parent = visualFolder
            local w3 = Instance.new("Weld")
            w3.Part0 = pot
            w3.Part1 = asaL
            w3.C0 = CFrame.new(0.2, 0.85, 0)
            w3.Parent = asaL

            local asaR = asaL:Clone()
            asaR.Name = "AsaR"
            asaR.Parent = visualFolder
            local w4 = Instance.new("Weld")
            w4.Part0 = pot
            w4.Part1 = asaR
            w4.C0 = CFrame.new(0.2, -0.85, 0)
            w4.Parent = asaR

            local att = Instance.new("Attachment")
            att.Parent = rim
            local smoke = Instance.new("ParticleEmitter")
            smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
            smoke.Color = ColorSequence.new(Color3.fromRGB(180, 180, 180))
            smoke.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(1, 1.2),
            })
            smoke.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(1, 1),
            })
            smoke.Lifetime = NumberRange.new(0.8, 1.4)
            smoke.Rate = 12
            smoke.Speed = NumberRange.new(0.5, 1.2)
            smoke.Acceleration = Vector3.new(0, 2, 0)
            smoke.LightEmission = 0
            smoke.Parent = att
        end

        local function quitarCazuela()
            if visualFolder then visualFolder:Destroy(); visualFolder = nil end
            if handle and handle.Parent then handle.Transparency = originalTransparency end
        end

        tool.Equipped:Connect(function()
            local char = LP.Character
            local bp = LP:FindFirstChild("Backpack")
            if char and bp then
                for _, t in ipairs(char:GetChildren()) do
                    if t:IsA("Tool") and t ~= tool and isZenBatTool(t) then
                        t.Parent = bp
                    end
                end
            end
            crearCazuela()
        end)
        tool.Unequipped:Connect(quitarCazuela)
        if tool.Parent == LP.Character then crearCazuela() end
        return
    end

    if not isZenBatTool(tool) then return end
    tool:SetAttribute("YaEsEspadaAzul", true)

    local originalTransparency = handle.Transparency
    local visualFolder = nil
    local sonidoSwing = nil

    local function crearEspada()
        if not EquipBat.enabled then return end
        handle.Transparency = 1

        if visualFolder and visualFolder.Parent then
            pcall(function() visualFolder:Destroy() end)
            visualFolder = nil
        end

        visualFolder = Instance.new("Folder")
        visualFolder.Name = "EspadaAzulVisual"
        visualFolder.Parent = handle

        local skinId = (State and State.equipBatSkin) or "Default"
        local skin = BAT_SKINS[skinId] or BAT_SKINS["Default"]
        if skin and skin.kind == "mesh" and skin.mesh then
            local p = Instance.new("Part")
            p.Name = "SkinMesh"
            p.Size = Vector3.new(1, 1, 1)
            p.CanCollide = false
            p.Massless = true
            p.Transparency = 0
            p.Parent = visualFolder
            local sm = Instance.new("SpecialMesh")
            sm.MeshId = skin.mesh
            sm.TextureId = skin.tex or ""
            sm.Scale = skin.scale or Vector3.new(1, 1, 1)
            sm.Parent = p
            local w = Instance.new("Weld")
            w.Part0 = handle
            w.Part1 = p
            w.C0 = skin.c0 or CFrame.new()
            w.Parent = p

            local fxCol = skin.fxColor or (ACCENT or Color3.fromRGB(180, 200, 255))
            local att = Instance.new("Attachment")
            att.Name = "CatalystFireAtt"
            att.Position = Vector3.new(0, 1.2, 0)
            att.Parent = p
            local att2 = Instance.new("Attachment")
            att2.Name = "CatalystFireAtt2"
            att2.Position = Vector3.new(0, -0.8, 0)
            att2.Parent = p

            local fuego = Instance.new("ParticleEmitter")
            fuego.Name = "CatalystFire"
            fuego.Texture = "rbxasset://textures/particles/fire_main.dds"
            fuego.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, fxCol),
                ColorSequenceKeypoint.new(1, Color3.new(fxCol.R * 0.3, fxCol.G * 0.3, fxCol.B * 0.6)),
            })
            fuego.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.55),
                NumberSequenceKeypoint.new(1, 0.05),
            })
            fuego.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 1),
            })
            fuego.Lifetime = NumberRange.new(0.25, 0.45)
            fuego.Rate = 18
            fuego.Speed = NumberRange.new(0.5, 2)
            fuego.SpreadAngle = Vector2.new(15, 15)
            fuego.LightEmission = 0.9
            fuego.LockedToPart = true
            fuego.Parent = att

            local sparks = Instance.new("ParticleEmitter")
            sparks.Name = "CatalystEmbers"
            sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            sparks.Color = ColorSequence.new(fxCol)
            sparks.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.22),
                NumberSequenceKeypoint.new(1, 0),
            })
            sparks.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(1, 1),
            })
            sparks.Lifetime = NumberRange.new(0.25, 0.5)
            sparks.Rate = 10
            sparks.Speed = NumberRange.new(2, 6)
            sparks.SpreadAngle = Vector2.new(40, 40)
            sparks.LightEmission = 1
            sparks.Parent = att2

            local luz = Instance.new("PointLight")
            luz.Name = "CatalystFireLight"
            luz.Color = fxCol
            luz.Brightness = 2.8
            luz.Range = 12
            luz.Parent = p

            local a0 = Instance.new("Attachment")
            a0.Name = "Trail0"
            a0.Position = Vector3.new(0, 1.8, 0)
            a0.Parent = p
            local a1 = Instance.new("Attachment")
            a1.Name = "Trail1"
            a1.Position = Vector3.new(0, -1.2, 0)
            a1.Parent = p
            local trail = Instance.new("Trail")
            trail.Name = "CatalystFireTrail"
            trail.Attachment0 = a0
            trail.Attachment1 = a1
            trail.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, fxCol),
                ColorSequenceKeypoint.new(1, Color3.new(fxCol.R * 0.4, fxCol.G * 0.4, fxCol.B * 0.7)),
            })
            trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(1, 1),
            })
            trail.Lifetime = 0.22
            trail.MinLength = 0.05
            trail.LightEmission = 0.9
            trail.Parent = p
            return
        end

        local col = ACCENT or Color3.fromRGB(180, 180, 180)
        local colDark = Color3.new(math.clamp(col.R * 0.5, 0, 1), math.clamp(col.G * 0.5, 0, 1), math.clamp(col.B * 0.5, 0, 1))
        local colFire = Color3.new(math.clamp(col.R * 1.1, 0, 1), math.clamp(col.G * 0.85, 0, 1), math.clamp(col.B * 0.55, 0, 1))

        local hoja = Instance.new("Part")
        hoja.Name = "Hoja"
        hoja.Size = Vector3.new(0.35, 5.8, 0.12)
        hoja.CanCollide = false
        hoja.Massless = true
        hoja.Color = col
        hoja.Material = Enum.Material.Metal
        hoja.Reflectance = 0.12
        hoja.Parent = visualFolder

        local meshHoja = Instance.new("SpecialMesh")
        meshHoja.MeshType = Enum.MeshType.Brick
        meshHoja.Parent = hoja

        local weldHoja = Instance.new("Weld")
        weldHoja.Part0 = handle
        weldHoja.Part1 = hoja
        weldHoja.C0 = CFrame.new(0, 0, 0)
        weldHoja.Parent = hoja

        local punta = Instance.new("WedgePart")
        punta.Name = "Punta"
        punta.Size = Vector3.new(0.12, 0.7, 0.35)
        punta.CanCollide = false
        punta.Massless = true
        punta.Color = col
        punta.Material = Enum.Material.Metal
        punta.Parent = visualFolder

        local weldPunta = Instance.new("Weld")
        weldPunta.Part0 = hoja
        weldPunta.Part1 = punta
        weldPunta.C0 = CFrame.new(0, 3.2, 0) * CFrame.Angles(0, math.rad(90), 0)
        weldPunta.Parent = punta

        local mango = Instance.new("Part")
        mango.Name = "Mango"
        mango.Size = Vector3.new(0.28, 1.3, 0.28)
        mango.CanCollide = false
        mango.Massless = true
        mango.Color = Color3.fromRGB(28, 28, 32)
        mango.Material = Enum.Material.SmoothPlastic
        mango.Parent = visualFolder

        local weldMango = Instance.new("Weld")
        weldMango.Part0 = hoja
        weldMango.Part1 = mango
        weldMango.C0 = CFrame.new(0, -3.4, 0)
        weldMango.Parent = mango

        local guardia = Instance.new("Part")
        guardia.Name = "Guardia"
        guardia.Size = Vector3.new(1.1, 0.18, 0.35)
        guardia.CanCollide = false
        guardia.Massless = true
        guardia.Color = colDark
        guardia.Material = Enum.Material.Metal
        guardia.Parent = visualFolder

        local weldGuardia = Instance.new("Weld")
        weldGuardia.Part0 = hoja
        weldGuardia.Part1 = guardia
        weldGuardia.C0 = CFrame.new(0, -2.6, 0)
        weldGuardia.Parent = guardia

        hoja.Color = Color3.fromRGB(40, 120, 255)
        punta.Color = Color3.fromRGB(80, 180, 255)
        guardia.Color = Color3.fromRGB(20, 60, 140)

        local att = Instance.new("Attachment")
        att.Name = "CatalystFireAtt"
        att.Position = Vector3.new(0, 0.5, 0)
        att.Parent = hoja

        local att2 = Instance.new("Attachment")
        att2.Name = "CatalystFireAtt2"
        att2.Position = Vector3.new(0, 2.2, 0)
        att2.Parent = hoja

        local function makeBlueFire(parentAtt, rate)
            local fuego = Instance.new("ParticleEmitter")
            fuego.Name = "CatalystFire"
            fuego.Texture = "rbxasset://textures/particles/fire_main.dds"
            fuego.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 245, 255)),
                ColorSequenceKeypoint.new(0.25, Color3.fromRGB(80, 180, 255)),
                ColorSequenceKeypoint.new(0.55, Color3.fromRGB(30, 100, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 30, 120)),
            })
            fuego.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.5),
                NumberSequenceKeypoint.new(0.4, 1.05),
                NumberSequenceKeypoint.new(1, 0),
            })
            fuego.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(0.5, 0.2),
                NumberSequenceKeypoint.new(1, 1),
            })
            fuego.Lifetime = NumberRange.new(0.4, 0.85)
            fuego.Rate = rate
            fuego.Speed = NumberRange.new(2, 5)
            fuego.SpreadAngle = Vector2.new(30, 30)
            fuego.Acceleration = Vector3.new(0, 8, 0)
            fuego.LightEmission = 0.95
            fuego.LightInfluence = 0
            fuego.LockedToPart = true
            fuego.Parent = parentAtt
            return fuego
        end
        -- rates bajos para no matar FPS
        makeBlueFire(att, 8)
        makeBlueFire(att2, 5)

        local sparks = Instance.new("ParticleEmitter")
        sparks.Name = "CatalystEmbers"
        sparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        sparks.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 240, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 120, 255)),
        })
        sparks.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.28),
            NumberSequenceKeypoint.new(1, 0),
        })
        sparks.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 1),
        })
        sparks.Lifetime = NumberRange.new(0.3, 0.7)
        sparks.Rate = 4
        sparks.Speed = NumberRange.new(3, 8)
        sparks.SpreadAngle = Vector2.new(60, 60)
        sparks.Acceleration = Vector3.new(0, -1, 0)
        sparks.LightEmission = 1
        sparks.Parent = att

        local ring = Instance.new("ParticleEmitter")
        ring.Name = "CatalystArc"
        ring.Texture = "rbxasset://textures/particles/smoke_main.dds"
        ring.Color = ColorSequence.new(Color3.fromRGB(100, 200, 255))
        ring.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.15),
            NumberSequenceKeypoint.new(1, 0.6),
        })
        ring.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1),
        })
        ring.Lifetime = NumberRange.new(0.25, 0.45)
        ring.Rate = 2
        ring.Speed = NumberRange.new(0.5, 1.5)
        ring.SpreadAngle = Vector2.new(180, 180)
        ring.LightEmission = 0.7
        ring.Parent = att2

        local luz = Instance.new("PointLight")
        luz.Name = "CatalystFireLight"
        luz.Color = col
        luz.Brightness = 1.4
        luz.Range = 8
        luz.Parent = hoja

        local a0 = Instance.new("Attachment")
        a0.Name = "Trail0"
        a0.Position = Vector3.new(0, -2.5, 0)
        a0.Parent = hoja
        local a1 = Instance.new("Attachment")
        a1.Name = "Trail1"
        a1.Position = Vector3.new(0, 2.8, 0)
        a1.Parent = hoja
        local trail = Instance.new("Trail")
        trail.Name = "CatalystFireTrail"
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, col),
            ColorSequenceKeypoint.new(1, colDark),
        })
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1),
        })
        trail.Lifetime = 0.2
        trail.MinLength = 0.05
        trail.LightEmission = 0.85
        trail.Parent = hoja
    end

    local function quitarEspada()
        if visualFolder then
            visualFolder:Destroy()
            visualFolder = nil
        end
        if handle and handle.Parent then
            handle.Transparency = originalTransparency
        end
    end

    tool.Equipped:Connect(crearEspada)
    tool.Unequipped:Connect(quitarEspada)

    if not tool:GetAttribute("CatalystSwingHooked") then
        tool:SetAttribute("CatalystSwingHooked", true)
        tool.Activated:Connect(function()
            if not EquipBat.enabled then return end
            if tool.Parent ~= LP.Character then return end
            local h = tool:FindFirstChild("Handle")
            _G.ZenPlaySwordSlash(h, tool)
        end)
    end

    if tool.Parent == LP.Character then
        crearEspada()
    end
end

local function equipBatRevisar()
    if not EquipBat.enabled then return end
    local backpack = LP:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                equipBatAplicarEfecto(item)
            end
        end
    end
    local character = LP.Character
    if character then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") then
                equipBatAplicarEfecto(item)
            end
        end
    end
end

local function startEquipBat()
    if EquipBat.enabled then return end
    EquipBat.enabled = true
    State.equipBatEnabled = true
    local function clearMarks(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                item:SetAttribute("CatalystSwingHooked", nil)
            end
        end
    end
    clearMarks(LP:FindFirstChild("Backpack"))
    clearMarks(LP.Character)
    for _, c in ipairs(EquipBat.conns) do
        pcall(function() c:Disconnect() end)
    end
    EquipBat.conns = {}
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        table.insert(EquipBat.conns, bp.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and EquipBat.enabled then
                task.wait(0.15)
                equipBatAplicarEfecto(child)
            end
        end))
    end
    table.insert(EquipBat.conns, LP.CharacterAdded:Connect(function(character)
        if not EquipBat.enabled then return end
        task.wait(0.6)
        equipBatRevisar()
        table.insert(EquipBat.conns, character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and EquipBat.enabled then
                task.wait(0.15)
                equipBatAplicarEfecto(child)
            end
        end))
    end))
    equipBatRevisar()
end

local function stopEquipBat()
    EquipBat.enabled = false
    State.equipBatEnabled = false
    for _, c in ipairs(EquipBat.conns) do
        pcall(function() c:Disconnect() end)
    end
    EquipBat.conns = {}
    local function clearTool(tool)
        if not tool or not tool:IsA("Tool") then return end
        tool:SetAttribute("YaEsEspadaAzul", nil)
        local handle = tool:FindFirstChild("Handle")
        if handle then
            local vf = handle:FindFirstChild("EspadaAzulVisual")
            if vf then vf:Destroy() end
            handle.Transparency = 0
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do clearTool(t) end
    end
    if LP.Character then
        for _, t in ipairs(LP.Character:GetChildren()) do clearTool(t) end
    end
end

do
    local _pulseT = 0
    RunService.Heartbeat:Connect(function(dt)
        if not EquipBat.enabled then return end
        if _G.__CATALYST_BOOTING then return end
        _pulseT = _pulseT + (dt or 0.016)
        if _pulseT < 0.5 then return end
        _pulseT = 0
        local char = LP.Character
        if not char then return end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local vf = t:FindFirstChild("Handle") and t.Handle:FindFirstChild("EspadaAzulVisual")
                if vf then
                    local luz = vf:FindFirstChild("CatalystFireLight", true)
                    if luz and luz:IsA("PointLight") then
                        local base = 2.6
                        luz.Brightness = base + math.sin(tick() * 3.5) * 0.7
                    end
                end
            end
        end
    end)
end

function setEquipBat(on)
    if on then startEquipBat() else stopEquipBat() end
    SetSetting("equipBatEnabled", on and true or false)
    if ZenToast then
        pcall(function()
            ZenToast(on and "Equip Bat ON" or "Equip Bat OFF", ACCENT)
        end)
    end
end
_G.setEquipBat = setEquipBat

function setEquipBatSkin(skinId)
    if not BAT_SKINS[skinId] then skinId = "Default" end
    State.equipBatSkin = skinId
    SetSetting("equipBatSkin", skinId)
    local function scrub(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                item:SetAttribute("YaEsEspadaAzul", nil)
                local handle = item:FindFirstChild("Handle")
                if handle then
                    local vf = handle:FindFirstChild("EspadaAzulVisual")
                    if vf then pcall(function() vf:Destroy() end) end
                    if handle.Transparency >= 1 then handle.Transparency = 0 end
                end
            end
        end
    end
    scrub(LP:FindFirstChild("Backpack"))
    scrub(LP.Character)
    if EquipBat.enabled or State.equipBatEnabled then
        equipBatRevisar()
    end
    if ZenToast then
        local sk = BAT_SKINS[skinId]
        pcall(function() ZenToast("Bat Skin: " .. ((sk and sk.label) or skinId), ACCENT) end)
    end
end
_G.setEquipBatSkin = setEquipBatSkin

function _G.AdaptInstantReset()
    if AdaptReset.Cooldown then return end
    AdaptReset.Cooldown = true
    AdaptReset.Successful = false
    AdaptReset.StopSequence = false
    AdaptReset.CameraLocked = false

    local character = LP.Character
    if not character then
        AdaptReset.Cooldown = false
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid then
        AdaptReset.Cooldown = false
        return
    end

    -- captura cámara un instante (sin loop largo)
    local camera = workspace.CurrentCamera
    local lockedCF = camera and camera.CFrame or nil
    if camera and lockedCF then
        AdaptReset.LockedCameraCFrame = lockedCF
        AdaptReset.CameraLocked = true
    end

    AdaptReset.Character = character

    -- INSTANT kill (sin wait de 40 intentos)
    pcall(function()
        humanoid.HipHeight = 1e30
        humanoid.BreakJointsOnDeath = true
        humanoid.PlatformStand = true
        if root then
            root.CanCollide = false
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.new(0, 1e7, 0)
        end
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        humanoid.Health = 0
        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
    end)

    -- remotes rápidos
    pcall(function()
        if type(performReset) == "function" then
            -- performReset tiene su propio cooldown; forzar kill ya hecho
            local rs = game:GetService("ReplicatedStorage")
            for _, name in ipairs({"Reset", "LoadCharacter", "Respawn", "CharacterReset"}) do
                local rem = rs:FindFirstChild(name)
                if rem then
                    if rem:IsA("RemoteEvent") then pcall(function() rem:FireServer() end)
                    elseif rem:IsA("RemoteFunction") then pcall(function() rem:InvokeServer() end) end
                end
            end
        end
    end)

    AdaptReset.Successful = true
    -- soltar cámara en cuanto respawnea o tras 0.25s
    task.spawn(function()
        local t0 = tick()
        while tick() - t0 < 0.6 do
            if LP.Character and LP.Character ~= character then break end
            if camera and lockedCF and AdaptReset.CameraLocked then
                camera.CFrame = lockedCF
            end
            task.wait()
        end
        AdaptReset.CameraLocked = false
        AdaptReset.Cooldown = false
        AdaptReset.Successful = false
        if camera then
            camera.CameraType = Enum.CameraType.Custom
            local c2 = LP.Character
            local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
            if h2 then camera.CameraSubject = h2 end
        end
    end)
end

function _G.AdaptStopInstantReset()
    AdaptReset.StopSequence = true
    if AdaptReset.Thread then
        pcall(task.cancel, AdaptReset.Thread)
        AdaptReset.Thread = nil
    end
    AdaptReset.Cooldown = false
    AdaptReset.Character = nil
    AdaptReset.CameraLocked = false
end

LP.CharacterAdded:Connect(function()
    _G.AdaptStopInstantReset()
    AdaptReset.Successful = false
    AdaptReset.StopSequence = false
    AdaptReset.CameraLocked = false
end)

RunService.RenderStepped:Connect(function()
    if AdaptReset.CameraLocked and AdaptReset.LockedCameraCFrame and workspace.CurrentCamera then
        workspace.CurrentCamera.CFrame = AdaptReset.LockedCameraCFrame
    end
end)

;(function()
    local blConn = nil
    local BL_POWER = 18 -- cap suave (antes 220 dropeaba)

    local function blClosest(root)
        local range = tonumber(State.bodyLockRange) or 25
        local best, bestD = nil, range
        for _, plr in ipairs(getPlayersCached()) do
            if plr ~= LP then
                local c = plr.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                local hum = c and c:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < bestD then bestD, best = d, hrp end
                end
            end
        end
        return best
    end

    function stopBodyLock()
        if blConn then pcall(function() blConn:Disconnect() end); blConn = nil end
        pcall(function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if hum then hum.AutoRotate = true end
            if root and not State.spinEnabled then
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end

    function startBodyLock()
        stopBodyLock()
        if not State.bodyLockEnabled then return end
        blConn = RunService.Heartbeat:Connect(function()
            if not State.bodyLockEnabled then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end

            -- no pelear con bat / tp / bat v2 / spin
            if (_G.CatalystBat and _G.CatalystBat.active) or _G.CatalystTpBatOn or State.bypassToggled then
                return
            end
            if State.spinEnabled then return end

            local target = blClosest(root)
            if not target then
                hum.AutoRotate = true
                if not State.spinEnabled then
                    root.AssemblyAngularVelocity = Vector3.new(0, root.AssemblyAngularVelocity.Y * 0.3, 0)
                end
                return
            end

            hum.AutoRotate = false

            local tVel = target.AssemblyLinearVelocity
            local tPos = target.Position + Vector3.new(tVel.X, 0, tVel.Z) * 0.06
            local myPos = root.Position
            local direction = tPos - myPos
            local flat = Vector3.new(direction.X, 0, direction.Z)
            if flat.Magnitude < 0.12 then
                root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                return
            end
            flat = flat.Unit

            -- CFrame suave en Y (evita torque loco que dropea / te tira al pasar al lado)
            local lookAt = Vector3.new(tPos.X, myPos.Y, tPos.Z)
            local goalCF = CFrame.lookAt(myPos, lookAt)
            local alpha = 0.22
            local dist = (target.Position - myPos).Magnitude
            if dist < 8 then alpha = 0.32
            elseif dist > 18 then alpha = 0.14 end

            local newCF = root.CFrame:Lerp(goalCF, alpha)
            -- conservar pitch/roll casi 0, solo yaw hacia el rival
            local _, y, _ = newCF:ToOrientation()
            root.CFrame = CFrame.new(myPos) * CFrame.Angles(0, y, 0)

            -- angular solo Y, CAP bajo (antes 220+ te dropeaba)
            local look = root.CFrame.LookVector
            local targetYaw = math.atan2(flat.X, flat.Z)
            local currentYaw = math.atan2(look.X, look.Z)
            local angleDiff = targetYaw - currentYaw
            if angleDiff > math.pi then angleDiff = angleDiff - (math.pi * 2) end
            if angleDiff < -math.pi then angleDiff = angleDiff + (math.pi * 2) end
            local yawVel = math.clamp(angleDiff * 18, -22, 22)
            root.AssemblyAngularVelocity = Vector3.new(0, yawVel, 0)
        end)
    end

    function _G.CatalystBodyLockActive()
        return State.bodyLockEnabled == true
    end
    function setBodyLock(on)
        State.bodyLockEnabled = on == true
        SetSetting("bodyLockEnabled", State.bodyLockEnabled)
        if State.bodyLockEnabled then startBodyLock() else stopBodyLock() end
    end

    task.defer(function()
        task.wait(0.6)
        if State.bodyLockEnabled then
            pcall(startBodyLock)
        end
    end)

    LP.CharacterAdded:Connect(function()
        if not State.bodyLockEnabled then return end
        task.wait(0.35)
        pcall(startBodyLock)
    end)

    local darkSaved = nil
    function applyDarkMode()
        local L = game:GetService("Lighting")
        if not darkSaved then
            darkSaved = {
                Brightness = L.Brightness, ClockTime = L.ClockTime,
                Ambient = L.Ambient, OutdoorAmbient = L.OutdoorAmbient,
                FogStart = L.FogStart, FogEnd = L.FogEnd, FogColor = L.FogColor,
                GlobalShadows = L.GlobalShadows,
            }
        end

        if State.skyEnabled then
            L.Brightness = math.clamp((L.Brightness or 1) * 0.82, 0.55, 1.6)
            local a = L.Ambient
            L.Ambient = Color3.new(a.R * 0.75, a.G * 0.75, a.B * 0.82)
            local o = L.OutdoorAmbient
            L.OutdoorAmbient = Color3.new(o.R * 0.72, o.G * 0.72, o.B * 0.8)
        else
            L.ClockTime = 4.5
            L.Brightness = 1.15
            L.Ambient = Color3.fromRGB(70, 78, 105)
            L.OutdoorAmbient = Color3.fromRGB(60, 68, 95)
            L.FogStart = 100
            L.FogEnd = 1400
            L.FogColor = Color3.fromRGB(45, 50, 70)
        end

        local cc = L:FindFirstChild("CatalystDarkCC")
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "CatalystDarkCC"
            cc.Parent = L
        end
        cc.Enabled = true
        cc.Brightness = -0.02
        cc.Contrast = 0.1
        cc.Saturation = 0.18 -- MANTIENE / realza colores
        cc.TintColor = Color3.fromRGB(200, 210, 255)

        local bloom = L:FindFirstChild("CatalystDarkBloom")
        if not bloom then
            bloom = Instance.new("BloomEffect")
            bloom.Name = "CatalystDarkBloom"
            bloom.Parent = L
        end
        bloom.Enabled = true
        bloom.Intensity = 0.35
        bloom.Size = 18
        bloom.Threshold = 0.95
    end
    function disableDarkMode()
        local L = game:GetService("Lighting")
        local cc = L:FindFirstChild("CatalystDarkCC")
        if cc then cc:Destroy() end
        local bloom = L:FindFirstChild("CatalystDarkBloom")
        if bloom then bloom:Destroy() end
        if State.skyEnabled and applySky then
            pcall(function() applySky(State.skyColorIndex or 1) end)
        elseif darkSaved then
            L.Brightness = darkSaved.Brightness
            L.ClockTime = darkSaved.ClockTime
            L.Ambient = darkSaved.Ambient
            L.OutdoorAmbient = darkSaved.OutdoorAmbient
            L.FogStart = darkSaved.FogStart
            L.FogEnd = darkSaved.FogEnd
            L.FogColor = darkSaved.FogColor
            L.GlobalShadows = darkSaved.GlobalShadows
        end
        darkSaved = nil -- reset para proxima vez
    end
    function setDarkMode(on)
        State.darkModeEnabled = on == true
        SetSetting("darkModeEnabled", State.darkModeEnabled)
        if State.darkModeEnabled then applyDarkMode() else disableDarkMode() end
    end
end)()

_guiChunk = (function()

local function _rgbFromCfg(t, fallback)
    if type(t) == "table" and t[1] and t[2] and t[3] then
        return Color3.fromRGB(tonumber(t[1]) or 0, tonumber(t[2]) or 0, tonumber(t[3]) or 0)
    end
    return fallback
end

local Q_OFF_BG   = Color3.fromRGB(0, 0, 0)
local Q_ON_BG    = Color3.fromRGB(255, 255, 255)
local Q_TEXT_OFF = Color3.fromRGB(235, 235, 235)
local Q_TEXT_ON  = Color3.fromRGB(255, 255, 255)

local ACCENT = Color3.fromRGB(255, 255, 255)
local DARK_ACC = Color3.fromRGB(25, 25, 25)
local OFF_BG = Color3.fromRGB(0, 0, 0)
local C_ROW = Color3.fromRGB(0, 0, 0)
local C_ROW_HOV = Color3.fromRGB(32, 32, 32)
local C_ON_BG = Color3.fromRGB(255, 255, 255)
local C_OFF_BG = Color3.fromRGB(0, 0, 0)
local C_WHITE = Color3.fromRGB(255, 255, 255)
local C_DIM = Color3.fromRGB(220, 220, 230)
local C_LABEL = Color3.fromRGB(235, 235, 235)

Config.guiAccent = {255, 255, 255}
Config.btnOffBg = {0, 0, 0}
Config.btnOnBg = {255, 255, 255}
Config.btnOffText = {210, 220, 210}
Config.btnOnText = {255, 255, 255}
Config.speedColor = {180, 180, 180}
Config.hitboxColor = {180, 180, 180}
Config.stealColor = {30, 140, 65}

pcall(function()
    SPEED_BASE_COLOR = _rgbFromCfg(Config.speedColor, Color3.fromRGB(180, 180, 180))
end)

local floatingBtnObjects = {}
local mobileBtnColorRefs = {}
local toggleColorRefs = {}

local function applyButtonTheme()
    for _, obj in ipairs(floatingBtnObjects) do
        pcall(function() if obj.updateUI then obj.updateUI() end end)
    end
    for _, entry in ipairs(mobileBtnColorRefs) do
        pcall(function() if entry.apply then entry.apply() end end)
    end
    if toggleColorRefs then
        for _, entry in ipairs(toggleColorRefs) do
            pcall(function() if entry.apply then entry.apply() end end)
        end
    end
end

local function setButtonColors(offBg, onBg, offText, onText)
    if offBg then
        Q_OFF_BG = offBg
        C_OFF_BG = offBg
        Config.btnOffBg = {math.floor(offBg.R*255+0.5), math.floor(offBg.G*255+0.5), math.floor(offBg.B*255+0.5)}
    end
    if onBg then
        Q_ON_BG = onBg
        C_ON_BG = onBg
        Config.btnOnBg = {math.floor(onBg.R*255+0.5), math.floor(onBg.G*255+0.5), math.floor(onBg.B*255+0.5)}
    end
    if offText then
        Q_TEXT_OFF = offText
        Config.btnOffText = {math.floor(offText.R*255+0.5), math.floor(offText.G*255+0.5), math.floor(offText.B*255+0.5)}
    end
    if onText then
        Q_TEXT_ON = onText
        Config.btnOnText = {math.floor(onText.R*255+0.5), math.floor(onText.G*255+0.5), math.floor(onText.B*255+0.5)}
    end
    AutoSave()
    applyButtonTheme()
end

local function setGuiAccent(c)
    if typeof(c) ~= "Color3" then c = Color3.fromRGB(255, 255, 255) end
    ACCENT = c
    _G._catalystThemeColor = c
    pcall(function()
        if _G._catalystAutoGrabThemeApply then
            _G._catalystAutoGrabThemeApply(c, _G._catalystThemeName)
        end
    end)
    pcall(function()
        local char = LP.Character
        if not char then return end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local handle = t:FindFirstChild("Handle")
                local vf = handle and handle:FindFirstChild("EspadaAzulVisual")
                if vf then
                    local col = ACCENT
                    local colDark = Color3.new(col.R * 0.55, col.G * 0.55, col.B * 0.55)
                    for _, p in ipairs(vf:GetChildren()) do
                        if p:IsA("BasePart") then
                            if p.Name == "Mango" then
                            elseif p.Name == "Guardia" then
                                p.Color = colDark
                            else
                                p.Color = col
                            end
                        end
                    end
                end
            end
        end
    end)
    C_LABEL = (_G._catalystThemeName == "purple") and Color3.fromRGB(235, 210, 255) or Color3.fromRGB(235, 235, 235)

    C_DIM = Color3.new(
        math.clamp(c.R * 0.7 + 0.2, 0, 1),
        math.clamp(c.G * 0.7 + 0.2, 0, 1),
        math.clamp(c.B * 0.7 + 0.2, 0, 1)
    )
    Config.guiAccent = {math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5)}
    Config.stealColor = {math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5)}
    Q_ON_BG = Color3.new(0.82, 0.82, 0.82)
    C_ON_BG = Q_ON_BG
    pcall(function() if applyButtonTheme then applyButtonTheme() end end)
    AutoSave()
    if (State.miniStyle or 1) >= 2 and _G.applyMiniStyle then
        pcall(function() _G.applyMiniStyle(State.miniStyle) end)
    elseif miniDot then
        pcall(function() miniDot.BackgroundColor3 = ACCENT end)
    end
    pcall(function()
        if pageTitle then pageTitle.TextColor3 = ACCENT end
        if headerLine then headerLine.BackgroundColor3 = ACCENT end
        if mainStroke then mainStroke.Color = c end
        if _G._mainStrokeGrad then
            _G._mainStrokeGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.45, c),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
        end
        if _G._avatarStroke then _G._avatarStroke.Color = c end
        if _G._avatarRing then _G._avatarRing.BackgroundColor3 = c end
        if titleStroke then titleStroke.Color = c end
        if miniDot then miniDot.BackgroundColor3 = c end
        if _G._refreshTitleGrad then pcall(_G._refreshTitleGrad) end
        if _G.ZenRebuildParticles then pcall(_G.ZenRebuildParticles) end
        if headerTitleRow then
            headerTitleRow.Visible = true
        end
        if footerLbl then footerLbl.TextColor3 = ACCENT end
        if _G._catalystFooterLbl then _G._catalystFooterLbl.TextColor3 = ACCENT end
        if tabBarStroke then tabBarStroke.Color = ACCENT end
        if contentSt then contentSt.Color = ACCENT end
        if headerAccentBar then headerAccentBar.BackgroundColor3 = ACCENT end
        pcall(function()
            for n, btn in pairs(tabBtns or {}) do
                if styleTab then styleTab(btn, currentTab == n) end
            end
        end)
        Q_ON_BG = Color3.fromRGB(220, 220, 220)
        Q_OFF_BG = Color3.fromRGB(12, 12, 12)
        Q_TEXT_ON = Color3.fromRGB(255, 255, 255)
        Q_TEXT_OFF = Color3.fromRGB(220, 220, 220)
        C_ON_BG = Q_ON_BG
        C_OFF_BG = Q_OFF_BG
        applyButtonTheme()
        pcall(function()
            if setSpeedColor then setSpeedColor(c) end
        end)
        pcall(function()
            if setHitboxColor then setHitboxColor(c) end
        end)
        pcall(function()
            if setStealColor then setStealColor(c) end
        end)
        SPEED_BASE_COLOR = c
        pcall(function()
            for _, lbl in ipairs(speedLabels or {}) do
                if lbl and lbl.Parent then
                    if lbl.Name ~= "StealBillLbl" then
                        lbl.TextColor3 = c
                    end
                end
            end
        end)
        pcall(function()
            if toggleColorRefs then
                for _, entry in ipairs(toggleColorRefs) do
                    if entry and entry.apply then entry.apply() end
                end
            end
            if keybindChipRefs then
                for _, chip in pairs(keybindChipRefs) do
                    if chip and chip.Parent then
                        chip.TextColor3 = ACCENT
                        local st = chip:FindFirstChildWhichIsA("UIStroke")
                        if st then st.Color = ACCENT end
                    end
                end
            end
        end)
        pcall(function()
            if topAccent then topAccent.BackgroundColor3 = c end
            if headerGlow then headerGlow.BackgroundColor3 = c end
            if headerAccentBar then headerAccentBar.BackgroundColor3 = c end
        end)
        pcall(function()
            if refreshCatalystGradients then refreshCatalystGradients(c) end
        end)
    end)
end

local function setSpeedColor(c)
    SPEED_BASE_COLOR = c
    Config.speedColor = {math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5)}
    AutoSave()
    for _, lbl in ipairs(speedLabels) do
        pcall(function()
            if not lbl or not lbl.Parent then return end
                        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            local g = lbl:FindFirstChildOfClass("UIGradient")
            if not g then
                g = Instance.new("UIGradient")
                g.Parent = lbl
                g.Rotation = 90
            end
            g.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.45, c),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
        end)
    end
end

local function setStealColor(c)
    Config.stealColor = {math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5)}
    AutoSave()
end

local function setHitboxColor(c)
    Config.hitboxColor = {math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5)}
    pcall(function()
        if ESP_CONFIG then
            ESP_CONFIG.BoxColor = c
            ESP_CONFIG.LineColor = c
        end
        for _, plr in ipairs(getPlayersCached()) do
            if plr ~= LP and plr.Character then
                local hl = plr.Character:FindFirstChild("RedESPBox")
                if hl and hl:IsA("Highlight") then
                    hl.FillColor = c
                end
            end
        end
        if playerData then
            for _, data in pairs(playerData) do
                if data.LineSegs then
                    for _, ln in ipairs(data.LineSegs) do
                        pcall(function() ln.Color = c end)
                    end
                elseif data.Line then
                    pcall(function() data.Line.Color = c end)
                end
            end
        end
    end)
    AutoSave()
end

pcall(function()
    local hc = _rgbFromCfg(Config.hitboxColor, Color3.fromRGB(180, 180, 180))
    if ESP_CONFIG then
        ESP_CONFIG.BoxColor = hc
        ESP_CONFIG.LineColor = hc
    end
end)

local TRANSPARENCY_BG = 0.35
local TRANSPARENCY_ROW = 0
local TRANSPARENCY_PILL = 0

local CONTENT_WIDTH = 270
local W,H,CORNER = 320, 400, 18

local BACKGROUND_OPTIONS = {
    {name = "Fondo 1", id = "74477110625593"},
    {name = "Fondo 2", id = "71467184507666"},
    {name = "Fondo 3", id = "70722989099746"},
    {name = "Fondo 4", id = "88996529847734"},
    {name = "Fondo 5", id = "105087825401282"},
    {name = "Fondo 6", id = "94056908243398"},
    {name = "Fondo 7", id = "81112256311926"},
    {name = "Fondo 8", id = "130295216066368"},
    {name = "Fondo 9", id = "89405965002550"},
}
local BACKGROUND_ID = BACKGROUND_OPTIONS[1].id
State.bgFondoIndex = math.clamp(tonumber(Config.bgFondoIndex) or 1, 1, #BACKGROUND_OPTIONS)
State.bgImageId = BACKGROUND_OPTIONS[State.bgFondoIndex].id

-- Fondo personalizado RLM DUELS. Coloca image_267fd05f.jpg junto al script.
local CUSTOM_BACKGROUND_FILE = "image_267fd05f.jpg"
local NINJA_ART_FILE = "rlm_ninja.jpg"
local RLM_MENU_IMAGE_ID = "109921137280472"
local RLM_BUTTON_IMAGE_ID = "90409558214392"
local RLM_STEAL_IMAGE_ID = "91529247387232"
local function customFileUri(name)
    local assetFn = getcustomasset or getsynasset
    if type(assetFn) ~= "function" or type(isfile) ~= "function" then return nil end
    local ok, exists = pcall(function() return isfile(name) end)
    if ok and exists then
        local good, asset = pcall(function() return assetFn(name) end)
        if good and asset then return asset end
    end
    return nil
end
local function customBackgroundUri()
    return customFileUri(CUSTOM_BACKGROUND_FILE)
end
local function ninjaArtUri()
    return customFileUri(NINJA_ART_FILE)
end

local function backgroundUri(id)
    return "rbxassetid://" .. RLM_BUTTON_IMAGE_ID
end
local function menuBackgroundUri()
    return "rbxassetid://" .. RLM_MENU_IMAGE_ID
end

local gui=Instance.new("ScreenGui"); gui.Name="CATALYST_DUELS"; gui.ResetOnSpawn=false; gui.DisplayOrder=10; gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Enabled = true
pcall(function() gui.Parent=game:GetService("CoreGui") end)
if not gui.Parent then
    pcall(function() gui.Parent = LP:WaitForChild("PlayerGui", 5) end)
end
_G._catalystMainGui = gui
task.delay(5, function()
    pcall(function()
        if gui and gui.Parent and not gui.Enabled then
            gui.Enabled = true
            print("[RLM DUELS] GUI failsafe enable")
        end
    end)
end)

local toastGui = Instance.new("Frame")
toastGui.Name = "CatalystToastHost"
toastGui.Size = UDim2.new(0, 220, 0, 0)
toastGui.Position = UDim2.new(0.5, -110, 0.12, 0)
toastGui.BackgroundTransparency = 1
toastGui.ZIndex = 200
toastGui.Parent = gui
local toastLayout = Instance.new("UIListLayout", toastGui)
toastLayout.SortOrder = Enum.SortOrder.LayoutOrder
toastLayout.Padding = UDim.new(0, 6)
toastLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

function ZenToast(text, color)
    color = color or ACCENT
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 220, 0, 0)
    card.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    card.ZIndex = 201
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
    local st = Instance.new("UIStroke", card)
    st.Color = color
    st.Thickness = 1.35
    st.Transparency = 0.2
    local bar = Instance.new("Frame", card)
    bar.Size = UDim2.new(0, 3, 1, -8)
    bar.Position = UDim2.new(0, 4, 0, 4)
    bar.BackgroundColor3 = color
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1, -16, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = tostring(text or "")
    lbl.TextColor3 = Color3.fromRGB(240, 240, 245)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize =  12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.ZIndex = 202
    card.Parent = toastGui
    card.Size = UDim2.new(0, 240, 0, 38)
    card.BackgroundTransparency = 1
    card.Position = UDim2.new(0.5, -120, 0, -10)
    st.Transparency = 1
    lbl.TextTransparency = 1
    TweenService:Create(card, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.04,
        Position = UDim2.new(0.5, -120, 0, 6)
    }):Play()
    TweenService:Create(st, TweenInfo.new(0.3), {Transparency = 0.15}):Play()
    TweenService:Create(lbl, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    task.delay(2.4, function()
        if not card.Parent then return end
        TweenService:Create(card, TweenInfo.new(0.22), {BackgroundTransparency = 1}):Play()
        TweenService:Create(lbl, TweenInfo.new(0.22), {TextTransparency = 1}):Play()
        TweenService:Create(st, TweenInfo.new(0.22), {Transparency = 1}):Play()
        task.wait(0.24)
        pcall(function() card:Destroy() end)
    end)
end
_G.ZenToast = ZenToast


local isAnimating = false
local savedMainPos = nil -- posición fija de la GUI (solo cambia si el usuario la arrastra)

function makeDraggable(inputObject, moveObject, lockedFn)
    local dragging, dragStart, startPos = false, nil, nil
    pcall(function()
        inputObject.Active = true
    end)
    inputObject.InputBegan:Connect(function(inp)
        if isAnimating then return end
        if lockedFn and lockedFn() then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = moveObject.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging or isAnimating then return end
        if lockedFn and lockedFn() then
            dragging = false
            return
        end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            moveObject.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
            if moveObject.Name == "Main" then
                savedMainPos = moveObject.Position
                if _G._setClassicMainPos then pcall(_G._setClassicMainPos, moveObject.Position) end
            end
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if moveObject.Name == "Main" then
                    savedMainPos = moveObject.Position
                    if _G._setClassicMainPos then pcall(_G._setClassicMainPos, moveObject.Position) end
                    pcall(function()
                        writefile("KzsHubMainPos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
                            moveObject.Position.X.Scale, moveObject.Position.X.Offset,
                            moveObject.Position.Y.Scale, moveObject.Position.Y.Offset))
                    end)
                elseif moveObject.Name == "Mini" then
                    pcall(function()
                        writefile("KzsHubMiniPos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
                            moveObject.Position.X.Scale, moveObject.Position.X.Offset,
                            moveObject.Position.Y.Scale, moveObject.Position.Y.Offset))
                    end)
                end
            end
        end
    end)
end

local _catalystGradList = {}
local function blackAccentSequence(c)
    c = (typeof(c) == "Color3") and c or ACCENT
    local dark = Color3.fromRGB(0, 0, 0)
    local strong = Color3.new(
        math.clamp(c.R * 1.2, 0, 1),
        math.clamp(c.G * 1.05, 0, 1),
        math.clamp(c.B * 1.2, 0, 1)
    )
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, dark),
        ColorSequenceKeypoint.new(0.5, strong),
        ColorSequenceKeypoint.new(1, dark),
    })
end
local function softAccentSequence(c)
    c = (typeof(c) == "Color3") and c or ACCENT
    local dark = Color3.fromRGB(0, 0, 0)
    local strong = Color3.new(
        math.clamp(c.R * 1.15, 0, 1),
        math.clamp(c.G * 1.0, 0, 1),
        math.clamp(c.B * 1.15, 0, 1)
    )
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, dark),
        ColorSequenceKeypoint.new(0.5, strong),
        ColorSequenceKeypoint.new(1, dark),
    })
end
local function ensureUIGradient(inst, rot)
    if not inst then return nil end
    local g = inst:FindFirstChildOfClass("UIGradient")
    if not g then
        g = Instance.new("UIGradient")
        g.Parent = inst
    end
    g.Rotation = rot or 90
    g.Color = blackAccentSequence(ACCENT)
    table.insert(_catalystGradList, g)
    return g
end
function refreshCatalystGradients(c)
    c = (typeof(c) == "Color3") and c or ACCENT
    local seq = blackAccentSequence(c)
    local soft = softAccentSequence(c)
    for i = #_catalystGradList, 1, -1 do
        local g = _catalystGradList[i]
        if g and g.Parent then
            local n = tostring(g.Parent.Name or "")
            if n == "Main" or n == "ContentPanel" or n == "TopTabBar" or n == "ToggleRow" or n == "InputRow" or n == "FooterBar" then
                g.Color = soft
            else
                g.Color = seq
            end
        else
            table.remove(_catalystGradList, i)
        end
    end
    pcall(function()
        if mainStroke then mainStroke.Color = c end
        if _G._mainStrokeGrad then _G._mainStrokeGrad.Color = seq end
        if contentSt then contentSt.Color = c end
        if tabBarStroke then tabBarStroke.Color = c end
        if headerLine then headerLine.BackgroundColor3 = c end
        if topAccent then topAccent.BackgroundColor3 = c end
    end)
end

local main=Instance.new("Frame",gui); main.Name="Main"
main.AnchorPoint=Vector2.new(0,0.5)
main.Size=UDim2.new(0,W,0,H)
main.Position=UDim2.new(0,12,0.5,0)
main.BackgroundColor3=Color3.fromRGB(0,0,0)
main.BackgroundTransparency=0
main.BorderSizePixel=0; main.Active=true
main.ClipsDescendants=true
local mainCorner=Instance.new("UICorner",main); mainCorner.CornerRadius=UDim.new(0,CORNER)

local mainStroke=Instance.new("UIStroke",main); mainStroke.Color=ACCENT; mainStroke.Thickness=1.5; mainStroke.Transparency=0.35
mainStroke.Enabled = false
mainStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
mainStroke.LineJoinMode = Enum.LineJoinMode.Round
local mainStrokeGrad = Instance.new("UIGradient", mainStroke)
mainStrokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.45, ACCENT),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
mainStrokeGrad.Rotation = 45
_G._mainStrokeGrad = mainStrokeGrad
local menuBorderLeft = Instance.new("Frame", main)
menuBorderLeft.Name = "MenuOpenBorderLeft"
menuBorderLeft.BorderSizePixel = 0
menuBorderLeft.BackgroundColor3 = ACCENT
menuBorderLeft.BackgroundTransparency = 1
menuBorderLeft.Position = UDim2.new(0.5, -1, 0.12, 0)
menuBorderLeft.Size = UDim2.new(0, 2, 0.76, 0)
menuBorderLeft.ZIndex = 50
local menuBorderRight = Instance.new("Frame", main)
menuBorderRight.Name = "MenuOpenBorderRight"
menuBorderRight.BorderSizePixel = 0
menuBorderRight.BackgroundColor3 = ACCENT
menuBorderRight.BackgroundTransparency = 1
menuBorderRight.Position = UDim2.new(0.5, -1, 0.12, 0)
menuBorderRight.Size = UDim2.new(0, 2, 0.76, 0)
menuBorderRight.ZIndex = 50

local topAccent = Instance.new("Frame", main)
topAccent.Name = "TopAccent"
topAccent.Visible = false
topAccent.Size = UDim2.new(1, 0, 0, 0)
topAccent.Position = UDim2.new(0, 0, 0, 0)
topAccent.BackgroundColor3 = ACCENT
topAccent.BorderSizePixel = 0
topAccent.ZIndex = 20
local topAccentGrad = Instance.new("UIGradient", topAccent)
topAccentGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.5, ACCENT),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
})
topAccentGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.75),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 0.75),
})

local _guiUserScale = math.clamp(tonumber(Config.guiScale) or 0.80, 0.55, 1.30)
State.guiScale = _guiUserScale
local _guiAnimScale = 1
local animScale = Instance.new("UIScale", main)
animScale.Name = "MainScale"
local function _refreshMainScale()
    animScale.Scale = _guiUserScale * _guiAnimScale
end
_refreshMainScale()

local bgImage = Instance.new("ImageLabel", main)
bgImage.Name = "BackgroundImage"
bgImage.AnchorPoint = Vector2.new(0.5, 0.5)
bgImage.Position = UDim2.new(0.5, 0, 0.5, 0)
bgImage.Size = UDim2.new(1, 4, 1, 4) -- +2px por lado para no dejar bordes con el corner
bgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.BorderSizePixel = 0
bgImage.Image = menuBackgroundUri()
bgImage.ImageTransparency = 0
bgImage.Visible = true
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ResampleMode = Enum.ResamplerMode.Default
bgImage.ZIndex = 0
bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
bgImage.ImageTransparency = 0.05

local ninjaArt = Instance.new("ImageLabel", main)
ninjaArt.Name = "NinjaArt"
ninjaArt.Size = UDim2.new(1, 0, 1, 0)
ninjaArt.Position = UDim2.new(0, 0, 0, 0)
ninjaArt.BackgroundTransparency = 1
ninjaArt.BorderSizePixel = 0
ninjaArt.Image = ninjaArtUri() or ""
ninjaArt.ImageTransparency = 0
ninjaArt.ScaleType = Enum.ScaleType.Crop
ninjaArt.ZIndex = 0
ninjaArt.Visible = ninjaArtUri() ~= nil
local ninjaFade = Instance.new("UIGradient", ninjaArt)
ninjaFade.Rotation = 90
ninjaFade.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.05),
    NumberSequenceKeypoint.new(0.45, 0.18),
    NumberSequenceKeypoint.new(0.8, 0.42),
    NumberSequenceKeypoint.new(1, 0.72),
})

local vignette = Instance.new("ImageLabel", main)
vignette.Name = "Vignette"
vignette.Size = UDim2.new(1, 0, 1, 0)
vignette.BackgroundTransparency = 1
vignette.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
vignette.ImageTransparency = 1
vignette.ZIndex = 1
local vigTop = Instance.new("Frame", main)
vigTop.Name = "VignetteTop"
vigTop.Size = UDim2.new(1, 0, 0, 70)
vigTop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
vigTop.BackgroundTransparency = 1
vigTop.BorderSizePixel = 0
vigTop.ZIndex = 1
local vigTopG = Instance.new("UIGradient", vigTop)
vigTopG.Rotation = 90
vigTopG.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 1),
})
local vigBot = Instance.new("Frame", main)
vigBot.Name = "VignetteBot"
vigBot.Size = UDim2.new(1, 0, 0, 50)
vigBot.Position = UDim2.new(0, 0, 1, -50)
vigBot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
vigBot.BackgroundTransparency = 1
vigBot.BorderSizePixel = 0
vigBot.ZIndex = 1
local vigBotG = Instance.new("UIGradient", vigBot)
vigBotG.Rotation = 90
vigBotG.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(1, 0.15),
})

local function applyBgImageLayout()
    if not bgImage then return end
    bgImage.AnchorPoint = Vector2.new(0.5, 0.5)
    bgImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    bgImage.Size = UDim2.new(1, 4, 1, 4)
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.BorderSizePixel = 0
end

local function setFondoUI(index)
    index = math.clamp(tonumber(index) or 1, 1, #BACKGROUND_OPTIONS)
    State.bgFondoIndex = index
    local opt = BACKGROUND_OPTIONS[index]
    State.bgImageId = opt and opt.id or ""
    if bgImage then
        bgImage.Image = menuBackgroundUri()
        bgImage.ImageTransparency = 0
        bgImage.Visible = true
    end
    if ninjaArt then
        ninjaArt.Image = ninjaArtUri() or ""
        ninjaArt.Visible = ninjaArtUri() ~= nil
    end
    SetSetting("bgFondoIndex", index)
    if opt and opt.id then SetSetting("bgImageId", opt.id) end
    if _G._refreshFondoBtns then pcall(_G._refreshFondoBtns) end
end

task.defer(function()
    pcall(function()
        setFondoUI(1)
    end)
end)

applyBgImageLayout()

local bgOverlay = Instance.new("Frame", main)
bgOverlay.Name = "BgOverlay"
bgOverlay.Size = UDim2.new(1, 0, 1, 0)
bgOverlay.Position = UDim2.new(0, 0, 0, 0)
bgOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bgOverlay.BackgroundTransparency = 0.52
bgOverlay.BorderSizePixel = 0
bgOverlay.ZIndex = 1
Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, CORNER)

local guiScaleFactor = _guiUserScale
function applyGuiScale(v)
    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800, 600)
    local maxScale = math.min(1.30, (viewport.X - 20) / W, (viewport.Y - 32) / H)
    maxScale = math.max(0.55, maxScale)
    v = math.clamp(tonumber(v) or _guiUserScale or 0.80, 0.55, maxScale)
    guiScaleFactor = v
    _guiUserScale = v
    State.guiScale = v
    if Config then Config.guiScale = v end
    _refreshMainScale()
    if SetSetting then SetSetting("guiScale", v) end
    pcall(function() if SaveConfig then SaveConfig() end end)
    return v
end

local GradTexts = {}
local function applyTextGradient(lbl, rot)
    if not lbl then return end
    lbl.TextColor3 = ACCENT
    local g = lbl:FindFirstChildWhichIsA("UIGradient")
    if not g then g = Instance.new("UIGradient", lbl) end
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40,40,40)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180,180,180)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(120,120,120)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(30,30,30)),
    })
    g.Rotation = rot or 0
    table.insert(GradTexts, g)
    return g
end
task.spawn(function()
    local t = 0
    while true do
        local dt = RunService.RenderStepped:Wait()
        t = t + dt
        local off = ((t * 0.35) % 2) - 1
        for _, g in ipairs(GradTexts) do
            if g and g.Parent then g.Offset = Vector2.new(off, 0) end
        end
    end
end)

local headerFrame = Instance.new("Frame", main)
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 62)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.ZIndex = 2
Instance.new("UICorner", headerFrame).CornerRadius = UDim.new(0, 24)

local avatarRing = Instance.new("Frame", headerFrame)
avatarRing.Name = "AvatarRing"
avatarRing.Visible = false
avatarRing.Size = UDim2.new(0, 0, 0, 0)
avatarRing.BackgroundTransparency = 1
local avatarStroke = Instance.new("UIStroke", avatarRing)
avatarStroke.Name = "AvatarStroke"
avatarStroke.Enabled = false
local avatarImg = Instance.new("ImageLabel", avatarRing)
avatarImg.Name = "AvatarImage"
avatarImg.Visible = false
_G._avatarStroke = avatarStroke
_G._avatarRing = avatarRing
local headerAccentBar = Instance.new("Frame", headerFrame)
headerAccentBar.Size = UDim2.new(1, 0, 0, 0)
headerAccentBar.Position = UDim2.new(0, 0, 1, -3)
headerAccentBar.BackgroundColor3 = ACCENT
headerAccentBar.BackgroundTransparency = 1
headerAccentBar.Visible = false
headerAccentBar.BorderSizePixel = 0
headerAccentBar.ZIndex = 5
local headerAccentGrad = Instance.new("UIGradient", headerAccentBar)
headerAccentGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,50)),
    ColorSequenceKeypoint.new(0.5, ACCENT),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40,40,50)),
})

local HEADER_LETTER_IDS = {
}

local headerTitleRow = Instance.new("Frame", headerFrame)
headerTitleRow.Name = "HeaderTitleRow"
headerTitleRow.AnchorPoint = Vector2.new(0.5, 0.5)
headerTitleRow.Size = UDim2.new(1, -24, 0, 52)
headerTitleRow.Position = UDim2.new(0.5, 0, 0.5, 0)
headerTitleRow.BackgroundTransparency = 1
headerTitleRow.BorderSizePixel = 0
headerTitleRow.ZIndex = 3
headerTitleRow.ClipsDescendants = false

local lettersRow = Instance.new("Frame", headerTitleRow)
lettersRow.Name = "Letters"
lettersRow.Size = UDim2.new(1, 0, 0, 34)
lettersRow.Position = UDim2.new(0, 0, 0, 0)
lettersRow.BackgroundTransparency = 1
lettersRow.ZIndex = 3

local titleLay = Instance.new("UIListLayout", lettersRow)
titleLay.FillDirection = Enum.FillDirection.Horizontal
titleLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
titleLay.VerticalAlignment = Enum.VerticalAlignment.Center
titleLay.Padding = UDim.new(0, 0)
titleLay.SortOrder = Enum.SortOrder.LayoutOrder

local headerWord = Instance.new("TextLabel", headerTitleRow)
headerWord.Name = "RLM DUELS"
headerWord.Size = UDim2.new(1, 0, 0, 34)
headerWord.Position = UDim2.new(0, 0, 0, 0)
headerWord.BackgroundTransparency = 1
headerWord.Text = "RLM DUELS"
headerWord.TextColor3 = Color3.fromRGB(190, 105, 255)
headerWord.Font = Enum.Font.GothamBlack
headerWord.TextStrokeColor3 = Color3.fromRGB(8, 5, 14)
headerWord.TextStrokeTransparency = 0.08
headerWord.TextSize = 22
headerWord.TextXAlignment = Enum.TextXAlignment.Center
headerWord.ZIndex = 4

local headerLetterImgs = {}
for i, id in ipairs(HEADER_LETTER_IDS) do
    local wrap = Instance.new("Frame", lettersRow)
    wrap.Name = "Letter_" .. tostring(i)
    wrap.Size = UDim2.new(0, 28, 0, 34)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.LayoutOrder = i
    wrap.ZIndex = 3

    local img = Instance.new("ImageLabel", wrap)
    img.Name = "Main"
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.BorderSizePixel = 0
    img.Image = "rbxassetid://" .. id
    img.ImageTransparency = 0
    img.ScaleType = Enum.ScaleType.Fit
    img.ImageColor3 = Color3.fromRGB(190, 105, 255)
    img.ZIndex = 4
    local letterStroke = Instance.new("UIStroke", img)
    letterStroke.Color = Color3.fromRGB(8, 5, 14)
    letterStroke.Thickness = 1.4
    letterStroke.Transparency = 0.08
    table.insert(headerLetterImgs, img)
end

local discordLbl = Instance.new("TextLabel", headerTitleRow)
discordLbl.Name = "Discord"
discordLbl.Size = UDim2.new(1, 0, 0, 14)
discordLbl.Position = UDim2.new(0, 0, 0, 36)
discordLbl.BackgroundTransparency = 1
discordLbl.Text = "discord.gg/RLMDUELS"
discordLbl.TextColor3 = Color3.fromRGB(140, 120, 165)
discordLbl.Font = Enum.Font.Gotham
discordLbl.TextSize = 10
discordLbl.TextXAlignment = Enum.TextXAlignment.Center
discordLbl.ZIndex = 4
_G._catalystDiscordLbl = discordLbl

local TITLE_COLORS = {
    blue  = Color3.fromRGB(65, 145, 255),
    black = Color3.fromRGB(45, 45, 52),
    white = Color3.fromRGB(245, 245, 250),
    -- compatibilidad con configuraciones antiguas
    purple = Color3.fromRGB(190, 105, 255),
    green  = Color3.fromRGB(60, 220, 120),
    red    = Color3.fromRGB(255, 70, 80),
}

function applyTitleColor(name)
    name = (name == "blue" or name == "black" or name == "white" or name == "purple") and name or "blue"
    State.titleColor = name
    Config.menuTheme = name
    _G._catalystThemeName = name
    SetSetting("menuTheme", name)
    SetSetting("titleColor", name)
    local col = TITLE_COLORS[name] or TITLE_COLORS.blue
    for _, img in ipairs(headerLetterImgs) do
        if img and img.Parent then
            if img:IsA("ImageLabel") then
                img.ImageColor3 = col
            elseif img:IsA("TextLabel") then
                img.TextColor3 = col
            end
        end
    end
    pcall(function() if setGuiAccent then setGuiAccent(col) end end)
    pcall(function()
        if miniDot then miniDot.BackgroundColor3 = col end
        if miniStroke then miniStroke.Color = col end
        if miniLabel then miniLabel.TextColor3 = col end
        if applyMiniLogoColor then applyMiniLogoColor() end
        if streetGrad then
            streetGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.45, col),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
        end
    end)
    pcall(function() if applyButtonTheme then applyButtonTheme() end end)
    _G._catalystLogoColor = col
end

pcall(function()
    applyTitleColor(Config.menuTheme or State.titleColor or "blue")
end)

local streetTitleLbl = Instance.new("TextLabel", headerFrame)
streetTitleLbl.Name = "StreetTitle"
streetTitleLbl.AnchorPoint = Vector2.new(0.5, 0.5)
streetTitleLbl.Size = UDim2.new(0.72, 0, 0, 42)
streetTitleLbl.Position = UDim2.new(0.52, 0, 0.5, 2)
streetTitleLbl.BackgroundTransparency = 1
streetTitleLbl.Text = "RLM DUELS"
streetTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
streetTitleLbl.Font = Enum.Font.LuckiestGuy
streetTitleLbl.TextSize = 34
streetTitleLbl.TextScaled = false
streetTitleLbl.TextXAlignment = Enum.TextXAlignment.Center
streetTitleLbl.Visible = false
streetTitleLbl.ZIndex = 8
local streetStroke = Instance.new("UIStroke", streetTitleLbl)
streetStroke.Color = Color3.fromRGB(0, 0, 0)
streetStroke.Thickness = 1.8
streetStroke.Transparency = 0.15
local streetGrad = Instance.new("UIGradient", streetTitleLbl)
streetGrad.Rotation = 90
streetGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.45, ACCENT),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})

function applyUiFontStyle(style)
    style = tostring(style or "normal"):lower()
    if style ~= "callejera" then style = "normal" end
    State.uiFontStyle = style
    SetSetting("uiFontStyle", style)
    local isStreet = (style == "callejera")
    if headerTitleRow then headerTitleRow.Visible = not isStreet end
    if streetTitleLbl then
        streetTitleLbl.Visible = isStreet
        if isStreet then
            streetTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            streetGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.45, ACCENT),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
        end
    end
end

pcall(function()
    applyUiFontStyle(State.uiFontStyle or Config.uiFontStyle or "normal")
end)

local headerTitle = Instance.new("TextLabel", headerFrame)
headerTitle.Name = "HeaderTitle"
headerTitle.Size = UDim2.new(0, 0, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = ""
headerTitle.Visible = false
headerTitle.ZIndex = 1

local headerTitleShadow = headerTitle
local titleStroke = Instance.new("UIStroke", headerTitle)
titleStroke.Enabled = false
local titleGrad = Instance.new("UIGradient", headerTitle)

local function refreshTitleGrad()
    if headerTitleRow then
        headerTitleRow.Visible = true
    end
end
refreshTitleGrad()
_G._refreshTitleGrad = refreshTitleGrad

local headerGlow = Instance.new("Frame", headerFrame)
headerGlow.Name = "HeaderGlow"
headerGlow.Size = UDim2.new(0, 0, 0, 0)
headerGlow.Position = UDim2.new(0, 0, 1, -18)
headerGlow.BackgroundColor3 = ACCENT
headerGlow.BackgroundTransparency = 1
headerGlow.Visible = false
headerGlow.BorderSizePixel = 0
headerGlow.ZIndex = 2
local headerLine = Instance.new("Frame", headerFrame)
headerLine.Name = "AccentLine"
headerLine.Size = UDim2.new(0, 0, 0, 0)
headerLine.Position = UDim2.new(0.25, 0, 1, -2)
headerLine.BackgroundColor3 = ACCENT
headerLine.BackgroundTransparency = 1
headerLine.Visible = false
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 4
Instance.new("UICorner", headerLine).CornerRadius = UDim.new(1, 0)
local contentPanel = Instance.new("Frame", main)
contentPanel.Name = "ContentPanel"
contentPanel.Size = UDim2.new(1, 0, 1, -84)
contentPanel.Position = UDim2.new(0, 0, 0, 62)
contentPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
contentPanel.BackgroundTransparency = 0.72
contentPanel.BorderSizePixel = 0
contentPanel.ClipsDescendants = true
contentPanel.ZIndex = 2
Instance.new("UICorner", contentPanel).CornerRadius = UDim.new(0, 22)
local contentSt = Instance.new("UIStroke", contentPanel)
contentSt.Color = ACCENT
contentSt.Thickness = 1
contentSt.Transparency = 1
contentSt.Enabled = false
contentSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local footerBar = Instance.new("Frame", main)
footerBar.Name = "FooterBar"
footerBar.Size = UDim2.new(1, -16, 0, 0)
footerBar.Position = UDim2.new(0, 8, 1, 0)
footerBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
footerBar.BackgroundTransparency = 1
footerBar.BorderSizePixel = 0
footerBar.Visible = false
footerBar.ZIndex = 6
Instance.new("UICorner", footerBar).CornerRadius = UDim.new(0, 8)
pcall(function()
    local fg = ensureUIGradient(footerBar, 0)
    if fg then fg.Color = softAccentSequence(ACCENT) end
end)
local footerStroke = Instance.new("UIStroke", footerBar)
footerStroke.Color = ACCENT
footerStroke.Thickness = 1
footerStroke.Transparency = 1
footerStroke.Enabled = false
local footerLbl = Instance.new("TextLabel", footerBar)
footerLbl.Size = UDim2.new(1, -12, 1, 0)
footerLbl.Position = UDim2.new(0, 6, 0, 0)
footerLbl.BackgroundTransparency = 1
footerLbl.Text = "discord.gg/RLMDUELS"
footerLbl.TextColor3 = Color3.fromRGB(140, 120, 165)
footerLbl.Font = Enum.Font.Gotham
footerLbl.TextSize = 10
footerLbl.TextXAlignment = Enum.TextXAlignment.Center
footerLbl.ZIndex = 7
_G._catalystFooterLbl = footerLbl
local footerDot = Instance.new("Frame", footerBar)
footerDot.Size = UDim2.new(0, 5, 0, 5)
footerDot.Position = UDim2.new(1, -14, 0.5, -2)
footerDot.Visible = false
footerDot.BackgroundColor3 = Color3.fromRGB(80, 255, 140)
footerDot.BorderSizePixel = 0
footerDot.ZIndex = 8
Instance.new("UICorner", footerDot).CornerRadius = UDim.new(1, 0)
task.spawn(function()
    while footerDot and footerDot.Parent do
        pcall(function()
            TweenService:Create(footerDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0.55
            }):Play()
            task.wait(0.9)
            TweenService:Create(footerDot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                BackgroundTransparency = 0
            }):Play()
            task.wait(0.9)
        end)
    end
end)

task.defer(function()
    if main and main.Parent then
        local sc = main:FindFirstChild("MainScale")
        if sc then
            sc.Scale = 0.92
            TweenService:Create(sc, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = _guiUserScale or 0.80}):Play()
        end
        if _G._catalystFooterLbl then
        end
        task.delay(0.35, function()
            pcall(function()
                if ZenToast then ZenToast("RLM DUELS listo", ACCENT) end
            end)
        end)
    end
end)

local topTabBar = Instance.new("Frame", contentPanel)
topTabBar.Name = "TopTabBar"
topTabBar.Size = UDim2.new(1, -12, 0, 34)
topTabBar.Position = UDim2.new(0, 6, 1, -40)
topTabBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
topTabBar.BackgroundTransparency = 1
topTabBar.BorderSizePixel = 0
topTabBar.ZIndex = 6
Instance.new("UICorner", topTabBar).CornerRadius = UDim.new(0, 8)
local tabBarStroke = Instance.new("UIStroke", topTabBar)
tabBarStroke.Color = ACCENT
tabBarStroke.Thickness = 1
tabBarStroke.Transparency = 1
tabBarStroke.Enabled = false

local topTabLayout = Instance.new("UIListLayout", topTabBar)
topTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
topTabLayout.FillDirection = Enum.FillDirection.Horizontal
topTabLayout.Padding = UDim.new(0, 4)
topTabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
topTabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local topTabPad = Instance.new("UIPadding", topTabBar)
topTabPad.PaddingLeft = UDim.new(0, 5)
topTabPad.PaddingRight = UDim.new(0, 5)
topTabPad.PaddingTop = UDim.new(0, 4)
topTabPad.PaddingBottom = UDim.new(0, 4)

local contentArea = Instance.new("Frame", contentPanel)
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -8, 1, -48)
contentArea.Position = UDim2.new(0, 4, 0, 2)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 3

local pageTitle = Instance.new("TextLabel", contentPanel)
pageTitle.Size = UDim2.new(1, -56, 0, 24)
pageTitle.Position = UDim2.new(0, 12, 0, 8)
pageTitle.BackgroundTransparency = 1
pageTitle.Text = ""
pageTitle.TextColor3 = ACCENT
pageTitle.Font = Enum.Font.GothamBlack
pageTitle.TextSize = 13
pageTitle.TextXAlignment = Enum.TextXAlignment.Left
pageTitle.ZIndex = 4
pageTitle.Visible = false

local function createPage(name)
    local sf=Instance.new("ScrollingFrame",contentArea)
    sf.Name="Page_"..name
    sf.Size=UDim2.new(1,0,1,0)
    sf.Position=UDim2.new(0,0,0,0)
    sf.BackgroundTransparency=1
    sf.BorderSizePixel=0
    sf.ScrollBarThickness=4
    sf.ScrollBarImageColor3=ACCENT
    sf.ScrollBarImageTransparency=0.25
    sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sf.CanvasSize=UDim2.new(0,0,0,0)
    sf.Visible=false
    sf.ZIndex=4
    local lay=Instance.new("UIListLayout",sf); lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,5)
    local pd=Instance.new("UIPadding",sf); pd.PaddingLeft=UDim.new(0,6); pd.PaddingRight=UDim.new(0,6); pd.PaddingTop=UDim.new(0,6); pd.PaddingBottom=UDim.new(0,14)
    local sc=Instance.new("UIScale",sf); sc.Name="PageScale"; sc.Scale=1
    return sf
end

local pageMove=createPage("Move")
local pageMechanics=createPage("Mechanics")
local pageVisuals=createPage("Visuals")
local pageClimas=Instance.new("Frame") -- removed tab (hidden)
pageClimas.Visible=false
local pageConfig=createPage("Config")
local pageMusic=createPage("Music")
local pageKeybinds=createPage("Keybinds")

local ALL_PAGES = {pageMove, pageMechanics, pageVisuals, pageConfig, pageMusic, pageKeybinds}
local PAGE_NAMES = {"Move","Mechanics","Visuals","Config","Música","Keybinds"}

local tabBtns={}
local currentTab = nil -- nil para forzar mostrar Move al iniciar

function styleTab(btn, isActive)
    local g = btn:FindFirstChildOfClass("UIGradient")
    if g then pcall(function() g:Destroy() end) end
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    local st = btn:FindFirstChildWhichIsA("UIStroke")
    if st then st.Enabled = false end
    local border = btn:FindFirstChild("BottomBorder")
    if not border then
        border = Instance.new("Frame")
        border.Name = "BottomBorder"
        border.Size = UDim2.new(0.65, 0, 0, 2)
        border.Position = UDim2.new(0.175, 0, 1, -1)
        border.BorderSizePixel = 0
        border.ZIndex = (btn.ZIndex or 1) + 1
        border.Parent = btn
        Instance.new("UICorner", border).CornerRadius = UDim.new(1, 0)
    end
    if isActive then
        btn.TextColor3 = C_LABEL
        btn.TextTransparency = 0
        btn.Font = Enum.Font.GothamBold
        border.Visible = true
        border.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
        border.BackgroundTransparency = 0
        pcall(function()
            TweenService:Create(border, TweenInfo.new(0.18), {
                BackgroundTransparency = 0.05,
                Size = UDim2.new(0.75, 0, 0, 2)
            }):Play()
        end)
    else
        btn.TextColor3 = Color3.fromRGB(110, 95, 125)
        btn.TextTransparency = 0.15
        btn.Font = Enum.Font.Gotham
        border.Visible = false
        border.BackgroundTransparency = 1
    end
end

local _tabAnimToken = 0
local function setTab(name)
    if currentTab == name then
        for n,btn in pairs(tabBtns) do styleTab(btn, n==name) end
        local pagesFix = {
            Move = pageMove, Mechanics = pageMechanics, Visuals = pageVisuals,
            Config = pageConfig, ["Música"] = pageMusic, Keybinds = pageKeybinds,
        }
        for n,pg in pairs(pagesFix) do
            if pg then pg.Visible = (n == name) end
        end
        return
    end
    local prev = currentTab
    currentTab = name
    State.lastMenuTab = name
    SetSetting("lastMenuTab", name)
    for n,btn in pairs(tabBtns) do
        styleTab(btn, n==name)
    end

    local pages = {
        Move = pageMove,
        Mechanics = pageMechanics,
        Visuals = pageVisuals,
        Config = pageConfig,
        ["Música"] = pageMusic,
        Keybinds = pageKeybinds,
    }
    local oldPage = pages[prev]
    local newPage = pages[name]
    if not newPage then return end

    _tabAnimToken += 1
    local token = _tabAnimToken

    task.spawn(function()
        if oldPage and oldPage.Parent then
            local oldScale = oldPage:FindFirstChild("PageScale")
            TweenService:Create(oldPage, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, -14, 0, 0)
            }):Play()
            if oldScale then
                TweenService:Create(oldScale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Scale = 0.97
                }):Play()
            end
            task.wait(0.11)
            if token ~= _tabAnimToken then return end
            oldPage.Visible = false
            oldPage.Position = UDim2.new(0, 0, 0, 0)
            if oldScale then oldScale.Scale = 1 end
        end

        if token ~= _tabAnimToken then return end
        for n,pg in pairs(pages) do
            if n ~= name and pg then pg.Visible = false end
        end
        newPage.Position = UDim2.new(0, 16, 0, 0)
        local newScale = newPage:FindFirstChild("PageScale")
        if newScale then newScale.Scale = 0.97 end
        newPage.Visible = true
        TweenService:Create(newPage, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        if newScale then
            TweenService:Create(newScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1
            }):Play()
        end
    end)
end

local TAB_SHORT = {
    Move = "↔ Speed",
    Mechanics = "⚙ Ctrl",
    Visuals = "◈ Visual",
    Config = "▣ Config",
    Keybinds = "⌘ Keys",
    ["Música"] = "Music",
}

local function makeTopTab(name, order)
    local b = Instance.new("TextButton", topTabBar)
    b.Name = "Tab_" .. name
    b.Size = UDim2.new(1 / 6, -6, 1, -4)
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = 1
    b.BorderSizePixel = 0
    b.Text = TAB_SHORT[name] or name
    b.TextColor3 = Color3.fromRGB(110, 95, 125)
    b.Font = Enum.Font.Gotham
    b.TextSize = 11
    b.TextTruncate = Enum.TextTruncate.AtEnd
    b.AutoButtonColor = false
    b.LayoutOrder = order
    b.ZIndex = 7
    local border = Instance.new("Frame", b)
    border.Name = "BottomBorder"
    border.Visible = false
    border.BackgroundTransparency = 1
    local st = Instance.new("UIStroke", b)
    st.Enabled = false
    b.MouseButton1Click:Connect(function()
        local sc = b:FindFirstChild("TabAnimScale")
        if not sc then
            sc = Instance.new("UIScale")
            sc.Name = "TabAnimScale"
            sc.Parent = b
        end
        sc.Scale = 0.9
        TweenService:Create(sc, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        setTab(name)
    end)
    b.MouseEnter:Connect(function()
        if currentTab == name then return end
        b.TextColor3 = Color3.fromRGB(210, 190, 255)
    end)
    b.MouseLeave:Connect(function()
        styleTab(b, currentTab == name)
    end)
    tabBtns[name] = b
    if name == "Move" then
        styleTab(b, true)
    end
    return b
end

makeTopTab("Move",1)
makeTopTab("Mechanics",2)
makeTopTab("Visuals",3)
makeTopTab("Keybinds",4)
makeTopTab("Config",5)
makeTopTab("Música",6)

task.defer(function()
    local savedTab = State.lastMenuTab or "Move"
    local validTabs = {Move=true, Mechanics=true, Visuals=true, Config=true, ["Música"]=true, Keybinds=true}
    setTab(validTabs[savedTab] and savedTab or "Move")
end)

local function forEachPageChild(fn)
    for _, pg in ipairs(ALL_PAGES) do
        for _, child in ipairs(pg:GetChildren()) do
            fn(child)
        end
    end
end

local mini=Instance.new("TextButton",gui)
mini.Name="Mini"
mini.Size=UDim2.new(0,152,0,32)
mini.Position=UDim2.new(0,12,0,70)
mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mini.BackgroundTransparency = 0
mini.BorderSizePixel=0
mini.Text=""
mini.AutoButtonColor=false
mini.Visible=false
mini.ZIndex=40

local miniSolid = Instance.new("Frame", mini)
miniSolid.Name = "SolidBlack"
miniSolid.Size = UDim2.new(1, 0, 1, 0)
miniSolid.Position = UDim2.new(0, 0, 0, 0)
miniSolid.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miniSolid.BackgroundTransparency = 0
miniSolid.BorderSizePixel = 0
miniSolid.ZIndex = 40
Instance.new("UICorner", miniSolid).CornerRadius = UDim.new(0, 10)

local cornerMini = Instance.new("UICorner", mini)
cornerMini.CornerRadius = UDim.new(0, 10)

local miniStroke=Instance.new("UIStroke",mini)
miniStroke.Enabled = false
miniStroke.Transparency = 1
miniStroke.Thickness = 0
miniStroke.Color = Color3.fromRGB(0, 0, 0)
miniStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

local miniDot = Instance.new("Frame", mini)
miniDot.Name = "BlinkDot"
miniDot.Size = UDim2.new(0, 5, 0, 5)
miniDot.Position = UDim2.new(0, 12, 0.5, -2.5)
miniDot.BackgroundColor3 = ACCENT
miniDot.BorderSizePixel = 0
miniDot.ZIndex = 42
Instance.new("UICorner", miniDot).CornerRadius = UDim.new(1, 0)

local miniLabel = Instance.new("TextLabel", mini)
miniLabel.Name = "MiniLabel"
miniLabel.Size = UDim2.new(1, -24, 1, 0)
miniLabel.Position = UDim2.new(0, 22, 0, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.Text = "RLM DUELS"
miniLabel.TextColor3 = Color3.fromRGB(190, 105, 255)
miniLabel.Font = Enum.Font.GothamBlack
miniLabel.TextSize = 12
miniLabel.TextStrokeColor3 = Color3.fromRGB(8, 5, 14)
miniLabel.TextStrokeTransparency = 0.08
miniLabel.TextXAlignment = Enum.TextXAlignment.Left
miniLabel.ZIndex = 42

local miniLabelGradient = Instance.new("UIGradient", miniLabel)
miniLabelGradient.Name = "RLMTextShimmer"
miniLabelGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 105, 255)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 105, 255)),
})
miniLabelGradient.Rotation = 0
local miniOpenBtn = Instance.new("TextButton", mini)
miniOpenBtn.Name = "OpenBtn"
miniOpenBtn.Size = UDim2.new(0, 98, 0, 28)
miniOpenBtn.Position = UDim2.new(1, -106, 0.5, -14)
miniOpenBtn.BackgroundColor3 = Color3.fromRGB(12, 7, 20)
miniOpenBtn.BackgroundTransparency = 0
miniOpenBtn.Text = "RLM DUELS"
miniOpenBtn.TextColor3 = Color3.fromRGB(205, 135, 255)
miniOpenBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
miniOpenBtn.TextStrokeTransparency = 0.05
miniOpenBtn.Font = Enum.Font.GothamBlack
miniOpenBtn.TextSize = 11
miniOpenBtn.Visible = false
miniOpenBtn.ZIndex = 43
miniOpenBtn.AutoButtonColor = false
Instance.new("UICorner", miniOpenBtn).CornerRadius = UDim.new(0, 8)
local miniOpenStroke = Instance.new("UIStroke", miniOpenBtn)
miniOpenStroke.Color = Color3.fromRGB(115, 45, 175)
miniOpenStroke.Thickness = 1.5
miniOpenStroke.Transparency = 0.12
local miniOpenGradient = Instance.new("UIGradient", miniOpenBtn)
miniOpenGradient.Name = "RLMShimmer"
miniOpenGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 5, 14)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(44, 18, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 5, 14)),
})
miniOpenGradient.Rotation = 0

local miniLetterRow = Instance.new("Frame", mini)
miniLetterRow.Name = "MiniLetterRow"
miniLetterRow.AnchorPoint = Vector2.new(0.5, 0.5)
miniLetterRow.Size = UDim2.new(0, 136, 0, 22)
miniLetterRow.Position = UDim2.new(0.5, 0, 0.5, 0)
miniLetterRow.BackgroundTransparency = 1
miniLetterRow.BorderSizePixel = 0
miniLetterRow.Visible = false
miniLetterRow.ZIndex = 45
local miniLetterLay = Instance.new("UIListLayout", miniLetterRow)
miniLetterLay.FillDirection = Enum.FillDirection.Horizontal
miniLetterLay.HorizontalAlignment = Enum.HorizontalAlignment.Center
miniLetterLay.VerticalAlignment = Enum.VerticalAlignment.Center
miniLetterLay.Padding = UDim.new(0, 1)
miniLetterLay.SortOrder = Enum.SortOrder.LayoutOrder
local miniLetterImgs = {}
for i, id in ipairs(HEADER_LETTER_IDS) do
    local wrap = Instance.new("Frame", miniLetterRow)
    wrap.Size = UDim2.new(0, 18, 0, 22)
    wrap.BackgroundTransparency = 1
    wrap.BorderSizePixel = 0
    wrap.LayoutOrder = i
    wrap.ZIndex = 45
    local im = Instance.new("ImageLabel", wrap)
    im.Size = UDim2.new(1, 0, 1, 0)
    im.BackgroundTransparency = 1
    im.Image = "rbxassetid://" .. id
    im.ImageColor3 = Color3.fromRGB(255, 255, 255)
    im.ScaleType = Enum.ScaleType.Fit
    im.ZIndex = 46
    table.insert(miniLetterImgs, im)
end
function applyMiniLogoColor()
    local col = ACCENT or Color3.fromRGB(255, 255, 255)
    pcall(function()
        if TITLE_COLORS and State and State.titleColor and TITLE_COLORS[State.titleColor] then
            col = TITLE_COLORS[State.titleColor]
        end
    end)
    for _, im in ipairs(miniLetterImgs) do
        if im and im.Parent then
            if im:IsA("TextLabel") then im.TextColor3 = col
            elseif im:IsA("ImageLabel") then im.ImageColor3 = col end
        end
    end
    if miniDot then miniDot.BackgroundColor3 = col end
    if miniStroke then
        miniStroke.Color = col
        miniStroke.Transparency = 0.3
    end
    if miniLabel then miniLabel.TextColor3 = col end
end
local function showMiniLetters3D()
    if not mini then return end
    mini.Size = UDim2.new(0, 176, 0, 34)
    mini.BackgroundColor3 = Color3.fromRGB(5, 4, 10)
    mini.BackgroundTransparency = 0
    if miniStroke then
        miniStroke.Enabled = true
        miniStroke.Color = Color3.fromRGB(145, 75, 205)
        miniStroke.Thickness = 1.4
        miniStroke.Transparency = 0.12
    end
    local solid = mini:FindFirstChild("SolidBlack")
    if solid then solid.BackgroundTransparency = 0; solid.BackgroundColor3 = Color3.fromRGB(5, 4, 10) end
    if miniLabel then
        miniLabel.Visible = true
        miniLabel.Text = "RLM DUELS"
        miniLabel.Size = UDim2.new(1, -34, 1, 0)
        miniLabel.Position = UDim2.new(0, 28, 0, 0)
        miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        miniLabel.Font = Enum.Font.GothamBlack
        miniLabel.TextSize = 14
        miniLabel.TextStrokeColor3 = Color3.fromRGB(35, 10, 55)
        miniLabel.TextStrokeTransparency = 0.05
        miniLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
    if miniDot then miniDot.Visible = true; miniDot.BackgroundColor3 = Color3.fromRGB(190, 105, 255) end
    if miniOpenBtn then miniOpenBtn.Visible = false end
    if miniZBox then miniZBox.Visible = false end
    if miniModeLbl then miniModeLbl.Visible = false end
    if miniLetterRow then miniLetterRow.Visible = false end
    if miniLabelGradient then
        miniLabelGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 105, 255)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 105, 255)),
        })
    end
end
local function hideMiniLetters3D()
    if miniLetterRow then miniLetterRow.Visible = false end
end

local miniZBox = Instance.new("Frame", mini)
miniZBox.Name = "ZBox"
miniZBox.Size = UDim2.new(0, 26, 0, 26)
miniZBox.Position = UDim2.new(0, 6, 0.5, -13)
miniZBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
miniZBox.BorderSizePixel = 0
miniZBox.Visible = false
miniZBox.ZIndex = 42
Instance.new("UICorner", miniZBox).CornerRadius = UDim.new(0, 7)
local miniZLbl = Instance.new("TextLabel", miniZBox)
miniZLbl.Size = UDim2.new(1, 0, 1, 0)
miniZLbl.BackgroundTransparency = 1
miniZLbl.Text = "Z"
miniZLbl.TextColor3 = Color3.fromRGB(25, 25, 30)
miniZLbl.Font = Enum.Font.GothamBlack
miniZLbl.TextSize = 14
miniZLbl.ZIndex = 43

local miniModeLbl = Instance.new("TextLabel", mini)
miniModeLbl.Name = "ModeHint"
miniModeLbl.Size = UDim2.new(0, 90, 0, 12)
miniModeLbl.Position = UDim2.new(0, 40, 1, -14)
miniModeLbl.BackgroundTransparency = 1
miniModeLbl.Text = ""
miniModeLbl.TextColor3 = Color3.fromRGB(180, 180, 190)
miniModeLbl.Font = Enum.Font.Gotham
miniModeLbl.TextSize = 9
miniModeLbl.TextXAlignment = Enum.TextXAlignment.Left
miniModeLbl.Visible = false
miniModeLbl.ZIndex = 42

local function applyMiniStyle(style)
    style = math.clamp(tonumber(style) or 1, 1, 6)
    State.miniStyle = style
    SetSetting("miniStyle", style)
    if not mini then return end
    if miniStroke then miniStroke.Enabled = false; miniStroke.Transparency = 1 end
    mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mini.BackgroundTransparency = 0
    if style == 1 then
        if showMiniLetters3D then
            showMiniLetters3D()
        else
            mini.Size = UDim2.new(0, 152, 0, 32)
            mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            mini.BackgroundTransparency = 0
            cornerMini.CornerRadius = UDim.new(0, 10)
            miniStroke.Enabled = false
            miniStroke.Transparency = 1
            miniDot.Visible = true
            miniDot.BackgroundColor3 = ACCENT
            miniLabel.Visible = true
            miniLabel.Text = "RLM DUELS"
            miniLabel.TextColor3 = Color3.fromRGB(190, 105, 255)
            miniLabel.Font = Enum.Font.GothamBlack
            miniLabel.TextStrokeColor3 = Color3.fromRGB(8, 5, 14)
            miniLabel.TextStrokeTransparency = 0.08
            miniOpenBtn.Visible = false
            if miniZBox then miniZBox.Visible = false end
            if miniModeLbl then miniModeLbl.Visible = false end
        end
    elseif style == 2 then
        mini.Size = UDim2.new(0, 152, 0, 36)
        mini.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        mini.BackgroundTransparency = 0.08
        cornerMini.CornerRadius = UDim.new(0, 10)
        miniStroke.Color = ACCENT
        miniStroke.Transparency = 0.35
        miniDot.Visible = false
        miniLabel.Visible = true
        miniLabel.Text = "RLM DUELS"
        miniLabel.Size = UDim2.new(1, 0, 1, 0)
        miniLabel.Position = UDim2.new(0, 0, 0, 0)
        miniLabel.TextColor3 = Color3.fromRGB(190, 105, 255)
        miniLabel.TextStrokeColor3 = Color3.fromRGB(8, 5, 14)
        miniLabel.TextStrokeTransparency = 0.08
        miniLabel.Font = Enum.Font.GothamBlack
        miniLabel.TextSize = 13
        miniLabel.TextXAlignment = Enum.TextXAlignment.Center
        miniOpenBtn.Visible = false
        if miniZBox then miniZBox.Visible = false end
        if miniModeLbl then miniModeLbl.Visible = false end
    elseif style == 3 then
        local a = ACCENT
        local dark = Color3.new(
            math.clamp(a.R * 0.16 + 0.04, 0, 1),
            math.clamp(a.G * 0.16 + 0.04, 0, 1),
            math.clamp(a.B * 0.16 + 0.04, 0, 1)
        )
        local mid = Color3.new(
            math.clamp(a.R * 0.32 + 0.07, 0, 1),
            math.clamp(a.G * 0.32 + 0.07, 0, 1),
            math.clamp(a.B * 0.32 + 0.07, 0, 1)
        )
        local lum = a.R * 0.3 + a.G * 0.59 + a.B * 0.11
        mini.Size = UDim2.new(0, 228, 0, 48)
        mini.BackgroundColor3 = mid
        mini.BackgroundTransparency = 0.05
        cornerMini.CornerRadius = UDim.new(0, 14)
        miniStroke.Color = a
        miniStroke.Thickness = 1.6
        miniStroke.Transparency = 0.18
        miniDot.Visible = false
        if miniZBox then
            miniZBox.Visible = true
            miniZBox.Size = UDim2.new(0, 32, 0, 32)
            miniZBox.BackgroundColor3 = a
            miniZBox.Position = UDim2.new(0, 8, 0.5, -16)
            local zl = miniZBox:FindFirstChildOfClass("TextLabel")
            if zl then
                zl.Text = "Z"
                zl.TextColor3 = lum > 0.55 and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(255, 255, 255)
            end
        end
        miniLabel.Visible = true
        miniLabel.Text = "RLM DUELS"
        miniLabel.Size = UDim2.new(0, 100, 1, 0)
        miniLabel.Position = UDim2.new(0, 48, 0, 0)
        miniLabel.TextColor3 = a
        miniLabel.Font = Enum.Font.GothamBlack
        miniLabel.TextSize = 13
        miniLabel.TextXAlignment = Enum.TextXAlignment.Left
        miniOpenBtn.Visible = true
        miniOpenBtn.Size = UDim2.new(0, 98, 0, 28)
        miniOpenBtn.Position = UDim2.new(1, -106, 0.5, -14)
        miniOpenBtn.BackgroundColor3 = Color3.fromRGB(12, 7, 20)
        miniOpenBtn.BackgroundTransparency = 0
        miniOpenBtn.TextColor3 = Color3.fromRGB(205, 135, 255)
        miniOpenBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        miniOpenBtn.TextStrokeTransparency = 0.05
        miniOpenBtn.Text = "RLM DUELS"
        miniOpenBtn.Font = Enum.Font.GothamBlack
        miniOpenBtn.TextSize = 11
        if miniOpenStroke then
            miniOpenStroke.Color = Color3.fromRGB(145, 70, 205)
            miniOpenStroke.Thickness = 1.5
        end
        if miniOpenGradient then
            miniOpenGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.48, a),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
            })
        end
        if miniModeLbl then
            miniModeLbl.Visible = true
            miniModeLbl.TextColor3 = a
            if getSpeedModeLabel then miniModeLbl.Text = getSpeedModeLabel() end
        end
    elseif style == 4 then
        local a = ACCENT
        local lum = a.R * 0.3 + a.G * 0.59 + a.B * 0.11
        mini.Size = UDim2.new(0, 48, 0, 48)
        mini.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        mini.BackgroundTransparency = 0.05
        cornerMini.CornerRadius = UDim.new(1, 0)
        miniStroke.Color = a
        miniStroke.Thickness = 2
        miniStroke.Transparency = 0.15
        miniDot.Visible = false
        if miniZBox then
            miniZBox.Visible = true
            miniZBox.Size = UDim2.new(0, 28, 0, 28)
            miniZBox.Position = UDim2.new(0.5, -14, 0.5, -14)
            miniZBox.BackgroundColor3 = a
            local zl = miniZBox:FindFirstChildOfClass("TextLabel")
            if zl then
                zl.Text = "Z"
                zl.TextSize = 16
                zl.TextColor3 = lum > 0.55 and Color3.fromRGB(15,15,20) or Color3.fromRGB(255,255,255)
            end
        end
        miniLabel.Visible = false
        miniOpenBtn.Visible = false
        if miniModeLbl then miniModeLbl.Visible = false end
    elseif style == 5 then
        local a = ACCENT
        mini.Size = UDim2.new(0, 168, 0, 30)
        mini.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
        mini.BackgroundTransparency = 0.08
        cornerMini.CornerRadius = UDim.new(0, 15)
        miniStroke.Color = a
        miniStroke.Thickness = 1.4
        miniStroke.Transparency = 0.25
        miniDot.Visible = true
        miniDot.BackgroundColor3 = a
        miniDot.Position = UDim2.new(0, 10, 0.5, -3.5)
        if miniZBox then miniZBox.Visible = false end
        miniLabel.Visible = true
        miniLabel.Text = "FPS  --"
        miniLabel.Size = UDim2.new(1, -28, 1, 0)
        miniLabel.Position = UDim2.new(0, 24, 0, 0)
        miniLabel.TextColor3 = a
        miniLabel.Font = Enum.Font.GothamBold
        miniLabel.TextSize = 12
        miniLabel.TextXAlignment = Enum.TextXAlignment.Left
        miniOpenBtn.Visible = false
        if miniModeLbl then miniModeLbl.Visible = false end
    elseif style == 6 then
        local a = ACCENT
        local mid = Color3.new(
            math.clamp(a.R * 0.25 + 0.06, 0, 1),
            math.clamp(a.G * 0.25 + 0.06, 0, 1),
            math.clamp(a.B * 0.25 + 0.06, 0, 1)
        )
        mini.Size = UDim2.new(0, 118, 0, 34)
        mini.BackgroundColor3 = mid
        mini.BackgroundTransparency = 0.05
        cornerMini.CornerRadius = UDim.new(0, 12)
        miniStroke.Color = a
        miniStroke.Thickness = 1.5
        miniStroke.Transparency = 0.2
        miniDot.Visible = false
        if miniZBox then miniZBox.Visible = false end
        miniLabel.Visible = true
        miniLabel.Text = "RLM DUELS"
        miniLabel.Size = UDim2.new(1, -8, 1, 0)
        miniLabel.Position = UDim2.new(0, 8, 0, 0)
        miniLabel.TextColor3 = a
        miniLabel.Font = Enum.Font.GothamBlack
        miniLabel.TextSize = 14
        miniLabel.TextXAlignment = Enum.TextXAlignment.Left
        miniOpenBtn.Visible = false
        if miniModeLbl then miniModeLbl.Visible = false end
    end
    if _G._refreshMiniStyleBtns then pcall(_G._refreshMiniStyleBtns) end
end
_G.applyMiniStyle = applyMiniStyle

task.spawn(function()
    local frames, last = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        if not mini or not mini.Parent then return end
        if (State.miniStyle or 1) ~= 5 or not mini.Visible or not miniLabel then return end
        frames = frames + 1
        local now = os.clock()
        if now - last < 0.5 then return end
        local fps = math.floor(frames / (now - last) + 0.5)
        frames = 0
        last = now
        miniLabel.Text = "FPS  " .. tostring(fps)
    end)
end)
task.spawn(function()
    while mini and mini.Parent do
        if mini.Visible and (State.miniStyle or 1) == 3 and miniModeLbl and miniModeLbl.Visible then
            if getSpeedModeLabel then
                miniModeLbl.Text = getSpeedModeLabel()
            end
        end
        task.wait(0.8)
    end
end)

makeDraggable(mini, mini, function() return State.uiLocked end)
task.spawn(function()
    while miniLabel and miniLabel.Parent and miniLabelGradient and miniLabelGradient.Parent do
        local labelTween = TweenService:Create(miniLabelGradient, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 360})
        labelTween:Play()
        labelTween.Completed:Wait()
        if miniLabelGradient and miniLabelGradient.Parent then miniLabelGradient.Rotation = 0 end
        task.wait(0.12)
    end
end)
task.spawn(function()
    while miniOpenBtn and miniOpenBtn.Parent and miniOpenGradient and miniOpenGradient.Parent do
        local shimmer = TweenService:Create(miniOpenGradient, TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 360})
        shimmer:Play()
        shimmer.Completed:Wait()
        if miniOpenGradient and miniOpenGradient.Parent then miniOpenGradient.Rotation = 0 end
        task.wait(0.15)
    end
end)
miniOpenBtn.MouseButton1Click:Connect(function()
    local sc = miniOpenBtn:FindFirstChildOfClass("UIScale")
    if not sc then sc = Instance.new("UIScale", miniOpenBtn) end
    sc.Scale = 0.88
    TweenService:Create(sc, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    pcall(showGui)
end)
mini.MouseButton1Click:Connect(function()
    local st = State.miniStyle or 1
    if st == 3 then return end -- solo open
    pcall(showGui)
end)
pcall(function() applyMiniStyle(State.miniStyle or 1) end)
mini.MouseEnter:Connect(function()
    TweenService:Create(miniStroke,TweenInfo.new(0.1),{Transparency=0.15, Color=ACCENT}):Play()
    mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mini.BackgroundTransparency = 0
end)
mini.MouseLeave:Connect(function()
    TweenService:Create(miniStroke,TweenInfo.new(0.1),{Transparency=0.35, Color=Color3.fromRGB(40,40,45)}):Play()
    mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mini.BackgroundTransparency = 0
end)

local function showGui()
    if main.Visible then return end
    if isAnimating then return end
    isAnimating = true
    local lockedPos = savedMainPos or main.Position
    main.Position = lockedPos
    main.Rotation = 0
    main.Visible = true
    mini.Visible = false
    pcall(hideMiniLetters3D)
    State.guiVisible = true
    SetSetting("guiVisible", true)
    _guiAnimScale = 0.82; _refreshMainScale()
    main.BackgroundTransparency = 1
    menuBorderLeft.Position = UDim2.new(0.5, -1, 0.12, 0)
    menuBorderRight.Position = UDim2.new(0.5, -1, 0.12, 0)
    menuBorderLeft.BackgroundTransparency = 0.12
    menuBorderRight.BackgroundTransparency = 0.12
    TweenService:Create(menuBorderLeft, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position=UDim2.new(0, 3, 0.12, 0), BackgroundTransparency=0.25}):Play()
    TweenService:Create(menuBorderRight, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position=UDim2.new(1, -5, 0.12, 0), BackgroundTransparency=0.25}):Play()
    pcall(function()
        mini.Visible = false
    end)
    local lockConn
    lockConn = RunService.RenderStepped:Connect(function()
        main.Position = lockedPos
        main.Rotation = 0
    end)
    TweenService:Create(animScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = _guiUserScale}):Play(); task.delay(0.3, function() _guiAnimScale = 1; _refreshMainScale() end)
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()
    if headerLine then
        local oldT = headerLine.BackgroundTransparency
        headerLine.BackgroundTransparency = 0
        TweenService:Create(headerLine, TweenInfo.new(0.45), {BackgroundTransparency = oldT or 0}):Play()
    end
    task.delay(0.3, function()
        if lockConn then lockConn:Disconnect() end
        main.Position = lockedPos
        main.Rotation = 0
        _guiAnimScale = 1; _refreshMainScale()
        isAnimating = false
    end)
end

local function hideGui()
    if not main.Visible then return end
    if isAnimating then return end
    isAnimating = true
    local lockedPos = main.Position
    savedMainPos = lockedPos
    TweenService:Create(menuBorderLeft, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position=UDim2.new(0.5, -1, 0.12, 0), BackgroundTransparency=1}):Play()
    TweenService:Create(menuBorderRight, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position=UDim2.new(0.5, -1, 0.12, 0), BackgroundTransparency=1}):Play()
    pcall(function()
        writefile("KzsHubMainPos.txt", string.format("%.3f,%.1f,%.3f,%.1f",
            lockedPos.X.Scale, lockedPos.X.Offset, lockedPos.Y.Scale, lockedPos.Y.Offset))
    end)
    local lockConn
    lockConn = RunService.RenderStepped:Connect(function()
        main.Position = lockedPos
        main.Rotation = 0
    end)
    TweenService:Create(animScale, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Scale = _guiUserScale * 0.86
    }):Play()
    task.delay(0.28, function()
        _guiAnimScale = 0.86
        _refreshMainScale()
    end)
    TweenService:Create(main, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play()
    task.delay(0.28, function()
        if lockConn then lockConn:Disconnect() end
        main.Visible = false
        main.Rotation = 0
        main.Position = lockedPos
        _guiAnimScale = 1
        _refreshMainScale()
        mini.Visible = true
        pcall(applyMiniStyle, State.miniStyle or 1)
        mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        mini.BackgroundTransparency = 0
        local msc = mini:FindFirstChild("MiniPop")
        if not msc then
            msc = Instance.new("UIScale")
            msc.Name = "MiniPop"
            msc.Parent = mini
        end
        msc.Scale = 0.88
        TweenService:Create(msc, TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(mini, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.12
        }):Play()
        State.guiVisible = false
        SetSetting("guiVisible", false)
        isAnimating = false
    end)
end

local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0,22,0,22)
minBtn.Position = UDim2.new(1,-30,0,14)
minBtn.BackgroundColor3 = Color3.fromRGB(16,16,20)
minBtn.BackgroundTransparency = 0
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(210,210,220)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.AutoButtonColor = false
minBtn.ZIndex = 10
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,10)
local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Color = Color3.fromRGB(0,0,0); minStroke.Thickness = 1; minStroke.Transparency = 0.45
local function makeGuiScaleButton(text, xOffset, delta)
    local b = Instance.new("TextButton", main)
    b.Name = delta < 0 and "GuiScaleDown" or "GuiScaleUp"
    b.Size = UDim2.new(0, 20, 0, 22)
    b.Position = UDim2.new(1, xOffset, 0, 14)
    b.BackgroundColor3 = Color3.fromRGB(20, 12, 30)
    b.BackgroundTransparency = 0
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(225, 195, 255)
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 16
    b.AutoButtonColor = false
    b.ZIndex = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    local outline = Instance.new("UIStroke", b)
    outline.Color = Color3.fromRGB(125, 70, 175)
    outline.Transparency = 0.18
    outline.Thickness = 1
    b.MouseButton1Click:Connect(function()
        applyGuiScale((_guiUserScale or 0.80) + delta)
    end)
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(72, 38, 105)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(20, 12, 30)}):Play()
    end)
end
makeGuiScaleButton("−", -78, -0.10)
makeGuiScaleButton("+", -54, 0.10)
minBtn.MouseEnter:Connect(function()
    TweenService:Create(minBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(0,0,0),BackgroundColor3=ACCENT,BackgroundTransparency=0}):Play()
    TweenService:Create(minStroke,TweenInfo.new(0.1),{Transparency=0.15}):Play()
end)
minBtn.MouseLeave:Connect(function()
    TweenService:Create(minBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(200,200,200),BackgroundColor3=Color3.fromRGB(14,14,14),BackgroundTransparency=0}):Play()
    TweenService:Create(minStroke,TweenInfo.new(0.1),{Transparency=0.45}):Play()
end)
minBtn.MouseButton1Click:Connect(hideGui)
do
    local lastTap, taps = 0, 0
    if headerFrame then
        headerFrame.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            local now = tick()
            taps = (now - lastTap < 0.35) and (taps + 1) or 1
            lastTap = now
            if taps >= 2 then taps = 0; pcall(hideGui) end
        end)
    end
end

mini.MouseButton1Click:Connect(showGui)

makeDraggable(main, main, function() return State.uiLocked end)
task.defer(function()
    local hf = main:FindFirstChild("HeaderFrame")
    if hf then
        pcall(function() hf.Active = true end)
        makeDraggable(hf, main, function() return State.uiLocked end)
    end
end)

function savePos(frame,file) pcall(function() writefile(file,string.format("%.3f,%.1f,%.3f,%.1f",frame.Position.X.Scale,frame.Position.X.Offset,frame.Position.Y.Scale,frame.Position.Y.Offset)) end) end
function loadPos(frame,file) local str; pcall(function() str=readfile(file) end); if str and str~="" then local p={}; for part in string.gmatch(str,"[^,]+") do table.insert(p,tonumber(part)) end; if #p>=4 and p[1] and p[2] and p[3] and p[4] then frame.Position=UDim2.new(p[1],p[2],p[3],p[4]); return true end end; return false end
function loadMainPosition()
    main.AnchorPoint = Vector2.new(0, 0.5)
    if not loadPos(main,"KzsHubMainPos.txt") then
        main.Position = UDim2.new(0, 12, 0.5, 0)
    end
    savedMainPos = main.Position
    if _G._setClassicMainPos then pcall(_G._setClassicMainPos, main.Position) end
end
function loadMiniPosition() loadPos(mini,"KzsHubMiniPos.txt") end
local lastMainSave=0
main:GetPropertyChangedSignal("Position"):Connect(function()
    if isAnimating then return end
    if tick()-lastMainSave>0.5 then
        lastMainSave=tick()
        savedMainPos = main.Position
        savePos(main,"KzsHubMainPos.txt")
    end
end)
local lastMiniSave=0; mini:GetPropertyChangedSignal("Position"):Connect(function() if tick()-lastMiniSave>0.5 then lastMiniSave=tick(); savePos(mini,"KzsHubMiniPos.txt") end end)

local keybindChipRefs={}

local _visualCtrlGui = nil
local _visualCtrlConn = nil

local function _clearVisualControlsGui()
    if _visualCtrlConn then
        pcall(function() _visualCtrlConn:Disconnect() end)
        _visualCtrlConn = nil
    end
    if _visualCtrlGui then
        pcall(function() _visualCtrlGui:Destroy() end)
        _visualCtrlGui = nil
    end
    pcall(function()
        local old = workspace:FindFirstChild("CatalystVisualLockPart")
        if old then old:Destroy() end
    end)
end

function stopVisualControls()
    _clearVisualControlsGui()
    State.visualControlsEnabled = false
    SetSetting("visualControlsEnabled", false)
end

local function _attachVisualControlsTo(char)
    _clearVisualControlsGui()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then
        head = char:WaitForChild("Head", 3)
    end
    if not head then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "CatalystVisualControls"
    bb.Adornee = head
    bb.Size = UDim2.new(0, 20, 0, 20)
    bb.StudsOffset = Vector3.new(0, 2.6, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 120
    bb.LightInfluence = 0
    bb.Parent = head
    _visualCtrlGui = bb

    local ring = Instance.new("Frame", bb)
    ring.Name = "Ring"
    ring.AnchorPoint = Vector2.new(0.5, 0.5)
    ring.Size = UDim2.new(0, 16, 0, 16)
    ring.Position = UDim2.new(0.5, 0, 0.5, 0)
    ring.BackgroundTransparency = 1
    ring.BorderSizePixel = 0
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke", ring)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1.4
    stroke.Transparency = 0.05

    local dot = Instance.new("Frame", bb)
    dot.Name = "Dot"
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Size = UDim2.new(0, 2, 0, 2)
    dot.Position = UDim2.new(0.5, 0, 0.5, 0)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BackgroundTransparency = 0
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
end

function startVisualControls()
    State.visualControlsEnabled = true
    SetSetting("visualControlsEnabled", true)

    local char = LP.Character
    if char then
        _attachVisualControlsTo(char)
    end

    if _visualCtrlConn then
        pcall(function() _visualCtrlConn:Disconnect() end)
        _visualCtrlConn = nil
    end
    _visualCtrlConn = LP.CharacterAdded:Connect(function(c)
        if not State.visualControlsEnabled then return end
        task.wait(0.35)
        _attachVisualControlsTo(c)
    end)
end

function setVisualControls(on)
    if on then
        startVisualControls()
    else
        stopVisualControls()
    end
end

function makeSectionLabel(text, parent)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.LayoutOrder = #parent:GetChildren() + 1

    local bar = Instance.new("Frame", row)
    bar.Size = UDim2.new(0, 3, 0, 14)
    bar.Position = UDim2.new(0, 4, 0.5, -7)
    bar.BackgroundColor3 = ACCENT
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local barG = Instance.new("UIGradient", bar)
    barG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    barG.Rotation = 90

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0, 160, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = string.upper(tostring(text or ""))
    lbl.TextColor3 = Color3.fromRGB(210, 175, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTransparency = 0

    local line = Instance.new("Frame", row)
    line.Size = UDim2.new(1, -185, 0, 1)
    line.Position = UDim2.new(0, 175, 0.5, 0)
    line.BackgroundColor3 = ACCENT
    line.BackgroundTransparency = 0.72
    line.BorderSizePixel = 0
    local lg = Instance.new("UIGradient", line)
    lg.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 1),
    })
    return row
end

function makeGap(parent,height)
    local f=Instance.new("Frame",parent); f.Size=UDim2.new(1,0,0,height or 2); f.BackgroundTransparency=1; f.BorderSizePixel=0; f.LayoutOrder=#parent:GetChildren()+1
end

function makeInputRow(label,defaultValue,onChange,parent)
    local row=Instance.new("Frame",parent); row.Name="InputRow"; row.Size=UDim2.new(1,0,0,30); row.BackgroundColor3=Color3.fromRGB(0,0,0); row.BackgroundTransparency=0; row.BorderSizePixel=0; row.LayoutOrder=#parent:GetChildren()+1;
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local rowStroke=Instance.new("UIStroke",row); rowStroke.Color=Color3.fromRGB(45, 30, 70); rowStroke.Thickness=1; rowStroke.Transparency=0.55
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.55,0,1,0); lbl.Position=UDim2.new(0,10,0,0); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C_LABEL; lbl.Font=Enum.Font.Gotham; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local box=Instance.new("TextBox",row); box.Size=UDim2.new(0,48,0,20); box.Position=UDim2.new(1,-56,0.5,-10); box.BackgroundColor3=Color3.fromRGB(8,9,14); box.BackgroundTransparency=0.05; box.BorderSizePixel=0; box.Text=tostring(defaultValue); box.TextColor3=C_LABEL; box.Font=Enum.Font.Gotham; box.TextSize=12; box.ClearTextOnFocus=true
    Instance.new("UICorner",box).CornerRadius=UDim.new(0,8); local stroke=Instance.new("UIStroke",box); stroke.Color=ACCENT; stroke.Transparency=0.6; stroke.Thickness=1
    box.Focused:Connect(function() TweenService:Create(stroke,TweenInfo.new(0.15),{Color=ACCENT}):Play() end)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(box.Text)
        if num and onChange then
            onChange(math.clamp(num, 0, 500))
        end
    end)
    box.FocusLost:Connect(function()
        TweenService:Create(stroke,TweenInfo.new(0.15),{Color=Color3.fromRGB(0,0,0)}):Play()
        local num = tonumber(box.Text)
        if num then
            local final = math.clamp(num, 0, 500)
            box.Text = tostring(final)
            if onChange then onChange(final) end
            AutoSave()
        else
            box.Text = tostring(defaultValue)
        end
    end)
    row.MouseEnter:Connect(function() TweenService:Create(rowStroke,TweenInfo.new(0.1),{Transparency=0.4}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(rowStroke,TweenInfo.new(0.1),{Transparency=0.65}):Play() end)
    return box
end

local function createCarouselSelector(parent, currentValue, options, onChanged)
    options = options or {}
    local selectedIndex = 1
    for i, opt in ipairs(options) do
        if tostring(opt) == tostring(currentValue) then
            selectedIndex = i
            break
        end
    end

    local nOpts = math.max(#options, 1)
    -- ancho según texto más largo
    local maxLen = 3
    for _, o in ipairs(options) do
        maxLen = math.max(maxLen, #tostring(o))
    end
    local midW = math.clamp(maxLen * 7 + 8, 36, 72)
    local totalW = midW + 36

    local frame = Instance.new("Frame", parent)
    frame.Name = "CarouselSelector"
    frame.Size = UDim2.new(0, totalW, 0, 22)
    frame.AnchorPoint = Vector2.new(1, 0.5)
    frame.Position = UDim2.new(1, -10, 0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.ZIndex = 8
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

    local st = Instance.new("UIStroke", frame)
    st.Color = ACCENT
    st.Thickness = 1
    st.Transparency = 0.35
    st.Name = "SelectStroke"

    local left = Instance.new("TextButton", frame)
    left.Name = "Left"
    left.Size = UDim2.new(0, 16, 1, 0)
    left.Position = UDim2.new(0, 1, 0, 0)
    left.BackgroundTransparency = 1
    left.Text = "‹"
    left.TextColor3 = Color3.fromRGB(150, 140, 165)
    left.Font = Enum.Font.GothamBold
    left.TextSize = 13
    left.AutoButtonColor = false
    left.ZIndex = 10

    local right = Instance.new("TextButton", frame)
    right.Name = "Right"
    right.Size = UDim2.new(0, 16, 1, 0)
    right.Position = UDim2.new(1, -17, 0, 0)
    right.BackgroundTransparency = 1
    right.Text = "›"
    right.TextColor3 = Color3.fromRGB(150, 140, 165)
    right.Font = Enum.Font.GothamBold
    right.TextSize = 13
    right.AutoButtonColor = false
    right.ZIndex = 10

    local mid = Instance.new("TextButton", frame)
    mid.Name = "Mid"
    mid.Size = UDim2.new(1, -34, 1, 0)
    mid.Position = UDim2.new(0, 17, 0, 0)
    mid.BackgroundTransparency = 1
    mid.Text = tostring(options[selectedIndex] or "")
    mid.Font = Enum.Font.GothamBold
    mid.TextSize = 11
    mid.TextColor3 = C_LABEL
    mid.TextTruncate = Enum.TextTruncate.AtEnd
    mid.AutoButtonColor = false
    mid.ZIndex = 10

    -- proxy oculto para API .Text (refresh externos)
    local btn = Instance.new("TextButton")
    btn.Name = "Proxy"
    btn.BackgroundTransparency = 1
    btn.Text = mid.Text
    btn.Visible = false
    btn.Parent = frame

    local _syncing = false
    local function paint()
        mid.Text = tostring(options[selectedIndex] or "")
        mid.TextColor3 = C_LABEL
        mid.Font = Enum.Font.GothamBold
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        st.Color = ACCENT
        st.Transparency = 0.35
        _syncing = true
        btn.Text = mid.Text
        _syncing = false
    end

    local function flash()
        local sc = frame:FindFirstChild("CarAnimScale")
        if not sc then
            sc = Instance.new("UIScale", frame)
            sc.Name = "CarAnimScale"
        end
        sc.Scale = 0.94
        TweenService:Create(sc, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
        frame.BackgroundColor3 = Color3.fromRGB(28, 18, 42)
        mid.TextColor3 = Color3.fromRGB(255, 255, 255)
        st.Transparency = 0.1
        task.delay(0.12, function()
            if frame and frame.Parent then paint() end
        end)
    end

    local function cycle(dir)
        if nOpts < 1 then return end
        selectedIndex = ((selectedIndex - 1 + (dir or 1)) % nOpts) + 1
        paint()
        flash()
        if onChanged then pcall(onChanged, options[selectedIndex], selectedIndex) end
    end

    left.MouseButton1Click:Connect(function() cycle(-1) end)
    right.MouseButton1Click:Connect(function() cycle(1) end)
    mid.MouseButton1Click:Connect(function() cycle(1) end)

    left.MouseEnter:Connect(function() left.TextColor3 = ACCENT end)
    left.MouseLeave:Connect(function() left.TextColor3 = Color3.fromRGB(150, 140, 165) end)
    right.MouseEnter:Connect(function() right.TextColor3 = ACCENT end)
    right.MouseLeave:Connect(function() right.TextColor3 = Color3.fromRGB(150, 140, 165) end)
    frame.MouseEnter:Connect(function()
        TweenService:Create(st, TweenInfo.new(0.1), {Transparency = 0.12}):Play()
    end)
    frame.MouseLeave:Connect(function()
        TweenService:Create(st, TweenInfo.new(0.1), {Transparency = 0.35}):Play()
    end)

    btn:GetPropertyChangedSignal("Text"):Connect(function()
        if _syncing then return end
        local t = tostring(btn.Text or "")
        for i, opt in ipairs(options) do
            if tostring(opt) == t then
                selectedIndex = i
                paint()
                break
            end
        end
    end)

    paint()
    return btn
end

local _holidayOriginals = setmetatable({}, {__mode = "k"})
local _holidaySnowGui = nil
local function setHolidayMode(enabled)
    local holidayGreen = Color3.fromRGB(18, 74, 48)
    local holidayRed = Color3.fromRGB(176, 38, 54)
    local holidayGold = Color3.fromRGB(232, 190, 92)
    local roots = {}
    pcall(function()
        local cg = game:GetService("CoreGui")
        for _, item in ipairs(cg:GetChildren()) do
            if item:IsA("ScreenGui") then table.insert(roots, item) end
        end
    end)
    pcall(function()
        local pg = LP:FindFirstChildOfClass("PlayerGui")
        if pg then for _, item in ipairs(pg:GetChildren()) do
            if item:IsA("ScreenGui") then table.insert(roots, item) end
        end end
    end)
    if enabled then
        for _, root in ipairs(roots) do
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("GuiObject") then
                    if not _holidayOriginals[obj] then
                        local saved = {bg=obj.BackgroundColor3}
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                            saved.text = obj.TextColor3
                            if obj:IsA("TextButton") then saved.buttonText = obj.Text end
                        end
                        _holidayOriginals[obj] = saved
                    end
                    local orig = _holidayOriginals[obj].bg
                    if obj:IsA("TextButton") then
                        local baseText = _holidayOriginals[obj].buttonText or ""
                        if baseText ~= "" and not baseText:find("🎄", 1, true) then obj.Text = "🎄 " .. baseText end
                    end
                    if orig then
                        if orig.R < 0.18 and orig.G < 0.18 and orig.B < 0.22 then obj.BackgroundColor3 = holidayGreen
                        elseif orig.R > 0.68 and orig.G > 0.68 and orig.B > 0.68 then obj.BackgroundColor3 = holidayGold end
                    end
                    if obj:IsA("UIStroke") then
                        if not _holidayOriginals[obj] then _holidayOriginals[obj] = {color=obj.Color} end
                        obj.Color = holidayRed
                    end
                elseif obj:IsA("UIStroke") then
                    if not _holidayOriginals[obj] then _holidayOriginals[obj] = {color=obj.Color} end
                    obj.Color = holidayRed
                end
            end
        end
        pcall(function()
            if _holidaySnowGui then _holidaySnowGui:Destroy() end
            local sg = Instance.new("ScreenGui")
            sg.Name = "RLMHolidaySnow"
            sg.ResetOnSpawn = false
            sg.IgnoreGuiInset = true
            sg.DisplayOrder = 10000
            pcall(function() sg.Parent = game:GetService("CoreGui") end)
            if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end
            _holidaySnowGui = sg
            -- Guirnalda superior con bombillas que cambian de color y pulsan.
            local bulbs = {}
            local bulbColors = {Color3.fromRGB(255,60,70), Color3.fromRGB(60,220,120), Color3.fromRGB(255,210,70), Color3.fromRGB(90,180,255)}
            for i = 1, 18 do
                local bulb = Instance.new("Frame")
                bulb.Name = "HolidayLight"
                bulb.Size = UDim2.fromOffset(9, 12)
                bulb.Position = UDim2.new((i-1)/17, -4, 0, 3)
                bulb.BackgroundColor3 = bulbColors[(i-1)%#bulbColors+1]
                bulb.BorderSizePixel = 0
                bulb.ZIndex = 10001
                bulb.Parent = sg
                Instance.new("UICorner", bulb).CornerRadius = UDim.new(1,0)
                local glow = Instance.new("UIStroke", bulb)
                glow.Color = bulb.BackgroundColor3
                glow.Thickness = 2
                glow.Transparency = 0.25
                bulbs[i] = {part=bulb,stroke=glow,index=(i-1)%#bulbColors+1}
            end
            task.spawn(function()
                while sg.Parent do
                    for _, light in ipairs(bulbs) do
                        if not sg.Parent then break end
                        light.index = light.index % #bulbColors + 1
                        local color = bulbColors[light.index]
                        TweenService:Create(light.part,TweenInfo.new(0.38,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundColor3=color,Size=UDim2.fromOffset(10,14)}):Play()
                        TweenService:Create(light.stroke,TweenInfo.new(0.38),{Color=color,Transparency=0.05}):Play()
                        task.wait(0.11)
                        if light.part.Parent then TweenService:Create(light.part,TweenInfo.new(0.4),{Size=UDim2.fromOffset(8,10)}):Play() end
                    end
                    task.wait(0.12)
                end
            end)
            task.spawn(function()
                while sg.Parent do
                    local flake = Instance.new("TextLabel")
                    flake.BackgroundTransparency = 1
                    flake.Text = ({"❄", "✦", "❅"})[math.random(1,3)]
                    flake.TextColor3 = Color3.fromRGB(255,255,255)
                    flake.TextTransparency = 0.22
                    flake.TextSize = math.random(12,22)
                    flake.Size = UDim2.fromOffset(28,28)
                    flake.Position = UDim2.new(math.random(),0,-0.06,0)
                    flake.ZIndex = 10000
                    flake.Parent = sg
                    TweenService:Create(flake,TweenInfo.new(math.random(5,9),Enum.EasingStyle.Linear),{Position=UDim2.new(flake.Position.X.Scale+math.random(-8,8)/100,0,1.08,0),Rotation=math.random(-120,120),TextTransparency=0.55}):Play()
                    task.delay(9,function() if flake.Parent then flake:Destroy() end end)
                    task.wait(0.28)
                end
            end)
        end)
    else
        for obj, props in pairs(_holidayOriginals) do
            pcall(function()
                if props.bg then obj.BackgroundColor3 = props.bg end
                if props.color then obj.Color = props.color end
                if props.text then obj.TextColor3 = props.text end
                if props.buttonText and obj:IsA("TextButton") then obj.Text = props.buttonText end
            end)
        end
        if _holidaySnowGui then pcall(function() _holidaySnowGui:Destroy() end); _holidaySnowGui = nil end
    end
end

function makeToggleRow(label,defaultValue,onToggle,parent,keybindStateKey)
    local row=Instance.new("Frame",parent)
    row.Name="ToggleRow"
    row.Size=UDim2.new(1,0,0,30)
    row.BackgroundColor3=Color3.fromRGB(0,0,0)
    row.BackgroundTransparency=0
    row.BorderSizePixel=0
    row.LayoutOrder=#parent:GetChildren()+1
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,10)
    local rowStroke=Instance.new("UIStroke",row)
    rowStroke.Color=Color3.fromRGB(0,0,0)
    rowStroke.Thickness=1
    rowStroke.Transparency=0.2
    local rowGradient = Instance.new("UIGradient", row)
    rowGradient.Name = "PressedPurpleBlend"
    rowGradient.Color = defaultValue and ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 6, 14)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(48, 22, 72)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 6, 14)),
    }) or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 11)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 11)),
    })
    local activeUnderline = Instance.new("Frame", row)
    activeUnderline.Name = "ActiveUnderline"
    activeUnderline.AnchorPoint = Vector2.new(0, 1)
    activeUnderline.Position = UDim2.new(0, 10, 1, -2)
    activeUnderline.Size = UDim2.new(defaultValue and 0.72 or 0.18, 0, 0, 2)
    activeUnderline.BackgroundColor3 = Color3.fromRGB(190, 105, 255)
    activeUnderline.BackgroundTransparency = defaultValue and 0.05 or 0.55
    activeUnderline.BorderSizePixel = 0
    activeUnderline.ZIndex = 4
    Instance.new("UICorner", activeUnderline).CornerRadius = UDim.new(1, 0)
    local underlineGradient = Instance.new("UIGradient", activeUnderline)
    underlineGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 35, 135)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(225, 185, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 55, 185)),
    })

    local lblW=keybindStateKey and 0.48 or 0.65
    local lbl=Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(lblW,0,1,0)
    lbl.Position=UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency=1
    lbl.Text=label
    lbl.TextColor3=C_LABEL
    lbl.Font=Enum.Font.Gotham
    lbl.TextSize=12
    lbl.TextTransparency=0
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.TextTransparency=0

    if keybindStateKey then
        local currentKey=State[keybindStateKey]
        local keyName=(currentKey and currentKey~=Enum.KeyCode.Unknown) and currentKey.Name or "-"
        local chip=Instance.new("TextButton",row)
        chip.Size=UDim2.new(0,32,0,12)
        chip.Position=UDim2.new(1,-78,0.5,-6)
        chip.BackgroundColor3=Color3.fromRGB(0,0,0)
        chip.BorderSizePixel=0
        chip.Text=keyName
        chip.TextColor3=C_LABEL
        chip.Font=Enum.Font.Gotham
        chip.TextSize=11
        chip.AutoButtonColor=false
        chip.ZIndex=20
        Instance.new("UICorner",chip).CornerRadius=UDim.new(0,3)
        local cStroke=Instance.new("UIStroke",chip)
        cStroke.Color=Color3.fromRGB(40,40,40)
        cStroke.Thickness=1
        keybindChipRefs[keybindStateKey]=chip
        local listening=false
        local lConn=nil
        local function stopListen(key)
            listening=false
            if lConn then lConn:Disconnect(); lConn=nil end
            chip.TextColor3=C_LABEL
            if key then
                State[keybindStateKey]=key
                chip.Text=key.Name
                SetSetting(keybindStateKey, key.Name)
                AutoSave()
            else
                local k=State[keybindStateKey]
                chip.Text=(k and k~=Enum.KeyCode.Unknown) and k.Name or "-"
            end
        end
        chip.MouseButton1Click:Connect(function()
            if listening then stopListen(nil); return end
            listening=true
            chip.Text="..."
            lConn=UIS.InputBegan:Connect(function(inp,gp)
                if not listening then return end
                if inp.UserInputType==Enum.UserInputType.Keyboard then
                    if inp.KeyCode==Enum.KeyCode.Escape then stopListen(nil); return end
                    stopListen(inp.KeyCode)
                end
            end)
        end)
    end

    -- switch pill (track negro + bolita accent)
    local pill = Instance.new("Frame", row)
    pill.Name = "Track"
    pill.Size = UDim2.new(0, 38, 0, 20)
    pill.AnchorPoint = Vector2.new(1, 0.5)
    pill.Position = UDim2.new(1, -12, 0.5, 0)
    pill.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    pill.BackgroundTransparency = 0
    pill.BorderSizePixel = 0
    pill.ZIndex = 8
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local uiStroke = Instance.new("UIStroke", pill)
    uiStroke.Color = defaultValue and ACCENT or Color3.fromRGB(40, 35, 50)
    uiStroke.Thickness = 1
    uiStroke.Transparency = defaultValue and 0.2 or 0.35
    uiStroke.Name = "PillStroke"
    local dot = Instance.new("Frame", pill)
    dot.Name = "Knob"
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = defaultValue and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    dot.BackgroundColor3 = defaultValue and ACCENT or Color3.fromRGB(85, 85, 95)
    dot.BorderSizePixel = 0
    dot.ZIndex = 9
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local shine = Instance.new("Frame", dot)
    shine.Name = "Shine"
    shine.Size = UDim2.new(1, -4, 0, 4)
    shine.Position = UDim2.new(0, 2, 0, 2)
    shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    shine.BackgroundTransparency = 0.72
    shine.BorderSizePixel = 0
    shine.ZIndex = 10
    Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)

    local isOn = defaultValue
    local function setV(on)
        isOn = on
        local ti = TweenInfo.new(0.28, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        rowGradient.Color = on and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 6, 14)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(55, 24, 82)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 6, 14)),
        }) or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 11)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 25)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 11)),
        })
        TweenService:Create(activeUnderline, ti, {
            Size = UDim2.new(on and 0.72 or 0.18, 0, 0, 2),
            BackgroundTransparency = on and 0.02 or 0.55,
        }):Play()
        TweenService:Create(rowStroke, ti, {
            Color = on and Color3.fromRGB(155, 85, 215) or Color3.fromRGB(0, 0, 0),
            Transparency = on and 0.05 or 0.2,
            Thickness = on and 1.3 or 1,
        }):Play()
        TweenService:Create(dot, ti, {
            Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = on and ACCENT or Color3.fromRGB(85, 85, 95),
        }):Play()
        TweenService:Create(pill, ti, {
            BackgroundColor3 = Color3.fromRGB(10, 10, 14),
            BackgroundTransparency = 0,
        }):Play()
        TweenService:Create(uiStroke, ti, {
            Color = on and ACCENT or Color3.fromRGB(40, 35, 50),
            Transparency = on and 0.2 or 0.35,
            Thickness = 1,
        }):Play()
        lbl.TextColor3 = C_LABEL
        lbl.TextTransparency = 0
    end

    local clk = Instance.new("TextButton", pill)
    clk.Size = UDim2.new(1, 0, 1, 0)
    clk.BackgroundTransparency = 1
    clk.Text = ""
    clk.AutoButtonColor = false
    clk.ZIndex = 11
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 12
    local function doToggle()
        isOn = not isOn
        setV(isOn)
        if onToggle then onToggle(isOn) end
        AutoSave()
    end
    clk.MouseButton1Click:Connect(doToggle)
    btn.MouseButton1Click:Connect(doToggle)
    row.MouseEnter:Connect(function()
        TweenService:Create(rowStroke, TweenInfo.new(0.1), {Transparency = 0}):Play()
    end)
    row.MouseLeave:Connect(function()
        TweenService:Create(rowStroke, TweenInfo.new(0.1), {Transparency = 0.2}):Play()
    end)
    table.insert(toggleColorRefs, {
        apply = function()
            local on = isOn
            rowGradient.Color = on and ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 6, 14)),
                ColorSequenceKeypoint.new(0.48, Color3.fromRGB(55, 24, 82)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 6, 14)),
            }) or ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 11)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 25)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 11)),
            })
            activeUnderline.Size = UDim2.new(on and 0.72 or 0.18, 0, 0, 2)
            activeUnderline.BackgroundTransparency = on and 0.02 or 0.55
            rowStroke.Color = on and Color3.fromRGB(155, 85, 215) or Color3.fromRGB(0, 0, 0)
            rowStroke.Transparency = on and 0.05 or 0.2
            pill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            uiStroke.Color = on and ACCENT or Color3.fromRGB(0, 0, 0)
            dot.BackgroundColor3 = on and ACCENT or Color3.fromRGB(70, 70, 78)
            dot.Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            lbl.TextColor3 = C_LABEL
        end
    })
    return setV
end

function makeDropActionRow(label, parent)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,26); row.BackgroundColor3=C_ROW; row.BackgroundTransparency=TRANSPARENCY_ROW; row.BorderSizePixel=0; row.LayoutOrder=#parent:GetChildren()+1;
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,12)
    local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.65,0,1,0); lbl.Position=UDim2.new(0,4,0,0); lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=C_LABEL; lbl.Font=Enum.Font.Gotham; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local actionBtn=Instance.new("TextButton",row); actionBtn.Size=UDim2.new(0,36,0,16); actionBtn.Position=UDim2.new(1,-42,0.5,-8); actionBtn.BackgroundColor3=PITCH_BLACK; actionBtn.BackgroundTransparency=0; actionBtn.BorderSizePixel=0; actionBtn.Text="BURST"; actionBtn.TextColor3=C_LABEL; actionBtn.Font=Enum.Font.Gotham; actionBtn.TextSize=12; actionBtn.ZIndex=20
    Instance.new("UICorner",actionBtn).CornerRadius=UDim.new(0,3); Instance.new("UIStroke",actionBtn).Color=Color3.fromRGB(0,0,0)
    actionBtn.MouseButton1Click:Connect(function()
        runDropBrainrot()
        TweenService:Create(actionBtn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(150,0,0)}):Play()
        TweenService:Create(actionBtn,TweenInfo.new(0.08),{Size = UDim2.new(0, 40, 0, 18)}):Play()
        task.delay(0.12, function()
            TweenService:Create(actionBtn,TweenInfo.new(0.08),{BackgroundColor3=PITCH_BLACK}):Play()
            TweenService:Create(actionBtn,TweenInfo.new(0.08),{Size = UDim2.new(0, 36, 0, 16)}):Play()
        end)
    end)
    row.MouseEnter:Connect(function() TweenService:Create(rowStroke,TweenInfo.new(0.1),{Transparency=0.4}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(rowStroke,TweenInfo.new(0.1),{Transparency=0.65}):Play() end)
    return actionBtn
end

function makeSkyDropdown(parent, selectedIndex, onSelect)
    selectedIndex = math.clamp(tonumber(selectedIndex) or 1, 1, #SKY_THEMES)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1,0,0,22)
    frame.BackgroundColor3 = C_ROW
    frame.BackgroundTransparency = TRANSPARENCY_ROW
    frame.BorderSizePixel = 0
    frame.LayoutOrder = #parent:GetChildren()+1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -28, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = (SKY_THEMES[selectedIndex] and SKY_THEMES[selectedIndex].name) or "Sky"
    lbl.TextColor3 = C_LABEL
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize =  12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local arrow = Instance.new("TextButton", frame)
    arrow.Size = UDim2.new(0, 22, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▾"
    arrow.TextColor3 = ACCENT
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 12
    arrow.ZIndex = 10

    local dropFrame = Instance.new("ScrollingFrame", gui)
    dropFrame.Name = "SkyDropdown"
    dropFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    dropFrame.BackgroundTransparency = 0.05
    dropFrame.BorderSizePixel = 0
    dropFrame.ClipsDescendants = true
    dropFrame.Visible = false
    dropFrame.ZIndex = 120
    dropFrame.ScrollBarThickness = 4
    dropFrame.ScrollBarImageColor3 = ACCENT
    dropFrame.CanvasSize = UDim2.new(0, 0, 0, #SKY_THEMES * 20 + 8)
    dropFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 12)
    local dropStroke = Instance.new("UIStroke", dropFrame)
    dropStroke.Color = ACCENT
    dropStroke.Thickness = 1
    dropStroke.Transparency = 0.4
    local dropLayout = Instance.new("UIListLayout", dropFrame)
    dropLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dropLayout.Padding = UDim.new(0, 2)
    local dropPad = Instance.new("UIPadding", dropFrame)
    dropPad.PaddingTop = UDim.new(0, 4)
    dropPad.PaddingBottom = UDim.new(0, 4)
    dropPad.PaddingLeft = UDim.new(0, 4)
    dropPad.PaddingRight = UDim.new(0, 4)

    local themeBtns = {}
    for i, theme in ipairs(SKY_THEMES) do
        local row = Instance.new("TextButton", dropFrame)
        row.Size = UDim2.new(1, -8, 0, 18)
        row.BackgroundColor3 = (i == selectedIndex) and Color3.fromRGB(40, 40, 48) or Color3.fromRGB(18, 18, 22)
        row.BackgroundTransparency = 0
        row.BorderSizePixel = 0
        row.LayoutOrder = i
        row.ZIndex = 121
        row.Text = ""
        row.AutoButtonColor = false
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        local dot = Instance.new("Frame", row)
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 6, 0.5, -3.5)
        dot.BackgroundColor3 = theme.dot
        dot.BorderSizePixel = 0
        dot.ZIndex = 122
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        local nameLbl = Instance.new("TextLabel", row)
        nameLbl.Size = UDim2.new(1, -20, 1, 0)
        nameLbl.Position = UDim2.new(0, 18, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = theme.name
        nameLbl.TextColor3 = (i == selectedIndex) and Color3.fromRGB(255,255,255) or Color3.fromRGB(170,170,180)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 10
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 122
        themeBtns[i] = row
        local capturedIdx = i
        row.MouseButton1Click:Connect(function()
            lbl.Text = theme.name
            dropFrame.Visible = false
            for j, btn in pairs(themeBtns) do
                local on = (j == capturedIdx)
                btn.BackgroundColor3 = on and Color3.fromRGB(40, 40, 48) or Color3.fromRGB(18, 18, 22)
                local nl = btn:FindFirstChildOfClass("TextLabel")
                if nl then nl.TextColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(170,170,180) end
            end
            if onSelect then onSelect(capturedIdx) end
        end)
    end

    local maxH = math.min(220, #SKY_THEMES * 20 + 12)
    dropFrame.Size = UDim2.new(0, CONTENT_WIDTH - 4, 0, maxH)

    local function openDrop()
        if dropFrame.Visible then
            dropFrame.Visible = false
            return
        end
        local absPos = frame.AbsolutePosition
        local absSize = frame.AbsoluteSize
        local cam = workspace.CurrentCamera
        local vh = cam and cam.ViewportSize.Y or 600
        local below = absPos.Y + absSize.Y + 4
        if below + maxH > vh - 8 then
            dropFrame.Position = UDim2.new(0, absPos.X, 0, math.max(8, absPos.Y - maxH - 4))
        else
            dropFrame.Position = UDim2.new(0, absPos.X, 0, below)
        end
        dropFrame.Visible = true
    end
    arrow.MouseButton1Click:Connect(openDrop)
    frame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            openDrop()
        end
    end)
    UIS.InputBegan:Connect(function(inp)
        if dropFrame.Visible and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            task.defer(function()
                if dropFrame.Visible then
                    local m = UIS:GetMouseLocation()
                    local pos, size = dropFrame.AbsolutePosition, dropFrame.AbsoluteSize
                    local fpos, fsize = frame.AbsolutePosition, frame.AbsoluteSize
                    local inDrop = m.X >= pos.X and m.X <= pos.X+size.X and m.Y >= pos.Y and m.Y <= pos.Y+size.Y
                    local inFrame = m.X >= fpos.X and m.X <= fpos.X+fsize.X and m.Y >= fpos.Y and m.Y <= fpos.Y+fsize.Y
                    if not inDrop and not inFrame then dropFrame.Visible = false end
                end
            end)
        end
    end)
    return function(idx)
        idx = math.clamp(tonumber(idx) or 1, 1, #SKY_THEMES)
        lbl.Text = SKY_THEMES[idx].name
    end
end

local mbScaleFactor = 1.0
local applyMBScale

local currentCat = ("Speed")
function refreshUIToggles()
    if State.laggerLevel > 0 then
        modeValLbl.Text = "Lagger " .. State.laggerLevel
    else
        modeValLbl.Text = (State.speedType == "normal" and "Normal" or "Carry")
    end
end

local playerData = {}
local playerSPConnections = {}
local playerSPRenderConn = nil
local playerSPRunning = false

local _hitboxInit = (type(Config.hitboxColor)=="table" and Config.hitboxColor[1]) and Color3.fromRGB(Config.hitboxColor[1], Config.hitboxColor[2], Config.hitboxColor[3]) or Color3.fromRGB(180, 180, 180)
local ESP_CONFIG = {
    CircleSize = 32,
    AvatarOffset = 3.0,
    LineColor = Color3.fromRGB(235, 235, 235),
    LineThickness = 2.6,
    BoxColor = Color3.fromRGB(235, 235, 235),
    BoxThickness = 2,
    FontSize = 11,
    NameOffset = 4,
}

local function createPlayerSPBillboard(player, char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local existing = head:FindFirstChild("MiniAvatarESP")
    if existing then existing:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MiniAvatarESP"
    billboard.Size = UDim2.new(0, 86, 0, 110)
    billboard.StudsOffset = Vector3.new(0, ESP_CONFIG.AvatarOffset, 0)
    billboard.AlwaysOnTop = true
    billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboard.Parent = head

    local container = Instance.new("Frame", billboard)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false

    local circleSize = ESP_CONFIG.CircleSize
    local radius = circleSize / 2

    -- card fondo
    local card = Instance.new("Frame", container)
    card.Name = "Card"
    card.Size = UDim2.new(1, 0, 0, 48)
    card.Position = UDim2.new(0, 0, 0, circleSize - 6)
    card.BackgroundColor3 = Color3.fromRGB(8, 6, 14)
    card.BackgroundTransparency = 0.25
    card.BorderSizePixel = 0
    card.ZIndex = 1
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local cardSt = Instance.new("UIStroke", card)
    cardSt.Color = Color3.fromRGB(255, 255, 255)
    cardSt.Thickness = 1
    cardSt.Transparency = 0.35

    local circleBg = Instance.new("Frame", container)
    circleBg.Size = UDim2.new(0, circleSize, 0, circleSize)
    circleBg.Position = UDim2.new(0.5, -radius, 0, 0)
    circleBg.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
    circleBg.BackgroundTransparency = 0.1
    circleBg.BorderSizePixel = 0
    circleBg.ZIndex = 3

    local corner = Instance.new("UICorner", circleBg)
    corner.CornerRadius = UDim.new(1, 0)

    local stroke = Instance.new("UIStroke", circleBg)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.15

    local glowStroke = Instance.new("UIStroke", circleBg)
    glowStroke.Color = Color3.fromRGB(120, 40, 220)
    glowStroke.Thickness = 4
    glowStroke.Transparency = 0.55
    glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local avatarImage = Instance.new("ImageLabel", circleBg)
    avatarImage.Size = UDim2.new(1, -4, 1, -4)
    avatarImage.Position = UDim2.new(0, 2, 0, 2)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ZIndex = 2

    local avatarUrl = string.format(
        "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png",
        player.UserId
    )
    avatarImage.Image = avatarUrl

    local nameLabel = Instance.new("TextLabel", container)
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.Position = UDim2.new(0, 0, 0, circleSize + ESP_CONFIG.NameOffset)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName or player.Name
    nameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = ESP_CONFIG.FontSize
    nameLabel.TextColor3 = Color3.fromRGB(240, 230, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextScaled = false
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.ZIndex = 3

    return billboard
end

local function createPlayerSPBox(char)
    if not char then return end
    local existing = char:FindFirstChild("RedESPBox")
    if existing then existing:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Name = "RedESPBox"
    highlight.Adornee = char
    highlight.FillColor = ESP_CONFIG.BoxColor
    highlight.OutlineColor = Color3.fromRGB(0,0,0)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
    return highlight
end

local function setupPlayerESP(player)
    if player == LP then return end
    if playerData[player] then return end

    local data = {
        Line = nil,
        Billboard = nil,
        Box = nil,
        Connections = {},
    }

    local segs = {}
    for i = 1, 3 do
        local line = Drawing.new("Line")
        line.Thickness = (i == 2) and 2.4 or 1.8
        line.Transparency = 0.15 + (i - 1) * 0.08
        line.Visible = false
        table.insert(segs, line)
    end
    data.LineSegs = segs
    data.Line = segs[1] -- compat setHitboxColor / remove

    local charAddedConn = player.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        local box = createPlayerSPBox(char)
        if box then data.Box = box end

        char:GetPropertyChangedSignal("Parent"):Connect(function()
            if not char.Parent then
                if data.Billboard then pcall(function() data.Billboard:Destroy() end); data.Billboard = nil end
                if data.Box then pcall(function() data.Box:Destroy() end); data.Box = nil end
            end
        end)
    end)

    table.insert(data.Connections, charAddedConn)

    local nameChangedConn = player:GetPropertyChangedSignal("DisplayName"):Connect(function()
        if data.Billboard then
            local nameLabel = data.Billboard:FindFirstChildWhichIsA("TextLabel")
            if nameLabel then nameLabel.Text = player.DisplayName end
        end
    end)
    table.insert(data.Connections, nameChangedConn)

    if player.Character then
        task.wait(0.2)
        local box = createPlayerSPBox(player.Character)
        if box then data.Box = box end
    end

    playerData[player] = data
end

local function removePlayerESP(player)
    if playerData[player] then
        if playerData[player].LineSegs then
            for _, ln in ipairs(playerData[player].LineSegs) do
                pcall(function() ln:Remove() end)
            end
        elseif playerData[player].Line then
            pcall(function() playerData[player].Line:Remove() end)
        end
        if playerData[player].Billboard then
            pcall(function() playerData[player].Billboard:Destroy() end)
        end
        if playerData[player].Box then
            pcall(function() playerData[player].Box:Destroy() end)
        end
        for _, conn in ipairs(playerData[player].Connections or {}) do
            pcall(function() conn:Disconnect() end)
        end
        playerData[player] = nil
    end
end

local function updatePlayerSPLines()
    local myChar = LP.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local base = (ESP_CONFIG and ESP_CONFIG.LineColor) or Color3.fromRGB(180, 180, 180)
    local bright = Color3.new(
        math.min(1, base.R * 1.35 + 0.15),
        math.min(1, base.G * 1.35 + 0.15),
        math.min(1, base.B * 1.35 + 0.15)
    )

    local function hideSegs(data)
        if data.LineSegs then
            for _, ln in ipairs(data.LineSegs) do ln.Visible = false end
        elseif data.Line then
            data.Line.Visible = false
        end
    end

    if not myHrp then
        for _, data in pairs(playerData) do hideSegs(data) end
        return
    end

    local cam = workspace.CurrentCamera
    if not cam then return end
    local myPos, visible = cam:WorldToViewportPoint(myHrp.Position)
    if not visible then
        for _, data in pairs(playerData) do hideSegs(data) end
        return
    end

    local from = Vector2.new(myPos.X, myPos.Y)
    for player, data in pairs(playerData) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local targetPos, visible2 = cam:WorldToViewportPoint(hrp.Position)
            if visible2 and data.LineSegs then
                local to = Vector2.new(targetPos.X, targetPos.Y)
                local n = #data.LineSegs
                for i, ln in ipairs(data.LineSegs) do
                    local t0 = (i - 1) / n
                    local t1 = i / n
                    local a = from:Lerp(to, t0)
                    local b = from:Lerp(to, t1)
                    local col = bright:Lerp(base, (i - 1) / math.max(1, n - 1))
                    ln.From = a
                    ln.To = b
                    ln.Color = col
                    ln.Visible = true
                end
            else
                hideSegs(data)
            end
        else
            hideSegs(data)
        end
    end
end

local function startPlayerSP()
    if playerSPRunning then return end
    playerSPRunning = true

    for _, player in ipairs(getPlayersCached()) do
        if player ~= LP then
            setupPlayerESP(player)
        end
    end

    if playerSPRenderConn then playerSPRenderConn:Disconnect() end
    do local _spa = 0
    playerSPRenderConn = RunService.Heartbeat:Connect(function(dt)
        if _G.__CATALYST_BOOTING then return end
        _spa = _spa + (dt or 0.016)
        if _spa < 0.12 then return end
        _spa = 0
        pcall(updatePlayerSPLines)
    end) end

    local playerAddedConn = Players.PlayerAdded:Connect(function(p)
        if p ~= LP then setupPlayerESP(p) end
    end)
    table.insert(playerSPConnections, playerAddedConn)

    local playerRemovingConn = Players.PlayerRemoving:Connect(function(p)
        removePlayerESP(p)
    end)
    table.insert(playerSPConnections, playerRemovingConn)

    local charAddedConn = LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        for player, data in pairs(playerData) do
            if player.Character then
                local bill = createPlayerSPBillboard(player, player.Character)
                if bill then
                    if data.Billboard then pcall(function() data.Billboard:Destroy() end) end
                    data.Billboard = bill
                end
                local box = createPlayerSPBox(player.Character)
                if box then
                    if data.Box then pcall(function() data.Box:Destroy() end) end
                    data.Box = box
                end
            end
        end
    end)
    table.insert(playerSPConnections, charAddedConn)
end

local function stopPlayerSP()
    if not playerSPRunning then return end
    playerSPRunning = false

    if playerSPRenderConn then
        playerSPRenderConn:Disconnect()
        playerSPRenderConn = nil
    end

    for _, conn in ipairs(playerSPConnections) do
        pcall(function() conn:Disconnect() end)
    end
    playerSPConnections = {}

    for player, data in pairs(playerData) do
        removePlayerESP(player)
    end
    playerData = {}
end

if State.playerSPEnabled then
    -- startPlayerSP disabled
end

local musicPageRebuild = nil

function makeKeybindRow(label, stateKey, parent)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    row.BackgroundTransparency = 0.18
    row.BorderSizePixel = 0
    row.LayoutOrder = #parent:GetChildren() + 1
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)
    local rowStroke = Instance.new("UIStroke", row)
    rowStroke.Color = ACCENT
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.72
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C_LABEL
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local cur = State[stateKey]
    local kn = (cur and cur ~= Enum.KeyCode.Unknown) and cur.Name or "-"
    local chip = Instance.new("TextButton", row)
    chip.Size = UDim2.new(0, 64, 0, 20)
    chip.Position = UDim2.new(1, -72, 0.5, -10)
    chip.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
    chip.BackgroundTransparency = 0.05
    chip.Text = kn
    chip.TextColor3 = ACCENT
    chip.Font = Enum.Font.GothamBold
    chip.TextSize = 10
    chip.AutoButtonColor = false
    Instance.new("UICorner", chip).CornerRadius = UDim.new(0, 8)
    local cst = Instance.new("UIStroke", chip)
    cst.Color = ACCENT
    cst.Transparency = 0.6
    cst.Thickness = 1
    keybindChipRefs[stateKey] = chip
    chip.MouseButton1Click:Connect(function()
        chip.Text = "..."
        local conn
        conn = UIS.InputBegan:Connect(function(inp, gp)
            if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
            local key = inp.KeyCode
            if key == Enum.KeyCode.Escape then
                local k = State[stateKey]
                chip.Text = (k and k ~= Enum.KeyCode.Unknown) and k.Name or "-"
                conn:Disconnect()
                return
            end
            State[stateKey] = key
            chip.Text = key.Name
            SetSetting(stateKey, key.Name)
            AutoSave()
            conn:Disconnect()
        end)
    end)
end

do
    local songs = {
        { name = "Koddy G - Hagalo", url = "https://files.catbox.moe/gp4f24.mp3", file = "catalyst/hagalo.mp3" },
        { name = "Laja-Setadora", url = "https://files.catbox.moe/94olvv.mp3", file = "Seteadora.mp3" },
        { name = "DUKI, Myke Towers - Nueva", url = "https://files.catbox.moe/cb88xa.mp3" },
        { name = "Gra Gra Boom", url = "https://files.catbox.moe/vy21x7.mp3" },
        { name = "LAJA - NADIE TA FRIO", url = "https://files.catbox.moe/ecc674.mp3" },
        { name = "Katya Lel", url = "https://files.catbox.moe/lg4en9.mp3" },
        { name = "Montagem Supersonic", url = "https://files.catbox.moe/rlykfl.mp3" },
        { name = "NO ERA AMOR", url = "https://files.catbox.moe/6x3ori.mp3" },
        { name = "KING NASIR DANCE", url = "https://files.catbox.moe/y62e3y.mp3" },
        { name = "Pibble Song", url = "https://files.catbox.moe/eixg9d.mp3" },
        { name = "Esclava", url = "https://files.catbox.moe/cdsh6o.mp3" },
        { name = "I Will Survive", url = "https://files.catbox.moe/65sjh6.mp3" },
        { name = "siinamota", url = "https://files.catbox.moe/8lnwtq.mp3" },
        { name = "Tuff Song", url = "https://files.catbox.moe/rvf2vy.mp3", file = "catalyst_tuffsong.mp3" },
        { name = "orula", url = "https://files.catbox.moe/v20ko9.mp3", file = "catalyst_orula.mp3" },
        { name = "X.O.X.O", url = "https://files.catbox.moe/jghp0f.mp3", file = "catalyst_xoxosong.mp3" },
        { name = "beretta", url = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", file = "catalyst_beretta.mp3", startAt = 10 },
        { name = "to the O", url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", file = "catalyst_to_the_o.mp3" },
        { name = "LAJA", url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3", file = "catalyst_laja.mp3" },
        { name = "HORA 0", url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3", file = "catalyst_hora_0.mp3" },
        { name = "Lucid Dreams", url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", file = "catalyst_lucid_dreams.mp3" },
        { name = "EL CHIRICUAZO", url = "https://files.catbox.moe/va3lhi.mp3", file = "chiricuazo_v2.mp3" },
        { name = "el de la R", url = "https://files.catbox.moe/u67vx5.mp3", file = "eldelaR.mp3" },
        { name = "WOW", url = "https://files.catbox.moe/14rdtj.mp3", file = "WOW.mp3" },
        { name = "El Hijo del 7", url = "https://files.catbox.moe/wpbab3.mp3", file = "elhijodel7.mp3" },
        { name = "corrido del 30", url = "https://files.catbox.moe/pf9kd9.mp3", file = "corrido_del_30.mp3" },
    }

    local PURPLE = Color3.fromRGB(230, 185, 55)
    local BG = Color3.fromRGB(12, 12, 16)
    local PANEL = Color3.fromRGB(20, 20, 26)
    local ROW = Color3.fromRGB(28, 28, 36)
    local ROW_ON = Color3.fromRGB(48, 34, 72)
    local TEXT = Color3.fromRGB(242, 242, 250)
    local MUTED = Color3.fromRGB(130, 130, 145)

    local M = {
        gui = nil, sound = nil, current = 0, playing = false,
        vol = 0.5, rows = {}, nowLbl = nil, playBtn = nil, dot = nil, volLbl = nil, requestId = 0, loading = false, error = nil,
    }
    pcall(function()
        if State and tonumber(State.musicVolume) then M.vol = tonumber(State.musicVolume) end
    end)

    local isfile_ = isfile or function() return false end
    local getcustomasset_ = getcustomasset
    local getsynasset_ = getsynasset

    pcall(function()
        if typeof(makefolder) == "function" then
            if not (typeof(isfolder) == "function" and isfolder("catalyst")) then
                makefolder("catalyst")
            end
        end
    end)

    local function ac()
        local ok, c = pcall(function() return ACCENT end)
        if ok and typeof(c) == "Color3" then return c end
        return PURPLE
    end

    local function stopAll()
        M.requestId = M.requestId + 1
        if M.sound then
            pcall(function() M.sound:Stop() end)
            pcall(function() M.sound:Destroy() end)
            M.sound = nil
        end
        M.playing = false
        M.loading = false
        M.error = nil
    end

    local function refreshUI()
        for i, row in pairs(M.rows) do
            if row and row.Parent then
                local on = (M.current == i and (M.playing or M.loading))
                row.BackgroundColor3 = on and ROW_ON or ROW
                local badge = row:FindFirstChild("Badge")
                local nameLbl = row:FindFirstChild("NameLbl")
                if badge then
                    badge.Visible = true
                    badge.Text = on and (M.loading and "…" or "❚❚") or "▶"
                    badge.TextColor3 = on and ac() or MUTED
                end
                if nameLbl then nameLbl.TextColor3 = on and Color3.fromRGB(255,255,255) or TEXT end
            end
        end
        if M.volLbl then
            M.volLbl.Text = tostring(math.floor(M.vol * 100 + 0.5)) .. "%"
        end
        if M.dot then
            M.dot.BackgroundColor3 = M.playing and Color3.fromRGB(90, 220, 130) or Color3.fromRGB(70, 70, 80)
        end
        if M.playBtn then
            M.playBtn.Text = M.playing and "❚❚" or "▶"
        end
        if M.nowLbl then
            M.nowLbl.TextColor3 = M.error and Color3.fromRGB(255, 145, 145) or TEXT
            if M.error then
                M.nowLbl.Text = M.error
            elseif M.loading and M.current > 0 and songs[M.current] then
                M.nowLbl.Text = "Cargando: " .. songs[M.current].name
            elseif M.current > 0 and songs[M.current] then
                M.nowLbl.Text = (M.playing and "♪ " or "Pausa: ") .. songs[M.current].name
            else
                M.nowLbl.Text = "Elige una canción"
            end
        end
    end

    local function audioValido(data)
        if type(data) ~= "string" or #data < 800 then return false end
        local head = data:sub(1, 256)
        local low = head:lower()
        if low:find("<html", 1, true) or low:find("<!doctype", 1, true)
            or low:find("access denied", 1, true) or low:find("not found", 1, true) then
            return false
        end
        local b1, b2 = data:byte(1, 2)
        return head:sub(1, 3) == "ID3"
            or (b1 == 0xFF and b2 and b2 >= 0xE0)
            or head:sub(1, 4) == "OggS"
            or (head:sub(1, 4) == "RIFF" and head:sub(9, 12) == "WAVE")
            or head:sub(1, 4) == "fLaC"
    end

    local function existeArchivo(path)
        if type(isfile_) ~= "function" then return false end
        local ok, exists = pcall(isfile_, path)
        return ok and exists == true
    end

    local function registrarAudio(path)
        local funcs = {}
        if type(getcustomasset_) == "function" then table.insert(funcs, getcustomasset_) end
        if type(getsynasset_) == "function" and getsynasset_ ~= getcustomasset_ then
            table.insert(funcs, getsynasset_)
        end
        for _, fn in ipairs(funcs) do
            local ok, asset = pcall(fn, path)
            if ok and type(asset) == "string" and asset ~= "" then return asset end
            ok, asset = pcall(fn, "./" .. path)
            if ok and type(asset) == "string" and asset ~= "" then return asset end
        end
        return nil
    end

    local function resolveSoundId(song, requestId)
        local url = song.url
        if not url or url == "" then return nil, "Canción sin enlace" end
        if string.sub(url, 1, 13) == "rbxassetid://" then return url end
        if string.sub(url, 1, 11) == "rbxasset://" then return url end
        if string.sub(url, 1, 7) ~= "http://" and string.sub(url, 1, 8) ~= "https://" then
            return nil, "Enlace de audio inválido"
        end
        if type(getcustomasset_) ~= "function" and type(getsynasset_) ~= "function" then
            return nil, "Executor sin audio local"
        end

        local match = string.match(url, "([^/]+)$") or ("t" .. tostring(math.random(10000, 99999)) .. ".mp3")
        match = string.gsub(match, "%%20", "_")
        match = string.gsub(match, "[^%w%._%-]", "_")
        if not string.find(match, "%.mp3") then match = match .. ".mp3" end
        local path = "catalyst/music_" .. match
        local fallbackPath = "catalyst_music_" .. match

        -- Reutilizar la caché actual y también los archivos de la versión anterior.
        local candidatos = {path, fallbackPath}
        if song.file and song.file ~= path then table.insert(candidatos, song.file) end
        for _, candidate in ipairs(candidatos) do
            if existeArchivo(candidate) then
                local valid = true
                if type(readfile) == "function" then
                    local ok, data = pcall(readfile, candidate)
                    if ok then valid = audioValido(data) end
                end
                if valid then
                    local asset = registrarAudio(candidate)
                    if asset then return asset end
                end
            end
        end

        if type(writefile) ~= "function" then return nil, "Executor sin guardado de archivos" end
        pcall(function()
            if type(makefolder) == "function" then
                if not (type(isfolder) == "function" and isfolder("catalyst")) then
                    makefolder("catalyst")
                end
            end
        end)

        local requestFns = {}
        local function addRequest(fn)
            if type(fn) ~= "function" then return end
            for _, existing in ipairs(requestFns) do if existing == fn then return end end
            table.insert(requestFns, fn)
        end
        addRequest(request)
        addRequest(http_request)
        if type(syn) == "table" then addRequest(syn.request) end
        if type(http) == "table" then addRequest(http.request) end
        if type(fluxus) == "table" then addRequest(fluxus.request) end

        local body, status = nil, nil
        for _, req in ipairs(requestFns) do
            local ok, response = pcall(req, {
                Url = url,
                Method = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8" }
            })
            if requestId ~= M.requestId then return nil, "Cancelado" end
            if ok and type(response) == "table" then
                local code = tonumber(response.StatusCode or response.Status or response.status_code)
                if code then status = code end
                local candidate = response.Body or response.body
                if (not code or code == 0 or (code >= 200 and code < 300)) and audioValido(candidate) then
                    body = candidate
                    break
                end
            elseif ok and audioValido(response) then
                body = response
                break
            end
        end
        if not body then
            local ok, candidate = pcall(function() return game:HttpGet(url, true) end)
            if requestId ~= M.requestId then return nil, "Cancelado" end
            if ok and audioValido(candidate) then body = candidate end
        end
        if not body then
            if status == 404 then return nil, "Enlace no disponible (404)" end
            return nil, "No se pudo descargar el audio"
        end

        local okWrite = pcall(writefile, path, body)
        if not okWrite then
            path = fallbackPath
            okWrite = pcall(writefile, path, body)
        end
        if not okWrite then return nil, "No se pudo guardar el audio" end
        local asset = registrarAudio(path)
        if asset then return asset end
        return nil, "No se pudo registrar el audio"
    end

    local function msPlay(idx)
        stopAll()
        local requestId = M.requestId
        local song = songs[idx]
        if not song then return end
        M.current = idx
        M.loading = true
        M.error = nil
        refreshUI()

        local okId, id, reason = pcall(resolveSoundId, song, requestId)
        if requestId ~= M.requestId then return end
        if not okId or not id then
            M.loading = false
            M.error = okId and (reason or "No se pudo cargar") or "Error al preparar el audio"
            warn("[RLM DUELS MUSIC] " .. song.name .. ": " .. M.error)
            refreshUI()
            return
        end

        local sound = Instance.new("Sound")
        sound.Name = "CatalystMusic"
        sound.Volume = math.clamp(tonumber(M.vol) or 0.5, 0, 1)
        sound.PlaybackSpeed = 1
        sound.Looped = false
        sound.SoundId = id
        local parented = false
        for _, parent in ipairs({
            game:GetService("SoundService"),
            game:GetService("Workspace"),
            LP and LP:FindFirstChild("PlayerGui"),
            LP,
            game:GetService("CoreGui"),
        }) do
            if parent and not parented then
                local okP = pcall(function() sound.Parent = parent end)
                if okP and sound.Parent then parented = true end
            end
        end
        if not parented then
            pcall(function() sound:Destroy() end)
            M.loading = false
            M.error = "No se pudo iniciar el sonido"
            refreshUI()
            return
        end

        M.sound = sound
        M.playing = true
        sound.Ended:Connect(function()
            if M.sound ~= sound or not M.playing then return end
            M.loading = false
            M.playing = false
            local n = M.current + 1
            if n > #songs then n = 1 end
            msPlay(n)
        end)
        refreshUI()
        -- Una sola llamada a Play: al cargar, Roblox continúa sin reiniciar la canción.
        local okPlay = pcall(function() sound:Play() end)
        if not okPlay then
            stopAll()
            M.error = "No se pudo iniciar el sonido"
            refreshUI()
            return
        end
        task.spawn(function()
            local t0 = tick()
            while M.sound == sound and sound.Parent and not sound.IsLoaded and tick() - t0 < 20 do
                task.wait(0.1)
            end
            if M.sound ~= sound or not sound.Parent then return end
            if not sound.IsLoaded then
                stopAll()
                M.error = "El audio no cargó"
                refreshUI()
                return
            end
            if song.startAt and song.startAt > 0 then
                pcall(function() sound.TimePosition = song.startAt end)
            end
            M.loading = false
            refreshUI()
        end)
    end

    -- La interfaz completa vive dentro de pageMusic; no se abre otra ventana.
    local function buildMusicPage()
        if not pageMusic or not pageMusic.Parent then return end
        M.vol = math.clamp(tonumber(State.musicVolume) or M.vol, 0, 1)
        if M.sound then M.sound.Volume = M.vol end
        for _, child in ipairs(pageMusic:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
                child:Destroy()
            end
        end
        M.rows = {}
        M.nowLbl = nil
        M.playBtn = nil
        M.dot = nil
        M.volLbl = nil

        makeSectionLabel("Music", pageMusic)

        local status = Instance.new("Frame", pageMusic)
        status.Name = "MusicStatus"
        status.Size = UDim2.new(1, 0, 0, 34)
        status.BackgroundColor3 = PANEL
        status.BorderSizePixel = 0
        status.LayoutOrder = #pageMusic:GetChildren() + 1
        Instance.new("UICorner", status).CornerRadius = UDim.new(0, 8)

        local dot = Instance.new("Frame", status)
        dot.Size = UDim2.new(0, 7, 0, 7)
        dot.Position = UDim2.new(0, 10, 0.5, -3)
        dot.BackgroundColor3 = MUTED
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        M.dot = dot

        local nowLbl = Instance.new("TextLabel", status)
        nowLbl.Size = UDim2.new(1, -78, 1, 0)
        nowLbl.Position = UDim2.new(0, 24, 0, 0)
        nowLbl.BackgroundTransparency = 1
        nowLbl.Text = "Elige una canción"
        nowLbl.TextColor3 = TEXT
        nowLbl.Font = Enum.Font.GothamMedium
        nowLbl.TextSize = 11
        nowLbl.TextXAlignment = Enum.TextXAlignment.Left
        nowLbl.TextTruncate = Enum.TextTruncate.AtEnd
        M.nowLbl = nowLbl

        local volLbl = Instance.new("TextLabel", status)
        volLbl.Size = UDim2.new(0, 48, 1, 0)
        volLbl.Position = UDim2.new(1, -53, 0, 0)
        volLbl.BackgroundTransparency = 1
        volLbl.TextColor3 = MUTED
        volLbl.Font = Enum.Font.GothamBold
        volLbl.TextSize = 10
        volLbl.TextXAlignment = Enum.TextXAlignment.Right
        M.volLbl = volLbl

        local controls = Instance.new("Frame", pageMusic)
        controls.Name = "MusicControls"
        controls.Size = UDim2.new(1, 0, 0, 32)
        controls.BackgroundTransparency = 1
        controls.BorderSizePixel = 0
        controls.LayoutOrder = #pageMusic:GetChildren() + 1
        local controlsLayout = Instance.new("UIListLayout", controls)
        controlsLayout.FillDirection = Enum.FillDirection.Horizontal
        controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        controlsLayout.Padding = UDim.new(0, 3)
        controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local function mkControl(text, order, bg, textColor)
            local button = Instance.new("TextButton", controls)
            button.Name = "MusicControl" .. order
            button.Size = UDim2.new(1 / 6, -3, 1, 0)
            button.LayoutOrder = order
            button.BackgroundColor3 = bg or ROW
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = textColor or TEXT
            button.Font = Enum.Font.GothamBold
            button.TextSize = 12
            button.AutoButtonColor = true
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            return button
        end
        local prevBtn = mkControl("‹", 1)
        local playBtn = mkControl("▶", 2, Color3.fromRGB(60, 44, 95))
        local nextBtn = mkControl("›", 3)
        local volD = mkControl("−", 4)
        local volU = mkControl("+", 5)
        local stopBtn = mkControl("■", 6, Color3.fromRGB(55, 32, 38), Color3.fromRGB(255, 140, 140))
        M.playBtn = playBtn

        prevBtn.MouseButton1Click:Connect(function()
            local i = M.current - 1
            if i < 1 then i = #songs end
            task.spawn(function() msPlay(i) end)
        end)
        nextBtn.MouseButton1Click:Connect(function()
            local i = M.current + 1
            if i > #songs then i = 1 end
            task.spawn(function() msPlay(i) end)
        end)
        playBtn.MouseButton1Click:Connect(function()
            if M.loading and not M.sound then
                stopAll()
                refreshUI()
            elseif M.playing and M.sound then
                pcall(function() M.sound:Pause() end)
                M.playing = false
                refreshUI()
            elseif M.sound then
                pcall(function() M.sound:Resume() end)
                M.playing = true
                refreshUI()
            else
                -- El primer enlace de la lista no está disponible en este momento;
                -- al iniciar por primera vez, usar la siguiente canción.
                local i = (M.current > 0) and M.current or 2
                task.spawn(function() msPlay(i) end)
            end
        end)
        stopBtn.MouseButton1Click:Connect(function()
            stopAll()
            refreshUI()
        end)
        local function changeVolume(delta)
            M.vol = math.clamp(M.vol + delta, 0, 1)
            if M.sound then M.sound.Volume = M.vol end
            State.musicVolume = M.vol
            SetSetting("musicVolume", M.vol)
            refreshUI()
        end
        volD.MouseButton1Click:Connect(function() changeVolume(-0.1) end)
        volU.MouseButton1Click:Connect(function() changeVolume(0.1) end)

        makeSectionLabel("Canciones", pageMusic)
        local hint = Instance.new("TextLabel", pageMusic)
        hint.Name = "MusicHint"
        hint.Size = UDim2.new(1, 0, 0, 24)
        hint.BackgroundTransparency = 1
        hint.LayoutOrder = #pageMusic:GetChildren() + 1
        hint.Text = "Toca una canción · desliza para ver todas"
        hint.TextColor3 = Color3.fromRGB(215, 205, 225)
        hint.Font = Enum.Font.Gotham
        hint.TextSize = 11
        hint.TextXAlignment = Enum.TextXAlignment.Left
        hint.TextTruncate = Enum.TextTruncate.AtEnd
        for i, song in ipairs(songs) do
            local row = Instance.new("Frame", pageMusic)
            row.Name = "MusicSong" .. i
            row.Size = UDim2.new(1, 0, 0, 36)
            row.BackgroundColor3 = ROW
            row.BorderSizePixel = 0
            row.LayoutOrder = #pageMusic:GetChildren() + 1
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

            local badge = Instance.new("TextLabel", row)
            badge.Name = "Badge"
            badge.Size = UDim2.new(0, 18, 1, 0)
            badge.Position = UDim2.new(0, 4, 0, 0)
            badge.BackgroundTransparency = 1
            badge.Text = "▶"
            badge.TextColor3 = ac()
            badge.Font = Enum.Font.GothamBold
            badge.TextSize = 10
            badge.Visible = true

            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Name = "NameLbl"
            nameLbl.Size = UDim2.new(1, -32, 1, 0)
            nameLbl.Position = UDim2.new(0, 26, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = song.name
            nameLbl.TextColor3 = TEXT
            nameLbl.Font = Enum.Font.GothamMedium
            nameLbl.TextSize = 12
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

            local hit = Instance.new("TextButton", row)
            hit.Name = "PlaySong"
            hit.Size = UDim2.new(1, 0, 1, 0)
            hit.BackgroundTransparency = 1
            hit.Text = ""
            hit.MouseButton1Click:Connect(function()
                if M.current == i and M.loading then
                    stopAll()
                    refreshUI()
                elseif M.current == i and M.sound and M.playing then
                    pcall(function() M.sound:Pause() end)
                    M.playing = false
                    refreshUI()
                elseif M.current == i and M.sound then
                    pcall(function() M.sound:Resume() end)
                    M.playing = true
                    refreshUI()
                else
                    task.spawn(function() msPlay(i) end)
                end
            end)
            M.rows[i] = row
        end
        refreshUI()
    end

    -- Se asigna antes de buildFullGUI, así la lista existe desde el primer armado.
    musicPageRebuild = buildMusicPage
    -- Compatibilidad: los accesos antiguos llevan a la pestaña, no a una ventana externa.
    _G.CatalystOpenMusicList = function() setTab("Música") end
    _G.CatalystStopMusic = function() stopAll(); refreshUI() end
end

function buildFullGUI()
    local tabBeforeBuild = State.lastMenuTab
    local menuPositionBeforeBuild = main and main.Position or savedMainPos
    local menuAnchorBeforeBuild = main and main.AnchorPoint or Vector2.new(0, 0.5)
    local validTabs = {Move=true, Mechanics=true, Visuals=true, Config=true, ["Música"]=true, Keybinds=true}
    toggleColorRefs = {}
    for _, pg in ipairs(ALL_PAGES) do
        for _, child in ipairs(pg:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then child:Destroy() end
        end
    end
    for _, child in ipairs(pageMusic:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then child:Destroy() end
    end

    currentTab = nil
    setTab("Move")
    pageMove.Visible = true
    pageMechanics.Visible = false
    pageVisuals.Visible = false
    pageConfig.Visible = false
    pageMusic.Visible = false
    pageKeybinds.Visible = false
    -- Construir Music primero para que no dependa de las demás secciones.
    if musicPageRebuild then musicPageRebuild() end

        local scroll = pageMove
    makeSectionLabel("Speeds", scroll)

    normalBox = makeInputRow("Normal", State.normalSpeed, function(v) State.normalSpeed=v; SetSetting("normalSpeed",v) end, scroll)
    carryBox  = makeInputRow("Carry",  State.carrySpeed,  function(v) State.carrySpeed=v;  SetSetting("carrySpeed",v) end, scroll)

    makeGap(scroll,2)
    makeGap(scroll,3)

    makeSectionLabel("Lagger Speeds", scroll)

    lagger1Box = makeInputRow("Lagger 1", State.laggerSpeed1, function(v)
        State.laggerSpeed1 = math.clamp(v, 1, 200)
        SetSetting("laggerSpeed1", State.laggerSpeed1)
    end, scroll)

    lagger2Box = makeInputRow("Lagger 2", State.laggerSpeed2, function(v)
        State.laggerSpeed2 = math.clamp(v, 1, 200)
        SetSetting("laggerSpeed2", State.laggerSpeed2)
    end, scroll)
    do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1,0,0,26)
        row.BackgroundColor3 = Color3.fromRGB(0,0,0)
        row.BackgroundTransparency = 0
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren()+1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,12)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.55,0,1,0)
        lbl.Position = UDim2.new(0,4,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Lagger Key"
        lbl.TextColor3 = C_LABEL
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local currentKey = State.keyLagger
        local keyName = (currentKey and currentKey ~= Enum.KeyCode.Unknown) and currentKey.Name or "-"
        local chip = Instance.new("TextButton", row)
        chip.Size = UDim2.new(0, 60, 0, 16)
        chip.Position = UDim2.new(1, -66, 0.5, -8)
        chip.BackgroundColor3 = PITCH_BLACK
        chip.BackgroundTransparency = 0
        chip.Text = keyName
        chip.TextColor3 = ACCENT
        chip.Font = Enum.Font.GothamBold
        chip.TextSize = 10
        chip.AutoButtonColor = false
        Instance.new("UICorner", chip).CornerRadius = UDim.new(0,5)
        keybindChipRefs["keyLagger"] = chip
        chip.MouseButton1Click:Connect(function()
            chip.Text = "..."
            local conn
            conn = UIS.InputBegan:Connect(function(inp, gp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                local key = inp.KeyCode
                if key == Enum.KeyCode.Escape then
                    local k = State.keyLagger
                    chip.Text = (k and k ~= Enum.KeyCode.Unknown) and k.Name or "-"
                    conn:Disconnect()
                    return
                end
                State.keyLagger = key
                chip.Text = key.Name
                SetSetting("keyLagger", key.Name)
                AutoSave()
                conn:Disconnect()
            end)
        end)
    end
    makeGap(scroll,2)

    local modeRow = Instance.new("Frame", scroll); modeRow.Size = UDim2.new(1,0,0,30); modeRow.BackgroundColor3 = Color3.fromRGB(0,0,0); modeRow.BackgroundTransparency=TRANSPARENCY_ROW; modeRow.LayoutOrder = #scroll:GetChildren()+1; Instance.new("UICorner",modeRow).CornerRadius=UDim.new(0,8)
    local modeLbl = Instance.new("TextLabel", modeRow); modeLbl.Size=UDim2.new(0.4,0,1,0); modeLbl.Position=UDim2.new(0,4,0,0); modeLbl.BackgroundTransparency=1; modeLbl.Text="Mode"; modeLbl.TextColor3=ACCENT; modeLbl.Font=Enum.Font.GothamBold; modeLbl.TextSize=10
    modeValLbl = Instance.new("TextLabel", modeRow); modeValLbl.Size=UDim2.new(0.6,-5,1,0); modeValLbl.Position=UDim2.new(0.4,0,0,0); modeValLbl.BackgroundTransparency=1
    if State.laggerLevel > 0 then
        modeValLbl.Text = "Lagger " .. State.laggerLevel
    else
        modeValLbl.Text = (State.speedType=="normal" and "Normal" or "Carry")
    end
    modeValLbl.TextColor3=ACCENT; modeValLbl.Font=Enum.Font.GothamBold; modeValLbl.TextSize=10; modeValLbl.TextXAlignment=Enum.TextXAlignment.Right
    local btnW,btnH=36,14
    local normalBtn=Instance.new("TextButton",modeRow); normalBtn.Size=UDim2.new(0,btnW,0,btnH); normalBtn.Position=UDim2.new(0.4,0,0.5,-btnH/2-1); normalBtn.BackgroundColor3=PITCH_BLACK; normalBtn.BackgroundTransparency=0; normalBtn.Text="N"; normalBtn.TextColor3=ACCENT; normalBtn.Font=Enum.Font.GothamBold; normalBtn.TextSize=9; Instance.new("UICorner",normalBtn).CornerRadius=UDim.new(0,3)
    local carryBtn=Instance.new("TextButton",modeRow); carryBtn.Size=UDim2.new(0,btnW,0,btnH); carryBtn.Position=UDim2.new(0.4,btnW+2,0.5,-btnH/2-1); carryBtn.BackgroundColor3=PITCH_BLACK; carryBtn.BackgroundTransparency=0; carryBtn.Text="C"; carryBtn.TextColor3=ACCENT; carryBtn.Font=Enum.Font.GothamBold; carryBtn.TextSize=9; Instance.new("UICorner",carryBtn).CornerRadius=UDim.new(0,3)
    _G._carryModeBtn = carryBtn
    carryBtn.Visible = not State.autoCarryEnabled
    local laggerBtn=Instance.new("TextButton",modeRow); laggerBtn.Size=UDim2.new(0,btnW,0,btnH); laggerBtn.Position=UDim2.new(0.4,(btnW+2)*2,0.5,-btnH/2-1); laggerBtn.BackgroundColor3=(State.laggerLevel > 0) and Color3.fromRGB(70, 70, 70) or PITCH_BLACK; laggerBtn.BackgroundTransparency=0
    laggerBtn.Text = (State.laggerLevel == 0 and "L") or (State.laggerLevel == 1 and "L1") or "L2"
    laggerBtn.TextColor3=ACCENT; laggerBtn.Font=Enum.Font.GothamBold; laggerBtn.TextSize=9; Instance.new("UICorner",laggerBtn).CornerRadius=UDim.new(0,3)

    local function updateMode()
        if State.laggerLevel > 0 then
            modeValLbl.Text = "Lagger " .. State.laggerLevel
            laggerBtn.Text = (State.laggerLevel == 1 and "L1") or "L2"
            laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        else
            modeValLbl.Text = (State.speedType == "normal" and "Normal" or "Carry")
            laggerBtn.Text = "L"
            laggerBtn.BackgroundColor3 = PITCH_BLACK
        end
    end
    local function cycleLagger()
        if State.laggerLevel == 0 then
            State.laggerLevel = 1
        elseif State.laggerLevel == 1 then
            State.laggerLevel = 2
        else
            State.laggerLevel = 1
        end
        State.speedType = "normal"

        if State.laggerLevel == 0 then
            if setMB_CS then setMB_CS(State.speedType == "carry") end
        else
            if setMB_CS then setMB_CS(false) end
        end

        SetSetting("laggerLevel", State.laggerLevel)
        SetSetting("speedType", State.speedType)
        updateMode()
        refreshUIToggles()
        updateLaggerButtons()
    end

    normalBtn.MouseButton1Click:Connect(function()
        if State.laggerLevel > 0 then
            State.laggerLevel = 0
            SetSetting("laggerLevel", 0)
            updateMode()
            refreshUIToggles()
            updateLaggerButtons()
        end
        State.speedType = "normal"
        updateMode()
        SetSetting("speedType", "normal")
        if setMB_CS then setMB_CS(false) end
    end)

    carryBtn.MouseButton1Click:Connect(function()
        if State.laggerLevel > 0 then
            State.laggerLevel = 0
            SetSetting("laggerLevel", 0)
            updateMode()
            refreshUIToggles()
            updateLaggerButtons()
        end
        State.speedType = "carry"
        updateMode()
        SetSetting("speedType", "carry")
        if setMB_CS then setMB_CS(true) end
    end)

    laggerBtn.MouseButton1Click:Connect(cycleLagger)

    makeGap(scroll,4)

    makeToggleRow("Auto Carry", State.autoCarryEnabled, function(on)
        State.autoCarryEnabled = on
        SetSetting("autoCarryEnabled", on)
        if _G._carryModeBtn then
            _G._carryModeBtn.Visible = not on
        end
        if on then
            if State.speedType == "carry" then
                State.speedType = "normal"
                SetSetting("speedType", "normal")
                if modeValLbl then modeValLbl.Text = "Normal" end
                if setMB_CS then setMB_CS(false) end
            end
        end
        if updateMode then pcall(updateMode) end
    end, scroll)

    scroll = pageMechanics

    -- ===== COMBAT: primero modos/selectores, al final los pills =====
    makeSectionLabel("Combat", scroll)

    -- toggles primero
    makeToggleRow("Bat Counter", State.batCounterEnabled == true, function(on)
        State.batCounterEnabled = on
        SetSetting("batCounterEnabled", on)
        if on then startBatCounter() else stopBatCounter() end
    end, scroll)

    makeToggleRow("Medusa Counter", State.medusaCounterEnabled == true, function(on)
        State.medusaCounterEnabled = on
        SetSetting("medusaCounterEnabled", on)
        if on then
            pcall(function() setupMedusaCounter(LP.Character) end)
        else
            pcall(function() stopMedusaCounter() end)
        end
    end, scroll)

    makeToggleRow("Anti Player Collision", State.antiPlayerCollision, function(on)
        State.antiPlayerCollision = on
        SetSetting("antiPlayerCollision", on)
        if on then startAntiPlayerCollision() else stopAntiPlayerCollision() end
    end, scroll)

    makeToggleRow("Anti Die", State.antiDieEnabled == true, function(on)
        setAntiDie(on)
    end, scroll)

    makeToggleRow("Inf Jump", State.infJumpEnabled, function(on)
        State.infJumpEnabled = on
        SetSetting("infJumpEnabled", on)
    end, scroll)

    makeGap(scroll, 3)

    -- modos / selectores después
    do
        local antiRagRow = Instance.new("Frame", scroll)
        antiRagRow.Size = UDim2.new(1,0,0,30)
        antiRagRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
        antiRagRow.BackgroundTransparency = TRANSPARENCY_ROW
        antiRagRow.BorderSizePixel = 0
        antiRagRow.LayoutOrder = #scroll:GetChildren()+1
        Instance.new("UICorner", antiRagRow).CornerRadius = UDim.new(0,10)
        local lbl = Instance.new("TextLabel", antiRagRow)
        lbl.Size = UDim2.new(0.4,0,1,0)
        lbl.Position = UDim2.new(0,8,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Anti Ragdoll"
        lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local _arInit = "Off"
        if State.antiRagdollActiveVersion == 1 then _arInit = "V1"
        elseif State.antiRagdollActiveVersion == 2 then _arInit = "V2" end
        local antiRagSelector = createCarouselSelector(antiRagRow, _arInit, {"Off","V1","V2"}, function(val)
            if val == "V1" then setAntiRagdollVersion(1)
            elseif val == "V2" then setAntiRagdollVersion(2)
            else setAntiRagdollVersion(0) end
        end)
        _G.updateAntiRagdollUI = function(version)
            local t = "Off"
            if version == 1 or version == "v1" then t = "V1"
            elseif version == 2 or version == "v2" then t = "V2" end
            if antiRagSelector then antiRagSelector.Text = t end
        end
    end

    do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Bat V2 Mode"
        lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local cur = (tonumber(State.bypassMode) or 1) == 2 and "V2" or "V1"
        local sel = createCarouselSelector(row, cur, {"V1", "V2"}, function(val)
            local mode = (val == "V2") and 2 or 1
            State.bypassMode = mode
            SetSetting("bypassMode", mode)
            -- solo afecta Bat V2 (boton flotante), NO al Bat Aimbot
            if State.bypassToggled then
                pcall(function() if startBatV2ByMode then startBatV2ByMode() end end)
            end
            if ZenToast then ZenToast("Bat V2 Mode → " .. (mode == 2 and "V2" or "V1"), ACCENT) end
        end)
        _G._refreshBatV2ModeUI = function()
            if sel then sel.Text = (tonumber(State.bypassMode) or 1) == 2 and "V2" or "V1" end
        end
    end

    do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "TP Bat Mode"
        lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local curTpLabel = ((tonumber(State.tpBatMode) or 2) == 1) and "V1" or "V2"
        local tpSelector = createCarouselSelector(row, curTpLabel, {"V1", "V2"}, function(val)
            local n = (val == "V1") and 1 or 2
            State.tpBatMode = n
            SetSetting("tpBatMode", n)
            if ZenToast then ZenToast("TP Bat → " .. val, ACCENT) end
        end)
        _G._refreshTpBatModeUI = function()
            if tpSelector then
                tpSelector.Text = ((tonumber(State.tpBatMode) or 2) == 1) and "V1" or "V2"
            end
        end
    end

    do
        local jmRow = Instance.new("Frame", scroll)
        jmRow.Size = UDim2.new(1,0,0,30)
        jmRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
        jmRow.BackgroundTransparency = TRANSPARENCY_ROW
        jmRow.BorderSizePixel = 0
        jmRow.LayoutOrder = #scroll:GetChildren()+1
        Instance.new("UICorner", jmRow).CornerRadius = UDim.new(0,10)
        local jmLbl = Instance.new("TextLabel", jmRow)
        jmLbl.Size = UDim2.new(0.4,0,1,0)
        jmLbl.Position = UDim2.new(0,8,0,0)
        jmLbl.BackgroundTransparency = 1
        jmLbl.Text = "Jump Mode"
        jmLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        jmLbl.Font = Enum.Font.Gotham
        jmLbl.TextSize = 12
        jmLbl.TextXAlignment = Enum.TextXAlignment.Left
        local curJM = (State.infJumpMode == "hold") and "Hold" or "Tap"
        createCarouselSelector(jmRow, curJM, {"Tap", "Hold"}, function(val)
            State.infJumpMode = (val == "Hold") and "hold" or "manual"
            SetSetting("infJumpMode", State.infJumpMode)
        end)
    end

    makeGap(scroll, 4)
    makeSectionLabel("Utili", scroll)

    -- toggles primero
    do
        local spinSetter = makeToggleRow("Spin Bot", State.spinEnabled == true, function(on)
            if _G.setSpinEnabled then
                _G.setSpinEnabled(on)
            else
                State.spinEnabled = on and true or false
                SetSetting("spinEnabled", State.spinEnabled)
            end
            if ZenToast then ZenToast(on and ("Spin ON · " .. tostring(State.spinSpeed or 80)) or "Spin OFF", ACCENT) end
        end, scroll)
        _G._spinToggleSetter = spinSetter
    end

    makeToggleRow("Body Lock", State.bodyLockEnabled == true, function(on)
        setBodyLock(on)
    end, scroll)

    makeToggleRow("E01", State.e01Enabled, function(on)
        State.e01Enabled = on
        SetSetting("e01Enabled", on)
        if on then startE01Detection() else stopE01Detection() end
    end, scroll)

    makeToggleRow("Player SP", State.playerSPEnabled, function(on)
        State.playerSPEnabled = on
        SetSetting("playerSPEnabled", on)
        if on then startPlayerSP() else stopPlayerSP() end
    end, scroll)

    makeToggleRow("Auto Brain Rots", State.autoSpinBrainrot == true, function(on)
        State.autoSpinBrainrot = on and true or false
        SetSetting("autoSpinBrainrot", State.autoSpinBrainrot)
        if ZenToast then
            ZenToast(on and "Auto Brain Rots ON" or "Auto Brain Rots OFF", ACCENT)
        end
        if on and _G.setSpinEnabled and _G.isCarryingBrainrot and _G.isCarryingBrainrot() then
            _G.setSpinEnabled(true)
        end
    end, scroll)

    makeGap(scroll, 3)

    -- inputs / acciones después
    makeInputRow("Spin Speed", tostring(tonumber(State.spinSpeed) or 80), function(val)
        local n = math.clamp(tonumber(val) or 80, 1, 300)
        State.spinSpeed = n
        SetSetting("spinSpeed", n)
        pcall(function()
            if _G._catalystApplySpinSpeed then _G._catalystApplySpinSpeed(n) end
        end)
    end, scroll)

    makeInputRow("Body Lock Range", State.bodyLockRange or 25, function(v)
        local n = math.clamp(tonumber(v) or 25, 4, 80)
        State.bodyLockRange = n
        SetSetting("bodyLockRange", n)
    end, scroll)

    makeGap(scroll, 4)
    scroll = pageVisuals

    ------------------------------------------------------------
    -- CHANGER
    ------------------------------------------------------------
    makeSectionLabel("Changer", scroll)


    makeToggleRow("Equip Bat", State.equipBatEnabled, function(on)
        setEquipBat(on)
    end, scroll)

    do
        local skinRow = Instance.new("Frame", scroll)
        skinRow.Size = UDim2.new(1, 0, 0, 30)
        skinRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        skinRow.BackgroundTransparency = TRANSPARENCY_ROW
        skinRow.BorderSizePixel = 0
        skinRow.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", skinRow).CornerRadius = UDim.new(0, 10)
        local tip = Instance.new("TextLabel", skinRow)
        tip.Size = UDim2.new(0.4, 0, 1, 0)
        tip.Position = UDim2.new(0, 8, 0, 0)
        tip.BackgroundTransparency = 1
        tip.Text = "Bat Skin"
        tip.TextColor3 = Color3.fromRGB(235, 235, 235)
        tip.Font = Enum.Font.Gotham
        tip.TextSize = 12
        tip.TextXAlignment = Enum.TextXAlignment.Left
        local order = {"Default", "Diamond", "Katana"}
        local idMap = { Default = "Default", Diamond = "DiamondSword", Katana = "Katana" }
        local revMap = { Default = "Default", DiamondSword = "Diamond", Katana = "Katana" }
        local curSkin = revMap[State.equipBatSkin or "Default"] or "Default"
        createCarouselSelector(skinRow, curSkin, order, function(val)
            local id = idMap[val] or "Default"
            setEquipBatSkin(id)
            if not (EquipBat.enabled or State.equipBatEnabled) then setEquipBat(true) end
        end)
    end

    do
        local animOpts = {"Off","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish"}
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Animations"
        lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local cur = State.animPack or "Off"
        if not table.find(animOpts, cur) then cur = "Off" end
        createCarouselSelector(row, cur, animOpts, function(val)
            State.animPack = val
            SetSetting("animPack", val)
            if val == "Off" then
                pcall(stopAnimPackLust)
            else
                pcall(applyAnimPackWithHeartbeat, val)
            end
        end)
    end

    do
        local ropaOpts = {"Off","Outfit 1","Outfit 2","Outfit 3","Outfit 4","Fuego"}
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Outfit"
        lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local cur = State.accessoryPack or "Off"
        if not table.find(ropaOpts, cur) then cur = "Off" end
        createCarouselSelector(row, cur, ropaOpts, function(val)
            State.accessoryPack = val
            SetSetting("accessoryPack", val)
            pcall(applyAccessoryPack, val)
        end)
    end

    do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Reset Skin"
        lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local b = Instance.new("TextButton", row)
        b.Size = UDim2.new(0, 72, 0, 20)
        b.Position = UDim2.new(1, -82, 0.5, -10)
        b.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
        b.Text = "Reset"
        b.TextColor3 = Color3.fromRGB(200, 200, 210)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 11
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", b)
        st.Color = Color3.fromRGB(55, 55, 65)
        st.Thickness = 1
        st.Transparency = 0.2
        b.MouseButton1Click:Connect(function()
            pcall(stopAnimPackLust)
            pcall(applyAccessoryPack, "Off")
            State.accessoryPack = "Off"
            State.animPack = "Off"
            SetSetting("accessoryPack", "Off")
            SetSetting("animPack", "Off")
            if ZenToast then ZenToast("Skin reset", ACCENT) end
        end)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(28, 22, 36), TextColor3 = ACCENT}):Play()
            TweenService:Create(st, TweenInfo.new(0.12), {Color = ACCENT, Transparency = 0.35}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(16, 16, 20), TextColor3 = Color3.fromRGB(200, 200, 210)}):Play()
            TweenService:Create(st, TweenInfo.new(0.12), {Color = Color3.fromRGB(55, 55, 65), Transparency = 0.2}):Play()
        end)
    end

    ------------------------------------------------------------
    -- EFFECTS
    ------------------------------------------------------------
    makeGap(scroll, 6)
    makeSectionLabel("Effects", scroll)

    makeToggleRow("Dark Mode", State.darkModeEnabled == true, function(on)
        setDarkMode(on)
    end, scroll)
    if State.darkModeEnabled then
        task.defer(function() pcall(applyDarkMode) end)
    end
    makeToggleRow("Stretch Rez", State.stretchRezEnabled, function(on)
        if on then enableStretchRez() else disableStretchRez() end
        SetSetting("stretchRezEnabled", on)
        if ZenToast then
            pcall(function()
                ZenToast(on and ("Stretch FOV "..tostring(State.stretchFov or 120)) or "Stretch OFF", ACCENT)
            end)
        end
    end, scroll)
    makeToggleRow("Waypoint ESP", State.waypointESPEnabled, function(on)
        State.waypointESPEnabled = on
        if on then startWaypointESP() else stopWaypointESP() end
        SetSetting("waypointESPEnabled", on)
    end, scroll)
    makeToggleRow("Modo Navidad", false, function(on)
        setHolidayMode(on)
        if ZenToast then pcall(function() ZenToast(on and "Modo Navidad ON" or "Modo Navidad OFF", ACCENT) end) end
    end, scroll)
    makeToggleRow("Controles Visual", State.visualControlsEnabled == true, function(on)
        setVisualControls(on)
        if ZenToast then
            pcall(function()
                ZenToast(on and "Controles Visual ON" or "Controles Visual OFF", ACCENT)
            end)
        end
    end, scroll)

    makeGap(scroll, 3)

    makeInputRow("Stretch FOV", State.stretchFov or 120, function(v)
        local n = math.clamp(tonumber(v) or 120, 70, 120)
        State.stretchFov = n
        SetSetting("stretchFov", n)
        if State.stretchRezEnabled and workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = n
        end
    end, scroll)

    do
        local row = Instance.new("Frame", scroll)
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Nuke"
        lbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local nukeMap = { OFF = 0, LOW = 1, MED = 2, HIGH = 3 }
        local nukeRev = { [0] = "OFF", [1] = "LOW", [2] = "MED", [3] = "HIGH" }
        local cur = nukeRev[State.nukeLevel or 0] or "OFF"
        local nukeSelector = createCarouselSelector(row, cur, {"OFF","LOW","MED","HIGH"}, function(val)
            setNukeLevel(nukeMap[val] or 0)
        end)
        _G._refreshNukeBtns = function()
            local t = nukeRev[State.nukeLevel or 0] or "OFF"
            if nukeSelector then nukeSelector.Text = t end
        end
    end

    scroll = pageConfig
    -- Diseño alternativo inspirado en la captura: contenido a la izquierda y navegación vertical a la derecha.
    local alternateNav = Instance.new("Frame", contentPanel)
    alternateNav.Name = "AlternateMenuNavigation"
    alternateNav.BackgroundTransparency = 1
    alternateNav.BorderSizePixel = 0
    alternateNav.Position = UDim2.new(0.79, 0, 0, 8)
    alternateNav.Size = UDim2.new(0.20, -8, 1, -16)
    alternateNav.Visible = false
    alternateNav.ZIndex = 8
    local altLayout = Instance.new("UIListLayout", alternateNav)
    altLayout.SortOrder = Enum.SortOrder.LayoutOrder
    altLayout.Padding = UDim.new(0, 8)
    altLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    altLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    local altNavButtons = {}
    local altTabs = {{"Move","Movement"},{"Mechanics","Combat"},{"Visuals","Visuals"},{"Config","Settings"},{"Keybinds","Keys"},{"Música","Music"}}
    for i, tab in ipairs(altTabs) do
        local b = Instance.new("TextButton", alternateNav)
        b.Name = "AltTab_" .. tab[1]
        b.LayoutOrder = i
        b.Size = UDim2.new(1, 0, 0, 46)
        b.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
        b.BackgroundTransparency = 0.08
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.Text = tab[2]
        b.TextColor3 = Color3.fromRGB(195, 150, 255)
        b.TextSize = 12
        b.Font = Enum.Font.GothamBold
        b.ZIndex = 9
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
        local outline = Instance.new("UIStroke", b)
        outline.Color = Color3.fromRGB(105, 65, 155)
        outline.Transparency = 0.45
        outline.Thickness = 1
        b.MouseButton1Click:Connect(function() setTab(tab[1]) end)
        b.MouseEnter:Connect(function()
            TweenService:Create(b,TweenInfo.new(0.14),{BackgroundColor3=Color3.fromRGB(54,32,88)}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b,TweenInfo.new(0.14),{BackgroundColor3=Color3.fromRGB(40,26,39)}):Play()
        end)
        altNavButtons[tab[1]] = b
    end
    local classicMainSize = main.Size
    local classicMainAnchor = main.AnchorPoint
    local classicMainPos = main.Position
    _G._setClassicMainPos = function(pos) classicMainPos = pos end
    local classicContentSize = contentArea.Size
    local classicContentPos = contentArea.Position
    local classicHeaderWordColor = headerWord.TextColor3
    local classicStreetTitleColor = streetTitleLbl.TextColor3
    local classicMainStrokeColor = mainStroke.Color
    local classicMainStrokeEnabled = mainStroke.Enabled
    local classicMainStrokeThickness = mainStroke.Thickness
    local classicContentStrokeColor = contentSt.Color
    local classicContentStrokeEnabled = contentSt.Enabled
    local alternateMenuOn = State.alternateMenuEnabled == true
    local function setAlternateMenu(on)
        alternateMenuOn = on == true
        if alternateMenuOn then
            local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(800,600)
            local altW = math.clamp(viewport.X * 0.58, 360, 520)
            local altH = math.clamp(viewport.Y * 0.88, 460, 900)
            main.AnchorPoint = Vector2.new(0.5,0.5)
            main.Position = UDim2.new(0.5,0,0.5,0)
            main.Size = UDim2.fromOffset(altW,altH)
            savedMainPos = main.Position
            topTabBar.Visible = false
            alternateNav.Visible = true
            contentArea.Position = UDim2.new(0,6,0,2)
            contentArea.Size = UDim2.new(0.77,-8,1,-48)
            headerWord.TextColor3 = Color3.fromRGB(205,135,255)
            streetTitleLbl.TextColor3 = Color3.fromRGB(205,135,255)
            mainStroke.Enabled = true
            mainStroke.Color = Color3.fromRGB(160,105,255)
            mainStroke.Thickness = 2
            contentSt.Enabled = true
            contentSt.Color = Color3.fromRGB(160,105,255)
            contentSt.Transparency = 0.45
            for name, b in pairs(altNavButtons) do
                b.BackgroundColor3 = (name == currentTab) and Color3.fromRGB(58,35,92) or Color3.fromRGB(40,26,39)
            end
        else
            alternateNav.Visible = false
            topTabBar.Visible = true
            contentArea.Size = classicContentSize
            contentArea.Position = classicContentPos
            main.Size = classicMainSize
            main.AnchorPoint = classicMainAnchor
            main.Position = classicMainPos
            savedMainPos = main.Position
            headerWord.TextColor3 = classicHeaderWordColor
            streetTitleLbl.TextColor3 = classicStreetTitleColor
            mainStroke.Color = classicMainStrokeColor
            mainStroke.Enabled = classicMainStrokeEnabled
            mainStroke.Thickness = classicMainStrokeThickness
            contentSt.Color = classicContentStrokeColor
            contentSt.Enabled = classicContentStrokeEnabled
        end
        State.alternateMenuEnabled = alternateMenuOn
        SetSetting("alternateMenuEnabled", alternateMenuOn)
    end
    if alternateMenuOn then setAlternateMenu(true) end
    makeSectionLabel("System", scroll)
    makeToggleRow("Cambiar diseño del menú", alternateMenuOn, function(on)
        setAlternateMenu(on)
        if ZenToast then ZenToast(on and "Menú alternativo" or "Menú clásico", ACCENT) end
    end, scroll)
    makeToggleRow("Lock Buttons", State.mobileLocked, function(on) State.mobileLocked=on; SetSetting("mobileLocked",on) end, scroll)
    makeToggleRow("Lock GUI", State.uiLocked, function(on)
        State.uiLocked = on
        SetSetting("uiLocked", on)
    end, scroll)
    local setAutoGrabMenuToggle = makeToggleRow("Auto Grab (Activar / Desactivar)", Config.autoGrabEnabled ~= false, function(on)
        Config.autoGrabEnabled = on
        SetSetting("autoGrabEnabled", on)
        if _G.CatalystSetAutoGrabEnabled then _G.CatalystSetAutoGrabEnabled(on) end
    end, scroll)
    local setAutoGrabBarToggle = makeToggleRow("Barra Auto Grab (Mostrar / Ocultar)", Config.autoGrabBarVisible ~= false, function(on)
        Config.autoGrabBarVisible = on
        SetSetting("autoGrabBarVisible", on)
        if _G.CatalystSetAutoGrabBarVisible then _G.CatalystSetAutoGrabBarVisible(on) end
    end, scroll)
    local setUnpatchToggle
    setUnpatchToggle = makeToggleRow("Unpatch Auto Steal", false, function(on)
        if on and _G.CatalystUnpatchAutoSteal then
            pcall(_G.CatalystUnpatchAutoSteal)
            if ZenToast then ZenToast("Auto Steal reiniciado", ACCENT) end
        end
        task.delay(0.12, function()
            if setUnpatchToggle then setUnpatchToggle(false) end
        end)
    end, scroll)
    _G._refreshAutoGrabMenuToggles = function()
        if setAutoGrabMenuToggle then setAutoGrabMenuToggle(Config.autoGrabEnabled ~= false) end
        if setAutoGrabBarToggle then setAutoGrabBarToggle(Config.autoGrabBarVisible ~= false) end
    end

    do
        local themeRow = Instance.new("Frame", scroll)
        themeRow.Name = "MenuThemeRow"
        themeRow.Size = UDim2.new(1, 0, 0, 30)
        themeRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        themeRow.BackgroundTransparency = TRANSPARENCY_ROW
        themeRow.BorderSizePixel = 0
        themeRow.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", themeRow).CornerRadius = UDim.new(0, 10)
        local themeLbl = Instance.new("TextLabel", themeRow)
        themeLbl.Size = UDim2.new(0.4, 0, 1, 0)
        themeLbl.Position = UDim2.new(0, 8, 0, 0)
        themeLbl.BackgroundTransparency = 1
        themeLbl.Text = "Color del menú"
        themeLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        themeLbl.Font = Enum.Font.Gotham
        themeLbl.TextSize = 12
        themeLbl.TextXAlignment = Enum.TextXAlignment.Left
        local currentTheme = (Config.menuTheme == "black" and "Negro") or (Config.menuTheme == "white" and "Blanco") or (Config.menuTheme == "purple" and "Morado") or "Azul"
        local themeSelector = createCarouselSelector(themeRow, currentTheme, {"Azul", "Negro", "Blanco", "Morado"}, function(value)
            local selected = (value == "Negro" and "black") or (value == "Blanco" and "white") or (value == "Morado" and "purple") or "blue"
            applyTitleColor(selected)
            if ZenToast then ZenToast("Color del menú: " .. value, ACCENT) end
        end)
        _G._refreshMenuThemeUI = function()
            if themeSelector then
                themeSelector.Text = (Config.menuTheme == "black" and "Negro") or (Config.menuTheme == "white" and "Blanco") or (Config.menuTheme == "purple" and "Morado") or "Azul"
            end
        end
    end

    do
        local shapeRow = Instance.new("Frame", scroll)
        shapeRow.Name = "FloatButtonShapeRow"
        shapeRow.Size = UDim2.new(1, 0, 0, 30)
        shapeRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shapeRow.BackgroundTransparency = TRANSPARENCY_ROW
        shapeRow.BorderSizePixel = 0
        shapeRow.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", shapeRow).CornerRadius = UDim.new(0, 10)
        local shapeLbl = Instance.new("TextLabel", shapeRow)
        shapeLbl.Size = UDim2.new(0.4, 0, 1, 0)
        shapeLbl.Position = UDim2.new(0, 8, 0, 0)
        shapeLbl.BackgroundTransparency = 1
        shapeLbl.Text = "Forma de botones"
        shapeLbl.TextColor3 = Color3.fromRGB(235, 235, 235)
        shapeLbl.Font = Enum.Font.Gotham
        shapeLbl.TextSize = 12
        shapeLbl.TextXAlignment = Enum.TextXAlignment.Left
        local shapeValue = (State.floatBtnShape == "Capsule") and "Redondos" or "Cuadrados"
        local shapeSelector = createCarouselSelector(shapeRow, shapeValue, {"Cuadrados", "Redondos"}, function(value)
            local selected = (value == "Redondos") and "Capsule" or "Square"
            if _G.CatalystSetFloatBtnShape then
                _G.CatalystSetFloatBtnShape(selected)
            else
                State.floatBtnShape = selected
                SetSetting("floatBtnShape", selected)
            end
            if ZenToast then ZenToast("Forma de botones: " .. value, ACCENT) end
        end)
        _G._refreshFloatBtnShapeUI = function()
            if shapeSelector then
                shapeSelector.Text = (State.floatBtnShape == "Capsule") and "Redondos" or "Cuadrados"
            end
        end
    end

    makeSectionLabel("Tamaño de botones", scroll)
    local function getFloatSize(btn)
        return btn and math.floor(tonumber(btn:GetAttribute("_floatSize")) or btn.AbsoluteSize.X or 72) or 72
    end
    local function setFloatSize(btn, size, file)
        if not btn then return end
        size = math.clamp(math.floor(tonumber(size) or 72), 48, 120)
        btn.Size = UDim2.fromOffset(size, size)
        btn:SetAttribute("_floatSize", size)
        pcall(function() writefile(file, tostring(size)) end)
    end
    local function makeSizeControl(label, getter, changer)
        local row = Instance.new("Frame", scroll)
        row.Name = "SizeControl_" .. label:gsub("%s", "")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        row.BackgroundTransparency = TRANSPARENCY_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local title = Instance.new("TextLabel", row)
        title.Size = UDim2.new(0.52, 0, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = label
        title.TextColor3 = C_LABEL
        title.Font = Enum.Font.Gotham
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        local value = Instance.new("TextLabel", row)
        value.Size = UDim2.fromOffset(44, 22)
        value.Position = UDim2.new(1, -88, 0.5, -11)
        value.BackgroundTransparency = 1
        value.TextColor3 = C_LABEL
        value.Font = Enum.Font.GothamBold
        value.TextSize = 11
        value.Text = tostring(getter()) .. "px"
        local minus = Instance.new("TextButton", row)
        minus.Size = UDim2.fromOffset(22, 22)
        minus.Position = UDim2.new(1, -114, 0.5, -11)
        minus.Text = "−"
        minus.TextColor3 = C_LABEL
        minus.TextSize = 16
        minus.Font = Enum.Font.GothamBold
        minus.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        minus.BorderSizePixel = 0
        Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 6)
        local plus = minus:Clone()
        plus.Parent = row
        plus.Name = "Plus"
        plus.Position = UDim2.new(1, -28, 0.5, -11)
        plus.Text = "+"
        local function refresh()
            value.Text = tostring(getter()) .. "px"
        end
        minus.MouseButton1Click:Connect(function() changer(-8); refresh() end)
        plus.MouseButton1Click:Connect(function() changer(8); refresh() end)
    end
    makeSizeControl("Insta Reset", function() return getFloatSize(_G._instaResetBtn and _G._instaResetBtn.button) end, function(d)
        local b = _G._instaResetBtn and _G._instaResetBtn.button
        setFloatSize(b, getFloatSize(b) + d, "KzsHubInstaResetSize.txt")
    end)
    makeSizeControl("Bat V2", function() return getFloatSize(_G._batV2Btn and _G._batV2Btn.button) end, function(d)
        local b = _G._batV2Btn and _G._batV2Btn.button
        setFloatSize(b, getFloatSize(b) + d, "KzsHubBatV2Size.txt")
    end)

    do
        State.hiddenButtons = State.hiddenButtons or {}
        if type(State.hiddenButtons) ~= "table" then State.hiddenButtons = {} end

        local header = Instance.new("Frame", scroll)
        header.Size = UDim2.new(1, 0, 0, 32)
        header.BackgroundColor3 = Color3.fromRGB(0,0,0)
        header.BackgroundTransparency = TRANSPARENCY_ROW
        header.BorderSizePixel = 0
        header.LayoutOrder = #scroll:GetChildren() + 1
        Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

        local title = Instance.new("TextLabel", header)
        title.Size = UDim2.new(1, -40, 1, 0)
        title.Position = UDim2.new(0, 10, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Remove Buttons"
        title.TextColor3 = C_LABEL
        title.Font = Enum.Font.GothamBold
        title.TextSize = 12
        title.TextXAlignment = Enum.TextXAlignment.Left

        local arrow = Instance.new("TextLabel", header)
        arrow.Size = UDim2.new(0, 28, 1, 0)
        arrow.Position = UDim2.new(1, -32, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = ACCENT
        arrow.Font = Enum.Font.GothamBold
        arrow.TextSize = 12
        arrow.TextXAlignment = Enum.TextXAlignment.Center

        local listFrame = Instance.new("Frame", scroll)
        listFrame.Size = UDim2.new(1, 0, 0, 0)
        listFrame.BackgroundTransparency = 1
        listFrame.BorderSizePixel = 0
        listFrame.Visible = false
        listFrame.ClipsDescendants = true
        listFrame.LayoutOrder = #scroll:GetChildren() + 1
        local listLayout = Instance.new("UIListLayout", listFrame)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 3)

        local expanded = false

        local function getButtonEntries()
            local entries = {}
            if floatingBtnRefs then
                for _, e in ipairs(floatingBtnRefs) do
                    if e.frame then
                        table.insert(entries, {
                            id = e.id or e.posFile or e.frame.Name,
                            label = e.label or e.frame.Name,
                            frame = e.frame,
                        })
                    end
                end
            end
            if mbGroup then
                table.insert(entries, {
                    id = "MobilePad",
                    label = "Mobile Pad",
                    frame = mbGroup,
                })
            end
            if mbButtonFrames then
                for _, e in ipairs(mbButtonFrames) do
                    if e.frame then
                        local lbl = e.label
                        if not lbl then
                            local t = e.frame:FindFirstChildWhichIsA("TextLabel", true)
                            lbl = t and t.Text or e.frame.Name
                            lbl = (lbl or ""):gsub("\n", " ")
                        end
                        table.insert(entries, {
                            id = e.id or e.posFile or e.frame.Name,
                            label = lbl,
                            frame = e.frame,
                        })
                    end
                end
            end
            return entries
        end

        local function applyVisibility(id, vis)
            State.hiddenButtons[id] = (not vis) and true or nil
            SetSetting("hiddenButtons", State.hiddenButtons)
            for _, e in ipairs(getButtonEntries()) do
                if e.id == id and e.frame then
                    e.frame.Visible = vis
                end
            end
        end

        local function applyAll(vis)
            for _, e in ipairs(getButtonEntries()) do
                if e.frame then e.frame.Visible = vis end
                State.hiddenButtons[e.id] = (not vis) and true or nil
            end
            SetSetting("hiddenButtons", State.hiddenButtons)
        end

        local function rebuildList()
            for _, ch in ipairs(listFrame:GetChildren()) do
                if not ch:IsA("UIListLayout") then ch:Destroy() end
            end
            local allRow = Instance.new("Frame", listFrame)
            allRow.Size = UDim2.new(1, 0, 0, 28)
            allRow.BackgroundColor3 = Color3.fromRGB(0,0,0)
            allRow.BackgroundTransparency = TRANSPARENCY_ROW
            allRow.BorderSizePixel = 0
            allRow.LayoutOrder = 0
            Instance.new("UICorner", allRow).CornerRadius = UDim.new(0, 8)
            local allLbl = Instance.new("TextLabel", allRow)
            allLbl.Size = UDim2.new(0.7, 0, 1, 0)
            allLbl.Position = UDim2.new(0, 10, 0, 0)
            allLbl.BackgroundTransparency = 1
            allLbl.Text = "Todo"
            allLbl.TextColor3 = ACCENT
            allLbl.Font = Enum.Font.GothamBold
            allLbl.TextSize = 11
            allLbl.TextXAlignment = Enum.TextXAlignment.Left
            local allOn = true
            for _, e in ipairs(getButtonEntries()) do
                if e.frame and not e.frame.Visible then allOn = false break end
            end
            local allPill = Instance.new("TextButton", allRow)
            allPill.Size = UDim2.new(0, 44, 0, 20)
            allPill.Position = UDim2.new(1, -52, 0.5, -10)
            allPill.BackgroundColor3 = allOn and ACCENT or Color3.fromRGB(22, 22, 28)
            allPill.Text = allOn and "ON" or "OFF"
            allPill.TextColor3 = allOn and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,170)
            allPill.Font = Enum.Font.GothamBold
            allPill.TextSize = 10
            allPill.AutoButtonColor = false
            Instance.new("UICorner", allPill).CornerRadius = UDim.new(1, 0)
            allPill.MouseButton1Click:Connect(function()
                local nextVis = not allOn
                applyAll(nextVis)
                rebuildList()
                if ZenToast then ZenToast(nextVis and "Botones ON" or "Botones OFF", ACCENT) end
            end)

            local order = 1
            for _, e in ipairs(getButtonEntries()) do
                local vis = e.frame and e.frame.Visible
                if State.hiddenButtons[e.id] then
                    vis = false
                    if e.frame then e.frame.Visible = false end
                end
                local row = Instance.new("Frame", listFrame)
                row.Size = UDim2.new(1, 0, 0, 26)
                row.BackgroundColor3 = Color3.fromRGB(0,0,0)
                row.BackgroundTransparency = 0
                row.BorderSizePixel = 0
                row.LayoutOrder = order
                Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
                local lbl = Instance.new("TextLabel", row)
                lbl.Size = UDim2.new(0.7, 0, 1, 0)
                lbl.Position = UDim2.new(0, 10, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = e.label
                lbl.TextColor3 = C_LABEL
                lbl.Font = Enum.Font.Gotham
                lbl.TextSize = 11
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                local pill = Instance.new("TextButton", row)
                pill.Size = UDim2.new(0, 44, 0, 18)
                pill.Position = UDim2.new(1, -52, 0.5, -9)
                pill.BackgroundColor3 = vis and ACCENT or Color3.fromRGB(22, 22, 28)
                pill.Text = vis and "ON" or "OFF"
                pill.TextColor3 = vis and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,170)
                pill.Font = Enum.Font.GothamBold
                pill.TextSize = 10
                pill.AutoButtonColor = false
                Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
                local eid, eframe = e.id, e.frame
                pill.MouseButton1Click:Connect(function()
                    local nextVis = not (eframe and eframe.Visible)
                    applyVisibility(eid, nextVis)
                    rebuildList()
                end)
                order += 1
            end
            local n = order
            listFrame.Size = UDim2.new(1, 0, 0, n * 29 + 4)
        end

        local hit = Instance.new("TextButton", header)
        hit.Size = UDim2.new(1, 0, 1, 0)
        hit.BackgroundTransparency = 1
        hit.Text = ""
        hit.ZIndex = 5
        hit.MouseButton1Click:Connect(function()
            expanded = not expanded
            arrow.Text = expanded and "▲" or "▼"
            listFrame.Visible = expanded
            if expanded then rebuildList() end
            local sc = header:FindFirstChild("ActScale") or Instance.new("UIScale", header)
            sc.Name = "ActScale"
            sc.Scale = 0.96
            TweenService:Create(sc, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)

        task.defer(function()
            task.wait(0.4)
            for _, e in ipairs(getButtonEntries()) do
                if State.hiddenButtons and State.hiddenButtons[e.id] and e.frame then
                    e.frame.Visible = false
                end
            end
        end)
    end

    makeGap(scroll,6)

    local scaleRow = Instance.new("Frame", scroll)
    scaleRow.Size = UDim2.new(1,0,0,28); scaleRow.BackgroundColor3=Color3.fromRGB(0,0,0); scaleRow.BackgroundTransparency=TRANSPARENCY_ROW
    scaleRow.BorderSizePixel=0; scaleRow.LayoutOrder=#scroll:GetChildren()+1
    Instance.new("UICorner",scaleRow).CornerRadius=UDim.new(0,8)
    local scaleLbl = Instance.new("TextLabel", scaleRow)
    scaleLbl.Size=UDim2.new(0.4,0,1,0); scaleLbl.Position=UDim2.new(0,6,0,0)
    scaleLbl.BackgroundTransparency=1; scaleLbl.Text="Buttons Scale"
    scaleLbl.TextColor3=ACCENT; scaleLbl.Font=Enum.Font.GothamBold; scaleLbl.TextSize=10
    scaleLbl.TextXAlignment=Enum.TextXAlignment.Left
    local scaleValLbl = Instance.new("TextLabel", scaleRow)
    scaleValLbl.Size=UDim2.new(0.18,0,1,0); scaleValLbl.Position=UDim2.new(0.4,0,0,0)
    scaleValLbl.BackgroundTransparency=1; scaleValLbl.Text=string.format("%.0f%%",(mbScaleFactor or 1)*100)
    scaleValLbl.TextColor3=C_WHITE; scaleValLbl.Font=Enum.Font.GothamBold; scaleValLbl.TextSize=10
    scaleValLbl.TextXAlignment=Enum.TextXAlignment.Center
    local minusBtn = Instance.new("TextButton", scaleRow)
    minusBtn.Size=UDim2.new(0,22,0,18); minusBtn.Position=UDim2.new(1,-52,0.5,-9)
    minusBtn.BackgroundColor3=PITCH_BLACK; minusBtn.BackgroundTransparency=0; minusBtn.BorderSizePixel=0
    minusBtn.Text="-"; minusBtn.TextColor3=ACCENT
    minusBtn.Font=Enum.Font.GothamBold; minusBtn.TextSize=12
    minusBtn.AutoButtonColor=false
    Instance.new("UICorner",minusBtn).CornerRadius=UDim.new(0,5)
    local plusBtn = Instance.new("TextButton", scaleRow)
    plusBtn.Size=UDim2.new(0,22,0,18); plusBtn.Position=UDim2.new(1,-26,0.5,-9)
    plusBtn.BackgroundColor3=PITCH_BLACK; plusBtn.BackgroundTransparency=0; plusBtn.BorderSizePixel=0
    plusBtn.Text="+"; plusBtn.TextColor3=ACCENT
    plusBtn.Font=Enum.Font.GothamBold; plusBtn.TextSize=12
    plusBtn.AutoButtonColor=false
    Instance.new("UICorner",plusBtn).CornerRadius=UDim.new(0,5)
    local function updateScale(v)
        applyMBScale(v)
        scaleValLbl.Text = string.format("%.0f%%", (mbScaleFactor or 1)*100)
        SetSetting("mbButtonScale", mbScaleFactor)
    end
    minusBtn.MouseButton1Click:Connect(function()
        updateScale(mbScaleFactor - 0.1)
    end)
    plusBtn.MouseButton1Click:Connect(function()
        updateScale(mbScaleFactor + 0.1)
    end)

    makeGap(scroll,6)

    makeSectionLabel("Config", scroll)

    local actionsRow = Instance.new("Frame", scroll)
    actionsRow.Size = UDim2.new(1, 0, 0, 36)
    actionsRow.BackgroundTransparency = 1
    actionsRow.BorderSizePixel = 0
    actionsRow.LayoutOrder = #scroll:GetChildren() + 1

    local saveRow = Instance.new("Frame", actionsRow)
    saveRow.Size = UDim2.new(0.48, -4, 1, 0)
    saveRow.Position = UDim2.new(0, 0, 0, 0)
    saveRow.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    saveRow.BackgroundTransparency = 0
    saveRow.BorderSizePixel = 0
    Instance.new("UICorner", saveRow).CornerRadius = UDim.new(0, 10)
    local saveStroke = Instance.new("UIStroke", saveRow)
    saveStroke.Color = ACCENT
    saveStroke.Thickness = 1.2
    saveStroke.Transparency = 0.35
    local saveBtn = Instance.new("TextButton", saveRow)
    saveBtn.Size = UDim2.new(1, 0, 1, 0)
    saveBtn.BackgroundTransparency = 1
    saveBtn.Text = "💾  GUARDAR"
    saveBtn.TextColor3 = ACCENT
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.TextSize = 12
    saveBtn.AutoButtonColor = false
    saveBtn.MouseButton1Click:Connect(function()
        local sc = saveRow:FindFirstChild("ActScale") or Instance.new("UIScale", saveRow)
        sc.Name = "ActScale"
        sc.Scale = 0.92
        TweenService:Create(sc, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(saveStroke, TweenInfo.new(0.12), {Thickness = 2.2, Transparency = 0.05}):Play()
        SaveConfig()
        saveBtn.Text = "✓  GUARDADO"
        saveBtn.TextColor3 = Color3.fromRGB(120, 255, 160)
        if ZenToast then ZenToast("Config guardada", ACCENT) end
        task.delay(1.2, function()
            if saveBtn and saveBtn.Parent then
                saveBtn.Text = "💾  GUARDAR"
                saveBtn.TextColor3 = ACCENT
            end
            if saveStroke and saveStroke.Parent then
                TweenService:Create(saveStroke, TweenInfo.new(0.2), {Thickness = 1.2, Transparency = 0.35}):Play()
            end
        end)
    end)

    local resetRow = Instance.new("Frame", actionsRow)
    resetRow.Size = UDim2.new(0.48, -4, 1, 0)
    resetRow.Position = UDim2.new(0.52, 4, 0, 0)
    resetRow.BackgroundColor3 = Color3.fromRGB(28, 10, 14)
    resetRow.BackgroundTransparency = 0
    resetRow.BorderSizePixel = 0
    Instance.new("UICorner", resetRow).CornerRadius = UDim.new(0, 10)
    local resetStroke = Instance.new("UIStroke", resetRow)
    resetStroke.Color = Color3.fromRGB(220, 70, 90)
    resetStroke.Thickness = 1.2
    resetStroke.Transparency = 0.35
    local resetBtn = Instance.new("TextButton", resetRow)
    resetBtn.Size = UDim2.new(1, 0, 1, 0)
    resetBtn.BackgroundTransparency = 1
    resetBtn.Text = "↺  RESET"
    resetBtn.TextColor3 = Color3.fromRGB(255, 120, 140)
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.TextSize = 12
    resetBtn.AutoButtonColor = false
    resetBtn.MouseButton1Click:Connect(function()
        local sc = resetRow:FindFirstChild("ActScale") or Instance.new("UIScale", resetRow)
        sc.Name = "ActScale"
        sc.Scale = 0.92
        TweenService:Create(sc, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        TweenService:Create(resetStroke, TweenInfo.new(0.12), {Thickness = 2.2, Transparency = 0.05}):Play()
        resetBtn.Text = "… RESETEANDO"
        resetBtn.TextColor3 = C_WHITE
        task.delay(0.35, function()
            if resetBtn and resetBtn.Parent then
                resetBtn.Text = "↺  RESET"
                resetBtn.TextColor3 = Color3.fromRGB(255, 120, 140)
            end
            if resetStroke and resetStroke.Parent then
                TweenService:Create(resetStroke, TweenInfo.new(0.2), {Thickness = 1.2, Transparency = 0.35}):Play()
            end
        end)
        if ZenToast then ZenToast("Config reseteada", Color3.fromRGB(255, 120, 140)) end
        local ok, errMsg = pcall(function()
        State.normalSpeed=60; State.carrySpeed=30;
        State.laggerSpeed1=13; State.laggerSpeed2=25
        State.laggerLevel=0
        State.speedType="normal"
        State.autoBatToggled=false; State.infJumpEnabled=false; State.infJumpMode="manual"
        State.antiRagdollV1Enabled=false; State.antiRagdollV2Enabled=false; State.antiRagdollActiveVersion=0
        setAntiRagdollVersion(0)
        State.fpsBoostEnabled=false; if Conns.fpsBoostMonitor then Conns.fpsBoostMonitor:Disconnect(); Conns.fpsBoostMonitor = nil end
        State.nukeLevel=0; State.nukeEnabled=false; pcall(disableNuke)
        State.medusaCounterEnabled=false; State.animEnabled=false; State.unwalkEnabled=false
        State.autoLeftEnabled=false; State.autoRightEnabled=false
        State.skyEnabled=false; State.skyColorIndex=1
        State.floatEnabled=false; State.floatHeight=9.5
        State.stretchRezEnabled=false;
        State.batCounterEnabled=false; State.waypointESPEnabled=false
        State.controllerEnabled=false; State.mobileLocked=false
        State.uiLocked=true
        State.bgFondoIndex=1
        Config.menuTheme = "blue"
        State.titleColor = "blue"
        pcall(function() applyTitleColor("blue") end)
        pcall(function() setFondoUI(1) end)
        State.keyAutoLeft=Enum.KeyCode.Unknown; State.keyAutoRight=Enum.KeyCode.Unknown
        State.keyDropBR=Enum.KeyCode.Unknown; State.keyTpDown=Enum.KeyCode.Unknown
        State.keyAutoBat=Enum.KeyCode.Unknown; State.keySpeedToggle=Enum.KeyCode.Unknown
        State.keyLagger=Enum.KeyCode.Unknown
        State.keyLagger1=Enum.KeyCode.Unknown
        State.keyLagger2=Enum.KeyCode.Unknown
        State.keyBatAim2=Enum.KeyCode.Unknown
        State.keyTpBat=Enum.KeyCode.Unknown
        State.keyInstaReset=Enum.KeyCode.Unknown
        State.keyBatV2=Enum.KeyCode.Unknown
        State.dropEnabled = false
        State.antiPlayerCollision=false
        State.playerSPEnabled = false
        if playerSPRunning then stopPlayerSP() end
        pcall(function() stopAntiPlayerCollision() end)
        State.bypassToggled = false
        State.bypassMode = 1
        State.bypassSpeed = 57
        toggleDropGlitch(false)
        stopAutoLeft(); stopAutoRight(); stopAntiRagdollV1(); stopAntiRagdollV2()
        stopAnimToggle(); stopUnwalk(); stopBatAimbot(); stopBatCounter()
        stopFloat(); stopWaypointESP()
        State.batAim2Enabled = false; State.batAim2Mode = "normal"
        if State.stretchRezEnabled then disableStretchRez() end
        State.accessoryPack = "Off"
        clearAllAccessories(LP.Character)
        for k,v in pairs(DefaultConfig) do Config[k]=v end
        State.lastMenuTab = DefaultConfig.lastMenuTab
        State.musicVolume = DefaultConfig.musicVolume
        SaveConfig()
        for k,chip in pairs(keybindChipRefs) do chip.Text="-" end
        if setMB_AL then setMB_AL(false) end; if setMB_AR then setMB_AR(false) end
        if setMB_AB then setMB_AB(false) end; if setMB_CS then setMB_CS(false) end
        updateLaggerButtons()
        syncDropButtons()
        updateScale(1.0)
        buildFullGUI()
        end)
        if not ok then warn("[RESET CONFIG] error while resetting settings: "..tostring(errMsg)) end

        local okPos, posErr = pcall(function()
            mbGroup.Position = UDim2.new(1, -(QW+64+10), 0.5, -QH/2-8)
            for _, entry in ipairs(mbButtonFrames) do
                entry.frame.Position = entry.defaultPos
                pcall(function() if isfile and isfile(entry.posFile) then delfile(entry.posFile) end end)
            end
            for _, entry in ipairs(floatingBtnRefs) do
                entry.frame.Position = entry.defaultPos
                pcall(function() if isfile and isfile(entry.posFile) then delfile(entry.posFile) end end)
            end
            pcall(function() if isfile and isfile("KzsHubMBPos.txt") then delfile("KzsHubMBPos.txt") end end)
        end)
        if not okPos then warn("[RESET CONFIG] error while resetting button positions: "..tostring(posErr)) end
    end)

    scroll = pageKeybinds
    task.spawn(function() startControllerSupport() end)
    makeSectionLabel("Controller", scroll)
    makeToggleRow("Controller Support", true, function(on)
        State.controllerEnabled = on
        SetSetting("controllerEnabled", on)
        gpEnabled = true
        startControllerSupport()
    end, scroll)

    for _, act in ipairs(GP_ACT) do
            local c = Instance.new("Frame", scroll); c.Size = UDim2.new(1,0,0,26); c.BackgroundColor3 = Color3.fromRGB(0,0,0); c.BackgroundTransparency=TRANSPARENCY_ROW; c.BorderSizePixel = 0; c.LayoutOrder = #scroll:GetChildren()+1; Instance.new("UICorner", c).CornerRadius = UDim.new(0,8)
            local lbl2 = Instance.new("TextLabel", c); lbl2.Size = UDim2.new(0.5, 0, 1, 0); lbl2.Position = UDim2.new(0, 4, 0, 0); lbl2.BackgroundTransparency = 1; lbl2.Text = act.label; lbl2.TextColor3 = ACCENT; lbl2.Font = Enum.Font.GothamBold; lbl2.TextSize = 10; lbl2.TextXAlignment = Enum.TextXAlignment.Left
            local curBtn = Instance.new("TextButton", c); curBtn.Size = UDim2.new(0, 52, 0, 16); curBtn.Position = UDim2.new(1, -58, 0.5, -8); curBtn.BackgroundColor3 = PITCH_BLACK; curBtn.BackgroundTransparency = 0; curBtn.BorderSizePixel = 0; curBtn.Text = xboxName(act.key); curBtn.TextColor3 = C_DIM; curBtn.Font = Enum.Font.GothamBold; curBtn.TextSize = 9; Instance.new("UICorner", curBtn).CornerRadius = UDim.new(0, 3)
            local cStroke = Instance.new("UIStroke", curBtn); cStroke.Color = Color3.fromRGB(60,60,60); cStroke.Thickness = 1
            local listening = false; local listenConn = nil
            curBtn.MouseButton1Click:Connect(function()
                if listening then
                    listening = false; if listenConn then listenConn:Disconnect(); listenConn = nil end
                    curBtn.Text = xboxName(act.key); TweenService:Create(cStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(60,60,60)}):Play(); return
                end
                listening = true; curBtn.Text = "..."; TweenService:Create(cStroke, TweenInfo.new(0.1), {Color = ACCENT}):Play()
                listenConn = UIS.InputBegan:Connect(function(inp, gpe)
                    if not listening then return end
                    if inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
                    local newKey = inp.KeyCode
                    if newKey == Enum.KeyCode.Thumbstick1 or newKey == Enum.KeyCode.Thumbstick2 or newKey == Enum.KeyCode.Unknown then return end
                    act.key = newKey; curBtn.Text = xboxName(newKey); listening = false
                    if listenConn then listenConn:Disconnect(); listenConn = nil end
                    saveGPBinds(); TweenService:Create(cStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(60,60,60)}):Play()
                end)
            end)
        end

    makeSectionLabel("Keybinds", scroll)

    makeGap(scroll, 4)
    makeSectionLabel("PC Keybinds", scroll)
    makeKeybindRow("Auto Left", "keyAutoLeft", scroll)
    makeKeybindRow("Auto Right", "keyAutoRight", scroll)
    makeKeybindRow("Drop BR", "keyDropBR", scroll)
    makeKeybindRow("TP Down", "keyTpDown", scroll)
    makeKeybindRow("Auto Bat", "keyAutoBat", scroll)
    makeKeybindRow("Bat V2", "keyBatV2", scroll)
    makeKeybindRow("Insta Reset", "keyInstaReset", scroll)
    makeKeybindRow("Carry / Speed", "keySpeedToggle", scroll)
    makeKeybindRow("Lagger Cycle", "keyLagger", scroll)
    makeKeybindRow("Lagger", "keyLagger", scroll)
    makeKeybindRow("Bat Aim 2", "keyBatAim2", scroll)

    setTab(validTabs[tabBeforeBuild] and tabBeforeBuild or "Move")
    -- Cambiar de pestaña, tema o reconstruir controles no debe recolocar el menú.
    if menuPositionBeforeBuild and main then
        main.AnchorPoint = menuAnchorBeforeBuild
        main.Position = menuPositionBeforeBuild
        savedMainPos = menuPositionBeforeBuild
    end

end

do
    local okBuild, errBuild = pcall(function()
        buildFullGUI()
    end)
    if okBuild then
        print("[RLM DUELS] ready · discord.gg/RLMDUELS")
        if State.visualControlsEnabled then
            task.defer(function() pcall(startVisualControls) end)
        end
    else
        warn("[RLM DUELS] buildFullGUI error: ", tostring(errBuild))
        print("[RLM DUELS] buildFullGUI error: ", tostring(errBuild))
    end
end

local QS, QG = 72, 6
local QR = 22
local Q_OFF = Q_OFF_BG
local Q_ON = Q_ON_BG
local Q_TEXT = Q_TEXT_OFF
local Q_BORDER = Color3.fromRGB(0,0,0)
local Q_BORDER_ON = Color3.fromRGB(0,0,0)
QW, QH = QS*2+QG, QS*4+QG*3
mbGroup = Instance.new("Frame", gui)
mbGroup.Name = "MobileButtons"
mbGroup.Size = UDim2.new(0, QW+64, 0, QH+64)
mbGroup.Position = UDim2.new(0,10, 0.5,-QH/2-8)
mbGroup.BackgroundTransparency = 1
mbGroup.BorderSizePixel = 0
mbGroup.Active = false
mbGroup.ZIndex = 100

function attachFrameDrag(inputSrc, frame, defaultPos, posFile)
    local dragging, dragStart, startPos = false, nil, nil
    inputSrc.InputBegan:Connect(function(inp)
        if State.mobileLocked then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = frame.Position
        end
    end)
    inputSrc.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.MouseButton2 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then savePos(frame, posFile) end
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging then return end
        if State.mobileLocked then dragging = false; return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            local factor = 1.0
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X * factor, startPos.Y.Scale, startPos.Y.Offset + delta.Y * factor)
        end
    end)
    local lastSave = 0
    frame:GetPropertyChangedSignal("Position"):Connect(function()
        if tick()-lastSave > 0.5 then lastSave = tick(); savePos(frame, posFile) end
    end)
    local positionLoaded = false
    pcall(function() positionLoaded = loadPos(frame, posFile) == true end)
    if not positionLoaded then frame.Position = defaultPos end
    mbButtonFrames[#mbButtonFrames+1] = { frame = frame, defaultPos = defaultPos, posFile = posFile, id = tostring(posFile or frame.Name), label = frame.Name }
end

applyMBScale = function(factor)
    mbScaleFactor = math.clamp(factor, 0.5, 2.0)
    local newQS = math.floor(72 * mbScaleFactor)
    local newQG = math.floor(6  * mbScaleFactor)
    local newQW = newQS*2+newQG
    local newQH = newQS*4+newQG*3
    if mbGroup then
        mbGroup.Size = UDim2.new(0, newQW+14, 0, newQH+14)
        local idx = 0
        for _, child in ipairs(mbGroup:GetChildren()) do
            if child:IsA("Frame") then
                local col = idx % 2
                local row2 = math.floor(idx / 2)
                child.Size = UDim2.new(0, newQS, 0, newQS)
                -- Las posiciones personalizadas ya se cargaron; no escribir
                -- posiciones de cuadrícula encima de los botones arrastrables.
                local hasSavedPosition = false
                for _, entry in ipairs(mbButtonFrames) do
                    if entry.frame == child then hasSavedPosition = true; break end
                end
                if not hasSavedPosition then
                    child.Position = UDim2.new(0, 6+col*(newQS+newQG), 0, 6+row2*(newQS+newQG))
                end
                idx = idx + 1
            end
        end
    end
    if floatingBtnObjects then
        for _, obj in ipairs(floatingBtnObjects) do
            pcall(function()
                local f = obj.frame or obj.btn
                if not f then return end
                local sc = f:FindFirstChild("FloatScale")
                if not sc then
                    sc = Instance.new("UIScale")
                    sc.Name = "FloatScale"
                    sc.Parent = f
                end
                sc.Scale = mbScaleFactor
            end)
        end
    end
    if floatingBtnRefs then
        for _, e in ipairs(floatingBtnRefs) do
            pcall(function()
                local f = e.frame
                if not f then return end
                local sc = f:FindFirstChild("FloatScale")
                if not sc then
                    sc = Instance.new("UIScale")
                    sc.Name = "FloatScale"
                    sc.Parent = f
                end
                sc.Scale = mbScaleFactor
            end)
        end
    end
end

function makeMobileBtn(label, col, row, isToggle, onAction)
    local relX=6+col*(QS+QG); local relY=6+row*(QS+QG)
    local frame=Instance.new("Frame",mbGroup); frame.Name=tostring(label):gsub("\n"," "); frame.Size=UDim2.new(0,QS,0,QS); frame.Position=UDim2.new(0,relX,0,relY)
    frame.BackgroundColor3=Color3.fromRGB(0,0,0); frame.BackgroundTransparency=0
    frame.BorderSizePixel=0; frame.Active=true; frame.ZIndex=102
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,14)
    local btnBg = Instance.new("ImageLabel", frame)
    btnBg.Name = "ReferenceBackground"
    btnBg.Size = UDim2.new(1, 0, 1, 0)
    btnBg.Position = UDim2.new(0, 0, 0, 0)
    btnBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnBg.BackgroundTransparency = 0
    btnBg.BorderSizePixel = 0
    btnBg.Image = backgroundUri(State.bgImageId or BACKGROUND_ID)
    btnBg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    btnBg.ImageTransparency = 0
    btnBg.ScaleType = Enum.ScaleType.Crop
    btnBg.ZIndex = 102
    btnBg.ClipsDescendants = true
    Instance.new("UICorner", btnBg).CornerRadius = UDim.new(0,14)
    local btnShade = Instance.new("Frame", frame)
    btnShade.Name = "ReferenceShade"
    btnShade.Size = UDim2.new(1, 0, 1, 0)
    btnShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnShade.BackgroundTransparency = 0.42
    btnShade.BorderSizePixel = 0
    btnShade.ZIndex = 102
    Instance.new("UICorner", btnShade).CornerRadius = UDim.new(0,14)
    local frameGrad = Instance.new("UIGradient", frame)
    frameGrad.Rotation = 135
    frameGrad.Enabled = false
    frameGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    local stroke = Instance.new("UIStroke", frame)
    stroke.Enabled = true
    stroke.Color = Color3.fromRGB(40, 40, 48)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.3
    local mobileUnderline = Instance.new("Frame", frame)
    mobileUnderline.Name = "BottomAccent"
    mobileUnderline.AnchorPoint = Vector2.new(0.5, 1)
    mobileUnderline.Position = UDim2.new(0.5, 0, 1, -6)
    mobileUnderline.Size = UDim2.new(0.58, 0, 0, 2)
    mobileUnderline.BackgroundColor3 = Color3.fromRGB(155, 85, 220)
    mobileUnderline.BackgroundTransparency = 0.16
    mobileUnderline.BorderSizePixel = 0
    mobileUnderline.ZIndex = 104
    Instance.new("UICorner", mobileUnderline).CornerRadius = UDim.new(1, 0)
    local mobileUnderlineGrad = Instance.new("UIGradient", mobileUnderline)
    mobileUnderlineGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 30, 120)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 205, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(115, 48, 170)),
    })
    local strokeGrad = Instance.new("UIGradient", stroke)
    strokeGrad.Rotation = 90
    strokeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    local btn=Instance.new("TextButton",frame); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=label
    btn.TextColor3=Color3.fromRGB(255,255,255); btn.Font=Enum.Font.GothamBlack; btn.TextSize=10; btn.TextWrapped=true; btn.LineHeight=1.2; btn.BorderSizePixel=0; btn.AutoButtonColor=false; btn.ZIndex=103
    local btnGrad = Instance.new("UIGradient", btn)
    btnGrad.Rotation = 90
    btnGrad.Enabled = false
    btnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.55, ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50)),
    })
    local isOn=false
    local frameScale = Instance.new("UIScale", frame)
    frameScale.Scale = 1
    local function applyBorder(on)
        local activePurple = Color3.fromRGB(190, 115, 245)
        stroke.Enabled = true
        stroke.Color = on and activePurple or Color3.fromRGB(110, 72, 140)
        stroke.Transparency = on and 0.03 or 0.16
        stroke.Thickness = on and 2.0 or 1.5
        frame.BackgroundColor3 = Color3.fromRGB(7, 5, 11)
        frameGrad.Enabled = true
        frameGrad.Rotation = 135
        frameGrad.Color = on and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 3, 7)),
            ColorSequenceKeypoint.new(0.48, Color3.fromRGB(72, 37, 105)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 5, 13)),
        }) or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 3, 6)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(34, 21, 47)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 4, 10)),
        })
        btnBg.ImageColor3 = on and Color3.fromRGB(205, 160, 255) or Color3.fromRGB(225, 210, 245)
        btnBg.ImageTransparency = on and 0.24 or 0.34
        btnShade.BackgroundTransparency = on and 0.22 or 0.30
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextStrokeColor3 = Color3.fromRGB(18, 8, 28)
        btn.TextStrokeTransparency = 0.05
        btnGrad.Enabled = true
        btnGrad.Color = on and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(220, 180, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
        }) or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 248, 255)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(205, 175, 225)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(250, 248, 255)),
        })
        strokeGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 8, 28)),
            ColorSequenceKeypoint.new(0.5, activePurple),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 8, 28)),
        })
        mobileUnderline.BackgroundColor3 = on and Color3.fromRGB(225, 185, 255) or Color3.fromRGB(150, 95, 190)
        mobileUnderline.BackgroundTransparency = on and 0.02 or 0.22
        mobileUnderline.Size = UDim2.new(on and 0.76 or 0.58, 0, 0, on and 3 or 2)
        mobileUnderlineGrad.Enabled = true
    end
    local function pressPop()
        frameScale.Scale = 0.86
        TweenService:Create(frameScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        local ts = btn.TextSize
        btn.TextSize = ts + 2
        TweenService:Create(btn, TweenInfo.new(0.18), {TextSize = ts}):Play()
    end
    btn.MouseButton1Click:Connect(function()
        pressPop()
        if isToggle then
            isOn=not isOn
            frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            applyBorder(isOn)
            if onAction then onAction(isOn) end
        else
            frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            applyBorder(true)
            task.delay(0.25,function()
                applyBorder(false)
            end)
            if onAction then onAction() end
        end
    end)
    local function setter(s)
        isOn=s
        frame.BackgroundColor3 = Color3.fromRGB(255,255,255)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        applyBorder(s)
    end
    table.insert(mobileBtnColorRefs, {
        frame = frame,
        btn = btn,
        background = btnBg,
        stroke = stroke,
        strokeGrad = strokeGrad,
        apply = function()
            frame.BackgroundTransparency = 0
            btnBg.Image = backgroundUri(State.bgImageId or BACKGROUND_ID)
            stroke.Color = ACCENT
            applyBorder(isOn)
        end
    })
    local defaultPos = UDim2.new(0,relX,0,relY)
    local posFile = "KzsHubMB_"..label:gsub("%s","").."Pos.txt"
    attachFrameDrag(btn, frame, defaultPos, posFile)
    return setter
end

setMB_BR = makeMobileBtn("DROP\nBR", 0,0,false, function() runDropBrainrot() end)
setMB_AL = makeMobileBtn("AUTO\nLEFT", 1,0,true,function(on)
    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
        if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
    end
    if on and State.bypassToggled then
        toggleBypass(false)
    end

    State.autoLeftEnabled=on
    if on then
        if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if setMB_AR then setMB_AR(false) end; if setAutoRight then setAutoRight(false) end end
        if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setMB_AB then setMB_AB(false) end; if setAutoBat then setAutoBat(false) end end
        startAutoLeft()
    else
        stopAutoLeft()
    end
    SetSetting("autoLeftEnabled",on); if setAutoLeft then setAutoLeft(on) end
end)
setMB_AB = makeMobileBtn("BAT", 0,1,true,function(on)
    if on and State.bypassToggled then
        toggleBypass(false)
    end
    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
        if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
    end

    State.autoBatToggled=on
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if setMB_AL then setMB_AL(false) end; if setAutoLeft then setAutoLeft(false) end end
        if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if setMB_AR then setMB_AR(false) end; if setAutoRight then setAutoRight(false) end end
        startBatAimbot()
    else
        stopBatAimbot()
    end
    SetSetting("autoBatToggled",on); if setAutoBat then setAutoBat(on) end
end)
setMB_AR = makeMobileBtn("AUTO\nRIGHT", 1,1,true,function(on)
    if _G.CatalystTpBatOn then
        _G.CatalystStopTpBat()
        if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
    end
    if on and State.bypassToggled then
        toggleBypass(false)
    end

    State.autoRightEnabled=on
    if on then
        if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if setMB_AL then setMB_AL(false) end; if setAutoLeft then setAutoLeft(false) end end
        if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setMB_AB then setMB_AB(false) end; if setAutoBat then setAutoBat(false) end end
        startAutoRight()
    else
        stopAutoRight()
    end
    SetSetting("autoRightEnabled",on); if setAutoRight then setAutoRight(on) end
end)
setMB_TD = makeMobileBtn("TP\nDOWN", 0,2,false,function() tpToGround() end)
setMB_CS = makeMobileBtn("CARRY", 1,2,true,function(on)
    if State.laggerLevel > 0 then
        State.laggerLevel = 0
        SetSetting("laggerLevel", 0)
        refreshUIToggles()
        updateLaggerButtons()
    end
    if on then State.speedType="carry"
    else State.speedType="normal" end
    SetSetting("speedType",State.speedType); refreshUIToggles()
end)

setL1 = makeMobileBtn("LAGGER\n1", 0, 3, true, function(on)
    if on then
        State.laggerLevel = 1
        setL2(false)
    else
        State.laggerLevel = 0
    end
    State.speedType = "normal"
    SetSetting("speedType", "normal")
    if setMB_CS then setMB_CS(false) end
    SetSetting("laggerLevel", State.laggerLevel)
    refreshUIToggles()
    updateLaggerButtons()
    for _, child in ipairs(pageMove:GetChildren()) do
        if child:IsA("Frame") then
            local laggerBtn = child:FindFirstChildWhichIsA("TextButton")
            if laggerBtn and laggerBtn.Text:match("^L%d?$") then
                if State.laggerLevel == 0 then
                    laggerBtn.Text = "L"
                    laggerBtn.BackgroundColor3 = PITCH_BLACK
                elseif State.laggerLevel == 1 then
                    laggerBtn.Text = "L1"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                else
                    laggerBtn.Text = "L2"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                end
                break
            end
        end
    end
end)

setL2 = makeMobileBtn("LAGGER\n2", 1, 3, true, function(on)
    if on then
        State.laggerLevel = 2
        setL1(false)
    else
        State.laggerLevel = 0
    end
    State.speedType = "normal"
    SetSetting("speedType", "normal")
    if setMB_CS then setMB_CS(false) end
    SetSetting("laggerLevel", State.laggerLevel)
    refreshUIToggles()
    updateLaggerButtons()
    for _, child in ipairs(pageMove:GetChildren()) do
        if child:IsA("Frame") then
            local laggerBtn = child:FindFirstChildWhichIsA("TextButton")
            if laggerBtn and laggerBtn.Text:match("^L%d?$") then
                if State.laggerLevel == 0 then
                    laggerBtn.Text = "L"
                    laggerBtn.BackgroundColor3 = PITCH_BLACK
                elseif State.laggerLevel == 1 then
                    laggerBtn.Text = "L1"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                else
                    laggerBtn.Text = "L2"
                    laggerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                end
                break
            end
        end
    end
end)

updateLaggerButtons()

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    local kc = inp.KeyCode

    if State.keyAutoLeft ~= Enum.KeyCode.Unknown and kc == State.keyAutoLeft then
        if _G.CatalystTpBatOn then
            _G.CatalystStopTpBat()
            if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
        end
        if State.bypassToggled then
            toggleBypass(false)
        end

        State.autoLeftEnabled = not State.autoLeftEnabled
        if State.autoLeftEnabled then
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if setAutoRight then setAutoRight(false) end; if setMB_AR then setMB_AR(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
            startAutoLeft()
        else
            stopAutoLeft()
        end
        if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end
        if setMB_AL then setMB_AL(State.autoLeftEnabled) end
        SetSetting("autoLeftEnabled", State.autoLeftEnabled)
    end

    if State.keyAutoRight ~= Enum.KeyCode.Unknown and kc == State.keyAutoRight then
        if _G.CatalystTpBatOn then
            _G.CatalystStopTpBat()
            if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
        end
        if State.bypassToggled then
            toggleBypass(false)
        end

        State.autoRightEnabled = not State.autoRightEnabled
        if State.autoRightEnabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if setAutoLeft then setAutoLeft(false) end; if setMB_AL then setMB_AL(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if setAutoBat then setAutoBat(false) end; if setMB_AB then setMB_AB(false) end end
            startAutoRight()
        else
            stopAutoRight()
        end
        if setAutoRight then setAutoRight(State.autoRightEnabled) end
        if setMB_AR then setMB_AR(State.autoRightEnabled) end
        SetSetting("autoRightEnabled", State.autoRightEnabled)
    end

    if State.keyDropBR ~= Enum.KeyCode.Unknown and kc == State.keyDropBR then
        runDropBrainrot()
    end

    if State.keyTpDown ~= Enum.KeyCode.Unknown and kc == State.keyTpDown then
        tpToGround()
    end

    if State.keyAutoBat ~= Enum.KeyCode.Unknown and kc == State.keyAutoBat then
        if State.bypassToggled then
            toggleBypass(false)
        end
        if _G.CatalystTpBatOn then
            _G.CatalystStopTpBat()
            if _G._tpBatBtn then _G._tpBatBtn.setActive(false) end
        end

        State.autoBatToggled = not State.autoBatToggled
        if State.autoBatToggled then
            _G.CatalystStartBat()
        else
            _G.CatalystStopBat()
        end
        if setAutoBat then setAutoBat(State.autoBatToggled) end
        if setMB_AB then setMB_AB(State.autoBatToggled) end
        SetSetting("autoBatToggled", State.autoBatToggled)
    end

    if State.keySpeedToggle ~= Enum.KeyCode.Unknown and kc == State.keySpeedToggle then
        if State.laggerLevel > 0 then
            State.laggerLevel = 0
            SetSetting("laggerLevel", 0)
            refreshUIToggles()
            updateLaggerButtons()
        end
        State.speedType = (State.speedType == "carry") and "normal" or "carry"
        if modeValLbl then modeValLbl.Text = State.speedType == "carry" and "Carry" or "Normal" end
        SetSetting("speedType", State.speedType)
        if setMB_CS then setMB_CS(State.speedType == "carry") end
    end

    if State.keyBatAim2 ~= Enum.KeyCode.Unknown and kc == State.keyBatAim2 then
        doBatV2()
    end
    if State.keyBatV2 ~= Enum.KeyCode.Unknown and kc == State.keyBatV2 then
        doBatV2()
    end

    if State.keyTpBat ~= Enum.KeyCode.Unknown and kc == State.keyTpBat then
        doTpBat()
    end

    if State.keyLagger ~= Enum.KeyCode.Unknown and kc == State.keyLagger then
        if doLaggerSpeed then doLaggerSpeed() end
    end
    if State.keyLagger ~= Enum.KeyCode.Unknown and kc == State.keyLagger then
        cycleLagger12()
    end
    if State.keyLagger1 ~= Enum.KeyCode.Unknown and kc == State.keyLagger1 then
        cycleLagger12()
    end
    if State.keyLagger2 ~= Enum.KeyCode.Unknown and kc == State.keyLagger2 then
        cycleLagger12()
    end

    if State.keyInstaReset ~= Enum.KeyCode.Unknown and kc == State.keyInstaReset then
        instaReset()
    end
end)

function setupChar(char)
    task.wait(0.1)
    originalAnims = nil
    h = char:WaitForChild("Humanoid", 5)
    hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not h or not hrp then return end

    local head = char:FindFirstChild("Head")
    if head then
        local oldBB = head:FindFirstChild("KzMobileBB")
        if oldBB then oldBB:Destroy() end

        local bb = Instance.new("BillboardGui", head)
        bb.Name = "KzMobileBB"
        bb.Size = UDim2.new(0, 200, 0, 92)
        bb.StudsOffset = Vector3.new(0, 4.15, 0)
        bb.AlwaysOnTop = true

        local stealLbl = Instance.new("TextLabel", bb)
        stealLbl.Name = "StealBillLbl"
        stealLbl.Visible = false
        stealLbl.Size = UDim2.new(1, 0, 0, 24)
        stealLbl.Position = UDim2.new(0, 0, 0, 0)
        stealLbl.BackgroundTransparency = 1
        stealLbl.Text = ""
        stealLbl.Visible = false
        stealLbl.TextColor3 = SPEED_BASE_COLOR
        stealLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        stealLbl.Font = Enum.Font.GothamBlack
        stealLbl.TextScaled = true
        stealLbl.TextStrokeTransparency = 0
        _G._catalystStealLbl = stealLbl

        local discLbl = Instance.new("TextLabel", bb)
        discLbl.Name = "DiscordBillLbl"
        discLbl.Size = UDim2.new(1, 0, 0, 20)
        discLbl.Position = UDim2.new(0, 0, 0, 26)
        discLbl.BackgroundTransparency = 1
        discLbl.Text = "discord.gg/RLMDUELS"
        discLbl.TextColor3 = SPEED_BASE_COLOR
        discLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        discLbl.Font = Enum.Font.GothamBold
        discLbl.TextScaled = true
        discLbl.TextStrokeTransparency = 0.1
        table.insert(speedLabels, discLbl)
        pcall(function() if ensureSpeedLabelGradient then ensureSpeedLabelGradient(discLbl) end end)

        speedLbl = Instance.new("TextLabel", bb)
        speedLbl.Name = "SpeedBillLbl"
        speedLbl.Size = UDim2.new(1, 0, 0, 28)
        speedLbl.Position = UDim2.new(0, 0, 0, 50)
        speedLbl.BackgroundTransparency = 1
        speedLbl.Text = "0.0"
        speedLbl.TextColor3 = SPEED_BASE_COLOR
        speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        speedLbl.Font = Enum.Font.GothamBlack
        speedLbl.TextScaled = true
        speedLbl.TextStrokeTransparency = 0
        table.insert(speedLabels, speedLbl)
        pcall(function() if ensureSpeedLabelGradient then ensureSpeedLabelGradient(speedLbl) end end)

        pcall(function()
        end)
    end

    if State.unwalkEnabled then State.unwalkEnabled = false; task.wait(0.3); startUnwalk() end

    pcall(function() fullMovementCleanup(char) end)
    State.autoLeftPhase = 1
    State.autoRightPhase = 1

    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if hum and root and hum.Health > 0 then
        if State.autoLeftEnabled then
            pcall(function()
                local fn = _G._startAutoLeft or startAutoLeft
                if fn then fn() end
            end)
        end
        if State.autoRightEnabled then
            pcall(function()
                local fn = _G._startAutoRight or startAutoRight
                if fn then fn() end
            end)
        end
        if State.animPack and State.animPack ~= "Off" then
            pcall(applyAnimPackWithHeartbeat, State.animPack)
        end
        if State.accessoryPack and State.accessoryPack ~= "Off" then
            pcall(applyAccessoryPack, State.accessoryPack)
        end
        if State.bypassToggled then
            startBypassAimbot()
        end
    end
end

LP.CharacterRemoving:Connect(function(char)
    pcall(function() fullMovementCleanup(char) end)
end)
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

task.spawn(function()
    local otherEntries = {} -- {lbl=, hrp=}
    local function addBillboard(char)
        task.wait(0.25)
        if not char or not char.Parent then return end
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not head or not hrp then return end
        local oldBB = head:FindFirstChild("KzOtherBB")
        if oldBB then oldBB:Destroy() end
        local bb = Instance.new("BillboardGui", head)
        bb.Name = "KzOtherBB"
        bb.Size = UDim2.new(0, 70, 0, 20)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        local speedLbl = Instance.new("TextLabel", bb)
        speedLbl.Size = UDim2.new(1, 0, 1, 0)
        speedLbl.BackgroundTransparency = 1
        speedLbl.Text = "0"
        speedLbl.TextColor3 = SPEED_BASE_COLOR
        speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        speedLbl.Font = Enum.Font.GothamBlack
        speedLbl.TextScaled = true
        speedLbl.TextStrokeTransparency = 0.2
        table.insert(speedLabels, speedLbl)
        table.insert(otherEntries, {lbl = speedLbl, hrp = hrp})
    end
    for _, player in ipairs(getPlayersCached()) do
        if player ~= LP then
            if player.Character then task.spawn(addBillboard, player.Character) end
            player.CharacterAdded:Connect(addBillboard)
        end
    end
    Players.PlayerAdded:Connect(function(player)
        if player == LP then return end
        player.CharacterAdded:Connect(addBillboard)
        if player.Character then task.spawn(addBillboard, player.Character) end
    end)
    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        acc = acc + (dt or 0.016)
        if acc < 0.4 then return end
        acc = 0
        for i = #otherEntries, 1, -1 do
            local e = otherEntries[i]
            if not e.lbl or not e.lbl.Parent or not e.hrp or not e.hrp.Parent then
                table.remove(otherEntries, i)
            else
                local v = e.hrp.AssemblyLinearVelocity
                e.lbl.Text = string.format("%.0f", math.sqrt(v.X*v.X + v.Z*v.Z))
            end
        end
    end)
end)

local lastSpeedUpdate = 0
local _spdLblAcc = 0
local _spdPhysAcc = 0
RunService.Heartbeat:Connect(function(dt)
    if _G._catalystShuttingDown then return end
    if _G.__CATALYST_BOOTING then return end
    if not (h and hrp) then return end
    if not h.Parent or not hrp.Parent then return end

    local skipSpeed = State.autoLeftEnabled or State.autoRightEnabled or (_G.CatalystBat and _G.CatalystBat.active)
        or State.bypassToggled or _G.CatalystTpBatOn

    _spdLblAcc = _spdLblAcc + (dt or 0.016)
    if speedLbl and _spdLblAcc >= 0.5 then
        _spdLblAcc = 0
        local md = h.MoveDirection
        local moving = (md.Magnitude > 0.01) or State.autoLeftEnabled or State.autoRightEnabled
        local shown
        if moving then
            local real = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z).Magnitude
            shown = (real > 1) and real or getCurrentSpeed()
        else
            shown = 0
        end
        speedLbl.Text = string.format("%.1f - %s", shown, getSpeedModeLabel())
    end

    -- física de speed: no cada frame si no hace falta
    _spdPhysAcc = _spdPhysAcc + (dt or 0.016)
    local needPhys = (not skipSpeed) and (h.MoveDirection.Magnitude > 0.01 or State.speedMode or State.laggerToggled)
    if not needPhys and _spdPhysAcc < 0.08 then return end
    if needPhys and _spdPhysAcc < 0.016 then return end
    _spdPhysAcc = 0

    if isRagdolledState(h) then
        clearSpeedVectorForce(hrp)
        if not skipSpeed then
            clearLinearVelocity(hrp)
            State.lastMoveDir = Vector3.zero
        end
        return
    end

    if skipSpeed then
        clearSpeedVectorForce(hrp)
        if (_G.CatalystBat and _G.CatalystBat.active) or State.bypassToggled or _G.CatalystTpBatOn then
            pcall(function() clearLinearVelocity(hrp) end)
        end
        return
    end

    if State.dropEnabled then
        return
    end

    local md = h.MoveDirection
    local st = h:GetState()
    local inAir = (st == Enum.HumanoidStateType.Jumping
        or st == Enum.HumanoidStateType.Freefall)

    if md.Magnitude > 0.01 and h.Health > 0 then
        State.lastMoveDir = md
        local spd = getCurrentSpeed()
        local moveDir = md.Unit
        setLinearVelocityXZ(hrp, moveDir.X * spd, moveDir.Z * spd)
    else
        State.lastMoveDir = Vector3.zero
        if not inAir then
            clearLinearVelocity(hrp)
            clearSpeedVectorForce(hrp)
        else
            pcall(function()
                local lv = hrp:FindFirstChild("KzLinearVelocity")
                if lv then lv.Enabled = false end
            end)
        end
        if not State.bodyLockEnabled and not State.spinEnabled then
            if not inAir and math.abs(hrp.AssemblyAngularVelocity.Y) > 0.5 then
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
            if h and not h.AutoRotate then
                h.AutoRotate = true
            end
        end
    end
end)

local _infJumpRayParams = RaycastParams.new()
_infJumpRayParams.FilterType = Enum.RaycastFilterType.Exclude
_infJumpRayParams.IgnoreWater = true

local function setupInfJumpPhysics(char)
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return nil end
    local att = hrp:FindFirstChild("InfJumpAttachment")
    if not att then
        att = Instance.new("Attachment")
        att.Name = "InfJumpAttachment"
        att.Parent = hrp
    end
    local lv = hrp:FindFirstChild("InfJumpVelocity")
    if not lv then
        lv = Instance.new("LinearVelocity")
        lv.Name = "InfJumpVelocity"
        lv.Attachment0 = att
        lv.MaxForce = 25000
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
        lv.LineDirection = Vector3.new(0, 1, 0)
        lv.LineVelocity = 0
        lv.Enabled = false
        lv.Parent = hrp
    end
    return lv
end

local function isCeilingAbove(char)
    local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not head then return false end
    _infJumpRayParams.FilterDescendantsInstances = {char}
    local hit = workspace:Raycast(head.Position, Vector3.new(0, 2.5, 0), _infJumpRayParams)
    return hit ~= nil
end

-- Hold suave (estilo Clean Anti Bat = 50). No mata ni pelea con anti-bat.
local INF_JUMP_FORCE = 52
local INF_HOLD_SPEED = 50

local _infAcc = 0
local _infJumpCooldown = 0
RunService.Heartbeat:Connect(function(dt)
    if not State.infJumpEnabled then return end
    _infAcc = _infAcc + (dt or 0.016)
    if _infAcc < 0.03 then return end
    _infAcc = 0
    local char = LP.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local lv = hrp:FindFirstChild("InfJumpVelocity")
    if lv then
        lv.Enabled = false
        lv.LineVelocity = 0
    end

    if State.infJumpMode == "hold" then
        local holding = humanoid.Jump == true
            or UIS:IsKeyDown(Enum.KeyCode.Space)
            or UIS:IsKeyDown(Enum.KeyCode.ButtonA)
        if holding and not isCeilingAbove(char) then
            -- Compatible con anti-bat: solo sube Y si está bajo, no toca XZ
            local v = hrp.AssemblyLinearVelocity
            if v.Y < INF_HOLD_SPEED then
                hrp.AssemblyLinearVelocity = Vector3.new(v.X, INF_HOLD_SPEED, v.Z)
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    if State.infJumpMode == "hold" then return end -- hold ya lo maneja Heartbeat
    local now = tick()
    if now - _infJumpCooldown < 0.06 then return end
    _infJumpCooldown = now
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end
    if isCeilingAbove(char) then return end

    local v = hrp.AssemblyLinearVelocity
    hrp.AssemblyLinearVelocity = Vector3.new(v.X, INF_JUMP_FORCE, v.Z)
end)

LP.CharacterAdded:Connect(function(char)
    task.defer(function() setupInfJumpPhysics(char) end)
end)
if LP.Character then task.defer(function() setupInfJumpPhysics(LP.Character) end) end

local _moveLoopAcc = 0
RunService.Heartbeat:Connect(function(dt)
    local char = LP.Character
    if not char then return end
    local featureMove = State.autoLeftEnabled or State.autoRightEnabled or (_G.CatalystBat and _G.CatalystBat.active) or _G.CatalystTpBatOn
    -- cuando no hay features activas, correr más lento
    _moveLoopAcc = _moveLoopAcc + (dt or 0.016)
    local needFast = featureMove or State.speedMode or State.laggerToggled or State.dropEnabled
    if not needFast and _moveLoopAcc < 0.15 then return end
    if needFast and _moveLoopAcc < 0.016 then return end
    _moveLoopAcc = 0
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    if isRagdolledState(hum) then
        if not featureMove then
            hardStopMovement(root, hum)
        else
            clearSpeedVectorForce(root)
        end
        return
    end

    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Running or st == Enum.HumanoidStateType.Freefall or st == Enum.HumanoidStateType.Jumping then
        if hum.PlatformStand then hum.PlatformStand = false end
        if hum.Sit then hum.Sit = false end
    end

    if not featureMove then
        local lv = root:FindFirstChild("KzLinearVelocity")
        local md = hum.MoveDirection
        if lv and lv.Enabled then
            if md.Magnitude < 0.05 then
                clearLinearVelocity(root)
            elseif lv.VelocityConstraintMode == Enum.VelocityConstraintMode.Vector then
                local v = lv.VectorVelocity
                if v.Magnitude < 0.5 then
                    clearLinearVelocity(root)
                end
            end
        end
        local vf = root:FindFirstChild("SpeedVectorForce")
        if vf and vf.Enabled and md.Magnitude < 0.05 then
            vf.Force = Vector3.zero
            vf.Enabled = false
        end
        if md.Magnitude < 0.05 then
            local ang = root.AssemblyAngularVelocity
            if ang.Magnitude > 1 and not State.spinEnabled then
                root.AssemblyAngularVelocity = Vector3.zero
            end
            if not hum.AutoRotate then
                hum.AutoRotate = true
            end
        end
    end
end)

local antiPlayerCollisionConn = nil
local function startAntiPlayerCollision()
    if antiPlayerCollisionConn then return end
    local _apcAcc = 0
    antiPlayerCollisionConn = RunService.Heartbeat:Connect(function(dt)
        if not State.antiPlayerCollision then return end
        _apcAcc = _apcAcc + (dt or 0.016)
        if _apcAcc < 0.22 then return end
        _apcAcc = 0
        for _, player in ipairs(getPlayersCached()) do
            if player ~= LP and player.Character then
                for _, part in ipairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end
local function stopAntiPlayerCollision()
    if antiPlayerCollisionConn then
        antiPlayerCollisionConn:Disconnect()
        antiPlayerCollisionConn = nil
    end
end
if State.antiPlayerCollision then
    task.spawn(function() task.wait(0.3); startAntiPlayerCollision() end)
end

local e01Running = false
local e01Thread = nil

do
local _carryCacheVal, _carryCacheAt = false, 0
local function isCarryingE01()
    local now = tick()
    if now - _carryCacheAt < 0.2 then
        return _carryCacheVal
    end
    _carryCacheAt = now

    local char = LP.Character
    if not char then
        _carryCacheVal = false
        return false
    end

    -- atributos rápidos
    local ok, stealing = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and stealing == true then _carryCacheVal = true; return true end
    ok, stealing = pcall(function() return char:GetAttribute("Stealing") end)
    if ok and stealing == true then _carryCacheVal = true; return true end
    local ok2, carrying = pcall(function() return LP:GetAttribute("Carrying") end)
    if ok2 and carrying == true then _carryCacheVal = true; return true end
    ok2, carrying = pcall(function() return char:GetAttribute("Carrying") end)
    if ok2 and carrying == true then _carryCacheVal = true; return true end

    if State.speedMode == true or State.carrySpeedActive == true then
        _carryCacheVal = true
        return true
    end

    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") or child:IsA("Model") then
            local name = child.Name:lower()
            if name:find("brain") or name:find("rot") or name:find("animal") or name:find("steal") or name:find("carry") then
                _carryCacheVal = true
                return true
            end
        end
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 28 and humanoid.WalkSpeed ~= 16 then
        _carryCacheVal = true
        return true
    end

    _carryCacheVal = false
    return false
end

_G.isCarryingBrainrot = isCarryingE01

local function startE01HeadCountdown()
    local char = LP.Character
    if not char or not char:FindFirstChild("Head") then return end

    local head = char.Head

    if head:FindFirstChild("HeadStealUI") then
        head.HeadStealUI:Destroy()
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HeadStealUI"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 220, 0, 35)
    billboard.StudsOffset = Vector3.new(0, 12.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.35, 0)
    corner.Parent = frame

    local border = Instance.new("UIStroke")
    border.Color = Color3.fromRGB(255, 255, 0)
    border.Thickness = 2
    border.Transparency = 0
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.TextStrokeTransparency = 0.2
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.Text = "DONT STEAL"
    textLabel.TextXAlignment = Enum.TextXAlignment.Center
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.Parent = frame

    local isComplete = false
    local startTime = tick()
    local totalDuration = 3.0

    local function animateBorderColors()
        while not isComplete do
            local elapsed = tick() - startTime
            local progress = math.min(elapsed / totalDuration, 1)

            if progress < 0.33 then
                border.Color = Color3.fromRGB(255, 255, 0)
                border.Thickness = 1.5 + (progress / 0.33) * 0.5
            elseif progress < 0.66 then
                local t = (progress - 0.33) / 0.33
                local r = 255
                local g = 255 * (1 - t)
                local b = 0
                border.Color = Color3.fromRGB(r, g, b)
                border.Thickness = 2 + t * 0.3
            else
                local t = (progress - 0.66) / 0.34
                local r = 255 * (1 - t)
                local g = 0 + t * 255
                local b = 0
                border.Color = Color3.fromRGB(r, g, b)
                border.Thickness = 2.3 + t * 0.3
            end

            if progress >= 1 and not isComplete then
                isComplete = true
                textLabel.Text = "ENTER!!!"
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextSize = 16

                border.Color = Color3.fromRGB(0, 255, 0)
                border.Thickness = 3
                task.wait(0.4)

                border.Color = Color3.fromRGB(200, 200, 200)
                border.Thickness = 2.5
                task.wait(0.4)

                border.Color = Color3.fromRGB(100, 100, 100)
                border.Thickness = 2
                task.wait(0.4)

                local fadeBorder = TweenService:Create(border, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 1,
                    Thickness = 0
                })
                fadeBorder:Play()

                local fadeText = TweenService:Create(textLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 1,
                    TextStrokeTransparency = 1
                })
                fadeText:Play()

                local fadeFrame = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                })
                fadeFrame:Play()

                task.wait(0.4)
                billboard:Destroy()
                break
            end

            task.wait(0.05)
        end
    end

    task.spawn(animateBorderColors)
end

function startE01Detection()
    if e01Running then return end
    e01Running = true
    local wasCarrying = false
    e01Thread = task.spawn(function()
        while State.e01Enabled and e01Running do
            local currentlyCarrying = isCarryingE01()
            if not wasCarrying and currentlyCarrying then
                startE01HeadCountdown()
            end
            wasCarrying = currentlyCarrying
            task.wait(0.1)
        end
        e01Running = false
        e01Thread = nil
    end)
end

function stopE01Detection()
    e01Running = false
    if e01Thread then
        task.cancel(e01Thread)
        e01Thread = nil
    end
end

function loadConfigState()
    local hasFile=false; pcall(function() hasFile=isfile(FileName) end); if not hasFile then return end
    local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end); if not ok or not cfg then return end
    if type(cfg.normalSpeed)=="number" then State.normalSpeed=cfg.normalSpeed end
    if type(cfg.carrySpeed)=="number" then State.carrySpeed=cfg.carrySpeed end
    if type(cfg.laggerSpeed1)=="number" then State.laggerSpeed1=cfg.laggerSpeed1 end
    if type(cfg.laggerSpeed2)=="number" then State.laggerSpeed2=cfg.laggerSpeed2 end
    if type(cfg.laggerLevel)=="number" then State.laggerLevel=cfg.laggerLevel end
    if cfg.speedType=="normal" or cfg.speedType=="carry" then State.speedType=cfg.speedType end
    if type(cfg.autoCarryEnabled)=="boolean" then State.autoCarryEnabled=cfg.autoCarryEnabled end
    if cfg.infJumpEnabled then State.infJumpEnabled=true end
    if cfg.infJumpMode=="manual" or cfg.infJumpMode=="hold" then State.infJumpMode=cfg.infJumpMode end
    if type(cfg.antiRagdollV1Enabled)=="boolean" then State.antiRagdollV1Enabled=cfg.antiRagdollV1Enabled end
    if type(cfg.antiRagdollV2Enabled)=="boolean" then State.antiRagdollV2Enabled=cfg.antiRagdollV2Enabled end
    if type(cfg.antiRagdollActiveVersion)=="number" then State.antiRagdollActiveVersion=cfg.antiRagdollActiveVersion end
    if State.antiRagdollActiveVersion == 1 then
        startAntiRagdollV1()
    elseif State.antiRagdollActiveVersion == 2 then
        startAntiRagdollV2()
    end
    if type(cfg.nukeLevel)=="number" and cfg.nukeLevel>0 then
        local lvl = cfg.nukeLevel
        task.delay(2.5, function() pcall(setNukeLevel, lvl) end)
    elseif cfg.nukeEnabled then
        task.delay(2.5, function() pcall(setNukeLevel, 3) end)
    end
    if cfg.medusaCounterEnabled then State.medusaCounterEnabled=true; setupMedusaCounter(LP.Character) end
    if cfg.unwalkEnabled then task.spawn(function() task.wait(0.5); startUnwalk() end) end
    if type(cfg.autoBatToggled)=="boolean" then
        State.autoBatToggled = cfg.autoBatToggled
        if State.autoBatToggled then
            task.spawn(function() _G.CatalystStartBat() end)
        end
    end
    State.autoLeftEnabled = false
    State.autoRightEnabled = false
    if cfg.dropEnabled ~= nil then State.dropEnabled = cfg.dropEnabled end
    if type(cfg.antiPlayerCollision)=="boolean" then
        State.antiPlayerCollision = cfg.antiPlayerCollision
        if State.antiPlayerCollision then task.spawn(function() task.wait(0.4); startAntiPlayerCollision() end) end
    end
    if type(cfg.bypassToggled)=="boolean" then
        State.bypassToggled = cfg.bypassToggled
        if State.bypassToggled then
            task.spawn(function() startBypassAimbot() end)
        end
    end
    if type(cfg.bypassMode)=="number" and (cfg.bypassMode==1 or cfg.bypassMode==2) then State.bypassMode=cfg.bypassMode end
    if type(cfg.bypassSpeed)=="number" then State.bypassSpeed=cfg.bypassSpeed end
    if type(cfg.tpBatMode)=="number" and (cfg.tpBatMode==1 or cfg.tpBatMode==2) then
        State.tpBatMode = cfg.tpBatMode
    end
    if type(cfg.tpBatStuds)=="number" then
        State.tpBatStuds = math.clamp(cfg.tpBatStuds, 0.5, 25)
    end
    if type(cfg.antiDieEnabled)=="boolean" and cfg.antiDieEnabled then
        State.antiDieEnabled = true
        task.spawn(function() task.wait(0.3); startAntiDie() end)
    end
    if type(cfg.bodyLockEnabled)=="boolean" then
        State.bodyLockEnabled = cfg.bodyLockEnabled
        if cfg.bodyLockEnabled then
            task.spawn(function()
                task.wait(0.45)
                if setBodyLock then
                    setBodyLock(true)
                elseif startBodyLock then
                    startBodyLock()
                end
            end)
        end
    end
    if type(cfg.bodyLockRange)=="number" then
        State.bodyLockRange = math.clamp(cfg.bodyLockRange, 4, 80)
    end
    if type(cfg.playerSPEnabled)=="boolean" then
        State.playerSPEnabled = cfg.playerSPEnabled
        -- playerSP auto-start disabled
    end
    if type(cfg.uiLocked)=="boolean" then
        State.uiLocked = cfg.uiLocked
    end
    if type(cfg.bgFondoIndex)=="number" then
        pcall(function() setFondoUI(cfg.bgFondoIndex) end)
    end
    if type(cfg.korbloxEnabled)=="boolean" then
        State.korbloxEnabled = cfg.korbloxEnabled
        if State.korbloxEnabled then
            task.spawn(function()
                attachKorbloxLeg("LeftLeg", {
                    targetBodyPart = "LeftLowerLeg",
                    partsToHide = {"LeftLeg", "LeftLowerLeg"},
                    id = "rbxassetid://12659408365",
                    scale = 1,
                    offset = CFrame.new(0, 0, 0)
                })
            end)
        end
    end
    if type(cfg.headlessEnabled)=="boolean" then
        State.headlessEnabled = cfg.headlessEnabled
        if State.headlessEnabled then
            task.spawn(function()
                attachHeadless()
            end)
        end
    end
    if type(cfg.animPack)=="string" and cfg.animPack ~= "Off" then
        State.animPack = cfg.animPack
        task.spawn(function()
            pcall(applyAnimPackWithHeartbeat, State.animPack)
        end)
    else
        State.animPack = "Off"
    end
    if type(cfg.accessoryPack)=="string" and cfg.accessoryPack ~= "Off" then
        State.accessoryPack = cfg.accessoryPack
        task.spawn(function()
            pcall(applyAccessoryPack, State.accessoryPack)
        end)
    else
        State.accessoryPack = "Off"
    end
    if type(cfg.e01Enabled)=="boolean" then
        State.e01Enabled = cfg.e01Enabled
        if State.e01Enabled then
            task.spawn(function() startE01Detection() end)
        end
    end
    local function loadKey(cfgKey, stateKey)
        if type(cfg[cfgKey])=="string" and cfg[cfgKey]~="Unknown" then
            local ok2,kc=pcall(function() return Enum.KeyCode[cfg[cfgKey]] end)
            if ok2 and kc then State[stateKey]=kc; local chip=keybindChipRefs[stateKey]; if chip then chip.Text=kc.Name end end
        end
    end
    loadKey("keyAutoLeft","keyAutoLeft")
    loadKey("keyAutoRight","keyAutoRight")
    loadKey("keyDropBR","keyDropBR")
    loadKey("keyTpDown","keyTpDown")
    loadKey("keyAutoBat","keyAutoBat")
    loadKey("keySpeedToggle","keySpeedToggle")
    loadKey("keyLagger","keyLagger")
    loadKey("keyLagger1","keyLagger1")
    loadKey("keyLagger2","keyLagger2")
    loadKey("keyBatAim2","keyBatAim2")
    loadKey("keyTpBat","keyTpBat")
    loadKey("keyInstaReset","keyInstaReset")
    loadKey("keyBatV2","keyBatV2")
    if cfg.skyEnabled then State.skyEnabled=cfg.skyEnabled; if cfg.skyEnabled then task.spawn(function() enableSky(cfg.skyColorIndex or 1) end) end end
    if cfg.skyColorIndex then State.skyColorIndex=cfg.skyColorIndex end
    if cfg.floatEnabled then State.floatEnabled=cfg.floatEnabled; if cfg.floatEnabled then task.spawn(function() startFloat() end) end end
    if cfg.floatHeight then State.floatHeight=cfg.floatHeight end
    if cfg.stretchRezEnabled then State.stretchRezEnabled=cfg.stretchRezEnabled; if cfg.stretchRezEnabled then task.spawn(function() enableStretchRez() end) end end
    if cfg.batCounterEnabled then State.batCounterEnabled=cfg.batCounterEnabled; if cfg.batCounterEnabled then task.spawn(function() startBatCounter() end) end end
    if cfg.waypointESPEnabled then State.waypointESPEnabled=cfg.waypointESPEnabled; if cfg.waypointESPEnabled then task.spawn(function() startWaypointESP() end) end end
    if cfg.controllerEnabled then State.controllerEnabled=cfg.controllerEnabled; if cfg.controllerEnabled then task.spawn(function() startControllerSupport() end) end end
    if cfg.mobileLocked ~= nil then State.mobileLocked = cfg.mobileLocked end
    if type(cfg.guiScale)=="number" then
        State.guiScale = cfg.guiScale
        task.spawn(function() if applyGuiScale then applyGuiScale(cfg.guiScale) end end)
    end
    if cfg.floatBtnShape == "Capsule" or cfg.floatBtnShape == "Square" then
        State.floatBtnShape = cfg.floatBtnShape
        task.defer(function()
            if _G.CatalystSetFloatBtnShape then _G.CatalystSetFloatBtnShape(cfg.floatBtnShape) end
            if _G._refreshFloatBtnShapeUI then _G._refreshFloatBtnShapeUI() end
        end)
    end
    if type(cfg.mbButtonScale)=="number" then
        mbScaleFactor = cfg.mbButtonScale
        task.spawn(function() applyMBScale(mbScaleFactor) end)
    end
    task.spawn(function()
        task.wait(0.15)
        if setMB_AL then setMB_AL(State.autoLeftEnabled) end; if setMB_AR then setMB_AR(State.autoRightEnabled) end; if setMB_AB then setMB_AB(State.autoBatToggled) end
        if setMB_CS then setMB_CS(State.speedType=="carry") end
        updateLaggerButtons()
        syncDropButtons()
        if State.dropEnabled then toggleDropGlitch(true) end
        refreshUIToggles()
        -- GUI ya se construye una sola vez fuera; evita segundo buildFullGUI pesado
        -- buildFullGUI()
    end)
end

loadMainPosition(); loadMiniPosition()
if not State.guiVisible then
    main.Visible = false
    mini.Visible = true
    pcall(applyMiniStyle, State.miniStyle or 1)
end
pcall(function()
    if mini then
        mini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        mini.BackgroundTransparency = 0
    end
end)
pcall(function() loadPos(mbGroup, "KzsHubMBPos.txt") end)
refreshUIToggles(); loadConfigState()

local BAT_V2_SPEED = 58
local BAT_V2_HIT_DIST = 13

local bypassConn = nil
local bypassSafetyConn = nil
local bypassRespawnConn = nil
local bypassState = {
    safetyConn = nil,
    enabled = false,
    equipped = false,
    target = nil,
    intendedVelocity = Vector3.zero,
    attachment = nil,
    angularVelocity = nil,
}

local BYPASS_LOCK_NAMES = {
    "LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
    "AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock",
    -- scripts externos / anti-bat ajenos: no pelear
    "AntiBat", "AntiBatV2", "AntiBatDetect", "BatDetect", "BodyVelocity",
    "AngularVelocity", "LinearVelocity", "VectorForce", "AlignOrientation",
    "CarryBoostLV", "KzLinearVelocity", "InfJumpVelocity", "CatalystSpinBAV",
}

local function bypassClearLocks(root)
    if not root then return end
    pcall(function()
        for _, name in ipairs(BYPASS_LOCK_NAMES) do
            local o = root:FindFirstChild(name)
            if o then o:Destroy() end
        end
        for _, child in ipairs(root:GetChildren()) do
            if child.Name ~= "_GB_AngV" and child.Name ~= "_GB_Att" then
                local n = child.Name:lower()
                if n:find("lockb") or n:find("lockangv") or n:find("batlock")
                    or n:find("antiaim") or n:find("velocitylock") then
                    child:Destroy()
                end
            end
        end
    end)
end

local function bypassDestroyAng()
    pcall(function()
        if bypassState.angularVelocity and bypassState.angularVelocity.Parent then
            bypassState.angularVelocity:Destroy()
        end
    end)
    pcall(function()
        if bypassState.attachment and bypassState.attachment.Parent then
            bypassState.attachment:Destroy()
        end
    end)
    bypassState.angularVelocity = nil
    bypassState.attachment = nil
end

local function bypassEnsureAng(root)
    if not root then return end
    pcall(function()
        local oldV = root:FindFirstChild("_GB_AngV")
        local oldA = root:FindFirstChild("_GB_Att")
        if oldV then oldV:Destroy() end
        if oldA then oldA:Destroy() end
    end)
    local att = Instance.new("Attachment")
    att.Name = "_GB_Att"
    att.Parent = root
    local ang = Instance.new("AngularVelocity")
    ang.Name = "_GB_AngV"
    ang.Attachment0 = att
    ang.RelativeTo = Enum.ActuatorRelativeTo.World
    ang.MaxTorque = math.huge
    ang.AngularVelocity = Vector3.zero
    ang.Parent = root
    bypassState.attachment = att
    bypassState.angularVelocity = ang
end

local function getClosestRootV2(fromRoot)
    if not fromRoot then return nil, math.huge end
    local best, bestD = nil, math.huge
    for _, p in ipairs(getPlayersCached()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local th = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and th and th.Health > 0 then
                local d = (tr.Position - fromRoot.Position).Magnitude
                if d < bestD then
                    bestD = d
                    best = tr
                end
            end
        end
    end
    return best, bestD
end


function startBypassAimbot()
    if bypassConn then
        pcall(function() bypassConn:Disconnect() end)
        bypassConn = nil
    end
    if bypassState.safetyConn then
        pcall(function() bypassState.safetyConn:Disconnect() end)
        bypassState.safetyConn = nil
    end

    bypassState.enabled = true
    bypassState.equipped = false
    bypassState.target = nil
    bypassState.intendedVelocity = Vector3.zero
    bypassState.speed = 58
    bypassState.swingRange = 14

    local char0 = LP.Character
    local root0 = char0 and char0:FindFirstChild("HumanoidRootPart")
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if root0 then
        bypassClearLocks(root0)
        bypassEnsureAng(root0)
        -- reset dirección residual al activar
        root0.AssemblyLinearVelocity = Vector3.zero
        root0.AssemblyAngularVelocity = Vector3.zero
        pcall(function() root0.Velocity = Vector3.zero end)
        if hum0 then
            hum0.AutoRotate = false
            pcall(function() hum0:Move(Vector3.zero, false) end)
        end
        local best, bestD = nil, 250
        for _, p in ipairs(getPlayersCached()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - root0.Position).Magnitude
                    if d < bestD then bestD = d; best = hrp end
                end
            end
        end
        if best then
            root0.CFrame = CFrame.new(root0.Position, Vector3.new(best.Position.X, root0.Position.Y, best.Position.Z))
        end
    end

    bypassConn = RunService.Heartbeat:Connect(function()
        if _G._catalystShuttingDown then return end
        if not State.bypassToggled or not bypassState.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or not hum or hum.Health <= 0 then return end

        -- Anti-fling vs anti-bat: si te empujan, clampa
        do
            local vel = root.AssemblyLinearVelocity
            local mag = vel.Magnitude
            if mag > 100 then
                root.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(vel.X, -65, 65),
                    math.clamp(vel.Y, -40, 50),
                    math.clamp(vel.Z, -65, 65)
                )
            elseif vel.Y > 70 then
                root.AssemblyLinearVelocity = Vector3.new(vel.X, 30, vel.Z)
            end
            if not State.spinEnabled and root.AssemblyAngularVelocity.Magnitude > 40 then
                root.AssemblyAngularVelocity = Vector3.zero
            end
            pcall(function()
                local lv = root:FindFirstChild("KzLinearVelocity")
                if lv then lv.Enabled = false end
            end)
        end

        local nowClr = tick()
        if nowClr - (bypassState._lastClear or 0) > 0.35 then
            bypassState._lastClear = nowClr
            bypassClearLocks(root)
        end
        if not bypassState.angularVelocity or not bypassState.angularVelocity.Parent then
            bypassEnsureAng(root)
        end

        if not bypassState.equipped then
            bypassState.equipped = true
            if not char:FindFirstChildOfClass("Tool") then
                local bat0 = (findBat and findBat()) or nil
                if not bat0 then
                    for _, t in ipairs((LP:FindFirstChildOfClass("Backpack") and LP.Backpack:GetChildren()) or {}) do
                        if t:IsA("Tool") then
                            local n = t.Name:lower()
                            if n:find("bat") or n:find("slap") then bat0 = t; break end
                        end
                    end
                end
                if bat0 then pcall(function() hum:EquipTool(bat0) end) end
            end
        end

        local targetRoot, dist = getClosestRootV2(root)
        if not targetRoot then
            bypassState.target = nil
            hum.AutoRotate = true
            if bypassState.angularVelocity then
                bypassState.angularVelocity.AngularVelocity = Vector3.zero
            end
            pcall(function() hum:Move(Vector3.zero, false) end)
            pcall(function() clearTpPinkMarker() end)
            return
        end
        bypassState.target = targetRoot
        local nowMk = tick()
        if nowMk - (bypassState._lastMarker or 0) > 0.25 then
            bypassState._lastMarker = nowMk
            pcall(function() setTpPinkMarker(targetRoot) end)
        end

        local tVel = targetRoot.AssemblyLinearVelocity or Vector3.zero
        local aimPos = targetRoot.Position + Vector3.new(tVel.X, 0, tVel.Z) * 0.04
        local delta = aimPos - root.Position
        local flat = Vector3.new(delta.X, 0, delta.Z)
        hum.AutoRotate = false

        -- bypass: sin AngularVelocity agresivo (evita irse de lado)
        if bypassState.angularVelocity then
            bypassState.angularVelocity.AngularVelocity = Vector3.zero
        end
        if flat.Magnitude > 0.05 then
            pcall(function()
                root.CFrame = CFrame.new(root.Position, Vector3.new(aimPos.X, root.Position.Y, aimPos.Z))
            end)
        end

        local spd = tonumber(bypassState.speed) or 57
        local unit = flat.Magnitude > 0.12 and flat.Unit or Vector3.zero
        local yCorr = math.clamp((aimPos.Y + 1.4) - root.Position.Y, -20, 28)
        if flat.Magnitude < 4.5 then
            spd = math.min(spd, 42)
        end
        local intended = Vector3.new(unit.X * spd, yCorr, unit.Z * spd)
        local mag = math.sqrt(intended.X * intended.X + intended.Z * intended.Z)
        if mag > 70 then
            intended = Vector3.new(intended.X / mag * 70, intended.Y, intended.Z / mag * 70)
        end
        bypassState.intendedVelocity = intended
        root.AssemblyLinearVelocity = intended

        if flat.Magnitude > 0.35 then
            pcall(function() hum:Move(Vector3.new(0, 0, -1), false) end)
        else
            pcall(function() hum:Move(Vector3.zero, false) end)
        end

        local hitDist = flat.Magnitude
        if hitDist <= 14 or dist <= 14 then
            local bat = char:FindFirstChildOfClass("Tool")
            if not bat then
                bat = (findBat and findBat()) or nil
            end
            if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
                if bat.Parent ~= char then
                    pcall(function() hum:EquipTool(bat) end)
                end
                local nowSw = tick()
                if nowSw - (bypassState._lastSwing or 0) >= 0.05 then
                    bypassState._lastSwing = nowSw
                    pcall(function()
                        for _ = 1, 8 do bat:Activate() end
                        for _, rem in ipairs(bat:GetDescendants()) do
                            if rem:IsA("RemoteEvent") then
                                pcall(function() rem:FireServer() end)
                            end
                        end
                        local handle = bat:FindFirstChild("Handle")
                        local tChar = targetRoot and targetRoot.Parent
                        if handle and tChar and firetouchinterest then
                            for _, p in ipairs(tChar:GetChildren()) do
                                if p:IsA("BasePart") then
                                    firetouchinterest(handle, p, 0)
                                    firetouchinterest(handle, p, 1)
                                end
                            end
                        end
                    end)
                end
            end
        end
    end)

    bypassState._safetyTick = 0
    bypassState.safetyConn = RunService.Heartbeat:Connect(function()
        if not State.bypassToggled or not bypassState.enabled then return end
        bypassState._safetyTick = (bypassState._safetyTick or 0) + 1
        if bypassState._safetyTick % 2 ~= 0 then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        if bypassState.target and bypassState.target.Parent then
            local delta = bypassState.target.Position - hrp.Position
            local flat = Vector3.new(delta.X, 0, delta.Z)
            if flat.Magnitude > 0.3 then
                pcall(function() hum:Move(flat.Unit, false) end)
            end
            local intended = bypassState.intendedVelocity or Vector3.zero
            if math.abs(hrp.AssemblyLinearVelocity.X - intended.X) > 30
               or math.abs(hrp.AssemblyLinearVelocity.Z - intended.Z) > 30 then
                hrp.AssemblyLinearVelocity = intended
            end
        end

        local v = hrp.AssemblyLinearVelocity
        local intended = bypassState.intendedVelocity or Vector3.zero
        if math.abs(v.X) > 120 or math.abs(v.Z) > 120 or math.abs(v.Y) > 90 then
            hrp.AssemblyLinearVelocity = Vector3.new(
                math.clamp(intended.X, -90, 90),
                math.clamp(intended.Y, -55, 55),
                math.clamp(intended.Z, -90, 90)
            )
        end
        if not State.spinEnabled then
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if bypassState._safetyTick % 6 == 0 then
            bypassClearLocks(hrp)
        end
    end)
end

end

function stopBypassAimbot()
    bypassState.enabled = false
    bypassState.equipped = false
    bypassState.target = nil
    bypassState.intendedVelocity = Vector3.zero

    if bypassConn then
        pcall(function() bypassConn:Disconnect() end)
        bypassConn = nil
    end
    if bypassState.safetyConn then
        pcall(function() bypassState.safetyConn:Disconnect() end)
        bypassState.safetyConn = nil
    end

    pcall(function() clearTpPinkMarker() end)

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        if bypassState.angularVelocity then
            pcall(function() bypassState.angularVelocity.AngularVelocity = Vector3.zero end)
        end
        pcall(function()
            local a = root:FindFirstChild("_GB_AngV") or root:FindFirstChild("_CatalystBypass_AngV")
            if a then a:Destroy() end
            local at = root:FindFirstChild("_GB_Att") or root:FindFirstChild("_CatalystBypass_Att")
            if at then at:Destroy() end
        end)
        root.AssemblyAngularVelocity = Vector3.zero
        local v = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(v.X * 0.3, v.Y, v.Z * 0.3)
    end
    if hum then
        hum.AutoRotate = true
        pcall(function() hum:Move(Vector3.zero, false) end)
    end
    bypassState.angularVelocity = nil
    bypassState.attachment = nil
end
-- ============================================================
-- BAT V2 MODE 2 — prediccion + punto rojo (logica completa)
-- ============================================================
local PredBatV2 = {
    conn = nil,
    target = nil,
    swingCooldown = false,
    nextSwingAt = 0,
    approachSpeed = 55,
    activateDistance = 13,
    minFollowDistance = 1,
    predictTime = 0.22,
    predictAhead = 3,
    maxVelocity = 80,
    swingDelay = 0.08,
    showDot = true,
    dotPart = nil,
    dotColor = Color3.fromRGB(220, 30, 45),
    dotSize = 1.5,
}

function predBatV2HideDot()
    if PredBatV2.dotPart then
        pcall(function() PredBatV2.dotPart:Destroy() end)
        PredBatV2.dotPart = nil
    end
end

function predBatV2CreateDot()
    predBatV2HideDot()
    local dot = Instance.new("Part")
    dot.Name = "CatalystPredBatDot"
    dot.Shape = Enum.PartType.Ball
    dot.Size = Vector3.new(PredBatV2.dotSize, PredBatV2.dotSize, PredBatV2.dotSize)
    dot.Color = PredBatV2.dotColor
    dot.Material = Enum.Material.Neon
    dot.CanCollide = false
    dot.CanTouch = false
    dot.CanQuery = false
    dot.Anchored = true
    dot.CastShadow = false
    dot.Transparency = 0
    dot.Parent = workspace

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PredictionGlow"
    billboard.Size = UDim2.new(0, 50, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Adornee = dot
    billboard.LightInfluence = 0
    billboard.Parent = dot

    local glow = Instance.new("ImageLabel", billboard)
    glow.Size = UDim2.new(1, 30, 1, 30)
    glow.Position = UDim2.new(0, -15, 0, -15)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = PredBatV2.dotColor
    glow.ImageTransparency = 0.3

    local hl = Instance.new("Highlight", dot)
    hl.FillColor = PredBatV2.dotColor
    hl.FillTransparency = 0.2
    hl.OutlineColor = Color3.fromRGB(255, 135, 145)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    PredBatV2.dotPart = dot
    return dot
end

function predBatV2UpdateDot(pos)
    if not PredBatV2.showDot then
        if PredBatV2.dotPart then PredBatV2.dotPart.Transparency = 1 end
        return
    end
    if not PredBatV2.dotPart or not PredBatV2.dotPart.Parent then
        predBatV2CreateDot()
    end
    if PredBatV2.dotPart then
        PredBatV2.dotPart.CFrame = CFrame.new(pos)
        PredBatV2.dotPart.Transparency = 0
    end
end

function predBatV2FindBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("bat") or n:find("slap") then return tool end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("slap") then
                    if hum then pcall(function() hum:EquipTool(tool) end) end
                    return tool
                end
            end
        end
    end
    return nil
end

function predBatV2Closest()
    local char = LP.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil, math.huge end
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tr = plr.Character:FindFirstChild("HumanoidRootPart")
            local th = plr.Character:FindFirstChildOfClass("Humanoid")
            if tr and th and th.Health > 0 then
                local d = (tr.Position - myRoot.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = plr
                end
            end
        end
    end
    return best, bestDist
end

function predBatV2Swing()
    if PredBatV2.swingCooldown then return end
    PredBatV2.swingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = predBatV2FindBat()
        if not bat then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if bat.Parent ~= char and hum then
            pcall(function() hum:EquipTool(bat) end)
        end
        pcall(function() bat:Activate() end)
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
        if remote then
            pcall(function() remote:FireServer() end)
        end
        local handle = bat:FindFirstChild("Handle")
        local tRoot = PredBatV2.target
        local tChar = tRoot and tRoot.Parent
        if handle and tChar and firetouchinterest then
            pcall(function() handle.CanTouch = true end)
            for _, pn in ipairs({"HumanoidRootPart", "UpperTorso", "Torso", "Head"}) do
                local tp = tChar:FindFirstChild(pn)
                if tp then
                    pcall(firetouchinterest, handle, tp, 0)
                    pcall(firetouchinterest, handle, tp, 1)
                end
            end
        end
    end)
    task.delay(PredBatV2.swingDelay or 0.08, function()
        PredBatV2.swingCooldown = false
    end)
end

function stopPredictionBatV2()
    if PredBatV2.conn then
        pcall(function() PredBatV2.conn:Disconnect() end)
        PredBatV2.conn = nil
    end
    predBatV2HideDot()
    PredBatV2.target = nil
    PredBatV2.swingCooldown = false
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if root then
            root.AssemblyAngularVelocity = Vector3.zero
        end
        if hum then
            hum.AutoRotate = true
        end
    end
end

function startPredictionBatV2()
    stopPredictionBatV2()
    PredBatV2.approachSpeed = math.clamp(tonumber(State.bypassSpeed) or 55, 40, 70)
    PredBatV2.swingDelay = 0.08
    PredBatV2.activateDistance = 13
    PredBatV2.predictTime = 0.22
    PredBatV2.nextSwingAt = 0
    predBatV2CreateDot()

    PredBatV2.conn = RunService.Heartbeat:Connect(function(dt)
        if not State.bypassToggled or (tonumber(State.bypassMode) or 1) ~= 2 then return end
        if _G._catalystShuttingDown then return end
        if State.autoBatToggled or _G.CatalystBatOn then
            pcall(function() if _G.CatalystStopBat then _G.CatalystStopBat() end end)
            State.autoBatToggled = false
        end

        local char = LP.Character
        if not char then
            predBatV2HideDot()
            return
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then
            if PredBatV2.dotPart then PredBatV2.dotPart.Transparency = 1 end
            return
        end

        -- anti-ragdoll / anti-bat fling (no return: sigue pegando)
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or hum.PlatformStand then
            pcall(function()
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            local v = root.AssemblyLinearVelocity
            if v.Magnitude > 100 then
                root.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(v.X, -55, 55),
                    math.clamp(v.Y, -40, 50),
                    math.clamp(v.Z, -55, 55)
                )
            end
            -- no return: anti-bat te pone Physics 1 frame
        end

        -- anti-fling suave (no tan agresivo = menos retroceso)
        do
            local vel = root.AssemblyLinearVelocity
            if vel.Magnitude > 140 or math.abs(vel.Y) > 120 then
                root.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(vel.X, -90, 90),
                    math.clamp(vel.Y, -80, 100),
                    math.clamp(vel.Z, -90, 90)
                )
            end
            pcall(function() _G._catalystBatVelWrite = tick() end)
        end

        hum.AutoRotate = false

        local bat = predBatV2FindBat()
        if bat and bat.Parent ~= char then
            pcall(function() hum:EquipTool(bat) end)
        end

        local target, targetDist = predBatV2Closest()
        if not target then
            if not State.spinEnabled then
                root.AssemblyAngularVelocity = Vector3.zero
            end
            if PredBatV2.dotPart then PredBatV2.dotPart.Transparency = 1 end
            return
        end

        local targetChar = target.Character
        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHum or targetHum.Health <= 0 then
            if PredBatV2.dotPart then PredBatV2.dotPart.Transparency = 1 end
            return
        end

        PredBatV2.target = targetRoot

        local targetVel = targetRoot.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = targetRoot.Position

        local predictPos = targetPos
            + targetVel * PredBatV2.predictTime
            + targetRoot.CFrame.LookVector * 0.3

        predBatV2UpdateDot(predictPos)

        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.01 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.new(0, 0, 1)
        end

        local chaseSpeed = PredBatV2.approachSpeed
        local desiredHeight = predictPos.Y + 2.4
        local yVel = (desiredHeight - myPos.Y) * 12 + targetVel.Y * 0.45
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.42)
        pcall(function() _G._catalystBatVelWrite = tick() end)

        local predictTime2 = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
        local fullPredict = targetPos + targetVel * predictTime2
        if (fullPredict - myPos).Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, fullPredict)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            if not State.spinEnabled then
                root.AssemblyAngularVelocity =
                    root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
            end
        end

        local now = tick()
        local distToTarget = (myPos - targetPos).Magnitude
        if distToTarget <= PredBatV2.activateDistance and now >= PredBatV2.nextSwingAt then
            PredBatV2.nextSwingAt = now + PredBatV2.swingDelay
            predBatV2Swing()
        end
    end)
end


-- ====== Bat V2 Mode V1 = Clean Hub BatBypass (SnowVS) ======
do
    local BAT_V2_SPEED = 58
    local BAT_V2_HIT_DIST = 9
    local BAT_V2_LEAD_STUDS = 2.8

    local SnowVS = _G.SnowVS or {}
    _G.SnowVS = SnowVS
    SnowVS.BatBypass = SnowVS.BatBypass or {}
    SnowVS.AimbotBypassV2 = SnowVS.BatBypass
    local BB = SnowVS.BatBypass

    BB.Enabled = false
    BB.Connection = nil
    BB.Z = {
        targetPlayer = nil,
        lastTargetPos = nil,
        targetVelocity = Vector3.zero,
        smoothedVelocity = Vector3.zero,
        velocityHistory = {},
        accelerationHistory = {},
        aerialVelocityHistory = {},
        previousDirection = nil,
        lastDirectionChangeTime = 0,
        airborneTime = 0,
        lastActivationTime = 0,
        currentPing = 0.1,
        realPingMs = 0,
    }
    BB.ZCFG = {
        FOLLOW_SPEED = BAT_V2_SPEED,
        ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
        MIN_FOLLOW_DISTANCE = 1,
        PREDICTION_TIME = 0.22,
        PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
        MAX_VELOCITY_CHANGE = 150,
        VELOCITY_SMOOTHING = 0.2,
        MAX_HORIZONTAL_VELOCITY = 80,
        SERVER_TICKRATE = 1 / 60,
        MIN_PING_COMPENSATION = 0.03,
        MAX_PING_COMPENSATION = 0.25,
        ACCELERATION_PREDICTION_WEIGHT = 0.3,
        DIRECTION_CHANGE_DETECTION_TIME = 0.12,
        QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
        GRAVITY = 196.2,
        AIR_CONTROL_FACTOR = 0.8,
        MIN_AIRBORNE_TIME = 0.08,
    }

    local function bbAverageVector(history)
        if #history == 0 then return Vector3.zero end
        local total = Vector3.zero
        for _, v in ipairs(history) do total = total + v end
        return total / #history
    end

    local function bbPushHistory(history, value, maximum)
        table.insert(history, value)
        if #history > maximum then table.remove(history, 1) end
    end

    function BB.FindBat()
        local char = LP.Character
        if not char then return nil end
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then
            local n = equipped.Name:lower()
            if n:find("bat", 1, true) or n:find("slap", 1, true) then
                return equipped
            end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = tool.Name:lower()
                    if n:find("bat", 1, true) or n:find("slap", 1, true) then
                        return tool
                    end
                end
            end
        end
        return nil
    end

    local function bbResetTarget()
        local Z = BB.Z
        Z.targetPlayer = nil
        Z.lastTargetPos = nil
        Z.targetVelocity = Vector3.zero
        Z.smoothedVelocity = Vector3.zero
        Z.velocityHistory = {}
        Z.accelerationHistory = {}
        Z.aerialVelocityHistory = {}
        Z.previousDirection = nil
        Z.airborneTime = 0
    end

    local function bbNearestTarget(root)
        local nearest, nearestDistance = nil, math.huge
        local list = (getPlayersCached and getPlayersCached()) or Players:GetPlayers()
        for _, candidate in ipairs(list) do
            if candidate ~= LP and candidate.Character then
                local targetRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
                local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                    local d = (targetRoot.Position - root.Position).Magnitude
                    if d < nearestDistance then
                        nearest = candidate
                        nearestDistance = d
                    end
                end
            end
        end
        return nearest
    end

    local function bbRotateRoot(root, direction)
        if direction.Magnitude < 0.01 then return end
        local axis = root.CFrame.LookVector:Cross(direction.Unit)
        local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
        if not State.spinEnabled then
            root.AssemblyAngularVelocity = axis.Magnitude > 0.01
                and axis.Unit * angle * 80
                or Vector3.zero
        end
    end

    local function bbSamplePing()
        local ok, value = pcall(function()
            local stats = game:GetService("Stats")
            local net = stats and stats.Network
            local item = net and net.ServerStatsItem
            local ping = item and item["Data Ping"]
            if ping and ping.GetValue then
                return (ping:GetValue() or 100) / 1000
            end
            return 0.1
        end)
        if ok and type(value) == "number" then
            BB.Z.currentPing = math.clamp(value, 0.03, 0.25)
        end
    end

    function BB.Stop()
        BB.Enabled = false
        if BB.Connection then
            pcall(function() BB.Connection:Disconnect() end)
            BB.Connection = nil
        end
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if humanoid then humanoid.AutoRotate = true end
        if root and not State.spinEnabled then root.AssemblyAngularVelocity = Vector3.zero end
        bbResetTarget()
        BB.Z.lastActivationTime = 0
    end

    function BB.Start()
        BB.Stop()
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end

        BB.Enabled = true
        humanoid.AutoRotate = false
        local bat = BB.FindBat()
        if bat and bat.Parent ~= char then
            pcall(function() humanoid:EquipTool(bat) end)
        end

        local pingAcc = 0
        BB.Connection = RunService.RenderStepped:Connect(function(dt)
            if not BB.Enabled then return end
            if not State.bypassToggled or (tonumber(State.bypassMode) or 1) ~= 1 then return end
            if _G._catalystShuttingDown then return end
            -- no Auto Bat encima
            if State.autoBatToggled or _G.CatalystBatOn then
                pcall(function() if _G.CatalystStopBat then _G.CatalystStopBat() end end)
                State.autoBatToggled = false
            end

            local Z = BB.Z
            local ZCFG = BB.ZCFG
            ZCFG.FOLLOW_SPEED = math.clamp(tonumber(State.bypassSpeed) or BAT_V2_SPEED, 48, 70)

            pingAcc = pingAcc + (dt or 0.016)
            if pingAcc >= 0.5 then
                pingAcc = 0
                bbSamplePing()
            end

            local currentChar = LP.Character
            local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
            local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
            if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
            currentHumanoid.AutoRotate = false
            root, humanoid = currentRoot, currentHumanoid

            -- anti-fling suave (anti-bat)
            do
                local v = root.AssemblyLinearVelocity
                if v.Magnitude > 130 or math.abs(v.Y) > 110 then
                    root.AssemblyLinearVelocity = Vector3.new(
                        math.clamp(v.X, -80, 80),
                        math.clamp(v.Y, -60, 80),
                        math.clamp(v.Z, -80, 80)
                    )
                end
            end

            bat = currentChar:FindFirstChildOfClass("Tool") or BB.FindBat()
            if bat and bat.Parent ~= currentChar then
                pcall(function() currentHumanoid:EquipTool(bat) end)
            end

            Z.targetPlayer = bbNearestTarget(root)
            local targetChar = Z.targetPlayer and Z.targetPlayer.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
            if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
                bbResetTarget()
                return
            end

            local targetPos = targetRoot.Position
            local safeDt = math.max(dt or 0.016, 1 / 240)

            if Z.lastTargetPos then
                local rawVelocity = (targetPos - Z.lastTargetPos) / safeDt
                if rawVelocity.Magnitude < ZCFG.MAX_VELOCITY_CHANGE * 2 then
                    bbPushHistory(Z.velocityHistory, rawVelocity, 8)
                    Z.targetVelocity = rawVelocity
                    Z.smoothedVelocity = Z.smoothedVelocity:Lerp(rawVelocity, ZCFG.VELOCITY_SMOOTHING)
                end
            end
            Z.lastTargetPos = targetPos

            local airborne = targetHumanoid.FloorMaterial == Enum.Material.Air
            Z.airborneTime = airborne and (Z.airborneTime + safeDt) or 0
            if airborne and Z.airborneTime >= ZCFG.MIN_AIRBORNE_TIME then
                bbPushHistory(Z.aerialVelocityHistory, Z.targetVelocity, 6)
            elseif not airborne then
                Z.aerialVelocityHistory = {}
            end

            local predictionVelocity = Z.smoothedVelocity
            if airborne and #Z.aerialVelocityHistory > 0 then
                local aerial = bbAverageVector(Z.aerialVelocityHistory)
                predictionVelocity = Vector3.new(aerial.X, Z.targetVelocity.Y, aerial.Z) * ZCFG.AIR_CONTROL_FACTOR
            end

            local quickTurn = false
            local horizontalVelocity = Vector3.new(Z.targetVelocity.X, 0, Z.targetVelocity.Z)
            if horizontalVelocity.Magnitude > 5 then
                local direction = horizontalVelocity.Unit
                if Z.previousDirection and Z.previousDirection:Dot(direction) < 0.5 then
                    quickTurn = (tick() - Z.lastDirectionChangeTime) < ZCFG.DIRECTION_CHANGE_DETECTION_TIME
                    Z.lastDirectionChangeTime = tick()
                end
                Z.previousDirection = direction
            end

            local serverDelay = Z.currentPing + ZCFG.SERVER_TICKRATE
            if quickTurn then serverDelay = serverDelay * ZCFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end

            local predicted = targetPos + predictionVelocity * serverDelay
            local acceleration = bbAverageVector(Z.accelerationHistory)
            predicted = predicted + acceleration * ZCFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)

            local predictionTime = ZCFG.PREDICTION_TIME * 1.1
            if airborne then
                predicted = predicted + predictionVelocity * predictionTime
                predicted = predicted + Vector3.new(0, -0.5 * ZCFG.GRAVITY * predictionTime * predictionTime, 0)
            else
                predicted = predicted + predictionVelocity * predictionTime
            end

            local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
            if flatPrediction.Magnitude > 1 then
                predicted = predicted + flatPrediction.Unit * ZCFG.PREDICT_AHEAD
            end

            local toTarget = predicted - root.Position
            bbRotateRoot(root, toTarget)

            if (targetPos - root.Position).Magnitude <= ZCFG.ACTIVATE_DISTANCE
                and (tick() - Z.lastActivationTime) >= 0.055 then
                if bat then
                    pcall(function()
                        bat:Activate()
                        bat:Activate()
                        bat:Activate()
                        local handle = bat:FindFirstChild("Handle")
                        if handle and firetouchinterest then
                            pcall(function() handle.CanTouch = true end)
                            local tChar = targetRoot.Parent
                            for _, pn in ipairs({"HumanoidRootPart", "UpperTorso", "Torso", "Head"}) do
                                local tp = tChar and tChar:FindFirstChild(pn)
                                if tp then
                                    pcall(firetouchinterest, handle, tp, 0)
                                    pcall(firetouchinterest, handle, tp, 1)
                                end
                            end
                        end
                    end)
                end
                Z.lastActivationTime = tick()
            end

            if toTarget.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
                local desired = toTarget.Unit * ZCFG.FOLLOW_SPEED
                -- más agresivo / responde YA
                local cur = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(
                    cur.X * 0.15 + desired.X * 0.85,
                    math.clamp(cur.Y * 0.25 + desired.Y * 0.55, -55, 70),
                    cur.Z * 0.15 + desired.Z * 0.85
                )
            else
                local cur = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(cur.X * 0.5, cur.Y * 0.5, cur.Z * 0.5)
            end
            pcall(function() _G._catalystBatVelWrite = tick() end)
        end)
    end

    _G.CatalystCleanBatV2Start = function()
        BB.Start()
    end
    _G.CatalystCleanBatV2Stop = function()
        BB.Stop()
    end
end


function startBatV2ByMode()
    -- V1 y V2 = Clean Hub BatBypass (V2 más agresivo)
    pcall(function() stopBypassAimbot() end)
    pcall(function() stopPredictionBatV2() end)
    pcall(function() if _G.CatalystCleanBatV2Stop then _G.CatalystCleanBatV2Stop() end end)
    pcall(function()
        if _G.CatalystStopBat then _G.CatalystStopBat() end
        State.autoBatToggled = false
    end)
    task.defer(function()
        if not State.bypassToggled then return end
        local mode = tonumber(State.bypassMode) or 1
        pcall(function()
            local BB = _G.SnowVS and _G.SnowVS.BatBypass
            if BB and BB.ZCFG then
                local base = tonumber(State.bypassSpeed) or 58
                if mode == 2 then
                    BB.ZCFG.FOLLOW_SPEED = math.clamp(base + 4, 52, 70)
                    BB.ZCFG.ACTIVATE_DISTANCE = 12
                    BB.ZCFG.PREDICTION_TIME = 0.08
                    BB.ZCFG.PREDICT_AHEAD = 3.2
                else
                    BB.ZCFG.FOLLOW_SPEED = math.clamp(base, 50, 68)
                    BB.ZCFG.ACTIVATE_DISTANCE = 9
                    BB.ZCFG.PREDICTION_TIME = 0.10
                    BB.ZCFG.PREDICT_AHEAD = 2.8
                end
            end
        end)
        -- SIEMPRE arrancar BatBypass (V1 y V2)
        if _G.CatalystCleanBatV2Start then
            _G.CatalystCleanBatV2Start()
        elseif _G.SnowVS and _G.SnowVS.BatBypass and _G.SnowVS.BatBypass.Start then
            _G.SnowVS.BatBypass.Start()
        end
    end)
end

local function stopBatV2All()
    pcall(function() stopBypassAimbot() end)
    pcall(function() stopPredictionBatV2() end)
    pcall(function() if _G.CatalystCleanBatV2Stop then _G.CatalystCleanBatV2Stop() end end)
    pcall(function() if _G.CatalystStopBat then _G.CatalystStopBat() end end)
end

function toggleBypass(state)
    if state == nil then
        state = not State.bypassToggled
    end
    State.bypassToggled = state and true or false

    if State.bypassToggled then
        if State.autoBatToggled then
            pcall(function() _G.CatalystStopBat() end)
            if setAutoBat then setAutoBat(false) end
            if setMB_AB then setMB_AB(false) end
            State.autoBatToggled = false
            SetSetting("autoBatToggled", false)
        end
        if State.autoLeftEnabled then
            State.autoLeftEnabled = false
            if setAutoLeft then setAutoLeft(false) end
            if setMB_AL then setMB_AL(false) end
            pcall(stopAutoLeft)
        end
        if State.autoRightEnabled then
            State.autoRightEnabled = false
            if setAutoRight then setAutoRight(false) end
            if setMB_AR then setMB_AR(false) end
            pcall(stopAutoRight)
        end
        if _G.CatalystTpBatOn then
            pcall(function() _G.CatalystStopTpBat() end)
            if _G._tpBatBtn then pcall(function() _G._tpBatBtn.setActive(false) end) end
        end
        startBatV2ByMode()
    else
        stopBatV2All()
    end

    if _G._batV2Btn then
        pcall(function() _G._batV2Btn.setActive(State.bypassToggled) end)
    end
    SetSetting("bypassToggled", State.bypassToggled)
end

function toggleBypassMode()
    State.bypassMode = (tonumber(State.bypassMode) == 2) and 1 or 2
    SetSetting("bypassMode", State.bypassMode)
    -- solo Bat V2 flotante; Bat Aimbot usa su propia logica
    if State.bypassToggled then
        startBatV2ByMode()
    end
    if ZenToast then
        ZenToast("Bat V2 Mode → " .. ((tonumber(State.bypassMode) == 2) and "V2" or "V1"))
    end
end

_G.CatalystToggleBatV2 = toggleBypass
_G.CatalystStartBatV2 = function() toggleBypass(true) end
_G.CatalystStopBatV2 = function() toggleBypass(false) end

_G._catalystFloatBtns = _G._catalystFloatBtns or {}
State.floatBtnShape = State.floatBtnShape or Config.floatBtnShape or "Square" -- Square | Capsule

local function applyFloatBtnShape(btn)
    if not btn then return end
    local shape = State.floatBtnShape or "Square"
    local savedPosition = btn.Position
    local corner = btn:FindFirstChildOfClass("UICorner")
    if not corner then
        corner = Instance.new("UICorner", btn)
    end
    if shape == "Capsule" then
        corner.CornerRadius = UDim.new(1, 0)
    else
        corner.CornerRadius = UDim.new(0, 0)
    end
    btn.Position = savedPosition
end

function _G.CatalystSetFloatBtnShape(shape)
    if shape ~= "Capsule" and shape ~= "Square" then shape = "Square" end
    State.floatBtnShape = shape
    SetSetting("floatBtnShape", shape)
    for _, btn in ipairs(_G._catalystFloatBtns or {}) do
        pcall(function() applyFloatBtnShape(btn) end)
    end
    for _, entry in ipairs(mbButtonFrames or {}) do
        pcall(function() applyFloatBtnShape(entry.frame) end)
    end
    if _G._refreshFloatBtnShapeUI then _G._refreshFloatBtnShapeUI() end
end

local function createFloatingButton(label, toggleFn, defaultPos, posFile, isToggle, sizeFile, showResizeHandle)
    local FLOAT_SIZE = 72
    local btn = Instance.new("TextButton")
    btn.Name = label:gsub("%s", "") .. "Button"
    btn.Parent = gui
    btn.Size = UDim2.new(0, FLOAT_SIZE, 0, FLOAT_SIZE)
    btn.Position = defaultPos
    btn.Text = ""
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = 0
    btn.AutoButtonColor = false
    btn.ZIndex = 300
    btn.ClipsDescendants = true
    btn:SetAttribute("_floatSize", FLOAT_SIZE)

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
    table.insert(_G._catalystFloatBtns, btn)
    applyFloatBtnShape(btn)

    local btnBg = Instance.new("ImageLabel", btn)
    btnBg.Name = "ReferenceBackground"
    btnBg.Size = UDim2.new(1, 0, 1, 0)
    btnBg.Position = UDim2.new(0, 0, 0, 0)
    btnBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnBg.BackgroundTransparency = 0
    btnBg.BorderSizePixel = 0
    btnBg.Image = backgroundUri(State.bgImageId or BACKGROUND_ID)
    btnBg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    btnBg.ImageTransparency = 0
    btnBg.ScaleType = Enum.ScaleType.Crop
    btnBg.ZIndex = 300
    btnBg.ClipsDescendants = true
    btnBg.Visible = false
    local bgCorner = Instance.new("UICorner", btnBg)
    bgCorner.CornerRadius = UDim.new(0, 18)
    local btnShade = Instance.new("Frame", btn)
    btnShade.Name = "ReferenceShade"
    btnShade.Size = UDim2.new(1, 0, 1, 0)
    btnShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnShade.BackgroundTransparency = 0.42
    btnShade.BorderSizePixel = 0
    btnShade.ZIndex = 300
    Instance.new("UICorner", btnShade).CornerRadius = UDim.new(0, 18)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Enabled = true
    stroke.Color = Color3.fromRGB(40, 40, 48)
    stroke.Thickness = 1.2
    stroke.Transparency = 0.25
    local strokeGrad = Instance.new("UIGradient", stroke)
    strokeGrad.Enabled = false
    local innerStroke = nil
    local topLine = Instance.new("Frame", btn)
    topLine.Name = "TopAccent"
    topLine.Size = UDim2.new(0.4, 0, 0, 1)
    topLine.Position = UDim2.new(0.3, 0, 0, 0)
    topLine.BackgroundColor3 = ACCENT
    topLine.BackgroundTransparency = 0.35
    topLine.BorderSizePixel = 0
    topLine.Visible = true
    topLine.ZIndex = 305
    Instance.new("UICorner", topLine).CornerRadius = UDim.new(1, 0)
    local bottomLine = Instance.new("Frame", btn)
    bottomLine.Name = "BottomAccent"
    bottomLine.AnchorPoint = Vector2.new(0.5, 1)
    bottomLine.Size = UDim2.new(0.58, 0, 0, 2)
    bottomLine.Position = UDim2.new(0.5, 0, 1, -5)
    bottomLine.BackgroundColor3 = Color3.fromRGB(155, 85, 220)
    bottomLine.BackgroundTransparency = 0.18
    bottomLine.BorderSizePixel = 0
    bottomLine.ZIndex = 305
    Instance.new("UICorner", bottomLine).CornerRadius = UDim.new(1, 0)
    local bottomGrad = Instance.new("UIGradient", bottomLine)
    bottomGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 28, 115)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 195, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 48, 165)),
    })
    local topGrad = Instance.new("UIGradient", topLine)
    topGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.85),
    })

    local lbl = Instance.new("TextLabel", btn)
    lbl.Name = "Label"
    lbl.Size = UDim2.new(1, -8, 1, -8)
    lbl.Position = UDim2.new(0, 4, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(235, 235, 240)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 10
    lbl.LineHeight = 1.2
    lbl.TextWrapped = true
    lbl.TextYAlignment = Enum.TextYAlignment.Center
    lbl.ZIndex = 303
    local lblGrad = Instance.new("UIGradient", lbl)
    lblGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.55, ACCENT),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50)),
    })
    lblGrad.Rotation = 90

    local dot = Instance.new("Frame", btn)
    dot.Name = "ActiveDot"
    dot.Size = UDim2.new(0, 7, 0, 7)
    dot.Position = UDim2.new(1, -13, 0, 6)
    dot.BackgroundColor3 = ACCENT
    dot.BackgroundTransparency = 1
    dot.BorderSizePixel = 0
    dot.ZIndex = 304
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local active = false
    local btnScale = Instance.new("UIScale", btn)
    btnScale.Scale = 1

    if sizeFile and showResizeHandle ~= false then
        local resizeHandle = Instance.new("TextButton", btn)
        resizeHandle.Name = "ResizeHandle"
        resizeHandle.Size = UDim2.fromOffset(18, 18)
        resizeHandle.Position = UDim2.new(1, -20, 1, -20)
        resizeHandle.BackgroundColor3 = Color3.fromRGB(235, 235, 240)
        resizeHandle.BackgroundTransparency = 0.38
        resizeHandle.BorderSizePixel = 0
        resizeHandle.Text = ""
        resizeHandle.AutoButtonColor = false
        resizeHandle.ZIndex = 310
        Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(1, 0)
        local resizeStroke = Instance.new("UIStroke", resizeHandle)
        resizeStroke.Color = Color3.fromRGB(20, 20, 24)
        resizeStroke.Transparency = 0.25
        local resizing, resizeInput, resizeStart, resizeStartSize = false, nil, nil, nil
        resizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                resizing = true
                resizeInput = input
                resizeStart = input.Position
                resizeStartSize = btn.AbsoluteSize.X
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not resizing then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input == resizeInput then
                local delta = input.Position - resizeStart
                local newSize = math.clamp(resizeStartSize + math.max(delta.X, delta.Y), 48, 120)
                btn.Size = UDim2.fromOffset(newSize, newSize)
                btn:SetAttribute("_floatSize", newSize)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if resizing and input == resizeInput then
                resizing = false
                resizeInput = nil
                pcall(function() writefile(sizeFile, tostring(math.floor(btn.AbsoluteSize.X))) end)
            end
        end)
        pcall(function()
            local savedSize = tonumber(readfile(sizeFile))
            if savedSize then
                savedSize = math.clamp(savedSize, 48, 120)
                btn.Size = UDim2.fromOffset(savedSize, savedSize)
                btn:SetAttribute("_floatSize", savedSize)
            end
        end)
    end
    if sizeFile and showResizeHandle == false then
        pcall(function()
            local savedSize = tonumber(readfile(sizeFile))
            if savedSize then
                savedSize = math.clamp(savedSize, 48, 120)
                btn.Size = UDim2.fromOffset(savedSize, savedSize)
                btn:SetAttribute("_floatSize", savedSize)
            end
        end)
    end

    local function pressPop()
        -- Los botones mantienen su tamaño normal; el tamaño solo se cambia desde Config.
        btnScale.Scale = 1
    end

    local function updateUI()
        local onCol = Q_ON_BG or ACCENT
        local offCol = Color3.fromRGB(0, 0, 0)
        local ac = ACCENT
        local themeName = _G._catalystThemeName or "blue"
        local isWhiteTheme = themeName == "white"
        local extDark = isWhiteTheme and Color3.fromRGB(210, 210, 218) or (themeName == "black" and Color3.fromRGB(5, 5, 7) or Color3.fromRGB(8, 12, 22))
        local extText = isWhiteTheme and Color3.fromRGB(25, 25, 30) or (themeName == "purple" and Color3.fromRGB(238, 215, 255) or Color3.fromRGB(245, 245, 250))
        pcall(function()
            if strokeGrad then
                strokeGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                    ColorSequenceKeypoint.new(0.5, ac),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
                })
            end
            if lblGrad then
                lblGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(0.55, ac),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 50)),
                })
            end
            if topLine then topLine.BackgroundColor3 = ac end
        end)
        btnBg.Visible = false
        local bgGradient
        pcall(function()
            bgGradient = btn:FindFirstChild("BgGrad")
            if not bgGradient then
                bgGradient = Instance.new("UIGradient")
                bgGradient.Name = "BgGrad"
                bgGradient.Parent = btn
            end
            bgGradient.Enabled = true
            bgGradient.Rotation = 135
            bgGradient.Color = active and ColorSequence.new({
                ColorSequenceKeypoint.new(0, extDark),
                ColorSequenceKeypoint.new(0.48, ac),
                ColorSequenceKeypoint.new(1, extDark),
            }) or ColorSequence.new({
                ColorSequenceKeypoint.new(0, extDark),
                ColorSequenceKeypoint.new(0.5, ac),
                ColorSequenceKeypoint.new(1, extDark),
            })
        end)
        btn.BackgroundColor3 = extDark
        btn.BackgroundTransparency = 0
        btnShade.BackgroundTransparency = active and 0.22 or 0.32
        lbl.TextColor3 = extText
        lbl.TextStrokeColor3 = extDark
        lbl.TextStrokeTransparency = 0.08
        if lblGrad then
            lblGrad.Enabled = true
            lblGrad.Color = active and ColorSequence.new({
                ColorSequenceKeypoint.new(0, extText),
                ColorSequenceKeypoint.new(0.52, ac),
                ColorSequenceKeypoint.new(1, extText),
            }) or ColorSequence.new({
                ColorSequenceKeypoint.new(0, extText),
                ColorSequenceKeypoint.new(0.5, ac),
                ColorSequenceKeypoint.new(1, extText),
            })
        end
        stroke.Enabled = true
        stroke.Color = active and ac or extDark
        stroke.Transparency = active and 0.02 or 0.12
        stroke.Thickness = active and 2.2 or 1.6
        topLine.BackgroundTransparency = active and 0.05 or 0.28
        bottomLine.BackgroundColor3 = active and ac or extDark
        bottomLine.BackgroundTransparency = active and 0.02 or 0.18
        bottomLine.Size = UDim2.new(active and 0.72 or 0.58, 0, 0, active and 3 or 2)
        bottomGrad.Enabled = true
        bottomGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, extDark),
            ColorSequenceKeypoint.new(0.5, ac),
            ColorSequenceKeypoint.new(1, extDark),
        })
        if dot then
            dot.BackgroundColor3 = ac
            TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundTransparency = active and 0 or 0.32}):Play()
        end
    end

    task.spawn(function()
        while btn and btn.Parent do
            bottomGrad.Offset = Vector2.new(-1, 0)
            local shineTween = TweenService:Create(bottomGrad, TweenInfo.new(1.35, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Offset = Vector2.new(1, 0),
            })
            shineTween:Play()
            task.wait(1.5)
        end
    end)

    table.insert(floatingBtnObjects, {
        button = btn,
        isActive = function() return active end,
        updateUI = updateUI
    })

    local dragging, dragStartPos, dragStartMousePos, clickStartTime, activeTouch = false, nil, nil, nil, nil
    local dragThreshold = 10

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if activeTouch and activeTouch ~= input then return end
            activeTouch = input
            clickStartTime = tick()
            dragStartPos = btn.Position
            dragStartMousePos = input.Position
            dragging = false
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input == activeTouch then
            if not dragging and clickStartTime and (tick() - clickStartTime) < 0.3 then
                if isToggle then
                    active = not active
                    pressPop()
                    updateUI()
                    pcall(function()
                        if lblGrad then
                            lblGrad.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.5, ACCENT),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
                            })
                        end
                    end)
                    if toggleFn then pcall(toggleFn, active) end
                else
                    pressPop()
                    local pressDark = (_G._catalystThemeName == "black") and Color3.fromRGB(5, 5, 7) or Color3.fromRGB(8, 12, 22)
                    btn.BackgroundColor3 = pressDark
                    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    stroke.Color = ACCENT
                    stroke.Transparency = 0
                    bottomLine.BackgroundColor3 = ACCENT
                    bottomLine.BackgroundTransparency = 0
                    bottomLine.Size = UDim2.new(0.76, 0, 0, 3)
                    local pressGradient = btn:FindFirstChild("BgGrad")
                    if pressGradient then
                        pressGradient.Enabled = true
                        pressGradient.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, pressDark),
                            ColorSequenceKeypoint.new(0.5, ACCENT),
                            ColorSequenceKeypoint.new(1, pressDark),
                        })
                    end
                    pcall(function()
                        if lblGrad then
                            lblGrad.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                                ColorSequenceKeypoint.new(0.5, ACCENT),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
                            })
                        end
                        if strokeGrad then
                            strokeGrad.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                                ColorSequenceKeypoint.new(0.5, ACCENT),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
                            })
                        end
                    end)
                    if toggleFn then pcall(toggleFn) end
                    task.delay(0.25, function()
                        if not active then updateUI() end
                    end)
                end
            end
            if dragging then savePos(btn, posFile) end
            dragging = false
            activeTouch = nil
            clickStartTime = nil
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if State.mobileLocked then return end
        if activeTouch and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if input.UserInputType == Enum.UserInputType.MouseMovement or input == activeTouch then
                local delta = input.Position - dragStartMousePos
                local distanceMoved = math.sqrt(delta.X^2 + delta.Y^2)
                if not dragging and distanceMoved > dragThreshold then dragging = true end
                if dragging then
                    btn.Position = UDim2.new(
                        dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                        dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
                    )
                end
            end
        end
    end)

    local lastSave = 0
    btn:GetPropertyChangedSignal("Position"):Connect(function()
        if tick() - lastSave > 0.5 then
            lastSave = tick()
            pcall(function()
                writefile(posFile, string.format("%.3f,%.1f,%.3f,%.1f",
                    btn.Position.X.Scale, btn.Position.X.Offset,
                    btn.Position.Y.Scale, btn.Position.Y.Offset))
            end)
        end
    end)

    local restoredPosition = false
    pcall(function()
        if isfile and isfile(posFile) then
            local data = readfile(posFile)
            if data and data ~= "" then
                local parts = {}
                for v in string.gmatch(data, "[^,]+") do table.insert(parts, tonumber(v)) end
                if #parts >= 4 and parts[1] and parts[2] and parts[3] and parts[4] then
                    btn.Position = UDim2.new(parts[1], parts[2], parts[3], parts[4])
                    restoredPosition = true
                end
            end
        end
    end)
    if not restoredPosition then btn.Position = defaultPos end

    btn.MouseEnter:Connect(function()
        if not State.mobileLocked and not active then
            local hov = Color3.new(
                math.clamp((ACCENT.R) * 0.25, 0, 1),
                math.clamp((ACCENT.G) * 0.25, 0, 1),
                math.clamp((ACCENT.B) * 0.25, 0, 1)
            )
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = hov}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.12), {Color = ACCENT, Transparency = 0.15}):Play()
        end
        btnScale.Scale = 1
    end)

    btn.MouseLeave:Connect(function()
        if not active then updateUI() end
        btnScale.Scale = 1
    end)

    table.insert(floatingBtnRefs, {frame = btn, defaultPos = defaultPos, posFile = posFile, label = label, id = tostring(posFile or label)})
    updateUI()

    return {
        button = btn,
        setActive = function(state) active = state; updateUI() end,
        isActive = function() return active end,
        toggle = function() active = not active; updateUI() end
    }
end

local instaResetBtn = createFloatingButton(
    "Insta Reset",
    function() _G.AdaptInstantReset() end,
    UDim2.new(0, 12, 0.56, 0),
    "KzsHubInstaResetPos.txt",
    false,
    "KzsHubInstaResetSize.txt",
    false
)
_G._instaResetBtn = instaResetBtn

_G._batV2Btn = createFloatingButton(
    "Bat V2",
    function(on)
        -- forzar estado real (no depender solo del flag visual)
        if on == true or on == false then
            toggleBypass(on)
        else
            toggleBypass(not State.bypassToggled)
        end
    end,
    UDim2.new(0, 12, 0.72, 0),
    "KzsHubBatV2Pos.txt",
    true,
    "KzsHubBatV2Size.txt",
    false
)

-- backup: click directo por si el drag del botón se come el toque
pcall(function()
    local b = _G._batV2Btn and _G._batV2Btn.button
    if b then
        b.Activated:Connect(function()
            -- solo si no se arrastró (el toggle principal ya maneja el click corto)
        end)
    end
end)

if State.bypassToggled and _G._batV2Btn then
    _G._batV2Btn.setActive(true)
    task.defer(function()
        if State.bypassToggled then startBatV2ByMode() end
    end)
end

end)()


-- Bat V2 V1 (Clean-style) + Spin simple — scopes propios
;(function()
    local cleanConn = nil
    local lastPos, lastT, vel = nil, 0, Vector3.zero
    local BAT_NAMES = {
        "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
        "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
        "Nuclear Slap","Galaxy Slap","Glitched Slap"
    }

    local function findBat(char)
        if not char then return nil end
        for _, n in ipairs(BAT_NAMES) do
            local t = char:FindFirstChild(n)
            if t and t:IsA("Tool") then return t end
        end
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then
                local ln = t.Name:lower()
                if ln:find("bat") or ln:find("slap") then return t end
            end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, n in ipairs(BAT_NAMES) do
                local t = bp:FindFirstChild(n)
                if t and t:IsA("Tool") then return t end
            end
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local ln = t.Name:lower()
                    if ln:find("bat") or ln:find("slap") then return t end
                end
            end
        end
        return nil
    end

    local function closestEnemy(root)
        local best, bestD = nil, 1e9
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local h = p.Character:FindFirstChildOfClass("Humanoid")
                local r = p.Character:FindFirstChild("HumanoidRootPart")
                if h and r and h.Health > 0 then
                    local d = (r.Position - root.Position).Magnitude
                    if d < bestD and d < 150 then
                        bestD, best = d, p
                    end
                end
            end
        end
        return best, bestD
    end

    local function stopClean()
        if cleanConn then pcall(function() cleanConn:Disconnect() end); cleanConn = nil end
        lastPos, lastT, vel = nil, 0, Vector3.zero
        pcall(function()
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end)
    end

    local lastSwing = 0
    local cleanAcc = 0

    local function startClean()
        stopClean()
        lastSwing = 0
        cleanAcc = 0
        cleanConn = RunService.Heartbeat:Connect(function(dt)
            if not State.bypassToggled then return end
            if (tonumber(State.bypassMode) or 1) ~= 1 then return end
            if _G._catalystShuttingDown then return end
            -- no correr Auto Bat encima
            if State.autoBatToggled or _G.CatalystBatOn then
                pcall(function() if _G.CatalystStopBat then _G.CatalystStopBat() end end)
                State.autoBatToggled = false
            end

            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end

            -- anti-fling (menos agresivo para que SI corra)
            do
                local v = root.AssemblyLinearVelocity
                if v.Magnitude > 160 or math.abs(v.Y) > 120 then
                    root.AssemblyLinearVelocity = Vector3.new(
                        math.clamp(v.X, -95, 95),
                        math.clamp(v.Y, -70, 90),
                        math.clamp(v.Z, -95, 95)
                    )
                end
            end

            hum.AutoRotate = false
            local spd = 62

            local bat = findBat(char)
            if bat and bat.Parent ~= char then
                pcall(function() hum:EquipTool(bat) end)
                bat = findBat(char)
            end

            local enemy = closestEnemy(root)
            if not enemy or not enemy.Character then return end
            local er = enemy.Character:FindFirstChild("HumanoidRootPart")
            local eh = enemy.Character:FindFirstChildOfClass("Humanoid")
            if not er or not eh or eh.Health <= 0 then return end

            local now = tick()
            local pos = er.Position
            if lastPos and lastT > 0 then
                local sdt = math.max(now - lastT, 0.004)
                local nv = (pos - lastPos) / sdt
                if nv.Magnitude < 160 then vel = vel:Lerp(nv, 0.25) end
            end
            lastPos, lastT = pos, now

            local ahead = vel * 0.12
            if ahead ~= ahead then ahead = Vector3.zero end
            -- altura baja para no volar
            local dest = pos + Vector3.new(ahead.X, 0, ahead.Z) + Vector3.new(0, 1.3, 0)
            local to = dest - root.Position
            local dist2 = to.Magnitude

            if dist2 > 0.35 then
                local dir = to.Unit
                local hv = Vector3.new(dir.X, 0, dir.Z) * spd
                local cv = root.AssemblyLinearVelocity
                local blended = Vector3.new(
                    cv.X * 0.25 + hv.X * 0.75,
                    math.clamp(cv.Y * 0.55 + dir.Y * 18, -40, 55),
                    cv.Z * 0.25 + hv.Z * 0.75
                )
                root.AssemblyLinearVelocity = Vector3.new(
                    math.clamp(blended.X, -70, 70),
                    math.clamp(blended.Y, -40, 55),
                    math.clamp(blended.Z, -70, 70)
                )
                root.CFrame = CFrame.new(root.Position, Vector3.new(pos.X, root.Position.Y, pos.Z))
            else
                root.CFrame = CFrame.new(root.Position, Vector3.new(pos.X, root.Position.Y, pos.Z))
                -- cerca: mantener stick ligero hacia el target
                local dir = (Vector3.new(pos.X, root.Position.Y, pos.Z) - root.Position)
                if dir.Magnitude > 0.05 then
                    dir = dir.Unit
                    local cv = root.AssemblyLinearVelocity
                    root.AssemblyLinearVelocity = Vector3.new(
                        math.clamp(cv.X * 0.3 + dir.X * 22, -40, 40),
                        math.clamp(cv.Y, -30, 40),
                        math.clamp(cv.Z * 0.3 + dir.Z * 22, -40, 40)
                    )
                end
            end

            if not State.spinEnabled then
                root.AssemblyAngularVelocity = Vector3.zero
            end

            if dist2 < 18 and (now - lastSwing) >= 0.06 then
                lastSwing = now
                local tool = bat or char:FindFirstChildOfClass("Tool")
                if tool then
                    pcall(function()
                        if tool.Parent ~= char then hum:EquipTool(tool) end
                        tool:Activate()
                        tool:Activate()
                        tool:Activate()
                        local handle = tool:FindFirstChild("Handle")
                        if handle and enemy.Character and firetouchinterest then
                            pcall(function() handle.CanTouch = true end)
                            local tr = enemy.Character:FindFirstChild("HumanoidRootPart")
                            local tt = enemy.Character:FindFirstChild("UpperTorso") or enemy.Character:FindFirstChild("Torso")
                            if tr then
                                pcall(firetouchinterest, handle, tr, 0)
                                pcall(firetouchinterest, handle, tr, 1)
                            end
                            if tt then
                                pcall(firetouchinterest, handle, tt, 0)
                                pcall(firetouchinterest, handle, tt, 1)
                            end
                        end
                        local ev = tool:FindFirstChildWhichIsA("RemoteEvent", true)
                        if ev then ev:FireServer() end
                    end)
                end
            end
        end)
    end

    -- CleanBatV2Start / Stop = BatBypass Clean Hub (V1)
    _G.CatalystCleanBatV2Start = function()
        if BB and BB.Start then
            BB.Start()
        else
            pcall(startClean)
        end
    end
    _G.CatalystCleanBatV2Stop = function()
        if BB and BB.Stop then BB.Stop() end
        pcall(stopClean)
    end

    -- si el botón ya estaba ON antes de cargar el módulo, arrancar
    if State.bypassToggled then
        task.defer(function()
            if State.bypassToggled and _G.CatalystCleanBatV2Start then
                _G.CatalystCleanBatV2Start()
            end
        end)
    end
end)()

-- Spin Bot — al pegarte: apaga spin y lo reenciende rápido (no toca ragdoll)
;(function()
    local spinBAV, spinConn, spinCharConn = nil, nil, nil
    local spinAcc = 0
    local spinCarryAcc = 0
    local spinCachedCarry = false
    local spinPhase = 0
    local spinDir = 1
    local dirTimer = 0
    local spdJitter = 0
    local weEnabledUnwalk = false
    local spinPausedUntil = 0
    local lastPauseAt = 0

    local function destroySpinBAV()
        if spinBAV then pcall(function() spinBAV:Destroy() end); spinBAV = nil end
        pcall(function()
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root then
                for _, v in pairs(root:GetChildren()) do
                    local n = tostring(v.Name)
                    if n == "CashHubSpinBAV" or n == "CatalystSpinBAV" or n:find("SpinBAV") then
                        pcall(function() v:Destroy() end)
                    end
                end
            end
        end)
    end

    local function stopSpinLoop()
        if spinConn then pcall(function() spinConn:Disconnect() end); spinConn = nil end
        if spinCharConn then pcall(function() spinCharConn:Disconnect() end); spinCharConn = nil end
        destroySpinBAV()
        pcall(function()
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if hum then hum.AutoRotate = true end
            if root then
                local a = root.AssemblyAngularVelocity
                root.AssemblyAngularVelocity = Vector3.new(a.X * 0.15, 0, a.Z * 0.15)
            end
        end)
        if weEnabledUnwalk then
            pcall(function()
                if stopUnwalk then stopUnwalk() end
            end)
            weEnabledUnwalk = false
        end
    end

    local function spinSpeedNow()
        -- El valor de la GUI ES la velocidad base real
        local base = math.clamp(tonumber(State.spinSpeed) or 80, 1, 300)
        local mul = spinCachedCarry and 1.35 or 1.0
        local spd = base * mul + (spdJitter or 0)
        return spd * spinDir
    end

    local function startSpinBAV()
        local c = LP.Character
        if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        destroySpinBAV()
        spinBAV = Instance.new("BodyAngularVelocity")
        spinBAV.Name = "CatalystSpinBAV"
        spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
        spinBAV.P = 0
        spinBAV.Parent = root
        spinBAV.AngularVelocity = Vector3.new(0, spinSpeedNow(), 0)
    end

    local function ensureUnwalkForSpin()
        if State.unwalkEnabled then
            weEnabledUnwalk = false
            return
        end
        pcall(function()
            if startUnwalk then
                startUnwalk()
                weEnabledUnwalk = true
            end
        end)
    end

    -- Solo apaga el SPIN un momento y lo vuelve a prender. NO toca ragdoll/anti-ragdoll.
    local function pauseSpinBriefly()
        local now = tick()
        if now - lastPauseAt < 0.15 then return end
        lastPauseAt = now
        spinPausedUntil = now + 0.1

        -- apagar spin
        if spinBAV then
            pcall(function() spinBAV.AngularVelocity = Vector3.zero end)
            destroySpinBAV()
        end
        pcall(function()
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root then
                local a = root.AssemblyAngularVelocity
                root.AssemblyAngularVelocity = Vector3.new(a.X, 0, a.Z)
            end
        end)

        -- reactivar spin rápido
        task.delay(0.1, function()
            if not State.spinEnabled then return end
            spinPausedUntil = 0
            startSpinBAV()
            pcall(function()
                local c = LP.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if h then h.AutoRotate = false end
            end)
        end)
    end

    local function wasHit(hum, root)
        if not hum or not root then return false end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
            or st == Enum.HumanoidStateType.Physics then
            return true
        end
        -- golpe fuerte sin depender de anti-ragdoll
        if root.AssemblyLinearVelocity.Magnitude > 95 then return true end
        if root.AssemblyAngularVelocity.Magnitude > 55 and not spinBAV then return true end
        return false
    end

    local function startSpinLoop()
        stopSpinLoop()
        if not State.spinEnabled then return end
        ensureUnwalkForSpin()
        startSpinBAV()
        spinPhase = 0
        spinDir = 1
        dirTimer = 0
        spdJitter = 0
        spinPausedUntil = 0
        lastPauseAt = 0

        spinConn = RunService.RenderStepped:Connect(function(dt)
            if not State.spinEnabled then return end
            dt = dt or 0.016
            spinAcc = spinAcc + dt
            if spinAcc < 0.016 then return end
            local step = spinAcc
            spinAcc = 0

            local c = LP.Character
            if not c then return end
            local root = c:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then
                if spinBAV then spinBAV.AngularVelocity = Vector3.zero end
                return
            end

            -- Si te pegan: SOLO apaga el spin y lo reenciende (no toca ragdoll)
            if wasHit(hum, root) and tick() >= spinPausedUntil then
                pauseSpinBriefly()
                return
            end

            if tick() < spinPausedUntil then
                return
            end

            if hum then hum.AutoRotate = false end

            spinCarryAcc = spinCarryAcc + step
            if spinCarryAcc >= 0.2 then
                spinCarryAcc = 0
                local ok, car = pcall(function()
                    return _G.isCarryingBrainrot and _G.isCarryingBrainrot() == true
                end)
                spinCachedCarry = ok and car == true
            end

            dirTimer = dirTimer + step
            local flipEvery = spinCachedCarry and 0.28 or 0.4
            if dirTimer >= flipEvery then
                dirTimer = 0
                spinDir = -spinDir
            end

            spinPhase = spinPhase + step
            spdJitter = math.sin(spinPhase * 11) * 22
                + math.sin(spinPhase * 4.2) * 12
                + math.sin(spinPhase * 17) * 7

            local spd = spinSpeedNow()
            if not spinBAV or spinBAV.Parent ~= root then
                startSpinBAV()
            else
                spinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
                spinBAV.AngularVelocity = Vector3.new(0, spd, 0)
            end
        end)

        spinCharConn = LP.CharacterAdded:Connect(function()
            if not State.spinEnabled then return end
            task.wait(0.35)
            if State.spinEnabled then
                ensureUnwalkForSpin()
                startSpinBAV()
            end
        end)
    end

    local function setSpinEnabled(on)
        State.spinEnabled = on and true or false
        SetSetting("spinEnabled", State.spinEnabled)
        if State.spinEnabled then
            startSpinLoop()
        else
            stopSpinLoop()
        end
        pcall(function()
            if _G._spinToggleSetter then
                _G._spinToggleSetter(State.spinEnabled)
            end
        end)
    end
    _G.setSpinEnabled = setSpinEnabled

    _G._catalystApplySpinSpeed = function(n)
        State.spinSpeed = math.clamp(tonumber(n) or State.spinSpeed or 80, 1, 300)
        if not State.spinEnabled then return end
        pcall(function()
            if spinBAV and spinBAV.Parent then
                spinBAV.AngularVelocity = Vector3.new(0, spinSpeedNow(), 0)
            end
        end)
    end

    if State.spinEnabled then
        task.defer(function()
            if State.spinEnabled then startSpinLoop() end
        end)
    end
end)()

-- Auto Brain Rots
;(function()
    local lastCarry, autoSpinWasOn, acc = false, false, 0
    RunService.Heartbeat:Connect(function(dt)
        if not State.autoSpinBrainrot then
            lastCarry, acc = false, 0
            return
        end
        acc = acc + (dt or 0.016)
        if acc < 0.3 then return end
        acc = 0
        local carrying = false
        pcall(function()
            carrying = _G.isCarryingBrainrot and _G.isCarryingBrainrot() == true
        end)
        if carrying and not lastCarry then
            if _G.setSpinEnabled then _G.setSpinEnabled(true) end
            autoSpinWasOn = true
        elseif (not carrying) and lastCarry and autoSpinWasOn then
            if _G.setSpinEnabled then _G.setSpinEnabled(false) end
            autoSpinWasOn = false
        end
        lastCarry = carrying
    end)
end)()

task.spawn(function()
    local lastUnstick = 0
    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < 0.2 then return end
        acc = 0
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        if hum.PlatformStand then
            local st = hum:GetState()
            if st ~= Enum.HumanoidStateType.Physics and st ~= Enum.HumanoidStateType.Ragdoll then
                hum.PlatformStand = false
            end
        end

        if not State.antiPlayerCollision and root.CanCollide == false then
            root.CanCollide = true
        end

        local now = tick()
        if now - lastUnstick < 0.35 then return end
        for _, plr in ipairs(getPlayersCached()) do
            if plr ~= LP and plr.Character then
                local ohrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if ohrp then
                    local delta = root.Position - ohrp.Position
                    local dist = delta.Magnitude
                    if dist < 2.0 and dist > 0.01 then
                        local push = Vector3.new(delta.X, 0, delta.Z)
                        if push.Magnitude < 0.05 then push = Vector3.new(1, 0, 0) end
                        push = push.Unit * 2.2
                        local y = root.AssemblyLinearVelocity.Y
                        root.AssemblyLinearVelocity = Vector3.new(push.X, y, push.Z)
                        lastUnstick = now
                        break
                    end
                end
            end
        end
    end)
end)

task.spawn(function()
    local acc = 0
    RunService.Heartbeat:Connect(function(dt)
        acc = acc + dt
        if acc < 0.18 then return end
        acc = 0

        if _G.CatalystTpBatOn then return end

        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        pcall(function()
            if sethiddenproperty then
                pcall(sethiddenproperty, root, "PhysicsRepRootPart", nil)
            end
            if gethiddenproperty then
                local ok, val = pcall(gethiddenproperty, root, "PhysicsRepRootPart")
                if ok and val ~= nil then
                    pcall(sethiddenproperty, root, "PhysicsRepRootPart", nil)
                end
            end
        end)

        local st = hum:GetState()
        if hum.PlatformStand and st ~= Enum.HumanoidStateType.Ragdoll then
            hum.PlatformStand = false
        end
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.FallingDown then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
        end

        pcall(function()
            for _, obj in ipairs(char:GetDescendants()) do
                local n = tostring(obj.Name or "")
                if n == "KzLinearVelocity" or n == "SpeedVectorForce" or n == "InfJumpVelocity"
                    or n == "SpeedAttachment" or n == "RootAttachment" or n == "InfJumpAttachment" then
                elseif obj:IsA("WeldConstraint") or obj:IsA("Weld") or obj:IsA("RigidConstraint") then
                    local p0, p1 = obj.Part0, obj.Part1
                    local foreign = false
                    if p0 and not p0:IsDescendantOf(char) then foreign = true end
                    if p1 and not p1:IsDescendantOf(char) then foreign = true end
                    if foreign then pcall(function() obj:Destroy() end) end
                elseif obj:IsA("AlignPosition") or obj:IsA("AlignOrientation") or obj:IsA("BodyPosition") then
                    pcall(function() obj:Destroy() end)
                elseif (obj:IsA("LinearVelocity") or obj:IsA("VectorForce") or obj:IsA("BodyVelocity"))
                    and (n:find("Ace") or n:find("Aimbot") or n:find("Bat") or n:find("Desync") or n:find("TP")) then
                    pcall(function() obj:Destroy() end)
                end
            end
        end)

        for _, plr in ipairs(getPlayersCached()) do
            if plr ~= LP and plr.Character then
                local ohrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if ohrp then
                    local d = (root.Position - ohrp.Position).Magnitude
                    if d < 1.2 then
                        local dir = root.Position - ohrp.Position
                        if dir.Magnitude < 0.05 then dir = Vector3.new(1, 0, 0) end
                        dir = Vector3.new(dir.X, 0, dir.Z)
                        if dir.Magnitude > 0.01 then dir = dir.Unit end
                        root.CFrame = root.CFrame + dir * 1.6
                        local y = root.AssemblyLinearVelocity.Y
                        root.AssemblyLinearVelocity = Vector3.new(dir.X * 3, y, dir.Z * 3)
                        break
                    end
                end
            end
        end
    end)
end)

task.spawn(function()
    local okAll, errAll = pcall(function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LP = Players.LocalPlayer

        local spoofOn = false
        local hooked = false
        local disabledPrompts = {}

        -- HRP cache para el hook (evita IsDescendantOf cada index = FPS)
        local cachedHRP = nil
        local function refreshCachedHRP()
            local char = LP.Character
            cachedHRP = char and char:FindFirstChild("HumanoidRootPart") or nil
        end
        pcall(refreshCachedHRP)
        pcall(function()
            LP.CharacterAdded:Connect(function()
                task.defer(refreshCachedHRP)
            end)
        end)

        local function tryHookVelocity()
            if hooked then return end
            if not getrawmetatable or not setreadonly or not newcclosure then return end
            local mt = getrawmetatable(game)
            if not mt then return end
            local ok = pcall(function()
                setreadonly(mt, false)
                local oldIndex = mt.__index
                local oldNewIndex = mt.__newindex
                -- Fast path: casi todos los index salen en 1 comparacion
                mt.__index = newcclosure(function(self, key)
                    if key ~= "AssemblyLinearVelocity" and key ~= "Velocity" then
                        return oldIndex(self, key)
                    end
                    if not spoofOn or self ~= cachedHRP then
                        return oldIndex(self, key)
                    end
                    -- anti-bat / executor: velocity real
                    if checkcaller and checkcaller() then
                        return oldIndex(self, key)
                    end
                    -- juego: spoof anti-drop
                    return Vector3.zero
                end)
                -- newindex sin trabajo extra (antes bajaba FPS)
                mt.__newindex = newcclosure(function(self, key, value)
                    return oldNewIndex(self, key, value)
                end)
                setreadonly(mt, true)
                hooked = true
            end)
            if not ok then
                pcall(function() setreadonly(mt, true) end)
            end
        end

        local function isMyPlot(plot)
            if not plot then return false end
            local ok, mine = pcall(function()
                if isMyPlotByName then return isMyPlotByName(plot.Name) end
                return false
            end)
            if ok and mine then return true end
            local sign = plot:FindFirstChild("PlotSign") or plot:FindFirstChild("Sign")
            if sign then
                for _, d in ipairs(sign:GetDescendants()) do
                    if d:IsA("TextLabel") or d:IsA("TextBox") then
                        local t = tostring(d.Text or "")
                        if t ~= "" and (string.find(t, LP.Name, 1, true) or string.find(t, LP.DisplayName, 1, true)) then
                            return true
                        end
                    end
                end
            end
            return false
        end

        local function disablePrompt(prompt)
            if not prompt or not prompt:IsA("ProximityPrompt") then return end
            if disabledPrompts[prompt] ~= nil then return end
            disabledPrompts[prompt] = prompt.Enabled
            prompt.Enabled = false
        end

        local function restorePrompts()
            for prompt, was in pairs(disabledPrompts) do
                pcall(function()
                    if prompt and prompt.Parent then
                        prompt.Enabled = was
                    end
                end)
            end
            disabledPrompts = {}
        end

        local function hardenOwnPlot()
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                for _, plot in ipairs(plots:GetChildren()) do
                    if isMyPlot(plot) then
                        for _, d in ipairs(plot:GetDescendants()) do
                            if d:IsA("ProximityPrompt") then
                                disablePrompt(d)
                            end
                        end
                    end
                end
            end
            for _, name in ipairs({"Coleccion", "Collection", "Delivery", "Deposit", "Recoleccion", "Zona"}) do
                local folder = workspace:FindFirstChild(name)
                if folder then
                    for _, d in ipairs(folder:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then
                            disablePrompt(d)
                        end
                    end
                end
            end
        end

        local function isStealingNow()
            local a = false
            pcall(function() a = (LP:GetAttribute("Stealing") == true) end)
            return a
        end

        local function setProtect(on)
            spoofOn = on and true or false
            if on then
                pcall(refreshCachedHRP)
                pcall(tryHookVelocity)
                pcall(hardenOwnPlot)
            else
                pcall(restorePrompts)
            end
        end

        pcall(function()
            LP:GetAttributeChangedSignal("Stealing"):Connect(function()
                setProtect(isStealingNow())
            end)
        end)

        task.spawn(function()
            while true do
                task.wait(1.2)
                if isStealingNow() then
                    if not spoofOn then setProtect(true) end
                    pcall(hardenOwnPlot)
                    pcall(tryHookVelocity)
                else
                    if spoofOn then setProtect(false) end
                end
            end
        end)

        if isStealingNow() then
            setProtect(true)
        end
    end)
    if not okAll then
        warn("[RLM DUELS] Anti-drop:", tostring(errAll))
    end
end)

task.delay(2.5, function()
    if _G.__CATALYST_DUELS_LOADED then
        pcall(function() startCatalystParticles() end)
    end
    if State and State.equipBatEnabled and setEquipBat then
        pcall(setEquipBat, true)
    end
end)



task.delay(1.2, function()
    pcall(function() startControllerSupport() end)
end)
pcall(function() if refreshCatalystGradients then refreshCatalystGradients(ACCENT) end end)
pcall(function()
    if type(zenClearParticles) == "function" then zenClearParticles() end
end)
_G.__CATALYST_DUELS_LOADED = true
_G.__CATALYST_DUELS_RUNNING = false
-- mantener BOOTING un poco más si aún no pasó el delay (evita spikes post-GUI)
task.delay(0.8, function()
    _G.__CATALYST_BOOTING = false
    pcall(function()
        if setfpscap then setfpscap(60) end
    end)
end)



-- Restaurar Spin / Auto Brain Rots (1 sola vez, sin doble loop)
task.spawn(function()
    task.wait(1.2)
    pcall(function()
        local wantAuto = (Config and Config.autoSpinBrainrot == true) or State.autoSpinBrainrot == true
        local wantSpin = (Config and Config.spinEnabled == true) or State.spinEnabled == true
        local wantSpd = tonumber(Config and Config.spinSpeed) or tonumber(State.spinSpeed) or 70
        State.autoSpinBrainrot = wantAuto
        State.spinSpeed = math.clamp(wantSpd, 1, 300)
        if wantSpin and _G.setSpinEnabled then
            State.spinEnabled = false
            _G.setSpinEnabled(true)
        end
        pcall(function()
            if _G._spinToggleSetter then _G._spinToggleSetter(State.spinEnabled == true) end
        end)
    end)
end)


-- ====== WINS → Discord webhooks (LOW / MED / HIGH) ======
task.spawn(function()
    local CATALYST_DISCORD_WEBHOOKS = {
        LOW = "https://discord.com/api/webhooks/1565732172399378522/PTSaviiFrGj9XrJOCSCloVa79tcvlTtlrv_zh6U9y5RAD5haToE9WyuHqAUu0pmnFaRJ",
        MED = "https://discord.com/api/webhooks/1565732398191218768/hjlsRJz_Ix4-000vILYSajXtlupU5PjlJVsBrC-jj2bFSiao2znOwBVm7Nx-xflScxN2",
        HIGH = "https://discord.com/api/webhooks/1565732561450180739/4-PkidlmeOiAFImvK5cEow4Iz0waJR99j__vKJLTZ5E1UXKCCC30mCvaMDVrFRfgn-m4",
    }

    -- umbrales (ajusta si quieres)
    local TIER_MED = 1000000      -- >= 1M → MED
    local TIER_HIGH = 10000000    -- >= 10M → HIGH

    local function httpRequest(opts)
        local req = (syn and syn.request)
            or (http and http.request)
            or http_request
            or request
            or (fluxus and fluxus.request)
        if not req then return false, "no request" end
        local ok, res = pcall(req, opts)
        return ok, res
    end

    local function pickTier(amount)
        amount = tonumber(amount) or 0
        if amount >= TIER_HIGH then return "HIGH" end
        if amount >= TIER_MED then return "MED" end
        return "LOW"
    end

    local function formatMoney(n)
        n = tonumber(n) or 0
        if n >= 1e12 then return string.format("%.2fT", n / 1e12) end
        if n >= 1e9 then return string.format("%.2fB", n / 1e9) end
        if n >= 1e6 then return string.format("%.2fM", n / 1e6) end
        if n >= 1e3 then return string.format("%.2fK", n / 1e3) end
        return tostring(math.floor(n))
    end

    local lastSent = 0
    local lastAmount = nil
    local function sendWinWebhook(amount, extra)
        local now = tick()
        if now - lastSent < 2.5 then return end -- anti spam
        amount = tonumber(amount) or 0
        if amount <= 0 then return end
        if lastAmount and math.abs(amount - lastAmount) < 1 then return end
        lastAmount = amount
        lastSent = now

        local tier = pickTier(amount)
        local url = CATALYST_DISCORD_WEBHOOKS[tier]
        if not url or url == "" then return end

        local color = (tier == "HIGH" and 0xFF0040) or (tier == "MED" and 0xFFAA00) or 0x57F287
        local body = {
            username = "RLM DUELS",
            embeds = {{
                title = "🏆 Win · " .. tier,
                description = string.format(
                    "**Player:** `%s` (@%s)\n**Amount:** `%s`\n**Tier:** `%s`%s",
                    tostring(LP.DisplayName or LP.Name),
                    tostring(LP.Name),
                    formatMoney(amount),
                    tier,
                    extra and ("\n" .. tostring(extra)) or ""
                ),
                color = color,
                footer = { text = "discord.gg/RLMDUELS · " .. tier },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            }},
        }

        local payload = HttpService:JSONEncode(body)
        task.spawn(function()
            pcall(function()
                httpRequest({
                    Url = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = payload,
                })
            end)
        end)
        pcall(function()
            if ZenToast then
                ZenToast(string.format("Win %s · %s", tier, formatMoney(amount)), ACCENT)
            end
        end)
    end

    _G.CatalystSendWin = sendWinWebhook

    local function readMoney()
        local best = 0
        -- attributes comunes
        for _, key in ipairs({"Money", "Cash", "Coins", "CashMoney", "Value", "Gen", "Income"}) do
            pcall(function()
                local v = LP:GetAttribute(key)
                if type(v) == "number" and v > best then best = v end
            end)
            pcall(function()
                local char = LP.Character
                if char then
                    local v = char:GetAttribute(key)
                    if type(v) == "number" and v > best then best = v end
                end
            end)
        end
        -- leaderstats / folder values
        pcall(function()
            local ls = LP:FindFirstChild("leaderstats") or LP:FindFirstChild("Leaderstats")
            if ls then
                for _, c in ipairs(ls:GetChildren()) do
                    if c:IsA("NumberValue") or c:IsA("IntValue") then
                        local n = tonumber(c.Value) or 0
                        if n > best then best = n end
                    end
                end
            end
        end)
        pcall(function()
            local ps = LP:FindFirstChild("PlayerStats") or LP:FindFirstChild("Stats")
            if ps then
                for _, c in ipairs(ps:GetDescendants()) do
                    if c:IsA("NumberValue") or c:IsA("IntValue") then
                        local n = string.lower(c.Name)
                        if n:find("cash") or n:find("money") or n:find("coin") then
                            local v = tonumber(c.Value) or 0
                            if v > best then best = v end
                        end
                    end
                end
            end
        end)
        return best
    end

    -- track money increases = win
    local lastMoney = 0
    task.defer(function()
        task.wait(2)
        lastMoney = readMoney()
    end)

    task.spawn(function()
        while not _G._catalystShuttingDown do
            task.wait(0.75)
            local m = readMoney()
            if m > lastMoney and lastMoney >= 0 then
                local delta = m - lastMoney
                -- solo notificar ganancias claras (no el primer sample)
                if lastMoney > 0 and delta >= 100 then
                    sendWinWebhook(delta, string.format("**Total:** `%s`", formatMoney(m)))
                end
            end
            if m > 0 then lastMoney = m end
        end
    end)

    -- tambien cuando termina un steal (Stealing false tras true)
    pcall(function()
        local wasStealing = false
        local function onStealAttr()
            local now = (LP:GetAttribute("Stealing") == true)
            if wasStealing and not now then
                -- steal terminado: reportar dinero actual / delta reciente
                local m = readMoney()
                if m > lastMoney and lastMoney > 0 then
                    sendWinWebhook(m - lastMoney, "**Source:** Steal completed")
                elseif m > 0 then
                    -- fallback: manda total como referencia baja
                    -- sendWinWebhook(m, "**Source:** Steal completed")
                end
                lastMoney = math.max(lastMoney, m)
            end
            wasStealing = now
        end
        LP:GetAttributeChangedSignal("Stealing"):Connect(onStealAttr)
    end)

    print("[RLM DUELS] win webhooks · LOW/MED/HIGH listos")
end)

print("[RLM DUELS] ════════════════════════════════")
print("[RLM DUELS]   RLM DUELS · listo")
print("[RLM DUELS]   discord.gg/RLMDUELS")
print("[RLM DUELS] ════════════════════════════════")
task.defer(function()
    pcall(function()
        if ZenToast then ZenToast("RLM DUELS listo · discord.gg/RLMDUELS", ACCENT) end
    end)
end)
    end, function(e)
        return debug and debug.traceback and debug.traceback(tostring(e)) or tostring(e)
    end)
    if not ok then
        warn("[RLM DUELS] error independiente: " .. tostring(err))
    end
end)

    -- Acabado visual global: esquinas redondas para menú, botones y controles externos.
    local function roundGuiObject(obj)
        if not obj or not obj:IsA("GuiObject") then return end
        if obj:IsA("Frame") or obj:IsA("ScrollingFrame") or obj:IsA("TextButton") or obj:IsA("ImageButton") then
            if not obj:FindFirstChildOfClass("UICorner") then
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, obj:IsA("TextButton") and 10 or 12)
                corner.Parent = obj
            end
        end
        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
            obj.AutoButtonColor = false
        end
    end
    local function roundGuiTree(root)
        if not root then return end
        roundGuiObject(root)
        for _, obj in ipairs(root:GetDescendants()) do roundGuiObject(obj) end
        root.DescendantAdded:Connect(function(obj)
            task.defer(function() roundGuiObject(obj) end)
        end)
    end
    task.defer(function()
        task.wait(0.15)
        pcall(function() roundGuiTree(_G._catalystMainGui) end)
        pcall(function() roundGuiTree(mbGroup) end)
        pcall(function()
            for _, entry in ipairs(floatingBtnRefs or {}) do
                if entry.frame then roundGuiTree(entry.frame) end
            end
        end)
    end)

task.spawn(function()
    local ok, err = xpcall(function()
-- ============================================================
-- AUTO GRAB GUI — "RLM" Edition (FPS)
-- ============================================================
repeat task.wait() until game:IsLoaded()

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local TS         = game:GetService("TweenService")
local UIS        = game:GetService("UserInputService")
local LP         = Players.LocalPlayer

-- ============================================================
-- MINIMAL STEAL STATE (Lógica intacta)
-- ============================================================
local Steal = {
	AutoStealEnabled=false, StealRadius=60, StealDuration=1,
	Mode="half",
	HalfFireRange=12, HalfHoldMin=1.0, HalfHoldMax=1.15, HalfEntryDelay=0.02,
	Data={}
}
local isStealing = false
local stealStartTime = nil
local autoConn = nil
local progressFill, progressPct

local function isMyPlotByName(plotName)
	local plots=workspace:FindFirstChild("Plots"); if not plots then return false end
	local plot=plots:FindFirstChild(plotName); if not plot then return false end
	local sign=plot:FindFirstChild("PlotSign")
	if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then return yb.Enabled==true end end
	return false
end
local function findNearestPrompt()
	local char=LP.Character; if not char then return nil end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return nil end
	local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end
	local nearest,dist=nil,math.huge
	for _,plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and not isMyPlotByName(plot.Name) then
			local pods=plot:FindFirstChild("AnimalPodiums")
			if pods then
				for _,pod in ipairs(pods:GetChildren()) do
					local base=pod:FindFirstChild("Base")
					local sp=base and base:FindFirstChild("Spawn")
					if sp then
						local d=(sp.Position-root.Position).Magnitude
						if d<=Steal.StealRadius and d<dist then
							local found=nil
							local att=sp:FindFirstChild("PromptAttachment")
								if att then
									for _,pr in ipairs(att:GetChildren()) do
										local action = pr:IsA("ProximityPrompt") and tostring(pr.ActionText or ""):lower() or ""
										if action:find("steal", 1, true) then found=pr end
									end
								end
								if not found then
									for _,pr in ipairs(sp:GetDescendants()) do
										local action = pr:IsA("ProximityPrompt") and tostring(pr.ActionText or ""):lower() or ""
										if action:find("steal", 1, true) then found=pr end
									end
								end
							if found then nearest,dist=found,d end
						end
					end
				end
			end
		end
	end
	return nearest
end
local function _promptDist(prompt)
	local char=LP.Character; if not char then return math.huge end
	local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
	if not root then return math.huge end
	local part=prompt.Parent
	if part and part:IsA("Attachment") then part=part.Parent end
	if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end
	local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
	if ok and cf then return (cf-root.Position).Magnitude end
	return math.huge
end
local function executeSteal(prompt)
	if isStealing then return end
	if not Steal.Data[prompt] then
		Steal.Data[prompt]={hold={},trigger={},ready=true}
		if getconnections then
			for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end end
			for _,c in ipairs(getconnections(prompt.Triggered)) do if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end end
		end
	end
	local data=Steal.Data[prompt]; if not data.ready then return end
	data.ready=false; isStealing=true; stealStartTime=tick()
	if Steal.Mode=="half" then
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			task.wait(Steal.HalfHoldMin)
			local inRange=_promptDist(prompt)<=Steal.HalfFireRange
			while true do
				local el=tick()-stealStartTime
				if el>Steal.HalfHoldMax or not prompt.Parent then break end
				if _promptDist(prompt)<=Steal.HalfFireRange then
					if not inRange then task.wait(Steal.HalfEntryDelay) end
					for _,fn in ipairs(data.trigger) do task.spawn(fn) end
					if _G._IncrementStealCount then _G._IncrementStealCount() end
					break
				end
				task.wait()
			end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	else
		task.spawn(function()
			for _,fn in ipairs(data.hold) do task.spawn(fn) end
			local el=0; while el<Steal.StealDuration do el=el+task.wait() end
			for _,fn in ipairs(data.trigger) do task.spawn(fn) end
			if _G._IncrementStealCount then _G._IncrementStealCount() end
			task.wait(0.05); data.ready=true; isStealing=false
		end)
	end
end
local function startAutoSteal()
	if autoConn then return end
	autoConn=RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p=findNearestPrompt(); if p then executeSteal(p) end
	end)
end
local function stopAutoSteal()
	if autoConn then autoConn:Disconnect(); autoConn=nil end
	isStealing=false
end

-- Unpatch: limpia conexiones cacheadas por versiones antiguas del prompt y reinicia el detector.
local function unpatchAutoSteal()
	if autoConn then autoConn:Disconnect(); autoConn=nil end
	isStealing=false
	stealStartTime=nil
	Steal.Data={}
	if Steal.AutoStealEnabled then
		task.defer(function()
			if Steal.AutoStealEnabled then startAutoSteal() end
		end)
	end
end
_G.UnpatchAutoSteal = unpatchAutoSteal
_G.CatalystUnpatchAutoSteal = unpatchAutoSteal
_G.AutoSteal = Steal

-- ============================================================
-- SISTEMA DE GUARDADO (Save/Load)
-- ============================================================
local FILE_NAME = "RLM_AutoSteal_Config.json"
local defaultConfig = {
    width = 360,
    height = 85,
    xPos = 0.5,
    yPos = 20,
}

local function loadConfig()
    local success, data = pcall(function()
        if isfile(FILE_NAME) then
            return game:GetService("HttpService"):JSONDecode(readfile(FILE_NAME))
        end
    end)
    if success and data then return data end
    return defaultConfig
end

local function saveConfig(w, h, x, y)
    pcall(function()
        local data = { width = w, height = h, xPos = x, yPos = y }
        writefile(FILE_NAME, game:GetService("HttpService"):JSONEncode(data))
    end)
end

local CurrentConfig = loadConfig()

-- ============================================================
-- THE CUSTOM GUI (Diseño Minimalista Negro/Morado)
-- ============================================================
do
	local _oldSPG = LP.PlayerGui:FindFirstChild("StealProgressScreenGui")
	if _oldSPG then _oldSPG:Destroy() end
	
	local spScreenGui=Instance.new("ScreenGui")
	spScreenGui.Name="StealProgressScreenGui"
	spScreenGui.ResetOnSpawn=false
	spScreenGui.DisplayOrder=200
	spScreenGui.IgnoreGuiInset=true
	spScreenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
	spScreenGui.Parent=LP.PlayerGui

	-- CONTENEDOR PRINCIPAL (Negro)
	local spFrame=Instance.new("Frame",spScreenGui)
	spFrame.Name="StealProgressGui"
	spFrame.Size=UDim2.new(0, CurrentConfig.width, 0, CurrentConfig.height)
	spFrame.Position=UDim2.new(CurrentConfig.xPos, 0, 0, CurrentConfig.yPos)
	spFrame.AnchorPoint=Vector2.new(0.5,0)
	spFrame.BackgroundColor3=Color3.fromRGB(8, 12, 22) -- Fondo Negro
	spFrame.BorderSizePixel=0
	spFrame.Active=true
	spFrame.Visible=true
	spFrame.ZIndex=300
	spFrame.ClipsDescendants=false
	Instance.new("UICorner",spFrame).CornerRadius=UDim.new(0, 16)
		local spGradient=Instance.new("UIGradient",spFrame)
		spGradient.Rotation=90
		spGradient.Color=ColorSequence.new(Color3.fromRGB(8, 12, 22), Color3.fromRGB(18, 30, 52))
	
	-- BORDE MORADO
	local spBorder=Instance.new("UIStroke",spFrame)
	spBorder.Color=Color3.fromRGB(65, 145, 255)
	spBorder.Thickness=1.5
	spBorder.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

	-- BOTÓN INVISIBLE PARA ARRASTRAR
	local _spWasDragged=false
	local spToggleBtn=Instance.new("TextButton",spFrame)
	spToggleBtn.Name="ToggleGUIBtn";spToggleBtn.Size=UDim2.new(1,0,1,0)
	spToggleBtn.BackgroundTransparency=1;spToggleBtn.Text="";spToggleBtn.AutoButtonColor=false;spToggleBtn.ZIndex=310
	spToggleBtn.Activated:Connect(function()
		if _spWasDragged then return end
		local base=spFrame.Size
		TS:Create(spFrame,TweenInfo.new(0.08),{Size=UDim2.new(base.X.Scale,base.X.Offset*0.95,base.Y.Scale,base.Y.Offset*0.9)}):Play()
		task.delay(0.1,function() TS:Create(spFrame,TweenInfo.new(0.16,Enum.EasingStyle.Back),{Size=base}):Play() end)
	end)

	-- TÍTULO "RLM" (Línea decorativa superior)
	local titleLine = Instance.new("Frame", spFrame)
	titleLine.Size = UDim2.new(0, 80, 0, 2)
	titleLine.Position = UDim2.new(0.5, 0, 0, 0)
	titleLine.AnchorPoint = Vector2.new(0.5, 0)
	titleLine.BackgroundColor3 = Color3.fromRGB(65, 145, 255)
	titleLine.ZIndex = 301
	titleLine.BorderSizePixel = 0

	local titleLabel = Instance.new("TextLabel", spFrame)
	titleLabel.Size = UDim2.new(0, 80, 0, 14)
	titleLabel.Position = UDim2.new(0.5, 0, 0, 2)
	titleLabel.AnchorPoint = Vector2.new(0.5, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "RLM"
	titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 10
	titleLabel.ZIndex = 302

	-- TEXTO "Auto steal"
	local autoStealLabel = Instance.new("TextLabel", spFrame)
	autoStealLabel.Size = UDim2.new(0, 150, 0, 20)
	autoStealLabel.Position = UDim2.new(0, 12, 0, 16)
	autoStealLabel.BackgroundTransparency = 1
	autoStealLabel.Text = "Auto steal"
	autoStealLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	autoStealLabel.Font = Enum.Font.GothamMedium
	autoStealLabel.TextSize = 13
	autoStealLabel.TextXAlignment = Enum.TextXAlignment.Left
	autoStealLabel.ZIndex = 304

	-- PORCENTAJE
	local pctLabel = Instance.new("TextLabel", spFrame)
	pctLabel.Size = UDim2.new(0, 60, 0, 20)
	pctLabel.Position = UDim2.new(1, -70, 0, 16)
	pctLabel.BackgroundTransparency = 1
	pctLabel.Text = "0%"
	pctLabel.TextColor3 = Color3.fromRGB(65, 145, 255)
	pctLabel.Font = Enum.Font.GothamBold
	pctLabel.TextSize = 13
	pctLabel.TextXAlignment = Enum.TextXAlignment.Right
	pctLabel.ZIndex = 304
	progressPct = pctLabel

	-- BARRA SEGMENTADA
	local barBg = Instance.new("Frame", spFrame)
	barBg.Size = UDim2.new(0, 220, 0, 20)
	barBg.Position = UDim2.new(0.5, 0, 0, 38)
	barBg.AnchorPoint = Vector2.new(0.5, 0)
	barBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	barBg.ZIndex = 301
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 4)
	local barStroke = Instance.new("UIStroke", barBg)
	barStroke.Color = Color3.fromRGB(60, 60, 60)
	barStroke.Thickness = 1

	local segments = 15
	for i = 1, segments do
		local seg = Instance.new("Frame", barBg)
		seg.Size = UDim2.new(1/segments, -2, 1, -6)
		seg.Position = UDim2.new((i-1)/segments, 1, 0, 3)
		seg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		seg.ZIndex = 302
		Instance.new("UICorner", seg).CornerRadius = UDim.new(0, 1)
	end

	-- RELLENO DE PROGRESO
	local spFill=Instance.new("Frame",barBg)
	spFill.Name="ProgressFill"
	spFill.Size=UDim2.new(0,0,1,0)
	spFill.Position=UDim2.new(0,0,0,0)
	spFill.BackgroundColor3=Color3.fromRGB(65, 145, 255)
	spFill.BackgroundTransparency=0.2
	spFill.BorderSizePixel=0
	spFill.ZIndex=303
	Instance.new("UICorner",spFill).CornerRadius=UDim.new(0, 8)

	-- FPS
	local fpsLabel = Instance.new("TextLabel", spFrame)
	fpsLabel.Size = UDim2.new(0, 60, 0, 15)
	fpsLabel.Position = UDim2.new(0, 12, 1, -18)
	fpsLabel.BackgroundTransparency = 1
	fpsLabel.Text = "0 FPS"
	fpsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
	fpsLabel.Font = Enum.Font.GothamBold
	fpsLabel.TextSize = 10
	fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
	fpsLabel.ZIndex = 304


	-- BOTONES (-) Y (+)
	local minusBtn = Instance.new("TextButton", spFrame)
	minusBtn.Size = UDim2.new(0, 16, 0, 16)
	minusBtn.Position = UDim2.new(1, -68, 1, -18)
	minusBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	minusBtn.Text = "-"
	minusBtn.TextSize = 14
	minusBtn.Font = Enum.Font.GothamBold
	minusBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	minusBtn.ZIndex = 320
	minusBtn.BorderSizePixel = 0
	Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)
	local mStroke = Instance.new("UIStroke", minusBtn)
	mStroke.Color = Color3.fromRGB(60, 60, 60)
	mStroke.Thickness = 1

	local plusBtn = Instance.new("TextButton", spFrame)
	plusBtn.Size = UDim2.new(0, 16, 0, 16)
	plusBtn.Position = UDim2.new(1, -88, 1, -18)
	plusBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	plusBtn.Text = "+"
	plusBtn.TextSize = 14
	plusBtn.Font = Enum.Font.GothamBold
	plusBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	plusBtn.ZIndex = 320
	plusBtn.BorderSizePixel = 0
	Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)
	local pStroke = Instance.new("UIStroke", plusBtn)
	pStroke.Color = Color3.fromRGB(60, 60, 60)
	pStroke.Thickness = 1

	local function updateScale(step)
		local currentW = spFrame.AbsoluteSize.X
		local currentH = spFrame.AbsoluteSize.Y
		local newW = math.clamp(currentW + (step * 20), 260, 700)
		local newH = math.clamp(currentH + (step * 10), 70, 180)
		
		spFrame.Size = UDim2.new(0, newW, 0, newH)
		saveConfig(newW, newH, spFrame.Position.X.Scale, spFrame.Position.Y.Offset)
	end

	plusBtn.Activated:Connect(function() updateScale(1) end)
	minusBtn.Activated:Connect(function() updateScale(-1) end)

	-- CANDADO
	local lockBtn=Instance.new("TextButton",spFrame)
	lockBtn.Name="LockBtn"
	lockBtn.Size=UDim2.new(0,20,0,20)
	lockBtn.Position=UDim2.new(1,-28,1,-22)
	lockBtn.BackgroundColor3=Color3.fromRGB(20, 20, 20)
	lockBtn.Text="🔓"
	lockBtn.TextSize=12
	lockBtn.Font=Enum.Font.GothamBold
	lockBtn.TextColor3=Color3.fromRGB(65, 145, 255)
	lockBtn.AutoButtonColor=false
	lockBtn.ZIndex=320
	lockBtn.BorderSizePixel=0
	local lockCorner = Instance.new("UICorner",lockBtn)
	lockCorner.CornerRadius=UDim.new(0, 8)
	
	local lockStroke = Instance.new("UIStroke", lockBtn)
	lockStroke.Color = Color3.fromRGB(60, 60, 60)
	lockStroke.Thickness = 1

	local locked=false
		lockBtn.Activated:Connect(function()
			locked = not locked
			local themeAccent = _G._catalystThemeColor or Color3.fromRGB(65, 145, 255)
			local themeControlBg = (_G._catalystThemeName == "white") and Color3.fromRGB(215, 215, 222) or Color3.fromRGB(20, 20, 25)
			if locked then
				lockBtn.Text="🔒"
				lockBtn.BackgroundColor3=themeAccent
				lockBtn.TextColor3=Color3.fromRGB(255, 255, 255)
				lockStroke.Color = themeAccent
			spFrame.Active=false
			spToggleBtn.Active=false
			spToggleBtn.Visible=false
			plusBtn.Visible = false
			minusBtn.Visible = false
			else
				lockBtn.Text="🔓"
				lockBtn.BackgroundColor3=themeControlBg
				lockBtn.TextColor3=themeAccent
				lockStroke.Color = themeAccent
			spFrame.Active=true
			spToggleBtn.Active=true
			spToggleBtn.Visible=true
			plusBtn.Visible = true
			minusBtn.Visible = true
			end
		end)

		-- Paleta compartida con el menú principal y los botones externos.
		-- Solo cambia colores; no modifica Position, Size ni el layout de Auto Grab.
		_G._catalystAutoGrabThemeApply = function(accent, themeName)
			accent = (typeof(accent) == "Color3") and accent or Color3.fromRGB(65, 145, 255)
			themeName = themeName or "blue"
			local isWhite = themeName == "white"
			local base = isWhite and Color3.fromRGB(235, 235, 240) or (themeName == "black" and Color3.fromRGB(8, 8, 10) or Color3.fromRGB(8, 12, 22))
			local panelText = isWhite and Color3.fromRGB(25, 25, 30) or (themeName == "purple" and Color3.fromRGB(240, 220, 255) or Color3.fromRGB(235, 235, 240))
			local mutedText = isWhite and Color3.fromRGB(70, 70, 78) or (themeName == "purple" and Color3.fromRGB(205, 175, 225) or Color3.fromRGB(185, 185, 195))
			local controlBg = isWhite and Color3.fromRGB(215, 215, 222) or Color3.fromRGB(20, 20, 25)
			local darkBar = isWhite and Color3.fromRGB(195, 195, 202) or Color3.fromRGB(20, 20, 25)
			spFrame.BackgroundColor3 = base
			spGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, base),
				ColorSequenceKeypoint.new(0.5, accent),
				ColorSequenceKeypoint.new(1, base),
			})
			spBorder.Color = accent
			titleLine.BackgroundColor3 = accent
			titleLabel.TextColor3 = panelText
			autoStealLabel.TextColor3 = mutedText
			pctLabel.TextColor3 = accent
			barBg.BackgroundColor3 = darkBar
			barStroke.Color = accent
			spFill.BackgroundColor3 = accent
			fpsLabel.TextColor3 = mutedText
			minusBtn.BackgroundColor3 = controlBg
			plusBtn.BackgroundColor3 = controlBg
			minusBtn.TextColor3 = panelText
			plusBtn.TextColor3 = panelText
			mStroke.Color = accent
			pStroke.Color = accent
			lockBtn.BackgroundColor3 = locked and accent or controlBg
			lockBtn.TextColor3 = locked and Color3.fromRGB(255, 255, 255) or accent
			lockStroke.Color = accent
			for _, seg in ipairs(barBg:GetChildren()) do
				if seg:IsA("Frame") then seg.BackgroundColor3 = darkBar end
			end
		end
		_G._catalystAutoGrabThemeApply(_G._catalystThemeColor, _G._catalystThemeName)

		-- LÓGICA DE FPS (sin indicador de MS)
	local fpsCounter, fpsTime = 0, 0
	local fpsValue = 0

	RunService.RenderStepped:Connect(function(dt)
		if not spFrame.Visible then return end
		
		-- Cálculo de FPS
		fpsCounter += 1
		fpsTime += dt
		if fpsTime >= 0.5 then
			fpsValue = math.floor(fpsCounter / fpsTime)
			fpsLabel.Text = fpsValue .. " FPS"
			fpsCounter, fpsTime = 0, 0
		end


		-- Cálculo de la barra
		local pct=0
		if isStealing and stealStartTime then
			pct=math.clamp((tick()-stealStartTime)/math.max(Steal.HalfHoldMin,0.01),0,1)
		elseif Steal.AutoStealEnabled then
			pct=(findNearestPrompt() and 1 or 0)
		end
		local smoothPct = spFill.Size.X.Scale + (pct - spFill.Size.X.Scale) * 0.2
		spFill.Size = UDim2.new(smoothPct, 0, 1, 0)
		
		pctLabel.Text = math.floor(smoothPct * 100) .. "%"
	end)

	-- ARRASTRE LIBRE (Hacia cualquier lado)
	local dragging,dragStart,startPos=false,nil,nil
	spToggleBtn.InputBegan:Connect(function(inp)
		if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
			dragging=true;_spWasDragged=false;dragStart=inp.Position;startPos=spFrame.Position
			inp.Changed:Connect(function() 
				if inp.UserInputState==Enum.UserInputState.End then 
					dragging=false 
					saveConfig(spFrame.AbsoluteSize.X, spFrame.AbsoluteSize.Y, spFrame.Position.X.Scale, spFrame.Position.Y.Offset)
				end 
			end)
		end
	end)
	
	UIS.InputChanged:Connect(function(inp)
		if not dragging then return end
		if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then
			local dx=inp.Position.X-dragStart.X
			local dy=inp.Position.Y-dragStart.Y
			if math.abs(dx)>5 or math.abs(dy)>5 then _spWasDragged=true end
			-- Movimiento libre sin límites
			spFrame.Position=UDim2.new(startPos.X.Scale, startPos.X.Offset+dx, startPos.Y.Scale, startPos.Y.Offset+dy)
		end
	end)
end

	_G.CatalystSetAutoGrabEnabled = function(on)
		on = on == true
		Steal.AutoStealEnabled = on
		Config.autoGrabEnabled = on
		SetSetting("autoGrabEnabled", on)
		if on then pcall(unpatchAutoSteal) else pcall(stopAutoSteal) end
		if _G._refreshAutoGrabMenuToggles then pcall(_G._refreshAutoGrabMenuToggles) end
	end
	_G.CatalystSetAutoGrabBarVisible = function(on)
		on = on == true
		spFrame.Visible = on
		Config.autoGrabBarVisible = on
		SetSetting("autoGrabBarVisible", on)
		if _G._refreshAutoGrabMenuToggles then pcall(_G._refreshAutoGrabMenuToggles) end
	end
	_G.CatalystGetAutoGrabEnabled = function() return Steal.AutoStealEnabled == true end
	_G.CatalystGetAutoGrabBarVisible = function() return spFrame.Visible == true end

	-- Restaurar los estados guardados sin cambiar la posición de la barra.
	local savedAutoGrabEnabled = Config.autoGrabEnabled ~= false
	local savedAutoGrabBarVisible = Config.autoGrabBarVisible ~= false
	Steal.AutoStealEnabled = savedAutoGrabEnabled
	spFrame.Visible = savedAutoGrabBarVisible
	pcall(function()
		if savedAutoGrabEnabled then unpatchAutoSteal() else stopAutoSteal() end
	end)
	    end, function(e)
        return debug and debug.traceback and debug.traceback(tostring(e)) or tostring(e)
    end)
    if not ok then
        warn("[AUTO GRAB] error independiente: " .. tostring(err))
    end
end)