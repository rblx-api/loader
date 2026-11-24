--[[
    SPLUNKY PACKET
    discord.gg/A8zVEJsR6
]]

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS           = game:GetService("ReplicatedStorage")
local RunService   = game:GetService("RunService")
local HttpService  = game:GetService("HttpService")

local LP = Players.LocalPlayer
local CONFIG_FILE = "SplunkyPacket_Config.json"

-- ========================
-- REMOTE / NET LOOKUP
-- ========================
local net = nil
task.spawn(function()
    local ok1, net1 = pcall(function()
        local pkgs = RS:WaitForChild("Packages", 5)
        return pkgs and pkgs:WaitForChild("Net", 5)
    end)
    if ok1 and net1 then
        local kids = net1:GetChildren()
        net = kids[6]
        if net then return end
    end
    local tries, pkgs = 0, nil
    while tries < 10 do
        local ok, found = pcall(function() return RS:FindFirstChild("Packages") end)
        if ok and found then pkgs = found; break end
        tries += 1; task.wait(0.5)
    end
    if not pkgs then return end
    local netObj = pkgs:FindFirstChild("Net")
    if not netObj then task.wait(5); netObj = pkgs:FindFirstChild("Net") end
    if not netObj then return end
    local ok2, found2 = pcall(function() return netObj:GetChildren()[230] end)
    if ok2 then net = found2 end
end)

-- ========================
-- CLEANUP
-- ========================
pcall(function()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        for _, n in ipairs({"SplunkyPacket","S2JRHub","S2HubGui"}) do
            local old = pg:FindFirstChild(n)
            if old then old:Destroy() end
        end
    end
    if gethui then
        for _, g in ipairs(gethui():GetChildren()) do
            if g.Name == "SplunkyPacket" or g.Name == "S2JRHub" then g:Destroy() end
        end
    end
end)

-- ========================
-- THEMES
-- ========================
local THEMES = {
    { name = "Blue",    accent = Color3.fromRGB(66,  133, 244) },
    { name = "Purple",  accent = Color3.fromRGB(160,  80, 255) },
    { name = "Green",   accent = Color3.fromRGB(50,  215, 100) },
    { name = "Red",     accent = Color3.fromRGB(220,  60,  60) },
    { name = "Orange",  accent = Color3.fromRGB(255, 150,  40) },
    { name = "Pink",    accent = Color3.fromRGB(255,  80, 180) },
    { name = "Cyan",    accent = Color3.fromRGB(40,  210, 220) },
    { name = "White",   accent = Color3.fromRGB(220, 220, 230) },
    { name = "Rainbow", accent = Color3.fromRGB(255,   0,   0) },
}

local BG_DARK   = Color3.fromRGB(12, 12, 16)
local BG_PANEL  = Color3.fromRGB(20, 20, 28)
local BG_INPUT  = Color3.fromRGB(30, 30, 40)
local WHITE     = Color3.fromRGB(255,255,255)
local GRAY_LBL  = Color3.fromRGB(150,150,170)
local BORDER    = Color3.fromRGB(50, 50, 70)
local GREEN_ON  = Color3.fromRGB(50, 215, 100)
local RED_OFF   = Color3.fromRGB(220, 60, 60)

local BG_IMAGES = {
    "rbxassetid://117506604414812",
    "rbxassetid://100339467909522",
    "rbxassetid://121717047689997",
    "rbxassetid://108804917358578",
}

-- ========================
-- STATE
-- ========================
local currentAccent   = THEMES[1].accent
local currentThemeIdx = 1
local currentBgIdx    = 0
local lagging         = false
local lagThread       = nil
local intensity       = 17000
local toggleKey       = Enum.KeyCode.Three
local toggleKeyName   = "Press keybind..."
local listeningForKey = false
local walking         = false
local walkThread      = nil
local brainrotOn      = true
local clickLock       = false
local isCollapsed     = false
local rainbowConn     = nil
local starRainOn      = false
local sakuraOn        = false
local starConn        = nil
local sakuraConn      = nil

-- Sizes
local W      = 330
local H_FULL = 320
local H_MINI = 108
local MIN_W, MAX_W = 220, 480
local MIN_H, MAX_H = 280, 650

-- ========================
-- GUI
-- ========================
local gui = Instance.new("ScreenGui")
gui.Name = "SplunkyPacket"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
pcall(function() if gethui then gui.Parent = gethui() end end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

local function corner(o, r)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,r); c.Parent = o; return c
end
local function stroke(o, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or BORDER; s.Thickness = th or 1; s.Transparency = tr or 0.5
    s.Parent = o; return s
end
local function mkLabel(parent, txt, x, y, w, h, size, col, font, xa)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Position = UDim2.fromOffset(x,y); l.Size = UDim2.fromOffset(w,h)
    l.Text = txt; l.TextSize = size or 13; l.TextColor3 = col or WHITE
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.ZIndex = 5; l.Parent = parent; return l
end
local function mkToggle(parent, x, y, startOn, accent)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromOffset(44, 22)
    bg.Position = UDim2.fromOffset(x, y)
    bg.BackgroundColor3 = startOn and accent or Color3.fromRGB(70,70,90)
    bg.ZIndex = 12; bg.Parent = parent
    corner(bg, 11)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16,16)
    knob.Position = startOn and UDim2.fromOffset(25,3) or UDim2.fromOffset(3,3)
    knob.BackgroundColor3 = WHITE
    knob.ZIndex = 13; knob.Parent = bg
    corner(knob, 8)
    local hit = Instance.new("TextButton")
    hit.Size = UDim2.fromScale(1,1)
    hit.BackgroundTransparency = 1; hit.Text = ""
    hit.ZIndex = 14; hit.Parent = bg
    return bg, knob, hit
end

-- Main frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(W, H_FULL)
Main.AnchorPoint = Vector2.new(0,0)
Main.Position = UDim2.new(0.5,-W/2, 0.5,-H_FULL/2)
Main.BackgroundColor3 = BG_DARK
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = gui
corner(Main, 18)
local mainStroke = stroke(Main, currentAccent, 1.5, 0.2)

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = BG_DARK
overlay.BackgroundTransparency = 0.3
overlay.BorderSizePixel = 0
overlay.ZIndex = 1; overlay.Parent = Main
corner(overlay, 18)

local bgImg = Instance.new("ImageLabel")
bgImg.Size = UDim2.new(1,0,1,0)
bgImg.BackgroundTransparency = 1
bgImg.Image = ""; bgImg.ImageTransparency = 0
bgImg.ScaleType = Enum.ScaleType.Crop
bgImg.ZIndex = 0; bgImg.Parent = Main
corner(bgImg, 18)

-- ========================
-- PARTICLE CONTAINER (ulduz/sakura — Main içi, overlay altında)
-- ========================
local particleContainer = Instance.new("Frame")
particleContainer.Size = UDim2.new(1,0,1,0)
particleContainer.BackgroundTransparency = 1
particleContainer.ZIndex = 2
particleContainer.ClipsDescendants = true
particleContainer.Parent = Main

-- ========================
-- HEADER
-- ========================
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,50)
header.BackgroundTransparency = 1
header.ZIndex = 4; header.Parent = Main

local titleLbl = Instance.new("TextLabel")
titleLbl.BackgroundTransparency = 1
titleLbl.Position = UDim2.fromOffset(14,8)
titleLbl.Size = UDim2.fromOffset(170,20)
titleLbl.Text = "SPLUNKY PACKET"
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 16; titleLbl.TextColor3 = WHITE
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5; titleLbl.Parent = header

local subLbl = Instance.new("TextLabel")
subLbl.BackgroundTransparency = 1
subLbl.Position = UDim2.fromOffset(14,28)
subLbl.Size = UDim2.fromOffset(170,14)
subLbl.Text = "discord.gg/A8zVEJsR6"
subLbl.Font = Enum.Font.Gotham
subLbl.TextSize = 11; subLbl.TextColor3 = GRAY_LBL
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 5; subLbl.Parent = header

local settingsBtn = Instance.new("TextButton")
settingsBtn.Size = UDim2.fromOffset(28,28)
settingsBtn.Position = UDim2.new(1,-64,0,11)
settingsBtn.BackgroundColor3 = BG_INPUT
settingsBtn.Text = "⚙"; settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 14; settingsBtn.TextColor3 = GRAY_LBL
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 6; settingsBtn.Parent = header
corner(settingsBtn, 7)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(28,28)
minBtn.Position = UDim2.new(1,-32,0,11)
minBtn.BackgroundColor3 = BG_INPUT
minBtn.Text = "−"; minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16; minBtn.TextColor3 = GRAY_LBL
minBtn.AutoButtonColor = false
minBtn.ZIndex = 6; minBtn.Parent = header
corner(minBtn, 7)

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1,-24,0,1)
divider.Position = UDim2.fromOffset(12,50)
divider.BackgroundColor3 = BORDER
divider.BackgroundTransparency = 0.3
divider.BorderSizePixel = 0; divider.ZIndex = 4; divider.Parent = Main

-- ========================
-- CONTENT
-- ========================
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Position = UDim2.fromOffset(0,54)
content.Size = UDim2.new(1,0,1,-54)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 0
content.CanvasSize = UDim2.fromOffset(0,0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ZIndex = 4; content.Parent = Main

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0,5)
listLayout.Parent = content

local contentPad = Instance.new("UIPadding")
contentPad.PaddingLeft  = UDim.new(0,12)
contentPad.PaddingRight = UDim.new(0,12)
contentPad.PaddingTop   = UDim.new(0,6)
contentPad.PaddingBottom= UDim.new(0,8)
contentPad.Parent = content

local function mkSection(h, lo)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,h)
    f.BackgroundTransparency = 1
    f.LayoutOrder = lo or 0; f.ZIndex = 4; f.Parent = content
    return f
end
local function mkPanel(parent, h)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,h)
    f.BackgroundColor3 = BG_PANEL
    f.BackgroundTransparency = 0.35
    f.BorderSizePixel = 0; f.ZIndex = 4; f.Parent = parent
    corner(f,10); stroke(f, BORDER, 1, 0.5)
    return f
end

-- ========================
-- 1) POWER — ÜÇBUCAQLı ÇƏRÇƏVƏ + 3 DÖVRƏN NEON XƏTT
-- ========================
local powerSec = mkSection(130, 1)

-- Üçbucaq container (mərkəzdə)
local TRI_SIZE = 110
local triContainer = Instance.new("Frame")
triContainer.Size = UDim2.fromOffset(TRI_SIZE, TRI_SIZE)
triContainer.Position = UDim2.new(0.5, -TRI_SIZE/2, 0, 8)
triContainer.BackgroundTransparency = 1
triContainer.ZIndex = 4; triContainer.Parent = powerSec

-- Üçbucaq arxa fon (canvas)
local triCanvas = Instance.new("ImageLabel")
triCanvas.Size = UDim2.new(1,0,1,0)
triCanvas.BackgroundTransparency = 1
triCanvas.Image = ""  -- rəngli background
triCanvas.ZIndex = 4; triCanvas.Parent = triContainer

-- POWER mətn (üçbucaq içi)
local powerSubLbl = Instance.new("TextLabel")
powerSubLbl.BackgroundTransparency = 1
powerSubLbl.Size = UDim2.new(1,0,0,16)
powerSubLbl.Position = UDim2.fromOffset(0, 38)
powerSubLbl.Text = "POWER"
powerSubLbl.Font = Enum.Font.GothamBold
powerSubLbl.TextSize = 11; powerSubLbl.TextColor3 = GRAY_LBL
powerSubLbl.TextXAlignment = Enum.TextXAlignment.Center
powerSubLbl.ZIndex = 5; powerSubLbl.Parent = triContainer

local PowerBox = Instance.new("TextBox")
PowerBox.BackgroundTransparency = 1
PowerBox.Size = UDim2.new(1,0,0,36)
PowerBox.Position = UDim2.fromOffset(0, 52)
PowerBox.Text = "17K"
PowerBox.Font = Enum.Font.GothamBlack
PowerBox.TextSize = 26; PowerBox.TextColor3 = WHITE
PowerBox.TextXAlignment = Enum.TextXAlignment.Center
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 5; PowerBox.Parent = triContainer

-- 3 dövrən neon xətt (ağ): hər biri bir Frame, üçbucaq kənarlarını simulate edir
-- Sadə yanaşma: 3 nazik Frame (xətt) üçbucaq ətrafında fırlansın
-- Frame-ları triContainer-ın ÜSTÜNDƏ (powerSec içi, containerın kənarları boyunca)

-- Neon orbit: 3 kiçik parlaq nöqtə üçbucağın ətrafında dövr edir
local orbitDots = {}
for i = 1, 3 do
    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = WHITE
    dot.BorderSizePixel = 0
    dot.ZIndex = 7; dot.Parent = powerSec
    corner(dot, 4)
    -- Parlaq neon görünüşü üçün UIStroke
    local ds = Instance.new("UIStroke")
    ds.Color = WHITE; ds.Thickness = 2; ds.Transparency = 0.0
    ds.Parent = dot
    orbitDots[i] = dot
end

-- Üçbucağın 3 künc nöqtəsi (powerSec içi, triContainer mövqeyinə nisbətən)
-- triContainer: X = W/2 - TRI_SIZE/2, Y = 8
-- Üçbucaq künclər (equalateral): top, bottomLeft, bottomRight
local function getTriPoints(cx, cy, r)
    return {
        { x = cx,            y = cy - r },            -- top
        { x = cx + r*0.866,  y = cy + r*0.5 },        -- bottom-right
        { x = cx - r*0.866,  y = cy + r*0.5 },        -- bottom-left
    }
end

-- Neon xətlər (3 xətt üçbucaq kənarları): Frame ilə simulate
local neonLines = {}
for i = 1, 3 do
    local line = Instance.new("Frame")
    line.BackgroundColor3 = WHITE
    line.BackgroundTransparency = 0.1
    line.BorderSizePixel = 0
    line.ZIndex = 6; line.AnchorPoint = Vector2.new(0, 0.5)
    line.Parent = powerSec
    neonLines[i] = line
end

-- Neon xətt + orbit animasiyası
local neonAngle = 0
local function lerp(a, b, t) return a + (b-a)*t end

local orbitConn = RunService.Heartbeat:Connect(function(dt)
    neonAngle = (neonAngle + dt * 60) % 360  -- dərəcə/san

    -- powerSec içindəki triContainer mərkəzi
    local cx = TRI_SIZE/2 + (W/2 - TRI_SIZE/2)   -- powerSec genişliyi = content genişliyi ≈ W-24
    local cy = 8 + TRI_SIZE/2
    local R  = TRI_SIZE * 0.46

    -- Neon xətlər: statik üçbucaq kənarları (tam kənar boyunca)
    local pts = getTriPoints(cx, cy, R)
    for i = 1, 3 do
        local a = pts[i]; local b = pts[(i%3)+1]
        local dx = b.x - a.x; local dy = b.y - a.y
        local len = math.sqrt(dx*dx + dy*dy)
        local ang = math.atan2(dy, dx)
        neonLines[i].Size     = UDim2.fromOffset(len, 2)
        neonLines[i].Position = UDim2.fromOffset(a.x, a.y)
        neonLines[i].Rotation = math.deg(ang)
    end

    -- 3 neon nöqtə üçbucağın perimetri boyunca dövr edir
    -- Perimetr = 3 * kənar uzunluğu, hər nöqtə 1/3 arayla
    local knar = R * math.sqrt(3)   -- equalateral tərəf
    local perim = 3 * knar
    for i, dot in ipairs(orbitDots) do
        local offset = perim * (i-1) / 3
        local progress = ((neonAngle/360) * perim + offset) % perim
        -- Hansı kənardayıq
        local seg = math.floor(progress / knar)
        local t   = (progress % knar) / knar
        local a   = pts[seg+1]; local b = pts[((seg+1)%3)+1]
        local px  = lerp(a.x, b.x, t)
        local py  = lerp(a.y, b.y, t)
        dot.Position = UDim2.fromOffset(px - 4, py - 4)
    end
end)

-- ========================
-- 2) AUTO BRAINROT
-- ========================
local brainrotSec = mkSection(34, 2)
mkLabel(brainrotSec, "Auto Brainrot", 0, 6, 160, 22, 14, WHITE, Enum.Font.GothamMedium)
local toggleBg, toggleKnob, toggleHit = mkToggle(brainrotSec, brainrotSec.Size.X.Offset - 46, 6, true, currentAccent)
-- pozisiya dinamik qurulur aşağıda

local function reposToggle(frame, bg)
    bg.Position = UDim2.new(1, -46, 0, 6)
end
reposToggle(brainrotSec, toggleBg)

-- ========================
-- 3) KEYBIND
-- ========================
local keySec = mkSection(34, 3)
mkLabel(keySec, "Keybind", 0, 6, 120, 22, 14, WHITE, Enum.Font.GothamMedium)

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.fromOffset(140, 24)
KeyBtn.Position = UDim2.new(1,-140,0,5)
KeyBtn.BackgroundTransparency = 1
KeyBtn.Text = "Press keybind..."
KeyBtn.Font = Enum.Font.GothamBold
KeyBtn.TextSize = 13
KeyBtn.TextColor3 = Color3.fromRGB(255,200,50)
KeyBtn.AutoButtonColor = false
KeyBtn.TextXAlignment = Enum.TextXAlignment.Right
KeyBtn.ZIndex = 5; KeyBtn.Parent = keySec

-- ========================
-- 4) CFRAME WALK
-- ========================
local walkSec = mkSection(58, 4)
local walkPanel = mkPanel(walkSec, 58)

mkLabel(walkPanel, "CFRAME WALK", 12, 5, 120, 15, 11, GRAY_LBL, Enum.Font.GothamBold)

local WalkBtn = Instance.new("TextButton")
WalkBtn.Size = UDim2.fromOffset(80, 22)
WalkBtn.Position = UDim2.new(1,-92,0,5)
WalkBtn.BackgroundColor3 = RED_OFF
WalkBtn.Text = "WALK OFF"
WalkBtn.Font = Enum.Font.GothamBlack
WalkBtn.TextSize = 11; WalkBtn.TextColor3 = WHITE
WalkBtn.AutoButtonColor = false; WalkBtn.ZIndex = 5; WalkBtn.Parent = walkPanel
corner(WalkBtn, 7)

mkLabel(walkPanel, "studs", 10, 30, 36, 18, 12, GRAY_LBL, Enum.Font.GothamMedium)
local studsBox = Instance.new("TextBox")
studsBox.Size = UDim2.fromOffset(40, 20); studsBox.Position = UDim2.fromOffset(50, 30)
studsBox.BackgroundColor3 = BG_INPUT; studsBox.Text = "3"
studsBox.Font = Enum.Font.GothamBlack; studsBox.TextSize = 13; studsBox.TextColor3 = WHITE
studsBox.TextXAlignment = Enum.TextXAlignment.Center; studsBox.ClearTextOnFocus = false
studsBox.ZIndex = 5; studsBox.Parent = walkPanel; corner(studsBox, 5)

mkLabel(walkPanel, "delay", 100, 30, 38, 18, 12, GRAY_LBL, Enum.Font.GothamMedium)
local delayBox = Instance.new("TextBox")
delayBox.Size = UDim2.fromOffset(48, 20); delayBox.Position = UDim2.fromOffset(142, 30)
delayBox.BackgroundColor3 = BG_INPUT; delayBox.Text = "0.06"
delayBox.Font = Enum.Font.GothamBlack; delayBox.TextSize = 13; delayBox.TextColor3 = WHITE
delayBox.TextXAlignment = Enum.TextXAlignment.Center; delayBox.ClearTextOnFocus = false
delayBox.ZIndex = 5; delayBox.Parent = walkPanel; corner(delayBox, 5)

-- ========================
-- 5) ACTIVATE
-- ========================
local activateSec = mkSection(44, 5)
local ActivateBtn = Instance.new("TextButton")
ActivateBtn.Size = UDim2.new(1,0,0,44)
ActivateBtn.BackgroundColor3 = currentAccent
ActivateBtn.Text = "ACTIVATE"
ActivateBtn.Font = Enum.Font.GothamBlack
ActivateBtn.TextSize = 17; ActivateBtn.TextColor3 = WHITE
ActivateBtn.AutoButtonColor = false; ActivateBtn.ZIndex = 5; ActivateBtn.Parent = activateSec
corner(ActivateBtn, 13)

-- ========================
-- SETTINGS PANEL
-- ========================
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(1,0,1,0)
settingsPanel.BackgroundColor3 = BG_DARK
settingsPanel.BackgroundTransparency = 0.05
settingsPanel.ZIndex = 10; settingsPanel.Visible = false; settingsPanel.Parent = Main
corner(settingsPanel, 18)

local sTitleLbl = Instance.new("TextLabel")
sTitleLbl.BackgroundTransparency = 1
sTitleLbl.Position = UDim2.fromOffset(14,10)
sTitleLbl.Size = UDim2.fromOffset(200,22)
sTitleLbl.Text = "SETTINGS"; sTitleLbl.Font = Enum.Font.GothamBlack
sTitleLbl.TextSize = 15; sTitleLbl.TextColor3 = WHITE
sTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
sTitleLbl.ZIndex = 11; sTitleLbl.Parent = settingsPanel

local sClose = Instance.new("TextButton")
sClose.Size = UDim2.fromOffset(28,28); sClose.Position = UDim2.new(1,-38,0,8)
sClose.BackgroundColor3 = BG_INPUT; sClose.Text = "✕"
sClose.Font = Enum.Font.GothamBold; sClose.TextSize = 13; sClose.TextColor3 = GRAY_LBL
sClose.AutoButtonColor = false; sClose.ZIndex = 11; sClose.Parent = settingsPanel; corner(sClose, 7)

local sDivider = Instance.new("Frame")
sDivider.Size = UDim2.new(1,-24,0,1); sDivider.Position = UDim2.fromOffset(12,42)
sDivider.BackgroundColor3 = BORDER; sDivider.BackgroundTransparency = 0.3
sDivider.ZIndex = 11; sDivider.Parent = settingsPanel

local sScroll = Instance.new("ScrollingFrame")
sScroll.Position = UDim2.fromOffset(0,46); sScroll.Size = UDim2.new(1,0,1,-46)
sScroll.BackgroundTransparency = 1; sScroll.ScrollBarThickness = 3
sScroll.ScrollBarImageColor3 = BORDER
sScroll.CanvasSize = UDim2.fromOffset(0,0); sScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
sScroll.ZIndex = 11; sScroll.Parent = settingsPanel

local sLayout = Instance.new("UIListLayout")
sLayout.SortOrder = Enum.SortOrder.LayoutOrder; sLayout.Padding = UDim.new(0,8); sLayout.Parent = sScroll

local sPad = Instance.new("UIPadding")
sPad.PaddingLeft = UDim.new(0,12); sPad.PaddingRight = UDim.new(0,12)
sPad.PaddingTop  = UDim.new(0,8);  sPad.PaddingBottom= UDim.new(0,10); sPad.Parent = sScroll

local function sSection(title, lo)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1; lbl.Size = UDim2.new(1,0,0,16)
    lbl.Text = title; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.TextColor3 = GRAY_LBL; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12; lbl.LayoutOrder = lo; lbl.Parent = sScroll; return lbl
end
local function sRow(h, lo)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,h); f.BackgroundTransparency = 1
    f.LayoutOrder = lo; f.ZIndex = 11; f.Parent = sScroll; return f
end

-- ---- BACKGROUND ----
sSection("BACKGROUND", 1)
local bgRow = sRow(50, 2)
local bgRowL = Instance.new("UIListLayout")
bgRowL.FillDirection = Enum.FillDirection.Horizontal
bgRowL.Padding = UDim.new(0,6); bgRowL.Parent = bgRow

local bgOffBtn = Instance.new("TextButton")
bgOffBtn.Size = UDim2.fromOffset(50,50); bgOffBtn.BackgroundColor3 = BG_INPUT
bgOffBtn.Text = "Off"; bgOffBtn.Font = Enum.Font.GothamBold
bgOffBtn.TextSize = 12; bgOffBtn.TextColor3 = WHITE; bgOffBtn.AutoButtonColor = false
bgOffBtn.ZIndex = 12; bgOffBtn.LayoutOrder = 0; bgOffBtn.Parent = bgRow; corner(bgOffBtn, 8)
local bgOffStroke = stroke(bgOffBtn, currentAccent, 1.5, 0.1)

local bgImgBtns = {}
for i, imgId in ipairs(BG_IMAGES) do
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.fromOffset(50,50); btn.BackgroundColor3 = BG_INPUT
    btn.Image = imgId; btn.ImageTransparency = 0; btn.ScaleType = Enum.ScaleType.Crop
    btn.AutoButtonColor = false; btn.ZIndex = 12; btn.LayoutOrder = i; btn.Parent = bgRow
    corner(btn, 8)
    local s = stroke(btn, BORDER, 1, 0.6)
    bgImgBtns[i] = {btn=btn, stk=s}
end

-- ---- THEMES ----
sSection("THEMES", 3)
local themeRow = sRow(32, 4)
local themeRowL = Instance.new("UIListLayout")
themeRowL.FillDirection = Enum.FillDirection.Horizontal
themeRowL.Padding = UDim.new(0,5); themeRowL.Parent = themeRow

local themeBtns = {}
for i, th in ipairs(THEMES) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(28,28)
    btn.BackgroundColor3 = (th.name == "Rainbow") and Color3.fromRGB(255,0,0) or th.accent
    btn.Text = ""; btn.AutoButtonColor = false
    btn.ZIndex = 12; btn.LayoutOrder = i; btn.Parent = themeRow; corner(btn, 14)
    local s = stroke(btn, WHITE, 1.5, (i==1) and 0.0 or 1.0)
    themeBtns[i] = {btn=btn, stk=s}
end

-- ---- EFFECTS ----
sSection("EFFECTS", 5)

local effectsPanel = Instance.new("Frame")
effectsPanel.Size = UDim2.new(1,0,0,70)
effectsPanel.BackgroundColor3 = BG_PANEL
effectsPanel.BackgroundTransparency = 0.4
effectsPanel.LayoutOrder = 6; effectsPanel.ZIndex = 11; effectsPanel.Parent = sScroll
corner(effectsPanel, 10)

-- Star Rain toggle
mkLabel(effectsPanel, "⭐  Star Rain", 12, 8, 160, 20, 13, WHITE, Enum.Font.GothamMedium)
local starBg, starKnob, starHit = mkToggle(effectsPanel, 0, 8, false, currentAccent)
starBg.Position = UDim2.new(1,-50,0,8)

-- Sakura toggle
mkLabel(effectsPanel, "🌸  Sakura Rain", 12, 40, 160, 20, 13, WHITE, Enum.Font.GothamMedium)
local sakuraBg, sakuraKnob, sakuraHit = mkToggle(effectsPanel, 0, 40, false, currentAccent)
sakuraBg.Position = UDim2.new(1,-50,0,40)

-- ---- MENU SIZE ----
sSection("MENU SIZE", 7)
local sizePanel = Instance.new("Frame")
sizePanel.Size = UDim2.new(1,0,0,78); sizePanel.BackgroundColor3 = BG_PANEL
sizePanel.BackgroundTransparency = 0.4; sizePanel.LayoutOrder = 8
sizePanel.ZIndex = 11; sizePanel.Parent = sScroll; corner(sizePanel, 10)

mkLabel(sizePanel, "Width", 12, 8, 50, 16, 12, GRAY_LBL, Enum.Font.GothamMedium)
local widthMinus = Instance.new("TextButton")
widthMinus.Size = UDim2.fromOffset(28,22); widthMinus.Position = UDim2.fromOffset(68,8)
widthMinus.BackgroundColor3 = BG_INPUT; widthMinus.Text = "−"; widthMinus.Font = Enum.Font.GothamBlack
widthMinus.TextSize = 16; widthMinus.TextColor3 = WHITE; widthMinus.AutoButtonColor = false
widthMinus.ZIndex = 12; widthMinus.Parent = sizePanel; corner(widthMinus, 5)

local widthLbl = Instance.new("TextLabel")
widthLbl.BackgroundTransparency = 1; widthLbl.Position = UDim2.fromOffset(100,8)
widthLbl.Size = UDim2.fromOffset(50,22); widthLbl.Text = tostring(W)
widthLbl.Font = Enum.Font.GothamBlack; widthLbl.TextSize = 14; widthLbl.TextColor3 = WHITE
widthLbl.TextXAlignment = Enum.TextXAlignment.Center; widthLbl.ZIndex = 12; widthLbl.Parent = sizePanel

local widthPlus = Instance.new("TextButton")
widthPlus.Size = UDim2.fromOffset(28,22); widthPlus.Position = UDim2.fromOffset(154,8)
widthPlus.BackgroundColor3 = BG_INPUT; widthPlus.Text = "+"; widthPlus.Font = Enum.Font.GothamBlack
widthPlus.TextSize = 16; widthPlus.TextColor3 = WHITE; widthPlus.AutoButtonColor = false
widthPlus.ZIndex = 12; widthPlus.Parent = sizePanel; corner(widthPlus, 5)

mkLabel(sizePanel, "Height", 12, 44, 50, 16, 12, GRAY_LBL, Enum.Font.GothamMedium)
local heightMinus = Instance.new("TextButton")
heightMinus.Size = UDim2.fromOffset(28,22); heightMinus.Position = UDim2.fromOffset(68,44)
heightMinus.BackgroundColor3 = BG_INPUT; heightMinus.Text = "−"; heightMinus.Font = Enum.Font.GothamBlack
heightMinus.TextSize = 16; heightMinus.TextColor3 = WHITE; heightMinus.AutoButtonColor = false
heightMinus.ZIndex = 12; heightMinus.Parent = sizePanel; corner(heightMinus, 5)

local heightLbl = Instance.new("TextLabel")
heightLbl.BackgroundTransparency = 1; heightLbl.Position = UDim2.fromOffset(100,44)
heightLbl.Size = UDim2.fromOffset(50,22); heightLbl.Text = tostring(H_FULL)
heightLbl.Font = Enum.Font.GothamBlack; heightLbl.TextSize = 14; heightLbl.TextColor3 = WHITE
heightLbl.TextXAlignment = Enum.TextXAlignment.Center; heightLbl.ZIndex = 12; heightLbl.Parent = sizePanel

local heightPlus = Instance.new("TextButton")
heightPlus.Size = UDim2.fromOffset(28,22); heightPlus.Position = UDim2.fromOffset(154,44)
heightPlus.BackgroundColor3 = BG_INPUT; heightPlus.Text = "+"; heightPlus.Font = Enum.Font.GothamBlack
heightPlus.TextSize = 16; heightPlus.TextColor3 = WHITE; heightPlus.AutoButtonColor = false
heightPlus.ZIndex = 12; heightPlus.Parent = sizePanel; corner(heightPlus, 5)

-- ---- SAVE CONFIG ----
sSection("CONFIG", 9)
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1,0,0,36); saveBtn.BackgroundColor3 = currentAccent
saveBtn.Text = "💾  SAVE CONFIG"; saveBtn.Font = Enum.Font.GothamBlack
saveBtn.TextSize = 14; saveBtn.TextColor3 = WHITE; saveBtn.AutoButtonColor = false
saveBtn.ZIndex = 12; saveBtn.LayoutOrder = 10; saveBtn.Parent = sScroll; corner(saveBtn, 10)

-- ========================
-- MINI ACTIVATE
-- ========================
local miniActivate = Instance.new("TextButton")
miniActivate.Size = UDim2.new(1,-24,0,34); miniActivate.Position = UDim2.fromOffset(12,65)
miniActivate.BackgroundColor3 = currentAccent; miniActivate.Text = "ACTIVATE"
miniActivate.Font = Enum.Font.GothamBlack; miniActivate.TextSize = 15; miniActivate.TextColor3 = WHITE
miniActivate.AutoButtonColor = false; miniActivate.ZIndex = 5; miniActivate.Visible = false
miniActivate.Parent = Main; corner(miniActivate, 11)

-- ========================
-- PARTICLE SYSTEM
-- ========================
local activeParticles = {}

local function spawnParticle(isStars)
    local pw = Main.AbsoluteSize.X
    local p = Instance.new("TextLabel")
    p.BackgroundTransparency = 1
    p.ZIndex = 3; p.Font = Enum.Font.GothamBold
    if isStars then
        local stars = {"✦","★","✧","⭐","✩","*"}
        p.Text = stars[math.random(1,#stars)]
        p.TextSize = math.random(10, 20)
        p.TextColor3 = Color3.fromRGB(255, 255, math.random(180,255))
    else
        local sakuras = {"🌸","✿","❀","🌺","♣"}
        p.Text = sakuras[math.random(1,#sakuras)]
        p.TextSize = math.random(12, 22)
        p.TextColor3 = Color3.fromRGB(255, math.random(150,200), math.random(180,220))
    end
    local startX = math.random(0, math.max(1, pw - 20))
    p.Position = UDim2.fromOffset(startX, -20)
    p.Size = UDim2.fromOffset(20, 20)
    p.Parent = particleContainer

    local speed = math.random(60, 160)
    local drift = math.random(-20, 20)
    local life  = 0
    local maxLife = (H_FULL + 40) / speed

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        life += dt
        if life > maxLife or not p.Parent then
            conn:Disconnect()
            pcall(function() p:Destroy() end)
            for i, v in ipairs(activeParticles) do
                if v == conn then table.remove(activeParticles, i); break end
            end
            return
        end
        local px = startX + drift * (life/maxLife)
        local py = -20 + speed * life
        p.Position = UDim2.fromOffset(px, py)
        p.TextTransparency = life > maxLife*0.7 and ((life - maxLife*0.7)/(maxLife*0.3)) or 0
    end)
    table.insert(activeParticles, conn)
end

local function clearParticles()
    for _, c in ipairs(activeParticles) do pcall(function() c:Disconnect() end) end
    activeParticles = {}
    for _, ch in ipairs(particleContainer:GetChildren()) do ch:Destroy() end
end

local function startStarRain()
    starRainOn = true
    starBg.BackgroundColor3 = currentAccent
    TweenService:Create(starKnob, TweenInfo.new(0.15), {Position = UDim2.fromOffset(25,3)}):Play()
    starConn = RunService.Heartbeat:Connect(function()
        if math.random() < 0.08 then spawnParticle(true) end
    end)
end
local function stopStarRain()
    starRainOn = false
    starBg.BackgroundColor3 = Color3.fromRGB(70,70,90)
    TweenService:Create(starKnob, TweenInfo.new(0.15), {Position = UDim2.fromOffset(3,3)}):Play()
    if starConn then starConn:Disconnect(); starConn = nil end
end

local function startSakura()
    sakuraOn = true
    sakuraBg.BackgroundColor3 = currentAccent
    TweenService:Create(sakuraKnob, TweenInfo.new(0.15), {Position = UDim2.fromOffset(25,3)}):Play()
    sakuraConn = RunService.Heartbeat:Connect(function()
        if math.random() < 0.06 then spawnParticle(false) end
    end)
end
local function stopSakura()
    sakuraOn = false
    sakuraBg.BackgroundColor3 = Color3.fromRGB(70,70,90)
    TweenService:Create(sakuraKnob, TweenInfo.new(0.15), {Position = UDim2.fromOffset(3,3)}):Play()
    if sakuraConn then sakuraConn:Disconnect(); sakuraConn = nil end
end

starHit.MouseButton1Click:Connect(function()
    if starRainOn then stopStarRain() else startStarRain() end
end)
sakuraHit.MouseButton1Click:Connect(function()
    if sakuraOn then stopSakura() else startSakura() end
end)

-- ========================
-- ACCENT APPLY
-- ========================
local function applyAccent(col)
    currentAccent = col
    mainStroke.Color = col
    -- neon dots rəngi (ağ qalır — neon görünüşü üçün)
    toggleBg.BackgroundColor3 = brainrotOn and col or Color3.fromRGB(70,70,90)
    ActivateBtn.BackgroundColor3 = lagging and RED_OFF or col
    miniActivate.BackgroundColor3 = lagging and RED_OFF or col
    saveBtn.BackgroundColor3 = col
    bgOffStroke.Color  = (currentBgIdx == 0) and col or BORDER
    bgOffStroke.Transparency = (currentBgIdx == 0) and 0.0 or 0.6
    for i, data in ipairs(bgImgBtns) do
        data.stk.Color = (i == currentBgIdx) and col or BORDER
        data.stk.Transparency = (i == currentBgIdx) and 0.0 or 0.6
    end
    for i, data in ipairs(themeBtns) do
        data.stk.Transparency = (i == currentThemeIdx) and 0.0 or 1.0
    end
    if starRainOn  then starBg.BackgroundColor3  = col end
    if sakuraOn    then sakuraBg.BackgroundColor3 = col end
end

local function startRainbow()
    if rainbowConn then rainbowConn:Disconnect() end
    rainbowConn = RunService.Heartbeat:Connect(function()
        local t = tick() * 0.4
        local col = Color3.new(
            math.abs(math.sin(t)),
            math.abs(math.sin(t+2.09)),
            math.abs(math.sin(t+4.19))
        )
        currentAccent = col
        mainStroke.Color = col
        toggleBg.BackgroundColor3 = brainrotOn and col or Color3.fromRGB(70,70,90)
        ActivateBtn.BackgroundColor3 = lagging and RED_OFF or col
        miniActivate.BackgroundColor3 = lagging and RED_OFF or col
        saveBtn.BackgroundColor3 = col
        themeBtns[9].btn.BackgroundColor3 = col
        if starRainOn  then starBg.BackgroundColor3  = col end
        if sakuraOn    then sakuraBg.BackgroundColor3 = col end
    end)
end
local function stopRainbow()
    if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
end

for i, data in ipairs(themeBtns) do
    data.btn.MouseButton1Click:Connect(function()
        currentThemeIdx = i; stopRainbow()
        if THEMES[i].name == "Rainbow" then startRainbow()
        else applyAccent(THEMES[i].accent) end
    end)
end

-- ========================
-- BG SELECT
-- ========================
local function selectBg(idx)
    currentBgIdx = idx
    bgImg.Image = (idx == 0) and "" or BG_IMAGES[idx]
    bgOffStroke.Color = (idx==0) and currentAccent or BORDER
    bgOffStroke.Transparency = (idx==0) and 0.0 or 0.6
    for i, data in ipairs(bgImgBtns) do
        data.stk.Color = (i==idx) and currentAccent or BORDER
        data.stk.Transparency = (i==idx) and 0.0 or 0.6
    end
end
bgOffBtn.MouseButton1Click:Connect(function() selectBg(0) end)
for i, data in ipairs(bgImgBtns) do
    data.btn.MouseButton1Click:Connect(function() selectBg(i) end)
end

-- ========================
-- SIZE CONTROLS
-- ========================
local function resizeMenu()
    widthLbl.Text = tostring(W); heightLbl.Text = tostring(H_FULL)
    if not isCollapsed then Main.Size = UDim2.fromOffset(W, H_FULL)
    else Main.Size = UDim2.fromOffset(W, H_MINI) end
    miniActivate.Size = UDim2.new(1,-24,0,34)
end
widthMinus.MouseButton1Click:Connect(function() W = math.clamp(W-10,MIN_W,MAX_W); resizeMenu() end)
widthPlus.MouseButton1Click:Connect(function()  W = math.clamp(W+10,MIN_W,MAX_W); resizeMenu() end)
heightMinus.MouseButton1Click:Connect(function() H_FULL = math.clamp(H_FULL-10,MIN_H,MAX_H); resizeMenu() end)
heightPlus.MouseButton1Click:Connect(function()  H_FULL = math.clamp(H_FULL+10,MIN_H,MAX_H); resizeMenu() end)

-- ========================
-- HELPERS
-- ========================
local function formatPower(v) return (v>=1000) and (math.floor(v/1000).."K") or tostring(v) end
local function parsePower(s)
    s = tostring(s):upper():gsub("%s","")
    local k = s:match("^(%d+%.?%d*)K$")
    if k then return math.floor(tonumber(k)*1000) end
    return tonumber(s) and math.floor(tonumber(s)) or nil
end
local function clampPower(v) return v and math.clamp(v,1000,150000) or intensity end

-- ========================
-- PACKET LAGGER
-- ========================
local function startLagging()
    if lagging then return end
    intensity = clampPower(parsePower(PowerBox.Text) or intensity)
    PowerBox.Text = formatPower(intensity); lagging = true
    ActivateBtn.Text = "DEACTIVATE"; ActivateBtn.BackgroundColor3 = RED_OFF
    miniActivate.Text = "DEACTIVATE"; miniActivate.BackgroundColor3 = RED_OFF
    lagThread = task.spawn(function()
        local payload = table.create(intensity, function() end)
        while lagging do
            if net then for _=1,3 do pcall(function() net:FireServer(payload) end) end end
            task.wait(0.01)
        end
    end)
end
local function stopLagging()
    if not lagging then return end
    lagging = false
    if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
    ActivateBtn.Text = "ACTIVATE"; ActivateBtn.BackgroundColor3 = currentAccent
    miniActivate.Text = "ACTIVATE"; miniActivate.BackgroundColor3 = currentAccent
end

-- ========================
-- CFRAME WALK
-- ========================
local function startWalk()
    walking = true; WalkBtn.Text = "WALK ON"; WalkBtn.BackgroundColor3 = GREEN_ON
    local studs = tonumber(studsBox.Text) or 3
    local delay = tonumber(delayBox.Text) or 0.06
    walkThread = task.spawn(function()
        while walking do
            local char = LP.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0.1 then
                pcall(function() hrp.CFrame = hrp.CFrame + hum.MoveDirection * studs end)
            end
            task.wait(delay)
        end
    end)
end
local function stopWalk()
    walking = false; WalkBtn.Text = "WALK OFF"; WalkBtn.BackgroundColor3 = RED_OFF
    if walkThread then pcall(task.cancel, walkThread); walkThread = nil end
end

WalkBtn.MouseButton1Click:Connect(function()
    if walking then stopWalk() else startWalk() end
end)

local function doActivate()
    if clickLock then return end; clickLock = true
    if lagging then stopLagging()
    else
        startLagging()
        if brainrotOn and not walking then startWalk() end
    end
    task.delay(0.15, function() clickLock = false end)
end
ActivateBtn.MouseButton1Click:Connect(doActivate)
miniActivate.MouseButton1Click:Connect(doActivate)

-- Brainrot toggle
local function updateToggle()
    toggleBg.BackgroundColor3 = brainrotOn and currentAccent or Color3.fromRGB(70,70,90)
    TweenService:Create(toggleKnob, TweenInfo.new(0.15), {
        Position = brainrotOn and UDim2.fromOffset(25,3) or UDim2.fromOffset(3,3)
    }):Play()
end
toggleHit.MouseButton1Click:Connect(function()
    brainrotOn = not brainrotOn; updateToggle()
    if not brainrotOn and walking then stopWalk() end
end)
updateToggle()

KeyBtn.MouseButton1Click:Connect(function()
    listeningForKey = true; KeyBtn.Text = "..."; KeyBtn.TextColor3 = WHITE
end)

PowerBox.FocusLost:Connect(function()
    intensity = clampPower(parsePower(PowerBox.Text)); PowerBox.Text = formatPower(intensity)
end)

-- ========================
-- MINIMIZE
-- ========================
local function setMini(mini)
    isCollapsed = mini
    if mini then
        minBtn.Text = "+"; content.Visible = false; settingsPanel.Visible = false
        miniActivate.Visible = true
        miniActivate.Text = lagging and "DEACTIVATE" or "ACTIVATE"
        miniActivate.BackgroundColor3 = lagging and RED_OFF or currentAccent
        TweenService:Create(Main, TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(W, H_MINI)
        }):Play()
    else
        minBtn.Text = "−"; miniActivate.Visible = false
        TweenService:Create(Main, TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(W, H_FULL)
        }):Play()
        task.delay(0.18, function() content.Visible = true end)
    end
end
minBtn.MouseButton1Click:Connect(function() setMini(not isCollapsed) end)
settingsBtn.MouseButton1Click:Connect(function() settingsPanel.Visible = not settingsPanel.Visible end)
sClose.MouseButton1Click:Connect(function() settingsPanel.Visible = false end)

-- ========================
-- DRAGGING
-- ========================
local dragging, dragStart, startPos
local function onDragBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        if settingsPanel.Visible then return end
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end
header.InputBegan:Connect(onDragBegan); Main.InputBegan:Connect(onDragBegan)
UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X,
                                   startPos.Y.Scale, startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- ========================
-- KEYBIND
-- ========================
UIS.InputBegan:Connect(function(input, gpe)
    if listeningForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            listeningForKey = false; toggleKeyName = input.KeyCode.Name
            local ok, key = pcall(function() return Enum.KeyCode[toggleKeyName] end)
            toggleKey = (ok and key) or Enum.KeyCode.Three
            KeyBtn.Text = toggleKeyName; KeyBtn.TextColor3 = Color3.fromRGB(255,200,50)
        end
        return
    end
    if gpe then return end
    if input.KeyCode == toggleKey then doActivate() end
end)

-- ========================
-- CONFIG SAVE / LOAD
-- ========================
local function saveConfig()
    pcall(function()
        if not writefile then return end
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            Power    = intensity, Keybind  = toggleKeyName,
            ThemeIdx = currentThemeIdx, BgIdx = currentBgIdx,
            Width    = W, Height = H_FULL,
            StarRain = starRainOn, Sakura = sakuraOn,
        }))
    end)
end
local function loadConfig()
    pcall(function()
        if not (readfile and isfile and isfile(CONFIG_FILE)) then return end
        local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if not (ok and type(cfg)=="table") then return end
        if tonumber(cfg.Power) then intensity = clampPower(tonumber(cfg.Power)); PowerBox.Text = formatPower(intensity) end
        if type(cfg.Keybind)=="string" and cfg.Keybind~="" then
            toggleKeyName = cfg.Keybind
            local ok2, key = pcall(function() return Enum.KeyCode[toggleKeyName] end)
            toggleKey = (ok2 and key) or Enum.KeyCode.Three
            KeyBtn.Text = toggleKeyName; KeyBtn.TextColor3 = Color3.fromRGB(255,200,50)
        end
        if tonumber(cfg.ThemeIdx) then
            local idx = math.clamp(math.floor(tonumber(cfg.ThemeIdx)),1,#THEMES)
            currentThemeIdx = idx
            if THEMES[idx].name=="Rainbow" then startRainbow() else applyAccent(THEMES[idx].accent) end
        end
        if tonumber(cfg.BgIdx) then selectBg(math.clamp(math.floor(tonumber(cfg.BgIdx)),0,#BG_IMAGES)) end
        if tonumber(cfg.Width)  then W      = math.clamp(math.floor(tonumber(cfg.Width)),  MIN_W,MAX_W) end
        if tonumber(cfg.Height) then H_FULL = math.clamp(math.floor(tonumber(cfg.Height)), MIN_H,MAX_H) end
        resizeMenu()
        if cfg.StarRain then startStarRain() end
        if cfg.Sakura   then startSakura()   end
    end)
end

saveBtn.MouseButton1Click:Connect(function()
    saveConfig(); saveBtn.Text = "✓  SAVED!"
    task.delay(1.5, function() saveBtn.Text = "💾  SAVE CONFIG" end)
end)

-- ========================
-- INIT
-- ========================
task.defer(function()
    loadConfig()
    applyAccent(currentAccent)
    selectBg(currentBgIdx)
end)

print("[SPLUNKY PACKET] Loaded ✓")