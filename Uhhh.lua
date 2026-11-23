--[[
	KYRON - ACTIVATE (Simple + No Lag)
	Solo botón ACTIVATE (V1 + V2 combinados)
	Candado + Arrastre
	Basado 100% en las lógicas del script original
]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Limpiar GUI anterior
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
	Intensity = 10000,
	IntensityV2 = 15000,
}

pcall(function()
	if isfile and isfile(FILE) then
		local data = HttpService:JSONDecode(readfile(FILE))
		for k in pairs(cfg) do
			if data[k] ~= nil then cfg[k] = data[k] end
		end
	end
end)

local function save()
	pcall(function()
		if writefile then
			writefile(FILE, HttpService:JSONEncode(cfg))
		end
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
	Bg     = Color3.fromRGB(14, 15, 18),
	Raise  = Color3.fromRGB(22, 24, 28),
	Line   = Color3.fromRGB(45, 48, 55),
	Dim    = Color3.fromRGB(110, 115, 125),
	Text   = Color3.fromRGB(235, 238, 245),
	White  = Color3.fromRGB(255, 255, 255),
	Gray   = Color3.fromRGB(55, 58, 65),
	Accent = Color3.fromRGB(200, 205, 215),
}

local FONT_B = Enum.Font.GothamBold
local FONT_K = Enum.Font.GothamBold

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
-- Event (igual que el original)
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

--------------------------------------------------------------------------
-- Lag Functions (exactas del original)
--------------------------------------------------------------------------
local active = false
local laggingV1, laggingV2 = false, false
local lagThreadV1, lagThreadV2 = nil, nil

local function startLaggingV1()
	if laggingV1 or not Event then return end
	laggingV1 = true
	local intensity = math.clamp(math.floor(tonumber(cfg.Intensity) or 10000), 1, 100000)
	local payload = table.create(intensity, function() end)
	lagThreadV1 = task.spawn(function()
		while laggingV1 do
			for _ = 1, 3 do
				pcall(function() Event:FireServer(payload) end)
			end
			task.wait(0.01)
		end
	end)
end

local function stopLaggingV1()
	if not laggingV1 then return end
	laggingV1 = false
	if lagThreadV1 then
		pcall(task.cancel, lagThreadV1)
		lagThreadV1 = nil
	end
end

local function startLaggingV2()
	if laggingV2 or not Event then return end
	laggingV2 = true
	local intensity = math.clamp(math.floor(tonumber(cfg.IntensityV2) or 15000), 1000, 1000000)
	local payload = table.create(intensity, function() end)
	lagThreadV2 = task.spawn(function()
		while laggingV2 do
			for _ = 1, 3 do
				pcall(function() Event:FireServer(payload) end)
			end
			task.wait(0.01)
		end
	end)
end

local function stopLaggingV2()
	if not laggingV2 then return end
	laggingV2 = false
	if lagThreadV2 then
		pcall(task.cancel, lagThreadV2)
		lagThreadV2 = nil
	end
end

local function setActivate(v)
	v = v and true or false
	if v == active then return end
	active = v
	if v then
		startLaggingV1()
		startLaggingV2()
	else
		stopLaggingV1()
		stopLaggingV2()
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

local W, H = 180, 70
local locked = cfg.Locked or false

local card = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = unpackPos(cfg.CardPos, UDim2.fromScale(0.5, 0.5)),
	Size = UDim2.fromOffset(W, H),
	BackgroundColor3 = C.Bg,
	BackgroundTransparency = 0.05,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = gui,
}, { corner(12) })

local cardStroke = stroke(C.Line, 0.35, 1.2)
cardStroke.Parent = card

-- Sombra suave
local shadow = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.52),
	Size = UDim2.new(1, 8, 1, 10),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.78,
	BorderSizePixel = 0,
	ZIndex = 0,
	Parent = card,
}, { corner(14) })

--------------------------------------------------------------------------
-- Candado
--------------------------------------------------------------------------
local lockBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -8, 0, 6),
	Size = UDim2.fromOffset(22, 22),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_B,
	TextSize = 12,
	TextColor3 = C.Dim,
	Text = locked and "🔒" or "🔓",
	ZIndex = 10,
	Parent = card,
}, { corner(6) })

local lockStroke = stroke(C.Line, 0.4, 1)
lockStroke.Parent = lockBtn

local function updateLockVisual()
	local icon = locked and "🔒" or "🔓"
	local col = locked and C.Accent or C.Dim
	local strokeCol = locked and C.Accent or C.Line
	lockBtn.Text = icon
	lockBtn.TextColor3 = col
	tween(lockStroke, 0.18, { Color = strokeCol })
end

local function toggleLock()
	locked = not locked
	cfg.Locked = locked
	save()
	updateLockVisual()
end

lockBtn.MouseButton1Click:Connect(toggleLock)
updateLockVisual()

--------------------------------------------------------------------------
-- Botón ACTIVATE
--------------------------------------------------------------------------
local activateBtn = new("TextButton", {
	Position = UDim2.fromOffset(10, 32),
	Size = UDim2.fromOffset(W - 20, 30),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 13,
	TextColor3 = C.White,
	Text = "ACTIVATE",
	ZIndex = 5,
	Parent = card,
}, { corner(8) })

local activateStroke = stroke(C.Line, 0.3, 1.15)
activateStroke.Parent = activateBtn

local activateScale = new("UIScale", { Parent = activateBtn })

local function paintActivate()
	if active then
		activateBtn.Text = "ACTIVATE  ON"
		activateBtn.BackgroundColor3 = C.Gray
		tween(activateStroke, 0.2, { Color = C.Accent })
	else
		activateBtn.Text = "ACTIVATE"
		activateBtn.BackgroundColor3 = C.Raise
		tween(activateStroke, 0.2, { Color = C.Line })
	end
end

activateBtn.MouseButton1Click:Connect(function()
	setActivate(not active)
	paintActivate()
	activateScale.Scale = 0.94
	tween(activateScale, 0.22, { Scale = 1 }, Enum.EasingStyle.Back)
end)

activateBtn.MouseButton1Down:Connect(function()
	tween(activateScale, 0.08, { Scale = 0.95 })
end)

activateBtn.MouseButton1Up:Connect(function()
	tween(activateScale, 0.18, { Scale = 1 }, Enum.EasingStyle.Back)
end)

paintActivate()

--------------------------------------------------------------------------
-- Drag (solo funciona si el candado está abierto)
--------------------------------------------------------------------------
do
	local dragging = false
	local startPos, startInput

	-- Zona de arrastre (toda la parte superior)
	local handle = new("TextButton", {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, -32, 0, 30),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 4,
		Parent = card,
	})

	handle.InputBegan:Connect(function(input)
		if locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = card.Position
			startInput = input.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging or locked then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - startInput
			card.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
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
-- Título pequeño
--------------------------------------------------------------------------
new("TextLabel", {
	Text = "KYRON",
	Font = FONT_K,
	TextSize = 11,
	TextColor3 = C.White,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(12, 6),
	Size = UDim2.fromOffset(80, 20),
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = card,
})

print("[KYRON] ACTIVATE cargado - Listo")