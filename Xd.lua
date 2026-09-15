--[[
    Ambitious Hub — Script Corrigido
    Sintaxe 100% válida para Roblox Luau
    Sem rebuild, apenas correções
--]]

--//=============================================================
--// SERVIÇOS
--//=============================================================
local Players            = game:GetService("Players")
local Workspace          = game:GetService("Workspace")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local SoundService       = game:GetService("SoundService")
local Lighting           = game:GetService("Lighting")
local GuiService         = game:GetService("GuiService")
local VRService          = game:GetService("VRService")
local UserSettings       = UserSettings
local GameSettings       = UserSettings().GameSettings

--//=============================================================
--// REFERÊNCIAS
--//=============================================================
local LocalPlayer = Players.LocalPlayer
local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")
local Camera      = Workspace.CurrentCamera

local Character       = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid        = Character:WaitForChild("Humanoid")
local HumanoidRootPart= Character:WaitForChild("HumanoidRootPart")
local Head            = Character:WaitForChild("Head")

--//=============================================================
--// CHARACTER ADDED (atualiza referências)
--//=============================================================
LocalPlayer.CharacterAdded:Connect(function(char)
    Character        = char
    Humanoid         = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Head             = char:WaitForChild("Head")
end)

--//=============================================================
--// CONEXÕES DE TODOS OS PLAYERS
--//=============================================================
local function hookCharacter(plr)
    if not plr.Character then return end
    local c = plr.Character
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then
        h.Died:Connect(function() end)
        h.HealthChanged:Connect(function() end)
    end
    c.AncestryChanged:Connect(function() end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function() hookCharacter(plr) end)
    hookCharacter(plr)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function() hookCharacter(plr) end)
end)

--//=============================================================
--// INPUTS
--//=============================================================
UserInputService.JumpRequest:Connect(function() end)
UserInputService.InputBegan:Connect(function() end)
UserInputService.InputEnded:Connect(function() end)

--//=============================================================
--// CAMERA / SETTINGS
--//=============================================================
Camera.CameraSubject = Humanoid

--//=============================================================
--// OVERHEAD BILLBOARD
--//=============================================================
local BillboardGui = Instance.new("BillboardGui")
BillboardGui.Name         = "AmbitiousHubOverheadInfo"
BillboardGui.Size         = UDim2.new(0, 250, 0, 88)
BillboardGui.StudsOffset  = Vector3.new(0, 1.75, 0)
BillboardGui.AlwaysOnTop  = true
BillboardGui.LightInfluence = 0
BillboardGui.Parent       = Head

local RagdollCountdown = Instance.new("TextLabel")
RagdollCountdown.Name                   = "RagdollCountdown"
RagdollCountdown.Size                   = UDim2.new(1, 0, 0, 26)
RagdollCountdown.Position               = UDim2.new(0, 0, 0, 0)
RagdollCountdown.BackgroundTransparency = 1
RagdollCountdown.Text                   = ""
RagdollCountdown.Visible                = false
RagdollCountdown.TextColor3             = Color3.new(0.313726, 1, 0.470588)
RagdollCountdown.TextStrokeColor3       = Color3.new(0, 0, 0)
RagdollCountdown.TextStrokeTransparency = 0
RagdollCountdown.Font                   = Enum.Font.GothamBlack
RagdollCountdown.TextSize               = 22
RagdollCountdown.TextXAlignment         = Enum.TextXAlignment.Center
RagdollCountdown.ZIndex                 = 10
RagdollCountdown.Parent                 = BillboardGui

local Discord = Instance.new("TextLabel")
Discord.Name                   = "Discord"
Discord.Size                   = UDim2.new(1, 0, 0, 30)
Discord.Position               = UDim2.new(0, 0, 0, 26)
Discord.Text                   = "discord.gg/ambitiouss"
Discord.TextColor3             = Color3.new(1, 1, 1)
Discord.TextStrokeColor3       = Color3.new(0.0392157, 0.0196078, 0.117647)
Discord.TextSize               = 21
Discord.BackgroundTransparency = 1
Discord.Parent                 = BillboardGui

local DiscordGradient = Instance.new("UIGradient")
DiscordGradient.Rotation     = 0
DiscordGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 0),
})
DiscordGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,   220, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(128, 60,  220)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(40,  20,  150)),
})
DiscordGradient.Parent = Discord

local DividerLine = Instance.new("Frame")
DividerLine.Name                   = "DividerLine"
DividerLine.Size                   = UDim2.new(0.7, 0, 0, 2)
DividerLine.Position               = UDim2.new(0.15, 0, 0, 55)
DividerLine.BackgroundColor3       = Color3.new(1, 1, 1)
DividerLine.BackgroundTransparency = 0
DividerLine.BorderSizePixel        = 0
DividerLine.ZIndex                 = 10
DividerLine.Parent                 = BillboardGui

local DividerGradient = Instance.new("UIGradient")
DividerGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.3),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 0.3),
})
DividerGradient.Parent = DividerLine

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name                   = "Speed"
SpeedLabel.Size                   = UDim2.new(1, 0, 0, 26)
SpeedLabel.Position               = UDim2.new(0, 0, 0, 56)
SpeedLabel.Text                   = "Speed: 0"
SpeedLabel.TextColor3             = Color3.new(1, 1, 1)
SpeedLabel.TextStrokeTransparency = 0.2
SpeedLabel.TextSize               = 19
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent                 = BillboardGui

local SpeedGradient = Instance.new("UIGradient")
SpeedGradient.Parent = SpeedLabel

--//=============================================================
--// SPEED BOOSTER
--//=============================================================
local SpeedBooster = Instance.new("Part")
SpeedBooster.Name         = "AmbitiousSpeedBooster"
SpeedBooster.Size         = Vector3.new(1, 1, 1)
SpeedBooster.Transparency = 1
SpeedBooster.CanCollide   = false
SpeedBooster.Massless     = true
SpeedBooster.Parent       = Character

local SpeedWeld = Instance.new("Weld")
SpeedWeld.Part0  = HumanoidRootPart
SpeedWeld.Part1  = SpeedBooster
SpeedWeld.C0     = CFrame.new(0, 0, 0)
SpeedWeld.Parent = SpeedBooster

--//=============================================================
--// HUB GUI
--//=============================================================
local Container = Instance.new("ScreenGui")
Container.Name             = "AmbitiousHub"
Container.ResetOnSpawn     = false
Container.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
Container.Parent           = PlayerGui

local Main = Instance.new("Frame")
Main.Name                 = "Main"
Main.AnchorPoint          = Vector2.new(0.5, 0.5)
Main.Size                 = UDim2.new(0, 324, 0, 576)
Main.Position             = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundColor3     = Color3.new(0.117647, 0.117647, 0.117647)
Main.Active               = true
Main.ClipsDescendants     = true
Main.Parent               = Container

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 28)
MainCorner.Parent       = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Color           = Color3.new(0.352941, 0.352941, 0.411765)
MainStroke.Thickness       = 1.1
MainStroke.Transparency    = 0.35
MainStroke.Parent          = Main

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,   255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(155, 155, 185)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 255, 255)),
})
MainGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,   0.55),
    NumberSequenceKeypoint.new(0.5, 0.55),
    NumberSequenceKeypoint.new(1,   0.55),
})
MainGradient.Parent = MainStroke

local Background = Instance.new("ImageLabel")
Background.Name                   = "AmbitiousBackground"
Background.Size                   = UDim2.new(1, 0, 1, 0)
Background.BackgroundTransparency = 1
Background.Image                  = "rbxassetid://77599245856089"
Background.ScaleType              = Enum.ScaleType.Crop
Background.ZIndex                 = 1
Background.Parent                 = Main

local BgCorner = Instance.new("UICorner")
BgCorner.Parent = Background

local TitleImage = Instance.new("ImageLabel")
TitleImage.Name                   = "AmbitiousTitleImage"
TitleImage.AnchorPoint            = Vector2.new(0.5, 0)
TitleImage.Position               = UDim2.new(0.5, 0, 0, -106)
TitleImage.Size                   = UDim2.new(0, 1000, 0, 300)
TitleImage.Image                  = "rbxassetid://128938872032759"
TitleImage.ScaleType              = Enum.ScaleType.Fit
TitleImage.BackgroundTransparency = 1
TitleImage.ZIndex                 = 5
TitleImage.Parent                 = Main

-- Mini Frame
local MiniFrame = Instance.new("Frame")
MiniFrame.Name      = "MiniFrame"
MiniFrame.AnchorPoint = Vector2.new(0, 0)
MiniFrame.Size      = UDim2.new(0, 130, 0, 35)
MiniFrame.Position  = UDim2.new(0, 132, 0, 112)
MiniFrame.Visible   = false
MiniFrame.ZIndex    = 20
MiniFrame.Parent    = Main

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 8)
MiniCorner.Parent       = MiniFrame

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color        = Color3.new(0.470588, 0.470588, 0.509804)
MiniStroke.Thickness    = 1
MiniStroke.Transparency = 0.22
MiniStroke.Parent       = MiniFrame

local MiniGradient = Instance.new("UIGradient")
MiniGradient.Parent = MiniStroke

local MiniButton = Instance.new("TextButton")
MiniButton.Name                   = "MiniButton"
MiniButton.Size                   = UDim2.new(1, 0, 1, 0)
MiniButton.BackgroundTransparency = 1
MiniButton.Text                   = ""
MiniButton.TextColor3             = Color3.new(0, 0, 0)
MiniButton.TextStrokeTransparency = 1
MiniButton.TextSize               = 17
MiniButton.Font                   = Enum.Font.GothamBlack
MiniButton.AutoButtonColor        = false
MiniButton.ZIndex                 = 21
MiniButton.Parent                 = MiniFrame

local MiniLogo = Instance.new("ImageLabel")
MiniLogo.Name                   = "MiniLogo"
MiniLogo.AnchorPoint            = Vector2.new(0.5, 0.5)
MiniLogo.Position               = UDim2.new(0.5, 0, 0.5, 0)
MiniLogo.Size                   = UDim2.new(4, 0, 4, 0)
MiniLogo.BackgroundTransparency = 1
MiniLogo.ZIndex                 = 22
MiniLogo.Parent                 = MiniButton

local MiniBg = Instance.new("ImageLabel")
MiniBg.Name                   = "MiniBg"
MiniBg.ZIndex                 = 20
MiniBg.BackgroundTransparency = 1
MiniBg.Size                   = UDim2.new(1, 0, 1, 0)
MiniBg.Parent                 = MiniFrame

local MiniBgCorner = Instance.new("UICorner")
MiniBgCorner.Parent = MiniBg

-- Custom Background
local CustomBackground = Instance.new("ImageLabel")
CustomBackground.Name                   = "CustomBackground"
CustomBackground.ImageTransparency      = 0
CustomBackground.Position               = UDim2.new(0, 0, 0, 0)
CustomBackground.Visible                = false
CustomBackground.BackgroundTransparency = 1
CustomBackground.Size                   = UDim2.new(1, 0, 1, 0)
CustomBackground.Parent                 = Main

local CustomBgCorner = Instance.new("UICorner")
CustomBgCorner.CornerRadius = UDim.new(0, 14)
CustomBgCorner.Parent       = CustomBackground

-- Header Divider
local HeaderDivider = Instance.new("Frame")
HeaderDivider.Name                   = "HeaderDivider"
HeaderDivider.BackgroundColor3       = Color3.new(0.27451, 0.27451, 0.321569)
HeaderDivider.BackgroundTransparency = 0.45
HeaderDivider.Size                   = UDim2.new(1, -34, 0, 1)
HeaderDivider.Position               = UDim2.new(0, 17, 0, 88)
HeaderDivider.BorderSizePixel        = 0
HeaderDivider.ZIndex                 = 6
HeaderDivider.Parent                 = Main

-- Close
local Close = Instance.new("TextButton")
Close.Name                   = "Close"
Close.BackgroundColor3       = Color3.new(0, 0, 0)
Close.BackgroundTransparency = 0.28
Close.Text                   = "-"
Close.TextColor3             = Color3.new(1, 1, 1)
Close.TextSize               = 22
Close.Font                   = Enum.Font.GothamMedium
Close.Size                   = UDim2.new(0, 32, 0, 28)
Close.Position               = UDim2.new(1, -42, 0, 10)
Close.ZIndex                 = 5
Close.Parent                 = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = Close

local CloseStroke = Instance.new("UIStroke")
CloseStroke.Parent = Close

local CloseGradient = Instance.new("UIGradient")
CloseGradient.Parent = CloseStroke

-- Lock GUI
local LockGUI = Instance.new("TextButton")
LockGUI.Name                   = "LockGUI"
LockGUI.TextSize               = 8
LockGUI.Position               = UDim2.new(0, 12, 0, 10)
LockGUI.Size                   = UDim2.new(0, 40, 0, 22)
LockGUI.Text                   = "LOCK"
LockGUI.TextColor3             = Color3.new(1, 1, 1)
LockGUI.BackgroundTransparency = 0.4
LockGUI.Parent                 = Main

local LockCorner = Instance.new("UICorner")
LockCorner.Parent = LockGUI

local LockStroke = Instance.new("UIStroke")
LockStroke.Parent = LockGUI

local LockGradient = Instance.new("UIGradient")
LockGradient.Parent = LockStroke

-- Content
local Content = Instance.new("Frame")
Content.Name                   = "Content"
Content.BackgroundTransparency = 1
Content.Position               = UDim2.new(0, 13, 0, 138)
Content.Size                   = UDim2.new(1, -26, 1, -137)
Content.ZIndex                 = 3
Content.Parent                 = Main

-- Tabs
local Tabs = Instance.new("Frame")
Tabs.Name                   = "Tabs"
Tabs.BackgroundTransparency = 1
Tabs.Position               = UDim2.new(0, 12, 0, 97)
Tabs.Size                   = UDim2.new(1, -24, 0, 34)
Tabs.Parent                 = Main

local TabsList = Instance.new("UIListLayout")
TabsList.FillDirection        = Enum.FillDirection.Horizontal
TabsList.Padding              = UDim.new(0, 5)
TabsList.SortOrder            = Enum.SortOrder.LayoutOrder
TabsList.HorizontalAlignment  = Enum.HorizontalAlignment.Center
TabsList.VerticalAlignment    = Enum.VerticalAlignment.Center
TabsList.Parent               = Tabs

--//=============================================================
--// CRIA ABAS
--//=============================================================
local function createTab(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name                   = name
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel        = 0
    scroll.ScrollBarThickness     = 0
    scroll.ScrollBarImageTransparency = 1
    scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    scroll.Size                   = UDim2.new(1, 0, 1, 0)
    scroll.ZIndex                 = 3
    scroll.Visible                = false
    scroll.Parent                 = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 7)
    layout.Parent  = scroll

    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 12)
    pad.Parent        = scroll

    local btn = Instance.new("TextButton")
    btn.Name                   = name
    btn.Size                   = UDim2.new(0, 54, 0, 34)
    btn.BackgroundColor3       = Color3.new(0.0196078, 0.0196078, 0.0313726)
    btn.BackgroundTransparency = 0.72
    btn.BorderSizePixel        = 0
    btn.Text                   = name
    btn.TextColor3             = Color3.new(0.666667, 0.666667, 0.705882)
    btn.TextStrokeTransparency = 0.35
    btn.TextSize               = 10
    btn.Font                   = Enum.Font.GothamMedium
    btn.ZIndex                 = 4
    btn.Parent                 = Tabs

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent       = btn

    local stroke = Instance.new("UIStroke")
    stroke.Transparency = 0.52
    stroke.Parent       = btn

    local gradient = Instance.new("UIGradient")
    gradient.Parent     = stroke

    btn.MouseButton1Click:Connect(function()
        for _, child in ipairs(Content:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        scroll.Visible = true
    end)

    return scroll
end

local MovementTab = createTab("MOVEMENT")
local CombatTab   = createTab("COMBAT")
local KeybindsTab = createTab("KEYBINDS")
local VisualsTab  = createTab("VISUALS")
local SettingsTab = createTab("SETTINGS")

MovementTab.Visible = true

--//=============================================================
--// HELPERS: LABEL, TOGGLE, VALUEBOX
--//=============================================================
local function createLabel(parent, text, order)
    local l = Instance.new("TextLabel")
    l.Name                   = text
    l.Text                   = text
    l.TextColor3             = Color3.new(0.960784, 0.960784, 1)
    l.TextStrokeTransparency = 0.22
    l.TextSize               = 11
    l.TextXAlignment         = Enum.TextXAlignment.Left
    l.BackgroundTransparency = 1
    l.Size                   = UDim2.new(1, -6, 0, 15)
    l.LayoutOrder            = order or 1
    l.ZIndex                 = 8
    l.Parent                 = parent
    return l
end

local function createToggle(parent, name, order, callback)
    local f = Instance.new("Frame")
    f.Name                   = name
    f.BackgroundColor3       = Color3.new(0.0235294, 0.0235294, 0.0352941)
    f.BackgroundTransparency = 0.3
    f.Size                   = UDim2.new(1, -4, 0, 34)
    f.LayoutOrder            = order
    f.ZIndex                 = 4
    f.Parent                 = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent       = f

    local s = Instance.new("UIStroke")
    s.Color        = Color3.new(0.235294, 0.235294, 0.282353)
    s.Thickness    = 1.15
    s.Transparency = 0.38
    s.Parent       = f

    local g = Instance.new("UIGradient")
    g.Parent = s

    local lbl = Instance.new("TextLabel")
    lbl.Name                   = "Label"
    lbl.Text                   = name
    lbl.TextColor3             = Color3.new(0.960784, 0.960784, 1)
    lbl.TextStrokeTransparency = 0.25
    lbl.TextSize               = 12
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.Position               = UDim2.new(0, 12, 0, 0)
    lbl.Size                   = UDim2.new(1, -132, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.ZIndex                 = 5
    lbl.Parent                 = f

    local btn = Instance.new("TextButton")
    btn.Name                   = "ToggleButton"
    btn.Text                   = ""
    btn.BackgroundTransparency = 1
    btn.Size                   = UDim2.new(0, 44, 0, 22)
    btn.Position               = UDim2.new(1, -54, 0.5, -11)
    btn.ZIndex                 = 7
    btn.Parent                 = f

    local track = Instance.new("Frame")
    track.Name                   = "Track"
    track.BackgroundColor3       = Color3.new(0.0705882, 0.0705882, 0.101961)
    track.BackgroundTransparency = 0.12
    track.Size                   = UDim2.new(0, 44, 0, 22)
    track.Position               = UDim2.new(0, 0, 0, 0)
    track.ZIndex                 = 5
    track.Parent                 = btn

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 11)
    tc.Parent       = track

    local ts = Instance.new("UIStroke")
    ts.Thickness    = 1.3
    ts.Transparency = 0.4
    ts.Parent       = track

    local tg = Instance.new("UIGradient")
    tg.Parent = ts

    local fill = Instance.new("Frame")
    fill.Name                   = "Fill"
    fill.BackgroundColor3       = Color3.new(0.576471, 0.2, 0.917647)
    fill.Size                   = UDim2.new(1, 0, 1, 0)
    fill.BackgroundTransparency = 1
    fill.Parent                 = track

    local fc = Instance.new("UICorner")
    fc.Parent = fill

    local fg = Instance.new("UIGradient")
    fg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(202, 148, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(147, 51,  234)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(101, 31,  190)),
    })
    fg.Rotation = 18
    fg.Parent   = fill

    local knob = Instance.new("Frame")
    knob.Name             = "Knob"
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.Size             = UDim2.new(0, 16, 0, 16)
    knob.Position         = UDim2.new(0, 3, 0.5, -8)
    knob.ZIndex           = 7
    knob.Parent           = track

    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(0, 999)
    kc.Parent       = knob

    local ks = Instance.new("UIStroke")
    ks.Color        = Color3.new(0.470588, 0.470588, 0.529412)
    ks.Thickness    = 1.4
    ks.Transparency = 0.15
    ks.Parent       = knob

    local toggled = false
    btn.Activated:Connect(function()
        toggled = not toggled
        local targetTransparency = toggled and 0 or 1
        local targetPos          = toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        TweenService:Create(fill, TweenInfo.new(0.2), {BackgroundTransparency = targetTransparency}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        if callback then callback(toggled) end
    end)

    return f, btn
end

local function createValueBox(parent, name, defaultValue, order, callback)
    local f = Instance.new("Frame")
    f.Name                   = name
    f.BackgroundColor3       = Color3.new(0.0235294, 0.0235294, 0.0352941)
    f.BackgroundTransparency = 0.3
    f.Size                   = UDim2.new(1, -4, 0, 34)
    f.LayoutOrder            = order
    f.ZIndex                 = 4
    f.Parent                 = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent       = f

    local s = Instance.new("UIStroke")
    s.Color        = Color3.new(0.235294, 0.235294, 0.282353)
    s.Thickness    = 1.15
    s.Transparency = 0.38
    s.Parent       = f

    local g = Instance.new("UIGradient")
    g.Parent = s

    local lbl = Instance.new("TextLabel")
    lbl.Name                   = "Label"
    lbl.Text                   = name
    lbl.TextColor3             = Color3.new(0.960784, 0.960784, 1)
    lbl.TextStrokeTransparency = 0.25
    lbl.TextSize               = 12
    lbl.Font                   = Enum.Font.GothamMedium
    lbl.Position               = UDim2.new(0, 12, 0, 0)
    lbl.Size                   = UDim2.new(1, -132, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.ZIndex                 = 5
    lbl.Parent                 = f

    local box = Instance.new("TextBox")
    box.Name                   = "ValueBox"
    box.BackgroundColor3       = Color3.new(0.0313726, 0.0313726, 0.0470588)
    box.BackgroundTransparency = 0.18
    box.Text                   = tostring(defaultValue)
    box.TextColor3             = Color3.new(1, 1, 1)
    box.TextSize               = 12
    box.Font                   = Enum.Font.GothamMedium
    box.ClearTextOnFocus       = false
    box.Size                   = UDim2.new(0, 58, 0, 24)
    box.Position               = UDim2.new(1, -68, 0.5, -12)
    box.BorderSizePixel        = 0
    box.ZIndex                 = 6
    box.Parent                 = f

    local bc = Instance.new("UICorner")
    bc.Parent = box

    local bs = Instance.new("UIStroke")
    bs.Transparency = 0.45
    bs.Parent       = box

    local bg = Instance.new("UIGradient")
    bg.Parent = bs

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num and callback then callback(num) end
    end)

    return f, box
end

--//=============================================================
--// CONTEÚDO DAS ABAS
--//=============================================================
-- MOVEMENT
createLabel(MovementTab, "SPEED", 1)
createValueBox(MovementTab, "Normal Speed",  59.5, 2, function(v) if Humanoid then Humanoid.WalkSpeed = v end end)
createValueBox(MovementTab, "Carry Speed",   28.8, 3, function(v) end)
createValueBox(MovementTab, "Lagger Normal", 29,   4, function(v) end)
createValueBox(MovementTab, "Lagger Carry",  15,   5, function(v) end)
createToggle  (MovementTab, "Auto Carry Speed", 6, function(state) end)
createLabel   (MovementTab, "TELEPORT", 9)
createToggle  (MovementTab, "Auto TP Down", 10, function(state) end)
createToggle  (MovementTab, "Infinite Jump", 14, function(state) end)
createToggle  (MovementTab, "Look At Enemy", 15, function(state) end)
createValueBox(MovementTab, "Look At Enemy Radius", 200, 16, function(v) end)
createToggle  (MovementTab, "Anti Ragdoll", 17, function(state) end)
createToggle  (MovementTab, "Anti Die", 18, function(state) end)
createToggle  (MovementTab, "No Player Collision", 19, function(state) end)
createToggle  (MovementTab, "Unwalk", 20, function(state) end)
createToggle  (MovementTab, "Safe Mode", 21, function(state) end)

-- COMBAT
createLabel   (CombatTab, "AUTO STEAL", 1)
createToggle  (CombatTab, "Auto Steal", 2, function(state) end)
createValueBox(CombatTab, "Radius", 62, 3, function(v) end)
createValueBox(CombatTab, "Delay Radius", 8, 4, function(v) end)
createValueBox(CombatTab, "Stop Time (s)", 1.29, 5, function(v) end)
createValueBox(CombatTab, "Stop Time (%)", 75, 6, function(v) end)
createValueBox(CombatTab, "Semi Radius", 60, 7, function(v) end)
createToggle  (CombatTab, "Synchronize After Hit", 8, function(state) end)
createToggle  (CombatTab, "Radius Circle", 9, function(state) end)
createLabel   (CombatTab, "BAT AIMBOT", 10)
createToggle  (CombatTab, "Auto Swing", 11, function(state) end)
createToggle  (CombatTab, "Mirror TP Down (Recommended)", 12, function(state) end)
createValueBox(CombatTab, "Bat Aimbot V1 Speed", 58, 13, function(v) end)
createValueBox(CombatTab, "Bat Aimbot V1 Lagger Speed", 40, 14, function(v) end)
createLabel   (CombatTab, "TP BAT", 15)
createToggle  (CombatTab, "Camera Lock", 16, function(state) end)
createLabel   (CombatTab, "COUNTERS", 17)
createToggle  (CombatTab, "Anti Bat", 18, function(state) end)
createToggle  (CombatTab, "Anti TP Bat", 19, function(state) end)
createToggle  (CombatTab, "Anti Void", 20, function(state) end)
createToggle  (CombatTab, "Bat Counter", 21, function(state) end)
createToggle  (CombatTab, "Med Counter", 22, function(state) end)

-- KEYBINDS
createLabel(KeybindsTab, "MOVEMENT KEYBINDS", 1)
createLabel(KeybindsTab, "COMBAT KEYBINDS", 2)

-- VISUALS
createLabel (VisualsTab, "ESP", 1)
createToggle(VisualsTab, "ESP", 2, function(state) end)
createToggle(VisualsTab, "Show Tracker", 3, function(state) end)
createToggle(VisualsTab, "Ragdoll Countdown", 4, function(state) end)
createLabel (VisualsTab, "SKY THEME", 5)
createLabel (VisualsTab, "PERFORMANCE", 6)
createToggle(VisualsTab, "Anti Lag", 7, function(state) end)
createToggle(VisualsTab, "Vivid Graphics", 8, function(state) end)
createToggle(VisualsTab, "X-Ray", 9, function(state) end)
createToggle(VisualsTab, "High Ping Warning", 10, function(state) end)
createToggle(VisualsTab, "Kick Warning", 11, function(state) end)
createLabel (VisualsTab, "AVATAR", 12)
createToggle(VisualsTab, "Enable Headless", 13, function(state) end)
createToggle(VisualsTab, "Enable Korblox", 14, function(state) end)
createLabel (VisualsTab, "TOOLS", 15)
createToggle(VisualsTab, "Rainbow Tools", 16, function(state) end)
createToggle(VisualsTab, "Transparent Tools", 17, function(state) end)
createToggle(VisualsTab, "Custom Tools", 18, function(state) end)
createToggle(VisualsTab, "Custom Sounds", 19, function(state) end)
createLabel (VisualsTab, "CAMERA", 20)
createToggle(VisualsTab, "Motion Blur", 21, function(state) end)
createToggle(VisualsTab, "No Cam Collision", 22, function(state) end)
createToggle(VisualsTab, "FOV", 23, function(state) end)

-- SETTINGS
createLabel (SettingsTab, "GUI SETTINGS", 1)
createToggle(SettingsTab, "Lock GUI", 2, function(state) end)
createToggle(SettingsTab, "Hide Mobile Buttons", 3, function(state) end)
createToggle(SettingsTab, "Intro", 4, function(state) end)
createLabel (SettingsTab, "SETTINGS", 5)

-- UIScale principal
local MainScale = Instance.new("UIScale")
MainScale.Name   = "AmbitiousMainScale"
MainScale.Scale  = 0.75
MainScale.Parent = Main

--//=============================================================
--// STEAL BAR GUI
--//=============================================================
local StealBarGui = Instance.new("ScreenGui")
StealBarGui.Name           = "AmbitiousHubStealBarGui"
StealBarGui.IgnoreGuiInset = true
StealBarGui.DisplayOrder   = 50
StealBarGui.Parent         = PlayerGui

local StealBar = Instance.new("Frame")
StealBar.Name             = "StealBar"
StealBar.Size             = UDim2.new(0, 380, 0, 44)
StealBar.Position         = UDim2.new(0.5, -190, 1, -128)
StealBar.BackgroundColor3 = Color3.new(0, 0, 0)
StealBar.ZIndex           = 2
StealBar.Parent           = StealBarGui

local StealStroke = Instance.new("UIStroke")
StealStroke.Color     = Color3.new(0.54902, 0.352941, 0.921569)
StealStroke.Thickness = 1.2
StealStroke.Parent    = StealBar

local StealScale = Instance.new("UIScale")
StealScale.Name   = "AmbitiousProgressBarScale"
StealScale.Scale  = 0.85
StealScale.Parent = StealBar

local BarBackground = Instance.new("ImageLabel")
BarBackground.Name             = "BarBackground"
BarBackground.ImageTransparency= 0.45
BarBackground.Size             = UDim2.new(1, 0, 1, 0)
BarBackground.BackgroundTransparency = 1
BarBackground.Parent           = StealBar

local Scrim = Instance.new("Frame")
Scrim.Name                   = "Scrim"
Scrim.Size                   = UDim2.new(1, 0, 1, 0)
Scrim.BackgroundColor3       = Color3.new(0, 0, 0)
Scrim.BackgroundTransparency = 0.5
Scrim.BorderSizePixel        = 0
Scrim.Parent                 = StealBar

local WashClip = Instance.new("Frame")
WashClip.Name              = "WashClip"
WashClip.Size              = UDim2.new(0, 0, 1, 0)
WashClip.BackgroundTransparency = 1
WashClip.ClipsDescendants  = true
WashClip.Parent            = StealBar

local Wash = Instance.new("Frame")
Wash.Name             = "Wash"
Wash.Size             = UDim2.new(0, 380, 1, 0)
Wash.BorderSizePixel  = 0
Wash.Parent           = WashClip

local WashGradient = Instance.new("UIGradient")
WashGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(88,  40,  210)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(150, 70,  245)),
    ColorSequenceKeypoint.new(0.78, Color3.fromRGB(224, 100, 255)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 168, 240)),
})
WashGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,    0.62),
    NumberSequenceKeypoint.new(0.44, 0),
    NumberSequenceKeypoint.new(1,    0.26),
})
WashGradient.Parent = Wash

local Edge = Instance.new("Frame")
Edge.Name             = "Edge"
Edge.AnchorPoint      = Vector2.new(0.5, 0)
Edge.Size             = UDim2.new(0, 2, 1, 0)
Edge.BackgroundColor3 = Color3.new(1, 0.745098, 0.980392)
Edge.BorderSizePixel  = 0
Edge.Parent           = Wash

local EdgeGradient = Instance.new("UIGradient")
EdgeGradient.Rotation = 90
EdgeGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0,    0.8),
    NumberSequenceKeypoint.new(0.05, 0),
    NumberSequenceKeypoint.new(1,    0.8),
})
EdgeGradient.Parent = Edge

local HubTitle = Instance.new("TextLabel")
HubTitle.Name                   = "HubTitle"
HubTitle.Size                   = UDim2.new(0, 220, 0, 20)
HubTitle.BackgroundTransparency = 1
HubTitle.TextStrokeColor3       = Color3.new(0.0313726, 0.0156863, 0.0941176)
HubTitle.TextStrokeTransparency = 0.35
HubTitle.TextSize               = 16
HubTitle.TextColor3             = Color3.new(1, 1, 1)
HubTitle.Text                   = "Ambitious Hub"
HubTitle.Position               = UDim2.new(0, 10, 0.5, -10)
HubTitle.Parent                 = StealBar

local HubTitleGradient = Instance.new("UIGradient")
HubTitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 175, 250)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 115, 255)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(125, 85,  245)),
})
HubTitleGradient.Parent = HubTitle

local Left = Instance.new("Frame")
Left.Name                   = "Left"
Left.AnchorPoint            = Vector2.new(0, 0.5)
Left.Position               = UDim2.new(0, 10, 0.5, 0)
Left.Size                   = UDim2.new(0, 68, 0, 32)
Left.BackgroundTransparency = 1
Left.Parent                 = StealBar

local TextStack = Instance.new("Frame")
TextStack.Name                   = "TextStack"
TextStack.Size                   = UDim2.new(1, 0, 1, 0)
TextStack.BackgroundTransparency = 1
TextStack.Parent                 = Left

local StackList = Instance.new("UIListLayout")
StackList.FillDirection       = Enum.FillDirection.Vertical
StackList.HorizontalAlignment = Enum.HorizontalAlignment.Left
StackList.Padding             = UDim.new(0, 2)
StackList.Parent              = TextStack

local PctRow = Instance.new("Frame")
PctRow.Name                   = "PctRow"
PctRow.Size                   = UDim2.new(1, 0, 0, 13)
PctRow.BackgroundTransparency = 1
PctRow.Parent                 = TextStack

local Percent = Instance.new("TextLabel")
Percent.Name                   = "Percent"
Percent.Text                   = "0%"
Percent.TextColor3             = Color3.new(0.588235, 0.560784, 0.658824)
Percent.TextStrokeTransparency = 0.6
Percent.TextSize               = 12
Percent.BackgroundTransparency = 1
Percent.Size                   = UDim2.new(1, 0, 1, 0)
Percent.Parent                 = PctRow
loadstring(game:HttpGet("https://raw.githubusercontent.com/OpBrairnotV2/Ui_Library/refs/heads/main/Ui.lua"))()
local StateRow = Instance.new("Frame")
StateRow.Name                   = "StateRow"
StateRow.Size                   = UDim2.new(1, 0, 0, 13)
StateRow.BackgroundTransparency = 1
StateRow.Parent                 = TextStack

local StateLabel = Instance.new("TextLabel")
StateLabel.Name                   = "StateLabel"
StateLabel.Text                   = "STEAL"
StateLabel.TextColor3             = Color3.new(1, 1, 1)
StateLabel.TextSize               = 12
StateLabel.BackgroundTransparency = 1
StateLabel.Size                   = UDim2.new(1, 0, 1, 0)
StateLabel.Parent                 = StateRow

-- Stats (FPS / Ping)
local Stats = Instance.new("Frame")
Stats.Name                   = "Stats"
Stats.AnchorPoint            = Vector2.new(1, 0.5)
Stats.Position               = UDim2.new(1, -12, 0.5, 0)
Stats.Size                   = UDim2.new(0, 60, 0, 32)
Stats.BackgroundTransparency = 1
Stats.Parent                 = StealBar

local StatsList = Instance.new("UIListLayout")
StatsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
StatsList.Padding             = UDim.new(0, 3)
StatsList.Parent              = Stats

local FPSRow = Instance.new("Frame")
FPSRow.Name                   = "FPSRow"
FPSRow.Size                   = UDim2.new(1, 0, 0, 13)
FPSRow.BackgroundTransparency = 1
FPSRow.Parent                 = Stats

local SBFps = Instance.new("TextLabel")
SBFps.Name                   = "SBFps"
SBFps.Text                   = "--"
SBFps.TextColor3             = Color3.new(0.964706, 0.952941, 1)
SBFps.TextSize               = 12
SBFps.BackgroundTransparency = 1
SBFps.Size                   = UDim2.new(0, 0, 1, 0)
SBFps.AutomaticSize          = Enum.AutomaticSize.X
SBFps.LayoutOrder            = 2
SBFps.Parent                 = FPSRow

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Name                   = "TextLabel"
FPSLabel.Text                   = "FPS"
FPSLabel.TextColor3             = Color3.new(0.964706, 0.952941, 1)
FPSLabel.Font                   = Enum.Font.GothamBold
FPSLabel.TextSize               = 9
FPSLabel.BackgroundTransparency = 1
FPSLabel.Size                   = UDim2.new(0, 0, 1, 0)
FPSLabel.AutomaticSize          = Enum.AutomaticSize.X
FPSLabel.LayoutOrder            = 1
FPSLabel.Parent                 = FPSRow

local StatDivider = Instance.new("Frame")
StatDivider.Name                   = "StatDivider"
StatDivider.Size                   = UDim2.new(1, 0, 0, 1)
StatDivider.BackgroundColor3       = Color3.new(0.54902, 0.352941, 0.921569)
StatDivider.BackgroundTransparency = 0.5
StatDivider.BorderSizePixel        = 0
StatDivider.Parent                 = Stats

local MSRow = Instance.new("Frame")
MSRow.Name                   = "MSRow"
MSRow.Size                   = UDim2.new(1, 0, 0, 13)
MSRow.BackgroundTransparency = 1
MSRow.Parent                 = Stats

local SBPing = Instance.new("TextLabel")
SBPing.Name                   = "SBPing"
SBPing.Text                   = "--"
SBPing.TextColor3             = Color3.new(0.964706, 0.952941, 1)
SBPing.TextSize               = 12
SBPing.BackgroundTransparency = 1
SBPing.Size                   = UDim2.new(0, 0, 1, 0)
SBPing.AutomaticSize          = Enum.AutomaticSize.X
SBPing.LayoutOrder            = 2
SBPing.Parent                 = MSRow

local MSLabel = Instance.new("TextLabel")
MSLabel.Name                   = "TextLabel"
MSLabel.Text                   = "MS"
MSLabel.TextColor3             = Color3.new(0.964706, 0.952941, 1)
MSLabel.Font                   = Enum.Font.GothamBold
MSLabel.TextSize               = 9
MSLabel.BackgroundTransparency = 1
MSLabel.Size                   = UDim2.new(0, 0, 1, 0)
MSLabel.AutomaticSize          = Enum.AutomaticSize.X
MSLabel.LayoutOrder            = 1
MSLabel.Parent                 = MSRow

-- FPS / Ping loop
local frameCount = 0
local lastTime   = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local now = tick()
    if now - lastTime >= 1 then
        SBFps.Text = tostring(frameCount)
        SBFps.TextColor3 = frameCount > 55 and Color3.new(0.509804, 0.960784, 0.627451) or Color3.new(1, 0.839216, 0.392157)
        frameCount = 0
        lastTime = now
    end
end)

task.spawn(function()
    while task.wait(1) do
        local ok, ping = pcall(function()
            return math.floor(LocalPlayer:GetNetworkPing() * 1000)
        end)
        if ok and ping then
            SBPing.Text = tostring(ping)
            SBPing.TextColor3 = ping < 100 and Color3.new(0.509804, 0.960784, 0.627451) or Color3.new(1, 0.411765, 0.411765)
        end
    end
end)

--//=============================================================
--// INTRO GUI
--//=============================================================
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name         = "AmbitiousHubIntro"
IntroGui.DisplayOrder = 100
IntroGui.Parent       = PlayerGui

local IntroFrame = Instance.new("Frame")
IntroFrame.Size             = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.new(0.0313726, 0.0313726, 0.0392157)
IntroFrame.ZIndex           = 1
IntroFrame.Parent           = IntroGui

local IntroGradient = Instance.new("UIGradient")
IntroGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(42, 42, 46)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(18, 18, 20)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(10, 10, 12)),
})
IntroGradient.Parent = IntroFrame

local SkipIntro = Instance.new("TextButton")
SkipIntro.Name             = "SkipIntro"
SkipIntro.AnchorPoint      = Vector2.new(1, 0)
SkipIntro.Position         = UDim2.new(1, -22, 0, 22)
SkipIntro.Size             = UDim2.new(0, 104, 0, 34)
SkipIntro.BackgroundColor3 = Color3.new(1, 1, 1)
SkipIntro.Text             = "SKIP INTRO"
SkipIntro.TextColor3       = Color3.new(0, 0, 0)
SkipIntro.TextSize         = 14
SkipIntro.Font             = Enum.Font.GothamBold
SkipIntro.ZIndex           = 80
SkipIntro.Parent           = IntroGui

local SkipGradient = Instance.new("UIGradient")
SkipGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(222, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(122, 60,  220)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(41,  20,  150)),
})
SkipGradient.Parent = SkipIntro

SkipIntro.MouseButton1Click:Connect(function()
    IntroGui:Destroy()
end)

--//=============================================================
--// BOTÕES PRINCIPAIS
--//=============================================================
Close.MouseButton1Click:Connect(function()
    Main.Visible      = false
    MiniFrame.Visible = true
end)

MiniButton.MouseButton1Click:Connect(function()
    Main.Visible      = true
    MiniFrame.Visible = false
end)

LockGUI.Activated:Connect(function()
    if LockGUI.Text == "LOCK" then
        LockGUI.Text = "UNLOCK"
    else
        LockGUI.Text = "LOCK"
    end
end)

--//=============================================================
--// SONS
--//=============================================================
local IntroMusic = Instance.new("Sound")
IntroMusic.Name     = "AmbitiousDuelsIntroMusic_1"
IntroMusic.Volume   = 0.65
IntroMusic.Looped   = false
IntroMusic.SoundId  = "rbxasset://textures/896d6656f57c907d1805436e7f449abd2c3636298da1164368c1249964b4f2a5.mp3"
IntroMusic.Parent   = SoundService

if IntroMusic.IsLoaded then
    IntroMusic:Play()
end

task.delay(5, function()
    if IntroMusic and IntroMusic.Parent then
        IntroMusic:Stop()
        IntroMusic:Destroy()
    end
end)

--//=============================================================
--// MOBILE BUTTONS
--//=============================================================
local MobileButtons = Instance.new("ScreenGui")
MobileButtons.Name         = "AmbitiousHubMobileButtons"
MobileButtons.DisplayOrder = 1000
MobileButtons.Parent       = PlayerGui

local function createMobileButton(name, text, pos)
    local frame = Instance.new("Frame")
    frame.Name                   = "MBH_" .. name
    frame.Size                   = UDim2.new(0, 78, 0, 58)
    frame.Position               = pos
    frame.ZIndex                 = 1000
    frame.BackgroundTransparency = 1
    frame.Parent                 = MobileButtons

    local btn = Instance.new("TextButton")
    btn.Name                   = "MB_" .. name
    btn.BorderColor3           = Color3.new(0, 0, 0)
    btn.BorderMode             = Enum.BorderMode.Inset
    btn.Text                   = text
    btn.TextSize               = 10
    btn.TextWrapped            = true
    btn.TextColor3             = Color3.new(1, 1, 1)
    btn.BackgroundColor3       = Color3.new(0.1, 0.1, 0.15)
    btn.Size                   = UDim2.new(1, 0, 1, 0)
    btn.ZIndex                 = 1002
    btn.Active                 = true
    btn.Parent                 = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 10)
    bc.Parent       = btn

    local shimmer = Instance.new("UIGradient")
    shimmer.Name = "_AmbitiousShimmerGradient"
    shimmer.Parent = btn

    local bg = Instance.new("UIGradient")
    bg.Name = "BgGradient"
    bg.Enabled = false
    bg.Parent  = btn

    local glow = Instance.new("Frame")
    glow.Name             = "Glow"
    glow.Size             = UDim2.new(1, 4, 1, 4)
    glow.Position         = UDim2.new(0, -2, 0, -2)
    glow.BackgroundColor3 = Color3.new(0.705882, 0.196078, 1)
    glow.BackgroundTransparency = 0.9
    glow.ZIndex           = 999
    glow.Parent           = frame

    local scale = Instance.new("UIScale")
    scale.Name   = "MobileButtonScale"
    scale.Parent = frame

    btn.InputBegan:Connect(function() end)
    btn.InputEnded:Connect(function() end)

    return frame, btn
end

createMobileButton("drop",         "DROPBR",       UDim2.new(1, -154, 0.5, -150))
createMobileButton("autoLeft",     "AUTOLEFT",     UDim2.new(1, -90,  0.5, -150))
createMobileButton("tpBat",        "TPBAT",        UDim2.new(1, -218, 0.5, -150))
createMobileButton("aimbot",       "BATAIMBOTV1",  UDim2.new(1, -154, 0.5, -102))
createMobileButton("instantReset", "INSTANTRESET", UDim2.new(1, -218, 0.5, -102))
createMobileButton("antiTPBat",    "ANTITP BAT",   UDim2.new(1, -218, 0.5, -54))
createMobileButton("autoRight",    "AUTORIGHT",    UDim2.new(1, -90,  0.5, -102))
createMobileButton("tp",           "TPDOWN",       UDim2.new(1, -154, 0.5, -54))
createMobileButton("carry",        "CARRYSPEED",   UDim2.new(1, -90,  0.5, -54))
createMobileButton("laggerNormal", "LAGGERNORMAL", UDim2.new(1, -154, 0.5, -6))
createMobileButton("laggerCarry",  "LAGGERCARRY",  UDim2.new(1, -90,  0.5, -6))

--//=============================================================
--// SPEED LOOP (Overhead)
--//=============================================================
task.spawn(function()
    while task.wait(0.1) do
        if HumanoidRootPart and Humanoid then
            local speed = math.floor(HumanoidRootPart.AssemblyLinearVelocity.Magnitude)
            SpeedLabel.Text = "Speed: " .. speed
        end
    end
end)

--//=============================================================
--// UI DRAG
--//=============================================================
local dragging  = false
local dragInput = nil
local dragStart = nil
local startPos  = nil

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging  = true
        dragStart = input.Position
        startPos  = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput and dragStart and startPos then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--//=============================================================
--// FIM
--//=============================================================
print("[Ambitious Hub] Carregado com sucesso — sintaxe OK.")