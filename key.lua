-- [NEW WORLD] +1 Pickaxe Swing Escape - gamer owns yall (v9.4 PREMIUM)
-- Place ID: 82554996468034
-- Teleport system is UNCHANGED from v9.
-- v9.4: added "⭐ BEST WORLD" default location (2074.9, 18.9, 7562.0)


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
    subLabel.Text = "v9.4 PREMIUM • " .. DISCORD
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
subtitle.Text = "✦ " .. THEMES[currentThemeName].name .. " • v9.4 • " .. DISCORD
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
        subtitle.Text = "✦ " .. THEMES[currentThemeName].name .. " • v9.4 • " .. DISCORD
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
footer.Text = "made by gamer owns yall • v9.4"
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


print("[gamer owns yall v9.4 PREMIUM] Loaded • Theme: " .. THEMES[currentThemeName].name .. " • " .. DISCORD)