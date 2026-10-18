-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"camaron4420"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

repeat task.wait() until game:IsLoaded()
local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService")
local LP = Players.LocalPlayer

-- =============== INTRO CONFIG LOAD ===============
local INTRO_CONFIG_FILE = "vortex_config.json"
local introSkipEnabled = false

local function loadIntroSkipConfig()
    if isfile and isfile(INTRO_CONFIG_FILE) then
        local ok, data = pcall(function() return HS:JSONDecode(readfile(INTRO_CONFIG_FILE)) end)
        if ok and data and data.skipIntro ~= nil then
            introSkipEnabled = data.skipIntro
        end
    end
end
loadIntroSkipConfig()

-- =============== INTRO SOURCE ===============
local introSource = [[
-- uranium.cc intro | LocalScript standalone
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UraniumIntro"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local introSkipped = false
local skipConnection = nil
local introSound = nil

local SOUND_ID = 120267378058133
local SKIP_SECONDS = 10

-- ===== EFFETTI =====
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.3
overlay.BorderSizePixel = 0
overlay.ZIndex = 1
overlay.Parent = screenGui

local darkOverlay = Instance.new("Frame")
darkOverlay.Size = UDim2.fromScale(1, 1)
darkOverlay.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
darkOverlay.BackgroundTransparency = 0.5
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 1
darkOverlay.Parent = screenGui

local vignette = Instance.new("ImageLabel")
vignette.Size = UDim2.fromScale(1, 1)
vignette.BackgroundTransparency = 1
vignette.Image = "rbxassetid://195611797"
vignette.ImageColor3 = Color3.fromRGB(0, 0, 0)
vignette.ImageTransparency = 0.35
vignette.ZIndex = 2
vignette.Parent = screenGui

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 850, 0, 130)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5, 0, 0.5, 0)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ClipsDescendants = false
container.ZIndex = 5
container.Parent = screenGui

-- TESTO UNICO "URANIUM.CC"
local mainLabel = Instance.new("TextLabel")
mainLabel.Size = UDim2.new(1, 0, 1, 0)
mainLabel.AnchorPoint = Vector2.new(0.5, 0.5)
mainLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
mainLabel.BackgroundTransparency = 1
mainLabel.Text = "URANIUM.CC"
mainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
mainLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
mainLabel.TextStrokeTransparency = 0
mainLabel.Font = Enum.Font.GothamBlack
mainLabel.TextSize = 88
mainLabel.TextXAlignment = Enum.TextXAlignment.Center
mainLabel.TextTransparency = 1
mainLabel.ZIndex = 5
mainLabel.Parent = container

-- Label separate per l'animazione iniziale
local leftLabel = Instance.new("TextLabel")
leftLabel.Size = UDim2.new(0, 400, 1, 0)
leftLabel.AnchorPoint = Vector2.new(1, 0.5)
leftLabel.Position = UDim2.new(0.5, -10, 0.5, 0)
leftLabel.BackgroundTransparency = 1
leftLabel.Text = "URANIUM"
leftLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
leftLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
leftLabel.TextStrokeTransparency = 0
leftLabel.Font = Enum.Font.GothamBlack
leftLabel.TextSize = 88
leftLabel.TextXAlignment = Enum.TextXAlignment.Right
leftLabel.TextTransparency = 1
leftLabel.ZIndex = 5
leftLabel.Visible = true
leftLabel.Parent = container

local rightLabel = Instance.new("TextLabel")
rightLabel.Size = UDim2.new(0, 200, 1, 0)
rightLabel.AnchorPoint = Vector2.new(0, 0.5)
rightLabel.Position = UDim2.new(0.5, -10, 0.5, 0)
rightLabel.BackgroundTransparency = 1
rightLabel.Text = ".CC"
rightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
rightLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
rightLabel.TextStrokeTransparency = 0
rightLabel.Font = Enum.Font.GothamBlack
rightLabel.TextSize = 88
rightLabel.TextXAlignment = Enum.TextXAlignment.Left
rightLabel.TextTransparency = 1
rightLabel.ZIndex = 5
rightLabel.Visible = true
rightLabel.Parent = container

-- Fascio di luce verde
local lightBeam = Instance.new("Frame")
lightBeam.Size = UDim2.new(0, 0, 1.1, 0)
lightBeam.AnchorPoint = Vector2.new(0, 0.5)
lightBeam.Position = UDim2.new(0, -20, 0.5, 0)
lightBeam.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
lightBeam.BackgroundTransparency = 0.5
lightBeam.BorderSizePixel = 0
lightBeam.ZIndex = 6
lightBeam.Parent = container

local beamGlow = Instance.new("Frame")
beamGlow.Size = UDim2.new(0, 0, 1.3, 0)
beamGlow.AnchorPoint = Vector2.new(0, 0.5)
beamGlow.Position = UDim2.new(0, -20, 0.5, 0)
beamGlow.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
beamGlow.BackgroundTransparency = 0.7
beamGlow.BorderSizePixel = 0
beamGlow.ZIndex = 5
beamGlow.Parent = container

local beamSparkles = Instance.new("Frame")
beamSparkles.Size = UDim2.new(0, 0, 1, 0)
beamSparkles.AnchorPoint = Vector2.new(0, 0.5)
beamSparkles.Position = UDim2.new(0, -20, 0.5, 0)
beamSparkles.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
beamSparkles.BackgroundTransparency = 0.8
beamSparkles.BorderSizePixel = 0
beamSparkles.ZIndex = 7
beamSparkles.Parent = container

-- Sottotitoli
local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, 0, 0, 40)
subLabel.AnchorPoint = Vector2.new(0.5, 0)
subLabel.Position = UDim2.new(0.5, 0, 0.5, 70)
subLabel.BackgroundTransparency = 1
subLabel.Text = "THE ONE THAT MOGS ALL. . ."
subLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
subLabel.Font = Enum.Font.GothamBold
subLabel.TextSize = 14
subLabel.TextXAlignment = Enum.TextXAlignment.Center
subLabel.TextTransparency = 1
subLabel.ZIndex = 5
subLabel.Parent = screenGui

local subLabel2 = Instance.new("TextLabel")
subLabel2.Size = UDim2.new(1, 0, 0, 25)
subLabel2.AnchorPoint = Vector2.new(0.5, 0)
subLabel2.Position = UDim2.new(0.5, 0, 0.5, 105)
subLabel2.BackgroundTransparency = 1
subLabel2.Text = "TAP THE SCREEN TO SKIP INTRO"
subLabel2.TextColor3 = Color3.fromRGB(100, 100, 100)
subLabel2.Font = Enum.Font.Gotham
subLabel2.TextSize = 11
subLabel2.TextXAlignment = Enum.TextXAlignment.Center
subLabel2.TextTransparency = 1
subLabel2.ZIndex = 5
subLabel2.Parent = screenGui

local accentBar = Instance.new("Frame")
accentBar.Size = UDim2.new(0, 0, 0, 2)
accentBar.AnchorPoint = Vector2.new(0.5, 0)
accentBar.Position = UDim2.new(0.5, 0, 0.5, 62)
accentBar.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
accentBar.BackgroundTransparency = 0
accentBar.BorderSizePixel = 0
accentBar.ZIndex = 5
accentBar.Parent = screenGui

local flashFrame = Instance.new("Frame")
flashFrame.Size = UDim2.fromScale(1, 1)
flashFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
flashFrame.BackgroundTransparency = 1
flashFrame.BorderSizePixel = 0
flashFrame.ZIndex = 10
flashFrame.Parent = screenGui

local glitchContainer = Instance.new("Frame")
glitchContainer.Size = UDim2.new(1, 0, 1, 0)
glitchContainer.BackgroundTransparency = 1
glitchContainer.ZIndex = 6
glitchContainer.Parent = screenGui

local dripContainer = Instance.new("Frame")
dripContainer.Size = UDim2.new(1, 0, 1, 0)
dripContainer.BackgroundTransparency = 1
dripContainer.ZIndex = 7
dripContainer.Parent = screenGui

local tapToRemoveLabel = Instance.new("TextLabel")
tapToRemoveLabel.Size = UDim2.new(0, 150, 0, 24)
tapToRemoveLabel.AnchorPoint = Vector2.new(0.5, 1)
tapToRemoveLabel.Position = UDim2.new(0.5, 0, 1, -20)
tapToRemoveLabel.BackgroundTransparency = 1
tapToRemoveLabel.Text = "✦ TAP TO REMOVE ✦"
tapToRemoveLabel.TextColor3 = Color3.fromRGB(0, 255, 180)
tapToRemoveLabel.Font = Enum.Font.GothamBold
tapToRemoveLabel.TextSize = 10
tapToRemoveLabel.TextXAlignment = Enum.TextXAlignment.Center
tapToRemoveLabel.TextTransparency = 0.5
tapToRemoveLabel.ZIndex = 15
tapToRemoveLabel.Parent = screenGui

-- ===== FUNZIONI =====
local function doFlash(color, alpha, duration)
	flashFrame.BackgroundColor3 = color or Color3.new(1,1,1)
	flashFrame.BackgroundTransparency = 1 - (alpha or 0.85)
	task.delay(duration or 0.06, function()
		if not introSkipped then
			TweenService:Create(flashFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
		else
			flashFrame.BackgroundTransparency = 1
		end
	end)
end

local function runLightBeam()
	lightBeam.Size = UDim2.new(0, 45, 1.1, 0)
	beamGlow.Size = UDim2.new(0, 65, 1.3, 0)
	beamSparkles.Size = UDim2.new(0, 45, 1, 0)

	lightBeam.BackgroundTransparency = 0.35
	beamGlow.BackgroundTransparency = 0.55
	beamSparkles.BackgroundTransparency = 0.75

	local beamTween = TweenService:Create(lightBeam, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		Position = UDim2.new(1, 20, 0.5, 0)
	})
	beamTween:Play()

	local glowTween = TweenService:Create(beamGlow, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		Position = UDim2.new(1, 20, 0.5, 0)
	})
	glowTween:Play()

	local sparkleTween = TweenService:Create(beamSparkles, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		Position = UDim2.new(1, 20, 0.5, 0)
	})
	sparkleTween:Play()

	local pulseCount = 0
	local pulseConnection
	pulseConnection = game:GetService("RunService").Heartbeat:Connect(function()
		if introSkipped then
			if pulseConnection then pulseConnection:Disconnect() end
			return
		end
		pulseCount = pulseCount + 1
		if pulseCount % 3 == 0 then
			local pulseIntensity = 0.3 + math.sin(pulseCount * 0.5) * 0.15
			lightBeam.BackgroundTransparency = 0.3 - (pulseIntensity * 0.2)
			beamGlow.BackgroundTransparency = 0.5 - (pulseIntensity * 0.1)
			beamSparkles.BackgroundTransparency = 0.7 - (pulseIntensity * 0.15)
		end
	end)

	beamTween.Completed:Wait()

	if pulseConnection then pulseConnection:Disconnect() end

	TweenService:Create(lightBeam, TweenInfo.new(0.25), {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1.1, 0)
	}):Play()
	TweenService:Create(beamGlow, TweenInfo.new(0.25), {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1.3, 0)
	}):Play()
	TweenService:Create(beamSparkles, TweenInfo.new(0.25), {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0)
	}):Play()
end

local function changeToGreen()
	task.wait(0.2)
	TweenService:Create(mainLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
		TextColor3 = Color3.fromRGB(0, 255, 180)
	}):Play()
end

local glitchChars = {"!", "#", "%", "/", "[", "]", "░", "▒", "▓", "—", "=", "*", "^", "~", "¦", "¤"}

local function glitchText(lbl, original)
	if introSkipped then return end
	for i = 1, 4 do
		if introSkipped then break end
		local s = ""
		for c in original:gmatch(".") do
			s = s .. (math.random() < 0.35 and glitchChars[math.random(#glitchChars)] or c)
		end
		lbl.Text = s
		task.wait(0.03)
	end
	if not introSkipped then
		lbl.Text = original
	end
end

local function addGlitchBar()
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, 0, 0, math.random(2, 12))
	bar.Position = UDim2.new(0, 0, math.random(10, 90)/100, 0)
	bar.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
	bar.BackgroundTransparency = math.random(45, 70) / 100
	bar.BorderSizePixel = 0
	bar.ZIndex = 6
	bar.Parent = glitchContainer
	task.delay(0.1, function()
		if bar then
			TweenService:Create(bar, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
			task.delay(0.1, function() bar:Destroy() end)
		end
	end)
end

local function shakeScreen(intensity, duration)
	if introSkipped then return end
	local baseLeft = UDim2.new(0.5, -8, 0.5, 0)
	local baseRight = UDim2.new(0.5, 8, 0.5, 0)
	local startTime = tick()

	while tick() - startTime < duration and not introSkipped do
		local currentIntensity = intensity * (1 - ((tick() - startTime) / duration))
		local ox = math.random(-math.floor(currentIntensity), math.floor(currentIntensity))
		local oy = math.random(-math.floor(currentIntensity * 0.5), math.floor(currentIntensity * 0.5))
		leftLabel.Position = UDim2.new(0.5, -8 + ox, 0.5, oy)
		rightLabel.Position = UDim2.new(0.5, 8 + ox, 0.5, oy)
		task.wait(0.02)
	end

	if not introSkipped then
		TweenService:Create(leftLabel, TweenInfo.new(0.05), {Position = baseLeft}):Play()
		TweenService:Create(rightLabel, TweenInfo.new(0.05), {Position = baseRight}):Play()
	end
end

local function setupAudio()
	introSound = Instance.new("Sound")
	introSound.SoundId = "rbxassetid://" .. SOUND_ID
	introSound.Volume = 0.7
	introSound.PlayOnRemove = false
	introSound.Parent = screenGui
	introSound.Loaded:Wait()
	introSound:Play()
	introSound.TimePosition = SKIP_SECONDS
	return introSound
end

local function fadeOutAudio(duration)
	if not introSound then return end
	local startVolume = introSound.Volume
	local steps = 30
	for i = 1, steps do
		if introSkipped or not introSound then break end
		introSound.Volume = startVolume * (1 - (i / steps))
		task.wait(duration / steps)
	end
	if introSound then
		introSound.Volume = 0
		introSound:Stop()
	end
end

local function stopAudio()
	if introSound then
		introSound:Stop()
		introSound:Destroy()
	end
end

local activeDrips = 0
local function createDrip(startX, startY, width, height, duration, delay)
	task.wait(delay)
	if introSkipped then return end
	activeDrips = activeDrips + 1

	local drip = Instance.new("Frame")
	drip.Size = UDim2.new(0, width, 0, height)
	drip.Position = UDim2.new(0.5, startX, 0.5, startY)
	drip.BackgroundColor3 = Color3.fromRGB(0, 255, 180)
	drip.BackgroundTransparency = 0.25
	drip.BorderSizePixel = 0
	drip.ZIndex = 7
	drip.Parent = dripContainer

	local stretch = TweenService:Create(drip, TweenInfo.new(duration * 0.35), {
		Size = UDim2.new(0, width, 0, height + 22),
		BackgroundTransparency = 0.1
	})
	stretch:Play()

	task.wait(duration * 0.35)

	if introSkipped then
		drip:Destroy()
		activeDrips = activeDrips - 1
		return
	end

	local fall = TweenService:Create(drip, TweenInfo.new(duration * 0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, startX + math.random(-3, 3), 0.5, startY + 80),
		BackgroundTransparency = 1
	})
	fall:Play()

	fall.Completed:Connect(function()
		drip:Destroy()
		activeDrips = activeDrips - 1
	end)
end

local function startDripping()
	if introSkipped then return end
	local fullText = "URANIUM.CC"
	local font = Enum.Font.GothamBlack
	local textSize = 88

	local textBoundsFull = TextService:GetTextSize(fullText, textSize, font, Vector2.new(math.huge, math.huge))
	local textHeight = textBoundsFull.Y

	local drips = {}
	local delayCounter = 0

	for i = 1, #fullText do
		local char = fullText:sub(i, i)
		local charBounds = TextService:GetTextSize(char, textSize, font, Vector2.new(math.huge, math.huge))
		local charWidth = charBounds.X

		local precedingText = fullText:sub(1, i-1)
		local precedingWidth = 0
		if i > 1 then
			precedingWidth = TextService:GetTextSize(precedingText, textSize, font, Vector2.new(math.huge, math.huge)).X
		end

		local totalTextWidth = textBoundsFull.X
		local leftEdgeOffset = -totalTextWidth / 2
		local charLeft = leftEdgeOffset + precedingWidth
		local charCenterX = charLeft + charWidth / 2

		local startY = textHeight / 2 + 3

		local rx = math.random(-2, 2)
		local ry = math.random(0, 4)

		local dripWidth = math.clamp(math.floor(charWidth * 0.35), 3, 7)
		local dripHeight = math.random(4, 7)
		local duration = 0.5 + math.random() * 0.2
		local delay = delayCounter * 0.07

		table.insert(drips, {
			startX = charCenterX + rx,
			startY = startY + ry,
			width = dripWidth,
			height = dripHeight,
			duration = duration,
			delay = delay
		})
		delayCounter = delayCounter + 1
	end

	for _, d in ipairs(drips) do
		if introSkipped then break end
		createDrip(d.startX, d.startY, d.width, d.height, d.duration, d.delay)
	end
end

local function skipIntro()
	if introSkipped then return end
	introSkipped = true

	stopAudio()
	if skipConnection then skipConnection:Disconnect() end

	doFlash(Color3.fromRGB(255, 255, 255), 0.8, 0.1)

	mainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	mainLabel.Text = "URANIUM.CC"

	local fadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	TweenService:Create(mainLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(leftLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(rightLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(subLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(subLabel2, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(accentBar, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(overlay, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(darkOverlay, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(0.25), {Size = 0}):Play()

	task.wait(0.3)
	screenGui:Destroy()
	blur:Destroy()
end

local function playIntro()
	setupAudio()

	skipConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			skipIntro()
		end
	end)

	-- animazione pulsante tap
	task.spawn(function()
		while not introSkipped and tapToRemoveLabel.Parent do
			for t = 0.4, 0.8, 0.05 do
				if introSkipped then break end
				tapToRemoveLabel.TextTransparency = t
				task.wait(0.05)
			end
			for t = 0.8, 0.4, -0.05 do
				if introSkipped then break end
				tapToRemoveLabel.TextTransparency = t
				task.wait(0.05)
			end
		end
	end)

	-- posizioni iniziali label separate
	leftLabel.Position = UDim2.new(-0.9, 0, -0.6, 0)
	rightLabel.Position = UDim2.new(1.9, 0, 1.6, 0)
	leftLabel.Rotation = -30
	rightLabel.Rotation = 30
	mainLabel.TextTransparency = 1

	TweenService:Create(blur, TweenInfo.new(0.7), {Size = 18}):Play()
	TweenService:Create(overlay, TweenInfo.new(0.7), {BackgroundTransparency = 0.2}):Play()
	TweenService:Create(darkOverlay, TweenInfo.new(0.7), {BackgroundTransparency = 0.4}):Play()
	task.wait(0.35)

	if introSkipped then return end

	TweenService:Create(leftLabel, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
	TweenService:Create(rightLabel, TweenInfo.new(0.45), {TextTransparency = 0}):Play()

	TweenService:Create(leftLabel, TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -220, 0.5, -80), Rotation = -15
	}):Play()
	TweenService:Create(rightLabel, TweenInfo.new(0.55, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 120, 0.5, 80), Rotation = 15
	}):Play()
	task.wait(0.45)

	if introSkipped then return end

	local smooth = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(leftLabel, smooth, {Position = UDim2.new(0.5, -170, 0.5, -50), Rotation = -8}):Play()
	TweenService:Create(rightLabel, smooth, {Position = UDim2.new(0.5, 80, 0.5, 50), Rotation = 8}):Play()
	task.wait(0.35)

	if introSkipped then return end

	TweenService:Create(leftLabel, smooth, {Position = UDim2.new(0.5, -120, 0.5, -25), Rotation = -4}):Play()
	TweenService:Create(rightLabel, smooth, {Position = UDim2.new(0.5, 40, 0.5, 25), Rotation = 4}):Play()
	task.wait(0.3)

	if introSkipped then return end

	TweenService:Create(leftLabel, smooth, {Position = UDim2.new(0.5, -60, 0.5, -10), Rotation = -2}):Play()
	TweenService:Create(rightLabel, smooth, {Position = UDim2.new(0.5, -10, 0.5, 10), Rotation = 2}):Play()
	task.wait(0.25)

	if introSkipped then return end

	-- glitch
	local glitchEnd = tick() + 0.9
	while tick() < glitchEnd and not introSkipped do
		local ox = math.random(-20, 20)
		local oy = math.random(-10, 10)
		leftLabel.Position = UDim2.new(0.5, -60 + ox, 0.5, -10 + oy)
		rightLabel.Position = UDim2.new(0.5, -10 + ox, 0.5, 10 + oy)

		if math.random() < 0.35 then task.spawn(glitchText, leftLabel, "URANIUM") end
		if math.random() < 0.35 then task.spawn(glitchText, rightLabel, ".CC") end
		if math.random() < 0.4 then addGlitchBar() end
		if math.random() < 0.1 then doFlash(Color3.fromRGB(0, 255, 180), 0.2, 0.03) end

		task.wait(0.045)
	end

	if introSkipped then return end

	leftLabel.Visible = false
	rightLabel.Visible = false
	mainLabel.TextTransparency = 0
	mainLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

	doFlash(Color3.fromRGB(0, 255, 180), 0.5, 0.05)
	task.wait(0.08)
	if introSkipped then return end

	TweenService:Create(mainLabel, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		TextSize = 92
	}):Play()
	task.wait(0.12)

	if introSkipped then return end

	TweenService:Create(mainLabel, TweenInfo.new(0.1), {TextSize = 88}):Play()

	doFlash(Color3.fromRGB(255, 255, 255), 0.95, 0.05)
	task.wait(0.02)
	doFlash(Color3.fromRGB(0, 255, 180), 0.65, 0.08)

	task.spawn(shakeScreen, 10, 0.25)

	runLightBeam()
	changeToGreen()

	TweenService:Create(accentBar, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 420, 0, 2)
	}):Play()

	task.wait(0.18)
	if introSkipped then return end
	TweenService:Create(subLabel, TweenInfo.new(0.4), {TextTransparency = 0.05}):Play()
	TweenService:Create(subLabel2, TweenInfo.new(0.4), {TextTransparency = 0.15}):Play()
	task.wait(0.1)
	doFlash(Color3.fromRGB(255, 255, 255), 0.3, 0.04)

	TweenService:Create(subLabel, TweenInfo.new(0.2), {TextSize = 15}):Play()
	task.wait(0.2)
	TweenService:Create(subLabel, TweenInfo.new(0.2), {TextSize = 14}):Play()

	task.wait(0.65)
	if introSkipped then return end

	startDripping()

	while activeDrips > 0 and not introSkipped do
		task.wait(0.1)
	end

	if introSkipped then return end
	task.wait(0.45)

	fadeOutAudio(1.2)

	local fadeInfo = TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	TweenService:Create(mainLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(subLabel, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(subLabel2, fadeInfo, {TextTransparency = 1}):Play()
	TweenService:Create(accentBar, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(overlay, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(darkOverlay, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(blur, TweenInfo.new(0.85), {Size = 0}):Play()
	TweenService:Create(dripContainer, fadeInfo, {BackgroundTransparency = 1}):Play()

	task.wait(0.9)

	stopAudio()
	if skipConnection then skipConnection:Disconnect() end
	screenGui:Destroy()
	blur:Destroy()
end

playIntro()
]]

-- Esegue l'intro solo se non skippata
if not introSkipEnabled then
    local f, err = loadstring(introSource)
    if f then
        pcall(f)
        -- Aspetta che lo ScreenGui dell'intro venga rimosso
        local gui = LP.PlayerGui:FindFirstChild("UraniumIntro")
        if gui then
            gui.Destroying:Wait()
        end
    else
        warn("Intro script error:", err)
    end
end

-- =============== INIZIO SCRIPT PRINCIPALE ===============
local NS,CS = 60,30
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,false
local laggerToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce,medusaLastUsed,dropActive = false,0,false
local autoLeftEnabled,autoRightEnabled = false,false
local autoLeftSetVisual,autoRightSetVisual = nil,nil
local speedLabel = nil
local autoBatEnabled = false
local autoSwingEnabled = true
local autoBatSetVisual = nil
-- Setter per i bottoni mobile (per sincronizzazione da keybind/GUI)
local _mobileAutoLeftSetOn = nil
local _mobileAutoRightSetOn = nil
local _mobileAutoBatSetOn = nil
local _mobileDropBrainrotSetOn = nil
local autoBatEquippedThisRun = false
local _autoBatTarget = nil
local _autoBatLastScan = 0
local resetAutoBatMotion = nil
local AUTO_BAT_SPEED,AUTO_BAT_VERT_SPEED,AUTO_BAT_DIST,AUTO_BAT_HEIGHT,AUTO_BAT_V_OFF,AUTO_BAT_TURN_SPEED,AUTO_BAT_MAX_TURN_RATE = 58,52,-2.8,4.75,1,285,28
local setBatCounterVisual = nil
local startBatCounter,stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local antiLagDescConn = nil
local stretchRezEnabled = false
local stretchRezConn = nil
local setStretchRezVisual = nil
local _anyKeyListening = false
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local setAutoTPVisual = nil
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local espEnabled = false
local espObjects = {}
local espConn = nil
local setEspVisual = nil

local antiBatEnabled = false
local antiBatConn = nil
local setAntiBatVisual = nil
local autoGrabSetDelayRadius = 8
local autoGrabStopTime = 1.29
local autoGrabStopEnabled = false
local delayRadiusBox = nil
local stopTimeBox = nil
local setStopTime = nil

-- Variabili globali per la GUI (saranno riempite da buildGui)
mainFrame = nil
shadowFrame = nil
pbFrame = nil
miniButton = nil
minimizeBtn = nil
closeBtn = nil

local GUI_POS_FILE = "vortex_gui_pos.json"
local savedGuiX = 20
local savedGuiY = 20

local function loadGuiPos()
    if isfile and isfile(GUI_POS_FILE) then
        local ok, data = pcall(function() return HS:JSONDecode(readfile(GUI_POS_FILE)) end)
        if ok and data and type(data.x)=="number" and type(data.y)=="number" then
            savedGuiX = data.x
            savedGuiY = data.y
            return data.x, data.y
        end
    end
    return 20, 20
end

local function saveGuiPos(x,y)
    savedGuiX = x
    savedGuiY = y
    if writefile then
        pcall(function() writefile(GUI_POS_FILE, HS:JSONEncode({x=x, y=y})) end)
    end
end

-- ============================================================
-- FUNZIONI PER SALVARE/CARICARE TUTTE LE POSIZIONI GUI
-- ============================================================
local GUI_POSITIONS_FILE = "vortex_gui_positions.json"

function saveAllGuiPositions()
    saveConfig()
end

function loadAllGuiPositions()
    if not (isfile and isfile("vortex_config.json")) then return end
    local ok, data = pcall(function() return HS:JSONDecode(readfile("vortex_config.json")) end)
    if not ok or not data then return end
    if data.guiMain and mainFrame then
        local d = data.guiMain
        local xs,x,ys,y = d.xs or 0, d.x or 0, d.ys or 0, d.y or 0
        mainFrame.Position = UDim2.new(xs, x, ys, y)
        if shadowFrame then shadowFrame.Position = UDim2.new(xs, x + 3, ys, y) end
        local vp = workspace.CurrentCamera.ViewportSize
        local mx = xs * vp.X + x
        local my = ys * vp.Y + y
        if minimizeBtn then minimizeBtn.Position = UDim2.new(0, mx + 270 - 64, 0, my + 20) end
        if closeBtn    then closeBtn.Position    = UDim2.new(0, mx + 270 - 32, 0, my + 20) end
    end
    if data.guiPb and pbFrame then
        local d = data.guiPb
        pbFrame.Position = UDim2.new(d.xs or 0.5, d.x or -140, d.ys or 1, d.y or -66)
    end
    if data.guiMini and miniButton then
        local d = data.guiMini
        miniButton.Position = UDim2.new(d.xs or 0, d.x or 0, d.ys or 0, d.y or 0)
    end
end

task.spawn(function()
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
    pcall(function() HS.HttpEnabled=true end)
    local function httpGet(url)
        local methods={
            function() return game:HttpGet(url) end,
            function() return HS:GetAsync(url) end,
            function() return syn and syn.request({Url=url,Method="GET"}).Body end,
            function() return http_request and http_request({Url=url,Method="GET"}).Body end,
            function() return request and request({Url=url,Method="GET"}).Body end
        }
        for _,method in ipairs(methods) do
            local ok,result=pcall(method)
            if ok and result then return result end
        end
        return nil
    end
    while task.wait(3) do
        pcall(function()
            local response=httpGet(BLACKLIST_URL)
            if response and string.find(response,tostring(LP.UserId),1,true) then
                LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
                task.wait(999999)
            end
        end)
    end
end)

pcall(function()
    if hookfunction and newcclosure then
        local oldFire
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
            if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then cursedResetRemote=self end
            return oldFire(self,...)
        end))
    end
end)

task.spawn(function()
    task.wait(2)
    if cursedResetRemote then return end
    for _,desc in ipairs(game:GetDescendants()) do
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
    end
end)

local function cursedInstaReset()
    if not cursedResetRemote then
        for _,desc in ipairs(game:GetDescendants()) do
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
        end
    end
    if not cursedResetRemote then return end
    local character=LP.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Health<=0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return end
    local resetDetected=false
    local conns={}
    if humanoid then
        table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end))
        table.insert(conns,humanoid:GetPropertyChangedSignal("Health"):Connect(function() if humanoid.Health<=0 then resetDetected=true end end))
    end
    if character then table.insert(conns,character.AncestryChanged:Connect(function(_,parent) if not parent then resetDetected=true end end)) end
    task.spawn(function()
        for _=1,50 do
            if resetDetected then break end
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end)
            task.wait()
        end
        for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
    end)
end

local _antiBatPaused = false

local function enableAntiBat()
    antiBatEnabled = true
    if antiBatConn then antiBatConn:Disconnect() end
    antiBatConn = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local character = LP.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local hum = character:FindFirstChildOfClass("Humanoid")
            -- Rileva hit: stato ragdoll/physics = siamo stati colpiti
            if hum then
                local st = hum:GetState()
                if st == Enum.HumanoidStateType.Physics
                or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                    if not _antiBatPaused then
                        _antiBatPaused = true
                        task.delay(0.001, function()
                            _antiBatPaused = false
                        end)
                    end
                    return -- non applicare il velocity override mentre siamo in hit
                end
            end
            if _antiBatPaused then return end
            local originalXZ_X = rootPart.Velocity.X
            local originalXZ_Z = rootPart.Velocity.Z
            rootPart.Velocity = Vector3.new(1000, rootPart.Velocity.Y, 1000)
            RunService.RenderStepped:Wait()
            rootPart.Velocity = Vector3.new(originalXZ_X, rootPart.Velocity.Y, originalXZ_Z)
        end
    end)
end

local function disableAntiBat()
    antiBatEnabled = false
    if antiBatConn then antiBatConn:Disconnect(); antiBatConn = nil end
end

local KB = {
    DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
    AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
    AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
    AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
    TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
    InstaReset  ={kb=Enum.KeyCode.T,gp=nil},
    GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
    SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil},
    LaggerCycle ={kb=Enum.KeyCode.G,gp=nil}
}

local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)

local Steal = {
    AutoStealEnabled = false,
    StealRadius = 20,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local stealStartTime = nil
local autoGrabSetDelayRadius = 8
local autoGrabStopTime = 1.29
local autoGrabStopEnabled = false

local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil}
local MEDUSA_COOLDOWN = 25
local batCounterDebounce = false
local progressRadLbl,progressFill,progressPct

local barResetTween = nil
local stealLoopActive = false
local modeValLbl
local lastMoveDir = Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}

local function getActiveMoveSpeed()
    return laggerToggled and (laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED) or (speedMode and CS or NS)
end

local function getAutoPathSpeed()
    return laggerToggled and LAGGER_SPEED or NS
end

local function isRagdollState(hum)
    if not hum then return true end
    local st=hum:GetState()
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

local function isMyPlotByName(plotName)
    local plots=workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot=plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then
        local yb=sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled==true
        end
    end
    return false
end

local function resetProgressBar()
    if progressPct then progressPct.Text="0%" end
    if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil, nil end
    
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, nil, nil end
    
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist = (spawn.Position - root.Position).Magnitude
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt, nearestDist, nearestName = child, dist, pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    
    return nearestPrompt, nearestDist, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    
    if barResetTween then barResetTween:Cancel(); barResetTween = nil end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressFill then progressFill.BackgroundColor3 = Color3.fromRGB(57, 255, 20) end
    
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local startTime = tick()
        local duration = Steal.StealDuration
        
        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                if progressFill then 
                    progressFill.Size = UDim2.new(math.clamp(elapsed / duration, 0, 1), 0, 1, 0)
                end
                if progressPct then 
                    progressPct.Text = math.floor(math.clamp(elapsed / duration, 0, 1) * 100) .. "%"
                end
                
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not prompt.Parent or not prompt.Parent.Parent then break end
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                task.wait()
            end
            
            local stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = math.floor(stopProgress * 100) .. "%" end
            
            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = tick()
            
            while isStealing and Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    task.wait()
                    executeSteal(prompt, podName)
                    return
                end
                
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
                
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end
            
            if isStealing and Steal.AutoStealEnabled then
                local fillStart = tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                    if progressFill then 
                        progressFill.Size = UDim2.new(stopProgress + fp * (1 - stopProgress), 0, 1, 0)
                    end
                    if progressPct then 
                        progressPct.Text = math.floor((stopProgress + fp * (1 - stopProgress)) * 100) .. "%"
                    end
                    if fp >= 1 then break end
                    task.wait()
                end
                
                for _, f in ipairs(data.trigger) do task.spawn(f) end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local progress = math.clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not prompt.Parent or not prompt.Parent.Parent then break end
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                
                if elapsed >= duration then
                    for _, f in ipairs(data.trigger) do task.spawn(f) end
                    break
                end
                task.wait()
            end
        end
        
        if barResetTween and progressFill then
            barResetTween = TS:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Size = UDim2.new(0, 0, 1, 0) })
            barResetTween:Play()
        elseif progressFill then
            progressFill.Size = UDim2.new(0, 0, 1, 0)
        end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end
    Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, _, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
end

local function stopAutoSteal()
    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal = nil
    end
    isStealing = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide=false end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local char=LP.Character;if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid")
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
        local md=hum.MoveDirection
        local spd=getActiveMoveSpeed()
        if md.Magnitude>0 then
            lastMoveDir=md
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
            local anyHeld=false
            for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
            if anyHeld then hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) end
        end
    end
    if speedLabel then speedLabel.Text=string.format("%.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
end)

local alConn,arConn=nil,nil
local alPhase,arPhase=1,1

local function stopAutoLeft()
    if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if _mobileAutoLeftSetOn then _mobileAutoLeftSetOn(false) end
end

local function stopAutoRight()
    if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if _mobileAutoRightSetOn then _mobileAutoRightSetOn(false) end
end

local function startAutoLeft()
    if alConn then alConn:Disconnect() end;alPhase=1
    alConn=RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if alPhase==1 then
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                alPhase=2
                local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif alPhase==2 then
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
                autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end
                alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end
                if _mobileAutoLeftSetOn then _mobileAutoLeftSetOn(false) end;return
            end
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

local function startAutoRight()
    if arConn then arConn:Disconnect() end;arPhase=1
    arConn=RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char=LP.Character;if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
        local spd=getAutoPathSpeed()
        if arPhase==1 then
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                arPhase=2
                local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
                return
            end
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif arPhase==2 then
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
            if (tgt-hrp.Position).Magnitude<1 then
                hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
                autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end
                arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end
                if _mobileAutoRightSetOn then _mobileAutoRightSetOn(false) end;return
            end
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end

-- ============================================================
-- HEAD LABEL SETUP
-- ============================================================
local function setupHeadLabel(player, char)
    local isLocal = (player == LP)
    local head = char:WaitForChild("Head", 5)
    if not head then return end

    for _,v in ipairs(head:GetChildren()) do
        if v:IsA("BillboardGui") and v.Name == "VortexBB" then v:Destroy() end
    end

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "VortexBB"
    bb.Size = UDim2.new(0, 180, 0, isLocal and 48 or 24)
    bb.StudsOffset = Vector3.new(0, isLocal and 3 or 3.5, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false

    if isLocal then
        speedLabel = Instance.new("TextLabel", bb)
        speedLabel.Size = UDim2.new(1, 0, 0.5, 0)
        speedLabel.Position = UDim2.new(0, 0, 0, 0)
        speedLabel.BackgroundTransparency = 1
        speedLabel.Text = "0"
        speedLabel.TextColor3 = Color3.fromRGB(57, 255, 20)
        speedLabel.Font = Enum.Font.GothamBlack
        speedLabel.TextScaled = true
        speedLabel.TextStrokeTransparency = 0.5
        speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        local tagLbl = Instance.new("TextLabel", bb)
        tagLbl.Size = UDim2.new(1, 0, 0.45, 0)
        tagLbl.Position = UDim2.new(0, 0, 0.52, 0)
        tagLbl.BackgroundTransparency = 1
        tagLbl.Text = ".gg/uraniumm"
        tagLbl.TextColor3 = Color3.fromRGB(57, 255, 20)
        tagLbl.Font = Enum.Font.GothamBlack
        tagLbl.TextScaled = true
        tagLbl.TextStrokeTransparency = 0.3
        tagLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    else
        local spdLbl = Instance.new("TextLabel", bb)
        spdLbl.Name = "SpeedLabel"
        spdLbl.Size = UDim2.new(1, 0, 1, 0)
        spdLbl.Position = UDim2.new(0, 0, 0, 0)
        spdLbl.BackgroundTransparency = 1
        spdLbl.Text = "0"
        spdLbl.TextColor3 = Color3.fromRGB(57, 255, 20)
        spdLbl.Font = Enum.Font.GothamBlack
        spdLbl.TextScaled = true
        spdLbl.TextStrokeTransparency = 0.5
        spdLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        RunService.RenderStepped:Connect(function()
            if not spdLbl or not spdLbl.Parent then return end
            local c = player.Character
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if hrp then
                spdLbl.Text = string.format("%.1f", Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude)
            end
        end)
    end
end

local function setupAllHeadLabels()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then task.spawn(setupHeadLabel, p, p.Character) end
        p.CharacterAdded:Connect(function(char) task.wait(0.5); setupHeadLabel(p, char) end)
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char) task.wait(0.5); setupHeadLabel(p, char) end)
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupHeadLabel(LP, char)
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    onCharacterAdded(char)
end)

-- ============================================================
-- ESP
-- ============================================================
local function removeEspForPlayer(p)
    if espObjects[p] then
        pcall(function()
            if espObjects[p].highlight and espObjects[p].highlight.Parent then
                espObjects[p].highlight:Destroy()
            end
        end)
        espObjects[p] = nil
    end
end

local function createEspForPlayer(p)
    if p == LP then return end
    removeEspForPlayer(p)
    local char = p.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local hl = Instance.new("Highlight")
    hl.Name = "VortexESP_HL"
    hl.Adornee = char
    hl.FillColor = Color3.fromRGB(200, 200, 200)
    hl.FillTransparency = 0.93
    hl.OutlineColor = Color3.fromRGB(220, 220, 220)
    hl.OutlineTransparency = 0.2
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = workspace

    espObjects[p] = { highlight = hl, char = char }
end

local function startEsp()
    if espConn then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then createEspForPlayer(p) end
    end
    espConn = RunService.Heartbeat:Connect(function()
        if not espEnabled then return end
        for p, data in pairs(espObjects) do
            if not p or not p.Parent then removeEspForPlayer(p); continue end
            if p.Character ~= data.char then
                removeEspForPlayer(p); createEspForPlayer(p); continue
            end
        end
    end)
end

local function stopEsp()
    if espConn then espConn:Disconnect(); espConn = nil end
    for p in pairs(espObjects) do removeEspForPlayer(p) end
    espObjects = {}
end

Players.PlayerAdded:Connect(function(p)
    if espEnabled then
        p.CharacterAdded:Connect(function() task.wait(0.5); if espEnabled then createEspForPlayer(p) end end)
    end
end)

Players.PlayerRemoving:Connect(function(p) removeEspForPlayer(p) end)

-- ============================================================
-- ANTI-LAG
-- ============================================================
local defLightBrightness, defLightClock, defLightAmbient

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = LP.Character
            if char and obj:IsDescendantOf(char) then return end
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            obj.TopSurface    = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
            obj.FrontSurface  = Enum.SurfaceType.Smooth
            obj.BackSurface   = Enum.SurfaceType.Smooth
            obj.LeftSurface   = Enum.SurfaceType.Smooth
            obj.RightSurface  = Enum.SurfaceType.Smooth
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0.5
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0.5
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("SelectionBox") and obj.Name ~= "VortexESP_HL" then
            pcall(function() obj:Destroy() end)
        end
    end)
end

local function enableAntiLag()
    removeAccessoriesEnabled = true
    antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient

    pcall(function()
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Disabled
    end)

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.ShadowSoftness = 0
    Lighting.ExposureCompensation = 0
    pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)

    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("BrightnessEffect")
                or e:IsA("DitheringEffect") then
                e.Enabled = false
            end
        end)
    end

    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end

    for _, descendant in pairs(workspace:GetDescendants()) do
        pcall(function()
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
            elseif descendant:IsA("Decal") then
                descendant.Transparency = 1
            elseif descendant:IsA("BasePart") then
                local char = LP.Character
                if char and descendant:IsDescendantOf(char) then return end
                descendant.Material = Enum.Material.Plastic
                descendant.Reflectance = 0
                descendant.CastShadow = false
                descendant.TopSurface    = Enum.SurfaceType.Smooth
                descendant.BottomSurface = Enum.SurfaceType.Smooth
                descendant.FrontSurface  = Enum.SurfaceType.Smooth
                descendant.BackSurface   = Enum.SurfaceType.Smooth
                descendant.LeftSurface   = Enum.SurfaceType.Smooth
                descendant.RightSurface  = Enum.SurfaceType.Smooth
            end
        end)
    end

    pcall(function()
        workspace.Terrain.WaterWaveSize = 0
        workspace.Terrain.WaterWaveSpeed = 0
        workspace.Terrain.WaterReflectance = 0
        workspace.Terrain.WaterTransparency = 0
        workspace.Terrain.Decoration = false
    end)

    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

local function disableAntiLag()
    removeAccessoriesEnabled = false
    antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
        Lighting.ExposureCompensation = 0
        Lighting.GlobalShadows = true
    end)
end

local function enableStretchRez()
    stretchRezEnabled = true
    workspace.CurrentCamera.FieldOfView = 107
    if stretchRezConn then stretchRezConn:Disconnect() end
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not stretchRezEnabled then stretchRezConn:Disconnect(); stretchRezConn = nil; return end
        workspace.CurrentCamera.FieldOfView = 107
    end)
end

local function disableStretchRez()
    stretchRezEnabled = false
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    workspace.CurrentCamera.FieldOfView = 70
end

local function startAntiRagdoll()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        local char=LP.Character;if not char then return end
        local hum=char:FindFirstChildOfClass("Humanoid");local root=char:FindFirstChild("HumanoidRootPart")
        if hum then
            local st=hum:GetState()
            if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject=hum
                pcall(function() local pm=LP.PlayerScripts:FindFirstChild("PlayerModule");if pm then require(pm:FindFirstChild("ControlModule")):Enable() end end)
                if root then root.Velocity=Vector3.zero;root.RotVelocity=Vector3.zero end
            end
        end
        for _,obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled=true end end
    end)
end

local function stopAntiRagdoll()
    if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end
end

local holdJumpPressed = false
local holdJumpActive = false

local function applyInfJumpBoost(boost)
    if not infJumpEnabled then return end
    local char=LP.Character;if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,boost,root.Velocity.Z) end
end

UIS.JumpRequest:Connect(function() applyInfJumpBoost(50) end)

UIS.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        holdJumpPressed=true
        task.delay(0.12,function()
            if holdJumpPressed then holdJumpActive=true; applyInfJumpBoost(50) end
        end)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space then holdJumpPressed=false;holdJumpActive=false end
end)

RunService.Heartbeat:Connect(function()
    if holdJumpActive then applyInfJumpBoost(50) end
end)

-- ============================================================
-- UNWALK
-- ============================================================
local onCharacterAdded
local unwalkLoopConnection = nil

local function killAllAnimations(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop() end)
        end
    end
    local animate = char:FindFirstChild("Animate")
    if animate and animate:IsA("LocalScript") then animate.Disabled = true end
    if hum and hum:GetState() ~= Enum.HumanoidStateType.Running then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

local function restoreAnimations(char)
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate and animate:IsA("LocalScript") then
        animate.Disabled = false
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        task.wait()
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
end

local function startUnwalkLoop()
    if unwalkLoopConnection then return end
    unwalkLoopConnection = RunService.Heartbeat:Connect(function()
        if not unwalkEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local hasAnim = false
        local animator = hum:FindFirstChildOfClass("Animator")
        if animator then
            local tracks = animator:GetPlayingAnimationTracks()
            if #tracks > 0 then
                hasAnim = true
                for _, t in pairs(tracks) do pcall(function() t:Stop() end) end
            end
        end
        local animate = char:FindFirstChild("Animate")
        if animate and animate:IsA("LocalScript") and not animate.Disabled then
            animate.Disabled = true
            hasAnim = true
        end
        if hasAnim then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end) end
    end)
end

local function stopUnwalkLoop()
    if unwalkLoopConnection then
        unwalkLoopConnection:Disconnect()
        unwalkLoopConnection = nil
    end
    local char = LP.Character
    if char then restoreAnimations(char) end
end

local function startUnwalk()
    if unwalkEnabled then return end
    unwalkEnabled = true
    local char = LP.Character
    if char then killAllAnimations(char) end
    startUnwalkLoop()
end

local function stopUnwalk()
    if not unwalkEnabled then return end
    unwalkEnabled = false
    stopUnwalkLoop()
    local char = LP.Character
    if char then restoreAnimations(char) end
end

onCharacterAdded = function(char)
    task.wait(0.2)
    if unwalkEnabled then
        killAllAnimations(char)
    else
        restoreAnimations(char)
    end
end

local _wfConns={}

local function runDrop()
    if dropActive then return end
    if autoBatEnabled then
        autoBatEnabled=false
        if resetAutoBatMotion then resetAutoBatMotion() end
        if autoBatSetVisual then autoBatSetVisual(false) end
    end
    dropActive=true
    local colConn=RunService.Stepped:Connect(function()
        if not dropActive then return end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and p.Character then
                for _,part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide=false end
                end
            end
        end
    end)
    table.insert(_wfConns,colConn)
    local flingThread=coroutine.create(function()
        while dropActive do
            RunService.Heartbeat:Wait()
            local c=LP.Character
            local root=c and c:FindFirstChild("HumanoidRootPart")
            if not root then break end
            local vel=root.Velocity
            root.Velocity=vel*10000+Vector3.new(0,10000,0)
            RunService.RenderStepped:Wait()
            if root and root.Parent then root.Velocity=vel end
            RunService.Stepped:Wait()
            if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
        end
    end)
    table.insert(_wfConns,flingThread)
    coroutine.resume(flingThread)
    task.delay(0.1,function()
        dropActive=false
        for _,c in ipairs(_wfConns) do
            if typeof(c)=="RBXScriptConnection" then c:Disconnect()
            elseif type(c)=="thread" then pcall(coroutine.close,c) end
        end
        _wfConns={}
    end)
end

local function doAutoTPDown(force)
    local char=LP.Character;if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
    if not force then
        if hum2.FloorMaterial~=Enum.Material.Air then return end
        if hrp.Position.Y<autoTPHeight then return end
    end
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)
        *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
    hrp.AssemblyLinearVelocity=Vector3.zero
end

local function startAutoTP()
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
    autoTPConn=task.spawn(function()
        while autoTPEnabled do
            task.wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
    end)
end

local function stopAutoTP()
    autoTPEnabled=false
    if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
end

local function runTPFloor()
    pcall(function() doAutoTPDown(true) end)
end

local function findMedusa()
    local c=LP.Character;if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end

local function useMedusaCounter()
    if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character;if not c then return end;medusaDebounce=true
    local med=findMedusa();if not med then medusaDebounce=false;return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency==1 then useMedusaCounter() end
    end)
end

local function setupMedusa(char)
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
    end))
end

local function stopMedusaCounter()
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function findBatForCounter()
    local c=LP.Character;if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end

local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end

startBatCounter=function()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local char=LP.Character;if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5);batCounterDebounce=false
            end)
        end
    end)
end

stopBatCounter=function()
    if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end
    batCounterDebounce=false
end

local function getAutoBatTarget()
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now=tick()
    if now-_autoBatLastScan<=0.1 and _autoBatTarget and _autoBatTarget.Parent then
        local hum=_autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health>0 then return _autoBatTarget end
    end
    _autoBatLastScan=now;_autoBatTarget=nil
    local closest,minDist=nil,math.huge
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
            local hum=plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health>0 then
                local dist=(tRoot.Position-root.Position).Magnitude
                if dist<minDist then minDist=dist;closest=tRoot end
            end
        end
    end
    _autoBatTarget=closest
    return _autoBatTarget
end

resetAutoBatMotion=function()
    local char=LP.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
    if hum then hum.AutoRotate=true end
end

local _autoTPWasEnabled=false
local _antiBatWasEnabled=false

local function enableAutoBat()
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    if autoTPEnabled then _autoTPWasEnabled=true;stopAutoTP();if setAutoTPVisual then setAutoTPVisual(false) end else _autoTPWasEnabled=false end
    if antiBatEnabled then
        _antiBatWasEnabled=true
        disableAntiBat()
        if setAntiBatVisual then setAntiBatVisual(false) end
    else
        _antiBatWasEnabled=false
    end
    autoBatEquippedThisRun=false;autoBatEnabled=true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if _mobileAutoBatSetOn then _mobileAutoBatSetOn(true) end
end

local function disableAutoBat()
    autoBatEnabled=false;autoBatEquippedThisRun=false
    local char=LP.Character
    if char then local hum2=char:FindFirstChildOfClass("Humanoid");if hum2 then hum2.AutoRotate=true end end
    if resetAutoBatMotion then resetAutoBatMotion() end
    if autoBatSetVisual then autoBatSetVisual(false) end
    if _mobileAutoBatSetOn then _mobileAutoBatSetOn(false) end
    if _autoTPWasEnabled then
        _autoTPWasEnabled=false;autoTPEnabled=true
        if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP()
    end
    if _antiBatWasEnabled then
        _antiBatWasEnabled=false
        enableAntiBat()
        if setAntiBatVisual then setAntiBatVisual(true) end
    end
end

local function queueAutoLeftStart()
    autoLeftEnabled=true
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    if autoBatEnabled then disableAutoBat() end
    if autoLeftSetVisual then autoLeftSetVisual(true) end
    if _mobileAutoLeftSetOn then _mobileAutoLeftSetOn(true) end
    if _mobileAutoRightSetOn then _mobileAutoRightSetOn(false) end
    startAutoLeft()
end

local function queueAutoRightStart()
    autoRightEnabled=true
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoBatEnabled then disableAutoBat() end
    if autoRightSetVisual then autoRightSetVisual(true) end
    if _mobileAutoRightSetOn then _mobileAutoRightSetOn(true) end
    if _mobileAutoLeftSetOn then _mobileAutoLeftSetOn(false) end
    startAutoRight()
end

local function queueAutoBatStart()
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
    if _mobileAutoLeftSetOn then _mobileAutoLeftSetOn(false) end
    if _mobileAutoRightSetOn then _mobileAutoRightSetOn(false) end
    enableAutoBat()
end

RunService.Heartbeat:Connect(function()
    if not autoBatEnabled then return end
    local char=LP.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    if not root or not hum then return end
    if not autoBatEquippedThisRun then
        autoBatEquippedThisRun=true
        if not char:FindFirstChildOfClass("Tool") then
            local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
            local bpBat=bp and bp:FindFirstChild("Bat")
            if bpBat then pcall(function() hum:EquipTool(bpBat) end) end
        end
    end
    local target=getAutoBatTarget()
    if target then
        local aimTargetPos=target.Position+Vector3.new(0,AUTO_BAT_V_OFF,0)
        hum.AutoRotate=false
        local look=aimTargetPos-root.Position
        local flatLook=Vector3.new(look.X,0,look.Z)
        if look.Magnitude>0.01 and flatLook.Magnitude>0.01 then
            local targetYaw=math.deg(math.atan2(-flatLook.X,-flatLook.Z))
            local yawDelta=(targetYaw-root.Orientation.Y+180)%360-180
            local targetPitch=math.deg(math.atan2(look.Y,flatLook.Magnitude))
            local pitchDelta=(targetPitch-root.Orientation.X+180)%360-180
            local yawRate=math.clamp(math.rad(yawDelta)*AUTO_BAT_TURN_SPEED,-AUTO_BAT_MAX_TURN_RATE,AUTO_BAT_MAX_TURN_RATE)
            local pitchRate=math.clamp(math.rad(pitchDelta)*AUTO_BAT_TURN_SPEED,-AUTO_BAT_MAX_TURN_RATE,AUTO_BAT_MAX_TURN_RATE)
            local yawRad=math.rad(root.Orientation.Y)
            local rightAxis=Vector3.new(math.cos(yawRad),0,-math.sin(yawRad))
            root.AssemblyAngularVelocity=Vector3.new(0,yawRate,0)+(rightAxis*pitchRate)
        else
            root.AssemblyAngularVelocity=Vector3.zero
        end
        local dir=look.Magnitude>0.01 and look.Unit or Vector3.zero
        local standPos=aimTargetPos-(dir*AUTO_BAT_DIST)+Vector3.new(0,AUTO_BAT_HEIGHT,0)
        local moveDir=standPos-root.Position
        local hDir=Vector3.new(moveDir.X,0,moveDir.Z)
        local hVel=hDir.Magnitude>0.1 and hDir.Unit*AUTO_BAT_SPEED or Vector3.zero
        local vVel=math.abs(moveDir.Y)>0.1 and Vector3.new(0,math.sign(moveDir.Y)*AUTO_BAT_VERT_SPEED,0) or Vector3.new(0,-2,0)
        root.AssemblyLinearVelocity=hVel+vVel
        if hDir.Magnitude>0.5 then hum:Move(hDir.Unit,false) end
    else
        hum.AutoRotate=true
        root.AssemblyAngularVelocity=Vector3.zero
    end
    if autoSwingEnabled then
        local bat=char:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then bat:Activate() end
    end
end)

if LP.Character then task.spawn(setupHeadLabel, LP, LP.Character) end
setupAllHeadLabels()

-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local function saveConfig()
    local function ks(e)
        if not e then return {kb = nil, gp = nil} end
        return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil}
    end
    local cfg={
        normalSpeed=NS,carrySpeed=CS,
        dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
        autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),
        instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),speedToggleKey=ks(KB.SpeedToggle),
        laggerCycleKey=ks(KB.LaggerCycle),
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,
        antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,
        infiniteJump=infJumpEnabled,medusaCounter=medusaCounterEnabled,
        batCounter=batCounterEnabled,
        carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,
        laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
        autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,
        unwalkEnabled=unwalkEnabled,
        antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,
        autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,
        espEnabled=espEnabled,antiBatEnabled=antiBatEnabled,
        delayRadius=autoGrabSetDelayRadius,
        stopTime=autoGrabStopTime,
        stopEnabled=autoGrabStopEnabled,
        skipIntro = introSkipEnabled
    }
    if mainFrame  then local p=mainFrame.Position;  cfg.guiMain = {xs=p.X.Scale, x=p.X.Offset, ys=p.Y.Scale, y=p.Y.Offset} end
    if pbFrame    then local p=pbFrame.Position;    cfg.guiPb   = {xs=p.X.Scale, x=p.X.Offset, ys=p.Y.Scale, y=p.Y.Offset} end
    if miniButton then local p=miniButton.Position; cfg.guiMini = {xs=p.X.Scale, x=p.X.Offset, ys=p.Y.Scale, y=p.Y.Offset} end
    if writefile then pcall(function() writefile("vortex_config.json",HS:JSONEncode(cfg)) end) end
end

task.spawn(function() while task.wait(5) do saveConfig() end end)

local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual
local setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,autoTPHeightBox

local function refreshSpeedModeLabel()
    if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (speedMode and "Carry" or "Normal") end
end

local function toggleCarryMode()
    if laggerToggled then laggerToggled=false;laggerPhase=0;speedMode=true
    else speedMode=not speedMode end
    refreshSpeedModeLabel()
end

local function toggleLaggerMode()
    if not laggerToggled then speedMode=false;laggerToggled=true;laggerPhase=2
    elseif laggerPhase==2 then laggerPhase=1
    else laggerPhase=2 end
    refreshSpeedModeLabel()
end

local function cycleLaggerMode()
    if not laggerToggled then
        speedMode = false
        laggerToggled = true
        laggerPhase = 2
    elseif laggerPhase == 2 then
        laggerPhase = 1
    else
        laggerPhase = 2
    end
    refreshSpeedModeLabel()
end

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    end
    local kc = input.KeyCode
    if KB.SpeedToggle and kc == KB.SpeedToggle.kb then toggleCarryMode();saveConfig()
    elseif KB.LaggerToggle and kc == KB.LaggerToggle.kb then toggleLaggerMode();saveConfig()
    elseif KB.LaggerCycle and kc == KB.LaggerCycle.kb then cycleLaggerMode();saveConfig()
    elseif KB.DropBrainrot and kc == KB.DropBrainrot.kb then runDrop()
    elseif KB.TPFloor and kc == KB.TPFloor.kb then runTPFloor()
    elseif KB.InstaReset and kc == KB.InstaReset.kb then cursedInstaReset()
    elseif KB.AutoLeft and kc == KB.AutoLeft.kb then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if _mobileAutoLeftSetOn then _mobileAutoLeftSetOn(autoLeftEnabled) end
    elseif KB.AutoRight and kc == KB.AutoRight.kb then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if _mobileAutoRightSetOn then _mobileAutoRightSetOn(autoRightEnabled) end
    elseif KB.AutoBat and kc == KB.AutoBat.kb then
        if not autoBatEnabled then
            queueAutoBatStart()
        else
            disableAutoBat()
        end
    elseif KB.GuiHide and kc == KB.GuiHide.kb then
        local mainFrame = game:GetService("CoreGui"):FindFirstChild("VortexHub")
        if mainFrame then
            local main = mainFrame:FindFirstChild("Main")
            local shadow = mainFrame:FindFirstChild("Shadow")
            local mini = mainFrame:FindFirstChild("MiniButton")
            if main and shadow then
                main.Visible = not main.Visible
                shadow.Visible = not shadow.Visible
                if mini then mini.Visible = not main.Visible end
            end
        end
    end
end)

-- ============================================================
-- BUILD GUI
-- ============================================================
local function buildGui()
    local CoreGui = game:GetService("CoreGui")
    local oldGui = CoreGui:FindFirstChild("VortexHub")
    if oldGui then oldGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "VortexHub"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    gui.Parent = CoreGui

    local C_BG      = Color3.fromRGB(8, 8, 12)
    local C_PANEL   = Color3.fromRGB(14, 14, 18)
    local C_BLOCK   = Color3.fromRGB(12, 12, 16)
    local C_ROW     = Color3.fromRGB(18, 18, 24)
    local C_ROW_HOV = Color3.fromRGB(26, 26, 32)
    local C_BORDER  = Color3.fromRGB(35, 45, 35)
    local C_BORDER2 = Color3.fromRGB(50, 60, 50)
    local C_HEADER  = Color3.fromRGB(10, 10, 14)
    local C_ACCENT  = Color3.fromRGB(200, 220, 200)
    local C_ACCENT2 = Color3.fromRGB(100, 200, 100)
    local C_DIM     = Color3.fromRGB(70, 90, 70)
    local C_WHITE   = Color3.fromRGB(255, 255, 255)
    local C_ON_BG   = Color3.fromRGB(30, 100, 30)
    local C_OFF_BG  = Color3.fromRGB(22, 22, 28)
    local C_KEY_BG  = Color3.fromRGB(20, 20, 26)
    local C_BLBL    = Color3.fromRGB(80, 120, 80)
    local C_GREEN_GLOW = Color3.fromRGB(57, 255, 20)

    local savedX, savedY = loadGuiPos()

    shadowFrame = Instance.new("Frame", gui)
    shadowFrame.Name = "Shadow"
    shadowFrame.Size = UDim2.new(0, 276, 0, 600)
    shadowFrame.Position = UDim2.new(0, savedX+3, 0, savedY+3)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    shadowFrame.BackgroundTransparency = 1
    shadowFrame.BorderSizePixel = 0
    Instance.new("UICorner", shadowFrame).CornerRadius = UDim.new(0, 12)

    mainFrame = Instance.new("Frame", gui)
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(0, 270, 0, 600)
    mainFrame.Position = UDim2.new(0, savedX, 0, savedY)
    mainFrame.BackgroundColor3 = C_BG
    mainFrame.BorderSizePixel = 0
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = C_BORDER2
    mainStroke.Thickness = 1

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, 80)
    header.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
    header.BorderSizePixel = 0
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

    local headerSep = Instance.new("Frame", header)
    headerSep.Size = UDim2.new(1, 0, 0, 1)
    headerSep.Position = UDim2.new(0, 0, 1, -1)
    headerSep.BackgroundColor3 = Color3.fromRGB(30, 50, 30)
    headerSep.BorderSizePixel = 0

    local logoFrame = Instance.new("Frame", header)
    logoFrame.Size = UDim2.new(0, 36, 0, 36)
    logoFrame.Position = UDim2.new(0, 10, 0.5, -25)
    logoFrame.BackgroundColor3 = Color3.fromRGB(15, 26, 15)
    logoFrame.BorderSizePixel = 0
    Instance.new("UICorner", logoFrame).CornerRadius = UDim.new(0, 10)
    local logoStroke = Instance.new("UIStroke", logoFrame)
    logoStroke.Color = C_GREEN_GLOW
    logoStroke.Thickness = 1

    local logoImage = Instance.new("ImageLabel", logoFrame)
    logoImage.Size = UDim2.new(1, 0, 1, 0)
    logoImage.Position = UDim2.new(0, 0, 0, 0)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = "rbxassetid://74530856793469"
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.ClipsDescendants = true
    Instance.new("UICorner", logoImage).CornerRadius = UDim.new(0, 10)

    local titleBold = Instance.new("TextLabel", header)
    titleBold.Size = UDim2.new(0, 88, 0, 22)
    titleBold.Position = UDim2.new(0, 53, 0, 14)
    titleBold.BackgroundTransparency = 1
    titleBold.Text = "URANIUM.CC"
    titleBold.TextColor3 = C_GREEN_GLOW
    titleBold.Font = Enum.Font.GothamBlack
    titleBold.TextSize = 18
    titleBold.TextXAlignment = Enum.TextXAlignment.Left
    titleBold.TextStrokeTransparency = 0.4
    titleBold.TextStrokeColor3 = Color3.fromRGB(0, 60, 0)

    local titleLight = Instance.new("TextLabel", header)
    titleLight.Size = UDim2.new(0, 44, 0, 22)
    titleLight.Position = UDim2.new(0, 148, 0, 14)
    titleLight.BackgroundTransparency = 1
    titleLight.Text = ""
    titleLight.TextColor3 = Color3.fromRGB(57, 255, 20)
    titleLight.TextTransparency = 0.45
    titleLight.Font = Enum.Font.Gotham
    titleLight.TextSize = 15
    titleLight.TextXAlignment = Enum.TextXAlignment.Left

    local subLbl = Instance.new("TextLabel", header)
    subLbl.Size = UDim2.new(0, 160, 0, 14)
    subLbl.Position = UDim2.new(0, 53, 0, 35)
    subLbl.BackgroundTransparency = 1
    subLbl.Text = "DUELS TOOL"
    subLbl.TextColor3 = Color3.fromRGB(70, 90, 70)
    subLbl.Font = Enum.Font.GothamBold
    subLbl.TextSize = 12
    subLbl.TextXAlignment = Enum.TextXAlignment.Left

    minimizeBtn = Instance.new("TextButton", gui)
    minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = C_GREEN_GLOW
    minimizeBtn.Font = Enum.Font.GothamBlack
    minimizeBtn.TextSize = 18
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)
    local minStroke = Instance.new("UIStroke", minimizeBtn)
    minStroke.Color = Color3.fromRGB(30, 50, 30)
    minStroke.Thickness = 1

    closeBtn = Instance.new("TextButton", gui)
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(57, 255, 20)
    closeBtn.TextTransparency = 0.3
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 13
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = Color3.fromRGB(30, 50, 30)
    closeStroke.Thickness = 1

    local function repositionButtons()
        local mx = mainFrame.Position.X.Offset
        local my = mainFrame.Position.Y.Offset
        minimizeBtn.Position = UDim2.new(0, mx + 270 - 64, 0, my + 20)
        closeBtn.Position    = UDim2.new(0, mx + 270 - 32, 0, my + 20)
    end
    repositionButtons()

    local isMinimized = false
    local originalMainSize = mainFrame.Size
    local originalShadowSize = shadowFrame.Size

    local function minimizeGUI()
        if isMinimized then return end
        isMinimized = true
        local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(mainFrame, ti, {Size = UDim2.new(0, 270, 0, 60)}):Play()
        TS:Create(shadowFrame, ti, {Size = UDim2.new(0, 276, 0, 60)}):Play()
        minimizeBtn.Text = "+"
    end

    local function restoreGUI()
        if not isMinimized then return end
        isMinimized = false
        local ti = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(mainFrame, ti, {Size = originalMainSize}):Play()
        TS:Create(shadowFrame, ti, {Size = originalShadowSize}):Play()
        minimizeBtn.Text = "−"
    end

    minimizeBtn.MouseButton1Click:Connect(function()
        if isMinimized then restoreGUI() else minimizeGUI() end
    end)

    do
        local dragging, dragInput, dragStart, startMainPos = false, nil, nil, nil
        header.InputBegan:Connect(function(inp)
            if isMinimized then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = inp.Position; startMainPos = mainFrame.Position
                inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        header.InputChanged:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
        end)
        UIS.InputChanged:Connect(function(inp)
            if inp == dragInput and dragging and not isMinimized then
                local dx = inp.Position.X - dragStart.X
                local dy = inp.Position.Y - dragStart.Y
                local nx = startMainPos.X.Offset + dx
                local ny = startMainPos.Y.Offset + dy
                mainFrame.Position = UDim2.new(0, nx, 0, ny)
                shadowFrame.Position = UDim2.new(0, nx + 3, 0, ny + 3)
                repositionButtons()
            end
        end)
        UIS.InputEnded:Connect(function(inp)
            if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and dragging then
                dragging = false
                saveAllGuiPositions()
            end
        end)
    end

    local scroll = Instance.new("ScrollingFrame", mainFrame)
    scroll.Size = UDim2.new(1,0,1,-58)
    scroll.Position = UDim2.new(0,0,0,58)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 2
    scroll.ScrollBarImageColor3 = C_GREEN_GLOW
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.CanvasSize = UDim2.new(0,0,0,0)

    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0,4)

    local pad = Instance.new("UIPadding", scroll)
    pad.PaddingLeft = UDim.new(0,10)
    pad.PaddingRight = UDim.new(0,10)
    pad.PaddingTop = UDim.new(0,10)
    pad.PaddingBottom = UDim.new(0,10)

    local lo = 0
    local function LO() lo=lo+1;return lo end

    local function makeGap(px)
        local f=Instance.new("Frame",scroll)
        f.Size=UDim2.new(1,0,0,px or 4)
        f.BackgroundTransparency=1;f.BorderSizePixel=0;f.LayoutOrder=LO()
    end

    local statsRow = Instance.new("Frame", scroll)
    statsRow.Size = UDim2.new(1,0,0,30)
    statsRow.BackgroundColor3 = C_PANEL
    statsRow.BorderSizePixel = 0
    statsRow.LayoutOrder = LO()
    Instance.new("UICorner", statsRow).CornerRadius = UDim.new(0,6)
    local statsStroke = Instance.new("UIStroke", statsRow)
    statsStroke.Color = C_BORDER2
    statsStroke.Thickness = 1

    local fpsLbl = Instance.new("TextLabel", statsRow)
    fpsLbl.Size = UDim2.new(0.5,-6,1,0)
    fpsLbl.Position = UDim2.new(0,10,0,0)
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Text = "FPS  --"
    fpsLbl.TextColor3 = C_ACCENT2
    fpsLbl.Font = Enum.Font.GothamBold
    fpsLbl.TextSize = 10
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Left

    local statDiv = Instance.new("Frame", statsRow)
    statDiv.Size = UDim2.new(0,1,0,14)
    statDiv.Position = UDim2.new(0.5,0,0.5,-7)
    statDiv.BackgroundColor3 = C_BORDER2
    statDiv.BorderSizePixel = 0

    local pingLbl = Instance.new("TextLabel", statsRow)
    pingLbl.Size = UDim2.new(0.5,-6,1,0)
    pingLbl.Position = UDim2.new(0.5,0,0,0)
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = "PING  --ms"
    pingLbl.TextColor3 = C_ACCENT2
    pingLbl.Font = Enum.Font.GothamBold
    pingLbl.TextSize = 10
    pingLbl.TextXAlignment = Enum.TextXAlignment.Right

    local function makeBlock(sectionName, rowCount)
        local totalH = 26 + rowCount * 34 + (rowCount-1)*3 + 10
        local block = Instance.new("Frame", scroll)
        block.Size = UDim2.new(1,0,0,totalH)
        block.BackgroundColor3 = C_BLOCK
        block.BorderSizePixel = 0
        block.LayoutOrder = LO()
        block.ClipsDescendants = true
        Instance.new("UICorner", block).CornerRadius = UDim.new(0,8)
        local blockStroke = Instance.new("UIStroke", block)
        blockStroke.Color = C_BORDER
        blockStroke.Thickness = 1

        local slbl = Instance.new("TextLabel", block)
        slbl.Size = UDim2.new(1,-16,0,20)
        slbl.Position = UDim2.new(0,8,0,4)
        slbl.BackgroundTransparency = 1
        slbl.Text = sectionName:upper()
        slbl.TextColor3 = C_GREEN_GLOW
        slbl.Font = Enum.Font.GothamBold
        slbl.TextSize = 9
        slbl.TextXAlignment = Enum.TextXAlignment.Left
        slbl.TextStrokeTransparency = 0.3

        local inner = Instance.new("Frame", block)
        inner.Size = UDim2.new(1,-16,0, rowCount*34+(rowCount-1)*3)
        inner.Position = UDim2.new(0,8,0,26)
        inner.BackgroundTransparency = 1
        inner.BorderSizePixel = 0

        local il = Instance.new("UIListLayout", inner)
        il.SortOrder = Enum.SortOrder.LayoutOrder
        il.Padding = UDim.new(0,3)

        return inner
    end

    local function makeRow(parent, label, defaultOn, onToggle)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,0,0,34)
        row.BackgroundColor3 = C_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = C_BORDER
        rowStroke.Thickness = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0.62,0,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C_ACCENT
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left

        local pillBg = Instance.new("Frame", row)
        pillBg.Size = UDim2.new(0,40,0,20)
        pillBg.Position = UDim2.new(1,-46,0.5,-10)
        pillBg.BackgroundColor3 = defaultOn and C_ON_BG or C_OFF_BG
        pillBg.BorderSizePixel = 0
        Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
        local pStroke = Instance.new("UIStroke", pillBg)
        pStroke.Color = defaultOn and C_GREEN_GLOW or C_BORDER
        pStroke.Thickness = 1

        local dot = Instance.new("Frame", pillBg)
        dot.Size = UDim2.new(0,14,0,14)
        dot.Position = defaultOn and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
        dot.BackgroundColor3 = defaultOn and C_GREEN_GLOW or C_DIM
        dot.BorderSizePixel = 0
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

        local isOn = defaultOn or false
        local function setOn(v)
            isOn = v
            TS:Create(pillBg,TweenInfo.new(0.2),{BackgroundColor3=v and C_ON_BG or C_OFF_BG}):Play()
            TS:Create(pStroke,TweenInfo.new(0.2),{Color=v and C_GREEN_GLOW or C_BORDER}):Play()
            TS:Create(dot,TweenInfo.new(0.2,Enum.EasingStyle.Back),{
                Position=v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
                BackgroundColor3=v and C_GREEN_GLOW or C_DIM
            }):Play()
        end

        local clk = Instance.new("TextButton", pillBg)
        clk.Size = UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text=""
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            isOn=not isOn;setOn(isOn)
            if onToggle then onToggle(isOn) end
        end)

        row.MouseEnter:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
        row.MouseLeave:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)

        return setOn
    end

    local function makeRowKey(parent, label, keyEntry, defaultOn, onToggle, onKeyChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,0,0,34)
        row.BackgroundColor3 = C_ROW
        row.BorderSizePixel = 0
        row.LayoutOrder = LO()
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = C_BORDER
        rowStroke.Thickness = 1

        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(0,90,1,0)
        lbl.Position = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency=1
        lbl.Text=label
        lbl.TextColor3=C_ACCENT
        lbl.Font=Enum.Font.GothamBold
        lbl.TextSize=11
        lbl.TextXAlignment=Enum.TextXAlignment.Left

        local keyBtn = Instance.new("TextButton", row)
        keyBtn.Size = UDim2.new(0,52,0,22)
        keyBtn.Position = UDim2.new(1,-104,0.5,-11)
        keyBtn.BackgroundColor3=C_KEY_BG
        keyBtn.BorderSizePixel=0
        keyBtn.Text=keyEntry and keyEntry.kb and keyEntry.kb.Name or "None"
        keyBtn.TextColor3=C_ACCENT2
        keyBtn.Font=Enum.Font.GothamBold
        keyBtn.TextSize=10
        Instance.new("UICorner",keyBtn).CornerRadius=UDim.new(0,4)
        local ks=Instance.new("UIStroke",keyBtn)
        ks.Color=C_BORDER2;ks.Thickness=1

        local listening=false;local listenConn
        local function stopListen(key)
            listening=false
            if listenConn then listenConn:Disconnect();listenConn=nil end
            TS:Create(ks,TweenInfo.new(0.12),{Color=C_BORDER2}):Play()
            keyBtn.TextColor3=C_ACCENT2
            if key and onKeyChange then keyBtn.Text=key.Name;onKeyChange(key) end
        end
        keyBtn.MouseButton1Click:Connect(function()
            if listening then stopListen(nil);return end
            listening=true;keyBtn.Text="...";keyBtn.TextColor3=C_GREEN_GLOW
            TS:Create(ks,TweenInfo.new(0.12),{Color=C_GREEN_GLOW}):Play()
            listenConn=UIS.InputBegan:Connect(function(inp)
                if not listening then return end
                if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
                if inp.KeyCode==Enum.KeyCode.Escape then stopListen(nil);return end
                stopListen(inp.KeyCode)
            end)
        end)

        local pillBg = Instance.new("Frame", row)
        pillBg.Size = UDim2.new(0,40,0,20)
        pillBg.Position = UDim2.new(1,-46,0.5,-10)
        pillBg.BackgroundColor3 = defaultOn and C_ON_BG or C_OFF_BG
        pillBg.BorderSizePixel=0
        Instance.new("UICorner",pillBg).CornerRadius=UDim.new(1,0)
        local pStroke=Instance.new("UIStroke",pillBg)
        pStroke.Color=defaultOn and C_GREEN_GLOW or C_BORDER;pStroke.Thickness=1

        local dot=Instance.new("Frame",pillBg)
        dot.Size=UDim2.new(0,14,0,14)
        dot.Position=defaultOn and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
        dot.BackgroundColor3=defaultOn and C_GREEN_GLOW or C_DIM
        dot.BorderSizePixel=0
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

        local isOn=defaultOn or false
        local function setOn(v)
            isOn=v
            TS:Create(pillBg,TweenInfo.new(0.2),{BackgroundColor3=v and C_ON_BG or C_OFF_BG}):Play()
            TS:Create(pStroke,TweenInfo.new(0.2),{Color=v and C_GREEN_GLOW or C_BORDER}):Play()
            TS:Create(dot,TweenInfo.new(0.2,Enum.EasingStyle.Back),{
                Position=v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
                BackgroundColor3=v and C_GREEN_GLOW or C_DIM
            }):Play()
        end

        local clk=Instance.new("TextButton",pillBg)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text=""
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            isOn=not isOn;setOn(isOn)
            if onToggle then onToggle(isOn) end
        end)

        row.MouseEnter:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
        row.MouseLeave:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)

        return setOn
    end

    local function makeInputRow(parent, label, defaultValue, onChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,0,0,34)
        row.BackgroundColor3=C_ROW
        row.BorderSizePixel=0
        row.LayoutOrder=LO()
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = C_BORDER
        rowStroke.Thickness = 1

        local lbl=Instance.new("TextLabel",row)
        lbl.Size=UDim2.new(0.55,0,1,0)
        lbl.Position=UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency=1
        lbl.Text=label
        lbl.TextColor3=C_ACCENT
        lbl.Font=Enum.Font.GothamBold
        lbl.TextSize=11
        lbl.TextXAlignment=Enum.TextXAlignment.Left

        local box=Instance.new("TextBox",row)
        box.Size=UDim2.new(0,78,0,24)
        box.Position=UDim2.new(1,-84,0.5,-12)
        box.BackgroundColor3=C_KEY_BG
        box.BorderSizePixel=0
        box.Text=tostring(defaultValue)
        box.TextColor3=C_ACCENT2
        box.Font=Enum.Font.GothamBold
        box.TextSize=11
        box.ClearTextOnFocus=false
        Instance.new("UICorner",box).CornerRadius=UDim.new(0,5)
        local bs=Instance.new("UIStroke",box)
        bs.Color=C_BORDER2;bs.Thickness=1

        box.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.15),{Color=C_GREEN_GLOW}):Play() end)
        box.FocusLost:Connect(function()
            TS:Create(bs,TweenInfo.new(0.15),{Color=C_BORDER2}):Play()
            if onChange then
                local n=tonumber(box.Text)
                if n then onChange(n) else box.Text=tostring(defaultValue) end
            end
        end)

        row.MouseEnter:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
        row.MouseLeave:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)

        return box
    end

    local function makeKeyOnlyRow(parent, label, keyEntry, onKeyChange)
        local row = Instance.new("Frame", parent)
        row.Size = UDim2.new(1,0,0,34)
        row.BackgroundColor3=C_ROW
        row.BorderSizePixel=0
        row.LayoutOrder=LO()
        Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = C_BORDER
        rowStroke.Thickness = 1

        local lbl=Instance.new("TextLabel",row)
        lbl.Size=UDim2.new(0.6,0,1,0)
        lbl.Position=UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency=1
        lbl.Text=label
        lbl.TextColor3=C_ACCENT
        lbl.Font=Enum.Font.GothamBold
        lbl.TextSize=11
        lbl.TextXAlignment=Enum.TextXAlignment.Left

        local keyBtn=Instance.new("TextButton",row)
        keyBtn.Size=UDim2.new(0,70,0,24)
        keyBtn.Position=UDim2.new(1,-76,0.5,-12)
        keyBtn.BackgroundColor3=C_KEY_BG
        keyBtn.BorderSizePixel=0
        keyBtn.Text=keyEntry and keyEntry.kb and keyEntry.kb.Name or "None"
        keyBtn.TextColor3=C_ACCENT2
        keyBtn.Font=Enum.Font.GothamBold
        keyBtn.TextSize=11
        Instance.new("UICorner",keyBtn).CornerRadius=UDim.new(0,5)
        local ks=Instance.new("UIStroke",keyBtn)
        ks.Color=C_BORDER2;ks.Thickness=1

        local listening=false;local listenConn
        local function stopListen(key)
            listening=false
            if listenConn then listenConn:Disconnect();listenConn=nil end
            TS:Create(ks,TweenInfo.new(0.12),{Color=C_BORDER2}):Play()
            keyBtn.TextColor3=C_ACCENT2
            if key and onKeyChange then keyBtn.Text=key.Name;onKeyChange(key) end
        end
        keyBtn.MouseButton1Click:Connect(function()
            if listening then stopListen(nil);return end
            listening=true;keyBtn.Text="...";keyBtn.TextColor3=C_GREEN_GLOW
            TS:Create(ks,TweenInfo.new(0.12),{Color=C_GREEN_GLOW}):Play()
            listenConn=UIS.InputBegan:Connect(function(inp)
                if not listening then return end
                if inp.UserInputType~=Enum.UserInputType.Keyboard then return end
                if inp.KeyCode==Enum.KeyCode.Escape then stopListen(nil);return end
                stopListen(inp.KeyCode)
            end)
        end)

        row.MouseEnter:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
        row.MouseLeave:Connect(function() TS:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)
    end

    -- BLOCCHI UI (inizio)
    local bSpeed = makeBlock("Speed", 5)
    normalBox = makeInputRow(bSpeed, "Normal Speed", NS, function(v) if v and v>0 and v<=500 then NS=v;saveConfig() end end)
    carryBox = makeInputRow(bSpeed, "Carry Speed", CS, function(v) if v and v>0 and v<=500 then CS=v;saveConfig() end end)
    laggerBox = makeInputRow(bSpeed, "Lagger Normal", LAGGER_SPEED, function(v) if v and v>0 and v<=500 then LAGGER_SPEED=v;saveConfig() end end)
    laggerCarryBox = makeInputRow(bSpeed, "Lagger Carry", LAGGER_CARRY_SPEED, function(v) if v and v>0 and v<=500 then LAGGER_CARRY_SPEED=v;saveConfig() end end)

    local modeRow = Instance.new("Frame", bSpeed)
    modeRow.Size = UDim2.new(1,0,0,34)
    modeRow.BackgroundColor3=C_ROW;modeRow.BorderSizePixel=0;modeRow.LayoutOrder=LO()
    Instance.new("UICorner",modeRow).CornerRadius=UDim.new(0,6)
    local modeStroke = Instance.new("UIStroke", modeRow)
    modeStroke.Color = C_BORDER
    modeStroke.Thickness = 1

    local modeLbl=Instance.new("TextLabel",modeRow)
    modeLbl.Size=UDim2.new(0.5,0,1,0);modeLbl.Position=UDim2.new(0,10,0,0)
    modeLbl.BackgroundTransparency=1;modeLbl.Text="Mode";modeLbl.TextColor3=C_ACCENT
    modeLbl.Font=Enum.Font.GothamBold;modeLbl.TextSize=11;modeLbl.TextXAlignment=Enum.TextXAlignment.Left
    modeValLbl=Instance.new("TextLabel",modeRow)
    modeValLbl.Size=UDim2.new(0,90,1,0);modeValLbl.Position=UDim2.new(1,-96,0,0)
    modeValLbl.BackgroundTransparency=1;modeValLbl.Text="Normal";modeValLbl.TextColor3=C_GREEN_GLOW
    modeValLbl.Font=Enum.Font.GothamBlack;modeValLbl.TextSize=11;modeValLbl.TextXAlignment=Enum.TextXAlignment.Right
    local modeClk=Instance.new("TextButton",modeRow)
    modeClk.Size=UDim2.new(1,0,1,0);modeClk.BackgroundTransparency=1;modeClk.Text=""
    modeClk.Activated:Connect(function() if _anyKeyListening then return end;toggleCarryMode();saveConfig() end)
    modeRow.MouseEnter:Connect(function() TS:Create(modeRow,TweenInfo.new(0.1),{BackgroundColor3=C_ROW_HOV}):Play() end)
    modeRow.MouseLeave:Connect(function() TS:Create(modeRow,TweenInfo.new(0.1),{BackgroundColor3=C_ROW}):Play() end)

    makeGap(4)

    local bCombat = makeBlock("Combat", 5)
    local setAutoBat = makeRowKey(bCombat, "Auto Bat", KB.AutoBat, autoBatEnabled, function(on)
        if on then queueAutoBatStart() else disableAutoBat() end
        saveConfig()
    end, function(k) KB.AutoBat.kb=k;KB.AutoBat.gp=nil;saveConfig() end)
    autoBatSetVisual = setAutoBat

    local setAutoSwing = makeRow(bCombat, "Auto Swing", autoSwingEnabled, function(on)
        autoSwingEnabled=on;saveConfig()
    end)
    setAutoSwingVisual = setAutoSwing

    local setBatCounter = makeRow(bCombat, "Bat Counter", batCounterEnabled, function(on)
        batCounterEnabled=on
        if on then startBatCounter() else stopBatCounter() end
        saveConfig()
    end)
    setBatCounterVisual = setBatCounter

    local setMedusa = makeRow(bCombat, "Medusa Counter", medusaCounterEnabled, function(on)
        medusaCounterEnabled=on
        if on then setupMedusa(LP.Character) else stopMedusaCounter() end
        saveConfig()
    end)

    local setAntiBat = makeRow(bCombat, "Anti Bat", antiBatEnabled, function(on)
        if on then
            if autoBatEnabled then
                autoBatEnabled = false
                disableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(false) end
                if _mobileAutoBatSetOn then _mobileAutoBatSetOn(false) end
            end
            antiBatEnabled = true
            enableAntiBat()
        else
            antiBatEnabled = false
            disableAntiBat()
        end
        saveConfig()
    end)
    setAntiBatVisual = setAntiBat

    makeGap(4)

    local bSteal = makeBlock("Steal", 5)
    radInput = makeInputRow(bSteal, "Steal Radius", Steal.StealRadius, function(v)
        if v and v>=1 and v<=500 then
            Steal.StealRadius=v
            if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal.StealRadius) end
            saveConfig()
        end
    end)

    delayRadiusBox = makeInputRow(bSteal, "Delay Radius", autoGrabSetDelayRadius, function(v)
        if v and v>=1 and v<=40 then 
            autoGrabSetDelayRadius = v
            saveConfig()
        end
    end)

    stopTimeBox = makeInputRow(bSteal, "Stop Time (s)", autoGrabStopTime, function(v)
        if v and v>=0.05 and v<=1.29 then 
            autoGrabStopTime = v
            saveConfig()
        end
    end)

    setStopTime = makeRow(bSteal, "Stop Time", autoGrabStopEnabled, function(on)
        autoGrabStopEnabled = on
        saveConfig()
    end)

    local setAutoSteal = makeRow(bSteal, "Auto Steal", Steal.AutoStealEnabled, function(on)
        Steal.AutoStealEnabled = on
        if on then 
            if not pcall(startAutoSteal) then 
                Steal.AutoStealEnabled = false
                setAutoSteal(false)
            end
        else 
            stopAutoSteal() 
        end
        saveConfig()
    end)
    setInstaGrab = setAutoSteal

    makeGap(4)

    local bMisc = makeBlock("Misc", 5)
    local setAntiRag = makeRow(bMisc, "Anti Ragdoll", antiRagdollEnabled, function(on)
        antiRagdollEnabled=on
        if on then startAntiRagdoll() else stopAntiRagdoll() end
        saveConfig()
    end)
    setAntiRagVisual = setAntiRag

    local setInfJump = makeRow(bMisc, "Infinite Jump", infJumpEnabled, function(on)
        infJumpEnabled=on;saveConfig()
    end)
    setInfJumpVisual = setInfJump

    local setUnwalk = makeRow(bMisc, "Unwalk", unwalkEnabled, function(on)
        if on then startUnwalk() else stopUnwalk() end
        saveConfig()
    end)
    setUnwalkVisual = setUnwalk

    local setEsp = makeRow(bMisc, "ESP", espEnabled, function(on)
        espEnabled=on
        if on then startEsp() else stopEsp() end
        saveConfig()
    end)
    setEspVisual = setEsp

    local setMedusaV = makeRow(bMisc, "Medusa Counter", medusaCounterEnabled, function(on)
        medusaCounterEnabled=on
        if on then setupMedusa(LP.Character) else stopMedusaCounter() end
        saveConfig()
    end)

    makeGap(4)

    local bVisual = makeBlock("Visual", 2)
    local setAntiLag = makeRow(bVisual, "Anti Lag", antiLagEnabled, function(on)
        if on then enableAntiLag() else disableAntiLag() end
        saveConfig()
    end)
    setAntiLagVisual = setAntiLag

    local setStretch = makeRow(bVisual, "Stretch Rez", stretchRezEnabled, function(on)
        if on then enableStretchRez() else disableStretchRez() end
        saveConfig()
    end)
    setStretchRezVisual = setStretch

    makeGap(4)

    local bMove = makeBlock("Movement", 2)
    local setAutoLeft = makeRowKey(bMove, "Auto Left", KB.AutoLeft, autoLeftEnabled, function(on)
        autoLeftEnabled=on
        if on then queueAutoLeftStart() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(on) end
        saveConfig()
    end, function(k) KB.AutoLeft.kb=k;KB.AutoLeft.gp=nil;saveConfig() end)
    autoLeftSetVisual = setAutoLeft

    local setAutoRight = makeRowKey(bMove, "Auto Right", KB.AutoRight, autoRightEnabled, function(on)
        autoRightEnabled=on
        if on then queueAutoRightStart() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(on) end
        saveConfig()
    end, function(k) KB.AutoRight.kb=k;KB.AutoRight.gp=nil;saveConfig() end)
    autoRightSetVisual = setAutoRight

    makeGap(4)

    local bTP = makeBlock("Auto TP", 2)
    local setAutoTP = makeRow(bTP, "Auto TP", autoTPEnabled, function(on)
        autoTPEnabled=on
        if on then startAutoTP() else stopAutoTP() end
        saveConfig()
    end)
    setAutoTPVisual = setAutoTP

    autoTPHeightBox = makeInputRow(bTP, "TP Height", autoTPHeight, function(v)
        if v and v>=0 and v<=500 then autoTPHeight=v;saveConfig() end
    end)

    makeGap(4)

    local bUtil = makeBlock("Utility", 5)
    makeKeyOnlyRow(bUtil, "Drop Brainrot", KB.DropBrainrot, function(k) KB.DropBrainrot.kb=k;KB.DropBrainrot.gp=nil;saveConfig() end)
    makeKeyOnlyRow(bUtil, "TP Down", KB.TPFloor, function(k) KB.TPFloor.kb=k;KB.TPFloor.gp=nil;saveConfig() end)
    makeKeyOnlyRow(bUtil, "Instant Reset", KB.InstaReset, function(k) KB.InstaReset.kb=k;KB.InstaReset.gp=nil;saveConfig() end)
    makeKeyOnlyRow(bUtil, "Speed Toggle", KB.SpeedToggle, function(k) KB.SpeedToggle.kb=k;KB.SpeedToggle.gp=nil;saveConfig() end)
    makeKeyOnlyRow(bUtil, "Cycle Lagger", KB.LaggerCycle, function(k) KB.LaggerCycle.kb=k;KB.LaggerCycle.gp=nil;saveConfig() end)

    makeGap(8)

    -- NUOVA TAB: INTRO
    local bIntro = makeBlock("Intro", 1)
    local setSkipIntro = makeRow(bIntro, "Skip Intro", introSkipEnabled, function(on)
        introSkipEnabled = on
        saveConfig()
    end)

    makeGap(8)

    pbFrame = Instance.new("Frame", gui)
    pbFrame.Size = UDim2.new(0,280,0,50)
    pbFrame.Position = UDim2.new(0.5,-140,1,-66)
    pbFrame.BackgroundColor3 = C_PANEL
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0,9)
    local pbStroke = Instance.new("UIStroke", pbFrame)
    pbStroke.Color = C_BORDER2
    pbStroke.Thickness = 1

    progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Size = UDim2.new(0,44,0,16);progressPct.Position = UDim2.new(0,9,0,7)
    progressPct.BackgroundTransparency=1;progressPct.Text="0%";progressPct.TextColor3=C_GREEN_GLOW
    progressPct.Font=Enum.Font.GothamBold;progressPct.TextSize=11;progressPct.TextXAlignment=Enum.TextXAlignment.Left

    progressRadLbl = Instance.new("TextLabel", pbFrame)
    progressRadLbl.Size = UDim2.new(0,104,0,16);progressRadLbl.Position = UDim2.new(1,-112,0,7)
    progressRadLbl.BackgroundTransparency=1
    progressRadLbl.Text=string.format("Radius: %.2g",Steal.StealRadius)
    progressRadLbl.TextColor3=C_DIM;progressRadLbl.Font=Enum.Font.GothamBold
    progressRadLbl.TextSize=11;progressRadLbl.TextXAlignment=Enum.TextXAlignment.Right

    local pbg = Instance.new("Frame", pbFrame)
    pbg.Size = UDim2.new(1,-18,0,11);pbg.Position = UDim2.new(0,9,0,30)
    pbg.BackgroundColor3=Color3.fromRGB(15,15,17);pbg.BorderSizePixel=0
    Instance.new("UICorner",pbg).CornerRadius=UDim.new(1,0)

    progressFill = Instance.new("Frame", pbg)
    progressFill.Size = UDim2.new(0,0,1,0);progressFill.BackgroundColor3=C_GREEN_GLOW
    progressFill.BorderSizePixel=0
    Instance.new("UICorner",progressFill).CornerRadius=UDim.new(1,0)

    do
        local dn,ds,sp,di=false,nil,nil,nil
        pbFrame.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dn=true;ds=i.Position;sp=pbFrame.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
            end
        end)
        pbFrame.InputChanged:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
        end)
        UIS.InputChanged:Connect(function(i)
            if i==di and dn then
                pbFrame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+(i.Position.X-ds.X),sp.Y.Scale,sp.Y.Offset+(i.Position.Y-ds.Y))
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i == di and dn then
                dn = false
                saveAllGuiPositions()
            end
        end)
    end

    miniButton = Instance.new("TextButton", gui)
    miniButton.Name = "MiniButton"
    miniButton.Size = UDim2.new(0,120,0,28)
    miniButton.Position = UDim2.new(0,savedX,0,savedY)
    miniButton.BackgroundColor3=C_ON_BG
    miniButton.BorderSizePixel=0
    miniButton.Text="URANIUM  HUB"
    miniButton.TextColor3=C_GREEN_GLOW
    miniButton.Font=Enum.Font.GothamBold
    miniButton.TextSize=11
    miniButton.ZIndex=20
    miniButton.Visible=false
    Instance.new("UICorner",miniButton).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",miniButton).Color=C_GREEN_GLOW

    local miniDragging, miniDragStart, miniStartPos = false
    miniButton.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            miniDragging = true
            miniDragStart = inp.Position
            miniStartPos = miniButton.Position
            inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then miniDragging = false end end)
        end
    end)
    miniButton.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            if miniDragging then
                local delta = inp.Position - miniDragStart
                miniButton.Position = UDim2.new(0, miniStartPos.X.Offset + delta.X, 0, miniStartPos.Y.Offset + delta.Y)
            end
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if miniDragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            miniDragging = false
            saveAllGuiPositions()
        end
    end)

    local function showGui() mainFrame.Visible=true;shadowFrame.Visible=true;pbFrame.Visible=true;miniButton.Visible=false end
    local function hideGui() mainFrame.Visible=false;shadowFrame.Visible=false;pbFrame.Visible=false;miniButton.Visible=true end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniButton.MouseButton1Click:Connect(showGui)

    loadAllGuiPositions()

    local frameCount,lastTime=0,tick()
    RunService.RenderStepped:Connect(function()
        frameCount=frameCount+1
        local now=tick()
        if now-lastTime>=1 then
            local fps=frameCount
            local fc=fps>=50 and C_GREEN_GLOW or fps>=30 and Color3.fromRGB(220,180,60) or Color3.fromRGB(200,60,60)
            fpsLbl.Text="FPS  "..fps
            fpsLbl.TextColor3=fc
            frameCount=0
            lastTime=now
        end
    end)

    task.spawn(function()
        while true do
            task.wait(2)
            local ping=LP:GetNetworkPing()
            if ping then
                local ms=math.floor(ping*1000)
                local pc=ms<=80 and C_GREEN_GLOW or ms<=150 and Color3.fromRGB(220,180,60) or Color3.fromRGB(200,60,60)
                pingLbl.Text="PING  "..ms.."ms"
                pingLbl.TextColor3=pc
            end
        end
    end)
end

-- ============================================================
-- CONFIG LOAD
-- ============================================================
local _savedCfg = nil

local function loadConfigKeys()
    if not(isfile and isfile("vortex_config.json")) then
        if isfile and isfile("cursedPC.json") then
            local ok,cfg=pcall(function() return HS:JSONDecode(readfile("cursedPC.json")) end)
            if ok and cfg then
                if cfg.normalSpeed then NS=cfg.normalSpeed end
                if cfg.carrySpeed then CS=cfg.carrySpeed end
                if cfg.grabRadius then Steal.StealRadius=cfg.grabRadius end
                if cfg.laggerSpeed then LAGGER_SPEED=cfg.laggerSpeed end
                if cfg.laggerCarrySpeed then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
                if cfg.autoTPHeight then autoTPHeight=cfg.autoTPHeight end
                if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing end
                if cfg.antiRagdoll then antiRagdollEnabled=cfg.antiRagdoll end
                if cfg.autoStealEnabled then Steal.AutoStealEnabled=cfg.autoStealEnabled end
                if cfg.infiniteJump then infJumpEnabled=cfg.infiniteJump end
                if cfg.medusaCounter then medusaCounterEnabled=cfg.medusaCounter end
                if cfg.batCounter then batCounterEnabled=cfg.batCounter end
                if cfg.carryMode then speedMode=cfg.carryMode end
                if cfg.laggerMode then laggerToggled=cfg.laggerMode;laggerPhase=cfg.laggerCarryMode and 2 or 1 end
                if cfg.autoTPEnabled then autoTPEnabled=cfg.autoTPEnabled end
                if cfg.autoBat then autoBatEnabled=cfg.autoBat end
                if cfg.unwalkEnabled then unwalkEnabled=cfg.unwalkEnabled end
                if cfg.antiLag then antiLagEnabled=cfg.antiLag end
                if cfg.stretchRez then stretchRezEnabled=cfg.stretchRez end
                if cfg.espEnabled then espEnabled=cfg.espEnabled end
                if cfg.antiBatEnabled then antiBatEnabled=cfg.antiBatEnabled end
                return
            end
        end
        return
    end
    local ok,cfg=pcall(function() return HS:JSONDecode(readfile("vortex_config.json")) end)
    if not ok or not cfg then return end
    _savedCfg=cfg
    local function lk(e,d)
        if not e then return end
        if type(d) ~= "table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot,cfg.dropBrainrotKey)
    lk(KB.AutoLeft,cfg.autoLeftKey)
    lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.AutoBat,cfg.autoBatKey)
    lk(KB.LaggerToggle,cfg.laggerToggleKey)
    lk(KB.TPFloor,cfg.tpFloorKey)
    lk(KB.InstaReset,cfg.instaResetKey)
    lk(KB.GuiHide,cfg.guiHideKey)
    lk(KB.SpeedToggle,cfg.speedToggleKey)
    lk(KB.LaggerCycle,cfg.laggerCycleKey)
    if cfg.normalSpeed then NS=cfg.normalSpeed end
    if cfg.carrySpeed then CS=cfg.carrySpeed end
    if cfg.grabRadius and type(cfg.grabRadius)=="number" then Steal.StealRadius=cfg.grabRadius else Steal.StealRadius=60 end
    if cfg.stealDuration and type(cfg.stealDuration)=="number" then Steal.StealDuration=cfg.stealDuration else Steal.StealDuration=1.4 end
    if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end
    if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
    if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then autoTPHeight=cfg.autoTPHeight end
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
    if cfg.espEnabled then espEnabled=cfg.espEnabled==true end
    if cfg.antiBatEnabled then antiBatEnabled=cfg.antiBatEnabled==true end
    -- NUOVO: carica skipIntro
    if cfg.skipIntro ~= nil then introSkipEnabled = cfg.skipIntro end
end

local function loadConfigState()
    local cfg=_savedCfg;if not cfg then return end
    if normalBox then normalBox.Text=tostring(NS) end
    if carryBox then carryBox.Text=tostring(CS) end
    if radInput then radInput.Text=tostring(Steal.StealRadius) end
    if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal.StealRadius) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
    if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
    if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
    
    if delayRadiusBox then delayRadiusBox.Text = tostring(cfg.delayRadius or autoGrabSetDelayRadius) end
    if stopTimeBox then stopTimeBox.Text = tostring(cfg.stopTime or autoGrabStopTime) end
    if setStopTime then setStopTime(cfg.stopEnabled == true) end
    
    if cfg.delayRadius then autoGrabSetDelayRadius = cfg.delayRadius end
    if cfg.stopTime then autoGrabStopTime = cfg.stopTime end
    if cfg.stopEnabled ~= nil then autoGrabStopEnabled = cfg.stopEnabled end
    
    task.spawn(function()
        task.wait(0.15)
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
        if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end end
        if cfg.medusaCounter then medusaCounterEnabled=true;setupMedusa(LP.Character) end
        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        if cfg.laggerMode then laggerToggled=true;speedMode=false;laggerPhase=cfg.laggerCarryMode and 2 or 1;refreshSpeedModeLabel()
        elseif cfg.carryMode then speedMode=false;toggleCarryMode() end
        if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
        if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end
        if cfg.unwalkEnabled then startUnwalk();if setUnwalkVisual then setUnwalkVisual(true) end end
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
        if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end
        if cfg.espEnabled then espEnabled=true;if setEspVisual then setEspVisual(true) end;startEsp() end
        if cfg.antiBatEnabled then antiBatEnabled=true;if setAntiBatVisual then setAntiBatVisual(true) end;enableAntiBat() end
    end)
end

loadConfigKeys()
buildGui()
loadConfigState()

-- ============================================================
-- BOTTONI FLUTTUANTI MOBILE
-- ============================================================
local mobileGuiEnabled = true
local mobileInputDetected = false

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.Keyboard or
       (input.UserInputType >= Enum.UserInputType.MouseButton1 and input.UserInputType <= Enum.UserInputType.MouseButton3) then
        if not mobileInputDetected then
            mobileInputDetected = true
            local mbGui = game:GetService("CoreGui"):FindFirstChild("VortexMobile")
            if mbGui then mbGui.Enabled = false end
        end
    end
end)

local function createMobileButtons()
    local MB_W  = 62
    local MB_H  = 52
    local MB_G  = 4
    local MB_PR = 8

    local MB_BG      = Color3.fromRGB(8, 8, 12)
    local MB_ROW_H   = Color3.fromRGB(18, 18, 24)
    local MB_BORDER2 = Color3.fromRGB(50, 60, 50)
    local MB_ACCENT  = Color3.fromRGB(200, 220, 200)
    local MB_GREEN   = Color3.fromRGB(57, 255, 20)
    local MB_ON_BG   = Color3.fromRGB(30, 100, 30)
    local MB_DIM     = Color3.fromRGB(70, 90, 70)

    local mbGui2 = game:GetService("CoreGui"):FindFirstChild("VortexMobile")
    if mbGui2 then mbGui2:Destroy() end
    mbGui2 = Instance.new("ScreenGui")
    mbGui2.Name = "VortexMobile"
    mbGui2.ResetOnSpawn = false
    mbGui2.DisplayOrder = 11
    mbGui2.IgnoreGuiInset = true
    mbGui2.Parent = game:GetService("CoreGui")

    local mbRoot = Instance.new("Frame", mbGui2)
    mbRoot.Size = UDim2.new(1, 0, 1, 0)
    mbRoot.BackgroundTransparency = 1
    mbRoot.BorderSizePixel = 0

    local function placeBtn(row, col)
        local x = col == 0
            and -(MB_PR + MB_W * 2 + MB_G)
            or  -(MB_PR + MB_W)
        local totalH = 5 * MB_H + 4 * MB_G
        local rowIdx = row + 1
        local y = -(totalH / 2) + rowIdx * (MB_H + MB_G)
        return x, y
    end

    local bx0, by0 = placeBtn(0, 0)
    local bx1, by1 = placeBtn(0, 1)
    local bx2, by2 = placeBtn(1, 0)
    local bx3, by3 = placeBtn(1, 1)
    local bx4, by4 = placeBtn(2, 0)
    local bx5, by5 = placeBtn(2, 1)
    local bx6, by6 = placeBtn(3, 0)
    local bx7, by7 = placeBtn(3, 1)

    local totalH = 5 * MB_H + 4 * MB_G
    local dropBrainrotX = -(MB_PR + MB_W * 2 + MB_G)
    local dropBrainrotY = -(totalH / 2)

    local function addBtn(l1, l2, xs, xo, ys, yo, defOn, cb)
        local b = Instance.new("Frame", mbRoot)
        b.Size = UDim2.new(0, MB_W, 0, MB_H)
        b.Position = UDim2.new(xs, xo, ys, yo)
        b.BackgroundColor3 = defOn and MB_ON_BG or MB_BG
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", b)
        st.Color = defOn and MB_GREEN or MB_BORDER2
        st.Thickness = 1
        local t1 = Instance.new("TextLabel", b)
        t1.Size = UDim2.new(1,0,0,14)
        t1.Position = UDim2.new(0,0,0,9)
        t1.BackgroundTransparency = 1
        t1.Text = l1
        t1.TextColor3 = defOn and MB_GREEN or MB_ACCENT
        t1.Font = Enum.Font.GothamBlack
        t1.TextSize = 9
        t1.TextXAlignment = Enum.TextXAlignment.Center
        local t2 = Instance.new("TextLabel", b)
        t2.Size = UDim2.new(1,0,0,14)
        t2.Position = UDim2.new(0,0,0,22)
        t2.BackgroundTransparency = 1
        t2.Text = l2
        t2.TextColor3 = defOn and MB_GREEN or MB_ACCENT
        t2.Font = Enum.Font.GothamBlack
        t2.TextSize = 9
        t2.TextXAlignment = Enum.TextXAlignment.Center
        local dt = Instance.new("Frame", b)
        dt.Size = UDim2.new(0,5,0,5)
        dt.Position = UDim2.new(0.5,-2,0,39)
        dt.BackgroundColor3 = defOn and MB_GREEN or MB_DIM
        dt.BorderSizePixel = 0
        Instance.new("UICorner", dt).CornerRadius = UDim.new(1, 0)
        local isOn = defOn or false
        local function setOn(v)
            isOn = v
            TS:Create(b,  TweenInfo.new(0.14), {BackgroundColor3 = v and MB_ON_BG or MB_BG}):Play()
            TS:Create(st, TweenInfo.new(0.14), {Color = v and MB_GREEN or MB_BORDER2}):Play()
            TS:Create(t1, TweenInfo.new(0.14), {TextColor3 = v and MB_GREEN or MB_ACCENT}):Play()
            TS:Create(t2, TweenInfo.new(0.14), {TextColor3 = v and MB_GREEN or MB_ACCENT}):Play()
            TS:Create(dt, TweenInfo.new(0.14), {BackgroundColor3 = v and MB_GREEN or MB_DIM}):Play()
        end
        local clk = Instance.new("TextButton", b)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = b.ZIndex + 1
        clk.Activated:Connect(function()
            isOn = not isOn
            setOn(isOn)
            if cb then cb(isOn) end
        end)
        b.MouseEnter:Connect(function()
            if not isOn then TS:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = MB_ROW_H}):Play() end
        end)
        b.MouseLeave:Connect(function()
            if not isOn then TS:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = MB_BG}):Play() end
        end)
        return setOn
    end

    local function addFlashBtn(labelText, xs, xo, ys, yo, width, cb)
        local b = Instance.new("Frame", mbRoot)
        b.Size = UDim2.new(0, width, 0, MB_H)
        b.Position = UDim2.new(xs, xo, ys, yo)
        b.BackgroundColor3 = MB_BG
        b.BorderSizePixel = 0
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", b)
        st.Color = MB_BORDER2
        st.Thickness = 1
        local t1 = Instance.new("TextLabel", b)
        t1.Size = UDim2.new(1,0,1,0)
        t1.Position = UDim2.new(0,0,0,0)
        t1.BackgroundTransparency = 1
        t1.Text = labelText
        t1.TextColor3 = MB_ACCENT
        t1.Font = Enum.Font.GothamBlack
        t1.TextSize = 9
        t1.TextXAlignment = Enum.TextXAlignment.Center
        t1.TextYAlignment = Enum.TextYAlignment.Center
        local function flashOn()
            TS:Create(b,  TweenInfo.new(0.08), {BackgroundColor3 = MB_ON_BG}):Play()
            TS:Create(st, TweenInfo.new(0.08), {Color = MB_GREEN}):Play()
            TS:Create(t1, TweenInfo.new(0.08), {TextColor3 = MB_GREEN}):Play()
            task.delay(0.1, function()
                TS:Create(b,  TweenInfo.new(0.1), {BackgroundColor3 = MB_BG}):Play()
                TS:Create(st, TweenInfo.new(0.1), {Color = MB_BORDER2}):Play()
                TS:Create(t1, TweenInfo.new(0.1), {TextColor3 = MB_ACCENT}):Play()
            end)
        end
        local clk = Instance.new("TextButton", b)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = b.ZIndex + 1
        clk.Activated:Connect(function()
            flashOn()
            if cb then cb() end
        end)
        b.MouseEnter:Connect(function()
            TS:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = MB_ROW_H}):Play()
        end)
        b.MouseLeave:Connect(function()
            TS:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = MB_BG}):Play()
        end)
        return flashOn
    end

    -- DROP BRAINROT
    local dropFlash = addFlashBtn("DROP BRAINROT", 1, dropBrainrotX, 0.5, dropBrainrotY, MB_W * 2 + MB_G, function() pcall(function() runDrop() end) end)
    _mobileDropBrainrotSetOn = dropFlash

    -- Auto Left / Auto Right
    local autoLeftMobileSetOn = addBtn("AUTO", "LEFT", 1,bx0, 0.5,by0, autoLeftEnabled, function(on)
        if on then queueAutoLeftStart() else autoLeftEnabled=false;stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        saveConfig()
    end)
    _mobileAutoLeftSetOn = autoLeftMobileSetOn

    local autoRightMobileSetOn = addBtn("AUTO", "RIGHT", 1,bx1, 0.5,by1, autoRightEnabled, function(on)
        if on then queueAutoRightStart() else autoRightEnabled=false;stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        saveConfig()
    end)
    _mobileAutoRightSetOn = autoRightMobileSetOn

    -- Normal Speed / Carry Speed
    local normalBtn, carryBtn
    local function updateSpeedButtons()
        if normalBtn then normalBtn(not laggerToggled and not speedMode) end
        if carryBtn then carryBtn(not laggerToggled and speedMode) end
    end
    normalBtn = addBtn("NORMAL", "SPEED", 1,bx2, 0.5,by2, not laggerToggled and not speedMode, function(on)
        if on then speedMode=false;laggerToggled=false;updateSpeedButtons();refreshSpeedModeLabel();saveConfig()
        else if not laggerToggled and not speedMode then normalBtn(true) else normalBtn(false) end end
    end)
    carryBtn = addBtn("CARRY", "SPEED", 1,bx3, 0.5,by3, not laggerToggled and speedMode, function(on)
        if on then speedMode=true;laggerToggled=false;updateSpeedButtons();refreshSpeedModeLabel();saveConfig()
        else if not laggerToggled and speedMode then carryBtn(true) else carryBtn(false) end end
    end)

    -- Lagger Normal / Lagger Carry
    local laggerNormalBtn, laggerCarryBtn
    local function updateLaggerButtons()
        if laggerNormalBtn then laggerNormalBtn(laggerToggled and laggerPhase == 1) end
        if laggerCarryBtn then laggerCarryBtn(laggerToggled and laggerPhase == 2) end
    end
    laggerNormalBtn = addBtn("LAGGER", "NORMAL", 1,bx4, 0.5,by4, laggerToggled and laggerPhase == 1, function(on)
        if on then laggerToggled=true;laggerPhase=1;speedMode=false;updateSpeedButtons();updateLaggerButtons();refreshSpeedModeLabel();saveConfig()
        else if laggerToggled and laggerPhase==1 then laggerNormalBtn(true) else laggerNormalBtn(false) end end
    end)
    laggerCarryBtn = addBtn("LAGGER", "CARRY", 1,bx5, 0.5,by5, laggerToggled and laggerPhase == 2, function(on)
        if on then laggerToggled=true;laggerPhase=2;speedMode=false;updateSpeedButtons();updateLaggerButtons();refreshSpeedModeLabel();saveConfig()
        else if laggerToggled and laggerPhase==2 then laggerCarryBtn(true) else laggerCarryBtn(false) end end
    end)

    -- Bat Aimbot
    local autoBatMobileSetOn = addBtn("BAT", "AIMBOT", 1,bx6, 0.5,by6, autoBatEnabled, function(on)
        if on then queueAutoBatStart() else disableAutoBat() end
        saveConfig()
    end)
    _mobileAutoBatSetOn = autoBatMobileSetOn

    -- TP Down
    local tpBtn, tpBtnSetOn
    tpBtn = addBtn("TP", "DOWN", 1,bx7, 0.5,by7, false, function(on)
        pcall(function() doAutoTPDown(true) end)
        task.delay(0.1, function() if tpBtnSetOn then tpBtnSetOn(false) end end)
    end)
    tpBtnSetOn = tpBtn

    refreshSpeedModeLabel = function()
        if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (speedMode and "Carry" or "Normal") end
        updateSpeedButtons()
        updateLaggerButtons()
    end
    cycleLaggerMode = function()
        if not laggerToggled then speedMode=false;laggerToggled=true;laggerPhase=2
        elseif laggerPhase==2 then laggerPhase=1
        else laggerPhase=2 end
        refreshSpeedModeLabel()
        updateSpeedButtons()
        updateLaggerButtons()
    end
end

task.spawn(function()
    task.wait(0.5)
    if not mobileInputDetected then
        createMobileButtons()
    end
end)
print("Uranium Duels On Top")
print("discord.gg/uraniumm")