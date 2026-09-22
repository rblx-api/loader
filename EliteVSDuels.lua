do
    local AnimSystem = {
        Enabled = false,
        Selected = "Ninja",
        Originals = nil,
        Conn = nil
        Packs = {
            ["Ninja"] = {
                idle1 = "rbxassetid://656117400", idle2 = "rbxassetid://656118341", walk = "rbxassetid://656121766", run = "rbxassetid://656118852",
                jump = "rbxassetid://109996626521204", fall = "rbxassetid://656115606", climb = "rbxassetid://656114359", swim = "rbxassetid://656119721", swimidle = "rbxassetid://656121397",
            },
            ["Amazon"] = {
                idle1 = "rbxassetid://10921344533", idle2 = "rbxassetid://10921345304", walk = "rbxassetid://10921355261", run = "rbxassetid://616163682",
                jump = "rbxassetid://104325245285198", fall = "rbxassetid://10921350320", climb = "rbxassetid://10921343576", swim = "rbxassetid://10921352344", swimidle = "rbxassetid://10921353442",
            },
            ["Mage"] = {
                idle1 = "rbxassetid://10921344533", idle2 = "rbxassetid://10921345304", walk = "rbxassetid://707897309", run = "rbxassetid://616163682",
                jump = "rbxassetid://656117878", fall = "rbxassetid://656115606", climb = "rbxassetid://656114359", swim = "rbxassetid://656119721", swimidle = "rbxassetid://656121397",
            },
            ["Vampire"] = {
                idle1 = "rbxassetid://10921315373", idle2 = "", walk = "rbxassetid://10921326949", run = "rbxassetid://10921320299",
                jump = "rbxassetid://10921322186", fall = "rbxassetid://10921321317", climb = "rbxassetid://10921314188", swim = "rbxassetid://10921324408", swimidle = "rbxassetid://10921325443",
            },
            ["Adidas"] = {
                idle1 = "rbxassetid://122257458498464", idle2 = "rbxassetid://102357151005774", walk = "rbxassetid://10921152678", run = "rbxassetid://82598234841035",
                jump = "rbxassetid://75290611992385", fall = "rbxassetid://10921148939", climb = "rbxassetid://88763136693023", swim = "rbxassetid://133308483266208", swimidle = "rbxassetid://109346520324160",
            },
            ["Anim Pack"] = {
                idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563", walk = "rbxassetid://109168724482748", run = "rbxassetid://10921148209",
                jump = "rbxassetid://116936326516985", fall = "rbxassetid://92294537340807", climb = "rbxassetid://119377220967554", swim = "rbxassetid://134591743181628", swimidle = "rbxassetid://98854111361360",
            },
            ["Adidas Sports"] = {
                idle1 = "rbxassetid://18537376492", idle2 = "rbxassetid://18537371272", walk = "rbxassetid://18537392113", run = "rbxassetid://18537384940",
                jump = "rbxassetid://18537380791", fall = "rbxassetid://18537367238", climb = "rbxassetid://18537363391", swim = "rbxassetid://18537389531", swimidle = "rbxassetid://18537387180",
            },
            ["Adidas Aura"] = {
                idle1 = "rbxassetid://110211186840347", idle2 = "rbxassetid://114191137265065", walk = "rbxassetid://83842218823011", run = "rbxassetid://118320322718866",
                jump = "rbxassetid://109996626521204", fall = "rbxassetid://95603166884636", climb = "rbxassetid://97824616490448", swim = "rbxassetid://134530128383903", swimidle = "rbxassetid://94922130551805",
            },
            ["Wicked Popular"] = {
                idle1 = "rbxassetid://118832222982049", idle2 = "rbxassetid://76049494037641", walk = "rbxassetid://92072849924640", run = "rbxassetid://72301599441680",
                jump = "rbxassetid://104325245285198", fall = "rbxassetid://121152442762481", climb = "rbxassetid://131326830509784", swim = "rbxassetid://99384245425157", swimidle = "rbxassetid://113199415118199",
            },
            ["Elder"] = {
                idle1 = "rbxassetid://10921101664", idle2 = "rbxassetid://10921102574", walk = "rbxassetid://10921111375", run = "rbxassetid://10921104374",
                jump = "rbxassetid://10921107367", fall = "rbxassetid://10921105765", climb = "rbxassetid://10921100400", swim = "rbxassetid://10921108971", swimidle = "rbxassetid://10921110146",
            },
            ["Astronaut"] = {
                idle1 = "rbxassetid://10921034824", idle2 = "rbxassetid://10921036806", walk = "rbxassetid://10921046031", run = "rbxassetid://10921039308",
                jump = "rbxassetid://10921042494", fall = "rbxassetid://10921040576", climb = "rbxassetid://10921032124", swim = "rbxassetid://10921044000", swimidle = "rbxassetid://10921045006",
            },
            ['Wicked "Dancing Through Life"'] = {
                idle1 = "rbxassetid://92849173543269", idle2 = "rbxassetid://132238900951109", walk = "rbxassetid://73718308412641", run = "rbxassetid://135515454877967",
                jump = "rbxassetid://78508480717326", fall = "rbxassetid://78147885297412", climb = "rbxassetid://129447497744818", swim = "rbxassetid://110657013921774", swimidle = "rbxassetid://129183123083281",
            },
            ["Werewolf"] = {
                idle1 = "rbxassetid://10921330408", idle2 = "rbxassetid://10921333667", walk = "rbxassetid://10921342074", run = "rbxassetid://10921336997",
                jump = "", fall = "rbxassetid://10921337907", climb = "rbxassetid://10921329322", swim = "rbxassetid://10921340419", swimidle = "rbxassetid://10921341319",
            },
            ["Superhero"] = {
                idle1 = "rbxassetid://10921288909", idle2 = "rbxassetid://10921290167", walk = "rbxassetid://10921298616", run = "rbxassetid://10921291831",
                jump = "rbxassetid://10921294559", fall = "rbxassetid://10921293373", climb = "rbxassetid://10921286911", swim = "rbxassetid://10921295495", swimidle = "rbxassetid://10921297391",
            },
            ["Toy"] = {
                idle1 = "rbxassetid://10921301576", idle2 = "", walk = "rbxassetid://10921312010", run = "rbxassetid://10921306285",
                jump = "rbxassetid://10921308158", fall = "rbxassetid://10921307241", climb = "rbxassetid://10921300839", swim = "rbxassetid://10921309319", swimidle = "rbxassetid://10921310341",
            },
            ["No Boundaries"] = {
                idle1 = "rbxassetid://18747067405", idle2 = "rbxassetid://18747063918", walk = "rbxassetid://18747074203", run = "rbxassetid://18747070484",
                jump = "rbxassetid://18747069148", fall = "rbxassetid://18747062535", climb = "rbxassetid://18747060903", swim = "rbxassetid://18747073181", swimidle = "rbxassetid://18747071682",
            },
            ["NFL"] = {
                idle1 = "rbxassetid://92080889861410", idle2 = "rbxassetid://74451233229259", walk = "rbxassetid://110358958299415", run = "rbxassetid://117333533048078",
                jump = "rbxassetid://119846112151352", fall = "rbxassetid://129773241321032", climb = "rbxassetid://134630013742019", swim = "rbxassetid://132697394189921", swimidle = "rbxassetid://79090109939093",
            },
        }
    }

    -- FUNCIONES DEL SISTEMA
    local function apply(char)
        local anim = char:FindFirstChild("Animate")
        local pack = AnimSystem.Packs[AnimSystem.Selected]
        if not anim or not pack then return end
        local function s(f, c, id)
            if not id or id == "" then return end
            local folder = anim:FindFirstChild(f)
            local val = folder and folder:FindFirstChild(c)
            if val and val:IsA("Animation") then val.AnimationId = id end
        end
        s("idle", "Animation1", pack.idle1); s("idle", "Animation2", pack.idle2)
        s("walk", "WalkAnim", pack.walk); s("run", "RunAnim", pack.run)
        s("jump", "JumpAnim", pack.jump); s("fall", "FallAnim", pack.fall)
        s("climb", "ClimbAnim", pack.climb); s("swim", "Swim", pack.swim)
        s("swimidle", "SwimIdle", pack.swimidle)
    end

    local function save(char)
        local anim = char:FindFirstChild("Animate")
        if not anim then return end
        local function g(f, c)
            local folder = anim:FindFirstChild(f)
            local val = folder and folder:FindFirstChild(c)
            return val and val.AnimationId
        end
        local ids = {
            idle1 = g("idle", "Animation1"), idle2 = g("idle", "Animation2"),
            walk = g("walk", "WalkAnim"), run = g("run", "RunAnim"),
            jump = g("jump", "JumpAnim"), fall = g("fall", "FallAnim"),
            climb = g("climb", "ClimbAnim"), swim = g("swim", "Swim"),
            swimidle = g("swimidle", "SwimIdle")
        }
        local isCustom = false
        for _, p in pairs(AnimSystem.Packs) do if p.walk == ids.walk then isCustom = true; break end end
        if not isCustom then AnimSystem.Originals = ids end
    end

    local function restore(char)
        local anim = char:FindFirstChild("Animate")
        local orig = AnimSystem.Originals
        if not anim or not orig then return end
        local function s(f, c, id)
            if not id then return end
            local folder = anim:FindFirstChild(f)
            local val = folder and folder:FindFirstChild(c)
            if val and val:IsA("Animation") then val.AnimationId = id end
        end
        s("idle", "Animation1", orig.idle1); s("idle", "Animation2", orig.idle2)
        s("walk", "WalkAnim", orig.walk); s("run", "RunAnim", orig.run)
        s("jump", "JumpAnim", orig.jump); s("fall", "FallAnim", orig.fall)
        s("climb", "ClimbAnim", orig.climb); s("swim", "Swim", orig.swim)
        s("swimidle", "SwimIdle", orig.swimidle)
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then for _, t in ipairs(h:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end; pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end) end
    end

    _G.toggleAnimSystem = function(on)
        AnimSystem.Enabled = on
        if AnimSystem.Conn then AnimSystem.Conn:Disconnect(); AnimSystem.Conn = nil end
        local char = game.Players.LocalPlayer.Character
        if on then
            if char then pcall(save, char); pcall(apply, char); local h = char:FindFirstChildOfClass("Humanoid"); if h then for _, t in ipairs(h:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end; pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end) end end
            AnimSystem.Conn = game:GetService("RunService").Heartbeat:Connect(function()
                if not AnimSystem.Enabled then return end
                local c = game.Players.LocalPlayer.Character
                if c then pcall(apply, c) end
            end)
        else
            if char then pcall(restore, char) end
        end
    end

    _G.setAnimPack = function(name)
        if AnimSystem.Packs[name] then
            AnimSystem.Selected = name
            if AnimSystem.Enabled then _G.toggleAnimSystem(true) end
        end
    end

    _G.getAnimPack = function() return AnimSystem.Selected end
    _G.getAnimPacks = function() local n={} for k,_ in pairs(AnimSystem.Packs) do table.insert(n,k) return n end end
end


repeat task.wait() until game:IsLoaded()
local Players, RunService, UIS, TS, Lighting, HS = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService")
local LP = Players.LocalPlayer

-- ====================== ANTI-DIE INSERTADO AQUÍ ======================
-- ========== ANTI-DIE ==========
local function activateAntiDie(char)
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        hum = char:WaitForChild("Humanoid", 5)
    end
    if not hum then return end

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    if hum:GetAttribute("KzAntiDieHooked") then return end
    hum:SetAttribute("KzAntiDieHooked", true)

    hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health <= 0 then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)

    hum.Died:Connect(function()
        task.wait()
        pcall(function()
            local newHum = Instance.new("Humanoid")
            newHum.Name = "ReplacedHumanoid"
            newHum.Parent = char
            if workspace.CurrentCamera then
                workspace.CurrentCamera.CameraSubject = newHum
            end
            if hum and hum.Parent then hum:Destroy() end
            task.defer(function()
                activateAntiDie(char)
            end)
        end)
    end)
end

-- Aplicar al personaje actual y a futuros respawns
task.spawn(function()
    if LP.Character then
        activateAntiDie(LP.Character)
    end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    activateAntiDie(char)
end)
-- ====================== FIN ANTI-DIE ================================

local NS, CS = 60, 29
local LAGGER_SPEED_1 = 20
local LAGGER_SPEED_2 = 10
local speedMode, antiRagdollEnabled = false, false
_G.__FROST_MOBILE_BUTTON_REFS = {}
_G.__FROST_UI_SIZE = _G.__FROST_UI_SIZE or 100
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

local BAT_AIMBOT_SPEED = 58
local BYPASS_AIMBOT_SPEED = 60
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
    AutoStealEnabled = true,  -- <--- CAMBIADO A true (siempre activado)
    StealRadius = 61.5,
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
local pbFrame = nil

local function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
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

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, math.huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local ct = tick()
    if ct - Steal.promptCacheTime < PROMPT_CACHE_REFRESH and #Steal.cachedPrompts > 0 then
        local np, nd = nil, math.huge
        for _, data in ipairs(Steal.cachedPrompts) do
            if data.prompt and data.prompt.Parent and data.prompt.Enabled ~= false then
                local dist = (data.spawn.Position - root.Position).Magnitude
                if dist <= Steal.StealRadius and dist < nd then
                    np = data.prompt
                    nd = dist
                end
            end
        end
        if np then return np, nd end
    end

    Steal.cachedPrompts = {}
    Steal.promptCacheTime = ct
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, math.huge end

    local np, nd = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    pcall(function()
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then
                                for _, child in ipairs(att:GetChildren()) do
                                    if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                        local dist = (spawn.Position - root.Position).Magnitude
                                        table.insert(Steal.cachedPrompts, {prompt = child, spawn = spawn})
                                        if dist <= Steal.StealRadius and dist < nd then
                                            np = child
                                            nd = dist
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
    return np, nd
end

local function executeSteal(prompt)
    local ct = tick()
    if ct - lastStealTick < STEAL_COOLDOWN then return end
    if isStealing then return end
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
        if Conns.progress then
            Conns.progress:Disconnect()
            Conns.progress = nil
        end
        resetProgressBar()
        task.wait(0.05)
        data.ready = true
        isStealing = false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p = findNearestPrompt()
        if p then
            executeSteal(p)
        else
            if progressPct and not isStealing then
                progressPct.Text = "0%"
            end
        end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal = nil
    end
    if Conns.progress then
        Conns.progress:Disconnect()
        Conns.progress = nil
    end
    isStealing = false
    lastStealTick = 0
    Steal.cachedPrompts = {}
    Steal.promptCacheTime = 0
    resetProgressBar()
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
                local speed = (Vector