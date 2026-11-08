-- BAT BYPASS + BAT AIMBOT from Clean Hub (wrapped safely) + VX7 Advanced Tracking Merged
pcall(function()
-- VX7 adapt prediction table
_G._adaptBatPred = _G._adaptBatPred or {}

-- Prefer UpperTorso/Torso for bat connects (real touchable parts)
local function getBatAimPart(character)
    if not character then return nil end
    return character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("HumanoidRootPart")
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, math.huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local aim = getBatAimPart(c) or tRoot
                        local dx = aim.Position.X - rpos.X
                        local dy = aim.Position.Y - rpos.Y
                        local dz = aim.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then 
                            minDist = d
                            closest = aim
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- VX7 upgraded nearestTarget with prediction cache
local function vx7NearestTarget(root)
    return getClosestTarget()
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = _V3new(0, -0.1, 0)
        root.AssemblyAngularVelocity = _V3zero
    end
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
    _unsuppressBodyLock(true)
end

-- MERGED: VX7 velocity prediction from message_3.txt added to WHITE's adapt
function startAimbotAdapt()
    if _aimbotConn then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end

        -- VX7 Prediction System (from message_3.txt tbl36.update)
        local adapt = _G._adaptBatPred
        local now = tick()
        local entry = adapt[target]
        local smoothedVel = Vector3.zero
        if not entry then
            adapt[target] = {pos = target.Position, time = now, vel = Vector3.zero}
        else
            local dt = math.clamp(now - entry.time, 0.00833, 0.25)
            local rawVel = (target.Position - entry.pos) / dt
            if rawVel.Magnitude > 80 then rawVel = rawVel.Unit * 80 end
            entry.vel = entry.vel:Lerp(rawVel, 0.38)
            entry.pos = target.Position
            entry.time = now
            smoothedVel = entry.vel
        end
        entry = adapt[target]

        local targetVel = smoothedVel.Magnitude > 0 and smoothedVel or (target.AssemblyLinearVelocity or Vector3.zero)
        local myPos = root.Position
        local targetPos = target.Position

        -- Cached ping (NOT every frame — was causing hitch/lag)
        _G._batAimPingCache = _G._batAimPingCache or { t = 0, ms = 50 }
        if now - _G._batAimPingCache.t > 0.5 then
            _G._batAimPingCache.t = now
            pcall(function()
                _G._batAimPingCache.ms = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() or 50
            end)
        end
        local pingSec = math.clamp((_G._batAimPingCache.ms or 50) / 1000, 0.04, 0.28)

        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(0.09 + speed3 / 130 + pingSec * 0.5, 0.09, 0.32)
        local predictedPos = targetPos + targetVel * predictTime

        local flatVel = Vector3.new(targetVel.X, 0, targetVel.Z)
        local lead = (type(BAT_V2_LEAD_STUDS) == "number" and BAT_V2_LEAD_STUDS or 5) + 1.2 + pingSec * 5
        if flatVel.Magnitude > 1 then
            predictedPos = predictedPos + flatVel.Unit * lead
        end
        predictedPos = Vector3.new(predictedPos.X, targetPos.Y + 1.2, predictedPos.Z)

        local direction = predictedPos - myPos
        local flatDir = _V3new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.05 then flatDir = flatDir.Unit else flatDir = _V3new(0,0,0) end

        local aimSpeed = (type(BAT_AIMBOT_SPEED) == "number" and BAT_AIMBOT_SPEED) or 55
        if type(BAT_V2_SPEED) == "number" then
            aimSpeed = math.max(aimSpeed, BAT_V2_SPEED * 0.92)
        end
        -- soft speed limit so client doesn't micro-stutter
        aimSpeed = math.min(aimSpeed, 78)

        local desiredHeight = predictedPos.Y + 2.2
        local yVel = (desiredHeight - myPos.Y) * 18 + targetVel.Y * 0.75
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 12) end
        yVel = _clamp(yVel, -55, 95)

        local curVel = root.AssemblyLinearVelocity
        local desiredVel = _V3new(flatDir.X * aimSpeed, yVel, flatDir.Z * aimSpeed)
        -- softer lerp = smoother, less laggy rubberband
        root.AssemblyLinearVelocity = curVel:Lerp(desiredVel, 0.55)

        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.15 then
            local goalCF = _CFlookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = _clamp(rx, -2.2, 2.2)
            ry = _clamp(ry, -2.2, 2.2)
            rz = _clamp(rz, -2.2, 2.2)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(rx * 36, ry * 36, rz * 36))
        end

        -- swing throttle (no double-defer spam = no lag spikes)
        local flatDist = Vector3.new(myPos.X - predictedPos.X, 0, myPos.Z - predictedPos.Z).Magnitude
        _G._batAimLastSwing = _G._batAimLastSwing or 0
        if flatDist <= 10.5 and (now - _G._batAimLastSwing) >= 0.18 then
            _G._batAimLastSwing = now
            trySwing()
        end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if not _G.AmbitiousSafeModeTryStart() then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        return
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if autoBatV2Enabled then disableBatV2() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

-- ═══════════════════════════════════════════════════════════════
-- BAT BYPASS — Ahora con predicción autónoma mejorada (VX7 merge)
-- ═══════════════════════════════════════════════════════════════

BAT_V2_SPEED           = BAT_V2_SPEED           or 72
BAT_V2_HIT_DIST        = BAT_V2_HIT_DIST        or 15
BAT_V2_LEAD_STUDS      = BAT_V2_LEAD_STUDS      or 5.5
BAT_V2_BODY_LOCK_RANGE = BAT_V2_BODY_LOCK_RANGE or 80

local SnowVS = _G.SnowVS or {}
_G.SnowVS = SnowVS

SnowVS.BatBypass = SnowVS.BatBypass or {}
SnowVS.AimbotBypassV2 = SnowVS.BatBypass

local BB = SnowVS.BatBypass

BB.Enabled    = BB.Enabled    or false
BB.Connection = BB.Connection or nil

BB.Z = BB.Z or {
    targetPlayer          = nil,
    lastTargetPos         = nil,
    targetVelocity        = Vector3.zero,
    smoothedVelocity      = Vector3.zero,
    velocityHistory       = {},
    accelerationHistory   = {},
    aerialVelocityHistory = {},
    previousDirection     = nil,
    lastDirectionChangeTime = 0,
    airborneTime          = 0,
    lastActivationTime    = 0,
    currentPing           = 0.1,
    realPingMs            = 0,
}

BB.ZCFG = BB.ZCFG or {
    FOLLOW_SPEED                    = BAT_V2_SPEED,
    ACTIVATE_DISTANCE               = BAT_V2_HIT_DIST,
    MIN_FOLLOW_DISTANCE             = 0.6,
    PREDICTION_TIME                 = 0.28,
    PREDICT_AHEAD                   = BAT_V2_LEAD_STUDS,
    MAX_VELOCITY_CHANGE             = 180,
    VELOCITY_SMOOTHING              = 0.32,
    MAX_HORIZONTAL_VELOCITY         = 95,
    SERVER_TICKRATE                 = 1 / 60,
    MIN_PING_COMPENSATION           = 0.04,
    MAX_PING_COMPENSATION           = 0.32,
    ACCELERATION_PREDICTION_WEIGHT  = 0.45,
    DIRECTION_CHANGE_DETECTION_TIME = 0.1,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.75,
    GRAVITY                         = 196.2,
    AIR_CONTROL_FACTOR              = 0.85,
    MIN_AIRBORNE_TIME               = 0.06,
}

local function bbAverageVector(history)
    if #history == 0 then return Vector3.zero end
    local total = Vector3.zero
    for _, v in ipairs(history) do total += v end
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
    Z.targetPlayer          = nil
    Z.lastTargetPos         = nil
    Z.targetVelocity        = Vector3.zero
    Z.smoothedVelocity      = Vector3.zero
    Z.velocityHistory       = {}
    Z.accelerationHistory   = {}
    Z.aerialVelocityHistory = {}
    Z.previousDirection     = nil
    Z.airborneTime          = 0
end

local function bbNearestTarget(root)
    local nearest, nearestDistance = nil, math.huge
    for _, candidate in ipairs(Players:GetPlayers()) do
        if candidate ~= LP and candidate.Character then
            local targetRoot     = candidate.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < nearestDistance then
                    nearest, nearestDistance = candidate, distance
                end
            end
        end
    end
    return nearest
end

local function bbRotateRoot(root, direction)
    if direction.Magnitude < 0.01 then return end
    local axis  = root.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
    root.AssemblyAngularVelocity = axis.Magnitude > 0.01
        and axis.Unit * angle * 80
        or  Vector3.zero
end

local function bbSamplePing()
    local ok, value = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    local Z = BB.Z
    if ok and type(value) == "number" then Z.realPingMs = math.floor(value) end
    Z.currentPing = math.clamp(
        Z.realPingMs / 1000,
        BB.ZCFG.MIN_PING_COMPENSATION,
        BB.ZCFG.MAX_PING_COMPENSATION
    )
end

BB.PingLoopStarted = BB.PingLoopStarted or false
if not BB.PingLoopStarted then
    BB.PingLoopStarted = true
    task.spawn(function()
        while true do
            pcall(bbSamplePing)
            task.wait(0.5)
        end
    end)
end

function BB.StartBodyLock() end
function BB.StopBodyLock()  end

function BB.Stop()
    local Z = BB.Z
    BB.Enabled = false
    if BB.Connection then
        BB.Connection:Disconnect()
        BB.Connection = nil
    end
    local char     = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root     = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid then humanoid.AutoRotate = true end
    if root     then root.AssemblyAngularVelocity = Vector3.zero end
    bbResetTarget()
    Z.lastActivationTime = 0
end

-- MERGED BYPASS: Now uses VX7 adapt prediction + ping comp
function BB.Start()
    if BB.Connection then return end
    local char     = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root     = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    BB.Enabled = true
    humanoid.AutoRotate = false
    local bat = BB.FindBat()
    if bat and bat.Parent ~= char then
        pcall(function() humanoid:EquipTool(bat) end)
    end
    BB.Connection = RunService.RenderStepped:Connect(function(dt)
        if not BB.Enabled then BB.Stop(); return end
        local Z     = BB.Z
        local ZCFG  = BB.ZCFG
        if _G.AceGetAntiBypassAimbotSpeed then
            ZCFG.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
        end
        local currentChar     = LP.Character
        local currentRoot     = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
        if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
        currentHumanoid.AutoRotate = false
        root, humanoid = currentRoot, currentHumanoid
        bat = currentChar:FindFirstChildOfClass("Tool") or BB.FindBat()
        if bat and bat.Parent ~= currentChar then
            pcall(currentHumanoid.EquipTool, currentHumanoid, bat)
        end
        Z.targetPlayer  = bbNearestTarget(root)
        local targetChar = Z.targetPlayer and Z.targetPlayer.Character
        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
            bbResetTarget(); return
        end
        local targetPos = targetRoot.Position
        local safeDt    = math.max(dt, 1 / 240)

        -- VX7 improved velocity tracking
        local adapt = _G._adaptBatPred
        local adaptEntry = adapt[targetRoot]
        if adaptEntry and adaptEntry.vel.Magnitude > 0 then
            Z.targetVelocity = adaptEntry.vel
        else
            if Z.lastTargetPos then
                local rawVelocity   = (targetPos - Z.lastTargetPos) / safeDt
                local velocityDelta = rawVelocity - Z.targetVelocity
                if velocityDelta.Magnitude > ZCFG.MAX_VELOCITY_CHANGE then
                    rawVelocity = Z.targetVelocity + velocityDelta.Unit * ZCFG.MAX_VELOCITY_CHANGE
                end
                local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
                if horizontal.Magnitude > ZCFG.MAX_HORIZONTAL_VELOCITY then
                    horizontal  = horizontal.Unit * ZCFG.MAX_HORIZONTAL_VELOCITY
                    rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
                end
                bbPushHistory(Z.accelerationHistory, (rawVelocity - Z.targetVelocity) / safeDt, 4)
                bbPushHistory(Z.velocityHistory,     rawVelocity, 8)
                Z.targetVelocity   = rawVelocity
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

        local predictionVelocity = Z.smoothedVelocity.Magnitude > 1 and Z.smoothedVelocity or Z.targetVelocity
        if airborne and #Z.aerialVelocityHistory > 0 then
            local aerial = bbAverageVector(Z.aerialVelocityHistory)
            predictionVelocity = Vector3.new(aerial.X, Z.targetVelocity.Y, aerial.Z) * ZCFG.AIR_CONTROL_FACTOR
        end

        local quickTurn = false
        local horizontalVelocity = Vector3.new(Z.targetVelocity.X, 0, Z.targetVelocity.Z)
        if horizontalVelocity.Magnitude > 5 then
            local direction = horizontalVelocity.Unit
            if Z.previousDirection and Z.previousDirection:Dot(direction) < 0.5 then
                quickTurn = tick() - Z.lastDirectionChangeTime < ZCFG.DIRECTION_CHANGE_DETECTION_TIME
                Z.lastDirectionChangeTime = tick()
            end
            Z.previousDirection = direction
        end

        local serverDelay = Z.currentPing + ZCFG.SERVER_TICKRATE
        if quickTurn then serverDelay *= ZCFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end

        local predicted    = targetPos + predictionVelocity * serverDelay
        local acceleration = bbAverageVector(Z.accelerationHistory)
        predicted += acceleration * ZCFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)

        local predictionTime = ZCFG.PREDICTION_TIME * 1.1
        if airborne then
            predicted += predictionVelocity * predictionTime
            predicted += Vector3.new(0, -0.5 * ZCFG.GRAVITY * predictionTime * predictionTime, 0)
        else
            predicted += predictionVelocity * predictionTime
        end

        local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
        local ahead = (ZCFG.PREDICT_AHEAD or 5.5) + 2.2 + (Z.currentPing or 0.1) * 10
        if flatPrediction.Magnitude > 1 then
            predicted += flatPrediction.Unit * ahead
        end
        local aimPart = targetChar and (targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso"))
        if aimPart then
            predicted = Vector3.new(predicted.X, aimPart.Position.Y + 0.45, predicted.Z)
        else
            predicted = Vector3.new(predicted.X, targetPos.Y + 1.25, predicted.Z)
        end

        local toTarget = predicted - root.Position
        bbRotateRoot(root, toTarget)

        local flatHit = Vector3.new(root.Position.X - predicted.X, 0, root.Position.Z - predicted.Z).Magnitude
        local hitDist = (ZCFG.ACTIVATE_DISTANCE or 15) + 2.5
        if flatHit <= hitDist and tick() - Z.lastActivationTime >= 0.16 then
            if bat then
                pcall(bat.Activate, bat)
            end
            Z.lastActivationTime = tick()
        end

        local follow = math.min(ZCFG.FOLLOW_SPEED or 72, 78)
        if toTarget.Magnitude > (ZCFG.MIN_FOLLOW_DISTANCE or 0.6) then
            local dir = toTarget.Unit
            local cur = root.AssemblyLinearVelocity
            local desired = Vector3.new(dir.X * follow, math.clamp(dir.Y * follow * 0.25 + cur.Y * 0.25, -50, 80), dir.Z * follow)
            root.AssemblyLinearVelocity = cur:Lerp(desired, 0.58)
        else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.45, 0)
        end
    end)
end

function BB.Toggle()
    if BB.Enabled then BB.Stop() else BB.Start() end
end

local function _aceSafeSave()
    if type(saveAllSettings) == "function" then pcall(saveAllSettings) end
end

local function _aceCurrentSpeedMode()
    if laggerCarryToggled then return "Lagger Carry" end
    if laggerToggled      then return "Lagger" end
    if speedMode          then return "Carry"  end
    return "Normal"
end

_G.AceGetAntiBypassAimbotSpeed = function()
    local mode = _aceCurrentSpeedMode()
    if mode == "Lagger" or mode == "Lagger Carry" then
        return math.clamp(tonumber(_G.AceAntiBypassLaggerAimbotSpeed) or 40, 1, 60)
    end
    return math.clamp(tonumber(_G.AceAntiBypassAimbotSpeed) or 55, 1, 60)
end

_G.AceRefreshAimbotVisual = function()
    if _G.AceAimbotSetVisual then
        _G.AceAimbotSetVisual(_G.AceAntiBypassAimbotOn == true)
    end
end

_G.AceStartAntiBypassAimbot = function()
    if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then
        return false
    end
    if _G.AceStopAutoTPForAction then _G.AceStopAutoTPForAction() end
    if _G.AceStopNormalAimbot    then _G.AceStopNormalAimbot()    end

    selectedAimbotMode = "Bat Bypass"
    _G.AceAntiBypassAimbotOn = true
    SnowVS.BatBypass.ZCFG.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
    SnowVS.BatBypass.Start()

    if _G.AceRefreshAimbotVisual then _G.AceRefreshAimbotVisual() end
    _aceSafeSave()
    return true
end

_G.AceStopAntiBypassAimbot = function(keepVisual)
    SnowVS.BatBypass.Stop()
    _G.AceAntiBypassAimbotOn = false
    if keepVisual ~= false and _G.AceRefreshAimbotVisual then
        _G.AceRefreshAimbotVisual()
    end
    _aceSafeSave()
end

_G.AceToggleSelectedAimbot = function()
    if selectedAimbotMode == "Bat Bypass" then
        if _G.AceAntiBypassAimbotOn then
            _G.AceStopAntiBypassAimbot()
        else
            _G.AceStartAntiBypassAimbot()
        end
    end
    if _G.AceRefreshAimbotVisual then _G.AceRefreshAimbotVisual() end
    _aceSafeSave()
end

_G.AceAntiBypassStart = _G.AceStartAntiBypassAimbot
_G.AceAntiBypassStop  = _G.AceStopAntiBypassAimbot

function enableBatV2()
    selectedAimbotMode = "Bat Bypass"
    local ok = _G.AceStartAntiBypassAimbot()
    if ok ~= false then
        autoBatV2Enabled = true
        if autoBatV2SetVisual then autoBatV2SetVisual(true) end
        if batV2FloatingButton then
            local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
            if btnFrame then paintFloatingBtn(btnFrame, true) end
        end
    end
end

function disableBatV2()
    _G.AceStopAntiBypassAimbot()
    autoBatV2Enabled = false
    if autoBatV2SetVisual then autoBatV2SetVisual(false) end
    if batV2FloatingButton then
        local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, false) end
    end
end

function toggleBatV2()
    if autoBatV2Enabled then disableBatV2() else enableBatV2() end
end

_G.AceAntiBypassSaveToConfig = function(t)
    t = t or {}
    t.selectedAimbotMode              = selectedAimbotMode
    t.ANTI_BYPASS_AIMBOT_SPEED        = _G.AceAntiBypassAimbotSpeed
    t.ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AceAntiBypassLaggerAimbotSpeed
    t.antiBypassAimbotEnabled         = _G.AceAntiBypassAimbotOn == true
    return t
end

_G.AceAntiBypassLoadFromConfig = function(data)
    if type(data) ~= "table" then return end
    selectedAimbotMode = data.selectedAimbotMode or selectedAimbotMode
    -- Migración de configs antiguas "Anti Bypass" → "Bat Bypass"
    if selectedAimbotMode == "Anti Bypass" then
        selectedAimbotMode = "Bat Bypass"
    end
    if selectedAimbotMode ~= "Bat Bypass" then
        selectedAimbotMode = "Normal"
    end
    _G.AceAntiBypassAimbotSpeed =
        math.clamp(tonumber(data.ANTI_BYPASS_AIMBOT_SPEED) or _G.AceAntiBypassAimbotSpeed or 55, 1, 60)

    if data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil
       or tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58 then
        _G.AceAntiBypassLaggerAimbotSpeed = 40
    else
        _G.AceAntiBypassLaggerAimbotSpeed =
            tonumber(data.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
    end

    _G.AceAntiBypassAimbotOn = data.antiBypassAimbotEnabled == true
end

-- ═══════════════════════════════════════════════════════════════
end)

local CLOVER_BRANDING = "WHITE HUB"
local function addCloverBranding(parent, position, size, textSize)
if not parent then
return nil
end
local existing = parent:FindFirstChild("CloverBranding")
if existing then
return existing
end
local label = Instance.new("TextLabel")
label.Name = "CloverBranding"
label.Parent = parent
label.Size = size or UDim2.new(1, -16, 0, 16)
label.Position = position or UDim2.new(0, 8, 1, -20)
label.BackgroundTransparency = 1
label.Text = "WHITE HUB"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextTransparency = 0
label.Font = Enum.Font.GothamBlack
label.TextSize = math.max(6, math.floor((textSize or 10) * 0.8))
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.TextStrokeTransparency = 0
label.ZIndex = 999
return label
end
local function makeCloverIcon(parent, pixelSize, zIndex)
local z = zIndex or 5
local holder = Instance.new("Frame")
holder.Name = "CloverIcon"
holder.AnchorPoint = Vector2.new(0.5, 0.5)
holder.Size = UDim2.fromOffset(100, 100)
holder.BackgroundTransparency = 1
holder.ZIndex = z
local iconScale = Instance.new("UIScale", holder)
iconScale.Scale = (pixelSize or 100) / 100
local leafColor = Color3.fromRGB(255, 255, 255)
local stemColor = Color3.fromRGB(0, 0, 0)
local a = 30
local d = a / math.sqrt(2)
local function piece(group, w, h, cx, cy, rot, round, color, zi)
local f = Instance.new("Frame", group)
f.AnchorPoint = Vector2.new(0.5, 0.5)
f.Size = UDim2.fromOffset(w, h)
f.Position = UDim2.fromOffset(50 + cx, 50 + cy)
f.Rotation = rot
f.BackgroundColor3 = color
f.BorderSizePixel = 0
f.ZIndex = zi
if round then
Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
end
return f
end
piece(holder, 6, 50, 17, 17, -45, true, stemColor, z)
for i = 0, 3 do
local group = Instance.new("Frame", holder)
group.Name = "Leaf" .. i
group.BackgroundTransparency = 1
group.Size = UDim2.fromOffset(100, 100)
group.Rotation = i * 90
group.ZIndex = z + 1
piece(group, a, a, 0, -d, 45, false, leafColor, z + 1)
piece(group, a, a, -d / 2, -1.5 * d, 0, true, leafColor, z + 1)
piece(group, a, a, d / 2, -1.5 * d, 0, true, leafColor, z + 1)
end
local core = piece(holder, 8, 8, 0, 0, 0, true, Color3.fromRGB(255, 255, 255), z + 2)
holder.Parent = parent
return holder
end
do
local ReplicatedStorage
do
local introTweenService, introRunService, introPlayer, introTrack, introSongFileName, introSound, introHeartbeatConnection
if _G.CloverHubRunning then
return
end
_G.CloverHubRunning = true
repeat
task.wait()
until game:IsLoaded()
do
local introPlayersService = game:GetService("Players")
introTweenService = game:GetService("TweenService")
introRunService = game:GetService("RunService")
introPlayer = introPlayersService.LocalPlayer
end
introSongIds = {
"https://files.catbox.moe/vbyghu.mp3",
"https://files.catbox.moe/5g2wg1.mp3",
"https://files.catbox.moe/r29x0i.mp3",
"https://files.catbox.moe/n53amf.mp3",
"https://files.catbox.moe/o4di3j.mp3",
"https://files.catbox.moe/um4hgp.mp3",
"https://files.catbox.moe/fiiu4a.mp3",
"https://files.catbox.moe/mdjmee.mp3",
"https://files.catbox.moe/2eysnf.mp3",
"https://files.catbox.moe/d4uky5.mp3",
"https://files.catbox.moe/8v5xra.mp3",
"https://files.catbox.moe/aneanv.mp3",
"https://files.catbox.moe/pm6lne.mp3",
"https://files.catbox.moe/y4q5y3.mp3",
"https://files.catbox.moe/pcdvty.mp3",
"rbxassetid://78658486161852",
"rbxassetid://96414211708215",
"rbxassetid://82746224492420",
"rbxassetid://110919391228823",
"rbxassetid://71393805905055",
"rbxassetid://91007045451630",
"https://files.catbox.moe/zuid5n.mp3",
"https://files.catbox.moe/z6eqnt.mp3",
"https://files.catbox.moe/t0nlhv.mp3",
"https://files.catbox.moe/mthg31.mp3",
"https://files.catbox.moe/ddnbup.mp3",
"https://files.catbox.moe/hg5cr4.mp3",
"https://files.catbox.moe/nps6gk.mp3",
"https://files.catbox.moe/iyw1cb.mp3",
"https://files.catbox.moe/2w0wtv.mp3"
}
currentIntroSongIndex = 1
pcall(function()
if isfile and readfile and isfile("CloverHub.json") then
local settingsData = game:GetService("HttpService"):JSONDecode(readfile("CloverHub.json"))
if type(settingsData.cloverHubSongIndex) == "number" then
local songCount = #introSongIds
currentIntroSongIndex = math.clamp(math.floor(settingsData.cloverHubSongIndex), 1, songCount)
end
end
end)
introTrack = introSongIds[currentIntroSongIndex]
introSongFileName = "cloverhub_intro_song_" .. currentIntroSongIndex .. ".mp3"
introSound = nil
introHeartbeatConnection = nil
do
local introGuiParents = {}
local CoreGui = game:GetService("CoreGui")
local playerGui = introPlayer and introPlayer:FindFirstChildOfClass("PlayerGui")
introGuiParents[1] = CoreGui
introGuiParents[2] = playerGui
for _, guiParent in ipairs(introGuiParents) do
guiParent = guiParent and guiParent:FindFirstChild("CleanLettersIntro")
if guiParent then
guiParent:Destroy()
end
end
end
do
local introGui, introClosed, closeIntro
introGui = Instance.new("ScreenGui")
introGui.Name = "CleanLettersIntro"
introGui.IgnoreGuiInset = true
introGui.ResetOnSpawn = false
introGui.DisplayOrder = 100000
introGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
addCloverBranding(introGui, UDim2.new(0, 0, 0, 18), UDim2.new(1, 0, 0, 34), 20)
pcall(function()
if syn and syn.protect_gui then
syn.protect_gui(introGui)
end
end)
if not pcall(function()
introGui.Parent = game:GetService("CoreGui")
end) then
introGui.Parent = introPlayer:WaitForChild("PlayerGui")
end
do
introClosed = false
local fadeables = {}
local title = Instance.new("TextLabel", introGui)
title.Name = "Title"
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Size = UDim2.fromOffset(700, 124)
title.Position = UDim2.new(0.5, 0, 0.5, 12)
title.BackgroundTransparency = 1
title.Text = "WHITE HUB"
title.Font = Enum.Font.GothamBlack
title.TextSize = 88
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.ZIndex = 5
local titleGradient = Instance.new("UIGradient", title)
titleGradient.Rotation = 90
titleGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.48, Color3.fromRGB(190, 205, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(112, 125, 255)),
})
local titleStroke = Instance.new("UIStroke", title)
titleStroke.Thickness = 3.5
titleStroke.Color = Color3.fromRGB(8, 10, 22)
titleStroke.Transparency = 1
local titleScale = Instance.new("UIScale", title)
titleScale.Scale = 0.85
introTweenService:Create(title, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
introTweenService:Create(titleStroke, TweenInfo.new(0.55), { Transparency = 0 }):Play()
introTweenService:Create(titleScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
local line = Instance.new("Frame", introGui)
line.Name = "Line"
line.AnchorPoint = Vector2.new(0.5, 0.5)
line.Size = UDim2.fromOffset(0, 4)
line.Position = UDim2.new(0.5, 0, 0.5, 84)
line.BackgroundColor3 = Color3.fromRGB(150, 165, 255)
line.BorderSizePixel = 0
line.ZIndex = 5
Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
introTweenService:Create(line, TweenInfo.new(2.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Size = UDim2.fromOffset(260, 3) }):Play()
local tagline = Instance.new("TextLabel", introGui)
tagline.Name = "Tagline"
tagline.AnchorPoint = Vector2.new(0.5, 0.5)
tagline.Size = UDim2.fromOffset(700, 52)
tagline.Position = UDim2.new(0.5, 0, 1, -42)
tagline.BackgroundTransparency = 1
tagline.Text = "MADE BY DOUÈ AND WHITE"
tagline.Font = Enum.Font.GothamBlack
tagline.TextSize = 23
tagline.TextColor3 = Color3.fromRGB(255, 255, 255)
tagline.TextTransparency = 0
tagline.ZIndex = 5
task.delay(0.8, function()
if tagline.Parent then
introTweenService:Create(tagline, TweenInfo.new(0.4), { TextTransparency = 0 }):Play()
end
end)
closeIntro = function()
if introClosed then
return
end
introClosed = true
local fade = TweenInfo.new(0.3)
pcall(function()
introTweenService:Create(title, fade, { TextTransparency = 1 }):Play()
introTweenService:Create(titleStroke, fade, { Transparency = 1 }):Play()
introTweenService:Create(line, fade, { BackgroundTransparency = 1 }):Play()
introTweenService:Create(tagline, fade, { TextTransparency = 1 }):Play()
end)
task.delay(0.35, function()
if introGui then
introGui:Destroy()
end
end)
end
local skipButton = Instance.new("TextButton", introGui)
skipButton.Size = UDim2.fromScale(1, 1)
skipButton.BackgroundTransparency = 1
skipButton.Text = ""
skipButton.BorderSizePixel = 0
skipButton.AutoButtonColor = false
skipButton.ZIndex = 10
skipButton.Activated:Connect(closeIntro)
task.delay(2.8, closeIntro)
task.spawn(function()
local function resolveAssetPath(filePath)
for _, entry in ipairs({
getcustomasset,
getsynasset,
getasset,
}) do
if typeof(entry) == "function" then
local ok, result = pcall(function()
return entry(filePath)
end)
if ok and type(result) == "string" and result ~= "" then
return result
end
end
end
return nil
end
local soundAssetId = nil
-- Support rbxassetid directly for intro
if type(introTrack) == "string" and (introTrack:find("rbxassetid") or tonumber(introTrack)) then
 if tonumber(introTrack) then soundAssetId = "rbxassetid://"..introTrack else soundAssetId = introTrack end
else
 soundAssetId = resolveAssetPath(introSongFileName)
 if not soundAssetId and isfile and isfile(introSongFileName) then
  soundAssetId = resolveAssetPath(introSongFileName)
 end
end
if not soundAssetId and writefile and not (type(introTrack)=="string" and introTrack:find("rbxassetid")) then
local ok, result = pcall(function()
return game:HttpGet(introTrack)
end)
if ok and type(result) == "string" and #result > 100 and pcall(function()
writefile(introSongFileName, result)
end) then
soundAssetId = resolveAssetPath(introSongFileName)
end
end
if not soundAssetId then
return
end
introSound = Instance.new("Sound")
introSound.Name = "CleanIntroSong"
introSound.SoundId = soundAssetId
introSound.Volume = 1
introSound.Looped = false
introSound.Parent = game:GetService("SoundService")
pcall(function()
introSound:Play()
end)
-- the music keeps playing after the intro screen closes, for up to 10 seconds total
task.wait(9.2)
local sound = introSound
if sound and sound.Parent then
pcall(function()
introTweenService:Create(sound, TweenInfo.new(0.8), { Volume = 0 }):Play()
end)
task.wait(0.8)
pcall(function()
sound:Stop()
sound:Destroy()
end)
end
end)
while not introClosed do
task.wait(0.05)
end
end
end
end
do
local raycastParams
task.wait(0.4)
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
Lighting = game:GetService("Lighting")
HttpService = game:GetService("HttpService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Workspace = game:GetService("Workspace")
localPlayer = Players.LocalPlayer
currentCamera = workspace.CurrentCamera
getTime = tick
clamp = math.clamp
floor = math.floor
huge = math.huge
sqrt = math.sqrt
newVector3 = Vector3.new
zeroVector = Vector3.zero
newCFrame = CFrame.new
lookAtCFrame = CFrame.lookAt
raycastParams = RaycastParams.new
do
local players = nil
local playerCacheTime = 0
getPlayersCached = function()
local now = getTime()
if players and now - playerCacheTime < 0.03 then
return players
end
players = Players:GetPlayers()
playerCacheTime = now
return players
end
end
waitForCharacterReady = function(character, timeout)
local waitDuration = timeout or 5
local deadline = getTime() + waitDuration
while
not character
or not character.Parent
or not character:FindFirstChild("HumanoidRootPart")
or not character:FindFirstChildOfClass("Humanoid")
do
if deadline < getTime() then
return false
end
task.wait(0.05)
end
return true
end
NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 55
-- NewBatAimbot will pick this up via BAT_AIMBOT_CONFIG.chaseSpeed = BAT_AIMBOT_SPEED
BYPASS_AIMBOT_SPEED = 60
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 372
CONFIG_FILE = "CloverHub.json"
BAT_V2_HIT_DIST = 4.5

-- ═══════════════════════════════════════════════════════════════════════════
-- NEW BAT AIMBOT (Anti-Bat Bypass Edition) - Position history velocity tracking
-- Replaces old Auto Bat / Bat Bypass / Bat Aimbot systems
-- ═══════════════════════════════════════════════════════════════════════════
local BatAimbotState = {
    enabled = false,
    hittingCooldown = false,
}

local BAT_AIMBOT_CONFIG = { -- PATCHED FRONT MODE
    chaseSpeed       = 55, -- FAST FRONT -- updated live from BAT_AIMBOT_SPEED
    aimHeight        = 3.7,
    yBoost           = 19.5,
    yVelY            = 0.8,
    minJumpY         = 13,
    yClamp           = Vector2.new(-70, 110),
    lerpAlpha        = 0.92,
    predictLead      = 0.14,
    lookAheadOffset  = 3.8, -- IN FRONT
    tiltSpeed        = 72,
    swingCooldown    = 0.02, -- FAST
    velTrackClamp    = 150,
    velSpoofMag      = 250,
    velSpoofDiffBase = 80,
    velTrackSamples  = 6,
    velSmooth        = 0.5,
}

local BatVTrack = { records = {} }
local batAimbotConn = nil

local function batFindBat()
    local char = localPlayer.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("bat") or n:find("slap") then return tool end
        end
    end
    local bp = localPlayer:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat") or n:find("slap") then return tool end
            end
        end
    end
    return nil
end

local function batGetClosestTarget()
    local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum   = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < minDist then minDist = d; closest = tRoot end
            end
        end
    end
    return closest
end

local function batGetTrueVelocity(root, now)
    if not root or not root.Parent then return Vector3.zero end
    local rec = BatVTrack.records[root]
    if not rec then
        rec = { s = {}, vel = Vector3.zero, ready = false }
        BatVTrack.records[root] = rec
    end
    local pos  = root.Position
    local last = rec.s[#rec.s]
    if last then
        local dt = now - last.t
        if dt > 1/240 and dt < 0.2 then
            local raw = (pos - last.pos) / dt
            local c   = BAT_AIMBOT_CONFIG.velTrackClamp
            local clamped = Vector3.new(
                math.clamp(raw.X, -c, c),
                math.clamp(raw.Y, -c, c),
                math.clamp(raw.Z, -c, c)
            )
            if rec.ready then
                rec.vel = rec.vel:Lerp(clamped, BAT_AIMBOT_CONFIG.velSmooth)
            else
                rec.vel = clamped
                rec.ready = true
            end
        end
    end
    table.insert(rec.s, { pos = pos, t = now })
    while #rec.s > BAT_AIMBOT_CONFIG.velTrackSamples do table.remove(rec.s, 1) end
    return rec.vel
end

local function batReadVelocity(target, now)
    local raw     = target.AssemblyLinearVelocity
    local tracked = batGetTrueVelocity(target, now)
    if not tracked or tracked.Magnitude < 0.5 then
        if raw.Magnitude > 400 then return Vector3.zero end
        return raw
    end
    local diff = (raw - tracked).Magnitude
    local rawMag, trackMag = raw.Magnitude, tracked.Magnitude
    if rawMag > BAT_AIMBOT_CONFIG.velSpoofMag then return tracked end
    if diff > math.max(BAT_AIMBOT_CONFIG.velSpoofDiffBase, trackMag * 1.5) then return tracked end
    return raw
end

local _batVtLastClean = 0
local function batVTrackCleanup(now)
    if now - _batVtLastClean < 5 then return end
    _batVtLastClean = now
    for r in pairs(BatVTrack.records) do
        if not r.Parent then BatVTrack.records[r] = nil end
    end
end

local function batSwingBat()
    if BatAimbotState.hittingCooldown then return end
    BatAimbotState.hittingCooldown = true
    pcall(function()
        local c = localPlayer.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local tool = batFindBat()
        if tool then
            if tool.Parent ~= c and hum then
                pcall(function() hum:EquipTool(tool) end)
            end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() tool:Activate() end)
            end
        end
    end)
    -- HARDER FRONT: 3 rapid swings
    task.spawn(function()
        for i=1,2 do task.wait(0.018) pcall(function() local c=localPlayer.Character local tool=batFindBat() if tool then local r=tool:FindFirstChildOfClass("RemoteEvent") if r then r:FireServer() else tool:Activate() end end end) end
    end)
    task.delay(BAT_AIMBOT_CONFIG.swingCooldown, function() BatAimbotState.hittingCooldown = false end)
end

local function batStartAimbot()
    if batAimbotConn then batAimbotConn:Disconnect() end
    local hum0 = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    carryController._batAimbotToggled = true
    batAimbotConn = RunService.RenderStepped:Connect(function()
        if not BatAimbotState.enabled then return end
        local char = localPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not hum  then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = batFindBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = batGetClosestTarget()
        if not target then return end
        local now = os.clock()
        batVTrackCleanup(now)
        local targetVel = batReadVelocity(target, now)
        local myPos     = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * BAT_AIMBOT_CONFIG.predictLead
        predictPos = predictPos + target.CFrame.LookVector * BAT_AIMBOT_CONFIG.lookAheadOffset
        local direction = predictPos - myPos
        local flat = Vector3.new(direction.X, 0, direction.Z)
        if flat.Magnitude < 0.001 then return end
        local flatDir = flat.Unit
        local desiredHeight = targetPos.Y + BAT_AIMBOT_CONFIG.aimHeight
        local yVel = (desiredHeight - myPos.Y) * BAT_AIMBOT_CONFIG.yBoost + targetVel.Y * BAT_AIMBOT_CONFIG.yVelY
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, BAT_AIMBOT_CONFIG.minJumpY)
        end
        yVel = math.clamp(yVel, BAT_AIMBOT_CONFIG.yClamp.X, BAT_AIMBOT_CONFIG.yClamp.Y)
        local desiredVel = Vector3.new(
            flatDir.X * BAT_AIMBOT_CONFIG.chaseSpeed,
            yVel,
            flatDir.Z * BAT_AIMBOT_CONFIG.chaseSpeed
        )
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, BAT_AIMBOT_CONFIG.lerpAlpha)
        local speed3     = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict   = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictPos)
            local curCF  = root.CFrame
            local diffCF = curCF:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * BAT_AIMBOT_CONFIG.tiltSpeed, ry * BAT_AIMBOT_CONFIG.tiltSpeed, rz * BAT_AIMBOT_CONFIG.tiltSpeed)
            )
        end
        local dist = (targetPos - myPos).Magnitude
        if dist < 14 then
            batSwingBat()
        end
    end)
end

local function batStopAimbot()
    if batAimbotConn then batAimbotConn:Disconnect(); batAimbotConn = nil end
    BatVTrack.records = {}
    local c = localPlayer.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity  = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
    BatAimbotState.hittingCooldown = false
    carryController._batAimbotToggled = false
end

local function batSetEnabled(on)
    BatAimbotState.enabled = on and true or false
    if BatAimbotState.enabled then
        batStartAimbot()
    else
        batStopAimbot()
    end
end

-- Expose for toggles
_G.NewBatAimbot = {
    setEnabled = batSetEnabled,
    isEnabled = function() return BatAimbotState.enabled end,
    start = batStartAimbot,
    stop = batStopAimbot,
    state = BatAimbotState,
    config = BAT_AIMBOT_CONFIG,
}

print("[CloverHub] New Bat Aimbot (Anti-Bat Bypass) loaded")

-- Keep chase speed in sync with the UI box
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.NewBatAimbot and _G.NewBatAimbot.config and BAT_AIMBOT_SPEED then
            _G.NewBatAimbot.config.chaseSpeed = BAT_AIMBOT_SPEED
        end
    end
end)

_isDraggingButton = false
backgroundIndex = 1
backgroundImageTransparency = 0.55
floatingButtonScale = 1
progressBarScale = 1
_floatingUIScales = {}
carryController = {
normalSpeed = NS,
carrySpeed = CS,
laggerSpeed = LAGGER_SPEED,
laggerCarrySpeed = LAGGER_CARRY_SPEED,
speedToggled = false,
laggerMode = 0,
softStealEnabled = false,
softStealRadius = 10,
softStealSpeed = 30,
softStealLatched = false,
_isCarrying = false,
_lastCarryCheck = 0,
_lvBoost = nil,
_lvAtt = nil,
_blockedTime = 0,
_maxForce = 2200,
_freeForce = 500,
_heartbeatConn = nil,
_softStealScanner = nil,
_softStealAnimals = {},
_softStealScanning = false,
_state = nil,
_dropInProgress = false,
_batAimbotToggled = false,
_rayParams = nil,
_rayFilter = nil,
_rayFilterTime = 0,
isCarrying = function(self)
local now = getTime()
if now - (self._lastCarryCheck or 0) < 0.1 then
return self._isCarrying
end
self._lastCarryCheck = now
local character = localPlayer.Character
if not character then
self._isCarrying = false
return false
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
local walkSpeed = humanoid and humanoid.WalkSpeed or 16
local isCarrying = walkSpeed < 25 and walkSpeed > 0
local ok, result = pcall(function()
return localPlayer:GetAttribute("Stealing")
end)
ok = ok and result == true
local isEnabled = false
if ok then
isEnabled = true
end
local ok2, result2 = pcall(function()
return character:GetAttribute("Stealing")
end)
if ok2 and result2 == true then
isEnabled = true
end
if not isEnabled then
for _, name in ipairs({
"Carrying",
"IsCarrying",
"Grabbed",
"Holding",
"StealHold",
"HasGrab",
}) do
local instance = character:FindFirstChild(name)
if instance then
if
instance:IsA("BoolValue") and instance.Value
or instance:IsA("ObjectValue") and instance.Value
or instance:IsA("StringValue") and instance.Value ~= ""
then
isEnabled = true
break
end
end
end
end
self._isCarrying = isCarrying or isEnabled
return self._isCarrying
end,
getActiveSpeed = function(self)
if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
return self.normalSpeed
end
if self.softStealEnabled then
local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
if distance and distance <= self.softStealRadius then
self.softStealLatched = true
return self.softStealSpeed
end
if self.softStealLatched and self:isCarrying() then
return self.softStealSpeed
end
self.softStealLatched = false
end
if self.laggerMode == 1 then
return self.laggerSpeed
end
if self.laggerMode == 2 then
return self.laggerCarrySpeed
end
if self.speedToggled then
return self.carrySpeed
end
return self.normalSpeed
end,
getStatus = function(self)
if not (self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled)) then
if self.softStealEnabled then
local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
if
distance and distance <= self.softStealRadius
or self.softStealLatched and self:isCarrying()
then
return "AUTO CARRY", self.softStealSpeed
end
end
if self.laggerMode == 1 then
return "LAGGER", self.laggerSpeed
end
if self.laggerMode == 2 then
return "LAGGER CARRY", self.laggerCarrySpeed
end
if self.speedToggled then
return "CARRY", self.carrySpeed
end
return "NORMAL", self.normalSpeed
end
return "NORMAL", self.normalSpeed
end,
}
do
local function destroyLV()
if carryController._lvBoost and carryController._lvBoost.Parent then
pcall(function()
carryController._lvBoost:Destroy()
end)
end
if carryController._lvAtt and carryController._lvAtt.Parent then
pcall(function()
carryController._lvAtt:Destroy()
end)
end
carryController._lvBoost = nil
carryController._lvAtt = nil
end
local function setupLV(parent)
if carryController._lvBoost and carryController._lvBoost.Parent == parent then
return
end
destroyLV()
local attachment = Instance.new("Attachment")
attachment.Parent = parent
local linearVelocity = Instance.new("LinearVelocity")
linearVelocity.Name = "CarryBoostLV"
linearVelocity.Attachment0 = attachment
linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
linearVelocity.PrimaryTangentAxis = newVector3(1, 0, 0)
linearVelocity.SecondaryTangentAxis = newVector3(0, 0, 1)
linearVelocity.MaxForce = carryController._maxForce
linearVelocity.PlaneVelocity = Vector2.zero
linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
linearVelocity.Parent = parent
carryController._lvAtt = attachment
carryController._lvBoost = linearVelocity
pcall(function()
parent:SetNetworkOwner(localPlayer)
end)
end
carryController.scanSoftStealAnimals = function(self)
self._softStealAnimals = {}
local plots = Workspace:FindFirstChild("Plots")
if not plots then
return
end
for _, child in ipairs(plots:GetChildren()) do
if child:IsA("Model") then
local animalPodiums = child:FindFirstChild("AnimalPodiums")
if animalPodiums then
for _, child2 in ipairs(animalPodiums:GetChildren()) do
if child2:IsA("Model") then
local base = child2:FindFirstChild("Base")
base = base and base:FindFirstChild("Spawn")
if base then
table.insert(self._softStealAnimals, {
plot = child.Name,
slot = child2.Name,
worldPosition = base.Position,
uid = child.Name .. "_" .. child2.Name,
})
end
end
end
end
end
end
end
carryController.startSoftStealScanner = function(callback)
if callback._softStealScanner then
return
end
callback._softStealScanning = true
callback:scanSoftStealAnimals()
local scanAcc = 0
callback._softStealScanner = RunService.Heartbeat:Connect(function(dt)
if not callback._softStealScanning then
return
end
scanAcc += dt
if scanAcc < 0.2 then
return
end
scanAcc = 0
callback:scanSoftStealAnimals()
end)
end
carryController.stopSoftStealScanner = function(self)
self._softStealScanning = false
if self._softStealScanner then
self._softStealScanner:Disconnect()
self._softStealScanner = nil
end
end
carryController.getNearestSoftStealAnimal = function(self, radius)
local character = localPlayer.Character
if character then
character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
end
if not character then
return nil, huge
end
local softStealAnimals = self._softStealAnimals
local position = character.Position
local bestDistance = huge
local animals = nil
for i = 1, #softStealAnimals do
local rootPart = softStealAnimals[i]
if rootPart.worldPosition then
local dx = position.X - rootPart.worldPosition.X
local dy = position.Y - rootPart.worldPosition.Y
local dz = position.Z - rootPart.worldPosition.Z
local distance = sqrt(dx * dx + dy * dy + dz * dz)
if distance < bestDistance then
bestDistance = distance
animals = rootPart
end
end
end
if radius and bestDistance > radius then
return nil, bestDistance
end
return animals, bestDistance
end
carryController.updateMovement = function(self, deltaTime)
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not humanoid then
return
end
local targetSpeed = self:getActiveSpeed()
local moveDirection = humanoid.MoveDirection
local moving = moveDirection.Magnitude > 0.1
local stepTime = clamp(deltaTime or 0.016, 0.001, 0.1)
local nowT = getTime()
local currentPos = humanoidRootPart.Position
local flatPos = newVector3(currentPos.X, 0, currentPos.Z)
-- lag-back detection: if the server snapped us backwards, drop to the
-- normal speed for a moment and ramp back up instead of fighting it
if self._lastFlatPos and moving then
local snap = flatPos - self._lastFlatPos
local flatDir = newVector3(moveDirection.X, 0, moveDirection.Z)
if snap.Magnitude > 6 and snap:Dot(flatDir) < 0 then
self._rubberbandUntil = nowT + 0.5
self._curSpeed = math.min(self._curSpeed or targetSpeed, self.normalSpeed)
end
end
self._lastFlatPos = flatPos
if nowT < (self._rubberbandUntil or 0) then
targetSpeed = math.min(targetSpeed, self.normalSpeed)
end
-- smooth speed ramp (no instant jump from walking pace to full speed)
local rampSpeed = self._curSpeed or math.min(targetSpeed, self.normalSpeed)
if not moving then
rampSpeed = math.min(rampSpeed, math.min(targetSpeed, self.normalSpeed))
elseif rampSpeed < targetSpeed then
rampSpeed = math.min(targetSpeed, rampSpeed + 120 * stepTime)
elseif rampSpeed > targetSpeed then
rampSpeed = math.max(targetSpeed, rampSpeed - 250 * stepTime)
end
self._curSpeed = rampSpeed
local speed = rampSpeed
local unit = nil
if moving then
if not self._rayParams then
self._rayParams = raycastParams()
self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
self._rayFilter = {}
self._rayFilterTime = 0
end
local now = getTime()
if now - self._rayFilterTime > 1 then
self._rayFilterTime = now
local rayFilter = self._rayFilter
while #rayFilter > 0 do
rayFilter[#rayFilter] = nil
end
rayFilter[1] = character
local plist = getPlayersCached()
for i = 1, #plist do
local p = plist[i]
if p.Character then
rayFilter[#rayFilter + 1] = p.Character
end
end
self._rayParams.FilterDescendantsInstances = rayFilter
else
local rayFilter = self._rayFilter
local found = false
for i = 1, #rayFilter do
if rayFilter[i] == character then
found = true
break
end
end
if not found then
rayFilter[1] = character
self._rayParams.FilterDescendantsInstances = rayFilter
end
end
local unit2 = newVector3(moveDirection.X, 0, moveDirection.Z).Unit
local rayParams = self._rayParams
local hit =
Workspace:Raycast(humanoidRootPart.Position + newVector3(0, 1, 0), unit2 * 2.5, rayParams)
local canCollide = hit and hit.Instance and hit.Instance.CanCollide
unit = nil
if canCollide then
local nf = newVector3(hit.Normal.X, 0, hit.Normal.Z)
unit = nil
if nf.Magnitude > 0.7 then
unit = nf.Unit
end
end
end
local hVelocity =
newVector3(humanoidRootPart.AssemblyLinearVelocity.X, 0, humanoidRootPart.AssemblyLinearVelocity.Z)
local blocked = unit ~= nil or moving and hVelocity.Magnitude < 2
if blocked and (nowT - (self._lastNoclipPass or 0)) > 0.25 then
self._lastNoclipPass = nowT
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Model") then
for _, descendant in ipairs(child:GetDescendants()) do
if descendant:IsA("BasePart") and descendant.CanCollide then
descendant.CanCollide = false
end
end
end
end
for _, name in ipairs({
"Carrying",
"IsCarrying",
"Grabbed",
"Holding",
"StealHold",
"HasGrab",
}) do
local instance = character:FindFirstChild(name)
if
instance
and instance:IsA("ObjectValue")
and instance.Value
and instance.Value:IsA("Model")
then
for _, descendant in ipairs(instance.Value:GetDescendants()) do
if descendant:IsA("BasePart") and descendant.CanCollide then
descendant.CanCollide = false
end
end
end
end
end
local state = humanoid:GetState()
if
not (
state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
or self._dropInProgress
or self._batAimbotToggled
)
then
if not carryController._lvBoost or carryController._lvBoost.Parent ~= humanoidRootPart then
setupLV(humanoidRootPart)
end
local lvBoost = carryController._lvBoost
if lvBoost then
if not lvBoost.Enabled then
lvBoost.Enabled = true
end
if 0.1 < moveDirection.Magnitude then
local unit2 = newVector3(moveDirection.X, 0, moveDirection.Z).Unit
if unit then
local wanted = unit2 * speed
local along = wanted - unit * wanted:Dot(unit)
if along.Magnitude < 0.5 then
lvBoost.PlaneVelocity = Vector2.zero
else
lvBoost.PlaneVelocity = Vector2.new(along.X, along.Z)
end
else
lvBoost.PlaneVelocity = Vector2.new(unit2.X * speed, unit2.Z * speed)
end
-- also drive the velocity directly (same method the normal speed uses);
-- the force-limited constraint alone can be too weak to beat the
-- humanoid's own walking and leaves the speed unchanged
local pv = lvBoost.PlaneVelocity
local curVel = humanoidRootPart.AssemblyLinearVelocity
humanoidRootPart.AssemblyLinearVelocity = newVector3(pv.X, curVel.Y, pv.Y)
else
lvBoost.PlaneVelocity = Vector2.zero
end
if blocked then
self._blockedTime = self._blockedTime + (deltaTime or 0.016)
else
self._blockedTime = 0
end
if self._blockedTime > 0.35 then
if lvBoost.MaxForce ~= self._freeForce then
lvBoost.MaxForce = self._freeForce
end
elseif lvBoost.MaxForce ~= self._maxForce then
lvBoost.MaxForce = self._maxForce
end
end
elseif carryController._lvBoost then
carryController._lvBoost.PlaneVelocity = Vector2.zero
if carryController._lvBoost.Enabled then
carryController._lvBoost.Enabled = false
end
end
end
carryController.start = function(deltaTime236)
if deltaTime236._heartbeatConn then
return
end
deltaTime236._heartbeatConn = RunService.Heartbeat:Connect(function(deltaTime)
deltaTime236:updateMovement(deltaTime)
end)
if deltaTime236.softStealEnabled then
deltaTime236:startSoftStealScanner()
end
print("[CarrySystem] Activado")
end
carryController.stop = function(self)
if self._heartbeatConn then
self._heartbeatConn:Disconnect()
self._heartbeatConn = nil
end
self:stopSoftStealScanner()
destroyLV()
self.softStealLatched = false
print("[CarrySystem] Desactivado")
end
end
end
carryController.setNormalSpeed = function(self, value)
self.normalSpeed = clamp(value, 1, 500)
end
carryController.setCarrySpeed = function(self, value)
self.carrySpeed = clamp(value, 1, 500)
end
carryController.setLaggerSpeed = function(self, value)
self.laggerSpeed = clamp(value, 0.1, 500)
end
carryController.setLaggerCarrySpeed = function(self, value)
self.laggerCarrySpeed = clamp(value, 0.1, 500)
end
carryController.setSoftStealSpeed = function(self, value)
self.softStealSpeed = clamp(value, 1, 500)
end
carryController.setSoftStealRadius = function(self, value)
self.softStealRadius = clamp(value, 1, 200)
end
carryController.toggleCarryMode = function(self)
self.speedToggled = not self.speedToggled
end
carryController.setLaggerMode = function(self, mode)
if mode == 0 then
self.laggerMode = 0
elseif mode == 1 then
self.laggerMode = 1
elseif mode == 2 then
self.laggerMode = 2
end
end
carryController.toggleLaggerMode = function(self)
if self.laggerMode == 0 then
self.laggerMode = 1
elseif self.laggerMode == 1 then
self.laggerMode = 2
else
self.laggerMode = 0
end
end
carryController.setSoftStealEnabled = function(self, softStealEnabled)
self.softStealEnabled = softStealEnabled
if softStealEnabled then
self:startSoftStealScanner()
else
self:stopSoftStealScanner()
self.softStealLatched = false
end
end
carryController.toggleSoftSteal = function(self)
self:setSoftStealEnabled(not self.softStealEnabled)
end
carryController.isRunning = function(self)
return self._heartbeatConn ~= nil
end
carryController.getCurrentSpeed = function(self)
return self:getActiveSpeed()
end
colorThemes = {
Gris = Color3.fromRGB(0, 0, 0),
}
currentColorTheme = "Gris"
selectedColor = colorThemes["Gris"]
getThemeColor = function()
return selectedColor
end
do
local object = 0
local object266 = nil
applyColorTheme = function(themeName)
local color = colorThemes[themeName]
if not color then
return
end
currentColorTheme = themeName
selectedColor = color
updateAllUIThemeColors(color)
saveAllSettings()
end
updateAllUIThemeColors = function(color)
local time = getTime()
if color == object266 and time - object < 0.1 then
return
end
object = time
object266 = color
if progressFill then
progressFill.BackgroundColor3 = color
local fillStroke = progressFill:FindFirstChild("FillStroke")
if fillStroke then
fillStroke.Color = color
end
local uiGradient = progressFill:FindFirstChildOfClass("UIGradient")
if uiGradient then
local data = {}
local object = ColorSequenceKeypoint.new(0, color:Lerp(Color3.new(0, 0, 0), 0.28))
local object282 = ColorSequenceKeypoint.new(0.5, color)
data[1] = object
data[2] = object282
data[3] = ColorSequenceKeypoint.new(1, color:Lerp(Color3.new(1, 1, 1), 0.10))
uiGradient.Color = ColorSequence.new(data)
end
end
if pbFrame then
local progressRow = pbFrame:FindFirstChild("ProgressRow")
if progressRow then
local fillRegion = progressRow:FindFirstChild("FillRegion")
if fillRegion then
local uIStroke = fillRegion:FindFirstChild("UIStroke")
if uIStroke then
uIStroke.Color = color
end
end
end
local discordLabel = pbFrame:FindFirstChild("DiscordLabel")
if discordLabel then
discordLabel.TextColor3 = color
end
local textLabel = pbFrame:FindFirstChild("FPSNeon")
if textLabel then
textLabel.TextColor3 = color
end
end
local function searchAndUpdateText(parent)
for _, descendant in ipairs(parent:GetDescendants()) do
if descendant:IsA("TextLabel") then
if
descendant.Text:find("discord.gg")
or descendant.Text:find("Spd:")
or descendant.Name == "DiscordText"
or descendant.Name == "CloverHubSpeedIndicator"
or descendant.Text:find("FPS")
or descendant.Text:find("speed")
then
descendant.TextColor3 = color
end
end
if descendant:IsA("UIStroke") then
if
descendant.Color == Color3.fromRGB(0, 0, 0)
or descendant.Color == Color3.fromRGB(0, 0, 0)
then
descendant.Color = color
end
end
end
end
if gui then
searchAndUpdateText(gui)
end
if tpBatFloatingButton then
local object = batDesyncTpEnabled
paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), object)
end
if batV2FloatingButton then
local object = autoBatV2Enabled
paintFloatingBtn(batV2FloatingButton:FindFirstChild("Frame"), object)
end
local data = tabButtons or {}
for _, label in ipairs(data) do
if
label.TextColor3 == Color3.fromRGB(0, 0, 0)
or label.TextColor3 == Color3.fromRGB(0, 0, 0)
then
label.TextColor3 = color
end
end
for _, entry in pairs(espHighlightCache) do
if entry then
entry.FillColor = color
entry.OutlineColor = color
end
end
for _, entry304 in pairs(espTracerCache) do
if entry304 then
for _, entry in ipairs(entry304) do
if entry then
entry.Color = color
end
end
end
end
for _, entry309 in pairs(espBillboardCache) do
if entry309 then
local imageLabel = entry309:FindFirstChildOfClass("ImageLabel")
if imageLabel then
local uIStroke = imageLabel:FindFirstChildOfClass("UIStroke")
if uIStroke then
uIStroke.Color = color
end
end
end
end
if main then
local titleFrame = main:FindFirstChild("TitleFrame")
if titleFrame then
for _, descendant in ipairs(titleFrame:GetDescendants()) do
if
descendant:IsA("UIStroke")
and (
descendant.Color == Color3.fromRGB(0, 0, 0)
or descendant.Color == Color3.fromRGB(0, 0, 0)
)
then
descendant.Color = color
end
end
end
end
if miniBtn then
miniBtn.TextColor3 = color
end
local playerGui = localPlayer:FindFirstChild("PlayerGui")
if playerGui then
local ragCountdownBillboard = playerGui:FindFirstChild("RagCountdownBillboard")
if ragCountdownBillboard then
local textLabel = ragCountdownBillboard:FindFirstChildOfClass("TextLabel")
if textLabel then
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
local uiGradient = textLabel:FindFirstChildOfClass("UIGradient")
if uiGradient then
local gradientKeypoints = {}
local gradientStart = ColorSequenceKeypoint.new(0, color)
local gradientHighlightStart = ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1))
local gradientHighlightEnd = ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1))
local gradientEnd = ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1))
gradientKeypoints[1] = gradientStart
gradientKeypoints[2] = gradientHighlightStart
gradientKeypoints[3] = gradientHighlightEnd
gradientKeypoints[4] = gradientEnd
gradientKeypoints[5] = ColorSequenceKeypoint.new(1, color)
uiGradient.Color = ColorSequence.new(gradientKeypoints)
end
end
end
end
if MobilePanel then
local floatingPanel = MobilePanel:FindFirstChild("FloatingPanel")
if floatingPanel then
local buttonsContainer = floatingPanel:FindFirstChild("ButtonsContainer")
if buttonsContainer then
for _, child in ipairs(buttonsContainer:GetChildren()) do
if child:IsA("TextButton") and child:FindFirstChild("BtnGrad") then
paintFloatingBtn(child, child:GetAttribute("MobActive") == true)
end
end
end
end
end
end
end
local getAutoStealDuration, getPlotsRoot
do
local outfitAssets = {
V1 = {
shirt = 123181702116947,
pants = 93330291631062,
hair = 140188532534398,
},
V2 = {
shirt = 101796619834594,
pants = 18975891159,
hair = 115520061093937,
},
V3 = {
shirt = 6361021759,
pants = 5414143509,
hair = 8349240186,
},
}
local function toAssetUrl(assetId)
return "http://www.roblox.com/asset/?id=" .. tostring(assetId)
end
local function applyNoOutfit(character)
local character = character or localPlayer.Character
if not character then
return
end
for _, child in ipairs(character:GetChildren()) do
if child.Name:sub(1, 12) == "LocalOutfit_" then
pcall(function()
child:Destroy()
end)
end
end
local oldAcc = character:FindFirstChild("AuFfitAccessory")
if oldAcc then
pcall(function()
oldAcc:Destroy()
end)
end
local oldKorblox = character:FindFirstChild("Korblox_RightLeg")
if oldKorblox then
pcall(function()
oldKorblox:Destroy()
end)
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
pcall(function()
child:Destroy()
end)
end
end
local head = character:FindFirstChild("Head")
if head then
head.Transparency = 0
head.CanCollide = true
head.LocalTransparencyModifier = 0
local face = head:FindFirstChild("face")
if face then
face.Transparency = 0
end
local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
if specialMesh then
pcall(function()
specialMesh:Destroy()
end)
end
end
pcall(function()
local neck = character:FindFirstChild("Neck")
if neck then
neck.Enabled = true
end
end)
for _, partName in ipairs({
"RightUpperLeg",
"RightLowerLeg",
"RightFoot",
}) do
local limb = character:FindFirstChild(partName)
if limb then
limb.Transparency = 0
end
end
local shirt = character:FindFirstChildWhichIsA("Shirt")
if shirt then
pcall(function()
shirt:Destroy()
end)
end
local pants = character:FindFirstChildWhichIsA("Pants")
if pants then
pcall(function()
pants:Destroy()
end)
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Accessory") then
local h = child:FindFirstChild("Handle")
if h then
h.Transparency = 0
end
end
end
end
outfits = {}
outfits[1] = {
label = "NO",
customApply = function() end,
}
end
currentOutfitIndex = 1
outfitSelectorLabel = nil
BACKGROUND_IMAGES = {
    { label = "None",    id = "",                                      overlay = "", theme = "Black", banner = "" },
    { label = "Image 1", id = "https://files.catbox.moe/krffjm.png",   overlay = "", theme = "Dark",  banner = "https://files.catbox.moe/krffjm.png" },
    { label = "Image 2", id = "https://files.catbox.moe/02c8pg.png",   overlay = "", theme = "Dark",  banner = "https://files.catbox.moe/02c8pg.png" },
    { label = "Image 3", id = "https://files.catbox.moe/7lp0nr.png",   overlay = "", theme = "Dark",  banner = "https://files.catbox.moe/7lp0nr.png" },
    { label = "Image 4", id = "https://files.catbox.moe/fmf7m0.png",   overlay = "", theme = "Dark",  banner = "https://files.catbox.moe/fmf7m0.png" },
    { label = "Image 5", id = "https://files.catbox.moe/m001vy.png",   overlay = "", theme = "Dark",  banner = "https://files.catbox.moe/m001vy.png" },
}
backgroundSelectorLabel = nil
backgroundImage = nil
backgroundImagePB = nil
-- Catbox URLs cannot be assigned directly to Roblox ImageLabels. Download them
-- to a local file and convert to a supported custom asset when the executor allows it.
_G.K7HubResolveBackgroundAsset = function(url, index)
if not url or url == "" then return "" end
if string.match(url, "^rbxassetid://") then return url end
local cached = _G.K7HubBackgroundAssetCache or {}
_G.K7HubBackgroundAssetCache = cached
if cached[url] then return cached[url] end
local downloader = (type(game.HttpGet) == "function" and function() return game:HttpGet(url) end) or nil
local writer = (type(writefile) == "function" and writefile) or nil
local assetLoader = (type(getcustomasset) == "function" and getcustomasset)
 or (type(getsynasset) == "function" and getsynasset) or nil
if downloader and writer and assetLoader then
local ok, data = pcall(downloader)
if ok and type(data) == "string" and #data > 0 then
local extension = string.match(url, "%.([%w]+)$") or "png"
local filename = "K7Hub_Background_" .. tostring(index or 1) .. "." .. extension
local wrote = pcall(writer, filename, data)
if wrote then
local assetOk, asset = pcall(assetLoader, filename)
if assetOk and type(asset) == "string" then
cached[url] = asset
return asset
end
end
end
end
warn("[K7 Hub] Could not load background URL as a Roblox image. Your executor must support HttpGet, writefile, and getcustomasset/getsynasset.")
return ""
end

-- Button background image painting (so hub buttons show selected background)
_G.K7HubBtnBgCache = _G.K7HubBtnBgCache or {}
local _btnBgList = _G.K7HubBtnBgCache

local function registerBtnForBg(guiObject)
if not guiObject then return end
for _, b in ipairs(_btnBgList) do
if b == guiObject then return end
end
table.insert(_btnBgList, guiObject)
end

local function paintBtnBgFast(guiObject, assetId, trans)
if not guiObject or not guiObject.Parent then return end
local img = guiObject:FindFirstChild("HubBgImage")
if not assetId or assetId == "" then
if img then img.Visible = false end
return
end
if not img then
img = Instance.new("ImageLabel")
img.Name = "HubBgImage"
img.BackgroundTransparency = 1
img.Size = UDim2.fromScale(1, 1)
img.ScaleType = Enum.ScaleType.Crop
img.ZIndex = 0
img.Parent = guiObject
local corner = guiObject:FindFirstChildOfClass("UICorner")
Instance.new("UICorner", img).CornerRadius = corner and corner.CornerRadius or UDim.new(0, 8)
-- keep text above image
for _, ch in ipairs(guiObject:GetChildren()) do
if ch:IsA("TextLabel") or ch:IsA("TextButton") then
ch.ZIndex = math.max(ch.ZIndex, 2)
end
end
registerBtnForBg(guiObject)
end
if img.Image ~= assetId then
img.Image = assetId
end
img.ImageTransparency = trans or 0.45
img.Visible = true
end

local function refreshAllBtnBackgrounds()
local background = BACKGROUND_IMAGES[backgroundIndex]
if not background then return end
local id = ""
if background.id and background.id ~= "" then
id = _G.K7HubResolveBackgroundAsset(background.id, backgroundIndex) or ""
end
local btnTrans = id ~= "" and math.min((backgroundImageTransparency or 0.55) + 0.05, 0.7) or 1
for i = #_btnBgList, 1, -1 do
local b = _btnBgList[i]
if not b or not b.Parent then
table.remove(_btnBgList, i)
else
paintBtnBgFast(b, id, btnTrans)
end
end
-- discover main hub + floating buttons
pcall(function()
local parents = {}
pcall(function() parents[#parents+1] = game:GetService("CoreGui") end)
local lp = game:GetService("Players").LocalPlayer
if lp then
local pg = lp:FindFirstChild("PlayerGui")
if pg then parents[#parents+1] = pg end
end
for _, parent in ipairs(parents) do
for _, name in ipairs({"CloverHub", "VERIS Songs", "WhiteHub", "K7Hub"}) do
local gui = parent:FindFirstChild(name)
if gui then
for _, child in ipairs(gui:GetDescendants()) do
if child:IsA("TextButton") then
paintBtnBgFast(child, id, btnTrans)
registerBtnForBg(child)
end
end
end
end
end
end)
end

applyBackground = function(index)
backgroundIndex = clamp(index or 1, 1, #BACKGROUND_IMAGES)
local background = BACKGROUND_IMAGES[backgroundIndex]
if not background then
return
end
local id = background.id and _G.K7HubResolveBackgroundAsset(background.id, backgroundIndex) or ""
local transparency = id ~= "" and backgroundImageTransparency or 1
if backgroundImage and backgroundImage.Parent then
backgroundImage.Image = id
backgroundImage.ImageTransparency = transparency
end
if backgroundImagePB and backgroundImagePB.Parent then
backgroundImagePB.Image = id
backgroundImagePB.ImageTransparency = id ~= "" and math.min(transparency + 0.15, 1) or 1
end
if backgroundSelectorLabel then
backgroundSelectorLabel.Text = background.label
end
-- paint buttons with background image
pcall(function()
if refreshAllBtnBackgrounds then refreshAllBtnBackgrounds() end
if _G.WhiteHubRefreshAntiBatPanelBg then _G.WhiteHubRefreshAntiBatPanelBg() end
end)
end
do
local function loadAvatarAsset(assetId)
local ok, result = pcall(function()
return game:GetObjects("rbxassetid://" .. tostring(assetId))
end)
if ok and typeof(result) == "table" and #result > 0 then
return result
end
local ok2, result2 = pcall(function()
return game:GetService("InsertService"):LoadAsset(assetId)
end)
if ok2 and result2 then
return {
result2,
}
end
return nil
end
local function applyHeadlessKorblox(parent)
if not parent then
return
end
pcall(function()
localPlayer.CharacterAvatarType = Enum.AvatarType.R6
end)
local head = parent:FindFirstChild("Head")
if head then
head.Transparency = 1
head.CanCollide = false
head.LocalTransparencyModifier = 1
local face = head:FindFirstChild("face")
if face then
face.Transparency = 1
end
end
pcall(function()
local neck = parent:FindFirstChild("Neck")
if neck then
neck.Enabled = false
end
end)
for _, child in pairs(parent:GetChildren()) do
if child:IsA("Accessory") then
local weld = child:FindFirstChildWhichIsA("Weld")
or child:FindFirstChildWhichIsA("WeldConstraint")
or child:FindFirstChildWhichIsA("Motor6D")
if weld then
local part0 = weld.Part0
local part1 = weld.Part1
if part0 and part0.Name == "Head" or part1 and part1.Name == "Head" then
child.Parent = nil
end
end
end
end
local rightLegConfig = {
id = "rbxassetid://139607718",
targetBodyPart = "RightUpperLeg",
partsToHide = {
"RightUpperLeg",
"RightLowerLeg",
"RightFoot",
},
scale = newVector3(1, 1, 1),
offset = newCFrame(0, 0, 0),
}
local targetPart = parent:FindFirstChild(rightLegConfig.targetBodyPart)
if targetPart then
local oldAsset = parent:FindFirstChild("Korblox_RightLeg")
if oldAsset then
oldAsset:Destroy()
end
for _, partName in ipairs(rightLegConfig.partsToHide) do
local limb = parent:FindFirstChild(partName)
if limb and limb:IsA("BasePart") then
limb.Transparency = 1
end
end
local ok, result = pcall(function()
return game:GetObjects(rightLegConfig.id)
end)
if ok and result and #result > 0 then
local assetModel = result[1]
assetModel.Name = "Korblox_RightLeg"
local isBasePart = assetModel:IsA("BasePart") and assetModel
or assetModel:FindFirstChildWhichIsA("BasePart", true)
if isBasePart then
isBasePart.Size = isBasePart.Size * rightLegConfig.scale
isBasePart.CanCollide = false
isBasePart.CFrame = targetPart.CFrame * rightLegConfig.offset
local weld = Instance.new("WeldConstraint")
weld.Part0 = targetPart
weld.Part1 = isBasePart
weld.Parent = isBasePart
assetModel.Parent = parent
end
end
end
end
AVATAR_PRESETS = {["1"] = {displayName = "1", hats = "1744060292,439945661,1125510,1029025", hair = "", headless = true, korblox = "Right", accessories = {1744060292, 439945661, 1125510, 1029025, 11748356, 8465506143, 11444217173}, clothing = {7424637509, 7689651773}}, ["2"] = {displayName = "2", hats = "74891470", hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842", headless = true, korblox = "Right", accessories = {74891470, 16630147, 6346833550, 6594911228, 6594919952, 6823338112, 7097747842}, clothing = {18423061209, 18423154566}}, ["3"] = {displayName = "3", hats = "215718515,439945661", hair = "7183785281", headless = true, korblox = "Right", accessories = {215718515, 439945661, 7183785281}, clothing = {15998365201, 7689651773}}, ["4"] = {displayName = "4", hats = "10159600649,439946249,17798262442,92482095662016", hair = "139101716417676", headless = true, korblox = "Right", accessories = {10159600649, 439946249, 17798262442, 92482095662016, 139101716417676, 12490213797}, clothing = {18766106994, 13925390578}}, ["5"] = {displayName = "5", hats = "553970961,1744060292", hair = "93268856876777", headless = true, korblox = "Right", accessories = {553970961, 1744060292, 93268856876777}, clothing = {9478068776, 6348682339}}, ["6"] = {hats = "74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427", hair = "126447390530523", headless = true, korblox = "Right", accessories = {74891470, 215718515, 439945661, 1016143686, 1744060292, 10159600649, 89012651581593, 126447390530523}, clothing = {88032876921227, 108259950755140}, displayName = "6"}, ["7"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {9733132546, 101481154733615}, displayName = "7"}, ["8"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {10796276786, 101481154733615}, displayName = "8"}, ["9"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {8844377623, 101481154733615}, displayName = "9"}, ["10"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {16107371158, 101481154733615}, displayName = "10"}, ["11"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {15970848598, 101481154733615}, displayName = "11"}, ["12"] = {hats = "", hair = "111149505826763", headless = false, korblox = "Off", accessories = {111149505826763}, clothing = {8844377623, 101481154733615}, displayName = "12"}, ["13"] = {hats = "17274218093", hair = "", headless = false, korblox = "Off", accessories = {111553288808103, 17274218093, 17387240647}, clothing = {130666125397672, 91321960147976}, displayName = "13"}, ["14"] = {hats = "127788745429250", hair = "", headless = false, korblox = "Off", accessories = {127788745429250, 143803235928952}, clothing = {77038549270215, 16717004839}, displayName = "14"}, ["15"] = {hats = "8261840689", hair = "", headless = true, korblox = "Right", accessories = {8261840689}, clothing = {7884186381, 13063157758}, displayName = "15"}, ["16"] = {hats = "91950080535908", hair = "96954292222783", headless = true, korblox = "Right", accessories = {91950080535908, 96954292222783, 17309352545, 132404403424262}, clothing = {9683332649, 13063157758}, displayName = "16"}, ["17"] = {hats = "10997283529", hair = "", headless = true, korblox = "Off", accessories = {10997283529, 125085889448130, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "17"}, ["18"] = {hats = "125157548394108", hair = "", headless = false, korblox = "Off", accessories = {125157548394108, 123231522991173, 74827642361405, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "18"}, ["19"] = {hats = "136644276218918", hair = "", headless = false, korblox = "Off", accessories = {136644276218918, 132022106987543, 131740907052260, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "19"}, ["20"] = {hats = "119331031817124", hair = "", headless = true, korblox = "Off", accessories = {119331031817124, 84952305140948, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "20"}, ["21"] = {hats = "18902416696", hair = "", headless = true, korblox = "Off", accessories = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702, 115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, clothing = {}, displayName = "21"}, ["22"] = {hats = "13935333090", hair = "", headless = false, korblox = "Off", accessories = {13935333090, 16110951997, 10632503818}, clothing = {}, displayName = "22"}, ["23"] = {hats = "74891470", hair = "", headless = true, korblox = "Off", accessories = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424}, clothing = {}, displayName = "23"}, ["24"] = {hats = "76479271580913", hair = "", headless = true, korblox = "Right", accessories = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718}, clothing = {}, displayName = "24"}, ["25"] = {hats = "", hair = "", headless = false, korblox = "Both", accessories = {70414871864071, 14863917259, 133498027006138, 82277826177074}, clothing = {}, displayName = "25"}, ["26"] = {displayName = "Halloween 1", hats = "", hair = "137816489423089", head = 92670829478194, headless = false, korblox = "Off", accessories = {137816489423089}, clothing = {11411687887, 18509017923}}}
AVATAR_TYPE_CACHE = {}
AVATAR_ORIGINAL_DESC = nil
avatarTypeProps = {
[11] = "Shirt",
[12] = "Pants",
[2] = "GraphicTShirt",
[8] = "HatAccessory",
[41] = "HairAccessory",
[42] = "FaceAccessory",
[43] = "NeckAccessory",
[44] = "ShouldersAccessory",
[45] = "FrontAccessory",
[46] = "BackAccessory",
[47] = "WaistAccessory",
[64] = "TShirtAccessory",
[65] = "ShirtAccessory",
[66] = "PantsAccessory",
[67] = "JacketAccessory",
[68] = "SweaterAccessory",
[69] = "ShortsAccessory",
[70] = "LeftShoeAccessory",
[71] = "RightShoeAccessory",
[72] = "DressSkirtAccessory",
}
avatarAccessoryProps = {
"HatAccessory",
"HairAccessory",
"FaceAccessory",
"NeckAccessory",
"ShouldersAccessory",
"FrontAccessory",
"BackAccessory",
"WaistAccessory",
"ShirtAccessory",
"PantsAccessory",
"JacketAccessory",
"SweaterAccessory",
"ShortsAccessory",
"TShirtAccessory",
"DressSkirtAccessory",
}
addAvatarAsset = function(desc, id)
local assetType = AVATAR_TYPE_CACHE[id]
if assetType == nil then
local ok, info = pcall(function()
return game:GetService("MarketplaceService"):GetProductInfo(id, Enum.InfoType.Asset)
end)
if ok and info then
assetType = info.AssetTypeId
else
assetType = false
end
AVATAR_TYPE_CACHE[id] = assetType
end
if not assetType then
return
end
local prop = avatarTypeProps[tonumber(assetType)]
if not prop then
return
end
if prop == "Shirt" or prop == "Pants" or prop == "GraphicTShirt" then
pcall(function()
desc[prop] = id
end)
return
end
local currentList = ""
pcall(function()
currentList = tostring(desc[prop] or "")
end)
for entry in string.gmatch(currentList, "[^,]+") do
if entry == tostring(id) then
return
end
end
pcall(function()
desc[prop] = (currentList == "" and tostring(id)) or (currentList .. "," .. tostring(id))
end)
end
resetAvatarVisuals = function(character)
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") then
head.Transparency = 0
head.LocalTransparencyModifier = 0
for _, child in ipairs(head:GetChildren()) do
if child:IsA("Decal") or child:IsA("Texture") then
child.Transparency = 0
end
end
end
local oldLeg = character:FindFirstChild("Korblox_RightLeg")
if oldLeg then
oldLeg:Destroy()
end
for _, partName in ipairs({
"RightUpperLeg",
"RightLowerLeg",
"RightFoot",
"Right Leg",
}) do
local limb = character:FindFirstChild(partName)
if limb and limb:IsA("BasePart") then
limb.Transparency = 0
end
end
end
applyAvatarKorblox = function(character)
local target = character:FindFirstChild("RightUpperLeg") or character:FindFirstChild("Right Leg")
if not target then
return
end
for _, partName in ipairs({
"RightUpperLeg",
"RightLowerLeg",
"RightFoot",
"Right Leg",
}) do
local limb = character:FindFirstChild(partName)
if limb and limb:IsA("BasePart") then
limb.Transparency = 1
end
end
local ok, result = pcall(function()
return game:GetObjects("rbxassetid://139607718")
end)
local model = ok and result and result[1]
local part = model and (model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true))
if part then
part.CanCollide = false
part.CastShadow = false
part.CFrame = target.CFrame
local weld = Instance.new("WeldConstraint")
weld.Part0 = target
weld.Part1 = part
weld.Parent = part
model.Name = "Korblox_RightLeg"
model.Parent = character
end
end
loadAvatarItem = function(character, humanoid, id)
local objs = nil
local ok, result = pcall(function()
return game:GetObjects("rbxassetid://" .. tostring(id))
end)
if ok and typeof(result) == "table" and #result > 0 then
objs = result
else
local ok2, result2 = pcall(function()
return game:GetService("InsertService"):LoadAsset(id)
end)
if ok2 and result2 then
objs = {
result2,
}
end
end
if not objs then
return false
end
local added = false
for _, obj in ipairs(objs) do
local items = {}
if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
items = {
obj,
}
else
for _, d in ipairs(obj:GetDescendants()) do
if d:IsA("Accessory") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then
table.insert(items, d)
end
end
end
for _, item in ipairs(items) do
local clone = item:Clone()
if clone:IsA("Accessory") then
clone.Name = "CloverAvatar_" .. clone.Name
pcall(function()
humanoid:AddAccessory(clone)
end)
else
for _, child in ipairs(character:GetChildren()) do
if child.ClassName == clone.ClassName then
child:Destroy()
end
end
clone.Parent = character
end
added = true
end
pcall(function()
obj:Destroy()
end)
end
return added
end
applyAvatarPreset = function(character, preset)
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not humanoid then
return
end
if not AVATAR_ORIGINAL_DESC then
pcall(function()
AVATAR_ORIGINAL_DESC = humanoid:GetAppliedDescription():Clone()
end)
end
local applied = nil
pcall(function()
applied = humanoid:GetAppliedDescription()
end)
local desc = (applied and applied:Clone()) or Instance.new("HumanoidDescription")
for _, prop in ipairs(avatarAccessoryProps) do
pcall(function()
desc[prop] = ""
end)
end
pcall(function()
desc.Shirt = 0
desc.Pants = 0
desc.GraphicTShirt = 0
if preset.head then
desc.Head = preset.head
end
end)
pcall(function()
humanoid:ApplyDescription(desc)
end)
task.wait(0.3)
character = localPlayer.Character or character
humanoid = character:FindFirstChildOfClass("Humanoid") or humanoid
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Accessory") and child.Name:sub(1, 13) == "CloverAvatar_" then
child:Destroy()
end
end
resetAvatarVisuals(character)
local ids = {}
local seen = {}
local function queue(id)
id = tonumber(id)
if id and id > 0 and not seen[id] then
seen[id] = true
table.insert(ids, id)
end
end
for entry in string.gmatch(tostring(preset.hats or ""), "[^,]+") do
queue(entry)
end
for entry in string.gmatch(tostring(preset.hair or ""), "[^,]+") do
queue(entry)
end
for _, id in ipairs(preset.accessories or {}) do
queue(id)
end
for _, id in ipairs(preset.clothing or {}) do
queue(id)
end
for _, id in ipairs(ids) do
local ok = loadAvatarItem(character, humanoid, id)
if not ok then
warn("[Clover] avatar item failed to load: " .. tostring(id))
end
end
if preset.headless then
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") then
head.Transparency = 1
head.LocalTransparencyModifier = 1
for _, child in ipairs(head:GetChildren()) do
if child:IsA("Decal") or child:IsA("Texture") then
child.Transparency = 1
end
end
end
end
if preset.korblox == "Right" or preset.korblox == "Both" then
applyAvatarKorblox(character)
end
end
restoreOriginalAvatar = function(character)
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if not humanoid or not AVATAR_ORIGINAL_DESC then
return
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Accessory") and child.Name:sub(1, 13) == "CloverAvatar_" then
child:Destroy()
end
end
pcall(function()
humanoid:ApplyDescription(AVATAR_ORIGINAL_DESC)
end)
task.wait(0.3)
resetAvatarVisuals(localPlayer.Character or character)
end
outfits[1].customApply = function(character)
task.spawn(restoreOriginalAvatar, character)
end
for i = 1, 26 do
local preset = AVATAR_PRESETS[tostring(i)]
if preset then
local label = preset.displayName
if label == tostring(i) then
label = "Avatar " .. i
end
outfits[#outfits + 1] = {
label = label,
customApply = function(character)
task.spawn(applyAvatarPreset, character, preset)
end,
}
end
end
applyOutfitByIndex = function(index)
local config = outfits[index]
if not config then
return
end
local character = localPlayer.Character
if not character then
return
end
if config.customApply then
config.customApply(character)
if outfitSelectorLabel then
outfitSelectorLabel.Text = config.label
end
return
end
character:WaitForChild("Head", 5)
local head = character:FindFirstChild("Head")
if not head then
return
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
pcall(function()
child:Destroy()
end)
end
end
local done = false
if head:IsA("MeshPart") then
done = pcall(function()
head.MeshId = config.headMesh
if config.headTexture then
head.TextureID = config.headTexture
end
end)
end
if not done then
local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
specialMesh.Parent = head
specialMesh.MeshType = Enum.MeshType.FileMesh
specialMesh.MeshId = config.headMesh
specialMesh.TextureId = config.headTexture or ""
end
if config.shirt then
local shirt = character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
shirt.Name = "Shirt"
shirt.ShirtTemplate = config.shirt
shirt.Parent = character
end
if config.pants then
local pants = character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
pants.Name = "Pants"
pants.PantsTemplate = config.pants
pants.Parent = character
end
local auFfitAccessory = character:FindFirstChild("AuFfitAccessory")
if auFfitAccessory then
auFfitAccessory:Destroy()
end
if config.accessory and head then
local objs = loadAvatarAsset(config.accessory)
if objs then
local basePart = nil
for _, o in ipairs(objs) do
if o:IsA("BasePart") then
basePart = o
break
else
basePart = o:FindFirstChildWhichIsA("BasePart", true)
if not basePart then
basePart = nil
continue
end
end
break
end
if basePart then
local clone = basePart:Clone()
clone.Name = "AuFfitAccessory"
clone.CanCollide = false
clone.Anchored = false
clone.Massless = true
clone.Parent = character
local weld = Instance.new("Weld")
weld.Part0 = head
weld.Part1 = clone
weld.C0 = newCFrame(config.offset)
weld.Parent = clone
end
for _, o in ipairs(objs) do
pcall(function()
o:Destroy()
end)
end
end
end
if config.headlessKorblox then
applyHeadlessKorblox(character)
elseif character then
local head2 = character:FindFirstChild("Head")
if head2 then
head2.Transparency = 0
head2.CanCollide = true
head2.LocalTransparencyModifier = 0
local face = head2:FindFirstChild("face")
if face then
face.Transparency = 0
end
end
pcall(function()
local neck = character:FindFirstChild("Neck")
if neck then
neck.Enabled = true
end
end)
for _, partName in ipairs({
"RightUpperLeg",
"RightLowerLeg",
"RightFoot",
}) do
local limb = character:FindFirstChild(partName)
if limb then
limb.Transparency = 0
end
end
local korbloxRightLeg = character:FindFirstChild("Korblox_RightLeg")
if korbloxRightLeg then
korbloxRightLeg:Destroy()
end
end
if outfitSelectorLabel then
outfitSelectorLabel.Text = config.label
end
end
end
SPIN_BOT_ENABLED = false
SPIN_BOT_SPEED = 50
SPIN_BOT_CONN = nil
SPIN_BOT_STEP_CONN = nil
SPIN_BOT_SAFE_POS = nil
cleanupSpinBot = function()
local character = localPlayer.Character
if not character then
return
end
local root = character:FindFirstChild("HumanoidRootPart")
if root then
local spin = root:FindFirstChild("CloverSpin")
if spin then
spin:Destroy()
end
local att = root:FindFirstChild("CloverSpinAtt")
if att then
att:Destroy()
end
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid.AutoRotate = true
pcall(function()
humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
end)
end
end
toggleSpinBot = function(on)
SPIN_BOT_ENABLED = on and true or false
if SPIN_BOT_CONN then
SPIN_BOT_CONN:Disconnect()
SPIN_BOT_CONN = nil
end
if SPIN_BOT_STEP_CONN then
SPIN_BOT_STEP_CONN:Disconnect()
SPIN_BOT_STEP_CONN = nil
end
SPIN_BOT_SAFE_POS = nil
pcall(cleanupSpinBot)
if not SPIN_BOT_ENABLED then
return
end
SPIN_BOT_CONN = RunService.Heartbeat:Connect(function(dt)
local character = localPlayer.Character
if not character then
return
end
local root = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 then
return
end
humanoid.AutoRotate = false
pcall(function()
humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
end)
if humanoid.PlatformStand then
humanoid.PlatformStand = false
end
local look = root.CFrame
local pos = look.Position
-- remember the last spot where we were standing on something, so we can
-- put the character back if it ever gets knocked under the map
local fallenHeight = Workspace.FallenPartsDestroyHeight
if humanoid.FloorMaterial ~= Enum.Material.Air and pos.Y > fallenHeight + 60 then
SPIN_BOT_SAFE_POS = pos
end
if pos.Y < fallenHeight + 40 and SPIN_BOT_SAFE_POS then
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
root.CFrame = CFrame.new(SPIN_BOT_SAFE_POS + Vector3.new(0, 3, 0))
return
end
-- spin only around the vertical axis and never let physics build up
-- extra rotation / fling velocity
local _, yaw = look:ToOrientation()
local newYaw = yaw + (SPIN_BOT_SPEED * math.min(dt, 0.05))
root.AssemblyAngularVelocity = Vector3.zero
root.CFrame = CFrame.new(pos) * CFrame.Angles(0, newYaw, 0)
end)
-- keep the spinning body from colliding with the map / other players,
-- which is what flings the character and kills it
local spinParts = {}
local spinPartsAge = 1
SPIN_BOT_STEP_CONN = RunService.Stepped:Connect(function(_, dt)
local character = localPlayer.Character
if not character then
return
end
spinPartsAge += dt or 0
if spinPartsAge >= 0.5 then
spinPartsAge = 0
table.clear(spinParts)
local root = character:FindFirstChild("HumanoidRootPart")
for _, part in ipairs(character:GetDescendants()) do
if part:IsA("BasePart") and part ~= root then
spinParts[#spinParts + 1] = part
end
end
end
for i = 1, #spinParts do
local part = spinParts[i]
if part.CanCollide then
part.CanCollide = false
end
end
end)
end
BETTERGFX_FLAGS = {
{ "DFIntClusterSenderMaxJoinBandwidthBps", "2100000000" },
{ "DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000" },
{ "DFIntServerFramesBetweenJoins", "1" },
{ "DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000" },
{ "DFIntConnectionMTUSize", "1400" },
{ "FIntRakNetResendBufferArrayLength", "1024" },
{ "DFIntRakNetNakResendDelayMsMax", "1" },
{ "DFIntWaitOnUpdateNetworkLoopEndedMS", "100" },
{ "DFIntWaitOnRecvFromLoopEndedMS", "100" },
{ "DFIntLargePacketQueueSizeCutoffMB", "1000" },
{ "DFIntSendRakNetStatsInterval", "2147483647" },
{ "DFIntRakNetLoopMs", "1" },
{ "DFIntRakNetSelectTimeoutMs", "1" },
{ "DFIntNetworkClusterPacketCacheNumParallelTasks", "8" },
{ "DFIntReplicationDataCacheNumParallelTasks", "8" },
{ "DFIntMegaReplicatorNumParallelTasks", "16" },
{ "DFIntMegaReplicatorNetworkQualityProcessorUnit", "10" },
{ "DFIntMaxProcessPacketsStepsPerCyclic", "512" },
{ "DFIntMaxProcessPacketsStepsAccumulated", "0" },
{ "DFIntMaxProcessPacketsJobScaling", "1000" },
{ "DFIntClientPacketMaxFrameMicroseconds", "200000" },
{ "DFIntClientPacketExcessMicroseconds", "10000" },
{ "DFIntClientPacketMinMicroseconds", "1" },
{ "DFIntClientPacketMaxDelayMs", "1" },
{ "DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1" },
{ "DFIntMaxFrameBufferSize", "4" },
{ "DFIntBufferCompressionThreshold", "100" },
{ "DFIntOverrideISRReplicatorStepBandwidthBytes", "131072" },
{ "DFIntTaskSchedulerTargetFps", "9999" },
{ "DFIntTaskSchedulerJobInitThreads", "8" },
{ "DFIntTaskSchedulerJobInGameThreads", "8" },
{ "FIntTaskSchedulerAutoThreadLimit", "16" },
{ "FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4" },
{ "DFIntRuntimeConcurrency", "16" },
{ "FIntSimWorldTaskQueueParallelTasks", "20" },
{ "DFIntHttpBatchLimit", "256" },
{ "FIntHttpBatchLimit", "256" },
{ "DFIntHttpCurlConnectionCacheSize", "512" },
{ "FIntDefaultMeshCacheSizeMB", "512" },
{ "DFIntMemCacheMaxCapacityMB", "256" },
{ "DFIntNumAssetsMaxToPreload", "1" },
{ "DFFlagEnableSoundPreloading", "false" },
{ "FFlagSlimContentProvider", "true" },
{ "DFFlagDebugSkipMeshVoxelizer", "true" },
{ "DFFlagTextureQualityOverrideEnabled", "true" },
{ "DFIntTextureQualityOverride", "0" },
{ "FIntDebugTextureManagerSkipMips", "7" },
{ "DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8" },
{ "FFlagTM2SkipMipsForUnstreamable2", "true" },
{ "DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true" },
{ "FFlagRenderUseTextureManager224", "false" },
{ "DFIntDebugFRMQualityLevelOverride", "1" },
{ "DFFlagDebugPauseVoxelizer", "true" },
{ "FFlagFastGPULightCulling3", "true" },
{ "FIntRenderLocalLightFadeInMs", "0" },
{ "FIntRenderLocalLightUpdatesMax", "1" },
{ "FIntRenderShadowmapBias", "0" },
{ "FIntSSAOMipLevels", "0" },
{ "FIntDebugForceMSAASamples", "1" },
{ "FIntDebugFRMOptionalMSAALevelOverride", "0" },
{ "FIntRobloxGuiBlurIntensity", "0" },
{ "FIntFRMMinGrassDistance", "0" },
{ "FIntFRMMaxGrassDistance", "0" },
{ "DFFlagCoreScriptTelemetry2", "false" },
{ "DFFlagBrowserTrackerIdTelemetryEnabled", "false" },
{ "FFlagPerfDataOnTelemetryV2", "false" },
{ "FFlagSendRenderFidelityTelemetry2", "false" },
{ "FFlagEnableTelemetryServiceMemoryCPUInfo", "false" },
{ "DFIntTelemetryProfilerHundredthsPercentage", "0" },
{ "FIntTelemetryProfilerFrequency", "0" },
{ "FIntPerformanceTelemetryQueueProcessLimit", "0" },
{ "DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0" },
}
BETTERGFX_ENABLED = false
BETTERGFX_STATE = nil
BETTERGFX_CONNS = {}
betterGfxStrip = function(inst, state)
if inst:IsA("ParticleEmitter")
or inst:IsA("Trail")
or inst:IsA("Smoke")
or inst:IsA("Fire")
or inst:IsA("Sparkles")
or inst:IsA("PostEffect") then
if inst.Enabled and inst.Name ~= "CloverHubESP" then
state.stripped[#state.stripped + 1] = inst
inst.Enabled = false
end
end
end
enableBetterGraphics = function()
if BETTERGFX_ENABLED then
return
end
BETTERGFX_ENABLED = true
local state = {
stripped = {},
flags = {},
}
BETTERGFX_STATE = state
local env = (getgenv and getgenv()) or _G
local setF = rawget(env, "setfflag") or rawget(_G, "set_fflag")
local getF = rawget(env, "getfflag") or rawget(_G, "get_fflag")
if type(setF) == "function" then
for _, entry in ipairs(BETTERGFX_FLAGS) do
local name, value = entry[1], entry[2]
local skip = false
local prev = nil
if type(getF) == "function" then
local ok, cur = pcall(getF, name)
if not ok or cur == nil then
skip = true
else
prev = cur
end
end
if not skip and pcall(setF, name, tostring(value)) and prev ~= nil then
state.flags[#state.flags + 1] = { name, prev }
end
end
end
pcall(function()
state.quality = settings().Rendering.QualityLevel
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)
pcall(function()
state.lighting = {
Lighting.GlobalShadows,
Lighting.EnvironmentDiffuseScale,
Lighting.EnvironmentSpecularScale,
}
Lighting.GlobalShadows = false
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
end)
pcall(function()
local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if atmosphere then
state.atmosphere = { atmosphere, atmosphere.Density, atmosphere.Glare, atmosphere.Haze }
atmosphere.Density = 0
atmosphere.Glare = 0
atmosphere.Haze = 0
end
end)
pcall(function()
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
state.terrain = {
terrain,
terrain.Decoration,
terrain.WaterWaveSize,
terrain.WaterWaveSpeed,
terrain.WaterReflectance,
}
terrain.Decoration = false
terrain.WaterWaveSize = 0
terrain.WaterWaveSpeed = 0
terrain.WaterReflectance = 0
local clouds = terrain:FindFirstChildOfClass("Clouds")
if clouds and clouds.Enabled then
state.clouds = clouds
clouds.Enabled = false
end
end
end)
task.spawn(function()
for _, root in ipairs({ workspace, Lighting }) do
local ok, list = pcall(function()
return root:GetDescendants()
end)
if ok then
local i, n = 1, #list
while i <= n do
if not BETTERGFX_ENABLED or BETTERGFX_STATE ~= state then
return
end
local t0 = os.clock()
while i <= n and (os.clock() - t0) < 0.002 do
pcall(betterGfxStrip, list[i], state)
i = i + 1
end
RunService.Heartbeat:Wait()
end
end
end
end)
for _, root in ipairs({ workspace, Lighting }) do
BETTERGFX_CONNS[#BETTERGFX_CONNS + 1] = root.DescendantAdded:Connect(function(inst)
if BETTERGFX_STATE then
pcall(betterGfxStrip, inst, BETTERGFX_STATE)
end
end)
end
end
disableBetterGraphics = function()
if not BETTERGFX_ENABLED then
return
end
BETTERGFX_ENABLED = false
for _, conn in ipairs(BETTERGFX_CONNS) do
conn:Disconnect()
end
BETTERGFX_CONNS = {}
local state = BETTERGFX_STATE
BETTERGFX_STATE = nil
if not state then
return
end
local env = (getgenv and getgenv()) or _G
local setF = rawget(env, "setfflag") or rawget(_G, "set_fflag")
if type(setF) == "function" then
for _, entry in ipairs(state.flags) do
pcall(setF, entry[1], tostring(entry[2]))
end
end
pcall(function()
if state.quality then
settings().Rendering.QualityLevel = state.quality
end
end)
pcall(function()
if state.lighting then
Lighting.GlobalShadows = state.lighting[1]
Lighting.EnvironmentDiffuseScale = state.lighting[2]
Lighting.EnvironmentSpecularScale = state.lighting[3]
end
end)
pcall(function()
local a = state.atmosphere
if a and a[1].Parent then
a[1].Density = a[2]
a[1].Glare = a[3]
a[1].Haze = a[4]
end
end)
pcall(function()
local t = state.terrain
if t and t[1].Parent then
t[1].Decoration = t[2]
t[1].WaterWaveSize = t[3]
t[1].WaterWaveSpeed = t[4]
t[1].WaterReflectance = t[5]
end
if state.clouds then
state.clouds.Enabled = true
end
end)
task.spawn(function()
for i, inst in ipairs(state.stripped) do
pcall(function()
inst.Enabled = true
end)
if i % 300 == 0 then
RunService.Heartbeat:Wait()
end
end
end)
end
FPSBOOST_ENABLED = false
FPSBOOST_SAVED = nil
FPSBOOST_CONN = nil
FPS_BYPASS_ENABLED = false
FPS_BYPASS_TARGET = 240

enableFpsBypass = function(target)
    FPS_BYPASS_ENABLED = true
    local fps = tonumber(target) or FPS_BYPASS_TARGET or 240
    if fps < 60 then fps = 240 end
    FPS_BYPASS_TARGET = fps
    pcall(function()
        if setfpscap then setfpscap(fps) end
    end)
    pcall(function()
        if typeof(setfpscap) == "function" then setfpscap(fps) end
    end)
    pcall(function()
        if setfflag then
            setfflag("DFIntTaskSchedulerTargetFps", tostring(fps))
        end
    end)
    pcall(function()
        if getfflag and setfflag then
            setfflag("DFIntTaskSchedulerTargetFps", tostring(math.floor(fps)))
        end
    end)
    -- keep applying every few sec (some executors reset cap)
    if _G.__WhiteHubFpsBypassLoop then return end
    _G.__WhiteHubFpsBypassLoop = true
    task.spawn(function()
        while _G.__WhiteHubFpsBypassLoop do
            if FPS_BYPASS_ENABLED then
                local f = FPS_BYPASS_TARGET or 240
                pcall(function() if setfpscap then setfpscap(f) end end)
                pcall(function() if setfflag then setfflag("DFIntTaskSchedulerTargetFps", tostring(f)) end end)
            end
            task.wait(2)
        end
    end)
end

disableFpsBypass = function()
    FPS_BYPASS_ENABLED = false
    pcall(function()
        if setfpscap then setfpscap(60) end
    end)
    pcall(function()
        if setfflag then setfflag("DFIntTaskSchedulerTargetFps", "60") end
    end)
end

fpsBoostHandle = function(inst, saved)
if inst:IsA("ParticleEmitter")
or inst:IsA("Trail")
or inst:IsA("Beam")
or inst:IsA("Smoke")
or inst:IsA("Fire")
or inst:IsA("Sparkles") then
if inst.Name ~= "CloverHubESP" and inst.Enabled then
saved.effects[#saved.effects + 1] = inst
inst.Enabled = false
end
elseif inst:IsA("Decal") or inst:IsA("Texture") then
if inst.Transparency < 1 then
saved.props[#saved.props + 1] = { inst, "Transparency", inst.Transparency }
inst.Transparency = 1
end
elseif inst:IsA("BasePart") and not inst:IsA("Terrain") then
if inst.CastShadow then
saved.shadows[#saved.shadows + 1] = inst
inst.CastShadow = false
end
if inst.Material ~= Enum.Material.SmoothPlastic and inst.Material ~= Enum.Material.Plastic then
saved.props[#saved.props + 1] = { inst, "Material", inst.Material }
inst.Material = Enum.Material.SmoothPlastic
end
if inst.Reflectance > 0 then
saved.props[#saved.props + 1] = { inst, "Reflectance", inst.Reflectance }
inst.Reflectance = 0
end
end
end
enableFpsBoost = function()
if FPSBOOST_ENABLED then
return
end
FPSBOOST_ENABLED = true
local saved = {
effects = {},
shadows = {},
post = {},
props = {},
}
FPSBOOST_SAVED = saved
pcall(function()
saved.quality = settings().Rendering.QualityLevel
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)
pcall(function()
saved.shadowsOn = Lighting.GlobalShadows
Lighting.GlobalShadows = false
end)
pcall(function()
saved.softness = Lighting.ShadowSoftness
Lighting.ShadowSoftness = 0
end)
pcall(function()
saved.terrain = {
workspace.Terrain.Decoration,
workspace.Terrain.WaterWaveSize,
workspace.Terrain.WaterWaveSpeed,
}
workspace.Terrain.Decoration = false
workspace.Terrain.WaterWaveSize = 0
workspace.Terrain.WaterWaveSpeed = 0
end)
for _, child in ipairs(Lighting:GetChildren()) do
if child:IsA("BlurEffect")
or child:IsA("SunRaysEffect")
or child:IsA("BloomEffect")
or child:IsA("DepthOfFieldEffect") then
if child.Enabled and not child:GetAttribute("_CloverHubSky") then
saved.post[#saved.post + 1] = child
child.Enabled = false
end
end
end
pcall(function()
if setfpscap then
setfpscap(999)
elseif typeof(setfpscap) == "function" then
setfpscap(999)
end
end)
pcall(function()
if setfflag then
setfflag("DFIntTaskSchedulerTargetFps", "999")
end
end)
local pending = workspace:GetDescendants()
task.spawn(function()
for i = 1, #pending do
if not FPSBOOST_ENABLED or FPSBOOST_SAVED ~= saved then
break
end
pcall(fpsBoostHandle, pending[i], saved)
if i % 300 == 0 then
RunService.Heartbeat:Wait()
end
end
end)
if FPSBOOST_CONN then
FPSBOOST_CONN:Disconnect()
end
FPSBOOST_CONN = workspace.DescendantAdded:Connect(function(inst)
if FPSBOOST_SAVED then
pcall(fpsBoostHandle, inst, FPSBOOST_SAVED)
end
end)
end
disableFpsBoost = function()
if not FPSBOOST_ENABLED then
return
end
FPSBOOST_ENABLED = false
if FPSBOOST_CONN then
FPSBOOST_CONN:Disconnect()
FPSBOOST_CONN = nil
end
local saved = FPSBOOST_SAVED
FPSBOOST_SAVED = nil
if not saved then
return
end
pcall(function()
if saved.quality then
settings().Rendering.QualityLevel = saved.quality
end
end)
pcall(function()
if saved.shadowsOn ~= nil then
Lighting.GlobalShadows = saved.shadowsOn
end
if saved.softness then
Lighting.ShadowSoftness = saved.softness
end
end)
pcall(function()
if saved.terrain then
workspace.Terrain.Decoration = saved.terrain[1]
workspace.Terrain.WaterWaveSize = saved.terrain[2]
workspace.Terrain.WaterWaveSpeed = saved.terrain[3]
end
end)
for _, inst in ipairs(saved.post) do
pcall(function()
inst.Enabled = true
end)
end
task.spawn(function()
for i, inst in ipairs(saved.effects) do
pcall(function()
inst.Enabled = true
end)
if i % 300 == 0 then
RunService.Heartbeat:Wait()
end
end
for i, inst in ipairs(saved.shadows) do
pcall(function()
inst.CastShadow = true
end)
if i % 300 == 0 then
RunService.Heartbeat:Wait()
end
end
for i, entry in ipairs(saved.props) do
pcall(function()
entry[1][entry[2]] = entry[3]
end)
if i % 300 == 0 then
RunService.Heartbeat:Wait()
end
end
end)
end
SMOOTH_SPEED_ENABLED = false
SMOOTH_ACCEL = 450
SMOOTH_DECEL = 800
SMOOTH_SAFE_SPEED = 500
SMOOTH_LAST_TIME = nil
SMOOTH_LAST_POS = nil
SMOOTH_COOLDOWN_UNTIL = 0
speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = true
editModeEnabled = false
uiScaleValue = 78
espEnabled = false
antiKickEnabled = false
setSafeModeVisual = nil
mirrorTPDownEnabled = false
mirrorTPDownSetVisual = nil
infJumpEnabled = false
infJumpMode = "HOLD"
bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batV2FloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil
neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil
currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil
autoBatV2Enabled = false
autoBatV2SetVisual = nil
selectedAimbotMode = "Normal"
autoSwingEnabled = false
_G.AceAntiBypassAimbotSpeed = _G.AceAntiBypassAimbotSpeed or 55
_G.AceAntiBypassLaggerAimbotSpeed = _G.AceAntiBypassLaggerAimbotSpeed or 40
_G.AceAntiBypassAimbotOn = _G.AceAntiBypassAimbotOn or false
_G.AceNormalAimbotOn = _G.AceNormalAimbotOn or false
_G.AceCurrentSpeedMode = _G.AceCurrentSpeedMode or "Normal"
_G.AceAntiBypassAimbot = _G.AceAntiBypassAimbot or {
conn = nil,
swingCooldown = false,
prevAutoRotate = nil,
}
_G.AceAntiBypassSlapList = _G.AceAntiBypassSlapList
or {
"Bat",
"Slap",
"Iron Slap",
"Gold Slap",
"Diamond Slap",
"Emerald Slap",
"Ruby Slap",
"Dark Matter Slap",
"Flame Slap",
"Nuclear Slap",
"Galaxy Slap",
"Glitched Slap",
}
_G.AceSafeModeTryStart = _G.AceSafeModeTryStart or _G.AmbitiousSafeModeTryStart
_G.AceStopAutoTPForAction = _G.AceStopAutoTPForAction
or function()
if batDesyncTpEnabled and type(stopBatDesyncTp) == "function" then
stopBatDesyncTp()
end
end
_G.AceStopNormalAimbot = _G.AceStopNormalAimbot
or function()
local wasAutoBatEnabled = autoBatEnabled
if wasAutoBatEnabled then
wasAutoBatEnabled = type(disableAutoBat) == "function"
end
if wasAutoBatEnabled then
disableAutoBat()
end
end
useCarrySystem = false
lastMoveDir = zeroVector
tpBatVersion = 1
tpBatVersionLabel = nil
tpBatVersionPill = nil
tpBatDistanceBox = nil
_G.__tpBatV2Distance = 8
game:GetService("CoreGui")
katanaSkinEnabled = false
do
local function createKatanaSkinController()
local katanaPlayersService = game:GetService("Players")
local katanaInsertService = game:GetService("InsertService")
local katanaLighting = game:GetService("Lighting")
local katanaReplicatedStorage = game:GetService("ReplicatedStorage")
local katanaPlayer = katanaPlayersService.LocalPlayer
local katanaColors = {
red = Color3.new(0.784314, 0, 0),
red2 = Color3.new(1, 0, 0.392157),
gold = Color3.new(1, 0.843137, 0),
}
local katanaState = {
Skin = "KATANA",
SkinOrder = {
"KATANA",
"NONE",
},
LastBat = nil,
LastAppliedSkin = nil,
OriginalKatanaTemplate = nil,
ExactTemplates = {},
ExactTemplateSearched = {},
ExactAssetIds = {
KATANA = "",
},
Original = {},
}
local function findBat()
local character = katanaPlayer.Character
if character then
local bat = character:FindFirstChild("Bat")
if bat and bat:IsA("Tool") then
return bat
end
end
local backpack = katanaPlayer:FindFirstChildOfClass("Backpack")
if backpack then
local bat = backpack:FindFirstChild("Bat")
if bat and bat:IsA("Tool") then
return bat
end
end
return nil
end
local function configureVisualPart(part)
if not part or not part:IsA("BasePart") then
return
end
part.Anchored = false
part.CanCollide = false
part.CanTouch = false
part.CanQuery = false
part.Massless = true
end
local function weldToHandle(part1, part0)
if not part1 or not part0 or not part1:IsA("BasePart") or not part0:IsA("BasePart") then
return
end
configureVisualPart(part1)
local weldConstraint = Instance.new("WeldConstraint")
weldConstraint.Name = "FlowerSkin_AssetWeld"
weldConstraint.Part0 = part0
weldConstraint.Part1 = part1
weldConstraint.Parent = part1
end
local function cacheOriginalBatState(batTool)
if not batTool then
return
end
local handle = batTool:FindFirstChild("Handle")
local slash = batTool:FindFirstChild("Slash")
katanaState.Original[batTool] = katanaState.Original[batTool] or {}
local originalState = katanaState.Original[batTool]
if handle and handle:IsA("BasePart") and not originalState.Handle then
originalState.Handle = {
Transparency = handle.Transparency,
LocalTransparencyModifier = handle.LocalTransparencyModifier,
CastShadow = handle.CastShadow,
}
end
if slash and slash:IsA("Sound") and not originalState.SlashSoundId then
originalState.SlashSoundId = slash.SoundId
end
end
local function captureOriginalKatanaTemplate()
if katanaState.OriginalKatanaTemplate then
return
end
local function scanContainer(container)
if not container then
return
end
local bat = container:FindFirstChild("Bat")
if not bat then
return
end
local flowerSkinKatanaRealistic = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
flowerSkinKatanaRealistic = flowerSkinKatanaRealistic
and flowerSkinKatanaRealistic:FindFirstChild("FlowerSkin_AssetKatana")
if flowerSkinKatanaRealistic then
katanaState.OriginalKatanaTemplate = flowerSkinKatanaRealistic:Clone()
end
end
scanContainer(katanaPlayer:FindFirstChildOfClass("Backpack"))
scanContainer(katanaPlayer.Character)
end
local function setBatHandleHidden(batTool, hidden)
local handle523 = batTool and batTool:FindFirstChild("Handle")
if not handle523 or not handle523:IsA("BasePart") then
return
end
cacheOriginalBatState(batTool)
if hidden then
handle523.LocalTransparencyModifier = 1
handle523.Transparency = 1
handle523.CastShadow = false
else
local handle = katanaState.Original[batTool] and katanaState.Original[batTool].Handle
handle523.LocalTransparencyModifier = handle and handle.LocalTransparencyModifier or 0
handle523.Transparency = handle and handle.Transparency or 0
handle523.CastShadow = handle and handle.CastShadow
if handle523.CastShadow == nil then
handle523.CastShadow = true
end
end
end
local function setBatSlashSound(batTool, soundId)
cacheOriginalBatState(batTool)
local slash = batTool and batTool:FindFirstChild("Slash")
if slash and slash:IsA("Sound") then
if not soundId then
soundId = katanaState.Original[batTool] and katanaState.Original[batTool].SlashSoundId
or slash.SoundId
end
slash.SoundId = soundId
end
end
local function restoreOriginalBatVisual(batTool)
if not batTool then
return
end
local flowerSkinKatanaRealistic = batTool:FindFirstChild("FlowerSkin_KatanaRealistic")
if flowerSkinKatanaRealistic then
flowerSkinKatanaRealistic:Destroy()
end
local flowerSkinAssetKatana = batTool:FindFirstChild("FlowerSkin_AssetKatana")
if flowerSkinAssetKatana then
flowerSkinAssetKatana:Destroy()
end
setBatHandleHidden(batTool, false)
setBatSlashSound(batTool, nil)
end
local function addKatanaRedEffects(parent)
if not parent or not parent:IsA("BasePart") then
return
end
local cloverHubSpeedIndicator = parent:FindFirstChild("CloverHubSpeedIndicator")
if cloverHubSpeedIndicator then
cloverHubSpeedIndicator:Destroy()
end
local topAttachment = Instance.new("Attachment")
topAttachment.Name = "FlowerSkin_ExtraRedVFX"
topAttachment.Position = Vector3.new(0, parent.Size.Y * 0.5, 0)
topAttachment.Parent = parent
local bottomAttachment = Instance.new("Attachment")
bottomAttachment.Name = "FlowerSkin_ExtraRedVFX_End"
bottomAttachment.Position = Vector3.new(0, -parent.Size.Y * 0.5, 0)
bottomAttachment.Parent = parent
local trail = Instance.new("Trail")
trail.Name = "FlowerSkin_ExtraRedVFX"
trail.Attachment0 = topAttachment
trail.Attachment1 = bottomAttachment
trail.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, katanaColors.red2),
ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)),
})
trail.Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.35),
NumberSequenceKeypoint.new(1, 1),
})
trail.Lifetime = 0.18
trail.LightEmission = 0.55
trail.Parent = parent
local particleEmitter = Instance.new("ParticleEmitter")
particleEmitter.Name = "FlowerSkin_ExtraRedVFX"
local red2 = katanaColors.red2
particleEmitter.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.new(0.784314, 0, 0)),
ColorSequenceKeypoint.new(1, red2),
})
particleEmitter.LightEmission = 0.55
particleEmitter.Rate = 14
particleEmitter.Lifetime = NumberRange.new(0.3, 0.45)
particleEmitter.Speed = NumberRange.new(0.2, 0.7)
particleEmitter.SpreadAngle = Vector2.new(12, 12)
particleEmitter.Size = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.08),
NumberSequenceKeypoint.new(1, 0),
})
particleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
particleEmitter.Parent = parent
end
local function createKatanaPart(parent, name, size, cframeOffset, color, material)
local part = Instance.new("Part")
part.Name = name
part.Size = size
part.Color = color
part.Material = material or Enum.Material.Neon
part.TopSurface = Enum.SurfaceType.Smooth
part.BottomSurface = Enum.SurfaceType.Smooth
configureVisualPart(part)
part.Parent = parent
return part, cframeOffset or CFrame.identity
end
local katanaCandidateNames = {
KATANA = {
"FlowerSkin_AssetKatana",
"Katana",
"FlowerSkin_KatanaRealistic",
},
}
local function isScriptInstance(instance)
return instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript")
end
local function removeScripts(root)
if not root then
return
end
if isScriptInstance(root) then
root:Destroy()
return
end
for _, descendant in ipairs(root:GetDescendants()) do
if isScriptInstance(descendant) then
descendant:Destroy()
end
end
end
local function hasBasePart(candidate)
if not candidate then
return false
end
if candidate:IsA("BasePart") then
return true
end
return candidate:FindFirstChildWhichIsA("BasePart", true) ~= nil
end
local function isGeneratedSkin(candidate)
local ok, result = pcall(function()
return candidate:GetAttribute("CursedBatSkinsGenerated")
end)
return ok and result == true
end
local function validateSkinCandidate(candidate)
if not candidate or isGeneratedSkin(candidate) then
return nil
end
if
candidate:IsA("Model")
or candidate:IsA("Tool")
or candidate:IsA("Accessory")
or candidate:IsA("BasePart")
then
if hasBasePart(candidate) then
return candidate
end
end
return nil
end
local function findNamedSkinCandidate(root, candidateNames)
if not root then
return nil
end
for _, entry in ipairs(candidateNames) do
if root.Name ~= entry then
continue
end
local candidate = validateSkinCandidate(root)
if candidate then
return candidate
end
end
for _, candidateName in ipairs(candidateNames) do
local instance = root:FindFirstChild(candidateName, true)
local validatedCandidate = validateSkinCandidate(instance)
if validatedCandidate then
return validatedCandidate
end
end
return nil
end
local function normalizeAssetId(assetId)
local normalizedId = tostring(assetId or ""):gsub("%s+", "")
if normalizedId == "" then
return nil
end
if normalizedId:match("^rbxassetid://") or normalizedId:match("^rbxasset://") then
return normalizedId
end
if normalizedId:match("^%d+$") then
return "rbxassetid://" .. normalizedId
end
return normalizedId
end
local function loadAssetSkinTemplate(skinName)
local assetUri = normalizeAssetId(katanaState.ExactAssetIds[skinName])
if not assetUri then
return nil
end
local loadedAssets = {}
pcall(function()
loadedAssets = game:GetObjects(assetUri)
end)
if #loadedAssets == 0 then
local match = tostring(assetUri):match("(%d+)")
if match then
pcall(function()
table.insert(loadedAssets, katanaInsertService:LoadAsset(tonumber(match)))
end)
end
end
local candidateNames = katanaCandidateNames[skinName] or {}
for _, entry in ipairs(loadedAssets) do
local candidate = findNamedSkinCandidate(entry, candidateNames) or validateSkinCandidate(entry)
if candidate then
local clone = candidate:Clone()
removeScripts(clone)
return clone
end
end
return nil
end
local function findExistingSkinTemplate(skinName)
local candidateNames = katanaCandidateNames[skinName]
if not candidateNames then
return nil
end
local searchRoots = {}
local character = katanaPlayer.Character
local backpack = katanaPlayer:FindFirstChildOfClass("Backpack")
local workspaceRoot = workspace
local lightingRoot = katanaLighting
searchRoots[1] = character
searchRoots[2] = backpack
searchRoots[3] = katanaReplicatedStorage
searchRoots[4] = lightingRoot
searchRoots[5] = workspaceRoot
for _, entry in ipairs(searchRoots) do
local candidate = findNamedSkinCandidate(entry, candidateNames)
if candidate then
local clone = candidate:Clone()
removeScripts(clone)
return clone
end
end
return nil
end
local function getSkinTemplate(skinName)
if skinName == "KATANA" and katanaState.OriginalKatanaTemplate then
return katanaState.OriginalKatanaTemplate
end
if katanaState.ExactTemplates[skinName] then
return katanaState.ExactTemplates[skinName]
end
if katanaState.ExactTemplateSearched[skinName] then
return nil
end
katanaState.ExactTemplateSearched[skinName] = true
local template = loadAssetSkinTemplate(skinName) or findExistingSkinTemplate(skinName)
if template then
katanaState.ExactTemplates[skinName] = template
end
return template
end
local normalizeSkinModel = nil
normalizeSkinModel = function(source, parent)
if source:IsA("Model") then
source.Name = "FlowerSkin_AssetKatana"
source.Parent = parent
return source
end
if source:IsA("BasePart") then
local model = Instance.new("Model")
model.Name = "FlowerSkin_AssetKatana"
model.Parent = parent
source.Parent = model
return model
end
if source:IsA("Tool") or source:IsA("Folder") then
local flowerSkinAssetKatana = source:FindFirstChild("FlowerSkin_AssetKatana")
or source:FindFirstChildWhichIsA("Model")
or source:FindFirstChildWhichIsA("BasePart")
if flowerSkinAssetKatana and flowerSkinAssetKatana.Parent == source then
flowerSkinAssetKatana.Parent = nil
source:Destroy()
return normalizeSkinModel(flowerSkinAssetKatana, parent)
end
local model = Instance.new("Model")
model.Name = "FlowerSkin_AssetKatana"
model.Parent = parent
for _, child in ipairs(source:GetChildren()) do
if not isScriptInstance(child) then
child.Parent = model
end
end
source:Destroy()
return model
end
return nil
end
local function applyExactSkinTemplate(batTool, skinName)
local handle = batTool and batTool:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then
return false
end
local template = getSkinTemplate(skinName)
if not template then
return false
end
local folder = Instance.new("Folder")
folder.Name = "FlowerSkin_KatanaRealistic"
folder.Parent = batTool
local skinModel = normalizeSkinModel(template:Clone(), folder)
if not skinModel or not hasBasePart(skinModel) then
folder:Destroy()
return false
end
removeScripts(skinModel)
pcall(function()
skinModel:SetAttribute("CursedBatSkinsExactMesh", true)
end)
local firstPart = nil
for _, descendant in ipairs(skinModel:GetDescendants()) do
if descendant:IsA("BasePart") then
firstPart = firstPart or descendant
configureVisualPart(descendant)
end
end
if not firstPart then
folder:Destroy()
return false
end
if skinModel:IsA("Model") then
skinModel.PrimaryPart = skinModel.PrimaryPart or firstPart
pcall(function()
skinModel:PivotTo(handle.CFrame)
end)
end
for _, descendant in ipairs(skinModel:GetDescendants()) do
if descendant:IsA("BasePart") then
weldToHandle(descendant, handle)
end
end
local weaponPart = skinModel:FindFirstChild("SharpParts", true)
or skinModel:FindFirstChild("WeaponPart", true)
or skinModel:FindFirstChild("Handle", true)
or firstPart
if weaponPart and not weaponPart:FindFirstChild("FlowerSkin_ExtraRedVFX") then
addKatanaRedEffects(weaponPart)
end
return true
end
local function createProceduralKatana(batTool, skinName)
local handle = batTool and batTool:FindFirstChild("Handle")
if not handle or not handle:IsA("BasePart") then
return nil
end
local folder = Instance.new("Folder")
folder.Name = "FlowerSkin_KatanaRealistic"
folder.Parent = batTool
local model = Instance.new("Model")
model.Name = "FlowerSkin_AssetKatana"
model:SetAttribute("CursedBatSkinsGenerated", true)
model.Parent = folder
local createdParts = {}
local function createPart(name, size, cframeOffset, color, material)
local part, offset = createKatanaPart(model, name, size, cframeOffset, color, material)
part.CFrame = handle.CFrame * offset
weldToHandle(part, handle)
table.insert(createdParts, part)
return part
end
if skinName == "KATANA" then
local metal = Enum.Material.Metal
createPart(
"Handle2",
Vector3.new(0.22, 1, 0.22),
CFrame.new(0, -0.48, 0),
Color3.new(0.176471, 0.176471, 0.045),
metal
)
local red2 = katanaColors.red2
local neon = Enum.Material.Neon
local sharpParts =
createPart("SharpParts", Vector3.new(0.18, 2.4, 0.12), CFrame.new(0, 1.05, 0), red2, neon)
local red = katanaColors.red
local neon2 = Enum.Material.Neon
createPart("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), red, neon2)
local gold = katanaColors.gold
local neon3 = Enum.Material.Neon
createPart("GoldAccent", Vector3.new(0.5, 0.12, 0.08), CFrame.new(0, -0.28, 0), gold, neon3)
addKatanaRedEffects(sharpParts)
end
model.PrimaryPart = createdParts[1]
return model
end
local slashSoundIds = {
KATANA = "rbxassetid://111808555599832",
}
return {
State = katanaState,
ApplySkin = function(skinName)
captureOriginalKatanaTemplate()
local lastBat = findBat()
if not lastBat then
katanaState.LastBat = nil
katanaState.LastAppliedSkin = nil
return false
end
cacheOriginalBatState(lastBat)
restoreOriginalBatVisual(lastBat)
if skinName == "NONE" then
katanaState.LastBat = lastBat
katanaState.LastAppliedSkin = skinName
return true
end
setBatHandleHidden(lastBat, true)
setBatSlashSound(lastBat, slashSoundIds[skinName])
if not applyExactSkinTemplate(lastBat, skinName) then
createProceduralKatana(lastBat, skinName)
end
local handle = lastBat:FindFirstChild("Handle")
if handle then
local fire = handle:FindFirstChildOfClass("Fire") or handle:FindFirstChild("Fire")
if fire and fire:IsA("Fire") then
fire.Enabled = true
fire.Color = katanaColors.red
fire.SecondaryColor = katanaColors.red2
end
end
katanaState.LastBat = lastBat
katanaState.LastAppliedSkin = skinName
return true
end,
SetExactAssetId = function(assetId)
katanaState.ExactAssetIds.KATANA = tostring(assetId or "")
katanaState.ExactTemplateSearched.KATANA = nil
katanaState.ExactTemplates.KATANA = nil
end,
}
end
katanaSkinController = createKatanaSkinController()
end
_G.CursedBatKatana = katanaSkinController
task.spawn(function()
while true do
if katanaSkinEnabled then
local character = localPlayer.Character
local bat = nil
if character then
bat = character:FindFirstChild("Bat")
local isTool = bat and bat:IsA("Tool")
if not isTool then
bat = nil
end
end
local needsSkinRefresh
if not bat then
local backpack = localPlayer:FindFirstChildOfClass("Backpack")
if backpack then
local bat2 = backpack:FindFirstChild("Bat")
if bat2 and bat2:IsA("Tool") then
needsSkinRefresh = bat2
else
needsSkinRefresh = bat
end
else
needsSkinRefresh = bat
end
else
needsSkinRefresh = bat
end
needsSkinRefresh = needsSkinRefresh
and (
needsSkinRefresh ~= katanaSkinController.State.LastBat
or katanaSkinController.State.LastAppliedSkin ~= "KATANA"
)
if needsSkinRefresh then
pcall(function()
katanaSkinController.ApplySkin("KATANA")
end)
end
end
task.wait(0.5)
end
end)
minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"
MinecraftBatSetVisual = nil
MinecraftBatColorSelector = nil
do
local function createMinecraftBatController()
local batGripOffset = newCFrame(-0.18, -0.52, -0.2)
local batGripRotation = CFrame.Angles(0.78539816339744828, 0, 0.087266462599716474)
local minecraftBatColors = {
["Default"] = nil,
["Abyss Blue"] = Color3.fromRGB(0, 0, 0),
["Venom Green"] = Color3.fromRGB(0, 0, 0),
["Royal Gold"] = Color3.fromRGB(255, 255, 255),
["Velvet Rose"] = Color3.fromRGB(0, 0, 0),
["Crimson Night"] = Color3.fromRGB(0, 0, 0),
}
local minecraftBatState = {
enabled = false,
colorMode = "Default",
cachedVisualPart = nil,
rgbConnection = nil,
}
local ok, result = pcall(function()
return game:GetObjects("rbxassetid://18566246244")
end)
if ok and result and #result > 0 then
local assetRoot = result[1]
minecraftBatState.cachedVisualPart = assetRoot:IsA("BasePart") and assetRoot
or assetRoot:FindFirstChildWhichIsA("BasePart", true)
end
local function setPartColor(part, color)
if not part or not color then
return
end
part.Color = color
if part:IsA("UnionOperation") then
pcall(function()
part.UsePartColor = true
end)
end
local specialMesh = part:FindFirstChildWhichIsA("SpecialMesh")
if specialMesh then
specialMesh.VertexColor = Vector3.new(color.R, color.G, color.B)
end
end
local function findBat()
local character = localPlayer.Character
if character then
local bat = character:FindFirstChild("Bat")
if bat and bat:IsA("Tool") then
return bat
end
end
local backpack = localPlayer:FindFirstChildOfClass("Backpack")
if backpack then
local bat = backpack:FindFirstChild("Bat")
if bat and bat:IsA("Tool") then
return bat
end
end
return nil
end
local function restoreBatVisual(batTool)
if not batTool then
return
end
local customUnionVisual = batTool:FindFirstChild("CustomUnionVisual")
if customUnionVisual then
pcall(function()
customUnionVisual:Destroy()
end)
end
local handle = batTool:FindFirstChild("Handle")
if handle then
handle.Transparency = 0
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
pcall(function()
child.Transparency = 0
end)
end
end
end
end
local function applyMinecraftBatVisual(batTool)
if not batTool or batTool.Name ~= "Bat" or not minecraftBatState.cachedVisualPart then
return
end
local handle = batTool:WaitForChild("Handle", 2)
if not handle then
return
end
local oldVisual = batTool:FindFirstChild("CustomUnionVisual")
if oldVisual then
oldVisual:Destroy()
end
handle.Transparency = 1
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
pcall(function()
child.Transparency = 1
end)
end
end
local visualPart = minecraftBatState.cachedVisualPart:Clone()
visualPart.Name = "CustomUnionVisual"
visualPart.CanCollide = false
visualPart.Massless = true
visualPart.Anchored = false
local scaleModel = Instance.new("Model")
visualPart.Parent = scaleModel
scaleModel.PrimaryPart = visualPart
pcall(function()
scaleModel:ScaleTo(2)
end)
visualPart.Parent = nil
scaleModel:Destroy()
if minecraftBatState.colorMode == "RGB" then
setPartColor(visualPart, Color3.fromHSV(tick() % 3 / 3, 1, 1))
elseif minecraftBatColors[minecraftBatState.colorMode] then
setPartColor(visualPart, minecraftBatColors[minecraftBatState.colorMode])
end
for _, child in ipairs(visualPart:GetChildren()) do
if child:IsA("Weld") or child:IsA("WeldConstraint") then
child:Destroy()
end
end
visualPart.CFrame = handle.CFrame * batGripOffset * batGripRotation
visualPart.Parent = batTool
local weld = Instance.new("WeldConstraint")
weld.Part0 = handle
weld.Part1 = visualPart
weld.Parent = visualPart
end
local function startRgbCycle()
if minecraftBatState.rgbConnection then
return
end
minecraftBatState.rgbConnection = RunService.RenderStepped:Connect(function()
if not minecraftBatState.enabled or minecraftBatState.colorMode ~= "RGB" then
return
end
local currentBat = findBat()
if not currentBat then
return
end
local customVisual = currentBat:FindFirstChild("CustomUnionVisual")
if customVisual then
setPartColor(customVisual, Color3.fromHSV(tick() % 3 / 3, 1, 1))
end
end)
end
local function stopRgbCycle()
if minecraftBatState.rgbConnection then
minecraftBatState.rgbConnection:Disconnect()
minecraftBatState.rgbConnection = nil
end
end
return {
State = minecraftBatState,
Colors = minecraftBatColors,
FindBat = findBat,
Apply = function()
if not minecraftBatState.enabled then
return
end
local batTool = findBat()
if batTool then
applyMinecraftBatVisual(batTool)
end
if minecraftBatState.colorMode == "RGB" then
startRgbCycle()
end
end,
Remove = function()
stopRgbCycle()
local character = localPlayer.Character
if character then
local bat = character:FindFirstChild("Bat")
if bat then
restoreBatVisual(bat)
end
end
local backpack = localPlayer:FindFirstChildOfClass("Backpack")
if backpack then
local bat = backpack:FindFirstChild("Bat")
if bat then
restoreBatVisual(bat)
end
end
end,
SetColorMode = function(colorMode)
minecraftBatState.colorMode = colorMode
if not minecraftBatState.enabled then
return
end
if colorMode == "RGB" then
startRgbCycle()
else
stopRgbCycle()
end
local batTool = findBat()
if batTool then
applyMinecraftBatVisual(batTool)
end
end,
}
end
minecraftBatSkinController = createMinecraftBatController()
end
task.spawn(function()
while true do
if minecraftBatSkinEnabled then
minecraftBatSkinController.State.enabled = true
local currentBat = minecraftBatSkinController.FindBat()
if currentBat and not currentBat:FindFirstChild("CustomUnionVisual") then
pcall(minecraftBatSkinController.Apply)
end
else
minecraftBatSkinController.State.enabled = false
end
task.wait(0.5)
end
end)
_G.AmbitiousNormalInfJump = _G.AmbitiousNormalInfJump
or {
holdPressed = false,
holdActive = false,
controllerActive = false,
mobilePressed = false,
mobileActive = false,
hooked = {},
}
_G._jumpEnsureProxy = function()
local character = localPlayer.Character
if not character then
return nil
end
return character:FindFirstChild("HumanoidRootPart")
end
_G.AmbitiousApplyNormalInfJumpBoost = function(value)
if not infJumpEnabled then
return
end
local character = localPlayer.Character
if not character then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health <= 0 then
return
end
local rootPart = _G._jumpEnsureProxy()
if not rootPart then
return
end
local velocity = rootPart.Velocity
rootPart.Velocity = newVector3(velocity.X, value or 50, velocity.Z)
end
_G.AmbitiousStopNormalInfJumpHoldState = function()
local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
ambitiousNormalInfJump.holdPressed = false
ambitiousNormalInfJump.holdActive = false
ambitiousNormalInfJump.controllerActive = false
ambitiousNormalInfJump.mobilePressed = false
ambitiousNormalInfJump.mobileActive = false
end
UserInputService.JumpRequest:Connect(function()
_G.AmbitiousApplyNormalInfJumpBoost(50)
end)
UserInputService.InputBegan:Connect(function(input)
if UserInputService:GetFocusedTextBox() then
return
end
local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
if infJumpMode == "MANUAL" then
return
end
ambitiousNormalInfJump.holdPressed = true
task.delay(0.12, function()
if _G.AmbitiousNormalInfJump.holdPressed and infJumpEnabled then
_G.AmbitiousNormalInfJump.holdActive = true
_G.AmbitiousApplyNormalInfJumpBoost(50)
end
end)
elseif input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
if infJumpMode ~= "MANUAL" then
ambitiousNormalInfJump.controllerActive = true
end
end
end)
UserInputService.InputEnded:Connect(function(input)
local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
ambitiousNormalInfJump.holdPressed = false
ambitiousNormalInfJump.holdActive = false
end
if input.KeyCode == Enum.KeyCode.ButtonA and input.UserInputType.Name:match("^Gamepad") then
ambitiousNormalInfJump.controllerActive = false
end
end)
_G.AmbitiousHookNormalInfMobileJumpButton = function(callback)
local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
if
not callback
or callback.Name ~= "JumpButton"
or not callback:IsA("GuiButton")
or ambitiousNormalInfJump.hooked[callback]
then
return
end
ambitiousNormalInfJump.hooked[callback] = true
callback.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.Touch or not infJumpEnabled then
return
end
if infJumpMode == "MANUAL" then
return
end
ambitiousNormalInfJump.mobilePressed = true
task.delay(0.12, function()
if ambitiousNormalInfJump.mobilePressed and infJumpEnabled then
ambitiousNormalInfJump.mobileActive = true
_G.AmbitiousApplyNormalInfJumpBoost(50)
end
end)
end)
callback.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch then
ambitiousNormalInfJump.mobilePressed = false
ambitiousNormalInfJump.mobileActive = false
end
end)
end
do
local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
if playerGui then
for _, descendant in ipairs(playerGui:GetDescendants()) do
_G.AmbitiousHookNormalInfMobileJumpButton(descendant)
end
playerGui.DescendantAdded:Connect(function(descendant)
task.defer(_G.AmbitiousHookNormalInfMobileJumpButton, descendant)
end)
end
end
RunService.Heartbeat:Connect(function()
local ambitiousNormalInfJump = _G.AmbitiousNormalInfJump
local isActive = infJumpEnabled and infJumpMode == "HOLD"
if isActive then
isActive = ambitiousNormalInfJump.holdActive
or ambitiousNormalInfJump.mobileActive
or ambitiousNormalInfJump.controllerActive
end
if isActive then
_G.AmbitiousApplyNormalInfJumpBoost(50)
end
end)
_G.setInfJumpInternal = function(value)
infJumpEnabled = value and true or false
if not infJumpEnabled then
_G.AmbitiousStopNormalInfJumpHoldState()
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if humanoidRootPart then
pcall(function()
humanoidRootPart.Velocity = zeroVector
end)
end
end
end
InfiniteJump = {
start = function()
_G.setInfJumpInternal(true)
end,
stop = function()
_G.setInfJumpInternal(false)
end,
isRunning = function()
return infJumpEnabled == true
end,
setJumpPower = function() end,
}
getActiveMoveSpeed = function()
if laggerCarryToggled then
return LAGGER_CARRY_SPEED
end
if laggerToggled then
return LAGGER_SPEED
end
if speedMode then
return CS
end
return NS
end
do
local data = {}
velocityHookedRoots = {}
registerVelocityRoot = function(character)
data = {}
if not character then
return
end
local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
if humanoidRootPart then
data[humanoidRootPart] = true
end
return humanoidRootPart
end
local isActive = nil
installVelocityReadHook = function(humanoidRootPart)
if not humanoidRootPart or velocityHookedRoots[humanoidRootPart] then
return
end
if isActive == false then
return
end
if isActive == nil then
isActive = type(getrawmetatable) == "function"
and type(setreadonly) == "function"
and type(newcclosure) == "function"
and type(checkcaller) == "function"
end
if not isActive then
return
end
velocityHookedRoots[humanoidRootPart] = true
if
not pcall(function()
local mt = getrawmetatable(humanoidRootPart)
if not mt then
return
end
setreadonly(mt, false)
local value = rawget(mt, "__index")
mt.__index = newcclosure(function(self, key)
if
not checkcaller()
and data[self]
and (key == "AssemblyLinearVelocity" or key == "Velocity")
then
local real
if type(value) == "function" then
real = value(self, key)
else
real = nil
if type(value) == "table" then
real = value[key]
end
end
if real and real.Magnitude > 20 then
return real.Unit * 20
end
return real
end
if type(value) == "function" then
return value(self, key)
end
if type(value) == "table" then
return value[key]
end
end)
setreadonly(mt, true)
end)
then
isActive = false
end
end
end
do
local saveOriginalAnimations
if localPlayer.Character then
local object = registerVelocityRoot(localPlayer.Character)
installVelocityReadHook(object)
end
isHumanoidRagdolled = function(humanoid)
if not humanoid then
return true
end
local state = humanoid:GetState()
return humanoid.PlatformStand
or state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
end
applyMovementVelocity = function(direction, speed, humanoidRootPart)
if not humanoidRootPart or not humanoidRootPart.Parent then
return
end
if autoBatV2Enabled or batDesyncTpEnabled or autoBatEnabled then
return
end
if direction and direction.Magnitude > 0.05 then
pcall(function()
if humanoidRootPart.SetNetworkOwner then
humanoidRootPart:SetNetworkOwner(localPlayer)
end
end)
local unit = direction.Unit
if SMOOTH_SPEED_ENABLED then
local now = os.clock()
local dt = clamp(now - (SMOOTH_LAST_TIME or now), 0.001, 0.1)
SMOOTH_LAST_TIME = now
local pos = humanoidRootPart.Position
if SMOOTH_LAST_POS then
local moved = newVector3(pos.X - SMOOTH_LAST_POS.X, 0, pos.Z - SMOOTH_LAST_POS.Z)
if moved.Magnitude > (speed * dt * 2.5) + 5 then
SMOOTH_COOLDOWN_UNTIL = now + 0.3
end
end
SMOOTH_LAST_POS = pos
local effective = speed
if now < SMOOTH_COOLDOWN_UNTIL and effective > SMOOTH_SAFE_SPEED then
effective = SMOOTH_SAFE_SPEED
end
local cur = humanoidRootPart.AssemblyLinearVelocity
local curH = newVector3(cur.X, 0, cur.Z)
local delta = newVector3(unit.X * effective, 0, unit.Z * effective) - curH
local maxStep = SMOOTH_ACCEL * dt
if delta.Magnitude > maxStep then
delta = delta.Unit * maxStep
end
local newH = curH + delta
humanoidRootPart.AssemblyLinearVelocity = newVector3(newH.X, cur.Y, newH.Z)
else
humanoidRootPart.AssemblyLinearVelocity =
newVector3(unit.X * speed, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * speed)
end
else
local cur = humanoidRootPart.AssemblyLinearVelocity
if SMOOTH_SPEED_ENABLED then
local now = os.clock()
local dt = clamp(now - (SMOOTH_LAST_TIME or now), 0.001, 0.1)
SMOOTH_LAST_TIME = now
SMOOTH_LAST_POS = humanoidRootPart.Position
local curH = newVector3(cur.X, 0, cur.Z)
local stepDown = SMOOTH_DECEL * dt
if curH.Magnitude > stepDown then
curH = curH - curH.Unit * stepDown
else
curH = zeroVector
end
humanoidRootPart.AssemblyLinearVelocity = newVector3(curH.X, cur.Y, curH.Z)
else
humanoidRootPart.AssemblyLinearVelocity = newVector3(0, cur.Y, 0)
end
end
end
getAutoPathSpeed = function()
if laggerCarryToggled or laggerToggled then
return LAGGER_SPEED
end
return NS
end
ANIM_PACKS = {
Zombie = {
idle1 = "rbxassetid://616158929",
idle2 = "rbxassetid://616160636",
walk = "rbxassetid://616168032",
run = "rbxassetid://616163682",
jump = "rbxassetid://616161997",
fall = "rbxassetid://616157476",
climb = "rbxassetid://616156119",
swim = "rbxassetid://616165109",
swimidle = "rbxassetid://616166655",
},
Ninja = {
idle1 = "rbxassetid://656117400",
idle2 = "rbxassetid://656117400",
walk = "rbxassetid://656121766",
run = "rbxassetid://656118852",
jump = "rbxassetid://656117878",
fall = "rbxassetid://656115606",
climb = "rbxassetid://656114359",
swim = "rbxassetid://656117400",
swimidle = "rbxassetid://656117400",
},
Knight = {
idle1 = "rbxassetid://657595757",
idle2 = "rbxassetid://657595757",
walk = "rbxassetid://657552124",
run = "rbxassetid://657564596",
jump = "rbxassetid://658409194",
fall = "rbxassetid://657600338",
climb = "rbxassetid://658360781",
swim = "rbxassetid://657595757",
swimidle = "rbxassetid://657595757",
},
Elder = {
idle1 = "rbxassetid://845397899",
idle2 = "rbxassetid://845397899",
walk = "rbxassetid://845403856",
run = "rbxassetid://845386501",
jump = "rbxassetid://845398858",
fall = "rbxassetid://845397673",
climb = "rbxassetid://845392038",
swim = "rbxassetid://845397899",
swimidle = "rbxassetid://845397899",
},
["Levitate"] = {
idle1 = "rbxassetid://616006778",
idle2 = "rbxassetid://616006778",
walk = "rbxassetid://616013216",
run = "rbxassetid://616013216",
jump = "rbxassetid://616008936",
fall = "rbxassetid://616005863",
climb = "rbxassetid://616003713",
swim = "rbxassetid://616006778",
swimidle = "rbxassetid://616006778",
},
Astronaut = {
idle1 = "rbxassetid://891621366",
idle2 = "rbxassetid://891621366",
walk = "rbxassetid://891636393",
run = "rbxassetid://891636393",
jump = "rbxassetid://891627522",
fall = "rbxassetid://891617961",
climb = "rbxassetid://891609353",
swim = "rbxassetid://891621366",
swimidle = "rbxassetid://891621366",
},
Pirate = {
idle1 = "rbxassetid://750781874",
idle2 = "rbxassetid://750781874",
walk = "rbxassetid://750785693",
run = "rbxassetid://750783738",
jump = "rbxassetid://750782230",
fall = "rbxassetid://750780242",
climb = "rbxassetid://750779899",
swim = "rbxassetid://750781874",
swimidle = "rbxassetid://750781874",
},
Toy = {
idle1 = "rbxassetid://782841498",
idle2 = "rbxassetid://782841498",
walk = "rbxassetid://782843345",
run = "rbxassetid://782842708",
jump = "rbxassetid://782847020",
fall = "rbxassetid://782846423",
climb = "rbxassetid://782843869",
swim = "rbxassetid://782841498",
swimidle = "rbxassetid://782841498",
},
Vampire = {
idle1 = "rbxassetid://1083445855",
idle2 = "rbxassetid://1083445855",
walk = "rbxassetid://1083473930",
run = "rbxassetid://1083462077",
jump = "rbxassetid://1083455352",
fall = "rbxassetid://1083443587",
climb = "rbxassetid://1083439238",
swim = "rbxassetid://1083445855",
swimidle = "rbxassetid://1083445855",
},
Werewolf = {
idle1 = "rbxassetid://1083195517",
idle2 = "rbxassetid://1083195517",
walk = "rbxassetid://1083178339",
run = "rbxassetid://1083216690",
jump = "rbxassetid://1083218792",
fall = "rbxassetid://1083189019",
climb = "rbxassetid://1083182000",
swim = "rbxassetid://1083195517",
swimidle = "rbxassetid://1083195517",
},
Rthro = {
idle1 = "rbxassetid://2510196951",
idle2 = "rbxassetid://2510196951",
walk = "rbxassetid://2510202577",
run = "rbxassetid://2510198475",
jump = "rbxassetid://2510197830",
fall = "rbxassetid://2510195892",
climb = "rbxassetid://2510192778",
swim = "rbxassetid://2510196951",
swimidle = "rbxassetid://2510196951",
},
Stylish = {
idle1 = "rbxassetid://616136790",
idle2 = "rbxassetid://616136790",
walk = "rbxassetid://616146177",
run = "rbxassetid://616140816",
jump = "rbxassetid://616139451",
fall = "rbxassetid://616134815",
climb = "rbxassetid://616133594",
swim = "rbxassetid://616136790",
swimidle = "rbxassetid://616136790",
},
}
ANIM_PACK_ORDER = {
{
"Off",
"Off",
},
{
"Zombie",
"Zombie",
},
{
"Ninja",
"Ninja",
},
{
"Knight",
"Knight",
},
{
"Elder",
"Elder",
},
{
"Levitate",
"Levitate",
},
{
"Astronaut",
"Astronaut",
},
{
"Pirate",
"Pirate",
},
{
"Toy",
"Toy",
},
{
"Vampire",
"Vampire",
},
{
"Werewolf",
"Werewolf",
},
{
"Rthro",
"Rthro",
},
{
"Stylish",
"Stylish",
},
}
do
local function isPackAnimation(id)
for _, pack in pairs(ANIM_PACKS) do
for _, entry in pairs(pack) do
if entry == id then
return true
end
end
end
return false
end
saveOriginalAnimations = function(character)
local animate = character:FindFirstChild("Animate")
if not animate then
return
end
local function g(object)
return object and object.AnimationId or nil
end
local ids = {
idle1 = g(animate.idle and animate.idle.Animation1),
idle2 = g(animate.idle and animate.idle.Animation2),
walk = g(animate.walk and animate.walk.WalkAnim),
run = g(animate.run and animate.run.RunAnim),
jump = g(animate.jump and animate.jump.JumpAnim),
fall = g(animate.fall and animate.fall.FallAnim),
climb = g(animate.climb and animate.climb.ClimbAnim),
swim = g(animate.swim and animate.swim.Swim),
swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
}
if not isPackAnimation(ids.walk) then
originalTryardAnims = ids
end
end
end
do
local function applyAnimationPack811(text)
currentAnimPack = text
if animSelectorLabel then
animSelectorLabel.Text = text
end
if text == "Off" then
if originalTryardAnims and localPlayer.Character then
local animate = localPlayer.Character:FindFirstChild("Animate")
if animate then
local function s(object, animationId)
if object and object.AnimationId ~= animationId then
object.AnimationId = animationId
end
end
s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
s(animate.run and animate.run.RunAnim, originalTryardAnims.run)
s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
end
end
if tryardHeartbeatConn then
tryardHeartbeatConn:Disconnect()
tryardHeartbeatConn = nil
end
return
end
local pack = ANIM_PACKS[text]
if not pack then
return
end
if tryardHeartbeatConn then
tryardHeartbeatConn:Disconnect()
end
tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
local animNow = os.clock()
if animNow - (_G.__cloverAnimT or 0) < 0.25 then
return
end
_G.__cloverAnimT = animNow
local character = localPlayer.Character
if not character then
return
end
local animate = character:FindFirstChild("Animate")
if not animate then
return
end
local function s(object, animationId)
if object and object.AnimationId ~= animationId then
object.AnimationId = animationId
end
end
s(animate.idle and animate.idle.Animation1, pack.idle1)
s(animate.idle and animate.idle.Animation2, pack.idle2)
s(animate.walk and animate.walk.WalkAnim, pack.walk)
s(animate.run and animate.run.RunAnim, pack.run)
s(animate.jump and animate.jump.JumpAnim, pack.jump)
s(animate.fall and animate.fall.FallAnim, pack.fall)
s(animate.climb and animate.climb.ClimbAnim, pack.climb)
s(animate.swim and animate.swim.Swim, pack.swim)
s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
end)
end
applyAnimationPack = function(animPack)
local character = localPlayer.Character
if character then
saveOriginalAnimations(character)
applyAnimationPack811(animPack)
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
for _, entry in ipairs(humanoid:GetPlayingAnimationTracks()) do
entry:Stop(0)
end
humanoid:ChangeState(Enum.HumanoidStateType.Running)
end
else
applyAnimationPack811(animPack)
end
currentAnimPack = animPack
end
disableAnimationPack = function()
currentAnimPack = "Off"
if animSelectorLabel then
animSelectorLabel.Text = "Off"
end
applyAnimationPack811("Off")
end
end
end
DEFAULT_KB = {
DropBrainrot = {
kb = Enum.KeyCode.J,
gp = nil,
},
AutoLeft = {
kb = Enum.KeyCode.Z,
gp = nil,
},
AutoRight = {
kb = Enum.KeyCode.C,
gp = nil,
},
AutoBat = {
kb = Enum.KeyCode.E,
gp = nil,
},
TPFloor = {
kb = Enum.KeyCode.F,
gp = nil,
},
GuiHide = {
kb = Enum.KeyCode.LeftControl,
gp = nil,
},
CarryToggle = {
kb = Enum.KeyCode.Q,
gp = nil,
},
LaggerMode = {
kb = Enum.KeyCode.R,
gp = nil,
},
TPBat = {
kb = Enum.KeyCode.X,
gp = nil,
},
BatV2 = {
kb = Enum.KeyCode.V,
gp = nil,
},
InstaReset = {
kb = Enum.KeyCode.H,
gp = nil,
},
}
KB = {
DropBrainrot = {
kb = DEFAULT_KB.DropBrainrot.kb,
gp = DEFAULT_KB.DropBrainrot.gp,
},
AutoLeft = {
kb = DEFAULT_KB.AutoLeft.kb,
gp = DEFAULT_KB.AutoLeft.gp,
},
AutoRight = {
kb = DEFAULT_KB.AutoRight.kb,
gp = DEFAULT_KB.AutoRight.gp,
},
AutoBat = {
kb = DEFAULT_KB.AutoBat.kb,
gp = DEFAULT_KB.AutoBat.gp,
},
TPFloor = {
kb = DEFAULT_KB.TPFloor.kb,
gp = DEFAULT_KB.TPFloor.gp,
},
GuiHide = {
kb = DEFAULT_KB.GuiHide.kb,
gp = DEFAULT_KB.GuiHide.gp,
},
CarryToggle = {
kb = DEFAULT_KB.CarryToggle.kb,
gp = DEFAULT_KB.CarryToggle.gp,
},
LaggerMode = {
kb = DEFAULT_KB.LaggerMode.kb,
gp = DEFAULT_KB.LaggerMode.gp,
},
TPBat = {
kb = DEFAULT_KB.TPBat.kb,
gp = DEFAULT_KB.TPBat.gp,
},
BatV2 = {
kb = DEFAULT_KB.BatV2.kb,
gp = DEFAULT_KB.BatV2.gp,
},
InstaReset = {
kb = DEFAULT_KB.InstaReset.kb,
gp = DEFAULT_KB.InstaReset.gp,
},
}
_isResetting = false
_lastSavedJSON = nil
_isLoading = false
CONFIG = {
AUTO_STEAL_ENABLED = false,
STEAL_RANGE = 61,
}
workspace:WaitForChild("Plots")
autoStealConnection = nil
autoStealState = {
AutoStealEnabled = false,
StealRadius = CONFIG.STEAL_RANGE,
StealDuration = 1.3,
StealDelay = 0.25,
Data = {},
}
autoStealBusy = false
autoStealVariant = 1
AUTO_STEAL_VARIANT_NAMES = {
"Normal",
"Semi",
"Semi Normal",
}
getAutoStealVariantName = function(value)
return AUTO_STEAL_VARIANT_NAMES[clamp(tonumber(value) or 1, 1, #AUTO_STEAL_VARIANT_NAMES)]
end
getAutoStealVariantIndex = function(value)
for i, entry in ipairs(AUTO_STEAL_VARIANT_NAMES) do
if entry == tostring(value) then
return i
end
end
return 1
end
getAutoStealDuration = function()
local stealDuration = autoStealState and autoStealState.StealDuration or 1.3
if autoStealVariant == 2 then
return stealDuration * 0.8
end
if autoStealVariant == 3 then
return stealDuration * 0.9
end
return stealDuration * 0.73
end
do
local instance = nil
local value = 0
getPlotsRoot = function()
local now = getTime()
if instance and now - value < 2 and instance.Parent then
return instance
end
instance = workspace:FindFirstChild("Plots")
value = now
return instance
end
end
do
local findNearestPrompt
do
local function isMyPlotByName(plotName)
local plotsRoot = getPlotsRoot()
if not plotsRoot then
return false
end
local plot = plotsRoot:FindFirstChild(plotName)
if not plot then
return false
end
local sign = plot:FindFirstChild("PlotSign")
if sign then
local yourBase = sign:FindFirstChild("YourBase")
if yourBase and yourBase:IsA("BillboardGui") then
return yourBase.Enabled == true
end
end
return false
end
findNearestPrompt = function()
local character = localPlayer.Character
if not character then
return nil, nil
end
local root = character:FindFirstChild("HumanoidRootPart")
if not root then
return nil, nil
end
local plotsRoot = getPlotsRoot()
if not plotsRoot then
return nil, nil
end
local nearestPrompt = nil
local nearestDistance = huge
local name = nil
local position = root.Position
for _, child in ipairs(plotsRoot:GetChildren()) do
if not isMyPlotByName(child.Name) then
local pods = child:FindFirstChild("AnimalPodiums")
if pods then
for _, child2 in ipairs(pods:GetChildren()) do
do
local spawn_ = child2:FindFirstChild("Base")
spawn_ = spawn_ and spawn_:FindFirstChild("Spawn")
if spawn_ and spawn_:IsA("BasePart") then
local position2 = spawn_.Position
local dx = position2.X - position.X
local dy = position2.Y - position.Y
local dz = position2.Z - position.Z
local distance = sqrt(dx * dx + dy * dy + dz * dz)
if distance < nearestDistance and distance <= autoStealState.StealRadius then
local promptAttachment = spawn_:FindFirstChild("PromptAttachment")
if promptAttachment then
for _, child3 in ipairs(promptAttachment:GetChildren()) do
if
child3:IsA("ProximityPrompt")
and child3.ActionText
and child3.ActionText:find("Steal")
then
nearestPrompt = child3
nearestDistance = distance
name = child2.Name
break
end
end
end
end
end
end
end
end
end
end
return nearestPrompt, name
end
end
STEAL_UI_LAST = -1
setStealProgressUI = function(p)
p = clamp(p, 0, 1)
local pct = floor(p * 100)
if pct == STEAL_UI_LAST then
return
end
STEAL_UI_LAST = pct
if progressFill then
progressFill.Size = UDim2.new(p, 0, 1, 0)
end
if progressPct then
progressPct.Text = pct .. "%"
end
end
local executeSteal = nil
executeSteal = function(prompt, podName)
if autoStealBusy then
return
end
if math.random(30) == 1 then
for k in pairs(autoStealState.Data) do
if not k.Parent then
autoStealState.Data[k] = nil
end
end
end
if not autoStealState.Data[prompt] then
autoStealState.Data[prompt] = {
hold = {},
trigger = {},
ready = true,
}
pcall(function()
if getconnections then
for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
if c.Function then
table.insert(autoStealState.Data[prompt].hold, c.Function)
end
end
for _, c in ipairs(getconnections(prompt.Triggered)) do
if c.Function then
table.insert(autoStealState.Data[prompt].trigger, c.Function)
end
end
end
end)
end
local object885 = autoStealState.Data[prompt]
if not object885.ready then
return
end
object885.ready = false
autoStealBusy = true
if progressFill then
progressFill.Size = UDim2.new(0, 0, 1, 0)
end
if progressPct then
progressPct.Text = ""
end
task.spawn(function()
for _, f in ipairs(object885.hold) do
task.spawn(f)
end
local startTime = getTime()
local stealDuration = autoStealState.StealDuration
local promptFired = getAutoStealDuration()
while true do
if autoStealBusy and autoStealState.AutoStealEnabled then
local elapsed = getTime() - startTime
if not (promptFired <= elapsed) then
setStealProgressUI(elapsed / stealDuration)
if not (not prompt.Parent or not prompt.Parent.Parent) then
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if
not (
humanoidRootPart
and (humanoidRootPart.Position - prompt.Parent.Parent.Position).Magnitude
> autoStealState.StealRadius
)
then
task.wait()
continue
end
end
end
end
break
end
local stopProgress = clamp(promptFired / stealDuration, 0, 1)
if progressFill then
progressFill.Size = UDim2.new(stopProgress, 0, 1, 0)
end
if progressPct then
progressPct.Text = floor(stopProgress * 100) .. "%"
end
local phase2Timeout = math.max(2.99 - promptFired - math.max(stealDuration - promptFired, 0), 0.05)
local phase2Start = getTime()
local exitTo = nil
while true do
if autoStealBusy and autoStealState.AutoStealEnabled then
if getTime() - phase2Start >= phase2Timeout then
exitTo = 2
break
elseif not prompt.Parent or not prompt.Parent.Parent then
exitTo = 3
break
else
local character = localPlayer.Character
character = character and character:FindFirstChild("HumanoidRootPart")
if character then
local magnitude = (character.Position - prompt.Parent.Parent.Position).Magnitude
if magnitude <= 9 then
exitTo = 1
break
elseif not (magnitude > autoStealState.StealRadius) then
task.wait()
continue
end
else
task.wait()
continue
end
end
else
exitTo = 1
break
end
break
end
if exitTo == 1 then
if autoStealBusy and autoStealState.AutoStealEnabled then
local fillStart = getTime()
local fillDuration = math.max(stealDuration - promptFired, 0.05)
while true do
local fp = clamp((getTime() - fillStart) / fillDuration, 0, 1)
setStealProgressUI(stopProgress + fp * (1 - stopProgress))
if not (fp >= 1 and true) then
task.wait()
continue
end
break
end
pcall(function()
for _, f in ipairs(object885.trigger) do
task.spawn(f)
end
local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
if remote and podName then
remote:FireServer(podName)
end
if prompt then
prompt:Fire()
end
end)
end
if progressFill then
progressFill.Size = UDim2.new(0, 0, 1, 0)
end
if progressPct then
progressPct.Text = ""
end
object885.ready = true
autoStealBusy = false
return
end
if exitTo == 2 then
if progressFill then
progressFill.Size = UDim2.new(0, 0, 1, 0)
end
if progressPct then
progressPct.Text = ""
end
object885.ready = true
autoStealBusy = false
task.wait()
local elapsed, progress = findNearestPrompt()
if elapsed then
executeSteal(elapsed, progress)
end
return
end
if exitTo == 3 then
autoStealBusy = false
if progressFill then
progressFill.Size = UDim2.new(0, 0, 1, 0)
end
if progressPct then
progressPct.Text = ""
end
object885.ready = true
return
end
autoStealBusy = false
if progressFill then
progressFill.Size = UDim2.new(0, 0, 1, 0)
end
if progressPct then
progressPct.Text = ""
end
object885.ready = true
end)
end
startAutoSteal = function()
if autoStealConnection then
local connected = false
pcall(function()
connected = autoStealConnection.Connected == true
end)
if connected then
autoStealState.StealRadius = CONFIG.STEAL_RANGE
autoStealState.AutoStealEnabled = true
CONFIG.AUTO_STEAL_ENABLED = true
return true
end
pcall(function()
autoStealConnection:Disconnect()
end)
autoStealConnection = nil
end
autoStealState.StealRadius = CONFIG.STEAL_RANGE
autoStealState.AutoStealEnabled = true
CONFIG.AUTO_STEAL_ENABLED = true
local stealAcc = 0
autoStealConnection = RunService.Heartbeat:Connect(function(dt)
if not autoStealState.AutoStealEnabled or autoStealBusy then
return
end
stealAcc = stealAcc + (dt or 0)
if stealAcc < 0.06 then
return
end
stealAcc = 0
local p, n = findNearestPrompt()
if p then
executeSteal(p, n)
end
end)
return true
end
end
stopAutoSteal = function()
if autoStealConnection then
autoStealConnection:Disconnect()
autoStealConnection = nil
end
autoStealBusy = false
autoStealState.AutoStealEnabled = false
CONFIG.AUTO_STEAL_ENABLED = false
if progressFill then
TweenService:Create(progressFill, TweenInfo.new(0.2), {
Size = UDim2.new(0, 0, 1, 0),
}):Play()
end
if progressPct then
progressPct.Text = ""
end
end
medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = newVector3(0, 0, 0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil
_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08
tpBatFloatingButton = nil
batV2FloatingButton = nil
enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {
autoSteal = nil,
batCounter = nil,
anchor = {},
progress = nil,
autoLeft = nil,
autoRight = nil,
}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressRadLbl = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox = nil
carryBox = nil
laggerBox = nil
lagger2Box = nil
radInput = nil
batSpeedBox = nil
uiScaleBox = nil
modeSelectBtn = nil
dropModeBtnRef = nil
setJumpToggleState = nil
autoBatSetVisual = nil
autoLeftSetVisual = nil
autoRightSetVisual = nil
setBatCounterVisual = nil
setMedusaVisual = nil
setAntiRagVisual = nil
setJumpVisual = nil
setUnwalkVisual = nil
setAntiLagVisual = nil
setLockUIVisual = nil
setInstaGrab = nil
setAntiDieVisual = nil
setEditModeVisual = nil
setESPVIsual = nil
mobSetAutoBat = nil
mobSetAutoLeft = nil
mobSetAutoRight = nil
mobSetDropBR = nil
mobSetTpDown = nil
mobSetCarry = nil
mobSetLagger1 = nil
mobSetLagger2 = nil
mobSetFloat = nil
autoBatV2SetVisual = nil
miniBtn = nil
main = nil
gui = nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
carrySystemToggleSetter = nil
autoStealVariantLabel = nil
carrySysNormalBox = nil
carrySysCarryBox = nil
carrySysLaggerBox = nil
carrySysLaggerCarryBox = nil
carrySysSoftStealSpeedBox = nil
carrySysSoftStealRadiusBox = nil
setSafeModeVisual = nil
mirrorTPDownSetVisual = nil
infJumpSetVisual = nil
infJumpModeSetVisual = nil
noPlayerCollisionEnabled = false
setNoPlayerCollisionVisual = nil
noCamCollisionEnabled = false
setNoCamCollisionVisual = nil
GAMEPAD_KEYS = {
[Enum.KeyCode.ButtonA] = true,
[Enum.KeyCode.ButtonB] = true,
[Enum.KeyCode.ButtonX] = true,
[Enum.KeyCode.ButtonY] = true,
[Enum.KeyCode.ButtonL1] = true,
[Enum.KeyCode.ButtonR1] = true,
[Enum.KeyCode.ButtonL2] = true,
[Enum.KeyCode.ButtonR2] = true,
[Enum.KeyCode.ButtonL3] = true,
[Enum.KeyCode.ButtonR3] = true,
[Enum.KeyCode.ButtonStart] = true,
[Enum.KeyCode.ButtonSelect] = true,
[Enum.KeyCode.DPadUp] = true,
[Enum.KeyCode.DPadDown] = true,
[Enum.KeyCode.DPadLeft] = true,
[Enum.KeyCode.DPadRight] = true,
}
MOVE_KEYS = {
[Enum.KeyCode.W] = true,
[Enum.KeyCode.A] = true,
[Enum.KeyCode.S] = true,
[Enum.KeyCode.D] = true,
[Enum.KeyCode.Up] = true,
[Enum.KeyCode.Left] = true,
[Enum.KeyCode.Down] = true,
[Enum.KeyCode.Right] = true,
}
BAT_COUNTER_SLAP_LIST = {
"Bat",
"Slap",
"Iron Slap",
"Gold Slap",
"Diamond Slap",
"Emerald Slap",
"Ruby Slap",
"Dark Matter Slap",
"Flame Slap",
"Nuclear Slap",
"Galaxy Slap",
"Glitched Slap",
}
AP = {
L1 = newVector3(-476.48, -6.28, 92.73),
L2 = newVector3(-483.12, -4.95, 94.8),
L_FACE = newVector3(-482.25, -4.96, 92.09),
R1 = newVector3(-476.16, -6.52, 25.62),
R2 = newVector3(-483.06, -5.03, 25.48),
R_FACE = newVector3(-482.06, -6.93, 35.47),
}
isGamepadInput = function(input)
return input and input.UserInputType and input.UserInputType.Name:match("^Gamepad") ~= nil
end
isBindableInput = function(input)
if not input or input.KeyCode == Enum.KeyCode.Unknown then
return false
end
if input.UserInputType == Enum.UserInputType.Keyboard then
return true
end
return isGamepadInput(input) and GAMEPAD_KEYS[input.KeyCode] == true
end
kbMatch = function(entry, kc)
return kc and (kc == entry.kb or entry.gp and kc == entry.gp)
end
resetProgressBar = function()
if progressPct then
progressPct.Text = ""
end
if progressFill then
progressFill.Size = UDim2.new(0, 0, 1, 0)
end
end
teleportDown = function()
pcall(function()
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return
end
local cFrame = humanoidRootPart.CFrame
humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z)
* CFrame.Angles(0, select(2, cFrame:ToEulerAnglesYXZ()), 0)
humanoidRootPart.Velocity = zeroVector
end)
end
do
local trackedPlayerHeights = {}
local lastMirrorTeleportTime = 0
local function hasActiveTeleportAimbot()
return _G.AmbitiousNormalAimbotOn == true
or _G.AmbitiousBatAimbotV2On == true
or _G.AmbitiousTPBatOn == true
or _G.AlvaroTP and _G.AlvaroTP.on == true
or autoBatEnabled == true
or autoBatV2Enabled == true
or batDesyncTpEnabled == true
end
local function mirrorTeleportDown()
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
character = character and character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not character or character.Health <= 0 then
return
end
local now = getTime()
if now - lastMirrorTeleportTime < 0.05 then
return
end
lastMirrorTeleportTime = now
local pitch, yaw = humanoidRootPart.CFrame:ToEulerAnglesYXZ()
humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position.X, -7, humanoidRootPart.Position.Z)
* CFrame.Angles(0, yaw, 0)
humanoidRootPart.Velocity = zeroVector
pcall(function()
humanoidRootPart.AssemblyLinearVelocity = zeroVector
end)
end
RunService.Heartbeat:Connect(function()
if not mirrorTPDownEnabled or not hasActiveTeleportAimbot() then
table.clear(trackedPlayerHeights)
return
end
for _, player in ipairs(Players:GetPlayers()) do
if player ~= localPlayer and player.Character then
local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
if humanoidRootPart then
local y = humanoidRootPart.Position.Y
local previousHeight = trackedPlayerHeights[player.UserId]
if previousHeight and previousHeight - y >= 3 then
pcall(mirrorTeleportDown)
table.clear(trackedPlayerHeights)
return
end
trackedPlayerHeights[player.UserId] = y
end
end
end
end)
_G.AmbitiousSetMirrorTPDown = function(enabled)
mirrorTPDownEnabled = enabled == true
if not mirrorTPDownEnabled then
table.clear(trackedPlayerHeights)
end
if mirrorTPDownSetVisual then
mirrorTPDownSetVisual(mirrorTPDownEnabled)
end
pcall(saveAllSettings)
end
end
end
_G.AmbitiousSafeModeGetCountdownLabel = function()
local ok, result = pcall(function()
return localPlayer.PlayerGui
and localPlayer.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
and localPlayer.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
and localPlayer.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
and localPlayer.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("TextLabel")
end)
return ok and result or nil
end
_G.AmbitiousSafeModeCountdownNumber = function(value)
local text = tostring(value or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
if text == "GO" or text == "START" or text == "READY" then
return true
end
local num = tonumber(text)
return num ~= nil and num >= 0 and num <= 10
end
_G.AmbitiousSafeModeCountdownValue = function()
local textLabel = _G.AmbitiousSafeModeGetCountdownLabel()
if not textLabel then
return nil
end
local text = tostring(textLabel.Text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
if text == "GO" or text == "START" or text == "READY" then
return 0
end
local num = tonumber(text)
if num ~= nil and num >= 0 and num <= 10 then
return num
end
return nil
end
_G.AmbitiousSafeModeInDuelCountdown = function()
local textLabel = _G.AmbitiousSafeModeGetCountdownLabel()
return textLabel and _G.AmbitiousSafeModeCountdownNumber(textLabel.Text) or false
end
_G.AmbitiousSafeModeBlockedTools = {
bat = true,
slap = true,
sword = true,
gun = true,
pistol = true,
rifle = true,
medusa = true,
hammer = true,
axe = true,
knife = true,
katana = true,
blade = true,
fist = true,
}
_G.AmbitiousSafeModeIsCarryableTool = function(callback)
if not callback or not callback:IsA("Tool") then
return false
end
local lowercaseText = callback.Name:lower()
for k in pairs(_G.AmbitiousSafeModeBlockedTools) do
if lowercaseText:find(k, 1, true) then
return false
end
end
return true
end
_G.AmbitiousSafeModeHoldingBrainrot = function()
local ok, result = pcall(function()
return localPlayer:GetAttribute("Stealing")
end)
if ok and result == true then
return true
end
local ok2, result2 = pcall(function()
return localPlayer:GetAttribute("Stealing")
end)
if ok2 and result2 == true then
return true
end
local character = localPlayer.Character
if not character then
return false
end
local ok3, result3 = pcall(function()
return character:GetAttribute("Stealing")
end)
if ok3 and result3 == true then
return true
end
for _, entry in ipairs({
"Carrying",
"IsCarrying",
"Grabbed",
"Holding",
"StealHold",
"HasGrab",
}) do
local instance = character:FindFirstChild(entry, true)
if instance then
if instance:IsA("BoolValue") and instance.Value then
return true
end
if instance:IsA("ObjectValue") and instance.Value then
return true
end
if instance:IsA("StringValue") and instance.Value ~= "" then
return true
end
end
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
local lowercaseText = child.Name:lower()
if
lowercaseText:find("brainrot")
or lowercaseText:find("animal")
or lowercaseText:find("carry")
or lowercaseText:find("grab")
or lowercaseText:find("steal")
or lowercaseText:find("hold")
then
return true
end
end
end
return false
end
_G.AmbitiousSafeModeIsLocked = function()
if not antiKickEnabled then
return false
end
return _G.AmbitiousSafeModeInDuelCountdown() or _G.AmbitiousSafeModeHoldingBrainrot()
end
_G.AmbitiousSafeModeForceStop = function(value)
local object = autoBatEnabled and disableAutoBat
local isEnabled = false
if object then
disableAutoBat()
isEnabled = true
end
if autoBatV2Enabled and disableBatV2 then
disableBatV2()
isEnabled = true
end
if batDesyncTpEnabled and stopBatDesyncTp then
stopBatDesyncTp()
isEnabled = true
end
if autoLeftEnabled then
autoLeftEnabled = false
if autoLeftSetVisual then
autoLeftSetVisual(false)
end
stopAutoLeft()
isEnabled = true
end
if autoRightEnabled then
autoRightEnabled = false
if autoRightSetVisual then
autoRightSetVisual(false)
end
stopAutoRight()
isEnabled = true
end
if isEnabled then
print("[SafeMode]", value or "LOCK")
end
end
_G.AmbitiousSafeModeTryStart = function()
if _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
_G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
return false
end
return true
end
_G.AmbitiousSafeModeMonitorStarted = _G.AmbitiousSafeModeMonitorStarted or false
if not _G.AmbitiousSafeModeMonitorStarted then
_G.AmbitiousSafeModeMonitorStarted = true
RunService.Heartbeat:Connect(function()
if antiKickEnabled and _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
_G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
end
end)
end
antiRagdollController = {}
antiRagdollController.__index = antiRagdollController
do
local data = {
active = false,
isBoosting = false,
cachedChar = nil,
ragdollConnections = {},
_lastBoostTime = 0,
}
local function getActiveMoveSpeed()
if laggerCarryToggled then
return LAGGER_CARRY_SPEED
end
if laggerToggled then
return LAGGER_SPEED
end
if speedMode then
return CS
end
return NS
end
local function disconnectAllV1()
for _, ragdollConnection in ipairs(data.ragdollConnections) do
pcall(function()
ragdollConnection:Disconnect()
end)
end
data.ragdollConnections = {}
end
local function cacheCharacterV1()
local character = localPlayer.Character
if not character then
return false
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoid or not humanoidRootPart then
return false
end
data.cachedChar = {
character = character,
humanoid = humanoid,
root = humanoidRootPart,
}
return true
end
local function isRagdolledV1()
if not data.cachedChar or not data.cachedChar.humanoid then
return false
end
local humanoid = data.cachedChar.humanoid
if not humanoid.Parent then
return false
end
return ({
[Enum.HumanoidStateType.Physics] = true,
[Enum.HumanoidStateType.Ragdoll] = true,
[Enum.HumanoidStateType.FallingDown] = true,
})[humanoid:GetState()] or false
end
local function forceExitRagdollV1()
if not data.cachedChar or not data.cachedChar.humanoid or not data.cachedChar.root then
return
end
local humanoid = data.cachedChar.humanoid
local root = data.cachedChar.root
if not humanoid.Parent or not root.Parent then
return
end
pcall(function()
localPlayer:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
end)
for _, descendant in ipairs(data.cachedChar.character:GetDescendants()) do
local isBallSocketConstraint = descendant:IsA("BallSocketConstraint")
local pos
if isBallSocketConstraint then
pos = isBallSocketConstraint
else
pos = descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")
end
if pos then
pcall(function()
descendant:Destroy()
end)
end
end
local activeMoveSpeed = getActiveMoveSpeed()
if not data.isBoosting then
data.isBoosting = true
data._lastBoostTime = getTime()
end
pcall(function()
humanoid.WalkSpeed = activeMoveSpeed
end)
if humanoid.Health > 0 then
pcall(function()
humanoid:ChangeState(Enum.HumanoidStateType.Running)
end)
end
pcall(function()
root.Anchored = false
end)
end
local function heartbeatLoopV1()
while data.active do
task.wait(0.05)
if isRagdolledV1() then
forceExitRagdollV1()
elseif data.isBoosting then
if getTime() - (data._lastBoostTime or 0) > 0.35 or not isRagdolledV1() then
data.isBoosting = false
if data.cachedChar and data.cachedChar.humanoid then
pcall(function()
data.cachedChar.humanoid.WalkSpeed = getActiveMoveSpeed()
end)
end
end
end
end
end
antiRagdollController.start = function()
if data.active then
return
end
antiRagdollController.stop()
if not cacheCharacterV1() then
warn("[AntiRagdollV1] No se pudo cachear el personaje")
return
end
data.active = true
data.isBoosting = false
local connection2 = RunService.RenderStepped:Connect(function()
local currentCamera2 = workspace.CurrentCamera
if currentCamera2 and data.cachedChar and data.cachedChar.humanoid then
if currentCamera2.CameraSubject ~= data.cachedChar.humanoid then
currentCamera2.CameraSubject = data.cachedChar.humanoid
end
end
end)
table.insert(data.ragdollConnections, connection2)
local connection3 = localPlayer.CharacterAdded:Connect(function()
data.isBoosting = false
task.wait(0.5)
cacheCharacterV1()
end)
table.insert(data.ragdollConnections, connection3)
task.spawn(heartbeatLoopV1)
print("[AntiRagdollV1] Activado")
end
antiRagdollController.stop = function()
data.active = false
if data.isBoosting and data.cachedChar and data.cachedChar.humanoid then
pcall(function()
data.cachedChar.humanoid.WalkSpeed = getActiveMoveSpeed()
end)
end
data.isBoosting = false
disconnectAllV1()
data.cachedChar = nil
print("[AntiRagdollV1] Desactivado")
end
antiRagdollController.isRunning = function()
return data.active
end
end
antiRagdollV2State = {
Enabled = false,
Connection = nil,
ResetCooldown = 0,
}
enableAntiRagdollV2 = function()
if antiRagdollV2State.Connection then
return
end
antiRagdollV2State.Enabled = true
antiRagdollV2State.Connection = RunService.Heartbeat:Connect(function()
if not antiRagdollV2State.Enabled then
return
end
local character = localPlayer.Character
if not character then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoid or not humanoidRootPart then
return
end
local isActive = humanoid.Health <= 0
if not isActive then
local dead = Enum.HumanoidStateType.Dead
isActive = humanoid:GetState() == dead
end
if isActive then
return
end
local state = humanoid:GetState()
local time = getTime()
if
state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
then
if time - antiRagdollV2State.ResetCooldown > 0.15 then
antiRagdollV2State.ResetCooldown = time
pcall(function()
local gettingUp = Enum.HumanoidStateType.GettingUp
if humanoid:GetState() == gettingUp then
return
end
local isActive = humanoid.Health <= 0
if not isActive then
local dead = Enum.HumanoidStateType.Dead
isActive = humanoid:GetState() == dead
end
if isActive then
return
end
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
humanoidRootPart.Velocity = zeroVector
humanoidRootPart.RotVelocity = zeroVector
humanoidRootPart.AssemblyLinearVelocity = zeroVector
humanoidRootPart.AssemblyAngularVelocity = zeroVector
for _, descendant in ipairs(character:GetDescendants()) do
if descendant:IsA("Motor6D") then
descendant.Enabled = true
end
if descendant:IsA("Constraint") then
descendant.Enabled = true
end
end
workspace.CurrentCamera.CameraSubject = humanoid
local playerModule = localPlayer.PlayerScripts:FindFirstChild("PlayerModule")
if playerModule then
local controlModule = require(playerModule:FindFirstChild("ControlModule"))
if controlModule then
controlModule:Enable()
end
end
humanoid.AutoRotate = true
humanoid.PlatformStand = false
humanoid.Sit = false
end)
end
end
end)
end
disableAntiRagdollV2 = function()
antiRagdollV2State.Enabled = false
if antiRagdollV2State.Connection then
antiRagdollV2State.Connection:Disconnect()
antiRagdollV2State.Connection = nil
end
antiRagdollV2State.ResetCooldown = 0
end
setAntiRagdollMode = function(mode)
if antiRagdollController.isRunning() then
antiRagdollController.stop()
end
if antiRagdollV2State.Enabled then
disableAntiRagdollV2()
end
antiRagdollMode = mode
if mode == "v1" then
antiRagdollController.start()
elseif mode == "v2" then
enableAntiRagdollV2()
end
if _G.updateAntiRagdollUI then
_G.updateAntiRagdollUI(mode)
end
saveAllSettings()
end
antiDie = {
enabled = false,
heartConn = nil,
deathConns = {},
charConn = nil,
humanoid = nil,
}
do
local function stopDropBrainrot()
for _, deathConnection in ipairs(antiDie.deathConns) do
pcall(function()
deathConnection:Disconnect()
end)
end
antiDie.deathConns = {}
if antiDie.heartConn then
pcall(function()
antiDie.heartConn:Disconnect()
end)
antiDie.heartConn = nil
end
end
local function protectCharacterFromDeath(character)
if not character then
return
end
local humanoid = character:WaitForChild("Humanoid", 5)
if not humanoid then
return
end
humanoid.MaxHealth = math.huge
humanoid.Health = math.huge
pcall(function()
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
humanoid.BreakJointsOnDeath = false
end)
antiDie.humanoid = humanoid
table.insert(
antiDie.deathConns,
humanoid.StateChanged:Connect(function(old, new)
if not antiDie.enabled then
return
end
if new == Enum.HumanoidStateType.Dead then
humanoid.Health = math.huge
pcall(function()
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end)
end
end)
)
table.insert(
antiDie.deathConns,
humanoid:GetPropertyChangedSignal("Health"):Connect(function()
if antiDie.enabled and humanoid.Health < humanoid.MaxHealth then
humanoid.Health = math.huge
end
end)
)
if antiDie.heartConn then
pcall(function()
antiDie.heartConn:Disconnect()
end)
end
antiDie.heartConn = RunService.Heartbeat:Connect(function()
if antiDie.enabled and humanoid and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
humanoid.Health = math.huge
end
end)
end
reapplyAntiDie = function(character)
if not antiDie.enabled then
return
end
protectCharacterFromDeath(character or localPlayer.Character)
end
antiDie.start = function()
antiDie.enabled = true
stopDropBrainrot()
protectCharacterFromDeath(localPlayer.Character)
if antiDie.charConn then
pcall(function()
antiDie.charConn:Disconnect()
end)
end
antiDie.charConn = localPlayer.CharacterAdded:Connect(function(character)
if not antiDie.enabled then
return
end
task.wait(0.1)
stopDropBrainrot()
protectCharacterFromDeath(character)
end)
print("[AntiDie] Activado (Envy logic)")
end
antiDie.stop = function()
antiDie.enabled = false
stopDropBrainrot()
if antiDie.charConn then
pcall(function()
antiDie.charConn:Disconnect()
end)
antiDie.charConn = nil
end
local character = localPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if humanoid then
pcall(function()
humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
humanoid.MaxHealth = 100
humanoid.Health = 100
end)
end
antiDie.humanoid = nil
print("[AntiDie] Desactivado")
end
end
_G.AntiDie = antiDie
antiFlingShield = {
enabled = false,
loop = nil,
velocityThreshold = 80,
}
do
local function stabilizeRoot(root)
if not root or not root.Parent then
return
end
if batDesyncTpEnabled then
return
end
local assemblyLinearVelocity = nil
if
not pcall(function()
assemblyLinearVelocity = root.AssemblyLinearVelocity
end) or typeof(assemblyLinearVelocity) ~= "Vector3"
then
assemblyLinearVelocity = function()
return root.Velocity
end
local ok
ok, assemblyLinearVelocity = pcall(assemblyLinearVelocity)
if not ok or typeof(assemblyLinearVelocity) ~= "Vector3" then
return
end
end
if assemblyLinearVelocity.Magnitude <= antiFlingShield.velocityThreshold then
return
end
local stabilized = newVector3(0, assemblyLinearVelocity.Y, 0)
pcall(function()
root.AssemblyLinearVelocity = stabilized
end)
pcall(function()
root.AssemblyAngularVelocity = zeroVector
end)
pcall(function()
root.Velocity = stabilized
end)
pcall(function()
root.RotVelocity = zeroVector
end)
end
antiFlingShield.start = function()
antiFlingShield.enabled = true
if antiFlingShield.loop then
antiFlingShield.loop:Disconnect()
end
antiFlingShield.loop = RunService.Heartbeat:Connect(function()
if not antiFlingShield.enabled then
return
end
local character = localPlayer.Character
stabilizeRoot(character and character:FindFirstChild("HumanoidRootPart"))
end)
print("[AntiFlingShield] Activado (interno)")
end
end
antiFlingShield.stop = function()
antiFlingShield.enabled = false
if antiFlingShield.loop then
antiFlingShield.loop:Disconnect()
antiFlingShield.loop = nil
end
print("[AntiFlingShield] Desactivado (interno)")
end
_G.AntiFlingShield = antiFlingShield
do
local isEnabled = false
local function getRagBillboard()
local character = localPlayer.Character
if not character then
return nil, nil
end
local head = character:FindFirstChild("Head")
if not head then
return nil, nil
end
local playerGui = localPlayer.PlayerGui
local ragCountdownBillboard = playerGui:FindFirstChild("RagCountdownBillboard")
if ragCountdownBillboard then
ragCountdownBillboard:Destroy()
end
local billboardGui = Instance.new("BillboardGui")
billboardGui.Name = "RagCountdownBillboard"
billboardGui.Size = UDim2.new(0, 84, 0, 42)
billboardGui.StudsOffset = newVector3(0, 7, 0)
billboardGui.AlwaysOnTop = true
billboardGui.Adornee = head
billboardGui.Parent = playerGui
local rootPart = Instance.new("TextLabel")
rootPart.Size = UDim2.new(1, 0, 1, 0)
rootPart.AnchorPoint = Vector2.new(0.5, 0.5)
rootPart.Position = UDim2.new(0.5, 0, 0.5, 0)
rootPart.BackgroundTransparency = 1
rootPart.Font = Enum.Font.GothamBlack
rootPart.TextScaled = true
rootPart.TextColor3 = Color3.fromRGB(255, 255, 255)
rootPart.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
rootPart.TextStrokeTransparency = 1
rootPart.Text = ""
rootPart.Parent = billboardGui
local uiGradient = Instance.new("UIGradient", rootPart)
local data = {}
local object = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
local object1133 = ColorSequenceKeypoint.new(0.3, Color3.new(1, 1, 1))
local object1134 = ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1))
local object1135 = ColorSequenceKeypoint.new(0.7, Color3.new(1, 1, 1))
data[1] = object
data[2] = object1133
data[3] = object1134
data[4] = object1135
data[5] = ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
uiGradient.Color = ColorSequence.new(data)
uiGradient.Rotation = 45
uiGradient.Offset = Vector2.new(0, 0)
return billboardGui, rootPart
end
local function ragPunch(label, text)
if not (label and label.Parent) then
return
end
label.Text = text
end
showRagdollCountdown = function()
if isEnabled then
return
end
isEnabled = true
task.spawn(function()
local ragBillboard, object = getRagBillboard()
if not ragBillboard then
isEnabled = false
return
end
local value = 2.5
while value > 0 and ragBillboard.Parent do
ragPunch(object, string.format("%.1f", value))
task.wait(0.1)
value -= 0.1
end
if ragBillboard and ragBillboard.Parent then
ragPunch(object, "READY!")
task.wait(0.5)
if ragBillboard and ragBillboard.Parent then
ragBillboard:Destroy()
end
end
isEnabled = false
end)
end
end
local isActive
do
local snowVS
do
local connection2, clearESP, updateESP
do
local isActive = false
RunService.Heartbeat:Connect(function()
local character = localPlayer.Character
if not character then
isActive = false
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health <= 0 then
isActive = false
return
end
local state = humanoid:GetState()
local isActive1155 = state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
if isActive1155 and not isActive then
isActive = true
showRagdollCountdown()
elseif not isActive1155 then
isActive = false
end
end)
end
do
local data = {}
local data1157 = {}
local data1158 = {}
local extras = {}
local myAtt = nil
connection2 = nil
local value = 0
profileImageCache = {}
clearESP = function()
for k in pairs(data) do
pcall(function()
data[k]:Destroy()
end)
end
for k in pairs(data1157) do
pcall(function()
data1157[k]:Destroy()
end)
end
for k in pairs(data1158) do
for _, ln in ipairs(data1158[k]) do
pcall(function()
ln.Visible = false
ln:Remove()
end)
end
end
data = {}
data1157 = {}
data1158 = {}
for k in pairs(extras) do
for _, inst in pairs(extras[k]) do
pcall(function()
inst:Destroy()
end)
end
end
extras = {}
if myAtt then
pcall(function()
myAtt:Destroy()
end)
myAtt = nil
end
end
local function makeESPTracers()
if not (Drawing and type(Drawing.new) == "function") then
return nil
end
local color = getThemeColor()
local line = Drawing.new("Line")
line.Color = color
line.Thickness = 2.2
line.Transparency = 0.9
line.Visible = false
local mid = Drawing.new("Line")
mid.Color = color
mid.Thickness = 1.2
mid.Transparency = 0.74
mid.Visible = false
local line2 = Drawing.new("Line")
line2.Color = color
line2.Thickness = 0.6
line2.Transparency = 0.1
line2.Visible = false
return {
line,
mid,
line2,
}
end
updateESP = function()
local now = getTime()
if now - value < 0.05 then
return
end
value = now
if not espEnabled then
clearESP()
return
end
local character = localPlayer.Character
character = character and character:FindFirstChild("HumanoidRootPart")
if not character then
return
end
local myScreenPosition, myOnScreen = currentCamera:WorldToViewportPoint(character.Position)
local vector22 = Vector2.new(myScreenPosition.X, myScreenPosition.Y)
local currentPlayers = getPlayersCached()
local plrSet = {}
for _, p in ipairs(currentPlayers) do
plrSet[p] = true
end
for k in pairs(data) do
if not plrSet[k] then
pcall(function()
data[k]:Destroy()
end)
data[k] = nil
end
end
for k in pairs(data1157) do
if not plrSet[k] then
pcall(function()
data1157[k]:Destroy()
end)
data1157[k] = nil
end
end
for k in pairs(data1158) do
if not plrSet[k] then
for _, ln in ipairs(data1158[k]) do
pcall(function()
ln.Visible = false
ln:Remove()
end)
end
data1158[k] = nil
end
end
for k in pairs(extras) do
if not plrSet[k] then
for _, inst in pairs(extras[k]) do
pcall(function()
inst:Destroy()
end)
end
extras[k] = nil
end
end
local color = getThemeColor()
for _, player in ipairs(currentPlayers) do
if player ~= localPlayer then
local character2 = player.Character
if not character2 then
if data[player] then
pcall(function()
data[player]:Destroy()
end)
data[player] = nil
end
if data1157[player] then
pcall(function()
data1157[player]:Destroy()
end)
data1157[player] = nil
end
if data1158[player] then
for _, ln in ipairs(data1158[player]) do
pcall(function()
ln.Visible = false
end)
end
end
else
local humanoidRootPart = character2:FindFirstChild("HumanoidRootPart")
local head = character2:FindFirstChild("Head")
local humanoid = character2:FindFirstChildOfClass("Humanoid")
if humanoidRootPart and head and humanoid and humanoid.Health > 0 then
local highlight = data[player]
if not highlight or not highlight.Parent or highlight.Parent ~= character2 then
if highlight then
pcall(function()
highlight:Destroy()
end)
end
highlight = Instance.new("Highlight")
highlight.Name = "CloverHubESP"
highlight.FillColor = color
highlight.FillTransparency = 0.72
highlight.OutlineColor = color
highlight.OutlineTransparency = 0.05
highlight.Adornee = character2
highlight.Parent = character2
data[player] = highlight
end
local billboardGui = data1157[player]
if not billboardGui or not billboardGui.Parent then
if billboardGui then
pcall(function()
billboardGui:Destroy()
end)
end
billboardGui = Instance.new("BillboardGui")
billboardGui.Name = "ProfilePic"
billboardGui.Size = UDim2.new(0, 56, 0, 56)
billboardGui.StudsOffset = newVector3(0, 3.8, 0)
billboardGui.Adornee = head
billboardGui.AlwaysOnTop = true
billboardGui.Parent = head
local img = Instance.new("ImageLabel", billboardGui)
img.Size = UDim2.new(1, -6, 1, -6)
img.Position = UDim2.new(0, 3, 0, 3)
img.BackgroundTransparency = 1
img.Image = "rbxassetid://0"
img.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
local uiStroke = Instance.new("UIStroke", img)
uiStroke.Color = color
uiStroke.Thickness = 1.5
data1157[player] = billboardGui
task.spawn(function()
local userId = player.UserId
local image = profileImageCache[userId]
if not image then
local ok
ok, image = pcall(function()
return Players:GetUserThumbnailAsync(
userId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
end)
if ok and image and image ~= "" then
profileImageCache[userId] = image
else
image = "rbxassetid://0"
end
end
if img then
img.Image = image
end
end)
else
if billboardGui.Adornee ~= head then
billboardGui.Adornee = head
end
billboardGui.Enabled = true
end
local lines = data1158[player]
if not lines then
lines = makeESPTracers()
data1158[player] = lines or {}
end
if lines and #lines > 0 then
local position, onScreen =
currentCamera:WorldToViewportPoint(humanoidRootPart.Position)
if onScreen and position.Z > 0 and myOnScreen then
local vector23 = Vector2.new(position.X, position.Y)
for _, ln in ipairs(lines) do
ln.From = vector22
ln.To = vector23
ln.Visible = true
end
else
for _, ln in ipairs(lines) do
ln.Visible = false
end
end
end
local ex = extras[player]
if not ex then
ex = {}
extras[player] = ex
end
if not ex.box or not ex.box.Parent or ex.box.Adornee ~= character2 then
if ex.box then
pcall(function()
ex.box:Destroy()
end)
end
local espBox = Instance.new("SelectionBox")
espBox.Name = "CloverHubESP"
espBox.Adornee = character2
espBox.Color3 = color
espBox.LineThickness = 0.035
espBox.SurfaceTransparency = 1
espBox.Parent = character2
ex.box = espBox
end
if not (Drawing and type(Drawing.new) == "function") then
local myCharacter = localPlayer.Character
local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
if myRoot then
if not myAtt or myAtt.Parent ~= myRoot then
if myAtt then
pcall(function()
myAtt:Destroy()
end)
end
myAtt = Instance.new("Attachment")
myAtt.Name = "CloverHubTracerA0"
myAtt.Parent = myRoot
end
if not ex.att or ex.att.Parent ~= humanoidRootPart then
if ex.att then
pcall(function()
ex.att:Destroy()
end)
end
ex.att = Instance.new("Attachment")
ex.att.Name = "CloverHubTracerA1"
ex.att.Parent = humanoidRootPart
end
if not ex.beam or not ex.beam.Parent then
local beam = Instance.new("Beam")
beam.Name = "CloverHubESP"
beam.Width0 = 0.18
beam.Width1 = 0.18
beam.FaceCamera = true
beam.LightEmission = 1
beam.LightInfluence = 0
beam.Segments = 1
beam.Color = ColorSequence.new(color)
beam.Transparency = NumberSequence.new(0.1)
beam.Parent = humanoidRootPart
ex.beam = beam
end
ex.beam.Attachment0 = myAtt
ex.beam.Attachment1 = ex.att
ex.beam.Enabled = true
end
end
else
if data[player] then
pcall(function()
data[player]:Destroy()
end)
data[player] = nil
end
if data1157[player] then
pcall(function()
data1157[player]:Destroy()
end)
data1157[player] = nil
end
if data1158[player] then
for _, ln in ipairs(data1158[player]) do
pcall(function()
ln.Visible = false
end)
end
end
end
end
end
end
end
end
do
local function startESPLoop()
if connection2 then
connection2:Disconnect()
end
connection2 = RunService.RenderStepped:Connect(updateESP)
end
local function stopEnemySpeed()
if connection2 then
connection2:Disconnect()
connection2 = nil
end
clearESP()
end
toggleESP = function(on)
espEnabled = on
if on then
startESPLoop()
else
stopEnemySpeed()
end
if setESPVIsual then
setESPVIsual(on)
end
end
end
end
do
local value = 0
updateEnemySpeedLabels = function()
value += 1
if value < 6 then
return
end
value = 0
local color = getThemeColor()
local players = getPlayersCached()
for i = 1, #players do
local player = players[i]
if player ~= localPlayer then
local character = player.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if humanoidRootPart and humanoid and humanoid.Health > 0 then
local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
local speed = sqrt(
assemblyLinearVelocity.X * assemblyLinearVelocity.X
+ assemblyLinearVelocity.Z * assemblyLinearVelocity.Z
)
local label = enemySpeedLabels[player]
if not label then
local head = character:FindFirstChild("Head")
if head then
local billboardGui = Instance.new("BillboardGui")
billboardGui.Size = UDim2.new(0, 100, 0, 25)
billboardGui.StudsOffset = newVector3(0, 5.5, 0)
billboardGui.AlwaysOnTop = true
billboardGui.Name = "EnemySpeedGui"
billboardGui.Parent = head
label = Instance.new("TextLabel", billboardGui)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextColor3 = color
label.Font = Enum.Font.GothamBold
label.TextScaled = true
label.TextStrokeTransparency = 1
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
enemySpeedLabels[player] = label
end
elseif label.Parent and label.Parent.Parent ~= character then
local head = character:FindFirstChild("Head")
if head then
label.Parent.Parent = head
end
end
if label then
label.Text = string.format("%.1f", speed)
if label.TextColor3 ~= color then
label.TextColor3 = color
end
end
else
local label = enemySpeedLabels[player]
if label and label.Parent and label.Parent.Parent then
label.Parent.Parent = nil
end
enemySpeedLabels[player] = nil
end
end
end
end
end
startEnemySpeed = function()
if enemySpeedConn then
enemySpeedConn:Disconnect()
end
enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end
stopEnemySpeed = function()
if enemySpeedConn then
enemySpeedConn:Disconnect()
enemySpeedConn = nil
end
end
do
local function findNearestPlayer()
local character = localPlayer.Character
if character then
local rootPart = character:FindFirstChild("HumanoidRootPart")
if not rootPart then
return nil
end
local position = rootPart.Position
local playersCached = getPlayersCached()
local closestDistance = huge
local closestPlayer = nil
for i = 1, #playersCached do
local player = playersCached[i]
if player ~= localPlayer then
local character2 = player.Character
if character2 then
local rootPart = character2:FindFirstChild("HumanoidRootPart")
if rootPart then
local humanoid = character2:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.Health > 0 then
local deltaX = rootPart.Position.X - position.X
local deltaY = rootPart.Position.Y - position.Y
local deltaZ = rootPart.Position.Z - position.Z
local distance = deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ
if distance < closestDistance then
closestDistance = distance
closestPlayer = rootPart
end
end
end
end
end
end
return closestPlayer
end
return nil
end
local function bodyLockTick()
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then
return
end
local rootPart = findNearestPlayer()
if not rootPart then
if not humanoid.AutoRotate then
humanoid.AutoRotate = true
end
return
end
if bodyLockRange < (rootPart.Position - humanoidRootPart.Position).Magnitude then
if not humanoid.AutoRotate then
humanoid.AutoRotate = true
end
return
end
if humanoid.AutoRotate then
humanoid.AutoRotate = false
end
local assemblyLinearVelocity = rootPart.AssemblyLinearVelocity
local vector = rootPart.Position
+ assemblyLinearVelocity * clamp(assemblyLinearVelocity.Magnitude / 80, 0.08, 0.35)
local parent = rootPart.Parent and rootPart.Parent:FindFirstChild("Head")
parent = parent and parent.Position.Y or rootPart.Position.Y
local y = humanoidRootPart.Position.Y
local hipHeight = humanoid.HipHeight or 0
local z = vector.Z
local vector1217 =
newVector3(vector.X, humanoidRootPart.Position.Y + clamp((parent - y + hipHeight) * 0.15, -1.5, 1.5), z)
if 0.1 < (vector1217 - humanoidRootPart.Position).Magnitude then
local object = lookAtCFrame(humanoidRootPart.Position, vector1217)
local _, object1265 = (humanoidRootPart.CFrame:Inverse() * object):ToEulerAnglesXYZ()
humanoidRootPart.AssemblyAngularVelocity =
humanoidRootPart.CFrame:VectorToWorldSpace(newVector3(0, clamp(object1265, -2.5, 2.5) * 42, 0))
end
end
startBodyLock = function()
if _bodyLockConn then
_bodyLockConn:Disconnect()
end
local acc = 0
_bodyLockConn = RunService.Heartbeat:Connect(function(deltaTime)
if not bodyLockEnabled then
return
end
if _blSuppressCount > 0 then
return
end
acc += deltaTime
if acc < 0.033 then
return
end
acc = 0
bodyLockTick()
end)
end
end
stopBodyLock = function()
if _bodyLockConn then
_bodyLockConn:Disconnect()
_bodyLockConn = nil
end
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
if humanoidRootPart then
humanoidRootPart.AssemblyAngularVelocity = zeroVector
humanoidRootPart.AssemblyLinearVelocity =
newVector3(humanoidRootPart.AssemblyLinearVelocity.X, -0.1, humanoidRootPart.AssemblyLinearVelocity.Z)
end
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid.AutoRotate = true
end
end
_suppressBodyLock = function()
_blSuppressCount = _blSuppressCount + 1
if _blSuppressCount == 1 and bodyLockEnabled then
_blWasEnabled = true
stopBodyLock()
if bodyLockSetVisual then
bodyLockSetVisual(false)
end
if _blRestoreTimer then
task.cancel(_blRestoreTimer)
_blRestoreTimer = nil
end
_blSmoothRestore = false
end
end
_unsuppressBodyLock = function(delayed)
if _blSuppressCount > 0 then
_blSuppressCount = _blSuppressCount - 1
end
if _blSuppressCount == 0 and _blWasEnabled then
_blWasEnabled = false
if _blRestoreTimer then
pcall(task.cancel, _blRestoreTimer)
_blRestoreTimer = nil
end
local function restore()
_blRestoreTimer = nil
if bodyLockEnabled then
_blSmoothRestore = true
startBodyLock()
if bodyLockSetVisual then
bodyLockSetVisual(true)
end
task.delay(0.5, function()
_blSmoothRestore = false
end)
end
end
if delayed then
_blRestoreTimer = task.delay(1, restore)
else
restore()
end
end
end
setupSpeedIndicator = function(callback)
local head = callback:WaitForChild("Head", 5)
if not head then
return
end
local cloverHubSpeedIndicator = head:FindFirstChild("CloverHubSpeedIndicator")
if cloverHubSpeedIndicator then
cloverHubSpeedIndicator:Destroy()
end
local discordText = head:FindFirstChild("DiscordText")
if discordText then
discordText:Destroy()
end
local billboardGui = Instance.new("BillboardGui", head)
billboardGui.Name = "CloverHubSpeedIndicator"
billboardGui.Size = UDim2.new(0, 340, 0, 92)
billboardGui.StudsOffset = newVector3(0, 2.9, 0)
billboardGui.AlwaysOnTop = true
billboardGui.LightInfluence = 0
speedLabel = Instance.new("TextLabel", billboardGui)
speedLabel.Name = "Speed"
speedLabel.Size = UDim2.new(1, 0, 0, 30)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Spd: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextStrokeTransparency = 0.08
speedLabel.Font = Enum.Font.GothamBlack
speedLabel.TextSize = 24
speedLabel.TextXAlignment = Enum.TextXAlignment.Center
speedLabel.ZIndex = 10
local speedBranding = addCloverBranding(
billboardGui,
UDim2.new(0, 0, 0, 32),
UDim2.new(1, 0, 0, 56),
44
)
if speedBranding then
speedBranding.Text = "discord.gg/Y2drTdjsjH"
speedBranding.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBranding.TextSize = 30
speedBranding.Font = Enum.Font.GothamBlack
speedBranding.TextTransparency = 0
speedBranding.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
speedBranding.TextStrokeTransparency = 0
-- remove any dark gradient that makes it unreadable
local oldGrad = speedBranding:FindFirstChildOfClass("UIGradient")
if oldGrad then oldGrad:Destroy() end
local brandStroke = speedBranding:FindFirstChildOfClass("UIStroke")
if not brandStroke then
brandStroke = Instance.new("UIStroke", speedBranding)
end
brandStroke.Thickness = 3.5
brandStroke.Color = Color3.fromRGB(0, 0, 0)
brandStroke.Transparency = 0
end
end
do
local clone = nil
startUnwalk = function()
local character = localPlayer.Character
if not character then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
for _, deltaTime in ipairs(humanoid:GetPlayingAnimationTracks()) do
pcall(function()
deltaTime:Stop()
end)
end
end
local animate = character:FindFirstChild("Animate")
if animate then
clone = animate:Clone()
animate:Destroy()
end
end
stopUnwalk = function()
local character = localPlayer.Character
if character then
if not character:FindFirstChild("Animate") then
local starterCharacterScripts = game:GetService("StarterPlayer")
:FindFirstChildOfClass("StarterCharacterScripts")
starterCharacterScripts = starterCharacterScripts
and starterCharacterScripts:FindFirstChild("Animate")
if starterCharacterScripts then
starterCharacterScripts:Clone().Parent = character
elseif clone then
clone:Clone().Parent = character
end
end
end
clone = nil
end
end
refreshSpeedModeLabel = function()
if modeValLbl then
if laggerCarryToggled then
modeValLbl.Text = "Lagger Carry"
elseif laggerToggled then
modeValLbl.Text = "Lagger"
elseif speedMode then
modeValLbl.Text = "Carry"
else
modeValLbl.Text = "Normal"
end
end
if laggerCarryToggled then
_G.AceCurrentSpeedMode = "Lagger Carry"
elseif laggerToggled then
_G.AceCurrentSpeedMode = "Lagger"
elseif speedMode then
_G.AceCurrentSpeedMode = "Carry"
else
_G.AceCurrentSpeedMode = "Normal"
end
if setCarryModeVisual then
setCarryModeVisual(speedMode)
end
if setLaggerModeVisual then
setLaggerModeVisual(laggerToggled)
end
if setLaggerCarryVisual then
setLaggerCarryVisual(laggerCarryToggled)
end
if carryController then
carryController.speedToggled = speedMode
if laggerCarryToggled then
carryController:setLaggerMode(2)
elseif laggerToggled then
carryController:setLaggerMode(1)
else
carryController:setLaggerMode(0)
end
end
end
resetMovementState = function()
refreshSpeedModeLabel()
if mobSetCarry then
mobSetCarry(speedMode)
end
if setLaggerModeVisual then
setLaggerModeVisual(laggerToggled)
end
if setLaggerCarryVisual then
setLaggerCarryVisual(laggerCarryToggled)
end
if carryController then
carryController.speedToggled = speedMode
if laggerCarryToggled then
carryController:setLaggerMode(2)
elseif laggerToggled then
carryController:setLaggerMode(1)
else
carryController:setLaggerMode(0)
end
end
end
toggleCarryMode = function()
if laggerToggled or laggerCarryToggled then
laggerToggled = false
laggerCarryToggled = false
speedMode = true
else
speedMode = not speedMode
end
resetMovementState()
end
toggleLaggerMode = function()
if laggerCarryToggled then
laggerCarryToggled = false
end
speedMode = false
laggerToggled = not laggerToggled
resetMovementState()
end
toggleLaggerCarryMode = function()
if laggerToggled then
laggerToggled = false
end
speedMode = false
laggerCarryToggled = not laggerCarryToggled
resetMovementState()
end
-- Automatic mode cycle is restricted to Carry Speed / Normal.
-- Lagger Normal and Lagger Carry remain manual-only and are never
-- activated or changed by this automatic cycle.
toggleLaggerCycle = function()
laggerToggled = false
laggerCarryToggled = false
speedMode = not speedMode
resetMovementState()
end
stopAutoLeft = function()
if alConn then
alConn:Disconnect()
alConn = nil
end
alPhase = 1
local character = localPlayer.Character
if character then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:Move(zeroVector, false)
end
end
if autoLeftSetVisual then
autoLeftSetVisual(false)
end
if mobSetAutoLeft then
mobSetAutoLeft(false)
end
_unsuppressBodyLock(true)
end
startAutoLeft = function()
if not _G.AmbitiousSafeModeTryStart() then
autoLeftEnabled = false
if autoLeftSetVisual then
autoLeftSetVisual(false)
end
return
end
if autoRightEnabled then
autoRightEnabled = false
stopAutoRight()
if autoRightSetVisual then
autoRightSetVisual(false)
end
if mobSetAutoRight then
mobSetAutoRight(false)
end
end
disableAllAimbots()
_suppressBodyLock()
if alConn then
alConn:Disconnect()
end
alPhase = 1
alConn = RunService.Heartbeat:Connect(function()
if not autoLeftEnabled then
return
end
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not humanoid then
return
end
local object = NS
if alPhase == 1 then
local position = humanoidRootPart.Position
if (newVector3(AP.L1.X, humanoidRootPart.Position.Y, AP.L1.Z) - position).Magnitude < 1 then
alPhase = 2
local vector = AP.L2 - humanoidRootPart.Position
local unit = newVector3(vector.X, 0, vector.Z).Unit
humanoid:Move(unit, false)
humanoidRootPart.AssemblyLinearVelocity =
newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
return
end
local vector = AP.L1 - humanoidRootPart.Position
local unit = newVector3(vector.X, 0, vector.Z).Unit
humanoid:Move(unit, false)
humanoidRootPart.AssemblyLinearVelocity =
newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
elseif alPhase == 2 then
local position = humanoidRootPart.Position
if (newVector3(AP.L2.X, humanoidRootPart.Position.Y, AP.L2.Z) - position).Magnitude < 1 then
humanoid:Move(zeroVector, false)
humanoidRootPart.AssemblyLinearVelocity = zeroVector
autoLeftEnabled = false
if alConn then
alConn:Disconnect()
alConn = nil
end
alPhase = 1
if autoLeftSetVisual then
autoLeftSetVisual(false)
end
if mobSetAutoLeft then
mobSetAutoLeft(false)
end
_unsuppressBodyLock(true)
local vector = newVector3(AP.L_FACE.X, humanoidRootPart.Position.Y, AP.L_FACE.Z)
if (vector - humanoidRootPart.Position).Magnitude > 0.01 then
humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position, vector)
end
return
end
local vector = AP.L2 - humanoidRootPart.Position
local unit = newVector3(vector.X, 0, vector.Z).Unit
humanoid:Move(unit, false)
humanoidRootPart.AssemblyLinearVelocity =
newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
end
end)
end
stopAutoRight = function()
if arConn then
arConn:Disconnect()
arConn = nil
end
arPhase = 1
local character = localPlayer.Character
if character then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:Move(zeroVector, false)
end
end
if autoRightSetVisual then
autoRightSetVisual(false)
end
if mobSetAutoRight then
mobSetAutoRight(false)
end
_unsuppressBodyLock(true)
end
startAutoRight = function()
if not _G.AmbitiousSafeModeTryStart() then
autoRightEnabled = false
if autoRightSetVisual then
autoRightSetVisual(false)
end
return
end
if autoLeftEnabled then
autoLeftEnabled = false
stopAutoLeft()
if autoLeftSetVisual then
autoLeftSetVisual(false)
end
if mobSetAutoLeft then
mobSetAutoLeft(false)
end
end
disableAllAimbots()
_suppressBodyLock()
if arConn then
arConn:Disconnect()
end
arPhase = 1
arConn = RunService.Heartbeat:Connect(function()
if not autoRightEnabled then
return
end
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not humanoid then
return
end
local object = NS
if arPhase == 1 then
local position = humanoidRootPart.Position
if (newVector3(AP.R1.X, humanoidRootPart.Position.Y, AP.R1.Z) - position).Magnitude < 1 then
arPhase = 2
local vector = AP.R2 - humanoidRootPart.Position
local unit = newVector3(vector.X, 0, vector.Z).Unit
humanoid:Move(unit, false)
humanoidRootPart.AssemblyLinearVelocity =
newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
return
end
local vector = AP.R1 - humanoidRootPart.Position
local unit = newVector3(vector.X, 0, vector.Z).Unit
humanoid:Move(unit, false)
humanoidRootPart.AssemblyLinearVelocity =
newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
elseif arPhase == 2 then
local position = humanoidRootPart.Position
if (newVector3(AP.R2.X, humanoidRootPart.Position.Y, AP.R2.Z) - position).Magnitude < 1 then
humanoid:Move(zeroVector, false)
humanoidRootPart.AssemblyLinearVelocity = zeroVector
autoRightEnabled = false
if arConn then
arConn:Disconnect()
arConn = nil
end
arPhase = 1
if autoRightSetVisual then
autoRightSetVisual(false)
end
if mobSetAutoRight then
mobSetAutoRight(false)
end
_unsuppressBodyLock(true)
local vector = newVector3(AP.R_FACE.X, humanoidRootPart.Position.Y, AP.R_FACE.Z)
if (vector - humanoidRootPart.Position).Magnitude > 0.01 then
humanoidRootPart.CFrame = newCFrame(humanoidRootPart.Position, vector)
end
return
end
local vector = AP.R2 - humanoidRootPart.Position
local unit = newVector3(vector.X, 0, vector.Z).Unit
humanoid:Move(unit, false)
humanoidRootPart.AssemblyLinearVelocity =
newVector3(unit.X * object, humanoidRootPart.AssemblyLinearVelocity.Y, unit.Z * object)
end
end)
end
getClosestTarget = function()
local character = localPlayer.Character
if not character then
return nil
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return nil
end
local position = humanoidRootPart.Position
local playersCached = getPlayersCached()
local object1342 = huge
local object1343 = nil
for i = 1, #playersCached do
local player = playersCached[i]
if player ~= localPlayer then
local character2 = player.Character
if character2 then
local rootPart = character2:FindFirstChild("HumanoidRootPart")
if rootPart then
local humanoid = character2:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.Health > 0 then
local value = rootPart.Position.X - position.X
local value1350 = rootPart.Position.Y - position.Y
local value1351 = rootPart.Position.Z - position.Z
local object13421307 = value * value + value1350 * value1350 + value1351 * value1351
if object13421307 < object1342 then
object1342 = object13421307
object1343 = rootPart
end
end
end
end
end
end
return object1343
end
trySwing = function()
pcall(function()
local character = localPlayer.Character
if not character then
return
end
local tool = character:FindFirstChildOfClass("Tool")
if tool and not isBatTool(tool) then
return
end
local bat = findBat()
if bat then
if bat.Parent ~= character then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
pcall(function()
humanoid:EquipTool(bat)
end)
end
end
pcall(function()
bat:Activate()
end)
end
end)
end
stopAimbotAdapt = function()
AIMBOT_STICKY_TARGET = nil
if disableBatAim then
disableBatAim()
end
_unsuppressBodyLock(true)
end
startAimbotAdapt = function()
_suppressBodyLock()
if enableBatAim then
enableBatAim()
end
end
disableAutoBat = function()
autoBatEnabled = false
if autoBatSetVisual then
autoBatSetVisual(false)
end
if mobSetAutoBat then
mobSetAutoBat(false)
end
if _G.NewBatAimbot then
_G.NewBatAimbot.setEnabled(false)
end
if type(stopAimbotAdapt) == "function" then
pcall(stopAimbotAdapt)
end
end
enableAutoBat = function()
if not _G.AmbitiousSafeModeTryStart or not _G.AmbitiousSafeModeTryStart() then
autoBatEnabled = false
if autoBatSetVisual then
autoBatSetVisual(false)
end
return
end
if autoLeftEnabled then
autoLeftEnabled = false
if autoLeftSetVisual then
autoLeftSetVisual(false)
end
stopAutoLeft()
end
if autoRightEnabled then
autoRightEnabled = false
if autoRightSetVisual then
autoRightSetVisual(false)
end
stopAutoRight()
end
if batDesyncTpEnabled and type(toggleBatDesyncTp) == "function" then
toggleBatDesyncTp()
end
if autoBatV2Enabled and type(disableBatV2) == "function" then
disableBatV2()
end
if batAimEnabled and type(disableBatAim) == "function" then
disableBatAim()
end
autoBatEnabled = true
if autoBatSetVisual then
autoBatSetVisual(true)
end
if mobSetAutoBat then
mobSetAutoBat(true)
end
if _G.NewBatAimbot then
_G.NewBatAimbot.setEnabled(true)
end
if type(startAimbotAdapt) == "function" then
pcall(startAimbotAdapt)
end
end
BAT_V2_SPEED = BAT_V2_SPEED or 55
BAT_V2_HIT_DIST = BAT_V2_HIT_DIST or 13
BAT_V2_LEAD_STUDS = BAT_V2_LEAD_STUDS or 3
BAT_V2_BODY_LOCK_RANGE = BAT_V2_BODY_LOCK_RANGE or 60
snowVS = _G.SnowVS or {}
_G.SnowVS = snowVS
snowVS.BatBypass = snowVS.BatBypass or {}
snowVS.AimbotBypassV2 = snowVS.BatBypass
do
local batBypass = snowVS.BatBypass
batBypass.Enabled = batBypass.Enabled or false
batBypass.Connection = batBypass.Connection or nil
batBypass.Z = batBypass.Z
or {
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
batBypass.ZCFG = batBypass.ZCFG
or {
FOLLOW_SPEED = BAT_V2_SPEED,
ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
MIN_FOLLOW_DISTANCE = 1,
PREDICTION_TIME = 0.22,
PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
MAX_VELOCITY_CHANGE = 150,
VELOCITY_SMOOTHING = 0.2,
MAX_HORIZONTAL_VELOCITY = 80,
SERVER_TICKRATE = 0.016666666666666666,
MIN_PING_COMPENSATION = 0.03,
MAX_PING_COMPENSATION = 0.25,
ACCELERATION_PREDICTION_WEIGHT = 0.3,
DIRECTION_CHANGE_DETECTION_TIME = 0.12,
QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
GRAVITY = 196.2,
AIR_CONTROL_FACTOR = 0.8,
MIN_AIRBORNE_TIME = 0.08,
}
local function averageVectors(vectors)
if #vectors == 0 then
return Vector3.zero
end
local sum = Vector3.zero
for _, entry in ipairs(vectors) do
sum += entry
end
return sum / #vectors
end
local function pushBounded(history, entry, maxEntries)
table.insert(history, entry)
if #history > maxEntries then
table.remove(history, 1)
end
end
batBypass.FindBat = function()
local character = localPlayer.Character
if not character then
return nil
end
local tool = character:FindFirstChildOfClass("Tool")
if tool then
local lowercaseText = tool.Name:lower()
if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
return tool
end
end
local backpack = localPlayer:FindFirstChildOfClass("Backpack")
if backpack then
for _, child in ipairs(backpack:GetChildren()) do
if child:IsA("Tool") then
local lowercaseText = child.Name:lower()
if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
return child
end
end
end
end
return nil
end
local function resetPredictionState()
local z = batBypass.Z
z.targetPlayer = nil
z.lastTargetPos = nil
z.targetVelocity = Vector3.zero
z.smoothedVelocity = Vector3.zero
z.velocityHistory = {}
z.accelerationHistory = {}
z.aerialVelocityHistory = {}
z.previousDirection = nil
z.airborneTime = 0
end
local function findClosestPlayer(rootPart)
local closestDistance = math.huge
local closestPlayer = nil
for _, player in ipairs(Players:GetPlayers()) do
if player ~= localPlayer and player.Character then
local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if humanoidRootPart and humanoid and humanoid.Health > 0 then
local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
if magnitude < closestDistance then
closestDistance = magnitude
closestPlayer = player
end
end
end
end
return closestPlayer
end
local function applyAngularAim(rootPart, direction)
if direction.Magnitude < 0.01 then
return
end
local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
or Vector3.zero
end
local function updatePing()
local ok, result = pcall(function()
return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
end)
local z = batBypass.Z
if ok and type(result) == "number" then
z.realPingMs = math.floor(result)
end
z.currentPing = math.clamp(
z.realPingMs / 1000,
batBypass.ZCFG.MIN_PING_COMPENSATION,
batBypass.ZCFG.MAX_PING_COMPENSATION
)
end
batBypass.PingLoopStarted = batBypass.PingLoopStarted or false
if not batBypass.PingLoopStarted then
batBypass.PingLoopStarted = true
task.spawn(function()
while true do
pcall(updatePing)
task.wait(0.5)
end
end)
end
batBypass.StartBodyLock = function() end
batBypass.StopBodyLock = function() end
local V2 = {
ANG = "_GB_AngV",
ATT = "_GB_Att",
CLEAN = {
"LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
"AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock",
},
conn = nil,
safetyConn = nil,
target = nil,
equipped = false,
intendedVelocity = Vector3.zero,
attachment = nil,
angularVelocity = nil,
speed = 56.5,
swingRange = 12,
}
function V2.cleanMovers(root)
if not root then
return
end
pcall(function()
for _, n in ipairs(V2.CLEAN) do
local c = root:FindFirstChild(n)
if c then
c:Destroy()
end
end
for _, child in ipairs(root:GetChildren()) do
if child.Name ~= V2.ANG and child.Name ~= V2.ATT then
local ln = child.Name:lower()
if ln:find("lockb") or ln:find("lockangv") or ln:find("batlock") or ln:find("antiaim") or ln:find("velocitylock") then
child:Destroy()
end
end
end
end)
end
function V2.ensureAngular(root)
if not root then
return
end
pcall(function()
local a = root:FindFirstChild(V2.ANG)
if a then
a:Destroy()
end
local b = root:FindFirstChild(V2.ATT)
if b then
b:Destroy()
end
end)
local att = Instance.new("Attachment")
att.Name = V2.ATT
att.Parent = root
local angV = Instance.new("AngularVelocity")
angV.Name = V2.ANG
angV.Attachment0 = att
angV.RelativeTo = Enum.ActuatorRelativeTo.World
angV.MaxTorque = math.huge
angV.AngularVelocity = Vector3.zero
angV.Parent = root
V2.attachment = att
V2.angularVelocity = angV
end
function V2.removeAngular()
pcall(function()
if V2.angularVelocity and V2.angularVelocity.Parent then
V2.angularVelocity:Destroy()
end
end)
pcall(function()
if V2.attachment and V2.attachment.Parent then
V2.attachment:Destroy()
end
end)
V2.angularVelocity = nil
V2.attachment = nil
end
function V2.pickTarget(root)
local best, bestD = nil, math.huge
for _, p in ipairs(Players:GetPlayers()) do
if p ~= localPlayer and p.Character then
local hrp = p.Character:FindFirstChild("HumanoidRootPart")
local hum = p.Character:FindFirstChildOfClass("Humanoid")
if hrp and hum and hum.Health > 0 then
local d = (hrp.Position - root.Position).Magnitude
if d < bestD then
bestD = d
best = hrp
end
end
end
end
return best, bestD
end
batBypass.Stop = function()
batBypass.Enabled = false
if _G.NewBatAimbot then
_G.NewBatAimbot.setEnabled(false)
end

V2.equipped = false
V2.target = nil
if V2.conn then
V2.conn:Disconnect()
V2.conn = nil
end
if V2.safetyConn then
V2.safetyConn:Disconnect()
V2.safetyConn = nil
end
batBypass.Connection = nil
local c = localPlayer.Character
local root = c and c:FindFirstChild("HumanoidRootPart")
if root then
pcall(function()
root.Velocity = root.Velocity * 0.3
end)
end
local hum = c and c:FindFirstChildOfClass("Humanoid")
if hum then
hum.AutoRotate = true
end
if V2.angularVelocity then
pcall(function()
V2.angularVelocity.AngularVelocity = Vector3.zero
end)
end
V2.removeAngular()
resetPredictionState()
batBypass.Z.lastActivationTime = 0
end
batBypass.Start = function()
if batBypass.Connection then
return
end
local c0 = localPlayer.Character
local hum0 = c0 and c0:FindFirstChildOfClass("Humanoid")
local root0 = c0 and c0:FindFirstChild("HumanoidRootPart")
if not hum0 or not root0 then
return
end
batBypass.Enabled = true
V2.equipped = false
V2.target = nil
V2.intendedVelocity = Vector3.zero
V2.cleanMovers(root0)
V2.ensureAngular(root0)
V2.conn = RunService.Heartbeat:Connect(function()
if not batBypass.Enabled then
return
end
local char = localPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if not hrp or not hum or hum.Health <= 0 then
return
end
if _G.AceGetAntiBypassAimbotSpeed then
V2.speed = _G.AceGetAntiBypassAimbotSpeed()
end
batBypass.ZCFG.FOLLOW_SPEED = V2.speed
V2.cleanMovers(hrp)
if not V2.angularVelocity or not V2.angularVelocity.Parent then
V2.ensureAngular(hrp)
end
if not V2.equipped then
V2.equipped = true
if not char:FindFirstChildOfClass("Tool") then
local b = batBypass.FindBat()
if b then
pcall(function()
hum:EquipTool(b)
end)
end
end
end
local target, dist = V2.pickTarget(hrp)
-- stay on the current target unless another one is clearly closer
if target and V2.target and V2.target ~= target and V2.target.Parent then
local oldHum = V2.target.Parent:FindFirstChildOfClass("Humanoid")
if oldHum and oldHum.Health > 0 then
local dOld = (V2.target.Position - hrp.Position).Magnitude
if dOld <= dist * 1.3 + 3 then
target = V2.target
dist = dOld
end
end
end
if not target then
V2.target = nil
hum.AutoRotate = true
if V2.angularVelocity then
V2.angularVelocity.AngularVelocity = Vector3.zero
end
return
end
V2.target = target
local tVel = target.AssemblyLinearVelocity
local flatVel = Vector3.new(tVel.X, 0, tVel.Z)
local leadT = math.clamp(dist / math.max(V2.speed, 1), 0.05, 0.25)
local aimPos = target.Position
+ flatVel * leadT
+ target.CFrame.LookVector * (flatVel.Magnitude < 1 and 1.5 or 0.5)
local delta = aimPos - hrp.Position
local flat = Vector3.new(delta.X, 0, delta.Z)
hum.AutoRotate = false
if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 then
local curY = hrp.Orientation.Y
local yawD = (math.deg(math.atan2(-flat.X, -flat.Z)) - curY + 180) % 360 - 180
local curX = hrp.Orientation.X
local pitchD = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - curX + 180) % 360 - 180
local rotY = math.clamp(math.rad(yawD) * 40, -28, 28)
local rotX = math.clamp(math.rad(pitchD) * 40, -28, 28)
local yawR = math.rad(hrp.Orientation.Y)
local fwd = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
V2.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
else
V2.angularVelocity.AngularVelocity = Vector3.zero
end
local spd = V2.speed * math.clamp(flat.Magnitude / 3, 0.4, 1)
V2.intendedVelocity = (flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
+ (math.abs(delta.Y) > 0.8 and Vector3.new(0, math.sign(delta.Y) * spd, 0) or Vector3.new(0, -2, 0))
hrp.AssemblyLinearVelocity = V2.intendedVelocity
hrp.Velocity = V2.intendedVelocity
if flat.Magnitude > 0.3 then
pcall(function()
hum:Move(flat.Unit, false)
end)
else
pcall(function()
hum:Move(Vector3.zero, false)
end)
end
if dist <= V2.swingRange and (getTime() - (V2.lastSwing or 0)) >= 0.08 then
V2.lastSwing = getTime()
local bat = char:FindFirstChildOfClass("Tool")
if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
pcall(function()
bat:Activate()
local re = bat:FindFirstChildWhichIsA("RemoteEvent")
if re then
re:FireServer()
end
end)
end
end
end)
batBypass.Connection = V2.conn
V2.safetyConn = RunService.RenderStepped:Connect(function()
if not batBypass.Enabled then
return
end
local char = localPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then
return
end
if V2.target and V2.target.Parent then
local delta = V2.target.Position - hrp.Position
local flat = Vector3.new(delta.X, 0, delta.Z)
if flat.Magnitude > 0.3 then
pcall(function()
hum:Move(flat.Unit, false)
end)
end
if math.abs(hrp.AssemblyLinearVelocity.X - V2.intendedVelocity.X) > 30
or math.abs(hrp.AssemblyLinearVelocity.Z - V2.intendedVelocity.Z) > 30 then
hrp.AssemblyLinearVelocity = V2.intendedVelocity
end
end
local v = hrp.Velocity
if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
hrp.Velocity = V2.intendedVelocity
end
V2.cleanMovers(hrp)
end)
end
batBypass.Toggle = function()
if batBypass.Enabled then
batBypass.Stop()
else
batBypass.Start()
end
end
end
local desyncLoopRunning, networkSpamThread, startCharacterRecoveryLoop, stopCharacterRecoveryLoop, setOutgoingBandwidthLimit, sendBlockListPayload
do
local function saveAimbotSettings()
if type(saveAllSettings) == "function" then
pcall(saveAllSettings)
end
end
local function refreshSpeedModeLabel()
if laggerCarryToggled then
return "Lagger Carry"
end
if laggerToggled then
return "Lagger"
end
if speedMode then
return "Carry"
end
return "Normal"
end
_G.AceGetAntiBypassAimbotSpeed = function()
local speedModeName = refreshSpeedModeLabel()
if speedModeName == "Lagger" or speedModeName == "Lagger Carry" then
return tonumber(_G.AceAntiBypassLaggerAimbotSpeed) or 40
end
return tonumber(_G.AceAntiBypassAimbotSpeed) or 60
end
_G.AceRefreshAimbotVisual = function()
if _G.AceAimbotSetVisual then
_G.AceAimbotSetVisual(_G.AceAntiBypassAimbotOn == true)
end
end
_G.AceStartAntiBypassAimbot = function()
if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then
return false
end
if _G.AceStopAutoTPForAction then
_G.AceStopAutoTPForAction()
end
if _G.AceStopNormalAimbot then
_G.AceStopNormalAimbot()
end
selectedAimbotMode = "Bat Bypass"
_G.AceAntiBypassAimbotOn = true
snowVS.BatBypass.ZCFG.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
snowVS.BatBypass.Start()
if _G.AceRefreshAimbotVisual then
_G.AceRefreshAimbotVisual()
end
saveAimbotSettings()
return true
end
_G.AceStopAntiBypassAimbot = function(updateVisual)
snowVS.BatBypass.Stop()
_G.AceAntiBypassAimbotOn = false
if updateVisual ~= false and _G.AceRefreshAimbotVisual then
_G.AceRefreshAimbotVisual()
end
saveAimbotSettings()
end
_G.AceToggleSelectedAimbot = function()
if selectedAimbotMode == "Bat Bypass" then
if _G.AceAntiBypassAimbotOn then
_G.AceStopAntiBypassAimbot()
else
_G.AceStartAntiBypassAimbot()
end
end
if _G.AceRefreshAimbotVisual then
_G.AceRefreshAimbotVisual()
end
saveAimbotSettings()
end
end
do
local object, object1476
_G.AceAntiBypassStart = _G.AceStartAntiBypassAimbot
_G.AceAntiBypassStop = _G.AceStopAntiBypassAimbot
enableBatV2 = function()
if autoBatEnabled and type(disableAutoBat) == "function" then
disableAutoBat()
end
if batDesyncTpEnabled and type(stopBatDesyncTp) == "function" then
stopBatDesyncTp()
end
autoBatV2Enabled = true
if autoBatV2SetVisual then
autoBatV2SetVisual(true)
end
if _G.NewBatAimbot then
_G.NewBatAimbot.setEnabled(true)
end
if batV2FloatingButton then
local frame = batV2FloatingButton:FindFirstChild("Frame")
if frame then
paintFloatingBtn(frame, true)
end
end
end
end
disableBatV2 = function()
_G.AceStopAntiBypassAimbot()
autoBatV2Enabled = false
if autoBatV2SetVisual then
autoBatV2SetVisual(false)
end
if _G.NewBatAimbot then
_G.NewBatAimbot.setEnabled(false)
end
if batV2FloatingButton then
local frame = batV2FloatingButton:FindFirstChild("Frame")
if frame then
paintFloatingBtn(frame, false)
end
end
end
toggleBatV2 = function()
if autoBatV2Enabled then
disableBatV2()
else
enableBatV2()
end
end
BAT_AIM_SPEED = 58
BAT_AIM_BYPASS_SPEED = 34
batAimEnabled = false
batAimBypassEnabled = false
batAimConn = nil
batAimNextSwingAt = 0
local function getRenderedCFrame(part)
local rendered = part.CFrame
local ok, current = pcall(part.GetRenderCFrame, part)
if ok and current then
rendered = current
end
return rendered
end
disableBatAim = function()
if batAimConn then
batAimConn:Disconnect()
batAimConn = nil
end
local character = localPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if rootPart then
rootPart.AssemblyLinearVelocity = Vector3.zero
rootPart.AssemblyAngularVelocity = Vector3.zero
end
if humanoid then
humanoid.AutoRotate = true
end
batAimEnabled = false
if batAimSetVisual then
batAimSetVisual(false)
end
end
enableBatAim = function()
if autoBatV2Enabled and disableBatV2 then
disableBatV2()
end
local character = localPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
if not humanoid or not rootPart then
return
end
if batAimConn then
batAimConn:Disconnect()
batAimConn = nil
end
batAimEnabled = true
batAimNextSwingAt = 0
humanoid.AutoRotate = false
local initialBat = character:FindFirstChildOfClass("Tool") or (batBypass.FindBat and batBypass.FindBat())
if initialBat and initialBat.Parent ~= character then
pcall(humanoid.EquipTool, humanoid, initialBat)
end
batAimConn = RunService.RenderStepped:Connect(function()
if not batAimEnabled then
return
end
local currentChar = localPlayer.Character
if not currentChar then
return
end
local currentRoot = currentChar:FindFirstChild("HumanoidRootPart")
local currentHumanoid = currentChar:FindFirstChildOfClass("Humanoid")
if not currentRoot or not currentHumanoid then
return
end
if currentHumanoid.AutoRotate then
currentHumanoid.AutoRotate = false
end
local bat = currentChar:FindFirstChildOfClass("Tool") or (batBypass.FindBat and batBypass.FindBat())
if bat and bat.Parent ~= currentChar then
pcall(currentHumanoid.EquipTool, currentHumanoid, bat)
end
local targetPlayer = findClosestPlayer(currentRoot)
if not targetPlayer or not targetPlayer.Character then
return
end
local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
return
end
local myPosition = currentRoot.Position
local targetCFrame = getRenderedCFrame(targetRoot)
local targetPosition = targetCFrame.Position
local direction = targetPosition - myPosition
local flatDirection = newVector3(direction.X, 0, direction.Z)
local chaseSpeed = batAimBypassEnabled and BAT_AIM_BYPASS_SPEED or BAT_AIM_SPEED
local horizontalVelocity = Vector3.zero
if flatDirection.Magnitude >= 0.01 then
horizontalVelocity = flatDirection.Unit * chaseSpeed
end
local verticalVelocity = clamp((targetPosition.Y - myPosition.Y) * 19.5, -70, 110)
currentRoot.AssemblyLinearVelocity = newVector3(horizontalVelocity.X, verticalVelocity, horizontalVelocity.Z)
if (targetPosition - myPosition).Magnitude > 0.1 then
local goalCFrame = lookAtCFrame(myPosition, targetPosition)
local object1382, object1383, object1384 =
(currentRoot.CFrame:Inverse() * goalCFrame):ToEulerAnglesXYZ()
currentRoot.AssemblyAngularVelocity = currentRoot.CFrame:VectorToWorldSpace(newVector3(
clamp(object1382, -2.5, 2.5) * 42,
clamp(object1383, -2.5, 2.5) * 42,
clamp(object1384, -2.5, 2.5) * 42
))
end
local swingNow = tick()
if bat and swingNow >= batAimNextSwingAt and (targetPosition - myPosition).Magnitude <= 8 then
batAimNextSwingAt = swingNow + 0.08
pcall(bat.Activate, bat)
end
end)
if batAimSetVisual then
batAimSetVisual(true)
end
end
toggleBatAim = function()
if batAimEnabled then
disableBatAim()
else
enableBatAim()
end
end
toggleBatAimBypass = function(on)
batAimBypassEnabled = on and true or false
if _G.NewBatAimbot then
_G.NewBatAimbot.setEnabled(batAimBypassEnabled)
end
-- also sync with autoBat / batV2 flags for UI consistency
if batAimBypassEnabled then
autoBatEnabled = true
autoBatV2Enabled = true
else
autoBatEnabled = false
autoBatV2Enabled = false
end
if autoBatSetVisual then autoBatSetVisual(batAimBypassEnabled) end
if autoBatV2SetVisual then autoBatV2SetVisual(batAimBypassEnabled) end
if mobSetAutoBat then mobSetAutoBat(batAimBypassEnabled) end
end
_G.AceAntiBypassSaveToConfig = function(value)
local vector = value or {}
vector.selectedAimbotMode = selectedAimbotMode
vector.ANTI_BYPASS_AIMBOT_SPEED = _G.AceAntiBypassAimbotSpeed
vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AceAntiBypassLaggerAimbotSpeed
vector.antiBypassAimbotEnabled = _G.AceAntiBypassAimbotOn == true
return vector
end
_G.AceAntiBypassLoadFromConfig = function(vector)
if type(vector) ~= "table" then
return
end
selectedAimbotMode = vector.selectedAimbotMode or selectedAimbotMode
if selectedAimbotMode == "Anti Bypass" then
selectedAimbotMode = "Bat Bypass"
end
if selectedAimbotMode ~= "Bat Bypass" then
selectedAimbotMode = "Normal"
end
_G.AceAntiBypassAimbotSpeed = tonumber(vector.ANTI_BYPASS_AIMBOT_SPEED) or _G.AceAntiBypassAimbotSpeed or 55
if
vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED == nil
or tonumber(vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) == 58
then
_G.AceAntiBypassLaggerAimbotSpeed = 40
else
_G.AceAntiBypassLaggerAimbotSpeed = tonumber(vector.ANTI_BYPASS_LAGGER_AIMBOT_SPEED) or 40
end
_G.AceAntiBypassAimbotOn = vector.antiBypassAimbotEnabled == true
end
batDesyncTpEnabled = false
batDesyncTpConn = nil
batDesyncTpSetVisual = nil
isActive = false
_G.AlvaroTP = _G.AlvaroTP
or {
conn = nil,
on = false,
h = nil,
hrp = nil,
hittingCooldown = false,
_charConn = nil,
}
desyncLoopRunning = false
startCharacterRecoveryLoop = function() end
stopCharacterRecoveryLoop = function() end
setOutgoingBandwidthLimit = function() end
sendBlockListPayload = function() end
startAlvaroTP = function() end
stopAlvaroTP = function() end
end

local restoreLightingState, applyNeonWeather, makeDraggable
toggleAlvaroTP = function() end
startBatDesyncTp = function() end
stopBatDesyncTp = function() end
toggleBatDesyncTp = function() end
setTPBatVersion = function() end
updateTpBatButtonWithAntiDie = function() end
findBat = function()
local character = localPlayer.Character
if not character then
return nil
end
for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
local deltaTime = character:FindFirstChild(name)
if deltaTime and deltaTime:IsA("Tool") then
return deltaTime
end
end
local backpack = localPlayer:FindFirstChildOfClass("Backpack")
if backpack then
for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
local deltaTime = backpack:FindFirstChild(name)
if deltaTime and deltaTime:IsA("Tool") then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
pcall(function()
humanoid:EquipTool(deltaTime)
end)
end
return deltaTime
end
end
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
return child
end
end
return nil
end
isBatTool = function(tool)
if not tool then
return false
end
for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
if tool.Name == name then
return true
end
end
return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end
findBatForCounter = function()
local character = localPlayer.Character
if not character then
return nil
end
local backpack = localPlayer:FindFirstChildOfClass("Backpack")
for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
local tool = character:FindFirstChild(name) or backpack and backpack:FindFirstChild(name)
if tool then
return tool
end
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
return child
end
end
if backpack then
for _, child in ipairs(backpack:GetChildren()) do
if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
return child
end
end
end
return nil
end
swingBatForCounter = function(bat, character)
local humanoid = character:FindFirstChildOfClass("Humanoid")
if bat.Parent ~= character and humanoid then
pcall(function()
humanoid:EquipTool(bat)
end)
task.wait(0.05)
end
local remoteEvent = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
if remoteEvent and remoteEvent:IsA("RemoteEvent") then
pcall(function()
remoteEvent:FireServer()
end)
task.wait(0.1)
pcall(function()
remoteEvent:FireServer()
end)
else
pcall(function()
bat:Activate()
end)
task.wait(0.1)
pcall(function()
bat:Activate()
end)
end
end
batCounterDebounce = false
stopBatCounter = function()
if Conns.batCounter then
Conns.batCounter:Disconnect()
Conns.batCounter = nil
end
batCounterDebounce = false
end
startBatCounter = function()
if Conns.batCounter then
return
end
Conns.batCounter = RunService.Heartbeat:Connect(function()
if not batCounterEnabled then
return
end
if not batCounterDebounce then
local character = localPlayer.Character
if not character then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then
return
end
local state = humanoid:GetState()
if
state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
then
batCounterDebounce = true
_suppressBodyLock()
task.spawn(function()
task.wait(0.15)
local batForCounter = findBatForCounter()
if batForCounter then
swingBatForCounter(batForCounter, character)
end
task.wait(0.3)
batCounterDebounce = false
_unsuppressBodyLock(true)
end)
end
return
end
return
end)
end
findMedusa = function()
local character = localPlayer.Character
if not character then
return nil
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Tool") then
local n = child.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then
return child
end
end
end
local backpack = localPlayer:FindFirstChild("Backpack")
if backpack then
for _, child in ipairs(backpack:GetChildren()) do
if child:IsA("Tool") then
local n = child.Name:lower()
if n:find("medusa") or n:find("head") or n:find("stone") then
return child
end
end
end
end
return nil
end
useMedusaCounter = function()
if medusaDebounce then
return
end
local object = medusaLastUsed
if getTime() - object < MEDUSA_COOLDOWN then
return
end
local character = localPlayer.Character
if not character then
return
end
medusaDebounce = true
local medusa = findMedusa()
if not medusa then
medusaDebounce = false
return
end
if medusa.Parent ~= character then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:EquipTool(medusa)
end
end
pcall(function()
medusa:Activate()
end)
medusaLastUsed = getTime()
medusaDebounce = false
end
onAnchorChanged = function(part)
return part:GetPropertyChangedSignal("Anchored"):Connect(function()
if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
useMedusaCounter()
end
end)
end
setupMedusaCounter = function(part)
for _, connection in pairs(Conns.anchor) do
pcall(function()
connection:Disconnect()
end)
end
Conns.anchor = {}
if not part or not medusaCounterEnabled then
return
end
for _, descendant in ipairs(part:GetDescendants()) do
if descendant:IsA("BasePart") then
table.insert(Conns.anchor, onAnchorChanged(descendant))
end
end
table.insert(
Conns.anchor,
part.DescendantAdded:Connect(function(descendant)
if descendant:IsA("BasePart") then
table.insert(Conns.anchor, onAnchorChanged(descendant))
end
end)
)
end
stopMedusaCounter = function()
for _, connection in pairs(Conns.anchor) do
pcall(function()
connection:Disconnect()
end)
end
Conns.anchor = {}
end

do
local connection2 = nil
stopDropBrainrot = function()
dropActive = false
if connection2 then
connection2:Disconnect()
connection2 = nil
end
for _, deltaTime in ipairs(dropConnections) do
if type(deltaTime) == "thread" then
pcall(task.cancel, deltaTime)
elseif type(deltaTime) == "RBXScriptConnection" then
pcall(deltaTime.Disconnect, deltaTime)
end
end
dropConnections = {}
local character = localPlayer.Character
if character then
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if humanoidRootPart then
humanoidRootPart.AssemblyLinearVelocity = zeroVector
end
end
if dropBrainrotSetVisual then
dropBrainrotSetVisual(false)
end
if mobSetDropBR then
mobSetDropBR(false)
end
end
runDropBrainrot = function()
if dropActive then
return
end
local character = localPlayer.Character
local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
character = character and character:FindFirstChildOfClass("Humanoid")
if not humanoidRootPart or not character then
return
end
if dropMode == 1 then
local speedH = 0
if humanoidRootPart then
local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
speedH = newVector3(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude
end
local cooldown = speedH > 5 and 0.6 or 0.25
local object = lastDropTime
if getTime() - object < cooldown then
return
end
lastDropTime = getTime()
dropActive = true
if dropBrainrotSetVisual then
dropBrainrotSetVisual(true)
end
if mobSetDropBR then
mobSetDropBR(true)
end
local wasAutoBat = false
if autoBatEnabled then
wasAutoBat = true
disableAutoBat()
if autoBatSetVisual then
autoBatSetVisual(false)
end
if mobSetAutoBat then
mobSetAutoBat(false)
end
end
local function finishDrop(threadRef)
if threadRef and dropConnections then
for i = #dropConnections, 1, -1 do
if dropConnections[i] == threadRef then
table.remove(dropConnections, i)
break
end
end
end
dropActive = false
local character2 = localPlayer.Character
if character2 then
local r = character2:FindFirstChild("HumanoidRootPart")
local humanoid = character2:FindFirstChildOfClass("Humanoid")
if r then
r.AssemblyLinearVelocity = zeroVector
r.AssemblyAngularVelocity = zeroVector
if r.Position.Y < -100 then
r.CFrame = newCFrame(r.Position.X, 5, r.Position.Z)
end
local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {
character2,
}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local hit = workspace:Raycast(r.Position, newVector3(0, -2000, 0), raycastParams)
if hit then
r.CFrame = newCFrame(
r.Position.X,
hit.Position.Y + (humanoid and humanoid.HipHeight or 2) + r.Size.Y / 2,
r.Position.Z
)
end
if humanoid and humanoid.Health > 0 then
humanoid:ChangeState(Enum.HumanoidStateType.Running)
end
end
end
if wasAutoBat then
enableAutoBat()
if autoBatSetVisual then
autoBatSetVisual(true)
end
if mobSetAutoBat then
mobSetAutoBat(true)
end
end
if dropBrainrotSetVisual then
dropBrainrotSetVisual(false)
end
if mobSetDropBR then
mobSetDropBR(false)
end
end
local thread = nil
thread = task.spawn(function()
local startTime = getTime()
while true do
local c = dropActive
if c then
c = getTime() - startTime < 0.3
end
if c then
RunService.Heartbeat:Wait()
local character2 = localPlayer.Character
character2 = character2 and character2:FindFirstChild("HumanoidRootPart")
if character2 then
local velocity = newVector3(0, character2.AssemblyLinearVelocity.Y, 0)
character2.AssemblyLinearVelocity = velocity * 10000 + newVector3(0, 10000, 0)
RunService.RenderStepped:Wait()
if character2 and character2.Parent then
character2.AssemblyLinearVelocity = velocity
end
RunService.Stepped:Wait()
if character2 and character2.Parent then
character2.AssemblyLinearVelocity = velocity + newVector3(0, 0.1, 0)
end
continue
end
end
break
end
finishDrop(thread)
end)
table.insert(dropConnections, thread)
task.delay(0.35, function()
if dropActive then
finishDrop(thread)
end
end)
return
end
dropActive = true
if dropBrainrotSetVisual then
dropBrainrotSetVisual(true)
end
if mobSetDropBR then
mobSetDropBR(true)
end
local t0 = getTime()
if connection2 then
connection2:Disconnect()
end
connection2 = RunService.Heartbeat:Connect(function()
local character2 = localPlayer.Character
local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart2 then
if connection2 then
connection2:Disconnect()
connection2 = nil
end
dropActive = false
if dropBrainrotSetVisual then
dropBrainrotSetVisual(false)
end
if mobSetDropBR then
mobSetDropBR(false)
end
return
end
if not dropActive then
if connection2 then
connection2:Disconnect()
connection2 = nil
end
if dropBrainrotSetVisual then
dropBrainrotSetVisual(false)
end
if mobSetDropBR then
mobSetDropBR(false)
end
return
end
if getTime() - t0 >= 0.22 then
if connection2 then
connection2:Disconnect()
connection2 = nil
end
pcall(function()
local raycastParams = RaycastParams.new()
raycastParams.FilterDescendantsInstances = {
character2,
}
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local hit = workspace:Raycast(humanoidRootPart2.Position, newVector3(0, -2000, 0), raycastParams)
if hit then
local humanoid = character2:FindFirstChildOfClass("Humanoid")
humanoidRootPart2.CFrame = newCFrame(
humanoidRootPart2.Position.X,
hit.Position.Y + (humanoid and humanoid.HipHeight or 2) + humanoidRootPart2.Size.Y / 2,
humanoidRootPart2.Position.Z
)
humanoidRootPart2.AssemblyLinearVelocity = zeroVector
humanoidRootPart2.AssemblyAngularVelocity = zeroVector
end
if hum2 and hum2.Health > 0 then
hum2:ChangeState(Enum.HumanoidStateType.Running)
end
end)
dropActive = false
if dropBrainrotSetVisual then
dropBrainrotSetVisual(false)
end
if mobSetDropBR then
mobSetDropBR(false)
end
return
end
local assemblyLinearVelocity = humanoidRootPart2.AssemblyLinearVelocity
humanoidRootPart2.AssemblyLinearVelocity =
newVector3(assemblyLinearVelocity.X, 160, assemblyLinearVelocity.Z)
end)
end
end
executeDropWithToggle = function(setVisual)
if dropActive then
return
end
task.spawn(function()
if setVisual then
setVisual(true)
end
runDropBrainrot()
while dropActive do
task.wait()
end
task.wait(0.1)
if setVisual then
setVisual(false)
end
end)
end
do
local function optimizeInstanceForAntiLag(callback)
pcall(function()
if callback:GetAttribute("_CloverHubSky") ~= nil then
return
end
if callback:IsA("Sky") or callback:IsA("Atmosphere") or callback:IsA("Clouds") then
return
end
if skyTheme ~= "Off" and callback.Parent == Lighting then
if
callback:IsA("BlurEffect")
or callback:IsA("SunRaysEffect")
or callback:IsA("ColorCorrectionEffect")
or callback:IsA("BloomEffect")
or callback:IsA("DepthOfFieldEffect")
or callback:IsA("BrightnessEffect")
or callback:IsA("DitheringEffect")
then
return
end
end
if callback:IsA("Accessory") or callback:IsA("Hat") then
local character = localPlayer.Character
if character and callback:IsDescendantOf(character) then
return
end
callback:Destroy()
elseif callback:IsA("BasePart") then
callback.Material = Enum.Material.Plastic
callback.Reflectance = 0
callback.CastShadow = false
callback.TopSurface = Enum.SurfaceType.Smooth
callback.BottomSurface = Enum.SurfaceType.Smooth
callback.FrontSurface = Enum.SurfaceType.Smooth
callback.BackSurface = Enum.SurfaceType.Smooth
callback.LeftSurface = Enum.SurfaceType.Smooth
callback.RightSurface = Enum.SurfaceType.Smooth
for _, child in ipairs(callback:GetChildren()) do
if child:IsA("Decal") or child:IsA("Texture") then
child.Transparency = 0.5
end
end
elseif callback:IsA("Decal") or callback:IsA("Texture") then
callback.Transparency = 0.5
elseif
callback:IsA("ParticleEmitter")
or callback:IsA("Trail")
or callback:IsA("Beam")
or callback:IsA("Fire")
or callback:IsA("Smoke")
or callback:IsA("Sparkles")
then
callback.Enabled = false
elseif callback:IsA("PointLight") or callback:IsA("SpotLight") or callback:IsA("SurfaceLight") then
callback.Enabled = false
elseif callback:IsA("SelectionBox") and callback.Name ~= "CloverHubESP" then
pcall(function()
callback:Destroy()
end)
end
end)
end
enableAntiLag = function()
antiLagEnabled = true
removeAccessoriesEnabled = true
_G._AmbitiousDefLightBrightness = _G._AmbitiousDefLightBrightness or Lighting.Brightness
_G._AmbitiousDefLightClock = _G._AmbitiousDefLightClock or Lighting.ClockTime
_G._AmbitiousDefLightAmbient = _G._AmbitiousDefLightAmbient or Lighting.OutdoorAmbient
pcall(function()
settings().Rendering.QualityLevel = 1
local disabled = Enum.MeshPartDetailLevel.Disabled
settings().Rendering.MeshPartDetailLevel = disabled
end)
if skyTheme == "Off" then
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10
Lighting.FogStart = 0
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.ShadowSoftness = 0
Lighting.ExposureCompensation = 0
pcall(function()
Lighting.Technology = Enum.Technology.Compatibility
return
end)
for _, child in pairs(Lighting:GetChildren()) do
pcall(function()
if child:GetAttribute("_AmbitiousVivid") then
return
end
if
child:IsA("BlurEffect")
or child:IsA("SunRaysEffect")
or child:IsA("ColorCorrectionEffect")
or child:IsA("BloomEffect")
or child:IsA("DepthOfFieldEffect")
or child:IsA("BrightnessEffect")
or child:IsA("DitheringEffect")
then
child.Enabled = false
end
end)
end
end
do
local pending = workspace:GetDescendants()
task.spawn(function()
local count = 0
for i = 1, #pending do
if not antiLagEnabled then
break
end
local descendant = pending[i]
optimizeInstanceForAntiLag(descendant)
if descendant:IsA("Decal") then
pcall(function()
descendant.Transparency = 1
end)
end
count += 1
if count % 200 == 0 then
RunService.Heartbeat:Wait()
end
end
end)
end
pcall(function()
workspace.Terrain.WaterWaveSize = 0
workspace.Terrain.WaterWaveSpeed = 0
workspace.Terrain.WaterReflectance = 0
workspace.Terrain.WaterTransparency = 0
workspace.Terrain.Decoration = false
end)
if antiLagDescConn then
antiLagDescConn:Disconnect()
end
antiLagDescConn = workspace.DescendantAdded:Connect(function(descendant)
if descendant:GetAttribute("_CloverHubSky") then
return
end
if descendant:IsA("Sky") or descendant:IsA("Atmosphere") or descendant:IsA("Clouds") then
return
end
if removeAccessoriesEnabled then
optimizeInstanceForAntiLag(descendant)
end
end)
end
end
disableAntiLag = function()
antiLagEnabled = false
removeAccessoriesEnabled = false
if antiLagDescConn then
antiLagDescConn:Disconnect()
antiLagDescConn = nil
end
if skyTheme == "Off" then
pcall(function()
if _G._AmbitiousDefLightBrightness then
Lighting.Brightness = _G._AmbitiousDefLightBrightness
end
if _G._AmbitiousDefLightClock then
Lighting.ClockTime = _G._AmbitiousDefLightClock
end
if _G._AmbitiousDefLightAmbient then
Lighting.OutdoorAmbient = _G._AmbitiousDefLightAmbient
end
Lighting.ExposureCompensation = 0
Lighting.GlobalShadows = true
end)
end
end
CUSTOM_FOV_BIND = "CloverHubCustomFOV"
enableCustomFov = function()
local currentCamera2 = workspace.CurrentCamera
if currentCamera2 and origFOV == nil then
origFOV = currentCamera2.FieldOfView
end
fovEnabled = true
if currentCamera2 then
pcall(function()
currentCamera2.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal
end)
pcall(function()
currentCamera2.FieldOfView = fovValue
end)
end
if customFovConn then
customFovConn:Disconnect()
customFovConn = nil
end
pcall(function()
RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND)
end)
local prio = 200
pcall(function()
prio = Enum.RenderPriority.Camera.Value + 10
end)
if
not pcall(function()
RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
if not fovEnabled then
return
end
local currentCamera3 = workspace.CurrentCamera
if currentCamera3 and currentCamera3.FieldOfView ~= fovValue then
currentCamera3.FieldOfView = fovValue
end
end)
end)
then
customFovConn = RunService.RenderStepped:Connect(function()
if not fovEnabled then
if customFovConn then
customFovConn:Disconnect()
customFovConn = nil
end
return
end
local currentCamera3 = workspace.CurrentCamera
if currentCamera3 then
currentCamera3.FieldOfView = fovValue
end
end)
end
end
disableCustomFov = function()
fovEnabled = false
pcall(function()
RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND)
end)
if customFovConn then
customFovConn:Disconnect()
customFovConn = nil
end
local currentCamera2 = workspace.CurrentCamera
if currentCamera2 then
pcall(function()
currentCamera2.FieldOfViewMode = Enum.FieldOfViewMode.Vertical
end)
pcall(function()
currentCamera2.FieldOfView = origFOV or 70
end)
end
end
applyStretchFOV = function(fieldOfView)
local currentCamera2 = workspace.CurrentCamera
if currentCamera2 then
pcall(function()
currentCamera2.FieldOfView = fieldOfView
end)
end
end
enableStretch = function()
if stretchConn then
return
end
stretchEnabled = true
local currentCamera2 = workspace.CurrentCamera
if not currentCamera2 then
return
end
origFOV = currentCamera2.FieldOfView or 70
applyStretchFOV(stretchFOV)
stretchConn = RunService.RenderStepped:Connect(function()
if not stretchEnabled then
stretchConn:Disconnect()
stretchConn = nil
return
end
local currentCamera3 = workspace.CurrentCamera
if currentCamera3 then
currentCamera3.CFrame = currentCamera3.CFrame * newCFrame(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
end
end)
if stretchFovConn then
stretchFovConn:Disconnect()
end
stretchFovConn = RunService.RenderStepped:Connect(function()
if stretchEnabled then
applyStretchFOV(stretchFOV)
else
stretchFovConn:Disconnect()
stretchFovConn = nil
end
end)
end
disableStretch = function()
stretchEnabled = false
if stretchConn then
stretchConn:Disconnect()
stretchConn = nil
end
if stretchFovConn then
stretchFovConn:Disconnect()
stretchFovConn = nil
end
local currentCamera2 = workspace.CurrentCamera
if currentCamera2 then
pcall(function()
currentCamera2.FieldOfView = origFOV or 70
end)
end
end
do
local function saveLightingState()
if _originalLighting then
return
end
_originalLighting = {
Brightness = Lighting.Brightness,
ClockTime = Lighting.ClockTime,
OutdoorAmbient = Lighting.OutdoorAmbient,
GlobalShadows = Lighting.GlobalShadows,
FogEnd = Lighting.FogEnd,
FogStart = Lighting.FogStart,
FogColor = Lighting.FogColor,
Ambient = Lighting.Ambient,
ColorCorrection = nil,
Bloom = nil,
}
for _, child in ipairs(Lighting:GetChildren()) do
if child:IsA("ColorCorrectionEffect") then
_originalLighting.ColorCorrection = {
Enabled = child.Enabled,
Brightness = child.Brightness,
Contrast = child.Contrast,
Saturation = child.Saturation,
TintColor = child.TintColor,
}
elseif child:IsA("BloomEffect") then
_originalLighting.Bloom = {
Enabled = child.Enabled,
Intensity = child.Intensity,
Size = child.Size,
Threshold = child.Threshold,
}
end
end
end
restoreLightingState = function()
if not _originalLighting then
return
end
local old = _originalLighting
Lighting.Brightness = old.Brightness
Lighting.ClockTime = old.ClockTime
Lighting.OutdoorAmbient = old.OutdoorAmbient
Lighting.GlobalShadows = old.GlobalShadows
Lighting.FogEnd = old.FogEnd
Lighting.FogStart = old.FogStart
Lighting.FogColor = old.FogColor
Lighting.Ambient = old.Ambient
if old.ColorCorrection then
local colorCorrectionEffect = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
if colorCorrectionEffect then
colorCorrectionEffect.Enabled = old.ColorCorrection.Enabled
colorCorrectionEffect.Brightness = old.ColorCorrection.Brightness
colorCorrectionEffect.Contrast = old.ColorCorrection.Contrast
colorCorrectionEffect.Saturation = old.ColorCorrection.Saturation
colorCorrectionEffect.TintColor = old.ColorCorrection.TintColor
end
end
if old.Bloom then
local bloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
if bloomEffect then
bloomEffect.Enabled = old.Bloom.Enabled
bloomEffect.Intensity = old.Bloom.Intensity
bloomEffect.Size = old.Bloom.Size
bloomEffect.Threshold = old.Bloom.Threshold
end
end
end
SKY_PRESETS_LIST = {
"Off",
"Night",
"Aurora",
"Sunset",
"Galaxy",
"Cyber",
"Sakura",
"Pink Night",
"Blood Moon",
"Emerald Dawn",
"Volcanic",
"Arctic",
"Midnight Ocean",
"Vaporwave",
"Toxic",
"Solar Eclipse",
"Hellscape",
"Heaven",
"Storm",
"Sunrise",
"Deep Space",
"Lavender Dream",
"Inferno",
"Mint Sky",
"Green Sky",
}
SKY_PRESETS = {
Off = {
kind = "off",
},
Night = {
clock = 22,
brightness = 2,
ambient = {
110,
100,
130,
},
outAmb = {
120,
110,
140,
},
sky = {
stars = 4000,
moon = 18,
sun = 0,
moonTex = true,
},
atm = {
dens = 0.45,
color = {
120,
60,
180,
},
decay = {
60,
20,
100,
},
glare = 0.5,
haze = 1.2,
},
},
Aurora = {
clock = 14,
brightness = 3,
ambient = {
150,
120,
150,
},
outAmb = {
160,
130,
150,
},
atm = {
dens = 0.55,
color = {
85,
80,
200,
},
decay = {
255,
20,
150,
},
glare = 2.5,
haze = 3,
},
clouds = {
cover = 0.7,
dens = 0.7,
color = {
85,
240,
250,
},
},
},
Sunset = {
clock = 17.2,
brightness = 2.5,
ambient = {
170,
120,
100,
},
outAmb = {
180,
130,
110,
},
sky = {
stars = 0,
sun = 25,
moon = 0,
},
atm = {
dens = 0.5,
color = {
255,
130,
60,
},
decay = {
255,
80,
30,
},
glare = 2,
haze = 2.5,
},
clouds = {
cover = 0.55,
dens = 0.55,
color = {
255,
200,
140,
},
},
},
Galaxy = {
clock = 0,
brightness = 1.5,
ambient = {
70,
60,
100,
},
outAmb = {
80,
70,
110,
},
sky = {
stars = 10000,
moon = 30,
sun = 0,
},
atm = {
dens = 0.15,
color = {
40,
20,
80,
},
decay = {
20,
10,
50,
},
glare = 0.3,
haze = 0.5,
},
},
Cyber = {
clock = 21,
brightness = 2.2,
ambient = {
90,
130,
170,
},
outAmb = {
100,
140,
180,
},
sky = {
stars = 2000,
moon = 12,
},
atm = {
dens = 0.4,
color = {
0,
200,
255,
},
decay = {
150,
0,
255,
},
glare = 2,
haze = 2,
},
clouds = {
cover = 0.4,
dens = 0.6,
color = {
100,
200,
85,
},
},
},
Sakura = {
clock = 11,
brightness = 3.5,
ambient = {
170,
150,
160,
},
outAmb = {
180,
160,
170,
},
sky = {
sun = 8,
},
atm = {
dens = 0.3,
color = {
85,
200,
220,
},
decay = {
255,
170,
200,
},
glare = 1,
haze = 1.5,
},
clouds = {
cover = 0.6,
dens = 0.4,
color = {
255,
250,
252,
},
},
},
["Pink Night"] = {
clock = 23,
brightness = 2.2,
ambient = {
120,
60,
110,
},
outAmb = {
140,
70,
120,
},
sky = {
stars = 5000,
moon = 22,
sun = 0,
moonTex = true,
},
atm = {
dens = 0.5,
color = {
85,
80,
180,
},
decay = {
140,
30,
100,
},
glare = 0.7,
haze = 1.4,
},
clouds = {
cover = 0.3,
dens = 0.5,
color = {
180,
90,
150,
},
},
},
["Blood Moon"] = {
clock = 22.5,
brightness = 1.8,
ambient = {
130,
70,
70,
},
outAmb = {
150,
80,
80,
},
sky = {
stars = 1500,
moon = 28,
sun = 0,
moonTex = true,
},
atm = {
dens = 0.45,
color = {
220,
80,
80,
},
decay = {
120,
40,
40,
},
glare = 1,
haze = 1.5,
},
clouds = {
cover = 0.45,
dens = 0.55,
color = {
120,
60,
60,
},
},
},
["Emerald Dawn"] = {
clock = 6.5,
brightness = 2.8,
ambient = {
130,
170,
140,
},
outAmb = {
140,
180,
150,
},
sky = {
sun = 18,
moon = 0,
stars = 0,
},
atm = {
dens = 0.4,
color = {
80,
200,
140,
},
decay = {
40,
150,
90,
},
glare = 1.8,
haze = 2.2,
},
clouds = {
cover = 0.5,
dens = 0.5,
color = {
200,
255,
220,
},
},
},
Volcanic = {
clock = 19,
brightness = 2.2,
ambient = {
180,
110,
80,
},
outAmb = {
200,
120,
90,
},
sky = {
stars = 200,
sun = 12,
moon = 0,
},
atm = {
dens = 0.55,
color = {
255,
110,
60,
},
decay = {
180,
70,
40,
},
glare = 2,
haze = 2.2,
},
clouds = {
cover = 0.65,
dens = 0.7,
color = {
120,
70,
50,
},
},
},
Arctic = {
clock = 9,
brightness = 3.2,
ambient = {
200,
220,
235,
},
outAmb = {
210,
230,
245,
},
sky = {
sun = 10,
stars = 0,
moon = 0,
},
atm = {
dens = 0.3,
color = {
180,
220,
255,
},
decay = {
140,
200,
240,
},
glare = 1.5,
haze = 1.8,
},
clouds = {
cover = 0.7,
dens = 0.6,
color = {
250,
253,
85,
},
},
},
["Midnight Ocean"] = {
clock = 1.5,
brightness = 1.7,
ambient = {
60,
90,
130,
},
outAmb = {
70,
100,
140,
},
sky = {
stars = 6000,
moon = 24,
sun = 0,
moonTex = true,
},
atm = {
dens = 0.5,
color = {
20,
60,
140,
},
decay = {
10,
30,
90,
},
glare = 0.6,
haze = 1.5,
},
},
Vaporwave = {
clock = 19.5,
brightness = 2.4,
ambient = {
180,
120,
200,
},
outAmb = {
190,
130,
210,
},
sky = {
stars = 1000,
moon = 14,
},
atm = {
dens = 0.45,
color = {
255,
100,
220,
},
decay = {
120,
60,
255,
},
glare = 2.2,
haze = 2.4,
},
clouds = {
cover = 0.55,
dens = 0.55,
color = {
200,
150,
85,
},
},
},
Toxic = {
clock = 13,
brightness = 2.5,
ambient = {
140,
180,
80,
},
outAmb = {
150,
190,
90,
},
atm = {
dens = 0.45,
color = {
100,
220,
40,
},
decay = {
60,
150,
20,
},
glare = 1.5,
haze = 1.8,
},
clouds = {
cover = 0.55,
dens = 0.55,
color = {
180,
255,
120,
},
},
},
["Solar Eclipse"] = {
clock = 12,
brightness = 1.2,
ambient = {
70,
60,
80,
},
outAmb = {
80,
70,
90,
},
sky = {
stars = 3500,
sun = 22,
moon = 0,
},
atm = {
dens = 0.4,
color = {
255,
180,
90,
},
decay = {
50,
40,
60,
},
glare = 2,
haze = 1.5,
},
},
Hellscape = {
clock = 18,
brightness = 2.2,
ambient = {
200,
100,
80,
},
outAmb = {
220,
110,
90,
},
sky = {
stars = 100,
sun = 30,
moon = 0,
},
atm = {
dens = 0.6,
color = {
255,
90,
60,
},
decay = {
140,
50,
40,
},
glare = 2.2,
haze = 2.4,
},
clouds = {
cover = 0.8,
dens = 0.8,
color = {
90,
50,
40,
},
},
},
Heaven = {
clock = 12,
brightness = 4,
ambient = {
240,
240,
210,
},
outAmb = {
250,
245,
220,
},
sky = {
sun = 16,
moon = 0,
stars = 0,
},
atm = {
dens = 0.25,
color = {
255,
250,
220,
},
decay = {
85,
240,
200,
},
glare = 3,
haze = 1.5,
},
clouds = {
cover = 0.85,
dens = 0.5,
color = {
255,
255,
255,
},
},
},
Storm = {
clock = 15,
brightness = 1.6,
ambient = {
105,
105,
125,
},
outAmb = {
115,
115,
135,
},
sky = {
stars = 0,
sun = 6,
moon = 0,
},
atm = {
dens = 0.55,
color = {
90,
100,
130,
},
decay = {
55,
65,
90,
},
glare = 0.5,
haze = 2.2,
},
clouds = {
cover = 0.85,
dens = 0.5,
color = {
70,
75,
90,
},
},
},
Sunrise = {
clock = 6.2,
brightness = 2.8,
ambient = {
220,
180,
130,
},
outAmb = {
230,
190,
140,
},
sky = {
sun = 22,
stars = 0,
moon = 0,
},
atm = {
dens = 0.45,
color = {
255,
180,
100,
},
decay = {
255,
140,
80,
},
glare = 2.4,
haze = 2.2,
},
clouds = {
cover = 0.4,
dens = 0.4,
color = {
85,
220,
180,
},
},
},
["Deep Space"] = {
clock = 0,
brightness = 1,
ambient = {
30,
25,
50,
},
outAmb = {
40,
35,
60,
},
sky = {
stars = 15000,
moon = 0,
sun = 0,
},
atm = {
dens = 0.05,
color = {
15,
5,
40,
},
decay = {
5,
0,
20,
},
glare = 0.2,
haze = 0.3,
},
},
["Lavender Dream"] = {
clock = 18.5,
brightness = 2.6,
ambient = {
180,
160,
220,
},
outAmb = {
190,
170,
230,
},
sky = {
stars = 800,
moon = 16,
sun = 0,
},
atm = {
dens = 0.4,
color = {
200,
160,
255,
},
decay = {
160,
120,
220,
},
glare = 1.4,
haze = 1.8,
},
clouds = {
cover = 0.55,
dens = 0.5,
color = {
220,
200,
85,
},
},
},
Inferno = {
clock = 17.5,
brightness = 2.4,
ambient = {
220,
140,
90,
},
outAmb = {
240,
150,
100,
},
sky = {
sun = 26,
moon = 0,
stars = 0,
},
atm = {
dens = 0.5,
color = {
255,
130,
70,
},
decay = {
200,
80,
40,
},
glare = 2.2,
haze = 2.2,
},
clouds = {
cover = 0.6,
dens = 0.6,
color = {
200,
110,
80,
},
},
},
["Green Sky"] = {
clock = 14,
brightness = 2,
ambient = { 17, 107, 42 },
outAmb = { 17, 107, 42 },
fog = { 27, 168, 66 },
atm = {
dens = 0.35,
color = { 60, 200, 100 },
decay = { 20, 140, 60 },
glare = 1,
haze = 1.5,
},
},
["Mint Sky"] = {
clock = 10,
brightness = 3.2,
ambient = {
180,
230,
210,
},
outAmb = {
190,
240,
220,
},
sky = {
sun = 10,
},
atm = {
dens = 0.32,
color = {
150,
255,
210,
},
decay = {
100,
220,
180,
},
glare = 1.6,
haze = 1.6,
},
clouds = {
cover = 0.55,
dens = 0.45,
color = {
240,
85,
250,
},
},
},
}
local function vC3(deltaTime)
return Color3.fromRGB(0, 0, 0)
end
_v4mpClearSky = function()
for _, child in ipairs(Lighting:GetChildren()) do
if child:GetAttribute("_AdaptDuelsSky") then
pcall(function()
child:Destroy()
end)
end
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if terrain then
for _, child in ipairs(terrain:GetChildren()) do
if child:GetAttribute("_AdaptDuelsSky") then
pcall(function()
child:Destroy()
end)
end
end
end
end
applyCustomSky = function(mode)
_v4mpClearSky()
local preset = SKY_PRESETS[mode]
if not preset or preset.kind == "off" then
Lighting.ClockTime = 14
Lighting.Brightness = 2
Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
Lighting.Ambient = Color3.fromRGB(255, 255, 255)
Lighting.FogEnd = 100000
Lighting.GlobalShadows = true
skyTheme = "Off"
return
end
Lighting.FogStart = 0
Lighting.FogEnd = 100000
Lighting.FogColor = vC3(preset.fog or { 200, 200, 200 })
Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
Lighting.GlobalShadows = true
Lighting.ClockTime = preset.clock or 14
Lighting.Brightness = preset.brightness or 2
if preset.outAmb then
Lighting.OutdoorAmbient = vC3(preset.outAmb)
end
if preset.ambient then
Lighting.Ambient = vC3(preset.ambient)
end
if preset.sky then
local sky = Instance.new("Sky")
sky:SetAttribute("_AdaptDuelsSky", true)
if preset.sky.stars then
sky.StarCount = preset.sky.stars
end
if preset.sky.moon then
sky.MoonAngularSize = preset.sky.moon
end
if preset.sky.sun then
sky.SunAngularSize = preset.sky.sun
end
if preset.sky.moonTex then
sky.MoonTextureId = "rbxasset://sky/moon.jpg"
end
sky.Parent = Lighting
end
if preset.atm then
local atm = Instance.new("Atmosphere")
atm:SetAttribute("_AdaptDuelsSky", true)
atm.Density = preset.atm.dens or 0.3
atm.Color = vC3(preset.atm.color)
atm.Decay = vC3(preset.atm.decay)
atm.Glare = preset.atm.glare or 1
atm.Haze = preset.atm.haze or 1
atm.Parent = Lighting
end
local terrain = workspace:FindFirstChildOfClass("Terrain")
if preset.clouds and terrain then
local clouds = Instance.new("Clouds")
clouds:SetAttribute("_AdaptDuelsSky", true)
clouds.Cover = preset.clouds.cover or 0.5
clouds.Density = preset.clouds.dens or 0.5
clouds.Color = vC3(preset.clouds.color)
clouds.Parent = terrain
end
skyTheme = mode
end
applyNeonWeather = function()
if not neonWeatherEnabled then
restoreLightingState()
return
end
if not _originalLighting then
saveLightingState()
end
Lighting.Brightness = 2.2
Lighting.ClockTime = 20
Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
Lighting.GlobalShadows = false
Lighting.FogEnd = 300
Lighting.FogStart = 0
Lighting.FogColor = Color3.fromRGB(255, 255, 255)
Lighting.Ambient = Color3.fromRGB(0, 0, 0)
local colorCorrectionEffect = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
if not colorCorrectionEffect then
colorCorrectionEffect = Instance.new("ColorCorrectionEffect")
colorCorrectionEffect.Parent = Lighting
end
colorCorrectionEffect.Enabled = true
colorCorrectionEffect.Brightness = 0.1
colorCorrectionEffect.Contrast = 0.08
colorCorrectionEffect.Saturation = 0.08
colorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 255)
local bloomEffect = Lighting:FindFirstChildOfClass("BloomEffect")
if not bloomEffect then
local bloomEffect2 = Instance.new("BloomEffect")
bloomEffect2.Parent = Lighting
bloomEffect = bloomEffect2
end
bloomEffect.Enabled = true
bloomEffect.Intensity = 0.4
bloomEffect.Size = 20
bloomEffect.Threshold = 0.9
end
end
do
local noPlayerCollisionState, isNoPlayerCollisionRunning, trackCollisionPart, restoreCollisionPart, enforceCharacterNoCollision, watchCharacterCollision, handleAddedWorkspacePart
toggleNeonWeather = function(state)
if state == nil then
neonWeatherEnabled = not neonWeatherEnabled
else
neonWeatherEnabled = state
end
applyNeonWeather()
if setNeonWeatherVisual then
setNeonWeatherVisual(neonWeatherEnabled)
end
end
paintFloatingBtn = function(button, active)
if not button then
return
end
local btnGrad = button:FindFirstChild("BtnGrad")
local textLabel = button:FindFirstChild("TextLabel")
local uiStroke = button:FindFirstChildOfClass("UIStroke")
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
if false then
if btnGrad then
if active then
btnGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
else
btnGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
end
end
if textLabel then
textLabel.TextColor3 = active and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
end
if uiStroke then
uiStroke.Color = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = active and 1.8 or 1.5
uiStroke.Transparency = active and 0.05 or 0.2
end
return
end
if active then
if btnGrad then
local activeGradientKeypoints = {}
local activeGradientStart = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
local activeGradientMiddle = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 255, 255))
local activeGradientEnd = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0))
activeGradientKeypoints[1] = activeGradientStart
activeGradientKeypoints[2] = activeGradientMiddle
activeGradientKeypoints[3] = activeGradientEnd
activeGradientKeypoints[4] = ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
btnGrad.Color = ColorSequence.new(activeGradientKeypoints)
end
if textLabel then
textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
end
if uiStroke then
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 1.8
uiStroke.Transparency = 0.05
end
else
if btnGrad then
local inactiveGradientKeypoints = {}
local inactiveGradientStart = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
local inactiveGradientMiddle = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 0, 0))
local inactiveGradientEnd = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0))
inactiveGradientKeypoints[1] = inactiveGradientStart
inactiveGradientKeypoints[2] = inactiveGradientMiddle
inactiveGradientKeypoints[3] = inactiveGradientEnd
inactiveGradientKeypoints[4] = ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
btnGrad.Color = ColorSequence.new(inactiveGradientKeypoints)
end
if textLabel then
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end
if uiStroke then
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Thickness = 1
uiStroke.Transparency = 0.62
end
end
end
applyFloatingButtonScale = function()
for _, uiScale in ipairs(_floatingUIScales) do
if uiScale and uiScale.Parent then
uiScale.Scale = floatingButtonScale
end
end
end
makeDraggable = function(rootPart)
local dragging = false
local dragStartPosition = nil
local initialGuiPosition = nil
local dragInput = nil
local dragConnection = nil
local function finishDrag()
dragging = false
dragInput = nil
if dragConnection then
dragConnection:Disconnect()
dragConnection = nil
end
pcall(saveAllSettings)
end
rootPart.InputBegan:Connect(function(input)
if uiLocked then
return
end
if _isDraggingButton then
return
end
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
dragging = true
dragStartPosition = input.Position
initialGuiPosition = rootPart.Position
if dragConnection then
dragConnection:Disconnect()
end
dragConnection = input.Changed:Connect(function()
if input.UserInputState == Enum.UserInputState.End then
finishDrag()
end
end)
end
end)
rootPart.InputEnded:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
finishDrag()
end
end)
UserInputService.InputEnded:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
finishDrag()
end
end)
rootPart.InputChanged:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch
then
dragInput = input
end
end)
UserInputService.InputChanged:Connect(function(input)
if input == dragInput and dragging then
if uiLocked then
finishDrag()
return
end
if _isDraggingButton then
return
end
if not dragStartPosition or not initialGuiPosition then
return
end
rootPart.Position = UDim2.new(
initialGuiPosition.X.Scale,
initialGuiPosition.X.Offset + input.Position.X - dragStartPosition.X,
initialGuiPosition.Y.Scale,
initialGuiPosition.Y.Offset + input.Position.Y - dragStartPosition.Y
)
end
end)
end
setupMovementAndIndicators = function(character)
if steppedConn then
steppedConn:Disconnect()
steppedConn = nil
end
if movementLoop then
movementLoop:Disconnect()
movementLoop = nil
end
local ccAcc = 0
steppedConn = RunService.Heartbeat:Connect(function(deltaTime)
ccAcc += deltaTime
if ccAcc < 0.05 then
return
end
ccAcc = 0
local plist = getPlayersCached()
for i = 1, #plist do
local p = plist[i]
if p ~= localPlayer then
local character = p.Character
if character then
local children = character:GetChildren()
for i2 = 1, #children do
local part = children[i2]
if part:IsA("BasePart") and part.CanCollide then
part.CanCollide = false
end
end
end
end
end
end)
movementLoop = RunService.RenderStepped:Connect(function()
local character = localPlayer.Character
if not character then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoid or not humanoidRootPart then
return
end
if
not autoBatEnabled
and not autoLeftEnabled
and not autoRightEnabled
and not autoBatV2Enabled
and not batDesyncTpEnabled
and not useCarrySystem
then
if isHumanoidRagdolled(humanoid) then
lastMoveDir = zeroVector
else
local moveDirection = humanoid.MoveDirection
local spd = getActiveMoveSpeed()
if moveDirection.Magnitude > 0 then
lastMoveDir = moveDirection
else
moveDirection = nil
if lastMoveDir.Magnitude > 0 then
local direction = nil
for k in pairs(MOVE_KEYS) do
if UserInputService:IsKeyDown(k) then
direction = lastMoveDir
break
else
direction = nil
end
end
moveDirection = direction
end
end
applyMovementVelocity(moveDirection, spd, humanoidRootPart)
end
end
if speedLabel then
local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
local s = sqrt(
assemblyLinearVelocity.X * assemblyLinearVelocity.X
+ assemblyLinearVelocity.Z * assemblyLinearVelocity.Z
)
if s < 0.05 then
s = 0
end
local nowLabel = os.clock()
if nowLabel - (SPEED_LABEL_LAST or 0) >= 0.1 then
SPEED_LABEL_LAST = nowLabel
speedLabel.Text = string.format("%.1f speed", s)
end
end
end)
setupSpeedIndicator(character)
startEnemySpeed()
end
toggleLockUI = function(state)
if state == nil then
uiLocked = not uiLocked
else
uiLocked = state
end
if uiLocked and editModeEnabled then
editModeEnabled = false
if setEditModeVisual then
setEditModeVisual(false)
end
end
if setLockUIVisual then
setLockUIVisual(uiLocked)
end
end
toggleEditMode = function(state)
if state == nil then
state = not editModeEnabled
end
if state and uiLocked then
state = false
end
editModeEnabled = state
if setEditModeVisual then
setEditModeVisual(state)
end
end
disableAllAimbots = function()
if autoBatEnabled then
disableAutoBat()
if autoBatSetVisual then
autoBatSetVisual(false)
end
if mobSetAutoBat then
mobSetAutoBat(false)
end
end
if batDesyncTpEnabled then
stopBatDesyncTp()
end
if autoBatV2Enabled then
disableBatV2()
if autoBatV2SetVisual then
autoBatV2SetVisual(false)
end
if batV2FloatingButton then
local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
if btnFrame then
paintFloatingBtn(btnFrame, false)
end
end
end
return
end
stopAllBackgroundTasks = function()
if movementLoop then
movementLoop:Disconnect()
movementLoop = nil
end
if steppedConn then
steppedConn:Disconnect()
steppedConn = nil
end
stopEnemySpeed()
if stretchEnabled then
disableStretch()
end
if stretchConn then
stretchConn:Disconnect()
stretchConn = nil
end
if stretchFovConn then
stretchFovConn:Disconnect()
stretchFovConn = nil
end
if antiRagdollController.isRunning() then
antiRagdollController.stop()
end
if antiRagdollV2State.Enabled then
disableAntiRagdollV2()
end
if antiDieEnabled then
antiDie.stop()
end
if antiFlingEnabled then
antiFlingShield.stop()
end
stopBatCounter()
stopBatCounterV2()
stopMedusaCounter()
stopAutoSteal()
disableAutoBat()
if batDesyncTpEnabled then
stopBatDesyncTp()
end
if autoBatV2Enabled then
disableBatV2()
end
stopAutoLeft()
stopAutoRight()
if unwalkEnabled and not isActive then
stopUnwalk()
end
if antiLagEnabled then
disableAntiLag()
end
if espEnabled then
toggleESP(false)
end
if dropActive then
stopDropBrainrot()
end
if bodyLockEnabled then
stopBodyLock()
end
_blSuppressCount = 0
_blWasEnabled = false
if _blRestoreTimer then
pcall(task.cancel, _blRestoreTimer)
_blRestoreTimer = nil
end
if _bodyLockConn then
_bodyLockConn:Disconnect()
_bodyLockConn = nil
end
for _, deltaTime in ipairs(dropConnections) do
if type(deltaTime) == "thread" then
pcall(task.cancel, deltaTime)
elseif type(deltaTime) == "RBXScriptConnection" then
pcall(deltaTime.Disconnect, deltaTime)
end
end
dropConnections = {}
dropActive = false
alPhase = 1
arPhase = 1
lastDropTime = 0
medusaDebounce = false
medusaLastUsed = 0
end
_G.NoPlayerCollisionState = _G.NoPlayerCollisionState or {}
noPlayerCollisionState = _G.NoPlayerCollisionState
noPlayerCollisionState.connections = noPlayerCollisionState.connections or {}
noPlayerCollisionState.parts = noPlayerCollisionState.parts or {}
noPlayerCollisionState.charConns = noPlayerCollisionState.charConns or {}
noPlayerCollisionState.running = noPlayerCollisionState.running or false
isNoPlayerCollisionRunning = function()
return noPlayerCollisionState.running == true
end
trackCollisionPart = function(callback, value)
if not callback or not callback:IsA("BasePart") then
return
end
if noPlayerCollisionState.parts[callback] then
return
end
local data = {
cc = callback.CanCollide,
ct = callback.CanTouch,
}
noPlayerCollisionState.parts[callback] = data
pcall(function()
callback.CanCollide = false
end)
if value then
pcall(function()
callback.CanTouch = false
end)
end
data.conn = callback:GetPropertyChangedSignal("CanCollide"):Connect(function()
if not isNoPlayerCollisionRunning() then
return
end
if callback.CanCollide then
pcall(function()
callback.CanCollide = false
end)
end
end)
data.destroy = callback.AncestryChanged:Connect(function()
if callback:IsDescendantOf(game) then
return
end
if data.conn then
pcall(function()
data.conn:Disconnect()
end)
end
if data.destroy then
pcall(function()
data.destroy:Disconnect()
end)
end
noPlayerCollisionState.parts[callback] = nil
end)
end
restoreCollisionPart = function(instance)
local object = noPlayerCollisionState.parts[instance]
if not object then
return
end
if object.conn then
pcall(function()
object.conn:Disconnect()
end)
end
if object.destroy then
pcall(function()
object.destroy:Disconnect()
end)
end
noPlayerCollisionState.parts[instance] = nil
if instance and instance.Parent then
pcall(function()
instance.CanCollide = object.cc
end)
pcall(function()
instance.CanTouch = object.ct
end)
end
end
enforceCharacterNoCollision = function(callback, value)
if not callback then
return
end
for _, descendant in ipairs(callback:GetDescendants()) do
if descendant:IsA("BasePart") and noPlayerCollisionState.parts[descendant] then
if not (value and descendant.Name == "HumanoidRootPart") then
if descendant.CanCollide then
pcall(function()
descendant.CanCollide = false
end)
end
end
end
end
end
do
local function watchHumanoidCollisionState(callback, instance, value)
if not noPlayerCollisionState.charConns[instance] then
noPlayerCollisionState.charConns[instance] = {}
end
table.insert(
noPlayerCollisionState.charConns[instance],
callback.StateChanged:Connect(function()
if not isNoPlayerCollisionRunning() then
return
end
task.defer(function()
if isNoPlayerCollisionRunning() and instance.Parent then
enforceCharacterNoCollision(instance, value)
end
end)
end)
)
table.insert(
noPlayerCollisionState.charConns[instance],
callback:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
if not isNoPlayerCollisionRunning() then
return
end
task.defer(function()
if isNoPlayerCollisionRunning() and instance.Parent then
enforceCharacterNoCollision(instance, value)
end
end)
end)
)
end
watchCharacterCollision = function(callback, value)
if not callback then
return
end
if noPlayerCollisionState.charConns[callback] then
return
end
noPlayerCollisionState.charConns[callback] = {}
local function trackCharacterDescendant(descendant)
if not isNoPlayerCollisionRunning() then
return
end
if not descendant:IsA("BasePart") then
return
end
if value and descendant.Name == "HumanoidRootPart" then
return
end
trackCollisionPart(descendant, not value)
end
for _, descendant in ipairs(callback:GetDescendants()) do
trackCharacterDescendant(descendant)
end
table.insert(
noPlayerCollisionState.charConns[callback],
callback.DescendantAdded:Connect(trackCharacterDescendant)
)
local humanoid = callback:FindFirstChildOfClass("Humanoid")
if not humanoid then
local connection2 = nil
connection2 = callback.ChildAdded:Connect(function(child)
if child:IsA("Humanoid") then
connection2:Disconnect()
watchHumanoidCollisionState(child, callback, value)
end
end)
table.insert(noPlayerCollisionState.charConns[callback], connection2)
else
watchHumanoidCollisionState(humanoid, callback, value)
end
table.insert(
noPlayerCollisionState.charConns[callback],
callback.AncestryChanged:Connect(function(child, parent)
if parent == nil then
local data = noPlayerCollisionState.charConns[callback] or {}
for _, connection in ipairs(data) do
pcall(function()
connection:Disconnect()
end)
end
noPlayerCollisionState.charConns[callback] = nil
end
end)
)
end
end
do
local function belongsToOtherPlayer(value)
local assemblyRootPart = value.AssemblyRootPart
if not assemblyRootPart then
return false
end
local model = assemblyRootPart:FindFirstAncestorOfClass("Model")
if not model then
return false
end
local playerFromCharacter = Players:GetPlayerFromCharacter(model)
return playerFromCharacter ~= nil and playerFromCharacter ~= localPlayer
end
handleAddedWorkspacePart = function(descendant)
if not isNoPlayerCollisionRunning() then
return
end
if not descendant:IsA("BasePart") then
return
end
if noPlayerCollisionState.parts[descendant] then
return
end
task.defer(function()
if not isNoPlayerCollisionRunning() then
return
end
if not descendant.Parent then
return
end
if belongsToOtherPlayer(descendant) then
trackCollisionPart(descendant, true)
end
end)
end
end
do
local function startNoPlayerCollision()
if noPlayerCollisionState.running then
return
end
noPlayerCollisionState.running = true
local connections = noPlayerCollisionState.connections or {}
for _, connection2 in ipairs(connections) do
pcall(function()
connection2:Disconnect()
end)
end
noPlayerCollisionState.connections = {}
local function addCollisionConnection(value)
table.insert(noPlayerCollisionState.connections, value)
end
local function watchPlayerCollision(player)
if player == localPlayer then
return
end
if player.Character then
watchCharacterCollision(player.Character, false)
end
addCollisionConnection(player.CharacterAdded:Connect(function(character)
if isNoPlayerCollisionRunning() then
watchCharacterCollision(character, false)
end
end))
end
for _, player in ipairs(Players:GetPlayers()) do
watchPlayerCollision(player)
end
addCollisionConnection(Players.PlayerAdded:Connect(watchPlayerCollision))
if localPlayer.Character then
watchCharacterCollision(localPlayer.Character, true)
end
addCollisionConnection(localPlayer.CharacterAdded:Connect(function(character)
if isNoPlayerCollisionRunning() then
watchCharacterCollision(character, true)
end
end))
for _, child in ipairs(Workspace:GetChildren()) do
handleAddedWorkspacePart(child)
end
addCollisionConnection(Workspace.DescendantAdded:Connect(handleAddedWorkspacePart))
local value = 0
addCollisionConnection(RunService.Heartbeat:Connect(function(deltaTime)
if not isNoPlayerCollisionRunning() then
return
end
value += deltaTime or 0
if value < 1 then
return
end
value = 0
for _, player in ipairs(Players:GetPlayers()) do
local character = player.Character
if character then
local isActive = player == localPlayer
enforceCharacterNoCollision(character, isActive)
for _, descendant in ipairs(character:GetDescendants()) do
if descendant:IsA("BasePart") and not noPlayerCollisionState.parts[descendant] then
if not (isActive and descendant.Name == "HumanoidRootPart") then
trackCollisionPart(descendant, not isActive)
end
end
end
end
end
end))
end
local function stopNoPlayerCollision()
if not noPlayerCollisionState.running then
return
end
noPlayerCollisionState.running = false
local connections = noPlayerCollisionState.connections or {}
for _, connection2 in ipairs(connections) do
pcall(function()
connection2:Disconnect()
end)
end
noPlayerCollisionState.connections = {}
for k, charConn in pairs(noPlayerCollisionState.charConns) do
for _, connection in ipairs(charConn) do
pcall(function()
connection:Disconnect()
end)
end
noPlayerCollisionState.charConns[k] = nil
end
for k in pairs(noPlayerCollisionState.parts) do
restoreCollisionPart(k)
end
noPlayerCollisionState.parts = {}
end
_G.SetNoPlayerCollision = function(value)
local noPlayerCollisionEnabled1809 = value and true or false
noPlayerCollisionEnabled = noPlayerCollisionEnabled1809
if noPlayerCollisionEnabled1809 then
startNoPlayerCollision()
else
stopNoPlayerCollision()
end
end
end
end
setNoPlayerCollision = function(noPlayerCollision)
local noPlayerCollisionEnabled1811 = noPlayerCollision and true or false
noPlayerCollisionEnabled = noPlayerCollisionEnabled1811
if noPlayerCollisionEnabled1811 then
if _G.SetNoPlayerCollision then
_G.SetNoPlayerCollision(true)
end
elseif _G.SetNoPlayerCollision then
_G.SetNoPlayerCollision(false)
end
end
_G._NoCamCollision = _G._NoCamCollision
or {
targetZoom = 10,
currentZoom = 10,
zoomConn = nil,
watchConns = {},
resync = true,
}
enableNoCamCollision = function()
noCamCollisionEnabled = true
local noCamCollision = _G._NoCamCollision
local currentCamera2 = workspace.CurrentCamera
noCamCollision.targetZoom = math.clamp(10, localPlayer.CameraMinZoomDistance, localPlayer.CameraMaxZoomDistance)
noCamCollision.currentZoom = noCamCollision.targetZoom
noCamCollision.resync = true
if noCamCollision.zoomConn then
noCamCollision.zoomConn:Disconnect()
end
noCamCollision.zoomConn = UserInputService.InputChanged:Connect(function(input, gameProcessed)
if not noCamCollisionEnabled then
return
end
if gameProcessed then
return
end
if input.UserInputType == Enum.UserInputType.MouseWheel then
noCamCollision.targetZoom = math.clamp(
noCamCollision.targetZoom - input.Position.Z * 4,
localPlayer.CameraMinZoomDistance,
localPlayer.CameraMaxZoomDistance
)
end
end)
local watchConns = noCamCollision.watchConns or {}
for _, watchConn in ipairs(watchConns) do
pcall(function()
watchConn:Disconnect()
end)
end
noCamCollision.watchConns = {}
local function markCameraForResync()
noCamCollision.resync = true
end
table.insert(
noCamCollision.watchConns,
localPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(markCameraForResync)
)
table.insert(
noCamCollision.watchConns,
localPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(markCameraForResync)
)
table.insert(
noCamCollision.watchConns,
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(markCameraForResync)
)
table.insert(noCamCollision.watchConns, localPlayer.CharacterAdded:Connect(markCameraForResync))
if currentCamera2 then
table.insert(
noCamCollision.watchConns,
currentCamera2:GetPropertyChangedSignal("CameraType"):Connect(markCameraForResync)
)
table.insert(
noCamCollision.watchConns,
currentCamera2:GetPropertyChangedSignal("CameraSubject"):Connect(markCameraForResync)
)
end
pcall(function()
RunService:UnbindFromRenderStep("FictionNoCamCollision")
end)
RunService:BindToRenderStep("FictionNoCamCollision", Enum.RenderPriority.Camera.Value + 1, function(value)
if not noCamCollisionEnabled then
return
end
local currentCamera3 = workspace.CurrentCamera
if not currentCamera3 then
return
end
if currentCamera3.CameraType == Enum.CameraType.Scriptable then
noCamCollision.resync = true
return
end
if currentCamera3.CameraSubject == nil then
noCamCollision.resync = true
return
end
local character = localPlayer.Character
if not (character and character:FindFirstChild("HumanoidRootPart")) then
noCamCollision.resync = true
return
end
local cameraMinZoomDistance = localPlayer.CameraMinZoomDistance
local cameraMaxZoomDistance = localPlayer.CameraMaxZoomDistance
if cameraMaxZoomDistance <= 1 then
noCamCollision.resync = true
return
end
local magnitude = (currentCamera3.CFrame.Position - currentCamera3.Focus.Position).Magnitude
if magnitude < 0.6 then
noCamCollision.resync = true
return
end
if noCamCollision.resync or magnitude > noCamCollision.currentZoom + 0.5 then
noCamCollision.targetZoom = math.clamp(magnitude, cameraMinZoomDistance, cameraMaxZoomDistance)
noCamCollision.currentZoom = noCamCollision.targetZoom
noCamCollision.resync = false
end
noCamCollision.targetZoom = math.clamp(noCamCollision.targetZoom, cameraMinZoomDistance, cameraMaxZoomDistance)
noCamCollision.currentZoom = noCamCollision.currentZoom
+ (noCamCollision.targetZoom - noCamCollision.currentZoom) * math.min(value * 15, 1)
currentCamera3.CFrame = currentCamera3.Focus
* currentCamera3.CFrame.Rotation
* newCFrame(0, 0, noCamCollision.currentZoom)
end)
end
disableNoCamCollision = function()
noCamCollisionEnabled = false
pcall(function()
RunService:UnbindFromRenderStep("FictionNoCamCollision")
end)
if _G._NoCamCollision.zoomConn then
_G._NoCamCollision.zoomConn:Disconnect()
_G._NoCamCollision.zoomConn = nil
end
local watchConns = _G._NoCamCollision.watchConns or {}
for _, watchConn in ipairs(watchConns) do
pcall(function()
watchConn:Disconnect()
end)
end
_G._NoCamCollision.watchConns = {}
end
buildConfigTable = function()
local config = {
normalSpeed = NS,
carrySpeed = CS,
laggerSpeed1 = LAGGER_SPEED,
laggerSpeed2 = LAGGER_CARRY_SPEED,
stealRadius = CONFIG.STEAL_RANGE,
antiRagdollMode = antiRagdollMode,
antiDieEnabled = antiDieEnabled,
autoSteal = CONFIG.AUTO_STEAL_ENABLED,
medusaCounter = medusaCounterEnabled,
batCounter = batCounterEnabled,
batCounterV2 = batCounterV2Enabled,
laggerToggled = laggerToggled,
laggerCarryToggled = laggerCarryToggled,
carryMode = speedMode,
batAimbotSpeed = BAT_AIMBOT_SPEED,
batAimBypassOn = batAimBypassEnabled == true,
dropMode = dropMode,
stretchEnabled = stretchEnabled,
stretchFOV = stretchFOV,
fovEnabled = fovEnabled,
fovValue = fovValue,
uiScale = uiScaleValue,
animPack = currentAnimPack,
espEnabled = espEnabled,
antiLag = antiLagEnabled,
tpBatEnabled = batDesyncTpEnabled,
neonWeather = neonWeatherEnabled,
skyTheme = skyTheme,
autoBatV2Enabled = autoBatV2Enabled,
selectedAimbotMode = selectedAimbotMode,
ANTI_BYPASS_AIMBOT_SPEED = _G.AceAntiBypassAimbotSpeed,
ANTI_BYPASS_LAGGER_AIMBOT_SPEED = _G.AceAntiBypassLaggerAimbotSpeed,
antiBypassAimbotEnabled = _G.AceAntiBypassAimbotOn == true,
katanaSkinEnabled = katanaSkinEnabled,
minecraftBatSkinEnabled = minecraftBatSkinEnabled,
minecraftBatSkinColorMode = minecraftBatSkinColorMode,
cloverHubSongIndex = currentIntroSongIndex,
cloverHubAutoTPDown = CloverHubAutoTPDown,
cloverHubAutoTPDownHeight = CloverHubAutoTPDownHeight,
cloverHubShowE01Warning = CloverHubShowE01Warning,
unwalk = unwalkEnabled,
holdJumpEnabled = infJumpEnabled,
holdJumpMode = infJumpMode,
mirrorTPDown = mirrorTPDownEnabled,
safeMode = antiKickEnabled,
noPlayerCollision = noPlayerCollisionEnabled == true,
noCamCollision = noCamCollisionEnabled == true,
antiLag = antiLagEnabled == true,
hideMobileButtons = _G.AmbitiousHideMobileButtons == true,
mobileHideList = _G.AmbitiousMobileHideList,
mobileButtonPositions = savedButtonPositions,
dropBrainrotKey = {
kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name,
gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name,
},
autoLeftKey = {
kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name,
gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name,
},
autoRightKey = {
kb = KB.AutoRight.kb and KB.AutoRight.kb.Name,
gp = KB.AutoRight.gp and KB.AutoRight.gp.Name,
},
autoBatKey = {
kb = KB.AutoBat.kb and KB.AutoBat.kb.Name,
gp = KB.AutoBat.gp and KB.AutoBat.gp.Name,
},
tpFloorKey = {
kb = KB.TPFloor.kb and KB.TPFloor.kb.Name,
gp = KB.TPFloor.gp and KB.TPFloor.gp.Name,
},
carryToggleKey = {
kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name,
gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name,
},
laggerModeKey = {
kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name,
gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name,
},
tpBatKey = {
kb = KB.TPBat.kb and KB.TPBat.kb.Name,
gp = KB.TPBat.gp and KB.TPBat.gp.Name,
},
batV2Key = {
kb = KB.BatV2.kb and KB.BatV2.kb.Name,
gp = KB.BatV2.gp and KB.BatV2.gp.Name,
},
instaResetKey = {
kb = KB.InstaReset.kb and KB.InstaReset.kb.Name,
gp = KB.InstaReset.gp and KB.InstaReset.gp.Name,
},
layoutV = 4,
tpBatFloatingPos = tpBatFloatingPos,
batV2FloatingPos = batV2FloatingPos,
instaResetFloatingPos = instaResetFloatingPos,
bodyLockEnabled = bodyLockEnabled,
bodyLockRange = bodyLockRange,
progressBarPos = savedProgressBarPos,
progressBarScale = progressBarScale,
lockUI = uiLocked,
editMode = editModeEnabled,
floatingButtonScale = floatingButtonScale,
outfitIndex = currentOutfitIndex,
backgroundIndex = backgroundIndex,
backgroundImageTransparency = backgroundImageTransparency,
themeColor = currentColorTheme,
useCarrySystem = useCarrySystem,
autoStealVariant = autoStealVariant,
carrySysNormal = carryController.normalSpeed,
carrySysCarry = carryController.carrySpeed,
carrySysLagger = carryController.laggerSpeed,
carrySysLaggerCarry = carryController.laggerCarrySpeed,
carrySysSoftStealSpeed = carryController.softStealSpeed,
carrySysSoftStealRadius = carryController.softStealRadius,
}
if pbFrame then
config.progressBarPos = {
XScale = pbFrame.Position.X.Scale,
XOffset = pbFrame.Position.X.Offset,
YScale = pbFrame.Position.Y.Scale,
YOffset = pbFrame.Position.Y.Offset,
}
end
if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
local floatingPanel = MobilePanel:FindFirstChild("FloatingPanel")
config.mobilePanelPos = {
XScale = floatingPanel.Position.X.Scale,
XOffset = floatingPanel.Position.X.Offset,
YScale = floatingPanel.Position.Y.Scale,
YOffset = floatingPanel.Position.Y.Offset,
}
end
return config
end
saveAllSettings = function()
if _isResetting or _isLoading then
return true
end
if not writefile then
warn("[CloverHub] writefile not supported by this executor")
return false
end
local okBuild, json = pcall(function()
return HttpService:JSONEncode(buildConfigTable())
end)
if not okBuild or type(json) ~= "string" then
warn("[CloverHub] Config build failed: " .. tostring(json))
return false
end
local fileExists = false
if isfile then
local okIs, exists = pcall(isfile, CONFIG_FILE)
fileExists = okIs and exists == true
end
if json == _lastSavedJSON and fileExists then
return true
end
local ok, err = pcall(writefile, CONFIG_FILE, json)
if ok then
_lastSavedJSON = json
else
warn("[CloverHub] Config write failed: " .. tostring(err))
end
return ok
end
_G.__CloverLoadInner = function()
if not isfile or not isfile(CONFIG_FILE) then
return false
end
local ok, result = pcall(function()
return HttpService:JSONDecode(readfile(CONFIG_FILE))
end)
if not ok or not result then
return false
end
_isLoading = true
NS = result.normalSpeed or NS
CS = result.carrySpeed or CS
LAGGER_SPEED = result.laggerSpeed1 or LAGGER_SPEED
LAGGER_CARRY_SPEED = result.laggerSpeed2 or LAGGER_CARRY_SPEED
CONFIG.STEAL_RANGE = result.stealRadius or CONFIG.STEAL_RANGE
if radInput then
radInput.Text = tostring(CONFIG.STEAL_RANGE)
end
uiLocked = result.lockUI ~= false
editModeEnabled = result.editMode or false
if result.antiRagdollMode then
antiRagdollMode = result.antiRagdollMode
else
antiRagdollMode = result.antiRagdoll and "v2" or "off"
end
antiDieEnabled = result.antiDieEnabled or false
antiFlingEnabled = result.antiFlingEnabled or false
CONFIG.AUTO_STEAL_ENABLED = result.autoSteal or false
medusaCounterEnabled = result.medusaCounter or false
batCounterEnabled = result.batCounter or false
batCounterV2Enabled = result.batCounterV2 or false
unwalkEnabled = result.unwalk or false
antiLagEnabled = result.antiLag or false
laggerToggled = result.laggerToggled or false
speedMode = result.carryMode or false
laggerCarryToggled = result.laggerCarryToggled or false
uiScaleValue = result.uiScale or 78
if mainUIScale then
mainUIScale.Scale = uiScaleValue / 100
end
progressBarScale = result.progressBarScale or 1
if pbScale then
pbScale.Scale = progressBarScale
end
espEnabled = result.espEnabled or false
if espEnabled then
toggleESP(true)
else
toggleESP(false)
end
currentColorTheme = "Gris"
selectedColor = colorThemes["Gris"]
_G.AceAntiBypassLoadFromConfig(result)
autoBatV2Enabled = _G.AceAntiBypassAimbotOn == true
if autoBatV2Enabled then
task.defer(function()
enableBatV2()
if autoBatV2SetVisual then
autoBatV2SetVisual(true)
end
end)
elseif autoBatV2SetVisual then
autoBatV2SetVisual(false)
end
katanaSkinEnabled = result.katanaSkinEnabled or false
minecraftBatSkinEnabled = result.minecraftBatSkinEnabled or false
minecraftBatSkinColorMode = result.minecraftBatSkinColorMode or "Default"
if MinecraftBatSetVisual then
MinecraftBatSetVisual(minecraftBatSkinEnabled)
end
if MinecraftBatColorSelector then
MinecraftBatColorSelector.Text = minecraftBatSkinColorMode
end
if minecraftBatSkinEnabled then
minecraftBatSkinController.State.enabled = true
minecraftBatSkinController.SetColorMode(minecraftBatSkinColorMode)
task.defer(function()
pcall(minecraftBatSkinController.Apply)
end)
else
minecraftBatSkinController.State.enabled = false
task.defer(function()
pcall(minecraftBatSkinController.Remove)
end)
end
if type(result.cloverHubSongIndex) == "number" then
local value = #introSongIds
currentIntroSongIndex = math.clamp(math.floor(result.cloverHubSongIndex), 1, value)
end
CloverHubAutoTPDown = result.cloverHubAutoTPDown == true
CloverHubAutoTPDownHeight = math.clamp(tonumber(result.cloverHubAutoTPDownHeight) or CloverHubAutoTPDownHeight, 0, 500)
CloverHubShowE01Warning = result.cloverHubShowE01Warning == true
if CloverHubAutoTPDownSetVisual then
CloverHubAutoTPDownSetVisual(CloverHubAutoTPDown)
end
if CloverHubShowE01WarningSetVisual then
CloverHubShowE01WarningSetVisual(CloverHubShowE01Warning)
end
if katanaSkinEnabled then
task.defer(function()
pcall(function()
katanaSkinController.ApplySkin("KATANA")
end)
end)
end
tpBatVersion = 1
_G.__tpBatV2Distance = 8
infJumpEnabled = result.holdJumpEnabled == true
infJumpMode = result.holdJumpMode == "MANUAL" and "MANUAL" or "HOLD"
mirrorTPDownEnabled = result.mirrorTPDown == true
antiKickEnabled = result.safeMode == true
noPlayerCollisionEnabled = result.noPlayerCollision == true
noCamCollisionEnabled = result.noCamCollision == true
if result.antiLag == true then
pcall(enableAntiLag)
end
if setAntiLagVisual then
setAntiLagVisual(antiLagEnabled == true)
end
if noPlayerCollisionEnabled then
if _G.SetNoPlayerCollision then
_G.SetNoPlayerCollision(true)
end
end
if noCamCollisionEnabled then
enableNoCamCollision()
end
if setNoPlayerCollisionVisual then
setNoPlayerCollisionVisual(noPlayerCollisionEnabled)
end
if setNoCamCollisionVisual then
setNoCamCollisionVisual(noCamCollisionEnabled)
end
_G.AmbitiousHideMobileButtons = result.hideMobileButtons == true
_G.AmbitiousMobileHideList = type(result.mobileHideList) == "table" and result.mobileHideList or {}
if result.tpBatEnabled then
task.defer(function()
startBatDesyncTp()
if batDesyncTpSetVisual then
batDesyncTpSetVisual(true)
end
end)
elseif batDesyncTpSetVisual then
batDesyncTpSetVisual(false)
end
skyTheme = result.skyTheme or "Off"
if skyTheme ~= "Off" then
pcall(applyCustomSky, skyTheme)
end
if skySelectorLabel then
skySelectorLabel.Text = skyTheme
end
neonWeatherEnabled = result.neonWeather or false
if neonWeatherEnabled then
task.defer(function()
toggleNeonWeather(true)
end)
else
toggleNeonWeather(false)
skyTheme = "Off"
pcall(applyCustomSky, "Off")
if skySelectorLabel then
skySelectorLabel.Text = "Off"
end
end
if result.animPack and ANIM_PACKS[result.animPack] then
applyAnimationPack(result.animPack)
else
currentAnimPack = "Off"
disableAnimationPack()
end
local function lk(e, d)
if not d then
return
end
if d.kb and Enum.KeyCode[d.kb] then
e.kb = Enum.KeyCode[d.kb]
end
if d.gp and Enum.KeyCode[d.gp] then
e.gp = Enum.KeyCode[d.gp]
end
end
lk(KB.DropBrainrot, result.dropBrainrotKey)
lk(KB.AutoLeft, result.autoLeftKey)
lk(KB.AutoRight, result.autoRightKey)
lk(KB.AutoBat, result.autoBatKey)
lk(KB.TPFloor, result.tpFloorKey)
lk(KB.CarryToggle, result.carryToggleKey)
lk(KB.LaggerMode, result.laggerModeKey)
lk(KB.TPBat, result.tpBatKey)
lk(KB.BatV2, result.batV2Key)
lk(KB.InstaReset, result.instaResetKey)
if result.mobileButtonPositions then
savedButtonPositions = result.mobileButtonPositions
end
if result.layoutV == 4 then
if result.mobilePanelPos then
savedMobilePanelPos = result.mobilePanelPos
end
if result.tpBatFloatingPos then
tpBatFloatingPos = result.tpBatFloatingPos
end
if result.batV2FloatingPos then
batV2FloatingPos = result.batV2FloatingPos
end
if result.instaResetFloatingPos then
instaResetFloatingPos = result.instaResetFloatingPos
end
end
if result.progressBarPos then
savedProgressBarPos = result.progressBarPos
end
if result.bodyLockEnabled ~= nil then
bodyLockEnabled = result.bodyLockEnabled
if bodyLockEnabled then
task.defer(function()
if bodyLockSetVisual then
bodyLockSetVisual(true)
end
startBodyLock()
end)
end
end
if result.bodyLockRange then
bodyLockRange = result.bodyLockRange
if bodyLockRangeBox then
bodyLockRangeBox.Text = tostring(bodyLockRange)
end
end
dropMode = result.dropMode or 1
stretchEnabled = result.stretchEnabled or false
fovValue = result.fovValue or 70
fovEnabled = result.fovEnabled or false
if fovSliderSet then
fovSliderSet(fovValue)
end
if fovEnabled then
enableCustomFov()
end
if setFovVisual then
setFovVisual(fovEnabled)
end
stretchFOV = result.stretchFOV or 120
BAT_AIMBOT_SPEED = math.clamp(tonumber(result.batAimbotSpeed) or BAT_AIMBOT_SPEED, 1, 60)
batAimBypassEnabled = result.batAimBypassOn == true
if batAimBypassSetVisual then
batAimBypassSetVisual(batAimBypassEnabled)
end
floatingButtonScale = result.floatingButtonScale or 1
if result.outfitIndex and result.outfitIndex >= 1 and result.outfitIndex <= #outfits then
currentOutfitIndex = result.outfitIndex
task.defer(function()
pcall(function()
applyOutfitByIndex(currentOutfitIndex)
end)
if outfitSelectorLabel then
outfitSelectorLabel.Text = outfits[currentOutfitIndex].label
end
end)
end
if result.backgroundIndex then
backgroundIndex = clamp(result.backgroundIndex, 1, #BACKGROUND_IMAGES)
end
if result.backgroundImageTransparency ~= nil then
backgroundImageTransparency = clamp(result.backgroundImageTransparency, 0, 1)
end
useCarrySystem = result.useCarrySystem or false
autoStealVariant = clamp(tonumber(result.autoStealVariant) or 1, 1, 3)
if autoStealVariantLabel then
autoStealVariantLabel.Text = getAutoStealVariantName(autoStealVariant)
end
carryController.normalSpeed = result.carrySysNormal or NS
carryController.carrySpeed = result.carrySysCarry or CS
carryController.laggerSpeed = result.carrySysLagger or LAGGER_SPEED
carryController.laggerCarrySpeed = result.carrySysLaggerCarry or LAGGER_CARRY_SPEED
carryController.softStealSpeed = result.carrySysSoftStealSpeed or 30
carryController.softStealRadius = result.carrySysSoftStealRadius or 10
if useCarrySystem then
carryController:start()
carryController.speedToggled = speedMode
if laggerCarryToggled then
carryController:setLaggerMode(2)
elseif laggerToggled then
carryController:setLaggerMode(1)
else
carryController:setLaggerMode(0)
end
else
carryController:stop()
end
autoBatEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
if dropModeBtnRef then
dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
end
refreshSpeedModeLabel()
if unwalkEnabled then
task.defer(function()
startUnwalk()
if setUnwalkVisual then
setUnwalkVisual(true)
end
end)
elseif setUnwalkVisual then
setUnwalkVisual(false)
end
_lastSavedJSON = HttpService:JSONEncode(buildConfigTable())
_isLoading = false
return true
end
loadAllSettings = function()
local okLoad, loadResult = pcall(_G.__CloverLoadInner)
if not okLoad then
warn("[CloverHub] Config load error: " .. tostring(loadResult))
_isLoading = false
return false
end
return loadResult
end
forceResetUI = function()
if normalBox then
normalBox.Text = tostring(NS)
end
if carryBox then
carryBox.Text = tostring(CS)
end
if radInput then
radInput.Text = tostring(CONFIG.STEAL_RANGE)
end
if laggerBox then
laggerBox.Text = tostring(LAGGER_SPEED)
end
if lagger2Box then
lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
end
if batSpeedBox then
batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
end
if uiScaleBox then
uiScaleBox.Text = tostring(uiScaleValue)
end
if dropModeBtnRef then
dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
end
if bodyLockRangeBox then
bodyLockRangeBox.Text = tostring(bodyLockRange)
end
if carrySysNormalBox then
carrySysNormalBox.Text = tostring(carryController.normalSpeed)
end
if carrySysCarryBox then
carrySysCarryBox.Text = tostring(carryController.carrySpeed)
end
if carrySysLaggerBox then
carrySysLaggerBox.Text = tostring(carryController.laggerSpeed)
end
if carrySysLaggerCarryBox then
carrySysLaggerCarryBox.Text = tostring(carryController.laggerCarrySpeed)
end
if carrySysSoftStealSpeedBox then
carrySysSoftStealSpeedBox.Text = tostring(carryController.softStealSpeed)
end
if carrySysSoftStealRadiusBox then
carrySysSoftStealRadiusBox.Text = tostring(carryController.softStealRadius)
end
if carrySystemToggleSetter then
carrySystemToggleSetter(useCarrySystem)
end
local function setVisualSafely(callback, visible)
if callback then
callback(visible)
end
end
setVisualSafely(autoBatSetVisual, false)
setVisualSafely(autoLeftSetVisual, false)
setVisualSafely(autoRightSetVisual, false)
setVisualSafely(setBatCounterVisual, false)
setVisualSafely(setBatCounterV2Visual, false)
setVisualSafely(setMedusaVisual, false)
setVisualSafely(setUnwalkVisual, false)
setVisualSafely(setAntiLagVisual, false)
setVisualSafely(setLockUIVisual, false)
setVisualSafely(setEditModeVisual, false)
setVisualSafely(setInstaGrab, false)
setVisualSafely(batDesyncTpSetVisual, false)
setVisualSafely(setESPVIsual, false)
setVisualSafely(bodyLockSetVisual, false)
setVisualSafely(setNeonWeatherVisual, false)
setVisualSafely(autoBatV2SetVisual, false)
setVisualSafely(setAntiDieVisual, false)
setVisualSafely(MinecraftBatSetVisual, false)
setVisualSafely(setSafeModeVisual, false)
setVisualSafely(mirrorTPDownSetVisual, false)
setVisualSafely(infJumpSetVisual, false)
setVisualSafely(infJumpModeSetVisual, nil)
noPlayerCollisionEnabled = false
noCamCollisionEnabled = false
if _G.SetNoPlayerCollision then
_G.SetNoPlayerCollision(false)
end
disableNoCamCollision()
setVisualSafely(setNoPlayerCollisionVisual, false)
setVisualSafely(setNoCamCollisionVisual, false)
if _G.stretchToggleSetter then
_G.stretchToggleSetter(false)
end
setVisualSafely(mobSetAutoBat, false)
setVisualSafely(mobSetAutoLeft, false)
setVisualSafely(mobSetAutoRight, false)
setVisualSafely(mobSetDropBR, false)
setVisualSafely(mobSetTpDown, false)
setVisualSafely(mobSetCarry, false)
setVisualSafely(mobSetLagger1, false)
setVisualSafely(mobSetLagger2, false)
autoStealVariant = 1
if autoStealVariantLabel then
autoStealVariantLabel.Text = getAutoStealVariantName(1)
end
tpBatVersion = 1
_G.__tpBatV2Distance = 8
minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"
minecraftBatSkinController.State.enabled = false
minecraftBatSkinController.State.colorMode = "Default"
pcall(minecraftBatSkinController.Remove)
if MinecraftBatColorSelector then
MinecraftBatColorSelector.Text = "Default"
end
refreshSpeedModeLabel()
updateProgressBarVisibility()
disableAntiLag()
toggleNeonWeather(false)
skyTheme = "Off"
pcall(applyCustomSky, "Off")
if skySelectorLabel then
skySelectorLabel.Text = "Off"
end
disableBatV2()
if antiDieEnabled then
antiDie.stop()
antiDieEnabled = false
end
if antiFlingEnabled then
antiFlingShield.stop()
antiFlingEnabled = false
end
for _, entry1857 in ipairs(keyButtonRefs) do
local entry = entry1857.entry
entry1857.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
end
currentColorTheme = "Gris"
selectedColor = colorThemes["Gris"]
updateAllUIThemeColors(selectedColor)
backgroundIndex = 1
if backgroundImage then
applyBackground(1)
end
if contentPages and contentPages.Visual then
for _, child in ipairs(contentPages.Visual:GetChildren()) do
if child:IsA("Frame") and child:FindFirstChild("BackgroundPreview") then
local previewImage = child.BackgroundPreview:FindFirstChild("PreviewImage")
local previewPlaceholder = child.BackgroundPreview:FindFirstChild("PreviewPlaceholder")
if previewImage then
previewImage.Image = ""
end
if previewPlaceholder then
previewPlaceholder.Visible = true
end
break
end
end
end
if miniBtn then
miniBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
end
local playerGui = localPlayer:FindFirstChild("PlayerGui")
if playerGui then
local ragCountdownBillboard = playerGui:FindFirstChild("RagCountdownBillboard")
if ragCountdownBillboard then
local textLabel = ragCountdownBillboard:FindFirstChildOfClass("TextLabel")
if textLabel then
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end
end
end
if MobilePanel then
local floatingPanel = MobilePanel:FindFirstChild("FloatingPanel")
if floatingPanel then
local buttonsContainer = floatingPanel:FindFirstChild("ButtonsContainer")
if buttonsContainer then
for _, child in ipairs(buttonsContainer:GetChildren()) do
if child:IsA("TextButton") then
local textLabel = child:FindFirstChildOfClass("TextLabel")
if textLabel then
if not (child.BackgroundColor3 == selectedColor) then
textLabel.TextColor3 = selectedColor
end
end
end
end
end
end
end
saveAllSettings()
end
resetFloatingPositions = function()
if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
local floatingPanel = MobilePanel:FindFirstChild("FloatingPanel")
floatingPanel.Position = UDim2.new(1, -10, 1, -364)
savedButtonPositions = {}
if floatingPanel:FindFirstChild("ButtonsContainer") then
for _, child in ipairs(floatingPanel.ButtonsContainer:GetChildren()) do
if child:IsA("TextButton") and child.Name then
local defX, defY = getDefaultButtonPosition(child.Name)
child.Position = UDim2.new(0, defX, 0, defY)
end
end
end
end
if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
tpBatFloatingButton:FindFirstChild("Frame").Position = UDim2.new(1, -146, 1, -208)
tpBatFloatingPos = nil
end
if batV2FloatingButton and batV2FloatingButton:FindFirstChild("Frame") then
batV2FloatingButton:FindFirstChild("Frame").Position = UDim2.new(1, -146, 1, -286)
batV2FloatingPos = nil
end
if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
instaResetFloatingButton.Frame.Position = UDim2.new(1, -146, 1, -130)
instaResetFloatingPos = nil
end
if pbFrame then
pbFrame.Position = UDim2.new(0.5, -190, 1, -60)
savedProgressBarPos = nil
end
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batV2FloatingPos = nil
end
resetToFactoryDefaults = function()
_isResetting = true
local ok, result = pcall(function()
stopAllBackgroundTasks()
stopAutoSteal()
stopBatCounter()
stopBatCounterV2()
stopMedusaCounter()
if antiRagdollController.isRunning() then
antiRagdollController.stop()
end
if antiRagdollV2State.Enabled then
disableAntiRagdollV2()
end
if antiDieEnabled then
antiDie.stop()
end
if antiFlingEnabled then
antiFlingShield.stop()
end
stopUnwalk()
disableAutoBat()
if batDesyncTpEnabled then
stopBatDesyncTp()
end
disableBatV2()
if batAimEnabled then
disableBatAim()
end
toggleBatAimBypass(false)
if batAimBypassSetVisual then
batAimBypassSetVisual(false)
end
stopBodyLock()
if espEnabled then
toggleESP(false)
end
if stretchEnabled then
disableStretch()
end
if antiLagEnabled then
disableAntiLag()
end
if dropActive then
stopDropBrainrot()
end
toggleNeonWeather(false)
skyTheme = "Off"
pcall(applyCustomSky, "Off")
if skySelectorLabel then
skySelectorLabel.Text = "Off"
end
if antiDieEnabled then
antiDie.stop()
antiDieEnabled = false
end
if antiFlingEnabled then
antiFlingShield.stop()
antiFlingEnabled = false
end
noPlayerCollisionEnabled = false
noCamCollisionEnabled = false
if _G.SetNoPlayerCollision then
_G.SetNoPlayerCollision(false)
end
disableNoCamCollision()
if setNoPlayerCollisionVisual then
setNoPlayerCollisionVisual(false)
end
if setNoCamCollisionVisual then
setNoCamCollisionVisual(false)
end
NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
CONFIG.STEAL_RANGE = 61
speedMode = false
laggerToggled = false
laggerCarryToggled = false
antiRagdollMode = "off"
antiDieEnabled = false
antiFlingEnabled = false
medusaCounterEnabled = false
batCounterEnabled = false
batCounterV2Enabled = false
autoBatEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
unwalkEnabled = false
antiLagEnabled = false
uiLocked = true
editModeEnabled = false
CONFIG.AUTO_STEAL_ENABLED = false
autoStealVariant = 1
BAT_AIMBOT_SPEED = 55
-- NewBatAimbot will pick this up via BAT_AIMBOT_CONFIG.chaseSpeed = BAT_AIMBOT_SPEED
dropMode = 1
stretchEnabled = false
stretchFOV = 120
fovValue = 70
disableCustomFov()
if fovSliderSet then
fovSliderSet(70)
end
if setFovVisual then
setFovVisual(false)
end
uiScaleValue = 78
if mainUIScale then
mainUIScale.Scale = 1
end
progressBarScale = 1
if pbScale then
pbScale.Scale = progressBarScale
end
espEnabled = false
bodyLockEnabled = false
bodyLockRange = 20
autoBatV2Enabled = false
katanaSkinEnabled = false
pcall(function()
katanaSkinController.ApplySkin("NONE")
end)
minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"
minecraftBatSkinController.State.enabled = false
minecraftBatSkinController.State.colorMode = "Default"
pcall(minecraftBatSkinController.Remove)
floatingButtonScale = 1
if batDesyncTpEnabled then
stopBatDesyncTp()
end
tpBatVersion = 1
_G.__tpBatV2Distance = 8
currentAnimPack = "Off"
disableAnimationPack()
currentOutfitIndex = 1
currentColorTheme = "Gris"
selectedColor = colorThemes.Gris
backgroundIndex = 1
backgroundImageTransparency = 0.35
applyBackground(1)
for k, entry in pairs(DEFAULT_KB) do
if KB[k] then
KB[k].kb = entry.kb
KB[k].gp = entry.gp
end
end
useCarrySystem = false
carryController:stop()
carryController.normalSpeed = NS
carryController.carrySpeed = CS
carryController.laggerSpeed = LAGGER_SPEED
carryController.laggerCarrySpeed = LAGGER_CARRY_SPEED
carryController.softStealSpeed = 30
carryController.softStealRadius = 10
carryController.speedToggled = false
carryController.laggerMode = 0
carryController.softStealEnabled = false
infJumpEnabled = false
infJumpMode = "HOLD"
mirrorTPDownEnabled = false
antiKickEnabled = false
_G.AmbitiousHideMobileButtons = false
_G.AmbitiousMobileHideList = {}
if _G.AmbitiousApplyMobileButtonsHidden then
_G.AmbitiousApplyMobileButtonsHidden()
end
pcall(disableAntiLag)
if setAntiLagVisual then
setAntiLagVisual(false)
end
if isfile and isfile(CONFIG_FILE) then
pcall(delfile, CONFIG_FILE)
end
resetFloatingPositions()
forceResetUI()
updateProgressBarVisibility()
refreshSpeedModeLabel()
_lastSavedJSON = nil
saveAllSettings()
end)
_isResetting = false
if not ok then
warn("[resetToFactoryDefaults]", result)
end
return ok
end
updateProgressBarVisibility = function()
if pbFrame then
pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
end
end
applyShimmerToText = function(object, speed)
local value = speed or 0.8
local color = getThemeColor()
local uiGradient = Instance.new("UIGradient", object)
local data = {}
local object = ColorSequenceKeypoint.new(0, color)
local object1953 = ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 0, 0))
local object1954 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
local object1955 = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0))
data[1] = object
data[2] = object1953
data[3] = object1954
data[4] = object1955
data[5] = ColorSequenceKeypoint.new(1, color)
uiGradient.Color = ColorSequence.new(data)
uiGradient.Rotation = 45
uiGradient.Offset = Vector2.new(0, 0)
task.spawn(function()
local deltaTime = 0
while uiGradient and uiGradient.Parent do
deltaTime += 0.02
uiGradient.Offset = Vector2.new(math.sin(deltaTime * value) * 0.4, 0)
task.wait(0.04)
end
end)
return uiGradient
end
getDefaultButtonPosition = function(btnName)
local value = ({
DropBR = 0,
AutoLeft = 1,
AutoBat = 2,
AutoRight = 3,
TpDown = 4,
Carry = 5,
Lagger1 = 6,
Lagger2 = 7,
Float = 8,
})[btnName] or 0
return value % 2 * 68, floor(value / 2) * 78
end
_G.AmbitiousHideMobileButtons = _G.AmbitiousHideMobileButtons == true
_G.AmbitiousMobileHideList = _G.AmbitiousMobileHideList or {}
_G.AmbitiousMobileHideIncluded = function(value)
local object = _G.AmbitiousMobileHideList[value]
if object == nil then
return true
end
return object == true
end
_G.AmbitiousApplyMobileButtonsHidden = function()
local isActive = _G.AmbitiousHideMobileButtons == true
local data = {
BatV2Button = "batV2",
InstaResetButton = "instaReset",
}
for _, entry in ipairs({
"CloverHubMobilePanel",
"BatV2Button",
"InstaResetButton",
}) do
local playerGui = game:GetService("CoreGui"):FindFirstChild(entry)
if not playerGui then
playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
playerGui = playerGui and playerGui:FindFirstChild(entry) or nil
end
if playerGui then
local object = data[entry]
if object then
playerGui.Enabled = not (isActive and _G.AmbitiousMobileHideIncluded(object))
else
local floatingPanel = playerGui:FindFirstChild("FloatingPanel")
floatingPanel = floatingPanel and floatingPanel:FindFirstChild("ButtonsContainer")
if floatingPanel then
local data = {
TpDown = "tp",
AutoBat = "aimbot",
AutoLeft = "autoLeft",
AutoRight = "autoRight",
DropBR = "drop",
Carry = "carry",
Lagger1 = "laggerNormal",
Lagger2 = "laggerCarry",
Float = "float",
}
for _, child in ipairs(floatingPanel:GetChildren()) do
if child:IsA("TextButton") then
child.Visible = not (
isActive and _G.AmbitiousMobileHideIncluded(data[child.Name] or child.Name)
)
end
end
end
end
end
end
end
do
local data = {
{
key = "drop",
label = "Drop BR",
},
{
key = "autoPlay",
label = "Auto Play",
},
{
key = "aimbot",
label = "Bat Aimbot",
},
{
key = "batV2",
label = "Bat Bypass",
},
{
key = "instaReset",
label = "Insta Reset",
},
{
key = "antiTPBat",
label = "Anti TP Bat",
},
{
key = "float",
label = "Float",
},
{
key = "tp",
label = "TP Down",
},
{
key = "carry",
label = "Carry Speed",
},
{
key = "laggerNormal",
label = "Lagger Normal",
},
{
key = "laggerCarry",
label = "Lagger Carry",
},
}
print("[IR] 1. inicio")
if _G.InstaResetLoaded then
print("[IR] ya cargado")
else
local isActive, thread, object, isActive1979, isActive1980, cFrame, object1982, instaResetFast
_G.InstaResetLoaded = true
isActive = false
thread = nil
object = nil
do
local isEnabled = false
isActive1979 = false
isActive1980 = false
cFrame = nil
object1982 = 0
print("[IR] 2. servicios OK, LP =", localPlayer and localPlayer.Name)
instaResetFast = function()
if isActive then
return
end
isActive = true
isEnabled = false
isActive1979 = false
isActive1980 = false
local character = localPlayer.Character
if not character then
isActive = false
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid then
isActive = false
return
end
local currentCamera2 = workspace.CurrentCamera
if currentCamera2 then
cFrame = currentCamera2.CFrame
isActive1980 = true
currentCamera2.CFrame = cFrame
end
object = character
local isRespawning = false
thread = task.spawn(function()
local attempts = 0
local hipHeight = humanoid.HipHeight
while true do
if
character
and character.Parent
and humanoid
and humanoid.Health > 0
and not isRespawning
and not isActive1979
then
if localPlayer.Character ~= character then
isRespawning = true
break
else
pcall(function()
humanoid.HipHeight = 1e30
humanoid.AutoRotate = true
local rootPart = character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CanCollide = false
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
child.CanCollide = false
end
end
end)
if
not character
or not character.Parent
or not humanoid
or humanoid.Health <= 0
or localPlayer.Character ~= character
then
isEnabled = true
break
else
attempts += 1
if not (attempts >= 40) then
task.wait(0.05)
continue
end
end
end
end
break
end
if not isEnabled then
if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
pcall(function()
humanoid.Health = 0
end)
task.wait(0.1)
if not character.Parent or humanoid.Health <= 0 then
isEnabled = true
end
end
end
if not isEnabled and character and character.Parent and humanoid then
pcall(function()
humanoid.HipHeight = hipHeight
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if humanoidRootPart then
humanoidRootPart.CanCollide = true
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
child.CanCollide = true
end
end
end)
end
isActive1980 = false
isActive = false
thread = nil
object = nil
isActive1979 = false
end)
end
end
do
local function instaReset()
local now2 = os.clock()
if now2 - object1982 < 0.75 then
return
end
object1982 = now2
instaResetFast()
end
print("[IR] 3. función lista")
localPlayer.CharacterAdded:Connect(function()
isActive1979 = true
if thread then
pcall(task.cancel, thread)
thread = nil
end
isActive = false
object = nil
isActive1980 = false
end)
task.spawn(function()
while true do
task.wait(0.016)
local currentCamera2 = workspace.CurrentCamera
if isActive1980 and cFrame and currentCamera2 then
currentCamera2.CFrame = cFrame
end
end
end)
print("[IR] 4. loop cámara iniciado")
_G.InstaReset = {
Trigger = instaReset,
}
end
end
buildGui = function()
Color3.fromRGB(0, 0, 0)
local color = Color3.fromRGB(0, 0, 0)
Color3.fromRGB(0, 0, 0)
Color3.fromRGB(0, 0, 0)
Color3.fromRGB(0, 0, 0)
local color2 = Color3.fromRGB(0, 0, 0)
local color3 = Color3.fromRGB(0, 0, 0)
local color4 = Color3.fromRGB(255, 255, 255)
Color3.fromRGB(0, 0, 0)
local color5 = Color3.fromRGB(0, 0, 0)
Color3.fromRGB(0, 0, 0)
local textColor3 = color
Color3.fromRGB(0, 0, 0)
Color3.fromRGB(0, 0, 0)
local cloverHub = game:GetService("CoreGui"):FindFirstChild("CloverHub")
if cloverHub then
cloverHub:Destroy()
end
local playerGui = localPlayer:FindFirstChild("PlayerGui")
if playerGui then
local cloverHub2 = playerGui:FindFirstChild("CloverHub")
if cloverHub2 then
cloverHub2:Destroy()
end
end
gui = Instance.new("ScreenGui")
gui.Enabled = false
gui.Name = "CloverHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
pcall(function()
if syn and syn.protect_gui then
syn.protect_gui(gui)
end
end)
if not pcall(function()
gui.Parent = game:GetService("CoreGui")
end) then
gui.Parent = localPlayer:WaitForChild("PlayerGui")
end
main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 340, 0, 500)
main.Position = UDim2.new(0, 20, 0, 2)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
do
local mainBgGradient = Instance.new("UIGradient", main)
mainBgGradient.Rotation = 90
mainBgGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
end
do
local mainTitle = Instance.new("TextLabel", main)
mainTitle.Name = "K7HubTopTitle"
mainTitle.AnchorPoint = Vector2.new(0.5, 0)
mainTitle.Position = UDim2.new(0.5, 0, 0, 12)
mainTitle.Size = UDim2.new(1, -16, 0, 54)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "WHITE HUB"
mainTitle.Font = Enum.Font.GothamBlack
mainTitle.TextSize = 44
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mainTitle.TextStrokeTransparency = 0.15
mainTitle.TextXAlignment = Enum.TextXAlignment.Center
mainTitle.ZIndex = 100
local mainTitleGradient = Instance.new("UIGradient", mainTitle)
mainTitleGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
end
backgroundImage = Instance.new("ImageLabel", main)
backgroundImage.Name = "BackgroundImage"
backgroundImage.Size = UDim2.new(1, 0, 1, 0)
backgroundImage.Position = UDim2.new(0, 0, 0, 0)
backgroundImage.BackgroundTransparency = 1
backgroundImage.BorderSizePixel = 0
backgroundImage.Image = ""
backgroundImage.ScaleType = Enum.ScaleType.Stretch
backgroundImage.ImageTransparency = 1
backgroundImage.ZIndex = 1
Instance.new("UICorner", backgroundImage).CornerRadius = UDim.new(0, 18)
local decor = Instance.new("CanvasGroup", main)
decor.Name = "BackgroundDecor"
decor.Size = UDim2.new(1, 0, 1, 0)
decor.BackgroundTransparency = 1
decor.GroupTransparency = 1
decor.ZIndex = 2
Instance.new("UICorner", decor).CornerRadius = UDim.new(0, 18)
local function decorBar(w, h, cx, cy, rot, color)
local bar = Instance.new("Frame", decor)
bar.AnchorPoint = Vector2.new(0.5, 0.5)
bar.Size = UDim2.fromOffset(w, h)
bar.Position = UDim2.fromOffset(cx, cy)
bar.Rotation = rot
bar.BackgroundColor3 = color
bar.BorderSizePixel = 0
bar.ZIndex = 2
return bar
end
mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = uiScaleValue / 100
local frame = Instance.new("Frame", main)
frame.Name = "TitleFrame"
frame.Size = UDim2.new(1, -24, 0, 92)
frame.Position = UDim2.new(0, 12, 0, 8)
frame.BackgroundTransparency = 1
frame.ZIndex = 20
-- PNG3 K7 header removed as requested.
local textButton = Instance.new("TextButton", main)
textButton.Size = UDim2.new(0, 28, 0, 28)
textButton.Position = UDim2.new(1, -38, 0, 10)
textButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textButton.BackgroundTransparency = 0.6
textButton.BorderSizePixel = 0
textButton.Text = "X"
textButton.TextColor3 = color4
textButton.Font = Enum.Font.GothamBlack
textButton.TextSize = 15
textButton.AutoButtonColor = false
textButton.ZIndex = 200
Instance.new("UICorner", textButton).CornerRadius = UDim.new(1, 0)
textButton.MouseEnter:Connect(function()
TweenService:Create(textButton, TweenInfo.new(0.12), {
TextColor3 = color4,
BackgroundColor3 = getThemeColor(),
}):Play()
end)
textButton.MouseLeave:Connect(function()
TweenService:Create(textButton, TweenInfo.new(0.12), {
TextColor3 = color4,
BackgroundColor3 = Color3.fromRGB(0, 0, 0),
}):Play()
end)
miniBtn = Instance.new("TextButton", gui)
miniBtn.Name = "VerisDuelsOpener"
miniBtn.Size = UDim2.new(0, 178, 0, 46)
miniBtn.Position = UDim2.new(0, 16, 0, 58)
miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miniBtn.BackgroundTransparency = 0
miniBtn.BorderSizePixel = 0
miniBtn.ClipsDescendants = true
miniBtn.Text = ""
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 14
miniBtn.AutoButtonColor = false
miniBtn.ZIndex = 20
miniBtn.Visible = false
local openerCorner = Instance.new("UICorner", miniBtn)
openerCorner.CornerRadius = UDim.new(0, 14)
local openerGradient = Instance.new("UIGradient", miniBtn)
openerGradient.Rotation = 0
openerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
local openerStroke = Instance.new("UIStroke", miniBtn)
openerStroke.Color = Color3.fromRGB(255, 255, 255)
openerStroke.Thickness = 1.4
openerStroke.Transparency = 0.12
local openerScale = Instance.new("UIScale", miniBtn)
openerScale.Scale = 1
miniBtn.MouseEnter:Connect(function()
    TweenService:Create(miniBtn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    TweenService:Create(openerStroke, TweenInfo.new(0.14), {Transparency = 0}):Play()
    TweenService:Create(openerScale, TweenInfo.new(0.14), {Scale = 1.035}):Play()
end)
miniBtn.MouseLeave:Connect(function()
    TweenService:Create(miniBtn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}):Play()
    TweenService:Create(openerStroke, TweenInfo.new(0.14), {Transparency = 0.12}):Play()
    TweenService:Create(openerScale, TweenInfo.new(0.14), {Scale = 1}):Play()
end)
local rootPart = Instance.new("TextLabel", miniBtn)
rootPart.Name = "MiniTitleImage"
rootPart.AnchorPoint = Vector2.new(0.5, 0.5)
rootPart.Size = UDim2.new(1, -12, 1, -8)
rootPart.Position = UDim2.new(0.5, 0, 0.5, 0)
rootPart.BackgroundTransparency = 1
rootPart.Text = "WHITE HUB  ›"
rootPart.Font = Enum.Font.GothamBlack
rootPart.TextScaled = false
rootPart.TextSize = 14
rootPart.TextColor3 = Color3.fromRGB(255, 255, 255)
local rootPartGradient = Instance.new("UIGradient", rootPart)
rootPartGradient.Rotation = 90
rootPartGradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
local rootPartStroke = Instance.new("UIStroke", rootPart)
rootPartStroke.Thickness = 0.7
rootPartStroke.Color = Color3.fromRGB(0, 0, 0)
rootPart.ZIndex = 21
local tween = nil
local position = main.Position
showGui = function()
if tween then
tween:Cancel()
end
if not main then
return
end
main.Visible = true
miniBtn.Visible = false
main.Position = UDim2.new(0, -350, 0, 2)
local data = {
Position = position,
}
tween = TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), data)
tween:Play()
tween.Completed:Connect(function()
tween = nil
end)
end
hideGui = function()
if tween then
tween:Cancel()
end
if not main or not main.Visible then
return
end
local udim2 = UDim2.new(0, -350, 0, 2)
tween = TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
Position = udim2,
})
tween:Play()
tween.Completed:Connect(function()
main.Visible = false
miniBtn.Visible = true
tween = nil
end)
return
end
textButton.MouseButton1Click:Connect(hideGui)
miniBtn.MouseButton1Click:Connect(showGui)
local rootPart1954 = Instance.new("Frame", main)
rootPart1954.Size = UDim2.new(1, -32, 0, 34)
local rootPart1955 = Instance.new("Frame", main)
rootPart1955.Name = "TabsDivider"
rootPart1955.Size = UDim2.new(1, -32, 0, 1)
rootPart1955.Position = UDim2.new(0, 16, 0, 56)
rootPart1955.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rootPart1955.BackgroundTransparency = 0.7
rootPart1955.BorderSizePixel = 0
rootPart1955.ZIndex = 11
rootPart1955.Visible = false
rootPart1954.Position = UDim2.new(0, 8, 1, -52)
rootPart1954.Size = UDim2.new(1, -16, 0, 40)
rootPart1954.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
rootPart1954.BackgroundTransparency = 0.25
Instance.new("UICorner", rootPart1954).CornerRadius = UDim.new(1, 0)
local tabBarStroke = Instance.new("UIStroke", rootPart1954)
tabBarStroke.Color = Color3.fromRGB(0, 0, 0)
tabBarStroke.Thickness = 1.5
tabBarStroke.Transparency = 0.2
rootPart1954.ZIndex = 10
local uiListLayout = Instance.new("UIListLayout", rootPart1954)
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, 4)
local rootPart1957 = Instance.new("Frame", main)
rootPart1957.Size = UDim2.new(1, -16, 1, -150)
rootPart1957.Position = UDim2.new(0, 8, 0, 84)
rootPart1957.BackgroundTransparency = 1
rootPart1957.ClipsDescendants = true
rootPart1957.ZIndex = 5
tabButtons = {}
local data2022 = {}
for i, text1960 in ipairs({
"Speed",
"Custom",
"Visual",
"Settings",
"Keybinds",
}) do
local textButton = Instance.new("TextButton", rootPart1954)
textButton.Size = UDim2.new(0.185, 0, 1, -8)
textButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textButton.BackgroundTransparency = 1
textButton.BorderSizePixel = 0
textButton.Text = text1960
textButton.TextColor3 = textColor3
textButton.Font = Enum.Font.GothamBold
textButton.TextSize = 11
textButton.AutoButtonColor = false
textButton.ZIndex = 11
Instance.new("UICorner", textButton).CornerRadius = UDim.new(1, 0)
local scrollingFrame = Instance.new("ScrollingFrame", rootPart1957)
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.Position = UDim2.new(0, 0, 0, 0)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
scrollingFrame.BackgroundTransparency = 0.6
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ClipsDescendants = true
scrollingFrame.ScrollBarThickness = 2
scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
scrollingFrame.ScrollBarImageTransparency = 0.3
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollingFrame.ZIndex = 6
Instance.new("UICorner", scrollingFrame).CornerRadius = UDim.new(0, 16)
scrollingFrame.Visible = i == 1
local uiListLayout2 = Instance.new("UIListLayout", scrollingFrame)
uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout2.Padding = UDim.new(0, 6)
uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
local uiPadding = Instance.new("UIPadding", scrollingFrame)
uiPadding.PaddingLeft = UDim.new(0, 8)
uiPadding.PaddingRight = UDim.new(0, 8)
uiPadding.PaddingTop = UDim.new(0, 6)
uiPadding.PaddingBottom = UDim.new(0, 20)
data2022[text1960] = scrollingFrame
textButton.MouseButton1Click:Connect(function()
for _, pg in pairs(data2022) do
pg.Visible = false
end
scrollingFrame.Visible = true
for _, b in ipairs(tabButtons) do
b.TextColor3 = textColor3
b.BackgroundTransparency = 1
local underline = b:FindFirstChild("Underline")
if underline then
underline.Visible = false
end
end
textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton.BackgroundTransparency = 0
local selectedUnderline = textButton:FindFirstChild("Underline")
if selectedUnderline then
selectedUnderline.Visible = true
end
end)
table.insert(tabButtons, textButton)
end
if tabButtons[1] then
tabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
tabButtons[1].BackgroundTransparency = 0
local firstUnderline = tabButtons[1]:FindFirstChild("Underline")
if firstUnderline then
firstUnderline.Visible = true
end
end
local data2034 = {}
local function nextLayoutOrder(page)
if not data2034[page] then
data2034[page] = 0
end
data2034[page] = data2034[page] + 1
return data2034[page]
end
local function createFrame(page, txt)
local f = Instance.new("Frame", page)
f.Size = UDim2.new(1, 0, 0, 26)
f.BackgroundTransparency = 1
f.BorderSizePixel = 0
f.LayoutOrder = nextLayoutOrder(page)
f.ZIndex = 7
local bar = Instance.new("Frame", f)
bar.Size = UDim2.new(0, 3, 0, 14)
bar.Position = UDim2.new(0, 4, 0.5, -7)
bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
bar.BorderSizePixel = 0
bar.ZIndex = 8
local l = Instance.new("TextLabel", f)
l.Size = UDim2.new(0, 10, 1, 0)
l.AutomaticSize = Enum.AutomaticSize.X
l.Position = UDim2.new(0, 14, 0, 0)
l.BackgroundTransparency = 1
l.Text = txt:upper()
l.TextColor3 = Color3.fromRGB(255, 255, 255)
l.Font = Enum.Font.GothamBold
l.TextSize = 11
l.TextXAlignment = Enum.TextXAlignment.Left
l.TextStrokeTransparency = 1
l.ZIndex = 8
local line = Instance.new("Frame", f)
line.Size = UDim2.new(1, -40, 0, 1)
line.Position = UDim2.new(0, 36, 0.5, 0)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.55
line.BorderSizePixel = 0
line.ZIndex = 8
local function placeLine()
local textWidth = l.AbsoluteSize.X
line.Position = UDim2.new(0, 14 + textWidth + 10, 0.5, 0)
line.Size = UDim2.new(1, -(14 + textWidth + 10 + 8), 0, 1)
end
l:GetPropertyChangedSignal("AbsoluteSize"):Connect(placeLine)
task.defer(placeLine)
return f
end
local function createFrame2(value, value2045)
local frame = Instance.new("Frame", value)
frame.Size = UDim2.new(1, -4, 0, value2045 or 38)
frame.BackgroundColor3 = color2
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel = 0
frame.LayoutOrder = nextLayoutOrder(value)
frame.ZIndex = 7
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Thickness = 1.5
uiStroke.Transparency = 0.2
frame.MouseEnter:Connect(function()
TweenService:Create(frame, TweenInfo.new(0.1), {
BackgroundColor3 = Color3.fromRGB(0, 0, 0),
}):Play()
end)
frame.MouseLeave:Connect(function()
local data = {
BackgroundColor3 = color2,
}
TweenService:Create(frame, TweenInfo.new(0.1), data):Play()
end)
return frame
end
local function mkLabel(row, text)
local l = Instance.new("TextLabel", row)
l.Size = UDim2.new(0.55, 0, 1, 0)
l.Position = UDim2.new(0, 10, 0, 0)
l.BackgroundTransparency = 1
l.Text = text
l.TextColor3 = Color3.fromRGB(255, 255, 255)
l.Font = Enum.Font.GothamBold
l.TextSize = 12
l.TextXAlignment = Enum.TextXAlignment.Left
l.TextTruncate = Enum.TextTruncate.AtEnd
l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
l.TextStrokeTransparency = 1
l.ZIndex = 8
return l
end
local function mkPill(row, offset)
local pill = Instance.new("Frame", row)
pill.Name = "Track"
pill.Size = UDim2.new(0, 34, 0, 18)
pill.AnchorPoint = Vector2.new(0.5, 0.5)
pill.Position = UDim2.new(1, -(offset or 48), 0.5, 0)
pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
pill.BackgroundTransparency = 0.2
pill.BorderSizePixel = 0
pill.ZIndex = 8
Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
local uiStroke = Instance.new("UIStroke", pill)
uiStroke.Color = color3
uiStroke.Thickness = 1
uiStroke.Transparency = 0.45
uiStroke.Name = "PillStroke"
local dot = Instance.new("Frame", pill)
dot.Name = "Knob"
dot.Size = UDim2.new(0, 13, 0, 13)
dot.AnchorPoint = Vector2.new(0, 0)
dot.Position = UDim2.new(0, 3, 0.5, -6)
dot.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dot.BorderSizePixel = 0
dot.ZIndex = 9
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
local shine = Instance.new("Frame", dot)
shine.Name = "Shine"
shine.Size = UDim2.new(1, -4, 0, 4)
shine.Position = UDim2.new(0, 2, 0, 2)
shine.BackgroundColor3 = color4
shine.BackgroundTransparency = 0.72
shine.BorderSizePixel = 0
shine.ZIndex = 10
Instance.new("UICorner", shine).CornerRadius = UDim.new(0, 4)
return pill, dot
end
local function animPill(pill, dot, on)
local uiStroke = pill:FindFirstChildOfClass("UIStroke")
local themeColor = getThemeColor()
local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(dot, tweenInfo, {
Position = on and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0),
}):Play()
TweenService:Create(pill, tweenInfo, {
BackgroundColor3 = on and themeColor or Color3.fromRGB(255, 255, 255),
BackgroundTransparency = on and 0 or 0.2,
}):Play()
if uiStroke then
TweenService:Create(uiStroke, tweenInfo, {
Color = on and themeColor or color3,
Transparency = on and 0.2 or 0.45,
Thickness = on and 1.5 or 1,
}):Play()
end
end
local function mkSlider(row, minV, maxV, default, cb)
local track = Instance.new("Frame", row)
track.Size = UDim2.new(0, 118, 0, 4)
track.Position = UDim2.new(1, -162, 0.5, -2)
track.BackgroundColor3 = color5
track.BackgroundTransparency = 0.3
track.BorderSizePixel = 0
track.ZIndex = 8
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
local fill = Instance.new("Frame", track)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = getThemeColor()
fill.BorderSizePixel = 0
fill.ZIndex = 9
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
local knob = Instance.new("Frame", track)
knob.Size = UDim2.new(0, 13, 0, 13)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(0, 0, 0.5, 0)
knob.BackgroundColor3 = color4
knob.BorderSizePixel = 0
knob.ZIndex = 11
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
local uiStroke = Instance.new("UIStroke", knob)
uiStroke.Color = getThemeColor()
uiStroke.Thickness = 2
local valLabel = Instance.new("TextLabel", row)
valLabel.Size = UDim2.new(0, 34, 0, 20)
valLabel.Position = UDim2.new(1, -38, 0.5, -10)
valLabel.BackgroundTransparency = 1
valLabel.Text = tostring(default)
valLabel.TextColor3 = color4
valLabel.Font = Enum.Font.GothamBold
valLabel.TextSize = 11
valLabel.TextXAlignment = Enum.TextXAlignment.Right
valLabel.ZIndex = 9
local hit = Instance.new("TextButton", row)
hit.Size = UDim2.new(0, 134, 0, 26)
hit.Position = UDim2.new(1, -170, 0.5, -13)
hit.BackgroundTransparency = 1
hit.Text = ""
hit.AutoButtonColor = false
hit.ZIndex = 12
local current = default
local function render(a)
local object = clamp(a, 0, 1)
fill.Size = UDim2.new(object, 0, 1, 0)
knob.Position = UDim2.new(object, 0, 0.5, 0)
fill.BackgroundColor3 = getThemeColor()
uiStroke.Color = getThemeColor()
end
local function applyFromX(px)
local x = track.AbsolutePosition.X
local x2 = track.AbsoluteSize.X
if x2 <= 0 then
x2 = 118
end
if x <= 0 then
return
end
local a = clamp((px - x) / x2, 0, 1)
local object = floor(minV + (maxV - minV) * a + 0.5)
current = object
valLabel.Text = tostring(object)
render(a)
if cb then
pcall(cb, object)
end
end
local dragging = false
hit.InputBegan:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
dragging = true
_isDraggingButton = true
applyFromX(input.Position.X)
end
end)
hit.InputEnded:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
dragging = false
_isDraggingButton = false
end
end)
UserInputService.InputChanged:Connect(function(input)
if not dragging then
return
end
if
input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch
then
applyFromX(input.Position.X)
end
end)
UserInputService.InputEnded:Connect(function(input)
if not dragging then
return
end
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
dragging = false
_isDraggingButton = false
end
end)
local function setValue(value)
local object = clamp(tonumber(value) or minV, minV, maxV)
current = object
valLabel.Text = tostring(object)
render((object - minV) / (maxV - minV))
end
setValue(default)
return setValue
end
local function mkToggle(page, txt, cb)
local row = createFrame2(page, 38)
mkLabel(row, txt)
local pill, dot = mkPill(row, 48)
local on = false
local function sv(s)
on = s
animPill(pill, dot, s)
if txt == "Auto Steal" then
    -- Cosmetic-only white/black styling to match the monochrome panel background.
    pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pill.BackgroundTransparency = 0.05
    local pillStroke = pill:FindFirstChildOfClass("UIStroke")
    if pillStroke then
        pillStroke.Color = Color3.fromRGB(0, 0, 0)
        pillStroke.Transparency = 0.15
        pillStroke.Thickness = 1.2
    end
    dot.BackgroundColor3 = s and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(0, 0, 0)
end
end
local clk = Instance.new("TextButton", pill)
clk.Size = UDim2.new(1, 0, 1, 0)
clk.BackgroundTransparency = 1
clk.Text = ""
clk.AutoButtonColor = false
clk.ZIndex = 10
clk.MouseButton1Click:Connect(function()
if editModeEnabled and not uiLocked then
pcall(cb, not on)
else
on = not on
sv(on)
pcall(cb, on)
end
end)
return sv
end
local function createTextBox(parent, default, w, xOff, cb)
local textBox = Instance.new("TextBox", parent)
w = w or 50
local xo = math.max(xOff or 56, w + 12)
textBox.Size = UDim2.new(0, w, 0, 24)
textBox.Position = UDim2.new(1, -xo, 0.5, -12)
textBox.BackgroundColor3 = color5
textBox.BackgroundTransparency = 0.7
textBox.BorderSizePixel = 0
textBox.Text = tostring(default)
textBox.TextColor3 = color4
textBox.Font = Enum.Font.GothamBold
textBox.TextSize = 11
textBox.ClearTextOnFocus = false
textBox.ZIndex = 8
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
local uiStroke = Instance.new("UIStroke", textBox)
uiStroke.Color = color3
uiStroke.Thickness = 1.2
uiStroke.Transparency = 0.25
textBox.Focused:Connect(function()
TweenService:Create(uiStroke, TweenInfo.new(0.12), {
Color = getThemeColor(),
Transparency = 0,
}):Play()
end)
textBox.FocusLost:Connect(function()
local data = {
Color = color3,
Transparency = 0.25,
}
TweenService:Create(uiStroke, TweenInfo.new(0.12), data):Play()
if cb then
local num = tonumber(textBox.Text)
if num then
cb(num)
else
textBox.Text = tostring(default)
end
end
end)
return textBox
end
local function createTextButton(parent, kbEntry)
local button = Instance.new("TextButton", parent)
button.Size = UDim2.new(0, 80, 0, 24)
button.Position = UDim2.new(1, -88, 0.5, -12)
button.BackgroundColor3 = color5
button.BackgroundTransparency = 0.5
button.BorderSizePixel = 0
local function getLabel()
return kbEntry.gp and kbEntry.gp.Name or kbEntry.kb and kbEntry.kb.Name or "None"
end
button.Text = getLabel()
button.TextColor3 = color4
button.Font = Enum.Font.GothamBold
button.TextSize = 9
button.ZIndex = 8
button.AutoButtonColor = false
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
local bs = Instance.new("UIStroke", button)
bs.Color = color3
bs.Thickness = 1
local li = false
local connection2 = nil
local text = button.Text
local listenStart = 0
button.Activated:Connect(function()
if li then
li = false
_anyKeyListening = false
if connection2 then
connection2:Disconnect()
connection2 = nil
end
button.Text = text
button.TextColor3 = color4
return
end
text = button.Text
li = true
_anyKeyListening = true
listenStart = getTime()
button.Text = "..."
button.TextColor3 = color4
connection2 = UserInputService.InputBegan:Connect(function(input)
if not li then
return
end
if input.KeyCode == Enum.KeyCode.Escape then
li = false
_anyKeyListening = false
if connection2 then
connection2:Disconnect()
connection2 = nil
end
button.Text = text
button.TextColor3 = color4
return
end
local isGp = isGamepadInput(input)
if isGp and getTime() - listenStart < 0.15 then
return
end
if not isBindableInput(input) then
return
end
button.Text = input.KeyCode.Name
text = input.KeyCode.Name
button.TextColor3 = color4
li = false
_anyKeyListening = false
if connection2 then
connection2:Disconnect()
connection2 = nil
end
if isGp then
kbEntry.gp = input.KeyCode
kbEntry.kb = nil
else
kbEntry.kb = input.KeyCode
kbEntry.gp = nil
end
end)
end)
table.insert(keyButtonRefs, {
btn = button,
entry = kbEntry,
})
return button
end
local function createCarouselSelector(parent, currentValue, options, onChanged)
local frame = Instance.new("Frame", parent)
frame.Size = UDim2.new(0, 175, 0, 30)
frame.Position = UDim2.new(1, -183, 0.5, -15)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.ZIndex = 8
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = color3
stroke.Thickness = 1
stroke.Transparency = 0.35
local rootPart = Instance.new("Frame", frame)
rootPart.Size = UDim2.new(0, 3, 0.55, 0)
rootPart.Position = UDim2.new(0, 6, 0.225, 0)
rootPart.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
rootPart.BorderSizePixel = 0
rootPart.ZIndex = 9
rootPart.Visible = false
Instance.new("UICorner", rootPart).CornerRadius = UDim.new(1, 0)
local textLabel = Instance.new("TextLabel", frame)
textLabel.Size = UDim2.new(1, -28, 1, 0)
textLabel.Position = UDim2.new(0, 14, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = tostring(currentValue)
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 12
textLabel.TextXAlignment = Enum.TextXAlignment.Center
textLabel.TextTruncate = Enum.TextTruncate.AtEnd
textLabel.ZIndex = 9
for _, arrow in ipairs({ { "‹", UDim2.new(0, 3, 0, 0) }, { "›", UDim2.new(1, -17, 0, 0) } }) do
local arrowLabel = Instance.new("TextLabel", frame)
arrowLabel.Size = UDim2.new(0, 14, 1, 0)
arrowLabel.Position = arrow[2]
arrowLabel.BackgroundTransparency = 1
arrowLabel.Text = arrow[1]
arrowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
arrowLabel.Font = Enum.Font.GothamBlack
arrowLabel.TextSize = 18
arrowLabel.ZIndex = 9
end
local rootPart2076 = Instance.new("Frame", frame)
rootPart2076.Size = UDim2.new(0, 70, 0, 6)
rootPart2076.Position = UDim2.new(1, -76, 0.5, -3)
rootPart2076.BackgroundTransparency = 1
rootPart2076.ZIndex = 9
rootPart2076.Visible = false
local uiListLayout2 = Instance.new("UIListLayout", rootPart2076)
uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right
uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout2.Padding = UDim.new(0, 3)
local indicatorFrames = {}
for i = 1, math.min(#options, 8) do
local frame = Instance.new("Frame", rootPart2076)
frame.Size = UDim2.new(0, 5, 0, 5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
indicatorFrames[i] = frame
end
local selectedIndex = 1
for i, entry in ipairs(options) do
if tostring(entry) == tostring(currentValue) then
selectedIndex = i
break
end
end
local textButton = Instance.new("TextButton", frame)
textButton.Size = UDim2.new(0.5, 0, 1, 0)
textButton.Position = UDim2.new(0, 0, 0, 0)
textButton.BackgroundTransparency = 1
textButton.Text = ""
textButton.AutoButtonColor = false
textButton.ZIndex = 11
local rootPart2085 = Instance.new("TextButton", frame)
rootPart2085.Size = UDim2.new(0.5, 0, 1, 0)
rootPart2085.Position = UDim2.new(0.5, 0, 0, 0)
rootPart2085.BackgroundTransparency = 1
rootPart2085.Text = ""
rootPart2085.AutoButtonColor = false
rootPart2085.ZIndex = 11
local function renderIndicators()
for i, frame in ipairs(indicatorFrames) do
local selected = i == selectedIndex
frame.BackgroundColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
frame.Size = selected and UDim2.new(0, 10, 0, 5) or UDim2.new(0, 5, 0, 5)
end
end
local function animateIndicators()
for i, entry in ipairs(indicatorFrames) do
local selected = i == selectedIndex
TweenService
:Create(entry, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
BackgroundColor3 = selected and Color3.fromRGB(255, 255, 255)
or Color3.fromRGB(0, 0, 0),
Size = selected and UDim2.new(0, 10, 0, 5) or UDim2.new(0, 5, 0, 5),
})
:Play()
end
end
local function animateLabel(text)
local tween2 = TweenService:Create(textLabel, TweenInfo.new(0.1), {
TextTransparency = 1,
Position = UDim2.new(0, 22, 0, 0),
})
tween2:Play()
tween2.Completed:Connect(function()
textLabel.Text = text
textLabel.Position = UDim2.new(0, 4, 0, 0)
TweenService
:Create(textLabel, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
TextTransparency = 0,
Position = UDim2.new(0, 14, 0, 0),
})
:Play()
return
end)
end
local function changeSelection(direction)
selectedIndex += direction
if selectedIndex < 1 then
selectedIndex = #options
end
if #options < selectedIndex then
selectedIndex = 1
end
animateLabel(tostring(options[selectedIndex]))
animateIndicators()
if onChanged then
pcall(onChanged, options[selectedIndex], selectedIndex)
end
end
textButton.MouseButton1Click:Connect(function()
changeSelection(-1)
end)
rootPart2085.MouseButton1Click:Connect(function()
changeSelection(1)
end)
frame.MouseEnter:Connect(function()
TweenService:Create(stroke, TweenInfo.new(0.12), {
Color = Color3.fromRGB(0, 0, 0),
Transparency = 0,
}):Play()
TweenService:Create(rootPart, TweenInfo.new(0.12), {
Size = UDim2.new(0, 4, 0.7, 0),
}):Play()
end)
frame.MouseLeave:Connect(function()
local data = {
Color = color3,
Transparency = 0.35,
}
TweenService:Create(stroke, TweenInfo.new(0.12), data):Play()
TweenService:Create(rootPart, TweenInfo.new(0.12), {
Size = UDim2.new(0, 3, 0.55, 0),
}):Play()
end)
renderIndicators()
local data2164 = {}
setmetatable(data2164, {
__index = function(value, value2167)
return textLabel[value2167]
end,
__newindex = function(value2168, value2169, value2170)
if value2169 == "Text" then
local text = tostring(value2170)
for i, entry in ipairs(options) do
if tostring(entry) == text then
selectedIndex = i
renderIndicators()
break
end
end
textLabel.Text = text
else
textLabel[value2169] = value2170
end
end,
})
return data2164
end
local function createActionRow(parent, labelText, buttonText)
local frame2 = createFrame2(parent, 36)
mkLabel(frame2, labelText)
createTextButton(frame2, buttonText)
end
local speed = data2022.Speed
createFrame(speed, "Base Speeds")
local frame2 = createFrame2(speed, 38)
mkLabel(frame2, "Normal Speed")
normalBox = createTextBox(frame2, NS, 50, 56, function(nS)
if nS > 0 and nS <= 500 then
NS = nS
saveAllSettings()
end
end)
local frame22118 = createFrame2(speed, 38)
mkLabel(frame22118, "Carry Speed")
carryBox = createTextBox(frame22118, CS, 50, 56, function(cS)
if cS > 0 and cS <= 500 then
CS = cS
saveAllSettings()
end
end)
local frame22120 = createFrame2(speed, 38)
mkLabel(frame22120, "Lagger Normal")
laggerBox = createTextBox(frame22120, LAGGER_SPEED, 50, 56, function(lAGGERSPEED)
if lAGGERSPEED > 0 and lAGGERSPEED <= 500 then
LAGGER_SPEED = lAGGERSPEED
saveAllSettings()
end
end)
local frame22122 = createFrame2(speed, 38)
mkLabel(frame22122, "Lagger Carry")
lagger2Box = createTextBox(frame22122, LAGGER_CARRY_SPEED, 50, 56, function(lAGGERCARRYSPEED)
if lAGGERCARRYSPEED > 0 and lAGGERCARRYSPEED <= 500 then
LAGGER_CARRY_SPEED = lAGGERCARRYSPEED
saveAllSettings()
end
end)
-- Bat Aimbot / Bypass Speed settings (customizable 1-60)
local frameBatAim = createFrame2(speed, 38)
mkLabel(frameBatAim, "Bat Aimbot Speed")
batSpeedBox = createTextBox(frameBatAim, BAT_AIMBOT_SPEED, 50, 56, function(val)
    val = math.clamp(tonumber(val) or BAT_AIMBOT_SPEED, 1, 60)
    BAT_AIMBOT_SPEED = val
    if _G.NewBatAimbot and _G.NewBatAimbot.config then
        _G.NewBatAimbot.config.chaseSpeed = val
    end
    saveAllSettings()
end)
local frameBatBypass = createFrame2(speed, 38)
mkLabel(frameBatBypass, "Bat Bypass Speed")
local bypassSpeedBox = createTextBox(frameBatBypass, tonumber(_G.AceAntiBypassAimbotSpeed) or 55, 50, 56, function(val)
    val = math.clamp(tonumber(val) or 55, 1, 60)
    _G.AceAntiBypassAimbotSpeed = val
    if SnowVS and SnowVS.BatBypass and SnowVS.BatBypass.ZCFG then
        SnowVS.BatBypass.ZCFG.FOLLOW_SPEED = val
    end
    saveAllSettings()
end)
local frame22124 = createFrame2(speed, 38)
mkLabel(frame22124, "Current Mode")
local text
if laggerCarryToggled then
text = "Lagger Carry"
elseif laggerToggled then
text = "Lagger"
else
text = "Normal"
if speedMode then
text = "Carry"
end
end
modeValLbl = createCarouselSelector(frame22124, text, {
"Normal",
"Carry",
"Lagger",
"Lagger Carry",
}, function(value)
speedMode = false
laggerToggled = false
laggerCarryToggled = false
if value == "Carry" then
speedMode = true
elseif value == "Lagger" then
laggerToggled = true
elseif value == "Lagger Carry" then
laggerCarryToggled = true
end
resetMovementState()
if mobSetCarry then
mobSetCarry(speedMode)
end
if mobSetLagger1 then
mobSetLagger1(laggerToggled)
end
if mobSetLagger2 then
mobSetLagger2(laggerCarryToggled)
end
end)
createFrame(speed, "Auto Carry System")
carrySystemToggleSetter = mkToggle(speed, "Auto Carry", function(useCarrySystem2127)
useCarrySystem = useCarrySystem2127
if useCarrySystem2127 then
carryController:start()
carryController.speedToggled = speedMode
if laggerCarryToggled then
carryController:setLaggerMode(2)
elseif laggerToggled then
carryController:setLaggerMode(1)
else
carryController:setLaggerMode(0)
end
carryController:setSoftStealEnabled(true)
else
carryController:stop()
carryController:setSoftStealEnabled(false)
end
saveAllSettings()
end)
local frame22128 = createFrame2(speed, 38)
mkLabel(frame22128, "Normal Speed")
carrySysNormalBox = createTextBox(frame22128, carryController.normalSpeed, 50, 56, function(value)
if value > 0 and value <= 500 then
carryController:setNormalSpeed(value)
saveAllSettings()
end
end)
local frame22130 = createFrame2(speed, 38)
mkLabel(frame22130, "Carry Speed")
carrySysCarryBox = createTextBox(frame22130, carryController.carrySpeed, 50, 56, function(value)
if value > 0 and value <= 500 then
carryController:setCarrySpeed(value)
saveAllSettings()
end
end)
local frame22132 = createFrame2(speed, 38)
mkLabel(frame22132, "Lagger Speed")
carrySysLaggerBox = createTextBox(frame22132, carryController.laggerSpeed, 50, 56, function(value)
if value > 0 and value <= 500 then
carryController:setLaggerSpeed(value)
saveAllSettings()
end
end)
local frame22134 = createFrame2(speed, 38)
mkLabel(frame22134, "Lagger Carry Spd")
carrySysLaggerCarryBox = createTextBox(frame22134, carryController.laggerCarrySpeed, 50, 56, function(value)
if value > 0 and value <= 500 then
carryController:setLaggerCarrySpeed(value)
saveAllSettings()
end
end)
local frame22136 = createFrame2(speed, 38)
mkLabel(frame22136, "Soft Steal Speed")
carrySysSoftStealSpeedBox = createTextBox(frame22136, carryController.softStealSpeed, 50, 56, function(value)
if value > 0 and value <= 500 then
carryController:setSoftStealSpeed(value)
saveAllSettings()
end
end)
local frame22138 = createFrame2(speed, 38)
mkLabel(frame22138, "Soft Steal Radius")
carrySysSoftStealRadiusBox = createTextBox(frame22138, carryController.softStealRadius, 50, 56, function(value)
if value > 0 then
carryController:setSoftStealRadius(value)
saveAllSettings()
end
end)
createFrame(speed, "Auto Movement")
autoLeftSetVisual = mkToggle(speed, "Auto Left", function(on)
autoLeftEnabled = on
if on then
startAutoLeft()
else
stopAutoLeft()
end
if mobSetAutoLeft then
mobSetAutoLeft(on)
end
end)
autoRightSetVisual = mkToggle(speed, "Auto Right", function(on)
autoRightEnabled = on
if on then
startAutoRight()
else
stopAutoRight()
end
if mobSetAutoRight then
mobSetAutoRight(on)
end
end)
createFrame(speed, "Teleport")
local frame22142 = createFrame2(speed, 38)
mkLabel(frame22142, "TP Down")
local label = Instance.new("TextButton", frame22142)
label.Size = UDim2.new(0.58, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = ""
label.AutoButtonColor = false
label.ZIndex = 8
label.MouseButton1Click:Connect(function()
teleportDown()
end)
local textLabel = Instance.new("TextLabel", frame22142)
textLabel.Size = UDim2.new(0, 70, 1, 0)
textLabel.Position = UDim2.new(1, -78, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "ACTIVATE"
textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 9
textLabel.TextXAlignment = Enum.TextXAlignment.Right
textLabel.ZIndex = 8
CloverHubAutoTPDownSetVisual = mkToggle(speed, "Auto TP Down", function(cloverHubAutoTPDown)
CloverHubAutoTPDown = cloverHubAutoTPDown
saveAllSettings()
end)
local frame22146 = createFrame2(speed, 38)
mkLabel(frame22146, "TP Down Height")
createTextBox(frame22146, CloverHubAutoTPDownHeight, 50, 56, function(value)
CloverHubAutoTPDownHeight = math.clamp(value, 0, 500)
saveAllSettings()
end)
mirrorTPDownSetVisual = mkToggle(speed, "Mirror TP Down", function(value)
_G.AmbitiousSetMirrorTPDown(value)
end)
infJumpSetVisual = mkToggle(speed, "Hold Jump", function(value)
_G.setInfJumpInternal(value)
saveAllSettings()
end)
local frame22150 = createFrame2(speed, 38)
mkLabel(frame22150, "Jump Mode")
infJumpModeSetVisual = createCarouselSelector(frame22150, infJumpMode, {
"HOLD",
"MANUAL",
}, function(infJumpMode2151)
if infJumpMode2151 ~= "MANUAL" then
infJumpMode2151 = "HOLD"
end
infJumpMode = infJumpMode2151
if infJumpMode == "MANUAL" then
_G.AmbitiousStopNormalInfJumpHoldState()
end
saveAllSettings()
end)
local custom = data2022.Custom
createFrame(custom, "Aimbots")
autoBatSetVisual = mkToggle(custom, "Auto Bat", function(on)
if on then
enableAutoBat()
else
disableAutoBat()
end
if mobSetAutoBat then
mobSetAutoBat(on)
end
end)
batAimBypassSetVisual = mkToggle(custom, "Bat Aimbot Bypass", function(on)
toggleBatAimBypass(on)
end)
spinBotSetVisual = mkToggle(custom, "Spin Bot", function(on)
toggleSpinBot(on)
end)
do
local spinSpeedFrame = createFrame2(custom, 38)
mkLabel(spinSpeedFrame, "Spin Speed")
createTextBox(spinSpeedFrame, SPIN_BOT_SPEED, 50, 56, function(v)
if v and v > 0 and v <= 500 then
SPIN_BOT_SPEED = v
end
end)
end
autoBatV2SetVisual = mkToggle(custom, "Bat Bypass", function(on)
if on then
enableBatV2()
else
disableBatV2()
end
end)
if autoBatV2SetVisual then
autoBatV2SetVisual(autoBatV2Enabled)
end
_G.AceAimbotSetVisual = autoBatV2SetVisual
createFrame(custom, "Counters")
setBatCounterVisual = mkToggle(custom, "Bat Counter", function(on)
batCounterEnabled = on
if on then
startBatCounter()
else
stopBatCounter()
end
end)
setBatCounterV2Visual = mkToggle(custom, "Bat Counter V2", function(on)
batCounterV2Enabled = on
if on then
startBatCounterV2()
else
stopBatCounterV2()
end
end)
setMedusaVisual = mkToggle(custom, "Medusa Counter", function(on)
medusaCounterEnabled = on
if on then
if localPlayer.Character then
setupMedusaCounter(localPlayer.Character)
else
stopMedusaCounter()
end
else
stopMedusaCounter()
end
if setMedusaVisual then
setMedusaVisual(on)
end
end)
createFrame(custom, "Defense")
bodyLockSetVisual = mkToggle(custom, "Body Lock", function(on)
bodyLockEnabled = on
if on then
if _blSuppressCount == 0 then
startBodyLock()
end
else
stopBodyLock()
end
end)
local frame22163 = createFrame2(custom, 38)
mkLabel(frame22163, "Body Lock Range")
bodyLockRangeBox = createTextBox(frame22163, bodyLockRange, 50, 56, function(value)
if value and value > 0 then
bodyLockRange = clamp(floor(value), 5, 200)
if bodyLockRangeBox then
bodyLockRangeBox.Text = tostring(bodyLockRange)
end
end
end)
setSafeModeVisual = mkToggle(custom, "Safe Mode", function(on)
antiKickEnabled = on
if on and _G.AmbitiousSafeModeForceStop then
_G.AmbitiousSafeModeForceStop("SAFE MODE")
end
saveAllSettings()
end)
setNoPlayerCollisionVisual = mkToggle(custom, "No Player Collision", function(on)
setNoPlayerCollision(on)
saveAllSettings()
end)
if setNoPlayerCollisionVisual then
setNoPlayerCollisionVisual(noPlayerCollisionEnabled)
end
createFrame(custom, "Survival")
local frame22167 = createFrame2(custom, 38)
mkLabel(frame22167, "Anti Ragdoll")
local text2232
if antiRagdollMode == "v1" then
text2232 = "V1"
else
text2232 = "Off"
if antiRagdollMode == "v2" then
text2232 = "V2"
end
end
local label2171 = createCarouselSelector(frame22167, text2232, {
"Off",
"V1",
"V2",
}, function(callback)
local lowercaseText = callback:lower()
setAntiRagdollMode(lowercaseText)
end)
_G.updateAntiRagdollUI = function(value)
local text = "Off"
if value == "v1" then
text = "V1"
elseif value == "v2" then
text = "V2"
end
if label2171 then
label2171.Text = text
end
end
_G.updateAntiRagdollUI(antiRagdollMode)
setUnwalkVisual = mkToggle(custom, "Unwalk", function(on)
unwalkEnabled = on
if on then
startUnwalk()
else
stopUnwalk()
end
saveAllSettings()
end)
setAntiDieVisual = mkToggle(custom, "Anti Die", function(on)
antiDieEnabled = on
if on then
antiDie.start()
else
antiDie.stop()
end
saveAllSettings()
end)
if setAntiDieVisual then
setAntiDieVisual(antiDieEnabled)
end
createFrame(custom, "Drop")
dropBrainrotSetVisual = mkToggle(custom, "Drop Brainrot", function(on)
if on then
executeDropWithToggle(function(value)
dropBrainrotSetVisual(value)
if mobSetDropBR then
mobSetDropBR(value)
end
end)
end
end)
setDropVisual = dropBrainrotSetVisual
local frame22179 = createFrame2(custom, 38)
mkLabel(frame22179, "Drop Mode")
dropModeBtnRef = createCarouselSelector(frame22179, dropMode == 1 and "Fling" or "Jump Drop", {
"Fling",
"Jump Drop",
}, function(direction)
if dropActive then
stopDropBrainrot()
end
dropMode = direction == "Fling" and 1 or 2
end)
local visual = data2022.Visual
createFrame(visual, "Interface")
setEditModeVisual = mkToggle(visual, "Edit Button", function(on)
toggleEditMode(on)
if on and uiLocked then
editModeEnabled = false
setEditModeVisual(false)
end
end)
if setEditModeVisual then
setEditModeVisual(editModeEnabled)
end
setLockUIVisual = mkToggle(visual, "Lock UI", function(on)
toggleLockUI(on)
if on and editModeEnabled then
editModeEnabled = false
if setEditModeVisual then
setEditModeVisual(false)
end
end
end)
setESPVIsual = mkToggle(visual, "Player ESP", function(on)
toggleESP(on)
end)
pcall(toggleESP, true)
createFrame(visual, "Camera")
setFovVisual = mkToggle(visual, "FOV", function(on)
if on then
enableCustomFov()
else
disableCustomFov()
end
end)
if setFovVisual then
setFovVisual(fovEnabled)
end
local frame22186 = createFrame2(visual, 38)
mkLabel(frame22186, "FOV Value")
fovSliderSet = mkSlider(frame22186, 20, 120, fovValue, function(fovValue2187)
fovValue = fovValue2187
if not fovEnabled then
enableCustomFov()
if setFovVisual then
setFovVisual(true)
end
end
local currentCamera2 = workspace.CurrentCamera
if currentCamera2 then
pcall(function()
currentCamera2.FieldOfView = fovValue
end)
end
return
end)
setNoCamCollisionVisual = mkToggle(visual, "No Cam Collision", function(on)
if on then
enableNoCamCollision()
else
disableNoCamCollision()
end
saveAllSettings()
end)
if setNoCamCollisionVisual then
setNoCamCollisionVisual(noCamCollisionEnabled)
end
local frame22190 = createFrame2(visual, 38)
mkLabel(frame22190, "Stretch Rez")
local object2255, object2256 = mkPill(frame22190, 48)
local object2257 = false
local function stretchToggleSetter(s)
object2257 = s
animPill(object2255, object2256, s)
if s then
enableStretch()
else
disableStretch()
end
stretchEnabled = s
end
local label2196 = Instance.new("TextButton", object2255)
label2196.Size = UDim2.new(1, 0, 1, 0)
label2196.BackgroundTransparency = 1
label2196.Text = ""
label2196.AutoButtonColor = false
label2196.ZIndex = 10
label2196.MouseButton1Click:Connect(function()
stretchToggleSetter(not object2257)
end)
_G.stretchToggleSetter = stretchToggleSetter
createFrame(visual, "Performance")
setAntiLagVisual = mkToggle(visual, "Anti Lag", function(on)
if on then
enableAntiLag()
else
disableAntiLag()
end
end)
mkToggle(visual, "FPS Boost", function(on)
if on then
enableFpsBoost()
else
disableFpsBoost()
end
end)
mkToggle(visual, "FPS Unlock (60+)", function(on)
if on then
enableFpsBypass(240)
else
disableFpsBypass()
end
end)
do
local fpsFrame = createFrame2(visual, 38)
mkLabel(fpsFrame, "FPS Cap Target")
createTextBox(fpsFrame, 240, 50, 56, function(v)
if v and v >= 60 and v <= 999 then
FPS_BYPASS_TARGET = v
if FPS_BYPASS_ENABLED then
enableFpsBypass(v)
end
end
end)
end
mkToggle(visual, "Better Graphics", function(on)
if on then
enableBetterGraphics()
else
disableBetterGraphics()
end
end)
CloverHubShowE01WarningSetVisual = mkToggle(visual, "Show E01 Warning", function(on)
CloverHubShowE01Warning = on
saveAllSettings()
end)
createFrame(visual, "Environment")
local frame22199 = createFrame2(visual, 38)
mkLabel(frame22199, "Sky Theme")
skySelectorLabel = createCarouselSelector(frame22199, skyTheme, SKY_PRESETS_LIST, function(skyTheme2200)
skyTheme = skyTheme2200
pcall(applyCustomSky, skyTheme2200)
pcall(saveAllSettings)
end)
local chamsOn, feetCircleOn = false, false
local visualsConn = nil
local visualsLast = 0
local function clearPlayerVisuals(kind)
for _, plr in ipairs(Players:GetPlayers()) do
local char = plr.Character
if char then
if kind ~= "feet" then
local cham = char:FindFirstChild("CloverHubChams")
if cham then
pcall(function()
cham:Destroy()
end)
end
end
if kind ~= "chams" then
local root = char:FindFirstChild("HumanoidRootPart")
local feet = root and root:FindFirstChild("CloverHubFeet")
if feet then
pcall(function()
feet:Destroy()
end)
end
end
end
end
end
local function buildCloverFeet(root, footOffset)
local folder = Instance.new("Folder")
folder.Name = "CloverHubFeet"
local leafColor = Color3.fromRGB(255, 255, 255)
local stemColor = Color3.fromRGB(0, 0, 0)
local a = 2.6
local d = a / math.sqrt(2)
local y = -footOffset + 0.1
local function box(size, cx, cz, yaw, color, dy)
local adorn = Instance.new("BoxHandleAdornment")
adorn.Adornee = root
adorn.Size = size
adorn.CFrame = CFrame.new(cx, y + (dy or 0), cz) * CFrame.Angles(0, math.rad(yaw), 0)
adorn.Color3 = color
adorn.Transparency = 0
adorn.AlwaysOnTop = false
adorn.ZIndex = 1
adorn.Parent = folder
end
local function disc(cx, cz, color)
local adorn = Instance.new("CylinderHandleAdornment")
adorn.Adornee = root
adorn.Height = 0.15
adorn.Radius = a / 2
adorn.CFrame = CFrame.new(cx, y, cz) * CFrame.Angles(math.rad(90), 0, 0)
adorn.Color3 = color
adorn.Transparency = 0
adorn.AlwaysOnTop = false
adorn.ZIndex = 1
adorn.Parent = folder
end
box(Vector3.new(0.35, 0.14, 3.6), 1.3, 1.3, 45, stemColor, -0.01)
for i = 0, 3 do
local theta = math.rad(i * 90)
local sinT, cosT = math.sin(theta), math.cos(theta)
local function rotate(lx, lz)
return lx * cosT + lz * sinT, -lx * sinT + lz * cosT
end
local sx, sz = rotate(0, d)
box(Vector3.new(a, 0.15, a), sx, sz, 45 + i * 90, leafColor, 0)
local c1x, c1z = rotate(-d / 2, 1.5 * d)
disc(c1x, c1z, leafColor)
local c2x, c2z = rotate(d / 2, 1.5 * d)
disc(c2x, c2z, leafColor)
end
folder.Parent = root
return folder
end
local function refreshPlayerVisuals()
local now = os.clock()
if now - visualsLast < 0.15 then
return
end
visualsLast = now
for _, plr in ipairs(Players:GetPlayers()) do
local char = plr.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local hum = char and char:FindFirstChildOfClass("Humanoid")
if root and hum and hum.Health > 0 then
local cham = char:FindFirstChild("CloverHubChams")
if chamsOn and plr ~= localPlayer then
if not cham then
cham = Instance.new("Highlight")
cham.Name = "CloverHubChams"
cham.FillColor = Color3.fromRGB(255, 255, 255)
cham.FillTransparency = 0.15
cham.OutlineColor = Color3.fromRGB(255, 255, 255)
cham.OutlineTransparency = 0
cham.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
cham.Adornee = char
cham.Parent = char
end
elseif cham then
pcall(function()
cham:Destroy()
end)
end
local feet = root:FindFirstChild("CloverHubFeet")
if feetCircleOn then
if not feet then
local footOffset = root.Size.Y / 2 + hum.HipHeight
if footOffset < 2.5 then
footOffset = 3
end
feet = buildCloverFeet(root, footOffset)
end
elseif feet then
pcall(function()
feet:Destroy()
end)
end
end
end
end
local function updatePlayerVisualsLoop()
if chamsOn or feetCircleOn then
if not visualsConn then
local visualsAcc = 0
visualsConn = RunService.Heartbeat:Connect(function(dt)
visualsAcc += dt
if visualsAcc < 0.2 then
return
end
visualsAcc = 0
refreshPlayerVisuals()
end)
end
else
if visualsConn then
visualsConn:Disconnect()
visualsConn = nil
end
end
end
mkToggle(visual, "Player Chams", function(on)
chamsOn = on
if not on then
clearPlayerVisuals("chams")
end
updatePlayerVisualsLoop()
end)
mkToggle(visual, "Feet Circle", function(on)
feetCircleOn = on
if not on then
clearPlayerVisuals("feet")
end
updatePlayerVisualsLoop()
end)

-- ═══════════════════════════════════════════════════════════
-- AVATAR CATALOG GUI — scrollable 3D previews (Strike-style grid)
-- ═══════════════════════════════════════════════════════════
do
    local InsertService = game:GetService("InsertService")
    local Players = game:GetService("Players")
    local avatarGui = nil
    local avatarEnabled = false
    local selectedOutfit = 1
    local appliedTag = "WhiteHub_LocalOutfit"

    local OUTFITS = {
        { label = "BLACK",  color = Color3.fromRGB(20, 20, 20), headless = true, items = {74891470} },
        { label = "RED",    color = Color3.fromRGB(180, 30, 40), headless = true, items = {4390891467} },
        { label = "BLUE",   color = Color3.fromRGB(40, 80, 200), items = {76059443, 74891470} },
        { label = "GALAXY", color = Color3.fromRGB(40, 20, 80), headless = true, items = {82831174733357, 139051312584295} },
        { label = "ALIEN",  color = Color3.fromRGB(60, 255, 80), headless = true, bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, items = {10997283529, 125085889448130} },
        { label = "OUTFIT 1", color = Color3.fromRGB(50, 50, 55), bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, items = {125157548394108, 123231522991173, 74827642361405} },
        { label = "OUTFIT 2", color = Color3.fromRGB(70, 70, 75), bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, face = 86109936998865, items = {136644276218918, 132022106987543, 131740907052260} },
        { label = "OUTFIT 3", color = Color3.fromRGB(90, 90, 95), headless = true, bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, items = {119331031817124, 84952305140948} },
        { label = "OUTFIT 4", color = Color3.fromRGB(110, 100, 90), headless = true, bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322}, items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702} },
        { label = "OUTFIT 5", color = Color3.fromRGB(80, 100, 120), items = {13935333090, 16110951997, 10632503818} },
        { label = "OUTFIT 6", color = Color3.fromRGB(30, 30, 35), headless = true, items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424} },
        { label = "VX7", color = Color3.fromRGB(255, 60, 60), headless = true, items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718} },
    }

    local MarketplaceService = game:GetService("MarketplaceService")
    local AssetService = game:GetService("AssetService")

    local function clearLocalOutfit(char)
        if not char then return end
        for _, ch in ipairs(char:GetChildren()) do
            if ch:GetAttribute(appliedTag) then
                pcall(function() ch:Destroy() end)
            end
        end
    end

    local function assetTypeId(assetId)
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(assetId, Enum.InfoType.Asset)
        end)
        if ok and info and info.AssetTypeId then
            return info.AssetTypeId
        end
        return nil
    end

    -- Build a HumanoidDescription from outfit ids (clothes + accessories + body)
    local function buildDescription(opt, baseDesc)
        local desc = baseDesc and baseDesc:Clone() or Instance.new("HumanoidDescription")
        pcall(function()
            desc:SetAccessories({}, true)
        end)
        pcall(function()
            desc.Shirt = 0
            desc.Pants = 0
            desc.GraphicTShirt = 0
        end)

        local accessories = {}
        local function handleId(assetId)
            local t = assetTypeId(assetId)
            if not t then
                -- still try as accessory
                table.insert(accessories, {
                    AssetId = assetId,
                    AccessoryType = Enum.AccessoryType.Hat,
                    Order = #accessories + 1,
                })
                return
            end
            -- Body parts
            if t == 17 or t == 27 then pcall(function() desc.Head = assetId end)
            elseif t == 18 then pcall(function() desc.Face = assetId end)
            elseif t == 27 then -- head
                pcall(function() desc.Head = assetId end)
            elseif t == 28 then pcall(function() desc.Torso = assetId end)
            elseif t == 29 then pcall(function() desc.LeftArm = assetId end)
            elseif t == 30 then pcall(function() desc.RightArm = assetId end)
            elseif t == 31 then pcall(function() desc.LeftLeg = assetId end)
            elseif t == 32 then pcall(function() desc.RightLeg = assetId end)
            -- Classic clothing
            elseif t == 11 then pcall(function() desc.Shirt = assetId end)
            elseif t == 12 then pcall(function() desc.Pants = assetId end)
            elseif t == 2 then pcall(function() desc.GraphicTShirt = assetId end)
            -- Bundle-ish / layered / accessories
            else
                local accType = Enum.AccessoryType.Hat
                if t == 41 then accType = Enum.AccessoryType.Hair
                elseif t == 42 then accType = Enum.AccessoryType.Face
                elseif t == 43 then accType = Enum.AccessoryType.Neck
                elseif t == 44 then accType = Enum.AccessoryType.Shoulder
                elseif t == 45 then accType = Enum.AccessoryType.Front
                elseif t == 46 then accType = Enum.AccessoryType.Back
                elseif t == 47 then accType = Enum.AccessoryType.Waist
                elseif t == 8 then accType = Enum.AccessoryType.Hat
                elseif t >= 64 and t <= 78 then
                    accType = Enum.AccessoryType.Jacket -- layered fallback
                end
                table.insert(accessories, {
                    AssetId = assetId,
                    AccessoryType = accType,
                    Order = #accessories + 1,
                    IsLayered = (t >= 64 and t <= 78) or nil,
                    Puffiness = opt.layeredPuffiness or 0,
                })
            end
        end

        for _, id in ipairs(opt.bodyItems or {}) do handleId(id) end
        for _, id in ipairs(opt.items or {}) do handleId(id) end
        if opt.face then handleId(opt.face) end

        pcall(function()
            desc:SetAccessories(accessories, true)
        end)
        return desc
    end

    local function applyOutfit(index)
        local opt = OUTFITS[index]
        if not opt then return end
        local char = localPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        clearLocalOutfit(char)

        local base
        pcall(function() base = hum:GetAppliedDescription() end)
        local desc = buildDescription(opt, base)

        local ok = pcall(function()
            hum:ApplyDescription(desc)
        end)
        if not ok then
            pcall(function()
                hum:ApplyDescriptionReset(desc)
            end)
        end

        -- Fallback: LoadAsset + AddAccessory for anything description missed
        task.spawn(function()
            local ids = {}
            for _, id in ipairs(opt.bodyItems or {}) do table.insert(ids, id) end
            for _, id in ipairs(opt.items or {}) do table.insert(ids, id) end
            if opt.face then table.insert(ids, opt.face) end
            for _, assetId in ipairs(ids) do
                local ok2, model = pcall(function()
                    return InsertService:LoadAsset(assetId)
                end)
                if ok2 and model then
                    for _, inst in ipairs(model:GetChildren()) do
                        if inst:IsA("Accessory") then
                            local cl = inst:Clone()
                            cl:SetAttribute(appliedTag, true)
                            pcall(function() hum:AddAccessory(cl) end)
                        elseif inst:IsA("Shirt") or inst:IsA("Pants") or inst:IsA("ShirtGraphic") then
                            -- remove old same class without tag
                            for _, ch in ipairs(char:GetChildren()) do
                                if ch.ClassName == inst.ClassName and not ch:GetAttribute(appliedTag) then
                                    pcall(function() ch:Destroy() end)
                                end
                            end
                            local cl = inst:Clone()
                            cl:SetAttribute(appliedTag, true)
                            cl.Parent = char
                        end
                    end
                    pcall(function() model:Destroy() end)
                end
            end
            if opt.headless then
                local head = char:FindFirstChild("Head")
                if head and head:IsA("BasePart") then
                    head.Transparency = 1
                    head.LocalTransparencyModifier = 1
                    for _, d in ipairs(head:GetDescendants()) do
                        if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
                    end
                end
            end
        end)

        selectedOutfit = index
        avatarEnabled = true
        pcall(function() desc:Destroy() end)
    end

    local function removeOutfit()
        local char = localPlayer.Character
        clearLocalOutfit(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                local d = Players:GetHumanoidDescriptionFromUserId(localPlayer.UserId)
                if d then hum:ApplyDescription(d) end
            end)
        end
        avatarEnabled = false
    end

    local function buildPreviewRig(opt)
        local baseDesc = Instance.new("HumanoidDescription")
        pcall(function()
            baseDesc.HeadColor = Color3.fromRGB(234, 184, 146)
            baseDesc.TorsoColor = Color3.fromRGB(234, 184, 146)
            baseDesc.LeftArmColor = Color3.fromRGB(234, 184, 146)
            baseDesc.RightArmColor = Color3.fromRGB(234, 184, 146)
            baseDesc.LeftLegColor = Color3.fromRGB(234, 184, 146)
            baseDesc.RightLegColor = Color3.fromRGB(234, 184, 146)
        end)
        local desc = buildDescription(opt, baseDesc)
        local model
        pcall(function()
            model = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
        end)
        if not model then
            pcall(function()
                model = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
            end)
        end
        if not model then
            model = Instance.new("Model")
            local p = Instance.new("Part")
            p.Size = Vector3.new(2, 2, 1)
            p.Anchored = true
            p.Parent = model
            model.PrimaryPart = p
            return model
        end
        model.Name = "PreviewRig"
        local hum = model:FindFirstChildOfClass("Humanoid")
        -- Extra LoadAsset pass so accessories appear in viewport
        local ids = {}
        for _, id in ipairs(opt.bodyItems or {}) do table.insert(ids, id) end
        for _, id in ipairs(opt.items or {}) do table.insert(ids, id) end
        if opt.face then table.insert(ids, opt.face) end
        for i, assetId in ipairs(ids) do
            if i > 8 then break end
            local ok2, asset = pcall(function() return InsertService:LoadAsset(assetId) end)
            if ok2 and asset then
                for _, inst in ipairs(asset:GetChildren()) do
                    if inst:IsA("Accessory") and hum then
                        pcall(function() hum:AddAccessory(inst:Clone()) end)
                    elseif inst:IsA("Shirt") or inst:IsA("Pants") or inst:IsA("ShirtGraphic") then
                        pcall(function() inst:Clone().Parent = model end)
                    end
                end
                pcall(function() asset:Destroy() end)
            end
        end
        for _, p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Anchored = true
                p.CanCollide = false
            end
        end
        if opt.headless then
            local head = model:FindFirstChild("Head")
            if head then
                head.Transparency = 1
                for _, d in ipairs(head:GetDescendants()) do
                    if d:IsA("Decal") or d:IsA("Texture") then d.Transparency = 1 end
                end
            end
        end
        local hrp = model:FindFirstChild("HumanoidRootPart")
        if hrp then model.PrimaryPart = hrp end
        pcall(function() model:PivotTo(CFrame.new()) end)
        pcall(function() baseDesc:Destroy() end)
        pcall(function() desc:Destroy() end)
        return model
    end

    local function openAvatarGui()
        if avatarGui and avatarGui.Parent then
            avatarGui.Enabled = true
            local f = avatarGui:FindFirstChild("Main")
            if f then f.Visible = true end
            return
        end
        local pg = localPlayer:FindFirstChild("PlayerGui") or localPlayer:WaitForChild("PlayerGui")
        local gui = Instance.new("ScreenGui")
        gui.Name = "WhiteHubAvatarCatalog"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 125
        gui.Parent = pg
        avatarGui = gui

        local main = Instance.new("Frame")
        main.Name = "Main"
        main.Size = UDim2.new(0, 360, 0, 420)
        main.Position = UDim2.new(0.5, -180, 0.5, -210)
        main.BackgroundColor3 = Color3.fromRGB(7, 7, 7)
        main.BorderSizePixel = 0
        main.Active = true
        main.Parent = gui
        Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
        local stroke = Instance.new("UIStroke", main)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Transparency = 0.45

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -50, 0, 28)
        title.Position = UDim2.new(0, 14, 0, 8)
        title.BackgroundTransparency = 1
        title.Text = "CUSTOM SKIN"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 15
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = main

        local close = Instance.new("TextButton")
        close.Size = UDim2.new(0, 28, 0, 28)
        close.Position = UDim2.new(1, -36, 0, 6)
        close.BackgroundTransparency = 1
        close.Text = "×"
        close.TextColor3 = Color3.fromRGB(255, 255, 255)
        close.Font = Enum.Font.GothamBold
        close.TextSize = 22
        close.Parent = main
        close.MouseButton1Click:Connect(function() main.Visible = false end)

        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, -28, 0, 1)
        line.Position = UDim2.new(0, 14, 0, 38)
        line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        line.BackgroundTransparency = 0.7
        line.BorderSizePixel = 0
        line.Parent = main

        local list = Instance.new("ScrollingFrame")
        list.Name = "PresetCards"
        list.BackgroundTransparency = 1
        list.BorderSizePixel = 0
        list.Position = UDim2.new(0, 12, 0, 48)
        list.Size = UDim2.new(1, -24, 1, -90)
        list.ScrollBarThickness = 4
        list.ScrollingDirection = Enum.ScrollingDirection.Y
        list.CanvasSize = UDim2.new(0, 0, 0, 0)
        list.AutomaticCanvasSize = Enum.AutomaticSize.Y
        list.Parent = main

        local grid = Instance.new("UIGridLayout")
        grid.CellSize = UDim2.new(0, 105, 0, 125)
        grid.CellPadding = UDim2.new(0, 8, 0, 8)
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.Parent = list

        local pad = Instance.new("UIPadding", list)
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 2)

        for i, opt in ipairs(OUTFITS) do
            local card = Instance.new("TextButton")
            card.Name = opt.label
            card.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            card.BorderSizePixel = 0
            card.Text = ""
            card.AutoButtonColor = false
            card.LayoutOrder = i
            card.Parent = list
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
            local cst = Instance.new("UIStroke", card)
            cst.Color = Color3.fromRGB(60, 60, 60)
            cst.Thickness = 1

            local viewport = Instance.new("ViewportFrame")
            viewport.Name = "AvatarPreview"
            viewport.Size = UDim2.new(1, -8, 1, -28)
            viewport.Position = UDim2.new(0, 4, 0, 4)
            viewport.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
            viewport.BorderSizePixel = 0
            viewport.Parent = card
            Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 8)

            local loading = Instance.new("TextLabel")
            loading.Size = UDim2.new(1, 0, 1, 0)
            loading.BackgroundTransparency = 1
            loading.Text = "..."
            loading.TextColor3 = Color3.fromRGB(160, 160, 160)
            loading.Font = Enum.Font.GothamBold
            loading.TextSize = 12
            loading.Parent = viewport

            task.spawn(function()
                local world = Instance.new("WorldModel")
                world.Parent = viewport
                local rig
                local ok = pcall(function()
                    rig = buildPreviewRig(opt)
                end)
                if not ok or not rig then
                    loading.Text = "N/A"
                    return
                end
                rig.Parent = world
                pcall(function()
                    local cf, size = rig:GetBoundingBox()
                    local target = cf.Position
                    local dist = math.max(size.X, size.Y, size.Z) * 1.55
                    local cam = Instance.new("Camera")
                    cam.FieldOfView = 28
                    cam.CFrame = CFrame.new(target + Vector3.new(0, size.Y * 0.05, dist), target)
                    cam.Parent = viewport
                    viewport.CurrentCamera = cam
                end)
                loading:Destroy()
                while viewport.Parent and main.Parent do
                    if main.Visible then
                        pcall(function()
                            local pivot = rig:GetPivot()
                            rig:PivotTo(CFrame.new(pivot.Position) * CFrame.Angles(0, math.rad((os.clock() * 24) % 360), 0))
                        end)
                    end
                    task.wait(0.03)
                end
            end)

            local name = Instance.new("TextLabel")
            name.Size = UDim2.new(1, -4, 0, 20)
            name.Position = UDim2.new(0, 2, 1, -22)
            name.BackgroundTransparency = 1
            name.Text = opt.label
            name.TextColor3 = Color3.fromRGB(230, 230, 230)
            name.Font = Enum.Font.GothamBold
            name.TextSize = 10
            name.Parent = card

            card.MouseButton1Click:Connect(function()
                name.Text = "..."
                task.spawn(function()
                    applyOutfit(i)
                    name.Text = opt.label
                    for _, ch in ipairs(list:GetChildren()) do
                        if ch:IsA("TextButton") then
                            local on = ch.LayoutOrder == selectedOutfit and avatarEnabled
                            local s = ch:FindFirstChildOfClass("UIStroke")
                            if s then
                                s.Color = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(60, 60, 60)
                            end
                        end
                    end
                end)
            end)
        end

        local removeBtn = Instance.new("TextButton")
        removeBtn.Size = UDim2.new(1, -24, 0, 30)
        removeBtn.Position = UDim2.new(0, 12, 1, -38)
        removeBtn.BackgroundColor3 = Color3.fromRGB(40, 18, 18)
        removeBtn.Text = "REMOVE OUTFIT"
        removeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
        removeBtn.Font = Enum.Font.GothamBold
        removeBtn.TextSize = 11
        removeBtn.Parent = main
        Instance.new("UICorner", removeBtn).CornerRadius = UDim.new(0, 8)
        removeBtn.MouseButton1Click:Connect(function()
            removeOutfit()
            for _, ch in ipairs(list:GetChildren()) do
                if ch:IsA("TextButton") then
                    local s = ch:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = Color3.fromRGB(60, 60, 60) end
                end
            end
        end)

        -- drag by title
        local dragging, dragStart, startPos
        title.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
        end)
        title.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    _G.WhiteHubOpenAvatarGui = openAvatarGui
    _G.WhiteHubApplyAvatarOutfit = applyOutfit
    _G.WhiteHubRemoveAvatarOutfit = removeOutfit

    localPlayer.CharacterAdded:Connect(function()
        if avatarEnabled and selectedOutfit then
            task.delay(1.2, function()
                if avatarEnabled then pcall(applyOutfit, selectedOutfit) end
            end)
        end
    end)
end

createFrame(visual, "Personalización")
mkToggle(visual, "Avatar Catalog GUI", function(on)
    if on then
        pcall(function()
            if _G.WhiteHubOpenAvatarGui then _G.WhiteHubOpenAvatarGui() end
        end)
    else
        pcall(function()
            local pg = localPlayer:FindFirstChild("PlayerGui")
            local g = pg and pg:FindFirstChild("WhiteHubAvatarCatalog")
            if g then
                local m = g:FindFirstChild("Main")
                if m then m.Visible = false end
            end
        end)
    end
end)

local batSkin = mkToggle(visual, "Bat Skin", function(direction)
katanaSkinEnabled = direction
if direction then
pcall(function()
katanaSkinController.ApplySkin("KATANA")
end)
else
pcall(function()
katanaSkinController.ApplySkin("NONE")
end)
end
saveAllSettings()
end)
if batSkin then
batSkin(katanaSkinEnabled)
end
MinecraftBatSetVisual = mkToggle(visual, "Minecraft Bat", function(enabled)
minecraftBatSkinEnabled = enabled
minecraftBatSkinController.State.enabled = enabled
if enabled then
pcall(minecraftBatSkinController.Apply)
else
pcall(minecraftBatSkinController.Remove)
end
saveAllSettings()
end)
if MinecraftBatSetVisual then
MinecraftBatSetVisual(minecraftBatSkinEnabled)
end
local frame22204 = createFrame2(visual, 38)
mkLabel(frame22204, "MC Bat Color")
MinecraftBatColorSelector = createCarouselSelector(frame22204, minecraftBatSkinColorMode, {
"Default",
"Abyss Blue",
"Venom Green",
"Royal Gold",
"Velvet Rose",
"Crimson Night",
"RGB",
}, function(minecraftBatSkinColorMode2205)
minecraftBatSkinColorMode = minecraftBatSkinColorMode2205
minecraftBatSkinController.SetColorMode(minecraftBatSkinColorMode2205)
saveAllSettings()
end)
local frame22206 = createFrame2(visual, 38)
mkLabel(frame22206, "Anim Pack")
local data2271 = {}
for _, entry in ipairs(ANIM_PACK_ORDER) do
table.insert(data2271, entry[2])
end
animSelectorLabel = createCarouselSelector(frame22206, currentAnimPack, data2271, function(value)
if value == "Off" then
disableAnimationPack()
else
applyAnimationPack(value)
end
end)
do
local avatarFrame = createFrame2(visual, 38)
mkLabel(avatarFrame, "Avatar")
local avatarNames = {}
for _, entry in ipairs(outfits) do
table.insert(avatarNames, entry.label)
end
outfitSelectorLabel = createCarouselSelector(
avatarFrame,
outfits[currentOutfitIndex].label,
avatarNames,
function(value)
for i, entry in ipairs(outfits) do
if entry.label == value then
currentOutfitIndex = i
pcall(function()
applyOutfitByIndex(currentOutfitIndex)
end)
saveAllSettings()
break
end
end
end
)
end
local frame22218 = createFrame2(visual, 56)
mkLabel(frame22218, "Background")
local rootPart2219 = Instance.new("Frame", frame22218)
rootPart2219.Name = "BackgroundPreview"
rootPart2219.Size = UDim2.new(0, 44, 0, 34)
rootPart2219.Position = UDim2.new(0, 84, 0.5, -17)
rootPart2219.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
rootPart2219.BackgroundTransparency = 0.15
rootPart2219.BorderSizePixel = 0
rootPart2219.ClipsDescendants = true
rootPart2219.ZIndex = 8
Instance.new("UICorner", rootPart2219).CornerRadius = UDim.new(0, 8)
local uiStroke = Instance.new("UIStroke", rootPart2219)
uiStroke.Color = color3
uiStroke.Thickness = 1.2
uiStroke.Transparency = 0.55
local rootPart2221 = Instance.new("ImageLabel", rootPart2219)
rootPart2221.Name = "PreviewImage"
rootPart2221.Size = UDim2.new(1, 0, 1, 0)
rootPart2221.Position = UDim2.new(0, 0, 0, 0)
rootPart2221.BackgroundTransparency = 1
rootPart2221.Image = ""
rootPart2221.ScaleType = Enum.ScaleType.Crop
rootPart2221.ZIndex = 9
Instance.new("UICorner", rootPart2221).CornerRadius = UDim.new(0, 8)
local label2222 = Instance.new("TextLabel", rootPart2219)
label2222.Name = "PreviewPlaceholder"
label2222.Size = UDim2.new(1, 0, 1, 0)
label2222.BackgroundTransparency = 1
label2222.Text = "OFF"
label2222.TextColor3 = Color3.fromRGB(0, 0, 0)
label2222.Font = Enum.Font.GothamBlack
label2222.TextSize = 12
label2222.ZIndex = 10
local function updateBackgroundPreview(index)
local background = BACKGROUND_IMAGES[index]
if not background or not background.id or background.id == "" then
rootPart2221.Image = ""
label2222.Visible = true
uiStroke.Color = color3
else
rootPart2221.Image = _G.K7HubResolveBackgroundAsset(background.id, index)
label2222.Visible = rootPart2221.Image == ""
uiStroke.Color = getThemeColor()
end
end
local function pulseBackgroundPreview()
rootPart2219.Size = UDim2.new(0, 44, 0, 34)
TweenService:Create(rootPart2219, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
Size = UDim2.new(0, 47, 0, 36),
}):Play()
task.delay(0.15, function()
TweenService:Create(rootPart2219, TweenInfo.new(0.15), {
Size = UDim2.new(0, 44, 0, 34),
}):Play()
end)
end
rootPart2219.MouseEnter:Connect(function()
TweenService:Create(uiStroke, TweenInfo.new(0.12), {
Color = getThemeColor(),
Transparency = 0.05,
}):Play()
end)
rootPart2219.MouseLeave:Connect(function()
local background = BACKGROUND_IMAGES[backgroundIndex]
local hasNoImage = not background or not background.id or background.id == ""
TweenService:Create(uiStroke, TweenInfo.new(0.12), {
Color = hasNoImage and color3 or getThemeColor(),
Transparency = hasNoImage and 0.55 or 0.2,
}):Play()
end)
local data2293 = {}
for _, entry2231 in ipairs(BACKGROUND_IMAGES) do
table.insert(data2293, entry2231.label)
end
backgroundSelectorLabel = createCarouselSelector(
frame22218,
BACKGROUND_IMAGES[backgroundIndex].label,
data2293,
function(value)
for i, entry in ipairs(BACKGROUND_IMAGES) do
if entry.label == value then
applyBackground(i)
updateBackgroundPreview(i)
pulseBackgroundPreview()
saveAllSettings()
break
end
end
end
)
if backgroundSelectorLabel then
local parent = backgroundSelectorLabel.Parent
if parent and parent:IsA("Frame") then
parent.Size = UDim2.new(0, 175, 0, 30)
parent.Position = UDim2.new(1, -183, 0.5, -15)
end
end
updateBackgroundPreview(backgroundIndex)
local settings_ = data2022.Settings
createFrame(settings_, "Intro")
local frame22237 = createFrame2(settings_, 38)
mkLabel(frame22237, "Intro Song")
local data2302 = {}
for i = 1, #introSongIds do
data2302[i] = "Song " .. i
end
createCarouselSelector(frame22237, "Song " .. currentIntroSongIndex, data2302, function(callback)
currentIntroSongIndex = math.clamp(tonumber(callback:match("%d+")) or 1, 1, #introSongIds)
saveAllSettings()
-- INSTANT PREVIEW: play without re-executing
pcall(function()
    local newTrack = introSongIds[currentIntroSongIndex]
    if introSound and introSound.Parent then
        introSound:Stop()
        introSound:Destroy()
    end
    local introSongFileName2 = "cloverhub_intro_song_" .. currentIntroSongIndex .. ".mp3"
    local soundAssetId = nil
    if newTrack:find("rbxassetid") then
        soundAssetId = newTrack
    else
        if _G.K7SongsGetAsset then
            soundAssetId = _G.K7SongsGetAsset(newTrack, introSongFileName2)
        end
        if not soundAssetId and isfile and isfile(introSongFileName2) and getcustomasset then
            soundAssetId = getcustomasset(introSongFileName2)
        end
        if not soundAssetId and writefile then
            local ok, result = pcall(function() return game:HttpGet(newTrack) end)
            if ok and result and #result > 100 then
                pcall(function() writefile(introSongFileName2, result) end)
                if getcustomasset then
                    soundAssetId = getcustomasset(introSongFileName2)
                end
            end
        end
        if not soundAssetId then
            soundAssetId = newTrack
        end
    end
    introSound = Instance.new("Sound")
    introSound.Name = "CleanIntroSong_Preview"
    introSound.SoundId = soundAssetId
    introSound.Volume = 1
    introSound.Looped = false
    introSound.Parent = game:GetService("SoundService")
    introSound:Play()
end)
end)
createFrame(settings_, "Auto Steal")
setInstaGrab = mkToggle(settings_, "Auto Steal", function(autoStealEnabled)
CONFIG.AUTO_STEAL_ENABLED = autoStealEnabled
if autoStealEnabled then
pcall(startAutoSteal)
else
stopAutoSteal()
end
updateProgressBarVisibility()
end)
local frame22242 = createFrame2(settings_, 38)
mkLabel(frame22242, "Steal Radius")
radInput = createTextBox(frame22242, CONFIG.STEAL_RANGE, 50, 56, function(value)
if value and value >= 5 and value <= 300 then
CONFIG.STEAL_RANGE = floor(value + 0.5)
autoStealState.StealRadius = CONFIG.STEAL_RANGE
radInput.Text = tostring(CONFIG.STEAL_RANGE)
saveAllSettings()
end
end)
local frame22244 = createFrame2(settings_, 38)
mkLabel(frame22244, "Steal Version")
local object2309 = AUTO_STEAL_VARIANT_NAMES
autoStealVariantLabel = createCarouselSelector(
frame22244,
getAutoStealVariantName(autoStealVariant),
object2309,
function(value)
autoStealVariant = getAutoStealVariantIndex(value)
saveAllSettings()
end
)
createFrame(settings_, "UI Settings")
-- Recolor existing accent properties throughout the UI, including text and gradients.
-- Track the previous choice so switching from one palette color to another works repeatedly.
local lastPaletteColor = selectedColor or getThemeColor()
local function applyPaletteToGui(color)
    local accentColors = {
        Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255),
    }
    local function isAccent(oldColor)
        if oldColor == lastPaletteColor then return true end
        for _, accent in ipairs(accentColors) do
            if oldColor == accent then return true end
        end
        -- Catch hard-coded purple shades used in older labels/strokes.
        local hue, saturation, value = oldColor:ToHSV()
        return saturation > 0.28 and value > 0.08 and hue >= 0.69 and hue <= 0.91
    end
    local roots = {}
    if gui then table.insert(roots, gui) end
    if main then table.insert(roots, main) end
    if MobilePanel then table.insert(roots, MobilePanel) end
    local seen = {}
    for _, root in ipairs(roots) do
        if root and not seen[root] then
            seen[root] = true
            for _, obj in ipairs(root:GetDescendants()) do
                if not (obj.Name and obj.Name:match('^ColorSwatch_')) then
                    if obj:IsA("GuiObject") and isAccent(obj.BackgroundColor3) then
                        obj.BackgroundColor3 = color
                    end
                    if (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) and isAccent(obj.TextColor3) then
                        obj.TextColor3 = color
                    end
                    if obj:IsA("UIStroke") and isAccent(obj.Color) then
                        obj.Color = color
                    elseif obj:IsA("UIGradient") then
                        local points = {}
                        for _, point in ipairs(obj.Color.Keypoints) do
                            points[#points + 1] = ColorSequenceKeypoint.new(point.Time, isAccent(point.Value) and color or point.Value)
                        end
                        obj.Color = ColorSequence.new(points)
                    end
                end
            end
        end
    end
    lastPaletteColor = color
end
-- Visual color palette: tap a swatch to apply that accent color immediately.
local paletteRow = createFrame2(settings_, 72)
mkLabel(paletteRow, "Pick a Color")
local paletteColors = {
    {name = "Purple", color = Color3.fromRGB(255, 255, 255)},
    {name = "Blue", color = Color3.fromRGB(0, 0, 0)},
    {name = "Cyan", color = Color3.fromRGB(255, 255, 255)},
    {name = "Green", color = Color3.fromRGB(255, 255, 255)},
    {name = "Lime", color = Color3.fromRGB(255, 255, 255)},
    {name = "Yellow", color = Color3.fromRGB(255, 255, 255)},
    {name = "Orange", color = Color3.fromRGB(255, 255, 255)},
    {name = "Red", color = Color3.fromRGB(255, 255, 255)},
    {name = "Pink", color = Color3.fromRGB(255, 255, 255)},
    {name = "White", color = Color3.fromRGB(255, 255, 255)},
    {name = "Silver", color = Color3.fromRGB(255, 255, 255)},
    {name = "Gold", color = Color3.fromRGB(255, 255, 255)},
}
local paletteSwatches = {}
for i, entry in ipairs(paletteColors) do
    local swatch = Instance.new("TextButton")
    swatch.Name = "ColorSwatch_" .. entry.name
    swatch.Size = UDim2.new(0, 23, 0, 23)
    local col = (i - 1) % 6
    local row = math.floor((i - 1) / 6)
    swatch.Position = UDim2.new(1, -166 + col * 27, 0, 7 + row * 29)
    swatch.BackgroundColor3 = entry.color
    swatch.BorderSizePixel = 0
    swatch.Text = ""
    swatch.AutoButtonColor = true
    swatch.ZIndex = 10
    swatch.Parent = paletteRow
    Instance.new("UICorner", swatch).CornerRadius = UDim.new(0, 6)
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(255, 255, 255)
    outline.Thickness = 1
    outline.Transparency = 0.65
    outline.Parent = swatch
    paletteSwatches[i] = swatch
    swatch.MouseButton1Click:Connect(function()
        selectedColor = entry.color
        currentColorTheme = entry.name
        updateAllUIThemeColors(entry.color)
        applyPaletteToGui(entry.color)
        for j, other in ipairs(paletteSwatches) do
            local stroke = other:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Thickness = (j == i) and 2.5 or 1
                stroke.Transparency = (j == i) and 0 or 0.65
            end
        end
        pcall(saveAllSettings)
    end)
end
-- Custom accent color controls: users can enter any RGB color (0-255).
local customColorRGB = {R = 120, G = 30, B = 185}
local customColorRow = createFrame2(settings_, 38)
mkLabel(customColorRow, "Custom Color RGB")
local customRBox = createTextBox(customColorRow, customColorRGB.R, 36, 155, function(value)
customColorRGB.R = math.clamp(math.floor(value + 0.5), 0, 255)
end)
local customGBox = createTextBox(customColorRow, customColorRGB.G, 36, 110, function(value)
customColorRGB.G = math.clamp(math.floor(value + 0.5), 0, 255)
end)
local customBBox = createTextBox(customColorRow, customColorRGB.B, 36, 65, function(value)
customColorRGB.B = math.clamp(math.floor(value + 0.5), 0, 255)
end)
local applyCustomColorRow = createFrame2(settings_, 38)
local applyCustomColorButton = Instance.new("TextButton")
applyCustomColorButton.Name = "ApplyCustomColorButton"
applyCustomColorButton.Size = UDim2.new(0, 130, 0, 26)
applyCustomColorButton.Position = UDim2.new(1, -140, 0.5, -13)
applyCustomColorButton.BackgroundColor3 = getThemeColor()
applyCustomColorButton.BorderSizePixel = 0
applyCustomColorButton.Text = "Apply Custom Color"
applyCustomColorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyCustomColorButton.Font = Enum.Font.GothamBold
applyCustomColorButton.TextSize = 11
applyCustomColorButton.ZIndex = 9
applyCustomColorButton.AutoButtonColor = true
applyCustomColorButton.Parent = applyCustomColorRow
Instance.new("UICorner", applyCustomColorButton).CornerRadius = UDim.new(0, 7)
applyCustomColorButton.MouseButton1Click:Connect(function()
local customColor = Color3.fromRGB(
math.clamp(math.floor(tonumber(customRBox.Text) or customColorRGB.R), 0, 255),
math.clamp(math.floor(tonumber(customGBox.Text) or customColorRGB.G), 0, 255),
math.clamp(math.floor(tonumber(customBBox.Text) or customColorRGB.B), 0, 255)
)
customColorRGB.R = math.floor(customColor.R * 255 + 0.5)
customColorRGB.G = math.floor(customColor.G * 255 + 0.5)
customColorRGB.B = math.floor(customColor.B * 255 + 0.5)
selectedColor = customColor
currentColorTheme = "Custom"
updateAllUIThemeColors(customColor)
applyPaletteToGui(customColor)
applyCustomColorButton.BackgroundColor3 = customColor
pcall(saveAllSettings)
end)
local frame22247 = createFrame2(settings_, 38)
mkLabel(frame22247, "UI Scale")
uiScaleBox = createTextBox(frame22247, uiScaleValue, 50, 56, function(value)
local n = clamp(floor(value + 0.5), 50, 150)
uiScaleValue = n
if mainUIScale then
mainUIScale.Scale = n / 100
end
saveAllSettings()
end)
local frame22250 = createFrame2(settings_, 38)
mkLabel(frame22250, "Float Scale")
createTextBox(frame22250, floor(floatingButtonScale * 100), 50, 56, function(value)
floatingButtonScale = clamp(value, 50, 200) / 100
applyFloatingButtonScale()
saveAllSettings()
end)
local frame22252 = createFrame2(settings_, 38)
mkLabel(frame22252, "Steal Bar Scale")
createTextBox(frame22252, floor(progressBarScale * 100), 50, 56, function(value)
progressBarScale = clamp(value, 50, 200) / 100
if pbScale then
pbScale.Scale = progressBarScale
end
saveAllSettings()
end)
createFrame(settings_, "Mobile Buttons")
local frame22254 = createFrame2(settings_, 38)
mkLabel(frame22254, "Hide Mobile Buttons")
local object2322, object2323 = mkPill(frame22254, 48)
local ambitiousHideMobileButtons = _G.AmbitiousHideMobileButtons == true
local function updateMobileButtonsPill(hidden)
ambitiousHideMobileButtons = hidden
animPill(object2322, object2323, hidden)
end
updateMobileButtonsPill(ambitiousHideMobileButtons)
local label2260 = Instance.new("TextButton", object2322)
label2260.Size = UDim2.new(1, 0, 1, 0)
label2260.BackgroundTransparency = 1
label2260.Text = ""
label2260.AutoButtonColor = false
label2260.ZIndex = 10
label2260.MouseButton1Click:Connect(function()
ambitiousHideMobileButtons = not ambitiousHideMobileButtons
_G.AmbitiousHideMobileButtons = ambitiousHideMobileButtons
updateMobileButtonsPill(ambitiousHideMobileButtons)
_G.AmbitiousApplyMobileButtonsHidden()
saveAllSettings()
end)
local value2328 = #data * 34 + (#data - 1) * 6 + 8
local frame22262 = createFrame2(settings_, 38)
mkLabel(frame22262, "Buttons to Hide")
local vector = Instance.new("Frame", settings_)
vector.Name = "HideButtonsList"
vector.BackgroundTransparency = 1
vector.Size = UDim2.new(1, -4, 0, value2328)
vector.LayoutOrder = nextLayoutOrder(settings_)
vector.ZIndex = 7
vector.ClipsDescendants = true
vector.Visible = false
local uiListLayout2 = Instance.new("UIListLayout", vector)
uiListLayout2.Padding = UDim.new(0, 6)
uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", vector).PaddingTop = UDim.new(0, 4)
for i, entry2266 in ipairs(data) do
local frame = Instance.new("Frame", vector)
frame.Name = "HideOpt_" .. entry2266.key
frame.BackgroundColor3 = color2
frame.BackgroundTransparency = 0.7
frame.Size = UDim2.new(1, -4, 0, 34)
frame.BorderSizePixel = 0
frame.LayoutOrder = i
frame.ZIndex = 7
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 9)
local uiStroke2 = Instance.new("UIStroke", frame)
uiStroke2.Color = color3
uiStroke2.Thickness = 1
uiStroke2.Transparency = 0.5
local textLabel = Instance.new("TextLabel", frame)
textLabel.BackgroundTransparency = 1
textLabel.Text = entry2266.label
textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 11
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.Position = UDim2.new(0, 12, 0, 0)
textLabel.Size = UDim2.new(1, -70, 1, 0)
textLabel.ZIndex = 8
local object = _G.AmbitiousMobileHideIncluded(entry2266.key)
local rootPart = Instance.new("Frame", frame)
rootPart.Name = "Track"
rootPart.Size = UDim2.new(0, 34, 0, 18)
rootPart.AnchorPoint = Vector2.new(0.5, 0.5)
rootPart.Position = UDim2.new(1, -48, 0.5, 0)
rootPart.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rootPart.BackgroundTransparency = object and 0 or 0.2
rootPart.BorderSizePixel = 0
rootPart.ZIndex = 8
Instance.new("UICorner", rootPart).CornerRadius = UDim.new(0, 9)
local uiStroke3 = Instance.new("UIStroke", rootPart)
uiStroke3.Color = color3
uiStroke3.Thickness = 1
uiStroke3.Transparency = 0.45
local rootPart2273 = Instance.new("Frame", rootPart)
rootPart2273.Name = "Knob"
rootPart2273.Size = UDim2.new(0, 13, 0, 13)
rootPart2273.AnchorPoint = Vector2.new(0, 0)
rootPart2273.Position = object and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
rootPart2273.BackgroundColor3 = object and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
rootPart2273.BorderSizePixel = 0
rootPart2273.ZIndex = 9
Instance.new("UICorner", rootPart2273).CornerRadius = UDim.new(1, 0)
local textButton = Instance.new("TextButton", rootPart)
textButton.Size = UDim2.new(1, 0, 1, 0)
textButton.BackgroundTransparency = 1
textButton.Text = ""
textButton.AutoButtonColor = false
textButton.ZIndex = 10
textButton.MouseButton1Click:Connect(function()
local ok = not _G.AmbitiousMobileHideIncluded(entry2266.key)
_G.AmbitiousMobileHideList[entry2266.key] = ok
animPill(rootPart, rootPart2273, ok)
_G.AmbitiousApplyMobileButtonsHidden()
saveAllSettings()
end)
end
local rootPart2276 = Instance.new("TextButton", frame22262)
rootPart2276.Size = UDim2.new(0, 28, 0, 24)
rootPart2276.Position = UDim2.new(1, -38, 0.5, -12)
rootPart2276.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
rootPart2276.Text = "▼"
rootPart2276.TextColor3 = Color3.fromRGB(0, 0, 0)
rootPart2276.Font = Enum.Font.GothamBold
rootPart2276.TextSize = 14
rootPart2276.AutoButtonColor = false
rootPart2276.ZIndex = 8
Instance.new("UICorner", rootPart2276).CornerRadius = UDim.new(0, 6)
local visible = false
rootPart2276.MouseButton1Click:Connect(function()
visible = not visible
vector.Visible = visible
rootPart2276.Text = visible and "▲" or "▼"
end)
createFrame(settings_, "Config")
do
local saveRow = createFrame2(settings_, 44)
saveRow.Size = UDim2.new(1, 0, 0, 44)
CONFIG_BTN_ROW = saveRow
local saveBtn = Instance.new("TextButton", saveRow)
saveBtn.Size = UDim2.new(0.5, -14, 0.82, 0)
saveBtn.Position = UDim2.new(0, 10, 0.09, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.BorderSizePixel = 0
saveBtn.Text = ""
saveBtn.AutoButtonColor = false
saveBtn.ZIndex = 8
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 10)
local saveGrad = Instance.new("UIGradient", saveBtn)
saveGrad.Rotation = 90
saveGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
local saveStroke = Instance.new("UIStroke", saveBtn)
saveStroke.Color = Color3.fromRGB(255, 255, 255)
saveStroke.Thickness = 1
saveStroke.Transparency = 1
local saveLabel = Instance.new("TextLabel", saveBtn)
saveLabel.Size = UDim2.new(1, 0, 1, 0)
saveLabel.BackgroundTransparency = 1
saveLabel.Text = "SAVE CONFIG"
saveLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
saveLabel.Font = Enum.Font.GothamBold
saveLabel.TextSize = 13
saveLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
saveLabel.TextStrokeTransparency = 1
saveLabel.ZIndex = 9
saveBtn.MouseEnter:Connect(function()
TweenService:Create(saveBtn, TweenInfo.new(0.14), { BackgroundTransparency = 0.15 }):Play()
end)
saveBtn.MouseLeave:Connect(function()
TweenService:Create(saveBtn, TweenInfo.new(0.14), { BackgroundTransparency = 0 }):Play()
end)
local saveBusy = false
saveBtn.MouseButton1Click:Connect(function()
if saveBusy then
return
end
saveBusy = true
pcall(function()
local focusedBox = game:GetService("UserInputService"):GetFocusedTextBox()
if focusedBox then
focusedBox:ReleaseFocus()
task.wait(0.1)
end
end)
_lastSavedJSON = nil
local saveOk, saveResult = pcall(saveAllSettings)
saveLabel.Text = (saveOk and saveResult == true) and "SAVED ✓" or "ERROR"
task.delay(1.5, function()
if saveLabel and saveLabel.Parent then
saveLabel.Text = "SAVE CONFIG"
end
saveBusy = false
end)
end)
end
do
local resetRow = CONFIG_BTN_ROW
local resetBtn = Instance.new("TextButton", resetRow)
resetBtn.Size = UDim2.new(0.5, -14, 0.82, 0)
resetBtn.Position = UDim2.new(0.5, 4, 0.09, 0)
resetBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
resetBtn.BorderSizePixel = 0
resetBtn.Text = ""
resetBtn.AutoButtonColor = false
resetBtn.ZIndex = 8
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 10)
local resetGrad = Instance.new("UIGradient", resetBtn)
resetGrad.Rotation = 90
local function setResetGrad(hot)
if hot then
resetGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
else
resetGrad.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
end
end
setResetGrad(false)
local resetStroke = Instance.new("UIStroke", resetBtn)
resetStroke.Color = Color3.fromRGB(255, 255, 255)
resetStroke.Thickness = 1.5
resetStroke.Transparency = 0.2
local resetLabel = Instance.new("TextLabel", resetBtn)
resetLabel.Size = UDim2.new(1, 0, 1, 0)
resetLabel.BackgroundTransparency = 1
resetLabel.Text = "RESET CONFIG"
resetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
resetLabel.Font = Enum.Font.GothamBold
resetLabel.TextSize = 13
resetLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
resetLabel.TextStrokeTransparency = 1
resetLabel.ZIndex = 9
resetBtn.MouseEnter:Connect(function()
TweenService:Create(resetStroke, TweenInfo.new(0.14), { Transparency = 0 }):Play()
end)
resetBtn.MouseLeave:Connect(function()
TweenService:Create(resetStroke, TweenInfo.new(0.14), { Transparency = 0.2 }):Play()
end)
local confirmStep = 0
local busy = false
resetBtn.MouseButton1Click:Connect(function()
if busy then
return
end
if confirmStep == 0 then
confirmStep = 1
resetLabel.Text = "CONFIRM?"
setResetGrad(true)
task.delay(2, function()
if confirmStep == 1 and resetBtn.Parent then
confirmStep = 0
resetLabel.Text = "RESET CONFIG"
setResetGrad(false)
end
end)
else
busy = true
confirmStep = 0
resetLabel.Text = pcall(resetToFactoryDefaults) and "RESET ✓" or "ERROR"
setResetGrad(false)
task.delay(1.5, function()
if resetLabel and resetLabel.Parent then
resetLabel.Text = "RESET CONFIG"
end
busy = false
end)
end
end)
end
local keybinds = data2022.Keybinds
createFrame(keybinds, "Keybinds")
createActionRow(keybinds, "Carry Mode", KB.CarryToggle)
createActionRow(keybinds, "Lagger Mode", KB.LaggerMode)
createActionRow(keybinds, "Auto Left", KB.AutoLeft)
createActionRow(keybinds, "Auto Right", KB.AutoRight)
createActionRow(keybinds, "Auto Bat", KB.AutoBat)
createActionRow(keybinds, "Bat Bypass", KB.BatV2)
createActionRow(keybinds, "Insta Reset", KB.InstaReset)
createActionRow(keybinds, "TP Down", KB.TPFloor)
createActionRow(keybinds, "Drop Brainrot", KB.DropBrainrot)
createActionRow(keybinds, "Hide GUI", KB.GuiHide)
local vector2318 = Instance.new("Frame", keybinds)
vector2318.Size = UDim2.new(1, 0, 0, 16)
vector2318.BackgroundTransparency = 1
vector2318.LayoutOrder = nextLayoutOrder(keybinds)
vector2318.ZIndex = 7
pbFrame = Instance.new("Frame", gui)
pbFrame.Size = UDim2.new(0, 260, 0, 54)
pbFrame.Position = UDim2.new(0.5, -130, 1, -62)
pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
pbFrame.BackgroundTransparency = 0
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
pbFrame.ClipsDescendants = true
pbFrame.Visible = CONFIG.AUTO_STEAL_ENABLED
pbFrame.ZIndex = 10
backgroundImagePB = Instance.new("ImageLabel", pbFrame)
backgroundImagePB.Name = "BackgroundImagePB"
backgroundImagePB.Size = UDim2.new(1, 0, 1, 0)
backgroundImagePB.Position = UDim2.new(0, 0, 0, 0)
backgroundImagePB.BackgroundTransparency = 1
backgroundImagePB.BorderSizePixel = 0
backgroundImagePB.Image = "rbxassetid://108154072473476"
backgroundImagePB.ScaleType = Enum.ScaleType.Crop
backgroundImagePB.ImageTransparency = 0
backgroundImagePB.Visible = true
backgroundImagePB.ZIndex = 10
Instance.new("UICorner", backgroundImagePB).CornerRadius = UDim.new(0, 10)
pbScale = Instance.new("UIScale", pbFrame)
pbScale.Scale = progressBarScale
if savedProgressBarPos then
pbFrame.Position = UDim2.new(
savedProgressBarPos.XScale or 0.5,
savedProgressBarPos.XOffset or -130,
savedProgressBarPos.YScale or 1,
savedProgressBarPos.YOffset or -62
)
end
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 10)
do
local pbBorder = Instance.new("UIStroke", pbFrame)
pbBorder.Color = Color3.fromRGB(255, 255, 255)
pbBorder.Thickness = 1
pbBorder.Transparency = 0.6
end
local rootPart2320 = Instance.new("Frame", pbFrame)
rootPart2320.Name = "ProgressRow"
rootPart2320.Size = UDim2.new(1, 0, 1, 0)
rootPart2320.Position = UDim2.new(0, 0, 0, 0)
rootPart2320.BackgroundTransparency = 1
rootPart2320.ZIndex = 11
local frame2321 = Instance.new("Frame", rootPart2320)
frame2321.Name = "FillRegion"
frame2321.Size = UDim2.new(1, -24, 0, 8)
frame2321.Position = UDim2.new(0, 12, 1, -12)
frame2321.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame2321.BackgroundTransparency = 0
frame2321.BorderSizePixel = 0
frame2321.ClipsDescendants = true
frame2321.ZIndex = 12
Instance.new("UICorner", frame2321).CornerRadius = UDim.new(1, 0)
progressFill = Instance.new("Frame", frame2321)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.Position = UDim2.new(0, 0, 0, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 13
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
local uiGradient4 = Instance.new("UIGradient", progressFill)
uiGradient4.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
})
uiGradient4.Rotation = 0
local autoStealTitle = Instance.new("TextLabel", pbFrame)
autoStealTitle.Name = "AutoStealTitle"
autoStealTitle.Size = UDim2.new(0, 82, 0, 18)
autoStealTitle.Position = UDim2.new(0, 10, 0, 4)
autoStealTitle.BackgroundTransparency = 1
autoStealTitle.Text = ""
autoStealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
autoStealTitle.Font = Enum.Font.GothamBlack
autoStealTitle.TextSize = 12
autoStealTitle.TextXAlignment = Enum.TextXAlignment.Left
autoStealTitle.TextStrokeTransparency = 1
autoStealTitle.ZIndex = 16
local stealingLabel = Instance.new("TextLabel", pbFrame)
stealingLabel.Name = "StealingLabel"
stealingLabel.Size = UDim2.new(0, 58, 0, 18)
stealingLabel.Position = UDim2.new(0, 90, 0, 4)
stealingLabel.BackgroundTransparency = 1
stealingLabel.Text = ""
stealingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
stealingLabel.Font = Enum.Font.GothamBold
stealingLabel.TextSize = 10
stealingLabel.TextXAlignment = Enum.TextXAlignment.Left
stealingLabel.TextStrokeTransparency = 1
stealingLabel.ZIndex = 16
progressPct = Instance.new("TextLabel", pbFrame)
progressPct.Size = UDim2.new(0, 42, 0, 18)
progressPct.Position = UDim2.new(1, -52, 0, 4)
progressPct.BackgroundTransparency = 1
progressPct.Text = ""
progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
progressPct.Font = Enum.Font.GothamBlack
progressPct.TextSize = 13
progressPct.TextXAlignment = Enum.TextXAlignment.Right
progressPct.TextStrokeTransparency = 1
progressPct.ZIndex = 16
fpsNeon = Instance.new("TextLabel", pbFrame)
fpsNeon.Name = "FPSNeon"
fpsNeon.Size = UDim2.new(1, -24, 0, 24)
fpsNeon.Position = UDim2.new(0, 12, 0, 3)
-- Keep the FPS/PING text transparent so the custom image behind the HUD is visible.
fpsNeon.BackgroundTransparency = 1
fpsNeon.RichText = true
fpsNeon.Text = "FPS: --  |  PING: -- ms"
fpsNeon.Visible = true
fpsNeon.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsNeon.Font = Enum.Font.Gotham
fpsNeon.TextSize = 12
fpsNeon.TextXAlignment = Enum.TextXAlignment.Left
fpsNeon.TextStrokeTransparency = 1
fpsNeon.ZIndex = 16
makeDraggable(pbFrame)
task.spawn(function()
local lastFrame = getTime()
local fpsSamples = {}
local fpsAvg = 60
RunService.RenderStepped:Connect(function()
local now = getTime()
local deltaTime = now - lastFrame
lastFrame = now
if 0 < deltaTime then
fpsAvg = fpsAvg + (1 / deltaTime - fpsAvg) * 0.1
end
end)
while true do
local ping = 0
pcall(function()
ping = localPlayer:GetNetworkPing() * 1000
end)
if fpsNeon then
local fpsValue = math.floor(fpsAvg + 0.5)
local pingValue = math.floor(ping + 0.5)
fpsNeon.Text = string.format("FPS: %d  |  PING: %d ms", fpsValue, pingValue)
end
task.wait(0.5)
end
end)
makeDraggable(main)
gui.Enabled = true
end
end
do
local isActive, object, isPlayerRagdolled, hasAnimationalEquipped, findNearbyArmedPlayer, tryHitBatCounterV2
createMobilePanel = function()
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CloverHubMobilePanel"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
if syn and syn.protect_gui then
syn.protect_gui(screenGui)
end
end)
if not pcall(function()
screenGui.Parent = game:GetService("CoreGui")
end) then
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end
local container = Instance.new("Frame", screenGui)
container.Name = "FloatingPanel"
container.Size = UDim2.new(0, 128, 0, 372)
container.AnchorPoint = Vector2.new(1, 0)
container.Position = UDim2.new(1, -10, 1, -364)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.Active = false
container.Selectable = false
container.ClipsDescendants = false
local uiScale = Instance.new("UIScale", container)
uiScale.Scale = floatingButtonScale
table.insert(_floatingUIScales, uiScale)
local btnContainer = Instance.new("Frame", container)
btnContainer.Name = "ButtonsContainer"
btnContainer.Size = UDim2.new(1, 0, 1, 0)
btnContainer.BackgroundTransparency = 1
btnContainer.Active = false
btnContainer.ClipsDescendants = false
-- branding removed so it does not block the mobile jump button
local color = Color3.fromRGB(0, 0, 0)
local buttons = {}
local buttonTexts = {
"DROP\nBR",
"AUTO\nLEFT",
"BAT\nAIMBOT",
"AUTO\nRIGHT",
"TP\nDOWN",
"CARRY\nSPD",
"LAGGER\nNORMAL",
"LAGGER\nCARRY",
"FLOAT",
}
local function createButton(name, text, order, isToggle, callback)
local button = Instance.new("TextButton", btnContainer)
button.Name = name
button.Size = UDim2.new(0, 52, 0, 52)
button.BackgroundColor3 = color
button.BorderSizePixel = 0
button.Text = ""
button.AutoButtonColor = false
button.ZIndex = 10
local savedPosition = savedButtonPositions[name]
if savedPosition then
button.Position = UDim2.new(0, savedPosition.X or 0, 0, savedPosition.Y or 0)
else
local defX, defY = getDefaultButtonPosition(name)
button.Position = UDim2.new(0, defX, 0, defY)
end
button.BackgroundColor3 = color
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)
local uiGradient = Instance.new("UIGradient", button)
uiGradient.Name = "BtnGrad"
uiGradient.Rotation = 90
local data = {}
local object = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
local object2464 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 0, 0))
local object2465 = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0))
data[1] = object
data[2] = object2464
data[3] = object2465
data[4] = ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
uiGradient.Color = ColorSequence.new(data)
local uiStroke = Instance.new("UIStroke", button)
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Thickness = 1
uiStroke.Transparency = 0.45
uiStroke.Name = "NormalStroke"
local label = Instance.new("TextLabel", button)
label.Name = "TextLabel"
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = text
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBlack
label.TextSize = 10
label.TextWrapped = true
label.ZIndex = 11
button:SetAttribute("GreenBtn", true)
local active = false
local function setActive(state)
active = state
button:SetAttribute("MobActive", state and true or false)
paintFloatingBtn(button, state)
end
setActive(false)
local dragging = false
local hasMoved = false
local position = nil
local position2 = nil
local movedDistance = 0
local function onInputBegan(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
dragging = true
hasMoved = false
movedDistance = 0
position = input.Position
position2 = button.Position
_isDraggingButton = true
end
end
local function onInputChanged(input)
if not dragging then
return
end
if
input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch
then
local delta = input.Position - position
movedDistance = delta.Magnitude
if editModeEnabled and not uiLocked then
hasMoved = true
button.Position = UDim2.new(0, position2.X.Offset + delta.X, 0, position2.Y.Offset + delta.Y)
end
end
end
local function onInputEnded(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
if dragging then
if movedDistance < 3 then
if isToggle then
if editModeEnabled and not uiLocked then
if callback then
callback(function() end)
end
elseif callback then
callback(setActive)
end
elseif callback then
callback(setActive, active)
end
elseif editModeEnabled and not uiLocked and hasMoved then
savedButtonPositions[name] = {
X = button.Position.X.Offset,
Y = button.Position.Y.Offset,
}
pcall(saveAllSettings)
end
dragging = false
hasMoved = false
position = nil
position2 = nil
movedDistance = 0
_isDraggingButton = false
end
end
end
button.InputBegan:Connect(onInputBegan)
button.InputChanged:Connect(onInputChanged)
button.InputEnded:Connect(onInputEnded)
buttons[name] = {
btn = button,
setActive = setActive,
label = label,
}
return setActive
end
for i, name in ipairs({
"DropBR",
"AutoLeft",
"AutoBat",
"AutoRight",
"TpDown",
"Carry",
"Lagger1",
"Lagger2",
"Float",
}) do
local text = buttonTexts[i]
local callback
if name == "DropBR" then
callback = function(setActive)
if autoBatEnabled then
return
end
setActive(true)
executeDropWithToggle(function(value)
if dropBrainrotSetVisual then
dropBrainrotSetVisual(value)
end
end)
task.delay(0.3, function()
setActive(false)
end)
end
elseif name == "AutoLeft" then
callback = function(setActive)
autoLeftEnabled = not autoLeftEnabled
setActive(autoLeftEnabled)
if autoLeftEnabled then
startAutoLeft()
else
stopAutoLeft()
end
if autoLeftSetVisual then
autoLeftSetVisual(autoLeftEnabled)
end
end
elseif name == "AutoBat" then
callback = function(setActive)
if not autoBatEnabled then
enableAutoBat()
else
disableAutoBat()
end
setActive(autoBatEnabled)
end
elseif name == "AutoRight" then
callback = function(setActive)
autoRightEnabled = not autoRightEnabled
setActive(autoRightEnabled)
if autoRightEnabled then
startAutoRight()
else
stopAutoRight()
end
if autoRightSetVisual then
autoRightSetVisual(autoRightEnabled)
end
end
elseif name == "TpDown" then
callback = function(setActive)
teleportDown()
setActive(true)
task.delay(0.2, function()
setActive(false)
end)
end
elseif name == "Carry" then
callback = function(setActive)
if not speedMode then
speedMode = true
laggerToggled = false
laggerCarryToggled = false
setActive(true)
if buttons.Lagger1 and buttons.Lagger1.setActive then
buttons.Lagger1.setActive(false)
end
if buttons.Lagger2 and buttons.Lagger2.setActive then
buttons.Lagger2.setActive(false)
end
else
speedMode = false
setActive(false)
end
refreshSpeedModeLabel()
end
elseif name == "Lagger1" then
callback = function(setActive)
if speedMode then
speedMode = false
if mobSetCarry then
mobSetCarry(false)
end
end
if not laggerToggled then
laggerToggled = true
laggerCarryToggled = false
setActive(true)
if buttons.Lagger2 and buttons.Lagger2.setActive then
buttons.Lagger2.setActive(false)
end
else
laggerToggled = false
setActive(false)
end
refreshSpeedModeLabel()
end
else
callback = nil
if name == "Lagger2" then
callback = function(setActive)
if speedMode then
speedMode = false
if mobSetCarry then
mobSetCarry(false)
end
end
if not laggerCarryToggled then
laggerCarryToggled = true
laggerToggled = false
setActive(true)
if buttons.Lagger1 and buttons.Lagger1.setActive then
buttons.Lagger1.setActive(false)
end
else
laggerToggled = false
setActive(false)
end
refreshSpeedModeLabel()
end
elseif name == "Float" then
callback = function(setActive)
if _G.WhiteHubFloatToggle then
_G.WhiteHubFloatToggle()
end
setActive(_G.WhiteHubFloatOn == true)
end
end
end
mobSetAutoBat = buttons.AutoBat and buttons.AutoBat.setActive
mobSetAutoLeft = buttons.AutoLeft and buttons.AutoLeft.setActive
mobSetAutoRight = buttons.AutoRight and buttons.AutoRight.setActive
mobSetDropBR = buttons.DropBR and buttons.DropBR.setActive
mobSetTpDown = buttons.TpDown and buttons.TpDown.setActive
mobSetCarry = buttons.Carry and buttons.Carry.setActive
mobSetLagger1 = buttons.Lagger1 and buttons.Lagger1.setActive
mobSetLagger2 = buttons.Lagger2 and buttons.Lagger2.setActive
mobSetFloat = buttons.Float and buttons.Float.setActive
local setActive = createButton(name, text, i - 1, true, callback)
if name == "AutoBat" then
mobSetAutoBat = setActive
end
if name == "AutoLeft" then
mobSetAutoLeft = setActive
end
if name == "AutoRight" then
mobSetAutoRight = setActive
end
if name == "DropBR" then
mobSetDropBR = setActive
end
if name == "TpDown" then
mobSetTpDown = setActive
end
if name == "Carry" then
mobSetCarry = setActive
end
if name == "Lagger1" then
mobSetLagger1 = setActive
end
if name == "Lagger2" then
mobSetLagger2 = setActive
end
if name == "Float" then
mobSetFloat = setActive
end
end
if buttons.AutoBat and buttons.AutoBat.setActive then
buttons.AutoBat.setActive(autoBatEnabled)
end
if buttons.AutoLeft and buttons.AutoLeft.setActive then
buttons.AutoLeft.setActive(autoLeftEnabled)
end
if buttons.AutoRight and buttons.AutoRight.setActive then
buttons.AutoRight.setActive(autoRightEnabled)
end
if buttons.Carry and buttons.Carry.setActive then
buttons.Carry.setActive(speedMode)
end
if buttons.Lagger1 and buttons.Lagger1.setActive then
buttons.Lagger1.setActive(laggerToggled)
end
if buttons.Lagger2 and buttons.Lagger2.setActive then
buttons.Lagger2.setActive(laggerCarryToggled)
end
if savedMobilePanelPos then
container.Position = UDim2.new(
savedMobilePanelPos.XScale or 1,
savedMobilePanelPos.XOffset or -10,
savedMobilePanelPos.YScale or 1,
savedMobilePanelPos.YOffset or -364
)
end
local draggingPanel = false
local position = nil
local position2 = nil
local function startDragPanel(input)
if uiLocked or _isDraggingButton or editModeEnabled then
return
end
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
draggingPanel = true
position = container.Position
position2 = input.Position
end
end
local function onDragPanel(input)
if not draggingPanel or uiLocked then
return
end
if
input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch
then
if position and position2 then
local delta = input.Position - position2
container.Position = UDim2.new(
position.X.Scale,
position.X.Offset + delta.X,
position.Y.Scale,
position.Y.Offset + delta.Y
)
end
end
end
local function endDragPanel()
if draggingPanel then
draggingPanel = false
savedMobilePanelPos = {
XScale = container.Position.X.Scale,
XOffset = container.Position.X.Offset,
YScale = container.Position.Y.Scale,
YOffset = container.Position.Y.Offset,
}
pcall(saveAllSettings)
end
position = nil
position2 = nil
end
container.InputBegan:Connect(startDragPanel)
container.InputEnded:Connect(endDragPanel)
UserInputService.InputChanged:Connect(onDragPanel)
UserInputService.InputEnded:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
endDragPanel()
end
end)
_G.AmbitiousApplyMobileButtonsHidden()
return screenGui
end
createBatV2FloatingButton = function()
local sILVER = Instance.new("ScreenGui")
sILVER.Name = "BatV2Button"
sILVER.ResetOnSpawn = false
sILVER.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sILVER.DisplayOrder = 22
pcall(function()
if syn and syn.protect_gui then
syn.protect_gui(sILVER)
end
end)
if not pcall(function()
sILVER.Parent = game:GetService("CoreGui")
end) then
sILVER.Parent = localPlayer:WaitForChild("PlayerGui")
end
local panel = Instance.new("Frame", sILVER)
panel.Size = UDim2.new(0, 60, 0, 60)
panel.Name = "Frame"
if batV2FloatingPos then
panel.Position = UDim2.new(
batV2FloatingPos.XScale or 1,
batV2FloatingPos.XOffset or -146,
batV2FloatingPos.YScale or 1,
batV2FloatingPos.YOffset or -286
)
else
panel.Position = UDim2.new(1, -146, 1, -286)
end
panel.AnchorPoint = Vector2.new(1, 0)
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BackgroundTransparency = 0
panel.BorderSizePixel = 0
panel.ZIndex = 20
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
local uiGradient = Instance.new("UIGradient", panel)
uiGradient.Name = "BtnGrad"
uiGradient.Rotation = 90
local btnFrame = {}
local object = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
local object2543 = ColorSequenceKeypoint.new(0.35, Color3.fromRGB(0, 0, 0))
local object2544 = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0))
btnFrame[1] = object
btnFrame[2] = object2543
btnFrame[3] = object2544
btnFrame[4] = ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
uiGradient.Color = ColorSequence.new(btnFrame)
local uiStroke = Instance.new("UIStroke", panel)
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Thickness = 1
uiStroke.Transparency = 0.45
local label = Instance.new("TextLabel", panel)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "BAT\nBYPASS"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBlack
label.TextSize = 10
label.TextWrapped = true
label.ZIndex = 21
local uiScale = Instance.new("UIScale", panel)
uiScale.Scale = floatingButtonScale
table.insert(_floatingUIScales, uiScale)
panel:SetAttribute("GreenBtn", true)
local function setActive(state)
paintFloatingBtn(panel, state)
end
paintFloatingBtn(panel, false)
local dragging = false
local hasMoved = false
local position = nil
local position2 = nil
panel.InputBegan:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
dragging = true
hasMoved = false
position = input.Position
position2 = panel.Position
end
end)
panel.InputChanged:Connect(function(input)
if not dragging then
return
end
if
input.UserInputType == Enum.UserInputType.MouseMovement
or input.UserInputType == Enum.UserInputType.Touch
then
local delta = input.Position - position
if 5 < delta.Magnitude then
hasMoved = true
end
if hasMoved and not uiLocked then
panel.Position = UDim2.new(
position2.X.Scale,
position2.X.Offset + delta.X,
position2.Y.Scale,
position2.Y.Offset + delta.Y
)
end
end
end)
panel.InputEnded:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
if dragging then
if not hasMoved then
setActive(not autoBatV2Enabled)
toggleBatV2()
elseif not uiLocked and hasMoved then
batV2FloatingPos = {
XScale = panel.Position.X.Scale,
XOffset = panel.Position.X.Offset,
YScale = panel.Position.Y.Scale,
YOffset = panel.Position.Y.Offset,
}
pcall(saveAllSettings)
end
dragging = false
hasMoved = false
end
end
end)
batV2FloatingButton = sILVER
return sILVER
end
createInstaResetFloatingButton = function()
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InstaResetButton"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 23
pcall(function()
if syn and syn.protect_gui then
syn.protect_gui(screenGui)
end
end)
if not pcall(function()
screenGui.Parent = game:GetService("CoreGui")
end) then
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end
local btnFrame = Instance.new("Frame", screenGui)
btnFrame.Size = UDim2.new(0, 60, 0, 60)
btnFrame.Name = "Frame"
if instaResetFloatingPos then
btnFrame.Position = UDim2.new(
instaResetFloatingPos.XScale or 1,
instaResetFloatingPos.XOffset or -146,
instaResetFloatingPos.YScale or 1,
instaResetFloatingPos.YOffset or -130
)
else
btnFrame.Position = UDim2.new(1, -146, 1, -130)
end
btnFrame.AnchorPoint = Vector2.new(1, 0)
btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btnFrame.BorderSizePixel = 0
btnFrame.ZIndex = 20
Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 10)
local uiGradient = Instance.new("UIGradient", btnFrame)
uiGradient.Name = "BtnGrad"
uiGradient.Rotation = 90
local data = {}
local object = ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0))
local object2569 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(0, 0, 0))
local object2570 = ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 0))
data[1] = object
data[2] = object2569
data[3] = object2570
data[4] = ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
uiGradient.Color = ColorSequence.new(data)
local uiStroke = Instance.new("UIStroke", btnFrame)
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Thickness = 1
uiStroke.Transparency = 0.45
local label = Instance.new("TextLabel", btnFrame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "INSTA\nRESET"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBlack
label.TextSize = 11
label.TextWrapped = true
label.ZIndex = 21
local uiScale = Instance.new("UIScale", btnFrame)
uiScale.Scale = floatingButtonScale
table.insert(_floatingUIScales, uiScale)
local dragging = nil
local hasMoved = nil
local position = nil
local position2 = nil
local activeInput = nil
local function pointInside(position)
local absolutePosition = btnFrame.AbsolutePosition
local absoluteSize = btnFrame.AbsoluteSize
return position.X >= absolutePosition.X
and position.X <= absolutePosition.X + absoluteSize.X
and position.Y >= absolutePosition.Y
and position.Y <= absolutePosition.Y + absoluteSize.Y
end
btnFrame:SetAttribute("GreenBtn", true)
local function setActive(state)
paintFloatingBtn(btnFrame, state and true or false)
end
paintFloatingBtn(btnFrame, false)
btnFrame.InputBegan:Connect(function(input)
if
input.UserInputType == Enum.UserInputType.MouseButton1
or input.UserInputType == Enum.UserInputType.Touch
then
if activeInput then
return
end
activeInput = input
dragging = true
hasMoved = false
position = input.Position
position2 = btnFrame.Position
end
end)
UserInputService.InputChanged:Connect(function(input)
if not dragging or not activeInput then
return
end
if
not (activeInput.UserInputType == Enum.UserInputType.Touch and input == activeInput)
and not (
activeInput.UserInputType == Enum.UserInputType.MouseButton1
and input.UserInputType == Enum.UserInputType.MouseMovement
)
then
return
end
local delta = input.Position - position
if delta.Magnitude > 12 then
hasMoved = true
end
if hasMoved and not uiLocked then
btnFrame.Position = UDim2.new(
position2.X.Scale,
position2.X.Offset + delta.X,
position2.Y.Scale,
position2.Y.Offset + delta.Y
)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input ~= activeInput then
return
end
if
input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch
then
return
end
if dragging then
if not hasMoved and (input.Position - position).Magnitude <= 12 and pointInside(input.Position) then
print("[IR] tap → instaReset()")
setActive(true)
if _G.InstaReset and _G.InstaReset.Trigger then
_G.InstaReset.Trigger()
end
task.delay(0.2, function()
setActive(false)
end)
elseif not uiLocked and hasMoved then
instaResetFloatingPos = {
XScale = btnFrame.Position.X.Scale,
XOffset = btnFrame.Position.X.Offset,
YScale = btnFrame.Position.Y.Scale,
YOffset = btnFrame.Position.Y.Offset,
}
pcall(saveAllSettings)
end
dragging = false
hasMoved = false
activeInput = nil
end
end)
instaResetFloatingButton = screenGui
return screenGui
end
batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil
isActive = false
object = 0
isPlayerRagdolled = function(player)
if not player or not player.Character then
return false
end
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if not humanoid then
return false
end
local state = humanoid:GetState()
return state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
end
hasAnimationalEquipped = function(player)
if not player or not player.Character then
return false
end
for _, child in ipairs(player.Character:GetChildren()) do
if child:IsA("Tool") then
if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then
return true
end
end
end
return false
end
findNearbyArmedPlayer = function()
local character = localPlayer.Character
if not character then
return nil
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return nil
end
local object = huge
local object2607 = nil
for _, player in ipairs(Players:GetPlayers()) do
if player ~= localPlayer and player.Character then
if hasAnimationalEquipped(player) then
local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if humanoidRootPart2 and humanoid and humanoid.Health > 0 then
local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude
if magnitude < 12 and magnitude < object then
object = magnitude
object2607 = player
end
end
end
end
end
return object2607
end
do
local function getBatV2Counter()
local character = localPlayer.Character
if not character then
return nil
end
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Tool") then
local name = child.Name:lower()
if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
return child
end
end
end
local backpack = localPlayer:FindFirstChild("Backpack")
if backpack then
for _, child in ipairs(backpack:GetChildren()) do
if child:IsA("Tool") then
local name = child.Name:lower()
if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
child.Parent = character
return child
end
end
end
end
if backpack then
for _, child in ipairs(backpack:GetChildren()) do
if child:IsA("Tool") then
child.Parent = character
return child
end
end
end
return nil
end
tryHitBatCounterV2 = function()
if batCounterV2HitCooldown then
return
end
batCounterV2HitCooldown = true
pcall(function()
local bat = getBatV2Counter()
if bat then
bat:Activate()
local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
if remoteEvent then
remoteEvent:FireServer()
end
end
end)
task.delay(BAT_COUNTER_V2_SWING_CD, function()
batCounterV2HitCooldown = false
end)
end
end
do
local function executeBatCounterV2()
local now = getTime()
if now - object < 0.01 then
return
end
if batCounterV2Debounce then
return
end
batCounterV2Debounce = true
object = now
local attacker = findNearbyArmedPlayer()
if not attacker then
batCounterV2Debounce = false
return
end
if isPlayerRagdolled(attacker) then
batCounterV2Debounce = false
return
end
if not hasAnimationalEquipped(attacker) then
batCounterV2Debounce = false
return
end
isActive = batDesyncTpEnabled
if not batDesyncTpEnabled then
startBatDesyncTp()
if batDesyncTpSetVisual then
batDesyncTpSetVisual(true)
end
end
local function doCounterHit()
local character = localPlayer.Character
if not character then
return
end
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart then
return
end
local character2 = attacker.Character
if not character2 then
return
end
local humanoidRootPart2 = character2:FindFirstChild("HumanoidRootPart")
if not humanoidRootPart2 then
return
end
if not hasAnimationalEquipped(attacker) then
batCounterV2Debounce = false
return
end
if sethiddenproperty then
sethiddenproperty(humanoidRootPart, "PhysicsRepRootPart", humanoidRootPart2)
end
local targetPosition = humanoidRootPart2.Position + newVector3(0, 2.5, 0)
if (humanoidRootPart.Position - targetPosition).Magnitude > 8 then
humanoidRootPart.CFrame = newCFrame(targetPosition)
end
tryHitBatCounterV2()
task.delay(0.05, function()
tryHitBatCounterV2()
end)
task.delay(0.1, function()
tryHitBatCounterV2()
end)
end
doCounterHit()
task.delay(0.2, function()
if not isActive and batDesyncTpEnabled then
stopBatDesyncTp()
if batDesyncTpSetVisual then
batDesyncTpSetVisual(false)
end
end
batCounterV2Debounce = false
end)
end
stopBatCounterV2 = function()
if batCounterV2Conn then
batCounterV2Conn:Disconnect()
batCounterV2Conn = nil
end
batCounterV2Debounce = false
batCounterV2HitCooldown = false
end
startBatCounterV2 = function()
if batCounterV2Conn then
return
end
batCounterV2Conn = RunService.Heartbeat:Connect(function()
if not batCounterV2Enabled then
return
end
if batCounterV2Debounce then
return
end
local character = localPlayer.Character
if not character then
return
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
if not humanoid or humanoid.Health <= 0 then
return
end
local state = humanoid:GetState()
if
state == Enum.HumanoidStateType.Physics
or state == Enum.HumanoidStateType.Ragdoll
or state == Enum.HumanoidStateType.FallingDown
or state == Enum.HumanoidStateType.GettingUp
or state == Enum.HumanoidStateType.Stunned
then
local object = findNearbyArmedPlayer()
if object then
if not isPlayerRagdolled(object) then
if hasAnimationalEquipped(object) then
executeBatCounterV2()
end
end
end
end
end)
end
end
end
toggleBatCounterV2 = function()
batCounterV2Enabled = not batCounterV2Enabled
if batCounterV2Enabled then
startBatCounterV2()
else
stopBatCounterV2()
end
return batCounterV2Enabled
end
updateUIFromLoaded = function()
task.wait()
if normalBox then
normalBox.Text = tostring(NS)
end
if carryBox then
carryBox.Text = tostring(CS)
end
if radInput then
radInput.Text = tostring(CONFIG.STEAL_RANGE)
end
if laggerBox then
laggerBox.Text = tostring(LAGGER_SPEED)
end
if lagger2Box then
lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
end
if batSpeedBox then
batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
end
if uiScaleBox then
uiScaleBox.Text = tostring(uiScaleValue)
end
if dropModeBtnRef then
dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
end
if bodyLockRangeBox then
bodyLockRangeBox.Text = tostring(bodyLockRange)
end
if carrySysNormalBox then
carrySysNormalBox.Text = tostring(carryController.normalSpeed)
end
if carrySysCarryBox then
carrySysCarryBox.Text = tostring(carryController.carrySpeed)
end
if carrySysLaggerBox then
carrySysLaggerBox.Text = tostring(carryController.laggerSpeed)
end
if carrySysLaggerCarryBox then
carrySysLaggerCarryBox.Text = tostring(carryController.laggerCarrySpeed)
end
if carrySysSoftStealSpeedBox then
carrySysSoftStealSpeedBox.Text = tostring(carryController.softStealSpeed)
end
if carrySysSoftStealRadiusBox then
carrySysSoftStealRadiusBox.Text = tostring(carryController.softStealRadius)
end
if carrySystemToggleSetter then
carrySystemToggleSetter(useCarrySystem)
end
if autoStealVariantLabel then
autoStealVariantLabel.Text = getAutoStealVariantName(autoStealVariant or 1)
end
refreshSpeedModeLabel()
if infJumpSetVisual then
infJumpSetVisual(infJumpEnabled)
end
if infJumpModeSetVisual then
infJumpModeSetVisual.Text = infJumpMode
end
if mirrorTPDownSetVisual then
mirrorTPDownSetVisual(mirrorTPDownEnabled)
end
if setSafeModeVisual then
setSafeModeVisual(antiKickEnabled)
end
if setNoPlayerCollisionVisual then
setNoPlayerCollisionVisual(noPlayerCollisionEnabled)
end
if setNoCamCollisionVisual then
setNoCamCollisionVisual(noCamCollisionEnabled)
end
for _, entry2522 in ipairs(keyButtonRefs) do
local entry = entry2522.entry
entry2522.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
end
if savedProgressBarPos and pbFrame then
pbFrame.Position = UDim2.new(
savedProgressBarPos.XScale or 0.5,
savedProgressBarPos.XOffset or -130,
savedProgressBarPos.YScale or 1,
savedProgressBarPos.YOffset or -62
)
end
applyFloatingButtonScale()
if uiLocked and setLockUIVisual then
setLockUIVisual(true)
end
if editModeEnabled and setEditModeVisual then
setEditModeVisual(true)
end
if _G.updateAntiRagdollUI then
_G.updateAntiRagdollUI(antiRagdollMode)
end
if antiRagdollMode == "v1" then
antiRagdollController.start()
elseif antiRagdollMode == "v2" then
enableAntiRagdollV2()
end
if antiDieEnabled then
if setAntiDieVisual then
setAntiDieVisual(true)
end
antiDie.start()
elseif setAntiDieVisual then
setAntiDieVisual(false)
end
if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then
setInstaGrab(true)
pcall(startAutoSteal)
end
if medusaCounterEnabled then
if setMedusaVisual then
setMedusaVisual(true)
end
if localPlayer.Character then
setupMedusaCounter(localPlayer.Character)
end
else
if setMedusaVisual then
setMedusaVisual(false)
end
stopMedusaCounter()
end
if batCounterEnabled and setBatCounterVisual then
setBatCounterVisual(true)
startBatCounter()
end
if batCounterV2Enabled and setBatCounterV2Visual then
setBatCounterV2Visual(true)
startBatCounterV2()
end
if unwalkEnabled and setUnwalkVisual then
setUnwalkVisual(true)
task.spawn(function()
task.wait(0.5)
startUnwalk()
end)
end
if antiLagEnabled then
if setAntiLagVisual then
setAntiLagVisual(true)
end
enableAntiLag()
else
if setAntiLagVisual then
setAntiLagVisual(false)
end
disableAntiLag()
end
if espEnabled then
toggleESP(true)
if setESPVIsual then
setESPVIsual(true)
end
else
toggleESP(false)
if setESPVIsual then
setESPVIsual(false)
end
end
if batDesyncTpEnabled then
if batDesyncTpSetVisual then
batDesyncTpSetVisual(true)
end
if not _G.AlvaroTP.on then
startBatDesyncTp()
end
updateTpBatButtonWithAntiDie(true)
else
if batDesyncTpSetVisual then
batDesyncTpSetVisual(false)
end
updateTpBatButtonWithAntiDie(false)
end
if autoBatV2Enabled then
if autoBatV2SetVisual then
autoBatV2SetVisual(true)
end
if batV2FloatingButton then
local frame = batV2FloatingButton:FindFirstChild("Frame")
if frame then
paintFloatingBtn(frame, true)
end
end
else
if autoBatV2SetVisual then
autoBatV2SetVisual(false)
end
if batV2FloatingButton then
local frame = batV2FloatingButton:FindFirstChild("Frame")
if frame then
paintFloatingBtn(frame, false)
end
end
end
if neonWeatherEnabled then
applyNeonWeather()
if setNeonWeatherVisual then
setNeonWeatherVisual(true)
end
else
restoreLightingState()
if setNeonWeatherVisual then
setNeonWeatherVisual(false)
end
end
if stretchEnabled then
enableStretch()
if _G.stretchToggleSetter then
_G.stretchToggleSetter(true)
end
elseif _G.stretchToggleSetter then
_G.stretchToggleSetter(false)
end
if setFovVisual then
setFovVisual(fovEnabled)
end
if fovSliderSet then
fovSliderSet(fovValue)
end
if mobSetAutoBat then
mobSetAutoBat(autoBatEnabled)
end
if mobSetAutoLeft then
mobSetAutoLeft(autoLeftEnabled)
end
if mobSetAutoRight then
mobSetAutoRight(autoRightEnabled)
end
if mobSetCarry then
mobSetCarry(speedMode)
end
if mobSetLagger1 then
mobSetLagger1(laggerToggled)
end
if mobSetLagger2 then
mobSetLagger2(laggerCarryToggled)
end
if bodyLockEnabled and bodyLockSetVisual then
if _blSuppressCount == 0 then
bodyLockSetVisual(true)
startBodyLock()
else
bodyLockSetVisual(false)
end
end
if MinecraftBatSetVisual then
MinecraftBatSetVisual(minecraftBatSkinEnabled)
end
if MinecraftBatColorSelector then
MinecraftBatColorSelector.Text = minecraftBatSkinColorMode
end
if minecraftBatSkinEnabled then
minecraftBatSkinController.State.enabled = true
pcall(minecraftBatSkinController.Apply)
end
updateProgressBarVisibility()
startEnemySpeed()
toggleLockUI(uiLocked)
pcall(function()
applyOutfitByIndex(currentOutfitIndex)
end)
if outfitSelectorLabel then
outfitSelectorLabel.Text = outfits[currentOutfitIndex].label
end
if backgroundImage then
applyBackground(backgroundIndex)
end
if contentPages and contentPages.Visual then
for _, child in ipairs(contentPages.Visual:GetChildren()) do
if child:IsA("Frame") and child:FindFirstChild("BackgroundPreview") then
local backgroundPreview = child.BackgroundPreview
local previewImage = backgroundPreview:FindFirstChild("PreviewImage")
local previewPlaceholder = backgroundPreview:FindFirstChild("PreviewPlaceholder")
local object = BACKGROUND_IMAGES[backgroundIndex]
if previewImage then
if object and object.id and object.id ~= "" then
previewImage.Image = object.id
if previewPlaceholder then
previewPlaceholder.Visible = false
end
else
previewImage.Image = ""
if previewPlaceholder then
previewPlaceholder.Visible = true
end
end
end
break
end
end
end
if MobilePanel then
local floatingPanel = MobilePanel:FindFirstChild("FloatingPanel")
if floatingPanel then
if savedMobilePanelPos then
floatingPanel.Position = UDim2.new(
savedMobilePanelPos.XScale or 1,
savedMobilePanelPos.XOffset or -10,
savedMobilePanelPos.YScale or 1,
savedMobilePanelPos.YOffset or -364
)
end
local buttonsContainer = floatingPanel:FindFirstChild("ButtonsContainer")
if buttonsContainer then
for _, child in ipairs(buttonsContainer:GetChildren()) do
if child:IsA("TextButton") then
local vector = savedButtonPositions and savedButtonPositions[child.Name]
if vector then
child.Position = UDim2.new(0, vector.X or 0, 0, vector.Y or 0)
end
end
end
end
end
end
if tpBatFloatingButton and tpBatFloatingPos then
local frame = tpBatFloatingButton:FindFirstChild("Frame")
if frame then
frame.Position = UDim2.new(
tpBatFloatingPos.XScale or 1,
tpBatFloatingPos.XOffset or -146,
tpBatFloatingPos.YScale or 1,
tpBatFloatingPos.YOffset or -208
)
end
end
if batV2FloatingButton and batV2FloatingPos then
local frame = batV2FloatingButton:FindFirstChild("Frame")
if frame then
frame.Position = UDim2.new(
batV2FloatingPos.XScale or 1,
batV2FloatingPos.XOffset or -146,
batV2FloatingPos.YScale or 1,
batV2FloatingPos.YOffset or -286
)
end
end
if instaResetFloatingButton and instaResetFloatingPos then
local frame = instaResetFloatingButton:FindFirstChild("Frame")
if frame then
frame.Position = UDim2.new(
instaResetFloatingPos.XScale or 1,
instaResetFloatingPos.XOffset or -146,
instaResetFloatingPos.YScale or 1,
instaResetFloatingPos.YOffset or -130
)
end
end
end
CloverHubAutoTPDown = false
CloverHubAutoTPDownHeight = 20
CloverHubShowE01Warning = false
CloverHubAutoTPLastAt = 0
CloverHubE01StartedAt = nil
CloverHubE01Gui = nil
RunService.Heartbeat:Connect(function()
if not CloverHubAutoTPDown then
return
end
local character = localPlayer.Character
local rootPart = character and character:FindFirstChild("HumanoidRootPart")
character = character and character:FindFirstChildOfClass("Humanoid")
local shouldTeleportDown = rootPart
and character
and character.FloorMaterial == Enum.Material.Air
and rootPart.Position.Y >= CloverHubAutoTPDownHeight
if shouldTeleportDown then
local lastTeleportTime = CloverHubAutoTPLastAt
shouldTeleportDown = tick() - lastTeleportTime >= 0.35
end
if shouldTeleportDown then
CloverHubAutoTPLastAt = tick()
teleportDown()
end
end)
do
local function isCarryingTarget()
local carryNow = os.clock()
if carryNow - (_G.__cloverCarryT or 0) < 0.15 then
return _G.__cloverCarryV == true
end
_G.__cloverCarryT = carryNow
_G.__cloverCarryV = false
local character = localPlayer.Character
if not character then
return false
end
for _, child in ipairs(character:GetChildren()) do
local lowercaseText = child.Name:lower()
if
lowercaseText:find("brain", 1, true)
or lowercaseText:find("animal", 1, true)
or lowercaseText:find("carry", 1, true)
or lowercaseText:find("steal", 1, true)
then
_G.__cloverCarryV = true
return true
end
end
local humanoid = character:FindFirstChildOfClass("Humanoid")
local carrying = humanoid ~= nil and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16
_G.__cloverCarryV = carrying
return carrying
end
RunService.Heartbeat:Connect(function()
if not CloverHubShowE01Warning or not isCarryingTarget() then
if CloverHubE01Gui then
CloverHubE01Gui.Enabled = false
end
CloverHubE01StartedAt = nil
return
end
CloverHubE01StartedAt = CloverHubE01StartedAt or tick()
local object = CloverHubE01StartedAt
local value = math.clamp((tick() - object) / 2.6, 0, 1)
if not CloverHubE01Gui then
CloverHubE01Gui = Instance.new("ScreenGui")
CloverHubE01Gui.Name = "CloverHubE01Warning"
CloverHubE01Gui.ResetOnSpawn = false
CloverHubE01Gui.IgnoreGuiInset = true
CloverHubE01Gui.Parent = localPlayer:WaitForChild("PlayerGui")
local frame = Instance.new("Frame", CloverHubE01Gui)
frame.Name = "Bar"
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0, 18)
frame.Size = UDim2.new(0, 300, 0, 36)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.34
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
local rootPart = Instance.new("Frame", frame)
rootPart.Name = "Track"
rootPart.Position = UDim2.new(0, 3, 0, 3)
rootPart.Size = UDim2.new(1, -6, 1, -6)
rootPart.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
rootPart.BackgroundTransparency = 0.48
rootPart.BorderSizePixel = 0
rootPart.ClipsDescendants = true
Instance.new("UICorner", rootPart).CornerRadius = UDim.new(1, 0)
local frame2558 = Instance.new("Frame", rootPart)
frame2558.Name = "Fill"
frame2558.Size = UDim2.new(0, 0, 1, 0)
frame2558.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame2558.BackgroundTransparency = 0.48
frame2558.BorderSizePixel = 0
Instance.new("UICorner", frame2558).CornerRadius = UDim.new(1, 0)
local textLabel = Instance.new("TextLabel", frame)
textLabel.Name = "Label"
textLabel.Size = UDim2.new(1, -16, 1, 0)
textLabel.Position = UDim2.new(0, 8, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.GothamBlack
textLabel.TextSize = 14
textLabel.TextStrokeTransparency = 0.18
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.ZIndex = 2
end
CloverHubE01Gui.Enabled = true
local warningReady = value >= 1
CloverHubE01Gui.Bar.Label.Text = warningReady and "STEAL" or "DONT STEAL"
CloverHubE01Gui.Bar.Label.TextColor3 = warningReady and Color3.fromRGB(255, 255, 255)
or Color3.fromRGB(0, 0, 0)
CloverHubE01Gui.Bar.Track.Fill.Size = UDim2.new(value, 0, 1, 0)
end)
end
buildGui()
MobilePanel = createMobilePanel()
_G.WhiteHubRefreshFloatBtn = function()
    local on = _G.WhiteHubFloatOn == true
    if mobSetFloat then pcall(mobSetFloat, on) end
end
batV2FloatingButton = createBatV2FloatingButton()
instaResetFloatingButton = createInstaResetFloatingButton()
do
local function createLastPositionTracker()
local trackerPlayersService = game:GetService("Players")
local trackerRunService = game:GetService("RunService")
local trackerWorkspace = game:GetService("Workspace")
local trackerPlayer = trackerPlayersService.LocalPlayer
local color = Color3.fromRGB(0, 0, 0)
Color3.fromRGB(0, 0, 0)
local color2 = Color3.fromRGB(0, 0, 0)
local color3 = Color3.fromRGB(0, 0, 0)
local color4 = Color3.fromRGB(0, 0, 0)
local color5 = Color3.fromRGB(0, 0, 0)
local mapMinX = -536.2
local mapMaxX = -422
local mapMinY = -10
local mapMinZ = -71.8
local trackerState = {
marker = nil,
markerLocked = false,
markerTarget = nil,
samples = {},
conn = nil,
acc = 0,
}
local function isValidVector(position)
return position ~= nil
and position.X == position.X
and position.Y == position.Y
and position.Z == position.Z
and math.abs(position.X) < 10000000
and math.abs(position.Y) < 10000000
and math.abs(position.Z) < 10000000
end
local function isInsideMapBounds(position)
if not position then
return false
end
return position.X >= mapMinX
and position.X <= mapMaxX
and position.Y >= mapMinY
and position.Y <= 75
and position.Z >= mapMinZ
and position.Z <= 192.9
end
local function getHistoricalSample(targetState, currentTime)
if not targetState or not targetState.history or #targetState.history == 0 then
return nil
end
local cutoffTime = currentTime - 0.2
local sample = nil
for _, historyEntry in ipairs(targetState.history) do
if historyEntry.time <= cutoffTime then
sample = historyEntry
continue
end
break
end
return sample or targetState.history[1]
end
local function hideLastPositionMarker()
trackerState.markerLocked = false
local marker = trackerState.marker
if not marker then
return
end
pcall(function()
marker.Transparency = 1
local alwaysOnTopSphere = marker:FindFirstChild("AlwaysOnTopSphere")
if alwaysOnTopSphere then
alwaysOnTopSphere.Visible = false
end
local lastPositionHighlight = marker:FindFirstChild("LastPositionHighlight")
if lastPositionHighlight then
lastPositionHighlight.Enabled = false
end
local lastPositionLabel = marker:FindFirstChild("LastPositionLabel")
if lastPositionLabel then
lastPositionLabel.Enabled = false
end
end)
end
local function showLastPositionMarker(rootPart)
if trackerState.markerLocked then
return
end
if not rootPart or not isInsideMapBounds(rootPart.Position) then
return
end
local rotation = rootPart.Rotation
local cFrame = CFrame.new(rootPart.Position.X, -7, rootPart.Position.Z) * rotation
local marker = trackerState.marker
if not marker or not marker.Parent then
marker = Instance.new("Part")
marker.Name = "CloverHubLastPosition"
marker.Shape = Enum.PartType.Ball
marker.Size = Vector3.new(3, 3, 3)
marker.Color = color
marker.Material = Enum.Material.Neon
marker.Anchored = true
marker.CanCollide = false
marker.CanTouch = false
marker.CanQuery = false
marker.CastShadow = false
marker.Parent = trackerWorkspace
local sphereHandleAdornment = Instance.new("SphereHandleAdornment")
sphereHandleAdornment.Name = "AlwaysOnTopSphere"
sphereHandleAdornment.Adornee = marker
sphereHandleAdornment.Radius = 1.55
sphereHandleAdornment.Color3 = color5
sphereHandleAdornment.Transparency = 0.05
sphereHandleAdornment.AlwaysOnTop = true
sphereHandleAdornment.Visible = true
sphereHandleAdornment.ZIndex = 10
sphereHandleAdornment.Parent = marker
local highlight = Instance.new("Highlight")
highlight.Name = "LastPositionHighlight"
highlight.Adornee = marker
highlight.FillColor = color
highlight.FillTransparency = 0.15
highlight.OutlineColor = color2
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Enabled = true
highlight.Parent = marker
local billboardGui = Instance.new("BillboardGui")
billboardGui.Name = "LastPositionLabel"
billboardGui.Size = UDim2.new(0, 110, 0, 20)
billboardGui.StudsOffset = Vector3.new(0, 2.1, 0)
billboardGui.AlwaysOnTop = true
billboardGui.Adornee = marker
billboardGui.Parent = marker
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.fromScale(1, 1)
textLabel.BackgroundTransparency = 1
textLabel.Text = "ultima posicion"
textLabel.TextColor3 = color3
textLabel.TextStrokeColor3 = color4
textLabel.TextStrokeTransparency = 0.25
textLabel.TextSize = 11
textLabel.Font = Enum.Font.GothamMedium
textLabel.Parent = billboardGui
trackerState.marker = marker
end
marker.Transparency = 0
local alwaysOnTopSphere = marker:FindFirstChild("AlwaysOnTopSphere")
if alwaysOnTopSphere then
alwaysOnTopSphere.Visible = true
end
local lastPositionHighlight = marker:FindFirstChild("LastPositionHighlight")
if lastPositionHighlight then
lastPositionHighlight.Enabled = true
end
local lastPositionLabel = marker:FindFirstChild("LastPositionLabel")
if lastPositionLabel then
lastPositionLabel.Enabled = true
end
marker.CFrame = cFrame
trackerState.markerLocked = true
end
local function isValidTargetPlayer(player)
if not player or player.Parent ~= trackerPlayersService or not player.Character then
return false
end
local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if
not humanoidRootPart
or not humanoid
or humanoid.Health <= 0
or not isValidVector(humanoidRootPart.Position)
then
return false
end
return isInsideMapBounds(humanoidRootPart.Position)
end
local function updateTargetTracking()
local character = trackerPlayer.Character
character = character and character:FindFirstChild("HumanoidRootPart")
if not character then
return
end
local markerTarget = trackerState.markerTarget
if markerTarget and markerTarget.Parent == trackerPlayersService then
local character2 = markerTarget.Character
local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
character2 = character2 and character2:FindFirstChildOfClass("Humanoid")
local rootPart = trackerState.samples[markerTarget] or {}
trackerState.samples[markerTarget] = rootPart
if
humanoidRootPart
and character2
and character2.Health > 0
and isValidVector(humanoidRootPart.Position)
then
if isInsideMapBounds(humanoidRootPart.Position) then
local now2 = tick()
if trackerState.markerLocked then
rootPart.history = {}
end
rootPart.history = rootPart.history or {}
table.insert(rootPart.history, {
time = now2,
safePosition = humanoidRootPart.Position,
safeCFrame = humanoidRootPart.CFrame,
})
while rootPart.history[1] and now2 - rootPart.history[1].time > 0.45 do
table.remove(rootPart.history, 1)
end
rootPart.safePosition = humanoidRootPart.Position
rootPart.safeCFrame = humanoidRootPart.CFrame
hideLastPositionMarker()
else
local rootPart2738 = getHistoricalSample(rootPart, tick())
showLastPositionMarker(rootPart2738 and rootPart2738.safeCFrame or rootPart.safeCFrame)
end
end
if not (character2 and character2.Health <= 0 or not humanoidRootPart and not rootPart.safeCFrame) then
return
end
trackerState.markerTarget = nil
hideLastPositionMarker()
end
local huge2 = math.huge
local player2740 = nil
for _, player in ipairs(trackerPlayersService:GetPlayers()) do
if player ~= trackerPlayer and isValidTargetPlayer(player) then
local position = character.Position
local magnitude = (player.Character:FindFirstChild("HumanoidRootPart").Position - position).Magnitude
if magnitude < huge2 then
huge2 = magnitude
player2740 = player
end
end
end
if player2740 then
trackerState.markerTarget = player2740
local rootPart = player2740.Character:FindFirstChild("HumanoidRootPart")
trackerState.samples[player2740] = {
safePosition = rootPart.Position,
safeCFrame = rootPart.CFrame,
history = {
{
time = tick(),
safePosition = rootPart.Position,
safeCFrame = rootPart.CFrame,
},
},
}
end
end
local rootPart
rootPart = {
GetMarkerCFrame = function()
local marker = trackerState.marker
if trackerState.markerLocked and marker and marker.Parent and marker.Transparency < 1 then
local markerTarget = trackerState.markerTarget
local humanoidRootPart = markerTarget
and markerTarget.Character
and markerTarget.Character:FindFirstChild("HumanoidRootPart")
if humanoidRootPart and isInsideMapBounds(humanoidRootPart.Position) then
hideLastPositionMarker()
return nil
end
return marker.CFrame
end
return nil
end,
ForceMarker = function(markerTarget, rootPart2751)
if markerTarget and markerTarget.Parent == trackerPlayersService then
trackerState.markerTarget = markerTarget
end
markerTarget = markerTarget and trackerState.samples[markerTarget]
local rootPart2752 = getHistoricalSample(markerTarget, tick())
markerTarget = rootPart2752 and rootPart2752.safeCFrame or markerTarget and markerTarget.safeCFrame
if not (not markerTarget and rootPart2751 and isInsideMapBounds(rootPart2751.Position)) then
rootPart2751 = markerTarget
end
if rootPart2751 then
showLastPositionMarker(rootPart2751)
end
return rootPart.GetMarkerCFrame()
end,
SetTarget = function(markerTarget)
if markerTarget and markerTarget ~= trackerPlayer and markerTarget.Parent == trackerPlayersService then
trackerState.markerTarget = markerTarget
end
end,
Clear = function()
trackerState.markerTarget = nil
hideLastPositionMarker()
end,
Destroy = function()
rootPart.Stop()
if trackerState.marker and trackerState.marker.Parent then
pcall(function()
trackerState.marker:Destroy()
end)
end
trackerState.marker = nil
end,
Start = function()
if trackerState.conn then
return trackerState.conn
end
trackerState.conn = trackerRunService.Heartbeat:Connect(function(deltaTime)
trackerState.acc = trackerState.acc + (deltaTime or 0)
if trackerState.acc < 0.016666666666666666 then
return
end
trackerState.acc = trackerState.acc % 0.016666666666666666
updateTargetTracking()
end)
return trackerState.conn
end,
Stop = function()
if trackerState.conn then
trackerState.conn:Disconnect()
trackerState.conn = nil
end
end,
IsInsideMap = isInsideMapBounds,
}
return rootPart
end
local cloverHubLastPosMarker = createLastPositionTracker()
_G.CloverHubLastPosMarker = cloverHubLastPosMarker
cloverHubLastPosMarker.Start()
end
if loadAllSettings() then
updateUIFromLoaded()
end
task.spawn(function()
task.wait(5)
while true do
pcall(saveAllSettings)
task.wait(5)
end
end)
Players.PlayerRemoving:Connect(function(leavingPlayer)
if leavingPlayer == localPlayer then
pcall(saveAllSettings)
end
end)
if useCarrySystem then
carryController:start()
carryController.speedToggled = speedMode
if laggerCarryToggled then
carryController:setLaggerMode(2)
elseif laggerToggled then
carryController:setLaggerMode(1)
else
carryController:setLaggerMode(0)
end
carryController:setSoftStealEnabled(true)
end
if localPlayer.Character then
task.wait(0.1)
if waitForCharacterReady(localPlayer.Character, 5) then
setupMovementAndIndicators(localPlayer.Character)
if currentAnimPack ~= "Off" then
applyAnimationPack(currentAnimPack)
end
pcall(function()
applyOutfitByIndex(currentOutfitIndex)
end)
if katanaSkinEnabled then
task.wait(0.6)
pcall(function()
katanaSkinController.ApplySkin("KATANA")
end)
end
if minecraftBatSkinEnabled then
task.wait(0.6)
pcall(function()
minecraftBatSkinController.Apply()
end)
end
end
end
do
local value = 0
localPlayer.CharacterAdded:Connect(function(character)
value += 1
local object = value
if autoStealConnection then
autoStealConnection:Disconnect()
autoStealConnection = nil
end
autoStealBusy = false
stopAutoLeft()
stopAutoRight()
stopBatCounter()
stopBatCounterV2()
stopMedusaCounter()
if not isActive then
stopUnwalk()
end
stopDropBrainrot()
if autoBatEnabled then
disableAutoBat()
end
if batDesyncTpEnabled then
stopBatDesyncTp()
end
if autoBatV2Enabled then
disableBatV2()
end
if bodyLockEnabled then
stopBodyLock()
end
local value2760 = getTime() + 5
while
not character.Parent
or not character:FindFirstChild("HumanoidRootPart")
or not character:FindFirstChildOfClass("Humanoid")
do
if value2760 < getTime() then
return
end
if object ~= value then
return
end
task.wait(0.05)
end
velocityHookedRoots = {}
local object2761 = registerVelocityRoot(character)
installVelocityReadHook(object2761)
setupMovementAndIndicators(character)
if antiRagdollMode == "v1" then
antiRagdollController.start()
elseif antiRagdollMode == "v2" then
enableAntiRagdollV2()
end
if antiDie.enabled then
task.defer(function()
reapplyAntiDie(character)
end)
end
if CONFIG.AUTO_STEAL_ENABLED then
pcall(startAutoSteal)
end
if batDesyncTpEnabled then
task.defer(startBatDesyncTp)
end
if autoBatV2Enabled then
task.defer(enableBatV2)
end
if BatAimbotState and BatAimbotState.enabled then
task.defer(function()
if _G.NewBatAimbot then _G.NewBatAimbot.start() end
end)
end
if bodyLockEnabled and _blSuppressCount == 0 then
startBodyLock()
end
if medusaCounterEnabled then
setupMedusaCounter(character)
if setMedusaVisual then
setMedusaVisual(true)
end
else
stopMedusaCounter()
if setMedusaVisual then
setMedusaVisual(false)
end
end
if batCounterEnabled then
startBatCounter()
end
if batCounterV2Enabled then
startBatCounterV2()
end
if unwalkEnabled and not isActive then
startUnwalk()
end
if currentAnimPack ~= "Off" then
task.wait(0.3)
applyAnimationPack(currentAnimPack)
end
updateProgressBarVisibility()
refreshSpeedModeLabel()
pcall(function()
applyOutfitByIndex(currentOutfitIndex)
end)
if outfitSelectorLabel then
outfitSelectorLabel.Text = outfits[currentOutfitIndex].label
end
if katanaSkinEnabled then
task.wait(1)
pcall(function()
katanaSkinController.ApplySkin("KATANA")
end)
end
if minecraftBatSkinEnabled then
task.wait(0.6)
pcall(function()
minecraftBatSkinController.Apply()
end)
end
end)
end
do
local value = 0
UserInputService.InputBegan:Connect(function(input, gameProcessed)
if _anyKeyListening then
return
end
if input.UserInputType == Enum.UserInputType.Keyboard then
if gameProcessed or UserInputService:GetFocusedTextBox() then
return
end
elseif not isGamepadInput(input) then
return
end
if not isBindableInput(input) then
return
end
local keyCode = input.KeyCode
if not keyCode then
return
end
if kbMatch(KB.LaggerMode, keyCode) then
if getTime() - value >= 0.3 then
value = getTime()
toggleLaggerCycle()
end
return
end
if kbMatch(KB.CarryToggle, keyCode) then
toggleCarryMode()
return
end
if kbMatch(KB.DropBrainrot, keyCode) then
if not dropActive then
if dropBrainrotSetVisual then
dropBrainrotSetVisual(true)
end
executeDropWithToggle(dropBrainrotSetVisual)
end
return
end
if kbMatch(KB.TPFloor, keyCode) then
teleportDown()
return
end
if kbMatch(KB.InstaReset, keyCode) then
if _G.InstaReset and _G.InstaReset.Trigger then
_G.InstaReset.Trigger()
end
return
end
if kbMatch(KB.AutoLeft, keyCode) then
autoLeftEnabled = not autoLeftEnabled
if autoLeftEnabled then
startAutoLeft()
else
stopAutoLeft()
end
if autoLeftSetVisual then
autoLeftSetVisual(autoLeftEnabled)
end
if mobSetAutoLeft then
mobSetAutoLeft(autoLeftEnabled)
end
return
end
if kbMatch(KB.AutoRight, keyCode) then
autoRightEnabled = not autoRightEnabled
if autoRightEnabled then
startAutoRight()
else
stopAutoRight()
end
if autoRightSetVisual then
autoRightSetVisual(autoRightEnabled)
end
if mobSetAutoRight then
mobSetAutoRight(autoRightEnabled)
end
return
end
if kbMatch(KB.AutoBat, keyCode) then
if not autoBatEnabled then
enableAutoBat()
if autoBatSetVisual then
autoBatSetVisual(true)
end
if mobSetAutoBat then
mobSetAutoBat(true)
end
else
disableAutoBat()
if autoBatSetVisual then
autoBatSetVisual(false)
end
if mobSetAutoBat then
mobSetAutoBat(false)
end
end
return
end
if kbMatch(KB.BatV2, keyCode) then
toggleBatV2()
if autoBatV2SetVisual then
autoBatV2SetVisual(autoBatV2Enabled)
end
if batV2FloatingButton then
local btnFrame = batV2FloatingButton:FindFirstChild("Frame")
if btnFrame then
paintFloatingBtn(btnFrame, autoBatV2Enabled)
end
end
return
end
if kbMatch(KB.GuiHide, keyCode) then
if main then
if main.Visible then
hideGui()
else
showGui()
end
end
return
end
end)
end
return



-- ============================================================
-- K7 SONGS - 65 SONGS (64 from FINAL + 117206383809583)
-- Small GUI with X close
-- ============================================================
task.spawn(function()
repeat task.wait() until game:IsLoaded()
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
if not LP then return end
local PlayerGui = LP:WaitForChild("PlayerGui")
local HubGui = PlayerGui
pcall(function() local g=gethui() if typeof(g)=='Instance' then HubGui=g end end)
local _k7s_isfile=isfile
local _k7s_writefile=writefile
local _k7s_getcustomasset=getcustomasset or getsynasset
local _k7s_request=(syn and syn.request) or request or http_request

-- ═══════════════════════════════════════════════════════════════
-- WHITE HUB ANTI BAT (panel toggles on screen; feature stays on when hidden)
-- Adapted from Daily anti-bat logic, rebranded WHITE HUB
-- ═══════════════════════════════════════════════════════════════
do
    local Players = game:GetService("Players")
    local UIS = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer

    local _WhiteHubAntiBatScreen = nil
    local state = {
        antiBat = false,
        infJumpEnabled = false,
        infJumpMode = "manual", -- "manual" | "hold"
        keybind = Enum.KeyCode.V,
        listening = false,
        collapsed = false,
        holdInfJumpConn = nil,
    }

    local antiBatConn, antiBatBusy = nil, false
    local connections = {}
    local function track(c) connections[#connections+1] = c return c end

    local function tween(obj, props, t)
        pcall(function()
            TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
        end)
    end

    local function applyPanelBackground(mainFrame)
        if not mainFrame then return end
        local bg = mainFrame:FindFirstChild("WhiteHubPanelBg")
        if not bg then
            bg = Instance.new("ImageLabel")
            bg.Name = "WhiteHubPanelBg"
            bg.BackgroundTransparency = 1
            bg.Size = UDim2.fromScale(1, 1)
            bg.ScaleType = Enum.ScaleType.Crop
            bg.ZIndex = 0
            bg.Parent = mainFrame
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 14)
            c.Parent = bg
        end
        local id = ""
        pcall(function()
            if BACKGROUND_IMAGES and backgroundIndex and BACKGROUND_IMAGES[backgroundIndex] then
                local entry = BACKGROUND_IMAGES[backgroundIndex]
                if entry.id and entry.id ~= "" then
                    if _G.K7HubResolveBackgroundAsset then
                        id = _G.K7HubResolveBackgroundAsset(entry.id, backgroundIndex) or entry.id
                    else
                        id = entry.id
                    end
                end
            end
        end)
        if id ~= "" then
            bg.Image = id
            bg.ImageTransparency = (typeof(backgroundImageTransparency) == "number") and backgroundImageTransparency or 0.45
            bg.Visible = true
            mainFrame.BackgroundTransparency = 0.35
        else
            bg.Visible = false
            mainFrame.BackgroundTransparency = 0.08
        end
    end

    _G.WhiteHubRefreshAntiBatPanelBg = function()
        if _WhiteHubAntiBatScreen then
            local main = _WhiteHubAntiBatScreen:FindFirstChild("MainFrame")
            if main then applyPanelBackground(main) end
        end
    end

    -- Anti Bat logic
    local function enableAntiBat()
        if antiBatConn then return end
        antiBatConn = RunService.Heartbeat:Connect(function()
            if not state.antiBat or antiBatBusy then return end
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            antiBatBusy = true
            pcall(function()
                local vel = hrp.Velocity
                hrp.Velocity = Vector3.new(math.random(-4000, 4000), vel.Y, math.random(-4000, 4000))
                RunService.RenderStepped:Wait()
                if hrp and hrp.Parent then
                    local cur = hrp.Velocity
                    hrp.Velocity = Vector3.new(vel.X, cur.Y, vel.Z)
                end
            end)
            antiBatBusy = false
        end)
    end

    local function disableAntiBat()
        if antiBatConn then
            antiBatConn:Disconnect()
            antiBatConn = nil
        end
    end

    local function startHoldInfJump()
        if state.holdInfJumpConn then state.holdInfJumpConn:Disconnect() end
        state.holdInfJumpConn = RunService.Heartbeat:Connect(function()
            if not state.infJumpEnabled or state.infJumpMode ~= "hold" then return end
            local char = LocalPlayer.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum then return end
            local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
            if isJumpHeld and root.Velocity.Y < 35 then
                root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
            end
            if root.Velocity.Y < -120 then
                root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
            end
        end)
    end

    local function stopHoldInfJump()
        if state.holdInfJumpConn then
            state.holdInfJumpConn:Disconnect()
            state.holdInfJumpConn = nil
        end
    end

    local function applyInfJumpMode()
        if state.infJumpEnabled and state.infJumpMode == "hold" then
            startHoldInfJump()
        else
            stopHoldInfJump()
        end
    end

    -- Manual inf jump once
    track(UIS.JumpRequest:Connect(function()
        if not state.infJumpEnabled or state.infJumpMode ~= "manual" then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end))

    local function openWhiteAntiBat(forceShow)
        if _WhiteHubAntiBatScreen and _WhiteHubAntiBatScreen.Parent then
            local main = _WhiteHubAntiBatScreen:FindFirstChild("MainFrame")
            if main then
                if forceShow == false then
                    main.Visible = false
                else
                    main.Visible = true
                    applyPanelBackground(main)
                end
            end
            return _WhiteHubAntiBatScreen
        end

        local parentGui = nil
        pcall(function()
            if HubGui then parentGui = HubGui end
        end)
        if not parentGui then
            parentGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
        end

        local screen = Instance.new("ScreenGui")
        screen.Name = "WhiteHubAntiBat"
        screen.ResetOnSpawn = false
        screen.IgnoreGuiInset = true
        screen.DisplayOrder = 10050
        screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screen.Parent = parentGui
        _WhiteHubAntiBatScreen = screen

        local main = Instance.new("Frame")
        main.Name = "MainFrame"
        main.Active = true
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        main.BackgroundTransparency = 0.08
        main.ClipsDescendants = true
        main.Position = UDim2.new(0.5, 0, 0.42, 0)
        main.Size = UDim2.new(0, 260, 0, 230)
        main.Parent = screen
        local mc = Instance.new("UICorner")
        mc.CornerRadius = UDim.new(0, 14)
        mc.Parent = main
        local ms = Instance.new("UIStroke")
        ms.Color = Color3.fromRGB(255, 255, 255)
        ms.Thickness = 1.5
        ms.Transparency = 0.25
        ms.Parent = main

        applyPanelBackground(main)

        local titleBar = Instance.new("Frame")
        titleBar.Size = UDim2.new(1, 0, 0, 40)
        titleBar.BackgroundTransparency = 1
        titleBar.ZIndex = 5
        titleBar.Parent = main

        local title = Instance.new("TextLabel")
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 12, 0, 0)
        title.Size = UDim2.new(1, -50, 1, 0)
        title.Font = Enum.Font.GothamBlack
        title.Text = "WHITE HUB  •  ANTI BAT"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 6
        title.Parent = titleBar

        local hideBtn = Instance.new("TextButton")
        hideBtn.Name = "Hide"
        hideBtn.Size = UDim2.new(0, 28, 0, 28)
        hideBtn.Position = UDim2.new(1, -36, 0, 6)
        hideBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        hideBtn.Text = "X"
        hideBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        hideBtn.Font = Enum.Font.GothamBlack
        hideBtn.TextSize = 13
        hideBtn.AutoButtonColor = false
        hideBtn.ZIndex = 10
        hideBtn.Parent = titleBar
        Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(0, 8)

        -- Hide only the panel; feature keeps running
        hideBtn.MouseButton1Click:Connect(function()
            main.Visible = false
        end)

        local body = Instance.new("Frame")
        body.BackgroundTransparency = 1
        body.Position = UDim2.new(0, 12, 0, 48)
        body.Size = UDim2.new(1, -24, 1, -58)
        body.ZIndex = 6
        body.Parent = main
        local list = Instance.new("UIListLayout")
        list.Padding = UDim.new(0, 8)
        list.Parent = body

        local function makeRow(name)
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 40)
            row.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            row.BackgroundTransparency = 0.35
            row.ZIndex = 7
            row.Parent = body
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
            local st = Instance.new("UIStroke")
            st.Color = Color3.fromRGB(255, 255, 255)
            st.Thickness = 1
            st.Transparency = 0.4
            st.Parent = row

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Position = UDim2.new(0, 12, 0, 0)
            lbl.Size = UDim2.new(1, -70, 1, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.Text = name .. "  •  OFF"
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.TextSize = 12
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 9
            lbl.Parent = row

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = 10
            btn.Parent = row

            local track = Instance.new("Frame")
            track.AnchorPoint = Vector2.new(1, 0.5)
            track.Position = UDim2.new(1, -10, 0.5, 0)
            track.Size = UDim2.new(0, 42, 0, 22)
            track.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            track.ZIndex = 9
            track.Parent = row
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

            local knob = Instance.new("Frame")
            knob.Position = UDim2.new(0, 3, 0, 3)
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            knob.ZIndex = 10
            knob.Parent = track
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

            return row, lbl, track, knob, btn
        end

        local _, abLbl, abTrack, abKnob, abBtn = makeRow("Anti Bat")
        local _, ijLbl, ijTrack, ijKnob, ijBtn = makeRow("Infinite Jump")

        local keybindBtn = Instance.new("TextButton")
        keybindBtn.Size = UDim2.new(1, 0, 0, 36)
        keybindBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        keybindBtn.BackgroundTransparency = 0.35
        keybindBtn.Font = Enum.Font.GothamBold
        keybindBtn.Text = "Keybind : V"
        keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        keybindBtn.TextSize = 12
        keybindBtn.ZIndex = 7
        keybindBtn.AutoButtonColor = false
        keybindBtn.Parent = body
        Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 10)
        local kst = Instance.new("UIStroke")
        kst.Color = Color3.fromRGB(255, 255, 255)
        kst.Transparency = 0.4
        kst.Parent = keybindBtn

        local function setToggleVisual(name, on, label, track, knob)
            label.Text = name .. "  •  " .. (on and "ON" or "OFF")
            label.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
            track.BackgroundColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
            knob.BackgroundColor3 = on and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            knob.Position = on and UDim2.new(0, 23, 0, 3) or UDim2.new(0, 3, 0, 3)
        end

        local function setAntiBat(on)
            state.antiBat = on
            setToggleVisual("Anti Bat", on, abLbl, abTrack, abKnob)
            if on then enableAntiBat() else disableAntiBat() end
        end

        local function setInfJump(on)
            state.infJumpEnabled = on
            setToggleVisual("Infinite Jump", on, ijLbl, ijTrack, ijKnob)
            applyInfJumpMode()
        end

        abBtn.MouseButton1Click:Connect(function() setAntiBat(not state.antiBat) end)
        ijBtn.MouseButton1Click:Connect(function() setInfJump(not state.infJumpEnabled) end)

        local function refreshKeybindText()
            keybindBtn.Text = state.listening and "Keybind : ..." or ("Keybind : " .. state.keybind.Name)
        end
        refreshKeybindText()

        keybindBtn.MouseButton1Click:Connect(function()
            state.listening = true
            refreshKeybindText()
        end)

        track(UIS.InputBegan:Connect(function(input, processed)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if state.listening then
                state.listening = false
                if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.Unknown then
                    state.keybind = input.KeyCode
                end
                refreshKeybindText()
                return
            end
            if processed then return end
            if input.KeyCode == state.keybind then
                setAntiBat(not state.antiBat)
            end
        end))

        -- Drag
        do
            local dragging, dragStart, startPos = false, nil, nil
            local function beginDrag(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
                dragging = true
                dragStart = input.Position
                startPos = main.Position
            end
            titleBar.InputBegan:Connect(beginDrag)
            main.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    -- only drag from empty area roughly top
                end
            end)
            UIS.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local d = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
        end

        -- restore visuals if already on
        setToggleVisual("Anti Bat", state.antiBat, abLbl, abTrack, abKnob)
        setToggleVisual("Infinite Jump", state.infJumpEnabled, ijLbl, ijTrack, ijKnob)

        return screen
    end

    _G.openWhiteAntiBat = openWhiteAntiBat
    _G.toggleWhiteAntiBatUI = function()
        if not (_WhiteHubAntiBatScreen and _WhiteHubAntiBatScreen.Parent) then
            pcall(openWhiteAntiBat, true)
            return true
        end
        local main = _WhiteHubAntiBatScreen:FindFirstChild("MainFrame")
        if not main then
            pcall(openWhiteAntiBat, true)
            return true
        end
        main.Visible = not main.Visible
        if main.Visible then applyPanelBackground(main) end
        return main.Visible
    end
    _G.isWhiteAntiBatUIOpen = function()
        local main = _WhiteHubAntiBatScreen and _WhiteHubAntiBatScreen:FindFirstChild("MainFrame")
        return main and main.Visible == true
    end
    _G.WhiteHubAntiBatIsOn = function()
        return state.antiBat == true
    end
end


MUSIC_PLAYER_OPTIONS = MUSIC_PLAYER_OPTIONS or {
  {name="a la carte", url="https://files.catbox.moe/nnfh2s.mp3", file="a_la_carte.mp3"},
  {name="Gelato", url="https://files.catbox.moe/sospih.mp3", file="K7DuelsHubMusic1.mp3"},
  {name="Meant To Be", url="https://files.catbox.moe/smt6l8.mp3", file="K7DuelsHubMusic2.mp3"},
  {name="Beccaria San Vittore RMX", url="https://files.catbox.moe/2r8auq.mp3", file="K7DuelsHubMusic3.mp3"},
  {name="The Box", url="https://files.catbox.moe/yumqjl.mp3", file="K7DuelsHubMusic4.mp3"},
  {name="Mu Ammar Gheddafi RMX", url="https://files.catbox.moe/qcuden.mp3", file="K7DuelsHubMusic5.mp3"},
  {name="Marocchino RMX", url="https://files.catbox.moe/iyav31.mp3", file="K7DuelsHubMusic6.mp3"},
  {name="Gotham Mashup", url="https://files.catbox.moe/7eof36.mp3", file="K7DuelsHubMusic7.mp3"},
  {name="Goosebumps", url="https://files.catbox.moe/6wqcck.mp3", file="K7DuelsHubMusic8.mp3"},
  {name="Houdini", url="https://files.catbox.moe/gsuxur.mp3", file="K7DuelsHubMusic9.mp3"},
  {name="Magnolia", url="https://files.catbox.moe/ursllw.mp3", file="K7DuelsHubMusic10.mp3"},
  {name="Redemption RMX", url="https://files.catbox.moe/kjxkv7.mp3", file="K7DuelsHubMusic11.mp3"},
  {name="Evicted RMX", url="https://files.catbox.moe/s28bh5.mp3", file="K7DuelsHubMusic12.mp3"},
  {name="Lyfe RMX", url="https://files.catbox.moe/8hciqx.mp3", file="K7DuelsHubMusic13.mp3"},
  {name="No Refunds RMX", url="https://files.catbox.moe/uz9hot.mp3", file="K7DuelsHubMusic14.mp3"},
  {name="8 AM In Manny RMX", url="https://files.catbox.moe/xh4t0r.mp3", file="K7DuelsHubMusic15.mp3"},
  {name="Us Vs Them RMX", url="https://files.catbox.moe/po5fbj.mp3", file="K7DuelsHubMusic16.mp3"},
  {name="Reflection 2 RMX", url="https://files.catbox.moe/kcst57.mp3", file="K7DuelsHubMusic17.mp3"},
  {name="I Know You Care RMX", url="https://files.catbox.moe/c2en1v.mp3", file="K7DuelsHubMusic18.mp3"},
  {name="Bubblegum RMX", url="https://files.catbox.moe/8xf15k.mp3", file="K7DuelsHubMusic19.mp3"},
  {name="Cream RMX", url="https://files.catbox.moe/yfhgqz.mp3", file="K7DuelsHubMusic20.mp3"},
  {name="Panzerknacker.wav", url="https://files.catbox.moe/izcvhm.mp3", file="K7DuelsHubMusic21.mp3"},
  {name="Freaked Out", url="https://files.catbox.moe/dyt2ja.mp3", file="K7DuelsHubMusic22.mp3"},
  {name="Scam Likely", url="https://files.catbox.moe/pr85mz.mp3", file="K7DuelsHubMusic23.mp3"},
  {name="Pure Cocaine", url="https://files.catbox.moe/dvjtjk.mp3", file="K7DuelsHubMusic24.mp3"},
  {name="Tesla", url="https://files.catbox.moe/n85fch.mp3", file="K7DuelsHubMusic25.mp3"},
  {name="Piazza Di Spaccio 2 RMX", url="https://files.catbox.moe/0ompvn.mp3", file="K7DuelsHubMusic26.mp3"},
  {name="Benef RMX", url="https://files.catbox.moe/swcqe5.mp3", file="K7DuelsHubMusic27.mp3"},
  {name="Accavallato RMX", url="https://files.catbox.moe/pme01q.mp3", file="K7DuelsHubMusic28.mp3"},
  {name="Hd RMX", url="https://files.catbox.moe/oa3ylr.mp3", file="K7DuelsHubMusic29.mp3"},
  {name="Vyzee", url="https://files.catbox.moe/gmxz02.mp3", file="K7DuelsHubMusic30.mp3"},
  {name="Addiction", url="https://files.catbox.moe/unkq06.mp3", file="K7DuelsHubMusic31.mp3"},
  {name="America RMX", url="https://files.catbox.moe/k09ioc.mp3", file="K7DuelsHubMusic32.mp3"},
  {name="Sprinter", url="https://files.catbox.moe/0gyb73.mp3", file="K7DuelsHubMusic33.mp3"},
  {name="Band4Band", url="https://files.catbox.moe/47dehm.mp3", file="K7DuelsHubMusic34.mp3"},
  {name="Doja RMX", url="https://files.catbox.moe/8ze5d8.mp3", file="K7DuelsHubMusic35.mp3"},
  {name="Opinel RMX", url="https://files.catbox.moe/hf6pdq.mp3", file="K7DuelsHubMusic36.mp3"},
  {name="Vrp RMX", url="https://files.catbox.moe/hjzkbu.mp3", file="K7DuelsHubMusic37.mp3"},
  {name="Tarantelle RMX", url="https://files.catbox.moe/0e9jwg.mp3", file="K7DuelsHubMusic38.mp3"},
  {name="Hood RMX", url="https://files.catbox.moe/raewna.mp3", file="K7DuelsHubMusic39.mp3"},
  {name="Mask RMX", url="https://files.catbox.moe/ghqz2q.mp3", file="K7DuelsHubMusic40.mp3"},
  {name="Spinnin RMX", url="https://files.catbox.moe/r9achz.mp3", file="K7DuelsHubMusic41.mp3"},
  {name="Dnd RMX", url="https://files.catbox.moe/1d83ju.mp3", file="K7DuelsHubMusic42.mp3"},
  {name="Xnx RMX", url="https://files.catbox.moe/a2e54o.mp3", file="K7DuelsHubMusic43.mp3"},
  {name="Hypebae RMX", url="https://files.catbox.moe/oj6hix.mp3", file="K7DuelsHubMusic44.mp3"},
  {name="Mercedes Nero RMX", url="https://h.uguu.se/dCgHArHt.mp3", file="K7DuelsHubMusic45.mp3", rev=2},
  {name="Dissenatori RMX", url="https://files.catbox.moe/fbjq0w.mp3", file="K7DuelsHubMusic46.mp3"},
  {name="British RMX", url="https://files.catbox.moe/jn9mmr.mp3", file="K7DuelsHubMusic47.mp3"},
  {name="Go Go Jack RMX", url="https://files.catbox.moe/u31krk.mp3", file="K7DuelsHubMusic48.mp3"},
  {name="Darkmoney RMX", url="https://files.catbox.moe/rz4mzu.mp3", file="K7DuelsHubMusic49.mp3"},
  {name="Ghetto RMX", url="https://files.catbox.moe/omj56p.mp3", file="K7DuelsHubMusic50.mp3"},
  {name="Copacabana RMX", url="https://files.catbox.moe/g43412.mp3", file="K7DuelsHubMusic51.mp3"},
  {name="Laja-Setadora", url="https://files.catbox.moe/94olvv.mp3", file="K7DuelsHubMusic52.mp3"},
  {name="DUKI, Myke Towers - Nueva", url="https://files.catbox.moe/cb88xa.mp3", file="K7DuelsHubMusic53.mp3"},
  {name="Gra Gra Boom", url="https://files.catbox.moe/vy21x7.mp3", file="K7DuelsHubMusic54.mp3"},
  {name="LAJA - NADIE TA FRIO", url="https://files.catbox.moe/ecc674.mp3", file="K7DuelsHubMusic55.mp3"},
  {name="Katya Lel", url="https://files.catbox.moe/lg4en9.mp3", file="K7DuelsHubMusic56.mp3"},
  {name="Montagem Supersonic", url="https://files.catbox.moe/rlykfl.mp3", file="K7DuelsHubMusic57.mp3"},
  {name="NO ERA AMOR", url="https://files.catbox.moe/6x3ori.mp3", file="K7DuelsHubMusic58.mp3"},
  {name="KING NASIR DANCE", url="https://files.catbox.moe/y62e3y.mp3", file="K7DuelsHubMusic59.mp3"},
  {name="Pibble Song", url="https://files.catbox.moe/eixg9d.mp3", file="K7DuelsHubMusic60.mp3"},
  {name="Esclava", url="https://files.catbox.moe/cdsh6o.mp3", file="K7DuelsHubMusic61.mp3"},
  {name="I Will Survive", url="https://files.catbox.moe/65sjh6.mp3", file="K7DuelsHubMusic62.mp3"},
  {name="siinamota", url="https://files.catbox.moe/8lnwtq.mp3", file="K7DuelsHubMusic63.mp3"},
  {name="IDK 2", url="https://files.catbox.moe/e5lgcd.mp3", file="K7DuelsHubMusic64.mp3"},
  {name="117206383809583", url="rbxassetid://117206383809583", file="K7DuelsHubMusic65.mp3"},
  {name="78658486161852", url="rbxassetid://78658486161852", file="K7DuelsHubMusic66.mp3"},
  {name="96414211708215", url="rbxassetid://96414211708215", file="K7DuelsHubMusic67.mp3"},
  {name="82746224492420", url="rbxassetid://82746224492420", file="K7DuelsHubMusic68.mp3"},
  {name="110919391228823", url="rbxassetid://110919391228823", file="K7DuelsHubMusic69.mp3"},
  {name="71393805905055", url="rbxassetid://71393805905055", file="K7DuelsHubMusic70.mp3"},
  {name="91007045451630", url="rbxassetid://91007045451630", file="K7DuelsHubMusic71.mp3"},








}

    local selectedMusicSong = 1
    local musicPlayerVolume = 1
    local musicPlayerSpeed = 1
    local musicAutoPlayNext = false
    local musicShuffleEnabled = false
    local musicLoopEnabled = false
    local _musicPlayerSound = nil
    local _musicPlayerToken = 0
    local musicSongCache = {}
    local musicSongDownloading = {}

    local function getMusicSongName()
        local opt = MUSIC_PLAYER_OPTIONS[selectedMusicSong]
        return opt and opt.name or "No Song"
    end
    local function musicRandomIndex()
        local total = #MUSIC_PLAYER_OPTIONS
        if total <= 1 then return 1 end
        local r = math.random(1, total - 1)
        if r >= selectedMusicSong then r = r + 1 end
        return r
    end
    local function _musicRefreshUI()
        if _G.K7SongsMusicRefreshUI then pcall(_G.K7SongsMusicRefreshUI) end
    end
    local function cacheMusicSong(option, allowDownload)
        if not option or not option.url or option.url == "" then return nil end
        local url = option.url
        if url:find("rbxassetid") or tonumber(url) then
            if tonumber(url) then return "rbxassetid://"..tostring(tonumber(url)) end
            return url
        end
        if not (_k7s_writefile and _k7s_getcustomasset) then return nil end
        local fileName = option.file or ("K7Songs_"..option.name..".mp3")
        if musicSongCache[fileName] then return musicSongCache[fileName] end
        if _k7s_isfile and _k7s_isfile(fileName) then
            local ok, asset = pcall(function() return _k7s_getcustomasset(fileName) end)
            if ok and asset then musicSongCache[fileName]=asset return asset end
        end
        if musicSongDownloading[fileName] then
            local t0=tick()
            while musicSongDownloading[fileName] and tick()-t0<20 do task.wait(0.1) end
            return musicSongCache[fileName]
        end
        musicSongDownloading[fileName]=true
        pcall(function()
            if _k7s_request then
                local res=_k7s_request({Url=url, Method="GET"})
                local body=res and (res.Body or res.body)
                if body then _k7s_writefile(fileName, body) end
            end
        end)
        task.wait(0.2)
        local asset=nil
        pcall(function() if _k7s_isfile and _k7s_isfile(fileName) then asset=_k7s_getcustomasset(fileName) end end)
        if asset then musicSongCache[fileName]=asset end
        musicSongDownloading[fileName]=nil
        return asset
    end
    local function createMusicSound(option, name)
        if not option then return nil end
        local soundId = cacheMusicSong(option, true)
        if not soundId then return nil end
        local sound = Instance.new("Sound")
        sound.Name = name or "K7SongsMusicPlayer"
        sound.Volume = musicPlayerVolume
        sound.PlaybackSpeed = musicPlayerSpeed
        sound.Looped = false
        sound.SoundId = soundId
        sound.Parent = SoundService
        return sound
    end
    local function fadeOutMusicSound(sound, dur)
        if not sound then return end
        dur=dur or 1.2
        pcall(function() TweenService:Create(sound, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Volume=0}):Play() end)
        task.delay(dur+0.1, function() pcall(function() if sound and sound.Parent then sound:Stop() sound:Destroy() end end) end)
    end
    local function stopMusicPlayback(fade)
        _musicPlayerToken=_musicPlayerToken+1
        local sound=_musicPlayerSound
        _musicPlayerSound=nil
        if sound then
            if fade==false then pcall(function() sound:Stop() sound:Destroy() end) else fadeOutMusicSound(sound,1.2) end
        end
        _musicRefreshUI()
    end
    local function playMusicSong(index)
        index=tonumber(index) or selectedMusicSong
        local total=#MUSIC_PLAYER_OPTIONS
        if total<=0 then return end
        if index<1 then index=total end
        if index>total then index=1 end
        selectedMusicSong=index
        stopMusicPlayback(true)
        local token=_musicPlayerToken
        _musicRefreshUI()
        task.spawn(function()
            local option=MUSIC_PLAYER_OPTIONS[index]
            local sound=createMusicSound(option, "K7SongsMusicPlayer_"..tostring(token))
            if token~=_musicPlayerToken then if sound then pcall(function() sound:Destroy() end) end return end
            if not sound then return end
            sound.Volume=musicPlayerVolume
            sound.PlaybackSpeed=musicPlayerSpeed
            sound.TimePosition=0
            _musicPlayerSound=sound
            local loadStart=tick()
            while sound and sound.Parent and not sound.IsLoaded and tick()-loadStart<15 do task.wait(0.05) end
            if token~=_musicPlayerToken then pcall(function() if sound and sound.Parent then sound:Destroy() end end) return end
            pcall(function() sound:Play() end)
            _musicRefreshUI()
            local endedConn
            endedConn=sound.Ended:Connect(function()
                if endedConn then pcall(function() endedConn:Disconnect() end) end
                if token~=_musicPlayerToken then return end
                if musicLoopEnabled then playMusicSong(selectedMusicSong)
                elseif musicShuffleEnabled then playMusicSong(musicRandomIndex())
                elseif musicAutoPlayNext then playMusicSong(selectedMusicSong+1)
                else stopMusicPlayback(false) end
            end)
        end)
    end
    local function toggleMusicPause()
        local sound=_musicPlayerSound
        if not sound or not sound.Parent then playMusicSong(selectedMusicSong) return end
        if sound.IsPlaying then pcall(function() sound:Pause() end) else pcall(function() sound:Resume() end) end
        _musicRefreshUI()
    end
    local function musicNextSong() if musicShuffleEnabled then playMusicSong(musicRandomIndex()) else playMusicSong(selectedMusicSong+1) end end
    local function musicPrevSong() if musicShuffleEnabled then playMusicSong(musicRandomIndex()) else playMusicSong(selectedMusicSong-1) end end
    local function musicSeek(delta)
        local sound=_musicPlayerSound
        if not sound or not sound.Parent then return end
        local len=sound.TimeLength or 0
        local sp=tonumber(musicPlayerSpeed) or 1
        if sp<=0 then sp=1 end
        local newPos=sound.TimePosition + ((tonumber(delta) or 0)*sp)
        if newPos<0 then newPos=0 end
        if len>0 and newPos>(len-0.2) then newPos=math.max(len-0.2,0) end
        pcall(function() sound.TimePosition=newPos end)
        _musicRefreshUI()
    end
    local function setMusicSpeed(v) v=math.clamp(math.floor((tonumber(v) or 1)*10+0.5)/10,0.1,2) musicPlayerSpeed=v local s=_musicPlayerSound if s and s.Parent then pcall(function() s.PlaybackSpeed=v end) end _musicRefreshUI() end
    local function setMusicVolume(v) v=math.clamp(math.floor((tonumber(v) or 1)*100+0.5)/100,0,2) musicPlayerVolume=v local s=_musicPlayerSound if s and s.Parent then pcall(function() s.Volume=v end) end _musicRefreshUI() end

    local function corner(gui,r) local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,r) c.Parent=gui return c end
    local function stroke(gui,col,th,tr) local s=Instance.new("UIStroke") s.Color=col s.Thickness=th or 1 s.Transparency=tr or 0 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=gui return s end

    local k7SongsGui = Instance.new("ScreenGui")
    k7SongsGui.Name = "VERIS Songs"
    k7SongsGui.ResetOnSpawn = false
    k7SongsGui.IgnoreGuiInset = true
    k7SongsGui.DisplayOrder = 9999
    k7SongsGui.Parent = HubGui

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "K7SongsToggle"
    toggleBtn.Size = UDim2.new(0, 100, 0, 32)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -80)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    toggleBtn.Text = "SONGS"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 12
    toggleBtn.Parent = k7SongsGui
    corner(toggleBtn,8)
    stroke(toggleBtn, Color3.fromRGB(255, 255, 255),1,0.2)

    local mpGui=nil
    local function closeMusicPlayer()
        _G.K7SongsMusicRefreshUI=nil
        if mpGui and mpGui.Parent then local g=mpGui mpGui=nil task.delay(0.2,function() pcall(function() if g and g.Parent then g:Destroy() end end) end) else mpGui=nil end
    end

    local function openMusicPlayer()
        if mpGui and mpGui.Parent then closeMusicPlayer() return end
        mpGui = Instance.new("ScreenGui")
        mpGui.Name = "K7SongsPlayerPopup"
        mpGui.ResetOnSpawn = false
        mpGui.IgnoreGuiInset = true
        mpGui.DisplayOrder = 10000
        mpGui.Parent = HubGui

        local backdrop = Instance.new("Frame")
        backdrop.Size=UDim2.new(1,0,1,0)
        backdrop.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        backdrop.BackgroundTransparency=0.5
        backdrop.BorderSizePixel=0
        backdrop.ZIndex=1
        backdrop.Parent=mpGui
        backdrop.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then closeMusicPlayer() end end)

        local POP_W,POP_H=300,380
        local frame=Instance.new("Frame")
        frame.Size=UDim2.new(0,POP_W,0,POP_H)
        frame.Position=UDim2.new(0.5,-POP_W/2,0.5,-POP_H/2)
        frame.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel=0
        frame.ZIndex=2
        frame.Parent=mpGui
        corner(frame,14)
        stroke(frame,Color3.fromRGB(255, 255, 255),1,0.3)

        local titleBar=Instance.new("Frame")
        titleBar.Size=UDim2.new(1,0,0,40)
        titleBar.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        titleBar.BorderSizePixel=0
        titleBar.ZIndex=3
        titleBar.Parent=frame
        corner(titleBar,14)

        local title=Instance.new("TextLabel")
        title.Text="SONGS"
        title.Size=UDim2.new(1,-70,1,0)
        title.Position=UDim2.new(0,14,0,0)
        title.BackgroundTransparency=1
        title.TextColor3=Color3.fromRGB(255, 255, 255)
        title.Font=Enum.Font.GothamBlack
        title.TextSize=14
        title.TextXAlignment=Enum.TextXAlignment.Left
        title.ZIndex=4
        title.Parent=titleBar

        -- X CLOSE BUTTON
        local closeBtn=Instance.new("TextButton")
        closeBtn.Name="CloseBtn"
        closeBtn.Size=UDim2.new(0,28,0,28)
        closeBtn.Position=UDim2.new(1,-36,0,6)
        closeBtn.BackgroundColor3=Color3.fromRGB(255, 255, 255)
        closeBtn.Text="X"
        closeBtn.TextColor3=Color3.fromRGB(255, 255, 255)
        closeBtn.Font=Enum.Font.GothamBlack
        closeBtn.TextSize=13
        closeBtn.ZIndex=4
        closeBtn.Parent=titleBar
        corner(closeBtn,8)
        closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3=Color3.fromRGB(255, 255, 255) end)
        closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3=Color3.fromRGB(255, 255, 255) end)
        closeBtn.MouseButton1Click:Connect(closeMusicPlayer)

        local nameLbl=Instance.new("TextLabel")
        nameLbl.Text=getMusicSongName()
        nameLbl.Size=UDim2.new(1,-20,0,20)
        nameLbl.Position=UDim2.new(0,10,0,48)
        nameLbl.BackgroundTransparency=1
        nameLbl.TextColor3=Color3.fromRGB(255, 255, 255)
        nameLbl.Font=Enum.Font.GothamBlack
        nameLbl.TextSize=12
        nameLbl.TextXAlignment=Enum.TextXAlignment.Center
        nameLbl.ZIndex=4
        nameLbl.Parent=frame

        local counterLbl=Instance.new("TextLabel")
        counterLbl.Text=""
        counterLbl.Size=UDim2.new(1,-20,0,12)
        counterLbl.Position=UDim2.new(0,10,0,68)
        counterLbl.BackgroundTransparency=1
        counterLbl.TextColor3=Color3.fromRGB(255, 255, 255)
        counterLbl.Font=Enum.Font.GothamBold
        counterLbl.TextSize=10
        counterLbl.TextXAlignment=Enum.TextXAlignment.Center
        counterLbl.ZIndex=4
        counterLbl.Parent=frame

        local barBg=Instance.new("Frame")
        barBg.Size=UDim2.new(1,-20,0,6)
        barBg.Position=UDim2.new(0,10,0,84)
        barBg.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        barBg.BorderSizePixel=0
        barBg.ZIndex=4
        barBg.Parent=frame
        corner(barBg,3)
        local barFill=Instance.new("Frame")
        barFill.Size=UDim2.new(0,0,1,0)
        barFill.BackgroundColor3=Color3.fromRGB(255, 255, 255)
        barFill.BorderSizePixel=0
        barFill.ZIndex=5
        barFill.Parent=barBg
        corner(barFill,3)

        local curLbl=Instance.new("TextLabel")
        curLbl.Text="0:00"
        curLbl.Size=UDim2.new(0,50,0,12)
        curLbl.Position=UDim2.new(0,10,0,92)
        curLbl.BackgroundTransparency=1
        curLbl.TextColor3=Color3.fromRGB(255, 255, 255)
        curLbl.Font=Enum.Font.GothamBold
        curLbl.TextSize=10
        curLbl.TextXAlignment=Enum.TextXAlignment.Left
        curLbl.ZIndex=4
        curLbl.Parent=frame
        local totLbl=Instance.new("TextLabel")
        totLbl.Text="--:--"
        totLbl.Size=UDim2.new(0,50,0,12)
        totLbl.Position=UDim2.new(1,-60,0,92)
        totLbl.BackgroundTransparency=1
        totLbl.TextColor3=Color3.fromRGB(255, 255, 255)
        totLbl.Font=Enum.Font.GothamBold
        totLbl.TextSize=10
        totLbl.TextXAlignment=Enum.TextXAlignment.Right
        totLbl.ZIndex=4
        totLbl.Parent=frame

        local controls=Instance.new("Frame")
        controls.Size=UDim2.new(1,-20,0,32)
        controls.Position=UDim2.new(0,10,0,110)
        controls.BackgroundTransparency=1
        controls.ZIndex=4
        controls.Parent=frame

        local function smallBtn(name,text,pos,w)
            local b=Instance.new("TextButton")
            b.Name=name
            b.Text=text
            b.Size=UDim2.new(0,w or 50,0,28)
            b.Position=pos
            b.BackgroundColor3=Color3.fromRGB(0, 0, 0)
            b.TextColor3=Color3.fromRGB(255, 255, 255)
            b.Font=Enum.Font.GothamBold
            b.TextSize=11
            b.ZIndex=5
            b.Parent=controls
            corner(b,8)
            return b
        end

        local prevBtn=smallBtn("Prev","<",UDim2.new(0,0,0,0),40)
        local playBtn=smallBtn("Play","PLAY",UDim2.new(0,44,0,0),70)
        local nextBtn=smallBtn("Next",">",UDim2.new(0,118,0,0),40)
        local stopBtn=smallBtn("Stop","STOP",UDim2.new(0,162,0,0),50)
        local b10=smallBtn("B10","-10",UDim2.new(0,216,0,0),34)
        local f10=smallBtn("F10","+10",UDim2.new(1,-34,0,0),34)

        local toggleRow=Instance.new("Frame")
        toggleRow.Size=UDim2.new(1,-20,0,26)
        toggleRow.Position=UDim2.new(0,10,0,148)
        toggleRow.BackgroundTransparency=1
        toggleRow.ZIndex=4
        toggleRow.Parent=frame
        local function toggleBtn(name,text,pos)
            local b=Instance.new("TextButton")
            b.Name=name
            b.Text=text
            b.Size=UDim2.new(0,70,0,22)
            b.Position=pos
            b.BackgroundColor3=Color3.fromRGB(0, 0, 0)
            b.TextColor3=Color3.fromRGB(255, 255, 255)
            b.Font=Enum.Font.GothamBold
            b.TextSize=10
            b.ZIndex=5
            b.Parent=toggleRow
            corner(b,6)
            return b
        end
        local autoBtn=toggleBtn("Auto","AUTO",UDim2.new(0,0,0,0))
        local shuffleBtn=toggleBtn("Shuffle","SHUFFLE",UDim2.new(0,74,0,0))
        local loopBtn=toggleBtn("Loop","LOOP",UDim2.new(0,148,0,0))

        local listLabel=Instance.new("TextLabel")
        listLabel.Text="TAP SONG TO PLAY - 65 SONGS"
        listLabel.Size=UDim2.new(1,-20,0,12)
        listLabel.Position=UDim2.new(0,10,0,180)
        listLabel.BackgroundTransparency=1
        listLabel.TextColor3=Color3.fromRGB(255, 255, 255)
        listLabel.Font=Enum.Font.GothamBold
        listLabel.TextSize=9
        listLabel.TextXAlignment=Enum.TextXAlignment.Left
        listLabel.ZIndex=4
        listLabel.Parent=frame

        local scroll=Instance.new("ScrollingFrame")
        scroll.Size=UDim2.new(1,-20,0,110)
        scroll.Position=UDim2.new(0,10,0,196)
        scroll.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        scroll.BorderSizePixel=0
        scroll.ScrollBarThickness=3
        scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
        scroll.ZIndex=4
        scroll.Parent=frame
        corner(scroll,8)
        local layout=Instance.new("UIListLayout")
        layout.Padding=UDim.new(0,3)
        layout.SortOrder=Enum.SortOrder.LayoutOrder
        layout.Parent=scroll

        for i,opt in ipairs(MUSIC_PLAYER_OPTIONS) do
            local btn=Instance.new("TextButton")
            btn.Text=i..". "..opt.name
            btn.Size=UDim2.new(1,-6,0,20)
            btn.BackgroundColor3=(i==selectedMusicSong) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            btn.TextColor3=Color3.fromRGB(255, 255, 255)
            btn.Font=Enum.Font.Gotham
            btn.TextSize=10
            btn.TextXAlignment=Enum.TextXAlignment.Left
            btn.LayoutOrder=i
            btn.ZIndex=5
            btn.Parent=scroll
            corner(btn,5)
            local pad=Instance.new("UIPadding",btn) pad.PaddingLeft=UDim.new(0,6)
            btn.MouseButton1Click:Connect(function() playMusicSong(i) end)
        end

        local volFrame=Instance.new("Frame")
        volFrame.Size=UDim2.new(1,-20,0,26)
        volFrame.Position=UDim2.new(0,10,0,314)
        volFrame.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        volFrame.BorderSizePixel=0
        volFrame.ZIndex=4
        volFrame.Parent=frame
        corner(volFrame,6)
        local volLbl=Instance.new("TextLabel")
        volLbl.Text="Vol"
        volLbl.Size=UDim2.new(0,30,1,0)
        volLbl.Position=UDim2.new(0,8,0,0)
        volLbl.BackgroundTransparency=1
        volLbl.TextColor3=Color3.fromRGB(255, 255, 255)
        volLbl.Font=Enum.Font.GothamBold
        volLbl.TextSize=10
        volLbl.ZIndex=5
        volLbl.Parent=volFrame
        local volDown=Instance.new("TextButton")
        volDown.Text="<"
        volDown.Size=UDim2.new(0,24,0,18)
        volDown.Position=UDim2.new(1,-80,0.5,-9)
        volDown.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        volDown.TextColor3=Color3.fromRGB(255, 255, 255)
        volDown.Font=Enum.Font.GothamBlack
        volDown.TextSize=10
        volDown.ZIndex=6
        volDown.Parent=volFrame
        corner(volDown,4)
        local volVal=Instance.new("TextLabel")
        volVal.Text=string.format("%.2f", musicPlayerVolume)
        volVal.Size=UDim2.new(0,32,0,18)
        volVal.Position=UDim2.new(1,-52,0.5,-9)
        volVal.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        volVal.TextColor3=Color3.fromRGB(255, 255, 255)
        volVal.Font=Enum.Font.GothamBold
        volVal.TextSize=10
        volVal.ZIndex=6
        volVal.Parent=volFrame
        corner(volVal,4)
        local volUp=Instance.new("TextButton")
        volUp.Text=">"
        volUp.Size=UDim2.new(0,24,0,18)
        volUp.Position=UDim2.new(1,-18,0.5,-9)
        volUp.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        volUp.TextColor3=Color3.fromRGB(255, 255, 255)
        volUp.Font=Enum.Font.GothamBlack
        volUp.TextSize=10
        volUp.ZIndex=6
        volUp.Parent=volFrame
        corner(volUp,4)

        local spdFrame=Instance.new("Frame")
        spdFrame.Size=UDim2.new(1,-20,0,26)
        spdFrame.Position=UDim2.new(0,10,0,344)
        spdFrame.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        spdFrame.BorderSizePixel=0
        spdFrame.ZIndex=4
        spdFrame.Parent=frame
        corner(spdFrame,6)
        local spdLbl=Instance.new("TextLabel")
        spdLbl.Text="Spd"
        spdLbl.Size=UDim2.new(0,30,1,0)
        spdLbl.Position=UDim2.new(0,8,0,0)
        spdLbl.BackgroundTransparency=1
        spdLbl.TextColor3=Color3.fromRGB(255, 255, 255)
        spdLbl.Font=Enum.Font.GothamBold
        spdLbl.TextSize=10
        spdLbl.ZIndex=5
        spdLbl.Parent=spdFrame
        local spdDown=Instance.new("TextButton")
        spdDown.Text="<"
        spdDown.Size=UDim2.new(0,24,0,18)
        spdDown.Position=UDim2.new(1,-80,0.5,-9)
        spdDown.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        spdDown.TextColor3=Color3.fromRGB(255, 255, 255)
        spdDown.Font=Enum.Font.GothamBlack
        spdDown.TextSize=10
        spdDown.ZIndex=6
        spdDown.Parent=spdFrame
        corner(spdDown,4)
        local spdVal=Instance.new("TextLabel")
        spdVal.Text=string.format("%.1fx", musicPlayerSpeed)
        spdVal.Size=UDim2.new(0,32,0,18)
        spdVal.Position=UDim2.new(1,-52,0.5,-9)
        spdVal.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        spdVal.TextColor3=Color3.fromRGB(255, 255, 255)
        spdVal.Font=Enum.Font.GothamBold
        spdVal.TextSize=10
        spdVal.ZIndex=6
        spdVal.Parent=spdFrame
        corner(spdVal,4)
        local spdUp=Instance.new("TextButton")
        spdUp.Text=">"
        spdUp.Size=UDim2.new(0,24,0,18)
        spdUp.Position=UDim2.new(1,-18,0.5,-9)
        spdUp.BackgroundColor3=Color3.fromRGB(0, 0, 0)
        spdUp.TextColor3=Color3.fromRGB(255, 255, 255)
        spdUp.Font=Enum.Font.GothamBlack
        spdUp.TextSize=10
        spdUp.ZIndex=6
        spdUp.Parent=spdFrame
        corner(spdUp,4)

        local function fmt(t) t=math.max(0,math.floor(tonumber(t) or 0)) return string.format("%d:%02d", math.floor(t/60), t%60) end

        local function refresh()
            if not (mpGui and mpGui.Parent) then return end
            nameLbl.Text=getMusicSongName()
            counterLbl.Text="TRACK "..tostring(selectedMusicSong).." / "..tostring(#MUSIC_PLAYER_OPTIONS)
            volVal.Text=string.format("%.2f", musicPlayerVolume)
            spdVal.Text=string.format("%.1fx", musicPlayerSpeed)
            local s=_musicPlayerSound
            local alive=s and s.Parent
            playBtn.Text=(alive and s.IsPlaying) and "PAUSE" or "PLAY"
            if alive then
                local sp=tonumber(musicPlayerSpeed) or 1
                if sp<=0 then sp=1 end
                local len=(s.TimeLength or 0)/sp
                local pos=(s.TimePosition or 0)/sp
                if len>0 then
                    barFill.Size=UDim2.new(math.clamp(pos/len,0,1),0,1,0)
                    curLbl.Text=fmt(pos)
                    totLbl.Text=fmt(len)
                end
            else
                barFill.Size=UDim2.new(0,0,1,0)
            end
            -- toggle colors
            autoBtn.BackgroundColor3=musicAutoPlayNext and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            shuffleBtn.BackgroundColor3=musicShuffleEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            loopBtn.BackgroundColor3=musicLoopEnabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        end
        _G.K7SongsMusicRefreshUI=refresh

        prevBtn.MouseButton1Click:Connect(function() musicPrevSong() end)
        nextBtn.MouseButton1Click:Connect(function() musicNextSong() end)
        playBtn.MouseButton1Click:Connect(function() toggleMusicPause() end)
        stopBtn.MouseButton1Click:Connect(function() stopMusicPlayback(false) end)
        b10.MouseButton1Click:Connect(function() musicSeek(-10) end)
        f10.MouseButton1Click:Connect(function() musicSeek(10) end)
        autoBtn.MouseButton1Click:Connect(function() musicAutoPlayNext=not musicAutoPlayNext refresh() end)
        shuffleBtn.MouseButton1Click:Connect(function() musicShuffleEnabled=not musicShuffleEnabled if musicShuffleEnabled then musicAutoPlayNext=false end refresh() end)
        loopBtn.MouseButton1Click:Connect(function() musicLoopEnabled=not musicLoopEnabled if musicLoopEnabled then musicAutoPlayNext=false musicShuffleEnabled=false end refresh() end)
        volDown.MouseButton1Click:Connect(function() setMusicVolume(musicPlayerVolume-0.05) end)
        volUp.MouseButton1Click:Connect(function() setMusicVolume(musicPlayerVolume+0.05) end)
        spdDown.MouseButton1Click:Connect(function() setMusicSpeed(musicPlayerSpeed-0.1) end)
        spdUp.MouseButton1Click:Connect(function() setMusicSpeed(musicPlayerSpeed+0.1) end)

        refresh()
        task.spawn(function() while mpGui and mpGui.Parent do pcall(refresh) task.wait(0.2) end end)
    end


-- ═══════════════════════════════════════════════════════════
-- WHITE HUB FLOAT
-- ON  = rise + stay at height (X/Z free) until you turn it off
-- OFF = TP down; stays on ground until you turn it on again
-- ═══════════════════════════════════════════════════════════
do
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local FLOAT = {
        RISE    = 17,
        RATE    = 55,
        conn    = nil,
        running = false,
        locked  = false,
        targetY = nil,
    }

    local function getHRP()
        local c = LP.Character
        if not c then return nil, nil end
        return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
    end

    local function startLoop()
        if FLOAT.conn then return end
        FLOAT.locked = false
        FLOAT.targetY = nil
        local _, hum0 = getHRP()
        if hum0 then
            pcall(function() hum0:ChangeState(Enum.HumanoidStateType.Freefall) end)
        end
        FLOAT.conn = RunService.Heartbeat:Connect(function(dt)
            local root = getHRP()
            if not root then return end
            local pos = root.Position
            local vel = root.AssemblyLinearVelocity or root.Velocity
            local rot = root.CFrame - root.CFrame.Position
            if not FLOAT.targetY then
                FLOAT.targetY = pos.Y + FLOAT.RISE
            end
            if not FLOAT.locked then
                local nextY = math.min(pos.Y + FLOAT.RATE * dt, FLOAT.targetY)
                root.CFrame = CFrame.new(pos.X, nextY, pos.Z) * rot
                pcall(function()
                    root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
                end)
                if nextY >= FLOAT.targetY then FLOAT.locked = true end
                return
            end
            -- Hold height; free X/Z movement
            root.CFrame = CFrame.new(pos.X, FLOAT.targetY, pos.Z) * rot
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
            end)
        end)
    end

    local function stopLoop(tpDown)
        if FLOAT.conn then
            pcall(function() FLOAT.conn:Disconnect() end)
            FLOAT.conn = nil
        end
        FLOAT.locked = false
        FLOAT.targetY = nil
        if tpDown then
            if type(teleportDown) == "function" then
                pcall(teleportDown)
            else
                local root = getHRP()
                if root then
                    local cf = root.CFrame
                    pcall(function()
                        root.CFrame = CFrame.new(root.Position.X, -7, root.Position.Z)
                            * CFrame.Angles(0, select(2, cf:ToEulerAnglesYXZ()), 0)
                        root.AssemblyLinearVelocity = Vector3.zero
                    end)
                end
            end
        end
    end

    local function enable()
        if FLOAT.running then return end
        FLOAT.running = true
        startLoop()  -- rise once and stay until disable
    end

    local function disable()
        if not FLOAT.running then return end
        FLOAT.running = false
        stopLoop(true)  -- TP down; stay grounded until enable again
    end

    _G.WhiteHubFloatOn = false

    local function floatSync()
        _G.WhiteHubFloatOn = FLOAT.running == true
        if _G.WhiteHubRefreshFloatBtn then
            pcall(_G.WhiteHubRefreshFloatBtn)
        end
    end

    function _G.WhiteHubFloatStart()
        if FLOAT.running then return end
        enable()
        floatSync()
    end

    function _G.WhiteHubFloatStop()
        if not FLOAT.running then return end
        disable()
        floatSync()
    end

    function _G.WhiteHubFloatToggle()
        if FLOAT.running then
            _G.WhiteHubFloatStop()
        else
            _G.WhiteHubFloatStart()
        end
    end

    _G.WhiteHubFloat = {
        start     = function() _G.WhiteHubFloatStart() end,
        stop      = function() _G.WhiteHubFloatStop() end,
        toggle    = function() _G.WhiteHubFloatToggle() end,
        isEnabled = function() return FLOAT.running == true end,
    }

    print("[White Hub] Float feature loaded (from K7)")
end

    toggleBtn.MouseButton1Click:Connect(openMusicPlayer)

    -- ═══════════════════════════════════════════════════════════
    -- FLOATING: ANTI BAT + LOCK / UNLOCK (near SONGS)
    -- ═══════════════════════════════════════════════════════════
    local floatingLocked = false

    local function makeCornerBtn(name, text, pos, w)
        local b = Instance.new("TextButton")
        b.Name = name
        b.Size = UDim2.new(0, w or 100, 0, 32)
        b.Position = pos
        b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 11
        b.AutoButtonColor = false
        b.Parent = k7SongsGui
        corner(b, 8)
        stroke(b, Color3.fromRGB(255, 255, 255), 1, 0.2)
        return b
    end

    local ORIG_POS = {
        songs   = UDim2.new(0, 20, 0.5, -80),
        antibat = UDim2.new(0, 20, 0.5, -42),
        lock    = UDim2.new(0, 20, 0.5, -4),
        unlock  = UDim2.new(0, 72, 0.5, -4),
    }

    local antiBatBtn = makeCornerBtn("WhiteAntiBatToggle", "ANTI BAT", ORIG_POS.antibat, 100)
    local lockBtn = makeCornerBtn("WhiteFloatLock", "LOCK", ORIG_POS.lock, 48)
    local unlockBtn = makeCornerBtn("WhiteFloatUnlock", "UNLOCK", ORIG_POS.unlock, 48)

    local function setAntiBatBtnVisual(open)
        if open then
            antiBatBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            antiBatBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            antiBatBtn.Text = "ANTI ON"
        else
            antiBatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            antiBatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            antiBatBtn.Text = "ANTI BAT"
        end
    end




    local function setLockVisual(locked)
        floatingLocked = locked == true
        if floatingLocked then
            lockBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            lockBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            unlockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            unlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            lockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            unlockBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            unlockBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
    setLockVisual(false)

    local function enableDrag(btn)
        local dragging = false
        local dragStart, startPos
        btn.InputBegan:Connect(function(input)
            if floatingLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = btn.Position
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if not dragging or floatingLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    enableDrag(toggleBtn)
    enableDrag(antiBatBtn)
    enableDrag(lockBtn)
    enableDrag(unlockBtn)

    local function resetFloatingPositions()
        toggleBtn.Position = ORIG_POS.songs
        antiBatBtn.Position = ORIG_POS.antibat
        lockBtn.Position = ORIG_POS.lock
        unlockBtn.Position = ORIG_POS.unlock
    end

    antiBatBtn.MouseButton1Click:Connect(function()
        local ok, isOpen = pcall(function()
            return _G.toggleWhiteAntiBatUI and _G.toggleWhiteAntiBatUI()
        end)
        if ok then
            setAntiBatBtnVisual(isOpen == true)
        else
            pcall(function()
                if _G.openWhiteAntiBat then _G.openWhiteAntiBat(true) end
            end)
            setAntiBatBtnVisual(true)
        end
    end)


    lockBtn.MouseButton1Click:Connect(function()
        setLockVisual(true)
    end)
    unlockBtn.MouseButton1Click:Connect(function()
        setLockVisual(false)
    end)

    task.spawn(function()
        while k7SongsGui and k7SongsGui.Parent do
            local abOpen = false
            pcall(function()
                abOpen = _G.isWhiteAntiBatUIOpen and _G.isWhiteAntiBatUIOpen() or false
            end)
            setAntiBatBtnVisual(abOpen)
            task.wait(1.0)
        end
    end)

    -- Register floating buttons for background image paint
    pcall(function()
        if registerBtnForBg then
            registerBtnForBg(toggleBtn)
            registerBtnForBg(antiBatBtn)
            registerBtnForBg(lockBtn)
            registerBtnForBg(unlockBtn)
        end
        if refreshAllBtnBackgrounds then
            task.defer(refreshAllBtnBackgrounds)
        end
    end)
    print("[White Hub] Floating ANTI BAT + LOCK/UNLOCK buttons ready")

    print("[K7 SONGS] Loaded tracks + Floating buttons ready")
end)