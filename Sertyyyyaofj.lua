--[[
	SERTY PACKET
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	• Dark navy panel + cyan glow border (exact look from the screenshot)
	• Value field + Activate toggle
	• Status: IDLE / RUNNING
	• Auto-save (value, position, locked)
	• Keybind (default C) + controller support
	• Optional auto-stop timer
	━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]

--==============================================================
--  EDITABLE SETTINGS
--==============================================================
local CFG_FILE     = "SertyPacket_Config.json"
local TITLE_TEXT   = "SERTY PACKET"
local PANEL_W      = 280
local PANEL_H      = 168
local R_PANEL      = 18
local R_ITEM       = 12
local MAX_POWER    = 100000
local AUTOSAVE     = 0.35
local DEFAULT_TIME = 0          -- 0 = never auto-stop
local MAX_TIME     = 60

--==============================================================
--  SERVICES
--==============================================================
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService       = game:GetService("HttpService")
local GuiService        = game:GetService("GuiService")

local player = Players.LocalPlayer
while not player do task.wait(0.1) player = Players.LocalPlayer end
local playerGui = player:FindFirstChildOfClass("PlayerGui")
while not playerGui do task.wait(0.1) playerGui = player:FindFirstChildOfClass("PlayerGui") end

--==============================================================
--  PALETTE  (matches the screenshot)
--==============================================================
local C = {
	bg         = Color3.fromRGB(12, 16, 24),      -- main panel
	field      = Color3.fromRGB(18, 24, 34),      -- value box / toggle track
	fieldInner = Color3.fromRGB(14, 18, 28),      -- inner of value box
	cyan       = Color3.fromRGB(0, 230, 180),     -- accent / title
	cyanSoft   = Color3.fromRGB(80, 220, 190),
	white      = Color3.fromRGB(230, 240, 245),
	dim        = Color3.fromRGB(110, 130, 150),
	border     = Color3.fromRGB(40, 180, 160),
	toggleOff  = Color3.fromRGB(55, 70, 90),
	toggleOn   = Color3.fromRGB(0, 210, 160),
	knob       = Color3.fromRGB(220, 235, 245),
	statusIdle = Color3.fromRGB(140, 160, 180),
	statusRun  = Color3.fromRGB(0, 230, 180),
}

--==============================================================
--  HELPERS
--==============================================================
local function mk(className, props, parent)
	local inst = Instance.new(className)
	for k, v in pairs(props) do inst[k] = v end
	if parent then inst.Parent = parent end
	return inst
end

local function corner(obj, r)
	return mk("UICorner", { CornerRadius = UDim.new(0, r) }, obj)
end

local function stroke(obj, color, thickness, transparency)
	return mk("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, obj)
end

local function tween(obj, props, t)
	TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function clamp(v, lo, hi)
	if v < lo then return lo elseif v > hi then return hi end
	return v
end

--==============================================================
--  NUMBER FORMAT
--==============================================================
local SUFFIX = { { "t", 1e12 }, { "b", 1e9 }, { "m", 1e6 }, { "k", 1e3 } }
local MULT   = { k = 1e3, m = 1e6, b = 1e9, t = 1e12 }

local function formatPower(value)
	local n = math.floor(tonumber(value) or 0)
	if n < 1000 then return tostring(n) end
	for _, pair in ipairs(SUFFIX) do
		local tag, size = pair[1], pair[2]
		if n >= size then
			local q = n / size
			local text
			if q >= 100 then
				text = string.format("%d", math.floor(q))
			else
				text = string.format("%.1f", math.floor(q * 10) / 10)
				if string.find(text, "%.") then
					text = string.gsub(text, "%.?0+$", "")
				end
			end
			return text .. tag
		end
	end
	return tostring(n)
end

local function parsePower(value)
	if value == nil then return nil end
	local s = string.lower(tostring(value))
	s = string.gsub(s, "[%s_,]", "")
	local number, tag = string.match(s, "^([%d%.]+)([kmbt]?)$")
	if not number then return nil end
	local n = tonumber(number)
	if not n then return nil end
	if tag ~= "" then n = n * MULT[tag] end
	return math.floor(clamp(n, 1, MAX_POWER))
end

--==============================================================
--  STATE
--==============================================================
local running   = false
local power     = 20000
local locked    = false
local capturing = false
local dragging  = false
local net
local timeLimit = DEFAULT_TIME
local runToken  = 0
local runClock  = 0

local bind = { kind = "key", code = "C", label = "C" }

local saveConfig, loadConfig, queueSave

--==============================================================
--  REMOTE
--==============================================================
task.spawn(function()
	local tries = 0
	local pkgs
	while tries < 10 do
		local ok, found = pcall(function()
			return ReplicatedStorage:FindFirstChild("Packages")
		end)
		if ok and found then pkgs = found break end
		tries = tries + 1
		task.wait(0.5)
	end
	if not pkgs then return end
	local netObj = pkgs:FindFirstChild("Net")
	if not netObj then
		task.wait(5)
		netObj = pkgs:FindFirstChild("Net")
	end
	if not netObj then return end
	local ok, found = pcall(function()
		return netObj:GetChildren()[230]
	end)
	if ok then net = found end
end)

--==============================================================
--  CLEAN OLD GUIS
--==============================================================
for _, name in ipairs({ "SertyPacket", "ArabPacketLagger", "CrystalPacketLagger", "HookPacketLagger", "KSK OP" }) do
	local old = playerGui:FindFirstChild(name)
	if old then old:Destroy() end
end

--==============================================================
--  GUI ROOT
--==============================================================
local screenGui = mk("ScreenGui", {
	Name = "SertyPacket",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
}, playerGui)

-- outer glow border (cyan)
local glow = mk("Frame", {
	Name = "Glow",
	Size = UDim2.fromOffset(PANEL_W + 4, PANEL_H + 4),
	Position = UDim2.fromOffset(-2, -2),
	BackgroundColor3 = C.border,
	BackgroundTransparency = 0.55,
	BorderSizePixel = 0,
	ZIndex = 1,
}, screenGui)
corner(glow, R_PANEL + 2)

local panel = mk("Frame", {
	Name = "Panel",
	Size = UDim2.fromOffset(PANEL_W, PANEL_H),
	BackgroundColor3 = C.bg,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ZIndex = 2,
}, screenGui)
corner(panel, R_PANEL)
stroke(panel, C.border, 1.6, 0.35)

-- keep glow attached to panel
panel:GetPropertyChangedSignal("Position"):Connect(function()
	glow.Position = UDim2.new(
		panel.Position.X.Scale,
		panel.Position.X.Offset - 2,
		panel.Position.Y.Scale,
		panel.Position.Y.Offset - 2
	)
end)
panel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	glow.Position = UDim2.fromOffset(panel.AbsolutePosition.X - 2, panel.AbsolutePosition.Y - 2)
end)

--==============================================================
--  TOP BAR
--==============================================================
local topBar = mk("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, 42),
	BackgroundTransparency = 1,
	ZIndex = 5,
}, panel)

-- Logo square "S"
local logo = mk("Frame", {
	Name = "Logo",
	Position = UDim2.fromOffset(14, 10),
	Size = UDim2.fromOffset(24, 24),
	BackgroundColor3 = Color3.fromRGB(8, 14, 22),
	BorderSizePixel = 0,
	ZIndex = 6,
}, topBar)
corner(logo, 7)
stroke(logo, C.cyan, 1.4, 0.15)

local logoText = mk("TextLabel", {
	Name = "S",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = "S",
	TextColor3 = C.cyan,
	TextSize = 15,
	ZIndex = 7,
}, logo)

-- Title
local title = mk("TextLabel", {
	Name = "Title",
	Position = UDim2.fromOffset(46, 11),
	Size = UDim2.fromOffset(170, 22),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBlack,
	Text = TITLE_TEXT,
	TextColor3 = C.cyan,
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 6,
}, topBar)

-- Gear / settings button (top right)
local gearBtn = mk("TextButton", {
	Name = "Gear",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -12, 0, 10),
	Size = UDim2.fromOffset(24, 24),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "⚙",
	TextColor3 = C.dim,
	TextSize = 16,
	AutoButtonColor = false,
	ZIndex = 7,
}, topBar)

-- thin cyan line under top bar
mk("Frame", {
	Name = "Line",
	Position = UDim2.new(0, 14, 0, 41),
	Size = UDim2.new(1, -28, 0, 1),
	BackgroundColor3 = C.cyan,
	BackgroundTransparency = 0.55,
	BorderSizePixel = 0,
	ZIndex = 5,
}, panel)

--==============================================================
--  VALUE ROW
--==============================================================
local valueRow = mk("Frame", {
	Name = "ValueRow",
	Position = UDim2.fromOffset(14, 54),
	Size = UDim2.new(1, -28, 0, 36),
	BackgroundColor3 = C.field,
	BorderSizePixel = 0,
	ZIndex = 5,
}, panel)
corner(valueRow, R_ITEM)

local valueLabel = mk("TextLabel", {
	Name = "Label",
	Position = UDim2.fromOffset(14, 0),
	Size = UDim2.new(0, 70, 1, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "Value",
	TextColor3 = C.white,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 6,
}, valueRow)

local valueBox = mk("TextBox", {
	Name = "ValueBox",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.fromOffset(110, 26),
	BackgroundColor3 = C.fieldInner,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamBold,
	Text = formatPower(power),
	PlaceholderText = "20000",
	PlaceholderColor3 = C.dim,
	TextColor3 = C.white,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 6,
}, valueRow)
corner(valueBox, 8)
stroke(valueBox, Color3.fromRGB(40, 55, 70), 1, 0.4)

--==============================================================
--  ACTIVATE ROW
--==============================================================
local actRow = mk("Frame", {
	Name = "ActivateRow",
	Position = UDim2.fromOffset(14, 98),
	Size = UDim2.new(1, -28, 0, 36),
	BackgroundColor3 = C.field,
	BorderSizePixel = 0,
	ZIndex = 5,
}, panel)
corner(actRow, R_ITEM)

local actLabel = mk("TextLabel", {
	Name = "Label",
	Position = UDim2.fromOffset(14, 0),
	Size = UDim2.new(0, 90, 1, 0),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamMedium,
	Text = "Activate",
	TextColor3 = C.white,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 6,
}, actRow)

-- Toggle track
local toggleTrack = mk("Frame", {
	Name = "Toggle",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -12, 0.5, 0),
	Size = UDim2.fromOffset(44, 22),
	BackgroundColor3 = C.toggleOff,
	BorderSizePixel = 0,
	ZIndex = 6,
}, actRow)
corner(toggleTrack, 11)

local toggleKnob = mk("Frame", {
	Name = "Knob",
	Position = UDim2.fromOffset(3, 3),
	Size = UDim2.fromOffset(16, 16),
	BackgroundColor3 = C.knob,
	BorderSizePixel = 0,
	ZIndex = 7,
}, toggleTrack)
corner(toggleKnob, 8)

--==============================================================
--  STATUS
--==============================================================
local statusLbl = mk("TextLabel", {
	Name = "Status",
	Position = UDim2.new(0, 0, 1, -22),
	Size = UDim2.new(1, 0, 0, 18),
	BackgroundTransparency = 1,
	Font = Enum.Font.GothamBold,
	Text = "IDLE",
	TextColor3 = C.statusIdle,
	TextSize = 11,
	ZIndex = 5,
}, panel)

--==============================================================
--  SETTINGS POPUP (gear)
--==============================================================
local settingsOpen = false
local settingsFrame = mk("Frame", {
	Name = "Settings",
	Position = UDim2.fromOffset(14, 48),
	Size = UDim2.new(1, -28, 0, 110),
	BackgroundColor3 = Color3.fromRGB(10, 14, 20),
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 20,
}, panel)
corner(settingsFrame, 12)
stroke(settingsFrame, C.border, 1, 0.5)

local function makeSetLabel(text, y)
	return mk("TextLabel", {
		Position = UDim2.fromOffset(12, y),
		Size = UDim2.new(0, 80, 0, 18),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		Text = text,
		TextColor3 = C.dim,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 21,
	}, settingsFrame)
end

makeSetLabel("Keybind", 10)
local keyBtn = mk("TextButton", {
	Position = UDim2.fromOffset(90, 8),
	Size = UDim2.fromOffset(100, 22),
	BackgroundColor3 = C.field,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Text = "{C}",
	TextColor3 = C.white,
	TextSize = 12,
	AutoButtonColor = false,
	ZIndex = 21,
}, settingsFrame)
corner(keyBtn, 6)

makeSetLabel("Time limit", 40)
local timeBox = mk("TextBox", {
	Position = UDim2.fromOffset(90, 38),
	Size = UDim2.fromOffset(100, 22),
	BackgroundColor3 = C.field,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Font = Enum.Font.GothamBold,
	Text = "OFF",
	TextColor3 = C.dim,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 21,
}, settingsFrame)
corner(timeBox, 6)

makeSetLabel("Lock panel", 70)
local lockBtn = mk("TextButton", {
	Position = UDim2.fromOffset(90, 68),
	Size = UDim2.fromOffset(100, 22),
	BackgroundColor3 = C.field,
	BorderSizePixel = 0,
	Font = Enum.Font.GothamBold,
	Text = "UNLOCKED",
	TextColor3 = C.cyanSoft,
	TextSize = 11,
	AutoButtonColor = false,
	ZIndex = 21,
}, settingsFrame)
corner(lockBtn, 6)

--==============================================================
--  KEYBIND HELPERS
--==============================================================
local function friendlyKey(name)
	local text = string.gsub(name, "^Button", "")
	text = string.gsub(text, "^DPad", "D-")
	text = string.gsub(text, "^Keypad", "NUM")
	if text == "" then return "?" end
	if #text == 1 then return string.upper(text) end
	return text
end

local function refreshKeyButton()
	if bind.kind == "none" then
		keyBtn.Text = "{NONE}"
		keyBtn.TextColor3 = C.dim
	else
		keyBtn.Text = "{" .. bind.label .. "}"
		keyBtn.TextColor3 = C.white
	end
end

local function setBind(kind, code, label, save)
	bind.kind = kind
	bind.code = code
	bind.label = label
	refreshKeyButton()
	if save ~= false and queueSave then queueSave() end
end

local function inputMatchesBind(input)
	if bind.kind == "none" or capturing then return false end
	if bind.kind == "mouse" then
		local wanted = Enum.UserInputType[bind.code]
		return wanted ~= nil and input.UserInputType == wanted
	end
	if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name == bind.code then
		return true
	end
	return false
end

--==============================================================
--  VISUALS
--==============================================================
local function setToggleVisual(on, animate)
	local targetPos = on and UDim2.fromOffset(25, 3) or UDim2.fromOffset(3, 3)
	local trackColor = on and C.toggleOn or C.toggleOff
	if animate then
		tween(toggleKnob, { Position = targetPos }, 0.14)
		tween(toggleTrack, { BackgroundColor3 = trackColor }, 0.14)
	else
		toggleKnob.Position = targetPos
		toggleTrack.BackgroundColor3 = trackColor
	end
end

local function setRunningVisuals(state)
	if state then
		statusLbl.Text = "RUNNING"
		statusLbl.TextColor3 = C.statusRun
		setToggleVisual(true, true)
	else
		statusLbl.Text = "IDLE"
		statusLbl.TextColor3 = C.statusIdle
		setToggleVisual(false, true)
	end
end

--==============================================================
--  LAGGER CORE
--==============================================================
local stopLagger

local function startLagger()
	if running then return end
	local parsed = parsePower(valueBox.Text)
	if parsed then power = parsed end
	valueBox.Text = formatPower(power)

	if not net then
		warn("[SERTY PACKET] Remote not ready – wait a second and try again.")
		return
	end

	running = true
	runToken = runToken + 1
	runClock = os.clock()
	local token = runToken

	setRunningVisuals(true)

	local packets = table.create(power, function() end)
	task.spawn(function()
		while running and token == runToken do
			for _ = 1, 3 do
				pcall(function() net:FireServer(packets) end)
			end
			task.wait(0.01)
		end
	end)

	-- optional auto-stop
	if timeLimit > 0 then
		task.spawn(function()
			while running and token == runToken do
				local left = timeLimit - (os.clock() - runClock)
				if left <= 0 then
					if running and token == runToken then stopLagger() end
					break
				end
				statusLbl.Text = string.format("RUNNING  %.1fs", left)
				task.wait(0.1)
			end
		end)
	end

	if queueSave then queueSave() end
end

function stopLagger()
	if not running then return end
	running = false
	runToken = runToken + 1
	setRunningVisuals(false)
	if queueSave then queueSave() end
end

local function toggleLagger()
	if running then stopLagger() else startLagger() end
end

--==============================================================
--  VALUE BOX
--==============================================================
valueBox.Focused:Connect(function()
	valueBox.Text = ""
	valueBox.PlaceholderText = formatPower(power)
end)

valueBox.FocusLost:Connect(function()
	local parsed = parsePower(valueBox.Text)
	if parsed then power = parsed end
	valueBox.Text = formatPower(power)
	if saveConfig then saveConfig() end
end)

valueBox:GetPropertyChangedSignal("Text"):Connect(function()
	if queueSave then queueSave() end
end)

--==============================================================
--  TOGGLE CLICK
--==============================================================
toggleTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		toggleLagger()
	end
end)

actRow.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		-- only if click is on the right side (toggle area)
		local rel = input.Position.X - actRow.AbsolutePosition.X
		if rel > actRow.AbsoluteSize.X - 60 then
			toggleLagger()
		end
	end
end)

--==============================================================
--  GEAR / SETTINGS
--==============================================================
gearBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	settingsFrame.Visible = settingsOpen
	gearBtn.TextColor3 = settingsOpen and C.cyan or C.dim
end)

--==============================================================
--  KEYBIND CAPTURE
--==============================================================
local function beginCapture()
	if capturing then return end
	capturing = true
	keyBtn.Text = "{PRESS}"
	keyBtn.TextColor3 = C.cyan
end

local function endCapture()
	capturing = false
	refreshKeyButton()
end

keyBtn.MouseButton1Click:Connect(function()
	if capturing then endCapture() else beginCapture() end
end)

--==============================================================
--  TIME BOX
--==============================================================
local function formatTime(v)
	local n = tonumber(v) or 0
	if n <= 0 then return "OFF" end
	n = math.floor(n * 10 + 0.5) / 10
	if n == math.floor(n) then return tostring(n) .. "s" end
	return string.format("%.1f", n) .. "s"
end

local function parseTime(v)
	local s = string.lower(tostring(v or ""))
	s = string.gsub(s, "[%s_,]", "")
	s = string.gsub(s, "sec$", "")
	s = string.gsub(s, "s$", "")
	if s == "" then return nil end
	if s == "off" or s == "no" or s == "none" then return 0 end
	local n = tonumber(s)
	if not n then return nil end
	return math.floor(clamp(n, 0, MAX_TIME) * 10 + 0.5) / 10
end

timeBox.FocusLost:Connect(function()
	local parsed = parseTime(timeBox.Text)
	if parsed ~= nil then timeLimit = parsed end
	timeBox.Text = formatTime(timeLimit)
	timeBox.TextColor3 = (timeLimit > 0) and C.white or C.dim
	if saveConfig then saveConfig() end
end)

--==============================================================
--  LOCK
--==============================================================
local function refreshLock()
	if locked then
		lockBtn.Text = "LOCKED"
		lockBtn.TextColor3 = C.cyan
	else
		lockBtn.Text = "UNLOCKED"
		lockBtn.TextColor3 = C.cyanSoft
	end
end

lockBtn.MouseButton1Click:Connect(function()
	locked = not locked
	refreshLock()
	if queueSave then queueSave() end
end)

--==============================================================
--  INPUT
--==============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if capturing then
		local kind = input.UserInputType
		if kind == Enum.UserInputType.Keyboard or string.find(kind.Name, "Gamepad") then
			local key = input.KeyCode
			if key == Enum.KeyCode.Unknown then return end
			if key == Enum.KeyCode.Escape or key == Enum.KeyCode.ButtonB then
				endCapture()
				return
			end
			endCapture()
			setBind("key", key.Name, friendlyKey(key.Name))
		elseif kind == Enum.UserInputType.MouseButton2 then
			endCapture()
			setBind("mouse", "MouseButton2", "RMB")
		end
		return
	end

	if UserInputService:GetFocusedTextBox() then return end
	if inputMatchesBind(input) then
		toggleLagger()
	end
end)

--==============================================================
--  DRAGGING
--==============================================================
local panelPos, dragStart

topBar.InputBegan:Connect(function(input)
	if locked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		panelPos = panel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				if queueSave then queueSave() end
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging or locked then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		panel.Position = UDim2.new(
			panelPos.X.Scale, panelPos.X.Offset + delta.X,
			panelPos.Y.Scale, panelPos.Y.Offset + delta.Y
		)
	end
end)

--==============================================================
--  AUTO SAVE
--==============================================================
local saveToken = 0

function saveConfig()
	if type(writefile) ~= "function" then return end
	local ok, data = pcall(function()
		return HttpService:JSONEncode({
			version = 1,
			power = power,
			keybind = { kind = bind.kind, code = bind.code, label = bind.label },
			timeLimit = timeLimit,
			locked = locked,
			position = {
				x = math.floor(panel.Position.X.Offset),
				y = math.floor(panel.Position.Y.Offset),
			},
		})
	end)
	if ok and type(data) == "string" then
		pcall(writefile, CFG_FILE, data)
	end
end

function queueSave()
	if type(writefile) ~= "function" then return end
	saveToken = saveToken + 1
	local mine = saveToken
	task.delay(AUTOSAVE, function()
		if mine == saveToken then saveConfig() end
	end)
end

function loadConfig()
	if type(isfile) ~= "function" or type(readfile) ~= "function" then return false end
	local okFile, hasFile = pcall(isfile, CFG_FILE)
	if not okFile or not hasFile then return false end
	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(CFG_FILE))
	end)
	if not ok or type(data) ~= "table" then return false end

	if tonumber(data.power) then
		power = math.floor(clamp(tonumber(data.power), 1, MAX_POWER))
		valueBox.Text = formatPower(power)
	end

	if type(data.keybind) == "table" then
		local k = data.keybind
		if k.kind == "none" then
			setBind("none", "None", "NONE", false)
		elseif k.kind == "mouse" and type(k.code) == "string" then
			setBind("mouse", k.code, tostring(k.label or k.code), false)
		elseif type(k.code) == "string" and k.code ~= "" then
			setBind("key", k.code, tostring(k.label or friendlyKey(k.code)), false)
		end
	end

	if data.timeLimit ~= nil then
		local t = tonumber(data.timeLimit)
		if t then
			timeLimit = clamp(t, 0, MAX_TIME)
			timeBox.Text = formatTime(timeLimit)
			timeBox.TextColor3 = (timeLimit > 0) and C.white or C.dim
		end
	end

	if data.locked ~= nil then
		locked = (data.locked == true)
		refreshLock()
	end

	local pos = data.position
	if type(pos) == "table" and tonumber(pos.x) and tonumber(pos.y) then
		panel.Position = UDim2.fromOffset(math.floor(pos.x), math.floor(pos.y))
	end

	return true
end

--==============================================================
--  INIT
--==============================================================
local function defaultPlace()
	local camera = workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
	panel.Position = UDim2.fromOffset(
		math.floor(viewport.X / 2 - PANEL_W / 2),
		math.floor(viewport.Y / 2 - PANEL_H / 2)
	)
end

defaultPlace()

task.spawn(function()
	local ok, result = pcall(loadConfig)
	if not (ok and result) then
		valueBox.Text = formatPower(power)
		timeBox.Text = formatTime(timeLimit)
	end
	-- clamp to screen
	local camera = workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
	local pos = panel.Position
	local x = clamp(pos.X.Offset, -PANEL_W + 70, viewport.X - 70)
	local y = clamp(pos.Y.Offset, 0, viewport.Y - PANEL_H - 4)
	panel.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
end)

setRunningVisuals(false)
refreshKeyButton()
refreshLock()
timeBox.Text = formatTime(timeLimit)
timeBox.TextColor3 = (timeLimit > 0) and C.white or C.dim

print("[SERTY PACKET] loaded")