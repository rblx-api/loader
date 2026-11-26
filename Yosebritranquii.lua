print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
 
local UserInputService = game:GetService("UserInputService")
 
local TweenService = game:GetService("TweenService")
 
local HttpService = game:GetService("HttpService")
 
local Players = game:GetService("Players")
 
local RunService = game:GetService("RunService")
 
local Stats = game:GetService("Stats")
 
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
 
 
local children = PlayerGui:GetChildren()
 
for k, v in pairs(children) do
end
 
local ScreenGui = Instance.new("ScreenGui")
 
ScreenGui.Name = "NexusPingLaggerGui"
 
ScreenGui.ResetOnSpawn = false
 
ScreenGui.DisplayOrder = 15
 
ScreenGui.Parent = PlayerGui
 
local Frame = Instance.new("Frame")
 
Frame.Name = "MainFrame"
 
Frame.Size = UDim2.new(0, 220, 0, 0)
 
Frame.Position = UDim2.new(0.5, -110, 0.5, -47.5)
 
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
 
Frame.BorderSizePixel = 0
 
Frame.Active = true
 
Frame.ClipsDescendants = true
 
Frame.Parent = ScreenGui
 
local UICorner = Instance.new("UICorner", Frame)
 
UICorner.CornerRadius = UDim.new(0, 10)
 
local UIStroke = Instance.new("UIStroke", Frame)
 
UIStroke.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke.Thickness = 1
 
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
Frame.InputBegan:Connect(function(input, gameProcessed)
end)
 
Frame.InputChanged:Connect(function(input2, gameProcessed2)
end)
 
local Frame2 = Instance.new("Frame", Frame)
 
Frame2.Size = UDim2.new(1, 0, 0, 32)
 
Frame2.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame2.BorderSizePixel = 0
 
Frame2.ZIndex = 2
 
local UICorner2 = Instance.new("UICorner", Frame2)
 
UICorner2.CornerRadius = UDim.new(0, 10)
 
local TextLabel = Instance.new("TextLabel", Frame2)
 
TextLabel.Size = UDim2.new(1, -64, 1, 0)
 
TextLabel.Position = UDim2.new(0, 12, 0, 0)
 
TextLabel.BackgroundTransparency = 1
 
TextLabel.Text = "NEXUS"
 
TextLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextLabel.Font = Enum.Font.GothamBlack
 
TextLabel.TextSize = 12
 
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel.ZIndex = 3
 
local TextLabel2 = Instance.new("TextLabel", Frame2)
 
TextLabel2.Size = UDim2.new(0, 80, 1, 0)
 
TextLabel2.Position = UDim2.new(0, 60, 0, 0)
 
TextLabel2.BackgroundTransparency = 1
 
TextLabel2.Text = "PING LAGGER"
 
TextLabel2.TextColor3 = Color3.fromRGB(90, 90, 105)
 
TextLabel2.Font = Enum.Font.GothamBold
 
TextLabel2.TextSize = 8
 
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel2.ZIndex = 3
 
local TextButton = Instance.new("TextButton", Frame2)
 
TextButton.Size = UDim2.new(0, 26, 0, 26)
 
TextButton.Position = UDim2.new(1, -30, 0.5, -13)
 
TextButton.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
 
TextButton.BorderSizePixel = 0
 
TextButton.AutoButtonColor = false
 
TextButton.Text = "\153"
 
TextButton.TextColor3 = Color3.fromRGB(130, 130, 145)
 
TextButton.Font = Enum.Font.GothamBold
 
TextButton.TextSize = 12
 
TextButton.ZIndex = 4
 
local UICorner3 = Instance.new("UICorner", TextButton)
 
UICorner3.CornerRadius = UDim.new(0, 6)
 
TextButton.MouseEnter:Connect(function(arg)
	 
	local tween8 = TweenService:Create(TextButton, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(45, 45, 55), TextColor3 = Color3.fromRGB(240, 240, 245) })
	 
	tween8:Play()
end)
 
TextButton.MouseLeave:Connect(function(arg2)
	 
	local tween9 = TweenService:Create(TextButton, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(36, 36, 44), TextColor3 = Color3.fromRGB(130, 130, 145) })
	 
	tween9:Play()
end)
 
local Frame3 = Instance.new("Frame", Frame)
 
Frame3.Size = UDim2.new(1, -20, 0, 28)
 
Frame3.Position = UDim2.new(0, 10, 0, 38)
 
Frame3.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
Frame3.BorderSizePixel = 0
 
Frame3.ZIndex = 2
 
local UICorner4 = Instance.new("UICorner", Frame3)
 
UICorner4.CornerRadius = UDim.new(0, 6)
 
local UIStroke2 = Instance.new("UIStroke", Frame3)
 
UIStroke2.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke2.Thickness = 1
 
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local Frame4 = Instance.new("Frame", Frame3)
 
Frame4.Size = UDim2.new(0, 8, 0, 8)
 
Frame4.Position = UDim2.new(0, 10, 0.5, -4)
 
Frame4.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
 
Frame4.BorderSizePixel = 0
 
Frame4.ZIndex = 3
 
local UICorner5 = Instance.new("UICorner", Frame4)
 
UICorner5.CornerRadius = UDim.new(0, 4)
 
local TextLabel3 = Instance.new("TextLabel", Frame3)
 
TextLabel3.Size = UDim2.new(1, -30, 1, 0)
 
TextLabel3.Position = UDim2.new(0, 24, 0, 0)
 
TextLabel3.BackgroundTransparency = 1
 
TextLabel3.Text = "INACTIVE"
 
TextLabel3.TextColor3 = Color3.fromRGB(90, 90, 105)
 
TextLabel3.Font = Enum.Font.GothamBold
 
TextLabel3.TextSize = 9
 
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel3.ZIndex = 3
 
local TextButton2 = Instance.new("TextButton", Frame)
 
TextButton2.Size = UDim2.new(1, -20, 0, 26)
 
TextButton2.Position = UDim2.new(0, 10, 0, 66)
 
TextButton2.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
 
TextButton2.BorderSizePixel = 0
 
TextButton2.AutoButtonColor = false
 
TextButton2.Text = "ACTIVATE"
 
TextButton2.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextButton2.Font = Enum.Font.GothamBlack
 
TextButton2.TextSize = 10
 
TextButton2.ZIndex = 2
 
local UICorner6 = Instance.new("UICorner", TextButton2)
 
UICorner6.CornerRadius = UDim.new(0, 6)
 
local UIStroke3 = Instance.new("UIStroke", TextButton2)
 
UIStroke3.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke3.Thickness = 1
 
UIStroke3.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextButton2.MouseEnter:Connect(function(arg3)
	 
	local tween10 = TweenService:Create(TextButton2, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween10:Play()
end)
 
TextButton2.MouseLeave:Connect(function(arg4)
	 
	local tween11 = TweenService:Create(TextButton2, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(36, 36, 44) })
	 
	tween11:Play()
end)
 
local Frame5 = Instance.new("Frame")
 
Frame5.Name = "SettingsPanel"
 
Frame5.Size = UDim2.new(0, 220, 0, 0)
 
Frame5.Position = UDim2.new(0.5, -110, 0.5, 60)
 
Frame5.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
 
Frame5.BorderSizePixel = 0
 
Frame5.Active = true
 
Frame5.ClipsDescendants = true
 
Frame5.Visible = false
 
Frame5.ZIndex = 20
 
Frame5.Parent = ScreenGui
 
local UICorner7 = Instance.new("UICorner", Frame5)
 
UICorner7.CornerRadius = UDim.new(0, 10)
 
local UIStroke4 = Instance.new("UIStroke", Frame5)
 
UIStroke4.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke4.Thickness = 1
 
UIStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
Frame5.InputBegan:Connect(function(input3, gameProcessed3)
end)
 
Frame5.InputChanged:Connect(function(input4, gameProcessed4)
end)
 
local Frame6 = Instance.new("Frame", Frame5)
 
Frame6.Size = UDim2.new(1, 0, 0, 32)
 
Frame6.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame6.BorderSizePixel = 0
 
Frame6.ZIndex = 21
 
local UICorner8 = Instance.new("UICorner", Frame6)
 
UICorner8.CornerRadius = UDim.new(0, 10)
 
local TextLabel4 = Instance.new("TextLabel", Frame6)
 
TextLabel4.Size = UDim2.new(1, -36, 1, 0)
 
TextLabel4.Position = UDim2.new(0, 12, 0, 0)
 
TextLabel4.BackgroundTransparency = 1
 
TextLabel4.Text = "SETTINGS"
 
TextLabel4.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextLabel4.Font = Enum.Font.GothamBlack
 
TextLabel4.TextSize = 10
 
TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel4.ZIndex = 22
 
local TextButton3 = Instance.new("TextButton", Frame6)
 
TextButton3.Size = UDim2.new(0, 26, 0, 26)
 
TextButton3.Position = UDim2.new(1, -30, 0.5, -13)
 
TextButton3.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
 
TextButton3.BorderSizePixel = 0
 
TextButton3.AutoButtonColor = false
 
TextButton3.Text = "\21"
 
TextButton3.TextColor3 = Color3.fromRGB(130, 130, 145)
 
TextButton3.Font = Enum.Font.GothamBold
 
TextButton3.TextSize = 10
 
TextButton3.ZIndex = 23
 
local UICorner9 = Instance.new("UICorner", TextButton3)
 
UICorner9.CornerRadius = UDim.new(0, 6)
 
TextButton3.MouseEnter:Connect(function(arg5)
	 
	local tween12 = TweenService:Create(TextButton3, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(235, 70, 90), TextColor3 = Color3.fromRGB(240, 240, 245) })
	 
	tween12:Play()
end)
 
TextButton3.MouseLeave:Connect(function(arg6)
	 
	local tween13 = TweenService:Create(TextButton3, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(36, 36, 44), TextColor3 = Color3.fromRGB(130, 130, 145) })
	 
	tween13:Play()
end)
 
local Frame7 = Instance.new("Frame", Frame5)
 
Frame7.Size = UDim2.new(1, -16, 0, 30)
 
Frame7.Position = UDim2.new(0, 8, 0, 38)
 
Frame7.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame7.BorderSizePixel = 0
 
Frame7.ZIndex = 21
 
local UICorner10 = Instance.new("UICorner", Frame7)
 
UICorner10.CornerRadius = UDim.new(0, 6)
 
local UIStroke5 = Instance.new("UIStroke", Frame7)
 
UIStroke5.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke5.Thickness = 1
 
UIStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local TextLabel5 = Instance.new("TextLabel", Frame7)
 
TextLabel5.Size = UDim2.new(0.5, 0, 1, 0)
 
TextLabel5.Position = UDim2.new(0, 10, 0, 0)
 
TextLabel5.BackgroundTransparency = 1
 
TextLabel5.Text = "Power"
 
TextLabel5.TextColor3 = Color3.fromRGB(200, 200, 215)
 
TextLabel5.Font = Enum.Font.GothamBold
 
TextLabel5.TextSize = 9
 
TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel5.ZIndex = 22
 
local TextBox = Instance.new("TextBox", Frame7)
 
TextBox.Size = UDim2.new(0, 60, 0, 20)
 
TextBox.Position = UDim2.new(1, -68, 0.5, -10)
 
TextBox.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
TextBox.BorderSizePixel = 0
 
TextBox.Text = "80000"
 
TextBox.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextBox.Font = Enum.Font.GothamBold
 
TextBox.TextSize = 10
 
TextBox.ClearTextOnFocus = false
 
TextBox.ZIndex = 23
 
local UICorner11 = Instance.new("UICorner", TextBox)
 
UICorner11.CornerRadius = UDim.new(0, 4)
 
local UIStroke6 = Instance.new("UIStroke", TextBox)
 
UIStroke6.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke6.Thickness = 1
 
UIStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextBox.Focused:Connect(function(arg7)
	 
	local tween14 = TweenService:Create(TextBox, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(200, 200, 215) })
	 
	tween14:Play()
end)
 
TextBox.FocusLost:Connect(function(enterPressed, inputObject)
	 
	local tween15 = TweenService:Create(TextBox, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween15:Play()
	 
	TextBox.Text = "80000"
	 
	HttpService:JSONEncode({
	autoBrainrot = true,
	bypassPower = 8000,
	interval = 0.15,
	keybindGp = "ButtonR2",
	keybindKb = "M",
	power = 80000
}) -- [SUPERZ] real
	 
	writefile("NexusPingLagger_Config.json", "{\"autoBrainrot\":true,\"bypassPower\":8000,\"interval\":0.15,\"keybindGp\":\"ButtonR2\",\"keybindKb\":\"M\",\"power\":80000}")
end)
 
local Frame8 = Instance.new("Frame", Frame5)
 
Frame8.Size = UDim2.new(1, -16, 0, 30)
 
Frame8.Position = UDim2.new(0, 8, 0, 72)
 
Frame8.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame8.BorderSizePixel = 0
 
Frame8.ZIndex = 21
 
local UICorner12 = Instance.new("UICorner", Frame8)
 
UICorner12.CornerRadius = UDim.new(0, 6)
 
local UIStroke7 = Instance.new("UIStroke", Frame8)
 
UIStroke7.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke7.Thickness = 1
 
UIStroke7.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local TextLabel6 = Instance.new("TextLabel", Frame8)
 
TextLabel6.Size = UDim2.new(0.5, 0, 1, 0)
 
TextLabel6.Position = UDim2.new(0, 10, 0, 0)
 
TextLabel6.BackgroundTransparency = 1
 
TextLabel6.Text = "Delay"
 
TextLabel6.TextColor3 = Color3.fromRGB(200, 200, 215)
 
TextLabel6.Font = Enum.Font.GothamBold
 
TextLabel6.TextSize = 9
 
TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel6.ZIndex = 22
 
local TextBox2 = Instance.new("TextBox", Frame8)
 
TextBox2.Size = UDim2.new(0, 60, 0, 20)
 
TextBox2.Position = UDim2.new(1, -68, 0.5, -10)
 
TextBox2.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
TextBox2.BorderSizePixel = 0
 
TextBox2.Text = "0.15"
 
TextBox2.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextBox2.Font = Enum.Font.GothamBold
 
TextBox2.TextSize = 10
 
TextBox2.ClearTextOnFocus = false
 
TextBox2.ZIndex = 23
 
local UICorner13 = Instance.new("UICorner", TextBox2)
 
UICorner13.CornerRadius = UDim.new(0, 4)
 
local UIStroke8 = Instance.new("UIStroke", TextBox2)
 
UIStroke8.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke8.Thickness = 1
 
UIStroke8.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextBox2.Focused:Connect(function(arg8)
	 
	local tween16 = TweenService:Create(TextBox2, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(200, 200, 215) })
	 
	tween16:Play()
end)
 
TextBox2.FocusLost:Connect(function(enterPressed2, inputObject2)
	 
	local tween17 = TweenService:Create(TextBox2, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween17:Play()
	 
	TextBox2.Text = "0.15"
	 
	HttpService:JSONEncode({
	autoBrainrot = true,
	bypassPower = 8000,
	interval = 0.15,
	keybindGp = "ButtonR2",
	keybindKb = "M",
	power = 80000
}) -- [SUPERZ] real
	 
	writefile("NexusPingLagger_Config.json", "{\"autoBrainrot\":true,\"bypassPower\":8000,\"interval\":0.15,\"keybindGp\":\"ButtonR2\",\"keybindKb\":\"M\",\"power\":80000}")
end)
 
local Frame9 = Instance.new("Frame", Frame5)
 
Frame9.Size = UDim2.new(1, -16, 0, 30)
 
Frame9.Position = UDim2.new(0, 8, 0, 106)
 
Frame9.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame9.BorderSizePixel = 0
 
Frame9.ZIndex = 21
 
local UICorner14 = Instance.new("UICorner", Frame9)
 
UICorner14.CornerRadius = UDim.new(0, 6)
 
local UIStroke9 = Instance.new("UIStroke", Frame9)
 
UIStroke9.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke9.Thickness = 1
 
UIStroke9.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local TextLabel7 = Instance.new("TextLabel", Frame9)
 
TextLabel7.Size = UDim2.new(0.5, 0, 1, 0)
 
TextLabel7.Position = UDim2.new(0, 10, 0, 0)
 
TextLabel7.BackgroundTransparency = 1
 
TextLabel7.Text = "Bypass Power"
 
TextLabel7.TextColor3 = Color3.fromRGB(200, 200, 215)
 
TextLabel7.Font = Enum.Font.GothamBold
 
TextLabel7.TextSize = 9
 
TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel7.ZIndex = 22
 
local TextBox3 = Instance.new("TextBox", Frame9)
 
TextBox3.Size = UDim2.new(0, 60, 0, 20)
 
TextBox3.Position = UDim2.new(1, -68, 0.5, -10)
 
TextBox3.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
TextBox3.BorderSizePixel = 0
 
TextBox3.Text = "8000"
 
TextBox3.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextBox3.Font = Enum.Font.GothamBold
 
TextBox3.TextSize = 10
 
TextBox3.ClearTextOnFocus = false
 
TextBox3.ZIndex = 23
 
local UICorner15 = Instance.new("UICorner", TextBox3)
 
UICorner15.CornerRadius = UDim.new(0, 4)
 
local UIStroke10 = Instance.new("UIStroke", TextBox3)
 
UIStroke10.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke10.Thickness = 1
 
UIStroke10.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextBox3.Focused:Connect(function(arg9)
	 
	local tween18 = TweenService:Create(TextBox3, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(200, 200, 215) })
	 
	tween18:Play()
end)
 
TextBox3.FocusLost:Connect(function(enterPressed3, inputObject3)
	 
	local tween19 = TweenService:Create(TextBox3, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween19:Play()
	 
	TextBox3.Text = "8000"
	 
	HttpService:JSONEncode({
	autoBrainrot = true,
	bypassPower = 8000,
	interval = 0.15,
	keybindGp = "ButtonR2",
	keybindKb = "M",
	power = 80000
}) -- [SUPERZ] real
	 
	writefile("NexusPingLagger_Config.json", "{\"autoBrainrot\":true,\"bypassPower\":8000,\"interval\":0.15,\"keybindGp\":\"ButtonR2\",\"keybindKb\":\"M\",\"power\":80000}")
end)
 
local Frame10 = Instance.new("Frame", Frame5)
 
Frame10.Size = UDim2.new(1, -16, 0, 30)
 
Frame10.Position = UDim2.new(0, 8, 0, 140)
 
Frame10.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame10.BorderSizePixel = 0
 
Frame10.ZIndex = 21
 
local UICorner16 = Instance.new("UICorner", Frame10)
 
UICorner16.CornerRadius = UDim.new(0, 6)
 
local UIStroke11 = Instance.new("UIStroke", Frame10)
 
UIStroke11.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke11.Thickness = 1
 
UIStroke11.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local TextLabel8 = Instance.new("TextLabel", Frame10)
 
TextLabel8.Size = UDim2.new(0.6, 0, 1, 0)
 
TextLabel8.Position = UDim2.new(0, 10, 0, 0)
 
TextLabel8.BackgroundTransparency = 1
 
TextLabel8.Text = "Auto Brainrot"
 
TextLabel8.TextColor3 = Color3.fromRGB(200, 200, 215)
 
TextLabel8.Font = Enum.Font.GothamBold
 
TextLabel8.TextSize = 9
 
TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel8.ZIndex = 22
 
local TextButton4 = Instance.new("TextButton", Frame10)
 
TextButton4.Size = UDim2.new(0, 44, 0, 20)
 
TextButton4.Position = UDim2.new(1, -52, 0.5, -10)
 
TextButton4.BorderSizePixel = 0
 
TextButton4.AutoButtonColor = false
 
TextButton4.Text = "ON"
 
TextButton4.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextButton4.Font = Enum.Font.GothamBlack
 
TextButton4.TextSize = 8
 
TextButton4.ZIndex = 23
 
local UICorner17 = Instance.new("UICorner", TextButton4)
 
UICorner17.CornerRadius = UDim.new(0, 10)
 
local UIStroke12 = Instance.new("UIStroke", TextButton4)
 
UIStroke12.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke12.Thickness = 1
 
UIStroke12.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextButton4.Text = "ON"
 
local tween = TweenService:Create(TextButton4, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(30, 80, 50), BorderColor3 = Color3.fromRGB(80, 220, 120) })
 
tween:Play()
 
TextButton4.MouseButton1Click:Connect(function()
	 
	TextButton4.Text = "OFF"
	 
	local tween20 = TweenService:Create(TextButton4, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(14, 14, 18), BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween20:Play()
	 
	HttpService:JSONEncode({
	autoBrainrot = false,
	bypassPower = 8000,
	interval = 0.15,
	keybindGp = "ButtonR2",
	keybindKb = "M",
	power = 80000
}) -- [SUPERZ] real
	 
	writefile("NexusPingLagger_Config.json", "{\"autoBrainrot\":false,\"bypassPower\":8000,\"interval\":0.15,\"keybindGp\":\"ButtonR2\",\"keybindKb\":\"M\",\"power\":80000}")
end)
 
local Frame11 = Instance.new("Frame", Frame5)
 
Frame11.Size = UDim2.new(1, -20, 0, 1)
 
Frame11.Position = UDim2.new(0, 10, 0, 174)
 
Frame11.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
 
Frame11.BorderSizePixel = 0
 
Frame11.ZIndex = 21
 
local TextLabel9 = Instance.new("TextLabel", Frame5)
 
TextLabel9.Size = UDim2.new(1, -16, 0, 14)
 
TextLabel9.Position = UDim2.new(0, 8, 0, 180)
 
TextLabel9.BackgroundTransparency = 1
 
TextLabel9.Text = "KEYBINDS"
 
TextLabel9.TextColor3 = Color3.fromRGB(90, 90, 105)
 
TextLabel9.Font = Enum.Font.GothamBold
 
TextLabel9.TextSize = 7
 
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel9.ZIndex = 21
 
local Frame12 = Instance.new("Frame", Frame5)
 
Frame12.Size = UDim2.new(1, -16, 0, 30)
 
Frame12.Position = UDim2.new(0, 8, 0, 194)
 
Frame12.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame12.BorderSizePixel = 0
 
Frame12.ZIndex = 21
 
local UICorner18 = Instance.new("UICorner", Frame12)
 
UICorner18.CornerRadius = UDim.new(0, 6)
 
local UIStroke13 = Instance.new("UIStroke", Frame12)
 
UIStroke13.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke13.Thickness = 1
 
UIStroke13.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local TextLabel10 = Instance.new("TextLabel", Frame12)
 
TextLabel10.Size = UDim2.new(0.4, 0, 1, 0)
 
TextLabel10.Position = UDim2.new(0, 10, 0, 0)
 
TextLabel10.BackgroundTransparency = 1
 
TextLabel10.Text = "Keyboard"
 
TextLabel10.TextColor3 = Color3.fromRGB(200, 200, 215)
 
TextLabel10.Font = Enum.Font.GothamBold
 
TextLabel10.TextSize = 9
 
TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel10.ZIndex = 22
 
local TextButton5 = Instance.new("TextButton", Frame12)
 
TextButton5.Size = UDim2.new(0, 60, 0, 20)
 
TextButton5.Position = UDim2.new(1, -68, 0.5, -10)
 
TextButton5.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
TextButton5.BorderSizePixel = 0
 
TextButton5.AutoButtonColor = false
 
TextButton5.Font = Enum.Font.GothamBold
 
TextButton5.TextSize = 9
 
TextButton5.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextButton5.ZIndex = 23
 
TextButton5.Text = "M"
 
local UICorner19 = Instance.new("UICorner", TextButton5)
 
UICorner19.CornerRadius = UDim.new(0, 4)
 
local UIStroke14 = Instance.new("UIStroke", TextButton5)
 
UIStroke14.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke14.Thickness = 1
 
UIStroke14.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextButton5.MouseButton1Click:Connect(function()
	 
	TextButton5.Text = "..."
	 
	TextButton5.TextColor3 = Color3.fromRGB(200, 200, 215)
	 
	local tween21 = TweenService:Create(Frame12, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(200, 200, 215) })
	 
	tween21:Play()
	 
	TextButton7.Text = "ButtonR2"
	 
	TextButton7.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween22 = TweenService:Create(Frame13, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween22:Play()
end)
 
local TextButton6 = Instance.new("TextButton", Frame12)
 
TextButton6.Size = UDim2.new(0, 20, 0, 20)
 
TextButton6.Position = UDim2.new(1, -30, 0.5, -10)
 
TextButton6.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
TextButton6.BorderSizePixel = 0
 
TextButton6.AutoButtonColor = false
 
TextButton6.Text = "\21"
 
TextButton6.TextColor3 = Color3.fromRGB(90, 90, 105)
 
TextButton6.Font = Enum.Font.GothamBold
 
TextButton6.TextSize = 8
 
TextButton6.ZIndex = 23
 
local UICorner20 = Instance.new("UICorner", TextButton6)
 
UICorner20.CornerRadius = UDim.new(0, 4)
 
TextButton6.MouseEnter:Connect(function(arg10)
	 
	local tween23 = TweenService:Create(TextButton6, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(235, 70, 90), TextColor3 = Color3.fromRGB(240, 240, 245) })
	 
	tween23:Play()
end)
 
TextButton6.MouseLeave:Connect(function(arg11)
	 
	local tween24 = TweenService:Create(TextButton6, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(14, 14, 18), TextColor3 = Color3.fromRGB(90, 90, 105) })
	 
	tween24:Play()
end)
 
TextButton6.MouseButton1Click:Connect(function()
	 
	TextButton5.Text = "None"
	 
	TextButton5.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween25 = TweenService:Create(Frame12, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween25:Play()
	 
	TextButton7.Text = "ButtonR2"
	 
	TextButton7.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween26 = TweenService:Create(Frame13, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween26:Play()
	 
	HttpService:JSONEncode({
	autoBrainrot = false,
	bypassPower = 8000,
	interval = 0.15,
	keybindGp = "ButtonR2",
	keybindKb = "None",
	power = 80000
}) -- [SUPERZ] real
	 
	writefile("NexusPingLagger_Config.json", "{\"autoBrainrot\":false,\"bypassPower\":8000,\"interval\":0.15,\"keybindGp\":\"ButtonR2\",\"keybindKb\":\"None\",\"power\":80000}")
end)
 
local Frame13 = Instance.new("Frame", Frame5)
 
Frame13.Size = UDim2.new(1, -16, 0, 30)
 
Frame13.Position = UDim2.new(0, 8, 0, 228)
 
Frame13.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
Frame13.BorderSizePixel = 0
 
Frame13.ZIndex = 21
 
local UICorner21 = Instance.new("UICorner", Frame13)
 
UICorner21.CornerRadius = UDim.new(0, 6)
 
local UIStroke15 = Instance.new("UIStroke", Frame13)
 
UIStroke15.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke15.Thickness = 1
 
UIStroke15.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local TextLabel11 = Instance.new("TextLabel", Frame13)
 
TextLabel11.Size = UDim2.new(0.4, 0, 1, 0)
 
TextLabel11.Position = UDim2.new(0, 10, 0, 0)
 
TextLabel11.BackgroundTransparency = 1
 
TextLabel11.Text = "Controller"
 
TextLabel11.TextColor3 = Color3.fromRGB(200, 200, 215)
 
TextLabel11.Font = Enum.Font.GothamBold
 
TextLabel11.TextSize = 9
 
TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel11.ZIndex = 22
 
local TextButton7 = Instance.new("TextButton", Frame13)
 
TextButton7.Size = UDim2.new(0, 60, 0, 20)
 
TextButton7.Position = UDim2.new(1, -68, 0.5, -10)
 
TextButton7.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
TextButton7.BorderSizePixel = 0
 
TextButton7.AutoButtonColor = false
 
TextButton7.Font = Enum.Font.GothamBold
 
TextButton7.TextSize = 9
 
TextButton7.TextColor3 = Color3.fromRGB(240, 240, 245)
 
TextButton7.ZIndex = 23
 
TextButton7.Text = "ButtonR2"
 
local UICorner22 = Instance.new("UICorner", TextButton7)
 
UICorner22.CornerRadius = UDim.new(0, 4)
 
local UIStroke16 = Instance.new("UIStroke", TextButton7)
 
UIStroke16.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke16.Thickness = 1
 
UIStroke16.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextButton7.MouseButton1Click:Connect(function()
	 
	TextButton5.Text = "None"
	 
	TextButton5.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween27 = TweenService:Create(Frame12, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween27:Play()
	 
	TextButton7.Text = "..."
	 
	TextButton7.TextColor3 = Color3.fromRGB(200, 200, 215)
	 
	local tween28 = TweenService:Create(Frame13, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(200, 200, 215) })
	 
	tween28:Play()
end)
 
local TextButton8 = Instance.new("TextButton", Frame13)
 
TextButton8.Size = UDim2.new(0, 20, 0, 20)
 
TextButton8.Position = UDim2.new(1, -30, 0.5, -10)
 
TextButton8.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
 
TextButton8.BorderSizePixel = 0
 
TextButton8.AutoButtonColor = false
 
TextButton8.Text = "\21"
 
TextButton8.TextColor3 = Color3.fromRGB(90, 90, 105)
 
TextButton8.Font = Enum.Font.GothamBold
 
TextButton8.TextSize = 8
 
TextButton8.ZIndex = 23
 
local UICorner23 = Instance.new("UICorner", TextButton8)
 
UICorner23.CornerRadius = UDim.new(0, 4)
 
TextButton8.MouseEnter:Connect(function(arg12)
	 
	local tween29 = TweenService:Create(TextButton8, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(235, 70, 90), TextColor3 = Color3.fromRGB(240, 240, 245) })
	 
	tween29:Play()
end)
 
TextButton8.MouseLeave:Connect(function(arg13)
	 
	local tween30 = TweenService:Create(TextButton8, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(14, 14, 18), TextColor3 = Color3.fromRGB(90, 90, 105) })
	 
	tween30:Play()
end)
 
TextButton8.MouseButton1Click:Connect(function()
	 
	TextButton5.Text = "None"
	 
	TextButton5.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween31 = TweenService:Create(Frame12, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween31:Play()
	 
	TextButton7.Text = "None"
	 
	TextButton7.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween32 = TweenService:Create(Frame13, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween32:Play()
	 
	HttpService:JSONEncode({
	autoBrainrot = false,
	bypassPower = 8000,
	interval = 0.15,
	keybindGp = "None",
	keybindKb = "None",
	power = 80000
}) -- [SUPERZ] real
	 
	writefile("NexusPingLagger_Config.json", "{\"autoBrainrot\":false,\"bypassPower\":8000,\"interval\":0.15,\"keybindGp\":\"None\",\"keybindKb\":\"None\",\"power\":80000}")
end)
 
local TextButton9 = Instance.new("TextButton", Frame5)
 
TextButton9.Size = UDim2.new(1, -16, 0, 24)
 
TextButton9.Position = UDim2.new(0, 8, 0, 262)
 
TextButton9.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
TextButton9.BorderSizePixel = 0
 
TextButton9.AutoButtonColor = false
 
TextButton9.Text = "RESET DEFAULTS"
 
TextButton9.TextColor3 = Color3.fromRGB(90, 90, 105)
 
TextButton9.Font = Enum.Font.GothamBold
 
TextButton9.TextSize = 8
 
TextButton9.ZIndex = 21
 
local UICorner24 = Instance.new("UICorner", TextButton9)
 
UICorner24.CornerRadius = UDim.new(0, 6)
 
local UIStroke17 = Instance.new("UIStroke", TextButton9)
 
UIStroke17.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke17.Thickness = 1
 
UIStroke17.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
TextButton9.MouseEnter:Connect(function(arg14)
	 
	local tween33 = TweenService:Create(TextButton9, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(120, 30, 40), BorderColor3 = Color3.fromRGB(235, 70, 90), TextColor3 = Color3.fromRGB(240, 240, 245) })
	 
	tween33:Play()
end)
 
TextButton9.MouseLeave:Connect(function(arg15)
	 
	local tween34 = TweenService:Create(TextButton9, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(26, 26, 32), BorderColor3 = Color3.fromRGB(45, 45, 55), TextColor3 = Color3.fromRGB(90, 90, 105) })
	 
	tween34:Play()
end)
 
local TextButton10 = Instance.new("TextButton", Frame5)
 
TextButton10.Size = UDim2.new(1, -16, 0, 28)
 
TextButton10.Position = UDim2.new(0, 8, 0, 290)
 
TextButton10.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
 
TextButton10.BorderSizePixel = 0
 
TextButton10.AutoButtonColor = false
 
TextButton10.Text = "AUTO OPTIMIZE"
 
TextButton10.TextColor3 = Color3.fromRGB(200, 200, 215)
 
TextButton10.Font = Enum.Font.GothamBlack
 
TextButton10.TextSize = 9
 
TextButton10.ZIndex = 21
 
local UICorner25 = Instance.new("UICorner", TextButton10)
 
UICorner25.CornerRadius = UDim.new(0, 6)
 
local UIStroke18 = Instance.new("UIStroke", TextButton10)
 
UIStroke18.Color = Color3.fromRGB(45, 45, 55)
 
UIStroke18.Thickness = 1
 
UIStroke18.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
 
local TextLabel12 = Instance.new("TextLabel", Frame5)
 
TextLabel12.Size = UDim2.new(1, -16, 0, 12)
 
TextLabel12.Position = UDim2.new(0, 8, 0, 320)
 
TextLabel12.BackgroundTransparency = 1
 
TextLabel12.Text = ""
 
TextLabel12.TextColor3 = Color3.fromRGB(90, 90, 105)
 
TextLabel12.Font = Enum.Font.GothamBold
 
TextLabel12.TextSize = 7
 
TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
 
TextLabel12.ZIndex = 21
 
TextButton10.MouseEnter:Connect(function(arg16)
	 
	local tween35 = TweenService:Create(TextButton10, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(36, 36, 44), TextColor3 = Color3.fromRGB(240, 240, 245) })
	 
	tween35:Play()
end)
 
TextButton10.MouseLeave:Connect(function(arg17)
	 
	local tween36 = TweenService:Create(TextButton10, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(26, 26, 32), TextColor3 = Color3.fromRGB(200, 200, 215) })
	 
	tween36:Play()
end)
 
TextButton10.MouseButton1Click:Connect(function()
	 
	TextButton10.Text = "SCANNING..."
	 
	TextButton10.TextColor3 = Color3.fromRGB(90, 90, 105)
	 
	TextLabel12.Text = "Measuring ping, CPU, GPU..."
	 
	task.spawn(function(...)
		 
		local value = Stats.Workspace.Heartbeat:GetValue()
		 
		local value2 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 1/20..."
		 
		task.wait(0.15)
		 
		local value3 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value4 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 2/20..."
		 
		task.wait(0.15)
		 
		local value5 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value6 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 3/20..."
		 
		task.wait(0.15)
		 
		local value7 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value8 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 4/20..."
		 
		task.wait(0.15)
		 
		local value9 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value10 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 5/20..."
		 
		task.wait(0.15)
		 
		local value11 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value12 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 6/20..."
		 
		task.wait(0.15)
		 
		local value13 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value14 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 7/20..."
		 
		task.wait(0.15)
		 
		local value15 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value16 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 8/20..."
		 
		task.wait(0.15)
		 
		local value17 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value18 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 9/20..."
		 
		task.wait(0.15)
		 
		local value19 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value20 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 10/20..."
		 
		task.wait(0.15)
		 
		local value21 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value22 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 11/20..."
		 
		task.wait(0.15)
		 
		local value23 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value24 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 12/20..."
		 
		task.wait(0.15)
		 
		local value25 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value26 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 13/20..."
		 
		task.wait(0.15)
		 
		local value27 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value28 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 14/20..."
		 
		task.wait(0.15)
		 
		local value29 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value30 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 15/20..."
		 
		task.wait(0.15)
		 
		local value31 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value32 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 16/20..."
		 
		task.wait(0.15)
		 
		local value33 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value34 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 17/20..."
		 
		task.wait(0.15)
		 
		local value35 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value36 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 18/20..."
		 
		task.wait(0.15)
		 
		local value37 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value38 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 19/20..."
		 
		task.wait(0.15)
		 
		local value39 = Stats.Workspace.Heartbeat:GetValue()
		 
		local value40 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		Stats.Network.ReceiveStats:GetValue()
		 
		TextLabel12.Text = "Sampling 20/20..."
		 
		task.wait(0.15)
		 
		TextLabel12.Text = string.format("CPU %.1f | GPU %.1f | Ping %.0f", (((((((((((((((((((((0 + tonumber(value)) + tonumber(value3)) + tonumber(value5)) + tonumber(value7)) + tonumber(value9)) + tonumber(value11)) + tonumber(value13)) + tonumber(value15)) + tonumber(value17)) + tonumber(value19)) + tonumber(value21)) + tonumber(value23)) + tonumber(value25)) + tonumber(value27)) + tonumber(value29)) + tonumber(value31)) + tonumber(value33)) + tonumber(value35)) + tonumber(value37)) + tonumber(value39)) / 20), 16, (((((((((((((((((((((0 + tonumber(value2)) + tonumber(value4)) + tonumber(value6)) + tonumber(value8)) + tonumber(value10)) + tonumber(value12)) + tonumber(value14)) + tonumber(value16)) + tonumber(value18)) + tonumber(value20)) + tonumber(value22)) + tonumber(value24)) + tonumber(value26)) + tonumber(value28)) + tonumber(value30)) + tonumber(value32)) + tonumber(value34)) + tonumber(value36)) + tonumber(value38)) + tonumber(value40)) / 20))
		 
	end)
end)
 
TextButton.MouseButton1Click:Connect(function()
	 
	Frame5.Visible = true
	 
	Frame5.Size = UDim2.new(0, 220, 0, 0)
	 
	local tween37 = TweenService:Create(Frame5, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 220, 0, 420) })
	 
	tween37:Play()
	 
	local tween38 = TweenService:Create(TextButton, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Rotation = 90 })
	 
	tween38:Play()
	 
	TextBox.Text = "80000"
	 
	TextBox2.Text = "0.15"
	 
	TextBox3.Text = "8000"
	 
	TextButton5.Text = "None"
	 
	TextButton5.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween39 = TweenService:Create(Frame12, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween39:Play()
	 
	TextButton7.Text = "None"
	 
	TextButton7.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween40 = TweenService:Create(Frame13, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween40:Play()
	 
	TextButton4.Text = "OFF"
	 
	TextButton4.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
	 
	TextButton4.BorderColor3 = Color3.fromRGB(45, 45, 55)
end)
 
TextButton3.MouseButton1Click:Connect(function()
	 
	TextButton5.Text = "None"
	 
	TextButton5.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween41 = TweenService:Create(Frame12, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween41:Play()
	 
	TextButton7.Text = "None"
	 
	TextButton7.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween42 = TweenService:Create(Frame13, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween42:Play()
	 
	local tween43 = TweenService:Create(Frame5, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 220, 0, 0) })
	 
	tween43:Play()
	 
	local tween44 = TweenService:Create(TextButton, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Rotation = 0 })
	 
	tween44:Play()
	 
	task.delay(0.24, function(...)
	end)
end)
 
local RobloxReplicatedStorage = game:FindFirstChild("RobloxReplicatedStorage")
 
local children2 = RobloxReplicatedStorage:GetChildren()
 
for i, v2 in ipairs(children2) do
	 
	v2.Name:find("Block")
	 
	TextButton2.MouseButton1Click:Connect(function()
		 
		task.spawn(function(...)
			 
			v2:FireServer({
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } },
	{ { { { { { { --[[...]] } } } } } } }
})
			 
			Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
			 
		end)
		 
		local value41 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		 
		TextLabel3.Text = "ACTIVE \" " .. math.floor(tonumber(value41)) .. "ms"
		 
		TextLabel3.TextColor3 = Color3.fromRGB(80, 220, 120)
		 
		local tween45 = TweenService:Create(Frame4, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(80, 220, 120) })
		 
		tween45:Play()
		 
		TextButton2.Text = "DEACTIVATE"
		 
		TextButton2.BackgroundColor3 = Color3.fromRGB(235, 70, 90)
		 
		TextButton2.TextColor3 = Color3.fromRGB(240, 240, 245)
	end)
	 
	RunService.Heartbeat:Connect(function(deltaTime)
	end)
	 
	UserInputService.InputBegan:Connect(function(input5, gameProcessed5)
		 
		input5.KeyCode.Name:sub(1, 6)
		 
		input5.KeyCode.Name:sub(1, 10)
		 
		input5.KeyCode.Name:sub(1, 4)
	end)
	 
	task.spawn(function(...)
		 
		task.wait(1)
		 
		TextLabel3.Text = "INACTIVE"
		 
		TextLabel3.TextColor3 = Color3.fromRGB(90, 90, 105)
		 
		local tween6 = TweenService:Create(Frame4, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(235, 70, 90) })
		 
		tween6:Play()
		 
		TextButton2.Text = "ACTIVATE"
		 
		TextButton2.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
		 
		TextButton2.TextColor3 = Color3.fromRGB(240, 240, 245)
		 
		task.wait(1)
		 
		TextLabel3.Text = "INACTIVE"
		 
		TextLabel3.TextColor3 = Color3.fromRGB(90, 90, 105)
		 
		local tween7 = TweenService:Create(Frame4, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(235, 70, 90) })
		 
		tween7:Play()
		 
		TextButton2.Text = "ACTIVATE"
		 
		TextButton2.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
		 
		TextButton2.TextColor3 = Color3.fromRGB(240, 240, 245)
		 
		task.wait(1)
		 
	end)
	 
	TextButton5.Text = "M"
	 
	TextButton5.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween2 = TweenService:Create(Frame12, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween2:Play()
	 
	TextButton7.Text = "ButtonR2"
	 
	TextButton7.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	local tween3 = TweenService:Create(Frame13, TweenInfo.new(0.12, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BorderColor3 = Color3.fromRGB(45, 45, 55) })
	 
	tween3:Play()
	 
	TextLabel3.Text = "INACTIVE"
	 
	TextLabel3.TextColor3 = Color3.fromRGB(90, 90, 105)
	 
	local tween4 = TweenService:Create(Frame4, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { BackgroundColor3 = Color3.fromRGB(235, 70, 90) })
	 
	tween4:Play()
	 
	TextButton2.Text = "ACTIVATE"
	 
	TextButton2.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
	 
	TextButton2.TextColor3 = Color3.fromRGB(240, 240, 245)
	 
	Frame.Visible = true
	 
	Frame.Position = UDim2.new(0.5, -110, 0.5, -47.5)
	 
	Frame.Size = UDim2.new(0, 220, 0, 0)
	 
	local tween5 = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(0, 220, 0, 95) })
	 
	tween5:Play()
	 
	task.delay(0.36, function(...)
	end)
	 
	task.spawn(function(...)
		 
		task.wait(1)
		 

		task.spawn(function(...)
			 
			task.wait(0.5)
			 
			task.wait(0.5)
			 
		end)
	end)
	 
	print("https://discord.gg/qQRzK6jfFH")
end

print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")
print("deobfuscated by fearless at https://discord.gg/qQRzK6jfFH")