-- stick packet lagger + Auto Steal + Rival Packer Lag
-- LocalScript / Executor
-- START = Lag | ACTIVAR AUTO STEAL = Auto Steal
-- POWER = Intensidad del lag (omahad power)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
if not player then return end
local pg = player:WaitForChild("PlayerGui")

-- Limpiar GUIs anteriores
for _, name in ipairs({"SickPacketChristmasVisual", "QWRPacketLagger", "SickPacketVisual", "StickPacketLagger", "GalaxyGui", "SickPacketBar", "RivalPackerLagger"}) do
	local old = pg:FindFirstChild(name)
	if old then old:Destroy() end
end

pcall(function()
	if _G.K7NormalSteal and _G.K7NormalSteal.stealConn then
		_G.K7NormalSteal.stealConn:Disconnect()
		_G.K7NormalSteal.stealConn = nil
	end
	_G.K7NormalSteal = nil
	if _G.K7V3Steal and _G.K7V3Steal.conn then
		_G.K7V3Steal.conn:Disconnect()
		_G.K7V3Steal.conn = nil
	end
	_G.K7V3Steal = nil
	if _G.K7SemiSteal and _G.K7SemiSteal.conn then
		_G.K7SemiSteal.conn:Disconnect()
		_G.K7SemiSteal.conn = nil
	end
	_G.K7SemiSteal = nil
end)

local getconnections = getconnections or (getgenv and getgenv().getconnections) or get_signal_cons or (syn and syn.get_signal_cons)

-------------------------------------------------
-- BUSCAR EVENTO DE LAG (igual que Rival Packer)
-------------------------------------------------
local Event
do
	local ok, net = pcall(function()
		return RS:WaitForChild("Packages", 3):WaitForChild("Net", 3)
	end)
	if ok and net then
		local kids = net:GetChildren()
		Event = kids[230]
	end
end

-------------------------------------------------
-- UI NAVIDEÑA (stick packet lagger)
-------------------------------------------------
local gui = Instance.new("ScreenGui", pg)
gui.Name = "StickPacketLagger"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

local function round(obj, radius)
	local c = Instance.new("UICorner", obj)
	c.CornerRadius = UDim.new(0, radius)
end

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(230, 210)
main.Position = UDim2.new(0.5, -115, 0.5, -105)
main.BackgroundColor3 = Color3.new(1, 1, 1)
main.BorderSizePixel = 0
main.Active = true
round(main, 12)

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 65, 42)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(8, 32, 28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 18, 28))
})
gradient.Rotation = 45

local border = Instance.new("UIStroke", main)
border.Color = Color3.fromRGB(255, 207, 90)
border.Transparency = 0.5
border.Thickness = 2

local function label(text, pos, size, fontSize)
	local l = Instance.new("TextLabel", main)
	l.BackgroundTransparency = 1
	l.Position = pos
	l.Size = size
	l.Text = text
	l.TextColor3 = Color3.fromRGB(245, 248, 240)
	l.Font = Enum.Font.GothamBold
	l.TextSize = fontSize
	l.ZIndex = 3
	return l
end

local random = Random.new(25)
for i = 1, 18 do
	local snow = label(i % 6 == 0 and "🎄" or "❄", UDim2.fromScale(random:NextNumber(0.03, 0.87), random:NextNumber(0.05, 0.8)), UDim2.fromOffset(22, 22), 18)
	snow.TextTransparency = 0.78
	snow.ZIndex = 1
end

local title = label("stick packet lagger", UDim2.fromOffset(12, 10), UDim2.new(1, -72, 0, 22), 14)
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextStrokeColor3 = Color3.fromRGB(255, 190, 60)
title.TextStrokeTransparency = 0.45

local shine = Instance.new("UIGradient", title)
shine.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 90)),
	ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 200, 90))
})
TweenService:Create(shine, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {Offset = Vector2.new(1, 0)}):Play()

local function button(text, pos, size)
	local b = Instance.new("TextButton", main)
	b.Position = pos
	b.Size = size
	b.BackgroundColor3 = Color3.fromRGB(22, 35, 31)
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.fromRGB(248, 245, 225)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.ZIndex = 5
	round(b, 7)
	return b
end

local lock = button("🔓", UDim2.new(1, -56, 0, 10), UDim2.fromOffset(21, 22))
local collapse = button("−", UDim2.new(1, -29, 0, 10), UDim2.fromOffset(21, 22))

local powerLabel = label("POWER (LAG)", UDim2.fromOffset(12, 45), UDim2.new(1, -24, 0, 14), 10)
powerLabel.TextXAlignment = Enum.TextXAlignment.Left

local power = Instance.new("TextBox", main)
power.Position = UDim2.fromOffset(12, 65)
power.Size = UDim2.new(1, -24, 0, 30)
power.BackgroundColor3 = Color3.fromRGB(18, 33, 29)
power.BorderSizePixel = 0
power.Text = "10000"
power.ClearTextOnFocus = false
power.TextColor3 = Color3.new(1, 1, 1)
power.Font = Enum.Font.GothamBold
power.TextSize = 13
power.ZIndex = 4
round(power, 8)

local start = button("START LAG", UDim2.fromOffset(12, 108), UDim2.new(1, -24, 0, 30))
local activate = button("ACTIVAR AUTO STEAL", UDim2.fromOffset(12, 142), UDim2.new(1, -24, 0, 30))

local notice = label("SOLO VISUAL · SIN FUNCIONES DE RED", UDim2.fromOffset(12, 180), UDim2.new(1, -24, 0, 14), 8)
notice.TextTransparency = 0.25

-- Luces navideñas
local colors = {Color3.fromRGB(255, 70, 70), Color3.fromRGB(255, 215, 80), Color3.fromRGB(80, 240, 135), Color3.fromRGB(100, 185, 255)}
local function light(x, y, index)
	local bulb = Instance.new("Frame", main)
	bulb.AnchorPoint = Vector2.new(0.5, 0.5)
	bulb.Position = UDim2.fromScale(x, y)
	bulb.Size = UDim2.fromOffset(6, 6)
	bulb.BackgroundColor3 = colors[(index - 1) % #colors + 1]
	bulb.BorderSizePixel = 0
	bulb.ZIndex = 10
	round(bulb, 6)
	local glow = Instance.new("UIStroke", bulb)
	glow.Color = bulb.BackgroundColor3
	glow.Thickness = 3
	glow.Transparency = 0.7
	TweenService:Create(bulb, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true, (index % 4) * 0.15), {BackgroundTransparency = 0.5}):Play()
end
for i = 0, 9 do
	light(0.04 + i * 0.92 / 9, 0, i + 1)
	light(0.04 + i * 0.92 / 9, 1, i + 2)
end
for i = 1, 5 do
	light(0, i / 6, i)
	light(1, i / 6, i + 1)
end

-------------------------------------------------
-- BARRA DE PROGRESO FUERA DEL MENÚ (flotante)
-------------------------------------------------
local barGui = Instance.new("ScreenGui", pg)
barGui.Name = "SickPacketBar"
barGui.ResetOnSpawn = false
barGui.IgnoreGuiInset = true
barGui.DisplayOrder = 10

local barContainer = Instance.new("Frame", barGui)
barContainer.Size = UDim2.fromOffset(220, 28)
barContainer.Position = UDim2.new(0.5, -110, 0.88, 0)
barContainer.BackgroundColor3 = Color3.fromRGB(12, 22, 20)
barContainer.BackgroundTransparency = 0.15
barContainer.BorderSizePixel = 0
barContainer.Visible = false
round(barContainer, 8)

local barStroke = Instance.new("UIStroke", barContainer)
barStroke.Color = Color3.fromRGB(60, 160, 255)
barStroke.Thickness = 1.5
barStroke.Transparency = 0.3

local barLabel = Instance.new("TextLabel", barContainer)
barLabel.Size = UDim2.new(1, 0, 0, 12)
barLabel.Position = UDim2.fromOffset(0, 2)
barLabel.BackgroundTransparency = 1
barLabel.Text = "AUTO STEAL"
barLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
barLabel.Font = Enum.Font.GothamBold
barLabel.TextSize = 9
barLabel.ZIndex = 2

local bar = Instance.new("Frame", barContainer)
bar.Name = "StealBar"
bar.Size = UDim2.new(1, -12, 0, 8)
bar.Position = UDim2.fromOffset(6, 16)
bar.BackgroundColor3 = Color3.fromRGB(20, 35, 40)
bar.BorderSizePixel = 0
round(bar, 4)

local barFill = Instance.new("Frame", bar)
barFill.Name = "Fill"
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
barFill.BorderSizePixel = 0
round(barFill, 4)

local function setBarProgress(p)
	barFill.Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0)
end
local function resetBar()
	barFill.Size = UDim2.new(0, 0, 1, 0)
end

-------------------------------------------------
-- VARIABLES
-------------------------------------------------
local active, activated, locked, collapsed, dragging = false, false, false, false, false
local dragInput, dragStart, startPosition
local connections = {}
local function connect(signal, fn)
	table.insert(connections, signal:Connect(fn))
end

-- LAG STATE
local lagging = false
local lagThread = nil
local intensity = 10000

local function clampIntensity(v)
	v = tonumber(v)
	if not v then return intensity end
	return math.clamp(math.floor(v), 1, 100000)
end

local function updateIntensity()
	intensity = clampIntensity(power.Text)
	power.Text = tostring(intensity)
end

-------------------------------------------------
-- SISTEMA DE LAG (igual que Rival Packer)
-------------------------------------------------
local function startLagging()
	if lagging then return end
	if not Event then
		notice.Text = "EVENTO NO ENCONTRADO"
		notice.TextColor3 = Color3.fromRGB(255, 80, 80)
		return
	end
	updateIntensity()
	lagging = true
	active = true
	start.Text = "STOP LAG"
	start.BackgroundColor3 = Color3.fromRGB(40, 85, 55)
	notice.Text = "LAG ACTIVADO · POWER " .. intensity
	notice.TextColor3 = Color3.fromRGB(100, 255, 140)

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
	active = false
	if lagThread then
		pcall(task.cancel, lagThread)
		lagThread = nil
	end
	start.Text = "START LAG"
	start.BackgroundColor3 = Color3.fromRGB(22, 35, 31)
	if not activated then
		notice.Text = "SOLO VISUAL · SIN FUNCIONES DE RED"
		notice.TextColor3 = Color3.fromRGB(245, 248, 240)
	end
end

-------------------------------------------------
-- LÓGICA DEL AUTO-STEAL (Galaxy V1)
-------------------------------------------------
local isOn = true
local currentMode = "V1"
local currentTrigger = "Tryhard"

_G.K7NormalSteal = _G.K7NormalSteal or {
	enabled = false, radius = 60, duration = 1.4,
	animals = {}, promptCache = {}, internalCache = {},
	scannerStarted = false, isStealing = false,
	stealConn = nil, lastSteal = 0, cooldown = 0.05,
}

local function getRoot()
	local c = player.Character
	if not c then return nil end
	return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso")
end

local function isMyBase(plotName)
	local plots = workspace:FindFirstChild("Plots")
	local plot = plots and plots:FindFirstChild(plotName)
	if not plot then return false end
	local sign = plot:FindFirstChild("PlotSign")
	local yourBase = sign and sign:FindFirstChild("YourBase")
	return yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled == true
end

local function scanPlots()
	local A = _G.K7NormalSteal
	A.animals = {}
	local plots = workspace:FindFirstChild("Plots")
	if not plots then return end
	for _, plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") and not isMyBase(plot.Name) then
			local podiums = plot:FindFirstChild("AnimalPodiums")
			if podiums then
				for _, podium in ipairs(podiums:GetChildren()) do
					if podium:IsA("Model") then
						local base = podium:FindFirstChild("Base")
						local spawn = base and base:FindFirstChild("Spawn")
						if spawn then
							table.insert(A.animals, {plot = plot.Name, slot = podium.Name, worldPosition = spawn.Position, uid = plot.Name .. "_" .. podium.Name})
						end
					end
				end
			end
		end
	end
end

local function ensureScanner()
	local A = _G.K7NormalSteal
	if A.scannerStarted then return end
	A.scannerStarted = true
	task.spawn(function()
		task.wait(1)
		while _G.K7NormalSteal do
			if A.enabled then pcall(scanPlots) end
			task.wait(3)
		end
	end)
end

local function findPrompt(data)
	if not data then return nil end
	local A = _G.K7NormalSteal
	local cached = A.promptCache[data.uid]
	if cached and cached.Parent then return cached end
	local plots = workspace:FindFirstChild("Plots")
	local plot = plots and plots:FindFirstChild(data.plot)
	if not plot then return nil end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	local podium = podiums and podiums:FindFirstChild(data.slot)
	if not podium then return nil end
	local base = podium:FindFirstChild("Base")
	local spawn = base and base:FindFirstChild("Spawn")
	if spawn then
		for _, v in ipairs(spawn:GetDescendants()) do
			if v:IsA("ProximityPrompt") then A.promptCache[data.uid] = v return v end
		end
	end
	for _, v in ipairs(podium:GetDescendants()) do
		if v:IsA("ProximityPrompt") then A.promptCache[data.uid] = v return v end
	end
	return nil
end

local function cacheCallbacks(prompt)
	local A = _G.K7NormalSteal
	if A.internalCache[prompt] and A.internalCache[prompt].ready ~= nil then return end
	local data = {ready = true, trigger = {}, hold = {}}
	pcall(function()
		if getconnections then
			for _, conn in ipairs(getconnections(prompt.Triggered) or {}) do if conn.Function then table.insert(data.trigger, conn.Function) end end
			if prompt.HoldBegan then
				for _, conn in ipairs(getconnections(prompt.HoldBegan) or {}) do if conn.Function then table.insert(data.hold, conn.Function) end end
			end
			if prompt.PromptButtonHoldBegan then
				for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan) or {}) do if conn.Function then table.insert(data.hold, conn.Function) end end
			end
		end
	end)
	A.internalCache[prompt] = data
end

local function doSteal(prompt, animalData)
	local A = _G.K7NormalSteal
	if not prompt or not prompt.Parent or A.isStealing then return end
	if not isOn then return end
	if tick() - (A.lastSteal or 0) < (A.cooldown or 0.08) then return end
	cacheCallbacks(prompt)
	local data = A.internalCache[prompt]
	if not data or not data.ready then return end
	data.ready = false
	A.isStealing = true
	A.lastSteal = tick()
	task.spawn(function()
		if #data.hold > 0 then
			for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
		else
			pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
		end
		local FILL_CAP = 0.60
		local HOLD_TIME = 2.2
		local COMPLETE_RADIUS = (currentTrigger == "Tryhard") and 10 or 16
		local function inCompleteRange()
			local root = getRoot()
			if not root or not animalData or not animalData.worldPosition then return false end
			return (root.Position - animalData.worldPosition).Magnitude <= COMPLETE_RADIUS
		end
		local t0 = tick()
		local dur = A.duration or 1.4
		while A.enabled and (currentMode == "V1" or currentMode == "V2") and isOn and tick() - t0 < dur do
			local p = math.min((tick() - t0) / dur, FILL_CAP)
			setBarProgress(p)
			if p >= FILL_CAP then break end
			task.wait()
		end
		if not A.enabled or (currentMode ~= "V1" and currentMode ~= "V2") or not isOn then
			data.ready = true
			A.isStealing = false
			resetBar()
			return
		end
		local holdT0 = tick()
		local completed = false
		while A.enabled and (currentMode == "V1" or currentMode == "V2") and isOn and tick() - holdT0 < HOLD_TIME do
			setBarProgress(FILL_CAP)
			if inCompleteRange() then completed = true break end
			task.wait()
		end
		if not completed or not A.enabled or (currentMode ~= "V1" and currentMode ~= "V2") or not isOn then
			data.ready = true
			A.isStealing = false
			resetBar()
			return
		end
		local t1 = tick()
		local fillDur = 0.35
		while A.enabled and (currentMode == "V1" or currentMode == "V2") and isOn and tick() - t1 < fillDur do
			local p = FILL_CAP + math.min((tick() - t1) / fillDur, 1) * (1 - FILL_CAP)
			setBarProgress(p)
			task.wait()
		end
		setBarProgress(1)
		if #data.trigger > 0 then
			for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
		else
			pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
		end
		task.wait(0.15)
		data.ready = true
		A.isStealing = false
		resetBar()
	end)
end

local function nearestAnimal()
	local A = _G.K7NormalSteal
	local root = getRoot()
	if not root then return nil end
	local best, bestDist = nil, math.huge
	for _, data in ipairs(A.animals) do
		if data.worldPosition and not isMyBase(data.plot) then
			local dist = (root.Position - data.worldPosition).Magnitude
			if dist < bestDist then best = data bestDist = dist end
		end
	end
	if best and bestDist <= (tonumber(A.radius) or 60) then return best end
	return nil
end

local function stopNormal()
	local A = _G.K7NormalSteal
	A.enabled = false
	A.isStealing = false
	if A.stealConn then A.stealConn:Disconnect() A.stealConn = nil end
	resetBar()
end

local function startNormal()
	if not isOn then return end
	local A = _G.K7NormalSteal
	A.radius = 60
	A.duration = 1.4
	A.enabled = true
	ensureScanner()
	pcall(scanPlots)
	if A.stealConn then A.stealConn:Disconnect() A.stealConn = nil end
	A.stealConn = RunService.Heartbeat:Connect(function()
		if not A.enabled or not isOn then return end
		if currentMode ~= "V1" and currentMode ~= "V2" then return end
		if A.isStealing then return end
		local target = nearestAnimal()
		if not target then return end
		local prompt = findPrompt(target)
		if prompt then doSteal(prompt, target) end
	end)
end

local function stopAllSteal()
	stopNormal()
	isOn = false
	barContainer.Visible = false
	resetBar()
end

local function startAutoSteal()
	isOn = true
	currentMode = "V1"
	barContainer.Visible = true
	startNormal()
end

-------------------------------------------------
-- BOTONES
-------------------------------------------------
connect(start.Activated, function()
	if lagging then
		stopLagging()
	else
		startLagging()
	end
end)

connect(activate.Activated, function()
	activated = not activated
	if activated then
		activate.Text = "DESACTIVAR AUTO STEAL"
		activate.BackgroundColor3 = Color3.fromRGB(85, 45, 55)
		if not lagging then
			notice.Text = "AUTO STEAL ACTIVADO"
			notice.TextColor3 = Color3.fromRGB(100, 200, 255)
		end
		startAutoSteal()
	else
		activate.Text = "ACTIVAR AUTO STEAL"
		activate.BackgroundColor3 = Color3.fromRGB(22, 35, 31)
		stopAllSteal()
		if not lagging then
			notice.Text = "SOLO VISUAL · SIN FUNCIONES DE RED"
			notice.TextColor3 = Color3.fromRGB(245, 248, 240)
		end
	end
end)

connect(power.FocusLost, function()
	updateIntensity()
end)

connect(lock.Activated, function()
	locked = not locked
	lock.Text = locked and "🔒" or "🔓"
	if locked then dragging = false end
end)

connect(collapse.Activated, function()
	collapsed = not collapsed
	collapse.Text = collapsed and "+" or "−"
	power.Visible = not collapsed
	powerLabel.Visible = not collapsed
	notice.Visible = not collapsed
	activate.Visible = not collapsed
	main.Size = UDim2.fromOffset(230, collapsed and 94 or 210)
	start.Position = UDim2.fromOffset(12, collapsed and 46 or 108)
end)

connect(title.InputBegan, function(input)
	if locked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragInput = input
		dragStart = input.Position
		startPosition = main.Position
	end
end)

connect(UIS.InputChanged, function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == dragInput) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
end)

connect(UIS.InputEnded, function(input)
	if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

gui.Destroying:Connect(function()
	for _, c in ipairs(connections) do c:Disconnect() end
	stopLagging()
	stopAllSteal()
	if barGui then barGui:Destroy() end
end)