-- [NEW WORLD] +1 Pickaxe Swing Escape - gamer owns yall (v8 PREMIUM)
-- Place ID: 82554996468034
-- Cool Background + Premium GUI

local Players         = game:GetService("Players")
local player          = Players.LocalPlayer
local playerGui       = player:WaitForChild("PlayerGui")
local RunService      = game:GetService("RunService")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local UserInputService= game:GetService("UserInputService")

-- ==================== THEME ====================
local GOLD       = Color3.fromRGB(212, 175, 55)
local GOLD_DARK  = Color3.fromRGB(160, 130, 35)
local GOLD_LIGHT = Color3.fromRGB(255, 215, 90)
local GOLD_NEON  = Color3.fromRGB(255, 235, 120)
local BLACK      = Color3.fromRGB(10, 10, 12)
local BLACK_2    = Color3.fromRGB(18, 18, 20)
local BLACK_3    = Color3.fromRGB(28, 28, 32)
local BLACK_4    = Color3.fromRGB(38, 38, 42)
local RED        = Color3.fromRGB(255, 70, 70)
local WHITE      = Color3.fromRGB(245, 245, 245)
local DISCORD    = "discord.gg/4TueRJmzDh"
local LOGO_ID    = "rbxassetid://138472956105442"

-- Clean old GUI
pcall(function() playerGui:FindFirstChild("GamerOwnsYall"):Destroy() end)

-- ==================== GUI ROOT ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamerOwnsYall"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ==================== SHADOW ====================
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(0, 340, 0, 520)
shadow.Position = UDim2.new(0.5, -170, 0.5, -250)
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.Parent = screenGui
local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 18)
shadowCorner.Parent = shadow

-- ==================== MAIN FRAME ====================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 330, 0, 500)
mainFrame.Position = UDim2.new(0.5, -165, 0.5, -250)
mainFrame.BackgroundColor3 = BLACK
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = GOLD
mainStroke.Thickness = 2
mainStroke.Transparency = 0.1
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local strokeGrad = Instance.new("UIGradient")
strokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_NEON),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
strokeGrad.Rotation = 0
strokeGrad.Parent = mainStroke

-- ==================== COOL BACKGROUND ====================
-- Layer 0: FULL BACKGROUND IMAGE (fills the whole frame)
local bgImage = Instance.new("ImageLabel")
bgImage.Name = "BgImage"
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.Position = UDim2.new(0, 0, 0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = LOGO_ID
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.15      -- lower = more visible. try 0.0–0.4
bgImage.ZIndex = 0
bgImage.Parent = mainFrame

-- Layer 1: dark gradient tint on top of the image
local bgBase = Instance.new("Frame")
bgBase.Size = UDim2.new(1,0,1,0)
bgBase.BackgroundColor3 = BLACK
bgBase.BorderSizePixel = 0
bgBase.ZIndex = 1
bgBase.Parent = mainFrame
Instance.new("UICorner", bgBase).CornerRadius = UDim.new(0,18)

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 20, 12)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(12,12,14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,10)),
})
bgGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.35),   -- top: image more visible
    NumberSequenceKeypoint.new(1, 0.65),   -- bottom: darker for content
})
bgGrad.Rotation = 125
bgGrad.Parent = bgBase

-- Layer 2: aurora blobs
local aurora1 = Instance.new("Frame")
aurora1.Size = UDim2.new(0, 200, 0, 200)
aurora1.Position = UDim2.new(0, -40, 0, -40)
aurora1.BackgroundColor3 = GOLD
aurora1.BackgroundTransparency = 0.85
aurora1.BorderSizePixel = 0
aurora1.ZIndex = 2
aurora1.Parent = mainFrame
Instance.new("UICorner", aurora1).CornerRadius = UDim.new(1,0)
local blur1 = Instance.new("UIStroke")
blur1.Thickness = 40
blur1.Color = GOLD
blur1.Transparency = 0.8
blur1.Parent = aurora1

local aurora2 = Instance.new("Frame")
aurora2.Size = UDim2.new(0, 250, 0, 250)
aurora2.Position = UDim2.new(1, -150, 1, -150)
aurora2.BackgroundColor3 = GOLD_DARK
aurora2.BackgroundTransparency = 0.88
aurora2.BorderSizePixel = 0
aurora2.ZIndex = 2
aurora2.Parent = mainFrame
Instance.new("UICorner", aurora2).CornerRadius = UDim.new(1,0)

-- Layer 3: vignette
local vignette = Instance.new("Frame")
vignette.Size = UDim2.new(1,0,1,0)
vignette.BackgroundColor3 = Color3.new(0,0,0)
vignette.BackgroundTransparency = 0
vignette.BorderSizePixel = 0
vignette.ZIndex = 3
vignette.Parent = mainFrame
Instance.new("UICorner", vignette).CornerRadius = UDim.new(0,18)
local vigGrad = Instance.new("UIGradient")
vigGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.7),
    NumberSequenceKeypoint.new(1, 0),
})
vigGrad.Rotation = 90
vigGrad.Parent = vignette

-- Floating particles
local particleHolder = Instance.new("Frame")
particleHolder.Size = UDim2.new(1,0,1,0)
particleHolder.BackgroundTransparency = 1
particleHolder.ZIndex = 4
particleHolder.ClipsDescendants = true
particleHolder.Parent = mainFrame

for i=1,12 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
    p.Position = UDim2.new(math.random(),0, math.random(),0)
    p.BackgroundColor3 = (i%2==0) and GOLD_LIGHT or GOLD
    p.BackgroundTransparency = math.random(30,70)/100
    p.BorderSizePixel = 0
    p.ZIndex = 4
    p.Parent = particleHolder
    local pc = Instance.new("UICorner")
    pc.CornerRadius = UDim.new(1,0)
    pc.Parent = p

    task.spawn(function()
        while p.Parent do
            local newY = math.clamp(p.Position.Y.Scale - math.random(5,15)/100, -0.1, 1.1)
            local tween = TweenService:Create(p, TweenInfo.new(math.random(4,10), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(math.random(),0, newY,0)
            })
            tween:Play()
            tween.Completed:Wait()
            if newY <= 0 then
                p.Position = UDim2.new(math.random(),0,1.1,0)
            end
        end
    end)
end

-- Animate background gradients (with self-disconnect guard)
task.spawn(function()
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not mainFrame.Parent then
            conn:Disconnect()
            return
        end
        t += dt
        strokeGrad.Rotation = (t*20) % 360
        aurora1.Position = UDim2.new(0, -40 + math.sin(t*0.5)*20, 0, -40 + math.cos(t*0.4)*20)
        aurora2.Position = UDim2.new(1, -180 + math.sin(t*0.3)*25, 1, -180 + math.cos(t*0.6)*25)
        bgGrad.Rotation = 125 + math.sin(t*0.2)*15
    end)
end)

-- ==================== HEADER ====================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 62)
header.BackgroundColor3 = BLACK_3
header.BorderSizePixel = 0
header.ZIndex = 10
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 18)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0.5, 0)
headerFix.Position = UDim2.new(0, 0, 0.5, 0)
headerFix.BackgroundColor3 = BLACK_3
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 10
headerFix.Parent = header

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 45, 15)),
    ColorSequenceKeypoint.new(1, BLACK_3),
})
headerGradient.Rotation = 0
headerGradient.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = GOLD
headerStroke.Thickness = 1
headerStroke.Transparency = 0.7
headerStroke.Parent = header

-- Top neon line
local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1,0,0,2)
neonLine.Position = UDim2.new(0,0,0,0)
neonLine.BackgroundColor3 = GOLD
neonLine.BorderSizePixel = 0
neonLine.ZIndex = 11
neonLine.Parent = header
local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_NEON),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
neonGrad.Parent = neonLine

-- Header logo
local headerLogo = Instance.new("ImageLabel")
headerLogo.Size = UDim2.new(0, 36, 0, 36)
headerLogo.Position = UDim2.new(0, 10, 0, 13)
headerLogo.BackgroundTransparency = 1
headerLogo.Image = LOGO_ID
headerLogo.ScaleType = Enum.ScaleType.Fit
headerLogo.ZIndex = 11
headerLogo.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -174, 0, 28)
title.Position = UDim2.new(0, 54, 0, 8)
title.BackgroundTransparency = 1
title.Text = "⚡ GAMER OWNS YALL"
title.TextColor3 = WHITE
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = header

local titleGlow = Instance.new("UIStroke")
titleGlow.Color = GOLD
titleGlow.Thickness = 0.8
titleGlow.Transparency = 0.6
titleGlow.Parent = title

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -174, 0, 14)
subtitle.Position = UDim2.new(0, 54, 0, 36)
subtitle.BackgroundTransparency = 1
subtitle.Text = "✦ PREMIUM v8 • " .. DISCORD
subtitle.TextColor3 = GOLD_LIGHT
subtitle.TextScaled = true
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 11
subtitle.Parent = header

-- ==================== HEADER BUTTONS ====================
local function makeHeaderBtn(pos, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.Position = pos
    btn.BackgroundColor3 = BLACK_4
    btn.Text = text
    btn.TextColor3 = WHITE
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 12
    btn.Parent = header
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    local s = Instance.new("UIStroke")
    s.Color = color or GOLD_DARK
    s.Thickness = 1
    s.Transparency = 0.5
    s.Parent = btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color or GOLD}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = BLACK_4}):Play()
    end)
    return btn
end

local minimizeBtn = makeHeaderBtn(UDim2.new(1, -80, 0, 6), "−", GOLD_DARK)
local closeBtn    = makeHeaderBtn(UDim2.new(1, -30, 0, 6), "✕", RED)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.wait(0.25)
    screenGui.Enabled = false
    mainFrame.Size = UDim2.new(0, 330, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -165, 0.5, -250)
end)

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0, 68, 0, 22)
discordBtn.Position = UDim2.new(1, -104, 0, 32)
discordBtn.BackgroundColor3 = BLACK_4
discordBtn.Text = "📋 COPY DISCORD"
discordBtn.TextColor3 = GOLD_LIGHT
discordBtn.TextScaled = true
discordBtn.Font = Enum.Font.GothamBold
discordBtn.ZIndex = 12
discordBtn.Parent = header
local dbCorner = Instance.new("UICorner")
dbCorner.CornerRadius = UDim.new(0, 8)
dbCorner.Parent = discordBtn
local dbStroke = Instance.new("UIStroke")
dbStroke.Color = GOLD
dbStroke.Thickness = 1
dbStroke.Transparency = 0.6
dbStroke.Parent = discordBtn

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD) end
    discordBtn.Text = "✔ COPIED"
    TweenService:Create(discordBtn, TweenInfo.new(0.15), {BackgroundColor3 = GOLD}):Play()
    task.wait(1.2)
    discordBtn.Text = "📋 COPY DISCORD"
    TweenService:Create(discordBtn, TweenInfo.new(0.15), {BackgroundColor3 = BLACK_4}):Play()
end)

-- ==================== HEADER DRAG ====================
do
    local dragging, dragStart, startPos = false, nil, nil

    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = mainFrame.Position
        end
    end

    header.InputBegan:Connect(beginDrag)
    headerFix.InputBegan:Connect(beginDrag)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            shadow.Position = UDim2.new(
                mainFrame.Position.X.Scale, mainFrame.Position.X.Offset - 5,
                mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ==================== CONTENT CONTAINER ====================
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -62)
content.Position = UDim2.new(0, 0, 0, 62)
content.BackgroundTransparency = 1
content.ZIndex = 5
content.Parent = mainFrame

-- ==================== MINIMIZE LOGIC ====================
local isMinimized = false
local FULL_SIZE = UDim2.new(0, 330, 0, 500)
local MINI_SIZE = UDim2.new(0, 330, 0, 62)
local FULL_POS  = UDim2.new(0.5, -165, 0.5, -250)

local function setMinimized(state)
    isMinimized = state
    content.Visible = not state
    shadow.Visible = not state
    minimizeBtn.Text = state and "+" or "−"
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = state and MINI_SIZE or FULL_SIZE
    }):Play()
end

minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(not isMinimized)
end)

-- ==================== CORE FUNCTIONS ====================
local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function teleportTo(vector3)
    local hrp = getHRP()
    if not hrp then return end
    hrp.AssemblyLinearVelocity  = Vector3.zero
    hrp.AssemblyAngularVelocity = Vector3.zero
    player.Character:PivotTo(CFrame.new(vector3))
end

local function getCurrentPos()
    local hrp = getHRP()
    return hrp and hrp.Position or nil
end

local function makeSectionLabel(text, yPos, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -24, 0, 20)
    lbl.Position = UDim2.new(0, 12, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = GOLD_LIGHT
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = parent or content
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 3, 0, 14)
    line.Position = UDim2.new(0, -6, 0.5, -7)
    line.BackgroundColor3 = GOLD
    line.BorderSizePixel = 0
    line.Parent = lbl
    Instance.new("UICorner", line).CornerRadius = UDim.new(0,2)
    return lbl
end

-- ==================== SAVED LOCATIONS ====================
local DEFAULT_LOCATIONS = {
    {name = "🏆 W4 Win Pad", pos = Vector3.new(1770, 5.24, 1220)},
    {name = "⛏️ W4 Blocks",  pos = Vector3.new(1678.07, 5.24, 1247.45)},
}

local savedLocations = {}
local loadedFromFile = false

pcall(function()
    if readfile and isfile and isfile("pickaxe_tp.json") then
        local data = HttpService:JSONDecode(readfile("pickaxe_tp.json"))
        for _, entry in ipairs(data) do
            table.insert(savedLocations, {
                name = entry.name,
                pos  = Vector3.new(entry.x, entry.y, entry.z),
            })
        end
        loadedFromFile = true
    end
end)

if not loadedFromFile then
    for _, d in ipairs(DEFAULT_LOCATIONS) do
        table.insert(savedLocations, { name = d.name, pos = d.pos })
    end
end

local function saveToFile()
    pcall(function()
        local out = {}
        for _, loc in ipairs(savedLocations) do
            table.insert(out, {
                name = loc.name,
                x = loc.pos.X, y = loc.pos.Y, z = loc.pos.Z
            })
        end
        writefile("pickaxe_tp.json", HttpService:JSONEncode(out))
    end)
end

local autoEnabled = false
local autoThread  = nil
local stopAuto
local startAuto

makeSectionLabel("📍 SAVED LOCATIONS", 8)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -24, 0, 175)
scrollFrame.Position = UDim2.new(0, 12, 0, 32)
scrollFrame.BackgroundColor3 = BLACK_2
scrollFrame.BackgroundTransparency = 0.2
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #savedLocations * 44 + 10)
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = GOLD
scrollFrame.ZIndex = 6
scrollFrame.Parent = content

local sfCorner = Instance.new("UICorner")
sfCorner.CornerRadius = UDim.new(0, 12)
sfCorner.Parent = scrollFrame

local sfStroke = Instance.new("UIStroke")
sfStroke.Color = GOLD_DARK
sfStroke.Thickness = 1
sfStroke.Transparency = 0.6
sfStroke.Parent = scrollFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

local sfPad = Instance.new("UIPadding")
sfPad.PaddingTop    = UDim.new(0, 6)
sfPad.PaddingLeft   = UDim.new(0, 6)
sfPad.PaddingRight  = UDim.new(0, 6)
sfPad.PaddingBottom = UDim.new(0, 6)
sfPad.Parent = scrollFrame

local selectedIndex = nil
local rowButtons = {}

local function refreshList()
    for _, btn in ipairs(rowButtons) do btn:Destroy() end
    rowButtons = {}
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #savedLocations * 44 + 10)

    if selectedIndex and selectedIndex > #savedLocations then
        selectedIndex = nil
    end

    for i, loc in ipairs(savedLocations) do
        local isSelected = (selectedIndex == i)

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 40)
        row.BackgroundColor3 = isSelected and Color3.fromRGB(45, 38, 18) or BLACK_3
        row.BackgroundTransparency = isSelected and 0.1 or 0.3
        row.LayoutOrder = i
        row.ZIndex = 7
        row.Parent = scrollFrame

        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 10)
        rc.Parent = row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = isSelected and GOLD_NEON or GOLD_DARK
        rStroke.Thickness = isSelected and 1.5 or 1
        rStroke.Transparency = isSelected and 0.1 or 0.65
        rStroke.Parent = row

        local nameBtn = Instance.new("TextButton")
        nameBtn.Size = UDim2.new(0.5, 0, 1, 0)
        nameBtn.BackgroundTransparency = 1
        nameBtn.Text = loc.name
        nameBtn.TextColor3 = isSelected and GOLD_LIGHT or WHITE
        nameBtn.TextScaled = true
        nameBtn.Font = Enum.Font.GothamBold
        nameBtn.TextXAlignment = Enum.TextXAlignment.Left
        nameBtn.ZIndex = 8
        nameBtn.Parent = row

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 12)
        pad.Parent = nameBtn

        local selectBtn = Instance.new("TextButton")
        selectBtn.Size = UDim2.new(0.24, 0, 0, 26)
        selectBtn.Position = UDim2.new(0.52, 0, 0, 7)
        selectBtn.BackgroundColor3 = isSelected and GOLD or BLACK_4
        selectBtn.Text = isSelected and "✔ SELECTED" or "SELECT"
        selectBtn.TextColor3 = isSelected and BLACK or WHITE
        selectBtn.TextScaled = true
        selectBtn.Font = Enum.Font.GothamBold
        selectBtn.ZIndex = 8
        selectBtn.Parent = row

        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(0, 7)
        sc.Parent = selectBtn

        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, 26, 0, 26)
        deleteBtn.Position = UDim2.new(0.79, 0, 0, 7)
        deleteBtn.BackgroundColor3 = BLACK_4
        deleteBtn.Text = "✕"
        deleteBtn.TextColor3 = WHITE
        deleteBtn.TextScaled = true
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.ZIndex = 8
        deleteBtn.Parent = row

        local dc = Instance.new("UICorner")
        dc.CornerRadius = UDim.new(0, 7)
        dc.Parent = deleteBtn

        local dStroke = Instance.new("UIStroke")
        dStroke.Color = RED
        dStroke.Thickness = 1
        dStroke.Transparency = 0.6
        dStroke.Parent = deleteBtn

        deleteBtn.MouseEnter:Connect(function()
            TweenService:Create(deleteBtn, TweenInfo.new(0.15), {BackgroundColor3 = RED}):Play()
        end)
        deleteBtn.MouseLeave:Connect(function()
            TweenService:Create(deleteBtn, TweenInfo.new(0.15), {BackgroundColor3 = BLACK_4}):Play()
        end)

        nameBtn.MouseButton1Click:Connect(function()
            teleportTo(loc.pos)
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = GOLD}):Play()
            task.wait(0.15)
            TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = isSelected and Color3.fromRGB(45,38,18) or BLACK_3}):Play()
        end)

        selectBtn.MouseButton1Click:Connect(function()
            selectedIndex = i
            refreshList()
        end)

        deleteBtn.MouseButton1Click:Connect(function()
            table.remove(savedLocations, i)
            if selectedIndex == i then
                selectedIndex = nil
                if autoEnabled then stopAuto() end
            elseif selectedIndex and selectedIndex > i then
                selectedIndex = selectedIndex - 1
            end
            refreshList()
            saveToFile()
        end)

        table.insert(rowButtons, row)
    end
end

-- ==================== SAVE CURRENT ====================
makeSectionLabel("💾 SAVE CURRENT POSITION", 216)

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.58, 0, 0, 36)
nameBox.Position = UDim2.new(0, 12, 0, 240)
nameBox.BackgroundColor3 = BLACK_3
nameBox.PlaceholderText = "Name this spot..."
nameBox.PlaceholderColor3 = Color3.fromRGB(130,130,130)
nameBox.Text = ""
nameBox.TextColor3 = WHITE
nameBox.TextScaled = true
nameBox.Font = Enum.Font.GothamMedium
nameBox.ZIndex = 6
nameBox.Parent = content

local nbCorner = Instance.new("UICorner")
nbCorner.CornerRadius = UDim.new(0, 10)
nbCorner.Parent = nameBox

local nbStroke = Instance.new("UIStroke")
nbStroke.Color = GOLD_DARK
nbStroke.Thickness = 1
nbStroke.Transparency = 0.5
nbStroke.Parent = nameBox

nameBox.Focused:Connect(function()
    TweenService:Create(nbStroke, TweenInfo.new(0.2), {Color = GOLD_LIGHT, Transparency = 0}):Play()
end)
nameBox.FocusLost:Connect(function()
    TweenService:Create(nbStroke, TweenInfo.new(0.2), {Color = GOLD_DARK, Transparency = 0.5}):Play()
end)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.32, 0, 0, 36)
saveBtn.Position = UDim2.new(0.64, 0, 0, 240)
saveBtn.BackgroundColor3 = GOLD
saveBtn.Text = "➕ SAVE"
saveBtn.TextColor3 = BLACK
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.GothamBlack
saveBtn.ZIndex = 6
saveBtn.Parent = content

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 10)
sbCorner.Parent = saveBtn

saveBtn.MouseEnter:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = GOLD_LIGHT}):Play()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {Size = UDim2.new(0.32, 2, 0, 38), Position = UDim2.new(0.64, -1, 0, 239)}):Play()
end)
saveBtn.MouseLeave:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = GOLD}):Play()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {Size = UDim2.new(0.32, 0, 0, 36), Position = UDim2.new(0.64, 0, 0, 240)}):Play()
end)

saveBtn.MouseButton1Click:Connect(function()
    local pos = getCurrentPos()
    if not pos then return end
    local n = nameBox.Text
    if n == "" then n = "📍 Spot " .. (#savedLocations+1) end
    table.insert(savedLocations, {name = n, pos = pos})
    nameBox.Text = ""
    refreshList()
    saveToFile()
end)

-- ==================== CLEAR ALL ====================
local clearAllBtn = Instance.new("TextButton")
clearAllBtn.Size = UDim2.new(1, -24, 0, 26)
clearAllBtn.Position = UDim2.new(0, 12, 0, 284)
clearAllBtn.BackgroundColor3 = BLACK_3
clearAllBtn.BackgroundTransparency = 0.3
clearAllBtn.Text = "🗑️ CLEAR ALL SAVED CONFIGS"
clearAllBtn.TextColor3 = Color3.fromRGB(200,200,200)
clearAllBtn.TextScaled = true
clearAllBtn.Font = Enum.Font.GothamBold
clearAllBtn.ZIndex = 6
clearAllBtn.Parent = content

local caCorner = Instance.new("UICorner")
caCorner.CornerRadius = UDim.new(0, 8)
caCorner.Parent = clearAllBtn

local caStroke = Instance.new("UIStroke")
caStroke.Color = RED
caStroke.Thickness = 1
caStroke.Transparency = 0.6
caStroke.Parent = clearAllBtn

local confirmPending = false

clearAllBtn.MouseButton1Click:Connect(function()
    if not confirmPending then
        confirmPending = true
        clearAllBtn.Text = "⚠️ CLICK AGAIN TO CONFIRM"
        clearAllBtn.BackgroundColor3 = RED
        clearAllBtn.TextColor3 = WHITE
        task.delay(3, function()
            if confirmPending then
                confirmPending = false
                clearAllBtn.Text = "🗑️ CLEAR ALL SAVED CONFIGS"
                clearAllBtn.BackgroundColor3 = BLACK_3
                clearAllBtn.TextColor3 = Color3.fromRGB(200,200,200)
            end
        end)
        return
    end

    confirmPending = false
    savedLocations = {}
    selectedIndex = nil
    if autoEnabled then stopAuto() end
    clearAllBtn.Text = "🗑️ CLEAR ALL SAVED CONFIGS"
    clearAllBtn.BackgroundColor3 = BLACK_3
    clearAllBtn.TextColor3 = Color3.fromRGB(200,200,200)
    refreshList()
    saveToFile()
end)

-- ==================== AUTO-TELEPORT ====================
makeSectionLabel("🔁 AUTO-TELEPORT", 320)

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0.60, 0, 0, 42)
autoBtn.Position = UDim2.new(0, 12, 0, 346)
autoBtn.BackgroundColor3 = BLACK_3
autoBtn.Text = "AUTO TP: OFF"
autoBtn.TextColor3 = WHITE
autoBtn.TextScaled = true
autoBtn.Font = Enum.Font.GothamBlack
autoBtn.ZIndex = 6
autoBtn.Parent = content

local abCorner = Instance.new("UICorner")
abCorner.CornerRadius = UDim.new(0, 10)
abCorner.Parent = autoBtn

local abStroke = Instance.new("UIStroke")
abStroke.Color = GOLD_DARK
abStroke.Thickness = 1.2
abStroke.Transparency = 0.4
abStroke.Parent = autoBtn

local intervalBox = Instance.new("TextBox")
intervalBox.Size = UDim2.new(0.30, 0, 0, 42)
intervalBox.Position = UDim2.new(0.66, 0, 0, 346)
intervalBox.BackgroundColor3 = BLACK_3
intervalBox.Text = "1s"
intervalBox.TextColor3 = WHITE
intervalBox.TextScaled = true
intervalBox.Font = Enum.Font.GothamBold
intervalBox.PlaceholderText = "1s"
intervalBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
intervalBox.ZIndex = 6
intervalBox.Parent = content

local ibCorner = Instance.new("UICorner")
ibCorner.CornerRadius = UDim.new(0, 10)
ibCorner.Parent = intervalBox

local ibStroke = Instance.new("UIStroke")
ibStroke.Color = GOLD_DARK
ibStroke.Thickness = 1.2
ibStroke.Transparency = 0.4
ibStroke.Parent = intervalBox

intervalBox.FocusLost:Connect(function()
    intervalBox.Text = intervalBox.Text:gsub("[^%d%.]", "")
    if intervalBox.Text == "" then intervalBox.Text = "1" end
    intervalBox.Text = intervalBox.Text .. "s"
end)

function stopAuto()
    autoEnabled = false
    if autoThread and coroutine.status(autoThread) ~= "dead" then
        task.cancel(autoThread)
    end
    autoThread = nil
    autoBtn.Text = "AUTO TP: OFF"
    autoBtn.TextColor3 = WHITE
    autoBtn.TextScaled = true
    abStroke.Color = GOLD_DARK
    TweenService:Create(autoBtn, TweenInfo.new(0.2), {BackgroundColor3 = BLACK_3}):Play()
end

function startAuto()
    if selectedIndex == nil then return end
    autoEnabled = true
    autoBtn.Text = "AUTO TP: ON • " .. savedLocations[selectedIndex].name
    autoBtn.TextScaled = false
    autoBtn.TextSize = 12
    autoBtn.BackgroundColor3 = GOLD
    autoBtn.TextColor3 = BLACK
    abStroke.Color = GOLD_LIGHT

    local intervalStr = intervalBox.Text:gsub("[^%d%.]", "")
    local interval = tonumber(intervalStr) or 1
    if interval < 0.1 then interval = 0.1 end

    autoThread = task.spawn(function()
        while autoEnabled do
            local target = savedLocations[selectedIndex]
            if target then teleportTo(target.pos) end
            task.wait(interval)
        end
    end)
end

autoBtn.MouseButton1Click:Connect(function()
    if autoEnabled then stopAuto() else startAuto() end
end)

-- ==================== FOOTER ====================
local footerLine = Instance.new("Frame")
footerLine.Size = UDim2.new(1, -24, 0, 1)
footerLine.Position = UDim2.new(0, 12, 1, -28)
footerLine.BackgroundColor3 = GOLD_DARK
footerLine.BackgroundTransparency = 0.6
footerLine.BorderSizePixel = 0
footerLine.ZIndex = 6
footerLine.Parent = content

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -24, 0, 16)
footer.Position = UDim2.new(0, 12, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "made by gamer owns yall • " .. DISCORD .. " • v8 PREMIUM"
footer.TextColor3 = Color3.fromRGB(120,120,120)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.ZIndex = 6
footer.Parent = content

-- ==================== TOGGLE BUTTON ====================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 56, 0, 56)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -28)
toggleBtn.BackgroundColor3 = BLACK
toggleBtn.Text = "⚡"
toggleBtn.TextColor3 = GOLD_LIGHT
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.Parent = screenGui

local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0, 28)
tbCorner.Parent = toggleBtn

local tbStroke = Instance.new("UIStroke")
tbStroke.Color = GOLD
tbStroke.Thickness = 2
tbStroke.Transparency = 0.1
tbStroke.Parent = toggleBtn

local tbGrad = Instance.new("UIGradient")
tbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_LIGHT),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
tbGrad.Parent = tbStroke

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = GOLD, TextColor3 = BLACK}):Play()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 62, 0, 62)}):Play()
end)

toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = BLACK, TextColor3 = GOLD_LIGHT}):Play()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {Size = UDim2.new(0, 56, 0, 56)}):Play()
end)

do
    local dragging, dragMoved = false, false
    local dragStart, startPos

    toggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragMoved = true, false
            dragStart = input.Position
            startPos  = toggleBtn.Position
        end
    end)

    toggleBtn.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) + math.abs(delta.Y) > 4 then
                dragMoved = true
            end
            toggleBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    toggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        if dragMoved then return end
        local open = not mainFrame.Visible
        mainFrame.Visible = open
        shadow.Visible = open and not isMinimized
    end)
end

-- Initial load
refreshList()

-- ==================== STARTUP ANIMATION ====================
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(0,0,0,0)
shadow.Position = UDim2.new(0.5,0,0.5,0)

TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = FULL_SIZE,
    Position = FULL_POS,
}):Play()
TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0,340,0,520),
    Position = UDim2.new(0.5, -170, 0.5, -250),
}):Play()

task.delay(0.5, function()
    while mainFrame.Parent do
        TweenService:Create(neonLine, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.3}):Play()
        task.wait(1.5)
        TweenService:Create(neonLine, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
        task.wait(1.5)
    end
end)

print("[gamer owns yall v8 PREMIUM] Loaded • " .. DISCORD)