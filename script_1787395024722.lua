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
                moved = true
            end
            f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + dx, sp.Y.Scale, sp.Y.Offset + dy)
        end
    end)
end

function findNearestPrompt()
    return nil, math.huge
end
function executeSteal(prompt) end

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
                        textLabel.Text = "Speed: " .. string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                    label.Text = "Speed: " .. string.format("%.1f", speed)
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
local MobilePanel = nil

local MobileButtons = {
    Visible = true,
    Frame = nil,
    Buttons = {}
}
local mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight
local mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2
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
    TPBat       ={kb=Enum.KeyCode.B,gp=nil},
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

-- (Ya no necesitamos el antiguo movementLoop ni steppedConn, ya están arriba)

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
    titleLabel.Text = "discord.gg/Surehub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 13
    titleLabel.TextScaled = false
    titleLabel.TextStrokeTransparency = 0
    titleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Size = UDim2.new(1, 0, 0, 26)
    speedLabel.Position = UDim2.new(0, 0, 0, 24)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 0.0"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

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
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
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

        if token ~= hitCountdownToken then return end
        lbl.Text = "UNREADY"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.wait(0.8)

        for i = 3, 1, -1 do
            if token ~= hitCountdownToken then return end
            lbl.Text = tostring(i)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            task.wait(1)
        end

        if token ~= hitCountdownToken then return end
        lbl.Text = "READY"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.wait(0.5)

        repeat
            task.wait(0.1)
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then break end
            local state = hum:GetState()
            if state ~= Enum.HumanoidStateType.Physics and
               state ~= Enum.HumanoidStateType.Ragdoll and
               state ~= Enum.HumanoidStateType.FallingDown then
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
    if ragdollTimerConn then return end
    if LP.Character then setupRagdollBillboard(LP.Character) end
    if not ragdollCharacterAddedConn then
        ragdollCharacterAddedConn = LP.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if ragdollTimerEnabled then setupRagdollBillboard(char) end
        end)
    end
    ragdollTimerConn = RunService.Heartbeat:Connect(function()
        if not ragdollTimerEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
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
    local bp = LP:FindFirstChildOfClass("Backpack")
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
                if lbl then lbl.TextColor3 = Color3.fromRGB(255, 255, 255) end
            end
        end
        stopBypassAimbot()
    end
    autoBatEnabled = true
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

disableAutoBat = function()
    autoBatEnabled = false
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
        if mobSetAutoBat then mobSetAutoBat(true) end
        startAimbotAdapt()
    end
end

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
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then root.AssemblyLinearVelocity = Vector3.zero end
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
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        if btnFrame then
            local label = btnFrame:FindFirstChild("TextLabel")
            if bypassToggled then
                btnFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                if label then label.TextColor3 = Color3.fromRGB(0, 0, 0) end
            else
                btnFrame.BackgroundColor3 = Color3.fromRGB(0, 20, 80)
                if label then label.TextColor3 = Color3.fromRGB(255, 255, 255) end
            end
        end
    end
end

local autoTPDownEnabled = false
local autoTPDownConn = nil
local autoTPDownThreshold = 20

-- ============================================================
--  TP DOWN V2 (solo hundimiento, sin impulso)
-- ============================================================
local function applyTPDownV2(sinkAmount)
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

    if hum and hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end

    task.wait(0.05)
    if hum and hum.Health < oldHealth then
        hum.Health = oldHealth
    end
end

local function executeTPDown()
    applyTPDownV2(0.8)
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
            modeValLbl.Text = laggerLevel == 1 and "Lagger Speed" or "Extra Speed"
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
    resetMovementState()
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
    resetMovementState()
end

local function toggleLockUI(state)
    if state == nil then
        uiLocked = not uiLocked
    else
        uiLocked = state
    end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

local floatingButtonPositions = {}

local function resetFloatingPositions()
    local defaultPositions = {
        DropBR   = {XScale=1, XOffset=-138, YScale=0, YOffset=140},
        AutoLeft = {XScale=1, XOffset=-70,  YScale=0, YOffset=140},
        AutoBat  = {XScale=1, XOffset=-138, YScale=0, YOffset=70},
        AutoRight= {XScale=1, XOffset=-70,  YScale=0, YOffset=70},
        TpDown   = {XScale=1, XOffset=-138, YScale=0, YOffset=210},
        Carry    = {XScale=1, XOffset=-70,  YScale=0, YOffset=210},
        Lagger1  = {XScale=1, XOffset=-138, YScale=0, YOffset=280},
        Lagger2  = {XScale=1, XOffset=-70,  YScale=0, YOffset=280},
    }
    for name, pos in pairs(defaultPositions) do
        local posKey = name .. "Pos"
        floatingButtonPositions[posKey] = {XScale=pos.XScale, XOffset=pos.XOffset, YScale=pos.YScale, YOffset=pos.YOffset}
        local btn = _G["floatBtn_" .. name]
        if btn and btn:FindFirstChild("Frame") then
            btn:FindFirstChild("Frame").Position = UDim2.new(pos.XScale, pos.XOffset, pos.YScale, pos.YOffset)
        end
    end

    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        instaResetFloatingButton:FindFirstChild("Frame").Position = UDim2.new(1, -206, 0, 140)
        instaResetFloatingPos = nil
    end
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        bypassFloatingButton:FindFirstChild("Frame").Position = UDim2.new(1, -206, 0, 210)
        bypassFloatingPos = nil
    end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        tpBatFloatingButton:FindFirstChild("Frame").Position = UDim2.new(1, -206, 0, 70)
        tpBatFloatingPos = nil
    end
    stealBarPosition = nil
    local stealPod = CoreGui:FindFirstChild("StealPod")
    if stealPod then
        local mainFrame = stealPod:FindFirstChild("Main")
        if mainFrame then
            mainFrame.Position = UDim2.new(0.5, -150, 0, 72)
        end
    end
    savedMobilePanelPos = nil
    instaResetFloatingPos = nil
    bypassFloatingPos = nil
    pcall(saveAllSettings)
end

local CONFIG_FILE = "LustHub.json"
local savedMobilePanelPos = nil
local savedInstaResetPos = nil
local savedBypassPos = nil
local lastSavedJSON = nil

local stealBarPosition = nil

local function buildConfigTable()
    local config = {
        normalSpeed = NS,
        carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED_1,
        laggerSpeed2 = LAGGER_SPEED_2,
        autoTPHeight = autoTPHeight,
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
        bypassToggled = false,
        bypassSpeed = BYPASS_AIMBOT_SPEED,
        medusaAutoReset = medusaAutoResetEnabled,
        stretchEnabled = stretchEnabled,
        stretchFOV = stretchFOV,
        galaxyEnabled = galaxyEnabled,
        tpBatEnabled = tpBatEnabled,
        ragdollTimer = ragdollTimerEnabled,
        antiRagdoll = antiRagdollEnabled,
        editMode = editModeEnabled,
        showIntro = introEnabled,
        intro2 = intro2Enabled,
        meleeAimbot = meleeAimbotEnabled,
        backgroundId = currentBackgroundId,
        espEnabled = espEnabled,
        zombieEnabled = zombieEnabled,
        adidasAuraEnabled = adidasAuraEnabled,
        vampireEnabled = vampireEnabled,
        amazonUnboxedEnabled = amazonEnabled,
        tpBatFloatingPos = tpBatFloatingPos,
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
        instaResetFloatingPos = instaResetFloatingPos,
        bypassFloatingPos = bypassFloatingPos,
        floatingButtonPositions = floatingButtonPositions,
        autoStealEnabled = STEAL_CONFIG and STEAL_CONFIG.AUTO_STEAL_ENABLED or true,
        stealBarPos = stealBarPosition,
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
    if data.autoTPHeight then autoTPHeight = data.autoTPHeight end
    if data.autoTPDownEnabled ~= nil then autoTPDownEnabled = data.autoTPDownEnabled end
    if data.autoTPDownThreshold then autoTPDownThreshold = data.autoTPDownThreshold end
    if data.lockUI ~= nil then uiLocked = data.lockUI end
    if data.autoLeft ~= nil then autoLeftEnabled = data.autoLeft end
    if data.autoRight ~= nil then autoRightEnabled = data.autoRight end
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
    if data.galaxyEnabled ~= nil then
        galaxyEnabled = data.galaxyEnabled
        if galaxyEnabled then applyGalaxySky() else removeGalaxySky() end
        if setGalaxyVisual then setGalaxyVisual(galaxyEnabled) end
    end
    if data.tpBatEnabled ~= nil then
        tpBatEnabled = data.tpBatEnabled
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
    end
    if data.ragdollTimer ~= nil then ragdollTimerEnabled = data.ragdollTimer end
    if data.antiRagdoll ~= nil then antiRagdollEnabled = data.antiRagdoll end
    if data.editMode ~= nil then editModeEnabled = data.editMode end
    if data.meleeAimbot ~= nil then meleeAimbotEnabled = data.meleeAimbot else meleeAimbotEnabled = true end
    if data.backgroundId then currentBackgroundId = data.backgroundId end
    if data.showIntro ~= nil then introEnabled = data.showIntro else introEnabled = true end
    if data.intro2 ~= nil then intro2Enabled = data.intro2 else intro2Enabled = false end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
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

    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.bypassFloatingPos then bypassFloatingPos = data.bypassFloatingPos end
    if data.batAimbotSpeed then
        BAT_AIMBOT_SPEED = data.batAimbotSpeed
        if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    end
    if data.bypassSpeed then
        BYPASS_AIMBOT_SPEED = data.bypassSpeed
        if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    end
    bypassToggled = false
    if data.stretchEnabled ~= nil then stretchEnabled = data.stretchEnabled end
    if data.stretchFOV then stretchFOV = data.stretchFOV end
    if data.floatingButtonPositions then floatingButtonPositions = data.floatingButtonPositions end
    if data.espEnabled ~= nil then espEnabled = data.espEnabled else espEnabled = false end
    if data.zombieEnabled ~= nil then zombieEnabled = data.zombieEnabled else zombieEnabled = false end
    if data.adidasAuraEnabled ~= nil then adidasAuraEnabled = data.adidasAuraEnabled else adidasAuraEnabled = false end
    if data.vampireEnabled ~= nil then vampireEnabled = data.vampireEnabled else vampireEnabled = false end
    if data.amazonUnboxedEnabled ~= nil then amazonEnabled = data.amazonUnboxedEnabled else amazonEnabled = false end

    if data.autoStealEnabled ~= nil then
        if STEAL_CONFIG then
            STEAL_CONFIG.AUTO_STEAL_ENABLED = data.autoStealEnabled
            if STEAL_CONFIG.AUTO_STEAL_ENABLED then
                if stealConnection then startAutoStealLoop() end
            else
                if stealConnection then stopAutoStealLoop() end
            end
            if progressPct then
                progressPct.Text = STEAL_CONFIG.AUTO_STEAL_ENABLED and "UNREADY" or "DISABLED"
                progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end
    if data.stealBarPos then stealBarPosition = data.stealBarPos end

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
    medusaAutoResetEnabled = false
    stretchEnabled = false
    stretchFOV = 120
    galaxyEnabled = false
    tpBatEnabled = false
    ragdollTimerEnabled = false
    antiRagdollEnabled = false
    editModeEnabled = false
    introEnabled = true
    intro2Enabled = false
    meleeAimbotEnabled = true
    currentBackgroundId = "rbxassetid://87126851304571"
    espEnabled = false
    zombieEnabled = false
    adidasAuraEnabled = false
    vampireEnabled = false
    amazonEnabled = false
    tpBatFloatingPos = nil
    stealBarPosition = nil
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if setBatCounterVisual then setBatCounterVisual(false) end
    if setMedusaVisual then setMedusaVisual(false) end
    if setMedusaAutoResetVisual then setMedusaAutoResetVisual(false) end
    if setJumpVisual then setJumpVisual(false) end
    if setUnwalkVisual then setUnwalkVisual(false) end
    if setAntiLagVisual then setAntiLagVisual(false) end
    if setAutoTPDownVisual then setAutoTPDownVisual(false) end
    if setLockUIVisual then setLockUIVisual(false) end
    if setInstaGrab then setInstaGrab(false) end
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    if setGalaxyVisual then setGalaxyVisual(false) end
    if setRagdollTimerVisual then setRagdollTimerVisual(false) end
    if setEditModeVisual then setEditModeVisual(false) end
    if setIntroVisual then setIntroVisual(true) end
    if setIntro2Visual then setIntro2Visual(false) end
    if setMeleeAimbotVisual then setMeleeAimbotVisual(meleeAimbotEnabled) end
    if setEspVisual then setEspVisual(false) end
    if setZombieVisual then setZombieVisual(false) end
    if setAdidasAuraVisual then setAdidasAuraVisual(false) end
    if setVampireVisual then setVampireVisual(false) end
    if setAmazonUnboxedVisual then setAmazonUnboxedVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    if mobSetDropBR then mobSetDropBR(false) end
    if mobSetTpDown then mobSetTpDown(false) end
    if mobSetCarry then mobSetCarry(false) end
    if mobSetLagger1 then mobSetLagger1(false) end
    if mobSetLagger2 then mobSetLagger2(false) end
    if modeSelectBtn then
        modeSelectBtn.Text = jumpMode == 1 and "Tap Tap" or "Hold"
    end
    if setJumpToggleState then setJumpToggleState(false) end
    refreshSpeedModeLabel()
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
    resetToDefaults()
    resetFloatingPositions()
    instaResetFloatingPos = nil
    bypassFloatingPos = nil
    tpBatFloatingPos = nil
    stealBarPosition = nil
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local btnFrame = instaResetFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -206, 0, 140)
    end
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -206, 0, 210)
    end
    if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
        local btnFrame = tpBatFloatingButton:FindFirstChild("Frame")
        btnFrame.Position = UDim2.new(1, -206, 0, 70)
    end
    local stealPod = CoreGui:FindFirstChild("StealPod")
    if stealPod then
        local mainFrame = stealPod:FindFirstChild("Main")
        if mainFrame then
            mainFrame.Position = UDim2.new(0.5, -150, 0, 72)
        end
    end
    return success
end

-- ============================================================
--  GUI PRINCIPAL (Surehub v2)
-- ============================================================
local gui = nil
local main = nil
local miniBtn = nil
local mainScale = nil

local function buildGui()
    local BLACK   = Color3.fromRGB(0,0,0)
    local ACCENT  = Color3.fromRGB(192,192,192)
    local INP     = Color3.fromRGB(12,12,12)
    local DARK_BLUE = Color3.fromRGB(0, 20, 80)
    local WHITE   = Color3.fromRGB(255,255,255)
    local CORNER  = 40
    local GUI_W, GUI_H = 420, 500

    local old=game:GetService("CoreGui"):FindFirstChild("LustHub");if old then old:Destroy() end
    local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("LustHub");if o then o:Destroy() end end
    gui=Instance.new("ScreenGui")
    gui.Name="LustHub";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end

    main=Instance.new("Frame",gui)
    main.Size=UDim2.new(0,GUI_W,0,GUI_H)
    main.Position=UDim2.new(0,20,0,2)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,CORNER)

    mainScale = Instance.new("UIScale", main)
    mainScale.Scale = 1

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Size = UDim2.new(1,0,1,0)
    bgImage.Position = UDim2.new(0,0,0,0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = currentBackgroundId
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    local bgCorner = Instance.new("UICorner", bgImage)
    bgCorner.CornerRadius = UDim.new(0, CORNER)

    local darkOverlay = Instance.new("Frame", main)
    darkOverlay.Size = UDim2.new(1,0,1,0)
    darkOverlay.Position = UDim2.new(0,0,0,0)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    darkOverlay.BackgroundTransparency = 0.5
    darkOverlay.BorderSizePixel = 0
    darkOverlay.ZIndex = 1
    Instance.new("UICorner", darkOverlay).CornerRadius = UDim.new(0, CORNER)

    local mainStroke=Instance.new("UIStroke",main)
    mainStroke.Color=ACCENT
    mainStroke.Thickness=1.2
    mainStroke.Transparency=0.55
    mainStroke.ZIndex = 2

    local shadow = Instance.new("Frame", main)
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, 4)
    shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadow.BackgroundTransparency = 0.8
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, CORNER)

    local titleBar = Instance.new("Frame", main)
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundTransparency = 1
    titleBar.ZIndex = 10
    local titleCorner = Instance.new("UICorner", titleBar)
    titleCorner.CornerRadius = UDim.new(0, CORNER)

    local titleLabel = Instance.new("TextLabel", titleBar)
    titleLabel.Size = UDim2.new(0, 160, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Surehub v2"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local titleGrad = Instance.new("UIGradient", titleLabel)
    titleGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 60, 120)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 60, 120))
    })
    titleGrad.Rotation = 45
    titleGrad.Offset = Vector2.new(0, 0)

    task.spawn(function()
        local t = 0
        while titleGrad and titleGrad.Parent do
            t = t + 0.02
            titleGrad.Offset = Vector2.new(math.sin(t * 0.5) * 0.5, 0)
            task.wait(0.03)
        end
    end)

    local titleStroke = Instance.new("UIStroke", titleLabel)
    titleStroke.Color = Color3.fromRGB(80, 160, 255)
    titleStroke.Thickness = 1.2
    titleStroke.Transparency = 0.3

    local closeBtn = Instance.new("TextButton", titleBar)
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
    closeBtn.BackgroundColor3 = BLACK
    closeBtn.BackgroundTransparency = 0
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = ACCENT
    closeStroke.Thickness = 1.2
    closeStroke.Transparency = 0.3

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(255,255,255),BackgroundColor3=Color3.fromRGB(20,20,20)}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0,Color=Color3.fromRGB(255,255,255)}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(255,255,255),BackgroundColor3=BLACK}):Play()
        TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0.3,Color=ACCENT}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 118, 0, 30)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 10, 30)
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "Surehub v2"
    miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextSize = 12
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)

    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Thickness = 3
    miniStroke.Transparency = 0
    miniStroke.Color = Color3.fromRGB(0, 150, 255)

    local grad = Instance.new("UIGradient", miniStroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.3,  Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(0.7,  Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(0, 0, 0))
    })
    grad.Rotation = 0

    task.spawn(function()
        while grad and grad.Parent do
            grad.Rotation = (grad.Rotation + 1) % 360
            task.wait(0.02)
        end
    end)

    local function showGui()
        if not main or not mainScale then return end
        main.Visible = true
        mainScale.Scale = 0
        miniBtn.Visible = false
        local tween = TS:Create(mainScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1})
        tween:Play()
        setActivePage(mainPage)
    end

    local function hideGui()
        if not main or not mainScale or not main.Visible then return end
        local tween = TS:Create(mainScale, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
        tween:Play()
        tween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            mainScale.Scale = 1
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local tabBar = Instance.new("Frame", main)
    tabBar.Size = UDim2.new(1, -20, 0, 36)
    tabBar.Position = UDim2.new(0, 10, 0, 40)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10
    local tabCorner = Instance.new("UICorner", tabBar)
    tabCorner.CornerRadius = UDim.new(0, 14)
    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, -16, 1, -(40 + 36 + 12))
    contentArea.Position = UDim2.new(0, 8, 0, 40 + 36 + 6)
    contentArea.BackgroundColor3 = Color3.fromRGB(0,0,0)
    contentArea.BackgroundTransparency = 0.4
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    contentArea.ZIndex = 2
    Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 30)
    local contentSt = Instance.new("UIStroke", contentArea)
    contentSt.Color = ACCENT
    contentSt.Thickness = 1
    contentSt.Transparency = 0.18

    local pageHolder = Instance.new("Frame", contentArea)
    pageHolder.Size = UDim2.new(1, -10, 1, -18)
    pageHolder.Position = UDim2.new(0, 5, 0, 9)
    pageHolder.BackgroundTransparency = 1
    pageHolder.BorderSizePixel = 0
    local phCorner = Instance.new("UICorner", pageHolder)
    phCorner.CornerRadius = UDim.new(0, 20)

    local function buildPage()
        local p = Instance.new("ScrollingFrame", pageHolder)
        p.Size = UDim2.new(1, -2, 1, 0)
        p.Position = UDim2.new(0, 0, 0, 0)
        p.BackgroundTransparency = 1
        p.BorderSizePixel = 0
        p.ClipsDescendants = true
        p.ScrollBarThickness = 8
        p.ScrollBarImageColor3 = ACCENT
        p.ScrollBarImageTransparency = 0
        p.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        p.CanvasSize = UDim2.new(0, 0, 0, 0)
        p.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local ll = Instance.new("UIListLayout", p)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0, 7)
        local pd = Instance.new("UIPadding", p)
        pd.PaddingLeft = UDim.new(0, 8)
        pd.PaddingRight = UDim.new(0, 8)
        pd.PaddingTop = UDim.new(0, 8)
        pd.PaddingBottom = UDim.new(0, 30)
        return p
    end

    local mainPage = buildPage()
    local otherPage = buildPage()
    otherPage.Visible = false
    local configPage = buildPage()
    configPage.Visible = false
    local keybindsPage = buildPage()
    keybindsPage.Visible = false

    local function addSpacer(page)
        local spacer = Instance.new("Frame", page)
        spacer.Size = UDim2.new(1, 0, 0, 300)
        spacer.BackgroundTransparency = 1
        spacer.BorderSizePixel = 0
        spacer.LayoutOrder = 999
    end

    local function makeTopTab(label, idx, page)
        local b = Instance.new("TextButton", tabBar)
        b.Size = UDim2.new(0, 82, 0, 28)
        b.BackgroundColor3 = DARK_BLUE
        b.BackgroundTransparency = 0
        b.BorderSizePixel = 0
        b.Text = label:sub(1,1) .. label:sub(2):lower()
        b.TextColor3 = WHITE
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.AutoButtonColor = false
        b.LayoutOrder = idx
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
        local s = Instance.new("UIStroke", b)
        s.Color = Color3.fromRGB(120,120,120)
        s.Thickness = 1
        s.Transparency = 0.4
        return b
    end

    local btnMain   = makeTopTab("SPEED",  1, mainPage)
    local btnOther  = makeTopTab("OTHER",  2, otherPage)
    local btnConfig = makeTopTab("CONFIG", 3, configPage)
    local btnKeybinds = makeTopTab("KEYBINDS", 4, keybindsPage)
    local allTabs = {
        {btn=btnMain,   page=mainPage},
        {btn=btnOther,  page=otherPage},
        {btn=btnConfig, page=configPage},
        {btn=btnKeybinds, page=keybindsPage},
    }

    local activePage = mainPage
    local function setActivePage(p)
        activePage = p
        for _, t in ipairs(allTabs) do
            t.page.Visible = (t.page == p)
            local isActive = (t.page == p)
            TS:Create(t.btn, TweenInfo.new(0.22), {
                BackgroundColor3 = isActive and WHITE or DARK_BLUE,
                BackgroundTransparency = 0,
                TextColor3 = isActive and Color3.fromRGB(0,0,0) or WHITE,
            }):Play()
            local st = t.btn:FindFirstChildWhichIsA("UIStroke")
            if st then
                TS:Create(st, TweenInfo.new(0.22), {
                    Color = isActive and Color3.fromRGB(180,180,180) or Color3.fromRGB(120,120,120),
                    Transparency = isActive and 0.2 or 0.4,
                }):Play()
            end
        end
    end

    btnMain.BackgroundColor3 = WHITE
    btnMain.BackgroundTransparency = 0
    btnMain.TextColor3 = Color3.fromRGB(0,0,0)
    local stMain = btnMain:FindFirstChildWhichIsA("UIStroke")
    if stMain then stMain.Color = Color3.fromRGB(180,180,180); stMain.Transparency = 0.2 end

    btnMain.MouseButton1Click:Connect(function() setActivePage(mainPage) end)
    btnOther.MouseButton1Click:Connect(function() setActivePage(otherPage) end)
    btnConfig.MouseButton1Click:Connect(function() setActivePage(configPage) end)
    btnKeybinds.MouseButton1Click:Connect(function() setActivePage(keybindsPage) end)

    local function mkSect(txt)
        local f = Instance.new("Frame", activePage)
        f.Size = UDim2.new(1, 0, 0, 26)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -10, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        f.LayoutOrder = #activePage:GetChildren() + 1
        local line = Instance.new("Frame", f)
        line.Size = UDim2.new(1, -20, 0, 1)
        line.Position = UDim2.new(0, 10, 1, -2)
        line.BackgroundColor3 = Color3.fromRGB(80,80,80)
        line.BackgroundTransparency = 0.5
        line.BorderSizePixel = 0
        return f
    end

    local function mkRow(h)
        local f = Instance.new("Frame", activePage)
        f.Size = UDim2.new(1, -2, 0, h or 40)
        f.BackgroundColor3 = Color3.fromRGB(0,0,0)
        f.BackgroundTransparency = 0.4
        f.BorderSizePixel = 0
        f.LayoutOrder = #activePage:GetChildren() + 1
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.2}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.4}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.58, 0, 1, 0)
        l.Position = UDim2.new(0, 11, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 46, 0, 24)
        pill.Position = UDim2.new(1, -(offset or 56), 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(42,42,42)
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 18, 0, 18)
        dot.Position = UDim2.new(0, 3, 0.5, -9)
        dot.BackgroundColor3 = Color3.fromRGB(130,130,130)
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        if on then
            TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(255,255,255)}):Play()
            TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
                Position=UDim2.new(1,-21,0.5,-9),
                BackgroundColor3=Color3.fromRGB(0,0,0)
            }):Play()
        else
            TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=Color3.fromRGB(0,20,80)}):Play()
            TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
                Position=UDim2.new(0,3,0.5,-9),
                BackgroundColor3=Color3.fromRGB(255,255,255)
            }):Play()
        end
    end

    local function mkToggle(txt, cb)
        local row = mkRow(40)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 56)
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
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 8)
        tb.Size = UDim2.new(0, bw, 0, 26)
        tb.Position = UDim2.new(1, -xo, 0.5, -13)
        tb.BackgroundColor3 = INP
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
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=ACCENT,Transparency=0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(80,80,80),Transparency=0.28}):Play()
            if cb then local n = tonumber(tb.Text); if n then cb(n) else tb.Text = tostring(default) end end
        end)
        return tb
    end

    local function mkSelector(parent, default, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 50, 0, 26)
        btn.Position = UDim2.new(1, -56, 0.5, -13)
        btn.BackgroundColor3 = INP
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
        end)
        return btn
    end

    setActivePage(mainPage)
    mkSect("| Speed")
    do local row=mkRow(40); mkLabel(row,"Normal Speed"); normalBox=mkBox(row,NS,50,56,function(v) if v>0 and v<=500 then NS=v end end) end
    do local row=mkRow(40); mkLabel(row,"Carry Speed"); carryBox=mkBox(row,CS,50,56,function(v) if v>0 and v<=500 then CS=v end end) end
    do local row=mkRow(40); mkLabel(row,"Lagger Speed"); laggerBox=mkBox(row,LAGGER_SPEED_1,50,56,function(v) if v>0 and v<=500 then LAGGER_SPEED_1=v end end) end
    do local row=mkRow(40); mkLabel(row,"Extra Speed"); lagger2Box=mkBox(row,LAGGER_SPEED_2,50,56,function(v) if v>0 and v<=500 then LAGGER_SPEED_2=v end end) end

    do local row=mkRow(40); mkLabel(row,"Height Y"); autoTPHeightBox=mkBox(row,autoTPHeight,50,56,function(v) if v>=1 and v<=500 then autoTPHeight=v; autoTPDownThreshold=v end end) end
    do local row=mkRow(40); mkLabel(row,"Bat Aimbot Speed"); batSpeedBox=mkBox(row,BAT_AIMBOT_SPEED,50,56,function(v) if v>0 and v<=200 then BAT_AIMBOT_SPEED=v end end) end
    do local row=mkRow(40); mkLabel(row,"Bypass Speed"); bypassSpeedBox=mkBox(row,BYPASS_AIMBOT_SPEED,50,56,function(v) if v>0 and v<=200 then BYPASS_AIMBOT_SPEED=v end end) end

    do local row=mkRow(40); mkLabel(row,"Current Mode"); modeValLbl=Instance.new("TextLabel",row); modeValLbl.Size=UDim2.new(0,100,1,0); modeValLbl.Position=UDim2.new(1,-104,0,0); modeValLbl.BackgroundTransparency=1; modeValLbl.Text="Normal"; modeValLbl.TextColor3=Color3.fromRGB(255,255,255); modeValLbl.Font=Enum.Font.GothamBlack; modeValLbl.TextSize=12; modeValLbl.TextXAlignment=Enum.TextXAlignment.Right; local clk=Instance.new("TextButton",row); clk.Size=UDim2.new(1,0,1,0); clk.BackgroundTransparency=1; clk.Text=""; clk.Activated:Connect(function() if _anyKeyListening then return end; toggleCarryMode() end) end

    setAutoTPDownVisual = mkToggle("Auto TP Down", function(on)
        autoTPDownEnabled = on
        if on then startAutoTPDown() else stopAutoTPDown() end
    end)

    setActivePage(otherPage)

    mkSect("| DUEL")
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

    setAntiRagdollVisual = mkToggle("Anti Ragdoll", function(on)
        antiRagdollEnabled = on
        if on then
            startAntiRagdoll()
        else
            stopAntiRagdoll()
        end
        pcall(saveAllSettings)
    end)

    setRagdollTimerVisual = mkToggle("Ragdoll Timer", function(on)
        ragdollTimerEnabled = on
        if on then
            startRagdollTimer()
        else
            stopRagdollTimer()
        end
        pcall(saveAllSettings)
    end)

    setMeleeAimbotVisual = mkToggle("Melee Aimbot", function(on)
        meleeAimbotEnabled = on
        if on then
            startMeleeAimbot()
        else
            stopMeleeAimbot()
        end
        pcall(saveAllSettings)
    end)

    setEspVisual = mkToggle("ESP Player", function(on)
        espEnabled = on
        if on then
            startESP()
        else
            stopESP()
        end
        pcall(saveAllSettings)
    end)

    mkSect("| Movement")
    do
        local row = mkRow(40)
        mkLabel(row, "Infinite Jump")
        jumpPill, jumpDot = mkPill(row, 56)
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
        local row = mkRow(40)
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

    setGalaxyVisual = mkToggle("Galaxy Visual", function(on)
        toggleGalaxy(on)
    end)

    setAntiLagVisual = mkToggle("Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
    end)

    -- ANIMATION SECTION
    mkSect("| Animation")
    setZombieVisual = mkToggle("Zombie Animation", function(on)
        toggleZombie(on)
    end)

    setAdidasAuraVisual = mkToggle("Adidas Aura", function(on)
        toggleAdidasAura(on)
    end)

    setVampireVisual = mkToggle("Vampire Animation", function(on)
        toggleVampire(on)
    end)

    setAmazonUnboxedVisual = mkToggle("Amazon Unboxed", function(on)
        toggleAmazon(on)
    end)

    mkSect("| Intro")
    setIntroVisual = mkToggle("Show Intro", function(on)
        introEnabled = on
        pcall(saveAllSettings)
    end)

    setIntro2Visual = mkToggle("Intro 2", function(on)
        intro2Enabled = on
        pcall(saveAllSettings)
    end)

    addSpacer(otherPage)

    setActivePage(configPage)

    mkSect("| FONDO")
    do
        local row = mkRow(80)
        row.Size = UDim2.new(1, -2, 0, 80)

        local function createFondoOption(parent, id, label, xOffset)
            local btn = Instance.new("TextButton", parent)
            btn.Size = UDim2.new(0, 100, 0, 70)
            btn.Position = UDim2.new(0, xOffset, 0.5, -35)
            btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(80,80,80)
            stroke.Thickness = 1.5
            stroke.Transparency = 0.2

            local img = Instance.new("ImageLabel", btn)
            img.Size = UDim2.new(1, -10, 0.7, -10)
            img.Position = UDim2.new(0, 5, 0, 5)
            img.BackgroundTransparency = 1
            img.Image = "rbxassetid://" .. id
            img.ScaleType = Enum.ScaleType.Crop
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 4)

            local lbl = Instance.new("TextLabel", btn)
            lbl.Size = UDim2.new(1, 0, 0, 16)
            lbl.Position = UDim2.new(0, 0, 1, -18)
            lbl.BackgroundTransparency = 1
            lbl.Text = label
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 10
            lbl.TextXAlignment = Enum.TextXAlignment.Center

            local function updateHighlight()
                local isActive = (currentBackgroundId == "rbxassetid://" .. id)
                stroke.Color = isActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(80,80,80)
                stroke.Thickness = isActive and 2.5 or 1.5
                btn.BackgroundColor3 = isActive and Color3.fromRGB(30,30,50) or Color3.fromRGB(20,20,20)
            end
            updateHighlight()

            btn.MouseButton1Click:Connect(function()
                currentBackgroundId = "rbxassetid://" .. id
                bgImage.Image = currentBackgroundId
                for _, child in ipairs(parent:GetChildren()) do
                    if child:IsA("TextButton") then
                        local strokeChild = child:FindFirstChildWhichIsA("UIStroke")
                        if strokeChild then
                            local imgChild = child:FindFirstChildWhichIsA("ImageLabel")
                            if imgChild then
                                local imgId = imgChild.Image:match("rbxassetid://(%d+)")
                                if imgId then
                                    local isActive = (currentBackgroundId == "rbxassetid://" .. imgId)
                                    strokeChild.Color = isActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(80,80,80)
                                    strokeChild.Thickness = isActive and 2.5 or 1.5
                                    child.BackgroundColor3 = isActive and Color3.fromRGB(30,30,50) or Color3.fromRGB(20,20,20)
                                end
                            end
                        end
                    end
                end
                pcall(saveAllSettings)
            end)

            return btn
        end

        createFondoOption(row, "124833425021074", "Fondo 1", 10)
        createFondoOption(row, "88879074569566", "Fondo 2", 120)
        createFondoOption(row, "87126851304571", "Fondo 3", 230)
    end

    mkSect("| STRETCH")
    setLockUIVisual = mkToggle("Lock UI", function(on)
        toggleLockUI(on)
    end)

    setEditModeVisual = mkToggle("Edit Button", function(on)
        editModeEnabled = on
        local color = on and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
        if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
            local stroke = instaResetFloatingButton:FindFirstChild("Frame"):FindFirstChildWhichIsA("UIStroke")
            if stroke then
                stroke.Color = color
                stroke.Transparency = on and 0 or 0.1
            end
        end
        if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
            local stroke = bypassFloatingButton:FindFirstChild("Frame"):FindFirstChildWhichIsA("UIStroke")
            if stroke then
                stroke.Color = color
                stroke.Transparency = on and 0 or 0.1
            end
        end
        if tpBatFloatingButton and tpBatFloatingButton:FindFirstChild("Frame") then
            local stroke = tpBatFloatingButton:FindFirstChild("Frame"):FindFirstChildWhichIsA("UIStroke")
            if stroke then
                stroke.Color = color
                stroke.Transparency = on and 0 or 0.1
            end
        end
        for name, btn in pairs(_G.floatButtons or {}) do
            if btn and btn:FindFirstChild("Frame") then
                local stroke2 = btn:FindFirstChild("Frame"):FindFirstChildWhichIsA("UIStroke")
                if stroke2 then
                    stroke2.Color = color
                    stroke2.Transparency = on and 0 or 0.1
                end
            end
        end
        pcall(saveAllSettings)
    end)

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
        local row = mkRow(40)
        mkLabel(row, "FOV")
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
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = Color3.fromRGB(80,80,80)
            stroke.Thickness = 1
            if val == stretchFOV then
                btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                            b.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                            b.TextColor3 = Color3.fromRGB(255, 255, 255)
                        else
                            b.BackgroundColor3 = Color3.fromRGB(12,12,12)
                            b.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
                pcall(saveAllSettings)
            end)
            table.insert(fovBtns, btn)
            return btn
        end
        makeFOVBtn(90, 0)
        makeFOVBtn(120, 53)
        makeFOVBtn(180, 106)
        _G.fovButtons = fovBtns
    end

    mkSect("| CONFIG")
    do
        local row = mkRow(40)
        row.Size = UDim2.new(1, -16, 0, 40)
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(0.9, 0, 0.8, 0)
        resetBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
        resetBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "RESET POSITIONS"
        resetBtn.TextColor3 = Color3.fromRGB(255,255,255)
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 13
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetBtn)
        resetStroke.Color = Color3.fromRGB(150,150,150)
        resetStroke.Thickness = 1.2
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

    -- AUTO STEAL TOGGLE
    mkSect("| AUTO STEAL")
    local autoStealToggleRef = mkToggle("Auto Steal", function(on)
        if STEAL_CONFIG then
            STEAL_CONFIG.AUTO_STEAL_ENABLED = on
            if on then
                if not stealConnection then startAutoStealLoop() end
                if progressPct then
                    progressPct.Text = "UNREADY"
                    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            else
                if stealConnection then stopAutoStealLoop() end
                if progressPct then
                    progressPct.Text = "DISABLED"
                    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
                end
            end
            pcall(saveAllSettings)
        end
    end)
    if STEAL_CONFIG and STEAL_CONFIG.AUTO_STEAL_ENABLED then
        autoStealToggleRef(true)
    else
        autoStealToggleRef(false)
    end

    addSpacer(configPage)

    setActivePage(keybindsPage)
    mkSect("Keybinds")

    local keyButtonRefs = {}

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 85, 0, 26)
        btn.Position = UDim2.new(1, -93, 0.5, -13)
        btn.BackgroundColor3 = INP
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = Color3.fromRGB(80,80,80)
        bs.Thickness = 1
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
            end)
        end)
        return btn
    end

    local function addKeybindRow(labelText, kbEntry)
        local row = mkRow(36)
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
    addKeybindRow("Insta Reset", KB.InstaReset)
    addKeybindRow("Auto TP Down", KB.AutoTPDown)
    addKeybindRow("TP Bat", KB.TPBat)

    local spacer = Instance.new("Frame", keybindsPage)
    spacer.Size = UDim2.new(1, 0, 0, 20)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = 100
    spacer.Visible = true

    _G.keyButtonRefs = keyButtonRefs

    local function drag(f)
        local dn,ds,sp,di=false
        f.InputBegan:Connect(function(i)
            if uiLocked and not editModeEnabled then return end
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
                if uiLocked and not editModeEnabled then dn=false; return end
                local nX=sp.X.Offset+(i.Position.X-ds.X)
                local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
            end
        end)
    end
    drag(main)

    setActivePage(mainPage)
end

-- ============================================================
--  ACTUALIZACIÓN DE LA GUI DESPUÉS DE CARGAR CONFIGURACIÓN
-- ============================================================
local function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text=tostring(NS) end
    if carryBox then carryBox.Text=tostring(CS) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text=tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if bypassSpeedBox then bypassSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    refreshSpeedModeLabel()
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if setIntroVisual then setIntroVisual(introEnabled) end
    if setIntro2Visual then setIntro2Visual(intro2Enabled) end

    if bgImage then
        bgImage.Image = currentBackgroundId
    end

    if antiRagdollEnabled then
        if setAntiRagdollVisual then setAntiRagdollVisual(true) end
        startAntiRagdoll()
    else
        if setAntiRagdollVisual then setAntiRagdollVisual(false) end
        stopAntiRagdoll()
    end

    if editModeEnabled then
        if setEditModeVisual then setEditModeVisual(true) end
    else
        if setEditModeVisual then setEditModeVisual(false) end
    end

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
    if autoBatEnabled then
        if mobSetAutoBat then mobSetAutoBat(true) end
        enableAutoBat()
    end
    if autoLeftEnabled then
        if LP.Character then startAutoLeft() end
    end
    if autoRightEnabled then
        if LP.Character then startAutoRight() end
    end
    if unwalkEnabled and setUnwalkVisual then setUnwalkVisual(true); task.spawn(function() task.wait(0.5); startUnwalk() end) end
    if antiLagEnabled and setAntiLagVisual then enableAntiLag(); setAntiLagVisual(true) end

    if ragdollTimerEnabled then
        if setRagdollTimerVisual then setRagdollTimerVisual(true) end
        startRagdollTimer()
    else
        if setRagdollTimerVisual then setRagdollTimerVisual(false) end
        stopRagdollTimer()
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
                btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            else
                btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
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

    if galaxyEnabled then
        applyGalaxySky()
    else
        removeGalaxySky()
    end
    if setGalaxyVisual then setGalaxyVisual(galaxyEnabled) end

    if tpBatEnabled then
        startTPBatLoop()
    else
        stopTPBatLoop()
    end
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

    if setMeleeAimbotVisual then
        setMeleeAimbotVisual(meleeAimbotEnabled)
    end
    if meleeAimbotEnabled then
        startMeleeAimbot()
    else
        stopMeleeAimbot()
    end

    if setEspVisual then
        setEspVisual(espEnabled)
    end
    if espEnabled then
        startESP()
    else
        stopESP()
    end

    -- Zombie Animation
    if setZombieVisual then
        setZombieVisual(zombieEnabled)
    end
    if zombieEnabled then
        task.spawn(function()
            task.wait(0.3)
            applyZombiePack()
        end)
    else
        task.spawn(function()
            task.wait(0.3)
            restoreOriginalAnims(originalAnimIds)
        end)
    end

    -- Adidas Aura
    if setAdidasAuraVisual then
        setAdidasAuraVisual(adidasAuraEnabled)
    end
    if adidasAuraEnabled then
        task.spawn(function()
            task.wait(0.3)
            applyAdidasAuraPack()
        end)
    else
        task.spawn(function()
            task.wait(0.3)
            restoreAdidasAuraAnims()
        end)
    end

    -- Vampire Animation
    if setVampireVisual then
        setVampireVisual(vampireEnabled)
    end
    if vampireEnabled then
        task.spawn(function()
            task.wait(0.3)
            applyVampirePack()
        end)
    else
        task.spawn(function()
            task.wait(0.3)
            restoreVampireAnims()
        end)
    end

    -- Amazon Unboxed Animation
    if setAmazonUnboxedVisual then
        setAmazonUnboxedVisual(amazonEnabled)
    end
    if amazonEnabled then
        task.spawn(function()
            task.wait(0.3)
            applyAmazonPack()
        end)
    else
        task.spawn(function()
            task.wait(0.3)
            restoreAmazonAnims()
        end)
    end

    for name, btnRef in pairs(_G.floatButtons or {}) do
        if btnRef and btnRef.frame then
            local posKey = name .. "Pos"
            local pos = floatingButtonPositions[posKey]
            if pos then
                btnRef.frame.Position = UDim2.new(pos.XScale or 1, pos.XOffset or -70, pos.YScale or 0, pos.YOffset or 0)
            end
        end
    end

    if stealBarPosition then
        local stealPod = CoreGui:FindFirstChild("StealPod")
        if stealPod then
            local mainFrame = stealPod:FindFirstChild("Main")
            if mainFrame then
                mainFrame.Position = UDim2.new(stealBarPosition.XScale, stealBarPosition.XOffset,
                                                stealBarPosition.YScale, stealBarPosition.YOffset)
            end
        end
    end

    startEnemySpeed()
end

-- ============================================================
--  BOTONES FLOTANTES
-- ============================================================
local floatButtons = {}
_G.floatButtons = floatButtons
local INACTIVE_BG = Color3.fromRGB(0, 20, 80)
local ACTIVE_BG   = Color3.fromRGB(255, 255, 255)
local TEXT_COLOR  = Color3.fromRGB(255, 255, 255)

local function createFloatingButton(buttonName, text, defaultPos, toggleCallback, clickCallback)
    local panel = Instance.new("ScreenGui")
    panel.Name = buttonName .. "Float"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local BTN_W, BTN_H = 60, 60
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    btnFrame.Name = "Frame"
    local posKey = buttonName .. "Pos"
    if floatingButtonPositions and floatingButtonPositions[posKey] then
        local pos = floatingButtonPositions[posKey]
        btnFrame.Position = UDim2.new(pos.XScale or 1, pos.XOffset or -70, pos.YScale or 0, pos.YOffset or 0)
    else
        btnFrame.Position = UDim2.new(defaultPos.XScale or 1, defaultPos.XOffset or -70, defaultPos.YScale or 0, defaultPos.YOffset or 0)
        floatingButtonPositions[posKey] = {
            XScale = btnFrame.Position.X.Scale,
            XOffset = btnFrame.Position.X.Offset,
            YScale = btnFrame.Position.Y.Scale,
            YOffset = btnFrame.Position.Y.Offset
        }
    end
    btnFrame.BackgroundColor3 = INACTIVE_BG
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local corner = Instance.new("UICorner", btnFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Thickness = 1.8
    stroke.Transparency = editModeEnabled and 0 or 0.1
    stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    grad.Rotation = 0
    task.spawn(function()
        while grad and grad.Parent do
            grad.Rotation = (grad.Rotation + 0.8) % 360
            task.wait(0.025)
        end
    end)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TEXT_COLOR
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    label.TextWrapped = true
    label.ZIndex = 21

    local activeState = false
    local function setActive(state)
        activeState = state
        if state then
            btnFrame.BackgroundColor3 = ACTIVE_BG
            label.TextColor3 = Color3.fromRGB(0, 0, 0)
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(0, 150, 255)
            stroke.Transparency = 0
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
            })
        else
            btnFrame.BackgroundColor3 = INACTIVE_BG
            label.TextColor3 = TEXT_COLOR
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
            stroke.Transparency = editModeEnabled and 0 or 0.1
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
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
            if hasMoved then
                if not uiLocked or editModeEnabled then
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
                    if toggleCallback then
                        toggleCallback(setActive)
                    elseif clickCallback then
                        clickCallback(setActive, activeState)
                    end
                elseif (not uiLocked or editModeEnabled) and hasMoved then
                    floatingButtonPositions[posKey] = {
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

    local ref = {panel=panel, frame=btnFrame, setActive=setActive, label=label}
    floatButtons[buttonName] = ref
    _G["floatBtn_" .. buttonName] = panel
    return ref
end

local defaultPositions = {
    DropBR   = {XScale=1, XOffset=-138, YScale=0, YOffset=140},
    AutoLeft = {XScale=1, XOffset=-70,  YScale=0, YOffset=140},
    AutoBat  = {XScale=1, XOffset=-138, YScale=0, YOffset=70},
    AutoRight= {XScale=1, XOffset=-70,  YScale=0, YOffset=70},
    TpDown   = {XScale=1, XOffset=-138, YScale=0, YOffset=210},
    Carry    = {XScale=1, XOffset=-70,  YScale=0, YOffset=210},
    Lagger1  = {XScale=1, XOffset=-138, YScale=0, YOffset=280},
    Lagger2  = {XScale=1, XOffset=-70,  YScale=0, YOffset=280},
}

local dropBRRef = createFloatingButton("DropBR", "DROP\nBR", defaultPositions.DropBR, nil, function(setActive, active)
    if autoBatEnabled then return end
    setActive(true)
    executeDropWithToggle(function(v)
        if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
    end)
    task.delay(0.3, function() setActive(false) end)
end)
mobSetDropBR = function(state) if dropBRRef then dropBRRef.setActive(state) end end

local autoLeftRef = createFloatingButton("AutoLeft", "AUTO\nLEFT", defaultPositions.AutoLeft, function(setActive)
    autoLeftEnabled = not autoLeftEnabled
    setActive(autoLeftEnabled)
    if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
end)
mobSetAutoLeft = function(state) if autoLeftRef then autoLeftRef.setActive(state) end end

local autoBatRef = createFloatingButton("AutoBat", "BAT\nAIMBOT", defaultPositions.AutoBat, function(setActive)
    if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
    setActive(autoBatEnabled)
end)
mobSetAutoBat = function(state) if autoBatRef then autoBatRef.setActive(state) end end

local autoRightRef = createFloatingButton("AutoRight", "AUTO\nRIGHT", defaultPositions.AutoRight, function(setActive)
    autoRightEnabled = not autoRightEnabled
    setActive(autoRightEnabled)
    if autoRightEnabled then startAutoRight() else stopAutoRight() end
    if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
end)
mobSetAutoRight = function(state) if autoRightRef then autoRightRef.setActive(state) end end

local tpDownRef = createFloatingButton("TpDown", "TP\nDOWN", defaultPositions.TpDown, nil, function(setActive, active)
    executeTPDown()
    setActive(true)
    task.delay(0.2, function() setActive(false) end)
end)
mobSetTpDown = function(state) if tpDownRef then tpDownRef.setActive(state) end end

local carryRef = createFloatingButton("Carry", "CARRY\nSPD", defaultPositions.Carry, function(setActive)
    if not speedMode then
        speedMode=true; laggerToggled=false; laggerLevel=1; setActive(true)
        if lagger1Ref then lagger1Ref.setActive(false) end
        if lagger2Ref then lagger2Ref.setActive(false) end
    else
        speedMode=false; setActive(false)
    end
    refreshSpeedModeLabel()
end)
mobSetCarry = function(state) if carryRef then carryRef.setActive(state) end end

local lagger1Ref = createFloatingButton("Lagger1", "LAGGER\nSPD", defaultPositions.Lagger1, function(setActive)
    if speedMode then speedMode=false; if carryRef then carryRef.setActive(false) end end
    if not laggerToggled or laggerLevel ~= 1 then
        laggerToggled = true; laggerLevel = 1; setActive(true)
        if lagger2Ref then lagger2Ref.setActive(false) end
    else
        laggerToggled = false; laggerLevel = 1; setActive(false)
    end
    refreshSpeedModeLabel()
end)
mobSetLagger1 = function(state) if lagger1Ref then lagger1Ref.setActive(state) end end

local lagger2Ref = createFloatingButton("Lagger2", "EXTRA\nSPD", defaultPositions.Lagger2, function(setActive)
    if speedMode then speedMode=false; if carryRef then carryRef.setActive(false) end end
    if not laggerToggled or laggerLevel ~= 2 then
        laggerToggled = true; laggerLevel = 2; setActive(true)
        if lagger1Ref then lagger1Ref.setActive(false) end
    else
        laggerToggled = false; laggerLevel = 1; setActive(false)
    end
    refreshSpeedModeLabel()
end)
mobSetLagger2 = function(state) if lagger2Ref then lagger2Ref.setActive(state) end end

task.spawn(function()
    task.wait(0.1)
    if autoBatRef then autoBatRef.setActive(autoBatEnabled) end
    if autoLeftRef then autoLeftRef.setActive(autoLeftEnabled) end
    if autoRightRef then autoRightRef.setActive(autoRightEnabled) end
    if carryRef then carryRef.setActive(speedMode) end
    if lagger1Ref then lagger1Ref.setActive(laggerToggled and laggerLevel==1) end
    if lagger2Ref then lagger2Ref.setActive(laggerToggled and laggerLevel==2) end
end)

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

    local BTN_W, BTN_H = 60, 60
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    btnFrame.Name = "Frame"
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(instaResetFloatingPos.XScale or 1,
                                      instaResetFloatingPos.XOffset or -206,
                                      instaResetFloatingPos.YScale or 0,
                                      instaResetFloatingPos.YOffset or 140)
    else
        btnFrame.Position = UDim2.new(1, -206, 0, 140)
    end
    btnFrame.BackgroundColor3 = INACTIVE_BG
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local corner = Instance.new("UICorner", btnFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Thickness = 1.8
    stroke.Transparency = editModeEnabled and 0 or 0.1
    stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    grad.Rotation = 0
    task.spawn(function()
        while grad and grad.Parent do
            grad.Rotation = (grad.Rotation + 0.8) % 360
            task.wait(0.025)
        end
    end)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextWrapped = true
    label.ZIndex = 21

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = ACTIVE_BG
            label.TextColor3 = Color3.fromRGB(0, 0, 0)
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(0, 150, 255)
            stroke.Transparency = 0
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
            })
        else
            btnFrame.BackgroundColor3 = INACTIVE_BG
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
            stroke.Transparency = editModeEnabled and 0 or 0.1
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
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
            if hasMoved then
                if not uiLocked or editModeEnabled then
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
                    setActive(true)
                    insta_reset()
                    if setInstaResetVisual then setInstaResetVisual(true) end
                    task.delay(0.3, function()
                        if setInstaResetVisual then setInstaResetVisual(false) end
                        setActive(false)
                    end)
                elseif (not uiLocked or editModeEnabled) and hasMoved then
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

    return panel
end

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

    local BTN_W, BTN_H = 60, 60
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    btnFrame.Name = "Frame"
    if bypassFloatingPos then
        btnFrame.Position = UDim2.new(bypassFloatingPos.XScale or 1,
                                      bypassFloatingPos.XOffset or -206,
                                      bypassFloatingPos.YScale or 0,
                                      bypassFloatingPos.YOffset or 210)
    else
        btnFrame.Position = UDim2.new(1, -206, 0, 210)
    end
    btnFrame.BackgroundColor3 = bypassToggled and ACTIVE_BG or INACTIVE_BG
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local corner = Instance.new("UICorner", btnFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Thickness = 1.8
    stroke.Transparency = editModeEnabled and 0 or 0.1
    stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    grad.Rotation = 0
    task.spawn(function()
        while grad and grad.Parent do
            grad.Rotation = (grad.Rotation + 0.8) % 360
            task.wait(0.025)
        end
    end)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BYPASS\nAIMBOT"
    label.TextColor3 = bypassToggled and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = ACTIVE_BG
            label.TextColor3 = Color3.fromRGB(0, 0, 0)
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(0, 150, 255)
            stroke.Transparency = 0
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
            })
        else
            btnFrame.BackgroundColor3 = INACTIVE_BG
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
            stroke.Transparency = editModeEnabled and 0 or 0.1
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
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
            if hasMoved then
                if not uiLocked or editModeEnabled then
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
                    toggleBypass(not bypassToggled)
                    setActive(bypassToggled)
                elseif (not uiLocked or editModeEnabled) and hasMoved then
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

    setActive(bypassToggled)
    return panel
end

local function createTPBatFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TPBatButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 22
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local BTN_W, BTN_H = 60, 60
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    btnFrame.Name = "Frame"
    if tpBatFloatingPos then
        btnFrame.Position = UDim2.new(tpBatFloatingPos.XScale or 1,
                                      tpBatFloatingPos.XOffset or -206,
                                      tpBatFloatingPos.YScale or 0,
                                      tpBatFloatingPos.YOffset or 70)
    else
        btnFrame.Position = UDim2.new(1, -206, 0, 70)
    end
    btnFrame.BackgroundColor3 = tpBatEnabled and ACTIVE_BG or INACTIVE_BG
    btnFrame.BackgroundTransparency = 0
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    local corner = Instance.new("UICorner", btnFrame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Thickness = 1.8
    stroke.Transparency = editModeEnabled and 0 or 0.1
    stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    })
    grad.Rotation = 0
    task.spawn(function()
        while grad and grad.Parent do
            grad.Rotation = (grad.Rotation + 0.8) % 360
            task.wait(0.025)
        end
    end)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = tpBatEnabled and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local function setActive(state)
        if state then
            btnFrame.BackgroundColor3 = ACTIVE_BG
            label.TextColor3 = Color3.fromRGB(0, 0, 0)
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(0, 150, 255)
            stroke.Transparency = 0
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 200, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 255))
            })
        else
            btnFrame.BackgroundColor3 = INACTIVE_BG
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            stroke.Color = editModeEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)
            stroke.Transparency = editModeEnabled and 0 or 0.1
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 150, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
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
            if hasMoved then
                if not uiLocked or editModeEnabled then
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
                    toggleTPBat(not tpBatEnabled)
                    setActive(tpBatEnabled)
                elseif (not uiLocked or editModeEnabled) and hasMoved then
                    tpBatFloatingPos = {
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

    return panel
end

-- ============================================================
--  CONSTRUCCIÓN E INICIALIZACIÓN FINAL
-- ============================================================
buildGui()
if loadAllSettings() then
    updateUIFromLoaded()
end

instaResetFloatingButton = createInstaResetFloatingButton()
bypassFloatingButton = createBypassFloatingButton()
tpBatFloatingButton = createTPBatFloatingButton()

if LP.Character then
    task.wait(0.0)
    setupSpeedIndicator(LP.Character)
end

if introEnabled then
    task.spawn(playCandyIntro)
end
if intro2Enabled then
    task.spawn(playIntro2Music)
end

-- ============================================================
--  RECONEXIÓN AL RESPAWN
-- ============================================================
LP.CharacterAdded:Connect(function(char)
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopAutoTPDown()
    stopUnwalk()
    stopDropBrainrot()
    stopMedusaAutoReset()
    if autoBatEnabled then disableAutoBat() end
    if bypassToggled then stopBypassAimbot() end
    if galaxyEnabled then
        removeGalaxySky()
        applyGalaxySky()
    end
    if tpBatEnabled then
        stopTPBatLoop()
        task.wait(0.1)
        startTPBatLoop()
    end
    if ragdollTimerEnabled then
        stopRagdollTimer()
        task.wait(0.1)
        startRagdollTimer()
    end
    if antiRagdollEnabled then
        stopAntiRagdoll()
        task.wait(0.1)
        startAntiRagdoll()
    end
    if meleeAimbotEnabled then
        stopMeleeAimbot()
        task.wait(0.1)
        startMeleeAimbot()
    end
    if espEnabled then
        stopESP()
        task.wait(0.1)
        startESP()
    end

    task.wait(0.1)
    while not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid") do
        task.wait()
    end

    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementConn then movementConn:Disconnect(); movementConn = nil end

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

    movementConn = RunService.Heartbeat:Connect(movementLoop)  -- reconectar el nuevo bucle

    setupSpeedIndicator(char)

    if autoBatEnabled then enableAutoBat() end
    if autoLeftEnabled then startAutoLeft() end
    if autoRightEnabled then startAutoRight() end
    if bypassToggled then toggleBypass(true) end
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
    if ragdollTimerEnabled then startRagdollTimer() end

    if zombieEnabled then
        task.wait(0.5)
        applyZombiePack()
    end

    if adidasAuraEnabled then
        task.wait(0.5)
        applyAdidasAuraPack()
    end

    if vampireEnabled then
        task.wait(0.5)
        applyVampirePack()
    end

    if amazonEnabled then
        task.wait(0.5)
        applyAmazonPack()
    end

    refreshSpeedModeLabel()
end)

-- ============================================================
--  KEYBINDS
-- ============================================================
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
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.Bypass, kc) then
        toggleBypass()
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
    if kbMatch(KB.TPBat, kc) then
        toggleTPBat(not tpBatEnabled)
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

print("✅ Surehub v2 (con Auto Steal, ESP Player, Zombie, Adidas Aura, Vampire y Amazon Unboxed) cargado correctamente.")
print("✅ Nuevo sistema de movimiento con bypass activo.")

-- ============================================================
--  AUTO STEAL (incluido en el mismo script)
-- ============================================================
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local plots = workspace:FindFirstChild("Plots")
    local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

    local STEAL_CONFIG = {
        AUTO_STEAL_ENABLED = true,
        HOLD_MIN = 1.3,
        HOLD_MAX = 2.6,
        ENTRY_DELAY = 0.3,
        COOLDOWN = 0.05,
        STEAL_RANGE = 9,
        PRIME_RANGE = 80
    }

    local StealState = {
        active = false,
        startTime = 0,
        phase = "idle",
        label = "",
        lastResult = "",
        lastResultTime = 0,
        totalSteals = 0,
        failedSteals = 0
    }

    local AnimalsData = {}
    local syncRemotes = nil
    local plotAnimalSync = {caches = {}, connections = {}}
    local allAnimalsCache = {}
    local PromptMemoryCache = {}
    local InternalStealCache = {}
    local stealConnection = nil

    local function initializeAutoStealSync()
        local ok = pcall(function()
            local Packages = ReplicatedStorage:FindFirstChild("Packages") or ReplicatedStorage:WaitForChild("Packages", 1)
            local Datas = ReplicatedStorage:FindFirstChild("Datas") or ReplicatedStorage:WaitForChild("Datas", 1)
            if not Packages or not Datas then return end
            AnimalsData = require(Datas:WaitForChild("Animals"))
            local folder = Packages:WaitForChild("Synchronizer")
            syncRemotes = {
                channelFolder = folder:WaitForChild("Channel"),
                routeRemote = folder:WaitForChild("CommunicationRoute"),
                requestData = folder:FindFirstChild("RequestData")
            }
        end)
        return ok and syncRemotes ~= nil
    end

    local function splitSyncPath(path)
        if typeof(path) == "table" then return path end
        local out = {}
        for part in string.gmatch(tostring(path), "[^%.]+") do
            table.insert(out, tonumber(part) or part)
        end
        return out
    end

    local function resolveSyncPath(path, root)
        local current = root
        local parent = nil
        local key = nil
        for _, part in ipairs(splitSyncPath(path)) do
            parent = current
            key = part
            current = current and current[part] or nil
        end
        return current, parent, key
    end

    local function applyPlotSyncDiff(channelName, packet)
        local cache = plotAnimalSync.caches[channelName]
        if typeof(cache) ~= "table" then return end
        local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
        local current, parent, key = resolveSyncPath(path, cache)
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
        if not syncRemotes or plotAnimalSync.connections[remote] then return end
        local channelName = tostring(remote.Name)
        if not plots:FindFirstChild(channelName) then return end
        if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
            local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
            plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
        elseif plotAnimalSync.caches[channelName] == nil then
            plotAnimalSync.caches[channelName] = {}
        end
        plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
            for _, packet in ipairs(queue) do
                applyPlotSyncDiff(channelName, packet)
            end
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

    local function startAutoStealSync()
        if not initializeAutoStealSync() then return false end
        for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
            if child:IsA("RemoteEvent") then attachPlotChannel(child) end
        end
        syncRemotes.channelFolder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") then attachPlotChannel(child) end
        end)
        syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
            for _, action in ipairs(actions) do
                local kind, channelName = action[1], tostring(action[2])
                if not plots:FindFirstChild(channelName) then continue end
                if kind == "ListenerAdded" then
                    local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
                    if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
                elseif kind == "ListenerRemoved" then
                    detachPlotChannel(channelName)
                end
            end
        end)
        return true
    end

    local function getPlotChannelData(plotName)
        return plotAnimalSync.caches[plotName]
    end

    local function getPlotOwner(plot)
        local sign = plot:FindFirstChild("PlotSign")
        local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label or label.Text == "Empty Base" then return nil end
        return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end

    local function isMyBaseAnimal(animalData)
        if not animalData or not animalData.plot then return false end
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then return false end
        return getPlotOwner(plot) == LP.DisplayName
    end

    local function findProximityPromptForAnimal(animalData)
        if not animalData then return nil end
        local cached = PromptMemoryCache[animalData.uid]
        if cached and cached.Parent then return cached end
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then return nil end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil end
        local podium = podiums:FindFirstChild(animalData.slot)
        if not podium then return nil end
        local base = podium:FindFirstChild("Base")
        if not base then return nil end
        local spawn = base:FindFirstChild("Spawn")
        if not spawn then return nil end
        local attach = spawn:FindFirstChild("PromptAttachment")
        if not attach then return nil end
        for _, p in ipairs(attach:GetChildren()) do
            if p:IsA("ProximityPrompt") then
                PromptMemoryCache[animalData.uid] = p
                return p
            end
        end
        return nil
    end

    local function getAnimalPosition(animalData)
        local plot = plots:FindFirstChild(animalData.plot)
        if not plot then return nil end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then return nil end
        local podium = podiums:FindFirstChild(animalData.slot)
        if not podium then return nil end
        return podium:GetPivot().Position
    end

    local function distToAnimal(animalData)
        local char = LP.Character
        if not char then return math.huge end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
        if not hrp then return math.huge end
        local pos = getAnimalPosition(animalData)
        if not pos then return math.huge end
        return (hrp.Position - pos).Magnitude
    end

    local function pickClosest()
        local char = LP.Character
        if not char then return nil end
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
        if not hrp then return nil end
        local best, bestDist = nil, math.huge
        for _, animalData in ipairs(allAnimalsCache) do
            if isMyBaseAnimal(animalData) then continue end
            local pos = getAnimalPosition(animalData)
            if not pos then continue end
            local dist = (hrp.Position - pos).Magnitude
            if dist > STEAL_CONFIG.PRIME_RANGE then continue end
            if dist < bestDist then
                bestDist = dist
                best = animalData
            end
        end
        return best
    end

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
        local ok1, conns1 = false, nil
        if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
        if ok1 and type(conns1) == "table" then
            for _, conn in ipairs(conns1) do
                if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
            end
        end
        local ok2, conns2 = false, nil
        if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
        if ok2 and type(conns2) == "table" then
            for _, conn in ipairs(conns2) do
                if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
            end
        end
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then InternalStealCache[prompt] = data end
    end

    local function executeStealAsync(prompt, animalData)
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        local label = animalData.name or "Animal"
        StealState.active = true
        StealState.startTime = tick()
        StealState.phase = "holding"
        StealState.label = label
        task.spawn(function()
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
            task.wait(STEAL_CONFIG.HOLD_MIN)
            StealState.phase = "waitingRange"
            local alreadyInRange = distToAnimal(animalData) <= STEAL_CONFIG.STEAL_RANGE
            local fired = false
            while true do
                local elapsed = tick() - StealState.startTime
                if elapsed > STEAL_CONFIG.HOLD_MAX then break end
                if not prompt.Parent then break end
                if distToAnimal(animalData) <= STEAL_CONFIG.STEAL_RANGE then
                    if not alreadyInRange then task.wait(STEAL_CONFIG.ENTRY_DELAY) end
                    for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                    fired = true
                    break
                end
                task.wait()
            end
            if fired then
                StealState.totalSteals = StealState.totalSteals + 1
                StealState.lastResult = "Stole " .. label
                StealState.phase = "success"
            else
                StealState.failedSteals = StealState.failedSteals + 1
                StealState.lastResult = "Missed window: " .. label
                StealState.phase = "failed"
            end
            StealState.active = false
            StealState.lastResultTime = tick()
            task.wait(STEAL_CONFIG.COOLDOWN)
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
            local cache = getPlotChannelData(plot.Name)
            if not cache then continue end
            local animalList = cache.AnimalList
            if typeof(animalList) ~= "table" then continue end
            for slot, animalData in pairs(animalList) do
                if type(animalData) == "table" then
                    local animalName = animalData.Index
                    local animalInfo = AnimalsData[animalName]
                    if not animalInfo then continue end
                    table.insert(newCache, {
                        name = animalInfo.DisplayName or animalName,
                        plot = plot.Name,
                        slot = tostring(slot),
                        uid = plot.Name .. "_" .. tostring(slot)
                    })
                end
            end
        end
        allAnimalsCache = newCache
        return #allAnimalsCache
    end

    local function startAutoStealLoop()
        if stealConnection then return end
        stealConnection = RunService.Heartbeat:Connect(function()
            if not STEAL_CONFIG.AUTO_STEAL_ENABLED then return end
            if StealState.active then return end
            local target = pickClosest()
            if not target then return end
            local prompt = PromptMemoryCache[target.uid]
            if not prompt or not prompt.Parent then prompt = findProximityPromptForAnimal(target) end
            if prompt then attemptSteal(prompt, target) end
        end)
    end

    local function stopAutoStealLoop()
        if stealConnection then
            stealConnection:Disconnect()
            stealConnection = nil
        end
        StealState.active = false
        StealState.phase = "idle"
    end

    -- BARRA DE ESTADO
    local progressFill, progressPct, progressStripe, progressPillStroke, progressRadLbl
    local progressLastFill = 0

    local stats = game:GetService("Stats")
    local fpsCount = 0
    local fpsTimer = 0
    local currentFPS = 0
    local currentPing = 0

    local function createStatusBar()
        for _, gui in ipairs({game:GetService("CoreGui"):GetChildren()}) do
            if gui.Name == "StealPod" then gui:Destroy() end
        end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then
            for _, gui in ipairs(pg:GetChildren()) do
                if gui.Name == "StealPod" then gui:Destroy() end
            end
        end

        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "StealPod"
        screenGui.ResetOnSpawn = false
        screenGui.IgnoreGuiInset = true
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.DisplayOrder = 100

        local success, err = pcall(function()
            screenGui.Parent = game:GetService("CoreGui")
        end)
        if not success then
            screenGui.Parent = LP:WaitForChild("PlayerGui")
        end

        local pbFrame = Instance.new("Frame", screenGui)
        pbFrame.Name = "Main"
        pbFrame.Size = UDim2.new(0, 300, 0, 52)
        if stealBarPosition then
            pbFrame.Position = UDim2.new(stealBarPosition.XScale, stealBarPosition.XOffset,
                                          stealBarPosition.YScale, stealBarPosition.YOffset)
        else
            pbFrame.Position = UDim2.new(0.5, -150, 0, 72)
        end
        pbFrame.BackgroundTransparency = 1
        pbFrame.BorderSizePixel = 0
        pbFrame.ClipsDescendants = false
        local mainCorner = Instance.new("UICorner", pbFrame)
        mainCorner.CornerRadius = UDim.new(0, 26)

        local bgImg = Instance.new("ImageLabel", pbFrame)
        bgImg.Size = UDim2.new(1, 0, 1, 0)
        bgImg.Position = UDim2.new(0, 0, 0, 0)
        bgImg.BackgroundTransparency = 1
        bgImg.Image = "rbxassetid://105710807617429"
        bgImg.ScaleType = Enum.ScaleType.Crop
        bgImg.ZIndex = 0
        local bgCorner = Instance.new("UICorner", bgImg)
        bgCorner.CornerRadius = UDim.new(0, 26)

        local overlay = Instance.new("Frame", pbFrame)
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.Position = UDim2.new(0, 0, 0, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.45
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 1
        local overlayCorner = Instance.new("UICorner", overlay)
        overlayCorner.CornerRadius = UDim.new(0, 26)

        local pbs = Instance.new("UIStroke", pbFrame)
        pbs.Color = Color3.fromRGB(255, 255, 255)
        pbs.Thickness = 1.4
        pbs.Transparency = 0.4
        pbs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        progressStripe = Instance.new("Frame", pbFrame)
        progressStripe.Size = UDim2.new(0, 4, 1, -18)
        progressStripe.Position = UDim2.new(0, 8, 0, 9)
        progressStripe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progressStripe.BorderSizePixel = 0
        Instance.new("UICorner", progressStripe).CornerRadius = UDim.new(1, 0)
        progressStripe.ZIndex = 2

        local statusPill = Instance.new("Frame", pbFrame)
        statusPill.Size = UDim2.new(0, 158, 0, 24)
        statusPill.Position = UDim2.new(0, 20, 0, 7)
        statusPill.BackgroundColor3 = Color3.fromRGB(9, 12, 24)
        statusPill.BackgroundTransparency = 0.5
        statusPill.BorderSizePixel = 0
        Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
        statusPill.ZIndex = 3
        progressPillStroke = Instance.new("UIStroke", statusPill)
        progressPillStroke.Color = Color3.fromRGB(255, 255, 255)
        progressPillStroke.Thickness = 1
        progressPillStroke.Transparency = 0.45

        progressPct = Instance.new("TextLabel", statusPill)
        progressPct.Size = UDim2.new(1, -10, 1, 0)
        progressPct.Position = UDim2.new(0, 8, 0, 0)
        progressPct.BackgroundTransparency = 1
        progressPct.Text = "Surehub v2  |  Ping: --ms  |  FPS: --"
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
        progressPct.Font = Enum.Font.GothamBlack
        progressPct.TextSize = 9
        progressPct.TextXAlignment = Enum.TextXAlignment.Left
        progressPct.ZIndex = 4

        progressRadLbl = Instance.new("TextLabel", pbFrame)
        progressRadLbl.Size = UDim2.new(0, 104, 0, 24)
        progressRadLbl.Position = UDim2.new(1, -114, 0, 7)
        progressRadLbl.BackgroundTransparency = 1
        progressRadLbl.Text = "| Radius: " .. tostring(STEAL_CONFIG.STEAL_RANGE)
        progressRadLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        progressRadLbl.Font = Enum.Font.GothamBlack
        progressRadLbl.TextSize = 11
        progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
        progressRadLbl.ZIndex = 4

        local pbg = Instance.new("Frame", pbFrame)
        pbg.Size = UDim2.new(1, -40, 0, 9)
        pbg.Position = UDim2.new(0, 20, 1, -15)
        pbg.BackgroundColor3 = Color3.fromRGB(8, 10, 18)
        pbg.BackgroundTransparency = 0.4
        pbg.BorderSizePixel = 0
        Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)
        pbg.ZIndex = 3
        local pbgStroke = Instance.new("UIStroke", pbg)
        pbgStroke.Color = Color3.fromRGB(45, 65, 120)
        pbgStroke.Thickness = 1
        pbgStroke.Transparency = 0.45

        progressFill = Instance.new("Frame", pbg)
        progressFill.Size = UDim2.new(0, 0, 1, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progressFill.BorderSizePixel = 0
        Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)
        progressFill.ZIndex = 4
        local fillGrad = Instance.new("UIGradient", progressFill)
        fillGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
        fillGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.55),
            NumberSequenceKeypoint.new(1, 0)
        })

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local dragThreshold = 5

        pbFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                dragStart = input.Position
                startPos = pbFrame.Position
            end
        end)

        pbFrame.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
                    hasMoved = true
                end
                if hasMoved then
                    if not uiLocked or editModeEnabled then
                        pbFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                                      startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    else
                        dragging = false
                    end
                end
            end
        end)

        pbFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if hasMoved and (not uiLocked or editModeEnabled) then
                        stealBarPosition = {
                            XScale = pbFrame.Position.X.Scale,
                            XOffset = pbFrame.Position.X.Offset,
                            YScale = pbFrame.Position.Y.Scale,
                            YOffset = pbFrame.Position.Y.Offset
                        }
                        pcall(saveAllSettings)
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                end
            end
        end)
    end

    local function updateStealBar(dt)
        if not progressFill or not progressPct then return end

        fpsCount = fpsCount + 1
        fpsTimer = fpsTimer + (dt or 0.016)
        if fpsTimer >= 1 then
            currentFPS = fpsCount
            fpsCount = 0
            fpsTimer = 0
            pcall(function()
                local pingVal = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                if pingVal then currentPing = pingVal end
            end)
        end

        local targetPct = 0
        if StealState.active then
            targetPct = math.clamp((tick() - StealState.startTime) / STEAL_CONFIG.HOLD_MAX, 0, 1)
        elseif StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.4 then
            targetPct = 1
        else
            targetPct = 0
        end

        progressLastFill = progressLastFill + (targetPct - progressLastFill) * math.min((dt or 0.016) * 14, 1)
        progressFill.Size = UDim2.new(progressLastFill, 0, 1, 0)

        progressPct.Text = string.format("Surehub v2  |  Ping: %dms  |  FPS: %d", currentPing, currentFPS)
        progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
        progressPct.TextSize = 9
    end

    RunService.RenderStepped:Connect(updateStealBar)

    local function initAutoSteal()
        createStatusBar()
        local syncOk = startAutoStealSync()
        if syncOk then
            scanAllPlots()
            task.spawn(function()
                while task.wait(5) do scanAllPlots() end
            end)
            startAutoStealLoop()
            print("✅ Auto Steal activado con sincronización.")
        else
            print("⚠️ No se pudo iniciar la sincronización. El robo automático no funcionará.")
            STEAL_CONFIG.AUTO_STEAL_ENABLED = false
            if progressPct then
                progressPct.Text = "SYNC FAIL"
                progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end

    task.spawn(function()
        task.wait(1)
        initAutoSteal()
    end)

    _G.toggleAutoSteal = function(state)
        STEAL_CONFIG.AUTO_STEAL_ENABLED = (state == nil) and not STEAL_CONFIG.AUTO_STEAL_ENABLED or state
        if STEAL_CONFIG.AUTO_STEAL_ENABLED then
            startAutoStealLoop()
        else
            stopAutoStealLoop()
        end
        print("Auto Steal: " .. (STEAL_CONFIG.AUTO_STEAL_ENABLED and "ON" or "OFF"))
        pcall(saveAllSettings)
    end

    print("✅ Auto Steal integrado. Usa _G.toggleAutoSteal() para activar/desactivar.")
end