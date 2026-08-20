do
    local animationPlayer = game:GetService("Players").LocalPlayer
    local animationRunService = game:GetService("RunService")
    local ANIM_PACKS = {
        Tryhard = {
            idle1 = "rbxassetid://133806214992291",
            idle2 = "rbxassetid://94970088341563",
            walk = "rbxassetid://707897309",
            run = "rbxassetid://707861613",
            jump = "rbxassetid://116936326516985",
            fall = "rbxassetid://116936326516985",
            climb = "rbxassetid://116936326516985",
            swim = "rbxassetid://116936326516985",
            swimidle = "rbxassetid://116936326516985",
        },
        Crazy = {
            idle1 = "rbxassetid://133806214992291",
            idle2 = "rbxassetid://94970088341563",
            walk = "rbxassetid://134824450619865",
            run = "rbxassetid://134824450619865",
            jump = "rbxassetid://121454505477205",
            fall = "rbxassetid://94788218468396",
            climb = "rbxassetid://121454505477205",
            swim = "rbxassetid://121454505477205",
            swimidle = "rbxassetid://121454505477205",
        },
    }
    local ANIM_PACK_ORDER = {{"Off", "Off"}, {"Tryhard", "Tryhard"}, {"Crazy", "Crazy"}}
    local currentAnimPack = "Off"
    local originalTryardAnims = nil
    local tryardHeartbeatConn = nil

    local function isPackAnim(id)
        for _, pack in pairs(ANIM_PACKS) do
            for _, value in pairs(pack) do
                if value == id then return true end
            end
        end
        return false
    end

    local function saveOriginalAnims(char)
        local animate = char and char:FindFirstChild("Animate")
        if not animate then return end
        local function get(obj) return obj and obj.AnimationId or nil end
        local ids = {
            idle1 = get(animate.idle and animate.idle.Animation1),
            idle2 = get(animate.idle and animate.idle.Animation2),
            walk = get(animate.walk and animate.walk.WalkAnim),
            run = get(animate.run and animate.run.RunAnim),
            jump = get(animate.jump and animate.jump.JumpAnim),
            fall = get(animate.fall and animate.fall.FallAnim),
            climb = get(animate.climb and animate.climb.ClimbAnim),
            swim = get(animate.swim and animate.swim.Swim),
            swimidle = get(animate.swimidle and animate.swimidle.SwimIdle),
        }
        if not isPackAnim(ids.walk) then originalTryardAnims = ids end
    end

    local function applyAnimPack(packName)
        currentAnimPack = packName
        if _G.animSelectorBtn then _G.animSelectorBtn.Text = packName end
        if packName == "Off" then
            if originalTryardAnims and animationPlayer.Character then
                local animate = animationPlayer.Character:FindFirstChild("Animate")
                if animate then
                    local function set(obj, id) if obj and id then obj.AnimationId = id end end
                    set(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                    set(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                    set(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                    set(animate.run and animate.run.RunAnim, originalTryardAnims.run)
                    set(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                    set(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                    set(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                    set(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                    set(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
                end
            end
            if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
            return
        end

        local pack = ANIM_PACKS[packName]
        if not pack then return end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
        tryardHeartbeatConn = animationRunService.Heartbeat:Connect(function()
            local char = animationPlayer.Character
            local animate = char and char:FindFirstChild("Animate")
            if not animate then return end
            local function set(obj, id) if obj and id then obj.AnimationId = id end end
            set(animate.idle and animate.idle.Animation1, pack.idle1)
            set(animate.idle and animate.idle.Animation2, pack.idle2)
            set(animate.walk and animate.walk.WalkAnim, pack.walk)
            set(animate.run and animate.run.RunAnim, pack.run)
            set(animate.jump and animate.jump.JumpAnim, pack.jump)
            set(animate.fall and animate.fall.FallAnim, pack.fall)
            set(animate.climb and animate.climb.ClimbAnim, pack.climb)
            set(animate.swim and animate.swim.Swim, pack.swim)
            set(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
        end)
    end

    local function startAnimPack(packName)
        local char = animationPlayer.Character
        if char then
            saveOriginalAnims(char)
            applyAnimPack(packName)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        else
            applyAnimPack(packName)
        end
    end

    local function stopAnimPack()
        applyAnimPack("Off")
    end

    _G.toggleAnimSystem = function(on)
        if on then
            local selected = currentAnimPack == "Off" and "Tryhard" or currentAnimPack
            startAnimPack(selected)
        else
            stopAnimPack()
        end
    end
    _G.setAnimPack = function(name)
        if name == "Off" then stopAnimPack()
        elseif ANIM_PACKS[name] then startAnimPack(name) end
    end
    _G.getAnimPack = function() return currentAnimPack end
    _G.getAnimEnabled = function() return currentAnimPack ~= "Off" end
    _G.getAnimPacks = function() return {"Off", "Tryhard", "Crazy"} end
    _G.startAnimPack = startAnimPack
    _G.stopAnimPack = stopAnimPack
    _G.ANIM_PACK_ORDER = ANIM_PACK_ORDER
end

repeat task.wait() until game:IsLoaded()
local Players, RunService, UIS, TS, Lighting, HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
local LP = Players.LocalPlayer
local NS, CS = 60, 29
local LAGGER_SPEED_1 = 20
local LAGGER_SPEED_2 = 10
local BAT_AIMBOT_SPEED = 58
local BYPASS_AIMBOT_SPEED = 60
local speedMode, antiRagdollEnabled = false, false
_G.__FROST_MOBILE_BUTTON_REFS = {}
_G.__FROST_UI_SIZE = _G.__FROST_UI_SIZE or 75
_G.__FROST_UI_SCALE_OBJ = nil
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

-- ====== STRETCH ======
local stretchEnabled = false
local stretchFOV = 120
local stretchConn = nil
local stretchFovConn = nil
local origFOV = 70

local medusaAutoResetEnabled = false
local medusaResetConns = {}
local setMedusaAutoResetVisual = nil

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
    stopAutoSteal()
    stopAutoTPDown()
    disableAutoBat()
    stopBypassAimbot()
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    isStealing = false
    Steal.cachedPrompts = {}
    Steal.promptCacheTime = 0
    _hittingCooldown = false
    bypassHittingCooldown = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

-- TRACERS
if tracersEnabled then 
    stopTracers() 
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
end

local bypassToggled = false
local bypassFloatingButton = nil
local bypassFloatingPos = nil
local bypassMode = 1
local bypassModeBtnRef = nil
local dropMode = 1
local dropModeBtnRef = nil
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

-- ====== AUTO STEAL ======
local Steal = {
    AutoStealEnabled = false,
    StealRadius = 9,
    StealDuration = 1.37,
    Data = {},
    cachedPrompts = {},
    promptCacheTime = 0,
}
local isStealing = false
local stealStartTime = nil
local lastStealTick = 0
local STEAL_COOLDOWN = 0.1
local PROMPT_CACHE_REFRESH = 0.15

local Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil,
    autoLeft = nil, autoRight = nil}
local progressFill = nil
local progressPct = nil
local progressRadLbl = nil

local function findNearestPrompt()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not root then return nil, math.huge end

    local ct = tick()
    if ct - Steal.promptCacheTime < PROMPT_CACHE_REFRESH and #Steal.cachedPrompts > 0 then
        local nearest, nearestDist = nil, math.huge
        for _, item in ipairs(Steal.cachedPrompts) do
            if item.prompt and item.prompt.Parent and item.prompt.Enabled ~= false then
                local dist = (item.spawn.Position - root.Position).Magnitude
                if dist <= Steal.StealRadius and dist < nearestDist then
                    nearest, nearestDist = item.prompt, dist
                end
            end
        end
        if nearest then return nearest, nearestDist end
    end

    Steal.cachedPrompts = {}
    Steal.promptCacheTime = ct
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then return nil, math.huge end

    local nearest, nearestDist = nil, math.huge
    for _, plot in ipairs(plotsFolder:GetChildren()) do
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if podiums then
            for _, podium in ipairs(podiums:GetChildren()) do
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attachment = spawn and spawn:FindFirstChild("PromptAttachment")
                if spawn and attachment then
                    for _, child in ipairs(attachment:GetChildren()) do
                        if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                            local dist = (spawn.Position - root.Position).Magnitude
                            table.insert(Steal.cachedPrompts, {prompt = child, spawn = spawn})
                            if dist <= Steal.StealRadius and dist < nearestDist then
                                nearest, nearestDist = child, dist
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest, nearestDist
end

local function executeSteal(prompt)
    local ct = tick()
    if ct - lastStealTick < STEAL_COOLDOWN or isStealing then return end
    if not prompt or not prompt.Parent or prompt.Enabled == false then return end

    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true, useFallback = false}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            else
                Steal.Data[prompt].useFallback = true
            end
        end)
    end

    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    stealStartTime = ct
    lastStealTick = ct

    if Conns.progress then Conns.progress:Disconnect() end
    Conns.progress = RunService.Heartbeat:Connect(function()
        if not isStealing then
            Conns.progress:Disconnect()
            Conns.progress = nil
            return
        end
        local prog = math.clamp((tick() - stealStartTime) / Steal.StealDuration, 0, 1)
        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
        if progressPct then progressPct.Text = math.floor(prog * 100) .. "%" end
    end)

    task.spawn(function()
        local ok = false
        pcall(function()
            if not data.useFallback and #data.hold > 0 then
                for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
                task.wait(Steal.StealDuration)
                for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
                ok = true
            end
        end)
        if not ok and type(fireproximityprompt) == "function" then
            pcall(function() fireproximityprompt(prompt) end)
            ok = true
            task.wait(Steal.StealDuration)
        end
        if not ok then
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(Steal.StealDuration)
                prompt:InputHoldEnd()
            end)
            ok = true
        end
        task.wait(Steal.StealDuration * 0.3)
        if Conns.progress then Conns.progress:Disconnect(); Conns.progress = nil end
        if resetProgressBar then resetProgressBar() end
        task.wait(0.05)
        data.ready = true
        isStealing = false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local prompt = findNearestPrompt()
        if prompt then
            executeSteal(prompt)
        elseif progressPct and not isStealing then
            progressPct.Text = "0%"
        end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal = nil end
    if Conns.progress then Conns.progress:Disconnect(); Conns.progress = nil end
    isStealing = false
    lastStealTick = 0
    Steal.cachedPrompts = {}
    Steal.promptCacheTime = 0
    if resetProgressBar then resetProgressBar() end
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
                        textLabel.Text = string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(210, 210, 214)  
                        textLabel.Font = Enum.Font.FredokaOne
                        textLabel.TextScaled = true
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(10, 10, 11)
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
                    label.Text = string.format("%.1f", speed)
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
-- Edit Buttons inicia desactivado: los botones quedan bloqueados individualmente
-- y se mueven junto con la GUI cuando Lock UI está desactivado.
local floatingButtonsLocked = true
local MobilePanel = nil
local floatingButtonScale = 1.0
local applyFloatingButtonScale = nil

local MobileButtons = {
    Visible = true,
    Frame = nil,
    Buttons = {}
}
local mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight
local mobSetDropBR, mobSetTpDown, mobSetAutoTPDown, mobSetCarry, mobSetLagger1, mobSetLagger2
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
    JumpMode    ={kb=Enum.KeyCode.V,gp=nil},
    Bypass      ={kb=Enum.KeyCode.N,gp=nil},
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
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if not autoBatEnabled and not bypassToggled and not autoLeftEnabled and not autoRightEnabled then
        local md = hum.MoveDirection
        local spd
        if laggerToggled then
            spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
        else
            spd = speedMode and CS or NS
        end
        
        -- ====== SPEED UNPATCH (CRÍTICO) ======
        -- Sin esto, el motor de Roblox revierte la velocidad a 16
        if hum.WalkSpeed ~= spd then
            hum.WalkSpeed = spd
        end
        -- ====================================
        
        if md.Magnitude > 0 then
            lastMoveDir = md
            hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true; break end
            end
            if anyHeld then
                hrp.Velocity = Vector3.new(lastMoveDir.X * spd, hrp.Velocity.Y, lastMoveDir.Z * spd)
            end
        end
    end
    if speedLabel then
        speedLabel.Text = string.format("Spd: %.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
    end
end)


local alConn, arConn = nil, nil
local alPhase, arPhase = 1, 1

local function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
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
        local spd = NS
        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
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
                return
            end
            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
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
        local spd = NS
        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
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
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
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
    local oldBB = head:FindFirstChild("LustHubSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "LustHubSpeedIndicator"
    bb.Size = UDim2.new(0, 180, 0, 56)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    local titleLabel = Instance.new("TextLabel", bb)
    titleLabel.Size = UDim2.new(1, 0, 0, 24)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = ""
    titleLabel.TextColor3 = Color3.fromRGB(210, 210, 214)  
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextSize = 18
    titleLabel.TextScaled = false
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(10, 10, 11)
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 0, 26)
    speedLabel.Position = UDim2.new(0, 0, 0, 24)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Spd: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(210, 210, 214)  
    speedLabel.Font = Enum.Font.FredokaOne
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(10, 10, 11)
end

local antiRagV2 = {
    Connection = nil,
    ResetCooldown = 0,
    Enabled = false
}

local function startAntiRagdoll()
    if antiRagV2.Connection then return end
    
    antiRagV2.Enabled = true
    antiRagV2.ResetCooldown = 0
    
    antiRagV2.Connection = RunService.Heartbeat:Connect(function()
        if not antiRagV2.Enabled then return end
        
        local char = LP.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        
        if not hum or not root then return end
        if hum.Health <= 0 then return end
        if hum:GetState() == Enum.HumanoidStateType.Dead then return end
        
        local state = hum:GetState()
        local now = tick()
        
        local isRagdolled = (
            state == Enum.HumanoidStateType.Physics or
            state == Enum.HumanoidStateType.Ragdoll or
            state == Enum.HumanoidStateType.FallingDown
        )
        
        local endTime = LP:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then
            isRagdolled = true
        end
        
        if isRagdolled then
            if now - antiRagV2.ResetCooldown > 0.15 then
                antiRagV2.ResetCooldown = now
                
                pcall(function()
                    local currentState = hum:GetState()
                    if currentState == Enum.HumanoidStateType.GettingUp then
                        return
                    end
                    
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then
                            obj.Enabled = true
                        end
                        if obj:IsA("Constraint") then
                            obj.Enabled = true
                        end
                        if obj:IsA("BallSocketConstraint") then
                            pcall(function() obj:Destroy() end)
                        end
                        if obj:IsA("Attachment") and obj.Name:find("RagdollAttachment") then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                    
                    workspace.CurrentCamera.CameraSubject = hum
                    
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = PM:FindFirstChild("ControlModule")
                        if CM then
                            local success, module = pcall(require, CM)
                            if success and module and module.Enable then
                                module:Enable()
                            end
                        end
                    end
                    
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                    
                    if hum.Health > 0 then
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                    
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                end)
            end
        end
    end)
end

local function stopAntiRagdoll()
    antiRagV2.Enabled = false
    
    if antiRagV2.Connection then
        antiRagV2.Connection:Disconnect()
        antiRagV2.Connection = nil
    end
    
    antiRagV2.ResetCooldown = 0
    
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.AutoRotate = true
        end
    end
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
    if dropMode == 1 then
        if speedH > 5 then
            cooldown = 0.6
        else
            cooldown = 0.25
        end
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
    if dropMode == 1 then
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
    else
        local conn = nil
        local startTime = tick()
        conn = RunService.Heartbeat:Connect(function()
            if not dropActive then
                conn:Disconnect()
                return
            end
            local c = LP.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if not root then
                conn:Disconnect()
                finishDrop()
                return
            end
            local elapsed = tick() - startTime
            if elapsed >= 0.2 then
                conn:Disconnect()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
                if rr then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    local off = (hum and hum.HipHeight or 2) + (root.Size.Y / 2)
                    root.CFrame = CFrame.new(root.Position.X, rr.Position.Y + off, root.Position.Z)
                    root.AssemblyLinearVelocity = Vector3.zero
                end
                finishDrop()
                return
            end
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 150, root.AssemblyLinearVelocity.Z)
        end)
        table.insert(dropConnections, conn)
    end
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

local infJumpConn = nil
local holdJumpConn = nil
local holdJumpJumpConn = nil

local function startJumpMode()
    if not jumpEnabled then return end
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

RunService.Heartbeat:Connect(function()
    if not jumpEnabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and root.Velocity.Y < -120 then
        root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
    end
end)

local defLightBrightness,defLightClock,defLightAmbient,defGlobalShadows,defFogEnd

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
                btnFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 11)
                local lbl = btnFrame:FindFirstChild("TextLabel")
                if lbl then lbl.TextColor3 = Color3.fromRGB(210, 210, 214) end
            end
        end
        stopBypassAimbot()
    end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

disableAutoBat = function()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
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
    end
end

-- ====== BYPASS AIMBOT ======
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
            if bypassToggled then
                btnFrame.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
                if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            else
                btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            end
        end
    end
    if bypassSetVisual then bypassSetVisual(bypassToggled) end
end

local function toggleBypassMode()
    bypassMode = bypassMode == 1 and 2 or 1
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    if bypassToggled then
        stopBypassAimbot()
        startBypassAimbot()
    end
end

-- ====== TP DOWN MEJORADO ======
local autoTPDownEnabled = false
local autoTPDownConn = nil
local autoTPDownThreshold = 20

local function tpToGround()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Guardar la rotación actual (solo Yaw)
    local _, yaw, _ = hrp.CFrame:ToEulerAnglesYXZ()
    
    -- Teleportar al suelo (Y = -7.00) manteniendo X y Z
    hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
        * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    
    -- Resetear estado del humanoid
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function executeTPDown()
    tpToGround()
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
            tpToGround()
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
            modeValLbl.Text = laggerLevel == 1 and "Lagger Mode 1" or "Lagger Mode 2"
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
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
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
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel==1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel==2) end
end

local function toggleLockUI(state)
    if state == nil then
        uiLocked = not uiLocked
    else
        uiLocked = state
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

-- ====== RESTAURAR POSICIONES ======
local mobileButtonPositions = {}

-- Forward declarations: resetFloatingPositions is above the real save function.
local saveAllSettings
local lastSavedJSON
local function resetFloatingPositions()
    local BTN_W, BTN_H = 48, 48
    local GAP_X, GAP_Y = 4, 4

    -- Posiciones originales solicitadas.
    local defaults = {
        BatBypass = {-(BTN_W + GAP_X), 0},                    -- al lado de DROP
        TpBat     = {-(BTN_W + GAP_X), (BTN_H + GAP_Y) * 2}, -- debajo de RESET

        DropBR    = {0, 0},
        AutoLeft  = {BTN_W + GAP_X, 0},
        AutoBat   = {0, BTN_H + GAP_Y},
        AutoRight = {BTN_W + GAP_X, BTN_H + GAP_Y},
        -- TP Down manual conserva su posición original.
        TpDown     = {0, (BTN_H + GAP_Y) * 2},
        Carry      = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 2},
        Lagger1      = {0, (BTN_H + GAP_Y) * 3},
        Lagger2      = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 3},
    }

    -- Resetear el panel base.
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        MobilePanel.FloatingPanel.Position = UDim2.new(1, -138, 0, 0)
    end

    -- El propio panel móvil conoce las referencias y posiciones reales.
    -- Esta función se puede llamar todas las veces que quieras.
    if type(_G.__FROST_RESET_MOBILE_BUTTONS) == "function" then
        pcall(_G.__FROST_RESET_MOBILE_BUTTONS)
    else
        local refs = _G.__FROST_MOBILE_BUTTON_REFS or {}
        for name, pos in pairs(defaults) do
            local btn = refs[name]
            if btn and btn.Parent then
                btn.Position = UDim2.new(0, pos[1], 0, pos[2])
            end
        end
    end

    -- Limpiar posiciones guardadas SIN sustituir la tabla:
    -- así todos los closures siguen usando la misma referencia.
    for key in pairs(mobileButtonPositions) do
        mobileButtonPositions[key] = nil
    end

    bypassFloatingPos = nil
    savedMobilePanelPos = nil

    -- Guardar inmediatamente el estado limpio.
    lastSavedJSON = nil
    if saveAllSettings then
        pcall(saveAllSettings)
    end
end

-- ====== CONFIGURACIÓN ======
local CONFIG_FILE = "LustHub.json"
local savedMobilePanelPos = nil
local savedProgressBarPos = nil
local savedBypassPos = nil
lastSavedJSON = nil

local function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        stealRadius = Steal.StealRadius,
        stealDuration = Steal.StealDuration,
        autoTPHeight = autoTPHeight,
        antiRagdoll = antiRagdollEnabled,
        autoSteal = Steal.AutoStealEnabled,
        jumpEnabled = jumpEnabled,
        jumpMode = jumpMode,
        tpDownMode = tpDownMode,
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
        tracersEnabled = tracersEnabled,
        autoTPDownEnabled = autoTPDownEnabled,
        autoTPDownThreshold = autoTPDownThreshold,
        lockUI = uiLocked,
        lockButtons = floatingButtonsLocked,
        uiSize = tonumber(_G.__FROST_UI_SIZE) or 75,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        bypassToggled = false,
        bypassSpeed = BYPASS_AIMBOT_SPEED,
        bypassMode = bypassMode,
        dropMode = dropMode,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        autoTPDownKey = {kb = KB.AutoTPDown.kb and KB.AutoTPDown.kb.Name, gp = KB.AutoTPDown.gp and KB.AutoTPDown.gp.Name},
        jumpModeKey = {kb = KB.JumpMode.kb and KB.JumpMode.kb.Name, gp = KB.JumpMode.gp and KB.JumpMode.gp.Name},
        bypassKey = {kb = KB.Bypass.kb and KB.Bypass.kb.Name, gp = KB.Bypass.gp and KB.Bypass.gp.Name},
        bypassFloatingPos = bypassFloatingPos,
        mobileButtonPositions = mobileButtonPositions,
        -- Versión de distribución: Auto TP Down queda junto a Lagger OFF.
        autoTPDownPositionVersion = 2,
        mobileButtonScale = floatingButtonScale,
        animSystemEnabled = _G.getAnimEnabled and _G.getAnimEnabled() or false,
        animSystemSelected = _G.getAnimPack and _G.getAnimPack() or "Anim Pack",
        skyTheme = currentSkyTheme,
        accessoryPack = currentAccessoryPack,
        cipherImage = _G.CipherSelectedImage,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale,
            XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale,
            YOffset = pbFrame.Position.Y.Offset
        }
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {
            XScale = container.Position.X.Scale,
            XOffset = container.Position.X.Offset,
            YScale = container.Position.Y.Scale,
            YOffset = container.Position.Y.Offset
        }
    end
    return config
end

saveAllSettings = function()
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
    if data.stealRadius then Steal.StealRadius = data.stealRadius end
    if data.stealDuration then Steal.StealDuration = data.stealDuration end
    if data.autoTPHeight then autoTPHeight = data.autoTPHeight end
    if data.autoTPDownEnabled ~= nil then autoTPDownEnabled = data.autoTPDownEnabled end
    if data.autoTPDownThreshold then autoTPDownThreshold = data.autoTPDownThreshold end
    if data.lockUI ~= nil then uiLocked = data.lockUI end
    if data.lockButtons ~= nil then floatingButtonsLocked = data.lockButtons == true end
    if data.uiSize then
        _G.__FROST_UI_SIZE = math.clamp(tonumber(data.uiSize) or 75, 50, 150)
        if _G.__FROST_UI_SCALE_OBJ then
            _G.__FROST_UI_SCALE_OBJ.Scale = _G.__FROST_UI_SIZE / 100
        end
    end
-- TRACERS
if data.tracersEnabled ~= nil then
    tracersEnabled = data.tracersEnabled
    if tracerToggleSetter then
        tracerToggleSetter(tracersEnabled)
    end
    if tracersEnabled then
        task.spawn(function()
            task.wait(0.5)
            startTracers()
        end)
    end
end
    if data.autoLeft ~= nil then autoLeftEnabled = data.autoLeft end
    if data.autoRight ~= nil then autoRightEnabled = data.autoRight end
    if data.antiRagdoll then antiRagdollEnabled = data.antiRagdoll end
    if data.autoSteal ~= nil then Steal.AutoStealEnabled = data.autoSteal == true end
    if data.jumpEnabled ~= nil then jumpEnabled = data.jumpEnabled end
    if data.jumpMode then jumpMode = data.jumpMode end
    if data.tpDownMode then tpDownMode = data.tpDownMode end
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
    if data.bypassFloatingPos then
        bypassFloatingPos = data.bypassFloatingPos
    end
    if data.batAimbotSpeed then
        BAT_AIMBOT_SPEED = data.batAimbotSpeed
        if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    end
    if data.bypassSpeed then
        BYPASS_AIMBOT_SPEED = data.bypassSpeed
        if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    end
    bypassToggled = false
    if data.bypassMode then
        bypassMode = data.bypassMode
        if bypassModeBtnRef then
            bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
        end
    end
    if data.dropMode then
        dropMode = data.dropMode
        if dropModeBtnRef then
            dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
        end
    end
    if data.stretchEnabled ~= nil then
        stretchEnabled = data.stretchEnabled
    end
    if data.stretchFOV then
        stretchFOV = data.stretchFOV
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
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if type(data.mobileButtonPositions) == "table" then mobileButtonPositions = data.mobileButtonPositions end
    -- Migrar una sola vez la posición de Auto TP Down a la derecha de Lagger OFF.
    if data.autoTPDownPositionVersion ~= 2 then
        mobileButtonPositions.AutoTPDown = {
            XScale = 0,
            XOffset = 68,
            YScale = 0,
            YOffset = 234
        }
        mobileButtonPositions.LaggerToggle = {
            XScale = 0,
            XOffset = 0,
            YScale = 0,
            YOffset = 234
        }
    end
    if data.mobileButtonScale ~= nil then
        floatingButtonScale = math.clamp(tonumber(data.mobileButtonScale) or 1.0, 0.5, 2.0)
    end
    local savedAnimEnabled = data.animSystemEnabled
    if data.animSystemSelected and _G.setAnimPack then
        _G.setAnimPack(data.animSystemSelected)
        if animSelectorBtn then animSelectorBtn.Text = data.animSystemSelected end
        if _G.animSelectorBtn then _G.animSelectorBtn.Text = data.animSystemSelected end
    end
    if savedAnimEnabled ~= nil and _G.toggleAnimSystem then
        _G.toggleAnimSystem(savedAnimEnabled == true)
    end
    if data.skyTheme and type(setSkyTheme) == "function" then
        setSkyTheme(data.skyTheme)
    end
    if data.accessoryPack and table.find(ACCESSORY_PACK_ORDER, data.accessoryPack) then
        currentAccessoryPack = data.accessoryPack
        task.defer(function() applyAccessoryPack(currentAccessoryPack) end)
    end
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
    Steal.StealRadius = 9
    Steal.StealDuration = 1.3
    autoTPHeight = 20
    autoTPDownThreshold = 20
    speedMode = false
    laggerToggled = false
    laggerLevel = 1
    antiRagdollEnabled = false
    jumpEnabled = false
    jumpMode = 1
    tpDownMode = 1
    medusaCounterEnabled = false
    batCounterEnabled = false
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    unwalkEnabled = false
    antiLagEnabled = false
    autoTPDownEnabled = false
    uiLocked = false
    floatingButtonsLocked = true
    floatingButtonScale = 1.0
    Steal.AutoStealEnabled = false
    BAT_AIMBOT_SPEED = 58
    BYPASS_AIMBOT_SPEED = 60
    bypassToggled = false
    bypassMode = 1
    dropMode = 1
    medusaAutoResetEnabled = false
    stretchEnabled = false
    stretchFOV = 120
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if radInput then radInput.Text = tostring(Steal.StealRadius) end
    if stealDurationBox then stealDurationBox.Text = tostring(Steal.StealDuration) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if progressRadLbl then progressRadLbl.Text = "-- · --" end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if setBatCounterVisual then setBatCounterVisual(false) end
    if setMedusaVisual then setMedusaVisual(false) end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    if setAntiRagVisual then setAntiRagVisual(false) end
    if setJumpVisual then setJumpVisual(false) end
    if setUnwalkVisual then setUnwalkVisual(false) end
    if setAntiLagVisual then setAntiLagVisual(false) end
    if setAutoTPDownVisual then setAutoTPDownVisual(false) end
    if setLockUIVisual then setLockUIVisual(false) end
    if setLockButtonsVisual then setLockButtonsVisual(false) end
    if setInstaGrab then setInstaGrab(false) end
    if bypassSetVisual then bypassSetVisual(false) end
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    if mobSetDropBR then mobSetDropBR(false) end
    if mobSetTpDown then mobSetTpDown(false) end
    if mobSetAutoTPDown then mobSetAutoTPDown(false) end
    if mobSetCarry then mobSetCarry(false) end
    if mobSetLagger1 then mobSetLagger1(false) end
    if mobSetLagger2 then mobSetLagger2(false) end
    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end
    if tpModeSelectBtn then
        tpModeSelectBtn.Text = tpDownMode == 1 and "V1" or "V2"
    end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
    end
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    if setJumpToggleState then setJumpToggleState(false) end
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    lastSavedJSON = HS:JSONEncode(buildConfigTable())
end

local function deleteAllSettings()
    local success = false
    if isfile and isfile(CONFIG_FILE) then
        success = pcall(function() delfile(CONFIG_FILE); return true end)
    end
    if isfile and isfile("LustHub_PanelPos.txt") then
        pcall(delfile, "LustHub_PanelPos.txt")
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -140, 1, -66)
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        container.Position = UDim2.new(1, -128 - 10, 0, 0)
    end
    bypassFloatingPos = nil
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, 294 + 10)
    end
    return success
end

-- ====== GUI ======
local gui = nil
local main = nil
local miniBtn = nil

local function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 94)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200,200,200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 94))
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

-- ====== CIPHER IMAGEN: SELECTOR DE IMÁGENES ======
-- Imágenes configuradas para el selector Cipher Images.
local CIPHER_IMAGE_OPTIONS = {
    {name = "Cipher image 4", id = "rbxassetid://73164545344375"},
}
local selectedCipherImage = CIPHER_IMAGE_OPTIONS[1].id

-- Una sola imagen de fondo para toda la interfaz.
-- Cambia este ID para reemplazar el fondo completo.
local UI_BACKGROUND_IMAGE = "rbxassetid://101894744159774"

_G.CipherImageTargets = _G.CipherImageTargets or {}

local cipherThemeRed = Color3.fromRGB(225, 225, 225)
local cipherThemeBlue = Color3.fromRGB(225, 225, 225)
local cipherThemeColor = cipherThemeRed
local cipherThemeButtonColor = Color3.fromRGB(24, 24, 26)

local function applyCipherV28Theme(color)
    cipherThemeColor = color or cipherThemeRed
    cipherThemeButtonColor = Color3.fromRGB(24, 24, 26)

    local function paint(root)
        if not root then return end
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                if obj:GetAttribute("CipherKeepTextColor") ~= true then
                    obj.TextColor3 = obj:GetAttribute("CipherFloatingLabel") and cipherThemeColor or Color3.fromRGB(238, 238, 238)
                end
                obj.TextStrokeTransparency = 1
            end
            if obj:IsA("GuiButton") then
                if obj:GetAttribute("CipherKeepBackground") ~= true then
                    obj.BackgroundColor3 = obj:GetAttribute("CipherActive") and cipherThemeColor or Color3.fromRGB(28, 28, 30)
                end
                if obj:GetAttribute("CipherKeepTextColor") ~= true then
                    obj.TextColor3 = cipherThemeColor
                end
            elseif obj:IsA("UIStroke") then
                obj.Color = Color3.fromRGB(0, 0, 0)
                obj.Transparency = 0.05
            elseif obj:GetAttribute("CipherTogglePill") then
                local active = obj:GetAttribute("CipherActive") == true
                obj.BackgroundColor3 = active and cipherThemeColor or Color3.fromRGB(50, 50, 54)
            end
            if obj:IsA("UIGradient") and obj.Parent and (obj.Parent:GetAttribute("CipherFloatingLabel") or obj.Parent:GetAttribute("CipherThemeTitle")) then
                obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, cipherThemeColor),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, cipherThemeColor)
                })
            end
        end
    end

    paint(gui)
    paint(pbFrame)
    paint(MobilePanel)
    paint(bypassFloatingButton)

    -- Actualización directa: los botones flotantes viven en ScreenGui separados.
    -- Así sus bordes cambian inmediatamente al seleccionar otra Cipher image.
    local function refreshFloatingButtonTheme(button)
        if not button or not button.Parent then return end
        local active = button:GetAttribute("CipherActive") == true
        local stroke = button:FindFirstChild("RedOuterStroke") or button:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = active and Color3.fromRGB(210, 210, 214) or Color3.fromRGB(0, 0, 0)
            stroke.Transparency = 1
            stroke.Thickness = 1
        end
        local label = button:FindFirstChild("TextLabel")
        if label then
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
        end
        button.BackgroundColor3 = active and Color3.fromRGB(210, 210, 214) or Color3.fromRGB(0, 0, 0)
    end

    for _, button in pairs(_G.__FROST_MOBILE_BUTTON_REFS or {}) do
        refreshFloatingButtonTheme(button)
    end
    if bypassFloatingButton then
        refreshFloatingButtonTheme(bypassFloatingButton:FindFirstChild("Frame"))
    end

    if progressFill then progressFill.BackgroundColor3 = Color3.fromRGB(210, 210, 214) end
    if speedLabel and speedLabel.Parent then speedLabel.TextColor3 = cipherThemeColor end
    for _, label in pairs(enemySpeedLabels) do
        if label and label.Parent then label.TextColor3 = cipherThemeColor end
    end
end

local function applyCipherImage(imageId)
    if type(imageId) ~= "string" or imageId == "" then return end
    selectedCipherImage = imageId
    _G.CipherSelectedImage = imageId
    for _, target in pairs(_G.CipherImageTargets) do
        if target and target.Parent then
            target.Image = imageId
        end
    end
    -- Cipher image 1 y 2 usan rojo; Cipher image 3 y 4 usan azul.
    if imageId == CIPHER_IMAGE_OPTIONS[1].id or imageId == CIPHER_IMAGE_OPTIONS[2].id then
        applyCipherV28Theme(cipherThemeRed)
    elseif imageId == CIPHER_IMAGE_OPTIONS[3].id or imageId == CIPHER_IMAGE_OPTIONS[4].id then
        applyCipherV28Theme(cipherThemeBlue)
    end
end

-- ====== CONSTRUCCIÓN DE GUI ======
local function buildGui()
        local BLACK   = Color3.fromRGB(10, 10, 11)
    local ACCENT  = Color3.fromRGB(235, 235, 235)
    local INP     = Color3.fromRGB(28, 28, 30)
    local CORNER  = 20
    local GUI_W, GUI_H = 380, 460

    local old=game:GetService("CoreGui"):FindFirstChild("LustHub")
    if old then old:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui")
    if pg then
        local o=pg:FindFirstChild("LustHub")
        if o then o:Destroy() end
    end
    gui=Instance.new("ScreenGui")
    gui.Name="LustHub"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=10
    gui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end

    main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,GUI_W,0,GUI_H)
main.Position=UDim2.new(0,22,0,6)

_G.__FROST_UI_SCALE_OBJ = Instance.new("UIScale", main)
_G.__FROST_UI_SCALE_OBJ.Scale = math.clamp((tonumber(_G.__FROST_UI_SIZE) or 75) / 100, 0.5, 1.5)

-- ====== IMAGEN DE FONDO (ESTILO CIPHER) - AGREGAR AQUÍ ======
local fullUIBackground = Instance.new("ImageLabel", main)
fullUIBackground.Name = "FullUIBackground"
fullUIBackground.Size = UDim2.new(1, 0, 1, 0)
fullUIBackground.Position = UDim2.new(0, 0, 0, 0)
fullUIBackground.BackgroundTransparency = 1
fullUIBackground.BorderSizePixel = 0
-- Fondo fijo: primera imagen del antiguo selector Background.
fullUIBackground.Image = UI_BACKGROUND_IMAGE
fullUIBackground.ImageTransparency = 0
fullUIBackground.ScaleType = Enum.ScaleType.Crop
fullUIBackground.ZIndex = 0
local fullUIBackgroundCorner = Instance.new("UICorner", fullUIBackground)
fullUIBackgroundCorner.CornerRadius = UDim.new(0, CORNER)

local mainGrad = Instance.new("UIGradient", main)
mainGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 13)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 26, 28))
})

mainGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.88),
    NumberSequenceKeypoint.new(0.5, 0.80),
    NumberSequenceKeypoint.new(1, 0.88)
})
    
   mainGrad.Rotation = 90
mainGrad.Offset = Vector2.new(0,0)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 13)
main.BackgroundTransparency = 0.68
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner",main).CornerRadius=UDim.new(0,CORNER)

    task.spawn(function()
        local t=0
        while mainStroke and mainStroke.Parent do
            t = t + 0.04
            local phase = math.sin(t * 1.2)
            mainStroke.Color = Color3.fromRGB(
                128 + 64 * (phase * 0.5 + 0.5),
                128 + 64 * (phase * 0.5 + 0.5),
                128 + 64 * (phase * 0.5 + 0.5)
            )
            mainStroke.Transparency = 0.35 + 0.2 * math.sin(t * 1.8)
            if mainGrad then
                mainGrad.Offset = Vector2.new(math.sin(t * 0.3) * 0.15, math.cos(t * 0.25) * 0.15)
            end
            task.wait(0.04)
        end
    end)

    local shadow = Instance.new("Frame", main)
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, 4)
    shadow.BackgroundColor3 = Color3.fromRGB(10, 10, 11)
    shadow.BackgroundTransparency = 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, CORNER)

    -- Branding
    local brandFrame = Instance.new("Frame", main)
    brandFrame.Size = UDim2.new(1, -20, 0, 24)
    brandFrame.Position = UDim2.new(0, 12, 0, 8)
    brandFrame.BackgroundTransparency = 1

    local brandTitle = Instance.new("TextLabel", brandFrame)
    brandTitle.Size = UDim2.new(1, -40, 0, 26)
    brandTitle.Position = UDim2.new(0, 6, 0, 0)
    brandTitle.BackgroundTransparency = 1
    brandTitle.Text = "Shynx.vs"
    brandTitle.RichText = false
    brandTitle:SetAttribute("CipherThemeTitle", true)
    brandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)  
    brandTitle.Font = Enum.Font.GothamBlack
    brandTitle.TextSize = 22
    brandTitle.TextXAlignment = Enum.TextXAlignment.Left
    local titleGrad = Instance.new("UIGradient", brandTitle)
    titleGrad:SetAttribute("CipherThemeGradient", true)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 184)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 184))
    })
    titleGrad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t=0
        while titleGrad and titleGrad.Parent do
            t = t + 0.03
            titleGrad.Offset = Vector2.new(math.sin(t * 0.8) * 0.3, 0)
            task.wait(0.04)
        end
    end)

    local brandSub = Instance.new("TextLabel", brandFrame)
    brandSub.Size = UDim2.new(1, 0, 0, 14)
    brandSub.Position = UDim2.new(0, 0, 0, 22)
    brandSub.BackgroundTransparency = 1
    brandSub.Text = ""
    brandSub.Visible = false
    brandSub.TextColor3 = Color3.fromRGB(210, 210, 214)
    brandSub.Font = Enum.Font.Gotham
    brandSub.TextSize = 10
    brandSub.TextXAlignment = Enum.TextXAlignment.Center
    applyShimmerToText(brandSub, 0.5)

    local brandLine = Instance.new("Frame", brandFrame)
    brandLine.Size = UDim2.new(0.4, 0, 0, 2)
    brandLine.Position = UDim2.new(0.3, 0, 1, -4)
    brandLine.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
    brandLine.Visible = false
    brandLine.BorderSizePixel = 0
    Instance.new("UICorner", brandLine).CornerRadius = UDim.new(1, 0)

    -- Botón cerrar
    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -34, 0, 9)
    closeBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
    closeBtn.BackgroundTransparency = 0.20
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = ACCENT
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 13
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    applyShimmerToText(closeBtn, 1.2)

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(255, 255, 255),BackgroundColor3=Color3.fromRGB(70, 70, 72)}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0,Color=Color3.fromRGB(255,255,255)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=ACCENT,BackgroundColor3=BLACK}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0.3,Color=ACCENT}):Play()
    end)

    miniBtn=Instance.new("TextButton",gui)
    miniBtn.Size=UDim2.new(0,118,0,30)
    miniBtn.Position=UDim2.new(0,16,0,58)
    miniBtn.BackgroundColor3=BLACK
    miniBtn.BorderSizePixel=0
    miniBtn.Text="Shynx.vs"
    miniBtn.TextColor3=ACCENT
    miniBtn.Font=Enum.Font.GothamBlack
    miniBtn.TextSize=12
    miniBtn.ZIndex=20
    miniBtn.Visible=false
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8)
    applyShimmerToText(miniBtn, 0.9)

    local function showGui()
        main.Visible=true
        miniBtn.Visible=false
    end

    local function hideGui()
        main.Visible=false
        miniBtn.Visible=true
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    -- Área de contenido
    local contentArea = Instance.new("Frame", main)
    -- Barra de pestañas compacta, inspirada en la referencia visual.
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "TabBar"
    -- Barra de pestañas a la izquierda.
    tabBar.Size = UDim2.new(0, 78, 1, -76)
    tabBar.Position = UDim2.new(0, 10, 0, 58)
    tabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 13)
    tabBar.BackgroundTransparency = 0.68
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 20
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)

    -- La barra es transparente para mostrar la misma imagen de fondo global.

    -- Identidad del jugador en la parte inferior de la barra lateral, estilo CLEAN HUB.
    local sideIdentity = Instance.new("Frame", tabBar)
    sideIdentity.Name = "SideIdentity"
    -- Identidad completa del jugador, colocada un poco más abajo como en CLEAN HUB.
    sideIdentity.Position = UDim2.new(0, 0, 1, -94)
    sideIdentity.Size = UDim2.new(1, 0, 0, 118)
    sideIdentity.BackgroundTransparency = 1
    sideIdentity.BorderSizePixel = 0
    sideIdentity.ZIndex = 30

    local sideAvatar = Instance.new("ImageLabel", sideIdentity)
    sideAvatar.AnchorPoint = Vector2.new(0.5, 0)
    sideAvatar.Position = UDim2.new(0.5, 0, 0, 0)
    sideAvatar.Size = UDim2.new(0, 60, 0, 60)
    sideAvatar.BackgroundColor3 = Color3.fromRGB(8, 9, 11)
    sideAvatar.BorderSizePixel = 0
    sideAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150"
    sideAvatar.ScaleType = Enum.ScaleType.Crop
    sideAvatar.ZIndex = 31
    sideAvatar.Parent = sideIdentity
    Instance.new("UICorner", sideAvatar).CornerRadius = UDim.new(0, 33)
    local avatarStroke = Instance.new("UIStroke", sideAvatar)
    avatarStroke.Color = Color3.fromRGB(255, 255, 255)
    avatarStroke.Thickness = 2

    local sideOnline = Instance.new("TextLabel", sideIdentity)
    sideOnline.Name = "OnlineStatus"
    sideOnline.Position = UDim2.new(0, 0, 0, 67)
    sideOnline.Size = UDim2.new(1, 0, 0, 18)
    sideOnline.BackgroundTransparency = 1
    sideOnline.Text = "Online"
    sideOnline.TextColor3 = Color3.fromRGB(255, 255, 255)
    sideOnline.TextSize = 12
    sideOnline.Font = Enum.Font.GothamBold
    sideOnline.TextXAlignment = Enum.TextXAlignment.Center
    sideOnline.ZIndex = 31


    contentArea.Size = UDim2.new(1, -100, 1, -72)
    contentArea.Position = UDim2.new(0, 98, 0, 58)
    contentArea.BackgroundColor3 = Color3.fromRGB(14, 14, 15)
    contentArea.BackgroundTransparency = 0.68
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 16)

    local pageHolder = Instance.new("Frame", contentArea)
    pageHolder.Size = UDim2.new(1, -6, 1, -6)
    pageHolder.Position = UDim2.new(0, 3, 0, 3)
    pageHolder.BackgroundTransparency = 1
    pageHolder.BorderSizePixel = 0

    -- Cada pestaña usa su propio ScrollingFrame, igual que la pestaña Combat.
    -- Esto evita compartir el estado de desplazamiento entre páginas.
    local function buildPage()
        local p = Instance.new("ScrollingFrame")
        p.Name = "ScrollableTabPage"
        p.Parent = pageHolder
        p.Size = UDim2.new(1, -2, 1, 0)
        p.Position = UDim2.new(0, 0, 0, 0)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ClipsDescendants = true
        p.Active = true
        p.Selectable = false
        p.ScrollingEnabled = true
        p.ScrollingDirection = Enum.ScrollingDirection.Y
        p.ElasticBehavior = Enum.ElasticBehavior.Always
        p.ScrollBarThickness = 5
        p.ScrollBarImageColor3 = ACCENT
        p.ScrollingEnabled = true
        p.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
        p.ScrollBarImageTransparency = 0.3
        p.CanvasPosition = Vector2.new(0, 0)
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ll = Instance.new("UIListLayout", p)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 5)
        local pd = Instance.new("UIPadding", p)
        pd.PaddingLeft = UDim.new(0, 4)
        pd.PaddingRight = UDim.new(0, 4)
        pd.PaddingTop = UDim.new(0, 4)
        pd.PaddingBottom = UDim.new(0, 4)

        -- Fuerza el tamaño desplazable para que todas las pestañas,
        -- incluidas Main y Keybinds, funcionen igual que Combat.
        -- AutomaticCanvasSize se encarga del alto real.
        -- Padding inferior grande para poder llegar siempre al último ajuste.
        pd.PaddingBottom = UDim.new(0, 140)

        local function updateCanvasSize()
            p.CanvasSize = UDim2.new(0, 0, 0, ll.AbsoluteContentSize.Y + 160)
        end
        ll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        task.defer(updateCanvasSize)
        return p
    end

    local tabNames = {
        "Moment", "Combat", "Main", "Keybinds"
    }
    local pages = {}
    local tabButtons = {}
    local activeTab = 1
    local scrollPage = nil

        local function setActiveTab(index)
        activeTab = index
        for i, page in ipairs(pages) do
            page.Visible = (i == index)
        end
        for i, button in ipairs(tabButtons) do
            local selected = (i == index)
            button.BackgroundColor3 = selected and Color3.fromRGB(48, 48, 50) or Color3.fromRGB(22, 22, 24)
            button.BackgroundTransparency = 0.78
            button.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 155)
            local stroke = button:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = selected and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(70, 70, 74)
                stroke.Transparency = 1
            end
        end
    end

    for i, name in ipairs(tabNames) do
        local button = Instance.new("TextButton", tabBar)
        button.Name = "Tab_" .. name:gsub("[^%w]", "")
        button.Size = UDim2.new(1, 0, 0, 30)
        -- Orden vertical: Moment, Combat, Main y Keybinds.
        local tabY = (i - 1) * 40
        button.Position = UDim2.new(0, 0, 0, tabY)
        button.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
        button.BackgroundTransparency = 0.78
        button.BorderSizePixel = 0
        button.Text = name
        button.TextColor3 = Color3.fromRGB(150, 150, 155)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 10
        button.AutoButtonColor = false
        button.ZIndex = 21
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)
        local stroke = Instance.new("UIStroke", button)
        stroke.Thickness = 1
        stroke.Color = Color3.fromRGB(70, 70, 74)
        stroke.Transparency = 1
        button.Activated:Connect(function() setActiveTab(i) end)
        table.insert(tabButtons, button)

        local page = buildPage()
        page.Name = "Page_" .. name:gsub("[^%w]", "")
        page.Visible = false
        table.insert(pages, page)
    end
    setActiveTab(1)

    -- El diseño KuRu utiliza bordes sutiles; se conservan los UIStroke.

    -- Funciones auxiliares
    local function mkSect(txt)
        local pageIndex = ({
            Moment = 1, Speed = 1,
            Combat = 2, Mechanics = 2, Visual = 3, Sky = 2, ["Auto Left / Right"] = 2, Steal = 2,
            Animations = 3,
            Main = 3,
            Interface = 3, Config = 3, Teleport = 3,
            Keybinds = 4
        })[txt]
        if pageIndex and pages[pageIndex] then
            scrollPage = pages[pageIndex]
        end
        -- Main funciona como contenedor de página, pero su título no se muestra;
        -- Auto Steal será la primera sección visible dentro de Main.
        if txt == "Main" then return end
        local f = Instance.new("Frame", scrollPage)
        f.Size = UDim2.new(1, 0, 0, 24)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -10, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(200, 205, 215)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        f.LayoutOrder = #scrollPage:GetChildren() + 1
        applyShimmerToText(l, 0.5)
        local accentBar = Instance.new("Frame", f)
        accentBar.Size = UDim2.new(0, 3, 0, 13)
        accentBar.Position = UDim2.new(0, 0, 0.5, -6)
        accentBar.BackgroundColor3 = ACCENT
        accentBar.BorderSizePixel = 0
        Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)
        return f
    end

    local function mkRow(h)
        local f = Instance.new("Frame", scrollPage)
        f.Size = UDim2.new(1, -2, 0, h or 38)
        f.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        f.BackgroundTransparency = 0.78
        f.BorderSizePixel = 0
        f.LayoutOrder = #scrollPage:GetChildren() + 1
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = Color3.fromRGB(0, 0, 0)
        rowStroke.Transparency = 0.78
        local rowGrad = Instance.new("UIGradient", f)
        rowGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35,35,37)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18,18,20)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28,28,30))
        })
        rowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.62),
            NumberSequenceKeypoint.new(0.5, 0.78),
            NumberSequenceKeypoint.new(1, 0.62)
        })
        rowGrad.Rotation = 90
        rowGrad.Offset = Vector2.new(0,0)
        task.spawn(function()
            local t=0
            while rowGrad and rowGrad.Parent do
                t = t + 0.02
                rowGrad.Offset = Vector2.new(math.sin(t * 0.2) * 0.1, 0)
                task.wait(0.04)
            end
        end)
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(15,15,15)}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = BLACK}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(238, 238, 238)
        l.Font = Enum.Font.GothamMedium
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        applyShimmerToText(l, 0.6)
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 42, 0, 22)
        pill.Position = UDim2.new(1, -(offset or 52), 0.5, -11)
        pill.BackgroundColor3 = Color3.fromRGB(50, 50, 54)
        pill.BackgroundTransparency = 0.55
        pill.BorderSizePixel = 0
                Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Thickness = 1
        pillStroke.Color = Color3.fromRGB(0, 0, 0)
        pillStroke.Transparency = 0.45
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 3, 0.5, -8)
        dot.BackgroundColor3 = Color3.fromRGB(130,130,130)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        pill:SetAttribute("CipherActive", on == true)
        local ps = pill:FindFirstChildOfClass("UIStroke")
        if ps then
            TS:Create(ps, TweenInfo.new(0.18), {Color = on and cipherThemeColor or Color3.fromRGB(0, 0, 0), Transparency = on and 0.15 or 0.45}):Play()
        end
        TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and cipherThemeColor or Color3.fromRGB(50, 50, 54)}):Play()
        TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
            Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),
            BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(130,130,130)
        }):Play()
    end

    local function mkToggle(txt, cb)
        local row = mkRow(38)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 52)
        pill:SetAttribute("CipherTogglePill", true)
        local on = false
        local function sv(s) on=s; animPill(pill,dot,s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
        end)
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 45
        local xo = math.max(xOff or 52, bw + 8)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        tb.BackgroundTransparency = 0.38
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = ACCENT
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 10
        tb.ClearTextOnFocus = false
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = Color3.fromRGB(0, 0, 0)
        bs.Thickness = 1
        bs.Transparency = 0.28
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=ACCENT,Transparency=0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(0, 0, 0),Transparency=0.28}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        applyShimmerToText(tb, 0.7)
        return tb
    end

    local function mkSelector(parent, default, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 48, 0, 24)
        btn.Position = UDim2.new(1, -52, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        btn.BackgroundTransparency = 0.38
        btn.BorderSizePixel = 0
        btn.Text = default
        btn.TextColor3 = Color3.fromRGB(238, 238, 238)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.TextScaled = false
        btn.ClipsDescendants = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1
        btn.MouseButton1Click:Connect(function()
            if _anyKeyListening then return end
            if cb then cb(btn) end
        end)
        applyShimmerToText(btn, 0.7)
        return btn
    end

    -- ====== PANEL DE SELECCIÓN ======
    local activeChoiceOverlay = nil
    local function openChoicePanel(titleText, items, selectedText, onChoose, themeColor)
        if activeChoiceOverlay then
            pcall(function() activeChoiceOverlay:Destroy() end)
            activeChoiceOverlay = nil
        end

        -- Panel de selección separado de la ventana principal.
        local overlay = Instance.new("Frame", gui)
        activeChoiceOverlay = overlay
        overlay.Name = "ChoiceOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.Position = UDim2.new(0, 0, 0, 0)
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 500

        local panel = Instance.new("Frame", overlay)
        panel.Size = UDim2.new(0, GUI_W - 34, 0, 360)
        panel.Position = UDim2.fromOffset(
            main.AbsolutePosition.X + 17,
            main.AbsolutePosition.Y + math.max(0, (main.AbsoluteSize.Y - 360) / 2)
        )
        panel.BackgroundColor3 = Color3.fromRGB(10, 10, 11)
        panel.BackgroundTransparency = themeColor and 0 or 0.03
        panel.BorderSizePixel = 0
        panel.ZIndex = 501
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
        local ps = Instance.new("UIStroke", panel)
        ps.Color = ACCENT
        ps.Thickness = 1.2
        ps.Transparency = 0.2

        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1, -54, 0, 38)
        title.Position = UDim2.new(0, 14, 0, 5)
        title.BackgroundTransparency = 1
        title.Active = true
        title.Text = titleText
        title.TextColor3 = themeColor or Color3.fromRGB(210, 210, 214)
        title.Font = Enum.Font.FredokaOne
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 502

        local close = Instance.new("TextButton", panel)
        close.Size = UDim2.new(0, 30, 0, 30)
        close.Position = UDim2.new(1, -36, 0, 8)
        close.BackgroundColor3 = Color3.fromRGB(0, 0, 24)
        close.BorderSizePixel = 0
        close.Text = "X"
        close.TextColor3 = ACCENT
        close.Font = Enum.Font.FredokaOne
        close.TextSize = 12
        close.ZIndex = 503
        Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

        -- Arrastre independiente usando la barra del título.
        local draggingChoice = false
        local dragStart = nil
        local startPos = nil

        title.InputBegan:Connect(function(input)
            if uiLocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingChoice = true
                dragStart = input.Position
                startPos = panel.Position
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if not draggingChoice or uiLocked or not dragStart or not startPos then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                panel.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)

        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                draggingChoice = false
                dragStart = nil
                startPos = nil
            end
        end)

        local scroll = Instance.new("ScrollingFrame", panel)
        scroll.Size = UDim2.new(1, -20, 1, -54)
        scroll.Position = UDim2.new(0, 10, 0, 46)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageColor3 = ACCENT
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.ZIndex = 502

        local listLayout = Instance.new("UIListLayout", scroll)
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 6)

        local padding = Instance.new("UIPadding", scroll)
        padding.PaddingLeft = UDim.new(0, 2)
        padding.PaddingRight = UDim.new(0, 6)
        padding.PaddingTop = UDim.new(0, 2)
        padding.PaddingBottom = UDim.new(0, 6)

        local function closePanel()
            if overlay and overlay.Parent then overlay:Destroy() end
            if activeChoiceOverlay == overlay then activeChoiceOverlay = nil end
        end
        close.Activated:Connect(closePanel)

        for index, text in ipairs(items) do
            local option = Instance.new("TextButton", scroll)
            option.Size = UDim2.new(1, -8, 0, 34)
            option.BackgroundColor3 = (text == selectedText) and (themeColor or Color3.fromRGB(210, 210, 214)) or (themeColor and Color3.fromRGB(10, 10, 11) or Color3.fromRGB(10, 10, 11))
            option.BackgroundTransparency = (text == selectedText) and 0.05 or 0.18
            option.BorderSizePixel = 0
            option.Text = text
            option.TextColor3 = (text == selectedText) and Color3.fromRGB(255, 255, 255) or (themeColor or Color3.fromRGB(210, 210, 214))
            option.Font = Enum.Font.FredokaOne
            option.TextSize = 11
            option.TextXAlignment = Enum.TextXAlignment.Left
            option.ZIndex = 503
            Instance.new("UICorner", option).CornerRadius = UDim.new(0, 9)
            local opad = Instance.new("UIPadding", option)
            opad.PaddingLeft = UDim.new(0, 12)
            local ost = Instance.new("UIStroke", option)
            ost.Color = (text == selectedText) and (themeColor or Color3.fromRGB(255, 255, 255)) or Color3.fromRGB(50, 50, 54)
            ost.Thickness = 1
            ost.Transparency = (text == selectedText) and 0.1 or 0.55
            option.Activated:Connect(function()
                if onChoose then onChoose(index, text) end
                closePanel()
            end)
        end
    end

    -- ====== CIPHER IMAGE PANEL ======
    local cipherImageOverlay
    local function openCipherImagePanel()
        if cipherImageOverlay and cipherImageOverlay.Parent then
            cipherImageOverlay:Destroy()
            cipherImageOverlay = nil
            return
        end
        cipherImageOverlay = Instance.new("Frame", gui)
        cipherImageOverlay.Name = "CipherImagePicker"
        cipherImageOverlay.Size = UDim2.fromScale(1, 1)
        cipherImageOverlay.BackgroundTransparency = 1
        cipherImageOverlay.ZIndex = 900

        local panel = Instance.new("Frame", cipherImageOverlay)
        panel.Size = UDim2.new(0, GUI_W - 24, 0, 330)
        panel.Position = UDim2.new(0.5, -(GUI_W - 24) / 2, 0.5, -165)
        panel.BackgroundColor3 = Color3.fromRGB(8, 18, 34)
        panel.BackgroundTransparency = 0.02
        panel.BorderSizePixel = 0
        panel.ZIndex = 901
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
        local panelStroke = Instance.new("UIStroke", panel)
        panelStroke.Color = ACCENT
        panelStroke.Thickness = 1.4
        panelStroke.Transparency = 0.12

        local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1, -54, 0, 34)
        title.Position = UDim2.new(0, 14, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = "CIPHER IMAGES"
        title.TextColor3 = ACCENT
        title.Font = Enum.Font.FredokaOne
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.ZIndex = 902

        local close = Instance.new("TextButton", panel)
        close.Size = UDim2.fromOffset(28, 28)
        close.Position = UDim2.new(1, -36, 0, 8)
        close.BackgroundColor3 = Color3.fromRGB(0, 0, 24)
        close.BorderSizePixel = 0
        close.Text = "X"
        close.TextColor3 = ACCENT
        close.Font = Enum.Font.FredokaOne
        close.TextSize = 12
        close.ZIndex = 902
        Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
        close.Activated:Connect(function()
            if cipherImageOverlay then cipherImageOverlay:Destroy(); cipherImageOverlay = nil end
        end)

        local scroll = Instance.new("ScrollingFrame", panel)
        scroll.Size = UDim2.new(1, -20, 1, -50)
        scroll.Position = UDim2.new(0, 10, 0, 44)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 4
        scroll.ScrollBarImageColor3 = ACCENT
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.ZIndex = 902
        local grid = Instance.new("UIGridLayout", scroll)
        grid.CellSize = UDim2.new(0.5, -8, 0, 112)
        grid.CellPadding = UDim2.new(0, 8, 0, 8)
        grid.SortOrder = Enum.SortOrder.LayoutOrder

        for index, option in ipairs(CIPHER_IMAGE_OPTIONS) do
            local card = Instance.new("ImageButton", scroll)
            card.Name = "CipherImage_" .. index
            card.Image = option.id
            card.ImageTransparency = 0
            card.ScaleType = Enum.ScaleType.Crop
            card.BackgroundColor3 = Color3.fromRGB(0, 0, 24)
            card.BackgroundTransparency = 0.08
            card.BorderSizePixel = 0
            card.AutoButtonColor = false
            card.ZIndex = 903
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 9)
            local stroke = Instance.new("UIStroke", card)
            stroke.Color = option.id == selectedCipherImage and cipherThemeColor or Color3.fromRGB(90, 90, 94)
            stroke.Thickness = option.id == selectedCipherImage and 2 or 1
            stroke.Transparency = 0.12
            local caption = Instance.new("TextLabel", card)
            caption.Size = UDim2.new(1, -8, 0, 22)
            caption.Position = UDim2.new(0, 4, 1, -26)
            caption.BackgroundColor3 = Color3.fromRGB(10, 10, 11)
            caption.BackgroundTransparency = 0.18
            caption.BorderSizePixel = 0
            caption.Text = option.name
            caption.TextColor3 = Color3.fromRGB(255, 255, 255)
            caption.Font = Enum.Font.FredokaOne
            caption.TextSize = 10
            caption.ZIndex = 904
            Instance.new("UICorner", caption).CornerRadius = UDim.new(0, 5)
            card.MouseEnter:Connect(function()
                TS:Create(stroke, TweenInfo.new(0.12), {Color = cipherThemeColor, Thickness = 2}):Play()
            end)
            card.MouseLeave:Connect(function()
                TS:Create(stroke, TweenInfo.new(0.12), {Color = option.id == selectedCipherImage and cipherThemeColor or Color3.fromRGB(90, 90, 94), Thickness = option.id == selectedCipherImage and 2 or 1}):Play()
            end)
            card.Activated:Connect(function()
                applyCipherImage(option.id)
                -- Guardar la imagen elegida para conservarla al volver a abrir el script.
                pcall(function() saveAllSettings() end)
                if cipherImageOverlay then cipherImageOverlay:Destroy(); cipherImageOverlay = nil end
            end)
        end

        -- Recolorea también el selector recién creado con el tema activo.
        applyCipherV28Theme(cipherThemeColor)
    end

    -- ====== SPEED SECTION ======
    mkSect("Speed")
    do local row=mkRow(38); mkLabel(row,"Normal Speed"); normalBox=mkBox(row,NS,45,52,function(v) if v>0 and v<=500 then NS=v end end) end
    do local row=mkRow(38); mkLabel(row,"Carry Speed"); carryBox=mkBox(row,CS,45,52,function(v) if v>0 and v<=500 then CS=v end end) end
    do local row=mkRow(38); mkLabel(row,"Lagger 1 Speed"); laggerBox=mkBox(row,LAGGER_SPEED_1,45,52,function(v) if v>0 and v<=500 then LAGGER_SPEED_1=v end end) end
    do local row=mkRow(38); mkLabel(row,"Lagger 2 Speed"); lagger2Box=mkBox(row,LAGGER_SPEED_2,45,52,function(v) if v>0 and v<=500 then LAGGER_SPEED_2=v end end) end
    do local row=mkRow(38); mkLabel(row,"Current Mode"); modeValLbl=Instance.new("TextLabel",row); modeValLbl.Size=UDim2.new(0,90,1,0); modeValLbl.Position=UDim2.new(1,-94,0,0); modeValLbl.BackgroundTransparency=1; modeValLbl.Text="Normal"; modeValLbl.TextColor3=ACCENT; modeValLbl.Font=Enum.Font.FredokaOne; modeValLbl.TextSize=11; modeValLbl.TextXAlignment=Enum.TextXAlignment.Right; applyShimmerToText(modeValLbl, 0.8); local clk=Instance.new("TextButton",row); clk.Size=UDim2.new(1,0,1,0); clk.BackgroundTransparency=1; clk.Text=""; clk.Activated:Connect(function() if _anyKeyListening then return end; toggleCarryMode() end) end
    do local row=mkRow(38); mkLabel(row,"Bat Speed"); batSpeedBox=mkBox(row,BAT_AIMBOT_SPEED,45,52,function(v) if v>0 and v<=200 then BAT_AIMBOT_SPEED=v end end) end
    do local row=mkRow(38); mkLabel(row,"Bypass Speed"); bypassSpeedBox=mkBox(row,BYPASS_AIMBOT_SPEED,45,52,function(v) if v>0 and v<=200 then BYPASS_AIMBOT_SPEED=v end end) end

    -- ====== COMBAT SECTION ======
    mkSect("Combat")

    autoBatSetVisual = mkToggle("Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
    end)

    setBatCounterVisual = mkToggle("Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)

    setMedusaVisual = mkToggle("Medusa Counter", function(on)
        setMedusaCounterState(on)
    end)

    setMedusaAutoResetVisual = mkToggle("Medusa Auto Reset", function(on)
        setMedusaAutoResetState(on)
    end)

    setAntiRagVisual = mkToggle("Anti Ragdoll", function(on)
        antiRagdollEnabled = on
        if on then startAntiRagdoll() else stopAntiRagdoll() end
    end)

-- ====== PLAYER ESP ======
local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espConn = nil
local _espLastRun = 0
local profileImageCache = {}
local function clearESP() for plr in pairs(espHighlightCache) do pcall(function() espHighlightCache[plr]:Destroy() end) end for plr in pairs(espBillboardCache) do pcall(function() espBillboardCache[plr]:Destroy() end) end for plr in pairs(espTracerCache) do for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false; ln:Remove() end) end end espHighlightCache = {} espBillboardCache = {} espTracerCache = {} end local function makeESPTracers() if not (Drawing and type(Drawing.new) == "function") then return nil end local SILVER = Color3.fromRGB(180, 180, 190) local outer = Drawing.new("Line") outer.Color = SILVER outer.Thickness = 2.2 outer.Transparency = 0.90 outer.Visible = false local mid = Drawing.new("Line") mid.Color = SILVER mid.Thickness = 1.2 mid.Transparency = 0.74 mid.Visible = false local core = Drawing.new("Line") core.Color = SILVER core.Thickness = 0.6 core.Transparency = 0.10 core.Visible = false return {outer, mid, core} end local function updateESP() local now = tick() if now - _espLastRun < 0.03 then return end _espLastRun = now if not espEnabled then clearESP(); return end local myChar = LP.Character local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart") if not myRoot then return end local myPos = myRoot.Position local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos) local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y) local currentPlayers = Players:GetPlayers() local plrSet = {} for _, p in ipairs(currentPlayers) do plrSet[p] = true end for plr in pairs(espHighlightCache) do if not plrSet[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) espHighlightCache[plr] = nil end end for plr in pairs(espBillboardCache) do if not plrSet[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) espBillboardCache[plr] = nil end end for plr in pairs(espTracerCache) do if not plrSet[plr] then for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false; ln:Remove() end) end espTracerCache[plr] = nil end end for _, plr in ipairs(currentPlayers) do if plr == LP then continue end local char = plr.Character if not char then if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) espHighlightCache[plr] = nil end if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) espBillboardCache[plr] = nil end if espTracerCache[plr] then for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false end) end end continue end local tRoot = char:FindFirstChild("HumanoidRootPart") local tHead = char:FindFirstChild("Head") local tHum = char:FindFirstChildOfClass("Humanoid") local alive = tRoot and tHead and tHum and tHum.Health > 0 if alive then local hl = espHighlightCache[plr] if not hl or not hl.Parent or hl.Parent ~= char then if hl then pcall(function() hl:Destroy() end) end hl = Instance.new("Highlight") hl.Name = "BloodHoundsESP" hl.FillColor = Color3.fromRGB(180, 180, 190) hl.FillTransparency = 0.72 hl.OutlineColor = Color3.fromRGB(180, 180, 190) hl.OutlineTransparency = 0.05 hl.Adornee = char hl.Parent = char espHighlightCache[plr] = hl end local bb = espBillboardCache[plr] if not bb or not bb.Parent then if bb then pcall(function() bb:Destroy() end) end bb = Instance.new("BillboardGui") bb.Name = "ProfilePic" bb.Size = UDim2.new(0, 56, 0, 56) bb.StudsOffset = Vector3.new(0, 3.8, 0) bb.Adornee = tHead bb.AlwaysOnTop = true bb.Parent = tHead local img = Instance.new("ImageLabel", bb) img.Size = UDim2.new(1, -6, 1, -6) img.Position = UDim2.new(0, 3, 0, 3) img.BackgroundTransparency = 1 img.Image = "rbxassetid://0" img.ScaleType = Enum.ScaleType.Fit local circle = Instance.new("UICorner", img) circle.CornerRadius = UDim.new(1, 0) local stroke = Instance.new("UIStroke", img) stroke.Color = Color3.fromRGB(180, 180, 190) stroke.Thickness = 1.5 espBillboardCache[plr] = bb task.spawn(function() local userId = plr.UserId local url = profileImageCache[userId] if not url then local success, u = pcall(function() return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) if success and u and u ~= "" then url = u profileImageCache[userId] = url else url = "rbxassetid://0" end end if img then img.Image = url end end) else if bb.Adornee ~= tHead then bb.Adornee = tHead end bb.Enabled = true end local lines = espTracerCache[plr] if not lines then lines = makeESPTracers() espTracerCache[plr] = lines or {} end if lines and #lines > 0 then local destPos = tRoot.Position local pos, onScreen = camera:WorldToViewportPoint(destPos) if onScreen and pos.Z > 0 and myOnScreen then local tVec = Vector2.new(pos.X, pos.Y) for _, ln in ipairs(lines) do ln.From = myVec ln.To = tVec ln.Visible = true end else for _, ln in ipairs(lines) do ln.Visible = false end end end else if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) espHighlightCache[plr] = nil end if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) espBillboardCache[plr] = nil end if espTracerCache[plr] then for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false end) end end end end end local function startESPLoop() if espConn then espConn:Disconnect() end espConn = RunService.RenderStepped:Connect(updateESP) end local function stopESPLoop() if espConn then espConn:Disconnect(); espConn = nil end clearESP() end function toggleESP(on) espEnabled = on if on then startESPLoop() else stopESPLoop() end if setESPVIsual then setESPVIsual(on) end end 
local function mkCombatAction(txt, callback)
    local row = mkRow(38)
    mkLabel(row, txt)
    local button = Instance.new("TextButton", row)
    button.Size = UDim2.new(0, 86, 0, 24)
    button.Position = UDim2.new(1, -94, 0.5, -12)
    button.BackgroundColor3 = INP
    button.BackgroundTransparency = 0.78
    button.BorderSizePixel = 0
    button.Text = "USE"
    button.TextColor3 = ACCENT
    button.Font = Enum.Font.FredokaOne
    button.TextSize = 10
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", button)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Transparency = 0.28
    button.Activated:Connect(function()
        local ok, err = pcall(callback)
        if not ok then
            warn("Combat action failed (" .. txt .. "): " .. tostring(err))
        end
    end)
    return button
end

    -- ====== WEEKLY KORBLOX (CON PERSISTENCIA Y SINCRONIZACIÓN) ======

local KORBLOX_CONFIGS = {
    ["Right Leg"] = {
        id = "rbxassetid://139607718",
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = Vector3.new(1, 1, 1),
        audio = "rbxassetid://135315310485417",
        offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 0, 0)
    }
}

local korbloxAssetModels = {}
local korbloxOriginalTransparency = {}

local function removeKorblox(itemName)
    if itemName then
        local assetModel = korbloxAssetModels[itemName]
        if assetModel and assetModel.Parent then
            assetModel:Destroy()
        end
        korbloxAssetModels[itemName] = nil

        local config = KORBLOX_CONFIGS[itemName]
        if config then
            for _, partName in ipairs(config.partsToHide) do
                local part = LP.Character and LP.Character:FindFirstChild(partName)
                if part and korbloxOriginalTransparency[part] ~= nil then
                    part.Transparency = korbloxOriginalTransparency[part]
                    korbloxOriginalTransparency[part] = nil
                end
            end
        end
        return
    end

    for name, assetModel in pairs(korbloxAssetModels) do
        if assetModel and assetModel.Parent then
            assetModel:Destroy()
        end
        korbloxAssetModels[name] = nil
    end

    for part, transparency in pairs(korbloxOriginalTransparency) do
        if part and part.Parent then
            part.Transparency = transparency
        end
    end
    table.clear(korbloxOriginalTransparency)
end

local function equipKorblox(itemName, config)
    local character = LP.Character
    if not character then return false, "No character" end

    local targetPart = character:FindFirstChild(config.targetBodyPart)
    if not targetPart or not targetPart:IsA("BasePart") then
        return false, "Target part missing"
    end

    local oldAsset = korbloxAssetModels[itemName]
    if oldAsset and oldAsset.Parent then oldAsset:Destroy() end
    korbloxAssetModels[itemName] = nil

    local success, objects = pcall(function()
        return game:GetObjects(config.id)
    end)
    
    if not success or not objects or #objects == 0 then
        -- Fallback: crear un bloque simple
        local fallback = Instance.new("Part")
        fallback.Name = "Korblox_Fallback_" .. itemName:gsub("%s+", "")
        fallback.Size = Vector3.new(0.5, 1.5, 0.5)
        fallback.Shape = Enum.PartType.Cylinder
        fallback.Material = Enum.Material.SmoothPlastic
        fallback.Color = Color3.fromRGB(255, 255, 255)
        fallback.Anchored = false
        fallback.CanCollide = false
        fallback.CanTouch = false
        fallback.CanQuery = false
        objects = {fallback}
    end

    local assetModel = objects[1]
    assetModel.Name = "Korblox_" .. itemName:gsub("%s+", "")
    
    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        local anchor = Instance.new("Part")
        anchor.Name = "Korblox_Anchor"
        anchor.Size = Vector3.new(0.3, 0.3, 0.3)
        anchor.Transparency = 1
        anchor.Anchored = false
        anchor.CanCollide = false
        anchor.CanTouch = false
        anchor.CanQuery = false
        anchor.Parent = assetModel
        mainMesh = anchor
    end

    mainMesh.Size = mainMesh.Size * config.scale
    mainMesh.CanCollide = false
    mainMesh.CanTouch = false
    mainMesh.CanQuery = false
    mainMesh.CFrame = targetPart.CFrame * config.offset

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    for _, partName in ipairs(config.partsToHide) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            if korbloxOriginalTransparency[part] == nil then
                korbloxOriginalTransparency[part] = part.Transparency
            end
            part.Transparency = 1
        end
    end

    assetModel.Parent = character
    korbloxAssetModels[itemName] = assetModel

    if config.audio ~= "" then
        local sound = Instance.new("Sound")
        sound.SoundId = config.audio
        sound.Volume = 0.5
        sound.Parent = mainMesh
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 3)
    end

    return true
end

-- ====== ACCESSORY PACK ======
local ACCESSORY_PACK_ORDER = {"Off", "Korblox", "Headless", "Both"}
currentAccessoryPack = currentAccessoryPack or "Off"
local accSelectorLabel = nil
local accessoryPackHead = nil
local accessoryPackHeadTransparency = nil

local function clearAccessoryPack()
    if accessoryPackHead and accessoryPackHead.Parent then accessoryPackHead:Destroy() end
    accessoryPackHead = nil
    local char = LP.Character
    if char and accessoryPackHeadTransparency ~= nil then
        local head = char:FindFirstChild("Head")
        if head and head:IsA("BasePart") then head.Transparency = accessoryPackHeadTransparency end
    end
    accessoryPackHeadTransparency = nil
    if type(removeKorblox) == "function" then
        pcall(removeKorblox, "Right Leg")
    end
end

-- Misma responsabilidad que attachKorbloxLeg en Lust Hub: carga el asset,
-- oculta la pierna original, lo suelda y registra su estado.
local function attachKorbloxLeg(legName, config)
    if type(equipKorblox) ~= "function" or not config then return false, "Korblox function/config missing" end
    local ok, err = equipKorblox(legName, config)
    -- El pack comparte el cargador de Korblox, pero no activa el toggle independiente.
    return ok, err
end

-- Misma responsabilidad que attachHeadless en Lust Hub.
local function attachHeadless()
    local char = LP.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return false, "Head missing" end
    if accessoryPackHead and accessoryPackHead.Parent then accessoryPackHead:Destroy() end
    accessoryPackHeadTransparency = head.Transparency
    head.Transparency = 1
    local ok, objects = pcall(function() return game:GetObjects("rbxassetid://134082579") end)
    if not ok or not objects or #objects == 0 then
        -- El efecto Headless sigue siendo válido sin el mesh opcional: la cabeza ya está oculta.
        warn("Headless asset unavailable; using transparent-head fallback")
        return true
    end
    local model = objects[1]
    model.Name = "Headless_Headless"
    local mesh = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    if not mesh then
        model:Destroy()
        -- Fallback compatible con Lust Hub: mantener la cabeza oculta aunque el asset no tenga MeshPart.
        warn("Headless asset has no BasePart; using transparent-head fallback")
        return true
    end
    mesh.CanCollide = false
    mesh.CanTouch = false
    mesh.CanQuery = false
    mesh.CFrame = head.CFrame
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = mesh
    weld.Parent = mesh
    model.Parent = char
    accessoryPackHead = model
    return true
end

local function applyAccessoryPack(packName)
    if not table.find(ACCESSORY_PACK_ORDER, packName) then packName = "Off" end
    clearAccessoryPack()
    currentAccessoryPack = packName
    if packName == "Off" then return true end

    if packName == "Korblox" or packName == "Both" then
        local ok = attachKorbloxLeg("Right Leg", KORBLOX_CONFIGS["Right Leg"])
        if not ok then
            clearAccessoryPack()
            currentAccessoryPack = "Off"
            return false
        end
    end

    if packName == "Headless" or packName == "Both" then
        local ok = attachHeadless()
        if not ok then
            clearAccessoryPack()
            currentAccessoryPack = "Off"
            return false
        end
    end
    return true
end

-- La reaplicación del pack se centraliza en el handler principal de respawn.

    -- ====== MECHANICS SECTION ======
    mkSect("Mechanics")

    -- ============================================================
    --  AUTO STEAL — módulo de reemplazo proporcionado por el usuario
    -- ============================================================
    -- Usar la misma tabla compartida que emplean buildConfigTable/loadAllSettings.
    -- Esto permite que Auto Steal se guarde y se restaure entre sesiones.
    Steal = {
        AutoStealEnabled = Steal.AutoStealEnabled == true,
        StealRadius = Steal.StealRadius or 9,
        StealDuration = Steal.StealDuration or 1.37,
        Data = {},
        cachedPrompts = {},
        promptCacheTime = 0,
    }

    local Semi = {
        enabled = false,
        holdMin = 1.3,
        holdMax = 2.6,
        entryDelay = 0.3,
        cooldown = 0.05,
        primeRange = 80,
        radius = 9,
        animals = {},
        promptCache = {},
        internalCache = {},
        state = {active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0},
        syncReady = false,
        plotSync = {caches = {}, connections = {}},
    }

    local isStealing = false
    local stealStartTime = nil
    local lastStealTick = 0
    local STEAL_COOLDOWN = 0.1
    local PROMPT_CACHE_REFRESH = 0.15
    local stealHeartbeatConn = nil
    local stealScanThread = nil

    -- ============================================================
    --  FUNCIONES AUXILIARES
    -- ============================================================
    local function rootPart()
        local char = LP.Character
        return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")) or nil
    end

    local function isMyPlotByName(plotName)
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return false end
        local plot = plots:FindFirstChild(plotName)
        if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local yb = sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") then
                return yb.Enabled == true
            end
        end
        return false
    end

    local function splitPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end

    local function resolvePath(path, root)
        local current, parent, key = root, nil, nil
        for _, part in ipairs(splitPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end

    local function applySyncDiff(channelName, packet)
        local cache = Semi.plotSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolvePath(path, cache)
        if action == "Changed" then
            if parent ~= nil then parent[key] = a end
        elseif action == "ArrayInsert" then
            if current ~= nil then table.insert(current, b, a) end
        elseif action == "ArrayRemoved" then
            if current ~= nil then table.remove(current, b) end
        elseif action == "DictionaryInsert" then
            if current ~= nil then current[b] = a end
        elseif action == "DictionaryRemoved" then
            if current ~= nil then current[b] = nil end
        end
    end

    local function attachPlotChannel(remote)
        if Semi.plotSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not Semi.plots:FindFirstChild(channelName) then return end
        if Semi.requestData and Semi.plotSync.caches[channelName] == nil then
            local ok, data = pcall(function() return Semi.requestData:InvokeServer(channelName) end)
            Semi.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif Semi.plotSync.caches[channelName] == nil then
            Semi.plotSync.caches[channelName] = {}
        end
        Semi.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do applySyncDiff(channelName, packet) end
        end)
    end

    -- ============================================================
    --  SISTEMA DE SYNC (para obtener animales)
    -- ============================================================
    function initSemiSync()
        if Semi.syncReady then return true end
        local ok = pcall(function()
            local rs = game:GetService("ReplicatedStorage")
            Semi.packages = rs:FindFirstChild("Packages") or rs:WaitForChild("Packages", 10)
            Semi.datas = rs:FindFirstChild("Datas") or rs:WaitForChild("Datas", 10)
            Semi.plots = workspace:FindFirstChild("Plots") or workspace:WaitForChild("Plots", 10)
            if not (Semi.packages and Semi.datas and Semi.plots) then return end
            Semi.animalsData = require(Semi.datas:WaitForChild("Animals", 10))
            local sync = Semi.packages:FindFirstChild("Synchronizer") or Semi.packages:WaitForChild("Synchronizer", 10)
            Semi.channelFolder = sync:FindFirstChild("Channel") or sync:WaitForChild("Channel", 10)
            Semi.routeRemote = sync:FindFirstChild("CommunicationRoute") or sync:WaitForChild("CommunicationRoute", 10)
            Semi.requestData = sync:FindFirstChild("RequestData")
            for _, child in ipairs(Semi.channelFolder:GetChildren()) do
                if child:IsA("RemoteEvent") then attachPlotChannel(child) end
            end
            Semi.channelFolder.ChildAdded:Connect(function(child)
                if child:IsA("RemoteEvent") then attachPlotChannel(child) end
            end)
            Semi.routeRemote.OnClientEvent:Connect(function(actions)
                for _, action in ipairs(actions) do
                    local kind, channelName = action[1], tostring(action[2])
                    if Semi.plots and Semi.plots:FindFirstChild(channelName) then
                        if kind == "ListenerAdded" then
                            local remote = Semi.channelFolder and Semi.channelFolder:FindFirstChild(channelName)
                            if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
                        elseif kind == "ListenerRemoved" then
                            for remote, conn in pairs(Semi.plotSync.connections) do
                                if tostring(remote.Name) == channelName then
                                    pcall(function() conn:Disconnect() end)
                                    Semi.plotSync.connections[remote] = nil
                                    Semi.plotSync.caches[channelName] = nil
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            Semi.syncReady = true
        end)
        return ok and Semi.syncReady == true
    end

    -- ============================================================
    --  OBTENER ANIMALES
    -- ============================================================
    function scanAllPlotsSemi()
        if not initSemiSync() then return 0 end
        local newCache = {}
        for _, plot in ipairs(Semi.plots:GetChildren()) do
            local cache = Semi.plotSync.caches[plot.Name]
            local animalList = cache and cache.AnimalList
            if typeof(animalList) == "table" then
                for slot, animalData in pairs(animalList) do
                    if type(animalData) == "table" then
                        local animalName = animalData.Index
                        local info = Semi.animalsData and Semi.animalsData[animalName]
                        if info then
                            table.insert(newCache, {
                                name = info.DisplayName or animalName,
                                plot = plot.Name,
                                slot = tostring(slot),
                                uid = plot.Name .. "_" .. tostring(slot),
                            })
                        end
                    end
                end
            end
        end
        Semi.animals = newCache
        return #newCache
    end

    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot or not Semi.plots then return false end
        local plot = Semi.plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if not sign then return false end
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
        return false
    end

    local function podiumFor(animalData)
        local plot = Semi.plots and Semi.plots:FindFirstChild(animalData.plot)
        local podiums = plot and plot:FindFirstChild("AnimalPodiums")
        return podiums and podiums:FindFirstChild(animalData.slot) or nil
    end

    local function animalPos(animalData)
        local podium = podiumFor(animalData)
        return podium and podium:GetPivot().Position or nil
    end

    local function distToAnimal(animalData)
        local root = rootPart()
        local pos = animalPos(animalData)
        return root and pos and (root.Position - pos).Magnitude or math.huge
    end

    local function findPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = Semi.promptCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local podium = podiumFor(animalData)
        local base = podium and podium:FindFirstChild("Base")
        local spawn = base and base:FindFirstChild("Spawn")
        local attach = spawn and spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, prompt in ipairs(attach:GetChildren()) do
            if prompt:IsA("ProximityPrompt") then
                Semi.promptCache[animalData.uid] = prompt
                return prompt
            end
        end
        return nil
    end

    local function pickClosest()
        local root = rootPart()
        if not root then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(Semi.animals) do
            if not isMyBaseAnimal(animalData) then
                local pos = animalPos(animalData)
                local dist = pos and (root.Position - pos).Magnitude or math.huge
                if dist <= (Semi.primeRange or 80) and dist < bestDist then
                    best, bestDist = animalData, dist
                end
            end
        end
        return best
    end

    -- ============================================================
    --  BARRA DE PROGRESO
    -- ============================================================
    local function resetProgressBar()
        if progressPct then progressPct.Text = "—" end
        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.TextColor3 = Color3.fromRGB(210, 210, 214) end
    end

    local function updateStealBar(progress, label)
        progress = math.clamp(progress or 0, 0, 1)
        local pct = math.floor(progress * 100 + 0.5)

        if progressFill then
            progressFill.Size = UDim2.fromScale(progress, 1)
            if label and string.find(label, "HOLDING") then
                progressFill.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
            elseif label and string.find(label, "MOVE CLOSER") then
                progressFill.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
            elseif label and string.find(label, "STOLE") then
                progressFill.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
            elseif label and string.find(label, "MISSED") then
                progressFill.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
            else
                progressFill.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
            end
        end

        if progressPct then
            if type(label) == "string" and label ~= "" and label ~= "READY" then
                progressPct.Text = label
            elseif progress > 0 then
                progressPct.Text = pct .. "%"
            else
                progressPct.Text = Steal.AutoStealEnabled and "—" or "IDLE"
            end
        end
    end

    -- La barra es un indicador persistente: no debe desaparecer al apagar Auto Steal.
    -- El estado desactivado se comunica mediante el texto "IDLE".
    function updateProgressBarVisibility()
        if pbFrame and pbFrame.Parent then
            pbFrame.Visible = true
            if not Steal.AutoStealEnabled then
                resetProgressBar()
                if progressPct then progressPct.Text = "IDLE" end
            end
        end
    end

    -- ============================================================
    --  EJECUTAR ROBO
    -- ============================================================
    local function buildCallbacks(prompt)
        if Semi.internalCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
        if okHold and type(holds) == "table" then
            for _, conn in ipairs(holds) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
        if okTrigger and type(triggers) == "table" then
            for _, conn in ipairs(triggers) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then Semi.internalCache[prompt] = data end
    end

    local function executeSemi(prompt, animalData)
        if not prompt or not prompt.Parent or not animalData then return false end
        buildCallbacks(prompt)
        local data = Semi.internalCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        Semi.state.active = true
        Semi.state.startTime = tick()
        Semi.state.phase = "holding"
        Semi.state.label = animalData.name or "Animal"
        isStealing = true
        stealStartTime = Semi.state.startTime

        task.spawn(function()
            local startTime = Semi.state.startTime

            for _, fn in ipairs(data.holdCallbacks) do
                task.spawn(function() pcall(fn) end)
            end

            while Semi.enabled and tick() - startTime < (Semi.holdMin or 1.3) do
                local elapsed = tick() - startTime
                Semi.state.phase = "holding"
                updateStealBar(elapsed / (Semi.holdMax or 2.6), "READY")
                task.wait()
            end

            Semi.state.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= (tonumber(Semi.radius) or 10)
            local fired = false

            while Semi.enabled and prompt.Parent do
                local elapsed = tick() - startTime
                if elapsed > (Semi.holdMax or 2.6) then break end

                local dist = distToAnimal(animalData)
                updateStealBar(elapsed / (Semi.holdMax or 2.6), "READY")

                if dist <= (tonumber(Semi.radius) or 10) then
                    if not alreadyInRange then task.wait(Semi.entryDelay or 0.3) end
                    if Semi.enabled then
                        for _, fn in ipairs(data.triggerCallbacks) do
                            task.spawn(function() pcall(fn) end)
                        end
                        fired = true
                    end
                    break
                end
                task.wait()
            end

            Semi.state.lastResult = "READY"
            Semi.state.active = false
            Semi.state.phase = fired and "success" or "failed"
            Semi.state.lastResultTime = tick()

            if fired then
                updateStealBar(1, "READY")
            else
                updateStealBar(0, "READY")
            end

            task.wait(Semi.cooldown or 0.05)
            data.ready = true
            task.wait(0.5)
            Semi.state.phase = "idle"
            resetProgressBar()
            isStealing = false
        end)
        return true
    end

    -- ============================================================
    --  CONTROL DE AUTO STEAL
    -- ============================================================
    local function startAnimalScan()
        if stealScanThread then return end
        stealScanThread = task.spawn(function()
            while true do
                if Steal.AutoStealEnabled then
                    pcall(scanAllPlotsSemi)
                end
                task.wait(2)
            end
        end)
    end

    local function stopAnimalScan()
        if stealScanThread then
            task.cancel(stealScanThread)
            stealScanThread = nil
        end
    end

    function startAutoSteal()
        if stealHeartbeatConn then
            Semi.enabled = true
            Steal.AutoStealEnabled = true
            if setInstaGrab then setInstaGrab(true) end
            return
        end
        Semi.enabled = true
        Steal.AutoStealEnabled = true
        if setInstaGrab then setInstaGrab(true) end
        initSemiSync()
        pcall(scanAllPlotsSemi)
        startAnimalScan()

        stealHeartbeatConn = RunService.Heartbeat:Connect(function()
            -- Mantener el estado activo si otra rutina modifica accidentalmente la bandera.
            -- stopAutoSteal() desactiva Semi.enabled antes de desconectar, por lo que el apagado manual se conserva.
            if Semi.enabled and not Steal.AutoStealEnabled then
                Steal.AutoStealEnabled = true
                if setInstaGrab then setInstaGrab(true) end
            end
            if not Semi.enabled or not Steal.AutoStealEnabled then return end
            if isStealing or Semi.state.active then return end

            local target = pickClosest()
            if not target then return end
            local prompt = findPromptForAnimal(target)
            if prompt then executeSemi(prompt, target) end
        end)

        updateProgressBarVisibility()
    end

    function stopAutoSteal()
        Semi.enabled = false
        Steal.AutoStealEnabled = false
        if stealHeartbeatConn then
            stealHeartbeatConn:Disconnect()
            stealHeartbeatConn = nil
        end
        Semi.state.active = false
        Semi.state.phase = "idle"
        isStealing = false
        stopAnimalScan()
        resetProgressBar()
        updateProgressBarVisibility()
    end

    LP.CharacterAdded:Connect(function()
        task.wait(1)
        if Steal.AutoStealEnabled then
            pcall(scanAllPlotsSemi)
            pcall(startAutoSteal)
        end
    end)

    -- ====== TP DOWN ======
    do
        local row = mkRow(38)
        mkLabel(row, "TP Down")
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(0.55, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.Activated:Connect(function() executeTPDown() end)
        local actLbl = Instance.new("TextLabel", row)
        actLbl.Size = UDim2.new(0, 60, 1, 0)
        actLbl.Position = UDim2.new(1, -64, 0, 0)
        actLbl.BackgroundTransparency = 1
        actLbl.Text = "ACTIVATE"
        actLbl.TextColor3 = ACCENT
        actLbl.Font = Enum.Font.FredokaOne
        actLbl.TextSize = 10
        actLbl.TextXAlignment = Enum.TextXAlignment.Right
        applyShimmerToText(actLbl, 0.8)
    end
    do
        local row = mkRow(38)
        mkLabel(row, "TP Down Mode")
        tpModeSelectBtn = mkSelector(row, tpDownMode == 1 and "V1" or "V1", function(btn)
            tpDownMode = tpDownMode == 1 and 1 or 1
            btn.Text = tpDownMode == 1 and "V1" or "V1"
        end)
    end
    -- Auto TP Down se controla desde el botón flotante; se conserva este setter
    -- para sincronizar estados cargados o restablecidos sin crear un toggle duplicado.
    setAutoTPDownVisual = function(on)
        if mobSetAutoTPDown then mobSetAutoTPDown(on == true) end
    end
    do local row=mkRow(38); mkLabel(row,"Height Y"); autoTPHeightBox=mkBox(row,autoTPHeight,45,52,function(v) if v>=1 and v<=500 then autoTPHeight=v; autoTPDownThreshold=v end end) end

    do
        local row = mkRow(38)
        mkLabel(row, "Infinite Jump")
        jumpPill, jumpDot = mkPill(row, 52)
        jumpOn = false
        setJumpToggleState = function(state)
            if jumpOn == state then return end
            jumpOn = state
            animPill(jumpPill, jumpDot, state)
            if state then
                jumpEnabled = true
                startJumpMode()
            else
                jumpEnabled = false
                stopJumpMode()
            end
        end
        local jumpClk = Instance.new("TextButton", jumpPill)
        jumpClk.Size = UDim2.new(1,0,1,0)
        jumpClk.BackgroundTransparency = 1
        jumpClk.Text = ""
        jumpClk.Activated:Connect(function()
            if _anyKeyListening then return end
            setJumpToggleState(not jumpOn)
        end)
        setJumpVisual = function(state) setJumpToggleState(state) end
    end

    do
        local row = mkRow(38)
        mkLabel(row, "Jump Mode")
        modeSelectBtn = mkSelector(row, jumpMode == 1 and "Tap Tap" or "Hold", function(btn)
            local newMode = jumpMode == 1 and 2 or 1
            jumpMode = newMode
            btn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
            if jumpEnabled then
                stopJumpMode()
                startJumpMode()
            end
        end)
    end

    setUnwalkVisual = mkToggle("Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

do
    -- Variables
    local autoResetOnDeath = false
    local _deathResetConn = nil
    local _deathResetCharAdded = nil
    
    -- Funciones
    local function setupDeathReset()
        if autoResetOnDeath then
            local char = LP.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if _deathResetConn then _deathResetConn:Disconnect() end
                    _deathResetConn = hum.Died:Connect(function()
                        if autoResetOnDeath then
                                        end
                    end)
                end
            end
            if not _deathResetCharAdded then
                _deathResetCharAdded = LP.CharacterAdded:Connect(function(char)
                    task.wait(0.5)
                    setupDeathReset()
                end)
            end
        else
            if _deathResetConn then _deathResetConn:Disconnect(); _deathResetConn = nil end
            if _deathResetCharAdded then _deathResetCharAdded:Disconnect(); _deathResetCharAdded = nil end
        end
    end
    
    local function toggleAutoResetOnDeath(state)
        autoResetOnDeath = state
        setupDeathReset()
        pcall(saveAllSettings)
    end
    
    -- Toggle en GUI
    local setAutoResetOnDeath = mkToggle("Auto Reset on Death", function(on)
        toggleAutoResetOnDeath(on)
    end)
    
    -- Cargar estado guardado
    if type(loadAllSettings) == "function" then
        -- Intentar cargar desde config
        local ok, data = pcall(function()
            if isfile and isfile("LustHub.json") then
                return game:GetService("HttpService"):JSONDecode(readfile("LustHub.json"))
            end
        end)
        if ok and type(data) == "table" and data.autoResetOnDeath ~= nil then
            autoResetOnDeath = data.autoResetOnDeath
            if autoResetOnDeath then
                task.wait(0.1)
                setAutoResetOnDeath(true)
                setupDeathReset()
            end
        end
    end
    
    -- Guardar en buildConfigTable (si existe)
    if type(buildConfigTable) == "function" then
        local oldBuild = buildConfigTable
        buildConfigTable = function()
            local config = oldBuild()
            config.autoResetOnDeath = autoResetOnDeath
            return config
        end
    end
    
    -- Limpiar en stopAllBackgroundTasks (si existe)
    if type(stopAllBackgroundTasks) == "function" then
        local oldStop = stopAllBackgroundTasks
        stopAllBackgroundTasks = function()
            oldStop()
            autoResetOnDeath = false
            if _deathResetConn then _deathResetConn:Disconnect(); _deathResetConn = nil end
            if _deathResetCharAdded then _deathResetCharAdded:Disconnect(); _deathResetCharAdded = nil end
        end
    end
    
    -- Resetear en resetToDefaults (si existe)
    if type(resetToDefaults) == "function" then
        local oldReset = resetToDefaults
        resetToDefaults = function()
            oldReset()
            autoResetOnDeath = false
            setupDeathReset()
            if setAutoResetOnDeath then setAutoResetOnDeath(false) end
        end
    end
    
    -- CharacterAdded
    local oldCharAdded = LP.CharacterAdded
    LP.CharacterAdded:Connect(function(char)
        if autoResetOnDeath then
            task.wait(0.5)
            setupDeathReset()
        end
    end)
end

-- TRACERS + ESP PLAYER AVATAR
-- Integrado para que las líneas, el Highlight y la foto circular
-- se activen y desactiven juntos desde el toggle "Player ESP".

local tracersEnabled = false
local tracersConn = nil
local tracersData = {}
local TRACER_COLOR = Color3.fromRGB(210, 210, 214)
local tracerToggleSetter = nil

local ESPPlayerObjects = {}

local function removePlayerAvatar(plr)
    local data = ESPPlayerObjects[plr]
    if not data then return end

    if data.billboard then
        pcall(function()
            data.billboard:Destroy()
        end)
    end

    ESPPlayerObjects[plr] = nil
end

local function createPlayerAvatar(plr)
    if plr == LP or ESPPlayerObjects[plr] then return end

    local character = plr.Character
    local head = character and character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPPlayerAvatar"
    billboard.Size = UDim2.fromOffset(52, 52)
    billboard.StudsOffset = Vector3.new(0, 3.2, 0)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false
    billboard.Adornee = head
    billboard.Parent = LP:WaitForChild("PlayerGui")

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.fromScale(1, 1)
    avatar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    avatar.BackgroundTransparency = 0
    avatar.BorderSizePixel = 0
    avatar.Image = ""
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = avatar

    local stroke = Instance.new("UIStroke")
    stroke.Name = "AvatarStroke"
    stroke.Thickness = 2
    stroke.Color = TRACER_COLOR
    stroke.Transparency = 0.1
    stroke.Parent = avatar

    ESPPlayerObjects[plr] = {
        billboard = billboard,
        avatar = avatar,
        stroke = stroke,
    }

    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                plr.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)

        if ok and image and avatar.Parent then
            avatar.Image = image
        end
    end)
end

local function refreshPlayerAvatar(plr)
    if not tracersEnabled or plr == LP then return end
    removePlayerAvatar(plr)
    task.wait(0.25)
    if tracersEnabled then
        createPlayerAvatar(plr)
    end
end

local function applyTracerGlow(player, char)
    if not char then return end
    if not tracersData[player] then return end

    if tracersData[player].Glow then
        pcall(function()
            tracersData[player].Glow:Destroy()
        end)
        tracersData[player].Glow = nil
    end

    task.wait(0.2)

    local glow = Instance.new("Highlight")
    glow.Name = "TracerGlow"
    glow.FillColor = TRACER_COLOR
    glow.FillTransparency = 0.35
    glow.OutlineColor = TRACER_COLOR
    glow.OutlineTransparency = 0.1
    glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    glow.Adornee = char
    glow.Parent = char

    tracersData[player].Glow = glow
end

local function setupTracer(player)
    if player == LP then return end
    if tracersData[player] then return end

    local line = Drawing.new("Line")
    line.Color = TRACER_COLOR
    line.Thickness = 1.5
    line.Transparency = 0.7
    line.Visible = false

    tracersData[player] = {
        Line = line,
        Glow = nil,
    }

    if player.Character then
        applyTracerGlow(player, player.Character)
        if tracersEnabled then
            createPlayerAvatar(player)
        end
    end

    player.CharacterAdded:Connect(function(char)
        applyTracerGlow(player, char)
        if tracersEnabled then
            task.spawn(function()
                refreshPlayerAvatar(player)
            end)
        end
    end)
end

local function startTracers()
    if tracersConn then return end
    if not tracersEnabled then return end

    for _, v in ipairs(Players:GetPlayers()) do
        setupTracer(v)
        if v ~= LP then
            createPlayerAvatar(v)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        setupTracer(player)
        if tracersEnabled and player.Character then
            createPlayerAvatar(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if tracersData[player] then
            if tracersData[player].Line then
                pcall(function()
                    tracersData[player].Line:Remove()
                end)
            end
            if tracersData[player].Glow then
                pcall(function()
                    tracersData[player].Glow:Destroy()
                end)
            end
            tracersData[player] = nil
        end
        removePlayerAvatar(player)
    end)

    tracersConn = RunService.RenderStepped:Connect(function()
        if not tracersEnabled then
            return
        end

        local myChar = LP.Character
        local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

        if not myHrp then
            for _, data in pairs(tracersData) do
                if data.Line then
                    data.Line.Visible = false
                end
            end
            return
        end

        local myPos, visible1 = workspace.CurrentCamera:WorldToViewportPoint(myHrp.Position)
        if not visible1 then
            for _, data in pairs(tracersData) do
                if data.Line then
                    data.Line.Visible = false
                end
            end
            return
        end

        for player, data in pairs(tracersData) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local targetPos, visible2 = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                if visible2 then
                    data.Line.Visible = true
                    data.Line.From = Vector2.new(myPos.X, myPos.Y)
                    data.Line.To = Vector2.new(targetPos.X, targetPos.Y)
                else
                    data.Line.Visible = false
                end
            else
                data.Line.Visible = false
            end
        end
    end)
end

local function stopTracers()
    if tracersConn then
        tracersConn:Disconnect()
        tracersConn = nil
    end

    for player, data in pairs(tracersData) do
        if data.Line then
            pcall(function()
                data.Line:Remove()
            end)
        end
        if data.Glow then
            pcall(function()
                data.Glow:Destroy()
            end)
        end
    end
    tracersData = {}

    for plr in pairs(ESPPlayerObjects) do
        removePlayerAvatar(plr)
    end
end

local function toggleTracers(state)
    tracersEnabled = state == true

    if tracersEnabled then
        startTracers()
    else
        stopTracers()
    end

    pcall(saveAllSettings)
end

local function setTracerColor(color)
    TRACER_COLOR = color

    for player, data in pairs(tracersData) do
        if data.Line then
            data.Line.Color = color
        end
        if data.Glow then
            data.Glow.FillColor = color
            data.Glow.OutlineColor = color
        end
    end

    for _, data in pairs(ESPPlayerObjects) do
        if data.stroke then
            data.stroke.Color = color
        end
    end
end

-- Disponible desde otros bloques del script.
_G.Tracers = {
    start = startTracers,
    stop = stopTracers,
    toggle = toggleTracers,
    setColor = setTracerColor,
    isEnabled = function()
        return tracersEnabled
    end,
}

_G.ToggleESPPlayer = function(enabled)
    toggleTracers(enabled)
end

task.spawn(function()
    task.wait(1.5)
    if tracersEnabled then
        startTracers()
        if tracerToggleSetter then
            tracerToggleSetter(true)
        end
    end
end)

local oldBuild = buildConfigTable
buildConfigTable = function()
    local config = oldBuild()
    config.tracersEnabled = tracersEnabled
    return config
end

local oldLoad = loadAllSettings
loadAllSettings = function()
    local ok = oldLoad()
    if ok then
        local data = HS:JSONDecode(readfile(CONFIG_FILE))
        if data and data.tracersEnabled ~= nil then
            tracersEnabled = data.tracersEnabled
            if tracerToggleSetter then
                tracerToggleSetter(tracersEnabled)
            end
            if tracersEnabled then
                task.spawn(function()
                    task.wait(0.5)
                    startTracers()
                end)
            end
        end
    end
    return ok
end

LP.CharacterAdded:Connect(function()
    if tracersEnabled then
        task.spawn(function()
            task.wait(1)
            startTracers()
        end)
    end
end)

local oldStop = stopAllBackgroundTasks
stopAllBackgroundTasks = function()
    oldStop()
    if tracersEnabled then
        stopTracers()
    end
end

-- El toggle Player ESP se crea dentro de la sección Main.


-- Reactivar al reaparecer o al volver a habilitar el sistema.
if tracersEnabled then
    task.spawn(function()
        task.wait(1)
        startTracers()
    end)
end
    dropBrainrotSetVisual = mkToggle("Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual

    do
        local row = mkRow(38)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "V1" or "V2", function(btn)
            if dropActive then
                stopDropBrainrot()
            end
            dropMode = dropMode == 1 and 2 or 1
            btn.Text = dropMode == 1 and "V1" or "V2"
        end)
    end

        -- ====== COMBAT VISUAL HELPERS ======


-- ====== SKY THEME SYSTEM ======
currentSkyTheme = currentSkyTheme or "Off"
local KILL_SKY_TAG = "MoveeSkyTheme"
local skySelectorLabel = nil
local skyOriginalLighting = nil
local KILL_SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local KILL_SKY_ORDER = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Arctic","Heaven","Storm","Sunrise","Deep Space","Mint Sky"}
local function killColor(rgb) return Color3.fromRGB(rgb[1],rgb[2],rgb[3]) end
local function killSaveOriginalLighting()
    if skyOriginalLighting then return end
    skyOriginalLighting = {ClockTime=Lighting.ClockTime,Brightness=Lighting.Brightness,OutdoorAmbient=Lighting.OutdoorAmbient,Ambient=Lighting.Ambient,FogStart=Lighting.FogStart,FogEnd=Lighting.FogEnd,FogColor=Lighting.FogColor,ColorShift_Top=Lighting.ColorShift_Top,ColorShift_Bottom=Lighting.ColorShift_Bottom,GlobalShadows=Lighting.GlobalShadows,LightingChildren={},TerrainChildren={}}
    for _,child in ipairs(Lighting:GetChildren()) do if child:IsA("Sky") or child:IsA("Atmosphere") then table.insert(skyOriginalLighting.LightingChildren,child:Clone()) end end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:IsA("Clouds") then table.insert(skyOriginalLighting.TerrainChildren,child:Clone()) end end end
end
local function KillApplyCustomSky(mode)
    killSaveOriginalLighting()
    for _,child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(KILL_SKY_TAG) or child:IsA("Sky") or child:IsA("Atmosphere") then pcall(function() child:Destroy() end) end
    end
    local terrain=workspace:FindFirstChildOfClass("Terrain")
    if terrain then for _,child in ipairs(terrain:GetChildren()) do if child:GetAttribute(KILL_SKY_TAG) or child:IsA("Clouds") then pcall(function() child:Destroy() end) end end end
    local preset=KILL_SKY_PRESETS[mode]
    if not preset or preset.kind=="off" then
        if skyOriginalLighting then
            for k,v in pairs(skyOriginalLighting) do if k~="LightingChildren" and k~="TerrainChildren" then pcall(function() Lighting[k]=v end) end end
            for _,child in ipairs(skyOriginalLighting.LightingChildren or {}) do child:Clone().Parent=Lighting end
            local offTerrain=workspace:FindFirstChildOfClass("Terrain")
            if offTerrain then for _,child in ipairs(skyOriginalLighting.TerrainChildren or {}) do child:Clone().Parent=offTerrain end end
        end
        currentSkyTheme="Off"; return
    end
    Lighting.FogStart=0;Lighting.FogEnd=100000;Lighting.FogColor=Color3.fromRGB(200,200,200);Lighting.ColorShift_Top=Color3.fromRGB(0,0,0);Lighting.ColorShift_Bottom=Color3.fromRGB(0,0,0);Lighting.GlobalShadows=true;Lighting.ClockTime=preset.clock or 14;Lighting.Brightness=preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient=killColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient=killColor(preset.ambient) end
    if preset.sky then local skyInst=Instance.new("Sky");skyInst:SetAttribute(KILL_SKY_TAG,true);if preset.sky.stars then skyInst.StarCount=preset.sky.stars end;if preset.sky.moon then skyInst.MoonAngularSize=preset.sky.moon end;if preset.sky.sun then skyInst.SunAngularSize=preset.sky.sun end;if preset.sky.moonTex then skyInst.MoonTextureId="rbxasset://sky/moon.jpg" end;skyInst.Parent=Lighting end
    if preset.atm then local atm=Instance.new("Atmosphere");atm:SetAttribute(KILL_SKY_TAG,true);atm.Density=preset.atm.dens or 0.3;atm.Color=killColor(preset.atm.color);atm.Decay=killColor(preset.atm.decay);atm.Glare=preset.atm.glare or 1;atm.Haze=preset.atm.haze or 1;atm.Parent=Lighting end
    if preset.clouds and terrain then local clouds=Instance.new("Clouds");clouds:SetAttribute(KILL_SKY_TAG,true);clouds.Cover=preset.clouds.cover or 0.5;clouds.Density=preset.clouds.dens or 0.5;clouds.Color=killColor(preset.clouds.color);clouds.Parent=terrain end
    currentSkyTheme=mode
end
function setSkyTheme(theme)
    if not KILL_SKY_PRESETS[theme] then theme="Off" end
    currentSkyTheme=theme;KillApplyCustomSky(theme);if skySelectorLabel then skySelectorLabel.Text=theme end
end

-- ====== MELE AIMBOT / BODY LOCK ======
local LOCK_RANGE = 150
local TOGGLE_KEY = Enum.KeyCode.B
local bodyLockEnabled = true
local _bodyLockConn = nil

local function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
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

local function bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local target = getClosestTarget()
    if not target then
        hum.AutoRotate = true
        return
    end

    local dist = (target.Position - root.Position).Magnitude
    if dist > LOCK_RANGE then
        hum.AutoRotate = true
        return
    end

    hum.AutoRotate = false
    local targetVel = target.AssemblyLinearVelocity
    local predictTime = math.clamp(targetVel.Magnitude / 150, 0.05, 0.2)
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

local function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    _bodyLockConn = RunService.RenderStepped:Connect(function()
        if bodyLockEnabled then bodyLockTick() end
    end)
end

local function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

local function toggleBodyLock()
    bodyLockEnabled = not bodyLockEnabled
    if bodyLockEnabled then
        startBodyLock()
        print("[MELE] Activado")
    else
        stopBodyLock()
        print("[MELE] Desactivado")
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if bodyLockEnabled then
        stopBodyLock()
        task.wait(0.2)
        startBodyLock()
    end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == TOGGLE_KEY and input.UserInputType == Enum.UserInputType.Keyboard then
        toggleBodyLock()
    end
end)

LP.Chatted:Connect(function(msg)
    if msg:lower() == "!mele" then toggleBodyLock() end
end)

-- Iniciar automáticamente al ejecutar el script.
startBodyLock()

local meleAimbotVisual = mkToggle("Mele Aimbot", function(on)
    if on ~= bodyLockEnabled then toggleBodyLock() end
end)
-- Reflejar el estado real: empieza activado.
meleAimbotVisual(true)

-- ============================================================
--  NINO TIME - Stun Timer (3-2-1 READY)
-- ============================================================
-- Nino Time queda activado por defecto si todavía no hay una preferencia guardada.
local ninoTimeEnabled = true
local ninoTimerGuiBB = nil
local ninoTimerText = nil
local ninoStunActive = false
local ninoStunStartTime = 0
local ninoStunDuration = 3.0
local ninoStunConnection = nil
local ninoStateChangedConnection = nil
local ninoDetectConnection = nil
local ninoCharacterAddedConnection = nil
local ninoWasStunned = false
local ninoLastDisplayedSecond = nil
local setNinoTimeVisual = nil

-- ============================================================
--  NINO TIME BACKEND
-- ============================================================
local function ninoCreateBillboard()
    if ninoTimerGuiBB then return end
    local char = LP.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    ninoTimerGuiBB = Instance.new("BillboardGui")
    ninoTimerGuiBB.Name = "NinoTimeBB"
    ninoTimerGuiBB.Adornee = head
    ninoTimerGuiBB.Size = UDim2.new(0, 120, 0, 36)
    ninoTimerGuiBB.StudsOffset = Vector3.new(0, 3.5, 0)
    ninoTimerGuiBB.AlwaysOnTop = true
    ninoTimerGuiBB.Parent = LP:WaitForChild("PlayerGui")
    ninoTimerGuiBB.Enabled = true
    ninoTimerText = Instance.new("TextLabel", ninoTimerGuiBB)
    ninoTimerText.Size = UDim2.new(1, 0, 1, 0)
    ninoTimerText.BackgroundTransparency = 1
    ninoTimerText.Text = "READY!!"
    ninoTimerText.TextColor3 = Color3.fromRGB(0, 255, 100)
    ninoTimerText.Font = Enum.Font.GothamBlack
    ninoTimerText.TextSize = 20
    ninoTimerText.TextStrokeTransparency = 0.5
    ninoTimerText.TextStrokeColor3 = Color3.fromRGB(10, 10, 11)
    ninoTimerText.TextXAlignment = Enum.TextXAlignment.Center
    ninoTimerText.TextYAlignment = Enum.TextYAlignment.Center
end

local function ninoUpdateDisplay()
    if not ninoTimerText then return end
    if not ninoStunActive then
        ninoTimerText.Text = "READY!!"
        ninoTimerText.TextColor3 = Color3.fromRGB(0, 255, 100)
        ninoTimerText.TextSize = 20
        if ninoTimerGuiBB then ninoTimerGuiBB.Enabled = ninoTimeEnabled end
        return
    end
    local elapsed = tick() - ninoStunStartTime
    local remaining = math.max(0, ninoStunDuration - elapsed)
    if remaining <= 0 then
        ninoStunActive = false
        if ninoStunConnection then ninoStunConnection:Disconnect(); ninoStunConnection = nil end
        ninoTimerText.Text = "READY!!"
        ninoTimerText.TextColor3 = Color3.fromRGB(210, 210, 214)
        ninoTimerText.TextSize = 20
        if ninoTimerGuiBB then ninoTimerGuiBB.Enabled = true end
        return
    end
    local second = math.ceil(remaining)
    if second ~= ninoLastDisplayedSecond then
        ninoLastDisplayedSecond = second
        ninoTimerText.Text = tostring(second)
        ninoTimerText.TextSize = 32
        if second == 3 then ninoTimerText.TextColor3 = Color3.fromRGB(210, 210, 214)
        elseif second == 2 then ninoTimerText.TextColor3 = Color3.fromRGB(50, 255, 50)
        elseif second == 1 then ninoTimerText.TextColor3 = Color3.fromRGB(50, 150, 255) end
    end
    if ninoTimerGuiBB then ninoTimerGuiBB.Enabled = true end
end

local function ninoOnStunDetected()
    if not ninoTimeEnabled then return end
    if ninoStunActive then return end
    ninoStunActive = true
    ninoStunStartTime = tick()
    ninoLastDisplayedSecond = nil
    ninoCreateBillboard()
    ninoUpdateDisplay()
    if ninoStunConnection then ninoStunConnection:Disconnect() end
    ninoStunConnection = RunService.Heartbeat:Connect(ninoUpdateDisplay)
end

local function ninoReadStunState(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Physics or
       state == Enum.HumanoidStateType.Ragdoll or
       state == Enum.HumanoidStateType.FallingDown or
       hum.PlatformStand then
        return true
    end

    for _, name in ipairs({"Stunned", "Stun", "IsStunned", "stunned", "stun"}) do
        local value = char:FindFirstChild(name, true)
        if value and value:IsA("BoolValue") and value.Value then return true end
        local attribute = hum:GetAttribute(name)
        if attribute == true then return true end
        attribute = char:GetAttribute(name)
        if attribute == true then return true end
    end

    return false
end

local function ninoSetupDetection(char)
    if ninoStateChangedConnection then ninoStateChangedConnection:Disconnect(); ninoStateChangedConnection = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    ninoStateChangedConnection = hum.StateChanged:Connect(function()
        if ninoTimeEnabled and ninoReadStunState(char) and not ninoWasStunned then
            ninoOnStunDetected()
        end
    end)
end

local function ninoStartDetection()
    if ninoDetectConnection then ninoDetectConnection:Disconnect() end
    ninoDetectConnection = RunService.Heartbeat:Connect(function()
        if not ninoTimeEnabled then return end
        local char = LP.Character
        local currentlyStunned = ninoReadStunState(char)
        if currentlyStunned and not ninoWasStunned then
            ninoOnStunDetected()
        end
        ninoWasStunned = currentlyStunned
    end)
end

local function setNinoTime(enabled)
    -- Nino Time inicia activado, pero el toggle puede apagarlo.
    ninoTimeEnabled = enabled
    if setNinoTimeVisual then setNinoTimeVisual(enabled) end
    if not enabled then
        if ninoStunConnection then ninoStunConnection:Disconnect(); ninoStunConnection = nil end
        if ninoDetectConnection then ninoDetectConnection:Disconnect(); ninoDetectConnection = nil end
        ninoStunActive = false
        ninoWasStunned = false
        if ninoTimerGuiBB then
            ninoTimerGuiBB:Destroy()
            ninoTimerGuiBB = nil
            ninoTimerText = nil
        end
        if ninoStateChangedConnection then ninoStateChangedConnection:Disconnect(); ninoStateChangedConnection = nil end
    else
        ninoCreateBillboard()
        ninoUpdateDisplay()
        local char = LP.Character
        if char then ninoSetupDetection(char) end
        ninoStartDetection()
        -- Ejecutar una primera cuenta visible al activar el toggle.
        -- Después, la detección normal iniciará las siguientes cuentas.
        ninoOnStunDetected()
    end
end

ninoCharacterAddedConnection = LP.CharacterAdded:Connect(function(char)
    if ninoTimeEnabled then
        ninoWasStunned = false
        ninoStunActive = false
        if ninoStunConnection then ninoStunConnection:Disconnect(); ninoStunConnection = nil end
        if ninoStateChangedConnection then ninoStateChangedConnection:Disconnect(); ninoStateChangedConnection = nil end
        if ninoTimerGuiBB then
            ninoTimerGuiBB:Destroy()
            ninoTimerGuiBB = nil
            ninoTimerText = nil
        end
        task.wait(0.2)
        ninoCreateBillboard()
        ninoUpdateDisplay()
        ninoSetupDetection(char)
    end
end)
-- ============================================================
--  FIN NINO TIME
-- ============================================================

local ninoTimeSetVisual = mkToggle("cipher timer", function(on)
    setNinoTime(on)
    pcall(saveAllSettings)
end)
setNinoTimeVisual = ninoTimeSetVisual
-- Arranque inicial; la preferencia guardada se restaura más abajo.
setNinoTime(true)

-- =============================================
-- GUARDAR Y RESTAURAR NINO TIME
-- =============================================
local oldBuildConfigNinoTime = buildConfigTable
buildConfigTable = function()
    local config = oldBuildConfigNinoTime()
    config.ninoTimeEnabled = ninoTimeEnabled
    return config
end

local oldLoadSettingsNinoTime = loadAllSettings
loadAllSettings = function()
    local ok = oldLoadSettingsNinoTime()
    if ok then
        local data = HS:JSONDecode(readfile(CONFIG_FILE))
        if data and data.ninoTimeEnabled ~= nil then
            setNinoTime(data.ninoTimeEnabled)
        end
    end
    return ok
end

    -- ====== AUTO LEFT / RIGHT ======
    mkSect("Auto Left / Right")
    autoLeftSetVisual = mkToggle("Auto Left", function(on)
        if on then
            autoLeftEnabled = true
            startAutoLeft()
        else
            autoLeftEnabled = false
            stopAutoLeft()
        end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle("Auto Right", function(on)
        if on then
            autoRightEnabled = true
            startAutoRight()
        else
            autoRightEnabled = false
            stopAutoRight()
        end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)


    mkSect("Main")
    mkSect("Auto Steal")
    -- Toggle de Auto Steal.
    setInstaGrab = mkToggle("Auto Steal", function(on)
        if on then
            Steal.AutoStealEnabled = true
            pcall(startAutoSteal)
        else
            pcall(stopAutoSteal)
        end
        updateProgressBarVisibility()
        pcall(saveAllSettings)
    end)

    -- Campo editable del alcance de Auto Steal.
    do
        local row = mkRow(38)
        mkLabel(row, "Auto Steal Range")
        radInput = mkBox(row, Semi.radius, 52, 60, function(value)
            local radius = math.clamp(value, 1, 80)
            Semi.radius = radius
            Steal.StealRadius = radius
            if radInput then
                radInput.Text = string.format("%.2g", radius)
            end
        end)
    end


    -- ====== VISUAL ======
    mkSect("Visual")
    -- Selector Sky Theme con el mismo patrón de Lust Hub: botones < y >.
    do
        local row = mkRow(38)
        mkLabel(row, "Sky Theme Pack")
        local skyIndex = 1
        for i, theme in ipairs(KILL_SKY_ORDER) do if theme == currentSkyTheme then skyIndex = i break end end
        local prevSky = Instance.new("TextButton", row)
        prevSky.Size = UDim2.new(0, 24, 0, 24)
        prevSky.Position = UDim2.new(1, -148, 0.5, -12)
        prevSky.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        prevSky.BorderSizePixel = 0
        prevSky.Text = "<"
        prevSky.TextColor3 = ACCENT
        prevSky.Font = Enum.Font.GothamBold
        prevSky.TextSize = 12
        Instance.new("UICorner", prevSky).CornerRadius = UDim.new(0, 5)
        skySelectorLabel = Instance.new("TextLabel", row)
        skySelectorLabel.Size = UDim2.new(0, 92, 0, 24)
        skySelectorLabel.Position = UDim2.new(1, -120, 0.5, -12)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = KILL_SKY_ORDER[skyIndex]
        skySelectorLabel.TextColor3 = ACCENT
        skySelectorLabel.Font = Enum.Font.FredokaOne
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        local nextSky = Instance.new("TextButton", row)
        nextSky.Size = UDim2.new(0, 24, 0, 24)
        nextSky.Position = UDim2.new(1, -28, 0.5, -12)
        nextSky.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        nextSky.BorderSizePixel = 0
        nextSky.Text = ">"
        nextSky.TextColor3 = ACCENT
        nextSky.Font = Enum.Font.GothamBold
        nextSky.TextSize = 12
        Instance.new("UICorner", nextSky).CornerRadius = UDim.new(0, 5)
        local function selectSky(index)
            skyIndex = ((index - 1) % #KILL_SKY_ORDER) + 1
            setSkyTheme(KILL_SKY_ORDER[skyIndex])
            pcall(saveAllSettings)
        end
        prevSky.Activated:Connect(function() selectSky(skyIndex - 1) end)
        nextSky.Activated:Connect(function() selectSky(skyIndex + 1) end)
    end


    -- Selector de Accessory Pack con navegación < y >.
    do
        local row = mkRow(38)
        mkLabel(row, "Accessory Pack")
        local packIndex = 1
        for i, name in ipairs(ACCESSORY_PACK_ORDER) do if name == currentAccessoryPack then packIndex = i break end end
        local prevPack = Instance.new("TextButton", row)
        prevPack.Size = UDim2.new(0, 24, 0, 24)
        prevPack.Position = UDim2.new(1, -148, 0.5, -12)
        prevPack.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        prevPack.BorderSizePixel = 0
        prevPack.Text = "<"
        prevPack.TextColor3 = ACCENT
        prevPack.Font = Enum.Font.GothamBold
        prevPack.TextSize = 12
        Instance.new("UICorner", prevPack).CornerRadius = UDim.new(0, 5)
        accSelectorLabel = Instance.new("TextLabel", row)
        accSelectorLabel.Size = UDim2.new(0, 92, 0, 24)
        accSelectorLabel.Position = UDim2.new(1, -120, 0.5, -12)
        accSelectorLabel.BackgroundTransparency = 1
        accSelectorLabel.Text = ACCESSORY_PACK_ORDER[packIndex]
        accSelectorLabel.TextColor3 = ACCENT
        accSelectorLabel.Font = Enum.Font.FredokaOne
        accSelectorLabel.TextSize = 11
        accSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        local nextPack = Instance.new("TextButton", row)
        nextPack.Size = UDim2.new(0, 24, 0, 24)
        nextPack.Position = UDim2.new(1, -28, 0.5, -12)
        nextPack.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        nextPack.BorderSizePixel = 0
        nextPack.Text = ">"
        nextPack.TextColor3 = ACCENT
        nextPack.Font = Enum.Font.GothamBold
        nextPack.TextSize = 12
        Instance.new("UICorner", nextPack).CornerRadius = UDim.new(0, 5)
        local function selectAccessory(index)
            packIndex = ((index - 1) % #ACCESSORY_PACK_ORDER) + 1
            local selected = ACCESSORY_PACK_ORDER[packIndex]
            local ok = applyAccessoryPack(selected)
            if ok then
                accSelectorLabel.Text = selected
            else
                currentAccessoryPack = "Off"
                packIndex = 1
                accSelectorLabel.Text = "Off"
            end
            pcall(saveAllSettings)
        end
        prevPack.Activated:Connect(function() selectAccessory(packIndex - 1) end)
        nextPack.Activated:Connect(function() selectAccessory(packIndex + 1) end)
    end


    -- Selector de animaciones de Lust Hub, únicamente con navegación < y >.
    do
        local row = mkRow(38)
        mkLabel(row, "Anim Pack")
        local packs = {{"Off", "Off"}, {"Tryhard", "Tryhard"}, {"Crazy", "Crazy"}}
        local packIndex = 1
        local initialPack = _G.getAnimPack and _G.getAnimPack() or "Off"
        for i, entry in ipairs(packs) do
            if entry[2] == initialPack then packIndex = i break end
        end

        local prevPack = Instance.new("TextButton", row)
        prevPack.Size = UDim2.new(0, 24, 0, 24)
        prevPack.Position = UDim2.new(1, -148, 0.5, -12)
        prevPack.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        prevPack.BorderSizePixel = 0
        prevPack.Text = "<"
        prevPack.TextColor3 = ACCENT
        prevPack.Font = Enum.Font.GothamBold
        prevPack.TextSize = 12
        Instance.new("UICorner", prevPack).CornerRadius = UDim.new(0, 5)

        local packLabel = Instance.new("TextLabel", row)
        packLabel.Size = UDim2.new(0, 92, 0, 24)
        packLabel.Position = UDim2.new(1, -120, 0.5, -12)
        packLabel.BackgroundTransparency = 1
        packLabel.Text = packs[packIndex][2]
        packLabel.TextColor3 = ACCENT
        packLabel.Font = Enum.Font.FredokaOne
        packLabel.TextSize = 11
        packLabel.TextXAlignment = Enum.TextXAlignment.Center
        _G.animSelectorBtn = packLabel

        local nextPack = Instance.new("TextButton", row)
        nextPack.Size = UDim2.new(0, 24, 0, 24)
        nextPack.Position = UDim2.new(1, -28, 0.5, -12)
        nextPack.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        nextPack.BorderSizePixel = 0
        nextPack.Text = ">"
        nextPack.TextColor3 = ACCENT
        nextPack.Font = Enum.Font.GothamBold
        nextPack.TextSize = 12
        Instance.new("UICorner", nextPack).CornerRadius = UDim.new(0, 5)

        local function selectAnim(index)
            packIndex = ((index - 1) % #packs) + 1
            local selected = packs[packIndex][2]
            packLabel.Text = selected
            if selected == "Off" then
                _G.toggleAnimSystem(false)
            else
                _G.setAnimPack(selected)
            end
            pcall(saveAllSettings)
        end
        prevPack.Activated:Connect(function() selectAnim(packIndex - 1) end)
        nextPack.Activated:Connect(function() selectAnim(packIndex + 1) end)
    end


    tracerToggleSetter = mkToggle("Player ESP", function(on)
        toggleTracers(on)
    end)
    _G.tracerToggleSetter = tracerToggleSetter
    tracerToggleSetter(tracersEnabled)



    -- Toggle de Stretch con el mismo pill interactivo de Lust.
    local stretchToggleSetter
    do
        local stretchRow = mkRow(38)
        mkLabel(stretchRow, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(stretchRow, 52)
        local stretchOn = false
        local function setStretch(on)
            stretchOn = on == true
            animPill(stretchPill, stretchDot, stretchOn)
            if stretchOn then
                enableStretch()
            else
                disableStretch()
            end
            stretchEnabled = stretchOn
            pcall(saveAllSettings)
        end
        local stretchClick = Instance.new("TextButton", stretchPill)
        stretchClick.Size = UDim2.new(1, 0, 1, 0)
        stretchClick.BackgroundTransparency = 1
        stretchClick.Text = ""
        stretchClick.AutoButtonColor = false
        stretchClick.ZIndex = 10
        stretchClick.Activated:Connect(function()
            setStretch(not stretchOn)
        end)
        stretchToggleSetter = setStretch
        _G.stretchToggleSetter = setStretch
        setStretch(stretchEnabled)
    end

    -- FOV debajo del toggle, igual que en Lust: botones directos 90 / 120 / 180.
    do
        local fovValues = {90, 120, 180}
        local fovRow = mkRow(38)
        mkLabel(fovRow, "FOV")

        local fovContainer = Instance.new("Frame", fovRow)
        fovContainer.Size = UDim2.new(0, 180, 1, 0)
        fovContainer.Position = UDim2.new(1, -188, 0, 0)
        fovContainer.BackgroundTransparency = 1
        fovContainer.ZIndex = 8

        local fovButtons = {}
        _G.fovButtons = fovButtons

        local function refreshFovButtons()
            for _, button in ipairs(fovButtons) do
                local selected = tonumber(button.Text) == tonumber(stretchFOV)
                button.BackgroundColor3 = selected and Color3.fromRGB(48, 48, 50) or Color3.fromRGB(12, 12, 13)
                button.BackgroundTransparency = selected and 0.15 or 0.55
                button.TextColor3 = selected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(210, 210, 214)
                local stroke = button:FindFirstChildOfClass("UIStroke")
                if stroke then
                    stroke.Color = selected and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(70, 70, 74)
                    stroke.Transparency = selected and 0.15 or 0.55
                end
            end
        end

        for index, value in ipairs(fovValues) do
            local button = Instance.new("TextButton", fovContainer)
            button.Size = UDim2.new(0, 56, 0, 28)
            button.Position = UDim2.new(0, (index - 1) * 60, 0.5, -14)
            button.BackgroundColor3 = Color3.fromRGB(12, 12, 13)
            button.BackgroundTransparency = 0.55
            button.BorderSizePixel = 0
            button.Text = tostring(value)
            button.TextColor3 = Color3.fromRGB(210, 210, 214)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 12
            button.AutoButtonColor = false
            button.ZIndex = 9
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = Color3.fromRGB(70, 70, 74)
            stroke.Thickness = 1
            table.insert(fovButtons, button)
            button.Activated:Connect(function()
                stretchFOV = value
                if stretchEnabled then applyStretchFOV(stretchFOV) end
                refreshFovButtons()
                pcall(saveAllSettings)
            end)
        end
        refreshFovButtons()
    end

    setAntiLagVisual = mkToggle("Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)
    -- ====== INTERFACE ======
    mkSect("Interface")
    setLockButtonsVisual = mkToggle("Edit Buttons", function(on)
        -- Edit Buttons activado: movimiento individual permitido.
        -- Desactivado: botones bloqueados; se mueven junto con la GUI.
        floatingButtonsLocked = not (on == true)
        pcall(saveAllSettings)
    end)


    setLockUIVisual = mkToggle("Lock UI", function(on)
        toggleLockUI(on)
        pcall(saveAllSettings)
    end)


    do
        local row = mkRow(38)
        mkLabel(row, "Ui scale")
        local scaleValue = tonumber(_G.__FROST_UI_SIZE) or 75
        local scaleLabel = Instance.new("TextLabel", row)
        scaleLabel.Size = UDim2.new(0, 46, 1, 0)
        scaleLabel.Position = UDim2.new(1, -100, 0, 0)
        scaleLabel.BackgroundTransparency = 1
        scaleLabel.Text = tostring(scaleValue)
        scaleLabel.TextColor3 = ACCENT
        scaleLabel.Font = Enum.Font.FredokaOne
        scaleLabel.TextSize = 11
        scaleLabel.TextXAlignment = Enum.TextXAlignment.Center

        local scaleMinus = Instance.new("TextButton", row)
        scaleMinus.Size = UDim2.new(0, 24, 0, 24)
        scaleMinus.Position = UDim2.new(1, -54, 0.5, -12)
        scaleMinus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        scaleMinus.BorderSizePixel = 0
        scaleMinus.Text = "-"
        scaleMinus.TextColor3 = ACCENT
        scaleMinus.Font = Enum.Font.FredokaOne
        scaleMinus.TextSize = 14
        Instance.new("UICorner", scaleMinus).CornerRadius = UDim.new(0, 5)

        local scalePlus = Instance.new("TextButton", row)
        scalePlus.Size = UDim2.new(0, 24, 0, 24)
        scalePlus.Position = UDim2.new(1, -27, 0.5, -12)
        scalePlus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        scalePlus.BorderSizePixel = 0
        scalePlus.Text = "+"
        scalePlus.TextColor3 = ACCENT
        scalePlus.Font = Enum.Font.FredokaOne
        scalePlus.TextSize = 14
        Instance.new("UICorner", scalePlus).CornerRadius = UDim.new(0, 5)

        local function updateUIScale(value)
            scaleValue = math.clamp(math.floor(value + 0.5), 50, 150)
            scaleLabel.Text = tostring(scaleValue)
            _G.__FROST_UI_SIZE = scaleValue
            if _G.__FROST_UI_SCALE_OBJ then
                _G.__FROST_UI_SCALE_OBJ.Scale = scaleValue / 100
            end
            pcall(saveAllSettings)
        end
        scaleMinus.Activated:Connect(function() updateUIScale(scaleValue - 5) end)
        scalePlus.Activated:Connect(function() updateUIScale(scaleValue + 5) end)
    end


    do
        local row = mkRow(38)
        mkLabel(row, "Button scale")
        local valueLabel = Instance.new("TextLabel", row)
        valueLabel.Size = UDim2.new(0, 46, 1, 0)
        valueLabel.Position = UDim2.new(1, -100, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = string.format("%.1f", floatingButtonScale)
        valueLabel.TextColor3 = ACCENT
        valueLabel.Font = Enum.Font.FredokaOne
        valueLabel.TextSize = 11
        valueLabel.TextXAlignment = Enum.TextXAlignment.Center

        local minus = Instance.new("TextButton", row)
        minus.Size = UDim2.new(0, 24, 0, 24)
        minus.Position = UDim2.new(1, -54, 0.5, -12)
        minus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        minus.BorderSizePixel = 0
        minus.Text = "-"
        minus.TextColor3 = ACCENT
        minus.Font = Enum.Font.FredokaOne
        minus.TextSize = 14
        Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 5)

        local plus = Instance.new("TextButton", row)
        plus.Size = UDim2.new(0, 24, 0, 24)
        plus.Position = UDim2.new(1, -27, 0.5, -12)
        plus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        plus.BorderSizePixel = 0
        plus.Text = "+"
        plus.TextColor3 = ACCENT
        plus.Font = Enum.Font.FredokaOne
        plus.TextSize = 14
        Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 5)

        local function updateFloatingScale(value)
            floatingButtonScale = math.clamp(math.floor(value * 10 + 0.5) / 10, 0.5, 2.0)
            valueLabel.Text = string.format("%.1f", floatingButtonScale)
            if applyFloatingButtonScale then applyFloatingButtonScale(floatingButtonScale) end
            pcall(saveAllSettings)
        end
        minus.Activated:Connect(function() updateFloatingScale(floatingButtonScale - 0.1) end)
        plus.Activated:Connect(function() updateFloatingScale(floatingButtonScale + 0.1) end)
    end



    -- ====== CONFIG ======
    mkSect("Config")


        do
        local row = mkRow(38)
        row.Size = UDim2.new(1, -8, 0, 38)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        saveBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(210, 210, 214)
        saveBtn.Font = Enum.Font.FredokaOne
        saveBtn.TextSize = 11
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = Color3.fromRGB(0, 0, 0)
        saveStroke.Thickness = 1.2
        applyShimmerToText(saveBtn, 0.6)
        saveBtn.Activated:Connect(function()
            local ok = pcall(saveAllSettings)
            saveBtn.Text = ok and "SAVED ✓" or "ERROR"
            saveBtn.BackgroundColor3 = ok and Color3.fromRGB(30, 70, 40) or Color3.fromRGB(90, 30, 30)
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then
                    saveBtn.Text = "SAVE CONFIG"
                    saveBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
                end
            end)
        end)
    end
    do
        local row = mkRow(38)
        row.Size = UDim2.new(1, -8, 0, 38)
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        resetBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        resetBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET POSITIONS"
        resetBtn.TextColor3 = Color3.fromRGB(210, 210, 214)
        resetBtn.Font = Enum.Font.FredokaOne
        resetBtn.TextSize = 11
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetBtn)
        resetStroke.Color = Color3.fromRGB(0, 0, 0)
        resetStroke.Thickness = 1.2
        applyShimmerToText(resetBtn, 0.6)
        resetBtn.Activated:Connect(function()
            resetFloatingPositions()
            resetBtn.Text = "RESET ✓"
            resetBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
            task.delay(1.2, function()
                if resetBtn and resetBtn.Parent then
                    resetBtn.Text = "RESET POSITIONS"
                    resetBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
                end
            end)
        end)
    end

    do
        local row = mkRow(44)
        row.Size = UDim2.new(1, -8, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        delBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(210, 210, 214)
        delBtn.Font = Enum.Font.FredokaOne
        delBtn.TextSize = 12
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(0, 0, 0)
        delStroke.Thickness = 1.2
        applyShimmerToText(delBtn, 0.6)

        local deleteState=0
        local originalDeleteText="DELETE SETTINGS"
        delBtn.Activated:Connect(function()
            if deleteState==0 then
                deleteState=1
                delBtn.Text="CONFIRM?"
                delBtn.BackgroundColor3=Color3.fromRGB(90, 90, 94)
                delBtn.TextColor3=Color3.fromRGB(255,255,255)
                task.delay(2,function()
                    if delBtn and delBtn.Parent and deleteState==1 then
                        deleteState=0
                        delBtn.Text=originalDeleteText
                        delBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
                        delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    end
                end)
            elseif deleteState==1 then
                local success=deleteAllSettings()
                if success then
                    delBtn.Text="DELETED ✓"
                    delBtn.BackgroundColor3=Color3.fromRGB(30,30,30)
                    delBtn.TextColor3=ACCENT
                    task.delay(1.5,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                else
                    delBtn.Text="NO FILE"
                    delBtn.BackgroundColor3=Color3.fromRGB(90, 90, 94)
                    delBtn.TextColor3=Color3.fromRGB(255,255,255)
                    task.delay(1.2,function()
                        if delBtn and delBtn.Parent then
                            deleteState=0
                            delBtn.Text=originalDeleteText
                            delBtn.BackgroundColor3=Color3.fromRGB(60,60,60)
                            delBtn.TextColor3=Color3.fromRGB(255,255,255)
                        end
                    end)
                end
            end
        end)
    end

    -- ====== KEYBINDS ======
    mkSect("Keybinds")

    local keyButtonRefs = {}

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 75, 0, 24)
        btn.Position = UDim2.new(1, -83, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        btn.BackgroundTransparency = 0.38
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = Color3.fromRGB(238, 238, 238)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(0, 0, 0)
        bs.Thickness = 1
        applyShimmerToText(btn, 0.7)
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=ACCENT; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = Color3.fromRGB(210, 210, 214)
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; btn.Text=pv; btn.TextColor3=ACCENT; return end
                local isGp = isGamepadInput(inp)
                if isGp and tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = ACCENT
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc=nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
            end)
        end)
        return btn
    end

    local function addKeybindRow(labelText, kbEntry)
        local row = mkRow(34)
        mkLabel(row, labelText)
        local btn = mkKeyButton(row, kbEntry)
        table.insert(keyButtonRefs, {btn=btn, entry=kbEntry})
    end

    addKeybindRow("Carry Mode", KB.CarryToggle)
    addKeybindRow("Lagger Mode", KB.LaggerMode)
    addKeybindRow("Auto Left", KB.AutoLeft)
    addKeybindRow("Auto Right", KB.AutoRight)
    addKeybindRow("Auto Bat", KB.AutoBat)
    addKeybindRow("Bypass Aimbot", KB.Bypass)
    addKeybindRow("TP Down", KB.TPFloor)
    addKeybindRow("Drop Brainrot", KB.DropBrainrot)

    local spacer = Instance.new("Frame", scrollPage)
    spacer.Size = UDim2.new(1, 0, 0, 20)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = 100
    spacer.Visible = true

    _G.keyButtonRefs = keyButtonRefs

    -- ============================================================
-- ============================================================
-- AUTO STEAL — BARRA DEL ÚLTIMO CHAPO
-- Diseño visual tomado de Últimoychapoesmiperra.txt.
do
    local BAR_BLACK = Color3.fromRGB(30, 30, 32)
    local BAR_ACCENT = Color3.fromRGB(180, 180, 190)
    local playerGui = LP:WaitForChild("PlayerGui")
    local oldStealBar = playerGui:FindFirstChild("StealBarGui")
    if oldStealBar then oldStealBar:Destroy() end
    local stealGui = Instance.new("ScreenGui")
    stealGui.Name = "StealBarGui"
    stealGui.ResetOnSpawn = false
    stealGui.IgnoreGuiInset = true
    stealGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    stealGui.Parent = playerGui

    pbFrame = Instance.new("Frame", stealGui)
    pbFrame.Size = UDim2.new(0, 280, 0, 34)
    pbFrame.Position = UDim2.new(0.5, -140, 1, -54)
    pbFrame.BackgroundColor3 = BAR_BLACK
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    -- La barra aparece desde la creación del GUI; luego el estado se actualiza normalmente.
    pbFrame.Visible = true
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(1, 0)
    local pbSt = Instance.new("UIStroke", pbFrame)
    pbSt.Color = BAR_ACCENT
    pbSt.Thickness = 1.2
    pbSt.Transparency = 0.2

    local fillRegion = Instance.new("Frame", pbFrame)
    fillRegion.Size = UDim2.new(0, 170, 1, -8)
    fillRegion.Position = UDim2.new(0, 5, 0, 4)
    fillRegion.BackgroundColor3 = BAR_BLACK
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
    local fillRegStroke = Instance.new("UIStroke", fillRegion)
    fillRegStroke.Color = BAR_ACCENT
    fillRegStroke.Thickness = 1
    fillRegStroke.Transparency = 0.6

    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = BAR_ACCENT
    progressFill.BorderSizePixel = 0
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160,160,160)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220,220,220)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160,160,160))
    })
    fillGrad.Rotation = 90
    task.spawn(function()
        local t=0
        while fillGrad and fillGrad.Parent do
            t = t + 0.03
            fillGrad.Offset = Vector2.new(math.sin(t * 0.6) * 0.2, 0)
            task.wait(0.04)
        end
    end)

    local stealLbl = Instance.new("TextLabel", fillRegion)
    stealLbl.Size = UDim2.new(0, 55, 1, 0)
    stealLbl.Position = UDim2.new(0, 8, 0, 0)
    stealLbl.BackgroundTransparency = 1
    stealLbl.Text = "STEAL"
    stealLbl.TextColor3 = Color3.fromRGB(55,55,60)
    stealLbl.Font = Enum.Font.GothamBlack
    stealLbl.TextSize = 10
    stealLbl.TextXAlignment = Enum.TextXAlignment.Left
    applyShimmerToText(stealLbl, 1.0)

    progressPct = Instance.new("TextLabel", fillRegion)
    progressPct.Size = UDim2.new(0, 45, 1, 0)
    progressPct.Position = UDim2.new(1, -52, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "—"
    progressPct.TextColor3 = Color3.fromRGB(55,55,60)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 9
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    applyShimmerToText(progressPct, 0.9)

    local pbDiv = Instance.new("Frame", pbFrame)
    pbDiv.Size = UDim2.new(0, 1, 0, 12)
    pbDiv.Position = UDim2.new(0, 182, 0.5, -6)
    pbDiv.BackgroundColor3 = BAR_ACCENT
    pbDiv.BackgroundTransparency = 0.7
    pbDiv.BorderSizePixel = 0

    progressRadLbl = Instance.new("TextLabel", pbFrame)
    progressRadLbl.Size = UDim2.new(0, 90, 1, 0)
    progressRadLbl.Position = UDim2.new(0, 186, 0, 0)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = "-- · --"
    progressRadLbl.TextColor3 = Color3.fromRGB(190,190,190)
    progressRadLbl.Font = Enum.Font.GothamBold
    progressRadLbl.TextSize = 9
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
    applyShimmerToText(progressRadLbl, 0.8)

    local function dragProgress(f)
        local dn,ds,sp,di = false

        local function progressBarLocked()
            -- La barra solo depende de Lock UI.
            -- Lock Buttons queda reservado para los botones flotantes.
            return uiLocked == true
        end

        f.InputBegan:Connect(function(i)
            if progressBarLocked() then
                dn = false
                return
            end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dn = true
                ds = i.Position
                sp = f.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dn = false end
                end)
            end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                di = i
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if progressBarLocked() then
                dn = false
                return
            end
            if i == di and dn then
                local nX = sp.X.Offset + (i.Position.X - ds.X)
                local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
                f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
            end
        end)
    end
    dragProgress(pbFrame)
end

-- ACTUALIZACIÓN EN TIEMPO REAL DEL ESTADO
RunService.RenderStepped:Connect(function()
    if not pbFrame or not pbFrame.Parent then return end
    if not Steal.AutoStealEnabled then
        progressFill.Size = UDim2.new(0,0,1,0)
        progressPct.Text = "IDLE"
        progressPct.TextColor3 = Color3.fromRGB(210,210,214)
        return
    end

    if Semi.state.active then
        local pct = math.clamp((tick() - Semi.state.startTime) / math.max(Semi.holdMax, 0.05), 0, 1)
        progressFill.Size = UDim2.new(pct,0,1,0)
        progressPct.Text = math.floor(pct * 100 + 0.5) .. "%"
        progressPct.TextColor3 = Color3.fromRGB(210, 210, 214)
    elseif Semi.state.lastResultTime > 0 and tick() - Semi.state.lastResultTime < 1.2 then
        progressFill.Size = UDim2.new(1,0,1,0)
        progressPct.Text = "100%"
        progressPct.TextColor3 = Color3.fromRGB(210,210,214)
    else
        progressFill.Size = UDim2.new(0,0,1,0)
        progressPct.Text = "—"
        progressPct.TextColor3 = Color3.fromRGB(210,210,214)
    end

    -- El rango no se muestra; este indicador queda reservado para FPS/ping.
end)

-- FPS Y PING EN LA MISMA BARRA
task.spawn(function()
    local lastFrame = tick()
    local fpsSamples = {}
    local fpsAvg = 60
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = now - lastFrame
        lastFrame = now
        if dt > 0 then
            table.insert(fpsSamples, 1 / dt)
            if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
            local sum = 0
            for _, v in ipairs(fpsSamples) do sum = sum + v end
            fpsAvg = sum / #fpsSamples
        end
    end)
    while true do
        local ping = 0
        pcall(function()
            ping = LP:GetNetworkPing() * 1000
        end)
        if progressRadLbl then
            progressRadLbl.Text = string.format("%dFPS · %dms", math.floor(fpsAvg + 0.5), math.floor(ping + 0.5))
        end
        task.wait(0.5)
    end
end)

    local function pointInsideVisiblePage(pos)
        for _, page in ipairs(pages) do
            if page.Visible then
                local pagePos = page.AbsolutePosition
                local pageSize = page.AbsoluteSize
                if pos.X >= pagePos.X and pos.X <= pagePos.X + pageSize.X
                    and pos.Y >= pagePos.Y and pos.Y <= pagePos.Y + pageSize.Y then
                    return true
                end
            end
        end
        return false
    end

    local function drag(f)
        local dn,ds,sp,di=false
        local groupedStarts = {}
        local groupedMoved = false
        local excludedGroupedButtons = {
            BatBypass = true, -- AIMBOT V2 / BAT V2
            TpBat = true,     -- ANTI DESYNC
        }
        local function beginGroupedDrag()
            groupedStarts = {}
            groupedMoved = false
            -- Con Lock UI desactivado y Edit Buttons desactivado,
            -- la GUI y los botones permitidos se desplazan juntos.
            if not floatingButtonsLocked then return end
            local refs = _G.__FROST_MOBILE_BUTTON_REFS or {}
            for name, btn in pairs(refs) do
                if btn and btn.Parent and not excludedGroupedButtons[name] then
                    groupedStarts[name] = btn.Position
                end
            end
        end
        local function moveGroupedButtons(delta)
            if not floatingButtonsLocked then return end
            for name, startPos in pairs(groupedStarts) do
                local btn = (_G.__FROST_MOBILE_BUTTON_REFS or {})[name]
                if btn and btn.Parent then
                    groupedMoved = true
                    btn.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + delta.X,
                        startPos.Y.Scale, startPos.Y.Offset + delta.Y
                    )
                end
            end
        end
        local function saveGroupedPositions()
            if not groupedMoved then return end
            local refs = _G.__FROST_MOBILE_BUTTON_REFS or {}
            for name, btn in pairs(refs) do
                if btn and btn.Parent and not excludedGroupedButtons[name] then
                    mobileButtonPositions[name] = {
                        XScale = btn.Position.X.Scale,
                        XOffset = btn.Position.X.Offset,
                        YScale = btn.Position.Y.Scale,
                        YOffset = btn.Position.Y.Offset,
                    }
                end
            end
            pcall(saveAllSettings)
        end
        f.InputBegan:Connect(function(i)
            if uiLocked then return end
            if (i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)
                and not pointInsideVisiblePage(i.Position) then
                dn=true; ds=i.Position; sp=f.Position
                beginGroupedDrag()
                i.Changed:Connect(function()
                    if i.UserInputState==Enum.UserInputState.End then
                        if dn then saveGroupedPositions() end
                        dn=false
                    end
                end)
            end
        end)
        f.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i==di and dn then
                if uiLocked then dn=false; return end
                local delta = i.Position - ds
                local nX=sp.X.Offset+delta.X
                local nY=sp.Y.Offset+delta.Y
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
                moveGroupedButtons(delta)
            end
        end)
    end
    -- La GUI se puede mover desde cualquier zona que no sea el ScrollingFrame.
    -- Dentro de Music y Keybinds el gesto queda reservado para desplazarse.
    drag(main)
end

local function updateUIFromLoaded()
    task.wait()
    -- buildGui() se ejecuta antes de loadAllSettings(); aplicar aquí la posición ya cargada.
    if pbFrame and type(savedProgressBarPos) == "table" then
        pbFrame.Position = UDim2.new(
            tonumber(savedProgressBarPos.XScale) or 0.5,
            tonumber(savedProgressBarPos.XOffset) or -140,
            tonumber(savedProgressBarPos.YScale) or 1,
            tonumber(savedProgressBarPos.YOffset) or -58
        )
    end
    if normalBox then normalBox.Text=tostring(NS) end
    if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end
    if stealDurationBox then stealDurationBox.Text=tostring(Steal.StealDuration) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text=tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if dropModeBtnRef then
        dropModeBtnRef.Text = dropMode == 1 and "V1" or "V2"
    end
    if tpModeSelectBtn then
        tpModeSelectBtn.Text = tpDownMode == 1 and "V1" or "V2"
    end
    if bypassModeBtnRef then
        bypassModeBtnRef.Text = bypassMode == 1 and "Bypass" or "TP Bat"
    end
    refreshSpeedModeLabel()
    if setLockUIVisual then setLockUIVisual(uiLocked == true) end
    if setLockButtonsVisual then setLockButtonsVisual(floatingButtonsLocked ~= true) end
    if antiRagdollEnabled and setAntiRagVisual then setAntiRagVisual(true); startAntiRagdoll() end
    if Steal.AutoStealEnabled and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if jumpEnabled then
        if setJumpVisual then setJumpVisual(true) end
        startJumpMode()
    else
        if setJumpVisual then setJumpVisual(false) end
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
        if setMedusaVisual then setMedusaVisual(false) end
        if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
        stopMedusaCounter()
        stopMedusaAutoReset()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if autoTPDownEnabled then if setAutoTPDownVisual then setAutoTPDownVisual(true) end; startAutoTPDown() end
    if autoBatEnabled and autoBatSetVisual then autoBatSetVisual(true); enableAutoBat() end
    if autoLeftEnabled and autoLeftSetVisual then autoLeftSetVisual(true) end
    if autoRightEnabled and autoRightSetVisual then autoRightSetVisual(true) end
    if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true); task.spawn(function() task.wait(0.5); startUnwalk() end) end
    if antiLagEnabled and setAntiLagVisual then enableAntiLag(); setAntiLagVisual(true) end

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
                btn.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
                btn.TextColor3 = Color3.fromRGB(10, 10, 11)
            else
                btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
                btn.TextColor3 = Color3.fromRGB(210, 210, 214)
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

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel==1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel==2) end

    updateProgressBarVisibility()
    startEnemySpeed()
end

local function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "LustHubMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local BTN_W, BTN_H = 60, 60
    local GAP_X, GAP_Y = 8, 18
    local PANEL_W = BTN_W * 2 + GAP_X
    local PANEL_H = BTN_H * 5 + GAP_Y * 4

    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -PANEL_W - 10, 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = false

    -- Apariencia idéntica a los botones flotantes de Chapo.
    local ACCENT = Color3.fromRGB(255, 255, 255)
    local INACTIVE_BG = Color3.fromRGB(0, 0, 0)
    local STROKE_COLOR = Color3.fromRGB(0, 0, 0)
    local ACTIVE_BG = Color3.fromRGB(210, 210, 214)
    local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)

    local buttons = {}
    local defaultPositions = {
        -- Columna extra a la izquierda:
        BatBypass = {-(BTN_W + GAP_X), 0},                    -- al lado de DROP
        TpBat     = {-(BTN_W + GAP_X), (BTN_H + GAP_Y) * 2}, -- debajo de RESET

        -- Layout original:
        DropBR    = {0, 0},
        AutoLeft  = {BTN_W + GAP_X, 0},
        AutoBat   = {0, BTN_H + GAP_Y},
        AutoRight = {BTN_W + GAP_X, BTN_H + GAP_Y},
        -- TP Down manual conserva su posición original.
        TpDown     = {0, (BTN_H + GAP_Y) * 2},
        Carry      = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 2},
        Lagger1      = {0, (BTN_H + GAP_Y) * 3},
        Lagger2      = {BTN_W + GAP_X, (BTN_H + GAP_Y) * 3},
    }

    local function readSavedPosition(name)
        local p = mobileButtonPositions and mobileButtonPositions[name]
        if type(p) == "table" then
            return UDim2.new(p.XScale or 0, p.XOffset or 0, p.YScale or 0, p.YOffset or 0)
        end
        local d = defaultPositions[name] or {0,0}
        return UDim2.new(0, d[1], 0, d[2])
    end

    local function saveButtonPosition(name, btn)
        mobileButtonPositions[name] = {
            XScale = btn.Position.X.Scale,
            XOffset = btn.Position.X.Offset,
            YScale = btn.Position.Y.Scale,
            YOffset = btn.Position.Y.Offset
        }
        pcall(saveAllSettings)
    end

    applyFloatingButtonScale = function(factor)
        floatingButtonScale = math.clamp(tonumber(factor) or 1.0, 0.5, 2.0)
        local scaledW = math.floor(BTN_W * floatingButtonScale)
        local scaledH = math.floor(BTN_H * floatingButtonScale)
        local scaledGapX = math.floor(GAP_X * floatingButtonScale)
        local scaledGapY = math.floor(GAP_Y * floatingButtonScale)
        container.Size = UDim2.new(0, scaledW * 2 + scaledGapX, 0, scaledH * 5 + scaledGapY * 4)
        for _, data in pairs(buttons) do
            if data and data.btn then
                data.btn.Size = UDim2.new(0, scaledW, 0, scaledH)
            end
        end
    end

    local function createButton(name, text, isToggle, callback)
        local btn = Instance.new("TextButton", container)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.Position = readSavedPosition(name)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn:SetAttribute("CipherFloatingButton", true)
        btn.Active = true
        btn.Selectable = true
        _G.__FROST_MOBILE_BUTTON_REFS[name] = btn
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Name = "RedOuterStroke"
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = STROKE_COLOR
        stroke.Thickness = 1
        stroke.Transparency = 1

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.TextWrapped = true
        label.Active = false
        applyShimmerToText(label, 0.7)

        local active = false
        local function setActive(state)
            active = state and true or false
            if active then
                btn.BackgroundColor3 = ACTIVE_BG
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                stroke.Color = ACTIVE_BG
                stroke.Transparency = 1
            else
                btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                stroke.Color = Color3.fromRGB(0, 0, 0)
                stroke.Transparency = 1
            end
        end

        local dragging = false
        local moved = false
        local dragStart = nil
        local startPos = nil
        local trackedInput = nil
        local threshold = 7

        btn.InputBegan:Connect(function(input)
            -- Lock Buttons bloquea el arrastre, pero permite activar el botón con un tap/click.
            -- Lock UI bloquea el arrastre, NO el tap/click.
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStart = input.Position
                startPos = btn.Position
                trackedInput = input
            end
        end)

        UIS.InputChanged:Connect(function(input)
            if floatingButtonsLocked then return end
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                if math.abs(delta.X) > threshold or math.abs(delta.Y) > threshold then moved = true end
                if moved then
                    btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end)

        local function finishDrag(input)
            if not dragging then return end
            if input and trackedInput and input.UserInputType ~= trackedInput.UserInputType and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return
            end
            dragging = false
            -- Lock Buttons bloquea exclusivamente el movimiento; el clic sigue funcionando.
            if floatingButtonsLocked then
                if callback then callback(setActive, active) end
            elseif moved then
                saveButtonPosition(name, btn)
            else
                if callback then callback(setActive, active) end
            end
            trackedInput = nil
            dragStart = nil
            startPos = nil
        end

        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                finishDrag(input)
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                finishDrag(input)
            end
        end)

        buttons[name] = {btn=btn, setActive=setActive, label=label}
        return setActive
    end

    mobSetDropBR = createButton("DropBR", "DROP\nBR", true, function(setActive)
        if autoBatEnabled then return end
        setActive(true)
        executeDropWithToggle(function(v)
            if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
        end)
        task.delay(0.3, function() setActive(false) end)
    end)

    mobSetAutoLeft = createButton("AutoLeft", "AUTO\nLEFT", true, function(setActive)
        autoLeftEnabled = not autoLeftEnabled
        setActive(autoLeftEnabled)
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    end)

    mobSetAutoBat = createButton("AutoBat", "BAT\nAIMBOT", true, function(setActive)
        if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
        setActive(autoBatEnabled)
    end)

    mobSetAutoRight = createButton("AutoRight", "AUTO\nRIGHT", true, function(setActive)
        autoRightEnabled = not autoRightEnabled
        setActive(autoRightEnabled)
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    end)

    mobSetTpDown = createButton("TpDown", "TP\nDOWN", true, function(setActive)
        executeTPDown()
        setActive(true)
        task.delay(0.25, function() setActive(false) end)
    end)

    mobSetCarry = createButton("Carry", "CARRY\nSPD", true, function(setActive)
        if not speedMode then
            speedMode = true
            laggerToggled = false
            laggerLevel = 0
            setActive(true)
        else
            speedMode = false
            setActive(false)
        end
        refreshSpeedModeLabel()
    end)

    mobSetLagger1 = createButton("Lagger1", "LAGGER\n1", true, function(setActive)
        if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
        if not laggerToggled or laggerLevel ~= 1 then
            laggerToggled = true
            laggerLevel = 1
            setActive(true)
            if buttons.Lagger2 then buttons.Lagger2.setActive(false) end
        else
            laggerToggled = false
            laggerLevel = 1
            setActive(false)
        end
        refreshSpeedModeLabel()
    end)

    mobSetLagger2 = createButton("Lagger2", "LAGGER\n2", true, function(setActive)
        if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
        if not laggerToggled or laggerLevel ~= 2 then
            laggerToggled = true
            laggerLevel = 2
            setActive(true)
            if buttons.Lagger1 then buttons.Lagger1.setActive(false) end
        else
            laggerToggled = false
            laggerLevel = 1
            setActive(false)
        end
        refreshSpeedModeLabel()
    end)

    createButton("BatBypass", "BAT\nV2", true, function(setActive)
        local turningOff = bypassToggled and bypassMode == 1
        if turningOff then
            toggleBypass(false)
        else
            if bypassToggled then toggleBypass(false) end
            bypassMode = 1
            toggleBypass(true)
        end
        if buttons.BatBypass then buttons.BatBypass.setActive(bypassToggled and bypassMode == 1) end
        if buttons.TpBat then buttons.TpBat.setActive(bypassToggled and bypassMode == 2) end
        pcall(saveAllSettings)
    end)

    createButton("TpBat", "ANTI\nDESYNC", true, function(setActive)
        local turningOff = bypassToggled and bypassMode == 2
        if turningOff then
            toggleBypass(false)
        else
            if bypassToggled then toggleBypass(false) end
            bypassMode = 2
            toggleBypass(true)
        end
        if buttons.BatBypass then buttons.BatBypass.setActive(bypassToggled and bypassMode == 1) end
        if buttons.TpBat then buttons.TpBat.setActive(bypassToggled and bypassMode == 2) end
        pcall(saveAllSettings)
    end)

    if buttons.AutoBat then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.TpDown then buttons.TpDown.setActive(false) end
    if buttons.Carry then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 then buttons.Lagger1.setActive(laggerToggled and laggerLevel == 1) end
    if buttons.Lagger2 then buttons.Lagger2.setActive(laggerToggled and laggerLevel == 2) end
    if buttons.BatBypass then buttons.BatBypass.setActive(bypassToggled and bypassMode==1) end
    if buttons.TpBat then buttons.TpBat.setActive(bypassToggled and bypassMode==2) end
    applyFloatingButtonScale(floatingButtonScale)

    -- Reset real y repetible: usa las referencias locales del panel.
    _G.__FROST_RESET_MOBILE_BUTTONS = function()
        for name, data in pairs(buttons) do
            local d = defaultPositions[name]
            if data and data.btn and data.btn.Parent and d then
                data.btn.Position = UDim2.new(0, d[1], 0, d[2])
            end
        end

        -- Limpiar posiciones guardadas sin reemplazar la tabla.
        for key in pairs(mobileButtonPositions) do
            mobileButtonPositions[key] = nil
        end
    end

    return panel
end



local function createBypassFloatingButton()
    local ACCENT = cipherThemeColor
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
    btnFrame.Size = UDim2.new(0, 48, 0, 48)
    btnFrame.Name = "Frame"
    if bypassFloatingPos then
        btnFrame.Position = UDim2.new(bypassFloatingPos.XScale or 1,
                                      bypassFloatingPos.XOffset or (-10 - 60),
                                      bypassFloatingPos.YScale or 0,
                                      bypassFloatingPos.YOffset or (294 + 10))
    else
        btnFrame.Position = UDim2.new(1, -10 - 60, 0, 294 + 10)
    end
   btnFrame.BackgroundColor3 = bypassToggled and Color3.fromRGB(210, 210, 214) or Color3.fromRGB(0, 0, 0)
    btnFrame:SetAttribute("CipherFloatingButton", true)
    btnFrame:SetAttribute("CipherActive", bypassToggled == true)
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 16)
    local btnStroke = Instance.new("UIStroke", btnFrame)
    btnStroke.Name = "RedOuterStroke"
    btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    btnStroke.Color = Color3.fromRGB(0, 0, 0)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 1
    btnStroke.LineJoinMode = Enum.LineJoinMode.Round

    local label = Instance.new("TextLabel", btnFrame)
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "ANTI\nDESYNC"
    label.TextColor3 = cipherThemeColor
    label:SetAttribute("CipherFloatingLabel", true)
    	label.Font = Enum.Font.GothamBold
	label.TextSize = 9
label.TextWrapped = true
label.ZIndex = 21
applyShimmerToText(label, 0.9)

    local function setActive(state)
        btnFrame:SetAttribute("CipherActive", state == true)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(210, 210, 214)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
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
        if floatingButtonsLocked then return end
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                hasMoved = true
            end
            if hasMoved then
                if not floatingButtonsLocked then
                    btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                else
                    dragging = false
                end
            end
        end
    end

    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setActive(not bypassToggled)
                    toggleBypass()
                elseif not floatingButtonsLocked and hasMoved then
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

buildGui()
if loadAllSettings() then
    updateUIFromLoaded()
end

MobilePanel = createMobilePanel()
if applyFloatingButtonScale then applyFloatingButtonScale(floatingButtonScale) end
applyCipherImage(CIPHER_IMAGE_OPTIONS[1].id)

-- bypassFloatingButton disabled: BAT BYPASS and TP BAT now live in the mobile panel

if LP.Character then
    task.wait(0.0)
    setupSpeedIndicator(LP.Character)
end

LP.CharacterAdded:Connect(function(char)
    local resumeAutoSteal = Steal.AutoStealEnabled
    stopAutoSteal()
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
            local spd
            if laggerToggled then
                spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
            else
                spd = speedMode and CS or NS
            end

            -- ====== SPEED UNPATCH (CRÍTICO) ======
            if hum.WalkSpeed ~= spd then
                hum.WalkSpeed = spd
            end
            -- ====================================

            if md.Magnitude > 0 then
                lastMoveDir = md
                hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
            elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
                local anyHeld = false
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then anyHeld = true; break end
                end
                if anyHeld then
                    hrp.Velocity = Vector3.new(lastMoveDir.X * spd, hrp.Velocity.Y, lastMoveDir.Z * spd)
                end
            end
        end

        if speedLabel then
            speedLabel.Text = string.format("Spd: %.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
        end
    end)

    setupSpeedIndicator(char)

    if autoBatEnabled then enableAutoBat() end
    if autoLeftEnabled then startAutoLeft() end
    if autoRightEnabled then startAutoRight() end
    if bypassToggled then toggleBypass(true) end
    if resumeAutoSteal then
        Steal.AutoStealEnabled = true
        pcall(startAutoSteal)
    end
    if jumpEnabled then startJumpMode() end
    if antiRagdollEnabled then startAntiRagdoll() end

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

    if currentAccessoryPack ~= "Off" then
        task.wait(0.3)
        applyAccessoryPack(currentAccessoryPack)
        if accSelectorLabel then accSelectorLabel.Text = currentAccessoryPack end
    end

    updateProgressBarVisibility()
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
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then
            startAutoLeft()
        else
            stopAutoLeft()
        end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
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
        return
    end
    if kbMatch(KB.Bypass, kc) then
        if bypassToggled and bypassMode == 1 then
            toggleBypass(false)
        else
            if bypassToggled then toggleBypass(false) end
            bypassMode = 1
            toggleBypass(true)
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
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
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