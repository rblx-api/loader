-- // BLINDER HUB BYPASS â€” By @BlinderDev //
-- // Services //
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- // Player + State //
local lp = Players.LocalPlayer
local isActive = false
local toggleKey = Enum.KeyCode.E
local capturingKey = false
local boostValue = 300000
local delayTime = 0.12
local lagConnection = nil

-- // Map boost to delay //
local function setBoost(val)
	boostValue = math.clamp(val, 10000, 500000)
	local ratio = (boostValue - 10000) / 490000
	delayTime = ratio * 0.2
end

setBoost(boostValue)

-- // Start / stop //
local function beginLag()
	if lagConnection then lagConnection:Disconnect() end

	lagConnection = RunService.RenderStepped:Connect(function()
		if not isActive then return end
		if delayTime > 0 then
			local t = tick()
			while tick() - t < delayTime do end
		end
	end)
end

local function endLag()
	isActive = false
	if lagConnection then lagConnection:Disconnect(); lagConnection = nil end
end

-- // Cleanup old GUI //
for _, obj in ipairs(CoreGui:GetChildren()) do
	if obj.Name == "BH_BypassPanel" then
		obj:Destroy()
	end
end

-- // ScreenGui //
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BH_BypassPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- // Main panel (dark card style) //
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 260, 0, 0)
panel.Position = UDim2.new(0.5, -130, 0.5, -180)
panel.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
panel.BackgroundTransparency = 0.05
panel.BorderSizePixel = 0
panel.Active = true
panel.Draggable = true
panel.ClipsDescendants = true
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0, 16)

local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 1.5
panelStroke.Color = Color3.fromRGB(200, 0, 0)
panelStroke.Transparency = 0.3
panelStroke.Parent = panel

-- // Intro animation //
TweenService:Create(panel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 260, 0, 360)
}):Play()

-- // Header bar //
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 44)
header.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
header.BorderSizePixel = 0
header.Parent = panel

Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 20)
headerFix.Position = UDim2.new(0, 0, 0, 24)
headerFix.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

local headerText = Instance.new("TextLabel")
headerText.Size = UDim2.new(1, 0, 1, 0)
headerText.BackgroundTransparency = 1
headerText.Text = "BLINDER HUB"
headerText.TextColor3 = Color3.new(1, 1, 1)
headerText.Font = Enum.Font.GothamBlack
headerText.TextSize = 16
headerText.Parent = header

-- // Divider line //
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0.85, 0, 0, 1)
divider.Position = UDim2.new(0.075, 0, 0, 60)
divider.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
divider.BorderSizePixel = 0
divider.Parent = panel

-- // Boost label //
local boostLabel = Instance.new("TextLabel")
boostLabel.Size = UDim2.new(0.85, 0, 0, 18)
boostLabel.Position = UDim2.new(0.075, 0, 0, 72)
boostLabel.BackgroundTransparency = 1
boostLabel.Text = "BOOST STRENGTH (10K - 500K)"
boostLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
boostLabel.Font = Enum.Font.GothamBold
boostLabel.TextSize = 10
boostLabel.TextXAlignment = Enum.TextXAlignment.Left
boostLabel.Parent = panel

-- // Boost input //
local boostInput = Instance.new("TextBox")
boostInput.Size = UDim2.new(0.85, 0, 0, 42)
boostInput.Position = UDim2.new(0.075, 0, 0, 94)
boostInput.BackgroundColor3 = Color3.fromRGB(18, 0, 0)
boostInput.Text = tostring(boostValue)
boostInput.TextColor3 = Color3.new(1, 1, 1)
boostInput.Font = Enum.Font.GothamBold
boostInput.TextSize = 15
boostInput.BorderSizePixel = 0
boostInput.ClearTextOnFocus = false
boostInput.Parent = panel

local inputCorner = Instance.new("UICorner", boostInput)
inputCorner.CornerRadius = UDim.new(0, 10)

local inputStroke = Instance.new("UIStroke")
inputStroke.Thickness = 1
inputStroke.Color = Color3.fromRGB(120, 0, 0)
inputStroke.Parent = boostInput

boostInput.FocusLost:Connect(function()
	local val = tonumber(boostInput.Text)
	if val then
		setBoost(val)
		boostInput.Text = tostring(boostValue)
	else
		boostInput.Text = tostring(boostValue)
	end
end)

-- // Divider 2 //
local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(0.85, 0, 0, 1)
divider2.Position = UDim2.new(0.075, 0, 0, 152)
divider2.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
divider2.BorderSizePixel = 0
divider2.Parent = panel

-- // Keybind label //
local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0.85, 0, 0, 18)
keyLabel.Position = UDim2.new(0.075, 0, 0, 164)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "TOGGLE KEYBIND"
keyLabel.TextColor3 = Color3.fromRGB(220, 50, 50)
keyLabel.Font = Enum.Font.GothamBold
keyLabel.TextSize = 10
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.Parent = panel

-- // Keybind button //
local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(0.85, 0, 0, 42)
keyBtn.Position = UDim2.new(0.075, 0, 0, 186)
keyBtn.BackgroundColor3 = Color3.fromRGB(18, 0, 0)
keyBtn.Text = "E"
keyBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
keyBtn.Font = Enum.Font.GothamBlack
keyBtn.TextSize = 15
keyBtn.BorderSizePixel = 0
keyBtn.AutoButtonColor = false
keyBtn.Parent = panel

local keyCorner = Instance.new("UICorner", keyBtn)
keyCorner.CornerRadius = UDim.new(0, 10)

local keyStroke = Instance.new("UIStroke")
keyStroke.Thickness = 1
keyStroke.Color = Color3.fromRGB(120, 0, 0)
keyStroke.Parent = keyBtn

keyBtn.MouseButton1Click:Connect(function()
	capturingKey = true
	keyBtn.Text = "PRESS A KEY..."
	keyBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
end)

-- // Divider 3 //
local divider3 = Instance.new("Frame")
divider3.Size = UDim2.new(0.85, 0, 0, 1)
divider3.Position = UDim2.new(0.075, 0, 0, 244)
divider3.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
divider3.BorderSizePixel = 0
divider3.Parent = panel

-- // Status indicator dot //
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(0.075, 0, 0, 264)
statusDot.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
statusDot.BorderSizePixel = 0
statusDot.Parent = panel

local dotCorner = Instance.new("UICorner", statusDot)
dotCorner.CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.7, 0, 0, 18)
statusLabel.Position = UDim2.new(0.075, 20, 0, 260)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "OFFLINE"
statusLabel.TextColor3 = Color3.fromRGB(120, 0, 0)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 11
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = panel

-- // Main toggle button //
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.85, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.075, 0, 0, 290)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
toggleBtn.Text = "ENABLE BYPASS"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBlack
toggleBtn.TextSize = 14
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = panel

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 12)

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1.5
toggleStroke.Color = Color3.fromRGB(100, 0, 0)
toggleStroke.Parent = toggleBtn

-- // Toggle logic //
local function toggleBypass()
	if not isActive then
		isActive = true
		toggleBtn.Text = "DISABLE BYPASS"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
		toggleStroke.Color = Color3.fromRGB(255, 50, 50)
		statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
		statusLabel.Text = "ACTIVE"
		statusLabel.TextColor3 = Color3.fromRGB(0, 255, 80)
		beginLag()
	else
		endLag()
		toggleBtn.Text = "ENABLE BYPASS"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
		toggleStroke.Color = Color3.fromRGB(100, 0, 0)
		statusDot.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
		statusLabel.Text = "OFFLINE"
		statusLabel.TextColor3 = Color3.fromRGB(120, 0, 0)
	end
end

toggleBtn.MouseButton1Click:Connect(toggleBypass)

-- // Input handler //
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if capturingKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			toggleKey = input.KeyCode
			keyBtn.Text = toggleKey.Name
			keyBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
			capturingKey = false
		end
		return
	end
	if input.KeyCode == toggleKey then
		toggleBypass()
	end
end)

-- // Respawn handler //
lp.CharacterAdded:Connect(function()
	task.wait(1)
	if isActive then
		endLag()
		isActive = true
		beginLag()
	end
end)

-- // End //