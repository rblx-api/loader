-- [NEW WORLD] +1 Pickaxe Swing Escape - gamer owns yall (v9.5 PREMIUM)
-- Place ID: 82554996468034
-- Teleport system is UNCHANGED from v9.
-- v9.5: bundled gamer MUSIC (63 songs) + 🎵 toggle button + RightShift keybind.
-- Music player code is isolated in a do...end block.

local Players          = game:GetService("Players")
local player           = Players.LocalPlayer
local playerGui        = player:WaitForChild("PlayerGui")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser      = game:GetService("VirtualUser")
local Stats            = game:GetService("Stats")

-- ==================== COLORS ====================
local BLACK   = Color3.fromRGB(10, 10, 12)
local BLACK_2 = Color3.fromRGB(18, 18, 20)
local BLACK_3 = Color3.fromRGB(28, 28, 32)
local BLACK_4 = Color3.fromRGB(38, 38, 42)
local RED     = Color3.fromRGB(255, 70, 70)
local WHITE   = Color3.fromRGB(245, 245, 245)
local GREEN   = Color3.fromRGB(90, 220, 120)
local YELLOW  = Color3.fromRGB(240, 200, 80)
local DISCORD = "discord.gg/4TueRJmzDh"
local LOGO_ID = "rbxassetid://138472956105442"

-- ==================== THEMES ====================
local THEMES = {
    Gold    = {name="GOLD",    primary=Color3.fromRGB(212,175,55), dark=Color3.fromRGB(160,130,35),  light=Color3.fromRGB(255,215,90),  neon=Color3.fromRGB(255,235,120)},
    Cyan    = {name="CYAN",    primary=Color3.fromRGB(80,200,255), dark=Color3.fromRGB(40,120,180),  light=Color3.fromRGB(150,220,255), neon=Color3.fromRGB(200,240,255)},
    Emerald = {name="EMERALD", primary=Color3.fromRGB(60,200,120), dark=Color3.fromRGB(30,120,70),   light=Color3.fromRGB(120,230,160), neon=Color3.fromRGB(180,255,210)},
    Crimson = {name="CRIMSON", primary=Color3.fromRGB(220,60,70),  dark=Color3.fromRGB(140,30,40),   light=Color3.fromRGB(255,120,120), neon=Color3.fromRGB(255,180,180)},
    Purple  = {name="PURPLE",  primary=Color3.fromRGB(170,90,230), dark=Color3.fromRGB(100,50,150),  light=Color3.fromRGB(210,150,255), neon=Color3.fromRGB(230,190,255)},
    Pink    = {name="PINK",    primary=Color3.fromRGB(255,110,180),dark=Color3.fromRGB(170,60,120),  light=Color3.fromRGB(255,170,210), neon=Color3.fromRGB(255,210,230)},
    Mono    = {name="MONO",    primary=Color3.fromRGB(220,220,220),dark=Color3.fromRGB(120,120,120), light=Color3.fromRGB(240,240,240), neon=Color3.fromRGB(255,255,255)},
    Blood   = {name="BLOOD",   primary=Color3.fromRGB(200,20,20),  dark=Color3.fromRGB(90,10,10),    light=Color3.fromRGB(255,80,80),   neon=Color3.fromRGB(255,140,140)},
}
local themeOrder = {"Gold","Cyan","Emerald","Crimson","Purple","Pink","Mono","Blood"}

local GOLD, GOLD_DARK, GOLD_LIGHT, GOLD_NEON
local currentThemeName = "Gold"
local function applyThemeVars(name)
    local t = THEMES[name] or THEMES.Gold
    GOLD, GOLD_DARK, GOLD_LIGHT, GOLD_NEON = t.primary, t.dark, t.light, t.neon
    currentThemeName = name
end
applyThemeVars(currentThemeName)

-- ==================== PLATFORM ====================
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ==================== SAFE WRAPPERS ====================
local function safeSetClipboard(text)
    if setclipboard then pcall(setclipboard, text)
    elseif toclipboard then pcall(toclipboard, text) end
end
local function safeReadFile(name)
    if readfile and isfile and isfile(name) then
        local ok, data = pcall(readfile, name)
        if ok then return data end
    end
    return nil
end
local function safeWriteFile(name, data)
    if writefile then pcall(writefile, name, data) end
end
local function safeNotify(title, text)
    if notify then pcall(notify, title, text) end
end

-- ==================== ANTI-AFK ====================
local antiAfkEnabled = false
local function enableAntiAfk()
    if antiAfkEnabled then return end
    local killed = false
    if getconnections then
        pcall(function()
            for _, v in pairs(getconnections(player.Idled)) do
                if v.Disable then v:Disable(); killed = true
                elseif v.Disconnect then v:Disconnect(); killed = true end
            end
        end)
    end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end)
    player.Idled:Connect(function()
        if not antiAfkEnabled then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end)
    end)
    task.spawn(function()
        while antiAfkEnabled do
            task.wait(300)
            if not antiAfkEnabled then break end
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(1), 0)
                end)
            end
        end
    end)
    antiAfkEnabled = true
    safeNotify("gamer owns yall", "Anti-AFK enabled")
    print("[Anti-AFK] Enabled (killed Idled: " .. tostring(killed) .. ")")
end
enableAntiAfk()

-- ==================== OVERHEAD ====================
local overheadGui = nil
local function createOverheadGui(character)
    if overheadGui then pcall(function() overheadGui:Destroy() end); overheadGui = nil end
    if not character then return end
    local head = character:FindFirstChild("Head") or character:WaitForChild("Head", 10)
    if not head then return end

    overheadGui = Instance.new("BillboardGui")
    overheadGui.Name = "GamerOwnsYall_Overhead"
    overheadGui.Size = UDim2.new(0, 200, 0, 50)
    overheadGui.StudsOffset = Vector3.new(0, 2.5, 0)
    overheadGui.AlwaysOnTop = true
    overheadGui.LightInfluence = 0
    overheadGui.Adornee = head
    overheadGui.Parent = head

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = BLACK
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = overheadGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

    local fStroke = Instance.new("UIStroke")
    fStroke.Color = GOLD; fStroke.Thickness = 1.5; fStroke.Transparency = 0.2
    fStroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 24)
    label.Position = UDim2.new(0, 5, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = "⚡ GAMER OWNS YALL"
    label.TextColor3 = WHITE
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.Parent = frame

    local labelGlow = Instance.new("UIStroke")
    labelGlow.Color = GOLD; labelGlow.Thickness = 1; labelGlow.Transparency = 0.4
    labelGlow.Parent = label

    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -10, 0, 14)
    subLabel.Position = UDim2.new(0, 5, 0, 26)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "v9.5 PREMIUM • " .. DISCORD
    subLabel.TextColor3 = GOLD_LIGHT
    subLabel.TextScaled = true
    subLabel.Font = Enum.Font.GothamMedium
    subLabel.Parent = frame

    task.spawn(function()
        while overheadGui and overheadGui.Parent do
            TweenService:Create(label, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = GOLD_LIGHT}):Play()
            task.wait(1.5)
            if not (overheadGui and overheadGui.Parent) then break end
            TweenService:Create(label, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = WHITE}):Play()
            task.wait(1.5)
        end
    end)
end
local function setupOverhead()
    createOverheadGui(player.Character)
    player.CharacterAdded:Connect(function(newChar)
        task.wait(1); createOverheadGui(newChar)
    end)
end
setupOverhead()

-- ==================== CLEAN OLD ====================
pcall(function() playerGui:FindFirstChild("GamerOwnsYall"):Destroy() end)

-- ==================== THEME REGISTRY ====================
local themedRegistry = {}
local function registerThemed(obj, prop, role)
    table.insert(themedRegistry, {obj=obj, prop=prop, role=role, kind="color"})
    return obj
end
local function registerGradient(grad)
    table.insert(themedRegistry, {obj=grad, prop="Color", role=nil, kind="gradient"})
    return grad
end

-- ==================== PING / FPS ====================
local currentFps  = 60
local currentPing = 0
local colorForFps, colorForPing

do
    colorForFps = function(fps)
        if fps >= 50 then return GREEN end
        if fps >= 30 then return YELLOW end
        return RED
    end
    colorForPing = function(ping)
        if ping < 80 then return GREEN end
        if ping < 150 then return YELLOW end
        return RED
    end

    local frameCount, lastSample = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        frameCount += 1
        local now = os.clock()
        if now - lastSample >= 1 then
            currentFps = math.floor(frameCount / (now - lastSample))
            frameCount = 0
            lastSample = now
        end
    end)

    local function getPing()
        local ok, p = pcall(function() return player:GetNetworkPing() end)
        if ok and type(p) == "number" and p > 0 then
            return math.floor(p * 1000)
        end
        local ok2, val = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok2 and type(val) == "number" then
            return math.floor(val)
        end
        return 0
    end
    task.spawn(function()
        while true do
            task.wait(2)
            currentPing = getPing()
        end
    end)
end

-- ==================== GUI ROOT ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GamerOwnsYall"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- ==================== DIMENSIONS ====================
local FRAME_W  = isMobile and 260 or 330
local FRAME_H  = isMobile and 500 or 555
local HEADER_H = isMobile and 48 or 58

local FULL_SIZE   = UDim2.new(0, FRAME_W, 0, FRAME_H)
local FULL_POS    = UDim2.new(0.5, -FRAME_W/2, 0.5, -FRAME_H/2)
local MINI_SIZE   = UDim2.new(0, FRAME_W, 0, HEADER_H)
local SHADOW_SIZE = UDim2.new(0, FRAME_W + 8, 0, FRAME_H + 8)
local SHADOW_POS  = UDim2.new(0.5, -(FRAME_W + 8)/2, 0.5, -(FRAME_H + 8)/2)

local Y_STATS      = 4
local Y_SECTION_1  = isMobile and 28  or 32
local Y_SCROLL     = isMobile and 46  or 52
local SCROLL_H     = isMobile and 148 or 175
local Y_SECTION_2  = isMobile and 198 or 232
local Y_NAMEBOX    = isMobile and 216 or 254
local Y_CLEAR      = isMobile and 252 or 292
local Y_SECTION_3  = isMobile and 280 or 322
local Y_AUTO       = isMobile and 298 or 344
local Y_SECTION_4  = isMobile and 340 or 396
local Y_SWATCH     = isMobile and 358 or 418
local Y_CURPOS     = isMobile and 396 or 460

-- ==================== SHADOW ====================
local shadow = Instance.new("Frame")
shadow.Size = SHADOW_SIZE
shadow.Position = SHADOW_POS
shadow.BackgroundColor3 = Color3.new(0,0,0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.Parent = screenGui
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 18)

-- ==================== MAIN FRAME ====================
local mainFrame = Instance.new("Frame")
mainFrame.Size = FULL_SIZE
mainFrame.Position = FULL_POS
mainFrame.BackgroundColor3 = BLACK
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = GOLD
mainStroke.Thickness = 2
mainStroke.Transparency = 0.1
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame
registerThemed(mainStroke, "Color", "primary")

local strokeGrad = Instance.new("UIGradient")
strokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_NEON),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
strokeGrad.Parent = mainStroke
registerGradient(strokeGrad)

local bgImage = Instance.new("ImageLabel")
bgImage.Size = UDim2.new(1,0,1,0)
bgImage.BackgroundTransparency = 1
bgImage.Image = LOGO_ID
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.15
bgImage.ZIndex = 0
bgImage.Parent = mainFrame

local bgBase = Instance.new("Frame")
bgBase.Size = UDim2.new(1,0,1,0)
bgBase.BackgroundColor3 = BLACK
bgBase.BorderSizePixel = 0
bgBase.ZIndex = 1
bgBase.Parent = mainFrame
Instance.new("UICorner", bgBase).CornerRadius = UDim.new(0,16)
local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22,20,12)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(12,12,14)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8,8,10)),
})
bgGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.35),
    NumberSequenceKeypoint.new(1, 0.65),
})
bgGrad.Rotation = 125
bgGrad.Parent = bgBase

local aurora1 = Instance.new("Frame")
aurora1.Size = UDim2.new(0, 180, 0, 180)
aurora1.Position = UDim2.new(0, -40, 0, -40)
aurora1.BackgroundColor3 = GOLD
aurora1.BackgroundTransparency = 0.85
aurora1.BorderSizePixel = 0
aurora1.ZIndex = 2
aurora1.Parent = mainFrame
Instance.new("UICorner", aurora1).CornerRadius = UDim.new(1,0)
registerThemed(aurora1, "BackgroundColor3", "primary")

local blur1 = Instance.new("UIStroke")
blur1.Thickness = 40
blur1.Color = GOLD
blur1.Transparency = 0.8
blur1.Parent = aurora1
registerThemed(blur1, "Color", "primary")

local aurora2 = Instance.new("Frame")
aurora2.Size = UDim2.new(0, 220, 0, 220)
aurora2.Position = UDim2.new(1, -140, 1, -140)
aurora2.BackgroundColor3 = GOLD_DARK
aurora2.BackgroundTransparency = 0.88
aurora2.BorderSizePixel = 0
aurora2.ZIndex = 2
aurora2.Parent = mainFrame
Instance.new("UICorner", aurora2).CornerRadius = UDim.new(1,0)
registerThemed(aurora2, "BackgroundColor3", "dark")

local vignette = Instance.new("Frame")
vignette.Size = UDim2.new(1,0,1,0)
vignette.BackgroundColor3 = Color3.new(0,0,0)
vignette.BorderSizePixel = 0
vignette.ZIndex = 3
vignette.Parent = mainFrame
Instance.new("UICorner", vignette).CornerRadius = UDim.new(0,16)
local vigGrad = Instance.new("UIGradient")
vigGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.7),
    NumberSequenceKeypoint.new(1, 0),
})
vigGrad.Rotation = 90
vigGrad.Parent = vignette

local particleHolder = Instance.new("Frame")
particleHolder.Size = UDim2.new(1,0,1,0)
particleHolder.BackgroundTransparency = 1
particleHolder.ZIndex = 4
particleHolder.ClipsDescendants = true
particleHolder.Parent = mainFrame

local particleList = {}
for i=1,10 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, math.random(2,4), 0, math.random(2,4))
    p.Position = UDim2.new(math.random(),0, math.random(),0)
    p.BackgroundColor3 = (i%2==0) and GOLD_LIGHT or GOLD
    p.BackgroundTransparency = math.random(30,70)/100
    p.BorderSizePixel = 0
    p.ZIndex = 4
    p.Parent = particleHolder
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
    table.insert(particleList, {frame=p, role=(i%2==0) and "light" or "primary"})
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

task.spawn(function()
    local t = 0
    local conn
    conn = RunService.RenderStepped:Connect(function(dt)
        if not mainFrame.Parent then conn:Disconnect(); return end
        t += dt
        strokeGrad.Rotation = (t*20) % 360
        aurora1.Position = UDim2.new(0, -40 + math.sin(t*0.5)*20, 0, -40 + math.cos(t*0.4)*20)
        aurora2.Position = UDim2.new(1, -160 + math.sin(t*0.3)*25, 1, -160 + math.cos(t*0.6)*25)
        bgGrad.Rotation = 125 + math.sin(t*0.2)*15
    end)
end)

-- ==================== HEADER ====================
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.BackgroundColor3 = BLACK_3
header.BorderSizePixel = 0
header.ZIndex = 10
header.Parent = mainFrame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

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
headerGradient.Parent = header

local headerStroke = Instance.new("UIStroke")
headerStroke.Color = GOLD; headerStroke.Thickness = 1; headerStroke.Transparency = 0.7
headerStroke.Parent = header
registerThemed(headerStroke, "Color", "primary")

local neonLine = Instance.new("Frame")
neonLine.Size = UDim2.new(1,0,0,2)
neonLine.BackgroundColor3 = GOLD
neonLine.BorderSizePixel = 0
neonLine.ZIndex = 11
neonLine.Parent = header
registerThemed(neonLine, "BackgroundColor3", "primary")
local neonGrad = Instance.new("UIGradient")
neonGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_NEON),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
neonGrad.Parent = neonLine
registerGradient(neonGrad)

local headerLogo = Instance.new("ImageLabel")
headerLogo.Size = UDim2.new(0, isMobile and 28 or 32, 0, isMobile and 28 or 32)
headerLogo.Position = UDim2.new(0, 8, 0, (HEADER_H - (isMobile and 28 or 32))/2)
headerLogo.BackgroundTransparency = 1
headerLogo.Image = LOGO_ID
headerLogo.ScaleType = Enum.ScaleType.Fit
headerLogo.ZIndex = 11
headerLogo.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -140, 0, isMobile and 20 or 24)
title.Position = UDim2.new(0, isMobile and 42 or 46, 0, isMobile and 4 or 6)
title.BackgroundTransparency = 1
title.Text = "⚡ GAMER OWNS YALL"
title.TextColor3 = WHITE
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 11
title.Parent = header
local titleGlow = Instance.new("UIStroke")
titleGlow.Color = GOLD; titleGlow.Thickness = 0.8; titleGlow.Transparency = 0.6
titleGlow.Parent = title
registerThemed(titleGlow, "Color", "primary")

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -140, 0, 12)
subtitle.Position = UDim2.new(0, isMobile and 42 or 46, 0, isMobile and 26 or 32)
subtitle.BackgroundTransparency = 1
subtitle.Text = "✦ " .. THEMES[currentThemeName].name .. " • v9.5 • " .. DISCORD
subtitle.TextColor3 = GOLD_LIGHT
subtitle.TextScaled = true
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 11
subtitle.Parent = header
registerThemed(subtitle, "TextColor3", "light")

local function makeHeaderBtn(pos, text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, isMobile and 20 or 22, 0, isMobile and 20 or 22)
    btn.Position = pos
    btn.BackgroundColor3 = BLACK_4
    btn.Text = text
    btn.TextColor3 = WHITE
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 12
    btn.Parent = header
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke")
    s.Color = color or GOLD_DARK
    s.Thickness = 1; s.Transparency = 0.5
    s.Parent = btn
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color or GOLD}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = BLACK_4}):Play()
    end)
    return btn, s
end

local minimizeBtn = makeHeaderBtn(UDim2.new(1, isMobile and -50 or -54, 0, isMobile and 4 or 5), "−", GOLD_DARK)
local closeBtn, closeStroke = makeHeaderBtn(UDim2.new(1, isMobile and -26 or -28, 0, isMobile and 4 or 5), "✕", RED)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0),
        Position = UDim2.new(0.5,0,0.5,0)
    }):Play()
    task.wait(0.25)
    mainFrame.Visible = false
    shadow.Visible = false
    mainFrame.Size = FULL_SIZE
    mainFrame.Position = FULL_POS
    miniStats.Visible = true
end)

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
                mainFrame.Position.X.Scale, mainFrame.Position.X.Offset - 4,
                mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset - 4)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- ==================== CONTENT ====================
local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -HEADER_H)
content.Position = UDim2.new(0, 0, 0, HEADER_H)
content.BackgroundTransparency = 1
content.ZIndex = 5
content.Parent = mainFrame

local isMinimized = false
local function setMinimized(state)
    isMinimized = state
    content.Visible = not state
    shadow.Visible = (not state) and mainFrame.Visible
    minimizeBtn.Text = state and "+" or "−"
    TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = state and MINI_SIZE or FULL_SIZE
    }):Play()
end
minimizeBtn.MouseButton1Click:Connect(function()
    setMinimized(not isMinimized)
end)

-- ==================== STATS BAR ====================
local statsBar = Instance.new("Frame")
statsBar.Size = UDim2.new(1, -16, 0, 20)
statsBar.Position = UDim2.new(0, 8, 0, Y_STATS)
statsBar.BackgroundColor3 = BLACK_2
statsBar.BackgroundTransparency = 0.3
statsBar.BorderSizePixel = 0
statsBar.ZIndex = 6
statsBar.Parent = content
Instance.new("UICorner", statsBar).CornerRadius = UDim.new(0, 6)
local stStroke = Instance.new("UIStroke")
stStroke.Color = GOLD_DARK; stStroke.Thickness = 1; stStroke.Transparency = 0.65
stStroke.Parent = statsBar
registerThemed(stStroke, "Color", "dark")

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0.5, -6, 1, 0)
fpsLabel.Position = UDim2.new(0, 6, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = GREEN
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.ZIndex = 7
fpsLabel.Parent = statsBar

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.5, -6, 1, 0)
pingLabel.Position = UDim2.new(0.5, 2, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "PING: --ms"
pingLabel.TextColor3 = GREEN
pingLabel.TextScaled = true
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextXAlignment = Enum.TextXAlignment.Right
pingLabel.ZIndex = 7
pingLabel.Parent = statsBar

local function makeSectionLabel(text, yPos, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -16, 0, 14)
    lbl.Position = UDim2.new(0, 8, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = GOLD_LIGHT
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 6
    lbl.Parent = parent
    registerThemed(lbl, "TextColor3", "light")
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 3, 0, 11)
    line.Position = UDim2.new(0, -5, 0.5, -5.5)
    line.BackgroundColor3 = GOLD
    line.BorderSizePixel = 0
    line.Parent = lbl
    Instance.new("UICorner", line).CornerRadius = UDim.new(0,2)
    registerThemed(line, "BackgroundColor3", "primary")
    return lbl
end

-- ==================== TELEPORT SYSTEM (UNTOUCHED FROM v9) ====================
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

-- ==================== SAVED LOCATIONS ====================
local DEFAULT_LOCATIONS = {
    {name = "⭐ BEST WORLD",   pos = Vector3.new(2074.9, 18.9, 7562.0)},
    {name = "🏆 W4 Win Pad",   pos = Vector3.new(1770, 5.24, 1220)},
    {name = "⛏️ W4 Blocks",    pos = Vector3.new(1678.07, 5.24, 1247.45)},
}

local savedLocations = {}
local loadedFromFile = false

local fileData = safeReadFile("pickaxe_tp.json")
if fileData then
    pcall(function()
        local data = HttpService:JSONDecode(fileData)
        for _, entry in ipairs(data) do
            table.insert(savedLocations, {
                name = entry.name,
                pos  = Vector3.new(entry.x, entry.y, entry.z),
            })
        end
        loadedFromFile = true
    end)
end
if not loadedFromFile then
    for _, d in ipairs(DEFAULT_LOCATIONS) do
        table.insert(savedLocations, { name = d.name, pos = d.pos })
    end
end

local function saveToFile()
    pcall(function()
        local out = {}
        for _, loc in ipairs(savedLocations) do
            table.insert(out, {name=loc.name, x=loc.pos.X, y=loc.pos.Y, z=loc.pos.Z})
        end
        safeWriteFile("pickaxe_tp.json", HttpService:JSONEncode(out))
    end)
end

local autoEnabled = false
local autoThread  = nil
local stopAuto
local startAuto

makeSectionLabel("📍 SAVED LOCATIONS", Y_SECTION_1, content)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 0, SCROLL_H)
scrollFrame.Position = UDim2.new(0, 8, 0, Y_SCROLL)
scrollFrame.BackgroundColor3 = BLACK_2
scrollFrame.BackgroundTransparency = 0.2
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #savedLocations * 52 + 8)
scrollFrame.ScrollBarThickness = isMobile and 5 or 3
scrollFrame.ScrollBarImageColor3 = GOLD
scrollFrame.ZIndex = 6
scrollFrame.Parent = content
registerThemed(scrollFrame, "ScrollBarImageColor3", "primary")
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 8)

local sfStroke = Instance.new("UIStroke")
sfStroke.Color = GOLD_DARK; sfStroke.Thickness = 1; sfStroke.Transparency = 0.6
sfStroke.Parent = scrollFrame
registerThemed(sfStroke, "Color", "dark")

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

local sfPad = Instance.new("UIPadding")
sfPad.PaddingTop    = UDim.new(0, 5)
sfPad.PaddingLeft   = UDim.new(0, 5)
sfPad.PaddingRight  = UDim.new(0, 5)
sfPad.PaddingBottom = UDim.new(0, 5)
sfPad.Parent = scrollFrame

local selectedIndex = nil
local rowButtons = {}

local function formatCoords(pos)
    return string.format("X %.1f  Y %.1f  Z %.1f", pos.X, pos.Y, pos.Z)
end

local function refreshList()
    for _, btn in ipairs(rowButtons) do btn:Destroy() end
    rowButtons = {}
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #savedLocations * 52 + 8)

    if selectedIndex and selectedIndex > #savedLocations then
        selectedIndex = nil
    end

    for i, loc in ipairs(savedLocations) do
        local isSelected = (selectedIndex == i)
        local ROW_H = 46

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -4, 0, ROW_H)
        row.BackgroundColor3 = isSelected and Color3.fromRGB(45, 38, 18) or BLACK_3
        row.BackgroundTransparency = isSelected and 0.1 or 0.3
        row.LayoutOrder = i
        row.ZIndex = 7
        row.Parent = scrollFrame

        local rc = Instance.new("UICorner")
        rc.CornerRadius = UDim.new(0, 8)
        rc.Parent = row

        local rStroke = Instance.new("UIStroke")
        rStroke.Color = isSelected and GOLD_NEON or GOLD_DARK
        rStroke.Thickness = isSelected and 1.5 or 1
        rStroke.Transparency = isSelected and 0.1 or 0.65
        rStroke.Parent = row

        local leftCol = Instance.new("Frame")
        leftCol.Size = UDim2.new(0.56, 0, 1, 0)
        leftCol.BackgroundTransparency = 1
        leftCol.ZIndex = 8
        leftCol.Parent = row

        local nameBtn = Instance.new("TextButton")
        nameBtn.Size = UDim2.new(1, -6, 0.5, 0)
        nameBtn.Position = UDim2.new(0, 6, 0, 2)
        nameBtn.BackgroundTransparency = 1
        nameBtn.Text = loc.name
        nameBtn.TextColor3 = isSelected and GOLD_LIGHT or WHITE
        nameBtn.TextScaled = true
        nameBtn.Font = Enum.Font.GothamBold
        nameBtn.TextXAlignment = Enum.TextXAlignment.Left
        nameBtn.ZIndex = 8
        nameBtn.Parent = leftCol

        local coordsLbl = Instance.new("TextLabel")
        coordsLbl.Size = UDim2.new(1, -6, 0.5, 0)
        coordsLbl.Position = UDim2.new(0, 6, 0.5, -2)
        coordsLbl.BackgroundTransparency = 1
        coordsLbl.Text = formatCoords(loc.pos)
        coordsLbl.TextColor3 = isSelected and GOLD_NEON or GOLD_DARK
        coordsLbl.TextScaled = true
        coordsLbl.Font = Enum.Font.Code
        coordsLbl.TextXAlignment = Enum.TextXAlignment.Left
        coordsLbl.ZIndex = 8
        coordsLbl.Parent = leftCol

        local selW = isMobile and 0.22 or 0.2
        local selH = isMobile and 22 or 24
        local selectBtn = Instance.new("TextButton")
        selectBtn.Size = UDim2.new(selW, 0, 0, selH)
        selectBtn.Position = UDim2.new(1 - selW - (isMobile and 0.16 or 0.15), 0, 0, (ROW_H - selH)/2)
        selectBtn.BackgroundColor3 = isSelected and GOLD or BLACK_4
        selectBtn.Text = isSelected and "✔" or "GO"
        selectBtn.TextColor3 = isSelected and BLACK or WHITE
        selectBtn.TextScaled = true
        selectBtn.Font = Enum.Font.GothamBold
        selectBtn.ZIndex = 8
        selectBtn.Parent = row
        Instance.new("UICorner", selectBtn).CornerRadius = UDim.new(0, 6)

        local delSize = isMobile and 22 or 24
        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.new(0, delSize, 0, delSize)
        deleteBtn.Position = UDim2.new(1, -(delSize+4), 0, (ROW_H-delSize)/2)
        deleteBtn.BackgroundColor3 = BLACK_4
        deleteBtn.Text = "✕"
        deleteBtn.TextColor3 = WHITE
        deleteBtn.TextScaled = true
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.ZIndex = 8
        deleteBtn.Parent = row
        Instance.new("UICorner", deleteBtn).CornerRadius = UDim.new(0, 6)
        local dStroke = Instance.new("UIStroke")
        dStroke.Color = RED; dStroke.Thickness = 1; dStroke.Transparency = 0.6
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
makeSectionLabel("💾 SAVE CURRENT POSITION", Y_SECTION_2, content)

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.60, 0, 0, 30)
nameBox.Position = UDim2.new(0, 8, 0, Y_NAMEBOX)
nameBox.BackgroundColor3 = BLACK_3
nameBox.PlaceholderText = "Name this spot..."
nameBox.PlaceholderColor3 = Color3.fromRGB(130,130,130)
nameBox.Text = ""
nameBox.TextColor3 = WHITE
nameBox.TextScaled = true
nameBox.Font = Enum.Font.GothamMedium
nameBox.ZIndex = 6
nameBox.Parent = content
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 8)
local nbStroke = Instance.new("UIStroke")
nbStroke.Color = GOLD_DARK; nbStroke.Thickness = 1; nbStroke.Transparency = 0.5
nbStroke.Parent = nameBox
registerThemed(nbStroke, "Color", "dark")

nameBox.Focused:Connect(function()
    TweenService:Create(nbStroke, TweenInfo.new(0.2), {Color = GOLD_LIGHT, Transparency = 0}):Play()
end)
nameBox.FocusLost:Connect(function()
    TweenService:Create(nbStroke, TweenInfo.new(0.2), {Color = GOLD_DARK, Transparency = 0.5}):Play()
end)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.32, 0, 0, 30)
saveBtn.Position = UDim2.new(0.66, 0, 0, Y_NAMEBOX)
saveBtn.BackgroundColor3 = GOLD
saveBtn.Text = "➕ SAVE"
saveBtn.TextColor3 = BLACK
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.GothamBlack
saveBtn.ZIndex = 6
saveBtn.Parent = content
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
registerThemed(saveBtn, "BackgroundColor3", "primary")

saveBtn.MouseEnter:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = GOLD_LIGHT}):Play()
end)
saveBtn.MouseLeave:Connect(function()
    TweenService:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = GOLD}):Play()
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
clearAllBtn.Size = UDim2.new(1, -16, 0, 22)
clearAllBtn.Position = UDim2.new(0, 8, 0, Y_CLEAR)
clearAllBtn.BackgroundColor3 = BLACK_3
clearAllBtn.BackgroundTransparency = 0.3
clearAllBtn.Text = "🗑️ CLEAR ALL SAVED CONFIGS"
clearAllBtn.TextColor3 = Color3.fromRGB(200,200,200)
clearAllBtn.TextScaled = true
clearAllBtn.Font = Enum.Font.GothamBold
clearAllBtn.ZIndex = 6
clearAllBtn.Parent = content
Instance.new("UICorner", clearAllBtn).CornerRadius = UDim.new(0, 6)
local caStroke = Instance.new("UIStroke")
caStroke.Color = RED; caStroke.Thickness = 1; caStroke.Transparency = 0.6
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

-- ==================== AUTO-TELEPORT (UNTOUCHED FROM v9) ====================
makeSectionLabel("🔁 AUTO-TELEPORT", Y_SECTION_3, content)

local autoBtn = Instance.new("TextButton")
autoBtn.Size = UDim2.new(0.60, 0, 0, 34)
autoBtn.Position = UDim2.new(0, 8, 0, Y_AUTO)
autoBtn.BackgroundColor3 = BLACK_3
autoBtn.Text = "AUTO TP: OFF"
autoBtn.TextColor3 = WHITE
autoBtn.TextScaled = true
autoBtn.Font = Enum.Font.GothamBlack
autoBtn.ZIndex = 6
autoBtn.Parent = content
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

local abStroke = Instance.new("UIStroke")
abStroke.Color = GOLD_DARK
abStroke.Thickness = 1.2
abStroke.Transparency = 0.4
abStroke.Parent = autoBtn

local intervalBox = Instance.new("TextBox")
intervalBox.Size = UDim2.new(0.30, 0, 0, 34)
intervalBox.Position = UDim2.new(0.66, 0, 0, Y_AUTO)
intervalBox.BackgroundColor3 = BLACK_3
intervalBox.Text = "1s"
intervalBox.TextColor3 = WHITE
intervalBox.TextScaled = true
intervalBox.Font = Enum.Font.GothamBold
intervalBox.PlaceholderText = "1s"
intervalBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
intervalBox.ZIndex = 6
intervalBox.Parent = content
Instance.new("UICorner", intervalBox).CornerRadius = UDim.new(0, 8)

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
    autoBtn.TextSize = 11
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

-- ==================== THEME PICKER ====================
makeSectionLabel("🎨 THEME", Y_SECTION_4, content)

local swatchRow = Instance.new("Frame")
swatchRow.Size = UDim2.new(1, -16, 0, isMobile and 32 or 36)
swatchRow.Position = UDim2.new(0, 8, 0, Y_SWATCH)
swatchRow.BackgroundColor3 = BLACK_2
swatchRow.BackgroundTransparency = 0.3
swatchRow.BorderSizePixel = 0
swatchRow.ZIndex = 6
swatchRow.Parent = content
Instance.new("UICorner", swatchRow).CornerRadius = UDim.new(0, 8)
local swStroke = Instance.new("UIStroke")
swStroke.Color = GOLD_DARK; swStroke.Thickness = 1; swStroke.Transparency = 0.65
swStroke.Parent = swatchRow
registerThemed(swStroke, "Color", "dark")

local swLayout = Instance.new("UIListLayout")
swLayout.FillDirection = Enum.FillDirection.Horizontal
swLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
swLayout.VerticalAlignment = Enum.VerticalAlignment.Center
swLayout.Padding = UDim.new(0, isMobile and 4 or 5)
swLayout.Parent = swatchRow

local swatches = {}
local swatchSize = isMobile and 24 or 28

local function refreshSwatches()
    for _, s in ipairs(swatches) do
        local isActive = (s.key == currentThemeName)
        s.button.Text = isActive and "✓" or ""
        s.stroke.Color = isActive and s.themeDef.neon or s.themeDef.dark
        s.stroke.Thickness = isActive and 2 or 1
        s.stroke.Transparency = isActive and 0 or 0.35
    end
end

for _, key in ipairs(themeOrder) do
    local themeDef = THEMES[key]
    local isActive = (key == currentThemeName)

    local swatch = Instance.new("TextButton")
    swatch.Size = UDim2.new(0, swatchSize, 0, swatchSize)
    swatch.BackgroundColor3 = themeDef.primary
    swatch.Text = isActive and "✓" or ""
    swatch.TextColor3 = BLACK
    swatch.TextScaled = true
    swatch.Font = Enum.Font.GothamBlack
    swatch.ZIndex = 7
    swatch.Parent = swatchRow
    Instance.new("UICorner", swatch).CornerRadius = UDim.new(1,0)

    local sStroke = Instance.new("UIStroke")
    sStroke.Color = isActive and themeDef.neon or themeDef.dark
    sStroke.Thickness = isActive and 2 or 1
    sStroke.Transparency = isActive and 0 or 0.35
    sStroke.Parent = swatch

    table.insert(swatches, {key=key, button=swatch, stroke=sStroke, themeDef=themeDef})

    swatch.MouseButton1Click:Connect(function()
        if currentThemeName == key then return end
        applyThemeVars(key)
        for _, entry in ipairs(themedRegistry) do
            if entry.kind == "gradient" then
                entry.obj.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, GOLD_DARK),
                    ColorSequenceKeypoint.new(0.5, GOLD_NEON),
                    ColorSequenceKeypoint.new(1, GOLD_DARK),
                })
            else
                local c
                if entry.role == "primary" then c = GOLD
                elseif entry.role == "dark" then c = GOLD_DARK
                elseif entry.role == "light" then c = GOLD_LIGHT
                elseif entry.role == "neon" then c = GOLD_NEON
                else c = entry.obj[entry.prop] end
                entry.obj[entry.prop] = c
            end
        end
        for _, p in ipairs(particleList) do
            p.frame.BackgroundColor3 = (p.role == "light") and GOLD_LIGHT or GOLD
        end
        refreshList()
        if player.Character then createOverheadGui(player.Character) end
        subtitle.Text = "✦ " .. THEMES[currentThemeName].name .. " • v9.5 • " .. DISCORD
        refreshSwatches()
    end)

    swatch.MouseEnter:Connect(function()
        if currentThemeName ~= key then
            TweenService:Create(swatch, TweenInfo.new(0.12), {Size = UDim2.new(0, swatchSize+3, 0, swatchSize+3)}):Play()
        end
    end)
    swatch.MouseLeave:Connect(function()
        TweenService:Create(swatch, TweenInfo.new(0.12), {Size = UDim2.new(0, swatchSize, 0, swatchSize)}):Play()
    end)
end

-- ==================== LIVE CURRENT POSITION ====================
local currentPosBar = Instance.new("Frame")
currentPosBar.Size = UDim2.new(1, -16, 0, 20)
currentPosBar.Position = UDim2.new(0, 8, 0, Y_CURPOS)
currentPosBar.BackgroundColor3 = BLACK_2
currentPosBar.BackgroundTransparency = 0.25
currentPosBar.BorderSizePixel = 0
currentPosBar.ZIndex = 6
currentPosBar.Parent = content
Instance.new("UICorner", currentPosBar).CornerRadius = UDim.new(0, 6)
local cpStroke = Instance.new("UIStroke")
cpStroke.Color = GOLD_DARK; cpStroke.Thickness = 1; cpStroke.Transparency = 0.65
cpStroke.Parent = currentPosBar
registerThemed(cpStroke, "Color", "dark")

local currentPosLbl = Instance.new("TextLabel")
currentPosLbl.Size = UDim2.new(1, -10, 1, 0)
currentPosLbl.Position = UDim2.new(0, 5, 0, 0)
currentPosLbl.BackgroundTransparency = 1
currentPosLbl.Text = "YOU  X 0.0   Y 0.0   Z 0.0"
currentPosLbl.TextColor3 = GOLD_LIGHT
currentPosLbl.TextScaled = true
currentPosLbl.Font = Enum.Font.Code
currentPosLbl.TextXAlignment = Enum.TextXAlignment.Center
currentPosLbl.ZIndex = 7
currentPosLbl.Parent = currentPosBar
registerThemed(currentPosLbl, "TextColor3", "light")

-- ==================== FOOTER ====================
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -16, 0, 12)
footer.Position = UDim2.new(0, 8, 1, -14)
footer.BackgroundTransparency = 1
footer.Text = "made by gamer owns yall • v9.5"
footer.TextColor3 = Color3.fromRGB(110,110,110)
footer.TextScaled = true
footer.Font = Enum.Font.Gotham
footer.ZIndex = 6
footer.Parent = content

-- ==================== TOGGLE BUTTON ====================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 48, 0, 48)
toggleBtn.Position = UDim2.new(0, 12, 0.5, -24)
toggleBtn.BackgroundColor3 = BLACK
toggleBtn.Text = "⚡"
toggleBtn.TextColor3 = GOLD_LIGHT
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.ZIndex = 15
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 24)
local tbStroke = Instance.new("UIStroke")
tbStroke.Color = GOLD; tbStroke.Thickness = 2; tbStroke.Transparency = 0.1
tbStroke.Parent = toggleBtn
registerThemed(tbStroke, "Color", "primary")
registerThemed(toggleBtn, "TextColor3", "light")
local tbGrad = Instance.new("UIGradient")
tbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_LIGHT),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
tbGrad.Parent = tbStroke
registerGradient(tbGrad)

toggleBtn.MouseEnter:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = GOLD, TextColor3 = BLACK}):Play()
end)
toggleBtn.MouseLeave:Connect(function()
    TweenService:Create(toggleBtn, TweenInfo.new(0.15), {BackgroundColor3 = BLACK, TextColor3 = GOLD_LIGHT}):Play()
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
            if math.abs(delta.X) + math.abs(delta.Y) > 8 then
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
        miniStats.Visible = not open
        if open then
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = isMinimized and MINI_SIZE or FULL_SIZE,
                Position = FULL_POS,
            }):Play()
        end
    end)
end

-- ==================== MUSIC TOGGLE BUTTON ====================
local musicToggle = Instance.new("TextButton")
musicToggle.Size = UDim2.new(0, 48, 0, 48)
musicToggle.Position = UDim2.new(0, 12, 0.5, 32)
musicToggle.BackgroundColor3 = BLACK
musicToggle.Text = "♪"
musicToggle.TextColor3 = GOLD_LIGHT
musicToggle.TextScaled = true
musicToggle.Font = Enum.Font.GothamBlack
musicToggle.ZIndex = 15
musicToggle.Parent = screenGui
Instance.new("UICorner", musicToggle).CornerRadius = UDim.new(0, 24)
local mtnStroke = Instance.new("UIStroke")
mtnStroke.Color = GOLD; mtnStroke.Thickness = 2; mtnStroke.Transparency = 0.1
mtnStroke.Parent = musicToggle
registerThemed(mtnStroke, "Color", "primary")
registerThemed(musicToggle, "TextColor3", "light")
local mtnGrad = Instance.new("UIGradient")
mtnGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_LIGHT),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
mtnGrad.Parent = mtnStroke
registerGradient(mtnGrad)

musicToggle.MouseEnter:Connect(function()
    TweenService:Create(musicToggle, TweenInfo.new(0.15), {BackgroundColor3 = GOLD, TextColor3 = BLACK}):Play()
end)
musicToggle.MouseLeave:Connect(function()
    TweenService:Create(musicToggle, TweenInfo.new(0.15), {BackgroundColor3 = BLACK, TextColor3 = GOLD_LIGHT}):Play()
end)

do
    local dragging, dragMoved = false, false
    local dragStart, startPos
    musicToggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragMoved = true, false
            dragStart = input.Position
            startPos  = musicToggle.Position
        end
    end)
    musicToggle.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) + math.abs(delta.Y) > 8 then
                dragMoved = true
            end
            musicToggle.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    musicToggle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    musicToggle.MouseButton1Click:Connect(function()
        if dragMoved then return end
        if _G.gamerMusic then
            _G.gamerMusic.ToggleUI()
        end
    end)
end

-- ==================== PERSISTENT MINI HUD ====================
local miniStats = Instance.new("Frame")
miniStats.Name = "MiniStats"
miniStats.Size = UDim2.new(0, 150, 0, 26)
miniStats.Position = UDim2.new(0.5, -75, 0, 8)
miniStats.BackgroundColor3 = BLACK
miniStats.BackgroundTransparency = 0.15
miniStats.BorderSizePixel = 0
miniStats.ZIndex = 20
miniStats.Visible = false
miniStats.Parent = screenGui
Instance.new("UICorner", miniStats).CornerRadius = UDim.new(0, 13)

local msStroke = Instance.new("UIStroke")
msStroke.Color = GOLD; msStroke.Thickness = 1.5; msStroke.Transparency = 0.15
msStroke.Parent = miniStats
registerThemed(msStroke, "Color", "primary")
local msGrad = Instance.new("UIGradient")
msGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, GOLD_DARK),
    ColorSequenceKeypoint.new(0.5, GOLD_NEON),
    ColorSequenceKeypoint.new(1, GOLD_DARK),
})
msGrad.Parent = msStroke
registerGradient(msGrad)

local miniFps = Instance.new("TextLabel")
miniFps.Size = UDim2.new(0.5, -4, 1, 0)
miniFps.Position = UDim2.new(0, 8, 0, 0)
miniFps.BackgroundTransparency = 1
miniFps.Text = "60 FPS"
miniFps.TextColor3 = GREEN
miniFps.TextScaled = true
miniFps.Font = Enum.Font.GothamBold
miniFps.TextXAlignment = Enum.TextXAlignment.Left
miniFps.ZIndex = 21
miniFps.Parent = miniStats

local miniPing = Instance.new("TextLabel")
miniPing.Size = UDim2.new(0.5, -4, 1, 0)
miniPing.Position = UDim2.new(0.5, -4, 0, 0)
miniPing.BackgroundTransparency = 1
miniPing.Text = "0 ms"
miniPing.TextColor3 = GREEN
miniPing.TextScaled = true
miniPing.Font = Enum.Font.GothamBold
miniPing.TextXAlignment = Enum.TextXAlignment.Right
miniPing.ZIndex = 21
miniPing.Parent = miniStats

do
    local mdragging, mdragStart, mstartPos = false, nil, nil
    miniStats.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            mdragging = true
            mdragStart = input.Position
            mstartPos = miniStats.Position
        end
    end)
    miniStats.InputChanged:Connect(function(input)
        if not mdragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - mdragStart
            miniStats.Position = UDim2.new(
                mstartPos.X.Scale, mstartPos.X.Offset + delta.X,
                mstartPos.Y.Scale, mstartPos.Y.Offset + delta.Y)
        end
    end)
    miniStats.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            mdragging = false
        end
    end)
end

-- ==================== UI REFRESH LOOP ====================
task.spawn(function()
    while true do
        task.wait(0.5)
        if fpsLabel and fpsLabel.Parent then
            fpsLabel.Text = "FPS: " .. currentFps
            fpsLabel.TextColor3 = colorForFps(currentFps)
        end
        if pingLabel and pingLabel.Parent then
            pingLabel.Text = "PING: " .. currentPing .. "ms"
            pingLabel.TextColor3 = colorForPing(currentPing)
        end
        if miniFps and miniFps.Parent then
            miniFps.Text = currentFps .. " FPS"
            miniFps.TextColor3 = colorForFps(currentFps)
        end
        if miniPing and miniPing.Parent then
            miniPing.Text = currentPing .. " ms"
            miniPing.TextColor3 = colorForPing(currentPing)
        end
        if currentPosLbl and currentPosLbl.Parent then
            local hrp = getHRP()
            if hrp then
                local p = hrp.Position
                currentPosLbl.Text = string.format("YOU  X %.1f   Y %.1f   Z %.1f", p.X, p.Y, p.Z)
            else
                currentPosLbl.Text = "YOU  --"
            end
        end
    end
end)

-- ==================== INITIAL LIST ====================
refreshList()

-- ==================== ENTRANCE ANIMATION ====================
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(0,0,0,0)
shadow.Position = UDim2.new(0.5,0,0.5,0)

TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = FULL_SIZE,
    Position = FULL_POS,
}):Play()
TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = SHADOW_SIZE,
    Position = SHADOW_POS,
}):Play()

task.delay(0.5, function()
    while neonLine.Parent do
        TweenService:Create(neonLine, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.3}):Play()
        task.wait(1.5)
        if not neonLine.Parent then break end
        TweenService:Create(neonLine, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
        task.wait(1.5)
    end
end)

print("[gamer owns yall v9.5 PREMIUM] Pickaxe GUI loaded • Theme: " .. THEMES[currentThemeName].name)

-- ============================================================
--  GAMER MUSIC  |  discord.gg/4TueRJmzDh
--  63 songs · gold/black · background · side select · minimize · API
--  Wrapped in do...end so its locals never collide with the TP script.
-- ============================================================
do
    local HttpService   = game:GetService("HttpService")
    local SoundService  = game:GetService("SoundService")
    local RunService    = game:GetService("RunService")
    local TweenService  = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local localPlayer   = game:GetService("Players").LocalPlayer
    local HubGui        = (gethui and gethui()) or game:GetService("CoreGui")

    -- ===== THEME =====
    local Theme = {
        Gold      = Color3.fromRGB(212, 175, 55),
        GoldLight = Color3.fromRGB(255, 215, 0),
        GoldDark  = Color3.fromRGB(140, 110, 30),
        Black     = Color3.fromRGB(8, 8, 8),
        BlackSoft = Color3.fromRGB(18, 18, 18),
        BlackCard = Color3.fromRGB(26, 24, 20),
        Text      = Color3.fromRGB(245, 235, 200),
        TextDim   = Color3.fromRGB(180, 165, 120),
        Discord   = "discord.gg/4TueRJmzDh",
        BG        = "rbxassetid://106519139240666",
    }

    local function goldStroke(obj, thick)
        local s = Instance.new("UIStroke")
        s.Color = Theme.Gold
        s.Thickness = thick or 1
        s.Transparency = 0.15
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = obj
        return s
    end

    local function goldGradient(obj, rot)
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Theme.GoldLight),
            ColorSequenceKeypoint.new(0.5, Theme.Gold),
            ColorSequenceKeypoint.new(1,   Theme.GoldDark),
        })
        g.Rotation = rot or 90
        g.Parent = obj
        return g
    end

    -- ============================================================
    --  SONG LIST
    -- ============================================================
    local MUSIC_PLAYER_OPTIONS = {
      {name="Gelato", url="https://files.catbox.moe/sospih.mp3", file="gamerMusic1.mp3"},
      {name="Meant To Be", url="https://files.catbox.moe/smt6l8.mp3", file="gamerMusic2.mp3"},
      {name="Beccaria San Vittore RMX", url="https://files.catbox.moe/2r8auq.mp3", file="gamerMusic3.mp3"},
      {name="The Box", url="https://files.catbox.moe/yumqjl.mp3", file="gamerMusic4.mp3"},
      {name="Mu Ammar Gheddafi RMX", url="https://files.catbox.moe/qcuden.mp3", file="gamerMusic5.mp3"},
      {name="Marocchino RMX", url="https://files.catbox.moe/iyav31.mp3", file="gamerMusic6.mp3"},
      {name="Gotham Mashup", url="https://files.catbox.moe/7eof36.mp3", file="gamerMusic7.mp3"},
      {name="Goosebumps", url="https://files.catbox.moe/6wqcck.mp3", file="gamerMusic8.mp3"},
      {name="Houdini", url="https://files.catbox.moe/gsuxur.mp3", file="gamerMusic9.mp3"},
      {name="Magnolia", url="https://files.catbox.moe/ursllw.mp3", file="gamerMusic10.mp3"},
      {name="Redemption RMX", url="https://files.catbox.moe/kjxkv7.mp3", file="gamerMusic11.mp3"},
      {name="Evicted RMX", url="https://files.catbox.moe/s28bh5.mp3", file="gamerMusic12.mp3"},
      {name="Lyfe RMX", url="https://files.catbox.moe/8hciqx.mp3", file="gamerMusic13.mp3"},
      {name="No Refunds RMX", url="https://files.catbox.moe/uz9hot.mp3", file="gamerMusic14.mp3"},
      {name="8 AM In Manny RMX", url="https://files.catbox.moe/xh4t0r.mp3", file="gamerMusic15.mp3"},
      {name="Us Vs Them RMX", url="https://files.catbox.moe/po5fbj.mp3", file="gamerMusic16.mp3"},
      {name="Reflection 2 RMX", url="https://files.catbox.moe/kcst57.mp3", file="gamerMusic17.mp3"},
      {name="I Know You Care RMX", url="https://files.catbox.moe/c2en1v.mp3", file="gamerMusic18.mp3"},
      {name="Bubblegum RMX", url="https://files.catbox.moe/8xf15k.mp3", file="gamerMusic19.mp3"},
      {name="Cream RMX", url="https://files.catbox.moe/yfhgqz.mp3", file="gamerMusic20.mp3"},
      {name="Panzerknacker.wav", url="https://files.catbox.moe/izcvhm.mp3", file="gamerMusic21.mp3"},
      {name="Freaked Out", url="https://files.catbox.moe/dyt2ja.mp3", file="gamerMusic22.mp3"},
      {name="Scam Likely", url="https://files.catbox.moe/pr85mz.mp3", file="gamerMusic23.mp3"},
      {name="Pure Cocaine", url="https://files.catbox.moe/dvjtjk.mp3", file="gamerMusic24.mp3"},
      {name="Tesla", url="https://files.catbox.moe/n85fch.mp3", file="gamerMusic25.mp3"},
      {name="Piazza Di Spaccio 2 RMX", url="https://files.catbox.moe/0ompvn.mp3", file="gamerMusic26.mp3"},
      {name="Benef RMX", url="https://files.catbox.moe/swcqe5.mp3", file="gamerMusic27.mp3"},
      {name="Accavallato RMX", url="https://files.catbox.moe/pme01q.mp3", file="gamerMusic28.mp3"},
      {name="Hd RMX", url="https://files.catbox.moe/oa3ylr.mp3", file="gamerMusic29.mp3"},
      {name="Vyzee", url="https://files.catbox.moe/gmxz02.mp3", file="gamerMusic30.mp3"},
      {name="Addiction", url="https://files.catbox.moe/unkq06.mp3", file="gamerMusic31.mp3"},
      {name="America RMX", url="https://files.catbox.moe/k09ioc.mp3", file="gamerMusic32.mp3"},
      {name="Sprinter", url="https://files.catbox.moe/0gyb73.mp3", file="gamerMusic33.mp3"},
      {name="Band4Band", url="https://files.catbox.moe/47dehm.mp3", file="gamerMusic34.mp3"},
      {name="Doja RMX", url="https://files.catbox.moe/8ze5d8.mp3", file="gamerMusic35.mp3"},
      {name="Opinel RMX", url="https://files.catbox.moe/hf6pdq.mp3", file="gamerMusic36.mp3"},
      {name="Vrp RMX", url="https://files.catbox.moe/hjzkbu.mp3", file="gamerMusic37.mp3"},
      {name="Tarantelle RMX", url="https://files.catbox.moe/0e9jwg.mp3", file="gamerMusic38.mp3"},
      {name="Hood RMX", url="https://files.catbox.moe/raewna.mp3", file="gamerMusic39.mp3"},
      {name="Mask RMX", url="https://files.catbox.moe/ghqz2q.mp3", file="gamerMusic40.mp3"},
      {name="Spinnin RMX", url="https://files.catbox.moe/r9achz.mp3", file="gamerMusic41.mp3"},
      {name="Dnd RMX", url="https://files.catbox.moe/1d83ju.mp3", file="gamerMusic42.mp3"},
      {name="Xnx RMX", url="https://files.catbox.moe/a2e54o.mp3", file="gamerMusic43.mp3"},
      {name="Hypebae RMX", url="https://files.catbox.moe/oj6hix.mp3", file="gamerMusic44.mp3"},
      {name="Mercedes Nero RMX", url="https://h.uguu.se/dCgHArHt.mp3", file="gamerMusic45.mp3", rev=2},
      {name="Dissenatori RMX", url="https://files.catbox.moe/fbjq0w.mp3", file="gamerMusic46.mp3"},
      {name="British RMX", url="https://files.catbox.moe/jn9mmr.mp3", file="gamerMusic47.mp3"},
      {name="Go Go Jack RMX", url="https://files.catbox.moe/u31krk.mp3", file="gamerMusic48.mp3"},
      {name="Darkmoney RMX", url="https://files.catbox.moe/rz4mzu.mp3", file="gamerMusic49.mp3"},
      {name="Ghetto RMX", url="https://files.catbox.moe/omj56p.mp3", file="gamerMusic50.mp3"},
      {name="Copacabana RMX", url="https://files.catbox.moe/g43412.mp3", file="gamerMusic51.mp3"},
      {name="Laja-Setadora", url="https://files.catbox.moe/94olvv.mp3", file="gamerMusic52.mp3"},
      {name="DUKI, Myke Towers - Nueva", url="https://files.catbox.moe/cb88xa.mp3", file="gamerMusic53.mp3"},
      {name="Gra Gra Boom", url="https://files.catbox.moe/vy21x7.mp3", file="gamerMusic54.mp3"},
      {name="LAJA - NADIE TA FRIO", url="https://files.catbox.moe/ecc674.mp3", file="gamerMusic55.mp3"},
      {name="Katya Lel", url="https://files.catbox.moe/lg4en9.mp3", file="gamerMusic56.mp3"},
      {name="Montagem Supersonic", url="https://files.catbox.moe/rlykfl.mp3", file="gamerMusic57.mp3"},
      {name="NO ERA AMOR", url="https://files.catbox.moe/6x3ori.mp3", file="gamerMusic58.mp3"},
      {name="KING NASIR DANCE", url="https://files.catbox.moe/y62e3y.mp3", file="gamerMusic59.mp3"},
      {name="Pibble Song", url="https://files.catbox.moe/eixg9d.mp3", file="gamerMusic60.mp3"},
      {name="Esclava", url="https://files.catbox.moe/cdsh6o.mp3", file="gamerMusic61.mp3"},
      {name="I Will Survive", url="https://files.catbox.moe/65sjh6.mp3", file="gamerMusic62.mp3"},
      {name="siinamota", url="https://files.catbox.moe/8lnwtq.mp3", file="gamerMusic63.mp3"},
    }

    -- ============================================================
    --  STATE
    -- ============================================================
    local MUSIC = {
        gui = nil,
        frame = nil,
        miniFrame = nil,
        sound = nil,
        current = 1,
        volume = 1,
        speed = 1,
        autoNext = false,
        shuffle = false,
        loop = false,
        cache = {},
        downloading = {},
        token = 0,
        refreshUI = nil,
        side = "Right",
        minimized = false,
        minimizedAt = 0,
    }

    local isfile_    = isfile or (syn and syn.isfile) or function() return false end
    local readfile_  = readfile or (syn and syn.readfile) or function() return nil end
    local writefile_ = writefile or (syn and syn.writefile) or function() end

    local function getSongName()
        local opt = MUSIC_PLAYER_OPTIONS[MUSIC.current]
        return opt and opt.name or "No Song"
    end

    local function randomIndex()
        local total = #MUSIC_PLAYER_OPTIONS
        if total <= 1 then return 1 end
        local r = math.random(1, total - 1)
        if r >= MUSIC.current then r = r + 1 end
        return r
    end

    local function refreshUI()
        if MUSIC.refreshUI then pcall(MUSIC.refreshUI) end
    end

    local function cacheSong(option, allowDownload)
        if not option or not option.url or option.url == "" then return nil end
        if not (writefile and getcustomasset) then return nil end
        local baseName = option.file or ("gamerMusic_" .. tostring(option.name or "song") .. ".mp3")
        local rev = math.max(math.floor(tonumber(option.rev) or 1), 1)
        local stem = baseName:gsub("%.mp3$", "")
        local fileName = (rev > 1) and (stem .. "_r" .. rev .. ".mp3") or baseName

        local function loadExisting()
            if MUSIC.cache[fileName] then return MUSIC.cache[fileName] end
            local hasFile = false
            pcall(function() hasFile = isfile and isfile(fileName) end)
            if hasFile then
                local ok = pcall(function() MUSIC.cache[fileName] = getcustomasset(fileName) end)
                if ok and MUSIC.cache[fileName] then return MUSIC.cache[fileName] end
            end
            return nil
        end

        local cached = loadExisting()
        if cached then return cached end
        if allowDownload == false then return nil end

        if MUSIC.downloading[fileName] then
            local t0 = tick()
            while MUSIC.downloading[fileName] and tick() - t0 < 15 do task.wait(0.05) end
            cached = loadExisting()
            if cached then return cached end
        end

        MUSIC.downloading[fileName] = true
        local ok = pcall(function()
            local data = game:HttpGet(option.url)
            if data and #data > 0 then
                writefile(fileName, data)
                MUSIC.cache[fileName] = getcustomasset(fileName)
            end
        end)
        MUSIC.downloading[fileName] = nil
        if ok and MUSIC.cache[fileName] then return MUSIC.cache[fileName] end
        return loadExisting()
    end

    local function createSound(option, name)
        if not option then return nil end
        local soundId = cacheSong(option, true)
        if not soundId then return nil end
        local snd = Instance.new("Sound")
        snd.Name = name or "gamerMusicPlayer"
        snd.Volume = MUSIC.volume
        snd.PlaybackSpeed = MUSIC.speed
        snd.Looped = false
        snd.SoundId = soundId
        snd.Parent = SoundService
        return snd
    end

    local function fadeOut(snd, dur)
        if not snd then return end
        dur = dur or 1.5
        pcall(function()
            TweenService:Create(snd, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Volume = 0}):Play()
        end)
        task.delay(dur + 0.1, function()
            pcall(function()
                if snd and snd.Parent then snd:Stop(); snd:Destroy() end
            end)
        end)
    end

    local function stopPlayback(fade)
        MUSIC.token = MUSIC.token + 1
        local snd = MUSIC.sound
        MUSIC.sound = nil
        if snd then
            if fade == false then
                pcall(function() snd:Stop(); snd:Destroy() end)
            else
                fadeOut(snd, 1.5)
            end
        end
        refreshUI()
    end

    local function playSong(index)
        index = tonumber(index) or MUSIC.current
        local total = #MUSIC_PLAYER_OPTIONS
        if total <= 0 then return end
        if index < 1 then index = total end
        if index > total then index = 1 end
        if not MUSIC_PLAYER_OPTIONS[index] then return end
        MUSIC.current = index
        stopPlayback(true)
        local myToken = MUSIC.token
        refreshUI()

        task.spawn(function()
            local option = MUSIC_PLAYER_OPTIONS[index]
            local snd = createSound(option, "gamerMusicPlayer_" .. tostring(myToken))
            if myToken ~= MUSIC.token then
                if snd then pcall(function() snd:Destroy() end) end
                return
            end
            if not snd then return end

            snd.Volume = MUSIC.volume
            snd.PlaybackSpeed = MUSIC.speed
            snd.TimePosition = 0
            MUSIC.sound = snd

            local loadStart = tick()
            while snd and snd.Parent and not snd.IsLoaded and tick() - loadStart < 15 do
                task.wait(0.05)
            end
            if myToken ~= MUSIC.token then
                pcall(function() if snd and snd.Parent then snd:Destroy() end end)
                return
            end
            pcall(function() snd:Play() end)
            refreshUI()

            local endedConn
            endedConn = snd.Ended:Connect(function()
                if endedConn then pcall(function() endedConn:Disconnect() end) end
                if myToken ~= MUSIC.token then return end
                if MUSIC.loop then
                    playSong(MUSIC.current)
                elseif MUSIC.shuffle then
                    playSong(randomIndex())
                elseif MUSIC.autoNext then
                    playSong(MUSIC.current + 1)
                else
                    stopPlayback(false)
                end
            end)
        end)
    end

    local function togglePause()
        local snd = MUSIC.sound
        if not snd or not snd.Parent then
            playSong(MUSIC.current)
            return
        end
        if snd.IsPlaying then
            pcall(function() snd:Pause() end)
        else
            pcall(function() snd:Resume() end)
        end
        refreshUI()
    end

    local function nextSong()
        if MUSIC.shuffle then playSong(randomIndex()) else playSong(MUSIC.current + 1) end
    end

    local function prevSong()
        if MUSIC.shuffle then playSong(randomIndex()) else playSong(MUSIC.current - 1) end
    end

    local function seek(delta)
        local snd = MUSIC.sound
        if not snd or not snd.Parent then return end
        local len = snd.TimeLength or 0
        local sp = tonumber(MUSIC.speed) or 1
        if sp <= 0 then sp = 1 end
        local newPos = snd.TimePosition + ((tonumber(delta) or 0) * sp)
        if newPos < 0 then newPos = 0 end
        if len > 0 and newPos > (len - 0.2) then newPos = math.max(len - 0.2, 0) end
        pcall(function() snd.TimePosition = newPos end)
        refreshUI()
    end

    local function setSpeed(v)
        v = math.clamp(math.floor((tonumber(v) or 1) * 10 + 0.5) / 10, 0.1, 2)
        MUSIC.speed = v
        local snd = MUSIC.sound
        if snd and snd.Parent then
            pcall(function() snd.PlaybackSpeed = v end)
        end
        refreshUI()
    end

    local function setVolume(v)
        v = math.clamp(math.floor((tonumber(v) or 1) * 100 + 0.5) / 100, 0, 2)
        MUSIC.volume = v
        local snd = MUSIC.sound
        if snd and snd.Parent then
            pcall(function() snd.Volume = v end)
        end
        refreshUI()
    end

    local function fmtTime(t)
        t = math.max(0, math.floor(tonumber(t) or 0))
        return string.format("%d:%02d", math.floor(t / 60), t % 60)
    end

    local function smallBtn(parent, name, text, size, pos, textSize)
        local b = Instance.new("TextButton", parent)
        b.Name = name
        b.BackgroundColor3 = Theme.BlackCard
        b.BorderSizePixel = 0
        b.Text = text
        b.TextColor3 = Theme.Gold
        b.TextSize = textSize or 13
        b.Font = Enum.Font.GothamBlack
        b.AutoButtonColor = false
        b.Size = size
        b.Position = pos
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        goldStroke(b, 1)
        b.MouseEnter:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = Theme.GoldDark}):Play()
        end)
        b.MouseLeave:Connect(function()
            TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BlackCard}):Play()
        end)
        return b
    end

    local function mpToggleRow(parent, labelText, getVal, setVal, yPos)
        local f = Instance.new("Frame", parent)
        f.Name = labelText
        f.BackgroundColor3 = Theme.BlackSoft
        f.BackgroundTransparency = 0.35
        f.BorderSizePixel = 0
        f.Size = UDim2.new(1, -24, 0, 36)
        f.Position = UDim2.new(0, 12, 0, yPos)
        f.ZIndex = 5
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 9)
        goldStroke(f, 1)

        local lbl = Instance.new("TextLabel", f)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.TextColor3 = Theme.Text
        lbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        lbl.TextStrokeTransparency = 0.4
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.Size = UDim2.new(1, -92, 1, 0)
        lbl.ZIndex = 6

        local pill = Instance.new("TextButton", f)
        pill.Name = "Pill"
        pill.BackgroundColor3 = Theme.BlackCard
        pill.BorderSizePixel = 0
        pill.Text = "OFF"
        pill.TextColor3 = Theme.TextDim
        pill.Font = Enum.Font.GothamBlack
        pill.TextSize = 11
        pill.AutoButtonColor = false
        pill.Size = UDim2.new(0, 60, 0, 24)
        pill.Position = UDim2.new(1, -72, 0.5, -12)
        pill.ZIndex = 6
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 12)
        goldStroke(pill, 1)

        local function apply(v)
            if v then
                pill.Text = "ON"
                pill.TextColor3 = Theme.Black
                pill.BackgroundColor3 = Theme.Gold
            else
                pill.Text = "OFF"
                pill.TextColor3 = Theme.TextDim
                pill.BackgroundColor3 = Theme.BlackCard
            end
        end
        apply(getVal() == true)

        pill.MouseButton1Click:Connect(function()
            local nv = not (getVal() == true)
            setVal(nv)
            apply(nv)
        end)
        return f, apply
    end

    -- ============================================================
    --  BUILD UI
    -- ============================================================
    local W, H = 340, 418
    local MINI_W, MINI_H = 200, 44

    local function getSidePos(side, w, h)
        if side == "Left" then
            return UDim2.new(0, 12, 0.5, -h/2)
        else
            return UDim2.new(1, -w - 12, 0.5, -h/2)
        end
    end

    function MUSIC.build()
        if MUSIC.gui then return end

        local sg = Instance.new("ScreenGui")
        sg.Name = "gamer_music"
        sg.ResetOnSpawn = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder = 9999
        sg.IgnoreGuiInset = true
        sg.Parent = HubGui
        MUSIC.gui = sg

        local frame = Instance.new("Frame", sg)
        frame.Name = "Frame"
        frame.AnchorPoint = Vector2.new(0, 0)
        frame.Position = getSidePos(MUSIC.side, W, H)
        frame.Size = UDim2.new(0, W, 0, H)
        frame.BackgroundColor3 = Theme.Black
        frame.BackgroundTransparency = 0.05
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)
        goldStroke(frame, 1.2)
        MUSIC.frame = frame

        local bgImage = Instance.new("ImageLabel", frame)
        bgImage.Name = "BgImage"
        bgImage.Size = UDim2.new(1, 0, 1, 0)
        bgImage.Position = UDim2.new(0, 0, 0, 0)
        bgImage.BackgroundTransparency = 1
        bgImage.Image = Theme.BG
        bgImage.ImageTransparency = 0.35
        bgImage.ScaleType = Enum.ScaleType.Crop
        bgImage.ZIndex = 0
        Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 16)

        local scrim = Instance.new("Frame", frame)
        scrim.Size = UDim2.new(1, 0, 1, 0)
        scrim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        scrim.BackgroundTransparency = 0.4
        scrim.BorderSizePixel = 0
        scrim.ZIndex = 1
        Instance.new("UICorner", scrim).CornerRadius = UDim.new(0, 16)

        local titleBar = Instance.new("Frame", frame)
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 48)
        titleBar.BackgroundColor3 = Theme.BlackSoft
        titleBar.BackgroundTransparency = 0.35
        titleBar.BorderSizePixel = 0
        titleBar.ZIndex = 5
        Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 16)

        local titleLbl = Instance.new("TextLabel", titleBar)
        titleLbl.Size = UDim2.new(1, -150, 1, 0)
        titleLbl.Position = UDim2.new(0, 16, 0, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "GAMER MUSIC"
        titleLbl.TextColor3 = Theme.Gold
        titleLbl.Font = Enum.Font.GothamBlack
        titleLbl.TextSize = 14
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.ZIndex = 6

        local sideHolder = Instance.new("Frame", titleBar)
        sideHolder.Name = "SideHolder"
        sideHolder.Size = UDim2.new(0, 56, 0, 24)
        sideHolder.Position = UDim2.new(1, -136, 0.5, -12)
        sideHolder.BackgroundColor3 = Theme.BlackCard
        sideHolder.BorderSizePixel = 0
        sideHolder.ZIndex = 6
        Instance.new("UICorner", sideHolder).CornerRadius = UDim.new(0, 12)
        goldStroke(sideHolder, 1)

        local leftBtn = Instance.new("TextButton", sideHolder)
        leftBtn.Size = UDim2.new(0, 28, 1, 0)
        leftBtn.Position = UDim2.new(0, 0, 0, 0)
        leftBtn.BackgroundTransparency = 1
        leftBtn.Text = "<"
        leftBtn.TextColor3 = Theme.TextDim
        leftBtn.Font = Enum.Font.GothamBlack
        leftBtn.TextSize = 12
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 7

        local rightBtn = Instance.new("TextButton", sideHolder)
        rightBtn.Size = UDim2.new(0, 28, 1, 0)
        rightBtn.Position = UDim2.new(1, -28, 0, 0)
        rightBtn.BackgroundTransparency = 1
        rightBtn.Text = ">"
        rightBtn.TextColor3 = Theme.TextDim
        rightBtn.Font = Enum.Font.GothamBlack
        rightBtn.TextSize = 12
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 7

        local function refreshSideVisual()
            if MUSIC.side == "Left" then
                leftBtn.TextColor3 = Theme.Black
                rightBtn.TextColor3 = Theme.TextDim
                leftBtn.BackgroundColor3 = Theme.Gold
                leftBtn.BackgroundTransparency = 0.1
                rightBtn.BackgroundColor3 = Theme.BlackCard
                rightBtn.BackgroundTransparency = 1
            else
                leftBtn.TextColor3 = Theme.TextDim
                rightBtn.TextColor3 = Theme.Black
                leftBtn.BackgroundColor3 = Theme.BlackCard
                leftBtn.BackgroundTransparency = 1
                rightBtn.BackgroundColor3 = Theme.Gold
                rightBtn.BackgroundTransparency = 0.1
            end
        end
        refreshSideVisual()

        local function setSide(side)
            MUSIC.side = side
            refreshSideVisual()
            if MUSIC.frame then
                TweenService:Create(MUSIC.frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {Position = getSidePos(side, W, H)}):Play()
            end
            if MUSIC.miniFrame then
                TweenService:Create(MUSIC.miniFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {Position = getSidePos(side, MINI_W, MINI_H)}):Play()
            end
        end
        leftBtn.MouseButton1Click:Connect(function() setSide("Left") end)
        rightBtn.MouseButton1Click:Connect(function() setSide("Right") end)

        local minBtn = Instance.new("TextButton", titleBar)
        minBtn.Size = UDim2.new(0, 28, 0, 28)
        minBtn.Position = UDim2.new(1, -72, 0, 10)
        minBtn.BackgroundColor3 = Theme.BlackCard
        minBtn.BorderSizePixel = 0
        minBtn.Text = "—"
        minBtn.TextColor3 = Theme.Gold
        minBtn.Font = Enum.Font.GothamBlack
        minBtn.TextSize = 14
        minBtn.AutoButtonColor = false
        minBtn.ZIndex = 6
        Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 7)
        goldStroke(minBtn, 1)
        minBtn.MouseEnter:Connect(function()
            TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.GoldDark}):Play()
        end)
        minBtn.MouseLeave:Connect(function()
            TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BlackCard}):Play()
        end)

        local closeBtn = Instance.new("TextButton", titleBar)
        closeBtn.Size = UDim2.new(0, 28, 0, 28)
        closeBtn.Position = UDim2.new(1, -40, 0, 10)
        closeBtn.BackgroundColor3 = Theme.BlackCard
        closeBtn.BorderSizePixel = 0
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Theme.Gold
        closeBtn.Font = Enum.Font.GothamBlack
        closeBtn.TextSize = 12
        closeBtn.AutoButtonColor = false
        closeBtn.ZIndex = 6
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)
        goldStroke(closeBtn, 1)
        closeBtn.MouseEnter:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(120, 30, 30)}):Play()
        end)
        closeBtn.MouseLeave:Connect(function()
            TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.BlackCard}):Play()
        end)
        closeBtn.MouseButton1Click:Connect(function()
            stopPlayback(true)
            MUSIC.gui:Destroy()
            MUSIC.gui = nil
            MUSIC.frame = nil
            MUSIC.miniFrame = nil
            MUSIC.refreshUI = nil
        end)

        local nameLbl = Instance.new("TextLabel", frame)
        nameLbl.Name = "SongName"
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = getSongName()
        nameLbl.TextColor3 = Theme.GoldLight
        nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLbl.TextStrokeTransparency = 0.4
        nameLbl.Font = Enum.Font.GothamBlack
        nameLbl.TextSize = 16
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.TextXAlignment = Enum.TextXAlignment.Center
        nameLbl.Position = UDim2.new(0, 14, 0, 56)
        nameLbl.Size = UDim2.new(1, -28, 0, 26)
        nameLbl.ZIndex = 5

        local counterLbl = Instance.new("TextLabel", frame)
        counterLbl.BackgroundTransparency = 1
        counterLbl.Text = ""
        counterLbl.TextColor3 = Theme.TextDim
        counterLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        counterLbl.TextStrokeTransparency = 0.4
        counterLbl.Font = Enum.Font.GothamBold
        counterLbl.TextSize = 10
        counterLbl.TextXAlignment = Enum.TextXAlignment.Center
        counterLbl.Position = UDim2.new(0, 14, 0, 83)
        counterLbl.Size = UDim2.new(1, -28, 0, 14)
        counterLbl.ZIndex = 5

        local barBg = Instance.new("Frame", frame)
        barBg.BackgroundColor3 = Theme.BlackSoft
        barBg.BackgroundTransparency = 0.25
        barBg.BorderSizePixel = 0
        barBg.Size = UDim2.new(1, -28, 0, 6)
        barBg.Position = UDim2.new(0, 14, 0, 105)
        barBg.ZIndex = 5
        Instance.new("UICorner", barBg).CornerRadius = UDim.new(0, 3)
        goldStroke(barBg, 1)

        local barFill = Instance.new("Frame", barBg)
        barFill.BackgroundColor3 = Theme.Gold
        barFill.BorderSizePixel = 0
        barFill.Size = UDim2.new(0, 0, 1, 0)
        barFill.ZIndex = 6
        Instance.new("UICorner", barFill).CornerRadius = UDim.new(0, 3)
        goldGradient(barFill, 0)

        local curLbl = Instance.new("TextLabel", frame)
        curLbl.BackgroundTransparency = 1
        curLbl.Text = "0:00"
        curLbl.TextColor3 = Theme.TextDim
        curLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        curLbl.TextStrokeTransparency = 0.4
        curLbl.Font = Enum.Font.GothamBold
        curLbl.TextSize = 10
        curLbl.TextXAlignment = Enum.TextXAlignment.Left
        curLbl.Position = UDim2.new(0, 14, 0, 114)
        curLbl.Size = UDim2.new(0, 60, 0, 14)
        curLbl.ZIndex = 5

        local totLbl = Instance.new("TextLabel", frame)
        totLbl.BackgroundTransparency = 1
        totLbl.Text = "0:00"
        totLbl.TextColor3 = Theme.TextDim
        totLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        totLbl.TextStrokeTransparency = 0.4
        totLbl.Font = Enum.Font.GothamBold
        totLbl.TextSize = 10
        totLbl.TextXAlignment = Enum.TextXAlignment.Right
        totLbl.Position = UDim2.new(1, -74, 0, 114)
        totLbl.Size = UDim2.new(0, 60, 0, 14)
        totLbl.ZIndex = 5

        local ctrl = Instance.new("Frame", frame)
        ctrl.BackgroundTransparency = 1
        ctrl.Size = UDim2.new(1, -24, 0, 50)
        ctrl.Position = UDim2.new(0, 12, 0, 136)
        ctrl.ZIndex = 5

        local prevBtn = smallBtn(ctrl, "PrevSong", "<", UDim2.new(0, 42, 0, 38), UDim2.new(0, 0, 0, 6), 15)
        local back10Btn = smallBtn(ctrl, "Back10", "<< 10", UDim2.new(0, 48, 0, 40), UDim2.new(0.5, -84, 0, 5), 11)
        local fwd10Btn = smallBtn(ctrl, "Fwd10", "10 >>", UDim2.new(0, 48, 0, 40), UDim2.new(0.5, 36, 0, 5), 11)
        local nextBtn = smallBtn(ctrl, "NextSong", ">", UDim2.new(0, 42, 0, 38), UDim2.new(1, -42, 0, 6), 15)

        local playHolder = Instance.new("Frame", ctrl)
        playHolder.BackgroundColor3 = Theme.Gold
        playHolder.BorderSizePixel = 0
        playHolder.Size = UDim2.new(0, 58, 0, 46)
        playHolder.Position = UDim2.new(0.5, -29, 0, 2)
        playHolder.ZIndex = 6
        Instance.new("UICorner", playHolder).CornerRadius = UDim.new(0, 14)
        goldStroke(playHolder, 1.2)
        goldGradient(playHolder, 45)

        local playBtn = Instance.new("TextButton", playHolder)
        playBtn.BackgroundTransparency = 1
        playBtn.Text = "PLAY"
        playBtn.TextColor3 = Theme.Black
        playBtn.Font = Enum.Font.GothamBlack
        playBtn.TextSize = 11
        playBtn.Size = UDim2.new(1, 0, 1, 0)
        playBtn.AutoButtonColor = false
        playBtn.ZIndex = 7

        prevBtn.MouseButton1Click:Connect(prevSong)
        nextBtn.MouseButton1Click:Connect(nextSong)
        back10Btn.MouseButton1Click:Connect(function() seek(-10) end)
        fwd10Btn.MouseButton1Click:Connect(function() seek(10) end)
        playBtn.MouseButton1Click:Connect(togglePause)

        local _, applyAutoNext = mpToggleRow(frame, "Auto Play Next", function() return MUSIC.autoNext end, function(v)
            MUSIC.autoNext = v
        end, 194)

        local _, applyShuffle = mpToggleRow(frame, "Shuffle", function() return MUSIC.shuffle end, function(v)
            MUSIC.shuffle = v
        end, 236)

        local _, applyLoop = mpToggleRow(frame, "Loop", function() return MUSIC.loop end, function(v)
            MUSIC.loop = v
        end, 278)

        local volFrame = Instance.new("Frame", frame)
        volFrame.BackgroundColor3 = Theme.BlackSoft
        volFrame.BackgroundTransparency = 0.35
        volFrame.BorderSizePixel = 0
        volFrame.Size = UDim2.new(1, -24, 0, 36)
        volFrame.Position = UDim2.new(0, 12, 1, -90)
        volFrame.ZIndex = 5
        Instance.new("UICorner", volFrame).CornerRadius = UDim.new(0, 9)
        goldStroke(volFrame, 1)

        local volLbl = Instance.new("TextLabel", volFrame)
        volLbl.BackgroundTransparency = 1
        volLbl.Text = "Volume"
        volLbl.TextColor3 = Theme.Text
        volLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        volLbl.TextStrokeTransparency = 0.4
        volLbl.Font = Enum.Font.GothamBold
        volLbl.TextSize = 12
        volLbl.TextXAlignment = Enum.TextXAlignment.Left
        volLbl.Position = UDim2.new(0, 12, 0, 0)
        volLbl.Size = UDim2.new(1, -140, 1, 0)
        volLbl.ZIndex = 6

        local volDown = smallBtn(volFrame, "VolDown", "<", UDim2.new(0, 26, 0, 24), UDim2.new(1, -120, 0.5, -12), 13)
        volDown.ZIndex = 6

        local volValue = Instance.new("TextLabel", volFrame)
        volValue.BackgroundColor3 = Theme.BlackCard
        volValue.BorderSizePixel = 0
        volValue.Text = string.format("%.2f", MUSIC.volume)
        volValue.TextColor3 = Theme.Gold
        volValue.Font = Enum.Font.GothamBlack
        volValue.TextSize = 12
        volValue.TextXAlignment = Enum.TextXAlignment.Center
        volValue.Size = UDim2.new(0, 46, 0, 24)
        volValue.Position = UDim2.new(1, -88, 0.5, -12)
        volValue.ZIndex = 6
        Instance.new("UICorner", volValue).CornerRadius = UDim.new(0, 7)
        goldStroke(volValue, 1)

        local volUp = smallBtn(volFrame, "VolUp", ">", UDim2.new(0, 26, 0, 24), UDim2.new(1, -36, 0.5, -12), 13)
        volUp.ZIndex = 6

        volDown.MouseButton1Click:Connect(function()
            setVolume(MUSIC.volume - 0.05)
            volValue.Text = string.format("%.2f", MUSIC.volume)
        end)
        volUp.MouseButton1Click:Connect(function()
            setVolume(MUSIC.volume + 0.05)
            volValue.Text = string.format("%.2f", MUSIC.volume)
        end)

        local spdFrame = Instance.new("Frame", frame)
        spdFrame.BackgroundColor3 = Theme.BlackSoft
        spdFrame.BackgroundTransparency = 0.35
        spdFrame.BorderSizePixel = 0
        spdFrame.Size = UDim2.new(1, -24, 0, 36)
        spdFrame.Position = UDim2.new(0, 12, 1, -48)
        spdFrame.ZIndex = 5
        Instance.new("UICorner", spdFrame).CornerRadius = UDim.new(0, 9)
        goldStroke(spdFrame, 1)

        local spdLbl = Instance.new("TextLabel", spdFrame)
        spdLbl.BackgroundTransparency = 1
        spdLbl.Text = "Speed"
        spdLbl.TextColor3 = Theme.Text
        spdLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        spdLbl.TextStrokeTransparency = 0.4
        spdLbl.Font = Enum.Font.GothamBold
        spdLbl.TextSize = 12
        spdLbl.TextXAlignment = Enum.TextXAlignment.Left
        spdLbl.Position = UDim2.new(0, 12, 0, 0)
        spdLbl.Size = UDim2.new(1, -140, 1, 0)
        spdLbl.ZIndex = 6

        local spdDown = smallBtn(spdFrame, "SpdDown", "<", UDim2.new(0, 26, 0, 24), UDim2.new(1, -120, 0.5, -12), 13)
        spdDown.ZIndex = 6

        local spdValue = Instance.new("TextLabel", spdFrame)
        spdValue.BackgroundColor3 = Theme.BlackCard
        spdValue.BorderSizePixel = 0
        spdValue.Text = string.format("%.1fx", MUSIC.speed)
        spdValue.TextColor3 = Theme.Gold
        spdValue.Font = Enum.Font.GothamBlack
        spdValue.TextSize = 12
        spdValue.TextXAlignment = Enum.TextXAlignment.Center
        spdValue.Size = UDim2.new(0, 46, 0, 24)
        spdValue.Position = UDim2.new(1, -88, 0.5, -12)
        spdValue.ZIndex = 6
        Instance.new("UICorner", spdValue).CornerRadius = UDim.new(0, 7)
        goldStroke(spdValue, 1)

        local spdUp = smallBtn(spdFrame, "SpdUp", ">", UDim2.new(0, 26, 0, 24), UDim2.new(1, -36, 0.5, -12), 13)
        spdUp.ZIndex = 6

        spdDown.MouseButton1Click:Connect(function()
            setSpeed(MUSIC.speed - 0.1)
            spdValue.Text = string.format("%.1fx", MUSIC.speed)
        end)
        spdUp.MouseButton1Click:Connect(function()
            setSpeed(MUSIC.speed + 0.1)
            spdValue.Text = string.format("%.1fx", MUSIC.speed)
        end)

        -- MINI FRAME
        local miniFrame = Instance.new("Frame", sg)
        miniFrame.Name = "MiniFrame"
        miniFrame.AnchorPoint = Vector2.new(0, 0)
        miniFrame.Position = getSidePos(MUSIC.side, MINI_W, MINI_H)
        miniFrame.Size = UDim2.new(0, MINI_W, 0, MINI_H)
        miniFrame.BackgroundColor3 = Theme.Black
        miniFrame.BackgroundTransparency = 0.05
        miniFrame.BorderSizePixel = 0
        miniFrame.ClipsDescendants = true
        miniFrame.Visible = false
        Instance.new("UICorner", miniFrame).CornerRadius = UDim.new(0, 12)
        goldStroke(miniFrame, 1.2)
        MUSIC.miniFrame = miniFrame

        local miniBg = Instance.new("ImageLabel", miniFrame)
        miniBg.Size = UDim2.new(1, 0, 1, 0)
        miniBg.BackgroundTransparency = 1
        miniBg.Image = Theme.BG
        miniBg.ImageTransparency = 0.4
        miniBg.ScaleType = Enum.ScaleType.Crop
        miniBg.ZIndex = 0
        Instance.new("UICorner", miniBg).CornerRadius = UDim.new(0, 12)

        local miniScrim = Instance.new("Frame", miniFrame)
        miniScrim.Size = UDim2.new(1, 0, 1, 0)
        miniScrim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        miniScrim.BackgroundTransparency = 0.5
        miniScrim.BorderSizePixel = 0
        miniScrim.ZIndex = 1
        Instance.new("UICorner", miniScrim).CornerRadius = UDim.new(0, 12)

        local miniNote = Instance.new("TextLabel", miniFrame)
        miniNote.Size = UDim2.new(0, 28, 1, 0)
        miniNote.Position = UDim2.new(0, 8, 0, 0)
        miniNote.BackgroundTransparency = 1
        miniNote.Text = "♪"
        miniNote.TextColor3 = Theme.Gold
        miniNote.Font = Enum.Font.GothamBlack
        miniNote.TextSize = 20
        miniNote.ZIndex = 5

        local miniName = Instance.new("TextLabel", miniFrame)
        miniName.Name = "MiniName"
        miniName.Size = UDim2.new(1, -80, 1, 0)
        miniName.Position = UDim2.new(0, 36, 0, 0)
        miniName.BackgroundTransparency = 1
        miniName.Text = getSongName()
        miniName.TextColor3 = Theme.GoldLight
        miniName.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        miniName.TextStrokeTransparency = 0.4
        miniName.Font = Enum.Font.GothamBold
        miniName.TextSize = 11
        miniName.TextTruncate = Enum.TextTruncate.AtEnd
        miniName.TextXAlignment = Enum.TextXAlignment.Left
        miniName.ZIndex = 5

        local miniPlayBtn = Instance.new("TextButton", miniFrame)
        miniPlayBtn.Size = UDim2.new(0, 28, 1, 0)
        miniPlayBtn.Position = UDim2.new(1, -32, 0, 0)
        miniPlayBtn.BackgroundTransparency = 1
        miniPlayBtn.Text = "▶"
        miniPlayBtn.TextColor3 = Theme.Gold
        miniPlayBtn.Font = Enum.Font.GothamBlack
        miniPlayBtn.TextSize = 14
        miniPlayBtn.AutoButtonColor = false
        miniPlayBtn.ZIndex = 6
        miniPlayBtn.MouseButton1Click:Connect(function()
            togglePause()
        end)

        local miniClick = Instance.new("TextButton", miniFrame)
        miniClick.Size = UDim2.new(1, -60, 1, 0)
        miniClick.Position = UDim2.new(0, 0, 0, 0)
        miniClick.BackgroundTransparency = 1
        miniClick.Text = ""
        miniClick.ZIndex = 4
        miniClick.MouseButton1Click:Connect(function()
            if tick() - MUSIC.minimizedAt < 0.25 then return end
            MUSIC.expand()
        end)

        do
            local dragging, dragStart, startPos = false, nil, nil
            miniFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = miniFrame.Position
                end
            end)
            miniFrame.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                    local d = input.Position - dragStart
                    miniFrame.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + d.X,
                        startPos.Y.Scale, startPos.Y.Offset + d.Y
                    )
                end
            end)
        end

        MUSIC.minimize = function()
            if not MUSIC.gui then return end
            MUSIC.minimized = true
            MUSIC.minimizedAt = tick()
            frame.Visible = false
            miniFrame.Visible = true
            miniFrame.Size = UDim2.new(0, 0, 0, MINI_H)
            TweenService:Create(miniFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(0, MINI_W, 0, MINI_H)}):Play()
        end

        MUSIC.expand = function()
            if not MUSIC.gui then return end
            MUSIC.minimized = false
            TweenService:Create(miniFrame, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                {Size = UDim2.new(0, 0, 0, MINI_H)}):Play()
            task.delay(0.17, function()
                miniFrame.Visible = false
                miniFrame.Size = UDim2.new(0, MINI_W, 0, MINI_H)
                frame.Visible = true
                frame.Size = UDim2.new(0, 0, 0, H)
                TweenService:Create(frame, TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, W, 0, H)}):Play()
            end)
        end

        minBtn.MouseButton1Click:Connect(function()
            MUSIC.minimize()
        end)

        do
            local dragging, dragStart, startPos = false, nil, nil
            titleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = frame.Position
                end
            end)
            titleBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch) then
                    local d = input.Position - dragStart
                    frame.Position = UDim2.new(
                        startPos.X.Scale, startPos.X.Offset + d.X,
                        startPos.Y.Scale, startPos.Y.Offset + d.Y
                    )
                end
            end)
        end

        MUSIC.refreshUI = function()
            if not (MUSIC.gui and MUSIC.gui.Parent) then return end
            local songName = getSongName()
            nameLbl.Text = songName
            miniName.Text = songName
            counterLbl.Text = "TRACK " .. tostring(MUSIC.current) .. " / " .. tostring(#MUSIC_PLAYER_OPTIONS)
            volValue.Text = string.format("%.2f", MUSIC.volume)
            spdValue.Text = string.format("%.1fx", MUSIC.speed)
            applyAutoNext(MUSIC.autoNext == true)
            applyShuffle(MUSIC.shuffle == true)
            applyLoop(MUSIC.loop == true)
            local s = MUSIC.sound
            local alive = s and s.Parent
            local isPlaying = alive and s.IsPlaying
            playBtn.Text = isPlaying and "PAUSE" or "PLAY"
            miniPlayBtn.Text = isPlaying and "❚❚" or "▶"
            if alive then
                local sp = tonumber(MUSIC.speed) or 1
                if sp <= 0 then sp = 1 end
                local len = (s.TimeLength or 0) / sp
                local pos = (s.TimePosition or 0) / sp
                if len > 0 then
                    barFill.Size = UDim2.new(math.clamp(pos / len, 0, 1), 0, 1, 0)
                    curLbl.Text = fmtTime(pos)
                    totLbl.Text = fmtTime(len)
                else
                    barFill.Size = UDim2.new(0, 0, 1, 0)
                    curLbl.Text = "0:00"
                    totLbl.Text = "--:--"
                end
            else
                barFill.Size = UDim2.new(0, 0, 1, 0)
                curLbl.Text = "0:00"
                totLbl.Text = "0:00"
            end
        end

        task.spawn(function()
            while MUSIC.gui and MUSIC.gui.Parent do
                pcall(MUSIC.refreshUI)
                task.wait(0.2)
            end
        end)

        MUSIC.refreshUI()
        print("[gamer music] UI built with " .. #MUSIC_PLAYER_OPTIONS .. " songs")
    end

    -- ============================================================
    --  FULL API
    -- ============================================================
    _G.gamerMusic = {
        List = function()
            local out = {}
            for i, s in ipairs(MUSIC_PLAYER_OPTIONS) do
                out[i] = { index = i, name = s.name, url = s.url }
            end
            return out
        end,
        Count = function() return #MUSIC_PLAYER_OPTIONS end,
        Search = function(query)
            query = tostring(query or ""):lower()
            local hits = {}
            for i, s in ipairs(MUSIC_PLAYER_OPTIONS) do
                if s.name:lower():find(query, 1, true) then
                    hits[#hits + 1] = { index = i, name = s.name }
                end
            end
            return hits
        end,

        Play = function(index) playSong(index) end,
        Pause = function() togglePause() end,
        Resume = function()
            local snd = MUSIC.sound
            if snd and snd.Parent and not snd.IsPlaying then
                pcall(function() snd:Resume() end)
                refreshUI()
            end
        end,
        Toggle = function() togglePause() end,
        Stop = function(fade) stopPlayback(fade) end,
        Next = function() nextSong() end,
        Prev = function() prevSong() end,

        Seek = function(seconds) seek(seconds) end,
        SeekTo = function(seconds)
            local snd = MUSIC.sound
            if not snd or not snd.Parent then return end
            local len = snd.TimeLength or 0
            if len <= 0 then return end
            local pos = math.clamp(tonumber(seconds) or 0, 0, len - 0.2)
            pcall(function() snd.TimePosition = pos end)
            refreshUI()
        end,
        SkipForward = function(sec) seek(sec or 10) end,
        SkipBack = function(sec) seek(-(sec or 10)) end,

        GetVolume = function() return MUSIC.volume end,
        SetVolume = function(v) setVolume(v) end,
        GetSpeed = function() return MUSIC.speed end,
        SetSpeed = function(v) setSpeed(v) end,

        IsAutoNext = function() return MUSIC.autoNext end,
        SetAutoNext = function(on)
            MUSIC.autoNext = on and true or false
            refreshUI()
        end,
        IsShuffle = function() return MUSIC.shuffle end,
        SetShuffle = function(on)
            MUSIC.shuffle = on and true or false
            refreshUI()
        end,
        IsLoop = function() return MUSIC.loop end,
        SetLoop = function(on)
            MUSIC.loop = on and true or false
            refreshUI()
        end,

        IsPlaying = function()
            local snd = MUSIC.sound
            return (snd and snd.Parent and snd.IsPlaying) == true
        end,
        IsLoaded = function()
            local snd = MUSIC.sound
            return (snd and snd.Parent and snd.IsLoaded) == true
        end,
        GetCurrent = function()
            local s = MUSIC_PLAYER_OPTIONS[MUSIC.current]
            if not s then return nil end
            return { index = MUSIC.current, name = s.name, url = s.url }
        end,
        GetCurrentName = function() return getSongName() end,
        GetCurrentIndex = function() return MUSIC.current end,

        GetPosition = function()
            local snd = MUSIC.sound
            if not snd or not snd.Parent then return 0 end
            local sp = tonumber(MUSIC.speed) or 1
            if sp <= 0 then sp = 1 end
            return (snd.TimePosition or 0) / sp
        end,
        GetDuration = function()
            local snd = MUSIC.sound
            if not snd or not snd.Parent then return 0 end
            local sp = tonumber(MUSIC.speed) or 1
            if sp <= 0 then sp = 1 end
            return (snd.TimeLength or 0) / sp
        end,
        GetProgress = function()
            local snd = MUSIC.sound
            if not snd or not snd.Parent then return 0 end
            local len = snd.TimeLength or 0
            if len <= 0 then return 0 end
            return math.clamp((snd.TimePosition or 0) / len, 0, 1)
        end,

        Open = function()
            if MUSIC.gui then return end
            pcall(MUSIC.build)
        end,
        Close = function()
            if not MUSIC.gui then return end
            stopPlayback(true)
            MUSIC.gui:Destroy()
            MUSIC.gui = nil
            MUSIC.frame = nil
            MUSIC.miniFrame = nil
            MUSIC.refreshUI = nil
        end,
        ToggleUI = function()
            if MUSIC.gui then
                _G.gamerMusic.Close()
            else
                _G.gamerMusic.Open()
            end
        end,
        IsOpen = function() return MUSIC.gui ~= nil end,

        Minimize = function()
            if MUSIC.minimize then MUSIC.minimize() end
        end,
        Expand = function()
            if MUSIC.expand then MUSIC.expand() end
        end,
        IsMinimized = function() return MUSIC.minimized == true end,
        ToggleMinimize = function()
            if MUSIC.minimized then
                if MUSIC.expand then MUSIC.expand() end
            else
                if MUSIC.minimize then MUSIC.minimize() end
            end
        end,

        GetSide = function() return MUSIC.side end,
        SetSide = function(side)
            if side ~= "Left" and side ~= "Right" then return end
            MUSIC.side = side
            if MUSIC.frame then
                TweenService:Create(MUSIC.frame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {Position = getSidePos(side, W, H)}):Play()
            end
            if MUSIC.miniFrame then
                TweenService:Create(MUSIC.miniFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {Position = getSidePos(side, MINI_W, MINI_H)}):Play()
            end
        end,

        Preload = function(index)
            if index then
                local s = MUSIC_PLAYER_OPTIONS[index]
                if s then
                    task.spawn(function() cacheSong(s, true) end)
                end
            else
                task.spawn(function()
                    for _, s in ipairs(MUSIC_PLAYER_OPTIONS) do
                        cacheSong(s, true)
                        task.wait(0.1)
                    end
                end)
            end
        end,
        ClearCache = function()
            MUSIC.cache = {}
        end,
        IsCached = function(index)
            local s = MUSIC_PLAYER_OPTIONS[index]
            if not s or not s.file then return false end
            return MUSIC.cache[s.file] ~= nil
        end,

        _state = MUSIC,
        _options = MUSIC_PLAYER_OPTIONS,
    }

    -- ============================================================
    --  AUTO-BUILD + KEYBIND
    -- ============================================================
    task.spawn(function()
        task.wait(1)
        pcall(MUSIC.build)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            _G.gamerMusic.ToggleUI()
        end
        if input.KeyCode == Enum.KeyCode.RightControl then
            _G.gamerMusic.ToggleMinimize()
        end
    end)

    print("[gamer music] loaded — RightShift toggle · RightCtrl minimize · _G.gamerMusic for API")
end

print("[gamer owns yall v9.5 PREMIUM] All systems loaded • " .. DISCORD)