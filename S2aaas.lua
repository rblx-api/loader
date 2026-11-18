-- S2PillWidget (ScreenGui)
local S2PillWidget = Instance.new("ScreenGui")
S2PillWidget.Name = "S2PillWidget"
S2PillWidget.ResetOnSpawn = false
S2PillWidget.DisplayOrder = 999
S2PillWidget.IgnoreGuiInset = true
S2PillWidget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
S2PillWidget.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

-- Root (Frame)
local Root = Instance.new("Frame")
Root.Name = "Root"
Root.AnchorPoint = Vector2.new(0.5, 0)
Root.BackgroundTransparency = 1
Root.BorderSizePixel = 0
Root.Position = UDim2.new(0.5, -27, 0, 95)
Root.Size = UDim2.new(0, 380, 0, 198)
Root.Parent = S2PillWidget

-- UIScale (UIScale)
local UIScale = Instance.new("UIScale")
UIScale.Scale = 0.85000002384185791
UIScale.Parent = Root

-- Shell (Frame)
local Shell = Instance.new("Frame")
Shell.Name = "Shell"
Shell.BackgroundColor3 = Color3.fromRGB(18, 24, 40)
Shell.BorderSizePixel = 0
Shell.ClipsDescendants = true
Shell.Size = UDim2.new(1, 0, 1, 0)
Shell.ZIndex = 2
Shell.Parent = Root

-- UICorner (UICorner)
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = Shell

-- UIStroke (UIStroke)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(120, 175, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.05000000074505806
UIStroke.Parent = Shell

-- UIGradient (UIGradient)
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 34, 54)), ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 24, 40))})
UIGradient.Rotation = 90
UIGradient.Parent = Shell

-- HubBG (ImageLabel)
local HubBG = Instance.new("ImageLabel")
HubBG.Name = "HubBG"
HubBG.BackgroundTransparency = 1
HubBG.BorderSizePixel = 0
HubBG.Size = UDim2.new(1, 0, 1, 0)
HubBG.Image = "rbxassetid://118131424737973"
HubBG.ImageTransparency = 0.20000000298023224
HubBG.ScaleType = Enum.ScaleType.Crop
HubBG.Parent = Shell

-- UICorner_2 (UICorner)
local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 16)
UICorner_2.Parent = HubBG

-- HubBGDim (Frame)
local HubBGDim = Instance.new("Frame")
HubBGDim.Name = "HubBGDim"
HubBGDim.BackgroundColor3 = Color3.fromRGB(8, 8, 16)
HubBGDim.BackgroundTransparency = 0.55000001192092896
HubBGDim.BorderSizePixel = 0
HubBGDim.Size = UDim2.new(1, 0, 1, 0)
HubBGDim.Parent = Shell

-- UICorner_3 (UICorner)
local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 16)
UICorner_3.Parent = HubBGDim

-- Header (Frame)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Active = true
Header.BackgroundTransparency = 1
Header.BorderSizePixel = 0
Header.Size = UDim2.new(1, 0, 0, 42)
Header.ZIndex = 3
Header.Parent = Shell

-- DragHandle (زر خفي لضمان التقاط السحب على الشريط العلوي)
local DragHandle = Instance.new("TextButton")
DragHandle.Name = "DragHandle"
DragHandle.Size = UDim2.new(1, 0, 1, 0)
DragHandle.BackgroundTransparency = 1
DragHandle.Text = ""
DragHandle.AutoButtonColor = false
DragHandle.ZIndex = 3
DragHandle.Parent = Header

-- Dot (Frame)
local Dot = Instance.new("Frame")
Dot.Name = "Dot"
Dot.AnchorPoint = Vector2.new(0, 0.5)
Dot.BackgroundColor3 = Color3.fromRGB(130, 190, 255)
Dot.BorderSizePixel = 0
Dot.Position = UDim2.new(0, 13, 0.5, 0)
Dot.Size = UDim2.new(0, 9, 0, 9)
Dot.ZIndex = 4
Dot.Parent = Header

-- UICorner_4 (UICorner)
local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(0, 4)
UICorner_4.Parent = Dot

-- Expand (TextButton)
local Expand = Instance.new("TextButton")
Expand.Name = "Expand"
Expand.AnchorPoint = Vector2.new(1, 0.5)
Expand.BackgroundColor3 = Color3.fromRGB(130, 190, 255)
Expand.BorderSizePixel = 0
Expand.Position = UDim2.new(1, -10, 0.5, 0)
Expand.Size = UDim2.new(0, 25, 0, 25)
Expand.ZIndex = 4
Expand.AutoButtonColor = false
Expand.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Expand.Text = "-"
Expand.TextColor3 = Color3.fromRGB(12, 20, 40)
Expand.TextSize = 15
Expand.Parent = Header

-- UICorner_5 (UICorner)
local UICorner_5 = Instance.new("UICorner")
UICorner_5.CornerRadius = UDim.new(0, 12)
UICorner_5.Parent = Expand

-- Toggle (TextButton)
local Toggle = Instance.new("TextButton")
Toggle.Name = "Toggle"
Toggle.AnchorPoint = Vector2.new(1, 0.5)
Toggle.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
Toggle.BorderSizePixel = 0
Toggle.Position = UDim2.new(1, -41, 0.5, 0)
Toggle.Size = UDim2.new(0, 46, 0, 25)
Toggle.ZIndex = 4
Toggle.AutoButtonColor = false
Toggle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Toggle.Text = "ON"
Toggle.TextColor3 = Color3.fromRGB(245, 250, 255)
Toggle.TextSize = 13
Toggle.Parent = Header

-- UICorner_6 (UICorner)
local UICorner_6 = Instance.new("UICorner")
UICorner_6.CornerRadius = UDim.new(0, 12)
UICorner_6.Parent = Toggle

-- UIStroke_2 (UIStroke)
local UIStroke_2 = Instance.new("UIStroke")
UIStroke_2.Color = Color3.fromRGB(130, 190, 255)
UIStroke_2.Transparency = 0.10000000149011612
UIStroke_2.Parent = Toggle

-- Lock (TextButton)
local Lock = Instance.new("TextButton")
Lock.Name = "Lock"
Lock.AnchorPoint = Vector2.new(1, 0.5)
Lock.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
Lock.BorderSizePixel = 0
Lock.Position = UDim2.new(1, -93, 0.5, 0)
Lock.Size = UDim2.new(0, 46, 0, 25)
Lock.ZIndex = 4
Lock.AutoButtonColor = false
Lock.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Lock.Text = "LOCK"
Lock.TextColor3 = Color3.fromRGB(245, 250, 255)
Lock.TextSize = 13
Lock.Parent = Header

-- UICorner_7 (UICorner)
local UICorner_7 = Instance.new("UICorner")
UICorner_7.CornerRadius = UDim.new(0, 12)
UICorner_7.Parent = Lock

-- UIStroke_3 (UIStroke)
local UIStroke_3 = Instance.new("UIStroke")
UIStroke_3.Color = Color3.fromRGB(130, 190, 255)
UIStroke_3.Transparency = 0.34999999403953552
UIStroke_3.Parent = Lock

-- RadiusBadge (TextButton)
local RadiusBadge = Instance.new("TextButton")
RadiusBadge.Name = "RadiusBadge"
RadiusBadge.AnchorPoint = Vector2.new(1, 0.5)
RadiusBadge.BackgroundColor3 = Color3.fromRGB(12, 20, 40)
RadiusBadge.BorderSizePixel = 0
RadiusBadge.Position = UDim2.new(1, -145, 0.5, 0)
RadiusBadge.Size = UDim2.new(0, 76, 0, 25)
RadiusBadge.ZIndex = 4
RadiusBadge.AutoButtonColor = false
RadiusBadge.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
RadiusBadge.Text = "Radius 70"
RadiusBadge.TextColor3 = Color3.fromRGB(245, 250, 255)
RadiusBadge.TextSize = 13
RadiusBadge.Parent = Header

-- UICorner_8 (UICorner)
local UICorner_8 = Instance.new("UICorner")
UICorner_8.CornerRadius = UDim.new(0, 12)
UICorner_8.Parent = RadiusBadge

-- UIStroke_4 (UIStroke)
local UIStroke_4 = Instance.new("UIStroke")
UIStroke_4.Color = Color3.fromRGB(120, 175, 255)
UIStroke_4.Transparency = 0.25
UIStroke_4.Parent = RadiusBadge

-- Title (TextLabel)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 31, 0, 0)
Title.Size = UDim2.new(1, -258, 1, 0)
Title.ZIndex = 4
Title.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title.Text = "S2 Auto Grab"
Title.TextColor3 = Color3.fromRGB(245, 250, 255)
Title.TextSize = 13
Title.TextTruncate = Enum.TextTruncate.AtEnd
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Progress (Frame)
local Progress = Instance.new("Frame")
Progress.Name = "Progress"
Progress.BackgroundTransparency = 1
Progress.BorderSizePixel = 0
Progress.Position = UDim2.new(0, 13, 0, 42)
Progress.Size = UDim2.new(1, -26, 0, 32)
Progress.ZIndex = 3
Progress.Parent = Shell

-- Track (Frame)
local Track = Instance.new("Frame")
Track.Name = "Track"
Track.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
Track.BorderSizePixel = 0
Track.Position = UDim2.new(0, 0, 0, 10)
Track.Size = UDim2.new(1, 0, 0, 12)
Track.ZIndex = 4
Track.Parent = Progress

-- UICorner_9 (UICorner)
local UICorner_9 = Instance.new("UICorner")
UICorner_9.CornerRadius = UDim.new(0, 6)
UICorner_9.Parent = Track

-- UIStroke_5 (UIStroke)
local UIStroke_5 = Instance.new("UIStroke")
UIStroke_5.Color = Color3.fromRGB(120, 175, 255)
UIStroke_5.Transparency = 0.30000001192092896
UIStroke_5.Parent = Track

-- Fill (Frame)
local Fill = Instance.new("Frame")
Fill.Name = "Fill"
Fill.BackgroundColor3 = Color3.fromRGB(130, 190, 255)
Fill.BorderSizePixel = 0
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.ZIndex = 5
Fill.Parent = Track

-- UICorner_10 (UICorner)
local UICorner_10 = Instance.new("UICorner")
UICorner_10.CornerRadius = UDim.new(0, 6)
UICorner_10.Parent = Fill

-- UIGradient_2 (UIGradient)
local UIGradient_2 = Instance.new("UIGradient")
UIGradient_2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 200, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 190, 255))})
UIGradient_2.Parent = Fill

-- Settings (Frame)
local Settings = Instance.new("Frame")
Settings.Name = "Settings"
Settings.BackgroundTransparency = 1
Settings.BorderSizePixel = 0
Settings.Position = UDim2.new(0, 13, 0, 74)
Settings.Size = UDim2.new(1, -26, 0, 124)
Settings.ZIndex = 3
Settings.Parent = Shell

-- Cards (Frame)
local Cards = Instance.new("Frame")
Cards.Name = "Cards"
Cards.BackgroundTransparency = 1
Cards.BorderSizePixel = 0
Cards.Size = UDim2.new(1, 0, 0, 84)
Cards.ZIndex = 4
Cards.Parent = Settings

-- Frame (Frame)
local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
Frame.BorderSizePixel = 0
Frame.Size = UDim2.new(0.36000001430511475, -5, 1, 0)
Frame.ZIndex = 4
Frame.Parent = Cards

-- UICorner_11 (UICorner)
local UICorner_11 = Instance.new("UICorner")
UICorner_11.CornerRadius = UDim.new(0, 11)
UICorner_11.Parent = Frame

-- UIStroke_6 (UIStroke)
local UIStroke_6 = Instance.new("UIStroke")
UIStroke_6.Color = Color3.fromRGB(120, 175, 255)
UIStroke_6.Transparency = 0.25
UIStroke_6.Parent = Frame

-- UIGradient_3 (UIGradient)
local UIGradient_3 = Instance.new("UIGradient")
UIGradient_3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 24, 40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 22, 38))})
UIGradient_3.Rotation = 90
UIGradient_3.Parent = Frame

-- TextLabel (TextLabel)
local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 10, 0, 9)
TextLabel.Size = UDim2.new(1, -20, 0, 15)
TextLabel.ZIndex = 5
TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.Text = "RADIUS"
TextLabel.TextColor3 = Color3.fromRGB(245, 250, 255)
TextLabel.TextSize = 13
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame

-- RadiusInput (TextBox)
local RadiusInput = Instance.new("TextBox")
RadiusInput.Name = "RadiusInput"
RadiusInput.BackgroundColor3 = Color3.fromRGB(12, 20, 40)
RadiusInput.BorderSizePixel = 0
RadiusInput.Position = UDim2.new(0, 10, 0, 30)
RadiusInput.Size = UDim2.new(1, -20, 0, 32)
RadiusInput.ZIndex = 5
RadiusInput.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
RadiusInput.Text = "70"
RadiusInput.TextColor3 = Color3.fromRGB(245, 250, 255)
RadiusInput.TextSize = 22
RadiusInput.ClearTextOnFocus = false
RadiusInput.PlaceholderText = "61"
RadiusInput.Parent = Frame

-- UICorner_12 (UICorner)
local UICorner_12 = Instance.new("UICorner")
UICorner_12.Parent = RadiusInput

-- UIStroke_7 (UIStroke)
local UIStroke_7 = Instance.new("UIStroke")
UIStroke_7.Color = Color3.fromRGB(120, 175, 255)
UIStroke_7.Transparency = 0.20000000298023224
UIStroke_7.Parent = RadiusInput

-- TextLabel_2 (TextLabel)
local TextLabel_2 = Instance.new("TextLabel")
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.Position = UDim2.new(0, 10, 0, 64)
TextLabel_2.Size = UDim2.new(1, -20, 0, 14)
TextLabel_2.ZIndex = 5
TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel_2.Text = "max 70"
TextLabel_2.TextColor3 = Color3.fromRGB(245, 250, 255)
TextLabel_2.TextSize = 13
TextLabel_2.Parent = Frame

-- Frame_2 (Frame)
local Frame_2 = Instance.new("Frame")
Frame_2.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.36000001430511475, 5, 0, 0)
Frame_2.Size = UDim2.new(0.63999998569488525, -5, 1, 0)
Frame_2.ZIndex = 4
Frame_2.Parent = Cards

-- UICorner_13 (UICorner)
local UICorner_13 = Instance.new("UICorner")
UICorner_13.CornerRadius = UDim.new(0, 11)
UICorner_13.Parent = Frame_2

-- UIStroke_8 (UIStroke)
local UIStroke_8 = Instance.new("UIStroke")
UIStroke_8.Color = Color3.fromRGB(120, 175, 255)
UIStroke_8.Transparency = 0.25
UIStroke_8.Parent = Frame_2

-- UIGradient_4 (UIGradient)
local UIGradient_4 = Instance.new("UIGradient")
UIGradient_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 24, 40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 22, 38))})
UIGradient_4.Rotation = 90
UIGradient_4.Parent = Frame_2

-- TextLabel_3 (TextLabel)
local TextLabel_3 = Instance.new("TextLabel")
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.Position = UDim2.new(0, 10, 0, 9)
TextLabel_3.Size = UDim2.new(1, -20, 0, 15)
TextLabel_3.ZIndex = 5
TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel_3.Text = "STEAL MODE"
TextLabel_3.TextColor3 = Color3.fromRGB(245, 250, 255)
TextLabel_3.TextSize = 13
TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_3.Parent = Frame_2

-- ModeTrack (Frame)
local ModeTrack = Instance.new("Frame")
ModeTrack.Name = "ModeTrack"
ModeTrack.BackgroundColor3 = Color3.fromRGB(16, 22, 38)
ModeTrack.BorderSizePixel = 0
ModeTrack.Position = UDim2.new(0, 10, 0, 30)
ModeTrack.Size = UDim2.new(1, -20, 0, 32)
ModeTrack.ZIndex = 5
ModeTrack.Parent = Frame_2

-- UICorner_14 (UICorner)
local UICorner_14 = Instance.new("UICorner")
UICorner_14.CornerRadius = UDim.new(0, 16)
UICorner_14.Parent = ModeTrack

-- UIStroke_9 (UIStroke)
local UIStroke_9 = Instance.new("UIStroke")
UIStroke_9.Color = Color3.fromRGB(120, 175, 255)
UIStroke_9.Transparency = 0.20000000298023224
UIStroke_9.Parent = ModeTrack

-- Thumb (Frame)
local Thumb = Instance.new("Frame")
Thumb.Name = "Thumb"
Thumb.BackgroundColor3 = Color3.fromRGB(130, 190, 255)
Thumb.BorderSizePixel = 0
Thumb.Position = UDim2.new(0.75, 2, 0, 2)
Thumb.Size = UDim2.new(0.25, -4, 1, -4)
Thumb.ZIndex = 6
Thumb.Parent = ModeTrack

-- UICorner_15 (UICorner)
local UICorner_15 = Instance.new("UICorner")
UICorner_15.CornerRadius = UDim.new(0, 14)
UICorner_15.Parent = Thumb

-- V1 (TextButton)
local V1 = Instance.new("TextButton")
V1.Name = "V1"
V1.BackgroundTransparency = 1
V1.BorderSizePixel = 0
V1.Size = UDim2.new(0.25, 0, 1, 0)
V1.ZIndex = 7
V1.AutoButtonColor = false
V1.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
V1.Text = "V1"
V1.TextColor3 = Color3.fromRGB(245, 250, 255)
V1.TextSize = 13
V1.Parent = ModeTrack

-- V2 (TextButton)
local V2 = Instance.new("TextButton")
V2.Name = "V2"
V2.BackgroundTransparency = 1
V2.BorderSizePixel = 0
V2.Position = UDim2.new(0.25, 0, 0, 0)
V2.Size = UDim2.new(0.25, 0, 1, 0)
V2.ZIndex = 7
V2.AutoButtonColor = false
V2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
V2.Text = "V2"
V2.TextColor3 = Color3.fromRGB(245, 250, 255)
V2.TextSize = 13
V2.Parent = ModeTrack

-- V3 (TextButton)
local V3 = Instance.new("TextButton")
V3.Name = "V3"
V3.BackgroundTransparency = 1
V3.BorderSizePixel = 0
V3.Position = UDim2.new(0.5, 0, 0, 0)
V3.Size = UDim2.new(0.25, 0, 1, 0)
V3.ZIndex = 7
V3.AutoButtonColor = false
V3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
V3.Text = "V3"
V3.TextColor3 = Color3.fromRGB(245, 250, 255)
V3.TextSize = 13
V3.Parent = ModeTrack

-- V4 (TextButton)
local V4 = Instance.new("TextButton")
V4.Name = "V4"
V4.BackgroundTransparency = 1
V4.BorderSizePixel = 0
V4.Position = UDim2.new(0.75, 0, 0, 0)
V4.Size = UDim2.new(0.25, 0, 1, 0)
V4.ZIndex = 7
V4.AutoButtonColor = false
V4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
V4.Text = "V4"
V4.TextColor3 = Color3.fromRGB(12, 20, 40)
V4.TextSize = 13
V4.Parent = ModeTrack

-- Discord (TextButton)
local Discord = Instance.new("TextButton")
Discord.Name = "Discord"
Discord.BackgroundTransparency = 1
Discord.BorderSizePixel = 0
Discord.Position = UDim2.new(0, 0, 0, 94)
Discord.Size = UDim2.new(1, 0, 0, 18)
Discord.ZIndex = 4
Discord.AutoButtonColor = false
Discord.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Discord.Text = "discord.gg/S2hub"
Discord.TextColor3 = Color3.fromRGB(130, 190, 255)
Discord.TextSize = 13
Discord.Parent = Settings

-- Mount GUI
S2PillWidget.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- ===============================================================
--  Logic & Behavior
-- ===============================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = game:GetService("Players").LocalPlayer

-- متغيرات التحكم في السحب والقفل
local isLocked = true
local isDragging = false
local dragStart = nil
local startPos = nil

-- دالة لإظهار رسالة التسريب والإشعار
local function showLeakMessage()
	print("leaked by mouad only gui")
	print("if you need logic join this server https://discord.gg/uQFjgXf2AX")
end

-- دالة لإنشاء النص فوق رأس اللاعب (BillboardGui)
local function createHeadBillboard()
	local character = player.Character
	if not character then return end
	
	local head = character:FindFirstChild("Head")
	if not head then return end
	
	local existing = head:FindFirstChild("MouadLeakBillboard")
	if existing then existing:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "MouadLeakBillboard"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 240, 0, 75)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.BackgroundTransparency = 0.6
	textLabel.Text = "leaked by mouad only gui\nif you need logic join:\nhttps://discord.gg/uQFjgXf2AX"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextScaled = true
	textLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
	textLabel.Parent = billboard
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = textLabel
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(130, 190, 255)
	stroke.Thickness = 1.5
	stroke.Parent = textLabel
end

createHeadBillboard()
player.CharacterAdded:Connect(createHeadBillboard)

-- منطق السحب (Dragging) عبر زر DragHandle الخفي
DragHandle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if isLocked then 
			print("GUI is LOCKED. Click the LOCK button to enable MOVE.")
			return 
		end 
		
		isDragging = true
		dragStart = input.Position
		startPos = Root.Position
		
		local moveConnection, endConnection
		moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
			if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
				if isDragging then
					local delta = moveInput.Position - dragStart
					Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
				end
			end
		end)
		
		endConnection = UserInputService.InputEnded:Connect(function(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
				isDragging = false
				moveConnection:Disconnect()
				endConnection:Disconnect()
			end
		end)
	end
end)

-- === Multi-property toggles ===

-- Toggle: Expand
do
	local _btn = Expand
	local _isOn = false
	_btn.MouseButton1Click:Connect(function()
		_isOn = not _isOn
		Expand.Text = _isOn and "-" or "+"
		Expand.BackgroundColor3 = _isOn and Color3.fromRGB(130, 190, 255) or Color3.new(0.557, 0.770, 1)
		Root.Size = _isOn and UDim2.new(0, 380, 0, 198) or UDim2.new(0, 380, 0, 74)
	end)
end

-- Toggle: RadiusBadge
do
	local _btn = RadiusBadge
	local _isOn = false
	_btn.MouseButton1Click:Connect(function()
		_isOn = not _isOn
		Lock.BackgroundColor3 = _isOn and Color3.fromRGB(50, 100, 180) or Color3.new(0.217, 0.408, 0.713)
		Expand.Text = _isOn and "+" or "-"
		RadiusBadge.BackgroundColor3 = _isOn and Color3.fromRGB(12, 20, 40) or Color3.fromRGB(12, 20, 40)
		Root.Size = _isOn and UDim2.new(0, 380, 0, 74) or UDim2.new(0, 380, 0, 198)
	end)
end

-- Toggle: Lock
do
	local _btn = Lock
	local _isOn = false
	_btn.MouseButton1Click:Connect(function()
		_isOn = not _isOn
		isLocked = not _isOn 
		
		if isLocked then
			print("GUI Locked - Cannot move")
		else
			print("GUI Unlocked - You can move it now from the top bar")
		end
		
		Root.Position = _isOn and UDim2.new(0.5, -15, 0, 98) or UDim2.new(0.5, -27, 0, 95)
		RadiusBadge.BackgroundColor3 = _isOn and Color3.fromRGB(12, 20, 40) or Color3.fromRGB(12, 20, 40)
		Lock.BackgroundColor3 = _isOn and Color3.fromRGB(32, 40, 60) or Color3.fromRGB(50, 100, 180)
		Lock.Text = _isOn and "MOVE" or "LOCK"
		Lock.Rotation = _isOn and -0.973 or 0
	end)
end

-- Toggle: Toggle (ON/OFF)
do
	local _btn = Toggle
	local _isOn = false
	_btn.MouseButton1Click:Connect(function()
		_isOn = not _isOn
		Dot.BackgroundColor3 = _isOn and Color3.fromRGB(160, 195, 240) or Color3.fromRGB(130, 190, 255)
		Toggle.BackgroundColor3 = _isOn and Color3.fromRGB(32, 40, 60) or Color3.fromRGB(50, 100, 180)
		Toggle.Text = _isOn and "OFF" or "ON"
	end)
end

-- Toggle: RadiusInput
do
	local _btn = RadiusInput
	local _isOn = false
	_btn.MouseButton1Click:Connect(function()
		_isOn = not _isOn
		RadiusInput.Text = _isOn and "6" or "61"
	end)
end

-- === نظام اختيار STEAL MODE المحسّن (V1, V2, V3, V4) ===

local function StealMode1() print("Steal Mode V1 Activated") end
local function StealMode2() print("Steal Mode V2 Activated") end
local function StealMode3() print("Steal Mode V3 Activated") end
local function StealMode4() print("Steal Mode V4 Activated") end

local function setStealMode(mode)
	local darkColor = Color3.fromRGB(12, 20, 40)
	local lightColor = Color3.fromRGB(245, 250, 255)
	
	V1.TextColor3 = (mode == 1) and darkColor or lightColor
	V2.TextColor3 = (mode == 2) and darkColor or lightColor
	V3.TextColor3 = (mode == 3) and darkColor or lightColor
	V4.TextColor3 = (mode == 4) and darkColor or lightColor
	
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local targetPos
	if mode == 1 then targetPos = UDim2.new(0, 2, 0, 2)
	elseif mode == 2 then targetPos = UDim2.new(0.25, 2, 0, 2)
	elseif mode == 3 then targetPos = UDim2.new(0.5, 2, 0, 2)
	elseif mode == 4 then targetPos = UDim2.new(0.75, 2, 0, 2) end
	
	TweenService:Create(Thumb, tweenInfo, {Position = targetPos}):Play()
	
	if mode == 1 then StealMode1()
	elseif mode == 2 then StealMode2()
	elseif mode == 3 then StealMode3()
	elseif mode == 4 then StealMode4() end
	
	showLeakMessage()
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Steal Mode",
			Text = "Activated V" .. mode .. "\nLeaked by Mouad",
			Duration = 3
		})
	end)
end

local function addClickEffect(button)
	button.MouseButton1Down:Connect(function()
		button.BackgroundTransparency = 0.5
		button.BackgroundColor3 = Color3.fromRGB(130, 190, 255)
	end)
	button.MouseButton1Up:Connect(function()
		button.BackgroundTransparency = 1
	end)
end

addClickEffect(V1)
addClickEffect(V2)
addClickEffect(V3)
addClickEffect(V4)

V1.MouseButton1Click:Connect(function() setStealMode(1) end)
V2.MouseButton1Click:Connect(function() setStealMode(2) end)
V3.MouseButton1Click:Connect(function() setStealMode(3) end)
V4.MouseButton1Click:Connect(function() setStealMode(4) end)

setStealMode(4)

return S2PillWidget