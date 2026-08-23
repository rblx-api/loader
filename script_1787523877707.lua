-- ============================================================
--  CT Duels | EDICIÓN BLANCO Y NEGRO (estilo Vere.v2)
--  Todos los colores azules reemplazados por blanco/gris.
--  Diseño de GUI basado en Vere v2.
-- ============================================================

-- SECCIÓN 1: CONFIGURACIÓN INICIAL (BRANDING, COLORES, STATE)
-- ============================================================
local CANDY_BRAND = "SHYNX.CC"
local CANDY_DISCORD = "SHYNX.CC"
local CANDY_COLORS = {
	BG = Color3.fromRGB(8,0,0),
	PANEL = Color3.fromRGB(16,2,2),
	CARD = Color3.fromRGB(24,4,4),
	ACCENT = Color3.fromRGB(220,50,80),  -- Bless accent
	PURPLE = Color3.fromRGB(220,50,80), -- Bless accent
	ICE = Color3.fromRGB(255,100,60),
	HOVER = Color3.fromRGB(255,80,100),
	TEXT = Color3.fromRGB(255,240,240),
	SECONDARY = Color3.fromRGB(180,140,145),
	STROKE = Color3.fromRGB(160,30,50),
	INPUT = Color3.fromRGB(220,50,80),
	OFF = Color3.fromRGB(50,20,28)
}

local BG         = Color3.fromRGB(10, 5, 8)
local SIDEBAR_BG = Color3.fromRGB(18, 8, 12)
local CARD_BG    = Color3.fromRGB(28, 10, 16)
local CARD_HOV   = Color3.fromRGB(255, 80, 100)
local KB_BG      = Color3.fromRGB(50, 20, 28)

local WHITE      = Color3.fromRGB(255,240,240)
local DIM        = Color3.fromRGB(180,140,145)
local DIM2       = Color3.fromRGB(50,20,28)

local BORDER     = Color3.fromRGB(160,30,50)
local BORDER2    = Color3.fromRGB(255,100,60)
local OPTION_TRANSPARENCY = 0.42
local OPTION_HOVER_TRANSPARENCY = 0.22
local TAB_TRANSPARENCY = 0.35
local TAB_HOVER_TRANSPARENCY = 0.16
local INPUT_TRANSPARENCY = 0.24

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local neonWeatherEnabled = false
local _originalLighting = nil
local setNeonWeatherVisual = nil
-- Estados de Body Lock como variables globales para no superar el límite de registros de Luau.
bodyLockEnabled = false
ACCESSORY_PACK_ORDER = nil
currentAccessoryPack = "Off"
accSelectorLabel = nil
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
bodyLockSetVisual = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
local musicEnabled = {}
lastAutoCarryCarryState = false
lastCarryButtonState = false

-- SECCIÓN 2: ALERTA DE PING ALTO (sin cambios)
task.spawn(function()
    local env = (getgenv and getgenv()) or _G
    env.__CRYON_HIGH_PING_RUN = (env.__CRYON_HIGH_PING_RUN or 0) + 1
    local thisRun = env.__CRYON_HIGH_PING_RUN
    env.__CRYON_INTRO_FINISHED_RUN = 0
    local shown = false

    local function getPingMilliseconds()
        local ok, value = pcall(function()
            local stats = game:GetService("Stats")
            local network = stats:FindFirstChild("Network")
            local serverStats = network and network:FindFirstChild("ServerStatsItem")
            local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
            if not pingItem then
                return nil
            end

            local numericValue
            pcall(function()
                numericValue = pingItem:GetValue()
            end)
            if type(numericValue) == "number" then
                return numericValue
            end

            local valueString = pingItem:GetValueString()
            return tonumber(tostring(valueString):match("[%d%.]+"))
        end)
        return ok and tonumber(value) or nil
    end

    local function showHighPingAlert()
        local TweenService = game:GetService("TweenService")
        local CoreGui = game:GetService("CoreGui")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local playerGui = player and player:FindFirstChildOfClass("PlayerGui")

        pcall(function()
            local old = CoreGui:FindFirstChild("CryonHighPingAlert")
            if old then old:Destroy() end
        end)
        pcall(function()
            local old = playerGui and playerGui:FindFirstChild("CryonHighPingAlert")
            if old then old:Destroy() end
        end)

        local gui = Instance.new("ScreenGui")
        gui.Name = "CryonHighPingAlert"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = false
        gui.DisplayOrder = 10000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

        local parented = pcall(function()
            gui.Parent = CoreGui
        end)
        if not parented or not gui.Parent then
            gui.Parent = playerGui
        end
        if not gui.Parent then
            gui:Destroy()
            return
        end

        local bar = Instance.new("Frame")
        bar.Name = "AlertBar"
        bar.AnchorPoint = Vector2.new(0.5, 0)
        bar.Position = UDim2.new(0.5, 0, 0, -44)
        bar.Size = UDim2.new(0, 310, 0, 32)
        bar.BackgroundColor3 = Color3.fromRGB(90,20,20)
        bar.BackgroundTransparency = 0.06
        bar.BorderSizePixel = 0
        bar.ClipsDescendants = true
        bar.ZIndex = 100
        bar.Parent = gui

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 11)
        corner.Parent = bar

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255,255,255)
        stroke.Transparency = 0.2
        stroke.Thickness = 1
        stroke.Parent = bar

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80,10,10)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80,10,10)),
        })
        gradient.Parent = bar

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.Text = "high ping! Your ping is more than 150."
        label.TextColor3 = Color3.fromRGB(255, 220, 220)
        label.TextSize = 13
        label.TextStrokeColor3 = Color3.fromRGB(40,10,10)
        label.TextStrokeTransparency = 0.55
        label.TextWrapped = false
        label.TextScaled = false
        label.ZIndex = 102
        label.Parent = bar

        local slideIn = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, 0, 0, 10)}
        )
        slideIn:Play()
        slideIn.Completed:Wait()

        task.wait(2)

        local slideOut = TweenService:Create(
            bar,
            TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, 0, 0, -44)}
        )
        slideOut:Play()
        slideOut.Completed:Wait()
        gui:Destroy()
    end

    while env.__CRYON_HIGH_PING_RUN == thisRun and env.__CRYON_INTRO_FINISHED_RUN ~= thisRun do
        task.wait(0.1)
    end

    while env.__CRYON_HIGH_PING_RUN == thisRun and not shown do
        local ping = getPingMilliseconds()
        if ping and ping > 150 then
            shown = true
            showHighPingAlert()
            break
        end
        task.wait(1)
    end
end)

-- SECCIÓN 3: INTRO ANIMADA (reemplazada por IntrofixedleakedbySami_modificada.txt)
-- El contenido se encapsula en una función para conservar su alcance local.
local function runVereuzxIntro()
--============================================================
-- SHADOW.VS INTRO
-- YOUR ORIGINAL VERSION
-- RANDOM IMAGE + MUSIC + BEAT EFFECTS + SKIP
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- SETTINGS
--============================================================

local MUSIC_URL =
	"https://files.catbox.moe/iknfuh.mp3"

local MUSIC_FILE =
	"SHYNX.VS_Music.mp3"

local MUSIC_VOLUME =
	0.75

local BPM =
	100

local BEAT =
	60 / BPM

-- IMAGE 2 FIRST
-- IMAGE 1 SECOND
-- THEN RANDOM WITHOUT REPEATING
local IMAGES = {
	"rbxassetid://134700069294475",
	"rbxassetid://134700069294475"
}

--============================================================
-- CLEAN OLD
--============================================================

for _, name in ipairs({
	"ShadowVSIntro"
}) do

	local old =
		PlayerGui:FindFirstChild(name)

	if old then
		old:Destroy()
	end

end

--============================================================
-- IMAGE ORDER
--============================================================

local lastImage =
	shared.ShadowVS_LastImage

local imageIndex

if not shared.ShadowVS_Run then

	shared.ShadowVS_Run =
		1

	imageIndex =
		2

elseif shared.ShadowVS_Run == 1 then

	shared.ShadowVS_Run =
		2

	imageIndex =
		1

else

	local choices = {}

	for i = 1, #IMAGES do

		if i ~= lastImage then
			table.insert(
				choices,
				i
			)
		end

	end

	imageIndex =
		choices[
			math.random(
				1,
				#choices
			)
		]

end

shared.ShadowVS_LastImage =
	imageIndex

local IMAGE_ID =
	IMAGES[imageIndex]

--============================================================
-- INTRO STATE
--============================================================

local introActive =
	true

local introFinished =
	false

local introSound =
	nil

--============================================================
-- GUI
--============================================================

local gui =
	Instance.new("ScreenGui")

gui.Name =
	"ShadowVSIntro"

gui.IgnoreGuiInset =
	true

gui.ResetOnSpawn =
	false

gui.DisplayOrder =
	999999

gui.ZIndexBehavior =
	Enum.ZIndexBehavior.Sibling

gui.Parent =
	PlayerGui

--============================================================
-- BACKGROUND
--============================================================

local background =
	Instance.new("Frame")

background.Size =
	UDim2.fromScale(
		1,
		1
	)

background.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

background.BorderSizePixel =
	0

background.ClipsDescendants =
	true

background.Parent =
	gui

--============================================================
-- IMAGE
--============================================================

local image =
	Instance.new("ImageLabel")

image.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

image.Position =
	UDim2.fromScale(
		0.5,
		0.5
	)

image.Size =
	UDim2.fromScale(
		1.08,
		1.08
	)

image.BackgroundTransparency =
	1

image.Image =
	IMAGE_ID

image.ImageTransparency =
	1

image.ScaleType =
	Enum.ScaleType.Crop

image.ZIndex =
	1

image.Parent =
	background

--============================================================
-- DARK OVERLAY
--============================================================

local dark =
	Instance.new("Frame")

dark.Size =
	UDim2.fromScale(
		1,
		1
	)

dark.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

dark.BackgroundTransparency =
	0.25

dark.BorderSizePixel =
	0

dark.ZIndex =
	2

dark.Parent =
	background

--============================================================
-- SKIP INTRO BUTTON
--============================================================

local skip =
	Instance.new("TextButton")

skip.AnchorPoint =
	Vector2.new(
		1,
		0
	)

skip.Position =
	UDim2.new(
		1,
		-14,
		0,
		14
	)

skip.Size =
	UDim2.fromOffset(
		105,
		36
	)

skip.BackgroundColor3 =
	Color3.fromRGB(
		15,
		15,
		18
	)

skip.BackgroundTransparency =
	0.15

skip.BorderSizePixel =
	0

skip.Text =
	"SKIP INTRO"

skip.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

skip.TextSize =
	12

skip.Font =
	Enum.Font.GothamBold

skip.AutoButtonColor =
	false

skip.ZIndex =
	500

skip.Parent =
	gui

local skipCorner =
	Instance.new("UICorner")

skipCorner.CornerRadius =
	UDim.new(
		0,
		7
	)

skipCorner.Parent =
	skip

local skipStroke =
	Instance.new("UIStroke")

skipStroke.Color =
	Color3.fromRGB(
		255,
		255,
		255
	)

skipStroke.Transparency =
	0.75

skipStroke.Thickness =
	1

skipStroke.Parent =
	skip

--============================================================
-- FLASH
--============================================================

local flash =
	Instance.new("Frame")

flash.Size =
	UDim2.fromScale(
		1,
		1
	)

flash.BackgroundColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

flash.BackgroundTransparency =
	1

flash.BorderSizePixel =
	0

flash.ZIndex =
	400

flash.Parent =
	gui

--============================================================
-- TITLE
--============================================================

local introTitle =
	Instance.new("TextLabel")

introTitle.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

introTitle.Position =
	UDim2.fromScale(
		0.5,
		0.5
	)

introTitle.Size =
	UDim2.fromScale(
		1.1,
		0.22
	)

introTitle.BackgroundTransparency =
	1

introTitle.Text =
		""

introTitle.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

introTitle.TextTransparency =
	1

introTitle.TextScaled =
	true

introTitle.Font =
	Enum.Font.GothamBlack

introTitle.ZIndex =
	20

introTitle.Parent =
	background

local titleStroke =
	Instance.new("UIStroke")

titleStroke.Color =
	Color3.fromRGB(
		0,
		0,
		0
	)

titleStroke.Thickness =
	3

titleStroke.Transparency =
	1

titleStroke.Parent =
	introTitle

--============================================================
-- SUBTITLE
--============================================================

local introSubtitle =
	Instance.new("TextLabel")

introSubtitle.AnchorPoint =
	Vector2.new(
		0.5,
		0.5
	)

introSubtitle.Position =
	UDim2.fromScale(
		0.5,
		0.59
	)

introSubtitle.Size =
	UDim2.fromScale(
		0.6,
		0.05
	)

introSubtitle.BackgroundTransparency =
	1

introSubtitle.Text =
	"CREATE BY COMINO"

introSubtitle.TextColor3 =
	Color3.fromRGB(
		205,
		205,
		205
	)

introSubtitle.TextTransparency =
	1

introSubtitle.TextScaled =
	true

introSubtitle.Font =
	Enum.Font.GothamBold

introSubtitle.ZIndex =
	20

introSubtitle.Parent =
	background

--============================================================
-- MUSIC LOADER
--============================================================

local function loadMusic()

	local asset

	pcall(function()

		if isfile and
			isfile(MUSIC_FILE) then

			asset =
				getcustomasset(
					MUSIC_FILE
				)

		end

	end)

	if not asset then

		local success, data =
			pcall(function()

				return game:HttpGet(
					MUSIC_URL
				)

			end)

		if success and
			data and
			#data > 1000 then

			pcall(function()

				writefile(
					MUSIC_FILE,
					data
				)

			end)

			pcall(function()

				asset =
					getcustomasset(
						MUSIC_FILE
					)

			end)

		end

	end

	return asset

end

--============================================================
-- PLAY MUSIC
--============================================================

task.spawn(function()

	local asset =
		loadMusic()

	if not asset or
		not introActive then
		return
	end

	introSound =
		Instance.new("Sound")

	introSound.Name =
		"ShadowVSIntroMusic"

	introSound.SoundId =
		asset

	introSound.Volume =
		MUSIC_VOLUME

	introSound.Looped =
		false

	introSound.Parent =
		SoundService

	pcall(function()
		introSound:Play()
	end)

end)

--============================================================
-- FINISH
--============================================================

local function finishIntro()

	if introFinished then
		return
	end

	introFinished =
		true

	introActive =
		false

	if introSound then

		pcall(function()

			TweenService:Create(
				introSound,
				TweenInfo.new(
					0.35
				),
				{
					Volume = 0
				}
			):Play()

		end)

		task.delay(
			0.4,
			function()

				pcall(function()

					introSound:Stop()
					introSound:Destroy()

				end)

			end
		)

	end

	pcall(function()
		gui:Destroy()
	end)

end

--============================================================
-- SKIP
--============================================================

skip.MouseButton1Click:Connect(
	finishIntro
)

--============================================================
-- SKIP HOVER
--============================================================

skip.MouseEnter:Connect(function()

	TweenService:Create(
		skip,
		TweenInfo.new(
			0.12
		),
		{
			BackgroundColor3 =
				Color3.fromRGB(
					55,
					55,
					60
				)
		}
	):Play()

end)

skip.MouseLeave:Connect(function()

	TweenService:Create(
		skip,
		TweenInfo.new(
			0.12
		),
		{
			BackgroundColor3 =
				Color3.fromRGB(
					15,
					15,
					18
				)
		}
	):Play()

end)

--============================================================
-- IMAGE FADE IN
--============================================================

TweenService:Create(
	image,
	TweenInfo.new(
		1.1,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.Out
	),
	{
		ImageTransparency =
			0
	}
):Play()

--============================================================
-- SLOW ZOOM
--============================================================

TweenService:Create(
	image,
	TweenInfo.new(
		18,
		Enum.EasingStyle.Sine,
		Enum.EasingDirection.InOut,
		-1,
		true
	),
	{
		Size =
			UDim2.fromScale(
				1.18,
				1.18
			)
	}
):Play()

--============================================================
-- BEAT FLASH
--============================================================

task.spawn(function()

	while introActive
		and gui.Parent do

		flash.BackgroundTransparency =
			0.8

		TweenService:Create(
			flash,
			TweenInfo.new(
				0.12,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			),
			{
				BackgroundTransparency =
					1
			}
		):Play()

		task.wait(
			BEAT
		)

	end

end)

--============================================================
-- TITLE
--============================================================

task.wait(1.5)

if not introActive then
	return
end

TweenService:Create(
	introTitle,
	TweenInfo.new(
		0.7,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.Out
	),
	{
		Size =
			UDim2.fromScale(
				0.9,
				0.18
			),

		TextTransparency =
			0
	}
):Play()

TweenService:Create(
	titleStroke,
	TweenInfo.new(
		0.5
	),
	{
		Transparency =
			0
	}
):Play()

--============================================================
-- TITLE SHAKE
--============================================================

task.wait(1)

for i = 1, 18 do

	if not introActive then
		return
	end

	introTitle.Position =
		UDim2.fromScale(
			0.5 +
				math.random(
					-8,
					8
				) / 1000,

			0.5 +
				math.random(
					-8,
					8
				) / 1000
		)

	task.wait(
		0.025
	)

end

introTitle.Position =
	UDim2.fromScale(
		0.5,
		0.5
	)

--============================================================
-- SUBTITLE
--============================================================

TweenService:Create(
	introSubtitle,
	TweenInfo.new(
		0.6,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.Out
	),
	{
		TextTransparency =
			0
	}
):Play()

--============================================================
-- HOLD
--============================================================

task.wait(7)

if not introActive then
	return
end

--============================================================
-- FINAL BEAT FLASHES
--============================================================

for i = 1, 14 do

	if not introActive then
		return
	end

	flash.BackgroundTransparency =
		0

	task.wait(
		0.025
	)

	flash.BackgroundTransparency =
		1

	task.wait(
		0.065
	)

end

--============================================================
-- EXTRA HOLD
--============================================================

task.wait(2)

if not introActive then
	return
end

--============================================================
-- TITLE FADE
--============================================================

TweenService:Create(
	introTitle,
	TweenInfo.new(
		1.2,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		TextTransparency =
			1
	}
):Play()

TweenService:Create(
	introSubtitle,
	TweenInfo.new(
		1,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		TextTransparency =
			1
	}
):Play()

TweenService:Create(
	titleStroke,
	TweenInfo.new(
		1
	),
	{
		Transparency =
			1
	}
):Play()

--============================================================
-- IMAGE FADE
--============================================================

TweenService:Create(
	image,
	TweenInfo.new(
		1.5,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		ImageTransparency =
			1
	}
):Play()

TweenService:Create(
	dark,
	TweenInfo.new(
		1.5
	),
	{
		BackgroundTransparency =
			1
	}
):Play()

--============================================================
-- MUSIC FADE
--============================================================

if introSound and
	introSound.Parent then

	TweenService:Create(
		introSound,
		TweenInfo.new(
			1.5,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.In
		),
		{
			Volume =
				0
		}
	):Play()

end

--============================================================
-- FINAL BLACK FADE
--============================================================

local finalFade =
	Instance.new("Frame")

finalFade.Size =
	UDim2.fromScale(
		1,
		1
	)

finalFade.BackgroundColor3 =
	Color3.fromRGB(
		0,
		0,
		0
	)

finalFade.BackgroundTransparency =
	1

finalFade.BorderSizePixel =
	0

finalFade.ZIndex =
	1000

finalFade.Parent =
	gui

TweenService:Create(
	finalFade,
	TweenInfo.new(
		1.5,
		Enum.EasingStyle.Quint,
		Enum.EasingDirection.In
	),
	{
		BackgroundTransparency =
			0
	}
):Play()

task.wait(
	1.6
)

finishIntro()
end

runVereuzxIntro()

-- SECCIÓN 4: VARIABLES GLOBALES Y STATE (sin cambios funcionales)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

;(function()
local NS, CS, LS, LS2 = 60, 30, 15, 24.5

local laggerPhase = 0

local State = {
	speedToggled = false, laggerToggled = false, autoBatToggled = false,
	speedProfile = "Normal",
	profileLaggerNormalSpeed = 40,
	profileLaggerCarrySpeed = 20,
	hittingCooldown = false, infJumpEnabled = false,
	antiRagdollEnabled = false, fpsBoostEnabled = false,
	antiLagEnabled = false,
	selectedIntroMusic = 1,
	isStealing = false, stealStartTime = nil, lastStealTick = 0,
	lastKnownHealth = 100,
	dropActive = false,
	dropBrainrotActive = false,
	autoLeftEnabled = false, autoRightEnabled = false,
	tpBatEnabled = false,
	unwalkEnabled = false,
	nuevaAnimacionEnabled = true,
	stretchRezEnabled = false, removeAccessoriesEnabled = false,
	darkModeEnabled = false, skyStyle = "Off",
			backgroundAssetId = "106050493494582",
backgroundAssetIds = {
					"106050493494582",
				},
	imageChoiceVisuals = {},
    dropConn = nil,
    dropBrainrotConn = nil,
    autoCarryEnabled = true,
    batV1Speed = 60,
    batV2Speed = 60,
}

local _anyKeyListening, uiLocked = false, false
local cancelStealBarDrag
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local autoSavePositions = function() end
local mobilePanelStyle = "darkhub"
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local mobileButtonsByName = {}
local mobileButtonDefaultPositions = {}
local BTN_POSITIONS_DH = {
	Drop       = UDim2.new(1, -298, 1, -334),
	AutoLeft   = UDim2.new(1, -144, 1, -334),
	AutoBat    = UDim2.new(1, -298, 1, -270),
	AutoRight  = UDim2.new(1, -144, 1, -270),
	TPDown     = UDim2.new(1, -298, 1, -206),
	Speed      = UDim2.new(1, -144, 1, -206),
	Lagger     = UDim2.new(1, -144, 1, -142),
}

local KB = {
	AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
	AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
	Drop      = {kb = Enum.KeyCode.X,           gp = nil},
	TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
	AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
	AutoBatV2 = {kb = nil,                      gp = nil},
	TPBat     = {kb = nil,                      gp = nil},
	Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
	Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
	InstaReset= {kb = nil,                      gp = nil},
}

local function kbMatch(entry, kc)
	return kc == entry.kb or (entry.gp and kc == entry.gp)
end

local function getProfileNormalSpeed()
	return State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS
end

function isLustPlayerStealing()
	return LP:GetAttribute("Stealing") == true
end

local function getProfileCarrySpeed()
	return State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS
end

local AP = {
	L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
	R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

local Steal = {
	AutoStealEnabled = false, StealRadius = 10, StealDuration = 1.3,
	Data = {}, plotCache = {}, plotCacheTime = {},
	cachedPrompts = {}, promptCacheTime = 0,
}

local Conns = {
	autoSteal = nil, antiRag = nil,
	anchor = {}, progress = nil,
}

local safetyPositionIsValid
local startBatAimbot, stopBatAimbot
local function findAnyToolMob()
	local c=LP.Character
	if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
	local bp=LP:FindFirstChildOfClass("Backpack")
	if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
	return nil
end
local function getClosestPlayerMob2()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil,math.huge end
	local cp,cd=nil,math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local tr=p.Character:FindFirstChild("HumanoidRootPart")
			local ph=p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health>0 then
				local d=(root.Position-tr.Position).Magnitude
				if d<cd then cd=d; cp=p end
			end
		end
	end
	return cp,cd
end
local MOB_SWING_COOLDOWN=0.08
local function tryHitBatMob()
	if State.hittingCooldown then return end; State.hittingCooldown=true
	pcall(function()
		local c=LP.Character; if not c then return end
		local hum2=c:FindFirstChildOfClass("Humanoid"); local tool=findAnyToolMob()
		if tool then
			if tool.Parent~=c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
			local remote=tool:FindFirstChildOfClass("RemoteEvent")
			if remote then pcall(function() remote:FireServer() end)
			else pcall(function() tool:Activate() end) end
		end
	end)
	task.delay(MOB_SWING_COOLDOWN,function() State.hittingCooldown=false end)
end
local _aimbotTarget = nil

local function findBat()
	local char = LP.Character; if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChildOfClass("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end

local function getClosestTarget()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
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
	return closest
end

-- ============================================================
--  FUNCIONES DE BAT AIMBOT V1 (modificadas para excluir TP Bat)
-- ============================================================
stopBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
	_aimbotTarget = nil
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
	State.hittingCooldown = false
	_autoBatTarget = nil
	_autoBatEquippedThisRun = false
end

startBatAimbot = function()
	if State.tpBatEnabled then
		State._setTPBatEnabled(false)
	end

	if Conns.aimbot then Conns.aimbot:Disconnect() end
	_autoBatEquippedThisRun = false

	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end

	Conns.aimbot = RunService.RenderStepped:Connect(function(dt)
		if not State.autoBatToggled then return end
		local char = LP.Character; if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

		if not char:FindFirstChildOfClass("Tool") then
			local bat = findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local target = getClosestTarget()
		if not target then
			hum.AutoRotate = true
			return
		end
		_aimbotTarget = target

		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position

		local predictPos = targetPos + targetVel * 0.14
		predictPos = predictPos + target.CFrame.LookVector * 0.3

		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
		local chaseSpeed = State.batV1Speed or 60

		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then
			yVel = math.max(yVel, 13)
		end
		yVel = math.clamp(yVel, -70, 110)

		local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

		local speed3 = targetVel.Magnitude
		local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local curCF  = root.CFrame
			local diffCF = curCF:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			local tiltSpeed = 42
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
				Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
			)
		end

		if State.autoSwingEnabled then
			local bat = char:FindFirstChildOfClass("Tool")
			if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
				pcall(function() bat:Activate() end)
			end
		end
	end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
end)

local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1

local h, hrp, speedLbl
local setAutoGrab, setAutoBat, setInfJump, setSuperJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode, setSkyStyle, setSkySelectorVisual, setAnimationPackVisual
local animationPackName = "Tryhard"
local setMedusaCounter, setBatCounter, setInstaGrab, setAutoSwingVisual
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost, startAutoSteal, stopAutoSteal
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil

State._configLoading = false
State._configLoaded = false
State._saveAfterLoad = false
State._saveRequestId = 0
State._lastSaveError = nil
State._configDirty = false
State._positionDirty = false

State._resolveFileFunction = function(name)
	local direct = nil
	if name == "writefile" then direct = writefile
	elseif name == "readfile" then direct = readfile
	elseif name == "isfile" then direct = isfile
	elseif name == "delfile" then direct = delfile
	elseif name == "makefolder" then direct = makefolder
	elseif name == "isfolder" then direct = isfolder end
	if type(direct) == "function" then return direct end

	local environments = {}
	pcall(function()
		if getgenv then table.insert(environments, getgenv()) end
	end)
	pcall(function()
		if getrenv then table.insert(environments, getrenv()) end
	end)
	table.insert(environments, _G)

	for _, environment in ipairs(environments) do
		if type(environment) == "table" then
			local candidate = rawget(environment, name)
			if type(candidate) == "function" then return candidate end
			local synEnvironment = rawget(environment, "syn")
			if type(synEnvironment) == "table" then
				local synCandidate = rawget(synEnvironment, name)
				if type(synCandidate) == "function" then return synCandidate end
			end
		end
	end

	if type(syn) == "table" and type(syn[name]) == "function" then
		return syn[name]
	end
	return nil
end

State._safeWriteFile = function(path, data)
	local writer = State._resolveFileFunction("writefile")
	if type(writer) ~= "function" then
		return false, "writefile no disponible en este ejecutor"
	end
	local ok, err = pcall(writer, path, data)
	if not ok then return false, tostring(err) end
	return true
end

State._safeReadFile = function(path)
	local reader = State._resolveFileFunction("readfile")
	if type(reader) ~= "function" then
		return nil, "readfile no disponible en este ejecutor"
	end
	local ok, result = pcall(reader, path)
	if not ok or type(result) ~= "string" or result == "" then
		return nil, ok and "archivo vacío" or tostring(result)
	end
	return result
end

State._safeDeleteFile = function(path)
	local deleter = State._resolveFileFunction("delfile")
	if type(deleter) ~= "function" then return false end
	local ok = pcall(deleter, path)
	return ok
end

State._readValidJsonFile = function(path)
	local raw = State._safeReadFile(path)
	if type(raw) ~= "string" then return nil, nil end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok or type(decoded) ~= "table" then return nil, raw end
	return decoded, raw
end

State._writeVerifiedJson = function(path, encoded)
	local writeOk, writeErr = State._safeWriteFile(path, encoded)
	if not writeOk then return false, writeErr end
	local decoded, raw = State._readValidJsonFile(path)
	if type(decoded) ~= "table" or raw ~= encoded then
		return false, "la verificación del archivo falló: " .. tostring(path)
	end
	return true
end

State._atomicJsonSave = function(mainPath, backupPath, tempPath, encoded)
	local jsonOk, decoded = pcall(function() return HttpService:JSONDecode(encoded) end)
	if not jsonOk or type(decoded) ~= "table" then
		return false, "JSON inválido antes de guardar"
	end

	local currentData, currentRaw = State._readValidJsonFile(mainPath)

	if type(currentData) == "table" and currentRaw == encoded then
		return true
	end

	if type(currentData) == "table" and type(currentRaw) == "string" then
		local backupOk, backupErr = State._safeWriteFile(backupPath, currentRaw)
		if not backupOk then return false, backupErr end
	end

	local tempOk, tempErr = State._safeWriteFile(tempPath, encoded)
	if not tempOk then return false, tempErr end

	local mainOk, mainErr = State._safeWriteFile(mainPath, encoded)
	if not mainOk then return false, mainErr end

	if type(currentData) ~= "table" then
		State._safeWriteFile(backupPath, encoded)
	end

	return true
end

State.requestConfigSave = function()
	if State._configLoading or not State._configLoaded then
		State._saveAfterLoad = true
		State._configDirty = true
		return
	end
	if State._configLoadFailed then
		return
	end

	State._configDirty = true
	State._saveRequestId = State._saveRequestId + 1
	local requestId = State._saveRequestId

	task.delay(1.75, function()
		if requestId ~= State._saveRequestId or State._configLoading then return end
		if not State._configDirty then return end
		if saveConfig then
			local ok, result = pcall(saveConfig)
			if not ok then State._lastSaveError = tostring(result) end
		end
	end)
end
local normalBox, carryBox, laggerBox, laggerBox2, durValBtn, uiScaleBox
local modeValLbl, progressFill, progressPct, progressRadLbl
local radValBtn
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local autoTPDownEnabled, autoTPDownConn, autoTPDownHeight = false, nil, 20

local startBatAimbotV2, stopBatAimbotV2
local _autoBatLastScan = 0
local _autoBatTarget = nil
local _autoBatEquippedThisRun = false

local autoBatV2SetVisual, setAutoBatV2, setHideButtonsVisual, setAutoTPDownVisual

local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
local btnInstaReset = nil

State.buttonsSizeValue = State.buttonsSizeValue or 50

function getMobileButtonPixels(value)
	value = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	return math.floor(34 + (value * 0.48) + 0.5)
end

function applyShapeToMobileButton(button)
	if not button or not button.Parent then return end

	local pixels = getMobileButtonPixels(State.buttonsSizeValue)
	local textPixels = math.clamp(math.floor(7 + State.buttonsSizeValue * 0.08 + 0.5), 8, 15)
	local shape = "Normal"
	local width, height = pixels, pixels
	local radius = UDim.new(0, math.clamp(math.floor(pixels * 0.30 + 0.5), 8, math.floor(pixels / 2)))

	if shape == "Circle" then
		radius = UDim.new(1, 0)
	elseif shape == "Square" then
		radius = UDim.new(0, 0)
	elseif shape == "Rectangle" then
		width = math.floor(pixels * 1.55 + 0.5)
		height = math.max(28, math.floor(pixels * 0.75 + 0.5))
		radius = UDim.new(0, math.max(5, math.floor(height * 0.18 + 0.5)))
	end

	button.Size = UDim2.new(0, width, 0, height)
	button.TextSize = textPixels

	local corner = button:FindFirstChild("ButtonShapeCorner")
	if not corner or not corner:IsA("UICorner") then
		corner = button:FindFirstChildOfClass("UICorner")
	end
	if not corner then
		corner = Instance.new("UICorner")
		corner.Parent = button
	end
	corner.Name = "ButtonShapeCorner"
	corner.CornerRadius = radius
end

function applyMobileButtonsShape(_shape)
	for _, mobileBtn in pairs(mobileButtonsByName) do
		applyShapeToMobileButton(mobileBtn)
	end
	applyShapeToMobileButton(btnBatV2)
	return "Normal"
end

function applyMobileButtonsSize(value)
	State.buttonsSizeValue = math.clamp(math.floor((tonumber(value) or 50) + 0.5), 0, 100)
	applyMobileButtonsShape("Normal")
end

local SAFETY_VOID_MARGIN = 18
local SAFETY_MAX_FLOOR_RAY = 4000
local safetyLastGroundedCFrame = nil
local safetyRestoring = false

local function safetyVoidY()
	local ok, value = pcall(function() return workspace.FallenPartsDestroyHeight end)
	if ok and type(value) == "number" then return value end
	return -500
end

local function safetyFiniteNumber(value)
	return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

safetyPositionIsValid = function(position)
	return typeof(position) == "Vector3"
		and safetyFiniteNumber(position.X)
		and safetyFiniteNumber(position.Y)
		and safetyFiniteNumber(position.Z)
		and position.Y > safetyVoidY() + SAFETY_VOID_MARGIN
end

local function safetyCharacterParts()
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not humanoid or humanoid.Health <= 0 or not root then
		return nil, nil, nil
	end
	return character, humanoid, root
end

local function safetyFloorPosition(root, character)
	if not root or not character or not safetyPositionIsValid(root.Position) then return nil end

	local ignore = {character}

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local offset = (humanoid and humanoid.HipHeight or 2) + (root.Size.Y / 2) + 0.05
	local origin = root.Position + Vector3.new(0, 5, 0)
	local distanceToVoid = math.max(100, origin.Y - safetyVoidY() + 50)
	local rayDistance = math.min(SAFETY_MAX_FLOOR_RAY, distanceToVoid)
	local hitPosition = nil

	pcall(function()
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = ignore
		params.FilterType = Enum.RaycastFilterType.Exclude
		pcall(function() params.RespectCanCollide = true end)
		local result = workspace:Raycast(origin, Vector3.new(0, -rayDistance, 0), params)
		if result and result.Instance and result.Position then
			hitPosition = result.Position
		end
	end)

	if not hitPosition then
		pcall(function()
			local ray = Ray.new(origin, Vector3.new(0, -rayDistance, 0))
			local part, position = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
			if part and position then hitPosition = position end
		end)
	end

	if not hitPosition then return nil end
	local landing = Vector3.new(root.Position.X, hitPosition.Y + offset, root.Position.Z)
	if not safetyPositionIsValid(landing) then return nil end
	return landing
end

local function safetyTeleport(root, humanoid, destination, preserveYaw)
	if not root or not root.Parent or not humanoid or humanoid.Health <= 0 then return false end
	if not safetyPositionIsValid(destination) then return false end

	local yaw = 0
	if preserveYaw ~= false then
		local _, currentYaw, _ = root.CFrame:ToOrientation()
		yaw = currentYaw
	end

	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	root.CFrame = CFrame.new(destination) * CFrame.Angles(0, yaw, 0)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	pcall(function() humanoid.PlatformStand = false end)
	return true
end

local function safetyTeleportToFloor(character, humanoid, root)
	local landing = safetyFloorPosition(root, character)
	if not landing then
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		return false
	end
	return safetyTeleport(root, humanoid, landing, true)
end

RunService.Heartbeat:Connect(function()
	local character, humanoid, root = safetyCharacterParts()
	if not character then return end

	if safetyPositionIsValid(root.Position)
		and humanoid.FloorMaterial ~= Enum.Material.Air
		and root.AssemblyLinearVelocity.Magnitude < 180 then
		safetyLastGroundedCFrame = root.CFrame
	end

	local riskyMovement = State.dropActive
		or State.dropBrainrotActive
		or autoTPDownEnabled
		or State.tpBatEnabled
		or State.autoBatToggled
		or State.autoBatV2Enabled

	if riskyMovement and not safetyPositionIsValid(root.Position) and not safetyRestoring then
		safetyRestoring = true
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		if safetyLastGroundedCFrame and safetyPositionIsValid(safetyLastGroundedCFrame.Position) then
			root.CFrame = safetyLastGroundedCFrame + Vector3.new(0, 2, 0)
		end
		task.defer(function() safetyRestoring = false end)
	end
end)

local function showDiscordInProgressBar()
	if not progressPct or not progressFill then return end

	local originalText = progressPct.Text
	local originalColor = progressPct.TextColor3
	local originalSize = progressPct.TextSize
	local originalAlign = progressPct.TextXAlignment

	progressPct.Text = "CREATE BY COMINO FACK"
	progressPct.TextColor3 = Color3.fromRGB(255,255,255)
	progressPct.TextSize = 13
	progressPct.TextXAlignment = Enum.TextXAlignment.Center
	progressPct.ZIndex = 12

	if progressRadLbl then progressRadLbl.Visible = false end

	task.delay(4, function()
		if progressPct then
			progressPct.Text = originalText or "0%"
			progressPct.TextColor3 = originalColor or Color3.fromRGB(200,200,230)
			progressPct.TextSize = originalSize or 11
			progressPct.TextXAlignment = originalAlign or Enum.TextXAlignment.Left
			progressPct.ZIndex = 5
		end
		if progressRadLbl then progressRadLbl.Visible = true end
	end)
end

local function stopAutoLeft()
	if alConn then alConn:Disconnect(); alConn = nil end
	alPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function stopAutoRight()
	if arConn then arConn:Disconnect(); arConn = nil end
	arPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

-- ============================================================
--  AUTO LEFT / RIGHT (con exclusión de TP Bat)
-- ============================================================
local function startAutoLeft()
	if State.tpBatEnabled then
		State._setTPBatEnabled(false)
	end

	if alConn then alConn:Disconnect() end
	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not State.autoLeftEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = getProfileNormalSpeed()
		if alPhase == 1 then
			local tgt = Vector3.new(AP.L1.X, hrp2.Position.Y, AP.L1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.L1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP.L2.X, hrp2.Position.Y, AP.L2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoLeftEnabled = false
				if alConn then alConn:Disconnect(); alConn = nil end
				alPhase = 1
				if autoLeftSetVisual then autoLeftSetVisual(false) end
				if (AP.L_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.L_FACE.X, hrp2.Position.Y, AP.L_FACE.Z))
				end
				return
			end
			local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

local function startAutoRight()
	if State.tpBatEnabled then
		State._setTPBatEnabled(false)
	end

	if arConn then arConn:Disconnect() end
	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not State.autoRightEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = getProfileNormalSpeed()
		if arPhase == 1 then
			local tgt = Vector3.new(AP.R1.X, hrp2.Position.Y, AP.R1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.R1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP.R2.X, hrp2.Position.Y, AP.R2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoRightEnabled = false
				if arConn then arConn:Disconnect(); arConn = nil end
				arPhase = 1
				if autoRightSetVisual then autoRightSetVisual(false) end
				if (AP.R_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.R_FACE.X, hrp2.Position.Y, AP.R_FACE.Z))
				end
				return
			end
			local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

-- SECCIÓN 5: FUNCIONES DE DROP Y TP DOWN
local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _tpDownActive = false

local function runDrop()
    if State.dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    State.dropActive = true
    local startedAt = tick()
    State.dropConn = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local r = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
        if not r or not currentHum or currentHum.Health <= 0 then
            if State.dropConn then
                State.dropConn:Disconnect()
                State.dropConn = nil
            end
            State.dropActive = false
            return
        end

        if tick() - startedAt >= DROP_ASCEND_DURATION then
            if State.dropConn then
                State.dropConn:Disconnect()
                State.dropConn = nil
            end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {currentChar}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
                if rr then
                    local offset = (currentHum.HipHeight or 2) + (r.Size.Y / 2)
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + offset, r.Position.Z)
                elseif r.Position.Y < -100 then
                    r.CFrame = CFrame.new(r.Position.X, 5, r.Position.Z)
                end
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
                if currentHum.Health > 0 then
                    currentHum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            State.dropActive = false
            return
        end

        local velocity = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(velocity.X, DROP_ASCEND_SPEED, velocity.Z)
    end)
end

local _tpDownActive = false
local function runTPDown()
	if _tpDownActive then return end
	_tpDownActive = true
	pcall(function()
		local character, humanoid, root = safetyCharacterParts()
		if character then safetyTeleportToFloor(character, humanoid, root) end
	end)
	_tpDownActive = false
end

State._tpBatHittingCooldown = false
State._tpBatHRP = nil
State._tpBatH = nil

State._tpBatGetTool = function()
	local char = LP.Character
	if not char then return nil end

	local bat = char:FindFirstChild("Bat")
	if bat then return bat end

	local backpack = LP:FindFirstChild("Backpack")
	if backpack then
		bat = backpack:FindFirstChild("Bat")
		if bat then
			bat.Parent = char
			return bat
		end
	end

	return nil
end

State._tpBatTryHit = function()
	if State._tpBatHittingCooldown then return end
	State._tpBatHittingCooldown = true

	pcall(function()
		local bat = State._tpBatGetTool()
		if bat then
			bat:Activate()

			local remoteEvent = bat:FindFirstChildWhichIsA("RemoteEvent")
			if remoteEvent then
				remoteEvent:FireServer()
			end

			local remoteFunction = bat:FindFirstChildWhichIsA("RemoteFunction")
			if remoteFunction then
				pcall(function()
					remoteFunction:InvokeServer()
				end)
			end
		end
	end)

	task.delay(0.08, function()
		State._tpBatHittingCooldown = false
	end)
end

State._tpBatClosest = function()
	if not State._tpBatHRP then return nil, math.huge end

	local closest, closestDistance = nil, math.huge
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LP and player.Character then
			local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot then
				local distance = (State._tpBatHRP.Position - targetRoot.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closest = player
				end
			end
		end
	end

	return closest, closestDistance
end

-- ============================================================
--  TP BAT (con desactivación de Auto Left/Right y Bat V1/V2)
-- ============================================================
State._setTPBatEnabled = function(on)
	on = on == true

	if on then
		if State.autoLeftEnabled then
			State.autoLeftEnabled = false
			stopAutoLeft()
			if autoLeftSetVisual then autoLeftSetVisual(false) end
		end
		if State.autoRightEnabled then
			State.autoRightEnabled = false
			stopAutoRight()
			if autoRightSetVisual then autoRightSetVisual(false) end
		end
		if State.autoBatToggled then
			State.autoBatToggled = false
			if autoBatSetVisual then autoBatSetVisual(false) end
			stopBatAimbot()
		end
		if State.autoBatV2Enabled then
			State.autoBatV2Enabled = false
			if autoBatV2SetVisual then autoBatV2SetVisual(false) end
			if mobileBatV2SetActive then mobileBatV2SetActive(false) end
			stopBatAimbotV2()
		end
	else
	end

	State.tpBatEnabled = on
	if State._tpBatSetter then State._tpBatSetter(on) end
	if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
end

RunService.Heartbeat:Connect(function()
	if not State.tpBatEnabled then return end

	if not State._tpBatH or not State._tpBatHRP
		or not State._tpBatH.Parent or not State._tpBatHRP.Parent then
		local char = LP.Character
		if char then
			State._tpBatH = char:FindFirstChildOfClass("Humanoid")
			State._tpBatHRP = char:FindFirstChild("HumanoidRootPart")
		end
		if not State._tpBatH or not State._tpBatHRP then return end
	end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(State._tpBatHRP, "PhysicsRepRootPart", targetRoot)
				end)
			end

			local targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0)
			if (State._tpBatHRP.Position - targetPosition).Magnitude > 5 then
				State._tpBatHRP.CFrame = CFrame.new(targetPosition)
			end

			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end

			State._tpBatTryHit()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if not State.tpBatEnabled then return end
	if not State._tpBatH or not State._tpBatHRP then return end
	if not State._tpBatH.Parent or not State._tpBatHRP.Parent then return end

	local target = State._tpBatClosest()
	if target and target.Character then
		local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if targetRoot then
			local camera = workspace.CurrentCamera
			if camera then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position)
			end
			State._tpBatTryHit()
		end
	end
end)

_bodyLockRespawnConnection = LP.CharacterAdded:Connect(function()
	task.defer(function()
		task.wait(0.5)
		if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end
	end)
end)

AccessoryPackRespawnConnection = LP.CharacterAdded:Connect(function()
	task.defer(function()
		task.wait(0.6)
		if currentAccessoryPack and currentAccessoryPack ~= "Off" then
			applyAccessoryPack(currentAccessoryPack)
		end
	end)
end)

LP.CharacterAdded:Connect(function(character)
	task.wait(0.2)
	State._tpBatH = character:FindFirstChildOfClass("Humanoid")
	State._tpBatHRP = character:FindFirstChild("HumanoidRootPart")
end)

if LP.Character then
	task.spawn(function()
		task.wait(0.2)
		State._tpBatH = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		State._tpBatHRP = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	end)
end

local function startAutoTPDown()
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
	autoTPDownConn = task.spawn(function()
		while autoTPDownEnabled do
			task.wait(0.1)
			pcall(function()
				local char = LP.Character; if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
				local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
				if hum.FloorMaterial ~= Enum.Material.Air then return end
				if root.Position.Y < autoTPDownHeight then return end
				safetyTeleportToFloor(char, hum, root)
			end)
		end
	end)
end

local function stopAutoTPDown()
	autoTPDownEnabled = false
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end

pcall(function()
	if hookfunction and newcclosure then
		local oldFire
		oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
			if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then
				cursedResetRemote=self
			end
			return oldFire(self,...)
		end))
	end
end)

task.spawn(function()
	task.wait(2)
	if cursedResetRemote then return end
	for _,desc in ipairs(game:GetDescendants()) do
		if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then
			cursedResetRemote=desc
			break
		end
	end
end)

local function cursedInstaReset()
	if not cursedResetRemote then
		for _,desc in ipairs(game:GetDescendants()) do
			if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then
				cursedResetRemote=desc
				break
			end
		end
	end
	if not cursedResetRemote then return end

	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoid and humanoid.Health <= 0 then
		pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
		return
	end

	local resetDetected = false
	local conns = {}

	if humanoid then
		table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
		table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			if humanoid.Health <= 0 then resetDetected = true end
		end))
	end
	if character then
		table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
			if not parent then resetDetected = true end
		end))
	end

	task.spawn(function()
		for _ = 1, 50 do
			if resetDetected then break end
			pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
			task.wait()
		end
		for _, conn in ipairs(conns) do
			pcall(function() conn:Disconnect() end)
		end
	end)
end

for _, name in pairs({"FEARV2GUI"}) do
	local old = game:GetService("CoreGui"):FindFirstChild(name)
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
end

-- SECCIÓN 6: GUI PRINCIPAL
local function makeDraggable(frame, isFloating)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	local moved = false
	local DRAG_THRESHOLD = 8
	frame.Active = true

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	frame.InputBegan:Connect(function(inp)
		if uiLocked or (isFloating and not editModeEnabled and (frame.Name == "Btn_TPBat" or frame.Name == "Btn_BatnV2")) then return end
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			dragInput = inp.UserInputType == Enum.UserInputType.Touch and inp or nil
			dragStart = inp.Position
			startPos = frame.Position
			if isFloating and not editModeEnabled then
				groupDragStarts = {}
				for name, button in pairs(mobileButtonsByName) do
					if name ~= "TPBat" and name ~= "BatV2" and button then
						groupDragStarts[name] = button.Position
					end
				end
			end
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then finishDrag() end
			end)
		end
	end)

	frame.InputChanged:Connect(function(inp)
		if (isFloating and (not editModeEnabled or uiLocked)) or (not isFloating and not editModeEnabled and not uiLocked) then finishDrag(); return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)

	UIS.InputChanged:Connect(function(inp)
		if (isFloating and (not editModeEnabled or uiLocked)) or (not isFloating and not editModeEnabled and not uiLocked) then finishDrag(); return end
		if dragging and (inp == dragInput or inp.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = inp.Position - dragStart
			if math.abs(d.X) >= DRAG_THRESHOLD or math.abs(d.Y) >= DRAG_THRESHOLD then
				moved = true
			end
			if moved then
				if isFloating and not editModeEnabled then
					for name, startButtonPos in pairs(groupDragStarts) do
						local button = mobileButtonsByName[name]
						if button then
							button.Position = UDim2.new(startButtonPos.X.Scale, startButtonPos.X.Offset+d.X, startButtonPos.Y.Scale, startButtonPos.Y.Offset+d.Y)
						end
					end
				else
					frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
				end
			end
		end
	end)

	UIS.InputEnded:Connect(function(inp)
		if dragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "CTDuelsGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
	gui.Parent = LP:WaitForChild("PlayerGui")
end

local _C={
	[1]=Color3.fromRGB(8,0,0),
	[2]=Color3.fromRGB(18, 8, 12),
	[3]=Color3.fromRGB(28,10,10),
	[4]=Color3.fromRGB(220, 50, 80),
	[5]=Color3.fromRGB(160,30,50),
	[6]=Color3.fromRGB(255,100,60),
	[7]=Color3.fromRGB(255,240,240),
	[8]=Color3.fromRGB(180,140,145),
	[9]=Color3.fromRGB(50,20,28),
	[10]=Color3.fromRGB(220, 50, 80),
}
local BG=_C[1];local SIDEBAR_BG=_C[2];local CARD_BG=_C[3];local CARD_HOV=_C[4]
local BORDER=_C[5];local BORDER2=_C[6];local WHITE=_C[7];local DIM=_C[8]
local DIM2=_C[9];local KB_BG=_C[10];local INPUT_BG=_C[10]

local function makeDraggableY(guiObject)
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragStart, startPos, moved = false, nil, nil, false
    guiObject.Active = true

    local function finishDrag()
        if not dragging then return end
        dragging = false
        if moved then
            moved = false
            if State.requestPositionSave then State.requestPositionSave() end
            if State.requestConfigSave then State.requestConfigSave() end
        end
    end

    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then finishDrag() end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.Y) > 1 then moved = true end
            local newY = startPos.Y.Offset + delta.Y
            local visibleOffset = 375

            local frameHeight = guiObject.AbsoluteSize.Y
            local screenHeight = guiObject.Parent.AbsoluteSize.Y

            local minY = visibleOffset - frameHeight
            local maxY = screenHeight - visibleOffset
            local clampedY = math.clamp(newY, minY, maxY)

            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, clampedY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            finishDrag()
        end
    end)
end

local W, H, SW =360, 520, 118
local CORNER = 18

local uiScaleValue = 80
local mainUIScale = nil
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 22, 0.5, -150)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Visible = false
main.BackgroundTransparency = 0

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, CORNER)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = BORDER
mainStroke.Thickness = 1.25
mainStroke.Transparency = 0.08

local premiumInnerBorder = Instance.new("Frame", main)
premiumInnerBorder.Name = "PremiumInnerBorder"
premiumInnerBorder.Size = UDim2.new(1, -8, 1, -8)
premiumInnerBorder.Position = UDim2.new(0, 4, 0, 4)
premiumInnerBorder.BackgroundTransparency = 1
premiumInnerBorder.BorderSizePixel = 0
premiumInnerBorder.ZIndex = 2
local premiumInnerCorner = Instance.new("UICorner", premiumInnerBorder)
premiumInnerCorner.CornerRadius = UDim.new(0, math.max(CORNER - 4, 0))
local premiumInnerStroke = Instance.new("UIStroke", premiumInnerBorder)
premiumInnerStroke.Color = Color3.fromRGB(70, 160, 255)
premiumInnerStroke.Thickness = 1
premiumInnerStroke.Transparency = 0.48

mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = 0.80

local fullUIBackground = Instance.new("ImageLabel", main)
fullUIBackground.Name = "FullUIBackground"
fullUIBackground.Size = UDim2.new(1, -2, 1, -2)
fullUIBackground.Position = UDim2.new(0, 1, 0, 1)
fullUIBackground.BackgroundTransparency = 1
fullUIBackground.BorderSizePixel = 0
fullUIBackground.Image = "rbxassetid://" .. tostring(State.backgroundAssetId)
fullUIBackground.ImageTransparency = 0.18
fullUIBackground.ScaleType = Enum.ScaleType.Crop
fullUIBackground.ZIndex = 1
local fullUIBackgroundCorner = Instance.new("UICorner", fullUIBackground)
fullUIBackgroundCorner.CornerRadius = UDim.new(0, math.max(CORNER - 1, 0))

State.applyBackgroundImage = function(assetId, shouldSave)
	assetId = tostring(assetId or "")
	local valid = false
	for _, id in ipairs(State.backgroundAssetIds) do
		if id == assetId then valid = true; break end
	end
	if not valid then assetId = State.backgroundAssetIds[1] end

	State.backgroundAssetId = assetId
	if fullUIBackground and fullUIBackground.Parent then
		fullUIBackground.Image = "rbxassetid://" .. assetId
	end

	for id, visual in pairs(State.imageChoiceVisuals) do
		local selected = id == assetId
		if visual.stroke then
			visual.stroke.Color = selected and WHITE or BORDER
			visual.stroke.Thickness = selected and 2.2 or 1
		end
		if visual.badge then
			visual.badge.Text = selected and ("✓ " .. tostring(visual.index)) or tostring(visual.index)
			visual.badge.BackgroundColor3 = selected and WHITE or Color3.fromRGB(5, 15, 35)
			visual.badge.TextColor3 = selected and BG or WHITE
		end
	end

	if shouldSave then
		-- Guardado inmediato: al cerrar Roblox, algunos ejecutores no disparan
		-- AncestryChanged o BindToClose antes de que termine el retraso.
		State._configDirty = true
		if State._configLoaded and not State._configLoading and saveConfig then
			task.defer(function()
				local ok = pcall(saveConfig)
				if not ok and State.requestConfigSave then
					State.requestConfigSave()
				end
			end)
		elseif State.requestConfigSave then
			State.requestConfigSave()
		end
	end
end

local topbar = Instance.new("Frame", main)
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = SIDEBAR_BG
topbar.BackgroundTransparency = 0.32
topbar.BorderSizePixel = 0
topbar.ZIndex = 10
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, CORNER)
local topPatch = Instance.new("Frame", topbar)
topPatch.Size = UDim2.new(1, 0, 0, CORNER)
topPatch.Position = UDim2.new(0, 0, 1, -CORNER)
topPatch.BackgroundColor3 = SIDEBAR_BG
topPatch.BackgroundTransparency = 0.32
topPatch.BorderSizePixel = 0
topPatch.ZIndex = 9
local topDiv = Instance.new("Frame", topbar)
topDiv.Size = UDim2.new(1, 0, 0, 1)
topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = Color3.fromRGB(220, 50, 80)
topDiv.BorderSizePixel = 0
topDiv.ZIndex = 11

local premiumTopLine = Instance.new("Frame", topbar)
premiumTopLine.Name = "PremiumTopLine"
premiumTopLine.Size = UDim2.new(1, -28, 0, 2)
premiumTopLine.Position = UDim2.new(0, 14, 0, 3)
premiumTopLine.BackgroundColor3 = Color3.fromRGB(220, 50, 80)
premiumTopLine.BorderSizePixel = 0
premiumTopLine.ZIndex = 14
local premiumTopCorner = Instance.new("UICorner", premiumTopLine)
premiumTopCorner.CornerRadius = UDim.new(1, 0)
local premiumTopGradient = Instance.new("UIGradient", premiumTopLine)
premiumTopGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80,10,10)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80,10,10))
})
premiumTopGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.55),
    NumberSequenceKeypoint.new(0.5, 0.02),
    NumberSequenceKeypoint.new(1, 0.55)
})

local titleLbl = Instance.new("TextLabel", topbar)
titleLbl.Size = UDim2.new(0, 190, 1, 0)
titleLbl.Position = UDim2.new(0, 17, 0, -3)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = " SHYNX.CC"
titleLbl.TextColor3 = WHITE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12

local verLbl = Instance.new("TextLabel", topbar)
verLbl.Size = UDim2.new(0, 240, 0, 14)
verLbl.Position = UDim2.new(0, 18, 0, 28)
verLbl.BackgroundTransparency = 1
verLbl.Text = "ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤCREATE BY COMINO FACK"
verLbl.TextColor3 = DIM
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 8
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 12

local minBtn = Instance.new("TextButton", topbar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = KB_BG
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = WHITE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.ZIndex = 13
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", minBtn).Color = BORDER
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=KB_BG}):Play() end)

do
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPosition = nil
	local moved = false

	local dragZone = Instance.new("TextButton", topbar)
	dragZone.Name = "TopbarDragZone"
	dragZone.Size = UDim2.new(1, -48, 1, 0)
	dragZone.Position = UDim2.new(0, 0, 0, 0)
	dragZone.BackgroundTransparency = 1
	dragZone.BorderSizePixel = 0
	dragZone.Text = ""
	dragZone.AutoButtonColor = false
	dragZone.Active = true
	dragZone.ZIndex = 13

	local function finishDrag()
		if not dragging then return end
		dragging = false
		dragInput = nil
		if moved then
			moved = false
			if State.requestPositionSave then State.requestPositionSave() end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end

	dragZone.InputBegan:Connect(function(input)
		if uiLocked then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1
		and input.UserInputType ~= Enum.UserInputType.Touch then return end

		dragging = true
		moved = false
		dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
		dragStart = input.Position
		startPosition = main.Position
				input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				finishDrag()
			end
		end)
	end)

	dragZone.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if uiLocked then finishDrag(); return end
		if not dragging then return end
		if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

		local delta = input.Position - dragStart

		if math.abs(delta.X) > 1 or math.abs(delta.Y) > 1 then moved = true end
		main.Position = UDim2.new(
			startPosition.X.Scale, startPosition.X.Offset + delta.X,
			startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
		)
	end)

	UIS.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch) then
			finishDrag()
		end
	end)
end

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(1, 0, 0, 42)
sidebar.Position = UDim2.new(0, 0, 0, 58)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BackgroundTransparency = 0.48
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5
sidebar.ClipsDescendants = true
do local _sc=Instance.new("UICorner",sidebar); _sc.CornerRadius=UDim.new(0,CORNER) end


local content = Instance.new("Frame", main)
content.Name = "ContentArea"
content.Size = UDim2.new(1, 0, 1, -100)
content.Position = UDim2.new(0, 0, 0, 100)
content.BackgroundColor3 = BG
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 100

local mini = Instance.new("TextButton", gui)
mini.Name = "CTDuelsMini"
mini.Size = UDim2.new(0, 115, 0, 36)
mini.Position = UDim2.new(0.5, -75, 0, 10)
mini.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
mini.BorderSizePixel = 0
mini.Text = "MENU"
mini.TextColor3 = WHITE
mini.Font = Enum.Font.GothamBlack
mini.TextSize = 13
mini.TextXAlignment = Enum.TextXAlignment.Center
mini.ZIndex = 20
mini.Visible = true
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 16)
local miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = Color3.fromRGB(220, 50, 80)
miniStroke.Thickness = 1.5

makeDraggable(mini)
mini.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

local function openGui()
	main.Visible = true
	mini.Visible = false
	main.BackgroundTransparency = 0
	mainUIScale.Scale = 0.85
	TweenService:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = uiScaleValue / 100}):Play()
end

local function closeGui()
	TweenService:Create(mainUIScale, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.85}):Play()
	task.delay(0.2, function()
		if main and main.Parent then main.Visible = false end
		if mini and mini.Parent then mini.Visible = true end
	end)
end

minBtn.MouseButton1Click:Connect(closeGui)
mini.MouseButton1Click:Connect(openGui)

mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=CARD_HOV}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=BG}):Play() end)

local tabs = {}
local tabPages = {}
local activeTabName = nil
local tabDefs = {
	{name="Speed"},
	{name="Music"},
	{name="Visuals"},
	{name="Utility"},
}
local switchTab
local pageLOs = {}

local tabListFrame = Instance.new("Frame", sidebar)
tabListFrame.Size = UDim2.new(1, 0, 1, 0)
tabListFrame.Position = UDim2.new(0, 0, 0, 0)
tabListFrame.BackgroundTransparency = 1
tabListFrame.BorderSizePixel = 0
tabListFrame.ZIndex = 6

local tabLL = Instance.new("UIListLayout", tabListFrame)
tabLL.FillDirection = Enum.FillDirection.Horizontal
tabLL.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLL.VerticalAlignment = Enum.VerticalAlignment.Center
tabLL.SortOrder = Enum.SortOrder.LayoutOrder
tabLL.Padding = UDim.new(0, 4)
local tabPad = Instance.new("UIPadding", tabListFrame)
tabPad.PaddingTop = UDim.new(0, 4)
tabPad.PaddingLeft = UDim.new(0, 8)
tabPad.PaddingRight = UDim.new(0, 8)

local ACTIVE_TAB_BG  = CARD_HOV
local ACTIVE_TAB_TXT = WHITE
local IDLE_TAB_BG    = CARD_BG
local IDLE_TAB_TXT   = WHITE

switchTab = function(name)
	activeTabName = name
	for _, td in ipairs(tabDefs) do
		local t = tabs[td.name]
		local isA = td.name == name
		TweenService:Create(t.frame, TweenInfo.new(0.14), {
			BackgroundColor3 = isA and ACTIVE_TAB_BG or IDLE_TAB_BG,
			BackgroundTransparency = isA and TAB_HOVER_TRANSPARENCY or TAB_TRANSPARENCY
		}):Play()
		TweenService:Create(t.lbl, TweenInfo.new(0.14), {
			TextColor3 = isA and ACTIVE_TAB_TXT or IDLE_TAB_TXT
		}):Play()
		if t.mark then
			TweenService:Create(t.mark, TweenInfo.new(0.14), {
				BackgroundTransparency = isA and 0.02 or 1
			}):Play()
		end
		tabPages[td.name].Visible = isA
	end
end

for i, td in ipairs(tabDefs) do
	local btn = Instance.new("TextButton", tabListFrame)
	btn.Size = UDim2.new(0, 78, 0, 34)
	btn.BackgroundColor3 = IDLE_TAB_BG
	btn.BackgroundTransparency = TAB_TRANSPARENCY
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.LayoutOrder = i
	btn.ZIndex = 7
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 11)
	local bSt = Instance.new("UIStroke", btn)
	bSt.Color = BORDER
	bSt.Thickness = 1

	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.Position = UDim2.new(0, 0, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = string.upper(td.name)
	lbl.TextColor3 = IDLE_TAB_TXT
	lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 9
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.TextWrapped = false
	lbl.TextTruncate = Enum.TextTruncate.AtEnd
	lbl.ZIndex = 9
	local activeMark = Instance.new("Frame", btn)
	activeMark.Name = "ActiveMark"
	activeMark.Size = UDim2.new(0, 3, 0, 14)
	activeMark.Position = UDim2.new(0, 3, 0.5, -7)
	activeMark.BackgroundColor3 = WHITE
	activeMark.BackgroundTransparency = 1
	activeMark.BorderSizePixel = 0
	activeMark.ZIndex = 10
	Instance.new("UICorner", activeMark).CornerRadius = UDim.new(1, 0)

	tabs[td.name] = {frame=btn, lbl=lbl, mark=activeMark}

	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundColor3 = BG
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = BORDER
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Active = true
	page.ScrollingEnabled = true
	page.ScrollingDirection = Enum.ScrollingDirection.Y
	page.ClipsDescendants = true
	page.Visible = false
	page.ZIndex = 3
	local pll = Instance.new("UIListLayout", page)
	pll.SortOrder = Enum.SortOrder.LayoutOrder
	pll.Padding = UDim.new(0, 7)
	local pp = Instance.new("UIPadding", page)
	pp.PaddingLeft = UDim.new(0, 13)
	pp.PaddingRight = UDim.new(0, 13)
	pp.PaddingTop = UDim.new(0, 12)
	pp.PaddingBottom = UDim.new(0, 48)
	tabPages[td.name] = page
	pageLOs[td.name] = 0
	btn.Activated:Connect(function() switchTab(td.name) end)
	btn.MouseEnter:Connect(function()
		if activeTabName ~= td.name then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=ACTIVE_TAB_BG, BackgroundTransparency=TAB_HOVER_TRANSPARENCY}):Play() end
	end)
	btn.MouseLeave:Connect(function()
		if activeTabName ~= td.name then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=IDLE_TAB_BG, BackgroundTransparency=TAB_TRANSPARENCY}):Play() end
	end)
end

-- Captura el gesto aunque comience sobre un toggle, selector u otro control.
do
	local touchPage, touchStart, canvasStart, touchMoved
	local function pageUnder(point)
		for _, page in pairs(tabPages) do
			if page.Visible then
				local p, s = page.AbsolutePosition, page.AbsoluteSize
				if point.X >= p.X and point.X <= p.X + s.X and point.Y >= p.Y and point.Y <= p.Y + s.Y then
					return page
				end
			end
		end
	end
	UIS.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch then return end
		touchPage = pageUnder(input.Position)
		if touchPage and touchPage.ScrollingEnabled then
			touchStart = input.Position
			canvasStart = touchPage.CanvasPosition
			touchMoved = false
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch or not touchPage then return end
		local delta = input.Position - touchStart
		if math.abs(delta.Y) > 3 then touchMoved = true end
		if not touchMoved then return end
		local maxY = math.max(0, touchPage.AbsoluteCanvasSize.Y - touchPage.AbsoluteSize.Y)
		touchPage.CanvasPosition = Vector2.new(canvasStart.X, math.clamp(canvasStart.Y - delta.Y, 0, maxY))
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			touchPage, touchStart, canvasStart, touchMoved = nil, nil, nil, nil
		end
	end)
end

local function lo(tabName) pageLOs[tabName] = pageLOs[tabName] + 1; return pageLOs[tabName] end
local function pg(tabName) return tabPages[tabName] end

local function makeSecHeader(tabName, text)
	local f = Instance.new("Frame", pg(tabName))
	f.Size = UDim2.new(1, 0, 0, 24)
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0
	f.LayoutOrder = lo(tabName)
	f.ZIndex = 4

	local accent = Instance.new("Frame", f)
	accent.Size = UDim2.new(0, 3, 0, 12)
	accent.Position = UDim2.new(0, 0, 0.5, -6)
	accent.BackgroundColor3 = WHITE
	accent.BorderSizePixel = 0
	accent.ZIndex = 5
	Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)

	local t = Instance.new("TextLabel", f)
	t.Size = UDim2.new(1, -12, 0, 16)
	t.Position = UDim2.new(0, 9, 0, 1)
	t.BackgroundTransparency = 1
	t.Text = text:upper()
	t.TextColor3 = WHITE
	t.Font = Enum.Font.GothamBold
	t.TextSize = 8
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.TextWrapped = false
	t.TextTruncate = Enum.TextTruncate.AtEnd
	t.ZIndex = 5

	local line = Instance.new("Frame", f)
	line.Size = UDim2.new(1, -9, 0, 1)
	line.Position = UDim2.new(0, 9, 1, -2)
	line.BackgroundColor3 = BORDER
	line.BackgroundTransparency = 0.25
	line.BorderSizePixel = 0
	line.ZIndex = 4
end

ACCESSORY_PACK_ORDER = {
    {"Off", "Off"},
    {"Korblox", "Korblox"},
    {"Headless", "Headless"},
    {"Both", "Both"}
}
currentAccessoryPack = "Off"
accSelectorLabel = nil

function clearAccessories()
    local char = LP.Character
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then
            pcall(function() child:Destroy() end)
        end
    end
    local partsToHide = {"Head", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
    for _, partName in ipairs(partsToHide) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
        end
    end
end

function attachKorbloxLeg(legName, config)
    local char = LP.Character
    if not char then return false, "No character" end

    local targetPart = char:FindFirstChild(config.targetBodyPart)
    if not targetPart then return false, "Target part missing" end

    local oldAsset = char:FindFirstChild("Korblox_" .. legName:gsub("%s+", ""))
    if oldAsset then oldAsset:Destroy() end

    for _, partName in ipairs(config.partsToHide) do
        local limb = char:FindFirstChild(partName)
        if limb and limb:IsA("BasePart") then
            limb.Transparency = 1
        end
    end

    local success, objects = pcall(function()
        return game:GetObjects(config.id)
    end)
    if not success or not objects or #objects == 0 then
        return false, "Asset fetch failed"
    end

    local assetModel = objects[1]
    assetModel.Name = "Korblox_" .. legName:gsub("%s+", "")

    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        return false, "No MeshPart in asset"
    end

    mainMesh.Size = mainMesh.Size * config.scale
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame * config.offset

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    assetModel.Parent = char
    return true
end

function attachHeadless()
    local char = LP.Character
    if not char then return false, "No character" end

    local targetPart = char:FindFirstChild("Head")
    if not targetPart then return false, "Head missing" end

    local oldAsset = char:FindFirstChild("Headless_Headless")
    if oldAsset then oldAsset:Destroy() end

    targetPart.Transparency = 1

    local success, objects = pcall(function()
        return game:GetObjects("rbxassetid://134082579")
    end)
    if not success or not objects or #objects == 0 then
        return false, "Asset fetch failed"
    end

    local assetModel = objects[1]
    assetModel.Name = "Headless_Headless"

    local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
    if not mainMesh then
        return false, "No MeshPart in asset"
    end

    mainMesh.Size = mainMesh.Size * Vector3.new(1,1,1)
    mainMesh.CanCollide = false
    mainMesh.CFrame = targetPart.CFrame

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = targetPart
    weld.Part1 = mainMesh
    weld.Parent = mainMesh

    assetModel.Parent = char
    return true
end

function applyAccessoryPack(packName)
    clearAccessories()
    if packName == "Off" then return end

    local rightLegConfig = {
        id = "rbxassetid://139607718",
        targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = Vector3.new(1,1,1),
        offset = CFrame.new(0,0,0)
    }

    if packName == "Korblox" or packName == "Both" then
        attachKorbloxLeg("Right Leg", rightLegConfig)
    end

    if packName == "Headless" or packName == "Both" then
        attachHeadless()
    end
end


local _unwalkSavedAnimate = nil
function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                end
            end
        end
    end
    return closest
end

function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    _bodyLockConn = RunService.RenderStepped:Connect(function()
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() _bodyLockConn = nil end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then task.cancel(_blRestoreTimer) _blRestoreTimer = nil end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        local function restore()
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
            _blRestoreTimer = nil
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end


local function startUnwalk()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
    local anim = c:FindFirstChild("Animate")
    if anim then _unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end
local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif _unwalkSavedAnimate then _unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    _unwalkSavedAnimate = nil
end

local function baseCard(tabName, h2)
	local c = Instance.new("Frame", pg(tabName))
	c.Size = UDim2.new(1, 0, 0, h2 or 38)
	c.BackgroundColor3 = CARD_BG
	c.BackgroundTransparency = OPTION_TRANSPARENCY
	c.BorderSizePixel = 0
	c.LayoutOrder = lo(tabName)
	c.ZIndex = 4
	Instance.new("UICorner", c).CornerRadius = UDim.new(0, 12)
	local cSt = Instance.new("UIStroke", c)
	cSt.Color = BORDER
	cSt.Thickness = 1
	cSt.Transparency = 0.18

	local sideAccent = Instance.new("Frame", c)
	sideAccent.Name = "VisualAccent"
	sideAccent.Size = UDim2.new(0, 2, 0.54, 0)
	sideAccent.Position = UDim2.new(0, 1, 0.23, 0)
	sideAccent.BackgroundColor3 = BORDER
	sideAccent.BackgroundTransparency = 0.2
	sideAccent.BorderSizePixel = 0
	sideAccent.ZIndex = 5
	Instance.new("UICorner", sideAccent).CornerRadius = UDim.new(1, 0)

	local bottomDetail = Instance.new("Frame", c)
	bottomDetail.Name = "BottomDetail"
	bottomDetail.Size = UDim2.new(1, -24, 0, 1)
	bottomDetail.Position = UDim2.new(0, 12, 1, -1)
	bottomDetail.BackgroundColor3 = Color3.fromRGB(70, 160, 255)
	bottomDetail.BackgroundTransparency = 0.58
	bottomDetail.BorderSizePixel = 0
	bottomDetail.ZIndex = 5

	c.MouseEnter:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	c.MouseLeave:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return c
end

local function cLabel(p, text, x, w, sz, col, font, xa)
	local l = Instance.new("TextLabel", p)
	l.Size = UDim2.new(0, w or 140, 1, 0)
	l.Position = UDim2.new(0, x or 10, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = col or WHITE
	l.Font = font or Enum.Font.GothamBold
	l.TextSize = sz or 11
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.ZIndex = 10
	return l
end

local function makePillToggle(parent, defOn, onToggle)
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", parent)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", parent)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV
end

local function makeKB(parent, kbEntry, onChange)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, 44, 0, 20)
	b.BackgroundColor3 = KB_BG
	b.BackgroundTransparency = INPUT_TRANSPARENCY
	b.BorderSizePixel = 0
	local function getDisplayText()
		if kbEntry.gp then return "GP:"..kbEntry.gp.Name
		elseif kbEntry.kb then return kbEntry.kb.Name
		else return "None" end
	end
	b.Text = getDisplayText()
	State._bindButtons = State._bindButtons or {}
	State._bindButtons[kbEntry] = b
	b.TextColor3 = WHITE
	b.Font = Enum.Font.GothamBold
	b.TextSize = 8
	b.ZIndex = 11
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local bs = Instance.new("UIStroke", b); bs.Color = BORDER; bs.Thickness = 1
	local li = false; local lc; local pv = b.Text
	b.MouseButton1Click:Connect(function()
		if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; b.Text=pv; b.TextColor3=WHITE; return end
		pv=b.Text; li=true; _anyKeyListening=true; b.Text="···"; b.TextColor3=DIM
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play()
		lc = UIS.InputBegan:Connect(function(inp)
			if not li then return end
			local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
			local isGp = string.sub(inp.UserInputType.Name, 1, 7) == "Gamepad"
			if not isKb and not isGp then return end
			if inp.KeyCode == Enum.KeyCode.Escape then
				li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
				b.Text=pv; b.TextColor3=WHITE; TweenService:Create(bs,TweenInfo.new(0.1),{Color=BORDER}):Play(); return
			end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
				b.Text = "GP:"..inp.KeyCode.Name; pv = b.Text
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
				b.Text = inp.KeyCode.Name; pv = b.Text
			end
			b.TextColor3=WHITE
			li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
			TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
			if onChange then onChange(inp.KeyCode) end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)
	end)
	return b
end

local function rowToggle(tabName, label, sub, defOn, onToggle)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	return makePillToggle(c, defOn, onToggle)
end

local function rowToggleKB(tabName, label, sub, kbEntry, defOn, onToggle, onKeyChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 120, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 120, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 150, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 150, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10+36+8+19), 0.5, -10)
	kb.ZIndex = 11
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", c)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or DIM2
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or BORDER
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or DIM2}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or BORDER
		}):Play()
	end
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return setV, kb
end

local function rowKBOnly(tabName, label, sub, kbEntry, onKeyChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 160, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	return kb
end

local function rowInput(tabName, label, sub, default, onChange)
	local c = baseCard(tabName, sub and 58 or 38)
	local titleLabel = cLabel(c, label, 10, 130, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		titleLabel.Size = UDim2.new(0, 130, 0, 18)
		titleLabel.Position = UDim2.new(0, 10, 0, 7)
		local sl = cLabel(c, sub, 10, 160, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 160, 0, 13)
		sl.Position = UDim2.new(0, 10, 0, 35)
	end
	local box = Instance.new("TextBox", c)
	box.Size = UDim2.new(0, 64, 0, 24)
	box.Position = UDim2.new(1, -74, 0.5, -12)
	box.BackgroundColor3 = INPUT_BG
	box.BackgroundTransparency = INPUT_TRANSPARENCY
	box.BorderSizePixel = 0
	box.Text = tostring(default)
	box.TextColor3 = WHITE
	box.Font = Enum.Font.GothamBold
	box.TextSize = 11
	box.ClearTextOnFocus = false
	box.ZIndex = 11
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
	local bs = Instance.new("UIStroke", box); bs.Color = BORDER; bs.Thickness = 1; bs.ZIndex = 12
	box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play() end)
	box.FocusLost:Connect(function()
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER}):Play()
		if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	return box
end

local function rowActionBtn(tabName, label, onClick)
	local b = Instance.new("TextButton", pg(tabName))
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = CARD_BG
	b.BackgroundTransparency = OPTION_TRANSPARENCY
	b.BorderSizePixel = 0
	b.Text = label
	b.TextColor3 = WHITE
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.LayoutOrder = lo(tabName)
	b.ZIndex = 5
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
	local bSt = Instance.new("UIStroke", b)
	bSt.Color = BORDER
	bSt.Thickness = 1.2

	local pressScale = Instance.new("UIScale", b)
	pressScale.Scale = 1

	b.MouseButton1Click:Connect(function()
		TweenService:Create(pressScale, TweenInfo.new(0.06), {Scale=0.975}):Play()
		TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play()
		task.delay(0.08, function()
			if pressScale and pressScale.Parent then
				TweenService:Create(pressScale, TweenInfo.new(0.09, Enum.EasingStyle.Back), {Scale=1}):Play()
			end
		end)
		task.delay(0.15, function()
			if b and b.Parent then
				TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play()
			end
		end)
		if onClick then pcall(onClick) end
	end)
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV, BackgroundTransparency=OPTION_HOVER_TRANSPARENCY}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG, BackgroundTransparency=OPTION_TRANSPARENCY}):Play() end)
	return b
end

local function rowCycleSelector(tabName, label, options, defaultValue, onChange)
	local c = baseCard(tabName, 40)
	cLabel(c, label, 10, 110, 11, WHITE, Enum.Font.GothamBold)

	local left = Instance.new("TextButton", c)
	left.Size = UDim2.new(0, 26, 0, 24)
	left.Position = UDim2.new(1, -142, 0.5, -12)
	left.BackgroundColor3 = INPUT_BG
	left.BackgroundTransparency = INPUT_TRANSPARENCY
	left.BorderSizePixel = 0
	left.Text = "<"
	left.TextColor3 = WHITE
	left.Font = Enum.Font.GothamBlack
	left.TextSize = 15
	left.ZIndex = 12
	Instance.new("UICorner", left).CornerRadius = UDim.new(0, 12)
	local leftStroke = Instance.new("UIStroke", left); leftStroke.Color = BORDER; leftStroke.Thickness = 1

	local valueLabel = Instance.new("TextLabel", c)
	valueLabel.Size = UDim2.new(0, 78, 0, 24)
	valueLabel.Position = UDim2.new(1, -112, 0.5, -12)
	valueLabel.BackgroundColor3 = INPUT_BG
	valueLabel.BackgroundTransparency = INPUT_TRANSPARENCY
	valueLabel.BorderSizePixel = 0
	valueLabel.TextColor3 = WHITE
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 9
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
	valueLabel.ZIndex = 11
	Instance.new("UICorner", valueLabel).CornerRadius = UDim.new(0, 12)
	local valueStroke = Instance.new("UIStroke", valueLabel); valueStroke.Color = BORDER; valueStroke.Thickness = 1

	local right = Instance.new("TextButton", c)
	right.Size = UDim2.new(0, 26, 0, 24)
	right.Position = UDim2.new(1, -30, 0.5, -12)
	right.BackgroundColor3 = INPUT_BG
	right.BackgroundTransparency = INPUT_TRANSPARENCY
	right.BorderSizePixel = 0
	right.Text = ">"
	right.TextColor3 = WHITE
	right.Font = Enum.Font.GothamBlack
	right.TextSize = 15
	right.ZIndex = 12
	Instance.new("UICorner", right).CornerRadius = UDim.new(0, 12)
	local rightStroke = Instance.new("UIStroke", right); rightStroke.Color = BORDER; rightStroke.Thickness = 1

	local index = 1
	for i, option in ipairs(options) do
		if option == defaultValue then index = i; break end
	end

	local function setValue(value, fireCallback)
		if type(value) == "number" then
			index = ((math.floor(value) - 1) % #options) + 1
		else
			for i, option in ipairs(options) do
				if option == value then index = i; break end
			end
		end
		valueLabel.Text = options[index]
		if fireCallback and onChange then pcall(onChange, options[index], index) end
		return options[index]
	end

	local function move(direction)
		setValue(index + direction, true)
		if State.requestConfigSave then State.requestConfigSave() end
	end

	left.Activated:Connect(function() move(-1) end)
	right.Activated:Connect(function() move(1) end)
	left.MouseEnter:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	left.MouseLeave:Connect(function() TweenService:Create(left, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)
	right.MouseEnter:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=0.05}):Play() end)
	right.MouseLeave:Connect(function() TweenService:Create(right, TweenInfo.new(0.1), {BackgroundTransparency=INPUT_TRANSPARENCY}):Play() end)

	setValue(defaultValue, false)
	return setValue, function() return options[index] end
end

-- SECCIÓN 7: PESTAÑA SPEED Y AUTO CARRY
do
makeSecHeader("Speed", "Speed Configuration")

do
	local c = baseCard("Speed", 48)
	cLabel(c, "Speed Profile", 10, 92, 11, WHITE, Enum.Font.GothamBold)

	local holder = Instance.new("Frame", c)
	holder.Name = "SpeedProfileSelector"
	holder.Size = UDim2.new(0, 150, 0, 28)
	holder.Position = UDim2.new(1, -160, 0.5, -14)
	holder.BackgroundTransparency = 1
	holder.BorderSizePixel = 0
	holder.ZIndex = 12

	local layout = Instance.new("UIListLayout", holder)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 6)

	local function makeProfileButton(label)
		local b = Instance.new("TextButton", holder)
		b.Name = label .. "Profile"
		b.Size = UDim2.new(0, 72, 0, 28)
		b.BackgroundColor3 = CARD_BG
		b.BackgroundTransparency = 0.12
		b.BorderSizePixel = 0
		b.Text = string.upper(label)
		b.TextColor3 = DIM
		b.TextSize = 10
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = false
		b.ZIndex = 13
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		local stroke = Instance.new("UIStroke", b)
		stroke.Color = Color3.fromRGB(70, 160, 255)
		stroke.Thickness = 1
		stroke.Transparency = 0.3
		return b, stroke
	end

	local normalProfileBtn, normalProfileStroke = makeProfileButton("Normal")
	local laggerProfileBtn, laggerProfileStroke = makeProfileButton("Lagger")

	local function refreshProfileVisual()
		local normalActive = State.speedProfile ~= "Lagger"
		TweenService:Create(normalProfileBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = normalActive and BORDER or CARD_BG,
			TextColor3 = normalActive and WHITE or DIM,
			BackgroundTransparency = normalActive and 0.02 or 0.12
		}):Play()
		TweenService:Create(laggerProfileBtn, TweenInfo.new(0.12), {
			BackgroundColor3 = not normalActive and BORDER or CARD_BG,
			TextColor3 = not normalActive and WHITE or DIM,
			BackgroundTransparency = not normalActive and 0.02 or 0.12
		}):Play()
		normalProfileStroke.Color = normalActive and BORDER2 or Color3.fromRGB(70, 160, 255)
		laggerProfileStroke.Color = not normalActive and BORDER2 or Color3.fromRGB(70, 160, 255)
	end

	local function selectProfile(profile)
		State.speedProfile = profile == "Lagger" and "Lagger" or "Normal"
		refreshProfileVisual()
		if normalBox then
			normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS)
		end
		if carryBox then
			carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS)
		end
		if modeValLbl then
			if State.laggerToggled then
				modeValLbl.Text = laggerPhase == 2 and "Lagger 2" or "Lagger 1"
			elseif State.speedToggled then
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"
			else
				modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"
			end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	normalProfileBtn.Activated:Connect(function() selectProfile("Normal") end)
	laggerProfileBtn.Activated:Connect(function() selectProfile("Lagger") end)

	State._refreshSpeedProfileVisual = refreshProfileVisual
	State._selectSpeedProfile = selectProfile
	refreshProfileVisual()
end

normalBox = rowInput("Speed", "Normal Speed", nil, NS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerNormalSpeed = v
		else
			NS = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
carryBox = rowInput("Speed", "Carry Speed", nil, CS, function(v)
	if v > 0 and v <= 500 then
		if State.speedProfile == "Lagger" then
			State.profileLaggerCarrySpeed = v
		else
			CS = v
			_G.CarrySpeedValue = v
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)
laggerBox = rowInput("Speed", "Lagger 1", nil, LS, function(v) if v>0 and v<=500 then LS=v end end)
laggerBox2 = rowInput("Speed", "Lagger 2", nil, LS2, function(v) if v>0 and v<=500 then LS2=v end end)

-- ===== TOGGLE AUTO CARRY (AHORA PERSISTE) =====
do
    local sv
    sv = rowToggle("Speed", "Auto Carry", "Se activa carry automáticamente al agarrar el Brainrot", State.autoCarryEnabled,
    function(on)
        State.autoCarryEnabled = on
        if State.requestConfigSave then State.requestConfigSave() end
    end)
    State.autoCarrySetVisual = sv
end

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Mode", 10, 80, 11, WHITE, Enum.Font.GothamBold)
	modeValLbl = cLabel(c, "Normal", 88, 80, 10, DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	local kb = makeKB(c, KB.Speed, function(k) end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.speedToggled = not State.speedToggled
		if State.speedToggled then
			State.laggerToggled = false
			if mobileLaggerSetActive then mobileLaggerSetActive(false) end
		end
		if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Lagger Mode", 10, 120, 11, WHITE, Enum.Font.GothamBold)
	local kb = makeKB(c, KB.Lagger, function(k) KB.Lagger.kb = k end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.laggerToggled = not State.laggerToggled
		if State.laggerToggled then
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
		end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
		if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

makeSecHeader("Speed", "MOVEMENT & DROP")
rowKBOnly("Speed", "TP Down", "Teleport to floor", KB.TPDown, function(k) KB.TPDown.kb=k end)
do
	local sv
	sv, _ = rowToggleKB("Speed", "Auto Left", nil, KB.AutoLeft, false,
	function(on)
		State.autoLeftEnabled = on
		if on then
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				startAutoLeft()
			end
		else stopAutoLeft() end
		if mobileAutoLeftSetActive then mobileAutoLeftSetActive(on) end
	end, function(k) KB.AutoLeft.kb=k end)
	autoLeftSetVisual = sv
end
do
	local sv
	sv, _ = rowToggleKB("Speed", "Auto Right", nil, KB.AutoRight, false,
	function(on)
		State.autoRightEnabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			if State.autoBatV2Enabled then State.autoBatV2Enabled=false; if autoBatV2SetVisual then autoBatV2SetVisual(false) end; stopBatAimbotV2() end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum and hrp and hum.WalkSpeed > 0 and not hrp.Anchored then
				startAutoRight()
			end
		else stopAutoRight() end
		if mobileAutoRightSetActive then mobileAutoRightSetActive(on) end
	end, function(k) KB.AutoRight.kb=k end)
	autoRightSetVisual = sv
end
rowKBOnly("Speed", "Drop",    nil, KB.Drop,   function(k) KB.Drop.kb=k end)

do
	setAutoTPDownVisual = rowToggle("Speed", "Auto TP Down", nil, false, function(on)
		autoTPDownEnabled = on
		if mobileAutoTPSetActive then mobileAutoTPSetActive(on) end
		if on then startAutoTPDown() else stopAutoTPDown() end
	end)
	rowInput("Speed", "TP Down Height", nil, autoTPDownHeight, function(v)
		autoTPDownHeight = math.clamp(v, 0, 500)
	end)
end

makeSecHeader("Speed", "MOVEMENT")
do
	local sv
	sv, _ = rowToggleKB("Speed", "Auto Bat V1", "Modo predictivo", KB.AutoBat, false,
	function(on)
		State.autoBatToggled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatV2Enabled then
				State.autoBatV2Enabled = false
				if autoBatV2SetVisual then autoBatV2SetVisual(false) end
				if mobileBatV2SetActive then mobileBatV2SetActive(false) end
				stopBatAimbotV2()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			startBatAimbot()
		else
			stopBatAimbot()
		end
		if mobileBatV1SetActive then mobileBatV1SetActive(on) end
	end,
	function(k) KB.AutoBat.kb = k end)
	autoBatSetVisual = sv
	setAutoBat = sv
end

do
	local sv
	sv, _ = rowToggleKB("Speed", "bat v2", "Versión avanzada ", KB.AutoBatV2, false,
	function(on)
		State.autoBatV2Enabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			if startBatAimbotV2 then startBatAimbotV2() end
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if mobileBatV2SetActive then mobileBatV2SetActive(on) end
	end,
	function() end)
	autoBatV2SetVisual = sv
	setAutoBatV2 = sv
end

State._setTPBatEnabled = function(on)
	on = on == true

	if on then
		if State.autoLeftEnabled then
			State.autoLeftEnabled = false
			stopAutoLeft()
			if autoLeftSetVisual then autoLeftSetVisual(false) end
		end
		if State.autoRightEnabled then
			State.autoRightEnabled = false
			stopAutoRight()
			if autoRightSetVisual then autoRightSetVisual(false) end
		end
		if State.autoBatToggled then
			State.autoBatToggled = false
			if autoBatSetVisual then autoBatSetVisual(false) end
			stopBatAimbot()
		end
		if State.autoBatV2Enabled then
			State.autoBatV2Enabled = false
			if autoBatV2SetVisual then autoBatV2SetVisual(false) end
			if mobileBatV2SetActive then mobileBatV2SetActive(false) end
			stopBatAimbotV2()
		end
	else
	end

	State.tpBatEnabled = on
	if State._tpBatSetter then State._tpBatSetter(on) end
	if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
end

State._tpBatConfigSetVisual = rowToggleKB("Speed", "TP BAT", "Teleport y golpe automático", KB.TPBat, false,
function(on)
	State._setTPBatEnabled(on)
end,
function() end)

makeSecHeader("Visuals", "Game Mechanics")

if not KB.InstaReset then KB.InstaReset = {kb=nil, gp=nil} end


setInfJump       = rowToggle("Visuals", "Infinite Jump",  nil, false, function(on) State.infJumpEnabled = on end)
setSuperJump     = rowToggle("Visuals", "Infinite Jump Hold",     nil, false, function(on) State.superJumpEnabled = on end)
setLinieVisual   = rowToggle("Visuals", "Player ESP", nil, false, function(on) toggleESP(on) end)

setAntiRag       = rowToggle("Visuals", "Anti Ragdoll",   nil, false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setUnwalkToggle  = rowToggle("Visuals", "Unwalk",         nil, false, function(on) State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end)
setMedusaCounter = rowToggle("Visuals", "Medusa Counter", nil, false, function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end)
setBatCounter = rowToggle("Visuals", "Bat Counter",    nil, false, function(on) State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end end)

RunService.Heartbeat:Connect(function()
    if not State.superJumpEnabled then return end
    local c = LP.Character
    if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)

    if isJumpHeld and root.Velocity.Y < 35 then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end

    if root.Velocity.Y < -120 then
        root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
    end
end)

makeSecHeader("Visuals", "Optimization & Visuals")

-- ============================================================
--  ELIMINADO EL TOGGLE DE HITBOX FOLLOWER
-- ============================================================

do
	local _Lighting = game:GetService("Lighting")
	local _antiLagConn = nil

	local function applyAntiLag(instance)
		if instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		elseif instance:IsA("Decal") then
			instance.Transparency = 1
		elseif instance:IsA("BasePart") then
			instance.Material = Enum.Material.Plastic
			instance.Reflectance = 0
			instance.CastShadow = false
		end
	end

	local function optimizeLighting()
		_Lighting.GlobalShadows = false
		_Lighting.FogEnd = 9e9
		_Lighting.Brightness = 1
		_Lighting.EnvironmentDiffuseScale = 0
		_Lighting.EnvironmentSpecularScale = 0
		for _, child in pairs(_Lighting:GetChildren()) do
			if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then
				child.Enabled = false
			end
		end
	end

	local function enableAntiLag()
		optimizeLighting()
		for _, desc in pairs(workspace:GetDescendants()) do
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end
		if _antiLagConn then _antiLagConn:Disconnect() end
		_antiLagConn = workspace.DescendantAdded:Connect(function(desc)
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end)
	end

	local function disableAntiLag()
		if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
	end

	setAntiLag = function(on)
		State.antiLagEnabled = on
		if on then enableAntiLag() else disableAntiLag() end
	end
	local setAntiLagVisual = rowToggle("Visuals", "Anti Lag", nil, false, function(on) setAntiLag(on) end)
	local rawSetAntiLag = setAntiLag
	setAntiLag = function(on) setAntiLagVisual(on); rawSetAntiLag(on) end
end

do
	local connection = nil
	local function rawSet(on)
		State.stretchRezEnabled = on
		if on then
			workspace.CurrentCamera.FieldOfView = 120
			if connection then connection:Disconnect() end
			connection = RunService.RenderStepped:Connect(function()
				if not State.stretchRezEnabled then
					if connection then connection:Disconnect(); connection = nil end
					return
				end
				workspace.CurrentCamera.FieldOfView = 120
			end)
		else
			if connection then connection:Disconnect(); connection = nil end
			workspace.CurrentCamera.FieldOfView = 70
		end
	end
	local visual = rowToggle("Visuals", "Stretch Rez", nil, false, function(on) rawSet(on) end)
	setStretchRez = function(on) visual(on); rawSet(on) end
end

do
	local connection = nil
	local function removeFromCharacter(character)
		if not character then return end
		for _, obj in ipairs(character:GetDescendants()) do
			if obj:IsA("Accessory") or obj:IsA("Hat") then
				pcall(function() obj:Destroy() end)
			end
		end
	end
	local function rawSet(on)
		State.removeAccessoriesEnabled = on
		if on then
			for _, player in pairs(Players:GetPlayers()) do
				removeFromCharacter(player.Character)
			end
			if not connection then
				connection = Players.PlayerAdded:Connect(function(player)
					player.CharacterAdded:Connect(function(character)
						task.wait(0.5)
						if State.removeAccessoriesEnabled then removeFromCharacter(character) end
					end)
				end)
			end
		else
			if connection then connection:Disconnect(); connection = nil end
		end
	end
	local visual = rowToggle("Visuals", "Remove Accessories", nil, false, function(on) rawSet(on) end)
	setRemoveAccessories = function(on) visual(on); rawSet(on) end
end

do
	local Lighting = game:GetService("Lighting")
	local defaults = {
		Brightness = Lighting.Brightness,
		ClockTime = Lighting.ClockTime,
		ExposureCompensation = Lighting.ExposureCompensation,
		OutdoorAmbient = Lighting.OutdoorAmbient,
		Ambient = Lighting.Ambient,
		FogColor = Lighting.FogColor,
		FogStart = Lighting.FogStart,
		FogEnd = Lighting.FogEnd,
		ColorShift_Top = Lighting.ColorShift_Top,
		ColorShift_Bottom = Lighting.ColorShift_Bottom,
		GlobalShadows = Lighting.GlobalShadows,
	}
	local SKY_TAG = "ShynxSkyTheme"

	local CANDY_SKY_PRESETS = {
    ["Off"] = { kind = "off" },
    ["Night"] = { clock = 22, brightness = 2, ambient = {110,100,130}, outAmb = {120,110,140}, sky = {stars = 4000, moon = 18, sun = 0, moonTex = true}, atm = {dens = 0.45, color = {120,60,180}, decay = {60,20,100}, glare = 0.5, haze = 1.2} },
    ["Aurora"] = { clock = 14, brightness = 3, ambient = {150,120,150}, outAmb = {160,130,150}, atm = {dens = 0.55, color = {255,80,200}, decay = {255,20,150}, glare = 2.5, haze = 3}, clouds = {cover = 0.7, dens = 0.7, color = {255,240,250}} },
    ["Sunset"] = { clock = 17.2, brightness = 2.5, ambient = {170,120,100}, outAmb = {180,130,110}, sky = {stars = 0, sun = 25, moon = 0}, atm = {dens = 0.5, color = {255,130,60}, decay = {255,80,30}, glare = 2, haze = 2.5}, clouds = {cover = 0.55, dens = 0.55, color = {255,200,140}} },
    ["Galaxy"] = { clock = 0, brightness = 1.5, ambient = {70,60,100}, outAmb = {80,70,110}, sky = {stars = 10000, moon = 30, sun = 0}, atm = {dens = 0.15, color = {40,20,80}, decay = {20,10,50}, glare = 0.3, haze = 0.5} },
    ["Cyber"] = { clock = 21, brightness = 2.2, ambient = {90,130,170}, outAmb = {100,140,180}, sky = {stars = 2000, moon = 12}, atm = {dens = 0.4, color = {0,200,255}, decay = {150,0,255}, glare = 2, haze = 2}, clouds = {cover = 0.4, dens = 0.6, color = {100,200,255}} },
    ["Sakura"] = { clock = 11, brightness = 3.5, ambient = {170,150,160}, outAmb = {180,160,170}, sky = {sun = 8}, atm = {dens = 0.3, color = {255,200,220}, decay = {255,170,200}, glare = 1, haze = 1.5}, clouds = {cover = 0.6, dens = 0.4, color = {255,250,252}} },
    ["Pink Night"] = { clock = 23, brightness = 2.2, ambient = {120,60,110}, outAmb = {140,70,120}, sky = {stars = 5000, moon = 22, sun = 0, moonTex = true}, atm = {dens = 0.5, color = {255,80,180}, decay = {140,30,100}, glare = 0.7, haze = 1.4}, clouds = {cover = 0.3, dens = 0.5, color = {180,90,150}} },
    ["Blood Moon"] = { clock = 22.5, brightness = 1.6, ambient = {130,40,40}, outAmb = {150,50,50}, sky = {stars = 1500, moon = 28, sun = 0, moonTex = true}, atm = {dens = 0.6, color = {220,30,30}, decay = {120,10,10}, glare = 1.4, haze = 2}, clouds = {cover = 0.5, dens = 0.7, color = {120,30,30}} },
    ["Emerald Dawn"] = { clock = 6.5, brightness = 2.8, ambient = {130,170,140}, outAmb = {140,180,150}, sky = {sun = 18, moon = 0, stars = 0}, atm = {dens = 0.4, color = {80,200,140}, decay = {40,150,90}, glare = 1.8, haze = 2.2}, clouds = {cover = 0.5, dens = 0.5, color = {200,255,220}} },
    ["Volcanic"] = { clock = 19, brightness = 2, ambient = {180,80,40}, outAmb = {200,90,50}, sky = {stars = 200, sun = 12, moon = 0}, atm = {dens = 0.75, color = {255,60,0}, decay = {180,20,0}, glare = 3, haze = 3.5}, clouds = {cover = 0.8, dens = 0.9, color = {120,40,20}} },
    ["Arctic"] = { clock = 9, brightness = 3.2, ambient = {200,220,235}, outAmb = {210,230,245}, sky = {sun = 10, stars = 0, moon = 0}, atm = {dens = 0.3, color = {180,220,255}, decay = {140,200,240}, glare = 1.5, haze = 1.8}, clouds = {cover = 0.7, dens = 0.6, color = {250,253,255}} },
    ["Midnight Ocean"] = { clock = 1.5, brightness = 1.7, ambient = {60,90,130}, outAmb = {70,100,140}, sky = {stars = 6000, moon = 24, sun = 0, moonTex = true}, atm = {dens = 0.5, color = {20,60,140}, decay = {10,30,90}, glare = 0.6, haze = 1.5} },
    ["Vaporwave"] = { clock = 19.5, brightness = 2.4, ambient = {180,120,200}, outAmb = {190,130,210}, sky = {stars = 1000, moon = 14}, atm = {dens = 0.45, color = {255,100,220}, decay = {120,60,255}, glare = 2.2, haze = 2.4}, clouds = {cover = 0.5, dens = 0.55, color = {200,150,255}} },
    ["Toxic"] = { clock = 13, brightness = 2.5, ambient = {140,180,80}, outAmb = {150,190,90}, atm = {dens = 0.55, color = {100,220,40}, decay = {60,150,20}, glare = 1.8, haze = 2.6}, clouds = {cover = 0.65, dens = 0.7, color = {180,255,120}} },
    ["Solar Eclipse"] = { clock = 12, brightness = 0.9, ambient = {50,40,60}, outAmb = {60,50,70}, sky = {stars = 3500, sun = 22, moon = 0}, atm = {dens = 0.5, color = {255,140,40}, decay = {30,20,40}, glare = 2.8, haze = 1.8} },
    ["Hellscape"] = { clock = 18, brightness = 1.8, ambient = {200,60,30}, outAmb = {220,70,40}, sky = {stars = 100, sun = 30, moon = 0}, atm = {dens = 0.85, color = {255,30,0}, decay = {120,0,0}, glare = 3.5, haze = 4}, clouds = {cover = 0.95, dens = 0.95, color = {80,20,10}} },
    ["Heaven"] = { clock = 12, brightness = 4, ambient = {240,235,210}, outAmb = {250,245,220}, sky = {sun = 16, moon = 0, stars = 0}, atm = {dens = 0.25, color = {255,250,220}, decay = {255,240,200}, glare = 3, haze = 1.5}, clouds = {cover = 0.85, dens = 0.5, color = {255,255,255}} },
    ["Storm"] = { clock = 15, brightness = 1.4, ambient = {90,90,110}, outAmb = {100,100,120}, sky = {stars = 0, sun = 6, moon = 0}, atm = {dens = 0.65, color = {80,90,120}, decay = {40,50,80}, glare = 0.5, haze = 3}, clouds = {cover = 0.95, dens = 0.95, color = {60,65,80}} },
    ["Sunrise"] = { clock = 6.2, brightness = 2.8, ambient = {220,180,130}, outAmb = {230,190,140}, sky = {sun = 22, stars = 0, moon = 0}, atm = {dens = 0.45, color = {255,180,100}, decay = {255,140,80}, glare = 2.4, haze = 2.2}, clouds = {cover = 0.4, dens = 0.4, color = {255,220,180}} },
    ["Deep Space"] = { clock = 0, brightness = 1, ambient = {30,25,50}, outAmb = {40,35,60}, sky = {stars = 15000, moon = 0, sun = 0}, atm = {dens = 0.08, color = {15,5,40}, decay = {5,0,20}, glare = 0.2, haze = 0.3} },
    ["Lavender Dream"] = { clock = 18.5, brightness = 2.6, ambient = {180,160,220}, outAmb = {190,170,230}, sky = {stars = 800, moon = 16, sun = 0}, atm = {dens = 0.4, color = {200,160,255}, decay = {160,120,220}, glare = 1.4, haze = 1.8}, clouds = {cover = 0.55, dens = 0.5, color = {220,200,255}} },
    ["Inferno"] = { clock = 17.5, brightness = 2.2, ambient = {220,100,40}, outAmb = {235,110,50}, sky = {sun = 26, moon = 0, stars = 0}, atm = {dens = 0.6, color = {255,90,20}, decay = {200,40,0}, glare = 3, haze = 3.2}, clouds = {cover = 0.7, dens = 0.7, color = {200,80,40}} },
    ["Mint Sky"] = { clock = 10, brightness = 3.2, ambient = {180,230,210}, outAmb = {190,240,220}, sky = {sun = 10}, atm = {dens = 0.32, color = {150,255,210}, decay = {100,220,180}, glare = 1.6, haze = 1.6}, clouds = {cover = 0.55, dens = 0.45, color = {240,255,250}} },
}

local CANDY_SKY_ORDER = {
    {"Off","Off"}, {"Night","Night"}, {"Aurora","Aurora"}, {"Sunset","Sunset"},
    {"Galaxy","Galaxy"}, {"Cyber","Cyber"}, {"Sakura","Sakura"},
    {"Pink Night","Pink Night"}, {"Blood Moon","Blood Moon"},
    {"Emerald Dawn","Emerald Dawn"}, {"Volcanic","Volcanic"},
    {"Arctic","Arctic"}, {"Midnight Ocean","Midnight Ocean"},
    {"Vaporwave","Vaporwave"}, {"Toxic","Toxic"},
    {"Solar Eclipse","Solar Eclipse"}, {"Hellscape","Hellscape"},
    {"Heaven","Heaven"}, {"Storm","Storm"}, {"Sunrise","Sunrise"},
    {"Deep Space","Deep Space"}, {"Lavender Dream","Lavender Dream"},
    {"Inferno","Inferno"}, {"Mint Sky","Mint Sky"}
}

	local function clearSky()
		for _, child in ipairs(Lighting:GetChildren()) do
			if child:GetAttribute(SKY_TAG) then
				pcall(function() child:Destroy() end)
			end
		end
		local terrain = workspace:FindFirstChildOfClass("Terrain")
		if terrain then
			for _, child in ipairs(terrain:GetChildren()) do
				if child:GetAttribute(SKY_TAG) then
					pcall(function() child:Destroy() end)
				end
			end
		end
	end

	local function candyInstance(className, parent, props)
		local inst = Instance.new(className)
		inst:SetAttribute(SKY_TAG, true)
		for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
		inst.Parent = parent
		return inst
	end

	local function candyColor(rgb)
		return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
	end

	local function findPreset(name)
		return CANDY_SKY_PRESETS[name] or CANDY_SKY_PRESETS["Off"]
	end

	local function apply(styleName)
		local preset = findPreset(styleName)
		clearSky()
		if styleName == "Off" or preset.kind == "off" then
			for key, value in pairs(defaults) do
				pcall(function() Lighting[key] = value end)
			end
			State.skyStyle = "Off"
			State.darkModeEnabled = false
			return "Off"
		end

		Lighting.FogStart = 0
		Lighting.FogEnd = 100000
		Lighting.FogColor = Color3.fromRGB(200, 200, 200)
		Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
		Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		Lighting.GlobalShadows = true
		Lighting.ClockTime = preset.clock or 14
		Lighting.Brightness = preset.brightness or 2
		if preset.outAmb then Lighting.OutdoorAmbient = candyColor(preset.outAmb) end
		if preset.ambient then Lighting.Ambient = candyColor(preset.ambient) end

		if preset.sky then
			local skyProps = {}
			if preset.sky.stars then skyProps.StarCount = preset.sky.stars end
			if preset.sky.moon then skyProps.MoonAngularSize = preset.sky.moon end
			if preset.sky.sun then skyProps.SunAngularSize = preset.sky.sun end
			if preset.sky.moonTex then skyProps.MoonTextureId = "rbxasset://sky/moon.jpg" end
			candyInstance("Sky", Lighting, skyProps)
		end

		if preset.atm then
			candyInstance("Atmosphere", Lighting, {
				Density = preset.atm.dens or 0.3,
				Color = candyColor(preset.atm.color),
				Decay = candyColor(preset.atm.decay),
				Glare = preset.atm.glare or 1,
				Haze = preset.atm.haze or 1,
			})
		end

		local terrain = workspace:FindFirstChildOfClass("Terrain")
		if preset.clouds and terrain then
			candyInstance("Clouds", terrain, {
				Cover = preset.clouds.cover or 0.5,
				Density = preset.clouds.dens or 0.5,
				Color = candyColor(preset.clouds.color),
			})
		end

		State.skyStyle = styleName
		State.darkModeEnabled = true
		return styleName
	end

	local names = {}
	for _, entry in ipairs(CANDY_SKY_ORDER) do table.insert(names, entry[2]) end
	setSkySelectorVisual = rowCycleSelector("Visuals", "Sky Color", names, State.skyStyle or "Off", function(styleName)
		apply(styleName)
	end)

	-- Selector de animaciones Lust PH restaurado debajo de Sky Theme.
	setAnimationPackVisual = rowCycleSelector("Visuals", "Animation Style", {"Off", "Tryhard", "Crazy", "zombie", "Mage", "Adidas", "Solar"}, animationPackName or "Tryhard", function(packName)
		-- Unwalk elimina Animate; se desactiva antes de aplicar otro paquete.
		if State.unwalkEnabled then
			State.unwalkEnabled = false
			stopUnwalk()
			if setUnwalkToggle then setUnwalkToggle(false) end
		end
		if packName == "Off" then
			State.nuevaAnimacionEnabled = false
			stopNuevaAnimacion()
		else
			State.nuevaAnimacionEnabled = true
			animationPackName = packName
			startNuevaAnimacion()
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	setSkyStyle = function(styleName)
		local applied = apply(styleName)
		if setSkySelectorVisual then setSkySelectorVisual(applied, false) end
		return applied
	end

	setDarkMode = function(on)
		return setSkyStyle(on and ((State.skyStyle and State.skyStyle ~= "Off") and State.skyStyle or "Galaxy") or "Off")
	end
end


	bodyLockSetVisual = rowToggle("Visuals", "Body Lock", nil, false, function(on)
		bodyLockEnabled = on
		if on then startBodyLock() else stopBodyLock() end
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	bodyLockRangeBox = rowInput("Visuals", "Body Lock Range", nil, bodyLockRange, function(value)
		local n = tonumber(value)
		if n then
			bodyLockRange = math.clamp(math.floor(n + 0.5), 5, 200)
			if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)


	setNeonWeatherVisual = rowToggle("Visuals", "Clima Neon", nil, false, function(on)
		toggleNeonWeather(on)
		if State.requestConfigSave then State.requestConfigSave() end
	end)
	if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end

do
	local Lighting = game:GetService("Lighting")

local function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        Ambient = Lighting.Ambient,
        ColorCorrection = nil,
        Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = {
                Enabled = e.Enabled,
                Brightness = e.Brightness,
                Contrast = e.Contrast,
                Saturation = e.Saturation,
                TintColor = e.TintColor,
            }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = {
                Enabled = e.Enabled,
                Intensity = e.Intensity,
                Size = e.Size,
                Threshold = e.Threshold,
            }
        end
    end
end

local function restoreLightingState()
    if not _originalLighting then return end
    local old = _originalLighting
    Lighting.Brightness = old.Brightness
    Lighting.ClockTime = old.ClockTime
    Lighting.OutdoorAmbient = old.OutdoorAmbient
    Lighting.GlobalShadows = old.GlobalShadows
    Lighting.FogEnd = old.FogEnd
    Lighting.FogStart = old.FogStart
    Lighting.FogColor = old.FogColor
    Lighting.Ambient = old.Ambient
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled
            cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast
            cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled
            bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size
            bloom.Threshold = old.Bloom.Threshold
        end
    end
    _originalLighting = nil
end

local function applyNeonWeather()
    if not neonWeatherEnabled then restoreLightingState() return end
    if not _originalLighting then saveLightingState() end
    Lighting.Brightness = 3.5
    Lighting.ClockTime = 20
    Lighting.OutdoorAmbient = Color3.fromRGB(20, 40, 80)
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 300
    Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(0, 80, 200)
    Lighting.Ambient = Color3.fromRGB(30, 60, 120)
    local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then
        cc = Instance.new("ColorCorrectionEffect")
        cc.Parent = Lighting
    end
    cc.Enabled = true
    cc.Brightness = 0.2
    cc.Contrast = 0.15
    cc.Saturation = 0.15
    cc.TintColor = Color3.fromRGB(180, 180, 190)
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    if not bloom then
        bloom = Instance.new("BloomEffect")
        bloom.Parent = Lighting
    end
    bloom.Enabled = true
    bloom.Intensity = 0.6
    bloom.Size = 25
    bloom.Threshold = 0.8
end

function toggleNeonWeather(state)
    if state == nil then neonWeatherEnabled = not neonWeatherEnabled else neonWeatherEnabled = state end
    applyNeonWeather()
    if setNeonWeatherVisual then setNeonWeatherVisual(neonWeatherEnabled) end
end
end


makeSecHeader("Utility", "Interface & Binds")

uiScaleBox = rowInput("Utility", "UI Scale", nil, uiScaleValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 50, 150)
	uiScaleValue = n
	if mainUIScale then mainUIScale.Scale = n / 100 end
	if uiScaleBox then uiScaleBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

buttonsSizeBox = rowInput("Utility", "Buttons Size", "0 = mínimo • 100 = máximo", State.buttonsSizeValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 0, 100)
	applyMobileButtonsSize(n)
	if buttonsSizeBox then buttonsSizeBox.Text = tostring(n) end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

setHideButtonsVisual = rowToggle("Utility", "Hide Buttons", "Oculta todos los botones flotantes", false, function(on)
	State.hideButtonsEnabled = on
	local visible = not on

	if MobilePanel then MobilePanel.Visible = visible end
	for _, mobileBtn in pairs(mobileButtonsByName) do
		if mobileBtn and mobileBtn.Parent then
			mobileBtn.Visible = visible
		end
	end

	if btnBatV2 then btnBatV2.Visible = visible end
	if btnInstaReset then btnInstaReset.Visible = visible end
	if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

setLockUIVisual = rowToggle("Utility", "Lock UI", nil, false, function(on)
  uiLocked = on
  if uiLocked and cancelStealBarDrag then
      cancelStealBarDrag()
  end
  if State.requestConfigSave then State.requestConfigSave() else pcall(saveConfig) end
end)

-- Edit controla si los botones flotantes pueden moverse individualmente.
setEditModeVisual = rowToggle("Utility", "Edit buttons", nil, false, function(on)
	editModeEnabled = on
	if State.requestConfigSave then State.requestConfigSave() end
end)

-- Accessory Pack de Lust Hub, colocado junto a Lock UI.
do
	local options = {"Off", "Korblox", "Headless", "Both"}
	local current = 1
	for i, name in ipairs(options) do
		if name == currentAccessoryPack then current = i break end
	end
	local setAccessoryVisual
	setAccessoryVisual = rowCycleSelector("Utility", "Accessory Pack", options, options[current], function(packName)
		currentAccessoryPack = packName
		applyAccessoryPack(packName)
		if State.requestConfigSave then State.requestConfigSave() end
	end)
end

-- Background fijo: sin selector ni toggle.

makeSecHeader("Music", "Music")

do
	local songParent = game:GetService("CoreGui")
	local starterGui = game:GetService("StarterGui")
	local assetFunction = getcustomasset or getsynasset

	local function notifySong(title, message)
		warn("[CT Duels " .. string.upper(title) .. "] " .. tostring(message))
		pcall(function()
			starterGui:SetCore("SendNotification", {
				Title = title,
				Text = tostring(message),
				Duration = 6
			})
		end)
	end

	local function fileExists(path)
		if type(isfile) ~= "function" then
			return false
		end
		local ok, exists = pcall(isfile, path)
		return ok and exists == true
	end

	local function validAudio(data)
		if type(data) ~= "string" or #data < 2048 then
			return false
		end
		local header = data:sub(1, 256):lower()
		return not (
			header:find("<html", 1, true)
			or header:find("<!doctype", 1, true)
			or header:find("access denied", 1, true)
			or header:find("not found", 1, true)
			or header:find("error", 1, true)
		)
	end

	local function downloadAudio(url, path)
		if type(writefile) ~= "function" then
			return false, "writefile no está disponible"
		end

		local data, lastError
		local requestFunction = request
			or http_request
			or (syn and syn.request)
			or (fluxus and fluxus.request)

		if type(requestFunction) == "function" then
			local ok, response = pcall(requestFunction, {
				Url = url,
				Method = "GET",
				Headers = {
					["User-Agent"] = "Mozilla/5.0",
					["Accept"] = "audio/mpeg,audio/*;q=0.9,*/*;q=0.8"
				}
			})
			if ok and type(response) == "table" then
				local code = tonumber(response.StatusCode or response.Status or response.status_code) or 0
				local body = response.Body or response.body
				if (code == 0 or (code >= 200 and code < 300)) and validAudio(body) then
					data = body
				else
					lastError = "respuesta HTTP inválida (" .. tostring(code) .. ")"
				end
			elseif not ok then
				lastError = tostring(response)
			end
		end

		if not data then
			local ok, result = pcall(function()
				return game:HttpGet(url, true)
			end)
			if ok and validAudio(result) then
				data = result
			elseif not ok then
				lastError = tostring(result)
			elseif not lastError then
				lastError = "el enlace no devolvió un MP3 válido"
			end
		end

		if not data then
			return false, lastError or "no se pudo descargar el audio"
		end

		local ok, err = pcall(writefile, path, data)
		if not ok then
			return false, tostring(err)
		end
		return true
	end

	local function addSong(config)
		local sound
		local wantedOn = false
		local preparing = false
		local started = false
		local loadedConnection

		local function destroySound()
			if loadedConnection then
				loadedConnection:Disconnect()
				loadedConnection = nil
			end
			if sound then
				pcall(function() sound:Destroy() end)
				sound = nil
			end
			started = false
		end

		local function createSound()
			if type(assetFunction) ~= "function" then
				return false, "getcustomasset/getsynasset no está disponible"
			end

			local ok, assetId = pcall(assetFunction, config.file)
			if not ok or type(assetId) ~= "string" or assetId == "" then
				return false, "el archivo local todavía no está disponible"
			end

			destroySound()
			sound = Instance.new("Sound")
			sound.Name = config.soundName
			sound.SoundId = assetId
			sound.Volume = config.volume
			sound.Looped = true
			sound.Parent = songParent

			if config.startAt and config.startAt > 0 then
				pcall(function() sound.TimePosition = config.startAt end)
				loadedConnection = sound.Loaded:Connect(function()
					if loadedConnection then
						loadedConnection:Disconnect()
						loadedConnection = nil
					end
					if sound and sound.Parent then
						pcall(function() sound.TimePosition = config.startAt end)
					end
				end)
			end
			return true
		end

		local function playNow()
			if not sound or not sound.Parent then
				return
			end
			if started then
				local ok = pcall(function() sound:Resume() end)
				if not ok then
					pcall(function() sound:Play() end)
				end
			else
				if config.startAt and config.startAt > 0 then
					pcall(function() sound.TimePosition = config.startAt end)
				end
				pcall(function() sound:Play() end)
				started = true
			end
		end

		local function prepare()
			if sound and sound.Parent then
				if wantedOn then playNow() end
				return
			end
			if preparing then return end
			preparing = true

			local alreadyDownloaded = fileExists(config.file)
			local created = select(1, createSound())

			if not created then
				if not alreadyDownloaded then
					notifySong(config.title, "Descargando " .. config.title .. " por primera vez...")
				end
				local downloaded, downloadError = downloadAudio(config.url, config.file)
				if not downloaded then
					preparing = false
					if config.notifications then
						notifySong(config.title, "No se pudo descargar: " .. tostring(downloadError))
					else
						warn("[CT Duels SONGS] " .. config.title .. ": " .. tostring(downloadError))
					end
					return
				end
				local okCreate, createError = createSound()
				if not okCreate then
					preparing = false
					if config.notifications then
						notifySong(config.title, tostring(createError))
					else
						warn("[CT Duels SONGS] " .. config.title .. ": " .. tostring(createError))
					end
					return
				end
			end

			preparing = false
			if wantedOn then playNow() end
		end

		if fileExists(config.file) then
			task.defer(function()
				if not sound then
					createSound()
				end
			end)
		end

		local musicKey = config.soundName or config.title
		 wantedOn = musicEnabled[musicKey] == true
		rowToggle("Music", config.title, nil, wantedOn, function(on)
			wantedOn = on
			musicEnabled[musicKey] = on
			if on then
				if sound and sound.Parent then
					playNow()
				else
					task.spawn(prepare)
				end
			elseif sound then
				pcall(function() sound:Pause() end)
			end
		end)
		if wantedOn then
			task.defer(prepare)
		end
	end

	local songs = {
	{
		title = "TUFF SONG",
		url = "https://files.catbox.moe/rvf2vy.mp3",
		file = "tuffsong.mp3",
		soundName = "CTDuels_TuffSong",
		volume = 0.85
	},
	{
		title = "WARE",
		url = "https://files.catbox.moe/p2pp91.mp3",
		file = "Ware.mp3",
		soundName = "Shynx.vs_Ware",
		volume = 0.85
	},
	{
		title = "WOW",
		url = "https://files.catbox.moe/14rdtj.mp3",
		file = "WOW.mp3",
		soundName = "shynx.vs_WOW",
		volume = 0.85
	},
	{
		title = "EL DE LA R",
		url = "https://files.catbox.moe/u67vx5.mp3",
		file = "eldelaR.mp3",
		soundName = "shynx.vs_el de la r",
		volume = 0.85,
		startAt = 10,
		notifications = true
	},
	{
		title = "CHIRICUAZO V2",
		url = "https://files.catbox.moe/va3lhi.mp3",
		file = "chiricuazo_v2.mp3",
		soundName = "shynx.vs_chiricuazo v2",
		volume = 0.85,
		notifications = true
	},
	{
		title = "LAJA",
		url = "https://file.garden/algLafWA1jk8WMfK/LAJA%20-%20NADIE%20TA%20FRIO%20(Letra)(MP3_160K).mp3",
		file = "overseer_laja_nadie_ta_frio_filegarden.mp3",
		soundName = "CTDuels_LAJA",
		volume = 0.75,
		notifications = true
	},
	{
		title = "HORA 0",
		url = "https://file.garden/algLafWA1jk8WMfK/Myke%20Towers%20-%20HORA%20CERO%20(Lyrics)(MP3_160K).mp3",
		file = "overseer_hora_0_filegarden.mp3",
		soundName = "CTDuels_HORA_0",
		volume = 0.75,
		notifications = true
	},
	{
		title = "ONDEADO V2",
		url = "https://files.catbox.moe/4lqp91.mp3",
		file = "el_ondeado_v2.mp3",
		soundName = "shynx.vs_ondeado v2",
		volume = 0.85,
		notifications = true
	},
	{
		title = "BLAME ON ME",
		url = "https://files.catbox.moe/ugvknv.mp3", 
		file = "blame_on_me.mp3",
		soundName = "CTDuels_BlameOnMe",
		volume = 0.85,
		notifications = true
	},
	{
		title = "SE VA CONMIGO",
		url = "https://files.catbox.moe/s2bqqk.mp3", 
		file = "se_va_conmigo.mp3",
		soundName = "CTDuels_SeVaConmigo",
		volume = 0.85,
		notifications = true
	}
}
	


	for _, config in ipairs(songs) do
		addSong(config)
	end
end

local saveBtn; saveBtn = rowActionBtn("Utility", "Save Config", function()
	if saveConfig then
		local ok, saved = pcall(saveConfig, saveBtn)
		if (not ok or saved ~= true) and State._lastSaveError then
			warn("[CT Duels AUTO SAVE] " .. tostring(State._lastSaveError))
		end
	elseif State.savePositionBackup then
		local saved = State.savePositionBackup()
		if saveBtn and saveBtn.Parent then
			local previous = saveBtn.Text
			saveBtn.Text = saved and "Positions Saved!" or "Save Failed!"
			task.delay(1.5, function()
				if saveBtn and saveBtn.Parent then saveBtn.Text = previous end
			end)
		end
	end
end)
rowActionBtn("Utility", "Reset Mobile Buttons", function()
    if resetMobileButtons then
        resetMobileButtons()
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5,-190,1,-58)
    end
    if setAutoGrab then
        setAutoGrab(false)
    end
end)

end


-- SECCIÓN 8: BOTONES MÓVILES
do
local BTN_SIZE = 58
		local BTN_GAP = 10
		local PADDING = 0
		local mobileViewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
		local mobileStartX = mobileViewport.X - (2 * BTN_SIZE + BTN_GAP) - 20
		local mobileStartY = math.floor(mobileViewport.Y * 0.12)
	MobilePanel = Instance.new("Frame")
	MobilePanel.Name = "MobileButtonsPanel"
	MobilePanel.Size = UDim2.new(0, PADDING * 2 + 2 * BTN_SIZE + BTN_GAP, 0, PADDING * 2 + 6 * BTN_SIZE + 5 * BTN_GAP)
	MobilePanel.Position = UDim2.new(1, -140, 0, 10)
	MobilePanel.BackgroundColor3 = Color3.fromRGB(18, 8, 12)
	MobilePanel.BackgroundTransparency = 1
	MobilePanel.BorderSizePixel = 0
	MobilePanel.ZIndex = 1
	MobilePanel.Parent = gui

	local Q_OFF      = Color3.fromRGB(18, 4, 8)
	local Q_ON       = Color3.fromRGB(220, 50, 80)
	local Q_TEXT_OFF = Color3.fromRGB(255, 220, 220)

	State._purpleAnimatedButtons = State._purpleAnimatedButtons or {}
	State._purpleAnimationPeriod = 5.5

	local purpleTextPalette = {
		Color3.fromRGB(160, 30, 50),
		Color3.fromRGB(220, 50, 80),
		Color3.fromRGB(120, 15, 30),
		Color3.fromRGB(255,150,150),
		Color3.fromRGB(255,100,60),
		Color3.fromRGB(120,15,30),
	}

	local function checkSpeedAndDropBeforeAction(stateCheckName, actionCallback)
		task.spawn(function()
			local char = LP.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			
			if hum then
				if hum.WalkSpeed < 20 then
					if State[stateCheckName] and actionCallback then
						actionCallback()
					end
					return
				end
				
				while hum and hum.WalkSpeed >= 20 and hum.WalkSpeed <= 24 and State[stateCheckName] do
					if runDrop then
						task.spawn(runDrop)
					end
					task.wait(0.5) 
					
					char = LP.Character
					hum = char and char:FindFirstChildOfClass("Humanoid")
				end
				
				if hum and hum.WalkSpeed >= 30 and State[stateCheckName] and actionCallback then
					actionCallback()
				end
			end
		end)
	end

	local function paletteColor(palette, progress)
		local count = #palette
		if count == 0 then return Color3.fromRGB(255, 220, 220) end
		if count == 1 then return palette[1] end
		progress = progress % 1
		local scaled = progress * count
		local index = math.floor(scaled) + 1
		local nextIndex = (index % count) + 1
		local alpha = scaled - math.floor(scaled)
		alpha = alpha * alpha * (3 - 2 * alpha)
		return palette[index]:Lerp(palette[nextIndex], alpha)
	end

	State._registerPurpleAnimatedButton = function(button)
		if not button then return end
		button:SetAttribute("PurpleActive", false)
		button:SetAttribute("PurpleFlash", false)
		button.BackgroundColor3 = Q_OFF
		button.TextColor3 = Color3.fromRGB(255, 220, 220)
		State._purpleAnimatedButtons[button] = {
			background = button.BackgroundColor3,
			text = Color3.fromRGB(255, 220, 220),
		}
	end

	if not State._purpleAnimationStarted then
		State._purpleAnimationStarted = true
		task.spawn(function()
			local lastClock = os.clock()
			while gui and gui.Parent do
				local now = os.clock()
				local dt = math.min(now - lastClock, 0.1)
				lastClock = now
				local progress = (now / State._purpleAnimationPeriod) % 1
				local animatedRed = paletteColor(purpleTextPalette, progress)
				local blend = 1 - math.exp(-dt * 8)

				for button, visual in pairs(State._purpleAnimatedButtons) do
					if button and button.Parent then
						local active = button:GetAttribute("PurpleActive") == true
						local flash = button:GetAttribute("PurpleFlash") == true
						local targetBackground
						local targetText

						if active or flash then
							targetBackground = Q_ON
							targetText = Color3.fromRGB(255, 220, 220)
						else
							targetBackground = Q_OFF
							targetText = Color3.fromRGB(255, 220, 220)
						end

						visual.background = visual.background:Lerp(targetBackground, blend)
						visual.text = visual.text:Lerp(targetText, blend)
						button.BackgroundColor3 = visual.background
						button.TextColor3 = Color3.fromRGB(255, 220, 220)
					else
						State._purpleAnimatedButtons[button] = nil
					end
				end

				RunService.RenderStepped:Wait()
			end
		end)
	end

	State._blueShineLabels = State._blueShineLabels or {}
	State._blueShineGradients = State._blueShineGradients or {}

	local function attachBlueTextShine(button)
		if not button or button:FindFirstChild("BlueTextShine") then return end

		button.TextTransparency = 1

		local shineText = Instance.new("TextLabel")
		shineText.Name = "BlueTextShine"
		shineText.BackgroundTransparency = 1
		shineText.BorderSizePixel = 0
		shineText.Size = UDim2.fromScale(1, 1)
		shineText.Position = UDim2.fromScale(0, 0)
		shineText.Text = button.Text
		shineText.TextColor3 = Color3.fromRGB(255, 220, 220)
		shineText.TextTransparency = 0
		shineText.TextScaled = button.TextScaled
		shineText.TextSize = button.TextSize
		shineText.Font = button.Font
		shineText.TextWrapped = button.TextWrapped
		shineText.LineHeight = button.LineHeight
		shineText.TextXAlignment = button.TextXAlignment
		shineText.TextYAlignment = button.TextYAlignment
		shineText.ZIndex = button.ZIndex + 1
		shineText.Active = false
		shineText.Selectable = false
		shineText.Parent = button

		local shineGradient = Instance.new("UIGradient")
		shineGradient.Name = "CleanBlueShine"
		shineGradient.Rotation = 0
		shineGradient.Offset = Vector2.new(-1.25, 0)
		shineGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(120, 15, 30)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(220, 50, 80)),
			ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 100, 60)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(220, 50, 80)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(120, 15, 30)),
		})
		shineGradient.Parent = shineText

		State._blueShineLabels[button] = shineText
		State._blueShineGradients[button] = shineGradient

		button:GetPropertyChangedSignal("Text"):Connect(function()
			if shineText.Parent then shineText.Text = button.Text end
		end)
		button:GetPropertyChangedSignal("Visible"):Connect(function()

			if shineText.Parent then shineText.Visible = button.Visible end
		end)
		button:GetPropertyChangedSignal("TextSize"):Connect(function()
			if shineText.Parent then shineText.TextSize = button.TextSize end
		end)
		button:GetPropertyChangedSignal("ZIndex"):Connect(function()
			if shineText.Parent then shineText.ZIndex = button.ZIndex + 1 end
		end)
	end

	if not State._blueShineSequenceStarted then
		State._blueShineSequenceStarted = true
		task.spawn(function()
			while gui and gui.Parent do
				local animatedAny = false
				for button, gradient in pairs(State._blueShineGradients) do
					if not (gui and gui.Parent) then break end
					if button and button.Parent and gradient and gradient.Parent and button.Visible then
						animatedAny = true
						gradient.Offset = Vector2.new(-1.25, 0)
						local tween = TweenService:Create(
							gradient,
							TweenInfo.new(1.45, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
							{Offset = Vector2.new(1.25, 0)}
						)
						tween:Play()
						tween.Completed:Wait()
						task.wait(0.06)
					elseif button and not button.Parent then
						State._blueShineLabels[button] = nil
						State._blueShineGradients[button] = nil
					end
				end
				if not animatedAny then task.wait(0.5) else task.wait(0.8) end
			end
		end)
	end

	local function createMobileButton(name, displayText, col, row, isToggle, onAction)
		local defaultX = mobileStartX + col * (BTN_SIZE + BTN_GAP)
		local defaultY = mobileStartY + row * (BTN_SIZE + BTN_GAP)

		local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. name
		btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
		local defaultPos = UDim2.new(0, defaultX, 0, defaultY)
		btn.Position = defaultPos
		btn.BackgroundColor3 = Q_OFF
		btn.BackgroundTransparency = 0
		btn.Text = displayText
		btn.TextColor3 = Color3.fromRGB(255, 220, 220)
		btn.TextScaled = false; btn.TextSize = 10
		btn.Font = Enum.Font.GothamBlack
		btn.TextWrapped = true; btn.LineHeight = 1.2
		btn.BorderSizePixel = 0; btn.AutoButtonColor = false
		btn.ZIndex = 101
		btn.Parent = gui
		mobileButtonsByName[name] = btn
		mobileButtonDefaultPositions[name] = defaultPos
		makeDraggable(btn, true)
		btn.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				if State.requestConfigSave then State.requestConfigSave() end
			end
		end)
		local buttonCorner = Instance.new("UICorner", btn)
		buttonCorner.Name = "ButtonShapeCorner"
		buttonCorner.CornerRadius = UDim.new(0, 14)

		local mobileStroke = Instance.new("UIStroke")
		mobileStroke.Name = "AccentOuterStroke"
		mobileStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		mobileStroke.Color = Color3.fromRGB(220, 50, 80)
		mobileStroke.Thickness = 1
		mobileStroke.Transparency = 0.8
		mobileStroke.LineJoinMode = Enum.LineJoinMode.Round
		mobileStroke.Parent = btn

		applyMobileButtonsSize(State.buttonsSizeValue)

		local isOn = false
		local function setter(s)
			isOn = s == true
			btn:SetAttribute("PurpleActive", isOn)
btn.BackgroundColor3 = isOn and Q_ON or Q_OFF
			btn.TextColor3 = isOn and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(255, 220, 220)
			mobileStroke.Transparency = isOn and 0.2 or 0.8
			end

			btn.MouseEnter:Connect(function()
				if not isOn then
					TweenService:Create(btn, TweenInfo.new(0.10), {BackgroundColor3 = Q_ON}):Play()
					TweenService:Create(btn, TweenInfo.new(0.10), {TextColor3 = Color3.fromRGB(10, 10, 10)}):Play()
				end
			end)
			btn.MouseLeave:Connect(function()
				TweenService:Create(btn, TweenInfo.new(0.10), {BackgroundColor3 = isOn and Q_ON or Q_OFF}):Play()
				TweenService:Create(btn, TweenInfo.new(0.10), {TextColor3 = isOn and Color3.fromRGB(10, 10, 10) or Color3.fromRGB(255, 220, 220)}):Play()
			end)

local function flash()
				btn.BackgroundColor3 = Q_ON
				btn.TextColor3 = Color3.fromRGB(10, 10, 10)
			task.delay(0.15, function()
				if btn and btn.Parent then
					btn.BackgroundColor3 = Q_OFF
					btn.TextColor3 = Color3.fromRGB(255, 220, 220)
				end
			end)
		end

		btn.Activated:Connect(function()
			if isToggle then
				isOn = not isOn; setter(isOn)
				if onAction then onAction(isOn) end
			else
				flash()
				if onAction then onAction() end
			end
			if State.requestConfigSave then State.requestConfigSave() end
		end)

		return btn, setter
	end

	createMobileButton("Drop", "DROP\nBR", 0, 0, false, function() task.spawn(runDrop) end)

	btnBatV2 = Instance.new("TextButton")
	btnBatV2.Name = "Btn_BatnV2"
	btnBatV2.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
	btnBatV2.Position = UDim2.new(0, mobileStartX, 0, mobileStartY + 4 * (BTN_SIZE + BTN_GAP))
	btnBatV2.BackgroundColor3 = Q_OFF
	btnBatV2.Text = "BAT V2"
	btnBatV2.TextColor3 = Color3.fromRGB(255, 220, 220)
	btnBatV2.TextScaled = false; btnBatV2.TextSize = 11
	btnBatV2.Font = Enum.Font.GothamBlack
	btnBatV2.TextWrapped = true; btnBatV2.LineHeight = 1.2
	btnBatV2.BorderSizePixel = 0; btnBatV2.AutoButtonColor = false
	btnBatV2.ZIndex = 101
	btnBatV2.Parent = gui
	local batV2Corner = Instance.new("UICorner", btnBatV2)
	batV2Corner.Name = "ButtonShapeCorner"
	batV2Corner.CornerRadius = UDim.new(0, 14)
	local batV2Stroke = Instance.new("UIStroke")
	batV2Stroke.Name = "AccentOuterStroke"
	batV2Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	batV2Stroke.Color = Color3.fromRGB(220, 50, 80)
	batV2Stroke.Thickness = 1
	batV2Stroke.Transparency = 0.8
	batV2Stroke.LineJoinMode = Enum.LineJoinMode.Round
	batV2Stroke.Parent = btnBatV2
	applyMobileButtonsSize(State.buttonsSizeValue)

	makeDraggable(btnBatV2, true)
	btnBatV2.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			if State.requestConfigSave then State.requestConfigSave() end
		end
	end)

	State._batV2On = false
	State._setBatV2Visual = function(s)
		State._batV2On = s
		btnBatV2:SetAttribute("PurpleActive", s == true)
		btnBatV2.BackgroundColor3 = s and Q_ON or Q_OFF
		if autoBatV2SetVisual then autoBatV2SetVisual(s) end
	end

	btnBatV2.Activated:Connect(function()
		State._batV2On = not State._batV2On
		State._setBatV2Visual(State._batV2On)
		State.autoBatV2Enabled = State._batV2On
		
		if _G.setRagdollTpState then _G.setRagdollTpState(not State._batV2On) end

		if State._batV2On then
			if State.autoLeftEnabled then State.autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoRightEnabled then State.autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then
				State.autoBatToggled = false
				if autoBatSetVisual then autoBatSetVisual(false) end
				stopBatAimbot()
			end
			if State.tpBatEnabled then State._setTPBatEnabled(false) end
			checkSpeedAndDropBeforeAction("autoBatV2Enabled", function()
				if startBatAimbotV2 then startBatAimbotV2() end
			end)
		else
			if stopBatAimbotV2 then stopBatAimbotV2() end
		end
		if State.requestConfigSave then State.requestConfigSave() end
	end)

	local oldAutoBatV2SetVisual = autoBatV2SetVisual
	autoBatV2SetVisual = function(on)
		State._batV2On = on
		btnBatV2:SetAttribute("PurpleActive", on == true)
		btnBatV2.BackgroundColor3 = on and Q_ON or Q_OFF
		if oldAutoBatV2SetVisual then oldAutoBatV2SetVisual(on) end
	end
	mobileBatV2SetActive = function(on) autoBatV2SetVisual(on) end


	resetMobileButtons = function()
		for name, btn in pairs(mobileButtonsByName) do
			local defaultPos = mobileButtonDefaultPositions[name]
			if btn and defaultPos then btn.Position = defaultPos end
		end
		btnBatV2.Position = UDim2.new(0, mobileStartX, 0, mobileStartY + 4 * (BTN_SIZE + BTN_GAP))
		if State.requestPositionSave then State.requestPositionSave() end
		if State.requestConfigSave then State.requestConfigSave() end
	end

	do
		local setter = select(2, createMobileButton("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(on)
			State.autoLeftEnabled = on
			if on then
				local requiredTpEnable = false
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State.autoBatToggled then 
					State.autoBatToggled=false; 
					if autoBatSetVisual then autoBatSetVisual(false) end; 
					stopBatAimbot()
					requiredTpEnable = true
				end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
					requiredTpEnable = true
				end
				if State.tpBatEnabled then State._setTPBatEnabled(false) end

				if requiredTpEnable and _G.setRagdollTpState then _G.setRagdollTpState(true) end

				local char = LP.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then 
					checkSpeedAndDropBeforeAction("autoLeftEnabled", function()
						startAutoLeft() 
					end)
				end
			else
				stopAutoLeft()
			end
		end))
		local previous = autoLeftSetVisual
		autoLeftSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoLeftSetActive = function(on) autoLeftSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoLeft = setter end
		local btn = mobileButtonsByName["AutoLeft"]
		if btn then
			btn.TextColor3 = Color3.fromRGB(255,255,255)
		end
	end

	do
		local setter = select(2, createMobileButton("AutoBat", "AIM\nBOT", 0, 1, true, function(on)
			State.autoBatToggled = on
			
			if _G.setRagdollTpState then _G.setRagdollTpState(not on) end

			if on then
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
				if State._batV2On then
					State._batV2On = false
					State._setBatV2Visual(false)
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if stopBatAimbotV2 then stopBatAimbotV2() end
				end
				if State.tpBatEnabled then State._setTPBatEnabled(false) end
				checkSpeedAndDropBeforeAction("autoBatToggled", function()
					startBatAimbot() 
				end)
			else
				stopBatAimbot()
			end
		end))
		local previous = autoBatSetVisual
		autoBatSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileBatV1SetActive = function(on) autoBatSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoBat = setter end
	end

	do
		local setter = select(2, createMobileButton("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(on)
			State.autoRightEnabled = on
			if on then
				local requiredTpEnable = false
				if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
				if State.autoBatToggled then 
					State.autoBatToggled=false; 
					if autoBatSetVisual then autoBatSetVisual(false) end; 
					stopBatAimbot()
					requiredTpEnable = true
				end
				if State.autoBatV2Enabled then
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if mobileBatV2SetActive then mobileBatV2SetActive(false) end
					stopBatAimbotV2()
					requiredTpEnable = true
				end
				if State.tpBatEnabled then State._setTPBatEnabled(false) end

				if requiredTpEnable and _G.setRagdollTpState then _G.setRagdollTpState(true) end

				local char = LP.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if hum and root and hum.WalkSpeed > 0 and not root.Anchored then 
					checkSpeedAndDropBeforeAction("autoRightEnabled", function()
						startAutoRight() 
					end)
				end
			else
				stopAutoRight()
			end
		end))
		local previous = autoRightSetVisual
		autoRightSetVisual = function(on)
			setter(on)
			if previous then previous(on) end
		end
		mobileAutoRightSetActive = function(on) autoRightSetVisual(on) end
		if mobileBtnActive then mobileBtnActive.AutoRight = setter end
		local btn = mobileButtonsByName["AutoRight"]
		if btn then
			btn.TextColor3 = Color3.fromRGB(255,255,255)
		end
	end

	createMobileButton("TPDown", "TP\nDOWN", 0, 2, false, function() task.spawn(runTPDown) end)

	State._tpBatButton, State._tpBatSetter = createMobileButton("TPBat", "TP\nBAT", 0, 4, true, function(on)
		State._setTPBatEnabled(on)
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end)
	State._tpBatSetVisual = function(on)
		State._setTPBatEnabled(on)
		if State._tpBatSetter then State._tpBatSetter(on) end
		if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(on) end
	end

	do
		local setter = select(2, createMobileButton("Speed", "CARRY\nSPD", 1, 2, true, function(on)
			State.speedToggled = on
			if on then
				State.laggerToggled = false
				laggerPhase = 0
				if mobileLaggerSetActive then mobileLaggerSetActive(false) end
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry" end
			else
				if modeValLbl then modeValLbl.Text = State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal" end
			end
		end))
		mobileSpeedSetActive = function(on) setter(on) end
	end

	do
		local lagger1Setter, lagger2Setter

		local function setLaggerPhase(phase)
			State.laggerToggled = true
			laggerPhase = phase
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
			if modeValLbl then modeValLbl.Text = "Lagger " .. tostring(phase) end
			lagger1Setter(phase == 1)
			lagger2Setter(phase == 2)
		end

		_, lagger1Setter = createMobileButton("Lagger1", "LAG\nMODE", 0, 3, true, function(on)
			if on then setLaggerPhase(1) else
				State.laggerToggled = false; laggerPhase = 0
				if modeValLbl then modeValLbl.Text = "Normal" end
				lagger2Setter(false)
			end
		end)

		_, lagger2Setter = createMobileButton("Lagger2", "LAG\nCARRY", 1, 3, true, function(on)
			if on then setLaggerPhase(2) else
				State.laggerToggled = false; laggerPhase = 0
				if modeValLbl then modeValLbl.Text = "Normal" end
				lagger1Setter(false)
			end
		end)

		mobileLaggerSetActive = function(on)
			local phase = laggerPhase == 2 and 2 or 1
			State.laggerToggled = on == true
			if on then laggerPhase = phase else laggerPhase = 0 end
			lagger1Setter(on == true and phase == 1)
			lagger2Setter(on == true and phase == 2)
		end
	end

	do
		local wasFrozen = false
		local prevInfJump = false
		local prevSuperJump = false
		local prevSpeedToggle = false

		RunService.Heartbeat:Connect(function()
			local char = LP.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then return end

			local isCurrentlyFrozen = hrp.Anchored or hum.WalkSpeed == 0

			if isCurrentlyFrozen then
				if State.autoBatV2Enabled or State._batV2On then
					State._batV2On = false
					State._setBatV2Visual(false)
					State.autoBatV2Enabled = false
					if autoBatV2SetVisual then autoBatV2SetVisual(false) end
					if stopBatAimbotV2 then stopBatAimbotV2() end
					if _G.setRagdollTpState then _G.setRagdollTpState(true) end
				end

				if State.autoBatToggled then
					State.autoBatToggled = false
					if autoBatSetVisual then autoBatSetVisual(false) end
					stopBatAimbot()
					if _G.setRagdollTpState then _G.setRagdollTpState(true) end
				end

				if not wasFrozen then
					wasFrozen = true
					prevInfJump = State.infJumpEnabled
					prevSuperJump = State.superJumpEnabled
					prevSpeedToggle = State.speedToggled

					if State.infJumpEnabled then
						State.infJumpEnabled = false
						if setInfJump then setInfJump(false) end
					end
					if State.superJumpEnabled then
						State.superJumpEnabled = false
						if setSuperJump then setSuperJump(false) end
					end
					if State.speedToggled then
						State.speedToggled = false
						if mobileSpeedSetActive then mobileSpeedSetActive(false) end
						if modeValLbl then
							modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
						end
					end

					if State.dropActive then
						if State.dropConn then
							State.dropConn:Disconnect()
							State.dropConn = nil
						end
						State.dropActive = false
					end
					if State.dropBrainrotActive then
						if State.dropBrainrotConn then
							State.dropBrainrotConn:Disconnect()
							State.dropBrainrotConn = nil
						end
						State.dropBrainrotActive = false
					end

					if State.autoLeftEnabled then stopAutoLeft() end
					if State.autoRightEnabled then stopAutoRight() end
				end
			else
				if wasFrozen then
					wasFrozen = false

					if prevInfJump then
						State.infJumpEnabled = true
						if setInfJump then setInfJump(true) end
					end
					if prevSuperJump then
						State.superJumpEnabled = true
						if setSuperJump then setSuperJump(true) end
					end
					if prevSpeedToggle then
						State.speedToggled = true
						if mobileSpeedSetActive then mobileSpeedSetActive(true) end
						if modeValLbl then
							modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry") or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal"))
						end
					end

					if State.autoLeftEnabled then startAutoLeft() end
					if State.autoRightEnabled then startAutoRight() end
				end
			end
		end)
	end
end


-- SECCIÓN 9: PLAYER ESP (PH)
local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espConn = nil
local _espLastRun = 0
profileImageCache = {}
local function clearESP()
	for plr in pairs(espHighlightCache) do
		pcall(function()
			espHighlightCache[plr]:Destroy()
		end)
	end
	for plr in pairs(espBillboardCache) do
		pcall(function()
			espBillboardCache[plr]:Destroy()
		end)
	end
	for plr in pairs(espTracerCache) do
		for _, ln in ipairs(espTracerCache[plr]) do
			pcall(function()
				ln.Visible = false
				ln:Remove()
			end)
		end
	end
	espHighlightCache = {}
	espBillboardCache = {}
	espTracerCache = {}
end
local function makeESPTracers()
	if not (Drawing and type(Drawing.new) == "function") then
		return nil
	end
	local SILVER = Color3.fromRGB(180, 180, 190)
	local outer = Drawing.new("Line")
	outer.Color = SILVER
	outer.Thickness = 2.2
	outer.Transparency = 0.90
	outer.Visible = false
	local mid = Drawing.new("Line")
	mid.Color = SILVER
	mid.Thickness = 1.2
	mid.Transparency = 0.74
	mid.Visible = false
	local core = Drawing.new("Line")
	core.Color = SILVER
	core.Thickness = 0.6
	core.Transparency = 0.10
	core.Visible = false
	return { outer, mid, core }
end
local function updatePlayerESP()
	Camera = workspace.CurrentCamera or Camera
	if not Camera then return end
	local now = tick()
	if now - _espLastRun < 0.03 then
		return
	end
	_espLastRun = now
	if not State.linieEnabled then
		clearESP()
		return
	end
	local myChar = LP.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then
		return
	end
	local myPos = myRoot.Position
	local myScreenPos, myOnScreen = Camera:WorldToViewportPoint(myPos)
	local myVec = Vector2.new(myScreenPos.X, myScreenPos.Y)
	local currentPlayers = Players:GetPlayers()
	local plrSet = {}
	for _, p in ipairs(currentPlayers) do
		plrSet[p] = true
	end
	for plr in pairs(espHighlightCache) do
		if not plrSet[plr] then
			pcall(function()
				espHighlightCache[plr]:Destroy()
			end)
			espHighlightCache[plr] = nil
		end
	end
	for plr in pairs(espBillboardCache) do
		if not plrSet[plr] then
			pcall(function()
				espBillboardCache[plr]:Destroy()
			end)
			espBillboardCache[plr] = nil
		end
	end
	for plr in pairs(espTracerCache) do
		if not plrSet[plr] then
			for _, ln in ipairs(espTracerCache[plr]) do
				pcall(function()
					ln.Visible = false
					ln:Remove()
				end)
			end
			espTracerCache[plr] = nil
		end
	end
	for _, plr in ipairs(currentPlayers) do
		if plr == LP then
			continue
		end
		local char = plr.Character
		if not char then
			if espHighlightCache[plr] then
				pcall(function()
					espHighlightCache[plr]:Destroy()
				end)
				espHighlightCache[plr] = nil
			end
			if espBillboardCache[plr] then
				pcall(function()
					espBillboardCache[plr]:Destroy()
				end)
				espBillboardCache[plr] = nil
			end
			if espTracerCache[plr] then
				for _, ln in ipairs(espTracerCache[plr]) do
					pcall(function()
						ln.Visible = false
					end)
				end
			end
			continue
		end
		local tRoot = char:FindFirstChild("HumanoidRootPart")
		local tHead = char:FindFirstChild("Head")
		local tHum = char:FindFirstChildOfClass("Humanoid")
		local alive = tRoot and tHead and tHum and tHum.Health > 0
		if alive then
			local hl = espHighlightCache[plr]
			if not hl or not hl.Parent or hl.Parent ~= char then
				if hl then
					pcall(function()
						hl:Destroy()
					end)
				end
				hl = Instance.new("Highlight")
				hl.Name = "LustHubESP"
				hl.FillColor = Color3.fromRGB(180, 180, 190)
				hl.FillTransparency = 0.72
				hl.OutlineColor = Color3.fromRGB(180, 180, 190)
				hl.OutlineTransparency = 0.05
				hl.Adornee = char
				hl.Parent = char
				espHighlightCache[plr] = hl
			end
			local bb = espBillboardCache[plr]
			if not bb or not bb.Parent then
				if bb then
					pcall(function()
						bb:Destroy()
					end)
				end
				bb = Instance.new("BillboardGui")
				bb.Name = "ProfilePic"
				bb.Size = UDim2.new(0, 56, 0, 56)
				bb.StudsOffset = Vector3.new(0, 3.8, 0)
				bb.Adornee = tHead
				bb.AlwaysOnTop = true
				bb.Parent = tHead
				local img = Instance.new("ImageLabel", bb)
				img.Size = UDim2.new(1, -6, 1, -6)
				img.Position = UDim2.new(0, 3, 0, 3)
				img.BackgroundTransparency = 1
				img.Image = "rbxassetid://0"
				img.ScaleType = Enum.ScaleType.Fit
				local circle = Instance.new("UICorner", img)
				circle.CornerRadius = UDim.new(1, 0)
				local stroke = Instance.new("UIStroke", img)
				stroke.Color = Color3.fromRGB(180, 180, 190)
				stroke.Thickness = 1.5
				espBillboardCache[plr] = bb
				task.spawn(function()
					local userId = plr.UserId
					local url = profileImageCache[userId]
					if not url then
						local success, u = pcall(function()
							return Players:GetUserThumbnailAsync(
								userId,
								Enum.ThumbnailType.HeadShot,
								Enum.ThumbnailSize.Size420x420
							)
						end)
						if success and u and u ~= "" then
							url = u
							profileImageCache[userId] = url
						else
							url = "rbxassetid://0"
						end
					end
					if img then
						img.Image = url
					end
				end)
			else
				if bb.Adornee ~= tHead then
					bb.Adornee = tHead
				end
				bb.Enabled = true
			end
			local lines = espTracerCache[plr]
			if not lines then
				lines = makeESPTracers()
				espTracerCache[plr] = lines or {}
			end
			if lines and #lines > 0 then
				local destPos = tRoot.Position
				local pos, onScreen = Camera:WorldToViewportPoint(destPos)
				if onScreen and pos.Z > 0 and myOnScreen then
					local tVec = Vector2.new(pos.X, pos.Y)
					for _, ln in ipairs(lines) do
						ln.From = myVec
						ln.To = tVec
						ln.Visible = true
					end
				else
					for _, ln in ipairs(lines) do
						ln.Visible = false
					end
				end
			end
		else
			if espHighlightCache[plr] then
				pcall(function()
					espHighlightCache[plr]:Destroy()
				end)
				espHighlightCache[plr] = nil
			end
			if espBillboardCache[plr] then
				pcall(function()
					espBillboardCache[plr]:Destroy()
				end)
				espBillboardCache[plr] = nil
			end
			if espTracerCache[plr] then
				for _, ln in ipairs(espTracerCache[plr]) do
					pcall(function()
						ln.Visible = false
					end)
				end
			end
		end
	end
end
local function startPlayerESPLoop()
	if espConn then
		espConn:Disconnect()
	end
	espConn = RunService.RenderStepped:Connect(updatePlayerESP)
end
local function stopPlayerESPLoop()
	if espConn then
		espConn:Disconnect()
		espConn = nil
	end
	clearESP()
end
function toggleESP(on)
	State.linieEnabled = on == true
	if State.linieEnabled then
		clearESP()
		startPlayerESPLoop()
	else
		stopPlayerESPLoop()
	end
end

State._positionConfigFile = "Vereuxv2_positions.json"
State._positionBackupFile = "Vereuxv2_positions.backup.json"
State._positionTempFile = "Vereuxv2_positions.tmp.json"
State._positionSaveRequestId = 0

State._positionSnapshot = function(guiObject)
    if not guiObject then return nil end
    local ok, position = pcall(function() return guiObject.Position end)
    if not ok or not position then return nil end
    return {xs=position.X.Scale, xo=position.X.Offset, ys=position.Y.Scale, yo=position.Y.Offset}
end

State._restoreSavedPosition = function(guiObject, data)
    if not guiObject or type(data) ~= "table" or data.xs == nil then return end
    pcall(function()
        guiObject.Position = UDim2.new(
            tonumber(data.xs) or 0,
            tonumber(data.xo) or 0,
            tonumber(data.ys) or 0,
            tonumber(data.yo) or 0
        )
    end)
end

State.savePositionBackup = function()
    local buttonPositions = {}
    for name, button in pairs(mobileButtonsByName) do
        buttonPositions[name] = State._positionSnapshot(button)
    end

    local payload = {
        version = 2,
        mainPos = State._positionSnapshot(main),
        miniPos = State._positionSnapshot(mini),
        panelPos = State._positionSnapshot(MobilePanel),
        pbPos = State._positionSnapshot(pbFrame),
        batV2Pos = State._positionSnapshot(btnBatV2),
        instaResetPos = State._positionSnapshot(btnInstaReset),
        autoStealBarPos = State._positionSnapshot(State.autoStealBarFrame),
        mobileButtonPositions = buttonPositions,
    }

    local encodedOk, encoded = pcall(function() return HttpService:JSONEncode(payload) end)
    if not encodedOk then return false end

    if encoded == State._lastPositionJson then
        State._positionDirty = false
        return true
    end

    local saved, err = State._atomicJsonSave(
        State._positionConfigFile,
        State._positionBackupFile,
        State._positionTempFile,
        encoded
    )
    if saved then
        State._lastPositionJson = encoded
        State._positionDirty = false
    else
        State._lastSaveError = err
    end
    return saved
end

State.loadPositionBackup = function()
    local mainData, mainRaw = State._readValidJsonFile(State._positionConfigFile)
    local tempData, tempRaw = State._readValidJsonFile(State._positionTempFile)
    local backupData, backupRaw = State._readValidJsonFile(State._positionBackupFile)

    local data, raw, recovered = nil, nil, false
    if type(tempData) == "table" and (type(mainData) ~= "table" or tempRaw ~= mainRaw) then
        data, raw, recovered = tempData, tempRaw, true
    elseif type(mainData) == "table" then
        data, raw = mainData, mainRaw
    elseif type(backupData) == "table" then
        data, raw, recovered = backupData, backupRaw, true
    end

    if type(data) ~= "table" then return false end
    State._lastPositionJson = raw
    State._positionDirty = false

    local function apply()
        State._restoreSavedPosition(main, data.mainPos)
        State._restoreSavedPosition(mini, data.miniPos)
        State._restoreSavedPosition(MobilePanel, data.panelPos)
        State._restoreSavedPosition(pbFrame, data.pbPos)
        State._restoreSavedPosition(btnBatV2, data.batV2Pos)
        State._restoreSavedPosition(btnInstaReset, data.instaResetPos)
        State._restoreSavedPosition(State.autoStealBarFrame, data.autoStealBarPos)
        if type(data.mobileButtonPositions) == "table" then
            for name, positionData in pairs(data.mobileButtonPositions) do
                State._restoreSavedPosition(mobileButtonsByName[name], positionData)
            end
        end
    end

    apply()
    task.delay(0.45, apply)
    task.delay(1.2, apply)

    if recovered and type(raw) == "string" then
        task.defer(function()
            State._atomicJsonSave(
                State._positionConfigFile,
                State._positionBackupFile,
                State._positionTempFile,
                raw
            )
        end)
    end
    return true
end

State.requestPositionSave = function()
    State._positionDirty = true
    State._positionSaveRequestId = State._positionSaveRequestId + 1
    local requestId = State._positionSaveRequestId

    task.delay(0.55, function()
        if requestId ~= State._positionSaveRequestId then return end
        if not State._positionDirty then return end
        local ok, result = pcall(State.savePositionBackup)
        if not ok then State._lastSaveError = tostring(result) end
    end)
end

task.spawn(function()
    task.wait(0.15)
    pcall(State.loadPositionBackup)
end)

-- SECCIÓN 10: BAT AIMBOT V2 Y FUNCIONES DE CONTEO
local function getAutoBatTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - _autoBatLastScan <= 0.1 and _autoBatTarget and _autoBatTarget.Parent then
        local hum = _autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        local char = _autoBatTarget.Parent
        local hasAntiBat = char:FindFirstChild("Anti-Bat") or char:FindFirstChild("AntiBat") or char:FindFirstChild("Shield")
        if hum and hum.Health > 0 and not hasAntiBat then return _autoBatTarget end
    end
    _autoBatLastScan = now
    _autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local tChar = plr.Character

            local hasAntiBat = tChar:FindFirstChild("Anti-Bat") or tChar:FindFirstChild("AntiBat") or tChar:FindFirstChild("Shield")

            if tRoot and hum and hum.Health > 0 and not hasAntiBat then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    _autoBatTarget = closest
    return _autoBatTarget
end

local LUST_BYPASS_AIMBOT_SPEED = 60
local BAT_V2_FOLLOW_DIST = 1.0
local BAT_V2_HEIGHT_OFFSET = 1.5
local BAT_V2_VERTICAL_OFFSET = 0.0
local BAT_V2_HIT_DIST = 4.5
local BAT_V2_SWING_COOLDOWN = 0.1

local bypassHittingCooldown = false

local function getClosestPlayerV2()
    local char = LP.Character
    if not char then return nil, math.huge end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end

    local closest, bestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < bestDistance then
                    bestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest, bestDistance
end

local function tryHitBypassBat()
    if bypassHittingCooldown then return end
    bypassHittingCooldown = true

    pcall(function()
        local char = LP.Character
        if not char then return end

        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatToolLust(currentTool) then
            bypassHittingCooldown = false
            return
        end

        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function() humanoid:EquipTool(bat) end)
                end
            end

            local remote = bat:FindFirstChildOfClass("RemoteEvent")
            if remote then
                pcall(function() remote:FireServer() end)
            else
                pcall(function() bat:Activate() end)
            end
        end
    end)

    task.delay(BAT_V2_SWING_COOLDOWN, function()
        bypassHittingCooldown = false
    end)
    task.delay(0.2, function()
        if bypassHittingCooldown then
            bypassHittingCooldown = false
        end
    end)
end

startBatAimbotV2 = function()
    if State.tpBatEnabled then
        State._setTPBatEnabled(false)
    end

    if Conns.aimbotV2 then return end
    State.autoBatV2Enabled = true

    Conns.aimbotV2 = RunService.Heartbeat:Connect(function()
        if not State.autoBatV2Enabled then return end

        local char = LP.Character
        if not char then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        local humanoidState = humanoid:GetState()
        if humanoidState == Enum.HumanoidStateType.Physics
            or humanoidState == Enum.HumanoidStateType.Ragdoll
            or humanoidState == Enum.HumanoidStateType.FallingDown then
            return
        end

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then
                pcall(function() humanoid:EquipTool(bat) end)
            end
        end

        local target = getClosestPlayerV2()
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local targetVelocity = targetRoot.AssemblyLinearVelocity
                local movementDirection = targetVelocity.Magnitude > 0.1
                    and targetVelocity.Unit
                    or targetRoot.CFrame.LookVector

                local offset = movementDirection * BAT_V2_FOLLOW_DIST
                    + Vector3.new(0, BAT_V2_HEIGHT_OFFSET + BAT_V2_VERTICAL_OFFSET, 0)
                local desiredPosition = targetRoot.Position + offset
                local directionToTarget = desiredPosition - root.Position

                local speed = State.batV2Speed or 60
                if directionToTarget.Magnitude > 0.5 then
                    local movementVector = directionToTarget.Unit * speed
                    root.AssemblyLinearVelocity = Vector3.new(
                        movementVector.X,
                        movementVector.Y,
                        movementVector.Z
                    )
                else
                    root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.95
                    if root.AssemblyLinearVelocity.Magnitude < 1 then
                        root.AssemblyLinearVelocity = Vector3.zero
                    end
                end

                if State.autoSwingEnabled
                    and (root.Position - targetRoot.Position).Magnitude <= BAT_V2_HIT_DIST then
                    tryHitBypassBat()
                end
            end
        else
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.9
            if root.AssemblyLinearVelocity.Magnitude < 1 then
                root.AssemblyLinearVelocity = Vector3.zero
            end
        end
    end)
end

stopBatAimbotV2 = function()
    State.autoBatV2Enabled = false

    if Conns.aimbotV2 then
        Conns.aimbotV2:Disconnect()
        Conns.aimbotV2 = nil
    end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.AutoRotate = true
        humanoid.PlatformStand = false
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end

    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        pcall(function()
            if sethiddenproperty then
                sethiddenproperty(root, "PhysicsRepRootPart", nil)
            end
        end)
    end

    bypassHittingCooldown = false
    State.lastMoveDir = Vector3.zero
end

-- SECCIÓN 11: AUTO STEAL (BLESS.VS) CON PERSISTENCIA
;(function()

local function _isfile(path)
    local checker = State._resolveFileFunction("isfile")
    if type(checker) == "function" then
        local ok, exists = pcall(checker, path)
        if ok then return exists == true end
    end
    local raw = State._safeReadFile(path)
    return type(raw) == "string"
end
local function _readfile(path)
    local raw, err = State._safeReadFile(path)
    if type(raw) ~= "string" then error(err or "readfile failed", 0) end
    return raw
end
local function _writefile(path, data)
    local ok, err = State._safeWriteFile(path, data)
    if not ok then error(err or "writefile failed", 0) end
    return true
end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15
local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15
local CONFIG_FILE="Vereuxv2.json"
State._configTempFile="Vereuxv2.tmp.json"
State._legacyConfigFile="Vereuxv2.json"
State._configBackupFile="Vereuxv2.backup.json"
State._legacyConfigBackupFile="Vereuxvs.backup.json"
State._legacyConfigTempFile="VereuxV2Config.tmp.json"

State.autoLeftPhase=1; State.autoRightPhase=1
State.medusaLastUsed=0; State.medusaDebounce=false; State.medusaCounterEnabled=false
State.batAimbotToggled=false; State.autoSwingEnabled=false
State.hittingCooldown=false
State.batCounterEnabled=false; State.batCounterDebounce=false
State.dropEnabled=false; State._tpInProgress=false
State.lastMoveDir=Vector3.new(0,0,0)
State._prevCarry=CS; State._prevSpeed=false
State.laggerEnabled=false

Conns.autoLeft=nil; Conns.autoRight=nil; Conns.aimbot=nil
Conns.batCounter=nil; Conns.unwalk=nil

local Presets={}
local PRESET_FILE="FEARV2Presets.json"; local LAST_PRESET_FILE="FEARV2LastPreset.json"
local function buildPresetSnapshot()
    return {normalSpeed=NS,carrySpeed=CS,laggerSpeed=LS,stealRadius=Steal.StealRadius,
        infJump=State.infJumpEnabled,
        antiRagdoll=State.antiRagdollEnabled,fpsBoost=State.fpsBoostEnabled,
        medusaCounter=State.medusaCounterEnabled,batCounter=State.batCounterEnabled,
        autoSteal=Steal.AutoStealEnabled,uiScale=uiScaleValue}
end
local function savePresetsFile()
    local ok,enc=pcall(function() return HttpService:JSONEncode(Presets) end)
    if ok then pcall(function() _writefile(PRESET_FILE,enc) end) end
end
local function loadPresetsFile()
    local hasFile=false; pcall(function() hasFile=_isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=_readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then Presets=dec end
end
local function saveLastPresetName(name)
    local ok,enc=pcall(function() return HttpService:JSONEncode({lastPreset=name}) end)
    if ok then pcall(function() _writefile(LAST_PRESET_FILE,enc) end) end
end
local function loadLastPresetName()
    local hasFile=false; pcall(function() hasFile=_isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw; pcall(function() raw=_readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then return dec.lastPreset end; return nil
end

local function doTpDown()
    pcall(function()
        local character, humanoid, root = safetyCharacterParts()
        if character then safetyTeleportToFloor(character, humanoid, root) end
    end)
end

local DROP_BRAINROT_ASCEND_DURATION = 0.22
local DROP_BRAINROT_ASCEND_SPEED = 160

local function runDropBrainrot()
    if State.dropBrainrotActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    State.dropBrainrotActive = true
    local startedAt = tick()
    State.dropBrainrotConn = RunService.Heartbeat:Connect(function()
        local currentChar = LP.Character
        local r = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
        local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
        if not r or not currentHum or currentHum.Health <= 0 then
            if State.dropBrainrotConn then
                State.dropBrainrotConn:Disconnect()
                State.dropBrainrotConn = nil
            end
            State.dropBrainrotActive = false
            return
        end

        if tick() - startedAt >= DROP_BRAINROT_ASCEND_DURATION then
            if State.dropBrainrotConn then
                State.dropBrainrotConn:Disconnect()
                State.dropBrainrotConn = nil
            end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {currentChar}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
                if rr then
                    local offset = (currentHum.HipHeight or 2) + (r.Size.Y / 2)
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + offset, r.Position.Z)
                elseif r.Position.Y < -100 then
                    r.CFrame = CFrame.new(r.Position.X, 5, r.Position.Z)
                end
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
                if currentHum.Health > 0 then
                    currentHum:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
            State.dropBrainrotActive = false
            return
        end

        local velocity = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(velocity.X, DROP_BRAINROT_ASCEND_SPEED, velocity.Z)
    end)
end

local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end
local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
local function stopBatCounter()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

local function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChildOfClass("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end; State.medusaDebounce=true
    local med=findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
local function setupMedusaCounter(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
local function stopMedusaCounter() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

local function faceSouth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end end) end
local function faceNorth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end end) end

local function startAutoLeft()
    if State.tpBatEnabled then
        State._setTPBatEnabled(false)
    end

    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=getProfileNormalSpeed()
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(AP.L1.X,root.Position.Y,AP.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(AP.L2.X,root.Position.Y,AP.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if autoLeftSetVisual then autoLeftSetVisual(false) end; faceSouth(); return end
            local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end
local function startAutoRight()
    if State.tpBatEnabled then
        State._setTPBatEnabled(false)
    end

    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=getProfileNormalSpeed()
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(AP.R1.X,root.Position.Y,AP.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(AP.R2.X,root.Position.Y,AP.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if autoRightSetVisual then autoRightSetVisual(false) end; faceNorth(); return end
            local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end

local antiRagdollConn = nil
local AntiRagdollV2 = { ResetCooldown = 0 }

local function resetAntiRagdollCharacter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end

    pcall(function()
        if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end

        workspace.CurrentCamera.CameraSubject = hum

        local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controlModule = playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local success, module = pcall(require, controlModule)
                if success and module and module.Enable then
                    module:Enable()
                end
            end
        end
    end)
end

startAntiRagdoll = function()
    if antiRagdollConn then return end

    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end

        local char = LP.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local root = char:FindFirstChild("HumanoidRootPart")
        if not root or hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            local now = tick()
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                resetAntiRagdollCharacter(char)
            end
        end
    end)
end

stopAntiRagdoll = function()
    if antiRagdollConn then
        antiRagdollConn:Disconnect()
        antiRagdollConn = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

local ContentProvider = game:GetService("ContentProvider")

-- Animation packs imported from fetched_clean, controlled by the same toggle.
ANIMATION_PACKS = {
    Tryhard = {
        WalkAnim = 707897309,
        RunAnim = 707861613,
        JumpAnim = 116936326516985,
        FallAnim = 116936326516985,
        ClimbAnim = 116936326516985,
        Swim = 116936326516985,
        SwimIdle = 116936326516985,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Crazy = {
        WalkAnim = 90478085024465,
        RunAnim = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 10921148939,
        SwimIdle = 129126268464847,
        Swim = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
      zombie= {
   	WalkAnim = 10921355261,
		RunAnim  = 616163682,
		JumpAnim = 10921322186,
		FallAnim = 10921321317,
		SwimIdle = 10921353442,
		Swim     = 10921352344,
		Animation1 = 122257458498464,
		Animation2 = 102357151005774,
		ClimbAnim = 10921343576
    },
    Mage = {
        WalkAnim = 707897309,
        RunAnim = 616163682,
        JumpAnim = 656117878,
        FallAnim = 656115606,
        ClimbAnim = 656114359,
        Swim = 656119721,
        SwimIdle = 656121397,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
    },
    Adidas = {
        WalkAnim = 10921152678,
        RunAnim = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 121152442762481,
        ClimbAnim = 88763136693023,
        Swim = 133308483266208,
        SwimIdle = 109346520324160,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
    },
    Solar = {
        WalkAnim = 10921355261,
        RunAnim = 616163682,
        JumpAnim = 104325245285198,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
}
    

    

    

local ANIMATION_PACK_ORDER = { "Off", "Tryhard", "Crazy" }
local ANIMATION_PACK_DEFAULT = "Tryhard"
animationPackName = ANIMATION_PACK_DEFAULT
local savedAnimate = nil
local applyingAnimationPack = false

local function waitForAnimate(character)
    for _ = 1, 40 do
        local animate = character and character:FindFirstChild("Animate")
        if animate and animate:FindFirstChild("idle") and animate:FindFirstChild("run") and animate:FindFirstChild("walk") then
            return animate
        end
        task.wait(0.1)
    end
    return nil
end

local function stopAllAnimationTracks(humanoid)
    if not humanoid then return end
    for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

local function ensureAnimation(folder, name)
    if not folder then return nil end
    local anim = folder:FindFirstChild(name)
    if not anim then
        anim = Instance.new("Animation")
        anim.Name = name
        anim.Parent = folder
    end
    return anim
end

local function setAnimation(anim, id)
    if anim and id then
        anim.AnimationId = "rbxassetid://" .. tostring(id)
    end
end

local function pickAnimation(pack, ...)
    for i = 1, select("#", ...) do
        local value = pack[select(i, ...)]
        if value ~= nil then return value end
    end
    return nil
end

local function saveOriginalAnimate(character)
    if character and not savedAnimate then
        local animate = character:FindFirstChild("Animate")
        if animate then savedAnimate = animate:Clone() end
    end
end

local function restoreOriginalAnimate(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    stopAllAnimationTracks(humanoid)

    local current = character:FindFirstChild("Animate")
    if current then current:Destroy() end

    -- Usa la copia original; si no existe, recupera Animate desde StarterPlayer.
    local sourceAnimate = savedAnimate
    if not sourceAnimate then
        local starterPlayer = game:GetService("StarterPlayer")
        local starterScripts = starterPlayer and starterPlayer:FindFirstChildOfClass("StarterCharacterScripts")
        sourceAnimate = starterScripts and starterScripts:FindFirstChild("Animate")
    end

    if sourceAnimate then
        local restored = sourceAnimate:Clone()
        restored.Disabled = false
        restored.Parent = character
        task.wait(0.08)
        pcall(function() restored.Disabled = true end)
        task.wait(0.03)
        pcall(function() restored.Disabled = false end)
    end

    if humanoid and humanoid.Parent then
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.04)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

local function applyAnimationPack(packName)
    if not State.nuevaAnimacionEnabled then
        restoreOriginalAnimate(LP.Character)
        return false
    end
    if applyingAnimationPack then return false end
    local pack = ANIMATION_PACKS[packName]
    if not pack then return false end
    applyingAnimationPack = true
    local character = LP.Character or LP.CharacterAdded:Wait()
    saveOriginalAnimate(character)
    local animate = waitForAnimate(character)
    if not animate then applyingAnimationPack = false; return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    stopAllAnimationTracks(humanoid)

    setAnimation(ensureAnimation(animate:FindFirstChild("walk"), "WalkAnim"), pickAnimation(pack, "WalkAnim", "Walk"))
    setAnimation(ensureAnimation(animate:FindFirstChild("run"), "RunAnim"), pickAnimation(pack, "RunAnim", "Run"))
    setAnimation(ensureAnimation(animate:FindFirstChild("jump"), "JumpAnim"), pickAnimation(pack, "JumpAnim", "Jump"))
    setAnimation(ensureAnimation(animate:FindFirstChild("fall"), "FallAnim"), pickAnimation(pack, "FallAnim", "Fall"))
    setAnimation(ensureAnimation(animate:FindFirstChild("climb"), "ClimbAnim"), pickAnimation(pack, "ClimbAnim", "Climb"))
    setAnimation(ensureAnimation(animate:FindFirstChild("swim"), "Swim"), pickAnimation(pack, "Swim"))
    setAnimation(ensureAnimation(animate:FindFirstChild("swimidle"), "SwimIdle"), pickAnimation(pack, "SwimIdle", "Swim"))

    local idle = animate:FindFirstChild("idle")
    if idle then
        local idle1 = pickAnimation(pack, "Animation1")
        local idle2 = pickAnimation(pack, "Animation2")
        if idle1 or idle2 then
            idle1, idle2 = idle1 or idle2, idle2 or idle1 or idle1
            setAnimation(ensureAnimation(idle, "Animation1"), idle1)
            setAnimation(ensureAnimation(idle, "Animation2"), idle2)
        elseif pack.Idle and #pack.Idle > 0 then
            for i, id in ipairs(pack.Idle) do
                setAnimation(ensureAnimation(idle, "Animation" .. i), id)
            end
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false
    if humanoid then
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    animationPackName = packName
    applyingAnimationPack = false
    return true
end

function startNuevaAnimacion()
    applyAnimationPack(animationPackName)
end

function stopNuevaAnimacion()
    restoreOriginalAnimate(LP.Character)
end

LP.CharacterAdded:Connect(function(character)
    savedAnimate = nil
    if State.nuevaAnimacionEnabled then
        task.defer(function()
            task.wait(0.5)
            applyAnimationPack(animationPackName)
        end)
    end
end)

local applyFPSBoost
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function()
        if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
        elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
        elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("SpecialMesh") then v.TextureId=""
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
        elseif v:IsA("Attachment") then v.Visible=false end
    end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local plots = workspace:WaitForChild("Plots")

-- ============================================================
--  AUTO STEAL DE BLESS.VS (REEMPLAZADO COMPLETAMENTE)
-- ============================================================
local CONFIG = {
	AUTO_STEAL_ENABLED = true,
	HOLD_MIN = 1.3,
	HOLD_MAX = 2.6,
	ENTRY_DELAY = 0.3,
	COOLDOWN = 0.05,
	STEAL_RANGE = 9,
	PRIME_RANGE = 80
}

local AnimalsData = {}
local syncRemotes = nil
local plotAnimalSync = {caches = {}, connections = {}}
local allAnimalsCache = {}
local PromptMemoryCache = {}
local InternalStealCache = {}
local stealConnection = nil

local StealState = {
	active = false,
	startTime = 0,
	phase = "idle",
	label = "",
	lastResult = "",
	lastResultTime = 0,
	totalSteals = 0,
	failedSteals = 0
}

local function initializeAutoStealSync()
	local ok = pcall(function()
		local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
		local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
		if not Packages or not Datas then return end
		AnimalsData = require(Datas:WaitForChild("Animals"))
		local folder = Packages:WaitForChild("Synchronizer")
		syncRemotes = {
			channelFolder = folder:WaitForChild("Channel"),
			routeRemote = folder:WaitForChild("CommunicationRoute"),
			requestData = folder:FindFirstChild("RequestData")
		}
	end)
	return ok and syncRemotes ~= nil
end

local function splitSyncPath(path)
	if typeof(path) == "table" then return path end
	local out = {}
	for part in string.gmatch(tostring(path), "[^%.]+") do
		table.insert(out, tonumber(part) or part)
	end
	return out
end

local function resolveSyncPath(path, root)
	local current = root
	local parent = nil
	local key = nil
	for _, part in ipairs(splitSyncPath(path)) do
		parent = current
		key = part
		current = current and current[part] or nil
	end
	return current, parent, key
end

local function applyPlotSyncDiff(channelName, packet)
	local cache = plotAnimalSync.caches[channelName]
	if typeof(cache) ~= "table" then return end
	local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
	local current, parent, key = resolveSyncPath(path, cache)
	if action == "Changed" then
		if parent ~= nil then parent[key] = a end
	elseif action == "ArrayInsert" then
		if current ~= nil then table.insert(current, b, a) end
	elseif action == "ArrayRemoved" then
		if current ~= nil then table.remove(current, b) end
	elseif action == "DictionaryInsert" then
		if current ~= nil then current[b] = a end
	elseif action == "DictionaryRemoved" then
		if current ~= nil then current[b] = nil end
	end
end

local function attachPlotChannel(remote)
	if not syncRemotes or plotAnimalSync.connections[remote] then return end
	local channelName = tostring(remote.Name)
	if not plots:FindFirstChild(channelName) then return end
	if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
		local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
		plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
	elseif plotAnimalSync.caches[channelName] == nil then
		plotAnimalSync.caches[channelName] = {}
	end
	plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
		for _, packet in ipairs(queue) do
			applyPlotSyncDiff(channelName, packet)
		end
	end)
end

local function detachPlotChannel(channelName)
	for remote, conn in pairs(plotAnimalSync.connections) do
		if tostring(remote.Name) == tostring(channelName) then
			conn:Disconnect()
			plotAnimalSync.connections[remote] = nil
			plotAnimalSync.caches[tostring(channelName)] = nil
			break
		end
	end
end

local function startAutoStealSync()
	if not initializeAutoStealSync() then return false end
	for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
		if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end
	syncRemotes.channelFolder.ChildAdded:Connect(function(child)
		if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end)
	syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
		for _, action in ipairs(actions) do
			local kind, channelName = action[1], tostring(action[2])
			if not plots:FindFirstChild(channelName) then continue end
			if kind == "ListenerAdded" then
				local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
				if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
			elseif kind == "ListenerRemoved" then
				detachPlotChannel(channelName)
			end
		end
	end)
	return true
end

local function getPlotChannelData(plotName)
	return plotAnimalSync.caches[plotName]
end

local function getPlotOwner(plot)
	local sign = plot:FindFirstChild("PlotSign")
	local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
	local label = frame and frame:FindFirstChild("TextLabel")
	if not label or label.Text == "Empty Base" then return nil end
	return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function isMyBaseAnimal(animalData)
	if not animalData or not animalData.plot then return false end
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return false end
	return getPlotOwner(plot) == LP.DisplayName
end

local function getAnimalPosition(animalData)
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return nil end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	if not podiums then return nil end
	local podium = podiums:FindFirstChild(animalData.slot)
	if not podium then return nil end
	return podium:GetPivot().Position
end

local function findProximityPromptForAnimal(animalData)
	if not animalData then return nil end
	local cached = PromptMemoryCache[animalData.uid]
	if cached and cached.Parent then return cached end
	local plot = plots:FindFirstChild(animalData.plot)
	if not plot then return nil end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	if not podiums then return nil end
	local podium = podiums:FindFirstChild(animalData.slot)
	if not podium then return nil end
	local base = podium:FindFirstChild("Base")
	if not base then return nil end
	local spawn = base:FindFirstChild("Spawn")
	if not spawn then return nil end
	local attach = spawn:FindFirstChild("PromptAttachment")
	if not attach then return nil end
	for _, p in ipairs(attach:GetChildren()) do
		if p:IsA("ProximityPrompt") then
			PromptMemoryCache[animalData.uid] = p
			return p
		end
	end
	return nil
end

local function distToAnimal(animalData)
	local character = LP.Character
	if not character then return math.huge end
	local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
	if not hrp then return math.huge end
	local pos = getAnimalPosition(animalData)
	if not pos then return math.huge end
	return (hrp.Position - pos).Magnitude
end

local function pickClosest()
	local character = LP.Character
	if not character then return nil end
	local hrp = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
	if not hrp then return nil end
	local best, bestDist = nil, math.huge
	for _, animalData in ipairs(allAnimalsCache) do
		if isMyBaseAnimal(animalData) then continue end
		local pos = getAnimalPosition(animalData)
		if not pos then continue end
		local dist = (hrp.Position - pos).Magnitude
		if dist > CONFIG.PRIME_RANGE then continue end
		if dist < bestDist then
			bestDist = dist
			best = animalData
		end
	end
	return best
end

local function buildStealCallbacks(prompt)
	if InternalStealCache[prompt] then return end
	local data = {holdCallbacks = {}, triggerCallbacks = {}, ready = true}
	local ok1, conns1 = false, nil
	if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
	if ok1 and type(conns1) == "table" then
		for _, conn in ipairs(conns1) do
			if type(conn.Function) == "function" then
				table.insert(data.holdCallbacks, conn.Function)
			end
		end
	end
	local ok2, conns2 = false, nil
	if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
	if ok2 and type(conns2) == "table" then
		for _, conn in ipairs(conns2) do
			if type(conn.Function) == "function" then
				table.insert(data.triggerCallbacks, conn.Function)
			end
		end
	end
	if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
		InternalStealCache[prompt] = data
	end
end

local function executeStealAsync(prompt, animalData)
	local data = InternalStealCache[prompt]
	if not data or not data.ready then return false end
	data.ready = false
	local label = animalData.name or "Animal"
	StealState.active = true
	StealState.startTime = tick()
	StealState.phase = "holding"
	StealState.label = label
	task.spawn(function()
		for _, fn in ipairs(data.holdCallbacks) do
			task.spawn(fn)
		end
		task.wait(CONFIG.HOLD_MIN)
		StealState.phase = "waitingRange"
		local alreadyInRange = distToAnimal(animalData) <= CONFIG.STEAL_RANGE
		local fired = false
		while true do
			local elapsed = tick() - StealState.startTime
			if elapsed > CONFIG.HOLD_MAX then break end
			if not prompt.Parent then break end
			if distToAnimal(animalData) <= CONFIG.STEAL_RANGE then
				if not alreadyInRange then task.wait(CONFIG.ENTRY_DELAY) end
				for _, fn in ipairs(data.triggerCallbacks) do
					task.spawn(fn)
				end
				fired = true
				break
			end
			task.wait()
		end
		if fired then
			StealState.totalSteals = StealState.totalSteals + 1
			StealState.lastResult = "Stole " .. label
			StealState.phase = "success"
		else
			StealState.failedSteals = StealState.failedSteals + 1
			StealState.lastResult = "Missed window: " .. label
			StealState.phase = "failed"
		end
		StealState.active = false
		StealState.lastResultTime = tick()
		task.wait(CONFIG.COOLDOWN)
		data.ready = true
	end)
	return true
end

local function attemptSteal(prompt, animalData)
	if not prompt or not prompt.Parent then return false end
	buildStealCallbacks(prompt)
	if not InternalStealCache[prompt] then return false end
	return executeStealAsync(prompt, animalData)
end

local function scanAllPlots()
	local newCache = {}
	for _, plot in ipairs(plots:GetChildren()) do
		local cache = getPlotChannelData(plot.Name)
		if not cache then continue end
		local animalList = cache.AnimalList
		if typeof(animalList) ~= "table" then continue end
		for slot, animalData in pairs(animalList) do
			if type(animalData) == "table" then
				local animalName = animalData.Index
				local animalInfo = AnimalsData[animalName]
				if not animalInfo then continue end
				table.insert(newCache, {
					name = animalInfo.DisplayName or animalName,
					plot = plot.Name,
					slot = tostring(slot),
					uid = plot.Name .. "_" .. tostring(slot)
				})
			end
		end
	end
	allAnimalsCache = newCache
	return #allAnimalsCache
end

function startAutoSteal()
	if stealConnection then return end
	stealConnection = RunService.Heartbeat:Connect(function()
		if not CONFIG.AUTO_STEAL_ENABLED then return end
		if StealState.active then return end
		local target = pickClosest()
		if not target then return end
		local prompt = PromptMemoryCache[target.uid]
		if not prompt or not prompt.Parent then
			prompt = findProximityPromptForAnimal(target)
		end
		if prompt then
			attemptSteal(prompt, target)
		end
	end)
end

function stopAutoSteal()
	if not stealConnection then return end
	stealConnection:Disconnect()
	stealConnection = nil
	StealState.active = false
	StealState.phase = "idle"
end

local CoreGui = game:GetService("CoreGui")

local oldGui = CoreGui:FindFirstChild("CandyStealBar")
if oldGui then oldGui:Destroy() end

local gui2 = Instance.new("ScreenGui")
gui2.Name = "CandyStealBar"
gui2.ResetOnSpawn = false
gui2.DisplayOrder = 10
gui2.IgnoreGuiInset = true
gui2.Parent = CoreGui

local UIS = game:GetService("UserInputService")

local dragging = false
local dragInput = nil
local dragStart
local startPos

-- Lock UI también bloquea el arrastre de esta barra.
local function finishStealBarDrag()
    dragging = false
    dragInput = nil
end
cancelStealBarDrag = finishStealBarDrag

-- ============================================================
-- BARRA DE ROBO CT DUELS (BLANCO) CON BOTÓN ÚNICO TOGGLE + RADIUS
-- ============================================================
local pbFrame = Instance.new("Frame", gui2)
pbFrame.Size = UDim2.new(0, 300, 0, 52)
pbFrame.Position = UDim2.new(0.5, -150, 0, 72)
pbFrame.BackgroundColor3 = Color3.fromRGB(5, 15, 35)
pbFrame.BorderSizePixel = 0
pbFrame.ClipsDescendants = false
pbFrame.Active = false
pbFrame.ZIndex = -1
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 16)

-- Zona superior dedicada al arrastre; no cubre el botón START/STOP.
local stealBarDragHandle = Instance.new("TextButton", pbFrame)
stealBarDragHandle.Name = "DragHandle"
stealBarDragHandle.Size = UDim2.new(1, -72, 0, 28)
stealBarDragHandle.Position = UDim2.new(0, 0, 0, 0)
stealBarDragHandle.BackgroundTransparency = 1
stealBarDragHandle.BorderSizePixel = 0
stealBarDragHandle.Text = ""
stealBarDragHandle.AutoButtonColor = false
stealBarDragHandle.Active = true
stealBarDragHandle.ZIndex = 5

stealBarDragHandle.InputBegan:Connect(function(input)
    if uiLocked then return end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end

    dragging = true
    dragInput = input.UserInputType == Enum.UserInputType.Touch and input or nil
    dragStart = input.Position
    startPos = pbFrame.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            finishStealBarDrag()
        end
    end)
end)

stealBarDragHandle.InputChanged:Connect(function(input)
    if uiLocked then
        finishStealBarDrag()
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if uiLocked then
        finishStealBarDrag()
        return
    end
    if not dragging then return end
    if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

    local delta = input.Position - dragStart
    pbFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        finishStealBarDrag()
    end
end)

-- Imagen decorativa de la barra; no captura entradas para conservar el arrastre.
local stealBarImage = Instance.new("ImageLabel", pbFrame)
stealBarImage.Name = "AutoStealImage"
stealBarImage.Size = UDim2.fromScale(1, 1)
stealBarImage.Position = UDim2.fromScale(0, 0)
stealBarImage.BackgroundTransparency = 1
stealBarImage.BorderSizePixel = 0
stealBarImage.Image = "rbxassetid://134700069294475"
stealBarImage.ImageTransparency = 0.48
stealBarImage.ScaleType = Enum.ScaleType.Crop
stealBarImage.Active = false
stealBarImage.Selectable = false
stealBarImage.ZIndex = 0
Instance.new("UICorner", stealBarImage).CornerRadius = UDim.new(0, 16)

local pbs = Instance.new("UIStroke", pbFrame)
pbs.Color = Color3.fromRGB(220, 50, 80)
pbs.Thickness = 1.4
pbs.Transparency = 0.1
local pbsGrad = Instance.new("UIGradient", pbs)
pbsGrad.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255, 220, 220))
pbsGrad.Rotation = 25

local progressStripe = Instance.new("Frame", pbFrame)
progressStripe.Size = UDim2.new(0, 4, 1, -18)
progressStripe.Position = UDim2.new(0, 8, 0, 9)
progressStripe.BackgroundColor3 = Color3.fromRGB(255,255,255)
progressStripe.BorderSizePixel = 0
progressStripe.ZIndex = 2
Instance.new("UICorner", progressStripe).CornerRadius = UDim.new(0, 8)

-- Pill del Status
local statusPill = Instance.new("Frame", pbFrame)
statusPill.Size = UDim2.new(0, 90, 0, 24)
statusPill.Position = UDim2.new(0, 20, 0, 7)
statusPill.BackgroundColor3 = Color3.fromRGB(8, 24, 55)
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 2
Instance.new("UICorner", statusPill).CornerRadius = UDim.new(0, 30)

local progressPillStroke = Instance.new("UIStroke", statusPill)
progressPillStroke.Color = Color3.fromRGB(220, 50, 80)
progressPillStroke.Thickness = 1
progressPillStroke.Transparency = 0.45

local progressDot = Instance.new("Frame", statusPill)
progressDot.Size = UDim2.new(0, 8, 0, 8)
progressDot.Position = UDim2.new(0, 8, 0.5, -4)
progressDot.BackgroundColor3 = Color3.fromRGB(255,255,255)
progressDot.BorderSizePixel = 0
progressDot.ZIndex = 2
Instance.new("UICorner", progressDot).CornerRadius = UDim.new(0, 10)

local progressDotGlow = Instance.new("UIStroke", progressDot)
progressDotGlow.Color = Color3.fromRGB(255,255,255)
progressDotGlow.Thickness = 2
progressDotGlow.Transparency = 0.4

local progressPct = Instance.new("TextLabel", statusPill)
progressPct.Size = UDim2.new(1, -20, 1, 0)
progressPct.Position = UDim2.new(0, 20, 0, 0)
progressPct.BackgroundTransparency = 1
progressPct.Text = (CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE")
progressPct.TextColor3 = Color3.fromRGB(255, 220, 220)
progressPct.Font = Enum.Font.GothamBlack
progressPct.TextSize = 10
progressPct.TextXAlignment = Enum.TextXAlignment.Left
progressPct.ZIndex = 2

local progressRadLbl = Instance.new("TextLabel", pbFrame)
progressRadLbl.Size = UDim2.new(0, 85, 0, 24)
progressRadLbl.Position = UDim2.new(0, 115, 0, 7)
progressRadLbl.BackgroundTransparency = 1
progressRadLbl.Text = "Radius: " .. tostring(CONFIG.STEAL_RANGE)
progressRadLbl.TextColor3 = Color3.fromRGB(255, 220, 220)
progressRadLbl.Font = Enum.Font.GothamBlack
progressRadLbl.TextSize = 10
progressRadLbl.TextXAlignment = Enum.TextXAlignment.Center
progressRadLbl.ZIndex = 2

local toggleBtn = Instance.new("TextButton", pbFrame)
toggleBtn.Size = UDim2.new(0, 50, 0, 24)
toggleBtn.Position = UDim2.new(1, -65, 0, 7)
toggleBtn.BorderSizePixel = 0
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 11
toggleBtn.ZIndex = 6
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

local btnStroke = Instance.new("UIStroke", toggleBtn)
btnStroke.Thickness = 1.2
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local btnGrad = Instance.new("UIGradient", toggleBtn)
btnGrad.Rotation = 90

local function updateButtonUI(enabled)
    if enabled then
        toggleBtn.Text = "STOP"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 95, 255)
        toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        btnStroke.Color = Color3.fromRGB(220, 50, 80)
        btnGrad.Color = ColorSequence.new(Color3.fromRGB(0, 130, 255), Color3.fromRGB(0, 60, 180))
        
        progressPct.Text = "READY"
        progressPct.TextColor3 = Color3.fromRGB(255, 220, 220)
    else
        toggleBtn.Text = "START"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 65, 170)
        toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
        btnStroke.Color = Color3.fromRGB(0, 70, 180)
        btnGrad.Color = ColorSequence.new(Color3.fromRGB(0, 55, 145), Color3.fromRGB(5, 15, 35))
        
        progressPct.Text = "IDLE"
        progressPct.TextColor3 = Color3.fromRGB(255, 220, 220)
    end
end

toggleBtn.Activated:Connect(function()
    CONFIG.AUTO_STEAL_ENABLED = not CONFIG.AUTO_STEAL_ENABLED
    
    if CONFIG.AUTO_STEAL_ENABLED then
        pcall(startAutoSteal)
    else
        pcall(stopAutoSteal)
    end
    
    updateButtonUI(CONFIG.AUTO_STEAL_ENABLED)
end)

updateButtonUI(CONFIG.AUTO_STEAL_ENABLED)

local pbg = Instance.new("Frame", pbFrame)
pbg.Size = UDim2.new(1, -40, 0, 9)
pbg.Position = UDim2.new(0, 20, 1, -15)
pbg.BackgroundColor3 = Color3.fromRGB(8,10,18)
pbg.BorderSizePixel = 0
pbg.ZIndex = 2
Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 30)

local pbgStroke = Instance.new("UIStroke", pbg)
pbgStroke.Color = Color3.fromRGB(70, 160, 255)
pbgStroke.Thickness = 1
pbgStroke.Transparency = 0.45

local progressFill = Instance.new("Frame", pbg)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(0, 95, 255)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 2
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 30)

local fillGrad = Instance.new("UIGradient", progressFill)
fillGrad.Color = ColorSequence.new(Color3.fromRGB(0, 130, 255), Color3.fromRGB(0, 60, 180))
fillGrad.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.55),
	NumberSequenceKeypoint.new(1, 0)
})

local progressLastFill = 0

local function updateStealBar(dt)
	local recent = StealState.lastResultTime > 0 and (tick() - StealState.lastResultTime) < 1.4
	local targetPct = 0
	local targetColor = Color3.fromRGB(255,255,255)
	local status = CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE"

	if StealState.active then
		targetPct = math.clamp((tick() - StealState.startTime) / CONFIG.HOLD_MAX, 0, 1)
		if StealState.phase == "waitingRange" then
			status = "WAITING"
			targetColor = Color3.fromRGB(70, 160, 255)
		else
			status = "STEALING"
			targetColor = Color3.fromRGB(255, 220, 220)
		end
	elseif recent then
		local success = StealState.phase == "success" or string.find(StealState.lastResult, "Stole") ~= nil
		targetPct = 1
		status = success and "SUCCESS" or "FAILED"
		targetColor = success and Color3.fromRGB(255, 220, 220) or Color3.fromRGB(70, 160, 255)
	elseif CONFIG.AUTO_STEAL_ENABLED then
		local scan = math.sin(tick() * 2.2) * 0.5 + 0.5
		targetPct = scan * 0.75
		status = "SCAN"
		targetColor = Color3.fromRGB(255,255,255)
	end

	progressLastFill = progressLastFill + (targetPct - progressLastFill) * math.min((dt or 0.016) * 14, 1)
	progressFill.Size = UDim2.new(progressLastFill, 0, 1, 0)
	progressFill.BackgroundColor3 = progressFill.BackgroundColor3:Lerp(targetColor, math.min((dt or 0.016) * 8, 1))
	progressPct.Text = status
	progressPct.TextColor3 = targetColor
end

RunService.RenderStepped:Connect(updateStealBar)

task.spawn(function()
	if startAutoStealSync() then
		scanAllPlots()
		while task.wait(5) do
			scanAllPlots()
		end
	end
end)

CONFIG.AUTO_STEAL_ENABLED = true
startAutoSteal()
updateButtonUI(true)

print("✅ Auto Steal ACTIVADO (Bless.vs style)")

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- SECCIÓN 12: PERSISTENCIA (SAVE/LOAD) CON AUTO CARRY Y AUTO STEAL
saveConfig = function(btn)
    if State._configLoading or not State._configLoaded then
        State._saveAfterLoad = true
        return false
    end

    if State._configLoadFailed and not btn then
        return false
    end

    if State._saveInProgress then
        State._saveQueued = true
        return false
    end

    State._saveInProgress = true

    local function keySnapshot(entry)
        return {
            kb = entry and entry.kb and entry.kb.Name or nil,
            gp = entry and entry.gp and entry.gp.Name or nil,
        }
    end

    local function positionSnapshot(guiObject)
        if not guiObject then return nil end
        local ok, p = pcall(function() return guiObject.Position end)
        if not ok or not p then return nil end
        return {
            xs = p.X.Scale,
            xo = p.X.Offset,
            ys = p.Y.Scale,
            yo = p.Y.Offset,
        }
    end

    local savedStealRadius = Steal.StealRadius
    local savedAutoStealEnabled = Steal.AutoStealEnabled
    if CONFIG then
        if type(CONFIG.STEAL_RANGE) == "number" then
            savedStealRadius = CONFIG.STEAL_RANGE
        end
        if CONFIG.AUTO_STEAL_ENABLED ~= nil then
            savedAutoStealEnabled = CONFIG.AUTO_STEAL_ENABLED == true
        end
    end

    local cfg = {
        configVersion = 8,

        normalSpeed = NS,
        carrySpeed = CS,
        profileLaggerNormalSpeed = State.profileLaggerNormalSpeed,
        profileLaggerCarrySpeed = State.profileLaggerCarrySpeed,
        speedProfile = State.speedProfile,
        laggerSpeed = LS,
        laggerCarrySpeed = LS2,
        stealRadius = savedStealRadius,
        stealDuration = Steal.StealDuration,

        uiScale = uiScaleValue,
        backgroundAssetId = State.backgroundAssetId,
        buttonsSize = State.buttonsSizeValue,
        uiLocked = uiLocked,
        editMode = editModeEnabled,

        autoLeftKey = keySnapshot(KB.AutoLeft),
        autoRightKey = keySnapshot(KB.AutoRight),
        dropKey = keySnapshot(KB.Drop),
        tpDownKey = keySnapshot(KB.TPDown),
        autoBatKey = keySnapshot(KB.AutoBat),
        autoBatV2Key = keySnapshot(KB.AutoBatV2),
        instaResetKey = keySnapshot(KB.InstaReset),
        tpBatKey = keySnapshot(KB.TPBat),
        speedKey = keySnapshot(KB.Speed),
        laggerKey = keySnapshot(KB.Lagger),

        infJump = State.infJumpEnabled,
        superJump = State.superJumpEnabled,
        antiRagdoll = State.antiRagdollEnabled,
        fpsBoost = State.fpsBoostEnabled,
        medusaCounter = State.medusaCounterEnabled,
        batCounter = State.batCounterEnabled,
        autoStealEnabled = savedAutoStealEnabled,
        unwalkEnabled = State.unwalkEnabled,
        desyncEnabled = State.desyncEnabled,
        autoSwing = State.autoSwingEnabled,
        autoBatToggled = State.autoBatToggled,
        autoBatV2Toggled = State.autoBatV2Enabled,
        tpBatEnabled = State.tpBatEnabled,
        stretchRez = State.stretchRezEnabled,
        removeAccessories = State.removeAccessoriesEnabled,
        antiLag = State.antiLagEnabled,
        darkMode = State.darkModeEnabled,
        skyStyle = State.skyStyle,
        neonWeather = neonWeatherEnabled,
        bodyLockEnabled = bodyLockEnabled,
        bodyLockRange = bodyLockRange,
        accessoryPack = currentAccessoryPack,
        musicEnabled = musicEnabled,
        animationPack = animationPackName,
        selectedIntroMusic = State.selectedIntroMusic,
        autoTPDown = autoTPDownEnabled,
        autoTPDownHeight = autoTPDownHeight,

        speedToggled = State.speedToggled,
        laggerMode = State.laggerToggled,
        laggerPhase = laggerPhase,

        linieEnabled = State.linieEnabled,
        nuevaAnimacion = State.nuevaAnimacionEnabled,
        instaReset = State.instaResetEnabled,
        instaResetVisible = btnInstaReset and btnInstaReset.Visible or nil,
        hideButtons = State.hideButtonsEnabled,

        autoCarryEnabled = State.autoCarryEnabled,

        batV1Speed = State.batV1Speed,
        batV2Speed = State.batV2Speed,

        panelPos = positionSnapshot(MobilePanel),
        mobileButtonPositions = (function()
            local positions = {}
            for name, mobileBtn in pairs(mobileButtonsByName) do
                positions[name] = positionSnapshot(mobileBtn)
            end
            return positions
        end)(),
        mainPos = positionSnapshot(main),
        miniPos = positionSnapshot(mini),
        pbPos = positionSnapshot(pbFrame),
        batV2Pos = positionSnapshot(btnBatV2),
        instaResetPos = positionSnapshot(btnInstaReset),
        autoStealBarPos = positionSnapshot(frame),
    }

    local encodeOk, encoded = pcall(function()
        return HttpService:JSONEncode(cfg)
    end)

    local saved = false
    if encodeOk and encoded then
        if not btn and encoded == State._lastConfigJson then
            State._configDirty = false
            State._saveInProgress = false
            State._saveQueued = false
            return true
        end

        local atomicOk, atomicResult, atomicErr = pcall(function()
            return State._atomicJsonSave(
                CONFIG_FILE,
                State._configBackupFile,
                State._configTempFile,
                encoded
            )
        end)

        saved = atomicOk and atomicResult == true
        if saved then
            State._lastConfigJson = encoded
            State._lastSaveError = nil
            State._configLoadFailed = false
            State._allowInitialConfigCreation = false

            if State.savePositionBackup then pcall(State.savePositionBackup) end

            State._configDirty = false
        else
            State._lastConfigJson = nil
            State._lastSaveError = tostring((atomicOk and atomicErr) or atomicResult or "No se pudo escribir la configuración")
            warn("[CT Duels AUTO SAVE] " .. State._lastSaveError)
        end
    else
        State._lastSaveError = "No se pudo convertir la configuración a JSON"
    end

    State._saveInProgress = false

    if btn and btn.Parent then
        local previousText = btn.Text
        btn.Text = saved and "Saved!" or "Failed!"
        task.delay(1.5, function()
            if btn and btn.Parent then btn.Text = previousText end
        end)
    end

    if State._saveQueued then
        State._saveQueued = false
        if State.requestConfigSave then State.requestConfigSave() end
    end

    return saved
end

loadConfig = function()
    local function readConfigFile(path)
        local decoded, raw = State._readValidJsonFile(path)
        if type(decoded) ~= "table" then return nil, raw end
        return decoded, raw
    end

    local mainCfg, mainRaw = readConfigFile(CONFIG_FILE)
    local tempCfg, tempRaw = readConfigFile(State._configTempFile)
    local backupCfg, backupRaw = readConfigFile(State._configBackupFile)
    local legacyCfg, legacyRaw = readConfigFile(State._legacyConfigFile)
    local legacyTempCfg, legacyTempRaw = readConfigFile(State._legacyConfigTempFile)
    local legacyBackupCfg, legacyBackupRaw = readConfigFile(State._legacyConfigBackupFile)

    local cfg, raw = nil, nil
    local loadedFromBackup = false
    local loadedFromLegacy = false
    local loadedFromTemp = false

    if type(tempCfg) == "table" and (type(mainCfg) ~= "table" or tempRaw ~= mainRaw) then
        cfg, raw = tempCfg, tempRaw
        loadedFromTemp = true
    elseif type(mainCfg) == "table" then
        cfg, raw = mainCfg, mainRaw
    elseif type(backupCfg) == "table" then
        cfg, raw = backupCfg, backupRaw
        loadedFromBackup = true
    elseif type(legacyTempCfg) == "table" and (type(legacyCfg) ~= "table" or legacyTempRaw ~= legacyRaw) then
        cfg, raw = legacyTempCfg, legacyTempRaw
        loadedFromLegacy = true
        loadedFromTemp = true
    elseif type(legacyCfg) == "table" then
        cfg, raw = legacyCfg, legacyRaw
        loadedFromLegacy = true
    elseif type(legacyBackupCfg) == "table" then
        cfg, raw = legacyBackupCfg, legacyBackupRaw
        loadedFromLegacy = true
        loadedFromBackup = true
    end

    local hadAnyConfigFile = false
    for _, path in ipairs({
        CONFIG_FILE,
        State._configTempFile,
        State._configBackupFile,
        State._legacyConfigFile,
        State._legacyConfigTempFile,
        State._legacyConfigBackupFile,
    }) do
        local exists = false
        pcall(function() exists = _isfile(path) end)
        if exists then hadAnyConfigFile = true break end
    end

    if not cfg then
        State._configLoaded = true
        State._configLoadFailed = hadAnyConfigFile
        State._allowInitialConfigCreation = not hadAnyConfigFile
        State._saveAfterLoad = false
        State._lastSaveError = hadAnyConfigFile and "Se encontraron configuraciones dañadas; no se sobrescribieron" or nil
        if State.loadPositionBackup then pcall(State.loadPositionBackup) end
        return false
    end

    State._configLoading = true
    State._configLoadFailed = false
    State._allowInitialConfigCreation = false

    local applyOk = pcall(function()
        if type(cfg.normalSpeed) == "number" then
            NS = cfg.normalSpeed
            if normalBox then normalBox.Text = tostring(NS) end
        end
        if type(cfg.carrySpeed) == "number" then
            CS = cfg.carrySpeed
            if carryBox then carryBox.Text = tostring(CS) end
        end
        if type(cfg.profileLaggerNormalSpeed) == "number" then
            State.profileLaggerNormalSpeed = cfg.profileLaggerNormalSpeed
        end
        if type(cfg.profileLaggerCarrySpeed) == "number" then
            State.profileLaggerCarrySpeed = cfg.profileLaggerCarrySpeed
        end
        if type(cfg.laggerSpeed) == "number" then
            LS = cfg.laggerSpeed
            if laggerBox then laggerBox.Text = tostring(LS) end
        end
        if type(cfg.laggerCarrySpeed) == "number" then
            LS2 = cfg.laggerCarrySpeed
            if laggerBox2 then laggerBox2.Text = tostring(LS2) end
        end

        if type(cfg.uiScale) == "number" then
            uiScaleValue = math.clamp(math.floor(cfg.uiScale + 0.5), 50, 150)
            if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
            if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
        end

        if cfg.backgroundAssetId and State.applyBackgroundImage then
            State.applyBackgroundImage(cfg.backgroundAssetId, false)
        elseif State.applyBackgroundImage then
            State.applyBackgroundImage(State.backgroundAssetId, false)
        end

        if type(cfg.buttonsSize) == "number" then
            State.buttonsSizeValue = math.clamp(math.floor(cfg.buttonsSize + 0.5), 0, 100)
        end
        applyMobileButtonsSize(State.buttonsSizeValue)
        if buttonsSizeBox then buttonsSizeBox.Text = tostring(State.buttonsSizeValue) end

        if cfg.uiLocked ~= nil then
            uiLocked = cfg.uiLocked == true
            if setLockUIVisual then setLockUIVisual(uiLocked) end
        end
        if cfg.editMode ~= nil then
            editModeEnabled = cfg.editMode == true
            if setEditModeVisual then setEditModeVisual(editModeEnabled) end
        end


        if cfg.selectedIntroMusic ~= nil then
            State.selectedIntroMusic = cfg.selectedIntroMusic
            if getgenv and getgenv().FEARV2MusicBtn then
                getgenv().FEARV2MusicBtn.Text = "Music " .. tostring(State.selectedIntroMusic)
            end
        end
        if type(cfg.musicEnabled) == "table" then
            musicEnabled = cfg.musicEnabled
        end
        if type(cfg.animationPack) == "string" then
            animationPackName = cfg.animationPack
        end

        if type(cfg.autoTPDownHeight) == "number" then
            autoTPDownHeight = math.clamp(cfg.autoTPDownHeight, 0, 500)
        end
        if cfg.autoTPDown ~= nil then
            autoTPDownEnabled = cfg.autoTPDown == true
            if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
            if autoTPDownEnabled then startAutoTPDown() else stopAutoTPDown() end
        end

        local savedRadius = cfg.stealRadius or cfg.grabRadius
        if savedRadius == 61 or savedRadius == 63 then
            savedRadius = 10
        end
        if type(savedRadius) == "number" then
            Steal.StealRadius = savedRadius
            if progressRadLbl then progressRadLbl.Text = "Radius: " .. tostring(savedRadius) end
            if radValBtn then radValBtn.Text = tostring(savedRadius) end
            if radBox then radBox.Text = tostring(savedRadius) end
            if CONFIG then CONFIG.STEAL_RANGE = savedRadius end
        end
        if type(cfg.stealDuration) == "number" then
            Steal.StealDuration = cfg.stealDuration
            if durValBtn then durValBtn.Text = tostring(Steal.StealDuration) end
        end

        local function loadKey(entry, data)
            if not entry or type(data) ~= "table" then return end
            entry.kb = nil
            entry.gp = nil
            if data.kb and Enum.KeyCode[data.kb] then entry.kb = Enum.KeyCode[data.kb] end
            if data.gp and Enum.KeyCode[data.gp] then entry.gp = Enum.KeyCode[data.gp] end

            if State._bindButtons and State._bindButtons[entry] then
                State._bindButtons[entry].Text =
                    entry.gp and ("GP:" .. entry.gp.Name)
                    or (entry.kb and entry.kb.Name or "None")
            end
        end

        loadKey(KB.AutoLeft, cfg.autoLeftKey)
        loadKey(KB.AutoRight, cfg.autoRightKey)
        loadKey(KB.Drop, cfg.dropKey)
        loadKey(KB.TPDown, cfg.tpDownKey)
        loadKey(KB.AutoBat, cfg.autoBatKey)
        loadKey(KB.AutoBatV2, cfg.autoBatV2Key)
        loadKey(KB.InstaReset, cfg.instaResetKey)
        loadKey(KB.TPBat, cfg.tpBatKey)
        loadKey(KB.Speed, cfg.speedKey)
        loadKey(KB.Lagger, cfg.laggerKey)

        if cfg.infJump ~= nil then
            State.infJumpEnabled = cfg.infJump == true
            if setInfJump then setInfJump(State.infJumpEnabled) end
        end
        if cfg.superJump ~= nil then
            State.superJumpEnabled = cfg.superJump == true
            if setSuperJump then setSuperJump(State.superJumpEnabled) end
        end
        if cfg.antiRagdoll ~= nil then
            State.antiRagdollEnabled = cfg.antiRagdoll == true
            if setAntiRag then setAntiRag(State.antiRagdollEnabled) end
            if State.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
        end
        if cfg.fpsBoost ~= nil then
            State.fpsBoostEnabled = cfg.fpsBoost == true
            if setFps then setFps(State.fpsBoostEnabled) end
            if State.fpsBoostEnabled then pcall(applyFPSBoost) end
        end
        if cfg.medusaCounter ~= nil then
            State.medusaCounterEnabled = cfg.medusaCounter == true
            if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
            if State.medusaCounterEnabled then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        end
        if cfg.batCounter ~= nil then
            State.batCounterEnabled = cfg.batCounter == true
            if setBatCounter then setBatCounter(State.batCounterEnabled) end
            if State.batCounterEnabled then startBatCounter() else stopBatCounter() end
        end
        if cfg.autoStealEnabled ~= nil then
            local autoStealOn = cfg.autoStealEnabled == true
            Steal.AutoStealEnabled = autoStealOn
            if CONFIG then CONFIG.AUTO_STEAL_ENABLED = autoStealOn end
            if setAutoGrab then setAutoGrab(autoStealOn) end

            if progressPct then progressPct.Text = autoStealOn and "READY" or "IDLE" end
            if toggleBtn then
                if autoStealOn then
                    toggleBtn.Text = "STOP"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 95, 255)
                    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
                    btnStroke.Color = Color3.fromRGB(220, 50, 80)
                    btnGrad.Color = ColorSequence.new(Color3.fromRGB(0, 130, 255), Color3.fromRGB(0, 60, 180))
                else
                    toggleBtn.Text = "START"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 65, 170)
                    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
                    btnStroke.Color = Color3.fromRGB(0, 70, 180)
                    btnGrad.Color = ColorSequence.new(Color3.fromRGB(0, 55, 145), Color3.fromRGB(5, 15, 35))
                end
            end

            if autoStealOn then pcall(startAutoSteal) else pcall(stopAutoSteal) end
        end
        if cfg.autoSwing ~= nil then
            State.autoSwingEnabled = cfg.autoSwing == true
            if setAutoSwingVisual then setAutoSwingVisual(State.autoSwingEnabled) end
        end
        if cfg.unwalkEnabled ~= nil then
            State.unwalkEnabled = cfg.unwalkEnabled == true
            if setUnwalkToggle then setUnwalkToggle(State.unwalkEnabled) end
            if State.unwalkEnabled then startUnwalk() else stopUnwalk() end
        end

        if cfg.stretchRez ~= nil and setStretchRez then
            State.stretchRezEnabled = cfg.stretchRez == true
            setStretchRez(State.stretchRezEnabled)
        end
        if cfg.removeAccessories ~= nil and setRemoveAccessories then
            State.removeAccessoriesEnabled = cfg.removeAccessories == true
            setRemoveAccessories(State.removeAccessoriesEnabled)
        end
        if cfg.antiLag ~= nil and setAntiLag then
            State.antiLagEnabled = cfg.antiLag == true
            setAntiLag(State.antiLagEnabled)
        end

        if cfg.skyStyle ~= nil and setSkyStyle then
            setSkyStyle(cfg.skyStyle)
        elseif cfg.darkMode ~= nil and setDarkMode then
            setDarkMode(cfg.darkMode == true)
        end

        
		if cfg.neonWeather ~= nil then
			neonWeatherEnabled = cfg.neonWeather == true
			task.defer(function() toggleNeonWeather(neonWeatherEnabled) end)
		end
		if cfg.bodyLockRange ~= nil then
			bodyLockRange = math.clamp(tonumber(cfg.bodyLockRange) or 20, 5, 200)
		end
		if cfg.bodyLockEnabled ~= nil then
			bodyLockEnabled = cfg.bodyLockEnabled == true
			task.defer(function()
				if bodyLockEnabled then startBodyLock() end
				if bodyLockSetVisual then bodyLockSetVisual(bodyLockEnabled) end
			end)
		end
		if type(cfg.accessoryPack) == "string" then
			currentAccessoryPack = cfg.accessoryPack
			task.defer(function() applyAccessoryPack(currentAccessoryPack) end)
		end
if cfg.desyncEnabled ~= nil then
            State.desyncEnabled = cfg.desyncEnabled == true
            task.defer(function()
                if setDesync then setDesync(State.desyncEnabled) end
                if saDesync then saDesync(State.desyncEnabled) end
                if State.desyncEnabled and startDesyncSession then startDesyncSession() end
            end)
        end

        if cfg.linieEnabled ~= nil then
            State.linieEnabled = cfg.linieEnabled == true
            if setLinieVisual then setLinieVisual(State.linieEnabled) end
        end

        if cfg.nuevaAnimacion ~= nil then
            State.nuevaAnimacionEnabled = cfg.nuevaAnimacion == true
            if setAnimationPackVisual then
                setAnimationPackVisual(State.nuevaAnimacionEnabled and animationPackName or "Off", false)
            end
            if State.nuevaAnimacionEnabled then
                task.defer(startNuevaAnimacion)
            else
                task.defer(stopNuevaAnimacion)
            end
        end

        local savedInstaReset = cfg.instaReset
        if savedInstaReset == nil then savedInstaReset = cfg.instaResetEnabled end
        if savedInstaReset ~= nil then
            State.instaResetEnabled = savedInstaReset == true
            if setInstaToggleVisual then setInstaToggleVisual(State.instaResetEnabled) end
        end

        if cfg.hideButtons ~= nil then
            State.hideButtonsEnabled = cfg.hideButtons == true
            if setHideButtonsVisual then setHideButtonsVisual(State.hideButtonsEnabled) end

            local visible = not State.hideButtonsEnabled
            if MobilePanel then MobilePanel.Visible = visible end
            for _, mobileBtn in pairs(mobileButtonsByName) do
                if mobileBtn then mobileBtn.Visible = visible end
            end
            if btnBatV2 then btnBatV2.Visible = visible end
            if btnInstaReset then
                btnInstaReset.Visible = visible and (cfg.instaResetVisible ~= false)
            end
        elseif cfg.instaResetVisible ~= nil and btnInstaReset then
            btnInstaReset.Visible = cfg.instaResetVisible == true
        end

        State.speedProfile = cfg.speedProfile == "Lagger" and "Lagger" or "Normal"
        if State._refreshSpeedProfileVisual then State._refreshSpeedProfileVisual() end
        if normalBox then
            normalBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerNormalSpeed or NS)
        end
        if carryBox then
            carryBox.Text = tostring(State.speedProfile == "Lagger" and State.profileLaggerCarrySpeed or CS)
        end

        State.speedToggled = cfg.speedToggled == true
        State.laggerToggled = cfg.laggerMode == true
        laggerPhase = tonumber(cfg.laggerPhase) or (State.laggerToggled and 1 or 0)
        laggerPhase = math.clamp(math.floor(laggerPhase), 0, 2)

        if State.laggerToggled then
            State.speedToggled = false
        elseif laggerPhase ~= 0 then
            laggerPhase = 0
        end

        if mobileSpeedSetActive then mobileSpeedSetActive(State.speedToggled) end
        if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
        if modeValLbl then
            modeValLbl.Text =
                laggerPhase == 2 and "Lagger Carry"
                or (State.laggerToggled and "Lagger")
                or (State.speedToggled and (State.speedProfile == "Lagger" and ("Carry · " .. tostring(State.profileLaggerCarrySpeed)) or "Carry"))
                or (State.speedProfile == "Lagger" and ("Lagger · " .. tostring(State.profileLaggerNormalSpeed)) or "Normal")
        end

        State._setTPBatEnabled(cfg.tpBatEnabled == true)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
        if State._tpBatConfigSetVisual then State._tpBatConfigSetVisual(State.tpBatEnabled) end

        local autoBatV1 = cfg.autoBatToggled == true
        local autoBatV2 = cfg.autoBatV2Toggled == true
        if autoBatV1 then autoBatV2 = false end

        State.autoBatToggled = autoBatV1
        State.autoBatV2Enabled = autoBatV2

        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
        if State.autoBatToggled then
            task.defer(startBatAimbot)
        elseif State.autoBatV2Enabled then
            task.defer(startBatAimbotV2)
        else
            pcall(stopBatAimbot)
            if stopBatAimbotV2 then pcall(stopBatAimbotV2) end
        end

        if type(cfg.batV1Speed) == "number" then
            State.batV1Speed = cfg.batV1Speed
            if batV1SpeedBox then batV1SpeedBox.Text = tostring(State.batV1Speed) end
        end
        if type(cfg.batV2Speed) == "number" then
            State.batV2Speed = cfg.batV2Speed
            if batV2SpeedBox then batV2SpeedBox.Text = tostring(State.batV2Speed) end
        end

        if cfg.autoCarryEnabled ~= nil then
            State.autoCarryEnabled = cfg.autoCarryEnabled == true
            if State.autoCarrySetVisual then
                State.autoCarrySetVisual(State.autoCarryEnabled)
            end
        end

        local function restorePosition(guiObject, data)
            if guiObject and type(data) == "table" and data.xs ~= nil then
                guiObject.Position = UDim2.new(
                    data.xs,
                    data.xo or 0,
                    data.ys or 0,
                    data.yo or 0
                )
            end
        end

        local function restoreSavedPositions()
            restorePosition(main, cfg.mainPos)
            restorePosition(mini, cfg.miniPos)
            restorePosition(MobilePanel, cfg.panelPos)

            if type(cfg.mobileButtonPositions) == "table" then
                for name, positionData in pairs(cfg.mobileButtonPositions) do
                    restorePosition(mobileButtonsByName[name], positionData)
                end
            end

            restorePosition(pbFrame, cfg.pbPos)
            restorePosition(btnBatV2, cfg.batV2Pos)
            restorePosition(btnInstaReset, cfg.instaResetPos)
            restorePosition(frame, cfg.autoStealBarPos)
        end

        restoreSavedPositions()
        task.delay(0.7, restoreSavedPositions)
        task.delay(1.35, function()
            restoreSavedPositions()
            task.defer(function()
                if State.loadPositionBackup and not State._positionDirty then
                    pcall(State.loadPositionBackup)
                end
            end)
        end)
    end)

    State._configLoading = false
    State._configLoaded = true
    State._configLoadFailed = not applyOk

    if applyOk then
        State._lastConfigJson = raw
        State._lastSaveError = nil
        State._configDirty = false
    else
        State._lastSaveError = "La configuración se leyó, pero no se pudo aplicar; no será sobrescrita"
    end

    local pendingSave = State._saveAfterLoad
    State._saveAfterLoad = false

    if applyOk and (loadedFromBackup or loadedFromLegacy or loadedFromTemp or pendingSave) then
        if loadedFromBackup or loadedFromLegacy or loadedFromTemp then State._lastConfigJson = nil end
        State.requestConfigSave()
    end

    return applyOk
end

State._otherSpeedLabels = State._otherSpeedLabels or {}
State._otherSpeedConnections = State._otherSpeedConnections or {}

State._attachOtherSpeedBillboard = function(player, character)
    if not player or player == LP or not character then return end

    task.spawn(function()
        local head = character:WaitForChild("Head", 8)
        local root = character:WaitForChild("HumanoidRootPart", 8)
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
        if not head or not root or not humanoid then return end

        local old = head:FindFirstChild("CRYONOtherSpeedBB")
        if old then old:Destroy() end

        local bb = Instance.new("BillboardGui")
        bb.Name = "CRYONOtherSpeedBB"
        bb.Adornee = head
        bb.Parent = head
        bb.Size = UDim2.new(0, 180, 0, 36)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 1000

        local label = Instance.new("TextLabel")
        label.Name = "OtherSpeedBillLbl"
        label.Parent = bb
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "0.0"
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

        State._otherSpeedLabels[player] = {
            label = label,
            root = root,
            humanoid = humanoid,
        }
    end)
end

State._setupOtherPlayerBillboard = function(player)
    if not player or player == LP then return end

    local previousConnection = State._otherSpeedConnections[player]
    if previousConnection then
        pcall(function() previousConnection:Disconnect() end)
    end

    State._otherSpeedConnections[player] = player.CharacterAdded:Connect(function(character)
        State._attachOtherSpeedBillboard(player, character)
    end)

    if player.Character then
        State._attachOtherSpeedBillboard(player, player.Character)
    end
end

task.spawn(function()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        State._setupOtherPlayerBillboard(otherPlayer)
    end
end)

Players.PlayerAdded:Connect(function(player)
    State._setupOtherPlayerBillboard(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local connection = State._otherSpeedConnections[player]
    if connection then pcall(function() connection:Disconnect() end) end
    State._otherSpeedConnections[player] = nil
    State._otherSpeedLabels[player] = nil
end)

task.spawn(function()
    while gui and gui.Parent do
        for player, data in pairs(State._otherSpeedLabels) do
            local label = data and data.label
            local root = data and data.root
            local humanoid = data and data.humanoid

            if player.Parent and label and label.Parent and root and root.Parent and humanoid and humanoid.Health > 0 then
                local velocity = root.AssemblyLinearVelocity
                local horizontalSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                label.Text = string.format("%.1f", horizontalSpeed)
                label.Visible = true
            elseif label and label.Parent then
                label.Visible = false
            end
        end
        task.wait(0.08)
    end
end)

local h,hrp,speedLbl
local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5)
    hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end

    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("FEARV2MobileBB"); if oldBB then oldBB:Destroy() end
        local bb=Instance.new("BillboardGui")
        bb.Name="FEARV2MobileBB"
        bb.Adornee=head
        bb.Parent=head
        bb.Size=UDim2.new(0,200,0,28); bb.StudsOffset=Vector3.new(0,3.2,0); bb.AlwaysOnTop=true
        bb.Enabled=true
        bb.LightInfluence=0; bb.MaxDistance=1000

        local speedTitle=Instance.new("TextLabel",bb)
        speedTitle.Name="SpeedTitle"
        speedTitle.Size=UDim2.new(1,0,0,0); speedTitle.Position=UDim2.new(0,0,0,0)
        speedTitle.BackgroundTransparency=1; speedTitle.Text=""
        speedTitle.TextColor3=Color3.fromRGB(255,255,255)
        speedTitle.Font=Enum.Font.GothamBlack; speedTitle.TextSize=15
        speedTitle.TextStrokeTransparency=0; speedTitle.TextStrokeColor3=Color3.fromRGB(0,0,0)

        speedLbl=Instance.new("TextLabel",bb); speedLbl.Name="SpeedBillLbl"
        speedLbl.Size=UDim2.new(1,0,1,0); speedLbl.Position=UDim2.new(0,0,0,0)
        speedLbl.BackgroundTransparency=1; speedLbl.Text="Spd: 0.0"
        speedLbl.TextColor3=Color3.fromRGB(180,140,145)
        speedLbl.Font=Enum.Font.GothamBold; speedLbl.TextScaled=true
        speedLbl.TextStrokeTransparency=0; speedLbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
    end


    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end

    if State.medusaCounterEnabled then setupMedusaCounter(char) end

    if State.autoBatToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    if Steal.AutoStealEnabled then pcall(stopAutoSteal); task.wait(0.5); pcall(startAutoSteal) end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

-- ============================================================================
--  MOVIMIENTO AL ESTILO YSLEM + NEW ERA (ENCAPSULADO Y REINICIO AUTOMÁTICO)
-- ============================================================================
local moveConn = nil
local speedEnabled = true

-- ── Variables para el sistema Yslem ──────────────────────
local yslemActive = false
local batV2Active = false
local _lv = nil
local _lv_att = nil
local _ownerWatchConn = nil
local ownTimer = 0
local ownInterval = 0.8 + math.random() * 0.4

local function cleanLV()
    if _lv then pcall(function() _lv:Destroy() end); _lv = nil end
    if _lv_att then pcall(function() _lv_att:Destroy() end); _lv_att = nil end
end

local function setupLV(hrp)
    cleanLV()
    local att = Instance.new("Attachment", hrp)
    att.Name = "_YS_A"
    local lv = Instance.new("LinearVelocity", hrp)
    lv.Name = "_YS_LV"
    lv.Attachment0 = att
    lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
    lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
    lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
    lv.MaxForce = math.huge
    lv.PlaneVelocity = Vector2.zero
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    _lv_att = att
    _lv = lv
end

local function claimOwn(hrp)
    pcall(function() hrp:SetNetworkOwner(LP) end)
end

local function startOwnerWatch(hrp)
    if _ownerWatchConn then pcall(function() _ownerWatchConn:Disconnect() end) end
    _ownerWatchConn = hrp:GetPropertyChangedSignal("ReceiveAge"):Connect(function()
        if yslemActive then task.defer(function() claimOwn(hrp) end) end
    end)
end

local function updateYslemState()
    local shouldBeActive = speedEnabled 
        and not State.autoBatToggled 
        and not State.autoLeftEnabled 
        and not State.autoRightEnabled 
        and not batV2Active

    if shouldBeActive == yslemActive then return end

    yslemActive = shouldBeActive
    if yslemActive then
        if hrp then
            setupLV(hrp)
            claimOwn(hrp)
            startOwnerWatch(hrp)
        end
    else
        cleanLV()
        if _ownerWatchConn then pcall(function() _ownerWatchConn:Disconnect() end); _ownerWatchConn = nil end
    end
end

local function startMovement()
    if moveConn then moveConn:Disconnect(); moveConn = nil end
    moveConn = RunService.RenderStepped:Connect(function()
        if not (h and hrp) then return end
        if State._tpInProgress then return end

        updateYslemState()

        pcall(function()
            if speedLbl then
                local velocity = hrp.AssemblyLinearVelocity
                local hspd = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                speedLbl.Text = "Spd: " .. string.format("%.1f", hspd)
            end
        end)
    end)
end

local heartbeatConn = nil
local function startYslemHeartbeat()
    if heartbeatConn then return end
    heartbeatConn = RunService.Heartbeat:Connect(function(dt)
        if not yslemActive then
            if _lv then _lv.PlaneVelocity = Vector2.zero end
            return
        end

        if not (h and hrp) then return end

        ownTimer = ownTimer + dt
        if ownTimer >= ownInterval then
            claimOwn(hrp)
            ownTimer = 0
            ownInterval = 0.8 + math.random() * 0.4
        end

        if not _lv or _lv.Parent ~= hrp then setupLV(hrp) end

        local md = h.MoveDirection
        autoCarryInCarry = State.autoCarryEnabled and not State.laggerToggled and isLustPlayerStealing()
        if State.laggerToggled then
            spd = (laggerPhase == 2) and LS2 or LS
        elseif State.autoCarryEnabled then
            spd = autoCarryInCarry and getProfileCarrySpeed() or getProfileNormalSpeed()
        else
            spd = State.speedToggled and getProfileCarrySpeed() or getProfileNormalSpeed()
        end
        carryButtonState = autoCarryInCarry or (not State.autoCarryEnabled and State.speedToggled)
        if carryButtonState ~= lastCarryButtonState then
            lastCarryButtonState = carryButtonState
            if mobileSpeedSetActive then mobileSpeedSetActive(carryButtonState) end
        end
        if autoCarryInCarry ~= lastAutoCarryCarryState then
            lastAutoCarryCarryState = autoCarryInCarry
            if modeValLbl then modeValLbl.Text = autoCarryInCarry and "Carry" or "Normal" end
        end

        if spd == 0 then
            _lv.PlaneVelocity = Vector2.zero
        elseif md.Magnitude > 0 then
            local dir = md.Unit
            State.lastMoveDir = dir
            _lv.PlaneVelocity = Vector2.new(dir.X * spd, dir.Z * spd)
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
            local anyHeld = false
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then anyHeld = true; break end
            end
            if anyHeld then
                local dir = State.lastMoveDir
                _lv.PlaneVelocity = Vector2.new(dir.X * spd, dir.Z * spd)
            else
                _lv.PlaneVelocity = Vector2.zero
            end
        else
            _lv.PlaneVelocity = Vector2.zero
        end
    end)
end

local function stopMovement()
    if moveConn then moveConn:Disconnect(); moveConn = nil end
    if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn = nil end
    cleanLV()
    if _ownerWatchConn then pcall(function() _ownerWatchConn:Disconnect() end); _ownerWatchConn = nil end
    yslemActive = false
end

local function restartMovement()
    stopMovement()
    startMovement()
    startYslemHeartbeat()
end

startMovement()
startYslemHeartbeat()

local oldStartAutoLeft = startAutoLeft
local oldStopAutoLeft = stopAutoLeft
startAutoLeft = function()
    oldStartAutoLeft()
    restartMovement()
end
stopAutoLeft = function()
    oldStopAutoLeft()
    restartMovement()
end

local oldStartAutoRight = startAutoRight
local oldStopAutoRight = stopAutoRight
startAutoRight = function()
    oldStartAutoRight()
    restartMovement()
end
stopAutoRight = function()
    oldStopAutoRight()
    restartMovement()
end

local oldStartBat = startBatAimbot
local oldStopBat = stopBatAimbot
startBatAimbot = function()
    oldStartBat()
    restartMovement()
end
stopBatAimbot = function()
    oldStopBat()
    restartMovement()
end

local oldStartBatV2 = startBatAimbotV2
local oldStopBatV2 = stopBatAimbotV2
startBatAimbotV2 = function()
    batV2Active = true
    oldStartBatV2()
    restartMovement()
end
stopBatAimbotV2 = function()
    batV2Active = false
    oldStopBatV2()
    restartMovement()
end

-- ============================================================================

UIS.InputBegan:Connect(function(inp,gp)
    if _anyKeyListening then return end
    if gp and string.sub(inp.UserInputType.Name, 1, 7) ~= "Gamepad" then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end
    if kbMatch(KB.Speed,kc) then
        State.laggerToggled = false; laggerPhase = 0
        State.speedToggled = not State.speedToggled
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
    elseif kbMatch(KB.AutoLeft,kc) then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoLeftEnabled and State.tpBatEnabled then State._setTPBatEnabled(false) end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
    elseif kbMatch(KB.AutoRight,kc) then
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoRightEnabled and State.tpBatEnabled then State._setTPBatEnabled(false) end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
    elseif kbMatch(KB.Drop,kc) then
        if not State.dropActive then task.spawn(runDrop) end
    elseif kbMatch(KB.TPDown,kc) then
        task.spawn(doTpDown)
    elseif kbMatch(KB.Lagger,kc) then
        if laggerPhase == 1 then
            laggerPhase = 2; State.laggerToggled = true; State.speedToggled = false
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 2" end
        else
            laggerPhase = 1; State.laggerToggled = true; State.speedToggled = false
            if mobileSpeedSetActive then mobileSpeedSetActive(false) end
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger 1" end
        end
    elseif kbMatch(KB.AutoBat,kc) then
        State.autoBatToggled=not State.autoBatToggled
        if State.autoBatToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.tpBatEnabled then State._setTPBatEnabled(false) end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
    elseif kbMatch(KB.AutoBatV2,kc) then
        State.autoBatV2Enabled = not State.autoBatV2Enabled
        if State.autoBatV2Enabled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            if State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
            if State.tpBatEnabled then State._setTPBatEnabled(false) end
            if startBatAimbotV2 then startBatAimbotV2() end
        else
            if stopBatAimbotV2 then stopBatAimbotV2() end
        end
        if autoBatV2SetVisual then autoBatV2SetVisual(State.autoBatV2Enabled) end
    elseif kbMatch(KB.TPBat,kc) then
        State._setTPBatEnabled(not State.tpBatEnabled)
        if State._tpBatSetVisual then State._tpBatSetVisual(State.tpBatEnabled) end
    elseif kbMatch(KB.InstaReset,kc) then
        task.spawn(cursedInstaReset)
        if btnInstaReset and btnInstaReset.Parent then
            btnInstaReset:SetAttribute("PurpleFlash", true)
            task.delay(0.35, function() if btnInstaReset and btnInstaReset.Parent then btnInstaReset:SetAttribute("PurpleFlash", false) end end)
        end
        if setInstaToggleVisual then
            setInstaToggleVisual(true)
            task.delay(0.2, function() if setInstaToggleVisual then setInstaToggleVisual(false) end end)
        end
    end

    if State.requestConfigSave then State.requestConfigSave() end
end)

loadPresetsFile()

task.spawn(function()
    local lastPresetName = loadLastPresetName()
    if lastPresetName and lastPresetName ~= "" then
        for _, preset in ipairs(Presets) do
            if preset.name == lastPresetName then
                pcall(function() applyPreset(preset.data) end)
                break
            end
        end
    end

    task.wait(0.2)
    local loaded = loadConfig()

    task.wait(0.5)
    if not loaded and State._allowInitialConfigCreation then
        pcall(saveConfig)
    end
end)

Players.LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if parent == nil and State._configLoaded and not State._configLoadFailed then
        if State._configDirty then pcall(saveConfig) end
        if State._positionDirty and State.savePositionBackup then
            pcall(State.savePositionBackup)
        end
    end
end)

pcall(function()
    game:BindToClose(function()
        if State._configLoaded and not State._configLoadFailed then
            if State._configDirty then pcall(saveConfig) end
            if State._positionDirty and State.savePositionBackup then
                pcall(State.savePositionBackup)
            end
        end
    end)
end)

-- Auto Carry de Lust Hub integrado en el cálculo central de velocidad.

-- ===== NUEVAS CASILLAS PARA VELOCIDAD DE BAT V1 Y V2 =====
local batV1SpeedBox = rowInput("Speed", "Bat V1 Speed", "Velocidad de persecución", State.batV1Speed, function(v)
	if v > 0 and v <= 500 then
		State.batV1Speed = v
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

local batV2SpeedBox = rowInput("Speed", "Bat V2 Speed", "Velocidad de persecución", State.batV2Speed, function(v)
	if v > 0 and v <= 500 then
		State.batV2Speed = v
		if State.requestConfigSave then State.requestConfigSave() end
	end
end)

print("[🌀 CT Duels] Loaded (Bless.vs edition) con Auto Carry, Lagger y Velocidades de Bat configurables!")

end)()
end)()