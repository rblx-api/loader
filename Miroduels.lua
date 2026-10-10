--// MIRO HUB
--discord.gg/kastorhub
--LEKAD BY FRNK33.
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

BirdHub_1 = Instance.new("ScreenGui")
BirdHub_1.Name = "BirdHub"
BirdHub_1.DisplayOrder = 10
BirdHub_1.IgnoreGuiInset = true
BirdHub_1.ResetOnSpawn = false
BirdHub_1.Parent = CoreGui

Frame_2 = Instance.new("Frame")
Frame_2.Position = UDim2.new(0, 20, 0, 20)
Frame_2.Size = UDim2.new(0, 360, 0, 410)
Frame_2.BackgroundColor3 = Color3.fromRGB(6, 4, 10)
Frame_2.BackgroundTransparency = 1
Frame_2.BorderSizePixel = 0
Frame_2.Parent = BirdHub_1

UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 14)
UICorner_3.Parent = Frame_2

UIStroke_4 = Instance.new("UIStroke")
UIStroke_4.Color = Color3.fromRGB(60, 40, 90)
UIStroke_4.Thickness = 1
UIStroke_4.Parent = Frame_2

UIGradient_5 = Instance.new("UIGradient")
UIGradient_5.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 12, 32)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(6, 4, 10)), ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 6, 20))})
UIGradient_5.Rotation = 135
UIGradient_5.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})
UIGradient_5.Parent = Frame_2

ImageLabel_6 = Instance.new("ImageLabel")
ImageLabel_6.Position = UDim2.new(0, 0, 0, 0)
ImageLabel_6.Size = UDim2.new(1, 0, 1, 0)
ImageLabel_6.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
ImageLabel_6.BackgroundTransparency = 1
ImageLabel_6.BorderSizePixel = 1
ImageLabel_6.ZIndex = 2
ImageLabel_6.Image = "rbxassetid://138039687036589"
ImageLabel_6.ImageColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_6.ScaleType = Enum.ScaleType.Crop
ImageLabel_6.Parent = Frame_2

UICorner_7 = Instance.new("UICorner")
UICorner_7.CornerRadius = UDim.new(0, 14)
UICorner_7.Parent = ImageLabel_6

BgGradient_8 = Instance.new("Frame")
BgGradient_8.Name = "BgGradient"
BgGradient_8.Position = UDim2.new(0, 0, 0, 0)
BgGradient_8.Size = UDim2.new(1, 0, 1, 0)
BgGradient_8.BackgroundColor3 = Color3.fromRGB(15, 10, 18)
BgGradient_8.BorderSizePixel = 0
BgGradient_8.ZIndex = 0
BgGradient_8.Parent = Frame_2

UICorner_9 = Instance.new("UICorner")
UICorner_9.CornerRadius = UDim.new(0, 14)
UICorner_9.Parent = BgGradient_8

UIGradient_10 = Instance.new("UIGradient")
UIGradient_10.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 12, 30)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 10, 18)), ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 10, 25))})
UIGradient_10.Rotation = 135
UIGradient_10.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})
UIGradient_10.Parent = BgGradient_8

Frame_11 = Instance.new("Frame")
Frame_11.Position = UDim2.new(0, 0, 0, 0)
Frame_11.Size = UDim2.new(1, 0, 0, 50)
Frame_11.BackgroundColor3 = Color3.fromRGB(11, 8, 18)
Frame_11.BackgroundTransparency = 1
Frame_11.BorderSizePixel = 0
Frame_11.Parent = Frame_2

UICorner_12 = Instance.new("UICorner")
UICorner_12.CornerRadius = UDim.new(0, 14)
UICorner_12.Parent = Frame_11

UIGradient_13 = Instance.new("UIGradient")
UIGradient_13.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 15, 55)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(11, 8, 18)), ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 40))})
UIGradient_13.Rotation = 90
UIGradient_13.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})
UIGradient_13.Parent = Frame_11

Frame_14 = Instance.new("Frame")
Frame_14.Position = UDim2.new(0.07500000298023224, 0, 1, -1)
Frame_14.Size = UDim2.new(0.8500000238418579, 0, 0, 1)
Frame_14.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
Frame_14.BackgroundTransparency = 0.4000000059604645
Frame_14.BorderSizePixel = 0
Frame_14.Parent = Frame_11

UIGradient_15 = Instance.new("UIGradient")
UIGradient_15.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
UIGradient_15.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.30000001192092896, 0), NumberSequenceKeypoint.new(0.699999988079071, 0), NumberSequenceKeypoint.new(1, 1)})
UIGradient_15.Parent = Frame_14

Frame_16 = Instance.new("Frame")
Frame_16.Position = UDim2.new(0, 10, 0.5, -16)
Frame_16.Size = UDim2.new(0, 32, 0, 32)
Frame_16.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame_16.BackgroundTransparency = 0.4000000059604645
Frame_16.BorderSizePixel = 0
Frame_16.Parent = Frame_11

UICorner_17 = Instance.new("UICorner")
UICorner_17.CornerRadius = UDim.new(0, 6)
UICorner_17.Parent = Frame_16

UIStroke_18 = Instance.new("UIStroke")
UIStroke_18.Color = Color3.fromRGB(185, 120, 255)
UIStroke_18.Thickness = 1
UIStroke_18.Transparency = 0.30000001192092896
UIStroke_18.Parent = Frame_16

ImageLabel_19 = Instance.new("ImageLabel")
ImageLabel_19.Position = UDim2.new(0, 2, 0, 2)
ImageLabel_19.Size = UDim2.new(1, -4, 1, -4)
ImageLabel_19.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
ImageLabel_19.BackgroundTransparency = 1
ImageLabel_19.BorderSizePixel = 1
ImageLabel_19.ZIndex = 5
ImageLabel_19.Image = "rbxassetid://94721565913784"
ImageLabel_19.ImageColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel_19.ScaleType = Enum.ScaleType.Fit
ImageLabel_19.Parent = Frame_16

UICorner_20 = Instance.new("UICorner")
UICorner_20.CornerRadius = UDim.new(0, 4)
UICorner_20.Parent = ImageLabel_19

TextLabel_21 = Instance.new("TextLabel")
TextLabel_21.Position = UDim2.new(0, 50, 0, 2)
TextLabel_21.Size = UDim2.new(1, -150, 1, -14)
TextLabel_21.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_21.BackgroundTransparency = 1
TextLabel_21.BorderSizePixel = 1
TextLabel_21.Text = "MIRO | DUELS"
TextLabel_21.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_21.TextSize = 15
TextLabel_21.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_21.Font = Enum.Font.GothamBlack
TextLabel_21.Parent = Frame_11

TextLabel_22 = Instance.new("TextLabel")
TextLabel_22.Position = UDim2.new(1, -108, 0.5, -8)
TextLabel_22.Size = UDim2.new(0, 100, 0, 16)
TextLabel_22.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_22.BackgroundTransparency = 1
TextLabel_22.BorderSizePixel = 1
TextLabel_22.Text = ".gg/miroduels"
TextLabel_22.TextColor3 = Color3.fromRGB(190, 170, 230)
TextLabel_22.TextSize = 10
TextLabel_22.TextXAlignment = Enum.TextXAlignment.Right
TextLabel_22.Font = Enum.Font.GothamBold
TextLabel_22.Parent = Frame_11

TextLabel_23 = Instance.new("TextLabel")
TextLabel_23.Position = UDim2.new(0, 50, 1, -16)
TextLabel_23.Size = UDim2.new(0, 130, 0, 13)
TextLabel_23.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_23.BackgroundTransparency = 1
TextLabel_23.BorderSizePixel = 1
TextLabel_23.ZIndex = 6
TextLabel_23.Text = "Ping: 290ms | FPS: 60"
TextLabel_23.TextColor3 = Color3.fromRGB(160, 110, 210)
TextLabel_23.TextSize = 9
TextLabel_23.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_23.Font = Enum.Font.GothamBold
TextLabel_23.Parent = Frame_11

TextButton_24 = Instance.new("TextButton")
TextButton_24.Position = UDim2.new(1, -34, 0.5, -14)
TextButton_24.Size = UDim2.new(0, 28, 0, 28)
TextButton_24.BackgroundColor3 = Color3.fromRGB(11, 8, 18)
TextButton_24.BorderSizePixel = 0
TextButton_24.Active = true
TextButton_24.Text = "-"
TextButton_24.TextColor3 = Color3.fromRGB(130, 85, 210)
TextButton_24.TextSize = 22
TextButton_24.Font = Enum.Font.GothamBold
TextButton_24.Parent = Frame_11

UICorner_25 = Instance.new("UICorner")
UICorner_25.CornerRadius = UDim.new(0, 6)
UICorner_25.Parent = TextButton_24

Frame_26 = Instance.new("Frame")
Frame_26.Position = UDim2.new(1, -84, 0, 54)
Frame_26.Size = UDim2.new(0, 76, 1, -58)
Frame_26.BackgroundColor3 = Color3.fromRGB(12, 8, 22)
Frame_26.BackgroundTransparency = 1
Frame_26.BorderSizePixel = 0
Frame_26.ZIndex = 3
Frame_26.Parent = Frame_2

UICorner_27 = Instance.new("UICorner")
UICorner_27.CornerRadius = UDim.new(0, 8)
UICorner_27.Parent = Frame_26

UIListLayout_28 = Instance.new("UIListLayout")
UIListLayout_28.FillDirection = Enum.FillDirection.Vertical
UIListLayout_28.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_28.Padding = UDim.new(0, 2)
UIListLayout_28.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout_28.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout_28.Parent = Frame_26

UIPadding_29 = Instance.new("UIPadding")
UIPadding_29.PaddingTop = UDim.new(0, 3)
UIPadding_29.PaddingBottom = UDim.new(0, 3)
UIPadding_29.PaddingLeft = UDim.new(0, 3)
UIPadding_29.PaddingRight = UDim.new(0, 3)
UIPadding_29.Parent = Frame_26

TextButton_30 = Instance.new("TextButton")
TextButton_30.Position = UDim2.new(0, 0, 0, 0)
TextButton_30.Size = UDim2.new(1, 0, 0, 28)
TextButton_30.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TextButton_30.BackgroundTransparency = 0.050000011920928955
TextButton_30.BorderSizePixel = 0
TextButton_30.LayoutOrder = 1
TextButton_30.Active = true
TextButton_30.Text = "Speed"
TextButton_30.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_30.TextSize = 11
TextButton_30.Font = Enum.Font.GothamBold
TextButton_30.Parent = Frame_26

UICorner_31 = Instance.new("UICorner")
UICorner_31.CornerRadius = UDim.new(0, 6)
UICorner_31.Parent = TextButton_30

UIStroke_32 = Instance.new("UIStroke")
UIStroke_32.Color = Color3.fromRGB(185, 120, 255)
UIStroke_32.Thickness = 1
UIStroke_32.Transparency = 0.30000001192092896
UIStroke_32.Parent = TextButton_30

ActiveStripe_33 = Instance.new("Frame")
ActiveStripe_33.Name = "ActiveStripe"
ActiveStripe_33.Position = UDim2.new(0, 3, 0.20000000298023224, 0)
ActiveStripe_33.Size = UDim2.new(0, 2, 0.6000000238418579, 0)
ActiveStripe_33.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
ActiveStripe_33.BorderSizePixel = 0
ActiveStripe_33.Parent = TextButton_30

UICorner_34 = Instance.new("UICorner")
UICorner_34.CornerRadius = UDim.new(0, 2)
UICorner_34.Parent = ActiveStripe_33

TextButton_35 = Instance.new("TextButton")
TextButton_35.Position = UDim2.new(0, 0, 0, 0)
TextButton_35.Size = UDim2.new(1, 0, 0, 28)
TextButton_35.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TextButton_35.BackgroundTransparency = 1
TextButton_35.BorderSizePixel = 0
TextButton_35.LayoutOrder = 2
TextButton_35.Active = true
TextButton_35.Text = "Combat"
TextButton_35.TextColor3 = Color3.fromRGB(190, 170, 230)
TextButton_35.TextSize = 11
TextButton_35.Font = Enum.Font.GothamBold
TextButton_35.Parent = Frame_26

UICorner_36 = Instance.new("UICorner")
UICorner_36.CornerRadius = UDim.new(0, 6)
UICorner_36.Parent = TextButton_35

UIStroke_37 = Instance.new("UIStroke")
UIStroke_37.Color = Color3.fromRGB(185, 120, 255)
UIStroke_37.Thickness = 1
UIStroke_37.Transparency = 1
UIStroke_37.Parent = TextButton_35

ActiveStripe_38 = Instance.new("Frame")
ActiveStripe_38.Name = "ActiveStripe"
ActiveStripe_38.Position = UDim2.new(0, 3, 0.20000000298023224, 0)
ActiveStripe_38.Size = UDim2.new(0, 2, 0.6000000238418579, 0)
ActiveStripe_38.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
ActiveStripe_38.BackgroundTransparency = 1
ActiveStripe_38.BorderSizePixel = 0
ActiveStripe_38.Parent = TextButton_35

UICorner_39 = Instance.new("UICorner")
UICorner_39.CornerRadius = UDim.new(0, 2)
UICorner_39.Parent = ActiveStripe_38

TextButton_40 = Instance.new("TextButton")
TextButton_40.Position = UDim2.new(0, 0, 0, 0)
TextButton_40.Size = UDim2.new(1, 0, 0, 28)
TextButton_40.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TextButton_40.BackgroundTransparency = 1
TextButton_40.BorderSizePixel = 0
TextButton_40.LayoutOrder = 3
TextButton_40.Active = true
TextButton_40.Text = "Steal"
TextButton_40.TextColor3 = Color3.fromRGB(190, 170, 230)
TextButton_40.TextSize = 11
TextButton_40.Font = Enum.Font.GothamBold
TextButton_40.Parent = Frame_26

UICorner_41 = Instance.new("UICorner")
UICorner_41.CornerRadius = UDim.new(0, 6)
UICorner_41.Parent = TextButton_40

UIStroke_42 = Instance.new("UIStroke")
UIStroke_42.Color = Color3.fromRGB(185, 120, 255)
UIStroke_42.Thickness = 1
UIStroke_42.Transparency = 1
UIStroke_42.Parent = TextButton_40

ActiveStripe_43 = Instance.new("Frame")
ActiveStripe_43.Name = "ActiveStripe"
ActiveStripe_43.Position = UDim2.new(0, 3, 0.20000000298023224, 0)
ActiveStripe_43.Size = UDim2.new(0, 2, 0.6000000238418579, 0)
ActiveStripe_43.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
ActiveStripe_43.BackgroundTransparency = 1
ActiveStripe_43.BorderSizePixel = 0
ActiveStripe_43.Parent = TextButton_40

UICorner_44 = Instance.new("UICorner")
UICorner_44.CornerRadius = UDim.new(0, 2)
UICorner_44.Parent = ActiveStripe_43

TextButton_45 = Instance.new("TextButton")
TextButton_45.Position = UDim2.new(0, 0, 0, 0)
TextButton_45.Size = UDim2.new(1, 0, 0, 28)
TextButton_45.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TextButton_45.BackgroundTransparency = 1
TextButton_45.BorderSizePixel = 0
TextButton_45.LayoutOrder = 4
TextButton_45.Active = true
TextButton_45.Text = "Visual"
TextButton_45.TextColor3 = Color3.fromRGB(190, 170, 230)
TextButton_45.TextSize = 11
TextButton_45.Font = Enum.Font.GothamBold
TextButton_45.Parent = Frame_26

UICorner_46 = Instance.new("UICorner")
UICorner_46.CornerRadius = UDim.new(0, 6)
UICorner_46.Parent = TextButton_45

UIStroke_47 = Instance.new("UIStroke")
UIStroke_47.Color = Color3.fromRGB(185, 120, 255)
UIStroke_47.Thickness = 1
UIStroke_47.Transparency = 1
UIStroke_47.Parent = TextButton_45

ActiveStripe_48 = Instance.new("Frame")
ActiveStripe_48.Name = "ActiveStripe"
ActiveStripe_48.Position = UDim2.new(0, 3, 0.20000000298023224, 0)
ActiveStripe_48.Size = UDim2.new(0, 2, 0.6000000238418579, 0)
ActiveStripe_48.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
ActiveStripe_48.BackgroundTransparency = 1
ActiveStripe_48.BorderSizePixel = 0
ActiveStripe_48.Parent = TextButton_45

UICorner_49 = Instance.new("UICorner")
UICorner_49.CornerRadius = UDim.new(0, 2)
UICorner_49.Parent = ActiveStripe_48

TextButton_50 = Instance.new("TextButton")
TextButton_50.Position = UDim2.new(0, 0, 0, 0)
TextButton_50.Size = UDim2.new(1, 0, 0, 28)
TextButton_50.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TextButton_50.BackgroundTransparency = 1
TextButton_50.BorderSizePixel = 0
TextButton_50.LayoutOrder = 5
TextButton_50.Active = true
TextButton_50.Text = "Interface"
TextButton_50.TextColor3 = Color3.fromRGB(190, 170, 230)
TextButton_50.TextSize = 11
TextButton_50.Font = Enum.Font.GothamBold
TextButton_50.Parent = Frame_26

UICorner_51 = Instance.new("UICorner")
UICorner_51.CornerRadius = UDim.new(0, 6)
UICorner_51.Parent = TextButton_50

UIStroke_52 = Instance.new("UIStroke")
UIStroke_52.Color = Color3.fromRGB(185, 120, 255)
UIStroke_52.Thickness = 1
UIStroke_52.Transparency = 1
UIStroke_52.Parent = TextButton_50

ActiveStripe_53 = Instance.new("Frame")
ActiveStripe_53.Name = "ActiveStripe"
ActiveStripe_53.Position = UDim2.new(0, 3, 0.20000000298023224, 0)
ActiveStripe_53.Size = UDim2.new(0, 2, 0.6000000238418579, 0)
ActiveStripe_53.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
ActiveStripe_53.BackgroundTransparency = 1
ActiveStripe_53.BorderSizePixel = 0
ActiveStripe_53.Parent = TextButton_50

UICorner_54 = Instance.new("UICorner")
UICorner_54.CornerRadius = UDim.new(0, 2)
UICorner_54.Parent = ActiveStripe_53

Frame_55 = Instance.new("Frame")
Frame_55.Position = UDim2.new(0, 4, 0, 54)
Frame_55.Size = UDim2.new(1, -88, 1, -56)
Frame_55.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_55.BackgroundTransparency = 1
Frame_55.BorderSizePixel = 0
Frame_55.ZIndex = 3
Frame_55.Parent = Frame_2

Page_Speed_56 = Instance.new("ScrollingFrame")
Page_Speed_56.Name = "Page_Speed"
Page_Speed_56.Position = UDim2.new(0, 0, 0, 0)
Page_Speed_56.Size = UDim2.new(1, 0, 1, 0)
Page_Speed_56.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Page_Speed_56.BackgroundTransparency = 1
Page_Speed_56.BorderSizePixel = 0
Page_Speed_56.ClipsDescendants = true
Page_Speed_56.CanvasSize = UDim2.new(0, 0, 0, 0)
Page_Speed_56.ScrollBarThickness = 0
Page_Speed_56.ScrollingDirection = Enum.ScrollingDirection.XY
Page_Speed_56.Parent = Frame_55

UIListLayout_57 = Instance.new("UIListLayout")
UIListLayout_57.FillDirection = Enum.FillDirection.Vertical
UIListLayout_57.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_57.Padding = UDim.new(0, 4)
UIListLayout_57.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout_57.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout_57.Parent = Page_Speed_56

UIPadding_58 = Instance.new("UIPadding")
UIPadding_58.PaddingTop = UDim.new(0, 6)
UIPadding_58.PaddingBottom = UDim.new(0, 10)
UIPadding_58.PaddingLeft = UDim.new(0, 6)
UIPadding_58.PaddingRight = UDim.new(0, 6)
UIPadding_58.Parent = Page_Speed_56

Frame_59 = Instance.new("Frame")
Frame_59.Position = UDim2.new(0, 0, 0, 0)
Frame_59.Size = UDim2.new(1, 0, 0, 2)
Frame_59.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_59.BackgroundTransparency = 1
Frame_59.BorderSizePixel = 0
Frame_59.LayoutOrder = 1
Frame_59.Parent = Page_Speed_56

TextLabel_60 = Instance.new("TextLabel")
TextLabel_60.Position = UDim2.new(0, 8, 0, 0)
TextLabel_60.Size = UDim2.new(1, -8, 1, 0)
TextLabel_60.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_60.BackgroundTransparency = 1
TextLabel_60.BorderSizePixel = 1
TextLabel_60.Text = "SPEED"
TextLabel_60.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_60.TextSize = 8
TextLabel_60.Parent = Frame_59

Frame_61 = Instance.new("Frame")
Frame_61.Position = UDim2.new(0, 0, 0, 0)
Frame_61.Size = UDim2.new(1, 0, 0, 4)
Frame_61.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_61.BackgroundTransparency = 1
Frame_61.BorderSizePixel = 0
Frame_61.LayoutOrder = 2
Frame_61.Parent = Page_Speed_56

Frame_62 = Instance.new("Frame")
Frame_62.Position = UDim2.new(0, 0, 0, 0)
Frame_62.Size = UDim2.new(1, 0, 0, 18)
Frame_62.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_62.BackgroundTransparency = 1
Frame_62.BorderSizePixel = 0
Frame_62.LayoutOrder = 3
Frame_62.Parent = Page_Speed_56

TextLabel_63 = Instance.new("TextLabel")
TextLabel_63.Position = UDim2.new(0, 8, 0, 0)
TextLabel_63.Size = UDim2.new(1, -8, 1, 0)
TextLabel_63.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_63.BackgroundTransparency = 1
TextLabel_63.BorderSizePixel = 1
TextLabel_63.Text = "SPEED"
TextLabel_63.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_63.TextSize = 9
TextLabel_63.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_63.Font = Enum.Font.GothamBlack
TextLabel_63.Parent = Frame_62

Frame_64 = Instance.new("Frame")
Frame_64.Position = UDim2.new(0, 0, 0, 0)
Frame_64.Size = UDim2.new(1, 0, 0, 32)
Frame_64.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_64.BorderSizePixel = 0
Frame_64.LayoutOrder = 4
Frame_64.Parent = Page_Speed_56

UICorner_65 = Instance.new("UICorner")
UICorner_65.CornerRadius = UDim.new(0, 10)
UICorner_65.Parent = Frame_64

UIStroke_66 = Instance.new("UIStroke")
UIStroke_66.Color = Color3.fromRGB(28, 28, 34)
UIStroke_66.Thickness = 1
UIStroke_66.Parent = Frame_64

TextLabel_67 = Instance.new("TextLabel")
TextLabel_67.Position = UDim2.new(0, 9, 0, 0)
TextLabel_67.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_67.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_67.BackgroundTransparency = 1
TextLabel_67.BorderSizePixel = 1
TextLabel_67.Text = "Normal Speed"
TextLabel_67.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_67.TextSize = 11
TextLabel_67.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_67.Font = Enum.Font.GothamBold
TextLabel_67.Parent = Frame_64

TextBox_68 = Instance.new("TextBox")
TextBox_68.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_68.Size = UDim2.new(0, 50, 0, 22)
TextBox_68.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_68.BorderSizePixel = 0
TextBox_68.ZIndex = 5
TextBox_68.Active = true
TextBox_68.Text = "60"
TextBox_68.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_68.TextSize = 11
TextBox_68.Font = Enum.Font.GothamBold
TextBox_68.Parent = Frame_64

UICorner_69 = Instance.new("UICorner")
UICorner_69.CornerRadius = UDim.new(0, 5)
UICorner_69.Parent = TextBox_68

UIStroke_70 = Instance.new("UIStroke")
UIStroke_70.Color = Color3.fromRGB(140, 90, 200)
UIStroke_70.Thickness = 1
UIStroke_70.Parent = TextBox_68

Frame_71 = Instance.new("Frame")
Frame_71.Position = UDim2.new(0, 0, 0, 0)
Frame_71.Size = UDim2.new(1, 0, 0, 32)
Frame_71.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_71.BorderSizePixel = 0
Frame_71.LayoutOrder = 5
Frame_71.Parent = Page_Speed_56

UICorner_72 = Instance.new("UICorner")
UICorner_72.CornerRadius = UDim.new(0, 10)
UICorner_72.Parent = Frame_71

UIStroke_73 = Instance.new("UIStroke")
UIStroke_73.Color = Color3.fromRGB(28, 28, 34)
UIStroke_73.Thickness = 1
UIStroke_73.Parent = Frame_71

TextLabel_74 = Instance.new("TextLabel")
TextLabel_74.Position = UDim2.new(0, 9, 0, 0)
TextLabel_74.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_74.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_74.BackgroundTransparency = 1
TextLabel_74.BorderSizePixel = 1
TextLabel_74.Text = "Carry Speed"
TextLabel_74.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_74.TextSize = 11
TextLabel_74.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_74.Font = Enum.Font.GothamBold
TextLabel_74.Parent = Frame_71

TextBox_75 = Instance.new("TextBox")
TextBox_75.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_75.Size = UDim2.new(0, 50, 0, 22)
TextBox_75.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_75.BorderSizePixel = 0
TextBox_75.ZIndex = 5
TextBox_75.Active = true
TextBox_75.Text = "30"
TextBox_75.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_75.TextSize = 11
TextBox_75.Font = Enum.Font.GothamBold
TextBox_75.Parent = Frame_71

UICorner_76 = Instance.new("UICorner")
UICorner_76.CornerRadius = UDim.new(0, 5)
UICorner_76.Parent = TextBox_75

UIStroke_77 = Instance.new("UIStroke")
UIStroke_77.Color = Color3.fromRGB(140, 90, 200)
UIStroke_77.Thickness = 1
UIStroke_77.Parent = TextBox_75

Frame_78 = Instance.new("Frame")
Frame_78.Position = UDim2.new(0, 0, 0, 0)
Frame_78.Size = UDim2.new(1, 0, 0, 32)
Frame_78.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_78.BorderSizePixel = 0
Frame_78.LayoutOrder = 6
Frame_78.Parent = Page_Speed_56

UICorner_79 = Instance.new("UICorner")
UICorner_79.CornerRadius = UDim.new(0, 10)
UICorner_79.Parent = Frame_78

UIStroke_80 = Instance.new("UIStroke")
UIStroke_80.Color = Color3.fromRGB(28, 28, 34)
UIStroke_80.Thickness = 1
UIStroke_80.Parent = Frame_78

TextLabel_81 = Instance.new("TextLabel")
TextLabel_81.Position = UDim2.new(0, 9, 0, 0)
TextLabel_81.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_81.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_81.BackgroundTransparency = 1
TextLabel_81.BorderSizePixel = 1
TextLabel_81.Text = "Lagger Normal Speed"
TextLabel_81.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_81.TextSize = 11
TextLabel_81.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_81.Font = Enum.Font.GothamBold
TextLabel_81.Parent = Frame_78

TextBox_82 = Instance.new("TextBox")
TextBox_82.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_82.Size = UDim2.new(0, 50, 0, 22)
TextBox_82.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_82.BorderSizePixel = 0
TextBox_82.ZIndex = 5
TextBox_82.Active = true
TextBox_82.Text = "15"
TextBox_82.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_82.TextSize = 11
TextBox_82.Font = Enum.Font.GothamBold
TextBox_82.Parent = Frame_78

UICorner_83 = Instance.new("UICorner")
UICorner_83.CornerRadius = UDim.new(0, 5)
UICorner_83.Parent = TextBox_82

UIStroke_84 = Instance.new("UIStroke")
UIStroke_84.Color = Color3.fromRGB(140, 90, 200)
UIStroke_84.Thickness = 1
UIStroke_84.Parent = TextBox_82

Frame_85 = Instance.new("Frame")
Frame_85.Position = UDim2.new(0, 0, 0, 0)
Frame_85.Size = UDim2.new(1, 0, 0, 32)
Frame_85.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_85.BorderSizePixel = 0
Frame_85.LayoutOrder = 7
Frame_85.Parent = Page_Speed_56

UICorner_86 = Instance.new("UICorner")
UICorner_86.CornerRadius = UDim.new(0, 10)
UICorner_86.Parent = Frame_85

UIStroke_87 = Instance.new("UIStroke")
UIStroke_87.Color = Color3.fromRGB(28, 28, 34)
UIStroke_87.Thickness = 1
UIStroke_87.Parent = Frame_85

TextLabel_88 = Instance.new("TextLabel")
TextLabel_88.Position = UDim2.new(0, 9, 0, 0)
TextLabel_88.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_88.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_88.BackgroundTransparency = 1
TextLabel_88.BorderSizePixel = 1
TextLabel_88.Text = "Lagger Carry Speed"
TextLabel_88.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_88.TextSize = 11
TextLabel_88.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_88.Font = Enum.Font.GothamBold
TextLabel_88.Parent = Frame_85

TextBox_89 = Instance.new("TextBox")
TextBox_89.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_89.Size = UDim2.new(0, 50, 0, 22)
TextBox_89.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_89.BorderSizePixel = 0
TextBox_89.ZIndex = 5
TextBox_89.Active = true
TextBox_89.Text = "24.5"
TextBox_89.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_89.TextSize = 11
TextBox_89.Font = Enum.Font.GothamBold
TextBox_89.Parent = Frame_85

UICorner_90 = Instance.new("UICorner")
UICorner_90.CornerRadius = UDim.new(0, 5)
UICorner_90.Parent = TextBox_89

UIStroke_91 = Instance.new("UIStroke")
UIStroke_91.Color = Color3.fromRGB(140, 90, 200)
UIStroke_91.Thickness = 1
UIStroke_91.Parent = TextBox_89

Frame_92 = Instance.new("Frame")
Frame_92.Position = UDim2.new(0, 0, 0, 0)
Frame_92.Size = UDim2.new(1, 0, 0, 32)
Frame_92.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_92.BorderSizePixel = 0
Frame_92.LayoutOrder = 8
Frame_92.Parent = Page_Speed_56

UICorner_93 = Instance.new("UICorner")
UICorner_93.CornerRadius = UDim.new(0, 10)
UICorner_93.Parent = Frame_92

UIStroke_94 = Instance.new("UIStroke")
UIStroke_94.Color = Color3.fromRGB(28, 28, 34)
UIStroke_94.Thickness = 1
UIStroke_94.Parent = Frame_92

TextLabel_95 = Instance.new("TextLabel")
TextLabel_95.Position = UDim2.new(0, 9, 0, 0)
TextLabel_95.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_95.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_95.BackgroundTransparency = 1
TextLabel_95.BorderSizePixel = 1
TextLabel_95.Text = "Mode"
TextLabel_95.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_95.TextSize = 11
TextLabel_95.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_95.Font = Enum.Font.GothamBold
TextLabel_95.Parent = Frame_92

TextLabel_96 = Instance.new("TextLabel")
TextLabel_96.Position = UDim2.new(1, -94, 0, 0)
TextLabel_96.Size = UDim2.new(0, 90, 1, 0)
TextLabel_96.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_96.BackgroundTransparency = 1
TextLabel_96.BorderSizePixel = 1
TextLabel_96.Text = "Normal"
TextLabel_96.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_96.TextSize = 11
TextLabel_96.TextXAlignment = Enum.TextXAlignment.Right
TextLabel_96.Font = Enum.Font.GothamBlack
TextLabel_96.Parent = Frame_92

TextButton_97 = Instance.new("TextButton")
TextButton_97.Position = UDim2.new(0, 0, 0, 0)
TextButton_97.Size = UDim2.new(1, 0, 1, 0)
TextButton_97.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_97.BackgroundTransparency = 1
TextButton_97.BorderSizePixel = 1
TextButton_97.ZIndex = 2
TextButton_97.Active = true
TextButton_97.Text = ""
TextButton_97.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_97.TextSize = 8
TextButton_97.Parent = Frame_92

Frame_98 = Instance.new("Frame")
Frame_98.Position = UDim2.new(0, 0, 0, 0)
Frame_98.Size = UDim2.new(1, 0, 0, 4)
Frame_98.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_98.BackgroundTransparency = 1
Frame_98.BorderSizePixel = 0
Frame_98.LayoutOrder = 9
Frame_98.Parent = Page_Speed_56

Frame_99 = Instance.new("Frame")
Frame_99.Position = UDim2.new(0, 0, 0, 0)
Frame_99.Size = UDim2.new(1, 0, 0, 18)
Frame_99.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_99.BackgroundTransparency = 1
Frame_99.BorderSizePixel = 0
Frame_99.LayoutOrder = 10
Frame_99.Parent = Page_Speed_56

TextLabel_100 = Instance.new("TextLabel")
TextLabel_100.Position = UDim2.new(0, 8, 0, 0)
TextLabel_100.Size = UDim2.new(1, -8, 1, 0)
TextLabel_100.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_100.BackgroundTransparency = 1
TextLabel_100.BorderSizePixel = 1
TextLabel_100.Text = "KEYBINDS"
TextLabel_100.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_100.TextSize = 9
TextLabel_100.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_100.Font = Enum.Font.GothamBlack
TextLabel_100.Parent = Frame_99

Frame_101 = Instance.new("Frame")
Frame_101.Position = UDim2.new(0, 0, 0, 0)
Frame_101.Size = UDim2.new(1, 0, 0, 32)
Frame_101.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_101.BorderSizePixel = 0
Frame_101.LayoutOrder = 11
Frame_101.Parent = Page_Speed_56

UICorner_102 = Instance.new("UICorner")
UICorner_102.CornerRadius = UDim.new(0, 10)
UICorner_102.Parent = Frame_101

UIStroke_103 = Instance.new("UIStroke")
UIStroke_103.Color = Color3.fromRGB(28, 28, 34)
UIStroke_103.Thickness = 1
UIStroke_103.Parent = Frame_101

TextLabel_104 = Instance.new("TextLabel")
TextLabel_104.Position = UDim2.new(0, 9, 0, 0)
TextLabel_104.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_104.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_104.BackgroundTransparency = 1
TextLabel_104.BorderSizePixel = 1
TextLabel_104.Text = "Speed Key"
TextLabel_104.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_104.TextSize = 11
TextLabel_104.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_104.Font = Enum.Font.GothamBold
TextLabel_104.Parent = Frame_101

TextButton_105 = Instance.new("TextButton")
TextButton_105.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_105.Size = UDim2.new(0, 46, 0, 22)
TextButton_105.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_105.BorderSizePixel = 0
TextButton_105.ZIndex = 5
TextButton_105.Active = true
TextButton_105.Text = "Q"
TextButton_105.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_105.TextSize = 9
TextButton_105.Font = Enum.Font.GothamBold
TextButton_105.Parent = Frame_101

UICorner_106 = Instance.new("UICorner")
UICorner_106.CornerRadius = UDim.new(0, 5)
UICorner_106.Parent = TextButton_105

Frame_107 = Instance.new("Frame")
Frame_107.Position = UDim2.new(0, 0, 0, 0)
Frame_107.Size = UDim2.new(1, 0, 0, 32)
Frame_107.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_107.BorderSizePixel = 0
Frame_107.LayoutOrder = 12
Frame_107.Parent = Page_Speed_56

UICorner_108 = Instance.new("UICorner")
UICorner_108.CornerRadius = UDim.new(0, 10)
UICorner_108.Parent = Frame_107

UIStroke_109 = Instance.new("UIStroke")
UIStroke_109.Color = Color3.fromRGB(28, 28, 34)
UIStroke_109.Thickness = 1
UIStroke_109.Parent = Frame_107

TextLabel_110 = Instance.new("TextLabel")
TextLabel_110.Position = UDim2.new(0, 9, 0, 0)
TextLabel_110.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_110.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_110.BackgroundTransparency = 1
TextLabel_110.BorderSizePixel = 1
TextLabel_110.Text = "Lagger Key"
TextLabel_110.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_110.TextSize = 11
TextLabel_110.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_110.Font = Enum.Font.GothamBold
TextLabel_110.Parent = Frame_107

TextButton_111 = Instance.new("TextButton")
TextButton_111.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_111.Size = UDim2.new(0, 46, 0, 22)
TextButton_111.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_111.BorderSizePixel = 0
TextButton_111.ZIndex = 5
TextButton_111.Active = true
TextButton_111.Text = "R"
TextButton_111.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_111.TextSize = 9
TextButton_111.Font = Enum.Font.GothamBold
TextButton_111.Parent = Frame_107

UICorner_112 = Instance.new("UICorner")
UICorner_112.CornerRadius = UDim.new(0, 5)
UICorner_112.Parent = TextButton_111

Page_Combat_113 = Instance.new("ScrollingFrame")
Page_Combat_113.Name = "Page_Combat"
Page_Combat_113.Position = UDim2.new(0, 0, 0, 0)
Page_Combat_113.Size = UDim2.new(1, 0, 1, 0)
Page_Combat_113.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Page_Combat_113.BackgroundTransparency = 1
Page_Combat_113.BorderSizePixel = 0
Page_Combat_113.Visible = false
Page_Combat_113.ClipsDescendants = true
Page_Combat_113.CanvasSize = UDim2.new(0, 0, 0, 0)
Page_Combat_113.ScrollBarThickness = 0
Page_Combat_113.ScrollingDirection = Enum.ScrollingDirection.XY
Page_Combat_113.Parent = Frame_55

UIListLayout_114 = Instance.new("UIListLayout")
UIListLayout_114.FillDirection = Enum.FillDirection.Vertical
UIListLayout_114.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_114.Padding = UDim.new(0, 4)
UIListLayout_114.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout_114.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout_114.Parent = Page_Combat_113

UIPadding_115 = Instance.new("UIPadding")
UIPadding_115.PaddingTop = UDim.new(0, 6)
UIPadding_115.PaddingBottom = UDim.new(0, 10)
UIPadding_115.PaddingLeft = UDim.new(0, 6)
UIPadding_115.PaddingRight = UDim.new(0, 6)
UIPadding_115.Parent = Page_Combat_113

Frame_116 = Instance.new("Frame")
Frame_116.Position = UDim2.new(0, 0, 0, 0)
Frame_116.Size = UDim2.new(1, 0, 0, 2)
Frame_116.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_116.BackgroundTransparency = 1
Frame_116.BorderSizePixel = 0
Frame_116.LayoutOrder = 13
Frame_116.Parent = Page_Combat_113

TextLabel_117 = Instance.new("TextLabel")
TextLabel_117.Position = UDim2.new(0, 8, 0, 0)
TextLabel_117.Size = UDim2.new(1, -8, 1, 0)
TextLabel_117.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_117.BackgroundTransparency = 1
TextLabel_117.BorderSizePixel = 1
TextLabel_117.Text = "COMBAT"
TextLabel_117.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_117.TextSize = 8
TextLabel_117.Parent = Frame_116

Frame_118 = Instance.new("Frame")
Frame_118.Position = UDim2.new(0, 0, 0, 0)
Frame_118.Size = UDim2.new(1, 0, 0, 4)
Frame_118.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_118.BackgroundTransparency = 1
Frame_118.BorderSizePixel = 0
Frame_118.LayoutOrder = 14
Frame_118.Parent = Page_Combat_113

Frame_119 = Instance.new("Frame")
Frame_119.Position = UDim2.new(0, 0, 0, 0)
Frame_119.Size = UDim2.new(1, 0, 0, 18)
Frame_119.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_119.BackgroundTransparency = 1
Frame_119.BorderSizePixel = 0
Frame_119.LayoutOrder = 15
Frame_119.Parent = Page_Combat_113

TextLabel_120 = Instance.new("TextLabel")
TextLabel_120.Position = UDim2.new(0, 8, 0, 0)
TextLabel_120.Size = UDim2.new(1, -8, 1, 0)
TextLabel_120.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_120.BackgroundTransparency = 1
TextLabel_120.BorderSizePixel = 1
TextLabel_120.Text = "COMBAT"
TextLabel_120.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_120.TextSize = 9
TextLabel_120.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_120.Font = Enum.Font.GothamBlack
TextLabel_120.Parent = Frame_119

Frame_121 = Instance.new("Frame")
Frame_121.Position = UDim2.new(0, 0, 0, 0)
Frame_121.Size = UDim2.new(1, 0, 0, 32)
Frame_121.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_121.BorderSizePixel = 0
Frame_121.LayoutOrder = 16
Frame_121.Parent = Page_Combat_113

UICorner_122 = Instance.new("UICorner")
UICorner_122.CornerRadius = UDim.new(0, 10)
UICorner_122.Parent = Frame_121

UIStroke_123 = Instance.new("UIStroke")
UIStroke_123.Color = Color3.fromRGB(28, 28, 34)
UIStroke_123.Thickness = 1
UIStroke_123.Parent = Frame_121

TextLabel_124 = Instance.new("TextLabel")
TextLabel_124.Position = UDim2.new(0, 9, 0, 0)
TextLabel_124.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_124.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_124.BackgroundTransparency = 1
TextLabel_124.BorderSizePixel = 1
TextLabel_124.Text = "Anti Bat"
TextLabel_124.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_124.TextSize = 11
TextLabel_124.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_124.Font = Enum.Font.GothamBold
TextLabel_124.Parent = Frame_121

TextButton_125 = Instance.new("TextButton")
TextButton_125.Position = UDim2.new(1, -62, 0.5, -11)
TextButton_125.Size = UDim2.new(0, 58, 0, 22)
TextButton_125.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
TextButton_125.BorderSizePixel = 0
TextButton_125.Active = true
TextButton_125.Text = "OPEN"
TextButton_125.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_125.TextSize = 10
TextButton_125.Font = Enum.Font.GothamBlack
TextButton_125.Parent = Frame_121

UICorner_126 = Instance.new("UICorner")
UICorner_126.CornerRadius = UDim.new(0, 5)
UICorner_126.Parent = TextButton_125

Frame_127 = Instance.new("Frame")
Frame_127.Position = UDim2.new(0, 0, 0, 0)
Frame_127.Size = UDim2.new(1, 0, 0, 32)
Frame_127.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_127.BorderSizePixel = 0
Frame_127.LayoutOrder = 17
Frame_127.Parent = Page_Combat_113

UICorner_128 = Instance.new("UICorner")
UICorner_128.CornerRadius = UDim.new(0, 10)
UICorner_128.Parent = Frame_127

UIStroke_129 = Instance.new("UIStroke")
UIStroke_129.Color = Color3.fromRGB(28, 28, 34)
UIStroke_129.Thickness = 1
UIStroke_129.Parent = Frame_127

TextLabel_130 = Instance.new("TextLabel")
TextLabel_130.Position = UDim2.new(0, 9, 0, 0)
TextLabel_130.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_130.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_130.BackgroundTransparency = 1
TextLabel_130.BorderSizePixel = 1
TextLabel_130.Text = "TP Bat (Desync)"
TextLabel_130.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_130.TextSize = 11
TextLabel_130.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_130.Font = Enum.Font.GothamBold
TextLabel_130.Parent = Frame_127

TextButton_131 = Instance.new("TextButton")
TextButton_131.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_131.Size = UDim2.new(0, 46, 0, 22)
TextButton_131.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_131.BorderSizePixel = 0
TextButton_131.ZIndex = 5
TextButton_131.Active = true
TextButton_131.Text = "None"
TextButton_131.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_131.TextSize = 9
TextButton_131.Font = Enum.Font.GothamBold
TextButton_131.Parent = Frame_127

UICorner_132 = Instance.new("UICorner")
UICorner_132.CornerRadius = UDim.new(0, 5)
UICorner_132.Parent = TextButton_131

Frame_133 = Instance.new("Frame")
Frame_133.Position = UDim2.new(1, -102, 0.5, -9)
Frame_133.Size = UDim2.new(0, 36, 0, 19)
Frame_133.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_133.BorderSizePixel = 0
Frame_133.ZIndex = 3
Frame_133.Parent = Frame_127

UICorner_134 = Instance.new("UICorner")
UICorner_134.CornerRadius = UDim.new(1, 0)
UICorner_134.Parent = Frame_133

Frame_135 = Instance.new("Frame")
Frame_135.Position = UDim2.new(0, 3, 0.5, -6)
Frame_135.Size = UDim2.new(0, 13, 0, 13)
Frame_135.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_135.BorderSizePixel = 0
Frame_135.ZIndex = 4
Frame_135.Parent = Frame_133

UICorner_136 = Instance.new("UICorner")
UICorner_136.CornerRadius = UDim.new(1, 0)
UICorner_136.Parent = Frame_135

TextButton_137 = Instance.new("TextButton")
TextButton_137.Position = UDim2.new(0, 0, 0, 0)
TextButton_137.Size = UDim2.new(1, 0, 1, 0)
TextButton_137.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_137.BackgroundTransparency = 1
TextButton_137.BorderSizePixel = 1
TextButton_137.ZIndex = 5
TextButton_137.Active = true
TextButton_137.Text = ""
TextButton_137.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_137.TextSize = 8
TextButton_137.Parent = Frame_133

Frame_138 = Instance.new("Frame")
Frame_138.Position = UDim2.new(0, 0, 0, 0)
Frame_138.Size = UDim2.new(1, 0, 0, 32)
Frame_138.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_138.BorderSizePixel = 0
Frame_138.LayoutOrder = 18
Frame_138.Parent = Page_Combat_113

UICorner_139 = Instance.new("UICorner")
UICorner_139.CornerRadius = UDim.new(0, 10)
UICorner_139.Parent = Frame_138

UIStroke_140 = Instance.new("UIStroke")
UIStroke_140.Color = Color3.fromRGB(28, 28, 34)
UIStroke_140.Thickness = 1
UIStroke_140.Parent = Frame_138

TextLabel_141 = Instance.new("TextLabel")
TextLabel_141.Position = UDim2.new(0, 9, 0, 0)
TextLabel_141.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_141.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_141.BackgroundTransparency = 1
TextLabel_141.BorderSizePixel = 1
TextLabel_141.Text = "Bat Aimbot"
TextLabel_141.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_141.TextSize = 11
TextLabel_141.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_141.Font = Enum.Font.GothamBold
TextLabel_141.Parent = Frame_138

TextButton_142 = Instance.new("TextButton")
TextButton_142.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_142.Size = UDim2.new(0, 46, 0, 22)
TextButton_142.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_142.BorderSizePixel = 0
TextButton_142.ZIndex = 5
TextButton_142.Active = true
TextButton_142.Text = "E"
TextButton_142.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_142.TextSize = 9
TextButton_142.Font = Enum.Font.GothamBold
TextButton_142.Parent = Frame_138

UICorner_143 = Instance.new("UICorner")
UICorner_143.CornerRadius = UDim.new(0, 5)
UICorner_143.Parent = TextButton_142

Frame_144 = Instance.new("Frame")
Frame_144.Position = UDim2.new(1, -102, 0.5, -9)
Frame_144.Size = UDim2.new(0, 36, 0, 19)
Frame_144.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_144.BorderSizePixel = 0
Frame_144.ZIndex = 3
Frame_144.Parent = Frame_138

UICorner_145 = Instance.new("UICorner")
UICorner_145.CornerRadius = UDim.new(1, 0)
UICorner_145.Parent = Frame_144

Frame_146 = Instance.new("Frame")
Frame_146.Position = UDim2.new(0, 3, 0.5, -6)
Frame_146.Size = UDim2.new(0, 13, 0, 13)
Frame_146.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_146.BorderSizePixel = 0
Frame_146.ZIndex = 4
Frame_146.Parent = Frame_144

UICorner_147 = Instance.new("UICorner")
UICorner_147.CornerRadius = UDim.new(1, 0)
UICorner_147.Parent = Frame_146

TextButton_148 = Instance.new("TextButton")
TextButton_148.Position = UDim2.new(0, 0, 0, 0)
TextButton_148.Size = UDim2.new(1, 0, 1, 0)
TextButton_148.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_148.BackgroundTransparency = 1
TextButton_148.BorderSizePixel = 1
TextButton_148.ZIndex = 5
TextButton_148.Active = true
TextButton_148.Text = ""
TextButton_148.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_148.TextSize = 8
TextButton_148.Parent = Frame_144

Frame_149 = Instance.new("Frame")
Frame_149.Position = UDim2.new(0, 0, 0, 0)
Frame_149.Size = UDim2.new(1, 0, 0, 32)
Frame_149.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_149.BorderSizePixel = 0
Frame_149.LayoutOrder = 19
Frame_149.Parent = Page_Combat_113

UICorner_150 = Instance.new("UICorner")
UICorner_150.CornerRadius = UDim.new(0, 10)
UICorner_150.Parent = Frame_149

UIStroke_151 = Instance.new("UIStroke")
UIStroke_151.Color = Color3.fromRGB(28, 28, 34)
UIStroke_151.Thickness = 1
UIStroke_151.Parent = Frame_149

TextLabel_152 = Instance.new("TextLabel")
TextLabel_152.Position = UDim2.new(0, 9, 0, 0)
TextLabel_152.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_152.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_152.BackgroundTransparency = 1
TextLabel_152.BorderSizePixel = 1
TextLabel_152.Text = "Aimbot Speed (Normal/Carry)"
TextLabel_152.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_152.TextSize = 11
TextLabel_152.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_152.Font = Enum.Font.GothamBold
TextLabel_152.Parent = Frame_149

TextBox_153 = Instance.new("TextBox")
TextBox_153.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_153.Size = UDim2.new(0, 50, 0, 22)
TextBox_153.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_153.BorderSizePixel = 0
TextBox_153.ZIndex = 5
TextBox_153.Active = true
TextBox_153.Text = "62"
TextBox_153.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_153.TextSize = 11
TextBox_153.Font = Enum.Font.GothamBold
TextBox_153.Parent = Frame_149

UICorner_154 = Instance.new("UICorner")
UICorner_154.CornerRadius = UDim.new(0, 5)
UICorner_154.Parent = TextBox_153

UIStroke_155 = Instance.new("UIStroke")
UIStroke_155.Color = Color3.fromRGB(140, 90, 200)
UIStroke_155.Thickness = 1
UIStroke_155.Parent = TextBox_153

Frame_156 = Instance.new("Frame")
Frame_156.Position = UDim2.new(0, 0, 0, 0)
Frame_156.Size = UDim2.new(1, 0, 0, 32)
Frame_156.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_156.BorderSizePixel = 0
Frame_156.LayoutOrder = 20
Frame_156.Parent = Page_Combat_113

UICorner_157 = Instance.new("UICorner")
UICorner_157.CornerRadius = UDim.new(0, 10)
UICorner_157.Parent = Frame_156

UIStroke_158 = Instance.new("UIStroke")
UIStroke_158.Color = Color3.fromRGB(28, 28, 34)
UIStroke_158.Thickness = 1
UIStroke_158.Parent = Frame_156

TextLabel_159 = Instance.new("TextLabel")
TextLabel_159.Position = UDim2.new(0, 9, 0, 0)
TextLabel_159.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_159.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_159.BackgroundTransparency = 1
TextLabel_159.BorderSizePixel = 1
TextLabel_159.Text = "Aimbot Speed (Lagger)"
TextLabel_159.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_159.TextSize = 11
TextLabel_159.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_159.Font = Enum.Font.GothamBold
TextLabel_159.Parent = Frame_156

TextBox_160 = Instance.new("TextBox")
TextBox_160.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_160.Size = UDim2.new(0, 50, 0, 22)
TextBox_160.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_160.BorderSizePixel = 0
TextBox_160.ZIndex = 5
TextBox_160.Active = true
TextBox_160.Text = "45"
TextBox_160.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_160.TextSize = 11
TextBox_160.Font = Enum.Font.GothamBold
TextBox_160.Parent = Frame_156

UICorner_161 = Instance.new("UICorner")
UICorner_161.CornerRadius = UDim.new(0, 5)
UICorner_161.Parent = TextBox_160

UIStroke_162 = Instance.new("UIStroke")
UIStroke_162.Color = Color3.fromRGB(140, 90, 200)
UIStroke_162.Thickness = 1
UIStroke_162.Parent = TextBox_160

Frame_163 = Instance.new("Frame")
Frame_163.Position = UDim2.new(0, 0, 0, 0)
Frame_163.Size = UDim2.new(1, 0, 0, 32)
Frame_163.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_163.BorderSizePixel = 0
Frame_163.LayoutOrder = 21
Frame_163.Parent = Page_Combat_113

UICorner_164 = Instance.new("UICorner")
UICorner_164.CornerRadius = UDim.new(0, 10)
UICorner_164.Parent = Frame_163

UIStroke_165 = Instance.new("UIStroke")
UIStroke_165.Color = Color3.fromRGB(28, 28, 34)
UIStroke_165.Thickness = 1
UIStroke_165.Parent = Frame_163

TextLabel_166 = Instance.new("TextLabel")
TextLabel_166.Position = UDim2.new(0, 9, 0, 0)
TextLabel_166.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_166.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_166.BackgroundTransparency = 1
TextLabel_166.BorderSizePixel = 1
TextLabel_166.Text = "Hit Distance"
TextLabel_166.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_166.TextSize = 11
TextLabel_166.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_166.Font = Enum.Font.GothamBold
TextLabel_166.Parent = Frame_163

TextBox_167 = Instance.new("TextBox")
TextBox_167.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_167.Size = UDim2.new(0, 50, 0, 22)
TextBox_167.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_167.BorderSizePixel = 0
TextBox_167.ZIndex = 5
TextBox_167.Active = true
TextBox_167.Text = "8"
TextBox_167.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_167.TextSize = 11
TextBox_167.Font = Enum.Font.GothamBold
TextBox_167.Parent = Frame_163

UICorner_168 = Instance.new("UICorner")
UICorner_168.CornerRadius = UDim.new(0, 5)
UICorner_168.Parent = TextBox_167

UIStroke_169 = Instance.new("UIStroke")
UIStroke_169.Color = Color3.fromRGB(140, 90, 200)
UIStroke_169.Thickness = 1
UIStroke_169.Parent = TextBox_167

Frame_170 = Instance.new("Frame")
Frame_170.Position = UDim2.new(0, 0, 0, 0)
Frame_170.Size = UDim2.new(1, 0, 0, 32)
Frame_170.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_170.BorderSizePixel = 0
Frame_170.LayoutOrder = 22
Frame_170.Parent = Page_Combat_113

UICorner_171 = Instance.new("UICorner")
UICorner_171.CornerRadius = UDim.new(0, 10)
UICorner_171.Parent = Frame_170

UIStroke_172 = Instance.new("UIStroke")
UIStroke_172.Color = Color3.fromRGB(28, 28, 34)
UIStroke_172.Thickness = 1
UIStroke_172.Parent = Frame_170

TextLabel_173 = Instance.new("TextLabel")
TextLabel_173.Position = UDim2.new(0, 9, 0, 0)
TextLabel_173.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_173.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_173.BackgroundTransparency = 1
TextLabel_173.BorderSizePixel = 1
TextLabel_173.Text = "Auto Swing"
TextLabel_173.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_173.TextSize = 11
TextLabel_173.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_173.Font = Enum.Font.GothamBold
TextLabel_173.Parent = Frame_170

Frame_174 = Instance.new("Frame")
Frame_174.Position = UDim2.new(1, -42, 0.5, -9)
Frame_174.Size = UDim2.new(0, 36, 0, 19)
Frame_174.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
Frame_174.BorderSizePixel = 0
Frame_174.ZIndex = 3
Frame_174.Parent = Frame_170

UICorner_175 = Instance.new("UICorner")
UICorner_175.CornerRadius = UDim.new(1, 0)
UICorner_175.Parent = Frame_174

Frame_176 = Instance.new("Frame")
Frame_176.Position = UDim2.new(1, -16, 0.5, -6)
Frame_176.Size = UDim2.new(0, 13, 0, 13)
Frame_176.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
Frame_176.BorderSizePixel = 0
Frame_176.ZIndex = 4
Frame_176.Parent = Frame_174

UICorner_177 = Instance.new("UICorner")
UICorner_177.CornerRadius = UDim.new(1, 0)
UICorner_177.Parent = Frame_176

TextButton_178 = Instance.new("TextButton")
TextButton_178.Position = UDim2.new(0, 0, 0, 0)
TextButton_178.Size = UDim2.new(1, 0, 1, 0)
TextButton_178.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_178.BackgroundTransparency = 1
TextButton_178.BorderSizePixel = 1
TextButton_178.ZIndex = 5
TextButton_178.Active = true
TextButton_178.Text = ""
TextButton_178.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_178.TextSize = 8
TextButton_178.Parent = Frame_174

Frame_179 = Instance.new("Frame")
Frame_179.Position = UDim2.new(0, 0, 0, 0)
Frame_179.Size = UDim2.new(1, 0, 0, 32)
Frame_179.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_179.BorderSizePixel = 0
Frame_179.LayoutOrder = 23
Frame_179.Parent = Page_Combat_113

UICorner_180 = Instance.new("UICorner")
UICorner_180.CornerRadius = UDim.new(0, 10)
UICorner_180.Parent = Frame_179

UIStroke_181 = Instance.new("UIStroke")
UIStroke_181.Color = Color3.fromRGB(28, 28, 34)
UIStroke_181.Thickness = 1
UIStroke_181.Parent = Frame_179

TextLabel_182 = Instance.new("TextLabel")
TextLabel_182.Position = UDim2.new(0, 9, 0, 0)
TextLabel_182.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_182.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_182.BackgroundTransparency = 1
TextLabel_182.BorderSizePixel = 1
TextLabel_182.Text = "Bat Counter"
TextLabel_182.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_182.TextSize = 11
TextLabel_182.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_182.Font = Enum.Font.GothamBold
TextLabel_182.Parent = Frame_179

Frame_183 = Instance.new("Frame")
Frame_183.Position = UDim2.new(1, -42, 0.5, -9)
Frame_183.Size = UDim2.new(0, 36, 0, 19)
Frame_183.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_183.BorderSizePixel = 0
Frame_183.ZIndex = 3
Frame_183.Parent = Frame_179

UICorner_184 = Instance.new("UICorner")
UICorner_184.CornerRadius = UDim.new(1, 0)
UICorner_184.Parent = Frame_183

Frame_185 = Instance.new("Frame")
Frame_185.Position = UDim2.new(0, 3, 0.5, -6)
Frame_185.Size = UDim2.new(0, 13, 0, 13)
Frame_185.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_185.BorderSizePixel = 0
Frame_185.ZIndex = 4
Frame_185.Parent = Frame_183

UICorner_186 = Instance.new("UICorner")
UICorner_186.CornerRadius = UDim.new(1, 0)
UICorner_186.Parent = Frame_185

TextButton_187 = Instance.new("TextButton")
TextButton_187.Position = UDim2.new(0, 0, 0, 0)
TextButton_187.Size = UDim2.new(1, 0, 1, 0)
TextButton_187.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_187.BackgroundTransparency = 1
TextButton_187.BorderSizePixel = 1
TextButton_187.ZIndex = 5
TextButton_187.Active = true
TextButton_187.Text = ""
TextButton_187.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_187.TextSize = 8
TextButton_187.Parent = Frame_183

Frame_188 = Instance.new("Frame")
Frame_188.Position = UDim2.new(0, 0, 0, 0)
Frame_188.Size = UDim2.new(1, 0, 0, 32)
Frame_188.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_188.BorderSizePixel = 0
Frame_188.LayoutOrder = 24
Frame_188.Parent = Page_Combat_113

UICorner_189 = Instance.new("UICorner")
UICorner_189.CornerRadius = UDim.new(0, 10)
UICorner_189.Parent = Frame_188

UIStroke_190 = Instance.new("UIStroke")
UIStroke_190.Color = Color3.fromRGB(28, 28, 34)
UIStroke_190.Thickness = 1
UIStroke_190.Parent = Frame_188

TextLabel_191 = Instance.new("TextLabel")
TextLabel_191.Position = UDim2.new(0, 9, 0, 0)
TextLabel_191.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_191.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_191.BackgroundTransparency = 1
TextLabel_191.BorderSizePixel = 1
TextLabel_191.Text = "Harder Hit Anim"
TextLabel_191.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_191.TextSize = 11
TextLabel_191.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_191.Font = Enum.Font.GothamBold
TextLabel_191.Parent = Frame_188

Frame_192 = Instance.new("Frame")
Frame_192.Position = UDim2.new(1, -42, 0.5, -9)
Frame_192.Size = UDim2.new(0, 36, 0, 19)
Frame_192.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_192.BorderSizePixel = 0
Frame_192.ZIndex = 3
Frame_192.Parent = Frame_188

UICorner_193 = Instance.new("UICorner")
UICorner_193.CornerRadius = UDim.new(1, 0)
UICorner_193.Parent = Frame_192

Frame_194 = Instance.new("Frame")
Frame_194.Position = UDim2.new(0, 3, 0.5, -6)
Frame_194.Size = UDim2.new(0, 13, 0, 13)
Frame_194.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_194.BorderSizePixel = 0
Frame_194.ZIndex = 4
Frame_194.Parent = Frame_192

UICorner_195 = Instance.new("UICorner")
UICorner_195.CornerRadius = UDim.new(1, 0)
UICorner_195.Parent = Frame_194

TextButton_196 = Instance.new("TextButton")
TextButton_196.Position = UDim2.new(0, 0, 0, 0)
TextButton_196.Size = UDim2.new(1, 0, 1, 0)
TextButton_196.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_196.BackgroundTransparency = 1
TextButton_196.BorderSizePixel = 1
TextButton_196.ZIndex = 5
TextButton_196.Active = true
TextButton_196.Text = ""
TextButton_196.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_196.TextSize = 8
TextButton_196.Parent = Frame_192

Page_Steal_197 = Instance.new("ScrollingFrame")
Page_Steal_197.Name = "Page_Steal"
Page_Steal_197.Position = UDim2.new(0, 0, 0, 0)
Page_Steal_197.Size = UDim2.new(1, 0, 1, 0)
Page_Steal_197.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Page_Steal_197.BackgroundTransparency = 1
Page_Steal_197.BorderSizePixel = 0
Page_Steal_197.Visible = false
Page_Steal_197.ClipsDescendants = true
Page_Steal_197.CanvasSize = UDim2.new(0, 0, 0, 0)
Page_Steal_197.ScrollBarThickness = 0
Page_Steal_197.ScrollingDirection = Enum.ScrollingDirection.XY
Page_Steal_197.Parent = Frame_55

UIListLayout_198 = Instance.new("UIListLayout")
UIListLayout_198.FillDirection = Enum.FillDirection.Vertical
UIListLayout_198.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_198.Padding = UDim.new(0, 4)
UIListLayout_198.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout_198.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout_198.Parent = Page_Steal_197

UIPadding_199 = Instance.new("UIPadding")
UIPadding_199.PaddingTop = UDim.new(0, 6)
UIPadding_199.PaddingBottom = UDim.new(0, 10)
UIPadding_199.PaddingLeft = UDim.new(0, 6)
UIPadding_199.PaddingRight = UDim.new(0, 6)
UIPadding_199.Parent = Page_Steal_197

Frame_200 = Instance.new("Frame")
Frame_200.Position = UDim2.new(0, 0, 0, 0)
Frame_200.Size = UDim2.new(1, 0, 0, 2)
Frame_200.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_200.BackgroundTransparency = 1
Frame_200.BorderSizePixel = 0
Frame_200.LayoutOrder = 25
Frame_200.Parent = Page_Steal_197

TextLabel_201 = Instance.new("TextLabel")
TextLabel_201.Position = UDim2.new(0, 8, 0, 0)
TextLabel_201.Size = UDim2.new(1, -8, 1, 0)
TextLabel_201.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_201.BackgroundTransparency = 1
TextLabel_201.BorderSizePixel = 1
TextLabel_201.Text = "STEAL"
TextLabel_201.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_201.TextSize = 8
TextLabel_201.Parent = Frame_200

Frame_202 = Instance.new("Frame")
Frame_202.Position = UDim2.new(0, 0, 0, 0)
Frame_202.Size = UDim2.new(1, 0, 0, 4)
Frame_202.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_202.BackgroundTransparency = 1
Frame_202.BorderSizePixel = 0
Frame_202.LayoutOrder = 26
Frame_202.Parent = Page_Steal_197

Frame_203 = Instance.new("Frame")
Frame_203.Position = UDim2.new(0, 0, 0, 0)
Frame_203.Size = UDim2.new(1, 0, 0, 18)
Frame_203.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_203.BackgroundTransparency = 1
Frame_203.BorderSizePixel = 0
Frame_203.LayoutOrder = 27
Frame_203.Parent = Page_Steal_197

TextLabel_204 = Instance.new("TextLabel")
TextLabel_204.Position = UDim2.new(0, 8, 0, 0)
TextLabel_204.Size = UDim2.new(1, -8, 1, 0)
TextLabel_204.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_204.BackgroundTransparency = 1
TextLabel_204.BorderSizePixel = 1
TextLabel_204.Text = "STEAL"
TextLabel_204.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_204.TextSize = 9
TextLabel_204.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_204.Font = Enum.Font.GothamBlack
TextLabel_204.Parent = Frame_203

Frame_205 = Instance.new("Frame")
Frame_205.Position = UDim2.new(0, 0, 0, 0)
Frame_205.Size = UDim2.new(1, 0, 0, 32)
Frame_205.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_205.BorderSizePixel = 0
Frame_205.LayoutOrder = 28
Frame_205.Parent = Page_Steal_197

UICorner_206 = Instance.new("UICorner")
UICorner_206.CornerRadius = UDim.new(0, 10)
UICorner_206.Parent = Frame_205

UIStroke_207 = Instance.new("UIStroke")
UIStroke_207.Color = Color3.fromRGB(28, 28, 34)
UIStroke_207.Thickness = 1
UIStroke_207.Parent = Frame_205

TextLabel_208 = Instance.new("TextLabel")
TextLabel_208.Position = UDim2.new(0, 9, 0, 0)
TextLabel_208.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_208.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_208.BackgroundTransparency = 1
TextLabel_208.BorderSizePixel = 1
TextLabel_208.Text = "Radius"
TextLabel_208.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_208.TextSize = 11
TextLabel_208.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_208.Font = Enum.Font.GothamBold
TextLabel_208.Parent = Frame_205

TextBox_209 = Instance.new("TextBox")
TextBox_209.Position = UDim2.new(1, -56, 0.5, -11)
TextBox_209.Size = UDim2.new(0, 50, 0, 22)
TextBox_209.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_209.BorderSizePixel = 0
TextBox_209.ZIndex = 5
TextBox_209.Active = true
TextBox_209.Text = "20"
TextBox_209.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_209.TextSize = 11
TextBox_209.Font = Enum.Font.GothamBold
TextBox_209.Parent = Frame_205

UICorner_210 = Instance.new("UICorner")
UICorner_210.CornerRadius = UDim.new(0, 5)
UICorner_210.Parent = TextBox_209

UIStroke_211 = Instance.new("UIStroke")
UIStroke_211.Color = Color3.fromRGB(140, 90, 200)
UIStroke_211.Thickness = 1
UIStroke_211.Parent = TextBox_209

Frame_212 = Instance.new("Frame")
Frame_212.Position = UDim2.new(0, 0, 0, 0)
Frame_212.Size = UDim2.new(1, 0, 0, 32)
Frame_212.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_212.BorderSizePixel = 0
Frame_212.LayoutOrder = 29
Frame_212.Parent = Page_Steal_197

UICorner_213 = Instance.new("UICorner")
UICorner_213.CornerRadius = UDim.new(0, 10)
UICorner_213.Parent = Frame_212

UIStroke_214 = Instance.new("UIStroke")
UIStroke_214.Color = Color3.fromRGB(28, 28, 34)
UIStroke_214.Thickness = 1
UIStroke_214.Parent = Frame_212

TextLabel_215 = Instance.new("TextLabel")
TextLabel_215.Position = UDim2.new(0, 9, 0, 0)
TextLabel_215.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_215.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_215.BackgroundTransparency = 1
TextLabel_215.BorderSizePixel = 1
TextLabel_215.Text = "Auto Steal"
TextLabel_215.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_215.TextSize = 11
TextLabel_215.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_215.Font = Enum.Font.GothamBold
TextLabel_215.Parent = Frame_212

Frame_216 = Instance.new("Frame")
Frame_216.Position = UDim2.new(1, -42, 0.5, -9)
Frame_216.Size = UDim2.new(0, 36, 0, 19)
Frame_216.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_216.BorderSizePixel = 0
Frame_216.ZIndex = 3
Frame_216.Parent = Frame_212

UICorner_217 = Instance.new("UICorner")
UICorner_217.CornerRadius = UDim.new(1, 0)
UICorner_217.Parent = Frame_216

Frame_218 = Instance.new("Frame")
Frame_218.Position = UDim2.new(0, 3, 0.5, -6)
Frame_218.Size = UDim2.new(0, 13, 0, 13)
Frame_218.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_218.BorderSizePixel = 0
Frame_218.ZIndex = 4
Frame_218.Parent = Frame_216

UICorner_219 = Instance.new("UICorner")
UICorner_219.CornerRadius = UDim.new(1, 0)
UICorner_219.Parent = Frame_218

TextButton_220 = Instance.new("TextButton")
TextButton_220.Position = UDim2.new(0, 0, 0, 0)
TextButton_220.Size = UDim2.new(1, 0, 1, 0)
TextButton_220.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_220.BackgroundTransparency = 1
TextButton_220.BorderSizePixel = 1
TextButton_220.ZIndex = 5
TextButton_220.Active = true
TextButton_220.Text = ""
TextButton_220.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_220.TextSize = 8
TextButton_220.Parent = Frame_216

Frame_221 = Instance.new("Frame")
Frame_221.Position = UDim2.new(0, 0, 0, 0)
Frame_221.Size = UDim2.new(1, 0, 0, 32)
Frame_221.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_221.BorderSizePixel = 0
Frame_221.LayoutOrder = 30
Frame_221.Parent = Page_Steal_197

UICorner_222 = Instance.new("UICorner")
UICorner_222.CornerRadius = UDim.new(0, 10)
UICorner_222.Parent = Frame_221

UIStroke_223 = Instance.new("UIStroke")
UIStroke_223.Color = Color3.fromRGB(28, 28, 34)
UIStroke_223.Thickness = 1
UIStroke_223.Parent = Frame_221

TextLabel_224 = Instance.new("TextLabel")
TextLabel_224.Position = UDim2.new(0, 9, 0, 0)
TextLabel_224.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_224.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_224.BackgroundTransparency = 1
TextLabel_224.BorderSizePixel = 1
TextLabel_224.Text = "Delay Radius"
TextLabel_224.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_224.TextSize = 11
TextLabel_224.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_224.Font = Enum.Font.GothamBold
TextLabel_224.Parent = Frame_221

TextBox_225 = Instance.new("TextBox")
TextBox_225.Position = UDim2.new(1, -56, 0.5, -11)
TextBox_225.Size = UDim2.new(0, 50, 0, 22)
TextBox_225.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_225.BorderSizePixel = 0
TextBox_225.ZIndex = 5
TextBox_225.Active = true
TextBox_225.Text = "nil"
TextBox_225.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_225.TextSize = 11
TextBox_225.Font = Enum.Font.GothamBold
TextBox_225.Parent = Frame_221

UICorner_226 = Instance.new("UICorner")
UICorner_226.CornerRadius = UDim.new(0, 5)
UICorner_226.Parent = TextBox_225

UIStroke_227 = Instance.new("UIStroke")
UIStroke_227.Color = Color3.fromRGB(140, 90, 200)
UIStroke_227.Thickness = 1
UIStroke_227.Parent = TextBox_225

Frame_228 = Instance.new("Frame")
Frame_228.Position = UDim2.new(0, 0, 0, 0)
Frame_228.Size = UDim2.new(1, 0, 0, 32)
Frame_228.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_228.BorderSizePixel = 0
Frame_228.LayoutOrder = 31
Frame_228.Parent = Page_Steal_197

UICorner_229 = Instance.new("UICorner")
UICorner_229.CornerRadius = UDim.new(0, 10)
UICorner_229.Parent = Frame_228

UIStroke_230 = Instance.new("UIStroke")
UIStroke_230.Color = Color3.fromRGB(28, 28, 34)
UIStroke_230.Thickness = 1
UIStroke_230.Parent = Frame_228

TextLabel_231 = Instance.new("TextLabel")
TextLabel_231.Position = UDim2.new(0, 9, 0, 0)
TextLabel_231.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_231.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_231.BackgroundTransparency = 1
TextLabel_231.BorderSizePixel = 1
TextLabel_231.Text = "Stop Time"
TextLabel_231.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_231.TextSize = 11
TextLabel_231.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_231.Font = Enum.Font.GothamBold
TextLabel_231.Parent = Frame_228

TextBox_232 = Instance.new("TextBox")
TextBox_232.Position = UDim2.new(1, -56, 0.5, -11)
TextBox_232.Size = UDim2.new(0, 50, 0, 22)
TextBox_232.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_232.BorderSizePixel = 0
TextBox_232.ZIndex = 5
TextBox_232.Active = true
TextBox_232.Text = "nil"
TextBox_232.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_232.TextSize = 11
TextBox_232.Font = Enum.Font.GothamBold
TextBox_232.Parent = Frame_228

UICorner_233 = Instance.new("UICorner")
UICorner_233.CornerRadius = UDim.new(0, 5)
UICorner_233.Parent = TextBox_232

UIStroke_234 = Instance.new("UIStroke")
UIStroke_234.Color = Color3.fromRGB(140, 90, 200)
UIStroke_234.Thickness = 1
UIStroke_234.Parent = TextBox_232

Frame_235 = Instance.new("Frame")
Frame_235.Position = UDim2.new(0, 0, 0, 0)
Frame_235.Size = UDim2.new(1, 0, 0, 32)
Frame_235.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_235.BorderSizePixel = 0
Frame_235.LayoutOrder = 32
Frame_235.Parent = Page_Steal_197

UICorner_236 = Instance.new("UICorner")
UICorner_236.CornerRadius = UDim.new(0, 10)
UICorner_236.Parent = Frame_235

UIStroke_237 = Instance.new("UIStroke")
UIStroke_237.Color = Color3.fromRGB(28, 28, 34)
UIStroke_237.Thickness = 1
UIStroke_237.Parent = Frame_235

TextLabel_238 = Instance.new("TextLabel")
TextLabel_238.Position = UDim2.new(0, 9, 0, 0)
TextLabel_238.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_238.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_238.BackgroundTransparency = 1
TextLabel_238.BorderSizePixel = 1
TextLabel_238.Text = "Stop Time"
TextLabel_238.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_238.TextSize = 11
TextLabel_238.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_238.Font = Enum.Font.GothamBold
TextLabel_238.Parent = Frame_235

Frame_239 = Instance.new("Frame")
Frame_239.Position = UDim2.new(1, -42, 0.5, -9)
Frame_239.Size = UDim2.new(0, 36, 0, 19)
Frame_239.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_239.BorderSizePixel = 0
Frame_239.ZIndex = 3
Frame_239.Parent = Frame_235

UICorner_240 = Instance.new("UICorner")
UICorner_240.CornerRadius = UDim.new(1, 0)
UICorner_240.Parent = Frame_239

Frame_241 = Instance.new("Frame")
Frame_241.Position = UDim2.new(0, 3, 0.5, -6)
Frame_241.Size = UDim2.new(0, 13, 0, 13)
Frame_241.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_241.BorderSizePixel = 0
Frame_241.ZIndex = 4
Frame_241.Parent = Frame_239

UICorner_242 = Instance.new("UICorner")
UICorner_242.CornerRadius = UDim.new(1, 0)
UICorner_242.Parent = Frame_241

TextButton_243 = Instance.new("TextButton")
TextButton_243.Position = UDim2.new(0, 0, 0, 0)
TextButton_243.Size = UDim2.new(1, 0, 1, 0)
TextButton_243.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_243.BackgroundTransparency = 1
TextButton_243.BorderSizePixel = 1
TextButton_243.ZIndex = 5
TextButton_243.Active = true
TextButton_243.Text = ""
TextButton_243.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_243.TextSize = 8
TextButton_243.Parent = Frame_239

Page_Visual_244 = Instance.new("ScrollingFrame")
Page_Visual_244.Name = "Page_Visual"
Page_Visual_244.Position = UDim2.new(0, 0, 0, 0)
Page_Visual_244.Size = UDim2.new(1, 0, 1, 0)
Page_Visual_244.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Page_Visual_244.BackgroundTransparency = 1
Page_Visual_244.BorderSizePixel = 0
Page_Visual_244.Visible = false
Page_Visual_244.ClipsDescendants = true
Page_Visual_244.CanvasSize = UDim2.new(0, 0, 0, 0)
Page_Visual_244.ScrollBarThickness = 0
Page_Visual_244.ScrollingDirection = Enum.ScrollingDirection.XY
Page_Visual_244.Parent = Frame_55

UIListLayout_245 = Instance.new("UIListLayout")
UIListLayout_245.FillDirection = Enum.FillDirection.Vertical
UIListLayout_245.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_245.Padding = UDim.new(0, 4)
UIListLayout_245.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout_245.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout_245.Parent = Page_Visual_244

UIPadding_246 = Instance.new("UIPadding")
UIPadding_246.PaddingTop = UDim.new(0, 6)
UIPadding_246.PaddingBottom = UDim.new(0, 10)
UIPadding_246.PaddingLeft = UDim.new(0, 6)
UIPadding_246.PaddingRight = UDim.new(0, 6)
UIPadding_246.Parent = Page_Visual_244

Frame_247 = Instance.new("Frame")
Frame_247.Position = UDim2.new(0, 0, 0, 0)
Frame_247.Size = UDim2.new(1, 0, 0, 2)
Frame_247.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_247.BackgroundTransparency = 1
Frame_247.BorderSizePixel = 0
Frame_247.LayoutOrder = 33
Frame_247.Parent = Page_Visual_244

TextLabel_248 = Instance.new("TextLabel")
TextLabel_248.Position = UDim2.new(0, 8, 0, 0)
TextLabel_248.Size = UDim2.new(1, -8, 1, 0)
TextLabel_248.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_248.BackgroundTransparency = 1
TextLabel_248.BorderSizePixel = 1
TextLabel_248.Text = "VISUAL"
TextLabel_248.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_248.TextSize = 8
TextLabel_248.Parent = Frame_247

Frame_249 = Instance.new("Frame")
Frame_249.Position = UDim2.new(0, 0, 0, 0)
Frame_249.Size = UDim2.new(1, 0, 0, 4)
Frame_249.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_249.BackgroundTransparency = 1
Frame_249.BorderSizePixel = 0
Frame_249.LayoutOrder = 34
Frame_249.Parent = Page_Visual_244

Frame_250 = Instance.new("Frame")
Frame_250.Position = UDim2.new(0, 0, 0, 0)
Frame_250.Size = UDim2.new(1, 0, 0, 18)
Frame_250.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_250.BackgroundTransparency = 1
Frame_250.BorderSizePixel = 0
Frame_250.LayoutOrder = 35
Frame_250.Parent = Page_Visual_244

TextLabel_251 = Instance.new("TextLabel")
TextLabel_251.Position = UDim2.new(0, 8, 0, 0)
TextLabel_251.Size = UDim2.new(1, -8, 1, 0)
TextLabel_251.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_251.BackgroundTransparency = 1
TextLabel_251.BorderSizePixel = 1
TextLabel_251.Text = "VISUAL"
TextLabel_251.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_251.TextSize = 9
TextLabel_251.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_251.Font = Enum.Font.GothamBlack
TextLabel_251.Parent = Frame_250

Frame_252 = Instance.new("Frame")
Frame_252.Position = UDim2.new(0, 0, 0, 0)
Frame_252.Size = UDim2.new(1, 0, 0, 4)
Frame_252.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_252.BackgroundTransparency = 1
Frame_252.BorderSizePixel = 0
Frame_252.LayoutOrder = 36
Frame_252.Parent = Page_Visual_244

Frame_253 = Instance.new("Frame")
Frame_253.Position = UDim2.new(0, 0, 0, 0)
Frame_253.Size = UDim2.new(1, 0, 0, 18)
Frame_253.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_253.BackgroundTransparency = 1
Frame_253.BorderSizePixel = 0
Frame_253.LayoutOrder = 37
Frame_253.Parent = Page_Visual_244

TextLabel_254 = Instance.new("TextLabel")
TextLabel_254.Position = UDim2.new(0, 8, 0, 0)
TextLabel_254.Size = UDim2.new(1, -8, 1, 0)
TextLabel_254.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_254.BackgroundTransparency = 1
TextLabel_254.BorderSizePixel = 1
TextLabel_254.Text = "MISC"
TextLabel_254.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_254.TextSize = 9
TextLabel_254.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_254.Font = Enum.Font.GothamBlack
TextLabel_254.Parent = Frame_253

Frame_255 = Instance.new("Frame")
Frame_255.Position = UDim2.new(0, 0, 0, 0)
Frame_255.Size = UDim2.new(1, 0, 0, 32)
Frame_255.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_255.BorderSizePixel = 0
Frame_255.LayoutOrder = 38
Frame_255.Parent = Page_Visual_244

UICorner_256 = Instance.new("UICorner")
UICorner_256.CornerRadius = UDim.new(0, 10)
UICorner_256.Parent = Frame_255

UIStroke_257 = Instance.new("UIStroke")
UIStroke_257.Color = Color3.fromRGB(28, 28, 34)
UIStroke_257.Thickness = 1
UIStroke_257.Parent = Frame_255

TextLabel_258 = Instance.new("TextLabel")
TextLabel_258.Position = UDim2.new(0, 9, 0, 0)
TextLabel_258.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_258.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_258.BackgroundTransparency = 1
TextLabel_258.BorderSizePixel = 1
TextLabel_258.Text = "Instant Reset"
TextLabel_258.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_258.TextSize = 11
TextLabel_258.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_258.Font = Enum.Font.GothamBold
TextLabel_258.Parent = Frame_255

TextButton_259 = Instance.new("TextButton")
TextButton_259.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_259.Size = UDim2.new(0, 46, 0, 22)
TextButton_259.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_259.BorderSizePixel = 0
TextButton_259.ZIndex = 5
TextButton_259.Active = true
TextButton_259.Text = "T"
TextButton_259.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_259.TextSize = 9
TextButton_259.Font = Enum.Font.GothamBold
TextButton_259.Parent = Frame_255

UICorner_260 = Instance.new("UICorner")
UICorner_260.CornerRadius = UDim.new(0, 5)
UICorner_260.Parent = TextButton_259

TextButton_261 = Instance.new("TextButton")
TextButton_261.Position = UDim2.new(0, 0, 0, 0)
TextButton_261.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextButton_261.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_261.BackgroundTransparency = 1
TextButton_261.BorderSizePixel = 1
TextButton_261.ZIndex = 2
TextButton_261.Active = true
TextButton_261.Text = ""
TextButton_261.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_261.TextSize = 8
TextButton_261.Parent = Frame_255

Frame_262 = Instance.new("Frame")
Frame_262.Position = UDim2.new(0, 0, 0, 0)
Frame_262.Size = UDim2.new(1, 0, 0, 32)
Frame_262.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_262.BorderSizePixel = 0
Frame_262.LayoutOrder = 39
Frame_262.Parent = Page_Visual_244

UICorner_263 = Instance.new("UICorner")
UICorner_263.CornerRadius = UDim.new(0, 10)
UICorner_263.Parent = Frame_262

UIStroke_264 = Instance.new("UIStroke")
UIStroke_264.Color = Color3.fromRGB(28, 28, 34)
UIStroke_264.Thickness = 1
UIStroke_264.Parent = Frame_262

TextLabel_265 = Instance.new("TextLabel")
TextLabel_265.Position = UDim2.new(0, 9, 0, 0)
TextLabel_265.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_265.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_265.BackgroundTransparency = 1
TextLabel_265.BorderSizePixel = 1
TextLabel_265.Text = "Infinite Jump"
TextLabel_265.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_265.TextSize = 11
TextLabel_265.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_265.Font = Enum.Font.GothamBold
TextLabel_265.Parent = Frame_262

Frame_266 = Instance.new("Frame")
Frame_266.Position = UDim2.new(1, -42, 0.5, -9)
Frame_266.Size = UDim2.new(0, 36, 0, 19)
Frame_266.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_266.BorderSizePixel = 0
Frame_266.ZIndex = 3
Frame_266.Parent = Frame_262

UICorner_267 = Instance.new("UICorner")
UICorner_267.CornerRadius = UDim.new(1, 0)
UICorner_267.Parent = Frame_266

Frame_268 = Instance.new("Frame")
Frame_268.Position = UDim2.new(0, 3, 0.5, -6)
Frame_268.Size = UDim2.new(0, 13, 0, 13)
Frame_268.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_268.BorderSizePixel = 0
Frame_268.ZIndex = 4
Frame_268.Parent = Frame_266

UICorner_269 = Instance.new("UICorner")
UICorner_269.CornerRadius = UDim.new(1, 0)
UICorner_269.Parent = Frame_268

TextButton_270 = Instance.new("TextButton")
TextButton_270.Position = UDim2.new(0, 0, 0, 0)
TextButton_270.Size = UDim2.new(1, 0, 1, 0)
TextButton_270.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_270.BackgroundTransparency = 1
TextButton_270.BorderSizePixel = 1
TextButton_270.ZIndex = 5
TextButton_270.Active = true
TextButton_270.Text = ""
TextButton_270.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_270.TextSize = 8
TextButton_270.Parent = Frame_266

Frame_271 = Instance.new("Frame")
Frame_271.Position = UDim2.new(0, 0, 0, 0)
Frame_271.Size = UDim2.new(1, 0, 0, 32)
Frame_271.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_271.BorderSizePixel = 0
Frame_271.LayoutOrder = 40
Frame_271.Parent = Page_Visual_244

UICorner_272 = Instance.new("UICorner")
UICorner_272.CornerRadius = UDim.new(0, 10)
UICorner_272.Parent = Frame_271

UIStroke_273 = Instance.new("UIStroke")
UIStroke_273.Color = Color3.fromRGB(28, 28, 34)
UIStroke_273.Thickness = 1
UIStroke_273.Parent = Frame_271

TextLabel_274 = Instance.new("TextLabel")
TextLabel_274.Position = UDim2.new(0, 9, 0, 0)
TextLabel_274.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_274.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_274.BackgroundTransparency = 1
TextLabel_274.BorderSizePixel = 1
TextLabel_274.Text = "Hold Inf Jump"
TextLabel_274.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_274.TextSize = 11
TextLabel_274.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_274.Font = Enum.Font.GothamBold
TextLabel_274.Parent = Frame_271

Frame_275 = Instance.new("Frame")
Frame_275.Position = UDim2.new(1, -42, 0.5, -9)
Frame_275.Size = UDim2.new(0, 36, 0, 19)
Frame_275.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_275.BorderSizePixel = 0
Frame_275.ZIndex = 3
Frame_275.Parent = Frame_271

UICorner_276 = Instance.new("UICorner")
UICorner_276.CornerRadius = UDim.new(1, 0)
UICorner_276.Parent = Frame_275

Frame_277 = Instance.new("Frame")
Frame_277.Position = UDim2.new(0, 3, 0.5, -6)
Frame_277.Size = UDim2.new(0, 13, 0, 13)
Frame_277.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_277.BorderSizePixel = 0
Frame_277.ZIndex = 4
Frame_277.Parent = Frame_275

UICorner_278 = Instance.new("UICorner")
UICorner_278.CornerRadius = UDim.new(1, 0)
UICorner_278.Parent = Frame_277

TextButton_279 = Instance.new("TextButton")
TextButton_279.Position = UDim2.new(0, 0, 0, 0)
TextButton_279.Size = UDim2.new(1, 0, 1, 0)
TextButton_279.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_279.BackgroundTransparency = 1
TextButton_279.BorderSizePixel = 1
TextButton_279.ZIndex = 5
TextButton_279.Active = true
TextButton_279.Text = ""
TextButton_279.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_279.TextSize = 8
TextButton_279.Parent = Frame_275

Frame_280 = Instance.new("Frame")
Frame_280.Position = UDim2.new(0, 0, 0, 0)
Frame_280.Size = UDim2.new(1, 0, 0, 32)
Frame_280.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_280.BorderSizePixel = 0
Frame_280.LayoutOrder = 41
Frame_280.Parent = Page_Visual_244

UICorner_281 = Instance.new("UICorner")
UICorner_281.CornerRadius = UDim.new(0, 10)
UICorner_281.Parent = Frame_280

UIStroke_282 = Instance.new("UIStroke")
UIStroke_282.Color = Color3.fromRGB(28, 28, 34)
UIStroke_282.Thickness = 1
UIStroke_282.Parent = Frame_280

TextLabel_283 = Instance.new("TextLabel")
TextLabel_283.Position = UDim2.new(0, 9, 0, 0)
TextLabel_283.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_283.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_283.BackgroundTransparency = 1
TextLabel_283.BorderSizePixel = 1
TextLabel_283.Text = "Anti Ragdoll"
TextLabel_283.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_283.TextSize = 11
TextLabel_283.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_283.Font = Enum.Font.GothamBold
TextLabel_283.Parent = Frame_280

Frame_284 = Instance.new("Frame")
Frame_284.Position = UDim2.new(1, -42, 0.5, -9)
Frame_284.Size = UDim2.new(0, 36, 0, 19)
Frame_284.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_284.BorderSizePixel = 0
Frame_284.ZIndex = 3
Frame_284.Parent = Frame_280

UICorner_285 = Instance.new("UICorner")
UICorner_285.CornerRadius = UDim.new(1, 0)
UICorner_285.Parent = Frame_284

Frame_286 = Instance.new("Frame")
Frame_286.Position = UDim2.new(0, 3, 0.5, -6)
Frame_286.Size = UDim2.new(0, 13, 0, 13)
Frame_286.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_286.BorderSizePixel = 0
Frame_286.ZIndex = 4
Frame_286.Parent = Frame_284

UICorner_287 = Instance.new("UICorner")
UICorner_287.CornerRadius = UDim.new(1, 0)
UICorner_287.Parent = Frame_286

TextButton_288 = Instance.new("TextButton")
TextButton_288.Position = UDim2.new(0, 0, 0, 0)
TextButton_288.Size = UDim2.new(1, 0, 1, 0)
TextButton_288.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_288.BackgroundTransparency = 1
TextButton_288.BorderSizePixel = 1
TextButton_288.ZIndex = 5
TextButton_288.Active = true
TextButton_288.Text = ""
TextButton_288.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_288.TextSize = 8
TextButton_288.Parent = Frame_284

Frame_289 = Instance.new("Frame")
Frame_289.Position = UDim2.new(0, 0, 0, 0)
Frame_289.Size = UDim2.new(1, 0, 0, 32)
Frame_289.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_289.BorderSizePixel = 0
Frame_289.LayoutOrder = 42
Frame_289.Parent = Page_Visual_244

UICorner_290 = Instance.new("UICorner")
UICorner_290.CornerRadius = UDim.new(0, 10)
UICorner_290.Parent = Frame_289

UIStroke_291 = Instance.new("UIStroke")
UIStroke_291.Color = Color3.fromRGB(28, 28, 34)
UIStroke_291.Thickness = 1
UIStroke_291.Parent = Frame_289

TextLabel_292 = Instance.new("TextLabel")
TextLabel_292.Position = UDim2.new(0, 9, 0, 0)
TextLabel_292.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_292.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_292.BackgroundTransparency = 1
TextLabel_292.BorderSizePixel = 1
TextLabel_292.Text = "Medusa Counter"
TextLabel_292.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_292.TextSize = 11
TextLabel_292.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_292.Font = Enum.Font.GothamBold
TextLabel_292.Parent = Frame_289

Frame_293 = Instance.new("Frame")
Frame_293.Position = UDim2.new(1, -42, 0.5, -9)
Frame_293.Size = UDim2.new(0, 36, 0, 19)
Frame_293.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_293.BorderSizePixel = 0
Frame_293.ZIndex = 3
Frame_293.Parent = Frame_289

UICorner_294 = Instance.new("UICorner")
UICorner_294.CornerRadius = UDim.new(1, 0)
UICorner_294.Parent = Frame_293

Frame_295 = Instance.new("Frame")
Frame_295.Position = UDim2.new(0, 3, 0.5, -6)
Frame_295.Size = UDim2.new(0, 13, 0, 13)
Frame_295.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_295.BorderSizePixel = 0
Frame_295.ZIndex = 4
Frame_295.Parent = Frame_293

UICorner_296 = Instance.new("UICorner")
UICorner_296.CornerRadius = UDim.new(1, 0)
UICorner_296.Parent = Frame_295

TextButton_297 = Instance.new("TextButton")
TextButton_297.Position = UDim2.new(0, 0, 0, 0)
TextButton_297.Size = UDim2.new(1, 0, 1, 0)
TextButton_297.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_297.BackgroundTransparency = 1
TextButton_297.BorderSizePixel = 1
TextButton_297.ZIndex = 5
TextButton_297.Active = true
TextButton_297.Text = ""
TextButton_297.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_297.TextSize = 8
TextButton_297.Parent = Frame_293

Frame_298 = Instance.new("Frame")
Frame_298.Position = UDim2.new(0, 0, 0, 0)
Frame_298.Size = UDim2.new(1, 0, 0, 32)
Frame_298.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_298.BorderSizePixel = 0
Frame_298.LayoutOrder = 43
Frame_298.Parent = Page_Visual_244

UICorner_299 = Instance.new("UICorner")
UICorner_299.CornerRadius = UDim.new(0, 10)
UICorner_299.Parent = Frame_298

UIStroke_300 = Instance.new("UIStroke")
UIStroke_300.Color = Color3.fromRGB(28, 28, 34)
UIStroke_300.Thickness = 1
UIStroke_300.Parent = Frame_298

TextLabel_301 = Instance.new("TextLabel")
TextLabel_301.Position = UDim2.new(0, 9, 0, 0)
TextLabel_301.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_301.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_301.BackgroundTransparency = 1
TextLabel_301.BorderSizePixel = 1
TextLabel_301.Text = "Unwalk"
TextLabel_301.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_301.TextSize = 11
TextLabel_301.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_301.Font = Enum.Font.GothamBold
TextLabel_301.Parent = Frame_298

Frame_302 = Instance.new("Frame")
Frame_302.Position = UDim2.new(1, -42, 0.5, -9)
Frame_302.Size = UDim2.new(0, 36, 0, 19)
Frame_302.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_302.BorderSizePixel = 0
Frame_302.ZIndex = 3
Frame_302.Parent = Frame_298

UICorner_303 = Instance.new("UICorner")
UICorner_303.CornerRadius = UDim.new(1, 0)
UICorner_303.Parent = Frame_302

Frame_304 = Instance.new("Frame")
Frame_304.Position = UDim2.new(0, 3, 0.5, -6)
Frame_304.Size = UDim2.new(0, 13, 0, 13)
Frame_304.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_304.BorderSizePixel = 0
Frame_304.ZIndex = 4
Frame_304.Parent = Frame_302

UICorner_305 = Instance.new("UICorner")
UICorner_305.CornerRadius = UDim.new(1, 0)
UICorner_305.Parent = Frame_304

TextButton_306 = Instance.new("TextButton")
TextButton_306.Position = UDim2.new(0, 0, 0, 0)
TextButton_306.Size = UDim2.new(1, 0, 1, 0)
TextButton_306.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_306.BackgroundTransparency = 1
TextButton_306.BorderSizePixel = 1
TextButton_306.ZIndex = 5
TextButton_306.Active = true
TextButton_306.Text = ""
TextButton_306.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_306.TextSize = 8
TextButton_306.Parent = Frame_302

Frame_307 = Instance.new("Frame")
Frame_307.Position = UDim2.new(0, 0, 0, 0)
Frame_307.Size = UDim2.new(1, 0, 0, 4)
Frame_307.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_307.BackgroundTransparency = 1
Frame_307.BorderSizePixel = 0
Frame_307.LayoutOrder = 44
Frame_307.Parent = Page_Visual_244

Frame_308 = Instance.new("Frame")
Frame_308.Position = UDim2.new(0, 0, 0, 0)
Frame_308.Size = UDim2.new(1, 0, 0, 18)
Frame_308.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_308.BackgroundTransparency = 1
Frame_308.BorderSizePixel = 0
Frame_308.LayoutOrder = 45
Frame_308.Parent = Page_Visual_244

TextLabel_309 = Instance.new("TextLabel")
TextLabel_309.Position = UDim2.new(0, 8, 0, 0)
TextLabel_309.Size = UDim2.new(1, -8, 1, 0)
TextLabel_309.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_309.BackgroundTransparency = 1
TextLabel_309.BorderSizePixel = 1
TextLabel_309.Text = "DISPLAY"
TextLabel_309.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_309.TextSize = 9
TextLabel_309.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_309.Font = Enum.Font.GothamBlack
TextLabel_309.Parent = Frame_308

Frame_310 = Instance.new("Frame")
Frame_310.Position = UDim2.new(0, 0, 0, 0)
Frame_310.Size = UDim2.new(1, 0, 0, 32)
Frame_310.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_310.BorderSizePixel = 0
Frame_310.LayoutOrder = 46
Frame_310.Parent = Page_Visual_244

UICorner_311 = Instance.new("UICorner")
UICorner_311.CornerRadius = UDim.new(0, 10)
UICorner_311.Parent = Frame_310

UIStroke_312 = Instance.new("UIStroke")
UIStroke_312.Color = Color3.fromRGB(28, 28, 34)
UIStroke_312.Thickness = 1
UIStroke_312.Parent = Frame_310

TextLabel_313 = Instance.new("TextLabel")
TextLabel_313.Position = UDim2.new(0, 9, 0, 0)
TextLabel_313.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_313.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_313.BackgroundTransparency = 1
TextLabel_313.BorderSizePixel = 1
TextLabel_313.Text = "Enemy ESP"
TextLabel_313.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_313.TextSize = 11
TextLabel_313.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_313.Font = Enum.Font.GothamBold
TextLabel_313.Parent = Frame_310

Frame_314 = Instance.new("Frame")
Frame_314.Position = UDim2.new(1, -42, 0.5, -9)
Frame_314.Size = UDim2.new(0, 36, 0, 19)
Frame_314.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_314.BorderSizePixel = 0
Frame_314.ZIndex = 3
Frame_314.Parent = Frame_310

UICorner_315 = Instance.new("UICorner")
UICorner_315.CornerRadius = UDim.new(1, 0)
UICorner_315.Parent = Frame_314

Frame_316 = Instance.new("Frame")
Frame_316.Position = UDim2.new(0, 3, 0.5, -6)
Frame_316.Size = UDim2.new(0, 13, 0, 13)
Frame_316.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_316.BorderSizePixel = 0
Frame_316.ZIndex = 4
Frame_316.Parent = Frame_314

UICorner_317 = Instance.new("UICorner")
UICorner_317.CornerRadius = UDim.new(1, 0)
UICorner_317.Parent = Frame_316

TextButton_318 = Instance.new("TextButton")
TextButton_318.Position = UDim2.new(0, 0, 0, 0)
TextButton_318.Size = UDim2.new(1, 0, 1, 0)
TextButton_318.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_318.BackgroundTransparency = 1
TextButton_318.BorderSizePixel = 1
TextButton_318.ZIndex = 5
TextButton_318.Active = true
TextButton_318.Text = ""
TextButton_318.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_318.TextSize = 8
TextButton_318.Parent = Frame_314

Frame_319 = Instance.new("Frame")
Frame_319.Position = UDim2.new(0, 0, 0, 0)
Frame_319.Size = UDim2.new(1, 0, 0, 32)
Frame_319.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_319.BorderSizePixel = 0
Frame_319.LayoutOrder = 47
Frame_319.Parent = Page_Visual_244

UICorner_320 = Instance.new("UICorner")
UICorner_320.CornerRadius = UDim.new(0, 10)
UICorner_320.Parent = Frame_319

UIStroke_321 = Instance.new("UIStroke")
UIStroke_321.Color = Color3.fromRGB(28, 28, 34)
UIStroke_321.Thickness = 1
UIStroke_321.Parent = Frame_319

TextLabel_322 = Instance.new("TextLabel")
TextLabel_322.Position = UDim2.new(0, 9, 0, 0)
TextLabel_322.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_322.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_322.BackgroundTransparency = 1
TextLabel_322.BorderSizePixel = 1
TextLabel_322.Text = "Enemy Speed"
TextLabel_322.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_322.TextSize = 11
TextLabel_322.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_322.Font = Enum.Font.GothamBold
TextLabel_322.Parent = Frame_319

Frame_323 = Instance.new("Frame")
Frame_323.Position = UDim2.new(1, -42, 0.5, -9)
Frame_323.Size = UDim2.new(0, 36, 0, 19)
Frame_323.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_323.BorderSizePixel = 0
Frame_323.ZIndex = 3
Frame_323.Parent = Frame_319

UICorner_324 = Instance.new("UICorner")
UICorner_324.CornerRadius = UDim.new(1, 0)
UICorner_324.Parent = Frame_323

Frame_325 = Instance.new("Frame")
Frame_325.Position = UDim2.new(0, 3, 0.5, -6)
Frame_325.Size = UDim2.new(0, 13, 0, 13)
Frame_325.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_325.BorderSizePixel = 0
Frame_325.ZIndex = 4
Frame_325.Parent = Frame_323

UICorner_326 = Instance.new("UICorner")
UICorner_326.CornerRadius = UDim.new(1, 0)
UICorner_326.Parent = Frame_325

TextButton_327 = Instance.new("TextButton")
TextButton_327.Position = UDim2.new(0, 0, 0, 0)
TextButton_327.Size = UDim2.new(1, 0, 1, 0)
TextButton_327.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_327.BackgroundTransparency = 1
TextButton_327.BorderSizePixel = 1
TextButton_327.ZIndex = 5
TextButton_327.Active = true
TextButton_327.Text = ""
TextButton_327.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_327.TextSize = 8
TextButton_327.Parent = Frame_323

Frame_328 = Instance.new("Frame")
Frame_328.Position = UDim2.new(0, 0, 0, 0)
Frame_328.Size = UDim2.new(1, 0, 0, 32)
Frame_328.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_328.BorderSizePixel = 0
Frame_328.LayoutOrder = 48
Frame_328.Parent = Page_Visual_244

UICorner_329 = Instance.new("UICorner")
UICorner_329.CornerRadius = UDim.new(0, 10)
UICorner_329.Parent = Frame_328

UIStroke_330 = Instance.new("UIStroke")
UIStroke_330.Color = Color3.fromRGB(28, 28, 34)
UIStroke_330.Thickness = 1
UIStroke_330.Parent = Frame_328

TextLabel_331 = Instance.new("TextLabel")
TextLabel_331.Position = UDim2.new(0, 9, 0, 0)
TextLabel_331.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_331.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_331.BackgroundTransparency = 1
TextLabel_331.BorderSizePixel = 1
TextLabel_331.Text = "Anti Lag"
TextLabel_331.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_331.TextSize = 11
TextLabel_331.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_331.Font = Enum.Font.GothamBold
TextLabel_331.Parent = Frame_328

Frame_332 = Instance.new("Frame")
Frame_332.Position = UDim2.new(1, -42, 0.5, -9)
Frame_332.Size = UDim2.new(0, 36, 0, 19)
Frame_332.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_332.BorderSizePixel = 0
Frame_332.ZIndex = 3
Frame_332.Parent = Frame_328

UICorner_333 = Instance.new("UICorner")
UICorner_333.CornerRadius = UDim.new(1, 0)
UICorner_333.Parent = Frame_332

Frame_334 = Instance.new("Frame")
Frame_334.Position = UDim2.new(0, 3, 0.5, -6)
Frame_334.Size = UDim2.new(0, 13, 0, 13)
Frame_334.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_334.BorderSizePixel = 0
Frame_334.ZIndex = 4
Frame_334.Parent = Frame_332

UICorner_335 = Instance.new("UICorner")
UICorner_335.CornerRadius = UDim.new(1, 0)
UICorner_335.Parent = Frame_334

TextButton_336 = Instance.new("TextButton")
TextButton_336.Position = UDim2.new(0, 0, 0, 0)
TextButton_336.Size = UDim2.new(1, 0, 1, 0)
TextButton_336.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_336.BackgroundTransparency = 1
TextButton_336.BorderSizePixel = 1
TextButton_336.ZIndex = 5
TextButton_336.Active = true
TextButton_336.Text = ""
TextButton_336.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_336.TextSize = 8
TextButton_336.Parent = Frame_332

Frame_337 = Instance.new("Frame")
Frame_337.Position = UDim2.new(0, 0, 0, 0)
Frame_337.Size = UDim2.new(1, 0, 0, 32)
Frame_337.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_337.BorderSizePixel = 0
Frame_337.LayoutOrder = 49
Frame_337.Parent = Page_Visual_244

UICorner_338 = Instance.new("UICorner")
UICorner_338.CornerRadius = UDim.new(0, 10)
UICorner_338.Parent = Frame_337

UIStroke_339 = Instance.new("UIStroke")
UIStroke_339.Color = Color3.fromRGB(28, 28, 34)
UIStroke_339.Thickness = 1
UIStroke_339.Parent = Frame_337

TextLabel_340 = Instance.new("TextLabel")
TextLabel_340.Position = UDim2.new(0, 9, 0, 0)
TextLabel_340.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_340.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_340.BackgroundTransparency = 1
TextLabel_340.BorderSizePixel = 1
TextLabel_340.Text = "Stretch Rez"
TextLabel_340.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_340.TextSize = 11
TextLabel_340.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_340.Font = Enum.Font.GothamBold
TextLabel_340.Parent = Frame_337

Frame_341 = Instance.new("Frame")
Frame_341.Position = UDim2.new(1, -42, 0.5, -9)
Frame_341.Size = UDim2.new(0, 36, 0, 19)
Frame_341.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_341.BorderSizePixel = 0
Frame_341.ZIndex = 3
Frame_341.Parent = Frame_337

UICorner_342 = Instance.new("UICorner")
UICorner_342.CornerRadius = UDim.new(1, 0)
UICorner_342.Parent = Frame_341

Frame_343 = Instance.new("Frame")
Frame_343.Position = UDim2.new(0, 3, 0.5, -6)
Frame_343.Size = UDim2.new(0, 13, 0, 13)
Frame_343.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_343.BorderSizePixel = 0
Frame_343.ZIndex = 4
Frame_343.Parent = Frame_341

UICorner_344 = Instance.new("UICorner")
UICorner_344.CornerRadius = UDim.new(1, 0)
UICorner_344.Parent = Frame_343

TextButton_345 = Instance.new("TextButton")
TextButton_345.Position = UDim2.new(0, 0, 0, 0)
TextButton_345.Size = UDim2.new(1, 0, 1, 0)
TextButton_345.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_345.BackgroundTransparency = 1
TextButton_345.BorderSizePixel = 1
TextButton_345.ZIndex = 5
TextButton_345.Active = true
TextButton_345.Text = ""
TextButton_345.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_345.TextSize = 8
TextButton_345.Parent = Frame_341

Frame_346 = Instance.new("Frame")
Frame_346.Position = UDim2.new(0, 0, 0, 0)
Frame_346.Size = UDim2.new(1, 0, 0, 32)
Frame_346.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_346.BorderSizePixel = 0
Frame_346.LayoutOrder = 50
Frame_346.Parent = Page_Visual_244

UICorner_347 = Instance.new("UICorner")
UICorner_347.CornerRadius = UDim.new(0, 10)
UICorner_347.Parent = Frame_346

UIStroke_348 = Instance.new("UIStroke")
UIStroke_348.Color = Color3.fromRGB(28, 28, 34)
UIStroke_348.Thickness = 1
UIStroke_348.Parent = Frame_346

TextLabel_349 = Instance.new("TextLabel")
TextLabel_349.Position = UDim2.new(0, 9, 0, 0)
TextLabel_349.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_349.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_349.BackgroundTransparency = 1
TextLabel_349.BorderSizePixel = 1
TextLabel_349.Text = "Custom Font"
TextLabel_349.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_349.TextSize = 11
TextLabel_349.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_349.Font = Enum.Font.GothamBold
TextLabel_349.Parent = Frame_346

Frame_350 = Instance.new("Frame")
Frame_350.Position = UDim2.new(1, -42, 0.5, -9)
Frame_350.Size = UDim2.new(0, 36, 0, 19)
Frame_350.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_350.BorderSizePixel = 0
Frame_350.ZIndex = 3
Frame_350.Parent = Frame_346

UICorner_351 = Instance.new("UICorner")
UICorner_351.CornerRadius = UDim.new(1, 0)
UICorner_351.Parent = Frame_350

Frame_352 = Instance.new("Frame")
Frame_352.Position = UDim2.new(0, 3, 0.5, -6)
Frame_352.Size = UDim2.new(0, 13, 0, 13)
Frame_352.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_352.BorderSizePixel = 0
Frame_352.ZIndex = 4
Frame_352.Parent = Frame_350

UICorner_353 = Instance.new("UICorner")
UICorner_353.CornerRadius = UDim.new(1, 0)
UICorner_353.Parent = Frame_352

TextButton_354 = Instance.new("TextButton")
TextButton_354.Position = UDim2.new(0, 0, 0, 0)
TextButton_354.Size = UDim2.new(1, 0, 1, 0)
TextButton_354.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_354.BackgroundTransparency = 1
TextButton_354.BorderSizePixel = 1
TextButton_354.ZIndex = 5
TextButton_354.Active = true
TextButton_354.Text = ""
TextButton_354.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_354.TextSize = 8
TextButton_354.Parent = Frame_350

Frame_355 = Instance.new("Frame")
Frame_355.Position = UDim2.new(0, 0, 0, 0)
Frame_355.Size = UDim2.new(1, 0, 0, 32)
Frame_355.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_355.BorderSizePixel = 0
Frame_355.LayoutOrder = 51
Frame_355.Parent = Page_Visual_244

UICorner_356 = Instance.new("UICorner")
UICorner_356.CornerRadius = UDim.new(0, 10)
UICorner_356.Parent = Frame_355

UIStroke_357 = Instance.new("UIStroke")
UIStroke_357.Color = Color3.fromRGB(28, 28, 34)
UIStroke_357.Thickness = 1
UIStroke_357.Parent = Frame_355

TextLabel_358 = Instance.new("TextLabel")
TextLabel_358.Position = UDim2.new(0, 9, 0, 0)
TextLabel_358.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_358.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_358.BackgroundTransparency = 1
TextLabel_358.BorderSizePixel = 1
TextLabel_358.Text = "Custom FOV"
TextLabel_358.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_358.TextSize = 11
TextLabel_358.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_358.Font = Enum.Font.GothamBold
TextLabel_358.Parent = Frame_355

Frame_359 = Instance.new("Frame")
Frame_359.Position = UDim2.new(1, -42, 0.5, -9)
Frame_359.Size = UDim2.new(0, 36, 0, 19)
Frame_359.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_359.BorderSizePixel = 0
Frame_359.ZIndex = 3
Frame_359.Parent = Frame_355

UICorner_360 = Instance.new("UICorner")
UICorner_360.CornerRadius = UDim.new(1, 0)
UICorner_360.Parent = Frame_359

Frame_361 = Instance.new("Frame")
Frame_361.Position = UDim2.new(0, 3, 0.5, -6)
Frame_361.Size = UDim2.new(0, 13, 0, 13)
Frame_361.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_361.BorderSizePixel = 0
Frame_361.ZIndex = 4
Frame_361.Parent = Frame_359

UICorner_362 = Instance.new("UICorner")
UICorner_362.CornerRadius = UDim.new(1, 0)
UICorner_362.Parent = Frame_361

TextButton_363 = Instance.new("TextButton")
TextButton_363.Position = UDim2.new(0, 0, 0, 0)
TextButton_363.Size = UDim2.new(1, 0, 1, 0)
TextButton_363.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_363.BackgroundTransparency = 1
TextButton_363.BorderSizePixel = 1
TextButton_363.ZIndex = 5
TextButton_363.Active = true
TextButton_363.Text = ""
TextButton_363.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_363.TextSize = 8
TextButton_363.Parent = Frame_359

Frame_364 = Instance.new("Frame")
Frame_364.Position = UDim2.new(0, 0, 0, 0)
Frame_364.Size = UDim2.new(1, 0, 0, 32)
Frame_364.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_364.BorderSizePixel = 0
Frame_364.LayoutOrder = 52
Frame_364.Parent = Page_Visual_244

UICorner_365 = Instance.new("UICorner")
UICorner_365.CornerRadius = UDim.new(0, 10)
UICorner_365.Parent = Frame_364

UIStroke_366 = Instance.new("UIStroke")
UIStroke_366.Color = Color3.fromRGB(28, 28, 34)
UIStroke_366.Thickness = 1
UIStroke_366.Parent = Frame_364

TextLabel_367 = Instance.new("TextLabel")
TextLabel_367.Position = UDim2.new(0, 9, 0, 0)
TextLabel_367.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_367.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_367.BackgroundTransparency = 1
TextLabel_367.BorderSizePixel = 1
TextLabel_367.Text = "FOV Value"
TextLabel_367.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_367.TextSize = 11
TextLabel_367.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_367.Font = Enum.Font.GothamBold
TextLabel_367.Parent = Frame_364

TextBox_368 = Instance.new("TextBox")
TextBox_368.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_368.Size = UDim2.new(0, 50, 0, 22)
TextBox_368.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_368.BorderSizePixel = 0
TextBox_368.ZIndex = 5
TextBox_368.Active = true
TextBox_368.Text = "90"
TextBox_368.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_368.TextSize = 11
TextBox_368.Font = Enum.Font.GothamBold
TextBox_368.Parent = Frame_364

UICorner_369 = Instance.new("UICorner")
UICorner_369.CornerRadius = UDim.new(0, 5)
UICorner_369.Parent = TextBox_368

UIStroke_370 = Instance.new("UIStroke")
UIStroke_370.Color = Color3.fromRGB(140, 90, 200)
UIStroke_370.Thickness = 1
UIStroke_370.Parent = TextBox_368

Frame_371 = Instance.new("Frame")
Frame_371.Position = UDim2.new(0, 0, 0, 0)
Frame_371.Size = UDim2.new(1, 0, 0, 32)
Frame_371.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_371.BorderSizePixel = 0
Frame_371.LayoutOrder = 53
Frame_371.Parent = Page_Visual_244

UICorner_372 = Instance.new("UICorner")
UICorner_372.CornerRadius = UDim.new(0, 10)
UICorner_372.Parent = Frame_371

UIStroke_373 = Instance.new("UIStroke")
UIStroke_373.Color = Color3.fromRGB(28, 28, 34)
UIStroke_373.Thickness = 1
UIStroke_373.Parent = Frame_371

TextLabel_374 = Instance.new("TextLabel")
TextLabel_374.Position = UDim2.new(0, 9, 0, 0)
TextLabel_374.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_374.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_374.BackgroundTransparency = 1
TextLabel_374.BorderSizePixel = 1
TextLabel_374.Text = "Sky Presets"
TextLabel_374.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_374.TextSize = 11
TextLabel_374.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_374.Font = Enum.Font.GothamBold
TextLabel_374.Parent = Frame_371

TextButton_375 = Instance.new("TextButton")
TextButton_375.Position = UDim2.new(1, -90, 0.5, -11)
TextButton_375.Size = UDim2.new(0, 80, 0, 22)
TextButton_375.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
TextButton_375.BorderSizePixel = 0
TextButton_375.Active = true
TextButton_375.Text = "OPEN"
TextButton_375.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_375.TextSize = 10
TextButton_375.Font = Enum.Font.GothamBlack
TextButton_375.Parent = Frame_371

UICorner_376 = Instance.new("UICorner")
UICorner_376.CornerRadius = UDim.new(0, 5)
UICorner_376.Parent = TextButton_375

Frame_377 = Instance.new("Frame")
Frame_377.Position = UDim2.new(0, 0, 0, 0)
Frame_377.Size = UDim2.new(1, 0, 0, 32)
Frame_377.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_377.BorderSizePixel = 0
Frame_377.LayoutOrder = 54
Frame_377.Parent = Page_Visual_244

UICorner_378 = Instance.new("UICorner")
UICorner_378.CornerRadius = UDim.new(0, 10)
UICorner_378.Parent = Frame_377

UIStroke_379 = Instance.new("UIStroke")
UIStroke_379.Color = Color3.fromRGB(28, 28, 34)
UIStroke_379.Thickness = 1
UIStroke_379.Parent = Frame_377

TextLabel_380 = Instance.new("TextLabel")
TextLabel_380.Position = UDim2.new(0, 9, 0, 0)
TextLabel_380.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_380.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_380.BackgroundTransparency = 1
TextLabel_380.BorderSizePixel = 1
TextLabel_380.Text = "Background Image"
TextLabel_380.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_380.TextSize = 11
TextLabel_380.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_380.Font = Enum.Font.GothamBold
TextLabel_380.Parent = Frame_377

Frame_381 = Instance.new("Frame")
Frame_381.Position = UDim2.new(1, -42, 0.5, -9)
Frame_381.Size = UDim2.new(0, 36, 0, 19)
Frame_381.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_381.BorderSizePixel = 0
Frame_381.ZIndex = 3
Frame_381.Parent = Frame_377

UICorner_382 = Instance.new("UICorner")
UICorner_382.CornerRadius = UDim.new(1, 0)
UICorner_382.Parent = Frame_381

Frame_383 = Instance.new("Frame")
Frame_383.Position = UDim2.new(0, 3, 0.5, -6)
Frame_383.Size = UDim2.new(0, 13, 0, 13)
Frame_383.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_383.BorderSizePixel = 0
Frame_383.ZIndex = 4
Frame_383.Parent = Frame_381

UICorner_384 = Instance.new("UICorner")
UICorner_384.CornerRadius = UDim.new(1, 0)
UICorner_384.Parent = Frame_383

TextButton_385 = Instance.new("TextButton")
TextButton_385.Position = UDim2.new(0, 0, 0, 0)
TextButton_385.Size = UDim2.new(1, 0, 1, 0)
TextButton_385.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_385.BackgroundTransparency = 1
TextButton_385.BorderSizePixel = 1
TextButton_385.ZIndex = 5
TextButton_385.Active = true
TextButton_385.Text = ""
TextButton_385.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_385.TextSize = 8
TextButton_385.Parent = Frame_381

Frame_386 = Instance.new("Frame")
Frame_386.Position = UDim2.new(0, 0, 0, 0)
Frame_386.Size = UDim2.new(1, 0, 0, 32)
Frame_386.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_386.BorderSizePixel = 0
Frame_386.LayoutOrder = 55
Frame_386.Parent = Page_Visual_244

UICorner_387 = Instance.new("UICorner")
UICorner_387.CornerRadius = UDim.new(0, 10)
UICorner_387.Parent = Frame_386

UIStroke_388 = Instance.new("UIStroke")
UIStroke_388.Color = Color3.fromRGB(28, 28, 34)
UIStroke_388.Thickness = 1
UIStroke_388.Parent = Frame_386

TextLabel_389 = Instance.new("TextLabel")
TextLabel_389.Position = UDim2.new(0, 9, 0, 0)
TextLabel_389.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_389.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_389.BackgroundTransparency = 1
TextLabel_389.BorderSizePixel = 1
TextLabel_389.Text = "BG Image"
TextLabel_389.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_389.TextSize = 11
TextLabel_389.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_389.Font = Enum.Font.GothamBold
TextLabel_389.Parent = Frame_386

TextButton_390 = Instance.new("TextButton")
TextButton_390.Position = UDim2.new(1, -112, 0.5, -11)
TextButton_390.Size = UDim2.new(0, 26, 0, 22)
TextButton_390.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_390.BorderSizePixel = 0
TextButton_390.Active = true
TextButton_390.Text = "<"
TextButton_390.TextColor3 = Color3.fromRGB(185, 120, 255)
TextButton_390.TextSize = 12
TextButton_390.Font = Enum.Font.GothamBlack
TextButton_390.Parent = Frame_386

UICorner_391 = Instance.new("UICorner")
UICorner_391.CornerRadius = UDim.new(0, 5)
UICorner_391.Parent = TextButton_390

TextLabel_392 = Instance.new("TextLabel")
TextLabel_392.Position = UDim2.new(1, -84, 0.5, -11)
TextLabel_392.Size = UDim2.new(0, 56, 0, 22)
TextLabel_392.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextLabel_392.BorderSizePixel = 0
TextLabel_392.Text = "1/4"
TextLabel_392.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_392.TextSize = 10
TextLabel_392.Font = Enum.Font.GothamBold
TextLabel_392.Parent = Frame_386

UICorner_393 = Instance.new("UICorner")
UICorner_393.CornerRadius = UDim.new(0, 5)
UICorner_393.Parent = TextLabel_392

TextButton_394 = Instance.new("TextButton")
TextButton_394.Position = UDim2.new(1, -26, 0.5, -11)
TextButton_394.Size = UDim2.new(0, 26, 0, 22)
TextButton_394.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_394.BorderSizePixel = 0
TextButton_394.Active = true
TextButton_394.Text = ">"
TextButton_394.TextColor3 = Color3.fromRGB(185, 120, 255)
TextButton_394.TextSize = 12
TextButton_394.Font = Enum.Font.GothamBlack
TextButton_394.Parent = Frame_386

UICorner_395 = Instance.new("UICorner")
UICorner_395.CornerRadius = UDim.new(0, 5)
UICorner_395.Parent = TextButton_394

Frame_396 = Instance.new("Frame")
Frame_396.Position = UDim2.new(0, 0, 0, 0)
Frame_396.Size = UDim2.new(1, 0, 0, 32)
Frame_396.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_396.BorderSizePixel = 0
Frame_396.LayoutOrder = 56
Frame_396.Parent = Page_Visual_244

UICorner_397 = Instance.new("UICorner")
UICorner_397.CornerRadius = UDim.new(0, 10)
UICorner_397.Parent = Frame_396

UIStroke_398 = Instance.new("UIStroke")
UIStroke_398.Color = Color3.fromRGB(28, 28, 34)
UIStroke_398.Thickness = 1
UIStroke_398.Parent = Frame_396

TextLabel_399 = Instance.new("TextLabel")
TextLabel_399.Position = UDim2.new(0, 9, 0, 0)
TextLabel_399.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_399.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_399.BackgroundTransparency = 1
TextLabel_399.BorderSizePixel = 1
TextLabel_399.Text = "Logo Image"
TextLabel_399.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_399.TextSize = 11
TextLabel_399.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_399.Font = Enum.Font.GothamBold
TextLabel_399.Parent = Frame_396

TextButton_400 = Instance.new("TextButton")
TextButton_400.Position = UDim2.new(1, -112, 0.5, -11)
TextButton_400.Size = UDim2.new(0, 26, 0, 22)
TextButton_400.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_400.BorderSizePixel = 0
TextButton_400.Active = true
TextButton_400.Text = "<"
TextButton_400.TextColor3 = Color3.fromRGB(185, 120, 255)
TextButton_400.TextSize = 12
TextButton_400.Font = Enum.Font.GothamBlack
TextButton_400.Parent = Frame_396

UICorner_401 = Instance.new("UICorner")
UICorner_401.CornerRadius = UDim.new(0, 5)
UICorner_401.Parent = TextButton_400

TextLabel_402 = Instance.new("TextLabel")
TextLabel_402.Position = UDim2.new(1, -84, 0.5, -11)
TextLabel_402.Size = UDim2.new(0, 56, 0, 22)
TextLabel_402.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextLabel_402.BorderSizePixel = 0
TextLabel_402.Text = "1/3"
TextLabel_402.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_402.TextSize = 10
TextLabel_402.Font = Enum.Font.GothamBold
TextLabel_402.Parent = Frame_396

UICorner_403 = Instance.new("UICorner")
UICorner_403.CornerRadius = UDim.new(0, 5)
UICorner_403.Parent = TextLabel_402

TextButton_404 = Instance.new("TextButton")
TextButton_404.Position = UDim2.new(1, -26, 0.5, -11)
TextButton_404.Size = UDim2.new(0, 26, 0, 22)
TextButton_404.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_404.BorderSizePixel = 0
TextButton_404.Active = true
TextButton_404.Text = ">"
TextButton_404.TextColor3 = Color3.fromRGB(185, 120, 255)
TextButton_404.TextSize = 12
TextButton_404.Font = Enum.Font.GothamBlack
TextButton_404.Parent = Frame_396

UICorner_405 = Instance.new("UICorner")
UICorner_405.CornerRadius = UDim.new(0, 5)
UICorner_405.Parent = TextButton_404

Frame_406 = Instance.new("Frame")
Frame_406.Position = UDim2.new(0, 0, 0, 0)
Frame_406.Size = UDim2.new(1, 0, 0, 32)
Frame_406.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_406.BorderSizePixel = 0
Frame_406.LayoutOrder = 57
Frame_406.Parent = Page_Visual_244

UICorner_407 = Instance.new("UICorner")
UICorner_407.CornerRadius = UDim.new(0, 10)
UICorner_407.Parent = Frame_406

UIStroke_408 = Instance.new("UIStroke")
UIStroke_408.Color = Color3.fromRGB(28, 28, 34)
UIStroke_408.Thickness = 1
UIStroke_408.Parent = Frame_406

TextLabel_409 = Instance.new("TextLabel")
TextLabel_409.Position = UDim2.new(0, 9, 0, 0)
TextLabel_409.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_409.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_409.BackgroundTransparency = 1
TextLabel_409.BorderSizePixel = 1
TextLabel_409.Text = "BG Opacity"
TextLabel_409.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_409.TextSize = 11
TextLabel_409.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_409.Font = Enum.Font.GothamBold
TextLabel_409.Parent = Frame_406

TextBox_410 = Instance.new("TextBox")
TextBox_410.Position = UDim2.new(1, -48, 0.5, -11)
TextBox_410.Size = UDim2.new(0, 50, 0, 22)
TextBox_410.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_410.BorderSizePixel = 0
TextBox_410.ZIndex = 5
TextBox_410.Active = true
TextBox_410.Text = "0.6"
TextBox_410.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_410.TextSize = 11
TextBox_410.Font = Enum.Font.GothamBold
TextBox_410.Parent = Frame_406

UICorner_411 = Instance.new("UICorner")
UICorner_411.CornerRadius = UDim.new(0, 5)
UICorner_411.Parent = TextBox_410

UIStroke_412 = Instance.new("UIStroke")
UIStroke_412.Color = Color3.fromRGB(140, 90, 200)
UIStroke_412.Thickness = 1
UIStroke_412.Parent = TextBox_410

Frame_413 = Instance.new("Frame")
Frame_413.Position = UDim2.new(0, 0, 0, 0)
Frame_413.Size = UDim2.new(1, 0, 0, 4)
Frame_413.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_413.BackgroundTransparency = 1
Frame_413.BorderSizePixel = 0
Frame_413.LayoutOrder = 58
Frame_413.Parent = Page_Visual_244

Frame_414 = Instance.new("Frame")
Frame_414.Position = UDim2.new(0, 0, 0, 0)
Frame_414.Size = UDim2.new(1, 0, 0, 18)
Frame_414.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_414.BackgroundTransparency = 1
Frame_414.BorderSizePixel = 0
Frame_414.LayoutOrder = 59
Frame_414.Parent = Page_Visual_244

TextLabel_415 = Instance.new("TextLabel")
TextLabel_415.Position = UDim2.new(0, 8, 0, 0)
TextLabel_415.Size = UDim2.new(1, -8, 1, 0)
TextLabel_415.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_415.BackgroundTransparency = 1
TextLabel_415.BorderSizePixel = 1
TextLabel_415.Text = "MOVEMENT"
TextLabel_415.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_415.TextSize = 9
TextLabel_415.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_415.Font = Enum.Font.GothamBlack
TextLabel_415.Parent = Frame_414

Frame_416 = Instance.new("Frame")
Frame_416.Position = UDim2.new(0, 0, 0, 0)
Frame_416.Size = UDim2.new(1, 0, 0, 32)
Frame_416.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_416.BorderSizePixel = 0
Frame_416.LayoutOrder = 60
Frame_416.Parent = Page_Visual_244

UICorner_417 = Instance.new("UICorner")
UICorner_417.CornerRadius = UDim.new(0, 10)
UICorner_417.Parent = Frame_416

UIStroke_418 = Instance.new("UIStroke")
UIStroke_418.Color = Color3.fromRGB(28, 28, 34)
UIStroke_418.Thickness = 1
UIStroke_418.Parent = Frame_416

TextLabel_419 = Instance.new("TextLabel")
TextLabel_419.Position = UDim2.new(0, 9, 0, 0)
TextLabel_419.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_419.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_419.BackgroundTransparency = 1
TextLabel_419.BorderSizePixel = 1
TextLabel_419.Text = "Auto Left"
TextLabel_419.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_419.TextSize = 11
TextLabel_419.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_419.Font = Enum.Font.GothamBold
TextLabel_419.Parent = Frame_416

TextButton_420 = Instance.new("TextButton")
TextButton_420.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_420.Size = UDim2.new(0, 46, 0, 22)
TextButton_420.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_420.BorderSizePixel = 0
TextButton_420.ZIndex = 5
TextButton_420.Active = true
TextButton_420.Text = "Z"
TextButton_420.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_420.TextSize = 9
TextButton_420.Font = Enum.Font.GothamBold
TextButton_420.Parent = Frame_416

UICorner_421 = Instance.new("UICorner")
UICorner_421.CornerRadius = UDim.new(0, 5)
UICorner_421.Parent = TextButton_420

Frame_422 = Instance.new("Frame")
Frame_422.Position = UDim2.new(1, -102, 0.5, -9)
Frame_422.Size = UDim2.new(0, 36, 0, 19)
Frame_422.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_422.BorderSizePixel = 0
Frame_422.ZIndex = 3
Frame_422.Parent = Frame_416

UICorner_423 = Instance.new("UICorner")
UICorner_423.CornerRadius = UDim.new(1, 0)
UICorner_423.Parent = Frame_422

Frame_424 = Instance.new("Frame")
Frame_424.Position = UDim2.new(0, 3, 0.5, -6)
Frame_424.Size = UDim2.new(0, 13, 0, 13)
Frame_424.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_424.BorderSizePixel = 0
Frame_424.ZIndex = 4
Frame_424.Parent = Frame_422

UICorner_425 = Instance.new("UICorner")
UICorner_425.CornerRadius = UDim.new(1, 0)
UICorner_425.Parent = Frame_424

TextButton_426 = Instance.new("TextButton")
TextButton_426.Position = UDim2.new(0, 0, 0, 0)
TextButton_426.Size = UDim2.new(1, 0, 1, 0)
TextButton_426.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_426.BackgroundTransparency = 1
TextButton_426.BorderSizePixel = 1
TextButton_426.ZIndex = 5
TextButton_426.Active = true
TextButton_426.Text = ""
TextButton_426.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_426.TextSize = 8
TextButton_426.Parent = Frame_422

Frame_427 = Instance.new("Frame")
Frame_427.Position = UDim2.new(0, 0, 0, 0)
Frame_427.Size = UDim2.new(1, 0, 0, 32)
Frame_427.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_427.BorderSizePixel = 0
Frame_427.LayoutOrder = 61
Frame_427.Parent = Page_Visual_244

UICorner_428 = Instance.new("UICorner")
UICorner_428.CornerRadius = UDim.new(0, 10)
UICorner_428.Parent = Frame_427

UIStroke_429 = Instance.new("UIStroke")
UIStroke_429.Color = Color3.fromRGB(28, 28, 34)
UIStroke_429.Thickness = 1
UIStroke_429.Parent = Frame_427

TextLabel_430 = Instance.new("TextLabel")
TextLabel_430.Position = UDim2.new(0, 9, 0, 0)
TextLabel_430.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_430.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_430.BackgroundTransparency = 1
TextLabel_430.BorderSizePixel = 1
TextLabel_430.Text = "Auto Right"
TextLabel_430.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_430.TextSize = 11
TextLabel_430.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_430.Font = Enum.Font.GothamBold
TextLabel_430.Parent = Frame_427

TextButton_431 = Instance.new("TextButton")
TextButton_431.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_431.Size = UDim2.new(0, 46, 0, 22)
TextButton_431.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_431.BorderSizePixel = 0
TextButton_431.ZIndex = 5
TextButton_431.Active = true
TextButton_431.Text = "C"
TextButton_431.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_431.TextSize = 9
TextButton_431.Font = Enum.Font.GothamBold
TextButton_431.Parent = Frame_427

UICorner_432 = Instance.new("UICorner")
UICorner_432.CornerRadius = UDim.new(0, 5)
UICorner_432.Parent = TextButton_431

Frame_433 = Instance.new("Frame")
Frame_433.Position = UDim2.new(1, -102, 0.5, -9)
Frame_433.Size = UDim2.new(0, 36, 0, 19)
Frame_433.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_433.BorderSizePixel = 0
Frame_433.ZIndex = 3
Frame_433.Parent = Frame_427

UICorner_434 = Instance.new("UICorner")
UICorner_434.CornerRadius = UDim.new(1, 0)
UICorner_434.Parent = Frame_433

Frame_435 = Instance.new("Frame")
Frame_435.Position = UDim2.new(0, 3, 0.5, -6)
Frame_435.Size = UDim2.new(0, 13, 0, 13)
Frame_435.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_435.BorderSizePixel = 0
Frame_435.ZIndex = 4
Frame_435.Parent = Frame_433

UICorner_436 = Instance.new("UICorner")
UICorner_436.CornerRadius = UDim.new(1, 0)
UICorner_436.Parent = Frame_435

TextButton_437 = Instance.new("TextButton")
TextButton_437.Position = UDim2.new(0, 0, 0, 0)
TextButton_437.Size = UDim2.new(1, 0, 1, 0)
TextButton_437.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_437.BackgroundTransparency = 1
TextButton_437.BorderSizePixel = 1
TextButton_437.ZIndex = 5
TextButton_437.Active = true
TextButton_437.Text = ""
TextButton_437.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_437.TextSize = 8
TextButton_437.Parent = Frame_433

Frame_438 = Instance.new("Frame")
Frame_438.Position = UDim2.new(0, 0, 0, 0)
Frame_438.Size = UDim2.new(1, 0, 0, 32)
Frame_438.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_438.BorderSizePixel = 0
Frame_438.LayoutOrder = 62
Frame_438.Parent = Page_Visual_244

UICorner_439 = Instance.new("UICorner")
UICorner_439.CornerRadius = UDim.new(0, 10)
UICorner_439.Parent = Frame_438

UIStroke_440 = Instance.new("UIStroke")
UIStroke_440.Color = Color3.fromRGB(28, 28, 34)
UIStroke_440.Thickness = 1
UIStroke_440.Parent = Frame_438

TextLabel_441 = Instance.new("TextLabel")
TextLabel_441.Position = UDim2.new(0, 9, 0, 0)
TextLabel_441.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_441.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_441.BackgroundTransparency = 1
TextLabel_441.BorderSizePixel = 1
TextLabel_441.Text = "Drop Mode"
TextLabel_441.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_441.TextSize = 11
TextLabel_441.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_441.Font = Enum.Font.GothamBold
TextLabel_441.Parent = Frame_438

TextButton_442 = Instance.new("TextButton")
TextButton_442.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_442.Size = UDim2.new(0, 46, 0, 22)
TextButton_442.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_442.BorderSizePixel = 0
TextButton_442.ZIndex = 5
TextButton_442.Active = true
TextButton_442.Text = "X"
TextButton_442.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_442.TextSize = 9
TextButton_442.Font = Enum.Font.GothamBold
TextButton_442.Parent = Frame_438

UICorner_443 = Instance.new("UICorner")
UICorner_443.CornerRadius = UDim.new(0, 5)
UICorner_443.Parent = TextButton_442

TextButton_444 = Instance.new("TextButton")
TextButton_444.Position = UDim2.new(0, 0, 0, 0)
TextButton_444.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextButton_444.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_444.BackgroundTransparency = 1
TextButton_444.BorderSizePixel = 1
TextButton_444.ZIndex = 2
TextButton_444.Active = true
TextButton_444.Text = ""
TextButton_444.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_444.TextSize = 8
TextButton_444.Parent = Frame_438

Frame_445 = Instance.new("Frame")
Frame_445.Position = UDim2.new(0, 0, 0, 0)
Frame_445.Size = UDim2.new(1, 0, 0, 32)
Frame_445.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_445.BorderSizePixel = 0
Frame_445.LayoutOrder = 63
Frame_445.Parent = Page_Visual_244

UICorner_446 = Instance.new("UICorner")
UICorner_446.CornerRadius = UDim.new(0, 10)
UICorner_446.Parent = Frame_445

UIStroke_447 = Instance.new("UIStroke")
UIStroke_447.Color = Color3.fromRGB(28, 28, 34)
UIStroke_447.Thickness = 1
UIStroke_447.Parent = Frame_445

TextLabel_448 = Instance.new("TextLabel")
TextLabel_448.Position = UDim2.new(0, 9, 0, 0)
TextLabel_448.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_448.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_448.BackgroundTransparency = 1
TextLabel_448.BorderSizePixel = 1
TextLabel_448.Text = "Drop Type"
TextLabel_448.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_448.TextSize = 11
TextLabel_448.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_448.Font = Enum.Font.GothamBold
TextLabel_448.Parent = Frame_445

TextButton_449 = Instance.new("TextButton")
TextButton_449.Position = UDim2.new(1, -172, 0.5, -11)
TextButton_449.Size = UDim2.new(0, 80, 0, 22)
TextButton_449.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
TextButton_449.BorderSizePixel = 0
TextButton_449.Active = true
TextButton_449.Text = "TP Drop"
TextButton_449.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_449.TextSize = 10
TextButton_449.Font = Enum.Font.GothamBlack
TextButton_449.Parent = Frame_445

UICorner_450 = Instance.new("UICorner")
UICorner_450.CornerRadius = UDim.new(0, 5)
UICorner_450.Parent = TextButton_449

TextButton_451 = Instance.new("TextButton")
TextButton_451.Position = UDim2.new(1, -78, 0.5, -11)
TextButton_451.Size = UDim2.new(0, 90, 0, 22)
TextButton_451.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_451.BorderSizePixel = 0
TextButton_451.Active = true
TextButton_451.Text = "Stand Still"
TextButton_451.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_451.TextSize = 10
TextButton_451.Font = Enum.Font.GothamBlack
TextButton_451.Parent = Frame_445

UICorner_452 = Instance.new("UICorner")
UICorner_452.CornerRadius = UDim.new(0, 5)
UICorner_452.Parent = TextButton_451

Frame_453 = Instance.new("Frame")
Frame_453.Position = UDim2.new(0, 0, 0, 0)
Frame_453.Size = UDim2.new(1, 0, 0, 32)
Frame_453.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_453.BorderSizePixel = 0
Frame_453.LayoutOrder = 64
Frame_453.Parent = Page_Visual_244

UICorner_454 = Instance.new("UICorner")
UICorner_454.CornerRadius = UDim.new(0, 10)
UICorner_454.Parent = Frame_453

UIStroke_455 = Instance.new("UIStroke")
UIStroke_455.Color = Color3.fromRGB(28, 28, 34)
UIStroke_455.Thickness = 1
UIStroke_455.Parent = Frame_453

TextLabel_456 = Instance.new("TextLabel")
TextLabel_456.Position = UDim2.new(0, 9, 0, 0)
TextLabel_456.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_456.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_456.BackgroundTransparency = 1
TextLabel_456.BorderSizePixel = 1
TextLabel_456.Text = "TP Down"
TextLabel_456.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_456.TextSize = 11
TextLabel_456.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_456.Font = Enum.Font.GothamBold
TextLabel_456.Parent = Frame_453

TextButton_457 = Instance.new("TextButton")
TextButton_457.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_457.Size = UDim2.new(0, 46, 0, 22)
TextButton_457.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_457.BorderSizePixel = 0
TextButton_457.ZIndex = 5
TextButton_457.Active = true
TextButton_457.Text = "F"
TextButton_457.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_457.TextSize = 9
TextButton_457.Font = Enum.Font.GothamBold
TextButton_457.Parent = Frame_453

UICorner_458 = Instance.new("UICorner")
UICorner_458.CornerRadius = UDim.new(0, 5)
UICorner_458.Parent = TextButton_457

TextButton_459 = Instance.new("TextButton")
TextButton_459.Position = UDim2.new(0, 0, 0, 0)
TextButton_459.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextButton_459.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_459.BackgroundTransparency = 1
TextButton_459.BorderSizePixel = 1
TextButton_459.ZIndex = 2
TextButton_459.Active = true
TextButton_459.Text = ""
TextButton_459.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_459.TextSize = 8
TextButton_459.Parent = Frame_453

Frame_460 = Instance.new("Frame")
Frame_460.Position = UDim2.new(0, 0, 0, 0)
Frame_460.Size = UDim2.new(1, 0, 0, 32)
Frame_460.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_460.BorderSizePixel = 0
Frame_460.LayoutOrder = 65
Frame_460.Parent = Page_Visual_244

UICorner_461 = Instance.new("UICorner")
UICorner_461.CornerRadius = UDim.new(0, 10)
UICorner_461.Parent = Frame_460

UIStroke_462 = Instance.new("UIStroke")
UIStroke_462.Color = Color3.fromRGB(28, 28, 34)
UIStroke_462.Thickness = 1
UIStroke_462.Parent = Frame_460

TextLabel_463 = Instance.new("TextLabel")
TextLabel_463.Position = UDim2.new(0, 9, 0, 0)
TextLabel_463.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_463.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_463.BackgroundTransparency = 1
TextLabel_463.BorderSizePixel = 1
TextLabel_463.Text = "Auto TP"
TextLabel_463.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_463.TextSize = 11
TextLabel_463.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_463.Font = Enum.Font.GothamBold
TextLabel_463.Parent = Frame_460

Frame_464 = Instance.new("Frame")
Frame_464.Position = UDim2.new(1, -42, 0.5, -9)
Frame_464.Size = UDim2.new(0, 36, 0, 19)
Frame_464.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_464.BorderSizePixel = 0
Frame_464.ZIndex = 3
Frame_464.Parent = Frame_460

UICorner_465 = Instance.new("UICorner")
UICorner_465.CornerRadius = UDim.new(1, 0)
UICorner_465.Parent = Frame_464

Frame_466 = Instance.new("Frame")
Frame_466.Position = UDim2.new(0, 3, 0.5, -6)
Frame_466.Size = UDim2.new(0, 13, 0, 13)
Frame_466.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_466.BorderSizePixel = 0
Frame_466.ZIndex = 4
Frame_466.Parent = Frame_464

UICorner_467 = Instance.new("UICorner")
UICorner_467.CornerRadius = UDim.new(1, 0)
UICorner_467.Parent = Frame_466

TextButton_468 = Instance.new("TextButton")
TextButton_468.Position = UDim2.new(0, 0, 0, 0)
TextButton_468.Size = UDim2.new(1, 0, 1, 0)
TextButton_468.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_468.BackgroundTransparency = 1
TextButton_468.BorderSizePixel = 1
TextButton_468.ZIndex = 5
TextButton_468.Active = true
TextButton_468.Text = ""
TextButton_468.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_468.TextSize = 8
TextButton_468.Parent = Frame_464

Frame_469 = Instance.new("Frame")
Frame_469.Position = UDim2.new(0, 0, 0, 0)
Frame_469.Size = UDim2.new(1, 0, 0, 32)
Frame_469.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_469.BorderSizePixel = 0
Frame_469.LayoutOrder = 66
Frame_469.Parent = Page_Visual_244

UICorner_470 = Instance.new("UICorner")
UICorner_470.CornerRadius = UDim.new(0, 10)
UICorner_470.Parent = Frame_469

UIStroke_471 = Instance.new("UIStroke")
UIStroke_471.Color = Color3.fromRGB(28, 28, 34)
UIStroke_471.Thickness = 1
UIStroke_471.Parent = Frame_469

TextLabel_472 = Instance.new("TextLabel")
TextLabel_472.Position = UDim2.new(0, 9, 0, 0)
TextLabel_472.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_472.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_472.BackgroundTransparency = 1
TextLabel_472.BorderSizePixel = 1
TextLabel_472.Text = "Auto Reset on Death"
TextLabel_472.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_472.TextSize = 11
TextLabel_472.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_472.Font = Enum.Font.GothamBold
TextLabel_472.Parent = Frame_469

Frame_473 = Instance.new("Frame")
Frame_473.Position = UDim2.new(1, -42, 0.5, -9)
Frame_473.Size = UDim2.new(0, 36, 0, 19)
Frame_473.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_473.BorderSizePixel = 0
Frame_473.ZIndex = 3
Frame_473.Parent = Frame_469

UICorner_474 = Instance.new("UICorner")
UICorner_474.CornerRadius = UDim.new(1, 0)
UICorner_474.Parent = Frame_473

Frame_475 = Instance.new("Frame")
Frame_475.Position = UDim2.new(0, 3, 0.5, -6)
Frame_475.Size = UDim2.new(0, 13, 0, 13)
Frame_475.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_475.BorderSizePixel = 0
Frame_475.ZIndex = 4
Frame_475.Parent = Frame_473

UICorner_476 = Instance.new("UICorner")
UICorner_476.CornerRadius = UDim.new(1, 0)
UICorner_476.Parent = Frame_475

TextButton_477 = Instance.new("TextButton")
TextButton_477.Position = UDim2.new(0, 0, 0, 0)
TextButton_477.Size = UDim2.new(1, 0, 1, 0)
TextButton_477.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_477.BackgroundTransparency = 1
TextButton_477.BorderSizePixel = 1
TextButton_477.ZIndex = 5
TextButton_477.Active = true
TextButton_477.Text = ""
TextButton_477.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_477.TextSize = 8
TextButton_477.Parent = Frame_473

Frame_478 = Instance.new("Frame")
Frame_478.Position = UDim2.new(0, 0, 0, 0)
Frame_478.Size = UDim2.new(1, 0, 0, 32)
Frame_478.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_478.BorderSizePixel = 0
Frame_478.LayoutOrder = 67
Frame_478.Parent = Page_Visual_244

UICorner_479 = Instance.new("UICorner")
UICorner_479.CornerRadius = UDim.new(0, 10)
UICorner_479.Parent = Frame_478

UIStroke_480 = Instance.new("UIStroke")
UIStroke_480.Color = Color3.fromRGB(28, 28, 34)
UIStroke_480.Thickness = 1
UIStroke_480.Parent = Frame_478

TextLabel_481 = Instance.new("TextLabel")
TextLabel_481.Position = UDim2.new(0, 9, 0, 0)
TextLabel_481.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_481.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_481.BackgroundTransparency = 1
TextLabel_481.BorderSizePixel = 1
TextLabel_481.Text = "Auto TP Height"
TextLabel_481.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_481.TextSize = 11
TextLabel_481.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_481.Font = Enum.Font.GothamBold
TextLabel_481.Parent = Frame_478

TextBox_482 = Instance.new("TextBox")
TextBox_482.Position = UDim2.new(1, -56, 0.5, -11)
TextBox_482.Size = UDim2.new(0, 50, 0, 22)
TextBox_482.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextBox_482.BorderSizePixel = 0
TextBox_482.ZIndex = 5
TextBox_482.Active = true
TextBox_482.Text = "20"
TextBox_482.TextColor3 = Color3.fromRGB(245, 240, 255)
TextBox_482.TextSize = 11
TextBox_482.Font = Enum.Font.GothamBold
TextBox_482.Parent = Frame_478

UICorner_483 = Instance.new("UICorner")
UICorner_483.CornerRadius = UDim.new(0, 5)
UICorner_483.Parent = TextBox_482

UIStroke_484 = Instance.new("UIStroke")
UIStroke_484.Color = Color3.fromRGB(140, 90, 200)
UIStroke_484.Thickness = 1
UIStroke_484.Parent = TextBox_482

Page_Interface_485 = Instance.new("ScrollingFrame")
Page_Interface_485.Name = "Page_Interface"
Page_Interface_485.Position = UDim2.new(0, 0, 0, 0)
Page_Interface_485.Size = UDim2.new(1, 0, 1, 0)
Page_Interface_485.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Page_Interface_485.BackgroundTransparency = 1
Page_Interface_485.BorderSizePixel = 0
Page_Interface_485.Visible = false
Page_Interface_485.ClipsDescendants = true
Page_Interface_485.CanvasSize = UDim2.new(0, 0, 0, 0)
Page_Interface_485.ScrollBarThickness = 0
Page_Interface_485.ScrollingDirection = Enum.ScrollingDirection.XY
Page_Interface_485.Parent = Frame_55

UIListLayout_486 = Instance.new("UIListLayout")
UIListLayout_486.FillDirection = Enum.FillDirection.Vertical
UIListLayout_486.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout_486.Padding = UDim.new(0, 4)
UIListLayout_486.HorizontalAlignment = Enum.HorizontalAlignment.Left
UIListLayout_486.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout_486.Parent = Page_Interface_485

UIPadding_487 = Instance.new("UIPadding")
UIPadding_487.PaddingTop = UDim.new(0, 6)
UIPadding_487.PaddingBottom = UDim.new(0, 10)
UIPadding_487.PaddingLeft = UDim.new(0, 6)
UIPadding_487.PaddingRight = UDim.new(0, 6)
UIPadding_487.Parent = Page_Interface_485

Frame_488 = Instance.new("Frame")
Frame_488.Position = UDim2.new(0, 0, 0, 0)
Frame_488.Size = UDim2.new(1, 0, 0, 2)
Frame_488.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_488.BackgroundTransparency = 1
Frame_488.BorderSizePixel = 0
Frame_488.LayoutOrder = 68
Frame_488.Parent = Page_Interface_485

TextLabel_489 = Instance.new("TextLabel")
TextLabel_489.Position = UDim2.new(0, 8, 0, 0)
TextLabel_489.Size = UDim2.new(1, -8, 1, 0)
TextLabel_489.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_489.BackgroundTransparency = 1
TextLabel_489.BorderSizePixel = 1
TextLabel_489.Text = "INTERFACE"
TextLabel_489.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_489.TextSize = 8
TextLabel_489.Parent = Frame_488

Frame_490 = Instance.new("Frame")
Frame_490.Position = UDim2.new(0, 0, 0, 0)
Frame_490.Size = UDim2.new(1, 0, 0, 4)
Frame_490.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_490.BackgroundTransparency = 1
Frame_490.BorderSizePixel = 0
Frame_490.LayoutOrder = 69
Frame_490.Parent = Page_Interface_485

Frame_491 = Instance.new("Frame")
Frame_491.Position = UDim2.new(0, 0, 0, 0)
Frame_491.Size = UDim2.new(1, 0, 0, 18)
Frame_491.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_491.BackgroundTransparency = 1
Frame_491.BorderSizePixel = 0
Frame_491.LayoutOrder = 70
Frame_491.Parent = Page_Interface_485

TextLabel_492 = Instance.new("TextLabel")
TextLabel_492.Position = UDim2.new(0, 8, 0, 0)
TextLabel_492.Size = UDim2.new(1, -8, 1, 0)
TextLabel_492.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_492.BackgroundTransparency = 1
TextLabel_492.BorderSizePixel = 1
TextLabel_492.Text = "INTERFACE"
TextLabel_492.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_492.TextSize = 9
TextLabel_492.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_492.Font = Enum.Font.GothamBlack
TextLabel_492.Parent = Frame_491

Frame_493 = Instance.new("Frame")
Frame_493.Position = UDim2.new(0, 0, 0, 0)
Frame_493.Size = UDim2.new(1, 0, 0, 32)
Frame_493.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_493.BorderSizePixel = 0
Frame_493.LayoutOrder = 71
Frame_493.Parent = Page_Interface_485

UICorner_494 = Instance.new("UICorner")
UICorner_494.CornerRadius = UDim.new(0, 10)
UICorner_494.Parent = Frame_493

UIStroke_495 = Instance.new("UIStroke")
UIStroke_495.Color = Color3.fromRGB(28, 28, 34)
UIStroke_495.Thickness = 1
UIStroke_495.Parent = Frame_493

TextLabel_496 = Instance.new("TextLabel")
TextLabel_496.Position = UDim2.new(0, 9, 0, 0)
TextLabel_496.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_496.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_496.BackgroundTransparency = 1
TextLabel_496.BorderSizePixel = 1
TextLabel_496.Text = "Hide UI"
TextLabel_496.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_496.TextSize = 11
TextLabel_496.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_496.Font = Enum.Font.GothamBold
TextLabel_496.Parent = Frame_493

TextButton_497 = Instance.new("TextButton")
TextButton_497.Position = UDim2.new(1, -50, 0.5, -11)
TextButton_497.Size = UDim2.new(0, 46, 0, 22)
TextButton_497.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_497.BorderSizePixel = 0
TextButton_497.ZIndex = 5
TextButton_497.Active = true
TextButton_497.Text = "LeftControl"
TextButton_497.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_497.TextSize = 9
TextButton_497.Font = Enum.Font.GothamBold
TextButton_497.Parent = Frame_493

UICorner_498 = Instance.new("UICorner")
UICorner_498.CornerRadius = UDim.new(0, 5)
UICorner_498.Parent = TextButton_497

Frame_499 = Instance.new("Frame")
Frame_499.Position = UDim2.new(0, 0, 0, 0)
Frame_499.Size = UDim2.new(1, 0, 0, 32)
Frame_499.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_499.BorderSizePixel = 0
Frame_499.LayoutOrder = 72
Frame_499.Parent = Page_Interface_485

UICorner_500 = Instance.new("UICorner")
UICorner_500.CornerRadius = UDim.new(0, 10)
UICorner_500.Parent = Frame_499

UIStroke_501 = Instance.new("UIStroke")
UIStroke_501.Color = Color3.fromRGB(28, 28, 34)
UIStroke_501.Thickness = 1
UIStroke_501.Parent = Frame_499

TextLabel_502 = Instance.new("TextLabel")
TextLabel_502.Position = UDim2.new(0, 9, 0, 0)
TextLabel_502.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_502.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_502.BackgroundTransparency = 1
TextLabel_502.BorderSizePixel = 1
TextLabel_502.Text = "Lock UI"
TextLabel_502.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_502.TextSize = 11
TextLabel_502.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_502.Font = Enum.Font.GothamBold
TextLabel_502.Parent = Frame_499

Frame_503 = Instance.new("Frame")
Frame_503.Position = UDim2.new(1, -42, 0.5, -9)
Frame_503.Size = UDim2.new(0, 36, 0, 19)
Frame_503.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_503.BorderSizePixel = 0
Frame_503.ZIndex = 3
Frame_503.Parent = Frame_499

UICorner_504 = Instance.new("UICorner")
UICorner_504.CornerRadius = UDim.new(1, 0)
UICorner_504.Parent = Frame_503

Frame_505 = Instance.new("Frame")
Frame_505.Position = UDim2.new(0, 3, 0.5, -6)
Frame_505.Size = UDim2.new(0, 13, 0, 13)
Frame_505.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_505.BorderSizePixel = 0
Frame_505.ZIndex = 4
Frame_505.Parent = Frame_503

UICorner_506 = Instance.new("UICorner")
UICorner_506.CornerRadius = UDim.new(1, 0)
UICorner_506.Parent = Frame_505

TextButton_507 = Instance.new("TextButton")
TextButton_507.Position = UDim2.new(0, 0, 0, 0)
TextButton_507.Size = UDim2.new(1, 0, 1, 0)
TextButton_507.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_507.BackgroundTransparency = 1
TextButton_507.BorderSizePixel = 1
TextButton_507.ZIndex = 5
TextButton_507.Active = true
TextButton_507.Text = ""
TextButton_507.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_507.TextSize = 8
TextButton_507.Parent = Frame_503

Frame_508 = Instance.new("Frame")
Frame_508.Position = UDim2.new(0, 0, 0, 0)
Frame_508.Size = UDim2.new(1, 0, 0, 32)
Frame_508.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_508.BorderSizePixel = 0
Frame_508.LayoutOrder = 73
Frame_508.Parent = Page_Interface_485

UICorner_509 = Instance.new("UICorner")
UICorner_509.CornerRadius = UDim.new(0, 10)
UICorner_509.Parent = Frame_508

UIStroke_510 = Instance.new("UIStroke")
UIStroke_510.Color = Color3.fromRGB(28, 28, 34)
UIStroke_510.Thickness = 1
UIStroke_510.Parent = Frame_508

TextLabel_511 = Instance.new("TextLabel")
TextLabel_511.Position = UDim2.new(0, 9, 0, 0)
TextLabel_511.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_511.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_511.BackgroundTransparency = 1
TextLabel_511.BorderSizePixel = 1
TextLabel_511.Text = "Hide Side Buttons"
TextLabel_511.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_511.TextSize = 11
TextLabel_511.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_511.Font = Enum.Font.GothamBold
TextLabel_511.Parent = Frame_508

Frame_512 = Instance.new("Frame")
Frame_512.Position = UDim2.new(1, -42, 0.5, -9)
Frame_512.Size = UDim2.new(0, 36, 0, 19)
Frame_512.BackgroundColor3 = Color3.fromRGB(26, 18, 42)
Frame_512.BorderSizePixel = 0
Frame_512.ZIndex = 3
Frame_512.Parent = Frame_508

UICorner_513 = Instance.new("UICorner")
UICorner_513.CornerRadius = UDim.new(1, 0)
UICorner_513.Parent = Frame_512

Frame_514 = Instance.new("Frame")
Frame_514.Position = UDim2.new(0, 3, 0.5, -6)
Frame_514.Size = UDim2.new(0, 13, 0, 13)
Frame_514.BackgroundColor3 = Color3.fromRGB(190, 170, 230)
Frame_514.BorderSizePixel = 0
Frame_514.ZIndex = 4
Frame_514.Parent = Frame_512

UICorner_515 = Instance.new("UICorner")
UICorner_515.CornerRadius = UDim.new(1, 0)
UICorner_515.Parent = Frame_514

TextButton_516 = Instance.new("TextButton")
TextButton_516.Position = UDim2.new(0, 0, 0, 0)
TextButton_516.Size = UDim2.new(1, 0, 1, 0)
TextButton_516.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_516.BackgroundTransparency = 1
TextButton_516.BorderSizePixel = 1
TextButton_516.ZIndex = 5
TextButton_516.Active = true
TextButton_516.Text = ""
TextButton_516.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_516.TextSize = 8
TextButton_516.Parent = Frame_512

Frame_517 = Instance.new("Frame")
Frame_517.Position = UDim2.new(0, 0, 0, 0)
Frame_517.Size = UDim2.new(1, 0, 0, 32)
Frame_517.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_517.BorderSizePixel = 0
Frame_517.LayoutOrder = 74
Frame_517.Parent = Page_Interface_485

UICorner_518 = Instance.new("UICorner")
UICorner_518.CornerRadius = UDim.new(0, 10)
UICorner_518.Parent = Frame_517

UIStroke_519 = Instance.new("UIStroke")
UIStroke_519.Color = Color3.fromRGB(28, 28, 34)
UIStroke_519.Thickness = 1
UIStroke_519.Parent = Frame_517

TextLabel_520 = Instance.new("TextLabel")
TextLabel_520.Position = UDim2.new(0, 9, 0, 0)
TextLabel_520.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_520.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_520.BackgroundTransparency = 1
TextLabel_520.BorderSizePixel = 1
TextLabel_520.Text = "Button Size"
TextLabel_520.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_520.TextSize = 11
TextLabel_520.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_520.Font = Enum.Font.GothamBold
TextLabel_520.Parent = Frame_517

TextLabel_521 = Instance.new("TextLabel")
TextLabel_521.Position = UDim2.new(1, -108, 0, 0)
TextLabel_521.Size = UDim2.new(0, 30, 1, 0)
TextLabel_521.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_521.BackgroundTransparency = 1
TextLabel_521.BorderSizePixel = 1
TextLabel_521.Text = "100%"
TextLabel_521.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_521.TextSize = 11
TextLabel_521.Font = Enum.Font.GothamBlack
TextLabel_521.Parent = Frame_517

TextButton_522 = Instance.new("TextButton")
TextButton_522.Position = UDim2.new(1, -74, 0.5, -11)
TextButton_522.Size = UDim2.new(0, 28, 0, 22)
TextButton_522.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_522.BorderSizePixel = 0
TextButton_522.Active = true
TextButton_522.Text = "-"
TextButton_522.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_522.TextSize = 14
TextButton_522.Font = Enum.Font.GothamBlack
TextButton_522.Parent = Frame_517

UICorner_523 = Instance.new("UICorner")
UICorner_523.CornerRadius = UDim.new(0, 5)
UICorner_523.Parent = TextButton_522

TextButton_524 = Instance.new("TextButton")
TextButton_524.Position = UDim2.new(1, -42, 0.5, -11)
TextButton_524.Size = UDim2.new(0, 28, 0, 22)
TextButton_524.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_524.BorderSizePixel = 0
TextButton_524.Active = true
TextButton_524.Text = "+"
TextButton_524.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_524.TextSize = 14
TextButton_524.Font = Enum.Font.GothamBlack
TextButton_524.Parent = Frame_517

UICorner_525 = Instance.new("UICorner")
UICorner_525.CornerRadius = UDim.new(0, 5)
UICorner_525.Parent = TextButton_524

Frame_526 = Instance.new("Frame")
Frame_526.Position = UDim2.new(0, 0, 0, 0)
Frame_526.Size = UDim2.new(1, 0, 0, 4)
Frame_526.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_526.BackgroundTransparency = 1
Frame_526.BorderSizePixel = 0
Frame_526.LayoutOrder = 75
Frame_526.Parent = Page_Interface_485

Frame_527 = Instance.new("Frame")
Frame_527.Position = UDim2.new(0, 0, 0, 0)
Frame_527.Size = UDim2.new(1, 0, 0, 18)
Frame_527.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
Frame_527.BackgroundTransparency = 1
Frame_527.BorderSizePixel = 0
Frame_527.LayoutOrder = 76
Frame_527.Parent = Page_Interface_485

TextLabel_528 = Instance.new("TextLabel")
TextLabel_528.Position = UDim2.new(0, 8, 0, 0)
TextLabel_528.Size = UDim2.new(1, -8, 1, 0)
TextLabel_528.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_528.BackgroundTransparency = 1
TextLabel_528.BorderSizePixel = 1
TextLabel_528.Text = "INTRO SONG"
TextLabel_528.TextColor3 = Color3.fromRGB(185, 120, 255)
TextLabel_528.TextSize = 9
TextLabel_528.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_528.Font = Enum.Font.GothamBlack
TextLabel_528.Parent = Frame_527

Frame_529 = Instance.new("Frame")
Frame_529.Position = UDim2.new(0, 0, 0, 0)
Frame_529.Size = UDim2.new(1, 0, 0, 32)
Frame_529.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_529.BorderSizePixel = 0
Frame_529.LayoutOrder = 77
Frame_529.Parent = Page_Interface_485

UICorner_530 = Instance.new("UICorner")
UICorner_530.CornerRadius = UDim.new(0, 10)
UICorner_530.Parent = Frame_529

UIStroke_531 = Instance.new("UIStroke")
UIStroke_531.Color = Color3.fromRGB(28, 28, 34)
UIStroke_531.Thickness = 1
UIStroke_531.Parent = Frame_529

TextLabel_532 = Instance.new("TextLabel")
TextLabel_532.Position = UDim2.new(0, 9, 0, 0)
TextLabel_532.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_532.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_532.BackgroundTransparency = 1
TextLabel_532.BorderSizePixel = 1
TextLabel_532.Text = "Play Intro"
TextLabel_532.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_532.TextSize = 11
TextLabel_532.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_532.Font = Enum.Font.GothamBold
TextLabel_532.Parent = Frame_529

Frame_533 = Instance.new("Frame")
Frame_533.Position = UDim2.new(1, -42, 0.5, -9)
Frame_533.Size = UDim2.new(0, 36, 0, 19)
Frame_533.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
Frame_533.BorderSizePixel = 0
Frame_533.ZIndex = 3
Frame_533.Parent = Frame_529

UICorner_534 = Instance.new("UICorner")
UICorner_534.CornerRadius = UDim.new(1, 0)
UICorner_534.Parent = Frame_533

Frame_535 = Instance.new("Frame")
Frame_535.Position = UDim2.new(1, -16, 0.5, -6)
Frame_535.Size = UDim2.new(0, 13, 0, 13)
Frame_535.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
Frame_535.BorderSizePixel = 0
Frame_535.ZIndex = 4
Frame_535.Parent = Frame_533

UICorner_536 = Instance.new("UICorner")
UICorner_536.CornerRadius = UDim.new(1, 0)
UICorner_536.Parent = Frame_535

TextButton_537 = Instance.new("TextButton")
TextButton_537.Position = UDim2.new(0, 0, 0, 0)
TextButton_537.Size = UDim2.new(1, 0, 1, 0)
TextButton_537.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton_537.BackgroundTransparency = 1
TextButton_537.BorderSizePixel = 1
TextButton_537.ZIndex = 5
TextButton_537.Active = true
TextButton_537.Text = ""
TextButton_537.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton_537.TextSize = 8
TextButton_537.Parent = Frame_533

Frame_538 = Instance.new("Frame")
Frame_538.Position = UDim2.new(0, 0, 0, 0)
Frame_538.Size = UDim2.new(1, 0, 0, 32)
Frame_538.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_538.BorderSizePixel = 0
Frame_538.LayoutOrder = 78
Frame_538.Parent = Page_Interface_485

UICorner_539 = Instance.new("UICorner")
UICorner_539.CornerRadius = UDim.new(0, 10)
UICorner_539.Parent = Frame_538

UIStroke_540 = Instance.new("UIStroke")
UIStroke_540.Color = Color3.fromRGB(28, 28, 34)
UIStroke_540.Thickness = 1
UIStroke_540.Parent = Frame_538

TextLabel_541 = Instance.new("TextLabel")
TextLabel_541.Position = UDim2.new(0, 9, 0, 0)
TextLabel_541.Size = UDim2.new(0.5799999833106995, 0, 1, 0)
TextLabel_541.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_541.BackgroundTransparency = 1
TextLabel_541.BorderSizePixel = 1
TextLabel_541.Text = "Intro Song"
TextLabel_541.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_541.TextSize = 11
TextLabel_541.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_541.Font = Enum.Font.GothamBold
TextLabel_541.Parent = Frame_538

TextButton_542 = Instance.new("TextButton")
TextButton_542.Position = UDim2.new(1, -112, 0.5, -11)
TextButton_542.Size = UDim2.new(0, 26, 0, 22)
TextButton_542.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_542.BorderSizePixel = 0
TextButton_542.Active = true
TextButton_542.Text = "<"
TextButton_542.TextColor3 = Color3.fromRGB(185, 120, 255)
TextButton_542.TextSize = 12
TextButton_542.Font = Enum.Font.GothamBlack
TextButton_542.Parent = Frame_538

UICorner_543 = Instance.new("UICorner")
UICorner_543.CornerRadius = UDim.new(0, 5)
UICorner_543.Parent = TextButton_542

TextLabel_544 = Instance.new("TextLabel")
TextLabel_544.Position = UDim2.new(1, -84, 0.5, -11)
TextLabel_544.Size = UDim2.new(0, 56, 0, 22)
TextLabel_544.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextLabel_544.BorderSizePixel = 0
TextLabel_544.Text = "Song 1"
TextLabel_544.TextColor3 = Color3.fromRGB(245, 240, 255)
TextLabel_544.TextSize = 9
TextLabel_544.Font = Enum.Font.GothamBold
TextLabel_544.Parent = Frame_538

UICorner_545 = Instance.new("UICorner")
UICorner_545.CornerRadius = UDim.new(0, 5)
UICorner_545.Parent = TextLabel_544

TextButton_546 = Instance.new("TextButton")
TextButton_546.Position = UDim2.new(1, -26, 0.5, -11)
TextButton_546.Size = UDim2.new(0, 26, 0, 22)
TextButton_546.BackgroundColor3 = Color3.fromRGB(10, 7, 18)
TextButton_546.BorderSizePixel = 0
TextButton_546.Active = true
TextButton_546.Text = ">"
TextButton_546.TextColor3 = Color3.fromRGB(185, 120, 255)
TextButton_546.TextSize = 12
TextButton_546.Font = Enum.Font.GothamBlack
TextButton_546.Parent = Frame_538

UICorner_547 = Instance.new("UICorner")
UICorner_547.CornerRadius = UDim.new(0, 5)
UICorner_547.Parent = TextButton_546

Frame_548 = Instance.new("Frame")
Frame_548.Position = UDim2.new(0, 0, 0, 0)
Frame_548.Size = UDim2.new(1, 0, 0, 44)
Frame_548.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_548.BorderSizePixel = 0
Frame_548.LayoutOrder = 79
Frame_548.Parent = Page_Interface_485

UICorner_549 = Instance.new("UICorner")
UICorner_549.CornerRadius = UDim.new(0, 10)
UICorner_549.Parent = Frame_548

UIStroke_550 = Instance.new("UIStroke")
UIStroke_550.Color = Color3.fromRGB(28, 28, 34)
UIStroke_550.Thickness = 1
UIStroke_550.Parent = Frame_548

TextButton_551 = Instance.new("TextButton")
TextButton_551.Position = UDim2.new(0, 8, 0, 4)
TextButton_551.Size = UDim2.new(1, -16, 1, -8)
TextButton_551.BackgroundColor3 = Color3.fromRGB(40, 12, 26)
TextButton_551.BorderSizePixel = 0
TextButton_551.Active = true
TextButton_551.Text = "RESET BUTTON POSITIONS"
TextButton_551.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_551.TextSize = 11
TextButton_551.Font = Enum.Font.GothamBlack
TextButton_551.Parent = Frame_548

UICorner_552 = Instance.new("UICorner")
UICorner_552.CornerRadius = UDim.new(0, 6)
UICorner_552.Parent = TextButton_551

UIStroke_553 = Instance.new("UIStroke")
UIStroke_553.Color = Color3.fromRGB(255, 80, 120)
UIStroke_553.Thickness = 1.2000000476837158
UIStroke_553.Parent = TextButton_551

Frame_554 = Instance.new("Frame")
Frame_554.Position = UDim2.new(0, 0, 0, 0)
Frame_554.Size = UDim2.new(1, 0, 0, 44)
Frame_554.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Frame_554.BorderSizePixel = 0
Frame_554.LayoutOrder = 80
Frame_554.Parent = Page_Interface_485

UICorner_555 = Instance.new("UICorner")
UICorner_555.CornerRadius = UDim.new(0, 10)
UICorner_555.Parent = Frame_554

UIStroke_556 = Instance.new("UIStroke")
UIStroke_556.Color = Color3.fromRGB(28, 28, 34)
UIStroke_556.Thickness = 1
UIStroke_556.Parent = Frame_554

TextButton_557 = Instance.new("TextButton")
TextButton_557.Position = UDim2.new(0, 8, 0, 4)
TextButton_557.Size = UDim2.new(1, -16, 1, -8)
TextButton_557.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
TextButton_557.BorderSizePixel = 0
TextButton_557.Active = true
TextButton_557.Text = "SAVE SETTINGS"
TextButton_557.TextColor3 = Color3.fromRGB(245, 240, 255)
TextButton_557.TextSize = 12
TextButton_557.Font = Enum.Font.GothamBlack
TextButton_557.Parent = Frame_554

UICorner_558 = Instance.new("UICorner")
UICorner_558.CornerRadius = UDim.new(0, 6)
UICorner_558.Parent = TextButton_557

UIStroke_559 = Instance.new("UIStroke")
UIStroke_559.Color = Color3.fromRGB(185, 120, 255)
UIStroke_559.Thickness = 1.2000000476837158
UIStroke_559.Parent = TextButton_557

TextButton_560 = Instance.new("TextButton")
TextButton_560.Position = UDim2.new(0, 26, 0, 26)
TextButton_560.Size = UDim2.new(0, 108, 0, 28)
TextButton_560.BackgroundColor3 = Color3.fromRGB(11, 8, 18)
TextButton_560.BorderSizePixel = 0
TextButton_560.ZIndex = 20
TextButton_560.Visible = false
TextButton_560.Active = true
TextButton_560.Text = "MIRO | DUELS"
TextButton_560.TextColor3 = Color3.fromRGB(185, 120, 255)
TextButton_560.TextSize = 11
TextButton_560.Font = Enum.Font.GothamBold
TextButton_560.Parent = BirdHub_1

UICorner_561 = Instance.new("UICorner")
UICorner_561.CornerRadius = UDim.new(0, 8)
UICorner_561.Parent = TextButton_560

UIStroke_562 = Instance.new("UIStroke")
UIStroke_562.Color = Color3.fromRGB(140, 90, 200)
UIStroke_562.Thickness = 1.2000000476837158
UIStroke_562.Parent = TextButton_560

Frame_563 = Instance.new("Frame")
Frame_563.Position = UDim2.new(0.5, -160, 1, -72)
Frame_563.Size = UDim2.new(0, 320, 0, 46)
Frame_563.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Frame_563.BorderSizePixel = 0
Frame_563.ZIndex = 50
Frame_563.ClipsDescendants = true
Frame_563.Active = true
Frame_563.Parent = BirdHub_1

UICorner_564 = Instance.new("UICorner")
UICorner_564.CornerRadius = UDim.new(0, 10)
UICorner_564.Parent = Frame_563

UIStroke_565 = Instance.new("UIStroke")
UIStroke_565.Color = Color3.fromRGB(36, 36, 46)
UIStroke_565.Thickness = 1.2000000476837158
UIStroke_565.Parent = Frame_563

TextLabel_566 = Instance.new("TextLabel")
TextLabel_566.Position = UDim2.new(0, 0, 0, 6)
TextLabel_566.Size = UDim2.new(1, 0, 0, 14)
TextLabel_566.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_566.BackgroundTransparency = 1
TextLabel_566.BorderSizePixel = 1
TextLabel_566.ZIndex = 52
TextLabel_566.Text = "FPS:60 | PING:290ms"
TextLabel_566.TextColor3 = Color3.fromRGB(210, 200, 255)
TextLabel_566.TextSize = 11
TextLabel_566.Font = Enum.Font.GothamBold
TextLabel_566.Parent = Frame_563

TextLabel_567 = Instance.new("TextLabel")
TextLabel_567.Position = UDim2.new(0, 12, 0, 6)
TextLabel_567.Size = UDim2.new(0, 60, 0, 14)
TextLabel_567.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_567.BackgroundTransparency = 1
TextLabel_567.BorderSizePixel = 1
TextLabel_567.ZIndex = 53
TextLabel_567.Text = "0%"
TextLabel_567.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_567.TextSize = 12
TextLabel_567.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_567.Font = Enum.Font.GothamBold
TextLabel_567.Parent = Frame_563

TextLabel_568 = Instance.new("TextLabel")
TextLabel_568.Position = UDim2.new(1, -82, 0, 6)
TextLabel_568.Size = UDim2.new(0, 50, 0, 14)
TextLabel_568.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_568.BackgroundTransparency = 1
TextLabel_568.BorderSizePixel = 1
TextLabel_568.ZIndex = 51
TextLabel_568.Text = "Radius:"
TextLabel_568.TextColor3 = Color3.fromRGB(130, 120, 160)
TextLabel_568.TextSize = 11
TextLabel_568.TextXAlignment = Enum.TextXAlignment.Right
TextLabel_568.Font = Enum.Font.GothamBold
TextLabel_568.Parent = Frame_563

TextLabel_569 = Instance.new("TextLabel")
TextLabel_569.Position = UDim2.new(1, -32, 0, 5)
TextLabel_569.Size = UDim2.new(0, 28, 0, 16)
TextLabel_569.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextLabel_569.BackgroundTransparency = 1
TextLabel_569.BorderSizePixel = 1
TextLabel_569.ZIndex = 52
TextLabel_569.Text = "20"
TextLabel_569.TextColor3 = Color3.fromRGB(170, 111, 255)
TextLabel_569.TextSize = 12
TextLabel_569.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_569.Font = Enum.Font.GothamBold
TextLabel_569.Parent = Frame_563

Frame_570 = Instance.new("Frame")
Frame_570.Position = UDim2.new(0, 10, 1, -20)
Frame_570.Size = UDim2.new(1, -20, 0, 14)
Frame_570.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
Frame_570.BorderSizePixel = 0
Frame_570.ZIndex = 51
Frame_570.ClipsDescendants = true
Frame_570.Parent = Frame_563

UICorner_571 = Instance.new("UICorner")
UICorner_571.CornerRadius = UDim.new(0, 4)
UICorner_571.Parent = Frame_570

UIStroke_572 = Instance.new("UIStroke")
UIStroke_572.Color = Color3.fromRGB(80, 50, 120)
UIStroke_572.Thickness = 1
UIStroke_572.Parent = Frame_570

Frame_573 = Instance.new("Frame")
Frame_573.Position = UDim2.new(0, 0, 0, 0)
Frame_573.Size = UDim2.new(0, 0, 1, 0)
Frame_573.BackgroundColor3 = Color3.fromRGB(185, 120, 255)
Frame_573.BorderSizePixel = 0
Frame_573.ZIndex = 52
Frame_573.Parent = Frame_570

UICorner_574 = Instance.new("UICorner")
UICorner_574.CornerRadius = UDim.new(0, 4)
UICorner_574.Parent = Frame_573

UIGradient_575 = Instance.new("UIGradient")
UIGradient_575.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 100, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 85, 210))})
UIGradient_575.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})
UIGradient_575.Parent = Frame_573

MB_drop_576 = Instance.new("TextButton")
MB_drop_576.Name = "MB_drop"
MB_drop_576.Position = UDim2.new(1, -176, 0.5, -132)
MB_drop_576.Size = UDim2.new(0, 80, 0, 60)
MB_drop_576.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_drop_576.BorderSizePixel = 0
MB_drop_576.ZIndex = 101
MB_drop_576.Active = true
MB_drop_576.Text = "DROP\nBR"
MB_drop_576.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_drop_576.TextSize = 11
MB_drop_576.Font = Enum.Font.GothamBlack
MB_drop_576.Parent = BirdHub_1

UICorner_577 = Instance.new("UICorner")
UICorner_577.CornerRadius = UDim.new(0, 8)
UICorner_577.Parent = MB_drop_576

UIStroke_578 = Instance.new("UIStroke")
UIStroke_578.Color = Color3.fromRGB(50, 52, 60)
UIStroke_578.Thickness = 1
UIStroke_578.Transparency = 0.30000001192092896
UIStroke_578.Parent = MB_drop_576

MB_autoLeft_579 = Instance.new("TextButton")
MB_autoLeft_579.Name = "MB_autoLeft"
MB_autoLeft_579.Position = UDim2.new(1, -88, 0.5, -132)
MB_autoLeft_579.Size = UDim2.new(0, 80, 0, 60)
MB_autoLeft_579.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_autoLeft_579.BorderSizePixel = 0
MB_autoLeft_579.ZIndex = 101
MB_autoLeft_579.Active = true
MB_autoLeft_579.Text = "AUTO\nLEFT"
MB_autoLeft_579.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_autoLeft_579.TextSize = 11
MB_autoLeft_579.Font = Enum.Font.GothamBlack
MB_autoLeft_579.Parent = BirdHub_1

UICorner_580 = Instance.new("UICorner")
UICorner_580.CornerRadius = UDim.new(0, 8)
UICorner_580.Parent = MB_autoLeft_579

UIStroke_581 = Instance.new("UIStroke")
UIStroke_581.Color = Color3.fromRGB(50, 52, 60)
UIStroke_581.Thickness = 1
UIStroke_581.Transparency = 0.30000001192092896
UIStroke_581.Parent = MB_autoLeft_579

MB_bat_582 = Instance.new("TextButton")
MB_bat_582.Name = "MB_bat"
MB_bat_582.Position = UDim2.new(1, -176, 0.5, -64)
MB_bat_582.Size = UDim2.new(0, 80, 0, 60)
MB_bat_582.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_bat_582.BorderSizePixel = 0
MB_bat_582.ZIndex = 101
MB_bat_582.Active = true
MB_bat_582.Text = "BAT\nBOT"
MB_bat_582.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_bat_582.TextSize = 11
MB_bat_582.Font = Enum.Font.GothamBlack
MB_bat_582.Parent = BirdHub_1

UICorner_583 = Instance.new("UICorner")
UICorner_583.CornerRadius = UDim.new(0, 8)
UICorner_583.Parent = MB_bat_582

UIStroke_584 = Instance.new("UIStroke")
UIStroke_584.Color = Color3.fromRGB(50, 52, 60)
UIStroke_584.Thickness = 1
UIStroke_584.Transparency = 0.30000001192092896
UIStroke_584.Parent = MB_bat_582

MB_autoRight_585 = Instance.new("TextButton")
MB_autoRight_585.Name = "MB_autoRight"
MB_autoRight_585.Position = UDim2.new(1, -88, 0.5, -64)
MB_autoRight_585.Size = UDim2.new(0, 80, 0, 60)
MB_autoRight_585.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_autoRight_585.BorderSizePixel = 0
MB_autoRight_585.ZIndex = 101
MB_autoRight_585.Active = true
MB_autoRight_585.Text = "AUTO\nRIGHT"
MB_autoRight_585.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_autoRight_585.TextSize = 11
MB_autoRight_585.Font = Enum.Font.GothamBlack
MB_autoRight_585.Parent = BirdHub_1

UICorner_586 = Instance.new("UICorner")
UICorner_586.CornerRadius = UDim.new(0, 8)
UICorner_586.Parent = MB_autoRight_585

UIStroke_587 = Instance.new("UIStroke")
UIStroke_587.Color = Color3.fromRGB(50, 52, 60)
UIStroke_587.Thickness = 1
UIStroke_587.Transparency = 0.30000001192092896
UIStroke_587.Parent = MB_autoRight_585

MB_tp_588 = Instance.new("TextButton")
MB_tp_588.Name = "MB_tp"
MB_tp_588.Position = UDim2.new(1, -176, 0.5, 4)
MB_tp_588.Size = UDim2.new(0, 80, 0, 60)
MB_tp_588.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_tp_588.BorderSizePixel = 0
MB_tp_588.ZIndex = 101
MB_tp_588.Active = true
MB_tp_588.Text = "TP\nDOWN"
MB_tp_588.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_tp_588.TextSize = 11
MB_tp_588.Font = Enum.Font.GothamBlack
MB_tp_588.Parent = BirdHub_1

UICorner_589 = Instance.new("UICorner")
UICorner_589.CornerRadius = UDim.new(0, 8)
UICorner_589.Parent = MB_tp_588

UIStroke_590 = Instance.new("UIStroke")
UIStroke_590.Color = Color3.fromRGB(50, 52, 60)
UIStroke_590.Thickness = 1
UIStroke_590.Transparency = 0.30000001192092896
UIStroke_590.Parent = MB_tp_588

MB_carry_591 = Instance.new("TextButton")
MB_carry_591.Name = "MB_carry"
MB_carry_591.Position = UDim2.new(1, -88, 0.5, 4)
MB_carry_591.Size = UDim2.new(0, 80, 0, 60)
MB_carry_591.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_carry_591.BorderSizePixel = 0
MB_carry_591.ZIndex = 101
MB_carry_591.Active = true
MB_carry_591.Text = "CARRY\nSPD"
MB_carry_591.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_carry_591.TextSize = 11
MB_carry_591.Font = Enum.Font.GothamBlack
MB_carry_591.Parent = BirdHub_1

UICorner_592 = Instance.new("UICorner")
UICorner_592.CornerRadius = UDim.new(0, 8)
UICorner_592.Parent = MB_carry_591

UIStroke_593 = Instance.new("UIStroke")
UIStroke_593.Color = Color3.fromRGB(50, 52, 60)
UIStroke_593.Thickness = 1
UIStroke_593.Transparency = 0.30000001192092896
UIStroke_593.Parent = MB_carry_591

MB_instaReset_594 = Instance.new("TextButton")
MB_instaReset_594.Name = "MB_instaReset"
MB_instaReset_594.Position = UDim2.new(1, -176, 0.5, 72)
MB_instaReset_594.Size = UDim2.new(0, 80, 0, 60)
MB_instaReset_594.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_instaReset_594.BorderSizePixel = 0
MB_instaReset_594.ZIndex = 101
MB_instaReset_594.Active = true
MB_instaReset_594.Text = "INSTA\nRESET"
MB_instaReset_594.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_instaReset_594.TextSize = 11
MB_instaReset_594.Font = Enum.Font.GothamBlack
MB_instaReset_594.Parent = BirdHub_1

UICorner_595 = Instance.new("UICorner")
UICorner_595.CornerRadius = UDim.new(0, 8)
UICorner_595.Parent = MB_instaReset_594

UIStroke_596 = Instance.new("UIStroke")
UIStroke_596.Color = Color3.fromRGB(50, 52, 60)
UIStroke_596.Thickness = 1
UIStroke_596.Transparency = 0.30000001192092896
UIStroke_596.Parent = MB_instaReset_594

MB_lagger_597 = Instance.new("TextButton")
MB_lagger_597.Name = "MB_lagger"
MB_lagger_597.Position = UDim2.new(1, -88, 0.5, 72)
MB_lagger_597.Size = UDim2.new(0, 80, 0, 60)
MB_lagger_597.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_lagger_597.BorderSizePixel = 0
MB_lagger_597.ZIndex = 101
MB_lagger_597.Active = true
MB_lagger_597.Text = "LAGGER\nMODE"
MB_lagger_597.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_lagger_597.TextSize = 11
MB_lagger_597.Font = Enum.Font.GothamBlack
MB_lagger_597.Parent = BirdHub_1

UICorner_598 = Instance.new("UICorner")
UICorner_598.CornerRadius = UDim.new(0, 8)
UICorner_598.Parent = MB_lagger_597

UIStroke_599 = Instance.new("UIStroke")
UIStroke_599.Color = Color3.fromRGB(50, 52, 60)
UIStroke_599.Thickness = 1
UIStroke_599.Transparency = 0.30000001192092896
UIStroke_599.Parent = MB_lagger_597

MB_tpBat_600 = Instance.new("TextButton")
MB_tpBat_600.Name = "MB_tpBat"
MB_tpBat_600.Position = UDim2.new(1, -176, 0.5, 140)
MB_tpBat_600.Size = UDim2.new(0, 80, 0, 60)
MB_tpBat_600.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
MB_tpBat_600.BorderSizePixel = 0
MB_tpBat_600.ZIndex = 101
MB_tpBat_600.Active = true
MB_tpBat_600.Text = "TP\nBAT"
MB_tpBat_600.TextColor3 = Color3.fromRGB(240, 240, 245)
MB_tpBat_600.TextSize = 11
MB_tpBat_600.Font = Enum.Font.GothamBlack
MB_tpBat_600.Parent = BirdHub_1

UICorner_601 = Instance.new("UICorner")
UICorner_601.CornerRadius = UDim.new(0, 8)
UICorner_601.Parent = MB_tpBat_600

UIStroke_602 = Instance.new("UIStroke")
UIStroke_602.Color = Color3.fromRGB(50, 52, 60)
UIStroke_602.Thickness = 1
UIStroke_602.Transparency = 0.30000001192092896
UIStroke_602.Parent = MB_tpBat_600

-- ═══════════════════════════════════════════════════════════════
-- BIRD HUB — WORKING LOGIC RECONSTRUCTION
-- Reconstructed by @skixzs | 2026
-- Patched and stabilized
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function clamp(value, minValue, maxValue)
    value = tonumber(value)
    if not value then
        return minValue
    end
    if value < minValue then
        return minValue
    end
    if value > maxValue then
        return maxValue
    end
    return value
end

local function typeofSafe(value)
    local ok, result = pcall(function()
        return typeof(value)
    end)
    return ok and result or type(value)
end

local State = {
    speedEnabled = false,
    laggerMode = false,
    carryMode = false,
    normalSpeed = tonumber(TextBox_68 and TextBox_68.Text) or 60,
    carrySpeed = tonumber(TextBox_75 and TextBox_75.Text) or 30,
    laggerSpeed = tonumber(TextBox_82 and TextBox_82.Text) or 15,
    laggerCarrySpeed = tonumber(TextBox_89 and TextBox_89.Text) or 24.5,
    tpBat = false,
    batAimbot = false,
    batAimbotSpeed = tonumber(TextBox_153 and TextBox_153.Text) or 62,
    batAimbotSpeedLagger = tonumber(TextBox_160 and TextBox_160.Text) or 45,
    autoSwing = false,
    batCounter = false,
    batHitDist = tonumber(TextBox_167 and TextBox_167.Text) or 8,
    grabRadius = tonumber(TextBox_209 and TextBox_209.Text) or 20,
    espEnabled = false,
    infiniteJump = false,
    antiRagdoll = false,
    noclip = false,
    autoLeft = false,
    autoRight = false,
    autoSteal = false,
    tpDrop = false,
    instaReset = false,
    customFOV = tonumber(TextBox_368 and TextBox_368.Text) or 90,
    customFOVEnabled = false,
    bgEnabled = true,
    bgVariant = 1,
    logoVariant = 1,
    bgOpacity = clamp(TextBox_410 and TextBox_410.Text or 0.6, 0, 1),
    uiLocked = false,
    dropType = "tp",
}

local Connections = {}
local espObjects = {}
local lastFps = 60
local swingToken = 0
local defaultWalkSpeed = 16
local defaultJumpHeight = 7.2
local storageKey = "__BirdHubSavedSettings"

local backgroundVariants = {
    {label = "1/4", color = Color3.fromRGB(255, 255, 255)},
    {label = "2/4", color = Color3.fromRGB(230, 210, 255)},
    {label = "3/4", color = Color3.fromRGB(205, 180, 255)},
    {label = "4/4", color = Color3.fromRGB(180, 145, 255)},
}

local logoVariants = {
    {label = "1/3", color = Color3.fromRGB(255, 255, 255)},
    {label = "2/3", color = Color3.fromRGB(185, 120, 255)},
    {label = "3/3", color = Color3.fromRGB(245, 210, 255)},
}

local mobileButtons = {
    MB_drop_576,
    MB_autoLeft_579,
    MB_bat_582,
    MB_autoRight_585,
    MB_tp_588,
    MB_carry_591,
    MB_instaReset_594,
    MB_lagger_597,
    MB_tpBat_600,
}

local defaultMobilePositions = {}
for _, btn in ipairs(mobileButtons) do
    if btn then
        defaultMobilePositions[btn.Name] = btn.Position
    end
end

local function disconnect(name)
    local item = Connections[name]
    if not item then
        return
    end
    if typeofSafe(item) == "RBXScriptConnection" then
        pcall(function()
            item:Disconnect()
        end)
    end
    Connections[name] = nil
end

local function getChar()
    return player and player.Character
end

local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getCamera()
    return Workspace.CurrentCamera
end

local function setSwitch(track, knob, enabled)
    if not track or not knob then
        return
    end
    local trackGoal = {
        BackgroundColor3 = enabled and Color3.fromRGB(185, 120, 255) or Color3.fromRGB(26, 18, 42)
    }
    local knobGoal = {
        Position = enabled and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
        BackgroundColor3 = enabled and Color3.fromRGB(245, 240, 255) or Color3.fromRGB(190, 170, 230)
    }
    pcall(function()
        TweenService:Create(track, tweenInfo, trackGoal):Play()
    end)
    pcall(function()
        TweenService:Create(knob, tweenInfo, knobGoal):Play()
    end)
end

local function setMainUiVisible(visible)
    if Frame_2 then
        Frame_2.Visible = visible
    end
    if Frame_563 then
        Frame_563.Visible = visible
    end
    for _, btn in ipairs(mobileButtons) do
        if btn then
            btn.Visible = visible
        end
    end
    if TextButton_560 then
        TextButton_560.Visible = not visible
    end
end

local function getNearestPlayer(maxDist)
    maxDist = maxDist or 200
    local root = getRoot()
    if not root then
        return nil, nil
    end

    local nearest, nearDist = nil, maxDist
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
            local eHum = p.Character:FindFirstChildOfClass("Humanoid")
            if eRoot and eHum and eHum.Health > 0 then
                local dist = (root.Position - eRoot.Position).Magnitude
                if dist < nearDist then
                    nearest = p
                    nearDist = dist
                end
            end
        end
    end
    return nearest, nearDist
end

local function applyBackgroundVisuals()
    State.bgOpacity = clamp(TextBox_410 and TextBox_410.Text or State.bgOpacity, 0, 1)
    local variant = backgroundVariants[State.bgVariant] or backgroundVariants[1]
    if ImageLabel_6 then
        ImageLabel_6.ImageColor3 = variant.color
        ImageLabel_6.ImageTransparency = State.bgEnabled and (1 - State.bgOpacity) or 1
    end
    if TextLabel_392 then
        TextLabel_392.Text = variant.label
    end
    if TextBox_410 then
        TextBox_410.Text = string.format("%.2f", State.bgOpacity)
    end
    setSwitch(Frame_381, Frame_383, State.bgEnabled)
end

local function applyLogoVisuals()
    local variant = logoVariants[State.logoVariant] or logoVariants[1]
    if ImageLabel_19 then
        ImageLabel_19.ImageColor3 = variant.color
    end
    if TextLabel_402 then
        TextLabel_402.Text = variant.label
    end
end

local function cycleBackground(direction)
    State.bgVariant = ((State.bgVariant - 1 + direction) % #backgroundVariants) + 1
    applyBackgroundVisuals()
end

local function cycleLogo(direction)
    State.logoVariant = ((State.logoVariant - 1 + direction) % #logoVariants) + 1
    applyLogoVisuals()
end

local function updateDropButtons()
    if TextButton_449 then
        TextButton_449.BackgroundColor3 = State.dropType == "tp" and Color3.fromRGB(185, 120, 255) or Color3.fromRGB(10, 7, 18)
        TextButton_449.TextColor3 = State.dropType == "tp" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(245, 240, 255)
    end
    if TextButton_451 then
        TextButton_451.BackgroundColor3 = State.dropType == "still" and Color3.fromRGB(185, 120, 255) or Color3.fromRGB(10, 7, 18)
        TextButton_451.TextColor3 = State.dropType == "still" and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(245, 240, 255)
    end
end

local function runDropMode()
    disconnect("dropMode")
    if not State.tpDrop then
        return
    end

    Connections.dropMode = RunService.Heartbeat:Connect(function()
        local root = getRoot()
        local hum = getHum()
        if not root or not hum then
            return
        end

        if State.dropType == "still" then
            hum:Move(Vector3.zero)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end

        local ray = Workspace:Raycast(root.Position, Vector3.new(0, -60, 0))
        if ray then
            local look = root.CFrame.LookVector
            local target = ray.Position + Vector3.new(0, 3, 0)
            root.CFrame = CFrame.new(target, target + look)
            root.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

local function updateSpeed()
    local hum = getHum()
    if not hum then
        return
    end

    if State.speedEnabled then
        local speed = State.normalSpeed
        if State.laggerMode and State.carryMode then
            speed = State.laggerCarrySpeed
        elseif State.laggerMode then
            speed = State.laggerSpeed
        elseif State.carryMode then
            speed = State.carrySpeed
        end
        hum.WalkSpeed = speed + (math.random() * 0.001)
        hum.JumpHeight = defaultJumpHeight + (math.random() * 0.001)
    end
end

local function toggleSpeed()
    State.speedEnabled = not State.speedEnabled
    if State.speedEnabled then
        disconnect("speed")
        Connections.speed = RunService.Heartbeat:Connect(updateSpeed)
        updateSpeed()
    else
        disconnect("speed")
        local hum = getHum()
        if hum then
            hum.WalkSpeed = defaultWalkSpeed
            hum.JumpHeight = defaultJumpHeight
        end
    end
end

local function toggleBatAimbot()
    State.batAimbot = not State.batAimbot
    if State.batAimbot then
        disconnect("aimbot")
        Connections.aimbot = RunService.Heartbeat:Connect(function()
            if not State.batAimbot then
                return
            end
            local root = getRoot()
            if not root then
                return
            end

            local target = getNearestPlayer(State.grabRadius)
            if target and target.Character then
                local eRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    local speed = State.laggerMode and State.batAimbotSpeedLagger or State.batAimbotSpeed
                    local dir = (eRoot.Position - root.Position).Unit
                    local targetPos = eRoot.Position - dir * State.batHitDist
                    local alpha = math.min(1, speed / 60 * 0.1)
                    local newPos = root.Position:Lerp(targetPos, alpha)
                    root.CFrame = CFrame.new(newPos, eRoot.Position)
                end
            end
        end)
    else
        disconnect("aimbot")
    end
end

local function toggleTpBat()
    State.tpBat = not State.tpBat
    if State.tpBat then
        disconnect("tpbat")
        Connections.tpbat = RunService.Heartbeat:Connect(function()
            if not State.tpBat then
                return
            end
            local root = getRoot()
            if not root then
                return
            end

            local target = getNearestPlayer(State.grabRadius)
            if target and target.Character then
                local eRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if eRoot then
                    root.CFrame = eRoot.CFrame * CFrame.new(0, 0, -State.batHitDist)
                end
            end
        end)
    else
        disconnect("tpbat")
    end
end

local function toggleAutoSwing()
    State.autoSwing = not State.autoSwing
    swingToken = swingToken + 1
    local myToken = swingToken
    if not State.autoSwing then
        return
    end

    task.spawn(function()
        while State.autoSwing and myToken == swingToken do
            pcall(function()
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
            task.wait(0.15)
        end
    end)
end

local function clearESP()
    for key, obj in pairs(espObjects) do
        pcall(function()
            obj:Destroy()
        end)
        espObjects[key] = nil
    end
end

local function createESP(targetPlayer)
    if not targetPlayer.Character then
        return
    end
    if espObjects[targetPlayer.Name] then
        pcall(function()
            espObjects[targetPlayer.Name]:Destroy()
        end)
        espObjects[targetPlayer.Name] = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.Adornee = targetPlayer.Character
    highlight.Parent = targetPlayer.Character
    espObjects[targetPlayer.Name] = highlight
end

local function toggleESP()
    State.espEnabled = not State.espEnabled
    if State.espEnabled then
        clearESP()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                createESP(p)
            end
        end

        disconnect("espAdded")
        disconnect("espRespawn")
        disconnect("espRemoving")

        Connections.espAdded = Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                task.wait(1)
                if State.espEnabled then
                    createESP(p)
                end
            end)
        end)

        Connections.espRespawn = player.CharacterAdded:Connect(function()
            task.wait(1)
            if State.espEnabled then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player then
                        createESP(p)
                    end
                end
            end
        end)

        Connections.espRemoving = Players.PlayerRemoving:Connect(function(p)
            if espObjects[p.Name] then
                pcall(function()
                    espObjects[p.Name]:Destroy()
                end)
                espObjects[p.Name] = nil
            end
        end)
    else
        clearESP()
        disconnect("espAdded")
        disconnect("espRespawn")
        disconnect("espRemoving")
    end
end

local function toggleNoclip()
    State.noclip = not State.noclip
    if State.noclip then
        disconnect("noclip")
        Connections.noclip = RunService.Stepped:Connect(function()
            local char = getChar()
            if not char then
                return
            end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        disconnect("noclip")
    end
end

local function toggleInfJump()
    State.infiniteJump = not State.infiniteJump
end

UIS.JumpRequest:Connect(function()
    if State.infiniteJump then
        local hum = getHum()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

local function toggleAntiRagdoll()
    State.antiRagdoll = not State.antiRagdoll
    if State.antiRagdoll then
        disconnect("antirag")
        Connections.antirag = RunService.Heartbeat:Connect(function()
            local hum = getHum()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    else
        disconnect("antirag")
    end
end

local function toggleAutoLeft()
    State.autoLeft = not State.autoLeft
    if State.autoLeft then
        disconnect("autoLeft")
        Connections.autoLeft = RunService.Heartbeat:Connect(function()
            local hum = getHum()
            if hum then
                hum:Move(Vector3.new(-1, 0, 0))
            end
        end)
    else
        disconnect("autoLeft")
    end
end

local function toggleAutoRight()
    State.autoRight = not State.autoRight
    if State.autoRight then
        disconnect("autoRight")
        Connections.autoRight = RunService.Heartbeat:Connect(function()
            local hum = getHum()
            if hum then
                hum:Move(Vector3.new(1, 0, 0))
            end
        end)
    else
        disconnect("autoRight")
    end
end

local function instaReset()
    local hum = getHum()
    if hum then
        hum.Health = 0
    end
end

local function toggleTpDrop()
    State.tpDrop = not State.tpDrop
    runDropMode()
end

local function toggleAutoSteal()
    State.autoSteal = not State.autoSteal
    if State.autoSteal then
        disconnect("steal")
        Connections.steal = RunService.Heartbeat:Connect(function()
            if not State.autoSteal then
                return
            end
            local root = getRoot()
            if not root then
                return
            end

            for _, obj in ipairs(Workspace:GetChildren()) do
                pcall(function()
                    if obj:IsA("Model") or obj:IsA("Tool") then
                        local part = obj:FindFirstChildOfClass("BasePart") or obj.PrimaryPart
                        if part then
                            local dist = (root.Position - part.Position).Magnitude
                            if dist < State.grabRadius then
                                root.CFrame = part.CFrame
                            end
                        end
                    end
                end)
            end
        end)
    else
        disconnect("steal")
    end
end

local function toggleCustomFOV()
    State.customFOVEnabled = not State.customFOVEnabled
    local cam = getCamera()
    if State.customFOVEnabled then
        disconnect("fov")
        Connections.fov = RunService.Heartbeat:Connect(function()
            local currentCamera = getCamera()
            if currentCamera then
                currentCamera.FieldOfView = State.customFOV
            end
        end)
    else
        disconnect("fov")
        if cam then
            cam.FieldOfView = 70
        end
    end
end

local tabs = {
    {btn = TextButton_30, page = Page_Speed_56, name = "Speed"},
    {btn = TextButton_35, page = Page_Combat_113, name = "Combat"},
    {btn = TextButton_40, page = Page_Steal_197, name = "Steal"},
    {btn = TextButton_45, page = Page_Visual_244, name = "Visual"},
    {btn = TextButton_50, page = Page_Interface_485, name = "Interface"},
}

local function switchTab(target)
    for _, tab in ipairs(tabs) do
        local active = tab.name == target
        pcall(function()
            tab.page.Visible = active
        end)
        pcall(function()
            TweenService:Create(tab.btn, tweenInfo, {
                TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(120, 100, 140)
            }):Play()
        end)
    end
end

for _, tab in ipairs(tabs) do
    pcall(function()
        tab.btn.MouseButton1Click:Connect(function()
            switchTab(tab.name)
        end)
    end)
end
switchTab("Speed")

UIS.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end
    if input.KeyCode == Enum.KeyCode.Q then
        toggleSpeed()
    elseif input.KeyCode == Enum.KeyCode.R then
        State.laggerMode = not State.laggerMode
    elseif input.KeyCode == Enum.KeyCode.E then
        toggleBatAimbot()
    elseif input.KeyCode == Enum.KeyCode.T then
        instaReset()
    elseif input.KeyCode == Enum.KeyCode.F then
        local root = getRoot()
        if root then
            local ray = Workspace:Raycast(root.Position, Vector3.new(0, -500, 0))
            if ray then
                root.CFrame = CFrame.new(ray.Position + Vector3.new(0, 3, 0))
            end
        end
    elseif input.KeyCode == Enum.KeyCode.Z then
        toggleAutoLeft()
    elseif input.KeyCode == Enum.KeyCode.C then
        toggleAutoRight()
    elseif input.KeyCode == Enum.KeyCode.X then
        toggleTpDrop()
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        setMainUiVisible(not (Frame_2 and Frame_2.Visible))
    end
end)

Connections.fps = RunService.Heartbeat:Connect(function(dt)
    if dt and dt > 0 then
        lastFps = math.max(1, math.floor((1 / dt) + 0.5))
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        local hum = getHum()
        local speed = 0
        if hum then
            speed = math.floor(hum.MoveDirection.Magnitude * hum.WalkSpeed * 10) / 10
        end

        local ping = math.floor((player:GetNetworkPing() or 0) * 1000)

        if TextLabel_23 then
            TextLabel_23.Text = string.format("Ping: %dms | FPS: %d", ping, lastFps)
        end
        if TextLabel_566 then
            TextLabel_566.Text = string.format("FPS:%d | PING:%dms", lastFps, ping)
        end
        if TextLabel_567 then
            local targetSpeed = math.max(State.normalSpeed, 1)
            local percent = math.floor((speed / targetSpeed) * 100 + 0.5)
            TextLabel_567.Text = string.format("%d%%", percent)
            if Frame_573 then
                Frame_573.Size = UDim2.new(clamp(speed / targetSpeed, 0, 1), 0, 1, 0)
            end
        end
        if TextLabel_569 then
            TextLabel_569.Text = tostring(math.floor(State.grabRadius * 10) / 10)
        end
    end
end)

local function bindTextBox(box, stateKey, minValue, maxValue)
    if not box or not stateKey then
        return
    end
    pcall(function()
        box.FocusLost:Connect(function()
            local previous = State[stateKey]
            local numeric = tonumber(box.Text)
            if numeric then
                if minValue and maxValue then
                    numeric = clamp(numeric, minValue, maxValue)
                end
                State[stateKey] = numeric
            end
            box.Text = tostring(State[stateKey] or previous)
            if stateKey == "customFOV" and State.customFOVEnabled then
                local cam = getCamera()
                if cam then
                    cam.FieldOfView = State.customFOV
                end
            elseif stateKey == "bgOpacity" then
                applyBackgroundVisuals()
            end
        end)
    end)
end

bindTextBox(TextBox_68, "normalSpeed", 1, 250)
bindTextBox(TextBox_75, "carrySpeed", 1, 250)
bindTextBox(TextBox_82, "laggerSpeed", 1, 250)
bindTextBox(TextBox_89, "laggerCarrySpeed", 1, 250)
bindTextBox(TextBox_153, "batAimbotSpeed", 1, 250)
bindTextBox(TextBox_160, "batAimbotSpeedLagger", 1, 250)
bindTextBox(TextBox_167, "batHitDist", 1, 50)
bindTextBox(TextBox_209, "grabRadius", 1, 500)
bindTextBox(TextBox_368, "customFOV", 30, 120)
bindTextBox(TextBox_410, "bgOpacity", 0, 1)

local dragging, dragStart, startPos

pcall(function()
    Frame_11.InputBegan:Connect(function(input)
        if State.uiLocked then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame_2.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
end)

UIS.InputChanged:Connect(function(input)
    if State.uiLocked then
        return
    end
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame_2.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local minimized = false
pcall(function()
    TextButton_24.MouseButton1Click:Connect(function()
        minimized = not minimized
        TweenService:Create(Frame_2, TweenInfo.new(0.3), {
            Size = minimized and UDim2.new(0, 360, 0, 50) or UDim2.new(0, 360, 0, 410)
        }):Play()
        TextButton_24.Text = minimized and "+" or "-"
    end)
end)

local function encodePosition(pos)
    return {
        xScale = pos.X.Scale,
        xOffset = pos.X.Offset,
        yScale = pos.Y.Scale,
        yOffset = pos.Y.Offset,
    }
end

local function decodePosition(data)
    if type(data) ~= "table" then
        return nil
    end
    return UDim2.new(
        tonumber(data.xScale) or 0,
        tonumber(data.xOffset) or 0,
        tonumber(data.yScale) or 0,
        tonumber(data.yOffset) or 0
    )
end

local function snapshotSettings()
    local mobilePositions = {}
    for _, btn in ipairs(mobileButtons) do
        if btn then
            mobilePositions[btn.Name] = encodePosition(btn.Position)
        end
    end
    return {
        normalSpeed = State.normalSpeed,
        carrySpeed = State.carrySpeed,
        laggerSpeed = State.laggerSpeed,
        laggerCarrySpeed = State.laggerCarrySpeed,
        batAimbotSpeed = State.batAimbotSpeed,
        batAimbotSpeedLagger = State.batAimbotSpeedLagger,
        batHitDist = State.batHitDist,
        grabRadius = State.grabRadius,
        customFOV = State.customFOV,
        bgOpacity = State.bgOpacity,
        bgVariant = State.bgVariant,
        logoVariant = State.logoVariant,
        bgEnabled = State.bgEnabled,
        uiLocked = State.uiLocked,
        dropType = State.dropType,
        framePosition = encodePosition(Frame_2.Position),
        mobilePositions = mobilePositions,
    }
end

local function applySavedSettings(data)
    if type(data) ~= "table" then
        return
    end

    for key, value in pairs(data) do
        if key == "bgVariant" then
            State.bgVariant = clamp(value, 1, #backgroundVariants)
        elseif key == "logoVariant" then
            State.logoVariant = clamp(value, 1, #logoVariants)
        elseif key == "dropType" and (value == "tp" or value == "still") then
            State.dropType = value
        elseif key == "bgEnabled" or key == "uiLocked" then
            State[key] = value and true or false
        elseif State[key] ~= nil and type(State[key]) ~= "boolean" then
            State[key] = tonumber(value) or State[key]
        end
    end

    if data.framePosition then
        local pos = decodePosition(data.framePosition)
        if pos then
            Frame_2.Position = pos
        end
    end

    if type(data.mobilePositions) == "table" then
        for _, btn in ipairs(mobileButtons) do
            local pos = decodePosition(data.mobilePositions[btn.Name])
            if pos then
                btn.Position = pos
            end
        end
    end

    if TextBox_68 then TextBox_68.Text = tostring(State.normalSpeed) end
    if TextBox_75 then TextBox_75.Text = tostring(State.carrySpeed) end
    if TextBox_82 then TextBox_82.Text = tostring(State.laggerSpeed) end
    if TextBox_89 then TextBox_89.Text = tostring(State.laggerCarrySpeed) end
    if TextBox_153 then TextBox_153.Text = tostring(State.batAimbotSpeed) end
    if TextBox_160 then TextBox_160.Text = tostring(State.batAimbotSpeedLagger) end
    if TextBox_167 then TextBox_167.Text = tostring(State.batHitDist) end
    if TextBox_209 then TextBox_209.Text = tostring(State.grabRadius) end
    if TextBox_368 then TextBox_368.Text = tostring(State.customFOV) end
    if TextBox_410 then TextBox_410.Text = string.format("%.2f", State.bgOpacity) end

    applyBackgroundVisuals()
    applyLogoVisuals()
    setSwitch(Frame_503, Frame_505, State.uiLocked)
    updateDropButtons()
end

local function saveSettings()
    local payload = snapshotSettings()
    _G[storageKey] = payload
    pcall(function()
        BirdHub_1:SetAttribute("SavedSettings", HttpService:JSONEncode(payload))
    end)
    if TextButton_557 then
        TextButton_557.Text = "SETTINGS SAVED"
        task.delay(1.2, function()
            if TextButton_557 then
                TextButton_557.Text = "SAVE SETTINGS"
            end
        end)
    end
end

local function loadSettings()
    local payload = _G[storageKey]
    if type(payload) ~= "table" then
        local encoded = nil
        pcall(function()
            encoded = BirdHub_1:GetAttribute("SavedSettings")
        end)
        if type(encoded) == "string" and encoded ~= "" then
            local ok, decoded = pcall(function()
                return HttpService:JSONDecode(encoded)
            end)
            if ok then
                payload = decoded
            end
        end
    end
    applySavedSettings(payload)
end

local function toggleUiLock()
    State.uiLocked = not State.uiLocked
    setSwitch(Frame_503, Frame_505, State.uiLocked)
end

local function wireToggle(btn, toggleFn, stateKey)
    if not btn then
        return
    end
    pcall(function()
        btn.MouseButton1Click:Connect(function()
            toggleFn()
            pcall(function()
                local indicator = (btn.Parent and btn.Parent:FindFirstChild("Indicator"))
                    or (btn.Parent and btn.Parent:FindFirstChildOfClass("Frame"))
                if indicator and indicator:IsA("Frame") and indicator.AbsoluteSize.X < 20 then
                    local enabled = stateKey and State[stateKey] or false
                    TweenService:Create(indicator, tweenInfo, {
                        BackgroundColor3 = enabled
                            and Color3.fromRGB(100, 255, 100)
                            or Color3.fromRGB(80, 60, 100)
                    }):Play()
                end
            end)
        end)
    end)
end

wireToggle(TextButton_97, toggleSpeed, "speedEnabled")
wireToggle(TextButton_137, toggleTpBat, "tpBat")
wireToggle(TextButton_148, toggleBatAimbot, "batAimbot")
wireToggle(TextButton_178, toggleAutoSwing, "autoSwing")
wireToggle(TextButton_187, function()
    State.batCounter = not State.batCounter
end, "batCounter")
wireToggle(TextButton_196, function() end, nil)
wireToggle(TextButton_220, toggleAutoSteal, "autoSteal")
pcall(function() TextButton_261.MouseButton1Click:Connect(instaReset) end)
wireToggle(TextButton_270, toggleInfJump, "infiniteJump")
wireToggle(TextButton_279, toggleInfJump, "infiniteJump")
wireToggle(TextButton_288, toggleAntiRagdoll, "antiRagdoll")
wireToggle(TextButton_306, toggleNoclip, "noclip")
wireToggle(TextButton_318, toggleESP, "espEnabled")
wireToggle(TextButton_363, toggleCustomFOV, "customFOVEnabled")
wireToggle(TextButton_426, toggleAutoLeft, "autoLeft")
wireToggle(TextButton_437, toggleAutoRight, "autoRight")
wireToggle(TextButton_459, function()
    local root = getRoot()
    if root then
        local ray = Workspace:Raycast(root.Position, Vector3.new(0, -500, 0))
        if ray then
            root.CFrame = CFrame.new(ray.Position + Vector3.new(0, 3, 0))
        end
    end
end, nil)

for _, tab in ipairs(tabs) do
    pcall(function()
        tab.btn.AutoButtonColor = true
    end)
end

pcall(function()
    for _, desc in ipairs(BirdHub_1:GetDescendants()) do
        if desc:IsA("TextButton") then
            desc.AutoButtonColor = true
        end
    end
end)

local function wireMB(btn, fn)
    if not btn then
        return
    end
    pcall(function()
        btn.MouseButton1Click:Connect(function()
            fn()
            pcall(function()
                local orig = btn.BackgroundColor3
                btn.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
                task.delay(0.3, function()
                    pcall(function()
                        btn.BackgroundColor3 = orig
                    end)
                end)
            end)
        end)
    end)
end

wireMB(MB_drop_576, toggleTpDrop)
wireMB(MB_autoLeft_579, toggleAutoLeft)
wireMB(MB_bat_582, toggleBatAimbot)
wireMB(MB_autoRight_585, toggleAutoRight)
wireMB(MB_tp_588, function()
    local root = getRoot()
    if root then
        local ray = Workspace:Raycast(root.Position, Vector3.new(0, -500, 0))
        if ray then
            root.CFrame = CFrame.new(ray.Position + Vector3.new(0, 3, 0))
        end
    end
end)
wireMB(MB_carry_591, function()
    State.carryMode = not State.carryMode
end)
wireMB(MB_instaReset_594, instaReset)
wireMB(MB_lagger_597, function()
    State.laggerMode = not State.laggerMode
end)
wireMB(MB_tpBat_600, toggleTpBat)

pcall(function()
    TextButton_385.MouseButton1Click:Connect(function()
        State.bgEnabled = not State.bgEnabled
        applyBackgroundVisuals()
    end)
end)
pcall(function() TextButton_390.MouseButton1Click:Connect(function() cycleBackground(-1) end) end)
pcall(function() TextButton_394.MouseButton1Click:Connect(function() cycleBackground(1) end) end)
pcall(function() TextButton_400.MouseButton1Click:Connect(function() cycleLogo(-1) end) end)
pcall(function() TextButton_404.MouseButton1Click:Connect(function() cycleLogo(1) end) end)
pcall(function() TextButton_449.MouseButton1Click:Connect(function() State.dropType = "tp"; updateDropButtons(); runDropMode() end) end)
pcall(function() TextButton_451.MouseButton1Click:Connect(function() State.dropType = "still"; updateDropButtons(); runDropMode() end) end)
pcall(function() TextButton_497.MouseButton1Click:Connect(function() setMainUiVisible(false) end) end)
pcall(function() TextButton_507.MouseButton1Click:Connect(toggleUiLock) end)
pcall(function() TextButton_522.MouseButton1Click:Connect(function()
    State.customFOV = math.max(30, State.customFOV - 5)
    if TextBox_368 then
        TextBox_368.Text = tostring(State.customFOV)
    end
    local cam = getCamera()
    if cam and State.customFOVEnabled then
        cam.FieldOfView = State.customFOV
    end
end) end)
pcall(function() TextButton_524.MouseButton1Click:Connect(function()
    State.customFOV = math.min(120, State.customFOV + 5)
    if TextBox_368 then
        TextBox_368.Text = tostring(State.customFOV)
    end
    local cam = getCamera()
    if cam and State.customFOVEnabled then
        cam.FieldOfView = State.customFOV
    end
end) end)
pcall(function() TextButton_551.MouseButton1Click:Connect(function()
    for _, btn in ipairs(mobileButtons) do
        local pos = defaultMobilePositions[btn.Name]
        if pos then
            btn.Position = pos
        end
    end
end) end)
pcall(function() TextButton_557.MouseButton1Click:Connect(saveSettings) end)
pcall(function() TextButton_560.MouseButton1Click:Connect(function() setMainUiVisible(true) end) end)
pcall(function()
    TextButton_125.MouseButton1Click:Connect(function()
        switchTab("Combat")
        if Page_Combat_113 and Page_Combat_113:IsA("ScrollingFrame") then
            Page_Combat_113.CanvasPosition = Vector2.new(0, 0)
        end
    end)
end)

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.speedEnabled then
        updateSpeed()
    end
    if State.espEnabled then
        task.wait(1)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                createESP(p)
            end
        end
    end
    if State.customFOVEnabled then
        local cam = getCamera()
        if cam then
            cam.FieldOfView = State.customFOV
        end
    end
    if State.tpDrop then
        runDropMode()
    end
end)

loadSettings()
applyBackgroundVisuals()
applyLogoVisuals()
updateDropButtons()
setSwitch(Frame_503, Frame_505, State.uiLocked)
setMainUiVisible(true)

print("[MIRO HUB] loaded")
print("LEKAD BY FRNK33.")
print("discord.gg/kastorhub")