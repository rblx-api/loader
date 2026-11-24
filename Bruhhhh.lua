--[[
	KYRON - ACTIVATE v7
	+ Settings gear | Auto Brainrot | Keybind | Professional UI
	Más fuerte + menos rubberband + todo se guarda
]]

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local HttpService       = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

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
-- Config (todo se guarda)
--------------------------------------------------------------------------
local FILE = "kyron_activate.json"
local cfg = {
	Locked       = false,
	CardPos      = nil,
	Intensity    = 14000,
	IntensityV2  = 22000,
	AutoBrainrot = false,
	Keybind      = "E",          -- tecla por defecto
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
	task.delay(0.25, function()
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
-- Theme profesional (negro / gris / blanco)
--------------------------------------------------------------------------
local C = {
	Bg        = Color3.fromRGB(10, 11, 14),
	Raise     = Color3.fromRGB(18, 20, 24),
	Raise2    = Color3.fromRGB(26, 28, 34),
	Line      = Color3.fromRGB(45, 48, 56),
	Dim       = Color3.fromRGB(110, 115, 125),
	Text      = Color3.fromRGB(225, 228, 235),
	White     = Color3.fromRGB(255, 255, 255),
	Gray      = Color3.fromRGB(55, 60, 70),
	Accent    = Color3.fromRGB(200, 210, 225),
	Glow      = Color3.fromRGB(170, 185, 210),
	Success   = Color3.fromRGB(90, 200, 140),
	Danger    = Color3.fromRGB(220, 90, 90),
}

local FONT_K = Enum.Font.GothamBold
local FONT_R = Enum.Font.Gotham

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

local function padding(t, b, l, r)
	return new("UIPadding", {
		PaddingTop = UDim.new(0, t or 0),
		PaddingBottom = UDim.new(0, b or 0),
		PaddingLeft = UDim.new(0, l or 0),
		PaddingRight = UDim.new(0, r or 0),
	})
end

--------------------------------------------------------------------------
-- Event (igual que v6)
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
-- Lag Functions v6 (intactas)
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

			-- === TIMING ANTI-RUBBERBAND ===
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
-- AUTO BRAINROT detection
--------------------------------------------------------------------------
local autoConn = nil
local function isBrainrot(obj)
	if not obj then return false end
	-- Detecta Tools o Models que suelen ser brainrots / pets agarrables
	if obj:IsA("Tool") then return true end
	if obj:IsA("Model") and (obj:FindFirstChildWhichIsA("BasePart") or obj:FindFirstChild("Humanoid")) then
		return true
	end
	return false
end

local function setupAutoBrainrot(char)
	if autoConn then
		autoConn:Disconnect()
		autoConn = nil
	end
	if not char then return end

	autoConn = char.ChildAdded:Connect(function(child)
		if not cfg.AutoBrainrot then return end
		if isBrainrot(child) then
			-- Pequeño delay para que el grab termine
			task.delay(0.12, function()
				if cfg.AutoBrainrot and child.Parent == char then
					setActivate(true)
					-- Actualizar visuales del botón principal
					if paintActivate then paintActivate() end
					if paintSettingsActivate then paintSettingsActivate() end
				end
			end)
		end
	end)
end

player.CharacterAdded:Connect(setupAutoBrainrot)
if player.Character then
	setupAutoBrainrot(player.Character)
end

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

local W, H = 200, 78
local locked = cfg.Locked or false
local settingsOpen = false
local listeningKeybind = false

local card = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = unpackPos(cfg.CardPos, UDim2.fromScale(0.5, 0.5)),
	Size = UDim2.fromOffset(W, H),
	BackgroundColor3 = C.Bg,
	BackgroundTransparency = 0.03,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = gui,
}, { corner(14) })

local cardStroke = stroke(C.Line, 0.35, 1.3)
cardStroke.Parent = card

-- Soft shadow
new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.54),
	Size = UDim2.new(1, 14, 1, 16),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0.78,
	BorderSizePixel = 0,
	ZIndex = 0,
	Parent = card,
}, { corner(18) })

local cardScale = new("UIScale", { Scale = 0.86, Parent = card })
tween(cardScale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back):Play()

--------------------------------------------------------------------------
-- Título
--------------------------------------------------------------------------
new("TextLabel", {
	Text = "KYRON",
	Font = FONT_K,
	TextSize = 12,
	TextColor3 = C.White,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(14, 9),
	Size = UDim2.fromOffset(70, 18),
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = card,
})

--------------------------------------------------------------------------
-- Botones superiores: Settings (tuerca) + Candado
--------------------------------------------------------------------------
-- Candado
local lockBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -8, 0, 7),
	Size = UDim2.fromOffset(26, 26),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 13,
	TextColor3 = C.Dim,
	Text = locked and "🔒" or "🔓",
	ZIndex = 12,
	Parent = card,
}, { corner(8) })

local lockStroke = stroke(C.Line, 0.35, 1)
lockStroke.Parent = lockBtn
local lockScale = new("UIScale", { Parent = lockBtn })

-- Tuerca (Settings)
local settingsBtn = new("TextButton", {
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, -38, 0, 7),
	Size = UDim2.fromOffset(26, 26),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 14,
	TextColor3 = C.Dim,
	Text = "⚙",
	ZIndex = 12,
	Parent = card,
}, { corner(8) })

local settingsStroke = stroke(C.Line, 0.35, 1)
settingsStroke.Parent = settingsBtn
local settingsScale = new("UIScale", { Parent = settingsBtn })

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
	lockScale.Scale = 0.78
	tween(lockScale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back):Play()
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
-- Settings Panel (pequeño, profesional)
--------------------------------------------------------------------------
local settingsPanel = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 1, 8),
	Size = UDim2.fromOffset(W, 0),
	BackgroundColor3 = C.Bg,
	BackgroundTransparency = 0.02,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Visible = false,
	ZIndex = 20,
	Parent = card,
}, { corner(12) })

local settingsStrokePanel = stroke(C.Line, 0.3, 1.2)
settingsStrokePanel.Parent = settingsPanel

local settingsContent = new("Frame", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Parent = settingsPanel,
})

-- Título del panel
new("TextLabel", {
	Text = "SETTINGS",
	Font = FONT_K,
	TextSize = 11,
	TextColor3 = C.Dim,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(12, 10),
	Size = UDim2.fromOffset(100, 16),
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = settingsContent,
})

-- === AUTO BRAINROT ===
local autoBtn = new("TextButton", {
	Position = UDim2.fromOffset(10, 32),
	Size = UDim2.fromOffset(W - 20, 30),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 12,
	TextColor3 = C.Text,
	Text = "",
	ZIndex = 21,
	Parent = settingsContent,
}, { corner(8) })

local autoStroke = stroke(C.Line, 0.3, 1)
autoStroke.Parent = autoBtn

local autoLabel = new("TextLabel", {
	Text = "AUTO BRAINROT",
	Font = FONT_K,
	TextSize = 12,
	TextColor3 = C.Text,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 0),
	Size = UDim2.new(1, -50, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = autoBtn,
})

local autoStatus = new("TextLabel", {
	Text = "OFF",
	Font = FONT_K,
	TextSize = 11,
	TextColor3 = C.Dim,
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.fromOffset(36, 20),
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = autoBtn,
})

local function paintAuto()
	if cfg.AutoBrainrot then
		autoStatus.Text = "ON"
		tween(autoStatus, 0.18, { TextColor3 = C.Success }):Play()
		tween(autoStroke, 0.18, { Color = C.Accent }):Play()
		tween(autoBtn, 0.18, { BackgroundColor3 = C.Raise2 }):Play()
	else
		autoStatus.Text = "OFF"
		tween(autoStatus, 0.18, { TextColor3 = C.Dim }):Play()
		tween(autoStroke, 0.18, { Color = C.Line }):Play()
		tween(autoBtn, 0.18, { BackgroundColor3 = C.Raise }):Play()
	end
end

autoBtn.MouseButton1Click:Connect(function()
	cfg.AutoBrainrot = not cfg.AutoBrainrot
	save()
	paintAuto()
	-- micro feedback
	autoBtn:FindFirstChildOfClass("UIScale") or new("UIScale", { Parent = autoBtn })
	local s = autoBtn:FindFirstChildOfClass("UIScale")
	s.Scale = 0.94
	tween(s, 0.22, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end)

autoBtn.MouseEnter:Connect(function()
	if not cfg.AutoBrainrot then
		tween(autoBtn, 0.12, { BackgroundColor3 = C.Raise2 }):Play()
	end
end)
autoBtn.MouseLeave:Connect(function()
	if not cfg.AutoBrainrot then
		tween(autoBtn, 0.15, { BackgroundColor3 = C.Raise }):Play()
	end
end)
paintAuto()

-- === KEYBIND ===
local keybindBtn = new("TextButton", {
	Position = UDim2.fromOffset(10, 68),
	Size = UDim2.fromOffset(W - 20, 30),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 12,
	TextColor3 = C.Text,
	Text = "",
	ZIndex = 21,
	Parent = settingsContent,
}, { corner(8) })

local keybindStroke = stroke(C.Line, 0.3, 1)
keybindStroke.Parent = keybindBtn

new("TextLabel", {
	Text = "KEYBIND",
	Font = FONT_K,
	TextSize = 12,
	TextColor3 = C.Text,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 0),
	Size = UDim2.new(1, -70, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = keybindBtn,
})

local keybindValue = new("TextLabel", {
	Text = tostring(cfg.Keybind or "E"),
	Font = FONT_K,
	TextSize = 12,
	TextColor3 = C.Accent,
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.fromOffset(50, 20),
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = keybindBtn,
})

local function startListeningKeybind()
	if listeningKeybind then return end
	listeningKeybind = true
	keybindValue.Text = "..."
	tween(keybindValue, 0.15, { TextColor3 = C.White }):Play()
	tween(keybindStroke, 0.15, { Color = C.Accent }):Play()

	local conn
	conn = UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			local keyName = input.KeyCode.Name
			cfg.Keybind = keyName
			save()
			keybindValue.Text = keyName
			tween(keybindValue, 0.2, { TextColor3 = C.Accent }):Play()
			tween(keybindStroke, 0.2, { Color = C.Line }):Play()
			listeningKeybind = false
			conn:Disconnect()
		end
	end)
end

keybindBtn.MouseButton1Click:Connect(function()
	startListeningKeybind()
end)

keybindBtn.MouseEnter:Connect(function()
	if not listeningKeybind then
		tween(keybindBtn, 0.12, { BackgroundColor3 = C.Raise2 }):Play()
	end
end)
keybindBtn.MouseLeave:Connect(function()
	if not listeningKeybind then
		tween(keybindBtn, 0.15, { BackgroundColor3 = C.Raise }):Play()
	end
end)

-- === ACTIVATE (dentro de settings) ===
local settingsActivateBtn = new("TextButton", {
	Position = UDim2.fromOffset(10, 104),
	Size = UDim2.fromOffset(W - 20, 32),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 13,
	TextColor3 = C.White,
	Text = "ACTIVATE",
	ZIndex = 21,
	Parent = settingsContent,
}, { corner(9) })

local settingsActivateStroke = stroke(C.Line, 0.25, 1.2)
settingsActivateStroke.Parent = settingsActivateBtn
local settingsActivateScale = new("UIScale", { Parent = settingsActivateBtn })

local function paintSettingsActivate()
	if active then
		settingsActivateBtn.Text = "ACTIVATE  ON"
		tween(settingsActivateBtn, 0.2, { BackgroundColor3 = C.Gray }):Play()
		tween(settingsActivateStroke, 0.2, { Color = C.Accent }):Play()
	else
		settingsActivateBtn.Text = "ACTIVATE"
		tween(settingsActivateBtn, 0.2, { BackgroundColor3 = C.Raise }):Play()
		tween(settingsActivateStroke, 0.2, { Color = C.Line }):Play()
	end
end

settingsActivateBtn.MouseButton1Click:Connect(function()
	setActivate(not active)
	paintActivate()
	paintSettingsActivate()
	settingsActivateScale.Scale = 0.93
	tween(settingsActivateScale, 0.25, { Scale = 1 }, Enum.EasingStyle.Back):Play()
end)

settingsActivateBtn.MouseEnter:Connect(function()
	if not active then
		tween(settingsActivateBtn, 0.12, { BackgroundColor3 = C.Raise2 }):Play()
	end
end)
settingsActivateBtn.MouseLeave:Connect(function()
	if not active then
		tween(settingsActivateBtn, 0.15, { BackgroundColor3 = C.Raise }):Play()
	end
end)

-- Función para abrir / cerrar settings
local function toggleSettings()
	settingsOpen = not settingsOpen
	if settingsOpen then
		settingsPanel.Visible = true
		settingsPanel.Size = UDim2.fromOffset(W, 0)
		tween(settingsPanel, 0.28, { Size = UDim2.fromOffset(W, 148) }, Enum.EasingStyle.Quint):Play()
		tween(settingsBtn, 0.2, { TextColor3 = C.Accent, BackgroundColor3 = C.Raise2 }):Play()
		tween(settingsStroke, 0.2, { Color = C.Accent }):Play()
		settingsScale.Scale = 0.82
		tween(settingsScale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back):Play()
	else
		local t = tween(settingsPanel, 0.22, { Size = UDim2.fromOffset(W, 0) }, Enum.EasingStyle.Quint)
		t:Play()
		t.Completed:Connect(function()
			if not settingsOpen then
				settingsPanel.Visible = false
			end
		end)
		tween(settingsBtn, 0.2, { TextColor3 = C.Dim, BackgroundColor3 = C.Raise }):Play()
		tween(settingsStroke, 0.2, { Color = C.Line }):Play()
	end
end

settingsBtn.MouseButton1Click:Connect(toggleSettings)
settingsBtn.MouseEnter:Connect(function()
	if not settingsOpen then
		tween(settingsBtn, 0.12, { BackgroundColor3 = C.Line }):Play()
	end
end)
settingsBtn.MouseLeave:Connect(function()
	if not settingsOpen then
		tween(settingsBtn, 0.18, { BackgroundColor3 = C.Raise }):Play()
	end
end)

--------------------------------------------------------------------------
-- Botón ACTIVATE principal
--------------------------------------------------------------------------
local activateBtn = new("TextButton", {
	Position = UDim2.fromOffset(12, 38),
	Size = UDim2.fromOffset(W - 24, 32),
	BackgroundColor3 = C.Raise,
	AutoButtonColor = false,
	Font = FONT_K,
	TextSize = 13,
	TextColor3 = C.White,
	Text = "ACTIVATE",
	ZIndex = 6,
	Parent = card,
}, { corner(9) })

local activateStroke = stroke(C.Line, 0.25, 1.2)
activateStroke.Parent = activateBtn
local activateScale = new("UIScale", { Parent = activateBtn })

local glow = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = C.Glow,
	BackgroundTransparency = 0.86,
	BorderSizePixel = 0,
	ZIndex = 1,
	Parent = activateBtn,
}, { corner(9) })

function paintActivate()
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
	paintSettingsActivate()
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
-- Keybind global
--------------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or listeningKeybind then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode.Name == tostring(cfg.Keybind) then
			setActivate(not active)
			paintActivate()
		end
	end
end)

--------------------------------------------------------------------------
-- Drag + Guardar posición
--------------------------------------------------------------------------
do
	local dragging = false
	local startPos, startInput

	local handle = new("TextButton", {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, -70, 0, 34),
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
			tween(cardStroke, 0.12, { Color = C.Accent, Transparency = 0.2 }):Play()
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
			tween(cardStroke, 0.25, { Color = C.Line, Transparency = 0.35 }):Play()
		end
	end)
end

--------------------------------------------------------------------------
-- Pulse cuando está activo
--------------------------------------------------------------------------
task.spawn(function()
	while card and card.Parent do
		if active then
			tween(activateStroke, 0.8, { Transparency = 0.45 }):Play()
			task.wait(0.8)
			if active then
				tween(activateStroke, 0.8, { Transparency = 0.15 }):Play()
			end
			task.wait(0.8)
		else
			task.wait(0.5)
		end
	end
end)

print("[KYRON] ACTIVATE v7 listo — Settings + Auto Brainrot + Keybind")