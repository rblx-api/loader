--[[
	KYRON - ACTIVATE v8 (Configuración y tuerca corregidas)
]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Limpiar versiones anteriores
pcall(function()
	local old = playerGui:FindFirstChild("KYRON_ACTIVATE")
	if old then old:Destroy() end
	if gethui then
		local h = gethui()
		local o = h:FindFirstChild("KYRON_ACTIVATE")
		if o then o:Destroy() end
	end
end)

--------------------------------------------------------------------------
-- Configuración y Persistencia
--------------------------------------------------------------------------
local FILE = "kyron_activate_v8.json"
local cfg = {
	Locked = false,
	CardPos = nil,
	Intensity = 14000,
	IntensityV2 = 22000,
	Keybind = "F",
	AutoBrainrot = true,
	BrainrotDelay = 4,
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
	task.delay(0.3, function()
		if token ~= saveToken then return end
		pcall(function()
			if writefile then
				writefile(FILE, HttpService:JSONEncode(cfg))
			end
		end)
	end)
end

local function packPos(p)
	return { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
end

local function unpackPos(t, fallback)
	if type(t) == "table" and #t == 4 then
		return UDim2.new(t[1], t[2], t[3], t[4])
	end
	return fallback
end

--------------------------------------------------------------------------
-- Theme / Estilos Visuales
--------------------------------------------------------------------------
local C = {
	Bg      = Color3.fromRGB(12, 13, 16),
	Raise   = Color3.fromRGB(20, 22, 26),
	Line    = Color3.fromRGB(42, 45, 52),
	Dim     = Color3.fromRGB(100, 105, 115),
	Text    = Color3.fromRGB(230, 233, 240),
	White   = Color3.fromRGB(255, 255, 255),
	Gray    = Color3.fromRGB(48, 52, 60),
	Accent  = Color3.fromRGB(190, 200, 215),
	Glow    = Color3.fromRGB(160, 175, 200),
	Green   = Color3.fromRGB(46, 204, 113),
	Red     = Color3.fromRGB(231, 76, 60),
}

local FONT_K = Enum.Font.GothamBold

local function new(class, props, kids)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do o[k] = v end
	for _, c in ipairs(kids or {}) do c.Parent = o end
	return o
end

local function tween(o, t, props, style, dir)
	return TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
end

local function corner(r)
	return new("UICorner", { CornerRadius = UDim.new(0, r) })
end

local function stroke(col, tr, th)
	return new("UIStroke", {
		Color = col,
		Transparency = tr or 0,
		Thickness = th or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})
end

--------------------------------------------------------------------------
-- Event
--------------------------------------------------------------------------
local Event
do
	local ok, net = pcall(function()
		local pkgs = ReplicatedStorage:WaitForChild("Packages", 4)
		return pkgs and pkgs:WaitForChild("Net", 4)
	end)
	if ok and net then
		Event = net:GetChildren()[6]
	end
end

--------------------------------------------------------------------------
-- Lógica Principal de Lag
--------------------------------------------------------------------------
local active = false
local lagging = false
local lagThread = nil
local payloadV1, payloadV2 = nil, nil

local function buildPayload(size)
	local t = table.create(size)
	for i = 1, size do
		t[i] = function() end
	end
	return t
end

local function startLagging()
	if lagging or not Event then return end
	lagging = true

	local intensity1 = math.clamp(math.floor(tonumber(cfg.Intensity) or 14000), 1, 200000)
	local intensity2 = math.clamp(math.floor(tonumber(cfg.IntensityV2) or 22000), 1000, 900000)

	if not payloadV1 or #payloadV1 ~= intensity1 then
		payloadV1 = buildPayload(intensity1)
	end
	if not payloadV2 or #payloadV2 ~= intensity2 then
		payloadV2 = buildPayload(intensity2)
	end

	lagThread = task.spawn(function()
		local cycle = 0
		while lagging do
			cycle += 1
			pcall(function()
				Event:FireServer(payloadV1)
				Event:FireServer(payloadV2)
				Event:FireServer(payloadV1)
				Event:FireServer(payloadV2)
				Event:FireServer(payloadV1)
				Event:FireServer(payloadV2)
				Event:FireServer(payloadV2)

				if cycle % 3 == 0 then
					Event:FireServer(payloadV1)
					Event:FireServer(payloadV2)
					Event:FireServer(payloadV1)
					Event:FireServer(payloadV2)
				end
			end)

			if cycle % 4 == 0 then
				task.wait(0.045)
			else
				task.wait(0.016)
			end
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

local setActivate

--------------------------------------------------------------------------
-- GUI Principal
--------------------------------------------------------------------------
local gui = new("ScreenGui", {
	Name = "KYRON_ACTIVATE",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 999,
})

pcall(function()
	if gethui then gui.Parent = gethui() end
end)
if not gui.Parent then
	gui.Parent = playerGui
end

local W, H = 186, 74
local locked = cfg.Locked or false

local card = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = unpackPos(cfg.CardPos, UDim2.fromScale(0.5, 0.5)),
	Size = UDim2.fromOffset(W, H),
	BackgroundColor3 = C.Bg,
	BackgroundTransparency = 0.04,
	BorderSizePixel = 0,
	ClipsDescendants = false, -- Cambiado a false para que la config sobresalga bien
	Parent = gui,
}, { corner(14) })

local cardStroke = stroke(C.Line, 0.4, 1.25)
cardStroke.Parent = card

new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.53),
	Size = UDim2.new(1, 10, 1, 12),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.8,
	BorderSizePixel = 0,
	ZIndex = 0,
	Parent = card,
}, { corner(16) })

-- Título
new("TextLabel", {
	Text = "KYRON",
	Font = FONT_K,
	TextSize = 11,
	TextColor3 = C.White,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(12, 7),
	Size = UDim2.fromOffset(70, 18),
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = card,
})

--------------------------------------------------------------------------
-- Panel de Configuración (Corregido y Visible)
--------------------------------------------------------------------------
local configPanel = new("Frame", {
	AnchorPoint = Vector2.new(0, 0),
	Position = UDim2.new(1, 8, 0, 0), -- Se alinea perfectamente al borde derecho de la tarjeta
	Size = UDim2.fromOffset(160, 175),
	BackgroundColor3 = C.Bg,
	BackgroundTransparency = 0.04,
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 50,
	Parent = card,
}, { corner(12), stroke(C.Line, 0.3, 1) })

-- Título Config
new("TextLabel", {
	Text = "CONFIGURACIÓN",
	Font = FONT_K,
	TextSize = 10,
	TextColor3 = C.Accent,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 8),
	Size = UDim2.fromOffset(140, 15),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 51,
	Parent = configPanel,
})

-- Power Slider / Input
new("TextLabel", {
	Text = "Power (Intensidad):",
	Font = Enum.Font.Gotham,
	TextSize = 9,
	TextColor3 = C.Dim,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 26),
	Size = UDim2.fromOffset(140, 14),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 51,
	Parent = configPanel,
})

local powerBox = new("TextBox", {
	Text = tostring(cfg.Intensity),
	Font = FONT_K,
	TextSize = 11,
	TextColor3 = C.White,
	BackgroundColor3 = C.Raise,
	Position = UDim2.fromOffset(10, 42),
	Size = UDim2.fromOffset(140, 22),
	ClearTextOnFocus = false,
	ZIndex = 51,
	Parent = configPanel,
}, { corner(6), stroke(C.Line, 0.4, 1) })

powerBox.FocusLost:Connect(function()
	local val = tonumber(powerBox.Text)
	if val then
		cfg.Intensity = math.clamp(val, 1, 200000)
		cfg.IntensityV2 = math.clamp(math.floor(val * 1.57), 1000, 900000)
		powerBox.Text = tostring(cfg.Intensity)
		save()
	else
		powerBox.Text = tostring(cfg.Intensity)
	end
end)

-- Keybind Opción
new("TextLabel", {
	Text = "Tecla de Activación:",
	Font = Enum.Font.Gotham,
	TextSize = 9,
	TextColor3 = C.Dim,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 68),
	Size = UDim2.fromOffset(140, 14),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 51,
	Parent = configPanel,
})

local keybindBtn = new("TextButton", {
	Text = "Key: " .. tostring(cfg.Keybind),
	Font = FONT_K,
	TextSize = 10,
	TextColor3 = C.White,
	BackgroundColor3 = C.Raise,
	Position = UDim2.fromOffset(10, 84),
	Size = UDim2.fromOffset(140, 22),
	AutoButtonColor = false,
	ZIndex = 51,
	Parent = configPanel,
}, { corner(6), stroke(C.Line, 0.4, 1) })

local listeningKey = false
keybindBtn.MouseButton1Click:Connect(function()
	listeningKey = true
	keybindBtn.Text = "Presiona una tecla..."
	tween(keybindBtn, 0.15, { TextColor3 = C.Accent }):Play()
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if listeningKey then
		if input.UserInputType == Enum.UserInputType.Keyboard then
			cfg.Keybind = input.KeyCode.Name
			keybindBtn.Text = "Key: " .. cfg.Keybind
			listeningKey = false
			save()
			tween(keybindBtn, 0.15, { TextColor3 = C.White }):Play()
		end
		return
	end

	if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode.Name == cfg.Keybind then
			if setActivate then
				setActivate(not active)
			end
		end
	end
end)

-- Auto Brainrot Toggle
local autoBrainBtn = new("TextButton", {
	Text = "Auto Brainrot: ON",
	Font = FONT_K,
	TextSize = 10,
	TextColor3 = C.Green,
	BackgroundColor3 = C.Raise,
	Position = UDim2.fromOffset(10, 112),
	Size = UDim2.fromOffset(140, 24),
	AutoButtonColor = false,
	ZIndex = 51,
	Parent = configPanel,
}, { corner(6), stroke(C.Line, 0.4, 1) })

local function updateAutoBrainVisual()
	if cfg.AutoBrainrot then
		autoBrainBtn.Text = "Auto Brainrot: ON"
		autoBrainBtn.TextColor3 = C.Green
	else
		autoBrainBtn.Text = "Auto Brainrot: OFF"
		autoBrainBtn.TextColor3 = C.Red
	end
end
updateAutoBrainVisual()

autoBrainBtn.MouseButton1Click:Connect(function()
	cfg.AutoBrainrot = not cfg.AutoBrainrot
	updateAutoBrainVisual()
	save()
end)

-- Timer Info Label (4 segundos)
new("TextLabel", {
	Text = "Timer Base: 4s [Robo Activo]",
	Font = Enum.Font.Gotham,
	TextSize = 8,
	TextColor3 = C.Dim,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 142),
	Size = UDim2.fromOffset(140, 24),
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Center,
	ZIndex = 51,
	Parent = configPanel,
})

--------------------------------------------------------------------------
-- Botón Config (Engranaje ⚙) al lado del Candado
--------------------------------------------------------------------------
local configBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -34, 0, 6),
	Size = UDim2.fromOffset(24, 24),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 12,
	TextColor3 = C.Dim,
	Text = "⚙",
	ZIndex = 20,
	Parent = card,
}, { corner(7), stroke(C.Line, 0.4, 1) })

configBtn.MouseButton1Click:Connect(function()
	local willBeVisible = not configPanel.Visible
	if willBeVisible then
		configPanel.Visible = true
		configPanel.Size = UDim2.fromOffset(160, 0)
		tween(configPanel, 0.25, { Size = UDim2.fromOffset(160, 175) }, Enum.EasingStyle.Back):Play()
	else
		task.spawn(function()
			tween(configPanel, 0.15, { Size = UDim2.fromOffset(160, 0) }):Play()
			task.wait(0.15)
			configPanel.Visible = false
		end)
	end
end)

--------------------------------------------------------------------------
-- Candado
--------------------------------------------------------------------------
local locked = cfg.Locked or false
local lockBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -8, 0, 6),
	Size = UDim2.fromOffset(24, 24),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 13,
	TextColor3 = C.Dim,
	Text = locked and "🔒" or "🔓",
	ZIndex = 20,
	Parent = card,
}, { corner(7), stroke(C.Line, 0.4, 1) })

local lockScale = new("UIScale", { Parent = lockBtn })

local function updateLockVisual()
	local icon = locked and "🔒" or "🔓"
	local col = locked and C.Accent or C.Dim
	lockBtn.Text = icon
	tween(lockBtn, 0.18, { TextColor3 = col }):Play()
end

lockBtn.MouseButton1Click:Connect(function()
	locked = not locked
	cfg.Locked = locked
	save()
	updateLockVisual()
	lockScale.Scale = 0.8
	tween(lockScale, 0.25, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end)
updateLockVisual()

--------------------------------------------------------------------------
-- Botón ACTIVATE Principal
--------------------------------------------------------------------------
local activateBtn = new("TextButton", {
	Position = UDim2.fromOffset(10, 34),
	Size = UDim2.fromOffset(W - 20, 32),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 13,
	TextColor3 = C.White,
	Text = "ACTIVATE",
	ZIndex = 10,
	Parent = card,
}, { corner(9) })

local activateStroke = stroke(C.Line, 0.3, 1.2)
activateStroke.Parent = activateBtn

local activateScale = new("UIScale", { Parent = activateBtn })

local glow = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = C.Glow,
	BackgroundTransparency = 0.88,
	BorderSizePixel = 0,
	ZIndex = 1,
	Parent = activateBtn,
}, { corner(9) })

local function paintActivate()
	if active then
		activateBtn.Text = "ACTIVATE  ON"
		tween(activateBtn, 0.22, { BackgroundColor3 = C.Gray }):Play()
		tween(activateStroke, 0.22, { Color = C.Accent }):Play()
		tween(glow, 0.3, { Size = UDim2.fromScale(1, 1) }):Play()
	else
		activateBtn.Text = "ACTIVATE"
		tween(activateBtn, 0.22, { BackgroundColor3 = C.Raise }):Play()
		tween(activateStroke, 0.22, { Color = C.Line }):Play()
		tween(glow, 0.25, { Size = UDim2.fromScale(0, 1) }):Play()
	end
end

setActivate = function(v)
	v = not not v
	if v == active then return end
	active = v
	if v then
		startLagging()
	else
		stopLagging()
	end
	paintActivate()
end

activateBtn.MouseButton1Click:Connect(function()
	setActivate(not active)
	activateScale.Scale = 0.93
	tween(activateScale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end)

activateBtn.MouseButton1Down:Connect(function()
	tween(activateScale, 0.07, { Scale = 0.94 }):Play()
end)

activateBtn.MouseButton1Up:Connect(function(	)
	tween(activateScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end)

paintActivate()

--------------------------------------------------------------------------
-- Lógica del Brainrot con Timer de 4 Segundos
--------------------------------------------------------------------------
local robbingActive = false
local function triggerBrainrotRobbery()
	if robbingActive then return end
	robbingActive = true

	if cfg.AutoBrainrot and not active then
		setActivate(true)
	end

	task.wait(cfg.BrainrotDelay)

	pcall(function()
		if Event and payloadV1 then
			Event:FireServer(payloadV1)
		end
	end)

	task.wait(0.5)
	robbingActive = false
end

getgenv().TriggerBrainrotWithTimer = function()
	triggerBrainrotRobbery()
end

--------------------------------------------------------------------------
-- Sistema de Arrastre (Drag)
--------------------------------------------------------------------------
do
	local dragging = false
	local startPos, startInput

	local handle = new("TextButton", {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, -60, 0, 32),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 5,
		Parent = card,
	})

	handle.InputBegan:Connect(function(input)
		if locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = card.Position
			startInput = input.Position
			tween(cardStroke, 0.12, { Color = C.Accent, Transparency = 0.25 }):Play()
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging or locked then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - startInput
			card.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			cfg.CardPos = packPos(card.Position)
			save()
			tween(cardStroke, 0.25, { Color = C.Line, Transparency = 0.4 }):Play()
		end
	end)
end

--------------------------------------------------------------------------
-- Animación de Pulso Activo
--------------------------------------------------------------------------
task.spawn(function()
	while card and card.Parent do
		if active then
			tween(activateStroke, 0.85, { Transparency = 0.5 }):Play()
			task.wait(0.85)
			if active then
				tween(activateStroke, 0.85, { Transparency = 0.18 }):Play()
			end
			task.wait(0.85)
		else
			task.wait(0.6)
		end
	end
end)

print("[KYRON] ACTIVATE v8 — Interfaz de configuración reparada y funcionando.")