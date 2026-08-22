-- ============================================================
--  SURHUB V2 + AUTO STEAL + ESP PLAYER + ZOMBIE ANIMATION
--  + ADIDAS AURA ANIMATION + VAMPIRE ANIMATION
--  + AMAZON UNBOXED ANIMATION
--  CON ANIMACIÓN DE CIERRE DEL MENÚ
--  TP DOWN V2 (SOLO HUNDIMIENTO) - SIN IMPULSO
--  SISTEMA DE MOVIMIENTO CON BYPASS (TRICK Y)
-- ============================================================
local Players, RunService, UIS, TS, Lighting, HS, SoundService = game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Lighting"), game:GetService("HttpService"), game:GetService("SoundService")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer
local NS, CS = 60, 29
local LAGGER_SPEED_1 = 20
local LAGGER_SPEED_2 = 10
local speedMode = false
local jumpMode = 1
local jumpEnabled = false
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

local stretchEnabled = false
local stretchFOV = 120
local stretchConn = nil
local stretchFovConn = nil
local origFOV = 70

local medusaAutoResetEnabled = false
local medusaResetConns = {}
local setMedusaAutoResetVisual = nil

local ragdollTimerEnabled = false
local hitCountdownActive = false
local hitCountdownToken = 0
local hitCountdownLabel = nil
local numberSizeMultiplier = 0.5
local ragdollTimerConn = nil
local ragdollCharacterAddedConn = nil
local setRagdollTimerVisual = nil

local antiRagdollEnabled = false
local antiRagdollConn = nil
local resetCooldown = 0

local editModeEnabled = false
local setEditModeVisual = nil

local stealMode = 1
local stealModeBtnRef = nil

-- ============================================================
--  NUEVAS VARIABLES PARA BYPASS DE VELOCIDAD
-- ============================================================
local VELOCITY_Y_TRICK = 0.000026
local activeSpeedValue = 60
local isJumping = false

-- ============================================================
--  MELEE AIMBOT (Body Lock)
-- ============================================================
local meleeAimbotEnabled = true
local _meleeAimbotConn = nil
local MELEE_LOCK_RANGE = 150
local setMeleeAimbotVisual = nil

-- ============================================================
--  ESP PLAYER (COLOR AZUL)
-- ============================================================
local espEnabled = false
local setEspVisual = nil
local espRenderConn = nil
local espObjects = {}
local _hlCache = {}
local _bbCache = {}
local _trCache = {}
local ESP_COLOR = Color3.fromRGB(0, 150, 255)

-- ============================================================
--  FUNCIONES COMUNES PARA ANIMACIONES (Zombie, Adidas, Vampire, Amazon)
-- ============================================================
local function waitForAnimate(char)
    for _ = 1, 40 do
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then return a end
        task.wait(0.1)
    end
    return nil
end

local function setAnim(obj, id)
    if obj and id then obj.AnimationId = "rbxassetid://" .. tostring(id) end
end

local function stopAllTracks(hum)
    if not hum then return end
    for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
end

local function ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then a = Instance.new("Animation"); a.Name = name; a.Parent = folder end
    return a
end

local function pick(pack, ...)
    for i = 1, select("#", ...) do
        local k = select(i, ...)
        local v = pack[k]
        if v ~= nil then return v end
    end
    return nil
end

-- ============================================================
--  ZOMBIE ANIMATION
-- ============================================================
local zombieEnabled = false
local originalAnimIds = {}
local zombieApplying = false
local setZombieVisual = nil

local PACKS = {
    ["Zombie"] = {
        WalkAnim = 10921355261,
        RunAnim = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345376,
        ClimbAnim = 10921343576
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim  = 97824616490448,
    },
    ["Vampire"] = {
        WalkAnim = 10921326949,
        RunAnim = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
    },
}

local function saveOriginalAnimIds(animate, targetTable)
    targetTable = targetTable or originalAnimIds
    if not animate then return end
    targetTable = {}
    local function saveFolder(folderName, animName)
        local folder = animate:FindFirstChild(folderName)
        if folder then
            local anim = folder:FindFirstChild(animName)
            if anim then
                targetTable[folderName .. "_" .. animName] = anim.AnimationId
            end
        end
    end
    saveFolder("walk", "WalkAnim")
    saveFolder("run", "RunAnim")
    saveFolder("jump", "JumpAnim")
    saveFolder("fall", "FallAnim")
    saveFolder("climb", "ClimbAnim")
    saveFolder("swim", "Swim")
    saveFolder("swimidle", "SwimIdle")
    local idleFolder = animate:FindFirstChild("idle")
    if idleFolder then
        local a1 = idleFolder:FindFirstChild("Animation1")
        if a1 then targetTable["idle_Animation1"] = a1.AnimationId end
        local a2 = idleFolder:FindFirstChild("Animation2")
        if a2 then targetTable["idle_Animation2"] = a2.AnimationId end
    end
end

local function restoreOriginalAnims(restoreTable)
    restoreTable = restoreTable or originalAnimIds
    local char = LP.Character
    if not char then return end
    local animate = waitForAnimate(char)
    if not animate then return end
    for key, id in pairs(restoreTable) do
        local parts = {}
        for part in string.gmatch(key, "[^_]+") do table.insert(parts, part) end
        if #parts == 2 then
            local folder = animate:FindFirstChild(parts[1])
            if folder then
                local anim = folder:FindFirstChild(parts[2])
                if anim then
                    anim.AnimationId = id
                end
            end
        end
    end
    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end) end
end

local function applyGenericPack(packName, targetOriginalTable)
    local applyingVar = false
    if applyingVar then return false end
    applyingVar = true
    local pack = PACKS[packName]
    if not pack then applyingVar = false return false end
    local char = LP.Character or LP.CharacterAdded:Wait()
    local animate = waitForAnimate(char)
    if not animate then applyingVar = false return false end
    saveOriginalAnimIds(animate, targetOriginalTable)
    local hum = char:FindFirstChildOfClass("Humanoid")
    stopAllTracks(hum)
    local function set(folder, name, id)
        local obj = ensureAnim(animate:FindFirstChild(folder), name)
        setAnim(obj, id)
    end
    set("walk", "WalkAnim", pick(pack, "WalkAnim", "Walk"))
    set("run", "RunAnim", pick(pack, "RunAnim", "Run"))
    set("jump", "JumpAnim", pick(pack, "JumpAnim", "Jump"))
    set("fall", "FallAnim", pick(pack, "FallAnim", "Fall"))
    set("climb", "ClimbAnim", pick(pack, "ClimbAnim", "Climb"))
    set("swim", "Swim", pick(pack, "Swim"))
    set("swimidle", "SwimIdle", pick(pack, "SwimIdle") or pick(pack, "Swim"))
    local idleFolder = animate:FindFirstChild("idle")
    if idleFolder then
        local a1 = pick(pack, "Animation1")
        local a2 = pick(pack, "Animation2")
        if a1 or a2 then
            setAnim(ensureAnim(idleFolder, "Animation1"), a1 or a2)
            setAnim(ensureAnim(idleFolder, "Animation2"), a2 or a1)
        elseif pack.Idle and #pack.Idle > 0 then
            setAnim(ensureAnim(idleFolder, "Animation1"), pack.Idle[1])
            setAnim(ensureAnim(idleFolder, "Animation2"), pack.Idle[2] or pack.Idle[1])
        end
    end
    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false
    if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Landed); task.wait(0.03); hum:ChangeState(Enum.HumanoidStateType.Running) end) end
    applyingVar = false
    return true
end

local function applyZombiePack()
    return applyGenericPack("Zombie", originalAnimIds)
end

local function restoreZombieAnims()
    restoreOriginalAnims(originalAnimIds)
end

local function toggleZombie(state)
    if state == nil then state = not zombieEnabled end
    if state then
        if adidasAuraEnabled then toggleAdidasAura(false) end
        if vampireEnabled then toggleVampire(false) end
        if amazonEnabled then toggleAmazon(false) end
    end
    zombieEnabled = state
    if zombieEnabled then
        applyZombiePack()
    else
        restoreZombieAnims()
    end
    if setZombieVisual then setZombieVisual(zombieEnabled) end
    pcall(saveAllSettings)
end

-- ============================================================
--  ADIDAS AURA ANIMATION
-- ============================================================
local adidasAuraEnabled = false
local adidasOriginalAnimIds = {}
local adidasApplying = false
local setAdidasAuraVisual = nil

local function applyAdidasAuraPack()
    return applyGenericPack("Adidas Aura", adidasOriginalAnimIds)
end

local function restoreAdidasAuraAnims()
    restoreOriginalAnims(adidasOriginalAnimIds)
end

local function toggleAdidasAura(state)
    if state == nil then state = not adidasAuraEnabled end
    if state then
        if zombieEnabled then toggleZombie(false) end
        if vampireEnabled then toggleVampire(false) end
        if amazonEnabled then toggleAmazon(false) end
    end
    adidasAuraEnabled = state
    if adidasAuraEnabled then
        applyAdidasAuraPack()
    else
        restoreAdidasAuraAnims()
    end
    if setAdidasAuraVisual then setAdidasAuraVisual(adidasAuraEnabled) end
    pcall(saveAllSettings)
end

-- ============================================================
--  VAMPIRE ANIMATION
-- ============================================================
local vampireEnabled = false
local vampireOriginalAnimIds = {}
local vampireApplying = false
local setVampireVisual = nil

local function applyVampirePack()
    return applyGenericPack("Vampire", vampireOriginalAnimIds)
end

local function restoreVampireAnims()
    restoreOriginalAnims(vampireOriginalAnimIds)
end

local function toggleVampire(state)
    if state == nil then state = not vampireEnabled end
    if state then
        if zombieEnabled then toggleZombie(false) end
        if adidasAuraEnabled then toggleAdidasAura(false) end
        if amazonEnabled then toggleAmazon(false) end
    end
    vampireEnabled = state
    if vampireEnabled then
        applyVampirePack()
    else
        restoreVampireAnims()
    end
    if setVampireVisual then setVampireVisual(vampireEnabled) end
    pcall(saveAllSettings)
end

-- ============================================================
--  AMAZON UNBOXED ANIMATION
-- ============================================================
local amazonEnabled = false
local amazonOriginalAnimIds = {}
local amazonApplying = false
local setAmazonUnboxedVisual = nil

local function applyAmazonPack()
    return applyGenericPack("Amazon Unboxed", amazonOriginalAnimIds)
end

local function restoreAmazonAnims()
    restoreOriginalAnims(amazonOriginalAnimIds)
end

local function toggleAmazon(state)
    if state == nil then state = not amazonEnabled end
    if state then
        if zombieEnabled then toggleZombie(false) end
        if adidasAuraEnabled then toggleAdidasAura(false) end
        if vampireEnabled then toggleVampire(false) end
    end
    amazonEnabled = state
    if amazonEnabled then
        applyAmazonPack()
    else
        restoreAmazonAnims()
    end
    if setAmazonUnboxedVisual then setAmazonUnboxedVisual(amazonEnabled) end
    pcall(saveAllSettings)
end

-- ============================================================
--  FUNCIONES EXISTENTES (clearESP, makeBillboard, etc.)
-- ============================================================
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

local function makeBillboard(head)
    local bb = Instance.new("BillboardGui")
    bb.Name = "BlessESPBB"
    bb.Size = UDim2.new(0, 110, 0, 18)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Adornee = head
    bb.Parent = head
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = ESP_COLOR
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextTruncate = Enum.TextTruncate.AtEnd
    return bb, lbl
end

local function makeTracers()
    if not (Drawing and type(Drawing.new) == "function") then return nil end
    local outer = Drawing.new("Line")
    outer.Color = ESP_COLOR
    outer.Thickness = 2.2
    outer.Transparency = 0.88
    outer.Visible = false
    local mid = Drawing.new("Line")
    mid.Color = ESP_COLOR
    mid.Thickness = 1.2
    mid.Transparency = 0.72
    mid.Visible = false
    local core = Drawing.new("Line")
    core.Color = ESP_COLOR
    core.Thickness = 0.6
    core.Transparency = 0.10
    core.Visible = false
    return {outer, mid, core}
end

local _espLastRun = 0
local function updateESP()
    local now = tick()
    if now - _espLastRun < 0.03 then return end
    _espLastRun = now
    if not espEnabled then clearESP(); return end
    local myChar = LP.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    local cam = workspace.CurrentCamera
    local mySP, myOn = cam:WorldToViewportPoint(myRoot.Position)
    local myVec = Vector2.new(mySP.X, mySP.Y)
    local plrSet = {}
    for _, p in ipairs(Players:GetPlayers()) do plrSet[p] = true end
    for plr in pairs(_hlCache) do
        if not plrSet[plr] then
            pcall(function() _hlCache[plr]:Destroy() end)
            _hlCache[plr] = nil
        end
    end
    for plr in pairs(_bbCache) do
        if not plrSet[plr] then
            pcall(function() _bbCache[plr]:Destroy() end)
            _bbCache[plr] = nil
        end
    end
    for plr in pairs(_trCache) do
        if not plrSet[plr] then
            for _, ln in ipairs(_trCache[plr]) do
                pcall(function() ln.Visible = false; ln:Remove() end)
            end
            _trCache[plr] = nil
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LP then continue end
        local char = plr.Character
        if not char then
            if _hlCache[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr] = nil end
            if _bbCache[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr] = nil end
            if _trCache[plr] then
                for _, ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible = false end) end
            end
            continue
        end
        local tRoot = char:FindFirstChild("HumanoidRootPart")
        local tHead = char:FindFirstChild("Head")
        local tHum  = char:FindFirstChildOfClass("Humanoid")
        if not (tRoot and tHead and tHum and tHum.Health > 0) then
            if _hlCache[plr] then pcall(function() _hlCache[plr]:Destroy() end); _hlCache[plr] = nil end
            if _bbCache[plr] then pcall(function() _bbCache[plr]:Destroy() end); _bbCache[plr] = nil end
            if _trCache[plr] then
                for _, ln in ipairs(_trCache[plr]) do pcall(function() ln.Visible = false end) end
            end
            continue
        end
        local hl = _hlCache[plr]
        if not hl or not hl.Parent or hl.Parent ~= char then
            if hl then pcall(function() hl:Destroy() end) end
            hl = Instance.new("Highlight")
            hl.Name = "BlessESP"
            hl.FillColor = ESP_COLOR
            hl.FillTransparency = 0.62
            hl.OutlineColor = ESP_COLOR
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = char
            hl.Parent = char
            _hlCache[plr] = hl
        end
        local bb = _bbCache[plr]
        if not bb or not bb.Parent or bb.Adornee ~= tHead then
            if bb then pcall(function() bb:Destroy() end) end
            local newBB, lbl = makeBillboard(tHead)
            lbl.Text = plr.DisplayName
            _bbCache[plr] = newBB
        end
        local espLines = _trCache[plr]
        if not espLines then
            espLines = makeTracers()
            _trCache[plr] = espLines or {}
        end
        if espLines and #espLines > 0 then
            local sp, on = cam:WorldToViewportPoint(tRoot.Position)
            if on and sp.Z > 0 and myOn then
                local tv = Vector2.new(sp.X, sp.Y)
                for _, ln in ipairs(espLines) do
                    ln.From = myVec
                    ln.To   = tv
                    ln.Visible = true
                end
            else
                for _, ln in ipairs(espLines) do
                    ln.Visible = false
                end
            end
        end
    end
end

local function startESP()
    if espRenderConn then return end
    espRenderConn = RunService.RenderStepped:Connect(updateESP)
end

local function stopESP()
    if espRenderConn then
        espRenderConn:Disconnect()
        espRenderConn = nil
    end
    clearESP()
end

-- ============================================================
--  INTRO VISUAL
-- ============================================================
local introEnabled = true
local setIntroVisual = nil
local intro2Enabled = false
local setIntro2Visual = nil
local currentBackgroundId = "rbxassetid://87126851304571"

local function playCandyIntro()
    local parent = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 3)
    pcall(function()
        for _, n in ipairs({"VioletGifIntroVertical","RubyGifIntroVertical","SurehubIntro","IrishGifIntroVertical","SoulHubIntro","BlessVSIntro"}) do
            local old = parent:FindFirstChild(n); if old then old:Destroy() end
        end
    end)
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "SurehubIntro"
    introGui.ResetOnSpawn = false
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    introGui.DisplayOrder = 1000000
    introGui.IgnoreGuiInset = true
    introGui.Parent = parent
    local darkBg = Instance.new("Frame", introGui)
    darkBg.Size = UDim2.new(1,0,1,0)
    darkBg.BackgroundColor3 = Color3.fromRGB(4,4,16)
    darkBg.BackgroundTransparency = 1
    darkBg.BorderSizePixel = 0
    darkBg.ZIndex = 1
    local bgGrad = Instance.new("UIGradient", darkBg)
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(6,10,40)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(2,4,20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(2,2,14)),
    })
    bgGrad.Rotation = 90
    local skipBtn = Instance.new("TextButton", introGui)
    skipBtn.AnchorPoint = Vector2.new(1,0)
    skipBtn.Position = UDim2.new(1,-22,0,22)
    skipBtn.Size = UDim2.new(0,104,0,34)
    skipBtn.BackgroundColor3 = Color3.fromRGB(6,30,60)
    skipBtn.BackgroundTransparency = 0.08
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = "SKIP INTRO"
    skipBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    skipBtn.TextSize = 11
    skipBtn.Font = Enum.Font.GothamBlack
    skipBtn.AutoButtonColor = false
    skipBtn.ZIndex = 80
    Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0,10)
    local skipStroke = Instance.new("UIStroke", skipBtn)
    skipStroke.Color = Color3.fromRGB(0,150,255); skipStroke.Thickness = 1; skipStroke.Transparency = 0.2
    local center = Instance.new("Frame", introGui)
    center.AnchorPoint = Vector2.new(0.5,0.5); center.Position = UDim2.new(0.5,0,0.5,0); center.Size = UDim2.new(0,660,0,220)
    center.BackgroundTransparency = 1; center.ZIndex = 40
    local lineTop = Instance.new("Frame", center)
    lineTop.AnchorPoint = Vector2.new(0.5,0); lineTop.Position = UDim2.new(0.5,0,0,48); lineTop.Size = UDim2.new(0,0,0,2)
    lineTop.BackgroundColor3 = Color3.fromRGB(0,150,255); lineTop.BorderSizePixel = 0; lineTop.ZIndex = 41
    local lineBot = Instance.new("Frame", center)
    lineBot.AnchorPoint = Vector2.new(0.5,1); lineBot.Position = UDim2.new(0.5,0,1,-8); lineBot.Size = UDim2.new(0,0,0,2)
    lineBot.BackgroundColor3 = Color3.fromRGB(0,150,255); lineBot.BorderSizePixel = 0; lineBot.ZIndex = 41
    local titleShadow = Instance.new("TextLabel", center)
    titleShadow.Size = UDim2.new(1,0,0,86); titleShadow.Position = UDim2.new(0,4,0,58); titleShadow.BackgroundTransparency = 1
    titleShadow.Text = "Surehub"; titleShadow.TextColor3 = Color3.fromRGB(0,0,0); titleShadow.Font = Enum.Font.GothamBlack; titleShadow.TextSize = 72
    titleShadow.TextTransparency = 1; titleShadow.TextStrokeTransparency = 1; titleShadow.ZIndex = 42
    local title = Instance.new("TextLabel", center)
    title.Size = UDim2.new(1,0,0,86); title.Position = UDim2.new(0,0,0,53); title.BackgroundTransparency = 1
    title.Text = "Surehub"; title.TextColor3 = Color3.fromRGB(0,150,255); title.Font = Enum.Font.GothamBlack; title.TextSize = 72
    title.TextTransparency = 1; title.TextStrokeTransparency = 1; title.TextStrokeColor3 = Color3.fromRGB(0,40,120); title.ZIndex = 43
    local subtitle = Instance.new("TextLabel", center)
    subtitle.Size = UDim2.new(1,0,0,26); subtitle.Position = UDim2.new(0,0,0,152); subtitle.BackgroundTransparency = 1
    subtitle.Text = "by Tumbado"
    subtitle.TextColor3 = Color3.fromRGB(150,210,255); subtitle.Font = Enum.Font.GothamMedium; subtitle.TextSize = 19; subtitle.TextTransparency = 1; subtitle.ZIndex = 43
    local introCompleteEvent = Instance.new("BindableEvent")
    local introActive = true
    local function finishIntro()
        if not introActive then return end
        introActive = false
        introCompleteEvent:Fire()
    end
    skipBtn.MouseButton1Click:Connect(finishIntro)
    task.spawn(function()
        pcall(function()
            writefile("SurehubIntro", game:HttpGet("https://files.catbox.moe/rcgr9f.mp3"))
            local soundParent = SoundService
            pcall(function() if gethui then soundParent = gethui() end end)
            local snd = Instance.new("Sound", soundParent)
            snd.SoundId = getcustomasset("SurehubIntro")
            snd.Volume = 1; snd:Play()
        end)
        TS:Create(darkBg, TweenInfo.new(0.65), {BackgroundTransparency = 0.15}):Play()
        task.wait(0.85); if not introActive then finishIntro(); return end
        TS:Create(lineTop, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,480,0,2)}):Play()
        TS:Create(lineBot, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0,480,0,2)}):Play()
        task.wait(0.12)
        TS:Create(titleShadow, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0.45, TextStrokeTransparency = 1}):Play()
        TS:Create(title, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0, TextStrokeTransparency = 0.2}):Play()
        task.wait(0.42)
        TS:Create(subtitle, TweenInfo.new(0.42), {TextTransparency = 0}):Play()
        for i = 1, 3 do
            if not introActive then break end
            TS:Create(title, TweenInfo.new(0.06), {TextColor3 = Color3.fromRGB(100,220,255)}):Play(); task.wait(0.06)
            TS:Create(title, TweenInfo.new(0.06), {TextColor3 = Color3.fromRGB(0,150,255)}):Play(); task.wait(0.06)
        end
        task.wait(3.0); if not introActive then return end
        TS:Create(title, TweenInfo.new(0.36), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
        TS:Create(titleShadow, TweenInfo.new(0.36), {TextTransparency = 1}):Play()
        TS:Create(subtitle, TweenInfo.new(0.32), {TextTransparency = 1}):Play()
        TS:Create(lineTop, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,2)}):Play()
        TS:Create(lineBot, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,2)}):Play()
        TS:Create(darkBg, TweenInfo.new(0.75), {BackgroundTransparency = 1}):Play()
        task.wait(0.8)
        introActive = false
        introCompleteEvent:Fire()
    end)
    introCompleteEvent.Event:Wait()
    introCompleteEvent:Destroy()
    introGui:Destroy()
end

local function playIntro2Music()
    local SONG_ID  = "rbxassetid://126107591945718"
    local SONG_VOL = 0.7
    local SONG_POS = 34
    local snd = Instance.new("Sound")
    snd.SoundId            = SONG_ID
    snd.Volume             = SONG_VOL
    snd.Looped             = false
    snd.RollOffMode        = Enum.RollOffMode.InverseTapered
    snd.RollOffMinDistance = 10000
    snd.RollOffMaxDistance = 10000
    snd.TimePosition       = SONG_POS
    snd.Parent             = SoundService
    if not snd.IsLoaded then
        local loaded = false
        task.spawn(function() snd.Loaded:Wait(); loaded = true end)
        local t = 0
        while not loaded and t < 0.5 do task.wait(0.05); t = t + 0.05 end
    end
    snd:Play()
end

-- ============================================================
--  MELEE AIMBOT
-- ============================================================
local function getMeleeClosestTarget()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

local function meleeTick()
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
    if _meleeAimbotConn then return end
    _meleeAimbotConn = RunService.RenderStepped:Connect(function()
        if meleeAimbotEnabled then meleeTick() end
    end)
end

local function stopMeleeAimbot()
    if _meleeAimbotConn then
        _meleeAimbotConn:Disconnect()
        _meleeAimbotConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyAngularVelocity = Vector3.zero end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
end

-- ============================================================
--  FUNCIONES DE RESETEO, ANTI-RAGDOLL, GALAXY, TP BAT, etc.
-- ============================================================
local function forceReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
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

local function startAntiRagdoll()
    if antiRagdollConn then return end
    antiRagdollEnabled = true
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local isRagdolled = (state == Enum.HumanoidStateType.Physics or
                             state == Enum.HumanoidStateType.Ragdoll or
                             state == Enum.HumanoidStateType.FallingDown)
        if isRagdolled then
            local now = tick()
            if now - resetCooldown > 0.15 then
                resetCooldown = now
                forceReset()
            end
        end
    end)
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
end

local galaxyEnabled = false
local galaxySky = nil
local galaxyOriginalValues = {}

local function applyGalaxySky()
    galaxyOriginalValues.Brightness = Lighting.Brightness
    galaxyOriginalValues.ClockTime = Lighting.ClockTime
    galaxyOriginalValues.ExposureCompensation = Lighting.ExposureCompensation
    galaxyOriginalValues.OutdoorAmbient = Lighting.OutdoorAmbient
    if Lighting:FindFirstChild("NgasGalaxySky") then
        Lighting.NgasGalaxySky:Destroy()
    end
    galaxySky = Instance.new("Sky")
    galaxySky.Name = "NgasGalaxySky"
    galaxySky.SkyboxBk = "rbxassetid://159454299"
    galaxySky.SkyboxDn = "rbxassetid://159454296"
    galaxySky.SkyboxFt = "rbxassetid://159454293"
    galaxySky.SkyboxLf = "rbxassetid://159454286"
    galaxySky.SkyboxRt = "rbxassetid://159454289"
    galaxySky.SkyboxUp = "rbxassetid://159454291"
    galaxySky.Parent = Lighting
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    Lighting.ExposureCompensation = -2
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
end

local function removeGalaxySky()
    if galaxySky then
        galaxySky:Destroy()
        galaxySky = nil
    end
    if Lighting:FindFirstChild("NgasGalaxySky") then
        Lighting.NgasGalaxySky:Destroy()
    end
    if galaxyOriginalValues.Brightness ~= nil then
        Lighting.Brightness = galaxyOriginalValues.Brightness
        Lighting.ClockTime = galaxyOriginalValues.ClockTime
        Lighting.ExposureCompensation = galaxyOriginalValues.ExposureCompensation
        Lighting.OutdoorAmbient = galaxyOriginalValues.OutdoorAmbient
        galaxyOriginalValues = {}
    end
end

local function toggleGalaxy(state)
    if state == nil then state = not galaxyEnabled end
    galaxyEnabled = state
    if galaxyEnabled then applyGalaxySky() else removeGalaxySky() end
    if setGalaxyVisual then setGalaxyVisual(galaxyEnabled) end
    pcall(saveAllSettings)
end

local tpBatEnabled = false
local tpBatConn = nil
local tpBatHittingCooldown = false
local tpBatFloatingButton = nil
local tpBatFloatingPos = nil
local setTPBatVisual = nil
local BAT_COUNTER_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
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

local function getClosestPlayerTP()
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

local function tryHitBatTP()
    if tpBatHittingCooldown then return end
    tpBatHittingCooldown = true
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then
            tpBatHittingCooldown = false
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
    task.delay(0.1, function() tpBatHittingCooldown = false end)
    task.delay(0.2, function()
        if tpBatHittingCooldown then tpBatHittingCooldown = false end
    end)
end

local function startTPBatLoop()
    if tpBatConn then return end
    tpBatConn = RunService.Heartbeat:Connect(function()
        if not tpBatEnabled then return end
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
        local target, dist = getClosestPlayerTP()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                pcall(function()
                    sethiddenproperty(root, "PhysicsRepRootPart", targetRoot)
                end)
                local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
                if (root.Position - targetPos).Magnitude > 8 then
                    root.CFrame = CFrame.new(targetPos)
                end
                local cam = workspace.CurrentCamera
                if cam then
                    cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position)
                end
                tryHitBatTP()
            end
        end
    end)
end

local function stopTPBatLoop()
    if tpBatConn then
        tpBatConn:Disconnect()
        tpBatConn = nil
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
    tpBatHittingCooldown = false
end

local function toggleTPBat(state)
    if state == nil then state = not tpBatEnabled end
    tpBatEnabled = state
    if tpBatEnabled then startTPBatLoop() else stopTPBatLoop() end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        local frame = tpBatFloatingButton:FindFirstChild("Frame")
        if frame then
            if tpBatEnabled then
                frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                local label = frame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(0, 0, 0) end
            else
                frame.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
                local label = frame:FindFirstChild("TextLabel")
                if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            end
        end
    end
    pcall(saveAllSettings)
end

local function stopAllBackgroundTasks()
    if movementConn then movementConn:Disconnect(); movementConn = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
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
    if galaxyEnabled then toggleGalaxy(false) end
    if tpBatEnabled then toggleTPBat(false) end
    stopRagdollTimer()
    stopAntiRagdoll()
    stopMeleeAimbot()
    if espEnabled then stopESP() end
    if zombieEnabled then toggleZombie(false) end
    if adidasAuraEnabled then toggleAdidasAura(false) end
    if vampireEnabled then toggleVampire(false) end
    if amazonEnabled then toggleAmazon(false) end
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

local Conns = {batCounter = nil, anchor = {}, progress = {},
    autoLeft = nil, autoRight = nil}

-- ============================================================
--  NUEVO SISTEMA DE MOVIMIENTO CON BYPASS Y TRICK Y
-- ============================================================
-- Variables ya declaradas arriba: VELOCITY_Y_TRICK, activeSpeedValue, isJumping

-- Detección de salto por tecla
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space then
        isJumping = true
        task.wait(0.25)
        isJumping = false
    end
end)

-- Detección de salto por velocidad vertical
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local velY = hrp.AssemblyLinearVelocity.Y
    if math.abs(velY) > 3 then
        isJumping = true
    elseif math.abs(velY) < 1 and isJumping then
        isJumping = false
    end
end)

-- Función para obtener la velocidad activa según el modo
local function getActiveSpeed()
    if laggerToggled then
        return (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
    elseif speedMode then
        return CS
    else
        return NS
    end
end

-- Bucle principal de movimiento (reemplaza el antiguo movementLoop)
local function movementLoop()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- Si algún aimbot/modo especial está activo, no interferir
    if autoBatEnabled or bypassToggled or autoLeftEnabled or autoRightEnabled then
        return
    end

    local direction = hum.MoveDirection
    if direction.Magnitude > 0.1 then
        activeSpeedValue = getActiveSpeed()
        hum.WalkSpeed = activeSpeedValue

        local currentVel = hrp.AssemblyLinearVelocity
        local newYVel = currentVel.Y

        -- Truco: si no está saltando y la Y es casi 0, aplicar el valor mínimo
        if not isJumping and math.abs(currentVel.Y) < 1 then
            newYVel = VELOCITY_Y_TRICK
        end

        hrp.AssemblyLinearVelocity = Vector3.new(
            direction.X * activeSpeedValue,
            newYVel,
            direction.Z * activeSpeedValue
        )
    end
end

-- Conectar el bucle a Heartbeat
local movementConn = RunService.Heartbeat:Connect(movementLoop)

-- Mantener el steppedConn para desactivar colisiones de otros jugadores
local steppedConn = RunService.Stepped:Connect(function()
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

-- ============================================================
--  RESTO DE FUNCIONES (movimiento, auto-left, auto-right, etc.)
-- ============================================================
local function drag(f)
    local dn, ds, sp, di = false, nil, nil, nil
    local moved = false
    local threshold = 6
    f.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true
            ds = i.Position
            sp = f.Position
            moved = false
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dn = false
                end
            end)
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            di = i
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            local dx, dy = i.Position.X - ds.X, i.Position.Y - ds.Y
            if (math.abs(dx) > threshold or math.abs(dy) > threshold) and not moved then
                moved = t... (Tiempo restante: 184 KB)