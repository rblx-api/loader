local HUB_NAME = "PUT YOUR HUB NAME HERE"
local SUBTITLE = "PREMIUM SCRIPT EXPERIENCE"

local ACCENT = Color3.fromRGB(132, 58, 255)
local ACCENT_2 = Color3.fromRGB(218, 160, 255)
local BACKGROUND = Color3.fromRGB(4, 3, 9)

local INTRO_TIME = 5.2
local TAP_TO_SKIP = true

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

ReplicatedFirst:RemoveDefaultLoadingScreen()

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("ComplexHubIntro")
if old then
	old:Destroy()
end

local finished = false
local closing = false
local renderConnection
local random = Random.new()

local function round(object, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object
	return corner
end

local function outline(object, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.Transparency = transparency or 0
	stroke.Parent = object
	return stroke
end

local function addScale(object, value)
	local scale = Instance.new("UIScale")
	scale.Scale = value
	scale.Parent = object
	return scale
end

local function play(object, duration, goal, style, direction)
	if finished or not object or not object.Parent then
		return
	end

	local tween = TweenService:Create(
		object,
		TweenInfo.new(
			duration,
			style or Enum.EasingStyle.Quint,
			direction or Enum.EasingDirection.Out
		),
		goal
	)

	tween:Play()
	return tween
end

local function waitTime(seconds)
	local started = os.clock()

	while not finished and os.clock() - started < seconds do
		RunService.Heartbeat:Wait()
	end

	return not finished
end

local gui = Instance.new("ScreenGui")
gui.Name = "ComplexHubIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 100000
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1, 1)
root.BackgroundColor3 = BACKGROUND
root.BorderSizePixel = 0
root.ClipsDescendants = true
root.Parent = gui

local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(2, 2, 6)),
	ColorSequenceKeypoint.new(0.45, Color3.fromRGB(17, 7, 31)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 2, 6)),
})
backgroundGradient.Rotation = 20
backgroundGradient.Parent = root

local camera = workspace.CurrentCamera
while not camera or camera.ViewportSize.X < 20 do
	RunService.RenderStepped:Wait()
	camera = workspace.CurrentCamera
end

local view = camera.ViewportSize
local shortest = math.min(view.X, view.Y)
local uiScaleValue = math.clamp(shortest / 720, 0.72, 1.12)

local scene = Instance.new("Frame")
scene.Size = UDim2.fromScale(1, 1)
scene.BackgroundTransparency = 1
scene.Parent = root

local topPanel = Instance.new("Frame")
topPanel.Size = UDim2.fromScale(1, 0.5)
topPanel.BackgroundColor3 = Color3.fromRGB(3, 3, 8)
topPanel.BorderSizePixel = 0
topPanel.ZIndex = 500
topPanel.Parent = root

local bottomPanel = Instance.new("Frame")
bottomPanel.AnchorPoint = Vector2.new(0, 1)
bottomPanel.Position = UDim2.fromScale(0, 1)
bottomPanel.Size = UDim2.fromScale(1, 0.5)
bottomPanel.BackgroundColor3 = Color3.fromRGB(3, 3, 8)
bottomPanel.BorderSizePixel = 0
bottomPanel.ZIndex = 500
bottomPanel.Parent = root

local topEdge = Instance.new("Frame")
topEdge.AnchorPoint = Vector2.new(0, 1)
topEdge.Position = UDim2.fromScale(0, 1)
topEdge.Size = UDim2.new(1, 0, 0, 2)
topEdge.BackgroundColor3 = ACCENT
topEdge.BackgroundTransparency = 0.15
topEdge.BorderSizePixel = 0
topEdge.Parent = topPanel

local bottomEdge = topEdge:Clone()
bottomEdge.AnchorPoint = Vector2.new(0, 0)
bottomEdge.Position = UDim2.fromScale(0, 0)
bottomEdge.Parent = bottomPanel

local grid = Instance.new("Frame")
grid.Size = UDim2.fromScale(1, 1)
grid.BackgroundTransparency = 1
grid.ZIndex = 1
grid.Parent = scene

for i = 0, 18 do
	local vertical = Instance.new("Frame")
	vertical.Size = UDim2.new(0, 1, 1, 0)
	vertical.Position = UDim2.fromScale(i / 18, 0)
	vertical.BackgroundColor3 = ACCENT
	vertical.BackgroundTransparency = 0.93
	vertical.BorderSizePixel = 0
	vertical.Parent = grid
end

for i = 0, 10 do
	local horizontal = Instance.new("Frame")
	horizontal.Size = UDim2.new(1, 0, 0, 1)
	horizontal.Position = UDim2.fromScale(0, i / 10)
	horizontal.BackgroundColor3 = ACCENT
	horizontal.BackgroundTransparency = 0.94
	horizontal.BorderSizePixel = 0
	horizontal.Parent = grid
end

local particles = {}

for i = 1, 42 do
	local particle = Instance.new("Frame")
	local size = random:NextInteger(2, 5)

	particle.AnchorPoint = Vector2.new(0.5, 0.5)
	particle.Position = UDim2.fromScale(
		random:NextNumber(0.03, 0.97),
		random:NextNumber(0.03, 0.97)
	)
	particle.Size = UDim2.fromOffset(size, size)
	particle.BackgroundColor3 = i % 5 == 0 and Color3.fromRGB(245, 240, 255) or ACCENT_2
	particle.BackgroundTransparency = random:NextNumber(0.45, 0.85)
	particle.BorderSizePixel = 0
	particle.ZIndex = 2
	particle.Parent = scene
	round(particle, 999)

	particles[i] = {
		object = particle,
		speed = random:NextNumber(0.008, 0.024),
		offset = random:NextNumber(0, math.pi * 2),
	}
end

local center = Instance.new("Frame")
center.AnchorPoint = Vector2.new(0.5, 0.5)
center.Position = UDim2.fromScale(0.5, 0.47)
center.Size = UDim2.fromOffset(430, 430)
center.BackgroundTransparency = 1
center.ZIndex = 20
center.Parent = scene

local centerScale = addScale(center, uiScaleValue * 0.72)

local glow = Instance.new("Frame")
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.Position = UDim2.fromScale(0.5, 0.5)
glow.Size = UDim2.fromOffset(210, 210)
glow.BackgroundColor3 = ACCENT
glow.BackgroundTransparency = 0.9
glow.BorderSizePixel = 0
glow.ZIndex = 10
glow.Parent = center
round(glow, 999)

local ring1 = Instance.new("Frame")
ring1.AnchorPoint = Vector2.new(0.5, 0.5)
ring1.Position = UDim2.fromScale(0.5, 0.5)
ring1.Size = UDim2.fromOffset(176, 176)
ring1.BackgroundTransparency = 1
ring1.Rotation = 0
ring1.ZIndex = 22
ring1.Parent = center
round(ring1, 999)
local ring1Stroke = outline(ring1, ACCENT_2, 3, 1)

local ring2 = Instance.new("Frame")
ring2.AnchorPoint = Vector2.new(0.5, 0.5)
ring2.Position = UDim2.fromScale(0.5, 0.5)
ring2.Size = UDim2.fromOffset(126, 126)
ring2.BackgroundTransparency = 1
ring2.Rotation = 0
ring2.ZIndex = 23
ring2.Parent = center
round(ring2, 999)
local ring2Stroke = outline(ring2, ACCENT, 2, 1)

local ring3 = Instance.new("Frame")
ring3.AnchorPoint = Vector2.new(0.5, 0.5)
ring3.Position = UDim2.fromScale(0.5, 0.5)
ring3.Size = UDim2.fromOffset(78, 78)
ring3.BackgroundColor3 = Color3.fromRGB(18, 8, 34)
ring3.BackgroundTransparency = 1
ring3.BorderSizePixel = 0
ring3.ZIndex = 24
ring3.Parent = center
round(ring3, 999)
local ring3Stroke = outline(ring3, ACCENT_2, 2, 1)

local core = Instance.new("Frame")
core.AnchorPoint = Vector2.new(0.5, 0.5)
core.Position = UDim2.fromScale(0.5, 0.5)
core.Size = UDim2.fromOffset(18, 18)
core.BackgroundColor3 = Color3.fromRGB(250, 247, 255)
core.BackgroundTransparency = 1
core.BorderSizePixel = 0
core.ZIndex = 25
core.Parent = center
round(core, 999)

local coreGlow = Instance.new("Frame")
coreGlow.AnchorPoint = Vector2.new(0.5, 0.5)
coreGlow.Position = UDim2.fromScale(0.5, 0.5)
coreGlow.Size = UDim2.fromOffset(52, 52)
coreGlow.BackgroundColor3 = ACCENT
coreGlow.BackgroundTransparency = 1
coreGlow.BorderSizePixel = 0
coreGlow.ZIndex = 21
coreGlow.Parent = center
round(coreGlow, 999)

local orbitDots = {}

for i = 1, 8 do
	local dot = Instance.new("Frame")
	dot.AnchorPoint = Vector2.new(0.5, 0.5)
	dot.Size = UDim2.fromOffset(i % 3 == 0 and 6 or 4, i % 3 == 0 and 6 or 4)
	dot.BackgroundColor3 = i % 2 == 0 and ACCENT_2 or Color3.fromRGB(250, 247, 255)
	dot.BackgroundTransparency = 1
	dot.BorderSizePixel = 0
	dot.ZIndex = 26
	dot.Parent = center
	round(dot, 999)

	orbitDots[i] = dot
end

local scan = Instance.new("Frame")
scan.AnchorPoint = Vector2.new(0.5, 0.5)
scan.Position = UDim2.fromScale(0.5, 0)
scan.Size = UDim2.new(1, 0, 0, 90)
scan.BackgroundTransparency = 1
scan.BorderSizePixel = 0
scan.ZIndex = 8
scan.Parent = scene

local scanGradient = Instance.new("UIGradient")
scanGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 0.82),
	NumberSequenceKeypoint.new(1, 1),
})
scanGradient.Color = ColorSequence.new(ACCENT)
scanGradient.Rotation = 90
scanGradient.Parent = scan

local titleHolder = Instance.new("Frame")
titleHolder.AnchorPoint = Vector2.new(0.5, 0.5)
titleHolder.Position = UDim2.fromScale(0.5, 0.69)
titleHolder.Size = UDim2.fromOffset(820, 120)
titleHolder.BackgroundTransparency = 1
titleHolder.ZIndex = 50
titleHolder.Parent = scene

local titleScale = addScale(titleHolder, uiScaleValue)

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 0.58)
title.BackgroundTransparency = 1
title.Text = ""
title.TextColor3 = Color3.fromRGB(248, 246, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 43
title.TextTransparency = 0
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.ZIndex = 51
title.Parent = titleHolder

local titleStroke = outline(title, ACCENT, 1, 0.68)

local subtitle = Instance.new("TextLabel")
subtitle.AnchorPoint = Vector2.new(0.5, 0)
subtitle.Position = UDim2.fromScale(0.5, 0.62)
subtitle.Size = UDim2.fromScale(1, 0.25)
subtitle.BackgroundTransparency = 1
subtitle.Text = SUBTITLE
subtitle.TextColor3 = Color3.fromRGB(169, 150, 196)
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 12
subtitle.TextTransparency = 1
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.ZIndex = 51
subtitle.Parent = titleHolder

local progressBack = Instance.new("Frame")
progressBack.AnchorPoint = Vector2.new(0.5, 0.5)
progressBack.Position = UDim2.fromScale(0.5, 0.84)
progressBack.Size = UDim2.fromOffset(360, 7)
progressBack.BackgroundColor3 = Color3.fromRGB(37, 29, 49)
progressBack.BackgroundTransparency = 1
progressBack.BorderSizePixel = 0
progressBack.ClipsDescendants = true
progressBack.ZIndex = 52
progressBack.Parent = scene
round(progressBack, 999)

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.fromScale(0, 1)
progressFill.BackgroundColor3 = ACCENT
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 53
progressFill.Parent = progressBack
round(progressFill, 999)

local progressGradient = Instance.new("UIGradient")
progressGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, ACCENT),
	ColorSequenceKeypoint.new(0.62, ACCENT_2),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
})
progressGradient.Parent = progressFill

local percent = Instance.new("TextLabel")
percent.AnchorPoint = Vector2.new(0.5, 0.5)
percent.Position = UDim2.fromScale(0.5, 0.89)
percent.Size = UDim2.fromOffset(100, 24)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = Color3.fromRGB(158, 139, 184)
percent.TextTransparency = 1
percent.Font = Enum.Font.GothamMedium
percent.TextSize = 11
percent.ZIndex = 52
percent.Parent = scene

local status = Instance.new("TextLabel")
status.AnchorPoint = Vector2.new(0.5, 0.5)
status.Position = UDim2.fromScale(0.5, 0.93)
status.Size = UDim2.fromOffset(300, 22)
status.BackgroundTransparency = 1
status.Text = "Preparing interface"
status.TextColor3 = Color3.fromRGB(132, 116, 154)
status.TextTransparency = 1
status.Font = Enum.Font.GothamMedium
status.TextSize = 10
status.ZIndex = 52
status.Parent = scene

local skipButton = Instance.new("TextButton")
skipButton.Size = UDim2.fromScale(1, 1)
skipButton.BackgroundTransparency = 1
skipButton.Text = ""
skipButton.AutoButtonColor = false
skipButton.ZIndex = 1000
skipButton.Parent = root

local skipText = Instance.new("TextLabel")
skipText.AnchorPoint = Vector2.new(0.5, 1)
skipText.Position = UDim2.new(0.5, 0, 1, -22)
skipText.Size = UDim2.fromOffset(180, 22)
skipText.BackgroundTransparency = 1
skipText.Text = "tap to skip"
skipText.TextColor3 = Color3.fromRGB(145, 132, 163)
skipText.TextTransparency = TAP_TO_SKIP and 0.28 or 1
skipText.Font = Enum.Font.GothamMedium
skipText.TextSize = 11
skipText.ZIndex = 1001
skipText.Parent = root

local flash = Instance.new("Frame")
flash.Size = UDim2.fromScale(1, 1)
flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flash.BackgroundTransparency = 1
flash.BorderSizePixel = 0
flash.ZIndex = 900
flash.Parent = root

local function closeIntro()
	if closing then
		return
	end

	closing = true
	finished = true

	if renderConnection then
		renderConnection:Disconnect()
	end

	TweenService:Create(
		flash,
		TweenInfo.new(0.07, Enum.EasingStyle.Linear),
		{BackgroundTransparency = 0.12}
	):Play()

	task.wait(0.07)

	TweenService:Create(
		topPanel,
		TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
		{Position = UDim2.fromScale(0, -0.5)}
	):Play()

	TweenService:Create(
		bottomPanel,
		TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut),
		{Position = UDim2.fromScale(0, 1.5)}
	):Play()

	TweenService:Create(
		flash,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad),
		{BackgroundTransparency = 1}
	):Play()

	TweenService:Create(
		root,
		TweenInfo.new(0.65, Enum.EasingStyle.Quad),
		{BackgroundTransparency = 1}
	):Play()

	task.wait(0.68)

	player:SetAttribute("HubIntroFinished", true)
	gui:Destroy()
end

if TAP_TO_SKIP then
	skipButton.Activated:Connect(closeIntro)
else
	skipButton.Active = false
end

renderConnection = RunService.RenderStepped:Connect(function(dt)
	if finished then
		return
	end

	ring1.Rotation += 24 * dt
	ring2.Rotation -= 38 * dt
	backgroundGradient.Rotation += 2 * dt
	progressGradient.Rotation += 22 * dt

	local time = os.clock()

	glow.Size = UDim2.fromOffset(
		210 + math.sin(time * 2.5) * 16,
		210 + math.sin(time * 2.5) * 16
	)

	coreGlow.Size = UDim2.fromOffset(
		52 + math.sin(time * 4.8) * 7,
		52 + math.sin(time * 4.8) * 7
	)

	for i, dot in ipairs(orbitDots) do
		local radius = i % 2 == 0 and 88 or 62
		local speed = i % 2 == 0 and 0.62 or -0.86
		local angle = time * speed + (math.pi * 2 / #orbitDots) * i

		dot.Position = UDim2.fromOffset(
			215 + math.cos(angle) * radius,
			215 + math.sin(angle) * radius
		)
	end

	for i, particleData in ipairs(particles) do
		local particle = particleData.object
		local x = particle.Position.X.Scale
		local y = particle.Position.Y.Scale - particleData.speed * dt

		if y < -0.03 then
			y = 1.03
			x = random:NextNumber(0.03, 0.97)
		end

		particle.Position = UDim2.fromScale(
			x + math.sin(time + particleData.offset) * 0.00015,
			y
		)
	end
end)

task.spawn(function()
	play(
		topPanel,
		0.7,
		{Position = UDim2.fromScale(0, -0.5)},
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.InOut
	)

	play(
		bottomPanel,
		0.7,
		{Position = UDim2.fromScale(0, 1.5)},
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.InOut
	)

	if not waitTime(0.38) then
		return
	end

	play(centerScale, 0.75, {Scale = uiScaleValue}, Enum.EasingStyle.Back)
	play(ring1Stroke, 0.45, {Transparency = 0.15})
	play(ring2Stroke, 0.52, {Transparency = 0.22})
	play(ring3, 0.4, {BackgroundTransparency = 0.08})
	play(ring3Stroke, 0.45, {Transparency = 0.08})
	play(core, 0.38, {BackgroundTransparency = 0})
	play(coreGlow, 0.38, {BackgroundTransparency = 0.78})

	for i, dot in ipairs(orbitDots) do
		task.delay(i * 0.045, function()
			play(dot, 0.24, {BackgroundTransparency = 0.05})
		end)
	end

	play(
		scan,
		1.1,
		{Position = UDim2.fromScale(0.5, 1)},
		Enum.EasingStyle.Linear
	)

	if not waitTime(0.52) then
		return
	end

	for i = 1, #HUB_NAME do
		if finished then
			return
		end

		title.Text = string.sub(HUB_NAME, 1, i)

		if string.sub(HUB_NAME, i, i) ~= " " then
			play(core, 0.07, {Size = UDim2.fromOffset(23, 23)})
			task.delay(0.07, function()
				play(core, 0.1, {Size = UDim2.fromOffset(18, 18)})
			end)
		end

		task.wait(0.035)
	end

	play(subtitle, 0.32, {TextTransparency = 0})
	play(progressBack, 0.3, {BackgroundTransparency = 0.12})
	play(percent, 0.3, {TextTransparency = 0})
	play(status, 0.3, {TextTransparency = 0})

	if not waitTime(0.28) then
		return
	end

	local loadStart = os.clock()
	local loadDuration = math.max(1.3, INTRO_TIME - 2.4)

	play(
		progressFill,
		loadDuration,
		{Size = UDim2.fromScale(1, 1)},
		Enum.EasingStyle.Quart,
		Enum.EasingDirection.InOut
	)

	while not finished do
		local progress = math.clamp((os.clock() - loadStart) / loadDuration, 0, 1)
		local value = math.floor(progress * 100)

		percent.Text = value .. "%"

		if value < 30 then
			status.Text = "Preparing interface"
		elseif value < 65 then
			status.Text = "Loading modules"
		elseif value < 92 then
			status.Text = "Finalizing"
		else
			status.Text = "Ready"
		end

		if progress >= 1 then
			break
		end

		RunService.RenderStepped:Wait()
	end

	if finished then
		return
	end

	percent.Text = "100%"
	status.Text = "Ready"

	play(flash, 0.06, {BackgroundTransparency = 0.12}, Enum.EasingStyle.Linear)
	play(centerScale, 0.15, {Scale = uiScaleValue * 1.12})
	play(titleScale, 0.15, {Scale = uiScaleValue * 1.04})

	if not waitTime(0.07) then
		return
	end

	play(flash, 0.25, {BackgroundTransparency = 1}, Enum.EasingStyle.Quad)
	play(centerScale, 0.22, {Scale = uiScaleValue})
	play(titleScale, 0.22, {Scale = uiScaleValue})

	if not waitTime(0.25) then
		return
	end

	topPanel.Position = UDim2.fromScale(0, -0.5)
	bottomPanel.Position = UDim2.fromScale(0, 1.5)

	play(topPanel, 0.48, {Position = UDim2.fromScale(0, 0)})
	play(bottomPanel, 0.48, {Position = UDim2.fromScale(0, 1)})

	if not waitTime(0.45) then
		return
	end

	closeIntro()
end)

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()