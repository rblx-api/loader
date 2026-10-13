-- leaked by awake v3
--==================================================================
-- HEARTLESS Speed Bypass (standalone extraction)
--==================================================================

--============================================================
-- 1. ENVIRONMENT SHIMS
--============================================================
local Players       = game:GetService("Players")
local UIS           = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local RunService    = game:GetService("RunService")
local HttpService   = game:GetService("HttpService")
local NetworkClient = game:GetService("NetworkClient")

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

local isMobile = false
do
    local ok, platform = pcall(function() return UIS:GetPlatform() end)
    if ok then
        isMobile = UIS.TouchEnabled and (platform == Enum.Platform.Android
            or platform == Enum.Platform.IOS or not UIS.MouseEnabled)
    end
end

-- State container used for tracking connections / stoppers
_G.__HEARTLESS_STATE = _G.__HEARTLESS_STATE or {conns = {}, stoppers = {}, alive = true}
function _G.__HeartlessTrackConn(conn)
    if conn then table.insert(_G.__HEARTLESS_STATE.conns, conn) end
    return conn
end
function _G.__HeartlessTrackStopper(fn)
    if fn then table.insert(_G.__HEARTLESS_STATE.stoppers, fn) end
end

--========================
-- Key-name formatter
--========================
local KEY_ALIASES = {MB3 = "Mouse3", ["MouseButton3"] = "Mouse3"}
local function formatKey(input)
    if not input then return "-" end
    if type(input) == "string" then return KEY_ALIASES[input] or input end
    return tostring(input):match("KeyCode%.(.+)") or tostring(input)
end

--========================
-- Tap helper (simplified)
--========================
local function onTap(gui, callback)
    gui.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        callback()
    end)
end

--========================
-- Theme shims (used by Bypass UI)
--========================
_G.__HeartlessThemeRoots = _G.__HeartlessThemeRoots or {}
function _G.__HeartlessRegisterThemeRoot(root)
    if not root then return end
    for _, r in ipairs(_G.__HeartlessThemeRoots) do
        if r == root then return end
    end
    table.insert(_G.__HeartlessThemeRoots, root)
end

function _G.__HeartlessRoundPanelBackground(child, parent)
    local mask = Instance.new("CanvasGroup")
    mask.Name = "RoundedBackgroundMask"
    mask.Size = UDim2.fromScale(1, 1)
    mask.Position = UDim2.fromOffset(0, 0)
    mask.BackgroundTransparency = 1
    mask.BorderSizePixel = 0
    mask.GroupTransparency = 0
    mask.ZIndex = child.ZIndex
    mask.Parent = parent
    local corner = parent:FindFirstChildOfClass("UICorner")
    Instance.new("UICorner", mask).CornerRadius =
        corner and corner.CornerRadius or UDim.new(0, 16)
    if corner then corner:Destroy() end
    child.Parent = mask
end

function _G.__HeartlessFramePanelBackground(img, index, kind)
    img.ScaleType = Enum.ScaleType.Crop
    if kind == "Bypass" then
        img.Size = UDim2.new(1, 0, 1.02, 0)
        img.Position = UDim2.fromScale(0, -0.02)
    else
        img.Size = UDim2.fromScale(1, 1)
        img.Position = UDim2.fromScale(0, 0)
    end
end

function _G.__HeartlessAddOriginalGui3Title(lbl, text)
    if lbl then lbl.Text = string.upper(tostring(text or "HEARTLESS")) end
end

function _G.__HeartlessAddUnifiedPanelShade(parent, radius, zindex)
    if not parent then return end
    local existing = parent:FindFirstChild("UnifiedBackgroundShade")
    if existing then existing:Destroy() end
    local shade = Instance.new("Frame")
    shade.Name = "UnifiedBackgroundShade"
    shade.Size = UDim2.fromScale(1, 1)
    shade.Position = UDim2.fromScale(0, 0)
    shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shade.BackgroundTransparency = 0.68
    shade.BorderSizePixel = 0
    shade.Active = false
    shade.ZIndex = zindex or 1
    shade.Parent = parent
    Instance.new("UICorner", shade).CornerRadius = UDim.new(0, radius or 16)
    local grad = Instance.new("UIGradient", shade)
    grad.Rotation = 90
    grad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.28),
        NumberSequenceKeypoint.new(0.55, 0.42),
        NumberSequenceKeypoint.new(1, 0.56),
    })
    return shade
end

function _G.__HeartlessReadSavedPanelVisibility(path)
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then
        return false, false
    end
    local ok, data = pcall(function()
        if not isfile(path) then return nil end
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok or type(data) ~= "table" then return false, false end
    return true, data.visible == true
end

--============================================================
-- 2. ASSET (bypass background images)
--============================================================
local BYPASS_BACKGROUND_URL = "https://files.catbox.moe/clcelu.jpg"
local function resolveCustomAsset(url)
    local write = typeof(writefile) == "function"
    local exists = typeof(isfile) == "function"
    local getAsset
    pcall(function()
        getAsset = (typeof(getcustomasset) == "function" and getcustomasset)
            or (typeof(getsynasset) == "function" and getsynasset)
    end)
    if not write or not exists then return url end

    local fileName = "HEARTLESSBypass_clcelu.jpg"
    local ok = false
    pcall(function() ok = isfile(fileName) end)
    if not ok then
        local fetched, body = pcall(function() return game:HttpGet(url) end)
        if not fetched or type(body) ~= "string" or #body < 16 then
            warn("HEARTLESS Bypass: could not download background")
            return "rbxassetid://94763047376005"
        end
        if not pcall(writefile, fileName, body) then return url end
    end
    if getAsset then
        local ok2, path = pcall(getAsset, fileName)
        if ok2 and type(path) == "string" and path ~= "" then return path end
    end
    return url
end
local BYPASS_BG = resolveCustomAsset(BYPASS_BACKGROUND_URL)

--============================================================
-- 3. BYPASS CORE (UI + logic)
--============================================================
-- Configuration / state kept in upvalues so the API can read/modify it
local BypassCfg = {
    Power        = 97000,
    PCPower      = 97000,
    MobilePower  = 72000,
    Mode         = "PC",
    SpamDelay    = 0.12,
    Version      = "V1",
    DropPaused   = false,
    Enabled      = false,
}
local BypassKey = {inputType = Enum.UserInputType.Keyboard, keyCode = Enum.KeyCode.Five}
local BypassAuto       = false
local BypassIsStealing = false
local BypassManualOverride = false
local BypassBackgroundIndex = 1
local BypassBackgrounds = {BYPASS_BG}

local BypassText    = Color3.fromRGB(160, 225, 255)
local BypassSub     = Color3.fromRGB(20, 70, 130)

_G.HEARTLESSBypass = nil
_G._HeartlessBypassGUILoaded = false

-- Forward declarations
local buildBypassPanel

--========================
-- Payload builders
--========================
local function buildV1Payload(power)
    local payload, head = {}, {{}}
    local cursor = head[1]
    for _ = 1, 186 do
        local nxt = {}
        table.insert(cursor, nxt)
        cursor = nxt
    end
    for _ = 1, math.floor(power / 188) do
        table.insert(payload, head)
    end
    return payload
end

local function buildV2Payload(power)
    local payload, head = {}, {{}}
    local cursor = head[1]
    for _ = 1, 296 do
        local nxt = {}
        table.insert(cursor, nxt)
        cursor = nxt
    end
    for _ = 1, math.floor(power / 298) do
        table.insert(payload, head)
    end
    return payload
end

local function buildPayload(power)
    return BypassCfg.Version == "V1" and buildV1Payload(power)
        or buildV2Payload(power)
end

--========================
-- Start / stop the bypass spam loop
--========================
local BypassRunning = false
local BypassPayload = nil
local BypassThread  = nil

local function startBypass()
    if BypassRunning then return true end
    BypassRunning = true
    pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)

    BypassPayload = buildPayload(BypassCfg.Power)
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    local remote = rrs and rrs:FindFirstChild("SetPlayerBlockList")
    if not remote then
        BypassRunning = false
        return
    end

    BypassThread = task.spawn(function()
        while BypassRunning do
            if BypassPayload then
                pcall(function() remote:FireServer(BypassPayload) end)
            end
            task.wait(BypassCfg.SpamDelay)
        end
    end)
    return true
end

local function stopBypass(silent)
    BypassRunning = false
    if BypassThread then
        pcall(function() task.cancel(BypassThread) end)
        BypassThread = nil
    end
    BypassPayload = nil
    if not silent then
        pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
    end
end

local function setPower(power)
    local maxP = BypassCfg.Mode == "PC" and 150000 or 100000
    BypassCfg.Power = math.clamp(power, 10000, maxP)
    if BypassCfg.Mode == "PC" then
        BypassCfg.PCPower = BypassCfg.Power
    else
        BypassCfg.MobilePower = BypassCfg.Power
    end
    if BypassRunning then
        stopBypass()
        task.wait(0.05)
        startBypass()
    end
end

local function setVersion(version)
    if version ~= "V1" and version ~= "V2" then return end
    BypassCfg.Version = version
    BypassCfg.Power = version == "V1" and 97000 or 100000
    if BypassCfg.Mode == "PC" then
        BypassCfg.PCPower = BypassCfg.Power
    else
        BypassCfg.MobilePower = BypassCfg.Power
    end
    if BypassRunning then
        stopBypass()
        task.wait(0.05)
        startBypass()
    end
end

--========================
-- Settings I/O
--========================
local function canPersist()
    return typeof(writefile) == "function"
        and typeof(readfile) == "function"
        and typeof(isfile) == "function"
end

local MainFrameRef -- set inside buildBypassPanel

local function saveSettings()
    if not canPersist() or not MainFrameRef then return end
    local payload = {
        power        = tostring(BypassCfg.Power),
        pcPower      = BypassCfg.PCPower,
        mobilePower  = BypassCfg.MobilePower,
        mode         = BypassCfg.Mode,
        autoOnSteal  = BypassAuto,
        keybind      = BypassKey and {
            inputType = BypassKey.inputType.Name,
            keyCode   = BypassKey.keyCode.Name,
        } or nil,
        background   = BypassBackgroundIndex,
        visible      = MainFrameRef.Visible,
        minimized    = MainFrameRef:GetAttribute("Minimized") == true,
        position     = {
            xScale  = MainFrameRef.Position.X.Scale,
            xOffset = MainFrameRef.Position.X.Offset,
            yScale  = MainFrameRef.Position.Y.Scale,
            yOffset = MainFrameRef.Position.Y.Offset,
        },
        bypassEnabled  = BypassRunning,
        manualOverride = BypassManualOverride,
        bypassVersion  = BypassCfg.Version,
    }
    pcall(function()
        writefile("HEARTLESSBypass_Settings.json", HttpService:JSONEncode(payload))
    end)
end

local function loadSettings()
    if not canPersist() then return nil end
    local ok, data = pcall(function()
        if isfile("HEARTLESSBypass_Settings.json") then
            return HttpService:JSONDecode(readfile("HEARTLESSBypass_Settings.json"))
        end
        return nil
    end)
    return ok and data or nil
end

--========================
-- Build the bypass panel
--========================
buildBypassPanel = function(showImmediately)
    if showImmediately == nil then showImmediately = true end
    if showImmediately and _G.HeartlessLagger and _G.HeartlessLagger.SetVisible then
        pcall(_G.HeartlessLagger.SetVisible, false)
    end
    if _G._HeartlessBypassGUILoaded then
        -- Already loaded: just toggle visibility
        if _G.HEARTLESSBypass and _G.HEARTLESSBypass.SetVisible then
            pcall(_G.HEARTLESSBypass.SetVisible, true)
        end
        return
    end

    _G._HeartlessBypassGUILoaded = true
    task.spawn(function()
        pcall(function()
            if not _G.__HEARTLESS_STATE.alive then return end
            if not _G.__HEARTLESS_STATE.alive then return end

            local gui = Instance.new("ScreenGui")
            gui.Name           = "HEARTLESSBypassGUI"
            gui.ResetOnSpawn   = false
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent         = PlayerGui
            _G.__HeartlessRegisterThemeRoot(gui)

            --=================== MAIN FRAME ===================
            local main = Instance.new("Frame")
            main.Name                 = "MainFrame"
            main.Size                 = UDim2.new(0, 320, 0, 160)
            main.Position             = UDim2.new(0.5, -160, 0.5, -80)
            main.BackgroundColor3     = Color3.fromRGB(9, 24, 52)
            main.BackgroundTransparency = 0
            main.BorderSizePixel      = 0
            main.ClipsDescendants     = true
            main.Active               = true
            main.Draggable            = false
            main.Parent               = gui
            main.Visible              = false
            MainFrameRef = main

            local aspect = Instance.new("UIAspectRatioConstraint")
            aspect.AspectRatio = 2
            aspect.Parent = main

            if isMobile then
                local scale = Instance.new("UIScale")
                scale.Name  = "MobilePanelScale"
                scale.Scale = 0.82
                scale.Parent = main
            end

            Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

            local mainStroke = Instance.new("UIStroke", main)
            mainStroke.Color            = Color3.fromRGB(181, 181, 181)
            mainStroke.Thickness        = 1.5
            mainStroke.Transparency     = 1
            mainStroke.ApplyStrokeMode  = Enum.ApplyStrokeMode.Border

            local bg = Instance.new("ImageLabel")
            bg.Name                 = "BgImageLabel"
            bg.Size                 = UDim2.new(1, 0, 1, 0)
            bg.BackgroundTransparency = 1
            bg.Image                = BypassBackgrounds[1]
            bg.ImageTransparency    = 0
            bg.ScaleType            = Enum.ScaleType.Crop
            bg.ZIndex               = 0
            bg.Parent               = main
            bg.Visible              = true
            Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 16)
            _G.__HeartlessRoundPanelBackground(bg, main)
            _G.__HeartlessAddUnifiedPanelShade(main, 16, 1)

            local glow  = Instance.new("UIStroke", main)
            glow.Name             = "Glow"
            glow.Color            = Color3.fromRGB(191, 191, 191)
            glow.Thickness        = 4
            glow.Transparency     = 1
            glow.ApplyStrokeMode  = Enum.ApplyStrokeMode.Border

            local glow2 = Instance.new("UIStroke", main)
            glow2.Name            = "Glow2"
            glow2.Color           = Color3.fromRGB(255, 255, 255)
            glow2.Thickness       = 6
            glow2.Transparency    = 1
            glow2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, 0, 1, 0)
            container.BackgroundTransparency = 1
            container.ZIndex = 3
            container.Parent = main

            --=================== MINIMIZE BUTTON ===================
            local minimize = Instance.new("TextButton")
            minimize.Name = "Minimize"
            minimize.Size = UDim2.fromOffset(28, 28)
            minimize.Position = UDim2.new(1, -36, 0, 8)
            minimize.BackgroundColor3 = Color3.fromRGB(12, 34, 70)
            minimize.BackgroundTransparency = 0.08
            minimize.BorderSizePixel = 0
            minimize.AutoButtonColor = false
            minimize.Text = "-"
            minimize.TextColor3 = BypassText
            minimize.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            minimize.TextStrokeTransparency = 0.15
            minimize.TextSize = 18
            minimize.Font = Enum.Font.GothamBlack
            minimize.ZIndex = 12
            minimize.Parent = main
            Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 7)
            local minimizeStroke = Instance.new("UIStroke", minimize)
            minimizeStroke.Color = Color3.fromRGB(0, 0, 0)
            minimizeStroke.Thickness = 1

            local miniToggle = Instance.new("TextButton")
            miniToggle.Name = "MinimizedToggle"
            miniToggle.Size = UDim2.new(1, -54, 0, 30)
            miniToggle.Position = UDim2.fromOffset(8, 7)
            miniToggle.BackgroundColor3 = Color3.fromRGB(18, 48, 92)
            miniToggle.BackgroundTransparency = 0.08
            miniToggle.BorderSizePixel = 0
            miniToggle.AutoButtonColor = false
            miniToggle.Text = "ACTIVATE BYPASS"
            miniToggle.TextColor3 = BypassText
            miniToggle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            miniToggle.TextStrokeTransparency = 0.15
            miniToggle.TextSize = 11
            miniToggle.Font = Enum.Font.GothamBold
            miniToggle.Visible = false
            miniToggle.ZIndex = 12
            miniToggle.Parent = main
            Instance.new("UICorner", miniToggle).CornerRadius = UDim.new(0, 7)
            local miniToggleStroke = Instance.new("UIStroke", miniToggle)
            miniToggleStroke.Color = Color3.fromRGB(0, 0, 0)
            miniToggleStroke.Thickness = 1

            local SIZE_FULL     = UDim2.fromOffset(320, 160)
            local SIZE_MINIMIZED = UDim2.fromOffset(310, 44)

            local function syncMinimizeText()
                miniToggle.Text = BypassRunning and "DEACTIVATE BYPASS" or "ACTIVATE BYPASS"
                miniToggle.BackgroundColor3 = BypassRunning
                    and Color3.fromRGB(45, 140, 220)
                    or Color3.fromRGB(18, 48, 92)
                miniToggle.TextColor3 = BypassText
            end

            local function setMinimized(flag, animate)
                flag = flag == true
                main:SetAttribute("Minimized", flag)
                minimize.Text = flag and "+" or "-"
                container.Visible = not flag
                miniToggle.Visible = flag
                if flag and themesPanel then themesPanel.Visible = false end
                aspect.Parent = flag and nil or main
                local target = flag and SIZE_MINIMIZED or SIZE_FULL
                if animate then
                    TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = target}):Play()
                else
                    main.Size = target
                end
            end
            minimize.Activated:Connect(function() setMinimized(not (main:GetAttribute("Minimized") == true), true); saveSettings() end)

            --=================== TITLE (Gui3 style) ===================
            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(0, 110, 0, 20)
            title.Position = UDim2.new(0, 16, 0, 7)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBlack
            title.Text = ""
            title.TextColor3 = BypassText
            title.TextSize = 16
            title.TextXAlignment = Enum.TextXAlignment.Left
            title.ZIndex = 3
            title.Parent = container
            local titleStroke = Instance.new("UIStroke", title)
            titleStroke.Color = Color3.fromRGB(0, 0, 0)
            titleStroke.Thickness = 1.5
            titleStroke.Transparency = 0.2
            local titleGrad = Instance.new("UIGradient", title)
            titleGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 220, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255)),
            })
            titleGrad.Enabled = false

            local bypassLabel = Instance.new("TextLabel")
            bypassLabel.Name = "BypassLabel"
            bypassLabel.Position = UDim2.new(0, 16, 0, 27)
            bypassLabel.Size = UDim2.new(0, 110, 0, 18)
            bypassLabel.BackgroundTransparency = 1
            bypassLabel.Text = ""
            bypassLabel.TextColor3 = BypassText
            bypassLabel.TextSize = 13
            bypassLabel.Font = Enum.Font.GothamBold
            bypassLabel.TextXAlignment = Enum.TextXAlignment.Left
            bypassLabel.ZIndex = 3
            bypassLabel.Parent = container

            title.AnchorPoint = Vector2.new(0.5, 0)
            title.Position = UDim2.new(0.5, 0, 0, 38)
            title.Size = UDim2.fromOffset(224, 20)
            _G.__HeartlessAddOriginalGui3Title(title, "HEARTLESS Bypass")
            title.Visible = true
            title.TextSize = 15

            local creditLabel = Instance.new("TextLabel")
            creditLabel.Name = "CreditLabel"
            creditLabel.AnchorPoint = Vector2.new(0.5, 0)
            creditLabel.Position = UDim2.new(0.5, 0, 0, 58)
            creditLabel.Size = UDim2.fromOffset(224, 14)
            creditLabel.BackgroundTransparency = 1
            creditLabel.Font = Enum.Font.Gotham
            creditLabel.Text = "leaked by awake v3"
            creditLabel.TextColor3 = BypassText
            creditLabel.TextTransparency = 0.35
            creditLabel.TextSize = 10
            creditLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            creditLabel.TextStrokeTransparency = 0.5
            creditLabel.TextXAlignment = Enum.TextXAlignment.Center
            creditLabel.ZIndex = 3
            creditLabel.Parent = container

            local titleShadow = Instance.new("TextLabel")
            titleShadow.Name = "TitleShadow"
            titleShadow.Size = UDim2.new(1, 0, 0, 50)
            titleShadow.Position = UDim2.new(0, -7, 0, 1)
            titleShadow.BackgroundTransparency = 1
            titleShadow.Font = Enum.Font.GothamBlack
            titleShadow.Text = ""
            titleShadow.TextColor3 = Color3.fromRGB(20, 50, 100)
            titleShadow.TextSize = 18
            titleShadow.TextXAlignment = Enum.TextXAlignment.Center
            titleShadow.ZIndex = 2
            titleShadow.Parent = container
            titleShadow.Visible = false

            --=================== THEMES BUTTON ===================
            local themesButton = Instance.new("TextButton")
            themesButton.AnchorPoint = Vector2.new(0.5, 0)
            themesButton.Size = UDim2.new(0, 90, 0, 20)
            themesButton.Position = UDim2.new(0.5, 0, 0, 38)
            themesButton.BackgroundColor3 = BypassText
            themesButton.BackgroundTransparency = 0.55
            themesButton.AutoButtonColor = false
            themesButton.Font = Enum.Font.GothamBold
            themesButton.Text = "Themes"
            themesButton.TextWrapped = false
            themesButton.TextXAlignment = Enum.TextXAlignment.Center
            themesButton.TextColor3 = BypassSub
            themesButton.TextSize = 10
            themesButton.Parent = container
            themesButton.Visible = false
            Instance.new("UICorner", themesButton).CornerRadius = UDim.new(0, 6)
            local themesButtonStroke = Instance.new("UIStroke", themesButton)
            themesButtonStroke.Color = Color3.fromRGB(0, 0, 0)
            themesButtonStroke.Thickness = 1
            themesButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            --=================== THEMES PANEL ===================
            local themesPanel = Instance.new("Frame")
            themesPanel.Name = "ThemesPanel"
            themesPanel.Size = UDim2.fromOffset(220, 180)
            themesPanel.BackgroundColor3 = Color3.fromRGB(45, 140, 220)
            themesPanel.BorderSizePixel = 0
            themesPanel.Visible = false
            themesPanel.ZIndex = 20
            themesPanel.Parent = gui
            local themesGrad = Instance.new("UIGradient", themesPanel)
            themesGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 58, 58)),
                ColorSequenceKeypoint.new(0.48, Color3.fromRGB(92, 92, 92)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(52, 52, 52)),
            })
            themesGrad.Rotation = 35
            local function positionThemes()
                themesPanel.Position = UDim2.new(
                    main.Position.X.Scale,
                    main.Position.X.Offset + main.Size.X.Offset + 12,
                    main.Position.Y.Scale,
                    main.Position.Y.Offset
                )
            end
            Instance.new("UICorner", themesPanel).CornerRadius = UDim.new(0, 12)
            local themesPanelStroke = Instance.new("UIStroke", themesPanel)
            themesPanelStroke.Color = mainStroke.Color
            themesPanelStroke.Thickness = mainStroke.Thickness

            local themeCards = {}
            local selectedTheme = BypassBackgroundIndex

            local function refreshThemes()
                for idx, card in ipairs(themeCards) do
                    local active = idx == selectedTheme
                    card.stroke.Color = BypassText
                    card.stroke.Thickness = active and 2 or 1.5
                    card.stroke.Transparency = active and 0.25 or 0.7
                    card.stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    local x, y, w, h = card.baseX, card.baseY, card.baseW, card.baseH
                    card.card.Size = active
                        and UDim2.fromOffset(math.max(4, w - 6), math.max(4, h - 6))
                        or UDim2.fromOffset(w, h)
                    card.card.Position = active
                        and UDim2.new(0, x + 3, 0, y + 3)
                        or UDim2.new(0, x, 0, y)
                    card.image.Size = UDim2.new(1, 0, 1, 0)
                    card.image.Position = UDim2.new(0, 0, 0, 0)
                end
            end

            for i, asset in ipairs(BypassBackgrounds) do
                local card = Instance.new("TextButton", themesPanel)
                local col = (i - 1) % 2
                local row = math.floor((i - 1) / 2)
                local x, y = 12 + col * 98, 12 + row * 62
                card.Size = UDim2.fromOffset(88, 56)
                card.Position = UDim2.new(0, x, 0, y)
                card.BackgroundColor3 = BypassText
                card.BorderSizePixel = 0
                card.Text = ""
                card.AutoButtonColor = false
                card.ZIndex = 21
                Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
                local image = Instance.new("ImageLabel", card)
                image.Size = UDim2.new(1, 0, 1, 0)
                image.BackgroundTransparency = 1
                image.Image = asset
                image.ScaleType = Enum.ScaleType.Crop
                image.ZIndex = 21
                Instance.new("UICorner", image).CornerRadius = UDim.new(0, 7)
                local lbl = Instance.new("TextLabel", card)
                lbl.Size = UDim2.new(1, -6, 0, 14)
                lbl.Position = UDim2.new(0, 3, 1, -16)
                lbl.BackgroundTransparency = 1
                lbl.Text = "GUI " .. tostring(i)
                lbl.TextColor3 = BypassText
                lbl.TextSize = 8
                lbl.Font = Enum.Font.GothamBold
                lbl.ZIndex = 23
                lbl.TextStrokeColor3 = Color3.fromRGB(5, 12, 25)
                lbl.TextStrokeTransparency = 0.25
                local stroke = Instance.new("UIStroke", card)
                stroke.Color = Color3.fromRGB(0, 0, 0)
                stroke.Thickness = 1
                stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                table.insert(themeCards, {card = card, stroke = stroke, image = image, baseX = x, baseY = y, baseW = 88, baseH = 56})
                card.Activated:Connect(function() selectedTheme = i; refreshThemes() end)
            end

            local saveTheme = Instance.new("TextButton", themesPanel)
            saveTheme.Size = UDim2.new(1, -24, 0, 28)
            saveTheme.Position = UDim2.new(0, 12, 1, -44)
            saveTheme.BackgroundColor3 = Color3.fromRGB(18, 48, 92)
            saveTheme.BorderSizePixel = 0
            saveTheme.Text = "Save Theme"
            saveTheme.TextColor3 = BypassText
            saveTheme.TextSize = 11
            saveTheme.Font = Enum.Font.GothamBold
            saveTheme.ZIndex = 21
            Instance.new("UICorner", saveTheme).CornerRadius = UDim.new(0, 7)
            saveTheme.Activated:Connect(function()
                BypassBackgroundIndex = selectedTheme
                bg.Image = BypassBackgrounds[BypassBackgroundIndex]
                _G.__HeartlessFramePanelBackground(bg, BypassBackgroundIndex, "Bypass")
                mainStroke.Transparency = BypassBackgroundIndex == 1 and 1 or 0.448
                glow.Transparency       = BypassBackgroundIndex == 1 and 1 or 0.782
                glow2.Transparency      = BypassBackgroundIndex == 1 and 1 or 0.891
                themesPanel.Visible = false
                saveSettings()
            end)
            themesButton.Activated:Connect(function()
                selectedTheme = BypassBackgroundIndex
                positionThemes()
                themesPanel.Visible = not themesPanel.Visible
                refreshThemes()
            end)

            --=================== VERSION BUTTON ===================
            local versionBtn = Instance.new("TextButton", container)
            versionBtn.AnchorPoint = Vector2.new(0, 0)
            versionBtn.Size = UDim2.new(0, 44, 0, 22)
            versionBtn.Position = UDim2.new(0, 16, 0, 13)
            versionBtn.BackgroundColor3 = Color3.fromRGB(7, 22, 48)
            versionBtn.BackgroundTransparency = 0
            versionBtn.AutoButtonColor = false
            versionBtn.Font = Enum.Font.GothamBold
            versionBtn.Text = "V1"
            versionBtn.TextColor3 = BypassSub
            versionBtn.TextSize = 10
            Instance.new("UICorner", versionBtn).CornerRadius = UDim.new(0, 6)
            local vGrad = Instance.new("UIGradient", versionBtn)
            vGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 22, 48)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 215, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 22, 48)),
            })
            local vStroke = Instance.new("UIStroke", versionBtn)
            vStroke.Color = Color3.fromRGB(160, 225, 255)
            vStroke.Thickness = 1
            vStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local function refreshVersionBtn()
                versionBtn.Text = BypassCfg.Version
                versionBtn.TextColor3 = BypassText
                vStroke.Color = Color3.fromRGB(160, 225, 255)
            end
            versionBtn.Activated:Connect(function()
                setVersion(BypassCfg.Version == "V1" and "V2" or "V1")
                refreshVersionBtn()
                saveSettings()
            end)

            --=================== PC / MOBILE TOGGLE ===================
            local pcFrame = Instance.new("Frame", container)
            pcFrame.Name = "PCToggleFrame"
            pcFrame.AnchorPoint = Vector2.new(0.5, 0)
            pcFrame.Position = UDim2.new(0.5, 0, 0, 13)
            pcFrame.Size = UDim2.new(0, 100, 0, 22)
            pcFrame.BackgroundColor3 = Color3.fromRGB(12, 34, 70)
            pcFrame.BackgroundTransparency = 0.4
            Instance.new("UICorner", pcFrame).CornerRadius = UDim.new(0, 6)
            local pcStroke = Instance.new("UIStroke", pcFrame)
            pcStroke.Color = Color3.fromRGB(38, 94, 145)
            pcStroke.Transparency = 0.3

            local pcBtn = Instance.new("TextButton", pcFrame)
            pcBtn.Position = UDim2.new(0, 2, 0, 2)
            pcBtn.Size = UDim2.new(0.5, -2, 1, -4)
            pcBtn.BackgroundTransparency = 0.4
            pcBtn.Text = "PC"
            pcBtn.TextSize = 9
            pcBtn.Font = Enum.Font.GothamBold
            pcBtn.AutoButtonColor = false
            Instance.new("UICorner", pcBtn).CornerRadius = UDim.new(0, 5)

            local mobBtn = Instance.new("TextButton", pcFrame)
            mobBtn.Position = UDim2.new(0.5, 2, 0, 2)
            mobBtn.Size = UDim2.new(0.5, -2, 1, -4)
            mobBtn.BackgroundTransparency = 0.4
            mobBtn.Text = "Mobile"
            mobBtn.TextSize = 9
            mobBtn.Font = Enum.Font.GothamBold
            mobBtn.AutoButtonColor = false
            Instance.new("UICorner", mobBtn).CornerRadius = UDim.new(0, 5)

            --=================== POWER ROW ===================
            local powerRow = Instance.new("Frame", container)
            powerRow.Name = "PowerRow"
            powerRow.Position = UDim2.new(0, 22, 0, 74)
            powerRow.Size = UDim2.new(1, -44, 0, 40)
            powerRow.BackgroundColor3 = Color3.fromRGB(12, 34, 70)
            powerRow.BackgroundTransparency = 0.4
            Instance.new("UICorner", powerRow).CornerRadius = UDim.new(0, 10)
            local powerStroke = Instance.new("UIStroke", powerRow)
            powerStroke.Color = Color3.fromRGB(38, 94, 145)
            powerStroke.Transparency = 0.3

            local powerLabel = Instance.new("TextLabel", powerRow)
            powerLabel.Size = UDim2.new(0, 38, 1, 0)
            powerLabel.Position = UDim2.new(0, 8, 0, 0)
            powerLabel.BackgroundTransparency = 1
            powerLabel.Text = "POWER"
            powerLabel.TextColor3 = BypassText
            powerLabel.TextSize = 8
            powerLabel.Font = Enum.Font.GothamBold
            powerLabel.TextXAlignment = Enum.TextXAlignment.Left

            local powerBox = Instance.new("TextBox", powerRow)
            powerBox.Size = UDim2.new(0, 60, 0, 24)
            powerBox.Position = UDim2.new(0, 46, 0, 8)
            powerBox.BackgroundColor3 = Color3.fromRGB(9, 24, 52)
            powerBox.BackgroundTransparency = 0.4
            powerBox.Font = Enum.Font.GothamBold
            powerBox.Text = "97000"
            powerBox.PlaceholderText = "97000"
            powerBox.TextColor3 = BypassText
            powerBox.TextSize = 10
            powerBox.ClearTextOnFocus = false
            powerBox.ZIndex = 4
            Instance.new("UICorner", powerBox).CornerRadius = UDim.new(0, 6)
            local powerBoxStroke = Instance.new("UIStroke", powerBox)
            powerBoxStroke.Color = Color3.fromRGB(0, 0, 0)
            powerBoxStroke.Thickness = 1.2
            powerBoxStroke.Transparency = 0.2

            powerBox:GetPropertyChangedSignal("Text"):Connect(function()
                local filtered = powerBox.Text:gsub("%D", "")
                if filtered ~= powerBox.Text then powerBox.Text = filtered end
            end)
            powerBox.FocusLost:Connect(function()
                local val = tonumber(powerBox.Text)
                if val then
                    local maxP = BypassCfg.Mode == "PC" and 150000 or 100000
                    local clamped = math.clamp(val, 10000, maxP)
                    powerBox.Text = tostring(clamped)
                    setPower(clamped)
                else
                    powerBox.Text = tostring(BypassCfg.Power)
                end
                saveSettings()
            end)

            --=================== KEYBIND BUTTON ===================
            local keybindBtn = Instance.new("TextButton", powerRow)
            keybindBtn.Size = UDim2.new(0, 30, 0, 24)
            keybindBtn.Position = UDim2.new(1, -34, 0, 8)
            keybindBtn.BackgroundColor3 = Color3.fromRGB(9, 24, 52)
            keybindBtn.BackgroundTransparency = 0.4
            keybindBtn.AutoButtonColor = false
            keybindBtn.Font = Enum.Font.GothamBold
            keybindBtn.Text = "5"
            keybindBtn.TextColor3 = BypassText
            keybindBtn.TextSize = 10
            keybindBtn.ZIndex = 4
            Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 6)
            local keybindStroke = Instance.new("UIStroke", keybindBtn)
            keybindStroke.Color = Color3.fromRGB(0, 0, 0)
            keybindStroke.Thickness = 1.2
            keybindStroke.Transparency = 0.2

            --=================== ACTIVATE BUTTON ===================
            local activateBtn = Instance.new("TextButton", powerRow)
            activateBtn.AnchorPoint = Vector2.new(0, 0)
            activateBtn.Size = UDim2.new(1, -150, 0, 32)
            activateBtn.Position = UDim2.new(0, 112, 0, 4)
            activateBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            activateBtn.BackgroundTransparency = 0.1
            activateBtn.AutoButtonColor = false
            activateBtn.Font = Enum.Font.GothamBold
            activateBtn.Text = "ACTIVATE BYPASS"
            activateBtn.TextColor3 = BypassText
            activateBtn.TextSize = 9
            Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 8)
            local activateStroke = Instance.new("UIStroke", activateBtn)
            activateStroke.Color = Color3.fromRGB(0, 0, 0)
            activateStroke.Thickness = 1.2
            activateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local activateGrad = Instance.new("UIGradient", activateBtn)
            activateGrad.Color = ColorSequence.new(Color3.fromRGB(36, 108, 174), Color3.fromRGB(18, 48, 92))
            activateGrad.Rotation = 90
            activateGrad.Enabled = false
            local activateScale = Instance.new("UIScale", activateBtn)
            activateScale.Scale = 1

            --=================== AUTO ON STEAL ===================
            local autoRow = Instance.new("Frame", container)
            autoRow.Size = UDim2.new(1, -44, 0, 24)
            autoRow.Position = UDim2.new(0, 22, 0, 118)
            autoRow.BackgroundColor3 = Color3.fromRGB(12, 34, 70)
            autoRow.BackgroundTransparency = 0.4
            Instance.new("UICorner", autoRow).CornerRadius = UDim.new(0, 8)
            local autoRowStroke = Instance.new("UIStroke", autoRow)
            autoRowStroke.Color = Color3.fromRGB(38, 94, 145)
            autoRowStroke.Transparency = 0.3

            local autoToggle = Instance.new("TextButton", autoRow)
            autoToggle.Size = UDim2.new(0, 28, 0, 14)
            autoToggle.Position = UDim2.new(1, -38, 0.5, -7)
            autoToggle.BackgroundColor3 = Color3.fromRGB(12, 34, 70)
            autoToggle.BackgroundTransparency = 0.4
            autoToggle.AutoButtonColor = false
            autoToggle.Text = ""
            Instance.new("UICorner", autoToggle).CornerRadius = UDim.new(1, 0)
            local autoStroke = Instance.new("UIStroke", autoToggle)
            autoStroke.Color = Color3.fromRGB(0, 0, 0)
            autoStroke.Thickness = 1.2
            local autoKnob = Instance.new("Frame", autoToggle)
            autoKnob.Size = UDim2.new(0, 10, 0, 10)
            autoKnob.Position = UDim2.new(0, 2, 0.5, -5)
            autoKnob.BackgroundColor3 = Color3.fromRGB(85, 190, 245)
            autoKnob.BorderSizePixel = 0
            Instance.new("UICorner", autoKnob).CornerRadius = UDim.new(1, 0)

            local autoLabel = Instance.new("TextLabel", autoRow)
            autoLabel.Size = UDim2.new(0.5, 0, 1, 0)
            autoLabel.Position = UDim2.new(0, 10, 0, 0)
            autoLabel.BackgroundTransparency = 1
            autoLabel.Font = Enum.Font.GothamBold
            autoLabel.Text = "Auto On Steal"
            autoLabel.TextColor3 = BypassSub
            autoLabel.TextSize = 9
            autoLabel.TextXAlignment = Enum.TextXAlignment.Left
            autoLabel.TextYAlignment = Enum.TextYAlignment.Center

            --=================== PC/MOBILE refresh ===================
            local function refreshMode()
                local isPC = BypassCfg.Mode == "PC"
                pcBtn.BackgroundColor3  = isPC and Color3.fromRGB(45, 140, 220) or Color3.fromRGB(5, 16, 38)
                pcBtn.TextColor3        = isPC and BypassText or Color3.fromRGB(115, 190, 230)
                mobBtn.BackgroundColor3 = isPC and Color3.fromRGB(5, 16, 38) or Color3.fromRGB(45, 140, 220)
                mobBtn.TextColor3       = isPC and Color3.fromRGB(115, 190, 230) or BypassText
                keybindBtn.Visible      = isPC
                powerBox.Size           = UDim2.new(0, 60, 0, 24)
            end

            local function switchMode(mode)
                if mode ~= "PC" and mode ~= "Mobile" then return end
                if BypassCfg.Mode == mode then return end
                local wasRunning = BypassRunning
                if wasRunning then stopBypass() end
                BypassCfg.Mode = mode
                BypassCfg.Power = mode == "PC" and BypassCfg.PCPower or BypassCfg.MobilePower
                powerBox.Text = tostring(BypassCfg.Power)
                refreshMode()
                if wasRunning then startBypass() end
                saveSettings()
            end
            pcBtn.Activated:Connect(function() switchMode("PC") end)
            mobBtn.Activated:Connect(function() switchMode("Mobile") end)
            refreshMode()

            --=================== auto-steal toggle visual ===================
            local function refreshAuto()
                local on = BypassAuto
                autoToggle.BackgroundColor3 = on and Color3.fromRGB(45, 140, 220) or Color3.fromRGB(12, 34, 70)
                autoKnob.Position = on and UDim2.new(0, 16, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
                autoKnob.BackgroundColor3 = on and Color3.fromRGB(45, 45, 45) or Color3.fromRGB(85, 190, 245)
                autoStroke.Color = on and Color3.fromRGB(160, 225, 255) or Color3.fromRGB(38, 94, 145)
                autoStroke.Thickness = on and 1.6 or 1.2
            end

            local function refreshBypassEnabledVisual(animate)
                if BypassRunning then
                    activateBtn.Text = "DEACTIVATE BYPASS"
                    activateBtn.TextColor3 = BypassText
                    activateGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(225, 225, 225)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(195, 195, 195)),
                    })
                    if animate then
                        TweenService:Create(activateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 140, 220)}):Play()
                        TweenService:Create(activateStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(160, 225, 255), Thickness = 1.8, Transparency = 0}):Play()
                    else
                        activateBtn.BackgroundColor3 = Color3.fromRGB(45, 140, 220)
                        activateStroke.Color = Color3.fromRGB(160, 225, 255)
                        activateStroke.Thickness = 1.8
                    end
                else
                    activateBtn.Text = "ACTIVATE BYPASS"
                    activateBtn.TextColor3 = BypassText
                    activateGrad.Color = ColorSequence.new(Color3.fromRGB(36, 108, 174), Color3.fromRGB(18, 48, 92))
                    if animate then
                        TweenService:Create(activateBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12, 34, 70)}):Play()
                        TweenService:Create(activateStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 0, 0), Thickness = 1.2, Transparency = 0}):Play()
                    else
                        activateBtn.BackgroundColor3 = Color3.fromRGB(12, 34, 70)
                        activateStroke.Color = Color3.fromRGB(0, 0, 0)
                        activateStroke.Thickness = 1.2
                    end
                end
                activateScale.Scale = 0.94
                TweenService:Create(activateScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                syncMinimizeText()
                saveSettings()
            end

            --========================
            -- Toggle from API / clicks
            --========================
            local function applyBypassState(wantEnabled, animate)
                wantEnabled = wantEnabled == true
                if BypassRunning == wantEnabled then
                    syncMinimizeText()
                    return
                end
                if wantEnabled then
                    if not startBypass() then return end
                else
                    stopBypass()
                end
                refreshBypassEnabledVisual(animate)
            end

            local function toggleBypass(animate)
                BypassManualOverride = true
                applyBypassState(not BypassRunning, animate)
                saveSettings()
            end

            activateBtn.Activated:Connect(function() toggleBypass(true) end)
            miniToggle.Activated:Connect(function() toggleBypass(true) end)
            activateBtn.MouseEnter:Connect(function()
                if not BypassRunning then
                    TweenService:Create(activateBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
                end
            end)
            activateBtn.MouseLeave:Connect(function()
                if not BypassRunning then
                    TweenService:Create(activateBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(12, 34, 70)}):Play()
                end
            end)

            --========================
            -- Keybind capture
            --========================
            local listening = false
            local function setKeyLabel(text)
                listening = text
                keybindBtn.Text = text and "..." or formatKey(BypassKey.keyCode)
            end
            keybindBtn.Activated:Connect(function() setKeyLabel(true) end)

            local GAMEPADS = {
                [Enum.UserInputType.Gamepad1] = true, [Enum.UserInputType.Gamepad2] = true,
                [Enum.UserInputType.Gamepad3] = true, [Enum.UserInputType.Gamepad4] = true,
            }
            local function isBindable(input)
                return input.UserInputType == Enum.UserInputType.Keyboard
                    or input.UserInputType == Enum.UserInputType.MouseButton3
                    or GAMEPADS[input.UserInputType] == true
            end
            local function prettyInput(input)
                if input.UserInputType == Enum.UserInputType.MouseButton3 then return "Mouse3" end
                return ({Zero = "0", One = "1", Two = "2", Three = "3", Four = "4",
                         Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9"})[input.KeyCode.Name]
                    or input.KeyCode.Name
            end

            _G.__HeartlessTrackConn(UIS.InputBegan:Connect(function(input, gameProcessed)
                if listening then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        setKeyLabel(false)
                        return
                    end
                    if isBindable(input) then
                        BypassKey = {inputType = input.UserInputType, keyCode = input.KeyCode}
                        keybindBtn.Text = prettyInput(input)
                        setKeyLabel(false)
                        saveSettings()
                    end
                    return
                end
                if gameProcessed then return end
                if BypassKey and input.UserInputType == BypassKey.inputType
                    and input.KeyCode == BypassKey.keyCode then
                    toggleBypass(true)
                end
            end))

            --========================
            -- Auto on steal
            --========================
            local function isStealing()
                return LocalPlayer:GetAttribute("Stealing") == true
            end
            local function syncAutoSteal(animate)
                local stealingNow = isStealing()
                BypassIsStealing = stealingNow
                if BypassAuto and not BypassManualOverride and stealingNow ~= BypassRunning then
                    applyBypassState(stealingNow, animate)
                end
            end
            _G.__HeartlessTrackConn(LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
                if LocalPlayer:GetAttribute("Stealing") == true then
                    BypassManualOverride = false
                end
                syncAutoSteal(true)
            end))
            task.spawn(function()
                while gui.Parent do
                    syncAutoSteal(false)
                    task.wait(1)
                end
            end)

            autoToggle.Activated:Connect(function()
                BypassAuto = not BypassAuto
                _G._HeartlessHub_BypassAuto = BypassAuto
                refreshAuto()
                if BypassAuto then
                    BypassManualOverride = false
                    syncAutoSteal(true)
                end
                saveSettings()
            end)

            --========================
            -- Drag to move
            --========================
            local dragging, dragStart, startPos, dragInput
            local function isOnHeader(pos)
                local absp, size = main.AbsolutePosition, main.AbsoluteSize
                return pos.X >= absp.X and pos.X <= absp.X + size.X
                    and pos.Y >= absp.Y and pos.Y <= absp.Y + 48
            end
            _G.__HeartlessTrackConn(UIS.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and input.UserInputType ~= Enum.UserInputType.Touch then return end
                if not main.Visible or not isOnHeader(input.Position) then return end
                dragging = true
                dragStart = input.Position
                startPos = main.AbsolutePosition
                dragInput = input
            end))
            _G.__HeartlessTrackConn(UIS.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType ~= Enum.UserInputType.MouseMovement
                    and input.UserInputType ~= Enum.UserInputType.Touch then return end
                local delta = input.Position - dragStart
                main.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
            end))
            _G.__HeartlessTrackConn(UIS.InputEnded:Connect(function(input)
                local matches = dragInput
                    and dragInput.UserInputType == Enum.UserInputType.MouseButton1
                    and input.UserInputType == Enum.UserInputType.MouseButton1
                if not dragging or (input ~= dragInput and not matches) then return end
                dragging, dragInput = false, nil
                saveSettings()
            end))

            --========================
            -- Ensure black text on dark bg for styling consistency
            --========================
            for _, inst in ipairs(gui:GetDescendants()) do
                if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                    inst:SetAttribute("HeartlessKeepBlackText", true)
                    inst.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    inst.TextStrokeTransparency = 0.2
                end
            end

            --========================
            -- Restore saved settings
            --========================
            local saved = loadSettings()
            if saved then
                if saved.visible ~= nil then main.Visible = saved.visible end
                if saved.bypassVersion then BypassCfg.Version = saved.bypassVersion; refreshVersionBtn() end
                BypassCfg.Mode = saved.mode == "Mobile" and "Mobile" or "PC"
                local p = tonumber(saved.power)
                BypassCfg.PCPower = math.clamp(tonumber(saved.pcPower)
                    or (BypassCfg.Mode == "PC" and p) or 97000, 10000, 150000)
                BypassCfg.MobilePower = math.clamp(tonumber(saved.mobilePower)
                    or (BypassCfg.Mode == "Mobile" and p) or 72000, 10000, 150000)
                BypassCfg.Power = BypassCfg.Mode == "PC" and BypassCfg.PCPower or BypassCfg.MobilePower
                powerBox.Text = tostring(BypassCfg.Power)
                refreshMode()
                if saved.autoOnSteal ~= nil then
                    BypassAuto = saved.autoOnSteal == true
                    _G._HeartlessHub_BypassAuto = BypassAuto
                    refreshAuto()
                end
                if saved.keybind and saved.keybind.inputType and saved.keybind.keyCode then
                    pcall(function()
                        local it = Enum.UserInputType[saved.keybind.inputType]
                        local kc = Enum.KeyCode[saved.keybind.keyCode]
                        if it and kc then
                            BypassKey = {inputType = it, keyCode = kc}
                            keybindBtn.Text = prettyInput({UserInputType = it, KeyCode = kc})
                        end
                    end)
                end
                if saved.background then
                    BypassBackgroundIndex = math.clamp(saved.background, 1, #BypassBackgrounds)
                    bg.Image = BypassBackgrounds[BypassBackgroundIndex]
                    _G.__HeartlessFramePanelBackground(bg, BypassBackgroundIndex, "Bypass")
                    mainStroke.Transparency = BypassBackgroundIndex == 1 and 1 or 0.448
                    glow.Transparency       = BypassBackgroundIndex == 1 and 1 or 0.782
                    glow2.Transparency      = BypassBackgroundIndex == 1 and 1 or 0.891
                end
                if saved.position then
                    pcall(function()
                        main.Position = UDim2.new(
                            saved.position.xScale, saved.position.xOffset,
                            saved.position.yScale, saved.position.yOffset)
                    end)
                end
                setMinimized(saved.minimized == true, false)
                if saved.manualOverride ~= nil then BypassManualOverride = saved.manualOverride end
                if BypassAuto then syncAutoSteal(false) end
            else
                BypassCfg.Version = "V1"
                BypassCfg.Mode = "PC"
                BypassCfg.PCPower = 97000
                BypassCfg.MobilePower = 72000
                BypassCfg.Power = 97000
                powerBox.Text = "97000"
                versionBtn.Text = "V1"
                refreshVersionBtn()
                refreshMode()
                saveSettings()
            end

            BypassBackgroundIndex = 1
            bg.Image = BypassBackgrounds[BypassBackgroundIndex]
            _G.__HeartlessFramePanelBackground(bg, BypassBackgroundIndex, "Bypass")
            mainStroke.Transparency = BypassBackgroundIndex == 1 and 1 or 0.448
            glow.Transparency       = BypassBackgroundIndex == 1 and 1 or 0.782
            glow2.Transparency      = BypassBackgroundIndex == 1 and 1 or 0.891

            saveSettings()

            local posDebounce = 0
            main:GetPropertyChangedSignal("Position"):Connect(function()
                if themesPanel.Visible then positionThemes() end
                posDebounce += 1
                local ticket = posDebounce
                task.delay(0.4, function()
                    if ticket == posDebounce then saveSettings() end
                end)
            end)

            --========================
            -- API
            --========================
            _G.HEARTLESSBypass = {
                ResetPosition = function()
                    dragging, dragInput = false, nil
                    main.Position = UDim2.new(0.5, -160, 0.5, -80)
                    saveSettings()
                end,
                GetPower     = function() return BypassCfg.Power end,
                GetKeybind   = function() return BypassKey end,
                IsEnabled    = function() return BypassRunning end,
                IsAutoOnSteal = function() return BypassAuto end,
                IsStealing   = function() return BypassIsStealing end,
                PauseForDrop = function()
                    if BypassCfg.DropPaused then return true end
                    BypassCfg.DropPaused = BypassRunning == true
                    if BypassCfg.DropPaused then stopBypass(true) end
                    return BypassCfg.DropPaused
                end,
                ResumeAfterDrop = function()
                    if not BypassCfg.DropPaused then return false end
                    BypassCfg.DropPaused = false
                    return startBypass()
                end,
                GetBackground = function() return BypassBackgroundIndex end,
                GetVersion    = function() return BypassCfg.Version end,
                GetMode       = function() return BypassCfg.Mode end,
                GetPosition   = function() return {x = main.Position.X.Offset, y = main.Position.Y.Offset} end,
                SetBackground = function(idx)
                    BypassBackgroundIndex = math.clamp(idx, 1, #BypassBackgrounds)
                    bg.Image = BypassBackgrounds[BypassBackgroundIndex]
                    _G.__HeartlessFramePanelBackground(bg, BypassBackgroundIndex, "Bypass")
                    mainStroke.Transparency = BypassBackgroundIndex == 1 and 1 or 0.448
                    glow.Transparency       = BypassBackgroundIndex == 1 and 1 or 0.782
                    glow2.Transparency      = BypassBackgroundIndex == 1 and 1 or 0.891
                    saveSettings()
                end,
                SetBypass = function(state)
                    BypassManualOverride = true
                    applyBypassState(state, true)
                    saveSettings()
                end,
                SetPower = function(power)
                    local maxP = BypassCfg.Mode == "PC" and 150000 or 100000
                    local clamped = math.clamp(power, 10000, maxP)
                    powerBox.Text = tostring(clamped)
                    setPower(clamped)
                    saveSettings()
                end,
                SetMode = function(mode) switchMode(mode) end,
                SetAutoOnSteal = function(state)
                    BypassAuto = state == true
                    _G._HeartlessHub_BypassAuto = BypassAuto
                    refreshAuto()
                    if BypassAuto then
                        BypassManualOverride = false
                        syncAutoSteal(true)
                    end
                    saveSettings()
                end,
                SetVisible = function(vis)
                    if not main then return end
                    main.Visible = vis and true or false
                    if not main.Visible and themesPanel then themesPanel.Visible = false end
                    saveSettings()
                end,
                SetVersion = function(version)
                    if version ~= "V1" and version ~= "V2" then return end
                    setVersion(version)
                    refreshVersionBtn()
                    saveSettings()
                end,
                SetPosition = function(x, y)
                    pcall(function()
                        main.Position = UDim2.new(main.Position.X.Scale, x, main.Position.Y.Scale, y)
                        saveSettings()
                    end)
                end,
                Stop = function() stopBypass() end,
            }

            if not _G.__HEARTLESS_STATE.alive then
                stopBypass()
                pcall(function() gui:Destroy() end)
                return
            end

            _G.__HeartlessTrackStopper(function()
                stopBypass()
                pcall(function()
                    if gui and gui.Parent then gui:Destroy() end
                end)
                _G.HEARTLESSBypass = nil
                _G._HeartlessBypassGUILoaded = false
            end)

            if showImmediately and main and not main.Visible then
                main.Visible = true
                saveSettings()
            end
        end)
    end)
end

_G.__openHeartlessBypassGUI = buildBypassPanel

--============================================================
-- 4. AUTO-LAUNCH
--============================================================
-- Replace this block if you want to control opening yourself.
pcall(function()
    if _G._HeartlessBypassGUILoaded then
        if _G.HEARTLESSBypass and _G.HEARTLESSBypass.SetVisible then
            _G.HEARTLESSBypass.SetVisible(true)
        end
    else
        buildBypassPanel(true)
    end
end)