local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local CONFIG_FILE = "OrsPacket_Config.json"

-- ===== BLACK & WHITE THEME =====
local ACCENT  = Color3.fromRGB(255, 255, 255)
local NAVY    = Color3.fromRGB(0, 0, 0)
local PANEL   = Color3.fromRGB(15, 15, 15)
local INPUT   = Color3.fromRGB(28, 28, 28)
local BTN     = Color3.fromRGB(48, 48, 48)
local WHITE   = Color3.fromRGB(255, 255, 255)
local DIM     = Color3.fromRGB(165, 165, 165)

local function corner(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
	return c
end

local function stroke(o, col, th, tr)
	local s = Instance.new("UIStroke")
	s.Color = col
	s.Thickness = th or 1
	s.Transparency = tr or 0.2
	s.Parent = o
	return s
end

local function label(parent, text, x, y, w, size, color, font)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Position = UDim2.fromOffset(x, y)
	l.Size = w
	l.Text = text
	l.Font = font or Enum.Font.GothamBold
	l.TextSize = size
	l.TextColor3 = color
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextScaled = true
	l.ZIndex = 3
	l.Parent = parent
	return l
end

local function smallBtn(parent, text, pos, size)
	local b = Instance.new("TextButton")
	b.Size = size or UDim2.fromOffset(22, 22)
	b.Position = pos
	b.BackgroundColor3 = INPUT
	b.BackgroundTransparency = 0.3
	b.Text = text
	b.Font = Enum.Font.GothamBlack
	b.TextSize = 13
	b.TextColor3 = WHITE
	b.AutoButtonColor = false
	b.ZIndex = 4
	b.Parent = parent
	corner(b, 6)
	return b
end

-- Cleanup
pcall(function()
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		for _, n in ipairs({"OrsPacketLagger", "BlindPacketLagger"}) do
			local old = pg:FindFirstChild(n)
			if old then old:Destroy() end
		end
	end
	if gethui then
		for _, g in ipairs(gethui():GetChildren()) do
			if g.Name == "OrsPacketLagger" then g:Destroy() end
		end
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "OrsPacketLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
pcall(function() if gethui then gui.Parent = gethui() end end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

-- ===== DIMENSIONI FISSE =====
local W = 260
local H = 130
local collapsedH = 88

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(W, H)
Main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
Main.BackgroundColor3 = NAVY
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = gui
corner(Main, 14)
stroke(Main, ACCENT, 1.2, 0.55)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1
header.ZIndex = 2
header.Parent = Main

-- Avatar
local Avatar = Instance.new("TextButton")
Avatar.Size = UDim2.fromOffset(32, 32)
Avatar.Position = UDim2.fromOffset(12, 9)
Avatar.BackgroundColor3 = BTN
Avatar.Text = "V"
Avatar.Font = Enum.Font.GothamBlack
Avatar.TextSize = 15
Avatar.TextColor3 = WHITE
Avatar.AutoButtonColor = false
Avatar.ZIndex = 3
Avatar.Parent = header
corner(Avatar, 16)
stroke(Avatar, ACCENT, 1.5, 0.2)

local Title = label(header, "OR´S PACKET LAGGER", 52, 10, UDim2.new(1, -112, 0, 16), 14, WHITE, Enum.Font.GothamBlack)
local SubTitle = label(header, "packet lagger", 52, 27, UDim2.new(1, -112, 0, 13), 10, DIM, Enum.Font.GothamMedium)

local gearBtn  = smallBtn(header, "⚙", UDim2.new(1, -56, 0, 14))
local minBtn   = smallBtn(header, "−", UDim2.new(1, -30, 0, 14))
for _, b in ipairs({gearBtn, minBtn}) do b.BackgroundTransparency = 1 end

-- Activate
local StartBtn = Instance.new("TextButton")
StartBtn.Position = UDim2.fromOffset(12, 50)
StartBtn.Size = UDim2.new(1, -24, 0, 34)
StartBtn.BackgroundColor3 = BTN
StartBtn.Text = "ACTIVATE"
StartBtn.Font = Enum.Font.GothamBlack
StartBtn.TextSize = 15
StartBtn.TextColor3 = WHITE
StartBtn.AutoButtonColor = false
StartBtn.ZIndex = 3
StartBtn.Parent = Main
corner(StartBtn, 10)
stroke(StartBtn, ACCENT, 1, 0.4)

-- Keybind
local keyLbl = label(Main, "Keybind", 14, 92, UDim2.fromOffset(80, 22), 12, WHITE)
local KeyBtn = Instance.new("TextButton")
KeyBtn.Position = UDim2.new(1, -86, 0, 92)
KeyBtn.Size = UDim2.fromOffset(46, 22)
KeyBtn.BackgroundColor3 = BTN
KeyBtn.Text = "V"
KeyBtn.Font = Enum.Font.GothamBlack
KeyBtn.TextSize = 13
KeyBtn.TextColor3 = WHITE
KeyBtn.AutoButtonColor = false
KeyBtn.ZIndex = 3
KeyBtn.Parent = Main
corner(KeyBtn, 7)

-- Divider
local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.fromOffset(12, 120)
divider.BackgroundColor3 = DIM
divider.BackgroundTransparency = 0.75
divider.BorderSizePixel = 0
divider.ZIndex = 3
divider.Parent = Main

-- ===================== SETTINGS =====================
local SW, SH = 260, 155   -- aumentamos altura para los botones Mobile/PC
local Settings = Instance.new("Frame")
Settings.Name = "Settings"
Settings.Size = UDim2.fromOffset(SW, SH)
Settings.BackgroundColor3 = NAVY
Settings.BorderSizePixel = 0
Settings.Visible = false
Settings.Active = true
Settings.ZIndex = 10
Settings.Parent = gui
corner(Settings, 14)
stroke(Settings, ACCENT, 1.2, 0.55)

local sTitle = label(Settings, "SETTINGS", 14, 10, UDim2.new(1, -28, 0, 16), 13, WHITE, Enum.Font.GothamBlack)
sTitle.ZIndex = 11

-- Power
local powerLbl = label(Settings, "Power", 14, 40, UDim2.fromOffset(80, 26), 12, WHITE)
powerLbl.ZIndex = 11

local powerRow = Instance.new("Frame")
powerRow.Size = UDim2.fromOffset(110, 26)
powerRow.Position = UDim2.new(1, -122, 0, 40)
powerRow.BackgroundColor3 = INPUT
powerRow.BackgroundTransparency = 0.3
powerRow.ZIndex = 11
powerRow.Parent = Settings
corner(powerRow, 7)

local minusBtn = smallBtn(powerRow, "-", UDim2.fromOffset(2, 2))
local plusBtn  = smallBtn(powerRow, "+", UDim2.new(1, -24, 0, 2))
minusBtn.ZIndex = 12; plusBtn.ZIndex = 12
minusBtn.BackgroundColor3 = BTN; plusBtn.BackgroundColor3 = BTN

local PowerBox = Instance.new("TextBox")
PowerBox.Position = UDim2.fromOffset(26, 0)
PowerBox.Size = UDim2.new(1, -52, 1, 0)
PowerBox.BackgroundTransparency = 1
PowerBox.Text = "15000"
PowerBox.Font = Enum.Font.GothamBlack
PowerBox.TextSize = 13
PowerBox.TextColor3 = WHITE
PowerBox.TextXAlignment = Enum.TextXAlignment.Center
PowerBox.ClearTextOnFocus = false
PowerBox.ZIndex = 12
PowerBox.Parent = powerRow

-- ===== BOTONES MOBILE / PC =====
local mobileBtn = Instance.new("TextButton")
mobileBtn.Size = UDim2.fromOffset(110, 24)
mobileBtn.Position = UDim2.fromOffset(14, 74)
mobileBtn.BackgroundColor3 = BTN
mobileBtn.Text = "MOBILE"
mobileBtn.Font = Enum.Font.GothamBlack
mobileBtn.TextSize = 12
mobileBtn.TextColor3 = WHITE
mobileBtn.AutoButtonColor = false
mobileBtn.ZIndex = 11
mobileBtn.Parent = Settings
corner(mobileBtn, 7)
stroke(mobileBtn, ACCENT, 1, 0.5)

local pcBtn = Instance.new("TextButton")
pcBtn.Size = UDim2.fromOffset(110, 24)
pcBtn.Position = UDim2.new(1, -124, 0, 74)
pcBtn.BackgroundColor3 = BTN
pcBtn.Text = "PC"
pcBtn.Font = Enum.Font.GothamBlack
pcBtn.TextSize = 12
pcBtn.TextColor3 = WHITE
pcBtn.AutoButtonColor = false
pcBtn.ZIndex = 11
pcBtn.Parent = Settings
corner(pcBtn, 7)
stroke(pcBtn, ACCENT, 1, 0.5)

-- Active On Steal
local stealLbl = label(Settings, "Active On Steal", 14, 110, UDim2.fromOffset(140, 26), 12, WHITE)
stealLbl.ZIndex = 11

local activeOnSteal = false
local stealTrack = Instance.new("TextButton")
stealTrack.Size = UDim2.fromOffset(38, 20)
stealTrack.Position = UDim2.new(1, -52, 0, 113)
stealTrack.BackgroundColor3 = INPUT
stealTrack.Text = ""
stealTrack.AutoButtonColor = false
stealTrack.ZIndex = 11
stealTrack.Parent = Settings
corner(stealTrack, 10)

local stealKnob = Instance.new("Frame")
stealKnob.Size = UDim2.fromOffset(16, 16)
stealKnob.Position = UDim2.fromOffset(2, 2)
stealKnob.BackgroundColor3 = WHITE
stealKnob.ZIndex = 12
stealKnob.Parent = stealTrack
corner(stealKnob, 8)

local function paintSteal()
	TweenService:Create(stealKnob, TweenInfo.new(0.15), {
		Position = activeOnSteal and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2),
		BackgroundColor3 = activeOnSteal and NAVY or WHITE,
	}):Play()
	stealTrack.BackgroundColor3 = activeOnSteal and ACCENT or INPUT
end

-- Size helpers
local isCollapsed = false
local function applySize()
	Main.Size = UDim2.fromOffset(W, isCollapsed and collapsedH or H)
end

local function openSettings()
	Settings.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset + W + 10, Main.Position.Y.Scale, Main.Position.Y.Offset)
	Settings.Visible = not Settings.Visible
end

Avatar.MouseButton1Click:Connect(openSettings)
gearBtn.MouseButton1Click:Connect(openSettings)

-- State
local lagging = false
local lagThread = nil
local intensity = 15000
local toggleKey = Enum.KeyCode.V
local toggleKeyName = "V"
local listeningForKey = false
local Event

-- LOGICA PACKET (kids[6])
do
	local ok, net = pcall(function()
		local pkgs = RS:WaitForChild("Packages", 5)
		return pkgs and pkgs:WaitForChild("Net", 5)
	end)
	if ok and net then
		local kids = net:GetChildren()
		Event = kids[6]
	end
end

local function setElementsVisible(visible)
	local elements = {keyLbl, KeyBtn, divider}
	for _, el in ipairs(elements) do
		el.Visible = visible
	end
end

local function clampPower(v)
	v = tonumber(v)
	if not v then return intensity end
	return math.clamp(math.floor(v), 1000, 1000000)
end

local function updatePower()
	intensity = clampPower(PowerBox.Text)
	PowerBox.Text = tostring(intensity)
end

local function applyKeybind(name)
	toggleKeyName = name or "V"
	local ok, key = pcall(function() return Enum.KeyCode[toggleKeyName] end)
	toggleKey = (ok and key) or Enum.KeyCode.V
	KeyBtn.Text = toggleKeyName
end

local function paintActivate()
	if lagging then
		StartBtn.Text = "DEACTIVATE"
		StartBtn.BackgroundColor3 = WHITE
		StartBtn.TextColor3 = NAVY
	else
		StartBtn.Text = "ACTIVATE"
		StartBtn.BackgroundColor3 = BTN
		StartBtn.TextColor3 = WHITE
	end
end

local function startLagging()
	if lagging then return end
	updatePower()
	lagging = true
	paintActivate()
	
	local payload = table.create(intensity, function() end) 
	
	lagThread = task.spawn(function()
		while lagging do
			if Event then 
				pcall(function() Event:FireServer(payload) end) 
			end
			task.wait(0.05) 
		end
	end)
end

local function stopLagging()
	if not lagging then return end
	lagging = false
	if lagThread then pcall(task.cancel, lagThread); lagThread = nil end
	paintActivate()
end

-- ===== SAVE / LOAD UNIFICADO (ya no se pisan) =====
local function saveAll()
	updatePower()
	pcall(function()
		if not writefile then return end
		local cfg = {
			Power = intensity,
			Keybind = toggleKeyName,
			ActiveOnSteal = activeOnSteal,
			Collapsed = isCollapsed,
			MainPosition = {
				XScale = Main.Position.X.Scale,
				XOffset = Main.Position.X.Offset,
				YScale = Main.Position.Y.Scale,
				YOffset = Main.Position.Y.Offset
			},
			SettingsVisible = Settings.Visible,
		}
		writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
	end)
end

local function loadAll()
	pcall(function()
		if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
		local ok, cfg = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
		if not (ok and type(cfg) == "table") then return end

		-- Power
		if tonumber(cfg.Power) then
			intensity = clampPower(cfg.Power)
			PowerBox.Text = tostring(intensity)
		end

		-- Keybind
		if type(cfg.Keybind) == "string" and cfg.Keybind ~= "" then
			applyKeybind(cfg.Keybind)
		end

		-- ActiveOnSteal
		if type(cfg.ActiveOnSteal) == "boolean" then
			activeOnSteal = cfg.ActiveOnSteal
			paintSteal()
		end

		-- Layout
		if type(cfg.Collapsed) == "boolean" then
			isCollapsed = cfg.Collapsed
			setElementsVisible(not isCollapsed)
			minBtn.Text = isCollapsed and "+" or "−"
		end
		applySize()

		if type(cfg.MainPosition) == "table" then
			local p = cfg.MainPosition
			Main.Position = UDim2.new(p.XScale or 0.5, p.XOffset or -W/2, p.YScale or 0.5, p.YOffset or -H/2)
		end

		Settings.Visible = cfg.SettingsVisible == true
	end)
end

-- Connections
minusBtn.MouseButton1Click:Connect(function()
	intensity = clampPower(intensity - 1000)
	PowerBox.Text = tostring(intensity)
	saveAll()
end)

plusBtn.MouseButton1Click:Connect(function()
	intensity = clampPower(intensity + 1000)
	PowerBox.Text = tostring(intensity)
	saveAll()
end)

PowerBox.FocusLost:Connect(function()
	updatePower()
	saveAll()
end)

-- Botones Mobile / PC
mobileBtn.MouseButton1Click:Connect(function()
	intensity = 60000
	PowerBox.Text = "60000"
	saveAll()
end)

pcBtn.MouseButton1Click:Connect(function()
	intensity = 120000
	PowerBox.Text = "120000"
	saveAll()
end)

StartBtn.MouseButton1Click:Connect(function()
	if lagging then stopLagging() else startLagging() end
end)

KeyBtn.MouseButton1Click:Connect(function()
	listeningForKey = true
	KeyBtn.Text = "..."
end)

stealTrack.MouseButton1Click:Connect(function()
	activeOnSteal = not activeOnSteal
	paintSteal()
	saveAll()
end)

-- Minimize
minBtn.MouseButton1Click:Connect(function()
	isCollapsed = not isCollapsed
	if isCollapsed then
		minBtn.Text = "+"
		setElementsVisible(false)
		TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
			Size = UDim2.fromOffset(W, collapsedH)
		}):Play()
	else
		minBtn.Text = "−"
		TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
			Size = UDim2.fromOffset(W, H)
		}):Play()
		task.delay(0.15, function() setElementsVisible(true) end)
	end
	saveAll()
end)

UIS.InputBegan:Connect(function(input, gpe)
	if listeningForKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			listeningForKey = false
			applyKeybind(input.KeyCode.Name)
			saveAll()
		end
		return
	end
	if gpe then return end
	if input.KeyCode == toggleKey then
		if lagging then stopLagging() else startLagging() end
	end
end)

-- Drag
local function makeDrag(handle, target)
	local dragging, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			task.defer(saveAll)
		end
	end)
end

makeDrag(header, Main)
makeDrag(Settings, Settings)

-- Carga inicial
task.defer(function()
	loadAll()
	paintActivate()
	paintSteal()
end)

-- Auto-save cada 2 segundos
task.spawn(function()
	while gui.Parent do
		task.wait(2)
		task.defer(saveAll)
	end
end)

gui.Destroying:Connect(saveAll)