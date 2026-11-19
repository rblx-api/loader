-- // Y78 PACKET LAGGET — lag core sealed, UI rebuilt
-- // 1 (Services)
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

-- // 2 (Player + state)
local lp            = Players.LocalPlayer
local activated     = false
local keybind       = Enum.KeyCode.E
local waitingForKey = false
local power         = 300000
local lagAmount     = 0.9
local lagConn       = nil
local isLocked      = false
local isMinimized   = false

-- // 3 (Map power to lag amount) — ORIGINAL, untouched
local function applyPower(val)
	power = math.clamp(val, 10000, 500000)
	local t = (power - 10000) / 490000
	lagAmount = t * 0.5
end

applyPower(power)

-- // 4 (Start / stop lag) — ORIGINAL, untouched
local function startLag()
	if lagConn then lagConn:Disconnect() end

	lagConn = RunService.RenderStepped:Connect(function()
		if not activated then return end
		if lagAmount > 0 then
			local t = tick()
			while tick() - t < lagAmount do end
		end
	end)
end

local function stopLag()
	activated = false
	if lagConn then lagConn:Disconnect(); lagConn = nil end
end

-- // 5 (Cleanup)
if CoreGui:FindFirstChild("Y78Bypass") then
	CoreGui.Y78Bypass:Destroy()
end

-- // 6 (ScreenGui)
local gui = Instance.new("ScreenGui")
gui.Name = "Y78Bypass"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

-- // 7 (Main frame)
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 180, 0, 0)
main.Position = UDim2.new(0.5, -90, 0.5, -105)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 48)
mainStroke.Thickness = 1
mainStroke.Transparency = 0.35
mainStroke.Parent = main

-- Background image
local bg = Instance.new("ImageLabel")
bg.Name = "BG"
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Position = UDim2.new(0, 0, 0, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://105897837102980"
bg.ScaleType = Enum.ScaleType.Crop
bg.ZIndex = 0
bg.Parent = main

Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 14)

-- Dark overlay so text stays readable
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
overlay.BackgroundTransparency = 0.55
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = main

Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 14)

TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {
	Size = UDim2.new(0, 180, 0, 210)
}):Play()

-- // 8 (Header)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundTransparency = 1
header.ZIndex = 2
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 14, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Y78 PACKET LAGGET"
title.TextColor3 = Color3.fromRGB(230, 230, 240)
title.Font = Enum.Font.GothamMedium
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3
title.Parent = header

-- Lock toggle
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 22, 0, 22)
lockBtn.Position = UDim2.new(1, -54, 0.5, -11)
lockBtn.BackgroundTransparency = 1
lockBtn.Text = "🔓"
lockBtn.TextSize = 14
lockBtn.ZIndex = 3
lockBtn.Parent = header

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -28, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.BorderSizePixel = 0
minBtn.AutoButtonColor = false
minBtn.ZIndex = 3
minBtn.Parent = header

Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

-- // 9 (Content)
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -24, 1, -48)
content.Position = UDim2.new(0, 12, 0, 40)
content.BackgroundTransparency = 1
content.ZIndex = 2
content.Parent = main

-- // 10 (Keybind row)
local kbRow = Instance.new("Frame")
kbRow.Size = UDim2.new(1, 0, 0, 32)
kbRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
kbRow.BackgroundTransparency = 0.35
kbRow.BorderSizePixel = 0
kbRow.ZIndex = 2
kbRow.Parent = content

Instance.new("UICorner", kbRow).CornerRadius = UDim.new(0, 8)

local kbLabel = Instance.new("TextLabel")
kbLabel.Size = UDim2.new(0.5, 0, 1, 0)
kbLabel.Position = UDim2.new(0, 12, 0, 0)
kbLabel.BackgroundTransparency = 1
kbLabel.Text = "Keybind"
kbLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
kbLabel.Font = Enum.Font.Gotham
kbLabel.TextSize = 12
kbLabel.TextXAlignment = Enum.TextXAlignment.Left
kbLabel.ZIndex = 3
kbLabel.Parent = kbRow

local kbBtn = Instance.new("TextButton")
kbBtn.Size = UDim2.new(0, 36, 0, 22)
kbBtn.Position = UDim2.new(1, -48, 0.5, -11)
kbBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
kbBtn.Text = "E"
kbBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
kbBtn.Font = Enum.Font.GothamBold
kbBtn.TextSize = 12
kbBtn.BorderSizePixel = 0
kbBtn.AutoButtonColor = false
kbBtn.ZIndex = 3
kbBtn.Parent = kbRow

Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0, 6)

kbBtn.MouseButton1Click:Connect(function()
	waitingForKey = true
	kbBtn.Text = "..."
	kbBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
end)

-- // 11 (Power row)
local powerRow = Instance.new("Frame")
powerRow.Size = UDim2.new(1, 0, 0, 32)
powerRow.Position = UDim2.new(0, 0, 0, 40)
powerRow.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
powerRow.BackgroundTransparency = 0.35
powerRow.BorderSizePixel = 0
powerRow.ZIndex = 2
powerRow.Parent = content

Instance.new("UICorner", powerRow).CornerRadius = UDim.new(0, 8)

local powerLabel = Instance.new("TextLabel")
powerLabel.Size = UDim2.new(0.5, 0, 1, 0)
powerLabel.Position = UDim2.new(0, 12, 0, 0)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "Power"
powerLabel.TextColor3 = Color3.fromRGB(160, 160, 175)
powerLabel.Font = Enum.Font.Gotham
powerLabel.TextSize = 12
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.ZIndex = 3
powerLabel.Parent = powerRow

local powerBox = Instance.new("TextBox")
powerBox.Size = UDim2.new(0, 64, 0, 22)
powerBox.Position = UDim2.new(1, -76, 0.5, -11)
powerBox.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
powerBox.Text = tostring(power)
powerBox.TextColor3 = Color3.fromRGB(210, 210, 220)
powerBox.Font = Enum.Font.GothamBold
powerBox.TextSize = 12
powerBox.BorderSizePixel = 0
powerBox.ClearTextOnFocus = false
powerBox.ZIndex = 3
powerBox.Parent = powerRow

Instance.new("UICorner", powerBox).CornerRadius = UDim.new(0, 6)

powerBox.FocusLost:Connect(function()
	local val = tonumber(powerBox.Text)
	if val then
		applyPower(val)
		powerBox.Text = tostring(power)
	else
		powerBox.Text = tostring(power)
	end
end)

-- // 12 (Toggle button)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 0, 36)
toggleBtn.Position = UDim2.new(0, 0, 1, -44)
toggleBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
toggleBtn.Text = "DISABLED"
toggleBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.ZIndex = 3
toggleBtn.Parent = content

Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 9)

local function setToggleVisual(on)
	if on then
		toggleBtn.Text = "ENABLED"
		toggleBtn.TextColor3 = Color3.fromRGB(40, 220, 140)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(22, 48, 36)
	else
		toggleBtn.Text = "DISABLED"
		toggleBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
		toggleBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
	end
end

-- // 13 (Toggle logic)
local function toggle()
	if not activated then
		activated = true
		setToggleVisual(true)
		startLag()
	else
		stopLag()
		setToggleVisual(false)
	end
end

toggleBtn.MouseButton1Click:Connect(toggle)

-- // Lock toggle
lockBtn.MouseButton1Click:Connect(function()
	isLocked = not isLocked
	if isLocked then
		lockBtn.Text = "🔒"
		main.Draggable = false
	else
		lockBtn.Text = "🔓"
		main.Draggable = true
	end
end)

-- // Minimize / expand
local function setMinimized(state)
	isMinimized = state
	if state then
		minBtn.Text = "+"
		kbRow.Visible = false
		powerRow.Visible = false
		content.Size = UDim2.new(1, -24, 0, 44)
		TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 180, 0, 92)
		}):Play()
	else
		minBtn.Text = "−"
		kbRow.Visible = true
		powerRow.Visible = true
		content.Size = UDim2.new(1, -24, 1, -48)
		TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 180, 0, 210)
		}):Play()
	end
end

minBtn.MouseButton1Click:Connect(function()
	setMinimized(not isMinimized)
end)

-- // 14 (Input listener)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if waitingForKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			keybind = input.KeyCode
			kbBtn.Text = keybind.Name
			kbBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
			waitingForKey = false
		end
		return
	end
	if input.KeyCode == keybind then
		toggle()
	end
end)

-- // 15 (Rainbow cycle)
local rainbowTargets = {
	title, kbLabel, kbBtn, powerLabel, powerBox, toggleBtn, minBtn
}

local hue = 0
RunService.RenderStepped:Connect(function()
	hue = (hue + 0.004) % 1
	local c = Color3.fromHSV(hue, 0.85, 1)
	for _, obj in ipairs(rainbowTargets) do
		if obj and obj.Parent then
			-- keep ENABLED green when active so status stays readable
			if obj == toggleBtn and activated then
				obj.TextColor3 = Color3.fromRGB(40, 220, 140)
			else
				obj.TextColor3 = c
			end
		end
	end
end)

-- // 16 (Re-apply on respawn)
lp.CharacterAdded:Connect(function()
	task.wait(1)
	if activated then
		stopLag()
		activated = true
		startLag()
		setToggleVisual(true)
	end
end)

-- // End