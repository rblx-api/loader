--[[
	KYRON

	Features:
	- Compact dark theme.
	- Mobile support: Touch draggable, scales to fit screen.
	- Minimize into a compact pill with a quick-toggle switch.
	- Keybind system.
	- CFrame Walk.
	- Lock to prevent dragging.
]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("KYRON")
if old then old:Destroy() end

--------------------------------------------------------------------------
-- Config
--------------------------------------------------------------------------
local FILE = "kyron.json"
local cfg = {
	Key = "G",
	Sounds = true,
	Collapsed = false,
	CardPos = nil,
	Intensity = 10000,
	WalkStuds = 8,
	WalkDelay = 0.1,
	Locked = false,
}
pcall(function()
	if isfile and isfile(FILE) then
		local data = HttpService:JSONDecode(readfile(FILE))
		for k in pairs(cfg) do
			if data[k] ~= nil then cfg[k] = data[k] end
		end
	end
end)

local saveToken = 0
local function save()
	saveToken += 1
	local token = saveToken
	task.delay(0.4, function()
		if token ~= saveToken then return end
		pcall(function()
			if writefile then writefile(FILE, HttpService:JSONEncode(cfg)) end
		end)
	end)
end

local function packPos(p) return { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset } end
local function unpackPos(t, fallback)
	if type(t) == "table" and #t == 4 then return UDim2.new(t[1], t[2], t[3], t[4]) end
	return fallback
end

--------------------------------------------------------------------------
-- Colors
--------------------------------------------------------------------------
local C = {
	Bg         = Color3.fromRGB(12, 14, 18),
	Raise      = Color3.fromRGB(20, 24, 32),
	Line       = Color3.fromRGB(40, 48, 62),
	Dim        = Color3.fromRGB(120, 140, 160),
	Sub        = Color3.fromRGB(160, 180, 200),
	Text       = Color3.fromRGB(240, 245, 255),
	White      = Color3.fromRGB(255, 255, 255),
	On         = Color3.fromRGB(0, 170, 255),
	Black      = Color3.fromRGB(16, 16, 20),
	Gray       = Color3.fromRGB(55, 58, 68),
	LightGray  = Color3.fromRGB(140, 145, 155),
}
local FONT, FONT_B, FONT_K = Enum.Font.Gotham, Enum.Font.GothamMedium, Enum.Font.GothamBold

local function new(class, props, kids)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	for _, c in ipairs(kids or {}) do c.Parent = o end
	return o
end
local function tween(o, t, props, style, dir)
	local tw = TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	tw:Play()
	return tw
end
local function corner(r) return new("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function round() return new("UICorner", { CornerRadius = UDim.new(1, 0) }) end
local function stroke(col, tr, th)
	return new("UIStroke", { Color = col, Transparency = tr or 0, Thickness = th or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
end
local function label(props)
	props.BackgroundTransparency = 1
	props.Font = props.Font or FONT
	props.TextSize = props.TextSize or 12
	props.TextColor3 = props.TextColor3 or C.Text
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	return new("TextLabel", props)
end

local KEYNAMES = {
	LeftShift = "L-Shift", RightShift = "R-Shift", LeftControl = "L-Ctrl", RightControl = "R-Ctrl",
	LeftAlt = "L-Alt", RightAlt = "R-Alt", Return = "Enter", Backspace = "Bksp", Space = "Space",
	CapsLock = "Caps", Tab = "Tab",
	ButtonA = "A", ButtonB = "B", ButtonX = "X", ButtonY = "Y",
	ButtonL1 = "L1", ButtonR1 = "R1", ButtonL2 = "L2", ButtonR2 = "R2",
	ButtonL3 = "L3", ButtonR3 = "R3", ButtonStart = "Start", ButtonSelect = "Select",
	DPadUp = "D-Up", DPadDown = "D-Down", DPadLeft = "D-Left", DPadRight = "D-Right",
}

--------------------------------------------------------------------------
local gui = new("ScreenGui", {
	Name = "KYRON", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100, Parent = playerGui,
})
local function play() end

-- State
local active = false
local activeSince = 0
local hooks = {}
local setActive
local locked = cfg.Locked or false

local touchOnly = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local W, H = 220, 268   -- más pequeño y rectangular

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------
local card = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = unpackPos(cfg.CardPos, UDim2.fromScale(0.5, 0.5)),
	Size = UDim2.fromOffset(W, H),
	BackgroundColor3 = C.Bg,
	BackgroundTransparency = 0.12,
	BorderSizePixel = 0, ClipsDescendants = true, Parent = gui,
}, { corner(14) })
local cardStroke = stroke(C.Line, 0.45, 1.4)
cardStroke.Parent = card
local cardScale = new("UIScale", { Parent = card })

local function fitScale()
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(1280, 720)
	local base = touchOnly and 1.08 or 1
	cardScale.Scale = math.clamp(math.min(base, (vs.X - 20) / W, (vs.Y - 20) / H), 0.55, 1.25)
end
fitScale()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)
end

-- Header
local title = label({
	Text = "KYRON",
	Font = FONT_K, TextSize = 14, TextColor3 = C.White,
	Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -90, 0, 34), Parent = card,
})

-- Lock button
local lockBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -58, 0, 6),
	Size = UDim2.fromOffset(24, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_B, TextSize = 13, TextColor3 = C.Dim, Text = "🔓", ZIndex = 10, Parent = card,
}, { corner(5) })
local lockStroke = stroke(C.Line, 0.5, 1)
lockStroke.Parent = lockBtn

-- Minimize
local minBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 6),
	Size = UDim2.fromOffset(24, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_B, TextSize = 14, TextColor3 = C.Dim, Text = "—", ZIndex = 10, Parent = card,
}, { corner(5) })
local minBtnStroke = stroke(C.Line, 0.5, 1)
minBtnStroke.Parent = minBtn

minBtn.MouseEnter:Connect(function() tween(minBtn, 0.12, { TextColor3 = C.White, BackgroundColor3 = C.Line }) end)
minBtn.MouseLeave:Connect(function() tween(minBtn, 0.2, { TextColor3 = C.Dim, BackgroundColor3 = C.Raise }) end)

-- Mini mode buttons
local miniToggleBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -40, 0.5, -12),
	Size = UDim2.fromOffset(38, 24),
	BackgroundColor3 = C.Raise, AutoButtonColor = false, Font = FONT_K, TextSize = 11,
	TextColor3 = C.White, Text = "START", Visible = false, ZIndex = 10, Parent = card,
}, { corner(6) })
local miniToggleStroke = stroke(C.Line, 0.25, 1.3)
miniToggleStroke.Parent = miniToggleBtn

local expandBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0.5, -11),
	Size = UDim2.fromOffset(24, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false, Font = FONT_K, TextSize = 14,
	TextColor3 = C.White, Text = "+", Visible = false, ZIndex = 10, Parent = card,
}, { corner(5) })
local expandStroke = stroke(C.Line, 0.25, 1.3)
expandStroke.Parent = expandBtn

-- Divider
new("Frame", {
	Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = C.Line, BackgroundTransparency = 0.55, BorderSizePixel = 0, Parent = card,
})

--------------------------------------------------------------------------
-- Compact config row: Power | Walk
--------------------------------------------------------------------------
local powerLbl = label({
	Text = "Power", Font = FONT, TextSize = 11, TextColor3 = C.Sub,
	Position = UDim2.fromOffset(14, 42), Size = UDim2.fromOffset(50, 16), Parent = card,
})
local intBox = new("TextBox", {
	Position = UDim2.fromOffset(14, 58), Size = UDim2.fromOffset(90, 26),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.4, BorderSizePixel = 0,
	Text = tostring(cfg.Intensity), Font = FONT_B, TextSize = 13, TextColor3 = C.On,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = card,
}, { corner(6) })
local intBoxStroke = stroke(C.Line, 0.5)
intBoxStroke.Parent = intBox

local walkLbl = label({
	Text = "Walk", Font = FONT, TextSize = 11, TextColor3 = C.Sub,
	Position = UDim2.fromOffset(116, 42), Size = UDim2.fromOffset(50, 16), Parent = card,
})
local walkBtn = new("TextButton", {
	Position = UDim2.fromOffset(116, 58), Size = UDim2.fromOffset(90, 26),
	BackgroundColor3 = C.Raise, AutoButtonColor = false, Font = FONT_K, TextSize = 12,
	TextColor3 = C.White, Text = "OFF", Parent = card,
}, { corner(6) })
local walkBtnStroke = stroke(C.Line, 0.3, 1.2)
walkBtnStroke.Parent = walkBtn

--------------------------------------------------------------------------
-- Keybind row
--------------------------------------------------------------------------
local keyLbl = label({
	Text = "Keybind", Font = FONT, TextSize = 11, TextColor3 = C.Sub,
	Position = UDim2.fromOffset(14, 92), Size = UDim2.fromOffset(60, 16), Parent = card,
})
local cap = new("TextButton", {
	Position = UDim2.fromOffset(14, 110), Size = UDim2.fromOffset(192, 26),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.4, AutoButtonColor = false,
	Selectable = true, Text = "", Parent = card,
}, { corner(6) })
local capStroke = stroke(C.Line, 0.5)
capStroke.Parent = cap
local capScale = new("UIScale", { Parent = cap })
local capText = label({
	Text = "", Font = FONT_B, TextSize = 12, TextColor3 = C.White,
	TextXAlignment = Enum.TextXAlignment.Center,
	Size = UDim2.fromScale(1, 1), Parent = cap,
})

local listening = false
local GAMEPAD_TYPES = {
	[Enum.UserInputType.Gamepad1] = true, [Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true, [Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true, [Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true, [Enum.UserInputType.Gamepad8] = true,
}
local function isBindableInput(input)
	return input.UserInputType == Enum.UserInputType.Keyboard or GAMEPAD_TYPES[input.UserInputType] == true
end
local function paintKey()
	listening = false
	capText.Text = KEYNAMES[cfg.Key] or cfg.Key
	capText.TextColor3 = C.White
	tween(capStroke, 0.2, { Color = C.Line })
end
paintKey()

--------------------------------------------------------------------------
-- Studs / Delay (compact under keybind)
--------------------------------------------------------------------------
local studsLbl = label({
	Text = "studs", Font = FONT, TextSize = 10, TextColor3 = C.Dim,
	Position = UDim2.fromOffset(14, 144), Size = UDim2.fromOffset(36, 18), Parent = card,
})
local studsInput = new("TextBox", {
	Position = UDim2.fromOffset(52, 142), Size = UDim2.fromOffset(48, 22),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.35, BorderSizePixel = 0,
	Text = tostring(cfg.WalkStuds), Font = FONT_B, TextSize = 12, TextColor3 = C.On,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = card,
}, { corner(5) })
local studsStroke = stroke(C.Line, 0.5)
studsStroke.Parent = studsInput

local delayLbl = label({
	Text = "delay", Font = FONT, TextSize = 10, TextColor3 = C.Dim,
	Position = UDim2.fromOffset(112, 144), Size = UDim2.fromOffset(36, 18), Parent = card,
})
local delayInput = new("TextBox", {
	Position = UDim2.fromOffset(150, 142), Size = UDim2.fromOffset(56, 22),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.35, BorderSizePixel = 0,
	Text = tostring(cfg.WalkDelay), Font = FONT_B, TextSize = 12, TextColor3 = C.On,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = card,
}, { corner(5) })
local delayStroke = stroke(C.Line, 0.5)
delayStroke.Parent = delayInput

--------------------------------------------------------------------------
-- START button at the bottom
--------------------------------------------------------------------------
local BTN_W, BTN_H = W - 28, 48
local btn = new("TextButton", {
	Position = UDim2.fromOffset(14, H - 62), Size = UDim2.fromOffset(BTN_W, BTN_H),
	BackgroundColor3 = C.Black, AutoButtonColor = false, Text = "", ClipsDescendants = true, Parent = card,
}, { corner(10) })

-- Soft shadow
local btnShadow = new("Frame", {
	Position = UDim2.fromOffset(14, H - 58), Size = UDim2.fromOffset(BTN_W, BTN_H),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.7,
	BorderSizePixel = 0, ZIndex = 0, Parent = card,
}, { corner(10) })

local btnStroke = stroke(C.Gray, 0.4, 1.2)
btnStroke.Parent = btn
local btnScale = new("UIScale", { Parent = btn })

local wash = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = C.White, BackgroundTransparency = 0.92, BorderSizePixel = 0, Parent = btn,
})
local sweep = new("Frame", {
	Position = UDim2.new(0, -70, 0, 0), Size = UDim2.fromOffset(70, BTN_H),
	BackgroundColor3 = C.White, BackgroundTransparency = 0.9, BorderSizePixel = 0, Visible = false, Parent = btn,
}, {
	new("UIGradient", { Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)
	}) }),
})
local dotRing = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(26, BTN_H / 2), Size = UDim2.fromOffset(11, 11),
	BackgroundTransparency = 1, Parent = btn,
}, { round() })
local ringStroke = stroke(C.White, 1, 1.4)
ringStroke.Parent = dotRing
local ringScale = new("UIScale", { Parent = dotRing })
local dot = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(26, BTN_H / 2), Size = UDim2.fromOffset(9, 9),
	BackgroundColor3 = C.LightGray, BorderSizePixel = 0, Parent = btn,
}, { round() })
local stateText = label({
	Text = "START", Font = FONT_K, TextSize = 16, TextColor3 = C.White,
	Position = UDim2.fromOffset(44, 8), Size = UDim2.new(1, -52, 0, 20), Parent = btn,
})
local subText = label({
	Text = "", Font = FONT, TextSize = 10, TextColor3 = C.LightGray,
	Position = UDim2.fromOffset(44, 28), Size = UDim2.new(1, -52, 0, 14), Parent = btn,
})

--------------------------------------------------------------------------
-- Walk logic
--------------------------------------------------------------------------
local walking = false
local walkThread = nil

local function paintWalk()
	if walking then
		walkBtn.Text = "ON"
		walkBtn.TextColor3 = C.On
		walkBtn.BackgroundColor3 = C.Bg
		tween(walkBtnStroke, 0.2, { Color = C.On })
	else
		walkBtn.Text = "OFF"
		walkBtn.TextColor3 = C.White
		walkBtn.BackgroundColor3 = C.Raise
		tween(walkBtnStroke, 0.2, { Color = C.Line })
	end
end

local function updateWalkSettings()
	local s = tonumber(studsInput.Text)
	if s then cfg.WalkStuds = math.clamp(math.floor(s), 1, 500) end
	local d = tonumber(delayInput.Text)
	if d then cfg.WalkDelay = math.clamp(d, 0.01, 2) end
	studsInput.Text = tostring(cfg.WalkStuds)
	delayInput.Text = tostring(cfg.WalkDelay)
	save()
end
studsInput.FocusLost:Connect(updateWalkSettings)
delayInput.FocusLost:Connect(updateWalkSettings)

walkBtn.MouseButton1Click:Connect(function()
	walking = not walking
	if walking then
		paintWalk()
		local studs = math.clamp(math.floor(tonumber(studsInput.Text) or 8), 1, 500)
		local delay = math.clamp(tonumber(delayInput.Text) or 0.1, 0.01, 2)
		walkThread = task.spawn(function()
			while walking do
				local char = player.Character
				local hrp  = char and char:FindFirstChild("HumanoidRootPart")
				local hum  = char and char:FindFirstChildOfClass("Humanoid")
				if hrp and hum then
					local dir = hum.MoveDirection
					if dir.Magnitude > 0.1 then
						pcall(function()
							hrp.CFrame = hrp.CFrame + dir * studs
						end)
					end
				end
				task.wait(delay)
			end
		end)
	else
		paintWalk()
		if walkThread then pcall(task.cancel, walkThread); walkThread = nil end
	end
end)

--------------------------------------------------------------------------
-- Lock logic
--------------------------------------------------------------------------
local function updateLockVisual()
	if locked then
		lockBtn.Text = "🔒"
		lockBtn.TextColor3 = C.On
		tween(lockStroke, 0.2, { Color = C.On })
	else
		lockBtn.Text = "🔓"
		lockBtn.TextColor3 = C.Dim
		tween(lockStroke, 0.2, { Color = C.Line })
	end
end
updateLockVisual()

lockBtn.MouseButton1Click:Connect(function()
	locked = not locked
	cfg.Locked = locked
	save()
	updateLockVisual()
end)

--------------------------------------------------------------------------
-- Drag (respects lock)
--------------------------------------------------------------------------
do
	local handle = new("TextButton", {
		Size = UDim2.new(1, -90, 0, 34), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = card,
	})
	local dragging, startPos, startInput
	handle.InputBegan:Connect(function(input)
		if locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, startPos, startInput = true, card.Position, input.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging or locked then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = (input.Position - startInput) / cardScale.Scale
			card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			cfg.CardPos = packPos(card.Position)
			save()
		end
	end)
end

--------------------------------------------------------------------------
-- Minimize / Restore
--------------------------------------------------------------------------
local function setCollapsed(collapsed)
	cfg.Collapsed = collapsed
	save()

	local hideList = {
		powerLbl, intBox, walkLbl, walkBtn,
		keyLbl, cap, studsLbl, studsInput, delayLbl, delayInput,
		btn, btnShadow
	}

	if collapsed then
		minBtn.Visible = false
		lockBtn.Visible = false
		for _, v in ipairs(hideList) do v.Visible = false end
		expandBtn.Visible = true
		miniToggleBtn.Visible = true
		tween(card, 0.28, { Size = UDim2.fromOffset(W, 34) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	else
		expandBtn.Visible = false
		miniToggleBtn.Visible = false
		minBtn.Visible = true
		lockBtn.Visible = true
		for _, v in ipairs(hideList) do v.Visible = true end
		tween(card, 0.4, { Size = UDim2.fromOffset(W, H) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	end
end

minBtn.MouseButton1Click:Connect(function() setCollapsed(true) end)
expandBtn.MouseButton1Click:Connect(function() setCollapsed(false) end)

--------------------------------------------------------------------------
-- Intensity
--------------------------------------------------------------------------
local function clampIntensity(v)
	v = tonumber(v)
	if not v then return cfg.Intensity end
	return math.clamp(math.floor(v), 1, 100000)
end
local function setIntensity(v)
	cfg.Intensity = clampIntensity(v)
	intBox.Text = tostring(cfg.Intensity)
	save()
end
intBox.FocusLost:Connect(function() setIntensity(intBox.Text) end)

--------------------------------------------------------------------------
-- Lagging Logic (kept exactly)
--------------------------------------------------------------------------
local Event
do
	local ok, net = pcall(function()
		local pkgs = ReplicatedStorage:WaitForChild("Packages", 5)
		return pkgs and pkgs:WaitForChild("Net", 5)
	end)
	if ok and net then
		local kids = net:GetChildren()
		Event = kids[6]
	end
end

local lagging = false
local lagThread

local function startLagging()
	if lagging then return end
	if not Event then return end
	lagging = true
	local intensity = math.clamp(math.floor(tonumber(cfg.Intensity) or 10000), 1, 100000)
	local payload = table.create(intensity, function() end)
	lagThread = task.spawn(function()
		while lagging do
			for _ = 1, 3 do
				pcall(function() Event:FireServer(payload) end)
			end
			task.wait(0.01)
		end
	end)
end

local function stopLagging()
	if not lagging then return end
	lagging = false
	if lagThread then
		pcall(task.cancel, lagThread)
		lagThread = nil
	end
end

--------------------------------------------------------------------------
-- Render / Active state
--------------------------------------------------------------------------
local pulseTweens = {}
local function stopPulse()
	for _, t in ipairs(pulseTweens) do t:Cancel() end
	pulseTweens = {}
end

local function render(instant)
	local t = instant and 0 or 0.3
	stopPulse()
	if active then
		tween(wash, t, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quint)
		tween(btnStroke, t, { Color = C.White })
		tween(dot, t, { BackgroundColor3 = C.White })
		stateText.Text = "STOP"
		sweep.Visible = true
		sweep.Position = UDim2.new(0, -70, 0, 0)

		local loop = TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1)
		ringStroke.Transparency = 0.25
		ringScale.Scale = 1
		for _, tw in ipairs({
			TweenService:Create(ringScale, loop, { Scale = 2.3 }),
			TweenService:Create(ringStroke, loop, { Transparency = 1 }),
			TweenService:Create(sweep, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), { Position = UDim2.new(1, 0, 0, 0) }),
		}) do
			tw:Play()
			table.insert(pulseTweens, tw)
		end

		miniToggleBtn.Text = "STOP"
		tween(miniToggleBtn, t, { TextColor3 = C.White })
		tween(miniToggleStroke, t, { Color = C.White })
	else
		tween(wash, t, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Quint)
		tween(btnStroke, t, { Color = C.Gray })
		tween(dot, t, { BackgroundColor3 = C.LightGray })
		stateText.Text = "START"
		subText.Text = ""
		sweep.Visible = false
		ringStroke.Transparency = 1

		miniToggleBtn.Text = "START"
		tween(miniToggleBtn, t, { TextColor3 = C.White })
		tween(miniToggleStroke, t, { Color = C.Line })
	end
end

setActive = function(v, quiet)
	v = v and true or false
	if v == active then return end
	active = v
	activeSince = os.clock()
	render(false)
	if v then startLagging() else stopLagging() end

	btnScale.Scale = 0.94
	tween(btnScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)

	if cfg.Collapsed then
		miniToggleBtn.Size = UDim2.fromOffset(36, 22)
		tween(miniToggleBtn, 0.25, { Size = UDim2.fromOffset(38, 24) }, Enum.EasingStyle.Back)
	end

	for _, fn in ipairs(hooks) do task.spawn(fn, active) end
end

btn.MouseButton1Down:Connect(function() tween(btnScale, 0.08, { Scale = 0.96 }) end)
btn.MouseButton1Up:Connect(function() tween(btnScale, 0.22, { Scale = 1 }, Enum.EasingStyle.Back) end)
btn.MouseEnter:Connect(function() if not active then tween(btnStroke, 0.15, { Color = C.LightGray }) end end)
btn.MouseLeave:Connect(function()
	tween(btnScale, 0.18, { Scale = 1 })
	if not active then tween(btnStroke, 0.2, { Color = C.Gray }) end
end)
btn.MouseButton1Click:Connect(function() setActive(not active) end)
miniToggleBtn.MouseButton1Click:Connect(function() setActive(not active) end)

-- Timer
do
	local acc = 0
	RunService.Heartbeat:Connect(function(dt)
		if not active then return end
		acc += dt
		if acc < 0.2 then return end
		acc = 0
		local s = math.floor(os.clock() - activeSince)
		subText.Text = string.format("%02d:%02d", s // 60, s % 60)
	end)
end

--------------------------------------------------------------------------
-- Keybind
--------------------------------------------------------------------------
cap.MouseButton1Down:Connect(function() tween(capScale, 0.08, { Scale = 0.94 }) end)
cap.MouseButton1Up:Connect(function() tween(capScale, 0.22, { Scale = 1 }, Enum.EasingStyle.Back) end)

local function beginKeybindCapture()
	listening = true
	capText.Text = "press..."
	capText.TextColor3 = C.On
	tween(capStroke, 0.2, { Color = C.On })
end
cap.Activated:Connect(beginKeybindCapture)

UserInputService.InputBegan:Connect(function(input, processed)
	if not isBindableInput(input) then return end

	if listening then
		listening = false
		local cancelled = input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB
		if not cancelled then
			cfg.Key = input.KeyCode.Name
			save()
		end
		paintKey()
		return
	end

	if processed then return end
	if input.KeyCode.Name == cfg.Key then
		setActive(not active)
		capScale.Scale = 0.9
		tween(capScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)
	end
end)

--------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------
_G.Kyron = {
	On = function(fn) table.insert(hooks, fn) end,
	Get = function() return active end,
	Set = function(v) setActive(v) end,
	Key = function() return cfg.Key end,
	Walk = function() return walking end,
	SetWalk = function(v)
		if v ~= walking then walkBtn.MouseButton1Click:Fire() end
	end,
}

--------------------------------------------------------------------------
-- Start
--------------------------------------------------------------------------
paintWalk()
render(true)
if cfg.Collapsed then
	setCollapsed(true)
else
	card.Size = UDim2.fromOffset(W, 34)
	tween(card, 0.45, { Size = UDim2.fromOffset(W, H) }, Enum.EasingStyle.Quint)
end
save()