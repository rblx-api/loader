--[[
    PrintedDuels  (ScreenGui)
    Grabbed by Zyx Copier on 2026-10-22 20:03:50
    Discord: https://discord.gg/ryzenhub
    954 instances
]]

local G = {}

-- PrintedDuels (ScreenGui)
G.PrintedDuels = Instance.new("ScreenGui")
G.PrintedDuels.Name = "PrintedDuels"
G.PrintedDuels.ResetOnSpawn = false
G.PrintedDuels.DisplayOrder = 10
G.PrintedDuels.IgnoreGuiInset = true
G.PrintedDuels.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

-- Frame (Frame)
G.Frame = Instance.new("Frame")
G.Frame.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
G.Frame.BorderSizePixel = 0
G.Frame.ClipsDescendants = true
G.Frame.Position = UDim2.new(0, 20, 0, 2)
G.Frame.Size = UDim2.new(0, 330, 0, 500)
G.Frame.Parent = G.PrintedDuels

-- UICorner (UICorner)
G.UICorner = Instance.new("UICorner")
G.UICorner.CornerRadius = UDim.new(0, 18)
G.UICorner.Parent = G.Frame

-- BackgroundImage (ImageLabel)
G.BackgroundImage = Instance.new("ImageLabel")
G.BackgroundImage.Name = "BackgroundImage"
G.BackgroundImage.BackgroundTransparency = 1
G.BackgroundImage.BorderSizePixel = 0
G.BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
G.BackgroundImage.Visible = false
G.BackgroundImage.ImageTransparency = 1
G.BackgroundImage.Parent = G.Frame

-- UICorner_2 (UICorner)
G.UICorner_2 = Instance.new("UICorner")
G.UICorner_2.CornerRadius = UDim.new(0, 18)
G.UICorner_2.Parent = G.BackgroundImage

-- UIScale (UIScale)
G.UIScale = Instance.new("UIScale")
G.UIScale.Scale = 0.77999997138977051
G.UIScale.Parent = G.Frame

-- TitleFrame (Frame)
G.TitleFrame = Instance.new("Frame")
G.TitleFrame.Name = "TitleFrame"
G.TitleFrame.BackgroundTransparency = 1
G.TitleFrame.Position = UDim2.new(0, 12, 0, 8)
G.TitleFrame.Size = UDim2.new(1, -24, 0, 48)
G.TitleFrame.ZIndex = 20
G.TitleFrame.Parent = G.Frame

-- TitleImage (ImageLabel)
G.TitleImage = Instance.new("ImageLabel")
G.TitleImage.Name = "TitleImage"
G.TitleImage.Visible = false
G.TitleImage.Parent = G.TitleFrame

-- AvatarPfp (ImageLabel)
G.AvatarPfp = Instance.new("ImageLabel")
G.AvatarPfp.Name = "AvatarPfp"
G.AvatarPfp.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
G.AvatarPfp.BorderSizePixel = 0
G.AvatarPfp.Position = UDim2.new(0, 4, 0.5, -20)
G.AvatarPfp.Size = UDim2.new(0, 40, 0, 40)
G.AvatarPfp.ZIndex = 22
G.AvatarPfp.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=10200711614&width=150&height=150&format=png"
G.AvatarPfp.Parent = G.TitleFrame

-- UICorner_3 (UICorner)
G.UICorner_3 = Instance.new("UICorner")
G.UICorner_3.CornerRadius = UDim.new(1, 0)
G.UICorner_3.Parent = G.AvatarPfp

-- UIStroke (UIStroke)
G.UIStroke = Instance.new("UIStroke")
G.UIStroke.Color = Color3.fromRGB(180, 180, 190)
G.UIStroke.Thickness = 1.2000000476837158
G.UIStroke.Transparency = 0.34999999403953552
G.UIStroke.Parent = G.AvatarPfp

-- PrintedDuelsTitle (TextLabel)
G.PrintedDuelsTitle = Instance.new("TextLabel")
G.PrintedDuelsTitle.Name = "PrintedDuelsTitle"
G.PrintedDuelsTitle.BackgroundTransparency = 1
G.PrintedDuelsTitle.Position = UDim2.new(0, 52, 0, 0)
G.PrintedDuelsTitle.Size = UDim2.new(1, -90, 1, 0)
G.PrintedDuelsTitle.ZIndex = 22
G.PrintedDuelsTitle.FontFace = Font.new("rbxasset://9e9f70187d85377c84ac11b96d7cbdad/starborn.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
G.PrintedDuelsTitle.Text = "PRINTED DUELS"
G.PrintedDuelsTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
G.PrintedDuelsTitle.TextSize = 21
G.PrintedDuelsTitle.TextXAlignment = Enum.TextXAlignment.Left
G.PrintedDuelsTitle.Parent = G.TitleFrame

-- TextButton (TextButton)
G.TextButton = Instance.new("TextButton")
G.TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
G.TextButton.BackgroundTransparency = 0.60000002384185791
G.TextButton.BorderSizePixel = 0
G.TextButton.Position = UDim2.new(1, -42, 0, 8)
G.TextButton.Size = UDim2.new(0, 32, 0, 32)
G.TextButton.ZIndex = 200
G.TextButton.AutoButtonColor = false
G.TextButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton.Text = "X"
G.TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton.TextSize = 16
G.TextButton.Parent = G.Frame

-- UICorner_4 (UICorner)
G.UICorner_4 = Instance.new("UICorner")
G.UICorner_4.Parent = G.TextButton

-- Frame_2 (Frame)
G.Frame_2 = Instance.new("Frame")
G.Frame_2.BackgroundTransparency = 1
G.Frame_2.Position = UDim2.new(0, 10, 1, -70)
G.Frame_2.Size = UDim2.new(1, -20, 0, 64)
G.Frame_2.ZIndex = 25
G.Frame_2.Parent = G.Frame

-- UIGridLayout (UIGridLayout)
G.UIGridLayout = Instance.new("UIGridLayout")
G.UIGridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
G.UIGridLayout.CellSize = UDim2.new(0.3333333432674408, -4, 0, 29)
G.UIGridLayout.FillDirectionMaxCells = 3
G.UIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
G.UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
G.UIGridLayout.Parent = G.Frame_2

-- TextButton_2 (TextButton)
G.TextButton_2 = Instance.new("TextButton")
G.TextButton_2.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
G.TextButton_2.BackgroundTransparency = 0.34999999403953552
G.TextButton_2.BorderSizePixel = 0
G.TextButton_2.LayoutOrder = 1
G.TextButton_2.Size = UDim2.new(0.3333333432674408, -4, 0, 29)
G.TextButton_2.ZIndex = 18
G.TextButton_2.AutoButtonColor = false
G.TextButton_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_2.Text = "Movement"
G.TextButton_2.TextColor3 = Color3.fromRGB(170, 170, 180)
G.TextButton_2.TextSize = 12
G.TextButton_2.Parent = G.Frame_2

-- UICorner_5 (UICorner)
G.UICorner_5 = Instance.new("UICorner")
G.UICorner_5.Parent = G.TextButton_2

-- UIStroke_2 (UIStroke)
G.UIStroke_2 = Instance.new("UIStroke")
G.UIStroke_2.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_2.Parent = G.TextButton_2

-- TextButton_3 (TextButton)
G.TextButton_3 = Instance.new("TextButton")
G.TextButton_3.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
G.TextButton_3.BackgroundTransparency = 0.34999999403953552
G.TextButton_3.BorderSizePixel = 0
G.TextButton_3.LayoutOrder = 2
G.TextButton_3.Size = UDim2.new(0.3333333432674408, -4, 0, 29)
G.TextButton_3.ZIndex = 18
G.TextButton_3.AutoButtonColor = false
G.TextButton_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_3.Text = "Combat"
G.TextButton_3.TextColor3 = Color3.fromRGB(170, 170, 180)
G.TextButton_3.TextSize = 12
G.TextButton_3.Parent = G.Frame_2

-- UICorner_6 (UICorner)
G.UICorner_6 = Instance.new("UICorner")
G.UICorner_6.Parent = G.TextButton_3

-- UIStroke_3 (UIStroke)
G.UIStroke_3 = Instance.new("UIStroke")
G.UIStroke_3.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_3.Parent = G.TextButton_3

-- TextButton_4 (TextButton)
G.TextButton_4 = Instance.new("TextButton")
G.TextButton_4.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
G.TextButton_4.BackgroundTransparency = 0.34999999403953552
G.TextButton_4.BorderSizePixel = 0
G.TextButton_4.LayoutOrder = 3
G.TextButton_4.Size = UDim2.new(0.3333333432674408, -4, 0, 29)
G.TextButton_4.ZIndex = 18
G.TextButton_4.AutoButtonColor = false
G.TextButton_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_4.Text = "Steal"
G.TextButton_4.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_4.TextSize = 12
G.TextButton_4.Parent = G.Frame_2

-- UICorner_7 (UICorner)
G.UICorner_7 = Instance.new("UICorner")
G.UICorner_7.Parent = G.TextButton_4

-- UIStroke_4 (UIStroke)
G.UIStroke_4 = Instance.new("UIStroke")
G.UIStroke_4.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_4.Parent = G.TextButton_4

-- TextButton_5 (TextButton)
G.TextButton_5 = Instance.new("TextButton")
G.TextButton_5.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
G.TextButton_5.BackgroundTransparency = 0.34999999403953552
G.TextButton_5.BorderSizePixel = 0
G.TextButton_5.LayoutOrder = 4
G.TextButton_5.Size = UDim2.new(0.3333333432674408, -4, 0, 29)
G.TextButton_5.ZIndex = 18
G.TextButton_5.AutoButtonColor = false
G.TextButton_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_5.Text = "Visuals"
G.TextButton_5.TextColor3 = Color3.fromRGB(170, 170, 180)
G.TextButton_5.TextSize = 12
G.TextButton_5.Parent = G.Frame_2

-- UICorner_8 (UICorner)
G.UICorner_8 = Instance.new("UICorner")
G.UICorner_8.Parent = G.TextButton_5

-- UIStroke_5 (UIStroke)
G.UIStroke_5 = Instance.new("UIStroke")
G.UIStroke_5.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_5.Parent = G.TextButton_5

-- TextButton_6 (TextButton)
G.TextButton_6 = Instance.new("TextButton")
G.TextButton_6.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
G.TextButton_6.BackgroundTransparency = 0.34999999403953552
G.TextButton_6.BorderSizePixel = 0
G.TextButton_6.LayoutOrder = 5
G.TextButton_6.Size = UDim2.new(0.3333333432674408, -4, 0, 29)
G.TextButton_6.ZIndex = 18
G.TextButton_6.AutoButtonColor = false
G.TextButton_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_6.Text = "Settings"
G.TextButton_6.TextColor3 = Color3.fromRGB(170, 170, 180)
G.TextButton_6.TextSize = 12
G.TextButton_6.Parent = G.Frame_2

-- UICorner_9 (UICorner)
G.UICorner_9 = Instance.new("UICorner")
G.UICorner_9.Parent = G.TextButton_6

-- UIStroke_6 (UIStroke)
G.UIStroke_6 = Instance.new("UIStroke")
G.UIStroke_6.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_6.Parent = G.TextButton_6

-- TextButton_7 (TextButton)
G.TextButton_7 = Instance.new("TextButton")
G.TextButton_7.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
G.TextButton_7.BackgroundTransparency = 0.34999999403953552
G.TextButton_7.BorderSizePixel = 0
G.TextButton_7.LayoutOrder = 6
G.TextButton_7.Size = UDim2.new(0.3333333432674408, -4, 0, 29)
G.TextButton_7.ZIndex = 18
G.TextButton_7.AutoButtonColor = false
G.TextButton_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_7.Text = "Binds"
G.TextButton_7.TextColor3 = Color3.fromRGB(170, 170, 180)
G.TextButton_7.TextSize = 12
G.TextButton_7.Parent = G.Frame_2

-- UICorner_10 (UICorner)
G.UICorner_10 = Instance.new("UICorner")
G.UICorner_10.Parent = G.TextButton_7

-- UIStroke_7 (UIStroke)
G.UIStroke_7 = Instance.new("UIStroke")
G.UIStroke_7.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_7.Parent = G.TextButton_7

-- TabsDivider (Frame)
G.TabsDivider = Instance.new("Frame")
G.TabsDivider.Name = "TabsDivider"
G.TabsDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.TabsDivider.BackgroundTransparency = 0.25
G.TabsDivider.BorderSizePixel = 0
G.TabsDivider.Position = UDim2.new(0, 10, 1, -76)
G.TabsDivider.Size = UDim2.new(1, -32, 0, 1)
G.TabsDivider.ZIndex = 18
G.TabsDivider.Parent = G.Frame

-- Frame_3 (Frame)
G.Frame_3 = Instance.new("Frame")
G.Frame_3.BackgroundTransparency = 1
G.Frame_3.ClipsDescendants = true
G.Frame_3.Position = UDim2.new(0, 6, 0, 54)
G.Frame_3.Size = UDim2.new(1, -12, 1, -132)
G.Frame_3.ZIndex = 15
G.Frame_3.Parent = G.Frame

-- Movement (ScrollingFrame)
G.Movement = Instance.new("ScrollingFrame")
G.Movement.Name = "Movement"
G.Movement.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
G.Movement.BackgroundTransparency = 0.85000002384185791
G.Movement.BorderSizePixel = 0
G.Movement.Size = UDim2.new(1, 0, 1, 0)
G.Movement.Visible = false
G.Movement.ZIndex = 6
G.Movement.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Movement.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Movement.ScrollBarImageColor3 = Color3.fromRGB(30, 30, 35)
G.Movement.ScrollBarImageTransparency = 0.30000001192092896
G.Movement.ScrollBarThickness = 2
G.Movement.ScrollingDirection = Enum.ScrollingDirection.Y
G.Movement.Parent = G.Frame_3

-- UICorner_11 (UICorner)
G.UICorner_11 = Instance.new("UICorner")
G.UICorner_11.CornerRadius = UDim.new(0, 16)
G.UICorner_11.Parent = G.Movement

-- UIListLayout (UIListLayout)
G.UIListLayout = Instance.new("UIListLayout")
G.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout.Padding = UDim.new(0, 6)
G.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout.Parent = G.Movement

-- UIPadding (UIPadding)
G.UIPadding = Instance.new("UIPadding")
G.UIPadding.PaddingBottom = UDim.new(0, 20)
G.UIPadding.PaddingLeft = UDim.new(0, 8)
G.UIPadding.PaddingRight = UDim.new(0, 8)
G.UIPadding.PaddingTop = UDim.new(0, 6)
G.UIPadding.Parent = G.Movement

-- SectionHeading (TextLabel)
G.SectionHeading = Instance.new("TextLabel")
G.SectionHeading.Name = "SectionHeading"
G.SectionHeading.BackgroundTransparency = 1
G.SectionHeading.LayoutOrder = 1
G.SectionHeading.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading.ZIndex = 15
G.SectionHeading.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading.Text = "BASE SPEEDS"
G.SectionHeading.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading.TextSize = 11
G.SectionHeading.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading.Parent = G.Movement

-- Frame_4 (Frame)
G.Frame_4 = Instance.new("Frame")
G.Frame_4.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_4.BackgroundTransparency = 0.079999998211860657
G.Frame_4.BorderSizePixel = 0
G.Frame_4.LayoutOrder = 2
G.Frame_4.Size = UDim2.new(1, -4, 0, 38)
G.Frame_4.ZIndex = 14
G.Frame_4.Parent = G.Movement

-- UICorner_12 (UICorner)
G.UICorner_12 = Instance.new("UICorner")
G.UICorner_12.CornerRadius = UDim.new(1, 0)
G.UICorner_12.Parent = G.Frame_4

-- UIStroke_8 (UIStroke)
G.UIStroke_8 = Instance.new("UIStroke")
G.UIStroke_8.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_8.Transparency = 0.5
G.UIStroke_8.Parent = G.Frame_4

-- TextLabel (TextLabel)
G.TextLabel = Instance.new("TextLabel")
G.TextLabel.BackgroundTransparency = 1
G.TextLabel.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel.ZIndex = 15
G.TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel.Text = "Normal Speed"
G.TextLabel.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel.TextSize = 12
G.TextLabel.TextStrokeTransparency = 0.64999997615814209
G.TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel.Parent = G.Frame_4

-- TextBox (TextBox)
G.TextBox = Instance.new("TextBox")
G.TextBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox.BackgroundTransparency = 0.69999998807907104
G.TextBox.BorderSizePixel = 0
G.TextBox.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox.Size = UDim2.new(0, 50, 0, 24)
G.TextBox.ZIndex = 15
G.TextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox.Text = "60"
G.TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox.TextSize = 11
G.TextBox.ClearTextOnFocus = false
G.TextBox:SetAttribute("PrintedLastValidValue", 60)
G.TextBox.Parent = G.Frame_4

-- UICorner_13 (UICorner)
G.UICorner_13 = Instance.new("UICorner")
G.UICorner_13.CornerRadius = UDim.new(0, 6)
G.UICorner_13.Parent = G.TextBox

-- UIStroke_9 (UIStroke)
G.UIStroke_9 = Instance.new("UIStroke")
G.UIStroke_9.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_9.Thickness = 1.2000000476837158
G.UIStroke_9.Transparency = 0.25
G.UIStroke_9.Parent = G.TextBox

-- Frame_5 (Frame)
G.Frame_5 = Instance.new("Frame")
G.Frame_5.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_5.BackgroundTransparency = 0.079999998211860657
G.Frame_5.BorderSizePixel = 0
G.Frame_5.LayoutOrder = 3
G.Frame_5.Size = UDim2.new(1, -4, 0, 38)
G.Frame_5.ZIndex = 14
G.Frame_5.Parent = G.Movement

-- UICorner_14 (UICorner)
G.UICorner_14 = Instance.new("UICorner")
G.UICorner_14.CornerRadius = UDim.new(1, 0)
G.UICorner_14.Parent = G.Frame_5

-- UIStroke_10 (UIStroke)
G.UIStroke_10 = Instance.new("UIStroke")
G.UIStroke_10.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_10.Transparency = 0.5
G.UIStroke_10.Parent = G.Frame_5

-- TextLabel_2 (TextLabel)
G.TextLabel_2 = Instance.new("TextLabel")
G.TextLabel_2.BackgroundTransparency = 1
G.TextLabel_2.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_2.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_2.ZIndex = 15
G.TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_2.Text = "Carry Speed"
G.TextLabel_2.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_2.TextSize = 12
G.TextLabel_2.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_2.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_2.Parent = G.Frame_5

-- TextBox_2 (TextBox)
G.TextBox_2 = Instance.new("TextBox")
G.TextBox_2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_2.BackgroundTransparency = 0.69999998807907104
G.TextBox_2.BorderSizePixel = 0
G.TextBox_2.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_2.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_2.ZIndex = 15
G.TextBox_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_2.Text = "29"
G.TextBox_2.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_2.TextSize = 11
G.TextBox_2.ClearTextOnFocus = false
G.TextBox_2:SetAttribute("PrintedLastValidValue", 29)
G.TextBox_2.Parent = G.Frame_5

-- UICorner_15 (UICorner)
G.UICorner_15 = Instance.new("UICorner")
G.UICorner_15.CornerRadius = UDim.new(0, 6)
G.UICorner_15.Parent = G.TextBox_2

-- UIStroke_11 (UIStroke)
G.UIStroke_11 = Instance.new("UIStroke")
G.UIStroke_11.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_11.Thickness = 1.2000000476837158
G.UIStroke_11.Transparency = 0.25
G.UIStroke_11.Parent = G.TextBox_2

-- Frame_6 (Frame)
G.Frame_6 = Instance.new("Frame")
G.Frame_6.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_6.BackgroundTransparency = 0.079999998211860657
G.Frame_6.BorderSizePixel = 0
G.Frame_6.LayoutOrder = 4
G.Frame_6.Size = UDim2.new(1, -4, 0, 38)
G.Frame_6.ZIndex = 14
G.Frame_6.Parent = G.Movement

-- UICorner_16 (UICorner)
G.UICorner_16 = Instance.new("UICorner")
G.UICorner_16.CornerRadius = UDim.new(1, 0)
G.UICorner_16.Parent = G.Frame_6

-- UIStroke_12 (UIStroke)
G.UIStroke_12 = Instance.new("UIStroke")
G.UIStroke_12.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_12.Transparency = 0.5
G.UIStroke_12.Parent = G.Frame_6

-- TextLabel_3 (TextLabel)
G.TextLabel_3 = Instance.new("TextLabel")
G.TextLabel_3.BackgroundTransparency = 1
G.TextLabel_3.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_3.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_3.ZIndex = 15
G.TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_3.Text = "Lagger Normal"
G.TextLabel_3.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_3.TextSize = 12
G.TextLabel_3.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_3.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_3.Parent = G.Frame_6

-- TextBox_3 (TextBox)
G.TextBox_3 = Instance.new("TextBox")
G.TextBox_3.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_3.BackgroundTransparency = 0.69999998807907104
G.TextBox_3.BorderSizePixel = 0
G.TextBox_3.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_3.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_3.ZIndex = 15
G.TextBox_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_3.Text = "15"
G.TextBox_3.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_3.TextSize = 11
G.TextBox_3.ClearTextOnFocus = false
G.TextBox_3:SetAttribute("PrintedLastValidValue", 15)
G.TextBox_3.Parent = G.Frame_6

-- UICorner_17 (UICorner)
G.UICorner_17 = Instance.new("UICorner")
G.UICorner_17.CornerRadius = UDim.new(0, 6)
G.UICorner_17.Parent = G.TextBox_3

-- UIStroke_13 (UIStroke)
G.UIStroke_13 = Instance.new("UIStroke")
G.UIStroke_13.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_13.Thickness = 1.2000000476837158
G.UIStroke_13.Transparency = 0.25
G.UIStroke_13.Parent = G.TextBox_3

-- Frame_7 (Frame)
G.Frame_7 = Instance.new("Frame")
G.Frame_7.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_7.BackgroundTransparency = 0.079999998211860657
G.Frame_7.BorderSizePixel = 0
G.Frame_7.LayoutOrder = 5
G.Frame_7.Size = UDim2.new(1, -4, 0, 38)
G.Frame_7.ZIndex = 14
G.Frame_7.Parent = G.Movement

-- UICorner_18 (UICorner)
G.UICorner_18 = Instance.new("UICorner")
G.UICorner_18.CornerRadius = UDim.new(1, 0)
G.UICorner_18.Parent = G.Frame_7

-- UIStroke_14 (UIStroke)
G.UIStroke_14 = Instance.new("UIStroke")
G.UIStroke_14.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_14.Transparency = 0.5
G.UIStroke_14.Parent = G.Frame_7

-- TextLabel_4 (TextLabel)
G.TextLabel_4 = Instance.new("TextLabel")
G.TextLabel_4.BackgroundTransparency = 1
G.TextLabel_4.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_4.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_4.ZIndex = 15
G.TextLabel_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_4.Text = "Lagger Carry"
G.TextLabel_4.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_4.TextSize = 12
G.TextLabel_4.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_4.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_4.Parent = G.Frame_7

-- TextBox_4 (TextBox)
G.TextBox_4 = Instance.new("TextBox")
G.TextBox_4.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_4.BackgroundTransparency = 0.69999998807907104
G.TextBox_4.BorderSizePixel = 0
G.TextBox_4.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_4.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_4.ZIndex = 15
G.TextBox_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_4.Text = "24.5"
G.TextBox_4.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_4.TextSize = 11
G.TextBox_4.ClearTextOnFocus = false
G.TextBox_4:SetAttribute("PrintedLastValidValue", 24.5)
G.TextBox_4.Parent = G.Frame_7

-- UICorner_19 (UICorner)
G.UICorner_19 = Instance.new("UICorner")
G.UICorner_19.CornerRadius = UDim.new(0, 6)
G.UICorner_19.Parent = G.TextBox_4

-- UIStroke_15 (UIStroke)
G.UIStroke_15 = Instance.new("UIStroke")
G.UIStroke_15.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_15.Thickness = 1.2000000476837158
G.UIStroke_15.Transparency = 0.25
G.UIStroke_15.Parent = G.TextBox_4

-- Frame_8 (Frame)
G.Frame_8 = Instance.new("Frame")
G.Frame_8.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_8.BackgroundTransparency = 0.029999999329447746
G.Frame_8.BorderSizePixel = 0
G.Frame_8.ClipsDescendants = true
G.Frame_8.LayoutOrder = 6
G.Frame_8.Size = UDim2.new(1, -4, 0, 44)
G.Frame_8.ZIndex = 14
G.Frame_8.Parent = G.Movement

-- UICorner_20 (UICorner)
G.UICorner_20 = Instance.new("UICorner")
G.UICorner_20.CornerRadius = UDim.new(0, 9)
G.UICorner_20.Parent = G.Frame_8

-- UIStroke_16 (UIStroke)
G.UIStroke_16 = Instance.new("UIStroke")
G.UIStroke_16.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_16.Transparency = 0.34999999403953552
G.UIStroke_16.Parent = G.Frame_8

-- TextLabel_5 (TextLabel)
G.TextLabel_5 = Instance.new("TextLabel")
G.TextLabel_5.BackgroundTransparency = 1
G.TextLabel_5.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_5.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_5.ZIndex = 16
G.TextLabel_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_5.Text = "Current Mode"
G.TextLabel_5.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_5.TextSize = 12
G.TextLabel_5.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_5.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_5.Parent = G.Frame_8

-- DropdownCardGradient (UIGradient)
G.DropdownCardGradient = Instance.new("UIGradient")
G.DropdownCardGradient.Name = "DropdownCardGradient"
G.DropdownCardGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient.Rotation = 90
G.DropdownCardGradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient.Parent = G.Frame_8

-- DropdownSelector (TextButton)
G.DropdownSelector = Instance.new("TextButton")
G.DropdownSelector.Name = "DropdownSelector"
G.DropdownSelector.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector.BorderSizePixel = 0
G.DropdownSelector.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector.ZIndex = 18
G.DropdownSelector.AutoButtonColor = false
G.DropdownSelector.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector.Text = "Normal  ▼"
G.DropdownSelector.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector.TextSize = 11
G.DropdownSelector.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector.Parent = G.Frame_8

-- UICorner_21 (UICorner)
G.UICorner_21 = Instance.new("UICorner")
G.UICorner_21.CornerRadius = UDim.new(0, 7)
G.UICorner_21.Parent = G.DropdownSelector

-- UIStroke_17 (UIStroke)
G.UIStroke_17 = Instance.new("UIStroke")
G.UIStroke_17.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_17.Transparency = 0.20000000298023224
G.UIStroke_17.Parent = G.DropdownSelector

-- DropdownChoices (ScrollingFrame)
G.DropdownChoices = Instance.new("ScrollingFrame")
G.DropdownChoices.Name = "DropdownChoices"
G.DropdownChoices.Active = true
G.DropdownChoices.BackgroundTransparency = 1
G.DropdownChoices.BorderSizePixel = 0
G.DropdownChoices.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices.Visible = false
G.DropdownChoices.ZIndex = 17
G.DropdownChoices.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices.ScrollBarThickness = 0
G.DropdownChoices.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices.Parent = G.Frame_8

-- UIListLayout_2 (UIListLayout)
G.UIListLayout_2 = Instance.new("UIListLayout")
G.UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_2.Padding = UDim.new(0, 4)
G.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_2.Parent = G.DropdownChoices

-- Option1 (TextButton)
G.Option1 = Instance.new("TextButton")
G.Option1.Name = "Option1"
G.Option1.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1.BorderSizePixel = 0
G.Option1.LayoutOrder = 1
G.Option1.Size = UDim2.new(1, -4, 0, 27)
G.Option1.ZIndex = 18
G.Option1.AutoButtonColor = false
G.Option1.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1.Text = "Normal"
G.Option1.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1.TextSize = 11
G.Option1.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1.Parent = G.DropdownChoices

-- UICorner_22 (UICorner)
G.UICorner_22 = Instance.new("UICorner")
G.UICorner_22.CornerRadius = UDim.new(0, 7)
G.UICorner_22.Parent = G.Option1

-- Option2 (TextButton)
G.Option2 = Instance.new("TextButton")
G.Option2.Name = "Option2"
G.Option2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2.BorderSizePixel = 0
G.Option2.LayoutOrder = 2
G.Option2.Size = UDim2.new(1, -4, 0, 27)
G.Option2.ZIndex = 18
G.Option2.AutoButtonColor = false
G.Option2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2.Text = "Carry"
G.Option2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2.TextSize = 11
G.Option2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2.Parent = G.DropdownChoices

-- UICorner_23 (UICorner)
G.UICorner_23 = Instance.new("UICorner")
G.UICorner_23.CornerRadius = UDim.new(0, 7)
G.UICorner_23.Parent = G.Option2

-- Option3 (TextButton)
G.Option3 = Instance.new("TextButton")
G.Option3.Name = "Option3"
G.Option3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option3.BorderSizePixel = 0
G.Option3.LayoutOrder = 3
G.Option3.Size = UDim2.new(1, -4, 0, 27)
G.Option3.ZIndex = 18
G.Option3.AutoButtonColor = false
G.Option3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option3.Text = "Lagger"
G.Option3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option3.TextSize = 11
G.Option3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option3.Parent = G.DropdownChoices

-- UICorner_24 (UICorner)
G.UICorner_24 = Instance.new("UICorner")
G.UICorner_24.CornerRadius = UDim.new(0, 7)
G.UICorner_24.Parent = G.Option3

-- Option4 (TextButton)
G.Option4 = Instance.new("TextButton")
G.Option4.Name = "Option4"
G.Option4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option4.BorderSizePixel = 0
G.Option4.LayoutOrder = 4
G.Option4.Size = UDim2.new(1, -4, 0, 27)
G.Option4.ZIndex = 18
G.Option4.AutoButtonColor = false
G.Option4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option4.Text = "Lagger Carry"
G.Option4.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option4.TextSize = 11
G.Option4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option4.Parent = G.DropdownChoices

-- UICorner_25 (UICorner)
G.UICorner_25 = Instance.new("UICorner")
G.UICorner_25.CornerRadius = UDim.new(0, 7)
G.UICorner_25.Parent = G.Option4

-- SectionHeading_2 (TextLabel)
G.SectionHeading_2 = Instance.new("TextLabel")
G.SectionHeading_2.Name = "SectionHeading"
G.SectionHeading_2.BackgroundTransparency = 1
G.SectionHeading_2.LayoutOrder = 7
G.SectionHeading_2.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_2.ZIndex = 15
G.SectionHeading_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_2.Text = "AUTO MOVEMENT"
G.SectionHeading_2.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_2.TextSize = 11
G.SectionHeading_2.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_2.Parent = G.Movement

-- Frame_9 (Frame)
G.Frame_9 = Instance.new("Frame")
G.Frame_9.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_9.BackgroundTransparency = 0.079999998211860657
G.Frame_9.BorderSizePixel = 0
G.Frame_9.LayoutOrder = 8
G.Frame_9.Size = UDim2.new(1, -4, 0, 44)
G.Frame_9.ZIndex = 14
G.Frame_9.Parent = G.Movement

-- UICorner_26 (UICorner)
G.UICorner_26 = Instance.new("UICorner")
G.UICorner_26.CornerRadius = UDim.new(1, 0)
G.UICorner_26.Parent = G.Frame_9

-- UIStroke_18 (UIStroke)
G.UIStroke_18 = Instance.new("UIStroke")
G.UIStroke_18.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_18.Transparency = 0.5
G.UIStroke_18.Parent = G.Frame_9

-- TextLabel_6 (TextLabel)
G.TextLabel_6 = Instance.new("TextLabel")
G.TextLabel_6.BackgroundTransparency = 1
G.TextLabel_6.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_6.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_6.ZIndex = 15
G.TextLabel_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_6.Text = "Auto Left"
G.TextLabel_6.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_6.TextSize = 12
G.TextLabel_6.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_6.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_6.Parent = G.Frame_9

-- Track (Frame)
G.Track = Instance.new("Frame")
G.Track.Name = "Track"
G.Track.AnchorPoint = Vector2.new(1, 0.5)
G.Track.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track.BorderSizePixel = 0
G.Track.Position = UDim2.new(1, -14, 0.5, 0)
G.Track.Size = UDim2.new(0, 48, 0, 26)
G.Track.ZIndex = 15
G.Track.Parent = G.Frame_9

-- UICorner_27 (UICorner)
G.UICorner_27 = Instance.new("UICorner")
G.UICorner_27.CornerRadius = UDim.new(1, 0)
G.UICorner_27.Parent = G.Track

-- Knob (Frame)
G.Knob = Instance.new("Frame")
G.Knob.Name = "Knob"
G.Knob.AnchorPoint = Vector2.new(0, 0.5)
G.Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob.BorderSizePixel = 0
G.Knob.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob.Size = UDim2.new(0, 20, 0, 20)
G.Knob.ZIndex = 16
G.Knob.Parent = G.Track

-- UICorner_28 (UICorner)
G.UICorner_28 = Instance.new("UICorner")
G.UICorner_28.CornerRadius = UDim.new(1, 0)
G.UICorner_28.Parent = G.Knob

-- KnobStroke (UIStroke)
G.KnobStroke = Instance.new("UIStroke")
G.KnobStroke.Name = "KnobStroke"
G.KnobStroke.Thickness = 0.60000002384185791
G.KnobStroke.Transparency = 0.75
G.KnobStroke.Parent = G.Knob

-- ToggleHit (TextButton)
G.ToggleHit = Instance.new("TextButton")
G.ToggleHit.Name = "ToggleHit"
G.ToggleHit.BackgroundTransparency = 1
G.ToggleHit.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit.ZIndex = 30
G.ToggleHit.AutoButtonColor = false
G.ToggleHit.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit.Text = ""
G.ToggleHit.Parent = G.Frame_9

-- Frame_10 (Frame)
G.Frame_10 = Instance.new("Frame")
G.Frame_10.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_10.BackgroundTransparency = 0.079999998211860657
G.Frame_10.BorderSizePixel = 0
G.Frame_10.LayoutOrder = 9
G.Frame_10.Size = UDim2.new(1, -4, 0, 44)
G.Frame_10.ZIndex = 14
G.Frame_10.Parent = G.Movement

-- UICorner_29 (UICorner)
G.UICorner_29 = Instance.new("UICorner")
G.UICorner_29.CornerRadius = UDim.new(1, 0)
G.UICorner_29.Parent = G.Frame_10

-- UIStroke_19 (UIStroke)
G.UIStroke_19 = Instance.new("UIStroke")
G.UIStroke_19.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_19.Transparency = 0.5
G.UIStroke_19.Parent = G.Frame_10

-- TextLabel_7 (TextLabel)
G.TextLabel_7 = Instance.new("TextLabel")
G.TextLabel_7.BackgroundTransparency = 1
G.TextLabel_7.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_7.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_7.ZIndex = 15
G.TextLabel_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_7.Text = "Auto Right"
G.TextLabel_7.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_7.TextSize = 12
G.TextLabel_7.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_7.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_7.Parent = G.Frame_10

-- Track_2 (Frame)
G.Track_2 = Instance.new("Frame")
G.Track_2.Name = "Track"
G.Track_2.AnchorPoint = Vector2.new(1, 0.5)
G.Track_2.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_2.BorderSizePixel = 0
G.Track_2.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_2.Size = UDim2.new(0, 48, 0, 26)
G.Track_2.ZIndex = 15
G.Track_2.Parent = G.Frame_10

-- UICorner_30 (UICorner)
G.UICorner_30 = Instance.new("UICorner")
G.UICorner_30.CornerRadius = UDim.new(1, 0)
G.UICorner_30.Parent = G.Track_2

-- Knob_2 (Frame)
G.Knob_2 = Instance.new("Frame")
G.Knob_2.Name = "Knob"
G.Knob_2.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_2.BorderSizePixel = 0
G.Knob_2.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_2.Size = UDim2.new(0, 20, 0, 20)
G.Knob_2.ZIndex = 16
G.Knob_2.Parent = G.Track_2

-- UICorner_31 (UICorner)
G.UICorner_31 = Instance.new("UICorner")
G.UICorner_31.CornerRadius = UDim.new(1, 0)
G.UICorner_31.Parent = G.Knob_2

-- KnobStroke_2 (UIStroke)
G.KnobStroke_2 = Instance.new("UIStroke")
G.KnobStroke_2.Name = "KnobStroke"
G.KnobStroke_2.Thickness = 0.60000002384185791
G.KnobStroke_2.Transparency = 0.75
G.KnobStroke_2.Parent = G.Knob_2

-- ToggleHit_2 (TextButton)
G.ToggleHit_2 = Instance.new("TextButton")
G.ToggleHit_2.Name = "ToggleHit"
G.ToggleHit_2.BackgroundTransparency = 1
G.ToggleHit_2.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_2.ZIndex = 30
G.ToggleHit_2.AutoButtonColor = false
G.ToggleHit_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_2.Text = ""
G.ToggleHit_2.Parent = G.Frame_10

-- SectionHeading_3 (TextLabel)
G.SectionHeading_3 = Instance.new("TextLabel")
G.SectionHeading_3.Name = "SectionHeading"
G.SectionHeading_3.BackgroundTransparency = 1
G.SectionHeading_3.LayoutOrder = 10
G.SectionHeading_3.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_3.ZIndex = 15
G.SectionHeading_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_3.Text = "TELEPORT"
G.SectionHeading_3.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_3.TextSize = 11
G.SectionHeading_3.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_3.Parent = G.Movement

-- Frame_11 (Frame)
G.Frame_11 = Instance.new("Frame")
G.Frame_11.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_11.BackgroundTransparency = 0.079999998211860657
G.Frame_11.BorderSizePixel = 0
G.Frame_11.LayoutOrder = 11
G.Frame_11.Size = UDim2.new(1, -4, 0, 38)
G.Frame_11.ZIndex = 14
G.Frame_11.Parent = G.Movement

-- UICorner_32 (UICorner)
G.UICorner_32 = Instance.new("UICorner")
G.UICorner_32.CornerRadius = UDim.new(1, 0)
G.UICorner_32.Parent = G.Frame_11

-- UIStroke_20 (UIStroke)
G.UIStroke_20 = Instance.new("UIStroke")
G.UIStroke_20.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_20.Transparency = 0.5
G.UIStroke_20.Parent = G.Frame_11

-- TextLabel_8 (TextLabel)
G.TextLabel_8 = Instance.new("TextLabel")
G.TextLabel_8.BackgroundTransparency = 1
G.TextLabel_8.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_8.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_8.ZIndex = 15
G.TextLabel_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_8.Text = "TP Down"
G.TextLabel_8.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_8.TextSize = 12
G.TextLabel_8.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_8.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_8.Parent = G.Frame_11

-- TextButton_8 (TextButton)
G.TextButton_8 = Instance.new("TextButton")
G.TextButton_8.BackgroundTransparency = 1
G.TextButton_8.Size = UDim2.new(0.57999998331069946, 0, 1, 0)
G.TextButton_8.ZIndex = 15
G.TextButton_8.AutoButtonColor = false
G.TextButton_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_8.Text = ""
G.TextButton_8.Parent = G.Frame_11

-- TextLabel_9 (TextLabel)
G.TextLabel_9 = Instance.new("TextLabel")
G.TextLabel_9.BackgroundTransparency = 1
G.TextLabel_9.Position = UDim2.new(1, -78, 0, 0)
G.TextLabel_9.Size = UDim2.new(0, 70, 1, 0)
G.TextLabel_9.ZIndex = 15
G.TextLabel_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_9.Text = "ACTIVATE"
G.TextLabel_9.TextColor3 = Color3.fromRGB(230, 230, 235)
G.TextLabel_9.TextSize = 9
G.TextLabel_9.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_9.Parent = G.Frame_11

-- Frame_12 (Frame)
G.Frame_12 = Instance.new("Frame")
G.Frame_12.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_12.BackgroundTransparency = 0.079999998211860657
G.Frame_12.BorderSizePixel = 0
G.Frame_12.LayoutOrder = 12
G.Frame_12.Size = UDim2.new(1, -4, 0, 44)
G.Frame_12.ZIndex = 14
G.Frame_12.Parent = G.Movement

-- UICorner_33 (UICorner)
G.UICorner_33 = Instance.new("UICorner")
G.UICorner_33.CornerRadius = UDim.new(1, 0)
G.UICorner_33.Parent = G.Frame_12

-- UIStroke_21 (UIStroke)
G.UIStroke_21 = Instance.new("UIStroke")
G.UIStroke_21.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_21.Transparency = 0.5
G.UIStroke_21.Parent = G.Frame_12

-- TextLabel_10 (TextLabel)
G.TextLabel_10 = Instance.new("TextLabel")
G.TextLabel_10.BackgroundTransparency = 1
G.TextLabel_10.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_10.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_10.ZIndex = 15
G.TextLabel_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_10.Text = "Auto TP Down"
G.TextLabel_10.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_10.TextSize = 12
G.TextLabel_10.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_10.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_10.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_10.Parent = G.Frame_12

-- Track_3 (Frame)
G.Track_3 = Instance.new("Frame")
G.Track_3.Name = "Track"
G.Track_3.AnchorPoint = Vector2.new(1, 0.5)
G.Track_3.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_3.BorderSizePixel = 0
G.Track_3.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_3.Size = UDim2.new(0, 48, 0, 26)
G.Track_3.ZIndex = 15
G.Track_3.Parent = G.Frame_12

-- UICorner_34 (UICorner)
G.UICorner_34 = Instance.new("UICorner")
G.UICorner_34.CornerRadius = UDim.new(1, 0)
G.UICorner_34.Parent = G.Track_3

-- Knob_3 (Frame)
G.Knob_3 = Instance.new("Frame")
G.Knob_3.Name = "Knob"
G.Knob_3.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_3.BorderSizePixel = 0
G.Knob_3.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_3.Size = UDim2.new(0, 20, 0, 20)
G.Knob_3.ZIndex = 16
G.Knob_3.Parent = G.Track_3

-- UICorner_35 (UICorner)
G.UICorner_35 = Instance.new("UICorner")
G.UICorner_35.CornerRadius = UDim.new(1, 0)
G.UICorner_35.Parent = G.Knob_3

-- KnobStroke_3 (UIStroke)
G.KnobStroke_3 = Instance.new("UIStroke")
G.KnobStroke_3.Name = "KnobStroke"
G.KnobStroke_3.Thickness = 0.60000002384185791
G.KnobStroke_3.Transparency = 0.75
G.KnobStroke_3.Parent = G.Knob_3

-- ToggleHit_3 (TextButton)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
G.ToggleHit_3 = Instance.new("TextButton")
G.ToggleHit_3.Name = "ToggleHit"
G.ToggleHit_3.BackgroundTransparency = 1
G.ToggleHit_3.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_3.ZIndex = 30
G.ToggleHit_3.AutoButtonColor = false
G.ToggleHit_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_3.Text = ""
G.ToggleHit_3.Parent = G.Frame_12

-- Frame_13 (Frame)
G.Frame_13 = Instance.new("Frame")
G.Frame_13.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_13.BackgroundTransparency = 0.079999998211860657
G.Frame_13.BorderSizePixel = 0
G.Frame_13.LayoutOrder = 13
G.Frame_13.Size = UDim2.new(1, -4, 0, 38)
G.Frame_13.ZIndex = 14
G.Frame_13.Parent = G.Movement

-- UICorner_36 (UICorner)
G.UICorner_36 = Instance.new("UICorner")
G.UICorner_36.CornerRadius = UDim.new(1, 0)
G.UICorner_36.Parent = G.Frame_13

-- UIStroke_22 (UIStroke)
G.UIStroke_22 = Instance.new("UIStroke")
G.UIStroke_22.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_22.Transparency = 0.5
G.UIStroke_22.Parent = G.Frame_13

-- TextLabel_11 (TextLabel)
G.TextLabel_11 = Instance.new("TextLabel")
G.TextLabel_11.BackgroundTransparency = 1
G.TextLabel_11.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_11.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_11.ZIndex = 15
G.TextLabel_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_11.Text = "TP Down Height"
G.TextLabel_11.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_11.TextSize = 12
G.TextLabel_11.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_11.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_11.Parent = G.Frame_13

-- TextBox_5 (TextBox)
G.TextBox_5 = Instance.new("TextBox")
G.TextBox_5.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_5.BackgroundTransparency = 0.69999998807907104
G.TextBox_5.BorderSizePixel = 0
G.TextBox_5.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_5.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_5.ZIndex = 15
G.TextBox_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_5.Text = "20"
G.TextBox_5.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_5.TextSize = 11
G.TextBox_5.ClearTextOnFocus = false
G.TextBox_5:SetAttribute("PrintedLastValidValue", 20)
G.TextBox_5.Parent = G.Frame_13

-- UICorner_37 (UICorner)
G.UICorner_37 = Instance.new("UICorner")
G.UICorner_37.CornerRadius = UDim.new(0, 6)
G.UICorner_37.Parent = G.TextBox_5

-- UIStroke_23 (UIStroke)
G.UIStroke_23 = Instance.new("UIStroke")
G.UIStroke_23.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_23.Thickness = 1.2000000476837158
G.UIStroke_23.Transparency = 0.25
G.UIStroke_23.Parent = G.TextBox_5

-- Frame_14 (Frame)
G.Frame_14 = Instance.new("Frame")
G.Frame_14.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_14.BackgroundTransparency = 0.079999998211860657
G.Frame_14.BorderSizePixel = 0
G.Frame_14.LayoutOrder = 14
G.Frame_14.Size = UDim2.new(1, -4, 0, 44)
G.Frame_14.ZIndex = 14
G.Frame_14.Parent = G.Movement

-- UICorner_38 (UICorner)
G.UICorner_38 = Instance.new("UICorner")
G.UICorner_38.CornerRadius = UDim.new(1, 0)
G.UICorner_38.Parent = G.Frame_14

-- UIStroke_24 (UIStroke)
G.UIStroke_24 = Instance.new("UIStroke")
G.UIStroke_24.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_24.Transparency = 0.5
G.UIStroke_24.Parent = G.Frame_14

-- TextLabel_12 (TextLabel)
G.TextLabel_12 = Instance.new("TextLabel")
G.TextLabel_12.BackgroundTransparency = 1
G.TextLabel_12.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_12.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_12.ZIndex = 15
G.TextLabel_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_12.Text = "Mirror TP Down"
G.TextLabel_12.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_12.TextSize = 12
G.TextLabel_12.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_12.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_12.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_12.Parent = G.Frame_14

-- Track_4 (Frame)
G.Track_4 = Instance.new("Frame")
G.Track_4.Name = "Track"
G.Track_4.AnchorPoint = Vector2.new(1, 0.5)
G.Track_4.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_4.BorderSizePixel = 0
G.Track_4.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_4.Size = UDim2.new(0, 48, 0, 26)
G.Track_4.ZIndex = 15
G.Track_4.Parent = G.Frame_14

-- UICorner_39 (UICorner)
G.UICorner_39 = Instance.new("UICorner")
G.UICorner_39.CornerRadius = UDim.new(1, 0)
G.UICorner_39.Parent = G.Track_4

-- Knob_4 (Frame)
G.Knob_4 = Instance.new("Frame")
G.Knob_4.Name = "Knob"
G.Knob_4.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_4.BorderSizePixel = 0
G.Knob_4.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_4.Size = UDim2.new(0, 20, 0, 20)
G.Knob_4.ZIndex = 16
G.Knob_4.Parent = G.Track_4

-- UICorner_40 (UICorner)
G.UICorner_40 = Instance.new("UICorner")
G.UICorner_40.CornerRadius = UDim.new(1, 0)
G.UICorner_40.Parent = G.Knob_4

-- KnobStroke_4 (UIStroke)
G.KnobStroke_4 = Instance.new("UIStroke")
G.KnobStroke_4.Name = "KnobStroke"
G.KnobStroke_4.Thickness = 0.60000002384185791
G.KnobStroke_4.Transparency = 0.75
G.KnobStroke_4.Parent = G.Knob_4

-- ToggleHit_4 (TextButton)
G.ToggleHit_4 = Instance.new("TextButton")
G.ToggleHit_4.Name = "ToggleHit"
G.ToggleHit_4.BackgroundTransparency = 1
G.ToggleHit_4.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_4.ZIndex = 30
G.ToggleHit_4.AutoButtonColor = false
G.ToggleHit_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_4.Text = ""
G.ToggleHit_4.Parent = G.Frame_14

-- Frame_15 (Frame)
G.Frame_15 = Instance.new("Frame")
G.Frame_15.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_15.BackgroundTransparency = 0.079999998211860657
G.Frame_15.BorderSizePixel = 0
G.Frame_15.LayoutOrder = 15
G.Frame_15.Size = UDim2.new(1, -4, 0, 44)
G.Frame_15.ZIndex = 14
G.Frame_15.Parent = G.Movement

-- UICorner_41 (UICorner)
G.UICorner_41 = Instance.new("UICorner")
G.UICorner_41.CornerRadius = UDim.new(1, 0)
G.UICorner_41.Parent = G.Frame_15

-- UIStroke_25 (UIStroke)
G.UIStroke_25 = Instance.new("UIStroke")
G.UIStroke_25.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_25.Transparency = 0.5
G.UIStroke_25.Parent = G.Frame_15

-- TextLabel_13 (TextLabel)
G.TextLabel_13 = Instance.new("TextLabel")
G.TextLabel_13.BackgroundTransparency = 1
G.TextLabel_13.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_13.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_13.ZIndex = 15
G.TextLabel_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_13.Text = "Infinite Jump"
G.TextLabel_13.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_13.TextSize = 12
G.TextLabel_13.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_13.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_13.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_13.Parent = G.Frame_15

-- Track_5 (Frame)
G.Track_5 = Instance.new("Frame")
G.Track_5.Name = "Track"
G.Track_5.AnchorPoint = Vector2.new(1, 0.5)
G.Track_5.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_5.BorderSizePixel = 0
G.Track_5.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_5.Size = UDim2.new(0, 48, 0, 26)
G.Track_5.ZIndex = 15
G.Track_5.Parent = G.Frame_15

-- UICorner_42 (UICorner)
G.UICorner_42 = Instance.new("UICorner")
G.UICorner_42.CornerRadius = UDim.new(1, 0)
G.UICorner_42.Parent = G.Track_5

-- Knob_5 (Frame)
G.Knob_5 = Instance.new("Frame")
G.Knob_5.Name = "Knob"
G.Knob_5.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_5.BorderSizePixel = 0
G.Knob_5.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_5.Size = UDim2.new(0, 20, 0, 20)
G.Knob_5.ZIndex = 16
G.Knob_5.Parent = G.Track_5

-- UICorner_43 (UICorner)
G.UICorner_43 = Instance.new("UICorner")
G.UICorner_43.CornerRadius = UDim.new(1, 0)
G.UICorner_43.Parent = G.Knob_5

-- KnobStroke_5 (UIStroke)
G.KnobStroke_5 = Instance.new("UIStroke")
G.KnobStroke_5.Name = "KnobStroke"
G.KnobStroke_5.Thickness = 0.60000002384185791
G.KnobStroke_5.Transparency = 0.75
G.KnobStroke_5.Parent = G.Knob_5

-- ToggleHit_5 (TextButton)
G.ToggleHit_5 = Instance.new("TextButton")
G.ToggleHit_5.Name = "ToggleHit"
G.ToggleHit_5.BackgroundTransparency = 1
G.ToggleHit_5.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_5.ZIndex = 30
G.ToggleHit_5.AutoButtonColor = false
G.ToggleHit_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_5.Text = ""
G.ToggleHit_5.Parent = G.Frame_15

-- Frame_16 (Frame)
G.Frame_16 = Instance.new("Frame")
G.Frame_16.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_16.BackgroundTransparency = 0.029999999329447746
G.Frame_16.BorderSizePixel = 0
G.Frame_16.ClipsDescendants = true
G.Frame_16.LayoutOrder = 16
G.Frame_16.Size = UDim2.new(1, -4, 0, 44)
G.Frame_16.ZIndex = 14
G.Frame_16.Parent = G.Movement

-- UICorner_44 (UICorner)
G.UICorner_44 = Instance.new("UICorner")
G.UICorner_44.CornerRadius = UDim.new(0, 9)
G.UICorner_44.Parent = G.Frame_16

-- UIStroke_26 (UIStroke)
G.UIStroke_26 = Instance.new("UIStroke")
G.UIStroke_26.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_26.Transparency = 0.34999999403953552
G.UIStroke_26.Parent = G.Frame_16

-- TextLabel_14 (TextLabel)
G.TextLabel_14 = Instance.new("TextLabel")
G.TextLabel_14.BackgroundTransparency = 1
G.TextLabel_14.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_14.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_14.ZIndex = 16
G.TextLabel_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_14.Text = "Jump Mode"
G.TextLabel_14.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_14.TextSize = 12
G.TextLabel_14.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_14.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_14.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_14.Parent = G.Frame_16

-- DropdownCardGradient_2 (UIGradient)
G.DropdownCardGradient_2 = Instance.new("UIGradient")
G.DropdownCardGradient_2.Name = "DropdownCardGradient"
G.DropdownCardGradient_2.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_2.Rotation = 90
G.DropdownCardGradient_2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_2.Parent = G.Frame_16

-- DropdownSelector_2 (TextButton)
G.DropdownSelector_2 = Instance.new("TextButton")
G.DropdownSelector_2.Name = "DropdownSelector"
G.DropdownSelector_2.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_2.BorderSizePixel = 0
G.DropdownSelector_2.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_2.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_2.ZIndex = 18
G.DropdownSelector_2.AutoButtonColor = false
G.DropdownSelector_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_2.Text = "MANUAL  ▼"
G.DropdownSelector_2.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_2.TextSize = 11
G.DropdownSelector_2.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_2.Parent = G.Frame_16

-- UICorner_45 (UICorner)
G.UICorner_45 = Instance.new("UICorner")
G.UICorner_45.CornerRadius = UDim.new(0, 7)
G.UICorner_45.Parent = G.DropdownSelector_2

-- UIStroke_27 (UIStroke)
G.UIStroke_27 = Instance.new("UIStroke")
G.UIStroke_27.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_27.Transparency = 0.20000000298023224
G.UIStroke_27.Parent = G.DropdownSelector_2

-- DropdownChoices_2 (ScrollingFrame)
G.DropdownChoices_2 = Instance.new("ScrollingFrame")
G.DropdownChoices_2.Name = "DropdownChoices"
G.DropdownChoices_2.Active = true
G.DropdownChoices_2.BackgroundTransparency = 1
G.DropdownChoices_2.BorderSizePixel = 0
G.DropdownChoices_2.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_2.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_2.Visible = false
G.DropdownChoices_2.ZIndex = 17
G.DropdownChoices_2.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_2.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_2.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_2.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_2.ScrollBarThickness = 0
G.DropdownChoices_2.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_2.Parent = G.Frame_16

-- UIListLayout_3 (UIListLayout)
G.UIListLayout_3 = Instance.new("UIListLayout")
G.UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_3.Padding = UDim.new(0, 4)
G.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_3.Parent = G.DropdownChoices_2

-- Option1_2 (TextButton)
G.Option1_2 = Instance.new("TextButton")
G.Option1_2.Name = "Option1"
G.Option1_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option1_2.BorderSizePixel = 0
G.Option1_2.LayoutOrder = 1
G.Option1_2.Size = UDim2.new(1, -4, 0, 27)
G.Option1_2.ZIndex = 18
G.Option1_2.AutoButtonColor = false
G.Option1_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_2.Text = "HOLD"
G.Option1_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option1_2.TextSize = 11
G.Option1_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_2.Parent = G.DropdownChoices_2

-- UICorner_46 (UICorner)
G.UICorner_46 = Instance.new("UICorner")
G.UICorner_46.CornerRadius = UDim.new(0, 7)
G.UICorner_46.Parent = G.Option1_2

-- Option2_2 (TextButton)
G.Option2_2 = Instance.new("TextButton")
G.Option2_2.Name = "Option2"
G.Option2_2.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option2_2.BorderSizePixel = 0
G.Option2_2.LayoutOrder = 2
G.Option2_2.Size = UDim2.new(1, -4, 0, 27)
G.Option2_2.ZIndex = 18
G.Option2_2.AutoButtonColor = false
G.Option2_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_2.Text = "MANUAL"
G.Option2_2.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option2_2.TextSize = 11
G.Option2_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_2.Parent = G.DropdownChoices_2

-- UICorner_47 (UICorner)
G.UICorner_47 = Instance.new("UICorner")
G.UICorner_47.CornerRadius = UDim.new(0, 7)
G.UICorner_47.Parent = G.Option2_2

-- SectionHeading_4 (TextLabel)
G.SectionHeading_4 = Instance.new("TextLabel")
G.SectionHeading_4.Name = "SectionHeading"
G.SectionHeading_4.BackgroundTransparency = 1
G.SectionHeading_4.LayoutOrder = 17
G.SectionHeading_4.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_4.ZIndex = 15
G.SectionHeading_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_4.Text = "DROP"
G.SectionHeading_4.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_4.TextSize = 11
G.SectionHeading_4.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_4.Parent = G.Movement

-- Frame_17 (Frame)
G.Frame_17 = Instance.new("Frame")
G.Frame_17.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_17.BackgroundTransparency = 0.079999998211860657
G.Frame_17.BorderSizePixel = 0
G.Frame_17.LayoutOrder = 18
G.Frame_17.Size = UDim2.new(1, -4, 0, 44)
G.Frame_17.ZIndex = 14
G.Frame_17.Parent = G.Movement

-- UICorner_48 (UICorner)
G.UICorner_48 = Instance.new("UICorner")
G.UICorner_48.CornerRadius = UDim.new(1, 0)
G.UICorner_48.Parent = G.Frame_17

-- UIStroke_28 (UIStroke)
G.UIStroke_28 = Instance.new("UIStroke")
G.UIStroke_28.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_28.Transparency = 0.5
G.UIStroke_28.Parent = G.Frame_17

-- TextLabel_15 (TextLabel)
G.TextLabel_15 = Instance.new("TextLabel")
G.TextLabel_15.BackgroundTransparency = 1
G.TextLabel_15.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_15.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_15.ZIndex = 15
G.TextLabel_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_15.Text = "Drop Brainrot"
G.TextLabel_15.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_15.TextSize = 12
G.TextLabel_15.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_15.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_15.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_15.Parent = G.Frame_17

-- Track_6 (Frame)
G.Track_6 = Instance.new("Frame")
G.Track_6.Name = "Track"
G.Track_6.AnchorPoint = Vector2.new(1, 0.5)
G.Track_6.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_6.BorderSizePixel = 0
G.Track_6.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_6.Size = UDim2.new(0, 48, 0, 26)
G.Track_6.ZIndex = 15
G.Track_6.Parent = G.Frame_17

-- UICorner_49 (UICorner)
G.UICorner_49 = Instance.new("UICorner")
G.UICorner_49.CornerRadius = UDim.new(1, 0)
G.UICorner_49.Parent = G.Track_6

-- Knob_6 (Frame)
G.Knob_6 = Instance.new("Frame")
G.Knob_6.Name = "Knob"
G.Knob_6.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_6.BorderSizePixel = 0
G.Knob_6.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_6.Size = UDim2.new(0, 20, 0, 20)
G.Knob_6.ZIndex = 16
G.Knob_6.Parent = G.Track_6

-- UICorner_50 (UICorner)
G.UICorner_50 = Instance.new("UICorner")
G.UICorner_50.CornerRadius = UDim.new(1, 0)
G.UICorner_50.Parent = G.Knob_6

-- KnobStroke_6 (UIStroke)
G.KnobStroke_6 = Instance.new("UIStroke")
G.KnobStroke_6.Name = "KnobStroke"
G.KnobStroke_6.Thickness = 0.60000002384185791
G.KnobStroke_6.Transparency = 0.75
G.KnobStroke_6.Parent = G.Knob_6

-- ToggleHit_6 (TextButton)
G.ToggleHit_6 = Instance.new("TextButton")
G.ToggleHit_6.Name = "ToggleHit"
G.ToggleHit_6.BackgroundTransparency = 1
G.ToggleHit_6.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_6.ZIndex = 30
G.ToggleHit_6.AutoButtonColor = false
G.ToggleHit_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_6.Text = ""
G.ToggleHit_6.Parent = G.Frame_17

-- Frame_18 (Frame)
G.Frame_18 = Instance.new("Frame")
G.Frame_18.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_18.BackgroundTransparency = 0.029999999329447746
G.Frame_18.BorderSizePixel = 0
G.Frame_18.ClipsDescendants = true
G.Frame_18.LayoutOrder = 19
G.Frame_18.Size = UDim2.new(1, -4, 0, 44)
G.Frame_18.ZIndex = 14
G.Frame_18.Parent = G.Movement

-- UICorner_51 (UICorner)
G.UICorner_51 = Instance.new("UICorner")
G.UICorner_51.CornerRadius = UDim.new(0, 9)
G.UICorner_51.Parent = G.Frame_18

-- UIStroke_29 (UIStroke)
G.UIStroke_29 = Instance.new("UIStroke")
G.UIStroke_29.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_29.Transparency = 0.34999999403953552
G.UIStroke_29.Parent = G.Frame_18

-- TextLabel_16 (TextLabel)
G.TextLabel_16 = Instance.new("TextLabel")
G.TextLabel_16.BackgroundTransparency = 1
G.TextLabel_16.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_16.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_16.ZIndex = 16
G.TextLabel_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_16.Text = "Drop Mode"
G.TextLabel_16.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_16.TextSize = 12
G.TextLabel_16.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_16.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_16.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_16.Parent = G.Frame_18

-- DropdownCardGradient_3 (UIGradient)
G.DropdownCardGradient_3 = Instance.new("UIGradient")
G.DropdownCardGradient_3.Name = "DropdownCardGradient"
G.DropdownCardGradient_3.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_3.Rotation = 90
G.DropdownCardGradient_3.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_3.Parent = G.Frame_18

-- DropdownSelector_3 (TextButton)
G.DropdownSelector_3 = Instance.new("TextButton")
G.DropdownSelector_3.Name = "DropdownSelector"
G.DropdownSelector_3.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_3.BorderSizePixel = 0
G.DropdownSelector_3.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_3.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_3.ZIndex = 18
G.DropdownSelector_3.AutoButtonColor = false
G.DropdownSelector_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_3.Text = "Fling  ▼"
G.DropdownSelector_3.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_3.TextSize = 11
G.DropdownSelector_3.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_3.Parent = G.Frame_18

-- UICorner_52 (UICorner)
G.UICorner_52 = Instance.new("UICorner")
G.UICorner_52.CornerRadius = UDim.new(0, 7)
G.UICorner_52.Parent = G.DropdownSelector_3

-- UIStroke_30 (UIStroke)
G.UIStroke_30 = Instance.new("UIStroke")
G.UIStroke_30.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_30.Transparency = 0.20000000298023224
G.UIStroke_30.Parent = G.DropdownSelector_3

-- DropdownChoices_3 (ScrollingFrame)
G.DropdownChoices_3 = Instance.new("ScrollingFrame")
G.DropdownChoices_3.Name = "DropdownChoices"
G.DropdownChoices_3.Active = true
G.DropdownChoices_3.BackgroundTransparency = 1
G.DropdownChoices_3.BorderSizePixel = 0
G.DropdownChoices_3.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_3.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_3.Visible = false
G.DropdownChoices_3.ZIndex = 17
G.DropdownChoices_3.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_3.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_3.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_3.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_3.ScrollBarThickness = 0
G.DropdownChoices_3.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_3.Parent = G.Frame_18

-- UIListLayout_4 (UIListLayout)
G.UIListLayout_4 = Instance.new("UIListLayout")
G.UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_4.Padding = UDim.new(0, 4)
G.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_4.Parent = G.DropdownChoices_3

-- Option1_3 (TextButton)
G.Option1_3 = Instance.new("TextButton")
G.Option1_3.Name = "Option1"
G.Option1_3.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_3.BorderSizePixel = 0
G.Option1_3.LayoutOrder = 1
G.Option1_3.Size = UDim2.new(1, -4, 0, 27)
G.Option1_3.ZIndex = 18
G.Option1_3.AutoButtonColor = false
G.Option1_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_3.Text = "Fling"
G.Option1_3.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_3.TextSize = 11
G.Option1_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_3.Parent = G.DropdownChoices_3

-- UICorner_53 (UICorner)
G.UICorner_53 = Instance.new("UICorner")
G.UICorner_53.CornerRadius = UDim.new(0, 7)
G.UICorner_53.Parent = G.Option1_3

-- Option2_3 (TextButton)
G.Option2_3 = Instance.new("TextButton")
G.Option2_3.Name = "Option2"
G.Option2_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_3.BorderSizePixel = 0
G.Option2_3.LayoutOrder = 2
G.Option2_3.Size = UDim2.new(1, -4, 0, 27)
G.Option2_3.ZIndex = 18
G.Option2_3.AutoButtonColor = false
G.Option2_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_3.Text = "Jump Drop"
G.Option2_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_3.TextSize = 11
G.Option2_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_3.Parent = G.DropdownChoices_3

-- UICorner_54 (UICorner)
G.UICorner_54 = Instance.new("UICorner")
G.UICorner_54.CornerRadius = UDim.new(0, 7)
G.UICorner_54.Parent = G.Option2_3

-- Combat (ScrollingFrame)
G.Combat = Instance.new("ScrollingFrame")
G.Combat.Name = "Combat"
G.Combat.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
G.Combat.BackgroundTransparency = 0.85000002384185791
G.Combat.BorderSizePixel = 0
G.Combat.Size = UDim2.new(1, 0, 1, 0)
G.Combat.Visible = false
G.Combat.ZIndex = 6
G.Combat.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Combat.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Combat.ScrollBarImageColor3 = Color3.fromRGB(30, 30, 35)
G.Combat.ScrollBarImageTransparency = 0.30000001192092896
G.Combat.ScrollBarThickness = 2
G.Combat.ScrollingDirection = Enum.ScrollingDirection.Y
G.Combat.Parent = G.Frame_3

-- UICorner_55 (UICorner)
G.UICorner_55 = Instance.new("UICorner")
G.UICorner_55.CornerRadius = UDim.new(0, 16)
G.UICorner_55.Parent = G.Combat

-- UIListLayout_5 (UIListLayout)
G.UIListLayout_5 = Instance.new("UIListLayout")
G.UIListLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_5.Padding = UDim.new(0, 6)
G.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_5.Parent = G.Combat

-- UIPadding_2 (UIPadding)
G.UIPadding_2 = Instance.new("UIPadding")
G.UIPadding_2.PaddingBottom = UDim.new(0, 20)
G.UIPadding_2.PaddingLeft = UDim.new(0, 8)
G.UIPadding_2.PaddingRight = UDim.new(0, 8)
G.UIPadding_2.PaddingTop = UDim.new(0, 6)
G.UIPadding_2.Parent = G.Combat

-- SectionHeading_5 (TextLabel)
G.SectionHeading_5 = Instance.new("TextLabel")
G.SectionHeading_5.Name = "SectionHeading"
G.SectionHeading_5.BackgroundTransparency = 1
G.SectionHeading_5.LayoutOrder = 1
G.SectionHeading_5.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_5.ZIndex = 15
G.SectionHeading_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_5.Text = "AIMBOTS"
G.SectionHeading_5.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_5.TextSize = 11
G.SectionHeading_5.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_5.Parent = G.Combat

-- Frame_19 (Frame)
G.Frame_19 = Instance.new("Frame")
G.Frame_19.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_19.BackgroundTransparency = 0.079999998211860657
G.Frame_19.BorderSizePixel = 0
G.Frame_19.LayoutOrder = 2
G.Frame_19.Size = UDim2.new(1, -4, 0, 44)
G.Frame_19.ZIndex = 14
G.Frame_19.Parent = G.Combat

-- UICorner_56 (UICorner)
G.UICorner_56 = Instance.new("UICorner")
G.UICorner_56.CornerRadius = UDim.new(1, 0)
G.UICorner_56.Parent = G.Frame_19

-- UIStroke_31 (UIStroke)
G.UIStroke_31 = Instance.new("UIStroke")
G.UIStroke_31.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_31.Transparency = 0.5
G.UIStroke_31.Parent = G.Frame_19

-- TextLabel_17 (TextLabel)
G.TextLabel_17 = Instance.new("TextLabel")
G.TextLabel_17.BackgroundTransparency = 1
G.TextLabel_17.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_17.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_17.ZIndex = 15
G.TextLabel_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_17.Text = "Aimbot"
G.TextLabel_17.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_17.TextSize = 12
G.TextLabel_17.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_17.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_17.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_17.Parent = G.Frame_19

-- Track_7 (Frame)
G.Track_7 = Instance.new("Frame")
G.Track_7.Name = "Track"
G.Track_7.AnchorPoint = Vector2.new(1, 0.5)
G.Track_7.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_7.BorderSizePixel = 0
G.Track_7.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_7.Size = UDim2.new(0, 48, 0, 26)
G.Track_7.ZIndex = 15
G.Track_7.Parent = G.Frame_19

-- UICorner_57 (UICorner)
G.UICorner_57 = Instance.new("UICorner")
G.UICorner_57.CornerRadius = UDim.new(1, 0)
G.UICorner_57.Parent = G.Track_7

-- Knob_7 (Frame)
G.Knob_7 = Instance.new("Frame")
G.Knob_7.Name = "Knob"
G.Knob_7.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_7.BorderSizePixel = 0
G.Knob_7.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_7.Size = UDim2.new(0, 20, 0, 20)
G.Knob_7.ZIndex = 16
G.Knob_7.Parent = G.Track_7

-- UICorner_58 (UICorner)
G.UICorner_58 = Instance.new("UICorner")
G.UICorner_58.CornerRadius = UDim.new(1, 0)
G.UICorner_58.Parent = G.Knob_7

-- KnobStroke_7 (UIStroke)
G.KnobStroke_7 = Instance.new("UIStroke")
G.KnobStroke_7.Name = "KnobStroke"
G.KnobStroke_7.Thickness = 0.60000002384185791
G.KnobStroke_7.Transparency = 0.75
G.KnobStroke_7.Parent = G.Knob_7

-- ToggleHit_7 (TextButton)
G.ToggleHit_7 = Instance.new("TextButton")
G.ToggleHit_7.Name = "ToggleHit"
G.ToggleHit_7.BackgroundTransparency = 1
G.ToggleHit_7.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_7.ZIndex = 30
G.ToggleHit_7.AutoButtonColor = false
G.ToggleHit_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_7.Text = ""
G.ToggleHit_7.Parent = G.Frame_19

-- Frame_20 (Frame)
G.Frame_20 = Instance.new("Frame")
G.Frame_20.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_20.BackgroundTransparency = 0.079999998211860657
G.Frame_20.BorderSizePixel = 0
G.Frame_20.LayoutOrder = 3
G.Frame_20.Size = UDim2.new(1, -4, 0, 38)
G.Frame_20.ZIndex = 14
G.Frame_20.Parent = G.Combat

-- UICorner_59 (UICorner)
G.UICorner_59 = Instance.new("UICorner")
G.UICorner_59.CornerRadius = UDim.new(1, 0)
G.UICorner_59.Parent = G.Frame_20

-- UIStroke_32 (UIStroke)
G.UIStroke_32 = Instance.new("UIStroke")
G.UIStroke_32.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_32.Transparency = 0.5
G.UIStroke_32.Parent = G.Frame_20

-- TextLabel_18 (TextLabel)
G.TextLabel_18 = Instance.new("TextLabel")
G.TextLabel_18.BackgroundTransparency = 1
G.TextLabel_18.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_18.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_18.ZIndex = 15
G.TextLabel_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_18.Text = "Chase Speed"
G.TextLabel_18.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_18.TextSize = 12
G.TextLabel_18.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_18.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_18.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_18.Parent = G.Frame_20

-- TextBox_6 (TextBox)
G.TextBox_6 = Instance.new("TextBox")
G.TextBox_6.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_6.BackgroundTransparency = 0.69999998807907104
G.TextBox_6.BorderSizePixel = 0
G.TextBox_6.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_6.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_6.ZIndex = 15
G.TextBox_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_6.Text = "58"
G.TextBox_6.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_6.TextSize = 11
G.TextBox_6.ClearTextOnFocus = false
G.TextBox_6:SetAttribute("PrintedLastValidValue", 58)
G.TextBox_6.Parent = G.Frame_20

-- UICorner_60 (UICorner)
G.UICorner_60 = Instance.new("UICorner")
G.UICorner_60.CornerRadius = UDim.new(0, 6)
G.UICorner_60.Parent = G.TextBox_6

-- UIStroke_33 (UIStroke)
G.UIStroke_33 = Instance.new("UIStroke")
G.UIStroke_33.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_33.Thickness = 1.2000000476837158
G.UIStroke_33.Transparency = 0.25
G.UIStroke_33.Parent = G.TextBox_6

-- Frame_21 (Frame)
G.Frame_21 = Instance.new("Frame")
G.Frame_21.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_21.BackgroundTransparency = 0.079999998211860657
G.Frame_21.BorderSizePixel = 0
G.Frame_21.LayoutOrder = 4
G.Frame_21.Size = UDim2.new(1, -4, 0, 44)
G.Frame_21.ZIndex = 14
G.Frame_21.Parent = G.Combat

-- UICorner_61 (UICorner)
G.UICorner_61 = Instance.new("UICorner")
G.UICorner_61.CornerRadius = UDim.new(1, 0)
G.UICorner_61.Parent = G.Frame_21

-- UIStroke_34 (UIStroke)
G.UIStroke_34 = Instance.new("UIStroke")
G.UIStroke_34.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_34.Transparency = 0.5
G.UIStroke_34.Parent = G.Frame_21

-- TextLabel_19 (TextLabel)
G.TextLabel_19 = Instance.new("TextLabel")
G.TextLabel_19.BackgroundTransparency = 1
G.TextLabel_19.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_19.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_19.ZIndex = 15
G.TextLabel_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_19.Text = "Auto Swing"
G.TextLabel_19.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_19.TextSize = 12
G.TextLabel_19.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_19.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_19.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_19.Parent = G.Frame_21

-- Track_8 (Frame)
G.Track_8 = Instance.new("Frame")
G.Track_8.Name = "Track"
G.Track_8.AnchorPoint = Vector2.new(1, 0.5)
G.Track_8.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Track_8.BorderSizePixel = 0
G.Track_8.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_8.Size = UDim2.new(0, 48, 0, 26)
G.Track_8.ZIndex = 15
G.Track_8.Parent = G.Frame_21

-- UICorner_62 (UICorner)
G.UICorner_62 = Instance.new("UICorner")
G.UICorner_62.CornerRadius = UDim.new(1, 0)
G.UICorner_62.Parent = G.Track_8

-- Knob_8 (Frame)
G.Knob_8 = Instance.new("Frame")
G.Knob_8.Name = "Knob"
G.Knob_8.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_8.BorderSizePixel = 0
G.Knob_8.Position = UDim2.new(1, -23, 0.5, 0)
G.Knob_8.Size = UDim2.new(0, 20, 0, 20)
G.Knob_8.ZIndex = 16
G.Knob_8.Parent = G.Track_8

-- UICorner_63 (UICorner)
G.UICorner_63 = Instance.new("UICorner")
G.UICorner_63.CornerRadius = UDim.new(1, 0)
G.UICorner_63.Parent = G.Knob_8

-- KnobStroke_8 (UIStroke)
G.KnobStroke_8 = Instance.new("UIStroke")
G.KnobStroke_8.Name = "KnobStroke"
G.KnobStroke_8.Thickness = 0.60000002384185791
G.KnobStroke_8.Transparency = 0.75
G.KnobStroke_8.Parent = G.Knob_8

-- ToggleHit_8 (TextButton)
G.ToggleHit_8 = Instance.new("TextButton")
G.ToggleHit_8.Name = "ToggleHit"
G.ToggleHit_8.BackgroundTransparency = 1
G.ToggleHit_8.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_8.ZIndex = 30
G.ToggleHit_8.AutoButtonColor = false
G.ToggleHit_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_8.Text = ""
G.ToggleHit_8.Parent = G.Frame_21

-- SectionHeading_6 (TextLabel)
G.SectionHeading_6 = Instance.new("TextLabel")
G.SectionHeading_6.Name = "SectionHeading"
G.SectionHeading_6.BackgroundTransparency = 1
G.SectionHeading_6.LayoutOrder = 5
G.SectionHeading_6.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_6.ZIndex = 15
G.SectionHeading_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_6.Text = "SPIN BOT"
G.SectionHeading_6.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_6.TextSize = 11
G.SectionHeading_6.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_6.Parent = G.Combat

-- Frame_22 (Frame)
G.Frame_22 = Instance.new("Frame")
G.Frame_22.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_22.BackgroundTransparency = 0.079999998211860657
G.Frame_22.BorderSizePixel = 0
G.Frame_22.LayoutOrder = 6
G.Frame_22.Size = UDim2.new(1, -4, 0, 44)
G.Frame_22.ZIndex = 14
G.Frame_22.Parent = G.Combat

-- UICorner_64 (UICorner)
G.UICorner_64 = Instance.new("UICorner")
G.UICorner_64.CornerRadius = UDim.new(1, 0)
G.UICorner_64.Parent = G.Frame_22

-- UIStroke_35 (UIStroke)
G.UIStroke_35 = Instance.new("UIStroke")
G.UIStroke_35.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_35.Transparency = 0.5
G.UIStroke_35.Parent = G.Frame_22

-- TextLabel_20 (TextLabel)
G.TextLabel_20 = Instance.new("TextLabel")
G.TextLabel_20.BackgroundTransparency = 1
G.TextLabel_20.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_20.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_20.ZIndex = 15
G.TextLabel_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_20.Text = "Spin Bot"
G.TextLabel_20.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_20.TextSize = 12
G.TextLabel_20.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_20.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_20.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_20.Parent = G.Frame_22

-- Track_9 (Frame)
G.Track_9 = Instance.new("Frame")
G.Track_9.Name = "Track"
G.Track_9.AnchorPoint = Vector2.new(1, 0.5)
G.Track_9.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_9.BorderSizePixel = 0
G.Track_9.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_9.Size = UDim2.new(0, 48, 0, 26)
G.Track_9.ZIndex = 15
G.Track_9.Parent = G.Frame_22

-- UICorner_65 (UICorner)
G.UICorner_65 = Instance.new("UICorner")
G.UICorner_65.CornerRadius = UDim.new(1, 0)
G.UICorner_65.Parent = G.Track_9

-- Knob_9 (Frame)
G.Knob_9 = Instance.new("Frame")
G.Knob_9.Name = "Knob"
G.Knob_9.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_9.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_9.BorderSizePixel = 0
G.Knob_9.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_9.Size = UDim2.new(0, 20, 0, 20)
G.Knob_9.ZIndex = 16
G.Knob_9.Parent = G.Track_9

-- UICorner_66 (UICorner)
G.UICorner_66 = Instance.new("UICorner")
G.UICorner_66.CornerRadius = UDim.new(1, 0)
G.UICorner_66.Parent = G.Knob_9

-- KnobStroke_9 (UIStroke)
G.KnobStroke_9 = Instance.new("UIStroke")
G.KnobStroke_9.Name = "KnobStroke"
G.KnobStroke_9.Thickness = 0.60000002384185791
G.KnobStroke_9.Transparency = 0.75
G.KnobStroke_9.Parent = G.Knob_9

-- ToggleHit_9 (TextButton)
G.ToggleHit_9 = Instance.new("TextButton")
G.ToggleHit_9.Name = "ToggleHit"
G.ToggleHit_9.BackgroundTransparency = 1
G.ToggleHit_9.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_9.ZIndex = 30
G.ToggleHit_9.AutoButtonColor = false
G.ToggleHit_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_9.Text = ""
G.ToggleHit_9.Parent = G.Frame_22

-- Frame_23 (Frame)
G.Frame_23 = Instance.new("Frame")
G.Frame_23.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_23.BackgroundTransparency = 0.079999998211860657
G.Frame_23.BorderSizePixel = 0
G.Frame_23.LayoutOrder = 7
G.Frame_23.Size = UDim2.new(1, -4, 0, 38)
G.Frame_23.ZIndex = 14
G.Frame_23.Parent = G.Combat

-- UICorner_67 (UICorner)
G.UICorner_67 = Instance.new("UICorner")
G.UICorner_67.CornerRadius = UDim.new(1, 0)
G.UICorner_67.Parent = G.Frame_23

-- UIStroke_36 (UIStroke)
G.UIStroke_36 = Instance.new("UIStroke")
G.UIStroke_36.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_36.Transparency = 0.5
G.UIStroke_36.Parent = G.Frame_23

-- TextLabel_21 (TextLabel)
G.TextLabel_21 = Instance.new("TextLabel")
G.TextLabel_21.BackgroundTransparency = 1
G.TextLabel_21.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_21.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_21.ZIndex = 15
G.TextLabel_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_21.Text = "Spin Speed"
G.TextLabel_21.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_21.TextSize = 12
G.TextLabel_21.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_21.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_21.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_21.Parent = G.Frame_23

-- TextBox_7 (TextBox)
G.TextBox_7 = Instance.new("TextBox")
G.TextBox_7.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_7.BackgroundTransparency = 0.69999998807907104
G.TextBox_7.BorderSizePixel = 0
G.TextBox_7.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_7.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_7.ZIndex = 15
G.TextBox_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_7.Text = "30"
G.TextBox_7.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_7.TextSize = 11
G.TextBox_7.ClearTextOnFocus = false
G.TextBox_7:SetAttribute("PrintedLastValidValue", 30)
G.TextBox_7.Parent = G.Frame_23

-- UICorner_68 (UICorner)
G.UICorner_68 = Instance.new("UICorner")
G.UICorner_68.CornerRadius = UDim.new(0, 6)
G.UICorner_68.Parent = G.TextBox_7

-- UIStroke_37 (UIStroke)
G.UIStroke_37 = Instance.new("UIStroke")
G.UIStroke_37.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_37.Thickness = 1.2000000476837158
G.UIStroke_37.Transparency = 0.25
G.UIStroke_37.Parent = G.TextBox_7

-- SectionHeading_7 (TextLabel)
G.SectionHeading_7 = Instance.new("TextLabel")
G.SectionHeading_7.Name = "SectionHeading"
G.SectionHeading_7.BackgroundTransparency = 1
G.SectionHeading_7.LayoutOrder = 8
G.SectionHeading_7.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_7.ZIndex = 15
G.SectionHeading_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_7.Text = "RAGDOLL COUNTDOWN"
G.SectionHeading_7.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_7.TextSize = 11
G.SectionHeading_7.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_7.Parent = G.Combat

-- Frame_24 (Frame)
G.Frame_24 = Instance.new("Frame")
G.Frame_24.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_24.BackgroundTransparency = 0.079999998211860657
G.Frame_24.BorderSizePixel = 0
G.Frame_24.LayoutOrder = 9
G.Frame_24.Size = UDim2.new(1, -4, 0, 44)
G.Frame_24.ZIndex = 14
G.Frame_24.Parent = G.Combat

-- UICorner_69 (UICorner)
G.UICorner_69 = Instance.new("UICorner")
G.UICorner_69.CornerRadius = UDim.new(1, 0)
G.UICorner_69.Parent = G.Frame_24

-- UIStroke_38 (UIStroke)
G.UIStroke_38 = Instance.new("UIStroke")
G.UIStroke_38.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_38.Transparency = 0.5
G.UIStroke_38.Parent = G.Frame_24

-- TextLabel_22 (TextLabel)
G.TextLabel_22 = Instance.new("TextLabel")
G.TextLabel_22.BackgroundTransparency = 1
G.TextLabel_22.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_22.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_22.ZIndex = 15
G.TextLabel_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_22.Text = "My Ragdoll Timer"
G.TextLabel_22.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_22.TextSize = 12
G.TextLabel_22.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_22.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_22.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_22.Parent = G.Frame_24

-- Track_10 (Frame)
G.Track_10 = Instance.new("Frame")
G.Track_10.Name = "Track"
G.Track_10.AnchorPoint = Vector2.new(1, 0.5)
G.Track_10.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Track_10.BorderSizePixel = 0
G.Track_10.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_10.Size = UDim2.new(0, 48, 0, 26)
G.Track_10.ZIndex = 15
G.Track_10.Parent = G.Frame_24

-- UICorner_70 (UICorner)
G.UICorner_70 = Instance.new("UICorner")
G.UICorner_70.CornerRadius = UDim.new(1, 0)
G.UICorner_70.Parent = G.Track_10

-- Knob_10 (Frame)
G.Knob_10 = Instance.new("Frame")
G.Knob_10.Name = "Knob"
G.Knob_10.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_10.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_10.BorderSizePixel = 0
G.Knob_10.Position = UDim2.new(1, -23, 0.5, 0)
G.Knob_10.Size = UDim2.new(0, 20, 0, 20)
G.Knob_10.ZIndex = 16
G.Knob_10.Parent = G.Track_10

-- UICorner_71 (UICorner)
G.UICorner_71 = Instance.new("UICorner")
G.UICorner_71.CornerRadius = UDim.new(1, 0)
G.UICorner_71.Parent = G.Knob_10

-- KnobStroke_10 (UIStroke)
G.KnobStroke_10 = Instance.new("UIStroke")
G.KnobStroke_10.Name = "KnobStroke"
G.KnobStroke_10.Thickness = 0.60000002384185791
G.KnobStroke_10.Transparency = 0.75
G.KnobStroke_10.Parent = G.Knob_10

-- ToggleHit_10 (TextButton)
G.ToggleHit_10 = Instance.new("TextButton")
G.ToggleHit_10.Name = "ToggleHit"
G.ToggleHit_10.BackgroundTransparency = 1
G.ToggleHit_10.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_10.ZIndex = 30
G.ToggleHit_10.AutoButtonColor = false
G.ToggleHit_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_10.Text = ""
G.ToggleHit_10.Parent = G.Frame_24

-- Frame_25 (Frame)
G.Frame_25 = Instance.new("Frame")
G.Frame_25.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_25.BackgroundTransparency = 0.079999998211860657
G.Frame_25.BorderSizePixel = 0
G.Frame_25.LayoutOrder = 10
G.Frame_25.Size = UDim2.new(1, -4, 0, 44)
G.Frame_25.ZIndex = 14
G.Frame_25.Parent = G.Combat

-- UICorner_72 (UICorner)
G.UICorner_72 = Instance.new("UICorner")
G.UICorner_72.CornerRadius = UDim.new(1, 0)
G.UICorner_72.Parent = G.Frame_25

-- UIStroke_39 (UIStroke)
G.UIStroke_39 = Instance.new("UIStroke")
G.UIStroke_39.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_39.Transparency = 0.5
G.UIStroke_39.Parent = G.Frame_25

-- TextLabel_23 (TextLabel)
G.TextLabel_23 = Instance.new("TextLabel")
G.TextLabel_23.BackgroundTransparency = 1
G.TextLabel_23.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_23.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_23.ZIndex = 15
G.TextLabel_23.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_23.Text = "Enemy Ragdoll Timer"
G.TextLabel_23.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_23.TextSize = 12
G.TextLabel_23.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_23.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_23.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_23.Parent = G.Frame_25

-- Track_11 (Frame)
G.Track_11 = Instance.new("Frame")
G.Track_11.Name = "Track"
G.Track_11.AnchorPoint = Vector2.new(1, 0.5)
G.Track_11.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Track_11.BorderSizePixel = 0
G.Track_11.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_11.Size = UDim2.new(0, 48, 0, 26)
G.Track_11.ZIndex = 15
G.Track_11.Parent = G.Frame_25

-- UICorner_73 (UICorner)
G.UICorner_73 = Instance.new("UICorner")
G.UICorner_73.CornerRadius = UDim.new(1, 0)
G.UICorner_73.Parent = G.Track_11

-- Knob_11 (Frame)
G.Knob_11 = Instance.new("Frame")
G.Knob_11.Name = "Knob"
G.Knob_11.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_11.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_11.BorderSizePixel = 0
G.Knob_11.Position = UDim2.new(1, -23, 0.5, 0)
G.Knob_11.Size = UDim2.new(0, 20, 0, 20)
G.Knob_11.ZIndex = 16
G.Knob_11.Parent = G.Track_11

-- UICorner_74 (UICorner)
G.UICorner_74 = Instance.new("UICorner")
G.UICorner_74.CornerRadius = UDim.new(1, 0)
G.UICorner_74.Parent = G.Knob_11

-- KnobStroke_11 (UIStroke)
G.KnobStroke_11 = Instance.new("UIStroke")
G.KnobStroke_11.Name = "KnobStroke"
G.KnobStroke_11.Thickness = 0.60000002384185791
G.KnobStroke_11.Transparency = 0.75
G.KnobStroke_11.Parent = G.Knob_11

-- ToggleHit_11 (TextButton)
G.ToggleHit_11 = Instance.new("TextButton")
G.ToggleHit_11.Name = "ToggleHit"
G.ToggleHit_11.BackgroundTransparency = 1
G.ToggleHit_11.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_11.ZIndex = 30
G.ToggleHit_11.AutoButtonColor = false
G.ToggleHit_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_11.Text = ""
G.ToggleHit_11.Parent = G.Frame_25

-- Frame_26 (Frame)
G.Frame_26 = Instance.new("Frame")
G.Frame_26.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_26.BackgroundTransparency = 0.079999998211860657
G.Frame_26.BorderSizePixel = 0
G.Frame_26.LayoutOrder = 11
G.Frame_26.Size = UDim2.new(1, -4, 0, 44)
G.Frame_26.ZIndex = 14
G.Frame_26.Parent = G.Combat

-- UICorner_75 (UICorner)
G.UICorner_75 = Instance.new("UICorner")
G.UICorner_75.CornerRadius = UDim.new(1, 0)
G.UICorner_75.Parent = G.Frame_26

-- UIStroke_40 (UIStroke)
G.UIStroke_40 = Instance.new("UIStroke")
G.UIStroke_40.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_40.Transparency = 0.5
G.UIStroke_40.Parent = G.Frame_26

-- TextLabel_24 (TextLabel)
G.TextLabel_24 = Instance.new("TextLabel")
G.TextLabel_24.BackgroundTransparency = 1
G.TextLabel_24.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_24.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_24.ZIndex = 15
G.TextLabel_24.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_24.Text = "TP BAT"
G.TextLabel_24.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_24.TextSize = 12
G.TextLabel_24.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_24.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_24.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_24.Parent = G.Frame_26

-- Track_12 (Frame)
G.Track_12 = Instance.new("Frame")
G.Track_12.Name = "Track"
G.Track_12.AnchorPoint = Vector2.new(1, 0.5)
G.Track_12.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_12.BorderSizePixel = 0
G.Track_12.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_12.Size = UDim2.new(0, 48, 0, 26)
G.Track_12.ZIndex = 15
G.Track_12.Parent = G.Frame_26

-- UICorner_76 (UICorner)
G.UICorner_76 = Instance.new("UICorner")
G.UICorner_76.CornerRadius = UDim.new(1, 0)
G.UICorner_76.Parent = G.Track_12

-- Knob_12 (Frame)
G.Knob_12 = Instance.new("Frame")
G.Knob_12.Name = "Knob"
G.Knob_12.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_12.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_12.BorderSizePixel = 0
G.Knob_12.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_12.Size = UDim2.new(0, 20, 0, 20)
G.Knob_12.ZIndex = 16
G.Knob_12.Parent = G.Track_12

-- UICorner_77 (UICorner)
G.UICorner_77 = Instance.new("UICorner")
G.UICorner_77.CornerRadius = UDim.new(1, 0)
G.UICorner_77.Parent = G.Knob_12

-- KnobStroke_12 (UIStroke)
G.KnobStroke_12 = Instance.new("UIStroke")
G.KnobStroke_12.Name = "KnobStroke"
G.KnobStroke_12.Thickness = 0.60000002384185791
G.KnobStroke_12.Transparency = 0.75
G.KnobStroke_12.Parent = G.Knob_12

-- ToggleHit_12 (TextButton)
G.ToggleHit_12 = Instance.new("TextButton")
G.ToggleHit_12.Name = "ToggleHit"
G.ToggleHit_12.BackgroundTransparency = 1
G.ToggleHit_12.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_12.ZIndex = 30
G.ToggleHit_12.AutoButtonColor = false
G.ToggleHit_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_12.Text = ""
G.ToggleHit_12.Parent = G.Frame_26

-- Frame_27 (Frame)
G.Frame_27 = Instance.new("Frame")
G.Frame_27.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_27.BackgroundTransparency = 0.029999999329447746
G.Frame_27.BorderSizePixel = 0
G.Frame_27.ClipsDescendants = true
G.Frame_27.LayoutOrder = 12
G.Frame_27.Size = UDim2.new(1, -4, 0, 44)
G.Frame_27.ZIndex = 14
G.Frame_27.Parent = G.Combat

-- UICorner_78 (UICorner)
G.UICorner_78 = Instance.new("UICorner")
G.UICorner_78.CornerRadius = UDim.new(0, 9)
G.UICorner_78.Parent = G.Frame_27

-- UIStroke_41 (UIStroke)
G.UIStroke_41 = Instance.new("UIStroke")
G.UIStroke_41.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_41.Transparency = 0.34999999403953552
G.UIStroke_41.Parent = G.Frame_27

-- TextLabel_25 (TextLabel)
G.TextLabel_25 = Instance.new("TextLabel")
G.TextLabel_25.BackgroundTransparency = 1
G.TextLabel_25.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_25.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_25.ZIndex = 16
G.TextLabel_25.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_25.Text = "Aimbot Mode"
G.TextLabel_25.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_25.TextSize = 12
G.TextLabel_25.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_25.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_25.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_25.Parent = G.Frame_27

-- DropdownCardGradient_4 (UIGradient)
G.DropdownCardGradient_4 = Instance.new("UIGradient")
G.DropdownCardGradient_4.Name = "DropdownCardGradient"
G.DropdownCardGradient_4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_4.Rotation = 90
G.DropdownCardGradient_4.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_4.Parent = G.Frame_27

-- DropdownSelector_4 (TextButton)
G.DropdownSelector_4 = Instance.new("TextButton")
G.DropdownSelector_4.Name = "DropdownSelector"
G.DropdownSelector_4.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_4.BorderSizePixel = 0
G.DropdownSelector_4.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_4.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_4.ZIndex = 18
G.DropdownSelector_4.AutoButtonColor = false
G.DropdownSelector_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_4.Text = "Normal  ▼"
G.DropdownSelector_4.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_4.TextSize = 11
G.DropdownSelector_4.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_4.Parent = G.Frame_27

-- UICorner_79 (UICorner)
G.UICorner_79 = Instance.new("UICorner")
G.UICorner_79.CornerRadius = UDim.new(0, 7)
G.UICorner_79.Parent = G.DropdownSelector_4

-- UIStroke_42 (UIStroke)
G.UIStroke_42 = Instance.new("UIStroke")
G.UIStroke_42.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_42.Transparency = 0.20000000298023224
G.UIStroke_42.Parent = G.DropdownSelector_4

-- DropdownChoices_4 (ScrollingFrame)
G.DropdownChoices_4 = Instance.new("ScrollingFrame")
G.DropdownChoices_4.Name = "DropdownChoices"
G.DropdownChoices_4.Active = true
G.DropdownChoices_4.BackgroundTransparency = 1
G.DropdownChoices_4.BorderSizePixel = 0
G.DropdownChoices_4.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_4.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_4.Visible = false
G.DropdownChoices_4.ZIndex = 17
G.DropdownChoices_4.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_4.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_4.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_4.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_4.ScrollBarThickness = 0
G.DropdownChoices_4.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_4.Parent = G.Frame_27

-- UIListLayout_6 (UIListLayout)
G.UIListLayout_6 = Instance.new("UIListLayout")
G.UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_6.Padding = UDim.new(0, 4)
G.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_6.Parent = G.DropdownChoices_4

-- Option1_4 (TextButton)
G.Option1_4 = Instance.new("TextButton")
G.Option1_4.Name = "Option1"
G.Option1_4.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_4.BorderSizePixel = 0
G.Option1_4.LayoutOrder = 1
G.Option1_4.Size = UDim2.new(1, -4, 0, 27)
G.Option1_4.ZIndex = 18
G.Option1_4.AutoButtonColor = false
G.Option1_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_4.Text = "Normal"
G.Option1_4.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_4.TextSize = 11
G.Option1_4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_4.Parent = G.DropdownChoices_4

-- UICorner_80 (UICorner)
G.UICorner_80 = Instance.new("UICorner")
G.UICorner_80.CornerRadius = UDim.new(0, 7)
G.UICorner_80.Parent = G.Option1_4

-- Option2_4 (TextButton)
G.Option2_4 = Instance.new("TextButton")
G.Option2_4.Name = "Option2"
G.Option2_4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_4.BorderSizePixel = 0
G.Option2_4.LayoutOrder = 2
G.Option2_4.Size = UDim2.new(1, -4, 0, 27)
G.Option2_4.ZIndex = 18
G.Option2_4.AutoButtonColor = false
G.Option2_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_4.Text = "Bypass"
G.Option2_4.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_4.TextSize = 11
G.Option2_4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_4.Parent = G.DropdownChoices_4

-- UICorner_81 (UICorner)
G.UICorner_81 = Instance.new("UICorner")
G.UICorner_81.CornerRadius = UDim.new(0, 7)
G.UICorner_81.Parent = G.Option2_4

-- SectionHeading_8 (TextLabel)
G.SectionHeading_8 = Instance.new("TextLabel")
G.SectionHeading_8.Name = "SectionHeading"
G.SectionHeading_8.BackgroundTransparency = 1
G.SectionHeading_8.LayoutOrder = 13
G.SectionHeading_8.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_8.ZIndex = 15
G.SectionHeading_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_8.Text = "COUNTERS"
G.SectionHeading_8.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_8.TextSize = 11
G.SectionHeading_8.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_8.Parent = G.Combat

-- Frame_28 (Frame)
G.Frame_28 = Instance.new("Frame")
G.Frame_28.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_28.BackgroundTransparency = 0.079999998211860657
G.Frame_28.BorderSizePixel = 0
G.Frame_28.LayoutOrder = 14
G.Frame_28.Size = UDim2.new(1, -4, 0, 44)
G.Frame_28.ZIndex = 14
G.Frame_28.Parent = G.Combat

-- UICorner_82 (UICorner)
G.UICorner_82 = Instance.new("UICorner")
G.UICorner_82.CornerRadius = UDim.new(1, 0)
G.UICorner_82.Parent = G.Frame_28

-- UIStroke_43 (UIStroke)
G.UIStroke_43 = Instance.new("UIStroke")
G.UIStroke_43.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_43.Transparency = 0.5
G.UIStroke_43.Parent = G.Frame_28

-- TextLabel_26 (TextLabel)
G.TextLabel_26 = Instance.new("TextLabel")
G.TextLabel_26.BackgroundTransparency = 1
G.TextLabel_26.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_26.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_26.ZIndex = 15
G.TextLabel_26.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_26.Text = "Bat Counter"
G.TextLabel_26.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_26.TextSize = 12
G.TextLabel_26.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_26.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_26.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_26.Parent = G.Frame_28

-- Track_13 (Frame)
G.Track_13 = Instance.new("Frame")
G.Track_13.Name = "Track"
G.Track_13.AnchorPoint = Vector2.new(1, 0.5)
G.Track_13.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_13.BorderSizePixel = 0
G.Track_13.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_13.Size = UDim2.new(0, 48, 0, 26)
G.Track_13.ZIndex = 15
G.Track_13.Parent = G.Frame_28

-- UICorner_83 (UICorner)
G.UICorner_83 = Instance.new("UICorner")
G.UICorner_83.CornerRadius = UDim.new(1, 0)
G.UICorner_83.Parent = G.Track_13

-- Knob_13 (Frame)
G.Knob_13 = Instance.new("Frame")
G.Knob_13.Name = "Knob"
G.Knob_13.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_13.BorderSizePixel = 0
G.Knob_13.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_13.Size = UDim2.new(0, 20, 0, 20)
G.Knob_13.ZIndex = 16
G.Knob_13.Parent = G.Track_13

-- UICorner_84 (UICorner)
G.UICorner_84 = Instance.new("UICorner")
G.UICorner_84.CornerRadius = UDim.new(1, 0)
G.UICorner_84.Parent = G.Knob_13

-- KnobStroke_13 (UIStroke)
G.KnobStroke_13 = Instance.new("UIStroke")
G.KnobStroke_13.Name = "KnobStroke"
G.KnobStroke_13.Thickness = 0.60000002384185791
G.KnobStroke_13.Transparency = 0.75
G.KnobStroke_13.Parent = G.Knob_13

-- ToggleHit_13 (TextButton)
G.ToggleHit_13 = Instance.new("TextButton")
G.ToggleHit_13.Name = "ToggleHit"
G.ToggleHit_13.BackgroundTransparency = 1
G.ToggleHit_13.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_13.ZIndex = 30
G.ToggleHit_13.AutoButtonColor = false
G.ToggleHit_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_13.Text = ""
G.ToggleHit_13.Parent = G.Frame_28

-- Frame_29 (Frame)
G.Frame_29 = Instance.new("Frame")
G.Frame_29.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_29.BackgroundTransparency = 0.079999998211860657
G.Frame_29.BorderSizePixel = 0
G.Frame_29.LayoutOrder = 15
G.Frame_29.Size = UDim2.new(1, -4, 0, 44)
G.Frame_29.ZIndex = 14
G.Frame_29.Parent = G.Combat

-- UICorner_85 (UICorner)
G.UICorner_85 = Instance.new("UICorner")
G.UICorner_85.CornerRadius = UDim.new(1, 0)
G.UICorner_85.Parent = G.Frame_29

-- UIStroke_44 (UIStroke)
G.UIStroke_44 = Instance.new("UIStroke")
G.UIStroke_44.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_44.Transparency = 0.5
G.UIStroke_44.Parent = G.Frame_29

-- TextLabel_27 (TextLabel)
G.TextLabel_27 = Instance.new("TextLabel")
G.TextLabel_27.BackgroundTransparency = 1
G.TextLabel_27.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_27.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_27.ZIndex = 15
G.TextLabel_27.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_27.Text = "Medusa Counter"
G.TextLabel_27.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_27.TextSize = 12
G.TextLabel_27.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_27.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_27.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_27.Parent = G.Frame_29

-- Track_14 (Frame)
G.Track_14 = Instance.new("Frame")
G.Track_14.Name = "Track"
G.Track_14.AnchorPoint = Vector2.new(1, 0.5)
G.Track_14.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_14.BorderSizePixel = 0
G.Track_14.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_14.Size = UDim2.new(0, 48, 0, 26)
G.Track_14.ZIndex = 15
G.Track_14.Parent = G.Frame_29

-- UICorner_86 (UICorner)
G.UICorner_86 = Instance.new("UICorner")
G.UICorner_86.CornerRadius = UDim.new(1, 0)
G.UICorner_86.Parent = G.Track_14

-- Knob_14 (Frame)
G.Knob_14 = Instance.new("Frame")
G.Knob_14.Name = "Knob"
G.Knob_14.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_14.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_14.BorderSizePixel = 0
G.Knob_14.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_14.Size = UDim2.new(0, 20, 0, 20)
G.Knob_14.ZIndex = 16
G.Knob_14.Parent = G.Track_14

-- UICorner_87 (UICorner)
G.UICorner_87 = Instance.new("UICorner")
G.UICorner_87.CornerRadius = UDim.new(1, 0)
G.UICorner_87.Parent = G.Knob_14

-- KnobStroke_14 (UIStroke)
G.KnobStroke_14 = Instance.new("UIStroke")
G.KnobStroke_14.Name = "KnobStroke"
G.KnobStroke_14.Thickness = 0.60000002384185791
G.KnobStroke_14.Transparency = 0.75
G.KnobStroke_14.Parent = G.Knob_14

-- ToggleHit_14 (TextButton)
G.ToggleHit_14 = Instance.new("TextButton")
G.ToggleHit_14.Name = "ToggleHit"
G.ToggleHit_14.BackgroundTransparency = 1
G.ToggleHit_14.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_14.ZIndex = 30
G.ToggleHit_14.AutoButtonColor = false
G.ToggleHit_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_14.Text = ""
G.ToggleHit_14.Parent = G.Frame_29

-- SectionHeading_9 (TextLabel)
G.SectionHeading_9 = Instance.new("TextLabel")
G.SectionHeading_9.Name = "SectionHeading"
G.SectionHeading_9.BackgroundTransparency = 1
G.SectionHeading_9.LayoutOrder = 16
G.SectionHeading_9.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_9.ZIndex = 15
G.SectionHeading_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_9.Text = "DEFENSE"
G.SectionHeading_9.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_9.TextSize = 11
G.SectionHeading_9.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_9.Parent = G.Combat

-- Frame_30 (Frame)
G.Frame_30 = Instance.new("Frame")
G.Frame_30.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_30.BackgroundTransparency = 0.079999998211860657
G.Frame_30.BorderSizePixel = 0
G.Frame_30.LayoutOrder = 17
G.Frame_30.Size = UDim2.new(1, -4, 0, 44)
G.Frame_30.ZIndex = 14
G.Frame_30.Parent = G.Combat

-- UICorner_88 (UICorner)
G.UICorner_88 = Instance.new("UICorner")
G.UICorner_88.CornerRadius = UDim.new(1, 0)
G.UICorner_88.Parent = G.Frame_30

-- UIStroke_45 (UIStroke)
G.UIStroke_45 = Instance.new("UIStroke")
G.UIStroke_45.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_45.Transparency = 0.5
G.UIStroke_45.Parent = G.Frame_30

-- TextLabel_28 (TextLabel)
G.TextLabel_28 = Instance.new("TextLabel")
G.TextLabel_28.BackgroundTransparency = 1
G.TextLabel_28.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_28.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_28.ZIndex = 15
G.TextLabel_28.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_28.Text = "Body Lock"
G.TextLabel_28.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_28.TextSize = 12
G.TextLabel_28.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_28.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_28.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_28.Parent = G.Frame_30

-- Track_15 (Frame)
G.Track_15 = Instance.new("Frame")
G.Track_15.Name = "Track"
G.Track_15.AnchorPoint = Vector2.new(1, 0.5)
G.Track_15.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_15.BorderSizePixel = 0
G.Track_15.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_15.Size = UDim2.new(0, 48, 0, 26)
G.Track_15.ZIndex = 15
G.Track_15.Parent = G.Frame_30

-- UICorner_89 (UICorner)
G.UICorner_89 = Instance.new("UICorner")
G.UICorner_89.CornerRadius = UDim.new(1, 0)
G.UICorner_89.Parent = G.Track_15

-- Knob_15 (Frame)
G.Knob_15 = Instance.new("Frame")
G.Knob_15.Name = "Knob"
G.Knob_15.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_15.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_15.BorderSizePixel = 0
G.Knob_15.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_15.Size = UDim2.new(0, 20, 0, 20)
G.Knob_15.ZIndex = 16
G.Knob_15.Parent = G.Track_15

-- UICorner_90 (UICorner)
G.UICorner_90 = Instance.new("UICorner")
G.UICorner_90.CornerRadius = UDim.new(1, 0)
G.UICorner_90.Parent = G.Knob_15

-- KnobStroke_15 (UIStroke)
G.KnobStroke_15 = Instance.new("UIStroke")
G.KnobStroke_15.Name = "KnobStroke"
G.KnobStroke_15.Thickness = 0.60000002384185791
G.KnobStroke_15.Transparency = 0.75
G.KnobStroke_15.Parent = G.Knob_15

-- ToggleHit_15 (TextButton)
G.ToggleHit_15 = Instance.new("TextButton")
G.ToggleHit_15.Name = "ToggleHit"
G.ToggleHit_15.BackgroundTransparency = 1
G.ToggleHit_15.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_15.ZIndex = 30
G.ToggleHit_15.AutoButtonColor = false
G.ToggleHit_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_15.Text = ""
G.ToggleHit_15.Parent = G.Frame_30

-- Frame_31 (Frame)
G.Frame_31 = Instance.new("Frame")
G.Frame_31.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_31.BackgroundTransparency = 0.079999998211860657
G.Frame_31.BorderSizePixel = 0
G.Frame_31.LayoutOrder = 18
G.Frame_31.Size = UDim2.new(1, -4, 0, 38)
G.Frame_31.ZIndex = 14
G.Frame_31.Parent = G.Combat

-- UICorner_91 (UICorner)
G.UICorner_91 = Instance.new("UICorner")
G.UICorner_91.CornerRadius = UDim.new(1, 0)
G.UICorner_91.Parent = G.Frame_31

-- UIStroke_46 (UIStroke)
G.UIStroke_46 = Instance.new("UIStroke")
G.UIStroke_46.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_46.Transparency = 0.5
G.UIStroke_46.Parent = G.Frame_31

-- TextLabel_29 (TextLabel)
G.TextLabel_29 = Instance.new("TextLabel")
G.TextLabel_29.BackgroundTransparency = 1
G.TextLabel_29.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_29.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_29.ZIndex = 15
G.TextLabel_29.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_29.Text = "Body Lock Range"
G.TextLabel_29.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_29.TextSize = 12
G.TextLabel_29.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_29.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_29.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_29.Parent = G.Frame_31

-- TextBox_8 (TextBox)
G.TextBox_8 = Instance.new("TextBox")
G.TextBox_8.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_8.BackgroundTransparency = 0.69999998807907104
G.TextBox_8.BorderSizePixel = 0
G.TextBox_8.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_8.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_8.ZIndex = 15
G.TextBox_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_8.Text = "20"
G.TextBox_8.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_8.TextSize = 11
G.TextBox_8.ClearTextOnFocus = false
G.TextBox_8:SetAttribute("PrintedLastValidValue", 20)
G.TextBox_8.Parent = G.Frame_31

-- UICorner_92 (UICorner)
G.UICorner_92 = Instance.new("UICorner")
G.UICorner_92.CornerRadius = UDim.new(0, 6)
G.UICorner_92.Parent = G.TextBox_8

-- UIStroke_47 (UIStroke)
G.UIStroke_47 = Instance.new("UIStroke")
G.UIStroke_47.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_47.Thickness = 1.2000000476837158
G.UIStroke_47.Transparency = 0.25
G.UIStroke_47.Parent = G.TextBox_8

-- Frame_32 (Frame)
G.Frame_32 = Instance.new("Frame")
G.Frame_32.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_32.BackgroundTransparency = 0.079999998211860657
G.Frame_32.BorderSizePixel = 0
G.Frame_32.LayoutOrder = 19
G.Frame_32.Size = UDim2.new(1, -4, 0, 44)
G.Frame_32.ZIndex = 14
G.Frame_32.Parent = G.Combat

-- UICorner_93 (UICorner)
G.UICorner_93 = Instance.new("UICorner")
G.UICorner_93.CornerRadius = UDim.new(1, 0)
G.UICorner_93.Parent = G.Frame_32

-- UIStroke_48 (UIStroke)
G.UIStroke_48 = Instance.new("UIStroke")
G.UIStroke_48.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_48.Transparency = 0.5
G.UIStroke_48.Parent = G.Frame_32

-- TextLabel_30 (TextLabel)
G.TextLabel_30 = Instance.new("TextLabel")
G.TextLabel_30.BackgroundTransparency = 1
G.TextLabel_30.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_30.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_30.ZIndex = 15
G.TextLabel_30.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_30.Text = "Safe Mode"
G.TextLabel_30.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_30.TextSize = 12
G.TextLabel_30.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_30.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_30.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_30.Parent = G.Frame_32

-- Track_16 (Frame)
G.Track_16 = Instance.new("Frame")
G.Track_16.Name = "Track"
G.Track_16.AnchorPoint = Vector2.new(1, 0.5)
G.Track_16.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_16.BorderSizePixel = 0
G.Track_16.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_16.Size = UDim2.new(0, 48, 0, 26)
G.Track_16.ZIndex = 15
G.Track_16.Parent = G.Frame_32

-- UICorner_94 (UICorner)
G.UICorner_94 = Instance.new("UICorner")
G.UICorner_94.CornerRadius = UDim.new(1, 0)
G.UICorner_94.Parent = G.Track_16

-- Knob_16 (Frame)
G.Knob_16 = Instance.new("Frame")
G.Knob_16.Name = "Knob"
G.Knob_16.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_16.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_16.BorderSizePixel = 0
G.Knob_16.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_16.Size = UDim2.new(0, 20, 0, 20)
G.Knob_16.ZIndex = 16
G.Knob_16.Parent = G.Track_16

-- UICorner_95 (UICorner)
G.UICorner_95 = Instance.new("UICorner")
G.UICorner_95.CornerRadius = UDim.new(1, 0)
G.UICorner_95.Parent = G.Knob_16

-- KnobStroke_16 (UIStroke)
G.KnobStroke_16 = Instance.new("UIStroke")
G.KnobStroke_16.Name = "KnobStroke"
G.KnobStroke_16.Thickness = 0.60000002384185791
G.KnobStroke_16.Transparency = 0.75
G.KnobStroke_16.Parent = G.Knob_16

-- ToggleHit_16 (TextButton)
G.ToggleHit_16 = Instance.new("TextButton")
G.ToggleHit_16.Name = "ToggleHit"
G.ToggleHit_16.BackgroundTransparency = 1
G.ToggleHit_16.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_16.ZIndex = 30
G.ToggleHit_16.AutoButtonColor = false
G.ToggleHit_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_16.Text = ""
G.ToggleHit_16.Parent = G.Frame_32

-- Frame_33 (Frame)
G.Frame_33 = Instance.new("Frame")
G.Frame_33.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_33.BackgroundTransparency = 0.079999998211860657
G.Frame_33.BorderSizePixel = 0
G.Frame_33.LayoutOrder = 20
G.Frame_33.Size = UDim2.new(1, -4, 0, 44)
G.Frame_33.ZIndex = 14
G.Frame_33.Parent = G.Combat

-- UICorner_96 (UICorner)
G.UICorner_96 = Instance.new("UICorner")
G.UICorner_96.CornerRadius = UDim.new(1, 0)
G.UICorner_96.Parent = G.Frame_33

-- UIStroke_49 (UIStroke)
G.UIStroke_49 = Instance.new("UIStroke")
G.UIStroke_49.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_49.Transparency = 0.5
G.UIStroke_49.Parent = G.Frame_33

-- TextLabel_31 (TextLabel)
G.TextLabel_31 = Instance.new("TextLabel")
G.TextLabel_31.BackgroundTransparency = 1
G.TextLabel_31.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_31.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_31.ZIndex = 15
G.TextLabel_31.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_31.Text = "No Player Collision"
G.TextLabel_31.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_31.TextSize = 12
G.TextLabel_31.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_31.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_31.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_31.Parent = G.Frame_33

-- Track_17 (Frame)
G.Track_17 = Instance.new("Frame")
G.Track_17.Name = "Track"
G.Track_17.AnchorPoint = Vector2.new(1, 0.5)
G.Track_17.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_17.BorderSizePixel = 0
G.Track_17.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_17.Size = UDim2.new(0, 48, 0, 26)
G.Track_17.ZIndex = 15
G.Track_17.Parent = G.Frame_33

-- UICorner_97 (UICorner)
G.UICorner_97 = Instance.new("UICorner")
G.UICorner_97.CornerRadius = UDim.new(1, 0)
G.UICorner_97.Parent = G.Track_17

-- Knob_17 (Frame)
G.Knob_17 = Instance.new("Frame")
G.Knob_17.Name = "Knob"
G.Knob_17.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_17.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_17.BorderSizePixel = 0
G.Knob_17.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_17.Size = UDim2.new(0, 20, 0, 20)
G.Knob_17.ZIndex = 16
G.Knob_17.Parent = G.Track_17

-- UICorner_98 (UICorner)
G.UICorner_98 = Instance.new("UICorner")
G.UICorner_98.CornerRadius = UDim.new(1, 0)
G.UICorner_98.Parent = G.Knob_17

-- KnobStroke_17 (UIStroke)
G.KnobStroke_17 = Instance.new("UIStroke")
G.KnobStroke_17.Name = "KnobStroke"
G.KnobStroke_17.Thickness = 0.60000002384185791
G.KnobStroke_17.Transparency = 0.75
G.KnobStroke_17.Parent = G.Knob_17

-- ToggleHit_17 (TextButton)
G.ToggleHit_17 = Instance.new("TextButton")
G.ToggleHit_17.Name = "ToggleHit"
G.ToggleHit_17.BackgroundTransparency = 1
G.ToggleHit_17.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_17.ZIndex = 30
G.ToggleHit_17.AutoButtonColor = false
G.ToggleHit_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_17.Text = ""
G.ToggleHit_17.Parent = G.Frame_33

-- SectionHeading_10 (TextLabel)
G.SectionHeading_10 = Instance.new("TextLabel")
G.SectionHeading_10.Name = "SectionHeading"
G.SectionHeading_10.BackgroundTransparency = 1
G.SectionHeading_10.LayoutOrder = 21
G.SectionHeading_10.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_10.ZIndex = 15
G.SectionHeading_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_10.Text = "SURVIVAL"
G.SectionHeading_10.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_10.TextSize = 11
G.SectionHeading_10.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_10.Parent = G.Combat

-- Frame_34 (Frame)
G.Frame_34 = Instance.new("Frame")
G.Frame_34.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_34.BackgroundTransparency = 0.029999999329447746
G.Frame_34.BorderSizePixel = 0
G.Frame_34.ClipsDescendants = true
G.Frame_34.LayoutOrder = 22
G.Frame_34.Size = UDim2.new(1, -4, 0, 44)
G.Frame_34.ZIndex = 14
G.Frame_34.Parent = G.Combat

-- UICorner_99 (UICorner)
G.UICorner_99 = Instance.new("UICorner")
G.UICorner_99.CornerRadius = UDim.new(0, 9)
G.UICorner_99.Parent = G.Frame_34

-- UIStroke_50 (UIStroke)
G.UIStroke_50 = Instance.new("UIStroke")
G.UIStroke_50.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_50.Transparency = 0.34999999403953552
G.UIStroke_50.Parent = G.Frame_34

-- TextLabel_32 (TextLabel)
G.TextLabel_32 = Instance.new("TextLabel")
G.TextLabel_32.BackgroundTransparency = 1
G.TextLabel_32.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_32.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_32.ZIndex = 16
G.TextLabel_32.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_32.Text = "Anti Ragdoll"
G.TextLabel_32.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_32.TextSize = 12
G.TextLabel_32.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_32.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_32.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_32.Parent = G.Frame_34

-- DropdownCardGradient_5 (UIGradient)
G.DropdownCardGradient_5 = Instance.new("UIGradient")
G.DropdownCardGradient_5.Name = "DropdownCardGradient"
G.DropdownCardGradient_5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_5.Rotation = 90
G.DropdownCardGradient_5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_5.Parent = G.Frame_34

-- DropdownSelector_5 (TextButton)
G.DropdownSelector_5 = Instance.new("TextButton")
G.DropdownSelector_5.Name = "DropdownSelector"
G.DropdownSelector_5.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_5.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_5.BorderSizePixel = 0
G.DropdownSelector_5.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_5.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_5.ZIndex = 18
G.DropdownSelector_5.AutoButtonColor = false
G.DropdownSelector_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_5.Text = "Off  ▼"
G.DropdownSelector_5.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_5.TextSize = 11
G.DropdownSelector_5.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_5.Parent = G.Frame_34

-- UICorner_100 (UICorner)
G.UICorner_100 = Instance.new("UICorner")
G.UICorner_100.CornerRadius = UDim.new(0, 7)
G.UICorner_100.Parent = G.DropdownSelector_5

-- UIStroke_51 (UIStroke)
G.UIStroke_51 = Instance.new("UIStroke")
G.UIStroke_51.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_51.Transparency = 0.20000000298023224
G.UIStroke_51.Parent = G.DropdownSelector_5

-- DropdownChoices_5 (ScrollingFrame)
G.DropdownChoices_5 = Instance.new("ScrollingFrame")
G.DropdownChoices_5.Name = "DropdownChoices"
G.DropdownChoices_5.Active = true
G.DropdownChoices_5.BackgroundTransparency = 1
G.DropdownChoices_5.BorderSizePixel = 0
G.DropdownChoices_5.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_5.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_5.Visible = false
G.DropdownChoices_5.ZIndex = 17
G.DropdownChoices_5.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_5.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_5.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_5.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_5.ScrollBarThickness = 0
G.DropdownChoices_5.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_5.Parent = G.Frame_34

-- UIListLayout_7 (UIListLayout)
G.UIListLayout_7 = Instance.new("UIListLayout")
G.UIListLayout_7.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_7.Padding = UDim.new(0, 4)
G.UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_7.Parent = G.DropdownChoices_5

-- Option1_5 (TextButton)
G.Option1_5 = Instance.new("TextButton")
G.Option1_5.Name = "Option1"
G.Option1_5.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_5.BorderSizePixel = 0
G.Option1_5.LayoutOrder = 1
G.Option1_5.Size = UDim2.new(1, -4, 0, 27)
G.Option1_5.ZIndex = 18
G.Option1_5.AutoButtonColor = false
G.Option1_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_5.Text = "Off"
G.Option1_5.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_5.TextSize = 11
G.Option1_5.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_5.Parent = G.DropdownChoices_5

-- UICorner_101 (UICorner)
G.UICorner_101 = Instance.new("UICorner")
G.UICorner_101.CornerRadius = UDim.new(0, 7)
G.UICorner_101.Parent = G.Option1_5

-- Option2_5 (TextButton)
G.Option2_5 = Instance.new("TextButton")
G.Option2_5.Name = "Option2"
G.Option2_5.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_5.BorderSizePixel = 0
G.Option2_5.LayoutOrder = 2
G.Option2_5.Size = UDim2.new(1, -4, 0, 27)
G.Option2_5.ZIndex = 18
G.Option2_5.AutoButtonColor = false
G.Option2_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_5.Text = "V1"
G.Option2_5.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_5.TextSize = 11
G.Option2_5.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_5.Parent = G.DropdownChoices_5

-- UICorner_102 (UICorner)
G.UICorner_102 = Instance.new("UICorner")
G.UICorner_102.CornerRadius = UDim.new(0, 7)
G.UICorner_102.Parent = G.Option2_5

-- Option3_2 (TextButton)
G.Option3_2 = Instance.new("TextButton")
G.Option3_2.Name = "Option3"
G.Option3_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option3_2.BorderSizePixel = 0
G.Option3_2.LayoutOrder = 3
G.Option3_2.Size = UDim2.new(1, -4, 0, 27)
G.Option3_2.ZIndex = 18
G.Option3_2.AutoButtonColor = false
G.Option3_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option3_2.Text = "V2"
G.Option3_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option3_2.TextSize = 11
G.Option3_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option3_2.Parent = G.DropdownChoices_5

-- UICorner_103 (UICorner)
G.UICorner_103 = Instance.new("UICorner")
G.UICorner_103.CornerRadius = UDim.new(0, 7)
G.UICorner_103.Parent = G.Option3_2

-- Frame_35 (Frame)
G.Frame_35 = Instance.new("Frame")
G.Frame_35.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_35.BackgroundTransparency = 0.079999998211860657
G.Frame_35.BorderSizePixel = 0
G.Frame_35.LayoutOrder = 23
G.Frame_35.Size = UDim2.new(1, -4, 0, 44)
G.Frame_35.ZIndex = 14
G.Frame_35.Parent = G.Combat

-- UICorner_104 (UICorner)
G.UICorner_104 = Instance.new("UICorner")
G.UICorner_104.CornerRadius = UDim.new(1, 0)
G.UICorner_104.Parent = G.Frame_35

-- UIStroke_52 (UIStroke)
G.UIStroke_52 = Instance.new("UIStroke")
G.UIStroke_52.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_52.Transparency = 0.5
G.UIStroke_52.Parent = G.Frame_35

-- TextLabel_33 (TextLabel)
G.TextLabel_33 = Instance.new("TextLabel")
G.TextLabel_33.BackgroundTransparency = 1
G.TextLabel_33.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_33.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_33.ZIndex = 15
G.TextLabel_33.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_33.Text = "Unwalk"
G.TextLabel_33.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_33.TextSize = 12
G.TextLabel_33.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_33.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_33.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_33.Parent = G.Frame_35

-- Track_18 (Frame)
G.Track_18 = Instance.new("Frame")
G.Track_18.Name = "Track"
G.Track_18.AnchorPoint = Vector2.new(1, 0.5)
G.Track_18.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_18.BorderSizePixel = 0
G.Track_18.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_18.Size = UDim2.new(0, 48, 0, 26)
G.Track_18.ZIndex = 15
G.Track_18.Parent = G.Frame_35

-- UICorner_105 (UICorner)
G.UICorner_105 = Instance.new("UICorner")
G.UICorner_105.CornerRadius = UDim.new(1, 0)
G.UICorner_105.Parent = G.Track_18

-- Knob_18 (Frame)
G.Knob_18 = Instance.new("Frame")
G.Knob_18.Name = "Knob"
G.Knob_18.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_18.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_18.BorderSizePixel = 0
G.Knob_18.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_18.Size = UDim2.new(0, 20, 0, 20)
G.Knob_18.ZIndex = 16
G.Knob_18.Parent = G.Track_18

-- UICorner_106 (UICorner)
G.UICorner_106 = Instance.new("UICorner")
G.UICorner_106.CornerRadius = UDim.new(1, 0)
G.UICorner_106.Parent = G.Knob_18

-- KnobStroke_18 (UIStroke)
G.KnobStroke_18 = Instance.new("UIStroke")
G.KnobStroke_18.Name = "KnobStroke"
G.KnobStroke_18.Thickness = 0.60000002384185791
G.KnobStroke_18.Transparency = 0.75
G.KnobStroke_18.Parent = G.Knob_18

-- ToggleHit_18 (TextButton)
G.ToggleHit_18 = Instance.new("TextButton")
G.ToggleHit_18.Name = "ToggleHit"
G.ToggleHit_18.BackgroundTransparency = 1
G.ToggleHit_18.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_18.ZIndex = 30
G.ToggleHit_18.AutoButtonColor = false
G.ToggleHit_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_18.Text = ""
G.ToggleHit_18.Parent = G.Frame_35

-- Frame_36 (Frame)
G.Frame_36 = Instance.new("Frame")
G.Frame_36.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_36.BackgroundTransparency = 0.079999998211860657
G.Frame_36.BorderSizePixel = 0
G.Frame_36.LayoutOrder = 24
G.Frame_36.Size = UDim2.new(1, -4, 0, 44)
G.Frame_36.ZIndex = 14
G.Frame_36.Parent = G.Combat

-- UICorner_107 (UICorner)
G.UICorner_107 = Instance.new("UICorner")
G.UICorner_107.CornerRadius = UDim.new(1, 0)
G.UICorner_107.Parent = G.Frame_36

-- UIStroke_53 (UIStroke)
G.UIStroke_53 = Instance.new("UIStroke")
G.UIStroke_53.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_53.Transparency = 0.5
G.UIStroke_53.Parent = G.Frame_36

-- TextLabel_34 (TextLabel)
G.TextLabel_34 = Instance.new("TextLabel")
G.TextLabel_34.BackgroundTransparency = 1
G.TextLabel_34.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_34.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_34.ZIndex = 15
G.TextLabel_34.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_34.Text = "Anti Die"
G.TextLabel_34.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_34.TextSize = 12
G.TextLabel_34.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_34.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_34.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_34.Parent = G.Frame_36

-- Track_19 (Frame)
G.Track_19 = Instance.new("Frame")
G.Track_19.Name = "Track"
G.Track_19.AnchorPoint = Vector2.new(1, 0.5)
G.Track_19.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_19.BorderSizePixel = 0
G.Track_19.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_19.Size = UDim2.new(0, 48, 0, 26)
G.Track_19.ZIndex = 15
G.Track_19.Parent = G.Frame_36

-- UICorner_108 (UICorner)
G.UICorner_108 = Instance.new("UICorner")
G.UICorner_108.CornerRadius = UDim.new(1, 0)
G.UICorner_108.Parent = G.Track_19

-- Knob_19 (Frame)
G.Knob_19 = Instance.new("Frame")
G.Knob_19.Name = "Knob"
G.Knob_19.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_19.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_19.BorderSizePixel = 0
G.Knob_19.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_19.Size = UDim2.new(0, 20, 0, 20)
G.Knob_19.ZIndex = 16
G.Knob_19.Parent = G.Track_19

-- UICorner_109 (UICorner)
G.UICorner_109 = Instance.new("UICorner")
G.UICorner_109.CornerRadius = UDim.new(1, 0)
G.UICorner_109.Parent = G.Knob_19

-- KnobStroke_19 (UIStroke)
G.KnobStroke_19 = Instance.new("UIStroke")
G.KnobStroke_19.Name = "KnobStroke"
G.KnobStroke_19.Thickness = 0.60000002384185791
G.KnobStroke_19.Transparency = 0.75
G.KnobStroke_19.Parent = G.Knob_19

-- ToggleHit_19 (TextButton)
G.ToggleHit_19 = Instance.new("TextButton")
G.ToggleHit_19.Name = "ToggleHit"
G.ToggleHit_19.BackgroundTransparency = 1
G.ToggleHit_19.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_19.ZIndex = 30
G.ToggleHit_19.AutoButtonColor = false
G.ToggleHit_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_19.Text = ""
G.ToggleHit_19.Parent = G.Frame_36

-- Steal (ScrollingFrame)
G.Steal = Instance.new("ScrollingFrame")
G.Steal.Name = "Steal"
G.Steal.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
G.Steal.BackgroundTransparency = 0.85000002384185791
G.Steal.BorderSizePixel = 0
G.Steal.Size = UDim2.new(1, 0, 1, 0)
G.Steal.ZIndex = 6
G.Steal.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Steal.CanvasPosition = Vector2.new(0, 100)
G.Steal.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Steal.ScrollBarImageColor3 = Color3.fromRGB(30, 30, 35)
G.Steal.ScrollBarImageTransparency = 0.30000001192092896
G.Steal.ScrollBarThickness = 2
G.Steal.ScrollingDirection = Enum.ScrollingDirection.Y
G.Steal.Parent = G.Frame_3

-- UICorner_110 (UICorner)
G.UICorner_110 = Instance.new("UICorner")
G.UICorner_110.CornerRadius = UDim.new(0, 16)
G.UICorner_110.Parent = G.Steal

-- UIListLayout_8 (UIListLayout)
G.UIListLayout_8 = Instance.new("UIListLayout")
G.UIListLayout_8.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_8.Padding = UDim.new(0, 6)
G.UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_8.Parent = G.Steal

-- UIPadding_3 (UIPadding)
G.UIPadding_3 = Instance.new("UIPadding")
G.UIPadding_3.PaddingBottom = UDim.new(0, 20)
G.UIPadding_3.PaddingLeft = UDim.new(0, 8)
G.UIPadding_3.PaddingRight = UDim.new(0, 8)
G.UIPadding_3.PaddingTop = UDim.new(0, 6)
G.UIPadding_3.Parent = G.Steal

-- SectionHeading_11 (TextLabel)
G.SectionHeading_11 = Instance.new("TextLabel")
G.SectionHeading_11.Name = "SectionHeading"
G.SectionHeading_11.BackgroundTransparency = 1
G.SectionHeading_11.LayoutOrder = 1
G.SectionHeading_11.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_11.ZIndex = 15
G.SectionHeading_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_11.Text = "AUTO CARRY SYSTEM"
G.SectionHeading_11.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_11.TextSize = 11
G.SectionHeading_11.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_11.Parent = G.Steal

-- Frame_37 (Frame)
G.Frame_37 = Instance.new("Frame")
G.Frame_37.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_37.BackgroundTransparency = 0.079999998211860657
G.Frame_37.BorderSizePixel = 0
G.Frame_37.LayoutOrder = 2
G.Frame_37.Size = UDim2.new(1, -4, 0, 44)
G.Frame_37.ZIndex = 14
G.Frame_37.Parent = G.Steal

-- UICorner_111 (UICorner)
G.UICorner_111 = Instance.new("UICorner")
G.UICorner_111.CornerRadius = UDim.new(1, 0)
G.UICorner_111.Parent = G.Frame_37

-- UIStroke_54 (UIStroke)
G.UIStroke_54 = Instance.new("UIStroke")
G.UIStroke_54.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_54.Transparency = 0.5
G.UIStroke_54.Parent = G.Frame_37

-- TextLabel_35 (TextLabel)
G.TextLabel_35 = Instance.new("TextLabel")
G.TextLabel_35.BackgroundTransparency = 1
G.TextLabel_35.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_35.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_35.ZIndex = 15
G.TextLabel_35.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_35.Text = "Auto Carry"
G.TextLabel_35.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_35.TextSize = 12
G.TextLabel_35.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_35.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_35.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_35.Parent = G.Frame_37

-- Track_20 (Frame)
G.Track_20 = Instance.new("Frame")
G.Track_20.Name = "Track"
G.Track_20.AnchorPoint = Vector2.new(1, 0.5)
G.Track_20.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_20.BorderSizePixel = 0
G.Track_20.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_20.Size = UDim2.new(0, 48, 0, 26)
G.Track_20.ZIndex = 15
G.Track_20.Parent = G.Frame_37

-- UICorner_112 (UICorner)
G.UICorner_112 = Instance.new("UICorner")
G.UICorner_112.CornerRadius = UDim.new(1, 0)
G.UICorner_112.Parent = G.Track_20

-- Knob_20 (Frame)
G.Knob_20 = Instance.new("Frame")
G.Knob_20.Name = "Knob"
G.Knob_20.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_20.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_20.BorderSizePixel = 0
G.Knob_20.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_20.Size = UDim2.new(0, 20, 0, 20)
G.Knob_20.ZIndex = 16
G.Knob_20.Parent = G.Track_20

-- UICorner_113 (UICorner)
G.UICorner_113 = Instance.new("UICorner")
G.UICorner_113.CornerRadius = UDim.new(1, 0)
G.UICorner_113.Parent = G.Knob_20

-- KnobStroke_20 (UIStroke)
G.KnobStroke_20 = Instance.new("UIStroke")
G.KnobStroke_20.Name = "KnobStroke"
G.KnobStroke_20.Thickness = 0.60000002384185791
G.KnobStroke_20.Transparency = 0.75
G.KnobStroke_20.Parent = G.Knob_20

-- ToggleHit_20 (TextButton)
G.ToggleHit_20 = Instance.new("TextButton")
G.ToggleHit_20.Name = "ToggleHit"
G.ToggleHit_20.BackgroundTransparency = 1
G.ToggleHit_20.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_20.ZIndex = 30
G.ToggleHit_20.AutoButtonColor = false
G.ToggleHit_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_20.Text = ""
G.ToggleHit_20.Parent = G.Frame_37

-- Frame_38 (Frame)
G.Frame_38 = Instance.new("Frame")
G.Frame_38.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_38.BackgroundTransparency = 0.079999998211860657
G.Frame_38.BorderSizePixel = 0
G.Frame_38.LayoutOrder = 3
G.Frame_38.Size = UDim2.new(1, -4, 0, 38)
G.Frame_38.ZIndex = 14
G.Frame_38.Parent = G.Steal

-- UICorner_114 (UICorner)
G.UICorner_114 = Instance.new("UICorner")
G.UICorner_114.CornerRadius = UDim.new(1, 0)
G.UICorner_114.Parent = G.Frame_38

-- UIStroke_55 (UIStroke)
G.UIStroke_55 = Instance.new("UIStroke")
G.UIStroke_55.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_55.Transparency = 0.5
G.UIStroke_55.Parent = G.Frame_38

-- TextLabel_36 (TextLabel)
G.TextLabel_36 = Instance.new("TextLabel")
G.TextLabel_36.BackgroundTransparency = 1
G.TextLabel_36.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_36.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_36.ZIndex = 15
G.TextLabel_36.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_36.Text = "Normal Speed"
G.TextLabel_36.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_36.TextSize = 12
G.TextLabel_36.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_36.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_36.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_36.Parent = G.Frame_38

-- TextBox_9 (TextBox)
G.TextBox_9 = Instance.new("TextBox")
G.TextBox_9.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_9.BackgroundTransparency = 0.69999998807907104
G.TextBox_9.BorderSizePixel = 0
G.TextBox_9.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_9.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_9.ZIndex = 15
G.TextBox_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_9.Text = "60"
G.TextBox_9.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_9.TextSize = 11
G.TextBox_9.ClearTextOnFocus = false
G.TextBox_9:SetAttribute("PrintedLastValidValue", 60)
G.TextBox_9.Parent = G.Frame_38

-- UICorner_115 (UICorner)
G.UICorner_115 = Instance.new("UICorner")
G.UICorner_115.CornerRadius = UDim.new(0, 6)
G.UICorner_115.Parent = G.TextBox_9

-- UIStroke_56 (UIStroke)
G.UIStroke_56 = Instance.new("UIStroke")
G.UIStroke_56.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_56.Thickness = 1.2000000476837158
G.UIStroke_56.Transparency = 0.25
G.UIStroke_56.Parent = G.TextBox_9

-- Frame_39 (Frame)
G.Frame_39 = Instance.new("Frame")
G.Frame_39.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_39.BackgroundTransparency = 0.079999998211860657
G.Frame_39.BorderSizePixel = 0
G.Frame_39.LayoutOrder = 4
G.Frame_39.Size = UDim2.new(1, -4, 0, 38)
G.Frame_39.ZIndex = 14
G.Frame_39.Parent = G.Steal

-- UICorner_116 (UICorner)
G.UICorner_116 = Instance.new("UICorner")
G.UICorner_116.CornerRadius = UDim.new(1, 0)
G.UICorner_116.Parent = G.Frame_39

-- UIStroke_57 (UIStroke)
G.UIStroke_57 = Instance.new("UIStroke")
G.UIStroke_57.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_57.Transparency = 0.5
G.UIStroke_57.Parent = G.Frame_39

-- TextLabel_37 (TextLabel)
G.TextLabel_37 = Instance.new("TextLabel")
G.TextLabel_37.BackgroundTransparency = 1
G.TextLabel_37.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_37.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_37.ZIndex = 15
G.TextLabel_37.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_37.Text = "Carry Speed"
G.TextLabel_37.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_37.TextSize = 12
G.TextLabel_37.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_37.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_37.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_37.Parent = G.Frame_39

-- TextBox_10 (TextBox)
G.TextBox_10 = Instance.new("TextBox")
G.TextBox_10.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_10.BackgroundTransparency = 0.69999998807907104
G.TextBox_10.BorderSizePixel = 0
G.TextBox_10.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_10.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_10.ZIndex = 15
G.TextBox_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_10.Text = "29"
G.TextBox_10.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_10.TextSize = 11
G.TextBox_10.ClearTextOnFocus = false
G.TextBox_10:SetAttribute("PrintedLastValidValue", 29)
G.TextBox_10.Parent = G.Frame_39

-- UICorner_117 (UICorner)
G.UICorner_117 = Instance.new("UICorner")
G.UICorner_117.CornerRadius = UDim.new(0, 6)
G.UICorner_117.Parent = G.TextBox_10

-- UIStroke_58 (UIStroke)
G.UIStroke_58 = Instance.new("UIStroke")
G.UIStroke_58.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_58.Thickness = 1.2000000476837158
G.UIStroke_58.Transparency = 0.25
G.UIStroke_58.Parent = G.TextBox_10

-- Frame_40 (Frame)
G.Frame_40 = Instance.new("Frame")
G.Frame_40.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_40.BackgroundTransparency = 0.079999998211860657
G.Frame_40.BorderSizePixel = 0
G.Frame_40.LayoutOrder = 5
G.Frame_40.Size = UDim2.new(1, -4, 0, 38)
G.Frame_40.ZIndex = 14
G.Frame_40.Parent = G.Steal

-- UICorner_118 (UICorner)
G.UICorner_118 = Instance.new("UICorner")
G.UICorner_118.CornerRadius = UDim.new(1, 0)
G.UICorner_118.Parent = G.Frame_40

-- UIStroke_59 (UIStroke)
G.UIStroke_59 = Instance.new("UIStroke")
G.UIStroke_59.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_59.Transparency = 0.5
G.UIStroke_59.Parent = G.Frame_40

-- TextLabel_38 (TextLabel)
G.TextLabel_38 = Instance.new("TextLabel")
G.TextLabel_38.BackgroundTransparency = 1
G.TextLabel_38.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_38.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_38.ZIndex = 15
G.TextLabel_38.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_38.Text = "Lagger Speed"
G.TextLabel_38.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_38.TextSize = 12
G.TextLabel_38.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_38.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_38.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_38.Parent = G.Frame_40

-- TextBox_11 (TextBox)
G.TextBox_11 = Instance.new("TextBox")
G.TextBox_11.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_11.BackgroundTransparency = 0.69999998807907104
G.TextBox_11.BorderSizePixel = 0
G.TextBox_11.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_11.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_11.ZIndex = 15
G.TextBox_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_11.Text = "15"
G.TextBox_11.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_11.TextSize = 11
G.TextBox_11.ClearTextOnFocus = false
G.TextBox_11:SetAttribute("PrintedLastValidValue", 15)
G.TextBox_11.Parent = G.Frame_40

-- UICorner_119 (UICorner)
G.UICorner_119 = Instance.new("UICorner")
G.UICorner_119.CornerRadius = UDim.new(0, 6)
G.UICorner_119.Parent = G.TextBox_11

-- UIStroke_60 (UIStroke)
G.UIStroke_60 = Instance.new("UIStroke")
G.UIStroke_60.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_60.Thickness = 1.2000000476837158
G.UIStroke_60.Transparency = 0.25
G.UIStroke_60.Parent = G.TextBox_11

-- Frame_41 (Frame)
G.Frame_41 = Instance.new("Frame")
G.Frame_41.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_41.BackgroundTransparency = 0.079999998211860657
G.Frame_41.BorderSizePixel = 0
G.Frame_41.LayoutOrder = 6
G.Frame_41.Size = UDim2.new(1, -4, 0, 38)
G.Frame_41.ZIndex = 14
G.Frame_41.Parent = G.Steal

-- UICorner_120 (UICorner)
G.UICorner_120 = Instance.new("UICorner")
G.UICorner_120.CornerRadius = UDim.new(1, 0)
G.UICorner_120.Parent = G.Frame_41

-- UIStroke_61 (UIStroke)
G.UIStroke_61 = Instance.new("UIStroke")
G.UIStroke_61.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_61.Transparency = 0.5
G.UIStroke_61.Parent = G.Frame_41

-- TextLabel_39 (TextLabel)
G.TextLabel_39 = Instance.new("TextLabel")
G.TextLabel_39.BackgroundTransparency = 1
G.TextLabel_39.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_39.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_39.ZIndex = 15
G.TextLabel_39.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_39.Text = "Lagger Carry Spd"
G.TextLabel_39.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_39.TextSize = 12
G.TextLabel_39.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_39.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_39.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_39.Parent = G.Frame_41

-- TextBox_12 (TextBox)
G.TextBox_12 = Instance.new("TextBox")
G.TextBox_12.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_12.BackgroundTransparency = 0.69999998807907104
G.TextBox_12.BorderSizePixel = 0
G.TextBox_12.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_12.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_12.ZIndex = 15
G.TextBox_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_12.Text = "24.5"
G.TextBox_12.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_12.TextSize = 11
G.TextBox_12.ClearTextOnFocus = false
G.TextBox_12:SetAttribute("PrintedLastValidValue", 24.5)
G.TextBox_12.Parent = G.Frame_41

-- UICorner_121 (UICorner)
G.UICorner_121 = Instance.new("UICorner")
G.UICorner_121.CornerRadius = UDim.new(0, 6)
G.UICorner_121.Parent = G.TextBox_12

-- UIStroke_62 (UIStroke)
G.UIStroke_62 = Instance.new("UIStroke")
G.UIStroke_62.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_62.Thickness = 1.2000000476837158
G.UIStroke_62.Transparency = 0.25
G.UIStroke_62.Parent = G.TextBox_12

-- Frame_42 (Frame)
G.Frame_42 = Instance.new("Frame")
G.Frame_42.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_42.BackgroundTransparency = 0.079999998211860657
G.Frame_42.BorderSizePixel = 0
G.Frame_42.LayoutOrder = 7
G.Frame_42.Size = UDim2.new(1, -4, 0, 38)
G.Frame_42.ZIndex = 14
G.Frame_42.Parent = G.Steal

-- UICorner_122 (UICorner)
G.UICorner_122 = Instance.new("UICorner")
G.UICorner_122.CornerRadius = UDim.new(1, 0)
G.UICorner_122.Parent = G.Frame_42

-- UIStroke_63 (UIStroke)
G.UIStroke_63 = Instance.new("UIStroke")
G.UIStroke_63.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_63.Transparency = 0.5
G.UIStroke_63.Parent = G.Frame_42

-- TextLabel_40 (TextLabel)
G.TextLabel_40 = Instance.new("TextLabel")
G.TextLabel_40.BackgroundTransparency = 1
G.TextLabel_40.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_40.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_40.ZIndex = 15
G.TextLabel_40.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_40.Text = "Soft Steal Speed"
G.TextLabel_40.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_40.TextSize = 12
G.TextLabel_40.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_40.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_40.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_40.Parent = G.Frame_42

-- TextBox_13 (TextBox)
G.TextBox_13 = Instance.new("TextBox")
G.TextBox_13.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_13.BackgroundTransparency = 0.69999998807907104
G.TextBox_13.BorderSizePixel = 0
G.TextBox_13.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_13.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_13.ZIndex = 15
G.TextBox_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_13.Text = "30"
G.TextBox_13.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_13.TextSize = 11
G.TextBox_13.ClearTextOnFocus = false
G.TextBox_13:SetAttribute("PrintedLastValidValue", 30)
G.TextBox_13.Parent = G.Frame_42

-- UICorner_123 (UICorner)
G.UICorner_123 = Instance.new("UICorner")
G.UICorner_123.CornerRadius = UDim.new(0, 6)
G.UICorner_123.Parent = G.TextBox_13

-- UIStroke_64 (UIStroke)
G.UIStroke_64 = Instance.new("UIStroke")
G.UIStroke_64.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_64.Thickness = 1.2000000476837158
G.UIStroke_64.Transparency = 0.25
G.UIStroke_64.Parent = G.TextBox_13

-- Frame_43 (Frame)
G.Frame_43 = Instance.new("Frame")
G.Frame_43.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_43.BackgroundTransparency = 0.079999998211860657
G.Frame_43.BorderSizePixel = 0
G.Frame_43.LayoutOrder = 8
G.Frame_43.Size = UDim2.new(1, -4, 0, 38)
G.Frame_43.ZIndex = 14
G.Frame_43.Parent = G.Steal

-- UICorner_124 (UICorner)
G.UICorner_124 = Instance.new("UICorner")
G.UICorner_124.CornerRadius = UDim.new(1, 0)
G.UICorner_124.Parent = G.Frame_43

-- UIStroke_65 (UIStroke)
G.UIStroke_65 = Instance.new("UIStroke")
G.UIStroke_65.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_65.Transparency = 0.5
G.UIStroke_65.Parent = G.Frame_43

-- TextLabel_41 (TextLabel)
G.TextLabel_41 = Instance.new("TextLabel")
G.TextLabel_41.BackgroundTransparency = 1
G.TextLabel_41.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_41.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_41.ZIndex = 15
G.TextLabel_41.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_41.Text = "Soft Steal Radius"
G.TextLabel_41.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_41.TextSize = 12
G.TextLabel_41.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_41.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_41.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_41.Parent = G.Frame_43

-- TextBox_14 (TextBox)
G.TextBox_14 = Instance.new("TextBox")
G.TextBox_14.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_14.BackgroundTransparency = 0.69999998807907104
G.TextBox_14.BorderSizePixel = 0
G.TextBox_14.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_14.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_14.ZIndex = 15
G.TextBox_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_14.Text = "10"
G.TextBox_14.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_14.TextSize = 11
G.TextBox_14.ClearTextOnFocus = false
G.TextBox_14:SetAttribute("PrintedLastValidValue", 10)
G.TextBox_14.Parent = G.Frame_43

-- UICorner_125 (UICorner)
G.UICorner_125 = Instance.new("UICorner")
G.UICorner_125.CornerRadius = UDim.new(0, 6)
G.UICorner_125.Parent = G.TextBox_14

-- UIStroke_66 (UIStroke)
G.UIStroke_66 = Instance.new("UIStroke")
G.UIStroke_66.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_66.Thickness = 1.2000000476837158
G.UIStroke_66.Transparency = 0.25
G.UIStroke_66.Parent = G.TextBox_14

-- SectionHeading_12 (TextLabel)
G.SectionHeading_12 = Instance.new("TextLabel")
G.SectionHeading_12.Name = "SectionHeading"
G.SectionHeading_12.BackgroundTransparency = 1
G.SectionHeading_12.LayoutOrder = 9
G.SectionHeading_12.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_12.ZIndex = 15
G.SectionHeading_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_12.Text = "AUTO STEAL"
G.SectionHeading_12.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_12.TextSize = 11
G.SectionHeading_12.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_12.Parent = G.Steal

-- Frame_44 (Frame)
G.Frame_44 = Instance.new("Frame")
G.Frame_44.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_44.BackgroundTransparency = 0.079999998211860657
G.Frame_44.BorderSizePixel = 0
G.Frame_44.LayoutOrder = 10
G.Frame_44.Size = UDim2.new(1, -4, 0, 44)
G.Frame_44.ZIndex = 14
G.Frame_44.Parent = G.Steal

-- UICorner_126 (UICorner)
G.UICorner_126 = Instance.new("UICorner")
G.UICorner_126.CornerRadius = UDim.new(1, 0)
G.UICorner_126.Parent = G.Frame_44

-- UIStroke_67 (UIStroke)
G.UIStroke_67 = Instance.new("UIStroke")
G.UIStroke_67.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_67.Transparency = 0.5
G.UIStroke_67.Parent = G.Frame_44

-- TextLabel_42 (TextLabel)
G.TextLabel_42 = Instance.new("TextLabel")
G.TextLabel_42.BackgroundTransparency = 1
G.TextLabel_42.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_42.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_42.ZIndex = 15
G.TextLabel_42.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_42.Text = "Auto Steal"
G.TextLabel_42.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_42.TextSize = 12
G.TextLabel_42.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_42.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_42.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_42.Parent = G.Frame_44

-- Track_21 (Frame)
G.Track_21 = Instance.new("Frame")
G.Track_21.Name = "Track"
G.Track_21.AnchorPoint = Vector2.new(1, 0.5)
G.Track_21.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Track_21.BorderSizePixel = 0
G.Track_21.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_21.Size = UDim2.new(0, 48, 0, 26)
G.Track_21.ZIndex = 15
G.Track_21.Parent = G.Frame_44

-- UICorner_127 (UICorner)
G.UICorner_127 = Instance.new("UICorner")
G.UICorner_127.CornerRadius = UDim.new(1, 0)
G.UICorner_127.Parent = G.Track_21

-- Knob_21 (Frame)
G.Knob_21 = Instance.new("Frame")
G.Knob_21.Name = "Knob"
G.Knob_21.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_21.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_21.BorderSizePixel = 0
G.Knob_21.Position = UDim2.new(1, -23, 0.5, 0)
G.Knob_21.Size = UDim2.new(0, 20, 0, 20)
G.Knob_21.ZIndex = 16
G.Knob_21.Parent = G.Track_21

-- UICorner_128 (UICorner)
G.UICorner_128 = Instance.new("UICorner")
G.UICorner_128.CornerRadius = UDim.new(1, 0)
G.UICorner_128.Parent = G.Knob_21

-- KnobStroke_21 (UIStroke)
G.KnobStroke_21 = Instance.new("UIStroke")
G.KnobStroke_21.Name = "KnobStroke"
G.KnobStroke_21.Thickness = 0.60000002384185791
G.KnobStroke_21.Transparency = 0.75
G.KnobStroke_21.Parent = G.Knob_21

-- ToggleHit_21 (TextButton)
G.ToggleHit_21 = Instance.new("TextButton")
G.ToggleHit_21.Name = "ToggleHit"
G.ToggleHit_21.BackgroundTransparency = 1
G.ToggleHit_21.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_21.ZIndex = 30
G.ToggleHit_21.AutoButtonColor = false
G.ToggleHit_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_21.Text = ""
G.ToggleHit_21.Parent = G.Frame_44

-- Frame_45 (Frame)
G.Frame_45 = Instance.new("Frame")
G.Frame_45.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_45.BackgroundTransparency = 0.079999998211860657
G.Frame_45.BorderSizePixel = 0
G.Frame_45.LayoutOrder = 11
G.Frame_45.Size = UDim2.new(1, -4, 0, 38)
G.Frame_45.ZIndex = 14
G.Frame_45.Parent = G.Steal

-- UICorner_129 (UICorner)
G.UICorner_129 = Instance.new("UICorner")
G.UICorner_129.CornerRadius = UDim.new(1, 0)
G.UICorner_129.Parent = G.Frame_45

-- UIStroke_68 (UIStroke)
G.UIStroke_68 = Instance.new("UIStroke")
G.UIStroke_68.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_68.Transparency = 0.5
G.UIStroke_68.Parent = G.Frame_45

-- TextLabel_43 (TextLabel)
G.TextLabel_43 = Instance.new("TextLabel")
G.TextLabel_43.BackgroundTransparency = 1
G.TextLabel_43.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_43.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_43.ZIndex = 15
G.TextLabel_43.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_43.Text = "Steal Radius"
G.TextLabel_43.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_43.TextSize = 12
G.TextLabel_43.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_43.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_43.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_43.Parent = G.Frame_45

-- TextBox_15 (TextBox)
G.TextBox_15 = Instance.new("TextBox")
G.TextBox_15.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_15.BackgroundTransparency = 0.69999998807907104
G.TextBox_15.BorderSizePixel = 0
G.TextBox_15.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_15.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_15.ZIndex = 15
G.TextBox_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_15.Text = "61"
G.TextBox_15.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_15.TextSize = 11
G.TextBox_15.ClearTextOnFocus = false
G.TextBox_15:SetAttribute("PrintedLastValidValue", 61)
G.TextBox_15.Parent = G.Frame_45

-- UICorner_130 (UICorner)
G.UICorner_130 = Instance.new("UICorner")
G.UICorner_130.CornerRadius = UDim.new(0, 6)
G.UICorner_130.Parent = G.TextBox_15

-- UIStroke_69 (UIStroke)
G.UIStroke_69 = Instance.new("UIStroke")
G.UIStroke_69.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_69.Thickness = 1.2000000476837158
G.UIStroke_69.Transparency = 0.25
G.UIStroke_69.Parent = G.TextBox_15

-- Frame_46 (Frame)
G.Frame_46 = Instance.new("Frame")
G.Frame_46.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_46.BackgroundTransparency = 0.029999999329447746
G.Frame_46.BorderSizePixel = 0
G.Frame_46.ClipsDescendants = true
G.Frame_46.LayoutOrder = 12
G.Frame_46.Size = UDim2.new(1, -4, 0, 44)
G.Frame_46.ZIndex = 14
G.Frame_46.Parent = G.Steal

-- UICorner_131 (UICorner)
G.UICorner_131 = Instance.new("UICorner")
G.UICorner_131.CornerRadius = UDim.new(0, 9)
G.UICorner_131.Parent = G.Frame_46

-- UIStroke_70 (UIStroke)
G.UIStroke_70 = Instance.new("UIStroke")
G.UIStroke_70.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_70.Transparency = 0.34999999403953552
G.UIStroke_70.Parent = G.Frame_46

-- TextLabel_44 (TextLabel)
G.TextLabel_44 = Instance.new("TextLabel")
G.TextLabel_44.BackgroundTransparency = 1
G.TextLabel_44.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_44.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_44.ZIndex = 16
G.TextLabel_44.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_44.Text = "Grab Mode"
G.TextLabel_44.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_44.TextSize = 12
G.TextLabel_44.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_44.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_44.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_44.Parent = G.Frame_46

-- DropdownCardGradient_6 (UIGradient)
G.DropdownCardGradient_6 = Instance.new("UIGradient")
G.DropdownCardGradient_6.Name = "DropdownCardGradient"
G.DropdownCardGradient_6.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_6.Rotation = 90
G.DropdownCardGradient_6.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_6.Parent = G.Frame_46

-- DropdownSelector_6 (TextButton)
G.DropdownSelector_6 = Instance.new("TextButton")
G.DropdownSelector_6.Name = "DropdownSelector"
G.DropdownSelector_6.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_6.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_6.BorderSizePixel = 0
G.DropdownSelector_6.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_6.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_6.ZIndex = 18
G.DropdownSelector_6.AutoButtonColor = false
G.DropdownSelector_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_6.Text = "Normal  ▼"
G.DropdownSelector_6.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_6.TextSize = 11
G.DropdownSelector_6.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_6.Parent = G.Frame_46

-- UICorner_132 (UICorner)
G.UICorner_132 = Instance.new("UICorner")
G.UICorner_132.CornerRadius = UDim.new(0, 7)
G.UICorner_132.Parent = G.DropdownSelector_6

-- UIStroke_71 (UIStroke)
G.UIStroke_71 = Instance.new("UIStroke")
G.UIStroke_71.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_71.Transparency = 0.20000000298023224
G.UIStroke_71.Parent = G.DropdownSelector_6

-- DropdownChoices_6 (ScrollingFrame)
G.DropdownChoices_6 = Instance.new("ScrollingFrame")
G.DropdownChoices_6.Name = "DropdownChoices"
G.DropdownChoices_6.Active = true
G.DropdownChoices_6.BackgroundTransparency = 1
G.DropdownChoices_6.BorderSizePixel = 0
G.DropdownChoices_6.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_6.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_6.Visible = false
G.DropdownChoices_6.ZIndex = 17
G.DropdownChoices_6.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_6.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_6.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_6.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_6.ScrollBarThickness = 0
G.DropdownChoices_6.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_6.Parent = G.Frame_46

-- UIListLayout_9 (UIListLayout)
G.UIListLayout_9 = Instance.new("UIListLayout")
G.UIListLayout_9.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_9.Padding = UDim.new(0, 4)
G.UIListLayout_9.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_9.Parent = G.DropdownChoices_6

-- Option1_6 (TextButton)
G.Option1_6 = Instance.new("TextButton")
G.Option1_6.Name = "Option1"
G.Option1_6.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_6.BorderSizePixel = 0
G.Option1_6.LayoutOrder = 1
G.Option1_6.Size = UDim2.new(1, -4, 0, 27)
G.Option1_6.ZIndex = 18
G.Option1_6.AutoButtonColor = false
G.Option1_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_6.Text = "Normal"
G.Option1_6.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_6.TextSize = 11
G.Option1_6.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_6.Parent = G.DropdownChoices_6

-- UICorner_133 (UICorner)
G.UICorner_133 = Instance.new("UICorner")
G.UICorner_133.CornerRadius = UDim.new(0, 7)
G.UICorner_133.Parent = G.Option1_6

-- Option2_6 (TextButton)
G.Option2_6 = Instance.new("TextButton")
G.Option2_6.Name = "Option2"
G.Option2_6.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_6.BorderSizePixel = 0
G.Option2_6.LayoutOrder = 2
G.Option2_6.Size = UDim2.new(1, -4, 0, 27)
G.Option2_6.ZIndex = 18
G.Option2_6.AutoButtonColor = false
G.Option2_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_6.Text = "Semi"
G.Option2_6.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_6.TextSize = 11
G.Option2_6.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_6.Parent = G.DropdownChoices_6

-- UICorner_134 (UICorner)
G.UICorner_134 = Instance.new("UICorner")
G.UICorner_134.CornerRadius = UDim.new(0, 7)
G.UICorner_134.Parent = G.Option2_6

-- Visuals (ScrollingFrame)
G.Visuals = Instance.new("ScrollingFrame")
G.Visuals.Name = "Visuals"
G.Visuals.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
G.Visuals.BackgroundTransparency = 0.85000002384185791
G.Visuals.BorderSizePixel = 0
G.Visuals.Size = UDim2.new(1, 0, 1, 0)
G.Visuals.Visible = false
G.Visuals.ZIndex = 6
G.Visuals.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Visuals.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Visuals.ScrollBarImageColor3 = Color3.fromRGB(30, 30, 35)
G.Visuals.ScrollBarImageTransparency = 0.30000001192092896
G.Visuals.ScrollBarThickness = 2
G.Visuals.ScrollingDirection = Enum.ScrollingDirection.Y
G.Visuals.Parent = G.Frame_3

-- UICorner_135 (UICorner)
G.UICorner_135 = Instance.new("UICorner")
G.UICorner_135.CornerRadius = UDim.new(0, 16)
G.UICorner_135.Parent = G.Visuals

-- UIListLayout_10 (UIListLayout)
G.UIListLayout_10 = Instance.new("UIListLayout")
G.UIListLayout_10.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_10.Padding = UDim.new(0, 6)
G.UIListLayout_10.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_10.Parent = G.Visuals

-- UIPadding_4 (UIPadding)
G.UIPadding_4 = Instance.new("UIPadding")
G.UIPadding_4.PaddingBottom = UDim.new(0, 20)
G.UIPadding_4.PaddingLeft = UDim.new(0, 8)
G.UIPadding_4.PaddingRight = UDim.new(0, 8)
G.UIPadding_4.PaddingTop = UDim.new(0, 6)
G.UIPadding_4.Parent = G.Visuals

-- Frame_47 (Frame)
G.Frame_47 = Instance.new("Frame")
G.Frame_47.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_47.BackgroundTransparency = 0.079999998211860657
G.Frame_47.BorderSizePixel = 0
G.Frame_47.LayoutOrder = 1
G.Frame_47.Size = UDim2.new(1, -4, 0, 44)
G.Frame_47.ZIndex = 14
G.Frame_47.Parent = G.Visuals

-- UICorner_136 (UICorner)
G.UICorner_136 = Instance.new("UICorner")
G.UICorner_136.CornerRadius = UDim.new(1, 0)
G.UICorner_136.Parent = G.Frame_47

-- UIStroke_72 (UIStroke)
G.UIStroke_72 = Instance.new("UIStroke")
G.UIStroke_72.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_72.Transparency = 0.5
G.UIStroke_72.Parent = G.Frame_47

-- TextLabel_45 (TextLabel)
G.TextLabel_45 = Instance.new("TextLabel")
G.TextLabel_45.BackgroundTransparency = 1
G.TextLabel_45.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_45.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_45.ZIndex = 15
G.TextLabel_45.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_45.Text = "Player ESP"
G.TextLabel_45.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_45.TextSize = 12
G.TextLabel_45.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_45.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_45.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_45.Parent = G.Frame_47

-- Track_22 (Frame)
G.Track_22 = Instance.new("Frame")
G.Track_22.Name = "Track"
G.Track_22.AnchorPoint = Vector2.new(1, 0.5)
G.Track_22.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_22.BorderSizePixel = 0
G.Track_22.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_22.Size = UDim2.new(0, 48, 0, 26)
G.Track_22.ZIndex = 15
G.Track_22.Parent = G.Frame_47

-- UICorner_137 (UICorner)
G.UICorner_137 = Instance.new("UICorner")
G.UICorner_137.CornerRadius = UDim.new(1, 0)
G.UICorner_137.Parent = G.Track_22

-- Knob_22 (Frame)
G.Knob_22 = Instance.new("Frame")
G.Knob_22.Name = "Knob"
G.Knob_22.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_22.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_22.BorderSizePixel = 0
G.Knob_22.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_22.Size = UDim2.new(0, 20, 0, 20)
G.Knob_22.ZIndex = 16
G.Knob_22.Parent = G.Track_22

-- UICorner_138 (UICorner)
G.UICorner_138 = Instance.new("UICorner")
G.UICorner_138.CornerRadius = UDim.new(1, 0)
G.UICorner_138.Parent = G.Knob_22

-- KnobStroke_22 (UIStroke)
G.KnobStroke_22 = Instance.new("UIStroke")
G.KnobStroke_22.Name = "KnobStroke"
G.KnobStroke_22.Thickness = 0.60000002384185791
G.KnobStroke_22.Transparency = 0.75
G.KnobStroke_22.Parent = G.Knob_22

-- ToggleHit_22 (TextButton)
G.ToggleHit_22 = Instance.new("TextButton")
G.ToggleHit_22.Name = "ToggleHit"
G.ToggleHit_22.BackgroundTransparency = 1
G.ToggleHit_22.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_22.ZIndex = 30
G.ToggleHit_22.AutoButtonColor = false
G.ToggleHit_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_22.Text = ""
G.ToggleHit_22.Parent = G.Frame_47

-- SectionHeading_13 (TextLabel)
G.SectionHeading_13 = Instance.new("TextLabel")
G.SectionHeading_13.Name = "SectionHeading"
G.SectionHeading_13.BackgroundTransparency = 1
G.SectionHeading_13.LayoutOrder = 2
G.SectionHeading_13.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_13.ZIndex = 15
G.SectionHeading_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_13.Text = "CAMERA"
G.SectionHeading_13.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_13.TextSize = 11
G.SectionHeading_13.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_13.Parent = G.Visuals

-- Frame_48 (Frame)
G.Frame_48 = Instance.new("Frame")
G.Frame_48.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_48.BackgroundTransparency = 0.079999998211860657
G.Frame_48.BorderSizePixel = 0
G.Frame_48.LayoutOrder = 3
G.Frame_48.Size = UDim2.new(1, -4, 0, 44)
G.Frame_48.ZIndex = 14
G.Frame_48.Parent = G.Visuals

-- UICorner_139 (UICorner)
G.UICorner_139 = Instance.new("UICorner")
G.UICorner_139.CornerRadius = UDim.new(1, 0)
G.UICorner_139.Parent = G.Frame_48

-- UIStroke_73 (UIStroke)
G.UIStroke_73 = Instance.new("UIStroke")
G.UIStroke_73.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_73.Transparency = 0.5
G.UIStroke_73.Parent = G.Frame_48

-- TextLabel_46 (TextLabel)
G.TextLabel_46 = Instance.new("TextLabel")
G.TextLabel_46.BackgroundTransparency = 1
G.TextLabel_46.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_46.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_46.ZIndex = 15
G.TextLabel_46.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_46.Text = "No Cam Collision"
G.TextLabel_46.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_46.TextSize = 12
G.TextLabel_46.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_46.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_46.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_46.Parent = G.Frame_48

-- Track_23 (Frame)
G.Track_23 = Instance.new("Frame")
G.Track_23.Name = "Track"
G.Track_23.AnchorPoint = Vector2.new(1, 0.5)
G.Track_23.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_23.BorderSizePixel = 0
G.Track_23.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_23.Size = UDim2.new(0, 48, 0, 26)
G.Track_23.ZIndex = 15
G.Track_23.Parent = G.Frame_48

-- UICorner_140 (UICorner)
G.UICorner_140 = Instance.new("UICorner")
G.UICorner_140.CornerRadius = UDim.new(1, 0)
G.UICorner_140.Parent = G.Track_23

-- Knob_23 (Frame)
G.Knob_23 = Instance.new("Frame")
G.Knob_23.Name = "Knob"
G.Knob_23.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_23.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_23.BorderSizePixel = 0
G.Knob_23.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_23.Size = UDim2.new(0, 20, 0, 20)
G.Knob_23.ZIndex = 16
G.Knob_23.Parent = G.Track_23

-- UICorner_141 (UICorner)
G.UICorner_141 = Instance.new("UICorner")
G.UICorner_141.CornerRadius = UDim.new(1, 0)
G.UICorner_141.Parent = G.Knob_23

-- KnobStroke_23 (UIStroke)
G.KnobStroke_23 = Instance.new("UIStroke")
G.KnobStroke_23.Name = "KnobStroke"
G.KnobStroke_23.Thickness = 0.60000002384185791
G.KnobStroke_23.Transparency = 0.75
G.KnobStroke_23.Parent = G.Knob_23

-- ToggleHit_23 (TextButton)
G.ToggleHit_23 = Instance.new("TextButton")
G.ToggleHit_23.Name = "ToggleHit"
G.ToggleHit_23.BackgroundTransparency = 1
G.ToggleHit_23.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_23.ZIndex = 30
G.ToggleHit_23.AutoButtonColor = false
G.ToggleHit_23.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_23.Text = ""
G.ToggleHit_23.Parent = G.Frame_48

-- Frame_49 (Frame)
G.Frame_49 = Instance.new("Frame")
G.Frame_49.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_49.BackgroundTransparency = 0.079999998211860657
G.Frame_49.BorderSizePixel = 0
G.Frame_49.LayoutOrder = 4
G.Frame_49.Size = UDim2.new(1, -4, 0, 44)
G.Frame_49.ZIndex = 14
G.Frame_49.Parent = G.Visuals

-- UICorner_142 (UICorner)
G.UICorner_142 = Instance.new("UICorner")
G.UICorner_142.CornerRadius = UDim.new(1, 0)
G.UICorner_142.Parent = G.Frame_49

-- UIStroke_74 (UIStroke)
G.UIStroke_74 = Instance.new("UIStroke")
G.UIStroke_74.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_74.Transparency = 0.5
G.UIStroke_74.Parent = G.Frame_49

-- TextLabel_47 (TextLabel)
G.TextLabel_47 = Instance.new("TextLabel")
G.TextLabel_47.BackgroundTransparency = 1
G.TextLabel_47.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_47.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_47.ZIndex = 15
G.TextLabel_47.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_47.Text = "Stretch Rez"
G.TextLabel_47.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_47.TextSize = 12
G.TextLabel_47.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_47.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_47.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_47.Parent = G.Frame_49

-- Track_24 (Frame)
G.Track_24 = Instance.new("Frame")
G.Track_24.Name = "Track"
G.Track_24.AnchorPoint = Vector2.new(1, 0.5)
G.Track_24.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_24.BorderSizePixel = 0
G.Track_24.Position = UDim2.new(1, -10, 0.5, 0)
G.Track_24.Size = UDim2.new(0, 48, 0, 26)
G.Track_24.ZIndex = 15
G.Track_24.Parent = G.Frame_49

-- UICorner_143 (UICorner)
G.UICorner_143 = Instance.new("UICorner")
G.UICorner_143.CornerRadius = UDim.new(1, 0)
G.UICorner_143.Parent = G.Track_24

-- Knob_24 (Frame)
G.Knob_24 = Instance.new("Frame")
G.Knob_24.Name = "Knob"
G.Knob_24.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_24.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_24.BorderSizePixel = 0
G.Knob_24.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_24.Size = UDim2.new(0, 20, 0, 20)
G.Knob_24.ZIndex = 16
G.Knob_24.Parent = G.Track_24

-- UICorner_144 (UICorner)
G.UICorner_144 = Instance.new("UICorner")
G.UICorner_144.CornerRadius = UDim.new(1, 0)
G.UICorner_144.Parent = G.Knob_24

-- KnobStroke_24 (UIStroke)
G.KnobStroke_24 = Instance.new("UIStroke")
G.KnobStroke_24.Name = "KnobStroke"
G.KnobStroke_24.Thickness = 0.60000002384185791
G.KnobStroke_24.Transparency = 0.75
G.KnobStroke_24.Parent = G.Knob_24

-- TextButton_9 (TextButton)
G.TextButton_9 = Instance.new("TextButton")
G.TextButton_9.BackgroundTransparency = 1
G.TextButton_9.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_9.ZIndex = 30
G.TextButton_9.AutoButtonColor = false
G.TextButton_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_9.Text = ""
G.TextButton_9.Parent = G.Frame_49

-- SectionHeading_14 (TextLabel)
G.SectionHeading_14 = Instance.new("TextLabel")
G.SectionHeading_14.Name = "SectionHeading"
G.SectionHeading_14.BackgroundTransparency = 1
G.SectionHeading_14.LayoutOrder = 5
G.SectionHeading_14.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_14.ZIndex = 15
G.SectionHeading_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_14.Text = "PERFORMANCE"
G.SectionHeading_14.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_14.TextSize = 11
G.SectionHeading_14.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_14.Parent = G.Visuals

-- Frame_50 (Frame)
G.Frame_50 = Instance.new("Frame")
G.Frame_50.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_50.BackgroundTransparency = 0.079999998211860657
G.Frame_50.BorderSizePixel = 0
G.Frame_50.LayoutOrder = 6
G.Frame_50.Size = UDim2.new(1, -4, 0, 44)
G.Frame_50.ZIndex = 14
G.Frame_50.Parent = G.Visuals

-- UICorner_145 (UICorner)
G.UICorner_145 = Instance.new("UICorner")
G.UICorner_145.CornerRadius = UDim.new(1, 0)
G.UICorner_145.Parent = G.Frame_50

-- UIStroke_75 (UIStroke)
G.UIStroke_75 = Instance.new("UIStroke")
G.UIStroke_75.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_75.Transparency = 0.5
G.UIStroke_75.Parent = G.Frame_50

-- TextLabel_48 (TextLabel)
G.TextLabel_48 = Instance.new("TextLabel")
G.TextLabel_48.BackgroundTransparency = 1
G.TextLabel_48.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_48.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_48.ZIndex = 15
G.TextLabel_48.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_48.Text = "Anti Lag"
G.TextLabel_48.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_48.TextSize = 12
G.TextLabel_48.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_48.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_48.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_48.Parent = G.Frame_50

-- Track_25 (Frame)
G.Track_25 = Instance.new("Frame")
G.Track_25.Name = "Track"
G.Track_25.AnchorPoint = Vector2.new(1, 0.5)
G.Track_25.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_25.BorderSizePixel = 0
G.Track_25.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_25.Size = UDim2.new(0, 48, 0, 26)
G.Track_25.ZIndex = 15
G.Track_25.Parent = G.Frame_50

-- UICorner_146 (UICorner)
G.UICorner_146 = Instance.new("UICorner")
G.UICorner_146.CornerRadius = UDim.new(1, 0)
G.UICorner_146.Parent = G.Track_25

-- Knob_25 (Frame)
G.Knob_25 = Instance.new("Frame")
G.Knob_25.Name = "Knob"
G.Knob_25.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_25.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_25.BorderSizePixel = 0
G.Knob_25.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_25.Size = UDim2.new(0, 20, 0, 20)
G.Knob_25.ZIndex = 16
G.Knob_25.Parent = G.Track_25

-- UICorner_147 (UICorner)
G.UICorner_147 = Instance.new("UICorner")
G.UICorner_147.CornerRadius = UDim.new(1, 0)
G.UICorner_147.Parent = G.Knob_25

-- KnobStroke_25 (UIStroke)
G.KnobStroke_25 = Instance.new("UIStroke")
G.KnobStroke_25.Name = "KnobStroke"
G.KnobStroke_25.Thickness = 0.60000002384185791
G.KnobStroke_25.Transparency = 0.75
G.KnobStroke_25.Parent = G.Knob_25

-- ToggleHit_24 (TextButton)
G.ToggleHit_24 = Instance.new("TextButton")
G.ToggleHit_24.Name = "ToggleHit"
G.ToggleHit_24.BackgroundTransparency = 1
G.ToggleHit_24.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_24.ZIndex = 30
G.ToggleHit_24.AutoButtonColor = false
G.ToggleHit_24.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_24.Text = ""
G.ToggleHit_24.Parent = G.Frame_50

-- SectionHeading_15 (TextLabel)
G.SectionHeading_15 = Instance.new("TextLabel")
G.SectionHeading_15.Name = "SectionHeading"
G.SectionHeading_15.BackgroundTransparency = 1
G.SectionHeading_15.LayoutOrder = 7
G.SectionHeading_15.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_15.ZIndex = 15
G.SectionHeading_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_15.Text = "ENVIRONMENT"
G.SectionHeading_15.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_15.TextSize = 11
G.SectionHeading_15.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_15.Parent = G.Visuals

-- Frame_51 (Frame)
G.Frame_51 = Instance.new("Frame")
G.Frame_51.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_51.BackgroundTransparency = 0.029999999329447746
G.Frame_51.BorderSizePixel = 0
G.Frame_51.ClipsDescendants = true
G.Frame_51.LayoutOrder = 8
G.Frame_51.Size = UDim2.new(1, -4, 0, 44)
G.Frame_51.ZIndex = 14
G.Frame_51.Parent = G.Visuals

-- UICorner_148 (UICorner)
G.UICorner_148 = Instance.new("UICorner")
G.UICorner_148.CornerRadius = UDim.new(0, 9)
G.UICorner_148.Parent = G.Frame_51

-- UIStroke_76 (UIStroke)
G.UIStroke_76 = Instance.new("UIStroke")
G.UIStroke_76.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_76.Transparency = 0.34999999403953552
G.UIStroke_76.Parent = G.Frame_51

-- TextLabel_49 (TextLabel)
G.TextLabel_49 = Instance.new("TextLabel")
G.TextLabel_49.BackgroundTransparency = 1
G.TextLabel_49.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_49.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_49.ZIndex = 16
G.TextLabel_49.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_49.Text = "Sky Theme"
G.TextLabel_49.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_49.TextSize = 12
G.TextLabel_49.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_49.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_49.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_49.Parent = G.Frame_51

-- DropdownCardGradient_7 (UIGradient)
G.DropdownCardGradient_7 = Instance.new("UIGradient")
G.DropdownCardGradient_7.Name = "DropdownCardGradient"
G.DropdownCardGradient_7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_7.Rotation = 90
G.DropdownCardGradient_7.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_7.Parent = G.Frame_51

-- DropdownSelector_7 (TextButton)
G.DropdownSelector_7 = Instance.new("TextButton")
G.DropdownSelector_7.Name = "DropdownSelector"
G.DropdownSelector_7.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_7.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_7.BorderSizePixel = 0
G.DropdownSelector_7.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_7.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_7.ZIndex = 18
G.DropdownSelector_7.AutoButtonColor = false
G.DropdownSelector_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_7.Text = "Off  ▼"
G.DropdownSelector_7.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_7.TextSize = 11
G.DropdownSelector_7.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_7.Parent = G.Frame_51

-- UICorner_149 (UICorner)
G.UICorner_149 = Instance.new("UICorner")
G.UICorner_149.CornerRadius = UDim.new(0, 7)
G.UICorner_149.Parent = G.DropdownSelector_7

-- UIStroke_77 (UIStroke)
G.UIStroke_77 = Instance.new("UIStroke")
G.UIStroke_77.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_77.Transparency = 0.20000000298023224
G.UIStroke_77.Parent = G.DropdownSelector_7

-- DropdownChoices_7 (ScrollingFrame)
G.DropdownChoices_7 = Instance.new("ScrollingFrame")
G.DropdownChoices_7.Name = "DropdownChoices"
G.DropdownChoices_7.Active = true
G.DropdownChoices_7.BackgroundTransparency = 1
G.DropdownChoices_7.BorderSizePixel = 0
G.DropdownChoices_7.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_7.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_7.Visible = false
G.DropdownChoices_7.ZIndex = 17
G.DropdownChoices_7.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_7.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_7.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_7.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_7.ScrollBarThickness = 3
G.DropdownChoices_7.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_7.Parent = G.Frame_51

-- UIListLayout_11 (UIListLayout)
G.UIListLayout_11 = Instance.new("UIListLayout")
G.UIListLayout_11.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_11.Padding = UDim.new(0, 4)
G.UIListLayout_11.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_11.Parent = G.DropdownChoices_7

-- Option1_7 (TextButton)
G.Option1_7 = Instance.new("TextButton")
G.Option1_7.Name = "Option1"
G.Option1_7.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_7.BorderSizePixel = 0
G.Option1_7.LayoutOrder = 1
G.Option1_7.Size = UDim2.new(1, -4, 0, 27)
G.Option1_7.ZIndex = 18
G.Option1_7.AutoButtonColor = false
G.Option1_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_7.Text = "Off"
G.Option1_7.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_7.TextSize = 11
G.Option1_7.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_7.Parent = G.DropdownChoices_7

-- UICorner_150 (UICorner)
G.UICorner_150 = Instance.new("UICorner")
G.UICorner_150.CornerRadius = UDim.new(0, 7)
G.UICorner_150.Parent = G.Option1_7

-- Option2_7 (TextButton)
G.Option2_7 = Instance.new("TextButton")
G.Option2_7.Name = "Option2"
G.Option2_7.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_7.BorderSizePixel = 0
G.Option2_7.LayoutOrder = 2
G.Option2_7.Size = UDim2.new(1, -4, 0, 27)
G.Option2_7.ZIndex = 18
G.Option2_7.AutoButtonColor = false
G.Option2_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_7.Text = "Night"
G.Option2_7.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_7.TextSize = 11
G.Option2_7.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_7.Parent = G.DropdownChoices_7

-- UICorner_151 (UICorner)
G.UICorner_151 = Instance.new("UICorner")
G.UICorner_151.CornerRadius = UDim.new(0, 7)
G.UICorner_151.Parent = G.Option2_7

-- Option3_3 (TextButton)
G.Option3_3 = Instance.new("TextButton")
G.Option3_3.Name = "Option3"
G.Option3_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option3_3.BorderSizePixel = 0
G.Option3_3.LayoutOrder = 3
G.Option3_3.Size = UDim2.new(1, -4, 0, 27)
G.Option3_3.ZIndex = 18
G.Option3_3.AutoButtonColor = false
G.Option3_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option3_3.Text = "Aurora"
G.Option3_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option3_3.TextSize = 11
G.Option3_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option3_3.Parent = G.DropdownChoices_7

-- UICorner_152 (UICorner)
G.UICorner_152 = Instance.new("UICorner")
G.UICorner_152.CornerRadius = UDim.new(0, 7)
G.UICorner_152.Parent = G.Option3_3

-- Option4_2 (TextButton)
G.Option4_2 = Instance.new("TextButton")
G.Option4_2.Name = "Option4"
G.Option4_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option4_2.BorderSizePixel = 0
G.Option4_2.LayoutOrder = 4
G.Option4_2.Size = UDim2.new(1, -4, 0, 27)
G.Option4_2.ZIndex = 18
G.Option4_2.AutoButtonColor = false
G.Option4_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option4_2.Text = "Sunset"
G.Option4_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option4_2.TextSize = 11
G.Option4_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option4_2.Parent = G.DropdownChoices_7

-- UICorner_153 (UICorner)
G.UICorner_153 = Instance.new("UICorner")
G.UICorner_153.CornerRadius = UDim.new(0, 7)
G.UICorner_153.Parent = G.Option4_2

-- Option5 (TextButton)
G.Option5 = Instance.new("TextButton")
G.Option5.Name = "Option5"
G.Option5.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option5.BorderSizePixel = 0
G.Option5.LayoutOrder = 5
G.Option5.Size = UDim2.new(1, -4, 0, 27)
G.Option5.ZIndex = 18
G.Option5.AutoButtonColor = false
G.Option5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option5.Text = "Galaxy"
G.Option5.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option5.TextSize = 11
G.Option5.TextTruncate = Enum.TextTruncate.AtEnd
G.Option5.Parent = G.DropdownChoices_7

-- UICorner_154 (UICorner)
G.UICorner_154 = Instance.new("UICorner")
G.UICorner_154.CornerRadius = UDim.new(0, 7)
G.UICorner_154.Parent = G.Option5

-- Option6 (TextButton)
G.Option6 = Instance.new("TextButton")
G.Option6.Name = "Option6"
G.Option6.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option6.BorderSizePixel = 0
G.Option6.LayoutOrder = 6
G.Option6.Size = UDim2.new(1, -4, 0, 27)
G.Option6.ZIndex = 18
G.Option6.AutoButtonColor = false
G.Option6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option6.Text = "Cyber"
G.Option6.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option6.TextSize = 11
G.Option6.TextTruncate = Enum.TextTruncate.AtEnd
G.Option6.Parent = G.DropdownChoices_7

-- UICorner_155 (UICorner)
G.UICorner_155 = Instance.new("UICorner")
G.UICorner_155.CornerRadius = UDim.new(0, 7)
G.UICorner_155.Parent = G.Option6

-- Option7 (TextButton)
G.Option7 = Instance.new("TextButton")
G.Option7.Name = "Option7"
G.Option7.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option7.BorderSizePixel = 0
G.Option7.LayoutOrder = 7
G.Option7.Size = UDim2.new(1, -4, 0, 27)
G.Option7.ZIndex = 18
G.Option7.AutoButtonColor = false
G.Option7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option7.Text = "Sakura"
G.Option7.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option7.TextSize = 11
G.Option7.TextTruncate = Enum.TextTruncate.AtEnd
G.Option7.Parent = G.DropdownChoices_7

-- UICorner_156 (UICorner)
G.UICorner_156 = Instance.new("UICorner")
G.UICorner_156.CornerRadius = UDim.new(0, 7)
G.UICorner_156.Parent = G.Option7

-- Option8 (TextButton)
G.Option8 = Instance.new("TextButton")
G.Option8.Name = "Option8"
G.Option8.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option8.BorderSizePixel = 0
G.Option8.LayoutOrder = 8
G.Option8.Size = UDim2.new(1, -4, 0, 27)
G.Option8.ZIndex = 18
G.Option8.AutoButtonColor = false
G.Option8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option8.Text = "Pink Night"
G.Option8.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option8.TextSize = 11
G.Option8.TextTruncate = Enum.TextTruncate.AtEnd
G.Option8.Parent = G.DropdownChoices_7

-- UICorner_157 (UICorner)
G.UICorner_157 = Instance.new("UICorner")
G.UICorner_157.CornerRadius = UDim.new(0, 7)
G.UICorner_157.Parent = G.Option8

-- Option9 (TextButton)
G.Option9 = Instance.new("TextButton")
G.Option9.Name = "Option9"
G.Option9.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option9.BorderSizePixel = 0
G.Option9.LayoutOrder = 9
G.Option9.Size = UDim2.new(1, -4, 0, 27)
G.Option9.ZIndex = 18
G.Option9.AutoButtonColor = false
G.Option9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option9.Text = "Blood Moon"
G.Option9.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option9.TextSize = 11
G.Option9.TextTruncate = Enum.TextTruncate.AtEnd
G.Option9.Parent = G.DropdownChoices_7

-- UICorner_158 (UICorner)
G.UICorner_158 = Instance.new("UICorner")
G.UICorner_158.CornerRadius = UDim.new(0, 7)
G.UICorner_158.Parent = G.Option9

-- Option10 (TextButton)
G.Option10 = Instance.new("TextButton")
G.Option10.Name = "Option10"
G.Option10.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option10.BorderSizePixel = 0
G.Option10.LayoutOrder = 10
G.Option10.Size = UDim2.new(1, -4, 0, 27)
G.Option10.ZIndex = 18
G.Option10.AutoButtonColor = false
G.Option10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option10.Text = "Emerald Dawn"
G.Option10.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option10.TextSize = 11
G.Option10.TextTruncate = Enum.TextTruncate.AtEnd
G.Option10.Parent = G.DropdownChoices_7

-- UICorner_159 (UICorner)
G.UICorner_159 = Instance.new("UICorner")
G.UICorner_159.CornerRadius = UDim.new(0, 7)
G.UICorner_159.Parent = G.Option10

-- Option11 (TextButton)
G.Option11 = Instance.new("TextButton")
G.Option11.Name = "Option11"
G.Option11.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option11.BorderSizePixel = 0
G.Option11.LayoutOrder = 11
G.Option11.Size = UDim2.new(1, -4, 0, 27)
G.Option11.ZIndex = 18
G.Option11.AutoButtonColor = false
G.Option11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option11.Text = "Volcanic"
G.Option11.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option11.TextSize = 11
G.Option11.TextTruncate = Enum.TextTruncate.AtEnd
G.Option11.Parent = G.DropdownChoices_7

-- UICorner_160 (UICorner)
G.UICorner_160 = Instance.new("UICorner")
G.UICorner_160.CornerRadius = UDim.new(0, 7)
G.UICorner_160.Parent = G.Option11

-- Option12 (TextButton)
G.Option12 = Instance.new("TextButton")
G.Option12.Name = "Option12"
G.Option12.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option12.BorderSizePixel = 0
G.Option12.LayoutOrder = 12
G.Option12.Size = UDim2.new(1, -4, 0, 27)
G.Option12.ZIndex = 18
G.Option12.AutoButtonColor = false
G.Option12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option12.Text = "Arctic"
G.Option12.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option12.TextSize = 11
G.Option12.TextTruncate = Enum.TextTruncate.AtEnd
G.Option12.Parent = G.DropdownChoices_7

-- UICorner_161 (UICorner)
G.UICorner_161 = Instance.new("UICorner")
G.UICorner_161.CornerRadius = UDim.new(0, 7)
G.UICorner_161.Parent = G.Option12

-- Option13 (TextButton)
G.Option13 = Instance.new("TextButton")
G.Option13.Name = "Option13"
G.Option13.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option13.BorderSizePixel = 0
G.Option13.LayoutOrder = 13
G.Option13.Size = UDim2.new(1, -4, 0, 27)
G.Option13.ZIndex = 18
G.Option13.AutoButtonColor = false
G.Option13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option13.Text = "Midnight Ocean"
G.Option13.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option13.TextSize = 11
G.Option13.TextTruncate = Enum.TextTruncate.AtEnd
G.Option13.Parent = G.DropdownChoices_7

-- UICorner_162 (UICorner)
G.UICorner_162 = Instance.new("UICorner")
G.UICorner_162.CornerRadius = UDim.new(0, 7)
G.UICorner_162.Parent = G.Option13

-- Option14 (TextButton)
G.Option14 = Instance.new("TextButton")
G.Option14.Name = "Option14"
G.Option14.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option14.BorderSizePixel = 0
G.Option14.LayoutOrder = 14
G.Option14.Size = UDim2.new(1, -4, 0, 27)
G.Option14.ZIndex = 18
G.Option14.AutoButtonColor = false
G.Option14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option14.Text = "Vaporwave"
G.Option14.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option14.TextSize = 11
G.Option14.TextTruncate = Enum.TextTruncate.AtEnd
G.Option14.Parent = G.DropdownChoices_7

-- UICorner_163 (UICorner)
G.UICorner_163 = Instance.new("UICorner")
G.UICorner_163.CornerRadius = UDim.new(0, 7)
G.UICorner_163.Parent = G.Option14

-- Option15 (TextButton)
G.Option15 = Instance.new("TextButton")
G.Option15.Name = "Option15"
G.Option15.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option15.BorderSizePixel = 0
G.Option15.LayoutOrder = 15
G.Option15.Size = UDim2.new(1, -4, 0, 27)
G.Option15.ZIndex = 18
G.Option15.AutoButtonColor = false
G.Option15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option15.Text = "Toxic"
G.Option15.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option15.TextSize = 11
G.Option15.TextTruncate = Enum.TextTruncate.AtEnd
G.Option15.Parent = G.DropdownChoices_7

-- UICorner_164 (UICorner)
G.UICorner_164 = Instance.new("UICorner")
G.UICorner_164.CornerRadius = UDim.new(0, 7)
G.UICorner_164.Parent = G.Option15

-- Option16 (TextButton)
G.Option16 = Instance.new("TextButton")
G.Option16.Name = "Option16"
G.Option16.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option16.BorderSizePixel = 0
G.Option16.LayoutOrder = 16
G.Option16.Size = UDim2.new(1, -4, 0, 27)
G.Option16.ZIndex = 18
G.Option16.AutoButtonColor = false
G.Option16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option16.Text = "Solar Eclipse"
G.Option16.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option16.TextSize = 11
G.Option16.TextTruncate = Enum.TextTruncate.AtEnd
G.Option16.Parent = G.DropdownChoices_7

-- UICorner_165 (UICorner)
G.UICorner_165 = Instance.new("UICorner")
G.UICorner_165.CornerRadius = UDim.new(0, 7)
G.UICorner_165.Parent = G.Option16

-- Option17 (TextButton)
G.Option17 = Instance.new("TextButton")
G.Option17.Name = "Option17"
G.Option17.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option17.BorderSizePixel = 0
G.Option17.LayoutOrder = 17
G.Option17.Size = UDim2.new(1, -4, 0, 27)
G.Option17.ZIndex = 18
G.Option17.AutoButtonColor = false
G.Option17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option17.Text = "Hellscape"
G.Option17.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option17.TextSize = 11
G.Option17.TextTruncate = Enum.TextTruncate.AtEnd
G.Option17.Parent = G.DropdownChoices_7

-- UICorner_166 (UICorner)
G.UICorner_166 = Instance.new("UICorner")
G.UICorner_166.CornerRadius = UDim.new(0, 7)
G.UICorner_166.Parent = G.Option17

-- Option18 (TextButton)
G.Option18 = Instance.new("TextButton")
G.Option18.Name = "Option18"
G.Option18.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option18.BorderSizePixel = 0
G.Option18.LayoutOrder = 18
G.Option18.Size = UDim2.new(1, -4, 0, 27)
G.Option18.ZIndex = 18
G.Option18.AutoButtonColor = false
G.Option18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option18.Text = "Heaven"
G.Option18.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option18.TextSize = 11
G.Option18.TextTruncate = Enum.TextTruncate.AtEnd
G.Option18.Parent = G.DropdownChoices_7

-- UICorner_167 (UICorner)
G.UICorner_167 = Instance.new("UICorner")
G.UICorner_167.CornerRadius = UDim.new(0, 7)
G.UICorner_167.Parent = G.Option18

-- Option19 (TextButton)
G.Option19 = Instance.new("TextButton")
G.Option19.Name = "Option19"
G.Option19.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option19.BorderSizePixel = 0
G.Option19.LayoutOrder = 19
G.Option19.Size = UDim2.new(1, -4, 0, 27)
G.Option19.ZIndex = 18
G.Option19.AutoButtonColor = false
G.Option19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option19.Text = "Storm"
G.Option19.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option19.TextSize = 11
G.Option19.TextTruncate = Enum.TextTruncate.AtEnd
G.Option19.Parent = G.DropdownChoices_7

-- UICorner_168 (UICorner)
G.UICorner_168 = Instance.new("UICorner")
G.UICorner_168.CornerRadius = UDim.new(0, 7)
G.UICorner_168.Parent = G.Option19

-- Option20 (TextButton)
G.Option20 = Instance.new("TextButton")
G.Option20.Name = "Option20"
G.Option20.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option20.BorderSizePixel = 0
G.Option20.LayoutOrder = 20
G.Option20.Size = UDim2.new(1, -4, 0, 27)
G.Option20.ZIndex = 18
G.Option20.AutoButtonColor = false
G.Option20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option20.Text = "Sunrise"
G.Option20.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option20.TextSize = 11
G.Option20.TextTruncate = Enum.TextTruncate.AtEnd
G.Option20.Parent = G.DropdownChoices_7

-- UICorner_169 (UICorner)
G.UICorner_169 = Instance.new("UICorner")
G.UICorner_169.CornerRadius = UDim.new(0, 7)
G.UICorner_169.Parent = G.Option20

-- Option21 (TextButton)
G.Option21 = Instance.new("TextButton")
G.Option21.Name = "Option21"
G.Option21.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option21.BorderSizePixel = 0
G.Option21.LayoutOrder = 21
G.Option21.Size = UDim2.new(1, -4, 0, 27)
G.Option21.ZIndex = 18
G.Option21.AutoButtonColor = false
G.Option21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option21.Text = "Deep Space"
G.Option21.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option21.TextSize = 11
G.Option21.TextTruncate = Enum.TextTruncate.AtEnd
G.Option21.Parent = G.DropdownChoices_7

-- UICorner_170 (UICorner)
G.UICorner_170 = Instance.new("UICorner")
G.UICorner_170.CornerRadius = UDim.new(0, 7)
G.UICorner_170.Parent = G.Option21

-- Option22 (TextButton)
G.Option22 = Instance.new("TextButton")
G.Option22.Name = "Option22"
G.Option22.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option22.BorderSizePixel = 0
G.Option22.LayoutOrder = 22
G.Option22.Size = UDim2.new(1, -4, 0, 27)
G.Option22.ZIndex = 18
G.Option22.AutoButtonColor = false
G.Option22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option22.Text = "Lavender Dream"
G.Option22.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option22.TextSize = 11
G.Option22.TextTruncate = Enum.TextTruncate.AtEnd
G.Option22.Parent = G.DropdownChoices_7

-- UICorner_171 (UICorner)
G.UICorner_171 = Instance.new("UICorner")
G.UICorner_171.CornerRadius = UDim.new(0, 7)
G.UICorner_171.Parent = G.Option22

-- Option23 (TextButton)
G.Option23 = Instance.new("TextButton")
G.Option23.Name = "Option23"
G.Option23.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option23.BorderSizePixel = 0
G.Option23.LayoutOrder = 23
G.Option23.Size = UDim2.new(1, -4, 0, 27)
G.Option23.ZIndex = 18
G.Option23.AutoButtonColor = false
G.Option23.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option23.Text = "Inferno"
G.Option23.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option23.TextSize = 11
G.Option23.TextTruncate = Enum.TextTruncate.AtEnd
G.Option23.Parent = G.DropdownChoices_7

-- UICorner_172 (UICorner)
G.UICorner_172 = Instance.new("UICorner")
G.UICorner_172.CornerRadius = UDim.new(0, 7)
G.UICorner_172.Parent = G.Option23

-- Option24 (TextButton)
G.Option24 = Instance.new("TextButton")
G.Option24.Name = "Option24"
G.Option24.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option24.BorderSizePixel = 0
G.Option24.LayoutOrder = 24
G.Option24.Size = UDim2.new(1, -4, 0, 27)
G.Option24.ZIndex = 18
G.Option24.AutoButtonColor = false
G.Option24.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option24.Text = "Mint Sky"
G.Option24.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option24.TextSize = 11
G.Option24.TextTruncate = Enum.TextTruncate.AtEnd
G.Option24.Parent = G.DropdownChoices_7

-- UICorner_173 (UICorner)
G.UICorner_173 = Instance.new("UICorner")
G.UICorner_173.CornerRadius = UDim.new(0, 7)
G.UICorner_173.Parent = G.Option24

-- SectionHeading_16 (TextLabel)
G.SectionHeading_16 = Instance.new("TextLabel")
G.SectionHeading_16.Name = "SectionHeading"
G.SectionHeading_16.BackgroundTransparency = 1
G.SectionHeading_16.LayoutOrder = 9
G.SectionHeading_16.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_16.ZIndex = 15
G.SectionHeading_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_16.Text = "APPEARANCE"
G.SectionHeading_16.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_16.TextSize = 11
G.SectionHeading_16.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_16.Parent = G.Visuals

-- Frame_52 (Frame)
G.Frame_52 = Instance.new("Frame")
G.Frame_52.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_52.BackgroundTransparency = 0.079999998211860657
G.Frame_52.BorderSizePixel = 0
G.Frame_52.LayoutOrder = 10
G.Frame_52.Size = UDim2.new(1, -4, 0, 44)
G.Frame_52.ZIndex = 14
G.Frame_52.Parent = G.Visuals

-- UICorner_174 (UICorner)
G.UICorner_174 = Instance.new("UICorner")
G.UICorner_174.CornerRadius = UDim.new(1, 0)
G.UICorner_174.Parent = G.Frame_52

-- UIStroke_78 (UIStroke)
G.UIStroke_78 = Instance.new("UIStroke")
G.UIStroke_78.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_78.Transparency = 0.5
G.UIStroke_78.Parent = G.Frame_52

-- TextLabel_50 (TextLabel)
G.TextLabel_50 = Instance.new("TextLabel")
G.TextLabel_50.BackgroundTransparency = 1
G.TextLabel_50.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_50.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_50.ZIndex = 15
G.TextLabel_50.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_50.Text = "Bat Skin"
G.TextLabel_50.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_50.TextSize = 12
G.TextLabel_50.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_50.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_50.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_50.Parent = G.Frame_52

-- Track_26 (Frame)
G.Track_26 = Instance.new("Frame")
G.Track_26.Name = "Track"
G.Track_26.AnchorPoint = Vector2.new(1, 0.5)
G.Track_26.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_26.BorderSizePixel = 0
G.Track_26.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_26.Size = UDim2.new(0, 48, 0, 26)
G.Track_26.ZIndex = 15
G.Track_26.Parent = G.Frame_52

-- UICorner_175 (UICorner)
G.UICorner_175 = Instance.new("UICorner")
G.UICorner_175.CornerRadius = UDim.new(1, 0)
G.UICorner_175.Parent = G.Track_26

-- Knob_26 (Frame)
G.Knob_26 = Instance.new("Frame")
G.Knob_26.Name = "Knob"
G.Knob_26.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_26.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_26.BorderSizePixel = 0
G.Knob_26.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_26.Size = UDim2.new(0, 20, 0, 20)
G.Knob_26.ZIndex = 16
G.Knob_26.Parent = G.Track_26

-- UICorner_176 (UICorner)
G.UICorner_176 = Instance.new("UICorner")
G.UICorner_176.CornerRadius = UDim.new(1, 0)
G.UICorner_176.Parent = G.Knob_26

-- KnobStroke_26 (UIStroke)
G.KnobStroke_26 = Instance.new("UIStroke")
G.KnobStroke_26.Name = "KnobStroke"
G.KnobStroke_26.Thickness = 0.60000002384185791
G.KnobStroke_26.Transparency = 0.75
G.KnobStroke_26.Parent = G.Knob_26

-- ToggleHit_25 (TextButton)
G.ToggleHit_25 = Instance.new("TextButton")
G.ToggleHit_25.Name = "ToggleHit"
G.ToggleHit_25.BackgroundTransparency = 1
G.ToggleHit_25.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_25.ZIndex = 30
G.ToggleHit_25.AutoButtonColor = false
G.ToggleHit_25.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_25.Text = ""
G.ToggleHit_25.Parent = G.Frame_52

-- Frame_53 (Frame)
G.Frame_53 = Instance.new("Frame")
G.Frame_53.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_53.BackgroundTransparency = 0.079999998211860657
G.Frame_53.BorderSizePixel = 0
G.Frame_53.LayoutOrder = 11
G.Frame_53.Size = UDim2.new(1, -4, 0, 44)
G.Frame_53.ZIndex = 14
G.Frame_53.Parent = G.Visuals

-- UICorner_177 (UICorner)
G.UICorner_177 = Instance.new("UICorner")
G.UICorner_177.CornerRadius = UDim.new(1, 0)
G.UICorner_177.Parent = G.Frame_53

-- UIStroke_79 (UIStroke)
G.UIStroke_79 = Instance.new("UIStroke")
G.UIStroke_79.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_79.Transparency = 0.5
G.UIStroke_79.Parent = G.Frame_53

-- TextLabel_51 (TextLabel)
G.TextLabel_51 = Instance.new("TextLabel")
G.TextLabel_51.BackgroundTransparency = 1
G.TextLabel_51.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_51.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_51.ZIndex = 15
G.TextLabel_51.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_51.Text = "Minecraft Bat"
G.TextLabel_51.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_51.TextSize = 12
G.TextLabel_51.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_51.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_51.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_51.Parent = G.Frame_53

-- Track_27 (Frame)
G.Track_27 = Instance.new("Frame")
G.Track_27.Name = "Track"
G.Track_27.AnchorPoint = Vector2.new(1, 0.5)
G.Track_27.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_27.BorderSizePixel = 0
G.Track_27.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_27.Size = UDim2.new(0, 48, 0, 26)
G.Track_27.ZIndex = 15
G.Track_27.Parent = G.Frame_53

-- UICorner_178 (UICorner)
G.UICorner_178 = Instance.new("UICorner")
G.UICorner_178.CornerRadius = UDim.new(1, 0)
G.UICorner_178.Parent = G.Track_27

-- Knob_27 (Frame)
G.Knob_27 = Instance.new("Frame")
G.Knob_27.Name = "Knob"
G.Knob_27.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_27.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_27.BorderSizePixel = 0
G.Knob_27.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_27.Size = UDim2.new(0, 20, 0, 20)
G.Knob_27.ZIndex = 16
G.Knob_27.Parent = G.Track_27

-- UICorner_179 (UICorner)
G.UICorner_179 = Instance.new("UICorner")
G.UICorner_179.CornerRadius = UDim.new(1, 0)
G.UICorner_179.Parent = G.Knob_27

-- KnobStroke_27 (UIStroke)
G.KnobStroke_27 = Instance.new("UIStroke")
G.KnobStroke_27.Name = "KnobStroke"
G.KnobStroke_27.Thickness = 0.60000002384185791
G.KnobStroke_27.Transparency = 0.75
G.KnobStroke_27.Parent = G.Knob_27

-- ToggleHit_26 (TextButton)
G.ToggleHit_26 = Instance.new("TextButton")
G.ToggleHit_26.Name = "ToggleHit"
G.ToggleHit_26.BackgroundTransparency = 1
G.ToggleHit_26.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_26.ZIndex = 30
G.ToggleHit_26.AutoButtonColor = false
G.ToggleHit_26.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_26.Text = ""
G.ToggleHit_26.Parent = G.Frame_53

-- Frame_54 (Frame)
G.Frame_54 = Instance.new("Frame")
G.Frame_54.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_54.BackgroundTransparency = 0.029999999329447746
G.Frame_54.BorderSizePixel = 0
G.Frame_54.ClipsDescendants = true
G.Frame_54.LayoutOrder = 12
G.Frame_54.Size = UDim2.new(1, -4, 0, 44)
G.Frame_54.ZIndex = 14
G.Frame_54.Parent = G.Visuals

-- UICorner_180 (UICorner)
G.UICorner_180 = Instance.new("UICorner")
G.UICorner_180.CornerRadius = UDim.new(0, 9)
G.UICorner_180.Parent = G.Frame_54

-- UIStroke_80 (UIStroke)
G.UIStroke_80 = Instance.new("UIStroke")
G.UIStroke_80.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_80.Transparency = 0.34999999403953552
G.UIStroke_80.Parent = G.Frame_54

-- TextLabel_52 (TextLabel)
G.TextLabel_52 = Instance.new("TextLabel")
G.TextLabel_52.BackgroundTransparency = 1
G.TextLabel_52.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_52.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_52.ZIndex = 16
G.TextLabel_52.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_52.Text = "MC Bat Color"
G.TextLabel_52.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_52.TextSize = 12
G.TextLabel_52.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_52.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_52.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_52.Parent = G.Frame_54

-- DropdownCardGradient_8 (UIGradient)
G.DropdownCardGradient_8 = Instance.new("UIGradient")
G.DropdownCardGradient_8.Name = "DropdownCardGradient"
G.DropdownCardGradient_8.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_8.Rotation = 90
G.DropdownCardGradient_8.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_8.Parent = G.Frame_54

-- DropdownSelector_8 (TextButton)
G.DropdownSelector_8 = Instance.new("TextButton")
G.DropdownSelector_8.Name = "DropdownSelector"
G.DropdownSelector_8.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_8.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_8.BorderSizePixel = 0
G.DropdownSelector_8.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_8.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_8.ZIndex = 18
G.DropdownSelector_8.AutoButtonColor = false
G.DropdownSelector_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_8.Text = "Default  ▼"
G.DropdownSelector_8.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_8.TextSize = 11
G.DropdownSelector_8.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_8.Parent = G.Frame_54

-- UICorner_181 (UICorner)
G.UICorner_181 = Instance.new("UICorner")
G.UICorner_181.CornerRadius = UDim.new(0, 7)
G.UICorner_181.Parent = G.DropdownSelector_8

-- UIStroke_81 (UIStroke)
G.UIStroke_81 = Instance.new("UIStroke")
G.UIStroke_81.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_81.Transparency = 0.20000000298023224
G.UIStroke_81.Parent = G.DropdownSelector_8

-- DropdownChoices_8 (ScrollingFrame)
G.DropdownChoices_8 = Instance.new("ScrollingFrame")
G.DropdownChoices_8.Name = "DropdownChoices"
G.DropdownChoices_8.Active = true
G.DropdownChoices_8.BackgroundTransparency = 1
G.DropdownChoices_8.BorderSizePixel = 0
G.DropdownChoices_8.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_8.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_8.Visible = false
G.DropdownChoices_8.ZIndex = 17
G.DropdownChoices_8.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_8.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_8.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_8.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_8.ScrollBarThickness = 3
G.DropdownChoices_8.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_8.Parent = G.Frame_54

-- UIListLayout_12 (UIListLayout)
G.UIListLayout_12 = Instance.new("UIListLayout")
G.UIListLayout_12.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_12.Padding = UDim.new(0, 4)
G.UIListLayout_12.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_12.Parent = G.DropdownChoices_8

-- Option1_8 (TextButton)
G.Option1_8 = Instance.new("TextButton")
G.Option1_8.Name = "Option1"
G.Option1_8.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_8.BorderSizePixel = 0
G.Option1_8.LayoutOrder = 1
G.Option1_8.Size = UDim2.new(1, -4, 0, 27)
G.Option1_8.ZIndex = 18
G.Option1_8.AutoButtonColor = false
G.Option1_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_8.Text = "Default"
G.Option1_8.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_8.TextSize = 11
G.Option1_8.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_8.Parent = G.DropdownChoices_8

-- UICorner_182 (UICorner)
G.UICorner_182 = Instance.new("UICorner")
G.UICorner_182.CornerRadius = UDim.new(0, 7)
G.UICorner_182.Parent = G.Option1_8

-- Option2_8 (TextButton)
G.Option2_8 = Instance.new("TextButton")
G.Option2_8.Name = "Option2"
G.Option2_8.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_8.BorderSizePixel = 0
G.Option2_8.LayoutOrder = 2
G.Option2_8.Size = UDim2.new(1, -4, 0, 27)
G.Option2_8.ZIndex = 18
G.Option2_8.AutoButtonColor = false
G.Option2_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_8.Text = "Abyss Blue"
G.Option2_8.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_8.TextSize = 11
G.Option2_8.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_8.Parent = G.DropdownChoices_8

-- UICorner_183 (UICorner)
G.UICorner_183 = Instance.new("UICorner")
G.UICorner_183.CornerRadius = UDim.new(0, 7)
G.UICorner_183.Parent = G.Option2_8

-- Option3_4 (TextButton)
G.Option3_4 = Instance.new("TextButton")
G.Option3_4.Name = "Option3"
G.Option3_4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option3_4.BorderSizePixel = 0
G.Option3_4.LayoutOrder = 3
G.Option3_4.Size = UDim2.new(1, -4, 0, 27)
G.Option3_4.ZIndex = 18
G.Option3_4.AutoButtonColor = false
G.Option3_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option3_4.Text = "Venom Green"
G.Option3_4.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option3_4.TextSize = 11
G.Option3_4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option3_4.Parent = G.DropdownChoices_8

-- UICorner_184 (UICorner)
G.UICorner_184 = Instance.new("UICorner")
G.UICorner_184.CornerRadius = UDim.new(0, 7)
G.UICorner_184.Parent = G.Option3_4

-- Option4_3 (TextButton)
G.Option4_3 = Instance.new("TextButton")
G.Option4_3.Name = "Option4"
G.Option4_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option4_3.BorderSizePixel = 0
G.Option4_3.LayoutOrder = 4
G.Option4_3.Size = UDim2.new(1, -4, 0, 27)
G.Option4_3.ZIndex = 18
G.Option4_3.AutoButtonColor = false
G.Option4_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option4_3.Text = "Royal Gold"
G.Option4_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option4_3.TextSize = 11
G.Option4_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option4_3.Parent = G.DropdownChoices_8

-- UICorner_185 (UICorner)
G.UICorner_185 = Instance.new("UICorner")
G.UICorner_185.CornerRadius = UDim.new(0, 7)
G.UICorner_185.Parent = G.Option4_3

-- Option5_2 (TextButton)
G.Option5_2 = Instance.new("TextButton")
G.Option5_2.Name = "Option5"
G.Option5_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option5_2.BorderSizePixel = 0
G.Option5_2.LayoutOrder = 5
G.Option5_2.Size = UDim2.new(1, -4, 0, 27)
G.Option5_2.ZIndex = 18
G.Option5_2.AutoButtonColor = false
G.Option5_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option5_2.Text = "Velvet Rose"
G.Option5_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option5_2.TextSize = 11
G.Option5_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option5_2.Parent = G.DropdownChoices_8

-- UICorner_186 (UICorner)
G.UICorner_186 = Instance.new("UICorner")
G.UICorner_186.CornerRadius = UDim.new(0, 7)
G.UICorner_186.Parent = G.Option5_2

-- Option6_2 (TextButton)
G.Option6_2 = Instance.new("TextButton")
G.Option6_2.Name = "Option6"
G.Option6_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option6_2.BorderSizePixel = 0
G.Option6_2.LayoutOrder = 6
G.Option6_2.Size = UDim2.new(1, -4, 0, 27)
G.Option6_2.ZIndex = 18
G.Option6_2.AutoButtonColor = false
G.Option6_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option6_2.Text = "Crimson Night"
G.Option6_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option6_2.TextSize = 11
G.Option6_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option6_2.Parent = G.DropdownChoices_8

-- UICorner_187 (UICorner)
G.UICorner_187 = Instance.new("UICorner")
G.UICorner_187.CornerRadius = UDim.new(0, 7)
G.UICorner_187.Parent = G.Option6_2

-- Option7_2 (TextButton)
G.Option7_2 = Instance.new("TextButton")
G.Option7_2.Name = "Option7"
G.Option7_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option7_2.BorderSizePixel = 0
G.Option7_2.LayoutOrder = 7
G.Option7_2.Size = UDim2.new(1, -4, 0, 27)
G.Option7_2.ZIndex = 18
G.Option7_2.AutoButtonColor = false
G.Option7_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option7_2.Text = "RGB"
G.Option7_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option7_2.TextSize = 11
G.Option7_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option7_2.Parent = G.DropdownChoices_8

-- UICorner_188 (UICorner)
G.UICorner_188 = Instance.new("UICorner")
G.UICorner_188.CornerRadius = UDim.new(0, 7)
G.UICorner_188.Parent = G.Option7_2

-- SectionHeading_17 (TextLabel)
G.SectionHeading_17 = Instance.new("TextLabel")
G.SectionHeading_17.Name = "SectionHeading"
G.SectionHeading_17.BackgroundTransparency = 1
G.SectionHeading_17.LayoutOrder = 13
G.SectionHeading_17.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_17.ZIndex = 15
G.SectionHeading_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_17.Text = "HEADLESS & KORBLOX"
G.SectionHeading_17.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_17.TextSize = 11
G.SectionHeading_17.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_17.Parent = G.Visuals

-- Frame_55 (Frame)
G.Frame_55 = Instance.new("Frame")
G.Frame_55.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_55.BackgroundTransparency = 0.079999998211860657
G.Frame_55.BorderSizePixel = 0
G.Frame_55.LayoutOrder = 14
G.Frame_55.Size = UDim2.new(1, -4, 0, 44)
G.Frame_55.ZIndex = 14
G.Frame_55.Parent = G.Visuals

-- UICorner_189 (UICorner)
G.UICorner_189 = Instance.new("UICorner")
G.UICorner_189.CornerRadius = UDim.new(1, 0)
G.UICorner_189.Parent = G.Frame_55

-- UIStroke_82 (UIStroke)
G.UIStroke_82 = Instance.new("UIStroke")
G.UIStroke_82.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_82.Transparency = 0.5
G.UIStroke_82.Parent = G.Frame_55

-- TextLabel_53 (TextLabel)
G.TextLabel_53 = Instance.new("TextLabel")
G.TextLabel_53.BackgroundTransparency = 1
G.TextLabel_53.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_53.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_53.ZIndex = 15
G.TextLabel_53.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_53.Text = "Headless"
G.TextLabel_53.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_53.TextSize = 12
G.TextLabel_53.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_53.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_53.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_53.Parent = G.Frame_55

-- Track_28 (Frame)
G.Track_28 = Instance.new("Frame")
G.Track_28.Name = "Track"
G.Track_28.AnchorPoint = Vector2.new(1, 0.5)
G.Track_28.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_28.BorderSizePixel = 0
G.Track_28.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_28.Size = UDim2.new(0, 48, 0, 26)
G.Track_28.ZIndex = 15
G.Track_28.Parent = G.Frame_55

-- UICorner_190 (UICorner)
G.UICorner_190 = Instance.new("UICorner")
G.UICorner_190.CornerRadius = UDim.new(1, 0)
G.UICorner_190.Parent = G.Track_28

-- Knob_28 (Frame)
G.Knob_28 = Instance.new("Frame")
G.Knob_28.Name = "Knob"
G.Knob_28.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_28.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_28.BorderSizePixel = 0
G.Knob_28.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_28.Size = UDim2.new(0, 20, 0, 20)
G.Knob_28.ZIndex = 16
G.Knob_28.Parent = G.Track_28

-- UICorner_191 (UICorner)
G.UICorner_191 = Instance.new("UICorner")
G.UICorner_191.CornerRadius = UDim.new(1, 0)
G.UICorner_191.Parent = G.Knob_28

-- KnobStroke_28 (UIStroke)
G.KnobStroke_28 = Instance.new("UIStroke")
G.KnobStroke_28.Name = "KnobStroke"
G.KnobStroke_28.Thickness = 0.60000002384185791
G.KnobStroke_28.Transparency = 0.75
G.KnobStroke_28.Parent = G.Knob_28

-- ToggleHit_27 (TextButton)
G.ToggleHit_27 = Instance.new("TextButton")
G.ToggleHit_27.Name = "ToggleHit"
G.ToggleHit_27.BackgroundTransparency = 1
G.ToggleHit_27.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_27.ZIndex = 30
G.ToggleHit_27.AutoButtonColor = false
G.ToggleHit_27.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_27.Text = ""
G.ToggleHit_27.Parent = G.Frame_55

-- Frame_56 (Frame)
G.Frame_56 = Instance.new("Frame")
G.Frame_56.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_56.BackgroundTransparency = 0.029999999329447746
G.Frame_56.BorderSizePixel = 0
G.Frame_56.ClipsDescendants = true
G.Frame_56.LayoutOrder = 15
G.Frame_56.Size = UDim2.new(1, -4, 0, 44)
G.Frame_56.ZIndex = 14
G.Frame_56.Parent = G.Visuals

-- UICorner_192 (UICorner)
G.UICorner_192 = Instance.new("UICorner")
G.UICorner_192.CornerRadius = UDim.new(0, 9)
G.UICorner_192.Parent = G.Frame_56

-- UIStroke_83 (UIStroke)
G.UIStroke_83 = Instance.new("UIStroke")
G.UIStroke_83.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_83.Transparency = 0.34999999403953552
G.UIStroke_83.Parent = G.Frame_56

-- TextLabel_54 (TextLabel)
G.TextLabel_54 = Instance.new("TextLabel")
G.TextLabel_54.BackgroundTransparency = 1
G.TextLabel_54.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_54.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_54.ZIndex = 16
G.TextLabel_54.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_54.Text = "Korblox"
G.TextLabel_54.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_54.TextSize = 12
G.TextLabel_54.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_54.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_54.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_54.Parent = G.Frame_56

-- DropdownCardGradient_9 (UIGradient)
G.DropdownCardGradient_9 = Instance.new("UIGradient")
G.DropdownCardGradient_9.Name = "DropdownCardGradient"
G.DropdownCardGradient_9.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_9.Rotation = 90
G.DropdownCardGradient_9.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_9.Parent = G.Frame_56

-- DropdownSelector_9 (TextButton)
G.DropdownSelector_9 = Instance.new("TextButton")
G.DropdownSelector_9.Name = "DropdownSelector"
G.DropdownSelector_9.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_9.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_9.BorderSizePixel = 0
G.DropdownSelector_9.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_9.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_9.ZIndex = 18
G.DropdownSelector_9.AutoButtonColor = false
G.DropdownSelector_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_9.Text = "Off  ▼"
G.DropdownSelector_9.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_9.TextSize = 11
G.DropdownSelector_9.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_9.Parent = G.Frame_56

-- UICorner_193 (UICorner)
G.UICorner_193 = Instance.new("UICorner")
G.UICorner_193.CornerRadius = UDim.new(0, 7)
G.UICorner_193.Parent = G.DropdownSelector_9

-- UIStroke_84 (UIStroke)
G.UIStroke_84 = Instance.new("UIStroke")
G.UIStroke_84.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_84.Transparency = 0.20000000298023224
G.UIStroke_84.Parent = G.DropdownSelector_9

-- DropdownChoices_9 (ScrollingFrame)
G.DropdownChoices_9 = Instance.new("ScrollingFrame")
G.DropdownChoices_9.Name = "DropdownChoices"
G.DropdownChoices_9.Active = true
G.DropdownChoices_9.BackgroundTransparency = 1
G.DropdownChoices_9.BorderSizePixel = 0
G.DropdownChoices_9.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_9.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_9.Visible = false
G.DropdownChoices_9.ZIndex = 17
G.DropdownChoices_9.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_9.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_9.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_9.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_9.ScrollBarThickness = 0
G.DropdownChoices_9.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_9.Parent = G.Frame_56

-- UIListLayout_13 (UIListLayout)
G.UIListLayout_13 = Instance.new("UIListLayout")
G.UIListLayout_13.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_13.Padding = UDim.new(0, 4)
G.UIListLayout_13.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_13.Parent = G.DropdownChoices_9

-- Option1_9 (TextButton)
G.Option1_9 = Instance.new("TextButton")
G.Option1_9.Name = "Option1"
G.Option1_9.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_9.BorderSizePixel = 0
G.Option1_9.LayoutOrder = 1
G.Option1_9.Size = UDim2.new(1, -4, 0, 27)
G.Option1_9.ZIndex = 18
G.Option1_9.AutoButtonColor = false
G.Option1_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_9.Text = "Off"
G.Option1_9.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_9.TextSize = 11
G.Option1_9.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_9.Parent = G.DropdownChoices_9

-- UICorner_194 (UICorner)
G.UICorner_194 = Instance.new("UICorner")
G.UICorner_194.CornerRadius = UDim.new(0, 7)
G.UICorner_194.Parent = G.Option1_9

-- Option2_9 (TextButton)
G.Option2_9 = Instance.new("TextButton")
G.Option2_9.Name = "Option2"
G.Option2_9.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_9.BorderSizePixel = 0
G.Option2_9.LayoutOrder = 2
G.Option2_9.Size = UDim2.new(1, -4, 0, 27)
G.Option2_9.ZIndex = 18
G.Option2_9.AutoButtonColor = false
G.Option2_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_9.Text = "Left"
G.Option2_9.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_9.TextSize = 11
G.Option2_9.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_9.Parent = G.DropdownChoices_9

-- UICorner_195 (UICorner)
G.UICorner_195 = Instance.new("UICorner")
G.UICorner_195.CornerRadius = UDim.new(0, 7)
G.UICorner_195.Parent = G.Option2_9

-- Option3_5 (TextButton)
G.Option3_5 = Instance.new("TextButton")
G.Option3_5.Name = "Option3"
G.Option3_5.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option3_5.BorderSizePixel = 0
G.Option3_5.LayoutOrder = 3
G.Option3_5.Size = UDim2.new(1, -4, 0, 27)
G.Option3_5.ZIndex = 18
G.Option3_5.AutoButtonColor = false
G.Option3_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option3_5.Text = "Right"
G.Option3_5.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option3_5.TextSize = 11
G.Option3_5.TextTruncate = Enum.TextTruncate.AtEnd
G.Option3_5.Parent = G.DropdownChoices_9

-- UICorner_196 (UICorner)
G.UICorner_196 = Instance.new("UICorner")
G.UICorner_196.CornerRadius = UDim.new(0, 7)
G.UICorner_196.Parent = G.Option3_5

-- Option4_4 (TextButton)
G.Option4_4 = Instance.new("TextButton")
G.Option4_4.Name = "Option4"
G.Option4_4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option4_4.BorderSizePixel = 0
G.Option4_4.LayoutOrder = 4
G.Option4_4.Size = UDim2.new(1, -4, 0, 27)
G.Option4_4.ZIndex = 18
G.Option4_4.AutoButtonColor = false
G.Option4_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option4_4.Text = "Both"
G.Option4_4.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option4_4.TextSize = 11
G.Option4_4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option4_4.Parent = G.DropdownChoices_9

-- UICorner_197 (UICorner)
G.UICorner_197 = Instance.new("UICorner")
G.UICorner_197.CornerRadius = UDim.new(0, 7)
G.UICorner_197.Parent = G.Option4_4

-- SectionHeading_18 (TextLabel)
G.SectionHeading_18 = Instance.new("TextLabel")
G.SectionHeading_18.Name = "SectionHeading"
G.SectionHeading_18.BackgroundTransparency = 1
G.SectionHeading_18.LayoutOrder = 16
G.SectionHeading_18.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_18.ZIndex = 15
G.SectionHeading_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_18.Text = "HATS"
G.SectionHeading_18.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_18.TextSize = 11
G.SectionHeading_18.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_18.Parent = G.Visuals

-- Frame_57 (Frame)
G.Frame_57 = Instance.new("Frame")
G.Frame_57.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_57.BackgroundTransparency = 0.029999999329447746
G.Frame_57.BorderSizePixel = 0
G.Frame_57.ClipsDescendants = true
G.Frame_57.LayoutOrder = 17
G.Frame_57.Size = UDim2.new(1, -4, 0, 44)
G.Frame_57.ZIndex = 14
G.Frame_57.Parent = G.Visuals

-- UICorner_198 (UICorner)
G.UICorner_198 = Instance.new("UICorner")
G.UICorner_198.CornerRadius = UDim.new(0, 9)
G.UICorner_198.Parent = G.Frame_57

-- UIStroke_85 (UIStroke)
G.UIStroke_85 = Instance.new("UIStroke")
G.UIStroke_85.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_85.Transparency = 0.34999999403953552
G.UIStroke_85.Parent = G.Frame_57

-- TextLabel_55 (TextLabel)
G.TextLabel_55 = Instance.new("TextLabel")
G.TextLabel_55.BackgroundTransparency = 1
G.TextLabel_55.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_55.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_55.ZIndex = 16
G.TextLabel_55.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_55.Text = "Hat Selection"
G.TextLabel_55.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_55.TextSize = 12
G.TextLabel_55.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_55.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_55.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_55.Parent = G.Frame_57

-- DropdownCardGradient_10 (UIGradient)
G.DropdownCardGradient_10 = Instance.new("UIGradient")
G.DropdownCardGradient_10.Name = "DropdownCardGradient"
G.DropdownCardGradient_10.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_10.Rotation = 90
G.DropdownCardGradient_10.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_10.Parent = G.Frame_57

-- DropdownSelector_10 (TextButton)
G.DropdownSelector_10 = Instance.new("TextButton")
G.DropdownSelector_10.Name = "DropdownSelector"
G.DropdownSelector_10.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_10.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_10.BorderSizePixel = 0
G.DropdownSelector_10.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_10.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_10.ZIndex = 18
G.DropdownSelector_10.AutoButtonColor = false
G.DropdownSelector_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_10.Text = "Off  ▼"
G.DropdownSelector_10.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_10.TextSize = 11
G.DropdownSelector_10.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_10.Parent = G.Frame_57

-- UICorner_199 (UICorner)
G.UICorner_199 = Instance.new("UICorner")
G.UICorner_199.CornerRadius = UDim.new(0, 7)
G.UICorner_199.Parent = G.DropdownSelector_10

-- UIStroke_86 (UIStroke)
G.UIStroke_86 = Instance.new("UIStroke")
G.UIStroke_86.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_86.Transparency = 0.20000000298023224
G.UIStroke_86.Parent = G.DropdownSelector_10

-- DropdownChoices_10 (ScrollingFrame)
G.DropdownChoices_10 = Instance.new("ScrollingFrame")
G.DropdownChoices_10.Name = "DropdownChoices"
G.DropdownChoices_10.Active = true
G.DropdownChoices_10.BackgroundTransparency = 1
G.DropdownChoices_10.BorderSizePixel = 0
G.DropdownChoices_10.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_10.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_10.Visible = false
G.DropdownChoices_10.ZIndex = 17
G.DropdownChoices_10.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_10.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_10.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_10.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_10.ScrollBarThickness = 3
G.DropdownChoices_10.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_10.Parent = G.Frame_57

-- UIListLayout_14 (UIListLayout)
G.UIListLayout_14 = Instance.new("UIListLayout")
G.UIListLayout_14.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_14.Padding = UDim.new(0, 4)
G.UIListLayout_14.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_14.Parent = G.DropdownChoices_10

-- Option1_10 (TextButton)
G.Option1_10 = Instance.new("TextButton")
G.Option1_10.Name = "Option1"
G.Option1_10.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_10.BorderSizePixel = 0
G.Option1_10.LayoutOrder = 1
G.Option1_10.Size = UDim2.new(1, -4, 0, 27)
G.Option1_10.ZIndex = 18
G.Option1_10.AutoButtonColor = false
G.Option1_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_10.Text = "Off"
G.Option1_10.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_10.TextSize = 11
G.Option1_10.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_10.Parent = G.DropdownChoices_10

-- UICorner_200 (UICorner)
G.UICorner_200 = Instance.new("UICorner")
G.UICorner_200.CornerRadius = UDim.new(0, 7)
G.UICorner_200.Parent = G.Option1_10

-- Option2_10 (TextButton)
G.Option2_10 = Instance.new("TextButton")
G.Option2_10.Name = "Option2"
G.Option2_10.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_10.BorderSizePixel = 0
G.Option2_10.LayoutOrder = 2
G.Option2_10.Size = UDim2.new(1, -4, 0, 27)
G.Option2_10.ZIndex = 18
G.Option2_10.AutoButtonColor = false
G.Option2_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_10.Text = "8-Bit Royal Crown"
G.Option2_10.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_10.TextSize = 11
G.Option2_10.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_10.Parent = G.DropdownChoices_10

-- UICorner_201 (UICorner)
G.UICorner_201 = Instance.new("UICorner")
G.UICorner_201.CornerRadius = UDim.new(0, 7)
G.UICorner_201.Parent = G.Option2_10

-- Option3_6 (TextButton)
G.Option3_6 = Instance.new("TextButton")
G.Option3_6.Name = "Option3"
G.Option3_6.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option3_6.BorderSizePixel = 0
G.Option3_6.LayoutOrder = 3
G.Option3_6.Size = UDim2.new(1, -4, 0, 27)
G.Option3_6.ZIndex = 18
G.Option3_6.AutoButtonColor = false
G.Option3_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option3_6.Text = "Purple Sparkle"
G.Option3_6.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option3_6.TextSize = 11
G.Option3_6.TextTruncate = Enum.TextTruncate.AtEnd
G.Option3_6.Parent = G.DropdownChoices_10

-- UICorner_202 (UICorner)
G.UICorner_202 = Instance.new("UICorner")
G.UICorner_202.CornerRadius = UDim.new(0, 7)
G.UICorner_202.Parent = G.Option3_6

-- Option4_5 (TextButton)
G.Option4_5 = Instance.new("TextButton")
G.Option4_5.Name = "Option4"
G.Option4_5.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option4_5.BorderSizePixel = 0
G.Option4_5.LayoutOrder = 4
G.Option4_5.Size = UDim2.new(1, -4, 0, 27)
G.Option4_5.ZIndex = 18
G.Option4_5.AutoButtonColor = false
G.Option4_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option4_5.Text = "Pink Sparkle"
G.Option4_5.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option4_5.TextSize = 11
G.Option4_5.TextTruncate = Enum.TextTruncate.AtEnd
G.Option4_5.Parent = G.DropdownChoices_10

-- UICorner_203 (UICorner)
G.UICorner_203 = Instance.new("UICorner")
G.UICorner_203.CornerRadius = UDim.new(0, 7)
G.UICorner_203.Parent = G.Option4_5

-- Option5_3 (TextButton)
G.Option5_3 = Instance.new("TextButton")
G.Option5_3.Name = "Option5"
G.Option5_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option5_3.BorderSizePixel = 0
G.Option5_3.LayoutOrder = 5
G.Option5_3.Size = UDim2.new(1, -4, 0, 27)
G.Option5_3.ZIndex = 18
G.Option5_3.AutoButtonColor = false
G.Option5_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option5_3.Text = "Red Sparkle"
G.Option5_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option5_3.TextSize = 11
G.Option5_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option5_3.Parent = G.DropdownChoices_10

-- UICorner_204 (UICorner)
G.UICorner_204 = Instance.new("UICorner")
G.UICorner_204.CornerRadius = UDim.new(0, 7)
G.UICorner_204.Parent = G.Option5_3

-- Option6_3 (TextButton)
G.Option6_3 = Instance.new("TextButton")
G.Option6_3.Name = "Option6"
G.Option6_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option6_3.BorderSizePixel = 0
G.Option6_3.LayoutOrder = 6
G.Option6_3.Size = UDim2.new(1, -4, 0, 27)
G.Option6_3.ZIndex = 18
G.Option6_3.AutoButtonColor = false
G.Option6_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option6_3.Text = "Midnight Sparkle"
G.Option6_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option6_3.TextSize = 11
G.Option6_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option6_3.Parent = G.DropdownChoices_10

-- UICorner_205 (UICorner)
G.UICorner_205 = Instance.new("UICorner")
G.UICorner_205.CornerRadius = UDim.new(0, 7)
G.UICorner_205.Parent = G.Option6_3

-- Option7_3 (TextButton)
G.Option7_3 = Instance.new("TextButton")
G.Option7_3.Name = "Option7"
G.Option7_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option7_3.BorderSizePixel = 0
G.Option7_3.LayoutOrder = 7
G.Option7_3.Size = UDim2.new(1, -4, 0, 27)
G.Option7_3.ZIndex = 18
G.Option7_3.AutoButtonColor = false
G.Option7_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option7_3.Text = "Green Sparkle"
G.Option7_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option7_3.TextSize = 11
G.Option7_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option7_3.Parent = G.DropdownChoices_10

-- UICorner_206 (UICorner)
G.UICorner_206 = Instance.new("UICorner")
G.UICorner_206.CornerRadius = UDim.new(0, 7)
G.UICorner_206.Parent = G.Option7_3

-- Option8_2 (TextButton)
G.Option8_2 = Instance.new("TextButton")
G.Option8_2.Name = "Option8"
G.Option8_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option8_2.BorderSizePixel = 0
G.Option8_2.LayoutOrder = 8
G.Option8_2.Size = UDim2.new(1, -4, 0, 27)
G.Option8_2.ZIndex = 18
G.Option8_2.AutoButtonColor = false
G.Option8_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option8_2.Text = "Black Sparkle"
G.Option8_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option8_2.TextSize = 11
G.Option8_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option8_2.Parent = G.DropdownChoices_10

-- UICorner_207 (UICorner)
G.UICorner_207 = Instance.new("UICorner")
G.UICorner_207.CornerRadius = UDim.new(0, 7)
G.UICorner_207.Parent = G.Option8_2

-- Option9_2 (TextButton)
G.Option9_2 = Instance.new("TextButton")
G.Option9_2.Name = "Option9"
G.Option9_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option9_2.BorderSizePixel = 0
G.Option9_2.LayoutOrder = 9
G.Option9_2.Size = UDim2.new(1, -4, 0, 27)
G.Option9_2.ZIndex = 18
G.Option9_2.AutoButtonColor = false
G.Option9_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option9_2.Text = "Fiery"
G.Option9_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option9_2.TextSize = 11
G.Option9_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option9_2.Parent = G.DropdownChoices_10

-- UICorner_208 (UICorner)
G.UICorner_208 = Instance.new("UICorner")
G.UICorner_208.CornerRadius = UDim.new(0, 7)
G.UICorner_208.Parent = G.Option9_2

-- Option10_2 (TextButton)
G.Option10_2 = Instance.new("TextButton")
G.Option10_2.Name = "Option10"
G.Option10_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option10_2.BorderSizePixel = 0
G.Option10_2.LayoutOrder = 10
G.Option10_2.Size = UDim2.new(1, -4, 0, 27)
G.Option10_2.ZIndex = 18
G.Option10_2.AutoButtonColor = false
G.Option10_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option10_2.Text = "Bluesteel"
G.Option10_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option10_2.TextSize = 11
G.Option10_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option10_2.Parent = G.DropdownChoices_10

-- UICorner_209 (UICorner)
G.UICorner_209 = Instance.new("UICorner")
G.UICorner_209.CornerRadius = UDim.new(0, 7)
G.UICorner_209.Parent = G.Option10_2

-- Option11_2 (TextButton)
G.Option11_2 = Instance.new("TextButton")
G.Option11_2.Name = "Option11"
G.Option11_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option11_2.BorderSizePixel = 0
G.Option11_2.LayoutOrder = 11
G.Option11_2.Size = UDim2.new(1, -4, 0, 27)
G.Option11_2.ZIndex = 18
G.Option11_2.AutoButtonColor = false
G.Option11_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option11_2.Text = "Frozen"
G.Option11_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option11_2.TextSize = 11
G.Option11_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option11_2.Parent = G.DropdownChoices_10

-- UICorner_210 (UICorner)
G.UICorner_210 = Instance.new("UICorner")
G.UICorner_210.CornerRadius = UDim.new(0, 7)
G.UICorner_210.Parent = G.Option11_2

-- Option12_2 (TextButton)
G.Option12_2 = Instance.new("TextButton")
G.Option12_2.Name = "Option12"
G.Option12_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option12_2.BorderSizePixel = 0
G.Option12_2.LayoutOrder = 12
G.Option12_2.Size = UDim2.new(1, -4, 0, 27)
G.Option12_2.ZIndex = 18
G.Option12_2.AutoButtonColor = false
G.Option12_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option12_2.Text = "Poisoned"
G.Option12_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option12_2.TextSize = 11
G.Option12_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option12_2.Parent = G.DropdownChoices_10

-- UICorner_211 (UICorner)
G.UICorner_211 = Instance.new("UICorner")
G.UICorner_211.CornerRadius = UDim.new(0, 7)
G.UICorner_211.Parent = G.Option12_2

-- Option13_2 (TextButton)
G.Option13_2 = Instance.new("TextButton")
G.Option13_2.Name = "Option13"
G.Option13_2.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option13_2.BorderSizePixel = 0
G.Option13_2.LayoutOrder = 13
G.Option13_2.Size = UDim2.new(1, -4, 0, 27)
G.Option13_2.ZIndex = 18
G.Option13_2.AutoButtonColor = false
G.Option13_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option13_2.Text = "Stormbreak"
G.Option13_2.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option13_2.TextSize = 11
G.Option13_2.TextTruncate = Enum.TextTruncate.AtEnd
G.Option13_2.Parent = G.DropdownChoices_10

-- UICorner_212 (UICorner)
G.UICorner_212 = Instance.new("UICorner")
G.UICorner_212.CornerRadius = UDim.new(0, 7)
G.UICorner_212.Parent = G.Option13_2

-- SectionHeading_19 (TextLabel)
G.SectionHeading_19 = Instance.new("TextLabel")
G.SectionHeading_19.Name = "SectionHeading"
G.SectionHeading_19.BackgroundTransparency = 1
G.SectionHeading_19.LayoutOrder = 18
G.SectionHeading_19.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_19.ZIndex = 15
G.SectionHeading_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_19.Text = "ANIMATIONS"
G.SectionHeading_19.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_19.TextSize = 11
G.SectionHeading_19.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_19.Parent = G.Visuals

-- Frame_58 (Frame)
G.Frame_58 = Instance.new("Frame")
G.Frame_58.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_58.BackgroundTransparency = 0.029999999329447746
G.Frame_58.BorderSizePixel = 0
G.Frame_58.ClipsDescendants = true
G.Frame_58.LayoutOrder = 19
G.Frame_58.Size = UDim2.new(1, -4, 0, 44)
G.Frame_58.ZIndex = 14
G.Frame_58.Parent = G.Visuals

-- UICorner_213 (UICorner)
G.UICorner_213 = Instance.new("UICorner")
G.UICorner_213.CornerRadius = UDim.new(0, 9)
G.UICorner_213.Parent = G.Frame_58

-- UIStroke_87 (UIStroke)
G.UIStroke_87 = Instance.new("UIStroke")
G.UIStroke_87.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_87.Transparency = 0.34999999403953552
G.UIStroke_87.Parent = G.Frame_58

-- TextLabel_56 (TextLabel)
G.TextLabel_56 = Instance.new("TextLabel")
G.TextLabel_56.BackgroundTransparency = 1
G.TextLabel_56.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_56.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_56.ZIndex = 16
G.TextLabel_56.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_56.Text = "Animation Pack"
G.TextLabel_56.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_56.TextSize = 12
G.TextLabel_56.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_56.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_56.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_56.Parent = G.Frame_58

-- DropdownCardGradient_11 (UIGradient)
G.DropdownCardGradient_11 = Instance.new("UIGradient")
G.DropdownCardGradient_11.Name = "DropdownCardGradient"
G.DropdownCardGradient_11.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_11.Rotation = 90
G.DropdownCardGradient_11.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_11.Parent = G.Frame_58

-- DropdownSelector_11 (TextButton)
G.DropdownSelector_11 = Instance.new("TextButton")
G.DropdownSelector_11.Name = "DropdownSelector"
G.DropdownSelector_11.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_11.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_11.BorderSizePixel = 0
G.DropdownSelector_11.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_11.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_11.ZIndex = 18
G.DropdownSelector_11.AutoButtonColor = false
G.DropdownSelector_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_11.Text = "Off  ▼"
G.DropdownSelector_11.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_11.TextSize = 11
G.DropdownSelector_11.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_11.Parent = G.Frame_58

-- UICorner_214 (UICorner)
G.UICorner_214 = Instance.new("UICorner")
G.UICorner_214.CornerRadius = UDim.new(0, 7)
G.UICorner_214.Parent = G.DropdownSelector_11

-- UIStroke_88 (UIStroke)
G.UIStroke_88 = Instance.new("UIStroke")
G.UIStroke_88.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_88.Transparency = 0.20000000298023224
G.UIStroke_88.Parent = G.DropdownSelector_11

-- DropdownChoices_11 (ScrollingFrame)
G.DropdownChoices_11 = Instance.new("ScrollingFrame")
G.DropdownChoices_11.Name = "DropdownChoices"
G.DropdownChoices_11.Active = true
G.DropdownChoices_11.BackgroundTransparency = 1
G.DropdownChoices_11.BorderSizePixel = 0
G.DropdownChoices_11.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_11.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_11.Visible = false
G.DropdownChoices_11.ZIndex = 17
G.DropdownChoices_11.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_11.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_11.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_11.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_11.ScrollBarThickness = 3
G.DropdownChoices_11.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_11.Parent = G.Frame_58

-- UIListLayout_15 (UIListLayout)
G.UIListLayout_15 = Instance.new("UIListLayout")
G.UIListLayout_15.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_15.Padding = UDim.new(0, 4)
G.UIListLayout_15.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_15.Parent = G.DropdownChoices_11

-- Option1_11 (TextButton)
G.Option1_11 = Instance.new("TextButton")
G.Option1_11.Name = "Option1"
G.Option1_11.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_11.BorderSizePixel = 0
G.Option1_11.LayoutOrder = 1
G.Option1_11.Size = UDim2.new(1, -4, 0, 27)
G.Option1_11.ZIndex = 18
G.Option1_11.AutoButtonColor = false
G.Option1_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_11.Text = "Off"
G.Option1_11.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_11.TextSize = 11
G.Option1_11.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_11.Parent = G.DropdownChoices_11

-- UICorner_215 (UICorner)
G.UICorner_215 = Instance.new("UICorner")
G.UICorner_215.CornerRadius = UDim.new(0, 7)
G.UICorner_215.Parent = G.Option1_11

-- Option2_11 (TextButton)
G.Option2_11 = Instance.new("TextButton")
G.Option2_11.Name = "Option2"
G.Option2_11.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_11.BorderSizePixel = 0
G.Option2_11.LayoutOrder = 2
G.Option2_11.Size = UDim2.new(1, -4, 0, 27)
G.Option2_11.ZIndex = 18
G.Option2_11.AutoButtonColor = false
G.Option2_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_11.Text = "Zombie"
G.Option2_11.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_11.TextSize = 11
G.Option2_11.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_11.Parent = G.DropdownChoices_11

-- UICorner_216 (UICorner)
G.UICorner_216 = Instance.new("UICorner")
G.UICorner_216.CornerRadius = UDim.new(0, 7)
G.UICorner_216.Parent = G.Option2_11

-- Option3_7 (TextButton)
G.Option3_7 = Instance.new("TextButton")
G.Option3_7.Name = "Option3"
G.Option3_7.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option3_7.BorderSizePixel = 0
G.Option3_7.LayoutOrder = 3
G.Option3_7.Size = UDim2.new(1, -4, 0, 27)
G.Option3_7.ZIndex = 18
G.Option3_7.AutoButtonColor = false
G.Option3_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option3_7.Text = "Ninja"
G.Option3_7.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option3_7.TextSize = 11
G.Option3_7.TextTruncate = Enum.TextTruncate.AtEnd
G.Option3_7.Parent = G.DropdownChoices_11

-- UICorner_217 (UICorner)
G.UICorner_217 = Instance.new("UICorner")
G.UICorner_217.CornerRadius = UDim.new(0, 7)
G.UICorner_217.Parent = G.Option3_7

-- Option4_6 (TextButton)
G.Option4_6 = Instance.new("TextButton")
G.Option4_6.Name = "Option4"
G.Option4_6.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option4_6.BorderSizePixel = 0
G.Option4_6.LayoutOrder = 4
G.Option4_6.Size = UDim2.new(1, -4, 0, 27)
G.Option4_6.ZIndex = 18
G.Option4_6.AutoButtonColor = false
G.Option4_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option4_6.Text = "Knight"
G.Option4_6.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option4_6.TextSize = 11
G.Option4_6.TextTruncate = Enum.TextTruncate.AtEnd
G.Option4_6.Parent = G.DropdownChoices_11

-- UICorner_218 (UICorner)
G.UICorner_218 = Instance.new("UICorner")
G.UICorner_218.CornerRadius = UDim.new(0, 7)
G.UICorner_218.Parent = G.Option4_6

-- Option5_4 (TextButton)
G.Option5_4 = Instance.new("TextButton")
G.Option5_4.Name = "Option5"
G.Option5_4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option5_4.BorderSizePixel = 0
G.Option5_4.LayoutOrder = 5
G.Option5_4.Size = UDim2.new(1, -4, 0, 27)
G.Option5_4.ZIndex = 18
G.Option5_4.AutoButtonColor = false
G.Option5_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option5_4.Text = "Elder"
G.Option5_4.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option5_4.TextSize = 11
G.Option5_4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option5_4.Parent = G.DropdownChoices_11

-- UICorner_219 (UICorner)
G.UICorner_219 = Instance.new("UICorner")
G.UICorner_219.CornerRadius = UDim.new(0, 7)
G.UICorner_219.Parent = G.Option5_4

-- Option6_4 (TextButton)
G.Option6_4 = Instance.new("TextButton")
G.Option6_4.Name = "Option6"
G.Option6_4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option6_4.BorderSizePixel = 0
G.Option6_4.LayoutOrder = 6
G.Option6_4.Size = UDim2.new(1, -4, 0, 27)
G.Option6_4.ZIndex = 18
G.Option6_4.AutoButtonColor = false
G.Option6_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option6_4.Text = "Levitate"
G.Option6_4.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option6_4.TextSize = 11
G.Option6_4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option6_4.Parent = G.DropdownChoices_11

-- UICorner_220 (UICorner)
G.UICorner_220 = Instance.new("UICorner")
G.UICorner_220.CornerRadius = UDim.new(0, 7)
G.UICorner_220.Parent = G.Option6_4

-- Option7_4 (TextButton)
G.Option7_4 = Instance.new("TextButton")
G.Option7_4.Name = "Option7"
G.Option7_4.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option7_4.BorderSizePixel = 0
G.Option7_4.LayoutOrder = 7
G.Option7_4.Size = UDim2.new(1, -4, 0, 27)
G.Option7_4.ZIndex = 18
G.Option7_4.AutoButtonColor = false
G.Option7_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option7_4.Text = "Astronaut"
G.Option7_4.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option7_4.TextSize = 11
G.Option7_4.TextTruncate = Enum.TextTruncate.AtEnd
G.Option7_4.Parent = G.DropdownChoices_11

-- UICorner_221 (UICorner)
G.UICorner_221 = Instance.new("UICorner")
G.UICorner_221.CornerRadius = UDim.new(0, 7)
G.UICorner_221.Parent = G.Option7_4

-- Option8_3 (TextButton)
G.Option8_3 = Instance.new("TextButton")
G.Option8_3.Name = "Option8"
G.Option8_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option8_3.BorderSizePixel = 0
G.Option8_3.LayoutOrder = 8
G.Option8_3.Size = UDim2.new(1, -4, 0, 27)
G.Option8_3.ZIndex = 18
G.Option8_3.AutoButtonColor = false
G.Option8_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option8_3.Text = "Pirate"
G.Option8_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option8_3.TextSize = 11
G.Option8_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option8_3.Parent = G.DropdownChoices_11

-- UICorner_222 (UICorner)
G.UICorner_222 = Instance.new("UICorner")
G.UICorner_222.CornerRadius = UDim.new(0, 7)
G.UICorner_222.Parent = G.Option8_3

-- Option9_3 (TextButton)
G.Option9_3 = Instance.new("TextButton")
G.Option9_3.Name = "Option9"
G.Option9_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option9_3.BorderSizePixel = 0
G.Option9_3.LayoutOrder = 9
G.Option9_3.Size = UDim2.new(1, -4, 0, 27)
G.Option9_3.ZIndex = 18
G.Option9_3.AutoButtonColor = false
G.Option9_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option9_3.Text = "Toy"
G.Option9_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option9_3.TextSize = 11
G.Option9_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option9_3.Parent = G.DropdownChoices_11

-- UICorner_223 (UICorner)
G.UICorner_223 = Instance.new("UICorner")
G.UICorner_223.CornerRadius = UDim.new(0, 7)
G.UICorner_223.Parent = G.Option9_3

-- Option10_3 (TextButton)
G.Option10_3 = Instance.new("TextButton")
G.Option10_3.Name = "Option10"
G.Option10_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option10_3.BorderSizePixel = 0
G.Option10_3.LayoutOrder = 10
G.Option10_3.Size = UDim2.new(1, -4, 0, 27)
G.Option10_3.ZIndex = 18
G.Option10_3.AutoButtonColor = false
G.Option10_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option10_3.Text = "Vampire"
G.Option10_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option10_3.TextSize = 11
G.Option10_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option10_3.Parent = G.DropdownChoices_11

-- UICorner_224 (UICorner)
G.UICorner_224 = Instance.new("UICorner")
G.UICorner_224.CornerRadius = UDim.new(0, 7)
G.UICorner_224.Parent = G.Option10_3

-- Option11_3 (TextButton)
G.Option11_3 = Instance.new("TextButton")
G.Option11_3.Name = "Option11"
G.Option11_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option11_3.BorderSizePixel = 0
G.Option11_3.LayoutOrder = 11
G.Option11_3.Size = UDim2.new(1, -4, 0, 27)
G.Option11_3.ZIndex = 18
G.Option11_3.AutoButtonColor = false
G.Option11_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option11_3.Text = "Werewolf"
G.Option11_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option11_3.TextSize = 11
G.Option11_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option11_3.Parent = G.DropdownChoices_11

-- UICorner_225 (UICorner)
G.UICorner_225 = Instance.new("UICorner")
G.UICorner_225.CornerRadius = UDim.new(0, 7)
G.UICorner_225.Parent = G.Option11_3

-- Option12_3 (TextButton)
G.Option12_3 = Instance.new("TextButton")
G.Option12_3.Name = "Option12"
G.Option12_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option12_3.BorderSizePixel = 0
G.Option12_3.LayoutOrder = 12
G.Option12_3.Size = UDim2.new(1, -4, 0, 27)
G.Option12_3.ZIndex = 18
G.Option12_3.AutoButtonColor = false
G.Option12_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option12_3.Text = "Rthro"
G.Option12_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option12_3.TextSize = 11
G.Option12_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option12_3.Parent = G.DropdownChoices_11

-- UICorner_226 (UICorner)
G.UICorner_226 = Instance.new("UICorner")
G.UICorner_226.CornerRadius = UDim.new(0, 7)
G.UICorner_226.Parent = G.Option12_3

-- Option13_3 (TextButton)
G.Option13_3 = Instance.new("TextButton")
G.Option13_3.Name = "Option13"
G.Option13_3.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option13_3.BorderSizePixel = 0
G.Option13_3.LayoutOrder = 13
G.Option13_3.Size = UDim2.new(1, -4, 0, 27)
G.Option13_3.ZIndex = 18
G.Option13_3.AutoButtonColor = false
G.Option13_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option13_3.Text = "Stylish"
G.Option13_3.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option13_3.TextSize = 11
G.Option13_3.TextTruncate = Enum.TextTruncate.AtEnd
G.Option13_3.Parent = G.DropdownChoices_11

-- UICorner_227 (UICorner)
G.UICorner_227 = Instance.new("UICorner")
G.UICorner_227.CornerRadius = UDim.new(0, 7)
G.UICorner_227.Parent = G.Option13_3

-- Settings (ScrollingFrame)
G.Settings = Instance.new("ScrollingFrame")
G.Settings.Name = "Settings"
G.Settings.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
G.Settings.BackgroundTransparency = 0.85000002384185791
G.Settings.BorderSizePixel = 0
G.Settings.Size = UDim2.new(1, 0, 1, 0)
G.Settings.Visible = false
G.Settings.ZIndex = 6
G.Settings.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Settings.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Settings.ScrollBarImageColor3 = Color3.fromRGB(30, 30, 35)
G.Settings.ScrollBarImageTransparency = 0.30000001192092896
G.Settings.ScrollBarThickness = 2
G.Settings.ScrollingDirection = Enum.ScrollingDirection.Y
G.Settings.Parent = G.Frame_3

-- UICorner_228 (UICorner)
G.UICorner_228 = Instance.new("UICorner")
G.UICorner_228.CornerRadius = UDim.new(0, 16)
G.UICorner_228.Parent = G.Settings

-- UIListLayout_16 (UIListLayout)
G.UIListLayout_16 = Instance.new("UIListLayout")
G.UIListLayout_16.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_16.Padding = UDim.new(0, 6)
G.UIListLayout_16.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_16.Parent = G.Settings

-- UIPadding_5 (UIPadding)
G.UIPadding_5 = Instance.new("UIPadding")
G.UIPadding_5.PaddingBottom = UDim.new(0, 20)
G.UIPadding_5.PaddingLeft = UDim.new(0, 8)
G.UIPadding_5.PaddingRight = UDim.new(0, 8)
G.UIPadding_5.PaddingTop = UDim.new(0, 6)
G.UIPadding_5.Parent = G.Settings

-- SectionHeading_20 (TextLabel)
G.SectionHeading_20 = Instance.new("TextLabel")
G.SectionHeading_20.Name = "SectionHeading"
G.SectionHeading_20.BackgroundTransparency = 1
G.SectionHeading_20.LayoutOrder = 1
G.SectionHeading_20.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_20.ZIndex = 15
G.SectionHeading_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_20.Text = "INTERFACE"
G.SectionHeading_20.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_20.TextSize = 11
G.SectionHeading_20.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_20.Parent = G.Settings

-- Frame_59 (Frame)
G.Frame_59 = Instance.new("Frame")
G.Frame_59.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_59.BackgroundTransparency = 0.079999998211860657
G.Frame_59.BorderSizePixel = 0
G.Frame_59.LayoutOrder = 2
G.Frame_59.Size = UDim2.new(1, -4, 0, 44)
G.Frame_59.ZIndex = 14
G.Frame_59.Parent = G.Settings

-- UICorner_229 (UICorner)
G.UICorner_229 = Instance.new("UICorner")
G.UICorner_229.CornerRadius = UDim.new(1, 0)
G.UICorner_229.Parent = G.Frame_59

-- UIStroke_89 (UIStroke)
G.UIStroke_89 = Instance.new("UIStroke")
G.UIStroke_89.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_89.Transparency = 0.5
G.UIStroke_89.Parent = G.Frame_59

-- TextLabel_57 (TextLabel)
G.TextLabel_57 = Instance.new("TextLabel")
G.TextLabel_57.BackgroundTransparency = 1
G.TextLabel_57.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_57.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_57.ZIndex = 15
G.TextLabel_57.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_57.Text = "Lock UI"
G.TextLabel_57.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_57.TextSize = 12
G.TextLabel_57.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_57.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_57.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_57.Parent = G.Frame_59

-- Track_29 (Frame)
G.Track_29 = Instance.new("Frame")
G.Track_29.Name = "Track"
G.Track_29.AnchorPoint = Vector2.new(1, 0.5)
G.Track_29.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Track_29.BorderSizePixel = 0
G.Track_29.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_29.Size = UDim2.new(0, 48, 0, 26)
G.Track_29.ZIndex = 15
G.Track_29.Parent = G.Frame_59

-- UICorner_230 (UICorner)
G.UICorner_230 = Instance.new("UICorner")
G.UICorner_230.CornerRadius = UDim.new(1, 0)
G.UICorner_230.Parent = G.Track_29

-- Knob_29 (Frame)
G.Knob_29 = Instance.new("Frame")
G.Knob_29.Name = "Knob"
G.Knob_29.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_29.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_29.BorderSizePixel = 0
G.Knob_29.Position = UDim2.new(1, -23, 0.5, 0)
G.Knob_29.Size = UDim2.new(0, 20, 0, 20)
G.Knob_29.ZIndex = 16
G.Knob_29.Parent = G.Track_29

-- UICorner_231 (UICorner)
G.UICorner_231 = Instance.new("UICorner")
G.UICorner_231.CornerRadius = UDim.new(1, 0)
G.UICorner_231.Parent = G.Knob_29

-- KnobStroke_29 (UIStroke)
G.KnobStroke_29 = Instance.new("UIStroke")
G.KnobStroke_29.Name = "KnobStroke"
G.KnobStroke_29.Thickness = 0.60000002384185791
G.KnobStroke_29.Transparency = 0.75
G.KnobStroke_29.Parent = G.Knob_29

-- ToggleHit_28 (TextButton)
G.ToggleHit_28 = Instance.new("TextButton")
G.ToggleHit_28.Name = "ToggleHit"
G.ToggleHit_28.BackgroundTransparency = 1
G.ToggleHit_28.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_28.ZIndex = 30
G.ToggleHit_28.AutoButtonColor = false
G.ToggleHit_28.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_28.Text = ""
G.ToggleHit_28.Parent = G.Frame_59

-- SectionHeading_21 (TextLabel)
G.SectionHeading_21 = Instance.new("TextLabel")
G.SectionHeading_21.Name = "SectionHeading"
G.SectionHeading_21.BackgroundTransparency = 1
G.SectionHeading_21.LayoutOrder = 3
G.SectionHeading_21.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_21.ZIndex = 15
G.SectionHeading_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_21.Text = "UI SETTINGS"
G.SectionHeading_21.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_21.TextSize = 11
G.SectionHeading_21.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_21.Parent = G.Settings

-- Frame_60 (Frame)
G.Frame_60 = Instance.new("Frame")
G.Frame_60.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_60.BackgroundTransparency = 0.079999998211860657
G.Frame_60.BorderSizePixel = 0
G.Frame_60.LayoutOrder = 4
G.Frame_60.Size = UDim2.new(1, -4, 0, 44)
G.Frame_60.ZIndex = 14
G.Frame_60.Parent = G.Settings

-- UICorner_232 (UICorner)
G.UICorner_232 = Instance.new("UICorner")
G.UICorner_232.CornerRadius = UDim.new(1, 0)
G.UICorner_232.Parent = G.Frame_60

-- UIStroke_90 (UIStroke)
G.UIStroke_90 = Instance.new("UIStroke")
G.UIStroke_90.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_90.Transparency = 0.5
G.UIStroke_90.Parent = G.Frame_60

-- TextLabel_58 (TextLabel)
G.TextLabel_58 = Instance.new("TextLabel")
G.TextLabel_58.BackgroundTransparency = 1
G.TextLabel_58.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_58.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_58.ZIndex = 15
G.TextLabel_58.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_58.Text = "Red Notifications"
G.TextLabel_58.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_58.TextSize = 12
G.TextLabel_58.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_58.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_58.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_58.Parent = G.Frame_60

-- Track_30 (Frame)
G.Track_30 = Instance.new("Frame")
G.Track_30.Name = "Track"
G.Track_30.AnchorPoint = Vector2.new(1, 0.5)
G.Track_30.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Track_30.BorderSizePixel = 0
G.Track_30.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_30.Size = UDim2.new(0, 48, 0, 26)
G.Track_30.ZIndex = 15
G.Track_30.Parent = G.Frame_60

-- UICorner_233 (UICorner)
G.UICorner_233 = Instance.new("UICorner")
G.UICorner_233.CornerRadius = UDim.new(1, 0)
G.UICorner_233.Parent = G.Track_30

-- Knob_30 (Frame)
G.Knob_30 = Instance.new("Frame")
G.Knob_30.Name = "Knob"
G.Knob_30.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_30.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_30.BorderSizePixel = 0
G.Knob_30.Position = UDim2.new(1, -23, 0.5, 0)
G.Knob_30.Size = UDim2.new(0, 20, 0, 20)
G.Knob_30.ZIndex = 16
G.Knob_30.Parent = G.Track_30

-- UICorner_234 (UICorner)
G.UICorner_234 = Instance.new("UICorner")
G.UICorner_234.CornerRadius = UDim.new(1, 0)
G.UICorner_234.Parent = G.Knob_30

-- KnobStroke_30 (UIStroke)
G.KnobStroke_30 = Instance.new("UIStroke")
G.KnobStroke_30.Name = "KnobStroke"
G.KnobStroke_30.Thickness = 0.60000002384185791
G.KnobStroke_30.Transparency = 0.75
G.KnobStroke_30.Parent = G.Knob_30

-- ToggleHit_29 (TextButton)
G.ToggleHit_29 = Instance.new("TextButton")
G.ToggleHit_29.Name = "ToggleHit"
G.ToggleHit_29.BackgroundTransparency = 1
G.ToggleHit_29.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_29.ZIndex = 30
G.ToggleHit_29.AutoButtonColor = false
G.ToggleHit_29.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_29.Text = ""
G.ToggleHit_29.Parent = G.Frame_60

-- Frame_61 (Frame)
G.Frame_61 = Instance.new("Frame")
G.Frame_61.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_61.BackgroundTransparency = 0.079999998211860657
G.Frame_61.BorderSizePixel = 0
G.Frame_61.LayoutOrder = 5
G.Frame_61.Size = UDim2.new(1, -4, 0, 44)
G.Frame_61.ZIndex = 14
G.Frame_61.Parent = G.Settings

-- UICorner_235 (UICorner)
G.UICorner_235 = Instance.new("UICorner")
G.UICorner_235.CornerRadius = UDim.new(1, 0)
G.UICorner_235.Parent = G.Frame_61

-- UIStroke_91 (UIStroke)
G.UIStroke_91 = Instance.new("UIStroke")
G.UIStroke_91.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_91.Transparency = 0.5
G.UIStroke_91.Parent = G.Frame_61

-- TextLabel_59 (TextLabel)
G.TextLabel_59 = Instance.new("TextLabel")
G.TextLabel_59.BackgroundTransparency = 1
G.TextLabel_59.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_59.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_59.ZIndex = 15
G.TextLabel_59.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_59.Text = "Buttons as Panel"
G.TextLabel_59.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_59.TextSize = 12
G.TextLabel_59.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_59.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_59.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_59.Parent = G.Frame_61

-- Track_31 (Frame)
G.Track_31 = Instance.new("Frame")
G.Track_31.Name = "Track"
G.Track_31.AnchorPoint = Vector2.new(1, 0.5)
G.Track_31.BackgroundColor3 = Color3.fromRGB(72, 72, 80)
G.Track_31.BorderSizePixel = 0
G.Track_31.Position = UDim2.new(1, -14, 0.5, 0)
G.Track_31.Size = UDim2.new(0, 48, 0, 26)
G.Track_31.ZIndex = 15
G.Track_31.Parent = G.Frame_61

-- UICorner_236 (UICorner)
G.UICorner_236 = Instance.new("UICorner")
G.UICorner_236.CornerRadius = UDim.new(1, 0)
G.UICorner_236.Parent = G.Track_31

-- Knob_31 (Frame)
G.Knob_31 = Instance.new("Frame")
G.Knob_31.Name = "Knob"
G.Knob_31.AnchorPoint = Vector2.new(0, 0.5)
G.Knob_31.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Knob_31.BorderSizePixel = 0
G.Knob_31.Position = UDim2.new(0, 3, 0.5, 0)
G.Knob_31.Size = UDim2.new(0, 20, 0, 20)
G.Knob_31.ZIndex = 16
G.Knob_31.Parent = G.Track_31

-- UICorner_237 (UICorner)
G.UICorner_237 = Instance.new("UICorner")
G.UICorner_237.CornerRadius = UDim.new(1, 0)
G.UICorner_237.Parent = G.Knob_31

-- KnobStroke_31 (UIStroke)
G.KnobStroke_31 = Instance.new("UIStroke")
G.KnobStroke_31.Name = "KnobStroke"
G.KnobStroke_31.Thickness = 0.60000002384185791
G.KnobStroke_31.Transparency = 0.75
G.KnobStroke_31.Parent = G.Knob_31

-- ToggleHit_30 (TextButton)
G.ToggleHit_30 = Instance.new("TextButton")
G.ToggleHit_30.Name = "ToggleHit"
G.ToggleHit_30.BackgroundTransparency = 1
G.ToggleHit_30.Size = UDim2.new(1, 0, 1, 0)
G.ToggleHit_30.ZIndex = 30
G.ToggleHit_30.AutoButtonColor = false
G.ToggleHit_30.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.ToggleHit_30.Text = ""
G.ToggleHit_30.Parent = G.Frame_61

-- Frame_62 (Frame)
G.Frame_62 = Instance.new("Frame")
G.Frame_62.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_62.BackgroundTransparency = 0.029999999329447746
G.Frame_62.BorderSizePixel = 0
G.Frame_62.ClipsDescendants = true
G.Frame_62.LayoutOrder = 6
G.Frame_62.Size = UDim2.new(1, -4, 0, 44)
G.Frame_62.ZIndex = 14
G.Frame_62.Parent = G.Settings

-- UICorner_238 (UICorner)
G.UICorner_238 = Instance.new("UICorner")
G.UICorner_238.CornerRadius = UDim.new(0, 9)
G.UICorner_238.Parent = G.Frame_62

-- UIStroke_92 (UIStroke)
G.UIStroke_92 = Instance.new("UIStroke")
G.UIStroke_92.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_92.Transparency = 0.34999999403953552
G.UIStroke_92.Parent = G.Frame_62

-- TextLabel_60 (TextLabel)
G.TextLabel_60 = Instance.new("TextLabel")
G.TextLabel_60.BackgroundTransparency = 1
G.TextLabel_60.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_60.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_60.ZIndex = 16
G.TextLabel_60.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_60.Text = "Text Style"
G.TextLabel_60.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_60.TextSize = 12
G.TextLabel_60.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_60.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_60.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_60.Parent = G.Frame_62

-- DropdownCardGradient_12 (UIGradient)
G.DropdownCardGradient_12 = Instance.new("UIGradient")
G.DropdownCardGradient_12.Name = "DropdownCardGradient"
G.DropdownCardGradient_12.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_12.Rotation = 90
G.DropdownCardGradient_12.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_12.Parent = G.Frame_62

-- DropdownSelector_12 (TextButton)
G.DropdownSelector_12 = Instance.new("TextButton")
G.DropdownSelector_12.Name = "DropdownSelector"
G.DropdownSelector_12.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_12.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_12.BorderSizePixel = 0
G.DropdownSelector_12.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_12.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_12.ZIndex = 18
G.DropdownSelector_12.AutoButtonColor = false
G.DropdownSelector_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_12.Text = "Normal  ▼"
G.DropdownSelector_12.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_12.TextSize = 11
G.DropdownSelector_12.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_12.Parent = G.Frame_62

-- UICorner_239 (UICorner)
G.UICorner_239 = Instance.new("UICorner")
G.UICorner_239.CornerRadius = UDim.new(0, 7)
G.UICorner_239.Parent = G.DropdownSelector_12

-- UIStroke_93 (UIStroke)
G.UIStroke_93 = Instance.new("UIStroke")
G.UIStroke_93.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_93.Transparency = 0.20000000298023224
G.UIStroke_93.Parent = G.DropdownSelector_12

-- DropdownChoices_12 (ScrollingFrame)
G.DropdownChoices_12 = Instance.new("ScrollingFrame")
G.DropdownChoices_12.Name = "DropdownChoices"
G.DropdownChoices_12.Active = true
G.DropdownChoices_12.BackgroundTransparency = 1
G.DropdownChoices_12.BorderSizePixel = 0
G.DropdownChoices_12.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_12.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_12.Visible = false
G.DropdownChoices_12.ZIndex = 17
G.DropdownChoices_12.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_12.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_12.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_12.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_12.ScrollBarThickness = 0
G.DropdownChoices_12.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_12.Parent = G.Frame_62

-- UIListLayout_17 (UIListLayout)
G.UIListLayout_17 = Instance.new("UIListLayout")
G.UIListLayout_17.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_17.Padding = UDim.new(0, 4)
G.UIListLayout_17.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_17.Parent = G.DropdownChoices_12

-- Option1_12 (TextButton)
G.Option1_12 = Instance.new("TextButton")
G.Option1_12.Name = "Option1"
G.Option1_12.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_12.BorderSizePixel = 0
G.Option1_12.LayoutOrder = 1
G.Option1_12.Size = UDim2.new(1, -4, 0, 27)
G.Option1_12.ZIndex = 18
G.Option1_12.AutoButtonColor = false
G.Option1_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_12.Text = "Normal"
G.Option1_12.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_12.TextSize = 11
G.Option1_12.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_12.Parent = G.DropdownChoices_12

-- UICorner_240 (UICorner)
G.UICorner_240 = Instance.new("UICorner")
G.UICorner_240.CornerRadius = UDim.new(0, 7)
G.UICorner_240.Parent = G.Option1_12

-- Option2_12 (TextButton)
G.Option2_12 = Instance.new("TextButton")
G.Option2_12.Name = "Option2"
G.Option2_12.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_12.BorderSizePixel = 0
G.Option2_12.LayoutOrder = 2
G.Option2_12.Size = UDim2.new(1, -4, 0, 27)
G.Option2_12.ZIndex = 18
G.Option2_12.AutoButtonColor = false
G.Option2_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_12.Text = "Pixel"
G.Option2_12.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_12.TextSize = 11
G.Option2_12.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_12.Parent = G.DropdownChoices_12

-- UICorner_241 (UICorner)
G.UICorner_241 = Instance.new("UICorner")
G.UICorner_241.CornerRadius = UDim.new(0, 7)
G.UICorner_241.Parent = G.Option2_12

-- Frame_63 (Frame)
G.Frame_63 = Instance.new("Frame")
G.Frame_63.BackgroundColor3 = Color3.fromRGB(15, 16, 19)
G.Frame_63.BackgroundTransparency = 0.029999999329447746
G.Frame_63.BorderSizePixel = 0
G.Frame_63.ClipsDescendants = true
G.Frame_63.LayoutOrder = 7
G.Frame_63.Size = UDim2.new(1, -4, 0, 44)
G.Frame_63.ZIndex = 14
G.Frame_63.Parent = G.Settings

-- UICorner_242 (UICorner)
G.UICorner_242 = Instance.new("UICorner")
G.UICorner_242.CornerRadius = UDim.new(0, 9)
G.UICorner_242.Parent = G.Frame_63

-- UIStroke_94 (UIStroke)
G.UIStroke_94 = Instance.new("UIStroke")
G.UIStroke_94.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_94.Transparency = 0.34999999403953552
G.UIStroke_94.Parent = G.Frame_63

-- TextLabel_61 (TextLabel)
G.TextLabel_61 = Instance.new("TextLabel")
G.TextLabel_61.BackgroundTransparency = 1
G.TextLabel_61.Position = UDim2.new(0, 13, 0, 0)
G.TextLabel_61.Size = UDim2.new(1, -150, 0, 44)
G.TextLabel_61.ZIndex = 16
G.TextLabel_61.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_61.Text = "Button Shape"
G.TextLabel_61.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_61.TextSize = 12
G.TextLabel_61.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_61.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_61.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_61.Parent = G.Frame_63

-- DropdownCardGradient_13 (UIGradient)
G.DropdownCardGradient_13 = Instance.new("UIGradient")
G.DropdownCardGradient_13.Name = "DropdownCardGradient"
G.DropdownCardGradient_13.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(21, 22, 26)), ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16))})
G.DropdownCardGradient_13.Rotation = 90
G.DropdownCardGradient_13.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.11999999731779099, 0), NumberSequenceKeypoint.new(1, 0.11999999731779099, 0)})
G.DropdownCardGradient_13.Parent = G.Frame_63

-- DropdownSelector_13 (TextButton)
G.DropdownSelector_13 = Instance.new("TextButton")
G.DropdownSelector_13.Name = "DropdownSelector"
G.DropdownSelector_13.AnchorPoint = Vector2.new(1, 0)
G.DropdownSelector_13.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.DropdownSelector_13.BorderSizePixel = 0
G.DropdownSelector_13.Position = UDim2.new(1, -10, 0, 8)
G.DropdownSelector_13.Size = UDim2.new(0, 120, 0, 27)
G.DropdownSelector_13.ZIndex = 18
G.DropdownSelector_13.AutoButtonColor = false
G.DropdownSelector_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DropdownSelector_13.Text = "Square  ▼"
G.DropdownSelector_13.TextColor3 = Color3.fromRGB(235, 235, 240)
G.DropdownSelector_13.TextSize = 11
G.DropdownSelector_13.TextTruncate = Enum.TextTruncate.AtEnd
G.DropdownSelector_13.Parent = G.Frame_63

-- UICorner_243 (UICorner)
G.UICorner_243 = Instance.new("UICorner")
G.UICorner_243.CornerRadius = UDim.new(0, 7)
G.UICorner_243.Parent = G.DropdownSelector_13

-- UIStroke_95 (UIStroke)
G.UIStroke_95 = Instance.new("UIStroke")
G.UIStroke_95.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_95.Transparency = 0.20000000298023224
G.UIStroke_95.Parent = G.DropdownSelector_13

-- DropdownChoices_13 (ScrollingFrame)
G.DropdownChoices_13 = Instance.new("ScrollingFrame")
G.DropdownChoices_13.Name = "DropdownChoices"
G.DropdownChoices_13.Active = true
G.DropdownChoices_13.BackgroundTransparency = 1
G.DropdownChoices_13.BorderSizePixel = 0
G.DropdownChoices_13.Position = UDim2.new(0, 13, 0, 44)
G.DropdownChoices_13.Size = UDim2.new(1, -26, 0, 0)
G.DropdownChoices_13.Visible = false
G.DropdownChoices_13.ZIndex = 17
G.DropdownChoices_13.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.DropdownChoices_13.CanvasSize = UDim2.new(0, 0, 0, 0)
G.DropdownChoices_13.ScrollBarImageColor3 = Color3.fromRGB(150, 152, 160)
G.DropdownChoices_13.ScrollBarImageTransparency = 0.15000000596046448
G.DropdownChoices_13.ScrollBarThickness = 0
G.DropdownChoices_13.ScrollingDirection = Enum.ScrollingDirection.Y
G.DropdownChoices_13.Parent = G.Frame_63

-- UIListLayout_18 (UIListLayout)
G.UIListLayout_18 = Instance.new("UIListLayout")
G.UIListLayout_18.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_18.Padding = UDim.new(0, 4)
G.UIListLayout_18.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_18.Parent = G.DropdownChoices_13

-- Option1_13 (TextButton)
G.Option1_13 = Instance.new("TextButton")
G.Option1_13.Name = "Option1"
G.Option1_13.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
G.Option1_13.BorderSizePixel = 0
G.Option1_13.LayoutOrder = 1
G.Option1_13.Size = UDim2.new(1, -4, 0, 27)
G.Option1_13.ZIndex = 18
G.Option1_13.AutoButtonColor = false
G.Option1_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option1_13.Text = "Square"
G.Option1_13.TextColor3 = Color3.fromRGB(18, 19, 22)
G.Option1_13.TextSize = 11
G.Option1_13.TextTruncate = Enum.TextTruncate.AtEnd
G.Option1_13.Parent = G.DropdownChoices_13

-- UICorner_244 (UICorner)
G.UICorner_244 = Instance.new("UICorner")
G.UICorner_244.CornerRadius = UDim.new(0, 7)
G.UICorner_244.Parent = G.Option1_13

-- Option2_13 (TextButton)
G.Option2_13 = Instance.new("TextButton")
G.Option2_13.Name = "Option2"
G.Option2_13.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
G.Option2_13.BorderSizePixel = 0
G.Option2_13.LayoutOrder = 2
G.Option2_13.Size = UDim2.new(1, -4, 0, 27)
G.Option2_13.ZIndex = 18
G.Option2_13.AutoButtonColor = false
G.Option2_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Option2_13.Text = "Circle"
G.Option2_13.TextColor3 = Color3.fromRGB(190, 191, 198)
G.Option2_13.TextSize = 11
G.Option2_13.TextTruncate = Enum.TextTruncate.AtEnd
G.Option2_13.Parent = G.DropdownChoices_13

-- UICorner_245 (UICorner)
G.UICorner_245 = Instance.new("UICorner")
G.UICorner_245.CornerRadius = UDim.new(0, 7)
G.UICorner_245.Parent = G.Option2_13

-- Frame_64 (Frame)
G.Frame_64 = Instance.new("Frame")
G.Frame_64.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_64.BackgroundTransparency = 0.079999998211860657
G.Frame_64.BorderSizePixel = 0
G.Frame_64.LayoutOrder = 8
G.Frame_64.Size = UDim2.new(1, -4, 0, 38)
G.Frame_64.ZIndex = 14
G.Frame_64.Parent = G.Settings

-- UICorner_246 (UICorner)
G.UICorner_246 = Instance.new("UICorner")
G.UICorner_246.CornerRadius = UDim.new(1, 0)
G.UICorner_246.Parent = G.Frame_64

-- UIStroke_96 (UIStroke)
G.UIStroke_96 = Instance.new("UIStroke")
G.UIStroke_96.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_96.Transparency = 0.5
G.UIStroke_96.Parent = G.Frame_64

-- TextLabel_62 (TextLabel)
G.TextLabel_62 = Instance.new("TextLabel")
G.TextLabel_62.BackgroundTransparency = 1
G.TextLabel_62.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_62.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_62.ZIndex = 15
G.TextLabel_62.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_62.Text = "UI Scale"
G.TextLabel_62.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_62.TextSize = 12
G.TextLabel_62.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_62.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_62.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_62.Parent = G.Frame_64

-- TextBox_16 (TextBox)
G.TextBox_16 = Instance.new("TextBox")
G.TextBox_16.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_16.BackgroundTransparency = 0.69999998807907104
G.TextBox_16.BorderSizePixel = 0
G.TextBox_16.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_16.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_16.ZIndex = 15
G.TextBox_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_16.Text = "78"
G.TextBox_16.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_16.TextSize = 11
G.TextBox_16.ClearTextOnFocus = false
G.TextBox_16:SetAttribute("PrintedLastValidValue", 78)
G.TextBox_16.Parent = G.Frame_64

-- UICorner_247 (UICorner)
G.UICorner_247 = Instance.new("UICorner")
G.UICorner_247.CornerRadius = UDim.new(0, 6)
G.UICorner_247.Parent = G.TextBox_16

-- UIStroke_97 (UIStroke)
G.UIStroke_97 = Instance.new("UIStroke")
G.UIStroke_97.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_97.Thickness = 1.2000000476837158
G.UIStroke_97.Transparency = 0.25
G.UIStroke_97.Parent = G.TextBox_16

-- Frame_65 (Frame)
G.Frame_65 = Instance.new("Frame")
G.Frame_65.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_65.BackgroundTransparency = 0.079999998211860657
G.Frame_65.BorderSizePixel = 0
G.Frame_65.LayoutOrder = 9
G.Frame_65.Size = UDim2.new(1, -4, 0, 38)
G.Frame_65.ZIndex = 14
G.Frame_65.Parent = G.Settings

-- UICorner_248 (UICorner)
G.UICorner_248 = Instance.new("UICorner")
G.UICorner_248.CornerRadius = UDim.new(1, 0)
G.UICorner_248.Parent = G.Frame_65

-- UIStroke_98 (UIStroke)
G.UIStroke_98 = Instance.new("UIStroke")
G.UIStroke_98.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_98.Transparency = 0.5
G.UIStroke_98.Parent = G.Frame_65

-- TextLabel_63 (TextLabel)
G.TextLabel_63 = Instance.new("TextLabel")
G.TextLabel_63.BackgroundTransparency = 1
G.TextLabel_63.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_63.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_63.ZIndex = 15
G.TextLabel_63.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_63.Text = "Float Scale"
G.TextLabel_63.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_63.TextSize = 12
G.TextLabel_63.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_63.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_63.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_63.Parent = G.Frame_65

-- TextBox_17 (TextBox)
G.TextBox_17 = Instance.new("TextBox")
G.TextBox_17.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_17.BackgroundTransparency = 0.69999998807907104
G.TextBox_17.BorderSizePixel = 0
G.TextBox_17.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_17.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_17.ZIndex = 15
G.TextBox_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_17.Text = "100"
G.TextBox_17.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_17.TextSize = 11
G.TextBox_17.ClearTextOnFocus = false
G.TextBox_17:SetAttribute("PrintedLastValidValue", 100)
G.TextBox_17.Parent = G.Frame_65

-- UICorner_249 (UICorner)
G.UICorner_249 = Instance.new("UICorner")
G.UICorner_249.CornerRadius = UDim.new(0, 6)
G.UICorner_249.Parent = G.TextBox_17

-- UIStroke_99 (UIStroke)
G.UIStroke_99 = Instance.new("UIStroke")
G.UIStroke_99.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_99.Thickness = 1.2000000476837158
G.UIStroke_99.Transparency = 0.25
G.UIStroke_99.Parent = G.TextBox_17

-- Frame_66 (Frame)
G.Frame_66 = Instance.new("Frame")
G.Frame_66.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_66.BackgroundTransparency = 0.079999998211860657
G.Frame_66.BorderSizePixel = 0
G.Frame_66.LayoutOrder = 10
G.Frame_66.Size = UDim2.new(1, -4, 0, 38)
G.Frame_66.ZIndex = 14
G.Frame_66.Parent = G.Settings

-- UICorner_250 (UICorner)
G.UICorner_250 = Instance.new("UICorner")
G.UICorner_250.CornerRadius = UDim.new(1, 0)
G.UICorner_250.Parent = G.Frame_66

-- UIStroke_100 (UIStroke)
G.UIStroke_100 = Instance.new("UIStroke")
G.UIStroke_100.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_100.Transparency = 0.5
G.UIStroke_100.Parent = G.Frame_66

-- TextLabel_64 (TextLabel)
G.TextLabel_64 = Instance.new("TextLabel")
G.TextLabel_64.BackgroundTransparency = 1
G.TextLabel_64.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_64.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_64.ZIndex = 15
G.TextLabel_64.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_64.Text = "Steal Bar Scale"
G.TextLabel_64.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_64.TextSize = 12
G.TextLabel_64.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_64.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_64.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_64.Parent = G.Frame_66

-- TextBox_18 (TextBox)
G.TextBox_18 = Instance.new("TextBox")
G.TextBox_18.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextBox_18.BackgroundTransparency = 0.69999998807907104
G.TextBox_18.BorderSizePixel = 0
G.TextBox_18.Position = UDim2.new(1, -62, 0.5, -12)
G.TextBox_18.Size = UDim2.new(0, 50, 0, 24)
G.TextBox_18.ZIndex = 15
G.TextBox_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextBox_18.Text = "100"
G.TextBox_18.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextBox_18.TextSize = 11
G.TextBox_18.ClearTextOnFocus = false
G.TextBox_18:SetAttribute("PrintedLastValidValue", 100)
G.TextBox_18.Parent = G.Frame_66

-- UICorner_251 (UICorner)
G.UICorner_251 = Instance.new("UICorner")
G.UICorner_251.CornerRadius = UDim.new(0, 6)
G.UICorner_251.Parent = G.TextBox_18

-- UIStroke_101 (UIStroke)
G.UIStroke_101 = Instance.new("UIStroke")
G.UIStroke_101.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_101.Thickness = 1.2000000476837158
G.UIStroke_101.Transparency = 0.25
G.UIStroke_101.Parent = G.TextBox_18

-- Binds (ScrollingFrame)
G.Binds = Instance.new("ScrollingFrame")
G.Binds.Name = "Binds"
G.Binds.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
G.Binds.BackgroundTransparency = 0.85000002384185791
G.Binds.BorderSizePixel = 0
G.Binds.Size = UDim2.new(1, 0, 1, 0)
G.Binds.Visible = false
G.Binds.ZIndex = 6
G.Binds.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.Binds.CanvasSize = UDim2.new(0, 0, 0, 0)
G.Binds.ScrollBarImageColor3 = Color3.fromRGB(30, 30, 35)
G.Binds.ScrollBarImageTransparency = 0.30000001192092896
G.Binds.ScrollBarThickness = 2
G.Binds.ScrollingDirection = Enum.ScrollingDirection.Y
G.Binds.Parent = G.Frame_3

-- UICorner_252 (UICorner)
G.UICorner_252 = Instance.new("UICorner")
G.UICorner_252.CornerRadius = UDim.new(0, 16)
G.UICorner_252.Parent = G.Binds

-- UIListLayout_19 (UIListLayout)
G.UIListLayout_19 = Instance.new("UIListLayout")
G.UIListLayout_19.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout_19.Padding = UDim.new(0, 6)
G.UIListLayout_19.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_19.Parent = G.Binds

-- UIPadding_6 (UIPadding)
G.UIPadding_6 = Instance.new("UIPadding")
G.UIPadding_6.PaddingBottom = UDim.new(0, 20)
G.UIPadding_6.PaddingLeft = UDim.new(0, 8)
G.UIPadding_6.PaddingRight = UDim.new(0, 8)
G.UIPadding_6.PaddingTop = UDim.new(0, 6)
G.UIPadding_6.Parent = G.Binds

-- SectionHeading_22 (TextLabel)
G.SectionHeading_22 = Instance.new("TextLabel")
G.SectionHeading_22.Name = "SectionHeading"
G.SectionHeading_22.BackgroundTransparency = 1
G.SectionHeading_22.LayoutOrder = 1
G.SectionHeading_22.Size = UDim2.new(1, -12, 0, 25)
G.SectionHeading_22.ZIndex = 15
G.SectionHeading_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.SectionHeading_22.Text = "KEYBINDS"
G.SectionHeading_22.TextColor3 = Color3.fromRGB(180, 180, 190)
G.SectionHeading_22.TextSize = 11
G.SectionHeading_22.TextXAlignment = Enum.TextXAlignment.Left
G.SectionHeading_22.Parent = G.Binds

-- Frame_67 (Frame)
G.Frame_67 = Instance.new("Frame")
G.Frame_67.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_67.BackgroundTransparency = 0.079999998211860657
G.Frame_67.BorderSizePixel = 0
G.Frame_67.LayoutOrder = 2
G.Frame_67.Size = UDim2.new(1, -4, 0, 36)
G.Frame_67.ZIndex = 14
G.Frame_67.Parent = G.Binds

-- UICorner_253 (UICorner)
G.UICorner_253 = Instance.new("UICorner")
G.UICorner_253.CornerRadius = UDim.new(1, 0)
G.UICorner_253.Parent = G.Frame_67

-- UIStroke_102 (UIStroke)
G.UIStroke_102 = Instance.new("UIStroke")
G.UIStroke_102.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_102.Transparency = 0.5
G.UIStroke_102.Parent = G.Frame_67

-- TextLabel_65 (TextLabel)
G.TextLabel_65 = Instance.new("TextLabel")
G.TextLabel_65.BackgroundTransparency = 1
G.TextLabel_65.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_65.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_65.ZIndex = 15
G.TextLabel_65.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_65.Text = "Carry Mode"
G.TextLabel_65.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_65.TextSize = 12
G.TextLabel_65.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_65.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_65.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_65.Parent = G.Frame_67

-- TextButton_10 (TextButton)
G.TextButton_10 = Instance.new("TextButton")
G.TextButton_10.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_10.BackgroundTransparency = 0.5
G.TextButton_10.BorderSizePixel = 0
G.TextButton_10.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_10.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_10.ZIndex = 15
G.TextButton_10.AutoButtonColor = false
G.TextButton_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_10.Text = "Q"
G.TextButton_10.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_10.TextSize = 9
G.TextButton_10.Parent = G.Frame_67

-- UICorner_254 (UICorner)
G.UICorner_254 = Instance.new("UICorner")
G.UICorner_254.CornerRadius = UDim.new(0, 6)
G.UICorner_254.Parent = G.TextButton_10

-- UIStroke_103 (UIStroke)
G.UIStroke_103 = Instance.new("UIStroke")
G.UIStroke_103.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_103.Parent = G.TextButton_10

-- Frame_68 (Frame)
G.Frame_68 = Instance.new("Frame")
G.Frame_68.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_68.BackgroundTransparency = 0.079999998211860657
G.Frame_68.BorderSizePixel = 0
G.Frame_68.LayoutOrder = 3
G.Frame_68.Size = UDim2.new(1, -4, 0, 36)
G.Frame_68.ZIndex = 14
G.Frame_68.Parent = G.Binds

-- UICorner_255 (UICorner)
G.UICorner_255 = Instance.new("UICorner")
G.UICorner_255.CornerRadius = UDim.new(1, 0)
G.UICorner_255.Parent = G.Frame_68

-- UIStroke_104 (UIStroke)
G.UIStroke_104 = Instance.new("UIStroke")
G.UIStroke_104.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_104.Transparency = 0.5
G.UIStroke_104.Parent = G.Frame_68

-- TextLabel_66 (TextLabel)
G.TextLabel_66 = Instance.new("TextLabel")
G.TextLabel_66.BackgroundTransparency = 1
G.TextLabel_66.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_66.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_66.ZIndex = 15
G.TextLabel_66.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_66.Text = "Lagger Mode"
G.TextLabel_66.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_66.TextSize = 12
G.TextLabel_66.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_66.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_66.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_66.Parent = G.Frame_68

-- TextButton_11 (TextButton)
G.TextButton_11 = Instance.new("TextButton")
G.TextButton_11.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_11.BackgroundTransparency = 0.5
G.TextButton_11.BorderSizePixel = 0
G.TextButton_11.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_11.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_11.ZIndex = 15
G.TextButton_11.AutoButtonColor = false
G.TextButton_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_11.Text = "R"
G.TextButton_11.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_11.TextSize = 9
G.TextButton_11.Parent = G.Frame_68

-- UICorner_256 (UICorner)
G.UICorner_256 = Instance.new("UICorner")
G.UICorner_256.CornerRadius = UDim.new(0, 6)
G.UICorner_256.Parent = G.TextButton_11

-- UIStroke_105 (UIStroke)
G.UIStroke_105 = Instance.new("UIStroke")
G.UIStroke_105.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_105.Parent = G.TextButton_11

-- Frame_69 (Frame)
G.Frame_69 = Instance.new("Frame")
G.Frame_69.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_69.BackgroundTransparency = 0.079999998211860657
G.Frame_69.BorderSizePixel = 0
G.Frame_69.LayoutOrder = 4
G.Frame_69.Size = UDim2.new(1, -4, 0, 36)
G.Frame_69.ZIndex = 14
G.Frame_69.Parent = G.Binds

-- UICorner_257 (UICorner)
G.UICorner_257 = Instance.new("UICorner")
G.UICorner_257.CornerRadius = UDim.new(1, 0)
G.UICorner_257.Parent = G.Frame_69

-- UIStroke_106 (UIStroke)
G.UIStroke_106 = Instance.new("UIStroke")
G.UIStroke_106.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_106.Transparency = 0.5
G.UIStroke_106.Parent = G.Frame_69

-- TextLabel_67 (TextLabel)
G.TextLabel_67 = Instance.new("TextLabel")
G.TextLabel_67.BackgroundTransparency = 1
G.TextLabel_67.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_67.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_67.ZIndex = 15
G.TextLabel_67.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_67.Text = "Auto Left"
G.TextLabel_67.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_67.TextSize = 12
G.TextLabel_67.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_67.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_67.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_67.Parent = G.Frame_69

-- TextButton_12 (TextButton)
G.TextButton_12 = Instance.new("TextButton")
G.TextButton_12.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_12.BackgroundTransparency = 0.5
G.TextButton_12.BorderSizePixel = 0
G.TextButton_12.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_12.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_12.ZIndex = 15
G.TextButton_12.AutoButtonColor = false
G.TextButton_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_12.Text = "Z"
G.TextButton_12.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_12.TextSize = 9
G.TextButton_12.Parent = G.Frame_69

-- UICorner_258 (UICorner)
G.UICorner_258 = Instance.new("UICorner")
G.UICorner_258.CornerRadius = UDim.new(0, 6)
G.UICorner_258.Parent = G.TextButton_12

-- UIStroke_107 (UIStroke)
G.UIStroke_107 = Instance.new("UIStroke")
G.UIStroke_107.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_107.Parent = G.TextButton_12

-- Frame_70 (Frame)
G.Frame_70 = Instance.new("Frame")
G.Frame_70.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_70.BackgroundTransparency = 0.079999998211860657
G.Frame_70.BorderSizePixel = 0
G.Frame_70.LayoutOrder = 5
G.Frame_70.Size = UDim2.new(1, -4, 0, 36)
G.Frame_70.ZIndex = 14
G.Frame_70.Parent = G.Binds

-- UICorner_259 (UICorner)
G.UICorner_259 = Instance.new("UICorner")
G.UICorner_259.CornerRadius = UDim.new(1, 0)
G.UICorner_259.Parent = G.Frame_70

-- UIStroke_108 (UIStroke)
G.UIStroke_108 = Instance.new("UIStroke")
G.UIStroke_108.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_108.Transparency = 0.5
G.UIStroke_108.Parent = G.Frame_70

-- TextLabel_68 (TextLabel)
G.TextLabel_68 = Instance.new("TextLabel")
G.TextLabel_68.BackgroundTransparency = 1
G.TextLabel_68.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_68.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_68.ZIndex = 15
G.TextLabel_68.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_68.Text = "Auto Right"
G.TextLabel_68.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_68.TextSize = 12
G.TextLabel_68.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_68.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_68.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_68.Parent = G.Frame_70

-- TextButton_13 (TextButton)
G.TextButton_13 = Instance.new("TextButton")
G.TextButton_13.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_13.BackgroundTransparency = 0.5
G.TextButton_13.BorderSizePixel = 0
G.TextButton_13.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_13.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_13.ZIndex = 15
G.TextButton_13.AutoButtonColor = false
G.TextButton_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_13.Text = "C"
G.TextButton_13.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_13.TextSize = 9
G.TextButton_13.Parent = G.Frame_70

-- UICorner_260 (UICorner)
G.UICorner_260 = Instance.new("UICorner")
G.UICorner_260.CornerRadius = UDim.new(0, 6)
G.UICorner_260.Parent = G.TextButton_13

-- UIStroke_109 (UIStroke)
G.UIStroke_109 = Instance.new("UIStroke")
G.UIStroke_109.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_109.Parent = G.TextButton_13

-- Frame_71 (Frame)
G.Frame_71 = Instance.new("Frame")
G.Frame_71.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_71.BackgroundTransparency = 0.079999998211860657
G.Frame_71.BorderSizePixel = 0
G.Frame_71.LayoutOrder = 6
G.Frame_71.Size = UDim2.new(1, -4, 0, 36)
G.Frame_71.ZIndex = 14
G.Frame_71.Parent = G.Binds

-- UICorner_261 (UICorner)
G.UICorner_261 = Instance.new("UICorner")
G.UICorner_261.CornerRadius = UDim.new(1, 0)
G.UICorner_261.Parent = G.Frame_71

-- UIStroke_110 (UIStroke)
G.UIStroke_110 = Instance.new("UIStroke")
G.UIStroke_110.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_110.Transparency = 0.5
G.UIStroke_110.Parent = G.Frame_71

-- TextLabel_69 (TextLabel)
G.TextLabel_69 = Instance.new("TextLabel")
G.TextLabel_69.BackgroundTransparency = 1
G.TextLabel_69.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_69.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_69.ZIndex = 15
G.TextLabel_69.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_69.Text = "Auto Bat"
G.TextLabel_69.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_69.TextSize = 12
G.TextLabel_69.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_69.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_69.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_69.Parent = G.Frame_71

-- TextButton_14 (TextButton)
G.TextButton_14 = Instance.new("TextButton")
G.TextButton_14.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_14.BackgroundTransparency = 0.5
G.TextButton_14.BorderSizePixel = 0
G.TextButton_14.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_14.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_14.ZIndex = 15
G.TextButton_14.AutoButtonColor = false
G.TextButton_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_14.Text = "E"
G.TextButton_14.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_14.TextSize = 9
G.TextButton_14.Parent = G.Frame_71

-- UICorner_262 (UICorner)
G.UICorner_262 = Instance.new("UICorner")
G.UICorner_262.CornerRadius = UDim.new(0, 6)
G.UICorner_262.Parent = G.TextButton_14

-- UIStroke_111 (UIStroke)
G.UIStroke_111 = Instance.new("UIStroke")
G.UIStroke_111.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_111.Parent = G.TextButton_14

-- Frame_72 (Frame)
G.Frame_72 = Instance.new("Frame")
G.Frame_72.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_72.BackgroundTransparency = 0.079999998211860657
G.Frame_72.BorderSizePixel = 0
G.Frame_72.LayoutOrder = 7
G.Frame_72.Size = UDim2.new(1, -4, 0, 36)
G.Frame_72.ZIndex = 14
G.Frame_72.Parent = G.Binds

-- UICorner_263 (UICorner)
G.UICorner_263 = Instance.new("UICorner")
G.UICorner_263.CornerRadius = UDim.new(1, 0)
G.UICorner_263.Parent = G.Frame_72

-- UIStroke_112 (UIStroke)
G.UIStroke_112 = Instance.new("UIStroke")
G.UIStroke_112.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_112.Transparency = 0.5
G.UIStroke_112.Parent = G.Frame_72

-- TextLabel_70 (TextLabel)
G.TextLabel_70 = Instance.new("TextLabel")
G.TextLabel_70.BackgroundTransparency = 1
G.TextLabel_70.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_70.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_70.ZIndex = 15
G.TextLabel_70.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_70.Text = "TP BAT"
G.TextLabel_70.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_70.TextSize = 12
G.TextLabel_70.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_70.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_70.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_70.Parent = G.Frame_72

-- TextButton_15 (TextButton)
G.TextButton_15 = Instance.new("TextButton")
G.TextButton_15.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_15.BackgroundTransparency = 0.5
G.TextButton_15.BorderSizePixel = 0
G.TextButton_15.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_15.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_15.ZIndex = 15
G.TextButton_15.AutoButtonColor = false
G.TextButton_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_15.Text = "X"
G.TextButton_15.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_15.TextSize = 9
G.TextButton_15.Parent = G.Frame_72

-- UICorner_264 (UICorner)
G.UICorner_264 = Instance.new("UICorner")
G.UICorner_264.CornerRadius = UDim.new(0, 6)
G.UICorner_264.Parent = G.TextButton_15

-- UIStroke_113 (UIStroke)
G.UIStroke_113 = Instance.new("UIStroke")
G.UIStroke_113.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_113.Parent = G.TextButton_15

-- Frame_73 (Frame)
G.Frame_73 = Instance.new("Frame")
G.Frame_73.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_73.BackgroundTransparency = 0.079999998211860657
G.Frame_73.BorderSizePixel = 0
G.Frame_73.LayoutOrder = 8
G.Frame_73.Size = UDim2.new(1, -4, 0, 36)
G.Frame_73.ZIndex = 14
G.Frame_73.Parent = G.Binds

-- UICorner_265 (UICorner)
G.UICorner_265 = Instance.new("UICorner")
G.UICorner_265.CornerRadius = UDim.new(1, 0)
G.UICorner_265.Parent = G.Frame_73

-- UIStroke_114 (UIStroke)
G.UIStroke_114 = Instance.new("UIStroke")
G.UIStroke_114.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_114.Transparency = 0.5
G.UIStroke_114.Parent = G.Frame_73

-- TextLabel_71 (TextLabel)
G.TextLabel_71 = Instance.new("TextLabel")
G.TextLabel_71.BackgroundTransparency = 1
G.TextLabel_71.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_71.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_71.ZIndex = 15
G.TextLabel_71.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_71.Text = "TP Down"
G.TextLabel_71.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_71.TextSize = 12
G.TextLabel_71.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_71.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_71.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_71.Parent = G.Frame_73

-- TextButton_16 (TextButton)
G.TextButton_16 = Instance.new("TextButton")
G.TextButton_16.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_16.BackgroundTransparency = 0.5
G.TextButton_16.BorderSizePixel = 0
G.TextButton_16.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_16.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_16.ZIndex = 15
G.TextButton_16.AutoButtonColor = false
G.TextButton_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_16.Text = "F"
G.TextButton_16.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_16.TextSize = 9
G.TextButton_16.Parent = G.Frame_73

-- UICorner_266 (UICorner)
G.UICorner_266 = Instance.new("UICorner")
G.UICorner_266.CornerRadius = UDim.new(0, 6)
G.UICorner_266.Parent = G.TextButton_16

-- UIStroke_115 (UIStroke)
G.UIStroke_115 = Instance.new("UIStroke")
G.UIStroke_115.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_115.Parent = G.TextButton_16

-- Frame_74 (Frame)
G.Frame_74 = Instance.new("Frame")
G.Frame_74.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_74.BackgroundTransparency = 0.079999998211860657
G.Frame_74.BorderSizePixel = 0
G.Frame_74.LayoutOrder = 9
G.Frame_74.Size = UDim2.new(1, -4, 0, 36)
G.Frame_74.ZIndex = 14
G.Frame_74.Parent = G.Binds

-- UICorner_267 (UICorner)
G.UICorner_267 = Instance.new("UICorner")
G.UICorner_267.CornerRadius = UDim.new(1, 0)
G.UICorner_267.Parent = G.Frame_74

-- UIStroke_116 (UIStroke)
G.UIStroke_116 = Instance.new("UIStroke")
G.UIStroke_116.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_116.Transparency = 0.5
G.UIStroke_116.Parent = G.Frame_74

-- TextLabel_72 (TextLabel)
G.TextLabel_72 = Instance.new("TextLabel")
G.TextLabel_72.BackgroundTransparency = 1
G.TextLabel_72.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_72.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_72.ZIndex = 15
G.TextLabel_72.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_72.Text = "Drop Brainrot"
G.TextLabel_72.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_72.TextSize = 12
G.TextLabel_72.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_72.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_72.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_72.Parent = G.Frame_74

-- TextButton_17 (TextButton)
G.TextButton_17 = Instance.new("TextButton")
G.TextButton_17.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_17.BackgroundTransparency = 0.5
G.TextButton_17.BorderSizePixel = 0
G.TextButton_17.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_17.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_17.ZIndex = 15
G.TextButton_17.AutoButtonColor = false
G.TextButton_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_17.Text = "J"
G.TextButton_17.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_17.TextSize = 9
G.TextButton_17.Parent = G.Frame_74

-- UICorner_268 (UICorner)
G.UICorner_268 = Instance.new("UICorner")
G.UICorner_268.CornerRadius = UDim.new(0, 6)
G.UICorner_268.Parent = G.TextButton_17

-- UIStroke_117 (UIStroke)
G.UIStroke_117 = Instance.new("UIStroke")
G.UIStroke_117.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_117.Parent = G.TextButton_17

-- Frame_75 (Frame)
G.Frame_75 = Instance.new("Frame")
G.Frame_75.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
G.Frame_75.BackgroundTransparency = 0.079999998211860657
G.Frame_75.BorderSizePixel = 0
G.Frame_75.LayoutOrder = 10
G.Frame_75.Size = UDim2.new(1, -4, 0, 36)
G.Frame_75.ZIndex = 14
G.Frame_75.Parent = G.Binds

-- UICorner_269 (UICorner)
G.UICorner_269 = Instance.new("UICorner")
G.UICorner_269.CornerRadius = UDim.new(1, 0)
G.UICorner_269.Parent = G.Frame_75

-- UIStroke_118 (UIStroke)
G.UIStroke_118 = Instance.new("UIStroke")
G.UIStroke_118.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_118.Transparency = 0.5
G.UIStroke_118.Parent = G.Frame_75

-- TextLabel_73 (TextLabel)
G.TextLabel_73 = Instance.new("TextLabel")
G.TextLabel_73.BackgroundTransparency = 1
G.TextLabel_73.Position = UDim2.new(0, 10, 0, 0)
G.TextLabel_73.Size = UDim2.new(0.55000001192092896, 0, 1, 0)
G.TextLabel_73.ZIndex = 15
G.TextLabel_73.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextLabel_73.Text = "Hide GUI"
G.TextLabel_73.TextColor3 = Color3.fromRGB(235, 235, 240)
G.TextLabel_73.TextSize = 12
G.TextLabel_73.TextStrokeTransparency = 0.64999997615814209
G.TextLabel_73.TextTruncate = Enum.TextTruncate.AtEnd
G.TextLabel_73.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_73.Parent = G.Frame_75

-- TextButton_18 (TextButton)
G.TextButton_18 = Instance.new("TextButton")
G.TextButton_18.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
G.TextButton_18.BackgroundTransparency = 0.5
G.TextButton_18.BorderSizePixel = 0
G.TextButton_18.Position = UDim2.new(1, -88, 0.5, -12)
G.TextButton_18.Size = UDim2.new(0, 80, 0, 24)
G.TextButton_18.ZIndex = 15
G.TextButton_18.AutoButtonColor = false
G.TextButton_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.TextButton_18.Text = "LeftControl"
G.TextButton_18.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextButton_18.TextSize = 9
G.TextButton_18.Parent = G.Frame_75

-- UICorner_270 (UICorner)
G.UICorner_270 = Instance.new("UICorner")
G.UICorner_270.CornerRadius = UDim.new(0, 6)
G.UICorner_270.Parent = G.TextButton_18

-- UIStroke_119 (UIStroke)
G.UIStroke_119 = Instance.new("UIStroke")
G.UIStroke_119.Color = Color3.fromRGB(50, 50, 50)
G.UIStroke_119.Parent = G.TextButton_18

-- Frame_76 (Frame)
G.Frame_76 = Instance.new("Frame")
G.Frame_76.BackgroundTransparency = 1
G.Frame_76.LayoutOrder = 11
G.Frame_76.Size = UDim2.new(1, 0, 0, 16)
G.Frame_76.ZIndex = 7
G.Frame_76.Parent = G.Binds

-- MenuParticles (Frame)
G.MenuParticles = Instance.new("Frame")
G.MenuParticles.Name = "MenuParticles"
G.MenuParticles.BackgroundTransparency = 1
G.MenuParticles.ClipsDescendants = true
G.MenuParticles.Size = UDim2.new(1, 0, 1, 0)
G.MenuParticles.Parent = G.Frame

-- Frame_77 (Frame)
G.Frame_77 = Instance.new("Frame")
G.Frame_77.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_77.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_77.BackgroundTransparency = 0.54133689403533936
G.Frame_77.BorderSizePixel = 0
G.Frame_77.Position = UDim2.new(0.95479387044906616, 0, 0.65190672874450684, 0)
G.Frame_77.Size = UDim2.new(0, 4, 0, 4)
G.Frame_77.ZIndex = 2
G.Frame_77.Parent = G.MenuParticles

-- UICorner_271 (UICorner)
G.UICorner_271 = Instance.new("UICorner")
G.UICorner_271.CornerRadius = UDim.new(1, 0)
G.UICorner_271.Parent = G.Frame_77

-- Frame_78 (Frame)
G.Frame_78 = Instance.new("Frame")
G.Frame_78.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_78.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_78.BackgroundTransparency = 0.44420981407165527
G.Frame_78.BorderSizePixel = 0
G.Frame_78.Position = UDim2.new(0.90883255004882812, 0, 0.49036785960197449, 0)
G.Frame_78.Size = UDim2.new(0, 3, 0, 4)
G.Frame_78.ZIndex = 2
G.Frame_78.Parent = G.MenuParticles

-- UICorner_272 (UICorner)
G.UICorner_272 = Instance.new("UICorner")
G.UICorner_272.CornerRadius = UDim.new(1, 0)
G.UICorner_272.Parent = G.Frame_78

-- Frame_79 (Frame)
G.Frame_79 = Instance.new("Frame")
G.Frame_79.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_79.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_79.BackgroundTransparency = 0.65382426977157593
G.Frame_79.BorderSizePixel = 0
G.Frame_79.Position = UDim2.new(0.7259446382522583, 0, 0.57578814029693604, 0)
G.Frame_79.Size = UDim2.new(0, 3, 0, 2)
G.Frame_79.ZIndex = 2
G.Frame_79.Parent = G.MenuParticles

-- UICorner_273 (UICorner)
G.UICorner_273 = Instance.new("UICorner")
G.UICorner_273.CornerRadius = UDim.new(1, 0)
G.UICorner_273.Parent = G.Frame_79

-- Frame_80 (Frame)
G.Frame_80 = Instance.new("Frame")
G.Frame_80.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_80.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_80.BackgroundTransparency = 0.39565590023994446
G.Frame_80.BorderSizePixel = 0
G.Frame_80.Position = UDim2.new(0.95084589719772339, 0, 0.97823017835617065, 0)
G.Frame_80.Size = UDim2.new(0, 4, 0, 3)
G.Frame_80.ZIndex = 2
G.Frame_80.Parent = G.MenuParticles

-- UICorner_274 (UICorner)
G.UICorner_274 = Instance.new("UICorner")
G.UICorner_274.CornerRadius = UDim.new(1, 0)
G.UICorner_274.Parent = G.Frame_80

-- Frame_81 (Frame)
G.Frame_81 = Instance.new("Frame")
G.Frame_81.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_81.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_81.BackgroundTransparency = 0.3962293267250061
G.Frame_81.BorderSizePixel = 0
G.Frame_81.Position = UDim2.new(0.29806691408157349, 0, 0.75714558362960815, 0)
G.Frame_81.Size = UDim2.new(0, 4, 0, 3)
G.Frame_81.ZIndex = 2
G.Frame_81.Parent = G.MenuParticles

-- UICorner_275 (UICorner)
G.UICorner_275 = Instance.new("UICorner")
G.UICorner_275.CornerRadius = UDim.new(1, 0)
G.UICorner_275.Parent = G.Frame_81

-- Frame_82 (Frame)
G.Frame_82 = Instance.new("Frame")
G.Frame_82.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_82.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_82.BackgroundTransparency = 0.59367150068283081
G.Frame_82.BorderSizePixel = 0
G.Frame_82.Position = UDim2.new(0.45660111308097839, 0, 0.88280099630355835, 0)
G.Frame_82.Size = UDim2.new(0, 3, 0, 4)
G.Frame_82.ZIndex = 2
G.Frame_82.Parent = G.MenuParticles

-- UICorner_276 (UICorner)
G.UICorner_276 = Instance.new("UICorner")
G.UICorner_276.CornerRadius = UDim.new(1, 0)
G.UICorner_276.Parent = G.Frame_82

-- Frame_83 (Frame)
G.Frame_83 = Instance.new("Frame")
G.Frame_83.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_83.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_83.BackgroundTransparency = 0.37110239267349243
G.Frame_83.BorderSizePixel = 0
G.Frame_83.Position = UDim2.new(0.11334896087646484, 0, 0.79100388288497925, 0)
G.Frame_83.Size = UDim2.new(0, 3, 0, 3)
G.Frame_83.ZIndex = 2
G.Frame_83.Parent = G.MenuParticles

-- UICorner_277 (UICorner)
G.UICorner_277 = Instance.new("UICorner")
G.UICorner_277.CornerRadius = UDim.new(1, 0)
G.UICorner_277.Parent = G.Frame_83

-- Frame_84 (Frame)
G.Frame_84 = Instance.new("Frame")
G.Frame_84.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_84.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_84.BackgroundTransparency = 0.57655388116836548
G.Frame_84.BorderSizePixel = 0
G.Frame_84.Position = UDim2.new(0.70914632081985474, 0, 0.79224073886871338, 0)
G.Frame_84.Size = UDim2.new(0, 3, 0, 4)
G.Frame_84.ZIndex = 2
G.Frame_84.Parent = G.MenuParticles

-- UICorner_278 (UICorner)
G.UICorner_278 = Instance.new("UICorner")
G.UICorner_278.CornerRadius = UDim.new(1, 0)
G.UICorner_278.Parent = G.Frame_84

-- Frame_85 (Frame)
G.Frame_85 = Instance.new("Frame")
G.Frame_85.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_85.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_85.BackgroundTransparency = 0.6947363018989563
G.Frame_85.BorderSizePixel = 0
G.Frame_85.Position = UDim2.new(0.97789311408996582, 0, 0.2647894024848938, 0)
G.Frame_85.Size = UDim2.new(0, 4, 0, 4)
G.Frame_85.ZIndex = 2
G.Frame_85.Parent = G.MenuParticles

-- UICorner_279 (UICorner)
G.UICorner_279 = Instance.new("UICorner")
G.UICorner_279.CornerRadius = UDim.new(1, 0)
G.UICorner_279.Parent = G.Frame_85

-- Frame_86 (Frame)
G.Frame_86 = Instance.new("Frame")
G.Frame_86.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_86.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_86.BackgroundTransparency = 0.3804839551448822
G.Frame_86.BorderSizePixel = 0
G.Frame_86.Position = UDim2.new(0.48624873161315918, 0, 0.51570791006088257, 0)
G.Frame_86.Size = UDim2.new(0, 4, 0, 3)
G.Frame_86.ZIndex = 2
G.Frame_86.Parent = G.MenuParticles

-- UICorner_280 (UICorner)
G.UICorner_280 = Instance.new("UICorner")
G.UICorner_280.CornerRadius = UDim.new(1, 0)
G.UICorner_280.Parent = G.Frame_86

-- Frame_87 (Frame)
G.Frame_87 = Instance.new("Frame")
G.Frame_87.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_87.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_87.BackgroundTransparency = 0.56846219301223755
G.Frame_87.BorderSizePixel = 0
G.Frame_87.Position = UDim2.new(0.81093418598175049, 0, 0.53800052404403687, 0)
G.Frame_87.Size = UDim2.new(0, 3, 0, 3)
G.Frame_87.ZIndex = 2
G.Frame_87.Parent = G.MenuParticles

-- UICorner_281 (UICorner)
G.UICorner_281 = Instance.new("UICorner")
G.UICorner_281.CornerRadius = UDim.new(1, 0)
G.UICorner_281.Parent = G.Frame_87

-- Frame_88 (Frame)
G.Frame_88 = Instance.new("Frame")
G.Frame_88.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_88.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_88.BackgroundTransparency = 0.54977560043334961
G.Frame_88.BorderSizePixel = 0
G.Frame_88.Position = UDim2.new(0.57876890897750854, 0, 0.23964041471481323, 0)
G.Frame_88.Size = UDim2.new(0, 2, 0, 4)
G.Frame_88.ZIndex = 2
G.Frame_88.Parent = G.MenuParticles

-- UICorner_282 (UICorner)
G.UICorner_282 = Instance.new("UICorner")
G.UICorner_282.CornerRadius = UDim.new(1, 0)
G.UICorner_282.Parent = G.Frame_88

-- Frame_89 (Frame)
G.Frame_89 = Instance.new("Frame")
G.Frame_89.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_89.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_89.BackgroundTransparency = 0.40927442908287048
G.Frame_89.BorderSizePixel = 0
G.Frame_89.Position = UDim2.new(0.2677672803401947, 0, 0.85715270042419434, 0)
G.Frame_89.Size = UDim2.new(0, 4, 0, 4)
G.Frame_89.ZIndex = 2
G.Frame_89.Parent = G.MenuParticles

-- UICorner_283 (UICorner)
G.UICorner_283 = Instance.new("UICorner")
G.UICorner_283.CornerRadius = UDim.new(1, 0)
G.UICorner_283.Parent = G.Frame_89

-- Frame_90 (Frame)
G.Frame_90 = Instance.new("Frame")
G.Frame_90.AnchorPoint = Vector2.new(0.5, 0.5)
G.Frame_90.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
G.Frame_90.BackgroundTransparency = 0.55766254663467407
G.Frame_90.BorderSizePixel = 0
G.Frame_90.Position = UDim2.new(0.58513706922531128, 0, 0.68233603239059448, 0)
G.Frame_90.Size = UDim2.new(0, 4, 0, 4)
G.Frame_90.ZIndex = 2
G.Frame_90.Parent = G.MenuParticles

-- UICorner_284 (UICorner)
G.UICorner_284 = Instance.new("UICorner")
G.UICorner_284.CornerRadius = UDim.new(1, 0)
G.UICorner_284.Parent = G.Frame_90

-- MenuPill (ImageButton)
G.MenuPill = Instance.new("ImageButton")
G.MenuPill.Name = "MenuPill"
G.MenuPill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
G.MenuPill.BorderSizePixel = 0
G.MenuPill.ClipsDescendants = true
G.MenuPill.Position = UDim2.new(0, 16, 0, 58)
G.MenuPill.Size = UDim2.new(0, 132, 0, 38)
G.MenuPill.Visible = false
G.MenuPill.ZIndex = 20
G.MenuPill.Image = "rbxassetid://90522270011044"
G.MenuPill.ImageTransparency = 0.079999998211860657
G.MenuPill.ScaleType = Enum.ScaleType.Crop
G.MenuPill.Parent = G.PrintedDuels

-- ThemeImg (ImageLabel)
G.ThemeImg = Instance.new("ImageLabel")
G.ThemeImg.Name = "ThemeImg"
G.ThemeImg.BackgroundTransparency = 1
G.ThemeImg.Size = UDim2.new(1, 0, 1, 0)
G.ThemeImg.Visible = false
G.ThemeImg.Image = "rbxassetid://127912104692615"
G.ThemeImg.ImageTransparency = 0.10000000149011612
G.ThemeImg.ScaleType = Enum.ScaleType.Crop
G.ThemeImg.Parent = G.MenuPill

-- UICorner_285 (UICorner)
G.UICorner_285 = Instance.new("UICorner")
G.UICorner_285.CornerRadius = UDim.new(1, 0)
G.UICorner_285.Parent = G.ThemeImg

-- UIScale_2 (UIScale)
G.UIScale_2 = Instance.new("UIScale")
G.UIScale_2.Parent = G.MenuPill

-- UICorner_286 (UICorner)
G.UICorner_286 = Instance.new("UICorner")
G.UICorner_286.CornerRadius = UDim.new(1, 0)
G.UICorner_286.Parent = G.MenuPill

-- MiniTitleImage (ImageLabel)
G.MiniTitleImage = Instance.new("ImageLabel")
G.MiniTitleImage.Name = "MiniTitleImage"
G.MiniTitleImage.AnchorPoint = Vector2.new(0.5, 0.5)
G.MiniTitleImage.BackgroundTransparency = 1
G.MiniTitleImage.Position = UDim2.new(0.5, 0, 0.5, 0)
G.MiniTitleImage.Size = UDim2.new(0.87999999523162842, 0, 0.87999999523162842, 0)
G.MiniTitleImage.ZIndex = 21
G.MiniTitleImage.ScaleType = Enum.ScaleType.Crop
G.MiniTitleImage.Parent = G.MenuPill

-- MenuLabel (TextLabel)
G.MenuLabel = Instance.new("TextLabel")
G.MenuLabel.Name = "MenuLabel"
G.MenuLabel.BackgroundTransparency = 1
G.MenuLabel.Position = UDim2.new(0, 8, 0, 0)
G.MenuLabel.Size = UDim2.new(1, -16, 1, 0)
G.MenuLabel.Visible = false
G.MenuLabel.ZIndex = 22
G.MenuLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.MenuLabel.Text = ""
G.MenuLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
G.MenuLabel.TextSize = 12
G.MenuLabel.Parent = G.MenuPill

-- UIStroke_120 (UIStroke)
G.UIStroke_120 = Instance.new("UIStroke")
G.UIStroke_120.Color = Color3.fromRGB(180, 180, 190)
G.UIStroke_120.Transparency = 0.44999998807907104
G.UIStroke_120.Parent = G.MenuPill

-- StealBar (Frame)
G.StealBar = Instance.new("Frame")
G.StealBar.Name = "StealBar"
G.StealBar.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
G.StealBar.BorderSizePixel = 0
G.StealBar.ClipsDescendants = true
G.StealBar.Position = UDim2.new(0.5, -150, 1, -98)
G.StealBar.Size = UDim2.new(0, 300, 0, 62)
G.StealBar.ZIndex = 17
G.StealBar.Parent = G.PrintedDuels

-- UICorner_287 (UICorner)
G.UICorner_287 = Instance.new("UICorner")
G.UICorner_287.CornerRadius = UDim.new(0, 12)
G.UICorner_287.Parent = G.StealBar

-- UIStroke_121 (UIStroke)
G.UIStroke_121 = Instance.new("UIStroke")
G.UIStroke_121.Color = Color3.fromRGB(6, 6, 8)
G.UIStroke_121.Thickness = 1.7999999523162842
G.UIStroke_121.Transparency = 1
G.UIStroke_121.Parent = G.StealBar

-- UIScale_3 (UIScale)
G.UIScale_3 = Instance.new("UIScale")
G.UIScale_3.Parent = G.StealBar

-- FillRegion (Frame)
G.FillRegion = Instance.new("Frame")
G.FillRegion.Name = "FillRegion"
G.FillRegion.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
G.FillRegion.BorderSizePixel = 0
G.FillRegion.ClipsDescendants = true
G.FillRegion.Position = UDim2.new(0, 10, 1, -24)
G.FillRegion.Size = UDim2.new(1, -20, 0, 14)
G.FillRegion.ZIndex = 18
G.FillRegion.Parent = G.StealBar

-- UICorner_288 (UICorner)
G.UICorner_288 = Instance.new("UICorner")
G.UICorner_288.CornerRadius = UDim.new(1, 0)
G.UICorner_288.Parent = G.FillRegion

-- Fill (Frame)
G.Fill = Instance.new("Frame")
G.Fill.Name = "Fill"
G.Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Fill.BorderSizePixel = 0
G.Fill.ClipsDescendants = true
G.Fill.Size = UDim2.new(0, 0, 1, 0)
G.Fill.ZIndex = 19
G.Fill.Parent = G.FillRegion

-- UICorner_289 (UICorner)
G.UICorner_289 = Instance.new("UICorner")
G.UICorner_289.CornerRadius = UDim.new(1, 0)
G.UICorner_289.Parent = G.Fill

-- UIGradient (UIGradient)
G.UIGradient = Instance.new("UIGradient")
G.UIGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 190, 80)), ColorSequenceKeypoint.new(0.55000001192092896, Color3.fromRGB(255, 145, 35)), ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 95, 15))})
G.UIGradient.Parent = G.Fill

-- BarParticle1 (Frame)
G.BarParticle1 = Instance.new("Frame")
G.BarParticle1.Name = "BarParticle1"
G.BarParticle1.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle1.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle1.BackgroundTransparency = 0.76245230436325073
G.BarParticle1.BorderSizePixel = 0
G.BarParticle1.Position = UDim2.new(0.94148951768875122, 0, 0.5, -2)
G.BarParticle1.Size = UDim2.new(0, 4, 0, 4)
G.BarParticle1.Visible = false
G.BarParticle1.ZIndex = 20
G.BarParticle1.Parent = G.Fill

-- UICorner_290 (UICorner)
G.UICorner_290 = Instance.new("UICorner")
G.UICorner_290.CornerRadius = UDim.new(1, 0)
G.UICorner_290.Parent = G.BarParticle1

-- BarParticle2 (Frame)
G.BarParticle2 = Instance.new("Frame")
G.BarParticle2.Name = "BarParticle2"
G.BarParticle2.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle2.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle2.BackgroundTransparency = 0.58746689558029175
G.BarParticle2.BorderSizePixel = 0
G.BarParticle2.Position = UDim2.new(0.37273114919662476, 0, 0.5, -2)
G.BarParticle2.Size = UDim2.new(0, 4, 0, 4)
G.BarParticle2.Visible = false
G.BarParticle2.ZIndex = 20
G.BarParticle2.Parent = G.Fill

-- UICorner_291 (UICorner)
G.UICorner_291 = Instance.new("UICorner")
G.UICorner_291.CornerRadius = UDim.new(1, 0)
G.UICorner_291.Parent = G.BarParticle2

-- BarParticle3 (Frame)
G.BarParticle3 = Instance.new("Frame")
G.BarParticle3.Name = "BarParticle3"
G.BarParticle3.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle3.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle3.BackgroundTransparency = 0.27351045608520508
G.BarParticle3.BorderSizePixel = 0
G.BarParticle3.Position = UDim2.new(0.50157004594802856, 0, 0.5, -1)
G.BarParticle3.Size = UDim2.new(0, 2, 0, 2)
G.BarParticle3.Visible = false
G.BarParticle3.ZIndex = 20
G.BarParticle3.Parent = G.Fill

-- UICorner_292 (UICorner)
G.UICorner_292 = Instance.new("UICorner")
G.UICorner_292.CornerRadius = UDim.new(1, 0)
G.UICorner_292.Parent = G.BarParticle3

-- BarParticle4 (Frame)
G.BarParticle4 = Instance.new("Frame")
G.BarParticle4.Name = "BarParticle4"
G.BarParticle4.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle4.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle4.BackgroundTransparency = 0.36856856942176819
G.BarParticle4.BorderSizePixel = 0
G.BarParticle4.Position = UDim2.new(0.71321934461593628, 0, 0.5, 2)
G.BarParticle4.Size = UDim2.new(0, 3, 0, 3)
G.BarParticle4.Visible = false
G.BarParticle4.ZIndex = 20
G.BarParticle4.Parent = G.Fill

-- UICorner_293 (UICorner)
G.UICorner_293 = Instance.new("UICorner")
G.UICorner_293.CornerRadius = UDim.new(1, 0)
G.UICorner_293.Parent = G.BarParticle4

-- BarParticle5 (Frame)
G.BarParticle5 = Instance.new("Frame")
G.BarParticle5.Name = "BarParticle5"
G.BarParticle5.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle5.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle5.BackgroundTransparency = 0.27455946803092957
G.BarParticle5.BorderSizePixel = 0
G.BarParticle5.Position = UDim2.new(0.10500697046518326, 0, 0.5, -1)
G.BarParticle5.Size = UDim2.new(0, 4, 0, 4)
G.BarParticle5.Visible = false
G.BarParticle5.ZIndex = 20
G.BarParticle5.Parent = G.Fill

-- UICorner_294 (UICorner)
G.UICorner_294 = Instance.new("UICorner")
G.UICorner_294.CornerRadius = UDim.new(1, 0)
G.UICorner_294.Parent = G.BarParticle5

-- BarParticle6 (Frame)
G.BarParticle6 = Instance.new("Frame")
G.BarParticle6.Name = "BarParticle6"
G.BarParticle6.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle6.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle6.BackgroundTransparency = 0.55888223648071289
G.BarParticle6.BorderSizePixel = 0
G.BarParticle6.Position = UDim2.new(0.58203727006912231, 0, 0.5, 2)
G.BarParticle6.Size = UDim2.new(0, 2, 0, 2)
G.BarParticle6.Visible = false
G.BarParticle6.ZIndex = 20
G.BarParticle6.Parent = G.Fill

-- UICorner_295 (UICorner)
G.UICorner_295 = Instance.new("UICorner")
G.UICorner_295.CornerRadius = UDim.new(1, 0)
G.UICorner_295.Parent = G.BarParticle6

-- BarParticle7 (Frame)
G.BarParticle7 = Instance.new("Frame")
G.BarParticle7.Name = "BarParticle7"
G.BarParticle7.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle7.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle7.BackgroundTransparency = 0.65187901258468628
G.BarParticle7.BorderSizePixel = 0
G.BarParticle7.Position = UDim2.new(0.021438194438815117, 0, 0.5, 2)
G.BarParticle7.Size = UDim2.new(0, 2, 0, 2)
G.BarParticle7.Visible = false
G.BarParticle7.ZIndex = 20
G.BarParticle7.Parent = G.Fill

-- UICorner_296 (UICorner)
G.UICorner_296 = Instance.new("UICorner")
G.UICorner_296.CornerRadius = UDim.new(1, 0)
G.UICorner_296.Parent = G.BarParticle7

-- BarParticle8 (Frame)
G.BarParticle8 = Instance.new("Frame")
G.BarParticle8.Name = "BarParticle8"
G.BarParticle8.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle8.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle8.BackgroundTransparency = 0.78217166662216187
G.BarParticle8.BorderSizePixel = 0
G.BarParticle8.Position = UDim2.new(0.24089303612709045, 0, 0.5, -1)
G.BarParticle8.Size = UDim2.new(0, 4, 0, 4)
G.BarParticle8.Visible = false
G.BarParticle8.ZIndex = 20
G.BarParticle8.Parent = G.Fill

-- UICorner_297 (UICorner)
G.UICorner_297 = Instance.new("UICorner")
G.UICorner_297.CornerRadius = UDim.new(1, 0)
G.UICorner_297.Parent = G.BarParticle8

-- BarParticle9 (Frame)
G.BarParticle9 = Instance.new("Frame")
G.BarParticle9.Name = "BarParticle9"
G.BarParticle9.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle9.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle9.BackgroundTransparency = 0.54272818565368652
G.BarParticle9.BorderSizePixel = 0
G.BarParticle9.Position = UDim2.new(0.044152729213237762, 0, 0.5, 2)
G.BarParticle9.Size = UDim2.new(0, 4, 0, 4)
G.BarParticle9.Visible = false
G.BarParticle9.ZIndex = 20
G.BarParticle9.Parent = G.Fill

-- UICorner_298 (UICorner)
G.UICorner_298 = Instance.new("UICorner")
G.UICorner_298.CornerRadius = UDim.new(1, 0)
G.UICorner_298.Parent = G.BarParticle9

-- BarParticle10 (Frame)
G.BarParticle10 = Instance.new("Frame")
G.BarParticle10.Name = "BarParticle10"
G.BarParticle10.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle10.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle10.BackgroundTransparency = 0.22400704026222229
G.BarParticle10.BorderSizePixel = 0
G.BarParticle10.Position = UDim2.new(0.75902336835861206, 0, 0.5, 2)
G.BarParticle10.Size = UDim2.new(0, 3, 0, 3)
G.BarParticle10.Visible = false
G.BarParticle10.ZIndex = 20
G.BarParticle10.Parent = G.Fill

-- UICorner_299 (UICorner)
G.UICorner_299 = Instance.new("UICorner")
G.UICorner_299.CornerRadius = UDim.new(1, 0)
G.UICorner_299.Parent = G.BarParticle10

-- BarParticle11 (Frame)
G.BarParticle11 = Instance.new("Frame")
G.BarParticle11.Name = "BarParticle11"
G.BarParticle11.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle11.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle11.BackgroundTransparency = 0.34319230914115906
G.BarParticle11.BorderSizePixel = 0
G.BarParticle11.Position = UDim2.new(0.97093331813812256, 0, 0.5, 2)
G.BarParticle11.Size = UDim2.new(0, 3, 0, 3)
G.BarParticle11.Visible = false
G.BarParticle11.ZIndex = 20
G.BarParticle11.Parent = G.Fill

-- UICorner_300 (UICorner)
G.UICorner_300 = Instance.new("UICorner")
G.UICorner_300.CornerRadius = UDim.new(1, 0)
G.UICorner_300.Parent = G.BarParticle11

-- BarParticle12 (Frame)
G.BarParticle12 = Instance.new("Frame")
G.BarParticle12.Name = "BarParticle12"
G.BarParticle12.AnchorPoint = Vector2.new(0.5, 0.5)
G.BarParticle12.BackgroundColor3 = Color3.fromRGB(255, 238, 190)
G.BarParticle12.BackgroundTransparency = 0.26204630732536316
G.BarParticle12.BorderSizePixel = 0
G.BarParticle12.Position = UDim2.new(0.74551737308502197, 0, 0.5, -1)
G.BarParticle12.Size = UDim2.new(0, 2, 0, 2)
G.BarParticle12.Visible = false
G.BarParticle12.ZIndex = 20
G.BarParticle12.Parent = G.Fill

-- UICorner_301 (UICorner)
G.UICorner_301 = Instance.new("UICorner")
G.UICorner_301.CornerRadius = UDim.new(1, 0)
G.UICorner_301.Parent = G.BarParticle12

-- DiscordFlash (TextLabel)
G.DiscordFlash = Instance.new("TextLabel")
G.DiscordFlash.Name = "DiscordFlash"
G.DiscordFlash.BackgroundTransparency = 1
G.DiscordFlash.Position = UDim2.new(0, 4, 0, 0)
G.DiscordFlash.Size = UDim2.new(1, -8, 1, 0)
G.DiscordFlash.ZIndex = 21
G.DiscordFlash.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.DiscordFlash.Text = "discord.gg/printed"
G.DiscordFlash.TextColor3 = Color3.fromRGB(255, 255, 255)
G.DiscordFlash.TextSize = 9
G.DiscordFlash.TextStrokeTransparency = 0.20000000298023224
G.DiscordFlash.TextTransparency = 0.65828096866607666
G.DiscordFlash.Parent = G.FillRegion

-- Pct (TextLabel)
G.Pct = Instance.new("TextLabel")
G.Pct.Name = "Pct"
G.Pct.BackgroundTransparency = 1
G.Pct.Position = UDim2.new(0, 10, 0, 4)
G.Pct.Size = UDim2.new(0, 70, 0, 18)
G.Pct.ZIndex = 20
G.Pct.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.Pct.Text = "0%"
G.Pct.TextColor3 = Color3.fromRGB(255, 255, 255)
G.Pct.TextSize = 14
G.Pct.TextXAlignment = Enum.TextXAlignment.Left
G.Pct.Parent = G.StealBar

-- FPSNeon (TextLabel)
G.FPSNeon = Instance.new("TextLabel")
G.FPSNeon.Name = "FPSNeon"
G.FPSNeon.BackgroundTransparency = 1
G.FPSNeon.Position = UDim2.new(0, 70, 0, 20)
G.FPSNeon.Size = UDim2.new(1, -140, 0, 14)
G.FPSNeon.ZIndex = 20
G.FPSNeon.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.FPSNeon.Text = "NORMAL GRAB"
G.FPSNeon.TextColor3 = Color3.fromRGB(210, 210, 215)
G.FPSNeon.TextScaled = true
G.FPSNeon.TextSize = 9
G.FPSNeon.TextWrapped = true
G.FPSNeon.Parent = G.StealBar

-- UITextSizeConstraint (UITextSizeConstraint)
G.UITextSizeConstraint = Instance.new("UITextSizeConstraint")
G.UITextSizeConstraint.MaxTextSize = 9
G.UITextSizeConstraint.MinTextSize = 7
G.UITextSizeConstraint.Parent = G.FPSNeon

-- PingLbl (TextLabel)
G.PingLbl = Instance.new("TextLabel")
G.PingLbl.Name = "PingLbl"
G.PingLbl.BackgroundTransparency = 1
G.PingLbl.Position = UDim2.new(1, -78, 0, 20)
G.PingLbl.Size = UDim2.new(0, 68, 0, 14)
G.PingLbl.ZIndex = 20
G.PingLbl.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.PingLbl.Text = "PING: 213ms"
G.PingLbl.TextColor3 = Color3.fromRGB(210, 210, 215)
G.PingLbl.TextSize = 9
G.PingLbl.TextXAlignment = Enum.TextXAlignment.Right
G.PingLbl.Parent = G.StealBar

-- FPSLabel (TextLabel)
G.FPSLabel = Instance.new("TextLabel")
G.FPSLabel.Name = "FPSLabel"
G.FPSLabel.BackgroundTransparency = 1
G.FPSLabel.Position = UDim2.new(0, 10, 0, 20)
G.FPSLabel.Size = UDim2.new(0, 60, 0, 14)
G.FPSLabel.ZIndex = 20
G.FPSLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G.FPSLabel.Text = "FPS: 49"
G.FPSLabel.TextColor3 = Color3.fromRGB(210, 210, 215)
G.FPSLabel.TextSize = 9
G.FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
G.FPSLabel.Parent = G.StealBar

-- mount
G.PrintedDuels.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

return G.PrintedDuels