--[[
    Riddler  (ScreenGui)
    Grabbed by Xavi GUI Copier v1.0.0 on 2026-09-24 21:41:29
    Discord: https://discord.gg/QhWDwSHvK
    345 instances
]]

local G = {}

-- Riddler (ScreenGui)
G.Riddler = Instance.new("ScreenGui")
G.Riddler.Name = "Riddler"
G.Riddler.ResetOnSpawn = false
G.Riddler.DisplayOrder = 251
G.Riddler.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main (Frame)
G.Main = Instance.new("Frame")
G.Main.Name = "Main"
G.Main.Active = true
G.Main.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
G.Main.BorderSizePixel = 0
G.Main.ClipsDescendants = true
G.Main.Position = UDim2.new(1, -253, 0.5, -195)
G.Main.Size = UDim2.new(0, 316, 0, 544)
G.Main.Parent = G.Riddler

-- UICorner (UICorner)
G.UICorner = Instance.new("UICorner")
G.UICorner.CornerRadius = UDim.new(0, 14)
G.UICorner.Parent = G.Main

-- UIGradient (UIGradient)
G.UIGradient = Instance.new("UIGradient")
G.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 15, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9))})
G.UIGradient.Rotation = 90
G.UIGradient.Parent = G.Main

-- UIStroke (UIStroke)
G.UIStroke = Instance.new("UIStroke")
G.UIStroke.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke.Thickness = 1.2000000476837158
G.UIStroke.Transparency = 0.44999998807907104
G.UIStroke.Parent = G.Main

-- WinScale (UIScale)
G.WinScale = Instance.new("UIScale")
G.WinScale.Name = "WinScale"
G.WinScale.Scale = 0.64999997615814209
G.WinScale.Parent = G.Main

-- Frame (Frame)
G.Frame = Instance.new("Frame")
G.Frame.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame.BorderSizePixel = 0
G.Frame.Size = UDim2.new(1, 0, 0, 44)
G.Frame.Parent = G.Main

-- UICorner_2 (UICorner)
G.UICorner_2 = Instance.new("UICorner")
G.UICorner_2.CornerRadius = UDim.new(0, 14)
G.UICorner_2.Parent = G.Frame

-- Frame_2 (Frame)
G.Frame_2 = Instance.new("Frame")
G.Frame_2.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_2.BorderSizePixel = 0
G.Frame_2.Position = UDim2.new(0, 0, 1, -14)
G.Frame_2.Size = UDim2.new(1, 0, 0, 14)
G.Frame_2.Parent = G.Frame

-- ImageLabel (ImageLabel)
G.ImageLabel = Instance.new("ImageLabel")
G.ImageLabel.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.ImageLabel.BorderSizePixel = 0
G.ImageLabel.Position = UDim2.new(0, 12, 0.5, -12)
G.ImageLabel.Size = UDim2.new(0, 24, 0, 24)
G.ImageLabel.Image = "rbxthumb://type=Asset&id=124491981850461&w=150&h=150"
G.ImageLabel.Parent = G.Frame

-- UICorner_3 (UICorner)
G.UICorner_3 = Instance.new("UICorner")
G.UICorner_3.CornerRadius = UDim.new(0, 12)
G.UICorner_3.Parent = G.ImageLabel

-- UIStroke_2 (UIStroke)
G.UIStroke_2 = Instance.new("UIStroke")
G.UIStroke_2.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_2.Thickness = 1.5
G.UIStroke_2.Transparency = 0.20000000298023224
G.UIStroke_2.Parent = G.ImageLabel

-- TextLabel (TextLabel)
G.TextLabel = Instance.new("TextLabel")
G.TextLabel.BackgroundTransparency = 1
G.TextLabel.Position = UDim2.new(0, 44, 0, 0)
G.TextLabel.Size = UDim2.new(1, -132, 1, 0)
G.TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel.Text = "RIDDLER"
G.TextLabel.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel.TextSize = 15
G.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel.Parent = G.Frame

-- Frame_3 (Frame)
G.Frame_3 = Instance.new("Frame")
G.Frame_3.BackgroundColor3 = Color3.fromRGB(55, 195, 105)
G.Frame_3.BorderSizePixel = 0
G.Frame_3.Position = UDim2.new(1, -160, 0.5, -4)
G.Frame_3.Size = UDim2.new(0, 8, 0, 8)
G.Frame_3.Parent = G.Frame

-- UICorner_4 (UICorner)
G.UICorner_4 = Instance.new("UICorner")
G.UICorner_4.CornerRadius = UDim.new(0, 4)
G.UICorner_4.Parent = G.Frame_3

-- TextButton (TextButton)
G.TextButton = Instance.new("TextButton")
G.TextButton.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton.BorderSizePixel = 0
G.TextButton.Position = UDim2.new(1, -149, 0.5, -11)
G.TextButton.Size = UDim2.new(0, 38, 0, 22)
G.TextButton.AutoButtonColor = false
G.TextButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton.Text = "Test"
G.TextButton.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton.TextSize = 10
G.TextButton.Parent = G.Frame

-- UICorner_5 (UICorner)
G.UICorner_5 = Instance.new("UICorner")
G.UICorner_5.Parent = G.TextButton

-- UIStroke_3 (UIStroke)
G.UIStroke_3 = Instance.new("UIStroke")
G.UIStroke_3.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_3.Transparency = 0.20000000298023224
G.UIStroke_3.Parent = G.TextButton

-- TextButton_2 (TextButton)
G.TextButton_2 = Instance.new("TextButton")
G.TextButton_2.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_2.BorderSizePixel = 0
G.TextButton_2.Position = UDim2.new(1, -108, 0.5, -11)
G.TextButton_2.Size = UDim2.new(0, 38, 0, 22)
G.TextButton_2.AutoButtonColor = false
G.TextButton_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_2.Text = "Feed"
G.TextButton_2.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_2.TextSize = 10
G.TextButton_2.Parent = G.Frame

-- UICorner_6 (UICorner)
G.UICorner_6 = Instance.new("UICorner")
G.UICorner_6.Parent = G.TextButton_2

-- UIStroke_4 (UIStroke)
G.UIStroke_4 = Instance.new("UIStroke")
G.UIStroke_4.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_4.Transparency = 0.20000000298023224
G.UIStroke_4.Parent = G.TextButton_2

-- TextButton_3 (TextButton)
G.TextButton_3 = Instance.new("TextButton")
G.TextButton_3.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_3.BorderSizePixel = 0
G.TextButton_3.Position = UDim2.new(1, -67, 0.5, -11)
G.TextButton_3.Size = UDim2.new(0, 38, 0, 22)
G.TextButton_3.AutoButtonColor = false
G.TextButton_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_3.Text = "Settings"
G.TextButton_3.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_3.Parent = G.Frame

-- UICorner_7 (UICorner)
G.UICorner_7 = Instance.new("UICorner")
G.UICorner_7.Parent = G.TextButton_3

-- UIStroke_5 (UIStroke)
G.UIStroke_5 = Instance.new("UIStroke")
G.UIStroke_5.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_5.Transparency = 0.20000000298023224
G.UIStroke_5.Parent = G.TextButton_3

-- TextButton_4 (TextButton)
G.TextButton_4 = Instance.new("TextButton")
G.TextButton_4.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_4.BorderSizePixel = 0
G.TextButton_4.Position = UDim2.new(1, -26, 0.5, -11)
G.TextButton_4.Size = UDim2.new(0, 22, 0, 22)
G.TextButton_4.AutoButtonColor = false
G.TextButton_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_4.Text = ""
G.TextButton_4.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_4.TextSize = 12
G.TextButton_4.Parent = G.Frame

-- UICorner_8 (UICorner)
G.UICorner_8 = Instance.new("UICorner")
G.UICorner_8.Parent = G.TextButton_4

-- UIStroke_6 (UIStroke)
G.UIStroke_6 = Instance.new("UIStroke")
G.UIStroke_6.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_6.Transparency = 0.20000000298023224
G.UIStroke_6.Parent = G.TextButton_4

-- Frame_4 (Frame)
G.Frame_4 = Instance.new("Frame")
G.Frame_4.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_4.BorderSizePixel = 0
G.Frame_4.Position = UDim2.new(0.5, -5, 0.5, -1)
G.Frame_4.Size = UDim2.new(0, 10, 0, 2)
G.Frame_4.Parent = G.TextButton_4

-- UICorner_9 (UICorner)
G.UICorner_9 = Instance.new("UICorner")
G.UICorner_9.CornerRadius = UDim.new(0, 1)
G.UICorner_9.Parent = G.Frame_4

-- Frame_5 (Frame)
G.Frame_5 = Instance.new("Frame")
G.Frame_5.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_5.BorderSizePixel = 0
G.Frame_5.Position = UDim2.new(0.5, -1, 0.5, -5)
G.Frame_5.Size = UDim2.new(0, 2, 0, 10)
G.Frame_5.Visible = false
G.Frame_5.Parent = G.TextButton_4

-- UICorner_10 (UICorner)
G.UICorner_10 = Instance.new("UICorner")
G.UICorner_10.CornerRadius = UDim.new(0, 1)
G.UICorner_10.Parent = G.Frame_5

-- CityBg (ImageLabel)
G.CityBg = Instance.new("ImageLabel")
G.CityBg.Name = "CityBg"
G.CityBg.BackgroundTransparency = 1
G.CityBg.BorderSizePixel = 0
G.CityBg.Size = UDim2.new(1, 0, 1, 0)
G.CityBg.ZIndex = 0
G.CityBg.Image = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420"
G.CityBg.ImageColor3 = Color3.fromRGB(200, 160, 190)
G.CityBg.ImageTransparency = 0.5
G.CityBg.ScaleType = Enum.ScaleType.Crop
G.CityBg.Parent = G.Main

-- UICorner_11 (UICorner)
G.UICorner_11 = Instance.new("UICorner")
G.UICorner_11.CornerRadius = UDim.new(0, 14)
G.UICorner_11.Parent = G.CityBg

-- LeavesLayer (Frame)
G.LeavesLayer = Instance.new("Frame")
G.LeavesLayer.Name = "LeavesLayer"
G.LeavesLayer.BackgroundTransparency = 1
G.LeavesLayer.BorderSizePixel = 0
G.LeavesLayer.ClipsDescendants = true
G.LeavesLayer.Size = UDim2.new(1, 0, 1, 0)
G.LeavesLayer.ZIndex = 0
G.LeavesLayer.Parent = G.Main

-- UICorner_12 (UICorner)
G.UICorner_12 = Instance.new("UICorner")
G.UICorner_12.CornerRadius = UDim.new(0, 14)
G.UICorner_12.Parent = G.LeavesLayer

-- Frame_6 (Frame)
G.Frame_6 = Instance.new("Frame")
G.Frame_6.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_6.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
G.Frame_6.BackgroundTransparency = 0.162838414311409
G.Frame_6.BorderSizePixel = 0
G.Frame_6.Position = UDim2.new(-0.099758774042129517, 0, 1, 20)
G.Frame_6.Rotation = 308
G.Frame_6.Size = UDim2.new(0, 8, 0, 10)
G.Frame_6.ZIndex = 0
G.Frame_6.Parent = G.LeavesLayer

-- UICorner_13 (UICorner)
G.UICorner_13 = Instance.new("UICorner")
G.UICorner_13.CornerRadius = UDim.new(1, 0)
G.UICorner_13.Parent = G.Frame_6

-- UIGradient_2 (UIGradient)
G.UIGradient_2 = Instance.new("UIGradient")
G.UIGradient_2.Rotation = 94
G.UIGradient_2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_2.Parent = G.Frame_6

-- Frame_7 (Frame)
G.Frame_7 = Instance.new("Frame")
G.Frame_7.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_7.BackgroundColor3 = Color3.fromRGB(230, 110, 170)
G.Frame_7.BackgroundTransparency = 0.29330736398696899
G.Frame_7.BorderSizePixel = 0
G.Frame_7.Position = UDim2.new(0.45008358359336853, 0, 0.87132805585861206, 19)
G.Frame_7.Rotation = 550.17041015625
G.Frame_7.Size = UDim2.new(0, 8, 0, 12)
G.Frame_7.ZIndex = 0
G.Frame_7.Parent = G.LeavesLayer

-- UICorner_14 (UICorner)
G.UICorner_14 = Instance.new("UICorner")
G.UICorner_14.CornerRadius = UDim.new(1, 0)
G.UICorner_14.Parent = G.Frame_7

-- UIGradient_3 (UIGradient)
G.UIGradient_3 = Instance.new("UIGradient")
G.UIGradient_3.Rotation = 222
G.UIGradient_3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_3.Parent = G.Frame_7

-- Frame_8 (Frame)
G.Frame_8 = Instance.new("Frame")
G.Frame_8.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_8.BackgroundColor3 = Color3.fromRGB(230, 110, 170)
G.Frame_8.BackgroundTransparency = 0.1985221654176712
G.Frame_8.BorderSizePixel = 0
G.Frame_8.Position = UDim2.new(0.62486618757247925, 0, 1, 20)
G.Frame_8.Rotation = -155
G.Frame_8.Size = UDim2.new(0, 8, 0, 10)
G.Frame_8.ZIndex = 0
G.Frame_8.Parent = G.LeavesLayer

-- UICorner_15 (UICorner)
G.UICorner_15 = Instance.new("UICorner")
G.UICorner_15.CornerRadius = UDim.new(1, 0)
G.UICorner_15.Parent = G.Frame_8

-- UIGradient_4 (UIGradient)
G.UIGradient_4 = Instance.new("UIGradient")
G.UIGradient_4.Rotation = 267
G.UIGradient_4.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_4.Parent = G.Frame_8

-- Frame_9 (Frame)
G.Frame_9 = Instance.new("Frame")
G.Frame_9.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_9.BackgroundColor3 = Color3.fromRGB(245, 135, 185)
G.Frame_9.BackgroundTransparency = 0.46777763962745667
G.Frame_9.BorderSizePixel = 0
G.Frame_9.Position = UDim2.new(0.34634146094322205, 0, 1, 20)
G.Frame_9.Rotation = -102
G.Frame_9.Size = UDim2.new(0, 7, 0, 10)
G.Frame_9.ZIndex = 0
G.Frame_9.Parent = G.LeavesLayer

-- UICorner_16 (UICorner)
G.UICorner_16 = Instance.new("UICorner")
G.UICorner_16.CornerRadius = UDim.new(1, 0)
G.UICorner_16.Parent = G.Frame_9

-- UIGradient_5 (UIGradient)
G.UIGradient_5 = Instance.new("UIGradient")
G.UIGradient_5.Rotation = 285
G.UIGradient_5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_5.Parent = G.Frame_9

-- Frame_10 (Frame)
G.Frame_10 = Instance.new("Frame")
G.Frame_10.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_10.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
G.Frame_10.BackgroundTransparency = 0.34376782178878784
G.Frame_10.BorderSizePixel = 0
G.Frame_10.Position = UDim2.new(0.9449307918548584, 0, 0.88963311910629272, 15)
G.Frame_10.Rotation = 64.05328369140625
G.Frame_10.Size = UDim2.new(0, 7, 0, 9)
G.Frame_10.ZIndex = 0
G.Frame_10.Parent = G.LeavesLayer

-- UICorner_17 (UICorner)
G.UICorner_17 = Instance.new("UICorner")
G.UICorner_17.CornerRadius = UDim.new(1, 0)
G.UICorner_17.Parent = G.Frame_10

-- UIGradient_6 (UIGradient)
G.UIGradient_6 = Instance.new("UIGradient")
G.UIGradient_6.Rotation = 110
G.UIGradient_6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_6.Parent = G.Frame_10

-- Frame_11 (Frame)
G.Frame_11 = Instance.new("Frame")
G.Frame_11.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_11.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
G.Frame_11.BackgroundTransparency = 0.41972547769546509
G.Frame_11.BorderSizePixel = 0
G.Frame_11.Position = UDim2.new(0.41142675280570984, 0, 0.78618299961090088, 15)
G.Frame_11.Rotation = 324.841796875
G.Frame_11.Size = UDim2.new(0, 7, 0, 11)
G.Frame_11.ZIndex = 0
G.Frame_11.Parent = G.LeavesLayer

-- UICorner_18 (UICorner)
G.UICorner_18 = Instance.new("UICorner")
G.UICorner_18.CornerRadius = UDim.new(1, 0)
G.UICorner_18.Parent = G.Frame_11

-- UIGradient_7 (UIGradient)
G.UIGradient_7 = Instance.new("UIGradient")
G.UIGradient_7.Rotation = 320
G.UIGradient_7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_7.Parent = G.Frame_11

-- Frame_12 (Frame)
G.Frame_12 = Instance.new("Frame")
G.Frame_12.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_12.BackgroundColor3 = Color3.fromRGB(245, 135, 185)
G.Frame_12.BackgroundTransparency = 0.17320886254310608
G.Frame_12.BorderSizePixel = 0
G.Frame_12.Position = UDim2.new(0.70356404781341553, 0, 0.67738503217697144, 8)
G.Frame_12.Rotation = -128.24020385742188
G.Frame_12.Size = UDim2.new(0, 6, 0, 8)
G.Frame_12.ZIndex = 0
G.Frame_12.Parent = G.LeavesLayer

-- UICorner_19 (UICorner)
G.UICorner_19 = Instance.new("UICorner")
G.UICorner_19.CornerRadius = UDim.new(1, 0)
G.UICorner_19.Parent = G.Frame_12

-- UIGradient_8 (UIGradient)
G.UIGradient_8 = Instance.new("UIGradient")
G.UIGradient_8.Rotation = 35
G.UIGradient_8.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_8.Parent = G.Frame_12

-- Frame_13 (Frame)
G.Frame_13 = Instance.new("Frame")
G.Frame_13.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_13.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
G.Frame_13.BackgroundTransparency = 0.18051715195178986
G.Frame_13.BorderSizePixel = 0
G.Frame_13.Position = UDim2.new(0.20770315825939178, 0, 0.57459545135498047, 7)
G.Frame_13.Rotation = 456.13235473632812
G.Frame_13.Size = UDim2.new(0, 7, 0, 10)
G.Frame_13.ZIndex = 0
G.Frame_13.Parent = G.LeavesLayer

-- UICorner_20 (UICorner)
G.UICorner_20 = Instance.new("UICorner")
G.UICorner_20.CornerRadius = UDim.new(1, 0)
G.UICorner_20.Parent = G.Frame_13

-- UIGradient_9 (UIGradient)
G.UIGradient_9 = Instance.new("UIGradient")
G.UIGradient_9.Rotation = 320
G.UIGradient_9.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_9.Parent = G.Frame_13

-- Frame_14 (Frame)
G.Frame_14 = Instance.new("Frame")
G.Frame_14.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_14.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
G.Frame_14.BackgroundTransparency = 0.38359025120735168
G.Frame_14.BorderSizePixel = 0
G.Frame_14.Position = UDim2.new(1.0094013214111328, 0, 0.66325241327285767, 11)
G.Frame_14.Rotation = -64.576263427734375
G.Frame_14.Size = UDim2.new(0, 8, 0, 11)
G.Frame_14.ZIndex = 0
G.Frame_14.Parent = G.LeavesLayer

-- UICorner_21 (UICorner)
G.UICorner_21 = Instance.new("UICorner")
G.UICorner_21.CornerRadius = UDim.new(1, 0)
G.UICorner_21.Parent = G.Frame_14

-- UIGradient_10 (UIGradient)
G.UIGradient_10 = Instance.new("UIGradient")
G.UIGradient_10.Rotation = 300
G.UIGradient_10.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_10.Parent = G.Frame_14

-- Frame_15 (Frame)
G.Frame_15 = Instance.new("Frame")
G.Frame_15.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_15.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
G.Frame_15.BackgroundTransparency = 0.3117002546787262
G.Frame_15.BorderSizePixel = 0
G.Frame_15.Position = UDim2.new(0.69358694553375244, 0, 0.7629019021987915, 12)
G.Frame_15.Rotation = 84.21319580078125
G.Frame_15.Size = UDim2.new(0, 7, 0, 9)
G.Frame_15.ZIndex = 0
G.Frame_15.Parent = G.LeavesLayer

-- UICorner_22 (UICorner)
G.UICorner_22 = Instance.new("UICorner")
G.UICorner_22.CornerRadius = UDim.new(1, 0)
G.UICorner_22.Parent = G.Frame_15

-- UIGradient_11 (UIGradient)
G.UIGradient_11 = Instance.new("UIGradient")
G.UIGradient_11.Rotation = 124
G.UIGradient_11.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_11.Parent = G.Frame_15

-- Frame_16 (Frame)
G.Frame_16 = Instance.new("Frame")
G.Frame_16.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_16.BackgroundColor3 = Color3.fromRGB(245, 135, 185)
G.Frame_16.BackgroundTransparency = 0.37438639998435974
G.Frame_16.BorderSizePixel = 0
G.Frame_16.Position = UDim2.new(0.80354809761047363, 0, 0.47786128520965576, 3)
G.Frame_16.Rotation = 309.64996337890625
G.Frame_16.Size = UDim2.new(0, 5, 0, 7)
G.Frame_16.ZIndex = 0
G.Frame_16.Parent = G.LeavesLayer

-- UICorner_23 (UICorner)
G.UICorner_23 = Instance.new("UICorner")
G.UICorner_23.CornerRadius = UDim.new(1, 0)
G.UICorner_23.Parent = G.Frame_16

-- UIGradient_12 (UIGradient)
G.UIGradient_12 = Instance.new("UIGradient")
G.UIGradient_12.Rotation = 70
G.UIGradient_12.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_12.Parent = G.Frame_16

-- Frame_17 (Frame)
G.Frame_17 = Instance.new("Frame")
G.Frame_17.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_17.BackgroundColor3 = Color3.fromRGB(255, 220, 235)
G.Frame_17.BackgroundTransparency = 0.42278820276260376
G.Frame_17.BorderSizePixel = 0
G.Frame_17.Position = UDim2.new(0.45550310611724854, 0, 0.43316084146499634, 2)
G.Frame_17.Rotation = 0.671417236328125
G.Frame_17.Size = UDim2.new(0, 5, 0, 8)
G.Frame_17.ZIndex = 0
G.Frame_17.Parent = G.LeavesLayer

-- UICorner_24 (UICorner)
G.UICorner_24 = Instance.new("UICorner")
G.UICorner_24.CornerRadius = UDim.new(1, 0)
G.UICorner_24.Parent = G.Frame_17

-- UIGradient_13 (UIGradient)
G.UIGradient_13 = Instance.new("UIGradient")
G.UIGradient_13.Rotation = 42
G.UIGradient_13.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_13.Parent = G.Frame_17

-- Frame_18 (Frame)
G.Frame_18 = Instance.new("Frame")
G.Frame_18.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_18.BackgroundColor3 = Color3.fromRGB(230, 110, 170)
G.Frame_18.BackgroundTransparency = 0.46347147226333618
G.Frame_18.BorderSizePixel = 0
G.Frame_18.Position = UDim2.new(0.29240250587463379, 0, 0.39989674091339111, 1)
G.Frame_18.Rotation = 289.54949951171875
G.Frame_18.Size = UDim2.new(0, 5, 0, 7)
G.Frame_18.ZIndex = 0
G.Frame_18.Parent = G.LeavesLayer

-- UICorner_25 (UICorner)
G.UICorner_25 = Instance.new("UICorner")
G.UICorner_25.CornerRadius = UDim.new(1, 0)
G.UICorner_25.Parent = G.Frame_18

-- UIGradient_14 (UIGradient)
G.UIGradient_14 = Instance.new("UIGradient")
G.UIGradient_14.Rotation = 332
G.UIGradient_14.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_14.Parent = G.Frame_18

-- Frame_19 (Frame)
G.Frame_19 = Instance.new("Frame")
G.Frame_19.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_19.BackgroundColor3 = Color3.fromRGB(255, 205, 225)
G.Frame_19.BackgroundTransparency = 0.2987731397151947
G.Frame_19.BorderSizePixel = 0
G.Frame_19.Position = UDim2.new(0.20819950103759766, 0, 0.32101219892501831, 0)
G.Frame_19.Rotation = 161.61500549316406
G.Frame_19.Size = UDim2.new(0, 6, 0, 9)
G.Frame_19.ZIndex = 0
G.Frame_19.Parent = G.LeavesLayer

-- UICorner_26 (UICorner)
G.UICorner_26 = Instance.new("UICorner")
G.UICorner_26.CornerRadius = UDim.new(1, 0)
G.UICorner_26.Parent = G.Frame_19

-- UIGradient_15 (UIGradient)
G.UIGradient_15 = Instance.new("UIGradient")
G.UIGradient_15.Rotation = 275
G.UIGradient_15.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_15.Parent = G.Frame_19

-- Frame_20 (Frame)
G.Frame_20 = Instance.new("Frame")
G.Frame_20.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_20.BackgroundColor3 = Color3.fromRGB(255, 175, 210)
G.Frame_20.BackgroundTransparency = 0.47325438261032104
G.Frame_20.BorderSizePixel = 0
G.Frame_20.Position = UDim2.new(0.73418211936950684, 0, 0.36020195484161377, 1)
G.Frame_20.Rotation = -109.66765594482422
G.Frame_20.Size = UDim2.new(0, 8, 0, 10)
G.Frame_20.ZIndex = 0
G.Frame_20.Parent = G.LeavesLayer

-- UICorner_27 (UICorner)
G.UICorner_27 = Instance.new("UICorner")
G.UICorner_27.CornerRadius = UDim.new(1, 0)
G.UICorner_27.Parent = G.Frame_20

-- UIGradient_16 (UIGradient)
G.UIGradient_16 = Instance.new("UIGradient")
G.UIGradient_16.Rotation = 158
G.UIGradient_16.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_16.Parent = G.Frame_20

-- Frame_21 (Frame)
G.Frame_21 = Instance.new("Frame")
G.Frame_21.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_21.BackgroundColor3 = Color3.fromRGB(245, 135, 185)
G.Frame_21.BackgroundTransparency = 0.28159576654434204
G.Frame_21.BorderSizePixel = 0
G.Frame_21.Position = UDim2.new(0.81040054559707642, 0, 0.18199968338012695, -4)
G.Frame_21.Rotation = -9.8579292297363281
G.Frame_21.Size = UDim2.new(0, 5, 0, 9)
G.Frame_21.ZIndex = 0
G.Frame_21.Parent = G.LeavesLayer

-- UICorner_28 (UICorner)
G.UICorner_28 = Instance.new("UICorner")
G.UICorner_28.CornerRadius = UDim.new(1, 0)
G.UICorner_28.Parent = G.Frame_21

-- UIGradient_17 (UIGradient)
G.UIGradient_17 = Instance.new("UIGradient")
G.UIGradient_17.Rotation = 127
G.UIGradient_17.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_17.Parent = G.Frame_21

-- Frame_22 (Frame)
G.Frame_22 = Instance.new("Frame")
G.Frame_22.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_22.BackgroundColor3 = Color3.fromRGB(255, 205, 225)
G.Frame_22.BackgroundTransparency = 0.28030988574028015
G.Frame_22.BorderSizePixel = 0
G.Frame_22.Position = UDim2.new(0.36771154403686523, 0, 0.25344598293304443, -2)
G.Frame_22.Rotation = -10.868389129638672
G.Frame_22.Size = UDim2.new(0, 5, 0, 7)
G.Frame_22.ZIndex = 0
G.Frame_22.Parent = G.LeavesLayer

-- UICorner_29 (UICorner)
G.UICorner_29 = Instance.new("UICorner")
G.UICorner_29.CornerRadius = UDim.new(1, 0)
G.UICorner_29.Parent = G.Frame_22

-- UIGradient_18 (UIGradient)
G.UIGradient_18 = Instance.new("UIGradient")
G.UIGradient_18.Rotation = 255
G.UIGradient_18.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0, 0), NumberSequenceKeypoint.new(1, 0.55000001192092896, 0)})
G.UIGradient_18.Parent = G.Frame_22

-- Frame_23 (Frame)
G.Frame_23 = Instance.new("Frame")
G.Frame_23.BackgroundTransparency = 1
G.Frame_23.Position = UDim2.new(0, 10, 0, 48)
G.Frame_23.Size = UDim2.new(1, -20, 1, -54)
G.Frame_23.Parent = G.Main

-- UIListLayout (UIListLayout)
G.UIListLayout = Instance.new("UIListLayout")
G.UIListLayout.Padding = UDim.new(0, 5)
G.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout.Parent = G.Frame_23

-- Frame_24 (Frame)
G.Frame_24 = Instance.new("Frame")
G.Frame_24.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_24.BorderSizePixel = 0
G.Frame_24.LayoutOrder = 1
G.Frame_24.Size = UDim2.new(1, 0, 0, 32)
G.Frame_24.Parent = G.Frame_23

-- UICorner_30 (UICorner)
G.UICorner_30 = Instance.new("UICorner")
G.UICorner_30.CornerRadius = UDim.new(0, 9)
G.UICorner_30.Parent = G.Frame_24

-- UIStroke_7 (UIStroke)
G.UIStroke_7 = Instance.new("UIStroke")
G.UIStroke_7.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_7.Transparency = 0.30000001192092896
G.UIStroke_7.Parent = G.Frame_24

-- Frame_25 (Frame)
G.Frame_25 = Instance.new("Frame")
G.Frame_25.BackgroundColor3 = Color3.fromRGB(55, 195, 105)
G.Frame_25.BorderSizePixel = 0
G.Frame_25.Position = UDim2.new(0, 12, 0.5, -4)
G.Frame_25.Size = UDim2.new(0, 8, 0, 8)
G.Frame_25.Parent = G.Frame_24

-- UICorner_31 (UICorner)
G.UICorner_31 = Instance.new("UICorner")
G.UICorner_31.CornerRadius = UDim.new(0, 4)
G.UICorner_31.Parent = G.Frame_25

-- TextLabel_2 (TextLabel)
G.TextLabel_2 = Instance.new("TextLabel")
G.TextLabel_2.BackgroundTransparency = 1
G.TextLabel_2.Position = UDim2.new(0, 28, 0, 0)
G.TextLabel_2.Size = UDim2.new(1, -32, 1, 0)
G.TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_2.Text = "ready - notify mapped"
G.TextLabel_2.TextColor3 = Color3.fromRGB(55, 195, 105)
G.TextLabel_2.TextSize = 12
G.TextLabel_2.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_2.Parent = G.Frame_24

-- Frame_26 (Frame)
G.Frame_26 = Instance.new("Frame")
G.Frame_26.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_26.BorderSizePixel = 0
G.Frame_26.LayoutOrder = 2
G.Frame_26.Size = UDim2.new(1, 0, 0, 44)
G.Frame_26.Parent = G.Frame_23

-- UICorner_32 (UICorner)
G.UICorner_32 = Instance.new("UICorner")
G.UICorner_32.CornerRadius = UDim.new(0, 9)
G.UICorner_32.Parent = G.Frame_26

-- UIStroke_8 (UIStroke)
G.UIStroke_8 = Instance.new("UIStroke")
G.UIStroke_8.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_8.Transparency = 0.30000001192092896
G.UIStroke_8.Parent = G.Frame_26

-- TextLabel_3 (TextLabel)
G.TextLabel_3 = Instance.new("TextLabel")
G.TextLabel_3.BackgroundTransparency = 1
G.TextLabel_3.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_3.Size = UDim2.new(1, -80, 1, 0)
G.TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_3.Text = "AI  -  OFF"
G.TextLabel_3.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_3.TextSize = 13
G.TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_3.Parent = G.Frame_26

-- Frame_27 (Frame)
G.Frame_27 = Instance.new("Frame")
G.Frame_27.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_27.BorderSizePixel = 0
G.Frame_27.Position = UDim2.new(1, -60, 0.5, -12)
G.Frame_27.Size = UDim2.new(0, 48, 0, 24)
G.Frame_27.Parent = G.Frame_26

-- UICorner_33 (UICorner)
G.UICorner_33 = Instance.new("UICorner")
G.UICorner_33.CornerRadius = UDim.new(0, 12)
G.UICorner_33.Parent = G.Frame_27

-- Frame_28 (Frame)
G.Frame_28 = Instance.new("Frame")
G.Frame_28.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_28.BorderSizePixel = 0
G.Frame_28.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_28.Size = UDim2.new(0, 18, 0, 18)
G.Frame_28.Parent = G.Frame_27

-- UICorner_34 (UICorner)
G.UICorner_34 = Instance.new("UICorner")
G.UICorner_34.CornerRadius = UDim.new(0, 9)
G.UICorner_34.Parent = G.Frame_28

-- TextButton_5 (TextButton)
G.TextButton_5 = Instance.new("TextButton")
G.TextButton_5.BackgroundTransparency = 1
G.TextButton_5.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_5.Text = ""
G.TextButton_5.Parent = G.Frame_26

-- Frame_29 (Frame)
G.Frame_29 = Instance.new("Frame")
G.Frame_29.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_29.BorderSizePixel = 0
G.Frame_29.LayoutOrder = 3
G.Frame_29.Size = UDim2.new(1, 0, 0, 44)
G.Frame_29.Parent = G.Frame_23

-- UICorner_35 (UICorner)
G.UICorner_35 = Instance.new("UICorner")
G.UICorner_35.CornerRadius = UDim.new(0, 9)
G.UICorner_35.Parent = G.Frame_29

-- UIStroke_9 (UIStroke)
G.UIStroke_9 = Instance.new("UIStroke")
G.UIStroke_9.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_9.Transparency = 0.30000001192092896
G.UIStroke_9.Parent = G.Frame_29

-- TextLabel_4 (TextLabel)
G.TextLabel_4 = Instance.new("TextLabel")
G.TextLabel_4.BackgroundTransparency = 1
G.TextLabel_4.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_4.Size = UDim2.new(1, -80, 1, 0)
G.TextLabel_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_4.Text = "LISTEN  -  OFF"
G.TextLabel_4.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_4.TextSize = 13
G.TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_4.Parent = G.Frame_29

-- Frame_30 (Frame)
G.Frame_30 = Instance.new("Frame")
G.Frame_30.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_30.BorderSizePixel = 0
G.Frame_30.Position = UDim2.new(1, -60, 0.5, -12)
G.Frame_30.Size = UDim2.new(0, 48, 0, 24)
G.Frame_30.Parent = G.Frame_29

-- UICorner_36 (UICorner)
G.UICorner_36 = Instance.new("UICorner")
G.UICorner_36.CornerRadius = UDim.new(0, 12)
G.UICorner_36.Parent = G.Frame_30

-- Frame_31 (Frame)
G.Frame_31 = Instance.new("Frame")
G.Frame_31.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_31.BorderSizePixel = 0
G.Frame_31.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_31.Size = UDim2.new(0, 18, 0, 18)
G.Frame_31.Parent = G.Frame_30

-- UICorner_37 (UICorner)
G.UICorner_37 = Instance.new("UICorner")
G.UICorner_37.CornerRadius = UDim.new(0, 9)
G.UICorner_37.Parent = G.Frame_31

-- TextButton_6 (TextButton)
G.TextButton_6 = Instance.new("TextButton")
G.TextButton_6.BackgroundTransparency = 1
G.TextButton_6.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_6.Text = ""
G.TextButton_6.Parent = G.Frame_29

-- Frame_32 (Frame)
G.Frame_32 = Instance.new("Frame")
G.Frame_32.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_32.BorderSizePixel = 0
G.Frame_32.LayoutOrder = 4
G.Frame_32.Size = UDim2.new(1, 0, 0, 62)
G.Frame_32.Parent = G.Frame_23

-- UICorner_38 (UICorner)
G.UICorner_38 = Instance.new("UICorner")
G.UICorner_38.CornerRadius = UDim.new(0, 9)
G.UICorner_38.Parent = G.Frame_32

-- UIStroke_10 (UIStroke)
G.UIStroke_10 = Instance.new("UIStroke")
G.UIStroke_10.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_10.Transparency = 0.30000001192092896
G.UIStroke_10.Parent = G.Frame_32

-- TextLabel_5 (TextLabel)
G.TextLabel_5 = Instance.new("TextLabel")
G.TextLabel_5.BackgroundTransparency = 1
G.TextLabel_5.Position = UDim2.new(0, 11, 0, 5)
G.TextLabel_5.Size = UDim2.new(1, -16, 0, 11)
G.TextLabel_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_5.Text = "QUESTION"
G.TextLabel_5.TextColor3 = Color3.fromRGB(235, 90, 175)
G.TextLabel_5.TextSize = 9
G.TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_5.Parent = G.Frame_32

-- TextLabel_6 (TextLabel)
G.TextLabel_6 = Instance.new("TextLabel")
G.TextLabel_6.BackgroundTransparency = 1
G.TextLabel_6.Position = UDim2.new(0, 11, 0, 18)
G.TextLabel_6.Size = UDim2.new(1, -22, 0, 40)
G.TextLabel_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
G.TextLabel_6.Text = "waiting..."
G.TextLabel_6.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_6.TextSize = 10
G.TextLabel_6.TextWrapped = true
G.TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_6.TextYAlignment = Enum.TextYAlignment.Top
G.TextLabel_6.Parent = G.Frame_32

-- TextButton_7 (TextButton)
G.TextButton_7 = Instance.new("TextButton")
G.TextButton_7.BackgroundTransparency = 1
G.TextButton_7.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_7.Text = ""
G.TextButton_7.Parent = G.Frame_32

-- Frame_33 (Frame)
G.Frame_33 = Instance.new("Frame")
G.Frame_33.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_33.BorderSizePixel = 0
G.Frame_33.LayoutOrder = 5
G.Frame_33.Size = UDim2.new(1, 0, 0, 54)
G.Frame_33.Parent = G.Frame_23

-- UICorner_39 (UICorner)
G.UICorner_39 = Instance.new("UICorner")
G.UICorner_39.CornerRadius = UDim.new(0, 9)
G.UICorner_39.Parent = G.Frame_33

-- UIStroke_11 (UIStroke)
G.UIStroke_11 = Instance.new("UIStroke")
G.UIStroke_11.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_11.Transparency = 0.34999999403953552
G.UIStroke_11.Parent = G.Frame_33

-- TextLabel_7 (TextLabel)
G.TextLabel_7 = Instance.new("TextLabel")
G.TextLabel_7.BackgroundTransparency = 1
G.TextLabel_7.Position = UDim2.new(0, 11, 0, 5)
G.TextLabel_7.Size = UDim2.new(1, -16, 0, 11)
G.TextLabel_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_7.Text = "ANSWER"
G.TextLabel_7.TextColor3 = Color3.fromRGB(235, 90, 175)
G.TextLabel_7.TextSize = 9
G.TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_7.Parent = G.Frame_33

-- TextBox (TextBox)
G.TextBox = Instance.new("TextBox")
G.TextBox.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
G.TextBox.BorderSizePixel = 0
G.TextBox.Position = UDim2.new(0, 9, 0, 19)
G.TextBox.Size = UDim2.new(1, -18, 0, 28)
G.TextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox.Text = ""
G.TextBox.TextColor3 = Color3.fromRGB(235, 90, 175)
G.TextBox.TextSize = 14
G.TextBox.TextXAlignment = Enum.TextXAlignment.Left
G.TextBox.ClearTextOnFocus = false
G.TextBox.PlaceholderColor3 = Color3.fromRGB(185, 175, 210)
G.TextBox.PlaceholderText = "answer appears here..."
G.TextBox.Parent = G.Frame_33

-- UICorner_40 (UICorner)
G.UICorner_40 = Instance.new("UICorner")
G.UICorner_40.CornerRadius = UDim.new(0, 7)
G.UICorner_40.Parent = G.TextBox

-- UIStroke_12 (UIStroke)
G.UIStroke_12 = Instance.new("UIStroke")
G.UIStroke_12.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_12.Thickness = 1.2000000476837158
G.UIStroke_12.Transparency = 0.25
G.UIStroke_12.Parent = G.TextBox

-- UIPadding (UIPadding)
G.UIPadding = Instance.new("UIPadding")
G.UIPadding.PaddingLeft = UDim.new(0, 9)
G.UIPadding.PaddingRight = UDim.new(0, 9)
G.UIPadding.Parent = G.TextBox

-- Frame_34 (Frame)
G.Frame_34 = Instance.new("Frame")
G.Frame_34.BackgroundTransparency = 1
G.Frame_34.LayoutOrder = 6
G.Frame_34.Size = UDim2.new(1, 0, 0, 33)
G.Frame_34.Parent = G.Frame_23

-- UIListLayout_2 (UIListLayout)
G.UIListLayout_2 = Instance.new("UIListLayout")
G.UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
G.UIListLayout_2.Padding = UDim.new(0, 6)
G.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_2.Parent = G.Frame_34

-- TextButton_8 (TextButton)
G.TextButton_8 = Instance.new("TextButton")
G.TextButton_8.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_8.BorderSizePixel = 0
G.TextButton_8.LayoutOrder = 1
G.TextButton_8.Size = UDim2.new(0.3333333432674408, -4, 1, 0)
G.TextButton_8.AutoButtonColor = false
G.TextButton_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_8.Text = "COPY"
G.TextButton_8.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_8.TextSize = 12
G.TextButton_8.Parent = G.Frame_34

-- UICorner_41 (UICorner)
G.UICorner_41 = Instance.new("UICorner")
G.UICorner_41.Parent = G.TextButton_8

-- UIStroke_13 (UIStroke)
G.UIStroke_13 = Instance.new("UIStroke")
G.UIStroke_13.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_13.Transparency = 0.20000000298023224
G.UIStroke_13.Parent = G.TextButton_8

-- TextButton_9 (TextButton)
G.TextButton_9 = Instance.new("TextButton")
G.TextButton_9.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_9.BorderSizePixel = 0
G.TextButton_9.LayoutOrder = 2
G.TextButton_9.Size = UDim2.new(0.3333333432674408, -4, 1, 0)
G.TextButton_9.AutoButtonColor = false
G.TextButton_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_9.Text = "CLEAR"
G.TextButton_9.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_9.TextSize = 12
G.TextButton_9.Parent = G.Frame_34

-- UICorner_42 (UICorner)
G.UICorner_42 = Instance.new("UICorner")
G.UICorner_42.Parent = G.TextButton_9

-- UIStroke_14 (UIStroke)
G.UIStroke_14 = Instance.new("UIStroke")
G.UIStroke_14.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_14.Transparency = 0.20000000298023224
G.UIStroke_14.Parent = G.TextButton_9

-- TextButton_10 (TextButton)
G.TextButton_10 = Instance.new("TextButton")
G.TextButton_10.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
G.TextButton_10.BorderSizePixel = 0
G.TextButton_10.LayoutOrder = 3
G.TextButton_10.Size = UDim2.new(0.3333333432674408, -4, 1, 0)
G.TextButton_10.AutoButtonColor = false
G.TextButton_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_10.Text = "REDEEM"
G.TextButton_10.TextColor3 = Color3.fromRGB(0, 0, 0)
G.TextButton_10.TextSize = 13
G.TextButton_10.Parent = G.Frame_34

-- UICorner_43 (UICorner)
G.UICorner_43 = Instance.new("UICorner")
G.UICorner_43.Parent = G.TextButton_10

-- UIGradient_19 (UIGradient)
G.UIGradient_19 = Instance.new("UIGradient")
G.UIGradient_19.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 90, 175)), ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 50, 110))})
G.UIGradient_19.Rotation = 90
G.UIGradient_19.Parent = G.TextButton_10

-- Frame_35 (Frame)
G.Frame_35 = Instance.new("Frame")
G.Frame_35.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_35.BorderSizePixel = 0
G.Frame_35.LayoutOrder = 7
G.Frame_35.Size = UDim2.new(1, 0, 0, 31)
G.Frame_35.Parent = G.Frame_23

-- UICorner_44 (UICorner)
G.UICorner_44 = Instance.new("UICorner")
G.UICorner_44.Parent = G.Frame_35

-- UIStroke_15 (UIStroke)
G.UIStroke_15 = Instance.new("UIStroke")
G.UIStroke_15.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_15.Transparency = 0.30000001192092896
G.UIStroke_15.Parent = G.Frame_35

-- TextLabel_8 (TextLabel)
G.TextLabel_8 = Instance.new("TextLabel")
G.TextLabel_8.BackgroundTransparency = 1
G.TextLabel_8.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_8.Size = UDim2.new(1, -56, 1, 0)
G.TextLabel_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_8.Text = "AUTO REDEEM ANSWER"
G.TextLabel_8.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_8.TextSize = 11
G.TextLabel_8.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_8.Parent = G.Frame_35

-- Frame_36 (Frame)
G.Frame_36 = Instance.new("Frame")
G.Frame_36.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_36.BorderSizePixel = 0
G.Frame_36.Position = UDim2.new(1, -46, 0.5, -9)
G.Frame_36.Size = UDim2.new(0, 36, 0, 18)
G.Frame_36.Parent = G.Frame_35

-- UICorner_45 (UICorner)
G.UICorner_45 = Instance.new("UICorner")
G.UICorner_45.CornerRadius = UDim.new(0, 9)
G.UICorner_45.Parent = G.Frame_36

-- Frame_37 (Frame)
G.Frame_37 = Instance.new("Frame")
G.Frame_37.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_37.BorderSizePixel = 0
G.Frame_37.Position = UDim2.new(0, 2, 0.5, -7)
G.Frame_37.Size = UDim2.new(0, 14, 0, 14)
G.Frame_37.Parent = G.Frame_36

-- UICorner_46 (UICorner)
G.UICorner_46 = Instance.new("UICorner")
G.UICorner_46.CornerRadius = UDim.new(0, 7)
G.UICorner_46.Parent = G.Frame_37

-- TextButton_11 (TextButton)
G.TextButton_11 = Instance.new("TextButton")
G.TextButton_11.BackgroundTransparency = 1
G.TextButton_11.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_11.Text = ""
G.TextButton_11.Parent = G.Frame_35

-- Frame_38 (Frame)
G.Frame_38 = Instance.new("Frame")
G.Frame_38.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_38.BorderSizePixel = 0
G.Frame_38.LayoutOrder = 8
G.Frame_38.Size = UDim2.new(1, 0, 0, 31)
G.Frame_38.Parent = G.Frame_23

-- UICorner_47 (UICorner)
G.UICorner_47 = Instance.new("UICorner")
G.UICorner_47.Parent = G.Frame_38

-- UIStroke_16 (UIStroke)
G.UIStroke_16 = Instance.new("UIStroke")
G.UIStroke_16.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_16.Transparency = 0.30000001192092896
G.UIStroke_16.Parent = G.Frame_38

-- TextLabel_9 (TextLabel)
G.TextLabel_9 = Instance.new("TextLabel")
G.TextLabel_9.BackgroundTransparency = 1
G.TextLabel_9.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_9.Size = UDim2.new(1, -56, 1, 0)
G.TextLabel_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_9.Text = "SECURE ANSWER (1-3)"
G.TextLabel_9.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_9.TextSize = 11
G.TextLabel_9.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_9.Parent = G.Frame_38

-- Frame_39 (Frame)
G.Frame_39 = Instance.new("Frame")
G.Frame_39.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_39.BorderSizePixel = 0
G.Frame_39.Position = UDim2.new(1, -46, 0.5, -9)
G.Frame_39.Size = UDim2.new(0, 36, 0, 18)
G.Frame_39.Parent = G.Frame_38

-- UICorner_48 (UICorner)
G.UICorner_48 = Instance.new("UICorner")
G.UICorner_48.CornerRadius = UDim.new(0, 9)
G.UICorner_48.Parent = G.Frame_39

-- Frame_40 (Frame)
G.Frame_40 = Instance.new("Frame")
G.Frame_40.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_40.BorderSizePixel = 0
G.Frame_40.Position = UDim2.new(0, 2, 0.5, -7)
G.Frame_40.Size = UDim2.new(0, 14, 0, 14)
G.Frame_40.Parent = G.Frame_39

-- UICorner_49 (UICorner)
G.UICorner_49 = Instance.new("UICorner")
G.UICorner_49.CornerRadius = UDim.new(0, 7)
G.UICorner_49.Parent = G.Frame_40

-- TextButton_12 (TextButton)
G.TextButton_12 = Instance.new("TextButton")
G.TextButton_12.BackgroundTransparency = 1
G.TextButton_12.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_12.Text = ""
G.TextButton_12.Parent = G.Frame_38

-- Frame_41 (Frame)
G.Frame_41 = Instance.new("Frame")
G.Frame_41.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_41.BorderSizePixel = 0
G.Frame_41.LayoutOrder = 9
G.Frame_41.Size = UDim2.new(1, 0, 0, 31)
G.Frame_41.Parent = G.Frame_23

-- UICorner_50 (UICorner)
G.UICorner_50 = Instance.new("UICorner")
G.UICorner_50.Parent = G.Frame_41

-- UIStroke_17 (UIStroke)
G.UIStroke_17 = Instance.new("UIStroke")
G.UIStroke_17.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_17.Transparency = 0.30000001192092896
G.UIStroke_17.Parent = G.Frame_41

-- TextLabel_10 (TextLabel)
G.TextLabel_10 = Instance.new("TextLabel")
G.TextLabel_10.BackgroundTransparency = 1
G.TextLabel_10.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_10.Size = UDim2.new(1, -56, 1, 0)
G.TextLabel_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_10.Text = "AUTO COPY ANSWER"
G.TextLabel_10.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_10.TextSize = 11
G.TextLabel_10.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_10.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_10.Parent = G.Frame_41

-- Frame_42 (Frame)
G.Frame_42 = Instance.new("Frame")
G.Frame_42.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_42.BorderSizePixel = 0
G.Frame_42.Position = UDim2.new(1, -46, 0.5, -9)
G.Frame_42.Size = UDim2.new(0, 36, 0, 18)
G.Frame_42.Parent = G.Frame_41

-- UICorner_51 (UICorner)
G.UICorner_51 = Instance.new("UICorner")
G.UICorner_51.CornerRadius = UDim.new(0, 9)
G.UICorner_51.Parent = G.Frame_42

-- Frame_43 (Frame)
G.Frame_43 = Instance.new("Frame")
G.Frame_43.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_43.BorderSizePixel = 0
G.Frame_43.Position = UDim2.new(0, 2, 0.5, -7)
G.Frame_43.Size = UDim2.new(0, 14, 0, 14)
G.Frame_43.Parent = G.Frame_42

-- UICorner_52 (UICorner)
G.UICorner_52 = Instance.new("UICorner")
G.UICorner_52.CornerRadius = UDim.new(0, 7)
G.UICorner_52.Parent = G.Frame_43

-- TextButton_13 (TextButton)
G.TextButton_13 = Instance.new("TextButton")
G.TextButton_13.BackgroundTransparency = 1
G.TextButton_13.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_13.Text = ""
G.TextButton_13.Parent = G.Frame_41

-- Frame_44 (Frame)
G.Frame_44 = Instance.new("Frame")
G.Frame_44.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_44.BorderSizePixel = 0
G.Frame_44.LayoutOrder = 10
G.Frame_44.Size = UDim2.new(1, 0, 0, 31)
G.Frame_44.Parent = G.Frame_23

-- UICorner_53 (UICorner)
G.UICorner_53 = Instance.new("UICorner")
G.UICorner_53.Parent = G.Frame_44

-- UIStroke_18 (UIStroke)
G.UIStroke_18 = Instance.new("UIStroke")
G.UIStroke_18.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_18.Transparency = 0.30000001192092896
G.UIStroke_18.Parent = G.Frame_44

-- TextLabel_11 (TextLabel)
G.TextLabel_11 = Instance.new("TextLabel")
G.TextLabel_11.BackgroundTransparency = 1
G.TextLabel_11.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_11.Size = UDim2.new(1, -56, 1, 0)
G.TextLabel_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_11.Text = "OPEN FEED ON HIT"
G.TextLabel_11.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_11.TextSize = 11
G.TextLabel_11.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_11.Parent = G.Frame_44

-- Frame_45 (Frame)
G.Frame_45 = Instance.new("Frame")
G.Frame_45.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_45.BorderSizePixel = 0
G.Frame_45.Position = UDim2.new(1, -46, 0.5, -9)
G.Frame_45.Size = UDim2.new(0, 36, 0, 18)
G.Frame_45.Parent = G.Frame_44

-- UICorner_54 (UICorner)
G.UICorner_54 = Instance.new("UICorner")
G.UICorner_54.CornerRadius = UDim.new(0, 9)
G.UICorner_54.Parent = G.Frame_45

-- Frame_46 (Frame)
G.Frame_46 = Instance.new("Frame")
G.Frame_46.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_46.BorderSizePixel = 0
G.Frame_46.Position = UDim2.new(0, 2, 0.5, -7)
G.Frame_46.Size = UDim2.new(0, 14, 0, 14)
G.Frame_46.Parent = G.Frame_45

-- UICorner_55 (UICorner)
G.UICorner_55 = Instance.new("UICorner")
G.UICorner_55.CornerRadius = UDim.new(0, 7)
G.UICorner_55.Parent = G.Frame_46

-- TextButton_14 (TextButton)
G.TextButton_14 = Instance.new("TextButton")
G.TextButton_14.BackgroundTransparency = 1
G.TextButton_14.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_14.Text = ""
G.TextButton_14.Parent = G.Frame_44

-- Frame_47 (Frame)
G.Frame_47 = Instance.new("Frame")
G.Frame_47.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_47.BorderSizePixel = 0
G.Frame_47.LayoutOrder = 11
G.Frame_47.Size = UDim2.new(1, 0, 0, 31)
G.Frame_47.Parent = G.Frame_23

-- UICorner_56 (UICorner)
G.UICorner_56 = Instance.new("UICorner")
G.UICorner_56.Parent = G.Frame_47

-- UIStroke_19 (UIStroke)
G.UIStroke_19 = Instance.new("UIStroke")
G.UIStroke_19.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_19.Transparency = 0.30000001192092896
G.UIStroke_19.Parent = G.Frame_47

-- TextLabel_12 (TextLabel)
G.TextLabel_12 = Instance.new("TextLabel")
G.TextLabel_12.BackgroundTransparency = 1
G.TextLabel_12.Position = UDim2.new(0, 11, 0, 0)
G.TextLabel_12.Size = UDim2.new(0, 56, 0, 31)
G.TextLabel_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_12.Text = "MODEL"
G.TextLabel_12.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_12.TextSize = 11
G.TextLabel_12.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_12.Parent = G.Frame_47

-- Frame_48 (Frame)
G.Frame_48 = Instance.new("Frame")
G.Frame_48.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
G.Frame_48.BorderSizePixel = 0
G.Frame_48.Position = UDim2.new(1, -177, 0.5, -11)
G.Frame_48.Size = UDim2.new(0, 168, 0, 23)
G.Frame_48.Parent = G.Frame_47

-- UICorner_57 (UICorner)
G.UICorner_57 = Instance.new("UICorner")
G.UICorner_57.CornerRadius = UDim.new(0, 7)
G.UICorner_57.Parent = G.Frame_48

-- TextButton_15 (TextButton)
G.TextButton_15 = Instance.new("TextButton")
G.TextButton_15.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
G.TextButton_15.BorderSizePixel = 0
G.TextButton_15.Position = UDim2.new(0, 1, 0, 1)
G.TextButton_15.Size = UDim2.new(0.5, -2, 1, -2)
G.TextButton_15.AutoButtonColor = false
G.TextButton_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_15.Text = "FASTER"
G.TextButton_15.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_15.TextSize = 10
G.TextButton_15.Parent = G.Frame_48

-- UICorner_58 (UICorner)
G.UICorner_58 = Instance.new("UICorner")
G.UICorner_58.CornerRadius = UDim.new(0, 6)
G.UICorner_58.Parent = G.TextButton_15

-- TextButton_16 (TextButton)
G.TextButton_16 = Instance.new("TextButton")
G.TextButton_16.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
G.TextButton_16.BorderSizePixel = 0
G.TextButton_16.Position = UDim2.new(0.5, 1, 0, 1)
G.TextButton_16.Size = UDim2.new(0.5, -2, 1, -2)
G.TextButton_16.AutoButtonColor = false
G.TextButton_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_16.Text = "FAST"
G.TextButton_16.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextButton_16.TextSize = 10
G.TextButton_16.Parent = G.Frame_48

-- UICorner_59 (UICorner)
G.UICorner_59 = Instance.new("UICorner")
G.UICorner_59.CornerRadius = UDim.new(0, 6)
G.UICorner_59.Parent = G.TextButton_16

-- Feed (Frame)
G.Feed = Instance.new("Frame")
G.Feed.Name = "Feed"
G.Feed.Active = true
G.Feed.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
G.Feed.BorderSizePixel = 0
G.Feed.ClipsDescendants = true
G.Feed.Position = UDim2.new(0.5, -322, 0.5, -168)
G.Feed.Size = UDim2.new(0, 348, 0, 392)
G.Feed.Parent = G.Riddler

-- UICorner_60 (UICorner)
G.UICorner_60 = Instance.new("UICorner")
G.UICorner_60.CornerRadius = UDim.new(0, 14)
G.UICorner_60.Parent = G.Feed

-- UIGradient_20 (UIGradient)
G.UIGradient_20 = Instance.new("UIGradient")
G.UIGradient_20.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 15, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9))})
G.UIGradient_20.Rotation = 90
G.UIGradient_20.Parent = G.Feed

-- UIStroke_20 (UIStroke)
G.UIStroke_20 = Instance.new("UIStroke")
G.UIStroke_20.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_20.Thickness = 1.2000000476837158
G.UIStroke_20.Transparency = 0.44999998807907104
G.UIStroke_20.Parent = G.Feed

-- WinScale_2 (UIScale)
G.WinScale_2 = Instance.new("UIScale")
G.WinScale_2.Name = "WinScale"
G.WinScale_2.Scale = 0.64999997615814209
G.WinScale_2.Parent = G.Feed

-- Frame_49 (Frame)
G.Frame_49 = Instance.new("Frame")
G.Frame_49.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_49.BorderSizePixel = 0
G.Frame_49.Size = UDim2.new(1, 0, 0, 44)
G.Frame_49.Parent = G.Feed

-- UICorner_61 (UICorner)
G.UICorner_61 = Instance.new("UICorner")
G.UICorner_61.CornerRadius = UDim.new(0, 14)
G.UICorner_61.Parent = G.Frame_49

-- Frame_50 (Frame)
G.Frame_50 = Instance.new("Frame")
G.Frame_50.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_50.BorderSizePixel = 0
G.Frame_50.Position = UDim2.new(0, 0, 1, -14)
G.Frame_50.Size = UDim2.new(1, 0, 0, 14)
G.Frame_50.Parent = G.Frame_49

-- ImageLabel_2 (ImageLabel)
G.ImageLabel_2 = Instance.new("ImageLabel")
G.ImageLabel_2.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.ImageLabel_2.BorderSizePixel = 0
G.ImageLabel_2.Position = UDim2.new(0, 12, 0.5, -12)
G.ImageLabel_2.Size = UDim2.new(0, 24, 0, 24)
G.ImageLabel_2.Image = "rbxthumb://type=Asset&id=124491981850461&w=150&h=150"
G.ImageLabel_2.Parent = G.Frame_49

-- UICorner_62 (UICorner)
G.UICorner_62 = Instance.new("UICorner")
G.UICorner_62.CornerRadius = UDim.new(0, 12)
G.UICorner_62.Parent = G.ImageLabel_2

-- UIStroke_21 (UIStroke)
G.UIStroke_21 = Instance.new("UIStroke")
G.UIStroke_21.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_21.Thickness = 1.5
G.UIStroke_21.Transparency = 0.20000000298023224
G.UIStroke_21.Parent = G.ImageLabel_2

-- TextLabel_13 (TextLabel)
G.TextLabel_13 = Instance.new("TextLabel")
G.TextLabel_13.BackgroundTransparency = 1
G.TextLabel_13.Position = UDim2.new(0, 44, 0, 0)
G.TextLabel_13.Size = UDim2.new(1, -204, 1, 0)
G.TextLabel_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_13.Text = "SOLVE LOG"
G.TextLabel_13.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel_13.TextSize = 15
G.TextLabel_13.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_13.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_13.Parent = G.Frame_49

-- TextButton_17 (TextButton)
G.TextButton_17 = Instance.new("TextButton")
G.TextButton_17.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_17.BorderSizePixel = 0
G.TextButton_17.Position = UDim2.new(1, -32, 0.5, -12)
G.TextButton_17.Size = UDim2.new(0, 24, 0, 24)
G.TextButton_17.AutoButtonColor = false
G.TextButton_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_17.Text = "X"
G.TextButton_17.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_17.TextSize = 12
G.TextButton_17.Parent = G.Frame_49

-- UICorner_63 (UICorner)
G.UICorner_63 = Instance.new("UICorner")
G.UICorner_63.Parent = G.TextButton_17

-- UIStroke_22 (UIStroke)
G.UIStroke_22 = Instance.new("UIStroke")
G.UIStroke_22.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_22.Transparency = 0.20000000298023224
G.UIStroke_22.Parent = G.TextButton_17

-- TextButton_18 (TextButton)
G.TextButton_18 = Instance.new("TextButton")
G.TextButton_18.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_18.BorderSizePixel = 0
G.TextButton_18.Position = UDim2.new(1, -84, 0.5, -12)
G.TextButton_18.Size = UDim2.new(0, 46, 0, 24)
G.TextButton_18.AutoButtonColor = false
G.TextButton_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_18.Text = "Clear"
G.TextButton_18.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_18.TextSize = 10
G.TextButton_18.Parent = G.Frame_49

-- UICorner_64 (UICorner)
G.UICorner_64 = Instance.new("UICorner")
G.UICorner_64.Parent = G.TextButton_18

-- UIStroke_23 (UIStroke)
G.UIStroke_23 = Instance.new("UIStroke")
G.UIStroke_23.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_23.Transparency = 0.20000000298023224
G.UIStroke_23.Parent = G.TextButton_18

-- TextLabel_14 (TextLabel)
G.TextLabel_14 = Instance.new("TextLabel")
G.TextLabel_14.BackgroundTransparency = 1
G.TextLabel_14.Position = UDim2.new(1, -152, 0, 0)
G.TextLabel_14.Size = UDim2.new(0, 62, 1, 0)
G.TextLabel_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_14.Text = "0 solved"
G.TextLabel_14.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_14.TextSize = 10
G.TextLabel_14.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_14.Parent = G.Frame_49

-- ScrollingFrame (ScrollingFrame)
G.ScrollingFrame = Instance.new("ScrollingFrame")
G.ScrollingFrame.BackgroundTransparency = 1
G.ScrollingFrame.BorderSizePixel = 0
G.ScrollingFrame.Position = UDim2.new(0, 11, 0, 50)
G.ScrollingFrame.Size = UDim2.new(1, -18, 1, -56)
G.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
G.ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(235, 90, 175)
G.ScrollingFrame.ScrollBarImageTransparency = 0.30000001192092896
G.ScrollingFrame.ScrollBarThickness = 3
G.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
G.ScrollingFrame.Parent = G.Feed

-- UIListLayout_3 (UIListLayout)
G.UIListLayout_3 = Instance.new("UIListLayout")
G.UIListLayout_3.Padding = UDim.new(0, 6)
G.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_3.Parent = G.ScrollingFrame

-- TextLabel_15 (TextLabel)
G.TextLabel_15 = Instance.new("TextLabel")
G.TextLabel_15.BackgroundTransparency = 1
G.TextLabel_15.LayoutOrder = 999
G.TextLabel_15.Size = UDim2.new(1, 0, 0, 34)
G.TextLabel_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
G.TextLabel_15.Text = "waiting for riddles..."
G.TextLabel_15.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_15.TextSize = 11
G.TextLabel_15.Parent = G.ScrollingFrame

-- Test (Frame)
G.Test = Instance.new("Frame")
G.Test.Name = "Test"
G.Test.Active = true
G.Test.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
G.Test.BorderSizePixel = 0
G.Test.ClipsDescendants = true
G.Test.Position = UDim2.new(0.5, -89, 0.5, -177)
G.Test.Size = UDim2.new(0, 300, 0, 214)
G.Test.Parent = G.Riddler

-- UICorner_65 (UICorner)
G.UICorner_65 = Instance.new("UICorner")
G.UICorner_65.CornerRadius = UDim.new(0, 14)
G.UICorner_65.Parent = G.Test

-- UIGradient_21 (UIGradient)
G.UIGradient_21 = Instance.new("UIGradient")
G.UIGradient_21.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 15, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9))})
G.UIGradient_21.Rotation = 90
G.UIGradient_21.Parent = G.Test

-- UIStroke_24 (UIStroke)
G.UIStroke_24 = Instance.new("UIStroke")
G.UIStroke_24.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_24.Thickness = 1.2000000476837158
G.UIStroke_24.Transparency = 0.44999998807907104
G.UIStroke_24.Parent = G.Test

-- WinScale_3 (UIScale)
G.WinScale_3 = Instance.new("UIScale")
G.WinScale_3.Name = "WinScale"
G.WinScale_3.Scale = 0.64999997615814209
G.WinScale_3.Parent = G.Test

-- Frame_51 (Frame)
G.Frame_51 = Instance.new("Frame")
G.Frame_51.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_51.BorderSizePixel = 0
G.Frame_51.Size = UDim2.new(1, 0, 0, 44)
G.Frame_51.Parent = G.Test

-- UICorner_66 (UICorner)
G.UICorner_66 = Instance.new("UICorner")
G.UICorner_66.CornerRadius = UDim.new(0, 14)
G.UICorner_66.Parent = G.Frame_51

-- Frame_52 (Frame)
G.Frame_52 = Instance.new("Frame")
G.Frame_52.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_52.BorderSizePixel = 0
G.Frame_52.Position = UDim2.new(0, 0, 1, -14)
G.Frame_52.Size = UDim2.new(1, 0, 0, 14)
G.Frame_52.Parent = G.Frame_51

-- ImageLabel_3 (ImageLabel)
G.ImageLabel_3 = Instance.new("ImageLabel")
G.ImageLabel_3.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.ImageLabel_3.BorderSizePixel = 0
G.ImageLabel_3.Position = UDim2.new(0, 12, 0.5, -12)
G.ImageLabel_3.Size = UDim2.new(0, 24, 0, 24)
G.ImageLabel_3.Image = "rbxthumb://type=Asset&id=124491981850461&w=150&h=150"
G.ImageLabel_3.Parent = G.Frame_51

-- UICorner_67 (UICorner)
G.UICorner_67 = Instance.new("UICorner")
G.UICorner_67.CornerRadius = UDim.new(0, 12)
G.UICorner_67.Parent = G.ImageLabel_3

-- UIStroke_25 (UIStroke)
G.UIStroke_25 = Instance.new("UIStroke")
G.UIStroke_25.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_25.Thickness = 1.5
G.UIStroke_25.Transparency = 0.20000000298023224
G.UIStroke_25.Parent = G.ImageLabel_3

-- TextLabel_16 (TextLabel)
G.TextLabel_16 = Instance.new("TextLabel")
G.TextLabel_16.BackgroundTransparency = 1
G.TextLabel_16.Position = UDim2.new(0, 44, 0, 0)
G.TextLabel_16.Size = UDim2.new(1, -132, 1, 0)
G.TextLabel_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_16.Text = "TEST SENDER"
G.TextLabel_16.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel_16.TextSize = 15
G.TextLabel_16.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_16.Parent = G.Frame_51

-- TextButton_19 (TextButton)
G.TextButton_19 = Instance.new("TextButton")
G.TextButton_19.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_19.BorderSizePixel = 0
G.TextButton_19.Position = UDim2.new(1, -28, 0.5, -11)
G.TextButton_19.Size = UDim2.new(0, 22, 0, 22)
G.TextButton_19.AutoButtonColor = false
G.TextButton_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_19.Text = "X"
G.TextButton_19.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_19.TextSize = 12
G.TextButton_19.Parent = G.Frame_51

-- UICorner_68 (UICorner)
G.UICorner_68 = Instance.new("UICorner")
G.UICorner_68.Parent = G.TextButton_19

-- UIStroke_26 (UIStroke)
G.UIStroke_26 = Instance.new("UIStroke")
G.UIStroke_26.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_26.Transparency = 0.20000000298023224
G.UIStroke_26.Parent = G.TextButton_19

-- Frame_53 (Frame)
G.Frame_53 = Instance.new("Frame")
G.Frame_53.BackgroundTransparency = 1
G.Frame_53.Position = UDim2.new(0, 12, 0, 50)
G.Frame_53.Size = UDim2.new(1, -24, 1, -58)
G.Frame_53.Parent = G.Test

-- UIListLayout_4 (UIListLayout)
G.UIListLayout_4 = Instance.new("UIListLayout")
G.UIListLayout_4.Padding = UDim.new(0, 8)
G.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_4.Parent = G.Frame_53

-- Frame_54 (Frame)
G.Frame_54 = Instance.new("Frame")
G.Frame_54.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_54.BorderSizePixel = 0
G.Frame_54.LayoutOrder = 1
G.Frame_54.Size = UDim2.new(1, 0, 0, 54)
G.Frame_54.Parent = G.Frame_53

-- UICorner_69 (UICorner)
G.UICorner_69 = Instance.new("UICorner")
G.UICorner_69.CornerRadius = UDim.new(0, 9)
G.UICorner_69.Parent = G.Frame_54

-- UIStroke_27 (UIStroke)
G.UIStroke_27 = Instance.new("UIStroke")
G.UIStroke_27.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_27.Transparency = 0.30000001192092896
G.UIStroke_27.Parent = G.Frame_54

-- TextLabel_17 (TextLabel)
G.TextLabel_17 = Instance.new("TextLabel")
G.TextLabel_17.BackgroundTransparency = 1
G.TextLabel_17.Position = UDim2.new(0, 11, 0, 6)
G.TextLabel_17.Size = UDim2.new(1, -16, 0, 12)
G.TextLabel_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_17.Text = "FAKE RIDDLE"
G.TextLabel_17.TextColor3 = Color3.fromRGB(235, 90, 175)
G.TextLabel_17.TextSize = 9
G.TextLabel_17.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_17.Parent = G.Frame_54

-- TextBox_2 (TextBox)
G.TextBox_2 = Instance.new("TextBox")
G.TextBox_2.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
G.TextBox_2.BorderSizePixel = 0
G.TextBox_2.Position = UDim2.new(0, 9, 0, 20)
G.TextBox_2.Size = UDim2.new(1, -18, 0, 26)
G.TextBox_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_2.Text = ""
G.TextBox_2.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextBox_2.TextSize = 12
G.TextBox_2.TextXAlignment = Enum.TextXAlignment.Left
G.TextBox_2.ClearTextOnFocus = false
G.TextBox_2.PlaceholderColor3 = Color3.fromRGB(185, 175, 210)
G.TextBox_2.PlaceholderText = "type a riddle to test..."
G.TextBox_2.Parent = G.Frame_54

-- UICorner_70 (UICorner)
G.UICorner_70 = Instance.new("UICorner")
G.UICorner_70.CornerRadius = UDim.new(0, 7)
G.UICorner_70.Parent = G.TextBox_2

-- UIPadding_2 (UIPadding)
G.UIPadding_2 = Instance.new("UIPadding")
G.UIPadding_2.PaddingLeft = UDim.new(0, 9)
G.UIPadding_2.PaddingRight = UDim.new(0, 9)
G.UIPadding_2.Parent = G.TextBox_2

-- UIStroke_28 (UIStroke)
G.UIStroke_28 = Instance.new("UIStroke")
G.UIStroke_28.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_28.Thickness = 1.2000000476837158
G.UIStroke_28.Transparency = 0.25
G.UIStroke_28.Parent = G.TextBox_2

-- Frame_55 (Frame)
G.Frame_55 = Instance.new("Frame")
G.Frame_55.BackgroundTransparency = 1
G.Frame_55.LayoutOrder = 2
G.Frame_55.Size = UDim2.new(1, 0, 0, 34)
G.Frame_55.Parent = G.Frame_53

-- TextButton_20 (TextButton)
G.TextButton_20 = Instance.new("TextButton")
G.TextButton_20.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_20.BorderSizePixel = 0
G.TextButton_20.Size = UDim2.new(0.40000000596046448, -4, 1, 0)
G.TextButton_20.AutoButtonColor = false
G.TextButton_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_20.Text = "SAMPLE"
G.TextButton_20.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_20.TextSize = 12
G.TextButton_20.Parent = G.Frame_55

-- UICorner_71 (UICorner)
G.UICorner_71 = Instance.new("UICorner")
G.UICorner_71.Parent = G.TextButton_20

-- UIStroke_29 (UIStroke)
G.UIStroke_29 = Instance.new("UIStroke")
G.UIStroke_29.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_29.Transparency = 0.20000000298023224
G.UIStroke_29.Parent = G.TextButton_20

-- TextButton_21 (TextButton)
G.TextButton_21 = Instance.new("TextButton")
G.TextButton_21.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
G.TextButton_21.BorderSizePixel = 0
G.TextButton_21.Position = UDim2.new(0.40000000596046448, 4, 0, 0)
G.TextButton_21.Size = UDim2.new(0.60000002384185791, -4, 1, 0)
G.TextButton_21.AutoButtonColor = false
G.TextButton_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_21.Text = "SEND"
G.TextButton_21.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_21.TextSize = 13
G.TextButton_21.Parent = G.Frame_55

-- UICorner_72 (UICorner)
G.UICorner_72 = Instance.new("UICorner")
G.UICorner_72.Parent = G.TextButton_21

-- UIGradient_22 (UIGradient)
G.UIGradient_22 = Instance.new("UIGradient")
G.UIGradient_22.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 90, 175)), ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 50, 110))})
G.UIGradient_22.Rotation = 90
G.UIGradient_22.Parent = G.TextButton_21

-- TextLabel_18 (TextLabel)
G.TextLabel_18 = Instance.new("TextLabel")
G.TextLabel_18.BackgroundTransparency = 1
G.TextLabel_18.LayoutOrder = 3
G.TextLabel_18.Size = UDim2.new(1, -4, 0, 14)
G.TextLabel_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
G.TextLabel_18.Text = ""
G.TextLabel_18.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_18.TextSize = 10
G.TextLabel_18.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_18.Parent = G.Frame_53

-- TextLabel_19 (TextLabel)
G.TextLabel_19 = Instance.new("TextLabel")
G.TextLabel_19.BackgroundTransparency = 1
G.TextLabel_19.LayoutOrder = 4
G.TextLabel_19.Size = UDim2.new(1, -4, 0, 26)
G.TextLabel_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
G.TextLabel_19.Text = "fires through the same handler as a real\nnotification - nothing leaves the client"
G.TextLabel_19.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_19.TextSize = 9
G.TextLabel_19.TextWrapped = true
G.TextLabel_19.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_19.Parent = G.Frame_53

-- Settings (Frame)
G.Settings = Instance.new("Frame")
G.Settings.Name = "Settings"
G.Settings.Active = true
G.Settings.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
G.Settings.BorderSizePixel = 0
G.Settings.ClipsDescendants = true
G.Settings.Position = UDim2.new(0.5, -81, 0.5, -27)
G.Settings.Size = UDim2.new(0, 300, 0, 198)
G.Settings.Parent = G.Riddler

-- UICorner_73 (UICorner)
G.UICorner_73 = Instance.new("UICorner")
G.UICorner_73.CornerRadius = UDim.new(0, 14)
G.UICorner_73.Parent = G.Settings

-- UIGradient_23 (UIGradient)
G.UIGradient_23 = Instance.new("UIGradient")
G.UIGradient_23.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 15, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9))})
G.UIGradient_23.Rotation = 90
G.UIGradient_23.Parent = G.Settings

-- UIStroke_30 (UIStroke)
G.UIStroke_30 = Instance.new("UIStroke")
G.UIStroke_30.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_30.Thickness = 1.2000000476837158
G.UIStroke_30.Transparency = 0.44999998807907104
G.UIStroke_30.Parent = G.Settings

-- WinScale_4 (UIScale)
G.WinScale_4 = Instance.new("UIScale")
G.WinScale_4.Name = "WinScale"
G.WinScale_4.Scale = 0.64999997615814209
G.WinScale_4.Parent = G.Settings

-- Frame_56 (Frame)
G.Frame_56 = Instance.new("Frame")
G.Frame_56.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_56.BorderSizePixel = 0
G.Frame_56.Size = UDim2.new(1, 0, 0, 44)
G.Frame_56.Parent = G.Settings

-- UICorner_74 (UICorner)
G.UICorner_74 = Instance.new("UICorner")
G.UICorner_74.CornerRadius = UDim.new(0, 14)
G.UICorner_74.Parent = G.Frame_56

-- Frame_57 (Frame)
G.Frame_57 = Instance.new("Frame")
G.Frame_57.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_57.BorderSizePixel = 0
G.Frame_57.Position = UDim2.new(0, 0, 1, -14)
G.Frame_57.Size = UDim2.new(1, 0, 0, 14)
G.Frame_57.Parent = G.Frame_56

-- ImageLabel_4 (ImageLabel)
G.ImageLabel_4 = Instance.new("ImageLabel")
G.ImageLabel_4.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.ImageLabel_4.BorderSizePixel = 0
G.ImageLabel_4.Position = UDim2.new(0, 12, 0.5, -12)
G.ImageLabel_4.Size = UDim2.new(0, 24, 0, 24)
G.ImageLabel_4.Image = "rbxthumb://type=Asset&id=124491981850461&w=150&h=150"
G.ImageLabel_4.Parent = G.Frame_56

-- UICorner_75 (UICorner)
G.UICorner_75 = Instance.new("UICorner")
G.UICorner_75.CornerRadius = UDim.new(0, 12)
G.UICorner_75.Parent = G.ImageLabel_4

-- UIStroke_31 (UIStroke)
G.UIStroke_31 = Instance.new("UIStroke")
G.UIStroke_31.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_31.Thickness = 1.5
G.UIStroke_31.Transparency = 0.20000000298023224
G.UIStroke_31.Parent = G.ImageLabel_4

-- TextLabel_20 (TextLabel)
G.TextLabel_20 = Instance.new("TextLabel")
G.TextLabel_20.BackgroundTransparency = 1
G.TextLabel_20.Position = UDim2.new(0, 44, 0, 0)
G.TextLabel_20.Size = UDim2.new(1, -132, 1, 0)
G.TextLabel_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_20.Text = "SETTINGS"
G.TextLabel_20.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel_20.TextSize = 15
G.TextLabel_20.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_20.Parent = G.Frame_56

-- TextButton_22 (TextButton)
G.TextButton_22 = Instance.new("TextButton")
G.TextButton_22.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_22.BorderSizePixel = 0
G.TextButton_22.Position = UDim2.new(1, -28, 0.5, -11)
G.TextButton_22.Size = UDim2.new(0, 22, 0, 22)
G.TextButton_22.AutoButtonColor = false
G.TextButton_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_22.Text = "X"
G.TextButton_22.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_22.TextSize = 12
G.TextButton_22.Parent = G.Frame_56

-- UICorner_76 (UICorner)
G.UICorner_76 = Instance.new("UICorner")
G.UICorner_76.Parent = G.TextButton_22

-- UIStroke_32 (UIStroke)
G.UIStroke_32 = Instance.new("UIStroke")
G.UIStroke_32.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_32.Transparency = 0.20000000298023224
G.UIStroke_32.Parent = G.TextButton_22

-- Frame_58 (Frame)
G.Frame_58 = Instance.new("Frame")
G.Frame_58.BackgroundTransparency = 1
G.Frame_58.BorderSizePixel = 0
G.Frame_58.Position = UDim2.new(0, 10, 0, 50)
G.Frame_58.Size = UDim2.new(1, -20, 1, -58)
G.Frame_58.Parent = G.Settings

-- UIListLayout_5 (UIListLayout)
G.UIListLayout_5 = Instance.new("UIListLayout")
G.UIListLayout_5.Padding = UDim.new(0, 5)
G.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_5.Parent = G.Frame_58

-- Frame_59 (Frame)
G.Frame_59 = Instance.new("Frame")
G.Frame_59.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_59.BorderSizePixel = 0
G.Frame_59.LayoutOrder = 1
G.Frame_59.Size = UDim2.new(1, 0, 0, 31)
G.Frame_59.Parent = G.Frame_58

-- UICorner_77 (UICorner)
G.UICorner_77 = Instance.new("UICorner")
G.UICorner_77.Parent = G.Frame_59

-- UIStroke_33 (UIStroke)
G.UIStroke_33 = Instance.new("UIStroke")
G.UIStroke_33.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_33.Transparency = 0.30000001192092896
G.UIStroke_33.Parent = G.Frame_59

-- TextLabel_21 (TextLabel)
G.TextLabel_21 = Instance.new("TextLabel")
G.TextLabel_21.BackgroundTransparency = 1
G.TextLabel_21.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_21.Size = UDim2.new(1, -56, 1, 0)
G.TextLabel_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_21.Text = "AUTO LISTEN"
G.TextLabel_21.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel_21.TextSize = 11
G.TextLabel_21.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_21.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_21.Parent = G.Frame_59

-- Frame_60 (Frame)
G.Frame_60 = Instance.new("Frame")
G.Frame_60.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
G.Frame_60.BorderSizePixel = 0
G.Frame_60.Position = UDim2.new(1, -46, 0.5, -9)
G.Frame_60.Size = UDim2.new(0, 36, 0, 18)
G.Frame_60.Parent = G.Frame_59

-- UICorner_78 (UICorner)
G.UICorner_78 = Instance.new("UICorner")
G.UICorner_78.CornerRadius = UDim.new(0, 9)
G.UICorner_78.Parent = G.Frame_60

-- Frame_61 (Frame)
G.Frame_61 = Instance.new("Frame")
G.Frame_61.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_61.BorderSizePixel = 0
G.Frame_61.Position = UDim2.new(0, 20, 0.5, -7)
G.Frame_61.Size = UDim2.new(0, 14, 0, 14)
G.Frame_61.Parent = G.Frame_60

-- UICorner_79 (UICorner)
G.UICorner_79 = Instance.new("UICorner")
G.UICorner_79.CornerRadius = UDim.new(0, 7)
G.UICorner_79.Parent = G.Frame_61

-- TextButton_23 (TextButton)
G.TextButton_23 = Instance.new("TextButton")
G.TextButton_23.BackgroundTransparency = 1
G.TextButton_23.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_23.Text = ""
G.TextButton_23.Parent = G.Frame_59

-- Frame_62 (Frame)
G.Frame_62 = Instance.new("Frame")
G.Frame_62.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_62.BorderSizePixel = 0
G.Frame_62.LayoutOrder = 2
G.Frame_62.Size = UDim2.new(1, 0, 0, 31)
G.Frame_62.Parent = G.Frame_58

-- UICorner_80 (UICorner)
G.UICorner_80 = Instance.new("UICorner")
G.UICorner_80.Parent = G.Frame_62

-- UIStroke_34 (UIStroke)
G.UIStroke_34 = Instance.new("UIStroke")
G.UIStroke_34.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_34.Transparency = 0.30000001192092896
G.UIStroke_34.Parent = G.Frame_62

-- TextLabel_22 (TextLabel)
G.TextLabel_22 = Instance.new("TextLabel")
G.TextLabel_22.BackgroundTransparency = 1
G.TextLabel_22.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_22.Size = UDim2.new(1, -56, 1, 0)
G.TextLabel_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_22.Text = "IGNORE SYSTEM PHRASES"
G.TextLabel_22.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel_22.TextSize = 11
G.TextLabel_22.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_22.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_22.Parent = G.Frame_62

-- Frame_63 (Frame)
G.Frame_63 = Instance.new("Frame")
G.Frame_63.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
G.Frame_63.BorderSizePixel = 0
G.Frame_63.Position = UDim2.new(1, -46, 0.5, -9)
G.Frame_63.Size = UDim2.new(0, 36, 0, 18)
G.Frame_63.Parent = G.Frame_62

-- UICorner_81 (UICorner)
G.UICorner_81 = Instance.new("UICorner")
G.UICorner_81.CornerRadius = UDim.new(0, 9)
G.UICorner_81.Parent = G.Frame_63

-- Frame_64 (Frame)
G.Frame_64 = Instance.new("Frame")
G.Frame_64.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_64.BorderSizePixel = 0
G.Frame_64.Position = UDim2.new(0, 20, 0.5, -7)
G.Frame_64.Size = UDim2.new(0, 14, 0, 14)
G.Frame_64.Parent = G.Frame_63

-- UICorner_82 (UICorner)
G.UICorner_82 = Instance.new("UICorner")
G.UICorner_82.CornerRadius = UDim.new(0, 7)
G.UICorner_82.Parent = G.Frame_64

-- TextButton_24 (TextButton)
G.TextButton_24 = Instance.new("TextButton")
G.TextButton_24.BackgroundTransparency = 1
G.TextButton_24.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_24.Text = ""
G.TextButton_24.Parent = G.Frame_62

-- Frame_65 (Frame)
G.Frame_65 = Instance.new("Frame")
G.Frame_65.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_65.BorderSizePixel = 0
G.Frame_65.LayoutOrder = 3
G.Frame_65.Size = UDim2.new(1, 0, 0, 31)
G.Frame_65.Parent = G.Frame_58

-- UICorner_83 (UICorner)
G.UICorner_83 = Instance.new("UICorner")
G.UICorner_83.Parent = G.Frame_65

-- UIStroke_35 (UIStroke)
G.UIStroke_35 = Instance.new("UIStroke")
G.UIStroke_35.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_35.Transparency = 0.30000001192092896
G.UIStroke_35.Parent = G.Frame_65

-- TextLabel_23 (TextLabel)
G.TextLabel_23 = Instance.new("TextLabel")
G.TextLabel_23.BackgroundTransparency = 1
G.TextLabel_23.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_23.Size = UDim2.new(1, -100, 1, 0)
G.TextLabel_23.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_23.Text = "DUO MODE (WITH REDEEMER)"
G.TextLabel_23.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_23.TextSize = 11
G.TextLabel_23.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_23.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_23.Parent = G.Frame_65

-- Frame_66 (Frame)
G.Frame_66 = Instance.new("Frame")
G.Frame_66.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_66.BorderSizePixel = 0
G.Frame_66.Position = UDim2.new(1, -46, 0.5, -9)
G.Frame_66.Size = UDim2.new(0, 36, 0, 18)
G.Frame_66.Parent = G.Frame_65

-- UICorner_84 (UICorner)
G.UICorner_84 = Instance.new("UICorner")
G.UICorner_84.CornerRadius = UDim.new(0, 9)
G.UICorner_84.Parent = G.Frame_66

-- Frame_67 (Frame)
G.Frame_67 = Instance.new("Frame")
G.Frame_67.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_67.BorderSizePixel = 0
G.Frame_67.Position = UDim2.new(0, 2, 0.5, -7)
G.Frame_67.Size = UDim2.new(0, 14, 0, 14)
G.Frame_67.Parent = G.Frame_66

-- UICorner_85 (UICorner)
G.UICorner_85 = Instance.new("UICorner")
G.UICorner_85.CornerRadius = UDim.new(0, 7)
G.UICorner_85.Parent = G.Frame_67

-- TextButton_25 (TextButton)
G.TextButton_25 = Instance.new("TextButton")
G.TextButton_25.BackgroundTransparency = 1
G.TextButton_25.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_25.Text = ""
G.TextButton_25.Parent = G.Frame_65

-- TextLabel_24 (TextLabel)
G.TextLabel_24 = Instance.new("TextLabel")
G.TextLabel_24.BackgroundTransparency = 1
G.TextLabel_24.Position = UDim2.new(1, -84, 0, 0)
G.TextLabel_24.Size = UDim2.new(0, 30, 0, 31)
G.TextLabel_24.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_24.Text = "0/2"
G.TextLabel_24.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_24.TextSize = 10
G.TextLabel_24.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_24.Parent = G.Frame_65

-- Frame_68 (Frame)
G.Frame_68 = Instance.new("Frame")
G.Frame_68.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_68.BorderSizePixel = 0
G.Frame_68.LayoutOrder = 4
G.Frame_68.Size = UDim2.new(1, 0, 0, 31)
G.Frame_68.Parent = G.Frame_58

-- UICorner_86 (UICorner)
G.UICorner_86 = Instance.new("UICorner")
G.UICorner_86.Parent = G.Frame_68

-- UIStroke_36 (UIStroke)
G.UIStroke_36 = Instance.new("UIStroke")
G.UIStroke_36.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_36.Transparency = 0.30000001192092896
G.UIStroke_36.Parent = G.Frame_68

-- TextLabel_25 (TextLabel)
G.TextLabel_25 = Instance.new("TextLabel")
G.TextLabel_25.BackgroundTransparency = 1
G.TextLabel_25.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_25.Size = UDim2.new(1, -70, 1, 0)
G.TextLabel_25.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_25.Text = "AUTO BUY"
G.TextLabel_25.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_25.TextSize = 11
G.TextLabel_25.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_25.Parent = G.Frame_68

-- TextButton_26 (TextButton)
G.TextButton_26 = Instance.new("TextButton")
G.TextButton_26.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_26.BorderSizePixel = 0
G.TextButton_26.Position = UDim2.new(1, -60, 0.5, -11)
G.TextButton_26.Size = UDim2.new(0, 52, 0, 22)
G.TextButton_26.AutoButtonColor = false
G.TextButton_26.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_26.Text = "OPEN"
G.TextButton_26.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_26.TextSize = 11
G.TextButton_26.Parent = G.Frame_68

-- UICorner_87 (UICorner)
G.UICorner_87 = Instance.new("UICorner")
G.UICorner_87.Parent = G.TextButton_26

-- UIStroke_37 (UIStroke)
G.UIStroke_37 = Instance.new("UIStroke")
G.UIStroke_37.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_37.Transparency = 0.20000000298023224
G.UIStroke_37.Parent = G.TextButton_26

-- UiSizeRow (Frame)
G.UiSizeRow = Instance.new("Frame")
G.UiSizeRow.Name = "UiSizeRow"
G.UiSizeRow.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.UiSizeRow.BorderSizePixel = 0
G.UiSizeRow.LayoutOrder = 3
G.UiSizeRow.Size = UDim2.new(1, 0, 0, 31)
G.UiSizeRow.Parent = G.Frame_58

-- UICorner_88 (UICorner)
G.UICorner_88 = Instance.new("UICorner")
G.UICorner_88.Parent = G.UiSizeRow

-- UIStroke_38 (UIStroke)
G.UIStroke_38 = Instance.new("UIStroke")
G.UIStroke_38.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_38.Transparency = 0.30000001192092896
G.UIStroke_38.Parent = G.UiSizeRow

-- TextLabel_26 (TextLabel)
G.TextLabel_26 = Instance.new("TextLabel")
G.TextLabel_26.BackgroundTransparency = 1
G.TextLabel_26.Position = UDim2.new(0, 11, 0, 0)
G.TextLabel_26.Size = UDim2.new(0, 70, 0, 31)
G.TextLabel_26.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_26.Text = "UI SIZE"
G.TextLabel_26.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_26.TextSize = 11
G.TextLabel_26.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_26.Parent = G.UiSizeRow

-- Frame_69 (Frame)
G.Frame_69 = Instance.new("Frame")
G.Frame_69.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
G.Frame_69.BorderSizePixel = 0
G.Frame_69.Position = UDim2.new(1, -177, 0.5, -11)
G.Frame_69.Size = UDim2.new(0, 168, 0, 23)
G.Frame_69.Parent = G.UiSizeRow

-- UICorner_89 (UICorner)
G.UICorner_89 = Instance.new("UICorner")
G.UICorner_89.CornerRadius = UDim.new(0, 7)
G.UICorner_89.Parent = G.Frame_69

-- TextButton_27 (TextButton)
G.TextButton_27 = Instance.new("TextButton")
G.TextButton_27.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
G.TextButton_27.BorderSizePixel = 0
G.TextButton_27.Position = UDim2.new(0, 1, 0, 1)
G.TextButton_27.Size = UDim2.new(0.3333333432674408, -2, 1, -2)
G.TextButton_27.AutoButtonColor = false
G.TextButton_27.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_27.Text = "BIG"
G.TextButton_27.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextButton_27.TextSize = 9
G.TextButton_27.Parent = G.Frame_69

-- UICorner_90 (UICorner)
G.UICorner_90 = Instance.new("UICorner")
G.UICorner_90.CornerRadius = UDim.new(0, 6)
G.UICorner_90.Parent = G.TextButton_27

-- TextButton_28 (TextButton)
G.TextButton_28 = Instance.new("TextButton")
G.TextButton_28.BackgroundColor3 = Color3.fromRGB(235, 90, 175)
G.TextButton_28.BorderSizePixel = 0
G.TextButton_28.Position = UDim2.new(0.3333333432674408, 1, 0, 1)
G.TextButton_28.Size = UDim2.new(0.3333333432674408, -2, 1, -2)
G.TextButton_28.AutoButtonColor = false
G.TextButton_28.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_28.Text = "MEDIUM"
G.TextButton_28.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_28.TextSize = 9
G.TextButton_28.Parent = G.Frame_69

-- UICorner_91 (UICorner)
G.UICorner_91 = Instance.new("UICorner")
G.UICorner_91.CornerRadius = UDim.new(0, 6)
G.UICorner_91.Parent = G.TextButton_28

-- TextButton_29 (TextButton)
G.TextButton_29 = Instance.new("TextButton")
G.TextButton_29.BackgroundColor3 = Color3.fromRGB(11, 10, 15)
G.TextButton_29.BorderSizePixel = 0
G.TextButton_29.Position = UDim2.new(0.66666668653488159, 1, 0, 1)
G.TextButton_29.Size = UDim2.new(0.3333333432674408, -2, 1, -2)
G.TextButton_29.AutoButtonColor = false
G.TextButton_29.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_29.Text = "SMALL"
G.TextButton_29.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextButton_29.TextSize = 9
G.TextButton_29.Parent = G.Frame_69

-- UICorner_92 (UICorner)
G.UICorner_92 = Instance.new("UICorner")
G.UICorner_92.CornerRadius = UDim.new(0, 6)
G.UICorner_92.Parent = G.TextButton_29

-- AutoBuy (Frame)
G.AutoBuy = Instance.new("Frame")
G.AutoBuy.Name = "AutoBuy"
G.AutoBuy.Active = true
G.AutoBuy.BackgroundColor3 = Color3.fromRGB(6, 6, 9)
G.AutoBuy.BorderSizePixel = 0
G.AutoBuy.ClipsDescendants = true
G.AutoBuy.Size = UDim2.new(0, 264, 0, 286)
G.AutoBuy.Visible = false
G.AutoBuy.Parent = G.Riddler

-- UICorner_93 (UICorner)
G.UICorner_93 = Instance.new("UICorner")
G.UICorner_93.CornerRadius = UDim.new(0, 14)
G.UICorner_93.Parent = G.AutoBuy

-- UIGradient_24 (UIGradient)
G.UIGradient_24 = Instance.new("UIGradient")
G.UIGradient_24.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 15, 21)), ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 9))})
G.UIGradient_24.Rotation = 90
G.UIGradient_24.Parent = G.AutoBuy

-- UIStroke_39 (UIStroke)
G.UIStroke_39 = Instance.new("UIStroke")
G.UIStroke_39.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_39.Thickness = 1.2000000476837158
G.UIStroke_39.Transparency = 0.44999998807907104
G.UIStroke_39.Parent = G.AutoBuy

-- WinScale_5 (UIScale)
G.WinScale_5 = Instance.new("UIScale")
G.WinScale_5.Name = "WinScale"
G.WinScale_5.Scale = 0.64999997615814209
G.WinScale_5.Parent = G.AutoBuy

-- Frame_70 (Frame)
G.Frame_70 = Instance.new("Frame")
G.Frame_70.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_70.BorderSizePixel = 0
G.Frame_70.Size = UDim2.new(1, 0, 0, 44)
G.Frame_70.Parent = G.AutoBuy

-- UICorner_94 (UICorner)
G.UICorner_94 = Instance.new("UICorner")
G.UICorner_94.CornerRadius = UDim.new(0, 14)
G.UICorner_94.Parent = G.Frame_70

-- Frame_71 (Frame)
G.Frame_71 = Instance.new("Frame")
G.Frame_71.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_71.BorderSizePixel = 0
G.Frame_71.Position = UDim2.new(0, 0, 1, -14)
G.Frame_71.Size = UDim2.new(1, 0, 0, 14)
G.Frame_71.Parent = G.Frame_70

-- ImageLabel_5 (ImageLabel)
G.ImageLabel_5 = Instance.new("ImageLabel")
G.ImageLabel_5.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.ImageLabel_5.BorderSizePixel = 0
G.ImageLabel_5.Position = UDim2.new(0, 12, 0.5, -12)
G.ImageLabel_5.Size = UDim2.new(0, 24, 0, 24)
G.ImageLabel_5.Image = "rbxthumb://type=Asset&id=124491981850461&w=150&h=150"
G.ImageLabel_5.Parent = G.Frame_70

-- UICorner_95 (UICorner)
G.UICorner_95 = Instance.new("UICorner")
G.UICorner_95.CornerRadius = UDim.new(0, 12)
G.UICorner_95.Parent = G.ImageLabel_5

-- UIStroke_40 (UIStroke)
G.UIStroke_40 = Instance.new("UIStroke")
G.UIStroke_40.Color = Color3.fromRGB(235, 90, 175)
G.UIStroke_40.Thickness = 1.5
G.UIStroke_40.Transparency = 0.20000000298023224
G.UIStroke_40.Parent = G.ImageLabel_5

-- TextLabel_27 (TextLabel)
G.TextLabel_27 = Instance.new("TextLabel")
G.TextLabel_27.BackgroundTransparency = 1
G.TextLabel_27.Position = UDim2.new(0, 44, 0, 0)
G.TextLabel_27.Size = UDim2.new(1, -132, 1, 0)
G.TextLabel_27.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_27.Text = "AUTO BUY"
G.TextLabel_27.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel_27.TextSize = 15
G.TextLabel_27.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_27.Parent = G.Frame_70

-- TextButton_30 (TextButton)
G.TextButton_30 = Instance.new("TextButton")
G.TextButton_30.BackgroundColor3 = Color3.fromRGB(32, 28, 42)
G.TextButton_30.BorderSizePixel = 0
G.TextButton_30.Position = UDim2.new(1, -28, 0.5, -11)
G.TextButton_30.Size = UDim2.new(0, 22, 0, 22)
G.TextButton_30.AutoButtonColor = false
G.TextButton_30.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_30.Text = "X"
G.TextButton_30.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextButton_30.TextSize = 12
G.TextButton_30.Parent = G.Frame_70

-- UICorner_96 (UICorner)
G.UICorner_96 = Instance.new("UICorner")
G.UICorner_96.Parent = G.TextButton_30

-- UIStroke_41 (UIStroke)
G.UIStroke_41 = Instance.new("UIStroke")
G.UIStroke_41.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_41.Transparency = 0.20000000298023224
G.UIStroke_41.Parent = G.TextButton_30

-- Frame_72 (Frame)
G.Frame_72 = Instance.new("Frame")
G.Frame_72.BackgroundTransparency = 1
G.Frame_72.Position = UDim2.new(0, 10, 0, 50)
G.Frame_72.Size = UDim2.new(1, -20, 1, -58)
G.Frame_72.Parent = G.AutoBuy

-- UIListLayout_6 (UIListLayout)
G.UIListLayout_6 = Instance.new("UIListLayout")
G.UIListLayout_6.Padding = UDim.new(0, 6)
G.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_6.Parent = G.Frame_72

-- Frame_73 (Frame)
G.Frame_73 = Instance.new("Frame")
G.Frame_73.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_73.BorderSizePixel = 0
G.Frame_73.LayoutOrder = 1
G.Frame_73.Size = UDim2.new(1, 0, 0, 44)
G.Frame_73.Parent = G.Frame_72

-- UICorner_97 (UICorner)
G.UICorner_97 = Instance.new("UICorner")
G.UICorner_97.CornerRadius = UDim.new(0, 9)
G.UICorner_97.Parent = G.Frame_73

-- UIStroke_42 (UIStroke)
G.UIStroke_42 = Instance.new("UIStroke")
G.UIStroke_42.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_42.Transparency = 0.30000001192092896
G.UIStroke_42.Parent = G.Frame_73

-- TextLabel_28 (TextLabel)
G.TextLabel_28 = Instance.new("TextLabel")
G.TextLabel_28.BackgroundTransparency = 1
G.TextLabel_28.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_28.Size = UDim2.new(1, -80, 1, 0)
G.TextLabel_28.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_28.Text = "AUTO BUY  -  OFF"
G.TextLabel_28.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_28.TextSize = 13
G.TextLabel_28.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_28.Parent = G.Frame_73

-- Frame_74 (Frame)
G.Frame_74 = Instance.new("Frame")
G.Frame_74.BackgroundColor3 = Color3.fromRGB(42, 35, 52)
G.Frame_74.BorderSizePixel = 0
G.Frame_74.Position = UDim2.new(1, -60, 0.5, -12)
G.Frame_74.Size = UDim2.new(0, 48, 0, 24)
G.Frame_74.Parent = G.Frame_73

-- UICorner_98 (UICorner)
G.UICorner_98 = Instance.new("UICorner")
G.UICorner_98.CornerRadius = UDim.new(0, 12)
G.UICorner_98.Parent = G.Frame_74

-- Frame_75 (Frame)
G.Frame_75 = Instance.new("Frame")
G.Frame_75.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
G.Frame_75.BorderSizePixel = 0
G.Frame_75.Position = UDim2.new(0, 3, 0.5, -9)
G.Frame_75.Size = UDim2.new(0, 18, 0, 18)
G.Frame_75.Parent = G.Frame_74

-- UICorner_99 (UICorner)
G.UICorner_99 = Instance.new("UICorner")
G.UICorner_99.CornerRadius = UDim.new(0, 9)
G.UICorner_99.Parent = G.Frame_75

-- TextButton_31 (TextButton)
G.TextButton_31 = Instance.new("TextButton")
G.TextButton_31.BackgroundTransparency = 1
G.TextButton_31.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_31.Text = ""
G.TextButton_31.Parent = G.Frame_73

-- Frame_76 (Frame)
G.Frame_76 = Instance.new("Frame")
G.Frame_76.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_76.BorderSizePixel = 0
G.Frame_76.LayoutOrder = 2
G.Frame_76.Size = UDim2.new(1, 0, 0, 28)
G.Frame_76.Parent = G.Frame_72

-- UICorner_100 (UICorner)
G.UICorner_100 = Instance.new("UICorner")
G.UICorner_100.CornerRadius = UDim.new(0, 9)
G.UICorner_100.Parent = G.Frame_76

-- UIStroke_43 (UIStroke)
G.UIStroke_43 = Instance.new("UIStroke")
G.UIStroke_43.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_43.Transparency = 0.30000001192092896
G.UIStroke_43.Parent = G.Frame_76

-- Frame_77 (Frame)
G.Frame_77 = Instance.new("Frame")
G.Frame_77.BackgroundColor3 = Color3.fromRGB(185, 175, 210)
G.Frame_77.BorderSizePixel = 0
G.Frame_77.Position = UDim2.new(0, 11, 0.5, -3)
G.Frame_77.Size = UDim2.new(0, 7, 0, 7)
G.Frame_77.Parent = G.Frame_76

-- UICorner_101 (UICorner)
G.UICorner_101 = Instance.new("UICorner")
G.UICorner_101.CornerRadius = UDim.new(0, 4)
G.UICorner_101.Parent = G.Frame_77

-- TextLabel_29 (TextLabel)
G.TextLabel_29 = Instance.new("TextLabel")
G.TextLabel_29.BackgroundTransparency = 1
G.TextLabel_29.Position = UDim2.new(0, 26, 0, 0)
G.TextLabel_29.Size = UDim2.new(1, -32, 1, 0)
G.TextLabel_29.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_29.Text = "idle"
G.TextLabel_29.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_29.TextSize = 11
G.TextLabel_29.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_29.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_29.Parent = G.Frame_76

-- Frame_78 (Frame)
G.Frame_78 = Instance.new("Frame")
G.Frame_78.BackgroundColor3 = Color3.fromRGB(16, 15, 21)
G.Frame_78.BorderSizePixel = 0
G.Frame_78.LayoutOrder = 3
G.Frame_78.Size = UDim2.new(1, 0, 0, 120)
G.Frame_78.Parent = G.Frame_72

-- UICorner_102 (UICorner)
G.UICorner_102 = Instance.new("UICorner")
G.UICorner_102.CornerRadius = UDim.new(0, 9)
G.UICorner_102.Parent = G.Frame_78

-- UIStroke_44 (UIStroke)
G.UIStroke_44 = Instance.new("UIStroke")
G.UIStroke_44.Color = Color3.fromRGB(42, 35, 52)
G.UIStroke_44.Transparency = 0.30000001192092896
G.UIStroke_44.Parent = G.Frame_78

-- TextLabel_30 (TextLabel)
G.TextLabel_30 = Instance.new("TextLabel")
G.TextLabel_30.BackgroundTransparency = 1
G.TextLabel_30.Position = UDim2.new(0, 11, 0, 7)
G.TextLabel_30.Size = UDim2.new(1, -20, 0, 12)
G.TextLabel_30.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_30.Text = "NEAREST BUYABLE"
G.TextLabel_30.TextColor3 = Color3.fromRGB(235, 90, 175)
G.TextLabel_30.TextSize = 9
G.TextLabel_30.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_30.Parent = G.Frame_78

-- TextLabel_31 (TextLabel)
G.TextLabel_31 = Instance.new("TextLabel")
G.TextLabel_31.BackgroundTransparency = 1
G.TextLabel_31.Position = UDim2.new(0, 11, 0, 24)
G.TextLabel_31.Size = UDim2.new(1, -20, 0, 15)
G.TextLabel_31.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_31.Text = "Name: ---"
G.TextLabel_31.TextColor3 = Color3.fromRGB(245, 240, 255)
G.TextLabel_31.TextSize = 11
G.TextLabel_31.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_31.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_31.Parent = G.Frame_78

-- TextLabel_32 (TextLabel)
G.TextLabel_32 = Instance.new("TextLabel")
G.TextLabel_32.BackgroundTransparency = 1
G.TextLabel_32.Position = UDim2.new(0, 11, 0, 41)
G.TextLabel_32.Size = UDim2.new(1, -20, 0, 15)
G.TextLabel_32.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_32.Text = "Income: --- /sec"
G.TextLabel_32.TextColor3 = Color3.fromRGB(235, 90, 175)
G.TextLabel_32.TextSize = 11
G.TextLabel_32.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_32.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_32.Parent = G.Frame_78

-- TextLabel_33 (TextLabel)
G.TextLabel_33 = Instance.new("TextLabel")
G.TextLabel_33.BackgroundTransparency = 1
G.TextLabel_33.Position = UDim2.new(0, 11, 0, 58)
G.TextLabel_33.Size = UDim2.new(1, -20, 0, 15)
G.TextLabel_33.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_33.Text = "Rarity: ---"
G.TextLabel_33.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_33.TextSize = 11
G.TextLabel_33.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_33.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_33.Parent = G.Frame_78

-- TextLabel_34 (TextLabel)
G.TextLabel_34 = Instance.new("TextLabel")
G.TextLabel_34.BackgroundTransparency = 1
G.TextLabel_34.Position = UDim2.new(0, 11, 0, 75)
G.TextLabel_34.Size = UDim2.new(1, -20, 0, 15)
G.TextLabel_34.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_34.Text = "Mutation: ---"
G.TextLabel_34.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_34.TextSize = 11
G.TextLabel_34.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_34.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_34.Parent = G.Frame_78

-- TextLabel_35 (TextLabel)
G.TextLabel_35 = Instance.new("TextLabel")
G.TextLabel_35.BackgroundTransparency = 1
G.TextLabel_35.Position = UDim2.new(0, 11, 0, 92)
G.TextLabel_35.Size = UDim2.new(1, -20, 0, 15)
G.TextLabel_35.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_35.Text = "Traits: ---"
G.TextLabel_35.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_35.TextSize = 11
G.TextLabel_35.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_35.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_35.Parent = G.Frame_78

-- TextLabel_36 (TextLabel)
G.TextLabel_36 = Instance.new("TextLabel")
G.TextLabel_36.BackgroundTransparency = 1
G.TextLabel_36.LayoutOrder = 4
G.TextLabel_36.Size = UDim2.new(1, 0, 0, 12)
G.TextLabel_36.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
G.TextLabel_36.Text = "Distance: ---"
G.TextLabel_36.TextColor3 = Color3.fromRGB(185, 175, 210)
G.TextLabel_36.TextSize = 9
G.TextLabel_36.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_36.Parent = G.Frame_72

-- mount
G.Riddler.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

return G.Riddler