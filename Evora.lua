if _G.EvoraduelsRunning then return end _G.EvoraduelsRunning = true local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UIS = game:GetService("UserInputService") local TS = game:GetService("TweenService") local Lighting = game:GetService("Lighting") local HS = game:GetService("HttpService") local Stats = game:GetService("Stats") local ReplicatedStorage = game:GetService("ReplicatedStorage") local LP = Players.LocalPlayer local camera = workspace.CurrentCamera NS = 60 CS = 29 LAGGER_SPEED_1 = 20 LAGGER_SPEED_2 = 10 MEDUSA_COOLDOWN = 25 BAT_AIMBOT_SPEED = 58 BYPASS_AIMBOT_SPEED = 60 MOBILE_PANEL_WIDTH = 128 MOBILE_PANEL_HEIGHT = 294 CONFIG_FILE = "Evoraduels.json" BAT_V2_HIT_DIST = 4.5 _isDraggingButton = false speedMode = false autoCarryEnabled = false antiRagdollEnabled = false jumpEnabled = false laggerToggled = false laggerLevel = 1 medusaCounterEnabled = false batCounterEnabled = false unwalkEnabled = false autoLeftEnabled = false autoRightEnabled = false autoBatEnabled = false dropMode = 1 antiLagEnabled = false removeAccessoriesEnabled = false stretchEnabled = false stretchFOV = 120 medusaAutoResetEnabled = false uiLocked = true editModeEnabled = false uiScaleValue = 80 espEnabled = false fovSelectorVisible = false bodyLockEnabled = false bodyLockRange = 20 bodyLockRangeBox = nil _bodyLockConn = nil bodyLockSetVisual = nil _blSuppressCount = 0 _blWasEnabled = false _blRestoreTimer = nil _blSmoothRestore = false savedProgressBarPos = nil savedButtonPositions = {} savedMobilePanelPos = nil tpBatFloatingPos = nil batV2FloatingPos = nil neonWeatherEnabled = false _originalLighting = nil setNeonWeatherVisual = nil currentAnimPack = "Off" originalTryardAnims = nil tryardHeartbeatConn = nil animSelectorLabel = nil autoBatV2Enabled = false autoBatV2SwingEnabled = true autoBatV2HitCooldown = false AUTO_BAT_V2_SPEED = 60 AUTO_BAT_V2_DIST = 1.0 AUTO_BAT_V2_HEIGHT = 1.5 AUTO_BAT_V2_V_OFF = 0.0 AUTO_BAT_V2_HIT_DIST = 4.5 AUTO_BAT_V2_SWING_CD = 0.08 _batV2Conn = nil antiDropEnabled = true antiDieEnabled = false stealBarSize = 1.0 mobileButtonSize = 1.0 _avatarCurrentIndex = 1 KORBLOX_ASSET_ID = 139607718 local speedLinearVelocity = nil local speedAttachment = nil local speedConnection = nil local currentSpeedValue = NS local speedEnabled = false local lastPosition = nil local lastTime = nil local lagbackCooldown = 0 local ownershipTimer = 0 local CoreGui = game:GetService("CoreGui")

-- ═══════════════ RANA INF JUMP & MOBILE JUMP SYSTEM ═══════════════
_G.ZurchiInfJumpState = _G.ZurchiInfJumpState or { enabled = false, mode = "normal" }
local InfJumpState = _G.ZurchiInfJumpState

local _lastJumpApplyTime = 0
local function applyRanaJump()
    local now = os.clock()
    if now - _lastJumpApplyTime < 0.22 then return end
    _lastJumpApplyTime = now

    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
end

-- Normal mode: triggers on jump request (Roblox mobile jump button naturally fires this)
UIS.JumpRequest:Connect(function()
    if not InfJumpState.enabled then return end
    if InfJumpState.mode == "normal" or InfJumpState.mode == "tap" then
        applyRanaJump()
    end
end)

-- Hold mode: continuous impulse when jump is held
RunService.Heartbeat:Connect(function()
    if not InfJumpState.enabled or InfJumpState.mode ~= "hold" then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and hum and hum.Health > 0 and hum.Jump then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

local _lastMobileJump = 0
local function _performMobileJump()
    local now = os.clock()
    if now - _lastMobileJump < 0.25 then return end
    _lastMobileJump = now

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    if InfJumpState.enabled then
        applyRanaJump()
    else
        hum.Jump = true
    end
end

local _jumpButtonConnections = {}
local function _bindButtonObj(obj)
    if not obj or not obj:IsA("GuiButton") then return end
    pcall(function()
        obj.Active = true
        obj.Selectable = true
        obj.Interactable = true
        obj.ZIndex = 100
    end)
    -- Single event connection with debounce avoids double jump triggers on tap
    table.insert(_jumpButtonConnections, obj.Activated:Connect(_performMobileJump))
end

local function _bindTouchJump()
    for _, c in ipairs(_jumpButtonConnections) do pcall(function() c:Disconnect() end) end
    table.clear(_jumpButtonConnections)

    local roots = {}
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if pg then table.insert(roots, pg) end
    pcall(function()
        local cg = game:GetService("CoreGui")
        if cg then table.insert(roots, cg) end
    end)

    for _, root in ipairs(roots) do
        local touchGui = root:FindFirstChild("TouchGui")
        if touchGui then
            pcall(function() touchGui.DisplayOrder = 1000 end)
            for _, obj in ipairs(touchGui:GetDescendants()) do
                if obj:IsA("GuiButton") and (obj.Name == "JumpButton" or obj.Name:lower():find("jump")) then
                    _bindButtonObj(obj)
                end
            end
        end
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("GuiButton") and obj.Name == "JumpButton" then
                _bindButtonObj(obj)
            end
        end
    end
end

task.spawn(function()
    local pg = LP:WaitForChild("PlayerGui")
    task.wait(0.5)
    _bindTouchJump()
    pg.ChildAdded:Connect(function(child)
        if child.Name == "TouchGui" or child.Name:lower():find("touch") then
            task.wait(0.1)
            _bindTouchJump()
        end
    end)
    pcall(function()
        local cg = game:GetService("CoreGui")
        if cg then
            cg.ChildAdded:Connect(function(child)
                if child.Name == "TouchGui" or child.Name:lower():find("touch") then
                    task.wait(0.1)
                    _bindTouchJump()
                end
            end)
        end
    end)
end)

LP.CharacterAdded:Connect(function(char)
    task.defer(function()
        char:WaitForChild("Humanoid", 10)
        task.wait(0.5)
        _bindTouchJump()
    end)
end)

task.spawn(function()
    for _ = 1, 20 do
        _bindTouchJump()
        task.wait(0.25)
    end
end)

local function getCharParts() local char = LP.Character if not char then return nil, nil end local hum = char:FindFirstChildOfClass("Humanoid") local root = char:FindFirstChild("HumanoidRootPart") if not hum or not root then return nil, nil end return hum, root end local function claimOwnership(root) pcall(function() root:SetNetworkOwner(LP) end) end local function cleanupSpeedPhysics() if speedLinearVelocity then speedLinearVelocity:Destroy() speedLinearVelocity = nil end if speedAttachment then speedAttachment:Destroy() speedAttachment = nil end if speedConnection then speedConnection:Disconnect() speedConnection = nil end lastPosition = nil lastTime = nil speedEnabled = false end local function applySpeedWithLinearVelocity(spd) cleanupSpeedPhysics() if spd <= 0 then return end local hum, root = getCharParts() if not hum or not root then return end claimOwnership(root) speedAttachment = Instance.new("Attachment") speedAttachment.Name = "SpeedAttachment" speedAttachment.Parent = root speedLinearVelocity = Instance.new("LinearVelocity") speedLinearVelocity.Name = "SpeedLinearVelocity" speedLinearVelocity.Attachment0 = speedAttachment speedLinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World speedLinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane speedLinearVelocity.PrimaryTangentAxis = Vector3.new(1, 0, 0) speedLinearVelocity.SecondaryTangentAxis = Vector3.new(0, 0, 1) speedLinearVelocity.MaxForce = 100000 speedLinearVelocity.PlaneVelocity = Vector2.zero speedLinearVelocity.Enabled = false speedLinearVelocity.Parent = root lastPosition = root.Position lastTime = tick() speedEnabled = true currentSpeedValue = spd speedConnection = RunService.Heartbeat:Connect(function(dt) if not speedEnabled then return end local hum2, root2 = getCharParts() if not hum2 or not root2 or not speedLinearVelocity then cleanupSpeedPhysics() return end ownershipTimer = ownershipTimer + dt if ownershipTimer >= 1.5 then claimOwnership(root2) ownershipTimer = 0 end local dir = hum2.MoveDirection if dir.Magnitude < 0.1 then speedLinearVelocity.Enabled = false lastPosition = root2.Position lastTime = tick() return end speedLinearVelocity.Enabled = true speedLinearVelocity.PlaneVelocity = Vector2.new(dir.X * spd, dir.Z * spd) lagbackCooldown = lagbackCooldown - dt local now = tick() local elapsed = now - lastTime if elapsed > 0.1 and lastPosition then local expectedDist = spd * elapsed local actualDist = (root2.Position - lastPosition).Magnitude if actualDist < expectedDist * 0.3 and lagbackCooldown <= 0 then speedLinearVelocity.PlaneVelocity = Vector2.new(dir.X * spd * 1.2, dir.Z * spd * 1.2) lagbackCooldown = 0.3 end end lastPosition = root2.Position lastTime = now end) end

local ANIM_PACKS = { Tryhard = { idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563", walk = "rbxassetid://707897309", run = "rbxassetid://707861613", jump = "rbxassetid://116936326516985", fall = "rbxassetid://116936326516985", climb = "rbxassetid://116936326516985", swim = "rbxassetid://116936326516985", swimidle = "rbxassetid://116936326516985", }, Crazy = { idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563", walk = "rbxassetid://134824450619865", run = "rbxassetid://134824450619865", jump = "rbxassetid://121454505477205", fall = "rbxassetid://94788218468396", climb = "rbxassetid://121454505477205", swim = "rbxassetid://121454505477205", swimidle = "rbxassetid://121454505477205", } } local ANIM_PACK_ORDER = {{"Off", "Off"}, {"Tryhard", "Tryhard"}, {"Crazy", "Crazy"}} local function isPackAnim(id) for _, pack in pairs(ANIM_PACKS) do for _, v in pairs(pack) do if v == id then return true end end end return false end
local function saveOriginalAnims(char) local animate = char:FindFirstChild("Animate") if not animate then return end local function g(obj) return obj and obj.AnimationId or nil end local ids = { idle1 = g(animate.idle and animate.idle.Animation1), idle2 = g(animate.idle and animate.idle.Animation2), walk = g(animate.walk and animate.walk.WalkAnim), run = g(animate.run and animate.run.RunAnim), jump = g(animate.jump and animate.jump.JumpAnim), fall = g(animate.fall and animate.fall.FallAnim), climb = g(animate.climb and animate.climb.ClimbAnim), swim = g(animate.swim and animate.swim.Swim), swimidle = g(animate.swimidle and animate.swimidle.SwimIdle), } if not isPackAnim(ids.walk) then originalTryardAnims = ids end end
local function applyAnimPack(packName) currentAnimPack = packName if animSelectorLabel then animSelectorLabel.Text = packName end if packName == "Off" then if originalTryardAnims and LP.Character then local animate = LP.Character:FindFirstChild("Animate") if animate then local function s(obj,id) if obj then obj.AnimationId = id end end s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1) s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2) s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk) s(animate.run and animate.run.RunAnim, originalTryardAnims.run) s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump) s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall) s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb) s(animate.swim and animate.swim.Swim, originalTryardAnims.swim) s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle) end end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end return end local pack = ANIM_PACKS[packName] if not pack then return end if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end tryardHeartbeatConn = RunService.Heartbeat:Connect(function() local c = LP.Character if not c then return end local animate = c:FindFirstChild("Animate") if not animate then return end local function s(obj,id) if obj then obj.AnimationId = id end end s(animate.idle and animate.idle.Animation1, pack.idle1) s(animate.idle and animate.idle.Animation2, pack.idle2) s(animate.walk and animate.walk.WalkAnim, pack.walk) s(animate.run and animate.run.RunAnim, pack.run) s(animate.jump and animate.jump.JumpAnim, pack.jump) s(animate.fall and animate.fall.FallAnim, pack.fall) s(animate.climb and animate.climb.ClimbAnim, pack.climb) s(animate.swim and animate.swim.Swim, pack.swim) s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle) end) end
local function startAnimPack(packName) local char = LP.Character if char then saveOriginalAnims(char) applyAnimPack(packName) local hum = char:FindFirstChildOfClass("Humanoid") if hum then for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end hum:ChangeState(Enum.HumanoidStateType.Running) end else applyAnimPack(packName) end currentAnimPack = packName end
local function stopAnimPack() currentAnimPack = "Off" if animSelectorLabel then animSelectorLabel.Text = "Off" end applyAnimPack("Off") end

DEFAULT_KB = { DropBrainrot = {kb = Enum.KeyCode.X, gp = nil}, AutoLeft = {kb = Enum.KeyCode.Z, gp = nil}, AutoRight = {kb = Enum.KeyCode.C, gp = nil}, AutoBat = {kb = Enum.KeyCode.E, gp = nil}, TPFloor = {kb = Enum.KeyCode.F, gp = nil}, GuiHide = {kb = Enum.KeyCode.LeftControl, gp = nil}, CarryToggle = {kb = Enum.KeyCode.Q, gp = nil}, LaggerMode = {kb = Enum.KeyCode.R, gp = nil}, TPLock = {kb = Enum.KeyCode.B, gp = nil}, BatV2 = {kb = Enum.KeyCode.N, gp = nil}, AntiDie = {kb = Enum.KeyCode.V, gp = nil}, } KB = { DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp}, AutoLeft = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp}, AutoRight = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp}, AutoBat = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp}, TPFloor = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp}, GuiHide = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp}, CarryToggle = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp}, LaggerMode = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp}, TPLock = {kb = DEFAULT_KB.TPLock.kb, gp = DEFAULT_KB.TPLock.gp}, BatV2 = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp}, AntiDie = {kb = DEFAULT_KB.AntiDie.kb, gp = DEFAULT_KB.AntiDie.gp}, } _isResetting = false _lastSavedJSON = nil _isLoading = false

local AdaptSteal = { AutoStealEnabled = true, StealRadius = 60, StealDuration = 1.3, Mode = "normal", Data = {}, }
local STEAL_MODE_CFG = { normal = { threshold = 0.90, nearDist = 14 }, ["73"] = { threshold = 0.73, nearDist = 9 } }
local isStealingAdapt = false local stealConnAdapt = nil local getconnections = getconnections or (getgenv and getgenv().getconnections)
local function getStealHRP() local c = LP.Character return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")) end
local function isMyPlotByName(plotName) local plots = workspace:FindFirstChild("Plots") local plot = plots and plots:FindFirstChild(plotName) if not plot then return false end local sign = plot:FindFirstChild("PlotSign") local yb = sign and sign:FindFirstChild("YourBase") return yb and yb:IsA("BillboardGui") and yb.Enabled end
local function getPromptPosition(prompt) if not prompt then return nil end local p = prompt.Parent while p and p ~= workspace do if p:IsA("BasePart") then return p.Position end p = p.Parent end return nil end
local function findNearestPrompt() local hrp = getStealHRP() if not hrp then return nil end local plots = workspace:FindFirstChild("Plots") if not plots then return nil end local nearest, dist = nil, math.huge for _, plot in ipairs(plots:GetChildren()) do if isMyPlotByName(plot.Name) then continue end local pods = plot:FindFirstChild("AnimalPodiums") if not pods then continue end for _, pod in ipairs(pods:GetChildren()) do local base = pod:FindFirstChild("Base") if not base then continue end local spawn = base:FindFirstChild("Spawn") if not spawn then continue end local d = (spawn.Position - hrp.Position).Magnitude if d <= AdaptSteal.StealRadius and d < dist then local att = spawn:FindFirstChild("PromptAttachment") if att then for _, p in ipairs(att:GetChildren()) do if p:IsA("ProximityPrompt") and p.ActionText and p.ActionText:find("Steal") then nearest, dist = p, d end end end end end end return nearest end
local function setAdaptBar(p)
    p = math.clamp(p or 0, 0, 1)
    if progressFill then
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        local fillWidth = math.max(p, 0.02)
        TS:Create(progressFill, TweenInfo.new(0.08, Enum.EasingStyle.Linear), { Size = UDim2.new(fillWidth, 0, 1, 0) }):Play()
    end
    if progressShadow then
        TS:Create(progressShadow, TweenInfo.new(0.08, Enum.EasingStyle.Linear), { Size = UDim2.new(math.max(p, 0.02), 0, 1, 0) }):Play()
    end
    if progressPct then
        progressPct.Text = math.floor(p * 100) .. "%"
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end
local function executeAdaptSteal(prompt) if isStealingAdapt or not AdaptSteal.AutoStealEnabled then return end if not AdaptSteal.Data[prompt] then AdaptSteal.Data[prompt] = { hold = {}, trigger = {}, ready = true } if getconnections then for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan) or {}) do if c.Function then table.insert(AdaptSteal.Data[prompt].hold, c.Function) end end for _, c in ipairs(getconnections(prompt.Triggered) or {}) do if c.Function then table.insert(AdaptSteal.Data[prompt].trigger, c.Function) end end end end local data = AdaptSteal.Data[prompt] if not data.ready then return end data.ready = false isStealingAdapt = true task.spawn(function() for _, f in ipairs(data.hold) do pcall(f) end end) local cfg = STEAL_MODE_CFG[AdaptSteal.Mode] or STEAL_MODE_CFG.normal local threshold = cfg.threshold local nearDist = cfg.nearDist local totalTime = tonumber(AdaptSteal.StealDuration) or 1.3 local timeToThreshold = totalTime * threshold local timeAfterThreshold = totalTime - timeToThreshold local startTime = tick() while tick() - startTime < timeToThreshold do if not AdaptSteal.AutoStealEnabled then isStealingAdapt = false; data.ready = true; setAdaptBar(0); return end setAdaptBar(math.clamp((tick() - startTime) / totalTime, 0, threshold)) task.wait() end setAdaptBar(threshold) local stillNear = false local hrp = getStealHRP() if hrp then local targetPos = getPromptPosition(prompt) if targetPos and (targetPos - hrp.Position).Magnitude <= nearDist then stillNear = true end end if not stillNear then local holdStart = tick() while tick() - holdStart < 4 do if not AdaptSteal.AutoStealEnabled then isStealingAdapt = false; data.ready = true; setAdaptBar(0); return end setAdaptBar(threshold) local hrp2 = getStealHRP() if hrp2 then local tp = getPromptPosition(prompt) if tp and (tp - hrp2.Position).Magnitude <= nearDist then stillNear = true; break end end task.wait() end if not stillNear then isStealingAdapt = false; data.ready = true; setAdaptBar(0); return end end local resumeTime = tick() while tick() - resumeTime < timeAfterThreshold do if not AdaptSteal.AutoStealEnabled then isStealingAdapt = false; data.ready = true; setAdaptBar(0); return end local fin = (tick() - resumeTime) / math.max(timeAfterThreshold, 0.01) setAdaptBar(threshold + fin * (1 - threshold)) task.wait() end setAdaptBar(1) for _, f in ipairs(data.trigger) do pcall(f) end task.wait(0.05) data.ready = true isStealingAdapt = false setAdaptBar(0) end
function startAutoSteal() AdaptSteal.AutoStealEnabled = true if stealConnAdapt then return end stealConnAdapt = RunService.Heartbeat:Connect(function() if isStealingAdapt or not AdaptSteal.AutoStealEnabled then return end local ok, prompt = pcall(findNearestPrompt) if ok and prompt then pcall(executeAdaptSteal, prompt) end end) end
function stopAutoSteal() AdaptSteal.AutoStealEnabled = false if stealConnAdapt then stealConnAdapt:Disconnect(); stealConnAdapt = nil end isStealingAdapt = false setAdaptBar(0) end
local _antiDropActive = false local _antiDropMt = getrawmetatable and getrawmetatable(game) or nil local _antiDropOldIdx, _antiDropOldNewIdx local _antiDropSpoofedVel = Vector3.zero
local function startAntiDrop() if _antiDropActive then return end if not _antiDropMt then return end _antiDropOldIdx = _antiDropMt.__index _antiDropOldNewIdx = _antiDropMt.__newindex setreadonly(_antiDropMt, false) _antiDropMt.__index = newcclosure(function(self, key) if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LP.Character) then return _antiDropSpoofedVel end return _antiDropOldIdx(self, key) end) _antiDropMt.__newindex = newcclosure(function(self, key, value) if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and self:IsDescendantOf(LP.Character) then _antiDropSpoofedVel = value return end return _antiDropOldNewIdx(self, key, value) end) setreadonly(_antiDropMt, true) _antiDropActive = true end
local function stopAntiDrop() if not _antiDropActive then return end if _antiDropMt and _antiDropOldIdx then setreadonly(_antiDropMt, false) _antiDropMt.__index = _antiDropOldIdx _antiDropMt.__newindex = _antiDropOldNewIdx setreadonly(_antiDropMt, true) _antiDropOldIdx = nil _antiDropOldNewIdx = nil end _antiDropActive = false end
function toggleAntiDrop(on) if on then startAntiDrop() else stopAntiDrop() end saveAllSettings() end
local _antiDieHeartConn = nil local _antiDieDeathConns = {} local _antiDieCharAddedConn = nil
local function _antiDieProtectChar(char) if not char then return end local hum = char:WaitForChild("Humanoid", 5) if not hum then return end hum.MaxHealth = math.huge hum.Health = math.huge local sc = hum.StateChanged:Connect(function(_, new) if not antiDieEnabled then return end if new == Enum.HumanoidStateType.Dead then hum.Health = math.huge hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end end) table.insert(_antiDieDeathConns, sc) hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) local hc = hum:GetPropertyChangedSignal("Health"):Connect(function() if not antiDieEnabled then return end if hum.Health < hum.MaxHealth then hum.Health = math.huge end end) table.insert(_antiDieDeathConns, hc) if _antiDieHeartConn then _antiDieHeartConn:Disconnect() end _antiDieHeartConn = RunService.Heartbeat:Connect(function() if not antiDieEnabled then return end if hum and hum.Parent and hum.Health < hum.MaxHealth then hum.Health = math.huge end end) end
function startAntiDie() for _, c in ipairs(_antiDieDeathConns) do pcall(function() c:Disconnect() end) end _antiDieDeathConns = {} if _antiDieHeartConn then _antiDieHeartConn:Disconnect(); _antiDieHeartConn = nil end if _antiDieCharAddedConn then _antiDieCharAddedConn:Disconnect(); _antiDieCharAddedConn = nil end _antiDieProtectChar(LP.Character) _antiDieCharAddedConn = LP.CharacterAdded:Connect(function(c) if not antiDieEnabled then return end task.wait(0.1) for _, c2 in ipairs(_antiDieDeathConns) do pcall(function() c2:Disconnect() end) end _antiDieDeathConns = {} _antiDieProtectChar(c) end) end
function stopAntiDie() for _, c in ipairs(_antiDieDeathConns) do pcall(function() c:Disconnect() end) end _antiDieDeathConns = {} if _antiDieHeartConn then _antiDieHeartConn:Disconnect(); _antiDieHeartConn = nil end if _antiDieCharAddedConn then _antiDieCharAddedConn:Disconnect(); _antiDieCharAddedConn = nil end local char = LP.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) hum.MaxHealth = 100 hum.Health = 100 end end end
function toggleAntiDie(on) antiDieEnabled = on if on then startAntiDie() else stopAntiDie() end saveAllSettings() end

CONFIG = { AUTO_STEAL_ENABLED = false, HOLD_MIN = 1.3, HOLD_MAX = 2.6, ENTRY_DELAY = 0.3, COOLDOWN = 0.05, STEAL_RANGE = 9, PRIME_RANGE = 80, } StealState = { active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0, totalSteals = 0, failedSteals = 0, } savedStealRadius = CONFIG.STEAL_RANGE savedStealDuration = CONFIG.HOLD_MAX
medusaDebounce = false medusaLastUsed = 0 dropActive = false lastDropTime = 0 lastMoveDir = Vector3.new(0,0,0) origFOV = 70 autoResetStates = { BALLOON = false, JAIL = false, TINY = false, RAGDOLL = false, ROCKET = false } _anyKeyListening = false _aimbotConn = nil _prevAutoRotate = nil tpLockEnabled = false tpLockSetVisual = nil tpLockConn = nil tpLockPrevAutoRotate = nil tpLockHitCD = false TP_LOCK_SWING_CD = 0.08 tpBatFloatingButton = nil batV2FloatingButton = nil enemySpeedConn = nil movementLoop = nil steppedConn = nil alConn = nil arConn = nil infJumpConn = nil stretchConn = nil stretchFovConn = nil antiLagDescConn = nil medusaResetConns = {} dropConnections = {} enemySpeedLabels = {} Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil} keyButtonRefs = {} progressFill = nil progressPct = nil progressRadLbl = nil progressShadow = nil pbFrame = nil speedLabel = nil modeValLbl = nil normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil modeSelectBtn, dropModeBtnRef = nil, nil setJumpToggleState = nil autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual, setMedusaAutoResetVisual = nil, nil, nil, nil, nil, nil setAntiRagVisual, setJumpVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab, setAntiDieVisual, setInfJumpVisual = nil, nil, nil, nil, nil, nil, nil, nil setEditModeVisual = nil setESPVIsual = nil mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil autoBatV2SetVisual = nil miniBtn, main, gui = nil, nil, nil MobilePanel = nil showGui = nil hideGui = nil mainUIScale = nil animSelectorLabel = nil pbScale = nil fovToggleBtn = nil fovContainer = nil GAMEPAD_KEYS = { [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true, [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true, [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true, [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true, [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true, [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true, [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true, [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true, } MOVE_KEYS = { [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true, [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true, } BAT_COUNTER_SLAP_LIST = { "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap" } AP = { L1 = Vector3.new(-476.48, -6.28, 92.73), L2 = Vector3.new(-483.12, -4.95, 94.80), L_FACE = Vector3.new(-482.25, -4.96, 92.09), R1 = Vector3.new(-476.16, -6.52, 25.62), R2 = Vector3.new(-483.06, -5.03, 25.48), R_FACE = Vector3.new(-482.06, -6.93, 35.47), } function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil end function isBindableInput(inp) if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end if inp.UserInputType == Enum.UserInputType.Keyboard then return true end return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true end function kbMatch(entry, kc) return kc and (kc == entry.kb or (entry.gp and kc == entry.gp)) end function resetProgressBar() if progressPct then progressPct.Text = "0%" end if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end end local function doTpDown() pcall(function() local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if not root then return end root.CFrame = CFrame.new( root.Position.X, -7, root.Position.Z ) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0) root.Velocity = Vector3.zero end) end local AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0, } local function startAntiRagdoll() if AntiRagdollV2.Connection then return end AntiRagdollV2.Enabled = true AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function() if not AntiRagdollV2.Enabled then return end local char = LP.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") local root = char:FindFirstChild("HumanoidRootPart") if not hum or not root then return end if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end local state = hum:GetState() local now = tick() if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then if now - AntiRagdollV2.ResetCooldown > 0.15 then AntiRagdollV2.ResetCooldown = now pcall(function() if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end hum:ChangeState(Enum.HumanoidStateType.GettingUp) root.Velocity = Vector3.zero root.RotVelocity = Vector3.zero root.AssemblyLinearVelocity = Vector3.zero root.AssemblyAngularVelocity = Vector3.zero for _, obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") then obj.Enabled = true end if obj:IsA("Constraint") then obj.Enabled = true end end workspace.CurrentCamera.CameraSubject = hum local PM = LP.PlayerScripts:FindFirstChild("PlayerModule") if PM then local CM = require(PM:FindFirstChild("ControlModule")) if CM then CM:Enable() end end hum.AutoRotate = true hum.PlatformStand = false hum.Sit = false end) end end end) end local function stopAntiRagdoll() AntiRagdollV2.Enabled = false if AntiRagdollV2.Connection then AntiRagdollV2.Connection:Disconnect() AntiRagdollV2.Connection = nil end AntiRagdollV2.ResetCooldown = 0 end local function setAntiRag(on) antiRagdollEnabled = on if on then startAntiRagdoll() else stopAntiRagdoll() end if setAntiRagVisual then setAntiRagVisual(on) end end
do local _ragCountdownRunning = false local function _getRagBillboard() local char = LP.Character if not char then return nil, nil end local head = char:FindFirstChild("Head") if not head then return nil, nil end local pGui = LP.PlayerGui local existing = pGui:FindFirstChild("RagCountdownBillboard") if existing then existing:Destroy() end local bb = Instance.new("BillboardGui") bb.Name = "RagCountdownBillboard" bb.Size = UDim2.new(0, 84, 0, 42) bb.StudsOffset = Vector3.new(0, 4.5, 0) bb.AlwaysOnTop = true bb.Adornee = head bb.Parent = pGui local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, 0, 1, 0) lbl.AnchorPoint = Vector2.new(0.5, 0.5) lbl.Position = UDim2.new(0.5, 0, 0.5, 0) lbl.BackgroundTransparency = 1 lbl.Font = Enum.Font.GothamBlack lbl.TextScaled = true lbl.TextColor3 = Color3.fromRGB(180, 180, 180) lbl.TextStrokeColor3 = Color3.fromRGB(255, 182, 213) lbl.TextStrokeTransparency = 0 lbl.Text = "" lbl.Parent = bb return bb, lbl end local function _ragPunch(lbl, text) if not (lbl and lbl.Parent) then return end lbl.Text = text end local function _startRagCountdown() if _ragCountdownRunning then return end _ragCountdownRunning = true task.spawn(function() local bb, lbl = _getRagBillboard() if not bb then _ragCountdownRunning = false; return end local timeLeft = 2.5 local step = 0.1 while timeLeft > 0 and bb.Parent do _ragPunch(lbl, string.format("%.1f", timeLeft)) task.wait(step) timeLeft = timeLeft - step end if bb and bb.Parent then _ragPunch(lbl, "READY!") task.wait(0.5) if bb and bb.Parent then bb:Destroy() end end _ragCountdownRunning = false end) end local _wasRagdolled = false RunService.Heartbeat:Connect(function() local char = LP.Character if not char then _wasRagdolled = false; return end local hum = char:FindFirstChildOfClass("Humanoid") if not hum or hum.Health <= 0 then _wasRagdolled = false; return end local st = hum:GetState() local inRag = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown if inRag and not _wasRagdolled then _wasRagdolled = true _startRagCountdown() elseif not inRag then _wasRagdolled = false end end) end
local function setupChar(char) if antiRagdollEnabled then task.wait(0.5) startAntiRagdoll() end antiDropEnabled = true startAntiDrop() if antiDieEnabled then task.defer(function() startAntiDie() end) end end
LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

local espHighlightCache = {} local espBillboardCache = {} local espTracerCache = {} local espConn = nil local _espLastRun = 0 profileImageCache = {}
local function clearESP() for plr in pairs(espHighlightCache) do pcall(function() espHighlightCache[plr]:Destroy() end) end for plr in pairs(espBillboardCache) do pcall(function() espBillboardCache[plr]:Destroy() end) end for plr in pairs(espTracerCache) do for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false; ln:Remove() end) end end espHighlightCache = {} espBillboardCache = {} espTracerCache = {} end
local function makeESPTracers() if not (Drawing and type(Drawing.new) == "function") then return nil end local GREY = Color3.fromRGB(180, 180, 180) local outer = Drawing.new("Line") outer.Color = GREY outer.Thickness = 2.2 outer.Transparency = 0.90 outer.Visible = false local mid = Drawing.new("Line") mid.Color = GREY mid.Thickness = 1.2 mid.Transparency = 0.74 mid.Visible = false local core = Drawing.new("Line") core.Color = GREY core.Thickness = 0.6 core.Transparency = 0.10 core.Visible = false return {outer, mid, core} end
local function updateESP() local now = tick() if now - _espLastRun < 0.03 then return end _espLastRun = now if not espEnabled then clearESP(); return end local myChar = LP.Character local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart") if not myRoot then return end local myPos = myRoot.Position local myScreenPos, myOnScreen = camera:WorldToViewportPoint(myPos) local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y) local currentPlayers = Players:GetPlayers() local plrSet = {} for _, p in ipairs(currentPlayers) do plrSet[p] = true end for plr in pairs(espHighlightCache) do if not plrSet[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) espHighlightCache[plr] = nil end end for plr in pairs(espBillboardCache) do if not plrSet[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) espBillboardCache[plr] = nil end end for plr in pairs(espTracerCache) do if not plrSet[plr] then for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false; ln:Remove() end) end espTracerCache[plr] = nil end end for _, plr in ipairs(currentPlayers) do if plr == LP then continue end local char = plr.Character if not char then if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) espHighlightCache[plr] = nil end if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) espBillboardCache[plr] = nil end if espTracerCache[plr] then for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false end) end end continue end local tRoot = char:FindFirstChild("HumanoidRootPart") local tHead = char:FindFirstChild("Head") local tHum = char:FindFirstChildOfClass("Humanoid") local alive = tRoot and tHead and tHum and tHum.Health > 0 if alive then local hl = espHighlightCache[plr] if not hl or not hl.Parent or hl.Parent ~= char then if hl then pcall(function() hl:Destroy() end) end hl = Instance.new("Highlight") hl.Name = "EvoraduelsESP" hl.FillColor = Color3.fromRGB(180, 180, 180) hl.FillTransparency = 0.72 hl.OutlineColor = Color3.fromRGB(180, 180, 180) hl.OutlineTransparency = 0.05 hl.Adornee = char hl.Parent = char espHighlightCache[plr] = hl end local bb = espBillboardCache[plr] if not bb or not bb.Parent then if bb then pcall(function() bb:Destroy() end) end bb = Instance.new("BillboardGui") bb.Name = "ProfilePic" bb.Size = UDim2.new(0, 56, 0, 56) bb.StudsOffset = Vector3.new(0, 3.8, 0) bb.Adornee = tHead bb.AlwaysOnTop = true bb.Parent = tHead local img = Instance.new("ImageLabel", bb) img.Size = UDim2.new(1, -6, 1, -6) img.Position = UDim2.new(0, 3, 0, 3) img.BackgroundTransparency = 1 img.Image = "rbxassetid://0" img.ScaleType = Enum.ScaleType.Fit local circle = Instance.new("UICorner", img) circle.CornerRadius = UDim.new(1, 0) local stroke = Instance.new("UIStroke", img) stroke.Color = Color3.fromRGB(180, 180, 180) stroke.Thickness = 1.5 espBillboardCache[plr] = bb task.spawn(function() local userId = plr.UserId local url = profileImageCache[userId] if not url then local success, u = pcall(function() return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) if success and u and u ~= "" then url = u profileImageCache[userId] = url else url = "rbxassetid://0" end end if img then img.Image = url end end) else if bb.Adornee ~= tHead then bb.Adornee = tHead end bb.Enabled = true end local lines = espTracerCache[plr] if not lines then lines = makeESPTracers() espTracerCache[plr] = lines or {} end if lines and #lines > 0 then local destPos = tRoot.Position local pos, onScreen = camera:WorldToViewportPoint(destPos) if onScreen and pos.Z > 0 and myOnScreen then local tVec = Vector2.new(pos.X, pos.Y) for _, ln in ipairs(lines) do ln.From = myVec ln.To = tVec ln.Visible = true end else for _, ln in ipairs(lines) do ln.Visible = false end end end else if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) espHighlightCache[plr] = nil end if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) espBillboardCache[plr] = nil end if espTracerCache[plr] then for _, ln in ipairs(espTracerCache[plr]) do pcall(function() ln.Visible = false end) end end end end end
local function startESPLoop() if espConn then espConn:Disconnect() end espConn = RunService.RenderStepped:Connect(updateESP) end
local function stopESPLoop() if espConn then espConn:Disconnect(); espConn = nil end clearESP() end
function toggleESP(on) espEnabled = on if on then startESPLoop() else stopESPLoop() end if setESPVIsual then setESPVIsual(on) end end
function updateEnemySpeedLabels() for _, player in ipairs(Players:GetPlayers()) do if player ~= LP then local char = player.Character if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then local hrp = char:FindFirstChild("HumanoidRootPart") local velocity = hrp.AssemblyLinearVelocity local speed = (Vector3.new(velocity.X, 0, velocity.Z).Magnitude) local label = enemySpeedLabels[player] if not label then local head = char:FindFirstChild("Head") if head then local bb = Instance.new("BillboardGui", head) bb.Size = UDim2.new(0, 100, 0, 25) bb.StudsOffset = Vector3.new(0, 5.5, 0) bb.AlwaysOnTop = true bb.Name = "EnemySpeedGui" local textLabel = Instance.new("TextLabel", bb) textLabel.Size = UDim2.new(1, 0, 1, 0) textLabel.BackgroundTransparency = 1 textLabel.Text = string.format("%.1f", speed) textLabel.TextColor3 = Color3.fromRGB(180, 180, 180) textLabel.Font = Enum.Font.GothamBold textLabel.TextScaled = true textLabel.TextStrokeTransparency = 0 textLabel.TextStrokeColor3 = Color3.fromRGB(255, 182, 213) label = textLabel enemySpeedLabels[player] = label end elseif label and label.Parent and label.Parent.Parent ~= char then local head = char:FindFirstChild("Head") if head then label.Parent.Parent = head end end if label then label.Text = string.format("%.1f", speed) end else local label = enemySpeedLabels[player] if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end enemySpeedLabels[player] = nil end end end for player, label in pairs(enemySpeedLabels) do if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end enemySpeedLabels[player] = nil end end end
function startEnemySpeed() if enemySpeedConn then enemySpeedConn:Disconnect() end enemySpeedConn = RunService.Heartbeat:Connect(function() updateEnemySpeedLabels() end) end
function stopEnemySpeed() if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end end

local function getClosestTargetBody() local char = LP.Character if not char then return nil end local root = char:FindFirstChild("HumanoidRootPart") if not root then return nil end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart") local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local dist = (tRoot.Position - root.Position).Magnitude if dist < minDist then minDist = dist closest = tRoot end end end end return closest end
local function _bodyLockTick() local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local hum = char:FindFirstChildOfClass("Humanoid") if not hum then return end local target = getClosestTargetBody() if not target then if not hum.AutoRotate then hum.AutoRotate = true end return end local dist = (target.Position - root.Position).Magnitude if dist > bodyLockRange then if not hum.AutoRotate then hum.AutoRotate = true end return end if hum.AutoRotate then hum.AutoRotate = false end local targetVel = target.AssemblyLinearVelocity local speed3 = targetVel.Magnitude local predictTime = math.clamp(speed3 / 80, 0.08, 0.35) local predictedPos = target.Position + targetVel * predictTime local targetHead = target.Parent and target.Parent:FindFirstChild("Head") local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y local myHeight = root.Position.Y + (hum.HipHeight or 0) local heightDiff = targetHeight - myHeight local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5) local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z) local toPredict = flatTarget - root.Position if toPredict.Magnitude > 0.1 then local goalCF = CFrame.lookAt(root.Position, flatTarget) local diffCF = root.CFrame:Inverse() * goalCF local _, ry, _ = diffCF:ToEulerAnglesXYZ() ry = math.clamp(ry, -2.5, 2.5) root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0)) end end
function startBodyLock() if _bodyLockConn then _bodyLockConn:Disconnect() end _bodyLockConn = RunService.RenderStepped:Connect(function() if not bodyLockEnabled then return end if _blSuppressCount > 0 then return end _bodyLockTick() end) end
function stopBodyLock() if _bodyLockConn then _bodyLockConn:Disconnect() _bodyLockConn = nil end local c = LP.Character local root = c and c:FindFirstChild("HumanoidRootPart") if root then root.AssemblyAngularVelocity = Vector3.zero root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z) end local hum2 = c and c:FindFirstChildOfClass("Humanoid") if hum2 then hum2.AutoRotate = true end end
function _suppressBodyLock() _blSuppressCount = _blSuppressCount + 1 if _blSuppressCount == 1 and bodyLockEnabled then _blWasEnabled = true stopBodyLock() if bodyLockSetVisual then bodyLockSetVisual(false) end if _blRestoreTimer then task.cancel(_blRestoreTimer) _blRestoreTimer = nil end _blSmoothRestore = false end end
function _unsuppressBodyLock(delayed) if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end if _blSuppressCount == 0 and _blWasEnabled then _blWasEnabled = false local function restore() if bodyLockEnabled then _blSmoothRestore = true startBodyLock() if bodyLockSetVisual then bodyLockSetVisual(true) end task.delay(0.5, function() _blSmoothRestore = false end) end _blRestoreTimer = nil end if delayed then _blRestoreTimer = task.delay(1, restore) else restore() end end end

function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 182, 213)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 182, 213)),
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0, 0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new((math.sin(t * speed) + 1) * 0.5 - 0.5, 0)
            task.wait(0.04)
        end
    end)
    return grad
end
function applyBlackShimmerToText(obj, speed) return applyShimmerToText(obj, speed) end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("EvoraduelsSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "EvoraduelsSpeedIndicator"
    bb.Size = UDim2.new(0, 120, 0, 32)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Spd: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(255, 182, 213)
    applyShimmerToText(speedLabel, 1.0)
    local discordBB = head:FindFirstChild("DiscordText")
    if discordBB then discordBB:Destroy() end
    discordBB = Instance.new("BillboardGui", head)
    discordBB.Name = "DiscordText"
    discordBB.Size = UDim2.new(0, 200, 0, 28)
    discordBB.StudsOffset = Vector3.new(0, 5.2, 0)
    discordBB.AlwaysOnTop = true
    local discordLabel = Instance.new("TextLabel", discordBB)
    discordLabel.Size = UDim2.new(1, 0, 1, 0)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Evoraduels"
    discordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLabel.Font = Enum.Font.GothamBold
    discordLabel.TextScaled = true
    discordLabel.TextStrokeTransparency = 0
    discordLabel.TextStrokeColor3 = Color3.fromRGB(255, 182, 213)
    applyShimmerToText(discordLabel, 1.0)
end

function startUnwalk() local c = LP.Character if not c then return end local hum = c:FindFirstChildOfClass("Humanoid") if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end local anim = c:FindFirstChild("Animate") if anim then unwalkSavedAnimate = anim:Clone() anim:Destroy() end end
function stopUnwalk() local c = LP.Character if c then local existing = c:FindFirstChild("Animate") if not existing then local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts") local starterAnim = src and src:FindFirstChild("Animate") if starterAnim then starterAnim:Clone().Parent = c elseif unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c end end end unwalkSavedAnimate = nil end
function refreshSpeedModeLabel() if modeValLbl then if autoCarryEnabled then modeValLbl.Text = "Auto Carry" elseif laggerToggled then modeValLbl.Text = laggerLevel == 1 and "Lagger Spd 1" or "Lagger Spd 2" elseif speedMode then modeValLbl.Text = "Carry Mode" else modeValLbl.Text = "Normal" end end end
function resetMovementState() refreshSpeedModeLabel() if mobSetCarry then mobSetCarry(speedMode) end if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end end
function toggleCarryMode() if laggerToggled then laggerToggled = false laggerLevel = 1 speedMode = true else speedMode = not speedMode if speedMode then laggerToggled = false laggerLevel = 1 end end resetMovementState() end
function toggleLaggerCycle() if speedMode then speedMode = false if mobSetCarry then mobSetCarry(false) end end if not laggerToggled then laggerToggled = true laggerLevel = 1 else laggerLevel = (laggerLevel == 1) and 2 or 1 end resetMovementState() end
function stopAutoLeft() if alConn then alConn:Disconnect(); alConn = nil end alPhase = 1 local char = LP.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum:Move(Vector3.zero, false) end end if autoLeftSetVisual then autoLeftSetVisual(false) end if mobSetAutoLeft then mobSetAutoLeft(false) end _unsuppressBodyLock(true) end
function startAutoLeft() if autoRightEnabled then autoRightEnabled = false stopAutoRight() if autoRightSetVisual then autoRightSetVisual(false) end if mobSetAutoRight then mobSetAutoRight(false) end end disableAllAimbots() _suppressBodyLock() if alConn then alConn:Disconnect() end alPhase = 1 alConn = RunService.Heartbeat:Connect(function() if not autoLeftEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end local spd = NS if alPhase == 1 then local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z) if (tgt - root.Position).Magnitude < 1 then alPhase = 2 local d = AP.L2 - root.Position local mv = Vector3.new(d.X, 0, d.Z).Unit hum:Move(mv, false) root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd) return end local d = AP.L1 - root.Position local mv = Vector3.new(d.X, 0, d.Z).Unit hum:Move(mv, false) root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd) elseif alPhase == 2 then local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z) if (tgt - root.Position).Magnitude < 1 then hum:Move(Vector3.zero, false) root.AssemblyLinearVelocity = Vector3.zero autoLeftEnabled = false if alConn then alConn:Disconnect(); alConn = nil end alPhase = 1 if autoLeftSetVisual then autoLeftSetVisual(false) end if mobSetAutoLeft then mobSetAutoLeft(false) end _unsuppressBodyLock(true) local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z) if (facePos - root.Position).Magnitude > 0.01 then root.CFrame = CFrame.new(root.Position, facePos) end return end local d = AP.L2 - root.Position local mv = Vector3.new(d.X, 0, d.Z).Unit hum:Move(mv, false) root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd) end end) end
function stopAutoRight() if arConn then arConn:Disconnect(); arConn = nil end arPhase = 1 local char = LP.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then hum:Move(Vector3.zero, false) end end if autoRightSetVisual then autoRightSetVisual(false) end if mobSetAutoRight then mobSetAutoRight(false) end _unsuppressBodyLock(true) end
function startAutoRight() if autoLeftEnabled then autoLeftEnabled = false stopAutoLeft() if autoLeftSetVisual then autoLeftSetVisual(false) end if mobSetAutoLeft then mobSetAutoLeft(false) end end disableAllAimbots() _suppressBodyLock() if arConn then arConn:Disconnect() end arPhase = 1 arConn = RunService.Heartbeat:Connect(function() if not autoRightEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end local spd = NS if arPhase == 1 then local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z) if (tgt - root.Position).Magnitude < 1 then arPhase = 2 local d = AP.R2 - root.Position local mv = Vector3.new(d.X, 0, d.Z).Unit hum:Move(mv, false) root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd) return end local d = AP.R1 - root.Position local mv = Vector3.new(d.X, 0, d.Z).Unit hum:Move(mv, false) root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd) elseif arPhase == 2 then local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z) if (tgt - root.Position).Magnitude < 1 then hum:Move(Vector3.zero, false) root.AssemblyLinearVelocity = Vector3.zero autoRightEnabled = false if arConn then arConn:Disconnect(); arConn = nil end arPhase = 1 if autoRightSetVisual then autoRightSetVisual(false) end if mobSetAutoRight then mobSetAutoRight(false) end _unsuppressBodyLock(true) local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z) if (facePos - root.Position).Magnitude > 0.01 then root.CFrame = CFrame.new(root.Position, facePos) end return end local d = AP.R2 - root.Position local mv = Vector3.new(d.X, 0, d.Z).Unit hum:Move(mv, false) root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd) end end) end
function getClosestTarget() local char = LP.Character if not char then return nil end local root = char:FindFirstChild("HumanoidRootPart") if not root then return nil end local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart") local hum = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and hum and hum.Health > 0 then local dist = (tRoot.Position - root.Position).Magnitude if dist < minDist then minDist = dist closest = tRoot end end end end return closest end
function trySwing() pcall(function() local char = LP.Character if not char then return end local currentTool = char:FindFirstChildOfClass("Tool") if currentTool and not isBatTool(currentTool) then return end local bat = findBat() if bat then if bat.Parent ~= char then local hum = char:FindFirstChildOfClass("Humanoid") if hum then pcall(function() hum:EquipTool(bat) end) end end pcall(function() bat:Activate() end) end end) end
function stopAimbotAdapt() if _aimbotConn then pcall(function() _aimbotConn:Disconnect() end) _aimbotConn = nil end local char = LP.Character local root = char and char:FindFirstChild("HumanoidRootPart") local hum = char and char:FindFirstChildOfClass("Humanoid") if hum then hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate hum.PlatformStand = false pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end) end if root then root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0) root.AssemblyAngularVelocity = Vector3.zero end _prevAutoRotate = nil lastMoveDir = Vector3.zero _unsuppressBodyLock(true) end
function startAimbotAdapt() if _aimbotConn then return end _suppressBodyLock() local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum0 then if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end hum0.AutoRotate = false end _aimbotConn = RunService.RenderStepped:Connect(function() if not autoBatEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end if not char:FindFirstChildOfClass("Tool") then local bat = findBat() if bat then pcall(function() hum:EquipTool(bat) end) end end local target = getClosestTarget() if not target then return end local targetVel = target.AssemblyLinearVelocity local myPos = root.Position local targetPos = target.Position local predictPos = targetPos + targetVel * 0.14 predictPos = predictPos + target.CFrame.LookVector * 0.3 local direction = predictPos - myPos local flatDir = Vector3.new(direction.X, 0, direction.Z) if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = Vector3.new(0,0,0) end local desiredHeight = targetPos.Y + 3.7 local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8 if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end yVel = math.clamp(yVel, -70, 110) local desiredVel = Vector3.new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED) root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8) local speed3 = targetVel.Magnitude local predictTime = math.clamp(speed3 / 150, 0.05, 0.2) local predictedPos = targetPos + targetVel * predictTime local toPredict = predictedPos - myPos if toPredict.Magnitude > 0.1 then local goalCF = CFrame.lookAt(myPos, predictedPos) local diffCF = root.CFrame:Inverse() * goalCF local rx, ry, rz = diffCF:ToEulerAnglesXYZ() rx = math.clamp(rx, -2.5, 2.5) ry = math.clamp(ry, -2.5, 2.5) rz = math.clamp(rz, -2.5, 2.5) root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42)) end local distToTarget = (root.Position - target.Position).Magnitude if distToTarget <= 8 then trySwing() end end) end
function disableAutoBat() autoBatEnabled = false if autoBatSetVisual then autoBatSetVisual(false) end if mobSetAutoBat then mobSetAutoBat(false) end stopAimbotAdapt() end
function enableAutoBat() if autoLeftEnabled then autoLeftEnabled = false if autoLeftSetVisual then autoLeftSetVisual(false) end stopAutoLeft() end if autoRightEnabled then autoRightEnabled = false if autoRightSetVisual then autoRightSetVisual(false) end stopAutoRight() end if tpLockEnabled then toggleAntiDesyncAimbot() end if autoBatV2Enabled then disableBatV2() end autoBatEnabled = true if autoBatSetVisual then autoBatSetVisual(true) end if mobSetAutoBat then mobSetAutoBat(true) end startAimbotAdapt() end
local function findAnyToolV2() local c = LP.Character if c then for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end local bp = LP:FindFirstChildOfClass("Backpack") if bp then for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end return nil end
local function getClosestPlayerV2() local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") if not hrp then return nil, math.huge end local closest, bestDist = nil, math.huge for _, p in ipairs(Players:GetPlayers()) do if p ~= LP and p.Character then local tr = p.Character:FindFirstChild("HumanoidRootPart") local ph = p.Character:FindFirstChildOfClass("Humanoid") if tr and ph and ph.Health > 0 then local d = (hrp.Position - tr.Position).Magnitude if d < bestDist then bestDist = d; closest = p end end end end return closest, bestDist end
local function tryHitBatV2() if autoBatV2HitCooldown or not autoBatV2SwingEnabled then return end autoBatV2HitCooldown = true local char = LP.Character if char then local hum = char:FindFirstChildOfClass("Humanoid") local tool = findAnyToolV2() if tool then if tool.Parent ~= char and hum then pcall(function() hum:EquipTool(tool) end) end local remote = tool:FindFirstChildOfClass("RemoteEvent") if remote then pcall(function() remote:FireServer() end) else pcall(function() tool:Activate() end) end end end task.delay(AUTO_BAT_V2_SWING_CD, function() autoBatV2HitCooldown = false end) end
local function startBatV2Aimbot() if _batV2Conn then return end _batV2Conn = RunService.Heartbeat:Connect(function() if not autoBatV2Enabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") local hum = char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end local target, dist = getClosestPlayerV2() if target and target.Character then local targetRoot = target.Character:FindFirstChild("HumanoidRootPart") if targetRoot then local targetVel = targetRoot.AssemblyLinearVelocity or targetRoot.Velocity local moveDir = targetVel.Magnitude > 0.1 and targetVel.Unit or targetRoot.CFrame.LookVector local offset = moveDir * AUTO_BAT_V2_DIST + Vector3.new(0, AUTO_BAT_V2_HEIGHT + AUTO_BAT_V2_V_OFF, 0) local desiredPos = targetRoot.Position + offset local toTarget = desiredPos - root.Position if toTarget.Magnitude > 0.5 then local moveVec = toTarget.Unit * AUTO_BAT_V2_SPEED root.AssemblyLinearVelocity = Vector3.new(moveVec.X, moveVec.Y, moveVec.Z) else root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95 if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end end local distToTarget = (root.Position - targetRoot.Position).Magnitude if distToTarget <= AUTO_BAT_V2_HIT_DIST then tryHitBatV2() end end else root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9 if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end end end) end
local function stopBatV2Aimbot() if _batV2Conn then _batV2Conn:Disconnect() _batV2Conn = nil end local c = LP.Character local root = c and c:FindFirstChild("HumanoidRootPart") if root then root.AssemblyLinearVelocity = Vector3.zero end autoBatV2HitCooldown = false end
function enableBatV2() if autoBatV2Enabled then return end if autoBatEnabled then disableAutoBat() end if tpLockEnabled then toggleAntiDesyncAimbot() end if autoLeftEnabled then autoLeftEnabled = false stopAutoLeft() if autoLeftSetVisual then autoLeftSetVisual(false) end if mobSetAutoLeft then mobSetAutoLeft(false) end end if autoRightEnabled then autoRightEnabled = false stopAutoRight() if autoRightSetVisual then autoRightSetVisual(false) end if mobSetAutoRight then mobSetAutoRight(false) end end autoBatV2Enabled = true startBatV2Aimbot() if autoBatV2SetVisual then autoBatV2SetVisual(true) end if _G.updateBatV2MobileVisual then _G.updateBatV2MobileVisual() end end
function disableBatV2() if not autoBatV2Enabled then return end autoBatV2Enabled = false stopBatV2Aimbot() if autoBatV2SetVisual then autoBatV2SetVisual(false) end if _G.updateBatV2MobileVisual then _G.updateBatV2MobileVisual() end end
function toggleBatV2() if autoBatV2Enabled then disableBatV2() else enableBatV2() end end

_G.AceAntiDesync = _G.AceAntiDesync or { conn = nil, hittingCooldown = false, h = nil, hrp = nil } _G.AceAntiDesyncAimbotOn = false antiDesyncAutoSwingEnabled = true
local function getBatAntiDesync() local char = LP.Character if not char then return nil end for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do local tool = char:FindFirstChild(name) if tool and tool:IsA("Tool") then return tool end end local bp = LP:FindFirstChild("Backpack") if bp then for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do local tool = bp:FindFirstChild(name) if tool and tool:IsA("Tool") then local hum = char:FindFirstChildOfClass("Humanoid") if hum then pcall(function() hum:EquipTool(tool) end) end return tool end end end for _, child in ipairs(char:GetChildren()) do if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then return child end end return nil end
local function trySwingAntiDesync() if _G.AceAntiDesync.hittingCooldown then return end _G.AceAntiDesync.hittingCooldown = true pcall(function() local bat = getBatAntiDesync() if bat then if bat.Parent ~= LP.Character then local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") if hum then pcall(function() hum:EquipTool(bat) end) end end bat:Activate() local ev = bat:FindFirstChildWhichIsA("RemoteEvent") if ev then pcall(function() ev:FireServer() end) end end end) task.delay(0.08, function() if _G.AceAntiDesync then _G.AceAntiDesync.hittingCooldown = false end end) end
local function getClosestPlayerAntiDesync() local hrp = _G.AceAntiDesync and _G.AceAntiDesync.hrp if not hrp then return nil, math.huge end local closest, bestDist = nil, math.huge for _, p in ipairs(Players:GetPlayers()) do if p ~= LP and p.Character then local tr = p.Character:FindFirstChild("HumanoidRootPart") local ph = p.Character:FindFirstChildOfClass("Humanoid") if tr and ph and ph.Health > 0 then local d = (hrp.Position - tr.Position).Magnitude if d < bestDist then bestDist = d; closest = p end end end end return closest, bestDist end
local function setupCharAntiDesync(char) task.wait(0.1) if not _G.AceAntiDesync then return end _G.AceAntiDesync.h = char and char:FindFirstChildOfClass("Humanoid") or nil _G.AceAntiDesync.hrp = char and char:FindFirstChild("HumanoidRootPart") or nil end
function startAntiDesyncAimbot() if _G.AceSafeModeTryStart and not _G.AceSafeModeTryStart() then return false end if _G.AceStopAutoTPForAction then _G.AceStopAutoTPForAction() end if autoBatEnabled then disableAutoBat() end if autoBatV2Enabled then disableBatV2() end if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft() end if autoRightEnabled then autoRightEnabled = false; stopAutoRight() end _G.AceAntiDesyncAimbotOn = true if _G.AceAntiDesync.conn then _G.AceAntiDesync.conn:Disconnect() _G.AceAntiDesync.conn = nil end if LP.Character then pcall(function() setupCharAntiDesync(LP.Character) end) end _G.AceAntiDesync.conn = RunService.Heartbeat:Connect(function() if not (_G.AceAntiDesyncAimbotOn and _G.AceAntiDesync.h and _G.AceAntiDesync.hrp) then return end local target = getClosestPlayerAntiDesync() if target and target.Character then local tr = target.Character:FindFirstChild("HumanoidRootPart") if tr then if sethiddenproperty then pcall(function() sethiddenproperty(_G.AceAntiDesync.hrp, "PhysicsRepRootPart", tr) end) end local targetPos = tr.Position + Vector3.new(0, 0.9, 0) if (_G.AceAntiDesync.hrp.Position - targetPos).Magnitude > 8 then _G.AceAntiDesync.hrp.CFrame = CFrame.new(targetPos) end local cam = workspace.CurrentCamera if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end if antiDesyncAutoSwingEnabled then trySwingAntiDesync() end end end end) if tpLockSetVisual then tpLockSetVisual(true) end if _G.updateTPBatMobileVisual then _G.updateTPBatMobileVisual() end saveAllSettings() return true end
function stopAntiDesyncAimbot() _G.AceAntiDesyncAimbotOn = false if _G.AceAntiDesync and _G.AceAntiDesync.conn then _G.AceAntiDesync.conn:Disconnect() _G.AceAntiDesync.conn = nil end if _G.AceAntiDesync then _G.AceAntiDesync.hittingCooldown = false end if sethiddenproperty and _G.AceAntiDesync and _G.AceAntiDesync.hrp then pcall(function() sethiddenproperty(_G.AceAntiDesync.hrp, "PhysicsRepRootPart", nil) end) end local cam = workspace.CurrentCamera if cam and LP.Character then local hrp = LP.Character:FindFirstChild("HumanoidRootPart") if hrp then cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position) end end if tpLockSetVisual then tpLockSetVisual(false) end if _G.updateTPBatMobileVisual then _G.updateTPBatMobileVisual() end saveAllSettings() end
function toggleAntiDesyncAimbot() if _G.AceAntiDesyncAimbotOn then stopAntiDesyncAimbot() else startAntiDesyncAimbot() end end
tpLockEnabled = _G.AceAntiDesyncAimbotOn tpLockConn = _G.AceAntiDesync.conn toggleTPLock = toggleAntiDesyncAimbot startTPLock = startAntiDesyncAimbot stopTPLock = stopAntiDesyncAimbot
LP.CharacterAdded:Connect(function(char) pcall(function() setupCharAntiDesync(char) end) if _G.AceAntiDesyncAimbotOn then task.wait(0.5) if not _G.AceAntiDesync.conn then startAntiDesyncAimbot() end end end)
if LP.Character then task.spawn(function() pcall(function() setupCharAntiDesync(LP.Character) end) end) end
_G.AceAntiDesyncStart = startAntiDesyncAimbot _G.AceAntiDesyncStop = stopAntiDesyncAimbot _G.AceAntiDesyncToggle = toggleAntiDesyncAimbot

function findBat() local char = LP.Character if not char then return nil end for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do local t = char:FindFirstChild(name) if t and t:IsA("Tool") then return t end end local bp = LP:FindFirstChildOfClass("Backpack") if bp then for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do local t = bp:FindFirstChild(name) if t and t:IsA("Tool") then local hum = char:FindFirstChildOfClass("Humanoid") if hum then pcall(function() hum:EquipTool(t) end) end return t end end end for _, ch in ipairs(char:GetChildren()) do if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end end return nil end
function isBatTool(tool) if not tool then return false end for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do if tool.Name == name then return true end end return tool.Name:lower():find("bat") or tool.Name:lower():find("slap") end
function findBatForCounter() local char = LP.Character if not char then return nil end local backpack = LP:FindFirstChildOfClass("Backpack") for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name)) if tool then return tool end end for _, child in ipairs(char:GetChildren()) do if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then return child end end if backpack then for _, child in ipairs(backpack:GetChildren()) do if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then return child end end end return nil end
function swingBatForCounter(bat, character) local humanoid = character:FindFirstChildOfClass("Humanoid") if bat.Parent ~= character and humanoid then pcall(function() humanoid:EquipTool(bat) end) task.wait(0.05) end local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction") if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end) task.wait(0.1) pcall(function() remote:FireServer() end) else pcall(function() bat:Activate() end) task.wait(0.1) pcall(function() bat:Activate() end) end end
function stopBatCounter() if Conns.batCounter then Conns.batCounter:Disconnect() Conns.batCounter = nil end batCounterDebounce = false end
function startBatCounter() if Conns.batCounter then return end Conns.batCounter = RunService.Heartbeat:Connect(function() if not batCounterEnabled then return end if batCounterDebounce then return end local character = LP.Character if not character then return end local humanoid = character:FindFirstChildOfClass("Humanoid") if not humanoid then return end local state = humanoid:GetState() if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then batCounterDebounce = true _suppressBodyLock() task.spawn(function() task.wait(0.15) local bat = findBatForCounter() if bat then swingBatForCounter(bat, character) end task.wait(0.3) batCounterDebounce = false _unsuppressBodyLock(true) end) end end) end
function findMedusa() local c = LP.Character if not c then return nil end for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end local bp = LP:FindFirstChild("Backpack") if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n = t.Name:lower() if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end return nil end
function useMedusaCounter() if medusaDebounce then return end if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end local c = LP.Character if not c then return end medusaDebounce = true local med = findMedusa() if not med then medusaDebounce = false; return end if med.Parent ~= c then local hum2 = c:FindFirstChildOfClass("Humanoid") if hum2 then hum2:EquipTool(med) end end pcall(function() med:Activate() end) medusaLastUsed = tick() medusaDebounce = false end
function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end end) end
function setupMedusa(char) for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} if not char or not medusaCounterEnabled then return end for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end end)) end
function stopMedusaCounter() for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end Conns.anchor = {} end
function setMedusaCounterState(state) medusaCounterEnabled = state if state then if medusaAutoResetEnabled then medusaAutoResetEnabled = false if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end end if LP.Character then setupMedusa(LP.Character) else stopMedusaCounter() end else stopMedusaCounter() end if setMedusaVisual then setMedusaVisual(state) end end

local DROP_ASCEND_DURATION = 0.22 local DROP_ASCEND_SPEED = 160 local _dropConn = nil
function stopDropBrainrot() dropActive = false if _dropConn then _dropConn:Disconnect() _dropConn = nil end for _, t in ipairs(dropConnections) do if type(t) == "thread" then pcall(task.cancel, t) elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end end dropConnections = {} local c = LP.Character if c then local root = c:FindFirstChild("HumanoidRootPart") if root then root.AssemblyLinearVelocity = Vector3.zero end end if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end if mobSetDropBR then mobSetDropBR(false) end end
function runDropBrainrot() if dropActive then return end local char = LP.Character local root = char and char:FindFirstChild("HumanoidRootPart") local hum = char and char:FindFirstChildOfClass("Humanoid") if not root or not hum then return end if dropMode == 1 then local speedH = 0 if root then local vel = root.AssemblyLinearVelocity speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude end local cooldown = (speedH > 5) and 0.6 or 0.25 if tick() - lastDropTime < cooldown then return end lastDropTime = tick() dropActive = true if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end if mobSetDropBR then mobSetDropBR(true) end local wasAutoBat = false if autoBatEnabled then wasAutoBat = true disableAutoBat() if autoBatSetVisual then autoBatSetVisual(false) end if mobSetAutoBat then mobSetAutoBat(false) end end local function finishDrop(threadRef) if threadRef and dropConnections then for i = #dropConnections, 1, -1 do if dropConnections[i] == threadRef then table.remove(dropConnections, i) break end end end dropActive = false local c = LP.Character if c then local r = c:FindFirstChild("HumanoidRootPart") local h = c:FindFirstChildOfClass("Humanoid") if r then r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero if r.Position.Y < -100 then r.CFrame = CFrame.new(r.Position.X, 5, r.Position.Z) end local rp = RaycastParams.new() rp.FilterDescendantsInstances = {c} rp.FilterType = Enum.RaycastFilterType.Exclude local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp) if rr then local off = (h and h.HipHeight or 2) + (r.Size.Y / 2) r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z) end if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end end end if wasAutoBat then enableAutoBat() if autoBatSetVisual then autoBatSetVisual(true) end if mobSetAutoBat then mobSetAutoBat(true) end end if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end if mobSetDropBR then mobSetDropBR(false) end end local flingThread = nil flingThread = task.spawn(function() local startTime = tick() while dropActive and (tick() - startTime) < 0.25 do RunService.Heartbeat:Wait() local c = LP.Character local r = c and c:FindFirstChild("HumanoidRootPart") if not r then break end local vel = r.AssemblyLinearVelocity vel = Vector3.new(0, vel.Y, 0) r.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0) RunService.RenderStepped:Wait() if r and r.Parent then r.AssemblyLinearVelocity = vel end RunService.Stepped:Wait() if r and r.Parent then r.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0) end end finishDrop(flingThread) end) table.insert(dropConnections, flingThread) task.delay(0.35, function() if dropActive then finishDrop(flingThread) end end) return end dropActive = true if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end if mobSetDropBR then mobSetDropBR(true) end local t0 = tick() if _dropConn then _dropConn:Disconnect() end _dropConn = RunService.Heartbeat:Connect(function() local c = LP.Character local r = c and c:FindFirstChild("HumanoidRootPart") if not r then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end dropActive = false if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end if mobSetDropBR then mobSetDropBR(false) end return end if not dropActive then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end if mobSetDropBR then mobSetDropBR(false) end return end if tick() - t0 >= DROP_ASCEND_DURATION then if _dropConn then _dropConn:Disconnect(); _dropConn = nil end pcall(function() local rp = RaycastParams.new() rp.FilterDescendantsInstances = {c} rp.FilterType = Enum.RaycastFilterType.Exclude local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp) if rr then local hum2 = c:FindFirstChildOfClass("Humanoid") local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2) r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z) r.AssemblyLinearVelocity = Vector3.zero r.AssemblyAngularVelocity = Vector3.zero end if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end end) dropActive = false if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end if mobSetDropBR then mobSetDropBR(false) end return end local lv = r.AssemblyLinearVelocity r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z) end) end
function executeDropWithToggle(setVisual) if dropActive then return end task.spawn(function() if setVisual then setVisual(true) end runDropBrainrot() while dropActive do task.wait() end task.wait(0.1) if setVisual then setVisual(false) end end) end
function applyAntiLagDerender(obj) pcall(function() if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy() elseif obj:IsA("BasePart") then obj.Material = Enum.Material.Plastic obj.Reflectance = 0 obj.CastShadow = false elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1 elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled = false elseif obj:IsA("AnimationController") or obj:IsA("Animator") then for _, t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end end end) end
function enableAntiLag() removeAccessoriesEnabled = true antiLagEnabled = true if defLightBrightness == nil then defLightBrightness = Lighting.Brightness defLightClock = Lighting.ClockTime defLightAmbient = Lighting.OutdoorAmbient defGlobalShadows = Lighting.GlobalShadows defFogEnd = Lighting.FogEnd end Lighting.GlobalShadows = false Lighting.FogEnd = 1e10 Lighting.Brightness = 0 for _, e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end end) end for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end if antiLagDescConn then antiLagDescConn:Disconnect() end antiLagDescConn = workspace.DescendantAdded:Connect(function(obj) if removeAccessoriesEnabled then applyAntiLagDerender(obj) end end) end
function disableAntiLag() removeAccessoriesEnabled = false antiLagEnabled = false if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end if defLightBrightness ~= nil then Lighting.Brightness = defLightBrightness end if defLightClock ~= nil then Lighting.ClockTime = defLightClock end if defLightAmbient ~= nil then Lighting.OutdoorAmbient = defLightAmbient end if defGlobalShadows ~= nil then Lighting.GlobalShadows = defGlobalShadows end if defFogEnd ~= nil then Lighting.FogEnd = defFogEnd end for _, e in pairs(Lighting:GetChildren()) do pcall(function() if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = true end end) end end
function applyStretchFOV(val) local cam = workspace.CurrentCamera if cam then pcall(function() cam.FieldOfView = val end) end end
function enableStretch() if stretchConn then return end stretchEnabled = true local cam = workspace.CurrentCamera if not cam then return end origFOV = cam.FieldOfView or 70 applyStretchFOV(stretchFOV) stretchConn = RunService.RenderStepped:Connect(function() if not stretchEnabled then stretchConn:Disconnect(); stretchConn = nil return end local c = workspace.CurrentCamera if c then c.CFrame = c.CFrame * CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1) end end) if stretchFovConn then stretchFovConn:Disconnect() end stretchFovConn = RunService.RenderStepped:Connect(function() if stretchEnabled then applyStretchFOV(stretchFOV) else stretchFovConn:Disconnect(); stretchFovConn = nil end end) end
function disableStretch() stretchEnabled = false if stretchConn then stretchConn:Disconnect(); stretchConn = nil end if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end local cam = workspace.CurrentCamera if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end end
local function saveLightingState() if _originalLighting then return end _originalLighting = { Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, OutdoorAmbient = Lighting.OutdoorAmbient, GlobalShadows = Lighting.GlobalShadows, FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart, FogColor = Lighting.FogColor, Ambient = Lighting.Ambient, ColorCorrection = nil, Bloom = nil, } for _, e in ipairs(Lighting:GetChildren()) do if e:IsA("ColorCorrectionEffect") then _originalLighting.ColorCorrection = { Enabled = e.Enabled, Brightness = e.Brightness, Contrast = e.Contrast, Saturation = e.Saturation, TintColor = e.TintColor, } elseif e:IsA("BloomEffect") then _originalLighting.Bloom = { Enabled = e.Enabled, Intensity = e.Intensity, Size = e.Size, Threshold = e.Threshold, } end end end
local function restoreLightingState() if not _originalLighting then return end local old = _originalLighting Lighting.Brightness = old.Brightness Lighting.ClockTime = old.ClockTime Lighting.OutdoorAmbient = old.OutdoorAmbient Lighting.GlobalShadows = old.GlobalShadows Lighting.FogEnd = old.FogEnd Lighting.FogStart = old.FogStart Lighting.FogColor = old.FogColor Lighting.Ambient = old.Ambient if old.ColorCorrection then local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if cc then cc.Enabled = old.ColorCorrection.Enabled cc.Brightness = old.ColorCorrection.Brightness cc.Contrast = old.ColorCorrection.Contrast cc.Saturation = old.ColorCorrection.Saturation cc.TintColor = old.ColorCorrection.TintColor end end if old.Bloom then local bloom = Lighting:FindFirstChildOfClass("BloomEffect") if bloom then bloom.Enabled = old.Bloom.Enabled bloom.Intensity = old.Bloom.Intensity bloom.Size = old.Bloom.Size bloom.Threshold = old.Bloom.Threshold end end _originalLighting = nil end
local function applyNeonWeather() if not neonWeatherEnabled then restoreLightingState() return end if not _originalLighting then saveLightingState() end Lighting.Brightness = 3.5 Lighting.ClockTime = 20 Lighting.OutdoorAmbient = Color3.fromRGB(40, 40, 40) Lighting.GlobalShadows = false Lighting.FogEnd = 300 Lighting.FogStart = 0 Lighting.FogColor = Color3.fromRGB(30, 30, 30) Lighting.Ambient = Color3.fromRGB(50, 50, 50) local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect") if not cc then cc = Instance.new("ColorCorrectionEffect") cc.Parent = Lighting end cc.Enabled = true cc.Brightness = 0.2 cc.Contrast = 0.15 cc.Saturation = 0.15 cc.TintColor = Color3.fromRGB(180, 180, 180) local bloom = Lighting:FindFirstChildOfClass("BloomEffect") if not bloom then bloom = Instance.new("BloomEffect") bloom.Parent = Lighting end bloom.Enabled = true bloom.Intensity = 0.6 bloom.Size = 25 bloom.Threshold = 0.8 end
function toggleNeonWeather(state) if state == nil then neonWeatherEnabled = not neonWeatherEnabled else neonWeatherEnabled = state end applyNeonWeather() if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end end
local function drag(f) local dn, ds, sp, di = false f.InputBegan:Connect(function(i) if uiLocked then return end if _isDraggingButton then return end if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dn = true; ds = i.Position; sp = f.Position i.Changed:Connect(function() if i.UserInputState == Enum.InputUserState.End then dn = false end end) end end) f.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end end) UIS.InputChanged:Connect(function(i) if i == di and dn then if uiLocked then dn = false; return end if _isDraggingButton then return end local nX = sp.X.Offset + (i.Position.X - ds.X) local nY = sp.Y.Offset + (i.Position.Y - ds.Y) f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY) end end) end
local function evoraIsCarrying()
    local char = LP.Character
    if not char then return false end
    if char:GetAttribute("Stealing") == true or LP:GetAttribute("Stealing") == true then return true end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            local n = string.lower(obj.Name)
            if string.find(n, "brainrot", 1, true) or string.find(n, "carry", 1, true) or string.find(n, "steal", 1, true) then return true end
            local ok, stealing = pcall(function() return obj:GetAttribute("Stealing") end)
            if ok and stealing == true then return true end
        end
    end
    return false
end

function setupMovementAndIndicators(char) if steppedConn then steppedConn:Disconnect(); steppedConn = nil end if movementLoop then movementLoop:Disconnect(); movementLoop = nil end steppedConn = RunService.Stepped:Connect(function() for _, p in ipairs(Players:GetPlayers()) do if p ~= LP and p.Character then for _, part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end end end) movementLoop = RunService.RenderStepped:Connect(function() local char2 = LP.Character if not char2 then return end local hum = char2:FindFirstChildOfClass("Humanoid") local hrp = char2:FindFirstChild("HumanoidRootPart") if not hum or not hrp then return end if not autoBatEnabled and not tpLockEnabled and not autoLeftEnabled and not autoRightEnabled and not autoBatV2Enabled then local spd if laggerToggled then spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1 elseif autoCarryEnabled then spd = evoraIsCarrying() and CS or NS else spd = speedMode and CS or NS end if speedEnabled and currentSpeedValue ~= spd then cleanupSpeedPhysics() end if not speedEnabled and spd > 0 then applySpeedWithLinearVelocity(spd) end else if speedEnabled then cleanupSpeedPhysics() end end if speedLabel then local v = hrp.Velocity local flatSpeed = math.sqrt(v.X * v.X + v.Z * v.Z) speedLabel.Text = "Spd: " .. string.format("%.1f", flatSpeed) end end) setupSpeedIndicator(char) startEnemySpeed() end
function toggleLockUI(state) if state == nil then uiLocked = not uiLocked else uiLocked = state end if uiLocked and editModeEnabled then editModeEnabled = false if setEditModeVisual then setEditModeVisual(false) end end if setLockUIVisual then setLockUIVisual(uiLocked) end end
function toggleEditMode(state) if state == nil then state = not editModeEnabled end if state and uiLocked then state = false end editModeEnabled = state if setEditModeVisual then setEditModeVisual(editModeEnabled) end end
function disableAllAimbots() if autoBatEnabled then disableAutoBat() if autoBatSetVisual then autoBatSetVisual(false) end if mobSetAutoBat then mobSetAutoBat(false) end end if tpLockEnabled then toggleAntiDesyncAimbot() end if autoBatV2Enabled then disableBatV2() if autoBatV2SetVisual then autoBatV2SetVisual(false) end end end
function stopAllBackgroundTasks() if movementLoop then movementLoop:Disconnect(); movementLoop = nil end if steppedConn then steppedConn:Disconnect(); steppedConn = nil end stopEnemySpeed() if stretchEnabled then disableStretch() end if stretchConn then stretchConn:Disconnect(); stretchConn = nil end if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end stopAntiRagdoll() stopBatCounter() stopMedusaCounter() stopAutoSteal() disableAutoBat() if tpLockEnabled then stopAntiDesyncAimbot() end if autoBatV2Enabled then disableBatV2() end stopAutoLeft() stopAutoRight() if unwalkEnabled then stopUnwalk() end if antiLagEnabled then disableAntiLag() end if espEnabled then toggleESP(false) end if dropActive then stopDropBrainrot() end if bodyLockEnabled then stopBodyLock() end if _antiDropActive then stopAntiDrop() end if antiDieEnabled then stopAntiDie() end cleanupSpeedPhysics() _blSuppressCount = 0 _blWasEnabled = false if _blRestoreTimer then task.cancel(_blRestoreTimer) _blRestoreTimer = nil end for _, t in ipairs(dropConnections) do if type(t) == "thread" then pcall(task.cancel, t) elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end end dropConnections = {} dropActive = false alPhase = 1 arPhase = 1 lastDropTime = 0 medusaDebounce = false medusaLastUsed = 0 end
function buildConfigTable()
    local config = {
        stealMode = AdaptSteal.Mode,
        fontStyle = _G.EvoraduelsFontName or "GothamBold",
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        stealRadius = CONFIG.STEAL_RANGE,
        stealDuration = CONFIG.HOLD_MAX,
        antiRagdoll = antiRagdollEnabled,
        autoSteal = AdaptSteal.AutoStealEnabled,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        laggerToggled = laggerToggled,
        laggerLevel = laggerLevel,
        carryMode = speedMode,
        autoCarryEnabled = autoCarryEnabled,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        uiScale = uiScaleValue,
        animPack = currentAnimPack,
        espEnabled = espEnabled,
        antiLag = antiLagEnabled,
        tpLockEnabled = _G.AceAntiDesyncAimbotOn,
        neonWeather = neonWeatherEnabled,
        autoBatV2Enabled = autoBatV2Enabled,
        antiDrop = true,
        antiDie = antiDieEnabled,
        infJump = (InfJumpState and InfJumpState.enabled == true),
        infJumpMode = (InfJumpState and InfJumpState.mode) or "normal",
        stealBarSize = stealBarSize,
        mobileButtonSize = mobileButtonSize,
        avatarIndex = _avatarCurrentIndex,
        mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpLockKey = {kb = KB.TPLock.kb and KB.TPLock.kb.Name, gp = KB.TPLock.gp and KB.TPLock.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        antiDieKey = {kb = KB.AntiDie.kb and KB.AntiDie.kb.Name, gp = KB.AntiDie.gp and KB.AntiDie.gp.Name},
        tpBatFloatingPos = tpBatFloatingPos,
        batV2FloatingPos = batV2FloatingPos,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        autoResetStates = autoResetStates,
        progressBarPos = savedProgressBarPos,
        lockUI = uiLocked,
        editMode = editModeEnabled,
    }
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = { XScale = container.Position.X.Scale, XOffset = container.Position.X.Offset, YScale = container.Position.Y.Scale, YOffset = container.Position.Y.Offset }
    end
    return config
end
function saveAllSettings() if _isResetting then return true end local config = buildConfigTable() local json = HS:JSONEncode(config) if json == _lastSavedJSON then return true end local success, err = pcall(function() writefile(CONFIG_FILE, json) end) if success then _lastSavedJSON = json end return success end
function loadAllSettings() if not isfile or not isfile(CONFIG_FILE) then return false end local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end) if not success or not data then return false end _isLoading = true if data.stealMode == "normal" or data.stealMode == "73" then AdaptSteal.Mode = data.stealMode end if type(data.fontStyle) == "string" then _G.EvoraduelsFontName = data.fontStyle end NS = data.normalSpeed or NS CS = data.carrySpeed or CS LAGGER_SPEED_1 = data.laggerSpeed1 or LAGGER_SPEED_1 LAGGER_SPEED_2 = data.laggerSpeed2 or LAGGER_SPEED_2 CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE CONFIG.HOLD_MAX = data.stealDuration or CONFIG.HOLD_MAX uiLocked = data.lockUI or true editModeEnabled = data.editMode or false antiRagdollEnabled = data.antiRagdoll or false medusaCounterEnabled = data.medusaCounter or false batCounterEnabled = data.batCounter or false unwalkEnabled = data.unwalk or false antiLagEnabled = data.antiLag or false laggerToggled = data.laggerToggled or false speedMode = data.carryMode or false autoCarryEnabled = data.autoCarryEnabled == true if autoCarrySetVisual then autoCarrySetVisual(autoCarryEnabled) end laggerLevel = data.laggerLevel or 1 medusaAutoResetEnabled = data.medusaAutoReset or false if medusaAutoResetEnabled and medusaCounterEnabled then medusaCounterEnabled = false end uiScaleValue = data.uiScale or 80 stealBarSize = data.stealBarSize or 1.0 mobileButtonSize = data.mobileButtonSize or 1.0 _avatarCurrentIndex = data.avatarIndex or 1 if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end if pbScale then pbScale.Scale = (uiScaleValue / 100) * stealBarSize end if _G.updateMobileButtonScale then _G.updateMobileButtonScale() end if _G.tpBatUIScale then _G.tpBatUIScale.Scale = mobileButtonSize end if _G.batV2UIScale then _G.batV2UIScale.Scale = mobileButtonSize end if data.infJump ~= nil then InfJumpState.enabled = (data.infJump == true) end
if data.infJumpMode ~= nil then InfJumpState.mode = tostring(data.infJumpMode) end
if setInfJumpVisual then setInfJumpVisual(InfJumpState.enabled) end
if _G.updateInfJumpModeLabel then _G.updateInfJumpModeLabel(InfJumpState.mode == "hold" and "Hold" or "Normal") end espEnabled = data.espEnabled or false if espEnabled then toggleESP(true) else toggleESP(false) end autoBatV2Enabled = data.autoBatV2Enabled or false if autoBatV2Enabled then task.defer(function() enableBatV2() if autoBatV2SetVisual then autoBatV2SetVisual(true) end end) else if autoBatV2SetVisual then autoBatV2SetVisual(false) end end antiDropEnabled = true antiDieEnabled = data.antiDie or false if antiDieEnabled then task.defer(function() toggleAntiDie(true) if setAntiDieVisual then setAntiDieVisual(true) end end) end local antiDesyncState = data.tpLockEnabled or false if antiDesyncState then task.defer(function() startAntiDesyncAimbot() if tpLockSetVisual then tpLockSetVisual(true) end end) else if tpLockSetVisual then tpLockSetVisual(false) end end neonWeatherEnabled = data.neonWeather or false if neonWeatherEnabled then task.defer(function() toggleNeonWeather(true) end) else toggleNeonWeather(false) end if data.animPack and ANIM_PACKS[data.animPack] then startAnimPack(data.animPack) else currentAnimPack = "Off" stopAnimPack() end local function lk(e, d) if not d then return end if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end end lk(KB.DropBrainrot, data.dropBrainrotKey) lk(KB.AutoLeft, data.autoLeftKey) lk(KB.AutoRight, data.autoRightKey) lk(KB.AutoBat, data.autoBatKey) lk(KB.TPFloor, data.tpFloorKey) lk(KB.CarryToggle, data.carryToggleKey) lk(KB.LaggerMode, data.laggerModeKey) lk(KB.TPLock, data.tpLockKey) lk(KB.BatV2, data.batV2Key) lk(KB.AntiDie, data.antiDieKey) if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end if data.batV2FloatingPos then batV2FloatingPos = data.batV2FloatingPos end if data.progressBarPos then savedProgressBarPos = data.progressBarPos end if data.bodyLockEnabled ~= nil then bodyLockEnabled = data.bodyLockEnabled if bodyLockEnabled then task.defer(function() if bodyLockSetVisual then bodyLockSetVisual(true) end startBodyLock() end) end end if data.bodyLockRange then bodyLockRange = data.bodyLockRange if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end end if data.autoResetStates then for k, v in pairs(data.autoResetStates) do if autoResetStates[k] ~= nil then autoResetStates[k] = v end end end dropMode = data.dropMode or 1 stretchEnabled = data.stretchEnabled or false stretchFOV = data.stretchFOV or 120 BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED autoBatEnabled = false autoLeftEnabled = false autoRightEnabled = false AdaptSteal.AutoStealEnabled = true if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end refreshSpeedModeLabel() _lastSavedJSON = HS:JSONEncode(buildConfigTable()) _isLoading = false return true end
function forceResetUI() if normalBox then normalBox.Text = tostring(NS) end if carryBox then carryBox.Text = tostring(CS) end if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end local function safeSet(fn, val) if fn then fn(val) end end safeSet(autoBatSetVisual, false) safeSet(autoLeftSetVisual, false) safeSet(autoRightSetVisual, false) safeSet(setBatCounterVisual, false) safeSet(setMedusaVisual, false) safeSet(setMedusaAutoResetVisual, false) safeSet(setAntiRagVisual, false) safeSet(setUnwalkVisual, false) safeSet(setAntiLagVisual, false) safeSet(setLockUIVisual, false) safeSet(setEditModeVisual, false) safeSet(setInstaGrab, true) safeSet(tpLockSetVisual, false) safeSet(setESPVIsual, false) safeSet(bodyLockSetVisual, false) safeSet(setNeonWeatherVisual, false) safeSet(autoBatV2SetVisual, false) safeSet(autoCarrySetVisual, false) safeSet(setAntiDieVisual, false) safeSet(setInfJumpVisual, true) if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end safeSet(mobSetAutoBat, false) safeSet(mobSetAutoLeft, false) safeSet(mobSetAutoRight, false) safeSet(mobSetDropBR, false) safeSet(mobSetTpDown, false) safeSet(mobSetCarry, false) safeSet(mobSetLagger1, false) safeSet(mobSetLagger2, false) if _G.updateStealBarScale then _G.updateStealBarScale() end if _G.updateMobileButtonScale then _G.updateMobileButtonScale() end if _G.tpBatUIScale then _G.tpBatUIScale.Scale = 1 end if _G.batV2UIScale then _G.batV2UIScale.Scale = 1 end refreshSpeedModeLabel() updateProgressBarVisibility() disableAntiLag() toggleNeonWeather(false) disableBatV2() for _, ref in ipairs(keyButtonRefs) do local entry = ref.entry local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None" ref.btn.Text = label end end
function resetFloatingPositions() if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then local container = MobilePanel:FindFirstChild("FloatingPanel") container.Position = UDim2.new(0, 10, 0, 0) savedButtonPositions = {} if container:FindFirstChild("ButtonsContainer") then for _, btn in ipairs(container.ButtonsContainer:GetChildren()) do if btn:IsA("Frame") and btn.Name:find("_Wrap") then local baseName = btn.Name:gsub("_Wrap$", "") local defX, defY = getDefaultButtonPosition(baseName) btn.Position = UDim2.new(0, defX, 0, defY) end end end end if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then local wrapper = tpBatFloatingButton:FindFirstChild("Frame") wrapper.Position = UDim2.new(0.5, 20, 0, 10) tpBatFloatingPos = nil end if batV2FloatingButton and batV2FloatingButton:FindFirstChild("Frame") then local wrapper = batV2FloatingButton:FindFirstChild("Frame") wrapper.Position = UDim2.new(0.5, -50, 0, 10) batV2FloatingPos = nil end if pbFrame then pbFrame.Position = UDim2.new(0.5, -170, 1, -70) savedProgressBarPos = nil end savedMobilePanelPos = nil tpBatFloatingPos = nil batV2FloatingPos = nil end
function resetToFactoryDefaults() _isResetting = true stopAllBackgroundTasks() stopAutoSteal() stopBatCounter() stopMedusaCounter() stopAntiRagdoll() stopUnwalk() disableAutoBat() if tpLockEnabled then stopAntiDesyncAimbot() end disableBatV2() stopBodyLock() if espEnabled then toggleESP(false) end if stretchEnabled then disableStretch() end if antiLagEnabled then disableAntiLag() end if dropActive then stopDropBrainrot() end if _antiDropActive then stopAntiDrop() end if antiDieEnabled then stopAntiDie() end toggleNeonWeather(false) NS = 60 CS = 29 LAGGER_SPEED_1 = 20 LAGGER_SPEED_2 = 10 CONFIG.STEAL_RANGE = 9 CONFIG.HOLD_MAX = 2.6 speedMode = false autoCarryEnabled = false if autoCarrySetVisual then autoCarrySetVisual(false) end laggerToggled = false laggerLevel = 1 antiRagdollEnabled = false medusaCounterEnabled = false batCounterEnabled = false autoBatEnabled = false autoLeftEnabled = false autoRightEnabled = false unwalkEnabled = false antiLagEnabled = false uiLocked = true editModeEnabled = false BAT_AIMBOT_SPEED = 58 _G.AceAntiDesyncAimbotOn = false dropMode = 1 medusaAutoResetEnabled = false stretchEnabled = false stretchFOV = 120 uiScaleValue = 80 stealBarSize = 1.0 mobileButtonSize = 1.0 _avatarCurrentIndex = 1 InfJumpState.enabled = true if mainUIScale then mainUIScale.Scale = 0.8 end if pbScale then pbScale.Scale = 0.8 end if _G.updateMobileButtonScale then _G.updateMobileButtonScale() end if _G.tpBatUIScale then _G.tpBatUIScale.Scale = 1 end if _G.batV2UIScale then _G.batV2UIScale.Scale = 1 end espEnabled = false bodyLockEnabled = false bodyLockRange = 20 autoBatV2Enabled = false antiDropEnabled = true antiDieEnabled = false for k in pairs(autoResetStates) do autoResetStates[k] = false end currentAnimPack = "Off" stopAnimPack() savedStealRadius = CONFIG.STEAL_RANGE savedStealDuration = CONFIG.HOLD_MAX for key, val in pairs(DEFAULT_KB) do if KB[key] then KB[key].kb = val.kb KB[key].gp = val.gp end end if isfile and isfile(CONFIG_FILE) then pcall(delfile, CONFIG_FILE) end resetFloatingPositions() forceResetUI() updateProgressBarVisibility() refreshSpeedModeLabel() _lastSavedJSON = nil saveAllSettings() _isResetting = false end
function updateProgressBarVisibility()
    local wantVisible = (AdaptSteal and AdaptSteal.AutoStealEnabled == true)
    if wantVisible then
        if not (_G.RanaStealGui and _G.RanaStealGui.Parent) and _G.buildRanaStealBar then
            pcall(_G.buildRanaStealBar)
        end
        if _G.RanaStealGui then _G.RanaStealGui.Enabled = true end
        if pbFrame then pbFrame.Visible = true end
    else
        if _G.RanaStealGui then _G.RanaStealGui.Enabled = false end
        if pbFrame then pbFrame.Visible = false end
    end
end
function getDefaultButtonPosition(btnName) local BTN_W, BTN_H = 60, 60 local GAP = 8 local orderMap = { DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, InstaReset = 8 } local order = orderMap[btnName] or 0 if btnName == "InstaReset" then return 0, - (BTN_H + GAP) end local row = math.floor(order / 2) local col = order % 2 return col * (BTN_W + GAP), row * (BTN_H + GAP + 10) end

local GREY_LIGHT = Color3.fromRGB(255, 182, 213)
local GREY_MID   = Color3.fromRGB(255, 105, 180)
local GREY_DARK  = Color3.fromRGB(25, 8, 18)
local GREY_BORDER = Color3.fromRGB(255, 182, 213)

-- ═══════════════ RANA OUTFIT SYSTEM ═══════════════
local RanaOutfit = {
    active = "Off",
    originalShirt = nil,
    originalPants = nil,
    originalAccessories = nil,
    originalHeadMesh = nil,
    originalHeadTexture = nil,
    packs = {
        ["Outfit 1"] = {
            accessory = 306969564,
            offset = Vector3.new(0, 0.3, 0),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=10632503795",
            pants = "http://www.roblox.com/asset/?id=123161592384863",
            korblox = "right"
        },
        ["Outfit 2"] = {
            accessory = 1744060292,
            offset = Vector3.new(0, 1.4, -0.2),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=11526718530",
            pants = "http://www.roblox.com/asset/?id=93710523210027",
            korblox = "right"
        },
        ["Outfit 3"] = {
            accessory = 112564966849233,
            offset = Vector3.new(0, 0.6, 0),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=11849088376",
            pants = "http://www.roblox.com/asset/?id=16534673928",
            korblox = "right"
        }
    }
}
function RanaOutfit:save(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    self.originalShirt = shirt and shirt.ShirtTemplate or nil
    self.originalPants = pants and pants.PantsTemplate or nil
    self.originalAccessories = {}
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") then
        self.originalHeadMesh = head.MeshId
        self.originalHeadTexture = head.TextureID
    elseif head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            self.originalHeadMesh = sm.MeshId
            self.originalHeadTexture = sm.TextureId
        end
    end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local ok, clone = pcall(function() return obj:Clone() end)
            if ok and clone then table.insert(self.originalAccessories, clone) end
        end
    end
end
function RanaOutfit:clear(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Accessory") or obj:IsA("Hat") or obj.Name == "RanaOutfitAccessory" or obj.Name:find("RanaKorblox_") then
            pcall(function() obj:Destroy() end)
        elseif obj:IsA("Shirt") or obj:IsA("Pants") then
            pcall(function() obj:Destroy() end)
        end
    end
    for _, name in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then part.Transparency = 0 end
    end
end
function RanaOutfit:restore(char)
    if not char then return end
    self:clear(char)
    if self.originalShirt then
        local shirt = Instance.new("Shirt")
        shirt.ShirtTemplate = self.originalShirt
        shirt.Parent = char
    end
    if self.originalPants then
        local pants = Instance.new("Pants")
        pants.PantsTemplate = self.originalPants
        pants.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and self.originalHeadMesh then
        pcall(function()
            if head:IsA("MeshPart") then
                head.MeshId = self.originalHeadMesh
                head.TextureID = self.originalHeadTexture or ""
            else
                local sm = head:FindFirstChildWhichIsA("SpecialMesh")
                if sm then
                    sm.MeshId = self.originalHeadMesh
                    sm.TextureId = self.originalHeadTexture or ""
                end
            end
        end)
    end
    if self.originalAccessories then
        for _, clone in ipairs(self.originalAccessories) do
            pcall(function()
                local restored = clone:Clone()
                restored.Parent = char
                for _, weld in ipairs(restored:GetDescendants()) do
                    if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                        local p0 = weld.Part0 and char:FindFirstChild(weld.Part0.Name)
                        local p1 = weld.Part1 and char:FindFirstChild(weld.Part1.Name)
                        if weld:IsA("Weld") then
                            weld.Part0 = p0 or weld.Part0
                            weld.Part1 = p1 or weld.Part1
                        else
                            weld.Part0 = p0 or weld.Part0
                            weld.Part1 = p1 or weld.Part1
                        end
                    end
                end
            end)
        end
    end
    self.originalShirt = nil
    self.originalPants = nil
    self.originalAccessories = nil
    self.originalHeadMesh = nil
    self.originalHeadTexture = nil
    self.active = "Off"
end
function RanaOutfit:apply(name)
    local cfg = self.packs[name]
    local char = LP.Character
    if not cfg or not char then return false end
    local head = char:FindFirstChild("Head")
    if not head then return false end
    if self.originalAccessories == nil then self:save(char) end
    self:clear(char)
    if cfg.headMesh then
        pcall(function()
            if head:IsA("MeshPart") then
                head.MeshId = cfg.headMesh
                head.TextureID = cfg.headTexture or ""
            else
                local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
                sm.MeshType = Enum.MeshType.FileMesh
                sm.MeshId = cfg.headMesh
                sm.TextureId = cfg.headTexture or ""
                sm.Parent = head
            end
        end)
    end
    local shirt = Instance.new("Shirt")
    shirt.ShirtTemplate = cfg.shirt
    shirt.Parent = char
    local pants = Instance.new("Pants")
    pants.PantsTemplate = cfg.pants
    pants.Parent = char
    if cfg.accessory then
        local ok, objects = pcall(function()
            return game:GetObjects("rbxassetid://" .. tostring(cfg.accessory))
        end)
        if ok and type(objects) == "table" and #objects > 0 then
            local handle
            for _, obj in ipairs(objects) do
                if obj:IsA("BasePart") then handle = obj break end
                local found = obj:FindFirstChildWhichIsA("BasePart", true)
                if found then handle = found break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "RanaOutfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = CFrame.new(cfg.offset or Vector3.zero)
                weld.Parent = h
            end
            for _, obj in ipairs(objects) do pcall(function() obj:Destroy() end) end
        end
    end
    if cfg.korblox == "right" then
        local target = char:FindFirstChild("RightUpperLeg")
        if target then
            for _, name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"}) do
                local part = char:FindFirstChild(name)
                if part and part:IsA("BasePart") then part.Transparency = 1 end
            end
            local ok, objects = pcall(function()
                return game:GetObjects("rbxassetid://139607718")
            end)
            if ok and type(objects) == "table" and #objects > 0 then
                local model = objects[1]
                local mesh = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
                if mesh then
                    mesh.CanCollide = false
                    mesh.Massless = true
                    mesh.CFrame = target.CFrame
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = target
                    weld.Part1 = mesh
                    weld.Parent = mesh
                    model.Name = "RanaKorblox_Outfit"
                    model.Parent = char
                end
            end
        end
    end
    self.active = name
    return true
end
function RanaOutfit:set(name)
    if name == "Off" then
        self:restore(LP.Character)
        return
    end
    self:apply(name)
end
LP.CharacterAdded:Connect(function()
    task.delay(1, function()
        if RanaOutfit.active ~= "Off" then
            pcall(function() RanaOutfit:apply(RanaOutfit.active) end)
        end
    end)
end)
_G.RanaOutfit = RanaOutfit
-- ═══════════════ END RANA OUTFIT ═══════════════

function buildAdaptStealHUD(parentGui)
    local pbScaleObj = nil
    local BG = Color3.fromRGB(255, 105, 180)
    local BORDER = GREY_BORDER
    local TRACK = Color3.fromRGB(45, 12, 29)
    local TRACK2 = Color3.fromRGB(255, 182, 213)
    local FILL = Color3.fromRGB(255, 105, 180)
    local StealBar = Instance.new("Frame")
    StealBar.Name = "AdaptStealBar"
    StealBar.Active = true
    StealBar.ZIndex = 50
    StealBar.Position = UDim2.new(0.5, -170, 1, -70)
    StealBar.Size = UDim2.new(0, 340, 0, 60)
    StealBar.BackgroundColor3 = BG
    StealBar.BorderSizePixel = 0
    StealBar.ClipsDescendants = false
    StealBar.Parent = parentGui
    Instance.new("UICorner", StealBar).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", StealBar)
    stroke.Color = BORDER
    stroke.Thickness = 2
    stroke.Transparency = 0
    pbScaleObj = Instance.new("UIScale", StealBar)
    pbScaleObj.Scale = (uiScaleValue / 100) * stealBarSize
    if savedProgressBarPos then
        StealBar.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -170, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -70)
    end
    local dragHandle = Instance.new("Frame")
    dragHandle.Size = UDim2.new(1, 0, 1, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.ZIndex = 60
    dragHandle.Parent = StealBar
    local pct = Instance.new("TextLabel")
    pct.ZIndex = 51
    pct.Position = UDim2.new(0, 15, 0, 8)
    pct.Size = UDim2.new(0, 100, 0, 20)
    pct.BackgroundTransparency = 1
    pct.Text = "0%"
    pct.TextColor3 = Color3.fromRGB(255, 182, 213)
    pct.TextSize = 14
    pct.Font = Enum.Font.GothamBold
    pct.TextXAlignment = Enum.TextXAlignment.Left
    pct.Parent = StealBar
    local fpslbl = Instance.new("TextLabel")
    fpslbl.ZIndex = 51
    fpslbl.Position = UDim2.new(1, -15, 0, 8)
    fpslbl.AnchorPoint = Vector2.new(1, 0)
    fpslbl.Size = UDim2.new(0, 200, 0, 20)
    fpslbl.BackgroundTransparency = 1
    fpslbl.Text = "60 FPS  •  23 m s"
    fpslbl.TextColor3 = GREY_LIGHT
    fpslbl.TextSize = 14
    fpslbl.Font = Enum.Font.GothamMedium
    fpslbl.TextXAlignment = Enum.TextXAlignment.Right
    fpslbl.Parent = StealBar
    local barBg = Instance.new("Frame")
    barBg.ZIndex = 51
    barBg.ClipsDescendants = true
    barBg.Position = UDim2.new(0, 15, 1, -18)
    barBg.Size = UDim2.new(1, -30, 0, 14)
    barBg.BackgroundColor3 = TRACK
    barBg.BorderSizePixel = 0
    barBg.Parent = StealBar
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
    local trackGrad = Instance.new("UIGradient")
    trackGrad.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 180)), ColorSequenceKeypoint.new(1, TRACK2) })
    trackGrad.Rotation = 90
    trackGrad.Parent = barBg
    local shadowFill = Instance.new("Frame")
    shadowFill.Name = "ShadowFill"
    shadowFill.Size = UDim2.new(0, 0, 1, 0)
    shadowFill.BackgroundColor3 = Color3.fromRGB(255, 182, 213)
    shadowFill.BorderSizePixel = 0
    shadowFill.ZIndex = 1
    shadowFill.Parent = barBg
    Instance.new("UICorner", shadowFill).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Name = "ProgressFill"
    fill.ZIndex = 2
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = FILL
    fill.BorderSizePixel = 0
    fill.Parent = barBg
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging, dragStart, startPos, dragConn, dragEndConn = false, nil, nil, nil, nil
    local function startDrag(input)
        if uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = StealBar.Position
            if dragConn then dragConn:Disconnect() end
            if dragEndConn then dragEndConn:Disconnect() end
            dragConn = UIS.InputChanged:Connect(function(i)
                if not dragging or uiLocked then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local delta = i.Position - dragStart
                    StealBar.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            dragEndConn = UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        savedProgressBarPos = { XScale = StealBar.Position.X.Scale, XOffset = StealBar.Position.X.Offset, YScale = StealBar.Position.Y.Scale, YOffset = StealBar.Position.Y.Offset }
                        saveAllSettings()
                    end
                    dragging = false
                    if dragConn then dragConn:Disconnect(); dragConn = nil end
                    if dragEndConn then dragEndConn:Disconnect(); dragEndConn = nil end
                end
            end)
        end
    end
    dragHandle.InputBegan:Connect(startDrag)
    task.spawn(function()
        local frames = 0
        RunService.RenderStepped:Connect(function() frames = frames + 1 end)
        while StealBar and StealBar.Parent do
            task.wait(1)
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            if fpslbl then fpslbl.Text = string.format("%d FPS  •  %d m s", frames, ping) end
            frames = 0
        end
    end)
    _G.updateStealBarScale = function()
        if pbScaleObj then pbScaleObj.Scale = (uiScaleValue / 100) * stealBarSize end
    end
    return StealBar, fill, pct, pbScaleObj, shadowFill
end

-- ═══════════════ RANA STEAL BAR (ON-SCREEN GUI, MOVABLE WHEN UI UNLOCKED) ═══════════════
local ranaScreenGui = nil
local ranaCard = nil
local ranaPbScale = nil

_G.buildRanaStealBar = function()
    if ranaScreenGui and ranaScreenGui.Parent and ranaCard and ranaCard.Parent then
        return ranaScreenGui
    end

    pcall(function() if ranaScreenGui then ranaScreenGui:Destroy() end end)

    ranaScreenGui = Instance.new("ScreenGui")
    ranaScreenGui.Name = "RanaAutoStealBar"
    ranaScreenGui.ResetOnSpawn = false
    ranaScreenGui.DisplayOrder = 60
    ranaScreenGui.IgnoreGuiInset = true
    ranaScreenGui.Enabled = true
    local okParent = pcall(function() ranaScreenGui.Parent = game:GetService("CoreGui") end)
    if not okParent then
        ranaScreenGui.Parent = LP:WaitForChild("PlayerGui")
    end

    -- Pink GUI Card (Sharp, compact, high-contrast)
    ranaCard = Instance.new("Frame")
    ranaCard.Name = "StealCard"
    ranaCard.Active = true
    ranaCard.ZIndex = 50
    ranaCard.Position = UDim2.new(0.5, -135, 1, -75)
    ranaCard.Size = UDim2.new(0, 270, 0, 48)
    ranaCard.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    ranaCard.BackgroundTransparency = 0
    ranaCard.BorderSizePixel = 0
    ranaCard.ClipsDescendants = false
    ranaCard.Visible = true
    ranaCard.Parent = ranaScreenGui
    Instance.new("UICorner", ranaCard).CornerRadius = UDim.new(0, 10)

    -- Bold Black Border
    local stroke = Instance.new("UIStroke", ranaCard)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 2.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    ranaPbScale = Instance.new("UIScale", ranaCard)
    ranaPbScale.Scale = (uiScaleValue / 100) * (stealBarSize or 1.0)

    -- White Text with Black Outline: Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 120, 0, 18)
    title.Position = UDim2.new(0, 10, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = "AUTO STEAL"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    title.TextStrokeTransparency = 0
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = ranaCard

    -- White Text with Black Outline: Mode Label
    progressRadLbl = Instance.new("TextLabel")
    progressRadLbl.Size = UDim2.new(0, 80, 0, 18)
    progressRadLbl.Position = UDim2.new(1, -90, 0, 4)
    progressRadLbl.BackgroundTransparency = 1
    progressRadLbl.Text = string.upper((AdaptSteal and AdaptSteal.Mode) or "NORMAL")
    progressRadLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressRadLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressRadLbl.TextStrokeTransparency = 0
    progressRadLbl.Font = Enum.Font.GothamBold
    progressRadLbl.TextSize = 11
    progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
    progressRadLbl.Parent = ranaCard

    -- High-Contrast Dark Track Container
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -68, 0, 13)
    track.Position = UDim2.new(0, 10, 0, 26)
    track.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.Parent = ranaCard
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 6)

    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Color = Color3.fromRGB(0, 0, 0)
    trackStroke.Thickness = 1.2

    -- Solid White Steal Progress Fill
    progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(0.02, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressFill.BorderSizePixel = 0
    progressFill.Parent = track
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 6)

    -- White Text with Black Outline: Percentage
    progressPct = Instance.new("TextLabel")
    progressPct.Size = UDim2.new(0, 46, 0, 16)
    progressPct.Position = UDim2.new(1, -54, 0, 24)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 12
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.Parent = ranaCard

    -- Restore saved position
    if savedProgressBarPos then
        ranaCard.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5,
            savedProgressBarPos.XOffset or -135,
            savedProgressBarPos.YScale or 1,
            savedProgressBarPos.YOffset or -75
        )
    end

    -- Dragging: only when Lock UI is OFF
    local dragging, dragStart, startPos, dragConn, dragEndConn = false, nil, nil, nil, nil
    ranaCard.InputBegan:Connect(function(input)
        if uiLocked then return end
        if _isDraggingButton then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = ranaCard.Position
            if dragConn then dragConn:Disconnect() end
            if dragEndConn then dragEndConn:Disconnect() end
            dragConn = UIS.InputChanged:Connect(function(i)
                if not dragging or uiLocked then return end
                if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                    local delta = i.Position - dragStart
                    ranaCard.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            dragEndConn = UIS.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                    if dragging and not uiLocked then
                        savedProgressBarPos = { XScale = ranaCard.Position.X.Scale, XOffset = ranaCard.Position.X.Offset, YScale = ranaCard.Position.Y.Scale, YOffset = ranaCard.Position.Y.Offset }
                        saveAllSettings()
                    end
                    dragging = false
                    if dragConn then dragConn:Disconnect(); dragConn = nil end
                    if dragEndConn then dragEndConn:Disconnect(); dragEndConn = nil end
                end
            end)
        end
    end)

    _G.updateStealBarScale = function()
        if ranaPbScale then ranaPbScale.Scale = (uiScaleValue / 100) * (stealBarSize or 1.0) end
    end

    pbFrame = ranaCard
    _G.RanaStealGui = ranaScreenGui
    return ranaScreenGui
end

-- Build once at startup so the bar always exists and shows up
task.spawn(function()
    for _ = 1, 30 do
        if _G.buildRanaStealBar() then break end
        task.wait(0.2)
    end
end)

_G.updateStealBarScale = function()
    if ranaPbScale then ranaPbScale.Scale = (uiScaleValue / 100) * (stealBarSize or 1.0) end
end

function buildGui()
    local GREY_L = GREY_LIGHT
    local GREY_M = GREY_MID
    local GREY_D = GREY_DARK
    local ROW_BG = Color3.fromRGB(255, 182, 213)
    local ROW_BORDER = GREY_BORDER
    local WHITE = Color3.fromRGB(255,255,255)
    local GRAY = Color3.fromRGB(120, 45, 80)
    local INP = Color3.fromRGB(255, 220, 235)
    local OFF = Color3.fromRGB(255, 182, 213)
    local TAB_ACTIVE = GREY_L
    local TAB_INACT = GREY_D
    local SECT_LBL = GREY_L

    local GUI_W, GUI_H = 330, 480
    local old = game:GetService("CoreGui"):FindFirstChild("Evoraduels")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild("Evoraduels"); if o then o:Destroy() end end
    gui = Instance.new("ScreenGui")
    gui.Name = "Evoraduels"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then gui.Parent = LP:WaitForChild("PlayerGui") end
    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = Color3.fromRGB(255, 182, 213)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://104462721630415"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = GREY_BORDER
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local titleLabel = Instance.new("TextLabel", main)
    titleLabel.Size = UDim2.new(0.6, -30, 0, 40)
    titleLabel.Position = UDim2.new(0, 12, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "EVORA ▼"
    titleLabel.TextColor3 = WHITE
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 26
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextStrokeColor3 = Color3.fromRGB(255, 182, 213)
    titleLabel.TextStrokeTransparency = 0.2
    titleLabel.ZIndex = 20
    applyShimmerToText(titleLabel, 1.2)

    local profileContainer = Instance.new("Frame", main)
    profileContainer.Size = UDim2.new(0, 40, 0, 40)
    profileContainer.Position = UDim2.new(0.5, -20, 0, 8)
    profileContainer.BackgroundTransparency = 1
    profileContainer.ZIndex = 30
    local profileImage = Instance.new("ImageLabel", profileContainer)
    profileImage.Size = UDim2.new(1, 0, 1, 0)
    profileImage.BackgroundColor3 = Color3.fromRGB(255, 182, 213)
    profileImage.BackgroundTransparency = 0.2
    profileImage.BorderSizePixel = 0
    profileImage.Image = "rbxassetid://0"
    profileImage.ScaleType = Enum.ScaleType.Fit
    profileImage.ZIndex = 31
    Instance.new("UICorner", profileImage).CornerRadius = UDim.new(1, 0)
    local profileStroke = Instance.new("UIStroke", profileImage)
    profileStroke.Color = GREY_BORDER
    profileStroke.Thickness = 2

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    closeBtn.BackgroundTransparency = 0.4
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = GREY_BORDER
    closeStroke.Thickness = 1
    closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = GREY_D}):Play() end)
    closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = WHITE, BackgroundColor3 = Color3.fromRGB(255, 105, 180)}):Play() end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 120, 0, 40)
    miniBtn.Position = UDim2.new(0, 16, 0, 16)
    miniBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = Color3.fromRGB(228, 120, 155)
    miniStroke.Thickness = 1.5
    miniStroke.Transparency = 0
    local miniDot = Instance.new("Frame", miniBtn)
    miniDot.Size = UDim2.new(0, 8, 0, 8)
    miniDot.Position = UDim2.new(0, 18, 0.5, -4)
    miniDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    miniDot.BorderSizePixel = 0
    miniDot.ZIndex = 21
    Instance.new("UICorner", miniDot).CornerRadius = UDim.new(1, 0)
    local miniLabel = Instance.new("TextLabel", miniBtn)
    miniLabel.Size = UDim2.new(1, -40, 1, 0)
    miniLabel.Position = UDim2.new(0, 34, 0, 0)
    miniLabel.BackgroundTransparency = 1
    miniLabel.Text = "EVORA ▼"
    miniLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    miniLabel.Font = Enum.Font.GothamBold
    miniLabel.TextSize = 14
    miniLabel.TextXAlignment = Enum.TextXAlignment.Left
    miniLabel.ZIndex = 21
    applyShimmerToText(miniLabel, 0.9)

    showGui = function() if main then main.Visible = true end if miniBtn then miniBtn.Visible = false end end
    hideGui = function() if main then main.Visible = false end if miniBtn then miniBtn.Visible = true end end
    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -24, 0, 28)
    tabBar.Position = UDim2.new(0, 12, 0, 50)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 3)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, -24, 1, -128)
    tabContent.Position = UDim2.new(0, 12, 0, 84)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Moment", "Combat", "Main", "Songs", "Settings", "Keys"}
    local tabButtons = {}
    local contentPages = {}
    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 48, 0, 26)
        btn.BackgroundColor3 = Color3.fromRGB(255, 182, 213)
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_INACT
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = GREY_BORDER
        stroke.Thickness = 1.2
        stroke.Transparency = 0

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundColor3 = Color3.fromRGB(8,8,8)
        page.BackgroundTransparency = 0.85
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = GREY_D
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.None
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        Instance.new("UICorner", page).CornerRadius = UDim.new(0, 16)
        page.Visible = (i == 1)
        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 16)
        local function updateCanvas() local contentSize = layout.AbsoluteContentSize local padBottom = padding.PaddingBottom.Offset local padTop = padding.PaddingTop.Offset local extra = 20 page.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + padTop + padBottom + extra) end
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        task.spawn(updateCanvas)
        contentPages[name] = page
        btn.MouseButton1Click:Connect(function()
            for _, pg2 in pairs(contentPages) do pg2.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do b.TextColor3 = TAB_INACT b.BackgroundColor3 = Color3.fromRGB(255, 182, 213) end
            btn.TextColor3 = TAB_ACTIVE
            btn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
            task.wait(0.05)
            updateCanvas()
        end)
        table.insert(tabButtons, btn)
    end
    if tabButtons[1] then tabButtons[1].TextColor3 = TAB_ACTIVE tabButtons[1].BackgroundColor3 = Color3.fromRGB(255, 105, 180) end

    local pageCounters = {}
    local function getNextOrder(page) if not pageCounters[page] then pageCounters[page] = 0 end pageCounters[page] = pageCounters[page] + 1 return pageCounters[page] end
    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = SECT_LBL
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(255, 182, 213)
        l.TextStrokeTransparency = 0.3
        l.ZIndex = 8
        applyShimmerToText(l, 1.0)
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -24, 0, 1.5)
        line.Position = UDim2.new(0, 12, 1, -4)
        line.BackgroundColor3 = GREY_M
        line.BackgroundTransparency = 0.6
        line.BorderSizePixel = 0
        line.ZIndex = 8
        return f
    end
    local function mkRow(page, h) local f = Instance.new("Frame", page) f.Size = UDim2.new(1, -4, 0, h or 38) f.BackgroundColor3 = ROW_BG f.BackgroundTransparency = 0.3 f.BorderSizePixel = 0 f.LayoutOrder = getNextOrder(page) f.ZIndex = 7 Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10) local rowStroke = Instance.new("UIStroke", f) rowStroke.Color = GREY_BORDER rowStroke.Thickness = 1 rowStroke.Transparency = 0.3 f.MouseEnter:Connect(function() TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play() end) f.MouseLeave:Connect(function() TS:Create(f, TweenInfo.new(0.1), {BackgroundColor3 = ROW_BG}):Play() end) return f end
    local function mkLabel(row, txt) local l = Instance.new("TextLabel", row) l.Size = UDim2.new(0.42, 0, 1, 0) l.Position = UDim2.new(0, 10, 0, 0) l.BackgroundTransparency = 1 l.Text = txt l.TextColor3 = WHITE l.Font = Enum.Font.GothamBold l.TextSize = 11 l.TextXAlignment = Enum.TextXAlignment.Left l.TextTruncate = Enum.TextTruncate.AtEnd l.TextStrokeColor3 = Color3.fromRGB(255, 182, 213) l.TextStrokeTransparency = 0.5 l.ZIndex = 8 return l end
    local function mkPill(row, offset) local pill = Instance.new("Frame", row) pill.Size = UDim2.new(0, 44, 0, 22) pill.Position = UDim2.new(1, -(offset or 52), 0.5, -11) pill.BackgroundColor3 = OFF pill.BorderSizePixel = 0 pill.ZIndex = 8 Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0) local stroke = Instance.new("UIStroke", pill) stroke.Color = GREY_BORDER stroke.Thickness = 1.2 stroke.Transparency = 0.6 local dot = Instance.new("Frame", pill) dot.Size = UDim2.new(0, 16, 0, 16) dot.Position = UDim2.new(0, 3, 0.5, -8) dot.BackgroundColor3 = GRAY dot.BorderSizePixel = 0 dot.ZIndex = 9 Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0) return pill, dot end
    local function animPill(pill, dot, on) TS:Create(pill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = on and GREY_M or OFF}):Play() TS:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), { Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = on and WHITE or GRAY }):Play() local stroke = pill:FindFirstChildOfClass("UIStroke") if stroke then TS:Create(stroke, TweenInfo.new(0.2), {Color = on and GREY_L or GREY_BORDER, Transparency = on and 0 or 0.6}):Play() end end
    local function mkToggle(page, txt, cb) local row = mkRow(page, 38) mkLabel(row, txt) local pill, dot = mkPill(row, 52) local on = false local function sv(s) on = s; animPill(pill, dot, s) end local clk = Instance.new("TextButton", pill) clk.Size = UDim2.new(1,0,1,0) clk.BackgroundTransparency = 1 clk.Text = "" clk.AutoButtonColor = false clk.ZIndex = 10 clk.MouseButton1Click:Connect(function() if editModeEnabled and not uiLocked then pcall(cb, not on) else on = not on sv(on) pcall(cb, on) end end) return sv end
    local function mkSelector(parent, default, options, cb) local container = Instance.new("Frame", parent) container.Size = UDim2.new(0, 130, 1, 0) container.Position = UDim2.new(1, -138, 0, 0) container.BackgroundTransparency = 1 container.ZIndex = 8 local leftBtn = Instance.new("TextButton", container) leftBtn.Size = UDim2.new(0, 26, 0, 26) leftBtn.Position = UDim2.new(0, 0, 0.5, -13) leftBtn.BackgroundColor3 = INP leftBtn.BackgroundTransparency = 0.7 leftBtn.BorderSizePixel = 0 leftBtn.Text = "<" leftBtn.TextColor3 = WHITE leftBtn.Font = Enum.Font.GothamBold leftBtn.TextSize = 13 leftBtn.AutoButtonColor = false leftBtn.ZIndex = 9 Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6) local leftStroke = Instance.new("UIStroke", leftBtn) leftStroke.Color = GREY_BORDER leftStroke.Thickness = 1 local label = Instance.new("TextLabel", container) label.Size = UDim2.new(0, 76, 0, 26) label.Position = UDim2.new(0.5, -38, 0.5, -13) label.BackgroundTransparency = 1 label.Text = default label.TextColor3 = WHITE label.Font = Enum.Font.GothamBold label.TextSize = 11 label.TextXAlignment = Enum.TextXAlignment.Center label.ZIndex = 9 local rightBtn = Instance.new("TextButton", container) rightBtn.Size = UDim2.new(0, 26, 0, 26) rightBtn.Position = UDim2.new(1, -26, 0.5, -13) rightBtn.BackgroundColor3 = INP rightBtn.BackgroundTransparency = 0.7 rightBtn.BorderSizePixel = 0 rightBtn.Text = ">" rightBtn.TextColor3 = WHITE rightBtn.Font = Enum.Font.GothamBold rightBtn.TextSize = 13 rightBtn.AutoButtonColor = false rightBtn.ZIndex = 9 Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6) local rightStroke = Instance.new("UIStroke", rightBtn) rightStroke.Color = GREY_BORDER rightStroke.Thickness = 1 local function updateLabel(newText) label.Text = newText end leftBtn.MouseButton1Click:Connect(function() if cb then cb(-1, updateLabel) end end) rightBtn.MouseButton1Click:Connect(function() if cb then cb(1, updateLabel) end end) return label end
    local function mkBox(parent, default, w, xOff, cb) local tb = Instance.new("TextBox", parent) local bw = w or 50 local xo = math.max(xOff or 56, bw + 12) tb.Size = UDim2.new(0, bw, 0, 24) tb.Position = UDim2.new(1, -xo, 0.5, -12) tb.BackgroundColor3 = INP tb.BackgroundTransparency = 0.7 tb.BorderSizePixel = 0 tb.Text = tostring(default) tb.TextColor3 = WHITE tb.Font = Enum.Font.GothamBold tb.TextSize = 11 tb.ClearTextOnFocus = false tb.ZIndex = 8 Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6) local bs = Instance.new("UIStroke", tb) bs.Color = GREY_BORDER bs.Thickness = 1.2 bs.Transparency = 0.25 tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = GREY_L, Transparency = 0}):Play() end) tb.FocusLost:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = GREY_BORDER, Transparency = 0.25}):Play() if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end end) return tb end
    local function mkSliderRow(page, labelText, getVal, setVal, minV, maxV, step, fmtFn)
        local row = mkRow(page, 38)
        mkLabel(row, labelText)
        local valLbl = Instance.new("TextLabel", row)
        valLbl.Size = UDim2.new(0, 60, 1, 0)
        valLbl.Position = UDim2.new(1, -112, 0, 0)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = fmtFn and fmtFn(getVal()) or tostring(getVal())
        valLbl.TextColor3 = WHITE
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextSize = 12
        valLbl.TextXAlignment = Enum.TextXAlignment.Center
        valLbl.ZIndex = 9
        local minusBtn = Instance.new("TextButton", row)
        minusBtn.Size = UDim2.new(0, 26, 0, 24)
        minusBtn.Position = UDim2.new(1, -144, 0.5, -12)
        minusBtn.BackgroundColor3 = INP
        minusBtn.BackgroundTransparency = 0.4
        minusBtn.BorderSizePixel = 0
        minusBtn.Text = "−"
        minusBtn.TextColor3 = WHITE
        minusBtn.Font = Enum.Font.GothamBlack
        minusBtn.TextSize = 16
        minusBtn.AutoButtonColor = false
        minusBtn.ZIndex = 9
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
        local ms1 = Instance.new("UIStroke", minusBtn) ms1.Color = GREY_BORDER ms1.Thickness = 1
        local plusBtn = Instance.new("TextButton", row)
        plusBtn.Size = UDim2.new(0, 26, 0, 24)
        plusBtn.Position = UDim2.new(1, -46, 0.5, -12)
        plusBtn.BackgroundColor3 = INP
        plusBtn.BackgroundTransparency = 0.4
        plusBtn.BorderSizePixel = 0
        plusBtn.Text = "+"
        plusBtn.TextColor3 = WHITE
        plusBtn.Font = Enum.Font.GothamBlack
        plusBtn.TextSize = 16
        plusBtn.AutoButtonColor = false
        plusBtn.ZIndex = 9
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
        local ms2 = Instance.new("UIStroke", plusBtn) ms2.Color = GREY_BORDER ms2.Thickness = 1
        minusBtn.MouseButton1Click:Connect(function()
            local newVal = math.clamp(getVal() - step, minV, maxV)
            setVal(newVal)
            valLbl.Text = fmtFn and fmtFn(newVal) or tostring(newVal)
        end)
        plusBtn.MouseButton1Click:Connect(function()
            local newVal = math.clamp(getVal() + step, minV, maxV)
            setVal(newVal)
            valLbl.Text = fmtFn and fmtFn(newVal) or tostring(newVal)
        end)
        return valLbl
    end
    local function mkKeyButton(parent, kbEntry) local btn = Instance.new("TextButton", parent) btn.Size = UDim2.new(0, 80, 0, 24) btn.Position = UDim2.new(1, -88, 0.5, -12) btn.BackgroundColor3 = INP btn.BackgroundTransparency = 0.5 btn.BorderSizePixel = 0 local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end btn.Text = getLabel() btn.TextColor3 = WHITE btn.Font = Enum.Font.GothamBold btn.TextSize = 9 btn.ZIndex = 8 btn.AutoButtonColor = false Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) local bs = Instance.new("UIStroke", btn) bs.Color = GREY_BORDER bs.Thickness = 1 local li = false; local lc; local pv = btn.Text; local listenStart = 0 btn.Activated:Connect(function() if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick(); btn.Text = "..."; btn.TextColor3 = WHITE lc = UIS.InputBegan:Connect(function(inp) if not li then return end if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end local isGp = isGamepadInput(inp) if isGp and tick()-listenStart < 0.15 then return end if not isBindableInput(inp) then return end btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end end) end) table.insert(keyButtonRefs, {btn = btn, entry = kbEntry}) return btn end
    local function addKeybindRow(page, labelText, kbEntry) local row = mkRow(page, 36) mkLabel(row, labelText) mkKeyButton(row, kbEntry) end

    local momentPage = contentPages["Moment"]
    mkSect(momentPage, "Speed")
    do local row = mkRow(momentPage, 38); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v end end) end
    do local row = mkRow(momentPage, 38); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v end end) end
    autoCarrySetVisual = mkToggle(momentPage, "Auto Carry", function(on) autoCarryEnabled = on == true; if autoCarryEnabled then speedMode = false; laggerToggled = false; laggerLevel = 1 end; refreshSpeedModeLabel(); saveAllSettings() end)
    do local row = mkRow(momentPage, 38); mkLabel(row, "Lagger 1 Speed"); laggerBox = mkBox(row, LAGGER_SPEED_1, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_1 = v end end) end
    do local row = mkRow(momentPage, 38); mkLabel(row, "Lagger 2 Speed"); lagger2Box = mkBox(row, LAGGER_SPEED_2, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_2 = v end end) end
    do local row = mkRow(momentPage, 38) mkLabel(row, "Current Mode") modeValLbl = Instance.new("TextLabel", row) modeValLbl.Size = UDim2.new(0, 110, 1, 0) modeValLbl.Position = UDim2.new(1, -118, 0, 0) modeValLbl.BackgroundTransparency = 1 modeValLbl.Text = "Normal" modeValLbl.TextColor3 = WHITE modeValLbl.Font = Enum.Font.GothamBlack modeValLbl.TextSize = 11 modeValLbl.TextXAlignment = Enum.TextXAlignment.Right modeValLbl.ZIndex = 8 local clk = Instance.new("TextButton", row) clk.Size = UDim2.new(1,0,1,0) clk.BackgroundTransparency = 1 clk.Text = "" clk.AutoButtonColor = false clk.ZIndex = 8 clk.MouseButton1Click:Connect(function() toggleCarryMode() end) end
    setUnwalkVisual = mkToggle(momentPage, "Unwalk", function(on) unwalkEnabled = on if on then startUnwalk() else stopUnwalk() end end)
    mkSect(momentPage, "Move")
    dropBrainrotSetVisual = mkToggle(momentPage, "Drop Brainrot", function(on) if on then executeDropWithToggle(function(v) dropBrainrotSetVisual(v) if mobSetDropBR then mobSetDropBR(v) end end) end end)
    setDropVisual = dropBrainrotSetVisual
    do local row = mkRow(momentPage, 38) mkLabel(row, "Drop Option") dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update) if dropActive then stopDropBrainrot() end dropMode = dropMode == 1 and 2 or 1 update(dropMode == 1 and "Fling" or "Jump Drop") end) end
    autoLeftSetVisual = mkToggle(momentPage, "Auto Left", function(on) autoLeftEnabled = on if on then startAutoLeft() else stopAutoLeft() end if mobSetAutoLeft then mobSetAutoLeft(on) end end)
    autoRightSetVisual = mkToggle(momentPage, "Auto Right", function(on) autoRightEnabled = on if on then startAutoRight() else stopAutoRight() end if mobSetAutoRight then mobSetAutoRight(on) end end)
    do local row = mkRow(momentPage, 38) mkLabel(row, "TP Down") local clk = Instance.new("TextButton", row) clk.Size = UDim2.new(0.58, 0, 1, 0) clk.BackgroundTransparency = 1 clk.Text = "" clk.AutoButtonColor = false clk.ZIndex = 8 clk.MouseButton1Click:Connect(function() doTpDown() end) local actLbl = Instance.new("TextLabel", row) actLbl.Size = UDim2.new(0, 70, 1, 0) actLbl.Position = UDim2.new(1, -78, 0, 0) actLbl.BackgroundTransparency = 1 actLbl.Text = "ACTIVATE" actLbl.TextColor3 = GREY_L actLbl.Font = Enum.Font.GothamBold actLbl.TextSize = 9 actLbl.TextXAlignment = Enum.TextXAlignment.Right actLbl.ZIndex = 8 end
    setInfJumpVisual = mkToggle(momentPage, "Inf Jump", function(on) InfJumpState.enabled = on saveAllSettings() end)
    if setInfJumpVisual then setInfJumpVisual(InfJumpState.enabled) end
    do
        local row = mkRow(momentPage, 38)
        mkLabel(row, "Inf Jump Mode")
        local _, updateModeLbl = mkSelector(row, InfJumpState.mode == "hold" and "Hold" or "Normal", {"Normal", "Hold"}, function(dir, updateLabel)
            if InfJumpState.mode == "hold" then
                InfJumpState.mode = "normal"
            else
                InfJumpState.mode = "hold"
            end
            updateLabel(InfJumpState.mode == "hold" and "Hold" or "Normal")
            saveAllSettings()
        end)
        _G.updateInfJumpModeLabel = updateModeLbl
    end

    local combatPage = contentPages["Combat"]
    mkSect(combatPage, "Bat Aimbots")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on) if on then enableAutoBat() else disableAutoBat() end if mobSetAutoBat then mobSetAutoBat(on) end end)
    do local row = mkRow(combatPage, 38); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 56, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end
    tpLockSetVisual = mkToggle(combatPage, "TP BAT V1", function(on) if on then if not _G.AceAntiDesyncAimbotOn then startAntiDesyncAimbot() end else if _G.AceAntiDesyncAimbotOn then stopAntiDesyncAimbot() end end end)
    if tpLockSetVisual then tpLockSetVisual(_G.AceAntiDesyncAimbotOn) end
    autoBatV2SetVisual = mkToggle(combatPage, "Bat V2", function(on) if on then enableBatV2() else disableBatV2() end end)
    if autoBatV2SetVisual then autoBatV2SetVisual(autoBatV2Enabled) end
    mkSect(combatPage, "Auto Grab")
    setInstaGrab = mkToggle(combatPage, "Auto Grab", function(on) if on then pcall(startAutoSteal) else stopAutoSteal() end updateProgressBarVisibility() end)
    if setInstaGrab then setInstaGrab(true) end
    do local row = mkRow(combatPage, 38) mkLabel(row, "Grab Radius") radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v) if v and v >= 5 and v <= 300 then CONFIG.STEAL_RANGE = math.floor(v+0.5) AdaptSteal.StealRadius = CONFIG.STEAL_RANGE radInput.Text = tostring(CONFIG.STEAL_RANGE) end end) end
    do local row = mkRow(combatPage, 38); mkLabel(row, "Auto Steal Mode"); local modeLabel = mkSelector(row, AdaptSteal.Mode == "73" and "73" or "Normal", {"Normal", "73"}, function(direction, updateLabel) AdaptSteal.Mode = AdaptSteal.Mode == "normal" and "73" or "normal"; updateLabel(AdaptSteal.Mode == "73" and "73" or "Normal"); saveAllSettings() end) end
    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on) batCounterEnabled = on if on then startBatCounter() else stopBatCounter() end end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on) setMedusaCounterState(on) end)
    mkSect(combatPage, "Defense")
    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on) setAntiRag(on) end)
    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on) toggleAntiDie(on) end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end
    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on) bodyLockEnabled = on if on then if _blSuppressCount == 0 then startBodyLock() end else stopBodyLock() end end)
    do local row = mkRow(combatPage, 38) mkLabel(row, "Body Lock Range") bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v) if v and v > 0 then bodyLockRange = math.clamp(math.floor(v), 5, 200) if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end end end) end

    local mainPage = contentPages["Main"]
    mkSect(mainPage, "Interface")
    setEditModeVisual = mkToggle(mainPage, "Unlock Buttons", function(on) toggleEditMode(on) if on and uiLocked then editModeEnabled = false setEditModeVisual(false) end end)
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
    setLockUIVisual = mkToggle(mainPage, "Lock UI", function(on) toggleLockUI(on) if on and editModeEnabled then editModeEnabled = false if setEditModeVisual then setEditModeVisual(false) end end end)
    setESPVIsual = mkToggle(mainPage, "Player ESP", function(on) toggleESP(on) end)
    setAntiLagVisual = mkToggle(mainPage, "Anti Lag", function(on) if on then enableAntiLag() else disableAntiLag() end end)
    setNeonWeatherVisual = mkToggle(mainPage, "☁ Sky Theme", function(on) toggleNeonWeather(on) end)
    if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end
    do local row = mkRow(mainPage, 38) mkLabel(row, "Stretch Rez") local expandBtn = Instance.new("TextButton", row) expandBtn.Size = UDim2.new(0, 28, 0, 22) expandBtn.Position = UDim2.new(0.58, 0, 0.5, -11) expandBtn.BackgroundColor3 = INP expandBtn.BackgroundTransparency = 0.7 expandBtn.BorderSizePixel = 0 expandBtn.Text = "▶" expandBtn.TextColor3 = WHITE expandBtn.Font = Enum.Font.GothamBold expandBtn.TextSize = 14 expandBtn.AutoButtonColor = false expandBtn.ZIndex = 9 Instance.new("UICorner", expandBtn).CornerRadius = UDim.new(0, 6) local expandStroke = Instance.new("UIStroke", expandBtn) expandStroke.Color = GREY_BORDER expandStroke.Thickness = 1 local stretchPill, stretchDot = mkPill(row, 52) local stretchOn = false local function setStretch(s) stretchOn = s animPill(stretchPill, stretchDot, s) if s then enableStretch() else disableStretch() end stretchEnabled = s end local stretchClk = Instance.new("TextButton", stretchPill) stretchClk.Size = UDim2.new(1,0,1,0) stretchClk.BackgroundTransparency = 1 stretchClk.Text = "" stretchClk.AutoButtonColor = false stretchClk.ZIndex = 10 stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end) _G.stretchToggleSetter = setStretch fovContainer = Instance.new("Frame", mainPage) fovContainer.Size = UDim2.new(1, -4, 0, 38) fovContainer.BackgroundColor3 = ROW_BG fovContainer.BackgroundTransparency = 0.3 fovContainer.BorderSizePixel = 0 fovContainer.LayoutOrder = getNextOrder(mainPage) fovContainer.ZIndex = 7 fovContainer.Visible = false Instance.new("UICorner", fovContainer).CornerRadius = UDim.new(0, 10) local fovStroke = Instance.new("UIStroke", fovContainer) fovStroke.Color = GREY_BORDER fovStroke.Thickness = 1 fovStroke.Transparency = 0.3 local fovLabel = Instance.new("TextLabel", fovContainer) fovLabel.Size = UDim2.new(0.25, 0, 1, 0) fovLabel.Position = UDim2.new(0, 10, 0, 0) fovLabel.BackgroundTransparency = 1 fovLabel.Text = "FOV" fovLabel.TextColor3 = WHITE fovLabel.Font = Enum.Font.GothamBold fovLabel.TextSize = 11 fovLabel.TextXAlignment = Enum.TextXAlignment.Left fovLabel.TextStrokeColor3 = Color3.fromRGB(255, 182, 213) fovLabel.TextStrokeTransparency = 0.5 fovLabel.ZIndex = 8 local fovBtnFrame = Instance.new("Frame", fovContainer) fovBtnFrame.Size = UDim2.new(0, 150, 1, 0) fovBtnFrame.Position = UDim2.new(1, -162, 0, 0) fovBtnFrame.BackgroundTransparency = 1 fovBtnFrame.ZIndex = 8 local function makeFOVBtn(val, x) local btn = Instance.new("TextButton", fovBtnFrame) btn.Size = UDim2.new(0, 42, 0, 26) btn.Position = UDim2.new(0, x, 0.5, -13) btn.BackgroundColor3 = INP btn.BackgroundTransparency = 0.7 btn.BorderSizePixel = 0 btn.Text = tostring(val) btn.TextColor3 = WHITE btn.Font = Enum.Font.GothamBold btn.TextSize = 11 btn.AutoButtonColor = false btn.ZIndex = 9 Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6) local stroke = Instance.new("UIStroke", btn) stroke.Color = GREY_BORDER stroke.Thickness = 1 if val == stretchFOV then btn.BackgroundColor3 = GREY_M btn.TextColor3 = Color3.fromRGB(255, 182, 213) end btn.MouseButton1Click:Connect(function() stretchFOV = val if stretchEnabled then applyStretchFOV(val) end for _, b in ipairs(fovBtnFrame:GetChildren()) do if b:IsA("TextButton") then local v = tonumber(b.Text) if v == val then b.BackgroundColor3 = GREY_M b.TextColor3 = Color3.fromRGB(255, 182, 213) else b.BackgroundColor3 = INP b.TextColor3 = WHITE end end end end) return btn end makeFOVBtn(90, 0) makeFOVBtn(120, 54) makeFOVBtn(180, 108) _G.fovButtons = fovBtnFrame:GetChildren() local function toggleFov() fovContainer.Visible = not fovContainer.Visible expandBtn.Text = fovContainer.Visible and "▼" or "▶" end expandBtn.MouseButton1Click:Connect(toggleFov) fovToggleBtn = expandBtn end
    mkSect(mainPage, "Personalización")
    do local row = mkRow(mainPage, 38) mkLabel(row, "Anim Pack") local currentIndex = 1 for i, entry in ipairs(ANIM_PACK_ORDER) do if entry[2] == currentAnimPack then currentIndex = i; break end end local container = Instance.new("Frame", row) container.Size = UDim2.new(0, 130, 1, 0) container.Position = UDim2.new(1, -138, 0, 0) container.BackgroundTransparency = 1 container.ZIndex = 8 local leftBtn = Instance.new("TextButton", container) leftBtn.Size = UDim2.new(0, 26, 0, 26) leftBtn.Position = UDim2.new(0, 0, 0.5, -13) leftBtn.BackgroundColor3 = INP leftBtn.BackgroundTransparency = 0.7 leftBtn.BorderSizePixel = 0 leftBtn.Text = "<" leftBtn.TextColor3 = WHITE leftBtn.Font = Enum.Font.GothamBold leftBtn.TextSize = 13 leftBtn.AutoButtonColor = false leftBtn.ZIndex = 9 Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6) local leftStroke = Instance.new("UIStroke", leftBtn) leftStroke.Color = GREY_BORDER leftStroke.Thickness = 1 animSelectorLabel = Instance.new("TextLabel", container) animSelectorLabel.Size = UDim2.new(0, 76, 0, 26) animSelectorLabel.Position = UDim2.new(0.5, -38, 0.5, -13) animSelectorLabel.BackgroundTransparency = 1 animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2] animSelectorLabel.TextColor3 = WHITE animSelectorLabel.Font = Enum.Font.GothamBold animSelectorLabel.TextSize = 12 animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center animSelectorLabel.ZIndex = 9 local rightBtn = Instance.new("TextButton", container) rightBtn.Size = UDim2.new(0, 26, 0, 26) rightBtn.Position = UDim2.new(1, -26, 0.5, -13) rightBtn.BackgroundColor3 = INP rightBtn.BackgroundTransparency = 0.7 rightBtn.BorderSizePixel = 0 rightBtn.Text = ">" rightBtn.TextColor3 = WHITE rightBtn.Font = Enum.Font.GothamBold rightBtn.TextSize = 13 rightBtn.AutoButtonColor = false rightBtn.ZIndex = 9 Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6) local rightStroke = Instance.new("UIStroke", rightBtn) rightStroke.Color = GREY_BORDER rightStroke.Thickness = 1 local function updateAnimSelector(direction) local idx = 1 for i, entry in ipairs(ANIM_PACK_ORDER) do if entry[2] == currentAnimPack then idx = i; break end end local newIdx = idx + direction if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end local packName = ANIM_PACK_ORDER[newIdx][2] if packName == "Off" then stopAnimPack() else startAnimPack(packName) end end leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end) rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end) end
    mkSect(mainPage, "Avatar")
    local AVATAR_PRESETS = {
        ["Outfit 1"] = { rana = true },
        ["Outfit 2"] = { rana = true },
        ["Outfit 3"] = { rana = true },
        ["Mario"] = {
            accessory = 171618720419916,
            offset = Vector3.new(0.0000, 0.4000, 0.0000),
            extraAccessories = {
                { id = 139351398622115, offset = Vector3.new(0.0000, 0.5000, 0.0000) },
                { id = 82096325611784,  offset = Vector3.new(0.0000, 0.5000, 0.0000) },
                { id = 9037800691,      offset = Vector3.new(0.0000, 0.5000, 0.0000) },
            },
            shirt = "http://www.roblox.com/asset/?id=1587537",
            pants = "http://www.roblox.com/asset/?id=108351469837493",
        },
        ["8 bit royal"] = {
            accessory = 93016120692476,
            offset = Vector3.new(0.0000, 0.4000, 0.0000),
        },
    }
    local AVATAR_ORDER = {"Outfit 1", "Outfit 2", "Outfit 3", "Mario", "8 bit royal"}
    local function _applyAccessory(char, assetId, offset, scale)
        local okLoad, model = pcall(function()
            return game:GetService("InsertService"):LoadAsset(assetId)
        end)
        if okLoad and model then
            local applied = false
            for _, item in ipairs(model:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Hat") then
                    item.Parent = char
                    applied = true
                    break
                end
            end
            model:Destroy()
            if applied then return end
        end
        local acc = Instance.new("Accessory")
        acc.Parent = char
        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 1)
        handle.Transparency = 1
        handle.CanCollide = false
        handle.Massless = true
        handle.Parent = acc
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://" .. tostring(assetId)
        if scale then mesh.Scale = scale end
        mesh.Parent = handle
        local head = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if head then
            local weld = Instance.new("Weld")
            weld.Part0 = handle
            weld.Part1 = head
            weld.C0 = CFrame.new(offset)
            weld.Parent = handle
        end
    end

    local function _applyKorblox(char, side)
        if not side then return end
        local legName = (side == "right") and "Right Leg" or "Left Leg"
        local leg = char:FindFirstChild(legName)
        if not leg then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local rigType = hum and hum.RigType
            if rigType == Enum.HumanoidRigType.R15 then
                legName = (side == "right") and "RightUpperLeg" or "LeftUpperLeg"
                leg = char:FindFirstChild(legName)
            end
        end
        if not leg then return end
        for _, d in ipairs(leg:GetChildren()) do
            if d:IsA("SpecialMesh") or d:IsA("Mesh") then d:Destroy() end
        end
        local m = Instance.new("SpecialMesh")
        m.MeshType = Enum.MeshType.FileMesh
        m.MeshId = "rbxassetid://" .. tostring(KORBLOX_ASSET_ID)
        m.Parent = leg
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then
                local n = obj.Name:lower()
                if n:find("korblox") then obj:Destroy() end
            end
        end
    end

    local function _applyAvatar(presetName)
        local preset = AVATAR_PRESETS[presetName]
        if not preset then return end
        -- Route Outfit 1/2/3 through the RANA outfit system
        if preset.rana then
            pcall(function() _G.RanaOutfit:set(presetName) end)
            return
        end
        local char = LP.Character
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy() end
        end
        pcall(function()
            for _, obj in ipairs(char:GetChildren()) do
                if obj.Name:lower():find("korblox") then obj:Destroy() end
            end
        end)
        local head = char:FindFirstChild("Head")
        if head and preset.headMesh then
            local existingMesh = head:FindFirstChildOfClass("SpecialMesh")
            if existingMesh then existingMesh:Destroy() end
            local m = Instance.new("SpecialMesh")
            m.MeshType = Enum.MeshType.FileMesh
            m.MeshId = preset.headMesh
            m.TextureId = preset.headTexture
            m.Parent = head
        end
        if preset.shirt then
            local shirt = char:FindFirstChildOfClass("Shirt") or Instance.new("Shirt", char)
            shirt.ShirtTemplate = preset.shirt
        end
        if preset.pants then
            local pants = char:FindFirstChildOfClass("Pants") or Instance.new("Pants", char)
            pants.PantsTemplate = preset.pants
        end
        if preset.accessory then
            pcall(function() _applyAccessory(char, preset.accessory, preset.offset, preset.accessoryScale) end)
        end
        if preset.extraAccessories then
            for _, acc in ipairs(preset.extraAccessories) do
                pcall(function() _applyAccessory(char, acc.id, acc.offset, acc.scale) end)
            end
        end
        if preset.korblox then
            pcall(function() _applyKorblox(char, preset.korblox) end)
        end
    end
    do local row = mkRow(mainPage, 38) mkLabel(row, "Avatar Preset") local container = Instance.new("Frame", row) container.Size = UDim2.new(0, 130, 1, 0) container.Position = UDim2.new(1, -138, 0, 0) container.BackgroundTransparency = 1 container.ZIndex = 8 local leftBtn = Instance.new("TextButton", container) leftBtn.Size = UDim2.new(0, 26, 0, 26) leftBtn.Position = UDim2.new(0, 0, 0.5, -13) leftBtn.BackgroundColor3 = INP leftBtn.BackgroundTransparency = 0.7 leftBtn.BorderSizePixel = 0 leftBtn.Text = "<" leftBtn.TextColor3 = WHITE leftBtn.Font = Enum.Font.GothamBold leftBtn.TextSize = 13 leftBtn.AutoButtonColor = false leftBtn.ZIndex = 9 Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6) local leftStroke = Instance.new("UIStroke", leftBtn) leftStroke.Color = GREY_BORDER leftStroke.Thickness = 1 local avatarLabel = Instance.new("TextLabel", container) avatarLabel.Size = UDim2.new(0, 76, 0, 26) avatarLabel.Position = UDim2.new(0.5, -38, 0.5, -13) avatarLabel.BackgroundTransparency = 1 avatarLabel.Text = AVATAR_ORDER[_avatarCurrentIndex] or AVATAR_ORDER[1] avatarLabel.TextColor3 = WHITE avatarLabel.Font = Enum.Font.GothamBold avatarLabel.TextSize = 12 avatarLabel.TextXAlignment = Enum.TextXAlignment.Center avatarLabel.ZIndex = 9 local rightBtn = Instance.new("TextButton", container) rightBtn.Size = UDim2.new(0, 26, 0, 26) rightBtn.Position = UDim2.new(1, -26, 0.5, -13) rightBtn.BackgroundColor3 = INP rightBtn.BackgroundTransparency = 0.7 rightBtn.BorderSizePixel = 0 rightBtn.Text = ">" rightBtn.TextColor3 = WHITE rightBtn.Font = Enum.Font.GothamBold rightBtn.TextSize = 13 rightBtn.AutoButtonColor = false rightBtn.ZIndex = 9 Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6) local rightStroke = Instance.new("UIStroke", rightBtn) rightStroke.Color = GREY_BORDER rightStroke.Thickness = 1 local function cycle(dir) _avatarCurrentIndex = _avatarCurrentIndex + dir if _avatarCurrentIndex < 1 then _avatarCurrentIndex = #AVATAR_ORDER end if _avatarCurrentIndex > #AVATAR_ORDER then _avatarCurrentIndex = 1 end avatarLabel.Text = AVATAR_ORDER[_avatarCurrentIndex] saveAllSettings() end leftBtn.MouseButton1Click:Connect(function() cycle(-1) end) rightBtn.MouseButton1Click:Connect(function() cycle(1) end) end
    do local row = mkRow(mainPage, 44) row.Size = UDim2.new(1, 0, 0, 44) local applyBtn = Instance.new("TextButton", row) applyBtn.Size = UDim2.new(1, -12, 0.8, 0) applyBtn.Position = UDim2.new(0, 6, 0.1, 0) applyBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) applyBtn.BackgroundTransparency = 0.4 applyBtn.BorderSizePixel = 0 applyBtn.Text = "APPLY AVATAR" applyBtn.TextColor3 = WHITE applyBtn.Font = Enum.Font.GothamBold applyBtn.TextSize = 13 applyBtn.AutoButtonColor = false applyBtn.ZIndex = 8 Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 8) local applyStroke = Instance.new("UIStroke", applyBtn) applyStroke.Color = GREY_BORDER applyStroke.Thickness = 1.2 applyStroke.Transparency = 0.3 applyBtn.MouseButton1Click:Connect(function() local name = AVATAR_ORDER[_avatarCurrentIndex] pcall(_applyAvatar, name) applyBtn.Text = "APPLIED: " .. name task.delay(1.2, function() if applyBtn and applyBtn.Parent then applyBtn.Text = "APPLY AVATAR" end end) end) end

    local songsPage = contentPages["Songs"]
    mkSect(songsPage, "Songs")
    local function makeSongRow(page, labelText, soundId, isExternal, cacheName, startPos)
        local row = mkRow(page, 38)
        mkLabel(row, labelText)
        local playBtn = Instance.new("TextButton", row)
        playBtn.Size = UDim2.new(0, 80, 0, 24)
        playBtn.Position = UDim2.new(1, -88, 0.5, -12)
        playBtn.BackgroundColor3 = INP
        playBtn.BackgroundTransparency = 0.5
        playBtn.BorderSizePixel = 0
        playBtn.Text = "PLAY"
        playBtn.TextColor3 = WHITE
        playBtn.Font = Enum.Font.GothamBold
        playBtn.TextSize = 10
        playBtn.AutoButtonColor = false
        playBtn.ZIndex = 8
        Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 6)
        local playStroke = Instance.new("UIStroke", playBtn)
        playStroke.Color = GREY_BORDER
        playStroke.Thickness = 1
        local state = { sound = nil, playing = false }
        local function stopSong()
            state.playing = false
            if state.sound then
                pcall(function() state.sound.Volume = 0 end)
                pcall(function() state.sound:Stop() end)
                pcall(function() state.sound:Destroy() end)
                state.sound = nil
            end
            playBtn.Text = "PLAY"
            playBtn.BackgroundColor3 = INP
            playBtn.TextColor3 = WHITE
        end
        local function startSong()
            if state.playing then stopSong() return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if not root then return end
            if state.sound then pcall(function() state.sound:Destroy() end) state.sound = nil end
            local snd = Instance.new("Sound")
            snd.Name = "EvoraduelsSong_" .. labelText
            snd.Volume = 1
            snd.Looped = false
            snd.Parent = root
            local finalId = soundId
            if isExternal then
                local ok = false
                if getcustomasset and writefile and isfile then
                    if not isfile(cacheName) then
                        local okDl, data = pcall(function() return game:HttpGet(soundId) end)
                        if okDl and data then pcall(writefile, cacheName, data) end
                    end
                    if isfile(cacheName) then
                        local okA, asset = pcall(getcustomasset, cacheName)
                        if okA and asset then finalId = asset; ok = true end
                    end
                end
                if not ok then finalId = soundId end
            end
            snd.SoundId = finalId
            if startPos then snd.TimePosition = startPos end
            local ref = snd
            snd:Play()
            state.sound = snd
            state.playing = true
            playBtn.Text = "STOP"
            playBtn.BackgroundColor3 = GREY_M
            playBtn.TextColor3 = Color3.fromRGB(255, 182, 213)
            snd.Ended:Connect(function()
                if state.sound == ref and state.playing then stopSong() end
            end)
        end
        playBtn.MouseButton1Click:Connect(function()
            if state.playing then stopSong() else startSong() end
        end)
    end
    makeSongRow(songsPage, "misery", "rbxassetid://121397051787416", false, nil, 35)
    makeSongRow(songsPage, "meant to be", "rbxassetid://126576350082922", false, nil, 23)
    makeSongRow(songsPage, "sorrow", "rbxassetid://88523902860927", false, nil, 13)
    makeSongRow(songsPage, "lucid dreams", "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3", true, "Evoraduels_lucid.mp3", nil)
    makeSongRow(songsPage, "took her to the o", "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3", true, "Evoraduels_von.mp3", nil)
    makeSongRow(songsPage, "beretta", "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3", true, "Evoraduels_beretta.mp3", nil)

    local settingsPage = contentPages["Settings"]
    mkSect(settingsPage, "Appearance")
    local EvoraduelsFontStyles = {"Gotham", "GothamBold", "SourceSans", "SourceSansBold", "Arial", "ArialBold", "Roboto", "RobotoMono", "Ubuntu", "Fantasy", "Antique", "Arcade", "Code", "Creepster", "Bodoni", "Cartoon", "SciFi", "Highway", "Legacy"}
    _G.EvoraduelsFontName = _G.EvoraduelsFontName or "GothamBold"
    local function applyEvoraduelsFont(fontName)
        fontName = fontName or _G.EvoraduelsFontName or "GothamBold"
        local fontEnum
        pcall(function() fontEnum = Enum.Font[fontName] end)
        if not fontEnum then return end
        _G.EvoraduelsFontName = fontName

        local function applyToContainer(container)
            if not container then return end
            pcall(function()
                for _, d in ipairs(container:GetDescendants()) do
                    if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                        pcall(function() d.Font = fontEnum end)
                    end
                end
            end)
        end

        applyToContainer(gui)
        applyToContainer(MobilePanel)
        applyToContainer(tpBatFloatingButton)
        applyToContainer(batV2FloatingButton)
        if _G.RanaStealGui then applyToContainer(_G.RanaStealGui) end
    end
    _G.applyEvoraduelsFont = applyEvoraduelsFont
    do local row = mkRow(settingsPage, 38); mkLabel(row, "Custom Font"); local idx = 1; for i, nm in ipairs(EvoraduelsFontStyles) do if nm == _G.EvoraduelsFontName then idx = i break end end; mkSelector(row, EvoraduelsFontStyles[idx], EvoraduelsFontStyles, function(direction, updateLabel) idx = ((idx - 1 + direction) % #EvoraduelsFontStyles) + 1; applyEvoraduelsFont(EvoraduelsFontStyles[idx]); updateLabel(EvoraduelsFontStyles[idx]); saveAllSettings() end) end
    applyEvoraduelsFont(_G.EvoraduelsFontName)
    mkSect(settingsPage, "Interface")
    mkSliderRow(settingsPage, "UI Scale", function() return uiScaleValue end, function(v) uiScaleValue = v if mainUIScale then mainUIScale.Scale = v / 100 end if pbScale then pbScale.Scale = (v / 100) * stealBarSize end if _G.updateStealBarScale then _G.updateStealBarScale() end end, 50, 150, 5, function(v) return tostring(v) .. "%" end)
    mkSliderRow(settingsPage, "Button Size", function() return math.floor(mobileButtonSize * 100 + 0.5) end, function(v) mobileButtonSize = v / 100 if _G.updateMobileButtonScale then _G.updateMobileButtonScale() end if _G.tpBatUIScale then _G.tpBatUIScale.Scale = mobileButtonSize end if _G.batV2UIScale then _G.batV2UIScale.Scale = mobileButtonSize end end, 60, 200, 5, function(v) return tostring(v) .. "%" end)
    mkSliderRow(settingsPage, "Steal Bar Size", function() return math.floor((stealBarSize or 1.0) * 100 + 0.5) end, function(v) stealBarSize = v / 100 if _G.updateStealBarScale then _G.updateStealBarScale() end saveAllSettings() end, 50, 200, 5, function(v) return tostring(v) .. "%" end)
    mkSect(settingsPage, "Config")
    do local row = mkRow(settingsPage, 44) row.Size = UDim2.new(1, 0, 0, 44) local saveBtn = Instance.new("TextButton", row) saveBtn.Size = UDim2.new(1, -12, 0.8, 0) saveBtn.Position = UDim2.new(0, 6, 0.1, 0) saveBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) saveBtn.BackgroundTransparency = 0.4 saveBtn.BorderSizePixel = 0 saveBtn.Text = "SAVE NOW" saveBtn.TextColor3 = WHITE saveBtn.Font = Enum.Font.GothamBold saveBtn.TextSize = 13 saveBtn.AutoButtonColor = false saveBtn.ZIndex = 8 Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8) local saveStroke = Instance.new("UIStroke", saveBtn) saveStroke.Color = GREY_BORDER saveStroke.Thickness = 1.2 saveStroke.Transparency = 0.3 saveBtn.MouseButton1Click:Connect(function() local ok = saveAllSettings() saveBtn.Text = ok and "SAVED ✓" or "ERROR" task.delay(1.2, function() if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE NOW" end end) end) end
    do local row = mkRow(settingsPage, 44) row.Size = UDim2.new(1, 0, 0, 44) local resetPosBtn = Instance.new("TextButton", row) resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0) resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0) resetPosBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) resetPosBtn.BackgroundTransparency = 0.4 resetPosBtn.BorderSizePixel = 0 resetPosBtn.Text = "RESET POSITIONS" resetPosBtn.TextColor3 = WHITE resetPosBtn.Font = Enum.Font.GothamBold resetPosBtn.TextSize = 13 resetPosBtn.AutoButtonColor = false resetPosBtn.ZIndex = 8 Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 8) local resetStroke = Instance.new("UIStroke", resetPosBtn) resetStroke.Color = GREY_BORDER resetStroke.Thickness = 1.2 resetStroke.Transparency = 0.3 local resetDebounce = false resetPosBtn.MouseButton1Click:Connect(function() if resetDebounce then return end resetDebounce = true resetFloatingPositions() resetPosBtn.Text = "RESET ✓" task.delay(1.2, function() if resetPosBtn and resetPosBtn.Parent then resetPosBtn.Text = "RESET POSITIONS" resetDebounce = false end end) end) end
    do local row = mkRow(settingsPage, 44) row.Size = UDim2.new(1, 0, 0, 44) local delBtn = Instance.new("TextButton", row) delBtn.Size = UDim2.new(1, -12, 0.8, 0) delBtn.Position = UDim2.new(0, 6, 0.1, 0) delBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 213) delBtn.BackgroundTransparency = 0.4 delBtn.BorderSizePixel = 0 delBtn.Text = "DELETE SETTINGS" delBtn.TextColor3 = WHITE delBtn.Font = Enum.Font.GothamBold delBtn.TextSize = 13 delBtn.AutoButtonColor = false delBtn.ZIndex = 8 Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 8) local delStroke = Instance.new("UIStroke", delBtn) delStroke.Color = GREY_BORDER delStroke.Thickness = 1.2 delStroke.Transparency = 0.3 local deleteState = 0 local originalDeleteText = "DELETE SETTINGS" local delDebounce = false delBtn.MouseButton1Click:Connect(function() if delDebounce then return end if deleteState == 0 then deleteState = 1 delBtn.Text = "CONFIRM?" delBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) task.delay(2, function() if delBtn and delBtn.Parent and deleteState == 1 then deleteState = 0 delBtn.Text = originalDeleteText delBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 213) end end) elseif deleteState == 1 then delDebounce = true local success = pcall(resetToFactoryDefaults) delBtn.Text = success and "DELETED ✓" or "ERROR" delBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 213) deleteState = 0 task.delay(1.5, function() if delBtn and delBtn.Parent then delBtn.Text = originalDeleteText delBtn.BackgroundColor3 = Color3.fromRGB(255, 182, 213) delDebounce = false end end) end end) end

    local keyPage = contentPages["Keys"]
    mkSect(keyPage, "Keybinds")
    do local row = mkRow(keyPage, 44) row.Size = UDim2.new(1, 0, 0, 44) local resetKbBtn = Instance.new("TextButton", row) resetKbBtn.Size = UDim2.new(1, -12, 0.8, 0) resetKbBtn.Position = UDim2.new(0, 6, 0.1, 0) resetKbBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) resetKbBtn.BackgroundTransparency = 0.4 resetKbBtn.BorderSizePixel = 0 resetKbBtn.Text = "RESET ALL KEYBINDS" resetKbBtn.TextColor3 = WHITE resetKbBtn.Font = Enum.Font.GothamBold resetKbBtn.TextSize = 13 resetKbBtn.AutoButtonColor = false resetKbBtn.ZIndex = 8 Instance.new("UICorner", resetKbBtn).CornerRadius = UDim.new(0, 8) local rkStroke = Instance.new("UIStroke", resetKbBtn) rkStroke.Color = GREY_BORDER rkStroke.Thickness = 1.2 rkStroke.Transparency = 0.3 local rkState = 0 local rkDebounce = false resetKbBtn.MouseButton1Click:Connect(function() if rkDebounce then return end if rkState == 0 then rkState = 1 resetKbBtn.Text = "CONFIRM RESET?" resetKbBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) task.delay(2, function() if resetKbBtn and resetKbBtn.Parent and rkState == 1 then rkState = 0 resetKbBtn.Text = "RESET ALL KEYBINDS" resetKbBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) end end) elseif rkState == 1 then rkDebounce = true rkState = 0 for key, val in pairs(DEFAULT_KB) do if KB[key] then KB[key].kb = val.kb KB[key].gp = val.gp end end for _, ref in ipairs(keyButtonRefs) do local entry = ref.entry local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None" ref.btn.Text = label end saveAllSettings() resetKbBtn.Text = "RESET ✓" resetKbBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) task.delay(1.5, function() if resetKbBtn and resetKbBtn.Parent then resetKbBtn.Text = "RESET ALL KEYBINDS" resetKbBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) rkDebounce = false end end) end end) end
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "TP BAT", KB.TPLock)
    addKeybindRow(keyPage, "Bat V2", KB.BatV2)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Anti Die", KB.AntiDie)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)
    local spacer = Instance.new("Frame", keyPage) spacer.Size = UDim2.new(1, 0, 0, 16) spacer.BackgroundTransparency = 1 spacer.LayoutOrder = getNextOrder(keyPage) spacer.ZIndex = 7
    task.spawn(function() local userId = LP.UserId local url = profileImageCache[userId] if not url then local success, u = pcall(function() return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) end) if success and u and u ~= "" then url = u profileImageCache[userId] = url else url = "rbxassetid://0" end end if profileImage then profileImage.Image = url end end)
    -- Adapt Steal progress-bar HUD removed; Auto Steal logic remains active.
    drag(main)
end


-- Evoraduels Insta Reset (ported from Rana)
local resetCooldown = false
local resetThread = nil
local currentResetChar = nil
local resetSuccessful = false
local stopResetSequence = false
local cameraLocked = false
local lockedCameraCFrame = nil

local function instaResetFast()
    if resetCooldown then return end
    resetCooldown = true
    resetSuccessful = false
    stopResetSequence = false
    cameraLocked = false

    local character = LP.Character
    if not character then resetCooldown = false return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then resetCooldown = false return end

    local camera = workspace.CurrentCamera
    if camera then
        lockedCameraCFrame = camera.CFrame
        cameraLocked = true
        camera.CFrame = lockedCameraCFrame
    end

    currentResetChar = character
    local isRespawning = false

    resetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = humanoid.HipHeight

        while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not stopResetSequence do
            if LP.Character ~= character then
                isRespawning = true
                break
            end

            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true

                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = false
                end

                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)

            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= maxAttempts then break end
            task.wait(0.05)
        end

        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function()
                    humanoid.Health = 0
                end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    resetSuccessful = true
                end
            end
        end

        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        cameraLocked = false
        resetCooldown = false
        resetThread = nil
        currentResetChar = nil
        stopResetSequence = false
    end)
end

function instaReset()
    instaResetFast()
end


function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "EvoraduelsMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local BTN_W, BTN_H = 60, 60
    local GAP = 8 local COLUMNS = 2 local ROWS = 6
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)
    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(0, 10, 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = false
    container.Selectable = false
    container.ClipsDescendants = false
    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    btnContainer.ClipsDescendants = false
    local INACTIVE_BG = Color3.fromRGB(15, 5, 12)
    local INACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
    local STROKE_COLOR = Color3.fromRGB(255, 105, 180)
    local ACTIVE_BG = Color3.fromRGB(255, 105, 180)
    local ACTIVE_TEXT = Color3.fromRGB(255, 255, 255)
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "InstaReset"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\n1", "LAGGER\n2", "INSTA\nRESET"}
    local function createButton(name, text, order, isToggle, callback)
        local savedPos = savedButtonPositions[name]
        local defX, defY
        if savedPos then defX, defY = savedPos.X or 0, savedPos.Y or 0 else defX, defY = getDefaultButtonPosition(name) end
        local wrapper = Instance.new("Frame", btnContainer)
        wrapper.Name = name .. "_Wrap"
        wrapper.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        wrapper.Position = UDim2.new(0, defX, 0, defY)
        wrapper.BackgroundTransparency = 1 wrapper.BorderSizePixel = 0 wrapper.ZIndex = 9 wrapper.ClipsDescendants = false
        local wrapperScale = Instance.new("UIScale", wrapper)
        wrapperScale.Scale = mobileButtonSize
        local btn = Instance.new("TextButton", wrapper)
        btn.Name = name btn.Size = UDim2.new(1, 0, 1, 0) btn.Position = UDim2.new(0, 0, 0, 0)
        btn.BackgroundColor3 = INACTIVE_BG btn.BorderSizePixel = 0 btn.Text = "" btn.AutoButtonColor = false btn.ZIndex = 10
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = STROKE_COLOR stroke.Thickness = 2 stroke.Transparency = 0 stroke.Name = "NormalStroke"
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1 label.Text = text label.TextColor3 = INACTIVE_TEXT
        label.Font = Enum.Font.GothamBold label.TextSize = 10 label.TextWrapped = true label.ZIndex = 11
        local active = false
        local function setActive(state)
            active = state
            if active then
                btn.BackgroundColor3 = ACTIVE_BG
                label.TextColor3 = ACTIVE_TEXT
                stroke.Color = STROKE_COLOR
                stroke.Transparency = 0
            else
                btn.BackgroundColor3 = INACTIVE_BG
                label.TextColor3 = INACTIVE_TEXT
                stroke.Color = STROKE_COLOR
                stroke.Transparency = 0
            end
        end
        local dragging = false local hasMoved = false local dragStart = nil local startPos = nil local movedDistance = 0
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true hasMoved = false movedDistance = 0 dragStart = input.Position startPos = wrapper.Position _isDraggingButton = true
            end
        end)
        btn.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if editModeEnabled and not uiLocked then
                    hasMoved = true
                    wrapper.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if isToggle then
                            if editModeEnabled and not uiLocked then if callback then callback(function() end) end
                            else if callback then callback(setActive) end end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif editModeEnabled and not uiLocked and hasMoved then
                        savedButtonPositions[name] = { X = wrapper.Position.X.Offset, Y = wrapper.Position.Y.Offset }
                    end
                    dragging = false hasMoved = false dragStart = nil startPos = nil movedDistance = 0 _isDraggingButton = false
                end
            end
        end)
        buttons[name] = {btn = btn, wrapper = wrapper, setActive = setActive, label = label, uiscale = wrapperScale}
        return setActive
    end
    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then callback = function(setActive) if autoBatEnabled then return end setActive(true) executeDropWithToggle(function(v) if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end end) task.delay(0.3, function() setActive(false) end) end
        elseif name == "AutoLeft" then callback = function(setActive) autoLeftEnabled = not autoLeftEnabled setActive(autoLeftEnabled) if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end end
        elseif name == "AutoBat" then callback = function(setActive) if not autoBatEnabled then enableAutoBat() else disableAutoBat() end setActive(autoBatEnabled) end
        elseif name == "AutoRight" then callback = function(setActive) autoRightEnabled = not autoRightEnabled setActive(autoRightEnabled) if autoRightEnabled then startAutoRight() else stopAutoRight() end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end end
        elseif name == "TpDown" then callback = function(setActive) doTpDown() setActive(true) task.delay(0.2, function() setActive(false) end) end
        elseif name == "Carry" then callback = function(setActive) if not speedMode then speedMode = true; laggerToggled = false; laggerLevel = 1; setActive(true) if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end else speedMode = false; setActive(false) end refreshSpeedModeLabel() end
        elseif name == "Lagger1" then callback = function(setActive) if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end if not laggerToggled or laggerLevel ~= 1 then laggerToggled = true; laggerLevel = 1; setActive(true) if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end else laggerToggled = false; laggerLevel = 1; setActive(false) end refreshSpeedModeLabel() end
        elseif name == "InstaReset" then callback = function(setActive) setActive(true); task.spawn(instaReset); task.delay(0.25, function() setActive(false) end) end
         elseif name == "Lagger2" then callback = function(setActive) if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end if not laggerToggled or laggerLevel ~= 2 then laggerToggled = true; laggerLevel = 2; setActive(true) if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end else laggerToggled = false; laggerLevel = 1; setActive(false) end refreshSpeedModeLabel() end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end
    _G.updateMobileButtonScale = function() for _, data in pairs(buttons) do if data.uiscale then data.uiscale.Scale = mobileButtonSize end end end
    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled and laggerLevel == 1) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerToggled and laggerLevel == 2) end
    if savedMobilePanelPos then container.Position = UDim2.new( savedMobilePanelPos.XScale or 0, savedMobilePanelPos.XOffset or 10, savedMobilePanelPos.YScale or 0, savedMobilePanelPos.YOffset or 0 ) end
    local draggingPanel = false local dragStartPos = nil local dragStartMousePos = nil
    container.InputBegan:Connect(function(input)
        if uiLocked or _isDraggingButton or editModeEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingPanel = true dragStartPos = container.Position dragStartMousePos = input.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not draggingPanel or uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStartPos and dragStartMousePos then
                local delta = input.Position - dragStartMousePos
                container.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
            end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if draggingPanel then
                draggingPanel = false
                savedMobilePanelPos = { XScale = container.Position.X.Scale, XOffset = container.Position.X.Offset, YScale = container.Position.Y.Scale, YOffset = container.Position.Y.Offset }
            end
            dragStartPos = nil dragStartMousePos = nil
        end
    end)
    return panel
end

function createTpBatFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local wrapper = Instance.new("Frame", panel)
    wrapper.Name = "Frame"
    wrapper.Size = UDim2.new(0, 60, 0, 60)
    if tpBatFloatingPos then
        wrapper.Position = UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10)
    else
        wrapper.Position = UDim2.new(0.5, 20, 0, 10)
    end
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.ZIndex = 20
    wrapper.ClipsDescendants = false
    local tpScale = Instance.new("UIScale", wrapper)
    tpScale.Name = "SizeScale"
    tpScale.Scale = mobileButtonSize
    _G.tpBatUIScale = tpScale
    local shadow = Instance.new("Frame", wrapper)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 3, 0, 4)
    shadow.BackgroundColor3 = Color3.fromRGB(15, 5, 12)
    shadow.BackgroundTransparency = 0.35
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 20
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 18)
    local btnFrame = Instance.new("Frame", wrapper)
    btnFrame.Size = UDim2.new(1, 0, 1, 0)
    btnFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 12)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 21
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local btnStroke = Instance.new("UIStroke", btnFrame)
    btnStroke.Color = Color3.fromRGB(255, 105, 180)
    btnStroke.Thickness = 2
    btnStroke.Transparency = 0
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21
    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 12)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    _G.updateTPBatMobileVisual = function()
        setActive(_G.AceAntiDesyncAimbotOn)
    end
    local dragging = false
    local hasMoved = false
    local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = inp.Position
            startPos = wrapper.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                wrapper.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleAntiDesyncAimbot()
                    setActive(_G.AceAntiDesyncAimbotOn)
                    saveAllSettings()
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = {
                        XScale = wrapper.Position.X.Scale,
                        XOffset = wrapper.Position.X.Offset,
                        YScale = wrapper.Position.Y.Scale,
                        YOffset = wrapper.Position.Y.Offset
                    }
                    saveAllSettings()
                end
                dragging = false
                hasMoved = false
            end
        end
    end)
    tpBatFloatingButton = panel
    _G.updateTPBatMobileVisual()
    return panel
end

function createBatV2FloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BatV2Button"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 22
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local wrapper = Instance.new("Frame", panel)
    wrapper.Name = "Frame"
    wrapper.Size = UDim2.new(0, 60, 0, 60)
    if batV2FloatingPos then
        wrapper.Position = UDim2.new(batV2FloatingPos.XScale or 0.5, batV2FloatingPos.XOffset or -50, batV2FloatingPos.YScale or 0, batV2FloatingPos.YOffset or 10)
    else
        wrapper.Position = UDim2.new(0.5, -50, 0, 10)
    end
    wrapper.BackgroundTransparency = 1
    wrapper.BorderSizePixel = 0
    wrapper.ZIndex = 20
    wrapper.ClipsDescendants = false

    local v2Scale = Instance.new("UIScale", wrapper)
    v2Scale.Name = "SizeScale"
    v2Scale.Scale = mobileButtonSize
    _G.batV2UIScale = v2Scale

    local shadow = Instance.new("Frame", wrapper)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0, 3, 0, 4)
    shadow.BackgroundColor3 = Color3.fromRGB(15, 5, 12)
    shadow.BackgroundTransparency = 0.35
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 20
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 18)

    local btnFrame = Instance.new("Frame", wrapper)
    btnFrame.Name = "ButtonFrame"
    btnFrame.Size = UDim2.new(1, 0, 1, 0)
    btnFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 12)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 21
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)

    local btnStroke = Instance.new("UIStroke", btnFrame)
    btnStroke.Color = Color3.fromRGB(255, 105, 180)
    btnStroke.Thickness = 2
    btnStroke.Transparency = 0

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BAT\nV2"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            btnFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 12)
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end

    _G.updateBatV2MobileVisual = function()
        setActive(autoBatV2Enabled)
    end

    local dragging = false
    local hasMoved = false
    local dragStart, startPos

    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = inp.Position
            startPos = wrapper.Position
        end
    end)

    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                wrapper.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleBatV2()
                    if _G.updateBatV2MobileVisual then _G.updateBatV2MobileVisual() end
                    saveAllSettings()
                elseif not uiLocked and hasMoved then
                    batV2FloatingPos = {
                        XScale = wrapper.Position.X.Scale,
                        XOffset = wrapper.Position.X.Offset,
                        YScale = wrapper.Position.Y.Scale,
                        YOffset = wrapper.Position.Y.Offset
                    }
                    saveAllSettings()
                end
                dragging = false
                hasMoved = false
            end
        end
    end)

    batV2FloatingButton = panel
    _G.updateBatV2MobileVisual()
    return panel
end

function updateUIFromLoaded() task.wait() if normalBox then normalBox.Text = tostring(NS) end if carryBox then carryBox.Text = tostring(CS) end if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end refreshSpeedModeLabel() for _, ref in ipairs(keyButtonRefs) do local entry = ref.entry local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None" ref.btn.Text = label end if savedProgressBarPos and pbFrame then pbFrame.Position = UDim2.new( savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -170, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -70 ) end if uiLocked and setLockUIVisual then setLockUIVisual(true) end if editModeEnabled and setEditModeVisual then setEditModeVisual(true) end if antiRagdollEnabled and setAntiRagVisual then setAntiRagVisual(true); startAntiRagdoll() end antiDropEnabled = true startAntiDrop() if antiDieEnabled then if setAntiDieVisual then setAntiDieVisual(true) end startAntiDie() end if setInfJumpVisual then setInfJumpVisual(InfJumpState.enabled) end AdaptSteal.AutoStealEnabled = true if setInstaGrab then setInstaGrab(true) end pcall(startAutoSteal) updateProgressBarVisibility() if medusaCounterEnabled then if setMedusaVisual then setMedusaVisual(true) end if LP.Character then setupMedusa(LP.Character) end end if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true) startBatCounter() end if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true); task.spawn(function() task.wait(0.5); startUnwalk() end) end if antiLagEnabled then if setAntiLagVisual then setAntiLagVisual(true) end enableAntiLag() else if setAntiLagVisual then setAntiLagVisual(false) end disableAntiLag() end if espEnabled then toggleESP(true) if setESPVIsual then setESPVIsual(true) end else toggleESP(false) if setESPVIsual then setESPVIsual(false) end end if _G.AceAntiDesyncAimbotOn then if tpLockSetVisual then tpLockSetVisual(true) end if not _G.AceAntiDesync.conn then startAntiDesyncAimbot() end else if tpLockSetVisual then tpLockSetVisual(false) end end if autoBatV2Enabled then if autoBatV2SetVisual then autoBatV2SetVisual(true) end if not _batV2Conn then startBatV2Aimbot() end else if autoBatV2SetVisual then autoBatV2SetVisual(false) end end if neonWeatherEnabled then applyNeonWeather() if setNeonWeatherVisual then setNeonWeatherVisual(true) end else restoreLightingState() if setNeonWeatherVisual then setNeonWeatherVisual(false) end end if stretchEnabled then enableStretch() if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end else if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end end if _G.fovButtons then for _, btn in ipairs(_G.fovButtons) do if btn:IsA("TextButton") then local val = tonumber(btn.Text) if val == stretchFOV then btn.BackgroundColor3 = GREY_MID btn.TextColor3 = Color3.fromRGB(255, 182, 213) else btn.BackgroundColor3 = Color3.fromRGB(255, 182, 213) btn.TextColor3 = Color3.fromRGB(255,255,255) end end end end if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end if mobSetCarry then mobSetCarry(speedMode) end if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end if bodyLockEnabled and bodyLockSetVisual then if _blSuppressCount == 0 then bodyLockSetVisual(true) startBodyLock() else bodyLockSetVisual(false) end end updateProgressBarVisibility() startEnemySpeed() if fovContainer then fovContainer.Visible = false if fovToggleBtn then fovToggleBtn.Text = "▶" end end toggleLockUI(uiLocked) end

buildGui()
-- Retain overhead Rana steal bar progress references
if loadAllSettings() then updateUIFromLoaded() end

antiDropEnabled = true
pcall(startAntiDrop)

AdaptSteal.AutoStealEnabled = true
pcall(startAutoSteal)
if setInstaGrab then setInstaGrab(true) end
updateProgressBarVisibility()

MobilePanel = createMobilePanel()
tpBatFloatingButton = createTpBatFloatingButton()
batV2FloatingButton = createBatV2FloatingButton()
if _G.applyEvoraduelsFont then _G.applyEvoraduelsFont(_G.EvoraduelsFontName) end
if LP.Character then task.wait(0.1) while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do task.wait() end setupMovementAndIndicators(LP.Character) if currentAnimPack ~= "Off" then startAnimPack(currentAnimPack) end end
LP.CharacterAdded:Connect(function(char) stopAutoSteal() stopAutoLeft() stopAutoRight() stopBatCounter() stopMedusaCounter() stopUnwalk() stopDropBrainrot() if autoBatEnabled then disableAutoBat() end if _G.AceAntiDesyncAimbotOn then stopAntiDesyncAimbot() end if autoBatV2Enabled then disableBatV2() end if bodyLockEnabled then stopBodyLock() end cleanupSpeedPhysics() task.wait(0.1) while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do task.wait() end setupMovementAndIndicators(char) AdaptSteal.AutoStealEnabled = true pcall(startAutoSteal) if setInstaGrab then setInstaGrab(true) end updateProgressBarVisibility() antiDropEnabled = true pcall(startAntiDrop) if _G.AceAntiDesyncAimbotOn then task.defer(function() startAntiDesyncAimbot() end) end if autoBatV2Enabled then task.defer(function() startBatV2Aimbot() end) end if antiRagdollEnabled then task.wait(0.5) startAntiRagdoll() end if antiDieEnabled then task.defer(function() startAntiDie() end) end if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end if medusaCounterEnabled then setupMedusa(char) if setMedusaVisual then setMedusaVisual(true) end end if batCounterEnabled then startBatCounter() end if unwalkEnabled then startUnwalk() end if currentAnimPack ~= "Off" then task.wait(0.5) startAnimPack(currentAnimPack) end updateProgressBarVisibility() refreshSpeedModeLabel() end)
local lastLaggerToggle = 0 local LAGGER_COOLDOWN = 0.3 UIS.InputBegan:Connect(function(input, gpe) if _anyKeyListening then return end if input.UserInputType == Enum.UserInputType.Keyboard then if gpe or UIS:GetFocusedTextBox() then return end elseif not isGamepadInput(input) then return end if not isBindableInput(input) then return end local kc = input.KeyCode if not kc then return end if kbMatch(KB.LaggerMode, kc) then if tick() - lastLaggerToggle >= LAGGER_COOLDOWN then lastLaggerToggle = tick() toggleLaggerCycle() end return end if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end if kbMatch(KB.DropBrainrot, kc) then if not dropActive then if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end executeDropWithToggle(dropBrainrotSetVisual) end return end if kbMatch(KB.TPFloor, kc) then doTpDown(); return end if kbMatch(KB.AntiDie, kc) then antiDieEnabled = not antiDieEnabled if antiDieEnabled then startAntiDie() else stopAntiDie() end if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end saveAllSettings() return end if kbMatch(KB.AutoLeft, kc) then autoLeftEnabled = not autoLeftEnabled if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end return end if kbMatch(KB.AutoRight, kc) then autoRightEnabled = not autoRightEnabled if autoRightEnabled then startAutoRight() else stopAutoRight() end if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end return end if kbMatch(KB.AutoBat, kc) then if not autoBatEnabled then enableAutoBat() if autoBatSetVisual then autoBatSetVisual(true) end if mobSetAutoBat then mobSetAutoBat(true) end else disableAutoBat() if autoBatSetVisual then autoBatSetVisual(false) end if mobSetAutoBat then mobSetAutoBat(false) end end return end if kbMatch(KB.TPLock, kc) then toggleAntiDesyncAimbot() if tpLockSetVisual then tpLockSetVisual(_G.AceAntiDesyncAimbotOn) end if _G.updateTPBatMobileVisual then _G.updateTPBatMobileVisual() end return end if kbMatch(KB.BatV2, kc) then toggleBatV2() if autoBatV2SetVisual then autoBatV2SetVisual(autoBatV2Enabled) end return end if kbMatch(KB.GuiHide, kc) then if main then if main.Visible then hideGui() else showGui() end end return end end)