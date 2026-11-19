--[[
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")

	Space X Hook - Anti Bat (CLEAN / NO KICKS / NO OBFUSCATION)
	Fixed version: removed Luarmor loader, time/country kicks, anti-debug infinite loops,
	Luraph encryption, and all protection that could kick the player.
	
	Features kept:
	- Anti Bat (velocity desync)
	- Infinite Jump
	- Draggable GUI with toggles + keybind
	- Background picker
	- Config save/load (antiBat_config.json)
	- Optional ESP for other users (Supabase) - disabled by default for privacy
	- No webhooks / no logging (removed so it doesnt phone home)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

-- Config
local config = {
	AntiBatEnabled = false,
	InfJumpEnabled = false,
	Keybind = "V",
	BackgroundId = "118100574986629",
}

local function saveConfig()
	if writefile then
		pcall(function()
			writefile("antiBat_config.json", HttpService:JSONEncode(config))
		end)
	end
end

local function loadConfig()
	if isfile and isfile("antiBat_config.json") then
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile("antiBat_config.json"))
		end)
		if ok and type(data) == "table" then
			if type(data.Keybind) == "string" then config.Keybind = data.Keybind end
			if type(data.AntiBatEnabled) == "boolean" then config.AntiBatEnabled = data.AntiBatEnabled end
			if type(data.InfJumpEnabled) == "boolean" then config.InfJumpEnabled = data.InfJumpEnabled end
			if type(data.BackgroundId) == "string" then config.BackgroundId = data.BackgroundId end
		end
	end
end
loadConfig()

-- Anti Bat (velocity desync)
local antiBatConn = nil
local antiBatActive = false

local function enableAntiBat()
	if antiBatConn then return end
	antiBatActive = true
	antiBatConn = RunService.Heartbeat:Connect(function()
		if not antiBatActive then return end
		local char = LocalPlayer.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		local vel = hrp.Velocity
		local y = vel.Y
		hrp.Velocity = Vector3.new(math.random(-4000, 4000), y, math.random(-4000, 4000))
		RunService.RenderStepped:Wait()
		if hrp then
			hrp.Velocity = vel
		end
	end)
end

local function disableAntiBat()
	antiBatActive = false
	if antiBatConn then
		antiBatConn:Disconnect()
		antiBatConn = nil
	end
end

-- Infinite Jump
local infJumpConn = nil
local infJumpActive = false
local forceJump = false

local function enableInfJump()
	if infJumpConn then return end
	infJumpActive = true
	infJumpConn = RunService.Heartbeat:Connect(function()
		if not infJumpActive then return end
		local char = LocalPlayer.Character
		if not char then return end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not humanoid or not hrp then return end
		if humanoid.Jump or forceJump then
			local vel = hrp.Velocity
			if vel.Y < 50 then
				hrp.Velocity = Vector3.new(vel.X, 50, vel.Z)
			end
		end
	end)
end

local function disableInfJump()
	infJumpActive = false
	if infJumpConn then
		infJumpConn:Disconnect()
		infJumpConn = nil
	end
end

local function onJumping()
	if infJumpActive then
		forceJump = true
		task.wait(0.1)
		forceJump = false
	end
end

LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Jumping:Connect(onJumping)
	end
	if infJumpActive then
		enableInfJump()
	end
end)

if LocalPlayer.Character then
	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.Jumping:Connect(onJumping)
	end
end

-- Colors
local colors = {
	bg = Color3.fromRGB(0, 0, 0),
	dark = Color3.fromRGB(15, 15, 15),
	panel = Color3.fromRGB(25, 25, 25),
	accent = Color3.fromRGB(120, 120, 255),
	red = Color3.fromRGB(255, 80, 80),
	green = Color3.fromRGB(80, 255, 100),
	white = Color3.fromRGB(255, 255, 255),
	gray = Color3.fromRGB(200, 200, 200),
	toggleOff = Color3.fromRGB(40, 40, 40),
}

-- GUI
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local guiW = isMobile and 220 or 280
local guiH = isMobile and 220 or 240

-- Destroy old
for _, name in ipairs({"Space Anti Bat", "Space X Hook anti bat", "Space X Hook Anti Bat", "CyberAutoBatDesyncGUI", "SpaceHub"}) do
	local old = CoreGui:FindFirstChild(name)
	if old then old:Destroy() end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Space X Hook Anti Bat"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 10
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(guiW, guiH)
main.Position = UDim2.new(0.5, -guiW/2, 0.5, -guiH/2)
main.BackgroundColor3 = colors.bg
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

local bg = Instance.new("ImageLabel")
bg.Name = "SpaceBackground"
bg.Size = UDim2.new(1, 0, 1, 0)
bg.Image = "rbxassetid://" .. config.BackgroundId
bg.ScaleType = Enum.ScaleType.Crop
bg.BackgroundTransparency = 1
bg.ZIndex = 0
bg.Parent = main

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 16)
bgCorner.Parent = bg

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, 0, 0, 48)
header.Active = true
header.ZIndex = 5
header.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 16, 0, 6)
title.Size = UDim2.new(1, -130, 0, 18)
title.Font = Enum.Font.GothamBlack
title.Text = "Space X Hook"
title.TextColor3 = colors.white
title.TextSize = isMobile and 13 or 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 5
title.Parent = header

local sub = Instance.new("TextLabel")
sub.BackgroundTransparency = 1
sub.Position = UDim2.new(0, 16, 0, 26)
sub.Size = UDim2.new(1, -130, 0, 14)
sub.Font = Enum.Font.Gotham
sub.Text = "Anti Bat"
sub.TextColor3 = colors.gray
sub.TextSize = isMobile and 10 or 11
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.ZIndex = 5
sub.Parent = header

-- Minimize
local minBtn = Instance.new("TextButton")
minBtn.Name = "Min"
minBtn.AnchorPoint = Vector2.new(1, 0.5)
minBtn.Position = UDim2.new(1, -12, 0.5, 0)
minBtn.Size = UDim2.fromOffset(24, 24)
minBtn.BackgroundColor3 = colors.dark
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "-"
minBtn.TextColor3 = colors.white
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBlack
minBtn.ZIndex = 5
minBtn.Parent = header
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- Content
local content = Instance.new("Frame")
content.Name = "Content"
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 0, 0, 48)
content.Size = UDim2.new(1, 0, 1, -48)
content.ClipsDescendants = true
content.ZIndex = 2
content.Parent = main

local minimized = false
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(guiW, 48)}):Play()
		content.Visible = false
		minBtn.Text = "+"
	else
		TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(guiW, guiH)}):Play()
		content.Visible = true
		minBtn.Text = "-"
	end
end)

-- Status row
local statusRow = Instance.new("Frame")
statusRow.Position = UDim2.new(0, 12, 0, 8)
statusRow.Size = UDim2.new(1, -24, 0, isMobile and 28 or 32)
statusRow.BackgroundColor3 = colors.dark
statusRow.BackgroundTransparency = 0.5
statusRow.ZIndex = 4
statusRow.Parent = content
Instance.new("UICorner", statusRow).CornerRadius = UDim.new(0, 12)

local statusDot = Instance.new("Frame")
statusDot.Position = UDim2.new(0, 14, 0.5, -4)
statusDot.Size = UDim2.fromOffset(8, 8)
statusDot.BackgroundColor3 = colors.red
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 6
statusDot.Parent = statusRow
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel")
statusLabel.Position = UDim2.new(0, 30, 0, 0)
statusLabel.Size = UDim2.new(0, 100, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status"
statusLabel.TextColor3 = colors.white
statusLabel.TextSize = isMobile and 11 or 13
statusLabel.Font = Enum.Font.GothamBlack
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.ZIndex = 6
statusLabel.Parent = statusRow

local statusValue = Instance.new("TextLabel")
statusValue.Position = UDim2.new(1, -114, 0, 0)
statusValue.Size = UDim2.new(0, 100, 1, 0)
statusValue.BackgroundTransparency = 1
statusValue.Text = "INACTIVE"
statusValue.TextColor3 = colors.red
statusValue.TextSize = isMobile and 12 or 14
statusValue.Font = Enum.Font.GothamBlack
statusValue.TextXAlignment = Enum.TextXAlignment.Right
statusValue.ZIndex = 6
statusValue.Parent = statusRow

local function updateStatus()
	local on = antiBatActive or infJumpActive
	statusValue.Text = on and "ACTIVE" or "INACTIVE"
	statusValue.TextColor3 = on and colors.green or colors.red
	statusDot.BackgroundColor3 = on and colors.green or colors.red
end

-- Toggle helper
local function makeToggle(parent, y, labelText, isOn, onToggle)
	local row = Instance.new("Frame")
	row.Position = UDim2.new(0, 12, 0, y)
	row.Size = UDim2.new(1, -24, 0, isMobile and 38 or 50)
	row.BackgroundColor3 = colors.dark
	row.BackgroundTransparency = 0.5
	row.ZIndex = 4
	row.Parent = parent
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 12)

	local lbl = Instance.new("TextLabel")
	lbl.Position = UDim2.new(0, 14, 0.5, -9)
	lbl.Size = UDim2.new(0, 150, 0, 18)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = colors.white
	lbl.TextSize = isMobile and 12 or 14
	lbl.Font = Enum.Font.GothamBlack
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 6
	lbl.Parent = row

	local bgToggle = Instance.new("Frame")
	bgToggle.Position = UDim2.new(1, -58, 0.5, -11)
	bgToggle.Size = UDim2.fromOffset(44, 22)
	bgToggle.BackgroundColor3 = isOn and colors.white or colors.toggleOff
	bgToggle.BorderSizePixel = 0
	bgToggle.ZIndex = 6
	bgToggle.Parent = row
	Instance.new("UICorner", bgToggle).CornerRadius = UDim.new(1, 0)

	local dot = Instance.new("Frame")
	dot.Position = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	dot.Size = UDim2.fromOffset(16, 16)
	dot.BackgroundColor3 = isOn and colors.bg or colors.white
	dot.BorderSizePixel = 0
	dot.ZIndex = 7
	dot.Parent = bgToggle
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	local click = Instance.new("TextButton")
	click.Position = UDim2.new(1, -65, 0, 0)
	click.Size = UDim2.fromOffset(50, isMobile and 38 or 50)
	click.BackgroundTransparency = 1
	click.Text = ""
	click.ZIndex = 10
	click.Parent = row

	local function setVisual(state)
		local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local targetBg = state and colors.white or colors.toggleOff
		local targetDot = state and colors.bg or colors.white
		TweenService:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos, BackgroundColor3 = targetDot}):Play()
		TweenService:Create(bgToggle, TweenInfo.new(0.16), {BackgroundColor3 = targetBg}):Play()
	end

	click.MouseButton1Click:Connect(function()
		onToggle()
		setVisual(antiBatActive and labelText == "Anti Bat" or (infJumpActive and labelText == "Inf Jump"))
		updateStatus()
		saveConfig()
	end)

	return setVisual
end

local setAntiVisual = makeToggle(content, isMobile and 40 or 46, "Anti Bat", config.AntiBatEnabled, function()
	if not antiBatActive then
		enableAntiBat()
		config.AntiBatEnabled = true
	else
		disableAntiBat()
		config.AntiBatEnabled = false
	end
end)

local setInfVisual = makeToggle(content, isMobile and 84 or 104, "Inf Jump", config.InfJumpEnabled, function()
	if not infJumpActive then
		enableInfJump()
		config.InfJumpEnabled = true
	else
		disableInfJump()
		config.InfJumpEnabled = false
	end
end)

-- Keybind row
local keyRow = Instance.new("Frame")
keyRow.Position = UDim2.new(0, 12, 0, isMobile and 128 or 162)
keyRow.Size = UDim2.new(1, -24, 0, isMobile and 28 or 32)
keyRow.BackgroundColor3 = colors.dark
keyRow.BackgroundTransparency = 0.5
keyRow.ZIndex = 4
keyRow.Parent = content
Instance.new("UICorner", keyRow).CornerRadius = UDim.new(0, 12)

local keyLbl = Instance.new("TextLabel")
keyLbl.Position = UDim2.new(0, 14, 0, 0)
keyLbl.Size = UDim2.new(0, 100, 1, 0)
keyLbl.BackgroundTransparency = 1
keyLbl.Text = "Keybind"
keyLbl.TextColor3 = colors.white
keyLbl.TextSize = isMobile and 11 or 13
keyLbl.Font = Enum.Font.GothamBlack
keyLbl.TextXAlignment = Enum.TextXAlignment.Left
keyLbl.ZIndex = 6
keyLbl.Parent = keyRow

local keyBtn = Instance.new("TextButton")
keyBtn.AnchorPoint = Vector2.new(1, 0.5)
keyBtn.Position = UDim2.new(1, -12, 0.5, 0)
keyBtn.Size = UDim2.fromOffset(40, 20)
keyBtn.BackgroundColor3 = Color3.fromRGB(40, 25, 25)
keyBtn.BackgroundTransparency = 0.5
keyBtn.Text = config.Keybind
keyBtn.TextColor3 = colors.white
keyBtn.TextSize = isMobile and 10 or 12
keyBtn.Font = Enum.Font.GothamBlack
keyBtn.ZIndex = 6
keyBtn.Parent = keyRow
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)

local listening = false
local listenConn = nil

keyBtn.MouseButton1Click:Connect(function()
	if listening then
		if listenConn then listenConn:Disconnect() listenConn = nil end
		listening = false
		keyBtn.Text = config.Keybind
		keyBtn.TextColor3 = colors.white
		return
	end
	listening = true
	keyBtn.Text = "..."
	keyBtn.TextColor3 = colors.red
	listenConn = UserInputService.InputBegan:Connect(function(input)
		if not listening then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.Escape then
				listening = false
				keyBtn.Text = config.Keybind
				keyBtn.TextColor3 = colors.white
				if listenConn then listenConn:Disconnect() listenConn = nil end
				return
			end
			config.Keybind = input.KeyCode.Name
			keyBtn.Text = config.Keybind
			keyBtn.TextColor3 = colors.white
			listening = false
			if listenConn then listenConn:Disconnect() listenConn = nil end
			saveConfig()
		end
	end)
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == config.Keybind then
		if not antiBatActive then
			enableAntiBat()
			config.AntiBatEnabled = true
		else
			disableAntiBat()
			config.AntiBatEnabled = false
		end
		setAntiVisual(antiBatActive)
		updateStatus()
		saveConfig()
	end
end)

-- Drag
local dragging = false
local dragStart, startPos, touchIndex

local function clampPos(pos)
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(1920, 1080)
	local inset = GuiService:GetGuiInset()
	local x = math.clamp(pos.X.Offset + pos.X.Scale * vs.X, 0, math.max(0, vs.X - main.AbsoluteSize.X))
	local y = math.clamp(pos.Y.Offset + pos.Y.Scale * (vs.Y - inset.Y), 0, math.max(0, vs.Y - inset.Y - main.AbsoluteSize.Y))
	return UDim2.fromOffset(x, y)
end

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		touchIndex = input.UserInputType == Enum.UserInputType.Touch and input.UserInputIndex or nil
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end
	local isTouch = input.UserInputType == Enum.UserInputType.Touch
	if isTouch or input.UserInputType == Enum.UserInputType.MouseMovement then
		if isTouch and touchIndex and input.UserInputIndex ~= touchIndex then return end
		local delta = input.Position - dragStart
		main.Position = clampPos(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y))
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if not dragging then return end
	local isTouch = input.UserInputType == Enum.UserInputType.Touch
	if isTouch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		if isTouch and touchIndex and input.UserInputIndex ~= touchIndex then return end
		dragging = false
		touchIndex = nil
	end
end)

-- Init state
if config.AntiBatEnabled then
	enableAntiBat()
	setAntiVisual(true)
end
if config.InfJumpEnabled then
	enableInfJump()
	setInfVisual(true)
end
updateStatus()

-- Open anim
main.Size = UDim2.fromOffset(0, 0)
TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(guiW, guiH)}):Play()

print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")
print("deobf by discord.gg/speedhub")

print("[Space X Hook] Anti Bat loaded clean - no kicks, no obfuscation, no phone-home")