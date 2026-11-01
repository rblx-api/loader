-- LocalScript -> colócalo en StarterGui (Roblox Studio)
-- Intro Ghoxt Hub: cartas (barajar -> abanico -> as) + tarjeta tipo Spotify "Now Playing"
-- con lluvia de luces LED rojas, música opcional y botón Skip Intro

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- CONFIGURACIÓN
----------------------------------------------------------------
local CONFIG = {
	Name = "GHOXT HUB",
	Tagline = "LOADING",
	Discord = "discord.gg/NZgavmpdM",
	Images = {
		"rbxassetid://106897611019941",
		"rbxassetid://79999011724260",
		"rbxassetid://115940405819747",
	},
	CardIntro = true,  -- false = salta directo a la tarjeta tipo Spotify
	TotalDuration = 8, -- duración TOTAL de la intro completa (cartas + tarjeta), en segundos
	FadeTime = 0.6,    -- crossfade entre imágenes de la portada

	-- Música: pega aquí el ID de tu audio (subido a Creator Hub o de la librería de Roblox)
	-- Ejemplo: "rbxassetid://1234567890". Déjalo vacío ("") para no usar música.
	MusicId = "rbxassetid://2637276471",
	MusicVolume = 0.7,
	MusicStart = 0,    -- segundo de la canción desde donde empieza

	RainCount = 55,    -- gotas de la lluvia LED (baja a 30 si va lento en móvil)
}

local COLORS = {
	Background    = Color3.fromRGB(0, 0, 0),
	BackgroundEnd = Color3.fromRGB(0, 0, 0),
	Panel         = Color3.fromRGB(22, 5, 10),
	DarkRed       = Color3.fromRGB(150, 16, 32),
	Red           = Color3.fromRGB(215, 30, 48),
	Light         = Color3.fromRGB(255, 255, 255),
	Dim           = Color3.fromRGB(230, 190, 195),
}

----------------------------------------------------------------
-- HELPERS
----------------------------------------------------------------
local function make(class, parent, props)
	local obj = Instance.new(class)
	for k, v in pairs(props or {}) do
		obj[k] = v
	end
	obj.Parent = parent
	return obj
end

local function round(obj, radius)
	make("UICorner", obj, { CornerRadius = UDim.new(0, radius) })
	return obj
end

local function stroke(obj, color, thickness, transparency)
	return make("UIStroke", obj, {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function tween(obj, time, props, style, direction)
	local t = TweenService:Create(obj, TweenInfo.new(
		time,
		style or Enum.EasingStyle.Quad,
		direction or Enum.EasingDirection.Out
	), props)
	t:Play()
	return t
end

local function fmt(sec)
	return string.format("%d:%02d", math.floor(sec / 60), math.floor(sec % 60))
end

----------------------------------------------------------------
-- GUI BASE
----------------------------------------------------------------
local screen = make("ScreenGui", playerGui, {
	Name = "GhoxtHubIntro",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 1000,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- CanvasGroup para poder desvanecer todo de una vez
local root = make("CanvasGroup", screen, {
	Name = "Root",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = COLORS.Background,
	BorderSizePixel = 0,
	GroupTransparency = 0,
	Active = true, -- bloquea clics hacia atrás
})

-- Fondo con degradado en un Frame aparte (un UIGradient directamente en el
-- CanvasGroup tiñe TODO el contenido y lo oscurece)
local bgFrame = make("Frame", root, {
	Name = "Background",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BorderSizePixel = 0,
	ZIndex = 0,
})
make("UIGradient", bgFrame, {
	Rotation = 35,
	Color = ColorSequence.new(COLORS.Background, COLORS.BackgroundEnd),
})

----------------------------------------------------------------
-- LLUVIA DE LUCES LED ROJAS
----------------------------------------------------------------
local rainLayer = make("Frame", root, {
	Name = "LedRain",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	ZIndex = 1,
})

local rng = Random.new()
local drops = {}

local function resetDrop(d, startAbove)
	d.length = rng:NextInteger(40, 120)
	d.speed = rng:NextInteger(280, 700)
	d.x = rng:NextNumber(0, 1)
	local height = math.max(rainLayer.AbsoluteSize.Y, 400)
	d.y = startAbove and -d.length or rng:NextNumber(-d.length, height)
	d.frame.Size = UDim2.fromOffset(rng:NextInteger(2, 3), d.length)
	d.frame.BackgroundTransparency = rng:NextNumber(0, 0.35)
end

for i = 1, CONFIG.RainCount do
	local frame = make("Frame", rainLayer, {
		Name = "Drop",
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundColor3 = Color3.fromRGB(255, 45, 65),
		BorderSizePixel = 0,
	})
	round(frame, 2)
	-- cola transparente arriba, cabeza brillante abajo
	make("UIGradient", frame, {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(1, 0),
		}),
	})
	local d = { frame = frame }
	resetDrop(d, false)
	drops[i] = d
end

local rainConnection = RunService.Heartbeat:Connect(function(dt)
	local height = rainLayer.AbsoluteSize.Y
	for _, d in ipairs(drops) do
		d.y += d.speed * dt
		if d.y > height then
			resetDrop(d, true)
		end
		d.frame.Position = UDim2.new(d.x, 0, 0, d.y)
	end
end)

----------------------------------------------------------------
-- INTRO DE CARTAS
----------------------------------------------------------------
local deck = make("CanvasGroup", root, {
	Name = "CardIntro",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.46),
	Size = UDim2.fromOffset(560, 320),
	BackgroundTransparency = 1,
	GroupTransparency = 1,
	ZIndex = 2,
})
local deckScale = make("UIScale", deck, { Scale = 1 })

local deckDefs = {
	{ rank = "K",  suit = utf8.char(9829), red = true  }, -- 1 (abajo)
	{ rank = "Q",  suit = utf8.char(9830), red = true  },
	{ rank = "J",  suit = utf8.char(9827), red = false },
	{ rank = "10", suit = utf8.char(9829), red = true  },
	{ rank = "A",  suit = utf8.char(9824), red = false }, -- 5 (arriba, el As)
}

-- posición de cada carta en el abanico (5 cartas, bien repartidas)
local fanSlots = { -2, 2, -1, 1, 0 }
local STACK_Y = 0.44

local cards = {}

local function buildCard(def, index)
	local card = make("CanvasGroup", deck, {
		Name = "Card" .. index,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, STACK_Y, (index - 3) * 2),
		Size = UDim2.fromOffset(112, 158),
		BackgroundColor3 = Color3.fromRGB(16, 5, 9),
		BorderSizePixel = 0,
		Rotation = (index - 3) * 1.5,
		ZIndex = index,
	})
	round(card, 12)
	stroke(card, index == 5 and COLORS.Light or COLORS.Red, 2, 0)
	local scale = make("UIScale", card, { Scale = 1 })

	local color = def.red and Color3.fromRGB(255, 60, 80) or COLORS.Light

	make("TextLabel", card, {
		Position = UDim2.fromOffset(9, 7),
		Size = UDim2.fromOffset(34, 46),
		BackgroundTransparency = 1,
		Text = def.rank .. "\n" .. def.suit,
		TextColor3 = color,
		Font = Enum.Font.GothamBlack,
		TextSize = 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
	make("TextLabel", card, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.52),
		Size = UDim2.fromOffset(80, 80),
		BackgroundTransparency = 1,
		Text = def.suit,
		TextColor3 = color,
		Font = Enum.Font.GothamBlack,
		TextSize = 64,
	})
	make("TextLabel", card, {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -9, 1, -7),
		Size = UDim2.fromOffset(34, 46),
		BackgroundTransparency = 1,
		Text = def.rank .. "\n" .. def.suit,
		TextColor3 = color,
		Font = Enum.Font.GothamBlack,
		TextSize = 20,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Rotation = 180,
	})

	return { card = card, scale = scale }
end

for i, def in ipairs(deckDefs) do
	cards[i] = buildCard(def, i)
end

local nameLabel = make("TextLabel", deck, {
	Name = "Name",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.9),
	Size = UDim2.fromOffset(400, 40),
	BackgroundTransparency = 1,
	Text = CONFIG.Name,
	TextColor3 = COLORS.Light,
	TextTransparency = 1,
	Font = Enum.Font.GothamBlack,
	TextSize = 32,
	ZIndex = 10,
})
local nameLine = make("Frame", deck, {
	Name = "NameLine",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.97),
	Size = UDim2.fromOffset(0, 3),
	BackgroundColor3 = COLORS.Red,
	BorderSizePixel = 0,
	ZIndex = 10,
})
round(nameLine, 2)

----------------------------------------------------------------
-- TARJETA TIPO SPOTIFY (NOW PLAYING)
----------------------------------------------------------------
local nowPlaying = make("CanvasGroup", root, {
	Name = "NowPlaying",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.46, 24),
	Size = UDim2.fromOffset(600, 300),
	BackgroundColor3 = COLORS.Panel,
	BorderSizePixel = 0,
	GroupTransparency = 1,
	ZIndex = 3,
})
round(nowPlaying, 18)
stroke(nowPlaying, COLORS.Red, 2, 0.1)
local playerScale = make("UIScale", nowPlaying, { Scale = 1 })

-- Degradado rojo estilo Spotify (en un frame hijo, no en el CanvasGroup)
local npBg = make("Frame", nowPlaying, {
	Name = "Bg",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BorderSizePixel = 0,
	ZIndex = 0,
})
make("UIGradient", npBg, {
	Rotation = 60,
	Color = ColorSequence.new(Color3.fromRGB(104, 14, 28), Color3.fromRGB(20, 4, 9)),
})

-- Portada (álbum): aquí rotan tus 3 imágenes
local cover = make("Frame", nowPlaying, {
	Name = "Cover",
	Position = UDim2.fromOffset(20, 20),
	Size = UDim2.fromOffset(260, 260),
	BackgroundColor3 = Color3.fromRGB(20, 4, 8),
	BorderSizePixel = 0,
})
round(cover, 10)

local slides = {}
for i, id in ipairs(CONFIG.Images) do
	local slide = make("ImageLabel", cover, {
		Name = "Slide" .. i,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Image = id,
		ScaleType = Enum.ScaleType.Crop,
		ImageTransparency = 1,
		ZIndex = i,
	})
	round(slide, 10)
	slides[i] = slide
end

-- "NOW PLAYING" + ecualizador
make("TextLabel", nowPlaying, {
	Name = "Header",
	Position = UDim2.fromOffset(304, 24),
	Size = UDim2.fromOffset(200, 14),
	BackgroundTransparency = 1,
	Text = "NOW PLAYING",
	TextColor3 = COLORS.Dim,
	Font = Enum.Font.GothamBold,
	TextSize = 10,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local eq = make("Frame", nowPlaying, {
	Name = "Equalizer",
	Position = UDim2.fromOffset(554, 22),
	Size = UDim2.fromOffset(26, 16),
	BackgroundTransparency = 1,
})
local eqBars = {}
for i = 1, 5 do
	local bar = make("Frame", eq, {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, (i - 1) * 5, 1, 0),
		Size = UDim2.fromOffset(3, 6),
		BackgroundColor3 = COLORS.Red,
		BorderSizePixel = 0,
	})
	round(bar, 1)
	eqBars[i] = bar
end

-- Título, "artista" (Discord) y corazón
make("TextLabel", nowPlaying, {
	Name = "Title",
	Position = UDim2.fromOffset(304, 50),
	Size = UDim2.fromOffset(240, 34),
	BackgroundTransparency = 1,
	Text = CONFIG.Name,
	TextColor3 = COLORS.Light,
	Font = Enum.Font.GothamBlack,
	TextSize = 26,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
})

make("TextLabel", nowPlaying, {
	Name = "Artist",
	Position = UDim2.fromOffset(304, 86),
	Size = UDim2.fromOffset(276, 20),
	BackgroundTransparency = 1,
	Text = CONFIG.Discord,
	TextColor3 = COLORS.Dim,
	Font = Enum.Font.GothamMedium,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
})

local heart = make("TextButton", nowPlaying, {
	Name = "Heart",
	Position = UDim2.fromOffset(552, 54),
	Size = UDim2.fromOffset(28, 28),
	BackgroundTransparency = 1,
	Text = utf8.char(9829),
	TextColor3 = COLORS.Red,
	Font = Enum.Font.GothamBold,
	TextSize = 24,
	AutoButtonColor = false,
})
local liked = true
heart.Activated:Connect(function()
	liked = not liked
	heart.TextColor3 = liked and COLORS.Red or COLORS.Dim
end)

local tagline = make("TextLabel", nowPlaying, {
	Name = "Tagline",
	Position = UDim2.fromOffset(304, 128),
	Size = UDim2.fromOffset(276, 18),
	BackgroundTransparency = 1,
	Text = CONFIG.Tagline,
	TextColor3 = COLORS.Red,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
})

-- Barra de progreso estilo reproductor
local track = make("Frame", nowPlaying, {
	Name = "Track",
	Position = UDim2.fromOffset(304, 190),
	Size = UDim2.fromOffset(276, 4),
	BackgroundColor3 = Color3.fromRGB(110, 40, 50),
	BorderSizePixel = 0,
})
round(track, 2)

local fill = make("Frame", track, {
	Name = "Fill",
	Size = UDim2.fromScale(0, 1),
	BackgroundColor3 = COLORS.Light,
	BorderSizePixel = 0,
})
round(fill, 2)

local knob = make("Frame", track, {
	Name = "Knob",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0, 0.5),
	Size = UDim2.fromOffset(12, 12),
	BackgroundColor3 = COLORS.Light,
	BorderSizePixel = 0,
})
round(knob, 6)

local timeLeft = make("TextLabel", nowPlaying, {
	Name = "TimeElapsed",
	Position = UDim2.fromOffset(304, 202),
	Size = UDim2.fromOffset(80, 14),
	BackgroundTransparency = 1,
	Text = "0:00",
	TextColor3 = COLORS.Dim,
	Font = Enum.Font.GothamMedium,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local timeRight = make("TextLabel", nowPlaying, {
	Name = "TimeTotal",
	Position = UDim2.fromOffset(500, 202),
	Size = UDim2.fromOffset(80, 14),
	BackgroundTransparency = 1,
	Text = fmt(CONFIG.TotalDuration),
	TextColor3 = COLORS.Dim,
	Font = Enum.Font.GothamMedium,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Right,
})

-- Controles: anterior / pausa / siguiente (siguiente = saltar la intro)
local prevBtn = make("TextButton", nowPlaying, {
	Name = "Prev",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromOffset(372, 252),
	Size = UDim2.fromOffset(40, 40),
	BackgroundTransparency = 1,
	Text = "«",
	TextColor3 = COLORS.Light,
	Font = Enum.Font.GothamBold,
	TextSize = 30,
	AutoButtonColor = false,
})

local playCircle = make("Frame", nowPlaying, {
	Name = "Play",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromOffset(442, 252),
	Size = UDim2.fromOffset(46, 46),
	BackgroundColor3 = COLORS.Light,
	BorderSizePixel = 0,
})
round(playCircle, 23)
for _, dx in ipairs({ -5, 5 }) do
	local bar = make("Frame", playCircle, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, dx, 0.5, 0),
		Size = UDim2.fromOffset(5, 16),
		BackgroundColor3 = Color3.fromRGB(20, 4, 9),
		BorderSizePixel = 0,
	})
	round(bar, 1)
end

local nextBtn = make("TextButton", nowPlaying, {
	Name = "Next",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromOffset(512, 252),
	Size = UDim2.fromOffset(40, 40),
	BackgroundTransparency = 1,
	Text = "»",
	TextColor3 = COLORS.Light,
	Font = Enum.Font.GothamBold,
	TextSize = 30,
	AutoButtonColor = false,
})

----------------------------------------------------------------
-- BOTÓN SKIP INTRO
----------------------------------------------------------------
local skip = make("TextButton", root, {
	Name = "SkipIntro",
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, -28),
	Size = UDim2.fromOffset(180, 38),
	BackgroundColor3 = COLORS.DarkRed,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Text = "SKIP INTRO  »",
	TextColor3 = COLORS.Light,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	ZIndex = 20,
})
round(skip, 10)
stroke(skip, COLORS.Red, 1.2, 0.2)

skip.MouseEnter:Connect(function()
	tween(skip, 0.15, { BackgroundColor3 = COLORS.Red })
end)
skip.MouseLeave:Connect(function()
	tween(skip, 0.15, { BackgroundColor3 = COLORS.DarkRed })
end)

----------------------------------------------------------------
-- ESCALA RESPONSIVA (móvil / PC)
----------------------------------------------------------------
local function fit()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local v = cam.ViewportSize
	playerScale.Scale = math.clamp(math.min((v.X - 32) / 600, (v.Y - 130) / 300), 0.4, 1.3)
	deckScale.Scale = math.clamp(math.min((v.X - 32) / 560, (v.Y - 130) / 320), 0.4, 1.3)
end
fit()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
end

----------------------------------------------------------------
-- LÓGICA
----------------------------------------------------------------
local closed = false
local introStart = os.clock()
local EXIT_FADE = 0.4 -- fade de salida (cuenta dentro de los 8 segundos)

-- Música de la intro
local music
if CONFIG.MusicId ~= "" then
	music = make("Sound", SoundService, {
		Name = "GhoxtIntroMusic",
		SoundId = CONFIG.MusicId,
		Volume = CONFIG.MusicVolume,
		Looped = false,
	})
	music.TimePosition = CONFIG.MusicStart
	music:Play()
end

-- Ecualizador animado
local eqTime = 0
local eqConnection = RunService.Heartbeat:Connect(function(dt)
	eqTime += dt
	for i, bar in ipairs(eqBars) do
		local h = 4 + (math.sin(eqTime * (5 + i * 1.7) + i * 1.3) * 0.5 + 0.5) * 12
		bar.Size = UDim2.fromOffset(3, h)
	end
end)

local function closeIntro()
	if closed then return end
	closed = true
	rainConnection:Disconnect()
	eqConnection:Disconnect()
	if music then
		tween(music, EXIT_FADE, { Volume = 0 })
		task.delay(EXIT_FADE + 0.1, function() music:Destroy() end)
	end
	local t = tween(root, EXIT_FADE, { GroupTransparency = 1 })
	t.Completed:Wait()
	screen:Destroy()
end

skip.Activated:Connect(closeIntro)
nextBtn.Activated:Connect(closeIntro)

-- Precarga de imágenes (sin bloquear la animación)
task.spawn(function()
	local toLoad = {}
	for _, label in ipairs(slides) do
		table.insert(toLoad, label)
	end
	pcall(function()
		ContentProvider:PreloadAsync(toLoad)
	end)
end)

local function pause(seconds)
	task.wait(seconds)
	return not closed
end

-- FASE 1: cartas (barajar -> abanico -> As -> nombre) ≈ 2.5 s
local function cardPhase()
	tween(deck, 0.25, { GroupTransparency = 0 })
	if not pause(0.3) then return false end

	-- barajar: 2 pasadas rápidas, la carta de arriba sale primero
	for pass = 1, 2 do
		local dir = (pass % 2 == 1) and 1 or -1
		for i = #cards, 1, -1 do
			local offset = #cards - i
			task.spawn(function()
				task.wait(offset * 0.04)
				if closed then return end
				local out = tween(cards[i].card, 0.12, {
					Position = UDim2.new(0.5, dir * (60 + offset * 3), STACK_Y, -14 + offset * 2),
					Rotation = dir * (7 + offset),
				}, Enum.EasingStyle.Sine)
				out.Completed:Wait()
				if closed then return end
				tween(cards[i].card, 0.14, {
					Position = UDim2.new(0.5, 0, STACK_Y, (i - 3) * 2),
					Rotation = (i - 3) * 1.5,
				}, Enum.EasingStyle.Quint)
			end)
		end
		if not pause(0.45) then return false end
	end

	-- abanico bien distribuido (el As al centro y arriba)
	for i, c in ipairs(cards) do
		local slot = fanSlots[i]
		tween(c.card, 0.35, {
			Position = UDim2.new(0.5, slot * 64, STACK_Y, math.abs(slot) * 10),
			Rotation = slot * 10,
		}, Enum.EasingStyle.Back)
	end
	if not pause(0.5) then return false end

	-- las demás cartas se esconden detrás y el As queda de protagonista
	for i = 1, 4 do
		local slot = fanSlots[i]
		tween(cards[i].card, 0.35, {
			Position = UDim2.new(0.5, slot * 14, STACK_Y, 30),
			Rotation = slot * 3,
			GroupTransparency = 1,
		})
	end
	local ace = cards[5]
	tween(ace.card, 0.35, { Position = UDim2.new(0.5, 0, STACK_Y, 0), Rotation = 0 }, Enum.EasingStyle.Back)
	tween(ace.scale, 0.35, { Scale = 1.18 }, Enum.EasingStyle.Back)
	tween(nameLabel, 0.3, { TextTransparency = 0 })
	tween(nameLine, 0.4, { Size = UDim2.fromOffset(180, 3) }, Enum.EasingStyle.Quint)
	if not pause(0.6) then return false end

	-- se desvanece la baraja
	tween(deck, 0.25, { GroupTransparency = 1 })
	if not pause(0.25) then return false end
	deck.Visible = false
	return true
end

-- FASE 2: tarjeta tipo Spotify con la barra de "música"
-- Dura lo que falte para completar CONFIG.TotalDuration
local function playerPhase()
	local duration = math.max(1.5, CONFIG.TotalDuration - EXIT_FADE - (os.clock() - introStart))
	timeRight.Text = fmt(math.floor(duration + 0.5))

	tween(nowPlaying, 0.4, {
		GroupTransparency = 0,
		Position = UDim2.fromScale(0.5, 0.46),
	}, Enum.EasingStyle.Quint)

	-- barra de progreso: relleno + bolita
	local barInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	TweenService:Create(fill, barInfo, { Size = UDim2.fromScale(1, 1) }):Play()
	TweenService:Create(knob, barInfo, { Position = UDim2.fromScale(1, 0.5) }):Play()

	-- portada: crossfade entre tus imágenes
	task.spawn(function()
		local count = #slides
		if count == 0 then return end
		local slideTime = duration / count
		local previous
		for i = 1, count do
			if closed then return end
			tween(slides[i], CONFIG.FadeTime, { ImageTransparency = 0 })
			if previous then
				tween(previous, CONFIG.FadeTime, { ImageTransparency = 1 })
			end
			previous = slides[i]
			task.wait(slideTime)
		end
	end)

	-- tiempo transcurrido + "LOADING..." animado
	local start = os.clock()
	while not closed and os.clock() - start < duration do
		local elapsed = os.clock() - start
		timeLeft.Text = fmt(elapsed)
		tagline.Text = CONFIG.Tagline .. string.rep(".", math.floor(elapsed * 2) % 4)
		task.wait(0.1)
	end

	if not closed then
		timeLeft.Text = fmt(math.floor(duration + 0.5))
		closeIntro()
	end
end

task.spawn(function()
	if CONFIG.CardIntro then
		if not cardPhase() then return end
	else
		deck.Visible = false
	end
	playerPhase()
end)