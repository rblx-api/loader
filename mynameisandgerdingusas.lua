-- HAZHUB creds (higher + bigger + purple)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("HazHubCreds") then
	playerGui.HazHubCreds:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "HazHubCreds"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "CredsFrame"
frame.AnchorPoint = Vector2.new(0.5, 1)
frame.Position = UDim2.new(0.5, 0, 1, 60)
frame.Size = UDim2.new(0, 340, 0, 96)
frame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
frame.BackgroundTransparency = 0.12
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(140, 70, 255)
stroke.Transparency = 0.55
stroke.Thickness = 1.4
stroke.Parent = frame

local glow = Instance.new("ImageLabel")
glow.Name = "Glow"
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5028857084"
glow.ImageColor3 = Color3.fromRGB(130, 60, 255)
glow.ImageTransparency = 0.72
glow.Size = UDim2.new(1, 40, 1, 40)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.ZIndex = 0
glow.Parent = frame

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.BackgroundTransparency = 1
logo.Position = UDim2.new(0, 16, 0.5, -22)
logo.Size = UDim2.new(0, 44, 0, 44)
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = frame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 8)
logoCorner.Parent = logo

task.spawn(function()
	local success, result = pcall(function()
		local url = "https://files.catbox.moe/ec9zp5.png"
		local data = game:HttpGet(url)
		writefile("HazHubLogo.png", data)
		return getcustomasset("HazHubLogo.png")
	end)

	if success and result then
		logo.Image = result
	else
		logo.Image = "https://files.catbox.moe/ec9zp5.png"
	end
end)

local title = Instance.new("TextLabel")
title.Name = "Title"
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 72, 0, 14)
title.Size = UDim2.new(1, -88, 0, 28)
title.Font = Enum.Font.GothamBold
title.Text = "HAZHUB"
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

local madeBy = Instance.new("TextLabel")
madeBy.Name = "MadeBy"
madeBy.BackgroundTransparency = 1
madeBy.Position = UDim2.new(0, 72, 0, 42)
madeBy.Size = UDim2.new(1, -88, 0, 18)
madeBy.Font = Enum.Font.Gotham
madeBy.Text = "made by h_a_z_z_a."
madeBy.TextSize = 14
madeBy.TextXAlignment = Enum.TextXAlignment.Left
madeBy.TextColor3 = Color3.fromRGB(180, 150, 255)
madeBy.Parent = frame

local dc = Instance.new("TextButton")
dc.Name = "Discord"
dc.BackgroundTransparency = 1
dc.Position = UDim2.new(0, 72, 0, 64)
dc.Size = UDim2.new(1, -88, 0, 18)
dc.Font = Enum.Font.Gotham
dc.Text = "discord.gg/zvJT9MzJhx"
dc.TextSize = 13
dc.TextXAlignment = Enum.TextXAlignment.Left
dc.TextColor3 = Color3.fromRGB(160, 110, 255)
dc.AutoButtonColor = false
dc.Parent = frame

dc.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/zvJT9MzJhx")
		dc.Text = "copied 🥀"
		task.wait(1.4)
		dc.Text = "discord.gg/zvJT9MzJhx"
	end
end)

task.spawn(function()
	local hue = 0
	while title and title.Parent do
		hue = (hue + 0.008) % 1
		title.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
		task.wait(0.03)
	end
end)

-- higher now
TweenService:Create(frame, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, 0, 1, -52)
}):Play()