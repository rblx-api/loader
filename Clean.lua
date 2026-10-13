-- Leaked by migisito(bless.vs owner)
-- https://discord.gg/XeQU4jGFwb
-- ============================================================
-- CLEAN HUB - SCRIPT COMPLETO MEJORADO
-- ============================================================

repeat task.wait() until game:IsLoaded()

local Players, RunService, UIS, TS, Lighting, HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
local LP = Players.LocalPlayer

local NS, CS = 60, 30
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode, antiRagdollEnabled, infJumpEnabled = false, false, false
local laggerToggled = false
local laggerCarryToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
local medusaResetEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce, medusaLastUsed, dropActive = false, 0, false
local autoLeftEnabled, autoRightEnabled = false, false
local autoLeftSetVisual, autoRightSetVisual = nil, nil
local tpLockEnabled = false
local tpLockSetVisual = nil
local batV2Enabled = false
local batV2SetVisual = nil
local setBatCounterVisual = nil
local startBatCounter, stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local antiLagDescConn = nil
local stretchRezEnabled = false
local stretchRezConn = nil
local setStretchRezVisual = nil
local espEnabled = false

-- Configuración ESP
local espBoxBaseWidth = 70
local espBoxBaseHeight = 100
local espScaleFactor = 25
local espMinScale = 0.4
local espMaxScale = 1.6

local unwalkSavedAnimate = nil
local _anyKeyListening = false
local _lastKbSet = 0
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local setAutoTPVisual = nil
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local setInfJumpVisual = nil
local mainFrame = nil
local bgImage = nil
local progressFill = nil
local progressPct = nil
local stealBarFrame = nil
local _guiLocked = false

-- ============================================================
-- COLOR MORADO GLOBAL (reemplaza todos los rojos)
-- ============================================================
local PURPLE = Color3.fromRGB(150, 50, 255)
local PURPLE_LIGHT = Color3.fromRGB(180, 100, 255)
local PURPLE_DARK = Color3.fromRGB(100, 30, 180)
local PURPLE_GLOW = Color3.fromRGB(200, 120, 255)

setCarryVisual = nil
setLaggerVisual = nil
setAutoSwingVisual = nil
setBatCounterVisual = nil
setAntiRagVisual = nil
setMedusaVisual = nil
setMedusaResetVisual = nil
setUnwalkVisual = nil
setAntiLagVisual = nil
setStretchRezVisual = nil
setAutoTPVisual = nil
setSaturationVisual = nil
setVoidModeVisual = nil
setStretchRezV2Visual = nil
setTranspVisual = nil
setLockVisual = nil
setMobVisual = nil
setCircleBtnsVisual = nil
setShapeVisual = nil
setRectVisual = nil
setInstaGrab = nil
setInfJumpVisual = nil
setEspVisual = nil
local startESP, stopESP

local uiScaleValue = 0.6
local uiScaleObject = nil

local TOGGLE_ON_COLOR = PURPLE
local TOGGLE_OFF_COLOR = Color3.fromRGB(10, 30, 90)

local tpLockConn = nil
local tpLockPrevAutoRotate = nil
local tpLockHitCD = false
local TP_LOCK_SWING_CD = 0.08

-- esp, muestra highlight + nombre + linea a cada jugador
do
	local _espEnabled  = false
	local _espConn     = nil
	local _espLastRun  = 0
	local _hlCache     = {}
	local _bbCache     = {}
	local _trCache     = {}

	local function clearESP()
	    for _, hl in pairs(_hlCache) do pcall(function() hl:Destroy() end) end
	    _hlCache = {}
	    for _, bb in pairs(_bbCache) do pcall(function() bb:Destroy() end) end
	    _bbCache = {}
	    for _, lines in pairs(_trCache) do
	        for _, ln in ipairs(lines) do
	            pcall(function() ln.Visible = false; ln:Remove() end)
	        end
	    end
	    _trCache = {}
	end

	local function _espMakeBillboard(head)
	    local bb = Instance.new("BillboardGui")
	    bb.Name        = "CleanDuelsESPBB"
	    bb.Size        = UDim2.new(0, 110, 0, 18)
	    bb.StudsOffset = Vector3.new(0, 3.2, 0)
	    bb.AlwaysOnTop = true
	    bb.LightInfluence = 0
	    bb.Adornee     = head
	    bb.Parent      = head
	    local lbl = Instance.new("TextLabel", bb)
	    lbl.Size                   = UDim2.new(1, 0, 1, 0)
	    lbl.BackgroundTransparency = 1
	    lbl.Font                   = Enum.Font.GothamBold
	    lbl.TextSize               = 11
	    lbl.TextColor3             = PURPLE
	    lbl.TextStrokeTransparency = 0.3
	    lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
	    lbl.TextXAlignment         = Enum.TextXAlignment.Center
	    lbl.TextTruncate           = Enum.TextTruncate.AtEnd
	    return bb, lbl
	end

	local function _espMakeTracers()
	    if not (Drawing and type(Drawing.new) == "function") then return nil end
	    local outer = Drawing.new("Line")
	    outer.Color        = PURPLE
	    outer.Thickness    = 2.2
	    outer.Transparency = 0.88
	    outer.Visible      = false
	    local mid = Drawing.new("Line")
	    mid.Color        = PURPLE
	    mid.Thickness    = 1.2
	    mid.Transparency = 0.72
	    mid.Visible      = false
	    local core = Drawing.new("Line")
	    core.Color        = PURPLE
	    core.Thickness    = 0.6
	    core.Transparency = 0.10
	    core.Visible      = false
	    return {outer, mid, core}
	end

	local function _espUpdate()
	    local now = tick()
	    if now - _espLastRun < 0.03 then return end
	    _espLastRun = now
	    if not _espEnabled then clearESP(); return end
	    local myChar = LP.Character
	    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	    if not myRoot then return end
	    local cam = workspace.CurrentCamera
	    local mySP, myOn = cam:WorldToViewportPoint(myRoot.Position)
	    local myVec = Vector2.new(mySP.X, mySP.Y)
	    local plrSet = {}
	    for _, p in ipairs(Players:GetPlayers()) do plrSet[p] = true end
			-- borrar jugadores que ya no estan
	    for plr in pairs(_hlCache) do
	        if not plrSet[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr] = nil end
	    end
	    for plr in pairs(_bbCache) do
	        if not plrSet[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr] = nil end
	    end
	    for plr in pairs(_trCache) do
	        if not plrSet[plr] then
	            for _, ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible=false; ln:Remove() end) end
	            _trCache[plr] = nil
	        end
	    end
			-- revisar a cada jugador
	    for _, plr in ipairs(Players:GetPlayers()) do
	        if plr == LP then continue end
	        local char = plr.Character
	        if not char then
	            if _hlCache[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr] = nil end
	            if _bbCache[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr] = nil end
	            if _trCache[plr] then for _, ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible=false end) end end
	            continue
	        end
	        local tRoot = char:FindFirstChild("HumanoidRootPart")
	        local tHead = char:FindFirstChild("Head")
	        local tHum  = char:FindFirstChildOfClass("Humanoid")
	        if tRoot and tHead and tHum and tHum.Health > 0 then
				-- ponerle el highlight
	            local hl = _hlCache[plr]
	            if not hl or not hl.Parent or hl.Parent ~= char then
	                if hl then pcall(function() hl:Destroy() end) end
	                hl = Instance.new("Highlight")
	                hl.Name                = "CleanDuelsESP"
	                hl.FillColor           = PURPLE
	                hl.FillTransparency    = 0.62
	                hl.OutlineColor        = PURPLE
	                hl.OutlineTransparency = 0
	                hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
	                hl.Adornee             = char
	                hl.Parent              = char
	                _hlCache[plr]          = hl
	            end
				-- mostrar su nombre arriba
	            local bb = _bbCache[plr]
	            if not bb or not bb.Parent or bb.Adornee ~= tHead then
	                if bb then pcall(function() bb:Destroy() end) end
	                local newBB, lbl = _espMakeBillboard(tHead)
	                lbl.Text      = plr.DisplayName
	                _bbCache[plr] = newBB
	            end
				-- dibujar la linea hacia el
	            local espLines = _trCache[plr]
	            if not espLines then
	                espLines = _espMakeTracers()
	                _trCache[plr] = espLines or {}
	            end
	            if espLines and #espLines > 0 then
	                local sp, on = cam:WorldToViewportPoint(tRoot.Position)
	                if on and sp.Z > 0 and myOn then
	                    local tv = Vector2.new(sp.X, sp.Y)
	                    for _, ln in ipairs(espLines) do ln.From=myVec; ln.To=tv; ln.Visible=true end
	                else
	                    for _, ln in ipairs(espLines) do ln.Visible=false end
	                end
	            end
	        else
	            if _hlCache[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr] = nil end
	            if _bbCache[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr] = nil end
	            if _trCache[plr] then for _, ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible=false end) end end
	        end
	    end
	end

	startESP = function()
	    if _espEnabled then return end
	    _espEnabled = true
	    if _espConn then _espConn:Disconnect() end
	    _espConn = RunService.RenderStepped:Connect(_espUpdate)
	end

	stopESP = function()
	    if not _espEnabled then return end
	    _espEnabled = false
	    if _espConn then _espConn:Disconnect(); _espConn = nil end
	    clearESP()
	end
end

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs({"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs({"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

local function getClosestPlayer()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            if tRoot then
                local d = (tRoot.Position - root.Position).Magnitude
                if d < minDist then minDist = d; closest = plr end
            end
        end
    end
    return closest, minDist
end

local function tpLockTryHit()
    if tpLockHitCD then return end
    tpLockHitCD = true
    pcall(function()
        local char = LP.Character
        if char then
            local bat = findBat()
            if bat then
                if bat.Parent ~= char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:EquipTool(bat) end) end
                end
                pcall(function() bat:Activate() end)
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then pcall(function() ev:FireServer() end) end
            end
        end
    end)
    task.delay(TP_LOCK_SWING_CD, function() tpLockHitCD = false end)
end

local function startTPLock()
    if tpLockConn then tpLockConn:Disconnect() end
    if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
    if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
    if batV2Enabled then toggleBatV2() end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        if tpLockPrevAutoRotate == nil then tpLockPrevAutoRotate = hum.AutoRotate end
        hum.AutoRotate = false
    end
    tpLockConn = RunService.Heartbeat:Connect(function()
        if not tpLockEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target, targetDist = getClosestPlayer()
        if not target then return end
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not tRoot then return end

        if sethiddenproperty then
            pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", tRoot) end)
        end
        local targetPos = tRoot.Position + Vector3.new(0, 0.9, 0)
        if (root.Position - targetPos).Magnitude > 8 then
            root.CFrame = CFrame.new(targetPos)
        end
        workspace.CurrentCamera.CFrame = CFrame.new(
            workspace.CurrentCamera.CFrame.Position, tRoot.Position
        )
        tpLockTryHit()
    end)
end

local function stopTPLock()
    if tpLockConn then tpLockConn:Disconnect(); tpLockConn = nil end
    tpLockHitCD = false
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if sethiddenproperty then pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", nil) end) end
    end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (tpLockPrevAutoRotate == nil) and true or tpLockPrevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    tpLockPrevAutoRotate = nil
end

local function toggleTPLock()
    tpLockEnabled = not tpLockEnabled
    if tpLockEnabled then
        startTPLock()
        if tpLockSetVisual then tpLockSetVisual(true) end
        if mobBtnRefs.tpLock then mobBtnRefs.tpLock(true) end
    else
        stopTPLock()
        if tpLockSetVisual then tpLockSetVisual(false) end
        if mobBtnRefs.tpLock then mobBtnRefs.tpLock(false) end
    end
    return tpLockEnabled
end

-- ============================================================
-- BAT V2
-- ============================================================
local AUTO_BAT_V2_SPEED = 60
local AUTO_BAT_V2_DIST = 1.0
local AUTO_BAT_V2_HEIGHT = 1.5
local AUTO_BAT_V2_V_OFF = 0.0
local AUTO_BAT_V2_HIT_DIST = 4.5
local AUTO_BAT_V2_SWING_CD = 0.08

local autoBatV2HitCooldown = false
local batV2Conn = nil
local batV2PrevAutoRotate = nil

local function _v2FindBat()
    local c = LP.Character
    if c then
        for _, v in ipairs(c:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, v in ipairs(bp:GetChildren()) do
            if v:IsA("Tool") then return v end
        end
    end
    return nil
end

local function _v2GetClosest()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, math.huge end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then bestDist = d; closest = p end
            end
        end
    end
    return closest, bestDist
end

local function _v2TrySwing()
    if autoBatV2HitCooldown or not autoSwingEnabled then return end
    autoBatV2HitCooldown = true
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tool = _v2FindBat()
        if tool then
            if tool.Parent ~= char and hum then
                pcall(function() hum:EquipTool(tool) end)
            end
            local remote = tool:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() tool:Activate() end)
            end
        end
    end
    task.delay(AUTO_BAT_V2_SWING_CD, function()
        autoBatV2HitCooldown = false
    end)
end

local function startBatV2()
    if batV2Conn then return end


    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
    end
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
    end
    if tpLockEnabled then
        toggleTPLock()
    end

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if batV2PrevAutoRotate == nil then batV2PrevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end

    batV2Conn = RunService.Heartbeat:Connect(function()
        if not batV2Enabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local target, dist = _v2GetClosest()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVel = targetRoot.AssemblyLinearVelocity or targetRoot.Velocity
                local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                local offset = moveDir * AUTO_BAT_V2_DIST + Vector3.new(0, AUTO_BAT_V2_HEIGHT + AUTO_BAT_V2_V_OFF, 0)
                local desiredPos = targetRoot.Position + offset
                local toTarget = desiredPos - root.Position

                if toTarget.Magnitude > 0.5 then
                    local moveVec = toTarget.Unit * AUTO_BAT_V2_SPEED
                    root.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end

                local distToTarget = (root.Position - targetRoot.Position).Magnitude
                if distToTarget <= AUTO_BAT_V2_HIT_DIST then
                    _v2TrySwing()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

local function stopBatV2()
    if batV2Conn then
        batV2Conn:Disconnect()
        batV2Conn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
    end
    autoBatV2HitCooldown = false
    local hum0 = c and c:FindFirstChildOfClass("Humanoid")
    if hum0 then
        hum0.AutoRotate = (batV2PrevAutoRotate == nil) and true or batV2PrevAutoRotate
        hum0.PlatformStand = false
        pcall(function() hum0:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    batV2PrevAutoRotate = nil
end

function toggleBatV2()
    batV2Enabled = not batV2Enabled
    if batV2Enabled then
        startBatV2()
        if batV2SetVisual then batV2SetVisual(true) end
        if mobBtnRefs.batV2 then mobBtnRefs.batV2(true) end
    else
        stopBatV2()
        if batV2SetVisual then batV2SetVisual(false) end
        if mobBtnRefs.batV2 then mobBtnRefs.batV2(false) end
    end
    saveConfig()
    return batV2Enabled
end

bodyLockEnabled   = false
bodyLockRange     = 40
_bodyLockConn     = nil
bodyLockSetVisual = nil

function _bodyLockGetTarget()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local closest, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health > 0 then
                local d = (hrp.Position - tr.Position).Magnitude
                if d < bestDist then bestDist = d; closest = tr end
            end
        end
    end
    return closest
end

function _bodyLockTick()
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum  = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    if hum.FloorMaterial == Enum.Material.Air then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local target = _bodyLockGetTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if (target.Position - root.Position).Magnitude > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local vel  = target.AssemblyLinearVelocity
    local pt   = math.clamp(vel.Magnitude / 150, 0.05, 0.2)
    local pred = target.Position + vel * pt
    local toP  = pred - root.Position
    if toP.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, pred)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    _bodyLockConn = RunService.RenderStepped:Connect(function()
        if not bodyLockEnabled then return end
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    local c    = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function toggleBodyLock()
    bodyLockEnabled = not bodyLockEnabled
    if bodyLockEnabled then
        startBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(true) end
    else
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
    end
    saveConfig()
end

local mobileButtonsEnabled = true
local mobileButtonsSize = 80
local circleButtonsEnabled = false
local shapeButtonsEnabled = false
local rectangularButtonsEnabled = false
local mobBtnRefs = {}
local mobGuiRef = nil
local infJumpMode = "manual"
local holdInfJumpConn = nil
local uiLocked = false
local perButtonDragEnabled = true

local BTN_OFF = Color3.fromRGB(0, 0, 0)
local BTN_ON = PURPLE
local TEXT_OFF = PURPLE
local TEXT_ON = Color3.fromRGB(0, 0, 0)

local KB = {
    DropBrainrot  = {kb = Enum.KeyCode.X,           gp = nil},
    AutoLeft      = {kb = Enum.KeyCode.Z,           gp = nil},
    AutoRight     = {kb = Enum.KeyCode.C,           gp = nil},
    TPLock        = {kb = Enum.KeyCode.E,           gp = nil},
    TPFloor       = {kb = Enum.KeyCode.F,           gp = nil},
    GuiHide       = {kb = Enum.KeyCode.LeftControl, gp = nil},
    SpeedToggle   = {kb = Enum.KeyCode.Q,           gp = nil},
    LaggerToggle  = {kb = Enum.KeyCode.R,           gp = nil},
    InstaReset    = {kb = Enum.KeyCode.G,           gp = nil},
    BatV2Toggle   = {kb = Enum.KeyCode.V,           gp = nil}
}

local function isGamepadInput(inp)
    if not inp then return false end
    if inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") then return true end
    return false
end

local function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp)
end

local CONTROLLER_BUTTONS = {
    [Enum.KeyCode.ButtonA]      = "A",       [Enum.KeyCode.ButtonB]      = "B",
    [Enum.KeyCode.ButtonX]      = "X",       [Enum.KeyCode.ButtonY]      = "Y",
    [Enum.KeyCode.ButtonL1]     = "LB",      [Enum.KeyCode.ButtonR1]     = "RB",
    [Enum.KeyCode.ButtonL2]     = "LT",      [Enum.KeyCode.ButtonR2]     = "RT",
    [Enum.KeyCode.ButtonL3]     = "LS",      [Enum.KeyCode.ButtonR3]     = "RS",
    [Enum.KeyCode.ButtonStart]  = "START",   [Enum.KeyCode.ButtonSelect] = "SELECT",
    [Enum.KeyCode.DPadUp]       = "DPAD_UP", [Enum.KeyCode.DPadLeft]     = "DPAD_LEFT",
    [Enum.KeyCode.DPadRight]    = "DPAD_RIGHT"
}

local function getKeyDisplayName(key, isGp)
    if isGp and CONTROLLER_BUTTONS[key] then return CONTROLLER_BUTTONS[key] end
    return key and key.Name or "None"
end

local function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local laggerState = {enabled = false, thread = nil, waitTime = 0.25, intensity = 270}
local isTouchEnabled = UIS.TouchEnabled
if isTouchEnabled then laggerState.waitTime = 5.8 end
local _laggerActive = false

local function createNestedTable(amount)
    local nested = {{}}; local current = nested[1]
    for i = 1, amount do local t = {}; table.insert(current, t); current = t end
    return nested
end

local function sendLagSpam()
    local nested = createNestedTable(laggerState.intensity)
    local payload = {}
    local maxCopies = math.min(499999 / (laggerState.intensity + 2), 1500)
    for i = 1, maxCopies do table.insert(payload, nested) end
    pcall(function()
        local r = game:GetService("RobloxReplicatedStorage"):FindFirstChild("SetPlayerBlockList")
        if r then r:FireServer(payload) end
    end)
end

local function removeNetworkLimit()
    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
end

local function startLaggerEngine()
    if laggerState.thread then task.cancel(laggerState.thread); laggerState.thread = nil end
    laggerState.enabled = true
    laggerState.thread = task.spawn(function()
        while laggerState.enabled do removeNetworkLimit(); sendLagSpam(); task.wait(laggerState.waitTime) end
    end)
end

local function stopLaggerEngine()
    laggerState.enabled = false
    if laggerState.thread then task.cancel(laggerState.thread); laggerState.thread = nil end
end

local AP_L1, AP_L2 = Vector3.new(-476.47,-6.28,92.73), Vector3.new(-483.12,-4.95,94.81)
local AP_R1, AP_R2 = Vector3.new(-476.16,-6.52,25.62), Vector3.new(-483.06,-5.03,25.48)

local function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

local function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED else return NS end
end

local function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

local function refreshSpeedModeLabel()
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerToggled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryToggled) end
end

local function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; laggerPhase = 0; speedMode = true
    else speedMode = not speedMode end
    refreshSpeedModeLabel()
end

local function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    laggerPhase = laggerToggled and 1 or 0
    refreshSpeedModeLabel()
end

local function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false; laggerPhase = 0 end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    if laggerCarryToggled then laggerPhase = 2 else laggerPhase = 0 end
    refreshSpeedModeLabel()
end

-- anti ragdoll, evita que te quedes tirado en el suelo
local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdoll()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        local state = hum:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdoll()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
end

-- contador visual encima de tu cabeza cuando te ragdollean
do
    local _ragCountdownRunning = false

    local function _getRagBillboard()
        local char = LP.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        local pGui = LP.PlayerGui
        local existing = pGui:FindFirstChild("RagCountdownBillboard")
        if existing then existing:Destroy() end
        local bb = Instance.new("BillboardGui")
        bb.Name = "RagCountdownBillboard"
        bb.Size = UDim2.new(0, 84, 0, 42)
        bb.StudsOffset = Vector3.new(0, 0.5, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = head
        bb.Parent = pGui
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.AnchorPoint = Vector2.new(0.5, 0.5)
        lbl.Position = UDim2.new(0.5, 0, 0.5, 0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextScaled = true
        lbl.TextColor3 = PURPLE
        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        lbl.TextStrokeTransparency = 0
        lbl.Text = ""
        lbl.Parent = bb
        return bb, lbl
    end

    local function _startRagCountdown()
        if _ragCountdownRunning then return end
        _ragCountdownRunning = true
        task.spawn(function()
            local bb, lbl = _getRagBillboard()
            if not bb then _ragCountdownRunning = false; return end
            local timeLeft = 2.5
            local step     = 0.1
            while timeLeft > 0 and bb.Parent do
                if lbl and lbl.Parent then lbl.Text = string.format("%.1f", timeLeft) end
                task.wait(step)
                timeLeft = timeLeft - step
            end
            if bb and bb.Parent then
                if lbl and lbl.Parent then lbl.Text = "READY!" end
                task.wait(0.5)
                if bb and bb.Parent then bb:Destroy() end
            end
            _ragCountdownRunning = false
        end)
    end

    local _wasRagdolled = false
    RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then _wasRagdolled = false; return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then _wasRagdolled = false; return end
        local st = hum:GetState()
        local inRag = st == Enum.HumanoidStateType.Physics
                   or st == Enum.HumanoidStateType.Ragdoll
                   or st == Enum.HumanoidStateType.FallingDown
        if inRag and not _wasRagdolled then
            _wasRagdolled = true
            _startRagCountdown()
        elseif not inRag then
            _wasRagdolled = false
        end
    end)
end


pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire = hookfunction(Instance.new("RemoteEvent").FireServer, newcclosure(function(self, ...)
            if not cursedResetRemote and typeof(self) == "Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3) == "RE/" then
                cursedResetRemote = self
            end
            return oldFire(self, ...)
        end))
    end
end)

task.spawn(function()
    task.wait(2)
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then cursedResetRemote = desc; break end
    end
end)

function cursedInstaReset()
    if not cursedResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then cursedResetRemote = desc; break end
        end
    end
    if not cursedResetRemote then return end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health <= 0 then
        pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end); return
    end
    local resetDetected = false; local conns = {}
    if humanoid then
        table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
        table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then resetDetected = true end
        end))
    end
    if character then
        table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
            if not parent then resetDetected = true end
        end))
    end
    task.spawn(function()
        for _ = 1, 50 do
            if resetDetected then break end
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
            task.wait()
        end
        for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local Steal = {
    AutoStealEnabled = false,
    StealRadius = 63,
    StealDuration = 1.3,
}
local isStealing = false
local stealStartTime = nil
local lastStealTick = 0
local Conns = {autoSteal = nil, antiRag = nil, batCounter = nil, anchor = {}}

local function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function updateProgressBar(pct)
    if not progressFill or not progressPct then return end
    pct = math.clamp(pct or 0, 0, 1)
    progressFill.Size = UDim2.new(pct, 0, 1, 0)
    progressPct.Text = math.floor(pct * 100) .. "%"
end

local startAutoSteal = function() end
local stopAutoSteal  = function() end

task.spawn(function()
    local RS = game:GetService("ReplicatedStorage")
    local ok, Packages = pcall(function() return RS:WaitForChild("Packages") end)
    if not ok or not Packages then return end
    local ok, Datas = pcall(function() return RS:WaitForChild("Datas") end)
    if not ok or not Datas then return end
    local ok, AnimMod = pcall(function() return Datas:WaitForChild("Animals") end)
    if not ok or not AnimMod then return end
    local ok, AnimalsData = pcall(require, AnimMod)
    if not ok or not AnimalsData then return end
    local ok, plots = pcall(function() return workspace:WaitForChild("Plots") end)
    if not ok or not plots then return end
    local ok, SyncFolder = pcall(function() return Packages:WaitForChild("Synchronizer") end)
    if not ok or not SyncFolder then return end
    local syncRemotes = {
        channelFolder = SyncFolder:WaitForChild("Channel"),
        routeRemote   = SyncFolder:WaitForChild("CommunicationRoute"),
        requestData   = SyncFolder:FindFirstChild("RequestData"),
    }

    local plotAnimalSync = {caches = {}, connections = {}}

    local function splitSyncPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end

    local function resolveSyncPath(path, root)
        local current, parent, key = root, nil, nil
        for _, part in ipairs(splitSyncPath(path)) do
            parent = current; key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end

    local function applyPlotSyncDiff(channelName, packet)
        local cache = plotAnimalSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolveSyncPath(path, cache)
        if     action == "Changed"           then if parent  then parent[key] = a end
        elseif action == "ArrayInsert"       then if current then table.insert(current, b, a) end
        elseif action == "ArrayRemoved"      then if current then table.remove(current, b) end
        elseif action == "DictionaryInsert"  then if current then current[b] = a end
        elseif action == "DictionaryRemoved" then if current then current[b] = nil end
        end
    end

    local function attachPlotChannel(remote)
        if plotAnimalSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
            local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
            plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif plotAnimalSync.caches[channelName] == nil then
            plotAnimalSync.caches[channelName] = {}
        end
        plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
        end)
    end

    local function detachPlotChannel(channelName)
        for remote, conn in pairs(plotAnimalSync.connections) do
            if tostring(remote.Name) == tostring(channelName) then
                conn:Disconnect()
                plotAnimalSync.connections[remote] = nil
                plotAnimalSync.caches[tostring(channelName)] = nil
                break
            end
        end
    end

    for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end
    syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then attachPlotChannel(child) end
    end)
    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
            local kind, ch = action[1], tostring(action[2])
            if not plots:FindFirstChild(ch) then continue end
            if kind == "ListenerAdded" then
                local r = syncRemotes.channelFolder:FindFirstChild(ch)
                if r and r:IsA("RemoteEvent") then attachPlotChannel(r) end
            elseif kind == "ListenerRemoved" then
                detachPlotChannel(ch)
            end
        end
    end)

    local function getPlotChannelData(plotName) return plotAnimalSync.caches[plotName] end

    local allAnimalsCache  = {}
    local PromptMemoryCache = {}
    local InternalStealCache = {}
    local stealConnection    = nil
    local stealProgressConn  = nil

    local StealState = {
        active = false, startTime = 0, phase = "idle", label = "",
        lastResult = "", lastResultTime = 0, totalSteals = 0, failedSteals = 0,
    }

    local HOLD_MIN = 1.3
    local HOLD_MAX = 2.6
    local ENTRY_DELAY = 0.3
    local STEAL_RANGE = 10
    local STEAL_COOLDOWN = 0.05

    local function getPlotOwner(plot)
        local sign  = plot:FindFirstChild("PlotSign"); if not sign then return nil end
        local sGui  = sign:FindFirstChild("SurfaceGui"); if not sGui then return nil end
        local frame = sGui:FindFirstChild("Frame"); if not frame then return nil end
        local lbl   = frame:FindFirstChild("TextLabel")
        if not lbl or lbl.Text == "Empty Base" then return nil end
        return lbl.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end

    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot then return false end
        local plot = plots:FindFirstChild(animalData.plot); if not plot then return false end
        return getPlotOwner(plot) == LP.DisplayName
    end

    local function findProximityPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = PromptMemoryCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local plot    = plots:FindFirstChild(animalData.plot);      if not plot    then return nil end
        local podiums = plot:FindFirstChild("AnimalPodiums");        if not podiums then return nil end
        local podium  = podiums:FindFirstChild(animalData.slot);     if not podium  then return nil end
        local base    = podium:FindFirstChild("Base");               if not base    then return nil end
        local spawn   = base:FindFirstChild("Spawn");                if not spawn   then return nil end
        local attach  = spawn:FindFirstChild("PromptAttachment");    if not attach  then return nil end
        for _, p in ipairs(attach:GetChildren()) do
            if p:IsA("ProximityPrompt") then PromptMemoryCache[animalData.uid] = p; return p end
        end
        return nil
    end

    local function getAnimalPosition(animalData)
        local plot    = plots:FindFirstChild(animalData.plot);      if not plot    then return nil end
        local podiums = plot:FindFirstChild("AnimalPodiums");        if not podiums then return nil end
        local podium  = podiums:FindFirstChild(animalData.slot);     if not podium  then return nil end
        return podium:GetPivot().Position
    end

    local function distToAnimal(animalData)
        local char = LP.Character; if not char then return math.huge end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
        if not hrp then return math.huge end
        local pos = getAnimalPosition(animalData); if not pos then return math.huge end
        return (hrp.Position - pos).Magnitude
    end

    local function pickClosest()
        local char = LP.Character; if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
        if not hrp then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(allAnimalsCache) do
            if isMyBaseAnimal(animalData) then continue end
            local pos = getAnimalPosition(animalData); if not pos then continue end
            local dist = (hrp.Position - pos).Magnitude
            if dist > Steal.StealRadius then continue end
            if dist < bestDist then bestDist = dist; best = animalData end
        end
        return best
    end

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if ok1 and type(conns1) == "table" then
            for _, conn in ipairs(conns1) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local ok2, conns2 = pcall(getconnections, prompt.Triggered)
        if ok2 and type(conns2) == "table" then
            for _, conn in ipairs(conns2) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
            InternalStealCache[prompt] = data
        end
    end

    local function executeStealAsync(prompt, animalData)
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false

        local label = animalData.name or "Animal"
        StealState.active    = true
        StealState.startTime = tick()
        StealState.phase     = "holding"
        StealState.label     = label
        isStealing           = true

        if stealProgressConn then stealProgressConn:Disconnect() end
        stealProgressConn = RunService.Heartbeat:Connect(function()
            if not isStealing then
                if stealProgressConn then stealProgressConn:Disconnect(); stealProgressConn = nil end
                return
            end
            updateProgressBar(math.clamp((tick() - StealState.startTime) / HOLD_MAX, 0, 1))
        end)

        task.spawn(function()
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
            task.wait(HOLD_MIN)
            StealState.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= STEAL_RANGE
            local fired = false
            while true do
                if tick() - StealState.startTime > HOLD_MAX then break end
                if not prompt.Parent then break end
                if distToAnimal(animalData) <= STEAL_RANGE then
                    if not alreadyInRange then task.wait(ENTRY_DELAY) end
                    for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                    fired = true; break
                end
                task.wait()
            end
            if fired then
                StealState.totalSteals  = StealState.totalSteals + 1
                StealState.lastResult   = "Stole " .. label
            else
                StealState.failedSteals = StealState.failedSteals + 1
                StealState.lastResult   = "Missed: " .. label
            end
            StealState.active         = false
            StealState.phase          = "idle"
            StealState.lastResultTime = tick()
            isStealing = false
            if stealProgressConn then stealProgressConn:Disconnect(); stealProgressConn = nil end
            resetProgressBar()
            task.wait(STEAL_COOLDOWN)
            data.ready = true
        end)
        return true
    end

    local function attemptSteal(prompt, animalData)
        if not prompt or not prompt.Parent then return false end
        buildStealCallbacks(prompt)
        if not InternalStealCache[prompt] then return false end
        return executeStealAsync(prompt, animalData)
    end

    local function scanAllPlots()
        local newCache = {}
        for _, plot in ipairs(plots:GetChildren()) do
            local cache = getPlotChannelData(plot.Name); if not cache then continue end
            local animalList = cache.AnimalList; if typeof(animalList) ~= "table" then continue end
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local animalInfo = AnimalsData[animalName]; if not animalInfo then continue end
                    table.insert(newCache, {
                        name = animalInfo.DisplayName or animalName,
                        plot = plot.Name,
                        slot = tostring(slot),
                        uid  = plot.Name .. "_" .. tostring(slot),
                    })
                end
            end
        end
        allAnimalsCache = newCache
        return #allAnimalsCache
    end

    startAutoSteal = function()
        if stealConnection then return end
        stealConnection = RunService.Heartbeat:Connect(function()
            if not Steal.AutoStealEnabled or StealState.active then return end
            local target = pickClosest(); if not target then return end
            local prompt = PromptMemoryCache[target.uid]
            if not prompt or not prompt.Parent then prompt = findProximityPromptForAnimal(target) end
            if prompt then attemptSteal(prompt, target) end
        end)
    end

    stopAutoSteal = function()
        if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
        isStealing = false
        StealState.active = false
        if stealProgressConn then stealProgressConn:Disconnect(); stealProgressConn = nil end
        resetProgressBar()
        InternalStealCache = {}
        PromptMemoryCache  = {}
    end

    scanAllPlots()
    if Steal.AutoStealEnabled then startAutoSteal() end
    task.spawn(function() while task.wait(5) do scanAllPlots() end end)
end)

RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1; autoLeftEnabled = false
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1; autoRightEnabled = false
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
end

local function startAutoLeft()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        local spd = getAutoPathSpeed()
        if alPhase == 1 then
            local tgt = Vector3.new(AP_L1.X, hrp.Position.Y, AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP_L2 - hrp.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv, false); hrp.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp.AssemblyLinearVelocity.Y, mv.Z*spd); hum:Move(mv, true); return
            end
            local d = AP_L1 - hrp.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv, false); hrp.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp.AssemblyLinearVelocity.Y, mv.Z*spd); hum:Move(mv, true)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP_L2.X, hrp.Position.Y, AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); hrp.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false; if alConn then alConn:Disconnect(); alConn = nil end; alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end; return
            end
            local d = AP_L2 - hrp.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv, false); hrp.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp.AssemblyLinearVelocity.Y, mv.Z*spd); hum:Move(mv, true)
        end
    end)
end

local function startAutoRight()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character; if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        local spd = getAutoPathSpeed()
        if arPhase == 1 then
            local tgt = Vector3.new(AP_R1.X, hrp.Position.Y, AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP_R2 - hrp.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv, false); hrp.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp.AssemblyLinearVelocity.Y, mv.Z*spd); hum:Move(mv, true); return
            end
            local d = AP_R1 - hrp.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv, false); hrp.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp.AssemblyLinearVelocity.Y, mv.Z*spd); hum:Move(mv, true)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP_R2.X, hrp.Position.Y, AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false); hrp.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false; if arConn then arConn:Disconnect(); arConn = nil end; arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end; return
            end
            local d = AP_R2 - hrp.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv, false); hrp.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp.AssemblyLinearVelocity.Y, mv.Z*spd); hum:Move(mv, true)
        end
    end)
end

local DROP_ASCEND_DURATION, DROP_ASCEND_SPEED = 0.2, 150
local function runDrop()
    if dropActive then return end
    if tpLockEnabled then toggleTPLock() end
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    dropActive = true; local t0 = tick(); local dc
    dc = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then dc:Disconnect(); dropActive = false; return end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            dc:Disconnect()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {char}; rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0,-2000,0), rp)
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.new(0,0,0)
            end
            dropActive = false; return
        end
        r.Velocity = Vector3.new(r.Velocity.X, DROP_ASCEND_SPEED, r.Velocity.Z)
    end)
end

local _lastTPTime = 0
local function doAutoTPDown(force)
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
    if hum2.Health <= 0 then return end
    local now = tick()
    if now - _lastTPTime < 0.08 then return end
    if not force then
        if hum2.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= autoTPHeight) then return end
    end
    if hrp.Position.Y <= -6.5 and not force then return end
    _lastTPTime = now
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    hrp.Velocity = Vector3.zero
end

local function startAutoTP()
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
    autoTPConn = task.spawn(function()
        while autoTPEnabled do task.wait(0.1); pcall(function() doAutoTPDown(false) end) end
    end)
end

local function stopAutoTP()
    autoTPEnabled = false
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
end

local function runTPFloor() pcall(function() doAutoTPDown(true) end) end

local function startUnwalk()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
    local anim = c:FindFirstChild("Animate")
    if anim then unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end

local function stopUnwalk()
    local c = LP.Character
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c; unwalkSavedAnimate = nil end
end

local function applyInfJumpBoost(boost)
    if not infJumpEnabled then return end
    if infJumpMode == "manual" then
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z) end
    end
end

UIS.JumpRequest:Connect(function() applyInfJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        task.delay(0.12, function() if UIS:IsKeyDown(Enum.KeyCode.Space) then applyInfJumpBoost(50) end end)
    end
end)
RunService.Heartbeat:Connect(function()
    if infJumpEnabled and infJumpMode == "manual" then
        if UIS:IsKeyDown(Enum.KeyCode.Space) then applyInfJumpBoost(50) end
    end
end)

local function startHoldInfJump()
    if holdInfJumpConn then return end
    holdInfJumpConn = RunService.Heartbeat:Connect(function()
        if not infJumpEnabled or infJumpMode ~= "hold" then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.Velocity.Y < 35 then root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z) end
        if root.Velocity.Y < -120 then root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z) end
    end)
end

local function stopHoldInfJump()
    if holdInfJumpConn then holdInfJumpConn:Disconnect(); holdInfJumpConn = nil end
end

if infJumpEnabled and infJumpMode == "hold" then startHoldInfJump() end

local function findMedusa()
    local c = LP.Character; if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

local MEDUSA_COOLDOWN = 25
local function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character; if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = tick(); medusaDebounce = false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 then
            if medusaResetEnabled then cursedInstaReset()
            elseif medusaCounterEnabled then useMedusaCounter() end
        end
    end)
end

local function setupMedusa(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}; if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end))
end

local function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local batCounterDebounce = false

local function findBatForCounter()
    local c = LP.Character; if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

local function swingBatForCounter(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end)
    end
end

startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local char = LP.Character; if not char then return end
        local hum2 = char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st = hum2:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, char) end
                task.wait(0.5); batCounterDebounce = false
            end)
        end
    end)
end

stopBatCounter = function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter = nil end
    batCounterDebounce = false
end

local SKY_TAG = "VynxSkyTheme"
local currentSkyTheme = "Off"
local SKY_PRESETS = {
    ["Off"]           = {kind="off"},
    ["Night"]         = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]        = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]        = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]        = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]         = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]        = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]    = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]    = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]  = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]      = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]        = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]= {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]     = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"]         = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]     = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]        = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]         = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]       = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]    = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]= {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]       = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]      = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local SKY_ORDER = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

local function _color3(rgb) return Color3.fromRGB(rgb[1], rgb[2], rgb[3]) end

local function applySkyTheme(mode)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
        end
    end
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14; Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000; Lighting.GlobalShadows = true
        currentSkyTheme = "Off"; return
    end
    Lighting.FogStart = 0; Lighting.FogEnd = 100000; Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0); Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true; Lighting.ClockTime = preset.clock or 14; Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _color3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _color3(preset.ambient) end
    if preset.sky then
        local sky = Instance.new("Sky"); sky:SetAttribute(SKY_TAG, true)
        if preset.sky.stars then sky.StarCount = preset.sky.stars end
        if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
        sky.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere"); atm:SetAttribute(SKY_TAG, true)
        atm.Density = preset.atm.dens or 0.3; atm.Color = _color3(preset.atm.color)
        atm.Decay = _color3(preset.atm.decay); atm.Glare = preset.atm.glare or 1; atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds"); clouds:SetAttribute(SKY_TAG, true)
        clouds.Cover = preset.clouds.cover or 0.5; clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _color3(preset.clouds.color); clouds.Parent = terrain
    end
    currentSkyTheme = mode
end

local defLightBrightness, defLightClock, defLightAmbient

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic; obj.Reflectance = 0; obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
        end
    end)
end

local function enableAntiLag()
    removeAccessoriesEnabled = true; antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false; Lighting.FogEnd = 1e10; Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0; Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

local function disableAntiLag()
    removeAccessoriesEnabled = false; antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
        Lighting.ExposureCompensation = 0
    end)
end

local function enableStretchRez()
    stretchRezEnabled = true; workspace.CurrentCamera.FieldOfView = 107
    if stretchRezConn then stretchRezConn:Disconnect() end
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not stretchRezEnabled then stretchRezConn:Disconnect(); stretchRezConn = nil; return end
        workspace.CurrentCamera.FieldOfView = 107
    end)
end

local function disableStretchRez()
    stretchRezEnabled = false
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    workspace.CurrentCamera.FieldOfView = 70
end

-- ============================================================
-- SISTEMA DE CONFIGURACIÓN MEJORADO
-- ============================================================
function saveConfig()
    local function ks(e)
        return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil}
    end

    local stealPos = nil
    if stealBarFrame then
        stealPos = {
            x = stealBarFrame.Position.X.Offset,
            y = stealBarFrame.Position.Y.Offset
        }
    end

    local cfg = {
        version = "1.0",
        normalSpeed = NS,
        carrySpeed = CS,
        dropBrainrotKey = ks(KB.DropBrainrot),
        autoLeftKey = ks(KB.AutoLeft),
        autoRightKey = ks(KB.AutoRight),
        tpLockKey = ks(KB.TPLock),
        laggerToggleKey = ks(KB.LaggerToggle),
        instaResetKey = ks(KB.InstaReset),
        tpFloorKey = ks(KB.TPFloor),
        guiHideKey = ks(KB.GuiHide),
        speedToggleKey = ks(KB.SpeedToggle),
        batV2Key = ks(KB.BatV2Toggle),
        grabRadius = Steal.StealRadius,
        stealDuration = Steal.StealDuration,
        antiRagdoll = antiRagdollEnabled,
        autoStealEnabled = Steal.AutoStealEnabled,
        infiniteJump = infJumpEnabled,
        medusaCounter = medusaCounterEnabled,
        medusaReset = medusaResetEnabled,
        batCounter = batCounterEnabled,
        carryMode = speedMode,
        laggerMode = laggerToggled,
        laggerCarryMode = laggerCarryToggled,
        laggerSpeed = LAGGER_SPEED,
        laggerCarrySpeed = LAGGER_CARRY_SPEED,
        tpLockEnabled = tpLockEnabled,
        autoSwing = autoSwingEnabled,
        unwalkEnabled = unwalkEnabled,
        antiLag = antiLagEnabled,
        stretchRez = stretchRezEnabled,
        autoTPEnabled = autoTPEnabled,
        autoTPHeight = autoTPHeight,
        mobileButtonsEnabled = mobileButtonsEnabled,
        mobileButtonsSize = mobileButtonsSize,
        circleButtonsEnabled = circleButtonsEnabled,
        shapeButtonsEnabled = shapeButtonsEnabled,
        rectangularButtonsEnabled = rectangularButtonsEnabled,
        infJumpMode = infJumpMode,
        uiLocked = uiLocked,
        perButtonDragEnabled = perButtonDragEnabled,
        batV2Enabled = batV2Enabled,
        skyTheme = currentSkyTheme,
        uiScale = uiScaleValue,
        stealBarPos = stealPos,
        espEnabled = espEnabled,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        lastSaved = os.time()
    }

    local success, err = pcall(function()
        local json = HS:JSONEncode(cfg)
        writefile("CleanHub.json", json)
    end)

    if success then
        print("✅ Configuración guardada correctamente")
    else
        warn("❌ Error al guardar configuración: " .. tostring(err))
    end
end

local function loadConfig()
    if not (isfile and isfile("CleanHub.json")) then
        print("ℹ️ No se encontró archivo de configuración, usando valores por defecto")
        return
    end

    local ok, cfg = pcall(function()
        return HS:JSONDecode(readfile("CleanHub.json"))
    end)

    if not ok or type(cfg) ~= "table" then
        warn("⚠️ Archivo de configuración corrupto, usando valores por defecto")
        return
    end

    NS = type(cfg.normalSpeed) == "number" and cfg.normalSpeed > 0 and cfg.normalSpeed or NS
    CS = type(cfg.carrySpeed) == "number" and cfg.carrySpeed > 0 and cfg.carrySpeed or CS
    LAGGER_SPEED = type(cfg.laggerSpeed) == "number" and cfg.laggerSpeed > 0 and cfg.laggerSpeed or LAGGER_SPEED
    LAGGER_CARRY_SPEED = type(cfg.laggerCarrySpeed) == "number" and cfg.laggerCarrySpeed > 0 and cfg.laggerCarrySpeed or LAGGER_CARRY_SPEED

    Steal.StealRadius = type(cfg.grabRadius) == "number" and cfg.grabRadius > 0 and cfg.grabRadius or Steal.StealRadius
    Steal.StealDuration = type(cfg.stealDuration) == "number" and cfg.stealDuration > 0 and cfg.stealDuration or Steal.StealDuration
    autoTPHeight = type(cfg.autoTPHeight) == "number" and cfg.autoTPHeight or autoTPHeight
    mobileButtonsSize = type(cfg.mobileButtonsSize) == "number" and cfg.mobileButtonsSize or mobileButtonsSize
    bodyLockRange = type(cfg.bodyLockRange) == "number" and cfg.bodyLockRange > 0 and cfg.bodyLockRange or bodyLockRange

    antiRagdollEnabled = type(cfg.antiRagdoll) == "boolean" and cfg.antiRagdoll or antiRagdollEnabled
    Steal.AutoStealEnabled = type(cfg.autoStealEnabled) == "boolean" and cfg.autoStealEnabled or Steal.AutoStealEnabled
    infJumpEnabled = type(cfg.infiniteJump) == "boolean" and cfg.infiniteJump or infJumpEnabled
    medusaCounterEnabled = type(cfg.medusaCounter) == "boolean" and cfg.medusaCounter or medusaCounterEnabled
    medusaResetEnabled = type(cfg.medusaReset) == "boolean" and cfg.medusaReset or medusaResetEnabled
    batCounterEnabled = type(cfg.batCounter) == "boolean" and cfg.batCounter or batCounterEnabled
    speedMode = type(cfg.carryMode) == "boolean" and cfg.carryMode or speedMode
    laggerToggled = type(cfg.laggerMode) == "boolean" and cfg.laggerMode or laggerToggled
    laggerCarryToggled = type(cfg.laggerCarryMode) == "boolean" and cfg.laggerCarryMode or laggerCarryToggled
    tpLockEnabled = type(cfg.tpLockEnabled) == "boolean" and cfg.tpLockEnabled or tpLockEnabled
    autoSwingEnabled = type(cfg.autoSwing) == "boolean" and cfg.autoSwing or autoSwingEnabled
    unwalkEnabled = type(cfg.unwalkEnabled) == "boolean" and cfg.unwalkEnabled or unwalkEnabled
    antiLagEnabled = type(cfg.antiLag) == "boolean" and cfg.antiLag or antiLagEnabled
    stretchRezEnabled = type(cfg.stretchRez) == "boolean" and cfg.stretchRez or stretchRezEnabled
    autoTPEnabled = type(cfg.autoTPEnabled) == "boolean" and cfg.autoTPEnabled or autoTPEnabled
    mobileButtonsEnabled = type(cfg.mobileButtonsEnabled) == "boolean" and cfg.mobileButtonsEnabled or mobileButtonsEnabled
    circleButtonsEnabled = type(cfg.circleButtonsEnabled) == "boolean" and cfg.circleButtonsEnabled or circleButtonsEnabled
    shapeButtonsEnabled = type(cfg.shapeButtonsEnabled) == "boolean" and cfg.shapeButtonsEnabled or shapeButtonsEnabled
    rectangularButtonsEnabled = type(cfg.rectangularButtonsEnabled) == "boolean" and cfg.rectangularButtonsEnabled or rectangularButtonsEnabled
    uiLocked = type(cfg.uiLocked) == "boolean" and cfg.uiLocked or uiLocked
    perButtonDragEnabled = type(cfg.perButtonDragEnabled) == "boolean" and cfg.perButtonDragEnabled or perButtonDragEnabled
    batV2Enabled = type(cfg.batV2Enabled) == "boolean" and cfg.batV2Enabled or batV2Enabled
    espEnabled = type(cfg.espEnabled) == "boolean" and cfg.espEnabled or espEnabled
    bodyLockEnabled = type(cfg.bodyLockEnabled) == "boolean" and cfg.bodyLockEnabled or bodyLockEnabled

    if type(cfg.infJumpMode) == "string" then infJumpMode = cfg.infJumpMode end
    if type(cfg.skyTheme) == "string" then currentSkyTheme = cfg.skyTheme end
    if type(cfg.uiScale) == "number" and cfg.uiScale >= 0.4 and cfg.uiScale <= 1.3 then uiScaleValue = cfg.uiScale end

    local function applyKey(target, saved)
        if not saved or not target then return end
        if saved.kb and Enum.KeyCode[saved.kb] then target.kb = Enum.KeyCode[saved.kb] end
        if saved.gp and Enum.KeyCode[saved.gp] then target.gp = Enum.KeyCode[saved.gp] end
    end
    applyKey(KB.DropBrainrot, cfg.dropBrainrotKey)
    applyKey(KB.AutoLeft, cfg.autoLeftKey)
    applyKey(KB.AutoRight, cfg.autoRightKey)
    applyKey(KB.TPLock, cfg.tpLockKey)
    applyKey(KB.LaggerToggle, cfg.laggerToggleKey)
    applyKey(KB.InstaReset, cfg.instaResetKey)
    applyKey(KB.TPFloor, cfg.tpFloorKey)
    applyKey(KB.GuiHide, cfg.guiHideKey)
    applyKey(KB.SpeedToggle, cfg.speedToggleKey)
    applyKey(KB.BatV2Toggle, cfg.batV2Key)

    print("✅ Configuración cargada correctamente")
end

task.spawn(function() while task.wait(5) do saveConfig() end end)

local function createHeadLabels(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local speedGui = Instance.new("BillboardGui")
    speedGui.Name = "VynxSpeedLabel"
    speedGui.Adornee = head
    speedGui.Size = UDim2.new(0, 160, 0, 28)
    speedGui.StudsOffset = Vector3.new(0, 2.8, 0)
    speedGui.AlwaysOnTop = true
    speedGui.Parent = char

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1,0,1,0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "0"
    speedLbl.TextColor3 = PURPLE
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.TextStrokeTransparency = 0
    speedLbl.Font = Enum.Font.GothamBold
    speedLbl.TextSize = 14
    speedLbl.TextScaled = true
    speedLbl.TextXAlignment = Enum.TextXAlignment.Center
    speedLbl.Parent = speedGui

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent then conn:Disconnect(); return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            local hSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude
            speedLbl.Text = string.format("%.0f", hSpeed)
        end
    end)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    createHeadLabels(char)
end)

if LP.Character then
    task.spawn(function()
        task.wait(0.5)
        createHeadLabels(LP.Character)
    end)
end

local playerSpeedLabels = {}

local function createPlayerSpeedLabel(plr)
    if plr == LP then return end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if playerSpeedLabels[plr] then
        playerSpeedLabels[plr].gui:Destroy()
        playerSpeedLabels[plr] = nil
    end

    local speedGui = Instance.new("BillboardGui")
    speedGui.Name = "VynxSpeedLabel_Other"
    speedGui.Adornee = head
    speedGui.Size = UDim2.new(0, 160, 0, 28)
    speedGui.StudsOffset = Vector3.new(0, 2.8, 0)
    speedGui.AlwaysOnTop = true
    speedGui.Parent = char

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1,0,1,0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "0"
    speedLbl.TextColor3 = PURPLE
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLbl.TextStrokeTransparency = 0
    speedLbl.Font = Enum.Font.GothamBold
    speedLbl.TextSize = 14
    speedLbl.TextScaled = true
    speedLbl.TextXAlignment = Enum.TextXAlignment.Center
    speedLbl.Parent = speedGui

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent then
            conn:Disconnect()
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local vel = hrp.AssemblyLinearVelocity
            local hSpeed = Vector3.new(vel.X, 0, vel.Z).Magnitude
            speedLbl.Text = string.format("%.0f", hSpeed)
        end
    end)

    playerSpeedLabels[plr] = {gui = speedGui, lbl = speedLbl, conn = conn}
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LP then
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerSpeedLabel(plr)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if playerSpeedLabels[plr] then
        playerSpeedLabels[plr].gui:Destroy()
        playerSpeedLabels[plr].conn:Disconnect()
        playerSpeedLabels[plr] = nil
    end
end)

local _cachedChar, _cachedHum, _cachedHrp = nil, nil, nil

LP.CharacterAdded:Connect(function(char)
    _cachedChar = nil; _cachedHum = nil; _cachedHrp = nil
    task.wait(0.3)
    _cachedChar = char
    _cachedHum = char:FindFirstChildOfClass("Humanoid")
    _cachedHrp = char:FindFirstChild("HumanoidRootPart")
    if medusaCounterEnabled or medusaResetEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5); startUnwalk() end
    if antiRagdollEnabled then stopAntiRagdoll(); startAntiRagdoll() end
    if Steal.AutoStealEnabled then stopAutoSteal(); startAutoSteal() end
    if espEnabled then startESP() end
    if bodyLockEnabled then startBodyLock() end
end)

local lastMoveDir = Vector3.new(0,0,0)
local MOVE_KEYS = {
    [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true
}

RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then _cachedChar = nil; return end
    local hum, hrp
    if char == _cachedChar then hum = _cachedHum; hrp = _cachedHrp
    else
        _cachedChar = char; hum = char:FindFirstChildOfClass("Humanoid")
        hrp = char:FindFirstChild("HumanoidRootPart"); _cachedHum = hum; _cachedHrp = hrp
    end
    if not hum or not hrp then return end
    local _st = hum:GetState()
    if _st == Enum.HumanoidStateType.Physics or _st == Enum.HumanoidStateType.Ragdoll or _st == Enum.HumanoidStateType.FallingDown then
        lastMoveDir = Vector3.new(0,0,0); return
    end
    if not tpLockEnabled and not autoLeftEnabled and not autoRightEnabled and not batV2Enabled then
        local md = hum.MoveDirection; local spd = getActiveMoveSpeed()
        if md.Magnitude > 0 then
            lastMoveDir = md; hrp.Velocity = Vector3.new(md.X*spd, hrp.Velocity.Y, md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld = true; break end end
            if anyHeld then hrp.Velocity = Vector3.new(lastMoveDir.X*spd, hrp.Velocity.Y, lastMoveDir.Z*spd) end
        end
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    end
    if not isGamepadInput(input) then
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    end
    if not isBindableInput(input) then return end
    local kc = input.KeyCode
    if kbMatch(KB.LaggerToggle, kc) then toggleLaggerMode(); saveConfig()
    elseif kbMatch(KB.SpeedToggle, kc) then toggleCarryMode(); saveConfig()
    elseif kbMatch(KB.DropBrainrot, kc) then runDrop()
    elseif kbMatch(KB.InstaReset, kc) then
        if tick() - _lastKbSet > 0.5 then pcall(cursedInstaReset) end
    elseif kbMatch(KB.TPFloor, kc) then runTPFloor()
    elseif kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then
            if autoRightEnabled then autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if tpLockEnabled then toggleTPLock() end
            if batV2Enabled then toggleBatV2() end
            startAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(true) end
        else stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
    elseif kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then
            if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if tpLockEnabled then toggleTPLock() end
            if batV2Enabled then toggleBatV2() end
            startAutoRight(); if autoRightSetVisual then autoRightSetVisual(true) end
        else stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
    elseif kbMatch(KB.TPLock, kc) then
        if batV2Enabled then toggleBatV2() end
        toggleTPLock(); saveConfig()
    elseif kbMatch(KB.GuiHide, kc) then
        if mainFrame then mainFrame.Visible = not mainFrame.Visible end
    elseif kbMatch(KB.BatV2Toggle, kc) then
        if tpLockEnabled then toggleTPLock() end
        toggleBatV2(); saveConfig()
    end
end)

local MOB_POS_FILE = "cleanbtn_pos.json"
local DRAG_THRESHOLD = 15

local function loadBtnPositions()
    if not (isfile and isfile(MOB_POS_FILE)) then return {} end
    local ok, data = pcall(function() return HS:JSONDecode(readfile(MOB_POS_FILE)) end)
    if ok and type(data) == "table" then return data end
    return {}
end

local function saveBtnPositions()
    if not writefile then return end; if not mobGuiRef then return end
    local out = {}
    for _, child in ipairs(mobGuiRef:GetDescendants()) do
        if child:IsA("Frame") and child:GetAttribute("BtnKey") then
            local key = child:GetAttribute("BtnKey")
            out[key] = {xo = child.Position.X.Offset, yo = child.Position.Y.Offset}
        end
    end
    pcall(function() writefile(MOB_POS_FILE, HS:JSONEncode(out)) end)
end

local function destroyMobileButtons()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end); mobGuiRef = nil end
    mobBtnRefs = {}
end

local function resetBtnPositions()
    pcall(function() if writefile then writefile(MOB_POS_FILE, "{}") end end)
    if mobileButtonsEnabled then buildMobileButtons() end
    if stealBarFrame then
        stealBarFrame.Position = UDim2.new(0.5, -150, 0.82, 0)
        saveConfig()
    end
end

local function buildMobileButtons()
    destroyMobileButtons()
    if not mobileButtonsEnabled then return end
    local savedPositions = loadBtnPositions()
    local BTN_SIZE = math.floor(mobileButtonsSize * 0.65)
    local fontSize = math.max(9, math.floor(mobileButtonsSize * 0.13))
    local spacing = 20; local cols = 2
    local isRect = rectangularButtonsEnabled
    local btnW = BTN_SIZE; local btnH = BTN_SIZE
    if isRect then btnW = math.floor(BTN_SIZE*1.4); btnH = math.floor(BTN_SIZE*0.75); spacing = 16 end
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800,600)
    local totalW = cols * btnW + (cols-1) * spacing
    local startX = viewport.X - totalW - 30; local startY = 30
    local buttonOrder = {
        {key="autoLeft",     label="AUTO LEFT",       toggle=true},
        {key="autoRight",    label="AUTO RIGHT",      toggle=true},
        {key="drop",         label="DROP BR",         toggle=false},
        {key="tpDown",       label="TP DOWN",         toggle=false},
        {key="batV2",        label="BAT V2",          toggle=true},
        {key="tpLock",       label="TP BAT",          toggle=true},
        {key="lagger",       label="LAGGER",          toggle=true},
        {key="laggerCarry",  label="LAGGER CARRY",    toggle=true},
        {key="carrySpeed",   label="CARRY SPD",       toggle=true},
        {key="instaReset",   label="INSTA RESET",     toggle=false},
    }
    local mobGui = Instance.new("ScreenGui")
    mobGui.Name = "VynxMobileButtons"; mobGui.ResetOnSpawn = false
    mobGui.DisplayOrder = 15; mobGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(mobGui) end end)
    if not pcall(function() mobGui.Parent = game:GetService("CoreGui") end) then
        mobGui.Parent = LP:WaitForChild("PlayerGui")
    end
    mobGuiRef = mobGui

    for i, def in ipairs(buttonOrder) do
        local col = (i-1) % cols; local row = math.floor((i-1)/cols)
        local xPos = startX + col*(btnW+spacing); local yPos = startY + row*(btnH+spacing)
        local saved = savedPositions[def.key]
        local initX = saved and saved.xo or xPos; local initY = saved and saved.yo or yPos
        local frame = Instance.new("Frame", mobGui)
        frame.Name = "MobBtn_"..def.key
        frame.Size = UDim2.new(0,btnW,0,btnH)
        frame.Position = UDim2.new(0,initX,0,initY)
        frame.BackgroundColor3 = BTN_OFF
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        frame.Active = true
        frame.ZIndex = 102
        frame:SetAttribute("BtnKey", def.key)
        local cornerRadius
        if circleButtonsEnabled then cornerRadius = UDim.new(1,0)
        elseif shapeButtonsEnabled then cornerRadius = UDim.new(0,4)
        elseif rectangularButtonsEnabled then cornerRadius = UDim.new(0,9)
        else cornerRadius = UDim.new(0, math.max(8, math.floor(math.min(btnW,btnH)*0.2))) end
        local uic = Instance.new("UICorner", frame)
        uic.CornerRadius = cornerRadius

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundTransparency = 1
        btn.Text = def.label
        btn.TextColor3 = TEXT_OFF
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = fontSize
        btn.LineHeight = 1.1
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 105

        local isOn = false

       local function setOn(v)
    isOn = v
    if v then
        -- Activado: Fondo MORADO, texto NEGRO
        frame.BackgroundColor3 = BTN_ON  -- PURPLE
        btn.TextColor3 = TEXT_ON  -- BLACK
        frame:SetAttribute("BtnIsOn", true)
    else
        -- Desactivado: Fondo NEGRO, texto MORADO
        frame.BackgroundColor3 = BTN_OFF  -- BLACK
        btn.TextColor3 = TEXT_OFF  -- PURPLE
        frame:SetAttribute("BtnIsOn", false)
    end
end

        mobBtnRefs[def.key] = setOn

        local dragData = {start=nil, startPos=nil, moved=false, down=false}
        btn.InputBegan:Connect(function(input)
            if uiLocked or not perButtonDragEnabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragData.moved = false
                dragData.down = true
                dragData.start = input.Position
                dragData.startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragData.down = false
                        if dragData.moved then pcall(saveBtnPositions) end
                    end
                end)
            end
        end)

        btn.InputChanged:Connect(function(input)
            if dragData.down and not uiLocked and perButtonDragEnabled and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragData.start
                if delta.Magnitude > DRAG_THRESHOLD then dragData.moved = true end
                if dragData.moved then
                    frame.Position = UDim2.new(
                        dragData.startPos.X.Scale,
                        dragData.startPos.X.Offset + delta.X,
                        dragData.startPos.Y.Scale,
                        dragData.startPos.Y.Offset + delta.Y
                    )
                end
            end
        end)

        btn.MouseButton1Click:Connect(function()
            if dragData.moved then
                dragData.moved = false
                return
            end

            if def.key == "autoLeft" then
                autoLeftEnabled = not autoLeftEnabled
                if autoLeftEnabled then
                    if autoRightEnabled then
                        autoRightEnabled = false
                        stopAutoRight()
                        if autoRightSetVisual then autoRightSetVisual(false) end
                        if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                    end
                    if tpLockEnabled then toggleTPLock() end
                    if batV2Enabled then toggleBatV2() end
                    startAutoLeft()
                    if autoLeftSetVisual then autoLeftSetVisual(true) end
                    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
                else
                    stopAutoLeft()
                    if autoLeftSetVisual then autoLeftSetVisual(false) end
                    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                end
                setOn(autoLeftEnabled)
                saveConfig()
                return
            end

            if def.key == "autoRight" then
                autoRightEnabled = not autoRightEnabled
                if autoRightEnabled then
                    if autoLeftEnabled then
                        autoLeftEnabled = false
                        stopAutoLeft()
                        if autoLeftSetVisual then autoLeftSetVisual(false) end
                        if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end
                    end
                    if tpLockEnabled then toggleTPLock() end
                    if batV2Enabled then toggleBatV2() end
                    startAutoRight()
                    if autoRightSetVisual then autoRightSetVisual(true) end
                    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
                else
                    stopAutoRight()
                    if autoRightSetVisual then autoRightSetVisual(false) end
                    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end
                end
                setOn(autoRightEnabled)
                saveConfig()
                return
            end

            if def.key == "tpLock" then
                if batV2Enabled then toggleBatV2() end
                toggleTPLock()
                setOn(tpLockEnabled)
                saveConfig()
                return
            end

            if def.key == "batV2" then
                if tpLockEnabled then toggleTPLock() end
                toggleBatV2()
                setOn(batV2Enabled)
                saveConfig()
                return
            end

            if def.key == "carrySpeed" then
                toggleCarryMode()
                setOn(speedMode)
                if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerToggled) end
                if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryToggled) end
                saveConfig()
                return
            end

            if def.key == "lagger" then
                toggleLaggerMode()
                setOn(laggerToggled)
                if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode) end
                if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryToggled) end
                saveConfig()
                return
            end

            if def.key == "laggerCarry" then
                toggleLaggerCarryMode()
                setOn(laggerCarryToggled)
                if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode) end
                if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerToggled) end
                saveConfig()
                return
            end

            if def.key == "drop" then
                setOn(true); runDrop(); task.delay(0.3, function() setOn(false) end)
                return
            end

            if def.key == "tpDown" then
                setOn(true); runTPFloor(); task.delay(0.3, function() setOn(false) end)
                return
            end

            if def.key == "instaReset" then
                setOn(true); cursedInstaReset(); task.delay(0.3, function() setOn(false) end)
                return
            end
        end)
    end

    if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end
    if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end
    if mobBtnRefs.tpLock then mobBtnRefs.tpLock(tpLockEnabled) end
    if mobBtnRefs.batV2 then mobBtnRefs.batV2(batV2Enabled) end
    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode) end
    if mobBtnRefs.lagger then mobBtnRefs.lagger(laggerToggled) end
    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerCarryToggled) end
end

-- ============================================================
-- NUEVA BARRA DE AUTO STEAL CON GUARDADO DE POSICIÓN
-- ============================================================
local function createStealBar()
    for _, n in ipairs({"VynxStealBar"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(n)
        if old then old:Destroy() end
        local pgui = LP:FindFirstChild("PlayerGui")
        if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end
    end

    local SB_W, SB_H = 320, 40
    local stealGui = Instance.new("ScreenGui")
    stealGui.Name = "VynxStealBar"
    stealGui.ResetOnSpawn = false
    stealGui.IgnoreGuiInset = true
    stealGui.DisplayOrder = 8
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(stealGui) end end)
    if not pcall(function() stealGui.Parent = game:GetService("CoreGui") end) then
        stealGui.Parent = LP:WaitForChild("PlayerGui")
    end

    local outer = Instance.new("Frame", stealGui)
    outer.Size = UDim2.new(0, SB_W, 0, SB_H)
    local defaultPos = UDim2.new(0.5, -SB_W/2, 0.82, 0)
    outer.Position = defaultPos
    outer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    outer.BackgroundTransparency = 0
    outer.BorderSizePixel = 0
    outer.ZIndex = 18
    Instance.new("UICorner", outer).CornerRadius = UDim.new(0, SB_H/2)
    stealBarFrame = outer

    local outerBorder = Instance.new("UIStroke", outer)
    outerBorder.Color = PURPLE
    outerBorder.Thickness = 1.2
    outerBorder.Transparency = 0.3
    outerBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local innerBorder = Instance.new("Frame", outer)
    innerBorder.Size = UDim2.new(1, -4, 1, -4)
    innerBorder.Position = UDim2.new(0, 2, 0, 2)
    innerBorder.BackgroundTransparency = 1
    innerBorder.BorderSizePixel = 0
    innerBorder.ZIndex = 19
    Instance.new("UICorner", innerBorder).CornerRadius = UDim.new(0, (SB_H-4)/2)
    local innerStroke = Instance.new("UIStroke", innerBorder)
    innerStroke.Color = PURPLE
    innerStroke.Thickness = 0.8
    innerStroke.Transparency = 0.2

    local dividerLine = Instance.new("Frame", innerBorder)
    dividerLine.Size = UDim2.new(0, 1, 0.8, 0)
    dividerLine.Position = UDim2.new(0.1, 0, 0.1, 0)
    dividerLine.BackgroundColor3 = PURPLE
    dividerLine.BackgroundTransparency = 0.2
    dividerLine.BorderSizePixel = 0
    dividerLine.ZIndex = 20

    local leftSection = Instance.new("Frame", innerBorder)
    leftSection.Size = UDim2.new(0.1, 0, 1, -8)
    leftSection.Position = UDim2.new(0, 2, 0, 4)
    leftSection.BackgroundTransparency = 1
    leftSection.ZIndex = 21

    local statusDot = Instance.new("Frame", leftSection)
    statusDot.Size = UDim2.new(0, 12, 0, 12)
    statusDot.Position = UDim2.new(0.5, -6, 0.5, -6)
    statusDot.BackgroundColor3 = PURPLE
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 22
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    local rightSection = Instance.new("Frame", innerBorder)
    rightSection.Size = UDim2.new(0.88, 0, 1, -8)
    rightSection.Position = UDim2.new(0.12, 0, 0, 4)
    rightSection.BackgroundTransparency = 1
    rightSection.ZIndex = 21

    local stealLabel = Instance.new("TextLabel", rightSection)
    stealLabel.Size = UDim2.new(0.35, 0, 0.5, 0)
    stealLabel.Position = UDim2.new(0, 0, 0, 0)
    stealLabel.BackgroundTransparency = 1
    stealLabel.Text = "STEAL"
    stealLabel.TextColor3 = PURPLE
    stealLabel.Font = Enum.Font.GothamBold
    stealLabel.TextSize = 12
    stealLabel.TextXAlignment = Enum.TextXAlignment.Left
    stealLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    stealLabel.ZIndex = 22

    local track = Instance.new("Frame", rightSection)
    track.Size = UDim2.new(0.92, 0, 0.35, 0)
    track.Position = UDim2.new(0, 0, 0.6, 0)
    track.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 4)
    track.ZIndex = 23

    local fillBar = Instance.new("Frame", track)
    fillBar.Size = UDim2.new(0, 0, 1, 0)
    fillBar.BackgroundColor3 = PURPLE
    fillBar.BorderSizePixel = 0
    Instance.new("UICorner", fillBar).CornerRadius = UDim.new(0, 4)
    fillBar.ZIndex = 24
    local gradient = Instance.new("UIGradient", fillBar)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, PURPLE),
        ColorSequenceKeypoint.new(1, PURPLE_LIGHT)
    })
    gradient.Rotation = 0

    local pctLabel = Instance.new("TextLabel", track)
    pctLabel.Size = UDim2.new(0.3, 0, 1, 0)
    pctLabel.Position = UDim2.new(0.72, 0, 0, 0)
    pctLabel.BackgroundTransparency = 1
    pctLabel.Text = "0%"
    pctLabel.TextColor3 = PURPLE
    pctLabel.Font = Enum.Font.GothamBold
    pctLabel.TextSize = 10
    pctLabel.TextXAlignment = Enum.TextXAlignment.Right
    pctLabel.TextYAlignment = Enum.TextYAlignment.Center
    pctLabel.ZIndex = 25

    progressFill = fillBar
    progressPct = pctLabel

    updateProgressBar = function(pct)
        pct = math.clamp(pct or 0, 0, 1)
        fillBar.Size = UDim2.new(pct, 0, 1, 0)
        pctLabel.Text = math.floor(pct * 100) .. "%"
    end
    resetProgressBar = function()
        updateProgressBar(0)
    end

    local function resetStealBarPosition()
        if stealBarFrame then
            stealBarFrame.Position = UDim2.new(0.5, -SB_W/2, 0.82, 0)
            saveConfig()
        end
    end
    _G.ResetStealBar = resetStealBarPosition

    local dragStart2, dragStartPos2, dragging2 = nil, nil, false
    outer.InputBegan:Connect(function(input)
        if uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging2 = true
            dragStart2 = input.Position
            dragStartPos2 = outer.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging2 = false
                    local pos = outer.Position
                    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
                    local x = pos.X.Offset
                    local y = pos.Y.Offset
                    if x >= 0 and x <= viewport.X - outer.Size.X.Offset and y >= 0 and y <= viewport.Y - outer.Size.Y.Offset then
                        task.spawn(function()
                            saveConfig()
                            print("✅ Posición de Steal Bar guardada")
                        end)
                    end
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if uiLocked then
            dragging2 = false
            return
        end
        if dragging2 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart2
            outer.Position = UDim2.new(dragStartPos2.X.Scale, dragStartPos2.X.Offset + delta.X, dragStartPos2.Y.Scale, dragStartPos2.Y.Offset + delta.Y)
        end
    end)

    local function loadStealBarPos()
        if not stealBarFrame then return end
        local ok, cfg = pcall(function() return HS:JSONDecode(readfile("CleanHub.json")) end)
        if ok and cfg and cfg.stealBarPos then
            local pos = cfg.stealBarPos
            local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
            local x = pos.x or -150
            local y = pos.y or 0
            if x >= 0 and x <= viewport.X - outer.Size.X.Offset and y >= 0 and y <= viewport.Y - outer.Size.Y.Offset then
                stealBarFrame.Position = UDim2.new(0.5, x, 0.82, y)
            else
                resetStealBarPosition()
            end
        else
            resetStealBarPosition()
        end
    end
    task.spawn(function() task.wait(0.2); loadStealBarPos() end)
end

local function applyState()
    if antiRagdollEnabled then stopAntiRagdoll(); startAntiRagdoll() end
    if setAntiRagVisual then setAntiRagVisual(antiRagdollEnabled) end
    if Steal.AutoStealEnabled then startAutoSteal() end
    if setInstaGrab then setInstaGrab(Steal.AutoStealEnabled) end
    if infJumpEnabled then if infJumpMode == "hold" then startHoldInfJump() end end
    if setInfJumpVisual then setInfJumpVisual(infJumpEnabled) end
    if medusaCounterEnabled or medusaResetEnabled then
        setupMedusa(LP.Character)
        if setMedusaVisual then setMedusaVisual(medusaCounterEnabled) end
        if setMedusaResetVisual then setMedusaResetVisual(medusaResetEnabled) end
    end
    if batCounterEnabled then startBatCounter() end
    if setBatCounterVisual then setBatCounterVisual(batCounterEnabled) end
    if tpLockEnabled then toggleTPLock() end
    if unwalkEnabled then startUnwalk() end
    if setUnwalkVisual then setUnwalkVisual(unwalkEnabled) end
    if antiLagEnabled then enableAntiLag() end
    if setAntiLagVisual then setAntiLagVisual(antiLagEnabled) end
    if stretchRezEnabled then enableStretchRez() end
    if setStretchRezVisual then setStretchRezVisual(stretchRezEnabled) end
    if autoTPEnabled then startAutoTP() end
    if setAutoTPVisual then setAutoTPVisual(autoTPEnabled) end
    if batV2Enabled then toggleBatV2() end
    if batV2SetVisual then batV2SetVisual(batV2Enabled) end
    if bodyLockEnabled then startBodyLock() end
    if bodyLockSetVisual then bodyLockSetVisual(bodyLockEnabled) end
    if espEnabled then startESP() end
    if setEspVisual then setEspVisual(espEnabled) end
    refreshSpeedModeLabel()
    if autoLeftEnabled and autoLeftSetVisual then autoLeftSetVisual(true) end
    if autoRightEnabled and autoRightSetVisual then autoRightSetVisual(true) end
    if currentSkyTheme and currentSkyTheme ~= "Off" then applySkyTheme(currentSkyTheme) end
    if mainFrame and uiScaleObject then uiScaleObject.Scale = uiScaleValue end
end

if _G.CLEAN_HUB_LOADED then return end
_G.CLEAN_HUB_LOADED = true

-- ============================================================
-- ESTRELLAS DE FONDO MEJORADAS (MÁS PEQUEÑAS Y CON BRILLO)
-- ============================================================
local function addStarfieldToMenu(menuFrame)
    if not menuFrame then return end

    local stars = {}
    local starContainer = Instance.new("Frame", menuFrame)
    starContainer.Name = "StarContainer"
    starContainer.Size = UDim2.new(1, 0, 1, 0)
    starContainer.Position = UDim2.new(0, 0, 0, 0)
    starContainer.BackgroundTransparency = 1
    starContainer.ZIndex = 0

    local function createStar()
        local star = Instance.new("Frame", starContainer)
        local size = 0.5 + math.random() * 1.5
        star.Size = UDim2.new(0, size, 0, size)
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.ZIndex = 1
        star.BorderSizePixel = 0

        local colorVariation = 0.7 + math.random() * 0.3
        star.BackgroundColor3 = Color3.new(
            1 * colorVariation,
            0.6 * colorVariation,
            0.6 * colorVariation
        )

        local baseTransparency = 0.05 + math.random() * 0.15
        star.BackgroundTransparency = baseTransparency

        local corner = Instance.new("UICorner", star)
        corner.CornerRadius = UDim.new(1, 0)

        local glow = Instance.new("ImageLabel", star)
        glow.Size = UDim2.new(4, 0, 4, 0)
        glow.Position = UDim2.new(0.5, -size*2, 0.5, -size*2)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://2310435351"
        glow.ImageColor3 = Color3.new(1, 0.8, 0.8)
        glow.ImageTransparency = 0.6 + math.random() * 0.2
        glow.ZIndex = 0
        glow.Visible = true

        return {
            frame = star,
            glow = glow,
            transparency = baseTransparency,
            timer = 1.5 + math.random() * 3.0,
            elapsed = 0,
            brightness = 0.5 + math.random() * 0.5,
            size = size
        }
    end

    for i = 1, 300 do
        local starData = createStar()
        table.insert(stars, starData)
    end

    task.spawn(function()
        while menuFrame.Parent and starContainer.Parent do
            for _, starData in ipairs(stars) do
                starData.elapsed = starData.elapsed + 0.05

                if starData.elapsed >= starData.timer then
                    starData.elapsed = 0
                    starData.timer = 1.5 + math.random() * 3.0

                    local star = starData.frame
                    local glow = starData.glow

                    local duration = 0.15 + math.random() * 0.1

                    TS:Create(glow, TweenInfo.new(duration/2, Enum.EasingStyle.Quad), {
                        ImageTransparency = 0.1
                    }):Play()
                    TS:Create(star, TweenInfo.new(duration/2, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = 0.01
                    }):Play()

                    task.wait(duration/2)

                    local newPos = UDim2.new(math.random(), 0, math.random(), 0)
                    local newSize = 0.3 + math.random() * 1.2

                    star.Position = newPos
                    star.Size = UDim2.new(0, newSize, 0, newSize)
                    glow.Size = UDim2.new(0, newSize*4, 0, newSize*4)
                    glow.Position = UDim2.new(0.5, -newSize*2, 0.5, -newSize*2)

                    TS:Create(glow, TweenInfo.new(duration/2, Enum.EasingStyle.Quad), {
                        ImageTransparency = 0.6 + math.random() * 0.3
                    }):Play()
                    TS:Create(star, TweenInfo.new(duration/2, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = starData.transparency
                    }):Play()
                end
            end
            task.wait(0.05)
        end
    end)
end

-- ============================================================
-- CONSTRUIR GUI MEJORADA
-- ============================================================
local function buildGui()
    local PURPLE    = PURPLE
    local BLACK    = Color3.fromRGB(0,   0,   0)
    local DARK     = Color3.fromRGB(0,   0,   0)
    local DARKER   = Color3.fromRGB(0,   0,   0)
    local MID      = Color3.fromRGB(0,   0,   0)
    local DIM_LINE = PURPLE
    local CHECK_OFF= TOGGLE_OFF_COLOR
    local BTN_ACT  = Color3.fromRGB(0,   0,   0)
    local INP_BG   = Color3.fromRGB(0,   0,   0)

    -- Colores para TP Bat y Bat V2
    local HIGHLIGHT_COLOR = PURPLE
    local HIGHLIGHT_ACTIVE = PURPLE_LIGHT

    for _, name in ipairs({"JokerHub", "VynxMobileButtons", "VynxStealBar", "VynxRagdollTimer"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(name)
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "CleanHub"; gui.ResetOnSpawn = false
    gui.DisplayOrder = 10; gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    uiScaleObject = Instance.new("UIScale", gui)
    uiScaleObject.Scale = uiScaleValue

    mainFrame = Instance.new("Frame", gui)
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 480, 0, 560)
    mainFrame.Position = UDim2.new(0.02, 0, 0.45, -280)
    mainFrame.BackgroundColor3 = DARK
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 24)

    addStarfieldToMenu(mainFrame)

    bgImage = Instance.new("ImageLabel", mainFrame)
    bgImage.Size = UDim2.new(1,0,1,0); bgImage.Position = UDim2.new(0,0,0,0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://79486502121665"
    bgImage.ScaleType = Enum.ScaleType.Crop; bgImage.ZIndex = 1
    bgImage.ImageTransparency = 0.45
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0,24)

    local bgOverlay = Instance.new("Frame", mainFrame)
    bgOverlay.Size = UDim2.new(1,0,1,0); bgOverlay.BackgroundColor3 = DARK
    bgOverlay.BackgroundTransparency = 0.35
    bgOverlay.BorderSizePixel = 0; bgOverlay.ZIndex = 2
    Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0,24)

    local dragging, dragInput2, dragStart2, startPos2
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart2 = input.Position
            startPos2 = mainFrame.Position
            dragInput2 = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    dragInput2 = nil
                end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart2
            if delta.Magnitude > 5 then
                mainFrame.Position = UDim2.new(
                    startPos2.X.Scale,
                    startPos2.X.Offset + delta.X,
                    startPos2.Y.Scale,
                    startPos2.Y.Offset + delta.Y
                )
            end
        end
    end)

    -- HEADER
    local Header = Instance.new("Frame", mainFrame)
    Header.Name = "Header"
    Header.Size = UDim2.new(1,0,0,70)
    Header.Position = UDim2.new(0,0,0,0)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 3

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1,0,1,0)
    Title.Position = UDim2.new(0,0,0,0)
    Title.BackgroundTransparency = 1
    Title.Text = "Clean Hub"
    Title.TextColor3 = PURPLE
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 32
    Title.TextScaled = false
    Title.TextXAlignment = Enum.TextXAlignment.Center
    Title.TextYAlignment = Enum.TextYAlignment.Center
    Title.ZIndex = 4

    local HeaderLine = Instance.new("Frame", Header)
    HeaderLine.Size = UDim2.new(1,-28,0,1.5)
    HeaderLine.Position = UDim2.new(0,14,1,-2)
    HeaderLine.BackgroundColor3 = PURPLE
    HeaderLine.BackgroundTransparency = 0.5
    HeaderLine.BorderSizePixel = 0
    HeaderLine.ZIndex = 3

    local closeBtn = Instance.new("TextButton", Header)
    closeBtn.Size = UDim2.new(0,28,0,28)
    closeBtn.Position = UDim2.new(1,-38,0.5,-14)
    closeBtn.BackgroundColor3 = BLACK
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = PURPLE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.ZIndex = 6
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

    local miniToggleBtn = Instance.new("TextButton", gui)
    miniToggleBtn.Name = "MiniToggle"
    miniToggleBtn.Size = UDim2.new(0, 100, 0, 40)
    miniToggleBtn.Position = UDim2.new(0.02, 0, 0.45, -20)
    miniToggleBtn.BackgroundColor3 = BLACK
    miniToggleBtn.Text = "CLEAN"
    miniToggleBtn.TextColor3 = PURPLE
    miniToggleBtn.Font = Enum.Font.GothamBold
    miniToggleBtn.TextSize = 14
    miniToggleBtn.BorderSizePixel = 0
    miniToggleBtn.ZIndex = 100
    miniToggleBtn.Visible = false
    Instance.new("UICorner", miniToggleBtn).CornerRadius = UDim.new(0, 10)

    miniToggleBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        miniToggleBtn.Visible = false
    end)

    local miniDrag, miniDragStart, miniStartPos
    miniToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            miniDrag = true
            miniDragStart = input.Position
            miniStartPos = miniToggleBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then miniDrag = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if miniDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - miniDragStart
            miniToggleBtn.Position = UDim2.new(miniStartPos.X.Scale, miniStartPos.X.Offset + delta.X, miniStartPos.Y.Scale, miniStartPos.Y.Offset + delta.Y)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        miniToggleBtn.Visible = true
    end)

    -- CONTENIDO
    local Content = Instance.new("ScrollingFrame", mainFrame)
    Content.Name = "Content"
    Content.Size = UDim2.new(1,-20,1,-85)
    Content.Position = UDim2.new(0,10,0,75)
    Content.BackgroundTransparency = 1
    Content.ZIndex = 3
    Content.CanvasSize = UDim2.new(0,0,0,0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.ScrollBarThickness = 3
    Content.ScrollBarImageColor3 = PURPLE
    Content.ScrollBarImageTransparency = 0.3

    local contentLayout = Instance.new("UIListLayout", Content)
    contentLayout.Padding = UDim.new(0, 14)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local contentPad = Instance.new("UIPadding", Content)
    contentPad.PaddingLeft = UDim.new(0,4)
    contentPad.PaddingRight = UDim.new(0,8)
    contentPad.PaddingTop = UDim.new(0,4)
    contentPad.PaddingBottom = UDim.new(0,8)

    -- HELPER FUNCTIONS MEJORADAS
    local function mkSect(parent, txt)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1,0,0,28)
        f.BackgroundTransparency = 1
        f.LayoutOrder = #parent:GetChildren() + 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1,0,1,0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = PURPLE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 14
        l.TextXAlignment = Enum.TextXAlignment.Left
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1,0,0,1)
        line.Position = UDim2.new(0,0,1,-1)
        line.BackgroundColor3 = PURPLE
        line.BackgroundTransparency = 0.6
        line.BorderSizePixel = 0
    end

    local function mkRow(parent)
        local f = Instance.new("Frame", parent)
        f.Size = UDim2.new(1,0,0,44)
        f.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        f.BackgroundTransparency = 0.4
        f.BorderSizePixel = 0
        f.LayoutOrder = #parent:GetChildren() + 1
        f.ZIndex = 2
        local corner = Instance.new("UICorner", f)
        corner.CornerRadius = UDim.new(0, 8)
        local pad = Instance.new("UIPadding", f)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        pad.PaddingTop = UDim.new(0, 4)
        pad.PaddingBottom = UDim.new(0, 4)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55,0,1,0)
        l.Position = UDim2.new(0,0,0,0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = PURPLE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 16
        l.TextXAlignment = Enum.TextXAlignment.Left
    end

    local function mkToggle(parent, txt, cb, initVal)
        local row = mkRow(parent)
        mkLabel(row, txt)
        local chk = Instance.new("TextButton", row)
        chk.Size = UDim2.new(0, 28, 0, 28)
        chk.Position = UDim2.new(1, -34, 0.5, -14)
        chk.BackgroundColor3 = initVal and TOGGLE_ON_COLOR or CHECK_OFF
        chk.BorderSizePixel = 0
        chk.Text = ""
        chk.ZIndex = 5
        Instance.new("UICorner", chk).CornerRadius = UDim.new(1,0)
        local state = initVal == true
        local function sv(s)
            state = s
            TS:Create(chk, TweenInfo.new(0.15), {BackgroundColor3 = s and TOGGLE_ON_COLOR or CHECK_OFF}):Play()
        end
        sv(state)
        chk.MouseButton1Click:Connect(function()
            if _anyKeyListening then return end
            state = not state
            sv(state)
            cb(state)
        end)
        return sv
    end

    local function mkBoxRow(parent, txt, default, cb)
        local row = mkRow(parent)
        mkLabel(row, txt)
        local tb = Instance.new("TextBox", row)
        tb.Size = UDim2.new(0,60,0,24)
        tb.Position = UDim2.new(1,-65,0.5,-12)
        tb.BackgroundColor3 = INP_BG
        tb.Text = tostring(default)
        tb.TextColor3 = PURPLE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 14
        tb.ClearTextOnFocus = false
        tb.ZIndex = 5
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0,6)
        tb.Focused:Connect(function() end)
        tb.FocusLost:Connect(function()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    local function mkKB(parent, kbEntry, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0,50,0,22)
        btn.Position = UDim2.new(1,-120,0.5,-11)
        btn.BackgroundColor3 = INP_BG
        btn.BorderSizePixel = 0
        local function getLabel()
            return (kbEntry.gp and getKeyDisplayName(kbEntry.gp, true)) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        end
        btn.Text = getLabel()
        btn.TextColor3 = PURPLE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
        local li, lc, pv, listenStart = false, nil, btn.Text, 0
        btn.MouseButton1Click:Connect(function()
            if li then
                li = false; _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                btn.Text = pv; return
            end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false; _anyKeyListening = false
                    if lc then lc:Disconnect(); lc = nil end
                    btn.Text = pv; return
                end
                local isGp = isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = getKeyDisplayName(inp.KeyCode, isGp)
                pv = btn.Text; li = false; _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                if cb then cb(inp.KeyCode, isGp) end
            end)
        end)
        return btn
    end

    local function mkToggleKB(parent, txt, kbEntry, onToggle, onKB)
        local row = mkRow(parent)
        mkLabel(row, txt)
        if kbEntry then
            mkKB(row, kbEntry, function(k, isGp)
                if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end
                if onKB then onKB(k, isGp) end
            end)
        end
        local chk = Instance.new("TextButton", row)
        chk.Size = UDim2.new(0, 28, 0, 28)
        chk.Position = UDim2.new(1, -34, 0.5, -14)
        chk.BackgroundColor3 = CHECK_OFF
        chk.BorderSizePixel = 0
        chk.Text = ""
        chk.ZIndex = 5
        Instance.new("UICorner", chk).CornerRadius = UDim.new(1,0)
        local state = false
        local function sv(s)
            state = s
            TS:Create(chk, TweenInfo.new(0.15), {BackgroundColor3 = s and TOGGLE_ON_COLOR or CHECK_OFF}):Play()
        end
        chk.MouseButton1Click:Connect(function()
            if _anyKeyListening then return end
            state = not state
            sv(state)
            if onToggle then onToggle(state) end
        end)
        return sv
    end

    -- Función para crear botones de acción con colores personalizados para TP Bat y Bat V2
    local function mkActionRow(parent, txt, onActivate, kbEntry, customColor)
        local row = mkRow(parent)
        mkLabel(row, txt)
        if kbEntry then
            mkKB(row, kbEntry, function(k, isGp)
                if isGp then kbEntry.gp = k; kbEntry.kb = nil else kbEntry.kb = k; kbEntry.gp = nil end
                saveConfig()
            end)
        end
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 50, 0, 24)
        btn.Position = UDim2.new(1, -56, 0.5, -12)
        btn.BackgroundColor3 = customColor or BTN_ACT
        btn.BorderSizePixel = 0
        btn.Text = "▶"
        btn.TextColor3 = PURPLE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.AutoButtonColor = false
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

        -- Para TP Bat y Bat V2: colores especiales
        if txt == "TP Bat" or txt == "Bat V2" then
            btn.BackgroundColor3 = HIGHLIGHT_COLOR
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = PURPLE_GLOW
            stroke.Thickness = 2
            stroke.Transparency = 0.3

            -- Efectos hover
            btn.MouseEnter:Connect(function()
                TS:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = PURPLE_LIGHT,
                    TextColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TS:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = HIGHLIGHT_COLOR,
                    TextColor3 = Color3.fromRGB(0, 0, 0)
                }):Play()
            end)
        end

        btn.MouseButton1Click:Connect(function()
            TS:Create(btn, TweenInfo.new(0.06), {
                BackgroundColor3 = (txt == "TP Bat" or txt == "Bat V2") and HIGHLIGHT_ACTIVE or PURPLE
            }):Play()
            TS:Create(btn, TweenInfo.new(0.06), {TextColor3 = BLACK}):Play()
            task.delay(0.14, function()
                TS:Create(btn, TweenInfo.new(0.1), {
                    BackgroundColor3 = customColor or BTN_ACT
                }):Play()
                TS:Create(btn, TweenInfo.new(0.1), {TextColor3 = PURPLE}):Play()
            end)
            if onActivate then onActivate() end
        end)
        return row
    end

    -- POBLAR CONTENIDO
    mkSect(Content, "Speed Values")
    mkBoxRow(Content, "Normal Speed", NS, function(v) if v>0 and v<=500 then NS=v end; saveConfig() end)
    mkBoxRow(Content, "Carry Speed", CS, function(v) if v>0 and v<=500 then CS=v end; saveConfig() end)
    mkBoxRow(Content, "Lagger Normal", LAGGER_SPEED, function(v) if v>0 and v<=500 then LAGGER_SPEED=v end; saveConfig() end)
    mkBoxRow(Content, "Lagger Carry", LAGGER_CARRY_SPEED, function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end; saveConfig() end)

    mkSect(Content, "Keybinds")
    mkActionRow(Content, "Speed Toggle",  nil, KB.SpeedToggle)
    mkActionRow(Content, "Lagger Toggle", nil, KB.LaggerToggle)
    mkActionRow(Content, "Insta Reset",   nil, KB.InstaReset)

    mkSect(Content, "Combat")
    setAutoSwingVisual   = mkToggle(Content, "Auto Swing",     function(on) autoSwingEnabled=on; saveConfig() end, autoSwingEnabled)
    setBatCounterVisual  = mkToggle(Content, "Bat Counter",    function(on) batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end; saveConfig() end, batCounterEnabled)
    setAntiRagVisual     = mkToggle(Content, "Anti Ragdoll",   function(on) antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end; saveConfig() end, antiRagdollEnabled)
    setMedusaVisual      = mkToggle(Content, "Medusa Counter", function(on) medusaCounterEnabled=on; if on then setupMedusa(LP.Character) else stopMedusaCounter() end; saveConfig() end, medusaCounterEnabled)
    setMedusaResetVisual = mkToggle(Content, "Medusa Reset",   function(on) medusaResetEnabled=on; saveConfig() end, medusaResetEnabled)
    setUnwalkVisual      = mkToggle(Content, "Unwalk",         function(on) unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end; saveConfig() end, unwalkEnabled)

    -- TP Bat con toggle y colores personalizados
    tpLockSetVisual = mkToggleKB(Content, "TP Bat", KB.TPLock, function(on)
        if _anyKeyListening then return end
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if batV2Enabled then toggleBatV2() end
            toggleTPLock()
        else if tpLockEnabled then toggleTPLock() end end
        saveConfig()
    end, function() saveConfig() end)
    tpLockSetVisual(tpLockEnabled)

    -- Bat V2 con toggle y colores personalizados
    batV2SetVisual = mkToggleKB(Content, "Bat V2", KB.BatV2Toggle, function(on)
        if _anyKeyListening then return end
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if tpLockEnabled then toggleTPLock() end
            toggleBatV2()
        else
            if batV2Enabled then toggleBatV2() end
        end
        saveConfig()
    end, function() saveConfig() end)
    batV2SetVisual(batV2Enabled)

    bodyLockSetVisual = mkToggle(Content, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then startBodyLock() else stopBodyLock() end
        if mobBtnRefs.bodyLock then mobBtnRefs.bodyLock(on) end
        saveConfig()
    end, bodyLockEnabled)
    mkBoxRow(Content, "Lock Range", bodyLockRange, function(v) if v > 0 and v <= 500 then bodyLockRange = v end; saveConfig() end)

    mkSect(Content, "Steal")
    mkBoxRow(Content, "Radius",   Steal.StealRadius,   function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v end; saveConfig() end)
    mkBoxRow(Content, "Duration", Steal.StealDuration, function(v) if v>=0.1 and v<=10  then Steal.StealDuration=v end; saveConfig() end)
    setInstaGrab = mkToggle(Content, "Auto Steal", function(on) Steal.AutoStealEnabled=on; if on then startAutoSteal() else stopAutoSteal() end; saveConfig() end, Steal.AutoStealEnabled)

    mkSect(Content, "Misc")
    setInfJumpVisual = mkToggle(Content, "Infinite Jump", function(on)
        infJumpEnabled=on
        if infJumpEnabled then if infJumpMode=="hold" then startHoldInfJump() end
        else stopHoldInfJump() end
        saveConfig()
    end, infJumpEnabled)

    do
        local row = mkRow(Content); mkLabel(row, "Jump Mode")
        local function mkModeBtn(lbl, xOff, mode)
            local b = Instance.new("TextButton", row)
            b.Size = UDim2.new(0,60,0,24); b.Position = UDim2.new(1,xOff,0.5,-12)
            b.BackgroundColor3 = (infJumpMode==mode) and PURPLE or BTN_ACT
            b.BorderSizePixel = 0; b.Text = lbl
            b.TextColor3 = (infJumpMode==mode) and BLACK or Color3.fromRGB(180,180,200)
            b.Font = Enum.Font.GothamBold; b.TextSize = 12; b.AutoButtonColor = false; b.ZIndex = 5
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
            b.MouseButton1Click:Connect(function()
                infJumpMode = mode
                b.BackgroundColor3=PURPLE; b.TextColor3=BLACK
                for _, child in ipairs(row:GetChildren()) do
                    if child:IsA("TextButton") and child ~= b then
                        child.BackgroundColor3=BTN_ACT; child.TextColor3=Color3.fromRGB(180,180,200)
                    end
                end
                if infJumpEnabled then
                    if mode == "hold" then startHoldInfJump() else stopHoldInfJump() end
                end
                saveConfig()
            end)
            return b
        end
        mkModeBtn("Manual", -130, "manual")
        mkModeBtn("Hold", -65, "hold")
    end

    mkSect(Content, "Movement")
    autoLeftSetVisual = mkToggleKB(Content, "Auto Left", KB.AutoLeft, function(on)
        autoLeftEnabled=on
        if on then
            if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if tpLockEnabled then toggleTPLock() end
            if batV2Enabled then toggleBatV2() end
            startAutoLeft()
        else stopAutoLeft() end; saveConfig()
    end, function() saveConfig() end)
    autoLeftSetVisual(autoLeftEnabled)

    autoRightSetVisual = mkToggleKB(Content, "Auto Right", KB.AutoRight, function(on)
        autoRightEnabled=on
        if on then
            if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if tpLockEnabled then toggleTPLock() end
            if batV2Enabled then toggleBatV2() end
            startAutoRight()
        else stopAutoRight() end; saveConfig()
    end, function() saveConfig() end)
    autoRightSetVisual(autoRightEnabled)

    mkActionRow(Content, "Drop Brainrot", function() runDrop() end,     KB.DropBrainrot)
    mkActionRow(Content, "TP Down",       function() runTPFloor() end,  KB.TPFloor)
    setAutoTPVisual = mkToggle(Content, "Auto TP", function(on) autoTPEnabled=on; if on then startAutoTP() else stopAutoTP() end; saveConfig() end, autoTPEnabled)
    mkBoxRow(Content, "TP Height", autoTPHeight, function(v) if v>=0 and v<=500 then autoTPHeight=v end; saveConfig() end)

    mkSect(Content, "Visual Effects")
    setEspVisual = mkToggle(Content, "ESP", function(on)
        espEnabled = on
        if on then startESP() else stopESP() end
        saveConfig()
    end, espEnabled)
    setAntiLagVisual    = mkToggle(Content, "Anti Lag",    function(on) if on then enableAntiLag() else disableAntiLag() end; saveConfig() end, antiLagEnabled)
    setStretchRezVisual = mkToggle(Content, "Stretch Rez", function(on) if on then enableStretchRez() else disableStretchRez() end; saveConfig() end, stretchRezEnabled)

    mkSect(Content, "Button Shapes")
    setCircleBtnsVisual = mkToggle(Content, "Circle Buttons", function(on)
        circleButtonsEnabled=on
        if on then shapeButtonsEnabled=false; rectangularButtonsEnabled=false
            if setShapeVisual then setShapeVisual(false) end
            if setRectVisual then setRectVisual(false) end
        end
        if mobGuiRef then buildMobileButtons() end; saveConfig()
    end, circleButtonsEnabled)

    setShapeVisual = mkToggle(Content, "Shape Buttons", function(on)
        shapeButtonsEnabled=on
        if on then circleButtonsEnabled=false; rectangularButtonsEnabled=false
            if setCircleBtnsVisual then setCircleBtnsVisual(false) end
            if setRectVisual then setRectVisual(false) end
        end
        if mobGuiRef then buildMobileButtons() end; saveConfig()
    end, shapeButtonsEnabled)

    setRectVisual = mkToggle(Content, "Rectangular Buttons", function(on)
        rectangularButtonsEnabled=on
        if on then circleButtonsEnabled=false; shapeButtonsEnabled=false
            if setCircleBtnsVisual then setCircleBtnsVisual(false) end
            if setShapeVisual then setShapeVisual(false) end
        end
        if mobGuiRef then buildMobileButtons() end; saveConfig()
    end, rectangularButtonsEnabled)

    mkSect(Content, "Sky Theme")
    do
        local row = mkRow(Content); mkLabel(row, "Current Theme")
        local currentLbl = Instance.new("TextLabel", row)
        currentLbl.Size = UDim2.new(0,120,1,0); currentLbl.Position = UDim2.new(1,-124,0,0)
        currentLbl.BackgroundTransparency = 1; currentLbl.Text = currentSkyTheme or "Off"
        currentLbl.TextColor3 = PURPLE; currentLbl.Font = Enum.Font.GothamBold
        currentLbl.TextSize = 14; currentLbl.TextXAlignment = Enum.TextXAlignment.Right; currentLbl.ZIndex = 5

        local gridContainer = Instance.new("Frame", Content)
        gridContainer.Size = UDim2.new(1,0,0,0); gridContainer.AutomaticSize = Enum.AutomaticSize.Y
        gridContainer.BackgroundTransparency = 1; gridContainer.LayoutOrder = #Content:GetChildren()+1
        local grid = Instance.new("UIGridLayout", gridContainer)
        grid.CellSize = UDim2.new(1/3,-4,0,30); grid.CellPadding = UDim2.new(0,4,0,4)
        grid.SortOrder = Enum.SortOrder.LayoutOrder; grid.FillDirection = Enum.FillDirection.Horizontal

        local function refreshSkyBtns()
            for _, child in ipairs(gridContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    local theme = child:GetAttribute("Theme"); local isActive = (theme == currentSkyTheme)
                    child.BackgroundColor3 = isActive and PURPLE or BTN_ACT
                    child.TextColor3 = isActive and BLACK or Color3.fromRGB(180,180,200)
                end
            end
            currentLbl.Text = currentSkyTheme or "Off"
        end

        for _, theme in ipairs(SKY_ORDER) do
            local btn = Instance.new("TextButton", gridContainer)
            btn.BackgroundColor3 = (theme==currentSkyTheme) and PURPLE or BTN_ACT
            btn.BorderSizePixel = 0; btn.Text = theme
            btn.TextColor3 = (theme==currentSkyTheme) and BLACK or Color3.fromRGB(180,180,200)
            btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.TextWrapped = true
            btn.AutoButtonColor = false; btn.ZIndex = 5
            btn:SetAttribute("Theme", theme)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
            btn.MouseButton1Click:Connect(function()
                currentSkyTheme = theme; applySkyTheme(theme); refreshSkyBtns(); saveConfig()
            end)
        end
        refreshSkyBtns()
    end

    mkSect(Content, "Interface")
    setLockVisual = mkToggle(Content, "Lock UI", function(on) uiLocked=on; saveConfig() end, uiLocked)

    do
        local row = mkRow(Content); mkLabel(row, "Reset Buttons")
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(0,70,0,24); resetBtn.Position = UDim2.new(1,-75,0.5,-12)
        resetBtn.BackgroundColor3 = BTN_ACT; resetBtn.BorderSizePixel = 0
        resetBtn.Text = "Reset"; resetBtn.TextColor3 = PURPLE
        resetBtn.Font = Enum.Font.GothamBold; resetBtn.TextSize = 12
        resetBtn.AutoButtonColor = false; resetBtn.ZIndex = 5
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,5)
        resetBtn.MouseButton1Click:Connect(function()
            resetBtnPositions()
            TS:Create(resetBtn, TweenInfo.new(0.1), {BackgroundColor3=PURPLE}):Play()
            task.delay(0.15, function() TS:Create(resetBtn, TweenInfo.new(0.1), {BackgroundColor3=BTN_ACT}):Play() end)
        end)
    end

    setMobVisual = mkToggle(Content, "Show Mobile UI", function(on)
        mobileButtonsEnabled=on; if on then buildMobileButtons() else destroyMobileButtons() end; saveConfig()
    end, mobileButtonsEnabled)

    mkBoxRow(Content, "Button Size", mobileButtonsSize, function(v)
        if v>=10 and v<=200 then mobileButtonsSize=v; if mobileButtonsEnabled then buildMobileButtons() end; saveConfig() end
    end)

    mkToggle(Content, "Lock buttons", function(on)
        perButtonDragEnabled = on
        saveConfig()
    end, perButtonDragEnabled)

    mkSect(Content, "UI Scale")
    mkBoxRow(Content, "UI Scale", uiScaleValue, function(v)
        if v>=0.4 and v<=1.3 then
            uiScaleValue=v; if uiScaleObject then uiScaleObject.Scale=v end; saveConfig()
        end
    end)
end

loadConfig()
uiScaleValue = 0.6
buildGui()
createStealBar()
if mobileButtonsEnabled then task.spawn(buildMobileButtons) end
applyState()
task.spawn(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            task.spawn(function()
                if plr.Character then createPlayerSpeedLabel(plr)
                else plr.CharacterAdded:Wait(); createPlayerSpeedLabel(plr) end
            end)
        end
    end
end)

print("✅ Clean Hub - Script cargado correctamente")