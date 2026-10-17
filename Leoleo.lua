-- ==========================================
-- HONEY DUELS V3.4 - MODIFIED (NO AutoHit, No AutoMedusa, No Hitbox, No Booster Panel)
-- FIXED: All requested changes applied
-- ==========================================
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Rep = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local Light = game:GetService("Lighting")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local VIM = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local Stats = game:GetService("Stats")

if not getconnections then getconnections = function() return {} end end

-- ==========================================
-- CONFIG
-- ==========================================
local D = {
    esp=false,infJump=false,antiRag=false,
    autoSteal=false,stealRadius=20,unwalk=false,
    xray=false,optimizer=false,moveSpeed=false,
    moveSpeedVal=58,stealSpeed=false,stealSpeedVal=29,
    jumpBoost=false,jumpBoostVal=75,gravity=false,gravityVal=70,
    lockPlayer=false,batAimbot=false,spinbot=false,spinSpeed=30,
    lockUI=false,autoPlayUI=false,
    autoPlayV2UI=false,autoPlayV3UI=false,
    showInfoUI=false,
    keybinds={},
    panelPosX=nil,panelPosY=nil,
    infoPosX=nil,infoPosY=nil,
    autoPlaySpeed=56.2,
    jumpBoostV2Val=48,
    floatV2Val=12,
    autoPlayDirect=false,
    autoPlayV2Direct=false,
    autoPlayV3Direct=false,
    stealDuration=1.3,
    autoPlaysStealSpeed=29,
    autoLockPlayer=false,
}

local function save(d) if writefile then pcall(function() writefile("HD34.json",Http:JSONEncode(d)) end) end end
local function load()
    if readfile and isfile and isfile("HD34.json") then
        local ok,r=pcall(function() return Http:JSONDecode(readfile("HD34.json")) end)
        if ok then return r end
    end
    return D
end
local C = load()
for k,v in pairs(D) do if C[k]==nil then C[k]=v end end

-- ==========================================
-- STATE / CONNECTIONS
-- ==========================================
local conn = {}
local state = {}
state.stealing = false
state.wasMoveBefore = false
state.stealActive = false
state.stealStart = nil
state.cachedBat = nil
state.cachedBat2 = nil
state.savedAnims = {}
state.origTrans = {}
state.origLight = {}
state.espBoxes = {}
state.espBBs = {}
state.espFolder = nil
state.animals = {}
state.promptCache = {}
state.stealCache = {}
state.alignOri = nil
state.attach0 = nil
state.autoPlayOn = false
state.autoPlayPhase = 1
state.autoPlayV2On = false
state.autoPlayV2Phase = 1
state.autoPlayV3On = false
state.autoPlayV3Phase = 1
state.circleParts = {}
state.batAimbotAuto = false
state.spaceHeld = false
state.galaxyVectorForce = nil
state.galaxyAttachment = nil
state.galaxyEnabled = false
state.hopsEnabled = false
state.lastHopTime = 0
state.originalJumpPower = 50
state.originalSkybox = nil
state.galaxySkyBright = nil
state.galaxySkyBrightConn = nil
state.galaxyPlanets = {}
state.galaxyBloom = nil
state.galaxyCC = nil
state.xrayEnabled = false
state.detectedSideAP = nil
state.detectedSideAPV2 = nil
state.detectedSideAPV3 = nil
state.ppVectorForce = nil
state.ppAttachment = nil
state.ppOriginalJumpPower = 50
state.ppJumpCount = 0
state.ppIsSlowFalling = false
state.ppWasRising = false
state.ppPhysicsActive = false
state.ppPhysicsConn = nil
state.anyAutoPlayActive = false
state.savedBoosterMoveSpeed = false
state.savedBoosterStealSpeed = false
state.savedBoosterJumpBoost = false
state.savedBoosterGravity = false
state.jumpCooldown = false
state.autoLockActive = false
state.autoLockConn = nil
-- Auto Steal saved values for auto play
state.savedStealDuration = nil
state.savedStealRadius = nil

-- Auto Play coordinates
local POSITION_L1 = Vector3.new(-476.48, -6.28, 92.73)
local POSITION_L_END = Vector3.new(-483.12, -4.95, 94.80)
local POSITION_R1 = Vector3.new(-476.16, -6.52, 25.62)
local POSITION_R_END = Vector3.new(-483.04, -5.09, 23.14)

local JUMP_Z = (POSITION_L1.Z + POSITION_R1.Z) / 2
local JUMP_TRIGGER_DIST = 2.5

local RETURN_SPEED = 28
local RETURN_DELAY = 0.05
local PLUS_DELAY = 0.05
local CROSS_SPEED = 28

local DEFAULT_GRAVITY = 196.2

-- ==========================================
-- HELPERS
-- ==========================================
local function getChar() return LP.Character end
local function getHRP() local c=getChar() return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart) end
local function getHum() local c=getChar() return c and c:FindFirstChildOfClass("Humanoid") end
local function dis(k) if conn[k] then conn[k]:Disconnect() conn[k]=nil end end

local function findBat()
    local c=getChar() if not c then return nil end
    local bp=LP:FindFirstChild("Backpack")
    local SlapList = {
        "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
        "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
        "Nuclear Slap","Galaxy Slap","Glitched Slap"
    }
    local function search(p)
        if not p then return nil end
        for _,t in ipairs(p:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find("bat") then return t end
        end
        for _,name in ipairs(SlapList) do
            local t = p:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        return nil
    end
    return search(c) or search(bp)
end

local function findRemote(name)
    for _,v in ipairs(Rep:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and (v.Name==name or v.Name:find(name)) then
            return v
        end
    end
    return nil
end

local function closestPlayer(range)
    local hrp=getHRP() if not hrp then return nil,999 end
    local best,dist=nil,range or 999
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local r=p.Character:FindFirstChild("HumanoidRootPart")
            local h=p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health>0 then
                local d=(hrp.Position-r.Position).Magnitude
                if d<dist then dist=d best=p end
            end
        end
    end
    return best,dist
end

local function captureJumpPower()
    local hum = getHum()
    if hum and hum.JumpPower > 0 then
        state.originalJumpPower = hum.JumpPower
        state.ppOriginalJumpPower = hum.JumpPower
    end
end
task.spawn(function() task.wait(1) captureJumpPower() end)

-- Auto Play helpers
local function distTo(hrp, target)
    return Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z).Magnitude
end

local function moveToward(hrp, hum, target, speed)
    local dir = (target - hrp.Position)
    local moveDir = Vector3.new(dir.X, 0, dir.Z)
    if moveDir.Magnitude < 0.01 then return end
    moveDir = moveDir.Unit
    hum:Move(moveDir, false)
    hrp.AssemblyLinearVelocity = Vector3.new(moveDir.X * speed, hrp.AssemblyLinearVelocity.Y, moveDir.Z * speed)
end

local function detectSide()
    local c = getChar()
    if not c then return nil end
    local h = getHRP()
    if not h then return nil end
    if distTo(h, POSITION_L1) <= distTo(h, POSITION_R1) then
        return "left"
    else
        return "right"
    end
end

local function getStartPos(side)
    if side == "left" then return POSITION_R1 else return POSITION_L1 end
end

local function getEndPos(side)
    if side == "left" then return POSITION_R_END else return POSITION_L_END end
end

local function getOppositeStartPos(side)
    if side == "left" then return POSITION_L1 else return POSITION_R1 end
end

local function fullStop()
    local c = getChar()
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        local h = getHRP()
        if hum then hum:Move(Vector3.zero, false) end
        if h then h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0) end
    end
end

local function faceSouth()
    local c = getChar() if not c then return end
    local h = getHRP() if not h then return end
    h.CFrame = CFrame.new(h.Position) * CFrame.Angles(0, 0, 0)
    local camera = workspace.CurrentCamera
    if camera then
        local charPos = h.Position
        camera.CFrame = CFrame.new(charPos.X, charPos.Y + 5, charPos.Z - 12) * CFrame.Angles(math.rad(-15), 0, 0)
    end
end

local function faceNorth()
    local c = getChar() if not c then return end
    local h = getHRP() if not h then return end
    h.CFrame = CFrame.new(h.Position) * CFrame.Angles(0, math.rad(180), 0)
    local camera = workspace.CurrentCamera
    if camera then
        local charPos = h.Position
        camera.CFrame = CFrame.new(charPos.X, charPos.Y + 2, charPos.Z + 12) * CFrame.Angles(0, math.rad(180), 0)
    end
end

local function applyFinalFace(side)
    if side == "left" then faceNorth() else faceSouth() end
end

local function applyFinalFaceNoCamera(side)
    -- Do nothing - no camera rotation for V2 and V3
end

-- Forward declarations
local toggleMoveSpeed, toggleStealSpeed, toggleGravity, toggleJumpBoost
local startStealDetect
local toggleAutoSteal, destroyCircle, createCircle
local stealFill
local isStealingAS = false
local StealData = {}

-- ==========================================
-- BOOSTER DISABLE/RESTORE FOR AUTO PLAY
-- ==========================================
local boosterToggles = {}
local toggles = {}

local function isAnyAutoPlayActive()
    return state.autoPlayOn or state.autoPlayV2On or state.autoPlayV3On
end

local function disableBoostersDuringAutoPlay()
    if state.anyAutoPlayActive then return end
    state.anyAutoPlayActive = true
    state.savedBoosterMoveSpeed = C.moveSpeed
    state.savedBoosterStealSpeed = C.stealSpeed
    state.savedBoosterJumpBoost = C.jumpBoost
    state.savedBoosterGravity = C.gravity

    -- Save auto steal settings
    state.savedStealDuration = C.stealDuration
    state.savedStealRadius = C.stealRadius

    -- Change auto steal to fast mode
    C.stealDuration = 0.4
    C.stealRadius = 15
    save(C)

    -- Update circle if auto steal is active
    if C.autoSteal then
        destroyCircle()
        createCircle()
    end

    if C.moveSpeed then
        dis("moveSpeed")
    end
    if C.stealSpeed then
        dis("stealSpeed")
    end
    if C.gravity then
        dis("gravity")
        if state.galaxyVectorForce then
            state.galaxyVectorForce:Destroy()
            state.galaxyVectorForce = nil
        end
        if state.galaxyAttachment then
            state.galaxyAttachment:Destroy()
            state.galaxyAttachment = nil
        end
        state.galaxyEnabled = false
        state.hopsEnabled = false
    end
end

local function restoreBoostersAfterAutoPlay()
    if isAnyAutoPlayActive() then return end
    state.anyAutoPlayActive = false

    -- Restore auto steal settings
    if state.savedStealDuration ~= nil then
        C.stealDuration = state.savedStealDuration
        state.savedStealDuration = nil
    end
    if state.savedStealRadius ~= nil then
        C.stealRadius = state.savedStealRadius
        state.savedStealRadius = nil
    end
    save(C)

    -- Update circle if auto steal is active
    if C.autoSteal then
        destroyCircle()
        createCircle()
    end

    task.spawn(function()
        task.wait(0.2)
        -- Restore movement speed by actually re-toggling
        if state.savedBoosterMoveSpeed and C.moveSpeed then
            toggleMoveSpeed(true)
        end
        if state.savedBoosterGravity and C.gravity then
            toggleGravity(true)
        end
        -- Restore steal speed detect
        if C.moveSpeed or C.stealSpeed then
            startStealDetect()
        end
    end)
end

-- ==========================================
-- FEATURE FUNCTIONS
-- ==========================================

local function isPlayerStealing()
    if LP:GetAttribute("Stealing") then return true end
    local char = getChar()
    if not char then return false end
    local hrp = getHRP()
    if not hrp then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for _, podium in ipairs(podiums:GetChildren()) do
                local base = podium:FindFirstChild("Base")
                if base then
                    local spawn2 = base:FindFirstChild("Spawn")
                    if spawn2 then
                        local podiumPos = podium:GetPivot().Position
                        local dist = (hrp.Position - podiumPos).Magnitude
                        if dist < 8 then
                            local attach = spawn2:FindFirstChild("PromptAttachment")
                            if attach then
                                for _, p in ipairs(attach:GetChildren()) do
                                    if p:IsA("ProximityPrompt") and p.Enabled then return true end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return false
end

-- ==========================================
-- MOVEMENT SPEED / STEAL SPEED
-- ==========================================
local function getMovementDirection()
    local c = getChar()
    if not c then return Vector3.zero end
    local hum = c:FindFirstChildOfClass("Humanoid")
    return hum and hum.MoveDirection or Vector3.zero
end

local function onStealingStateChanged(isSt)
    if isSt then
        state.stealing = true
        if C.moveSpeed then state.wasMoveBefore = true dis("moveSpeed") end
        if C.stealSpeed and not state.anyAutoPlayActive then
            dis("stealSpeed")
            conn.stealSpeed = RS.Heartbeat:Connect(function()
                if not LP:GetAttribute("Stealing") then return end
                local hrp = getHRP()
                local hum = getHum()
                if not hrp or not hum then return end
                local md = getMovementDirection()
                if md.Magnitude > 0.1 then
                    hrp.AssemblyLinearVelocity = Vector3.new(md.X * C.stealSpeedVal, hrp.AssemblyLinearVelocity.Y, md.Z * C.stealSpeedVal)
                end
            end)
        end
    else
        state.stealing = false
        dis("stealSpeed")
        if state.wasMoveBefore then
            state.wasMoveBefore = false
            if C.moveSpeed and not state.anyAutoPlayActive then
                dis("moveSpeed")
                conn.moveSpeed = RS.Heartbeat:Connect(function()
                    local hrp = getHRP()
                    local hum = getHum()
                    if not hrp or not hum then return end
                    local md = getMovementDirection()
                    if md.Magnitude > 0.1 then
                        hrp.AssemblyLinearVelocity = Vector3.new(md.X * C.moveSpeedVal, hrp.AssemblyLinearVelocity.Y, md.Z * C.moveSpeedVal)
                    end
                end)
            end
        end
    end
end

startStealDetect = function()
    dis("stealDetect")
    pcall(function()
        LP:GetAttributeChangedSignal("Stealing"):Connect(function()
            local isSt = LP:GetAttribute("Stealing") == true
            if isSt ~= state.stealing then onStealingStateChanged(isSt) end
        end)
    end)
    conn.stealDetect = RS.Heartbeat:Connect(function()
        local nowStealing = isPlayerStealing()
        if nowStealing ~= state.stealing then onStealingStateChanged(nowStealing) end
    end)
end

toggleMoveSpeed = function(on)
    C.moveSpeed = on save(C) dis("moveSpeed")
    if on and not state.stealing and not state.anyAutoPlayActive then
        conn.moveSpeed = RS.Heartbeat:Connect(function()
            local hrp = getHRP()
            local hum = getHum()
            if not hrp or not hum then return end
            local md = getMovementDirection()
            if md.Magnitude > 0.1 then
                hrp.AssemblyLinearVelocity = Vector3.new(md.X * C.moveSpeedVal, hrp.AssemblyLinearVelocity.Y, md.Z * C.moveSpeedVal)
            end
        end)
    end
    if C.moveSpeed or C.stealSpeed then startStealDetect() end
end

toggleStealSpeed = function(on)
    C.stealSpeed = on save(C) dis("stealSpeed")
    if on and state.stealing and not state.anyAutoPlayActive then
        conn.stealSpeed = RS.Heartbeat:Connect(function()
            if not LP:GetAttribute("Stealing") then return end
            local hrp = getHRP()
            local hum = getHum()
            if not hrp or not hum then return end
            local md = getMovementDirection()
            if md.Magnitude > 0.1 then
                hrp.AssemblyLinearVelocity = Vector3.new(md.X * C.stealSpeedVal, hrp.AssemblyLinearVelocity.Y, md.Z * C.stealSpeedVal)
            end
        end)
    end
    if C.moveSpeed or C.stealSpeed then startStealDetect() end
end

-- ==========================================
-- JUMP BOOST (same logic as Booster panel in script 2)
-- ==========================================
toggleJumpBoost = function(on)
    C.jumpBoost=on save(C)
    -- Jump Boost simply stores the value; the actual boost is used
    -- by Gravity's hop logic when space is held, matching script 2 behavior
end

-- ==========================================
-- GRAVITY (same logic as Booster panel in script 2)
-- ==========================================
local function setupGravityForce()
    pcall(function()
        local c = getChar() if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart") if not h then return end
        if state.galaxyVectorForce then state.galaxyVectorForce:Destroy() end
        if state.galaxyAttachment then state.galaxyAttachment:Destroy() end
        state.galaxyAttachment = Instance.new("Attachment")
        state.galaxyAttachment.Parent = h
        state.galaxyVectorForce = Instance.new("VectorForce")
        state.galaxyVectorForce.Attachment0 = state.galaxyAttachment
        state.galaxyVectorForce.ApplyAtCenterOfMass = true
        state.galaxyVectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        state.galaxyVectorForce.Force = Vector3.new(0, 0, 0)
        state.galaxyVectorForce.Parent = h
    end)
end

local function updateGravityForce()
    if not state.galaxyEnabled or not state.galaxyVectorForce then return end
    local c = getChar() if not c then return end
    local mass = 0
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then mass = mass + p:GetMass() end
    end
    local tg = DEFAULT_GRAVITY * (C.gravityVal / 100)
    state.galaxyVectorForce.Force = Vector3.new(0, mass * (DEFAULT_GRAVITY - tg) * 0.95, 0)
end

local function adjustGravityJump()
    pcall(function()
        local hum = getHum() if not hum then return end
        if not state.galaxyEnabled then
            hum.JumpPower = state.originalJumpPower
            return
        end
        local ratio = math.sqrt((DEFAULT_GRAVITY * (C.gravityVal / 100)) / DEFAULT_GRAVITY)
        hum.JumpPower = state.originalJumpPower * ratio
    end)
end

local function doMiniHop()
    if not state.hopsEnabled then return end
    pcall(function()
        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return end
        if tick() - state.lastHopTime < 0.08 then return end
        state.lastHopTime = tick()
        if hum.FloorMaterial == Enum.Material.Air then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, C.jumpBoostVal, hrp.AssemblyLinearVelocity.Z)
        end
    end)
end

toggleGravity = function(on)
    C.gravity=on save(C) dis("gravity")
    if on and not state.anyAutoPlayActive then
        state.galaxyEnabled = true
        state.hopsEnabled = true
        setupGravityForce()
        adjustGravityJump()
        conn.gravity=RS.Heartbeat:Connect(function()
            if state.hopsEnabled and state.spaceHeld then doMiniHop() end
            if state.galaxyEnabled then updateGravityForce() end
        end)
    else
        state.galaxyEnabled = false
        state.hopsEnabled = false
        if state.galaxyVectorForce then state.galaxyVectorForce:Destroy() state.galaxyVectorForce = nil end
        if state.galaxyAttachment then state.galaxyAttachment:Destroy() state.galaxyAttachment = nil end
        adjustGravityJump()
    end
end

-- ==========================================
-- INF JUMP
-- ==========================================
local FIXED_INF_JUMP_VELOCITY = 50

local function toggleInfJump(on)
    C.infJump=on save(C) dis("infJump")
    if on then
        conn.infJump=UIS.JumpRequest:Connect(function()
            local hum,hrp=getHum(),getHRP()
            if not hum or not hrp or hum.Health<=0 then return end
            local s=hum:GetState()
            if s==Enum.HumanoidStateType.Seated or s==Enum.HumanoidStateType.Dead then return end
            hrp.AssemblyLinearVelocity=Vector3.new(hrp.AssemblyLinearVelocity.X, FIXED_INF_JUMP_VELOCITY, hrp.AssemblyLinearVelocity.Z)
        end)
    end
end

-- Space held tracking
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then state.spaceHeld = true end
end)
UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then state.spaceHeld = false end
end)

local function toggleAntiRag(on)
    C.antiRag=on save(C) dis("antiRag")
    if on then
        conn.antiRag=RS.Heartbeat:Connect(function()
            local c=getChar() if not c then return end
            local hum,hrp=getHum(),getHRP()
            if not hum or not hrp then return end
            local s=hum:GetState()
            local ragStates={[Enum.HumanoidStateType.Physics]=1,[Enum.HumanoidStateType.Ragdoll]=1,[Enum.HumanoidStateType.FallingDown]=1}
            if ragStates[s] then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum
                pcall(function()
                    local PlayerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PlayerModule then require(PlayerModule:FindFirstChild("ControlModule")):Enable() end
                end)
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
            end
            for _,d in ipairs(c:GetDescendants()) do
                if d:IsA("Motor6D") and d.Enabled == false then d.Enabled = true end
            end
            local cam=workspace.CurrentCamera
            if cam and cam.CameraSubject~=hum then cam.CameraSubject=hum end
        end)
    end
end

local function toggleSpinbot(on)
    C.spinbot=on save(C) dis("spinbot")
    local c=getChar()
    if c then
        local hrp=c:FindFirstChild("HumanoidRootPart")
        if hrp then local bav=hrp:FindFirstChild("SpinBAV") if bav then bav:Destroy() end end
    end
    if on then
        conn.spinbot=RS.Heartbeat:Connect(function()
            local hrp=getHRP() if not hrp then return end
            local bav=hrp:FindFirstChild("SpinBAV")
            if not bav then
                bav=Instance.new("BodyAngularVelocity")
                bav.Name="SpinBAV" bav.MaxTorque=Vector3.new(0,math.huge,0) bav.Parent=hrp
            end
            if LP:GetAttribute("Stealing") then
                bav.AngularVelocity=Vector3.new(0,0,0)
            else
                bav.AngularVelocity=Vector3.new(0,C.spinSpeed,0)
            end
        end)
    end
end

local function toggleUnwalk(on)
    C.unwalk=on save(C)
    local c=getChar() if not c then return end
    local hum=getHum()
    if on then
        if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
        local anim=c:FindFirstChild("Animate")
        if anim then state.savedAnims = anim:Clone() anim:Destroy() end
    else
        if state.savedAnims and typeof(state.savedAnims)=="Instance" then
            state.savedAnims:Clone().Parent = c
            state.savedAnims = nil
        end
    end
end

local function toggleXray(on)
    C.xray=on save(C)
    if on then
        for _,o in ipairs(workspace:GetDescendants()) do
            if o:IsA("BasePart") and o.Anchored and o.CanCollide then
                local n=o.Name:lower() local pn=o.Parent and o.Parent.Name:lower() or ""
                if n:find("base") or pn:find("base") or n:find("wall") or pn:find("wall") then
                    if not state.origTrans[o] then state.origTrans[o]=o.LocalTransparencyModifier end
                    o.LocalTransparencyModifier=0.85
                end
            end
        end
    else
        for p,v in pairs(state.origTrans) do if p and p.Parent then p.LocalTransparencyModifier=v end end
        state.origTrans={}
    end
end

-- ==========================================
-- OPTIMIZER
-- ==========================================
local function enableGalaxySkyBright()
    if state.galaxySkyBright then return end
    state.originalSkybox = Light:FindFirstChildOfClass("Sky")
    if state.originalSkybox then state.originalSkybox.Parent = nil end
    state.galaxySkyBright = Instance.new("Sky")
    state.galaxySkyBright.SkyboxBk = "rbxassetid://1534951537"
    state.galaxySkyBright.SkyboxDn = "rbxassetid://1534951537"
    state.galaxySkyBright.SkyboxFt = "rbxassetid://1534951537"
    state.galaxySkyBright.SkyboxLf = "rbxassetid://1534951537"
    state.galaxySkyBright.SkyboxRt = "rbxassetid://1534951537"
    state.galaxySkyBright.SkyboxUp = "rbxassetid://1534951537"
    state.galaxySkyBright.StarCount = 10000
    state.galaxySkyBright.CelestialBodiesShown = false
    state.galaxySkyBright.Parent = Light
    state.galaxyBloom = Instance.new("BloomEffect")
    state.galaxyBloom.Intensity = 1.5 state.galaxyBloom.Size = 40 state.galaxyBloom.Threshold = 0.8
    state.galaxyBloom.Parent = Light
    state.galaxyCC = Instance.new("ColorCorrectionEffect")
    state.galaxyCC.Saturation = 0.8 state.galaxyCC.Contrast = 0.3
    state.galaxyCC.TintColor = Color3.fromRGB(200, 150, 255)
    state.galaxyCC.Parent = Light
    Light.Ambient = Color3.fromRGB(120, 60, 180)
    Light.Brightness = 3 Light.ClockTime = 0
    for i = 1, 2 do
        local p = Instance.new("Part")
        p.Shape = Enum.PartType.Ball
        p.Size = Vector3.new(800 + i * 200, 800 + i * 200, 800 + i * 200)
        p.Anchored = true p.CanCollide = false p.CastShadow = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(140 + i * 20, 60 + i * 10, 200 + i * 15)
        p.Transparency = 0.3
        p.Position = Vector3.new(math.cos(i * 2) * (3000 + i * 500), 1500 + i * 300, math.sin(i * 2) * (3000 + i * 500))
        p.Parent = workspace
        table.insert(state.galaxyPlanets, p)
    end
    state.galaxySkyBrightConn = RS.Heartbeat:Connect(function()
        local t = tick() * 0.5
        Light.Ambient = Color3.fromRGB(120 + math.sin(t) * 60, 50 + math.sin(t * 0.8) * 40, 180 + math.sin(t * 1.2) * 50)
        if state.galaxyBloom then state.galaxyBloom.Intensity = 1.2 + math.sin(t * 2) * 0.4 end
    end)
end

local function disableGalaxySkyBright()
    if state.galaxySkyBrightConn then state.galaxySkyBrightConn:Disconnect() state.galaxySkyBrightConn = nil end
    if state.galaxySkyBright then state.galaxySkyBright:Destroy() state.galaxySkyBright = nil end
    if state.originalSkybox then state.originalSkybox.Parent = Light end
    if state.galaxyBloom then state.galaxyBloom:Destroy() state.galaxyBloom = nil end
    if state.galaxyCC then state.galaxyCC:Destroy() state.galaxyCC = nil end
    for _, obj in ipairs(state.galaxyPlanets) do if obj then obj:Destroy() end end
    state.galaxyPlanets = {}
    Light.Ambient = Color3.fromRGB(127, 127, 127) Light.Brightness = 2 Light.ClockTime = 14
end

local function toggleOptimizer(on)
    C.optimizer=on save(C)
    if on then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Light.GlobalShadows = false Light.Brightness = 3 Light.FogEnd = 9e9
        end)
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then obj:Destroy()
                    elseif obj:IsA("BasePart") then obj.CastShadow = false obj.Material = Enum.Material.Plastic end
                end)
            end
        end)
        state.xrayEnabled = true
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Anchored and (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                    state.origTrans[obj] = obj.LocalTransparencyModifier
                    obj.LocalTransparencyModifier = 0.85
                end
            end
        end)
        enableGalaxySkyBright()
    else
        if state.xrayEnabled then
            for part, value in pairs(state.origTrans) do if part and part.Parent then part.LocalTransparencyModifier = value end end
            state.origTrans = {} state.xrayEnabled = false
        end
        disableGalaxySkyBright()
    end
end

-- ==========================================
-- ESP
-- ==========================================
local function clearESP()
    for _,b in pairs(state.espBoxes) do if b then b:Destroy() end end
    for _,b in pairs(state.espBBs) do if b then b:Destroy() end end
    state.espBoxes={} state.espBBs={}
end

local function toggleESP(on)
    C.esp=on save(C) dis("espUpdate") dis("espAdd") dis("espRemove")
    if not on then clearESP() if state.espFolder then state.espFolder:Destroy() state.espFolder=nil end return end
    clearESP()
    state.espFolder=state.espFolder or Instance.new("Folder")
    state.espFolder.Name="HD_ESP" state.espFolder.Parent=CoreGui
    local yellow=Color3.fromRGB(255,200,50)
    local function makeESP(p)
        if p==LP then return end
        local c=p.Character if not c then return end
        local hrp=c:FindFirstChild("HumanoidRootPart") if not hrp then return end
        if state.espBoxes[p.Name] then state.espBoxes[p.Name]:Destroy() end
        if state.espBBs[p.Name] then state.espBBs[p.Name]:Destroy() end
        local box=Instance.new("BoxHandleAdornment")
        box.Adornee=hrp box.AlwaysOnTop=true box.ZIndex=5 box.Size=Vector3.new(4,6,4)
        box.Color3=yellow box.Transparency=0.7 box.Parent=state.espFolder
        local bb=Instance.new("BillboardGui")
        bb.Adornee=hrp bb.Size=UDim2.new(0,200,0,50) bb.StudsOffset=Vector3.new(0,3.5,0)
        bb.AlwaysOnTop=true bb.MaxDistance=1000 bb.Parent=state.espFolder
        local nl=Instance.new("TextLabel",bb)
        nl.Size=UDim2.new(1,0,0.5,0) nl.BackgroundTransparency=1 nl.Text=p.Name
        nl.TextColor3=Color3.new(1,1,1) nl.TextStrokeTransparency=0 nl.TextSize=14 nl.Font=Enum.Font.FredokaOne
        local dl=Instance.new("TextLabel",bb)
        dl.Name="D" dl.Size=UDim2.new(1,0,0.5,0) dl.Position=UDim2.new(0,0,0.5,0)
        dl.BackgroundTransparency=1 dl.Text="0" dl.TextColor3=Color3.new(1,1,1)
        dl.TextStrokeTransparency=0 dl.TextSize=12 dl.Font=Enum.Font.FredokaOne
        state.espBoxes[p.Name]=box state.espBBs[p.Name]=bb
    end
    for _,p in ipairs(Players:GetPlayers()) do makeESP(p) end
    conn.espAdd=Players.PlayerAdded:Connect(makeESP)
    conn.espRemove=Players.PlayerRemoving:Connect(function(p)
        if state.espBoxes[p.Name] then state.espBoxes[p.Name]:Destroy() state.espBoxes[p.Name]=nil end
        if state.espBBs[p.Name] then state.espBBs[p.Name]:Destroy() state.espBBs[p.Name]=nil end
    end)
    conn.espUpdate=RS.RenderStepped:Connect(function()
        local lhrp=getHRP()
        for _,p in ipairs(Players:GetPlayers()) do
            if p==LP then continue end
            local c=p.Character if not c then continue end
            local r=c:FindFirstChild("HumanoidRootPart") if not r then continue end
            if not state.espBoxes[p.Name] then makeESP(p) end
            local box=state.espBoxes[p.Name]
            local bb=state.espBBs[p.Name]
            if box then box.Adornee=r end
            if bb then bb.Adornee=r
                if lhrp then local dl=bb:FindFirstChild("D")
                    if dl then dl.Text=math.floor((r.Position-lhrp.Position).Magnitude).." studs" end
                end
            end
        end
    end)
end

-- ==========================================
-- BAT AIMBOT
-- ==========================================
local function stopBatAimbot()
    dis("batAimbot")
    if state.alignOri then state.alignOri:Destroy() state.alignOri=nil end
    if state.attach0 then state.attach0:Destroy() state.attach0=nil end
    local hum=getHum() if hum then hum.AutoRotate=true end
end

local function toggleBatAimbot(on)
    C.batAimbot=on save(C)
    if not on then stopBatAimbot() return end
    local hrp=getHRP() local hum=getHum()
    if not hrp or not hum then return end
    hum.AutoRotate=false
    state.attach0=Instance.new("Attachment",hrp)
    state.alignOri=Instance.new("AlignOrientation")
    state.alignOri.Attachment0=state.attach0
    state.alignOri.Mode=Enum.OrientationAlignmentMode.OneAttachment
    state.alignOri.RigidityEnabled=true state.alignOri.MaxTorque=math.huge
    state.alignOri.Responsiveness=200 state.alignOri.Parent=hrp
    conn.batAimbot=RS.RenderStepped:Connect(function()
        local target
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local r=p.Character:FindFirstChild("HumanoidRootPart")
                local h=p.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health>0 then
                    local d=(r.Position-hrp.Position).Magnitude
                    if d<=40 then target=r break end
                end
            end
        end
        if target then
            state.alignOri.CFrame=CFrame.lookAt(hrp.Position,Vector3.new(target.Position.X,hrp.Position.Y,target.Position.Z))
        end
    end)
end

-- ==========================================
-- LOCK PLAYER (ALWAYS IN FRONT of target)
-- ==========================================
local function toggleLockPlayer(on)
    C.lockPlayer=on save(C) dis("lockPlayer")
    if not on then state.cachedBat2=nil return end
    local lastHit=0
    local BAT_SWING_COOLDOWN = 0.12
    local lastTargetVY = nil
    local myLastJumpTime = 0

    conn.lockPlayer=RS.Heartbeat:Connect(function()
        local hrp=getHRP() local hum=getHum()
        if not hrp or not hum then return end

        local target, targetTorso, dist = nil, nil, math.huge
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                local r=p.Character:FindFirstChild("HumanoidRootPart")
                local torso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso")
                local h=p.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health>0 then
                    local d=(hrp.Position-r.Position).Magnitude
                    if d<dist then dist=d target=r targetTorso=torso or r end
                end
            end
        end
        if not target or not targetTorso then return end

        local bat = findBat()
        if bat then
            local c = getChar()
            if bat.Parent ~= c then hum:EquipTool(bat) end
        end

        local targetHum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
        local targetVY = target.AssemblyLinearVelocity.Y
        local targetY = target.Position.Y
        local myY = hrp.Position.Y
        local yDiff = targetY - myY

        local targetLook = target.CFrame.LookVector
        local targetFlatLook = Vector3.new(targetLook.X, 0, targetLook.Z)
        if targetFlatLook.Magnitude < 0.01 then
            targetFlatLook = Vector3.new(0, 0, -1)
        else
            targetFlatLook = targetFlatLook.Unit
        end

        local desiredFrontDist = 2.5
        local frontPos = target.Position + targetFlatLook * desiredFrontDist

        local toMe = (hrp.Position - target.Position)
        local toMeFlat = Vector3.new(toMe.X, 0, toMe.Z)
        if toMeFlat.Magnitude > 0.1 then
            toMeFlat = toMeFlat.Unit
        end
        local dotProduct = toMeFlat:Dot(targetFlatLook)

        local dir = (frontPos - hrp.Position)
        local flatDir = Vector3.new(dir.X, 0, dir.Z)
        local flatDist = flatDir.Magnitude
        local spd = 55

        if dotProduct < -0.2 then
            local rightVec = Vector3.new(targetFlatLook.Z, 0, -targetFlatLook.X)
            local sideCheck = toMeFlat:Dot(rightVec)
            local sideDir = sideCheck >= 0 and rightVec or -rightVec
            local circleTarget = target.Position + targetFlatLook * desiredFrontDist + sideDir * 4
            local circleDir = (circleTarget - hrp.Position)
            local circleFlat = Vector3.new(circleDir.X, 0, circleDir.Z)
            if circleFlat.Magnitude > 0.1 then
                circleFlat = circleFlat.Unit
            end
            local circleSpeed = 65
            hrp.AssemblyLinearVelocity = Vector3.new(circleFlat.X * circleSpeed, hrp.AssemblyLinearVelocity.Y, circleFlat.Z * circleSpeed)
        elseif flatDist > 0.8 then
            local md = flatDir.Unit
            local dynamicSpeed = math.clamp(flatDist * 8, 20, spd)
            hrp.AssemblyLinearVelocity = Vector3.new(md.X * dynamicSpeed, hrp.AssemblyLinearVelocity.Y, md.Z * dynamicSpeed)
        else
            local tv = target.AssemblyLinearVelocity
            local targetMoveDir = Vector3.new(tv.X, 0, tv.Z)
            if targetMoveDir.Magnitude > 1 then
                local predictOffset = targetFlatLook * 2
                local predictPos = target.Position + predictOffset
                local toPredicted = (predictPos - hrp.Position)
                local flatToPredicted = Vector3.new(toPredicted.X, 0, toPredicted.Z)
                if flatToPredicted.Magnitude > 0.5 then
                    local corrDir = flatToPredicted.Unit
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        tv.X + corrDir.X * 10,
                        hrp.AssemblyLinearVelocity.Y,
                        tv.Z + corrDir.Z * 10
                    )
                else
                    hrp.AssemblyLinearVelocity = Vector3.new(tv.X, hrp.AssemblyLinearVelocity.Y, tv.Z)
                end
            else
                hrp.AssemblyLinearVelocity = Vector3.new(tv.X, hrp.AssemblyLinearVelocity.Y, tv.Z)
            end
        end

        if targetHum then
            local ts = targetHum:GetState()
            local now = tick()

            local isTargetJumping = false
            local isTargetRising = targetVY > 3

            if lastTargetVY and lastTargetVY <= 2 and targetVY > 5 then
                isTargetJumping = true
            end

            if ts == Enum.HumanoidStateType.Jumping then
                isTargetJumping = true
            end

            if (isTargetJumping or isTargetRising) and now - myLastJumpTime > 0.15 then
                local ms = hum:GetState()
                if ms == Enum.HumanoidStateType.Running or ms == Enum.HumanoidStateType.Landed then
                    local jumpVel = math.max(targetVY, 45)
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, jumpVel, hrp.AssemblyLinearVelocity.Z)
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    myLastJumpTime = now
                end
            end

            if yDiff > 1.5 and flatDist < 15 then
                local ms = hum:GetState()
                if ms == Enum.HumanoidStateType.Freefall or ms == Enum.HumanoidStateType.Jumping then
                    local neededVY = math.sqrt(2 * 196.2 * math.min(yDiff, 8))
                    local currentVY = hrp.AssemblyLinearVelocity.Y
                    if currentVY < neededVY then
                        hrp.AssemblyLinearVelocity = Vector3.new(
                            hrp.AssemblyLinearVelocity.X,
                            math.min(neededVY, 60),
                            hrp.AssemblyLinearVelocity.Z
                        )
                    end
                elseif ms == Enum.HumanoidStateType.Running or ms == Enum.HumanoidStateType.Landed then
                    if now - myLastJumpTime > 0.2 then
                        local jumpVel = math.min(math.sqrt(2 * 196.2 * yDiff) * 1.1, 65)
                        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, jumpVel, hrp.AssemblyLinearVelocity.Z)
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                        myLastJumpTime = now
                    end
                end
            end

            if yDiff < -2 and not (ts == Enum.HumanoidStateType.Running or ts == Enum.HumanoidStateType.Landed) then
                local currentVY = hrp.AssemblyLinearVelocity.Y
                if currentVY > 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        hrp.AssemblyLinearVelocity.X,
                        currentVY * 0.3,
                        hrp.AssemblyLinearVelocity.Z
                    )
                end
            end

            lastTargetVY = targetVY
        end

        local actualDist = (hrp.Position - target.Position).Magnitude
        local now=tick()
        if actualDist<=8 and now-lastHit>BAT_SWING_COOLDOWN then
            if bat and bat.Parent==getChar() then
                bat:Activate()
                lastHit=now
            end
        end
    end)
end

-- ==========================================
-- AUTO LOCK PLAYER
-- ==========================================
local function isEnemyStealingFromMe()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local isMyPlot = false
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then isMyPlot = yb.Enabled end
        end
        if not isMyPlot then continue end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                if p:GetAttribute("Stealing") then
                    return true
                end
            end
        end
    end
    return false
end

local function toggleAutoLockPlayer(on)
    C.autoLockPlayer = on save(C) dis("autoLockPlayer")
    if not on then
        return
    end
    local wasLocked = false
    conn.autoLockPlayer = RS.Heartbeat:Connect(function()
        if not C.autoLockPlayer then return end
        local iAmStealing = isPlayerStealing()
        local enemyStealing = isEnemyStealingFromMe()

        if not iAmStealing and enemyStealing then
            if not C.lockPlayer then
                C.lockPlayer = true
                toggleLockPlayer(true)
                wasLocked = true
                local tog = toggles["Lock Player"]
                if tog then tog.SetState(true) end
            end
        else
            if wasLocked and C.lockPlayer then
                C.lockPlayer = false
                toggleLockPlayer(false)
                wasLocked = false
                local tog = toggles["Lock Player"]
                if tog then tog.SetState(false) end
            end
        end
    end)
end

-- ==========================================
-- AUTO STEAL
-- ==========================================
stealFill=nil

local function getStealDuration()
    return C.stealDuration or 1.3
end

destroyCircle = function()
    for _,p in ipairs(state.circleParts) do if p and p.Parent then p:Destroy() end end
    state.circleParts={}
    pcall(function() RS:UnbindFromRenderStep("ASCircle") end)
end

createCircle = function()
    destroyCircle()
    local hrp=getHRP() if not hrp then return end
    local SEG=64 local R=C.stealRadius
    local pts={}
    for i=0,SEG-1 do
        local a=math.rad(i*360/SEG)
        pts[i+1]=Vector3.new(math.cos(a),0,math.sin(a))*R
    end
    for i=1,#pts do
        local ni=i%#pts+1
        local p1,p2=pts[i],pts[ni]
        local part=Instance.new("Part")
        part.Anchored=true part.CanCollide=false
        part.Size=Vector3.new((p2-p1).Magnitude,0.15,0.25)
        part.Color=Color3.fromRGB(255,200,50) part.Material=Enum.Material.Neon
        part.Transparency=0.25 part.CastShadow=false part.Parent=workspace
        state.circleParts[i]=part
    end
    RS:BindToRenderStep("ASCircle",Enum.RenderPriority.Camera.Value+1,function()
        local r=getHRP() if not r then return end
        local p2={}
        for i=0,SEG-1 do local a=math.rad(i*360/SEG) p2[i+1]=Vector3.new(math.cos(a),0,math.sin(a))*R end
        for idx,p in ipairs(state.circleParts) do
            if p and p.Parent then
                local ni=idx%#p2+1
                local a,b=p2[idx],p2[ni]
                local c=(a+b)/2+Vector3.new(r.Position.X,r.Position.Y-2.8,r.Position.Z)
                p.Size=Vector3.new((b-a).Magnitude,0.15,0.25)
                p.CFrame=CFrame.new(c,c+Vector3.new(b.X-a.X,0,b.Z-a.Z))*CFrame.Angles(0,math.pi/2,0)
            end
        end
    end)
end

local function isMyBase(pn)
    local plot=workspace:FindFirstChild("Plots") and workspace.Plots:FindFirstChild(pn)
    if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled end
    end
    return false
end

local function ResetProgressBar()
    if stealFill then stealFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function findNearestPrompt()
    local h = getHRP() if not h then return nil, math.huge, nil end
    local plots = workspace:FindFirstChild("Plots") if not plots then return nil, math.huge, nil end
    local np, nd, nn = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyBase(plot.Name) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then continue end
        for _, pod in ipairs(podiums:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn2 = base and base:FindFirstChild("Spawn")
                if spawn2 then
                    local dist = (spawn2.Position - h.Position).Magnitude
                    if dist < nd and dist <= C.stealRadius then
                        local att = spawn2:FindFirstChild("PromptAttachment")
                        if att then
                            for _, ch in ipairs(att:GetChildren()) do
                                if ch:IsA("ProximityPrompt") then
                                    np, nd, nn = ch, dist, pod.Name break
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
    if isStealingAS then return end
    if not StealData[prompt] then
        StealData[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(StealData[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(StealData[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = StealData[prompt]
    if not data.ready then return end
    data.ready = false
    isStealingAS = true
    state.stealActive = true
    state.stealStart = tick()
    local STEAL_DUR = getStealDuration()
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local el = 0
        while el < STEAL_DUR and state.stealActive do
            task.wait(0.03)
            el = tick() - state.stealStart
            if stealFill then
                local pct = math.min(el / STEAL_DUR, 1)
                TS:Create(stealFill, TweenInfo.new(0.1, Enum.EasingStyle.Linear), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
            end
        end
        for _, f in ipairs(data.trigger) do task.spawn(f) end
        if stealFill then TS:Create(stealFill, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 1, 0)}):Play() end
        task.wait(0.2)
        isStealingAS = false
        state.stealActive = false
        state.stealStart = nil
        data.ready = true
        task.wait(0.15)
        if stealFill and not state.stealActive then stealFill.Size = UDim2.new(0, 0, 1, 0) end
    end)
end

toggleAutoSteal = function(on)
    C.autoSteal=on save(C) dis("autoSteal")
    if not on then
        isStealingAS = false
        state.stealActive=false state.stealStart=nil
        destroyCircle() StealData={}
        ResetProgressBar()
        return
    end
    createCircle()
    conn.autoSteal=RS.Heartbeat:Connect(function()
        if isStealingAS then return end
        local p, _, n = findNearestPrompt()
        if p then executeSteal(p, n) else ResetProgressBar() end
    end)
end

-- ==========================================
-- AUTO PLAY V3 PHYSICS
-- ==========================================
local function setupPPGravityForce()
    pcall(function()
        local c = getChar() if not c then return end
        local h = getHRP() if not h then return end
        if state.ppVectorForce then state.ppVectorForce:Destroy() end
        if state.ppAttachment then state.ppAttachment:Destroy() end
        state.ppAttachment = Instance.new("Attachment")
        state.ppAttachment.Name = "PPGravAttach"
        state.ppAttachment.Parent = h
        state.ppVectorForce = Instance.new("VectorForce")
        state.ppVectorForce.Name = "PPGravForce"
        state.ppVectorForce.Attachment0 = state.ppAttachment
        state.ppVectorForce.ApplyAtCenterOfMass = true
        state.ppVectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        state.ppVectorForce.Force = Vector3.new(0, 0, 0)
        state.ppVectorForce.Parent = h
    end)
end

local function updatePPSlowFallForce()
    if not state.ppVectorForce then return end
    local c = getChar() if not c then return end
    local mass = 0
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then mass = mass + p:GetMass() end
    end
    local targetGravity = DEFAULT_GRAVITY * (C.floatV2Val / 100)
    state.ppVectorForce.Force = Vector3.new(0, mass * (DEFAULT_GRAVITY - targetGravity) * 0.95, 0)
end

local function clearPPGravityForce()
    if state.ppVectorForce then state.ppVectorForce:Destroy() state.ppVectorForce = nil end
    if state.ppAttachment then state.ppAttachment:Destroy() state.ppAttachment = nil end
end

local function startPPPhysics()
    state.ppPhysicsActive = true
    state.ppJumpCount = 0
    state.ppIsSlowFalling = false
    state.ppWasRising = false
    captureJumpPower()
    setupPPGravityForce()

    local didFirstJump = false
    local didSecondJump = false
    local waitingForLand1 = false

    if state.ppPhysicsConn then state.ppPhysicsConn:Disconnect() end
    state.ppPhysicsConn = RS.Heartbeat:Connect(function()
        if not state.ppPhysicsActive then return end
        local c = getChar() if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local hrp = getHRP()
        if not hum or not hrp then return end

        local vy = hrp.AssemblyLinearVelocity.Y
        local humState = hum:GetState()
        local onGround = (humState == Enum.HumanoidStateType.Running or humState == Enum.HumanoidStateType.Landed)

        if state.ppJumpCount == 0 and not didFirstJump then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, C.jumpBoostVal, hrp.AssemblyLinearVelocity.Z)
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
            didFirstJump = true
            state.ppJumpCount = 1
            waitingForLand1 = true
            state.ppWasRising = true
            return
        end

        if state.ppJumpCount == 1 and waitingForLand1 then
            if onGround and didFirstJump then
                waitingForLand1 = false
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, C.jumpBoostV2Val, hrp.AssemblyLinearVelocity.Z)
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                didSecondJump = true
                state.ppJumpCount = 2
                state.ppWasRising = true
                state.ppIsSlowFalling = false
            end
            return
        end

        if state.ppJumpCount == 2 and didSecondJump then
            if vy > 1 then state.ppWasRising = true end
            if state.ppWasRising and vy <= 0 and not state.ppIsSlowFalling then
                state.ppIsSlowFalling = true
            end
            if state.ppIsSlowFalling then
                updatePPSlowFallForce()
                if vy < -3 then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -3, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end
    end)
end

local function stopPPPhysics()
    state.ppPhysicsActive = false
    state.ppIsSlowFalling = false
    state.ppJumpCount = 0
    state.ppWasRising = false
    if state.ppPhysicsConn then state.ppPhysicsConn:Disconnect() state.ppPhysicsConn = nil end
    clearPPGravityForce()
    pcall(function()
        local c = getChar()
        if c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = state.ppOriginalJumpPower end
        end
    end)
end

-- ==========================================
-- AUTO PLAYS SPEED (for all auto plays)
-- Priority: Auto Plays Speed has priority, but when stealing Auto Plays Steal Speed has priority
-- ==========================================
local function startAutoPlaysSpeed()
    dis("autoPlaysSpeed")
    dis("autoPlaysStealSpeed")

    conn.autoPlaysSpeed = RS.Heartbeat:Connect(function()
        if not state.anyAutoPlayActive then return end
        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return end
        local md = getMovementDirection()
        if md.Magnitude < 0.1 then return end

        local isStealing = LP:GetAttribute("Stealing") == true

        if isStealing then
            -- When stealing, Auto Plays Steal Speed has priority
            hrp.AssemblyLinearVelocity = Vector3.new(md.X * C.autoPlaysStealSpeed, hrp.AssemblyLinearVelocity.Y, md.Z * C.autoPlaysStealSpeed)
        else
            -- When not stealing, Auto Plays Speed has priority (handled by moveToward in phases)
            -- This connection only overrides manual movement during auto play
        end
    end)
end

local function stopAutoPlaysSpeed()
    dis("autoPlaysSpeed")
    dis("autoPlaysStealSpeed")
end

-- ==========================================
-- AUTO PLAY (with camera rotation)
-- ==========================================
local function startAutoPlay()
    -- Ensure only one auto play at a time
    if state.autoPlayV2On then
        state.autoPlayV2On = false
        dis("autoPlayV2")
        state.autoPlayV2Phase = 1
    end
    if state.autoPlayV3On then
        state.autoPlayV3On = false
        dis("autoPlayV3")
        state.autoPlayV3Phase = 1
        stopPPPhysics()
    end

    dis("autoPlay")
    state.autoPlayPhase = 1
    state.autoPlayOn = true
    state.jumpCooldown = false
    state.detectedSideAP = detectSide()
    if not state.detectedSideAP then state.autoPlayOn = false return end

    disableBoostersDuringAutoPlay()
    startAutoPlaysSpeed()

    local startPos = getStartPos(state.detectedSideAP)
    local endPos = getEndPos(state.detectedSideAP)

    conn.autoPlay = RS.Heartbeat:Connect(function()
        if not state.autoPlayOn then return end
        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return end

        if state.autoPlayPhase == 1 then
            if distTo(hrp, startPos) < 1 then state.autoPlayPhase = 2 return end
            moveToward(hrp, hum, startPos, C.autoPlaySpeed)
        elseif state.autoPlayPhase == 2 then
            if distTo(hrp, endPos) < 1 then
                fullStop()
                state.autoPlayPhase = 3
                task.spawn(function()
                    task.wait(PLUS_DELAY)
                    if state.autoPlayOn then state.autoPlayPhase = 4 end
                end)
                return
            end
            moveToward(hrp, hum, endPos, C.autoPlaySpeed)
        elseif state.autoPlayPhase == 3 then
            return
        elseif state.autoPlayPhase == 4 then
            if distTo(hrp, startPos) < 1 then
                fullStop()
                state.autoPlayOn = false
                dis("autoPlay")
                stopAutoPlaysSpeed()
                applyFinalFace(state.detectedSideAP)
                restoreBoostersAfterAutoPlay()
                return
            end
            moveToward(hrp, hum, startPos, RETURN_SPEED)
        end
    end)
end

local function stopAutoPlay()
    state.autoPlayOn = false
    dis("autoPlay")
    state.autoPlayPhase = 1
    state.jumpCooldown = false
    stopAutoPlaysSpeed()
    fullStop()
    restoreBoostersAfterAutoPlay()
end

-- ==========================================
-- AUTO PLAY V2
-- ==========================================
local function startAutoPlayV2()
    -- Ensure only one auto play at a time
    if state.autoPlayOn then
        state.autoPlayOn = false
        dis("autoPlay")
        state.autoPlayPhase = 1
    end
    if state.autoPlayV3On then
        state.autoPlayV3On = false
        dis("autoPlayV3")
        state.autoPlayV3Phase = 1
        stopPPPhysics()
    end

    dis("autoPlayV2")
    state.autoPlayV2Phase = 1
    state.autoPlayV2On = true
    state.jumpCooldown = false
    state.detectedSideAPV2 = detectSide()
    if not state.detectedSideAPV2 then state.autoPlayV2On = false return end

    disableBoostersDuringAutoPlay()
    startAutoPlaysSpeed()

    local startPos = getStartPos(state.detectedSideAPV2)
    local endPos = getEndPos(state.detectedSideAPV2)
    local oppositePos = getOppositeStartPos(state.detectedSideAPV2)

    conn.autoPlayV2 = RS.Heartbeat:Connect(function()
        if not state.autoPlayV2On then return end
        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return end

        if state.autoPlayV2Phase == 1 then
            if distTo(hrp, startPos) < 1 then state.autoPlayV2Phase = 2 return end
            moveToward(hrp, hum, startPos, C.autoPlaySpeed)
        elseif state.autoPlayV2Phase == 2 then
            if distTo(hrp, endPos) < 1 then
                fullStop()
                state.autoPlayV2Phase = 3
                task.spawn(function()
                    task.wait(PLUS_DELAY)
                    if state.autoPlayV2On then state.autoPlayV2Phase = 4 end
                end)
                return
            end
            moveToward(hrp, hum, endPos, C.autoPlaySpeed)
        elseif state.autoPlayV2Phase == 3 then
            return
        elseif state.autoPlayV2Phase == 4 then
            if distTo(hrp, startPos) < 1 then state.autoPlayV2Phase = 5 return end
            moveToward(hrp, hum, startPos, RETURN_SPEED)
        elseif state.autoPlayV2Phase == 5 then
            -- Last leg: use Auto Plays Steal Speed for the cross speed
            if distTo(hrp, oppositePos) < 1 then
                fullStop()
                state.autoPlayV2On = false
                dis("autoPlayV2")
                stopAutoPlaysSpeed()
                applyFinalFaceNoCamera(state.detectedSideAPV2)
                restoreBoostersAfterAutoPlay()
                return
            end
            moveToward(hrp, hum, oppositePos, C.autoPlaysStealSpeed)
        end
    end)
end

local function stopAutoPlayV2()
    state.autoPlayV2On = false
    dis("autoPlayV2")
    state.autoPlayV2Phase = 1
    state.jumpCooldown = false
    stopAutoPlaysSpeed()
    fullStop()
    restoreBoostersAfterAutoPlay()
end

-- ==========================================
-- AUTO PLAY V3
-- ==========================================
local function startAutoPlayV3()
    -- Ensure only one auto play at a time
    if state.autoPlayOn then
        state.autoPlayOn = false
        dis("autoPlay")
        state.autoPlayPhase = 1
    end
    if state.autoPlayV2On then
        state.autoPlayV2On = false
        dis("autoPlayV2")
        state.autoPlayV2Phase = 1
    end

    dis("autoPlayV3")
    state.autoPlayV3Phase = 1
    state.autoPlayV3On = true
    state.jumpCooldown = false
    state.detectedSideAPV3 = detectSide()
    if not state.detectedSideAPV3 then state.autoPlayV3On = false return end

    disableBoostersDuringAutoPlay()
    startAutoPlaysSpeed()

    local startPos = getStartPos(state.detectedSideAPV3)
    local endPos = getEndPos(state.detectedSideAPV3)
    local oppositePos = getOppositeStartPos(state.detectedSideAPV3)

    conn.autoPlayV3 = RS.Heartbeat:Connect(function()
        if not state.autoPlayV3On then return end
        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return end

        if state.autoPlayV3Phase == 1 then
            if distTo(hrp, startPos) < 1 then state.autoPlayV3Phase = 2 return end
            moveToward(hrp, hum, startPos, C.autoPlaySpeed)
        elseif state.autoPlayV3Phase == 2 then
            if distTo(hrp, endPos) < 1 then
                fullStop()
                state.autoPlayV3Phase = 3
                task.spawn(function()
                    task.wait(PLUS_DELAY)
                    if state.autoPlayV3On then state.autoPlayV3Phase = 4 end
                end)
                return
            end
            moveToward(hrp, hum, endPos, C.autoPlaySpeed)
        elseif state.autoPlayV3Phase == 3 then
            return
        elseif state.autoPlayV3Phase == 4 then
            if distTo(hrp, startPos) < 1 then
                state.autoPlayV3Phase = 5
                startPPPhysics()
                return
            end
            moveToward(hrp, hum, startPos, RETURN_SPEED)
        elseif state.autoPlayV3Phase == 5 then
            -- Last leg: use Auto Plays Steal Speed for the cross speed
            if distTo(hrp, oppositePos) < 1 then
                fullStop()
                stopPPPhysics()
                state.autoPlayV3On = false
                dis("autoPlayV3")
                stopAutoPlaysSpeed()
                applyFinalFaceNoCamera(state.detectedSideAPV3)
                restoreBoostersAfterAutoPlay()
                return
            end
            moveToward(hrp, hum, oppositePos, C.autoPlaysStealSpeed)
        end
    end)
end

local function stopAutoPlayV3()
    state.autoPlayV3On = false
    dis("autoPlayV3")
    state.autoPlayV3Phase = 1
    state.jumpCooldown = false
    stopPPPhysics()
    stopAutoPlaysSpeed()
    fullStop()
    restoreBoostersAfterAutoPlay()
end

-- ==========================================
-- V3.4 BEAUTIFUL UI SYSTEM
-- ==========================================
local SG=Instance.new("ScreenGui")
SG.Name="HD34" SG.ResetOnSpawn=false SG.DisplayOrder=1000 SG.Parent=PG

local isMob=UIS.TouchEnabled and not UIS.KeyboardEnabled
local mobScale = isMob and 0.54 or 1

local Theme = {
    Primary = Color3.fromRGB(255, 200, 50),
    Secondary = Color3.fromRGB(255, 180, 30),
    Accent = Color3.fromRGB(255, 230, 100),
    Background = Color3.fromRGB(8, 7, 6),
    Background2 = Color3.fromRGB(18, 16, 13),
    Background3 = Color3.fromRGB(28, 25, 20),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 190, 180),
    Success = Color3.fromRGB(100, 255, 150),
    Danger = Color3.fromRGB(255, 100, 100),
    ToggleOn = Color3.fromRGB(255, 200, 50),
    ToggleOff = Color3.fromRGB(45, 42, 38),
    ToggleOffBg = Color3.fromRGB(25, 23, 20),
    SliderFill = Color3.fromRGB(255, 200, 50),
    DotColor = Color3.fromRGB(255, 200, 50),
    Keybind = Color3.fromRGB(255, 230, 100),
    Glow = Color3.fromRGB(255, 220, 80),
}

local activeGradients = {}
local animationAngle = 0
local floatingDots = {}

local function registerGradient(gradient)
    table.insert(activeGradients, gradient)
end

local gradientCounter = 0
RS.Heartbeat:Connect(function(dt)
    gradientCounter = gradientCounter + 1
    if gradientCounter % 3 ~= 0 then return end
    animationAngle = (animationAngle + (dt * 120 * 3)) % 360
    for i = #activeGradients, 1, -1 do
        local grad = activeGradients[i]
        if grad and grad.Parent then grad.Rotation = animationAngle
        else table.remove(activeGradients, i) end
    end
    for i, dot in ipairs(floatingDots) do
        if dot and dot.Parent then
            local baseY = dot:GetAttribute("BaseY") or 0
            local offset = math.sin(tick() * 2 + i) * 3
            dot.Position = UDim2.new(dot.Position.X.Scale, dot.Position.X.Offset, 0, baseY + offset)
        end
    end
end)

local function createAnimatedYellowText(textLabel)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = textLabel
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 100)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 120)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 180, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 100))
    })
    registerGradient(gradient)
    return gradient
end

local function createAnimatedGreenText(textLabel)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = textLabel
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 255, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 255, 100))
    })
    registerGradient(gradient)
    return gradient
end

local function createAnimatedRedText(textLabel)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = textLabel
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 80))
    })
    registerGradient(gradient)
    return gradient
end

local function addAnimatedYellowStroke(frame, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 200, 50)
    stroke.Thickness = thickness or 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    local gradient = Instance.new("UIGradient")
    gradient.Parent = stroke
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 100)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 240, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 100))
    })
    registerGradient(gradient)
    return stroke
end

local function createFloatingDots(parent, count)
    for i = 1, count do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
        local xPos = math.random(10, 90) / 100
        local yPos = math.random(10, 90)
        dot.Position = UDim2.new(xPos, 0, 0, yPos)
        dot.BackgroundColor3 = Theme.DotColor
        dot.BackgroundTransparency = math.random(30, 70) / 100
        dot.Parent = parent
        dot:SetAttribute("BaseY", yPos)
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        table.insert(floatingDots, dot)
    end
end

local function makeDraggable(frame, saveKey)
    local dragging, dragStart, startPos = false, nil, nil
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if saveKey then
                        C[saveKey.."X"] = frame.Position.X.Scale
                        C[saveKey.."Y"] = frame.Position.Y.Scale
                        save(C)
                    end
                end
            end)
        end
    end)
    local dragInput
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Keybind system
local keybinds = {}
if C.keybinds then
    for feature, stored in pairs(C.keybinds) do
        if typeof(stored) == "string" then
            local ok, val = pcall(function() return Enum.KeyCode[stored] end)
            if ok and val then keybinds[feature] = val end
        end
    end
end

local noKeybindFeatures = {
    ["Auto Play UI"] = true,
    ["Unwalk"] = true,
    ["Optimizer"] = true,
    ["XRay"] = true,
    ["Anti Ragdoll"] = true,
    ["Lock Player UI"] = true,
    ["Show Info UI"] = true,
    ["Auto Play V2 UI"] = true,
    ["Auto Play V3 UI"] = true,
    ["Auto Plays Speed"] = true,
    ["2nd Jump Boost V2"] = true,
    ["Float (V2)"] = true,
    ["Auto Plays Steal Speed"] = true,
    ["Movement Speed"] = true,
    ["Steal Speed"] = true,
    ["Jump Boost"] = true,
    ["Gravity %"] = true,
}

UIS.InputBegan:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for name, keyCode in pairs(keybinds) do
        if input.KeyCode == keyCode then
            local tog = toggles[name]
            if tog then tog.SetState(not tog.GetState()) end
        end
    end
end)

-- ==========================================
-- BEAUTIFUL TOGGLE CREATION
-- ==========================================
local function S(v) return math.floor(v * mobScale) end

local function createBeautifulToggle(name, defaultState, callback, parent, hasSlider, sliderMin, sliderMax, sliderDefault, sliderCallback, sliderStep)
    local frameHeight = hasSlider and S(75) or S(52)
    local hasKB = not noKeybindFeatures[name]

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -S(8), 0, frameHeight)
    frame.BackgroundColor3 = Theme.Background2
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, S(10))

    local innerGlow = Instance.new("Frame")
    innerGlow.Size = UDim2.new(1, -4, 1, -4)
    innerGlow.Position = UDim2.new(0, 2, 0, 2)
    innerGlow.BackgroundColor3 = Theme.Background3
    innerGlow.BackgroundTransparency = 0.5
    innerGlow.ZIndex = 0
    innerGlow.Parent = frame
    Instance.new("UICorner", innerGlow).CornerRadius = UDim.new(0, S(8))

    local toggleRow = Instance.new("Frame")
    toggleRow.Size = UDim2.new(1, 0, 0, S(38))
    toggleRow.BackgroundTransparency = 1
    toggleRow.Parent = frame

    local labelOffset = S(6)

    if hasKB then
        local kbSize = S(24)
        local kbFrame = Instance.new("Frame")
        kbFrame.Size = UDim2.new(0, kbSize, 0, kbSize)
        kbFrame.Position = UDim2.new(0, S(6), 0.5, -kbSize/2)
        kbFrame.BackgroundColor3 = Color3.fromRGB(35, 32, 26)
        kbFrame.Parent = toggleRow
        Instance.new("UICorner", kbFrame).CornerRadius = UDim.new(0, S(6))
        local kbStroke = Instance.new("UIStroke")
        kbStroke.Color = Color3.fromRGB(60, 55, 40)
        kbStroke.Thickness = 1
        kbStroke.Parent = kbFrame

        local kbLabel = Instance.new("TextLabel")
        kbLabel.Size = UDim2.new(1, 0, 1, 0)
        kbLabel.BackgroundTransparency = 1
        kbLabel.Text = keybinds[name] and keybinds[name].Name or "-"
        kbLabel.TextColor3 = keybinds[name] and Theme.Keybind or Color3.fromRGB(100, 100, 100)
        kbLabel.Font = Enum.Font.FredokaOne
        kbLabel.TextSize = S(10)
        kbLabel.Parent = kbFrame

        local isBinding = false
        kbFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isBinding = true
                kbLabel.Text = "..."
                kbLabel.TextColor3 = Theme.Accent
                kbStroke.Color = Theme.Primary
            end
        end)
        UIS.InputBegan:Connect(function(input, gp2)
            if not isBinding or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if input.KeyCode == Enum.KeyCode.Escape then
                keybinds[name] = nil
            elseif input.KeyCode ~= Enum.KeyCode.Unknown then
                keybinds[name] = input.KeyCode
            end
            kbLabel.Text = keybinds[name] and keybinds[name].Name or "-"
            kbLabel.TextColor3 = keybinds[name] and Theme.Keybind or Color3.fromRGB(100, 100, 100)
            kbStroke.Color = keybinds[name] and Color3.fromRGB(100, 90, 60) or Color3.fromRGB(60, 55, 40)
            C.keybinds = {}
            for k, v in pairs(keybinds) do C.keybinds[k] = v.Name end
            save(C)
            isBinding = false
        end)

        labelOffset = S(36)
    end

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -S(60) - labelOffset, 1, 0)
    label.Position = UDim2.new(0, labelOffset, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.FredokaOne
    label.TextSize = S(11)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleRow

    local toggleWidth = S(52)
    local toggleHeight = S(26)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Size = UDim2.new(0, toggleWidth, 0, toggleHeight)
    toggleContainer.Position = UDim2.new(1, -toggleWidth - S(6), 0.5, -toggleHeight/2)
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = toggleRow

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(1, 0, 1, 0)
    toggleBg.BackgroundColor3 = Theme.ToggleOffBg
    toggleBg.Parent = toggleContainer
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local toggleTrack = Instance.new("Frame")
    toggleTrack.Size = UDim2.new(1, -4, 1, -4)
    toggleTrack.Position = UDim2.new(0, 2, 0, 2)
    toggleTrack.BackgroundColor3 = Theme.ToggleOff
    toggleTrack.Parent = toggleBg
    Instance.new("UICorner", toggleTrack).CornerRadius = UDim.new(1, 0)

    local circleSize = toggleHeight - 8
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, circleSize, 0, circleSize)
    toggleCircle.Position = UDim2.new(0, 4, 0.5, -circleSize/2)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 145, 140)
    toggleCircle.Parent = toggleBg
    Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)

    local circleHL = Instance.new("Frame")
    circleHL.Size = UDim2.new(0.6, 0, 0.6, 0)
    circleHL.Position = UDim2.new(0.2, 0, 0.1, 0)
    circleHL.BackgroundColor3 = Color3.fromRGB(200, 195, 190)
    circleHL.BackgroundTransparency = 0.5
    circleHL.Parent = toggleCircle
    Instance.new("UICorner", circleHL).CornerRadius = UDim.new(1, 0)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.Position = UDim2.new(0.5, -3, 0.5, -3)
    statusDot.BackgroundColor3 = Color3.fromRGB(100, 95, 90)
    statusDot.Parent = toggleCircle
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local glowEffect = Instance.new("ImageLabel")
    glowEffect.Size = UDim2.new(1.5, 0, 1.5, 0)
    glowEffect.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glowEffect.BackgroundTransparency = 1
    glowEffect.Image = "rbxassetid://5028857084"
    glowEffect.ImageColor3 = Theme.Glow
    glowEffect.ImageTransparency = 1
    glowEffect.Parent = toggleCircle

    local isEnabled = defaultState or false
    local toggleGradient = nil

    local function updateVisuals(animate)
        local ti = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        if isEnabled then
            local pos = UDim2.new(1, -circleSize - 4, 0.5, -circleSize/2)
            if animate then
                TS:Create(toggleCircle, ti, {Position = pos}):Play()
                TS:Create(toggleTrack, ti, {BackgroundColor3 = Theme.ToggleOn}):Play()
                TS:Create(toggleCircle, ti, {BackgroundColor3 = Color3.fromRGB(255, 250, 240)}):Play()
                TS:Create(circleHL, ti, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TS:Create(statusDot, ti, {BackgroundColor3 = Theme.Primary}):Play()
                TS:Create(glowEffect, ti, {ImageTransparency = 0.7}):Play()
            else
                toggleCircle.Position = pos
                toggleTrack.BackgroundColor3 = Theme.ToggleOn
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 250, 240)
                circleHL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                statusDot.BackgroundColor3 = Theme.Primary
                glowEffect.ImageTransparency = 0.7
            end
            if not toggleGradient then
                toggleGradient = Instance.new("UIGradient")
                toggleGradient.Parent = toggleTrack
                toggleGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
                })
                toggleGradient.Rotation = 45
                registerGradient(toggleGradient)
            end
        else
            local pos = UDim2.new(0, 4, 0.5, -circleSize/2)
            if animate then
                TS:Create(toggleCircle, ti, {Position = pos}):Play()
                TS:Create(toggleTrack, ti, {BackgroundColor3 = Theme.ToggleOff}):Play()
                TS:Create(toggleCircle, ti, {BackgroundColor3 = Color3.fromRGB(150, 145, 140)}):Play()
                TS:Create(circleHL, ti, {BackgroundColor3 = Color3.fromRGB(200, 195, 190)}):Play()
                TS:Create(statusDot, ti, {BackgroundColor3 = Color3.fromRGB(100, 95, 90)}):Play()
                TS:Create(glowEffect, ti, {ImageTransparency = 1}):Play()
            else
                toggleCircle.Position = pos
                toggleTrack.BackgroundColor3 = Theme.ToggleOff
                toggleCircle.BackgroundColor3 = Color3.fromRGB(150, 145, 140)
                circleHL.BackgroundColor3 = Color3.fromRGB(200, 195, 190)
                statusDot.BackgroundColor3 = Color3.fromRGB(100, 95, 90)
                glowEffect.ImageTransparency = 1
            end
            if toggleGradient then
                for i, g in ipairs(activeGradients) do
                    if g == toggleGradient then table.remove(activeGradients, i) break end
                end
                toggleGradient:Destroy()
                toggleGradient = nil
            end
        end
    end

    toggleBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isEnabled = not isEnabled
            updateVisuals(true)
            callback(isEnabled)
        end
    end)

    toggles[name] = {
        GetState = function() return isEnabled end,
        SetState = function(s)
            if isEnabled == s then return end
            isEnabled = s
            updateVisuals(true)
            callback(isEnabled)
        end
    }

    if defaultState then updateVisuals(false) end

    if hasSlider then
        local sliderRow = Instance.new("Frame")
        sliderRow.Size = UDim2.new(1, -S(14), 0, S(24))
        sliderRow.Position = UDim2.new(0, S(7), 0, S(42))
        sliderRow.BackgroundTransparency = 1
        sliderRow.Parent = frame

        local sliderBg = Instance.new("Frame")
        sliderBg.Size = UDim2.new(1, -S(50), 0, 6)
        sliderBg.Position = UDim2.new(0, 0, 0.5, -3)
        sliderBg.BackgroundColor3 = Color3.fromRGB(35, 32, 26)
        sliderBg.Parent = sliderRow
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

        local sliderFillF = Instance.new("Frame")
        sliderFillF.Size = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), 0, 1, 0)
        sliderFillF.BackgroundColor3 = Theme.SliderFill
        sliderFillF.Parent = sliderBg
        Instance.new("UICorner", sliderFillF).CornerRadius = UDim.new(1, 0)

        Instance.new("UIGradient", sliderFillF).Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
        })

        local sliderKnob = Instance.new("Frame")
        sliderKnob.Size = UDim2.new(0, 12, 0, 12)
        sliderKnob.Position = UDim2.new((sliderDefault - sliderMin) / (sliderMax - sliderMin), -6, 0.5, -6)
        sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 245, 220)
        sliderKnob.Parent = sliderBg
        Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
        local knobStroke = Instance.new("UIStroke")
        knobStroke.Color = Theme.Primary
        knobStroke.Thickness = 2
        knobStroke.Parent = sliderKnob

        local inputBox = Instance.new("TextBox")
        inputBox.Size = UDim2.new(0, S(45), 0, S(22))
        inputBox.Position = UDim2.new(1, -S(47), 0.5, -S(11))
        inputBox.BackgroundColor3 = Color3.fromRGB(35, 32, 26)
        inputBox.Text = tostring(sliderDefault)
        inputBox.TextColor3 = Theme.Text
        inputBox.Font = Enum.Font.FredokaOne
        inputBox.TextSize = S(11)
        inputBox.ClearTextOnFocus = false
        inputBox.Parent = sliderRow
        Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, S(6))
        Instance.new("UIStroke", inputBox).Color = Color3.fromRGB(60, 55, 40)

        local currentValue = sliderDefault
        local sDragging = false
        local stepSize = sliderStep or 1

        local function updateSlider(percent, updateInput)
            percent = math.clamp(percent, 0, 1)
            local raw = sliderMin + (sliderMax - sliderMin) * percent
            currentValue = math.floor(raw / stepSize + 0.5) * stepSize
            currentValue = math.clamp(currentValue, sliderMin, sliderMax)
            local ap = (currentValue - sliderMin) / (sliderMax - sliderMin)
            sliderFillF.Size = UDim2.new(ap, 0, 1, 0)
            sliderKnob.Position = UDim2.new(ap, -6, 0.5, -6)
            if updateInput ~= false then inputBox.Text = tostring(currentValue) end
            if sliderCallback then sliderCallback(currentValue) end
        end

        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sDragging = true
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                updateSlider(math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1))
            end
        end)
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sDragging = false end
        end)
        UIS.InputChanged:Connect(function(input)
            if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                updateSlider(math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1))
            end
        end)
        inputBox.FocusLost:Connect(function()
            local num = tonumber(inputBox.Text)
            if num then
                num = math.clamp(num, sliderMin, sliderMax)
                updateSlider((num - sliderMin) / (sliderMax - sliderMin), false)
                inputBox.Text = tostring(currentValue)
            else inputBox.Text = tostring(currentValue) end
        end)
    end

    return frame
end

-- ==========================================
-- STANDALONE SLIDER
-- ==========================================
local function createStandaloneSlider(name, min, max, defaultValue, sliderStep, inputStep, callback, parent)
    local frameHeight = S(52)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -S(8), 0, frameHeight)
    frame.BackgroundColor3 = Theme.Background2
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, S(10))

    local innerGlow = Instance.new("Frame")
    innerGlow.Size = UDim2.new(1, -4, 1, -4)
    innerGlow.Position = UDim2.new(0, 2, 0, 2)
    innerGlow.BackgroundColor3 = Theme.Background3
    innerGlow.BackgroundTransparency = 0.5
    innerGlow.ZIndex = 0
    innerGlow.Parent = frame
    Instance.new("UICorner", innerGlow).CornerRadius = UDim.new(0, S(8))

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -S(12), 0, S(18))
    label.Position = UDim2.new(0, S(6), 0, S(2))
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.FredokaOne
    label.TextSize = S(10)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderRow = Instance.new("Frame")
    sliderRow.Size = UDim2.new(1, -S(14), 0, S(24))
    sliderRow.Position = UDim2.new(0, S(7), 0, S(22))
    sliderRow.BackgroundTransparency = 1
    sliderRow.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -S(50), 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0.5, -3)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 32, 26)
    sliderBg.Parent = sliderRow
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

    local sliderFillF = Instance.new("Frame")
    sliderFillF.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    sliderFillF.BackgroundColor3 = Theme.SliderFill
    sliderFillF.Parent = sliderBg
    Instance.new("UICorner", sliderFillF).CornerRadius = UDim.new(1, 0)

    Instance.new("UIGradient", sliderFillF).Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 30))
    })

    local sliderKnob = Instance.new("Frame")
    sliderKnob.Size = UDim2.new(0, 12, 0, 12)
    sliderKnob.Position = UDim2.new((defaultValue - min) / (max - min), -6, 0.5, -6)
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 245, 220)
    sliderKnob.Parent = sliderBg
    Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)
    local ks = Instance.new("UIStroke") ks.Color = Theme.Primary ks.Thickness = 2 ks.Parent = sliderKnob

    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(0, S(45), 0, S(22))
    inputBox.Position = UDim2.new(1, -S(47), 0.5, -S(11))
    inputBox.BackgroundColor3 = Color3.fromRGB(35, 32, 26)
    inputBox.Text = tostring(defaultValue) inputBox.TextColor3 = Theme.Text
    inputBox.Font = Enum.Font.FredokaOne inputBox.TextSize = S(11)
    inputBox.ClearTextOnFocus = false inputBox.Parent = sliderRow
    Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, S(6))
    Instance.new("UIStroke", inputBox).Color = Color3.fromRGB(60, 55, 40)

    local currentValue = defaultValue
    local sDragging = false

    local function updateSlider(percent, updateInput)
        percent = math.clamp(percent, 0, 1)
        local raw = min + (max - min) * percent
        currentValue = math.floor(raw / sliderStep + 0.5) * sliderStep
        currentValue = math.clamp(currentValue, min, max)
        currentValue = math.floor(currentValue * 100 + 0.5) / 100
        local ap = (currentValue - min) / (max - min)
        sliderFillF.Size = UDim2.new(ap, 0, 1, 0)
        sliderKnob.Position = UDim2.new(ap, -6, 0.5, -6)
        if updateInput ~= false then inputBox.Text = tostring(currentValue) end
        if callback then callback(currentValue) end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = true
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            updateSlider(math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1))
        end
    end)
    sliderBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sDragging = false end
    end)
    UIS.InputChanged:Connect(function(input)
        if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = input.Position.X - sliderBg.AbsolutePosition.X
            updateSlider(math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1))
        end
    end)
    inputBox.FocusLost:Connect(function()
        local num = tonumber(inputBox.Text)
        if num then
            num = math.clamp(num, min, max)
            num = math.floor(num / inputStep + 0.5) * inputStep
            num = math.floor(num * 100 + 0.5) / 100
            currentValue = num
            local ap = (currentValue - min) / (max - min)
            sliderFillF.Size = UDim2.new(ap, 0, 1, 0)
            sliderKnob.Position = UDim2.new(ap, -6, 0.5, -6)
            inputBox.Text = tostring(currentValue)
            if callback then callback(currentValue) end
        else inputBox.Text = tostring(currentValue) end
    end)

    return frame
end

-- ==========================================
-- INFO BAR
-- ==========================================
local barWidth = S(420)
local barHeight = S(60)

local infoBarYOffset = isMob and S(100) or S(80)

local infoBar = Instance.new("Frame")
infoBar.Name = "InfoBar"
infoBar.Size = UDim2.new(0, barWidth, 0, barHeight)
infoBar.Position = UDim2.new(0.5, -barWidth/2, 1, -barHeight - infoBarYOffset)
infoBar.BackgroundColor3 = Theme.Background
infoBar.BackgroundTransparency = 0.05
infoBar.Active = true
infoBar.Visible = false
infoBar.Parent = SG
Instance.new("UICorner", infoBar).CornerRadius = UDim.new(0, S(12))

local t1 = Instance.new("TextLabel")
t1.Size = UDim2.new(0, S(70), 0, S(26))
t1.Position = UDim2.new(0, S(8), 0, S(4))
t1.BackgroundTransparency = 1 t1.Text = "HONEY"
t1.TextColor3 = Theme.Text t1.Font = Enum.Font.FredokaOne
t1.TextSize = S(18) t1.TextXAlignment = Enum.TextXAlignment.Left
t1.Parent = infoBar

local t2 = Instance.new("TextLabel")
t2.Size = UDim2.new(0, S(65), 0, S(26))
t2.Position = UDim2.new(0, S(75), 0, S(4))
t2.BackgroundTransparency = 1 t2.Text = "DUELS"
t2.TextColor3 = Theme.Primary t2.Font = Enum.Font.FredokaOne
t2.TextSize = S(18) t2.TextXAlignment = Enum.TextXAlignment.Left
t2.Parent = infoBar
createAnimatedYellowText(t2)

local sep1 = Instance.new("Frame")
sep1.Size = UDim2.new(0, S(130), 0, 2)
sep1.Position = UDim2.new(0, S(8), 0, S(30))
sep1.BackgroundColor3 = Theme.Primary sep1.Parent = infoBar
Instance.new("UICorner", sep1).CornerRadius = UDim.new(0, 1)

local byLabel = Instance.new("TextLabel")
byLabel.Size = UDim2.new(0, S(105), 0, S(18))
byLabel.Position = UDim2.new(0, S(8), 0, S(34))
byLabel.BackgroundTransparency = 1 byLabel.Text = "By FelipeTuffBoii"
byLabel.TextColor3 = Theme.Text byLabel.Font = Enum.Font.FredokaOne
byLabel.TextSize = S(10) byLabel.TextXAlignment = Enum.TextXAlignment.Left
byLabel.Parent = infoBar

local sep2 = Instance.new("Frame")
sep2.Size = UDim2.new(0, 2, 0, S(12))
sep2.Position = UDim2.new(0, S(115), 0, S(37))
sep2.BackgroundColor3 = Theme.Primary sep2.Parent = infoBar
Instance.new("UICorner", sep2).CornerRadius = UDim.new(0, 1)

local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0, S(110), 0, S(18))
discordLabel.Position = UDim2.new(0, S(122), 0, S(34))
discordLabel.BackgroundTransparency = 1 discordLabel.Text = "discord.gg/fmq8u5ksV"
discordLabel.TextColor3 = Theme.Text discordLabel.Font = Enum.Font.FredokaOne
discordLabel.TextSize = S(9) discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.Parent = infoBar

local sep3 = Instance.new("Frame")
sep3.Size = UDim2.new(0, 2, 0, barHeight - S(16))
sep3.Position = UDim2.new(0, S(240), 0, S(8))
sep3.BackgroundColor3 = Theme.Primary sep3.Parent = infoBar
Instance.new("UICorner", sep3).CornerRadius = UDim.new(0, 1)

local infoOpenBtn = Instance.new("TextButton")
infoOpenBtn.Size = UDim2.new(0, S(70), 0, barHeight - S(16))
infoOpenBtn.Position = UDim2.new(0, S(252), 0, S(8))
infoOpenBtn.BackgroundColor3 = Theme.Background
infoOpenBtn.Text = "" infoOpenBtn.Parent = infoBar
Instance.new("UICorner", infoOpenBtn).CornerRadius = UDim.new(0, S(8))

local infoOpenText = Instance.new("TextLabel")
infoOpenText.Size = UDim2.new(1, 0, 1, 0)
infoOpenText.BackgroundTransparency = 1 infoOpenText.Text = "OPEN"
infoOpenText.TextColor3 = Theme.Text infoOpenText.Font = Enum.Font.FredokaOne
infoOpenText.TextSize = S(14) infoOpenText.Parent = infoOpenBtn

local sep4 = Instance.new("Frame")
sep4.Size = UDim2.new(0, 2, 0, barHeight - S(16))
sep4.Position = UDim2.new(0, S(330), 0, S(8))
sep4.BackgroundColor3 = Theme.Primary sep4.Parent = infoBar
Instance.new("UICorner", sep4).CornerRadius = UDim.new(0, 1)

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0, S(65), 0, barHeight - S(16))
versionLabel.Position = UDim2.new(0, S(342), 0, S(8))
versionLabel.BackgroundTransparency = 1 versionLabel.Text = "V3.4"
versionLabel.TextColor3 = Theme.Primary versionLabel.Font = Enum.Font.FredokaOne
versionLabel.TextSize = S(20) versionLabel.Parent = infoBar
createAnimatedYellowText(versionLabel)

-- ==========================================
-- MAIN PANEL
-- ==========================================
local mainW = S(420)
local mainH = S(520)

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0, mainW, 0, mainH)
panel.Position = UDim2.new(1, -mainW - S(10), 0, S(10))
panel.BackgroundColor3 = Theme.Background
panel.BackgroundTransparency = 0.02
panel.Visible = false
panel.Active = true
panel.Parent = SG
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, S(14))
makeDraggable(panel, "panelPos")
createFloatingDots(panel, 12)

local titleC = Instance.new("Frame")
titleC.Size = UDim2.new(1, -S(50), 0, S(34))
titleC.Position = UDim2.new(0, S(12), 0, S(8))
titleC.BackgroundTransparency = 1 titleC.Parent = panel

local honeyT = Instance.new("TextLabel")
honeyT.Size = UDim2.new(0, S(70), 1, 0)
honeyT.BackgroundTransparency = 1 honeyT.Text = "HONEY"
honeyT.TextColor3 = Theme.Text honeyT.TextSize = S(22)
honeyT.Font = Enum.Font.FredokaOne honeyT.TextXAlignment = Enum.TextXAlignment.Left
honeyT.Parent = titleC

local duelsT = Instance.new("TextLabel")
duelsT.Size = UDim2.new(0, S(65), 1, 0)
duelsT.Position = UDim2.new(0, S(72), 0, 0)
duelsT.BackgroundTransparency = 1 duelsT.Text = "DUELS"
duelsT.TextColor3 = Theme.Primary duelsT.TextSize = S(22)
duelsT.Font = Enum.Font.FredokaOne duelsT.TextXAlignment = Enum.TextXAlignment.Left
duelsT.Parent = titleC
createAnimatedYellowText(duelsT)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, S(30), 0, S(30))
closeBtn.Position = UDim2.new(1, -S(40), 0, S(8))
closeBtn.BackgroundColor3 = Theme.Background2
closeBtn.BackgroundTransparency = 0.3 closeBtn.Text = ""
closeBtn.Parent = panel
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, S(8))

local closeTxt = Instance.new("TextLabel")
closeTxt.Size = UDim2.new(1, 0, 1, 0) closeTxt.BackgroundTransparency = 1
closeTxt.Text = "X" closeTxt.Font = Enum.Font.FredokaOne
closeTxt.TextSize = S(16) closeTxt.TextColor3 = Theme.Text
closeTxt.Parent = closeBtn

-- Two columns
local colContainer = Instance.new("Frame")
colContainer.Size = UDim2.new(1, -S(14), 1, -S(56))
colContainer.Position = UDim2.new(0, S(7), 0, S(50))
colContainer.BackgroundTransparency = 1 colContainer.Parent = panel

local leftCol = Instance.new("ScrollingFrame")
leftCol.Size = UDim2.new(0.5, -3, 1, 0)
leftCol.BackgroundTransparency = 1
leftCol.ScrollBarThickness = 2
leftCol.ScrollBarImageColor3 = Theme.Primary
leftCol.Parent = colContainer

local leftLay = Instance.new("UIListLayout", leftCol)
leftLay.Padding = UDim.new(0, S(5))
Instance.new("UIPadding", leftCol).PaddingTop = UDim.new(0, 2)

local rightCol = Instance.new("ScrollingFrame")
rightCol.Size = UDim2.new(0.5, -3, 1, 0)
rightCol.Position = UDim2.new(0.5, 3, 0, 0)
rightCol.BackgroundTransparency = 1
rightCol.ScrollBarThickness = 2
rightCol.ScrollBarImageColor3 = Theme.Primary
rightCol.Parent = colContainer

local rightLay = Instance.new("UIListLayout", rightCol)
rightLay.Padding = UDim.new(0, S(5))
Instance.new("UIPadding", rightCol).PaddingTop = UDim.new(0, 2)

-- ==========================================
-- CREATE TOGGLES - LEFT COLUMN
-- ==========================================
createBeautifulToggle("Anti Ragdoll", C.antiRag, function(on) toggleAntiRag(on) end, leftCol)
createBeautifulToggle("Auto Steal", C.autoSteal, function(on) toggleAutoSteal(on) end, leftCol, true, 5, 100, C.stealRadius, function(v)
    C.stealRadius=v save(C)
    if C.autoSteal then destroyCircle() createCircle() end
end, 1)
createBeautifulToggle("Bat Aimbot", C.batAimbot, function(on) toggleBatAimbot(on) end, leftCol)
createBeautifulToggle("Lock Player", C.lockPlayer, function(on) toggleLockPlayer(on) end, leftCol)
createBeautifulToggle("Lock Player UI", C.lockUI, function(on) C.lockUI=on save(C) end, leftCol)
createBeautifulToggle("Auto Lock Player", C.autoLockPlayer, function(on) toggleAutoLockPlayer(on) end, leftCol)
createBeautifulToggle("Spin Bot", C.spinbot, function(on) toggleSpinbot(on) end, leftCol, true, 0, 100, C.spinSpeed, function(v) C.spinSpeed=v save(C) end, 1)
createBeautifulToggle("Inf Jump", C.infJump, function(on) toggleInfJump(on) end, leftCol)
createBeautifulToggle("Show Info UI", C.showInfoUI, function(on) C.showInfoUI=on save(C) end, leftCol)
createBeautifulToggle("Auto Play V3 UI", C.autoPlayV3UI, function(on) C.autoPlayV3UI=on save(C) end, leftCol)
createBeautifulToggle("Auto Play V2 UI", C.autoPlayV2UI, function(on) C.autoPlayV2UI=on save(C) end, leftCol)
createBeautifulToggle("Auto Play UI", C.autoPlayUI, function(on) C.autoPlayUI=on save(C) end, leftCol)

createStandaloneSlider("Auto Plays Speed", 20, 70, C.autoPlaySpeed, 0.5, 0.1, function(v)
    C.autoPlaySpeed = v save(C)
end, leftCol)

createStandaloneSlider("2nd Jump Boost V2", 10, 80, C.jumpBoostV2Val, 0.5, 0.1, function(v)
    C.jumpBoostV2Val = v save(C)
end, leftCol)

createStandaloneSlider("Float (V2)", 5, 50, C.floatV2Val, 0.5, 0.1, function(v)
    C.floatV2Val = v save(C)
end, leftCol)

-- ==========================================
-- CREATE TOGGLES - RIGHT COLUMN
-- ==========================================
createBeautifulToggle("Unwalk", C.unwalk, function(on) toggleUnwalk(on) end, rightCol)
createBeautifulToggle("XRay", C.xray, function(on) toggleXray(on) end, rightCol)
createBeautifulToggle("Player ESP", C.esp, function(on) toggleESP(on) end, rightCol)
createBeautifulToggle("Optimizer", C.optimizer, function(on) toggleOptimizer(on) end, rightCol)

createBeautifulToggle("Movement Speed", C.moveSpeed, function(on)
    toggleMoveSpeed(on)
end, rightCol, true, 20, 70, C.moveSpeedVal, function(v)
    C.moveSpeedVal = v save(C)
end, 1)

createBeautifulToggle("Steal Speed", C.stealSpeed, function(on)
    toggleStealSpeed(on)
end, rightCol, true, 10, 35, C.stealSpeedVal, function(v)
    C.stealSpeedVal = v save(C)
end, 1)

createBeautifulToggle("Jump Boost", C.jumpBoost, function(on)
    toggleJumpBoost(on)
end, rightCol, true, 10, 80, C.jumpBoostVal, function(v)
    C.jumpBoostVal = v save(C)
end, 1)

createBeautifulToggle("Gravity %", C.gravity, function(on)
    toggleGravity(on)
end, rightCol, true, 25, 130, C.gravityVal, function(v)
    C.gravityVal = v save(C)
end, 1)

createStandaloneSlider("Auto Plays Steal Speed", 10, 50, C.autoPlaysStealSpeed, 0.5, 0.1, function(v)
    C.autoPlaysStealSpeed = v save(C)
end, rightCol)

createBeautifulToggle("Auto Play V3", C.autoPlayV3Direct, function(on)
    C.autoPlayV3Direct = on save(C)
    if on then
        -- Stop others first via their toggles
        if state.autoPlayOn then
            stopAutoPlay()
            C.autoPlayDirect = false save(C)
            if toggles["Auto Play"] then
                local t = toggles["Auto Play"]
                -- Avoid recursive callback by checking state
                if t.GetState() then
                    -- Manually reset without triggering callback again
                    t.SetState(false)
                end
            end
        end
        if state.autoPlayV2On then
            stopAutoPlayV2()
            C.autoPlayV2Direct = false save(C)
            if toggles["Auto Play V2"] then
                if toggles["Auto Play V2"].GetState() then
                    toggles["Auto Play V2"].SetState(false)
                end
            end
        end
        startAutoPlayV3()
        task.spawn(function()
            while state.autoPlayV3On do task.wait(0.1) end
            C.autoPlayV3Direct = false save(C)
            if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
                toggles["Auto Play V3"].SetState(false)
            end
        end)
    else
        stopAutoPlayV3()
    end
end, rightCol)

createBeautifulToggle("Auto Play V2", C.autoPlayV2Direct, function(on)
    C.autoPlayV2Direct = on save(C)
    if on then
        if state.autoPlayOn then
            stopAutoPlay()
            C.autoPlayDirect = false save(C)
            if toggles["Auto Play"] and toggles["Auto Play"].GetState() then
                toggles["Auto Play"].SetState(false)
            end
        end
        if state.autoPlayV3On then
            stopAutoPlayV3()
            C.autoPlayV3Direct = false save(C)
            if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
                toggles["Auto Play V3"].SetState(false)
            end
        end
        startAutoPlayV2()
        task.spawn(function()
            while state.autoPlayV2On do task.wait(0.1) end
            C.autoPlayV2Direct = false save(C)
            if toggles["Auto Play V2"] and toggles["Auto Play V2"].GetState() then
                toggles["Auto Play V2"].SetState(false)
            end
        end)
    else
        stopAutoPlayV2()
    end
end, rightCol)

createBeautifulToggle("Auto Play", C.autoPlayDirect, function(on)
    C.autoPlayDirect = on save(C)
    if on then
        if state.autoPlayV2On then
            stopAutoPlayV2()
            C.autoPlayV2Direct = false save(C)
            if toggles["Auto Play V2"] and toggles["Auto Play V2"].GetState() then
                toggles["Auto Play V2"].SetState(false)
            end
        end
        if state.autoPlayV3On then
            stopAutoPlayV3()
            C.autoPlayV3Direct = false save(C)
            if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
                toggles["Auto Play V3"].SetState(false)
            end
        end
        startAutoPlay()
        task.spawn(function()
            while state.autoPlayOn do task.wait(0.1) end
            C.autoPlayDirect = false save(C)
            if toggles["Auto Play"] and toggles["Auto Play"].GetState() then
                toggles["Auto Play"].SetState(false)
            end
        end)
    else
        stopAutoPlay()
    end
end, rightCol)

leftLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    leftCol.CanvasSize = UDim2.new(0, 0, 0, leftLay.AbsoluteContentSize.Y + 10)
end)
rightLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    rightCol.CanvasSize = UDim2.new(0, 0, 0, rightLay.AbsoluteContentSize.Y + 10)
end)

-- Panel open/close logic
local function setPanelVisible(vis)
    panel.Visible = vis
    infoOpenText.Text = vis and "CLOSE" or "OPEN"
end

closeBtn.MouseButton1Click:Connect(function() setPanelVisible(false) end)
infoOpenBtn.MouseButton1Click:Connect(function() setPanelVisible(not panel.Visible) end)

-- ==========================================
-- AUTO STEAL PANEL (with steal duration input)
-- ==========================================
local asW = S(300)
local asH = S(48)

local asPanel = Instance.new("Frame")
asPanel.Name = "AutoStealPanel"
asPanel.Size = UDim2.new(0, asW, 0, asH)
asPanel.Position = UDim2.new(0.5, -asW/2, 0, S(12))
asPanel.BackgroundColor3 = Theme.Background
asPanel.BackgroundTransparency = 0.05
asPanel.Active = true asPanel.Parent = SG
Instance.new("UICorner", asPanel).CornerRadius = UDim.new(0, S(10))

local asLabelAuto = Instance.new("TextLabel")
asLabelAuto.Size = UDim2.new(0, S(34), 0, S(20))
asLabelAuto.Position = UDim2.new(0, S(8), 0, S(4))
asLabelAuto.BackgroundTransparency = 1 asLabelAuto.Text = "Auto"
asLabelAuto.TextColor3 = Theme.Text asLabelAuto.Font = Enum.Font.FredokaOne
asLabelAuto.TextSize = S(13) asLabelAuto.TextXAlignment = Enum.TextXAlignment.Left
asLabelAuto.Parent = asPanel

local asLabelSteal = Instance.new("TextLabel")
asLabelSteal.Size = UDim2.new(0, S(40), 0, S(20))
asLabelSteal.Position = UDim2.new(0, S(44), 0, S(4))
asLabelSteal.BackgroundTransparency = 1 asLabelSteal.Text = "Steal"
asLabelSteal.TextColor3 = Theme.Primary asLabelSteal.Font = Enum.Font.FredokaOne
asLabelSteal.TextSize = S(13) asLabelSteal.TextXAlignment = Enum.TextXAlignment.Left
asLabelSteal.Parent = asPanel
createAnimatedYellowText(asLabelSteal)

local asStatusLabel = Instance.new("TextLabel")
asStatusLabel.Size = UDim2.new(0, S(30), 0, S(20))
asStatusLabel.Position = UDim2.new(0, S(88), 0, S(4))
asStatusLabel.BackgroundTransparency = 1
asStatusLabel.Text = C.autoSteal and "ON" or "OFF"
asStatusLabel.TextColor3 = C.autoSteal and Theme.Success or Theme.Danger
asStatusLabel.Font = Enum.Font.FredokaOne asStatusLabel.TextSize = S(11)
asStatusLabel.TextXAlignment = Enum.TextXAlignment.Left
asStatusLabel.Parent = asPanel

-- Steal Duration input box
local asDurBox = Instance.new("TextBox")
asDurBox.Size = UDim2.new(0, S(38), 0, S(24))
asDurBox.Position = UDim2.new(1, -S(108), 0, S(3))
asDurBox.BackgroundColor3 = Theme.Background asDurBox.BorderSizePixel = 0
asDurBox.Text = tostring(C.stealDuration) asDurBox.TextColor3 = Theme.Text
asDurBox.Font = Enum.Font.FredokaOne asDurBox.TextSize = S(11)
asDurBox.TextXAlignment = Enum.TextXAlignment.Center
asDurBox.PlaceholderText = "Spd" asDurBox.ClearTextOnFocus = false
asDurBox.Parent = asPanel
Instance.new("UICorner", asDurBox).CornerRadius = UDim.new(0, S(6))

local asDurLabel = Instance.new("TextLabel")
asDurLabel.Size = UDim2.new(0, S(8), 0, S(24))
asDurLabel.Position = UDim2.new(1, -S(70), 0, S(3))
asDurLabel.BackgroundTransparency = 1
asDurLabel.Text = "s"
asDurLabel.TextColor3 = Theme.TextSecondary
asDurLabel.Font = Enum.Font.FredokaOne
asDurLabel.TextSize = S(10)
asDurLabel.TextXAlignment = Enum.TextXAlignment.Left
asDurLabel.Parent = asPanel

asDurBox.FocusLost:Connect(function()
    local n = tonumber(asDurBox.Text)
    if n then
        n = math.clamp(n, 0.4, 5)
        n = math.floor(n * 10 + 0.5) / 10
        C.stealDuration = n save(C)
        asDurBox.Text = tostring(C.stealDuration)
    else asDurBox.Text = tostring(C.stealDuration) end
end)

-- Radius input box
local asRadBox = Instance.new("TextBox")
asRadBox.Size = UDim2.new(0, S(48), 0, S(24))
asRadBox.Position = UDim2.new(1, -S(58), 0, S(3))
asRadBox.BackgroundColor3 = Theme.Background asRadBox.BorderSizePixel = 0
asRadBox.Text = tostring(C.stealRadius) asRadBox.TextColor3 = Theme.Text
asRadBox.Font = Enum.Font.FredokaOne asRadBox.TextSize = S(12)
asRadBox.TextXAlignment = Enum.TextXAlignment.Center
asRadBox.PlaceholderText = "R" asRadBox.ClearTextOnFocus = false
asRadBox.Parent = asPanel
Instance.new("UICorner", asRadBox).CornerRadius = UDim.new(0, S(6))

asRadBox.FocusLost:Connect(function()
    local n = tonumber(asRadBox.Text)
    if n and n >= 5 then
        C.stealRadius = math.floor(n) save(C)
        asRadBox.Text = tostring(C.stealRadius)
        if C.autoSteal then destroyCircle() createCircle() end
    else asRadBox.Text = tostring(C.stealRadius) end
end)

local asProgBg = Instance.new("Frame")
asProgBg.Size = UDim2.new(1, -S(12), 0, S(8))
asProgBg.Position = UDim2.new(0, S(6), 1, -S(12))
asProgBg.BackgroundColor3 = Color3.fromRGB(25, 23, 20)
asProgBg.Parent = asPanel
Instance.new("UICorner", asProgBg).CornerRadius = UDim.new(1, 0)

stealFill = Instance.new("Frame")
stealFill.Size = UDim2.new(0, 0, 1, 0)
stealFill.BackgroundColor3 = Theme.Primary stealFill.Parent = asProgBg
Instance.new("UICorner", stealFill).CornerRadius = UDim.new(1, 0)

local fillGrad = Instance.new("UIGradient")
fillGrad.Parent = stealFill
fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 80))
})
registerGradient(fillGrad)

local function updateASStatus()
    if asStatusLabel then
        asStatusLabel.Text = C.autoSteal and "ON" or "OFF"
        asStatusLabel.TextColor3 = C.autoSteal and Theme.Success or Theme.Danger
    end
    -- Update the UI boxes to reflect current values (may change during auto play)
    if asDurBox and not asDurBox:IsFocused() then
        asDurBox.Text = tostring(C.stealDuration)
    end
    if asRadBox and not asRadBox:IsFocused() then
        asRadBox.Text = tostring(C.stealRadius)
    end
end

-- ==========================================
-- FLOAT BUTTON (narrower, centered)
-- ==========================================
local floatBtnW = S(180)
local floatBtnH = S(32)

local floatBtn = Instance.new("TextButton")
floatBtn.Name = "FloatOpenBtn"
floatBtn.Size = UDim2.new(0, floatBtnW, 0, floatBtnH)
floatBtn.Position = UDim2.new(0.5, -floatBtnW/2, 0, S(12) + asH + S(3))
floatBtn.BackgroundColor3 = Theme.Background
floatBtn.BackgroundTransparency = 0.05
floatBtn.Text = ""
floatBtn.Active = true
floatBtn.Parent = SG
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0, S(10))

local floatBtnOpenClose = Instance.new("TextLabel")
floatBtnOpenClose.Size = UDim2.new(0, S(50), 1, 0)
floatBtnOpenClose.Position = UDim2.new(0.5, -S(42), 0, 0)
floatBtnOpenClose.BackgroundTransparency = 1
floatBtnOpenClose.Text = "Open"
floatBtnOpenClose.TextColor3 = Theme.Text
floatBtnOpenClose.Font = Enum.Font.FredokaOne
floatBtnOpenClose.TextSize = S(14)
floatBtnOpenClose.TextXAlignment = Enum.TextXAlignment.Right
floatBtnOpenClose.Parent = floatBtn

local floatBtnMenu = Instance.new("TextLabel")
floatBtnMenu.Size = UDim2.new(0, S(45), 1, 0)
floatBtnMenu.Position = UDim2.new(0.5, -S(42) + S(52), 0, 0)
floatBtnMenu.BackgroundTransparency = 1
floatBtnMenu.Text = "Menu"
floatBtnMenu.TextColor3 = Theme.Primary
floatBtnMenu.Font = Enum.Font.FredokaOne
floatBtnMenu.TextSize = S(14)
floatBtnMenu.TextXAlignment = Enum.TextXAlignment.Left
floatBtnMenu.Parent = floatBtn
createAnimatedYellowText(floatBtnMenu)

floatBtn.MouseButton1Click:Connect(function()
    setPanelVisible(not panel.Visible)
end)

panel:GetPropertyChangedSignal("Visible"):Connect(function()
    floatBtnOpenClose.Text = panel.Visible and "Close" or "Open"
end)

-- ==========================================
-- FPS / PING BAR
-- ==========================================
local fpsBarH = S(24)
local fpsBar = Instance.new("Frame")
fpsBar.Name = "FPSPingBar"
fpsBar.Size = UDim2.new(0, floatBtnW, 0, fpsBarH)
fpsBar.Position = UDim2.new(0.5, -floatBtnW/2, 0, S(12) + asH + S(3) + floatBtnH + S(2))
fpsBar.BackgroundColor3 = Theme.Background
fpsBar.BackgroundTransparency = 0.05
fpsBar.Parent = SG
Instance.new("UICorner", fpsBar).CornerRadius = UDim.new(0, S(8))

local fpsPingLabel = Instance.new("TextLabel")
fpsPingLabel.Size = UDim2.new(1, 0, 1, 0)
fpsPingLabel.BackgroundTransparency = 1
fpsPingLabel.Text = "FPS: 0  |  PING: 0ms"
fpsPingLabel.TextColor3 = Theme.Text
fpsPingLabel.Font = Enum.Font.FredokaOne
fpsPingLabel.TextSize = S(10)
fpsPingLabel.TextXAlignment = Enum.TextXAlignment.Center
fpsPingLabel.Parent = fpsBar

local fpsFrameCount = 0
local fpsLastTime = tick()
local fpsUpdateCounter = 0

RS.Heartbeat:Connect(function()
    fpsFrameCount = fpsFrameCount + 1
    fpsUpdateCounter = fpsUpdateCounter + 1
    if fpsUpdateCounter % 30 == 0 then
        local now = tick()
        local elapsed = now - fpsLastTime
        local fps = 0
        if elapsed > 0 then
            fps = math.floor(fpsFrameCount / elapsed)
            fpsFrameCount = 0
            fpsLastTime = now
        end
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        fpsPingLabel.Text = "FPS: " .. tostring(fps) .. "  |  PING: " .. tostring(ping) .. "ms"
    end
end)

-- ==========================================
-- LOCK PLAYER UI
-- ==========================================
local lockUIFrame = Instance.new("Frame")
lockUIFrame.Name = "LockPlayerUI"
lockUIFrame.Size = UDim2.new(0, S(210), 0, S(48))
lockUIFrame.Position = UDim2.new(1, -S(220), 0, S(10))
lockUIFrame.BackgroundColor3 = Theme.Background
lockUIFrame.BackgroundTransparency = 0.1
lockUIFrame.Active = true lockUIFrame.Visible = false
lockUIFrame.Parent = SG
Instance.new("UICorner", lockUIFrame).CornerRadius = UDim.new(0, S(10))
makeDraggable(lockUIFrame)

local lockTogBtn = Instance.new("TextButton")
lockTogBtn.Size = UDim2.new(1, -S(12), 1, -S(8))
lockTogBtn.Position = UDim2.new(0, S(6), 0, S(4))
lockTogBtn.BackgroundTransparency = 1
lockTogBtn.Text = "Enable Lock Player"
lockTogBtn.TextColor3 = Theme.Success lockTogBtn.Font = Enum.Font.FredokaOne
lockTogBtn.TextSize = S(13) lockTogBtn.TextWrapped = true
lockTogBtn.Parent = lockUIFrame

local lockUIGrad = createAnimatedGreenText(lockTogBtn)

local function updateLockUIState()
    if C.lockPlayer then
        lockTogBtn.Text = "Disable Lock Player"
        if lockUIGrad then
            for i, g in ipairs(activeGradients) do if g == lockUIGrad then table.remove(activeGradients, i) break end end
            lockUIGrad:Destroy()
        end
        lockUIGrad = createAnimatedRedText(lockTogBtn)
    else
        lockTogBtn.Text = "Enable Lock Player"
        if lockUIGrad then
            for i, g in ipairs(activeGradients) do if g == lockUIGrad then table.remove(activeGradients, i) break end end
            lockUIGrad:Destroy()
        end
        lockUIGrad = createAnimatedGreenText(lockTogBtn)
    end
end

lockTogBtn.MouseButton1Click:Connect(function()
    C.lockPlayer = not C.lockPlayer
    toggleLockPlayer(C.lockPlayer) updateLockUIState()
    if toggles["Lock Player"] then toggles["Lock Player"].SetState(C.lockPlayer) end
end)

-- ==========================================
-- AUTO PLAY V3 UI (top-left, first)
-- ==========================================
local autoPlayV3UIFrame = Instance.new("Frame")
autoPlayV3UIFrame.Name = "AutoPlayV3UI"
autoPlayV3UIFrame.Size = UDim2.new(0, S(160), 0, S(48))
autoPlayV3UIFrame.Position = UDim2.new(0, S(10), 0, S(10))
autoPlayV3UIFrame.BackgroundColor3 = Theme.Background
autoPlayV3UIFrame.BackgroundTransparency = 0.1
autoPlayV3UIFrame.Active = true autoPlayV3UIFrame.Visible = false
autoPlayV3UIFrame.Parent = SG
Instance.new("UICorner", autoPlayV3UIFrame).CornerRadius = UDim.new(0, S(10))
makeDraggable(autoPlayV3UIFrame)

local autoPlayV3TogBtn = Instance.new("TextButton")
autoPlayV3TogBtn.Size = UDim2.new(1, -S(12), 1, -S(8))
autoPlayV3TogBtn.Position = UDim2.new(0, S(6), 0, S(4))
autoPlayV3TogBtn.BackgroundTransparency = 1
autoPlayV3TogBtn.Text = "Enable Auto Play V3"
autoPlayV3TogBtn.TextColor3 = Theme.Success autoPlayV3TogBtn.Font = Enum.Font.FredokaOne
autoPlayV3TogBtn.TextSize = S(12) autoPlayV3TogBtn.TextWrapped = true
autoPlayV3TogBtn.Parent = autoPlayV3UIFrame

local autoPlayV3UIGrad = createAnimatedGreenText(autoPlayV3TogBtn)

local function updateAutoPlayV3UIState()
    if state.autoPlayV3On then
        autoPlayV3TogBtn.Text = "Disable Auto Play V3"
        if autoPlayV3UIGrad then
            for i, g in ipairs(activeGradients) do if g == autoPlayV3UIGrad then table.remove(activeGradients, i) break end end
            autoPlayV3UIGrad:Destroy()
        end
        autoPlayV3UIGrad = createAnimatedRedText(autoPlayV3TogBtn)
    else
        autoPlayV3TogBtn.Text = "Enable Auto Play V3"
        if autoPlayV3UIGrad then
            for i, g in ipairs(activeGradients) do if g == autoPlayV3UIGrad then table.remove(activeGradients, i) break end end
            autoPlayV3UIGrad:Destroy()
        end
        autoPlayV3UIGrad = createAnimatedGreenText(autoPlayV3TogBtn)
    end
end

autoPlayV3TogBtn.MouseButton1Click:Connect(function()
    if state.autoPlayV3On then
        stopAutoPlayV3()
        updateAutoPlayV3UIState()
        -- Also reset the main panel toggle
        C.autoPlayV3Direct = false save(C)
        if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
            toggles["Auto Play V3"].SetState(false)
        end
    else
        -- Stop others first
        if state.autoPlayOn then
            stopAutoPlay()
            updateAutoPlayUIState()
            C.autoPlayDirect = false save(C)
            if toggles["Auto Play"] and toggles["Auto Play"].GetState() then
                toggles["Auto Play"].SetState(false)
            end
        end
        if state.autoPlayV2On then
            stopAutoPlayV2()
            updateAutoPlayV2UIState()
            C.autoPlayV2Direct = false save(C)
            if toggles["Auto Play V2"] and toggles["Auto Play V2"].GetState() then
                toggles["Auto Play V2"].SetState(false)
            end
        end
        startAutoPlayV3()
        updateAutoPlayV3UIState()
        task.spawn(function()
            while state.autoPlayV3On do task.wait(0.1) end
            updateAutoPlayV3UIState()
            C.autoPlayV3Direct = false save(C)
            if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
                toggles["Auto Play V3"].SetState(false)
            end
        end)
    end
end)

-- ==========================================
-- AUTO PLAY V2 UI (below V3)
-- ==========================================
local autoPlayV2UIFrame = Instance.new("Frame")
autoPlayV2UIFrame.Name = "AutoPlayV2UI"
autoPlayV2UIFrame.Size = UDim2.new(0, S(160), 0, S(48))
autoPlayV2UIFrame.Position = UDim2.new(0, S(10), 0, S(64))
autoPlayV2UIFrame.BackgroundColor3 = Theme.Background
autoPlayV2UIFrame.BackgroundTransparency = 0.1
autoPlayV2UIFrame.Active = true autoPlayV2UIFrame.Visible = false
autoPlayV2UIFrame.Parent = SG
Instance.new("UICorner", autoPlayV2UIFrame).CornerRadius = UDim.new(0, S(10))
makeDraggable(autoPlayV2UIFrame)

local autoPlayV2TogBtn = Instance.new("TextButton")
autoPlayV2TogBtn.Size = UDim2.new(1, -S(12), 1, -S(8))
autoPlayV2TogBtn.Position = UDim2.new(0, S(6), 0, S(4))
autoPlayV2TogBtn.BackgroundTransparency = 1
autoPlayV2TogBtn.Text = "Enable Auto Play V2"
autoPlayV2TogBtn.TextColor3 = Theme.Success autoPlayV2TogBtn.Font = Enum.Font.FredokaOne
autoPlayV2TogBtn.TextSize = S(12) autoPlayV2TogBtn.TextWrapped = true
autoPlayV2TogBtn.Parent = autoPlayV2UIFrame

local autoPlayV2UIGrad = createAnimatedGreenText(autoPlayV2TogBtn)

local function updateAutoPlayV2UIState()
    if state.autoPlayV2On then
        autoPlayV2TogBtn.Text = "Disable Auto Play V2"
        if autoPlayV2UIGrad then
            for i, g in ipairs(activeGradients) do if g == autoPlayV2UIGrad then table.remove(activeGradients, i) break end end
            autoPlayV2UIGrad:Destroy()
        end
        autoPlayV2UIGrad = createAnimatedRedText(autoPlayV2TogBtn)
    else
        autoPlayV2TogBtn.Text = "Enable Auto Play V2"
        if autoPlayV2UIGrad then
            for i, g in ipairs(activeGradients) do if g == autoPlayV2UIGrad then table.remove(activeGradients, i) break end end
            autoPlayV2UIGrad:Destroy()
        end
        autoPlayV2UIGrad = createAnimatedGreenText(autoPlayV2TogBtn)
    end
end

autoPlayV2TogBtn.MouseButton1Click:Connect(function()
    if state.autoPlayV2On then
        stopAutoPlayV2()
        updateAutoPlayV2UIState()
        C.autoPlayV2Direct = false save(C)
        if toggles["Auto Play V2"] and toggles["Auto Play V2"].GetState() then
            toggles["Auto Play V2"].SetState(false)
        end
    else
        if state.autoPlayOn then
            stopAutoPlay()
            updateAutoPlayUIState()
            C.autoPlayDirect = false save(C)
            if toggles["Auto Play"] and toggles["Auto Play"].GetState() then
                toggles["Auto Play"].SetState(false)
            end
        end
        if state.autoPlayV3On then
            stopAutoPlayV3()
            updateAutoPlayV3UIState()
            C.autoPlayV3Direct = false save(C)
            if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
                toggles["Auto Play V3"].SetState(false)
            end
        end
        startAutoPlayV2()
        updateAutoPlayV2UIState()
        task.spawn(function()
            while state.autoPlayV2On do task.wait(0.1) end
            updateAutoPlayV2UIState()
            C.autoPlayV2Direct = false save(C)
            if toggles["Auto Play V2"] and toggles["Auto Play V2"].GetState() then
                toggles["Auto Play V2"].SetState(false)
            end
        end)
    end
end)

-- ==========================================
-- AUTO PLAY UI (below V2)
-- ==========================================
local autoPlayUIFrame = Instance.new("Frame")
autoPlayUIFrame.Name = "AutoPlayUI"
autoPlayUIFrame.Size = UDim2.new(0, S(160), 0, S(48))
autoPlayUIFrame.Position = UDim2.new(0, S(10), 0, S(118))
autoPlayUIFrame.BackgroundColor3 = Theme.Background
autoPlayUIFrame.BackgroundTransparency = 0.1
autoPlayUIFrame.Active = true autoPlayUIFrame.Visible = false
autoPlayUIFrame.Parent = SG
Instance.new("UICorner", autoPlayUIFrame).CornerRadius = UDim.new(0, S(10))
makeDraggable(autoPlayUIFrame)

local autoPlayTogBtn = Instance.new("TextButton")
autoPlayTogBtn.Size = UDim2.new(1, -S(12), 1, -S(8))
autoPlayTogBtn.Position = UDim2.new(0, S(6), 0, S(4))
autoPlayTogBtn.BackgroundTransparency = 1
autoPlayTogBtn.Text = "Enable Auto Play"
autoPlayTogBtn.TextColor3 = Theme.Success autoPlayTogBtn.Font = Enum.Font.FredokaOne
autoPlayTogBtn.TextSize = S(12) autoPlayTogBtn.TextWrapped = true
autoPlayTogBtn.Parent = autoPlayUIFrame

local autoPlayUIGrad = createAnimatedGreenText(autoPlayTogBtn)

local function updateAutoPlayUIState()
    if state.autoPlayOn then
        autoPlayTogBtn.Text = "Disable Auto Play"
        if autoPlayUIGrad then
            for i, g in ipairs(activeGradients) do if g == autoPlayUIGrad then table.remove(activeGradients, i) break end end
            autoPlayUIGrad:Destroy()
        end
        autoPlayUIGrad = createAnimatedRedText(autoPlayTogBtn)
    else
        autoPlayTogBtn.Text = "Enable Auto Play"
        if autoPlayUIGrad then
            for i, g in ipairs(activeGradients) do if g == autoPlayUIGrad then table.remove(activeGradients, i) break end end
            autoPlayUIGrad:Destroy()
        end
        autoPlayUIGrad = createAnimatedGreenText(autoPlayTogBtn)
    end
end

autoPlayTogBtn.MouseButton1Click:Connect(function()
    if state.autoPlayOn then
        stopAutoPlay()
        updateAutoPlayUIState()
        C.autoPlayDirect = false save(C)
        if toggles["Auto Play"] and toggles["Auto Play"].GetState() then
            toggles["Auto Play"].SetState(false)
        end
    else
        if state.autoPlayV2On then
            stopAutoPlayV2()
            updateAutoPlayV2UIState()
            C.autoPlayV2Direct = false save(C)
            if toggles["Auto Play V2"] and toggles["Auto Play V2"].GetState() then
                toggles["Auto Play V2"].SetState(false)
            end
        end
        if state.autoPlayV3On then
            stopAutoPlayV3()
            updateAutoPlayV3UIState()
            C.autoPlayV3Direct = false save(C)
            if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
                toggles["Auto Play V3"].SetState(false)
            end
        end
        startAutoPlay()
        updateAutoPlayUIState()
        task.spawn(function()
            while state.autoPlayOn do task.wait(0.1) end
            updateAutoPlayUIState()
            C.autoPlayDirect = false save(C)
            if toggles["Auto Play"] and toggles["Auto Play"].GetState() then
                toggles["Auto Play"].SetState(false)
            end
        end)
    end
end)

-- ==========================================
-- VISIBILITY WATCHERS
-- ==========================================
RS.Heartbeat:Connect(function()
    lockUIFrame.Visible = C.lockUI
    infoBar.Visible = C.showInfoUI
    autoPlayUIFrame.Visible = C.autoPlayUI
    autoPlayV2UIFrame.Visible = C.autoPlayV2UI
    autoPlayV3UIFrame.Visible = C.autoPlayV3UI
    updateASStatus()
end)

-- ==========================================
-- INIT AUTO LOAD
-- ==========================================
task.spawn(function()
    task.wait(2)
    if C.antiRag then toggleAntiRag(true) end
    if C.esp then toggleESP(true) end
    if C.xray then toggleXray(true) end
    if C.optimizer then toggleOptimizer(true) end
    if C.infJump then toggleInfJump(true) end
    if C.spinbot then toggleSpinbot(true) end
    if C.batAimbot then toggleBatAimbot(true) end
    if C.lockPlayer then toggleLockPlayer(true) end
    if C.unwalk then toggleUnwalk(true) end
    if C.autoSteal then toggleAutoSteal(true) end
    if C.gravity then toggleGravity(true) end
    if C.jumpBoost then toggleJumpBoost(true) end
    if C.autoLockPlayer then toggleAutoLockPlayer(true) end
    if C.moveSpeed then toggleMoveSpeed(true) end
    if C.stealSpeed then toggleStealSpeed(true) end
    if C.moveSpeed or C.stealSpeed then startStealDetect() end
end)

-- ==========================================
-- RESPAWN HANDLER
-- ==========================================
LP.CharacterAdded:Connect(function()
    task.wait(1)
    state.stealing = false
    state.wasMoveBefore = false
    state.stealActive = false
    state.stealStart = nil
    state.cachedBat = nil
    state.cachedBat2 = nil
    isStealingAS = false

    captureJumpPower()

    if state.autoPlayOn then stopAutoPlay() updateAutoPlayUIState() end
    if state.autoPlayV2On then stopAutoPlayV2() updateAutoPlayV2UIState() end
    if state.autoPlayV3On then stopAutoPlayV3() updateAutoPlayV3UIState() end

    if C.autoPlayDirect then
        C.autoPlayDirect = false save(C)
        if toggles["Auto Play"] and toggles["Auto Play"].GetState() then
            toggles["Auto Play"].SetState(false)
        end
    end
    if C.autoPlayV2Direct then
        C.autoPlayV2Direct = false save(C)
        if toggles["Auto Play V2"] and toggles["Auto Play V2"].GetState() then
            toggles["Auto Play V2"].SetState(false)
        end
    end
    if C.autoPlayV3Direct then
        C.autoPlayV3Direct = false save(C)
        if toggles["Auto Play V3"] and toggles["Auto Play V3"].GetState() then
            toggles["Auto Play V3"].SetState(false)
        end
    end

    local reloads = {
        {C.esp, function() toggleESP(false) task.wait(0.1) toggleESP(true) end},
        {C.antiRag, function() toggleAntiRag(false) task.wait(0.1) toggleAntiRag(true) end},
        {C.lockPlayer, function() toggleLockPlayer(false) task.wait(0.1) toggleLockPlayer(true) end},
        {C.batAimbot, function() toggleBatAimbot(false) task.wait(0.1) toggleBatAimbot(true) end},
        {C.spinbot, function() toggleSpinbot(false) task.wait(0.1) toggleSpinbot(true) end},
        {C.autoSteal, function() toggleAutoSteal(false) task.wait(0.1) toggleAutoSteal(true) end},
        {C.infJump, function() toggleInfJump(false) task.wait(0.1) toggleInfJump(true) end},
        {C.gravity, function() toggleGravity(false) task.wait(0.1) toggleGravity(true) end},
        {C.xray, function() toggleXray(true) end},
        {C.optimizer, function() toggleOptimizer(false) task.wait(0.1) toggleOptimizer(true) end},
        {C.autoLockPlayer, function() toggleAutoLockPlayer(false) task.wait(0.1) toggleAutoLockPlayer(true) end},
    }
    for _, r in ipairs(reloads) do if r[1] then r[2]() end end
    if C.moveSpeed or C.stealSpeed then
        startStealDetect()
        if C.moveSpeed and not state.stealing then toggleMoveSpeed(true) end
        if C.stealSpeed and state.stealing then toggleStealSpeed(true) end
    end
end)

-- ==========================================
-- CLEANUP
-- ==========================================
SG.Destroying:Connect(function()
    for k, c in pairs(conn) do if c then pcall(function() c:Disconnect() end) end end
    clearESP()
    if state.espFolder then state.espFolder:Destroy() end
    destroyCircle()
    stopBatAimbot()
    stopAutoPlay()
    stopAutoPlayV2()
    stopAutoPlayV3()
    stopAutoPlaysSpeed()
    if C.xray then toggleXray(false) end
    if C.optimizer then toggleOptimizer(false) end
    if state.galaxyVectorForce then state.galaxyVectorForce:Destroy() end
    if state.galaxyAttachment then state.galaxyAttachment:Destroy() end
    local c = getChar()
    if c then
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            local b = hrp:FindFirstChild("SpinBAV")
            if b then b:Destroy() end
        end
    end
    if lockUIFrame then lockUIFrame:Destroy() end
    if autoPlayUIFrame then autoPlayUIFrame:Destroy() end
    if autoPlayV2UIFrame then autoPlayV2UIFrame:Destroy() end
    if autoPlayV3UIFrame then autoPlayV3UIFrame:Destroy() end
    if asPanel then asPanel:Destroy() end
    if infoBar then infoBar:Destroy() end
    if floatBtn then floatBtn:Destroy() end
    if fpsBar then fpsBar:Destroy() end
end)

-- ==========================================
-- INITIAL SETUP
-- ==========================================
task.spawn(function()
    task.wait(0.5)
    leftCol.CanvasSize = UDim2.new(0, 0, 0, leftLay.AbsoluteContentSize.Y + 10)
    rightCol.CanvasSize = UDim2.new(0, 0, 0, rightLay.AbsoluteContentSize.Y + 10)
    print("[HONEY DUELS] V3.4 MODIFIED FIXED loaded")
end)