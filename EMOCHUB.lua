-- ============================================================
-- GUMBALL DUELS  v6.0  (VERSIÓN FINAL - TODO FUNCIONAL)
-- ============================================================

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local Stats           = game:GetService("Stats")
local LP              = Players.LocalPlayer

task.spawn(function() end)

local _isfile   = isfile   or (syn and syn.isfile)   or (getgenv and getgenv().isfile)   or function() return false end
local _readfile = readfile  or (syn and syn.readfile)  or (getgenv and getgenv().readfile)  or function() return nil  end
local _writefile= writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or function() end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

-- ============================================================
-- STATE
-- ============================================================
local State = {
    normalSpeed=60, carrySpeed=30, laggerSpeed=10.1,
    speedToggled=false, laggerEnabled=false,
    infJumpEnabled=false, antiRagdollEnabled=false, fpsBoostEnabled=false,
    holdJumpEnabled=false, holdJumpPower=65, holdJumpLoop=nil,
    guiVisible=true, uiLocked=false,
    isStealing=false, stealStartTime=nil, lastStealTick=0,
    autoLeftEnabled=false, autoRightEnabled=false,
    autoLeftPhase=1, autoRightPhase=1,
    medusaLastUsed=0, medusaDebounce=false, medusaCounterEnabled=false,
    autoMedusaEnabled=false, medusaCircle=nil, medusaAttacking=false,
    batAimbotToggled=false, autoSwingEnabled=false,
    hittingCooldown=false,
    batCounterEnabled=false, batCounterDebounce=false,
    dropEnabled=false, _tpInProgress=false,
    lastMoveDir=Vector3.new(0,0,0),
    unwalkEnabled=false, stackButtonsHidden=false,
    _prevCarry=30, _prevSpeed=false,
    duelCountdownEnabled=false, _duelWaiting=false,
    buttonShape = "round",
    guiScale = 0.85,
    buttonsScale = 1.0,
    medusaRange = 9.5,
    medusaCooldown = 0.12,
}

local Keys = {
    speed=Enum.KeyCode.Q, guiHide=Enum.KeyCode.LeftControl,
    autoLeft=Enum.KeyCode.L, autoRight=Enum.KeyCode.R,
    lagger=Enum.KeyCode.Unknown, tpDown=Enum.KeyCode.Unknown,
    drop=Enum.KeyCode.H, aimbot=Enum.KeyCode.Unknown,
    medusaToggle=Enum.KeyCode.M,
}

-- ============================================================
-- DEFAULT STACK BUTTON POSITIONS
-- ============================================================
local BTN_W=70; local BTN_H=60; local BTN_GAP=10; local COLS=2
local stackDefs = {
    {key="autoLeft",   label="AUTO LEFT"},
    {key="autoRight",  label="AUTO RIGHT"},
    {key="aimbot",     label="AIMBOT"},
    {key="lagger",     label="LAGGER"},
    {key="drop",       label="DROP BR"},
    {key="tpDown",     label="TP DOWN"},
    {key="carrySpeed", label="CARRY"},
}
local GRID_W=COLS*(BTN_W+BTN_GAP)-BTN_GAP
local GRID_H=math.ceil(#stackDefs/COLS)*(BTN_H+BTN_GAP)-BTN_GAP

local function getDefaultStackPos(i)
    local col=(i-1)%COLS
    local row2=math.floor((i-1)/COLS)
    return UDim2.new(1,-(GRID_W+14)+col*(BTN_W+BTN_GAP),0.5,-(GRID_H/2)+row2*(BTN_H+BTN_GAP))
end

local Steal = {
    AutoStealEnabled=false, StealRadius=20, StealDuration=0.25,
    Data={}, plotCache={}, plotCacheTime={}, cachedPrompts={}, promptCacheTime=0,
}

-- ============================================================
-- PRESETS
-- ============================================================
local Presets = {}
local PRESET_FILE = "GumballDuelsPresets.json"
local LAST_PRESET_FILE = "GumballDuelsLastPreset.json"
local CONFIG_FILE = "GumballDuelsConfig.json"

local function buildPresetSnapshot()
    return {
        normalSpeed   = State.normalSpeed,
        carrySpeed    = State.carrySpeed,
        laggerSpeed   = State.laggerSpeed,
        stealRadius   = Steal.StealRadius,
        stealDuration = Steal.StealDuration,
        infJump       = State.infJumpEnabled,
        holdJump      = State.holdJumpEnabled,
        holdJumpPower = State.holdJumpPower,
        antiRagdoll   = State.antiRagdollEnabled,
        fpsBoost      = State.fpsBoostEnabled,
        medusaCounter = State.medusaCounterEnabled,
        autoMedusa    = State.autoMedusaEnabled,
        medusaRange   = State.medusaRange,
        medusaCooldown= State.medusaCooldown,
        batCounter    = State.batCounterEnabled,
        autoSteal     = Steal.AutoStealEnabled,
        buttonShape   = State.buttonShape,
        guiScale      = State.guiScale,
        buttonsScale  = State.buttonsScale,
    }
end

local function savePresetsFile()
    local ok,encoded=pcall(function() return HttpService:JSONEncode(Presets) end)
    if ok then pcall(function() _writefile(PRESET_FILE,encoded) end) end
end

local function loadPresetsFile()
    local hasFile=false; pcall(function() hasFile=_isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=_readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,decoded=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and decoded then Presets=decoded end
end

local function saveLastPresetName(name)
    local ok, encoded = pcall(function() return HttpService:JSONEncode({lastPreset=name}) end)
    if ok then pcall(function() _writefile(LAST_PRESET_FILE, encoded) end) end
end

local function loadLastPresetName()
    local hasFile = false; pcall(function() hasFile = _isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw; pcall(function() raw = _readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and decoded then return decoded.lastPreset end
    return nil
end

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15
local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15

local POS={
    L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80),
    R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.04,-5.09,23.14),
}

local Conns={autoSteal=nil,antiRag=nil,autoLeft=nil,autoRight=nil,aimbot=nil,anchor={},progress=nil,batCounter=nil,unwalk=nil,autoMedusa=nil}

local h,hrp
local setAutoLeft,setAutoRight,setInfJump,setHoldJump,setAntiRag,setFps,setHoldJumpPower
local setMedusaCounter,setUnwalkToggle,setAimbot,setAutoSwing
local setLagger,setDropBrainrot,setInstaGrab
local setupMedusaCounter,stopMedusaCounter,startAntiRagdoll,stopAntiRagdoll
local applyFPSBoost,startAutoSteal,stopAutoSteal
local startAutoLeft,stopAutoLeft,startAutoRight,stopAutoRight
local saveConfig,loadConfig,runDropBrainrot,stopDropBrainrot,doTpDown
local startBatAimbot,stopBatAimbot,startBatCounter,stopBatCounter,setBatCounter
local startAutoMedusa,stopAutoMedusa,setAutoMedusa
local stackBtnRefs={}; local stackWrappers={}; local keybindBtnRefs={}
local normalBox,carryBox,laggerBox,uiScaleBox,stealRadBox,medusaRangeBox,medusaCooldownBox,btnsScaleBox,holdJumpPowerBox
local setHideButtonsToggle
local radTB
local presetListFrame=nil
local presetNameBox=nil
local rebuildPresetList

-- ============================================================
-- COLORES (GREEN THEME)
-- ============================================================
local C = {
    winBg       = Color3.fromRGB(6, 12, 6),
    winBorder   = Color3.fromRGB(40, 120, 40),
    topBg       = Color3.fromRGB(8, 20, 8),
    topTitle    = Color3.fromRGB(255, 255, 255),
    topSub      = Color3.fromRGB(120, 200, 120),
    topBtn      = Color3.fromRGB(120, 200, 120),
    topBtnHov   = Color3.fromRGB(150, 230, 150),
    topDivider  = Color3.fromRGB(40, 120, 40),
    tabBarBg    = Color3.fromRGB(6, 14, 6),
    tabBarDiv   = Color3.fromRGB(40, 120, 40),
    tabIdle     = Color3.fromRGB(100, 170, 100),
    tabActive   = Color3.fromRGB(255, 255, 255),
    tabActiveBg = Color3.fromRGB(12, 40, 12),
    tabUnderline= Color3.fromRGB(80, 180, 80),
    sectionTxt  = Color3.fromRGB(120, 200, 120),
    sectionDiv  = Color3.fromRGB(40, 120, 40),
    rowBg       = Color3.fromRGB(0, 0, 0),
    rowBorder   = Color3.fromRGB(30, 90, 30),
    rowLabel    = Color3.fromRGB(255, 255, 255),
    rowSub      = Color3.fromRGB(110, 180, 110),
    rowValue    = Color3.fromRGB(200, 235, 200),
    rowHov      = Color3.fromRGB(12, 40, 12),
    inputBg     = Color3.fromRGB(10, 28, 10),
    inputBorder = Color3.fromRGB(35, 100, 35),
    inputFocus  = Color3.fromRGB(60, 180, 60),
    inputTxt    = Color3.fromRGB(255, 255, 255),
    pillOff     = Color3.fromRGB(18, 45, 18),
    pillOn      = Color3.fromRGB(30, 110, 30),
    dotOff      = Color3.fromRGB(35, 85, 35),
    dotOn       = Color3.fromRGB(255, 255, 255),
    pillBorder  = Color3.fromRGB(35, 100, 35),
    modeBtnBg   = Color3.fromRGB(10, 32, 10),
    modeBtnBrd  = Color3.fromRGB(35, 100, 35),
    modeBtnTxt  = Color3.fromRGB(110, 180, 110),
    modeBtnActBg= Color3.fromRGB(30, 110, 30),
    modeBtnActTx= Color3.fromRGB(255, 255, 255),
    chipBg      = Color3.fromRGB(15, 45, 15),
    chipBorder  = Color3.fromRGB(35, 100, 35),
    chipTxt     = Color3.fromRGB(130, 200, 130),
    btnBg       = Color3.fromRGB(18, 50, 18),
    btnBorder   = Color3.fromRGB(35, 100, 35),
    btnTxt      = Color3.fromRGB(255, 255, 255),
    btnHov      = Color3.fromRGB(35, 90, 35),
    stackBg     = Color3.fromRGB(8, 25, 8),
    stackBrd    = Color3.fromRGB(40, 120, 40),
    stackTxt    = Color3.fromRGB(180, 235, 180),
    stackActBg  = Color3.fromRGB(30, 110, 30),
    stackActBrd = Color3.fromRGB(80, 200, 80),
    stackActTxt = Color3.fromRGB(255, 255, 255),
    stackDot    = Color3.fromRGB(35, 85, 35),
    stackDotOn  = Color3.fromRGB(255, 255, 255),
    infoBg      = Color3.fromRGB(6, 14, 6),
    infoBrd     = Color3.fromRGB(40, 120, 40),
    infoTxt     = Color3.fromRGB(110, 180, 110),
    infoVal     = Color3.fromRGB(255, 255, 255),
    infoFill    = Color3.fromRGB(30, 110, 30),
    accent      = Color3.fromRGB(30, 110, 30),
    accentDim   = Color3.fromRGB(20, 70, 20),
    presetBg    = Color3.fromRGB(10, 28, 10),
    presetBrd   = Color3.fromRGB(40, 120, 40),
    presetLoad  = Color3.fromRGB(25, 100, 25),
    presetDel   = Color3.fromRGB(140, 60, 60),
    delBrd      = Color3.fromRGB(180, 80, 80),
    lockOn      = Color3.fromRGB(60, 180, 60),
    divider     = Color3.fromRGB(35, 100, 35),
}

-- ============================================================
-- FUNCIONES DE CONFIGURACIÓN
-- ============================================================
local function applyButtonShape(shape)
    State.buttonShape = shape
    for _, wrapper in pairs(stackWrappers) do
        if wrapper then
            local corner = wrapper:FindFirstChildOfClass("UICorner")
            if corner then
                if shape == "round" then
                    corner.CornerRadius = UDim.new(1, 0)
                else
                    corner.CornerRadius = UDim.new(0, 8)
                end
            end
        end
    end
end

local function applyGuiScale(scale)
    State.guiScale = scale
    if uiScaleObj then uiScaleObj.Scale = scale end
end

local function applyButtonsScale(scale)
    State.buttonsScale = scale
    for _, wrapper in pairs(stackWrappers) do
        if wrapper then
            local scaleObj = wrapper:FindFirstChild("ScaleObject")
            if not scaleObj then
                scaleObj = Instance.new("UIScale", wrapper)
                scaleObj.Name = "ScaleObject"
            end
            scaleObj.Scale = scale
        end
    end
end

-- ============================================================
-- HOLD JUMP MEJORADO (VERSIÓN PREMIUM)
-- ============================================================
local function updateHoldJumpRefs()
    local char = LP.Character
    if char then
        h = char:FindFirstChildOfClass("Humanoid")
        hrp = char:FindFirstChild("HumanoidRootPart")
    end
end

local holdJumpFloatBtn = nil
local holdJumpFloatFrame = nil

local function createHoldJumpFloatingButton()
    if holdJumpFloatFrame then return end

    holdJumpFloatFrame = Instance.new("Frame", gui)
    holdJumpFloatFrame.Name = "HoldJumpFloatBtn"
    holdJumpFloatFrame.Size = UDim2.new(0, 100, 0, 36)
    holdJumpFloatFrame.Position = UDim2.new(0, 10, 0.65, 0)
    holdJumpFloatFrame.BackgroundColor3 = Color3.fromRGB(15, 50, 15)
    holdJumpFloatFrame.BackgroundTransparency = 0.15
    holdJumpFloatFrame.BorderSizePixel = 0
    holdJumpFloatFrame.ZIndex = 20
    mkCorner(holdJumpFloatFrame, 10)
    mkStroke(holdJumpFloatFrame, Color3.fromRGB(40, 160, 40), 1)

    local btnCorner = Instance.new("UICorner", holdJumpFloatFrame)
    btnCorner.CornerRadius = UDim.new(0, 10)

    local btnText = Instance.new("TextLabel", holdJumpFloatFrame)
    btnText.Size = UDim2.new(1, 0, 1, 0)
    btnText.BackgroundTransparency = 1
    btnText.Text = "🔹 HOLD JUMP: OFF"
    btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnText.Font = Enum.Font.GothamBold
    btnText.TextSize = 9
    btnText.TextScaled = true
    btnText.ZIndex = 21

    local clickBtn = Instance.new("TextButton", holdJumpFloatFrame)
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.ZIndex = 22

    local dragData = {dragging=false, dragStart=nil, startPos=nil}
    holdJumpFloatFrame.InputBegan:Connect(function(inp)
        if State.uiLocked then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragData.dragging = true
            dragData.dragStart = inp.Position
            dragData.startPos = holdJumpFloatFrame.Position
        end
    end)
    holdJumpFloatFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragData.dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if dragData.dragging and inp.UserInputType == Enum.UserInputType.MouseMovement and not State.uiLocked then
            local delta = inp.Position - dragData.dragStart
            holdJumpFloatFrame.Position = UDim2.new(
                dragData.startPos.X.Scale,
                dragData.startPos.X.Offset + delta.X,
                dragData.startPos.Y.Scale,
                dragData.startPos.Y.Offset + delta.Y
            )
        end
    end)

    local function updateFloatBtnUI()
        if State.holdJumpEnabled then
            btnText.Text = "🔹 HOLD JUMP: ON  [" .. State.holdJumpPower .. "]"
            btnText.TextColor3 = Color3.fromRGB(100, 255, 100)
            mkStroke(holdJumpFloatFrame, Color3.fromRGB(100, 255, 100), 1)
            holdJumpFloatFrame.BackgroundColor3 = Color3.fromRGB(20, 65, 20)
        else
            btnText.Text = "🔹 HOLD JUMP: OFF"
            btnText.TextColor3 = Color3.fromRGB(255, 255, 255)
            mkStroke(holdJumpFloatFrame, Color3.fromRGB(40, 160, 40), 1)
            holdJumpFloatFrame.BackgroundColor3 = Color3.fromRGB(15, 50, 15)
        end
    end

    clickBtn.MouseButton1Click:Connect(function()
        setHoldJump(not State.holdJumpEnabled)
        updateFloatBtnUI()
        if holdJumpStatus then updateHoldJumpStatus() end
    end)

    clickBtn.MouseEnter:Connect(function()
        TweenService:Create(holdJumpFloatFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end)
    clickBtn.MouseLeave:Connect(function()
        TweenService:Create(holdJumpFloatFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.15}):Play()
    end)

    updateFloatBtnUI()
end

local function startHoldJump()
    if State.holdJumpLoop then return end
    updateHoldJumpRefs()

    State.holdJumpLoop = RunService.Heartbeat:Connect(function()
        if not State.holdJumpEnabled then return end
        if not h or not hrp then
            updateHoldJumpRefs()
            return
        end
        if h.Health <= 0 then return end

        local spacePressed = false
        pcall(function()
            spacePressed = UIS:IsKeyDown(Enum.KeyCode.Space)
            if not spacePressed then
                spacePressed = UIS:IsKeyDown(Enum.KeyCode.ButtonA) or UIS:IsKeyDown(Enum.KeyCode.ButtonX)
            end
        end)

        if spacePressed then
            hrp.AssemblyLinearVelocity = Vector3.new(
                hrp.AssemblyLinearVelocity.X,
                State.holdJumpPower,
                hrp.AssemblyLinearVelocity.Z
            )
            pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
    end)

    if not Conns.jumpRequest then
        Conns.jumpRequest = UIS.JumpRequest:Connect(function()
            if State.holdJumpEnabled and h and hrp and h.Health > 0 then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, State.holdJumpPower, hrp.AssemblyLinearVelocity.Z)
                return true
            end
        end)
    end

    print("[Hold Jump] Activado con potencia: " .. State.holdJumpPower)
end

local function stopHoldJump()
    if State.holdJumpLoop then
        State.holdJumpLoop:Disconnect()
        State.holdJumpLoop = nil
    end
    if Conns.jumpRequest then
        Conns.jumpRequest:Disconnect()
        Conns.jumpRequest = nil
    end
    print("[Hold Jump] Desactivado")
end

local function setHoldJump(enabled)
    State.holdJumpEnabled = enabled
    if enabled then
        startHoldJump()
        if not holdJumpFloatFrame then
            createHoldJumpFloatingButton()
        end
    else
        stopHoldJump()
    end
    if holdJumpStatus then updateHoldJumpStatus() end
end

local function setHoldJumpPower(power)
    if power >= 45 and power <= 150 then
        State.holdJumpPower = power
        print("[Hold Jump] Potencia ajustada a: " .. power)
        if holdJumpFloatFrame and State.holdJumpEnabled then
            local btnText = holdJumpFloatFrame:FindFirstChildOfClass("TextLabel")
            if btnText then
                btnText.Text = "🔹 HOLD JUMP: ON  [" .. power .. "]"
            end
        end
    end
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    updateHoldJumpRefs()
    if State.holdJumpEnabled then
        stopHoldJump()
        task.wait(0.1)
        startHoldJump()
    end
end)

-- ============================================================
-- SPEED
-- ============================================================
local function updateSpeed()
    if not h or not hrp then return end
    if State.batAimbotToggled or State.autoLeftEnabled or State.autoRightEnabled then return end

    local md = h.MoveDirection
    local spd = State.normalSpeed
    if State.laggerEnabled then
        spd = State.laggerSpeed
    elseif State.speedToggled then
        spd = State.carrySpeed
    end

    if md.Magnitude > 0 then
        State.lastMoveDir = md
        hrp.Velocity = Vector3.new(md.X * spd, hrp.Velocity.Y, md.Z * spd)
    elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
        local anyHeld = false
        for key in pairs(MOVE_KEYS) do
            if UIS:IsKeyDown(key) then
                anyHeld = true
                break
            end
        end
        if anyHeld then
            hrp.Velocity = Vector3.new(State.lastMoveDir.X * spd, hrp.Velocity.Y, State.lastMoveDir.Z * spd)
        end
    end
end

-- ============================================================
-- AUTO STEAL
-- ============================================================
local function resetProgressBar()
    if stealPctLbl then stealPctLbl.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function isMyPlotByName(pn)
    local ct = tick()
    if Steal.plotCache[pn] and (ct - (Steal.plotCacheTime[pn] or 0)) < PLOT_CACHE_DURATION then
        return Steal.plotCache[pn]
    end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        Steal.plotCache[pn] = false
        Steal.plotCacheTime[pn] = ct
        return false
    end
    local plot = plots:FindFirstChild(pn)
    if not plot then
        Steal.plotCache[pn] = false
        Steal.plotCacheTime[pn] = ct
        return false
    end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            local r = yb.Enabled == true
            Steal.plotCache[pn] = r
            Steal.plotCacheTime[pn] = ct
            return r
        end
    end
    Steal.plotCache[pn] = false
    Steal.plotCacheTime[pn] = ct
    return false
end

local function findNearestPrompt()
    local c = LP.Character
    if not c then return nil end
    local root = c:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    local ct = tick()
    if ct - Steal.promptCacheTime < PROMPT_CACHE_REFRESH and #Steal.cachedPrompts > 0 then
        local np, nd = nil, math.huge
        for _, data in ipairs(Steal.cachedPrompts) do
            if data.spawn then
                local dist = (data.spawn.Position - root.Position).Magnitude
                if dist <= Steal.StealRadius and dist < nd then
                    np = data.prompt
                    nd = dist
                end
            end
        end
        if np then return np end
    end

    Steal.cachedPrompts = {}
    Steal.promptCacheTime = ct
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end

    local np, nd = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end

        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local sp = base and base:FindFirstChild("Spawn")
                if sp then
                    local att = sp:FindFirstChild("PromptAttachment")
                    if att then
                        for _, child in ipairs(att:GetChildren()) do
                            if child:IsA("ProximityPrompt") then
                                local dist = (sp.Position - root.Position).Magnitude
                                table.insert(Steal.cachedPrompts, {prompt = child, spawn = sp})
                                if dist <= Steal.StealRadius and dist < nd then
                                    np = child
                                    nd = dist
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
    return np
end

local function executeSteal(prompt)
    local ct = tick()
    if ct - State.lastStealTick < STEAL_COOLDOWN then return end
    if State.isStealing then return end

    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c2 in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c2.Function then table.insert(Steal.Data[prompt].hold, c2.Function) end
                end
                for _, c2 in ipairs(getconnections(prompt.Triggered)) do
                    if c2.Function then table.insert(Steal.Data[prompt].trigger, c2.Function) end
                end
            else
                Steal.Data[prompt].useFallback = true
            end
        end)
    end

    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    State.isStealing = true
    State.stealStartTime = ct
    State.lastStealTick = ct

    if Conns.progress then Conns.progress:Disconnect() end
    Conns.progress = RunService.Heartbeat:Connect(function()
        if not State.isStealing then
            Conns.progress:Disconnect()
            return
        end
        local prog = math.clamp((tick() - State.stealStartTime) / Steal.StealDuration, 0, 1)
        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
        if stealPctLbl then stealPctLbl.Text = math.floor(prog * 100) .. "%" end
    end)

    task.spawn(function()
        local ok = false
        pcall(function()
            if not data.useFallback then
                for _, fn in ipairs(data.hold) do task.spawn(fn) end
                task.wait(Steal.StealDuration)
                for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                ok = true
            end
        end)
        if not ok and fireproximityprompt then
            pcall(function()
                fireproximityprompt(prompt)
                ok = true
            end)
        end
        if not ok then
            pcall(function()
                prompt:InputHoldBegin()
                task.wait(Steal.StealDuration)
                prompt:InputHoldEnd()
            end)
        end

        task.wait(Steal.StealDuration * 0.3)
        if Conns.progress then Conns.progress:Disconnect() end
        resetProgressBar()
        task.wait(0.05)
        data.ready = true
        State.isStealing = false
    end)
end

startAutoSteal = function()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or State.isStealing then return end
        local p = findNearestPrompt()
        if p then executeSteal(p) end
    end)
end

stopAutoSteal = function()
    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal = nil
    end
    State.isStealing = false
    State.lastStealTick = 0
    resetProgressBar()
end

-- ============================================================
-- AUTO MEDUSA
-- ============================================================
local function findMedusaTool()
    local char = LP.Character
    local backpack = LP:FindFirstChildOfClass("Backpack")
    local keywords = {"medusa", "Medusa's Head", "medusa's head"}
    local function search(container)
        if not container then return nil end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local nameLower = tool.Name:lower()
                for _, kw in ipairs(keywords) do
                    if nameLower:find(kw:lower()) then return tool end
                end
            end
        end
        return nil
    end
    return search(char) or search(backpack)
end

local function unequipMedusa()
    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local medusa = findMedusaTool()
    if medusa and medusa.Parent == char then
        pcall(function() humanoid:UnequipTools() end)
    end
end

local function enemyInRange()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LP and other.Character then
            local otherRoot = other.Character:FindFirstChild("HumanoidRootPart")
            local otherHum = other.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHum and otherHum.Health > 0 then
                local distance = (root.Position - otherRoot.Position).Magnitude
                if distance <= State.medusaRange then return true end
            end
        end
    end
    return false
end

local function createMedusaCircle()
    if State.medusaCircle then State.medusaCircle:Destroy() end
    State.medusaCircle = Instance.new("Part")
    State.medusaCircle.Name = "AutoMedusaRange"
    State.medusaCircle.Shape = Enum.PartType.Cylinder
    State.medusaCircle.Size = Vector3.new(0.2, State.medusaRange * 2, State.medusaRange * 2)
    State.medusaCircle.Color = Color3.fromRGB(0, 200, 0)
    State.medusaCircle.Material = Enum.Material.Neon
    State.medusaCircle.Transparency = 0.35
    State.medusaCircle.Anchored = true
    State.medusaCircle.CanCollide = false
    State.medusaCircle.Parent = workspace
end

local function updateMedusaCircle()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if State.medusaCircle and root then
        State.medusaCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, 2.6, 0)) * CFrame.Angles(0, 0, math.rad(90))
    end
end

startAutoMedusa = function()
    if Conns.autoMedusa then return end
    createMedusaCircle()
    Conns.autoMedusa = RunService.Heartbeat:Connect(function()
        if not State.autoMedusaEnabled then return end
        updateMedusaCircle()
        if not enemyInRange() then
            unequipMedusa()
            return
        end
        local medusa = findMedusaTool()
        if not medusa then return end
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid and medusa.Parent ~= char then
            pcall(function() humanoid:EquipTool(medusa) end)
        end
        local heldTool = char and char:FindFirstChildOfClass("Tool")
        if not heldTool or State.medusaAttacking then return end
        State.medusaAttacking = true
        heldTool:Activate()
        task.delay(State.medusaCooldown, function() State.medusaAttacking = false end)
    end)
end

stopAutoMedusa = function()
    if Conns.autoMedusa then Conns.autoMedusa:Disconnect(); Conns.autoMedusa = nil end
    if State.medusaCircle then State.medusaCircle:Destroy(); State.medusaCircle = nil end
    State.medusaAttacking = false
    unequipMedusa()
end

setAutoMedusa = function(enabled)
    State.autoMedusaEnabled = enabled
    if enabled then startAutoMedusa() else stopAutoMedusa() end
end

-- ============================================================
-- LIMPIEZA INICIAL
-- ============================================================
for _,name in pairs({"VyseSlottedGUI","VyseAsireGUI","VyseAsireHubV4","VyseAsireHubV5","VyseAsireHubV5_1","AsireHubV5_1","AsireHubV5_2","OpiumGGV5_2","ShadowGGV5_2","ShadowGGV6","GumballDuelsV6","AutoMedusaGUI","DigraResetGui","HoldJumpGUI"}) do
    pcall(function() local o=game:GetService("CoreGui"):FindFirstChild(name); if o then o:Destroy() end end)
    pcall(function() local o=LP:WaitForChild("PlayerGui"):FindFirstChild(name); if o then o:Destroy() end end)
end

-- ============================================================
-- ROOT GUI
-- ============================================================
local gui=Instance.new("ScreenGui")
gui.Name="GumballDuelsV6"; gui.ResetOnSpawn=false; gui.DisplayOrder=10
gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=LP:WaitForChild("PlayerGui")

local uiScaleObj=Instance.new("UIScale",gui); uiScaleObj.Scale=State.guiScale

-- ============================================================
-- HELPERS
-- ============================================================
local function mkCorner(p,r)
    local c=Instance.new("UICorner",p)
    if r == "full" then
        c.CornerRadius = UDim.new(1, 0)
    else
        c.CornerRadius = UDim.new(0, r or 8)
    end
    return c
end

local function mkStroke(p,col,th)
    local s=Instance.new("UIStroke",p); s.Color=col; s.Thickness=th or 1
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; return s
end

local function mkGradient(p,color1,color2,vertical)
    local grad=Instance.new("UIGradient",p)
    grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,color1),ColorSequenceKeypoint.new(1,color2)}
    grad.Rotation=vertical and 90 or 0
    return grad
end

-- ============================================================
-- DRAG
-- ============================================================
local function makeDraggable(frame,handle)
    local src=handle or frame
    local dragging,dragInput,dragStart,startPos=false,nil,nil,nil
    src.InputBegan:Connect(function(inp)
        if State.uiLocked then return end
        if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragStart=inp.Position; startPos=frame.Position
            inp.Changed:Connect(function() if inp.UserInputState==Enum.UserInputState.End then dragging=false end end)
        end
    end)
    src.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dragInput=inp end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp==dragInput and dragging and not State.uiLocked then
            local dx=inp.Position.X-dragStart.X; local dy=inp.Position.Y-dragStart.Y
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+dx,startPos.Y.Scale,startPos.Y.Offset+dy)
        end
    end)
end

local function makeStackDraggable(frame,onTap)
    local dragging,dragInput,dragStart,startPos=false,nil,nil,nil; local moved=false
    frame.InputBegan:Connect(function(inp)
        if State.uiLocked then return end
        if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
        dragging=true; moved=false; dragStart=inp.Position; startPos=frame.Position
        inp.Changed:Connect(function()
            if inp.UserInputState==Enum.UserInputState.End then
                if not moved and onTap then onTap() end; dragging=false; moved=false
            end
        end)
    end)
    frame.InputChanged:Connect(function(inp)
        if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then dragInput=inp end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp~=dragInput or not dragging then return end
        if State.uiLocked then return end
        local dx=inp.Position.X-dragStart.X; local dy=inp.Position.Y-dragStart.Y
        if math.abs(dx)>4 or math.abs(dy)>4 then moved=true end
        if moved and not State.uiLocked then
            frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+dx,startPos.Y.Scale,startPos.Y.Offset+dy)
        end
    end)
end

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local WIN_W = 340
local WIN_H = 520
local TITLE_H = 50
local TAB_H   = 35

local mainOuter = Instance.new("Frame", gui)
mainOuter.Name = "MainOuter"
mainOuter.Size = UDim2.new(0, WIN_W, 0, WIN_H)
mainOuter.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
mainOuter.BackgroundTransparency = 1
mainOuter.BorderSizePixel = 0
mainOuter.ClipsDescendants = true
mkCorner(mainOuter, 10)
mkStroke(mainOuter, C.winBorder, 1)
makeDraggable(mainOuter)

local bgGrad = Instance.new("Frame", mainOuter)
bgGrad.Name = "BgGradient"
bgGrad.Size = UDim2.new(1, 0, 1, 0)
bgGrad.BackgroundColor3 = C.winBg
bgGrad.BackgroundTransparency = 0
bgGrad.BorderSizePixel = 0
bgGrad.ZIndex = 0
mkCorner(bgGrad, 10)
mkGradient(bgGrad, Color3.fromRGB(10, 28, 10), Color3.fromRGB(6, 14, 6), true)

-- ============================================================
-- TITLE BAR
-- ============================================================
local titleBar = Instance.new("Frame", mainOuter)
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = C.topBg
titleBar.BackgroundTransparency = 0
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 5
mkCorner(titleBar, 10)
mkGradient(titleBar, Color3.fromRGB(15, 40, 15), Color3.fromRGB(8, 20, 8), true)

local logoFrame = Instance.new("Frame", titleBar)
logoFrame.Size = UDim2.new(0, 140, 0, 32)
logoFrame.Position = UDim2.new(0, 12, 0.5, -16)
logoFrame.BackgroundTransparency = 1
logoFrame.ZIndex = 6

local shadowLogo = Instance.new("TextLabel", logoFrame)
shadowLogo.Size = UDim2.new(1, 0, 1, 0)
shadowLogo.BackgroundTransparency = 1
shadowLogo.Text = "GUMBALL DUELS"
shadowLogo.TextColor3 = C.topTitle
shadowLogo.Font = Enum.Font.GothamBlack
shadowLogo.TextSize = 18
shadowLogo.TextScaled = true
shadowLogo.TextXAlignment = Enum.TextXAlignment.Left
shadowLogo.ZIndex = 7

local dotLogo = Instance.new("Frame", logoFrame)
dotLogo.Size = UDim2.new(0, 6, 0, 6)
dotLogo.Position = UDim2.new(1, 4, 0.5, -3)
dotLogo.BackgroundColor3 = C.accent
dotLogo.BorderSizePixel = 0
mkCorner(dotLogo, "full")

local subLogo = Instance.new("TextLabel", titleBar)
subLogo.Size = UDim2.new(0, 100, 0, 12)
subLogo.Position = UDim2.new(0, 12, 1, -14)
subLogo.BackgroundTransparency = 1
subLogo.Text = "gumball.duels"
subLogo.TextColor3 = C.topSub
subLogo.Font = Enum.Font.Gotham
subLogo.TextSize = 8
subLogo.TextXAlignment = Enum.TextXAlignment.Left
subLogo.ZIndex = 6

local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -36, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 70)
closeBtn.BackgroundTransparency = 0.8
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.ZIndex = 7
mkCorner(closeBtn, "full")
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play()
end)
closeBtn.MouseButton1Click:Connect(function() State.guiVisible = false; mainOuter.Visible = false end)

local titleDiv = Instance.new("Frame", mainOuter)
titleDiv.Size = UDim2.new(1, -24, 0, 1)
titleDiv.Position = UDim2.new(0, 12, 0, TITLE_H)
titleDiv.BackgroundColor3 = C.topDivider
titleDiv.BorderSizePixel = 0
titleDiv.ZIndex = 5

-- ============================================================
-- TAB BAR
-- ============================================================
local tabBar = Instance.new("Frame", mainOuter)
tabBar.Size = UDim2.new(1, -24, 0, TAB_H)
tabBar.Position = UDim2.new(0, 12, 0, TITLE_H + 4)
tabBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tabBar.BackgroundTransparency = 0.5
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 5
mkCorner(tabBar, 6)

local tabBarLL = Instance.new("UIListLayout", tabBar)
tabBarLL.FillDirection = Enum.FillDirection.Horizontal
tabBarLL.SortOrder = Enum.SortOrder.LayoutOrder
tabBarLL.Padding = UDim.new(0, 4)

-- ============================================================
-- CONTENT AREA
-- ============================================================
local CONTENT_Y = TITLE_H + TAB_H + 12
local contentBg = Instance.new("Frame", mainOuter)
contentBg.Size = UDim2.new(1, -24, 1, -CONTENT_Y - 12)
contentBg.Position = UDim2.new(0, 12, 0, CONTENT_Y)
contentBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
contentBg.BackgroundTransparency = 0.3
contentBg.BorderSizePixel = 0
contentBg.ClipsDescendants = true
contentBg.ZIndex = 2
mkCorner(contentBg, 6)

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local TABS = {"SPEED", "AIMBOT", "MECH", "MOVE", "MEDUSA", "SET"}
local currentTab = "SPEED"
local tabBtns = {}; local tabPages = {}

local TAB_COUNT = #TABS
for i, name in ipairs(TABS) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1/TAB_COUNT, -3, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = (name == currentTab) and 0.6 or 1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = (name == currentTab) and C.tabActive or C.tabIdle
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.ZIndex = 6
    mkCorner(btn, 4)

    local underline = Instance.new("Frame", btn)
    underline.Size = UDim2.new(0.5, 0, 0, 2)
    underline.Position = UDim2.new(0.25, 0, 1, -3)
    underline.BackgroundColor3 = C.tabUnderline
    underline.BorderSizePixel = 0
    underline.Visible = (name == currentTab)
    underline.ZIndex = 7

    tabBtns[name] = {btn = btn, underline = underline}

    btn.MouseEnter:Connect(function()
        if name ~= currentTab then
            TweenService:Create(btn, TweenInfo.new(0.1), {TextColor3 = C.tabActive, BackgroundTransparency = 0.7}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if name ~= currentTab then
            TweenService:Create(btn, TweenInfo.new(0.1), {TextColor3 = C.tabIdle, BackgroundTransparency = 1}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        currentTab = name
        for _, n in ipairs(TABS) do
            local t = tabBtns[n]; local active = (n == name)
            TweenService:Create(t.btn, TweenInfo.new(0.14), {
                TextColor3 = active and C.tabActive or C.tabIdle,
                BackgroundTransparency = active and 0.6 or 1,
            }):Play()
            t.underline.Visible = active
            if tabPages[n] then tabPages[n].Visible = active end
        end
    end)
end

-- ============================================================
-- PAGE BUILDERS
-- ============================================================
local currentPage = nil; local lo = 0
local function LO() lo = lo + 1; return lo end

local function makeGap(px)
    local f = Instance.new("Frame", currentPage)
    f.Size = UDim2.new(1, 0, 0, px or 5)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.LayoutOrder = LO()
end

local function makeSectionHeader(label)
    local wrap = Instance.new("Frame", currentPage)
    wrap.Size = UDim2.new(1, 0, 0, 25)
    wrap.BackgroundTransparency = 1; wrap.BorderSizePixel = 0; wrap.LayoutOrder = LO()
    local lbl = Instance.new("TextLabel", wrap)
    lbl.Size = UDim2.new(1, -12, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label and label:upper() or ""
    lbl.TextColor3 = C.sectionTxt
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function makeDivider()
    local div = Instance.new("Frame", currentPage)
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.new(0, 10, 0, 0)
    div.BackgroundColor3 = C.divider
    div.BorderSizePixel = 0
    div.LayoutOrder = LO()
end

local function makeInputRow(label, default, onChange)
    local row = Instance.new("Frame", currentPage)
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = C.rowBg
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    mkCorner(row, 4)

    local div = Instance.new("Frame", row)
    div.Size = UDim2.new(1, -20, 0, 1)
    div.Position = UDim2.new(0, 10, 1, -1)
    div.BackgroundColor3 = C.rowBorder; div.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -90, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.rowLabel
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local boxWrap = Instance.new("Frame", row)
    boxWrap.Size = UDim2.new(0, 65, 0, 26)
    boxWrap.Position = UDim2.new(1, -78, 0.5, -13)
    boxWrap.BackgroundColor3 = C.inputBg; boxWrap.BorderSizePixel = 0
    mkCorner(boxWrap, 4)
    local bs = mkStroke(boxWrap, C.inputBorder, 1)

    local box = Instance.new("TextBox", boxWrap)
    box.Size = UDim2.new(1, -8, 1, 0); box.Position = UDim2.new(0, 4, 0, 0)
    box.BackgroundTransparency = 1; box.Text = tostring(default)
    box.TextColor3 = C.inputTxt; box.Font = Enum.Font.GothamBold
    box.TextSize = 11; box.ClearTextOnFocus = false; box.ZIndex = 8
    box.TextXAlignment = Enum.TextXAlignment.Center
    box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.15), {Color=C.inputFocus}):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(bs, TweenInfo.new(0.15), {Color=C.inputBorder}):Play()
        if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
    end)
    return box, row
end

local function makeToggleRow(label, defaultOn, onToggle)
    local row = Instance.new("Frame", currentPage)
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = C.rowBg
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    mkCorner(row, 4)

    local div = Instance.new("Frame", row)
    div.Size = UDim2.new(1, -20, 0, 1); div.Position = UDim2.new(0, 10, 1, -1)
    div.BackgroundColor3 = C.rowBorder; div.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -75, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = C.rowLabel; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local pillBg = Instance.new("Frame", row)
    pillBg.Size = UDim2.new(0, 38, 0, 20); pillBg.Position = UDim2.new(1, -50, 0.5, -10)
    pillBg.BackgroundColor3 = defaultOn and C.pillOn or C.pillOff
    pillBg.BorderSizePixel = 0; pillBg.ZIndex = 7
    mkCorner(pillBg, 10); mkStroke(pillBg, C.pillBorder, 1)

    local dot = Instance.new("Frame", pillBg)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = defaultOn and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    dot.BackgroundColor3 = defaultOn and C.dotOn or C.dotOff
    dot.BorderSizePixel = 0; dot.ZIndex = 8; mkCorner(dot, 7)

    local isOn = defaultOn or false
    local function setV(on)
        isOn = on
        TweenService:Create(pillBg, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = on and C.pillOn or C.pillOff}):Play()
        TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = on and C.dotOn or C.dotOff
        }):Play()
    end
    local function toggle() isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end end

    local clk = Instance.new("TextButton", row)
    clk.Size = UDim2.new(1, -65, 1, 0); clk.BackgroundTransparency = 1
    clk.Text = ""; clk.ZIndex = 5; clk.BorderSizePixel = 0
    clk.MouseButton1Click:Connect(toggle)
    local pClk = Instance.new("TextButton", pillBg)
    pClk.Size = UDim2.new(1, 0, 1, 0); pClk.BackgroundTransparency = 1
    pClk.Text = ""; pClk.ZIndex = 9; pClk.BorderSizePixel = 0
    pClk.MouseButton1Click:Connect(toggle)
    return setV
end

local function getKeyDisplayName(kc)
    local n = kc.Name
    local gpNames = {
        ButtonA="A",ButtonB="B",ButtonX="X",ButtonY="Y",
        ButtonL1="LB",ButtonL2="LT",ButtonL3="LS",
        ButtonR1="RB",ButtonR2="RT",ButtonR3="RS",
        ButtonSelect="SEL",ButtonStart="STA",
        DPadUp="D-U",DPadDown="D-D",DPadLeft="D-L",DPadRight="D-R",
        Thumbstick1="LS",Thumbstick2="RS",
    }
    if gpNames[n] then return gpNames[n] end
    return n:sub(1, 3)
end

local function makeKeybindRow(label, currentKey, onChanged, keyName)
    local row = Instance.new("Frame", currentPage)
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = C.rowBg
    row.BackgroundTransparency = 0.5
    row.BorderSizePixel = 0
    row.LayoutOrder = LO()
    mkCorner(row, 4)

    local div = Instance.new("Frame", row)
    div.Size = UDim2.new(1, -20, 0, 1); div.Position = UDim2.new(0, 10, 1, -1)
    div.BackgroundColor3 = C.rowBorder; div.BorderSizePixel = 0

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -80, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = C.rowLabel; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local kbtn = Instance.new("TextButton", row)
    kbtn.Size = UDim2.new(0, 55, 0, 26); kbtn.Position = UDim2.new(1, -68, 0.5, -13)
    kbtn.BackgroundColor3 = C.chipBg; kbtn.BorderSizePixel = 0
    kbtn.Text = getKeyDisplayName(currentKey); kbtn.TextColor3 = C.chipTxt
    kbtn.Font = Enum.Font.GothamBold; kbtn.TextSize = 10; kbtn.ZIndex = 8
    mkCorner(kbtn, 4); local ks = mkStroke(kbtn, C.chipBorder, 1)

    local listening = false; local lconnKeyboard = nil; local lconnGamepad = nil
    local function stopL(key)
        listening = false
        if lconnKeyboard then lconnKeyboard:Disconnect(); lconnKeyboard = nil end
        if lconnGamepad  then lconnGamepad:Disconnect();  lconnGamepad = nil  end
        TweenService:Create(ks, TweenInfo.new(0.12), {Color=C.chipBorder}):Play()
        kbtn.TextColor3 = C.chipTxt
        if key then
            kbtn.Text = getKeyDisplayName(key)
            if onChanged then onChanged(key) end
            task.spawn(function() if saveConfig then pcall(saveConfig) end end)
        end
    end
    kbtn.MouseButton1Click:Connect(function()
        if listening then stopL(nil); return end
        listening = true; kbtn.Text = "..."
        kbtn.TextColor3 = C.inputTxt
        TweenService:Create(ks, TweenInfo.new(0.12), {Color=C.inputFocus}):Play()
        lconnKeyboard = UIS.InputBegan:Connect(function(inp)
            if not listening then return end
            if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if inp.KeyCode == Enum.KeyCode.Escape then stopL(nil); return end
            stopL(inp.KeyCode)
        end)
        lconnGamepad = UIS.InputBegan:Connect(function(inp)
            if not listening then return end
            if inp.UserInputType ~= Enum.UserInputType.Gamepad1
            and inp.UserInputType ~= Enum.UserInputType.Gamepad2
            and inp.UserInputType ~= Enum.UserInputType.Gamepad3
            and inp.UserInputType ~= Enum.UserInputType.Gamepad4 then return end
            local kc = inp.KeyCode; if kc == Enum.KeyCode.Unknown then return end
            stopL(kc)
        end)
    end)
    if keyName then keybindBtnRefs[keyName] = kbtn end
    return kbtn
end

local function buildPage(tabName, buildFn)
    local page = Instance.new("ScrollingFrame", contentBg)
    page.Name = tabName; page.Visible = (tabName == "SPEED")
    page.Size = UDim2.new(1, 0, 1, 0); page.Position = UDim2.new(0, 0, 0, 0)
    page.BackgroundTransparency = 1; page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = C.accent
    page.ScrollBarImageTransparency = 0.5
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y; page.CanvasSize = UDim2.new(0, 0, 0, 0)
    local ll = Instance.new("UIListLayout", page)
    ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 4)
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 4)
    tabPages[tabName] = page; currentPage = page; lo = 0
    buildFn()
    currentPage = nil
end

-- ============================================================
-- SPEED PAGE
-- ============================================================
buildPage("SPEED", function()
    makeGap(4)
    makeSectionHeader("SPEED CONFIG")
    makeGap(1)

    normalBox = makeInputRow("Normal", State.normalSpeed, function(n)
        if n > 0 and n <= 500 then State.normalSpeed = n end
    end)
    carryBox = makeInputRow("Carry", State.carrySpeed, function(n)
        if n > 0 and n <= 500 then State.carrySpeed = n end
    end)
    laggerBox = makeInputRow("Lagger", State.laggerSpeed, function(n)
        if n > 0 and n <= 500 then State.laggerSpeed = n end
    end)

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("SPEED MODE")
    makeGap(1)

    local modeRow = Instance.new("Frame", currentPage)
    modeRow.Size = UDim2.new(1, 0, 0, 42)
    modeRow.BackgroundTransparency = 1; modeRow.BorderSizePixel = 0; modeRow.LayoutOrder = LO()

    local modeWrap = Instance.new("Frame", modeRow)
    modeWrap.Size = UDim2.new(1, -20, 0, 32)
    modeWrap.Position = UDim2.new(0, 10, 0, 5)
    modeWrap.BackgroundColor3 = C.modeBtnBg; modeWrap.BorderSizePixel = 0
    mkCorner(modeWrap, 5); mkStroke(modeWrap, C.modeBtnBrd, 1)

    local modeLL = Instance.new("UIListLayout", modeWrap)
    modeLL.FillDirection = Enum.FillDirection.Horizontal
    modeLL.SortOrder = Enum.SortOrder.LayoutOrder; modeLL.Padding = UDim.new(0, 0)

    local modeStatusRow = Instance.new("Frame", currentPage)
    modeStatusRow.Size = UDim2.new(1, 0, 0, 20)
    modeStatusRow.BackgroundTransparency = 1; modeStatusRow.BorderSizePixel = 0; modeStatusRow.LayoutOrder = LO()
    local modeStatusLbl = Instance.new("TextLabel", modeStatusRow)
    modeStatusLbl.Size = UDim2.new(1, -20, 1, 0); modeStatusLbl.Position = UDim2.new(0, 10, 0, 0)
    modeStatusLbl.BackgroundTransparency = 1; modeStatusLbl.Text = "Mode: Normal"
    modeStatusLbl.TextColor3 = C.rowSub; modeStatusLbl.Font = Enum.Font.Gotham
    modeStatusLbl.TextSize = 9; modeStatusLbl.TextXAlignment = Enum.TextXAlignment.Left

    local modeNames = {"Normal", "Carry", "Lagger"}
    local modeBtns = {}
    local function setModeActive(active)
        for _, m in ipairs(modeNames) do
            local b = modeBtns[m]; if not b then continue end
            local isActive = (m == active)
            TweenService:Create(b, TweenInfo.new(0.15), {
                BackgroundColor3 = isActive and C.modeBtnActBg or Color3.fromRGB(0,0,0),
                BackgroundTransparency = isActive and 0 or 1,
                TextColor3 = isActive and C.modeBtnActTx or C.modeBtnTxt,
            }):Play()
        end
        modeStatusLbl.Text = "Mode: " .. active
        if active == "Normal" then
            State.speedToggled = false; State.laggerEnabled = false
            if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
            if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(false) end
        elseif active == "Carry" then
            State.speedToggled = true; State.laggerEnabled = false
            if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(true) end
            if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(false) end
        elseif active == "Lagger" then
            State.speedToggled = false; State.laggerEnabled = true
            if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
            if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(true) end
        end
    end

    for i, mname in ipairs(modeNames) do
        local b = Instance.new("TextButton", modeWrap)
        b.Size = UDim2.new(1/3, 0, 1, 0)
        b.BackgroundColor3 = (i == 1) and C.modeBtnActBg or Color3.fromRGB(0,0,0)
        b.BackgroundTransparency = (i == 1) and 0 or 1
        b.BorderSizePixel = 0; b.Text = mname
        b.TextColor3 = (i == 1) and C.modeBtnActTx or C.modeBtnTxt
        b.Font = Enum.Font.GothamBold; b.TextSize = 10; b.ZIndex = 8
        b.LayoutOrder = i; mkCorner(b, 4)
        b.MouseButton1Click:Connect(function() setModeActive(mname) end)
        modeBtns[mname] = b
    end

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("KEYBINDS")
    makeGap(1)
    makeKeybindRow("Speed", Keys.speed, function(k) Keys.speed = k end, "speed")
    makeKeybindRow("Lagger", Keys.lagger, function(k) Keys.lagger = k end, "lagger")
    makeGap(4)
end)

-- ============================================================
-- AIMBOT PAGE
-- ============================================================
buildPage("AIMBOT", function()
    makeGap(4)
    makeSectionHeader("BAT AIMBOT")
    makeGap(1)
    setAutoSwing = makeToggleRow("Auto Swing", false, function(on) State.autoSwingEnabled = on end)
    setBatCounter = makeToggleRow("Bat Counter", false, function(on)
        State.batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)
    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("KEYBINDS")
    makeGap(1)
    makeKeybindRow("Aimbot", Keys.aimbot, function(k) Keys.aimbot = k end, "aimbot")
    makeGap(4)
end)

-- ============================================================
-- MECH PAGE
-- ============================================================
buildPage("MECH", function()
    makeGap(4)
    makeSectionHeader("JUMP")
    makeGap(1)

    setHoldJump = makeToggleRow("Hold Jump (Mejorado)", false, function(on)
        setHoldJump(on)
    end)

    holdJumpPowerBox = makeInputRow("Hold Jump Power", State.holdJumpPower, function(n)
        if n >= 45 and n <= 150 then setHoldJumpPower(n) end
    end)

    makeGap(4)
    makeDivider()
    makeGap(4)
    makeSectionHeader("INFINITE JUMP")
    makeGap(1)

    setInfJump = makeToggleRow("Infinite Jump", false, function(on)
        State.infJumpEnabled = on
    end)

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("STEALING")
    makeGap(1)

    setInstaGrab = makeToggleRow("Auto Steal", false, function(on)
        Steal.AutoStealEnabled = on
        if on then
            pcall(startAutoSteal)
        else
            stopAutoSteal()
        end
    end)

    stealRadBox = makeInputRow("Steal Radius", Steal.StealRadius, function(n)
        if n >= 5 and n <= 300 then
            Steal.StealRadius = math.floor(n)
            Steal.cachedPrompts = {}
            Steal.promptCacheTime = 0
            if radTB and not radTB:IsFocused() then radTB.Text = tostring(Steal.StealRadius) end
        end
    end)

    makeInputRow("Steal Duration", Steal.StealDuration, function(n)
        if n >= 0.05 and n <= 2 then Steal.StealDuration = n end
    end)

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("COMBAT / DEFENSE")
    makeGap(1)

    setAntiRag = makeToggleRow("Anti Ragdoll", false, function(on)
        State.antiRagdollEnabled = on
        if on then startAntiRagdoll() else stopAntiRagdoll() end
    end)

    setFps = makeToggleRow("FPS Boost", false, function(on)
        State.fpsBoostEnabled = on
        if on then pcall(applyFPSBoost) end
    end)

    setUnwalkToggle = makeToggleRow("Unwalk", false, function(on)
        State.unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    makeGap(4)
end)

-- ============================================================
-- MOVE PAGE
-- ============================================================
buildPage("MOVE", function()
    makeGap(4)
    makeSectionHeader("AUTO MOVEMENT")
    makeGap(1)
    makeKeybindRow("Auto Left", Keys.autoLeft, function(k) Keys.autoLeft = k end, "autoLeft")
    makeKeybindRow("Auto Right", Keys.autoRight, function(k) Keys.autoRight = k end, "autoRight")
    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("OTHER KEYS")
    makeGap(1)
    makeKeybindRow("Drop Key", Keys.drop, function(k) Keys.drop = k end, "drop")
    makeKeybindRow("TP Down Key", Keys.tpDown, function(k) Keys.tpDown = k end, "tpDown")
    makeGap(4)
end)

-- ============================================================
-- MEDUSA PAGE
-- ============================================================
buildPage("MEDUSA", function()
    makeGap(4)
    makeSectionHeader("AUTO MEDUSA")
    makeGap(1)

    makeToggleRow("Auto Medusa", false, function(on)
        setAutoMedusa(on)
    end)

    medusaRangeBox = makeInputRow("Range", State.medusaRange, function(n)
        if n >= 5 and n <= 20 then
            State.medusaRange = n
            if State.autoMedusaEnabled then
                stopAutoMedusa()
                startAutoMedusa()
            end
        end
    end)

    medusaCooldownBox = makeInputRow("Cooldown", State.medusaCooldown, function(n)
        if n >= 0.05 and n <= 1 then State.medusaCooldown = n end
    end)

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("MEDUSA COUNTER")
    makeGap(1)

    setMedusaCounter = makeToggleRow("Medusa Counter", false, function(on)
        State.medusaCounterEnabled = on
        if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
    end)

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("KEYBINDS")
    makeGap(1)
    makeKeybindRow("Medusa Toggle", Keys.medusaToggle, function(k) Keys.medusaToggle = k end, "medusaToggle")
    makeGap(4)
end)

-- ============================================================
-- SET PAGE
-- ============================================================
local function applyStackButtonsVisible(visible)
    State.stackButtonsHidden = not visible
    for _, wrapper in pairs(stackWrappers) do wrapper.Visible = visible end
end

local function applyPreset(data)
    if data.normalSpeed then State.normalSpeed=data.normalSpeed; if normalBox then normalBox.Text=tostring(data.normalSpeed) end end
    if data.carrySpeed  then State.carrySpeed=data.carrySpeed;   if carryBox  then carryBox.Text=tostring(data.carrySpeed)   end end
    if data.laggerSpeed then State.laggerSpeed=data.laggerSpeed; if laggerBox then laggerBox.Text=tostring(data.laggerSpeed)  end end
    if data.holdJumpPower then setHoldJumpPower(data.holdJumpPower); if holdJumpPowerBox then holdJumpPowerBox.Text = tostring(data.holdJumpPower) end end
    if data.stealRadius then
        Steal.StealRadius=data.stealRadius; Steal.cachedPrompts={}; Steal.promptCacheTime=0
        if stealRadBox and not stealRadBox:IsFocused() then stealRadBox.Text=tostring(data.stealRadius) end
        if radTB and not radTB:IsFocused() then radTB.Text=tostring(data.stealRadius) end
    end
    if data.stealDuration then Steal.StealDuration=data.stealDuration end
    if data.medusaRange then State.medusaRange = data.medusaRange; if medusaRangeBox then medusaRangeBox.Text = tostring(data.medusaRange) end end
    if data.medusaCooldown then State.medusaCooldown = data.medusaCooldown; if medusaCooldownBox then medusaCooldownBox.Text = tostring(data.medusaCooldown) end end
    if data.autoMedusa ~= nil then setAutoMedusa(data.autoMedusa) end
    if data.holdJump ~= nil then setHoldJump(data.holdJump) end
    if data.infJump~=nil and setInfJump then State.infJumpEnabled=data.infJump; setInfJump(data.infJump) end
    if data.antiRagdoll~=nil and setAntiRag then State.antiRagdollEnabled=data.antiRagdoll; setAntiRag(data.antiRagdoll); if data.antiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end end
    if data.fpsBoost~=nil and setFps then State.fpsBoostEnabled=data.fpsBoost; setFps(data.fpsBoost); if data.fpsBoost then pcall(applyFPSBoost) end end
    if data.medusaCounter~=nil and setMedusaCounter then State.medusaCounterEnabled=data.medusaCounter; setMedusaCounter(data.medusaCounter); if data.medusaCounter then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end
    if data.batCounter~=nil and setBatCounter then State.batCounterEnabled=data.batCounter; setBatCounter(data.batCounter); if data.batCounter then startBatCounter() else stopBatCounter() end end
    if data.autoSteal~=nil and setInstaGrab then
        Steal.AutoStealEnabled=data.autoSteal; setInstaGrab(data.autoSteal)
        if data.autoSteal then pcall(startAutoSteal) else stopAutoSteal() end
    end
    if data.buttonShape then applyButtonShape(data.buttonShape) end
    if data.guiScale then applyGuiScale(data.guiScale); if uiScaleBox then uiScaleBox.Text = tostring(data.guiScale) end end
    if data.buttonsScale then applyButtonsScale(data.buttonsScale); if btnsScaleBox then btnsScaleBox.Text = tostring(data.buttonsScale) end end
end

buildPage("SET", function()
    makeGap(4)
    makeSectionHeader("INTERFACE")
    makeGap(1)
    makeKeybindRow("Hide GUI", Keys.guiHide, function(k) Keys.guiHide = k end, "guiHide")

    local lockRow = Instance.new("Frame", currentPage)
    lockRow.Size = UDim2.new(1, 0, 0, 40)
    lockRow.BackgroundColor3 = C.rowBg
    lockRow.BackgroundTransparency = 0.5
    lockRow.BorderSizePixel = 0
    lockRow.LayoutOrder = LO()
    mkCorner(lockRow, 4)

    local lockDiv = Instance.new("Frame", lockRow)
    lockDiv.Size = UDim2.new(1, -20, 0, 1); lockDiv.Position = UDim2.new(0, 10, 1, -1)
    lockDiv.BackgroundColor3 = C.rowBorder; lockDiv.BorderSizePixel = 0

    local lockLbl = Instance.new("TextLabel", lockRow)
    lockLbl.Size = UDim2.new(1, -75, 1, 0); lockLbl.Position = UDim2.new(0, 12, 0, 0)
    lockLbl.BackgroundTransparency = 1; lockLbl.Text = "Lock UI Position"
    lockLbl.TextColor3 = C.rowLabel; lockLbl.Font = Enum.Font.GothamBold; lockLbl.TextSize = 10
    lockLbl.TextXAlignment = Enum.TextXAlignment.Left

    local lockPillBg = Instance.new("Frame", lockRow)
    lockPillBg.Size = UDim2.new(0, 38, 0, 20); lockPillBg.Position = UDim2.new(1, -50, 0.5, -10)
    lockPillBg.BackgroundColor3 = State.uiLocked and C.pillOn or C.pillOff
    lockPillBg.BorderSizePixel = 0; lockPillBg.ZIndex = 7
    mkCorner(lockPillBg, 10); mkStroke(lockPillBg, C.pillBorder, 1)

    local lockDot = Instance.new("Frame", lockPillBg)
    lockDot.Size = UDim2.new(0, 14, 0, 14)
    lockDot.Position = State.uiLocked and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    lockDot.BackgroundColor3 = State.uiLocked and C.dotOn or C.dotOff
    lockDot.BorderSizePixel = 0; lockDot.ZIndex = 8; mkCorner(lockDot, 7)

    local lockBtnSet = Instance.new("TextButton", lockRow)
    lockBtnSet.Size = UDim2.new(1, -65, 1, 0); lockBtnSet.BackgroundTransparency = 1
    lockBtnSet.Text = ""; lockBtnSet.ZIndex = 5; lockBtnSet.BorderSizePixel = 0
    lockBtnSet.MouseButton1Click:Connect(function()
        State.uiLocked = not State.uiLocked
        lockPillBg.BackgroundColor3 = State.uiLocked and C.pillOn or C.pillOff
        lockDot.Position = State.uiLocked and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
        lockDot.BackgroundColor3 = State.uiLocked and C.dotOn or C.dotOff
    end)

    local scaleRow = Instance.new("Frame", currentPage)
    scaleRow.Size = UDim2.new(1, 0, 0, 40)
    scaleRow.BackgroundColor3 = C.rowBg
    scaleRow.BackgroundTransparency = 0.5
    scaleRow.BorderSizePixel = 0
    scaleRow.LayoutOrder = LO()
    mkCorner(scaleRow, 4)

    local scaleDiv = Instance.new("Frame", scaleRow)
    scaleDiv.Size = UDim2.new(1, -20, 0, 1); scaleDiv.Position = UDim2.new(0, 10, 1, -1)
    scaleDiv.BackgroundColor3 = C.rowBorder; scaleDiv.BorderSizePixel = 0

    local scaleLbl = Instance.new("TextLabel", scaleRow)
    scaleLbl.Size = UDim2.new(1, -90, 1, 0); scaleLbl.Position = UDim2.new(0, 12, 0, 0)
    scaleLbl.BackgroundTransparency = 1; scaleLbl.Text = "UI Scale"
    scaleLbl.TextColor3 = C.rowLabel; scaleLbl.Font = Enum.Font.GothamBold; scaleLbl.TextSize = 10
    scaleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local scaleBoxWrap = Instance.new("Frame", scaleRow)
    scaleBoxWrap.Size = UDim2.new(0, 65, 0, 26); scaleBoxWrap.Position = UDim2.new(1, -78, 0.5, -13)
    scaleBoxWrap.BackgroundColor3 = C.inputBg; scaleBoxWrap.BorderSizePixel = 0
    mkCorner(scaleBoxWrap, 4)
    local sbs = mkStroke(scaleBoxWrap, C.inputBorder, 1)

    uiScaleBox = Instance.new("TextBox", scaleBoxWrap)
    uiScaleBox.Size = UDim2.new(1, -8, 1, 0); uiScaleBox.Position = UDim2.new(0, 4, 0, 0)
    uiScaleBox.BackgroundTransparency = 1; uiScaleBox.Text = tostring(State.guiScale)
    uiScaleBox.TextColor3 = C.inputTxt; uiScaleBox.Font = Enum.Font.GothamBold
    uiScaleBox.TextSize = 11; uiScaleBox.ClearTextOnFocus = false; uiScaleBox.ZIndex = 8
    uiScaleBox.TextXAlignment = Enum.TextXAlignment.Center
    uiScaleBox.Focused:Connect(function() TweenService:Create(sbs, TweenInfo.new(0.15), {Color=C.inputFocus}):Play() end)
    uiScaleBox.FocusLost:Connect(function()
        TweenService:Create(sbs, TweenInfo.new(0.15), {Color=C.inputBorder}):Play()
        local n = tonumber(uiScaleBox.Text)
        if n and n >= 0.5 and n <= 1.5 then applyGuiScale(n) else uiScaleBox.Text = tostring(State.guiScale) end
    end)

    local btnsScaleRow = Instance.new("Frame", currentPage)
    btnsScaleRow.Size = UDim2.new(1, 0, 0, 40)
    btnsScaleRow.BackgroundColor3 = C.rowBg
    btnsScaleRow.BackgroundTransparency = 0.5
    btnsScaleRow.BorderSizePixel = 0
    btnsScaleRow.LayoutOrder = LO()
    mkCorner(btnsScaleRow, 4)

    local btnsScaleDiv = Instance.new("Frame", btnsScaleRow)
    btnsScaleDiv.Size = UDim2.new(1, -20, 0, 1); btnsScaleDiv.Position = UDim2.new(0, 10, 1, -1)
    btnsScaleDiv.BackgroundColor3 = C.rowBorder; btnsScaleDiv.BorderSizePixel = 0

    local btnsScaleLbl = Instance.new("TextLabel", btnsScaleRow)
    btnsScaleLbl.Size = UDim2.new(1, -90, 1, 0); btnsScaleLbl.Position = UDim2.new(0, 12, 0, 0)
    btnsScaleLbl.BackgroundTransparency = 1; btnsScaleLbl.Text = "Buttons Scale"
    btnsScaleLbl.TextColor3 = C.rowLabel; btnsScaleLbl.Font = Enum.Font.GothamBold; btnsScaleLbl.TextSize = 10
    btnsScaleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local btnsScaleBoxWrap = Instance.new("Frame", btnsScaleRow)
    btnsScaleBoxWrap.Size = UDim2.new(0, 65, 0, 26); btnsScaleBoxWrap.Position = UDim2.new(1, -78, 0.5, -13)
    btnsScaleBoxWrap.BackgroundColor3 = C.inputBg; btnsScaleBoxWrap.BorderSizePixel = 0
    mkCorner(btnsScaleBoxWrap, 4)
    local bbs = mkStroke(btnsScaleBoxWrap, C.inputBorder, 1)

    btnsScaleBox = Instance.new("TextBox", btnsScaleBoxWrap)
    btnsScaleBox.Size = UDim2.new(1, -8, 1, 0); btnsScaleBox.Position = UDim2.new(0, 4, 0, 0)
    btnsScaleBox.BackgroundTransparency = 1; btnsScaleBox.Text = tostring(State.buttonsScale)
    btnsScaleBox.TextColor3 = C.inputTxt; btnsScaleBox.Font = Enum.Font.GothamBold
    btnsScaleBox.TextSize = 11; btnsScaleBox.ClearTextOnFocus = false; btnsScaleBox.ZIndex = 8
    btnsScaleBox.TextXAlignment = Enum.TextXAlignment.Center
    btnsScaleBox.Focused:Connect(function() TweenService:Create(bbs, TweenInfo.new(0.15), {Color=C.inputFocus}):Play() end)
    btnsScaleBox.FocusLost:Connect(function()
        TweenService:Create(bbs, TweenInfo.new(0.15), {Color=C.inputBorder}):Play()
        local n = tonumber(btnsScaleBox.Text)
        if n and n >= 0.6 and n <= 1.5 then applyButtonsScale(n) else btnsScaleBox.Text = tostring(State.buttonsScale) end
    end)

    setHideButtonsToggle = makeToggleRow("Hide Floating Buttons", false, function(on)
        applyStackButtonsVisible(not on)
    end)

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("BUTTON SHAPE")
    makeGap(1)

    local shapeRow = Instance.new("Frame", currentPage)
    shapeRow.Size = UDim2.new(1, 0, 0, 40)
    shapeRow.BackgroundTransparency = 0.5; shapeRow.BorderSizePixel = 0; shapeRow.LayoutOrder = LO()
    mkCorner(shapeRow, 4)

    local shapeLbl = Instance.new("TextLabel", shapeRow)
    shapeLbl.Size = UDim2.new(0.5, -12, 1, 0); shapeLbl.Position = UDim2.new(0, 12, 0, 0)
    shapeLbl.BackgroundTransparency = 1; shapeLbl.Text = "Shape"
    shapeLbl.TextColor3 = C.rowLabel; shapeLbl.Font = Enum.Font.GothamBold; shapeLbl.TextSize = 10
    shapeLbl.TextXAlignment = Enum.TextXAlignment.Left

    local shapeWrap = Instance.new("Frame", shapeRow)
    shapeWrap.Size = UDim2.new(0, 100, 0, 28); shapeWrap.Position = UDim2.new(1, -112, 0.5, -14)
    shapeWrap.BackgroundColor3 = C.modeBtnBg; shapeWrap.BorderSizePixel = 0
    mkCorner(shapeWrap, 4); mkStroke(shapeWrap, C.modeBtnBrd, 1)
    local shapeLL = Instance.new("UIListLayout", shapeWrap)
    shapeLL.FillDirection = Enum.FillDirection.Horizontal
    shapeLL.SortOrder = Enum.SortOrder.LayoutOrder; shapeLL.Padding = UDim.new(0, 0)

    local shapeBtns = {}
    local shapeOptions = {{"Square", "square"}, {"Round", "round"}}
    for i, opt in ipairs(shapeOptions) do
        local sb = Instance.new("TextButton", shapeWrap)
        sb.Size = UDim2.new(0.5, 0, 1, 0)
        local isActive = (State.buttonShape == opt[2])
        sb.BackgroundColor3 = isActive and C.modeBtnActBg or Color3.fromRGB(0,0,0)
        sb.BackgroundTransparency = isActive and 0 or 1
        sb.BorderSizePixel = 0
        sb.Text = opt[1]
        sb.TextColor3 = isActive and C.modeBtnActTx or C.modeBtnTxt
        sb.Font = Enum.Font.GothamBold; sb.TextSize = 10; sb.ZIndex = 6
        sb.LayoutOrder = i
        mkCorner(sb, 4)
        shapeBtns[opt[2]] = sb
        sb.MouseButton1Click:Connect(function()
            applyButtonShape(opt[2])
            for _, btn in pairs(shapeBtns) do
                local act = (btn == sb)
                TweenService:Create(btn, TweenInfo.new(0.15), {
                    BackgroundColor3 = act and C.modeBtnActBg or Color3.fromRGB(0,0,0),
                    BackgroundTransparency = act and 0 or 1,
                    TextColor3 = act and C.modeBtnActTx or C.modeBtnTxt,
                }):Play()
            end
        end)
    end

    makeGap(6)
    makeDivider()
    makeGap(4)
    makeSectionHeader("PRESETS")
    makeGap(1)

    local nameWrap = Instance.new("Frame", currentPage)
    nameWrap.Size = UDim2.new(1, 0, 0, 36); nameWrap.BackgroundTransparency = 1
    nameWrap.BorderSizePixel = 0; nameWrap.LayoutOrder = LO()
    local nameBoxWrap = Instance.new("Frame", nameWrap)
    nameBoxWrap.Size = UDim2.new(1, -20, 0, 28); nameBoxWrap.Position = UDim2.new(0, 10, 0, 4)
    nameBoxWrap.BackgroundColor3 = C.inputBg; nameBoxWrap.BorderSizePixel = 0; mkCorner(nameBoxWrap, 4)
    local nbs = mkStroke(nameBoxWrap, C.inputBorder, 1)
    presetNameBox = Instance.new("TextBox", nameBoxWrap)
    presetNameBox.Size = UDim2.new(1, -8, 1, 0); presetNameBox.Position = UDim2.new(0, 4, 0, 0)
    presetNameBox.BackgroundTransparency = 1; presetNameBox.PlaceholderText = "Preset name..."
    presetNameBox.PlaceholderColor3 = C.rowSub; presetNameBox.Text = ""
    presetNameBox.TextColor3 = C.inputTxt; presetNameBox.Font = Enum.Font.GothamBold
    presetNameBox.TextSize = 10; presetNameBox.ClearTextOnFocus = false; presetNameBox.ZIndex = 9
    presetNameBox.TextXAlignment = Enum.TextXAlignment.Left
    presetNameBox.Focused:Connect(function() TweenService:Create(nbs,TweenInfo.new(0.15),{Color=C.inputFocus}):Play() end)
    presetNameBox.FocusLost:Connect(function() TweenService:Create(nbs,TweenInfo.new(0.15),{Color=C.inputBorder}):Play() end)

    makeGap(1)

    local sWrap = Instance.new("Frame", currentPage)
    sWrap.Size = UDim2.new(1, 0, 0, 36); sWrap.BackgroundTransparency = 1
    sWrap.BorderSizePixel = 0; sWrap.LayoutOrder = LO()
    local savePBtn = Instance.new("TextButton", sWrap)
    savePBtn.Size = UDim2.new(1, -20, 0, 28); savePBtn.Position = UDim2.new(0, 10, 0, 4)
    savePBtn.BackgroundColor3 = C.btnBg; savePBtn.BorderSizePixel = 0
    savePBtn.Text = "Save Preset"; savePBtn.TextColor3 = C.btnTxt
    savePBtn.Font = Enum.Font.GothamBold; savePBtn.TextSize = 10; savePBtn.ZIndex = 9
    mkCorner(savePBtn, 4); mkStroke(savePBtn, C.btnBorder, 1)
    savePBtn.MouseEnter:Connect(function() TweenService:Create(savePBtn,TweenInfo.new(0.1),{BackgroundColor3=C.btnHov}):Play() end)
    savePBtn.MouseLeave:Connect(function() TweenService:Create(savePBtn,TweenInfo.new(0.1),{BackgroundColor3=C.btnBg}):Play() end)
    savePBtn.MouseButton1Click:Connect(function()
        local nm = presetNameBox.Text:match("^%s*(.-)%s*$")
        if nm == "" then savePBtn.Text = "Name!"; task.delay(1, function() savePBtn.Text = "Save Preset" end); return end
        local found = false
        for i, p in ipairs(Presets) do if p.name == nm then Presets[i].data = buildPresetSnapshot(); found = true; break end end
        if not found then table.insert(Presets, {name=nm, data=buildPresetSnapshot()}) end
        savePresetsFile(); presetNameBox.Text = ""
        savePBtn.Text = "Saved!"; task.delay(1, function() savePBtn.Text = "Save Preset" end)
        rebuildPresetList()
    end)

    makeGap(2)

    local listWrap = Instance.new("Frame", currentPage)
    listWrap.Size = UDim2.new(1, 0, 0, 0); listWrap.AutomaticSize = Enum.AutomaticSize.Y
    listWrap.BackgroundTransparency = 1; listWrap.BorderSizePixel = 0; listWrap.LayoutOrder = LO()
    local listLL = Instance.new("UIListLayout", listWrap)
    listLL.SortOrder = Enum.SortOrder.LayoutOrder; listLL.Padding = UDim.new(0, 3)
    local listPad = Instance.new("UIPadding", listWrap)
    listPad.PaddingLeft = UDim.new(0, 10); listPad.PaddingRight = UDim.new(0, 10)
    presetListFrame = listWrap

    local emptyLbl = Instance.new("TextLabel", listWrap)
    emptyLbl.Name = "EmptyLabel"; emptyLbl.Size = UDim2.new(1, 0, 0, 25)
    emptyLbl.BackgroundTransparency = 1; emptyLbl.Text = "No presets"
    emptyLbl.TextColor3 = C.rowSub; emptyLbl.Font = Enum.Font.Gotham; emptyLbl.TextSize = 9
    emptyLbl.TextXAlignment = Enum.TextXAlignment.Center; emptyLbl.LayoutOrder = 1

    makeGap(6)

    local fw = Instance.new("Frame", currentPage); fw.Size = UDim2.new(1, 0, 0, 25)
    fw.BackgroundTransparency = 1; fw.BorderSizePixel = 0; fw.LayoutOrder = LO()
    local fl = Instance.new("TextLabel", fw); fl.Size = UDim2.new(1, 0, 1, 0)
    fl.BackgroundTransparency = 1; fl.Text = "GUMBALL DUELS  v6.0"
    fl.TextColor3 = Color3.fromRGB(60, 120, 60); fl.Font = Enum.Font.Gotham; fl.TextSize = 8
    fl.TextXAlignment = Enum.TextXAlignment.Center
end)

rebuildPresetList = function()
    if not presetListFrame then return end
    for _, child in ipairs(presetListFrame:GetChildren()) do
        if child.Name ~= "EmptyLabel" and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    local emptyLbl = presetListFrame:FindFirstChild("EmptyLabel")
    if emptyLbl then emptyLbl.Visible = (#Presets == 0) end
    for i, preset in ipairs(Presets) do
        local row = Instance.new("Frame", presetListFrame)
        row.Name = "Preset_"..i; row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundColor3 = C.presetBg; row.BorderSizePixel = 0; row.LayoutOrder = i+1
        mkCorner(row, 4); mkStroke(row, C.presetBrd, 1)
        local nameLbl = Instance.new("TextLabel", row)
        nameLbl.Size = UDim2.new(1, -90, 1, 0); nameLbl.Position = UDim2.new(0, 10, 0, 0)
        nameLbl.BackgroundTransparency = 1; nameLbl.Text = preset.name
        nameLbl.TextColor3 = C.rowLabel; nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 10; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        local loadBtn = Instance.new("TextButton", row)
        loadBtn.Size = UDim2.new(0, 42, 0, 24); loadBtn.Position = UDim2.new(1, -90, 0.5, -12)
        loadBtn.BackgroundColor3 = C.presetLoad; loadBtn.BorderSizePixel = 0
        loadBtn.Text = "Load"; loadBtn.TextColor3 = Color3.fromRGB(255,255,255)
        loadBtn.Font = Enum.Font.GothamBold; loadBtn.TextSize = 9; loadBtn.ZIndex = 9
        mkCorner(loadBtn, 4)
        loadBtn.MouseEnter:Connect(function() TweenService:Create(loadBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(35,120,35)}):Play() end)
        loadBtn.MouseLeave:Connect(function() TweenService:Create(loadBtn,TweenInfo.new(0.1),{BackgroundColor3=C.presetLoad}):Play() end)
        loadBtn.MouseButton1Click:Connect(function()
            applyPreset(preset.data); saveLastPresetName(preset.name)
            loadBtn.Text = "OK"; task.delay(0.8, function() if loadBtn and loadBtn.Parent then loadBtn.Text = "Load" end end)
        end)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(0, 32, 0, 24); delBtn.Position = UDim2.new(1, -48, 0.5, -12)
        delBtn.BackgroundColor3 = C.presetDel; delBtn.BorderSizePixel = 0
        delBtn.Text = "X"; delBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
        delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 10; delBtn.ZIndex = 9
        mkCorner(delBtn, 4)
        delBtn.MouseEnter:Connect(function() TweenService:Create(delBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(180, 85, 85)}):Play() end)
        delBtn.MouseLeave:Connect(function() TweenService:Create(delBtn,TweenInfo.new(0.1),{BackgroundColor3=C.presetDel}):Play() end)
        delBtn.MouseButton1Click:Connect(function()
            table.remove(Presets, i); savePresetsFile(); rebuildPresetList()
        end)
    end
end

for _, n in ipairs(TABS) do
    local t = tabBtns[n]; local active = (n == "SPEED")
    t.btn.TextColor3 = active and C.tabActive or C.tabIdle
    t.btn.BackgroundTransparency = active and 0.6 or 1
    t.underline.Visible = active
    if tabPages[n] then tabPages[n].Visible = active end
end

-- ============================================================
-- VBTN (botón flotante GUMBALL DUELS)
-- ============================================================
local vBtnFrame = Instance.new("Frame", gui)
vBtnFrame.Name = "GumballDuelsVBtn"
vBtnFrame.Size = UDim2.new(0, 120, 0, 38)
vBtnFrame.Position = UDim2.new(1, -130, 0, 18)
vBtnFrame.BackgroundColor3 = Color3.fromRGB(15, 50, 15)
vBtnFrame.BackgroundTransparency = 0
vBtnFrame.BorderSizePixel = 0
vBtnFrame.Active = true
vBtnFrame.ZIndex = 20
mkCorner(vBtnFrame, 19)
mkStroke(vBtnFrame, Color3.fromRGB(40, 120, 40), 1)

local floatingText = Instance.new("TextLabel", vBtnFrame)
floatingText.Size = UDim2.new(1, 0, 1, 0)
floatingText.BackgroundTransparency = 1
floatingText.Text = "GUMBALL DUELS"
floatingText.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingText.Font = Enum.Font.GothamBold
floatingText.TextSize = 13
floatingText.TextScaled = true
floatingText.ZIndex = 21

local vDragging,vDragInput,vDragStart,vStartPos=false,nil,nil,nil; local vMoved=false
vBtnFrame.InputBegan:Connect(function(inp)
    if State.uiLocked then return end
    if inp.UserInputType~=Enum.UserInputType.MouseButton1 and inp.UserInputType~=Enum.UserInputType.Touch then return end
    vDragging=true; vMoved=false; vDragStart=inp.Position; vStartPos=vBtnFrame.Position
    inp.Changed:Connect(function()
        if inp.UserInputState==Enum.UserInputState.End then
            if not vMoved then State.guiVisible=not State.guiVisible; mainOuter.Visible=State.guiVisible end
            vDragging=false; vMoved=false
        end
    end)
end)
vBtnFrame.InputChanged:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch then vDragInput=inp end
end)
UIS.InputChanged:Connect(function(inp)
    if inp~=vDragInput or not vDragging then return end
    if State.uiLocked then return end
    local dx=inp.Position.X-vDragStart.X; local dy=inp.Position.Y-vDragStart.Y
    if math.abs(dx)>4 or math.abs(dy)>4 then vMoved=true end
    if vMoved then vBtnFrame.Position=UDim2.new(vStartPos.X.Scale,vStartPos.X.Offset+dx,vStartPos.Y.Scale,vStartPos.Y.Offset+dy) end
end)

-- ============================================================
-- INFO BAR
-- ============================================================
local infoBar = Instance.new("Frame", gui)
infoBar.Size = UDim2.new(0, 230, 0, 58)
infoBar.Position = UDim2.new(0.5, -115, 1, -72)
infoBar.BackgroundColor3 = C.infoBg
infoBar.BackgroundTransparency = 0.2
infoBar.BorderSizePixel = 0
infoBar.Active = true
mkCorner(infoBar, 8)
mkStroke(infoBar, C.infoBrd, 1)
makeDraggable(infoBar)

local ibAcc = Instance.new("Frame", infoBar)
ibAcc.Size = UDim2.new(0, 3, 0.7, 0); ibAcc.Position = UDim2.new(0, 0, 0.15, 0)
ibAcc.BackgroundColor3 = C.accent; ibAcc.BorderSizePixel = 0; mkCorner(ibAcc, 2)

local stealLbl = Instance.new("TextLabel", infoBar)
stealLbl.Size = UDim2.new(0, 100, 0, 14); stealLbl.Position = UDim2.new(0, 14, 0, 8)
stealLbl.BackgroundTransparency = 1; stealLbl.Text = "Steal Progress"
stealLbl.TextColor3 = C.infoTxt; stealLbl.Font = Enum.Font.GothamBold; stealLbl.TextSize = 9
stealLbl.TextXAlignment = Enum.TextXAlignment.Left

stealPctLbl = Instance.new("TextLabel", infoBar)
stealPctLbl.Size = UDim2.new(0, 45, 0, 14); stealPctLbl.Position = UDim2.new(1, -50, 0, 8)
stealPctLbl.BackgroundTransparency = 1; stealPctLbl.Text = "0%"; stealPctLbl.TextColor3 = C.infoVal
stealPctLbl.Font = Enum.Font.GothamBlack; stealPctLbl.TextSize = 10
stealPctLbl.TextXAlignment = Enum.TextXAlignment.Right

local pTrack = Instance.new("Frame", infoBar)
pTrack.Size = UDim2.new(1, -28, 0, 5); pTrack.Position = UDim2.new(0, 14, 0, 26)
pTrack.BackgroundColor3 = C.infoBrd; pTrack.BorderSizePixel = 0; mkCorner(pTrack, 2)
progressFill = Instance.new("Frame", pTrack)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = C.infoFill; progressFill.BorderSizePixel = 0; mkCorner(progressFill, 2)

local medusaStatus = Instance.new("TextLabel", infoBar)
medusaStatus.Size = UDim2.new(0, 100, 0, 12); medusaStatus.Position = UDim2.new(0, 14, 0, 42)
medusaStatus.BackgroundTransparency = 1
medusaStatus.Text = "Medusa: OFF"
medusaStatus.TextColor3 = Color3.fromRGB(200, 40, 40)
medusaStatus.Font = Enum.Font.GothamBold
medusaStatus.TextSize = 8
medusaStatus.TextXAlignment = Enum.TextXAlignment.Left

local holdJumpStatus = Instance.new("TextLabel", infoBar)
holdJumpStatus.Size = UDim2.new(0, 80, 0, 12); holdJumpStatus.Position = UDim2.new(1, -94, 0, 42)
holdJumpStatus.BackgroundTransparency = 1
holdJumpStatus.Text = "HoldJump: OFF"
holdJumpStatus.TextColor3 = Color3.fromRGB(200, 40, 40)
holdJumpStatus.Font = Enum.Font.GothamBold
holdJumpStatus.TextSize = 8
holdJumpStatus.TextXAlignment = Enum.TextXAlignment.Right

local function updateMedusaStatus()
    medusaStatus.Text = State.autoMedusaEnabled and "Medusa: ON" or "Medusa: OFF"
    medusaStatus.TextColor3 = State.autoMedusaEnabled and Color3.fromRGB(40, 210, 80) or Color3.fromRGB(200, 40, 40)
end

local function updateHoldJumpStatus()
    holdJumpStatus.Text = State.holdJumpEnabled and "HoldJump: ON" or "HoldJump: OFF"
    holdJumpStatus.TextColor3 = State.holdJumpEnabled and Color3.fromRGB(40, 210, 80) or Color3.fromRGB(200, 40, 40)
end

local function makeStatMini(xOff, w, icon)
    local box = Instance.new("Frame", infoBar)
    box.Size = UDim2.new(0, w, 0, 16); box.Position = UDim2.new(0, xOff, 0, 38)
    box.BackgroundTransparency = 1
    local iL = Instance.new("TextLabel", box); iL.Size = UDim2.new(0, 25, 1, 0)
    iL.BackgroundTransparency = 1; iL.Text = icon; iL.TextColor3 = C.infoTxt
    iL.Font = Enum.Font.GothamBold; iL.TextSize = 9
    local vL = Instance.new("TextLabel", box); vL.Size = UDim2.new(1, -25, 1, 0); vL.Position = UDim2.new(0, 25, 0, 0)
    vL.BackgroundTransparency = 1; vL.Text = "--"; vL.TextColor3 = C.infoVal
    vL.Font = Enum.Font.GothamBlack; vL.TextSize = 9; vL.TextXAlignment = Enum.TextXAlignment.Left
    return vL
end
local fpsVal = makeStatMini(12, 55, "FPS"); local pingVal = makeStatMini(75, 65, "PING")

local radWrap = Instance.new("Frame", infoBar)
radWrap.Size = UDim2.new(0, 80, 0, 16); radWrap.Position = UDim2.new(1, -90, 0, 38)
radWrap.BackgroundTransparency = 1
local radIco = Instance.new("TextLabel", radWrap)
radIco.Size = UDim2.new(0, 28, 1, 0); radIco.BackgroundTransparency = 1
radIco.Text = "RAD"; radIco.TextColor3 = C.infoTxt; radIco.Font = Enum.Font.GothamBold; radIco.TextSize = 9
radTB = Instance.new("TextBox", radWrap)
radTB.Size = UDim2.new(0, 45, 1, 0); radTB.Position = UDim2.new(0, 28, 0, 0)
radTB.BackgroundTransparency = 1; radTB.Text = tostring(Steal.StealRadius); radTB.TextColor3 = C.infoVal
radTB.Font = Enum.Font.GothamBlack; radTB.TextSize = 9; radTB.ClearTextOnFocus = false; radTB.ZIndex = 10
radTB.FocusLost:Connect(function()
    local n = tonumber(radTB.Text)
    if n and n >= 5 and n <= 300 then Steal.StealRadius = math.floor(n); Steal.cachedPrompts = {}; Steal.promptCacheTime = 0 end
    radTB.Text = tostring(Steal.StealRadius)
    if stealRadBox and not stealRadBox:IsFocused() then stealRadBox.Text = tostring(Steal.StealRadius) end
end)

do
    local lastT = tick(); local fc = 0
    RunService.RenderStepped:Connect(function()
        fc = fc + 1; local now = tick()
        if now - lastT >= 0.5 then
            local fps = math.floor(fc / (now - lastT)); fc = 0; lastT = now; fpsVal.Text = tostring(fps)
            fpsVal.TextColor3 = fps >= 55 and Color3.fromRGB(180,220,180) or fps >= 30 and Color3.fromRGB(220,220,150) or Color3.fromRGB(220,150,150)
        end
    end)
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                pingVal.Text = ping.."ms"
                pingVal.TextColor3 = ping <= 80 and Color3.fromRGB(180,220,180) or ping <= 150 and Color3.fromRGB(220,220,150) or Color3.fromRGB(220,150,150)
            end)
        end
    end)
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if not radTB:IsFocused() then radTB.Text = tostring(Steal.StealRadius) end
                if stealRadBox and not stealRadBox:IsFocused() then stealRadBox.Text = tostring(Steal.StealRadius) end
            end)
            updateMedusaStatus()
            updateHoldJumpStatus()
        end
    end)
end

-- ============================================================
-- STACK BUTTONS
-- ============================================================
for i, def in ipairs(stackDefs) do
    local btnFrame = Instance.new("Frame", gui)
    btnFrame.Name = "StackBtn_"..def.key
    btnFrame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
    btnFrame.Position = getDefaultStackPos(i)
    btnFrame.BackgroundColor3 = C.stackBg
    btnFrame.BorderSizePixel = 0
    btnFrame.Active = true
    btnFrame.ZIndex = 15

    local btnScale = Instance.new("UIScale", btnFrame)
    btnScale.Name = "ScaleObject"
    btnScale.Scale = State.buttonsScale

    local corner = Instance.new("UICorner", btnFrame)
    if State.buttonShape == "round" then
        corner.CornerRadius = UDim.new(1, 0)
    else
        corner.CornerRadius = UDim.new(0, 8)
    end
    local bStroke = mkStroke(btnFrame, C.stackBrd, 1)
    stackWrappers[def.key] = btnFrame

    local nl = Instance.new("TextLabel", btnFrame)
    nl.Size = UDim2.new(1, -6, 1, -10)
    nl.Position = UDim2.new(0, 3, 0, 3)
    nl.BackgroundTransparency = 1
    nl.Text = def.label
    nl.TextColor3 = C.stackTxt
    nl.Font = Enum.Font.GothamBlack
    nl.TextSize = 11
    nl.TextWrapped = true
    nl.TextXAlignment = Enum.TextXAlignment.Center
    nl.ZIndex = 6

    local dot = Instance.new("Frame", btnFrame)
    dot.Size = UDim2.new(0, 9, 0, 9)
    dot.Position = UDim2.new(0.5, -4.5, 1, -12)
    dot.BackgroundColor3 = C.stackDot
    dot.BorderSizePixel = 0
    mkCorner(dot, 4.5)

    local btnState = false
    local function setOn(on)
        btnState = on
        TweenService:Create(btnFrame, TweenInfo.new(0.15), {BackgroundColor3 = on and C.stackActBg or C.stackBg}):Play()
        TweenService:Create(bStroke, TweenInfo.new(0.15), {Color = on and C.stackActBrd or C.stackBrd}):Play()
        TweenService:Create(nl, TweenInfo.new(0.15), {TextColor3 = on and C.stackActTxt or C.stackTxt}):Play()
        TweenService:Create(dot, TweenInfo.new(0.15), {BackgroundColor3 = on and C.stackDotOn or C.stackDot}):Play()
    end
    stackBtnRefs[def.key] = {setOn = setOn}

    btnFrame.MouseEnter:Connect(function()
        if not btnState then TweenService:Create(btnFrame,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(12, 38, 12)}):Play() end
    end)
    btnFrame.MouseLeave:Connect(function()
        TweenService:Create(btnFrame,TweenInfo.new(0.1),{BackgroundColor3=btnState and C.stackActBg or C.stackBg}):Play()
    end)

    local function onTap()
        if def.key == "tpDown" then doTpDown(); return end
        if def.key == "carrySpeed" then State.speedToggled = not State.speedToggled; setOn(State.speedToggled); return end
        local ns = not btnState; setOn(ns)
        if def.key == "autoLeft" then
            State.autoLeftEnabled = ns
            if ns and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
            if ns then startAutoLeft() else stopAutoLeft() end
        elseif def.key == "autoRight" then
            State.autoRightEnabled = ns
            if ns and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
            if ns then startAutoRight() else stopAutoRight() end
        elseif def.key == "aimbot" then
            State.batAimbotToggled = ns
            if ns then
                if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end end
                if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end end
                pcall(startBatAimbot)
            else stopBatAimbot() end
        elseif def.key == "lagger" then
            State.laggerEnabled = ns
            if ns then
                State._prevCarry = State.carrySpeed
                State._prevSpeed = State.speedToggled
                State.speedToggled = false
                if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
                if carryBox then carryBox.Text = tostring(State.laggerSpeed) end
            else
                State.carrySpeed = State._prevCarry or 30
                State.speedToggled = State._prevSpeed or false
                if carryBox then carryBox.Text = tostring(State.carrySpeed) end
                if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
            end
        elseif def.key == "drop" then
            if ns then runDropBrainrot() else stopDropBrainrot() end
        end
    end
    makeStackDraggable(btnFrame, onTap)
end

-- ============================================================
-- FUNCIONES DE GAMEPLAY FALTANTES
-- ============================================================
doTpDown = function()
    pcall(function()
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local rp=RaycastParams.new(); rp.FilterDescendantsInstances={c}; rp.FilterType=Enum.RaycastFilterType.Exclude
        local res=workspace:Raycast(root.Position,Vector3.new(0,-1000,0),rp)
        if res then root.CFrame=CFrame.new(res.Position+Vector3.new(0,root.Size.Y/2+0.5,0)); root.AssemblyLinearVelocity=Vector3.zero end
    end)
end

local _dropConns={}
runDropBrainrot=function()
    if State.dropEnabled then return end; State.dropEnabled=true
    if stackBtnRefs.drop then stackBtnRefs.drop.setOn(true) end
    task.spawn(function()
        local colConn=RunService.Stepped:Connect(function()
            if not State.dropEnabled then return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end
                end
            end
        end)
        table.insert(_dropConns,colConn)
        task.spawn(function()
            while State.dropEnabled do
                RunService.Heartbeat:Wait()
                local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                local vel=root.Velocity
                root.Velocity=vel*10000+Vector3.new(0,10000,0)
                RunService.RenderStepped:Wait()
                if root and root.Parent then root.Velocity=vel end
                RunService.Stepped:Wait()
                if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
            end
        end)
        task.wait(DROP_AUTO_OFF_DELAY); stopDropBrainrot()
    end)
end
stopDropBrainrot=function()
    State.dropEnabled=false
    for _,cn in ipairs(_dropConns) do pcall(function() cn:Disconnect() end) end; _dropConns={}
    if stackBtnRefs.drop then stackBtnRefs.drop.setOn(false) end
end

local VYSE_AIMBOT_SPEED=56.5; local VYSE_HIT_DIST=5; local SWING_COOLDOWN=0.08

local function findAnyTool()
    local c=LP.Character
    if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
    return nil
end

local function getClosestPlayer()
    if not hrp then return nil,math.huge end
    local cp,cd=nil,math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            local tr=p.Character:FindFirstChild("HumanoidRootPart")
            local ph=p.Character:FindFirstChildOfClass("Humanoid")
            if tr and ph and ph.Health>0 then
                local d=(hrp.Position-tr.Position).Magnitude
                if d<cd then cd=d; cp=p end
            end
        end
    end
    return cp,cd
end

local function tryHitBat()
    if State.hittingCooldown then return end; State.hittingCooldown=true
    pcall(function()
        local c=LP.Character; if not c then return end
        local hum2=c:FindFirstChildOfClass("Humanoid")
        local tool=findAnyTool()
        if tool then
            if tool.Parent~=c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
            local remote=tool:FindFirstChildOfClass("RemoteEvent")
            if remote then pcall(function() remote:FireServer() end)
            else pcall(function() tool:Activate() end) end
        end
    end)
    task.delay(SWING_COOLDOWN,function() State.hittingCooldown=false end)
end

startBatAimbot=function()
    if Conns.aimbot then return end
    Conns.aimbot=RunService.Heartbeat:Connect(function()
        if not State.batAimbotToggled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum2=c:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local target,dist=getClosestPlayer()
        if target and target.Character then
            local tr=target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local fp=tr.Position+tr.CFrame.LookVector*1.5
                local dir=(fp-root.Position).Unit
                root.AssemblyLinearVelocity=Vector3.new(dir.X*VYSE_AIMBOT_SPEED,dir.Y*VYSE_AIMBOT_SPEED,dir.Z*VYSE_AIMBOT_SPEED)
                if dist<=VYSE_HIT_DIST and State.autoSwingEnabled then tryHitBat() end
            end
        else root.AssemblyLinearVelocity=Vector3.zero end
    end)
end
stopBatAimbot=function()
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot=nil end
    local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity=Vector3.zero end; State.hittingCooldown=false
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end

startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        local isRagdolled=st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
        if isRagdolled then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
stopBatCounter=function()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

local function findMedusaCounter()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end; State.medusaDebounce=true
    local med=findMedusaCounter(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
setupMedusaCounter=function(char)
    stopMedusaCounter(); if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
stopMedusaCounter=function() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

local function faceSouth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end end) end
local function faceNorth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end end) end

startAutoLeft=function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end; local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=State.normalSpeed
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(POS.L1.X,root.Position.Y,POS.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(POS.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(POS.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(POS.L2.X,root.Position.Y,POS.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end; faceSouth(); return end
            local d=(POS.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
stopAutoLeft=function()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
    if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end
end

startAutoRight=function()
    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end; local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=State.normalSpeed
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(POS.R1.X,root.Position.Y,POS.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(POS.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(POS.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(POS.R2.X,root.Position.Y,POS.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end; faceNorth(); return end
            local d=(POS.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
stopAutoRight=function()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
    if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end
end

local Conns_duelWatch = nil
local function startDuelCountdownWatcher(direction)
    if Conns_duelWatch then Conns_duelWatch:Disconnect(); Conns_duelWatch=nil end
    State._duelWaiting = true
    local function countdownVisible()
        local pg = LP:FindFirstChild("PlayerGui"); if not pg then return false end
        for _, obj in ipairs(pg:GetDescendants()) do
            if obj:IsA("TextLabel") then
                local t = obj.Text
                if t == "3" or t == "2" or t == "1" or t == "GO!" or t == "Go!" then
                    if obj.Visible then return true end
                end
            end
            if obj:IsA("ScreenGui") then
                local n = obj.Name:lower()
                if (n:find("duel") or n:find("countdown") or n:find("battle")) and obj.Enabled then
                    return true
                end
            end
        end
        return false
    end
    local sawCountdown = false
    Conns_duelWatch = RunService.Heartbeat:Connect(function()
        if not State.duelCountdownEnabled then
            Conns_duelWatch:Disconnect(); Conns_duelWatch=nil; State._duelWaiting=false; return
        end
        local visible = countdownVisible()
        if not sawCountdown and visible then
            sawCountdown = true
        end
        if sawCountdown and not visible then
            Conns_duelWatch:Disconnect(); Conns_duelWatch=nil; State._duelWaiting=false
            task.wait(0.05)
            if direction == "left" then
                State.autoLeftEnabled=true
                if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(true) end
                startAutoLeft()
            elseif direction == "right" then
                State.autoRightEnabled=true
                if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(true) end
                startAutoRight()
            end
            task.delay(2, function()
                if State.duelCountdownEnabled then
                    startDuelCountdownWatcher(direction)
                end
            end)
        end
    end)
end
local function stopDuelCountdownWatcher()
    if Conns_duelWatch then Conns_duelWatch:Disconnect(); Conns_duelWatch=nil end
    State._duelWaiting = false
end

startAntiRagdoll=function()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        local c=LP.Character; if not c then return end
        local hum2=c:FindFirstChildOfClass("Humanoid"); local root=c:FindFirstChild("HumanoidRootPart")
        if not hum2 or not root then return end; if hum2.Health<=0 then return end
        local st=hum2:GetState(); if st==Enum.HumanoidStateType.Dead then return end
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            pcall(function() hum2:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() workspace.CurrentCamera.CameraSubject=hum2 end)
            pcall(function() local PM=LP.PlayerScripts:FindFirstChild("PlayerModule"); if PM then local CM=require(PM:FindFirstChild("ControlModule")); if CM then CM:Enable() end end end)
            root.Velocity=Vector3.new(0,0,0); root.RotVelocity=Vector3.new(0,0,0)
        end
        for _,obj in ipairs(c:GetDescendants()) do pcall(function() if obj:IsA("Motor6D") and obj.Enabled==false then obj.Enabled=true end end) end
    end)
end
stopAntiRagdoll=function() if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag=nil end end

local unwalkAnimateRef=nil
local function startUnwalk()
    local c=LP.Character; if not c then return end
    local hum2=c:FindFirstChildOfClass("Humanoid")
    if hum2 then pcall(function() for _,track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end end) end
    local animCtrl=c:FindFirstChildOfClass("AnimationController")
    if animCtrl then pcall(function() for _,track in ipairs(animCtrl:GetPlayingAnimationTracks()) do track:Stop(0) end end) end
    local anim=c:FindFirstChild("Animate")
    if anim and anim:IsA("LocalScript") then anim.Disabled=true; unwalkAnimateRef=anim end
    if Conns.unwalk then Conns.unwalk:Disconnect() end
    Conns.unwalk=RunService.Heartbeat:Connect(function()
        if not State.unwalkEnabled then return end
        local c2=LP.Character; if not c2 then return end
        local hum3=c2:FindFirstChildOfClass("Humanoid")
        if hum3 then pcall(function() for _,track in ipairs(hum3:GetPlayingAnimationTracks()) do track:Stop(0) end end) end
    end)
end
local function stopUnwalk()
    if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk=nil end
    local c=LP.Character
    if c and unwalkAnimateRef and unwalkAnimateRef.Parent==c then unwalkAnimateRef.Disabled=false end
    unwalkAnimateRef=nil
end

applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function()
        if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
        elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
        elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("SpecialMesh") then v.TextureId=""
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
        elseif v:IsA("Attachment") then v.Visible=false end
    end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end

saveConfig = function()
    local cfg = {
        normalSpeed   = State.normalSpeed,
        carrySpeed    = State.carrySpeed,
        laggerSpeed   = State.laggerSpeed,
        stealRadius   = Steal.StealRadius,
        stealDuration = Steal.StealDuration,
        uiScale       = State.guiScale,
        buttonsScale  = State.buttonsScale,
        stackButtonsHidden = State.stackButtonsHidden,
        buttonShape   = State.buttonShape,
        medusaRange   = State.medusaRange,
        medusaCooldown= State.medusaCooldown,
        holdJump      = State.holdJumpEnabled,
        holdJumpPower = State.holdJumpPower,
        speedKey     = Keys.speed.Name,
        autoLeftKey  = Keys.autoLeft.Name,
        autoRightKey = Keys.autoRight.Name,
        guiHideKey   = Keys.guiHide.Name,
        dropKey      = Keys.drop.Name,
        laggerKey    = Keys.lagger.Name,
        tpDownKey    = Keys.tpDown.Name,
        aimbotKey    = Keys.aimbot.Name,
        medusaKey    = Keys.medusaToggle.Name,
        infJump          = State.infJumpEnabled,
        antiRagdoll      = State.antiRagdollEnabled,
        fpsBoost         = State.fpsBoostEnabled,
        medusaCounter    = State.medusaCounterEnabled,
        autoMedusa       = State.autoMedusaEnabled,
        batCounter       = State.batCounterEnabled,
        autoStealEnabled = Steal.AutoStealEnabled,
    }
    local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok then pcall(function() _writefile(CONFIG_FILE, encoded) end) end
end

loadConfig = function()
    local hasFile = false
    pcall(function() hasFile = _isfile(CONFIG_FILE) end)
    if not hasFile then pcall(function() hasFile = _isfile("GumballDuelsConfig.json") end) end
    if not hasFile then return end

    local raw
    local ok = pcall(function() raw = _readfile(CONFIG_FILE) end)
    if not ok or not raw then pcall(function() raw = _readfile("GumballDuelsConfig.json") end) end
    if not raw then return end

    local cfg; local ok2 = pcall(function() cfg = HttpService:JSONDecode(raw) end)
    if not ok2 or not cfg then return end

    if cfg.normalSpeed then State.normalSpeed = cfg.normalSpeed; if normalBox then normalBox.Text = tostring(cfg.normalSpeed) end end
    if cfg.carrySpeed  then State.carrySpeed  = cfg.carrySpeed;  if carryBox  then carryBox.Text  = tostring(cfg.carrySpeed)  end end
    if cfg.laggerSpeed then State.laggerSpeed = cfg.laggerSpeed; if laggerBox then laggerBox.Text = tostring(cfg.laggerSpeed) end end
    if cfg.holdJumpPower then setHoldJumpPower(cfg.holdJumpPower); if holdJumpPowerBox then holdJumpPowerBox.Text = tostring(cfg.holdJumpPower) end end
    if cfg.stealRadius   then Steal.StealRadius   = cfg.stealRadius   end
    if cfg.stealDuration then Steal.StealDuration = cfg.stealDuration end
    if cfg.medusaRange then State.medusaRange = cfg.medusaRange; if medusaRangeBox then medusaRangeBox.Text = tostring(cfg.medusaRange) end end
    if cfg.medusaCooldown then State.medusaCooldown = cfg.medusaCooldown; if medusaCooldownBox then medusaCooldownBox.Text = tostring(cfg.medusaCooldown) end end
    if cfg.holdJump ~= nil then setHoldJump(cfg.holdJump); updateHoldJumpStatus() end
    if cfg.uiScale then applyGuiScale(cfg.uiScale); if uiScaleBox then uiScaleBox.Text = tostring(cfg.uiScale) end end
    if cfg.buttonsScale then applyButtonsScale(cfg.buttonsScale); if btnsScaleBox then btnsScaleBox.Text = tostring(cfg.buttonsScale) end end
    if cfg.stackButtonsHidden then
        applyStackButtonsVisible(false)
        if setHideButtonsToggle then setHideButtonsToggle(true) end
    end
    if cfg.buttonShape then applyButtonShape(cfg.buttonShape) end
    if cfg.autoMedusa then setAutoMedusa(cfg.autoMedusa); updateMedusaStatus() end

    local function tryKey(field, keyTarget)
        if cfg[field] and Enum.KeyCode[cfg[field]] then
            local kc = Enum.KeyCode[cfg[field]]
            Keys[keyTarget] = kc
            if keybindBtnRefs[keyTarget] then
                keybindBtnRefs[keyTarget].Text = getKeyDisplayName(kc)
            end
        end
    end
    tryKey("speedKey",    "speed")
    tryKey("autoLeftKey", "autoLeft")
    tryKey("autoRightKey","autoRight")
    tryKey("guiHideKey",  "guiHide")
    tryKey("dropKey",     "drop")
    tryKey("laggerKey",   "lagger")
    tryKey("tpDownKey",   "tpDown")
    tryKey("aimbotKey",   "aimbot")
    tryKey("medusaKey",   "medusaToggle")

    if cfg.autoStealEnabled then Steal.AutoStealEnabled = true; if setInstaGrab then setInstaGrab(true) end; pcall(startAutoSteal) end
    if cfg.infJump then State.infJumpEnabled = true; if setInfJump then setInfJump(true) end end
    if cfg.antiRagdoll then State.antiRagdollEnabled = true; if setAntiRag then setAntiRag(true) end; startAntiRagdoll() end
    if cfg.fpsBoost then State.fpsBoostEnabled = true; if setFps then setFps(true) end; applyFPSBoost() end
    if cfg.medusaCounter then State.medusaCounterEnabled = true; if setMedusaCounter then setMedusaCounter(true) end; setupMedusaCounter(LP.Character) end
    if cfg.batCounter then State.batCounterEnabled = true; if setBatCounter then setBatCounter(true) end; startBatCounter() end
end

-- ============================================================
-- CHARACTER SETUP
-- ============================================================
local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5)
    hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end

    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("GumballDuelsBB"); if oldBB then oldBB:Destroy() end

        local bb=Instance.new("BillboardGui", head)
        bb.Name="GumballDuelsBB"
        bb.Size=UDim2.new(0, 160, 0, 50)
        bb.StudsOffset=Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop=true

        local mainFrame = Instance.new("Frame", bb)
        mainFrame.Size = UDim2.new(1, 0, 1, 0)
        mainFrame.BackgroundTransparency = 1

        local shadowText = Instance.new("TextLabel", mainFrame)
        shadowText.Size = UDim2.new(1, 0, 0, 18)
        shadowText.Position = UDim2.new(0, 0, 0, 2)
        shadowText.BackgroundTransparency = 1
        shadowText.Text = "GUMBALL DUELS"
        shadowText.TextColor3 = C.topTitle
        shadowText.Font = Enum.Font.GothamBlack
        shadowText.TextScaled = true
        shadowText.TextStrokeTransparency = 0.2
        shadowText.TextStrokeColor3 = Color3.fromRGB(20, 80, 20)

        local speedBillLbl=Instance.new("TextLabel", mainFrame)
        speedBillLbl.Name="SpeedBillLbl"
        speedBillLbl.Size=UDim2.new(1, 0, 0, 20)
        speedBillLbl.Position=UDim2.new(0, 0, 0, 22)
        speedBillLbl.BackgroundTransparency=1
        speedBillLbl.Text="0.0"
        speedBillLbl.TextColor3=Color3.fromRGB(180, 240, 180)
        speedBillLbl.Font=Enum.Font.GothamBlack
        speedBillLbl.TextScaled=true
        speedBillLbl.TextStrokeTransparency=0.1
        speedBillLbl.TextStrokeColor3=Color3.new(0, 0, 0)

        local lbl2=Instance.new("TextLabel", mainFrame)
        lbl2.Size=UDim2.new(1, 0, 0, 12)
        lbl2.Position=UDim2.new(0, 0, 1, -12)
        lbl2.BackgroundTransparency=1
        lbl2.Text="gumball.duels"
        lbl2.TextColor3=Color3.fromRGB(120, 200, 120)
        lbl2.Font=Enum.Font.Gotham
        lbl2.TextScaled=true
    end

    if Conns.unwalk then Conns.unwalk:Disconnect(); Conns.unwalk=nil end; unwalkAnimateRef=nil
    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
    if State.medusaCounterEnabled then setupMedusaCounter(char) end
    if State.batAimbotToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    if State.autoMedusaEnabled then
        stopAutoMedusa()
        startAutoMedusa()
    end
    if State.holdJumpEnabled then
        stopHoldJump()
        startHoldJump()
    end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- ============================================================
-- RUNTIME LOOPS
-- ============================================================
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

RunService.RenderStepped:Connect(function()
    if not (h and hrp) then return end
    if State._tpInProgress then return end

    updateSpeed()

    pcall(function()
        local head2 = LP.Character and LP.Character:FindFirstChild("Head")
        if head2 then
            local bb2 = head2:FindFirstChild("GumballDuelsBB")
            local sl = bb2 and bb2:FindFirstChild("SpeedBillLbl")
            if sl then
                local hspd = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
                sl.Text = string.format("%.1f", hspd)
            end
        end
    end)
end)

-- ============================================================
-- INPUT
-- ============================================================
UIS.InputBegan:Connect(function(inp,gp)
    if gp then return end
    local isKb=inp.UserInputType==Enum.UserInputType.Keyboard
    local isGp=inp.UserInputType==Enum.UserInputType.Gamepad1 or inp.UserInputType==Enum.UserInputType.Gamepad2 or inp.UserInputType==Enum.UserInputType.Gamepad3 or inp.UserInputType==Enum.UserInputType.Gamepad4
    if not isKb and not isGp then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end

    if kc==Keys.speed then
        State.speedToggled=not State.speedToggled
        if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
    elseif kc==Keys.autoLeft then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(State.autoLeftEnabled) end
        if State.autoLeftEnabled and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    elseif kc==Keys.autoRight then
        State.autoRightEnabled=not State.autoRightEnabled
        if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(State.autoRightEnabled) end
        if State.autoRightEnabled and State.batAimbotToggled then State.batAimbotToggled=false; stopBatAimbot(); if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(false) end end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
    elseif kc==Keys.drop then
        if not State.dropEnabled then runDropBrainrot() end
    elseif kc==Keys.lagger then
        State.laggerEnabled = not State.laggerEnabled
        if stackBtnRefs.lagger then stackBtnRefs.lagger.setOn(State.laggerEnabled) end
        if State.laggerEnabled then
            State._prevCarry = State.carrySpeed
            State._prevSpeed = State.speedToggled
            State.speedToggled = false
            if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(false) end
            if carryBox then carryBox.Text = tostring(State.laggerSpeed) end
        else
            State.carrySpeed = State._prevCarry or 30
            State.speedToggled = State._prevSpeed or false
            if carryBox then carryBox.Text = tostring(State.carrySpeed) end
            if stackBtnRefs.carrySpeed then stackBtnRefs.carrySpeed.setOn(State.speedToggled) end
        end
    elseif kc==Keys.tpDown then
        doTpDown()
    elseif kc==Keys.aimbot then
        State.batAimbotToggled=not State.batAimbotToggled
        if State.batAimbotToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if stackBtnRefs.autoLeft then stackBtnRefs.autoLeft.setOn(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if stackBtnRefs.autoRight then stackBtnRefs.autoRight.setOn(false) end end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if stackBtnRefs.aimbot then stackBtnRefs.aimbot.setOn(State.batAimbotToggled) end
    elseif kc==Keys.medusaToggle then
        setAutoMedusa(not State.autoMedusaEnabled)
        updateMedusaStatus()
    elseif kc==Keys.guiHide then
        if isKb then State.guiVisible=not State.guiVisible; mainOuter.Visible=State.guiVisible end
    end
end)

-- ============================================================
-- INIT
-- ============================================================
loadPresetsFile()
rebuildPresetList()
loadConfig()
createHoldJumpFloatingButton()

task.spawn(function()
    task.wait(0.3)
    local lastPresetName = loadLastPresetName()
    if lastPresetName and lastPresetName ~= "" then
        for _, preset in ipairs(Presets) do
            if preset.name == lastPresetName then
                applyPreset(preset.data)
                print("[GumballDuels v6.0] Auto-loaded last preset: " .. lastPresetName)
                break
            end
        end
    end
end)

task.delay(1, function() pcall(saveConfig) end)

print("[GumballDuels v6.0] Loaded - VERSIÓN FINAL - Todo Funcional")
print("[Hold Jump] Mejorado - Botón flotante creado - Potencia ajustable (45-150)")