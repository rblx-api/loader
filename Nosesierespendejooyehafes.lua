--[[
	KYRON + Bat Bypass
	Compact black / gray theme
	Lock • Shadows • Smooth animations
	Bat Bypass V1-V4 (follow + auto swing + TP mode)
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
	Collapsed = false,
	CardPos = nil,
	Intensity = 10000,
	WalkStuds = 8,
	WalkDelay = 0.1,
	Locked = false,
	-- Bat Bypass
	BatBypass = false,
	BatVersion = 1,          -- 1-4
	BatSpeed = 55,
	BatMode = 1,             -- 1 = Bypass (velocity), 2 = TP Bat
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
	task.delay(0.35, function()
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
-- Theme (black / gray only)
--------------------------------------------------------------------------
local C = {
	Bg        = Color3.fromRGB(14, 15, 18),
	Raise     = Color3.fromRGB(22, 24, 28),
	Line      = Color3.fromRGB(45, 48, 55),
	Dim       = Color3.fromRGB(110, 115, 125),
	Sub       = Color3.fromRGB(150, 155, 165),
	Text      = Color3.fromRGB(235, 238, 245),
	White     = Color3.fromRGB(255, 255, 255),
	Black     = Color3.fromRGB(10, 11, 14),
	Gray      = Color3.fromRGB(55, 58, 65),
	LightGray = Color3.fromRGB(130, 135, 145),
	Accent    = Color3.fromRGB(200, 205, 215),
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

-- State
local active = false
local activeSince = 0
local hooks = {}
local setActive
local locked = cfg.Locked or false
local walking = false
local walkThread = nil

local touchOnly = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local W, H = 210, 360

--------------------------------------------------------------------------
-- Window
--------------------------------------------------------------------------
local card = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = unpackPos(cfg.CardPos, UDim2.fromScale(0.5, 0.5)),
	Size = UDim2.fromOffset(W, H),
	BackgroundColor3 = C.Bg,
	BackgroundTransparency = 0.08,
	BorderSizePixel = 0, ClipsDescendants = true, Parent = gui,
}, { corner(14) })
local cardStroke = stroke(C.Line, 0.4, 1.3)
cardStroke.Parent = card
local cardScale = new("UIScale", { Parent = card })

local outerShadow = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.52),
	Size = UDim2.new(1, 10, 1, 12),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.78,
	BorderSizePixel = 0, ZIndex = 0, Parent = card,
}, { corner(16) })

local function fitScale()
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(1280, 720)
	local base = touchOnly and 1.06 or 1
	cardScale.Scale = math.clamp(math.min(base, (vs.X - 24) / W, (vs.Y - 24) / H), 0.55, 1.2)
end
fitScale()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScale)
end

--------------------------------------------------------------------------
-- Header
--------------------------------------------------------------------------
local title = label({
	Text = "KYRON",
	Font = FONT_K, TextSize = 13, TextColor3 = C.White,
	Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -100, 0, 32), Parent = card,
})

local lockBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -52, 0, 5),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_B, TextSize = 12, TextColor3 = C.Dim, Text = "🔓", ZIndex = 12, Parent = card,
}, { corner(5) })
local lockStroke = stroke(C.Line, 0.45, 1)
lockStroke.Parent = lockBtn

local minBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 5),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_B, TextSize = 13, TextColor3 = C.Dim, Text = "—", ZIndex = 12, Parent = card,
}, { corner(5) })
local minBtnStroke = stroke(C.Line, 0.45, 1)
minBtnStroke.Parent = minBtn

minBtn.MouseEnter:Connect(function() tween(minBtn, 0.12, { TextColor3 = C.White, BackgroundColor3 = C.Line }) end)
minBtn.MouseLeave:Connect(function() tween(minBtn, 0.18, { TextColor3 = C.Dim, BackgroundColor3 = C.Raise }) end)

new("Frame", {
	Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = C.Line, BackgroundTransparency = 0.55, BorderSizePixel = 0, Parent = card,
})

--------------------------------------------------------------------------
-- Collapsed bar
--------------------------------------------------------------------------
local miniBar = new("Frame", {
	Size = UDim2.fromOffset(W, 32),
	BackgroundTransparency = 1, Visible = false, Parent = card,
})

local miniTitle = label({
	Text = "KYRON", Font = FONT_K, TextSize = 12, TextColor3 = C.White,
	Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(60, 32), Parent = miniBar,
})

local miniToggleBtn = new("TextButton", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.fromOffset(64, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_K, TextSize = 11, TextColor3 = C.White, Text = "INICIO",
	ZIndex = 10, Parent = miniBar,
}, { corner(6) })
local miniToggleStroke = stroke(C.Line, 0.3, 1.2)
miniToggleStroke.Parent = miniToggleBtn

local miniLockBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -36, 0.5, 0),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_B, TextSize = 11, TextColor3 = C.Dim, Text = "🔓",
	ZIndex = 12, Parent = miniBar,
}, { corner(5) })
local miniLockStroke = stroke(C.Line, 0.45, 1)
miniLockStroke.Parent = miniLockBtn

local expandBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -8, 0.5, 0),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_K, TextSize = 14, TextColor3 = C.White, Text = "+",
	ZIndex = 12, Parent = miniBar,
}, { corner(5) })
local expandStroke = stroke(C.Line, 0.3, 1.2)
expandStroke.Parent = expandBtn

--------------------------------------------------------------------------
-- Config row (Power / Walk)
--------------------------------------------------------------------------
local powerLbl = label({
	Text = "Power", Font = FONT, TextSize = 10, TextColor3 = C.Sub,
	Position = UDim2.fromOffset(12, 40), Size = UDim2.fromOffset(50, 14), Parent = card,
})
local intBox = new("TextBox", {
	Position = UDim2.fromOffset(12, 55), Size = UDim2.fromOffset(88, 24),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.35, BorderSizePixel = 0,
	Text = tostring(cfg.Intensity), Font = FONT_B, TextSize = 12, TextColor3 = C.Accent,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = card,
}, { corner(6) })
local intBoxStroke = stroke(C.Line, 0.5)
intBoxStroke.Parent = intBox

local walkLbl = label({
	Text = "Walk", Font = FONT, TextSize = 10, TextColor3 = C.Sub,
	Position = UDim2.fromOffset(110, 40), Size = UDim2.fromOffset(50, 14), Parent = card,
})
local walkBtn = new("TextButton", {
	Position = UDim2.fromOffset(110, 55), Size = UDim2.fromOffset(88, 24),
	BackgroundColor3 = C.Raise, AutoButtonColor = false, Font = FONT_K, TextSize = 11,
	TextColor3 = C.White, Text = "APAGADO", Parent = card,
}, { corner(6) })
local walkBtnStroke = stroke(C.Line, 0.35, 1.1)
walkBtnStroke.Parent = walkBtn

local keyLbl = label({
	Text = "Keybind", Font = FONT, TextSize = 10, TextColor3 = C.Sub,
	Position = UDim2.fromOffset(12, 88), Size = UDim2.fromOffset(60, 14), Parent = card,
})
local cap = new("TextButton", {
	Position = UDim2.fromOffset(12, 104), Size = UDim2.fromOffset(186, 24),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.35, AutoButtonColor = false,
	Selectable = true, Text = "", Parent = card,
}, { corner(6) })
local capStroke = stroke(C.Line, 0.5)
capStroke.Parent = cap
local capScale = new("UIScale", { Parent = cap })
local capText = label({
	Text = "", Font = FONT_B, TextSize = 11, TextColor3 = C.White,
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

local studsLbl = label({
	Text = "studs", Font = FONT, TextSize = 10, TextColor3 = C.Dim,
	Position = UDim2.fromOffset(12, 138), Size = UDim2.fromOffset(34, 16), Parent = card,
})
local studsInput = new("TextBox", {
	Position = UDim2.fromOffset(48, 136), Size = UDim2.fromOffset(44, 20),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.35, BorderSizePixel = 0,
	Text = tostring(cfg.WalkStuds), Font = FONT_B, TextSize = 11, TextColor3 = C.Accent,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = card,
}, { corner(5) })
local studsStroke = stroke(C.Line, 0.5)
studsStroke.Parent = studsInput

local delayLbl = label({
	Text = "delay", Font = FONT, TextSize = 10, TextColor3 = C.Dim,
	Position = UDim2.fromOffset(106, 138), Size = UDim2.fromOffset(34, 16), Parent = card,
})
local delayInput = new("TextBox", {
	Position = UDim2.fromOffset(142, 136), Size = UDim2.fromOffset(56, 20),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.35, BorderSizePixel = 0,
	Text = tostring(cfg.WalkDelay), Font = FONT_B, TextSize = 11, TextColor3 = C.Accent,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = card,
}, { corner(5) })
local delayStroke = stroke(C.Line, 0.5)
delayStroke.Parent = delayInput

--------------------------------------------------------------------------
-- Bat Bypass section
--------------------------------------------------------------------------
local batSep = new("Frame", {
	Position = UDim2.fromOffset(12, 164), Size = UDim2.fromOffset(186, 1),
	BackgroundColor3 = C.Line, BackgroundTransparency = 0.5, BorderSizePixel = 0, Parent = card,
})

local batTitle = label({
	Text = "Bat Bypass", Font = FONT_K, TextSize = 11, TextColor3 = C.White,
	Position = UDim2.fromOffset(12, 170), Size = UDim2.fromOffset(100, 16), Parent = card,
})

-- Toggle Bat Bypass
local batBtn = new("TextButton", {
	Position = UDim2.fromOffset(12, 190), Size = UDim2.fromOffset(88, 26),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_K, TextSize = 11, TextColor3 = C.White, Text = "OFF",
	Parent = card,
}, { corner(6) })
local batBtnStroke = stroke(C.Line, 0.35, 1.1)
batBtnStroke.Parent = batBtn
local batBtnScale = new("UIScale", { Parent = batBtn })

-- Version cycle
local verBtn = new("TextButton", {
	Position = UDim2.fromOffset(110, 190), Size = UDim2.fromOffset(88, 26),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_K, TextSize = 11, TextColor3 = C.Accent, Text = "V" .. tostring(cfg.BatVersion),
	Parent = card,
}, { corner(6) })
local verBtnStroke = stroke(C.Line, 0.35, 1.1)
verBtnStroke.Parent = verBtn

-- Speed
local speedLbl = label({
	Text = "Speed", Font = FONT, TextSize = 10, TextColor3 = C.Dim,
	Position = UDim2.fromOffset(12, 224), Size = UDim2.fromOffset(40, 16), Parent = card,
})
local speedBox = new("TextBox", {
	Position = UDim2.fromOffset(52, 222), Size = UDim2.fromOffset(50, 20),
	BackgroundColor3 = C.Raise, BackgroundTransparency = 0.35, BorderSizePixel = 0,
	Text = tostring(cfg.BatSpeed), Font = FONT_B, TextSize = 11, TextColor3 = C.Accent,
	ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Center, Parent = card,
}, { corner(5) })
local speedStroke = stroke(C.Line, 0.5)
speedStroke.Parent = speedBox

-- Mode (only relevant for V4, but always visible)
local modeBtn = new("TextButton", {
	Position = UDim2.fromOffset(112, 222), Size = UDim2.fromOffset(86, 20),
	BackgroundColor3 = C.Raise, AutoButtonColor = false,
	Font = FONT_B, TextSize = 10, TextColor3 = C.Sub,
	Text = (cfg.BatMode == 2) and "TP Bat" or "Bypass",
	Parent = card,
}, { corner(5) })
local modeStroke = stroke(C.Line, 0.5)
modeStroke.Parent = modeBtn

--------------------------------------------------------------------------
-- Main button (Lag)
--------------------------------------------------------------------------
local BTN_W, BTN_H = W - 24, 44
local btn = new("TextButton", {
	Position = UDim2.fromOffset(12, H - 56), Size = UDim2.fromOffset(BTN_W, BTN_H),
	BackgroundColor3 = C.Black, AutoButtonColor = false, Text = "", ClipsDescendants = true, Parent = card,
}, { corner(10) })

local btnShadow = new("Frame", {
	Position = UDim2.fromOffset(12, H - 52), Size = UDim2.fromOffset(BTN_W, BTN_H),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.72,
	BorderSizePixel = 0, ZIndex = 0, Parent = card,
}, { corner(10) })

local btnStroke = stroke(C.Gray, 0.4, 1.15)
btnStroke.Parent = btn
local btnScale = new("UIScale", { Parent = btn })

local wash = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = C.White, BackgroundTransparency = 0.93, BorderSizePixel = 0, Parent = btn,
})
local sweep = new("Frame", {
	Position = UDim2.new(0, -60, 0, 0), Size = UDim2.fromOffset(60, BTN_H),
	BackgroundColor3 = C.White, BackgroundTransparency = 0.9, BorderSizePixel = 0, Visible = false, Parent = btn,
}, {
	new("UIGradient", { Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)
	}) }),
})
local dotRing = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(24, BTN_H / 2), Size = UDim2.fromOffset(10, 10),
	BackgroundTransparency = 1, Parent = btn,
}, { round() })
local ringStroke = stroke(C.White, 1, 1.3)
ringStroke.Parent = dotRing
local ringScale = new("UIScale", { Parent = dotRing })
local dot = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(24, BTN_H / 2), Size = UDim2.fromOffset(8, 8),
	BackgroundColor3 = C.LightGray, BorderSizePixel = 0, Parent = btn,
}, { round() })
local stateText = label({
	Text = "INICIO", Font = FONT_K, TextSize = 15, TextColor3 = C.White,
	Position = UDim2.fromOffset(40, 7), Size = UDim2.new(1, -48, 0, 18), Parent = btn,
})
local subText = label({
	Text = "", Font = FONT, TextSize = 9, TextColor3 = C.LightGray,
	Position = UDim2.fromOffset(40, 26), Size = UDim2.new(1, -48, 0, 12), Parent = btn,
})

--------------------------------------------------------------------------
-- Walk logic
--------------------------------------------------------------------------
local function paintWalk()
	if walking then
		walkBtn.Text = "ENCENDIDO"
		walkBtn.TextColor3 = C.White
		walkBtn.BackgroundColor3 = C.Gray
		tween(walkBtnStroke, 0.2, { Color = C.Accent })
	else
		walkBtn.Text = "APAGADO"
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
-- Lock
--------------------------------------------------------------------------
local function updateLockVisual()
	local icon = locked and "🔒" or "🔓"
	local col = locked and C.Accent or C.Dim
	local strokeCol = locked and C.Accent or C.Line

	lockBtn.Text = icon
	lockBtn.TextColor3 = col
	tween(lockStroke, 0.2, { Color = strokeCol })

	miniLockBtn.Text = icon
	miniLockBtn.TextColor3 = col
	tween(miniLockStroke, 0.2, { Color = strokeCol })
end
updateLockVisual()

local function toggleLock()
	locked = not locked
	cfg.Locked = locked
	save()
	updateLockVisual()
end
lockBtn.MouseButton1Click:Connect(toggleLock)
miniLockBtn.MouseButton1Click:Connect(toggleLock)

--------------------------------------------------------------------------
-- Drag
--------------------------------------------------------------------------
do
	local handle = new("TextButton", {
		Size = UDim2.new(1, -100, 0, 32), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = card,
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
-- Minimize
--------------------------------------------------------------------------
local hideList = {
	title, lockBtn, minBtn,
	powerLbl, intBox, walkLbl, walkBtn,
	keyLbl, cap, studsLbl, studsInput, delayLbl, delayInput,
	batSep, batTitle, batBtn, verBtn, speedLbl, speedBox, modeBtn,
	btn, btnShadow
}

local function setCollapsed(collapsed)
	cfg.Collapsed = collapsed
	save()

	if collapsed then
		for _, v in ipairs(hideList) do v.Visible = false end
		miniBar.Visible = true
		outerShadow.Visible = false
		tween(card, 0.28, { Size = UDim2.fromOffset(W, 32) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
	else
		miniBar.Visible = false
		outerShadow.Visible = true
		for _, v in ipairs(hideList) do v.Visible = true end
		tween(card, 0.38, { Size = UDim2.fromOffset(W, H) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
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
-- Lagging (original)
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
-- BAT BYPASS LOGIC (V1-V4)
--------------------------------------------------------------------------
local batOn = false
local batConn = nil
local swingCooldown = false
local prevAutoRotate = nil

local BAT_NAMES = {
	"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap",
	"Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

local function findBat()
	local char = player.Character
	if not char then return nil end
	for _, name in ipairs(BAT_NAMES) do
		local t = char:FindFirstChild(name)
		if t and t:IsA("Tool") then return t end
	end
	local bp = player:FindFirstChildOfClass("Backpack")
	if bp then
		for _, name in ipairs(BAT_NAMES) do
			local t = bp:FindFirstChild(name)
			if t and t:IsA("Tool") then return t end
		end
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") then
				local n = t.Name:lower()
				if n:find("bat", 1, true) or n:find("slap", 1, true) then return t end
			end
		end
	end
	for _, t in ipairs(char:GetChildren()) do
		if t:IsA("Tool") then
			local n = t.Name:lower()
			if n:find("bat", 1, true) or n:find("slap", 1, true) then return t end
		end
	end
	return nil
end

local function isBatTool(tool)
	if not tool then return false end
	local n = tool.Name:lower()
	return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
end

local function getClosestTarget()
	local char = player.Character
	if not char then return nil, math.huge end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return nil, math.huge end
	local closest, bestDist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local tr = p.Character:FindFirstChild("HumanoidRootPart")
			local ph = p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health > 0 then
				local d = (root.Position - tr.Position).Magnitude
				if d < bestDist then
					bestDist = d
					closest = tr
				end
			end
		end
	end
	return closest, bestDist
end

local function trySwing()
	if swingCooldown then return end
	swingCooldown = true
	pcall(function()
		local char = player.Character
		if not char then return end
		local current = char:FindFirstChildOfClass("Tool")
		if current and not isBatTool(current) then
			swingCooldown = false
			return
		end
		local bat = findBat()
		if bat then
			if bat.Parent ~= char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then pcall(function() hum:EquipTool(bat) end) end
			end
			local remote = bat:FindFirstChildOfClass("RemoteEvent")
			if remote then
				pcall(function() remote:FireServer() end)
			else
				pcall(function() bat:Activate() end)
			end
		end
	end)
	task.delay(0.08, function() swingCooldown = false end)
	task.delay(0.2, function() if swingCooldown then swingCooldown = false end end)
end

local function stopBatBypass()
	if batConn then
		pcall(function() batConn:Disconnect() end)
		batConn = nil
	end
	batOn = false
	swingCooldown = false
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.AutoRotate = (prevAutoRotate == nil) and true or prevAutoRotate
		hum.PlatformStand = false
		pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
	end
	if root then
		root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
		root.AssemblyAngularVelocity = Vector3.zero
		pcall(function()
			if sethiddenproperty then
				sethiddenproperty(root, "PhysicsRepRootPart", nil)
			end
		end)
	end
	prevAutoRotate = nil
end

local function startBatBypass()
	if batConn then return end
	local char0 = player.Character
	if not char0 or not char0:FindFirstChildOfClass("Humanoid") or not char0:FindFirstChild("HumanoidRootPart") then
		return false
	end

	batOn = true
	local hum0 = char0:FindFirstChildOfClass("Humanoid")
	if hum0 then
		if prevAutoRotate == nil then prevAutoRotate = hum0.AutoRotate end
		hum0.AutoRotate = false
	end

	batConn = RunService.Heartbeat:Connect(function()
		if not batOn then return end

		local char = player.Character
		if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum or hum.Health <= 0 then return end

		local state = hum:GetState()
		if state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown then
			return
		end

		-- Auto equip bat
		if not char:FindFirstChildOfClass("Tool") then
			local bat = findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local target, dist = getClosestTarget()
		if not target then
			root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
			return
		end

		local speed = math.clamp(tonumber(cfg.BatSpeed) or 55, 10, 200)
		local version = math.clamp(tonumber(cfg.BatVersion) or 1, 1, 4)
		local mode = (cfg.BatMode == 2) and 2 or 1

		-- Version tuning
		local followDist, hitDist, predictMul, heightOff
		if version == 1 then
			followDist, hitDist, predictMul, heightOff = 1.2, 5.5, 0.12, 1.2
		elseif version == 2 then
			followDist, hitDist, predictMul, heightOff = 0.9, 5.0, 0.16, 1.5
			speed = speed * 1.15
		elseif version == 3 then
			followDist, hitDist, predictMul, heightOff = 1.0, 6.0, 0.20, 2.0
			speed = speed * 1.25
		else -- V4
			followDist, hitDist, predictMul, heightOff = 1.0, 4.8, 0.14, 0.9
		end

		if mode == 2 and version >= 3 then
			-- TP Bat style (more aggressive teleport)
			pcall(function()
				if sethiddenproperty then
					sethiddenproperty(root, "PhysicsRepRootPart", target)
				end
			end)
			local targetPos = target.Position + Vector3.new(0, heightOff, 0)
			if (root.Position - targetPos).Magnitude > 7 then
				root.CFrame = CFrame.new(targetPos)
			else
				local to = (targetPos - root.Position)
				if to.Magnitude > 0.3 then
					root.AssemblyLinearVelocity = to.Unit * speed
				end
			end
			local cam = workspace.CurrentCamera
			if cam then
				cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
			end
			if dist <= hitDist + 1.5 then
				trySwing()
			end
		else
			-- Velocity Bypass style
			local tVel = target.AssemblyLinearVelocity
			local moveDir = (tVel.Magnitude > 0.15) and tVel.Unit or target.CFrame.LookVector
			local offset = moveDir * followDist + Vector3.new(0, heightOff, 0)
			local desired = target.Position + offset + (tVel * predictMul)

			local toTarget = desired - root.Position
			if toTarget.Magnitude > 0.4 then
				local moveVec = toTarget.Unit * speed
				-- slight vertical assist
				local yAssist = math.clamp((desired.Y - root.Position.Y) * 8, -40, 50)
				root.AssemblyLinearVelocity = Vector3.new(moveVec.X, yAssist + moveVec.Y * 0.35, moveVec.Z)
			else
				root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.92
			end

			-- face target
			local flat = Vector3.new(toTarget.X, 0, toTarget.Z)
			if flat.Magnitude > 0.1 then
				local look = CFrame.lookAt(root.Position, root.Position + flat)
				local _, y = look:ToEulerAnglesYXZ()
				root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, y, 0)
			end

			if dist <= hitDist then
				trySwing()
			end
		end
	end)

	return true
end

local function setBatBypass(on)
	on = not not on
	if on == batOn then return end
	if on then
		local ok = startBatBypass()
		if not ok then
			batOn = false
			cfg.BatBypass = false
			return
		end
		cfg.BatBypass = true
	else
		stopBatBypass()
		cfg.BatBypass = false
	end
	save()
	-- visual
	if batOn then
		batBtn.Text = "ON"
		batBtn.BackgroundColor3 = C.Gray
		tween(batBtnStroke, 0.18, { Color = C.Accent })
	else
		batBtn.Text = "OFF"
		batBtn.BackgroundColor3 = C.Raise
		tween(batBtnStroke, 0.18, { Color = C.Line })
	end
end

-- UI bindings for Bat Bypass
local function paintBatVersion()
	verBtn.Text = "V" .. tostring(cfg.BatVersion)
end
local function paintMode()
	modeBtn.Text = (cfg.BatMode == 2) and "TP Bat" or "Bypass"
	modeBtn.TextColor3 = (cfg.BatMode == 2) and C.Accent or C.Sub
end

batBtn.MouseButton1Click:Connect(function()
	setBatBypass(not batOn)
	batBtnScale.Scale = 0.92
	tween(batBtnScale, 0.22, { Scale = 1 }, Enum.EasingStyle.Back)
end)

verBtn.MouseButton1Click:Connect(function()
	cfg.BatVersion = (cfg.BatVersion % 4) + 1
	paintBatVersion()
	save()
	-- if already on, restart with new version
	if batOn then
		stopBatBypass()
		task.defer(function() setBatBypass(true) end)
	end
end)

modeBtn.MouseButton1Click:Connect(function()
	cfg.BatMode = (cfg.BatMode == 2) and 1 or 2
	paintMode()
	save()
	if batOn then
		stopBatBypass()
		task.defer(function() setBatBypass(true) end)
	end
end)

speedBox.FocusLost:Connect(function()
	local v = tonumber(speedBox.Text)
	if v then
		cfg.BatSpeed = math.clamp(math.floor(v), 10, 200)
	end
	speedBox.Text = tostring(cfg.BatSpeed)
	save()
end)

paintBatVersion()
paintMode()
if cfg.BatBypass then
	task.defer(function() setBatBypass(true) end)
end

-- Clean on character respawn
player.CharacterAdded:Connect(function()
	task.wait(0.4)
	if cfg.BatBypass then
		stopBatBypass()
		task.defer(function() setBatBypass(true) end)
	end
end)

--------------------------------------------------------------------------
-- Render (Lag button)
--------------------------------------------------------------------------
local pulseTweens = {}
local function stopPulse()
	for _, t in ipairs(pulseTweens) do t:Cancel() end
	pulseTweens = {}
end

local function render(instant)
	local t = instant and 0 or 0.28
	stopPulse()
	if active then
		tween(wash, t, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Quint)
		tween(btnStroke, t, { Color = C.Accent })
		tween(dot, t, { BackgroundColor3 = C.White })
		stateText.Text = "DETENER"
		sweep.Visible = true
		sweep.Position = UDim2.new(0, -60, 0, 0)

		local loop = TweenInfo.new(1.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1)
		ringStroke.Transparency = 0.3
		ringScale.Scale = 1
		for _, tw in ipairs({
			TweenService:Create(ringScale, loop, { Scale = 2.2 }),
			TweenService:Create(ringStroke, loop, { Transparency = 1 }),
			TweenService:Create(sweep, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), { Position = UDim2.new(1, 0, 0, 0) }),
		}) do
			tw:Play()
			table.insert(pulseTweens, tw)
		end

		miniToggleBtn.Text = "DETENER"
		tween(miniToggleStroke, t, { Color = C.Accent })
	else
		tween(wash, t, { Size = UDim2.fromScale(0, 1) }, Enum.EasingStyle.Quint)
		tween(btnStroke, t, { Color = C.Gray })
		tween(dot, t, { BackgroundColor3 = C.LightGray })
		stateText.Text = "INICIO"
		subText.Text = ""
		sweep.Visible = false
		ringStroke.Transparency = 1

		miniToggleBtn.Text = "INICIO"
		tween(miniToggleStroke, t, { Color = C.Line })
	end
end

setActive = function(v)
	v = v and true or false
	if v == active then return end
	active = v
	activeSince = os.clock()
	render(false)
	if v then startLagging() else stopLagging() end

	btnScale.Scale = 0.94
	tween(btnScale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back)

	for _, fn in ipairs(hooks) do task.spawn(fn, active) end
end

btn.MouseButton1Down:Connect(function() tween(btnScale, 0.08, { Scale = 0.95 }) end)
btn.MouseButton1Up:Connect(function() tween(btnScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back) end)
btn.MouseEnter:Connect(function() if not active then tween(btnStroke, 0.15, { Color = C.LightGray }) end end)
btn.MouseLeave:Connect(function()
	tween(btnScale, 0.16, { Scale = 1 })
	if not active then tween(btnStroke, 0.18, { Color = C.Gray }) end
end)
btn.MouseButton1Click:Connect(function() setActive(not active) end)
miniToggleBtn.MouseButton1Click:Connect(function() setActive(not active) end)

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
cap.MouseButton1Down:Connect(function() tween(capScale, 0.08, { Scale = 0.95 }) end)
cap.MouseButton1Up:Connect(function() tween(capScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back) end)

local function beginKeybindCapture()
	listening = true
	capText.Text = "press..."
	capText.TextColor3 = C.Accent
	tween(capStroke, 0.2, { Color = C.Accent })
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
		capScale.Scale = 0.92
		tween(capScale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back)
	end
end)

--------------------------------------------------------------------------
-- Public
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
	BatBypass = function() return batOn end,
	SetBatBypass = function(v) setBatBypass(v) end,
}

--------------------------------------------------------------------------
-- Start
--------------------------------------------------------------------------
paintWalk()
render(true)
if cfg.Collapsed then
	setCollapsed(true)
else
	card.Size = UDim2.fromOffset(W, 32)
	tween(card, 0.4, { Size = UDim2.fromOffset(W, H) }, Enum.EasingStyle.Quint)
end
save()