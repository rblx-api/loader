--[[
    HEARTLESS.VS - Script completo v3.3.1
    CAMBIOS v3.3.1:
    - ✅ Imagen de Rapture del botón mini a 120x120
    - ✅ Auto Left y Auto Right movidos debajo de Drop Brainrot
    - ✅ Body Lock con rango ajustable integrado
    - ✅ 12 estilos de animación seleccionables más Off
    - ✅ Auto Carry Speed en la pestaña Speed
    - ✅ Reproductor HEARTLESS con 21 pistas
    - ✅ Ocho botones flotantes de Updateyoutv12, sin botones Music/Next
    - ✅ Imágenes de Rampage (grises) para el menú (380x95) y botón (120x120)
    - ✅ Fondos y texturas del menú en tema Halloween (nombre HEARTLESS intacto)
    - ✅ Barra de Steal con degradado Naranja
    - ✅ Un solo botón Lock/Unlock para fijar o mover los botones
]]

skipIntroEnabled = true

if _G.RaptureDuelRunning then return end
_G.RaptureDuelRunning = true

repeat task.wait() until game:IsLoaded()

-- SECCIÓN 3: INTRO ANIMADA — HALLOWEEN HEARTLESS.vs
-- Calabazas flotantes + luna + murciélagos + título naranja
do
	local envI = (getgenv and getgenv()) or _G
	if envI.__CRYON_NO_INTRO_SAVED == true then
		envI.__CRYON_INTRO_FINISHED_RUN = envI.__CRYON_HIGH_PING_RUN or 0
	else
		task.spawn(function()
		local introOk, introErr = pcall(function()
--============================================================
-- HEARTLESS.vs HALLOWEEN INTRO
--============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local ORANGE = Color3.fromRGB(255, 120, 0)
local ORANGE_L = Color3.fromRGB(255, 170, 50)
local PUMPKIN = Color3.fromRGB(255, 140, 20)
local STEM = Color3.fromRGB(40, 120, 30)
local MOON = Color3.fromRGB(255, 230, 160)
local PURPLE = Color3.fromRGB(90, 30, 130)

-- Canción Halloween (catálogo Roblox: "Halloween Night")
-- Fallbacks: Night Of Ghouls / Spooky Scary Skeletons
local MUSIC_SOUND_ID = "rbxassetid://1838592691"
local MUSIC_FALLBACKS = {
	"rbxassetid://1838592691", -- Halloween Night
	"rbxassetid://1837467198", -- Night Of Ghouls
	"rbxassetid://515669032",  -- Spooky Scary Skeletons
	"rbxassetid://1836009584", -- Bouncing Halloween
}
local MUSIC_START = 0
local MUSIC_END = 7
local MUSIC_VOLUME = 0.9

for _, name in ipairs({"ShadowVSIntro", "ViciousKatanaIntro", "ConejoMaloKatanaIntro", "AceDuelsIntro", "ViciousIntro", "HEARTLESSVsHalloweenIntro"}) do
	local old = PlayerGui:FindFirstChild(name)
	if old then pcall(function() old:Destroy() end) end
	pcall(function()
		local cg = CoreGui:FindFirstChild(name)
		if cg then cg:Destroy() end
	end)
end

local introActive = true
local introFinished = false
local introSound = nil
local fxConn = nil

local function finishIntro()
	if introFinished then return end
	introFinished = true
	introActive = false
	pcall(function()
		local env = (getgenv and getgenv()) or _G
		env.__CRYON_INTRO_FINISHED_RUN = env.__CRYON_HIGH_PING_RUN or 0
	end)
	if fxConn then
		pcall(function() fxConn:Disconnect() end)
		fxConn = nil
	end
	if introSound then
		pcall(function()
			TweenService:Create(introSound, TweenInfo.new(0.35), { Volume = 0 }):Play()
		end)
		task.delay(0.4, function()
			pcall(function()
				introSound:Stop()
				introSound:Destroy()
			end)
		end)
	end
end

local gui = Instance.new("ScreenGui")
gui.Name = "HEARTLESSVsHalloweenIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function()
	if syn and syn.protect_gui then syn.protect_gui(gui) end
end)
local parented = pcall(function() gui.Parent = CoreGui end)
if not parented or not gui.Parent then
	gui.Parent = PlayerGui
end

local stage = Instance.new("Frame")
stage.Name = "Stage"
stage.Size = UDim2.fromScale(1, 1)
stage.BackgroundColor3 = Color3.fromRGB(6, 2, 10)
stage.BackgroundTransparency = 0
stage.BorderSizePixel = 0
stage.ClipsDescendants = true
stage.Parent = gui

-- Vignette naranja / púrpura
local vignette = Instance.new("Frame")
vignette.Name = "Vignette"
vignette.Size = UDim2.fromScale(1, 1)
vignette.BackgroundColor3 = Color3.fromRGB(40, 10, 0)
vignette.BackgroundTransparency = 0.55
vignette.BorderSizePixel = 0
vignette.ZIndex = 2
vignette.Parent = stage
local vigGrad = Instance.new("UIGradient")
vigGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.15),
	NumberSequenceKeypoint.new(0.45, 0.75),
	NumberSequenceKeypoint.new(1, 0.1),
})
vigGrad.Rotation = 90
vigGrad.Parent = vignette

-- Luna
local moon = Instance.new("Frame")
moon.Name = "Moon"
moon.AnchorPoint = Vector2.new(0.5, 0.5)
moon.Position = UDim2.fromScale(0.78, 0.22)
moon.Size = UDim2.fromOffset(110, 110)
moon.BackgroundColor3 = MOON
moon.BorderSizePixel = 0
moon.BackgroundTransparency = 1
moon.ZIndex = 5
moon.Parent = stage
Instance.new("UICorner", moon).CornerRadius = UDim.new(1, 0)
local moonGlow = Instance.new("UIStroke")
moonGlow.Color = ORANGE_L
moonGlow.Thickness = 4
moonGlow.Transparency = 1
moonGlow.Parent = moon
-- cráteres
for i, off in ipairs({{0.28, 0.3, 18}, {0.55, 0.55, 12}, {0.35, 0.62, 10}}) do
	local c = Instance.new("Frame")
	c.Name = "Crater" .. i
	c.AnchorPoint = Vector2.new(0.5, 0.5)
	c.Position = UDim2.fromScale(off[1], off[2])
	c.Size = UDim2.fromOffset(off[3], off[3])
	c.BackgroundColor3 = Color3.fromRGB(210, 185, 120)
	c.BackgroundTransparency = 0.35
	c.BorderSizePixel = 0
	c.ZIndex = 6
	c.Parent = moon
	Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
end

-- Estrellas / partículas
local starLayer = Instance.new("Frame")
starLayer.Name = "Stars"
starLayer.Size = UDim2.fromScale(1, 1)
starLayer.BackgroundTransparency = 1
starLayer.ZIndex = 3
starLayer.Parent = stage
local stars = {}
for i = 1, 36 do
	local s = Instance.new("Frame")
	s.Name = "Star" .. i
	s.BackgroundColor3 = (i % 3 == 0) and ORANGE_L or Color3.fromRGB(255, 255, 240)
	s.BorderSizePixel = 0
	local sz = 2 + math.random() * 3
	s.Size = UDim2.fromOffset(sz, sz)
	s.Position = UDim2.fromScale(math.random(), math.random() * 0.75)
	s.BackgroundTransparency = 0.2 + math.random() * 0.5
	s.ZIndex = 3
	s.Parent = starLayer
	Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
	stars[i] = { gui = s, base = s.BackgroundTransparency, phase = math.random() * 6.28, speed = 1.5 + math.random() }
end

-- Murciélagos (formas simples con frames)
local function makeBat(parent, x, y, scale)
	local bat = Instance.new("Frame")
	bat.Name = "Bat"
	bat.AnchorPoint = Vector2.new(0.5, 0.5)
	bat.Position = UDim2.fromScale(x, y)
	bat.Size = UDim2.fromOffset(28 * scale, 14 * scale)
	bat.BackgroundTransparency = 1
	bat.ZIndex = 12
	bat.Parent = parent
	local body = Instance.new("Frame")
	body.Name = "Body"
	body.AnchorPoint = Vector2.new(0.5, 0.5)
	body.Position = UDim2.fromScale(0.5, 0.5)
	body.Size = UDim2.fromScale(0.28, 0.55)
	body.BackgroundColor3 = Color3.fromRGB(15, 10, 20)
	body.BorderSizePixel = 0
	body.Parent = bat
	Instance.new("UICorner", body).CornerRadius = UDim.new(1, 0)
	local function wing(side)
		local w = Instance.new("Frame")
		w.Name = side == -1 and "WingL" or "WingR"
		w.AnchorPoint = Vector2.new(side == -1 and 1 or 0, 0.5)
		w.Position = UDim2.fromScale(0.5, 0.5)
		w.Size = UDim2.fromScale(0.48, 0.9)
		w.BackgroundColor3 = Color3.fromRGB(20, 12, 28)
		w.BorderSizePixel = 0
		w.Rotation = side * 8
		w.Parent = bat
		Instance.new("UICorner", w).CornerRadius = UDim.new(0.4, 0)
		return w
	end
	local wl, wr = wing(-1), wing(1)
	bat.BackgroundTransparency = 1
	return bat, wl, wr
end

local bats = {}
for i = 1, 5 do
	local b, wl, wr = makeBat(stage, -0.15 - i * 0.08, 0.25 + (i % 3) * 0.12, 0.9 + (i % 3) * 0.25)
	bats[i] = { gui = b, wl = wl, wr = wr, speed = 0.18 + i * 0.04, yBase = b.Position.Y.Scale, phase = i * 1.3 }
end

-- Calabazas (cuerpo + tallo + cara)
local function makePumpkin(parent, x, y, size)
	local root = Instance.new("Frame")
	root.Name = "Pumpkin"
	root.AnchorPoint = Vector2.new(0.5, 0.5)
	root.Position = UDim2.fromScale(x, y)
	root.Size = UDim2.fromOffset(size, size)
	root.BackgroundTransparency = 1
	root.ZIndex = 15
	root.Parent = parent

	local body = Instance.new("Frame")
	body.Name = "Body"
	body.Size = UDim2.fromScale(1, 0.92)
	body.Position = UDim2.fromScale(0, 0.08)
	body.BackgroundColor3 = PUMPKIN
	body.BorderSizePixel = 0
	body.Parent = root
	Instance.new("UICorner", body).CornerRadius = UDim.new(1, 0)
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(90, 40, 10)
	stroke.Thickness = 2
	stroke.Parent = body

	-- segmentos
	for _, ox in ipairs({0.28, 0.5, 0.72}) do
		local seg = Instance.new("Frame")
		seg.AnchorPoint = Vector2.new(0.5, 0.5)
		seg.Position = UDim2.fromScale(ox, 0.5)
		seg.Size = UDim2.new(0, 2, 0.7, 0)
		seg.BackgroundColor3 = Color3.fromRGB(200, 90, 10)
		seg.BackgroundTransparency = 0.45
		seg.BorderSizePixel = 0
		seg.ZIndex = 2
		seg.Parent = body
	end

	-- tallo
	local stem = Instance.new("Frame")
	stem.Name = "Stem"
	stem.AnchorPoint = Vector2.new(0.5, 1)
	stem.Position = UDim2.fromScale(0.5, 0.12)
	stem.Size = UDim2.fromOffset(math.max(8, size * 0.14), math.max(10, size * 0.18))
	stem.BackgroundColor3 = STEM
	stem.BorderSizePixel = 0
	stem.ZIndex = 16
	stem.Parent = root
	Instance.new("UICorner", stem).CornerRadius = UDim.new(0, 3)

	-- cara (ojos + boca)
	local function eye(px)
		local e = Instance.new("Frame")
		e.AnchorPoint = Vector2.new(0.5, 0.5)
		e.Position = UDim2.fromScale(px, 0.38)
		e.Size = UDim2.fromScale(0.16, 0.18)
		e.BackgroundColor3 = Color3.fromRGB(20, 8, 5)
		e.BorderSizePixel = 0
		e.Rotation = 0
		e.ZIndex = 3
		e.Parent = body
		Instance.new("UICorner", e).CornerRadius = UDim.new(0, 2)
		return e
	end
	eye(0.32); eye(0.68)
	local mouth = Instance.new("Frame")
	mouth.AnchorPoint = Vector2.new(0.5, 0.5)
	mouth.Position = UDim2.fromScale(0.5, 0.68)
	mouth.Size = UDim2.fromScale(0.42, 0.12)
	mouth.BackgroundColor3 = Color3.fromRGB(20, 8, 5)
	mouth.BorderSizePixel = 0
	mouth.ZIndex = 3
	mouth.Parent = body
	Instance.new("UICorner", mouth).CornerRadius = UDim.new(0, 3)

	return root
end

local pumpkins = {}
local pumpkinLayout = {
	{0.22, 1.15, 90},
	{0.50, 1.25, 130},
	{0.78, 1.18, 100},
	{0.35, 1.35, 70},
	{0.65, 1.40, 75},
}
for i, cfg in ipairs(pumpkinLayout) do
	local p = makePumpkin(stage, cfg[1], cfg[2], cfg[3])
	pumpkins[i] = { gui = p, targetY = 0.62 + (i % 3) * 0.05, size = cfg[3], phase = i * 0.9 }
end

-- Título + glow
local title = Instance.new("TextLabel")
title.Name = "Title"
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Position = UDim2.fromScale(0.5, 0.38)
title.Size = UDim2.new(0, 620, 0, 80)
title.BackgroundTransparency = 1
title.RichText = true
title.Text = "HEARTLESS.vs"
title.TextColor3 = ORANGE
title.Font = Enum.Font.GothamBlack
title.TextSize = 58
title.TextTransparency = 1
title.TextStrokeColor3 = Color3.fromRGB(80, 0, 0)
title.TextStrokeTransparency = 1
title.ZIndex = 30
title.Parent = stage
local titleGlow = Instance.new("TextLabel")
titleGlow.Name = "TitleGlow"
titleGlow.AnchorPoint = Vector2.new(0.5, 0.5)
titleGlow.Position = UDim2.fromScale(0.5, 0.38)
titleGlow.Size = UDim2.new(0, 640, 0, 90)
titleGlow.BackgroundTransparency = 1
titleGlow.Text = "HEARTLESS.vs"
titleGlow.TextColor3 = Color3.fromRGB(255, 60, 20)
titleGlow.Font = Enum.Font.GothamBlack
titleGlow.TextSize = 58
titleGlow.TextTransparency = 1
titleGlow.ZIndex = 29
titleGlow.Parent = stage

local tag = Instance.new("TextLabel")
tag.Name = "Tag"
tag.AnchorPoint = Vector2.new(0.5, 0.5)
tag.Position = UDim2.fromScale(0.5, 0.48)
tag.Size = UDim2.new(0, 520, 0, 28)
tag.BackgroundTransparency = 1
tag.Text = "* HALLOWEEN NIGHT *"
tag.TextColor3 = Color3.fromRGB(255, 90, 40)
tag.Font = Enum.Font.GothamBold
tag.TextSize = 14
tag.TextTransparency = 1
tag.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
tag.TextStrokeTransparency = 1
tag.ZIndex = 30
tag.Parent = stage

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
subtitle.Position = UDim2.fromScale(0.5, 0.54)
subtitle.Size = UDim2.new(0, 520, 0, 36)
subtitle.BackgroundTransparency = 1
subtitle.Text = "ENTER THE NIGHTMARE"
subtitle.TextColor3 = Color3.fromRGB(255, 200, 160)
subtitle.Font = Enum.Font.GothamBold
subtitle.TextSize = 22
subtitle.TextTransparency = 1
subtitle.TextStrokeColor3 = Color3.fromRGB(40, 0, 0)
subtitle.TextStrokeTransparency = 1
subtitle.ZIndex = 30
subtitle.Parent = stage

-- Niebla inferior
local fog = Instance.new("Frame")
fog.Name = "Fog"
fog.AnchorPoint = Vector2.new(0.5, 1)
fog.Position = UDim2.fromScale(0.5, 1.05)
fog.Size = UDim2.new(1.2, 0, 0.35, 0)
fog.BackgroundColor3 = Color3.fromRGB(40, 15, 30)
fog.BackgroundTransparency = 0.35
fog.BorderSizePixel = 0
fog.ZIndex = 12
fog.Parent = stage
local fogGrad = Instance.new("UIGradient")
fogGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.4, 0.55),
	NumberSequenceKeypoint.new(1, 0.2),
})
fogGrad.Rotation = 90
fogGrad.Parent = fog

-- Flash de rayo
local lightning = Instance.new("Frame")
lightning.Name = "Lightning"
lightning.Size = UDim2.fromScale(1, 1)
lightning.BackgroundColor3 = Color3.fromRGB(255, 240, 220)
lightning.BackgroundTransparency = 1
lightning.BorderSizePixel = 0
lightning.ZIndex = 40
lightning.Parent = stage

-- Línea decorativa bajo el título
local line = Instance.new("Frame")
line.Name = "Line"
line.AnchorPoint = Vector2.new(0.5, 0.5)
line.Position = UDim2.fromScale(0.5, 0.445)
line.Size = UDim2.fromOffset(0, 2)
line.BackgroundColor3 = ORANGE
line.BackgroundTransparency = 1
line.BorderSizePixel = 0
line.ZIndex = 30
line.Parent = stage

-- Skip
local skip = Instance.new("TextButton")
skip.AnchorPoint = Vector2.new(1, 1)
skip.Position = UDim2.new(1, -14, 1, -14)
skip.Size = UDim2.fromOffset(128, 38)
skip.BackgroundColor3 = Color3.fromRGB(18, 6, 10)
skip.BackgroundTransparency = 0.12
skip.BorderSizePixel = 0
skip.Text = "SKIP INTRO"
skip.TextColor3 = ORANGE_L
skip.TextSize = 12
skip.Font = Enum.Font.GothamBold
skip.AutoButtonColor = false
skip.ZIndex = 500
skip.Parent = gui
Instance.new("UICorner", skip).CornerRadius = UDim.new(0, 9)
local skipStroke = Instance.new("UIStroke")
skipStroke.Color = ORANGE
skipStroke.Transparency = 0.3
skipStroke.Thickness = 1.6
skipStroke.Parent = skip

skip.MouseButton1Click:Connect(function()
	if introFinished then return end
	finishIntro()
	pcall(function() gui:Destroy() end)
end)

-- Música Halloween
task.spawn(function()
	if not introActive then return end
	introSound = Instance.new("Sound")
	introSound.Name = "HEARTLESSVsHalloweenMusic"
	introSound.Volume = MUSIC_VOLUME
	introSound.Looped = false
	introSound.TimePosition = MUSIC_START
	introSound.Parent = SoundService

	local ids = MUSIC_FALLBACKS or { MUSIC_SOUND_ID }
	local playing = false
	for _, sid in ipairs(ids) do
		if not introActive then return end
		introSound.SoundId = sid
		local ok = pcall(function() introSound:Play() end)
		task.wait(0.25)
		if ok and introSound.IsPlaying then
			playing = true
			break
		end
		pcall(function() introSound:Stop() end)
	end
	if not playing then
		pcall(function()
			introSound.SoundId = MUSIC_SOUND_ID
			introSound:Play()
		end)
	end

	for _ = 1, 6 do
		task.wait(0.05)
		if not introActive or not introSound or not introSound.Parent then return end
		if (introSound.TimePosition or 0) < (MUSIC_START - 0.1) then
			pcall(function() introSound.TimePosition = MUSIC_START end)
		end
		if not introSound.IsPlaying then
			pcall(function() introSound:Play() end)
		end
	end

	local duration = math.max(0.5, MUSIC_END - MUSIC_START)
	task.delay(duration, function()
		if introSound and introSound.Parent and introActive then
			pcall(function()
				TweenService:Create(introSound, TweenInfo.new(0.45), { Volume = 0 }):Play()
			end)
		end
	end)
end)

-- FX: estrellas + murciélagos + niebla
fxConn = RunService.RenderStepped:Connect(function(dt)
	if not introActive then return end
	dt = dt or 0.016
	for _, s in ipairs(stars) do
		local g = s.gui
		if g and g.Parent then
			g.BackgroundTransparency = s.base + math.sin(tick() * s.speed + s.phase) * 0.28
		end
	end
	for _, b in ipairs(bats) do
		local g = b.gui
		if g and g.Parent then
			local x = g.Position.X.Scale + b.speed * dt
			local y = b.yBase + math.sin(tick() * 2.2 + b.phase) * 0.045
			if x > 1.2 then x = -0.15 end
			g.Position = UDim2.fromScale(x, y)
			if b.wl and b.wr then
				local flap = math.sin(tick() * 11 + b.phase) * 20
				b.wl.Rotation = -14 - flap
				b.wr.Rotation = 14 + flap
			end
		end
	end
	if fog and fog.Parent then
		fog.Position = UDim2.fromScale(0.5 + math.sin(tick() * 0.35) * 0.03, 1.02)
	end
end)

--============================================================
-- ANIMACIÓN (~8.5s) — más cinematic
--============================================================
if not introActive then
	pcall(function() gui:Destroy() end)
	return
end

local function flashLightning()
	if not introActive or not lightning.Parent then return end
	lightning.BackgroundTransparency = 0.35
	task.wait(0.05)
	if not introActive then return end
	lightning.BackgroundTransparency = 0.85
	task.wait(0.04)
	if not introActive then return end
	lightning.BackgroundTransparency = 0.25
	task.wait(0.07)
	if not introActive then return end
	TweenService:Create(lightning, TweenInfo.new(0.35), { BackgroundTransparency = 1 }):Play()
end

-- 1) Luna + niebla
TweenService:Create(moon, TweenInfo.new(1.0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	BackgroundTransparency = 0,
}):Play()
TweenService:Create(moonGlow, TweenInfo.new(1.0), { Transparency = 0.28 }):Play()
TweenService:Create(fog, TweenInfo.new(1.2), { BackgroundTransparency = 0.25 }):Play()
task.wait(0.8)
if not introActive then pcall(function() gui:Destroy() end); return end

-- Rayo 1
task.spawn(flashLightning)
task.wait(0.35)
if not introActive then pcall(function() gui:Destroy() end); return end

-- 2) Calabazas suben
for i, p in ipairs(pumpkins) do
	task.spawn(function()
		task.wait((i - 1) * 0.1)
		if not introActive or not p.gui.Parent then return end
		TweenService:Create(p.gui, TweenInfo.new(0.9, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = UDim2.fromScale(p.gui.Position.X.Scale, p.targetY),
		}):Play()
	end)
end
task.wait(1.35)
if not introActive then pcall(function() gui:Destroy() end); return end

local pumpkinBob = RunService.RenderStepped:Connect(function()
	if not introActive then return end
	for _, p in ipairs(pumpkins) do
		local g = p.gui
		if g and g.Parent then
			local bob = math.sin(tick() * 1.7 + p.phase) * 0.014
			g.Position = UDim2.fromScale(g.Position.X.Scale, p.targetY + bob)
		end
	end
end)

-- 3) Título + línea + tag
TweenService:Create(titleGlow, TweenInfo.new(0.5), { TextTransparency = 0.55 }):Play()
TweenService:Create(title, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	TextTransparency = 0,
	TextStrokeTransparency = 0.2,
}):Play()
TweenService:Create(line, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.fromOffset(220, 2),
	BackgroundTransparency = 0.15,
}):Play()
task.wait(0.4)
if not introActive then
	pcall(function() pumpkinBob:Disconnect() end)
	pcall(function() gui:Destroy() end)
	return
end
TweenService:Create(tag, TweenInfo.new(0.4), {
	TextTransparency = 0,
	TextStrokeTransparency = 0.35,
}):Play()
TweenService:Create(subtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	TextTransparency = 0,
	TextStrokeTransparency = 0.3,
}):Play()

-- Pulso del título
task.spawn(function()
	while introActive and title and title.Parent do
		TweenService:Create(titleGlow, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			TextTransparency = 0.35,
		}):Play()
		task.wait(0.7)
		if not introActive then break end
		TweenService:Create(titleGlow, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			TextTransparency = 0.7,
		}):Play()
		task.wait(0.7)
	end
end)

task.wait(1.2)
if not introActive then
	pcall(function() pumpkinBob:Disconnect() end)
	pcall(function() gui:Destroy() end)
	return
end

-- Rayo 2 + cambio de subtítulo
task.spawn(flashLightning)
subtitle.Text = "FEAR THE HUNT"
task.wait(1.4)
if not introActive then
	pcall(function() pumpkinBob:Disconnect() end)
	pcall(function() gui:Destroy() end)
	return
end
subtitle.Text = "HEARTLESS.vs  -  HALLOWEEN"
task.wait(1.3)
if not introActive then
	pcall(function() pumpkinBob:Disconnect() end)
	pcall(function() gui:Destroy() end)
	return
end

-- 4) Fade out cinematic
TweenService:Create(title, TweenInfo.new(0.5), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
TweenService:Create(titleGlow, TweenInfo.new(0.5), { TextTransparency = 1 }):Play()
TweenService:Create(tag, TweenInfo.new(0.45), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
TweenService:Create(subtitle, TweenInfo.new(0.45), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
TweenService:Create(line, TweenInfo.new(0.4), { BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 2) }):Play()
TweenService:Create(moon, TweenInfo.new(0.55), { BackgroundTransparency = 1 }):Play()
TweenService:Create(moonGlow, TweenInfo.new(0.55), { Transparency = 1 }):Play()
TweenService:Create(fog, TweenInfo.new(0.5), { BackgroundTransparency = 1 }):Play()
TweenService:Create(stage, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
TweenService:Create(vignette, TweenInfo.new(0.55), { BackgroundTransparency = 1 }):Play()
for _, p in ipairs(pumpkins) do
	if p.gui and p.gui.Parent then
		for _, d in ipairs(p.gui:GetDescendants()) do
			if d:IsA("Frame") then
				TweenService:Create(d, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
			elseif d:IsA("UIStroke") then
				TweenService:Create(d, TweenInfo.new(0.4), { Transparency = 1 }):Play()
			end
		end
		TweenService:Create(p.gui, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
	end
end
task.wait(0.6)

pcall(function() pumpkinBob:Disconnect() end)
finishIntro()
pcall(function() gui:Destroy() end)
		end) -- pcall intro body
		if not introOk then
			warn("[HEARTLESS.vs] Intro error: ", introErr)
			pcall(function()
				local env = (getgenv and getgenv()) or _G
				env.__CRYON_INTRO_FINISHED_RUN = env.__CRYON_HIGH_PING_RUN or 0
			end)
		end
		end) -- task.spawn
	end
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

local _tick     = tick
local _clamp    = math.clamp
local _floor    = math.floor
local _abs      = math.abs
local _huge     = math.huge
local _sqrt     = math.sqrt
local _V3new    = Vector3.new
local _V3zero   = Vector3.zero
local _CFnew    = CFrame.new
local _CFlookAt = CFrame.lookAt

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
CONFIG_FILE = "RaptureDuel.json"
_isDraggingButton = false

-- ============================================================
-- COLORES GLOBALES
-- ============================================================
local ORANGE       = Color3.fromRGB(255, 128, 0)
local PASTEL_PINK  = ORANGE
local NEON_PINK    = ORANGE
local BLACK_BG     = Color3.fromRGB(0, 0, 0)
local BLACK_STROKE = Color3.fromRGB(0, 0, 0)
local MINI_BUTTON_TEXT = Color3.fromRGB(220, 220, 220)

local INACTIVE_BG  = Color3.fromRGB(0, 0, 0)
local INACTIVE_TXT = Color3.fromRGB(255, 255, 255)
local ACTIVE_TXT   = ORANGE

-- ✅ Degradado Naranja para la barra de Steal
local STEAL_GRADIENT = {
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 128, 0)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 190, 80)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 128, 0)),
}

-- ============================================================
-- ESTADOS
-- ============================================================
aimbotMode = "V1"
aimbotModeSetVisual = nil
antiRagSetVisual = nil
stealModeSetVisual = nil

rainbowToolsEnabled     = false
transparentToolsEnabled = false
customToolsEnabled      = false
customSoundsEnabled     = false
customToolSkin          = "DiamondSword"
toolSkinSetVisual       = nil

batBypassEnabled = batBypassEnabled or false
batBypassSetVisual = nil
batBypassFloatingButton = nil
batBypassFloatingPos = nil

antiDieEnabled = antiDieEnabled or false
antiFlingEnabled = antiFlingEnabled or false
setAntiDieVisual = nil
setAntiFlingVisual = nil

_G.RaptureToolAssets = {
    DiamondSword = {
        label = "Diamond Sword", cat = "Bat",
        mesh = "rbxassetid://8827558932", tex = "rbxassetid://8827558969",
        scale = Vector3.new(0.2, 0.2, 0.2),
        c0 = CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), 300),
        view = 4.9,
    },
    Katana = {
        label = "Katana", cat = "Bat",
        mesh = "rbxassetid://13528902482", tex = "rbxassetid://13528902373",
        scale = Vector3.new(1.4, 1.4, 1.4),
        c0 = CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)),
        view = 6.6,
    },
    Skull = {
        label = "Skull", cat = "Medusa",
        mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
        scale = Vector3.new(1, 1, 1),
        c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
        view = 4.2,
    },
    GoldenDesertEagle = {
        label = "Golden Desert Eagle", cat = "Medusa",
        mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
        scale = Vector3.new(0.01, 0.01, 0.01),
        c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
        view = 3.0,
    },
}

stealMode = "Normal"
V2_STOP_PERCENT = 70
NORMAL_STOP_PERCENT = 90

backgroundIndex = 1
backgroundImages = {
    -- Fondos Halloween (casa embrujada, calabazas, luna, cementerio, esqueletos)
    "306356299",      -- Haunted house night scene
    "2489023285",     -- Haunted house wall texture
    "1091692228",     -- Black cat on pumpkins
    "4185844526",     -- Pumpkin with lights
    "5634829236",     -- Jack-o'-lantern face
    "4019381967",     -- Cute Halloween ghost
    "185495988",      -- Spooky skeleton
    "36517427",       -- Scary pumpkin face
}

backgroundImageTransparency = 0
floatingButtonScale = 1
progressBarScale = 1
_floatingUIScales = {}

titleLbl = nil
miniBtn = nil
bestScripLabel = nil
raptureLinkLabel = nil
skipIntroToggleSet = nil

local PRINTED_SOUND_PACKS = {
    V1 = {
        toggle = { "rbxassetid://6042053626", "rbxassetid://3398620867", "rbxassetid://255881176", "rbxassetid://12222208" },
        tab    = { "rbxassetid://3398620867", "rbxassetid://6042053626", "rbxassetid://12222200" },
        pitch = 1, volume = 2,
    },
    V2 = {
        toggle = { "rbxassetid://9113822143", "rbxassetid://6895079853", "rbxassetid://12222208" },
        tab    = { "rbxassetid://9113821597", "rbxassetid://6895079733", "rbxassetid://12222200" },
        pitch = 1.15, volume = 1.6,
    },
}
currentSoundPack = "V1"
local _soundCache = {}

local function getMenuSound(idList)
    local key = table.concat(idList, "|")
    local cached = _soundCache[key]
    if cached and cached.Parent then return cached end
    for _, id in ipairs(idList) do
        local ok, sound = pcall(function()
            local s = Instance.new("Sound")
            s.Name = "RaptureMenuSound"
            s.SoundId = id
            s.Parent = SoundService
            pcall(function() task.wait() end)
            return s
        end)
        if ok and sound then
            if sound.IsLoaded then _soundCache[key] = sound return sound end
            pcall(function() sound:Destroy() end)
        end
    end
    return nil
end

local function playMenuSound(kind)
    pcall(function()
        local pack = PRINTED_SOUND_PACKS[currentSoundPack] or PRINTED_SOUND_PACKS.V1
        local sound = getMenuSound(kind == "tab" and pack.tab or pack.toggle)
        if not sound then return end
        local clone = sound:Clone()
        clone.Volume = pack.volume or 1.5
        local pitch = pack.pitch or 1
        if kind == "tab" then pitch = pitch * 0.94 end
        clone.PlaybackSpeed = pitch
        clone.Parent = SoundService
        clone:Play()
        task.delay(3, function() pcall(function() clone:Destroy() end) end)
    end)
end

function getThemeColor() return ORANGE end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

_G._RaptureDynamicSliders = _G._RaptureDynamicSliders or {}

function _RaptureApplyThemeToSliders()
    for _, entry in ipairs(_G._RaptureDynamicSliders) do
        if entry and entry.applyThemeColor then
            pcall(entry.applyThemeColor, PASTEL_PINK)
        end
    end
end

function updateAllUIThemeColors(color)
    color = color or PASTEL_PINK
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.05 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if progressFill then progressFill.BackgroundColor3 = ORANGE end
    if pbFrame then
        local border = pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = BLACK_STROKE end
        pbFrame.BackgroundColor3 = BLACK_BG
    end

    if speedLabel then speedLabel.TextColor3 = color end
    if bestScripLabel then bestScripLabel.TextColor3 = color end
    if raptureLinkLabel then raptureLinkLabel.TextColor3 = color end

    local char = LP.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("RaptureDuelSpeedIndicator")
            if bb then
                for _, child in ipairs(bb:GetChildren()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        child.TextColor3 = color
                    end
                end
            end
            local ragBB = head:FindFirstChild("RaptureRagTimerBillboard")
            if ragBB then
                local ragLbl = ragBB:FindFirstChild("RagTimerLbl")
                if ragLbl then ragLbl.TextColor3 = color end
            end
        end
    end

    if titleLbl then titleLbl.TextColor3 = color end
    if miniBtn then miniBtn.TextColor3 = MINI_BUTTON_TEXT end

    for plr, billboard in pairs(espBillboardCache) do
        if billboard and billboard.Parent then
            local container = billboard:FindFirstChild("Frame")
            if container then
                local nameLbl = container:FindFirstChild("TextLabel")
                if nameLbl then nameLbl.TextColor3 = color end
            end
        end
    end

    if tpBatFloatingButton then
        paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
    end

    if batBypassFloatingButton then
        paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), batBypassEnabled)
    end

    for _, tab in ipairs(tabButtons or {}) do
        if tab:GetAttribute("IsActiveTab") then
            tab.TextColor3 = ACTIVE_TXT
            tab.BackgroundColor3 = BLACK_BG
        end
    end

    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end

    if lockBtn then lockBtn.TextColor3 = color end
end

speedMode = false
autoCarryEnabled = false
autoCarrySpeedActive = false
autoCarryConn = nil
setAutoCarryVisual = nil
antiRagdollEnabled = false
antiRagdollVersion = "v1"
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 2
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
stretchValue = 0.7
uiLocked = true
uiScaleValue = 66
progressBarScaleValue = 78
espEnabled = false
antiLagEnabled = false
ragdollTimerEnabled = false


-- Reproductor local con la playlist completa de HEARTLESS.
local HEARTLESSMusicEnabled = false
local HEARTLESSSelectedSongIndex = 1
local HEARTLESSCurrentSound = nil
local HEARTLESSPlaybackGeneration = 0
local HEARTLESSMusicSetVisual = nil
local HEARTLESSMusicTrackRefresh = nil
local HEARTLESSMusicSoundService = game:GetService("SoundService")
local HEARTLESSAssetFunction = getcustomasset or getsynasset
local HEARTLESS_MUSIC_TRACKS = {
    -- Originales
    {
        title = "El corrido del 30",
        url = "https://files.catbox.moe/pf9kd9.mp3",
        file = "corrido_del_30.mp3",
    },
    {
        title = "WARE",
        url = "https://files.catbox.moe/p2pp91.mp3",
        file = "Ware.mp3",
    },
    {
        title = "El Hijo del 7",
        url = "https://files.catbox.moe/wpbab3.mp3",
        file = "elhijodel7.mp3",
    },
    {
        title = "WOW",
        url = "https://files.catbox.moe/14rdtj.mp3",
        file = "WOW.mp3",
    },
    {
        title = "el de la R",
        url = "https://files.catbox.moe/u67vx5.mp3",
        file = "eldelaR.mp3",
    },
    {
        title = "EL CHIRICUAZO",
        url = "https://files.catbox.moe/va3lhi.mp3",
        file = "chiricuazo_v2.mp3",
    },
    {
        title = "HORA 0",
        url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
        file = "hora_0.mp3",
    },
    {
        title = "El Maestro",
        url = "https://files.catbox.moe/bmjsah.mp3",
        file = "el_maestro.mp3",
    },
    {
        title = "Seteadora",
        url = "https://files.catbox.moe/94olvv.mp3",
        file = "Seteadora.mp3",
    },
    {
        title = "El Ondeado V2",
        url = "https://files.catbox.moe/4lqp91.mp3",
        file = "el_ondeado_v2.mp3",
    },
    -- Nuevas canciones (8)
    {
        title = "tuffsong",
        url = "https://files.catbox.moe/rvf2vy.mp3",
        file = "tuffsong.mp3",
    },
    {
        title = "friosong",
        url = "https://files.catbox.moe/v20ko9.mp3",
        file = "friosong.mp3",
    },
    {
        title = "xoxosong",
        url = "https://files.catbox.moe/jghp0f.mp3",
        file = "xoxosong.mp3",
    },
    {
        title = "beretta",
        url = "https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3",
        file = "overseer_beretta_filegarden.mp3",
    },
    {
        title = "tp the 0",
        url = "https://file.garden/algLafWA1jk8WMfK/King%20Von%20-%20Took%20Her%20To%20The%20O%20(Lyrics)(MP3_160K).mp3",
        file = "overseer_to_the_o_filegarden.mp3",
    },
    {
        title = "laja",
        url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3",
        file = "overseer_laja_nadie_ta_frio_filegarden.mp3",
    },
    {
        title = "hora 0",
        url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
        file = "overseer_hora_0_filegarden.mp3",
    },
    {
        title = "lucid",
        url = "https://file.garden/algLafWA1jk8WMfK/Lucid%20Dreams%20-%20Clean%20-%20Juice%20WRLD(MP3_160K).mp3",
        file = "overseer_lucid_dreams_filegarden.mp3",
    },
    {
        title = "NUTS",
        url = "https://archive.org/download/li-l-peep-nuts-feat.-lil-skil-extended_202011/LiL%20PEEP%20-%20nuts%20%28feat.%20lil%20skil%29%20%28Extended%29.mp3",
        file = "mvp_nuts_lilpeep.mp3",
    },
    {
        title = "Cinderella",
        url = "https://ia801000.us.archive.org/29/items/macmiller_202012/Cinderella.mp3",
        file = "mvp_cinderella_macmiller_v3.mp3",
    },
    {
        title = "BIA - WE ON GO",
        url = "https://ia601009.us.archive.org/21/items/we-on-go/WE%20ON%20GO.mp3",
        file = "mvp_intro_weongo.mp3",
    },
}

local function HEARTLESSValidAudio(data)
    if type(data) ~= "string" or #data < 2048 then return false end
    local header = data:sub(1, 256):lower()
    return not (header:find("<html", 1, true) or header:find("<!doctype", 1, true)
        or header:find("access denied", 1, true) or header:find("not found", 1, true)
        or header:find("error", 1, true))
end

local function HEARTLESSDownloadSong(url, path)
    if type(writefile) ~= "function" then return false end
    local data
    local requestFn = request or http_request or (syn and syn.request) or (fluxus and fluxus.request)
    if type(requestFn) == "function" then
        local ok, res = pcall(requestFn, {Url = url, Method = "GET", Headers = {
            ["User-Agent"] = "Mozilla/5.0", ["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8"
        }})
        if ok and type(res) == "table" then
            local code = tonumber(res.StatusCode or res.Status or res.status_code) or 0
            local body = res.Body or res.body
            if (code == 0 or (code >= 200 and code < 300)) and HEARTLESSValidAudio(body) then data = body end
        end
    end
    if not data then
        local ok, result = pcall(function() return game:HttpGet(url, true) end)
        if ok and HEARTLESSValidAudio(result) then data = result end
    end
    if not data then return false end
    return pcall(writefile, path, data)
end

local function HEARTLESSLocalAsset(path)
    if type(HEARTLESSAssetFunction) ~= "function" then return nil end
    local ok, id = pcall(HEARTLESSAssetFunction, path)
    return ok and type(id) == "string" and id ~= "" and id or nil
end

local function stopHEARTLESSMusic()
    HEARTLESSPlaybackGeneration = HEARTLESSPlaybackGeneration + 1
    local sound = HEARTLESSCurrentSound
    HEARTLESSCurrentSound = nil
    if sound then
        pcall(function() sound:Stop() end)
        pcall(function() sound:Destroy() end)
    end
end

local function playHEARTLESSMusic(index)
    if not HEARTLESSMusicEnabled then return end
    index = math.clamp(math.floor(tonumber(index) or HEARTLESSSelectedSongIndex or 1), 1, #HEARTLESS_MUSIC_TRACKS)
    HEARTLESSSelectedSongIndex = index
    HEARTLESSPlaybackGeneration = HEARTLESSPlaybackGeneration + 1
    local generation = HEARTLESSPlaybackGeneration
    local prior = HEARTLESSCurrentSound
    HEARTLESSCurrentSound = nil
    if prior then
        pcall(function() prior:Stop() end)
        pcall(function() prior:Destroy() end)
    end
    if HEARTLESSMusicTrackRefresh then HEARTLESSMusicTrackRefresh() end
    local song = HEARTLESS_MUSIC_TRACKS[index]
    local assetId = HEARTLESSLocalAsset(song.file)
    if not assetId then
        local downloaded = HEARTLESSDownloadSong(song.url, song.file)
        if downloaded then assetId = HEARTLESSLocalAsset(song.file) end
    end
    if generation ~= HEARTLESSPlaybackGeneration or not HEARTLESSMusicEnabled then return end
    if not assetId then
        warn("[MUSIC] No se pudo cargar: " .. tostring(song.title) .. ". Revisa getcustomasset/getsynasset y la descarga local.")
        return
    end
    local sound = Instance.new("Sound")
    sound.Name = "HEARTLESSMusic_" .. song.title:gsub("%s+", "_")
    sound.SoundId = assetId
    sound.Volume = 0.75
    sound.Looped = true
    sound.Parent = HEARTLESSMusicSoundService
    HEARTLESSCurrentSound = sound
    local ok = pcall(function() sound:Play() end)
    if not ok then
        if HEARTLESSCurrentSound == sound then HEARTLESSCurrentSound = nil end
        pcall(function() sound:Destroy() end)
    end
end

function setHEARTLESSMusicEnabled(on)
    HEARTLESSMusicEnabled = on == true
    if HEARTLESSMusicEnabled then playHEARTLESSMusic(HEARTLESSSelectedSongIndex) else stopHEARTLESSMusic() end
    if HEARTLESSMusicSetVisual then HEARTLESSMusicSetVisual(HEARTLESSMusicEnabled) end
    task.defer(saveAllSettings)
end

function changeHEARTLESSMusicTrack(delta)
    HEARTLESSSelectedSongIndex = ((HEARTLESSSelectedSongIndex - 1 + delta) % #HEARTLESS_MUSIC_TRACKS) + 1
    if HEARTLESSMusicTrackRefresh then HEARTLESSMusicTrackRefresh() end
    if HEARTLESSMusicEnabled then playHEARTLESSMusic(HEARTLESSSelectedSongIndex) end
    task.defer(saveAllSettings)
end

local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espGlowCache = {}
local espConn = nil

local _markerCache = {}
local _markerConn = nil
local MARKER_LIFETIME = 3.5

antiLagDescConn = nil
_antiLagStored = {}

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batBypassFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil


bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
bodyLockSetVisual = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
animSelectorLabel = nil
originalTryardAnims = nil
currentAnimPack = "Off"
tryardHeartbeatConn = nil
local originalAnimSets = setmetatable({}, { __mode = "k" })

ANIM_PACKS = {
            Zombie = {
                idle1 = "rbxassetid://616158929",
                idle2 = "rbxassetid://616160636",
                walk = "rbxassetid://616168032",
                run = "rbxassetid://616163682",
                jump = "rbxassetid://616161997",
                fall = "rbxassetid://616157476",
                climb = "rbxassetid://616156119",
                swim = "rbxassetid://616165109",
                swimidle = "rbxassetid://616166655",
            },
            Ninja = {
                idle1 = "rbxassetid://656117400",
                idle2 = "rbxassetid://656117400",
                walk = "rbxassetid://656121766",
                run = "rbxassetid://656118852",
                jump = "rbxassetid://656117878",
                fall = "rbxassetid://656115606",
                climb = "rbxassetid://656114359",
                swim = "rbxassetid://656117400",
                swimidle = "rbxassetid://656117400",
            },
            Knight = {
                idle1 = "rbxassetid://657595757",
                idle2 = "rbxassetid://657595757",
                walk = "rbxassetid://657552124",
                run = "rbxassetid://657564596",
                jump = "rbxassetid://658409194",
                fall = "rbxassetid://657600338",
                climb = "rbxassetid://658360781",
                swim = "rbxassetid://657595757",
                swimidle = "rbxassetid://657595757",
            },
            Elder = {
                idle1 = "rbxassetid://845397899",
                idle2 = "rbxassetid://845397899",
                walk = "rbxassetid://845403856",
                run = "rbxassetid://845386501",
                jump = "rbxassetid://845398858",
                fall = "rbxassetid://845397673",
                climb = "rbxassetid://845392038",
                swim = "rbxassetid://845397899",
                swimidle = "rbxassetid://845397899",
            },
            ["Levitate"] = {
                idle1 = "rbxassetid://616006778",
                idle2 = "rbxassetid://616006778",
                walk = "rbxassetid://616013216",
                run = "rbxassetid://616013216",
                jump = "rbxassetid://616008936",
                fall = "rbxassetid://616005863",
                climb = "rbxassetid://616003713",
                swim = "rbxassetid://616006778",
                swimidle = "rbxassetid://616006778",
            },
            Astronaut = {
                idle1 = "rbxassetid://891621366",
                idle2 = "rbxassetid://891621366",
                walk = "rbxassetid://891636393",
                run = "rbxassetid://891636393",
                jump = "rbxassetid://891627522",
                fall = "rbxassetid://891617961",
                climb = "rbxassetid://891609353",
                swim = "rbxassetid://891621366",
                swimidle = "rbxassetid://891621366",
            },
            Pirate = {
                idle1 = "rbxassetid://750781874",
                idle2 = "rbxassetid://750781874",
                walk = "rbxassetid://750785693",
                run = "rbxassetid://750783738",
                jump = "rbxassetid://750782230",
                fall = "rbxassetid://750780242",
                climb = "rbxassetid://750779899",
                swim = "rbxassetid://750781874",
                swimidle = "rbxassetid://750781874",
            },
            Toy = {
                idle1 = "rbxassetid://782841498",
                idle2 = "rbxassetid://782841498",
                walk = "rbxassetid://782843345",
                run = "rbxassetid://782842708",
                jump = "rbxassetid://782847020",
                fall = "rbxassetid://782846423",
                climb = "rbxassetid://782843869",
                swim = "rbxassetid://782841498",
                swimidle = "rbxassetid://782841498",
            },
            Vampire = {
                idle1 = "rbxassetid://1083445855",
                idle2 = "rbxassetid://1083445855",
                walk = "rbxassetid://1083473930",
                run = "rbxassetid://1083462077",
                jump = "rbxassetid://1083455352",
                fall = "rbxassetid://1083443587",
                climb = "rbxassetid://1083439238",
                swim = "rbxassetid://1083445855",
                swimidle = "rbxassetid://1083445855",
            },
            Werewolf = {
                idle1 = "rbxassetid://1083195517",
                idle2 = "rbxassetid://1083195517",
                walk = "rbxassetid://1083178339",
                run = "rbxassetid://1083216690",
                jump = "rbxassetid://1083218792",
                fall = "rbxassetid://1083189019",
                climb = "rbxassetid://1083182000",
                swim = "rbxassetid://1083195517",
                swimidle = "rbxassetid://1083195517",
            },
            Rthro = {
                idle1 = "rbxassetid://2510196951",
                idle2 = "rbxassetid://2510196951",
                walk = "rbxassetid://2510202577",
                run = "rbxassetid://2510198475",
                jump = "rbxassetid://2510197830",
                fall = "rbxassetid://2510195892",
                climb = "rbxassetid://2510192778",
                swim = "rbxassetid://2510196951",
                swimidle = "rbxassetid://2510196951",
            },
            Stylish = {
                idle1 = "rbxassetid://616136790",
                idle2 = "rbxassetid://616136790",
                walk = "rbxassetid://616146177",
                run = "rbxassetid://616140816",
                jump = "rbxassetid://616139451",
                fall = "rbxassetid://616134815",
                climb = "rbxassetid://616133594",
                swim = "rbxassetid://616136790",
                swimidle = "rbxassetid://616136790",
            },
        }

ANIM_PACK_ORDER = {"Off", "Zombie", "Ninja", "Knight", "Elder", "Levitate", "Astronaut", "Pirate", "Toy", "Vampire", "Werewolf", "Rthro", "Stylish"}

local function getAnimationObjects(character)
    local animate = character and character:FindFirstChild("Animate")
    if not animate then return nil end
    local function child(parent, name)
        return parent and parent:FindFirstChild(name) or nil
    end
    local idle, walk, run = child(animate, "idle"), child(animate, "walk"), child(animate, "run")
    local jump, fall, climb = child(animate, "jump"), child(animate, "fall"), child(animate, "climb")
    local swim, swimidle = child(animate, "swim"), child(animate, "swimidle")
    return {
        idle1 = child(idle, "Animation1"), idle2 = child(idle, "Animation2"),
        walk = child(walk, "WalkAnim"), run = child(run, "RunAnim"),
        jump = child(jump, "JumpAnim"), fall = child(fall, "FallAnim"),
        climb = child(climb, "ClimbAnim"), swim = child(swim, "Swim"),
        swimidle = child(swimidle, "SwimIdle"),
    }
end

local function captureOriginalAnimations(character)
    if not character or originalAnimSets[character] then return end
    local objects = getAnimationObjects(character)
    if not objects then return end
    local ids = {}
    for key, object in pairs(objects) do
        if object and object:IsA("Animation") then ids[key] = object.AnimationId end
    end
    originalAnimSets[character] = ids
    originalTryardAnims = ids
end

local function writeAnimationIds(character, ids)
    local objects = getAnimationObjects(character)
    if not objects or not ids then return false end
    for key, object in pairs(objects) do
        if object and object:IsA("Animation") and ids[key] then
            object.AnimationId = ids[key]
        end
    end
    return true
end

local function stopAnimationTracks(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
    pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
end

function applyAnimationPack(packName)
    if packName ~= "Off" and not ANIM_PACKS[packName] then return false end
    currentAnimPack = packName
    if animSelectorLabel and animSelectorLabel.Parent then
        animSelectorLabel.Text = packName .. "  ▼"
    end
    if tryardHeartbeatConn then
        tryardHeartbeatConn:Disconnect()
        tryardHeartbeatConn = nil
    end
    local character = LP.Character
    if not character then return true end
    captureOriginalAnimations(character)
    if packName == "Off" then
        writeAnimationIds(character, originalAnimSets[character])
        stopAnimationTracks(character)
        return true
    end
    local pack = ANIM_PACKS[packName]
    local elapsed = 0
    local function applyNow()
        if LP.Character == character then writeAnimationIds(character, pack) end
    end
    applyNow()
    stopAnimationTracks(character)
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function(dt)
        elapsed = elapsed + dt
        if elapsed < 0.25 then return end
        elapsed = 0
        if LP.Character ~= character then return end
        applyNow()
    end)
    return true
end

function disableAnimationPack()
    return applyAnimationPack("Off")
end

local function findNearestBodyLockTarget(root)
    if not root then return nil end
    local nearest, nearestDistance = nil, _huge
    for _, player in ipairs(_GetPlayersCached()) do
        if player ~= LP then
            local character = player.Character
            local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if targetRoot and humanoid and humanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < nearestDistance then
                    nearest, nearestDistance = targetRoot, distance
                end
            end
        end
    end
    return nearest
end

local function bodyLockTick()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    local target = findNearestBodyLockTarget(root)
    if not target or (target.Position - root.Position).Magnitude > bodyLockRange then
        humanoid.AutoRotate = true
        return
    end
    humanoid.AutoRotate = false
    local velocity = target.AssemblyLinearVelocity
    local predicted = target.Position + velocity * _clamp(velocity.Magnitude / 80, 0.08, 0.35)
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetY = targetHead and targetHead.Position.Y or target.Position.Y
    local yOffset = _clamp((targetY - root.Position.Y + (humanoid.HipHeight or 0)) * 0.15, -1.5, 1.5)
    local lookPoint = _V3new(predicted.X, root.Position.Y + yOffset, predicted.Z)
    if (lookPoint - root.Position).Magnitude > 0.1 then
        local look = _CFlookAt(root.Position, lookPoint)
        local _, yaw = (root.CFrame:Inverse() * look):ToEulerAnglesXYZ()
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, _clamp(yaw, -2.5, 2.5) * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    local accumulator = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled or _blSuppressCount > 0 then return end
        accumulator = accumulator + dt
        if accumulator < 0.033 then return end
        accumulator = 0
        pcall(bodyLockTick)
    end)
end

function stopBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    if humanoid then humanoid.AutoRotate = true end
end

_suppressBodyLock = function()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
        _blSmoothRestore = false
    end
end

_unsuppressBodyLock = function(delayed)
    if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then _blRestoreTimer = task.delay(1, restore) else restore() end
    end
end


useCarrySystem = false
lastMoveDir = _V3zero

-- ============================================================
-- MEDUSA HIT HELPERS
-- ============================================================
local function getMedusaHitTime() return _G._RaptureMedusaHitTime or 0 end
local function isMedusaHit() return (_tick() - getMedusaHitTime()) < 4 end
local function setMedusaHitTime() _G._RaptureMedusaHitTime = _tick() end

do
    local _medusaWatcherConns = {}
    local function _clearMedusaWatcher()
        for _, c in ipairs(_medusaWatcherConns) do pcall(function() c:Disconnect() end) end
        _medusaWatcherConns = {}
    end
    local function _hookPart(part)
        if not part:IsA("BasePart") then return end
        local c = part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if part.Anchored and part.Transparency == 1 then setMedusaHitTime() end
        end)
        table.insert(_medusaWatcherConns, c)
    end
    local function _attachMedusaWatcher(char)
        _clearMedusaWatcher()
        _G._RaptureMedusaHitTime = 0
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do _hookPart(part) end
        table.insert(_medusaWatcherConns, char.DescendantAdded:Connect(function(part) _hookPart(part) end))
    end
    if LP.Character then _attachMedusaWatcher(LP.Character) end
    LP.CharacterAdded:Connect(function(char) waitForCharReady(char, 10); _attachMedusaWatcher(char) end)
end

-- ============================================================
-- RAGDOLL COUNTDOWN
-- ============================================================
_G._RaptureRCD = _G._RaptureRCD or {conn=nil, charConn=nil, endTime=0, seconds=2.6}
ragdollCountdownLabel = nil
ragdollCountdownEnabled = false

function hookRagdollCountdown(char)
    if _G._RaptureRCD.conn then pcall(function() _G._RaptureRCD.conn:Disconnect() end); _G._RaptureRCD.conn = nil end
    if _G._RaptureRCD.charConn then pcall(function() _G._RaptureRCD.charConn:Disconnect() end); _G._RaptureRCD.charConn = nil end
    if not ragdollCountdownEnabled then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4)
    if not hum then return end

    local function beginCountdown()
        local duration = isMedusaHit() and 3.6 or _G._RaptureRCD.seconds
        _G._RaptureRCD.endTime = _tick() + duration
        if ragdollCountdownLabel then ragdollCountdownLabel.Visible = true end
    end
    local function isRagdollStateForCountdown()
        local st = hum:GetState()
        return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
    end
    _G._RaptureRCD.charConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then beginCountdown() end
    end)
    _G._RaptureRCD.conn = RunService.RenderStepped:Connect(function()
        if not ragdollCountdownEnabled then
            if _G._RaptureRCD.conn then pcall(function() _G._RaptureRCD.conn:Disconnect() end); _G._RaptureRCD.conn = nil end
            if ragdollCountdownLabel then ragdollCountdownLabel.Visible = false; ragdollCountdownLabel.Text = "" end
            return
        end
        if not ragdollCountdownLabel or not ragdollCountdownLabel.Parent then return end
        if isRagdollStateForCountdown() and _G._RaptureRCD.endTime < _tick() then beginCountdown() end
        local left = math.max(0, _G._RaptureRCD.endTime - _tick())
        if left > 0 then
            ragdollCountdownLabel.Visible = true
            ragdollCountdownLabel.Text = string.format("RAGDOLL %.1f", left)
            ragdollCountdownLabel.TextColor3 = left <= 1 and Color3.fromRGB(255, 230, 90) or getThemeColor()
        else
            ragdollCountdownLabel.Visible = false
            ragdollCountdownLabel.Text = ""
        end
    end)
end

-- ============================================================
-- ANTI FLING
-- ============================================================
local _antiFlingState = { connection = nil, threshold = 80, spinThreshold = 40 }
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__RaptureLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    if autoBatEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then return true end
    if batDesyncTpEnabled then return true end
    return false
end

function startAntiFling()
    if _antiFlingState.connection then return end
    antiFlingEnabled = true
    _antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end
        if dropActive or _G.IsDropping then return end
        if _afOwnMoverActive() then return end
        if _afHubSpeedLive() then return end

        local velocity = root.AssemblyLinearVelocity
        local flat = Vector3.new(velocity.X, 0, velocity.Z)

        if flat.Magnitude > _antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end

function stopAntiFling()
    antiFlingEnabled = false
    if _antiFlingState.connection then
        _antiFlingState.connection:Disconnect()
        _antiFlingState.connection = nil
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiFlingEnabled then startAntiFling() end
end)

-- ============================================================
-- ANTI DIE
-- ============================================================
_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false }

_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        fallDamageProtection = false,
        ragdollProtection = true,
        autoRevive = true,
    },
}

function _antiDie.SuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    _antiDie.invincibleUntil = _tick() + _antiDie.config.invincibilityFrames
    _antiDie.lastHealTime = _tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then
            hum.Health = hum.MaxHealth or 100
        end
    end
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDie.SuperHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AutoRevive()
    if not _antiDie.config.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AttachHealth(char)
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _antiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        if hum.Health <= 0 then _antiDie.AutoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
end

function _antiDie.StartEngine()
    if _antiDie.enabled and _antiDie.loop then return end
    _antiDie.enabled = true
    _antiDieEnabled = true
    antiDieEnabled = true
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    _antiDie.loop = RunService.Heartbeat:Connect(function()
        if not _antiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        _antiDie.PreventDamage(root, hum)
    end)
    if LP.Character then _antiDie.AttachHealth(LP.Character) end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    _antiDie.charConn = LP.CharacterAdded:Connect(function(char)
        if not _antiDie.enabled then return end
        task.wait(0.05)
        _antiDie.AttachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then _antiDie.SuperHeal(hum) end
    end)
end

function _antiDie.StopEngine()
    _antiDie.enabled = false
    _antiDieEnabled = false
    antiDieEnabled = false
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.BreakJointsOnDeath = true
        if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
            hum.MaxHealth = 100
            hum.Health = math.min(hum.Health, 100)
        end
    end)
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled then _antiDie.StartEngine() else _antiDie.StopEngine() end
end

_G.AntiDie = {
    start = function() _antiDieStopped = false; _antiDieSetEnabled(true) end,
    stop = function() _antiDieSetEnabled(false) end,
}

-- ============================================================
-- TOOLS ENGINE (rainbow, transparent, custom, sounds)
-- ============================================================
do
    local CT_ITEMS = {
        { key = "Bat",    match = function(n) n = n:lower() return n:find("bat") ~= nil or n:find("slap") ~= nil end },
        { key = "Medusa", match = function(n) return n:lower():find("medusa") ~= nil end },
    }
    local function ctMatchItem(inst)
        if not (inst:IsA("Tool") or inst:IsA("Model") or inst:IsA("Accessory") or inst:IsA("BasePart")) then return nil end
        for _, item in ipairs(CT_ITEMS) do
            if item.match(inst.Name) then return item end
        end
        return nil
    end
    local function isReplicaStuff(d)
        if d.Name == "LocalReplica" then return true end
        return d:FindFirstAncestor("LocalReplica") ~= nil
    end
    local CT_Trans = {}
    do
        local PRIORITY = { "custom", "rainbow", "transparent" }
        local baseline = setmetatable({}, { __mode = "k" })
        local claims   = setmetatable({}, { __mode = "k" })
        function CT_Trans.getBaseline(part)
            local b = baseline[part]
            if b ~= nil then return b end
            local ok, val = pcall(function() return part.Transparency end)
            if not ok then return nil end
            baseline[part] = val
            return val
        end
        local function wantedValue(part)
            local c = claims[part]
            if not c then return nil end
            for _, who in ipairs(PRIORITY) do
                if c[who] ~= nil then return c[who] end
            end
            return nil
        end
        local function resolve(part)
            local v = wantedValue(part)
            if v ~= nil then pcall(function() part.Transparency = v end) return end
            local b = baseline[part]
            if b ~= nil then pcall(function() part.Transparency = b end) end
        end
        function CT_Trans.claim(part, who, value)
            if not part then return end
            if CT_Trans.getBaseline(part) == nil then return end
            local c = claims[part]
            if not c then c = {}; claims[part] = c end
            c[who] = value
            resolve(part)
        end
        function CT_Trans.release(part, who)
            if not part then return end
            local c = claims[part]
            if not c then return end
            c[who] = nil
            if next(c) == nil then claims[part] = nil end
            if part.Parent then resolve(part) end
        end
    end

    -- RAINBOW TOOLS
    do
        local SPEED = 0.35
        local SPREAD = 0.035
        local UPDATE_STEP = 1 / 40
        local enabled  = false
        local tracked  = setmetatable({}, { __mode = "k" })
        local watchers = setmetatable({}, { __mode = "k" })
        local unregister
        local function classify(d)
            if d:IsA("MeshPart") then
                return { obj = d, kind = "part", props = { "Color", "Material", "TextureID" }, clearTexture = "TextureID" }
            elseif d:IsA("BasePart") then
                return { obj = d, kind = "part", props = { "Color", "Material" } }
            elseif d:IsA("SurfaceAppearance") then
                return { obj = d, kind = "surface", props = { "Parent" } }
            elseif d:IsA("Decal") or d:IsA("Texture") then
                return { obj = d, kind = "decal", props = {} }
            elseif d:IsA("SpecialMesh") then
                return { obj = d, kind = "vector", prop = "VertexColor", props = { "VertexColor", "TextureId" }, clearTexture = "TextureId" }
            elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
                return { obj = d, kind = "sequence", prop = "Color", props = { "Color" } }
            elseif d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then
                return { obj = d, kind = "color", prop = "Color", props = { "Color" } }
            elseif d:IsA("Highlight") then
                return { obj = d, kind = "color", prop = "FillColor", props = { "FillColor" } }
            end
            return nil
        end
        local function snapshot(node)
            node.original = {}
            for _, prop in ipairs(node.props) do
                local ok, val = pcall(function() return node.obj[prop] end)
                if ok then node.original[prop] = val end
            end
        end
        local function restoreNode(node)
            if node.kind == "decal" then CT_Trans.release(node.obj, "rainbow") end
            if not node.original then return end
            for prop, val in pairs(node.original) do pcall(function() node.obj[prop] = val end) end
        end
        local function applyOnce(node)
            if node.kind == "surface" then pcall(function() node.obj.Parent = nil end)
            elseif node.kind == "decal" then CT_Trans.claim(node.obj, "rainbow", 1)
            elseif node.clearTexture then pcall(function() node.obj[node.clearTexture] = "" end) end
        end
        local function addNode(entry, d)
            local node = classify(d)
            if not node then return end
            snapshot(node)
            applyOnce(node)
            if node.kind == "part" then table.insert(entry.parts, node)
            elseif node.kind == "surface" or node.kind == "decal" then table.insert(entry.statics, node)
            else table.insert(entry.effects, node) end
        end
        local function register(root)
            if tracked[root] then return end
            local entry = { parts = {}, effects = {}, statics = {}, conns = {} }
            tracked[root] = entry
            for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
            if root:IsA("BasePart") then addNode(entry, root) end
            table.insert(entry.conns, root.DescendantAdded:Connect(function(d) addNode(entry, d) end))
            table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
                if not parent then unregister(root, false) end
            end))
        end
        function unregister(root, doRestore)
            local entry = tracked[root]
            if not entry then return end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
            if doRestore then
                for _, node in ipairs(entry.parts)   do restoreNode(node) end
                for _, node in ipairs(entry.effects) do restoreNode(node) end
                for _, node in ipairs(entry.statics) do restoreNode(node) end
            end
            tracked[root] = nil
        end
        local function tryRegister(inst)
            if not enabled then return end
            if ctMatchItem(inst) then register(inst) end
        end
        local function unwatch(container)
            local conns = watchers[container]
            if not conns then return end
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            watchers[container] = nil
        end
        local function watch(container)
            if not container or watchers[container] then return end
            watchers[container] = { container.ChildAdded:Connect(tryRegister) }
            for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
        end
        local function watchAll()
            watch(LP:FindFirstChildOfClass("Backpack"))
            watch(LP.Character)
        end
        LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)
        LP.CharacterAdded:Connect(function(char)
            for root in pairs(tracked) do unregister(root, false) end
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function() if enabled then watchAll() end end)
        end)
        local acc = 0
        RunService.Heartbeat:Connect(function(dt)
            if not enabled then return end
            if next(tracked) == nil then return end
            acc = acc + dt
            if acc < UPDATE_STEP then return end
            acc = 0
            local baseHue = (tick() * SPEED) % 1
            for _, entry in pairs(tracked) do
                for i, node in ipairs(entry.parts) do
                    local part = node.obj
                    if part.Parent then
                        pcall(function()
                            part.Color = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1)
                        end)
                    end
                end
                for i, node in ipairs(entry.effects) do
                    if node.obj.Parent then
                        local col = Color3.fromHSV((baseHue + (i - 1) * SPREAD) % 1, 1, 1)
                        if node.kind == "sequence" then
                            pcall(function() node.obj[node.prop] = ColorSequence.new(col) end)
                        elseif node.kind == "vector" then
                            pcall(function() node.obj[node.prop] = Vector3.new(col.R, col.G, col.B) end)
                        else
                            pcall(function() node.obj[node.prop] = col end)
                        end
                    end
                end
            end
        end)
        _G.RaptureRainbowTools = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                if on then watchAll()
                else
                    for root in pairs(tracked) do unregister(root, true) end
                    for container in pairs(watchers) do unwatch(container) end
                end
                if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
            end,
            isEnabled = function() return enabled end,
        }
    end

    -- TRANSPARENT TOOLS
    do
        local TRANSPARENCY = 0.5
        local enabled  = false
        local tracked  = setmetatable({}, { __mode = "k" })
        local watchers = setmetatable({}, { __mode = "k" })
        local unregister
        local function canTouch(d)
            if not d:IsA("BasePart") then return false end
            local base = CT_Trans.getBaseline(d)
            if base == nil or base >= 1 then return false end
            return true
        end
        local function addNode(entry, d)
            if not canTouch(d) then return end
            if entry.seen[d] then return end
            entry.seen[d] = true
            table.insert(entry.parts, { obj = d })
            CT_Trans.claim(d, "transparent", TRANSPARENCY)
        end
        local function register(root)
            if tracked[root] then return end
            local entry = { parts = {}, seen = {}, conns = {} }
            tracked[root] = entry
            for _, d in ipairs(root:GetDescendants()) do addNode(entry, d) end
            if root:IsA("BasePart") then addNode(entry, root) end
            table.insert(entry.conns, root.DescendantAdded:Connect(function(d) addNode(entry, d) end))
            table.insert(entry.conns, root.AncestryChanged:Connect(function(_, parent)
                if not parent then unregister(root, false) end
            end))
        end
        function unregister(root, doRestore)
            local entry = tracked[root]
            if not entry then return end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
            for _, node in ipairs(entry.parts) do CT_Trans.release(node.obj, "transparent") end
            tracked[root] = nil
        end
        local function tryRegister(inst)
            if not enabled then return end
            if ctMatchItem(inst) then register(inst) end
        end
        local function unwatch(container)
            local conns = watchers[container]
            if not conns then return end
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            watchers[container] = nil
        end
        local function watch(container)
            if not container or watchers[container] then return end
            watchers[container] = { container.ChildAdded:Connect(tryRegister) }
            for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
        end
        local function watchAll()
            watch(LP:FindFirstChildOfClass("Backpack"))
            watch(LP.Character)
        end
        LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)
        LP.CharacterAdded:Connect(function(char)
            for root in pairs(tracked) do unregister(root, false) end
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function() if enabled then watchAll() end end)
        end)
        _G.RaptureTransparentTools = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                if on then watchAll()
                else
                    for root in pairs(tracked) do unregister(root, true) end
                    for container in pairs(watchers) do unwatch(container) end
                end
                if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
            end,
            isEnabled = function() return enabled end,
        }
    end

    -- CUSTOM TOOLS
    do
        local ASSETS = _G.RaptureToolAssets
        _G.RaptureCustomToolSkins = _G.RaptureCustomToolSkins or { Bat = "DiamondSword", Medusa = "GoldenDesertEagle" }
        local function skinFor(cat)
            local key = _G.RaptureCustomToolSkins[cat]
            if key and ASSETS[key] and ASSETS[key].cat == cat then return key end
            return (cat == "Bat") and "DiamondSword" or "GoldenDesertEagle"
        end
        local enabled       = false
        local tracked       = setmetatable({}, { __mode = "k" })
        local watchers      = setmetatable({}, { __mode = "k" })
        local pendingHandle = setmetatable({}, { __mode = "k" })
        local teardown
        local function buildReplica(handle, mode)
            local existing = handle:FindFirstChild("LocalReplica")
            if existing then existing:Destroy() end
            local data = ASSETS[mode] or ASSETS.DiamondSword
            local m = Instance.new("Model")
            m.Name = "LocalReplica"
            local p = Instance.new("Part")
            p.Name        = "MainPart"
            p.CanCollide  = false
            p.CanQuery    = false
            p.CanTouch    = false
            p.Massless    = true
            p.Size        = Vector3.new(1, 1, 1)
            p.Transparency= 0
            p.Anchored    = false
            p.Parent      = m
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType  = Enum.MeshType.FileMesh
            mesh.MeshId    = data.mesh
            mesh.TextureId = data.tex
            mesh.Parent    = p
            local w = Instance.new("Motor6D")
            w.Part0 = handle
            w.Part1 = p
            mesh.Scale = data.scale
            w.C0 = data.c0
            w.Parent = p
            m.Parent = handle
            return m
        end
        local function hideNode(entry, d)
            if isReplicaStuff(d) then return end
            if d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture") then
                entry.hidden[d] = true
                CT_Trans.claim(d, "custom", 1)
            end
        end
        local function setupTool(tool)
            if tracked[tool] then return end
            local item = ctMatchItem(tool)
            if not item or item.key == "Medusa" then return end
            local handle = tool:FindFirstChild("Handle")
            if not handle then
                if pendingHandle[tool] then return end
                local c
                c = tool.ChildAdded:Connect(function(child)
                    if child.Name == "Handle" then
                        pcall(function() c:Disconnect() end)
                        pendingHandle[tool] = nil
                        if enabled then setupTool(tool) end
                    end
                end)
                pendingHandle[tool] = c
                return
            end
            local entry = { hidden = {}, conns = {} }
            tracked[tool] = entry
            for _, d in ipairs(tool:GetDescendants()) do hideNode(entry, d) end
            local mode = skinFor((item and item.key == "Bat") and "Bat" or "Medusa")
            entry.cat = (item and item.key == "Bat") and "Bat" or "Medusa"
            buildReplica(handle, mode)
            table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
                task.defer(function() if tracked[tool] then hideNode(entry, d) end end)
            end))
            table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
                if not parent then teardown(tool, false) end
            end))
        end
        function teardown(tool, doRestore)
            local entry = tracked[tool]
            if not entry then return end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
            local handle = tool:FindFirstChild("Handle")
            if handle then
                local rep = handle:FindFirstChild("LocalReplica")
                if rep then pcall(function() rep:Destroy() end) end
            end
            for obj in pairs(entry.hidden) do CT_Trans.release(obj, "custom") end
            entry.hidden = {}
            tracked[tool] = nil
        end
        local function tryRegister(inst)
            if not enabled then return end
            if inst:IsA("Tool") and ctMatchItem(inst) then setupTool(inst) end
        end
        local function unwatch(container)
            local conns = watchers[container]
            if not conns then return end
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            watchers[container] = nil
        end
        local function watch(container)
            if not container or watchers[container] then return end
            watchers[container] = { container.ChildAdded:Connect(tryRegister) }
            for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
        end
        local function watchAll()
            watch(LP:FindFirstChildOfClass("Backpack"))
            watch(LP.Character)
        end
        LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)
        LP.CharacterAdded:Connect(function(char)
            for tool in pairs(tracked) do teardown(tool, false) end
            for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
            table.clear(pendingHandle)
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function() if enabled then watchAll() end end)
        end)
        _G.RaptureCustomTools = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                if on then watchAll()
                else
                    for tool in pairs(tracked) do teardown(tool, true) end
                    for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                    table.clear(pendingHandle)
                    for container in pairs(watchers) do unwatch(container) end
                end
                if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
            end,
            isEnabled = function() return enabled end,
        }
        _G.RaptureSetCustomToolSkin = function(cat, key)
            if not ASSETS[key] or ASSETS[key].cat ~= cat then return end
            _G.RaptureCustomToolSkins[cat] = key
            for tool, entry in pairs(tracked) do
                if tool.Parent and entry.cat == cat then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then pcall(buildReplica, handle, key) end
                end
            end
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end
    end

    -- CUSTOM SOUNDS
    do
        local SOUNDS = {
            Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
        }
        local hooked = setmetatable({}, { __mode = "k" })
        local enabled       = false
        local tracked       = setmetatable({}, { __mode = "k" })
        local watchers      = setmetatable({}, { __mode = "k" })
        local pendingHandle = setmetatable({}, { __mode = "k" })
        local teardown
        local function playCustom(entry)
            local cs = entry.sound
            if not cs or not cs.Parent then return end
            local d = entry.data
            if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
            pcall(function() cs:Stop(); cs.TimePosition = d.skip or 0; cs.Volume = 1; cs:Play() end)
            if d.doublePlay and d.delay then
                entry.timer = task.delay(d.delay, function()
                    entry.timer = nil
                    if not enabled then return end
                    if cs and cs.Parent then
                        pcall(function() cs:Stop(); cs.TimePosition = d.skip or 0; cs.Volume = 1; cs:Play() end)
                    end
                end)
            end
        end
        local function hookSound(entry, snd)
            if not snd:IsA("Sound") then return end
            if snd.Name == "CustomSound" then return end
            if hooked[snd] then return end
            if entry.muted[snd] ~= nil then return end
            entry.muted[snd] = snd.Volume
            hooked[snd] = true
            local function trigger()
                if not enabled then return end
                if snd.Playing or snd.TimePosition > 0 then
                    pcall(function() snd.Volume = 0; snd:Stop() end)
                    playCustom(entry)
                end
            end
            local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
            local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
            table.insert(entry.conns, c1)
            table.insert(entry.conns, c2)
            local c3
            c3 = snd.AncestryChanged:Connect(function(_, parent)
                if parent then return end
                pcall(function() c1:Disconnect() end)
                pcall(function() c2:Disconnect() end)
                pcall(function() c3:Disconnect() end)
                hooked[snd] = nil
                entry.muted[snd] = nil
                if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
            end)
            table.insert(entry.conns, c3)
            if snd.Playing then trigger() end
        end
        local function setupTool(tool)
            if tracked[tool] then return end
            local item = ctMatchItem(tool)
            if not item then return end
            local data = SOUNDS[item.key]
            if not data then return end
            local handle = tool:FindFirstChild("Handle")
            if not handle then
                if pendingHandle[tool] then return end
                local c
                c = tool.ChildAdded:Connect(function(child)
                    if child.Name == "Handle" then
                        pcall(function() c:Disconnect() end)
                        pendingHandle[tool] = nil
                        if enabled then setupTool(tool) end
                    end
                end)
                pendingHandle[tool] = c
                return
            end
            local old = handle:FindFirstChild("CustomSound")
            if old then pcall(function() old:Destroy() end) end
            local cs = Instance.new("Sound")
            cs.Name        = "CustomSound"
            cs.SoundId     = data.id
            cs.Volume      = 1
            cs.Looped      = false
            cs.RollOffMode = Enum.RollOffMode.Inverse
            cs.MaxDistance = 1000
            cs.MinDistance = 1000
            cs.Parent      = handle
            local entry = { sound = cs, data = data, conns = {}, muted = {} }
            tracked[tool] = entry
            for _, d in ipairs(tool:GetDescendants()) do hookSound(entry, d) end
            table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
                if tracked[tool] then hookSound(entry, d) end
            end))
            table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
                if not parent then teardown(tool) end
            end))
        end
        function teardown(tool)
            local entry = tracked[tool]
            if not entry then return end
            if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
            for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
            if entry.sound then pcall(function() entry.sound:Destroy() end) end
            for snd, vol in pairs(entry.muted) do
                hooked[snd] = nil
                if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
            end
            tracked[tool] = nil
        end
        local function tryRegister(inst)
            if not enabled then return end
            if inst:IsA("Tool") and ctMatchItem(inst) then setupTool(inst) end
        end
        local function unwatch(container)
            local conns = watchers[container]
            if not conns then return end
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            watchers[container] = nil
        end
        local function watch(container)
            if not container or watchers[container] then return end
            watchers[container] = { container.ChildAdded:Connect(tryRegister) }
            for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
        end
        local function watchAll()
            watch(LP:FindFirstChildOfClass("Backpack"))
            watch(LP.Character)
        end
        LP.ChildAdded:Connect(function(child)
            if enabled and child:IsA("Backpack") then watch(child) end
        end)
        LP.CharacterAdded:Connect(function(char)
            for tool in pairs(tracked) do teardown(tool) end
            for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
            table.clear(pendingHandle)
            for container in pairs(watchers) do unwatch(container) end
            if not enabled then return end
            watch(char)
            task.defer(function() if enabled then watchAll() end end)
        end)
        _G.RaptureCustomSounds = {
            setEnabled = function(on)
                on = on and true or false
                enabled = on
                if on then watchAll()
                else
                    for tool in pairs(tracked) do teardown(tool) end
                    for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                    table.clear(pendingHandle)
                    for container in pairs(watchers) do unwatch(container) end
                end
                if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
            end,
            isEnabled = function() return enabled end,
        }
    end
end

-- ============================================================
-- Infinite Jump
-- ============================================================
local InfiniteJump = {
    enabled = false,
    jumpPower = 55,
    minVelocity = 30,
    jumpConn = nil,
    heartbeatConn = nil,
}

local function applyJump(root)
    if not root then return end
    pcall(function()
        root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z)
    end)
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end

local function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then
        applyJump(root)
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
end

InfiniteJump.start()

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode or autoCarrySpeedActive then return CS
    else return NS end
end

local CARRY_STATE_NAMES = {
    carry = true, carrying = true, iscarrying = true, hascarry = true,
    carryactive = true, carystate = true, carryingbrainrot = true,
    iscarryingbrainrot = true, hasbrainrot = true, holding = true,
    isholding = true, holdingbrainrot = true, carried = true,
}

local function normalizedCarryName(name)
    return string.lower(tostring(name or "")):gsub("[^%w]", "")
end

local function carryValueIsActive(name, value)
    if not CARRY_STATE_NAMES[normalizedCarryName(name)] then return false end
    if type(value) == "boolean" then return value end
    if type(value) == "number" then return value > 0 end
    if type(value) == "string" then
        local text = string.lower(value)
        return text == "true" or text == "yes" or text == "1"
            or text == "carrying" or text == "holding" or text == "active"
    end
    return false
end

local function hasAutoCarryState()
    local character = LP.Character
    for _, container in ipairs({LP, character}) do
        if container then
            for name, value in pairs(container:GetAttributes()) do
                if carryValueIsActive(name, value) then return true end
            end
            for _, object in ipairs(container:GetDescendants()) do
                if object:IsA("BoolValue") or object:IsA("IntValue") or object:IsA("NumberValue") or object:IsA("StringValue") then
                    if carryValueIsActive(object.Name, object.Value) then return true end
                elseif (object:IsA("Tool") or object:IsA("Model")) then
                    local objectName = normalizedCarryName(object.Name)
                    if objectName == "brainrot" or objectName == "carriedbrainrot" then return true end
                elseif object:IsA("ObjectValue") and CARRY_STATE_NAMES[normalizedCarryName(object.Name)] and object.Value then
                    return true
                end
            end
        end
    end
    return false
end

function startAutoCarry()
    autoCarryEnabled = true
    if autoCarryConn then autoCarryConn:Disconnect(); autoCarryConn = nil end
    local elapsed = 0
    autoCarryConn = RunService.Heartbeat:Connect(function(dt)
        if not autoCarryEnabled then return end
        elapsed = elapsed + dt
        if elapsed < 0.2 then return end
        elapsed = 0
        local ok, carrying = pcall(hasAutoCarryState)
        local active = ok and carrying == true
        if active ~= autoCarrySpeedActive then
            autoCarrySpeedActive = active
            refreshSpeedModeLabel()
        end
    end)
end

function stopAutoCarry()
    autoCarryEnabled = false
    if autoCarryConn then autoCarryConn:Disconnect(); autoCarryConn = nil end
    autoCarrySpeedActive = false
    refreshSpeedModeLabel()
end

local _velChecked = {}
local _hookedVelParts = {}

local function _setupVelChecked(char)
    _velChecked = {}
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then _velChecked[hrp] = true end
    return hrp
end

local _hookVelSupported = nil
local function _hookVelHRP(hrp)
    if not hrp or _hookedVelParts[hrp] then return end
    if _hookVelSupported == false then return end
    if _hookVelSupported == nil then
        _hookVelSupported = (type(getrawmetatable) == "function")
            and (type(setreadonly) == "function")
            and (type(newcclosure) == "function")
            and (type(checkcaller) == "function")
    end
    if not _hookVelSupported then return end
    _hookedVelParts[hrp] = true
    local ok = pcall(function()
        local mt = getrawmetatable(hrp)
        if not mt then return end
        setreadonly(mt, false)
        local originalVelIndex = rawget(mt, "__index")
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and _velChecked[self]
               and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real
                if type(originalVelIndex) == "function" then
                    real = originalVelIndex(self, key)
                elseif type(originalVelIndex) == "table" then
                    real = originalVelIndex[key]
                end
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            if type(originalVelIndex) == "function" then
                return originalVelIndex(self, key)
            elseif type(originalVelIndex) == "table" then
                return originalVelIndex[key]
            end
        end)
        setreadonly(mt, true)
    end)
    if not ok then _hookVelSupported = false end
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

local function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if autoBatEnabled then return end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then return end
    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, vy, unit.Z * speed)
        _G.__RaptureLiveSpeed = { t = os.clock(), v = speed }
    else
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(0, vy, 0)
    end
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    TPBat        = {kb = Enum.KeyCode.V, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
    BatBypass    = {kb = Enum.KeyCode.B, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    TPBat        = {kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
    BatBypass    = {kb = DEFAULT_KB.BatBypass.kb, gp = DEFAULT_KB.BatBypass.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
}

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    Data = {}
}

local isStealing = false
local autoGrabSetDelayRadius = 9
local stealConnection = nil

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if not Steal.AutoStealEnabled then return end
    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
    end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
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
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
    local pauseRatio = (stealMode == "V2") and (V2_STOP_PERCENT / 100) or (NORMAL_STOP_PERCENT / 100)
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local startTime = _tick()
        local duration = Steal.StealDuration
        local stopTime = duration * pauseRatio
        local promptFired = false
        local phase = 1
        local phase2Start = 0
        local phase2Timeout = math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
        while isStealing and Steal.AutoStealEnabled and phase == 1 do
            local elapsed = _tick() - startTime
            if elapsed >= stopTime then
                phase = 2; phase2Start = _tick(); break
            end
            local progress = _clamp(elapsed / duration, 0, pauseRatio)
            if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
            if not prompt.Parent or not prompt.Parent.Parent then break end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
            task.wait()
        end
        if phase == 2 then
            if progressFill then progressFill.Size = UDim2.new(pauseRatio, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(pauseRatio * 100) .. "%" end
        end
        while isStealing and Steal.AutoStealEnabled and phase == 2 do
            if _tick() - phase2Start >= phase2Timeout then
                if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                if progressPct then progressPct.Text = "0%" end
                data.ready = true; isStealing = false
                task.wait()
                local newPrompt, newName = findNearestPrompt()
                if newPrompt then executeSteal(newPrompt, newName) end
                return
            end
            if not prompt.Parent or not prompt.Parent.Parent then
                isStealing = false
                if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                if progressPct then progressPct.Text = "0%" end
                data.ready = true
                return
            end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                if dist <= autoGrabSetDelayRadius then phase = 3; break
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
        if isStealing and Steal.AutoStealEnabled and phase == 3 then
            local fillStart = _tick()
            local fillDuration = math.max(duration - stopTime, 0.05)
            while true do
                local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                local totalProgress = pauseRatio + fp * (1 - pauseRatio)
                if fp >= 1 then totalProgress = 1 end
                if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
                if fp >= 1 and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end
        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        data.ready = true
        isStealing = false
    end)
end

function startAutoSteal()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            CONFIG.AUTO_STEAL_ENABLED = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function stopAutoSteal()
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then
        TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play()
    end
    if progressPct then progressPct.Text = "0%" end
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08
tpBatFloatingButton = nil

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil, medusaAuto = nil, noPlayerCol = nil}
keyButtonRefs = {}
progressFill = nil
stealBarImage = nil
progressPct = nil
pbFrame = nil
speedLabel = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox, progressBarScaleBox = nil, nil, nil, nil, nil, nil, nil, nil
stretchValueBox = nil
medusaRadiusBox = nil
medusaDelayBox = nil
setJumpToggleState = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAutoMedusaVisual, setRagdollTimerVisual = nil, nil
setAntiRagVisual, setJumpVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil
setESPVisual, setAntiLagVisual = nil, nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
main, gui = nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
batBypassFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
pbScale = nil
tabButtons = {}
contentPages = {}
currentTab = "Speed"
lockBtn = nil
fpsLabel = nil
msLabel = nil
ragdollCountdownLabel = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (entry.kb == kc or (entry.gp and kc == entry.gp))
end

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = _V3zero
    end)
end

function saveSkipIntroSetting() end

function setSkipIntro(enabled)
    skipIntroEnabled = true
    saveAllSettings()
end

-- ============================================================
-- ANTI RAGDOLL V1/V2
-- ============================================================
local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1

local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16

local stateV1 = {
    active = false,
    isBoosting = false,
    cachedChar = nil,
    ragdollConnections = {},
}

local function disconnectAllV1()
    for _, conn in ipairs(stateV1.ragdollConnections) do
        pcall(function() conn:Disconnect() end)
    end
    stateV1.ragdollConnections = {}
end

local function cacheCharacterV1()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    stateV1.cachedChar = { character = char, humanoid = hum, root = root }
    return true
end

local function isRagdolledV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end
    local hum = stateV1.cachedChar.humanoid
    local st = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    return ragdollStates[st] or false
end

local function forceExitRagdollV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end
    local hum = stateV1.cachedChar.humanoid
    local root = stateV1.cachedChar.root
    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    for _, descendant in ipairs(stateV1.cachedChar.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            descendant:Destroy()
        end
    end
    if not stateV1.isBoosting then
        stateV1.isBoosting = true
        hum.WalkSpeed = BOOST_SPEED
    end
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
end

local function heartbeatLoopV1()
    while stateV1.active do
        task.wait()
        if isRagdolledV1() then
            forceExitRagdollV1()
        elseif stateV1.isBoosting and not isRagdolledV1() then
            stateV1.isBoosting = false
            if stateV1.cachedChar and stateV1.cachedChar.humanoid then
                stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
            end
        end
    end
end

function AntiRagdollV1.start()
    if stateV1.active then return end
    AntiRagdollV1.stop()
    if not cacheCharacterV1() then return end
    stateV1.active = true
    stateV1.isBoosting = false
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then
            cam.CameraSubject = stateV1.cachedChar.humanoid
        end
    end)
    table.insert(stateV1.ragdollConnections, camConn)
    local respawnConn = LP.CharacterAdded:Connect(function()
        stateV1.isBoosting = false
        task.wait(0.5)
        cacheCharacterV1()
    end)
    table.insert(stateV1.ragdollConnections, respawnConn)
    task.spawn(heartbeatLoopV1)
end

function AntiRagdollV1.stop()
    stateV1.active = false
    if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
        stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    stateV1.isBoosting = false
    disconnectAllV1()
    stateV1.cachedChar = nil
end

function AntiRagdollV1.isRunning() return stateV1.active end

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
                    root.AssemblyAngularVelocity = _V3zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdollEnabled(enabled)
    antiRagdollEnabled = enabled
    if enabled then
        if antiRagdollVersion == "v1" then AntiRagdollV1.start()
        elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end
    else
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    end
    saveAllSettings()
end

function setAntiRagdollVersion(version)
    antiRagdollVersion = version
    if antiRagdollEnabled then
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if version == "v1" then AntiRagdollV1.start()
        elseif version == "v2" then startAntiRagdollV2() end
    end
    saveAllSettings()
end

-- ============================================================
-- MEDUSA COUNTER
-- ============================================================
function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

-- ============================================================
-- ESP
-- ============================================================
local function espCreateGlow(plr)
    local old = workspace:FindFirstChild("RaptureESPGlow_" .. tostring(plr.UserId))
    if old then old:Destroy() end
    local glow = Instance.new("Part")
    glow.Name = "RaptureESPGlow_" .. tostring(plr.UserId)
    glow.Shape = Enum.PartType.Ball
    glow.Size = Vector3.new(0.65, 0.65, 0.65)
    glow.Anchored = true
    glow.CanCollide = false
    glow.CanTouch = false
    glow.CanQuery = false
    glow.CastShadow = false
    glow.Material = Enum.Material.SmoothPlastic
    glow.Color = getThemeColor()
    glow.Transparency = 0.05
    glow.CFrame = CFrame.new(0, -10000, 0)
    glow.Parent = workspace
    local light = Instance.new("PointLight", glow)
    light.Color = getThemeColor()
    light.Brightness = 2.5
    light.Range = 9
    light.Shadows = false
    return glow
end

local function espCreateBox(char)
    if not char then return end
    local old = char:FindFirstChild("RaptureESPBox")
    if old then old:Destroy() end
    local h = Instance.new("Highlight")
    h.Name = "RaptureESPBox"
    h.Adornee = char
    h.FillColor = getThemeColor()
    h.OutlineColor = Color3.fromRGB(0, 0, 0)
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0.1
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = char
    return h
end

local function espCreateBillboard(plr, char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("RaptureESPAvatar")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "RaptureESPAvatar"
    bb.Size = UDim2.new(0, 80, 0, 60)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head
    local container = Instance.new("Frame", bb)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    local name = Instance.new("TextLabel", container)
    name.Size = UDim2.new(1, 0, 0, 20)
    name.Position = UDim2.new(0, 0, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = plr.DisplayName or plr.Name
    name.TextColor3 = getThemeColor()
    name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    name.TextStrokeTransparency = 0.3
    name.Font = Enum.Font.GothamBold
    name.TextSize = 12
    return bb
end

function startESP()
    if espConn then return end
    espEnabled = true
    local function setupPlayer(plr)
        if plr == LP then return end
        if espHighlightCache[plr] then return end
        local char = plr.Character
        if char then
            espBillboardCache[plr] = espCreateBillboard(plr, char)
            espHighlightCache[plr] = espCreateBox(char)
        end
        espGlowCache[plr] = espCreateGlow(plr)
    end
    local function removePlayer(plr)
        if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end); espBillboardCache[plr] = nil end
        if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end); espHighlightCache[plr] = nil end
        if espGlowCache[plr] then pcall(function() espGlowCache[plr]:Destroy() end); espGlowCache[plr] = nil end
    end
    for _, plr in ipairs(Players:GetPlayers()) do setupPlayer(plr) end
    Conns.espAdded = Players.PlayerAdded:Connect(setupPlayer)
    Conns.espRemoving = Players.PlayerRemoving:Connect(removePlayer)
    Conns.espCharAdded = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(Conns.espCharAdded, plr.CharacterAdded:Connect(function(char)
                task.wait(0.3)
                if espEnabled then
                    if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) end
                    if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) end
                    espBillboardCache[plr] = espCreateBillboard(plr, char)
                    espHighlightCache[plr] = espCreateBox(char)
                end
            end))
        end
    end
    espConn = RunService.RenderStepped:Connect(function()
        if not espEnabled then return end
        local accent = getThemeColor()
        for plr, glow in pairs(espGlowCache) do
            if glow and glow.Parent then
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    glow.Color = accent
                    glow.CFrame = CFrame.new(hrp.Position - Vector3.new(0, (hrp.Size.Y * 0.5) + 2.35, 0))
                    local light = glow:FindFirstChildOfClass("PointLight")
                    if light then light.Color = accent end
                else
                    glow.CFrame = CFrame.new(0, -10000, 0)
                end
            end
        end
        for plr, hl in pairs(espHighlightCache) do
            if hl and hl.Parent then hl.FillColor = accent end
        end
        for plr, billboard in pairs(espBillboardCache) do
            if billboard and billboard.Parent then
                local container = billboard:FindFirstChild("Frame")
                if container then
                    local nameLbl = container:FindFirstChild("TextLabel")
                    if nameLbl then nameLbl.TextColor3 = accent end
                end
            end
        end
    end)
end

function stopESP()
    espEnabled = false
    if espConn then espConn:Disconnect(); espConn = nil end
    if Conns.espAdded then Conns.espAdded:Disconnect(); Conns.espAdded = nil end
    if Conns.espRemoving then Conns.espRemoving:Disconnect(); Conns.espRemoving = nil end
    if Conns.espCharAdded then
        for _, c in ipairs(Conns.espCharAdded) do pcall(function() c:Disconnect() end) end
        Conns.espCharAdded = {}
    end
    for plr in pairs(espBillboardCache) do pcall(function() espBillboardCache[plr]:Destroy() end) end
    for plr in pairs(espHighlightCache) do pcall(function() espHighlightCache[plr]:Destroy() end) end
    for plr in pairs(espGlowCache) do pcall(function() espGlowCache[plr]:Destroy() end) end
    espBillboardCache = {}
    espHighlightCache = {}
    espGlowCache = {}
end

-- ============================================================
-- ANTI LAG
-- ============================================================
local _isUnderPlots = function(obj)
    local p = obj
    while p and p ~= workspace do
        if p.Name == "Plots" then return true end
        p = p.Parent
    end
    return false
end

local _alStore = {
    brightness=nil, clockTime=nil, ambient=nil, outdoorAmbient=nil,
    globalShadows=nil, fogEnd=nil, fogStart=nil, fogColor=nil,
    colorCorrection=nil, bloom=nil, blur=nil, sunRays=nil, dof=nil,
    particleList={}, partList={}, lightList={}, hatList={}, destroyed={},
    charStrips={},
}

local function _alClearStore()
    _alStore = {
        brightness=nil, clockTime=nil, ambient=nil, outdoorAmbient=nil,
        globalShadows=nil, fogEnd=nil, fogStart=nil, fogColor=nil,
        colorCorrection=nil, bloom=nil, blur=nil, sunRays=nil, dof=nil,
        particleList={}, partList={}, lightList={}, hatList={}, destroyed={},
        charStrips={},
    }
end

local function _alStripChar(char)
    if not char or char == LP.Character then return end
    if _alStore.charStrips[char] then return end    _alStore.charStrips[char] = true
    pcall(function()
        for _, acc in ipairs(char:GetChildren()) do
            if acc:IsA("Accessory") or acc:IsA("Clothing") or acc:IsA("Shirt")
               or acc:IsA("Pants") or acc:IsA("ShirtGraphic") or acc:IsA("BodyColors") then
                acc:Destroy()
            end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local shirt = hum:FindFirstChild("Shirt"); if shirt then shirt:Destroy() end
            local pants = hum:FindFirstChild("Pants"); if pants then pants:Destroy() end
            local tshirt = hum:FindFirstChild("TShirt"); if tshirt then tshirt:Destroy() end
            hum.AutoRotate = false
            hum.PlatformStand = true
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            local anim = char:FindFirstChild("Animate")
            if anim then anim:Destroy() end
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CastShadow = false
                part.Material = Enum.Material.Plastic
                part.Reflectance = 0
                if part:IsA("MeshPart") then
                    pcall(function() part.RenderFidelity = Enum.RenderFidelity.Performance end)
                    part.DoubleSided = false
                end
            end
        end
    end)
end

local function _alDerender(obj)
    if not obj then return end
    if _isUnderPlots(obj) then return end
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = obj:FindFirstAncestorOfClass("Model")
            if char and Players:GetPlayerFromCharacter(char) then
                local parent = obj.Parent
                table.insert(_alStore.hatList, { obj = obj, parent = parent })
                obj.Parent = nil
            end
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
            table.insert(_alStore.particleList, { obj = obj, enabled = obj.Enabled })
            obj.Enabled = false
        elseif obj:IsA("Light") then
            table.insert(_alStore.lightList, { obj = obj, shadows = obj.Shadows, enabled = obj.Enabled })
            obj.Shadows = false
            if obj:IsA("PointLight") or obj:IsA("SpotLight") then
                obj.Enabled = false
            end
        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
            table.insert(_alStore.partList, {
                obj = obj,
                castShadow = obj.CastShadow,
                material = obj.Material,
                reflectance = obj.Reflectance,
            })
            obj.CastShadow = false
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            if obj:IsA("MeshPart") then
                pcall(function() obj.RenderFidelity = Enum.RenderFidelity.Performance end)
                obj.DoubleSided = false
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic")
            or obj:IsA("SurfaceAppearance") or obj:IsA("BodyColors") then
            table.insert(_alStore.destroyed, obj)
            obj:Destroy()
        elseif obj:IsA("SpecialMesh") then
            obj.TextureId = ""
        end
    end)
end

function enableAntiLag()
    antiLagEnabled = true
    _alClearStore()
    pcall(function() setfpscap(1e9) end)
    pcall(function() sethiddenproperty(game, "RenderFidelity", Enum.RenderFidelity.Performance) end)
    pcall(function() sethiddenproperty(game, "RenderQuality", 0) end)
    pcall(function() sethiddenproperty(game, "TextureQuality", Enum.TextureQuality.Performance) end)
    pcall(function() sethiddenproperty(Lighting, "Technology", Enum.Technology.Legacy) end)

    local L = Lighting
    _alStore.brightness = L.Brightness
    _alStore.clockTime = L.ClockTime
    _alStore.ambient = L.Ambient
    _alStore.outdoorAmbient = L.OutdoorAmbient
    _alStore.globalShadows = L.GlobalShadows
    _alStore.fogEnd = L.FogEnd
    _alStore.fogStart = L.FogStart
    _alStore.fogColor = L.FogColor

    for _, e in ipairs(L:GetChildren()) do
        pcall(function()
            if e:IsA("BloomEffect") then
                _alStore.bloom = { enabled = e.Enabled, intensity = e.Intensity, size = e.Size, threshold = e.Threshold }
                e.Enabled = false
            elseif e:IsA("BlurEffect") then
                _alStore.blur = { enabled = e.Enabled, size = e.Size }
                e.Enabled = false
            elseif e:IsA("SunRaysEffect") then
                _alStore.sunRays = { enabled = e.Enabled, intensity = e.Intensity, spread = e.Spread }
                e.Enabled = false
            elseif e:IsA("DepthOfFieldEffect") then
                _alStore.dof = {
                    enabled = e.Enabled, farIntensity = e.FarIntensity,
                    focusDistance = e.FocusDistance, inFocusRadius = e.InFocusRadius,
                    nearIntensity = e.NearIntensity,
                }
                e.Enabled = false
            elseif e:IsA("ColorCorrectionEffect") then
                _alStore.colorCorrection = {
                    enabled = e.Enabled, brightness = e.Brightness, contrast = e.Contrast,
                    saturation = e.Saturation, tintColor = e.TintColor,
                }
                e.Enabled = false
            end
        end)
    end

    L.GlobalShadows = false
    L.FogEnd = 1e10
    L.FogStart = 1e10
    L.Brightness = 1

    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        pcall(function() sethiddenproperty(terrain, "Decoration", false) end)
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        for _, dec in ipairs(terrain:GetDescendants()) do
            if dec:IsA("Decal") or dec:IsA("Texture") or dec:IsA("TerrainDetail") then
                pcall(function() dec:Destroy() end)
            end
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        _alDerender(obj)
    end

    for _, light in ipairs(workspace:GetDescendants()) do
        if light:IsA("Light") then
            pcall(function()
                light.Shadows = false
                if light:IsA("PointLight") or light:IsA("SpotLight") then light.Enabled = false end
            end)
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then _alStripChar(plr.Character) end
    end

    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if not antiLagEnabled then return end
        if _isUnderPlots(obj) then return end
        _alDerender(obj)
    end)

    if _alStore.playerAddedConn then _alStore.playerAddedConn:Disconnect() end
    _alStore.playerAddedConn = Players.PlayerAdded:Connect(function(plr)
        if plr == LP then return end
        plr.CharacterAdded:Connect(function(char)
            if antiLagEnabled then task.wait(0.5); _alStripChar(char) end
        end)
        if plr.Character and antiLagEnabled then _alStripChar(plr.Character) end
    end)
end

function disableAntiLag()
    if not antiLagEnabled then return end
    antiLagEnabled = false
    if antiLagDescConn then antiLagDescConn:Disconnect(); antiLagDescConn = nil end
    if _alStore.playerAddedConn then _alStore.playerAddedConn:Disconnect(); _alStore.playerAddedConn = nil end
    local s = _alStore
    pcall(function() setfpscap(240) end)
    pcall(function()
        local L = Lighting
        if s.brightness ~= nil then L.Brightness = s.brightness end
        if s.clockTime ~= nil then L.ClockTime = s.clockTime end
        if s.ambient ~= nil then L.Ambient = s.ambient end
        if s.outdoorAmbient ~= nil then L.OutdoorAmbient = s.outdoorAmbient end
        if s.globalShadows ~= nil then L.GlobalShadows = s.globalShadows end
        if s.fogEnd ~= nil then L.FogEnd = s.fogEnd end
        if s.fogStart ~= nil then L.FogStart = s.fogStart end
        if s.fogColor ~= nil then L.FogColor = s.fogColor end
    end)
    pcall(function()
        local L = Lighting
        if s.colorCorrection then
            local cc = L:FindFirstChildOfClass("ColorCorrectionEffect")
            if cc then
                cc.Enabled = s.colorCorrection.enabled
                cc.Brightness = s.colorCorrection.brightness
                cc.Contrast = s.colorCorrection.contrast
                cc.Saturation = s.colorCorrection.saturation
                cc.TintColor = s.colorCorrection.tintColor
            end
        end
        if s.bloom then
            local bl = L:FindFirstChildOfClass("BloomEffect")
            if bl then
                bl.Enabled = s.bloom.enabled
                bl.Intensity = s.bloom.intensity
                bl.Size = s.bloom.size
                bl.Threshold = s.bloom.threshold
            end
        end
        if s.blur then
            local br = L:FindFirstChildOfClass("BlurEffect")
            if br then br.Enabled = s.blur.enabled; br.Size = s.blur.size end
        end
        if s.sunRays then
            local sr = L:FindFirstChildOfClass("SunRaysEffect")
            if sr then
                sr.Enabled = s.sunRays.enabled
                sr.Intensity = s.sunRays.intensity
                sr.Spread = s.sunRays.spread
            end
        end
        if s.dof then
            local dof = L:FindFirstChildOfClass("DepthOfFieldEffect")
            if dof then
                dof.Enabled = s.dof.enabled
                dof.FarIntensity = s.dof.farIntensity
                dof.FocusDistance = s.dof.focusDistance
                dof.InFocusRadius = s.dof.inFocusRadius
                dof.NearIntensity = s.dof.nearIntensity
            end
        end
    end)
    for _, entry in ipairs(s.hatList or {}) do
        pcall(function()
            if entry.obj and entry.obj.Parent == nil and entry.parent then entry.obj.Parent = entry.parent end
        end)
    end
    for _, entry in ipairs(s.particleList or {}) do
        pcall(function()
            if entry.obj and entry.obj.Parent then entry.obj.Enabled = entry.enabled end
        end)
    end
    for _, entry in ipairs(s.lightList or {}) do
        pcall(function()
            if entry.obj and entry.obj.Parent then
                entry.obj.Shadows = entry.shadows
                entry.obj.Enabled = entry.enabled
            end
        end)
    end
    for _, entry in ipairs(s.partList or {}) do
        pcall(function()
            if entry.obj and entry.obj.Parent then
                entry.obj.CastShadow = entry.castShadow
                entry.obj.Material = entry.material
                entry.obj.Reflectance = entry.reflectance
            end
        end)
    end
    _alClearStore()
end

-- ============================================================
-- SPEED INDICATOR
-- ============================================================
function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("RaptureDuelSpeedIndicator")
    if oldBB then oldBB:Destroy() end

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "RaptureDuelSpeedIndicator"
    bb.Size = UDim2.new(0, 220, 0, 58)
    bb.StudsOffset = _V3new(0, 3.6, 0)
    bb.AlwaysOnTop = true

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, 0, 0, 28)
    speedLabel.Position = UDim2.new(0, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: " .. string.format("%.1f", getActiveMoveSpeed())
    speedLabel.TextColor3 = getThemeColor()
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextScaled = true
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.ZIndex = 5

    ragdollCountdownLabel = Instance.new("TextLabel", bb)
    ragdollCountdownLabel.Name = "RagdollCountdown"
    ragdollCountdownLabel.Size = UDim2.new(1, 0, 0, 26)
    ragdollCountdownLabel.Position = UDim2.new(0, 0, 0, 30)
    ragdollCountdownLabel.BackgroundTransparency = 1
    ragdollCountdownLabel.Text = ""
    ragdollCountdownLabel.Visible = false
    ragdollCountdownLabel.TextColor3 = getThemeColor()
    ragdollCountdownLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    ragdollCountdownLabel.TextStrokeTransparency = 0
    ragdollCountdownLabel.Font = Enum.Font.GothamBlack
    ragdollCountdownLabel.TextSize = 22
    ragdollCountdownLabel.TextXAlignment = Enum.TextXAlignment.Center
    ragdollCountdownLabel.ZIndex = 10
    ragdollCountdownLabel.Parent = bb

end

local unwalkSavedAnimate = nil
unwalkEnabled = false

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
end

function toggleCarryMode()
    if speedMode then speedMode = false
    else speedMode = true; laggerToggled = false; laggerCarryToggled = false end
    resetMovementState()
    saveAllSettings()
end

function toggleLaggerMode()
    if laggerToggled then laggerToggled = false
    else laggerToggled = true; speedMode = false; laggerCarryToggled = false end
    resetMovementState()
    saveAllSettings()
end

function toggleLaggerCarryMode()
    if laggerCarryToggled then laggerCarryToggled = false
    else laggerCarryToggled = true; speedMode = false; laggerToggled = false end
    resetMovementState()
    saveAllSettings()
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false; laggerToggled = true; laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false; laggerToggled = false; laggerCarryToggled = true
    else
        speedMode = true; laggerToggled = false; laggerCarryToggled = false
    end
    resetMovementState()
    saveAllSettings()
end

-- ============================================================
-- AUTO LEFT / RIGHT
-- ============================================================
function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false; stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false; stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

-- ============================================================
-- AIMBOT V1
-- ============================================================
function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

function stopAimbotAdapt()
    if _aimbotConn then
        pcall(function() _aimbotConn:Disconnect() end)
        _aimbotConn = nil
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = _V3new(0, -0.1, 0)
        root.AssemblyAngularVelocity = _V3zero
    end
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
end

function startAimbotAdapt()
    if _aimbotConn then return end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local myPos = root.Position
        local targetPos = target.Position
        local targetVel = target.AssemblyLinearVelocity
        local speedMult, predictAmount, heightOffset
        if aimbotMode == "V2" then
            speedMult = BAT_AIMBOT_SPEED * 1.05
            predictAmount = 0.22
            heightOffset = 3.2
        else
            speedMult = BAT_AIMBOT_SPEED
            predictAmount = 0.14
            heightOffset = 3.7
        end
        local predictPos = targetPos + targetVel * predictAmount
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = _V3new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = _V3new(0,0,0) end
        local desiredHeight = targetPos.Y + heightOffset
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = _clamp(yVel, -70, 110)
        local desiredVel = _V3new(flatDir.X * speedMult, yVel, flatDir.Z * speedMult)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = _clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = _CFlookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = _clamp(rx, -2.5, 2.5)
            ry = _clamp(ry, -2.5, 2.5)
            rz = _clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(rx * 42, ry * 42, rz * 42))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then trySwing() end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function enableAutoBat()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

-- ============================================================
-- BAT AIMBOT V2
-- ============================================================
_G.RaptureBatAimbotV2State = _G.RaptureBatAimbotV2State or {
    conn = nil, hittingCooldown = false, lastSafeCFrame = nil,
    lastPosition = nil, lastSampleTime = 0,
}
_G.RaptureBatAimbotV2TPDistance = _G.RaptureBatAimbotV2TPDistance or 8

local BAT_V2_BYPASS_DISTANCE = _G.RaptureBatAimbotV2TPDistance or 8
local BAT_V2_CHASE_SPEED = 58
local BAT_V2_CHASE_HEIGHT = 3.7
local BAT_V2_CHASE_PREDICT = 0.14

local function _aimbotV2FindBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    return nil
end

local function _aimbotV2TrySwing()
    local S = _G.RaptureBatAimbotV2State
    if S.hittingCooldown then return end
    S.hittingCooldown = true
    pcall(function()
        local bat = _aimbotV2FindBat()
        if not bat then return end
        local char = LP.Character
        if bat.Parent ~= char then
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(bat) end) end
        end
        pcall(function() bat:Activate() end)
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then pcall(function() ev:FireServer() end) end
    end)
    task.delay(0.08, function()
        if _G.RaptureBatAimbotV2State then _G.RaptureBatAimbotV2State.hittingCooldown = false end
    end)
end

local function _aimbotV2GetClosest()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest, minDist
end

local function _aimbotV2ApplyBypass(hrp, targetRoot)
    if not hrp or not targetRoot then return end
    if sethiddenproperty then
        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", targetRoot) end)
    end
    local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
    if (hrp.Position - targetPos).Magnitude > 2 then
        hrp.CFrame = CFrame.new(targetPos)
    end
end

local function _aimbotV2ClearBypass(hrp)
    if sethiddenproperty and hrp then
        pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
    end
end

function _G.RaptureStartBatAimbotV2()
    _G.RaptureBatAimbotV2On = true
    selectedAimbotMode = "V2"
    local S = _G.RaptureBatAimbotV2State
    if S.conn then pcall(function() S.conn:Disconnect() end); S.conn = nil end
    S.hittingCooldown = false
    S.lastSafeCFrame = nil
    S.lastPosition = nil
    S.lastSampleTime = 0
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then hum0.AutoRotate = false end
    S.conn = RunService.RenderStepped:Connect(function()
        if not _G.RaptureBatAimbotV2On then return end
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = _aimbotV2FindBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local targetRoot, dist = _aimbotV2GetClosest()
        if not targetRoot then
            _aimbotV2ClearBypass(hrp)
            hum.AutoRotate = true
            return
        end
        local targetPos = targetRoot.Position
        if dist > BAT_V2_BYPASS_DISTANCE then
            _aimbotV2ClearBypass(hrp)
            hum.AutoRotate = false
            local targetVel = targetRoot.AssemblyLinearVelocity
            local myPos = hrp.Position
            local predictPos = targetPos + targetVel * BAT_V2_CHASE_PREDICT
            predictPos = predictPos + targetRoot.CFrame.LookVector * 0.3
            local direction = predictPos - myPos
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 1) end
            local desiredHeight = targetPos.Y + BAT_V2_CHASE_HEIGHT
            local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
            if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
            yVel = math.clamp(yVel, -70, 110)
            local desiredVel = Vector3.new(flatDir.X * BAT_V2_CHASE_SPEED, yVel, flatDir.Z * BAT_V2_CHASE_SPEED)
            hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
            local toTarget = predictPos - myPos
            if toTarget.Magnitude > 0.1 then
                local goalCF = CFrame.lookAt(myPos, predictPos)
                local diffCF = hrp.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                rx = math.clamp(rx, -2.5, 2.5)
                ry = math.clamp(ry, -2.5, 2.5)
                rz = math.clamp(rz, -2.5, 2.5)
                hrp.AssemblyAngularVelocity = hrp.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
            end
        else
            _aimbotV2ApplyBypass(hrp, targetRoot)
            local cam = workspace.CurrentCamera
            if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, targetPos) end
        end
        if autoSwingEnabled then _aimbotV2TrySwing() end
    end)
    if _G.RaptureRefreshAimbotVisual then _G.RaptureRefreshAimbotVisual() end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function _G.RaptureStopBatAimbotV2(keepVisual)
    _G.RaptureBatAimbotV2On = false
    local S = _G.RaptureBatAimbotV2State
    if S and S.conn then S.conn:Disconnect(); S.conn = nil end
    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        if sethiddenproperty then
            pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", hrp) end)
        end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
    if keepVisual ~= false and _G.RaptureRefreshAimbotVisual then _G.RaptureRefreshAimbotVisual() end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function _G.RaptureRefreshAimbotVisual()
    if _G.RaptureAimbotSetVisual then
        if selectedAimbotMode == "V2" then
            _G.RaptureAimbotSetVisual(_G.RaptureBatAimbotV2On == true)
        else
            _G.RaptureAimbotSetVisual(_G.RaptureNormalAimbotOn == true)
        end
    end
end

-- ============================================================
-- TP BAT
-- ============================================================
batDesyncTpEnabled = false
batDesyncTpConn = nil
batDesyncTpSetVisual = nil
hittingCooldownDesync = false
_tpBatUnwalkForced = false

local function getBatDesync()
    local char = LP.Character
    if not char then return nil end
    local tool = char:FindFirstChild("Bat")
    if tool then return tool end
    local bp2 = LP:FindFirstChild("Backpack")
    if bp2 then
        tool = bp2:FindFirstChild("Bat")
        if tool then tool.Parent = char; return tool end
    end
    return nil
end

local function tryHitBatDesync()
    if hittingCooldownDesync then return end
    hittingCooldownDesync = true
    pcall(function()
        local bat = getBatDesync()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(0.08, function() hittingCooldownDesync = false end)
end

local function getClosestPlayerDesync()
    local char = LP.Character
    if not char then return nil, _huge end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, _huge end
    local hpos = hrp.Position
    local cp, cd = nil, _huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                local d = (hpos - tr.Position).Magnitude
                if d < cd then cd = d; cp = p end
            end
        end
    end
    return cp, cd
end

local function batDesyncTpUpdate()
    if not batDesyncTpEnabled then stopBatDesyncTp(); return end
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = getClosestPlayerDesync()
    if target and target.Character then
        local tr = target.Character:FindFirstChild("HumanoidRootPart")
        if tr then
            if sethiddenproperty then
                pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end)
            end
            local targetPos = tr.Position + _V3new(0, 0.9, 0)
            if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = _CFnew(targetPos) end
            local cam = workspace.CurrentCamera
            if cam then cam.CFrame = _CFnew(cam.CFrame.Position, tr.Position) end
            tryHitBatDesync()
        end
    end
end

function startBatDesyncTp()
    if batDesyncTpConn then return end
    if not unwalkEnabled then startUnwalk(); unwalkEnabled = true; _tpBatUnwalkForced = true end
    batDesyncTpEnabled = true
    batDesyncTpConn = RunService.Heartbeat:Connect(batDesyncTpUpdate)
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function stopBatDesyncTp()
    if batDesyncTpConn then batDesyncTpConn:Disconnect(); batDesyncTpConn = nil end
    batDesyncTpEnabled = false
    if _tpBatUnwalkForced then
        stopUnwalk()
        unwalkEnabled = false
        _tpBatUnwalkForced = false
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
        startBatDesyncTp()
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
end

-- ============================================================
-- ============================================================
-- BAT V2 (lógica de Updatev210introZbenjaClean)
-- ============================================================
do
    local BAV2_ANG = "_GB_AngV"
    local BAV2_ATT = "_GB_Att"
    local BAV2_CLEAN = {
        "LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt",
        "AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"
    }

    local V2 = {
        enabled = false,
        conn = nil,
        safetyConn = nil,
        target = nil,
        equipped = false,
        intendedVelocity = Vector3.zero,
        attachment = nil,
        angularVelocity = nil,
        speed = 58,
        swingRange = 12,
    }
    _G.__RivalHubBatV2 = V2
    _G._RaptureBatBypass = V2

    local function cleanMovers(root)
        if not root then return end
        pcall(function()
            for _, n in ipairs(BAV2_CLEAN) do
                local c = root:FindFirstChild(n)
                if c then c:Destroy() end
            end
            for _, child in ipairs(root:GetChildren()) do
                if child.Name ~= BAV2_ANG and child.Name ~= BAV2_ATT then
                    local ln = child.Name:lower()
                    if ln:find("lockb") or ln:find("lockangv")
                       or ln:find("batlock") or ln:find("antiaim")
                       or ln:find("velocitylock") then
                        child:Destroy()
                    end
                end
            end
        end)
    end

    local function ensureAngular(root)
        if not root then return end
        pcall(function()
            local a = root:FindFirstChild(BAV2_ANG); if a then a:Destroy() end
            local b = root:FindFirstChild(BAV2_ATT); if b then b:Destroy() end
        end)
        local att = Instance.new("Attachment")
        att.Name = BAV2_ATT
        att.Parent = root
        local angV = Instance.new("AngularVelocity")
        angV.Name = BAV2_ANG
        angV.Attachment0 = att
        angV.RelativeTo = Enum.ActuatorRelativeTo.World
        angV.MaxTorque = math.huge
        angV.AngularVelocity = Vector3.zero
        angV.Parent = root
        V2.attachment = att
        V2.angularVelocity = angV
    end

    local function removeAngular()
        pcall(function() if V2.angularVelocity and V2.angularVelocity.Parent then V2.angularVelocity:Destroy() end end)
        pcall(function() if V2.attachment and V2.attachment.Parent then V2.attachment:Destroy() end end)
        V2.angularVelocity = nil
        V2.attachment = nil
    end

    local function pickTarget(root)
        local best, bestD = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < bestD then bestD = d; best = hrp end
                end
            end
        end
        return best, bestD
    end

    local function getBat(char)
        local eq = char and char:FindFirstChildOfClass("Tool")
        if eq then
            local n = eq.Name:lower()
            if n:find("bat") or n:find("slap") then return eq end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("bat") or n:find("slap") then return t end
                end
            end
        end
        return nil
    end

    local function stopBatV2()
        V2.enabled = false
        V2.equipped = false
        V2.target = nil
        if V2.conn then V2.conn:Disconnect(); V2.conn = nil end
        if V2.safetyConn then V2.safetyConn:Disconnect(); V2.safetyConn = nil end
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then pcall(function() root.Velocity = root.Velocity * 0.3 end) end
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
        if V2.angularVelocity then
            pcall(function() V2.angularVelocity.AngularVelocity = Vector3.zero end)
        end
        removeAngular()
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
        if batBypassFloatingButton then
            paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), false)
        end
    end

    local function startBatV2()
        stopBatV2()
        V2.enabled = true
        V2.equipped = false
        V2.target = nil
        V2.intendedVelocity = Vector3.zero
        V2.speed = tonumber(BAT_AIMBOT_SPEED) or 58
        if _suppressBodyLock then pcall(_suppressBodyLock) end

        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then
            cleanMovers(root)
            ensureAngular(root)
        end

        V2.conn = RunService.Heartbeat:Connect(function()
            if not V2.enabled then return end
            local char = LP.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not hum or hum.Health <= 0 then return end

            cleanMovers(hrp)
            if not V2.angularVelocity or not V2.angularVelocity.Parent then
                ensureAngular(hrp)
            end

            if not V2.equipped then
                V2.equipped = true
                if not char:FindFirstChildOfClass("Tool") then
                    local b = getBat(char)
                    if b then pcall(function() hum:EquipTool(b) end) end
                end
            end

            local target, dist = pickTarget(hrp)
            if not target then
                V2.target = nil
                hum.AutoRotate = true
                if V2.angularVelocity then
                    V2.angularVelocity.AngularVelocity = Vector3.zero
                end
                return
            end
            V2.target = target

            local aimPos = target.Position
                + target.CFrame.LookVector * (target.Velocity.Magnitude < 0.1 and 1.5 or 5)
            local delta = aimPos - hrp.Position
            local flat  = Vector3.new(delta.X, 0, delta.Z)
            hum.AutoRotate = false

            if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 then
                local curY   = hrp.Orientation.Y
                local yawD   = (math.deg(math.atan2(-flat.X, -flat.Z)) - curY + 180) % 360 - 180
                local curX   = hrp.Orientation.X
                local pitchD = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - curX + 180) % 360 - 180
                local rotY   = math.clamp(math.rad(yawD)   * 40, -28, 28)
                local rotX   = math.clamp(math.rad(pitchD) * 40, -28, 28)
                local yawR   = math.rad(hrp.Orientation.Y)
                local fwd    = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
                V2.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
            else
                V2.angularVelocity.AngularVelocity = Vector3.zero
            end

            local spd = tonumber(V2.speed) or 58
            V2.intendedVelocity =
                (flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
                + (math.abs(delta.Y) > 0.8
                    and Vector3.new(0, math.sign(delta.Y) * spd, 0)
                    or  Vector3.new(0, -2, 0))
            hrp.AssemblyLinearVelocity = V2.intendedVelocity
            hrp.Velocity = V2.intendedVelocity

            if flat.Magnitude > 0.3 then
                pcall(function() hum:Move(flat.Unit, false) end)
            else
                pcall(function() hum:Move(Vector3.zero, false) end)
            end

            if dist <= V2.swingRange then
                local bat = char:FindFirstChildOfClass("Tool")
                if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
                    pcall(function()
                        bat:Activate()
                        local re = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if re then re:FireServer() end
                    end)
                end
            end
        end)

        V2.safetyConn = RunService.RenderStepped:Connect(function()
            if not V2.enabled then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            if V2.target and V2.target.Parent then
                local delta = V2.target.Position - hrp.Position
                local flat = Vector3.new(delta.X, 0, delta.Z)
                if flat.Magnitude > 0.3 then
                    pcall(function() hum:Move(flat.Unit, false) end)
                end
                if math.abs(hrp.AssemblyLinearVelocity.X - V2.intendedVelocity.X) > 30
                   or math.abs(hrp.AssemblyLinearVelocity.Z - V2.intendedVelocity.Z) > 30 then
                    hrp.AssemblyLinearVelocity = V2.intendedVelocity
                end
            end

            local v = hrp.Velocity
            if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
                hrp.Velocity = V2.intendedVelocity
            end
            cleanMovers(hrp)
        end)
        if batBypassFloatingButton then
            paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), true)
        end
    end

    _G.__RivalHubStartBatV2 = startBatV2
    _G.__RivalHubStopBatV2  = stopBatV2
    _G.__RivalHubIsBatV2    = function() return V2.enabled == true end
    _G.RaptureStartBatBypass = startBatV2
    _G.RaptureStopBatBypass = stopBatV2
    _G.RaptureToggleBatBypass = function()
        if V2.enabled then stopBatV2() else startBatV2() end
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if V2.enabled then
            V2.equipped = false
            V2.target = nil
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                cleanMovers(hrp)
                ensureAngular(hrp)
            end
        end
    end)
end

-- ============================================================
-- HELPERS
-- ============================================================
function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

batCounterDebounce = false

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
            end)
        end
    end)
end

-- ============================================================
-- DROP BRAINROT
-- ============================================================
local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
                if rr then
                    local hum2 = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                end
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = _V3new(lv.X, DROP_ASCEND_SPEED, lv.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

-- ============================================================
-- FOV / STRETCH
-- ============================================================
CUSTOM_FOV_BIND = "RaptureDuelCustomFOV"

function enableCustomFov()
    local cam = workspace.CurrentCamera
    if cam and origFOV == nil then origFOV = cam.FieldOfView end
    fovEnabled = true
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal end)
        pcall(function() cam.FieldOfView = fovValue end)
    end
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    local prio = 200
    pcall(function() prio = Enum.RenderPriority.Camera.Value + 10 end)
    local ok = pcall(function()
        RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
            if not fovEnabled then return end
            local c = workspace.CurrentCamera
            if c and c.FieldOfView ~= fovValue then c.FieldOfView = fovValue end
        end)
    end)
    if not ok then
        customFovConn = RunService.RenderStepped:Connect(function()
            if not fovEnabled then
                if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
                return
            end
            local c = workspace.CurrentCamera
            if c then c.FieldOfView = fovValue end
        end)
    end
end

function disableCustomFov()
    fovEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Vertical end)
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    local val = tonumber(stretchValue) or 0.7
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,val,0,0,0,1) end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

-- ============================================================
-- PINTAR BOTONES FLOTANTES
-- ============================================================
function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")

    if active then
        btnFrame.BackgroundColor3 = ORANGE
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, ORANGE:Lerp(Color3.new(1,1,1), 0.35)),
                ColorSequenceKeypoint.new(0.45, ORANGE),
                ColorSequenceKeypoint.new(1.00, ORANGE:Lerp(Color3.new(0,0,0), 0.35)),
            })
        end
        if label then label.TextColor3 = Color3.fromRGB(0, 0, 0) end
        if stroke then
            stroke.Color = ORANGE
            stroke.Thickness = 1.5
            stroke.Transparency = 0.1
        end
    else
        btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(12,12,12)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0)),
            })
        end
        if label then label.TextColor3 = ORANGE end
        if stroke then
            stroke.Color = ORANGE
            stroke.Thickness = 1
            stroke.Transparency = 0.35
        end
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then uiScale.Scale = floatingButtonScale end
    end
end

local function drag(f)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local function stopDrag()
        dn = false
        di = nil
        if endConn then endConn:Disconnect(); endConn = nil end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                    end
                end
            end
        end
    end)
    movementLoop = RunService.Heartbeat:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled
           and not batDesyncTpEnabled
           and not (_G._RaptureBatBypass and _G._RaptureBatBypass.enabled) then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                local spd = getActiveMoveSpeed()
                local dir = nil
                if md.Magnitude > 0 then
                    lastMoveDir = md
                    dir = md
                elseif lastMoveDir.Magnitude > 0 then
                    for key in pairs(MOVE_KEYS) do
                        if UIS:IsKeyDown(key) then dir = lastMoveDir; break end
                    end
                end
                _applyVelocitySpeed(dir, spd, hrp)
            end
        end
        if speedLabel then
            speedLabel.Text = "Speed: " .. string.format("%.1f", getActiveMoveSpeed())
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
    if lockBtn then lockBtn.Text = uiLocked and "🔒 LOCK" or "🔓 UNLOCK" end
    saveAllSettings()
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    stopAutoCarry()
    stopHEARTLESSMusic()
    if stretchEnabled then disableStretch() end
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiFlingEnabled then stopAntiFling() end
    if antiDieEnabled then _antiDie.StopEngine() end
    stopBatCounter()
    stopMedusaCounter()
    bodyLockEnabled = false
    _blWasEnabled = false
    _blSuppressCount = 0
    if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
    stopBodyLock()
    disableAnimationPack()
    stopAutoSteal()
    disableAutoBat()
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled and not _tpBatUnwalkForced then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end
    if espEnabled then stopESP() end
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

-- ============================================================
-- SAVE / LOAD
-- ============================================================
function buildConfigTable()
    local config = {
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        stealMode = stealMode,
        antiRagdollEnabled = antiRagdollEnabled,
        antiRagdollVersion = antiRagdollVersion,
        antiFlingEnabled = antiFlingEnabled,
        antiDieEnabled = antiDieEnabled,
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        animPack = currentAnimPack,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        ragdollCountdown = ragdollCountdownEnabled,
        laggerToggled = laggerToggled,
        laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode,
        autoCarry = autoCarryEnabled,
        HEARTLESSMusicEnabled = HEARTLESSMusicEnabled, HEARTLESSMusicTrack = HEARTLESSSelectedSongIndex,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        batAimbotV2BypassDistance = tonumber(_G.RaptureBatAimbotV2TPDistance) or 8,
        aimbotMode = aimbotMode,
        dropMode = 2,
        stretchEnabled = stretchEnabled, stretchFOV = stretchFOV, stretchValue = stretchValue,
        fovEnabled = fovEnabled, fovValue = fovValue,
        uiScale = uiScaleValue, progressBarScale = progressBarScaleValue,
        tpBatEnabled = batDesyncTpEnabled,
        batBypassEnabled = batBypassEnabled,
        espEnabled = espEnabled, antiLag = antiLagEnabled,
        rainbowTools     = rainbowToolsEnabled,
        transparentTools = transparentToolsEnabled,
        customTools      = customToolsEnabled,
        customSounds     = customSoundsEnabled,
        customToolSkin   = customToolSkin,
        mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        batBypassKey = {kb = KB.BatBypass.kb and KB.BatBypass.kb.Name, gp = KB.BatBypass.gp and KB.BatBypass.gp.Name},
        tpBatFloatingPos = tpBatFloatingPos,
        batBypassFloatingPos = batBypassFloatingPos,
        instaResetFloatingPos = instaResetFloatingPos,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        floatingButtonScale = floatingButtonScale,
        skipIntro = true,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale, XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale, YOffset = pbFrame.Position.Y.Offset
        }
    end
    return config
end

function saveAllSettings()
    if _isResetting then return true end
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == _lastSavedJSON then return true end
    local success, err = pcall(function() writefile(CONFIG_FILE, json) end)
    if success then _lastSavedJSON = json end
    return success
end

function saveAmbitiousConfig() saveAllSettings() end

function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    if data.stealMode then
        stealMode = data.stealMode
        if stealMode ~= "V2" then stealMode = "Normal" end
    else
        stealMode = "Normal"
    end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if data.lockUI == nil then
        uiLocked = true
    else
        uiLocked = data.lockUI
    end
    antiRagdollEnabled = data.antiRagdollEnabled or false
    if data.antiRagdollVersion then
        antiRagdollVersion = data.antiRagdollVersion
        if antiRagdollVersion ~= "v2" then antiRagdollVersion = "v1" end
    else
        antiRagdollVersion = "v1"
    end
    antiFlingEnabled = data.antiFlingEnabled or false
    antiDieEnabled = data.antiDieEnabled or false
    bodyLockEnabled = data.bodyLockEnabled == true
    bodyLockRange = math.clamp(tonumber(data.bodyLockRange) or 20, 5, 200)
    currentAnimPack = (type(data.animPack) == "string" and (data.animPack == "Off" or ANIM_PACKS[data.animPack])) and data.animPack or "Off"
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    ragdollCountdownEnabled = data.ragdollCountdown or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false
    autoCarryEnabled = data.autoCarry == true
    HEARTLESSMusicEnabled = data.HEARTLESSMusicEnabled == true
    HEARTLESSSelectedSongIndex = math.clamp(math.floor(tonumber(data.HEARTLESSMusicTrack) or 1), 1, #HEARTLESS_MUSIC_TRACKS)
    espEnabled = data.espEnabled or false
    antiLagEnabled = data.antiLag or false

    if data.aimbotMode then
        aimbotMode = data.aimbotMode
        if aimbotMode ~= "V2" then aimbotMode = "V1" end
    else
        aimbotMode = "V1"
    end

    rainbowToolsEnabled     = data.rainbowTools == true
    transparentToolsEnabled = data.transparentTools == true
    customToolsEnabled      = data.customTools == true
    customSoundsEnabled     = data.customSounds == true
    customToolSkin          = data.customToolSkin or "DiamondSword"
    batBypassEnabled        = data.batBypassEnabled == true
    if _G.RaptureToolAssets and not _G.RaptureToolAssets[customToolSkin] then
        customToolSkin = "DiamondSword"
    end
    if type(data.batAimbotV2BypassDistance) == "number" then
        _G.RaptureBatAimbotV2TPDistance = math.clamp(data.batAimbotV2BypassDistance, 1, 50)
    end
    uiScaleValue = data.uiScale or uiScaleValue
    progressBarScaleValue = data.progressBarScale or progressBarScaleValue
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = progressBarScaleValue / 100 end
    local tpBatStateLoaded = data.tpBatEnabled or false
    if tpBatStateLoaded then
        task.defer(function()
            startBatDesyncTp()
            if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        end)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    end
    local function lk(e, d)
        if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.TPBat, data.tpBatKey)
    lk(KB.InstaReset, data.instaResetKey)
    lk(KB.BatBypass, data.batBypassKey)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.batBypassFloatingPos then batBypassFloatingPos = data.batBypassFloatingPos end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    stretchEnabled = data.stretchEnabled or false
    stretchValue = data.stretchValue or 0.7
    fovValue = data.fovValue or 70
    fovEnabled = data.fovEnabled or false
    if fovSliderSet then fovSliderSet(fovValue) end
    if fovEnabled then enableCustomFov() end
    if setFovVisual then setFovVisual(fovEnabled) end
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    backgroundIndex = data.backgroundIndex or 1
    if backgroundIndex < 1 or backgroundIndex > #backgroundImages then backgroundIndex = 1 end
    backgroundImageTransparency = data.backgroundImageTransparency or 0
    floatingButtonScale = data.floatingButtonScale or floatingButtonScale
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAllBackgroundTasks()
        NS = 60
        CS = 29
        LAGGER_SPEED = 15
        LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        stealMode = "Normal"
        speedMode = false
        autoCarryEnabled = false
        autoCarrySpeedActive = false
        HEARTLESSMusicEnabled = false
        HEARTLESSSelectedSongIndex = 1
        stopHEARTLESSMusic()
        laggerToggled = false
        laggerCarryToggled = false
        antiRagdollEnabled = false
        antiRagdollVersion = "v1"
        antiFlingEnabled = false
        antiDieEnabled = false
        medusaCounterEnabled = false
        batCounterEnabled = false
        ragdollCountdownEnabled = false
        autoBatEnabled = false
        autoLeftEnabled = false
        autoRightEnabled = false
        unwalkEnabled = false
        bodyLockEnabled = false
        bodyLockRange = 20
        _blWasEnabled = false
        _blSuppressCount = 0
        disableAnimationPack()
        uiLocked = true
        CONFIG.AUTO_STEAL_ENABLED = false
        BAT_AIMBOT_SPEED = 58
        _G.RaptureBatAimbotV2TPDistance = 8
        if _G.RaptureBatAimbotV2BypassBox then _G.RaptureBatAimbotV2BypassBox.Text = "8" end
        aimbotMode = "V1"
        rainbowToolsEnabled = false
        transparentToolsEnabled = false
        customToolsEnabled = false
        customSoundsEnabled = false
        customToolSkin = "DiamondSword"
        batBypassEnabled = false
        if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
        stretchEnabled = false
        stretchValue = 0.7
        fovValue = 70
        uiScaleValue = 66
        progressBarScaleValue = 78
        backgroundIndex = 1
        floatingButtonScale = 1
        espEnabled = false
        antiLagEnabled = false
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then
                KB[key].kb = val.kb
                KB[key].gp = val.gp
            end
        end
        if isfile and isfile(CONFIG_FILE) then pcall(delfile, CONFIG_FILE) end
        savedButtonPositions = {}
        if MobilePanel then
            for _, btn in ipairs(MobilePanel:GetChildren()) do
                if btn:IsA("TextButton") and btn.Name then
                    local defX, defY = getDefaultButtonPosition(btn.Name)
                    btn.Position = UDim2.new(0, defX, 0, defY)
                end
            end
        end
        task.defer(function()
            if setAntiRagVisual then setAntiRagVisual(false) end
            if setInstaGrab then setInstaGrab(false) end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if setBatCounterVisual then setBatCounterVisual(false) end
            if setMedusaVisual then setMedusaVisual(false) end
            if setRagdollTimerVisual then setRagdollTimerVisual(false) end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if autoBatSetVisual then autoBatSetVisual(false) end
            if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
            if batBypassSetVisual then batBypassSetVisual(false) end
            if setESPVisual then setESPVisual(false) end
            if setAntiLagVisual then setAntiLagVisual(false) end
            if setFovVisual then setFovVisual(false) end
            if setAntiDieVisual then setAntiDieVisual(false) end
            if setAntiFlingVisual then setAntiFlingVisual(false) end
            if setAutoCarryVisual then setAutoCarryVisual(false) end
            if HEARTLESSMusicSetVisual then HEARTLESSMusicSetVisual(false) end
            if HEARTLESSMusicTrackRefresh then HEARTLESSMusicTrackRefresh() end
            if bodyLockSetVisual then bodyLockSetVisual(false) end
            if bodyLockRangeBox then bodyLockRangeBox.Text = "20" end
            if animationSelectorRefresh then animationSelectorRefresh("Off") end
            if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
            if aimbotModeSetVisual then aimbotModeSetVisual("V1") end
            if antiRagSetVisual then antiRagSetVisual("V1") end
            if stealModeSetVisual then stealModeSetVisual("Normal") end
            if _G.RaptureRainbowTools then _G.RaptureRainbowTools.setEnabled(false) end
            if _G.RaptureTransparentTools then _G.RaptureTransparentTools.setEnabled(false) end
            if _G.RaptureCustomTools then _G.RaptureCustomTools.setEnabled(false) end
            if _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(false) end
            refreshSpeedModeLabel()
        end)
        updateAllUIThemeColors(PASTEL_PINK)
        _RaptureApplyThemeToSliders()
        _lastSavedJSON = nil
        saveAllSettings()
    end)
    _isResetting = false
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = true end
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local orderMap = {
        DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3,
        TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7
    }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

-- ============================================================
-- ENEMY SPEED LABELS
-- ============================================================
local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0
    local color = getThemeColor()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = color
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= color then label.TextColor3 = color end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

-- ============================================================
-- INSTA RESET
-- ============================================================
do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true
        local resetCooldown = false
        local resetThread = nil
        local _lastInstaResetRequest = 0
        local function instaResetFast()
            if resetCooldown then return end
            resetCooldown = true
            local character = LP.Character
            if not character then resetCooldown = false return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then resetCooldown = false return end
            resetThread = task.spawn(function()
                local attempts = 0
                while character and character.Parent and humanoid and humanoid.Health > 0 and attempts < 40 do
                    if LP.Character ~= character then break end
                    pcall(function()
                        humanoid.HipHeight = 1e30
                        humanoid.AutoRotate = true
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then rootPart.CanCollide = false end
                    end)
                    if not character or not character.Parent or humanoid.Health <= 0 then break end
                    attempts = attempts + 1
                    task.wait(0.05)
                end
                if character and character.Parent and humanoid and humanoid.Health > 0 then
                    pcall(function() humanoid.Health = 0 end)
                end
                resetCooldown = false
                resetThread = nil
            end)
        end
        local function instaReset()
            local now = os.clock()
            if now - _lastInstaResetRequest < 0.75 then return end
            _lastInstaResetRequest = now
            instaResetFast()
        end
        LP.CharacterAdded:Connect(function()
            if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
            resetCooldown = false
        end)
        _G.InstaReset = { Trigger = instaReset }
    end
end

-- ============================================================
-- BUILD GUI
-- ============================================================
function buildGui()
    local ROW_BG = Color3.fromRGB(0, 0, 0)
    local ROW_BORDER = Color3.fromRGB(0, 0, 0)
    local WHITE = ORANGE
    local INP = Color3.fromRGB(10, 10, 10)
    local TAB_INACT = ORANGE
    local GUI_W, GUI_H = 360, 520

    local old = CoreGui:FindFirstChild("RaptureDuel")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild("RaptureDuel"); if o then o:Destroy() end end

    gui = Instance.new("ScreenGui")
    gui.Name = "RaptureDuel"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = CoreGui end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    local watermark = Instance.new("TextLabel", gui)
    watermark.Name = "CalabasasWatermark"
    watermark.AnchorPoint = Vector2.new(0, 1)
    watermark.Size = UDim2.new(0, 150, 0, 28)
    watermark.Position = UDim2.new(0, 12, 1, -12)
    watermark.BackgroundTransparency = 1
    watermark.Text = "Calabasas"
    watermark.TextColor3 = ORANGE
    watermark.Font = Enum.Font.Garamond
    watermark.TextSize = 22
    watermark.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    watermark.TextStrokeTransparency = 0.2
    watermark.TextXAlignment = Enum.TextXAlignment.Left
    watermark.ZIndex = 250

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundColor3 = Color3.fromRGB(8, 4, 12)  -- fondo base Halloween (negro-púrpura)
    bgImage.BackgroundTransparency = 0
    bgImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    bgImage.ImageTransparency = backgroundImageTransparency
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    -- Encabezado: el nombre se muestra como texto centrado en una placa.
    local topImage = Instance.new("ImageLabel", main)
    topImage.Name = "TopImage"
    topImage.Size = UDim2.new(0, 380, 0, 95)   -- ✅ 380x95
    topImage.Position = UDim2.new(0.5, -190, 0, -10)
    topImage.BackgroundTransparency = 1
    topImage.Image = ""  -- Logo anterior eliminado; se usa el nombre HEARTLESS.VS
    topImage.ScaleType = Enum.ScaleType.Fit
    topImage.ZIndex = 15
    topImage.Parent = main

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local titleFrame = Instance.new("Frame", main)
    titleFrame.Size = UDim2.new(0, 210, 0, 70)
    titleFrame.Position = UDim2.new(0, 8, 0, 18)
    titleFrame.BackgroundTransparency = 1
    titleFrame.BorderSizePixel = 0
    titleFrame.ZIndex = 20

    titleLbl = Instance.new("TextLabel", titleFrame)
    titleLbl.Size = UDim2.new(1, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 0, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "HEARTLESS.VS"
    titleLbl.TextColor3 = getThemeColor()
    titleLbl.Font = Enum.Font.Garamond
    titleLbl.TextSize = 46
    titleLbl.TextScaled = false
    titleLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    titleLbl.TextStrokeTransparency = 0.12
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center
    titleLbl.ZIndex = 21

    -- Un solo botón alterna entre fijar la interfaz y permitir moverla.
    lockBtn = Instance.new("TextButton", main)
    lockBtn.Name = "LockToggleButton"
    lockBtn.Size = UDim2.new(0, 80, 0, 32)
    lockBtn.Position = UDim2.new(1, -128, 0, 12)
    lockBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    lockBtn.BackgroundTransparency = 0.1
    lockBtn.BorderSizePixel = 0
    lockBtn.Text = uiLocked and "🔒 LOCK" or "🔓 UNLOCK"
    lockBtn.TextColor3 = ORANGE
    lockBtn.Font = Enum.Font.GothamBold
    lockBtn.TextSize = 12
    lockBtn.AutoButtonColor = false
    lockBtn.ZIndex = 200
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 8)
    local lockStroke = Instance.new("UIStroke", lockBtn)
    lockStroke.Color = ORANGE
    lockStroke.Thickness = 1
    lockStroke.Transparency = 0.25
    lockBtn.Activated:Connect(function()
        toggleLockUI()
    end)

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.MouseButton1Click:Connect(function() hideGui() end)

    -- ✅ BOTÓN MINI CON IMAGEN A 120x120
    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 170, 0, 52)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "HEARTLESS.VS"
    miniBtn.TextColor3 = MINI_BUTTON_TEXT
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 18
    miniBtn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.TextStrokeTransparency = 0.2
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    miniBtn.AutoButtonColor = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = ORANGE
    miniStroke.Thickness = 2
    miniStroke.Transparency = 0.2

    local miniImg = Instance.new("ImageLabel", miniBtn)
    miniImg.Name = "MiniImage"
    miniImg.AnchorPoint = Vector2.new(0.5, 0.5)
    -- ✅ IMAGEN DEL BOTÓN MINI A 120x120
    miniImg.Size = UDim2.new(0, 120, 0, 120)
    miniImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    miniImg.BackgroundTransparency = 1
    miniImg.Image = ""  -- Imagen anterior eliminada
    miniImg.ScaleType = Enum.ScaleType.Fit
    miniImg.ZIndex = 21
    miniImg.Parent = miniBtn

    miniBtn.MouseButton1Click:Connect(function() showGui() end)

    local slideTween = nil
    local mainOriginalPos = main.Position

    showGui = function()
        if slideTween then slideTween:Cancel() end
        if not main then return end
        main.Visible = true
        miniBtn.Visible = false
        main.Position = UDim2.new(0, -GUI_W - 20, 0, 2)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = mainOriginalPos})
        slideTween:Play()
    end

    hideGui = function()
        if slideTween then slideTween:Cancel() end
        if not main or not main.Visible then return end
        local targetPos = UDim2.new(0, -GUI_W - 20, 0, 2)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween:Play()
        slideTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            slideTween = nil
        end)
    end

    local TAB_W = 80
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "SideTabBar"
    tabBar.Size = UDim2.new(0, TAB_W, 0, 280)
    tabBar.Position = UDim2.new(1, -TAB_W - 8, 0, 134)
    tabBar.BackgroundTransparency = 1
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local tabContent = Instance.new("Frame", main)
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -TAB_W - 20, 1, -139)
    tabContent.Position = UDim2.new(0, 10, 0, 134)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Config", "Keybinds"}
    local tabButtonsLocal = {}
    local contentPagesLocal = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(1, -10, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_INACT
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 11
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        btn.LayoutOrder = i
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn:SetAttribute("IsActiveTab", i == 1)
        if i == 1 then
            btn.BackgroundColor3 = BLACK_BG
            btn.TextColor3 = ACTIVE_TXT
            btn.BackgroundTransparency = 0
        end
        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = getThemeColor()
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)
        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 2)
        padding.PaddingRight = UDim.new(0, 2)
        padding.PaddingTop = UDim.new(0, 4)
        padding.PaddingBottom = UDim.new(0, 20)
        contentPagesLocal[name] = page
        btn.MouseButton1Click:Connect(function()
            playMenuSound("tab")
            for _, pg2 in pairs(contentPagesLocal) do pg2.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtonsLocal) do
                b.TextColor3 = TAB_INACT
                b.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                b:SetAttribute("IsActiveTab", false)
            end
            btn.TextColor3 = ACTIVE_TXT
            btn.BackgroundColor3 = BLACK_BG
            btn:SetAttribute("IsActiveTab", true)
        end)
        table.insert(tabButtonsLocal, btn)
    end
    tabButtons = tabButtonsLocal
    contentPages = contentPagesLocal

    local pageCounters = {}
    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 40)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.05
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", f)
        st.Color = BLACK_STROKE
        st.Thickness = 1
        st.Transparency = 0.2
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 46, 0, 22)
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -(offset or 10), 0.5, 0)
        pill.BackgroundColor3 = INACTIVE_BG
        pill.BackgroundTransparency = 0
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = BLACK_STROKE
        stroke.Thickness = 1.5
        stroke.Transparency = 0.3
        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 3, 0.5, -8)
        dot.BackgroundColor3 = INACTIVE_TXT
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, info, {
            Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = on and Color3.fromRGB(255,255,255) or INACTIVE_TXT,
        }):Play()
        TS:Create(pill, info, {
            BackgroundColor3 = on and PASTEL_PINK or INACTIVE_BG,
            BackgroundTransparency = 0,
        }):Play()
        if stroke then
            TS:Create(stroke, info, {
                Color = on and PASTEL_PINK or BLACK_STROKE,
                Transparency = on and 0.1 or 0.3,
            }):Play()
        end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 40)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 10)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
            task.defer(saveAllSettings)
        end)
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.3
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = BLACK_STROKE
        bs.Thickness = 1
        bs.Transparency = 0.3
        tb.FocusLost:Connect(function()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(saveAllSettings)
            end
        end)
        return tb
    end

    local function mkStepRow(page, label, getValue, setValue, minV, maxV, step)
        local row = mkRow(page, 40)
        mkLabel(row, label)
        local valLabel = Instance.new("TextLabel", row)
        valLabel.Size = UDim2.new(0, 46, 0, 24)
        valLabel.Position = UDim2.new(1, -120, 0.5, -12)
        valLabel.BackgroundColor3 = INP
        valLabel.BackgroundTransparency = 0.3
        valLabel.BorderSizePixel = 0
        valLabel.Text = tostring(getValue())
        valLabel.TextColor3 = WHITE
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 11
        valLabel.ZIndex = 8
        Instance.new("UICorner", valLabel).CornerRadius = UDim.new(0, 8)
        local minusBtn = Instance.new("TextButton", row)
        minusBtn.Size = UDim2.new(0, 26, 0, 24)
        minusBtn.Position = UDim2.new(1, -152, 0.5, -12)
        minusBtn.BackgroundColor3 = INP
        minusBtn.BackgroundTransparency = 0.3
        minusBtn.BorderSizePixel = 0
        minusBtn.Text = "−"
        minusBtn.TextColor3 = WHITE
        minusBtn.Font = Enum.Font.GothamBlack
        minusBtn.TextSize = 16
        minusBtn.ZIndex = 8
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 8)
        local plusBtn = Instance.new("TextButton", row)
        plusBtn.Size = UDim2.new(0, 26, 0, 24)
        plusBtn.Position = UDim2.new(1, -70, 0.5, -12)
        plusBtn.BackgroundColor3 = INP
        plusBtn.BackgroundTransparency = 0.3
        plusBtn.BorderSizePixel = 0
        plusBtn.Text = "+"
        plusBtn.TextColor3 = WHITE
        plusBtn.Font = Enum.Font.GothamBlack
        plusBtn.TextSize = 16
        plusBtn.ZIndex = 8
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 8)
        local function updateLabel() valLabel.Text = tostring(getValue()) end
        minusBtn.MouseButton1Click:Connect(function()
            local v = getValue() - step
            if v < minV then v = minV end
            setValue(v); updateLabel(); saveAllSettings()
        end)
        plusBtn.MouseButton1Click:Connect(function()
            local v = getValue() + step
            if v > maxV then v = maxV end
            setValue(v); updateLabel(); saveAllSettings()
        end)
        return valLabel
    end

    local function mkCollapsibleSlider(page, label, options, getValue, setValue, opts)
        opts = opts or {}
        local wrapper = Instance.new("Frame", page)
        wrapper.Size = UDim2.new(1, -4, 0, 40)
        wrapper.BackgroundTransparency = 1
        wrapper.LayoutOrder = getNextOrder(page)
        wrapper.ClipsDescendants = false
        wrapper.ZIndex = 7
        local row = Instance.new("Frame", wrapper)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.Position = UDim2.new(0, 0, 0, 0)
        row.BackgroundColor3 = ROW_BG
        row.BackgroundTransparency = 0.05
        row.BorderSizePixel = 0
        row.ZIndex = 8
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = BLACK_STROKE
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.2
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -100, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = WHITE
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.ZIndex = 9
        local currentValueLbl = Instance.new("TextLabel", row)
        currentValueLbl.Size = UDim2.new(0, 60, 1, 0)
        currentValueLbl.Position = UDim2.new(1, -96, 0, 0)
        currentValueLbl.BackgroundTransparency = 1
        currentValueLbl.Text = tostring(getValue())
        currentValueLbl.TextColor3 = PASTEL_PINK
        currentValueLbl.Font = Enum.Font.GothamBold
        currentValueLbl.TextSize = 11
        currentValueLbl.TextXAlignment = Enum.TextXAlignment.Right
        currentValueLbl.ZIndex = 9
        local arrowBtn = Instance.new("TextButton", row)
        arrowBtn.Name = "Arrow"
        arrowBtn.Size = UDim2.new(0, 30, 0, 30)
        arrowBtn.Position = UDim2.new(1, -36, 0.5, -15)
        arrowBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        arrowBtn.BackgroundTransparency = 0.25
        arrowBtn.BorderSizePixel = 0
        arrowBtn.Text = "▲"
        arrowBtn.TextColor3 = WHITE
        arrowBtn.Font = Enum.Font.GothamBold
        arrowBtn.TextSize = 14
        arrowBtn.AutoButtonColor = false
        arrowBtn.ZIndex = 10
        Instance.new("UICorner", arrowBtn).CornerRadius = UDim.new(0, 8)
        local arrowStroke = Instance.new("UIStroke", arrowBtn)
        arrowStroke.Color = PASTEL_PINK
        arrowStroke.Thickness = 1
        arrowStroke.Transparency = 0.35
        local holder = Instance.new("Frame", wrapper)
        holder.Size = UDim2.new(1, 0, 0, 0)
        holder.Position = UDim2.new(0, 0, 0, 42)
        holder.BackgroundTransparency = 1
        holder.ClipsDescendants = true
        holder.ZIndex = 7
        holder.Visible = false
        local sliderRow = Instance.new("Frame", holder)
        sliderRow.Size = UDim2.new(1, 0, 0, 42)
        sliderRow.Position = UDim2.new(0, 0, 0, 0)
        sliderRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        sliderRow.BackgroundTransparency = 0.15
        sliderRow.BorderSizePixel = 0
        sliderRow.ZIndex = 8
        Instance.new("UICorner", sliderRow).CornerRadius = UDim.new(0, 10)
        local sliderBg = Instance.new("Frame", sliderRow)
        sliderBg.Size = UDim2.new(1, -16, 1, -8)
        sliderBg.Position = UDim2.new(0, 8, 0, 4)
        sliderBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        sliderBg.BackgroundTransparency = 0.2
        sliderBg.BorderSizePixel = 0
        sliderBg.ClipsDescendants = true
        sliderBg.ZIndex = 9
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 14)
        local sliderBgStroke = Instance.new("UIStroke", sliderBg)
        sliderBgStroke.Color = BLACK_STROKE
        sliderBgStroke.Thickness = 1.4
        sliderBgStroke.Transparency = 0.32
        local optionBtns = {}
        local optionTexts = {}
        local segW = 1 / #options
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton", sliderBg)
            optBtn.Name = "Opt_" .. tostring(i)
            optBtn.AnchorPoint = Vector2.new(0.5, 0.5)
            optBtn.Size = UDim2.new(segW, -4, 1, -8)
            optBtn.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
            optBtn.BackgroundColor3 = INACTIVE_BG
            optBtn.BackgroundTransparency = 0
            optBtn.BorderSizePixel = 0
            optBtn.Text = ""
            optBtn.AutoButtonColor = false
            optBtn.ZIndex = 10
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 13)
            local optStroke = Instance.new("UIStroke", optBtn)
            optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            optStroke.Color = BLACK_STROKE
            optStroke.Thickness = 1.5
            optStroke.Transparency = 0.6
            optStroke.Parent = optBtn
            local optLbl = Instance.new("TextLabel", optBtn)
            optLbl.AnchorPoint = Vector2.new(0.5, 0.5)
            optLbl.Size = UDim2.new(1, 0, 1, 0)
            optLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
            optLbl.BackgroundTransparency = 1
            optLbl.Text = opt
            optLbl.TextColor3 = INACTIVE_TXT
            optLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            optLbl.TextStrokeTransparency = 0.4
            optLbl.TextSize = 11
            optLbl.Font = Enum.Font.GothamBlack
            optLbl.TextXAlignment = Enum.TextXAlignment.Center
            optLbl.ZIndex = 11
            optLbl.Parent = optBtn
            optionBtns[i] = optBtn
            optionTexts[i] = optLbl
            optBtn.MouseButton1Click:Connect(function()
                setValue(opt)
                for j, btn in ipairs(optionBtns) do
                    local sel = (j == i)
                    TS:Create(btn, TweenInfo.new(0.18), {
                        BackgroundColor3 = sel and PASTEL_PINK or INACTIVE_BG,
                    }):Play()
                    local st = btn:FindFirstChildOfClass("UIStroke")
                    if st then
                        TS:Create(st, TweenInfo.new(0.18), {
                            Color = sel and PASTEL_PINK or BLACK_STROKE,
                            Transparency = sel and 0.1 or 0.6,
                            Thickness = sel and 2 or 1.5,
                        }):Play()
                    end
                    TS:Create(optionTexts[j], TweenInfo.new(0.14), {
                        TextColor3 = INACTIVE_TXT,
                    }):Play()
                end
                currentValueLbl.Text = tostring(opt)
                task.defer(saveAllSettings)
            end)
        end
        local function applyVisual(mode)
            local idx = 1
            for i, opt in ipairs(options) do
                if opt == mode then idx = i break end
            end
            for j, btn in ipairs(optionBtns) do
                local sel = (j == idx)
                btn.BackgroundColor3 = sel and PASTEL_PINK or INACTIVE_BG
                local st = btn:FindFirstChildOfClass("UIStroke")
                if st then
                    st.Color = sel and PASTEL_PINK or BLACK_STROKE
                    st.Transparency = sel and 0.1 or 0.6
                    st.Thickness = sel and 2 or 1.5
                end
                optionTexts[j].TextColor3 = INACTIVE_TXT
            end
            currentValueLbl.Text = tostring(mode)
        end
        local function applyThemeColor(newColor)
            local idx = 1
            for i, opt in ipairs(options) do
                if opt == getValue() then idx = i break end
            end
            for j, btn in ipairs(optionBtns) do
                if j == idx then
                    btn.BackgroundColor3 = newColor
                end
            end
            arrowStroke.Color = newColor
            sliderBgStroke.Color = newColor
            currentValueLbl.TextColor3 = newColor
        end
        table.insert(_G._RaptureDynamicSliders, {
            applyThemeColor = applyThemeColor
        })
        local expanded = false
        arrowBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                holder.Visible = true
                TS:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 42)
                }):Play()
                TS:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, -4, 0, 84)
                }):Play()
                TS:Create(arrowBtn, TweenInfo.new(0.2), {Rotation = 180}):Play()
            else
                TS:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                TS:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                    Size = UDim2.new(1, -4, 0, 40)
                }):Play()
                TS:Create(arrowBtn, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.delay(0.22, function()
                    if not expanded then holder.Visible = false end
                end)
            end
        end)
        applyVisual(getValue())
        return applyVisual, currentValueLbl, optionBtns, optionTexts
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 70, 0, 24)
        btn.Position = UDim2.new(1, -78, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                task.defer(saveAllSettings)
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 40)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    -- === SPEED PAGE ===
    local speedPage = contentPages["Speed"]
    do local row = mkRow(speedPage); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 60, function(v) if v > 0 and v <= 500 then NS = v end end) end
    setAutoCarryVisual = mkToggle(speedPage, "Auto Carry Speed", function(on)
        if on then startAutoCarry() else stopAutoCarry() end
        task.defer(saveAllSettings)
    end)
    do local row = mkRow(speedPage); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 60, function(v) if v > 0 and v <= 500 then CS = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger Carry"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v end end) end

    -- === COMBAT PAGE ===
    local combatPage = contentPages["Combat"]

    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
        task.defer(saveAllSettings)
    end)

    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then if LP.Character then setupMedusaCounter(LP.Character) end
        else stopMedusaCounter() end
        task.defer(saveAllSettings)
    end)

    setRagdollTimerVisual = mkToggle(combatPage, "Ragdoll Countdown", function(on)
        ragdollCountdownEnabled = on
        if on then hookRagdollCountdown(LP.Character)
        else
            if _G._RaptureRCD.conn then pcall(function() _G._RaptureRCD.conn:Disconnect() end); _G._RaptureRCD.conn = nil end
            if _G._RaptureRCD.charConn then pcall(function() _G._RaptureRCD.charConn:Disconnect() end); _G._RaptureRCD.charConn = nil end
            if ragdollCountdownLabel then
                ragdollCountdownLabel.Visible = false
                ragdollCountdownLabel.Text = ""
            end
        end
        task.defer(saveAllSettings)
    end)

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then _antiDie.StartEngine() else _antiDie.StopEngine() end
        task.defer(saveAllSettings)
    end)

    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
        antiFlingEnabled = on
        if on then startAntiFling() else stopAntiFling() end
        task.defer(saveAllSettings)
    end)

    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on) setAntiRagdollEnabled(on) end)

    antiRagSetVisual = mkCollapsibleSlider(combatPage, "Anti Ragdoll Version", {"V1", "V2"},
        function() return antiRagdollVersion == "v1" and "V1" or "V2" end,
        function(v)
            local newV = (v == "V2") and "v2" or "v1"
            setAntiRagdollVersion(newV)
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end)

    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then
            _blWasEnabled = true
            if _blSuppressCount == 0 then startBodyLock() end
        else
            _blWasEnabled = false
            stopBodyLock()
        end
        task.defer(saveAllSettings)
    end)
    do
        local row = mkRow(combatPage)
        mkLabel(row, "Body Lock Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 54, 64, function(value)
            if value and value >= 5 and value <= 200 then
                bodyLockRange = _floor(value + 0.5)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
                task.defer(saveAllSettings)
            end
        end)
    end

    setInstaGrab = mkToggle(combatPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
    end)

    stealModeSetVisual = mkCollapsibleSlider(combatPage, "Steal Mode", {"Normal", "V2"},
        function() return stealMode end,
        function(v)
            if v ~= "V2" then v = "Normal" end
            stealMode = v
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end)

    do local row = mkRow(combatPage); mkLabel(row, "Steal Radius"); radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 60, function(v) if v and v >= 5 and v <= 300 then CONFIG.STEAL_RANGE = _floor(v+0.5); Steal.StealRadius = CONFIG.STEAL_RANGE; saveAllSettings() end end) end

    autoBatSetVisual = mkToggle(combatPage, "Bat Aimbot", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        task.defer(saveAllSettings)
    end)

    local aimbotModeRefresh
    aimbotModeRefresh = mkCollapsibleSlider(combatPage, "Bat Aimbot Mode", {"V1", "V2"},
        function() return aimbotMode end,
        function(v)
            if v ~= "V2" then v = "V1" end
            aimbotMode = v
            selectedAimbotMode = v
            if _G.RaptureRefreshAimbotVisual then _G.RaptureRefreshAimbotVisual() end
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end)
    aimbotModeSetVisual = aimbotModeRefresh

    do local row = mkRow(combatPage); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 60, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end

    batBypassSetVisual = mkToggle(combatPage, "Bat V2", function(on)
        if on then
            if not _G._RaptureBatBypass.enabled then _G.RaptureStartBatBypass() end
        else
            if _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
        end
        task.defer(saveAllSettings)
    end)

    batDesyncTpSetVisual = mkToggle(combatPage, "TP BAT", function(on)
        if on then if not batDesyncTpEnabled then toggleBatDesyncTp() end
        else if batDesyncTpEnabled then toggleBatDesyncTp() end end
        task.defer(saveAllSettings)
    end)

    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then executeDropWithToggle(function(v) dropBrainrotSetVisual(v); if mobSetDropBR then mobSetDropBR(v) end end) end
    end)

    autoLeftSetVisual = mkToggle(combatPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
        task.defer(saveAllSettings)
    end)

    autoRightSetVisual = mkToggle(combatPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
        task.defer(saveAllSettings)
    end)

    -- === VISUAL PAGE ===
    local visualPage = contentPages["Visual"]

    HEARTLESSMusicSetVisual = mkToggle(visualPage, "HEARTLESS Music", function(on)
        setHEARTLESSMusicEnabled(on)
    end)
    do
        local row = mkRow(visualPage, 40)
        local trackLabel = Instance.new("TextLabel", row)
        trackLabel.Name = "HEARTLESSMusicTrackLabel"
        trackLabel.Size = UDim2.new(1, -128, 1, 0)
        trackLabel.Position = UDim2.new(0, 12, 0, 0)
        trackLabel.BackgroundTransparency = 1
        trackLabel.TextColor3 = WHITE
        trackLabel.Font = Enum.Font.GothamBold
        trackLabel.TextSize = 11
        trackLabel.TextXAlignment = Enum.TextXAlignment.Left
        trackLabel.TextTruncate = Enum.TextTruncate.AtEnd
        trackLabel.ZIndex = 8
        local function makeTrackButton(text, rightOffset)
            local button = Instance.new("TextButton", row)
            button.Size = UDim2.new(0, 26, 0, 26)
            button.Position = UDim2.new(1, -rightOffset, 0.5, -13)
            button.BackgroundColor3 = INP
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = ORANGE
            button.Font = Enum.Font.GothamBlack
            button.TextSize = 18
            button.AutoButtonColor = false
            button.ZIndex = 9
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = ORANGE
            stroke.Thickness = 1
            stroke.Transparency = 0.35
            return button
        end
        local previous = makeTrackButton("‹", 64)
        local next = makeTrackButton("›", 32)
        HEARTLESSMusicTrackRefresh = function()
            local song = HEARTLESS_MUSIC_TRACKS[HEARTLESSSelectedSongIndex]
            if song then
                trackLabel.Text = string.format("%02d/%02d  %s", HEARTLESSSelectedSongIndex, #HEARTLESS_MUSIC_TRACKS, song.title)
            end
        end
        previous.Activated:Connect(function() changeHEARTLESSMusicTrack(-1) end)
        next.Activated:Connect(function() changeHEARTLESSMusicTrack(1) end)
        HEARTLESSMusicTrackRefresh()
    end

    setESPVisual = mkToggle(visualPage, "ESP Players", function(on)
        if on then startESP() else stopESP() end
        task.defer(saveAllSettings)
    end)

    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        task.defer(saveAllSettings)
    end)

    do
        local row = mkRow(visualPage, 40)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 10)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
            task.defer(saveAllSettings)
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end
    do local row = mkRow(visualPage); mkLabel(row, "Stretch Value"); stretchValueBox = mkBox(row, stretchValue, 50, 60, function(v) if v and v >= 0.3 and v <= 1.5 then stretchValue = v; if stretchEnabled then disableStretch(); enableStretch() end; saveAllSettings() end end) end

    setFovVisual = mkToggle(visualPage, "FOV", function(on)
        if on then enableCustomFov() else disableCustomFov() end
        task.defer(saveAllSettings)
    end)
    if setFovVisual then setFovVisual(fovEnabled) end
    do
        local row = mkRow(visualPage)
        mkLabel(row, "FOV Value")
        local fovBox = mkBox(row, fovValue, 50, 60, function(v)
            if v and v >= 20 and v <= 120 then
                fovValue = _floor(v + 0.5)
                if not fovEnabled then enableCustomFov(); if setFovVisual then setFovVisual(true) end end
                local cam = workspace.CurrentCamera
                if cam then pcall(function() cam.FieldOfView = fovValue end) end
                saveAllSettings()
            end
        end)
        fovSliderSet = function(val) if fovBox then fovBox.Text = tostring(val) end end
    end


    do
        local options = ANIM_PACK_ORDER
        local wrapper = Instance.new("Frame", visualPage)
        wrapper.Name = "AnimationPackSelector"
        wrapper.Size = UDim2.new(1, -4, 0, 40)
        wrapper.BackgroundTransparency = 1
        wrapper.LayoutOrder = getNextOrder(visualPage)
        wrapper.ClipsDescendants = false
        wrapper.ZIndex = 7
        local row = Instance.new("Frame", wrapper)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundColor3 = ROW_BG
        row.BackgroundTransparency = 0.05
        row.BorderSizePixel = 0
        row.ZIndex = 8
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = BLACK_STROKE
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.2
        local title = mkLabel(row, "Animations")
        title.Size = UDim2.new(0.45, 0, 1, 0)
        local choice = Instance.new("TextButton", row)
        choice.Name = "AnimationPackChoice"
        choice.Size = UDim2.new(0.50, -8, 0, 28)
        choice.Position = UDim2.new(0.47, 0, 0, 6)
        choice.BackgroundColor3 = INP
        choice.BackgroundTransparency = 0.1
        choice.BorderSizePixel = 0
        choice.Text = tostring(currentAnimPack) .. "  ▼"
        choice.TextColor3 = ORANGE
        choice.Font = Enum.Font.GothamBold
        choice.TextSize = 11
        choice.TextTruncate = Enum.TextTruncate.AtEnd
        choice.AutoButtonColor = false
        choice.ZIndex = 10
        Instance.new("UICorner", choice).CornerRadius = UDim.new(0, 7)
        local choiceStroke = Instance.new("UIStroke", choice)
        choiceStroke.Color = ORANGE
        choiceStroke.Thickness = 1
        choiceStroke.Transparency = 0.3
        animSelectorLabel = choice
        local panel = Instance.new("Frame", wrapper)
        panel.Name = "AnimationPackOptions"
        panel.Position = UDim2.new(0, 0, 0, 42)
        panel.Size = UDim2.new(1, 0, 0, 0)
        panel.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        panel.BackgroundTransparency = 0.08
        panel.BorderSizePixel = 0
        panel.Visible = false
        panel.ZIndex = 12
        Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
        local panelStroke = Instance.new("UIStroke", panel)
        panelStroke.Color = ORANGE
        panelStroke.Thickness = 1
        panelStroke.Transparency = 0.35
        local grid = Instance.new("UIGridLayout", panel)
        grid.CellSize = UDim2.new(0.31, 0, 0, 25)
        grid.CellPadding = UDim2.new(0, 5, 0, 5)
        grid.FillDirectionMaxCells = 3
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.VerticalAlignment = Enum.VerticalAlignment.Top
        for index, option in ipairs(options) do
            local button = Instance.new("TextButton", panel)
            button.Name = "AnimationOption_" .. tostring(index)
            button.LayoutOrder = index
            button.BackgroundColor3 = option == currentAnimPack and ORANGE or Color3.fromRGB(12, 12, 12)
            button.BorderSizePixel = 0
            button.Text = option
            button.TextColor3 = option == currentAnimPack and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(230, 230, 230)
            button.Font = Enum.Font.GothamBold
            button.TextSize = 10
            button.TextTruncate = Enum.TextTruncate.AtEnd
            button.AutoButtonColor = false
            button.ZIndex = 13
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)
            button.Activated:Connect(function()
                applyAnimationPack(option)
                for _, other in ipairs(panel:GetChildren()) do
                    if other:IsA("TextButton") then
                        local selected = other.Text == option
                        other.BackgroundColor3 = selected and ORANGE or Color3.fromRGB(12, 12, 12)
                        other.TextColor3 = selected and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(230, 230, 230)
                    end
                end
                panel.Visible = false
                wrapper.Size = UDim2.new(1, -4, 0, 40)
                choice.Text = tostring(option) .. "  ▼"
                task.defer(saveAllSettings)
            end)
        end
        local function refreshAnimationSelector(value)
            choice.Text = tostring(value or currentAnimPack) .. "  ▼"
            for _, button in ipairs(panel:GetChildren()) do
                if button:IsA("TextButton") then
                    local selected = button.Text == (value or currentAnimPack)
                    button.BackgroundColor3 = selected and ORANGE or Color3.fromRGB(12, 12, 12)
                    button.TextColor3 = selected and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(230, 230, 230)
                end
            end
        end
        animationSelectorRefresh = refreshAnimationSelector
        choice.Activated:Connect(function()
            local opening = not panel.Visible
            panel.Visible = opening
            if opening then
                local rows = math.ceil(#options / 3)
                local height = rows * 25 + math.max(0, rows - 1) * 5 + 8
                panel.Size = UDim2.new(1, 0, 0, height)
                wrapper.Size = UDim2.new(1, -4, 0, 48 + height)
                choice.Text = tostring(currentAnimPack) .. "  ▲"
            else
                wrapper.Size = UDim2.new(1, -4, 0, 40)
                choice.Text = tostring(currentAnimPack) .. "  ▼"
            end
        end)
    end

    local rainbowSetVisual = mkToggle(visualPage, "Rainbow Tools", function(on)
        rainbowToolsEnabled = on
        if _G.RaptureRainbowTools then _G.RaptureRainbowTools.setEnabled(on) end
        task.defer(saveAllSettings)
    end)

    local transparentSetVisual = mkToggle(visualPage, "Transparent Tools", function(on)
        transparentToolsEnabled = on
        if _G.RaptureTransparentTools then _G.RaptureTransparentTools.setEnabled(on) end
        task.defer(saveAllSettings)
    end)

    local customToolsSetVisual = mkToggle(visualPage, "Custom Tools", function(on)
        customToolsEnabled = on
        if _G.RaptureCustomTools then _G.RaptureCustomTools.setEnabled(on) end
        task.defer(saveAllSettings)
    end)

    local toolSkinRefresh
    toolSkinRefresh = mkCollapsibleSlider(visualPage, "Custom Tool Skin",
        {"Sword", "Katana", "Skull", "Eagle"},
        function()
            if customToolSkin == "Katana" then return "Katana"
            elseif customToolSkin == "Skull" then return "Skull"
            elseif customToolSkin == "GoldenDesertEagle" then return "Eagle"
            else return "Sword" end
        end,
        function(v)
            local mapped = "DiamondSword"
            if v == "Katana" then mapped = "Katana"
            elseif v == "Skull" then mapped = "Skull"
            elseif v == "Eagle" then mapped = "GoldenDesertEagle" end
            customToolSkin = mapped
            if _G.RaptureSetCustomToolSkin then
                pcall(_G.RaptureSetCustomToolSkin, "Bat", mapped)
                pcall(_G.RaptureSetCustomToolSkin, "Medusa", mapped)
            end
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end)
    toolSkinSetVisual = toolSkinRefresh

    local customSoundsSetVisual = mkToggle(visualPage, "Custom Sounds", function(on)
        customSoundsEnabled = on
        if _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(on) end
        task.defer(saveAllSettings)
    end)

    -- === CONFIG PAGE ===
    local configPage = contentPages["Config"]

    uiScaleBox = mkStepRow(configPage, "UI Scale",
        function() return uiScaleValue end,
        function(v)
            uiScaleValue = v
            if mainUIScale then mainUIScale.Scale = v / 100 end
        end, 50, 150, 1)

    progressBarScaleBox = mkStepRow(configPage, "Progress Bar Scale",
        function() return progressBarScaleValue end,
        function(v)
            progressBarScaleValue = v
            if pbScale then pbScale.Scale = v / 100 end
        end, 50, 150, 1)

    local floatScaleLabel = mkStepRow(configPage, "Button Scale",
        function() return _floor(floatingButtonScale * 100) end,
        function(v)
            floatingButtonScale = v / 100
            applyFloatingButtonScale()
        end, 50, 200, 1)

    do
        local row = mkRow(configPage, 44)
        mkLabel(row, "Background Image")
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -92, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(18, 14, 24)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = "PICK"
        btn.TextColor3 = getThemeColor()
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 10
        btn.ZIndex = 8
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn.Activated:Connect(function() openImagePicker() end)
    end

    do
        local row = mkRow(configPage, 40)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -8, 0.85, 0)
        delBtn.Position = UDim2.new(0, 4, 0.07, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        delBtn.BackgroundTransparency = 0.3
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE CONFIG"
        delBtn.TextColor3 = WHITE
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 10)
        local deleteState = 0
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = "DELETE CONFIG"
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                pcall(resetToFactoryDefaults)
                task.defer(function()
                    if setAntiRagVisual then setAntiRagVisual(false) end
                    if setInstaGrab then setInstaGrab(false) end
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
                    if setBatCounterVisual then setBatCounterVisual(false) end
                    if setMedusaVisual then setMedusaVisual(false) end
                    if setRagdollTimerVisual then setRagdollTimerVisual(false) end
                    if autoLeftSetVisual then autoLeftSetVisual(false) end
                    if autoRightSetVisual then autoRightSetVisual(false) end
                    if autoBatSetVisual then autoBatSetVisual(false) end
                    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
                    if batBypassSetVisual then batBypassSetVisual(false) end
                    if setESPVisual then setESPVisual(false) end
                    if setAntiLagVisual then setAntiLagVisual(false) end
                    if setFovVisual then setFovVisual(false) end
                    if setAntiDieVisual then setAntiDieVisual(false) end
                    if setAntiFlingVisual then setAntiFlingVisual(false) end
                    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
                    if aimbotModeSetVisual then aimbotModeSetVisual("V1") end
                    if antiRagSetVisual then antiRagSetVisual("V1") end
                    if stealModeSetVisual then stealModeSetVisual("Normal") end
                    if rainbowSetVisual then rainbowSetVisual(false) end
                    if transparentSetVisual then transparentSetVisual(false) end
                    if customToolsSetVisual then customToolsSetVisual(false) end
                    if customSoundsSetVisual then customSoundsSetVisual(false) end
                    refreshSpeedModeLabel()
                end)
                delBtn.Text = "DELETED"
                task.delay(1.5, function() if delBtn and delBtn.Parent then delBtn.Text = "DELETE CONFIG"; delDebounce = false; deleteState = 0 end end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "TP BAT", KB.TPBat)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    addKeybindRow(keyPage, "Bat V2", KB.BatBypass)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    -- ==================== BARRA DE STEAL ====================
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Size = UDim2.new(0, 480, 0, 76)
    pbFrame.Position = UDim2.new(0.5, -240, 1, -90)
    pbFrame.BackgroundColor3 = BLACK_BG
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = true
    pbFrame.ZIndex = 10
    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = progressBarScaleValue / 100
    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -240, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -90)
    end
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 16)
    local border = Instance.new("UIStroke", pbFrame)
    border.Color = BLACK_STROKE
    border.Thickness = 1.5
    border.Transparency = 0.3
    local topRow = Instance.new("Frame", pbFrame)
    topRow.Size = UDim2.new(1, 0, 0, 26)
    topRow.Position = UDim2.new(0, 0, 0, 6)
    topRow.BackgroundTransparency = 1
    topRow.ZIndex = 12
    progressPct = Instance.new("TextLabel", topRow)
    progressPct.Size = UDim2.new(0.4, 0, 1, 0)
    progressPct.Position = UDim2.new(0, 14, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(255,255,255)
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 16
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    progressPct.TextStrokeTransparency = 0.2
    progressPct.ZIndex = 13
    fpsLabel = Instance.new("TextLabel", topRow)
    fpsLabel.Size = UDim2.new(0.3, 0, 1, 0)
    fpsLabel.Position = UDim2.new(0.35, 0, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: --"
    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextSize = 14
    fpsLabel.TextScaled = true
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
    fpsLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    fpsLabel.TextStrokeTransparency = 0.2
    fpsLabel.ZIndex = 13
    msLabel = Instance.new("TextLabel", topRow)
    msLabel.Size = UDim2.new(0.3, 0, 1, 0)
    msLabel.Position = UDim2.new(0.65, 0, 0, 0)
    msLabel.BackgroundTransparency = 1
    msLabel.Text = "MS: --"
    msLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    msLabel.Font = Enum.Font.GothamBold
    msLabel.TextSize = 14
    msLabel.TextScaled = true
    msLabel.TextXAlignment = Enum.TextXAlignment.Right
    msLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    msLabel.TextStrokeTransparency = 0.2
    msLabel.ZIndex = 13
    local progressRow = Instance.new("Frame", pbFrame)
    progressRow.Size = UDim2.new(1, -20, 0, 20)
    progressRow.Position = UDim2.new(0, 10, 0, 46)
    progressRow.BackgroundTransparency = 1
    progressRow.ZIndex = 11
    local fillRegion = Instance.new("Frame", progressRow)
    fillRegion.Size = UDim2.new(1, 0, 1, 0)
    fillRegion.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fillRegion.BackgroundTransparency = 0.15
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 12
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(0, 10)
    local frStroke = Instance.new("UIStroke", fillRegion)
    frStroke.Color = Color3.fromRGB(255, 255, 255)
    frStroke.Thickness = 1
    frStroke.Transparency = 0.2
    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = ORANGE
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 13
    progressFill.ClipsDescendants = true
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 10)
    -- No colocar una imagen encima: así el relleno naranja siempre queda visible.
    stealBarImage = nil
    -- ✅ Degradado naranja para la barra de Steal
    local glowGrad = Instance.new("UIGradient", progressFill)
    glowGrad.Color = ColorSequence.new(STEAL_GRADIENT)
    glowGrad.Rotation = 90
    drag(pbFrame)
    task.spawn(function()
        local lastFrame = _tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = _tick()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then
                table.insert(fpsSamples, 1 / dt)
                if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                local sum = 0
                for _, v in ipairs(fpsSamples) do sum = sum + v end
                fpsAvg = sum / #fpsSamples
            end
        end)
        while true do
            local ping = 0
            pcall(function() ping = LP:GetNetworkPing() * 1000 end)
            if fpsLabel then fpsLabel.Text = string.format("FPS: %d", _floor(fpsAvg + 0.5)) end
            if msLabel then msLabel.Text = string.format("MS: %d", _floor(ping + 0.5)) end
            task.wait(0.5)
        end
    end)
    drag(main)
end

-- ============================================================
-- UI AUX
-- ============================================================
function openImagePicker()
    pcall(function()
        local old = CoreGui:FindFirstChild("RaptureImagePicker")
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then local o = pg:FindFirstChild("RaptureImagePicker"); if o then o:Destroy() end end
    end)
    local viewer = Instance.new("ScreenGui")
    viewer.Name = "RaptureImagePicker"
    viewer.ResetOnSpawn = false
    viewer.IgnoreGuiInset = true
    viewer.DisplayOrder = 400
    if not pcall(function() viewer.Parent = CoreGui end) then viewer.Parent = LP:WaitForChild("PlayerGui") end
    local dim = Instance.new("TextButton", viewer)
    dim.Size = UDim2.new(1, 0, 1, 0)
    dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dim.BackgroundTransparency = 0.45
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Activated:Connect(function() viewer:Destroy() end)
    local frame = Instance.new("Frame", viewer)
    frame.Size = UDim2.new(0, 420, 0, 380)
    frame.Position = UDim2.new(0.5, -210, 0.5, -190)
    frame.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local st = Instance.new("UIStroke", frame)
    st.Color = Color3.fromRGB(60,50,75)
    st.Thickness = 1.8
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -48, 0, 30)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "BACKGROUND IMAGE"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -34, 0, 8)
    close.BackgroundColor3 = Color3.fromRGB(28,26,36)
    close.BorderSizePixel = 0
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Font = Enum.Font.GothamBlack
    close.TextSize = 14
    close.ZIndex = 4
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
    close.Activated:Connect(function() viewer:Destroy() end)
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -16, 1, -52)
    scroll.Position = UDim2.new(0, 8, 0, 44)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = getThemeColor()
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 3
    local grid = Instance.new("UIGridLayout", scroll)
    grid.CellSize = UDim2.new(0, 120, 0, 80)
    grid.CellPadding = UDim2.new(0, 8, 0, 8)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    for i, id in ipairs(backgroundImages) do
        local thumb = Instance.new("TextButton", scroll)
        thumb.Size = UDim2.new(0, 120, 0, 80)
        thumb.BackgroundColor3 = Color3.fromRGB(20, 18, 26)
        thumb.BorderSizePixel = 0
        thumb.Text = ""
        thumb.LayoutOrder = i
        thumb.ZIndex = 4
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8)
        local thumbSt = Instance.new("UIStroke", thumb)
        thumbSt.Color = (backgroundIndex == i) and getThemeColor() or Color3.fromRGB(60, 50, 75)
        thumbSt.Thickness = (backgroundIndex == i) and 2 or 1
        thumbSt.Transparency = (backgroundIndex == i) and 0 or 0.4
        local img = Instance.new("ImageLabel", thumb)
        img.Size = UDim2.new(1, -8, 1, -8)
        img.Position = UDim2.new(0, 4, 0, 4)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://" .. id
        img.ScaleType = Enum.ScaleType.Crop
        img.ZIndex = 5
        Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
        thumb.Activated:Connect(function()
            viewer:Destroy()
            task.defer(function()
                pcall(function()
                    backgroundIndex = i
                    saveAllSettings()
                    local bgImg = main and main:FindFirstChild("BackgroundImage")
                    if bgImg then
                        bgImg.Image = "rbxassetid://" .. id
                        bgImg.ImageTransparency = backgroundImageTransparency
                    end
                    if stealBarImage then
                        stealBarImage.Image = "rbxassetid://" .. id
                    end
                end)
            end)
        end)
    end
end

-- ============================================================
-- MOBILE PANEL + FLOATING BUTTONS
-- ============================================================
function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    -- Retirar instancias de la versión anterior para evitar botones duplicados al volver a ejecutar.
    for _, host in ipairs({CoreGui, LP:FindFirstChildOfClass("PlayerGui")}) do
        if host then
            for _, guiName in ipairs({"RaptureDuelMobilePanel", "YoutMobilePanel", "BatBypassButton"}) do
                local oldGui = host:FindFirstChild(guiName)
                if oldGui then pcall(function() oldGui:Destroy() end) end
            end
        end
    end
    panel.Name = "YoutMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local BTN_W, BTN_H = 60, 60
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nNORMAL", "LAGGER\nCARRY"}
    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local btn = Instance.new("TextButton", panel)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        local buttonScale = Instance.new("UIScale", btn)
        buttonScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, buttonScale)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10
        local savedPos = savedButtonPositions[name]
        if savedPos and (tonumber(savedPos.X) or 0) < 0 then
            -- Positions below zero belonged to the old grid on the right side.
            savedButtonPositions[name] = nil
            savedPos = nil
        end
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252,252,253)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233,233,236)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168,168,176)),
        })
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(120,120,128)
        stroke.Thickness = 1
        stroke.Transparency = 0.55
        stroke.Name = "NormalStroke"
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(32,32,40)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 11
        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            paintFloatingBtn(btn, state)
        end
        setActive(false)
        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                hasMoved = false
                movedDistance = 0
                dragStart = input.Position
                startPos = btn.Position
                _isDraggingButton = true
            end
        end)
        btn.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if name == "DropBR" then
                            if not autoBatEnabled then
                                setActive(true)
                                executeDropWithToggle(function(v) if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end end)
                                task.delay(0.3, function() setActive(false) end)
                            end
                        elseif name == "AutoLeft" then
                            autoLeftEnabled = not autoLeftEnabled
                            setActive(autoLeftEnabled)
                            if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
                        elseif name == "AutoBat" then
                            if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                            setActive(autoBatEnabled)
                        elseif name == "AutoRight" then
                            autoRightEnabled = not autoRightEnabled
                            setActive(autoRightEnabled)
                            if autoRightEnabled then startAutoRight() else stopAutoRight() end
                            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
                        elseif name == "TpDown" then
                            doTpDown()
                            setActive(true)
                            task.delay(0.2, function() setActive(false) end)
                        elseif name == "Carry" then
                            if not speedMode then
                                speedMode = true
                                laggerToggled = false
                                laggerCarryToggled = false
                                setActive(true)
                                if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                                if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                            else
                                speedMode = false
                                setActive(false)
                            end
                            refreshSpeedModeLabel()
                        elseif name == "Lagger1" then
                            if not laggerToggled then
                                laggerToggled = true
                                speedMode = false
                                laggerCarryToggled = false
                                setActive(true)
                                if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end
                                if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                            else
                                laggerToggled = false
                                setActive(false)
                            end
                            refreshSpeedModeLabel()
                        elseif name == "Lagger2" then
                            if not laggerCarryToggled then
                                laggerCarryToggled = true
                                speedMode = false
                                laggerToggled = false
                                setActive(true)
                                if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end
                                if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                            else
                                laggerCarryToggled = false
                                setActive(false)
                            end
                            refreshSpeedModeLabel()
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = {
                            X = btn.Position.X.Offset,
                            Y = btn.Position.Y.Offset
                        }
                        task.defer(saveAllSettings)
                    end
                    dragging = false
                    hasMoved = false
                    dragStart = nil
                    startPos = nil
                    movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end)
        buttons[name] = {btn = btn, setActive = setActive, label = label}
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end
    if buttons.AutoLeft then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoBat then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoRight then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 then buttons.Lagger2.setActive(laggerCarryToggled) end
    return panel
end

function createTpBatFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    btnFrame.Position = tpBatFloatingPos and UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10) or UDim2.new(0.5, 20, 0, 10)
    btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(12,12,12)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0)),
    })
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = ORANGE
    stroke.Thickness = 1
    stroke.Transparency = 0.55
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = ORANGE
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21
    paintFloatingBtn(btnFrame, false)
    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleBatDesyncTp()
                    paintFloatingBtn(btnFrame, batDesyncTpEnabled)
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }
                    task.defer(saveAllSettings)
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    tpBatFloatingButton = panel
    return panel
end

function createBatBypassFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BatBypassButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 22
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end

    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    btnFrame.Position = batBypassFloatingPos and UDim2.new(
        batBypassFloatingPos.XScale or 0.5, batBypassFloatingPos.XOffset or 180,
        batBypassFloatingPos.YScale or 0, batBypassFloatingPos.YOffset or 10
    ) or UDim2.new(0.5, 180, 0, 10)
    btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)

    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(12, 12, 12)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })

    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = ORANGE
    stroke.Thickness = 1
    stroke.Transparency = 0.55

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BAT\nV2"
    label.TextColor3 = ORANGE
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21

    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)

    local function refresh()
        local enabled = _G._RaptureBatBypass and _G._RaptureBatBypass.enabled == true
        paintFloatingBtn(btnFrame, enabled)
    end
    refresh()

    local dragging, hasMoved, dragStart, startPos = false, false, nil, nil
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = inp.Position
            startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if not dragging then return end
        if not hasMoved then
            if _G.RaptureToggleBatBypass then _G.RaptureToggleBatBypass() end
            refresh()
            if batBypassSetVisual then
                batBypassSetVisual(_G._RaptureBatBypass and _G._RaptureBatBypass.enabled == true)
            end
        elseif not uiLocked then
            batBypassFloatingPos = {
                XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset,
                YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset,
            }
            task.defer(saveAllSettings)
        end
        dragging = false
        hasMoved = false
        dragStart = nil
        startPos = nil
    end)

    batBypassFloatingButton = panel
    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    btnFrame.Position = instaResetFloatingPos and UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or 100, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10) or UDim2.new(0.5, 100, 0, 10)
    btnFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(12,12,12)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0)),
    })
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = ORANGE
    stroke.Thickness = 1
    stroke.Transparency = 0.55
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "INSTA\nRESET"
    label.TextColor3 = ORANGE
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21
    paintFloatingBtn(btnFrame, false)
    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos, activeInput
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            activeInput = inp
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging or not activeInput then return end
        local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput
        local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType == Enum.UserInputType.MouseMovement
        if not isTouchMove and not isMouseMove then return end
        local delta = inp.Position - dragStart
        if delta.Magnitude > 12 then hasMoved = true end
        if hasMoved and not uiLocked then
            btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp ~= activeInput then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then
            if not hasMoved then
                if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
                paintFloatingBtn(btnFrame, true)
                task.delay(0.45, function()
                    if btnFrame and btnFrame.Parent then paintFloatingBtn(btnFrame, false) end
                end)
            elseif not uiLocked and hasMoved then
                instaResetFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }
                task.defer(saveAllSettings)
            end
            dragging = false; hasMoved = false; activeInput = nil
        end
    end)
    instaResetFloatingButton = panel
    return panel
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if animationSelectorRefresh then animationSelectorRefresh(currentAnimPack) end
    if HEARTLESSMusicTrackRefresh then HEARTLESSMusicTrackRefresh() end
    if HEARTLESSMusicSetVisual then HEARTLESSMusicSetVisual(HEARTLESSMusicEnabled) end
    if HEARTLESSMusicEnabled then playHEARTLESSMusic(HEARTLESSSelectedSongIndex) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if autoCarryEnabled then
        if setAutoCarryVisual then setAutoCarryVisual(true) end
        startAutoCarry()
    elseif setAutoCarryVisual then
        setAutoCarryVisual(false)
    end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if progressBarScaleBox then progressBarScaleBox.Text = tostring(progressBarScaleValue) end
    if stretchValueBox then stretchValueBox.Text = tostring(stretchValue) end
    if _G.RaptureBatAimbotV2BypassBox then
        _G.RaptureBatAimbotV2BypassBox.Text = tostring(_G.RaptureBatAimbotV2TPDistance or 8)
    end
    refreshSpeedModeLabel()
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -240, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -90)
    end
    local bgImg = main and main:FindFirstChild("BackgroundImage")
    if bgImg then
        bgImg.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        bgImg.ImageTransparency = backgroundImageTransparency
    end
    if stealBarImage then
        stealBarImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    end
    applyFloatingButtonScale()
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if bodyLockEnabled then
        if bodyLockSetVisual then bodyLockSetVisual(true) end
        if _blSuppressCount == 0 then startBodyLock() end
    else
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        stopBodyLock()
    end
    if currentAnimPack ~= "Off" then applyAnimationPack(currentAnimPack) end
    if antiRagdollEnabled then
        if setAntiRagVisual then setAntiRagVisual(true) end
        if antiRagdollVersion == "v1" then AntiRagdollV1.start()
        elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end
    end
    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        _antiDie.StartEngine()
    end
    if antiFlingEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        startAntiFling()
    end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if medusaCounterEnabled and setMedusaVisual then setMedusaVisual(true); if LP.Character then setupMedusaCounter(LP.Character) end end
    if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true); startBatCounter() end
    if ragdollCountdownEnabled and setRagdollTimerVisual then setRagdollTimerVisual(true); hookRagdollCountdown(LP.Character) end
    if espEnabled and setESPVisual then setESPVisual(true); startESP() end
    if antiLagEnabled and setAntiLagVisual then setAntiLagVisual(true); enableAntiLag() end
    if stretchEnabled and _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    if setFovVisual then setFovVisual(fovEnabled) end
    if fovSliderSet then fovSliderSet(fovValue) end
    if batDesyncTpEnabled then
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        if not batDesyncTpConn then startBatDesyncTp() end
    end
    if batBypassEnabled then
        if batBypassSetVisual then batBypassSetVisual(true) end
        if not _G._RaptureBatBypass.enabled then _G.RaptureStartBatBypass() end
    end
    if aimbotModeSetVisual then aimbotModeSetVisual(aimbotMode) end
    if antiRagSetVisual then antiRagSetVisual(antiRagdollVersion == "v1" and "V1" or "V2") end
    if stealModeSetVisual then stealModeSetVisual(stealMode == "V2" and "V2" or "Normal") end
    if rainbowToolsEnabled and _G.RaptureRainbowTools then _G.RaptureRainbowTools.setEnabled(true) end
    if transparentToolsEnabled and _G.RaptureTransparentTools then _G.RaptureTransparentTools.setEnabled(true) end
    if customToolsEnabled and _G.RaptureCustomTools then _G.RaptureCustomTools.setEnabled(true) end
    if customSoundsEnabled and _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(true) end
    if _G.RaptureSetCustomToolSkin and customToolSkin then
        pcall(_G.RaptureSetCustomToolSkin, "Bat", customToolSkin)
        pcall(_G.RaptureSetCustomToolSkin, "Medusa", customToolSkin)
    end
    startEnemySpeed()
    toggleLockUI(uiLocked)
end

-- ============================================================
-- INICIALIZACIÓN
-- ============================================================
buildGui()

if loadAllSettings() then
    updateUIFromLoaded()
end

task.defer(function()
    task.wait(0.15)
    if _RaptureApplyThemeToSliders then _RaptureApplyThemeToSliders() end
    for _, entry in ipairs(_G._RaptureDynamicSliders) do
        pcall(function() entry.applyThemeColor(PASTEL_PINK) end)
    end
end)

speedMode = false
laggerToggled = false
laggerCarryToggled = false
refreshSpeedModeLabel()

MobilePanel = createMobilePanel()
tpBatFloatingButton = createTpBatFloatingButton()
batBypassFloatingButton = createBatBypassFloatingButton()
instaResetFloatingButton = createInstaResetFloatingButton()

if LP.Character then
    task.wait(0.1)
    if waitForCharReady(LP.Character, 5) then
        setupMovementAndIndicators(LP.Character)
        captureOriginalAnimations(LP.Character)
        if currentAnimPack ~= "Off" then applyAnimationPack(currentAnimPack) end
        if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end
    end
end

LP.CharacterAdded:Connect(function(char)
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    if not _tpBatUnwalkForced then stopUnwalk() end
    stopDropBrainrot()
    if autoBatEnabled then disableAutoBat() end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    task.wait(0.5)
    if not char.Parent then return end
    _hookedVelParts = {}
    _setupVelChecked(char)
    setupMovementAndIndicators(char)
    _blSuppressCount = 0
    _blWasEnabled = false
    task.defer(function()
        if not char.Parent then return end
        waitForCharReady(char, 5)
        captureOriginalAnimations(char)
        if currentAnimPack ~= "Off" then applyAnimationPack(currentAnimPack) end
        if bodyLockEnabled then
            if bodyLockSetVisual then bodyLockSetVisual(true) end
            startBodyLock()
        end
    end)
    if antiRagdollEnabled then
        if antiRagdollVersion == "v1" then AntiRagdollV1.start()
        elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end
    end
    if antiDieEnabled then _antiDie.StartEngine() end
    if antiFlingEnabled then startAntiFling() end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
    if batDesyncTpEnabled then task.defer(startBatDesyncTp) end
    if medusaCounterEnabled then setupMedusaCounter(char) end
    if batCounterEnabled then startBatCounter() end
    if espEnabled then stopESP(); task.wait(0.2); startESP() end
    if ragdollCountdownEnabled then hookRagdollCountdown(char) end
    if unwalkEnabled and not _tpBatUnwalkForced then startUnwalk() end
    refreshSpeedModeLabel()
end)

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end
    local kc = input.KeyCode
    if not kc then return end
    if kbMatch(KB.LaggerMode, kc) then
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.InstaReset, kc) then
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
        return
    end
    if kbMatch(KB.BatBypass, kc) then
        _G.RaptureToggleBatBypass()
        if batBypassSetVisual then batBypassSetVisual(_G._RaptureBatBypass.enabled) end
        return
    end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.TPBat, kc) then
        toggleBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

-- ============================================================
-- SKINS Y SONIDOS DE BATE Y MEDUSA (fuente proporcionada)
-- ============================================================
-- ============================================================
-- shel.Vs: VISUAL DE ESPADA NO BASTAO
-- Transferido do Moraes tlgd (somente a funcao visual da katana).
-- ============================================================
do
    local SwordPlayers = game:GetService("Players")
    local SwordLP = SwordPlayers.LocalPlayer

    local KATANA_MESH = "rbxassetid://13528902482"
    local KATANA_TEXTURE = "rbxassetid://13528902373"

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
    end

    local function applySwordVisual(tool)
        if not isBatTool(tool) then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end

        local oldReplica = handle:FindFirstChild("ShelSwordReplica")
        if oldReplica then oldReplica:Destroy() end

        local model = Instance.new("Model")
        model.Name = "ShelSwordReplica"

        local part = Instance.new("Part")
        part.Name = "SwordPart"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 0
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.Anchored = false
        part.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = KATANA_MESH
        -- Sem textura: assim a lamina/espada em si fica colorida (arco-iris)
        mesh.TextureId = ""
        mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
        mesh.Parent = part

        -- Espada colorida (arco-iris animado)
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromHSV(0, 1, 1)
        part.Reflectance = 0.1
        mesh.VertexColor = Vector3.new(1, 1, 1)

        local glow = Instance.new("PointLight")
        glow.Name = "ShelSwordGlow"
        glow.Brightness = 3
        glow.Range = 12
        glow.Color = part.Color
        glow.Parent = part

        _G.ShelSwordRainbowParts = _G.ShelSwordRainbowParts or {}
        table.insert(_G.ShelSwordRainbowParts, { part = part, mesh = mesh, light = glow })

        model.PrimaryPart = part
        model.Parent = handle
        part.CFrame = handle.CFrame * (
            CFrame.new(0, 0.6, 0)
            * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180))
        )

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part

        -- Esconde o bastao original e mostra somente a espada.
        pcall(function() handle.Transparency = 1 end)
    end

    local function watchContainer(container)
        if not container then return end

        for _, child in ipairs(container:GetChildren()) do
            if isBatTool(child) then
                task.defer(applySwordVisual, child)
            end
        end

        if not container:GetAttribute("ShelSwordVisualWatch") then
            container:SetAttribute("ShelSwordVisualWatch", true)
            container.ChildAdded:Connect(function(child)
                if not isBatTool(child) then return end
                task.wait()
                applySwordVisual(child)
            end)
        end
    end

    local function scanSwordTools()
        watchContainer(SwordLP:FindFirstChildOfClass("Backpack"))
        watchContainer(SwordLP.Character)
    end

    scanSwordTools()

    SwordLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            watchContainer(child)
        end
    end)

    SwordLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchContainer(character)
        scanSwordTools()
    end)

    task.spawn(function()
        while task.wait(1) do
            scanSwordTools()
        end
    end)

    -- Loop unico que anima as cores da espada
    if not _G.ShelSwordRainbowLoop then
        _G.ShelSwordRainbowLoop = true
        _G.ShelSwordRainbowSpeed = _G.ShelSwordRainbowSpeed or 0.35
        task.spawn(function()
            while task.wait(0.03) do
                local list = _G.ShelSwordRainbowParts
                if list then
                    local hue = (tick() * (_G.ShelSwordRainbowSpeed or 0.35)) % 1
                    local color = Color3.fromHSV(hue, 1, 1)
                    for i = #list, 1, -1 do
                        local entry = list[i]
                        if entry and entry.part and entry.part.Parent then
                            entry.part.Color = color
                            if entry.mesh then
                                entry.mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
                            end
                            if entry.light then
                                entry.light.Color = color
                            end
                        else
                            table.remove(list, i)
                        end
                    end
                end
            end
        end)
    end

    _G.ShelSwordVisual = {
        apply = scanSwordTools,
        mesh = KATANA_MESH,
        texture = KATANA_TEXTURE,
        rainbow = true,
    }
end
-- ============================================================
-- FIM shel.Vs: VISUAL DE ESPADA NO BASTAO
-- ============================================================


-- ============================================================
-- shel.Vs: SONIDO DE LA ESPADA (TRANSFERIDO DEL MORAES TLGD)
-- Espada: rbxassetid://5713085119
-- ============================================================
do
    local SoundPlayers = game:GetService("Players")
    local SoundLP = SoundPlayers.LocalPlayer
    local SWORD_SOUND = "rbxassetid://5713085119"
    local hookedTools = setmetatable({}, {__mode = "k"})
    local customSounds = setmetatable({}, {__mode = "k"})

    local function isSwordTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
            or name:find("sword", 1, true) ~= nil or name:find("knife", 1, true) ~= nil
            or name:find("espada", 1, true) ~= nil
    end

    local function makeCustomSound(parent)
        local old = customSounds[parent]
        if old and old.Parent then
            old.SoundId = SWORD_SOUND
            return old
        end
        local sound = Instance.new("Sound")
        sound.Name = "ShelCustomToolSound"
        sound.SoundId = SWORD_SOUND
        sound.Volume = 1
        sound.Looped = false
        sound.Parent = parent
        customSounds[parent] = sound
        return sound
    end

    local function playCustomSound(parent)
        if not parent or not parent.Parent then return end
        local sound = makeCustomSound(parent)
        pcall(function()
            sound:Stop()
            sound.TimePosition = 0.2
            sound.Volume = 1
            sound:Play()
        end)
    end

    local function hookTool(tool)
        if not isSwordTool(tool) or hookedTools[tool] then return end
        hookedTools[tool] = true
        local hookedSounds = setmetatable({}, {__mode = "k"})

        local function hookSound(sound)
            if not sound:IsA("Sound") or sound.Name == "ShelCustomToolSound" or hookedSounds[sound] then return end
            hookedSounds[sound] = true
            local triggering = false
            local function trigger()
                if triggering or not sound.Parent then return end
                if sound.Playing or sound.TimePosition > 0 then
                    triggering = true
                    pcall(function()
                        sound.Volume = 0
                        sound:Stop()
                    end)
                    playCustomSound(sound.Parent)
                    triggering = false
                end
            end
            sound:GetPropertyChangedSignal("Playing"):Connect(trigger)
            sound:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
        end

        for _, descendant in ipairs(tool:GetDescendants()) do
            hookSound(descendant)
        end
        tool.DescendantAdded:Connect(hookSound)
    end

    local function watchContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(hookTool, child) end
        end
        if not container:GetAttribute("ShelToolSoundWatch") then
            container:SetAttribute("ShelToolSoundWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                hookTool(child)
            end)
        end
    end

    local function scanSoundTools()
        watchContainer(SoundLP:FindFirstChildOfClass("Backpack"))
        watchContainer(SoundLP.Character)
    end

    scanSoundTools()
    SoundLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchContainer(child) end
    end)
    SoundLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchContainer(character)
        scanSoundTools()
    end)
    task.spawn(function()
        while task.wait(1) do scanSoundTools() end
    end)

    _G.ShelSwordSound = {
        apply = scanSoundTools,
        SwordSound = SWORD_SOUND,
    }
end
-- ============================================================
-- FIM shel.Vs: SONIDO DE LA ESPADA
-- ============================================================



task.defer(function()
    task.wait(0.1)
    _RaptureApplyThemeToSliders()
end)

print("===========================================")
print("  RAPTURE DUEL CARGADO v3.3.1")
print("  ✅ Imagen de Rapture 120x120 en el botón mini")
print("  ✅ Imagen del menú 380x95")
print("  ✅ Auto Left y Auto Right debajo de Drop Brainrot")
print("  ✅ Body Lock con rango ajustable integrado")
print("  ✅ 12 estilos de animación seleccionables + Off")
print("  ✅ Auto Carry Speed en la pestaña Speed")
print("  ✅ Reproductor HEARTLESS con 21 pistas")
print("  ✅ Ocho botones flotantes de Updateyoutv12; música solo en Visual")
print("  ✅ Barra de Steal con degradado Naranja")
print("===========================================")