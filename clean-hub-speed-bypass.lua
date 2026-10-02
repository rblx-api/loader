local CleanSpeedBypass = Instance.new("ScreenGui")
CleanSpeedBypass.Name = "Clean Speed Bypass"
CleanSpeedBypass.ResetOnSpawn = false
CleanSpeedBypass.IgnoreGuiInset = true
CleanSpeedBypass.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets

local Root = Instance.new("Frame")
Root.Name = "Root"
Root.Active = true
Root.BackgroundTransparency = 1
Root.BorderSizePixel = 0
Root.Position = UDim2.new(0.5, -120, 0.5, -115)
Root.Size = UDim2.new(0, 240, 0, 260)
Root.Parent = CleanSpeedBypass

local RootScale = Instance.new("UIScale")
RootScale.Name = "RootScale"
RootScale.Parent = Root

local Frame = Instance.new("Frame")
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Position = UDim2.new(0, 60, 0, 0)
Frame.Size = UDim2.new(0, 180, 0, 260)
Frame.Parent = Root

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.ZIndex = 0
BackgroundImage.Image = "rbxassetid://101894744159774"
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = Frame

local UICorner_2 = Instance.new("UICorner")
UICorner_2.CornerRadius = UDim.new(0, 10)
UICorner_2.Parent = BackgroundImage

local BackgroundOverlay = Instance.new("Frame")
BackgroundOverlay.Name = "BackgroundOverlay"
BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundOverlay.BackgroundTransparency = 0.55000001192092896
BackgroundOverlay.BorderSizePixel = 0
BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
BackgroundOverlay.Parent = Frame

local UICorner_3 = Instance.new("UICorner")
UICorner_3.CornerRadius = UDim.new(0, 10)
UICorner_3.Parent = BackgroundOverlay

local TextLabel = Instance.new("TextLabel")
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 5, 0, 4)
TextLabel.Size = UDim2.new(1, -35, 0, 16)
TextLabel.ZIndex = 20
TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel.RichText = true
TextLabel.Text = "<font color=\"#808080\"><b>|</b></font>  Clean Speed Bypass"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 13
TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame

local TextLabel_2 = Instance.new("TextLabel")
TextLabel_2.BackgroundTransparency = 1
TextLabel_2.Position = UDim2.new(0, 5, 0, 19)
TextLabel_2.Size = UDim2.new(1, -35, 0, 14)
TextLabel_2.ZIndex = 20
TextLabel_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
TextLabel_2.Text = "https://discord.gg/TBBAUZu8cW"
TextLabel_2.TextColor3 = Color3.fromRGB(180, 180, 180)
TextLabel_2.TextSize = 10
TextLabel_2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_2.Parent = Frame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.BackgroundTransparency = 0.34999999403953552
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -25, 0, 8)
MinimizeBtn.Size = UDim2.new(0, 18, 0, 18)
MinimizeBtn.ZIndex = 30
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = Frame

local UICorner_4 = Instance.new("UICorner")
UICorner_4.CornerRadius = UDim.new(1, 0)
UICorner_4.Parent = MinimizeBtn

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Position = UDim2.new(0, 0, 0, 42)
Content.Size = UDim2.new(1, 0, 1, -42)
Content.ZIndex = 2
Content.Parent = Frame

local TextButton = Instance.new("TextButton")
TextButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TextButton.BackgroundTransparency = 0.34999999403953552
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.05000000074505806, 0, 0, 22)
TextButton.Size = UDim2.new(0.89999997615814209, 0, 0, 32)
TextButton.ZIndex = 3
TextButton.AutoButtonColor = false
TextButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextButton.Text = "Enable"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextSize = 12
TextButton.Parent = Content

local UICorner_5 = Instance.new("UICorner")
UICorner_5.Parent = TextButton

local Frame_2 = Instance.new("Frame")
Frame_2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame_2.BackgroundTransparency = 0.40000000596046448
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.05000000074505806, 0, 0, 58)
Frame_2.Size = UDim2.new(0.89999997615814209, 0, 0, 30)
Frame_2.ZIndex = 3
Frame_2.Parent = Content

local UICorner_6 = Instance.new("UICorner")
UICorner_6.Parent = Frame_2

local TextLabel_3 = Instance.new("TextLabel")
TextLabel_3.BackgroundTransparency = 1
TextLabel_3.Size = UDim2.new(0.60000002384185791, 0, 1, 0)
TextLabel_3.ZIndex = 4
TextLabel_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel_3.Text = "Auto Brainrot"
TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_3.TextSize = 10
TextLabel_3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_3.Parent = Frame_2

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.Parent = TextLabel_3

local TextButton_2 = Instance.new("TextButton")
TextButton_2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.BackgroundTransparency = 0.34999999403953552
TextButton_2.BorderSizePixel = 0
TextButton_2.Position = UDim2.new(0.60000002384185791, 0, 0.15000000596046448, 0)
TextButton_2.Size = UDim2.new(0.34999999403953552, 0, 0.69999998807907104, 0)
TextButton_2.ZIndex = 4
TextButton_2.AutoButtonColor = false
TextButton_2.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextButton_2.Text = "OFF"
TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton_2.TextSize = 11
TextButton_2.Parent = Frame_2

local UICorner_7 = Instance.new("UICorner")
UICorner_7.CornerRadius = UDim.new(0, 6)
UICorner_7.Parent = TextButton_2

local Frame_3 = Instance.new("Frame")
Frame_3.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame_3.BackgroundTransparency = 0.40000000596046448
Frame_3.BorderSizePixel = 0
Frame_3.Position = UDim2.new(0.05000000074505806, 0, 0, 94)
Frame_3.Size = UDim2.new(0.89999997615814209, 0, 0, 30)
Frame_3.ZIndex = 3
Frame_3.Parent = Content

local UICorner_8 = Instance.new("UICorner")
UICorner_8.Parent = Frame_3

local TextLabel_4 = Instance.new("TextLabel")
TextLabel_4.BackgroundTransparency = 1
TextLabel_4.Size = UDim2.new(0.60000002384185791, 0, 1, 0)
TextLabel_4.ZIndex = 4
TextLabel_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel_4.Text = "Mode"
TextLabel_4.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_4.TextSize = 10
TextLabel_4.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_4.Parent = Frame_3

local UIPadding_2 = Instance.new("UIPadding")
UIPadding_2.PaddingLeft = UDim.new(0, 10)
UIPadding_2.Parent = TextLabel_4

local TextButton_3 = Instance.new("TextButton")
TextButton_3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton_3.BackgroundTransparency = 0.34999999403953552
TextButton_3.BorderSizePixel = 0
TextButton_3.Position = UDim2.new(0.60000002384185791, 0, 0.15000000596046448, 0)
TextButton_3.Size = UDim2.new(0.18000000715255737, 0, 0.69999998807907104, 0)
TextButton_3.ZIndex = 4
TextButton_3.AutoButtonColor = false
TextButton_3.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextButton_3.Text = "Mobile"
TextButton_3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton_3.TextSize = 9
TextButton_3.Parent = Frame_3

local UICorner_9 = Instance.new("UICorner")
UICorner_9.CornerRadius = UDim.new(0, 6)
UICorner_9.Parent = TextButton_3

local TextButton_4 = Instance.new("TextButton")
TextButton_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton_4.BorderSizePixel = 0
TextButton_4.Position = UDim2.new(0.79000002145767212, 0, 0.15000000596046448, 0)
TextButton_4.Size = UDim2.new(0.18000000715255737, 0, 0.69999998807907104, 0)
TextButton_4.ZIndex = 4
TextButton_4.AutoButtonColor = false
TextButton_4.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextButton_4.Text = "PC"
TextButton_4.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton_4.TextSize = 9
TextButton_4.Parent = Frame_3

local UICorner_10 = Instance.new("UICorner")
UICorner_10.CornerRadius = UDim.new(0, 6)
UICorner_10.Parent = TextButton_4

local Frame_4 = Instance.new("Frame")
Frame_4.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame_4.BackgroundTransparency = 0.40000000596046448
Frame_4.BorderSizePixel = 0
Frame_4.Position = UDim2.new(0.05000000074505806, 0, 0, 130)
Frame_4.Size = UDim2.new(0.89999997615814209, 0, 0, 30)
Frame_4.ZIndex = 3
Frame_4.Parent = Content

local UICorner_11 = Instance.new("UICorner")
UICorner_11.Parent = Frame_4

local TextLabel_5 = Instance.new("TextLabel")
TextLabel_5.BackgroundTransparency = 1
TextLabel_5.Size = UDim2.new(0.60000002384185791, 0, 1, 0)
TextLabel_5.ZIndex = 4
TextLabel_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel_5.Text = "Power"
TextLabel_5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_5.TextSize = 10
TextLabel_5.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_5.Parent = Frame_4

local UIPadding_3 = Instance.new("UIPadding")
UIPadding_3.PaddingLeft = UDim.new(0, 10)
UIPadding_3.Parent = TextLabel_5

local TextBox = Instance.new("TextBox")
TextBox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextBox.BackgroundTransparency = 0.34999999403953552
TextBox.BorderSizePixel = 0
TextBox.Position = UDim2.new(0.55000001192092896, 0, 0.15000000596046448, 0)
TextBox.Size = UDim2.new(0.40000000596046448, 0, 0.69999998807907104, 0)
TextBox.ZIndex = 4
TextBox.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextBox.Text = "97000"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 12
TextBox.ClearTextOnFocus = false
TextBox.Parent = Frame_4

local UICorner_12 = Instance.new("UICorner")
UICorner_12.CornerRadius = UDim.new(0, 6)
UICorner_12.Parent = TextBox

local Frame_5 = Instance.new("Frame")
Frame_5.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame_5.BackgroundTransparency = 0.40000000596046448
Frame_5.BorderSizePixel = 0
Frame_5.Position = UDim2.new(0.05000000074505806, 0, 0, 166)
Frame_5.Size = UDim2.new(0.89999997615814209, 0, 0, 30)
Frame_5.ZIndex = 3
Frame_5.Parent = Content

local UICorner_13 = Instance.new("UICorner")
UICorner_13.Parent = Frame_5

local TextLabel_6 = Instance.new("TextLabel")
TextLabel_6.BackgroundTransparency = 1
TextLabel_6.Size = UDim2.new(0.60000002384185791, 0, 1, 0)
TextLabel_6.ZIndex = 4
TextLabel_6.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel_6.Text = "Keybind"
TextLabel_6.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_6.TextSize = 10
TextLabel_6.TextXAlignment = Enum.TextXAlignment.Left
TextLabel_6.Parent = Frame_5

local UIPadding_4 = Instance.new("UIPadding")
UIPadding_4.PaddingLeft = UDim.new(0, 10)
UIPadding_4.Parent = TextLabel_6

local TextButton_5 = Instance.new("TextButton")
TextButton_5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton_5.BackgroundTransparency = 0.34999999403953552
TextButton_5.BorderSizePixel = 0
TextButton_5.Position = UDim2.new(0.55000001192092896, 0, 0.15000000596046448, 0)
TextButton_5.Size = UDim2.new(0.40000000596046448, 0, 0.69999998807907104, 0)
TextButton_5.ZIndex = 4
TextButton_5.AutoButtonColor = false
TextButton_5.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextButton_5.Text = "V"
TextButton_5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton_5.TextSize = 12
TextButton_5.Parent = Frame_5

local UICorner_14 = Instance.new("UICorner")
UICorner_14.CornerRadius = UDim.new(0, 6)
UICorner_14.Parent = TextButton_5

local LockCapsule = Instance.new("TextButton")
LockCapsule.Name = "LockCapsule"
LockCapsule.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
LockCapsule.BackgroundTransparency = 0.5
LockCapsule.BorderSizePixel = 0
LockCapsule.Position = UDim2.new(1, -96, 0, 4)
LockCapsule.Size = UDim2.new(0, 44, 0, 16)
LockCapsule.ZIndex = 5
LockCapsule.AutoButtonColor = false
LockCapsule.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
LockCapsule.Text = "Lock"
LockCapsule.TextColor3 = Color3.fromRGB(255, 255, 255)
LockCapsule.TextSize = 10
LockCapsule.Parent = Content

local UICorner_15 = Instance.new("UICorner")
UICorner_15.CornerRadius = UDim.new(1, 0)
UICorner_15.Parent = LockCapsule

local SliderToggleBtn = Instance.new("TextButton")
SliderToggleBtn.Name = "SliderToggleBtn"
SliderToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
SliderToggleBtn.BackgroundTransparency = 0.5
SliderToggleBtn.BorderSizePixel = 0
SliderToggleBtn.Position = UDim2.new(1, -48, 0, 4)
SliderToggleBtn.Size = UDim2.new(0, 44, 0, 16)
SliderToggleBtn.ZIndex = 5
SliderToggleBtn.AutoButtonColor = false
SliderToggleBtn.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
SliderToggleBtn.Text = "Hide"
SliderToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderToggleBtn.TextSize = 10
SliderToggleBtn.Parent = Content

local UICorner_16 = Instance.new("UICorner")
UICorner_16.CornerRadius = UDim.new(1, 0)
UICorner_16.Parent = SliderToggleBtn

local SliderGroup = Instance.new("Frame")
SliderGroup.Name = "SliderGroup"
SliderGroup.BackgroundTransparency = 1
SliderGroup.BorderSizePixel = 0
SliderGroup.Position = UDim2.new(0, 0, 0, 25)
SliderGroup.Size = UDim2.new(0, 50, 0, 180)
SliderGroup.Parent = Root

local SizeSlider = Instance.new("Frame")
SizeSlider.Name = "SizeSlider"
SizeSlider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SizeSlider.BackgroundTransparency = 0.15000000596046448
SizeSlider.BorderSizePixel = 0
SizeSlider.ClipsDescendants = true
SizeSlider.Size = UDim2.new(1, 0, 1, 0)
SizeSlider.Parent = SliderGroup

local UICorner_17 = Instance.new("UICorner")
UICorner_17.CornerRadius = UDim.new(0, 10)
UICorner_17.Parent = SizeSlider

local TextLabel_7 = Instance.new("TextLabel")
TextLabel_7.BackgroundTransparency = 1
TextLabel_7.Position = UDim2.new(0, 0, 0, 8)
TextLabel_7.Size = UDim2.new(1, 0, 0, 20)
TextLabel_7.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
TextLabel_7.Text = "100"
TextLabel_7.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel_7.TextSize = 13
TextLabel_7.Parent = SizeSlider

local Frame_6 = Instance.new("Frame")
Frame_6.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame_6.BorderSizePixel = 0
Frame_6.Position = UDim2.new(0.5, -5, 0, 42)
Frame_6.Size = UDim2.new(0, 10, 0, 120)
Frame_6.Parent = SizeSlider

local UICorner_18 = Instance.new("UICorner")
UICorner_18.CornerRadius = UDim.new(1, 0)
UICorner_18.Parent = Frame_6

local Frame_7 = Instance.new("Frame")
Frame_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_7.BorderSizePixel = 0
Frame_7.Position = UDim2.new(0.5, -5, 0, 102)
Frame_7.Size = UDim2.new(0, 10, 0, 60)
Frame_7.ZIndex = 2
Frame_7.Parent = SizeSlider

local UICorner_19 = Instance.new("UICorner")
UICorner_19.CornerRadius = UDim.new(1, 0)
UICorner_19.Parent = Frame_7

local TextButton_6 = Instance.new("TextButton")
TextButton_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton_6.BorderSizePixel = 0
TextButton_6.Position = UDim2.new(0.5, -10, 0, 92)
TextButton_6.Size = UDim2.new(0, 20, 0, 20)
TextButton_6.ZIndex = 3
TextButton_6.AutoButtonColor = false
TextButton_6.Text = ""
TextButton_6.Parent = SizeSlider

local UICorner_20 = Instance.new("UICorner")
UICorner_20.CornerRadius = UDim.new(1, 0)
UICorner_20.Parent = TextButton_6

CleanSpeedBypass.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

return CleanSpeedBypass