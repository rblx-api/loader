--[[
    👹 ROLEX DEVIL — TINY GHOST THEME 👻
    SpamGrab + 6 Songs + Volume Slider + START-first Toggle
]]

-- ===== SERVICES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ===== THEME =====
local THEME = {
    BG       = Color3.fromRGB(8, 4, 14),
    BG2      = Color3.fromRGB(18, 8, 28),
    GLASS    = Color3.fromRGB(35, 18, 55),
    GLASS2   = Color3.fromRGB(55, 30, 80),
    ORANGE   = Color3.fromRGB(255, 130, 20),
    ORANGE2  = Color3.fromRGB(255, 190, 70),
    PURPLE   = Color3.fromRGB(160, 70, 240),
    PURPLE2  = Color3.fromRGB(220, 130, 255),
    PINK     = Color3.fromRGB(255, 90, 190),
    RED      = Color3.fromRGB(230, 40, 50),
    GREEN    = Color3.fromRGB(80, 250, 150),
    GHOST    = Color3.fromRGB(200, 220, 255),
    TEXT     = Color3.fromRGB(255, 240, 225),
    SUBTEXT  = Color3.fromRGB(200, 170, 235),
}
local Fonts = { Title = Enum.Font.GothamBlack, Body = Enum.Font.GothamSemibold }

-- ===== PLAYLIST (6 SONGS) =====
local PLAYLIST = {
    135607709606498,
    104524426733163,
    121397051787416,
    109285503966930,
    97055099171835,
    107942306801458,
}
local songIndex = 1

local song = Instance.new("Sound")
song.Name = "ROLEX_DEVIL_SONG"
song.SoundId = "rbxassetid://" .. PLAYLIST[songIndex]
song.Volume = 0.5
song.Looped = false
song.Parent = SoundService

-- ===== GRAB EVENT =====
local CombatService = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit")
    :WaitForChild("Services"):WaitForChild("CombatService")
local GrabEvent = CombatService:WaitForChild("RF"):WaitForChild("Grab")

-- ===== SPAM CORE (STARTS OFF) =====
local spamming = false
local spamConnection
local grabsThisSecond, totalGrabs = 0, 0

local function startSpam()
    if spamming then return end
    spamming = true
    spamConnection = RunService.Heartbeat:Connect(function()
        task.spawn(function()
            pcall(function()
                GrabEvent:InvokeServer()
                grabsThisSecond += 1
                totalGrabs += 1
            end)
        end)
    end)
end

local function stopSpam()
    spamming = false
    if spamConnection then spamConnection:Disconnect(); spamConnection = nil end
end

-- ===== HELPERS =====
local function corner(p, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p; return c
end
local function gradient(p, colors, rot)
    local g = Instance.new("UIGradient")
    g.Color = colors or ColorSequence.new({ColorSequenceKeypoint.new(0, THEME.ORANGE), ColorSequenceKeypoint.new(1, THEME.PURPLE)})
    g.Rotation = rot or 45
    g.Parent = p
    return g
end
local function stroke(p, color, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.ORANGE
    s.Thickness = th or 1
    s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end
local function addRipple(btn, color)
    btn.ClipsDescendants = true
    btn.MouseButton1Down:Connect(function()
        local r = Instance.new("Frame")
        r.Size = UDim2.new(0, 0, 0, 0)
        r.Position = UDim2.new(0.5, 0, 0.5, 0)
        r.AnchorPoint = Vector2.new(0.5, 0.5)
        r.BackgroundColor3 = color or Color3.new(1,1,1)
        r.BackgroundTransparency = 0.3
        r.BorderSizePixel = 0
        r.ZIndex = 10
        r.Parent = btn
        corner(r, 999)
        local m = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 1.6
        TweenService:Create(r, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, m, 0, m),
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.45, function() r:Destroy() end)
    end)
end

-- ===== ROOT =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ROLEX_DEVIL_TINY"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 9999
screenGui.Parent = PlayerGui

local dim = Instance.new("Frame")
dim.Size = UDim2.new(1, 0, 1, 0)
dim.BackgroundColor3 = Color3.new(0, 0, 0)
dim.BackgroundTransparency = 0.6
dim.BorderSizePixel = 0
dim.Visible = false
dim.ZIndex = 1
dim.Parent = screenGui

-- ===== MAIN WINDOW (TINY) =====
local W, H = 200, 310

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
main.BackgroundColor3 = THEME.BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Active = true
main.Draggable = true
main.ZIndex = 2
main.Parent = screenGui

corner(main, 12)
gradient(main, ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.BG2),
    ColorSequenceKeypoint.new(0.5, THEME.BG),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 6, 30)),
}), 135)

local mainStroke = stroke(main, THEME.ORANGE, 1.5, 0.15)
task.spawn(function()
    while main.Parent do
        TweenService:Create(mainStroke, TweenInfo.new(1.5), {Transparency = 0.8, Color = THEME.PURPLE}):Play()
        task.wait(1.5)
        TweenService:Create(mainStroke, TweenInfo.new(1.5), {Transparency = 0.15, Color = THEME.ORANGE}):Play()
        task.wait(1.5)
    end
end)

-- ===== GHOST BACKGROUND (subtle) =====
local ghostBg = Instance.new("Frame")
ghostBg.Size = UDim2.new(1, 0, 1, 0)
ghostBg.BackgroundTransparency = 1
ghostBg.ClipsDescendants = true
ghostBg.ZIndex = 2
ghostBg.Parent = main

local bigGhost = Instance.new("TextLabel")
bigGhost.Size = UDim2.new(0, 140, 0, 140)
bigGhost.Position = UDim2.new(0.5, -70, 0.5, -50)
bigGhost.BackgroundTransparency = 1
bigGhost.Text = "👻"
bigGhost.TextSize = 140
bigGhost.TextTransparency = 0.9
bigGhost.Rotation = -12
bigGhost.ZIndex = 2
bigGhost.Parent = ghostBg

-- Floating ghosts
local ghostEmojis = {"👻", "🎃", "🦇", "💀", "🕷️"}
task.spawn(function()
    while ghostBg.Parent do
        local g = Instance.new("TextLabel")
        g.Size = UDim2.new(0, 16, 0, 16)
        g.BackgroundTransparency = 1
        g.Text = ghostEmojis[math.random(1, #ghostEmojis)]
        g.TextSize = math.random(10, 16)
        g.TextTransparency = 0.65
        g.Position = UDim2.new(math.random(), 0, 1.05, 0)
        g.Rotation = math.random(-30, 30)
        g.ZIndex = 2
        g.Parent = ghostBg
        TweenService:Create(g, TweenInfo.new(4 + math.random()*3, Enum.EasingStyle.Linear), {
            Position = UDim2.new(g.Position.X.Scale, 0, -0.15, 0),
            TextTransparency = 0.97,
            Rotation = math.random(-180, 180),
        }):Play()
        task.delay(7, function() g:Destroy() end)
        task.wait(0.8)
    end
end)

-- ===== HEADER (compact) =====
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = THEME.GLASS
header.BorderSizePixel = 0
header.ZIndex = 3
header.Parent = main
corner(header, 12)
gradient(header, ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 20, 90)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(110, 30, 70)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 10, 55)),
}), 90)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(45, 10, 55)
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 2
headerFix.Parent = header

-- Ghost logo
local logoHolder = Instance.new("Frame")
logoHolder.Size = UDim2.new(0, 30, 0, 30)
logoHolder.Position = UDim2.new(0, 7, 0.5, -15)
logoHolder.BackgroundColor3 = Color3.fromRGB(20, 8, 35)
logoHolder.BorderSizePixel = 0
logoHolder.ZIndex = 4
logoHolder.Parent = header
corner(logoHolder, 999)
stroke(logoHolder, THEME.GHOST, 1.5, 0)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "👻"
logoText.TextSize = 18
logoText.ZIndex = 5
logoText.Parent = logoHolder

task.spawn(function()
    while logoText.Parent do
        TweenService:Create(logoText, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, 0, 0, -2)
        }):Play()
        task.wait(0.6)
        TweenService:Create(logoText, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0, 0, 0, 2)
        }):Play()
        task.wait(0.6)
    end
end)

local logoRing = Instance.new("Frame")
logoRing.Size = UDim2.new(0, 36, 0, 36)
logoRing.Position = UDim2.new(0, -3, 0, -3)
logoRing.BackgroundTransparency = 1
logoRing.ZIndex = 3
logoRing.Parent = logoHolder
corner(logoRing, 999)
stroke(logoRing, THEME.PURPLE2, 1.5, 0.3)
task.spawn(function()
    while logoRing.Parent do
        TweenService:Create(logoRing, TweenInfo.new(3), {Rotation = logoRing.Rotation + 180}):Play()
        task.wait(3)
    end
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 14)
title.Position = UDim2.new(0, 44, 0, 5)
title.BackgroundTransparency = 1
title.Text = "ROLEX DEVIL"
title.Font = Fonts.Title
title.TextSize = 12
title.TextColor3 = THEME.ORANGE2
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeTransparency = 0.4
title.TextStrokeColor3 = Color3.fromRGB(80, 0, 20)
title.ZIndex = 4
title.Parent = header

task.spawn(function()
    local cols = {THEME.ORANGE2, THEME.PINK, THEME.PURPLE2, THEME.ORANGE2}
    local i = 1
    while title.Parent do
        TweenService:Create(title, TweenInfo.new(0.9), {TextColor3 = cols[i]}):Play()
        i = (i % #cols) + 1
        task.wait(0.9)
    end
end)

-- Subtitle
local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, -50, 0, 10)
subLabel.Position = UDim2.new(0, 44, 0, 22)
subLabel.BackgroundTransparency = 1
subLabel.Text = "👻 GHOST EDITION"
subLabel.Font = Fonts.Body
subLabel.TextSize = 8
subLabel.TextColor3 = THEME.SUBTEXT
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.ZIndex = 4
subLabel.Parent = header

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -24, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(70, 14, 28)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.Font = Fonts.Title
closeBtn.TextSize = 10
closeBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 5
closeBtn.Parent = header
corner(closeBtn, 999)
stroke(closeBtn, THEME.RED, 1, 0.3)

closeBtn.MouseButton1Click:Connect(function()
    stopSpam(); song:Stop(); screenGui:Destroy()
end)

-- ===== STATS ROW (tiny) =====
local statsRow = Instance.new("Frame")
statsRow.Size = UDim2.new(1, -12, 0, 38)
statsRow.Position = UDim2.new(0, 6, 0, 48)
statsRow.BackgroundTransparency = 1
statsRow.ZIndex = 4
statsRow.Parent = main

local statLayout = Instance.new("UIListLayout")
statLayout.FillDirection = Enum.FillDirection.Horizontal
statLayout.Padding = UDim.new(0, 4)
statLayout.Parent = statsRow

local function makeStatCard(labelText, valueText, accent)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.333, -3, 1, 0)
    card.BackgroundColor3 = THEME.GLASS
    card.BorderSizePixel = 0
    card.ZIndex = 4
    card.Parent = statsRow
    corner(card, 6)
    stroke(card, accent, 1, 0.4)
    gradient(card, ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.GLASS2),
        ColorSequenceKeypoint.new(1, THEME.GLASS),
    }), 90)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 10)
    lbl.Position = UDim2.new(0, 0, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.Font = Fonts.Body
    lbl.TextSize = 7
    lbl.TextColor3 = accent
    lbl.ZIndex = 5
    lbl.Parent = card

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1, 0, 0, 16)
    val.Position = UDim2.new(0, 0, 0, 14)
    val.BackgroundTransparency = 1
    val.Text = valueText
    val.Font = Fonts.Title
    val.TextSize = 12
    val.TextColor3 = THEME.TEXT
    val.ZIndex = 5
    val.Parent = card
    return val
end

local fpsVal   = makeStatCard("FPS",    "0", THEME.GREEN)
local grabVal  = makeStatCard("GRAB/S", "0", THEME.ORANGE)
local totalVal = makeStatCard("TOTAL",  "0", THEME.PINK)

task.spawn(function()
    local fps = 0
    RunService.RenderStepped:Connect(function() fps += 1 end)
    while screenGui.Parent do
        task.wait(1)
        fpsVal.Text   = tostring(fps)
        grabVal.Text  = tostring(grabsThisSecond)
        totalVal.Text = totalGrabs > 9999 and string.format("%.1fk", totalGrabs/1000) or tostring(totalGrabs)
        grabsThisSecond = 0
        fps = 0
    end
end)

-- ===== TOGGLE BUTTON (START first) =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -12, 0, 40)
toggleBtn.Position = UDim2.new(0, 6, 0, 92)
toggleBtn.BackgroundColor3 = THEME.GREEN
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = ""
toggleBtn.AutoButtonColor = false
toggleBtn.ClipsDescendants = true
toggleBtn.ZIndex = 4
toggleBtn.Parent = main
corner(toggleBtn, 8)
gradient(toggleBtn, ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 200, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 120, 130)),
}), 90)
local toggleStroke = stroke(toggleBtn, THEME.GREEN, 1.5, 0.2)

local toggleIcon = Instance.new("TextLabel")
toggleIcon.Size = UDim2.new(0, 26, 0, 26)
toggleIcon.Position = UDim2.new(0, 8, 0.5, -13)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Text = "▶"
toggleIcon.TextSize = 18
toggleIcon.TextColor3 = THEME.TEXT
toggleIcon.ZIndex = 5
toggleIcon.Parent = toggleBtn

local toggleLabel = Instance.new("TextLabel")
toggleLabel.Size = UDim2.new(1, -44, 1, 0)
toggleLabel.Position = UDim2.new(0, 40, 0, 0)
toggleLabel.BackgroundTransparency = 1
toggleLabel.Text = "START SPAM"
toggleLabel.Font = Fonts.Title
toggleLabel.TextSize = 12
toggleLabel.TextColor3 = THEME.TEXT
toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
toggleLabel.ZIndex = 5
toggleLabel.Parent = toggleBtn

addRipple(toggleBtn, Color3.new(1, 1, 1))

-- ===== MUSIC FRAME (compact) =====
local musicFrame = Instance.new("Frame")
musicFrame.Size = UDim2.new(1, -12, 0, 92)
musicFrame.Position = UDim2.new(0, 6, 0, 138)
musicFrame.BackgroundColor3 = THEME.GLASS
musicFrame.BorderSizePixel = 0
musicFrame.ZIndex = 4
musicFrame.Parent = main
corner(musicFrame, 8)
stroke(musicFrame, THEME.PURPLE, 1, 0.3)
gradient(musicFrame, ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.GLASS2),
    ColorSequenceKeypoint.new(1, THEME.GLASS),
}), 90)

local musicTitle = Instance.new("TextLabel")
musicTitle.Size = UDim2.new(1, -10, 0, 10)
musicTitle.Position = UDim2.new(0, 5, 0, 4)
musicTitle.BackgroundTransparency = 1
musicTitle.Text = "🎵 TRACK 1/" .. #PLAYLIST
musicTitle.Font = Fonts.Body
musicTitle.TextSize = 8
musicTitle.TextColor3 = THEME.PINK
musicTitle.TextXAlignment = Enum.TextXAlignment.Left
musicTitle.ZIndex = 5
musicTitle.Parent = musicFrame

-- Controls row
local controls = Instance.new("Frame")
controls.Size = UDim2.new(1, -10, 0, 22)
controls.Position = UDim2.new(0, 5, 0, 18)
controls.BackgroundTransparency = 1
controls.ZIndex = 5
controls.Parent = musicFrame

local ctrlLayout = Instance.new("UIListLayout")
ctrlLayout.FillDirection = Enum.FillDirection.Horizontal
ctrlLayout.Padding = UDim.new(0, 3)
ctrlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ctrlLayout.Parent = controls

local function makeCtrlBtn(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 22, 0, 22)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = text
    b.Font = Fonts.Title
    b.TextSize = 11
    b.TextColor3 = THEME.TEXT
    b.AutoButtonColor = false
    b.ClipsDescendants = true
    b.ZIndex = 6
    b.Parent = controls
    corner(b, 5)
    addRipple(b, Color3.new(1,1,1))
    return b
end

local prevBtn = makeCtrlBtn("⏮", Color3.fromRGB(70, 35, 110))
local playBtn = makeCtrlBtn("▶", Color3.fromRGB(200, 50, 130))
local nextBtn = makeCtrlBtn("⏭", Color3.fromRGB(70, 35, 110))

-- Equalizer
local eqHolder = Instance.new("Frame")
eqHolder.Size = UDim2.new(0, 40, 0, 20)
eqHolder.Position = UDim2.new(1, -46, 0, 19)
eqHolder.BackgroundTransparency = 1
eqHolder.ZIndex = 6
eqHolder.Parent = musicFrame

local eqBars = {}
for i = 1, 4 do
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 5, 0, 16)
    bar.Position = UDim2.new(0, (i-1)*10, 1, 0)
    bar.AnchorPoint = Vector2.new(0, 1)
    bar.BackgroundColor3 = THEME.PINK
    bar.BorderSizePixel = 0
    bar.ZIndex = 7
    bar.Parent = eqHolder
    corner(bar, 2)
    eqBars[i] = bar
end

task.spawn(function()
    while eqHolder.Parent do
        if song.IsPlaying then
            for _, bar in ipairs(eqBars) do
                TweenService:Create(bar, TweenInfo.new(0.15 + math.random()*0.15), {
                    Size = UDim2.new(0, 5, 0, math.random(3, 16))
                }):Play()
            end
        else
            for _, bar in ipairs(eqBars) do
                TweenService:Create(bar, TweenInfo.new(0.2), {Size = UDim2.new(0, 5, 0, 3)}):Play()
            end
        end
        task.wait(0.18)
    end
end)

-- Volume row
local volRow = Instance.new("Frame")
volRow.Size = UDim2.new(1, -10, 0, 22)
volRow.Position = UDim2.new(0, 5, 0, 46)
volRow.BackgroundTransparency = 1
volRow.ZIndex = 5
volRow.Parent = musicFrame

local volIcon = Instance.new("TextLabel")
volIcon.Size = UDim2.new(0, 16, 1, 0)
volIcon.BackgroundTransparency = 1
volIcon.Text = "🔊"
volIcon.TextSize = 10
volIcon.ZIndex = 6
volIcon.Parent = volRow

local volPct = Instance.new("TextLabel")
volPct.Size = UDim2.new(0, 28, 1, 0)
volPct.Position = UDim2.new(1, -28, 0, 0)
volPct.BackgroundTransparency = 1
volPct.Text = "50%"
volPct.Font = Fonts.Body
volPct.TextSize = 8
volPct.TextColor3 = THEME.SUBTEXT
volPct.TextXAlignment = Enum.TextXAlignment.Right
volPct.ZIndex = 6
volPct.Parent = volRow

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, -54, 0, 6)
sliderTrack.Position = UDim2.new(0, 20, 0.5, -3)
sliderTrack.BackgroundColor3 = Color3.fromRGB(55, 28, 75)
sliderTrack.BorderSizePixel = 0
sliderTrack.ZIndex = 6
sliderTrack.Parent = volRow
corner(sliderTrack, 3)

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
sliderFill.BackgroundColor3 = THEME.PINK
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 7
sliderFill.Parent = sliderTrack
corner(sliderFill, 3)
gradient(sliderFill, ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.PURPLE),
    ColorSequenceKeypoint.new(1, THEME.PINK),
}), 0)

local sliderKnob = Instance.new("Frame")
sliderKnob.Size = UDim2.new(0, 12, 0, 12)
sliderKnob.Position = UDim2.new(0.5, -6, 0.5, -6)
sliderKnob.BackgroundColor3 = THEME.ORANGE2
sliderKnob.BorderSizePixel = 0
sliderKnob.ZIndex = 8
sliderKnob.Parent = sliderTrack
corner(sliderKnob, 999)
stroke(sliderKnob, THEME.BG, 2, 0)

local sliding = false
local function updateVolumeFromX(absX)
    local rel = math.clamp((absX - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
    song.Volume = rel
    sliderFill.Size = UDim2.new(rel, 0, 1, 0)
    sliderKnob.Position = UDim2.new(rel, -6, 0.5, -6)
    volPct.Text = math.floor(rel * 100 + 0.5) .. "%"
end

sliderTrack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        updateVolumeFromX(input.Position.X)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        updateVolumeFromX(input.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
    end
end)

-- Track controls
local function updateTrackLabel()
    musicTitle.Text = "🎵 TRACK " .. songIndex .. "/" .. #PLAYLIST
end

local function loadTrack(idx, play)
    songIndex = idx
    song:Stop()
    song.SoundId = "rbxassetid://" .. PLAYLIST[songIndex]
    updateTrackLabel()
    if play then song:Play() else song:Pause() end
end

prevBtn.MouseButton1Click:Connect(function()
    local idx = songIndex - 1
    if idx < 1 then idx = #PLAYLIST end
    loadTrack(idx, true)
    playBtn.Text = "⏸"
end)

nextBtn.MouseButton1Click:Connect(function()
    local idx = songIndex + 1
    if idx > #PLAYLIST then idx = 1 end
    loadTrack(idx, true)
    playBtn.Text = "⏸"
end)

playBtn.MouseButton1Click:Connect(function()
    if song.IsPlaying then
        song:Pause()
        playBtn.Text = "▶"
    else
        song:Play()
        playBtn.Text = "⏸"
    end
end)

song.Ended:Connect(function()
    local idx = songIndex + 1
    if idx > #PLAYLIST then idx = 1 end
    loadTrack(idx, true)
    playBtn.Text = "⏸"
end)

-- ===== MOBILE MODE BUTTON =====
local sizeBtn = Instance.new("TextButton")
sizeBtn.Size = UDim2.new(1, -12, 0, 22)
sizeBtn.Position = UDim2.new(0, 6, 0, 236)
sizeBtn.BackgroundColor3 = THEME.GLASS
sizeBtn.BorderSizePixel = 0
sizeBtn.Text = "📱 MOBILE: OFF"
sizeBtn.Font = Fonts.Body
sizeBtn.TextSize = 8
sizeBtn.TextColor3 = THEME.SUBTEXT
sizeBtn.AutoButtonColor = false
sizeBtn.ClipsDescendants = true
sizeBtn.ZIndex = 4
sizeBtn.Parent = main
corner(sizeBtn, 6)
stroke(sizeBtn, THEME.ORANGE, 1, 0.5)
addRipple(sizeBtn, THEME.ORANGE)

-- ===== FOOTER =====
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -12, 0, 12)
footer.Position = UDim2.new(0, 6, 1, -18)
footer.BackgroundTransparency = 1
footer.Text = "👻 ROLEX DEVIL 👻"
footer.Font = Fonts.Body
footer.TextSize = 7
footer.TextColor3 = THEME.SUBTEXT
footer.TextTransparency = 0.4
footer.ZIndex = 4
footer.Parent = main

-- ===== TOGGLE LOGIC (START first) =====
local active = false
local function setActive(state)
    active = state
    if active then
        startSpam()
        toggleIcon.Text = "⛔"
        toggleLabel.Text = "STOP SPAM"
        gradient(toggleBtn, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 40, 50)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 15, 70)),
        }), 90)
        toggleStroke.Color = Color3.fromRGB(255, 110, 110)
    else
        stopSpam()
        toggleIcon.Text = "▶"
        toggleLabel.Text = "START SPAM"
        gradient(toggleBtn, ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 200, 90)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 120, 130)),
        }), 90)
        toggleStroke.Color = THEME.GREEN
    end
    local orig = toggleBtn.Size
    TweenService:Create(toggleBtn, TweenInfo.new(0.08), {
        Size = UDim2.new(orig.X.Scale, orig.X.Offset, 0, 37)
    }):Play()
    task.delay(0.1, function()
        TweenService:Create(toggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {Size = orig}):Play()
    end)
end

setActive(false)  -- start OFF

toggleBtn.MouseButton1Click:Connect(function()
    setActive(not active)
end)

-- ===== MOBILE MODE TOGGLE =====
local mobileCompact = false
sizeBtn.MouseButton1Click:Connect(function()
    mobileCompact = not mobileCompact
    sizeBtn.Text = mobileCompact and "📱 MOBILE: ON" or "📱 MOBILE: OFF"
    local target = mobileCompact and UDim2.new(0, 170, 0, 260) or UDim2.new(0, W, 0, H)
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = target}):Play()
end)

-- ===== KEYBINDS =====
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        setActive(not active)
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

-- ===== MOBILE BUBBLE =====
if isMobile then
    local bubble = Instance.new("TextButton")
    bubble.Size = UDim2.new(0, 40, 0, 40)
    bubble.Position = UDim2.new(0, 10, 0.5, 26)
    bubble.BackgroundColor3 = THEME.PURPLE
    bubble.BorderSizePixel = 0
    bubble.Text = "👻"
    bubble.Font = Fonts.Title
    bubble.TextSize = 17
    bubble.TextColor3 = THEME.TEXT
    bubble.AutoButtonColor = false
    bubble.Active = true
    bubble.ZIndex = 20
    bubble.Parent = screenGui
    corner(bubble, 999)
    local bubbleStroke = stroke(bubble, THEME.PURPLE2, 2, 0)

    task.spawn(function()
        while bubble.Parent do
            TweenService:Create(bubbleStroke, TweenInfo.new(1), {Transparency = 0.7, Thickness = 3}):Play()
            task.wait(1)
            TweenService:Create(bubbleStroke, TweenInfo.new(1), {Transparency = 0, Thickness = 2}):Play()
            task.wait(1)
        end
    end)

    local dragging, dragStart, startPos = false, nil, nil
    bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = bubble.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - dragStart
            bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    bubble.MouseButton1Click:Connect(function()
        main.Visible = not main.Visible
        dim.Visible = main.Visible
        if main.Visible then
            main.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, W, 0, H)}):Play()
        end
    end)
end

-- ===== OPEN ANIMATION =====
main.Size = UDim2.new(0, 0, 0, 0)
main.BackgroundTransparency = 1
task.delay(0.05, function()
    TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, W, 0, H),
    }):Play()
    TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
end)

print("👻 [ROLEX DEVIL — TINY GHOST THEME] Loaded — Spam OFF • 6 songs ready 🎃")