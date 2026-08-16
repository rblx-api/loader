local Players = game:GetService("Players").LocalPlayer:WaitForChild('PlayerGui')
local HttpService = game:GetService("HttpService")
local isfileResult = isfile("SacredAHK_Key.txt")
local getChildren = Players:GetChildren()
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SacredUI_KeySystem"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Players
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 230)
Frame.Position = UDim2.new(0.5, -160, 0.5, -115)
Frame.BackgroundColor3 = Color3.fromRGB(250, 250, 252)
Frame.BorderSizePixel = 0
local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 16)
local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Color = Color3.fromRGB(230, 20, 50)
UIStroke.Thickness = 2.5
UIStroke.Transparency = 0
spawn(function(arg1, arg2, arg3)
    for _ = 1, 124 do
        local TweenService = game:GetService("TweenService"):Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Transparency = 0.5
        })
        local play = TweenService:Play()
        task.wait(1)
        local TweenService2 = game:GetService("TweenService"):Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        Transparency = 0
        })
        local play2 = TweenService2:Play()
        task.wait(1)
    end
    local TweenService3 = game:GetService("TweenService"):Create(UIStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.5
        })
    local play3 = TweenService3:Play()
    for _ = 1, 249 do
        task.wait(1)
        local TweenService4 = game:GetService("TweenService").Create:Play()
    end
    for _ = 1, 502 do
        task.wait(1)
    end
end)
local TextLabel = Instance.new("TextLabel", Frame)
TextLabel.Text = "🔐 SACRED AHK [mejorado]"
TextLabel.Font = Enum.Font.GothamBlack
TextLabel.TextSize = 18
TextLabel.TextColor3 = Color3.fromRGB(220, 20, 50)
TextLabel.Size = UDim2.new(1, 0, 0, 30)
TextLabel.Position = UDim2.new(0, 0, 0, 16)
TextLabel.BackgroundTransparency = 1
local TextLabel2 = Instance.new("TextLabel", Frame)
TextLabel2.Text = "Enter key to unlock script access"
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextSize = 10
TextLabel2.TextColor3 = Color3.fromRGB(80, 80, 95)
TextLabel2.Size = UDim2.new(1, 0, 0, 16)
TextLabel2.Position = UDim2.new(0, 0, 0, 44)
TextLabel2.BackgroundTransparency = 1
local TextButton = Instance.new("TextButton", Frame)
TextButton.Text = "📋 Copy Discord Link (Get Key)"
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 11
TextButton.TextColor3 = Color3.fromRGB(230, 20, 50)
TextButton.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
TextButton.Size = UDim2.new(0.85, 0, 0, 30)
TextButton.Position = UDim2.new(0.075, 0, 0, 68)
local UICorner2 = Instance.new("UICorner", TextButton)
UICorner2.CornerRadius = UDim.new(0, 10)
local UIStroke2 = Instance.new("UIStroke", TextButton)
UIStroke2.Color = Color3.fromRGB(220, 200, 210)
UIStroke2.Thickness = 1
TextButton:Connect(function(arg1, arg2, arg3)
    setclipboard('https://discord.gg/pNxhjQx8vV')
    TextButton.Text = "✅ Discord Link Copied!"
end)
local TextBox = Instance.new("TextBox", Frame)
TextBox.PlaceholderText = "Enter Key Here..."
TextBox.PlaceholderColor3 = Color3.fromRGB(130, 130, 145)
TextBox.Text = ""
TextBox.Font = Enum.Font.GothamBold
TextBox.TextSize = 13
TextBox.TextColor3 = Color3.fromRGB(20, 20, 30)
TextBox.BackgroundColor3 = Color3.fromRGB(240, 242, 248)
TextBox.Size = UDim2.new(0.85, 0, 0, 34)
TextBox.Position = UDim2.new(0.075, 0, 0, 110)
TextBox.ClearTextOnFocus = false
local UICorner3 = Instance.new("UICorner", TextBox)
UICorner3.CornerRadius = UDim.new(0, 10)
local UIStroke3 = Instance.new("UIStroke", TextBox)
UIStroke3.Color = Color3.fromRGB(200, 200, 215)
UIStroke3.Thickness = 1.2
local TextButton2 = Instance.new("TextButton", Frame)
TextButton2.Text = "🔓 Verify Key"
TextButton2.Font = Enum.Font.GothamBlack
TextButton2.TextSize = 13
TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton2.BackgroundColor3 = Color3.fromRGB(230, 20, 50)
TextButton2.Size = UDim2.new(0.85, 0, 0, 34)
TextButton2.Position = UDim2.new(0.075, 0, 0, 154)
local UICorner4 = Instance.new("UICorner", TextButton2)
UICorner4.CornerRadius = UDim.new(0, 12)
local TextLabel3 = Instance.new("TextLabel", Frame)
TextLabel3.Text = ""
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.TextSize = 9.5
TextLabel3.TextColor3 = Color3.fromRGB(220, 20, 50)
TextLabel3.Size = UDim2.new(1, 0, 0, 16)
TextLabel3.Position = UDim2.new(0, 0, 0, 196)
TextLabel3.BackgroundTransparency = 1
TextButton2:Connect(function(arg1, arg2, arg3)
    TextLabel3.TextColor3 = Color3.fromRGB(220, 20, 50)
    TextLabel3.Text = "❌ Invalid Key! Copy Discord to get it."
    local uDim2 = Frame + UDim2.new(0, 6, 0, 0)
end)