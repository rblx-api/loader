-- ＳＭＫㅤＨＵＢ | by Davy...
-- v33: correção Bat Bypass, fundo sem afetar texto, TRIPA ON/OFF e Insta Reset S2.
-- [[ Hii! this file was cracked by SOURCE_CODE ]]
-- [[ TIMESTAMP: 08:59:18 ]]

-- Se omitió el prelude remoto opaco del archivo original.

-- No se ejecutan cargadores Lua remotos.

repeat task.wait() until game:IsLoaded()
Players = game:GetService("Players")
RunService = game:GetService("RunService")
UIS = game:GetService("UserInputService")
Lighting = game:GetService("Lighting")
HS = game:GetService("HttpService")
ReplicatedStorage = game:GetService("ReplicatedStorage")
TS_G = game:GetService("TweenService")
LP = Players.LocalPlayer
camera = workspace.CurrentCamera
CONFIG_FILE = "SMK_HUB.json"
DISCORD_INVITE_URL = "https://discord.gg/bgsmy5ReNh"

local function resolvePurenDuelsImage()
    -- Fondo gamer dibujado por la interfaz; no se carga ninguna imagen navideña.
    return nil
end

local function decoratePuren001Button(button)
    if not button or not button:IsA("TextButton") or button:GetAttribute("Puren001Neon") then return end
    if button.Text == "" or button.Visible == false then return end
    button:SetAttribute("Puren001Neon", true)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Puren001NeonStroke"
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = 1
    stroke.Transparency = 0.28
    stroke.Parent = button
end

local function addPuren001Decorations(parent, compact)
    if not parent then return end
    local watermark = Instance.new("TextLabel")
    watermark.Name = "Puren001Watermark"
    watermark.BackgroundTransparency = 1
    watermark.Text = "ＳＭＫㅤＨＵＢ"
    watermark.TextColor3 = Color3.fromRGB(0, 0, 0)
    watermark.TextTransparency = compact and 0.78 or 0.86
    watermark.Font = Enum.Font.GothamBlack
    watermark.TextScaled = true
    watermark.Size = UDim2.fromScale(0.62, 0.72)
    watermark.AnchorPoint = Vector2.new(0.5, 0.5)
    watermark.Position = UDim2.fromScale(0.5, 0.52)
    watermark.ZIndex = (parent.ZIndex or 1) + 1
    watermark.Active = false
    watermark.Parent = parent
    local outline = Instance.new("UIStroke")
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Thickness = compact and 1.2 or 2
    outline.Transparency = 0.2
    outline.Parent = watermark
end

HUB_COLOR_OPTIONS = {"original", "gold", "violet"}
DEFAULT_HUB_COLOR = HUB_COLOR_OPTIONS[1]


-- Identidade visual SMK: nome interno e interface unificados.
SMKBrandStyle = {
    text = "ＳＭＫ",
    fontMode = "original",
    labels = setmetatable({}, {__mode = "k"}),
    silver = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(155, 160, 170)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(225, 230, 240)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(225, 230, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(155, 160, 170)),
    }),
}
function SMKBrandStyle.apply(label)
    SMKBrandStyle.labels[label] = label:GetAttribute("SMKBaseTitleSize") or label.TextSize
    label:SetAttribute("SMKBaseTitleSize", SMKBrandStyle.labels[label])
    label.Font = SMKBrandStyle.fontMode == "balloon" and Enum.Font.FredokaOne or Enum.Font.GothamBlack
    label.TextSize = SMKBrandStyle.labels[label] * (SMKBrandStyle.fontMode == "balloon" and 1.2 or 1)
    label.TextWrapped = false
    local sizeLimit = label:FindFirstChild("SMKTitleSizeLimit") or Instance.new("UITextSizeConstraint", label)
    sizeLimit.Name = "SMKTitleSizeLimit"
    sizeLimit.MinTextSize = 10
    sizeLimit.MaxTextSize = label.TextSize
    label.TextScaled = true
    local gradient = label:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", label)
    gradient.Name = "SMKBrandShine"
    gradient.Color = SMKBrandStyle.silver
    gradient.Rotation = 0
    -- Brilho prateado estático: evita um tween infinito para cada título.
end

function SMKBrandStyle.setFont(mode, shouldSave)
    SMKBrandStyle.fontMode = mode == "balloon" and "balloon" or "original"
    for label, baseSize in pairs(SMKBrandStyle.labels) do
        if label.Parent then
            label.Font = SMKBrandStyle.fontMode == "balloon" and Enum.Font.FredokaOne or Enum.Font.GothamBlack
            label.TextSize = baseSize * (SMKBrandStyle.fontMode == "balloon" and 1.2 or 1)
            local limit = label:FindFirstChild("SMKTitleSizeLimit")
            if limit then limit.MaxTextSize = label.TextSize end
        end
    end
    if S and S.refreshHubFontSelection then S.refreshHubFontSelection() end
    if shouldSave and saveConfig then saveConfig() end
end

local function showIntro(onFinished)
--============================================================
-- ＳＭＫㅤＨＵＢ INTRO
-- YOUR ORIGINAL VERSION
-- RANDOM IMAGE + MUSIC + BEAT EFFECTS + SKIP
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local player = LP
local PlayerGui = player:WaitForChild("PlayerGui")

--============================================================
-- SETTINGS
--============================================================

local MUSIC_URL =
	"https://files.catbox.moe/qhpfe5.mp3"

local MUSIC_FILE =
	"ShadowVS_Music.mp3"

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
	"rbxassetid://129700697019613",
	"rbxassetid://108697485255882",
	"rbxassetid://71211662493854",
	"rbxassetid://118953269416540"
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
	"ＳＭＫㅤＨＵＢ"

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
	"DUELS"

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

	if type(onFinished) == "function" then
		task.defer(onFinished)
	end

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
		Enum.EasingDirection.InOut
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

local function clearOldSMKInterface()
    if type(_G._SMKBatBypassCleanup) == "function" then
        pcall(_G._SMKBatBypassCleanup)
        _G._SMKBatBypassCleanup = nil
    end
    local playerGui = LP:WaitForChild("PlayerGui")
    local roots = {playerGui}
    local coreOk, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if coreOk and coreGui then table.insert(roots, coreGui) end

    for _, root in ipairs(roots) do
        for _, guiName in ipairs({"SMK", "SMKStealHUD", "StealBarMovableSmall", "SMK_FloatingPanel", "FloatingModeMenu", "BrainrotIntroGui"}) do
            local oldGui = root:FindFirstChild(guiName)
            if oldGui then pcall(function() oldGui:Destroy() end) end
        end
    end

    local character = LP.Character
    local head = character and character:FindFirstChild("Head")
    local oldBillboard = head and head:FindFirstChild("SMKSpeedBB")
    if oldBillboard then oldBillboard:Destroy() end
end

clearOldSMKInterface()

removedAccessories = {}

local function removeCharacterAccessories()
    local char = LP.Character
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or (child:IsA("Model") and child:FindFirstChild("Handle")) then
            table.insert(removedAccessories, {parent = child.Parent, acc = child})
            child.Parent = nil
        end
    end
end

local function restoreAccessories()
    for _, item in ipairs(removedAccessories) do
        if item.acc and not item.acc.Parent then
            item.acc.Parent = item.parent
        end
    end
    removedAccessories = {}
end

local function safeWritefile(path, data) if type(writefile) == "function" then pcall(writefile, path, data) end end
local function safeReadfile(path) if type(readfile) == "function" then local ok, data = pcall(readfile, path) return ok and data or nil end return nil end
local function safeIsfile(path) if type(isfile) == "function" then local ok, res = pcall(isfile, path) return ok and res end return false end
local function safeSetfpscap(v) if type(setfpscap) == "function" then pcall(setfpscap, v) end end
local function safeSethiddenproperty(obj, prop, val) if type(sethiddenproperty) == "function" then pcall(sethiddenproperty, obj, prop, val) end end

S = {
    espEnabled = false, espPlayerCache = {players = {}, addConn = nil, remConn = nil, colorConn = nil, _colorAcc = 0}, setESPVisual = nil,
    NS = 70, CS = 45, LS = 22, LCS = 22,
    speedMode = false, laggerMode = 0,
    antiRagdollEnabled = false, antiBatEnabled = false, antiBatConnections = {}, antiBatHeartbeat = nil, antiBatCharacterConn = nil, medusaCounterEnabled = false,
    medusaDebounce = false, medusaLastUsed = 0, medusaConns = {}, MEDUSA_COOLDOWN = 25,
    unwalkEnabled = false,
    autoLeftEnabled = false, autoRightEnabled = false,
    autoLeftSetVisual = nil, autoRightSetVisual = nil,
    _btnAAL = nil, _bsAAL = nil, _l1AAL = nil, _l2AAL = nil,
    _btnAAR = nil, _bsAAR = nil, _l1AAR = nil, _l2AAR = nil,
    _btnBAT = nil, _bsBAT = nil, _l1BAT = nil, _l2BAT = nil,
    _setPButtonActive = nil, speedCounterLabel = nil, speedDiscordLabel = nil, speedLabelLastUpdate = 0,
    batBypassEnabled = false, setBatBypassVisual = nil,
    informationE01Enabled = true, setInformationE01Visual = nil,
    batAimbotEnabled = false, batAimbotSetVisual = nil, batAimbotConn = nil,
    tpBatEnabled = false, tpBatSetVisual = nil, tpBatConn = nil, tpBatHitCooldown = false,
    tpBatAntiDieConnections = {}, batTpEnabled = false, _smartBatTpDriving = false,
    autoSwingEnabled = true, autoBatEquippedThisRun = false,
    _autoBatTarget = nil, _autoBatLastScan = 0,
    resetAutoBatMotion = nil,
    batCounterEnabled = false, batCounterConn = nil, batCounterDebounce = false,
    setBatCounterVisual = nil,
    medusaSkinMode = "Off", medusaSkinSelectorLabel = nil,
    batSkinMode = "Off", batSkinSelectorLabel = nil, batSkinConnections = {},
    displaySkin = "Off", displaySkinSelectorLabel = nil, customSkinEnabled = false, _skinApplyToken = 0,
    fpsBoostEnabled = false,
    lockUIEnabled = false,
    mainMenuFrame = nil, miniToggleButton = nil, floatingPanelFrame = nil, floatingPanelGui = nil,
    _floatingButtonInfos = nil, _floatingFreeButtonLayer = nil, _floatingUpdateLayout = nil,
    mainGuiScaleObj = nil, floatingGuiScaleObj = nil,
    hubColor = DEFAULT_HUB_COLOR,
    optimizerMode = "standard", setTripaVisual = nil,
    _noclipTimer = 0, _fpsCount = 0, _lastFpsTime = tick(), currentFPS = 0,
    alConn = nil, arConn = nil, alPhase = 1, arPhase = 1,
    progressFill = nil, progressPct = nil, progressBarFrame = nil, topBarHUD = nil, stealHudCard = nil,
    stealActive = false,
    setLaggerVisual = nil, speedClk = nil, setFpsVisual = nil,
    setAntiRagVisual = nil, setMedusaVisual = nil,
    setUnwalkVisual = nil, setDarkVisual = nil, setInstaGrab = nil,
    normalBox = nil, carryBox = nil, laggerBox = nil,
    radInput = nil, setLockUI_Visual = nil, setHideOpiumButtons = nil,
    holdJumpEnabled = false, holdJumpConn = nil, setHoldJumpVisual = nil,
    antiDropEnabled = false, setAntiDropVisual = nil,
    antiDieEnabled = false, setAntiDieVisual = nil,
    stealDurationBox = nil,
    hudBgLabel = nil,
    hudBarPos = nil,
    dropBrainrotActive = false,
    dropMode = 1, -- Drakon: 1 = Fling, 2 = Jump Drop
    lastDropTime = 0,
    _dropSpeedMode = nil,
    _dropLaggerMode = nil,
    tpDownHeightTrigger = 20,
    Steal = {
        AutoStealEnabled = false, StealRadius = 61, StealDuration = 1.3,
        Data = {}, plotCache = {}, plotCacheTime = {}, cachedPrompts = {}, promptCacheTime = 0,
        isStealing = false, stealStartTime = nil, lastStealTick = 0,
    },
    KB = {
        DropBrainrot = {kb = Enum.KeyCode.X, gp = Enum.KeyCode.ButtonR2},
        AutoLeft = {kb = Enum.KeyCode.Z, gp = Enum.KeyCode.DPadLeft},
        AutoRight = {kb = Enum.KeyCode.C, gp = Enum.KeyCode.DPadRight},
        AutoBat = {kb = Enum.KeyCode.E, gp = Enum.KeyCode.ButtonY},
        BatBypass = {kb = Enum.KeyCode.V, gp = Enum.KeyCode.ButtonB},
        TPFlor = {kb = Enum.KeyCode.F, gp = Enum.KeyCode.ButtonA},
        GuiHide = {kb = Enum.KeyCode.LeftControl, gp = Enum.KeyCode.ButtonSelect},
        SpeedToggle = {kb = Enum.KeyCode.Q, gp = Enum.KeyCode.DPadUp},
        LaggerToggle = {kb = Enum.KeyCode.R, gp = Enum.KeyCode.DPadDown},
    },
    AP = {
        L1 = Vector3.new(-476.47, -6.28, 92.73), L2 = Vector3.new(-483.12, -4.95, 94.81),
        L_FACE = Vector3.new(-482.25, -4.96, 92.09),
        R1 = Vector3.new(-476.16, -6.52, 25.62), R2 = Vector3.new(-483.06, -5.03, 25.48),
        R_FACE = Vector3.new(-482.06, -6.93, 35.47),
    },
    Conns = {autoSteal = nil, antiRag = nil, anchor = {}, progress = nil},
    moveConn = nil, speedEnabled = true, h = nil, hrp = nil,
    lastMoveDir = Vector3.new(0,0,0),
    MOVE_KEYS = {
        [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
        [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
        [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
        [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
    },
    lockMobileButtons = false,
    editMobileButtons = false,
    mobileButtonStyle = "original",
    IS_TOUCH_DEVICE = UIS.TouchEnabled,
    IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled,
    phoneGuiScale = 0.72,
    phoneButtonsScale = 0.86,
    mobileButtonPositions = {},
    mobileButtonRefs = {},
    floatingFreeButtonPositions = {},
    CONFIG_FILE = CONFIG_FILE,
    _floatingButtons = {},
    BAT_HIT_RANGE = 16,
    _holdJumpCooldownUntil = 0,
    holdJumpPressed = false,
    holdJumpActive = false,
    _youtResetInProgress = false,
    antiFlingEnabled = false, setAntiFlingVisual = nil,
    bodyLockEnabled = false, bodyLockRange = 20, bodyLockConnection = nil, bodyLockSetVisual = nil,
    currentAnimPack = "Off", originalAnimPack = nil, animPackConnection = nil, animSelectorLabel = nil,
    antiLagEnabled = false, setAntiLagVisual = nil,
    vividGraphicsEnabled = false, vividEffects = {},
    skyTheme = "Off", skySelectorLabel = nil,
    krobloxMode = "Off", krobloxSelectorLabel = nil,
    stretchEnabled = false, stretchFOV = 120,
    origFOV = nil, stretchConn = nil, stretchFovConn = nil,
}

-- ===== PLAYER ESP (VX7 COMPOSITE: BOX + HIGHLIGHT + SPEED CARD + TRACERS) =====
PLAYER_ESP_COLOR = Color3.fromRGB(255, 255, 255)
PLAYER_ESP_FILL_TRANSPARENCY = 0.7
PLAYER_ESP_OUTLINE_TRANSPARENCY = 0.3
PLAYER_ESP_BIND_NAME = "SMK_VX7_PlayerESP"

local function ensurePlayerESPGui()
    local cache = S.espPlayerCache
    if cache.screenGui and cache.screenGui.Parent then return cache.screenGui end
    local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SMK_VX7_PlayerESP"
    screenGui.ResetOnSpawn = false
    screenGui.DisplayOrder = 998
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.Parent = playerGui
    cache.screenGui = screenGui
    return screenGui
end

local function removeESPHighlight(playerData)
    if playerData and playerData.highlight then
        pcall(function() playerData.highlight:Destroy() end)
        playerData.highlight = nil
    end
end

local function disconnectESPConnection(playerData, name)
    local connection = playerData and playerData[name]
    if connection then
        pcall(function() connection:Disconnect() end)
        playerData[name] = nil
    end
end

local function removeESPForPlayer(player)
    local cache = S.espPlayerCache
    local data = cache and cache.players[player]
    if not data then return end
    disconnectESPConnection(data, "charConn")
    disconnectESPConnection(data, "charRemovingConn")
    removeESPHighlight(data)
    for _, key in ipairs({"box", "infoFrame", "tracer"}) do
        if data[key] then pcall(function() data[key]:Destroy() end); data[key] = nil end
    end
    data.speedLabel = nil
    data.nameLabel = nil
    cache.players[player] = nil
end

local function clearESP()
    local cache = S.espPlayerCache
    if not cache then return end
    local players = {}
    for player in pairs(cache.players) do table.insert(players, player) end
    for _, player in ipairs(players) do removeESPForPlayer(player) end
end

local function createESPBox(parent)
    local box = Instance.new("Frame")
    box.Name = "VX7_ESPBox2D"
    box.BackgroundColor3 = PLAYER_ESP_COLOR
    box.BackgroundTransparency = 0.75
    box.BorderSizePixel = 0
    box.Visible = false
    box.ZIndex = 2
    box.Parent = parent
    local stroke = Instance.new("UIStroke")
    stroke.Color = PLAYER_ESP_COLOR
    stroke.Thickness = 1.5
    stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = box
    return box
end

local function createESPTracer(parent)
    local tracer = Instance.new("Frame")
    tracer.Name = "VX7_ESPTracer"
    tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    tracer.BackgroundColor3 = PLAYER_ESP_COLOR
    tracer.BackgroundTransparency = 0.1
    tracer.BorderSizePixel = 0
    tracer.Visible = false
    tracer.ZIndex = 1
    tracer.Parent = parent
    local stroke = Instance.new("UIStroke", tracer)
    stroke.Color = Color3.fromRGB(20, 20, 24)
    stroke.Thickness = 0.75
    stroke.Transparency = 0.25
    return tracer
end

local function updateESPTracer(tracer, camera, root)
    if not tracer then return end
    tracer.Visible = false
    if not camera or not root then return end
    local target, onScreen = camera:WorldToViewportPoint(root.Position)
    if not onScreen or target.Z <= 0 then return end
    local viewport = camera.ViewportSize
    local originX, originY = viewport.X * 0.5, viewport.Y - 8
    local dx, dy = target.X - originX, target.Y - originY
    local length = math.sqrt(dx * dx + dy * dy)
    if length ~= length or length == math.huge or length < 1 then return end
    tracer.Position = UDim2.fromOffset((originX + target.X) * 0.5, (originY + target.Y) * 0.5)
    tracer.Size = UDim2.fromOffset(length, 2)
    tracer.Rotation = math.deg(math.atan2(dy, dx))
    tracer.BackgroundColor3 = PLAYER_ESP_COLOR
    tracer.Visible = true
end

local function createESPInfoCard(parent, player)
    local root = Instance.new("Frame")
    root.Name = "VX7_EI_" .. tostring(player.UserId)
    root.Size = UDim2.fromOffset(174, 59)
    root.AnchorPoint = Vector2.new(0.5, 1)
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.Visible = false
    root.Parent = parent

    local avatarBack = Instance.new("Frame")
    avatarBack.Size = UDim2.fromOffset(34, 34)
    avatarBack.Position = UDim2.fromOffset(8, 3)
    avatarBack.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    avatarBack.BorderSizePixel = 0
    avatarBack.Parent = root
    Instance.new("UICorner", avatarBack).CornerRadius = UDim.new(1, 0)

    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(1, -4, 1, -4)
    avatar.Position = UDim2.fromOffset(2, 2)
    avatar.BackgroundTransparency = 1
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.Parent = avatarBack
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        end)
        if ok and image and avatar.Parent then avatar.Image = image end
    end)

    local speed = Instance.new("TextLabel")
    speed.Name = "Speed"
    speed.Size = UDim2.new(1, 0, 0, 40)
    speed.Position = UDim2.new(0, 0, 0, 0)
    speed.BackgroundTransparency = 1
    speed.Text = "0.0"
    speed.TextColor3 = PLAYER_ESP_COLOR
    speed.Font = Enum.Font.GothamBlack
    speed.TextSize = 30
    speed.TextXAlignment = Enum.TextXAlignment.Center
    speed.TextYAlignment = Enum.TextYAlignment.Center
    speed.TextStrokeTransparency = 0
    speed.TextStrokeColor3 = Color3.fromRGB(20, 20, 24)
    speed.Parent = root

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, 0, 0, 17)
    displayName.Position = UDim2.new(0, 0, 0, 40)
    displayName.BackgroundTransparency = 1
    displayName.Text = player.DisplayName
    displayName.TextColor3 = PLAYER_ESP_COLOR
    displayName.Font = Enum.Font.GothamBold
    displayName.TextSize = 10
    displayName.TextXAlignment = Enum.TextXAlignment.Center
    displayName.TextStrokeTransparency = 0
    displayName.TextStrokeColor3 = Color3.fromRGB(20, 20, 24)
    displayName.Parent = root
    return root, speed, displayName
end

local function setPlayerESPCharacter(playerData, character)
    removeESPHighlight(playerData)
    if not S.espEnabled or not character or not character.Parent then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "VX7_ESPPlayer"
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = PLAYER_ESP_FILL_TRANSPARENCY
    highlight.OutlineTransparency = PLAYER_ESP_OUTLINE_TRANSPARENCY
    highlight.FillColor = PLAYER_ESP_COLOR
    highlight.OutlineColor = PLAYER_ESP_COLOR
    pcall(function() highlight:SetAttribute("VX7ESP", true) end)
    highlight.Parent = character
    playerData.highlight = highlight
end

local function watchESPPlayer(player)
    if not player or player == LP then return end
    removeESPForPlayer(player)
    local cache = S.espPlayerCache
    local data = {lastSpeedText = nil}
    cache.players[player] = data
    local screenGui = ensurePlayerESPGui()
    data.box = createESPBox(screenGui)
    data.tracer = createESPTracer(screenGui)
    data.infoFrame, data.speedLabel, data.nameLabel = createESPInfoCard(screenGui, player)
    setPlayerESPCharacter(data, player.Character)

    data.charConn = player.CharacterAdded:Connect(function(character)
        task.delay(0.1, function()
            if S.espEnabled and cache.players[player] == data then
                setPlayerESPCharacter(data, character)
            end
        end)
    end)
    data.charRemovingConn = player.CharacterRemoving:Connect(function(character)
        if data.highlight and data.highlight.Adornee == character then removeESPHighlight(data) end
        if data.box then data.box.Visible = false end
        if data.infoFrame then data.infoFrame.Visible = false end
        if data.tracer then data.tracer.Visible = false end
    end)
end

local function updateESP(deltaTime)
    if not S.espEnabled then return end
    local cache = S.espPlayerCache
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then
        for _, data in pairs(cache.players) do
            if data.tracer then data.tracer.Visible = false end
        end
        return
    end
    cache.infoAccumulator = (cache.infoAccumulator or 0) + (deltaTime or 1 / 60)
    local updateInfo = cache.infoAccumulator >= 1 / 30
    if updateInfo then cache.infoAccumulator = 0 end

    for player, data in pairs(cache.players) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")
        if character and humanoid and humanoid.Health > 0 and root then
            updateESPTracer(data.tracer, currentCamera, root)
            local headPos = (head and head.Position or root.Position + Vector3.new(0, 1, 0)) + Vector3.new(0, 1.6, 0)
            local footPos = root.Position - Vector3.new(0, 3, 0)
            local topScreen, topOnScreen = currentCamera:WorldToViewportPoint(headPos)
            local bottomScreen, bottomOnScreen = currentCamera:WorldToViewportPoint(footPos)
            if data.box and topOnScreen and bottomOnScreen and topScreen.Z > 0 and bottomScreen.Z > 0 then
                local height = math.abs(bottomScreen.Y - topScreen.Y)
                local width = height * 0.55
                if height == height and width == width and height > 0 then
                    data.box.Size = UDim2.fromOffset(width, height)
                    data.box.Position = UDim2.fromOffset((topScreen.X + bottomScreen.X) * 0.5 - width * 0.5, math.min(topScreen.Y, bottomScreen.Y))
                    data.box.Visible = true
                else
                    data.box.Visible = false
                end
            elseif data.box then
                data.box.Visible = false
            end

            if updateInfo and data.infoFrame and data.speedLabel then
                local cardPos, onScreen = currentCamera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.45, 0))
                if onScreen and cardPos.Z > 0 then
                    data.infoFrame.Position = UDim2.fromOffset(cardPos.X, cardPos.Y)
                    data.infoFrame.Visible = true
                    local velocity = root.AssemblyLinearVelocity
                    local speedText = tostring(math.floor(Vector3.new(velocity.X, 0, velocity.Z).Magnitude * 10 + 0.5) / 10)
                    if data.lastSpeedText ~= speedText then
                        data.lastSpeedText = speedText
                        data.speedLabel.Text = speedText
                    end
                    data.speedLabel.TextColor3 = PLAYER_ESP_COLOR
                else
                    data.infoFrame.Visible = false
                end
            end
            local highlight = data.highlight
            if (not highlight or not highlight.Parent or highlight.Adornee ~= character) and S.espEnabled then
                setPlayerESPCharacter(data, character)
            elseif highlight then
                if highlight.FillColor ~= PLAYER_ESP_COLOR then highlight.FillColor = PLAYER_ESP_COLOR end
                if highlight.OutlineColor ~= PLAYER_ESP_COLOR then highlight.OutlineColor = PLAYER_ESP_COLOR end
            end
        else
            if data.box then data.box.Visible = false end
            if data.infoFrame then data.infoFrame.Visible = false end
            if data.highlight then removeESPHighlight(data) end
            if data.tracer then data.tracer.Visible = false end
        end
    end
end

local function stopESPLoop()
    S.espEnabled = false
    local cache = S.espPlayerCache
    if not cache then return end
    for _, name in ipairs({"addConn", "remConn", "renderConn"}) do
        local connection = cache[name]
        if connection then pcall(function() connection:Disconnect() end); cache[name] = nil end
    end
    if cache.renderBound then
        pcall(function() RunService:UnbindFromRenderStep(PLAYER_ESP_BIND_NAME) end)
        cache.renderBound = false
    end
    clearESP()
    if cache.screenGui then
        pcall(function() cache.screenGui:Destroy() end)
        cache.screenGui = nil
    end
    cache.infoAccumulator = 0
end

local function startESPLoop()
    stopESPLoop()
    S.espEnabled = true
    local cache = S.espPlayerCache
    ensurePlayerESPGui()
    for _, player in ipairs(Players:GetPlayers()) do watchESPPlayer(player) end
    cache.addConn = Players.PlayerAdded:Connect(watchESPPlayer)
    cache.remConn = Players.PlayerRemoving:Connect(removeESPForPlayer)
    local bindOk = pcall(function()
        RunService:BindToRenderStep(PLAYER_ESP_BIND_NAME, Enum.RenderPriority.Camera.Value + 2, updateESP)
    end)
    if bindOk then
        cache.renderBound = true
    else
        cache.renderConn = RunService.RenderStepped:Connect(updateESP)
    end
end

local function toggleESP(on)
    if on then startESPLoop() else stopESPLoop() end
end

SWING_COOLDOWN = 0.25
AUTO_BAT_SPEED, AUTO_BAT_VERT_SPEED, AUTO_BAT_DIST, AUTO_BAT_HEIGHT, AUTO_BAT_V_OFF, AUTO_BAT_TURN_SPEED, AUTO_BAT_MAX_TURN_RATE =
    58, 52, 0.15, 0.35, 0.65, 285, 28

S.ui = function(pcVal, mobVal) return S.IS_MOBILE and mobVal or pcVal end
local function applyPhoneGuiScale(frame, scaleValue, storeKey)
    if not frame then return end
    local scaleObj = frame:FindFirstChild("SMKPhoneScale")
    if not scaleObj then
        scaleObj = Instance.new("UIScale")
        scaleObj.Name = "SMKPhoneScale"
        scaleObj.Parent = frame
    end
    scaleObj.Scale = S.IS_TOUCH_DEVICE and scaleValue or 1
    if storeKey then
        S[storeKey] = scaleObj
    end
end
S.getActiveSpeed = function()
    if S.laggerMode == 1 then return S.LS
    elseif S.laggerMode == 2 then return S.LCS
    elseif S.speedMode then return S.CS
    else return S.NS
    end
end
S.getSpeedModeName = function()
    if S.laggerMode == 1 then return "Lagger Normal Speed" end
    if S.laggerMode == 2 then return "Lagger Carry Speed" end
    return S.speedMode and "Carry" or "Normal"
end
S.getAutoPathSpeed = function()
    if S.laggerMode == 1 then return S.LS
    elseif S.laggerMode == 2 then return S.LCS
    else return S.NS end
end

local function isSpeedRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

-- VX7's original speed core: obstacle resolution, step assist, spoof hooks and LV sync.
S._vxSpeedMotion =
	{ smoothed = Vector2.zero, lastMagnitude = 0, stepToken = 0, stepTarget = nil, stepExpires = 0, root = nil }
S._unifiedMovementEnabled = S._unifiedMovementEnabled ~= false
S._vxSpeedCollisionParams = RaycastParams.new()
S._vxSpeedCollisionParams.FilterType = Enum.RaycastFilterType.Exclude
S._vxSpeedCollisionParams.IgnoreWater = true
pcall(function()
	S._vxSpeedCollisionParams.RespectCanCollide = true
end)
function S._vxSpeedPulseVertical(parent, arg, lineVelocity, arg2)
	if not parent or not parent.Parent then
		return
	end
	local name, name2 = arg .. "Attachment", arg .. "LinearVelocity"
	local attachment = parent:FindFirstChild(name)
	if not attachment then
		attachment = Instance.new("Attachment")
		attachment.Name = name
		attachment.Parent = parent
	end
	local linearVelocity = parent:FindFirstChild(name2)
	if not linearVelocity then
		linearVelocity = Instance.new("LinearVelocity")
		linearVelocity.Name = name2
		linearVelocity.Attachment0 = attachment
		linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
		linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
		linearVelocity.LineDirection = Vector3.new(0, 1, 0)
		linearVelocity.ForceLimitsEnabled = false
		linearVelocity.Parent = parent
	end
	linearVelocity:SetAttribute("VX7Pulse", {} and (os.clock()) or 0)
	local attribute = linearVelocity:GetAttribute("VX7Pulse")
	linearVelocity.LineVelocity = lineVelocity or 0
	linearVelocity.Enabled = true
	task.delay(arg2 or 0.12, function()
		if not linearVelocity.Parent or linearVelocity:GetAttribute("VX7Pulse") ~= attribute then
			return
		end
		pcall(function()
			linearVelocity:Destroy()
		end)
		if attachment.Parent then
			pcall(function()
				attachment:Destroy()
			end)
		end
	end)
end
function S._vxSpeedCheckRoof(arg, arg2)
	if not arg or not arg.Parent or S._youtResetInProgress or S.dropBrainrotActive then
		return false
	end
	if S.batTpEnabled or S._smartBatTpDriving then
		return false
	end
	local n23 = math.max(arg.AssemblyLinearVelocity.Y, 0)
	if n23 <= 0.25 then
		return false
	end
	local vxSpeedCollisionParams = S._vxSpeedCollisionParams
	vxSpeedCollisionParams.FilterDescendantsInstances = { arg.Parent }
	local n24 = math.clamp(arg2 or 0.016666666666666666, 0.004166666666666667, 0.06666666666666667)
	if
		not workspace:Raycast(
			arg.Position,
			Vector3.new(0, 3.05 + math.min(n23 * n24, 0.9), 0),
			vxSpeedCollisionParams
		)
	then
		return false
	end
	S._vxSpeedClearStep(arg)
	S._vxSpeedPulseVertical(arg, "VX7VampireRoofGuard", 0, 0.14)
	return true
end
function S._vxSpeedClearStep(arg)
	local vxSpeedMotion = S._vxSpeedMotion
	vxSpeedMotion.stepToken = vxSpeedMotion.stepToken + 1
	vxSpeedMotion.stepTarget = nil
	vxSpeedMotion.stepExpires = 0
	if not arg then
		return
	end
	local vX7SpeedStepLinearVelocity = arg:FindFirstChild("VX7SpeedStepLinearVelocity")
	if vX7SpeedStepLinearVelocity then
		pcall(function()
			vX7SpeedStepLinearVelocity:Destroy()
		end)
	end
	local vX7SpeedStepAttachment = arg:FindFirstChild("VX7SpeedStepAttachment")
	if vX7SpeedStepAttachment then
		pcall(function()
			vX7SpeedStepAttachment:Destroy()
		end)
	end
end
function S._vxSpeedRequestStep(root, stepTarget)
	if not root or not root.Parent or not stepTarget or stepTarget <= root.Position.Y + 0.05 then
		return
	end
	local vxSpeedMotion, now3 = S._vxSpeedMotion, os.clock()
	if vxSpeedMotion.stepTarget and vxSpeedMotion.root == root and now3 < vxSpeedMotion.stepExpires then
		vxSpeedMotion.stepTarget = math.max(vxSpeedMotion.stepTarget, stepTarget)
		vxSpeedMotion.stepExpires = math.max(vxSpeedMotion.stepExpires, now3 + 0.32)
		return
	end
	S._vxSpeedClearStep(root)
	vxSpeedMotion.root = root
	vxSpeedMotion.stepTarget = stepTarget
	vxSpeedMotion.stepExpires = now3 + 0.32
	local stepToken = vxSpeedMotion.stepToken
	task.spawn(function()
		while
			vxSpeedMotion.stepToken == stepToken
			and root.Parent
			and root.Parent == LP.Character
			and os.clock() < vxSpeedMotion.stepExpires
		do
			local n23 = (vxSpeedMotion.stepTarget or root.Position.Y) - root.Position.Y
			if n23 <= 0.05 then
				break
			end
			S._vxSpeedCollisionParams.FilterDescendantsInstances = { root.Parent }
			if
				workspace:Raycast(
					root.Position,
					Vector3.new(0, 3.05 + math.min(n23, 2.35), 0),
					S._vxSpeedCollisionParams
				)
			then
				break
			end
			local vX7SpeedStepAttachment = root:FindFirstChild("VX7SpeedStepAttachment")
			if not vX7SpeedStepAttachment then
				vX7SpeedStepAttachment = Instance.new("Attachment")
				vX7SpeedStepAttachment.Name = "VX7SpeedStepAttachment"
				vX7SpeedStepAttachment.Parent = root
			end
			local vX7SpeedStepLinearVelocity = root:FindFirstChild("VX7SpeedStepLinearVelocity")
			if not vX7SpeedStepLinearVelocity then
				vX7SpeedStepLinearVelocity = Instance.new("LinearVelocity")
				vX7SpeedStepLinearVelocity.Name = "VX7SpeedStepLinearVelocity"
				vX7SpeedStepLinearVelocity.Attachment0 = vX7SpeedStepAttachment
				vX7SpeedStepLinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
				vX7SpeedStepLinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
				vX7SpeedStepLinearVelocity.LineDirection = Vector3.new(0, 1, 0)
				vX7SpeedStepLinearVelocity.ForceLimitsEnabled = false
				vX7SpeedStepLinearVelocity.Parent = root
			end
			vX7SpeedStepLinearVelocity.LineVelocity = math.clamp(n23 * 11, 7, 17)
			vX7SpeedStepLinearVelocity.Enabled = true
			RunService.Heartbeat:Wait()
		end
		if vxSpeedMotion.stepToken == stepToken then
			S._vxSpeedClearStep(root)
		end
	end)
end
function S._vxSpeedWalkableStep(arg, arg2, arg3, arg4, arg5)
	if not arg2 or not arg or not arg.Parent or not arg3 or arg3.Magnitude < 0.01 then
		return false
	end
	local vxSpeedCollisionParams = S._vxSpeedCollisionParams
	vxSpeedCollisionParams.FilterDescendantsInstances = { arg.Parent }
	local hit = workspace:Raycast(arg.Position, Vector3.new(0, -7, 0), vxSpeedCollisionParams)
	if not hit or hit.Normal.Y < 0.45 then
		return false
	end
	local n23, n24 =
		math.clamp((arg2.HipHeight or 2) + 0.25, 1.35, 2.35),
		arg.Position + arg3.Unit * (arg5 + math.min(arg4, 0.65) + 0.08)
	arg3 = workspace:Raycast(
		Vector3.new(n24.X, hit.Position.Y + n23 + 0.25, n24.Z),
		Vector3.new(0, -n23 - 0.45, 0),
		vxSpeedCollisionParams
	)
	if not arg3 or arg3.Normal.Y < 0.55 then
		return false
	end
	n24 = arg3.Position.Y - hit.Position.Y
	if n24 > 0.05 and n24 <= n23 then
		return true, arg3.Position.Y + (arg2.HipHeight or 2) + arg.Size.Y * 0.5 + 0.06
	end
	return false
end
function S._vxSpeedResolveHorizontal(arg, arg2, arg3, arg4)
	local vector = Vector3.new(arg3.X, 0, arg3.Z)
	if vector.Magnitude < 0.01 then
		return vector, false, false
	end
	local vxSpeedCollisionParams = S._vxSpeedCollisionParams
	vxSpeedCollisionParams.FilterDescendantsInstances = { arg.Parent }
	local magnitude, n23, n24 =
		vector.Magnitude,
		math.clamp(
			math.max(arg4 or 0.016666666666666666, 0.011111111111111112),
			0.011111111111111112,
			0.06666666666666667
		),
		math.clamp(math.max(arg.Size.X, arg.Size.Z) * 0.5, 0.9, 1)
	arg3, arg4 = S._vxSpeedWalkableStep(arg, arg2, vector, vector.Magnitude * n23, n24)
	if arg3 then
		S._vxSpeedRequestStep(arg, arg4)
	end
	arg3, arg4 = false
	local flag15 = false
	for i = 1, 2, 1 do
		if vector.Magnitude < 0.02 then
			break
		end
		local n25, hit = vector.Magnitude * n23
		if
			not pcall(function()
				hit =
					workspace:Spherecast(arg.Position, n24, vector.Unit * (n25 + 0.03), vxSpeedCollisionParams)
			end)
		then
			hit = workspace:Raycast(arg.Position, vector.Unit * (n25 + n24 + 0.03), vxSpeedCollisionParams)
		end
		if not hit then
			break
		end
		i = math.cos(math.rad(math.clamp(arg2 and arg2.MaxSlopeAngle or 45, 0, 89)))
		if hit.Normal.Y >= i then
			break
		end
		local v45, vector2 = S._vxSpeedWalkableStep(arg, arg2, vector, n25, n24)
		if v45 then
			S._vxSpeedRequestStep(arg, vector2)
			break
		end
		vector2 = Vector3.new(hit.Normal.X, 0, hit.Normal.Z)
		if vector2.Magnitude < 0.05 then
			break
		end
		vector2 = vector2.Unit
		i = vector:Dot(vector2)
		if i >= 0 then
			break
		end
		arg3 = true
		v45 = vector
		if arg4 and arg4:Dot(vector2) < 0.55 then
			vector, flag15 = Vector3.zero, true
			break
		end
		arg4 = arg4 or vector2
		local n26, n27 = v45 - vector2 * i, math.max((hit.Distance or 0) - 0.03, 0)
		vector = n26 - vector2 * math.min(-i, n27 / n23)
	end
	if vector.Magnitude < 0.04 then
		vector = Vector3.zero
	end
	if vector.Magnitude > magnitude then
		vector = vector.Unit * magnitude
	end
	return vector, arg3, flag15
end

		_G.fakeVelocity = Vector3.zero
		_G.spoofedVelocity = _G.fakeVelocity
		fakeVelocity = _G.fakeVelocity
		spoofedVelocity = _G.fakeVelocity
		S._vx7SpoofedVelocity = _G.fakeVelocity
		local humanoidRootPart2, humanoid2
		local function fn86(character2)
			if not character2 then
				humanoidRootPart2, humanoid2 = nil, nil
				S._vxCachedRoot = nil
				S._vxCachedHum = nil
				return
			end
			local ok, result = pcall(character2.WaitForChild, character2, "HumanoidRootPart", 5)
			humanoidRootPart2 = ok and result or (character2:FindFirstChild("HumanoidRootPart"))
			ok, result = pcall(character2.WaitForChild, character2, "Humanoid", 5)
			humanoid2 = ok and result or (character2:FindFirstChildOfClass("Humanoid"))
			S._vxCachedRoot = humanoidRootPart2
			S._vxCachedHum = humanoid2
		end
		if LP.Character then
			task.spawn(fn86, LP.Character)
		end
		LP.CharacterAdded:Connect(fn86)
		LP.CharacterRemoving:Connect(function()
			humanoidRootPart2, humanoid2 = nil, nil
			S._vxCachedRoot = nil
			S._vxCachedHum = nil
		end)
		S._vx7Hooked = false
		function S._vx7SetupHooks()
			if S._vx7Hooked then
				return
			end
			local v45 = getrawmetatable and (getrawmetatable(game))
			if not v45 or type(v45) ~= "table" or not newcclosure then
				return
			end
			local v46, v47 = setreadonly or make_writeable, isreadonly or iswriteable
			S._vx7Hooked = pcall(function()
				if v47 and (v47(v45)) and v46 then
					v46(v45, false)
				elseif v46 then
					v46(v45, false)
				end
				local index, newindex = v45.__index, v45.__newindex
				v45.__index = newcclosure(function(arg, arg2)
					if
						(arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity")
						and not checkcaller()
						and S.antiDropEnabled
						and (rawequal(arg, humanoidRootPart2))
					then
						return _G.fakeVelocity
					end
					return index(arg, arg2)
				end)
				v45.__newindex = newcclosure(function(arg, arg2, fakeVelocity_)
					if
						(arg2 == "AssemblyLinearVelocity" or arg2 == "Velocity")
						and not checkcaller()
						and S.antiDropEnabled
						and (rawequal(arg, humanoidRootPart2))
					then
						_G.fakeVelocity = fakeVelocity_
						fakeVelocity = fakeVelocity_
						_G.spoofedVelocity = fakeVelocity_
						spoofedVelocity = fakeVelocity_
						S._vx7SpoofedVelocity = fakeVelocity_
						return
					end
					return newindex(arg, arg2, fakeVelocity_)
				end)
				if v46 then
					v46(v45, true)
				end
			end)
		end
		function S._vxSyncSpoof(fakeVelocity_)
			_G.fakeVelocity = fakeVelocity_
			fakeVelocity = fakeVelocity_
			_G.spoofedVelocity = fakeVelocity_
			spoofedVelocity = fakeVelocity_
			S._vx7SpoofedVelocity = fakeVelocity_
		end
		task.spawn(function()
			pcall(S._vx7SetupHooks)
			task.wait(1)
			pcall(S._vx7SetupHooks)
		end)
		local function ensureLV(root)
			pcall(S._vx7SetupHooks)
			S._vxSpeedMotion.root = root
			if S._vxSyncSpoof then
				S._vxSyncSpoof(
					Vector3.new(
						root.AssemblyLinearVelocity.X,
						root.AssemblyLinearVelocity.Y,
						root.AssemblyLinearVelocity.Z
					)
				)
			end
		end
		local function setLV(arg, arg2, arg3, arg4)
			if not arg or not arg.Parent then
				return
			end
			ensureLV(arg)
			local y, vector = arg.AssemblyLinearVelocity.Y, Vector3.new(arg2 or 0, 0, arg3 or 0)
			arg4 = if S._unifiedLastJumpTime and os.clock() - S._unifiedLastJumpTime < 0.15
				then 0
				else if math.abs(y) > 20 then (math.clamp(y, -20, 20)) else y
			if vector.Magnitude > 0.05 then
				arg3, arg2 = math.min(vector.Magnitude, 16), vector.Unit
				if S._vxSyncSpoof then
					S._vxSyncSpoof(Vector3.new(arg2.X * arg3, arg4, arg2.Z * arg3))
				end
				arg.AssemblyLinearVelocity = Vector3.new(vector.X, y, vector.Z)
			elseif S._vxSyncSpoof then
				S._vxSyncSpoof(Vector3.new(0, arg4, 0))
			end
		end
		local function clearLV()
			local root = S._vxSpeedMotion.root
			if S._vxSpeedClearStep then
				S._vxSpeedClearStep(root)
			end
			if S._vxSyncSpoof then
				S._vxSyncSpoof(Vector3.zero)
			end
			S._vxSpeedMotion.smoothed = Vector2.zero
			S._vxSpeedMotion.lastMagnitude = 0
			S._vxSpeedMotion.root = nil
		end
LP.CharacterRemoving:Connect(clearLV)
S._vxClearSpeedVelocity = clearLV
S._vxSetSpeedVelocity = setLV

S._unifiedResolveSpeed = function()
    local ok, speed = pcall(S.getActiveSpeed)
    if ok and type(speed) == "number" then return speed end
    return tonumber(S.NS) or 16
end

saveConfig = nil
updateFloatingButtons = nil

-- Función central para actualizar el botón flotante de Lagger
local function updateLaggerButtonVisual()
    local fb = S._floatingButtons
    if not fb.lagger then return end
    local active = S.laggerMode ~= 0 and not S.speedMode
    fb.l2Lagger.Text = ""
    S._setPButtonActive(fb.lagger, fb.strokeLagger, fb.l1Lagger, fb.l2Lagger, active)
end

S.refreshSpeedModeLabel = function()
    if S.speedClk then S.speedClk(S.speedMode and S.laggerMode == 0) end
    if S.setLaggerVisual then S.setLaggerVisual(S.laggerMode ~= 0) end
    updateLaggerButtonVisual()
    if updateFloatingButtons then updateFloatingButtons() end
end

S.applySpeedVelocityNow = function(deltaTime)
    if S._youtResetInProgress or S.batBypassEnabled then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then return end
    if S._vxSpeedCheckRoof and S._vxSpeedCheckRoof(root, deltaTime or 1 / 60) then
        setLV(root, 0, 0, deltaTime)
        return
    end
    local direction = hum.MoveDirection
    if direction.Magnitude > 0.05 then
        direction = Vector3.new(direction.X, 0, direction.Z)
        local magnitude = direction.Magnitude
        if magnitude > 0.001 then
            direction = direction.Unit
            S.lastMoveDir = direction
            pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
            local horizontal = Vector3.new(direction.X * S._unifiedResolveSpeed(), 0, direction.Z * S._unifiedResolveSpeed())
            if S._vxSpeedResolveHorizontal then
                local ok, result = pcall(S._vxSpeedResolveHorizontal, root, hum, horizontal, deltaTime or 1 / 60)
                if ok and typeof(result) == "Vector3" then horizontal = result end
            end
            setLV(root, horizontal.X, horizontal.Z, deltaTime)
        else
            setLV(root, 0, 0, deltaTime)
        end
    else
        setLV(root, 0, 0, deltaTime)
    end
end

S.setNormalSpeedMode = function()
    S.laggerMode = 0
    S.speedMode = false
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.setCarrySpeedMode = function()
    S.laggerMode = 0
    S.speedMode = true
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.setLaggerNormalMode = function()
    S.speedMode = false
    S.laggerMode = 1
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end
S.setLaggerCarryMode = function()
    S.speedMode = false
    S.laggerMode = 2
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.setLaggerOffMode = function()
    S.laggerMode = 0
    S.refreshSpeedModeLabel()
end

S.toggleCarryMode = function()
    if S.laggerMode ~= 0 then
        S.laggerMode = 0
        S.speedMode = true
    else
        S.speedMode = not S.speedMode
    end
    S.refreshSpeedModeLabel()
    S.applySpeedVelocityNow()
end

S.toggleLaggerMode = function()
    if S.laggerMode == 2 then
        S.setLaggerNormalMode()
    else
        S.setLaggerCarryMode()
    end
end

S.setupSpeedBillboard = function(char)
    local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
    if not head then return end
    local oldBB = head:FindFirstChild("SMKSpeedBB")
    if oldBB then oldBB:Destroy() end

    -- Colores tomados del indicador sobre la cabeza de Ace Duels (tema 2):
    -- pale 210,218,228 -> accent 104,116,132 -> accent2 156,169,186.
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "SMKSpeedBB"
    bb.Size = UDim2.fromOffset(118, 36)
    bb.StudsOffset = Vector3.new(0, 1.75, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.LightInfluence = 0
    bb.MaxDistance = 150

    local function addAceGradient(label)
        local gradient = Instance.new("UIGradient", label)
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 235, 235)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 170, 170)),
        })
        return gradient
    end

    local discordLbl = Instance.new("TextLabel", bb)
    discordLbl.Name = "DiscordBillLbl"
    discordLbl.Size = UDim2.new(1, 0, 0.46, 0)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text = "ＳＭＫㅤＨＵＢ"
    discordLbl:SetAttribute("DiscordInviteURL", DISCORD_INVITE_URL)
    discordLbl.Font = Enum.Font.GothamBlack
    discordLbl.TextScaled = true
    discordLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    discordLbl.TextStrokeTransparency = 0
    discordLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local discordSize = Instance.new("UITextSizeConstraint", discordLbl)
    discordSize.MinTextSize = 4
    discordSize.MaxTextSize = 12
    SMKBrandStyle.apply(discordLbl)

    local speedLbl = Instance.new("TextLabel", bb)
    speedLbl.Name = "SpeedBillLbl"
    speedLbl.Size = UDim2.new(1, 0, 0.46, 0)
    speedLbl.Position = UDim2.new(0, 0, 0.54, 0)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: 0"
    speedLbl.Font = Enum.Font.GothamBlack
    speedLbl.TextScaled = true
    speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLbl.TextStrokeTransparency = 0
    speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local speedSize = Instance.new("UITextSizeConstraint", speedLbl)
    speedSize.MinTextSize = 4
    speedSize.MaxTextSize = 12
    addAceGradient(speedLbl)

    S.speedDiscordLabel = discordLbl
    S.speedCounterLabel = speedLbl
end

local function updateSpeedBillboard(hrp)
    if not S.speedCounterLabel then return end
    local now = os.clock()
    if now - S.speedLabelLastUpdate >= 0.12 then
        S.speedLabelLastUpdate = now
        local v = hrp.Velocity
        local flatSpeed = math.sqrt((v.X * v.X) + (v.Z * v.Z))
        S.speedCounterLabel.Text = string.format("Speed: %.1f", flatSpeed)
    end
end


-- Ragdoll Timer tomado únicamente de Ace Duels.
-- Es independiente del indicador de Discord/Speed de SMK.
smkRagdollTimer = {
    billboard = nil,
    label = nil,
    character = nil,
    active = false,
    startTime = 0,
    endTime = 0,
    goUntil = 0,
    wasRagdolled = false,
    duration = 2.6,
    connection = nil,
}

local function setupSMKRagdollTimer(char)
    local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
    if not head then return end
    local old = head:FindFirstChild("SMKRagdollTimerBB")
    if old then old:Destroy() end
    if smkRagdollTimer.connection then
        pcall(function() smkRagdollTimer.connection:Disconnect() end)
        smkRagdollTimer.connection = nil
    end
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "SMKRagdollTimerBB"
    bb.Size = UDim2.fromOffset(112, 28)
    bb.StudsOffset = Vector3.new(0, 4.45, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.LightInfluence = 0
    bb.MaxDistance = 150
    local label = Instance.new("TextLabel", bb)
    label.Name = "RagdollTimerLabel"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.Font = Enum.Font.GothamBlack
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local sizeConstraint = Instance.new("UITextSizeConstraint", label)
    sizeConstraint.MinTextSize = 4
    sizeConstraint.MaxTextSize = 17
    local gradient = Instance.new("UIGradient", label)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 235, 235)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 170, 170)),
    })
    smkRagdollTimer.billboard = bb
    smkRagdollTimer.label = label
    smkRagdollTimer.character = char
    smkRagdollTimer.active = false
    smkRagdollTimer.startTime = 0
    smkRagdollTimer.endTime = 0
    smkRagdollTimer.goUntil = 0
    smkRagdollTimer.wasRagdolled = false

    local function isRagdolled(humanoid)
        if not humanoid then return false end
        local state = humanoid:GetState()
        return humanoid.PlatformStand
            or state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
    end

    smkRagdollTimer.connection = RunService.Heartbeat:Connect(function()
        if smkRagdollTimer.character ~= char or not bb.Parent or not label.Parent then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            label.Text = ""
            smkRagdollTimer.active = false
            return
        end
        local now = os.clock()
        local ragdolled = isRagdolled(humanoid)
        if ragdolled and not smkRagdollTimer.wasRagdolled and not smkRagdollTimer.active and smkRagdollTimer.goUntil <= now then
            smkRagdollTimer.active = true
            smkRagdollTimer.startTime = now
            smkRagdollTimer.endTime = now + smkRagdollTimer.duration
            label.Text = string.format("%.1f", smkRagdollTimer.duration)
        end
        if smkRagdollTimer.active then
            local remaining = smkRagdollTimer.endTime - now
            if remaining <= 0 then
                smkRagdollTimer.active = false
                smkRagdollTimer.goUntil = now + 0.65
                label.Text = "GO"
            else
                label.Text = string.format("%.1f", remaining)
            end
        elseif smkRagdollTimer.goUntil > now then
            label.Text = "GO"
        else
            label.Text = ""
        end
        smkRagdollTimer.wasRagdolled = ragdolled
    end)
end

-- ============================================================
-- ============================================================
-- ============================================================
-- ============================================================
-- Forward declarations used by features defined later in the script.
startAntiRagdoll, stopAntiRagdoll = nil, nil
startBatCounter, stopBatCounter = nil, nil
setBatAimbot = nil
triggerBatCounter = nil
stopDropBrainrot = nil
startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight = nil, nil, nil, nil

-- Instant Reset adapted from Ace Duels.
-- Uses Ace's pulse/queue/camera flow and SMK's local guard APIs.
aceInstaResetState = _G._AceInstaResetState or {}
_G._AceInstaResetState = aceInstaResetState

for _, connection in ipairs(aceInstaResetState.connections or {}) do
    pcall(function() connection:Disconnect() end)
end
if aceInstaResetState.cameraConnection then
    pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
end
aceInstaResetState.connections = {}
aceInstaResetState.cameraConnection = nil
aceInstaResetState.busy = false
aceInstaResetState.busyAt = 0
aceInstaResetState.queued = false
aceInstaResetState.queuedUntil = 0
aceInstaResetState.token = 0
aceInstaResetState.cameraHeld = false
aceInstaResetState.cameraHeldAt = 0
aceInstaResetState.suspended = nil
aceInstaResetState.speed = tonumber(aceInstaResetState.speed) or 1000000

resetHeartbeat = RunService.PreSimulation or RunService.Heartbeat
local function registerResetConnection(connection)
    table.insert(aceInstaResetState.connections, connection)
    return connection
end

local function suspendSMKGuards()
    local state = {antiRagdoll = false, batCounter = false, batAimbot = false, autoLeft = false, autoRight = false, movement = false}
    if S.antiRagdollEnabled then
        state.antiRagdoll = true
        S.antiRagdollEnabled = false
        if stopAntiRagdoll then pcall(stopAntiRagdoll) end
        if S.setAntiRagVisual then pcall(S.setAntiRagVisual, false) end
    end
    if S.batCounterEnabled then
        state.batCounter = true
        S.batCounterEnabled = false
        if stopBatCounter then pcall(stopBatCounter) end
        if S.setBatCounterVisual then pcall(S.setBatCounterVisual, false) end
    end
    if S.batBypassEnabled and S.setBatBypass then
        state.batBypass = true
        S.setBatBypass(false)
    end
    if S.batAimbotEnabled then
        state.batAimbot = true
        if setBatAimbot then pcall(setBatAimbot, false) end
    end
    if S.autoLeftEnabled then state.autoLeft = true end
    if S.autoRightEnabled then state.autoRight = true end
    if S.moveConn then state.movement = true end
    if state.autoLeft then
        S.autoLeftEnabled = false
        if stopAutoLeft then pcall(stopAutoLeft) end
        if S.autoLeftSetVisual then pcall(S.autoLeftSetVisual, false) end
    end
    if state.autoRight then
        S.autoRightEnabled = false
        if stopAutoRight then pcall(stopAutoRight) end
        if S.autoRightSetVisual then pcall(S.autoRightSetVisual, false) end
    end
    if S.dropBrainrotActive and stopDropBrainrot then pcall(stopDropBrainrot) end
    if S.stopMovement then pcall(S.stopMovement) end
    S._unifiedGamepadHeld = false
    S._unifiedTouchHeld = false
    S.holdJumpPressed = false
    S.holdJumpActive = false
    aceInstaResetState.suspended = state
    return state
end

local function restoreSMKGuards(state)
    state = state or aceInstaResetState.suspended or {}
    aceInstaResetState.suspended = nil
    if state.antiRagdoll then
        S.antiRagdollEnabled = true
        if startAntiRagdoll then pcall(startAntiRagdoll) end
        if S.setAntiRagVisual then pcall(S.setAntiRagVisual, true) end
    end
    if state.batCounter then
        S.batCounterEnabled = true
        if startBatCounter then pcall(startBatCounter) end
        if S.setBatCounterVisual then pcall(S.setBatCounterVisual, true) end
    end
    if state.batBypass and S.setBatBypass then pcall(S.setBatBypass, true) end
    if state.batAimbot and setBatAimbot then pcall(setBatAimbot, true) end
    if state.autoLeft then
        S.autoLeftEnabled = true
        if startAutoLeft then pcall(startAutoLeft) end
        if S.autoLeftSetVisual then pcall(S.autoLeftSetVisual, true) end
    end
    if state.autoRight then
        S.autoRightEnabled = true
        if startAutoRight then pcall(startAutoRight) end
        if S.autoRightSetVisual then pcall(S.autoRightSetVisual, true) end
    end
    if state.movement and S.startMovement then pcall(S.startMovement) end
    if updateFloatingButtons then pcall(updateFloatingButtons) end
    if saveConfig then pcall(saveConfig) end
end

local function holdResetCamera(oldCharacter)
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then return end
    if aceInstaResetState.cameraHeld and (os.clock() - (aceInstaResetState.cameraHeldAt or 0)) < 5 then return end
    aceInstaResetState.cameraHeld = true
    aceInstaResetState.cameraHeldAt = os.clock()
    local heldCFrame, heldFocus = currentCamera.CFrame, currentCamera.Focus
    pcall(function()
        currentCamera.CameraType = Enum.CameraType.Scriptable
        currentCamera.CFrame = heldCFrame
        currentCamera.Focus = heldFocus
    end)
    aceInstaResetState.cameraConnection = RunService.RenderStepped:Connect(function()
        if workspace.CurrentCamera ~= currentCamera then return end
        pcall(function()
            currentCamera.CameraType = Enum.CameraType.Scriptable
            currentCamera.CFrame = heldCFrame
            currentCamera.Focus = heldFocus
        end)
    end)
    task.spawn(function()
        local elapsed = 0
        while LP.Character == oldCharacter and elapsed < 3 do elapsed += task.wait() end
        if aceInstaResetState.cameraConnection then
            pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
            aceInstaResetState.cameraConnection = nil
        end
        local newCharacter = LP.Character
        aceInstaResetState.cameraHeld = false
        local newCamera = workspace.CurrentCamera or currentCamera
        if newCamera then
            pcall(function()
                newCamera.CameraType = Enum.CameraType.Custom
                local humanoid = newCharacter and newCharacter:FindFirstChildOfClass("Humanoid")
                if humanoid then newCamera.CameraSubject = humanoid end
            end)
        end
    end)
end

local function releaseResetCamera()
    if aceInstaResetState.cameraConnection then
        pcall(function() aceInstaResetState.cameraConnection:Disconnect() end)
        aceInstaResetState.cameraConnection = nil
    end
    aceInstaResetState.cameraHeld = false
end

local function aceFlingUp(character)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not (root and root:IsA("BasePart")) then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            humanoid.BreakJointsOnDeath = true
            humanoid.PlatformStand = true
            humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
        end)
    end
    local velocity = Vector3.new(0, math.clamp(aceInstaResetState.speed, 1000, 10000000), 0)
    local function pulse()
        if not root.Parent then return false end
        return pcall(function()
            root.AssemblyAngularVelocity = Vector3.zero
            root.AssemblyLinearVelocity = velocity
        end)
    end
    if not pulse() then return false end
    task.spawn(function()
        local elapsed = 0
        while elapsed < 1.2 do
            elapsed += resetHeartbeat:Wait()
            if not root.Parent or LP.Character ~= character then return end
            pulse()
        end
    end)
    return true
end

local function aceHardKill(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.PlatformStand = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid.BreakJointsOnDeath = true
        if humanoid.MaxHealth == math.huge or humanoid.MaxHealth <= 0 then humanoid.MaxHealth = 100 end
        humanoid.Health = 0
    end)
    pcall(function() character:BreakJoints() end)
end

local function aceInstantReset()
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not (character and humanoid and root and root:IsA("BasePart")) then
        aceInstaResetState.queued = true
        aceInstaResetState.queuedUntil = os.clock() + 12
        return
    end
    if aceInstaResetState.busy and (os.clock() - (aceInstaResetState.busyAt or 0)) < 5 then return end
    aceInstaResetState.busy = true
    aceInstaResetState.busyAt = os.clock()
    aceInstaResetState.token += 1
    local token = aceInstaResetState.token
    S._youtResetInProgress = true
    local suspended = suspendSMKGuards()
    task.spawn(function()
        pcall(function()
            holdResetCamera(character)
            if not aceFlingUp(character) then aceHardKill(character) end
            local elapsed = 0
            while LP.Character == character and elapsed < 1.2 do elapsed += task.wait() end
            if LP.Character == character then
                local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
                if currentHumanoid and currentHumanoid.Health > 0 then aceHardKill(character) end
            end
            local waited = 0
            while LP.Character == character and waited < 8 do waited += task.wait() end
        end)
        if aceInstaResetState.token ~= token then return end
        releaseResetCamera()
        aceInstaResetState.busy = false
        S._youtResetInProgress = false
        restoreSMKGuards(suspended)
    end)
end

registerResetConnection(resetHeartbeat:Connect(function()
    if not aceInstaResetState.busy then return end
    if (os.clock() - (aceInstaResetState.busyAt or 0)) >= 10 then
        aceInstaResetState.busy = false
        releaseResetCamera()
        S._youtResetInProgress = false
        restoreSMKGuards()
    end
end))

registerResetConnection(LP.CharacterAdded:Connect(function(character)
    if not aceInstaResetState.queued then return end
    if (aceInstaResetState.queuedUntil or 0) < os.clock() then
        aceInstaResetState.queued = false
        return
    end
    aceInstaResetState.queued = false
    task.spawn(function()
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
        local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
        task.wait(0.15)
        if humanoid and root and humanoid.Health > 0 and LP.Character == character then aceInstantReset() end
    end)
end))

_G._AceInstaReset = aceInstantReset
_G._CandyInstaReset = aceInstantReset
_G._AceInstaResetTune = function(value)
    local number = tonumber(value)
    if number then aceInstaResetState.speed = math.clamp(math.abs(number), 1000, 10000000) end
    return aceInstaResetState.speed
end
_G._CandyInstaResetTune = _G._AceInstaResetTune

_lastRequest = 0
local function sourceInstaResetTrigger()
    local now = os.clock()
    if now - _lastRequest < 0.15 then return end
    _lastRequest = now
    aceInstantReset()
end
_G.InstaReset = {Trigger = sourceInstaResetTrigger}
_G.VynxDoInstaReset = _G.InstaReset.Trigger
_G.smkInstantReset = _G.InstaReset.Trigger
-- Rebind the camera to the Humanoid whenever the character respawns.
LP.CharacterAdded:Connect(function(character)
    task.defer(function()
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid and character then humanoid = character:WaitForChild("Humanoid", 5) end
        local camera = workspace.CurrentCamera
        if camera and humanoid then
            pcall(function()
                camera.CameraType = Enum.CameraType.Custom
                camera.CameraSubject = humanoid
            end)
        end
    end)
end)

-- Drop Brainrot adaptado do Drakon: Fling (0.30s) e Jump Drop (0.22s).
-- Todos os botões e atalhos existentes continuam usando runDropBrainrot.
DROP_FLING_COOLDOWN_FAST = 0.6
DROP_FLING_COOLDOWN_SLOW = 0.25
local function setDropActive(on)
    S.dropBrainrotActive = on
    if S.dropBrainrotSetVisual then pcall(S.dropBrainrotSetVisual, on) end
    if S.dropBrainrotFloatVisual and S.dropBrainrotFloatVisual ~= S.dropBrainrotSetVisual then
        pcall(S.dropBrainrotFloatVisual, on)
    end
end

stopDropBrainrot = function()
    local finish = S._dropFinish
    if finish then finish(true); return end
    setDropActive(false)
end

LP.CharacterRemoving:Connect(function()
    local finish = S._dropFinish
    if finish then finish(false) end
end)

local function runDropBrainrot()
    if S.dropBrainrotActive or _G.IsDropping or S._youtResetInProgress then return end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 or root.Anchored then return end
    local mode = S.dropMode == 2 and 2 or 1
    local now = tick()
    if mode == 1 then
        local velocity = root.AssemblyLinearVelocity
        local speedH = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
        local cooldown = speedH > 5 and DROP_FLING_COOLDOWN_FAST or DROP_FLING_COOLDOWN_SLOW
        if now - (S.lastDropTime or 0) < cooldown then return end
        S.lastDropTime = now
    end

    local savedSpeed = S.speedMode
    local savedLagger = S.laggerMode
    local savedBat = S.batAimbotEnabled == true
    if savedBat then setBatAimbot(false) end
    setDropActive(true)
    local finished = false
    local worker, timeout, connection
    local finishDrop
    finishDrop = function(restoreCharacter)
        if finished then return end
        finished = true
        if connection then connection:Disconnect(); connection = nil end
        if worker and worker ~= coroutine.running() then pcall(task.cancel, worker) end
        if timeout and timeout ~= coroutine.running() then pcall(task.cancel, timeout) end
        S._dropThread = nil
        S._dropConn = nil
        S._dropFinish = nil
        if restoreCharacter and LP.Character == character and root.Parent then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                if root.Position.Y < -100 then root.CFrame = CFrame.new(root.Position.X, 5, root.Position.Z) end
                local params = RaycastParams.new()
                params.FilterDescendantsInstances = {character}
                params.FilterType = Enum.RaycastFilterType.Exclude
                local hit = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), params)
                if hit then
                    root.CFrame = CFrame.new(root.Position.X,
                        hit.Position.Y + humanoid.HipHeight + root.Size.Y / 2, root.Position.Z)
                end
                if humanoid.Health > 0 then humanoid:ChangeState(Enum.HumanoidStateType.Running) end
            end)
        end
        S.speedMode = savedSpeed
        S.laggerMode = savedLagger
        setDropActive(false)
        if savedBat then pcall(setBatAimbot, true) end
        if S.refreshSpeedModeLabel then pcall(S.refreshSpeedModeLabel) end
        if restoreCharacter and S.applySpeedVelocityNow then pcall(S.applySpeedVelocityNow) end
        if S.restartMovement then pcall(S.restartMovement) end
        if updateFloatingButtons then pcall(updateFloatingButtons) end
    end
    S._dropFinish = finishDrop

    if mode == 2 then
        connection = RunService.Heartbeat:Connect(function()
            local ok, err = pcall(function()
                if finished then return end
                if LP.Character ~= character or not root.Parent then finishDrop(false); return end
                if tick() - now >= 0.22 then finishDrop(true); return end
                local velocity = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(velocity.X, 160, velocity.Z)
            end)
            if not ok then finishDrop(true); warn("[ＳＭＫㅤＨＵＢ] Jump Drop: " .. tostring(err)) end
        end)
        S._dropConn = connection
        timeout = task.delay(0.35, function() finishDrop(true) end)
        return
    end

    worker = task.defer(function()
        local ok, err = pcall(function()
            local startedAt = tick()
            while not finished and S.dropBrainrotActive and tick() - startedAt < 0.30 do
                RunService.Heartbeat:Wait()
                if finished or LP.Character ~= character or not root.Parent then break end
                local velocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
                root.AssemblyLinearVelocity = velocity * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if finished or not root.Parent then break end
                root.AssemblyLinearVelocity = velocity
                RunService.Stepped:Wait()
                if finished or not root.Parent then break end
                root.AssemblyLinearVelocity = velocity + Vector3.new(0, 0.1, 0)
            end
        end)
        finishDrop(LP.Character == character)
        if not ok then warn("[ＳＭＫㅤＨＵＢ] Fling Drop: " .. tostring(err)) end
    end)
    S._dropThread = worker
    timeout = task.delay(0.35, function() finishDrop(true) end)
end

S.startMovement = function()
    if S.moveConn then S.moveConn:Disconnect(); S.moveConn = nil end
    local movementSignal = RunService.PreSimulation or RunService.Stepped
    S.moveConn = movementSignal:Connect(function(firstDelta, secondDelta)
        local deltaTime = secondDelta or firstDelta or 1 / 60
        if not S.speedEnabled or not S._unifiedMovementEnabled or S._youtResetInProgress then return end
        local char = LP.Character
        local hum = char and (S._vxCachedHum and S._vxCachedHum.Parent and S._vxCachedHum or char:FindFirstChildOfClass("Humanoid"))
        local root = char and (S._vxCachedRoot and S._vxCachedRoot.Parent and S._vxCachedRoot or char:FindFirstChild("HumanoidRootPart"))
        if not char or not hum or not root or hum.Health <= 0 then return end
        S.h, S.hrp = hum, root
        if S.dropBrainrotActive or S.batBypassEnabled then return end
        if S.batAimbotEnabled or S.autoLeftEnabled or S.autoRightEnabled then
            setLV(root, 0, 0, deltaTime)
            return
        end
        local state = hum:GetState()
        if hum.PlatformStand or state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            S.lastMoveDir = Vector3.zero
            setLV(root, 0, 0, deltaTime)
            return
        end
        if S._vxSpeedCheckRoof and S._vxSpeedCheckRoof(root, deltaTime) then
            setLV(root, 0, 0, deltaTime)
            return
        end
        local direction = hum.MoveDirection
        if direction.Magnitude <= 0.05 and S.antiRagdollEnabled and S.lastMoveDir.Magnitude > 0 then
            for key in pairs(S.MOVE_KEYS) do
                if UIS:IsKeyDown(key) then direction = S.lastMoveDir; break end
            end
        end
        if direction.Magnitude > 0.05 then
            direction = Vector3.new(direction.X, 0, direction.Z)
            local magnitude = direction.Magnitude
            if magnitude > 0.001 then
                direction = direction.Unit
                S.lastMoveDir = direction
                pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
                local speed = S._unifiedResolveSpeed()
                local horizontal = Vector3.new(direction.X * speed, 0, direction.Z * speed)
                if S._vxSpeedResolveHorizontal then
                    local ok, result = pcall(S._vxSpeedResolveHorizontal, root, hum, horizontal, deltaTime)
                    if ok and typeof(result) == "Vector3" then horizontal = result end
                end
                setLV(root, horizontal.X, horizontal.Z, deltaTime)
            else
                setLV(root, 0, 0, deltaTime)
            end
        else
            setLV(root, 0, 0, deltaTime)
        end
        updateSpeedBillboard(root)
    end)
end

S.stopMovement = function()
    if S.moveConn then S.moveConn:Disconnect(); S.moveConn = nil end
    if clearLV then clearLV() end
end
S.restartMovement = function() S.stopMovement(); S.startMovement() end
S.speedEnabled = true
S.startMovement()

-- ── Hold Jump (ported from the attached SMK; standalone Infinite Jump removed) ──
S.holdJumpPower = 55
S.holdJumpMinVelocity = 35
S.holdJumpFallClamp = -120
S._unifiedCanJump = true
S._unifiedLastJumpTime = S._unifiedLastJumpTime or 0
S._unifiedGamepadHeld = false
S._unifiedTouchHeld = false
S._mobileJumpButtonConns = S._mobileJumpButtonConns or {}
S._mobileJumpWatchConn = nil
S._mobileJumpButton = nil

local function clearHoldJump()
    S.holdJumpPressed = false
    S.holdJumpActive = false
    S._unifiedGamepadHeld = false
    S._unifiedTouchHeld = false
end

local function isJumpInputFocused()
    local ok, focused = pcall(function() return UIS:GetFocusedTextBox() end)
    return ok and focused ~= nil
end

local function getHoldJumpParts()
    local character = LP.Character
    if not character then return nil, nil, nil end
    return character, character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
end

S._unifiedApplyJumpVelocity = function()
    if not S.holdJumpEnabled or not S._unifiedCanJump or S._youtResetInProgress or isJumpInputFocused() then return end
    if S.dropBrainrotActive then return end
    local character, humanoid, root = getHoldJumpParts()
    if not character or not humanoid or not root or humanoid.Health <= 0 then return end

    S._unifiedCanJump = false
    S._unifiedLastJumpTime = os.clock()
    humanoid.Jump = true
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
    local velocity = root.AssemblyLinearVelocity
    if S._vxSyncSpoof then S._vxSyncSpoof(Vector3.new(velocity.X, 0, velocity.Z)) end
    root.AssemblyLinearVelocity = Vector3.new(velocity.X, S.holdJumpPower, velocity.Z)
    task.delay(0.08, function() S._unifiedCanJump = true end)
end

local function isGamepadInput(input)
    return input.UserInputType.Name:match("^Gamepad%d+$") ~= nil
end

local function bindMobileJumpButton(button)
    for _, connection in ipairs(S._mobileJumpButtonConns) do pcall(function() connection:Disconnect() end) end
    table.clear(S._mobileJumpButtonConns)
    S._unifiedTouchHeld = false
    S._mobileJumpButton = nil
    if not button or not button:IsA("GuiButton") then return end
    S._mobileJumpButton = button
    table.insert(S._mobileJumpButtonConns, button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            S._unifiedTouchHeld = true
            S.holdJumpPressed = true
        end
    end))
    table.insert(S._mobileJumpButtonConns, button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then clearHoldJump() end
    end))
    table.insert(S._mobileJumpButtonConns, button.AncestryChanged:Connect(function(_, parent)
        if not parent then clearHoldJump(); S._mobileJumpButton = nil end
    end))
end

local function findMobileJumpButton()
    local playerGui = LP:FindFirstChildOfClass("PlayerGui")
    local button = playerGui and playerGui:FindFirstChild("JumpButton", true)
    if button and button ~= S._mobileJumpButton then bindMobileJumpButton(button) end
end

local function stopHoldJumpConnections()
    clearHoldJump()
    if S.IJ_JumpConn then S.IJ_JumpConn:Disconnect(); S.IJ_JumpConn = nil end
    if S.IJ_InputBeganConn then S.IJ_InputBeganConn:Disconnect(); S.IJ_InputBeganConn = nil end
    if S.IJ_InputEndedConn then S.IJ_InputEndedConn:Disconnect(); S.IJ_InputEndedConn = nil end
    if S.IJ_HoldConn then S.IJ_HoldConn:Disconnect(); S.IJ_HoldConn = nil end
    if S._mobileJumpWatchConn then S._mobileJumpWatchConn:Disconnect(); S._mobileJumpWatchConn = nil end
    for _, connection in ipairs(S._mobileJumpButtonConns) do pcall(function() connection:Disconnect() end) end
    table.clear(S._mobileJumpButtonConns)
    S._mobileJumpButton = nil
    S._unifiedCanJump = true
end

local function ensureHoldJumpConnections()
    if not S.IJ_JumpConn then
        S.IJ_JumpConn = UIS.JumpRequest:Connect(function()
            if S.holdJumpEnabled and not isJumpInputFocused() then S._unifiedApplyJumpVelocity() end
        end)
    end
    if not S.IJ_InputBeganConn then
        S.IJ_InputBeganConn = UIS.InputBegan:Connect(function(input)
            if isJumpInputFocused() then return end
            if input.KeyCode == Enum.KeyCode.Space and input.UserInputType == Enum.UserInputType.Keyboard then
                S.holdJumpPressed = true
            elseif input.KeyCode == Enum.KeyCode.ButtonA and isGamepadInput(input) then
                S._unifiedGamepadHeld = true
                S.holdJumpPressed = true
            end
        end)
    end
    if not S.IJ_InputEndedConn then
        S.IJ_InputEndedConn = UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.Space and input.UserInputType == Enum.UserInputType.Keyboard then
                clearHoldJump()
            elseif input.KeyCode == Enum.KeyCode.ButtonA and isGamepadInput(input) then
                S._unifiedGamepadHeld = false
                if not S._unifiedTouchHeld and not UIS:IsKeyDown(Enum.KeyCode.Space) then clearHoldJump() end
            end
        end)
    end
    if not S.IJ_HoldConn then
        S.IJ_HoldConn = RunService.Heartbeat:Connect(function()
            if not S.holdJumpEnabled or S.dropBrainrotActive or S._youtResetInProgress or isJumpInputFocused() then return end
            local character, humanoid, root = getHoldJumpParts()
            if not character or not humanoid or not root or humanoid.Health <= 0 then return end
            local keyboardHeld = false
            pcall(function() keyboardHeld = UIS:IsKeyDown(Enum.KeyCode.Space) end)
            local jumpHeld = keyboardHeld or humanoid.Jump == true or S._unifiedGamepadHeld == true or S._unifiedTouchHeld == true
            local velocity = root.AssemblyLinearVelocity
            if jumpHeld and velocity.Y < S.holdJumpMinVelocity then S._unifiedApplyJumpVelocity() end
            if velocity.Y < S.holdJumpFallClamp then
                local clamped = Vector3.new(velocity.X, S.holdJumpFallClamp, velocity.Z)
                if S._vxSyncSpoof then S._vxSyncSpoof(clamped) end
                root.AssemblyLinearVelocity = clamped
            end
        end)
    end
    if UIS.TouchEnabled then
        local playerGui = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui")
        if not S._mobileJumpWatchConn then
            S._mobileJumpWatchConn = playerGui.DescendantAdded:Connect(function(descendant)
                if descendant.Name == "JumpButton" and descendant:IsA("GuiButton") then bindMobileJumpButton(descendant) end
            end)
        end
        task.defer(findMobileJumpButton)
    end
end

local function startHoldJump()
    S.holdJumpEnabled = true
    S.holdJumpMode = true
    ensureHoldJumpConnections()
end

local function stopHoldJump()
    S.holdJumpEnabled = false
    S.holdJumpMode = false
    stopHoldJumpConnections()
end

TP_DOWN_MODE = "full"
S.tpDownHeightTrigger = tonumber(S.tpDownHeightTrigger) or 20

local function tpIsCarryingBrainrot(character)
    if not character then return false end
    if LP:GetAttribute("Stealing") == true or character:GetAttribute("Stealing") == true then return true end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if not (name:find("bat") or name:find("slap")) then return true end
        end
    end
    return false
end

local function runTPDownFull()
    pcall(function()
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        local worldPosition = root.Position
        if worldPosition.Y <= -7 then
            root.CFrame = CFrame.new(worldPosition.X, -7, worldPosition.Z)
            root.AssemblyLinearVelocity = Vector3.zero
            return
        end

        local rootOffset = (humanoid.HipHeight or 2) + root.Size.Y * 0.5 + 0.2
        local ignoredNames = {"invis", "wall", "trigger", "barrier", "clip", "ghost"}

        local function hasIgnoredName(instance)
            while instance and instance ~= workspace do
                local name = string.lower(instance.Name or "")
                for _, ignored in ipairs(ignoredNames) do
                    if name:find(ignored, 1, true) then return true end
                end
                instance = instance.Parent
            end
            return false
        end

        local function shouldSkip(instance)
            if instance == workspace.Terrain then return false end
            if not instance or not instance:IsA("BasePart") then return true end
            if not instance.CanCollide then return true end
            if (instance.Transparency or 0) >= 0.75 then return true end
            if (instance.LocalTransparencyModifier or 0) >= 0.75 then return true end
            return hasIgnoredName(instance)
        end

        local function findFloorY(origin)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.IgnoreWater = true
            local filter = {character}
            for _ = 1, 80 do
                params.FilterDescendantsInstances = filter
                local hit = workspace:Raycast(origin, Vector3.new(0, -7 - origin.Y, 0), params)
                if not hit then return nil end
                if not shouldSkip(hit.Instance) then return hit.Position.Y end
                table.insert(filter, hasIgnoredName(hit.Instance) and hit.Instance.Parent or hit.Instance)
            end
            return nil
        end

        local radius = math.max(0.75, math.min(2, math.max(root.Size.X, root.Size.Z) * 0.55))
        local offsets = {
            Vector3.zero,
            Vector3.new(radius, 0, 0), Vector3.new(-radius, 0, 0),
            Vector3.new(0, 0, radius), Vector3.new(0, 0, -radius),
            Vector3.new(radius * 0.7, 0, radius * 0.7),
            Vector3.new(-radius * 0.7, 0, radius * 0.7),
            Vector3.new(radius * 0.7, 0, -radius * 0.7),
            Vector3.new(-radius * 0.7, 0, -radius * 0.7),
        }

        local floorY = findFloorY(worldPosition + Vector3.new(0, 0.25, 0))
        if not floorY then
            for i = 2, #offsets do
                local candidate = findFloorY(worldPosition + offsets[i] + Vector3.new(0, 0.25, 0))
                if candidate and (not floorY or candidate > floorY) then floorY = candidate end
            end
        end

        local targetY = -7
        if floorY then
            local candidateY = floorY + rootOffset
            if worldPosition.Y - 0.35 <= candidateY then return end
            targetY = math.max(candidateY, -7)
        end

        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = CFrame.new(worldPosition.X, targetY, worldPosition.Z) * CFrame.Angles(0, yaw, 0)
        root.AssemblyLinearVelocity = Vector3.zero
    end)
end

local function executeTPDown()
    if S.dropBrainrotActive or _G.IsDropping then return end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not root or not humanoid or humanoid.Health <= 0 or root.Anchored or humanoid.Sit or humanoid.SeatPart then return end
    if TP_DOWN_MODE == "full" then runTPDownFull() end
end

_G._VynxRunTPDown = executeTPDown

-- Yout visual features: Vivid Graphics, Stretch Rez, and Sky Theme.
local function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

local function enableStretch()
    if S.stretchConn then return end
    S.stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    S.origFOV = cam.FieldOfView or 70
    applyStretchFOV(S.stretchFOV)
    S.stretchConn = RunService.RenderStepped:Connect(function()
        if not S.stretchEnabled then
            S.stretchConn:Disconnect()
            S.stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if S.stretchFovConn then S.stretchFovConn:Disconnect() end
    S.stretchFovConn = RunService.RenderStepped:Connect(function()
        if S.stretchEnabled then applyStretchFOV(S.stretchFOV)
        else S.stretchFovConn:Disconnect(); S.stretchFovConn = nil end
    end)
end

local function disableStretch()
    S.stretchEnabled = false
    if S.stretchConn then S.stretchConn:Disconnect(); S.stretchConn = nil end
    if S.stretchFovConn then S.stretchFovConn:Disconnect(); S.stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = S.origFOV or 70 end) end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

local function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

local function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        S.skyTheme = "Off"
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    S.skyTheme = mode
end

local function enableVividGraphics()
    if S.vividGraphicsEnabled and #S.vividEffects > 0 then return end
    S.vividGraphicsEnabled = true
    for _, eff in ipairs(S.vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    S.vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    table.insert(S.vividEffects, color)
    local bloom = Instance.new("BloomEffect")
    bloom.Parent = Lighting
    bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 1
    table.insert(S.vividEffects, bloom)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3; atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(220, 220, 225)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2; atmosphere.Haze = 1
    table.insert(S.vividEffects, atmosphere)
    local sun = Instance.new("SunRaysEffect")
    sun.Parent = Lighting
    sun.Intensity = 0.2; sun.Spread = 0.8
    table.insert(S.vividEffects, sun)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Parent = Lighting
    dof.FocusDistance = 25; dof.InFocusRadius = 10
    dof.NearIntensity = 0.2; dof.FarIntensity = 0.4
    table.insert(S.vividEffects, dof)
    task.spawn(function()
        while S.vividGraphicsEnabled and color and color.Parent do
            color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
            task.wait(0.03)
        end
    end)
end

local function disableVividGraphics()
    S.vividGraphicsEnabled = false
    for _, eff in ipairs(S.vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    S.vividEffects = {}
end

local function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveConfig()
end


YF = {}
-- Yout-to-SMK ports: Anti Fling, Lock Enemy, Anim Pack, and Anti Lag.
-- Anti Fling and Lock Enemy, adapted to SMK's state and movement system.
YF.antiFlingState = {connection = nil, threshold = 80, spinThreshold = 40}
function YF.startAntiFling()
    S.antiFlingEnabled = true
    if YF.antiFlingState.connection then return end
    YF.antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not S.antiFlingEnabled then return end
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end
        if S._youtResetInProgress or S.dropBrainrotActive or _G.IsDropping then return end
        if S.autoLeftEnabled or S.autoRightEnabled or S.batAimbotEnabled or S.batBypassEnabled or S.bodyLockEnabled then return end
        local velocity = root.AssemblyLinearVelocity
        if Vector3.new(velocity.X, 0, velocity.Z).Magnitude > YF.antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > YF.antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end
function YF.stopAntiFling()
    S.antiFlingEnabled = false
    if YF.antiFlingState.connection then YF.antiFlingState.connection:Disconnect(); YF.antiFlingState.connection = nil end
end

function YF.getClosestTargetBody()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local otherCharacter = player.Character
            local targetRoot = otherCharacter and otherCharacter:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = otherCharacter and otherCharacter:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < minDistance then closest, minDistance = targetRoot, distance end
            end
        end
    end
    return closest
end

function YF.bodyLockTick()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    if S.batBypassEnabled then return end
    if S._youtResetInProgress or S.dropBrainrotActive or S.autoLeftEnabled or S.autoRightEnabled or S.batAimbotEnabled then
        if not humanoid.AutoRotate then humanoid.AutoRotate = true end
        return
    end
    local target = YF.getClosestTargetBody()
    if not target or (target.Position - root.Position).Magnitude > S.bodyLockRange then
        if not humanoid.AutoRotate then humanoid.AutoRotate = true end
        return
    end
    if humanoid.AutoRotate then humanoid.AutoRotate = false end
    local targetVelocity = target.AssemblyLinearVelocity
    local predictTime = math.clamp(targetVelocity.Magnitude / 80, 0.08, 0.35)
    local predictedPosition = target.Position + targetVelocity * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (humanoid.HipHeight or 0)
    local verticalCorrection = math.clamp((targetHeight - myHeight) * 0.15, -1.5, 1.5)
    local lookPosition = Vector3.new(predictedPosition.X, root.Position.Y + verticalCorrection, predictedPosition.Z)
    if (lookPosition - root.Position).Magnitude > 0.1 then
        local goal = CFrame.lookAt(root.Position, lookPosition)
        local relative = root.CFrame:Inverse() * goal
        local _, yaw = relative:ToEulerAnglesXYZ()
        yaw = math.clamp(yaw, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, yaw * 42, 0))
    end
end
function YF.startBodyLock()
    S.bodyLockEnabled = true
    if S.bodyLockConnection then return end
    local accumulator = 0
    S.bodyLockConnection = RunService.Heartbeat:Connect(function(dt)
        if not S.bodyLockEnabled then return end
        accumulator = accumulator + dt
        if accumulator < 0.033 then return end
        accumulator = 0
        YF.bodyLockTick()
    end)
end
function YF.stopBodyLock()
    S.bodyLockEnabled = false
    if S.bodyLockConnection then S.bodyLockConnection:Disconnect(); S.bodyLockConnection = nil end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
end

YF.ANIM_PACKS = {
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

YF.ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

function YF.isPackAnim(id)
    for _, pack in pairs(YF.ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

function YF.saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not YF.isPackAnim(ids.walk) then S.originalAnimPack = ids end
end

function YF.applyAnimPack(packName)
    S.currentAnimPack = packName
    if S.animSelectorLabel then S.animSelectorLabel.Text = packName end
    if packName == "Off" then
        if S.originalAnimPack and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj and id then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, S.originalAnimPack.idle1)
                s(animate.idle and animate.idle.Animation2, S.originalAnimPack.idle2)
                s(animate.walk and animate.walk.WalkAnim, S.originalAnimPack.walk)
                s(animate.run  and animate.run.RunAnim,   S.originalAnimPack.run)
                s(animate.jump and animate.jump.JumpAnim, S.originalAnimPack.jump)
                s(animate.fall and animate.fall.FallAnim, S.originalAnimPack.fall)
                s(animate.climb and animate.climb.ClimbAnim, S.originalAnimPack.climb)
                s(animate.swim and animate.swim.Swim, S.originalAnimPack.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, S.originalAnimPack.swimidle)
            end
        end
        if S.animPackConnection then S.animPackConnection:Disconnect(); S.animPackConnection = nil end
        return
    end
    local pack = YF.ANIM_PACKS[packName]
    if not pack then return end
    if S.animPackConnection then S.animPackConnection:Disconnect() end
    local observedCharacter, capturedCharacter = nil, nil
    S.animPackConnection = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        if c ~= observedCharacter then observedCharacter, capturedCharacter = c, nil end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        if capturedCharacter ~= c then
            YF.saveOriginalAnims(c)
            capturedCharacter = c
        end
        if not animate then return end
        local function s(obj,id) if obj and id then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run  and animate.run.RunAnim,   pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

function YF.startAnimPack(packName)
    local char = LP.Character
    if char then
        YF.saveOriginalAnims(char)
        YF.applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        YF.applyAnimPack(packName)
    end
    S.currentAnimPack = packName
end

function YF.stopAnimPack()
    S.currentAnimPack = "Off"
    if S.animSelectorLabel then S.animSelectorLabel.Text = "Off" end
    YF.applyAnimPack("Off")
end

YF._alSaved = setmetatable({}, { __mode = "k" })
YF._alDetached = {}
YF._alAnimators = setmetatable({}, { __mode = "k" })
YF._alStoppedTracks = setmetatable({}, { __mode = "k" })
YF._alGeneration = 0
YF._alScanCancel = nil
YF._alConns = {}
YF._alLightOrig = nil
YF._alWorldOrig = {}
YF._alFlagOriginals = {}
YF._alRunning = false

-- TRIPA adaptado: somente ajustes gráficos reversíveis, sem FPS 9999,
-- alterações de rede/physics, Destroy de objetos ou varreduras repetidas.
YF.TRIPA_FLAGS = {
    {"FFlagDisablePostFx", "True"},
    {"FFlagDisablePostProcess", "True"},
    {"FIntRenderGrassDetailStrands", "0"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"FIntRenderShadowIntensity", "0"},
    {"FFlagFastGPULightCulling3", "True"},
    {"DFFlagTextureQualityOverrideEnabled", "True"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntTextureQualityLevel", "0"},
    {"FFlagRemoveGlobalShadows", "True"},
    {"FFlagRenderShadowSkip", "True"},
    {"DFIntShadowMapSize", "1"},
    {"FFlagDebugDisableParticles", "True"},
    {"FIntParticleCount", "0"},
    {"DFIntMaxParticleCount", "0"},
    {"FIntMaxParticlesPerEmitter", "0"},
    {"DFIntGrassMaxDistance", "0"},
    {"FIntGrassDetail", "0"},
    {"FFlagGrassRendering", "False"},
    {"FFlagWaterReflection", "False"},
    {"FFlagWaterRefraction", "False"},
}
YF.AL_LOW_FLAGS = {
    {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
    {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
    {"DFIntServerFramesBetweenJoins", "1"},
    {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
    {"DFIntConnectionMTUSize", "1400"},
    {"FIntRakNetResendBufferArrayLength", "1024"},
    {"DFIntRakNetNakResendDelayMsMax", "1"},
    {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
    {"DFIntWaitOnRecvFromLoopEndedMS", "100"},
    {"DFIntLargePacketQueueSizeCutoffMB", "1000"},
    {"DFIntSendRakNetStatsInterval", "2147483647"},
    {"DFIntRakNetLoopMs", "1"},
    {"DFIntRakNetSelectTimeoutMs", "1"},
    {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
    {"DFIntReplicationDataCacheNumParallelTasks", "8"},
    {"DFIntMegaReplicatorNumParallelTasks", "16"},
    {"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
    {"DFIntMaxProcessPacketsStepsAccumulated", "0"},
    {"DFIntMaxProcessPacketsJobScaling", "1000"},
    {"DFIntClientPacketMaxFrameMicroseconds", "200000"},
    {"DFIntClientPacketExcessMicroseconds", "10000"},
    {"DFIntClientPacketMinMicroseconds", "1"},
    {"DFIntClientPacketMaxDelayMs", "1"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
    {"DFIntMaxFrameBufferSize", "4"},
    {"DFIntBufferCompressionThreshold", "100"},
    {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
    {"DFIntTaskSchedulerJobInitThreads", "8"},
    {"DFIntTaskSchedulerJobInGameThreads", "8"},
    {"FIntTaskSchedulerAutoThreadLimit", "16"},
    {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
    {"DFIntRuntimeConcurrency", "16"},
    {"FIntSimWorldTaskQueueParallelTasks", "20"},
    {"DFIntHttpBatchLimit", "256"},
    {"FIntHttpBatchLimit", "256"},
    {"DFIntHttpCurlConnectionCacheSize", "512"},
    {"FIntDefaultMeshCacheSizeMB", "512"},
    {"DFIntMemCacheMaxCapacityMB", "256"},
    {"DFIntNumAssetsMaxToPreload", "1"},
    {"DFFlagEnableSoundPreloading", "false"},
    {"FFlagSlimContentProvider", "true"},
    {"DFFlagDebugSkipMeshVoxelizer", "true"},
    {"DFFlagTextureQualityOverrideEnabled", "true"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntDebugTextureManagerSkipMips", "7"},
    {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
    {"FFlagTM2SkipMipsForUnstreamable2", "true"},
    {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
    {"FFlagRenderUseTextureManager224", "false"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"DFFlagDebugPauseVoxelizer", "true"},
    {"FFlagFastGPULightCulling3", "true"},
    {"FIntRenderLocalLightFadeInMs", "0"},
    {"FIntRenderLocalLightUpdatesMax", "1"},
    {"FIntRenderShadowmapBias", "0"},
    {"FIntSSAOMipLevels", "0"},
    {"FIntDebugForceMSAASamples", "1"},
    {"FIntDebugFRMOptionalMSAALevelOverride", "0"},
    {"FIntRobloxGuiBlurIntensity", "0"},
    {"FIntFRMMinGrassDistance", "0"},
    {"FIntFRMMaxGrassDistance", "0"},
    {"DFFlagCoreScriptTelemetry2", "false"},
    {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
    {"FFlagPerfDataOnTelemetryV2", "false"},
    {"FFlagSendRenderFidelityTelemetry2", "false"},
    {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
    {"DFIntTelemetryProfilerHundredthsPercentage", "0"},
    {"FIntTelemetryProfilerFrequency", "0"},
    {"FIntPerformanceTelemetryQueueProcessLimit", "0"},
    {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
}

function YF._alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    -- Only change flags when the original values can also be queried and restored.
    if type(setter) ~= "function" or type(getter) ~= "function" then return end
    for _, flag in ipairs(S.optimizerMode == "tripa" and YF.TRIPA_FLAGS or YF.AL_LOW_FLAGS) do
        local ok, current = pcall(getter, flag[1])
        if ok and current ~= nil then
            if YF._alFlagOriginals[flag[1]] == nil then
                YF._alFlagOriginals[flag[1]] = tostring(current)
            end
            pcall(setter, flag[1], tostring(flag[2]))
        end
    end
end

function YF._alSaveLighting()
    if YF._alLightOrig then return end
    YF._alLightOrig = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        GlobalShadows = Lighting.GlobalShadows,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
    }
end

function YF._alApplyLowPermanentSettings()
    if next(YF._alWorldOrig) == nil then
        pcall(function() YF._alWorldOrig.renderQuality = settings().Rendering.QualityLevel end)
        pcall(function() YF._alWorldOrig.savedQuality = UserSettings():GetService("UserGameSettings").SavedQualityLevel end)
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            YF._alWorldOrig.terrainObject = terrain
            YF._alWorldOrig.terrain = {
                Decoration = terrain.Decoration, WaterWaveSize = terrain.WaterWaveSize,
                WaterWaveSpeed = terrain.WaterWaveSpeed, WaterReflectance = terrain.WaterReflectance,
                WaterTransparency = terrain.WaterTransparency,
            }
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then YF._alWorldOrig.cloudsObject = clouds; YF._alWorldOrig.cloudsEnabled = clouds.Enabled end
        end
        YF._alWorldOrig.atmospheres = {}
        for _, atmosphere in ipairs(Lighting:GetChildren()) do
            if atmosphere:IsA("Atmosphere") then
                YF._alWorldOrig.atmospheres[atmosphere] = {
                    Density = atmosphere.Density, Glare = atmosphere.Glare, Haze = atmosphere.Haze,
                }
            end
        end
    end
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e10
    end)
    pcall(function()
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
        end
    end)
end

function YF._alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = YF._alSaved[object]
        if not bucket then bucket = {}; YF._alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

function YF._alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    if object:GetAttribute("_AdaptDuelsSky") then return true end
    for _, effect in ipairs(S.vividEffects or {}) do if effect == object then return true end end
    local parent = object
    while parent and parent ~= workspace do
        if S.optimizerMode == "tripa" then
            -- Mantém personagens (incluindo outros jogadores) e beams do hub.
            if parent:IsA("Model") and parent:FindFirstChildOfClass("Humanoid") then return true end
            if parent.Name:match("^PlotBeam") or parent.Name:match("^BrainrotBeam")
                or parent.Name == "HighestValueBeam" or parent.Name == "BaseLineBeam" then return true end
        end
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^BloodHounds") or name:match("^Yout") or name:match("^SMK") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

function YF.applyAntiLagDerender(obj)
    pcall(function()
        if not YF._alRunning then return end
        if YF._alIsProtectedVisual(obj) then return end
        if S.optimizerMode == "tripa" and (obj:IsA("Sky") or obj:IsA("Shirt")
            or obj:IsA("Pants") or obj:IsA("ShirtGraphic")) then return end

        if obj:IsA("Terrain") then
            YF._alChange(obj, "Decoration", false)
            YF._alChange(obj, "WaterWaveSize", 0)
            YF._alChange(obj, "WaterWaveSpeed", 0)
            YF._alChange(obj, "WaterReflectance", 0)
            YF._alChange(obj, "WaterTransparency", S.optimizerMode == "tripa" and 0 or 1)
        end
        if obj:IsA("BasePart") then
            YF._alChange(obj, "Material", Enum.Material.Plastic)
            YF._alChange(obj, "MaterialVariant", "")
            YF._alChange(obj, "Reflectance", 0)
            YF._alChange(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                YF._alChange(obj, "TextureID", "")
                YF._alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                YF._alChange(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                YF._alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            YF._alChange(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            YF._alDetached[obj] = true
            YF._alChange(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            YF._alChange(obj, "Transparency", 1)
            YF._alChange(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            YF._alChange(obj, "Enabled", false)
            YF._alChange(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            YF._alChange(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("PostEffect")
            or obj:IsA("Clouds") then
            YF._alChange(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            YF._alChange(obj, "Density", 0)
            YF._alChange(obj, "Haze", 0)
            YF._alChange(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"}) do
                YF._alChange(obj, face, "")
            end
            YF._alChange(obj, "StarCount", 0)
            YF._alChange(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            YF._alChange(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            YF._alChange(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            YF._alChange(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            if not YF._alAnimators[obj] then
                local char = LP.Character
                if not (char and obj:IsDescendantOf(char)) then
                    YF._alAnimators[obj] = true
                    local token = YF._alGeneration
                    local ok, conn = pcall(function()
                        return obj.AnimationPlayed:Connect(function(track)
                            if not YF._alRunning or YF._alGeneration ~= token then return end
                            task.defer(function()
                                if YF._alRunning and YF._alGeneration == token then
                                    pcall(function()
                                        if track.IsPlaying and not YF._alStoppedTracks[track] then
                                            YF._alStoppedTracks[track] = {animator = obj, time = track.TimePosition, speed = track.Speed}
                                        end
                                        track:Stop(0)
                                    end)
                                end
                            end)
                        end)
                    end)
                    if ok then table.insert(YF._alConns, conn) end
                    pcall(function()
                        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                            if track.IsPlaying then
                                YF._alStoppedTracks[track] = {
                                    animator = obj,
                                    time = track.TimePosition,
                                    speed = track.Speed,
                                }
                                track:Stop(0)
                            end
                        end
                    end)
                end
            end
        end
    end)
end

function YF.enableAntiLag()
    if YF._alRunning then return end
    YF._alRunning = true
    S.antiLagEnabled = true
    YF._alGeneration = YF._alGeneration + 1
    local token = YF._alGeneration

    YF._alSaveLighting()
    YF._alApplyLowFlags()
    YF._alApplyLowPermanentSettings()
    if S.optimizerMode == "tripa" then
        YF._alChange(Lighting, "Brightness", 3)
        YF._alChange(Lighting, "Ambient", Color3.fromRGB(255, 255, 255))
        YF._alChange(Lighting, "OutdoorAmbient", Color3.fromRGB(255, 255, 255))
        YF._alChange(Lighting, "ShadowSoftness", 0)
        YF._alChange(Lighting, "ClockTime", 0)
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then YF._alChange(terrain, "WaterTransparency", 0) end
    end

    table.insert(YF._alConns, workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if YF._alRunning and YF._alGeneration == token then
                pcall(YF.applyAntiLagDerender, obj)
            end
        end)
    end))
    table.insert(YF._alConns, Lighting.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if YF._alRunning and YF._alGeneration == token then
                pcall(YF.applyAntiLagDerender, obj)
            end
        end)
    end))

    local function walkBatched(roots, apply, shouldContinue)
        task.spawn(function()
            local pending = {}
            for _, root in ipairs(roots) do
                if root then
                    local ok, children = pcall(function() return root:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
            end
            while #pending > 0 and YF._alRunning and YF._alGeneration == token and shouldContinue() do
                local deadline = os.clock() + 0.0008
                while #pending > 0 and os.clock() < deadline do
                    local obj = table.remove(pending)
                    pcall(apply, obj)
                    local ok, children = pcall(function() return obj:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end

    walkBatched({workspace, Lighting}, YF.applyAntiLagDerender, function()
        return YF._alRunning and YF._alGeneration == token
    end)
end

function YF.disableAntiLag()
    if not YF._alRunning then
        S.antiLagEnabled = false
        return
    end
    YF._alRunning = false
    S.antiLagEnabled = false
    YF._alGeneration = YF._alGeneration + 1

    if YF._alScanCancel then pcall(YF._alScanCancel); YF._alScanCancel = nil end

    for _, conn in ipairs(YF._alConns) do pcall(function() conn:Disconnect() end) end
    YF._alConns = {}

    for object, properties in pairs(YF._alSaved) do
        for property, original in pairs(properties) do
            pcall(function() object[property] = original.value end)
        end
    end
    YF._alSaved = setmetatable({}, { __mode = "k" })
    YF._alDetached = {}
    YF._alAnimators = setmetatable({}, { __mode = "k" })

    for track, state in pairs(YF._alStoppedTracks) do
        pcall(function()
            if state.animator.Parent and not track.IsPlaying then
                track:Play(0, 1, state.speed)
                track.TimePosition = state.time
            end
        end)
    end
    YF._alStoppedTracks = setmetatable({}, { __mode = "k" })

    if YF._alLightOrig then
        pcall(function()
            Lighting.Brightness = YF._alLightOrig.Brightness
            Lighting.ClockTime = YF._alLightOrig.ClockTime
            Lighting.OutdoorAmbient = YF._alLightOrig.OutdoorAmbient
            Lighting.Ambient = YF._alLightOrig.Ambient
            Lighting.GlobalShadows = YF._alLightOrig.GlobalShadows
            Lighting.EnvironmentDiffuseScale = YF._alLightOrig.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = YF._alLightOrig.EnvironmentSpecularScale
            Lighting.FogStart = YF._alLightOrig.FogStart
            Lighting.FogEnd = YF._alLightOrig.FogEnd
        end)
    end
    pcall(function()
        if YF._alWorldOrig.renderQuality ~= nil then settings().Rendering.QualityLevel = YF._alWorldOrig.renderQuality end
        if YF._alWorldOrig.savedQuality ~= nil then UserSettings():GetService("UserGameSettings").SavedQualityLevel = YF._alWorldOrig.savedQuality end
        local terrain, state = YF._alWorldOrig.terrainObject, YF._alWorldOrig.terrain
        if terrain and terrain.Parent and state then
            for property, value in pairs(state) do terrain[property] = value end
        end
        local clouds = YF._alWorldOrig.cloudsObject
        if clouds and clouds.Parent and YF._alWorldOrig.cloudsEnabled ~= nil then clouds.Enabled = YF._alWorldOrig.cloudsEnabled end
        for atmosphere, values in pairs(YF._alWorldOrig.atmospheres or {}) do
            if atmosphere.Parent then for property, value in pairs(values) do atmosphere[property] = value end end
        end
    end)
    YF._alWorldOrig = {}
    YF._alLightOrig = nil
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    if type(setter) == "function" then
        for name, value in pairs(YF._alFlagOriginals) do pcall(setter, name, value) end
    end
    YF._alFlagOriginals = {}
end

function YF.setOptimizer(mode, enabled)
    if YF._alRunning and (not enabled or S.optimizerMode ~= mode) then YF.disableAntiLag() end
    if enabled then S.optimizerMode = mode; YF.enableAntiLag() end
    if S.setAntiLagVisual then S.setAntiLagVisual(S.antiLagEnabled and S.optimizerMode == "standard") end
    if S.setTripaVisual then S.setTripaVisual(S.antiLagEnabled and S.optimizerMode == "tripa") end
end

saveConfig = function()
    pcall(function()
        local function ks(e)
            return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil}
        end
        local cfg = {
            keybindVersion = 1,
            userMenuScale = S.userMenuScale or 1,
            userMobileScale = S.userMobileScale or 1,
            normalSpeed = S.NS, carrySpeed = S.CS, laggerSpeed = S.LS, laggerCarrySpeed = S.LCS,
            hubColor = S.hubColor,
            optimizerMode = S.optimizerMode,
            mobileButtonStyle = S.mobileButtonStyle,
            hubTitleFont = SMKBrandStyle.fontMode,
            medusaSkin = S.medusaSkinMode or "Off",
            laggerMode = S.speedMode and 0 or S.laggerMode,
            tpDownHeightTrigger = S.tpDownHeightTrigger,
            dropMode = S.dropMode,
            dropBrainrotKey = ks(S.KB.DropBrainrot), autoLeftKey = ks(S.KB.AutoLeft),
            autoRightKey = ks(S.KB.AutoRight), autoBatKey = ks(S.KB.AutoBat),
            batBypassKey = ks(S.KB.BatBypass),
            informationE01 = S.informationE01Enabled,
            tpFloorKey = ks(S.KB.TPFlor), guiHideKey = ks(S.KB.GuiHide),
            speedToggleKey = ks(S.KB.SpeedToggle), laggerToggleKey = ks(S.KB.LaggerToggle),
            grabRadius = S.Steal.StealRadius, antiRagdoll = S.antiRagdollEnabled,
            autoStealEnabled = S.stealActive,
            medusaCounter = S.medusaCounterEnabled, carryMode = S.speedMode,
            batAimbot = S.batAimbotEnabled,
            batBypassVersion = S.batBypassVersion or "v5",
            batBypassSpeed = S.batBypassSpeed or 58,
            batSkin = S.batSkinMode,
            displaySkin = S.displaySkin,
            customSkin = S.customSkinEnabled,
            espEnabled = S.espEnabled,
            unwalkEnabled = S.unwalkEnabled,
            lockUI = S.lockUIEnabled, fpsBoost = S.fpsBoostEnabled,
            vividGraphics = S.vividGraphicsEnabled,
            stretchEnabled = S.stretchEnabled, stretchFOV = S.stretchFOV,
            skyTheme = S.skyTheme,
            krobloxMode = S.krobloxMode,
            antiFling = S.antiFlingEnabled,
            lockEnemy = S.bodyLockEnabled, lockEnemyRange = S.bodyLockRange,
            animPack = S.currentAnimPack,
            antiLag = S.antiLagEnabled,
            hideOpiumButtons = S.hideOpiumButtonsEnabled or false,
            holdJumpEnabled = S.holdJumpEnabled,
            antiDrop = S.antiDropEnabled,
            antiDie = S.antiDieEnabled,
            batCounter = S.batCounterEnabled,
            stealDuration = S.Steal.StealDuration,
            mobileButtonPositions = S.mobileButtonPositions,
            lockMobileButtons = S.lockMobileButtons,
            floatingFreeButtonPositions = S.floatingFreeButtonPositions,
            mainMenuPos = S.menuOpenPosition and {
                XS = S.menuOpenPosition.X.Scale, X = S.menuOpenPosition.X.Offset,
                YS = S.menuOpenPosition.Y.Scale, Y = S.menuOpenPosition.Y.Offset,
            } or nil,
            floatingPanelPos = S.floatingPanelFrame and {
                XS = S.floatingPanelFrame.Position.X.Scale, X = S.floatingPanelFrame.Position.X.Offset,
                YS = S.floatingPanelFrame.Position.Y.Scale, Y = S.floatingPanelFrame.Position.Y.Offset,
            } or nil,
            stealHudPos = S.stealHudCard and {
                XS = S.stealHudCard.Position.X.Scale, X = S.stealHudCard.Position.X.Offset,
                YS = S.stealHudCard.Position.Y.Scale, Y = S.stealHudCard.Position.Y.Offset,
            } or nil,
        }
        local ok, data = pcall(function() return HS:JSONEncode(cfg) end)
        if ok and data then safeWritefile(S.CONFIG_FILE, data) end
    end)
end

task.spawn(function()
    while task.wait(10) do
        saveConfig()
    end
end)

local function resetFloatingPanel()
    S.editMobileButtons = false
    if S.setEditMobileButtonsVisual then S.setEditMobileButtonsVisual(false) end
    if S.refreshMobileEditMode then S.refreshMobileEditMode() end
    S.mobileButtonPositions = {}
    S.floatingFreeButtonPositions = {}
    if S.floatingPanelFrame then
        S.floatingPanelFrame.Position = UDim2.new(0.79, 0, 0, 0)
    end
    if S._floatingFreeButtonLayer then
        S._floatingFreeButtonLayer.Position = UDim2.new(0.79, 0, 0, 0)
    end
    if S.stealHudCard then
        S.stealHudCard.Position = UDim2.new(0.5, -150, 1, -75)
    end
    for _, info in ipairs(S._floatingButtonInfos or {}) do
        info.userMoved = false
    end
    if S._floatingUpdateLayout then pcall(S._floatingUpdateLayout) end
    saveConfig()
end

-- Visual-only progress targets; gameplay timing stays unchanged.
S.setProgressVisual = function(value)
    value = math.clamp(value, 0, 1)
    S.progressVisualTarget = value
    if value >= 1 then
        S.progressVisualCompleteUntil = os.clock() + 0.12
    end
end

local function resetProgressBar()
    S.setProgressVisual(0)
    -- Bar always stays visible; just reset fill width
end

AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled or not S.antiRagdollEnabled then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root then return end
        if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end

        local state = humanoid:GetState()
        local now = tick()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                -- Disparar el contador antes de que V2 cambie el estado a GettingUp.
                if triggerBatCounter then triggerBatCounter(character) end
                pcall(function()
                    if humanoid:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if humanoid.Health <= 0 or humanoid:GetState() == Enum.HumanoidStateType.Dead then return end
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = Vector3.zero
                    root.RotVelocity = Vector3.zero
                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    for _, obj in ipairs(character:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    local camera = workspace.CurrentCamera
                    if camera then camera.CameraSubject = humanoid end
                    local playerScripts = LP:FindFirstChild("PlayerScripts")
                    local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
                    local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
                    if controlModule then
                        local controls = require(controlModule)
                        if controls and controls.Enable then controls:Enable() end
                    end
                    humanoid.AutoRotate = true
                    humanoid.PlatformStand = false
                    humanoid.Sit = false
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

startAntiRagdoll = function()
    startAntiRagdollV2()
end

stopAntiRagdoll = function()
    stopAntiRagdollV2()
end

local function toggleAntiRag(on)
    S.antiRagdollEnabled = (on == true)
    if S.antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
end

savedAnimate = nil

local function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            t:Stop()
        end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        if not savedAnimate then
            savedAnimate = anim:Clone()
        end
        anim:Destroy()
    end
    S.unwalkEnabled = true
end

local function stopUnwalk()
    if not S.unwalkEnabled then return end
    S.unwalkEnabled = false
    local c = LP.Character
    if c and savedAnimate then
        local existing = c:FindFirstChild("Animate")
        if existing and existing ~= savedAnimate then existing:Destroy() end
        savedAnimate.Parent = c
        savedAnimate.Disabled = false
        savedAnimate = nil
    end
end

POS = S.AP

function stopAutoLeft()
    if S.alConn then S.alConn:Disconnect(); S.alConn = nil end
    S.alPhase = 1
    local c = LP.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
end

function stopAutoRight()
    if S.arConn then S.arConn:Disconnect(); S.arConn = nil end
    S.arPhase = 1
    local c = LP.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if S.autoRightSetVisual then S.autoRightSetVisual(false) end
end

function startAutoLeft()
    if S.batBypassEnabled and S.setBatBypass then S.setBatBypass(false) end
    if S.alConn then S.alConn:Disconnect() end
    S.alPhase = 1
    S.alConn = RunService.Heartbeat:Connect(function()
        if not S.autoLeftEnabled or S._youtResetInProgress then return end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if isSpeedRagdollState(hum) then
            hum:Move(Vector3.zero, false)
            return
        end
        local spd = S.getAutoPathSpeed()
        if S.alPhase == 1 then
            local tgt = Vector3.new(POS.L1.X, root.Position.Y, POS.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                S.alPhase = 2
                local d = POS.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
                return
            end
            local d = POS.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        elseif S.alPhase == 2 then
            local tgt = Vector3.new(POS.L2.X, root.Position.Y, POS.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.Velocity = Vector3.zero
                S.autoLeftEnabled = false
                if S.alConn then S.alConn:Disconnect(); S.alConn = nil end
                S.alPhase = 1
                if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
                if S._setPButtonActive and S._btnAAL then
                    S._setPButtonActive(S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL, false)
                end
                task.defer(S.startMovement)
                return
            end
            local d = POS.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        end
    end)
end

function startAutoRight()
    if S.batBypassEnabled and S.setBatBypass then S.setBatBypass(false) end
    if S.arConn then S.arConn:Disconnect() end
    S.arPhase = 1
    S.arConn = RunService.Heartbeat:Connect(function()
        if not S.autoRightEnabled or S._youtResetInProgress then return end
        local c = LP.Character; if not c then return end
        local root = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end
        if isSpeedRagdollState(hum) then
            hum:Move(Vector3.zero, false)
            return
        end
        local spd = S.getAutoPathSpeed()
        if S.arPhase == 1 then
            local tgt = Vector3.new(POS.R1.X, root.Position.Y, POS.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                S.arPhase = 2
                local d = POS.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
                return
            end
            local d = POS.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        elseif S.arPhase == 2 then
            local tgt = Vector3.new(POS.R2.X, root.Position.Y, POS.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.Velocity = Vector3.zero
                S.autoRightEnabled = false
                if S.arConn then S.arConn:Disconnect(); S.arConn = nil end
                S.arPhase = 1
                if S.autoRightSetVisual then S.autoRightSetVisual(false) end
                if S._setPButtonActive and S._btnAAR then
                    S._setPButtonActive(S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR, false)
                end
                task.defer(S.startMovement)
                return
            end
            local d = POS.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.Velocity = Vector3.new(mv.X * spd, root.Velocity.Y, mv.Z * spd)
        end
    end)
end

-- Auto Path must never keep steering a new character after any reset/respawn.
LP.CharacterRemoving:Connect(function()
    S.autoLeftEnabled = false
    S.autoRightEnabled = false
    pcall(stopAutoLeft)
    pcall(stopAutoRight)
    if S._setPButtonActive and S._btnAAL then
        pcall(S._setPButtonActive, S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL, false)
    end
    if S._setPButtonActive and S._btnAAR then
        pcall(S._setPButtonActive, S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR, false)
    end
    if S.stopMovement then pcall(S.stopMovement) end
end)

_bubbleBatAim = {
    targetPlayer = nil,
    lastTargetPos = nil,
    targetVelocity = Vector3.zero,
    smoothedVelocity = Vector3.zero,
    velocityHistory = {},
    accelerationHistory = {},
    aerialVelocityHistory = {},
    previousDirection = nil,
    lastDirectionChangeTime = 0,
    airborneTime = 0,
    lastActivationTime = 0,
    currentPing = 0.1,
    realPingMs = 0,
    lastPingCheck = 0,
}

BUBBLE_BAT_AIM = {
    ACTIVATE_DISTANCE = 13,
    MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.22,
    PREDICT_AHEAD = 3,
    MAX_VELOCITY_CHANGE = 150,
    VELOCITY_SMOOTHING = 0.2,
    MAX_HORIZONTAL_VELOCITY = 80,
    SERVER_TICKRATE = 1 / 60,
    MIN_PING_COMPENSATION = 0.03,
    MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
}
_batAimLastWarn = 0

local function bubbleAverage(list)
    if #list == 0 then return Vector3.zero end
    local sum = Vector3.zero
    for _, value in ipairs(list) do sum = sum + value end
    return sum / #list
end

local function bubblePush(list, value, maxCount)
    table.insert(list, value)
    if #list > maxCount then table.remove(list, 1) end
end

local function bubbleResetAimState()
    _bubbleBatAim.targetPlayer = nil
    _bubbleBatAim.lastTargetPos = nil
    _bubbleBatAim.targetVelocity = Vector3.zero
    _bubbleBatAim.smoothedVelocity = Vector3.zero
    _bubbleBatAim.velocityHistory = {}
    _bubbleBatAim.accelerationHistory = {}
    _bubbleBatAim.aerialVelocityHistory = {}
    _bubbleBatAim.previousDirection = nil
    _bubbleBatAim.airborneTime = 0
    _bubbleBatAim.lastActivationTime = 0
end

local function findAimbotBat(character)
    if not character then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    local function isBatTool(item)
        if not item or not item:IsA("Tool") then return false end
        local name = string.lower(item.Name)
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
    end
    for _, item in ipairs(character:GetChildren()) do
        if isBatTool(item) then return item end
    end
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if isBatTool(item) then return item end
        end
    end
    return nil
end

local function getAutoBatTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    if now - S._autoBatLastScan <= 0.1 and S._autoBatTarget and S._autoBatTarget.Parent then
        local hum = S._autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then return S._autoBatTarget end
    end
    S._autoBatLastScan = now
    S._autoBatTarget = nil
    local closest, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < minDist then
                    minDist = distance
                    closest = targetRoot
                end
            end
        end
    end
    S._autoBatTarget = closest
    return closest
end

_batAimPreviousAutoRotate = nil
S.resetAutoBatMotion = function()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.AutoRotate = true end
    _batAimPreviousAutoRotate = nil
end

local function enableAutoBat()
    if S.autoLeftEnabled then
        S.autoLeftEnabled = false
        if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if S.autoRightEnabled then
        S.autoRightEnabled = false
        if S.autoRightSetVisual then S.autoRightSetVisual(false) end
        stopAutoRight()
    end
    S.autoBatEquippedThisRun = false
    S.batAimbotEnabled = true
end

local function disableAutoBat()
    if S.batAimbotConn then
        S.batAimbotConn:Disconnect()
        S.batAimbotConn = nil
    end
    S.batAimbotEnabled = false
    S.autoBatEquippedThisRun = false
    S._autoBatTarget = nil
    bubbleResetAimState()
    S.resetAutoBatMotion()
end

local function queueAutoBatStart()
    enableAutoBat()
end

-- Funcionamento do Bat Aimbot do Empire; o visual e os atalhos do ＳＭＫㅤＨＵＢ são preservados.
function S.empireFindBatForAimbot() local char = LP.Character if not char then return nil end for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end local bp = LP:FindFirstChild("Backpack") if bp then for _, tool in ipairs(bp:GetChildren()) do if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end end end return nil end 
function startBatAimbot()
    if S.batBypassEnabled and S.setBatBypass then S.setBatBypass(false) end
    if S.batAimbotConn then
        S.batAimbotConn:Disconnect()
        S.batAimbotConn = nil
    end
    queueAutoBatStart()
    S._autoBatTarget = nil
    S._autoBatLastScan = 0
    S.batAimbotConn = RunService.Heartbeat:Connect(function() if not S.batAimbotEnabled then return end local char = LP.Character if not char then return end local root = char:FindFirstChild("HumanoidRootPart") if not root then return end local hum = char:FindFirstChildOfClass("Humanoid") if not hum then return end if not char:FindFirstChildOfClass("Tool") then local bat = S.empireFindBatForAimbot() if bat then pcall(function() hum:EquipTool(bat) end) end end local now = tick() local target = S._autoBatTarget if now - (S._autoBatLastScan or 0) > 0.1 or not target or not target.Parent then S._autoBatLastScan = now target = nil local closest, minDist = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LP and plr.Character then local tRoot = plr.Character:FindFirstChild("HumanoidRootPart") local th = plr.Character:FindFirstChildOfClass("Humanoid") if tRoot and th and th.Health > 0 then local dist = (tRoot.Position - root.Position).Magnitude if dist < minDist then minDist = dist closest = tRoot end end end end target = closest S._autoBatTarget = target else local th = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid") if not th or th.Health <= 0 then S._autoBatTarget = nil target = nil end end if not target then hum.AutoRotate = true root.AssemblyAngularVelocity = Vector3.zero return end hum.AutoRotate = false local targetVel = target.AssemblyLinearVelocity local myPos = root.Position local targetPos = target.Position local predictPos = targetPos + targetVel * 0.14 predictPos = predictPos + target.CFrame.LookVector * 0.3 local direction = predictPos - myPos local flatDir = Vector3.new(direction.X, 0, direction.Z) if flatDir.Magnitude > 0.01 then flatDir = flatDir.Unit else flatDir = Vector3.new(0, 0, 1) end local chaseSpeed = 58 local desiredHeight = targetPos.Y + 3.7 local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8 if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end yVel = math.clamp(yVel, -70, 110) local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed) root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8) local speed3 = targetVel.Magnitude local predictTime = math.clamp(speed3 / 150, 0.05, 0.2) local predictedPos = targetPos + targetVel * predictTime local toPredict = predictedPos - myPos if toPredict.Magnitude > 0.1 then local goalCF = CFrame.lookAt(myPos, predictedPos) local diffCF = root.CFrame:Inverse() * goalCF local rx, ry, rz = diffCF:ToEulerAnglesXYZ() rx = math.clamp(rx, -2.5, 2.5) ry = math.clamp(ry, -2.5, 2.5) rz = math.clamp(rz, -2.5, 2.5) root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42)) end if S.autoSwingEnabled then local bat = char:FindFirstChild("Bat") or S.empireFindBatForAimbot() if bat and bat:IsA("Tool") then pcall(function() bat:Activate() end) end end end) 
end

function stopBatAimbot()
    disableAutoBat()
end

local function disconnectTpBatAntiDie()
    for _, conn in ipairs(S.tpBatAntiDieConnections or {}) do pcall(function() conn:Disconnect() end) end
    S.tpBatAntiDieConnections = {}
end
local function hookTpBatAntiDie(character)
    disconnectTpBatAntiDie()
    if not S.tpBatEnabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)
    table.insert(S.tpBatAntiDieConnections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if S.tpBatEnabled and humanoid.Parent and humanoid.Health <= 0 then
            pcall(function() humanoid.Health = humanoid.MaxHealth; humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end))
end
local function findTpBatTool()
    local character=LP.Character
    if not character then return nil end
    local function matches(child)
        if not child:IsA("Tool") then return false end
        local name=child.Name:lower()
        return name:find("bat") or name:find("slap")
    end
    for _,child in ipairs(character:GetChildren()) do if matches(child) then return child end end
    local backpack=LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _,child in ipairs(backpack:GetChildren()) do
            if matches(child) then
                local humanoid=character:FindFirstChildOfClass("Humanoid")
                if humanoid then pcall(function() humanoid:EquipTool(child) end) end
                return child
            end
        end
    end
    return nil
end
local function findTpBatNearestTarget(root)
    if not root then return nil,math.huge end
    local best,bestDistance=nil,math.huge
    for _,player in ipairs(Players:GetPlayers()) do
        if player~=LP and player.Character then
            local otherRoot=player.Character:FindFirstChild("HumanoidRootPart")
            local otherHumanoid=player.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHumanoid and otherHumanoid.Health>0 then
                local distance=(root.Position-otherRoot.Position).Magnitude
                if distance<bestDistance then bestDistance=distance; best=player end
            end
        end
    end
    return best,bestDistance
end
local function swingTpBat()
    if S.tpBatHitCooldown then return end
    S.tpBatHitCooldown=true
    pcall(function()
        local bat=findTpBatTool()
        if not bat then return end
        bat:Activate()
        local remote=bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    task.delay(0.08,function() S.tpBatHitCooldown=false end)
end
local function tpBatTick()
    if not S.tpBatEnabled then return end
    local character=LP.Character
    if not character then return end
    local root=character:FindFirstChild("HumanoidRootPart")
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health<=0 then return end
    local animator=humanoid:FindFirstChildOfClass("Animator")
    if animator then pcall(function() for _,track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end end) end
    local bat=findTpBatTool()
    if bat and bat.Parent~=character then pcall(function() humanoid:EquipTool(bat) end) end
    local target,distance=findTpBatNearestTarget(root)
    if not target or distance>100 then return end
    local targetRoot=target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(nil) end end)
    if not S.tpBatEnabled or root.Parent~=character or not targetRoot.Parent then return end
    root.CFrame=CFrame.new(targetRoot.Position+Vector3.new(0,0.9,0))
    root.AssemblyLinearVelocity=targetRoot.AssemblyLinearVelocity
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
    local currentCamera=workspace.CurrentCamera
    if currentCamera then currentCamera.CFrame=CFrame.new(currentCamera.CFrame.Position,targetRoot.Position) end
    swingTpBat()
    pcall(function() for _,descendant in ipairs(character:GetDescendants()) do if descendant:IsA("BasePart") then descendant.CanCollide=false end end end)
end
local function setTpBat(state)
    local enabled=state==true
    if enabled and S.batBypassEnabled and S.setBatBypass then S.setBatBypass(false) end
    S.tpBatEnabled=enabled; S.batTpEnabled=enabled; S._smartBatTpDriving=enabled
    if enabled then
        hookTpBatAntiDie(LP.Character)
        if S.tpBatConn then S.tpBatConn:Disconnect() end
        S.tpBatConn=RunService.Heartbeat:Connect(tpBatTick)
    else
        if S.tpBatConn then S.tpBatConn:Disconnect(); S.tpBatConn=nil end
        disconnectTpBatAntiDie()
        local character=LP.Character
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if root then pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end) end
    end
end
LP.CharacterAdded:Connect(function(character)
    if S.tpBatEnabled then task.wait(0.1); hookTpBatAntiDie(character) end
end)
setBatAimbot = function(state)
    if state and S.batBypassEnabled and S.setBatBypass then S.setBatBypass(false) end
    if S.batAimbotEnabled == state then return end
    S.batAimbotEnabled = state
    if state then
        -- Every activation path keeps normal aimbot separate from Auto Path.
        if S.autoLeftEnabled then
            S.autoLeftEnabled = false
            stopAutoLeft()
            if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
        end
        if S.autoRightEnabled then
            S.autoRightEnabled = false
            stopAutoRight()
            if S.autoRightSetVisual then S.autoRightSetVisual(false) end
        end
        startBatAimbot()
    else
        stopBatAimbot()
    end
    if S.batAimbotSetVisual then S.batAimbotSetVisual(state) end
    if S._setPButtonActive and S._btnBAT then
        S._setPButtonActive(S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT, state)
    end
    S.restartMovement()
    saveConfig()
end

do
-- ===== BAT V2 (portado da primeira source / Macho Hub) =====
local BV2 = {
    on = false,
    conn = nil,
    pingConn = nil,
    cd = false,
    speed = 55,
    lastSwing = 0,
    targetPlayer = nil,
    lastTargetPos = nil,
    targetVelocity = Vector3.zero,
    smoothedVelocity = Vector3.zero,
    velocityHistory = {},
    accelerationHistory = {},
    aerialVelocityHistory = {},
    previousDirection = nil,
    lastDirectionChangeTime = 0,
    airborneTime = 0,
    lastActivationTime = 0,
    currentPing = 0.1,
    realPingMs = 0,
}

local BV2CFG = {
    FOLLOW_SPEED = 55,
    ACTIVATE_DISTANCE = 13,
    MIN_FOLLOW_DISTANCE = 1,
    PREDICTION_TIME = 0.22,
    PREDICT_AHEAD = 3,
    MAX_VELOCITY_CHANGE = 150,
    VELOCITY_SMOOTHING = 0.2,
    MAX_HORIZONTAL_VELOCITY = 80,
    SERVER_TICKRATE = 1 / 60,
    MIN_PING_COMPENSATION = 0.03,
    MAX_PING_COMPENSATION = 0.25,
    ACCELERATION_PREDICTION_WEIGHT = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY = 196.2,
    AIR_CONTROL_FACTOR = 0.8,
    MIN_AIRBORNE_TIME = 0.08,
}

local function batV2FindTool()
    local char = LP.Character
    if not char then return nil end

    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        local n = equipped.Name:lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) then return equipped end
    end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            return tool
        end
    end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                return tool
            end
        end
    end
    return nil
end

local function bv2Average(history)
    if #history == 0 then return Vector3.zero end
    local total = Vector3.zero
    for _, v in ipairs(history) do total = total + v end
    return total / #history
end

local function bv2Push(history, value, maximum)
    table.insert(history, value)
    if #history > maximum then table.remove(history, 1) end
end

local function bv2ResetTarget()
    BV2.targetPlayer = nil
    BV2.lastTargetPos = nil
    BV2.targetVelocity = Vector3.zero
    BV2.smoothedVelocity = Vector3.zero
    BV2.velocityHistory = {}
    BV2.accelerationHistory = {}
    BV2.aerialVelocityHistory = {}
    BV2.previousDirection = nil
    BV2.airborneTime = 0
end

local function batV2ClosestRoot()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, math.huge end
    local closest, closestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (targetRoot.Position - root.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closest = targetRoot
                end
            end
        end
    end
    return closest, closestDistance
end

local function bv2ClosestPlayer(root)
    local closestDistance, closestPlayer = math.huge, nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local tRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local tHum = player.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and tHum and tHum.Health > 0 then
                local d = (root.Position - tRoot.Position).Magnitude
                if d < closestDistance then
                    closestDistance = d
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

local function bv2ApplyAngularAim(root, direction)
    if direction.Magnitude < 0.01 then return end
    local crossVector = root.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
    root.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80 or Vector3.zero
end

local function bv2UpdatePing()
    local ok, value = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and type(value) == "number" then BV2.realPingMs = math.floor(value) end
    BV2.currentPing = math.clamp(BV2.realPingMs / 1000, BV2CFG.MIN_PING_COMPENSATION, BV2CFG.MAX_PING_COMPENSATION)
end

local function batV2Swing()
    local now = tick()
    if now - (BV2.lastSwing or 0) < 0.05 then return end
    if S.autoSwingEnabled == false then return end
    BV2.lastSwing = now
    pcall(function()
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local tool = batV2FindTool()
        if not tool then return end
        if tool.Parent ~= char and humanoid then
            pcall(function() humanoid:EquipTool(tool) end)
        end
        pcall(function() tool:Activate() end)
    end)
end

local function batV2Stop()
    BV2.on = false
    S.batBypassEnabled = false
    if BV2.conn then
        pcall(function() BV2.conn:Disconnect() end)
        BV2.conn = nil
    end
    BV2.pingConn = nil

    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid then pcall(function() humanoid.AutoRotate = true end) end
    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
    bv2ResetTarget()
    BV2.lastActivationTime = 0
    BV2.cd = false
    if S.setBatBypassVisual then S.setBatBypassVisual(false) end
    if S.setBatBypassRowVisual then S.setBatBypassRowVisual(false) end
    if S.restartMovement then S.restartMovement() end
end

local function batV2Start()
    if BV2.conn then
        pcall(function() BV2.conn:Disconnect() end)
        BV2.conn = nil
    end

    if S.batAimbotEnabled then setBatAimbot(false) end
    if S.tpBatEnabled then setTpBat(false) end
    if S.autoLeftEnabled then
        S.autoLeftEnabled = false; stopAutoLeft()
        if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
    end
    if S.autoRightEnabled then
        S.autoRightEnabled = false; stopAutoRight()
        if S.autoRightSetVisual then S.autoRightSetVisual(false) end
    end
    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    bv2ResetTarget()
    BV2.on = true
    S.batBypassEnabled = true
    humanoid.AutoRotate = false

    local tool = batV2FindTool()
    if tool and tool.Parent ~= char then
        pcall(function() humanoid:EquipTool(tool) end)
    end

    if not BV2.pingConn then
        local generation = {}
        BV2.pingConn = generation
        task.spawn(function()
            while BV2.pingConn == generation do pcall(bv2UpdatePing); task.wait(0.5) end
        end)
    end

    BV2.conn = RunService.RenderStepped:Connect(function(deltaTime)
        if not BV2.on then batV2Stop(); return end
        if S._youtResetInProgress or S.dropBrainrotActive then return end

        BV2CFG.FOLLOW_SPEED = math.clamp(tonumber(BV2.speed) or 55, 1, 200)

        local cChar = LP.Character
        local cRoot = cChar and cChar:FindFirstChild("HumanoidRootPart")
        local cHum = cChar and cChar:FindFirstChildOfClass("Humanoid")
        if not cRoot or not cHum or cHum.Health <= 0 then batV2Stop(); return end
        cHum.AutoRotate = false
        root, humanoid = cRoot, cHum

        tool = cChar:FindFirstChildOfClass("Tool") or batV2FindTool()
        if tool and tool.Parent ~= cChar then
            pcall(function() cHum:EquipTool(tool) end)
        end

        local nextTarget = bv2ClosestPlayer(root)
        if nextTarget ~= BV2.targetPlayer then bv2ResetTarget() end
        BV2.targetPlayer = nextTarget
        local tChar = BV2.targetPlayer and BV2.targetPlayer.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
        if not tRoot or not tHum or tHum.Health <= 0 then bv2ResetTarget(); return end

        local targetPos = tRoot.Position
        local safeDt = math.max(deltaTime, 1 / 240)

        if BV2.lastTargetPos then
            local rawVelocity = (targetPos - BV2.lastTargetPos) / safeDt
            local velocityDelta = rawVelocity - BV2.targetVelocity
            if velocityDelta.Magnitude > BV2CFG.MAX_VELOCITY_CHANGE then
                rawVelocity = BV2.targetVelocity + velocityDelta.Unit * BV2CFG.MAX_VELOCITY_CHANGE
            end
            local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
            if horizontal.Magnitude > BV2CFG.MAX_HORIZONTAL_VELOCITY then
                horizontal = horizontal.Unit * BV2CFG.MAX_HORIZONTAL_VELOCITY
                rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
            end
            bv2Push(BV2.accelerationHistory, (rawVelocity - BV2.targetVelocity) / safeDt, 4)
            bv2Push(BV2.velocityHistory, rawVelocity, 8)
            BV2.targetVelocity = rawVelocity
            BV2.smoothedVelocity = BV2.smoothedVelocity:Lerp(rawVelocity, BV2CFG.VELOCITY_SMOOTHING)
        end
        BV2.lastTargetPos = targetPos

        local airborne = tHum.FloorMaterial == Enum.Material.Air
        BV2.airborneTime = airborne and (BV2.airborneTime + safeDt) or 0
        if airborne and BV2.airborneTime >= BV2CFG.MIN_AIRBORNE_TIME then
            bv2Push(BV2.aerialVelocityHistory, BV2.targetVelocity, 6)
        elseif not airborne then
            BV2.aerialVelocityHistory = {}
        end

        local predictionVelocity = BV2.smoothedVelocity
        if airborne and #BV2.aerialVelocityHistory > 0 then
            local aerial = bv2Average(BV2.aerialVelocityHistory)
            predictionVelocity = Vector3.new(aerial.X, BV2.targetVelocity.Y, aerial.Z) * BV2CFG.AIR_CONTROL_FACTOR
        end

        local quickTurn = false
        local horizontalVelocity = Vector3.new(BV2.targetVelocity.X, 0, BV2.targetVelocity.Z)
        if horizontalVelocity.Magnitude > 5 then
            local direction = horizontalVelocity.Unit
            if BV2.previousDirection and BV2.previousDirection:Dot(direction) < 0.5 then
                quickTurn = tick() - BV2.lastDirectionChangeTime < BV2CFG.DIRECTION_CHANGE_DETECTION_TIME
                BV2.lastDirectionChangeTime = tick()
            end
            BV2.previousDirection = direction
        end

        local serverDelay = BV2.currentPing + BV2CFG.SERVER_TICKRATE
        if quickTurn then serverDelay *= BV2CFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end

        local predicted = targetPos + predictionVelocity * serverDelay
            + bv2Average(BV2.accelerationHistory) * BV2CFG.ACCELERATION_PREDICTION_WEIGHT * serverDelay * serverDelay * 0.5

        local leadTime = BV2CFG.PREDICTION_TIME * 1.1
        if airborne then
            predicted += predictionVelocity * leadTime + Vector3.new(0, -0.5 * BV2CFG.GRAVITY * leadTime * leadTime, 0)
        else
            predicted += predictionVelocity * leadTime
        end

        local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
        if flatPrediction.Magnitude > 1 then
            predicted += flatPrediction.Unit * BV2CFG.PREDICT_AHEAD
        end

        local toTarget = predicted - root.Position
        bv2ApplyAngularAim(root, toTarget)

        if (targetPos - root.Position).Magnitude <= BV2CFG.ACTIVATE_DISTANCE
            and tick() - BV2.lastActivationTime >= 0.3 then
            if tool then pcall(function() tool:Activate() end) end
            BV2.lastActivationTime = tick()
        end

        if toTarget.Magnitude > BV2CFG.MIN_FOLLOW_DISTANCE then
            root.AssemblyLinearVelocity = toTarget.Unit * BV2CFG.FOLLOW_SPEED
        else
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
        end
    end)
end



S.setBatBypass = function(enabled)
    if enabled == true then
        batV2Start()
    else
        batV2Stop()
    end
    if S.setBatBypassVisual then S.setBatBypassVisual(BV2.on == true) end
    if updateFloatingButtons then updateFloatingButtons() end
end
S.toggleBatBypass = function()
    S.setBatBypass(not S.batBypassEnabled)
end
_G._SMKBatBypassCleanup = batV2Stop
LP.CharacterRemoving:Connect(function()
    if BV2.on then batV2Stop() end
end)
end -- prime.vs Bat V2 isolated module

-- EMBER V1-V4 + original ＳＭＫㅤＨＵＢ V5. Engines are private and mutually exclusive.
do
    local Engines = {}
    local disposed = false
    S.batBypassVersion = S.batBypassVersion or "v5"
    S.batBypassSpeed = S.batBypassSpeed or 58
    local originalSet = S.setBatBypass
    local originalCleanup = _G._SMKBatBypassCleanup
    local activeEngine = nil
    local v1Connection = nil
    local lastSwing = 0
    local function nearest(root)
        local target, distance = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local other = player.Character:FindFirstChild("HumanoidRootPart")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if other and hum and hum.Health > 0 then
                    local d = (other.Position - root.Position).Magnitude
                    if d < distance then target, distance = other, d end
                end
            end
        end
        return target, distance
    end
    Engines.v1 = {
        Start = function()
            local character = LP.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            humanoid.AutoRotate = false
            lastSwing = 0
            v1Connection = RunService.RenderStepped:Connect(function()
                if not S.batBypassEnabled then return end
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not root or not hum or hum.Health <= 0 then return end
                local bat = S.empireFindBatForAimbot()
                if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
                local target, distance = nearest(root)
                if not target then
                    hum.AutoRotate = true
                    root.AssemblyAngularVelocity = Vector3.zero
                    return
                end
                hum.AutoRotate = false
                local myPos, targetPos = root.Position, target.Position
                local direction = targetPos - myPos
                local flat = Vector3.new(direction.X, 0, direction.Z)
                flat = flat.Magnitude > 0 and flat.Unit or Vector3.zero
                local speed = math.clamp(tonumber(S.batBypassSpeed) or 58, 1, 500)
                local yVel = (targetPos.Y + 3.7 - myPos.Y) * 19.5
                if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
                yVel = math.clamp(yVel, -70, 110)
                root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(Vector3.new(flat.X * speed, yVel, flat.Z * speed), 0.8)
                if direction.Magnitude > 0.1 then
                    local diff = root.CFrame:Inverse() * CFrame.lookAt(myPos, targetPos)
                    local rx, ry, rz = diff:ToEulerAnglesXYZ()
                    root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(
                        math.clamp(rx, -2.5, 2.5) * 42,
                        math.clamp(ry, -2.5, 2.5) * 42,
                        math.clamp(rz, -2.5, 2.5) * 42))
                end
                if distance <= 8 and bat and tick() - lastSwing >= 0.08 then
                    lastSwing = tick()
                    pcall(function() bat:Activate() end)
                end
            end)
        end,
        Stop = function()
            if v1Connection then v1Connection:Disconnect(); v1Connection = nil end
        end,
        IsEnabled = function() return v1Connection ~= nil end,
    }
do
    local state = {
        enabled = false,
        connection = nil,
        autoSwing = true,
        approachSpeed = 58,
        laggerSpeed = 40,
        useLaggerSpeed = false,
        predCache = {},
        moverName = "Blast_AimbotV2_LV",
        attachmentName = "Blast_AimbotV2_Att",
        minForce = 1000000,
        maxForce = 50000000,
    }

    local function getCharacterParts()
        local char = LP.Character
        if not char then return nil, nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return nil, nil end
        return hrp, hum
    end

    local function getBatTool()
        local char = LP.Character
        if not char then return nil end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Tool") then
                local n = string.lower(child.Name)
                if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return child end
            end
        end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        if backpack then
            for _, child in ipairs(backpack:GetChildren()) do
                if child:IsA("Tool") then
                    local n = string.lower(child.Name)
                    if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return child end
                end
            end
        end
        return nil
    end

    local function nearestTarget(fromPos)
        local bestDist, bestHRP = math.huge, nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local dist = (hrp.Position - fromPos).Magnitude
                    if dist < bestDist then bestDist, bestHRP = dist, hrp end
                end
            end
        end
        return bestHRP
    end

    local function clearMover(hrp)
        if not hrp then return end
        local lv = hrp:FindFirstChild(state.moverName)
        local att = hrp:FindFirstChild(state.attachmentName)
        if lv and lv:IsA("LinearVelocity") then lv:Destroy() end
        if att and att:IsA("Attachment") then att:Destroy() end
    end

    local function ensureMover(hrp, speed)
        local att = hrp:FindFirstChild(state.attachmentName)
        if not att or not att:IsA("Attachment") then
            if att then att:Destroy() end
            att = Instance.new("Attachment")
            att.Name = state.attachmentName
            att.Parent = hrp
        end
        local lv = hrp:FindFirstChild(state.moverName)
        if not lv or not lv:IsA("LinearVelocity") then
            if lv then lv:Destroy() end
            lv = Instance.new("LinearVelocity")
            lv.Name = state.moverName
            lv.Attachment0 = att
            lv.RelativeTo = Enum.ActuatorRelativeTo.World
            lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            lv.ForceLimitsEnabled = true
            lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
            lv.VectorVelocity = Vector3.zero
            lv.Parent = hrp
        else
            lv.Attachment0 = att
        end
        local force = math.clamp(hrp.AssemblyMass * math.max(speed * 220, 6000), state.minForce, state.maxForce)
        lv.MaxAxesForce = Vector3.new(force, force, force)
        lv.Enabled = true
        return lv
    end

    local function applyMove(hrp, desiredVel, speed, dt)
        local lv = ensureMover(hrp, speed)
        local alpha = 1 - math.exp(-math.max(dt, 0) * 26)
        lv.VectorVelocity = lv.VectorVelocity:Lerp(desiredVel, alpha)
    end

    local function resetMotion()
        local character = LP.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if hrp then
            clearMover(hrp)
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local look = hrp.CFrame.LookVector
            local flat = Vector3.new(look.X, 0, look.Z)
            if flat.Magnitude > 0.01 then flat = flat.Unit else flat = Vector3.new(0, 0, -1) end
            hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat)
        end
        if hum then
            hum.AutoRotate = true
            hum.PlatformStand = false
            pcall(function() hum:Move(Vector3.zero, false) end)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end

    local function update(dt)
        if not state.enabled then return end
        if not S.batBypassEnabled then return end
        local hrp, hum = getCharacterParts()
        if not hrp or not hum then clearMover(hrp) return end
        local target = nearestTarget(hrp.Position)
        if not target then
            hum.AutoRotate = true
            hrp.AssemblyAngularVelocity = Vector3.zero
            clearMover(hrp)
            return
        end
        local speed = state.useLaggerSpeed and state.laggerSpeed or state.approachSpeed
        local configuredSpeed = S.batBypassSpeed
        speed = math.clamp(tonumber(configuredSpeed) or speed, 1, 500)
        local now = tick()
        local cache = state.predCache[target]
        local predictedVel = Vector3.zero
        if not cache then
            state.predCache[target] = { pos = target.Position, time = now, vel = Vector3.zero }
        else
            local dtPred = math.clamp(now - cache.time, 1/120, 0.25)
            local rawVel = (target.Position - cache.pos) / dtPred
            if rawVel.Magnitude > 80 then rawVel = rawVel.Unit * 80 end
            cache.vel = cache.vel:Lerp(rawVel, 0.25)
            cache.pos = target.Position
            cache.time = now
            predictedVel = cache.vel
        end
        local lookAhead = math.clamp(predictedVel.Magnitude / 130, 0.05, 0.12)
        local aimPoint = target.Position + predictedVel * lookAhead + Vector3.new(0, 1, 0)
        hum.AutoRotate = false
        local toTarget = aimPoint - hrp.Position
        local flatDir = Vector3.new(toTarget.X, 0, toTarget.Z)
        if toTarget.Magnitude > 0.01 and flatDir.Magnitude > 0.01 then
            local yawDelta = (math.deg(math.atan2(-flatDir.X, -flatDir.Z)) - hrp.Orientation.Y + 180) % 360 - 180
            local pitchDelta = (math.deg(math.atan2(toTarget.Y, flatDir.Magnitude)) - hrp.Orientation.X + 180) % 360 - 180
            local yawForce = math.clamp(math.rad(yawDelta) * 285, -28, 28)
            local pitchForce = math.clamp(math.rad(pitchDelta) * 285, -28, 28)
            local right = Vector3.new(math.cos(math.rad(hrp.Orientation.Y)), 0, -math.sin(math.rad(hrp.Orientation.Y)))
            hrp.AssemblyAngularVelocity = Vector3.new(0, yawForce, 0) + right * pitchForce
        else
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        local moveVec = (aimPoint + Vector3.new(0, 4.75, 0) - hrp.Position)
        local flatMove = Vector3.new(moveVec.X, 0, moveVec.Z)
        local horizontal = flatMove.Magnitude > 0.1 and flatMove.Unit * speed or Vector3.zero
        local vertical = math.abs(moveVec.Y) > 0.1 and Vector3.new(0, math.sign(moveVec.Y) * 52, 0) or Vector3.new(0, -2, 0)
        applyMove(hrp, horizontal + vertical, speed, dt)
        if flatMove.Magnitude > 0.5 then hum:Move(flatMove.Unit, false) end
        if state.autoSwing then
            local bat = getBatTool()
            if bat and bat.Parent == LP.Character then pcall(function() bat:Activate() end) end
        end
    end

    local AimbotV2 = {}
    function AimbotV2.Start(opts)
        opts = opts or {}
        if state.enabled then
            AimbotV2.Stop()
        end
        state.enabled = true
        state.autoSwing = opts.autoSwing ~= false
        if true == false then state.autoSwing = false end
        local configuredSpeed = S.batBypassSpeed
        state.approachSpeed = tonumber(opts.speed) or tonumber(configuredSpeed) or 58
        state.laggerSpeed = tonumber(opts.laggerSpeed) or 40
        state.useLaggerSpeed = opts.useLaggerSpeed == true
        state.predCache = {}
        local _, hum = getCharacterParts()
        if hum then
            local bat = getBatTool()
            if bat and bat.Parent ~= LP.Character then pcall(function() hum:EquipTool(bat) end) end
        end
        clearMover(select(1, getCharacterParts()))
        state.connection = RunService.RenderStepped:Connect(update)
        -- Connection belongs to this engine.
    end
    function AimbotV2.Stop()
        if not state.enabled and not state.connection then return end
        state.enabled = false
        if state.connection then state.connection:Disconnect() state.connection = nil end
        -- Connection cleared above.
        resetMotion()
        state.predCache = {}
    end
    function AimbotV2.IsEnabled() return state.enabled end
    function AimbotV2.SetLaggerMode(active) state.useLaggerSpeed = active == true end
    function AimbotV2.SetAutoSwing(active) state.autoSwing = active == true end
    function AimbotV2.SetSpeed(normal, lagger)
        if normal then state.approachSpeed = math.clamp(tonumber(normal) or 58, 1, 500) end
        if lagger then state.laggerSpeed = math.clamp(tonumber(lagger) or 40, 1, 500) end
    end

    Engines.v2 = AimbotV2
    -- Engine remains private to ＳＭＫㅤＨＵＢ.
end

-- ============================================================
-- AIMBOT V3 = BAT BYPASS (retirado do Fluxo.Vs)
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer
    local BAT_V2_SPEED, BAT_V2_HIT_DIST, BAT_V2_LEAD_STUDS = 55, 13, 3
    local snowVS = { BatBypass = {} }
    do
        local batBypass = snowVS.BatBypass
        batBypass.Enabled = batBypass.Enabled or false
        batBypass.Connection = batBypass.Connection or nil
        batBypass.Z = batBypass.Z
            or {
                targetPlayer = nil,
                lastTargetPos = nil,
                targetVelocity = Vector3.zero,
                smoothedVelocity = Vector3.zero,
                velocityHistory = {},
                accelerationHistory = {},
                aerialVelocityHistory = {},
                previousDirection = nil,
                lastDirectionChangeTime = 0,
                airborneTime = 0,
                lastActivationTime = 0,
                currentPing = 0.1,
                realPingMs = 0,
            }
        batBypass.ZCFG = batBypass.ZCFG
            or {
                FOLLOW_SPEED = BAT_V2_SPEED,
                ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
                MIN_FOLLOW_DISTANCE = 1,
                PREDICTION_TIME = 0.22,
                PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
                MAX_VELOCITY_CHANGE = 150,
                VELOCITY_SMOOTHING = 0.2,
                MAX_HORIZONTAL_VELOCITY = 80,
                SERVER_TICKRATE = 0.016666666666666666,
                MIN_PING_COMPENSATION = 0.03,
                MAX_PING_COMPENSATION = 0.25,
                ACCELERATION_PREDICTION_WEIGHT = 0.3,
                DIRECTION_CHANGE_DETECTION_TIME = 0.12,
                QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
                GRAVITY = 196.2,
                AIR_CONTROL_FACTOR = 0.8,
                MIN_AIRBORNE_TIME = 0.08,
            }
        local function averageVectors(vectors)
            if #vectors == 0 then
                return Vector3.zero
            end
            local sum = Vector3.zero
            for _, entry in ipairs(vectors) do
                sum += entry
            end
            return sum / #vectors
        end
        local function pushBounded(history, entry, maxEntries)
            table.insert(history, entry)
            if #history > maxEntries then
                table.remove(history, 1)
            end
        end
        batBypass.FindBat = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local lowercaseText = tool.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                    return tool
                end
            end
            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowercaseText = child.Name:lower()
                        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                            return child
                        end
                    end
                end
            end
            return nil
        end
        local function resetPredictionState()
            local z = batBypass.Z
            z.targetPlayer = nil
            z.lastTargetPos = nil
            z.targetVelocity = Vector3.zero
            z.smoothedVelocity = Vector3.zero
            z.velocityHistory = {}
            z.accelerationHistory = {}
            z.aerialVelocityHistory = {}
            z.previousDirection = nil
            z.airborneTime = 0
        end
        local function findClosestPlayer(rootPart)
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < closestDistance then
                            closestDistance = magnitude
                            closestPlayer = player
                        end
                    end
                end
            end
            return closestPlayer
        end
        local function applyAngularAim(rootPart, direction)
            if direction.Magnitude < 0.01 then
                return
            end
            local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
            local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
            rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
                or Vector3.zero
        end
        local function updatePing()
            local ok, result = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            local z = batBypass.Z
            if ok and type(result) == "number" then
                z.realPingMs = math.floor(result)
            end
            z.currentPing = math.clamp(
                z.realPingMs / 1000,
                batBypass.ZCFG.MIN_PING_COMPENSATION,
                batBypass.ZCFG.MAX_PING_COMPENSATION
            )
        end
        batBypass.PingGeneration = 0
        batBypass.StartBodyLock = function() end
        batBypass.StopBodyLock = function() end
        batBypass.Stop = function()
            local z = batBypass.Z
            batBypass.Enabled = false
            batBypass.PingGeneration = batBypass.PingGeneration + 1
            if batBypass.Connection then
                batBypass.Connection:Disconnect()
                batBypass.Connection = nil
            end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            character = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.AutoRotate = true
            end
            if character then
                character.AssemblyAngularVelocity = Vector3.zero
            end
            resetPredictionState()
            z.lastActivationTime = 0
        end
        batBypass.Start = function()
            if batBypass.Connection then
                return
            end
            local character = localPlayer.Character
            local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid1387 or not rootPart then
                return
            end
            batBypass.Enabled = true
            batBypass.PingGeneration = batBypass.PingGeneration + 1
            local pingGeneration = batBypass.PingGeneration
            pcall(updatePing)
            task.spawn(function()
                while batBypass.Enabled and batBypass.PingGeneration == pingGeneration and not disposed do
                    pcall(updatePing)
                    task.wait(0.5)
                end
            end)
            humanoid1387.AutoRotate = false
            local tool = batBypass.FindBat()
            if tool and tool.Parent ~= character then
                pcall(function()
                    humanoid1387:EquipTool(tool)
                end)
            end
            batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
                if not batBypass.Enabled then
                    batBypass.Stop()
                    return
                end
                local z = batBypass.Z
                local zcfg = batBypass.ZCFG
                zcfg.FOLLOW_SPEED = math.clamp(tonumber(S.batBypassSpeed) or BAT_V2_SPEED, 1, 500)
                local character2 = localPlayer.Character
                local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
                    return
                end
                humanoid.AutoRotate = false
                rootPart = rootPart1394
                humanoid1387 = humanoid
                tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
                if tool and tool.Parent ~= character2 then
                    pcall(humanoid.EquipTool, humanoid, tool)
                end
                z.targetPlayer = findClosestPlayer(rootPart)
                local character3 = z.targetPlayer and z.targetPlayer.Character
                local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
                character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
                if not rootPart1442 or not character3 or character3.Health <= 0 then
                    resetPredictionState()
                    return
                end
                local position = rootPart1442.Position
                local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local vector = targetVelocity - z.targetVelocity
                    if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                        targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                    end
                    local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                        local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
                    end
                    pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    pushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local isAirborne = character3.FloorMaterial == Enum.Material.Air
                z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
                if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                    pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not isAirborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if isAirborne and #z.aerialVelocityHistory > 0 then
                    local vector = averageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
                end
                local changedDirectionQuickly = false
                local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if vector3.Magnitude > 5 then
                    local unit = vector3.Unit
                    if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                        local lastDirectionChangeTime = z.lastDirectionChangeTime
                        changedDirectionQuickly = tick() - lastDirectionChangeTime
                            < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = tick()
                    end
                    z.previousDirection = unit
                end
                local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
                if changedDirectionQuickly then
                    predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
                end
                local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + averageVectors(z.accelerationHistory)
                        * accelerationPredictionWeight
                        * predictionTime
                        * predictionTime
                        * 0.5
                local leadTime = zcfg.PREDICTION_TIME * 1.1
                local leadPosition
                if isAirborne then
                    leadPosition = predictedPosition
                        + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if vector4.Magnitude > 1 then
                    leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
                end
                local targetDirection = leadPosition - rootPart.Position
                applyAngularAim(rootPart, targetDirection)
                local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
                if withinActivationRange then
                    local lastActivationTime = z.lastActivationTime
                    withinActivationRange = tick() - lastActivationTime >= 0.3
                end
                if withinActivationRange then
                    if tool then
                        pcall(tool.Activate, tool)
                    end
                    z.lastActivationTime = tick()
                end
                if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end
        batBypass.Toggle = function()
            if batBypass.Enabled then
                batBypass.Stop()
            else
                batBypass.Start()
            end
        end
    end
    Engines.v3 = {
        Start = function() snowVS.BatBypass.Start() end,
        Stop = function() snowVS.BatBypass.Stop() end,
        IsEnabled = function() return snowVS.BatBypass.Enabled end,
    }
end

-- ============================================================
-- AIMBOT V4 = BAT BYPASS (retirado do Clean)
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer
    local BAT_V2_SPEED, BAT_V2_HIT_DIST, BAT_V2_LEAD_STUDS = 55, 13, 3
    local snowVS = { BatBypass = {} }
    do
        local batBypass = snowVS.BatBypass
        batBypass.Enabled = batBypass.Enabled or false
        batBypass.Connection = batBypass.Connection or nil
        batBypass.Z = batBypass.Z
            or {
                targetPlayer = nil,
                lastTargetPos = nil,
                targetVelocity = Vector3.zero,
                smoothedVelocity = Vector3.zero,
                velocityHistory = {},
                accelerationHistory = {},
                aerialVelocityHistory = {},
                previousDirection = nil,
                lastDirectionChangeTime = 0,
                airborneTime = 0,
                lastActivationTime = 0,
                currentPing = 0.1,
                realPingMs = 0,
            }
        batBypass.ZCFG = batBypass.ZCFG
            or {
                FOLLOW_SPEED = BAT_V2_SPEED,
                ACTIVATE_DISTANCE = BAT_V2_HIT_DIST,
                MIN_FOLLOW_DISTANCE = 1,
                PREDICTION_TIME = 0.22,
                PREDICT_AHEAD = BAT_V2_LEAD_STUDS,
                MAX_VELOCITY_CHANGE = 150,
                VELOCITY_SMOOTHING = 0.2,
                MAX_HORIZONTAL_VELOCITY = 80,
                SERVER_TICKRATE = 0.016666666666666666,
                MIN_PING_COMPENSATION = 0.03,
                MAX_PING_COMPENSATION = 0.25,
                ACCELERATION_PREDICTION_WEIGHT = 0.3,
                DIRECTION_CHANGE_DETECTION_TIME = 0.12,
                QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
                GRAVITY = 196.2,
                AIR_CONTROL_FACTOR = 0.8,
                MIN_AIRBORNE_TIME = 0.08,
            }
        local function averageVectors(vectors)
            if #vectors == 0 then
                return Vector3.zero
            end
            local sum = Vector3.zero
            for _, entry in ipairs(vectors) do
                sum += entry
            end
            return sum / #vectors
        end
        local function pushBounded(history, entry, maxEntries)
            table.insert(history, entry)
            if #history > maxEntries then
                table.remove(history, 1)
            end
        end
        batBypass.FindBat = function()
            local character = localPlayer.Character
            if not character then
                return nil
            end
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local lowercaseText = tool.Name:lower()
                if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                    return tool
                end
            end
            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                for _, child in ipairs(backpack:GetChildren()) do
                    if child:IsA("Tool") then
                        local lowercaseText = child.Name:lower()
                        if lowercaseText:find("bat", 1, true) or lowercaseText:find("slap", 1, true) then
                            return child
                        end
                    end
                end
            end
            return nil
        end
        local function resetPredictionState()
            local z = batBypass.Z
            z.targetPlayer = nil
            z.lastTargetPos = nil
            z.targetVelocity = Vector3.zero
            z.smoothedVelocity = Vector3.zero
            z.velocityHistory = {}
            z.accelerationHistory = {}
            z.aerialVelocityHistory = {}
            z.previousDirection = nil
            z.airborneTime = 0
        end
        local function findClosestPlayer(rootPart)
            local closestDistance = math.huge
            local closestPlayer = nil
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoidRootPart and humanoid and humanoid.Health > 0 then
                        local magnitude = (rootPart.Position - humanoidRootPart.Position).Magnitude
                        if magnitude < closestDistance then
                            closestDistance = magnitude
                            closestPlayer = player
                        end
                    end
                end
            end
            return closestPlayer
        end
        local function applyAngularAim(rootPart, direction)
            if direction.Magnitude < 0.01 then
                return
            end
            local crossVector = rootPart.CFrame.LookVector:Cross(direction.Unit)
            local angle = math.asin(math.clamp(crossVector.Magnitude, -1, 1))
            rootPart.AssemblyAngularVelocity = crossVector.Magnitude > 0.1 and crossVector.Unit * angle * 80
                or Vector3.zero
        end
        local function updatePing()
            local ok, result = pcall(function()
                return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
            end)
            local z = batBypass.Z
            if ok and type(result) == "number" then
                z.realPingMs = math.floor(result)
            end
            z.currentPing = math.clamp(
                z.realPingMs / 1000,
                batBypass.ZCFG.MIN_PING_COMPENSATION,
                batBypass.ZCFG.MAX_PING_COMPENSATION
            )
        end
        batBypass.PingGeneration = 0
        batBypass.StartBodyLock = function() end
        batBypass.StopBodyLock = function() end
        batBypass.Stop = function()
            local z = batBypass.Z
            batBypass.Enabled = false
            batBypass.PingGeneration = batBypass.PingGeneration + 1
            if batBypass.Connection then
                batBypass.Connection:Disconnect()
                batBypass.Connection = nil
            end
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            character = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                humanoid.AutoRotate = true
            end
            if character then
                character.AssemblyAngularVelocity = Vector3.zero
            end
            resetPredictionState()
            z.lastActivationTime = 0
        end
        batBypass.Start = function()
            if batBypass.Connection then
                return
            end
            local character = localPlayer.Character
            local humanoid1387 = character and character:FindFirstChildOfClass("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid1387 or not rootPart then
                return
            end
            batBypass.Enabled = true
            batBypass.PingGeneration = batBypass.PingGeneration + 1
            local pingGeneration = batBypass.PingGeneration
            pcall(updatePing)
            task.spawn(function()
                while batBypass.Enabled and batBypass.PingGeneration == pingGeneration and not disposed do
                    pcall(updatePing)
                    task.wait(0.5)
                end
            end)
            humanoid1387.AutoRotate = false
            local tool = batBypass.FindBat()
            if tool and tool.Parent ~= character then
                pcall(function()
                    humanoid1387:EquipTool(tool)
                end)
            end
            batBypass.Connection = RunService.RenderStepped:Connect(function(deltaTime)
                if not batBypass.Enabled then
                    batBypass.Stop()
                    return
                end
                local z = batBypass.Z
                local zcfg = batBypass.ZCFG
                zcfg.FOLLOW_SPEED = math.clamp(tonumber(S.batBypassSpeed) or BAT_V2_SPEED, 1, 500)
                local character2 = localPlayer.Character
                local rootPart1394 = character2 and character2:FindFirstChild("HumanoidRootPart")
                local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
                if not rootPart1394 or not humanoid or humanoid.Health <= 0 then
                    return
                end
                humanoid.AutoRotate = false
                rootPart = rootPart1394
                humanoid1387 = humanoid
                tool = character2:FindFirstChildOfClass("Tool") or batBypass.FindBat()
                if tool and tool.Parent ~= character2 then
                    pcall(humanoid.EquipTool, humanoid, tool)
                end
                z.targetPlayer = findClosestPlayer(rootPart)
                local character3 = z.targetPlayer and z.targetPlayer.Character
                local rootPart1442 = character3 and character3:FindFirstChild("HumanoidRootPart")
                character3 = character3 and character3:FindFirstChildOfClass("Humanoid")
                if not rootPart1442 or not character3 or character3.Health <= 0 then
                    resetPredictionState()
                    return
                end
                local position = rootPart1442.Position
                local sampleDeltaTime = math.max(deltaTime, 0.0041666666666666666)
                if z.lastTargetPos then
                    local targetVelocity = (position - z.lastTargetPos) / sampleDeltaTime
                    local vector = targetVelocity - z.targetVelocity
                    if zcfg.MAX_VELOCITY_CHANGE < vector.Magnitude then
                        targetVelocity = z.targetVelocity + vector.Unit * zcfg.MAX_VELOCITY_CHANGE
                    end
                    local vector3 = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
                    if vector3.Magnitude > zcfg.MAX_HORIZONTAL_VELOCITY then
                        local vector = vector3.Unit * zcfg.MAX_HORIZONTAL_VELOCITY
                        targetVelocity = Vector3.new(vector.X, targetVelocity.Y, vector.Z)
                    end
                    pushBounded(z.accelerationHistory, (targetVelocity - z.targetVelocity) / sampleDeltaTime, 4)
                    pushBounded(z.velocityHistory, targetVelocity, 8)
                    z.targetVelocity = targetVelocity
                    z.smoothedVelocity = z.smoothedVelocity:Lerp(targetVelocity, zcfg.VELOCITY_SMOOTHING)
                end
                z.lastTargetPos = position
                local isAirborne = character3.FloorMaterial == Enum.Material.Air
                z.airborneTime = isAirborne and z.airborneTime + sampleDeltaTime or 0
                if isAirborne and z.airborneTime >= zcfg.MIN_AIRBORNE_TIME then
                    pushBounded(z.aerialVelocityHistory, z.targetVelocity, 6)
                elseif not isAirborne then
                    z.aerialVelocityHistory = {}
                end
                local smoothedVelocity = z.smoothedVelocity
                if isAirborne and #z.aerialVelocityHistory > 0 then
                    local vector = averageVectors(z.aerialVelocityHistory)
                    smoothedVelocity = Vector3.new(vector.X, z.targetVelocity.Y, vector.Z) * zcfg.AIR_CONTROL_FACTOR
                end
                local changedDirectionQuickly = false
                local vector3 = Vector3.new(z.targetVelocity.X, 0, z.targetVelocity.Z)
                if vector3.Magnitude > 5 then
                    local unit = vector3.Unit
                    if z.previousDirection and z.previousDirection:Dot(unit) < 0.5 then
                        local lastDirectionChangeTime = z.lastDirectionChangeTime
                        changedDirectionQuickly = tick() - lastDirectionChangeTime
                            < zcfg.DIRECTION_CHANGE_DETECTION_TIME
                        z.lastDirectionChangeTime = tick()
                    end
                    z.previousDirection = unit
                end
                local predictionTime = z.currentPing + zcfg.SERVER_TICKRATE
                if changedDirectionQuickly then
                    predictionTime *= zcfg.QUICK_DIRECTION_CHANGE_MULTIPLIER
                end
                local accelerationPredictionWeight = zcfg.ACCELERATION_PREDICTION_WEIGHT
                local predictedPosition = position
                    + smoothedVelocity * predictionTime
                    + averageVectors(z.accelerationHistory)
                        * accelerationPredictionWeight
                        * predictionTime
                        * predictionTime
                        * 0.5
                local leadTime = zcfg.PREDICTION_TIME * 1.1
                local leadPosition
                if isAirborne then
                    leadPosition = predictedPosition
                        + smoothedVelocity * leadTime
                        + Vector3.new(0, -0.5 * zcfg.GRAVITY * leadTime * leadTime, 0)
                else
                    leadPosition = predictedPosition + smoothedVelocity * leadTime
                end
                local vector4 = Vector3.new(smoothedVelocity.X, 0, smoothedVelocity.Z)
                if vector4.Magnitude > 1 then
                    leadPosition += vector4.Unit * zcfg.PREDICT_AHEAD
                end
                local targetDirection = leadPosition - rootPart.Position
                applyAngularAim(rootPart, targetDirection)
                local withinActivationRange = (position - rootPart.Position).Magnitude <= zcfg.ACTIVATE_DISTANCE
                if withinActivationRange then
                    local lastActivationTime = z.lastActivationTime
                    withinActivationRange = tick() - lastActivationTime >= 0.3
                end
                if withinActivationRange then
                    if tool then
                        pcall(tool.Activate, tool)
                    end
                    z.lastActivationTime = tick()
                end
                if zcfg.MIN_FOLLOW_DISTANCE < targetDirection.Magnitude then
                    rootPart.AssemblyLinearVelocity = targetDirection.Unit * zcfg.FOLLOW_SPEED
                else
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, rootPart.AssemblyLinearVelocity.Y * 0.5, 0)
                end
            end)
        end
        batBypass.Toggle = function()
            if batBypass.Enabled then
                batBypass.Stop()
            else
                batBypass.Start()
            end
        end
    end
    Engines.v4 = {
        Start = function() snowVS.BatBypass.Start() end,
        Stop = function() snowVS.BatBypass.Stop() end,
        IsEnabled = function() return snowVS.BatBypass.Enabled end,
    }
end
    local function stopAll()
        for _, engine in pairs(Engines) do
            if engine.IsEnabled() then pcall(engine.Stop) end
        end
        if originalCleanup then pcall(originalCleanup) end
        activeEngine = nil
        S.batBypassEnabled = false
        local character = LP.Character
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if hum then hum.AutoRotate = true end
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            for _, name in ipairs({"Blast_AimbotV2_LV", "Blast_AimbotV2_Att"}) do
                local mover = root:FindFirstChild(name)
                if mover then mover:Destroy() end
            end
        end
    end
    S.setBatBypass = function(enabled)
        stopAll()
        if enabled == true and not disposed then
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                if S.batAimbotEnabled then setBatAimbot(false) end
                if S.tpBatEnabled then setTpBat(false) end
                if S.autoLeftEnabled then
                    S.autoLeftEnabled = false; stopAutoLeft()
                    if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
                end
                if S.autoRightEnabled then
                    S.autoRightEnabled = false; stopAutoRight()
                    if S.autoRightSetVisual then S.autoRightSetVisual(false) end
                end
                if S.batBypassVersion == "v5" then
                    originalSet(true)
                else
                    local engine = Engines[S.batBypassVersion]
                    if engine then
                        S.batBypassEnabled = true
                        activeEngine = engine
                        engine.Start()
                        S.batBypassEnabled = engine.IsEnabled()
                    end
                end
            end
        end
        if S.setBatBypassVisual then S.setBatBypassVisual(S.batBypassEnabled) end
        if S.setBatBypassRowVisual then S.setBatBypassRowVisual(S.batBypassEnabled) end
        if S.restartMovement then S.restartMovement() end
        if updateFloatingButtons then updateFloatingButtons() end
        saveConfig()
    end
    S.selectBatBypassVersion = function(version, persist)
        if version ~= "v5" and not Engines[version] then return end
        if version == S.batBypassVersion then return end
        local restart = S.batBypassEnabled
        S.setBatBypass(false)
        S.batBypassVersion = version
        if S.refreshBatBypassVersions then S.refreshBatBypassVersions() end
        if restart then S.setBatBypass(true) end
        if persist ~= false then saveConfig() end
    end
    _G._SMKBatBypassCleanup = function()
        disposed = true
        stopAll()
    end
    LP.CharacterRemoving:Connect(function()
        if S.batBypassEnabled then S.setBatBypass(false) end
    end)
end


BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap",
}

local function findBatForCounter()
    local character = LP.Character
    if not character then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = character:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

local function swingBatForCounter(bat, character)
    if not bat or not character then return end
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

triggerBatCounter = function(character)
    if not S.batCounterEnabled or S.batCounterDebounce then return end
    character = character or LP.Character
    if not character then return end
    S.batCounterDebounce = true
    -- Clean integra estos hooks con body-lock; se usan solo si están disponibles.
    if type(_suppressBodyLock) == "function" then pcall(_suppressBodyLock) end
    task.spawn(function()
        task.wait(0.15)
        local ok, err = pcall(function()
            local bat = findBatForCounter()
            if bat then swingBatForCounter(bat, character) end
        end)
        if not ok then warn("[ＳＭＫㅤＨＵＢ] Bat Counter error: " .. tostring(err)) end
        task.wait(0.3)
        S.batCounterDebounce = false
        if type(_unsuppressBodyLock) == "function" then pcall(_unsuppressBodyLock, true) end
    end)
end

stopBatCounter = function()
    if S.batCounterConn then
        S.batCounterConn:Disconnect()
        S.batCounterConn = nil
    end
    S.batCounterDebounce = false
end

startBatCounter = function()
    if S.batCounterConn then return end
    S.batCounterConn = RunService.Heartbeat:Connect(function()
        if not S.batCounterEnabled or S.batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            triggerBatCounter(character)
        end
    end)
end
medusaWatchedCharacter = nil
medusaLastErrorWarn = 0

local function findMedusa(character)
    local c = character or LP.Character
    if not c then return nil end
    local function isMedusaTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("medusa") or name:find("head") or name:find("stone")
    end
    for _, tool in ipairs(c:GetChildren()) do
        if isMedusaTool(tool) then return tool end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if isMedusaTool(tool) then return tool end
        end
    end
    return nil
end

local function useMedusaCounter()
    if not S.medusaCounterEnabled or S.medusaDebounce then return end
    local now = tick()
    if now - (S.medusaLastUsed or 0) < S.MEDUSA_COOLDOWN then return end
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not character or not humanoid or humanoid.Health <= 0 then return end

    S.medusaDebounce = true
    local ok, activated = pcall(function()
        local medusa = findMedusa(character)
        if not medusa then return false end
        if medusa.Parent ~= character then
            local equipOk = pcall(function() humanoid:EquipTool(medusa) end)
            if not equipOk then return false end
        end
        if not medusa.Parent then return false end
        local activateOk = pcall(function() medusa:Activate() end)
        if not activateOk then return false end
        return true
    end)
    S.medusaDebounce = false
    if ok and activated then
        S.medusaLastUsed = tick()
    elseif not ok and tick() - medusaLastErrorWarn >= 3 then
        medusaLastErrorWarn = tick()
        warn("[ＳＭＫㅤＨＵＢ] Medusa Counter error: " .. tostring(activated))
    end
end

local function onAnchorChanged(part)
    if not part or not part:IsA("BasePart") then return nil end
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if not S.medusaCounterEnabled or not part.Parent then return end
        if part.Anchored and part.Transparency == 1 then
            useMedusaCounter()
        end
    end)
end

local function stopMedusaCounter()
    for _, connection in ipairs(S.medusaConns) do
        if connection then pcall(function() connection:Disconnect() end) end
    end
    S.medusaConns = {}
    medusaWatchedCharacter = nil
end

local function setupMedusaCounter(character)
    stopMedusaCounter()
    if not character or not S.medusaCounterEnabled or character ~= LP.Character then return end
    medusaWatchedCharacter = character
    local watchedParts = {}
    local function watchPart(part)
        if not S.medusaCounterEnabled or medusaWatchedCharacter ~= character then return end
        if not part or not part:IsA("BasePart") or watchedParts[part] then return end
        watchedParts[part] = true
        local ok, connection = pcall(onAnchorChanged, part)
        if ok and connection then table.insert(S.medusaConns, connection) end
    end
    for _, part in ipairs(character:GetDescendants()) do
        watchPart(part)
    end
    table.insert(S.medusaConns, character.DescendantAdded:Connect(watchPart))
end

LP.CharacterRemoving:Connect(function(character)
    if medusaWatchedCharacter == character then stopMedusaCounter() end
end)

local function applyFPSBoost()
    safeSetfpscap(999999999)
    removeCharacterAccessories()
    local function pO(v)
        pcall(function()
            if v:IsA("Model") then
                v.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
                v.ModelStreamingMode = Enum.ModelStreamingMode.Nonatomic
            elseif v:IsA("MeshPart") then
                v.CastShadow = false; v.DoubleSided = false
                v.RenderFidelity = Enum.RenderFidelity.Performance
            elseif v:IsA("BasePart") then
                v.CastShadow = false; v.Material = Enum.Material.Plastic; v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("SpecialMesh") then
                v.TextureId = ""
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke")
                or v:IsA("Sparkles") or v:IsA("ParticleEmitter")
                or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then
                v:Destroy()
            elseif v:IsA("Attachment") then
                v.Visible = false
            end
        end)
    end
    for _, v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L = Lighting
        for _, v in pairs(L:GetDescendants()) do
            pcall(function()
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect")
                    or v:IsA("BlurEffect") or v:IsA("SunRaysEffect")
                    or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds")
                    or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then
                    v:Destroy()
                end
            end)
        end
        safeSethiddenproperty(L, "Technology", Enum.Technology.Legacy)
        L.GlobalShadows = false; L.FogEnd = 9e9; L.Brightness = 0
        local ter = workspace:FindFirstChildOfClass("Terrain")
        if ter then
            safeSethiddenproperty(ter, "Decoration", false)
            ter.WaterReflectance = 0; ter.WaterTransparency = 0.7
            ter.WaterWaveSize = 0; ter.WaterWaveSpeed = 0
        end
    end)
    workspace.DescendantAdded:Connect(function(v)
        if S.fpsBoostEnabled then task.spawn(pO, v) end
    end)
end

local function stopFPSBoost()
    S.fpsBoostEnabled = false
    restoreAccessories()
end

local function runTPFloor()
    pcall(function() executeTPDown() end)
end

getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
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

local function sanitizeStealRadius(value, fallback)
    local raw = tostring(value or ""):gsub(",", ".")
    local n = tonumber(raw)
    if not n or n ~= n or n <= 0 or n == math.huge or n == -math.huge then
        return fallback or 61
    end
    return n
end

local function setStealRadius(value, fallback)
    S.Steal.StealRadius = sanitizeStealRadius(value, fallback or S.Steal.StealRadius)
    return S.Steal.StealRadius
end
local function sanitizeStealDuration(value, fallback)
    local raw = tostring(value or ""):gsub(",", ".")
    local number = tonumber(raw)
    if not number or number ~= number or number == math.huge or number == -math.huge then
        return fallback or 1.3
    end
    return math.clamp(number, 0.05, 2)
end
local function setStealDuration(value, fallback)
    S.Steal.StealDuration = sanitizeStealDuration(value, fallback or S.Steal.StealDuration)
    return S.Steal.StealDuration
end

-- YOUT AUTO STEAL integrado en ＳＭＫㅤＨＵＢ (mantiene el menu/HUD original).
-- Se conserva el flujo de robo por fases del codigo Yout: pausa inicial,
-- espera de proximidad y finalizacion del progreso antes de disparar el prompt.
autoGrabSetDelayRadius = 9
autoGrabStopTime = 0.96
autoGrabStopEnabled = true
_plotsCache = nil
_plotsCacheTime = 0

local function getPlotsRoot()
    local now = tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function applyStealRadiusToPrompt(prompt)
    if not prompt then return end
    pcall(function()
        prompt.MaxActivationDistance = math.max(prompt.MaxActivationDistance or 0, setStealRadius(S.Steal.StealRadius, 61))
    end)
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end

    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    local rpos = root.Position
    local radius = setStealRadius(S.Steal.StealRadius, 61)
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
                    local dx, dy, dz = sp.X - rpos.X, sp.Y - rpos.Y, sp.Z - rpos.Z
                    local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
                    if dist < nearestDist and dist <= radius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and tostring(child.ActionText or ""):find("Steal") then
                                    applyStealRadiusToPrompt(child)
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
    return nearestPrompt, nearestName
end

local function resetCleanStealProgress()
    S.setProgressVisual(0)
end

-- Yout Auto Steal: rutina adaptada a S.Steal y al HUD blanco/negro de ＳＭＫㅤＨＵＢ.
local function executeSteal(prompt, podName)
    if S.Steal.isStealing or not prompt then return end

    if math.random(30) == 1 then
        for cachedPrompt in pairs(S.Steal.Data) do
            if not cachedPrompt.Parent then S.Steal.Data[cachedPrompt] = nil end
        end
    end

    if not S.Steal.Data[prompt] then
        S.Steal.Data[prompt] = {hold = {}, trigger = {}, ready = true}
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(S.Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(S.Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end

    local data = S.Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    S.Steal.isStealing = true
    S.Steal.stealStartTime = tick()
    resetCleanStealProgress()

    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end

        local startTime = tick()
        local duration = setStealDuration(S.Steal.StealDuration, 1.3)
        local promptFired = false
        local stopProgress = 0

        if autoGrabStopEnabled then
            while S.Steal.isStealing and S.Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = math.clamp(elapsed / duration, 0, 1)
                S.setProgressVisual(progress)
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > S.Steal.StealRadius then break end
                task.wait()
            end

            stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
            S.setProgressVisual(stopProgress)

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = tick()
            while S.Steal.isStealing and S.Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    resetCleanStealProgress()
                    data.ready = true
                    S.Steal.isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    resetCleanStealProgress()
                    data.ready = true
                    S.Steal.isStealing = false
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > S.Steal.StealRadius then
                        resetCleanStealProgress()
                        data.ready = true
                        S.Steal.isStealing = false
                        return
                    end
                end
                task.wait()
            end

            if S.Steal.isStealing and S.Steal.AutoStealEnabled then
                local fillStart = tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    S.setProgressVisual(totalProgress)
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while S.Steal.isStealing and S.Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local progress = math.clamp(elapsed / duration, 0, 1)
                S.setProgressVisual(progress)
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > S.Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end

        resetCleanStealProgress()
        data.ready = true
        S.Steal.isStealing = false
    end)
end

local function startAutoSteal()
    if S.Conns.autoSteal then
        S.stealActive = true
        S.Steal.AutoStealEnabled = true
        return
    end
    S.stealActive = true
    S.Steal.AutoStealEnabled = true
    S.Conns.autoSteal = RunService.Heartbeat:Connect(function()
        if not S.Steal.AutoStealEnabled or S.Steal.isStealing then return end
        local prompt, podName = findNearestPrompt()
        if prompt then executeSteal(prompt, podName) end
    end)
end

local function stopAutoSteal()
    if S.Conns.autoSteal then S.Conns.autoSteal:Disconnect(); S.Conns.autoSteal = nil end
    S.stealActive = false
    S.Steal.AutoStealEnabled = false
    if S.Conns.progress then S.Conns.progress:Disconnect(); S.Conns.progress = nil end
    S.Steal.isStealing = false
    S.Steal.stealStartTime = nil
    resetCleanStealProgress()
end

_noclipCache = {}  -- [player] = {char, parts[]}
RunService.Stepped:Connect(function(_, dt)
    S._noclipTimer = S._noclipTimer + dt
    if S._noclipTimer < 0.15 then return end  -- 6fps es suficiente para noclip
    S._noclipTimer = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local cached = _noclipCache[p]
            if not cached or cached.char ~= p.Character then
                local parts = {}
                for _, obj in ipairs(p.Character:GetDescendants()) do
                    if obj:IsA("BasePart") then table.insert(parts, obj) end
                end
                _noclipCache[p] = {char = p.Character, parts = parts}
                cached = _noclipCache[p]
            end
            for _, part in ipairs(cached.parts) do
                if part and part.Parent then part.CanCollide = false end
            end
        else
            _noclipCache[p] = nil
        end
    end
end)

RunService.RenderStepped:Connect(function()
    S._fpsCount = S._fpsCount + 1
    local now = tick()
    if now - S._lastFpsTime >= 1 then
        S.currentFPS = math.floor(S._fpsCount/(now - S._lastFpsTime))
        S._fpsCount = 0
        S._lastFpsTime = now
    end
end)

updateFloatingButtons = function()
    if not S._setPButtonActive then return end
    local fb = S._floatingButtons
    if fb.lagger then updateLaggerButtonVisual() end
    if fb.carry then S._setPButtonActive(fb.carry, fb.strokeCarry, fb.l1Carry, fb.l2Carry, S.speedMode) end
    if fb.autoLeft then S._setPButtonActive(fb.autoLeft, fb.strokeAutoLeft, fb.l1AutoLeft, fb.l2AutoLeft, S.autoLeftEnabled) end
    if fb.autoRight then S._setPButtonActive(fb.autoRight, fb.strokeAutoRight, fb.l1AutoRight, fb.l2AutoRight, S.autoRightEnabled) end
    if fb.bat then S._setPButtonActive(fb.bat, fb.strokeBat, fb.l1Bat, fb.l2Bat, S.batAimbotEnabled) end
    if S.setBatBypassVisual then S.setBatBypassVisual(S.batBypassEnabled == true) end
end

local function setUILock(enabled)
    S.lockUIEnabled = enabled == true
    if S.lockUIEnabled then S._floatingPanelDragging = false end
    -- Lock bloquea únicamente el arrastre; las acciones siguen funcionando.
    if S.mainMenuFrame then S.mainMenuFrame.Active = true end
    if S.miniToggleButton then S.miniToggleButton.Active = true end
    -- El contenedor es solo visual; nunca debe capturar toques detrás.
    if S.floatingPanelFrame then S.floatingPanelFrame.Active = false end
end

local function makeDraggable(frame, isFloatingPanel, dragTarget, onMove)
    local dragging, dragStart, startPos = false, nil, nil
    local moved = false
    local target = dragTarget or frame
    frame.Active = true
    frame.InputBegan:Connect(function(inp)
        if S.lockUIEnabled then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            if isFloatingPanel then S._floatingPanelDragging = false end
            dragStart = inp.Position
            startPos = target.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if S.lockUIEnabled or not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 2 then
                moved = true
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y
                target.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
                if onMove then pcall(onMove, target) end
                if isFloatingPanel then S._floatingPanelDragging = true end
            end
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging and moved and (isFloatingPanel or target == S.mainMenuFrame) then
                saveConfig()
            end
            dragging = false
            moved = false
            if isFloatingPanel then
                task.delay(0.12, function()
                    S._floatingPanelDragging = false
                end)
            end
        end
    end)
end

-- ===========================
-- ===========================
-- SMK — VERTICAL GUI  (black / grey / red / white)
-- ===========================

-- Paleta do hub independente de imagens de fundo.
local SMKThemeIndex = 1
local SMKThemeBases = {}
local SMKThemeReverse = {}
local SMKPaletteKeys = {"C_BG", "C_HEADER", "C_CARD", "C_CARD_HOV", "C_BORDER",
    "C_HIGHLIGHT", "C_SHADE", "C_HIGHLIGHT_BRIGHT", "C_WHITE", "C_GREY", "C_DIM",
    "C_ACCENT", "C_SEPARATOR_GRAY", "C_CARD_ACTIVE_BG"}
local SMKPaletteBases = {}
local function SMKColorKey(color)
    return string.format("%.6f/%.6f/%.6f", color.R, color.G, color.B)
end
local function SMKTint(color)
    if SMKThemeIndex == 1 then return color end
    -- Preserve deliberately colored warning/action states; tint neutral UI roles.
    local high = math.max(color.R, color.G, color.B)
    local low = math.min(color.R, color.G, color.B)
    if high - low > 0.10 then return color end
    local level = (color.R + color.G + color.B) / 3
    if SMKThemeIndex == 2 then
        return Color3.new(level, level * 0.48, level * 0.08)
    end
    return Color3.new(level * 0.72, level * 0.32, level)
end
local function SMKThemeRGB(r, g, b)
    local base = Color3.fromRGB(r, g, b)
    local key = SMKColorKey(base)
    SMKThemeBases[key] = base
    local color = SMKTint(base)
    SMKThemeReverse[SMKColorKey(color)] = base
    return color
end
local function SMKApplyColorTheme(assetId)
    local index
    for i, optionId in ipairs(HUB_COLOR_OPTIONS) do
        if optionId == assetId then index = i; break end
    end
    if not index then return false end
    local previous = SMKThemeReverse
    SMKThemeIndex = index
    SMKThemeReverse = {}
    for _, base in pairs(SMKThemeBases) do
        SMKThemeReverse[SMKColorKey(SMKTint(base))] = base
    end
    -- Explicit assignments also support executors whose script globals differ from _G.
    C_BG = SMKTint(SMKPaletteBases.C_BG)
    C_HEADER = SMKTint(SMKPaletteBases.C_HEADER)
    C_CARD = SMKTint(SMKPaletteBases.C_CARD)
    C_CARD_HOV = SMKTint(SMKPaletteBases.C_CARD_HOV)
    C_BORDER = SMKTint(SMKPaletteBases.C_BORDER)
    C_HIGHLIGHT = SMKTint(SMKPaletteBases.C_HIGHLIGHT)
    C_SHADE = SMKTint(SMKPaletteBases.C_SHADE)
    C_HIGHLIGHT_BRIGHT = SMKTint(SMKPaletteBases.C_HIGHLIGHT_BRIGHT)
    C_WHITE = SMKTint(SMKPaletteBases.C_WHITE)
    C_GREY = SMKTint(SMKPaletteBases.C_GREY)
    C_DIM = SMKTint(SMKPaletteBases.C_DIM)
    C_ACCENT = SMKTint(SMKPaletteBases.C_ACCENT)
    C_SEPARATOR_GRAY = SMKTint(SMKPaletteBases.C_SEPARATOR_GRAY)
    C_CARD_ACTIVE_BG = SMKTint(SMKPaletteBases.C_CARD_ACTIVE_BG)
    local function recolor(color)
        local base = previous[SMKColorKey(color)] or SMKThemeBases[SMKColorKey(color)]
        return base and SMKTint(base) or color
    end
    local roots = {}
    local menuRoot = S.mainMenuFrame and S.mainMenuFrame.Parent
    if menuRoot then table.insert(roots, menuRoot) end
    if S.floatingPanelGui then table.insert(roots, S.floatingPanelGui) end
    if S.stealHudCard and S.stealHudCard.Parent then table.insert(roots, S.stealHudCard.Parent) end
    for _, root in ipairs(roots) do
        for _, object in ipairs(root:GetDescendants()) do
            if object:IsA("GuiObject") then
                object.BackgroundColor3 = recolor(object.BackgroundColor3)
                if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                    object.TextColor3 = recolor(object.TextColor3)
                end
                if object:IsA("ScrollingFrame") then
                    object.ScrollBarImageColor3 = recolor(object.ScrollBarImageColor3)
                end
                -- Keep background photos and thumbnails in their original colors.
            elseif object:IsA("UIStroke") then
                object.Color = recolor(object.Color)
            elseif object:IsA("UIGradient") then
                local points = {}
                for _, point in ipairs(object.Color.Keypoints) do
                    table.insert(points, ColorSequenceKeypoint.new(point.Time, recolor(point.Value)))
                end
                object.Color = ColorSequence.new(points)
            end
        end
    end
    PLAYER_ESP_COLOR = SMKThemeRGB(255, 255, 255)
    local cache = S.espPlayerCache
    for _, data in pairs(cache and cache.players or {}) do
        if data.box and data.box.Parent then
            data.box.BackgroundColor3 = PLAYER_ESP_COLOR
            local stroke = data.box:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Color = PLAYER_ESP_COLOR end
        end
        if data.tracer and data.tracer.Parent then data.tracer.BackgroundColor3 = PLAYER_ESP_COLOR end
        if data.speedLabel and data.speedLabel.Parent then data.speedLabel.TextColor3 = PLAYER_ESP_COLOR end
        if data.nameLabel and data.nameLabel.Parent then data.nameLabel.TextColor3 = PLAYER_ESP_COLOR end
        if data.highlight and data.highlight.Parent then
            data.highlight.FillColor = PLAYER_ESP_COLOR
            data.highlight.OutlineColor = PLAYER_ESP_COLOR
        end
    end
    if S.refreshMobileTheme then S.refreshMobileTheme() end
    if S.refreshHubColorSelection then S.refreshHubColorSelection() end
    return true
end

-- ── Palette (Premium Glassmorphism) ──────────────────────────────────────
C_BG       = SMKThemeRGB(0, 0, 0)
C_HEADER   = SMKThemeRGB(0, 0, 0)
C_CARD     = SMKThemeRGB(0, 0, 0)
C_CARD_HOV = SMKThemeRGB(12, 12, 12)
C_BORDER   = SMKThemeRGB(0, 0, 0)
C_HIGHLIGHT      = SMKThemeRGB(0, 0, 0)
C_SHADE  = SMKThemeRGB(0, 0, 0)
C_HIGHLIGHT_BRIGHT = SMKThemeRGB(0, 0, 0)
C_WHITE    = SMKThemeRGB(245, 245, 245)
C_GREY     = SMKThemeRGB(160, 160, 160)
C_DIM      = SMKThemeRGB(72, 72, 72)
C_ACCENT   = SMKThemeRGB(0, 0, 0)
C_SEPARATOR_GRAY = SMKThemeRGB(0, 0, 0)
C_CARD_ACTIVE_BG = SMKThemeRGB(0, 0, 0)
SMKPaletteBases = {
    C_BG = C_BG,
    C_HEADER = C_HEADER,
    C_CARD = C_CARD,
    C_CARD_HOV = C_CARD_HOV,
    C_BORDER = C_BORDER,
    C_HIGHLIGHT = C_HIGHLIGHT,
    C_SHADE = C_SHADE,
    C_HIGHLIGHT_BRIGHT = C_HIGHLIGHT_BRIGHT,
    C_WHITE = C_WHITE,
    C_GREY = C_GREY,
    C_DIM = C_DIM,
    C_ACCENT = C_ACCENT,
    C_SEPARATOR_GRAY = C_SEPARATOR_GRAY,
    C_CARD_ACTIVE_BG = C_CARD_ACTIVE_BG
}

PANEL_W  = 290
PANEL_H  = 520
HEADER_H = 72
TABBAR_H = 42

-- ── Scrolling page factory ────────────────────────────────────────────────
local DAHUB_NUM_KEYS = {Zero="0",One="1",Two="2",Three="3",Four="4",Five="5",Six="6",Seven="7",Eight="8",Nine="9",
    KeypadZero="Num0",KeypadOne="Num1",KeypadTwo="Num2",KeypadThree="Num3",KeypadFour="Num4",KeypadFive="Num5",KeypadSix="Num6",KeypadSeven="Num7",KeypadEight="Num8",KeypadNine="Num9"}
function SMKKeyName(k) if not k then return "None" end local n = k.Name; return DAHUB_NUM_KEYS[n] or n end

-- Shared keybinding capture: one listener, no action while assigning a key.
SMKBindings = {buttons = setmetatable({}, {__mode = "k"}), active = nil, blockedUntil = 0}
function SMKBindings.refresh()
    for button, entry in pairs(SMKBindings.buttons) do
        if button.Parent then
            button.Text = SMKKeyName(entry.kb) .. " / " .. SMKKeyName(entry.gp)
        end
    end
end
function SMKBindings.assign(entry, key, isGamepad)
    if not entry or not key or key == Enum.KeyCode.Unknown or key == Enum.KeyCode.Escape then return false end
    local field = isGamepad and "gp" or "kb"
    local previous = entry[field]
    -- Swap occupied keys rather than allowing two actions on the same input.
    for _, other in pairs(S.KB) do
        if other ~= entry and other[field] == key then other[field] = previous end
    end
    entry[field] = key
    SMKBindings.refresh()
    return true
end
function SMKBindings.suppressed()
    return SMKBindings.active ~= nil or tick() < SMKBindings.blockedUntil
        or UIS:GetFocusedTextBox() ~= nil
end
function SMKBindings.capture(button, entry)
    local current = SMKBindings.active
    if current then
        if current.conn then current.conn:Disconnect() end
        SMKBindings.active = nil
        SMKBindings.refresh()
        if current.button == button then return end
    end
    local capture = {button = button}
    SMKBindings.active = capture
    button.Text = "..."
    capture.conn = UIS.InputBegan:Connect(function(input)
        local isGamepad = input.UserInputType == Enum.UserInputType.Gamepad1
        if input.UserInputType ~= Enum.UserInputType.Keyboard and not isGamepad then return end
        if input.KeyCode == Enum.KeyCode.Unknown then return end
        -- Remain blocked for this entire event, regardless of listener order.
        SMKBindings.blockedUntil = tick() + 0.2
        if input.KeyCode ~= Enum.KeyCode.Escape then
            SMKBindings.assign(entry, input.KeyCode, isGamepad)
            saveConfig()
        end
        if capture.conn then capture.conn:Disconnect() end
        SMKBindings.active = nil
        SMKBindings.refresh()
    end)
    task.delay(10, function()
        if SMKBindings.active == capture then
            if capture.conn then capture.conn:Disconnect() end
            SMKBindings.active = nil
            SMKBindings.refresh()
        end
    end)
end
function SMKBindings.register(button, entry)
    SMKBindings.buttons[button] = entry
    button.TextSize = 9
    button.TextScaled = true
    local limit = Instance.new("UITextSizeConstraint", button)
    limit.MinTextSize = 8
    limit.MaxTextSize = 10
    button.Activated:Connect(function() SMKBindings.capture(button, entry) end)
    SMKBindings.refresh()
end
-- End shared keybinding capture.

function SMKSetUserScale(kind, v, persist)
    if kind ~= "menu" and kind ~= "mobile" then return end
    v = tonumber(v)
    if not v or v ~= v or v == math.huge or v == -math.huge then return end
    v = math.clamp(v, 0.5, 2)
    if kind == "menu" then S.userMenuScale = v else S.userMobileScale = v end
    local target
    if kind == "menu" then
        target = S.mainMenuFrame and S.mainMenuFrame:FindFirstChild("Main")
    else
        target = S.floatingPanelFrame
    end
    if target then
        local sc = target:FindFirstChild("SMKUserScale")
        if not sc then sc = Instance.new("UIScale"); sc.Name = "SMKUserScale"; sc.Parent = target end
        sc.Scale = v
        if kind == "mobile" and S.refreshMobileBackgroundLayout then
            S.refreshMobileBackgroundLayout()
        end
    end
    if persist ~= false then saveConfig() end
end
local function buildGui_createScrollingPages(parent)
    local pages = {}
    for _, n in ipairs({"Speed","Main","Player","Visual","Move","Config","Keybinds","Music"}) do
        local sf = Instance.new("ScrollingFrame", parent)
        sf.Size = UDim2.new(1,0,1,0)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 3
        sf.ScrollBarImageColor3 = C_HIGHLIGHT
        sf.Visible = false
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.CanvasSize = UDim2.new(0,0,0,0)
        pcall(function() sf.ElasticBehavior = Enum.ElasticBehavior.Always end)
        pcall(function() sf.ScrollingDirection = Enum.ScrollingDirection.Y end)
        local ll = Instance.new("UIListLayout", sf)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Padding = UDim.new(0,6)
        ll.FillDirection = Enum.FillDirection.Vertical
        local pp = Instance.new("UIPadding", sf)
        pp.PaddingLeft  = UDim.new(0,10)
        pp.PaddingRight = UDim.new(0,10)
        pp.PaddingTop   = UDim.new(0,10)
        pp.PaddingBottom= UDim.new(0,18)
        pages[n] = sf
    end
    return pages
end

rowCounts = {Speed=0, Main=0, Player=0, Visual=0, Move=0, Config=0, Keybinds=0, Music=0}

-- ── Card row ──────────────────────────────────────────────────────────────
local function mkCard(pg, pages, h)
    rowCounts[pg] = rowCounts[pg] + 1
    local f = Instance.new("Frame", pages[pg])
    f.Size = UDim2.new(1,0,0,h or 38)
    f.BackgroundColor3 = C_CARD
    f.BackgroundTransparency = 0.85
    f.BorderSizePixel = 0
    f.LayoutOrder = rowCounts[pg]
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,12)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = SMKThemeRGB(68, 68, 74); stroke.Thickness = 1; stroke.Transparency = 0.55
    -- Subtle inner glow gradient
    local cardGrad = Instance.new("UIGradient", f)
    cardGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SMKThemeRGB(34, 34, 39)),
        ColorSequenceKeypoint.new(0.5, SMKThemeRGB(24, 24, 28)),
        ColorSequenceKeypoint.new(1, SMKThemeRGB(20, 20, 24)),
    })
    cardGrad.Rotation = 90
    return f
end

-- ── Section divider ───────────────────────────────────────────────────────
local function mkSection(pg, pages, text)
    rowCounts[pg] = rowCounts[pg] + 1
    local f = Instance.new("Frame", pages[pg])
    f.Size = UDim2.new(1,0,0,20)
    f.BackgroundTransparency = 1
    f.BorderSizePixel = 0
    f.LayoutOrder = rowCounts[pg]
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,-10,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = C_HIGHLIGHT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local line = Instance.new("Frame", f)
    line.Size = UDim2.new(1,-10,0,1)
    line.Position = UDim2.new(0,10,1,-1)
    line.BackgroundColor3 = C_SEPARATOR_GRAY
    line.BackgroundTransparency = 0.72
    line.BorderSizePixel = 0
end

-- ── Toggle row ────────────────────────────────────────────────────────────
local function mkToggle(pg, pages, label, defKey, defOn, onToggle, onKeyChanged)
    local card = mkCard(pg, pages, 36)
    local cardStroke = card:FindFirstChildOfClass("UIStroke")

    local lbl = Instance.new("TextLabel", card)
    lbl.Size = defKey and UDim2.new(1,-172,1,0) or UDim2.new(1,-74,1,0)
    lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C_WHITE
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local keyBtn = nil
    if defKey then
        keyBtn = Instance.new("TextButton", card)
        keyBtn.Size = UDim2.new(0,96,0,28)
        keyBtn.Position = UDim2.new(1,-156,0.5,-14)
        keyBtn.BackgroundColor3 = SMKThemeRGB(0, 0, 0)
        keyBtn.BackgroundTransparency = 0
        keyBtn.BorderSizePixel = 0
        keyBtn.ZIndex = 10
        keyBtn.Text = SMKKeyName(defKey or Enum.KeyCode.Unknown)
        keyBtn.TextColor3 = C_GREY
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 9
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,10)
        local ks = Instance.new("UIStroke", keyBtn)
        ks.Color = SMKThemeRGB(34, 34, 40)
        ks.Thickness = 1
        ks.Transparency = 0.52
        ks.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        for _, entry in pairs(S.KB) do
            if entry.kb == defKey or entry.gp == defKey then
                SMKBindings.register(keyBtn, entry)
                break
            end
        end
    end

    -- Interruptor estilo SMK Leaked: perilla centrada gris apagada y morada encendida.
    local pillBg = Instance.new("Frame", card)
    pillBg.Size = UDim2.new(0,42,0,22)
    pillBg.AnchorPoint = Vector2.new(1,0.5)
    pillBg.Position = UDim2.new(1,-12,0.5,0)
    pillBg.BackgroundColor3 = SMKThemeRGB(40,40,40)
    pillBg.BackgroundTransparency = 0
    pillBg.BorderSizePixel = 0
    pillBg.ZIndex = 6
    pillBg.ClipsDescendants = false
    Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1,0)
    local pillStroke = Instance.new("UIStroke", pillBg)
    pillStroke.Name = "TrackStroke"
    pillStroke.Color = SMKThemeRGB(225, 225, 225)
    pillStroke.Thickness = 1.2
    pillStroke.Transparency = 0.4
    local pillGradient = Instance.new("UIGradient", pillBg)
    pillGradient.Name = "TrackGradient"
    pillGradient.Rotation = 90
    pillGradient.Enabled = true
    pillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SMKThemeRGB(44,44,54)),
        ColorSequenceKeypoint.new(0.55, SMKThemeRGB(26, 26, 26)),
        ColorSequenceKeypoint.new(1, SMKThemeRGB(12,12,16)),
    })
    local dotBack = Instance.new("Frame", pillBg)
    dotBack.Name = "DotBack"
    dotBack.AnchorPoint = Vector2.new(0.5,0.5)
    dotBack.Position = UDim2.new(0.5,0,0.5,1)
    dotBack.Size = UDim2.new(0,15,0,15)
    dotBack.BackgroundColor3 = SMKThemeRGB(0,0,0)
    dotBack.BackgroundTransparency = 0.55
    dotBack.BorderSizePixel = 0
    dotBack.ZIndex = 6
    Instance.new("UICorner", dotBack).CornerRadius = UDim.new(1,0)
    local dot = Instance.new("Frame", pillBg)
    dot.Name = "Knob"
    dot.AnchorPoint = Vector2.new(0.5,0.5)
    dot.Position = UDim2.new(0.5,0,0.5,0)
    dot.Size = UDim2.new(0,13,0,13)
    dot.BackgroundColor3 = SMKThemeRGB(92,92,104)
    dot.BorderSizePixel = 0
    dot.ZIndex = 7
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local dotGradient = Instance.new("UIGradient", dot)
    dotGradient.Name = "SMKDotGradient"
    dotGradient.Rotation = 90
    dotGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SMKThemeRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, SMKThemeRGB(170,170,180)),
    })
    local dotGloss = Instance.new("Frame", dot)
    dotGloss.Name = "SMKPurpleGloss"
    dotGloss.Size = UDim2.new(0.46,0,0.24,0)
    dotGloss.Position = UDim2.new(0.22,0,0.11,0)
    dotGloss.BackgroundColor3 = SMKThemeRGB(255,255,255)
    dotGloss.BackgroundTransparency = 0.62
    dotGloss.BorderSizePixel = 0
    dotGloss.ZIndex = 8
    Instance.new("UICorner", dotGloss).CornerRadius = UDim.new(1,0)
    local dotScale = Instance.new("UIScale", dot)
    dotScale.Scale = 1

    local isOn = defOn or false
    local function setV(on)
        isOn = on
        local fadeInfo = TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        TS_G:Create(dot, fadeInfo, {
            BackgroundColor3 = on and C_BG or C_WHITE,
            Position = on and UDim2.new(1,-11,0.5,0) or UDim2.new(0,11,0.5,0),
            Size = UDim2.fromOffset(16,16),
        }):Play()
        dotGradient.Enabled = not on
        dotGloss.BackgroundTransparency = on and 0.8 or 0.38
        pillGradient.Enabled = true
        -- Estado visual solicitado: activado = blanco puro; desactivado = negro puro.
        pillGradient.Color = on and ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
        }) or ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
        })
        TS_G:Create(pillBg, fadeInfo, {BackgroundColor3 = on and C_WHITE or Color3.fromRGB(0, 0, 0)}):Play()
        TS_G:Create(pillStroke, fadeInfo, {
            Color = on and C_HIGHLIGHT_BRIGHT or C_BORDER,
            Transparency = on and 0.1 or 0.38,
        }):Play()
        TS_G:Create(dotBack, fadeInfo, {
            Position = on and UDim2.new(1,-11,0.5,1) or UDim2.new(0,11,0.5,1),
            BackgroundTransparency = on and 0.78 or 0.55,
        }):Play()
        if cardStroke then
            TS_G:Create(cardStroke, fadeInfo, {
                Color = on and C_HIGHLIGHT or C_BORDER,
                Transparency = on and 0.28 or 0.55,
            }):Play()
        end
    end

    local clickArea = Instance.new("TextButton", card)
    clickArea.Size = defKey and UDim2.new(1,-172,1,0) or UDim2.new(1,0,1,0)
    clickArea.BackgroundTransparency = 1; clickArea.Text = ""; clickArea.ZIndex = 8
    local function toggleRow()
        if SMKBindings.active then return end
        isOn = not isOn; setV(isOn)
        if onToggle then onToggle(isOn) end
    end
    clickArea.Activated:Connect(toggleRow)
    if defKey then
        local switchTap = Instance.new("TextButton", card)
        switchTap.Size = UDim2.new(0,54,1,0)
        switchTap.Position = UDim2.new(1,-58,0,0)
        switchTap.BackgroundTransparency = 1
        switchTap.Text = ""
        switchTap.ZIndex = 9
        switchTap.Activated:Connect(toggleRow)
    end
    clickArea.MouseEnter:Connect(function()
        TS_G:Create(card, TweenInfo.new(0.12), {BackgroundColor3 = C_CARD_HOV}):Play()
    end)
    clickArea.MouseLeave:Connect(function()
        TS_G:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = C_CARD}):Play()
    end)

    setV(isOn)
    return setV, keyBtn
end

-- ── Number input row ──────────────────────────────────────────────────────
local function mkInput(pg, pages, label, default, onChange, speedKey)
    local card = mkCard(pg, pages, 36)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(0.55,-8,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = label
    lbl.TextColor3 = C_WHITE; lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", card)
    box.Size = UDim2.new(0,66,0,26); box.Position = UDim2.new(1,-74,0.5,-13)
    box.BackgroundColor3 = SMKThemeRGB(18, 18, 18); box.BorderSizePixel = 0
    box.Text = tostring(default); box.TextColor3 = C_WHITE
    box.Font = Enum.Font.GothamBlack; box.TextSize = 11
    box.ClearTextOnFocus = false; box.MultiLine = false
    pcall(function() box.ReturnKeyType = Enum.ReturnKeyType.Done end)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = C_BORDER; boxStroke.Thickness = 0.8
    local lastVal = tostring(default); local isFocused = false
    if speedKey then
        lbl.Size = UDim2.new(1, -144, 1, 0)
        lbl.TextWrapped = true
        box.Size = UDim2.fromOffset(48, 26)
        box.Position = UDim2.new(1, -94, 0.5, -13)
        local function addSpeedButton(text, offset, delta)
            local button = Instance.new("TextButton", card)
            button.Name = delta > 0 and "SpeedPlus" or "SpeedMinus"
            button.Size = UDim2.fromOffset(28, 26)
            button.Position = UDim2.new(1, offset, 0.5, -13)
            button.Text = text
            button.TextColor3 = C_WHITE
            button.BackgroundColor3 = box.BackgroundColor3
            button.BorderSizePixel = 0
            button.Font = Enum.Font.GothamBold
            button.TextSize = 18
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = C_BORDER
            stroke.Thickness = 0.8
            button.Activated:Connect(function()
                -- Read the applied speed, not an uncommitted or stale text value.
                local current = tonumber(S[speedKey])
                if not current then return end
                local nextValue = current + delta
                if nextValue <= 0 or nextValue > 500 then return end
                isFocused = false
                pcall(function() box:ReleaseFocus(false) end)
                onChange(nextValue)
                lastVal = tostring(S[speedKey])
                box.Text = lastVal
                TS_G:Create(boxStroke, TweenInfo.new(0.15), {Color = C_BORDER}):Play()
            end)
        end
        addSpeedButton("-", -126, -0.5)
        addSpeedButton("+", -40, 0.5)
    end
    box.Focused:Connect(function()
        isFocused = true
        TS_G:Create(boxStroke, TweenInfo.new(0.15), {Color = C_HIGHLIGHT}):Play()
    end)
    local function applyVal()
        if not isFocused then return end
        isFocused = false
        TS_G:Create(boxStroke, TweenInfo.new(0.15), {Color = C_BORDER}):Play()
        local n = tonumber(box.Text)
        if n then lastVal = tostring(n); box.Text = lastVal; onChange(n)
        else box.Text = lastVal end
        pcall(function() box:ReleaseFocus(false) end)
    end
    box.FocusLost:Connect(function()
        if isFocused then
            isFocused = false
            TS_G:Create(boxStroke, TweenInfo.new(0.15), {Color = C_BORDER}):Play()
            local n = tonumber(box.Text)
            if n then lastVal = tostring(n); box.Text = lastVal; onChange(n)
            else box.Text = lastVal end
        end
    end)
    pcall(function() box.ReturnPressedFromOnScreenKeyboard:Connect(applyVal) end)
    UIS.TouchTap:Connect(function(positions)
        if not isFocused then return end
        pcall(function()
            local abs = box.AbsolutePosition; local sz = box.AbsoluteSize; local tp = positions[1]
            if tp and not (tp.X>=abs.X and tp.X<=abs.X+sz.X and tp.Y>=abs.Y and tp.Y<=abs.Y+sz.Y) then
                applyVal()
            end
        end)
    end)
    return box
end

-- ── Action / keybind row ──────────────────────────────────────────────────
local function mkActionRow(pg, pages, labelText, keyEntry, onRun)
    local card = mkCard(pg, pages, 36)
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1,-142,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = labelText
    lbl.TextColor3 = C_WHITE; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Toda la fila ejecuta la acción al tocarla; el botón de tecla sigue permitiendo reasignarla.
    if onRun then
        local actionTap = Instance.new("TextButton", card)
        actionTap.Name = "ActionTapArea"
        actionTap.Size = keyEntry and UDim2.new(1, -132, 1, 0) or UDim2.new(1, 0, 1, 0)
        actionTap.BackgroundTransparency = 1
        actionTap.Text = ""
        actionTap.AutoButtonColor = false
        actionTap.Active = true
        actionTap.ZIndex = 2
        actionTap.Activated:Connect(function()
            task.spawn(onRun)
        end)
    end

    if keyEntry then
        local keyBtn = Instance.new("TextButton", card)
        keyBtn.Size = UDim2.new(0,112,0,24); keyBtn.Position = UDim2.new(1,-122,0.5,-12)
        keyBtn.BackgroundColor3 = SMKThemeRGB(18, 18, 18); keyBtn.BorderSizePixel = 0; keyBtn.ZIndex = 10
        keyBtn.Text = SMKKeyName(keyEntry.kb or keyEntry.gp or Enum.KeyCode.Unknown)
        keyBtn.TextColor3 = C_GREY; keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 9
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0,7)
        local ks = Instance.new("UIStroke", keyBtn); ks.Color = C_BORDER; ks.Thickness = 0.8
        SMKBindings.register(keyBtn, keyEntry)
    end
    return function(newLabel)
        if lbl and lbl.Parent then lbl.Text = newLabel end
    end
end

-- ── Mini toggle (minimised button) ────────────────────────────────────────
local function buildGui_createMiniToggle(gui, showGuiFn)
    local btn = Instance.new("TextButton", gui)
    btn.Name = "MiniToggle"
    btn.Size = UDim2.new(0,152,0,40)
    btn.Position = UDim2.new(0,18,0,60)
    btn.BackgroundColor3 = SMKThemeRGB(12, 12, 16)
    btn.BackgroundTransparency = 0.02
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 20
    btn.Visible = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,20) -- esquinas más redondeadas
    local ms = Instance.new("UIStroke", btn)
    ms.Color = C_HIGHLIGHT
    ms.Thickness = 1
    ms.Transparency = 0.45
    local titleIcon = Instance.new("TextLabel", btn)
    titleIcon.Name = "MiniTitleImage"
    titleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    titleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    titleIcon.Size = UDim2.new(1, 0, 1, 0)
    titleIcon.BackgroundTransparency = 1
    titleIcon.Text = SMKBrandStyle.text
    titleIcon.Font = Enum.Font.GothamBlack
    titleIcon.TextSize = 20
    titleIcon.TextColor3 = SMKThemeRGB(255, 255, 255)
    titleIcon.ZIndex = 21
    SMKBrandStyle.apply(titleIcon)
    makeDraggable(btn, false)
    btn.MouseButton1Click:Connect(showGuiFn)
    return btn
end

-- ── Kroblox (ported from Ace Duels) ────────────────────────────────────────
_G._SMKKrobloxMode = _G._SMKKrobloxMode or "Off"
DAHUB_KROBLOX_ASSETS = {
    ["Left Leg"] = {
        id = "rbxassetid://139607673", targetBodyPart = "LeftUpperLeg",
        partsToHide = {"LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
        scale = Vector3.new(1, 1, 1), audio = "rbxassetid://87998522263554",
        offset = CFrame.new(0, 0, 0) * CFrame.Angles(1.2, 0, 0),
    },
    ["Right Leg"] = {
        id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg",
        partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"},
        scale = Vector3.new(1, 1, 1), audio = "rbxassetid://135315310485417",
        offset = CFrame.new(0, 0, 0) * CFrame.Angles(0, 1.2, 0),
    },
}
local function clearSMKKroblox()
    local character = LP.Character
    if not character then return end
    for _, name in ipairs({"Korblox_LeftLeg", "Korblox_RightLeg", "SMKKroblox_LeftLeg", "SMKKroblox_RightLeg"}) do
        local object = character:FindFirstChild(name)
        if object then pcall(function() object:Destroy() end) end
    end
    for _, name in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            part.Transparency = 0
            part.LocalTransparencyModifier = 0
        end
    end
end

local function attachSMKKroblox(whichLeg)
    local data = DAHUB_KROBLOX_ASSETS[whichLeg]
    local character = LP.Character
    if not data or not character then return false end
    local target = character:FindFirstChild(data.targetBodyPart)
    if not target then return false end
    local old = character:FindFirstChild("Korblox_" .. whichLeg:gsub("%s+", ""))
    if old then old:Destroy() end
    for _, name in ipairs(data.partsToHide) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then part.Transparency = 1 end
    end
    local ok, objects = pcall(function() return game:GetObjects(data.id) end)
    if not ok or not objects or #objects == 0 then return false end
    local object = objects[1]
    object.Name = "Korblox_" .. whichLeg:gsub("%s+", "")
    local meshPart = object:IsA("BasePart") and object or object:FindFirstChildWhichIsA("BasePart", true)
    if not meshPart then pcall(function() object:Destroy() end); return false end
    meshPart.Size = meshPart.Size * data.scale
    meshPart.CanCollide = false
    meshPart.CanTouch = false
    meshPart.CanQuery = false
    meshPart.Massless = true
    meshPart.CFrame = target.CFrame * data.offset
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = target
    weld.Part1 = meshPart
    weld.Parent = meshPart
    object.Parent = character
    return true
end

_G._SMKApplyKroblox = function(mode)
    mode = ({Off=true, Left=true, Right=true, Both=true})[mode] and mode or "Off"
    clearSMKKroblox()
    S.krobloxMode = mode
    _G._SMKKrobloxMode = mode
    if mode == "Left" or mode == "Both" then pcall(attachSMKKroblox, "Left Leg") end
    if mode == "Right" or mode == "Both" then pcall(attachSMKKroblox, "Right Leg") end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.6)
    if _G._SMKKrobloxMode ~= "Off" then
        pcall(_G._SMKApplyKroblox, _G._SMKKrobloxMode)
    end
end)

-- ── Tab content builders ──────────────────────────────────────────────────
local function buildSpeedTab(pages)
    mkSection("Speed", pages, "Speed Values")
    S.normalBox  = mkInput("Speed", pages, "Normal Speed",   S.NS, function(v)
        if v>0 and v<=500 then S.NS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end, "NS")
    S.carryBox   = mkInput("Speed", pages, "Carry Speed",    S.CS, function(v)
        if v>0 and v<=500 then S.CS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end, "CS")
    S.laggerBox  = mkInput("Speed", pages, "Lagger Normal Speed", S.LS, function(v)
        if v>0 and v<=500 then S.LS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end, "LS")
    S.laggerCarryBox = mkInput("Speed", pages, "Lagger Carry Speed", S.LCS, function(v)
        if v>0 and v<=500 then S.LCS=v; S.applySpeedVelocityNow(); S.restartMovement(); saveConfig() end end, "LCS")
    mkSection("Speed", pages, "Modes")
    S.speedClk, _ = mkToggle("Speed", pages, "Carry Mode", S.KB.SpeedToggle.kb, S.speedMode, function(on)
        if on and S.laggerMode~=0 then S.laggerMode=0; if S.setLaggerVisual then S.setLaggerVisual(false) end; updateLaggerButtonVisual() end
        S.speedMode = on
        if on then S.setCarrySpeedMode() else S.setNormalSpeedMode() end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.SpeedToggle.gp=k; S.KB.SpeedToggle.kb=nil
        else S.KB.SpeedToggle.kb=k; S.KB.SpeedToggle.gp=nil end; saveConfig()
    end)
    S.setLaggerVisual, _ = mkToggle("Speed", pages, "Lagger Mode", S.KB.LaggerToggle.kb, S.laggerMode ~= 0, function(on)
        if on then
            if S.speedClk then S.speedClk(false) end
            S.setLaggerNormalMode()
        else
            S.setLaggerOffMode()
        end
        updateLaggerButtonVisual(); S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.LaggerToggle.gp=k; S.KB.LaggerToggle.kb=nil
        else S.KB.LaggerToggle.kb=k; S.KB.LaggerToggle.gp=nil end; saveConfig()
    end)
    -- Speed Bypass: control visual seguro. No ejecuta remotes ni spam al servidor.
    mkSection("Speed", pages, "Speed Bypass")
    S.speedBypassVisualEnabled = false
    S.setSpeedBypassVisual, _ = mkToggle("Speed", pages, "Speed Bypass (visual)", nil, false, function(on)
        S.speedBypassVisualEnabled = on
    end)
end

-- ==================== DAHUB BAT SKINS ====================
do
-- Complete Bat catalog from the supplied Prime.vs, including original orientation and slash sounds.
SMKBatSkin = {}
DAHUB_BAT_SKINS = {
    {name = "Off"},
    {
        name = "Epic Katana",
        id = "rbxassetid://14052995337",
        soundId = "rbxassetid://111808555599832",
        c0 = CFrame.new(),
    },
    {
        name = "Bloody Katana",
        id = "rbxassetid://126653333198410",
        soundId = "rbxassetid://111808555599832",
        c0 = CFrame.new(),
    },
}
SMKBatSkin.cache = {}
SMKBatSkin.originals = setmetatable({}, {__mode = "k"})
SMKBatSkin.soundConnections = setmetatable({}, {__mode = "k"})
SMKBatSkin.watched = setmetatable({}, {__mode = "k"})

function SMKBatSkin.smkLoadBatSkin(id)
    if SMKBatSkin.cache[id] then return SMKBatSkin.cache[id] end
    local ok, objects = pcall(function() return game:GetObjects(id) end)
    if not ok or type(objects) ~= "table" or #objects == 0 then return nil end
    SMKBatSkin.cache[id] = objects[1]
    return objects[1]
end

function SMKBatSkin.smkIsBat(tool)
    return tool and tool:IsA("Tool") and tool.Name:lower() == "bat"
end

function SMKBatSkin.smkSetBatSlashSound(tool, soundId)
    if not tool then return end
    for _, sound in ipairs(tool:GetDescendants()) do
        if sound:IsA("Sound") and sound.Name == "Slash" then
            local original = sound:GetAttribute("SMKOriginalSlashSound")
            if soundId then
                if original == nil then sound:SetAttribute("SMKOriginalSlashSound", sound.SoundId) end
                sound.SoundId = soundId
            elseif original ~= nil then
                sound.SoundId = original
                sound:SetAttribute("SMKOriginalSlashSound", nil)
            end
        end
    end
end

function SMKBatSkin.smkRestoreBatSkin(tool, clearOriginal)
    if not SMKBatSkin.smkIsBat(tool) then return end
    local handle = tool:FindFirstChild("Handle")
    local original = SMKBatSkin.originals[tool]
    if handle then
        -- En Off no debe quedar visible ningún modelo, weld o parte de la skin.
        for _, child in ipairs(handle:GetChildren()) do
            if not child:IsA("Sound") then
                pcall(function() child:Destroy() end)
            end
        end
    end
    if handle and original then
        handle.Transparency = original.transparency
        handle.CanCollide = original.canCollide
        handle.CanTouch = original.canTouch
        handle.CanQuery = original.canQuery
        handle.Size = original.size
    elseif handle then
        handle.Transparency = 0
    end
    if original and original.grip then tool.Grip = original.grip end
    SMKBatSkin.smkSetBatSlashSound(tool, nil)
    local soundConnection = SMKBatSkin.soundConnections[tool]
    if clearOriginal ~= false and soundConnection then
        pcall(function() soundConnection:Disconnect() end)
        SMKBatSkin.soundConnections[tool] = nil
    end
    if clearOriginal ~= false then SMKBatSkin.originals[tool] = nil end
end

function SMKBatSkin.smkPrepareBatSkin(tool, entry)
    if not SMKBatSkin.smkIsBat(tool) or not entry or not entry.id then return end
    local toolHandle = tool:FindFirstChild("Handle")
    if not toolHandle then return end

    if not SMKBatSkin.originals[tool] then
        SMKBatSkin.originals[tool] = {
            grip = tool.Grip,
            transparency = toolHandle.Transparency,
            canCollide = toolHandle.CanCollide,
            canTouch = toolHandle.CanTouch,
            canQuery = toolHandle.CanQuery,
            size = toolHandle.Size,
        }
    end

    SMKBatSkin.smkRestoreBatSkin(tool, false)
    for _, child in ipairs(toolHandle:GetChildren()) do
        if not child:IsA("Sound") then pcall(function() child:Destroy() end) end
    end

    local katanaRoot = SMKBatSkin.smkLoadBatSkin(entry.id)
    if not katanaRoot then return end
    local modelClone = katanaRoot:Clone()
    modelClone.Name = "SMKBatSkinModel"
    modelClone.Parent = toolHandle

    local srcHandle = modelClone:IsA("BasePart") and modelClone
        or modelClone:FindFirstChild("Handle", true)
        or modelClone:FindFirstChildWhichIsA("BasePart", true)
    if not srcHandle then modelClone:Destroy(); return end
    local parts = {}
    if modelClone:IsA("BasePart") then parts[#parts + 1] = modelClone end
    for _, inst in ipairs(modelClone:GetDescendants()) do
        if inst:IsA("BasePart") then parts[#parts + 1] = inst end
    end
    local pivot = srcHandle.CFrame
    local orientFix = entry.c0 or CFrame.new()
    for _, part in ipairs(parts) do
        local relative = pivot:ToObjectSpace(part.CFrame)
        part.Anchored = false
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.CFrame = toolHandle.CFrame * orientFix * relative
        local weld = Instance.new("Weld", part)
        weld.Name = "SMKBatSkinWeld"
        weld.Part0 = toolHandle
        weld.Part1 = part
        weld.C0 = orientFix * relative
        weld.C1 = CFrame.new()
    end
    toolHandle.Transparency = 1

    local previousSoundConnection = SMKBatSkin.soundConnections[tool]
    if previousSoundConnection then
        pcall(function() previousSoundConnection:Disconnect() end)
        SMKBatSkin.soundConnections[tool] = nil
    end
    SMKBatSkin.smkSetBatSlashSound(tool, entry.soundId)
    SMKBatSkin.soundConnections[tool] = tool.DescendantAdded:Connect(function(obj)
        if S.batSkinMode == entry.name and obj:IsA("Sound") and obj.Name == "Slash" then
            if obj:GetAttribute("SMKOriginalSlashSound") == nil then
                obj:SetAttribute("SMKOriginalSlashSound", obj.SoundId)
            end
            obj.SoundId = entry.soundId
        end
    end)
end

function SMKBatSkin.smkApplyBatSkin(tool)
    if not SMKBatSkin.smkIsBat(tool) then return end
    if S.batSkinMode == "Off" then
        SMKBatSkin.smkRestoreBatSkin(tool)
        return
    end
    local entry
    for _, candidate in ipairs(DAHUB_BAT_SKINS) do
        if candidate.name == S.batSkinMode then entry = candidate; break end
    end
    if entry then SMKBatSkin.smkPrepareBatSkin(tool, entry) end
end

function SMKBatSkin.smkScanBatSkins(parent)
    if not parent then return end
    for _, child in ipairs(parent:GetChildren()) do
        if SMKBatSkin.smkIsBat(child) then task.spawn(SMKBatSkin.smkApplyBatSkin, child) end
    end
end

function SMKBatSkin.smkWatchBatSkinContainer(parent)
    if not parent or SMKBatSkin.watched[parent] then return end
    SMKBatSkin.watched[parent] = true
    table.insert(S.batSkinConnections, parent.ChildAdded:Connect(function(child)
        task.wait(0.1)
        if SMKBatSkin.smkIsBat(child) then SMKBatSkin.smkApplyBatSkin(child) end
    end))
    SMKBatSkin.smkScanBatSkins(parent)
end

function SMKBatSkin.smkWatchBatSkinCharacter(character)
    SMKBatSkin.smkWatchBatSkinContainer(character)
    SMKBatSkin.smkWatchBatSkinContainer(LP:FindFirstChildOfClass("Backpack"))
    if S.batSkinMode ~= "Off" then
        task.delay(0.35, function()
            if LP.Character == character then
                SMKBatSkin.smkScanBatSkins(character)
                SMKBatSkin.smkScanBatSkins(LP:FindFirstChildOfClass("Backpack"))
            end
        end)
    end
end

function SMKBatSkin.smkSetBatSkin(mode, shouldSave)
    local valid = false
    for _, entry in ipairs(DAHUB_BAT_SKINS) do
        if entry.name == mode then valid = true; break end
    end
    S.batSkinMode = valid and mode or "Off"
    SMKBatSkin.smkScanBatSkins(LP.Character)
    SMKBatSkin.smkScanBatSkins(LP:FindFirstChildOfClass("Backpack"))
    if S.batSkinSelectorLabel then S.batSkinSelectorLabel.Text = S.batSkinMode end
    if shouldSave then saveConfig() end
end

function SMKBatSkin.smkCycleBatSkin(direction)
    local index = 1
    for i, entry in ipairs(DAHUB_BAT_SKINS) do
        if entry.name == S.batSkinMode then index = i; break end
    end
    index = index + (direction or 1)
    if index < 1 then index = #DAHUB_BAT_SKINS end
    if index > #DAHUB_BAT_SKINS then index = 1 end
    SMKBatSkin.smkSetBatSkin(DAHUB_BAT_SKINS[index].name, true)
end

S.setBatSkin = SMKBatSkin.smkSetBatSkin
S.cycleBatSkin = SMKBatSkin.smkCycleBatSkin

LP.CharacterAdded:Connect(function(character)
    task.wait(0.2)
    SMKBatSkin.smkWatchBatSkinCharacter(character)
end)
LP.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") then SMKBatSkin.smkWatchBatSkinContainer(child) end
end)
SMKBatSkin.smkWatchBatSkinCharacter(LP.Character)
end

-- ==================== PRIME.VS MEDUSA COSMETIC ====================
do
SMKMedusaSkin = {watched = setmetatable({}, {__mode="k"})}
function SMKMedusaSkin.load(assetId)
    local ok, objects = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(assetId)) end)
    if ok and type(objects)=="table" and #objects>0 then return objects end
    local loaded
    pcall(function() loaded=game:GetService("InsertService"):LoadAsset(tonumber(assetId)) end)
    return loaded and {loaded} or nil
end
local function SMKClearMedusaVisual(tool)
if not tool then return end
pcall(function()
local folder = tool:FindFirstChild("Hub073GearVisual")
if folder then folder:Destroy() end
local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if handle then
for _, ch in ipairs(handle:GetChildren()) do
if ch.Name == "Hub073GearMesh" or (ch:IsA("SpecialMesh") and ch:GetAttribute("Hub073")) then
ch:Destroy()
end
end
local orig = tool:GetAttribute("Hub073OrigHandleTrans")
if orig ~= nil then
handle.Transparency = orig
elseif handle.Transparency >= 0.99 then
handle.Transparency = 0
end
end
end)
end
local function SMKApplyMedusaAsset(tool, assetId)
if not tool or not assetId then return false end
if tool:GetAttribute("Hub073Applying") then return false end
tool:SetAttribute("Hub073Applying", true)
assetId = tonumber(tostring(assetId):match("%d+")) or assetId
local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
if not handle then
tool:SetAttribute("Hub073Applying", nil)
return false
end
local success = false
pcall(function()
SMKClearMedusaVisual(tool)
if tool:GetAttribute("Hub073OrigHandleTrans") == nil then
tool:SetAttribute("Hub073OrigHandleTrans", handle.Transparency)
end
local objs = SMKMedusaSkin.load(assetId)
if not objs or #objs == 0 then return end
local folder = Instance.new("Folder")
folder.Name = "Hub073GearVisual"
folder.Parent = tool
local srcTool, srcHandle
for _, o in ipairs(objs) do
if o:IsA("Tool") then
srcTool = o
srcHandle = o:FindFirstChild("Handle") or o:FindFirstChildWhichIsA("BasePart")
break
end
local t = o:FindFirstChildOfClass("Tool") or o:FindFirstChildWhichIsA("Tool", true)
if t then
srcTool = t
srcHandle = t:FindFirstChild("Handle") or t:FindFirstChildWhichIsA("BasePart")
break
end
end
if not srcHandle then
for _, o in ipairs(objs) do
if o:IsA("BasePart") then srcHandle = o; break end
local p = o:FindFirstChildWhichIsA("BasePart", true)
if p then srcHandle = p; break end
end
end
local skinConfig = nil
local orientFix = skinConfig and skinConfig.c0 or CFrame.new()
local parts = {}
local root = srcTool or objs[1]
if root then
if root:IsA("BasePart") then table.insert(parts, root) end
if root:IsA("Accessory") then
local ah = root:FindFirstChild("Handle")
if ah then table.insert(parts, ah) end
end
for _, d in ipairs(root:GetDescendants()) do
if d:IsA("BasePart") then table.insert(parts, d) end
end
end
if #parts == 0 and srcHandle then
table.insert(parts, srcHandle)
end
local seen = {}
local unique = {}
for _, p in ipairs(parts) do
if not seen[p] then
seen[p] = true
table.insert(unique, p)
end
end
parts = unique
if #parts > 0 then
handle.Transparency = 1
local pivot = srcHandle or parts[1]
for _, src in ipairs(parts) do
local okc, clone = pcall(function() return src:Clone() end)
if okc and clone then
for _, child in ipairs(clone:GetDescendants()) do
if child:IsA("LuaSourceContainer") or child:IsA("Sound") then child:Destroy() end
end
clone.Name = "GV_" .. tostring(src.Name)
clone.Anchored = false
clone.CanCollide = false
clone.Massless = true
pcall(function()
clone.CanQuery = false
clone.CanTouch = false
end)
local rel = pivot.CFrame:ToObjectSpace(src.CFrame)
clone.CFrame = handle.CFrame * orientFix * rel
clone.Parent = folder
local w = Instance.new("Weld")
w.Name = "Hub073GearWeld"
w.Part0 = handle
w.Part1 = clone
w.C0 = orientFix * rel
w.C1 = CFrame.new()
w.Parent = clone
success = true
end
end
elseif srcHandle then
local mesh = srcHandle:FindFirstChildOfClass("SpecialMesh")
if mesh then
local m = mesh:Clone()
m.Name = "Hub073GearMesh"
m:SetAttribute("Hub073", true)
m.Parent = handle
success = true
end
for _, d in ipairs(srcHandle:GetChildren()) do
if d:IsA("Decal") or d:IsA("Texture") then
pcall(function() d:Clone().Parent = handle end)
end
end
pcall(function()
handle.Color = srcHandle.Color
handle.Material = srcHandle.Material
handle.Reflectance = srcHandle.Reflectance
end)
end
for _, o in ipairs(objs) do
pcall(function() o:Destroy() end)
end
end)
tool:SetAttribute("Hub073Applying", nil)
-- Original Medusa sounds are untouched, exactly as in Prime.vs.
return success
end

function SMKMedusaSkin.apply(tool)
    if not tool or not tool:IsA("Tool") or not tool.Name:lower():find("medusa",1,true) then return end
    if S.medusaSkinMode == "Medusa 1" then
        SMKApplyMedusaAsset(tool,11563251)
    else
        SMKClearMedusaVisual(tool)
    end
end
function SMKMedusaSkin.scan(parent)
    if not parent then return end
    for _, tool in ipairs(parent:GetChildren()) do task.spawn(SMKMedusaSkin.apply,tool) end
end
function SMKMedusaSkin.watch(parent)
    if not parent or SMKMedusaSkin.watched[parent] then return end
    SMKMedusaSkin.watched[parent]=true
    parent.ChildAdded:Connect(function(tool) task.wait(0.15); SMKMedusaSkin.apply(tool) end)
    SMKMedusaSkin.scan(parent)
end
function SMKMedusaSkin.set(mode,shouldSave)
    S.medusaSkinMode=mode=="Medusa 1" and "Medusa 1" or "Off"
    SMKMedusaSkin.scan(LP.Character)
    SMKMedusaSkin.scan(LP:FindFirstChildOfClass("Backpack"))
    if S.medusaSkinSelectorLabel then S.medusaSkinSelectorLabel.Text=S.medusaSkinMode end
    if shouldSave then saveConfig() end
end
S.setMedusaSkin=SMKMedusaSkin.set
LP.CharacterAdded:Connect(function(character) SMKMedusaSkin.watch(character) end)
LP.ChildAdded:Connect(function(child) if child:IsA("Backpack") then SMKMedusaSkin.watch(child) end end)
SMKMedusaSkin.watch(LP.Character)
SMKMedusaSkin.watch(LP:FindFirstChildOfClass("Backpack"))
end

-- ==================== DAHUB DISPLAY MODE / COMPLETE SKINS ====================
do
SMKDisplaySkin = {}
DAHUB_SKIN_ORDER = {"Off", "PURPLE", "BLUE", "RED", "BLACK", "GREEN", "WHITE", "BLEED 1", "BLEED 2", "BLEED 3", "BLEED 4", "BLEED 5"}
DAHUB_SKIN_SETS = {
    ["BLEED 1"] = {accessories={306969564}, headless=false, korblox="Right", shirtTemplate="rbxassetid://10632503795", pantsTemplate="rbxassetid://123161592384863", headMesh="rbxassetid://134079402", headTexture="rbxassetid://133940918", color=Color3.fromRGB(255,255,255)},
    ["BLEED 2"] = {accessories={1744060292}, headless=false, korblox="Right", shirtTemplate="rbxassetid://11526718530", pantsTemplate="rbxassetid://93710523210027", headMesh="rbxassetid://134079402", headTexture="rbxassetid://133940918", color=Color3.fromRGB(255,255,255)},
    ["BLEED 3"] = {accessories={112564966849233}, headless=false, korblox="Right", shirtTemplate="rbxassetid://11849088376", pantsTemplate="rbxassetid://16534673928", headMesh="rbxassetid://134079402", headTexture="rbxassetid://133940918", color=Color3.fromRGB(255,255,255)},
    ["BLEED 4"] = {accessories={10159600649}, headless=false, korblox="Off", shirtTemplate="rbxassetid://9683332638", pantsTemplate="rbxassetid://93182020184041", headMesh="rbxassetid://134079402", headTexture="rbxassetid://133940918", color=Color3.fromRGB(255,255,255)},
    ["BLEED 5"] = {accessories={8349240186}, headless=false, korblox="Off", shirtTemplate="rbxassetid://11926549070", pantsTemplate="rbxassetid://13189494471", headMesh="rbxassetid://16673245747", headTexture=nil, color=Color3.fromRGB(255,255,255)},
    PURPLE = {hats="1744060292,439945661,1125510,1029025", hair="", headless=true, korblox="Right", accessories={1744060292,439945661,1125510,1029025,11748356,8465506143,11444217173}, clothing={7424637509,7689651773}, color=SMKThemeRGB(200, 200, 200)},
    BLUE = {hats="74891470", hair="16630147,6346833550,6594911228,6594919952,6823338112,7097747842", headless=true, korblox="Right", accessories={74891470,16630147,6346833550,6594911228,6594919952,6823338112,7097747842}, clothing={18423061209,18423154566}, color=SMKThemeRGB(55,145,255)},
    RED = {hats="215718515,439945661", hair="7183785281", headless=true, korblox="Right", accessories={215718515,439945661,7183785281}, clothing={15998365201,7689651773}, color=SMKThemeRGB(235,62,72)},
    BLACK = {hats="10159600649,439946249,17798262442,92482095662016", hair="139101716417676", headless=true, korblox="Right", accessories={10159600649,439946249,17798262442,92482095662016,139101716417676,12490213797}, clothing={18766106994,13925390578}, color=SMKThemeRGB(24,24,30)},
    GREEN = {hats="553970961,1744060292", hair="93268856876777", headless=true, korblox="Right", accessories={553970961,1744060292,93268856876777}, clothing={9478068776,6348682339}, color=SMKThemeRGB(62,210,112)},
    WHITE = {hats="74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427", hair="126447390530523", headless=true, korblox="Right", accessories={74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,126447390530523}, clothing={88032876921227,108259950755140}, color=SMKThemeRGB(238,238,244)},
}
DAHUB_ASSET_PROPERTIES = {
    [1744060292]="HatAccessory", [439945661]="HatAccessory", [1125510]="HatAccessory", [1029025]="HatAccessory", [8465506143]="HatAccessory", [74891470]="HatAccessory", [215718515]="HatAccessory", [10159600649]="HatAccessory", [439946249]="HatAccessory", [17798262442]="HatAccessory", [92482095662016]="HatAccessory", [553970961]="HatAccessory", [1016143686]="HatAccessory", [89012651581593]="HatAccessory", [88365652378427]="HatAccessory",
    [16630147]="HairAccessory", [6346833550]="HairAccessory", [6594911228]="HairAccessory", [6594919952]="HairAccessory", [6823338112]="HairAccessory", [7097747842]="HairAccessory", [7183785281]="HairAccessory", [139101716417676]="HairAccessory", [93268856876777]="HairAccessory", [126447390530523]="HairAccessory",
    [11748356]="FaceAccessory", [12490213797]="FaceAccessory", [11444217173]="NeckAccessory",
    [7424637509]="Shirt", [18423061209]="Shirt", [15998365201]="Shirt", [18766106994]="Shirt", [9478068776]="Shirt", [88032876921227]="Shirt",
    [7689651773]="Pants", [18423154566]="Pants", [13925390578]="Pants", [6348682339]="Pants", [108259950755140]="Pants",
}
SMKOriginalDescriptions = setmetatable({}, {__mode="k"})
SMKOriginalOutfits = setmetatable({}, {__mode="k"})

function SMKDisplaySkin.assetInSet(id, setData)
    id=tonumber(id); if not id or not setData then return false end
    for _,v in ipairs(setData.accessories or {}) do if id==v then return true end end
    for _,v in ipairs(setData.clothing or {}) do if id==v then return true end end
    return false
end
function SMKDisplaySkin.appendDescriptionAsset(description, id)
    local property=DAHUB_ASSET_PROPERTIES[tonumber(id)]
    if not property then return end
    if property=="Shirt" or property=="Pants" then description[property]=tonumber(id); return end
    local old=tostring(description[property] or "")
    if not old:find(tostring(id),1,true) then description[property]=(old=="" and tostring(id) or old..","..tostring(id)) end
end
function SMKDisplaySkin.buildDescription(setName, character)
    local setData=DAHUB_SKIN_SETS[setName]; if not setData then return nil end
    local humanoid=character and character:FindFirstChildOfClass("Humanoid"); if not humanoid then return nil end
    local description
    pcall(function() description=humanoid:GetAppliedDescription():Clone() end)
    if not description then pcall(function() description=Players:GetHumanoidDescriptionFromUserId(LP.UserId) end) end
    if not description then description=Instance.new("HumanoidDescription") end
    for _,property in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory","ShirtAccessory","PantsAccessory","JacketAccessory","SweaterAccessory","ShortsAccessory","TShirtAccessory","DressSkirtAccessory"}) do pcall(function() description[property]="" end) end
    pcall(function() description.Shirt=0; description.Pants=0; description.GraphicTShirt=0; description.HatAccessory=setData.hats or ""; description.HairAccessory=setData.hair or "" end)
    for _,id in ipairs(setData.accessories or {}) do SMKDisplaySkin.appendDescriptionAsset(description,id) end
    for _,id in ipairs(setData.clothing or {}) do SMKDisplaySkin.appendDescriptionAsset(description,id) end
    return description
end
function SMKDisplaySkin.applyDescription(humanoid, description)
    if not humanoid or not description then return false end
    for _,methodName in ipairs({"ApplyDescriptionClientServer","ApplyDescriptionReset","ApplyDescription"}) do
        local method
        pcall(function() method=humanoid[methodName] end)
        if type(method)=="function" then
            local copy=description:Clone(); local ok=pcall(method,humanoid,copy); copy:Destroy(); if ok then return true end
        end
    end
    return false
end
function SMKDisplaySkin.captureOriginalOutfit(character)
    if SMKOriginalOutfits[character] then return end
    local saved={}
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            local ok,clone=pcall(function() return child:Clone() end)
            if ok and clone then saved[#saved+1]=clone end
        end
    end
    SMKOriginalOutfits[character]=saved
end
function SMKDisplaySkin.restoreOriginalOutfit(character)
    local saved=SMKOriginalOutfits[character]
    if not saved then return end
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then pcall(function() child:Destroy() end) end
    end
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    for _,clone in ipairs(saved) do
        local copy=clone:Clone()
        if copy:IsA("Accessory") and humanoid then SMKDisplaySkin.attachAccessory(character,humanoid,copy) else copy.Parent=character end
    end
end

function SMKDisplaySkin.clearMarked(character)
    for _,child in ipairs(character:GetChildren()) do
        if child:GetAttribute("SMKCompleteSkin") then pcall(function() child:Destroy() end) end
    end
end
function SMKDisplaySkin.markAndColor(character, setData)
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            local id
            pcall(function() id=tonumber(child.SourceAssetId) end)
            if SMKDisplaySkin.assetInSet(id,setData) then child:SetAttribute("SMKCompleteSkin",true) end
        end
    end
    for _,descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local parent=descendant
            while parent and parent~=character do
                if parent:GetAttribute("SMKCompleteSkin") then descendant.Color=setData.color; break end
                parent=parent.Parent
            end
        end
    end
end
function SMKDisplaySkin.setHeadless(character, enabled)
    local head=character and character:FindFirstChild("Head"); if not head then return end
    local transparency=enabled and 1 or 0; head.Transparency=transparency; head.LocalTransparencyModifier=transparency
    for _,child in ipairs(head:GetChildren()) do if child:IsA("Decal") or child:IsA("Texture") then child.Transparency=transparency end end
end
function SMKDisplaySkin.attachAccessory(character, humanoid, accessory)
    local handle=accessory:FindFirstChild("Handle",true)
    pcall(function() humanoid:AddAccessory(accessory) end)
    if not accessory.Parent then accessory.Parent=character end
    if not handle or not handle:IsA("BasePart") then return accessory.Parent==character end
    local handleAttachment=handle:FindFirstChildWhichIsA("Attachment")
    if not handleAttachment then return accessory.Parent==character end
    local targetAttachment
    for _,descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name==handleAttachment.Name and not descendant:IsDescendantOf(accessory) then targetAttachment=descendant; break end
    end
    if targetAttachment and targetAttachment.Parent:IsA("BasePart") then
        handle.Anchored=false; handle.CanCollide=false; handle.CanTouch=false; handle.CanQuery=false; handle.Massless=true
        handle.CFrame=targetAttachment.Parent.CFrame*targetAttachment.CFrame*handleAttachment.CFrame:Inverse()
        if not handle:FindFirstChild("SMKAccessoryWeld") then
            local weld=Instance.new("WeldConstraint"); weld.Name="SMKAccessoryWeld"; weld.Part0=targetAttachment.Parent; weld.Part1=handle; weld.Parent=handle
        end
    end
    return accessory.Parent==character
end
function SMKDisplaySkin.hasAsset(character, assetId)
    assetId=tonumber(assetId)
    for _,child in ipairs(character:GetChildren()) do
        local sourceId
        pcall(function() sourceId=tonumber(child.SourceAssetId) end)
        if assetId and assetId>0 then
            if sourceId==assetId or tonumber(child:GetAttribute("SMKSkinAssetId"))==assetId then return true end
        end
    end
    return false
end
function SMKDisplaySkin.addAsset(character, humanoid, assetId)
    if SMKDisplaySkin.hasAsset(character,assetId) then return true end
    local ok, objects=pcall(function() return game:GetObjects("rbxassetid://"..tostring(assetId)) end)
    if not ok or type(objects)~="table" or #objects==0 then
        local loaded
        pcall(function() loaded=game:GetService("InsertService"):LoadAsset(tonumber(assetId)) end)
        objects=loaded and {loaded} or {}
    end
    local added=false
    for _,root in ipairs(objects) do
        local candidates={}
        if root:IsA("Accessory") or root:IsA("Shirt") or root:IsA("Pants") or root:IsA("ShirtGraphic") then table.insert(candidates,root) end
        for _,descendant in ipairs(root:GetDescendants()) do
            if descendant:IsA("Accessory") or descendant:IsA("Shirt") or descendant:IsA("Pants") or descendant:IsA("ShirtGraphic") then table.insert(candidates,descendant) end
        end
        for _,source in ipairs(candidates) do
            local clone=source:Clone(); clone:SetAttribute("SMKCompleteSkin",true); clone:SetAttribute("SMKSkinAssetId",tonumber(assetId))
            if clone:IsA("Accessory") then
                if SMKDisplaySkin.attachAccessory(character,humanoid,clone) then added=true end
            else
                for _,old in ipairs(character:GetChildren()) do if old.ClassName==clone.ClassName and old:GetAttribute("SMKCompleteSkin") then old:Destroy() end end
                clone.Parent=character; added=true
            end
        end
        pcall(function() root:Destroy() end)
    end
    return added
end

function SMKDisplaySkin.applyAccessories(character, humanoid, description, setData)
    local source
    pcall(function() source=Players:CreateHumanoidModelFromDescriptionAsync(description,Enum.HumanoidRigType.R15) end)
    if not source then pcall(function() source=Players:CreateHumanoidModelFromDescription(description,Enum.HumanoidRigType.R15) end) end
    if not source then return end
    for _,child in ipairs(source:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
            if child:IsA("Accessory") then
                local sourceId; pcall(function() sourceId=tonumber(child.SourceAssetId) end)
                if not SMKDisplaySkin.hasAsset(character,sourceId) then
                    local clone=child:Clone(); clone:SetAttribute("SMKCompleteSkin",true); clone:SetAttribute("SMKSkinAssetId",sourceId)
                    SMKDisplaySkin.attachAccessory(character,humanoid,clone)
                end
            else
                for _,current in ipairs(character:GetChildren()) do if current.ClassName==child.ClassName then pcall(function() current:Destroy() end) end end
                local clone=child:Clone(); clone:SetAttribute("SMKCompleteSkin",true); clone.Parent=character
            end
        end
    end
    source:Destroy(); SMKDisplaySkin.markAndColor(character,setData)
end

function SMKDisplaySkin.apply(token)
    token=token or S._skinApplyToken
    local character=LP.Character; local setName=S.displaySkin
    if token~=S._skinApplyToken or not character or setName=="Off" or not S.customSkinEnabled then return end
    local humanoid=character:FindFirstChildOfClass("Humanoid"); local setData=DAHUB_SKIN_SETS[setName]
    if not humanoid or not setData then return end
    if not SMKOriginalDescriptions[character] then pcall(function() SMKOriginalDescriptions[character]=humanoid:GetAppliedDescription():Clone() end) end
    SMKDisplaySkin.captureOriginalOutfit(character)
    local originalHead=character:FindFirstChild("Head")
    local originalMesh=originalHead and originalHead:FindFirstChildOfClass("SpecialMesh")
    if originalMesh and originalHead:GetAttribute("SMKOriginalHeadMesh")~=nil then
        originalMesh.MeshId=originalHead:GetAttribute("SMKOriginalHeadMesh")
        originalMesh.TextureId=originalHead:GetAttribute("SMKOriginalHeadTexture") or ""
    end

    -- Vanta quita los accesorios actuales y aplica la descripción completa primero.
    for _,child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Accoutrement") then pcall(function() child:Destroy() end) end
    end
    local description=SMKDisplaySkin.buildDescription(setName,character)
    if description then SMKDisplaySkin.applyDescription(humanoid,description) end
    task.wait(0.18)
    if token~=S._skinApplyToken then if description then description:Destroy() end; return end

    -- Fallback directo: añade cada asset de la skin aunque ApplyDescription no lo adjunte.
    for _,id in ipairs(setData.accessories or {}) do SMKDisplaySkin.addAsset(character,humanoid,id) end
    for _,id in ipairs(setData.clothing or {}) do SMKDisplaySkin.addAsset(character,humanoid,id) end
    task.wait(0.35)
    if token~=S._skinApplyToken then if description then description:Destroy() end; return end
    for _,id in ipairs(setData.accessories or {}) do SMKDisplaySkin.addAsset(character,humanoid,id) end
    for _,id in ipairs(setData.clothing or {}) do SMKDisplaySkin.addAsset(character,humanoid,id) end
    if description then SMKDisplaySkin.applyAccessories(character,humanoid,description,setData) end
    if description then description:Destroy() end
    SMKDisplaySkin.markAndColor(character,setData)
    if setData.shirtTemplate then
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Shirt") or item:IsA("Pants") then item:Destroy() end
        end
        local shirt=Instance.new("Shirt",character); shirt.ShirtTemplate=setData.shirtTemplate; shirt:SetAttribute("SMKCompleteSkin",true)
        local pants=Instance.new("Pants",character); pants.PantsTemplate=setData.pantsTemplate; pants:SetAttribute("SMKCompleteSkin",true)
    end
    local head=character:FindFirstChild("Head")
    if setData.headMesh and head then
        local mesh=head:FindFirstChildOfClass("SpecialMesh")
        if mesh then
            if head:GetAttribute("SMKOriginalHeadMesh")==nil then
                head:SetAttribute("SMKOriginalHeadMesh",mesh.MeshId)
                head:SetAttribute("SMKOriginalHeadTexture",mesh.TextureId)
            end
            mesh.MeshId=setData.headMesh
            mesh.TextureId=setData.headTexture or ""
        end
    end
    SMKDisplaySkin.setHeadless(character,setData.headless==true)
    if type(_G._SMKApplyKroblox)=="function" then pcall(_G._SMKApplyKroblox,setData.korblox or "Off") end
end

function SMKDisplaySkin.off()
    local character=LP.Character; if not character then return end
    local humanoid=character:FindFirstChildOfClass("Humanoid")
    local head=character:FindFirstChild("Head")
    local mesh=head and head:FindFirstChildOfClass("SpecialMesh")
    if mesh and head:GetAttribute("SMKOriginalHeadMesh")~=nil then
        mesh.MeshId=head:GetAttribute("SMKOriginalHeadMesh")
        mesh.TextureId=head:GetAttribute("SMKOriginalHeadTexture") or ""
        head:SetAttribute("SMKOriginalHeadMesh",nil); head:SetAttribute("SMKOriginalHeadTexture",nil)
    end
    SMKDisplaySkin.clearMarked(character)
    if humanoid and SMKOriginalDescriptions[character] then
        SMKDisplaySkin.applyDescription(humanoid,SMKOriginalDescriptions[character]:Clone())
        task.wait(0.2)
    end
    SMKDisplaySkin.restoreOriginalOutfit(character)
    SMKDisplaySkin.setHeadless(character,false)
    if type(_G._SMKApplyKroblox)=="function" then pcall(_G._SMKApplyKroblox,"Off") end
end
function SMKDisplaySkin.setSkin(name,save)
    S._skinApplyToken=S._skinApplyToken+1
    local myToken=S._skinApplyToken
    local valid=false; for _,v in ipairs(DAHUB_SKIN_ORDER) do if v==name then valid=true end end
    S.displaySkin=valid and name or "Off"
    if S.displaySkin=="Off" then S.customSkinEnabled=false; SMKDisplaySkin.off() else S.customSkinEnabled=true; task.spawn(function() pcall(SMKDisplaySkin.apply,myToken) end) end
    if S.displaySkinSelectorLabel then S.displaySkinSelectorLabel.Text=S.displaySkin end
    if S.customSkinVisual then S.customSkinVisual(S.customSkinEnabled) end
    if save then saveConfig() end
end
function SMKDisplaySkin.cycleSkin(direction)
    local index=1; for i,v in ipairs(DAHUB_SKIN_ORDER) do if v==S.displaySkin then index=i end end
    index=index+(direction or 1); if index<1 then index=#DAHUB_SKIN_ORDER end; if index>#DAHUB_SKIN_ORDER then index=1 end
    SMKDisplaySkin.setSkin(DAHUB_SKIN_ORDER[index],true)
end
function SMKDisplaySkin.setCustom(on)
    S._skinApplyToken=S._skinApplyToken+1
    local myToken=S._skinApplyToken
    S.customSkinEnabled=on==true
    if S.customSkinEnabled then if S.displaySkin=="Off" then S.displaySkin="PURPLE" end; task.spawn(function() SMKDisplaySkin.apply(myToken) end) else SMKDisplaySkin.off() end
    if S.customSkinVisual then S.customSkinVisual(S.customSkinEnabled) end
    if S.displaySkinSelectorLabel then S.displaySkinSelectorLabel.Text=S.displaySkin end
    saveConfig()
end
S.setDisplaySkin=SMKDisplaySkin.setSkin; S.cycleDisplaySkin=SMKDisplaySkin.cycleSkin; S.setCustomSkin=SMKDisplaySkin.setCustom
S.applyDisplaySkin=function(token) return SMKDisplaySkin.apply(token) end
LP.CharacterAdded:Connect(function(character) task.wait(0.4); SMKOriginalDescriptions[character]=nil; SMKOriginalOutfits[character]=nil; if S.customSkinEnabled and S.displaySkin~="Off" then task.spawn(SMKDisplaySkin.apply) end end)
end

-- ==================== MYSTERY INFORMATION E01 ====================
do
    local running = true
    if type(_G._SMKInformationE01Cleanup) == "function" then
        pcall(_G._SMKInformationE01Cleanup)
    end
    local introGeneration = 0
    local wasHoldingBrainrot = false
    local activeIntroGui = nil
    local activeCameraConn = nil
    local function clearIntro()
        introGeneration = introGeneration + 1
        if activeIntroGui then pcall(function() activeIntroGui:Destroy() end); activeIntroGui = nil end
        if activeCameraConn then activeCameraConn:Disconnect(); activeCameraConn = nil end
    end
    S.setInformationE01 = function(on, persist)
        S.informationE01Enabled = on == true
        if not S.informationE01Enabled then clearIntro(); wasHoldingBrainrot = false end
        if S.setInformationE01Visual then S.setInformationE01Visual(S.informationE01Enabled) end
        if persist ~= false then saveConfig() end
    end
    _G._SMKInformationE01Cleanup = function()
        running = false
        clearIntro()
    end

    local function isHoldingBrainrot()
        if _G.AceSafeModeHoldingBrainrot then
            local ok, carrying = pcall(_G.AceSafeModeHoldingBrainrot)
            if ok and carrying then return true end
        end

        local char = LP and LP.Character
        if not char then return false end
        for _, child in ipairs(char:GetChildren()) do
            local name = tostring(child.Name or ""):lower()
            if (child:IsA("Tool") or child:IsA("Model")) and
               (name:find("brainrot", 1, true) or name:find("animal", 1, true) or
                name:find("carry", 1, true) or name:find("grab", 1, true) or
                name:find("steal", 1, true) or name:find("hold", 1, true)) then
                return true
            end
        end
        return false
    end

    local function playBrainrotIntro(myGeneration)
        -- O aviso não altera a visibilidade nem o estado do menu.
        if activeIntroGui then pcall(function() activeIntroGui:Destroy() end) end

        local playerGui = LP and (LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5))
        if not playerGui or myGeneration ~= introGeneration or not isHoldingBrainrot()
           or (S and S.informationE01Enabled == false) then return end

        local introGui = Instance.new("ScreenGui")
        introGui.Name = "BrainrotEnterIntro"
        introGui.ResetOnSpawn = false
        introGui.IgnoreGuiInset = true
        introGui.DisplayOrder = 1000000
        introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        introGui.Parent = playerGui
        activeIntroGui = introGui

        local strip = Instance.new("Frame")
        strip.Name = "EnterStrip"
        strip.AnchorPoint = Vector2.new(0.5, 0.5)
        strip.Position = UDim2.new(0.5, 0, -0.18, 0)
        strip.BackgroundColor3 = Color3.fromRGB(176, 24, 45)
        strip.BackgroundTransparency = 0
        strip.BorderSizePixel = 0
        strip.ClipsDescendants = false
        strip.ZIndex = 2
        strip.Parent = introGui
        Instance.new("UICorner", strip).CornerRadius = UDim.new(1, 0)
        local completeBorder = Instance.new("UIStroke", strip)
        completeBorder.Name = "CompleteLoadingBorder"
        completeBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        completeBorder.Color = Color3.fromRGB(22, 112, 62)
        completeBorder.Thickness = 3
        completeBorder.Transparency = 1
        completeBorder.ZIndex = 6

        local scale = Instance.new("UIScale", strip)
        scale.Scale = 0.9

        local stripHeight = 46
        local cornerRadius = 23
        local lineThickness = 3
        local inset = 3

        local function fitStrip()
            local camera = workspace.CurrentCamera
            if not camera or not strip.Parent then return end
            local width = math.min(math.max(150, math.floor(camera.ViewportSize.X * 0.33)), math.max(1, camera.ViewportSize.X - 24))
            strip.Size = UDim2.fromOffset(width, stripHeight)
        end
        fitStrip()

        local cameraConn
        local function bindCamera(camera)
            if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
            if camera then cameraConn = camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitStrip) end
            activeCameraConn = cameraConn
        end
        bindCamera(workspace.CurrentCamera)

        local label = Instance.new("TextLabel")
        label.Name = "EnterLabel"
        label.Size = UDim2.new(1, -32, 1, -16)
        label.Position = UDim2.fromOffset(16, 8)
        label.BackgroundTransparency = 1
        label.Text = "DON'T ENTER"
        label.TextColor3 = Color3.fromRGB(255, 228, 142)
        label.TextTransparency = 0
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextWrapped = true
        label.ZIndex = 5
        label.Parent = strip
        local textLimit = Instance.new("UITextSizeConstraint", label)
        textLimit.MinTextSize = 10
        textLimit.MaxTextSize = 16


        local function stillValid()
            return running and myGeneration == introGeneration and introGui.Parent ~= nil and isHoldingBrainrot()
                and not (S and S.informationE01Enabled == false)
        end
        local function abortIfReleased()
            if stillValid() then return false end
            if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
            if introGui.Parent then introGui:Destroy() end
            if activeIntroGui == introGui then activeIntroGui = nil end
            return true
        end

        local arrival = TS_G:Create(strip, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.12)
        })
        TS_G:Create(scale, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        arrival:Play()
        arrival.Completed:Wait()
        if abortIfReleased() then return end

        -- Linha continua de carregamento, preenchida da esquerda para a direita.
        local revealTime = 1.9
        local DARK_CYAN = Color3.fromRGB(22, 112, 62)
        local track = Instance.new("Frame", strip)
        track.Name = "LoadingTrack"
        track.AnchorPoint = Vector2.new(0.5, 1)
        track.Position = UDim2.new(0.5, 0, 1, -6)
        track.Size = UDim2.new(1, -26, 0, lineThickness)
        track.BackgroundColor3 = Color3.fromRGB(255, 228, 142)
        track.BackgroundTransparency = 0.2
        track.BorderSizePixel = 0
        track.ClipsDescendants = true
        track.ZIndex = 6
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local lineFill = Instance.new("Frame", track)
        lineFill.Name = "LoadingLine"
        lineFill.Size = UDim2.new(0, 0, 1, 0)
        lineFill.BackgroundColor3 = DARK_CYAN
        lineFill.BorderSizePixel = 0
        lineFill.ZIndex = 7
        Instance.new("UICorner", lineFill).CornerRadius = UDim.new(1, 0)

        local elapsed = 0
        while elapsed < revealTime do
            lineFill.Size = UDim2.new(math.clamp(elapsed / revealTime, 0, 1), 0, 1, 0)
            elapsed = elapsed + task.wait()
            if abortIfReleased() then return end
        end
        lineFill.Size = UDim2.new(1, 0, 1, 0)
        completeBorder.Transparency = 0



        label.Text = "ENTER"
        label.TextTransparency = 1
        TS_G:Create(label, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        task.wait(0.3)
        if abortIfReleased() then return end

        TS_G:Create(scale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 1.35}):Play()
        TS_G:Create(strip, TweenInfo.new(0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TS_G:Create(label, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TS_G:Create(completeBorder, TweenInfo.new(0.25), {Transparency = 1}):Play()
        task.wait(0.4)

        if cameraConn then cameraConn:Disconnect(); cameraConn = nil end
        if introGui.Parent then introGui:Destroy() end
        if activeIntroGui == introGui then activeIntroGui = nil end
    end

    -- Only starts on the transition from not holding to holding the pet.
    task.spawn(function()
        while running do
            local holding = isHoldingBrainrot()
            local shouldShow = holding and not (S and S.informationE01Enabled == false)
            if shouldShow and not wasHoldingBrainrot then
                introGeneration = introGeneration + 1
                local thisGeneration = introGeneration
                task.spawn(function() playBrainrotIntro(thisGeneration) end)
            elseif not shouldShow and wasHoldingBrainrot then
                introGeneration = introGeneration + 1
                if activeIntroGui then
                    pcall(function() activeIntroGui:Destroy() end)
                    activeIntroGui = nil
                end
                if activeCameraConn then activeCameraConn:Disconnect(); activeCameraConn = nil end
            end
            wasHoldingBrainrot = shouldShow
            task.wait(0.1)
        end
    end)
end

-- ===== ANTI BAT (proteccion Anti Die integrada desde el script proporcionado) =====
local function stopAntiBatProtection()
    for _, connection in ipairs(S.antiBatConnections or {}) do
        pcall(function() connection:Disconnect() end)
    end
    S.antiBatConnections = {}
    if S.antiBatHeartbeat then
        pcall(function() S.antiBatHeartbeat:Disconnect() end)
        S.antiBatHeartbeat = nil
    end
    if S.antiBatCharacterConn then
        pcall(function() S.antiBatCharacterConn:Disconnect() end)
        S.antiBatCharacterConn = nil
    end
end

local function protectAntiBatCharacter(character)
    if not S.antiBatEnabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not humanoid or not S.antiBatEnabled then return end
    pcall(function()
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)
    table.insert(S.antiBatConnections, humanoid.StateChanged:Connect(function(_, newState)
        if not S.antiBatEnabled or newState ~= Enum.HumanoidStateType.Dead then return end
        pcall(function()
            humanoid.Health = math.huge
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end)
    end))
    table.insert(S.antiBatConnections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if S.antiBatEnabled and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
            pcall(function() humanoid.Health = math.huge end)
        end
    end))
    S.antiBatHeartbeat = RunService.Heartbeat:Connect(function()
        if S.antiBatEnabled and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
            pcall(function() humanoid.Health = math.huge end)
        end
    end)
end

local function setAntiBatProtection(enabled)
    S.antiBatEnabled = enabled == true
    stopAntiBatProtection()
    if not S.antiBatEnabled then return end
    protectAntiBatCharacter(LP.Character)
    S.antiBatCharacterConn = LP.CharacterAdded:Connect(function(character)
        task.wait(0.1)
        if S.antiBatEnabled then
            for _, connection in ipairs(S.antiBatConnections) do
                pcall(function() connection:Disconnect() end)
            end
            S.antiBatConnections = {}
            if S.antiBatHeartbeat then S.antiBatHeartbeat:Disconnect(); S.antiBatHeartbeat = nil end
            protectAntiBatCharacter(character)
        end
    end)
end

-- 404 ANTI DROP integration: reuse SMK's existing velocity hook rather than
-- installing a second metatable hook that could conflict with movement.
S.setAntiDrop = function(enabled, persist)
    S.antiDropEnabled = enabled == true
    if S.antiDropEnabled then
        if S._vx7SetupHooks then pcall(S._vx7SetupHooks) end
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root and S._vxSyncSpoof then
            pcall(S._vxSyncSpoof, root.AssemblyLinearVelocity)
        end
    end
    if persist ~= false and saveConfig then saveConfig() end
    return S.antiDropEnabled
end

-- 404 ANTI DIE: restore the character's original health settings when disabled.
local antiDieConnections = {}
local antiDieCharacterConnection = nil
local antiDieSavedHumanoid = nil
local antiDieOriginal = nil

local function disconnectAntiDieCharacter()
    for _, connection in ipairs(antiDieConnections) do
        pcall(function() connection:Disconnect() end)
    end
    antiDieConnections = {}
end

local function restoreAntiDieHumanoid()
    local humanoid, saved = antiDieSavedHumanoid, antiDieOriginal
    if humanoid and humanoid.Parent and saved then
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, saved.deadEnabled)
            humanoid.MaxHealth = saved.maxHealth
            humanoid.Health = math.clamp(saved.health, 0, saved.maxHealth)
        end)
    end
    antiDieSavedHumanoid, antiDieOriginal = nil, nil
end

local function protectAntiDieCharacter(character)
    disconnectAntiDieCharacter()
    restoreAntiDieHumanoid()
    if not S.antiDieEnabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
        or character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    antiDieSavedHumanoid = humanoid
    local ok, deadEnabled = pcall(function()
        return humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead)
    end)
    antiDieOriginal = {
        maxHealth = humanoid.MaxHealth,
        health = humanoid.Health,
        deadEnabled = ok and deadEnabled or true,
    }

    pcall(function()
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    antiDieConnections[#antiDieConnections + 1] =
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if S.antiDieEnabled and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
                pcall(function() humanoid.Health = math.huge end)
            end
        end)

    antiDieConnections[#antiDieConnections + 1] =
        humanoid.StateChanged:Connect(function(_, newState)
            if S.antiDieEnabled and newState == Enum.HumanoidStateType.Dead and humanoid.Parent then
                pcall(function()
                    humanoid.Health = math.huge
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                end)
            end
        end)
end

S.setAntiDie = function(enabled, persist)
    S.antiDieEnabled = enabled == true
    if antiDieCharacterConnection then
        antiDieCharacterConnection:Disconnect()
        antiDieCharacterConnection = nil
    end
    disconnectAntiDieCharacter()
    if S.antiDieEnabled then
        protectAntiDieCharacter(LP.Character)
        antiDieCharacterConnection = LP.CharacterAdded:Connect(function(character)
            task.wait(0.1)
            if S.antiDieEnabled then protectAntiDieCharacter(character) end
        end)
    else
        restoreAntiDieHumanoid()
    end
    if persist ~= false and saveConfig then saveConfig() end
    return S.antiDieEnabled
end

local function buildMainTab(pages)
    mkSection("Main", pages, "Information")
    S.setInformationE01Visual, _ = mkToggle("Main", pages, "Information E01", nil,
        S.informationE01Enabled, function(on) S.setInformationE01(on, true) end, nil)
    mkSection("Main", pages, "Counters")
    local batVis, _ = mkToggle("Main", pages, "Bat Aimbot", S.KB.AutoBat.kb, S.batAimbotEnabled, function(on)
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end; stopAutoLeft() end
            if S.autoRightEnabled then S.autoRightEnabled=false; if S.autoRightSetVisual then S.autoRightSetVisual(false) end; stopAutoRight() end
        end
        setBatAimbot(on); updateFloatingButtons()
    end, function(k,isGp)
        if isGp then S.KB.AutoBat.gp=k; S.KB.AutoBat.kb=nil
        else S.KB.AutoBat.kb=k; S.KB.AutoBat.gp=nil end; saveConfig()
    end)
    S.batAimbotSetVisual = batVis
    mkSection("Main", pages, "Bat Bypass")
    S.setBatBypassRowVisual = mkToggle("Main", pages, "Bat Bypass", nil, S.batBypassEnabled,
        function(on) S.setBatBypass(on) end, nil)
    do
        local card = mkCard("Main", pages, 68)
        local label = Instance.new("TextLabel", card)
        label.Position = UDim2.fromOffset(12, 5)
        label.Size = UDim2.new(1, -24, 0, 16)
        label.BackgroundTransparency = 1
        label.Text = "ＳＭＫㅤＨＵＢ"
        label.TextColor3 = C_GREY
        label.Font = Enum.Font.GothamMedium
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        local pill = Instance.new("Frame", card)
        pill.Name = "BatBypassVersionsPill"
        pill.Position = UDim2.fromOffset(8, 25)
        pill.Size = UDim2.new(1, -16, 0, 34)
        pill.BackgroundColor3 = C_BG
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local border = Instance.new("UIStroke", pill)
        border.Color = C_BORDER; border.Transparency = 0.25
        local buttons = {}
        for index = 1, 5 do
            local version = "v" .. index
            local choice = Instance.new("TextButton", pill)
            choice.Name = "Bypass_" .. version
            choice.Size = UDim2.new(0.2, -6, 1, -6)
            choice.Position = UDim2.new((index - 1) * 0.2, 3, 0, 3)
            choice.Text = "V" .. index
            choice.Font = Enum.Font.GothamBold
            choice.TextSize = 12
            choice.AutoButtonColor = false
            choice.BorderSizePixel = 0
            Instance.new("UICorner", choice).CornerRadius = UDim.new(1, 0)
            local stroke = Instance.new("UIStroke", choice)
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            buttons[version] = {button = choice, stroke = stroke}
            choice.Activated:Connect(function() S.selectBatBypassVersion(version, true) end)
        end
        S.refreshBatBypassVersions = function()
            for version, ref in pairs(buttons) do
                local selected = version == S.batBypassVersion
                TS_G:Create(ref.button, TweenInfo.new(0.18), {
                    BackgroundColor3 = selected and C_WHITE or C_CARD,
                    BackgroundTransparency = selected and 0.04 or 0.24,
                    TextColor3 = selected and C_BG or C_GREY,
                }):Play()
                TS_G:Create(ref.stroke, TweenInfo.new(0.18), {
                    Color = selected and C_HIGHLIGHT_BRIGHT or C_BORDER,
                    Transparency = selected and 0.15 or 0.65,
                }):Play()
            end
        end
        S.refreshBatBypassVersions()
    end
    mkInput("Main", pages, "Bypass Speed", S.batBypassSpeed or 58,
        function(n) S.batBypassSpeed = math.clamp(n, 1, 500); saveConfig() end)
    S.setBatCounterVisual, _ = mkToggle("Main", pages, "Bat Counter", nil, S.batCounterEnabled, function(on)
        S.batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
        saveConfig()
    end, nil)
    S.setMedusaVisual, _ = mkToggle("Main", pages, "Medusa Counter", nil, S.medusaCounterEnabled, function(on)
        S.medusaCounterEnabled=on
        if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end; saveConfig()
    end, nil)
    do
        local card = mkCard("Main", pages, 40)
        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0, 108, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "Bat Skins"
        label.TextColor3 = C_WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeBatSkinButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeBatSkinButton("<", 0)
        S.batSkinSelectorLabel = Instance.new("TextLabel", selector)
        S.batSkinSelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.batSkinSelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.batSkinSelectorLabel.BackgroundTransparency = 1
        S.batSkinSelectorLabel.Text = S.batSkinMode
        S.batSkinSelectorLabel.TextColor3 = C_WHITE
        S.batSkinSelectorLabel.Font = Enum.Font.GothamBold
        S.batSkinSelectorLabel.TextSize = 10
        S.batSkinSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.batSkinSelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.batSkinSelectorLabel.ZIndex = 9
        local right = makeBatSkinButton(">", 120)
        left.MouseButton1Click:Connect(function() S.cycleBatSkin(-1) end)
        right.MouseButton1Click:Connect(function() S.cycleBatSkin(1) end)
    end
    do
        local card=mkCard("Visual",pages,40)
        local label=Instance.new("TextLabel",card)
        label.Size=UDim2.new(0,108,1,0); label.Position=UDim2.fromOffset(12,0); label.BackgroundTransparency=1
        label.Text="Medusa Skin"; label.Font=Enum.Font.GothamBold; label.TextSize=11; label.TextColor3=C_WHITE; label.TextXAlignment=Enum.TextXAlignment.Left
        local selector=Instance.new("Frame",card); selector.Size=UDim2.new(0,142,1,0); selector.Position=UDim2.new(1,-152,0,0); selector.BackgroundTransparency=1
        S.medusaSkinSelectorLabel=Instance.new("TextLabel",selector)
        local value=S.medusaSkinSelectorLabel; value.Size=UDim2.fromOffset(90,24); value.Position=UDim2.new(0,26,0.5,-12); value.BackgroundTransparency=1
        value.Text=S.medusaSkinMode; value.Font=Enum.Font.GothamBold; value.TextSize=10; value.TextColor3=C_WHITE
        for i,text in ipairs({"<",">"}) do
            local arrow=Instance.new("TextButton",selector); arrow.Size=UDim2.fromOffset(22,24); arrow.Position=UDim2.new(0,(i-1)*120,0.5,-12)
            arrow.BackgroundTransparency=1; arrow.Text=text; arrow.Font=Enum.Font.GothamBold; arrow.TextSize=13; arrow.TextColor3=C_WHITE
            arrow.Activated:Connect(function() S.setMedusaSkin(S.medusaSkinMode=="Off" and "Medusa 1" or "Off",true) end)
        end
    end
    mkSection("Visual", pages, "Display Mode")
    do
        local card = mkCard("Visual", pages, 40)
        local label = Instance.new("TextLabel", card); label.Size=UDim2.new(0,108,1,0); label.Position=UDim2.new(0,12,0,0); label.BackgroundTransparency=1; label.Text="Skins"; label.TextColor3=C_WHITE; label.Font=Enum.Font.GothamBold; label.TextSize=11; label.TextXAlignment=Enum.TextXAlignment.Left
        local selector=Instance.new("Frame",card); selector.Size=UDim2.new(0,142,1,0); selector.Position=UDim2.new(1,-152,0,0); selector.BackgroundTransparency=1
        local left=Instance.new("TextButton",selector); left.Size=UDim2.fromOffset(22,24); left.Position=UDim2.new(0,0,0.5,-12); left.BackgroundTransparency=1; left.Text="<"; left.TextColor3=C_WHITE; left.Font=Enum.Font.GothamBold; left.TextSize=13; left.AutoButtonColor=false
        S.displaySkinSelectorLabel=Instance.new("TextLabel",selector); S.displaySkinSelectorLabel.Size=UDim2.fromOffset(90,24); S.displaySkinSelectorLabel.Position=UDim2.new(0,26,0.5,-12); S.displaySkinSelectorLabel.BackgroundTransparency=1; S.displaySkinSelectorLabel.Text=S.displaySkin; S.displaySkinSelectorLabel.TextColor3=C_WHITE; S.displaySkinSelectorLabel.Font=Enum.Font.GothamBold; S.displaySkinSelectorLabel.TextSize=10; S.displaySkinSelectorLabel.TextXAlignment=Enum.TextXAlignment.Center; S.displaySkinSelectorLabel.TextTruncate=Enum.TextTruncate.AtEnd
        local right=Instance.new("TextButton",selector); right.Size=UDim2.fromOffset(22,24); right.Position=UDim2.new(0,120,0.5,-12); right.BackgroundTransparency=1; right.Text=">"; right.TextColor3=C_WHITE; right.Font=Enum.Font.GothamBold; right.TextSize=13; right.AutoButtonColor=false
        left.MouseButton1Click:Connect(function() S.cycleDisplaySkin(-1) end); right.MouseButton1Click:Connect(function() S.cycleDisplaySkin(1) end)
    end
    S.customSkinVisual, _ = mkToggle("Visual", pages, "Custom Skin", nil, S.customSkinEnabled, function(on) S.setCustomSkin(on) end, nil)
    mkSection("Player", pages, "Player")
    S.setESPVisual, _ = mkToggle("Player", pages, "Player ESP", nil, S.espEnabled, function(on)
        toggleESP(on); saveConfig()
    end, nil)
    S.setFpsVisual, _ = mkToggle("Player", pages, "FPS Boost", nil, S.fpsBoostEnabled, function(on)
        S.fpsBoostEnabled=on; if on then applyFPSBoost() else stopFPSBoost() end; saveConfig()
    end, nil)
    S.setHoldJumpVisual, _ = mkToggle("Player", pages, "Infinity Jump", nil, S.holdJumpEnabled, function(on)
        S.holdJumpEnabled=on
        if on then startHoldJump() else stopHoldJump() end
        saveConfig()
    end, nil)
    mkSection("Player", pages, "Protection")
    S.setAntiFlingVisual, _ = mkToggle("Player", pages, "Anti Fling", nil, S.antiFlingEnabled, function(on)
        if on then YF.startAntiFling() else YF.stopAntiFling() end
        saveConfig()
    end, nil)
    S.bodyLockSetVisual, _ = mkToggle("Player", pages, "Lock Enemy", nil, S.bodyLockEnabled, function(on)
        if on then YF.startBodyLock() else YF.stopBodyLock() end
        saveConfig()
    end, nil)
    mkInput("Player", pages, "Lock Enemy Range", S.bodyLockRange, function(value)
        if value and value > 0 then
            S.bodyLockRange = math.clamp(math.floor(value), 5, 200)
            saveConfig()
        end
    end)
    mkSection("Visual", pages, "Visuals")
    S.setVividVisual, _ = mkToggle("Visual", pages, "Vivid Graphics", nil, S.vividGraphicsEnabled, function(on)
        toggleVividGraphics(on)
    end, nil)
    S.setStretchVisual, _ = mkToggle("Visual", pages, "Stretch Rez", nil, S.stretchEnabled, function(on)
        if on then enableStretch() else disableStretch() end
        S.stretchEnabled = on
        saveConfig()
    end, nil)
    do
        local card = mkCard("Visual", pages, 40)
        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0, 118, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "Kroblox Select"
        label.TextColor3 = C_WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeKrobloxButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeKrobloxButton("<", 0)
        S.krobloxSelectorLabel = Instance.new("TextLabel", selector)
        S.krobloxSelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.krobloxSelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.krobloxSelectorLabel.BackgroundTransparency = 1
        S.krobloxSelectorLabel.Text = S.krobloxMode
        S.krobloxSelectorLabel.TextColor3 = C_WHITE
        S.krobloxSelectorLabel.Font = Enum.Font.GothamBold
        S.krobloxSelectorLabel.TextSize = 10
        S.krobloxSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.krobloxSelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.krobloxSelectorLabel.ZIndex = 9
        local right = makeKrobloxButton(">", 120)
        local options = {"Off", "Left", "Right", "Both"}
        local function changeKroblox(direction)
            local index = 1
            for i, name in ipairs(options) do
                if name == S.krobloxMode then index = i; break end
            end
            index = index + direction
            if index < 1 then index = #options end
            if index > #options then index = 1 end
            local mode = options[index]
            pcall(_G._SMKApplyKroblox, mode)
            S.krobloxSelectorLabel.Text = mode
            saveConfig()
        end
        left.MouseButton1Click:Connect(function()
            changeKroblox(-1)
        end)
        right.MouseButton1Click:Connect(function()
            changeKroblox(1)
        end)
    end
    do
        local card = mkCard("Visual", pages, 40)
        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0, 100, 1, 0)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "Sky Theme"
        label.TextColor3 = C_WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeSkyButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeSkyButton("<", 0)
        S.skySelectorLabel = Instance.new("TextLabel", selector)
        S.skySelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.skySelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.skySelectorLabel.BackgroundTransparency = 1
        S.skySelectorLabel.Text = S.skyTheme
        S.skySelectorLabel.TextColor3 = C_WHITE
        S.skySelectorLabel.Font = Enum.Font.GothamBold
        S.skySelectorLabel.TextSize = 10
        S.skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.skySelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.skySelectorLabel.ZIndex = 9
        local right = makeSkyButton(">", 120)
        local function changeSky(direction)
            local index = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == S.skyTheme then index = i; break end
            end
            index = index + direction
            if index < 1 then index = #SKY_PRESETS_LIST end
            if index > #SKY_PRESETS_LIST then index = 1 end
            local name = SKY_PRESETS_LIST[index]
            pcall(applyCustomSky, name)
            S.skyTheme = name
            S.skySelectorLabel.Text = name
            saveConfig()
        end
        left.MouseButton1Click:Connect(function() changeSky(-1) end)
        right.MouseButton1Click:Connect(function() changeSky(1) end)
    end
    mkSection("Visual", pages, "Character / Performance")
    do
        local card = mkCard("Visual", pages, 40)
        local title = Instance.new("TextLabel", card)
        title.Size = UDim2.new(0, 100, 1, 0)
        title.Position = UDim2.new(0, 12, 0, 0)
        title.BackgroundTransparency = 1
        title.Text = "Anim Pack"
        title.TextColor3 = C_WHITE
        title.Font = Enum.Font.GothamBold
        title.TextSize = 11
        title.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("Frame", card)
        selector.Size = UDim2.new(0, 142, 1, 0)
        selector.Position = UDim2.new(1, -152, 0, 0)
        selector.BackgroundTransparency = 1
        local function makeAnimButton(text, x)
            local button = Instance.new("TextButton", selector)
            button.Size = UDim2.new(0, 22, 0, 24)
            button.Position = UDim2.new(0, x, 0.5, -12)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = text
            button.TextColor3 = C_WHITE
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.ZIndex = 10
            return button
        end
        local left = makeAnimButton("<", 0)
        S.animSelectorLabel = Instance.new("TextLabel", selector)
        S.animSelectorLabel.Size = UDim2.new(0, 90, 0, 24)
        S.animSelectorLabel.Position = UDim2.new(0, 26, 0.5, -12)
        S.animSelectorLabel.BackgroundTransparency = 1
        S.animSelectorLabel.Text = S.currentAnimPack
        S.animSelectorLabel.TextColor3 = C_WHITE
        S.animSelectorLabel.Font = Enum.Font.GothamBold
        S.animSelectorLabel.TextSize = 10
        S.animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        S.animSelectorLabel.TextTruncate = Enum.TextTruncate.AtEnd
        S.animSelectorLabel.ZIndex = 9
        local right = makeAnimButton(">", 120)
        local function changeAnimPack(direction)
            local index = 1
            for i, entry in ipairs(YF.ANIM_PACK_ORDER) do
                if entry[2] == S.currentAnimPack then index = i; break end
            end
            index = index + direction
            if index < 1 then index = #YF.ANIM_PACK_ORDER end
            if index > #YF.ANIM_PACK_ORDER then index = 1 end
            local packName = YF.ANIM_PACK_ORDER[index][2]
            if packName == "Off" then YF.stopAnimPack() else YF.startAnimPack(packName) end
            if S.animSelectorLabel then S.animSelectorLabel.Text = packName end
            saveConfig()
        end
        left.MouseButton1Click:Connect(function() changeAnimPack(-1) end)
        right.MouseButton1Click:Connect(function() changeAnimPack(1) end)
    end
    mkSection("Visual", pages, "Otimização")
    S.setAntiLagVisual, _ = mkToggle("Visual", pages, "Anti Lag", nil,
        S.antiLagEnabled and S.optimizerMode == "standard", function(on)
        YF.setOptimizer("standard", on); saveConfig()
    end, nil)
    S.setTripaVisual, _ = mkToggle("Visual", pages, "Tropa Otimizador (TRIPA)", nil,
        S.antiLagEnabled and S.optimizerMode == "tripa", function(on)
        YF.setOptimizer("tripa", on); saveConfig()
    end, nil)
    do
        local card = mkCard("Visual", pages, 36)
        local off = Instance.new("TextButton", card)
        off.Name = "DisableOptimizer"
        off.Size = UDim2.fromScale(1, 1)
        off.BackgroundTransparency = 1
        off.BorderSizePixel = 0
        off.Text = "Desativar otimizador"
        off.TextColor3 = C_WHITE
        off.Font = Enum.Font.GothamBold
        off.TextSize = 11
        off.Activated:Connect(function() YF.setOptimizer(S.optimizerMode, false); saveConfig() end)
    end
    mkSection("Main", pages, "Utility")
    S.setUnwalkVisual, _ = mkToggle("Main", pages, "Unwalk", nil, S.unwalkEnabled, function(on)
        if on then startUnwalk() else stopUnwalk() end; saveConfig()
    end, nil)
    S.setAntiBatVisual, _ = mkToggle("Main", pages, "Anti Bat", nil, S.antiBatEnabled, function(on)
        setAntiBatProtection(on); saveConfig()
    end, nil)
    S.setAntiRagVisual, _ = mkToggle("Main", pages, "Anti Ragdoll", nil, S.antiRagdollEnabled, function(on)
        toggleAntiRag(on); saveConfig()
    end, nil)
    S.setAntiDropVisual, _ = mkToggle("Main", pages, "Anti Drop (404)", nil, S.antiDropEnabled, function(on)
        S.setAntiDrop(on, true)
    end, nil)
    S.setAntiDieVisual, _ = mkToggle("Main", pages, "Anti Die (404)", nil, S.antiDieEnabled, function(on)
        S.setAntiDie(on, true)
    end, nil)
end

local function buildMoveTab(pages)
    mkSection("Move", pages, "Auto Path")
    local setALVis, _ = mkToggle("Move", pages, "Auto Left", S.KB.AutoLeft.kb, false, function(on)
        S.autoLeftEnabled=on
        if on then
            if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
            if S.batAimbotEnabled then setBatAimbot(false) end
            startAutoLeft()
        else stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.AutoLeft.gp=k; S.KB.AutoLeft.kb=nil
        else S.KB.AutoLeft.kb=k; S.KB.AutoLeft.gp=nil end; saveConfig()
    end)
    S.autoLeftSetVisual = setALVis
    local setARVis, _ = mkToggle("Move", pages, "Auto Right", S.KB.AutoRight.kb, false, function(on)
        S.autoRightEnabled=on
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
            if S.batAimbotEnabled then setBatAimbot(false) end
            startAutoRight()
        else stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end, function(k,isGp)
        if isGp then S.KB.AutoRight.gp=k; S.KB.AutoRight.kb=nil
        else S.KB.AutoRight.kb=k; S.KB.AutoRight.gp=nil end; saveConfig()
    end)
    S.autoRightSetVisual = setARVis
    mkSection("Move", pages, "Steal")
    local setStealVis, _ = mkToggle("Move", pages, "Auto Steal", nil, S.stealActive, function(on)
        S.stealActive = on
        if on then startAutoSteal() else stopAutoSteal() end
        saveConfig()
    end, nil)
    S.setInstaGrab = setStealVis
    S.radInput = mkInput("Move", pages, "Steal Radius", S.Steal.StealRadius, function(v)
        if v>=1 and v<=300 then S.Steal.StealRadius=math.floor(v) end; saveConfig()
    end)
    S.stealDurationBox = mkInput("Move", pages, "Steal Duration", S.Steal.StealDuration, function(v)
        if tonumber(v) then setStealDuration(v); saveConfig() end
    end)
    mkSection("Move", pages, "Actions")
    do
        local card = mkCard("Move", pages, 36)
        local label = Instance.new("TextLabel", card)
        label.Size = UDim2.new(0.5, -8, 1, 0)
        label.Position = UDim2.fromOffset(12, 0)
        label.BackgroundTransparency = 1
        label.Text = "Drop Mode"
        label.TextColor3 = C_WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        local selector = Instance.new("TextButton", card)
        selector.Size = UDim2.new(0, 108, 0, 26)
        selector.Position = UDim2.new(1, -116, 0.5, -13)
        selector.BackgroundColor3 = C_HEADER
        selector.TextColor3 = C_WHITE
        selector.Font = Enum.Font.GothamBold
        selector.TextSize = 11
        selector.BorderSizePixel = 0
        Instance.new("UICorner", selector).CornerRadius = UDim.new(0, 8)
        local function refresh()
            selector.Text = S.dropMode == 2 and "‹ Jump Drop ›" or "‹ Fling ›"
        end
        refresh()
        selector.Activated:Connect(function()
            stopDropBrainrot()
            S.dropMode = S.dropMode == 2 and 1 or 2
            refresh()
            saveConfig()
        end)
    end
    mkActionRow("Move", pages, "Drop Brainrot", S.KB.DropBrainrot, runDropBrainrot)
    mkActionRow("Move", pages, "TP Down",       S.KB.TPFlor,       runTPFloor)
end

local function buildKeybindsTab(pages)
    mkSection("Keybinds", pages, "Keybind")
    mkActionRow("Keybinds", pages, "Hide GUI",       S.KB.GuiHide,      nil)
    mkActionRow("Keybinds", pages, "Carry Mode",     S.KB.SpeedToggle,  function() S.toggleCarryMode(); S.restartMovement(); updateFloatingButtons(); saveConfig() end)
    mkActionRow("Keybinds", pages, "Lagger Mode",    S.KB.LaggerToggle, function() S.toggleLaggerMode(); S.restartMovement(); updateFloatingButtons(); saveConfig() end)
    mkActionRow("Keybinds", pages, "Bat Bypass", S.KB.BatBypass, function() S.toggleBatBypass(); saveConfig() end)
    mkActionRow("Keybinds", pages, "Bat Aimbot",     S.KB.AutoBat,      function() setBatAimbot(not S.batAimbotEnabled) end)
    mkActionRow("Keybinds", pages, "Auto Left",      S.KB.AutoLeft,     function()
        S.autoLeftEnabled=not S.autoLeftEnabled
        if S.autoLeftEnabled then if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end; startAutoLeft() else stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end; updateFloatingButtons(); saveConfig()
    end)
    mkActionRow("Keybinds", pages, "Auto Right",     S.KB.AutoRight,    function()
        S.autoRightEnabled=not S.autoRightEnabled
        if S.autoRightEnabled then if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end; startAutoRight() else stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end; updateFloatingButtons(); saveConfig()
    end)
    mkActionRow("Keybinds", pages, "Drop Brainrot",  S.KB.DropBrainrot, runDropBrainrot)
    mkActionRow("Keybinds", pages, "TP Down",        S.KB.TPFlor,       runTPFloor)
end

local function resetConfigToDefaults()
    if S.selectBatBypassVersion then S.selectBatBypassVersion("v5", false) end
    S.batBypassSpeed = 58
    if S.setBatBypass then S.setBatBypass(false) end
    pcall(stopAutoSteal)
    pcall(stopBatCounter)
    pcall(stopMedusaCounter)
    pcall(stopUnwalk)
    pcall(stopHoldJump)
    pcall(stopAutoLeft)
    pcall(stopAutoRight)
    pcall(stopBatAimbot)
    pcall(setTpBat, false)
    pcall(stopAntiRagdoll)
    pcall(stopFPSBoost)
    pcall(YF.stopAntiFling)
    pcall(YF.stopBodyLock)
    pcall(YF.disableAntiLag)
    pcall(YF.stopAnimPack)
    pcall(disableStretch)
    pcall(disableVividGraphics)
    pcall(toggleESP, false)

    S.NS, S.CS, S.LS, S.LCS = 70, 45, 22, 22
    S.speedMode, S.laggerMode = false, 0
    S.antiRagdollEnabled = false
    S.medusaCounterEnabled = false
    S.unwalkEnabled = false
    S.autoLeftEnabled, S.autoRightEnabled = false, false
    S.batAimbotEnabled, S.batCounterEnabled = false, false
    S.fpsBoostEnabled = false
    S.stealActive = false
    S.espEnabled = false
    S.antiFlingEnabled = false
    S.bodyLockEnabled, S.bodyLockRange = false, 20
    S.antiLagEnabled = false
    S.vividGraphicsEnabled = false
    S.stretchEnabled, S.stretchFOV = false, 120
    S.skyTheme, S.krobloxMode = "Off", "Off"
    if S.setBatSkin then pcall(S.setBatSkin, "Off", false) end
    S.batSkinMode = "Off"
    if S.setDisplaySkin then pcall(S.setDisplaySkin, "Off", false) else S.displaySkin="Off"; S.customSkinEnabled=false end
    S.currentAnimPack = "Off"
    S.hideOpiumButtonsEnabled = false
    S.lockUIEnabled = false
    S.Steal.StealRadius, S.Steal.StealDuration = 61, 1.3
    S.tpDownHeightTrigger = 20
    local function resetKey(name, kb, gp)
        if S.KB[name] then S.KB[name].kb, S.KB[name].gp = kb, gp end
    end
    resetKey("DropBrainrot", Enum.KeyCode.X, Enum.KeyCode.ButtonR2)
    resetKey("AutoLeft", Enum.KeyCode.Z, Enum.KeyCode.DPadLeft)
    resetKey("AutoRight", Enum.KeyCode.C, Enum.KeyCode.DPadRight)
    resetKey("AutoBat", Enum.KeyCode.E, Enum.KeyCode.ButtonY)
    resetKey("BatBypass", Enum.KeyCode.V, Enum.KeyCode.ButtonB)
    if S.setInformationE01 then S.setInformationE01(true, false) end
    resetKey("TPFlor", Enum.KeyCode.F, Enum.KeyCode.ButtonA)
    resetKey("GuiHide", Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonSelect)
    resetKey("SpeedToggle", Enum.KeyCode.Q, Enum.KeyCode.DPadUp)
    resetKey("LaggerToggle", Enum.KeyCode.R, Enum.KeyCode.DPadDown)
    S.hubColor = DEFAULT_HUB_COLOR
    S.optimizerMode = "standard"
    if S.setTripaVisual then S.setTripaVisual(false) end
    S.mobileButtonStyle = "original"
    SMKBrandStyle.setFont("original",false)
    if S.setMedusaSkin then S.setMedusaSkin("Off",false) end
    if S.refreshMobileButtonStyleSelection then S.refreshMobileButtonStyleSelection() end
    if S.refreshMobileButtonShape then S.refreshMobileButtonShape() end
    SMKApplyColorTheme(S.hubColor)
    S.mobileButtonPositions = {}
    S.floatingFreeButtonPositions = {}

    pcall(applyCustomSky, "Off")
    pcall(_G._SMKApplyKroblox, "Off")
    if S.displaySkinSelectorLabel then S.displaySkinSelectorLabel.Text="Off" end
    if S.customSkinVisual then S.customSkinVisual(false) end
    pcall(setUILock, false)
    if S.floatingPanelGui then S.floatingPanelGui.Enabled = true end
    pcall(function()
        local pg = LP:FindFirstChild("PlayerGui")
        local old = pg and pg:FindFirstChild("OpiumGGV5_2")
        if old then old.Enabled = true end
    end)
    SMKBindings.refresh()
    if S.speedClk then S.speedClk(false) end
    if S.setLaggerVisual then S.setLaggerVisual(false) end
    if S.setAntiRagVisual then S.setAntiRagVisual(false) end
    if S.setFpsVisual then S.setFpsVisual(false) end
    if S.setBatCounterVisual then S.setBatCounterVisual(false) end
    if S.batAimbotSetVisual then S.batAimbotSetVisual(false) end
    if S.tpBatSetVisual then S.tpBatSetVisual(false) end
    if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end
    if S.autoRightSetVisual then S.autoRightSetVisual(false) end
    if S.setAntiFlingVisual then S.setAntiFlingVisual(false) end
    if S.bodyLockSetVisual then S.bodyLockSetVisual(false) end
    if S.setVividVisual then S.setVividVisual(false) end
    if S.setStretchVisual then S.setStretchVisual(false) end
    if S.setMedusaVisual then S.setMedusaVisual(false) end
    if S.setUnwalkVisual then S.setUnwalkVisual(false) end
    if S.setAntiLagVisual then S.setAntiLagVisual(false) end
    if S.setHideOpiumButtons2 then S.setHideOpiumButtons2(false) end
    S.refreshSpeedModeLabel()
    resetFloatingPanel()
    if updateFloatingButtons then updateFloatingButtons() end
    saveConfig()
end

local function buildConfigTab(pages)
    mkSection("Config", pages, "General")
    mkInput("Config", pages, "UI Scale", S.userMenuScale or 1, function(v) SMKSetUserScale("menu", v) end)
    mkInput("Config", pages, "Mobile Buttons Scale", S.userMobileScale or 1, function(v) SMKSetUserScale("mobile", v) end)
    S.setLockUI_Visual2, _ = mkToggle("Config", pages, "Lock UI", nil, S.lockUIEnabled or false, function(on)
        S.lockUIEnabled=on; setUILock(on); saveConfig()
    end, nil)
    S.setEditMobileButtonsVisual, _ = mkToggle("Config", pages, "Edit Mobile Buttons", nil, false, function(on)
        S.editMobileButtons = on == true
        if on then
            S.lockUIEnabled = false
            setUILock(false)
            if S.setLockUI_Visual2 then S.setLockUI_Visual2(false) end
        end
        if S.refreshMobileEditMode then S.refreshMobileEditMode() end
        saveConfig()
    end, nil)
    do
        local card = mkCard("Config", pages, 44)
        local pill = Instance.new("Frame", card)
        pill.Name = "MobileButtonStylePill"
        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Color = C_BORDER; pillStroke.Transparency = 0.3
        pill.Position = UDim2.fromOffset(8, 5)
        pill.Size = UDim2.new(1, -16, 1, -10)
        pill.BackgroundColor3 = C_BG
        pill.BorderSizePixel = 0
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0.5, 0)
        local options = {}
        for index, option in ipairs({{"original", "Da Button original"}, {"round", "Button redondo"}}) do
            local choice = Instance.new("TextButton", pill)
            choice.Name = "MobileButtonStyle_" .. option[1]
            choice.Position = UDim2.new((index - 1) * 0.5, 3, 0, 3)
            choice.Size = UDim2.new(0.5, -6, 1, -6)
            choice.BorderSizePixel = 0
            choice.AutoButtonColor = false
            choice.Font = Enum.Font.GothamBold
            choice.TextSize = 10
            choice.TextWrapped = true
            choice.Text = option[2]
            Instance.new("UICorner", choice).CornerRadius = UDim.new(0.5, 0)
            local stroke = Instance.new("UIStroke", choice)
            stroke.Color = C_BORDER; stroke.Transparency = 0.65
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            options[option[1]] = choice
            choice.Activated:Connect(function()
                S.mobileButtonStyle = option[1]
                S.refreshMobileButtonStyleSelection()
                if S.refreshMobileButtonShape then S.refreshMobileButtonShape() end
                saveConfig()
            end)
        end
        S.refreshMobileButtonStyleSelection = function()
            for id, choice in pairs(options) do
                local selected = S.mobileButtonStyle == id
                TS_G:Create(choice, TweenInfo.new(0.18), {
                    BackgroundColor3 = selected and C_WHITE or C_CARD,
                    TextColor3 = selected and C_BG or C_GREY,
                    BackgroundTransparency = selected and 0.04 or 0.24,
                }):Play()
            end
        end
        S.refreshMobileButtonStyleSelection()
    end
    mkSection("Config", pages, "Fonte do nome do hub")
    do
        local card=mkCard("Config",pages,44)
        local pill=Instance.new("Frame",card); pill.Name="HubTitleFontPill"; pill.Position=UDim2.fromOffset(8,5); pill.Size=UDim2.new(1,-16,1,-10)
        pill.BackgroundColor3=C_BG; pill.BorderSizePixel=0; Instance.new("UICorner",pill).CornerRadius=UDim.new(0.5,0)
        local border=Instance.new("UIStroke",pill); border.Color=C_BORDER; border.Transparency=0.3
        local choices={}
        for i,option in ipairs({{"original","Original",Enum.Font.GothamBlack},{"balloon","Balloon",Enum.Font.FredokaOne}}) do
            local choice=Instance.new("TextButton",pill); choice.Size=UDim2.new(0.5,-6,1,-6); choice.Position=UDim2.new((i-1)*0.5,3,0,3)
            choice.Name="HubTitleFont_"..option[1]; choice.Text=option[2]; choice.Font=option[3]; choice.TextSize=option[1]=="balloon" and 16 or 12
            choice.AutoButtonColor=false; choice.BorderSizePixel=0; Instance.new("UICorner",choice).CornerRadius=UDim.new(0.5,0)
            local stroke=Instance.new("UIStroke",choice); stroke.Color=C_BORDER; stroke.Transparency=0.65; stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
            choices[option[1]]=choice
            choice.Activated:Connect(function() SMKBrandStyle.setFont(option[1],true) end)
        end
        S.refreshHubFontSelection=function()
            for id,choice in pairs(choices) do
                local selected=SMKBrandStyle.fontMode==id
                TS_G:Create(choice,TweenInfo.new(0.18),{
                    BackgroundColor3=selected and C_WHITE or C_CARD,
                    TextColor3=selected and C_BG or C_GREY,
                    BackgroundTransparency=selected and 0.04 or 0.24,
                }):Play()
            end
        end
        S.refreshHubFontSelection()
    end
    S.setHideOpiumButtons2, _ = mkToggle("Config", pages, "Hide Buttons", nil, S.hideOpiumButtonsEnabled or false, function(on)
        S.hideOpiumButtonsEnabled=on
        if S.floatingPanelGui then S.floatingPanelGui.Enabled=not on end
        pcall(function()
            local pg=LP:FindFirstChild("PlayerGui")
            if pg then local og=pg:FindFirstChild("OpiumGGV5_2"); if og then og.Enabled=not on end end
        end)
        saveConfig()
    end, nil)
    mkSection("Config", pages, "Cor do hub")
    local colorCard = mkCard("Config", pages, 52)
    local choices = {}
    local labels = {"Original", "Dourado", "Violeta"}
    S.refreshHubColorSelection = function()
        for id, choice in pairs(choices) do
            local selected = S.hubColor == id
            choice.BackgroundColor3 = selected and C_WHITE or C_CARD
            choice.TextColor3 = selected and C_BG or C_GREY
        end
    end
    for index, colorId in ipairs(HUB_COLOR_OPTIONS) do
        local choice = Instance.new("TextButton", colorCard)
        choice.Name = "HubColor_" .. colorId
        choice.Position = UDim2.new((index - 1) / 3, 6, 0, 10)
        choice.Size = UDim2.new(1 / 3, -12, 0, 32)
        choice.BorderSizePixel = 0
        choice.AutoButtonColor = false
        choice.Text = labels[index]
        choice.Font = Enum.Font.GothamBold
        choice.TextSize = 11
        choice.TextWrapped = true
        Instance.new("UICorner", choice).CornerRadius = UDim.new(0, 6)
        choices[colorId] = choice
        choice.Activated:Connect(function()
            S.hubColor = colorId
            SMKApplyColorTheme(colorId)
            saveConfig()
        end)
    end
    S.refreshHubColorSelection()

    mkSection("Config", pages, "Config")
    local function addConfigManagementButton(text, callback, mode)
        local card = mkCard("Config", pages, 44)
        local button = Instance.new("TextButton", card)
        button.Name = "ConfigManagement_" .. text:gsub("%s+", "")
        button.Size = UDim2.new(1, -20, 0.82, 0)
        button.Position = UDim2.new(0, 10, 0.09, 0)
        button.BackgroundColor3 = SMKThemeRGB(255, 255, 255)
        button.BorderSizePixel = 0
        button.Text = ""
        button.AutoButtonColor = false
        button.ZIndex = 8
        Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)

        local gradient = Instance.new("UIGradient", button)
        gradient.Rotation = 90
        if mode == "save" then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, SMKThemeRGB(120, 120, 130)),
                ColorSequenceKeypoint.new(0.50, SMKThemeRGB(60, 60, 70)),
                ColorSequenceKeypoint.new(1.00, SMKThemeRGB(20, 20, 26)),
            })
        elseif mode == "reset" then
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, SMKThemeRGB(80, 90, 110)),
                ColorSequenceKeypoint.new(0.50, SMKThemeRGB(45, 55, 75)),
                ColorSequenceKeypoint.new(1.00, SMKThemeRGB(18, 22, 32)),
            })
        else
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, SMKThemeRGB(180, 45, 80)),
                ColorSequenceKeypoint.new(0.50, SMKThemeRGB(120, 25, 55)),
                ColorSequenceKeypoint.new(1.00, SMKThemeRGB(60, 10, 30)),
            })
        end

        local stroke = Instance.new("UIStroke", button)
        stroke.Thickness = 1.5
        stroke.Transparency = 0.35
        stroke.Color = mode == "save" and SMKThemeRGB(200, 200, 215)
            or mode == "reset" and SMKThemeRGB(150, 175, 210)
            or SMKThemeRGB(255, 130, 170)

        local label = Instance.new("TextLabel", button)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = SMKThemeRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 13
        label.TextStrokeColor3 = SMKThemeRGB(0, 0, 0)
        label.TextStrokeTransparency = 0.55
        label.ZIndex = 9

        button.MouseEnter:Connect(function()
            TS_G:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -12, 0.92, 0),
                Position = UDim2.new(0, 6, 0.04, 0),
            }):Play()
            TS_G:Create(stroke, TweenInfo.new(0.14), {Transparency = 0.05}):Play()
        end)
        button.MouseLeave:Connect(function()
            TS_G:Create(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -20, 0.82, 0),
                Position = UDim2.new(0, 10, 0.09, 0),
            }):Play()
            TS_G:Create(stroke, TweenInfo.new(0.14), {Transparency = 0.35}):Play()
        end)

        if mode == "save" then
            button.MouseButton1Click:Connect(function()
                local ok = pcall(saveConfig)
                label.Text = ok and "SAVED ✓" or "ERROR"
                task.delay(1.2, function()
                    if label and label.Parent then label.Text = text end
                end)
            end)
        elseif mode == "reset" then
            local resetDebounce = false
            button.MouseButton1Click:Connect(function()
                if resetDebounce then return end
                resetDebounce = true
                pcall(resetFloatingPanel)
                label.Text = "RESET ✓"
                task.delay(1.2, function()
                    if label and label.Parent then
                        label.Text = text
                        resetDebounce = false
                    end
                end)
            end)
        else
            local deleteState = 0
            local deleteDebounce = false
            button.MouseButton1Click:Connect(function()
                if deleteDebounce then return end
                if deleteState == 0 then
                    deleteState = 1
                    label.Text = "CONFIRM?"
                    gradient.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0.00, SMKThemeRGB(230, 70, 100)),
                        ColorSequenceKeypoint.new(0.50, SMKThemeRGB(180, 40, 70)),
                        ColorSequenceKeypoint.new(1.00, SMKThemeRGB(90, 15, 40)),
                    })
                    task.delay(2, function()
                        if button and button.Parent and deleteState == 1 then
                            deleteState = 0
                            label.Text = text
                            gradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.00, SMKThemeRGB(180, 45, 80)),
                                ColorSequenceKeypoint.new(0.50, SMKThemeRGB(120, 25, 55)),
                                ColorSequenceKeypoint.new(1.00, SMKThemeRGB(60, 10, 30)),
                            })
                        end
                    end)
                else
                    deleteDebounce = true
                    local ok = pcall(resetConfigToDefaults)
                    label.Text = ok and "DELETED ✓" or "ERROR"
                    deleteState = 0
                    task.delay(1.5, function()
                        if label and label.Parent then
                            label.Text = text
                            gradient.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0.00, SMKThemeRGB(180, 45, 80)),
                                ColorSequenceKeypoint.new(0.50, SMKThemeRGB(120, 25, 55)),
                                ColorSequenceKeypoint.new(1.00, SMKThemeRGB(60, 10, 30)),
                            })
                            deleteDebounce = false
                        end
                    end)
                end
            end)
        end
        return button
    end
    addConfigManagementButton("SAVE CONFIG", saveConfig, "save")
    addConfigManagementButton("RESET POSITIONS", resetFloatingPanel, "reset")
    addConfigManagementButton("DELETE SETTINGS", resetConfigToDefaults, "delete")
end -- close buildConfigTab

-- Disable health bar
pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end)
LP.CharacterAdded:Connect(function()
    pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false) end)
end) -- close LP.CharacterAdded:Connect

local function buildGui()
    S.mainMenuFrame = nil
    S.refreshHubColorSelection = nil
    SMKApplyColorTheme(S.hubColor or DEFAULT_HUB_COLOR)
    local old = game:GetService("CoreGui"):FindFirstChild("SMK")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "SMK"; gui.ResetOnSpawn = false
    gui.DisplayOrder = 100; gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    -- Outer drag frame
    local outer = Instance.new("Frame", gui)
    outer.Name = "Outer"
    outer.AnchorPoint = Vector2.new(0, 0.5)
    outer.Position = UDim2.new(0, 14, 0.5, 0)
    outer.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
    outer.BackgroundTransparency = 1; outer.BorderSizePixel = 0
    outer.ClipsDescendants = false
    outer.Visible = false
    S.mainMenuFrame = outer
    -- El panel no se arrastra desde toda su superficie: eso interfería con
    -- los gestos de toque y desplazamiento de las páginas/tabs.
    applyPhoneGuiScale(outer, S.phoneGuiScale, "mainGuiScaleObj")
    if S.IS_TOUCH_DEVICE then outer.Position = UDim2.new(0,8,0.5,0) end
    if S.menuOpenPosition then outer.Position = S.menuOpenPosition end
    S.menuOpenPosition = outer.Position

    -- Inner panel (glassmorphism)
    local main = Instance.new("Frame", outer)
    main.Name = "Main"; main.Size = UDim2.new(1,0,1,0)
    main.BackgroundColor3 = C_BG; main.BackgroundTransparency = 1
    main.BorderSizePixel = 0; main.ClipsDescendants = true; main.ZIndex = 1
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    -- Banner integrado como fundo de todo o menu, sem uma janela separada.
    local menuBackground = Instance.new("ImageLabel", main)
    menuBackground.Name = "PurenDuelsMenuBackground"
    menuBackground.Size = UDim2.fromScale(1, 1)
    menuBackground.Position = UDim2.fromScale(0, 0)
    menuBackground.BackgroundColor3 = C_BG
    menuBackground.BackgroundTransparency = 0.08
    menuBackground.BorderSizePixel = 0
    menuBackground.ImageTransparency = 0.34
    menuBackground.ScaleType = Enum.ScaleType.Crop
    menuBackground.ZIndex = 0
    menuBackground.Active = false
    addPuren001Decorations(menuBackground, false)
    task.spawn(function()
        local asset = resolvePurenDuelsImage()
        if asset and menuBackground.Parent then menuBackground.Image = asset end
    end)
    local menuBackgroundShade = Instance.new("Frame", main)
    menuBackgroundShade.Name = "PurenDuelsMenuBackgroundShade"
    menuBackgroundShade.Size = UDim2.fromScale(1, 1)
    menuBackgroundShade.BackgroundColor3 = C_BG
    menuBackgroundShade.BackgroundTransparency = 0.42
    menuBackgroundShade.BorderSizePixel = 0
    menuBackgroundShade.ZIndex = 0
    menuBackgroundShade.Active = false
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = SMKThemeRGB(160, 160, 172); mainStroke.Thickness = 1.2; mainStroke.Transparency = 0.34
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Painel de cor sólida, sem imagens de fundo.

    -- Header (premium gradient + glassmorphism)
    local header = Instance.new("Frame", main)
    header.Name = "Header"; header.Size = UDim2.new(1,0,0,HEADER_H)
    header.BackgroundColor3 = C_HEADER; header.BackgroundTransparency = 0.32
    header.BorderSizePixel = 0; header.ZIndex = 5; header.ClipsDescendants = true
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)
    -- Arrastrar solo desde el encabezado y mover el panel completo.
    makeDraggable(header, false, outer, function(target)
        S.menuOpenPosition = target.Position
    end)
    local headerGrad = Instance.new("UIGradient", header)
    headerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SMKThemeRGB(65, 65, 74)),
        ColorSequenceKeypoint.new(0.5, SMKThemeRGB(36, 36, 43)),
        ColorSequenceKeypoint.new(1, SMKThemeRGB(19, 19, 24)),
    })
    headerGrad.Rotation = 90
    addPuren001Decorations(header, true)

    local titleImage = Instance.new("TextLabel", header)
    titleImage.Name = "MenuTitleImage"
    titleImage.AnchorPoint = Vector2.new(0, 0.5)
    titleImage.Position = UDim2.fromOffset(4, 36)
    titleImage.Size = UDim2.fromOffset(240, 68)
    titleImage.BackgroundTransparency = 1
    titleImage.Text = SMKBrandStyle.text
    titleImage.Font = Enum.Font.GothamBlack
    titleImage.TextSize = 32
    titleImage.TextColor3 = C_WHITE
    titleImage.ZIndex = 6
    SMKBrandStyle.apply(titleImage)

    titleImage.Position = UDim2.fromOffset(10, 36)
    titleImage.Size = UDim2.fromOffset(230, 68)

    -- Close button (premium style)
    local closeBtn = Instance.new("TextButton", header)
    closeBtn.AnchorPoint = Vector2.new(1,0.5); closeBtn.Position = UDim2.fromOffset(PANEL_W-14,36)
    closeBtn.Size = UDim2.fromOffset(30,30); closeBtn.BackgroundColor3 = SMKThemeRGB(28, 28, 28)
    closeBtn.BorderSizePixel = 0; closeBtn.Text = "−"; closeBtn.TextColor3 = SMKThemeRGB(205, 205, 214)
    closeBtn.AutoButtonColor = false
    closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 18; closeBtn.ZIndex = 10
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,10)
    local closeBtnStroke = Instance.new("UIStroke", closeBtn)
    closeBtnStroke.Color = SMKThemeRGB(59, 59, 59); closeBtnStroke.Thickness = 1; closeBtnStroke.Transparency = 0.3
    closeBtn.MouseEnter:Connect(function()
        TS_G:Create(closeBtn,TweenInfo.new(0.15,Enum.EasingStyle.Quad),{BackgroundColor3=C_HIGHLIGHT,TextColor3=C_WHITE}):Play()
        TS_G:Create(closeBtnStroke,TweenInfo.new(0.15),{Color=C_HIGHLIGHT_BRIGHT,Transparency=0}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS_G:Create(closeBtn,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{BackgroundColor3=SMKThemeRGB(28, 28, 28),TextColor3=SMKThemeRGB(205, 205, 214)}):Play()
        TS_G:Create(closeBtnStroke,TweenInfo.new(0.2),{Color=SMKThemeRGB(59, 59, 59),Transparency=0.3}):Play()
    end)

    -- Header separator (premium animated silver glow line)
    local hSep = Instance.new("Frame", main)
    hSep.Size = UDim2.new(1,-20,0,1); hSep.Position = UDim2.fromOffset(10,HEADER_H)
    hSep.BackgroundColor3 = SMKThemeRGB(235, 235, 235); hSep.BackgroundTransparency = 0.45
    hSep.BorderSizePixel = 0; hSep.ZIndex = 4
    Instance.new("UICorner", hSep).CornerRadius = UDim.new(1,0)
    local hSepG = Instance.new("UIGradient", hSep)
    hSepG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, SMKThemeRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.46, SMKThemeRGB(235, 235, 235)),
        ColorSequenceKeypoint.new(1, SMKThemeRGB(170, 170, 170)),
    })
    hSepG.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.12,0.05),
        NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(0.88,0.05), NumberSequenceKeypoint.new(1,1)
    })
    -- Glow line behind separator
    local hSepGlow = Instance.new("Frame", main)
    hSepGlow.Size = UDim2.new(1,-30,0,6); hSepGlow.Position = UDim2.fromOffset(15,HEADER_H-2)
    hSepGlow.BackgroundColor3 = SMKThemeRGB(170, 170, 170); hSepGlow.BackgroundTransparency = 0.96
    hSepGlow.BorderSizePixel = 0; hSepGlow.ZIndex = 3
    Instance.new("UICorner", hSepGlow).CornerRadius = UDim.new(1,0)
    local hSepGlowG = Instance.new("UIGradient", hSepGlow)
    hSepGlowG.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.2,0.3),
        NumberSequenceKeypoint.new(0.5,0), NumberSequenceKeypoint.new(0.8,0.3), NumberSequenceKeypoint.new(1,1)
    })

    -- Drakon-style tabs sit below the header; horizontal scrolling keeps
    -- every label readable on the compact ＳＭＫㅤＨＵＢ panel.
    local TAB_H = 44
    local contentY = HEADER_H + TAB_H + 8
    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, 0, 1, -contentY)
    contentArea.Position = UDim2.fromOffset(0, contentY)
    contentArea.BackgroundTransparency = 1
    contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 2
    contentArea.ClipsDescendants = true

    local pages = buildGui_createScrollingPages(contentArea)
    buildSpeedTab(pages); buildMainTab(pages); buildMoveTab(pages); buildConfigTab(pages); buildKeybindsTab(pages)

    -- YouTube Music Player integrado como una pestaña independiente.
    do
        local musicPage = pages.Music
        local heading = Instance.new("TextLabel", musicPage)
        heading.Name = "MusicHeading"
        heading.Size = UDim2.new(1, 0, 0, 34)
        heading.BackgroundTransparency = 1
        heading.Text = "YOUTUBE MUSIC PLAYER"
        heading.TextColor3 = C_WHITE
        heading.Font = Enum.Font.GothamBlack
        heading.TextSize = 15
        heading.TextXAlignment = Enum.TextXAlignment.Left
        heading.LayoutOrder = 1

        local launchButton = Instance.new("TextButton", musicPage)
        launchButton.Name = "LaunchYouTubeMusic"
        launchButton.Size = UDim2.new(1, 0, 0, 46)
        launchButton.BackgroundColor3 = C_CARD
        launchButton.BackgroundTransparency = 0.08
        launchButton.BorderSizePixel = 0
        launchButton.Text = "♫  ABRIR YOUTUBE MUSIC"
        launchButton.TextColor3 = C_WHITE
        launchButton.Font = Enum.Font.GothamBold
        launchButton.TextSize = 13
        launchButton.AutoButtonColor = false
        launchButton.LayoutOrder = 2
        Instance.new("UICorner", launchButton).CornerRadius = UDim.new(0, 14)
        local launchStroke = Instance.new("UIStroke", launchButton)
        launchStroke.Color = C_BORDER
        launchStroke.Thickness = 1
        launchStroke.Transparency = 0.35

        local musicStatus = Instance.new("TextLabel", musicPage)
        musicStatus.Name = "MusicStatus"
        musicStatus.Size = UDim2.new(1, 0, 0, 38)
        musicStatus.BackgroundTransparency = 1
        musicStatus.Text = "Pulsa el botón para iniciar el reproductor."
        musicStatus.TextColor3 = C_GREY
        musicStatus.Font = Enum.Font.Gotham
        musicStatus.TextSize = 11
        musicStatus.TextWrapped = true
        musicStatus.TextXAlignment = Enum.TextXAlignment.Left
        musicStatus.LayoutOrder = 4

        -- Botón SMK HUB colocado justo debajo del botón YouTube Music.
        local confuserButton = Instance.new("TextButton", musicPage)
        confuserButton.Name = "SMKHubConfuserButton"
        confuserButton.Size = UDim2.new(1, 0, 0, 42)
        confuserButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        confuserButton.BackgroundTransparency = 0
        confuserButton.BorderSizePixel = 0
        confuserButton.Text = "SMK HUB"
        confuserButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        confuserButton.Font = Enum.Font.GothamBold
        confuserButton.TextSize = 13
        confuserButton.AutoButtonColor = false
        confuserButton.LayoutOrder = 3
        Instance.new("UICorner", confuserButton).CornerRadius = UDim.new(0, 14)
        local confuserStroke = Instance.new("UIStroke", confuserButton)
        confuserStroke.Color = Color3.fromRGB(255, 255, 255)
        confuserStroke.Thickness = 1
        confuserStroke.Transparency = 0

        local confuserRunning = false
        confuserButton.Activated:Connect(function()
            if confuserRunning then return end
            confuserRunning = true
            local originalText = confuserButton.Text
            confuserButton.Text = "CARGANDO SMK HUB..."
            task.spawn(function()
                local ok, err = pcall(function()
                    local response = game:HttpGet("https://gist.githubusercontent.com/xd-myscript/813506337130a69f73815abf6936525a/raw/f1bd4ef4a9dc92381d0c788ec61fc4fe1f1b5b5b/ghoxtconfuser.lua")
                    local compiler = loadstring or (type(getgenv) == "function" and getgenv().loadstring)
                    assert(type(compiler) == "function", "loadstring no está disponible")
                    local chunk, compileError = compiler(response)
                    assert(type(chunk) == "function", compileError or "No se pudo compilar Ghoxt Confuser")
                    chunk()
                end)
                confuserButton.Text = ok and "SMK HUB INICIADO" or "ERROR AL INICIAR SMK HUB"
                if not ok then warn("SMK HUB: " .. tostring(err)) end
                task.wait(2)
                confuserButton.Text = originalText
                confuserRunning = false
            end)
        end)

        local musicSource = [====[
getgenv().YMP = getgenv().YMP or false

if getgenv().YMP then
	return
end

getgenv().YMP = true
task.wait(0.5)

local fn = cloneref or function(arg)
	return arg
end

local tweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local tbl = { Ordem = "relevance", Data = "any", Duracao = "any", Pagina = 1 }
local tweenInfo3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local ordem = "relevance"
local data = "any"
local duracao = "any"
local tbl2 = { "relevance", "view" }
local tbl3 = { "any", "hours", "today", "week", "month", "year" }
local tbl4 = { "any", "short", "medium", "long" }
local tbl5 = {}
local tbl6 = {}
local tbl7 = {}
local tbl8 = {}
local tbl9 = {}
local tbl10 = {}
local tbl11 = {}
local v = fn(game:GetService("CoreGui"))
local v2 = fn(game:GetService("StarterGui"))
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = v
screenGui.IgnoreGuiInset = true
HttpService = fn(game:GetService("HttpService"))
local v3 = fn(game:GetService("Lighting"))
local v4 = fn(game:GetService("Players"))
local userId = v4.LocalPlayer.UserId
local str = v4.LocalPlayer.LocaleId:lower()
local v5 = fn(game:GetService("LogService"))
local v6 = fn(game:GetService("TweenService"))
fn(Instance.new("Sound"))
local v7 = fn(game:GetService("SoundService"))
local v8 = fn(game:GetService("Workspace"))
fn(game:GetService("RunService"))
fn(game:GetService("TextService"))
local v9 = fn(game:GetService("UserInputService"))
local currentCamera = v8.CurrentCamera
local flag = false
local flag2 = false
local screenGui2 = nil
local n = 1
local str2 = "Todos"
local flag3 = false
local flag4 = false
local n2 = 0
local v10 = nil
local tweenInfo4 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo5 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo6 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local flag5 = true
local flag6 = false
local str3 = "https://ymp-api.ddns.net"
local websocket_ = WebSocket or websocket or Websocket or syn and syn.websocket or nil
local flag7 = false
local flag8 = false
local str4 = "Auto"
local v11 = nil
local flag9 = false
local v12 = nil
local udim2 = nil
local flag10 = false
local flag11 = false
local flag12 = false
local flag13 = false
local tween = nil
local n3 = 0
local text = nil
local flag14 = false
local layoutOrder = 0
local udim22 = UDim2.new(0, 4, 0, 4)
local udim23 = UDim2.new(0, 4, 1, 4)
local flag15 = true
local tween2 = nil
local v13 = nil
local tween3 = nil
local flag16 = false
local flag17 = false
local request_ = request or http_request or syn_request or syn and syn.request or http and http.request or fluxus and fluxus.request or getgenv and getgenv().request
local requestAsync

if request_ then
	requestAsync = request_
else
	requestAsync = http and http.request_async
end

local writeClipboard = setclipboard or toclipboard or syn and syn.write_clipboard
local setclipboard_

if writeClipboard then
	setclipboard_ = writeClipboard
else
	setclipboard_ = fluxus and fluxus.setclipboard
end

local gethwid_ = gethwid and gethwid()

if not gethwid_ then
	gethwid_ = syn and syn.gethwid and syn.gethwid()
end

gethwid_ = gethwid_ or fluxus and fluxus.gethwid and fluxus.gethwid()
local hwid

if gethwid_ then
	hwid = gethwid_
else
	hwid = getgenv and getgenv().hwid
end

local v14 = hwid or userId
local flag18 = typeof(clonefunction) == "function" and clonefunction or nil
local v15 = flag18 and flag18(pcall) or pcall
local v16 = flag18 and flag18(typeof) or typeof

CheckRequest = function()
	local v17 = v15(function()
		return ishooked
	end) and ishooked or nil

	local v18 = v15(function()
		return restorefunction
	end) and restorefunction or nil

	if v16(v18) == "function" and v16(v17) == "function" then
		local v19, v20 = v15(v17, v17)

		if v19 and v20 then
			v15(v18, v17)
		end
	end

	if v16(v17) == "function" then
		local v19, v20 = v15(v17, requestAsync)
		if v19 and v20 then
			return false
		end
		local v21, v22 = v15(v17, game.HttpGet)
		if v21 and v22 then
			return false
		end
	end

	return true
end

if not CheckRequest() then
	return
end

local ok, result = pcall(game.HttpGet, game, "https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Versao")

if not ok or not result or not CheckRequest() then
	return
end

local str5 = result:gsub("%s+", ""):gsub("[^%w.]", "")

if str5 == "off" then
	return
end

if str5 ~= "8.5" then
	getgenv().YMP = false
	-- No ejecutar código Lua remoto del reproductor de música.
	return
end

local ok2, result2 = pcall(function()
	return game:HttpGet("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Notifications")
end)

if ok2 then
	local ok3, result3 = pcall(function()
		return HttpService:JSONDecode(result2)
	end)

	if ok3 and result3 then
		local str6 = (result3.title or ""):gsub("%s+", "")
		local str7 = (result3.text or ""):gsub("%s+", "")

		if str6 ~= "" or str7 ~= "" then
			v2:SetCore("SendNotification", {
				Title = result3.title or "Empty",
				Text = result3.text or "Empty",
				Icon = "rbxassetid://83758613781843",
				Duration = 10,
			})

			task.wait(5)
		end
	end
end

Carregar = function()
	if not flag then
		flag = true
		screenGui2 = Instance.new("ScreenGui")
		screenGui2.Parent = v
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLabel.Size = UDim2.new(0, 0, 0, 0)
		imageLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
		imageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		imageLabel.Image = "rbxassetid://132058030456598"
		imageLabel.Active = true
		imageLabel.Draggable = false
		imageLabel.Parent = screenGui2
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 5)
		uiCorner.Parent = imageLabel
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Thickness = 2
		uiStroke.Color = Color3.fromRGB(255, 0, 0)
		uiStroke.Parent = imageLabel
		local tween4 = v6:Create(imageLabel, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0.4, 0, 0.5, 0), Position = UDim2.new(0.5, 0, 0.4, 0) })
		tween4:Play()

		tween4.Completed:Connect(function()
			if not flag then
				return
			end
			flag2 = true

			task.spawn(function()
				while true do
					if flag2 and imageLabel.Parent then
						local tween5 = v6:Create(imageLabel, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0.5, 0, 0.38, 0) })
						local tween6 = v6:Create(imageLabel, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), { Position = UDim2.new(0.5, 0, 0.42, 0) })
						tween5:Play()
						tween5.Completed:Wait()

						if flag2 then
							tween6:Play()
							tween6.Completed:Wait()
							continue
						end
					end

					break
				end
			end)
		end)
	else
		flag = false
		flag2 = false

		if screenGui2 then
			local imageLabel = screenGui2:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				local tween4 = v6:Create(imageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Position = UDim2.new(0.5, 0, -0.5, 0),
					BackgroundTransparency = 1,
					ImageTransparency = 1,
				})

				tween4:Play()

				tween4.Completed:Connect(function()
					if screenGui2 then
						screenGui2:Destroy()
						screenGui2 = nil
					end
				end)
			else
				screenGui2:Destroy()
				screenGui2 = nil
			end
		end
	end
end

Carregar()

Traducao = {
	Sucesso = "Success",
	Erro = "Error",
	Imcompativel = "Your executor does not have support",
	Navegacao = "Navigation",
	Player = "Media Player",
	Add = "Add New",
	Equalizador = "Audio adjustment",
	Welcome = "Welcome",
	Dev = "Creator",
	Hey = "Hey you!",
	Play = "Play a song for me",
	Volume = "Volume",
	Freque = "Sound frequencies",
	Efeitos = "Sound effects",
	Graves = "Bass",
	Medios = "Mids",
	Agudos = "Treble",
	Nenhum = "None",
	Todos = "All",
	Musicas = "Musics",
	Favoritos = "Favorites",
	Favoritado = "Added to favorites",
	Desfavoritado = "Removed from favorites",
	Excluido = "Content deleted",
	Vazio = "Empty",
	VazioTexto = "There is nothing in this category at the moment",
	Search = "Search",
	Pesquisar = "Search for a YouTube title or link",
	Pesquisar2 = "Search for a YouTube title or link, or a Roblox ID",
	PesquiseTitle = "Start a search",
	PesquiseText = "We'll do our best to find your video or music",
	PesquiseTextPL = "We'll search through your entire playlist",
	SemResutadoTitle = "No results",
	SemResutadoText = "We checked everywhere possible, but we couldn't find any results for that search",
	SemResutadoTextPL = "We didn't find any results for that search in your playlist",
	LocalTitle = "Local Audios",
	LocalText = "There's nothing here yet, Add new audio files to the 'Local Audio' folder of the script",
	EscolhaFor = "Select the desired format",
	Musica = "Music",
	Cancelar = "Cancel",
	De = "By",
	In = "In",
	ErroCrackTitle = "Request denied",
	ErroCrackText = "It appears you do not have a valid Premium key",
	ErroTitle = "Something went wrong",
	ErroText = "There was an instability on our servers or in your internet connection, Please try again",
	Aguarde = "Please wait",
	Dados = "We are obtaining data from your file",
	MaisUmPauco = "Almost ready",
	Baixando = "We are downloading your file to add it to your playlist",
	Baixado = "Download complete!",
	Terminou = "Everything went well, and it's already been added to your playlist",
	Priv1 = "Download and play videos",
	Priv2 = "Advanced search",
	PP = "Premium Privilege",
	SobrePri1 = "You will be able to download and watch any YouTube video",
	SobrePri2 = "Have an advanced search that includes search filters and more pages of results",
	SobrePri3 = "You can use MiniPlayer to watch videos or control music on a small floating window",
	SobrePri4 = "Add and listen to any audio from the Roblox library",
	SobrePri5 = "You will be able to interact in Global Chat and converse with other YouTube Music Player users in real time",
	SobrePri6 = "The floating button will have a stylish yellow look!",
	Key = "Enter the Premium key here",
	Link = "Get a free key",
	Robux = "Buy a key with Robux",
	KeyInvalida = "The key you provided is invalid or has expired!",
	KeyErro = "An error occurred while validating your key, Please try again in a few seconds",
	JaTemKey = "It seems to me that you already have a registered key",
	LinkCopiado = "Link copied!",
	Navegador = "Paste the link into your browser to get the key",
	TooMany = "Too many requests",
	RateLi = "You are making too many requests, Wait a few seconds and try again!",
	KeyError = "An error occurred in the key system, Please try again",
	OpcaoBloqueadaTitle = "Option blocked",
	OpcaoBloqueadaText = "Get a Premium key to use this!",
	NenhumaMidia = "No valid tracks found in your playlist's current category!",
	PlayMode = "Playback mode",
	Auto = "Auto-skip: The next track from the current category in your playlist will be selected automatically",
	Repetir = "Repeat: The current track you are listening to will be repeated on a loop",
	Random = "Random: The system will randomly select a track from the current category of your playlist",
	PlayModeRepetir = "No valid tracks found in your playlist's current category, Repeating...",
	DownloadFazendo = "Wait for the system to finish loading the images",
	RecursoTi = "Resource unavailable",
	RecursoTe = "The main equalizer options are not compatible with video",
	RsetadoEqua = "All the changes you made to the equalizer have been removed!",
	NaoPodePagina = "You cannot change pages at the moment",
	NaoPodeFiltro = "Do a search before applying filters!",
	Processando = "Processing...",
	Filter = "Search filters",
	Order = "Order:",
	UploaDate = "Upload Date:",
	Duration = "Duration:",
	AplicarF = "Apply filters",
	RemoverF = "Remove filters",
	Relevance = "Relevance",
	View = "Most viewed",
	Any = "Any",
	Hours = "Last hours",
	Today = "Today",
	Week = "This week",
	Month = "This month",
	Year = "This year",
	Short = "Short(less than 4 minutes)",
	Long = "Long(more than 20 minutes)",
	Medium = "Medium(4 to 20 minutes)",
	JaTemRoblox = "You already have this Roblox ID in your playlist!",
	JaTemMusica = "You already have this song in your playlist!",
	JaTemVideo = "You already have this video in your playlist!",
	FiltrosRemovidos = "All applied filters have been removed!",
	FiltrosJaPadrao = "All filters are already defined by default!",
	Privado = "This audio has been set to private or deleted, It cannot be played",
	VocePremium = "Validated Key",
	Keyless = "Global Chat keyless",
	KeylessOn = "Keyless mode is enabled, Global chat is now unlocked!",
	KeylessOff = "Keyless mode has been disabled, Global Chat is blocked!",
	VocePremiumTexto = "Your Premium has been successfully activated, Enjoy your privileges!",
	Respeito = "Follow the rules to avoid being banned",
	RegrasTi = "Chat Rules",
	Regras = "No insults, No racism, No inappropriate or malicious content, No spam, No suspicious links",
	Sistema = "System",
	EnvieGc = "Write something...",
	GcKey = "Get a premium key to send messages in global chat",
	GcBan = "You have been banned from Global Chat, You can appeal on Discord using your ID:",
	GcUnban = "You have been unbanned from global chat, Behave yourself to avoid being banned again!",
	Banido = "You have been banned",
	Desbanido = "You have been unbanned",
	ExploitIcomGC = "Your executor does not support Global Chat!",
	TraducaoSystem = "Translation",
	TraduOn = "The Global Chat translation system has been enabled",
	TraduOff = "The Global Chat translation system has been disabled",
	TextoCopiado = "Copied message",
	Mutado = "Sounds Removed",
	Desmutado = "Sounds Restored",
	SobreMute = "All game sounds have been removed",
	SobreUnmute = "All the game sounds have been restored",
	AvisoReport1 = "Report Notice — You are about to report the user",
	AvisoReport2 = "on Global Chat, Are you sure you want to continue? False reports that do not involve an actual rule violation may result in a ban.",
	ReportSucesso = "Report sent!",
	ReportSucesso2 = "Your report has been submitted to our staff team, We will review it and take the necessary actions",
	MotivoReport = "Enter the reason for the report here",
	ReportErro = "Report Error",
	ReportErro1 = "For security reasons, you must have a valid Premium key to submit reports",
	ReportErro2 = "The reported message could not be found, Are you attempting to submit a false report?",
	ReportErro3 = "An error occurred while processing the report, Please try again",
	ReportErro4 = "You can only submit new reports every 2 minutes",
	ReportErro5 = "Are you seriously trying to report yourself?",
	ReportErro6 = "You have already reported this message",
	ReportErro7 = "This message has already been reported by another user",
	ReportErro8 = "You are banned and cannot submit reports",
	ReportErro10 = "Write a reason in your report!",
	ReportErro11 = "The reason must be a minimum of 10 characters and a maximum of 200 characters",
	Aviso = "Warning",
	FecharAviso = "Close warn",
	MsgMod = "Message from the moderator:",
	Tutorial = "The link has been copied successfully — Paste it into your browser for instructions on how to resolve download errors",
	Tentando = "Trying Again",
	TentandoTexto = "We will try downloading again",
	GCmudo = "Global Chat muted",
	GCmudoTexto = "New messages will not be notified via the floating button",
	GCunmudo = "Global Chat unmuted",
	GCunmudoTexto = "You will be notified of each new message",
	MidiaErro = "Error loading media",
	MidiaErroMsg = "Could not load: Unsupported executor or corrupted file",
}

pcall(function()
	if str == "en-us" or not Traducao then
		return
	end
	local str6 = str:sub(1, 2)
	local tbl12 = {}
	local tbl13 = {}
	local n4 = 0

	for k, v17 in pairs(Traducao) do
		n4 += 1
		tbl12[n4] = k
		tbl13[n4] = v17
	end

	local str7 = table.concat(tbl13, " || ")

	local ok3, result3 = pcall(function()
		return game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(str7))
	end)

	if ok3 and result3 then
		local data2 = HttpService:JSONDecode(result3)
		local v17 = data2 and data2[1]
		local str8 = ""

		if v17 then
			for _, v18 in ipairs(data2[1]) do
				str8 ..= v18[1] or ""
			end
		end

		local parts = str8:split("||")

		for i = 1, n4 do
			local v18 = parts[i]

			if v18 then
				Traducao[tbl12[i]] = v18:match("^%s*(.-)%s*$")
			end
		end
	end
end)

TraduzirMsg = function(arg)
	local str6 = (str or "en"):sub(1, 2)

	local ok3, result3 = pcall(function()
		local response = game:HttpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=" .. str6 .. "&dt=t&q=" .. HttpService:UrlEncode(arg))
		local data2 = HttpService:JSONDecode(response)

		if data2 and data2[1] then
			if data2[2] == str6 then
				return arg
			end
			local tbl12 = {}

			for _, v17 in ipairs(data2[1]) do
				table.insert(tbl12, v17[1] or "")
			end

			return table.concat(tbl12):match("^%s*(.-)%s*$")
		end

		return arg
	end)

	arg = ok3 and result3 or arg
	return arg
end

local sound = Instance.new("Sound")
sound.Looped = false
sound.Parent = v7

local function fn2(arg)
	sound.SoundId = "rbxassetid://" .. arg
	sound:Play()
end

local function fn3(text2, text3, arg, arg2)
	if type(text2) ~= "string" then
		local v17 = tostring
		text2 = text2 or ""
		text2 = v17(text2)
	end

	if type(text3) ~= "string" then
		local v17 = tostring
		text3 = text3 or ""
		text3 = v17(text3)
	end

	if type(arg) ~= "number" then
		arg = 3
	end

	n2 += 1
	local v17 = n2
	fn2(arg2 ~= nil and type(arg2) == "number" and tostring(arg2) or "129485210015224")
	local notifGui = v4.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("NotifGui")

	if not notifGui then
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "NotifGui"
		notifGui.ResetOnSpawn = false
		notifGui.Parent = v
	end

	if v10 and v10.Parent then
		v10:Destroy()
		v10 = nil
	end

	local imageButton = Instance.new("ImageButton")
	imageButton.Size = UDim2.new(0, 0, 0, 0)
	imageButton.Position = UDim2.new(0.5, 0, 0, 10)
	imageButton.AnchorPoint = Vector2.new(0.5, 0)
	imageButton.BackgroundColor3 = Color3.fromRGB(18, 18, 21)
	imageButton.BackgroundTransparency = 0.08
	imageButton.BorderSizePixel = 0
	imageButton.AutomaticSize = Enum.AutomaticSize.Y
	imageButton.ClipsDescendants = true
	imageButton.Parent = notifGui
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = imageButton
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(178, 34, 34)
	uiStroke.Thickness = 0
	uiStroke.Parent = imageButton
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -10, 0, 25)
	textLabel.Position = UDim2.new(0, 5, 0, 5)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Parent = imageButton
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -10, 0, -2)
	textLabel2.Position = UDim2.new(0, 5, 0, 35)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
	textLabel2.Font = Enum.Font.SourceSans
	textLabel2.Size = UDim2.new(1, -10, 0, 0)
	textLabel2.AutomaticSize = Enum.AutomaticSize.Y
	textLabel2.TextWrapped = true
	textLabel2.TextSize = 20
	textLabel2.Text = ""
	textLabel2.TextXAlignment = Enum.TextXAlignment.Center
	textLabel2.TextYAlignment = Enum.TextYAlignment.Center
	textLabel2.Parent = imageButton
	v10 = imageButton
	local tween4 = v6:Create(imageButton, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = UDim2.new(0.45, 0, 0, 70) })
	imageButton.Size = UDim2.new(0, 0, 0, 70)
	tween4:Play()
	task.wait(0.1)
	uiStroke.Thickness = 2
	textLabel2.Text = text3
	local flag19 = false

	local function fn4()
		if flag19 then
			return
		end
		flag19 = true
		if not imageButton or not imageButton.Parent then
			return
		end
		textLabel.Text = ""
		textLabel2.Text = ""
		local uiStroke2 = imageButton:FindFirstChildOfClass("UIStroke")

		if uiStroke2 then
			uiStroke2:Destroy()
		end

		local tween5 = v6:Create(imageButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, imageButton.Size.Y.Offset) })
		tween5:Play()

		tween5.Completed:Connect(function()
			if not imageButton.Parent then
				return
			end
			local tween6 = v6:Create(imageButton, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
			tween6:Play()

			tween6.Completed:Connect(function()
				if imageButton then
					imageButton:Destroy()
				end

				if v10 == imageButton then
					v10 = nil
				end
			end)
		end)
	end

	imageButton.MouseButton1Click:Connect(fn4)

	task.delay(arg, function()
		if v17 ~= n2 then
			return
		end
		fn4()
	end)
end

for _, v17 in ipairs({
	"writefile",
	"readfile",
	"isfile",
	"delfile",
	"listfiles",
	"makefolder",
	"isfolder",
	"delfolder",
	"getcustomasset",
}) do
	if type(_G[v17] or getgenv()[v17]) ~= "function" then
		fn3(Traducao.Erro, Traducao.Imcompativel, 15)
		Carregar()
		getgenv().YMP = false
		return
	end
end

if not requestAsync then
	fn3(Traducao.Erro, Traducao.Imcompativel, 15)
	Carregar()
	getgenv().YMP = false
	return
end

if not isfolder("YouTube Music Player") then
	makefolder("YouTube Music Player")
end

if not isfolder("YouTube Music Player/Musics") then
	makefolder("YouTube Music Player/Musics")
end

if not isfolder("YouTube Music Player/Videos") then
	makefolder("YouTube Music Player/Videos")
end

if not isfolder("YouTube Music Player/Roblox IDS") then
	makefolder("YouTube Music Player/Roblox IDS")
end

if not isfolder("YouTube Music Player/Local Audios") then
	makefolder("YouTube Music Player/Local Audios")
end

if not isfolder("YouTube Music Player/Internal") then
	makefolder("YouTube Music Player/Internal")
end

if not isfolder("YouTube Music Player/Internal/Cache") then
	makefolder("YouTube Music Player/Internal/Cache")
end

if isfolder("YouTube Music Player/Cache") then
	delfolder("YouTube Music Player/Cache")
end

if not isfile("YouTube Music Player/Internal/Data.json") then
	writefile("YouTube Music Player/Internal/Data.json", "[{\"Key\":\"\",\"Favorites\":[]}]")
end

if not isfile("YouTube Music Player/[ IMPORTANT ] README.txt") then
	writefile("YouTube Music Player/[ IMPORTANT ] README.txt", [[[ YouTube Music Player ]

This script was developed by @Termux_404
I am deeply grateful for using my script! :D

[>] If you want to add audio files without downloading them using the script's search and download engine, place the MP3 file in the folder "Local Audios"
Make sure the file is not corrupted or too large, otherwise the audio will not play.

[ Social media ]

Discord server: https://discord.gg/kbh2dEdnYP

YouTube channel: https://youtube.com/@termux_404

Scriptblox: https://scriptblox.com/u/Termux_404

Have a good game and enjoy!]])
end

if not isfile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt") then
	writefile("YouTube Music Player/Internal/Cache/ABOUT CACHE.txt", [[[YouTube Music Player Cache]

This folder is used to temporarily store images to help things load faster.

All files here will be cleared the first time you execute the script.

You can ignore everything here without any problem! :D]])
end

if isfile("YouTube Music Player/[YMP] README.txt") then
	delfile("YouTube Music Player/[YMP] README.txt")
end

for _, v17 in ipairs(listfiles("YouTube Music Player/Internal/Cache")) do
	if not string.find(v17, "ABOUT CACHE.txt") then
		delfile(v17)
	end
end

if isfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3") then
	delfile("YouTube Music Player/Musics/TAn5b0_j64s.mp3")
end

pcall(function()
	if not isfile("YouTube Music Player/Musics/LvvrO6JifEA.mp3") then
		writefile("YouTube Music Player/Musics/LvvrO6JifEA.mp3", game:HttpGet("https://github.com/Dan41/Roblox-Scripts/raw/refs/heads/main/Youtube%20Music%20Player/Welcome.mp3"))
	end
end)

Corner = function(parent, arg, arg2)
	local uiCorner = Instance.new("UICorner")

	if arg2 == nil then
		uiCorner.CornerRadius = UDim.new(0, arg)
	else
		uiCorner.CornerRadius = UDim.new(arg, arg2)
	end

	uiCorner.Parent = parent
end

Stroke = function(parent, arg, arg2, arg3, thickness, transparency)
	local uiStroke = parent:FindFirstChildOfClass("UIStroke")

	if not uiStroke then
		uiStroke = Instance.new("UIStroke")
		uiStroke.Parent = parent
	end

	uiStroke.Color = Color3.fromRGB(arg, arg2, arg3)
	uiStroke.Thickness = thickness

	if transparency ~= nil then
		uiStroke.Transparency = transparency
	end
end

Draggable = function(arg, arg2)
	if not arg or not arg:IsA("GuiObject") then
		return
	end
	local flag19 = false
	local v17 = nil
	local position = nil
	local position2 = nil
	local n4 = 2
	arg:SetAttribute("Blocked", false)
	arg:SetAttribute("Moved", false)

	local function fn4(arg3)
		local n5 = arg3.Position - position

		if not arg:GetAttribute("Moved") and n5.Magnitude > n4 then
			arg:SetAttribute("Moved", true)
		end

		local n6 = position2.X.Offset + n5.X
		local n7 = position2.Y.Offset + n5.Y

		if arg2 then
			local screenGui3 = arg:FindFirstAncestorWhichIsA("ScreenGui")

			if screenGui3 then
				local absoluteSize = screenGui3.AbsoluteSize
				local absoluteSize2 = arg.AbsoluteSize
				local anchorPoint = arg.AnchorPoint
				local uiStroke = arg:FindFirstChildWhichIsA("UIStroke")
				local enabled = uiStroke and uiStroke.Enabled
				local n8 = 0

				if enabled then
					n8 = uiStroke.Thickness
				end

				local n9 = -position2.Y.Scale * absoluteSize.Y + anchorPoint.Y * absoluteSize2.Y + n8
				local n10 = (1 - position2.Y.Scale) * absoluteSize.Y - (1 - anchorPoint.Y) * absoluteSize2.Y - n8
				n6 = math.clamp(n6, -position2.X.Scale * absoluteSize.X + anchorPoint.X * absoluteSize2.X + n8, (1 - position2.X.Scale) * absoluteSize.X - (1 - anchorPoint.X) * absoluteSize2.X - n8)
				n7 = math.clamp(n7, n9, n10)
			end
		end

		arg.Position = UDim2.new(position2.X.Scale, n6, position2.Y.Scale, n7)
	end

	arg.InputBegan:Connect(function(input)
		if flag19 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag19 = true
			v17 = input
			position = input.Position
			position2 = arg.Position
			arg:SetAttribute("Blocked", true)
			arg:SetAttribute("Moved", false)
			local connection = nil

			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag19 = false
					v17 = nil
					arg:SetAttribute("Blocked", false)
					connection:Disconnect()
				end
			end)
		end
	end)

	arg.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if not v17 then
				v17 = input
			end
		end
	end)

	v9.InputChanged:Connect(function(input)
		if flag19 and input == v17 then
			fn4(input)
		end
	end)
end

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0, 587, 0, 300)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Visible = false
frame.Parent = screenGui
local imageButton = Instance.new("ImageButton")
imageButton.Size = UDim2.new(0, 50, 0, 50)
imageButton.AnchorPoint = Vector2.new(0.5, 0)
imageButton.Position = UDim2.new(0.5, 0, 0, 20)
imageButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
imageButton.Image = "rbxassetid://83758613781843"
imageButton.Visible = false
imageButton.Parent = screenGui
ContadorJA = Instance.new("Frame")
ContadorJA.Size = UDim2.new(0, 17, 0, 17)
ContadorJA.Position = UDim2.new(0, 36, 0, -3)
ContadorJA.BackgroundColor3 = Color3.fromRGB(250, 92, 92)
ContadorJA.Visible = false
ContadorJA.Parent = imageButton
ContadorJANU = Instance.new("TextLabel")
ContadorJANU.Size = UDim2.new(0, 15, 0, 15)
ContadorJANU.Position = UDim2.new(0, 1, 0, 1)
ContadorJANU.BackgroundTransparency = 1
ContadorJANU.Text = "0"
ContadorJANU.TextColor3 = Color3.fromRGB(0, 0, 0)
ContadorJANU.TextScaled = true
ContadorJANU.Parent = ContadorJA
Draggable(imageButton, true)
Draggable(frame)
Mutar = Instance.new("ImageButton")
Mutar.Size = UDim2.new(0, 30, 0, 30)
Mutar.Position = UDim2.new(0, 6, 0, 6)
Mutar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Mutar.Image = "rbxassetid://109518972658686"
Mutar.Parent = frame
BotaoFechar = Instance.new("ImageButton")
BotaoFechar.Size = UDim2.new(0, 30, 0, 30)
BotaoFechar.Position = UDim2.new(1, -36, 0, 6)
BotaoFechar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
BotaoFechar.Parent = frame
X = Instance.new("ImageLabel")
X.AnchorPoint = Vector2.new(0.5, 0.5)
X.Size = UDim2.new(0, 17, 0, 17)
X.Position = UDim2.new(0.5, 0, 0.5, 0)
X.BackgroundTransparency = 1
X.Image = "rbxassetid://119026663645791"
X.Parent = BotaoFechar
Titulo = Instance.new("Frame")
Titulo.Size = UDim2.new(0, 488, 0, 30)
Titulo.Position = UDim2.new(0, 50, 0, 6)
Titulo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Titulo.Parent = frame
TextoTitulo = Instance.new("TextLabel")
TextoTitulo.Size = UDim2.new(1, 0, 1, -4)
TextoTitulo.Position = UDim2.new(0, 0, 0, 2)
TextoTitulo.BackgroundTransparency = 1
TextoTitulo.Text = "YouTube Music Player V8.5"
TextoTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTitulo.TextScaled = true
TextoTitulo.Font = Enum.Font.Highway
TextoTitulo.Parent = Titulo
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Linha.BorderSizePixel = 0
Linha.Parent = frame
Navegacao = Instance.new("Frame")
Navegacao.Size = UDim2.new(0, 160, 1, -61)
Navegacao.Position = UDim2.new(0, 7, 0, 54)
Navegacao.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Navegacao.BorderSizePixel = 0
Navegacao.Visible = true
Navegacao.ClipsDescendants = true
Navegacao.Parent = frame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Navegacao
TituloNave = Instance.new("Frame")
TituloNave.Size = UDim2.new(0, 150, 0, 32)
TituloNave.Position = UDim2.new(0, 5, 0, 5)
TituloNave.BackgroundColor3 = Color3.fromRGB(185, 34, 34)
TituloNave.Parent = Navegacao
FotoNave = Instance.new("ImageLabel")
FotoNave.Size = UDim2.new(0, 32, 0, 32)
FotoNave.Position = UDim2.new(0, 0, 0, 0)
FotoNave.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoNave.BackgroundTransparency = 0.5
FotoNave.Image = "rbxassetid://123533799129853"
FotoNave.Parent = TituloNave
NomeNave = Instance.new("TextLabel")
NomeNave.Size = UDim2.new(0, 102, 1, 0)
NomeNave.Position = UDim2.new(0, 37, 0, 0)
NomeNave.BackgroundTransparency = 1
NomeNave.Text = Traducao.Navegacao
NomeNave.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeNave.Font = Enum.Font.SourceSansBold
NomeNave.TextScaled = true
NomeNave.Parent = TituloNave
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 193)
BaseSF.Position = UDim2.new(0, 1, 0, 45)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Navegacao
ScrollNave = Instance.new("ScrollingFrame")
ScrollNave.Size = UDim2.new(1, 0, 1, 0)
ScrollNave.Position = UDim2.new(0, 0, 0, 0)
ScrollNave.BackgroundTransparency = 1
ScrollNave.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollNave.ScrollBarImageTransparency = 0.5
ScrollNave.BorderSizePixel = 0
ScrollNave.ScrollBarThickness = 1
ScrollNave.CanvasSize = UDim2.new(0, 0, 0, 271)
ScrollNave.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollNave.ClipsDescendants = false
ScrollNave.Parent = BaseSF
Botao1 = Instance.new("ImageButton")
Botao1.Name = "Botao1"
Botao1.Size = UDim2.new(0, 148, 0, 35)
Botao1.Position = UDim2.new(0, 5, 0, 5)
Botao1.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
Botao1.AutoButtonColor = false
Botao1.Parent = ScrollNave
Botao2 = Instance.new("ImageButton")
Botao2.Name = "Botao2"
Botao2.Size = UDim2.new(0, 148, 0, 35)
Botao2.Position = UDim2.new(0, 5, 0, 50)
Botao2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao2.AutoButtonColor = false
Botao2.Parent = ScrollNave
Botao3 = Instance.new("ImageButton")
Botao3.Name = "Botao3"
Botao3.Size = UDim2.new(0, 148, 0, 35)
Botao3.Position = UDim2.new(0, 5, 0, 95)
Botao3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao3.AutoButtonColor = false
Botao3.Parent = ScrollNave
Botao4 = Instance.new("ImageButton")
Botao4.Name = "Botao4"
Botao4.Size = UDim2.new(0, 148, 0, 35)
Botao4.Position = UDim2.new(0, 5, 0, 140)
Botao4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao4.AutoButtonColor = false
Botao4.Parent = ScrollNave
Botao5 = Instance.new("ImageButton")
Botao5.Name = "Botao5"
Botao5.Size = UDim2.new(0, 148, 0, 35)
Botao5.Position = UDim2.new(0, 5, 0, 185)
Botao5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao5.BackgroundTransparency = 0.9
Botao5.AutoButtonColor = false
Botao5.Parent = ScrollNave
Botao6 = Instance.new("ImageButton")
Botao6.Name = "Botao6"
Botao6.Size = UDim2.new(0, 148, 0, 35)
Botao6.Position = UDim2.new(0, 5, 0, 230)
Botao6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Botao6.AutoButtonColor = false
Botao6.Parent = ScrollNave
Icone1 = Instance.new("ImageLabel")
Icone1.Size = UDim2.new(0, 35, 0, 35)
Icone1.Position = UDim2.new(0, 0, 0, 0)
Icone1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone1.Image = "rbxassetid://107770126918811"
Icone1.Parent = Botao1
Icone2 = Instance.new("ImageLabel")
Icone2.Size = UDim2.new(0, 35, 0, 35)
Icone2.Position = UDim2.new(0, 0, 0, 0)
Icone2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone2.Image = "rbxassetid://79505391139157"
Icone2.Parent = Botao2
Icone3 = Instance.new("ImageLabel")
Icone3.Size = UDim2.new(0, 35, 0, 35)
Icone3.Position = UDim2.new(0, 0, 0, 0)
Icone3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone3.Image = "rbxassetid://116645068635461"
Icone3.Parent = Botao3
Icone4 = Instance.new("ImageLabel")
Icone4.Size = UDim2.new(0, 35, 0, 35)
Icone4.Position = UDim2.new(0, 0, 0, 0)
Icone4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone4.Image = "rbxassetid://71048917954785"
Icone4.Parent = Botao4
Icone5 = Instance.new("ImageLabel")
Icone5.Size = UDim2.new(0, 35, 0, 35)
Icone5.Position = UDim2.new(0, 0, 0, 0)
Icone5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone5.BackgroundTransparency = 0.9
Icone5.Image = "rbxassetid://140320771062475"
Icone5.ImageTransparency = 0.9
Icone5.Parent = Botao5
Icone6 = Instance.new("ImageLabel")
Icone6.Size = UDim2.new(0, 35, 0, 35)
Icone6.Position = UDim2.new(0, 0, 0, 0)
Icone6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Icone6.Image = "rbxassetid://75536888881661"
Icone6.Parent = Botao6
Nome1 = Instance.new("TextLabel")
Nome1.Size = UDim2.new(0, 103, 1, 0)
Nome1.Position = UDim2.new(0, 41, 0, 0)
Nome1.BackgroundTransparency = 1
Nome1.Text = "Home"
Nome1.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome1.Font = Enum.Font.SourceSansBold
Nome1.TextScaled = true
Nome1.Parent = Botao1
Nome2 = Instance.new("TextLabel")
Nome2.Size = UDim2.new(0, 103, 1, 0)
Nome2.Position = UDim2.new(0, 41, 0, 0)
Nome2.BackgroundTransparency = 1
Nome2.Text = Traducao.Player
Nome2.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome2.Font = Enum.Font.SourceSansBold
Nome2.TextScaled = true
Nome2.Parent = Botao2
Nome3 = Instance.new("TextLabel")
Nome3.Size = UDim2.new(0, 103, 1, 0)
Nome3.Position = UDim2.new(0, 41, 0, 0)
Nome3.BackgroundTransparency = 1
Nome3.Text = Traducao.Equalizador
Nome3.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome3.Font = Enum.Font.SourceSansBold
Nome3.TextScaled = true
Nome3.Parent = Botao3
Nome4 = Instance.new("TextLabel")
Nome4.Size = UDim2.new(0, 103, 1, 0)
Nome4.Position = UDim2.new(0, 41, 0, 0)
Nome4.BackgroundTransparency = 1
Nome4.Text = Traducao.Add
Nome4.TextColor3 = Color3.fromRGB(255, 255, 255)
Nome4.Font = Enum.Font.SourceSansBold
Nome4.TextScaled = true
Nome4.Parent = Botao4
Nome5 = Instance.new("TextLabel")
Nome5.Size = UDim2.new(0, 103, 1, 0)
Nome5.Position = UDim2.new(0, 41, 0, 0)
Nome5.BackgroundTransparency = 1
Nome5.Text = "Global Chat"
Nome5.TextColor3 = Color3.fromRGB(20, 20, 20)
Nome5.Font = Enum.Font.SourceSansBold
Nome5.TextScaled = true
Nome5.Parent = Botao5
Nome6 = Instance.new("TextLabel")
Nome6.Size = UDim2.new(0, 103, 1, 0)
Nome6.Position = UDim2.new(0, 41, 0, 0)
Nome6.BackgroundTransparency = 1
Nome6.Text = "Premium"
Nome6.TextColor3 = Color3.fromRGB(255, 255, 153)
Nome6.Font = Enum.Font.SourceSansBold
Nome6.TextScaled = true
Nome6.Parent = Botao6
ContadorJABO = Instance.new("Frame")
ContadorJABO.Size = UDim2.new(0, 15, 0, 15)
ContadorJABO.Position = UDim2.new(0, 0, 0, -3)
ContadorJABO.BackgroundColor3 = Color3.fromRGB(250, 92, 92)
ContadorJABO.Visible = false
ContadorJABO.Parent = Icone5
ContadorJANUBO = Instance.new("TextLabel")
ContadorJANUBO.Size = UDim2.new(0, 15, 0, 15)
ContadorJANUBO.Position = UDim2.new(0, 0, 0, 0)
ContadorJANUBO.BackgroundTransparency = 1
ContadorJANUBO.Text = "0"
ContadorJANUBO.TextColor3 = Color3.fromRGB(0, 0, 0)
ContadorJANUBO.TextScaled = true
ContadorJANUBO.Parent = ContadorJABO
Playlist = Instance.new("Frame")
Playlist.Size = UDim2.new(0, 160, 1, -61)
Playlist.Position = UDim2.new(0, 420, 0, 54)
Playlist.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Playlist.BorderSizePixel = 0
Playlist.Parent = frame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Playlist
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 195)
Linha2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha2.BorderSizePixel = 0
Linha2.Parent = Playlist
TituloPlayL = Instance.new("Frame")
TituloPlayL.Size = UDim2.new(0, 150, 0, 32)
TituloPlayL.Position = UDim2.new(0, 5, 0, 5)
TituloPlayL.BackgroundColor3 = Color3.fromRGB(185, 34, 34)
TituloPlayL.Parent = Playlist
FotoPlayL = Instance.new("ImageLabel")
FotoPlayL.Size = UDim2.new(0, 32, 0, 32)
FotoPlayL.Position = UDim2.new(0, 0, 0, 0)
FotoPlayL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoPlayL.BackgroundTransparency = 0.5
FotoPlayL.Image = "rbxassetid://96966806844504"
FotoPlayL.Parent = TituloPlayL
NomePlayL = Instance.new("TextLabel")
NomePlayL.Size = UDim2.new(0, 102, 1, 0)
NomePlayL.Position = UDim2.new(0, 37, 0, 0)
NomePlayL.BackgroundTransparency = 1
NomePlayL.Text = "Playlist"
NomePlayL.TextColor3 = Color3.fromRGB(255, 0, 0)
NomePlayL.Font = Enum.Font.SourceSansBold
NomePlayL.TextScaled = true
NomePlayL.Parent = TituloPlayL
EsquerdaPL = Instance.new("ImageButton")
EsquerdaPL.Size = UDim2.new(0, 32, 0, 32)
EsquerdaPL.Position = UDim2.new(0, 6, 0, 202)
EsquerdaPL.BackgroundColor3 = Color3.fromRGB(237, 76, 66)
EsquerdaPL.Image = "rbxassetid://121046797518772"
EsquerdaPL.Parent = Playlist
DireitaPL = Instance.new("ImageButton")
DireitaPL.Size = UDim2.new(0, 32, 0, 32)
DireitaPL.Position = UDim2.new(0, 122, 0, 202)
DireitaPL.BackgroundColor3 = Color3.fromRGB(237, 76, 66)
DireitaPL.Image = "rbxassetid://132437763424488"
DireitaPL.Parent = Playlist
Vazio = Instance.new("ImageLabel")
Vazio.Size = UDim2.new(0, 70, 0, 70)
Vazio.Position = UDim2.new(0, 45, 0, 63)
Vazio.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Vazio.BackgroundTransparency = 1
Vazio.Image = "rbxassetid://123712679435265"
Vazio.Visible = false
Vazio.Parent = Playlist
VazioLocal = Instance.new("ImageLabel")
VazioLocal.Size = UDim2.new(0, 70, 0, 70)
VazioLocal.Position = UDim2.new(0, 45, 0, 63)
VazioLocal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VazioLocal.BackgroundTransparency = 1
VazioLocal.Image = "rbxassetid://103453753684654"
VazioLocal.Visible = false
VazioLocal.Parent = Playlist
AguardandoPL = Instance.new("ImageLabel")
AguardandoPL.Size = UDim2.new(0, 70, 0, 70)
AguardandoPL.Position = UDim2.new(0, 45, 0, 63)
AguardandoPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AguardandoPL.BackgroundTransparency = 1
AguardandoPL.Image = "rbxassetid://128559285276409"
AguardandoPL.Visible = false
AguardandoPL.Parent = Playlist
SemResultadoPL = Instance.new("ImageLabel")
SemResultadoPL.Size = UDim2.new(0, 70, 0, 70)
SemResultadoPL.Position = UDim2.new(0, 45, 0, 63)
SemResultadoPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SemResultadoPL.BackgroundTransparency = 1
SemResultadoPL.Image = "rbxassetid://109542040841239"
SemResultadoPL.Visible = false
SemResultadoPL.Parent = Playlist
ErroPL = Instance.new("TextLabel")
ErroPL.Size = UDim2.new(0, 150, 0, 42)
ErroPL.Position = UDim2.new(0, 5, 0, 149)
ErroPL.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ErroPL.BackgroundTransparency = 0.5
ErroPL.RichText = true
ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
ErroPL.Font = Enum.Font.SourceSansBold
ErroPL.TextScaled = true
ErroPL.Visible = false
ErroPL.Parent = Playlist
FrameAbaPL = Instance.new("Frame")
FrameAbaPL.Size = UDim2.new(0, 70, 0, 32)
FrameAbaPL.Position = UDim2.new(0, 45, 0, 202)
FrameAbaPL.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FrameAbaPL.BackgroundTransparency = 0.5
FrameAbaPL.Parent = Playlist
AbaPL = Instance.new("TextLabel")
AbaPL.Size = UDim2.new(1, -6, 1, -6)
AbaPL.Position = UDim2.new(0, 3, 0, 3)
AbaPL.BackgroundTransparency = 1
AbaPL.Text = Traducao.Todos
AbaPL.TextColor3 = Color3.fromRGB(255, 0, 0)
AbaPL.Font = Enum.Font.SourceSansBold
AbaPL.TextScaled = true
AbaPL.Visible = true
AbaPL.Parent = FrameAbaPL
PesquisaPL = Instance.new("TextBox")
PesquisaPL.Size = UDim2.new(1, -6, 1, -6)
PesquisaPL.Position = UDim2.new(0, 3, 0, 3)
PesquisaPL.BackgroundTransparency = 1
PesquisaPL.Text = ""
PesquisaPL.PlaceholderText = Traducao.Search
PesquisaPL.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisaPL.Font = Enum.Font.SourceSansBold
PesquisaPL.TextScaled = true
PesquisaPL.TextWrapped = true
PesquisaPL.Visible = false
PesquisaPL.Parent = FrameAbaPL
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(0, 158, 0, 149)
BaseSF.Position = UDim2.new(0, 1, 0, 45)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = Playlist
ScrollTodos = Instance.new("ScrollingFrame")
ScrollTodos.Name = "ScrollTodos"
ScrollTodos.Size = UDim2.new(1, 0, 1, 0)
ScrollTodos.Position = UDim2.new(0, 0, 0, 0)
ScrollTodos.BackgroundTransparency = 1
ScrollTodos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollTodos.ScrollBarImageTransparency = 0.5
ScrollTodos.BorderSizePixel = 0
ScrollTodos.ScrollBarThickness = 1
ScrollTodos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollTodos.CanvasPosition = Vector2.new(0, 0)
ScrollTodos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollTodos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollTodos.Visible = true
ScrollTodos.Parent = BaseSF
ScrollMusicas = Instance.new("ScrollingFrame")
ScrollMusicas.Name = "ScrollMusicas"
ScrollMusicas.Size = UDim2.new(1, 0, 1, 0)
ScrollMusicas.Position = UDim2.new(0, 0, 0, 0)
ScrollMusicas.BackgroundTransparency = 1
ScrollMusicas.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollMusicas.ScrollBarImageTransparency = 0.5
ScrollMusicas.BorderSizePixel = 0
ScrollMusicas.ScrollBarThickness = 1
ScrollMusicas.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollMusicas.CanvasPosition = Vector2.new(0, 0)
ScrollMusicas.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollMusicas.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollMusicas.Visible = false
ScrollMusicas.Parent = BaseSF
ScrollVideos = Instance.new("ScrollingFrame")
ScrollVideos.Name = "ScrollVideos"
ScrollVideos.Size = UDim2.new(1, 0, 1, 0)
ScrollVideos.Position = UDim2.new(0, 0, 0, 0)
ScrollVideos.BackgroundTransparency = 1
ScrollVideos.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollVideos.ScrollBarImageTransparency = 0.5
ScrollVideos.BorderSizePixel = 0
ScrollVideos.ScrollBarThickness = 1
ScrollVideos.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollVideos.CanvasPosition = Vector2.new(0, 0)
ScrollVideos.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollVideos.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollVideos.Visible = false
ScrollVideos.Parent = BaseSF
ScrollRoblox = Instance.new("ScrollingFrame")
ScrollRoblox.Name = "ScrollRoblox"
ScrollRoblox.Size = UDim2.new(1, 0, 1, 0)
ScrollRoblox.Position = UDim2.new(0, 0, 0, 0)
ScrollRoblox.BackgroundTransparency = 1
ScrollRoblox.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollRoblox.ScrollBarImageTransparency = 0.5
ScrollRoblox.BorderSizePixel = 0
ScrollRoblox.ScrollBarThickness = 1
ScrollRoblox.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollRoblox.CanvasPosition = Vector2.new(0, 0)
ScrollRoblox.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollRoblox.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollRoblox.Visible = false
ScrollRoblox.Parent = BaseSF
ScrollFav = Instance.new("ScrollingFrame")
ScrollFav.Name = "ScrollFav"
ScrollFav.Size = UDim2.new(1, 0, 1, 0)
ScrollFav.Position = UDim2.new(0, 0, 0, 0)
ScrollFav.BackgroundTransparency = 1
ScrollFav.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFav.ScrollBarImageTransparency = 0.5
ScrollFav.BorderSizePixel = 0
ScrollFav.ScrollBarThickness = 1
ScrollFav.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollFav.CanvasPosition = Vector2.new(0, 0)
ScrollFav.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollFav.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollFav.Visible = false
ScrollFav.Parent = BaseSF
ScrollLocal = Instance.new("ScrollingFrame")
ScrollLocal.Name = "ScrollLocal"
ScrollLocal.Size = UDim2.new(1, 0, 1, 0)
ScrollLocal.Position = UDim2.new(0, 0, 0, 0)
ScrollLocal.BackgroundTransparency = 1
ScrollLocal.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollLocal.ScrollBarImageTransparency = 0.5
ScrollLocal.BorderSizePixel = 0
ScrollLocal.ScrollBarThickness = 1
ScrollLocal.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollLocal.CanvasPosition = Vector2.new(0, 0)
ScrollLocal.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollLocal.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollLocal.Visible = false
ScrollLocal.Parent = BaseSF
ScrollPesquisa = Instance.new("ScrollingFrame")
ScrollPesquisa.Name = "ScrollPesquisa"
ScrollPesquisa.Size = UDim2.new(1, 0, 1, 0)
ScrollPesquisa.Position = UDim2.new(0, 0, 0, 0)
ScrollPesquisa.BackgroundTransparency = 1
ScrollPesquisa.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPesquisa.ScrollBarImageTransparency = 0.5
ScrollPesquisa.BorderSizePixel = 0
ScrollPesquisa.ScrollBarThickness = 1
ScrollPesquisa.CanvasSize = UDim2.new(0, 243, 0, 0)
ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
ScrollPesquisa.ElasticBehavior = Enum.ElasticBehavior.Never
ScrollPesquisa.ScrollingDirection = Enum.ScrollingDirection.XY
ScrollPesquisa.Visible = false
ScrollPesquisa.Parent = BaseSF
Tela1 = Instance.new("Frame")
Tela1.Size = UDim2.new(0, 247, 0, 251)
Tela1.Position = UDim2.new(0, 170, 0, 48)
Tela1.BackgroundTransparency = 1
Tela1.BorderSizePixel = 0
Tela1.Visible = true
Tela1.Parent = frame
Tela2 = Instance.new("Frame")
Tela2.Size = UDim2.new(0, 247, 0, 251)
Tela2.Position = UDim2.new(0, 170, 0, 48)
Tela2.BackgroundTransparency = 1
Tela2.BorderSizePixel = 0
Tela2.Visible = false
Tela2.Parent = frame
Tela3 = Instance.new("Frame")
Tela3.Size = UDim2.new(0, 247, 0, 251)
Tela3.Position = UDim2.new(0, 170, 0, 48)
Tela3.BackgroundTransparency = 1
Tela3.BorderSizePixel = 0
Tela3.Visible = false
Tela3.Parent = frame
Tela4 = Instance.new("Frame")
Tela4.Size = UDim2.new(0, 247, 0, 251)
Tela4.Position = UDim2.new(0, 170, 0, 48)
Tela4.BackgroundTransparency = 1
Tela4.BorderSizePixel = 0
Tela4.Visible = false
Tela4.Parent = frame
Tela5 = Instance.new("Frame")
Tela5.Size = UDim2.new(0, 247, 0, 251)
Tela5.Position = UDim2.new(0, 170, 0, 48)
Tela5.BackgroundTransparency = 1
Tela5.BorderSizePixel = 0
Tela5.Visible = false
Tela5.Parent = frame
Tela6 = Instance.new("Frame")
Tela6.Size = UDim2.new(0, 247, 0, 251)
Tela6.Position = UDim2.new(0, 170, 0, 48)
Tela6.BackgroundTransparency = 1
Tela6.BorderSizePixel = 0
Tela6.Visible = false
Tela6.Parent = frame
Welcome = Instance.new("Frame")
Welcome.Size = UDim2.new(0, 235, 0, 43)
Welcome.Position = UDim2.new(0, 6, 0, 6)
Welcome.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Welcome.BorderSizePixel = 0
Welcome.Parent = Tela1
NomeWelcome = Instance.new("TextLabel")
NomeWelcome.Size = UDim2.new(1, 0, 1, 0)
NomeWelcome.Position = UDim2.new(0, 0, 0, 0)
NomeWelcome.BackgroundTransparency = 1
NomeWelcome.Text = Traducao.Welcome
NomeWelcome.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeWelcome.Font = Enum.Font.SourceSansBold
NomeWelcome.TextScaled = true
NomeWelcome.Parent = Welcome
Dev = Instance.new("Frame")
Dev.Size = UDim2.new(0, 235, 0, 61)
Dev.Position = UDim2.new(0, 6, 0, 58)
Dev.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Dev.BorderSizePixel = 0
Dev.Parent = Tela1
FotoDev = Instance.new("ImageLabel")
FotoDev.Size = UDim2.new(0, 47, 0, 46)
FotoDev.Position = UDim2.new(0, 7, 0, 8)
FotoDev.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FotoDev.BackgroundTransparency = 0.5
FotoDev.Image = "rbxassetid://86887253295141"
FotoDev.Parent = Dev
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 62, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Dev
TextoDev = Instance.new("TextLabel")
TextoDev.Size = UDim2.new(1, -70, 1, 0)
TextoDev.Position = UDim2.new(0, 66, 0, 0)
TextoDev.BackgroundTransparency = 1
TextoDev.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoDev.Font = Enum.Font.SourceSansBold
TextoDev.TextScaled = true
TextoDev.RichText = true
TextoDev.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Dev .. "</font>\n<font color=\"rgb(178,34,34)\">Termux_404</font>"
TextoDev.Parent = Dev
Social = Instance.new("Frame")
Social.Size = UDim2.new(0, 235, 0, 117)
Social.Position = UDim2.new(0, 6, 0, 128)
Social.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Social.BorderSizePixel = 0
Social.Parent = Tela1
SocialTitulo = Instance.new("Frame")
SocialTitulo.Size = UDim2.new(1, 0, 0, 30)
SocialTitulo.Position = UDim2.new(0, 0, 0, 0)
SocialTitulo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
SocialTitulo.BorderSizePixel = 0
SocialTitulo.Parent = Social
SocialTexto = Instance.new("TextLabel")
SocialTexto.Size = UDim2.new(1, 0, 1, 0)
SocialTexto.Position = UDim2.new(0, 0, 0, 0)
SocialTexto.BackgroundTransparency = 1
SocialTexto.Text = "Social"
SocialTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
SocialTexto.Font = Enum.Font.SourceSansBold
SocialTexto.TextScaled = true
SocialTexto.Parent = SocialTitulo
Discord = Instance.new("ImageButton")
Discord.Size = UDim2.new(0, 223, 0, 32)
Discord.Position = UDim2.new(0, 6, 0, 40)
Discord.BackgroundColor3 = Color3.fromRGB(143, 42, 234)
Discord.Parent = Social
UIScaleDis = Instance.new("UIScale")
UIScaleDis.Parent = Discord
IconeDiscord = Instance.new("ImageLabel")
IconeDiscord.Size = UDim2.new(0, 32, 0, 32)
IconeDiscord.Position = UDim2.new(0, 0, 0, 0)
IconeDiscord.BackgroundColor3 = Color3.fromRGB(40, 100, 240)
IconeDiscord.Image = "rbxassetid://90602349315916"
IconeDiscord.Parent = Discord
TextoDiscord = Instance.new("TextLabel")
TextoDiscord.Size = UDim2.new(1, -50, 1, 0)
TextoDiscord.Position = UDim2.new(0, 39, 0, 0)
TextoDiscord.BackgroundTransparency = 1
TextoDiscord.Text = "Discord"
TextoDiscord.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoDiscord.Font = Enum.Font.Garamond
TextoDiscord.TextScaled = true
TextoDiscord.Parent = Discord
You = Instance.new("ImageButton")
You.Size = UDim2.new(0, 223, 0, 32)
You.Position = UDim2.new(0, 6, 0, 79)
You.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
You.Parent = Social
UIScaleYou = Instance.new("UIScale")
UIScaleYou.Parent = You
IconeYou = Instance.new("ImageLabel")
IconeYou.Size = UDim2.new(0, 32, 0, 32)
IconeYou.Position = UDim2.new(0, 0, 0, 0)
IconeYou.BackgroundColor3 = Color3.fromRGB(40, 100, 240)
IconeYou.Image = "rbxassetid://111196037573101"
IconeYou.Parent = You
TextoYou = Instance.new("TextLabel")
TextoYou.Size = UDim2.new(1, -50, 1, 0)
TextoYou.Position = UDim2.new(0, 39, 0, 0)
TextoYou.BackgroundTransparency = 1
TextoYou.Text = "YouTube"
TextoYou.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoYou.Font = Enum.Font.Garamond
TextoYou.TextScaled = true
TextoYou.Parent = You
Musica = Instance.new("ImageLabel")
Musica.Size = UDim2.new(0, 235, 0, 120)
Musica.Position = UDim2.new(0, 6, 0, 6)
Musica.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Musica.BorderSizePixel = 0
Musica.Visible = true
Musica.ImageRectOffset = Vector2.new(0, 0)
Musica.ImageRectSize = Vector2.new(0, 0)
Musica.Image = "rbxassetid://120329190202259"
Musica.Parent = Tela2
Video = Instance.new("VideoFrame")
Video.Size = UDim2.new(0, 235, 0, 120)
Video.Position = UDim2.new(0, 6, 0, 6)
Video.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Video.BorderSizePixel = 0
Video.Visible = false
Video.Video = ""
Video.Volume = 1
Video.Looped = false
Video.Parent = nil
BotaoTela = Instance.new("ImageButton")
BotaoTela.Size = UDim2.new(0, 235, 0, 120)
BotaoTela.Position = UDim2.new(0, 6, 0, 6)
BotaoTela.BackgroundTransparency = 1
BotaoTela.ClipsDescendants = true
BotaoTela.Visible = true
BotaoTela.ZIndex = 2
BotaoTela.Parent = Tela2
TempoAtual = Instance.new("Frame")
TempoAtual.Size = UDim2.new(0, 55, 0, 20)
TempoAtual.Position = UDim2.new(0, 6, 0, 6)
TempoAtual.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TempoAtual.BackgroundTransparency = 0.5
TempoAtual.ZIndex = 2
TempoAtual.Parent = BotaoTela
TempoTotal = Instance.new("Frame")
TempoTotal.Size = UDim2.new(0, 55, 0, 20)
TempoTotal.Position = UDim2.new(0, 174, 0, 6)
TempoTotal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TempoTotal.BackgroundTransparency = 0.5
TempoTotal.ZIndex = 2
TempoTotal.Parent = BotaoTela
TimerAtual = Instance.new("TextLabel")
TimerAtual.Size = UDim2.new(1, 0, 1, 0)
TimerAtual.Position = UDim2.new(0, 0, 0, 0)
TimerAtual.BackgroundTransparency = 1
TimerAtual.Text = "00:00"
TimerAtual.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerAtual.TextScaled = true
TimerAtual.Font = Enum.Font.SourceSansBold
TimerAtual.ZIndex = 2
TimerAtual.Parent = TempoAtual
TimerTotal = Instance.new("TextLabel")
TimerTotal.Size = UDim2.new(1, 0, 1, 0)
TimerTotal.Position = UDim2.new(0, 0, 0, 0)
TimerTotal.BackgroundTransparency = 1
TimerTotal.Text = "00:00"
TimerTotal.TextColor3 = Color3.fromRGB(255, 255, 255)
TimerTotal.TextScaled = true
TimerTotal.Font = Enum.Font.SourceSansBold
TimerTotal.ZIndex = 2
TimerTotal.Parent = TempoTotal
Repetir = Instance.new("ImageButton")
Repetir.Size = UDim2.new(0, 30, 0, 30)
Repetir.Position = UDim2.new(0.5, -35, 0.5, -54)
Repetir.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Repetir.BackgroundTransparency = 0.5
Repetir.BorderSizePixel = 0
Repetir.Image = "rbxassetid://72571947341676"
Repetir.ZIndex = 2
Repetir.Parent = BotaoTela
Miniplayer = Instance.new("ImageButton")
Miniplayer.Size = UDim2.new(0, 30, 0, 30)
Miniplayer.Position = UDim2.new(0.5, 5, 0.5, -54)
Miniplayer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Miniplayer.BackgroundTransparency = 0.5
Miniplayer.BorderSizePixel = 0
Miniplayer.Image = "rbxassetid://102723588572082"
Miniplayer.ZIndex = 2
Miniplayer.Parent = BotaoTela
BarraProgresso = Instance.new("ImageButton")
BarraProgresso.Size = UDim2.new(0, 223, 0, 10)
BarraProgresso.Position = UDim2.new(0, 6, 0, 103)
BarraProgresso.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
BarraProgresso.BorderSizePixel = 0
BarraProgresso.AutoButtonColor = false
BarraProgresso.ZIndex = 2
BarraProgresso.Parent = BotaoTela
Rastro = Instance.new("Frame")
Rastro.Size = UDim2.new(0, 0, 1, 0)
Rastro.Position = UDim2.new(0, 0, 0, 0)
Rastro.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Rastro.BorderSizePixel = 0
Rastro.ZIndex = 2
Rastro.Parent = BarraProgresso
BolaProgresso = Instance.new("ImageButton")
BolaProgresso.Size = UDim2.new(0, 16, 0, 16)
BolaProgresso.Position = UDim2.new(0, 0, 0, -3)
BolaProgresso.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
BolaProgresso.BorderSizePixel = 0
BolaProgresso.AnchorPoint = Vector2.new(0, 0)
BolaProgresso.ZIndex = 2
BolaProgresso.Parent = BarraProgresso
MicroBola = Instance.new("Frame")
MicroBola.Size = UDim2.new(0, 6, 0, 6)
MicroBola.Position = UDim2.new(0, 5, 0, 5)
MicroBola.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MicroBola.BorderSizePixel = 0
MicroBola.ZIndex = 2
MicroBola.Parent = BolaProgresso
PlayerInfo = Instance.new("VideoFrame")
PlayerInfo.Size = UDim2.new(0, 235, 0, 61)
PlayerInfo.Position = UDim2.new(0, 6, 0, 135)
PlayerInfo.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PlayerInfo.BorderSizePixel = 0
PlayerInfo.Parent = Tela2
FotoAutor = Instance.new("ImageLabel")
FotoAutor.Size = UDim2.new(0, 50, 0, 49)
FotoAutor.Position = UDim2.new(0, 6, 0, 6)
FotoAutor.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
FotoAutor.BorderSizePixel = 0
FotoAutor.Visible = true
FotoAutor.Image = "rbxassetid://130243480255582"
FotoAutor.Parent = PlayerInfo
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 63, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = PlayerInfo
Linhah = Instance.new("Frame")
Linhah.Size = UDim2.new(0, 2, 1, 0)
Linhah.Position = UDim2.new(0, 170, 0, 0)
Linhah.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linhah.BorderSizePixel = 0
Linhah.Parent = PlayerInfo
TituloMusica = Instance.new("TextLabel")
TituloMusica.Size = UDim2.new(1, -140, 1, -8)
TituloMusica.Position = UDim2.new(0, 70, 0, 4)
TituloMusica.BackgroundTransparency = 1
TituloMusica.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloMusica.Font = Enum.Font.SourceSansBold
TituloMusica.TextScaled = true
TituloMusica.RichText = true
TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
TituloMusica.Parent = PlayerInfo
Disco = Instance.new("ImageLabel")
Disco.Size = UDim2.new(0, 50, 0, 49)
Disco.Position = UDim2.new(0, 179, 0, 6)
Disco.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Disco.BorderSizePixel = 0
Disco.Visible = true
Disco.Image = "rbxassetid://76801681748723"
Disco.ClipsDescendants = true
Disco.Parent = PlayerInfo
Controles = Instance.new("Frame")
Controles.Size = UDim2.new(0, 235, 0, 40)
Controles.Position = UDim2.new(0, 6, 0, 205)
Controles.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Controles.BorderSizePixel = 0
Controles.Parent = Tela2
Voltar = Instance.new("ImageButton")
Voltar.Size = UDim2.new(0, 30, 0, 30)
Voltar.Position = UDim2.new(0, 10, 0.5, -15)
Voltar.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Voltar.BorderSizePixel = 0
Voltar.Image = "rbxassetid://88757150664292"
Voltar.Parent = Controles
Retroceder = Instance.new("ImageButton")
Retroceder.Size = UDim2.new(0, 30, 0, 30)
Retroceder.Position = UDim2.new(0, 55, 0.5, -15)
Retroceder.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Retroceder.BorderSizePixel = 0
Retroceder.Image = "rbxassetid://122950454234379"
Retroceder.Parent = Controles
Play = Instance.new("ImageButton")
Play.Size = UDim2.new(0, 30, 0, 30)
Play.Position = UDim2.new(0.5, -15, 0.5, -15)
Play.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Play.BorderSizePixel = 0
Play.Image = "rbxassetid://110560238983134"
Play.Parent = Controles
Adiantar = Instance.new("ImageButton")
Adiantar.Size = UDim2.new(0, 30, 0, 30)
Adiantar.Position = UDim2.new(1, -85, 0.5, -15)
Adiantar.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Adiantar.BorderSizePixel = 0
Adiantar.Image = "rbxassetid://102857578902137"
Adiantar.Parent = Controles
Pular = Instance.new("ImageButton")
Pular.Size = UDim2.new(0, 30, 0, 30)
Pular.Position = UDim2.new(1, -40, 0.5, -15)
Pular.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Pular.BorderSizePixel = 0
Pular.Image = "rbxassetid://82401540450034"
Pular.Parent = Controles
local imageButton2 = Instance.new("ImageButton")
imageButton2.Size = UDim2.new(0.27, 0, 0.37, 0)
imageButton2.AnchorPoint = Vector2.new(1, 1)
imageButton2.Position = UDim2.new(1, -20, 1, -20)
imageButton2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
imageButton2.BorderSizePixel = 0
imageButton2.BackgroundTransparency = 1
imageButton2.AutoButtonColor = false
imageButton2.Active = true
imageButton2.Visible = false
imageButton2.ZIndex = 3
imageButton2.Parent = nil
Draggable(imageButton2, true)
MiniMusica = Instance.new("ImageLabel")
MiniMusica.Size = UDim2.new(1, 0, 1, 0)
MiniMusica.Position = UDim2.new(0, 0, 0, 0)
MiniMusica.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniMusica.BorderSizePixel = 0
MiniMusica.Visible = true
MiniMusica.ImageRectOffset = Vector2.new(0, 0)
MiniMusica.ImageRectSize = Vector2.new(0, 0)
MiniMusica.Image = "rbxassetid://120329190202259"
MiniMusica.ZIndex = 3
MiniMusica.Parent = imageButton2
MiniVideo = Instance.new("VideoFrame")
MiniVideo.Size = UDim2.new(1, 0, 1, 0)
MiniVideo.Position = UDim2.new(0, 0, 0, 0)
MiniVideo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniVideo.BorderSizePixel = 0
MiniVideo.Visible = false
MiniVideo.Video = ""
MiniVideo.Volume = 1
MiniVideo.Looped = false
MiniVideo.ZIndex = 3
MiniVideo.Parent = imageButton2
MiniBack = Instance.new("ImageButton")
MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniBack.AnchorPoint = Vector2.new(0.5, 1)
MiniBack.Position = UDim2.new(0.105, 0, 0.94, 0)
MiniBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniBack.BackgroundTransparency = 0.5
MiniBack.Image = "rbxassetid://122582556337724"
MiniBack.Visible = false
MiniBack.ZIndex = 3
MiniBack.Parent = imageButton2
MiniRetroceder = Instance.new("ImageButton")
MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniRetroceder.AnchorPoint = Vector2.new(0.5, 1)
MiniRetroceder.Position = UDim2.new(0.3025, 0, 0.94, 0)
MiniRetroceder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniRetroceder.BackgroundTransparency = 0.5
MiniRetroceder.Image = "rbxassetid://95993997488260"
MiniRetroceder.Visible = false
MiniRetroceder.ZIndex = 3
MiniRetroceder.Parent = imageButton2
MiniPlay = Instance.new("ImageButton")
MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniPlay.AnchorPoint = Vector2.new(0.5, 1)
MiniPlay.Position = UDim2.new(0.5, 0, 0.94, 0)
MiniPlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniPlay.BackgroundTransparency = 0.5
MiniPlay.Image = "rbxassetid://119936293795425"
MiniPlay.Visible = false
MiniPlay.ZIndex = 3
MiniPlay.Parent = imageButton2
MiniAvancar = Instance.new("ImageButton")
MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniAvancar.AnchorPoint = Vector2.new(0.5, 1)
MiniAvancar.Position = UDim2.new(0.6975, 0, 0.94, 0)
MiniAvancar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniAvancar.BackgroundTransparency = 0.5
MiniAvancar.Image = "rbxassetid://95582496868769"
MiniAvancar.Visible = false
MiniAvancar.ZIndex = 3
MiniAvancar.Parent = imageButton2
MiniSkip = Instance.new("ImageButton")
MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
MiniSkip.AnchorPoint = Vector2.new(0.5, 1)
MiniSkip.Position = UDim2.new(0.895, 0, 0.94, 0)
MiniSkip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MiniSkip.BackgroundTransparency = 0.5
MiniSkip.Image = "rbxassetid://101914600863480"
MiniSkip.Visible = false
MiniSkip.ZIndex = 3
MiniSkip.Parent = imageButton2
TelaCheia = Instance.new("ImageButton")
TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
TelaCheia.AnchorPoint = Vector2.new(0.5, 0)
TelaCheia.Position = UDim2.new(0.105, 0, 0.03, 0)
TelaCheia.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TelaCheia.BackgroundTransparency = 0.5
TelaCheia.Image = "rbxassetid://73952228795506"
TelaCheia.Visible = false
TelaCheia.ZIndex = 3
TelaCheia.Parent = imageButton2
FecharMini = Instance.new("ImageButton")
FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
FecharMini.AnchorPoint = Vector2.new(0.5, 0)
FecharMini.Position = UDim2.new(0.895, 0, 0.03, 0)
FecharMini.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FecharMini.BackgroundTransparency = 0.5
FecharMini.Image = "rbxassetid://71780293592221"
FecharMini.Visible = false
FecharMini.ZIndex = 3
FecharMini.Parent = imageButton2
TituloEqua = Instance.new("Frame")
TituloEqua.Size = UDim2.new(0, 235, 0, 43)
TituloEqua.Position = UDim2.new(0, 6, 0, 6)
TituloEqua.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloEqua.BorderSizePixel = 0
TituloEqua.Parent = Tela3
NomeEqua = Instance.new("TextLabel")
NomeEqua.Size = UDim2.new(1, 0, 1, 0)
NomeEqua.Position = UDim2.new(0, 0, 0, 0)
NomeEqua.BackgroundTransparency = 1
NomeEqua.Text = Traducao.Equalizador
NomeEqua.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeEqua.Font = Enum.Font.SourceSansBold
NomeEqua.TextScaled = true
NomeEqua.Parent = TituloEqua
EquaFrame = Instance.new("Frame")
EquaFrame.Size = UDim2.new(0, 235, 0, 187)
EquaFrame.Position = UDim2.new(0, 6, 0, 58)
EquaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
EquaFrame.BorderSizePixel = 0
EquaFrame.Parent = Tela3
NoEquaFrame = Instance.new("Frame")
NoEquaFrame.Size = UDim2.new(0, 235, 0, 129)
NoEquaFrame.Position = UDim2.new(0, 6, 0, 116)
NoEquaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
NoEquaFrame.BorderSizePixel = 0
NoEquaFrame.Visible = false
NoEquaFrame.Parent = Tela3
Blockedicon = Instance.new("ImageLabel")
Blockedicon.Size = UDim2.new(0, 60, 0, 60)
Blockedicon.AnchorPoint = Vector2.new(0.5, 0.5)
Blockedicon.Position = UDim2.new(0.5, 0, 0.5, -23)
Blockedicon.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
Blockedicon.BackgroundTransparency = 1
Blockedicon.Image = "rbxassetid://140149151607570"
Blockedicon.Parent = NoEquaFrame
ErroEqua = Instance.new("TextLabel")
ErroEqua.Size = UDim2.new(0, 224, 0, 42)
ErroEqua.Position = UDim2.new(0, 5, 0, 82)
ErroEqua.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ErroEqua.BackgroundTransparency = 0.5
ErroEqua.RichText = true
ErroEqua.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.RecursoTe .. "</font>"
ErroEqua.Font = Enum.Font.SourceSansBold
ErroEqua.TextScaled = true
ErroEqua.Parent = NoEquaFrame
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Parent = EquaFrame
ScrollEqua = Instance.new("ScrollingFrame")
ScrollEqua.Size = UDim2.new(1, -1, 1, 0)
ScrollEqua.Position = UDim2.new(0, 0, 0, 0)
ScrollEqua.BackgroundTransparency = 1
ScrollEqua.BorderSizePixel = 0
ScrollEqua.ScrollBarThickness = 1
ScrollEqua.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollEqua.ScrollBarImageTransparency = 0.5
ScrollEqua.CanvasSize = UDim2.new(0, 0, 0, 1015)
ScrollEqua.CanvasPosition = Vector2.new(0, 0)
ScrollEqua.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollEqua.ScrollingEnabled = true
ScrollEqua.ClipsDescendants = true
ScrollEqua.Parent = BaseSF
Volume = Instance.new("Frame")
Volume.Size = UDim2.new(0, 219, 0, 35)
Volume.Position = UDim2.new(0, 8, 0, 5)
Volume.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Volume.Parent = ScrollEqua
IconeVolume = Instance.new("ImageLabel")
IconeVolume.Size = UDim2.new(0, 35, 0, 35)
IconeVolume.Position = UDim2.new(0, 0, 0, 0)
IconeVolume.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeVolume.BackgroundTransparency = 0
IconeVolume.Image = "rbxassetid://89282663179812"
IconeVolume.Parent = Volume
VolumeBox = Instance.new("TextBox")
VolumeBox.Size = UDim2.new(0, 182, 1, 0)
VolumeBox.Position = UDim2.new(0, 39, 0, 0)
VolumeBox.BackgroundTransparency = 1
VolumeBox.Text = "1"
VolumeBox.PlaceholderText = Traducao.Volume
VolumeBox.TextWrapped = true
VolumeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
VolumeBox.Font = Enum.Font.SourceSansBold
VolumeBox.TextScaled = true
VolumeBox.Parent = Volume
Pitch = Instance.new("Frame")
Pitch.Size = UDim2.new(0, 219, 0, 35)
Pitch.Position = UDim2.new(0, 8, 0, 50)
Pitch.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Pitch.Parent = ScrollEqua
IconePitch = Instance.new("ImageLabel")
IconePitch.Size = UDim2.new(0, 35, 0, 35)
IconePitch.Position = UDim2.new(0, 0, 0, 0)
IconePitch.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconePitch.BackgroundTransparency = 0
IconePitch.Image = "rbxassetid://102339134358611"
IconePitch.Parent = Pitch
PitchBox = Instance.new("TextBox")
PitchBox.Size = UDim2.new(0, 182, 1, 0)
PitchBox.Position = UDim2.new(0, 39, 0, 0)
PitchBox.BackgroundTransparency = 1
PitchBox.Text = "1"
PitchBox.PlaceholderText = "Pitch"
PitchBox.TextWrapped = true
PitchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PitchBox.Font = Enum.Font.SourceSansBold
PitchBox.TextScaled = true
PitchBox.Parent = Pitch
FrequenciaTitulo = Instance.new("Frame")
FrequenciaTitulo.Size = UDim2.new(0, 219, 0, 25)
FrequenciaTitulo.Position = UDim2.new(0, 8, 0, 105)
FrequenciaTitulo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FrequenciaTitulo.BackgroundTransparency = 0.6
FrequenciaTitulo.BorderSizePixel = 1
FrequenciaTitulo.Parent = ScrollEqua
TextoFrenquencia = Instance.new("TextLabel")
TextoFrenquencia.Size = UDim2.new(1, -70, 1, -4)
TextoFrenquencia.Position = UDim2.new(0, 35, 0, 2)
TextoFrenquencia.BackgroundTransparency = 1
TextoFrenquencia.Text = Traducao.Freque
TextoFrenquencia.Font = Enum.Font.Garamond
TextoFrenquencia.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoFrenquencia.TextScaled = true
TextoFrenquencia.Parent = FrequenciaTitulo
Graves = Instance.new("Frame")
Graves.Size = UDim2.new(0, 219, 0, 35)
Graves.Position = UDim2.new(0, 8, 0, 150)
Graves.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Graves.Parent = ScrollEqua
IconeGraves = Instance.new("ImageLabel")
IconeGraves.Size = UDim2.new(0, 35, 0, 35)
IconeGraves.Position = UDim2.new(0, 0, 0, 0)
IconeGraves.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeGraves.BackgroundTransparency = 0
IconeGraves.Image = "rbxassetid://91932971942355"
IconeGraves.Parent = Graves
GravesBox = Instance.new("TextBox")
GravesBox.Size = UDim2.new(0, 182, 1, 0)
GravesBox.Position = UDim2.new(0, 39, 0, 0)
GravesBox.BackgroundTransparency = 1
GravesBox.Text = "1"
GravesBox.PlaceholderText = Traducao.Graves
GravesBox.TextWrapped = true
GravesBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GravesBox.Font = Enum.Font.SourceSansBold
GravesBox.TextScaled = true
GravesBox.Parent = Graves
Medios = Instance.new("Frame")
Medios.Size = UDim2.new(0, 219, 0, 35)
Medios.Position = UDim2.new(0, 8, 0, 195)
Medios.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Medios.Parent = ScrollEqua
IconeMedios = Instance.new("ImageLabel")
IconeMedios.Size = UDim2.new(0, 35, 0, 35)
IconeMedios.Position = UDim2.new(0, 0, 0, 0)
IconeMedios.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeMedios.BackgroundTransparency = 0
IconeMedios.Image = "rbxassetid://91932971942355"
IconeMedios.Parent = Medios
MediosBox = Instance.new("TextBox")
MediosBox.Size = UDim2.new(0, 182, 1, 0)
MediosBox.Position = UDim2.new(0, 39, 0, 0)
MediosBox.BackgroundTransparency = 1
MediosBox.Text = "1"
MediosBox.PlaceholderText = Traducao.Medios
MediosBox.TextWrapped = true
MediosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MediosBox.Font = Enum.Font.SourceSansBold
MediosBox.TextScaled = true
MediosBox.Parent = Medios
Agudos = Instance.new("Frame")
Agudos.Size = UDim2.new(0, 219, 0, 35)
Agudos.Position = UDim2.new(0, 8, 0, 240)
Agudos.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Agudos.Parent = ScrollEqua
IconeAgudos = Instance.new("ImageLabel")
IconeAgudos.Size = UDim2.new(0, 35, 0, 35)
IconeAgudos.Position = UDim2.new(0, 0, 0, 0)
IconeAgudos.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeAgudos.BackgroundTransparency = 0
IconeAgudos.Image = "rbxassetid://91932971942355"
IconeAgudos.Parent = Agudos
AgudosBox = Instance.new("TextBox")
AgudosBox.Size = UDim2.new(0, 182, 1, 0)
AgudosBox.Position = UDim2.new(0, 39, 0, 0)
AgudosBox.BackgroundTransparency = 1
AgudosBox.Text = "1"
AgudosBox.PlaceholderText = Traducao.Agudos
AgudosBox.TextWrapped = true
AgudosBox.TextColor3 = Color3.fromRGB(255, 255, 255)
AgudosBox.Font = Enum.Font.SourceSansBold
AgudosBox.TextScaled = true
AgudosBox.Parent = Agudos
EfeitosTitulo = Instance.new("Frame")
EfeitosTitulo.Size = UDim2.new(0, 219, 0, 25)
EfeitosTitulo.Position = UDim2.new(0, 8, 0, 295)
EfeitosTitulo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EfeitosTitulo.BackgroundTransparency = 0.6
EfeitosTitulo.BorderSizePixel = 1
EfeitosTitulo.Parent = ScrollEqua
TextoEfeitos = Instance.new("TextLabel")
TextoEfeitos.Size = UDim2.new(1, -70, 1, -4)
TextoEfeitos.Position = UDim2.new(0, 35, 0, 2)
TextoEfeitos.BackgroundTransparency = 1
TextoEfeitos.Text = Traducao.Efeitos
TextoEfeitos.Font = Enum.Font.Garamond
TextoEfeitos.TextColor3 = Color3.fromRGB(255, 0, 0)
TextoEfeitos.TextScaled = true
TextoEfeitos.Parent = EfeitosTitulo
Nenhum = Instance.new("ImageButton")
Nenhum.Name = "Nenhum"
Nenhum.Size = UDim2.new(0, 219, 0, 35)
Nenhum.Position = UDim2.new(0, 8, 0, 340)
Nenhum.AutoButtonColor = false
Nenhum.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
Nenhum.Parent = ScrollEqua
IconeNenhum = Instance.new("ImageLabel")
IconeNenhum.Size = UDim2.new(0, 35, 0, 35)
IconeNenhum.Position = UDim2.new(0, 0, 0, 0)
IconeNenhum.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeNenhum.BackgroundTransparency = 0
IconeNenhum.Image = "rbxassetid://130043384241999"
IconeNenhum.Parent = Nenhum
NenhumTexto = Instance.new("TextLabel")
NenhumTexto.Size = UDim2.new(0, 182, 1, 0)
NenhumTexto.Position = UDim2.new(0, 39, 0, 0)
NenhumTexto.BackgroundTransparency = 1
NenhumTexto.Text = Traducao.Nenhum
NenhumTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
NenhumTexto.Font = Enum.Font.SourceSansBold
NenhumTexto.TextScaled = true
NenhumTexto.Parent = Nenhum
Reverb = Instance.new("ImageButton")
Reverb.Name = "Reverb"
Reverb.Size = UDim2.new(0, 219, 0, 35)
Reverb.Position = UDim2.new(0, 8, 0, 385)
Reverb.AutoButtonColor = false
Reverb.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Reverb.Parent = ScrollEqua
IconeReverb = Instance.new("ImageLabel")
IconeReverb.Size = UDim2.new(0, 35, 0, 35)
IconeReverb.Position = UDim2.new(0, 0, 0, 0)
IconeReverb.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeReverb.BackgroundTransparency = 0
IconeReverb.Image = "rbxassetid://72645952367955"
IconeReverb.Parent = Reverb
ReverbTexto = Instance.new("TextLabel")
ReverbTexto.Size = UDim2.new(0, 182, 1, 0)
ReverbTexto.Position = UDim2.new(0, 39, 0, 0)
ReverbTexto.BackgroundTransparency = 1
ReverbTexto.Text = "Reverb"
ReverbTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ReverbTexto.Font = Enum.Font.SourceSansBold
ReverbTexto.TextScaled = true
ReverbTexto.Parent = Reverb
Echo = Instance.new("ImageButton")
Echo.Name = "Echo"
Echo.Size = UDim2.new(0, 219, 0, 35)
Echo.Position = UDim2.new(0, 8, 0, 430)
Echo.AutoButtonColor = false
Echo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Echo.Parent = ScrollEqua
IconeEcho = Instance.new("ImageLabel")
IconeEcho.Size = UDim2.new(0, 35, 0, 35)
IconeEcho.Position = UDim2.new(0, 0, 0, 0)
IconeEcho.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeEcho.BackgroundTransparency = 0
IconeEcho.Image = "rbxassetid://72645952367955"
IconeEcho.Parent = Echo
EchoTexto = Instance.new("TextLabel")
EchoTexto.Size = UDim2.new(0, 182, 1, 0)
EchoTexto.Position = UDim2.new(0, 39, 0, 0)
EchoTexto.BackgroundTransparency = 1
EchoTexto.Text = "Echo"
EchoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
EchoTexto.Font = Enum.Font.SourceSansBold
EchoTexto.TextScaled = true
EchoTexto.Parent = Echo
Distortion = Instance.new("ImageButton")
Distortion.Name = "Distortion"
Distortion.Size = UDim2.new(0, 219, 0, 35)
Distortion.Position = UDim2.new(0, 8, 0, 475)
Distortion.AutoButtonColor = false
Distortion.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Distortion.Parent = ScrollEqua
IconeDistortion = Instance.new("ImageLabel")
IconeDistortion.Size = UDim2.new(0, 35, 0, 35)
IconeDistortion.Position = UDim2.new(0, 0, 0, 0)
IconeDistortion.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeDistortion.Image = "rbxassetid://72645952367955"
IconeDistortion.Parent = Distortion
DistortionTexto = Instance.new("TextLabel")
DistortionTexto.Size = UDim2.new(0, 182, 1, 0)
DistortionTexto.Position = UDim2.new(0, 39, 0, 0)
DistortionTexto.BackgroundTransparency = 1
DistortionTexto.Text = "Distortion"
DistortionTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DistortionTexto.Font = Enum.Font.SourceSansBold
DistortionTexto.TextScaled = true
DistortionTexto.Parent = Distortion
Chorus = Instance.new("ImageButton")
Chorus.Name = "Chorus"
Chorus.Size = UDim2.new(0, 219, 0, 35)
Chorus.Position = UDim2.new(0, 8, 0, 520)
Chorus.AutoButtonColor = false
Chorus.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Chorus.Parent = ScrollEqua
IconeChorus = Instance.new("ImageLabel")
IconeChorus.Size = UDim2.new(0, 35, 0, 35)
IconeChorus.Position = UDim2.new(0, 0, 0, 0)
IconeChorus.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeChorus.Image = "rbxassetid://72645952367955"
IconeChorus.Parent = Chorus
ChorusTexto = Instance.new("TextLabel")
ChorusTexto.Size = UDim2.new(0, 182, 1, 0)
ChorusTexto.Position = UDim2.new(0, 39, 0, 0)
ChorusTexto.BackgroundTransparency = 1
ChorusTexto.Text = "Chorus"
ChorusTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
ChorusTexto.Font = Enum.Font.SourceSansBold
ChorusTexto.TextScaled = true
ChorusTexto.Parent = Chorus
Flanger = Instance.new("ImageButton")
Flanger.Name = "Flanger"
Flanger.Size = UDim2.new(0, 219, 0, 35)
Flanger.Position = UDim2.new(0, 8, 0, 565)
Flanger.AutoButtonColor = false
Flanger.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Flanger.Parent = ScrollEqua
IconeFlanger = Instance.new("ImageLabel")
IconeFlanger.Size = UDim2.new(0, 35, 0, 35)
IconeFlanger.Position = UDim2.new(0, 0, 0, 0)
IconeFlanger.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeFlanger.Image = "rbxassetid://72645952367955"
IconeFlanger.Parent = Flanger
FlangerTexto = Instance.new("TextLabel")
FlangerTexto.Size = UDim2.new(0, 182, 1, 0)
FlangerTexto.Position = UDim2.new(0, 39, 0, 0)
FlangerTexto.BackgroundTransparency = 1
FlangerTexto.Text = "Flanger"
FlangerTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
FlangerTexto.Font = Enum.Font.SourceSansBold
FlangerTexto.TextScaled = true
FlangerTexto.Parent = Flanger
Tremolo = Instance.new("ImageButton")
Tremolo.Name = "Tremolo"
Tremolo.Size = UDim2.new(0, 219, 0, 35)
Tremolo.Position = UDim2.new(0, 8, 0, 610)
Tremolo.AutoButtonColor = false
Tremolo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Tremolo.Parent = ScrollEqua
IconeTremolo = Instance.new("ImageLabel")
IconeTremolo.Size = UDim2.new(0, 35, 0, 35)
IconeTremolo.Position = UDim2.new(0, 0, 0, 0)
IconeTremolo.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeTremolo.Image = "rbxassetid://72645952367955"
IconeTremolo.Parent = Tremolo
TremoloTexto = Instance.new("TextLabel")
TremoloTexto.Size = UDim2.new(0, 182, 1, 0)
TremoloTexto.Position = UDim2.new(0, 39, 0, 0)
TremoloTexto.BackgroundTransparency = 1
TremoloTexto.Text = "Tremolo"
TremoloTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
TremoloTexto.Font = Enum.Font.SourceSansBold
TremoloTexto.TextScaled = true
TremoloTexto.Parent = Tremolo
Compressor = Instance.new("ImageButton")
Compressor.Name = "Compressor"
Compressor.Size = UDim2.new(0, 219, 0, 35)
Compressor.Position = UDim2.new(0, 8, 0, 655)
Compressor.AutoButtonColor = false
Compressor.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Compressor.Parent = ScrollEqua
IconeCompressor = Instance.new("ImageLabel")
IconeCompressor.Size = UDim2.new(0, 35, 0, 35)
IconeCompressor.Position = UDim2.new(0, 0, 0, 0)
IconeCompressor.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeCompressor.Image = "rbxassetid://72645952367955"
IconeCompressor.Parent = Compressor
CompressorTexto = Instance.new("TextLabel")
CompressorTexto.Size = UDim2.new(0, 182, 1, 0)
CompressorTexto.Position = UDim2.new(0, 39, 0, 0)
CompressorTexto.BackgroundTransparency = 1
CompressorTexto.Text = "Compressor"
CompressorTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CompressorTexto.Font = Enum.Font.SourceSansBold
CompressorTexto.TextScaled = true
CompressorTexto.Parent = Compressor
Radio = Instance.new("ImageButton")
Radio.Name = "Radio"
Radio.Size = UDim2.new(0, 219, 0, 35)
Radio.Position = UDim2.new(0, 8, 0, 700)
Radio.AutoButtonColor = false
Radio.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Radio.Parent = ScrollEqua
IconeRadio = Instance.new("ImageLabel")
IconeRadio.Size = UDim2.new(0, 35, 0, 35)
IconeRadio.Position = UDim2.new(0, 0, 0, 0)
IconeRadio.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeRadio.Image = "rbxassetid://72645952367955"
IconeRadio.Parent = Radio
RadioTexto = Instance.new("TextLabel")
RadioTexto.Size = UDim2.new(0, 182, 1, 0)
RadioTexto.Position = UDim2.new(0, 39, 0, 0)
RadioTexto.BackgroundTransparency = 1
RadioTexto.Text = "Radio"
RadioTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RadioTexto.Font = Enum.Font.SourceSansBold
RadioTexto.TextScaled = true
RadioTexto.Parent = Radio
Cinema = Instance.new("ImageButton")
Cinema.Name = "Cinema"
Cinema.Size = UDim2.new(0, 219, 0, 35)
Cinema.Position = UDim2.new(0, 8, 0, 745)
Cinema.AutoButtonColor = false
Cinema.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Cinema.Parent = ScrollEqua
IconeCinema = Instance.new("ImageLabel")
IconeCinema.Size = UDim2.new(0, 35, 0, 35)
IconeCinema.Position = UDim2.new(0, 0, 0, 0)
IconeCinema.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeCinema.Image = "rbxassetid://72645952367955"
IconeCinema.Parent = Cinema
CinemaTexto = Instance.new("TextLabel")
CinemaTexto.Size = UDim2.new(0, 182, 1, 0)
CinemaTexto.Position = UDim2.new(0, 39, 0, 0)
CinemaTexto.BackgroundTransparency = 1
CinemaTexto.Text = "Cinema"
CinemaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CinemaTexto.Font = Enum.Font.SourceSansBold
CinemaTexto.TextScaled = true
CinemaTexto.Parent = Cinema
Underwater = Instance.new("ImageButton")
Underwater.Name = "Underwater"
Underwater.Size = UDim2.new(0, 219, 0, 35)
Underwater.Position = UDim2.new(0, 8, 0, 790)
Underwater.AutoButtonColor = false
Underwater.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Underwater.Parent = ScrollEqua
IconeUnderwater = Instance.new("ImageLabel")
IconeUnderwater.Size = UDim2.new(0, 35, 0, 35)
IconeUnderwater.Position = UDim2.new(0, 0, 0, 0)
IconeUnderwater.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeUnderwater.Image = "rbxassetid://72645952367955"
IconeUnderwater.Parent = Underwater
UnderwaterTexto = Instance.new("TextLabel")
UnderwaterTexto.Size = UDim2.new(0, 182, 1, 0)
UnderwaterTexto.Position = UDim2.new(0, 39, 0, 0)
UnderwaterTexto.BackgroundTransparency = 1
UnderwaterTexto.Text = "Underwater"
UnderwaterTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
UnderwaterTexto.Font = Enum.Font.SourceSansBold
UnderwaterTexto.TextScaled = true
UnderwaterTexto.Parent = Underwater
Kid = Instance.new("ImageButton")
Kid.Name = "Kid"
Kid.Size = UDim2.new(0, 219, 0, 35)
Kid.Position = UDim2.new(0, 8, 0, 835)
Kid.AutoButtonColor = false
Kid.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Kid.Parent = ScrollEqua
IconeKid = Instance.new("ImageLabel")
IconeKid.Size = UDim2.new(0, 35, 0, 35)
IconeKid.Position = UDim2.new(0, 0, 0, 0)
IconeKid.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeKid.BackgroundTransparency = 0
IconeKid.Image = "rbxassetid://72645952367955"
IconeKid.Parent = Kid
KidTexto = Instance.new("TextLabel")
KidTexto.Size = UDim2.new(0, 182, 1, 0)
KidTexto.Position = UDim2.new(0, 39, 0, 0)
KidTexto.BackgroundTransparency = 1
KidTexto.Text = "Kid"
KidTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
KidTexto.Font = Enum.Font.SourceSansBold
KidTexto.TextScaled = true
KidTexto.Parent = Kid
Robot = Instance.new("ImageButton")
Robot.Name = "Robot"
Robot.Size = UDim2.new(0, 219, 0, 35)
Robot.Position = UDim2.new(0, 8, 0, 880)
Robot.AutoButtonColor = false
Robot.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Robot.Parent = ScrollEqua
IconeRobot = Instance.new("ImageLabel")
IconeRobot.Size = UDim2.new(0, 35, 0, 35)
IconeRobot.Position = UDim2.new(0, 0, 0, 0)
IconeRobot.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeRobot.BackgroundTransparency = 0
IconeRobot.Image = "rbxassetid://72645952367955"
IconeRobot.Parent = Robot
RobotTexto = Instance.new("TextLabel")
RobotTexto.Size = UDim2.new(0, 182, 1, 0)
RobotTexto.Position = UDim2.new(0, 39, 0, 0)
RobotTexto.BackgroundTransparency = 1
RobotTexto.Text = "Bug"
RobotTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RobotTexto.Font = Enum.Font.SourceSansBold
RobotTexto.TextScaled = true
RobotTexto.Parent = Robot
Slowed = Instance.new("ImageButton")
Slowed.Name = "Slowed"
Slowed.Size = UDim2.new(0, 219, 0, 35)
Slowed.Position = UDim2.new(0, 8, 0, 925)
Slowed.AutoButtonColor = false
Slowed.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Slowed.Parent = ScrollEqua
IconeSlowed = Instance.new("ImageLabel")
IconeSlowed.Size = UDim2.new(0, 35, 0, 35)
IconeSlowed.Position = UDim2.new(0, 0, 0, 0)
IconeSlowed.BackgroundColor3 = Color3.fromRGB(37, 33, 32)
IconeSlowed.BackgroundTransparency = 0
IconeSlowed.Image = "rbxassetid://72645952367955"
IconeSlowed.Parent = Slowed
SlowedTexto = Instance.new("TextLabel")
SlowedTexto.Size = UDim2.new(0, 182, 1, 0)
SlowedTexto.Position = UDim2.new(0, 39, 0, 0)
SlowedTexto.BackgroundTransparency = 1
SlowedTexto.Text = "Slowed"
SlowedTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
SlowedTexto.Font = Enum.Font.SourceSansBold
SlowedTexto.TextScaled = true
SlowedTexto.Parent = Slowed
ResetarEqua = Instance.new("ImageButton")
ResetarEqua.Name = "Resetar"
ResetarEqua.Size = UDim2.new(0, 219, 0, 35)
ResetarEqua.Position = UDim2.new(0, 8, 0, 975)
ResetarEqua.AutoButtonColor = false
ResetarEqua.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ResetarEqua.Parent = ScrollEqua
ResetarTexto = Instance.new("TextLabel")
ResetarTexto.Size = UDim2.new(1, 0, 1, 0)
ResetarTexto.Position = UDim2.new(0, 0, 0, 0)
ResetarTexto.BackgroundTransparency = 1
ResetarTexto.Text = "Reset"
ResetarTexto.TextColor3 = Color3.fromRGB(255, 0, 0)
ResetarTexto.Font = Enum.Font.SourceSansBold
ResetarTexto.TextScaled = true
ResetarTexto.Parent = ResetarEqua
Pesquisa = Instance.new("Frame")
Pesquisa.Size = UDim2.new(0, 235, 0, 43)
Pesquisa.Position = UDim2.new(0, 6, 0, 6)
Pesquisa.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Pesquisa.BorderSizePixel = 0
Pesquisa.Parent = Tela4
Lupa = Instance.new("ImageButton")
Lupa.Size = UDim2.new(0, 43, 0, 43)
Lupa.Position = UDim2.new(0, 0, 0, 0)
Lupa.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
Lupa.Image = "rbxassetid://78857002895466"
Lupa.Active = true
Lupa.Parent = Pesquisa
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(0, 2, 1, 0)
Linha.Position = UDim2.new(0, 43, 0, 0)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Pesquisa
PesquisarBox = Instance.new("TextBox")
PesquisarBox.Size = UDim2.new(0, 139, 0, 37)
PesquisarBox.Position = UDim2.new(0, 48, 0, 3)
PesquisarBox.Text = ""
PesquisarBox.PlaceholderText = Traducao.Pesquisar
PesquisarBox.TextScaled = true
PesquisarBox.TextWrapped = true
PesquisarBox.ClearTextOnFocus = false
PesquisarBox.TextColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
PesquisarBox.BackgroundTransparency = 1
PesquisarBox.Active = true
PesquisarBox.Parent = Pesquisa
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(0, 2, 1, 0)
Linha2.Position = UDim2.new(0, 190, 0, 0)
Linha2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha2.BorderSizePixel = 0
Linha2.Parent = Pesquisa
Filtro = Instance.new("ImageButton")
Filtro.Size = UDim2.new(0, 33, 0, 33)
Filtro.Position = UDim2.new(0, 197, 0, 5)
Filtro.AutoButtonColor = false
Filtro.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Filtro.Image = "rbxassetid://128216827107080"
Filtro.Parent = Pesquisa
DownloadFrame = Instance.new("Frame")
DownloadFrame.Size = UDim2.new(0, 235, 0, 151)
DownloadFrame.Position = UDim2.new(0, 6, 0, 58)
DownloadFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
DownloadFrame.BorderSizePixel = 0
DownloadFrame.Parent = Tela4
DownloadFrameTexto = Instance.new("TextLabel")
DownloadFrameTexto.Size = UDim2.new(0, 223, 0, 40)
DownloadFrameTexto.Position = UDim2.new(0, 6, 0, 105)
DownloadFrameTexto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DownloadFrameTexto.BackgroundTransparency = 0.5
DownloadFrameTexto.RichText = true
DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
DownloadFrameTexto.Font = Enum.Font.SourceSansBold
DownloadFrameTexto.TextScaled = true
DownloadFrameTexto.Visible = true
DownloadFrameTexto.Parent = DownloadFrame
padding2 = Instance.new("UIPadding")
padding2.PaddingLeft = UDim.new(0, 2)
padding2.PaddingRight = UDim.new(0, 2)
padding2.PaddingTop = UDim.new(0, 2)
padding2.PaddingBottom = UDim.new(0, 2)
padding2.Parent = DownloadFrameTexto
PaginaFrame = Instance.new("Frame")
PaginaFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PaginaFrame.BorderSizePixel = 0
PaginaFrame.Visible = false
PaginaFrame.Parent = Tela4
ScrollPagina = Instance.new("ScrollingFrame")
ScrollPagina.Size = UDim2.new(1, -6, 1, 0)
ScrollPagina.Position = UDim2.new(0, 3, 0, 0)
ScrollPagina.BackgroundTransparency = 1
ScrollPagina.BorderSizePixel = 0
ScrollPagina.ScrollBarThickness = 1
ScrollPagina.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPagina.ScrollBarImageTransparency = 0.5
ScrollPagina.CanvasSize = UDim2.new(0, 280, 0, 0)
ScrollPagina.ScrollingDirection = Enum.ScrollingDirection.X
ScrollPagina.ClipsDescendants = true
ScrollPagina.Parent = PaginaFrame
PaginaEsperandoFrame = Instance.new("Frame")
PaginaEsperandoFrame.Size = UDim2.new(0, 235, 0, 27)
PaginaEsperandoFrame.Position = UDim2.new(0, 6, 0, 218)
PaginaEsperandoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
PaginaEsperandoFrame.BorderSizePixel = 0
PaginaEsperandoFrame.Visible = true
PaginaEsperandoFrame.Parent = Tela4
PaginaEsperandoIcon = Instance.new("ImageLabel")
PaginaEsperandoIcon.Size = UDim2.new(0, 27, 0, 27)
PaginaEsperandoIcon.Position = UDim2.new(0, 0, 0, 0)
PaginaEsperandoIcon.BackgroundTransparency = 1
PaginaEsperandoIcon.Image = "rbxassetid://130610275359163"
PaginaEsperandoIcon.Parent = PaginaEsperandoFrame
PaginaEsperandoText = Instance.new("TextLabel")
PaginaEsperandoText.Size = UDim2.new(1, -36, 1, 0)
PaginaEsperandoText.Position = UDim2.new(0, 32, 0, 0)
PaginaEsperandoText.RichText = true
PaginaEsperandoText.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.RecursoTi .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.NaoPodePagina .. "</font>"
PaginaEsperandoText.TextScaled = true
PaginaEsperandoText.Font = Enum.Font.SourceSansBold
PaginaEsperandoText.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
PaginaEsperandoText.BackgroundTransparency = 1
PaginaEsperandoText.BorderSizePixel = 0
PaginaEsperandoText.Parent = PaginaEsperandoFrame
Aguardando = Instance.new("ImageLabel")
Aguardando.Size = UDim2.new(0, 80, 0, 80)
Aguardando.AnchorPoint = Vector2.new(0.5, 0.5)
Aguardando.Position = UDim2.new(0.5, 2, 0.5, -20)
Aguardando.BackgroundTransparency = 1
Aguardando.Image = "rbxassetid://130321829564804"
Aguardando.Visible = true
Aguardando.Parent = DownloadFrame
Loading = Instance.new("ImageLabel")
Loading.Size = UDim2.new(0, 75, 0, 75)
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.Position = UDim2.new(0.5, 0, 0.5, -2)
Loading.BackgroundTransparency = 1
Loading.Image = "rbxassetid://124877910068047"
Loading.Visible = false
Loading.Parent = DownloadFrame
SemResultado = Instance.new("ImageLabel")
SemResultado.Size = UDim2.new(0, 80, 0, 80)
SemResultado.AnchorPoint = Vector2.new(0.5, 0.5)
SemResultado.Position = UDim2.new(0.5, 3, 0.5, -20)
SemResultado.BackgroundTransparency = 1
SemResultado.Image = "rbxassetid://94766101394526"
SemResultado.Visible = false
SemResultado.Parent = DownloadFrame
Resultados = Instance.new("Frame")
Resultados.Size = UDim2.new(1, 0, 1, -4)
Resultados.Position = UDim2.new(0, 0, 0, 2)
Resultados.BackgroundTransparency = 1
Resultados.BorderSizePixel = 0
Resultados.ClipsDescendants = true
Resultados.Parent = DownloadFrame
FiltroFrame = Instance.new("Frame")
FiltroFrame.Size = UDim2.new(1, 0, 1, 0)
FiltroFrame.Position = UDim2.new(0, 0, 0, 0)
FiltroFrame.BackgroundTransparency = 1
FiltroFrame.BorderSizePixel = 0
FiltroFrame.Visible = false
FiltroFrame.Parent = Resultados
TituloFiltro = Instance.new("TextLabel")
TituloFiltro.Size = UDim2.new(0, 227, 0, 24)
TituloFiltro.Position = UDim2.new(0, 4, 0, 2)
TituloFiltro.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TituloFiltro.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFiltro.BackgroundTransparency = 0.5
TituloFiltro.BorderSizePixel = 0
TituloFiltro.Text = Traducao.Filter
TituloFiltro.TextSize = 12
TituloFiltro.Parent = FiltroFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = FiltroFrame
ScrollFiltro = Instance.new("ScrollingFrame")
ScrollFiltro.Size = UDim2.new(1, -1, 1, -10)
ScrollFiltro.Position = UDim2.new(0, 0, 0, 34)
ScrollFiltro.BackgroundTransparency = 1
ScrollFiltro.BorderSizePixel = 0
ScrollFiltro.ScrollBarThickness = 1
ScrollFiltro.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollFiltro.ScrollBarImageTransparency = 0.5
ScrollFiltro.CanvasSize = UDim2.new(0, 0, 0, 210)
ScrollFiltro.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollFiltro.ClipsDescendants = true
ScrollFiltro.Parent = FiltroFrame
Relevancia = Instance.new("ImageButton")
Relevancia.Size = UDim2.new(0, 221, 0, 35)
Relevancia.Position = UDim2.new(0, 7, 0, 5)
Relevancia.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Relevancia.BorderSizePixel = 0
Relevancia.AutoButtonColor = false
Relevancia.Parent = ScrollFiltro
DataUpload = Instance.new("ImageButton")
DataUpload.Size = UDim2.new(0, 221, 0, 35)
DataUpload.Position = UDim2.new(0, 7, 0, 50)
DataUpload.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DataUpload.BackgroundTransparency = 0
DataUpload.BorderSizePixel = 0
DataUpload.AutoButtonColor = false
DataUpload.Active = true
DataUpload.Parent = ScrollFiltro
Duracao = Instance.new("ImageButton")
Duracao.Size = UDim2.new(0, 221, 0, 35)
Duracao.Position = UDim2.new(0, 7, 0, 95)
Duracao.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Duracao.BorderSizePixel = 0
Duracao.AutoButtonColor = false
Duracao.Parent = ScrollFiltro
IconeRelevancia = Instance.new("ImageLabel")
IconeRelevancia.Size = UDim2.new(0, 35, 0, 35)
IconeRelevancia.Position = UDim2.new(0, 0, 0, 0)
IconeRelevancia.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeRelevancia.BackgroundTransparency = 0
IconeRelevancia.Image = "rbxassetid://86663364934636"
IconeRelevancia.Parent = Relevancia
IconeDataUpload = Instance.new("ImageLabel")
IconeDataUpload.Size = UDim2.new(0, 35, 0, 35)
IconeDataUpload.Position = UDim2.new(0, 0, 0, 0)
IconeDataUpload.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeDataUpload.BackgroundTransparency = 0
IconeDataUpload.Image = "rbxassetid://102239634857456"
IconeDataUpload.ImageTransparency = 0
IconeDataUpload.Parent = DataUpload
IconeDuracao = Instance.new("ImageLabel")
IconeDuracao.Size = UDim2.new(0, 35, 0, 35)
IconeDuracao.Position = UDim2.new(0, 0, 0, 0)
IconeDuracao.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeDuracao.BackgroundTransparency = 0
IconeDuracao.Image = "rbxassetid://124803568759863"
IconeDuracao.Parent = Duracao
RelevanciaTexto = Instance.new("TextLabel")
RelevanciaTexto.Size = UDim2.new(0, 178, 1, 0)
RelevanciaTexto.Position = UDim2.new(0, 39, 0, 0)
RelevanciaTexto.BackgroundTransparency = 1
RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
RelevanciaTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
RelevanciaTexto.Font = Enum.Font.SourceSansBold
RelevanciaTexto.TextScaled = true
RelevanciaTexto.Parent = Relevancia
DataUploadTexto = Instance.new("TextLabel")
DataUploadTexto.Size = UDim2.new(0, 178, 1, 0)
DataUploadTexto.Position = UDim2.new(0, 39, 0, 0)
DataUploadTexto.BackgroundTransparency = 1
DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
DataUploadTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DataUploadTexto.Font = Enum.Font.SourceSansBold
DataUploadTexto.TextScaled = true
DataUploadTexto.Parent = DataUpload
DuracaoTexto = Instance.new("TextLabel")
DuracaoTexto.Size = UDim2.new(0, 178, 1, 0)
DuracaoTexto.Position = UDim2.new(0, 39, 0, 0)
DuracaoTexto.BackgroundTransparency = 1
DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
DuracaoTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DuracaoTexto.Font = Enum.Font.SourceSansBold
DuracaoTexto.TextScaled = true
DuracaoTexto.Parent = Duracao
AplicarFiltro = Instance.new("ImageButton")
AplicarFiltro.Size = UDim2.new(0, 100, 0, 35)
AplicarFiltro.Position = UDim2.new(0, 7, 0, 145)
AplicarFiltro.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
AplicarFiltro.BackgroundTransparency = 0.9
AplicarFiltro.BorderSizePixel = 0
AplicarFiltro.AutoButtonColor = false
AplicarFiltro.Parent = ScrollFiltro
RemoverFiltro = Instance.new("ImageButton")
RemoverFiltro.Size = UDim2.new(0, 100, 0, 35)
RemoverFiltro.Position = UDim2.new(0, 128, 0, 145)
RemoverFiltro.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
RemoverFiltro.BackgroundTransparency = 0.9
RemoverFiltro.BorderSizePixel = 0
RemoverFiltro.AutoButtonColor = false
RemoverFiltro.Parent = ScrollFiltro
NomeAplicarFiltro = Instance.new("TextLabel")
NomeAplicarFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeAplicarFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeAplicarFiltro.BackgroundTransparency = 1
NomeAplicarFiltro.Text = Traducao.AplicarF
NomeAplicarFiltro.TextColor3 = Color3.fromRGB(20, 20, 20)
NomeAplicarFiltro.Font = Enum.Font.SourceSansBold
NomeAplicarFiltro.TextScaled = true
NomeAplicarFiltro.Parent = AplicarFiltro
NomeRemoverFiltro = Instance.new("TextLabel")
NomeRemoverFiltro.Size = UDim2.new(1, -8, 1, -8)
NomeRemoverFiltro.Position = UDim2.new(0, 4, 0, 4)
NomeRemoverFiltro.BackgroundTransparency = 1
NomeRemoverFiltro.Text = Traducao.RemoverF
NomeRemoverFiltro.TextColor3 = Color3.fromRGB(20, 20, 20)
NomeRemoverFiltro.Font = Enum.Font.SourceSansBold
NomeRemoverFiltro.TextScaled = true
NomeRemoverFiltro.Parent = RemoverFiltro
Formato = Instance.new("Frame")
Formato.Size = UDim2.new(1, 0, 1, 0)
Formato.Position = UDim2.new(0, 0, 0, 0)
Formato.BackgroundTransparency = 1
Formato.BorderSizePixel = 0
Formato.Visible = false
Formato.Parent = Resultados
TituloFormato = Instance.new("TextLabel")
TituloFormato.Size = UDim2.new(0, 227, 0, 24)
TituloFormato.Position = UDim2.new(0, 4, 0, 2)
TituloFormato.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TituloFormato.TextColor3 = Color3.fromRGB(255, 255, 255)
TituloFormato.BackgroundTransparency = 0.5
TituloFormato.BorderSizePixel = 0
TituloFormato.Text = Traducao.EscolhaFor
TituloFormato.TextSize = 12
TituloFormato.Parent = Formato
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 30)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = Formato
Thumbfor = Instance.new("ImageLabel")
Thumbfor.Size = UDim2.new(0, 85, 0, 50)
Thumbfor.Position = UDim2.new(0, 7, 0, 39)
Thumbfor.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Thumbfor.Image = "rbxassetid://0"
Thumbfor.ImageRectOffset = Vector2.new(0, 0)
Thumbfor.ImageRectSize = Vector2.new(0, 0)
Thumbfor.Parent = Formato
Titulofor = Instance.new("Frame")
Titulofor.Size = UDim2.new(0, 127, 0, 50)
Titulofor.Position = UDim2.new(0, 101, 0, 39)
Titulofor.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Titulofor.Parent = Formato
TextoTituloFor = Instance.new("TextLabel")
TextoTituloFor.Size = UDim2.new(1, -10, 1, -10)
TextoTituloFor.Position = UDim2.new(0, 5, 0, 5)
TextoTituloFor.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextoTituloFor.BackgroundTransparency = 1
TextoTituloFor.BorderSizePixel = 0
TextoTituloFor.RichText = true
TextoTituloFor.Text = ""
TextoTituloFor.TextScaled = true
TextoTituloFor.Parent = Titulofor
BotaoMp3 = Instance.new("ImageButton")
BotaoMp3.Size = UDim2.new(0, 60, 0, 30)
BotaoMp3.Position = UDim2.new(0, 7, 0, 112)
BotaoMp3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BotaoMp3.BackgroundTransparency = 0
BotaoMp3.AutoButtonColor = true
BotaoMp3.Parent = Formato
BotaoMp4 = Instance.new("ImageButton")
BotaoMp4.Size = UDim2.new(0, 60, 0, 30)
BotaoMp4.Position = UDim2.new(0, 88, 0, 112)
BotaoMp4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BotaoMp4.BackgroundTransparency = 0.9
BotaoMp4.AutoButtonColor = false
BotaoMp4.Parent = Formato
BotaoCancelar = Instance.new("ImageButton")
BotaoCancelar.Size = UDim2.new(0, 60, 0, 30)
BotaoCancelar.Position = UDim2.new(0, 168, 0, 112)
BotaoCancelar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BotaoCancelar.Parent = Formato
NomeMp3 = Instance.new("TextLabel")
NomeMp3.Size = UDim2.new(1, -8, 1, -8)
NomeMp3.Position = UDim2.new(0, 4, 0, 4)
NomeMp3.BackgroundTransparency = 1
NomeMp3.Text = Traducao.Musica
NomeMp3.TextColor3 = Color3.fromRGB(0, 191, 255)
NomeMp3.Font = Enum.Font.SourceSansBold
NomeMp3.TextScaled = true
NomeMp3.Parent = BotaoMp3
NomeMp4 = Instance.new("TextLabel")
NomeMp4.Size = UDim2.new(1, -8, 1, -8)
NomeMp4.Position = UDim2.new(0, 4, 0, 4)
NomeMp4.BackgroundTransparency = 1
NomeMp4.Text = "Video"
NomeMp4.TextColor3 = Color3.fromRGB(144, 238, 144)
NomeMp4.Font = Enum.Font.SourceSansBold
NomeMp4.TextScaled = true
NomeMp4.Parent = BotaoMp4
NomeCancel = Instance.new("TextLabel")
NomeCancel.Size = UDim2.new(1, -8, 1, -8)
NomeCancel.Position = UDim2.new(0, 4, 0, 4)
NomeCancel.BackgroundTransparency = 1
NomeCancel.Text = Traducao.Cancelar
NomeCancel.TextColor3 = Color3.fromRGB(178, 55, 34)
NomeCancel.Font = Enum.Font.SourceSansBold
NomeCancel.TextScaled = true
NomeCancel.Parent = BotaoCancelar
Erro = Instance.new("ImageLabel")
Erro.Size = UDim2.new(0, 80, 0, 80)
Erro.AnchorPoint = Vector2.new(0.5, 0.5)
Erro.Position = UDim2.new(0.5, -3, 0.5, -20)
Erro.BackgroundTransparency = 1
Erro.Image = "rbxassetid://80694922314021"
Erro.Visible = false
Erro.Parent = Resultados
Baixando = Instance.new("ImageLabel")
Baixando.Size = UDim2.new(0, 80, 0, 80)
Baixando.AnchorPoint = Vector2.new(0.5, 0.5)
Baixando.Position = UDim2.new(0.5, -3, 0.5, -20)
Baixando.BackgroundTransparency = 1
Baixando.Image = "rbxassetid://76931060119037"
Baixando.Visible = false
Baixando.Parent = Resultados
Concluido = Instance.new("ImageLabel")
Concluido.Size = UDim2.new(0, 77, 0, 77)
Concluido.AnchorPoint = Vector2.new(0.5, 0.5)
Concluido.Position = UDim2.new(0.5, -3, 0.5, -20)
Concluido.BackgroundTransparency = 1
Concluido.Image = "rbxassetid://135264044346021"
Concluido.Visible = false
Concluido.Parent = Resultados
Tutorial = Instance.new("ImageButton")
Tutorial.Size = UDim2.new(0, 25, 0, 25)
Tutorial.Position = UDim2.new(0, 7, 0, 5)
Tutorial.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Tutorial.BorderSizePixel = 0
Tutorial.Visible = false
Tutorial.Parent = Resultados
TutoTexto = Instance.new("TextLabel")
TutoTexto.Size = UDim2.new(1, 0, 1, 0)
TutoTexto.Position = UDim2.new(0, 0, 0, 0)
TutoTexto.BackgroundTransparency = 1
TutoTexto.Text = "?"
TutoTexto.TextColor3 = Color3.fromRGB(188, 11, 35)
TutoTexto.Font = Enum.Font.SourceSansBold
TutoTexto.TextScaled = true
TutoTexto.Parent = Tutorial
Novamente = Instance.new("ImageButton")
Novamente.Size = UDim2.new(0, 25, 0, 25)
Novamente.Position = UDim2.new(0, 203, 0, 5)
Novamente.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Novamente.BorderSizePixel = 0
Novamente.Visible = false
Novamente.Parent = Resultados
FotoNova = Instance.new("ImageLabel")
FotoNova.Size = UDim2.new(0, 18, 0, 18)
FotoNova.Position = UDim2.new(0, 3, 0, 3)
FotoNova.BackgroundTransparency = 1
FotoNova.ImageTransparency = 0
FotoNova.Image = "rbxassetid://95528695645064"
FotoNova.Parent = Novamente
ScrollDownload = Instance.new("ScrollingFrame")
ScrollDownload.Size = UDim2.new(1, -1, 1, 0)
ScrollDownload.Position = UDim2.new(0, 0, 0, 0)
ScrollDownload.BackgroundTransparency = 1
ScrollDownload.BorderSizePixel = 0
ScrollDownload.ScrollBarThickness = 1
ScrollDownload.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollDownload.ScrollBarImageTransparency = 0.5
ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollDownload.CanvasPosition = Vector2.new(0, 0)
ScrollDownload.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollDownload.ClipsDescendants = true
ScrollDownload.Visible = false
ScrollDownload.Parent = Resultados
TituloGC = Instance.new("Frame")
TituloGC.Size = UDim2.new(0, 235, 0, 43)
TituloGC.Position = UDim2.new(0, 6, 0, 6)
TituloGC.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloGC.BorderSizePixel = 0
TituloGC.Parent = Tela5
NomeGC = Instance.new("TextLabel")
NomeGC.Size = UDim2.new(1, 0, 1, 0)
NomeGC.Position = UDim2.new(0, 0, 0, 0)
NomeGC.BackgroundTransparency = 1
NomeGC.Text = "Global Chat"
NomeGC.TextColor3 = Color3.fromRGB(255, 0, 0)
NomeGC.Font = Enum.Font.SourceSansBold
NomeGC.TextScaled = true
NomeGC.Parent = TituloGC
GCFrame = Instance.new("Frame")
GCFrame.Size = UDim2.new(0, 235, 0, 187)
GCFrame.Position = UDim2.new(0, 6, 0, 58)
GCFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
GCFrame.BorderSizePixel = 0
GCFrame.Parent = Tela5
Regras = Instance.new("TextButton")
Regras.Size = UDim2.new(0, 19, 0, 19)
Regras.Position = UDim2.new(0, 5, 0, 3)
Regras.Text = "R"
Regras.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Regras.TextColor3 = Color3.fromRGB(255, 255, 255)
Regras.BackgroundTransparency = 0.5
Regras.Parent = GCFrame
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 2)
Linha.Position = UDim2.new(0, 0, 0, 25)
Linha.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha.BorderSizePixel = 0
Linha.Parent = GCFrame
AvisoGC = Instance.new("TextLabel")
AvisoGC.Size = UDim2.new(0, 177, 0, 19)
AvisoGC.Position = UDim2.new(0, 29, 0, 3)
AvisoGC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AvisoGC.BackgroundTransparency = 0.5
AvisoGC.Text = Traducao.Respeito
AvisoGC.TextColor3 = Color3.fromRGB(255, 255, 255)
AvisoGC.Font = Enum.Font.SourceSansBold
AvisoGC.TextScaled = true
AvisoGC.Visible = true
AvisoGC.Parent = GCFrame
padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 3)
padding.PaddingRight = UDim.new(0, 3)
padding.PaddingTop = UDim.new(0, 3)
padding.PaddingBottom = UDim.new(0, 3)
padding.Parent = AvisoGC
NotificarGC = Instance.new("ImageButton")
NotificarGC.Size = UDim2.new(0, 19, 0, 19)
NotificarGC.Position = UDim2.new(0, 211, 0, 3)
NotificarGC.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
NotificarGC.BackgroundTransparency = 0.5
NotificarGC.Parent = GCFrame
Sino = Instance.new("ImageLabel")
Sino.Size = UDim2.new(0, 17, 0, 16)
Sino.Position = UDim2.new(0, 1, 0, 1)
Sino.Image = "rbxassetid://115374069603142"
Sino.BackgroundTransparency = 1
Sino.Parent = NotificarGC
EsperandoIMG = Instance.new("ImageLabel")
EsperandoIMG.Size = UDim2.new(0, 90, 0, 90)
EsperandoIMG.AnchorPoint = Vector2.new(0.5, 0.5)
EsperandoIMG.Position = UDim2.new(0.5, -3, 0.5, -5)
EsperandoIMG.BackgroundTransparency = 1
EsperandoIMG.Image = "rbxassetid://18836713445"
EsperandoIMG.Visible = true
EsperandoIMG.Parent = GCFrame
BaseFinalGC = Instance.new("Frame")
BaseFinalGC.Size = UDim2.new(0, 40, 0, 40)
BaseFinalGC.AnchorPoint = Vector2.new(0.5, 0.5)
BaseFinalGC.Position = UDim2.new(0.5, 0, 0.5, 26)
BaseFinalGC.BorderSizePixel = 0
BaseFinalGC.BackgroundTransparency = 1
BaseFinalGC.ZIndex = 2
BaseFinalGC.ClipsDescendants = true
BaseFinalGC.Parent = GCFrame
FinalGC = Instance.new("ImageButton")
FinalGC.Size = UDim2.new(0, 32, 0, 32)
FinalGC.Position = UDim2.new(0, 4, 1, 4)
FinalGC.ZIndex = 2
FinalGC.Image = "rbxassetid://128357204583758"
FinalGC.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
FinalGC.Parent = BaseFinalGC
ScrollGC = Instance.new("ScrollingFrame")
ScrollGC.Size = UDim2.new(1, -2, 1, -73)
ScrollGC.Position = UDim2.new(0, 1, 0, 28)
ScrollGC.BackgroundTransparency = 1
ScrollGC.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollGC.ScrollBarImageTransparency = 0.5
ScrollGC.BorderSizePixel = 0
ScrollGC.ScrollBarThickness = 1
ScrollGC.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollGC.CanvasPosition = Vector2.new(0, 0)
ScrollGC.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollGC.ClipsDescendants = true
ScrollGC.Visible = false
ScrollGC.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollGC.Parent = GCFrame
paddinggc = Instance.new("UIPadding")
paddinggc.PaddingLeft = UDim.new(0, 5)
paddinggc.PaddingRight = UDim.new(0, 5)
paddinggc.PaddingTop = UDim.new(0, 5)
paddinggc.PaddingBottom = UDim.new(0, 5)
paddinggc.Parent = ScrollGC
layoutgc = Instance.new("UIListLayout")
layoutgc.Parent = ScrollGC
layoutgc.SortOrder = Enum.SortOrder.LayoutOrder
layoutgc.Padding = UDim.new(0, 9)
Linha2 = Instance.new("Frame")
Linha2.Size = UDim2.new(1, 0, 0, 2)
Linha2.Position = UDim2.new(0, 0, 0, 143)
Linha2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Linha2.BorderSizePixel = 0
Linha2.Parent = GCFrame
MsgFrame = Instance.new("Frame")
MsgFrame.Size = UDim2.new(0, 223, 0, 32)
MsgFrame.Position = UDim2.new(0, 6, 0, 150)
MsgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MsgFrame.BorderSizePixel = 0
MsgFrame.Parent = GCFrame
MsgErroGC = Instance.new("TextLabel")
MsgErroGC.Size = UDim2.new(0, 215, 0, 28)
MsgErroGC.Position = UDim2.new(0, 4, 0, 2)
MsgErroGC.Text = Traducao.GcKey
MsgErroGC.TextScaled = true
MsgErroGC.TextColor3 = Color3.fromRGB(220, 220, 220)
MsgErroGC.BackgroundTransparency = 1
MsgErroGC.Visible = true
MsgErroGC.Parent = MsgFrame
Traduzir = Instance.new("ImageButton")
Traduzir.Size = UDim2.new(0, 24, 0, 24)
Traduzir.Position = UDim2.new(0, 4, 0, 4)
Traduzir.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Traduzir.Visible = false
Traduzir.Parent = MsgFrame
FotoTradu = Instance.new("ImageLabel")
FotoTradu.Size = UDim2.new(0, 18, 0, 18)
FotoTradu.Position = UDim2.new(0, 3, 0, 3)
FotoTradu.BackgroundTransparency = 1
FotoTradu.ImageTransparency = 0
FotoTradu.Image = "rbxassetid://84867288877251"
FotoTradu.Parent = Traduzir
LinhaTraducao = Instance.new("Frame")
LinhaTraducao.Size = UDim2.new(0, 1, 1, 0)
LinhaTraducao.Position = UDim2.new(0, 32, 0, 0)
LinhaTraducao.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LinhaTraducao.BorderSizePixel = 0
LinhaTraducao.Visible = false
LinhaTraducao.Parent = MsgFrame
GCBox = Instance.new("TextBox")
GCBox.Size = UDim2.new(0, 151, 0, 28)
GCBox.Position = UDim2.new(0, 36, 0, 2)
GCBox.Text = ""
GCBox.ClearTextOnFocus = false
GCBox.PlaceholderText = Traducao.EnvieGc
GCBox.TextScaled = true
GCBox.TextColor3 = Color3.fromRGB(255, 255, 255)
GCBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
GCBox.BackgroundTransparency = 1
GCBox.Active = false
GCBox.Visible = false
GCBox.Parent = MsgFrame
SendGC = Instance.new("ImageButton")
SendGC.Size = UDim2.new(0, 32, 0, 32)
SendGC.Position = UDim2.new(0, 191, 0, 0)
SendGC.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SendGC.Visible = false
SendGC.Parent = MsgFrame
Aviao = Instance.new("ImageLabel")
Aviao.Size = UDim2.new(0, 24, 0, 24)
Aviao.Position = UDim2.new(0, 4, 0, 4)
Aviao.BackgroundTransparency = 1
Aviao.ImageTransparency = 0
Aviao.Image = "rbxassetid://111380412941011"
Aviao.Parent = SendGC
TituloPremium = Instance.new("Frame")
TituloPremium.Size = UDim2.new(0, 235, 0, 43)
TituloPremium.Position = UDim2.new(0, 6, 0, 6)
TituloPremium.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloPremium.BorderSizePixel = 0
TituloPremium.Parent = Tela6
NomePremium = Instance.new("TextLabel")
NomePremium.Size = UDim2.new(1, 0, 1, 0)
NomePremium.Position = UDim2.new(0, 0, 0, 0)
NomePremium.BackgroundTransparency = 1
NomePremium.Text = "Premium"
NomePremium.TextColor3 = Color3.fromRGB(255, 255, 0)
NomePremium.Font = Enum.Font.SourceSansBold
NomePremium.TextScaled = true
NomePremium.Parent = TituloPremium
Privilegios = Instance.new("Frame")
Privilegios.Size = UDim2.new(0, 235, 0, 100)
Privilegios.Position = UDim2.new(0, 6, 0, 58)
Privilegios.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Privilegios.BorderSizePixel = 0
Privilegios.Parent = Tela6
BaseSF = Instance.new("Frame")
BaseSF.Size = UDim2.new(1, 0, 1, -4)
BaseSF.Position = UDim2.new(0, 0, 0, 2)
BaseSF.BackgroundTransparency = 1
BaseSF.BorderSizePixel = 0
BaseSF.ClipsDescendants = true
BaseSF.Visible = true
BaseSF.Parent = Privilegios
ScrollPremium = Instance.new("ScrollingFrame")
ScrollPremium.Size = UDim2.new(1, -2, 1, 0)
ScrollPremium.Position = UDim2.new(0, 0, 0, 0)
ScrollPremium.BackgroundTransparency = 1
ScrollPremium.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
ScrollPremium.ScrollBarImageTransparency = 0.5
ScrollPremium.BorderSizePixel = 0
ScrollPremium.ScrollBarThickness = 1
ScrollPremium.CanvasSize = UDim2.new(0, 0, 0, 270)
ScrollPremium.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollPremium.ClipsDescendants = false
ScrollPremium.Parent = BaseSF
Priv1 = Instance.new("ImageButton")
Priv1.Size = UDim2.new(0, 221, 0, 35)
Priv1.Position = UDim2.new(0, 7, 0, 5)
Priv1.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
Priv1.AutoButtonColor = false
Priv1.Parent = ScrollPremium
Priv2 = Instance.new("ImageButton")
Priv2.Size = UDim2.new(0, 221, 0, 35)
Priv2.Position = UDim2.new(0, 7, 0, 50)
Priv2.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
Priv2.AutoButtonColor = false
Priv2.Parent = ScrollPremium
Priv3 = Instance.new("ImageButton")
Priv3.Size = UDim2.new(0, 221, 0, 35)
Priv3.Position = UDim2.new(0, 7, 0, 95)
Priv3.BackgroundColor3 = Color3.fromRGB(72, 61, 139)
Priv3.AutoButtonColor = false
Priv3.Parent = ScrollPremium
Priv4 = Instance.new("ImageButton")
Priv4.Size = UDim2.new(0, 221, 0, 35)
Priv4.Position = UDim2.new(0, 7, 0, 140)
Priv4.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
Priv4.AutoButtonColor = false
Priv4.Parent = ScrollPremium
Priv5 = Instance.new("ImageButton")
Priv5.Size = UDim2.new(0, 221, 0, 35)
Priv5.Position = UDim2.new(0, 7, 0, 185)
Priv5.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
Priv5.AutoButtonColor = false
Priv5.Parent = ScrollPremium
Priv6 = Instance.new("ImageButton")
Priv6.Size = UDim2.new(0, 221, 0, 35)
Priv6.Position = UDim2.new(0, 7, 0, 230)
Priv6.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
Priv6.AutoButtonColor = false
Priv6.Parent = ScrollPremium
IconePriv1 = Instance.new("ImageLabel")
IconePriv1.Size = UDim2.new(0, 35, 0, 35)
IconePriv1.Position = UDim2.new(0, 0, 0, 0)
IconePriv1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv1.Image = "rbxassetid://140605327166526"
IconePriv1.Parent = Priv1
IconePriv2 = Instance.new("ImageLabel")
IconePriv2.Size = UDim2.new(0, 35, 0, 35)
IconePriv2.Position = UDim2.new(0, 0, 0, 0)
IconePriv2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv2.Image = "rbxassetid://128999640209878"
IconePriv2.Parent = Priv2
IconePriv3 = Instance.new("ImageLabel")
IconePriv3.Size = UDim2.new(0, 35, 0, 35)
IconePriv3.Position = UDim2.new(0, 0, 0, 0)
IconePriv3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv3.Image = "rbxassetid://126724539196702"
IconePriv3.Parent = Priv3
IconePriv4 = Instance.new("ImageLabel")
IconePriv4.Size = UDim2.new(0, 35, 0, 35)
IconePriv4.Position = UDim2.new(0, 0, 0, 0)
IconePriv4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv4.Image = "rbxassetid://77651842919295"
IconePriv4.Parent = Priv4
IconePriv5 = Instance.new("ImageLabel")
IconePriv5.Size = UDim2.new(0, 35, 0, 35)
IconePriv5.Position = UDim2.new(0, 0, 0, 0)
IconePriv5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv5.Image = "rbxassetid://129506682254424"
IconePriv5.Parent = Priv5
IconePriv6 = Instance.new("ImageLabel")
IconePriv6.Size = UDim2.new(0, 35, 0, 35)
IconePriv6.Position = UDim2.new(0, 0, 0, 0)
IconePriv6.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconePriv6.Image = "rbxassetid://135757623745817"
IconePriv6.Parent = Priv6
TextoPriv1 = Instance.new("TextLabel")
TextoPriv1.Size = UDim2.new(0, 160, 1, 0)
TextoPriv1.Position = UDim2.new(0, 45, 0, 0)
TextoPriv1.BackgroundTransparency = 1
TextoPriv1.Text = Traducao.Priv1
TextoPriv1.TextColor3 = Color3.fromRGB(144, 238, 144)
TextoPriv1.Font = Enum.Font.SourceSansBold
TextoPriv1.TextScaled = true
TextoPriv1.Parent = Priv1
TextoPriv2 = Instance.new("TextLabel")
TextoPriv2.Size = UDim2.new(0, 160, 1, 0)
TextoPriv2.Position = UDim2.new(0, 45, 0, 0)
TextoPriv2.BackgroundTransparency = 1
TextoPriv2.Text = Traducao.Priv2
TextoPriv2.TextColor3 = Color3.fromRGB(173, 216, 230)
TextoPriv2.Font = Enum.Font.SourceSansBold
TextoPriv2.TextScaled = true
TextoPriv2.Parent = Priv2
TextoPriv3 = Instance.new("TextLabel")
TextoPriv3.Size = UDim2.new(0, 160, 1, 0)
TextoPriv3.Position = UDim2.new(0, 45, 0, 0)
TextoPriv3.BackgroundTransparency = 1
TextoPriv3.Text = "MiniPlayer"
TextoPriv3.TextColor3 = Color3.fromRGB(186, 85, 211)
TextoPriv3.Font = Enum.Font.SourceSansBold
TextoPriv3.TextScaled = true
TextoPriv3.Parent = Priv3
TextoPriv4 = Instance.new("TextLabel")
TextoPriv4.Size = UDim2.new(0, 160, 1, 0)
TextoPriv4.Position = UDim2.new(0, 45, 0, 0)
TextoPriv4.BackgroundTransparency = 1
TextoPriv4.Text = "Roblox Audio"
TextoPriv4.TextColor3 = Color3.fromRGB(255, 99, 71)
TextoPriv4.Font = Enum.Font.SourceSansBold
TextoPriv4.TextScaled = true
TextoPriv4.Parent = Priv4
TextoPriv5 = Instance.new("TextLabel")
TextoPriv5.Size = UDim2.new(0, 160, 1, 0)
TextoPriv5.Position = UDim2.new(0, 45, 0, 0)
TextoPriv5.BackgroundTransparency = 1
TextoPriv5.Text = "Global Chat"
TextoPriv5.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoPriv5.Font = Enum.Font.SourceSansBold
TextoPriv5.TextScaled = true
TextoPriv5.Parent = Priv5
TextoPriv6 = Instance.new("TextLabel")
TextoPriv6.Size = UDim2.new(0, 160, 1, 0)
TextoPriv6.Position = UDim2.new(0, 45, 0, 0)
TextoPriv6.BackgroundTransparency = 1
TextoPriv6.Text = "Premium UI"
TextoPriv6.TextColor3 = Color3.fromRGB(139, 69, 19)
TextoPriv6.Font = Enum.Font.SourceSansBold
TextoPriv6.TextScaled = true
TextoPriv6.Parent = Priv6
local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(0, 235, 0, 78)
frame2.Position = UDim2.new(0, 6, 0, 167)
frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
frame2.BorderSizePixel = 0
frame2.Visible = false
frame2.Parent = Tela6
IconeKeyOk = Instance.new("ImageLabel")
IconeKeyOk.Size = UDim2.new(0, 40, 0, 40)
IconeKeyOk.AnchorPoint = Vector2.new(0.5, 0)
IconeKeyOk.Position = UDim2.new(0.5, 0, 0, 2)
IconeKeyOk.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeKeyOk.BackgroundTransparency = 1
IconeKeyOk.Image = "rbxassetid://132948829118667"
IconeKeyOk.Parent = frame2
PremiumOkTexto = Instance.new("TextLabel")
PremiumOkTexto.Size = UDim2.new(0, 225, 0, 30)
PremiumOkTexto.Position = UDim2.new(0, 5, 0, 44)
PremiumOkTexto.RichText = true
PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
PremiumOkTexto.TextScaled = true
PremiumOkTexto.Font = Enum.Font.SourceSansBold
PremiumOkTexto.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
PremiumOkTexto.BackgroundTransparency = 0.5
PremiumOkTexto.BorderSizePixel = 0
PremiumOkTexto.Parent = frame2
KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 235, 0, 43)
KeyFrame.Position = UDim2.new(0, 6, 0, 167)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
KeyFrame.BorderSizePixel = 0
KeyFrame.Visible = true
KeyFrame.Parent = Tela6
SendKey = Instance.new("ImageButton")
SendKey.Size = UDim2.new(0, 43, 0, 43)
SendKey.Position = UDim2.new(0, 0, 0, 0)
SendKey.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
SendKey.Parent = KeyFrame
IconeKey = Instance.new("ImageLabel")
IconeKey.Size = UDim2.new(0, 30, 0, 30)
IconeKey.Position = UDim2.new(0, 6, 0, 6)
IconeKey.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
IconeKey.BackgroundTransparency = 1
IconeKey.Image = "rbxassetid://108124574887969"
IconeKey.Parent = SendKey
KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 186, 0, 41)
KeyBox.Position = UDim2.new(0, 47, 0, 1)
KeyBox.Text = ""
KeyBox.ClearTextOnFocus = false
KeyBox.PlaceholderText = Traducao.Key
KeyBox.TextScaled = true
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.BackgroundTransparency = 1
KeyBox.Active = true
KeyBox.Parent = KeyFrame
GetKey = Instance.new("ImageButton")
GetKey.Size = UDim2.new(0, 235, 0, 26)
GetKey.Position = UDim2.new(0, 6, 0, 219)
GetKey.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
GetKey.Visible = true
GetKey.Parent = Tela6
SetaES = Instance.new("ImageButton")
SetaES.Size = UDim2.new(0, 26, 0, 26)
SetaES.Position = UDim2.new(0, 0, 0, 0)
SetaES.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
SetaES.Parent = GetKey
SetaDI = Instance.new("ImageButton")
SetaDI.Size = UDim2.new(0, 26, 0, 26)
SetaDI.Position = UDim2.new(0, 209, 0, 0)
SetaDI.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
SetaDI.Parent = GetKey
Esquerda = Instance.new("TextLabel")
Esquerda.Size = UDim2.new(0, 20, 0, 20)
Esquerda.Position = UDim2.new(0, 3, 0, 2)
Esquerda.BackgroundTransparency = 1
Esquerda.Text = "<"
Esquerda.TextColor3 = Color3.fromRGB(0, 0, 0)
Esquerda.Font = Enum.Font.SourceSansBold
Esquerda.TextSize = 25
Esquerda.Parent = SetaES
Direita = Instance.new("TextLabel")
Direita.Size = UDim2.new(0, 20, 0, 20)
Direita.Position = UDim2.new(0, 3, 0, 2)
Direita.BackgroundTransparency = 1
Direita.Text = ">"
Direita.TextColor3 = Color3.fromRGB(0, 0, 0)
Direita.Font = Enum.Font.SourceSansBold
Direita.TextSize = 25
Direita.Parent = SetaDI
GetKeyTexto = Instance.new("TextLabel")
GetKeyTexto.Size = UDim2.new(0, 165, 1, 0)
GetKeyTexto.Position = UDim2.new(0, 35, 0, 0)
GetKeyTexto.BackgroundTransparency = 1
GetKeyTexto.Text = Traducao.Link
GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
GetKeyTexto.Font = Enum.Font.SourceSansBold
GetKeyTexto.TextScaled = true
GetKeyTexto.Parent = GetKey
ReportFrame = Instance.new("Frame")
ReportFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ReportFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ReportFrame.Size = UDim2.new(0, 300, 0, 250)
ReportFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ReportFrame.BorderSizePixel = 0
ReportFrame.Visible = false
ReportFrame.Parent = screenGui
TituloReportFrame = Instance.new("Frame")
TituloReportFrame.Size = UDim2.new(0, 286, 0, 30)
TituloReportFrame.Position = UDim2.new(0, 7, 0, 6)
TituloReportFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloReportFrame.Parent = ReportFrame
TextoTituloReportFrame = Instance.new("TextLabel")
TextoTituloReportFrame.Size = UDim2.new(1, 0, 1, -4)
TextoTituloReportFrame.Position = UDim2.new(0, 0, 0, 2)
TextoTituloReportFrame.BackgroundTransparency = 1
TextoTituloReportFrame.Text = "Report"
TextoTituloReportFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloReportFrame.TextScaled = true
TextoTituloReportFrame.Font = Enum.Font.Highway
TextoTituloReportFrame.Parent = TituloReportFrame
LinhaReport = Instance.new("Frame")
LinhaReport.Size = UDim2.new(1, 0, 0, 5)
LinhaReport.Position = UDim2.new(0, 0, 0, 42)
LinhaReport.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
LinhaReport.BorderSizePixel = 0
LinhaReport.Parent = ReportFrame
TextoReportFrameFrame = Instance.new("Frame")
TextoReportFrameFrame.Size = UDim2.new(0, 286, 0, 135)
TextoReportFrameFrame.Position = UDim2.new(0, 7, 0, 54)
TextoReportFrameFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TextoReportFrameFrame.Parent = ReportFrame
TextoReportFrame = Instance.new("TextLabel")
TextoReportFrame.Size = UDim2.new(0, 276, 0, 90)
TextoReportFrame.Position = UDim2.new(0, 5, 0, 5)
TextoReportFrame.BackgroundTransparency = 1
TextoReportFrame.Text = ""
TextoReportFrame.TextXAlignment = Enum.TextXAlignment.Left
TextoReportFrame.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoReportFrame.TextScaled = true
TextoReportFrame.Font = Enum.Font.Highway
TextoReportFrame.Parent = TextoReportFrameFrame
LinhaMotivo = Instance.new("Frame")
LinhaMotivo.Size = UDim2.new(1, 0, 0, 2)
LinhaMotivo.Position = UDim2.new(0, 0, 0, 100)
LinhaMotivo.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
LinhaMotivo.BorderSizePixel = 0
LinhaMotivo.Parent = TextoReportFrameFrame
Motivo = Instance.new("Frame")
Motivo.Size = UDim2.new(0, 274, 0, 23)
Motivo.Position = UDim2.new(0, 6, 0, 107)
Motivo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Motivo.BorderSizePixel = 0
Motivo.Parent = TextoReportFrameFrame
MotivoBox = Instance.new("TextBox")
MotivoBox.Size = UDim2.new(1, -6, 1, -6)
MotivoBox.Position = UDim2.new(0, 3, 0, 3)
MotivoBox.BackgroundTransparency = 1
MotivoBox.Text = ""
MotivoBox.PlaceholderText = Traducao.MotivoReport
MotivoBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MotivoBox.Font = Enum.Font.SourceSansBold
MotivoBox.TextScaled = true
MotivoBox.ClearTextOnFocus = false
MotivoBox.Parent = Motivo
Denunciar = Instance.new("ImageButton")
Denunciar.Size = UDim2.new(0, 100, 0, 30)
Denunciar.Position = UDim2.new(0, 193, 0, 210)
Denunciar.BackgroundColor3 = Color3.fromRGB(207, 55, 52)
Denunciar.Active = true
Denunciar.Parent = ReportFrame
FotoReport = Instance.new("ImageLabel")
FotoReport.Size = UDim2.new(0, 40, 0, 40)
FotoReport.Position = UDim2.new(0, 131, 0, 200)
FotoReport.BackgroundTransparency = 1
FotoReport.Image = ""
FotoReport.Parent = ReportFrame
CancelarReport = Instance.new("ImageButton")
CancelarReport.Size = UDim2.new(0, 100, 0, 30)
CancelarReport.Position = UDim2.new(0, 7, 0, 210)
CancelarReport.BackgroundColor3 = Color3.fromRGB(127, 127, 127)
CancelarReport.Active = true
CancelarReport.Parent = ReportFrame
DenunciarTexto = Instance.new("TextLabel")
DenunciarTexto.Size = UDim2.new(1, -6, 1, -6)
DenunciarTexto.Position = UDim2.new(0, 3, 0, 3)
DenunciarTexto.BackgroundTransparency = 1
DenunciarTexto.Text = "Report"
DenunciarTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
DenunciarTexto.TextScaled = true
DenunciarTexto.Parent = Denunciar
CancelarReportTexto = Instance.new("TextLabel")
CancelarReportTexto.Size = UDim2.new(1, -6, 1, -6)
CancelarReportTexto.Position = UDim2.new(0, 3, 0, 3)
CancelarReportTexto.BackgroundTransparency = 1
CancelarReportTexto.Text = Traducao.Cancelar
CancelarReportTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CancelarReportTexto.TextScaled = true
CancelarReportTexto.Parent = CancelarReport
BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0
BlurEffect.Parent = v3
Warn = Instance.new("Frame")
Warn.AnchorPoint = Vector2.new(0.5, 0.5)
Warn.Position = UDim2.new(0.5, 0, 0.5, 0)
Warn.Size = UDim2.new(0, 300, 0, 250)
Warn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Warn.BorderSizePixel = 0
Warn.Visible = false
Warn.Parent = screenGui
TituloWarn = Instance.new("Frame")
TituloWarn.Size = UDim2.new(0, 286, 0, 30)
TituloWarn.Position = UDim2.new(0, 7, 0, 6)
TituloWarn.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TituloWarn.Parent = Warn
TextoTituloWarn = Instance.new("TextLabel")
TextoTituloWarn.Size = UDim2.new(1, 0, 1, -4)
TextoTituloWarn.Position = UDim2.new(0, 0, 0, 2)
TextoTituloWarn.BackgroundTransparency = 1
TextoTituloWarn.Text = Traducao.Aviso
TextoTituloWarn.TextColor3 = Color3.fromRGB(255, 255, 255)
TextoTituloWarn.TextScaled = true
TextoTituloWarn.Font = Enum.Font.Highway
TextoTituloWarn.Parent = TituloWarn
Linha = Instance.new("Frame")
Linha.Size = UDim2.new(1, 0, 0, 5)
Linha.Position = UDim2.new(0, 0, 0, 42)
Linha.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Linha.BorderSizePixel = 0
Linha.Parent = Warn
TextoWarnFrame = Instance.new("Frame")
TextoWarnFrame.Size = UDim2.new(0, 286, 0, 125)
TextoWarnFrame.Position = UDim2.new(0, 7, 0, 54)
TextoWarnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
TextoWarnFrame.Parent = Warn
TextoWarn = Instance.new("TextLabel")
TextoWarn.Size = UDim2.new(0, 276, 0, 115)
TextoWarn.Position = UDim2.new(0, 5, 0, 5)
TextoWarn.BackgroundTransparency = 1
TextoWarn.Text = ""
TextoWarn.TextXAlignment = Enum.TextXAlignment.Left
TextoWarn.TextColor3 = Color3.fromRGB(192, 192, 192)
TextoWarn.TextScaled = true
TextoWarn.Font = Enum.Font.Highway
TextoWarn.Parent = TextoWarnFrame
CloseWarn = Instance.new("ImageButton")
CloseWarn.Size = UDim2.new(0, 150, 0, 30)
CloseWarn.AnchorPoint = Vector2.new(0.5, 0.5)
CloseWarn.Position = UDim2.new(0.5, 0, 0, 215)
CloseWarn.BackgroundColor3 = Color3.fromRGB(207, 55, 52)
CloseWarn.BackgroundTransparency = 0
CloseWarn.Parent = Warn
CloseWarnTexto = Instance.new("TextLabel")
CloseWarnTexto.Size = UDim2.new(1, -6, 1, -6)
CloseWarnTexto.Position = UDim2.new(0, 3, 0, 3)
CloseWarnTexto.BackgroundTransparency = 1
CloseWarnTexto.Text = Traducao.FecharAviso
CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseWarnTexto.TextScaled = true
CloseWarnTexto.Parent = CloseWarn

YmpHwid = function()
	return v14
end

YmpClipboard = function(arg)
	if setclipboard_ then
		pcall(function()
			setclipboard_(arg)
		end)
	end
end

YmpRequest = function(...)
	return requestAsync(...)
end

scrolls = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }

ApiInfo = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/info?url=" .. "https://youtu.be/" .. arg)
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Author, data2.Thumbnail, data2.AuthorUrl
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(2)
	end

	return nil
end

ApiRoblox = function(arg)
	local n4 = 0

	while n4 < 8 do
		n4 += 1

		local ok3, result3, result4, result5, result6 = pcall(function()
			local response = game:HttpGet(str3 .. "/roblox?assetId=" .. tostring(arg))
			local data2 = HttpService:JSONDecode(response)
			return data2.Name, data2.Creator.Id, data2.Creator.Name, data2.Public
		end)

		if ok3 and result3 then
			return result3, result4, result5, result6
		end
		task.wait(2)
	end

	return nil
end

local flag19 = false
local flag20 = false

processQueue = function()
	if flag7 then
		return
	end
	flag7 = true

	while #tbl7 > 0 do
		table.remove(tbl7, 1)()
	end

	flag7 = false
end

FavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v17 = ok3 and result3
			local tbl12

			if v17 then
				tbl12 = v17
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for _, favorite in ipairs(favorites) do
				if favorite == arg then
					tbl6 = favorites
					return
				end
			end

			table.insert(favorites, arg)
			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

DesfavoritarFile = function(arg)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			ok3 = ok3 and result3
			local tbl12

			if ok3 then
				tbl12 = ok3
			else
				tbl12 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl12[1] = tbl12[1] or { Key = "", Favorites = {} }
			tbl12[1].Favorites = tbl12[1].Favorites or {}
			local favorites = tbl12[1].Favorites

			for i, favorite in ipairs(favorites) do
				if favorite == arg then
					table.remove(favorites, i)
					break
				end
			end

			tbl6 = favorites

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl12))
			end)
		end)

		processQueue()
	end)
end

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Favorites then
		tbl6 = data2[1].Favorites
	end
end)

local sound2 = Instance.new("Sound")
sound2.Parent = v7
sound2.Looped = false
sound2.Volume = 1
sound2.SoundId = ""
sound2.PlaybackSpeed = 1
Equalizer = Instance.new("EqualizerSoundEffect")
Equalizer.LowGain = 1
Equalizer.MidGain = 1
Equalizer.HighGain = 1
Equalizer.Parent = sound2
VolumesOriginais = {}
MuteCon = nil
Mutado = false

GlobalMute = function(arg)
	pcall(function()
		if arg then
			if Mutado then
				return
			end
			Mutado = true

			local function fn4(arg2)
				pcall(function()
					if not arg2:IsA("Sound") then
						return
					end

					if arg2 == sound2 or arg2 == sound then
						return
					end

					if VolumesOriginais[arg2] == nil then
						VolumesOriginais[arg2] = arg2.Volume
					end

					arg2.Volume = 0
				end)
			end

			for _, descendant in ipairs(game:GetDescendants()) do
				fn4(descendant)
			end

			MuteCon = game.DescendantAdded:Connect(function(descendant)
				if Mutado then
					fn4(descendant)
				end
			end)
		else
			if not Mutado then
				return
			end
			Mutado = false

			if MuteCon then
				MuteCon:Disconnect()
				MuteCon = nil
			end

			for k, v17 in pairs(VolumesOriginais) do
				pcall(function()
					if k and k.Parent and k ~= sound2 then
						k.Volume = v17
					end
				end)
			end

			table.clear(VolumesOriginais)
		end
	end)
end

Mutar.MouseButton1Click:Connect(function()
	if Mutar.Image == "rbxassetid://109518972658686" then
		Mutar.Image = "rbxassetid://139303337799549"
		fn3(Traducao.Mutado, Traducao.SobreMute, 5)
		GlobalMute(true)
	else
		Mutar.Image = "rbxassetid://109518972658686"
		fn3(Traducao.Desmutado, Traducao.SobreUnmute, 5)
		GlobalMute(false)
	end
end)

BibliotecaMusicas = {}
BilbliotecaVideos = {}
BibliotecaRoblox = {}
BibliotecaLocal = {}
Girando = false
Congelado = false
GiroBackup = 1
GiroSpeed = 1

Girar = function(arg)
	if arg then
		Girando = true
		Congelado = false
	else
		Girando = false
		Disco.Rotation = 0
		Congelado = false
	end
end

SetFreeze = function(arg)
	Congelado = arg
end

task.spawn(function()
	while true do
		if Girando and not Congelado and GiroSpeed > 0 then
			local v17 = Disco
			v17.Rotation = v17.Rotation + GiroSpeed
		end

		task.wait(0.02)
	end
end)

formatar = function(arg)
	local n4 = math.floor(arg / 60)
	local n5 = math.floor(arg % 60)
	return string.format("%02d:%02d", n4, n5)
end

Reset = function()
	Rastro.Size = UDim2.new(0, 0, 1, 0)
	BolaProgresso.AnchorPoint = Vector2.new(0, 0.5)
	BolaProgresso.Position = UDim2.new(0, 0, 0.5, 0)
	TimerAtual.Text = "00:00"
end

setProgress = function(arg)
	local n4 = math.clamp(arg, 0, 1)
	Rastro.Size = UDim2.new(n4, 0, 1, 0)
	BolaProgresso.AnchorPoint = Vector2.new(n4, 0.5)
	BolaProgresso.Position = UDim2.new(n4, 0, 0.5, 0)
end

getProgress = function(arg)
	local x = BarraProgresso.AbsolutePosition.X
	local x2 = BarraProgresso.AbsoluteSize.X
	if x2 <= 0 then
		return 0
	end
	return math.clamp((arg - x) / x2, 0, 1)
end

seek = function(arg)
	local v17 = v12
	local flag21 = v12

	if v17 then
		flag21 = v17.TimeLength > 0
	end

	if flag21 then
		TimerAtual.Text = formatar(arg * v17.TimeLength)
	end
end

BarraProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
			local v18 = getProgress(input.Position.X)
			setProgress(v18)
			seek(v18)
		end
	end
end)

BolaProgresso.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and flag9 then
			flag8 = true
		end
	end
end)

v9.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if flag8 then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local timeLength = v17.TimeLength
				v17.TimePosition = math.clamp(getProgress(input.Position.X), 0, 0.999) * timeLength
			end

			flag8 = false
		end
	end
end)

v9.InputChanged:Connect(function(input)
	if flag8 then
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local v17 = v12
			local flag21 = v12

			if v17 then
				flag21 = v17.TimeLength > 0
			end

			if flag21 and flag9 then
				local n4 = math.clamp(getProgress(input.Position.X), 0, 0.999)
				setProgress(n4)
				seek(n4)
			end
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		local v17 = v12
		local flag21 = v12

		if v17 then
			flag21 = v17.TimeLength > 0
		end

		if flag21 and not flag8 then
			local timePosition = v17.TimePosition
			setProgress(timePosition / v17.TimeLength)
			TimerAtual.Text = formatar(timePosition)
		end
	end
end)

Equalizador = function(arg)
	if arg == true then
		EquaFrame.Size = UDim2.new(0, 235, 0, 187)
		NoEquaFrame.Visible = false
		ScrollEqua.ScrollingEnabled = true
	else
		EquaFrame.Size = UDim2.new(0, 235, 0, 49)
		NoEquaFrame.Visible = true
		ScrollEqua.CanvasPosition = Vector2.new(0, 0)
		ScrollEqua.ScrollingEnabled = false
	end
end

Selecionar = function(arg, arg2)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal, ScrollPesquisa }
	local v17 = nil

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				local v19 = string.split(child.Name, ":")
				if v19[1] == arg2 and v19[2] == arg then
					v17 = child
					break
				end
			end
		end

		if not v17 then
			continue
		end
		break
	end

	if not v17 then
		return
	end

	local function fn4(arg3)
		local imageLabel = arg3:FindFirstChildOfClass("ImageLabel")
		arg3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end

		Stroke(arg3, 50, 50, 50, 2)

		for _, child in ipairs(arg3:GetChildren()) do
			if child:IsA("ImageButton") then
				Stroke(child, 50, 50, 50, 2)
			end
		end
	end

	if BotaoSelecionadoAtual == v17 then
		for _, v18 in ipairs(tbl12) do
			for _, child in ipairs(v18:GetChildren()) do
				if child:IsA("ImageButton") then
					fn4(child)
				end
			end
		end

		BotaoSelecionadoAtual = nil
		return
	end

	for _, v18 in ipairs(tbl12) do
		for _, child in ipairs(v18:GetChildren()) do
			if child:IsA("ImageButton") then
				fn4(child)
			end
		end
	end

	local imageLabel = v17:FindFirstChildOfClass("ImageLabel")
	v17.BackgroundColor3 = Color3.fromRGB(139, 0, 0)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	Stroke(v17, 255, 0, 0, 2)

	for _, child in ipairs(v17:GetChildren()) do
		if child:IsA("ImageButton") then
			Stroke(child, 255, 0, 0, 2)
		end
	end

	BotaoSelecionadoAtual = v17
end

CurrentMediaId = nil
thumbAtual = nil
BloquearMidia = false

resetSound = function(arg)
	if arg then
		pcall(function()
			arg:Stop()
			arg.SoundId = ""
			arg.TimePosition = 0
		end)
	end
end

resetVideo = function(arg)
	if arg then
		pcall(function()
			arg:Pause()
			arg.Video = ""
			arg.TimePosition = 0
		end)
	end
end

local function fn4(arg, arg2)
	if not arg2 or not arg then
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end
	resetSound(sound2)
	resetVideo(Video)
	resetVideo(MiniVideo)
	BloquearMidia = true
	local n4 = math.random()
	CurrentRequestId = n4
	task.wait(0.05)
	CurrentMediaId = arg2
	thumbAtual = nil
	local currentPlaying = arg .. ":" .. arg2
	Selecionar(arg, arg2)
	local visible = imageButton2.Visible

	if _G.CurrentPlaying == currentPlaying then
		_G.CurrentPlaying = nil
		Reset()
		Play.Image = "rbxassetid://110560238983134"
		MiniPlay.Image = "rbxassetid://119936293795425"
		flag9 = false
		Girar(false)
		Equalizador(true)
		GiroSpeed = GiroBackup
		BloquearMidia = false

		if visible then
			Musica.Image = "rbxassetid://109021809317392"
		else
			Musica.Image = "rbxassetid://120329190202259"
		end

		Musica.ImageRectOffset = Vector2.new(0, 0)
		Musica.ImageRectSize = Vector2.new(0, 0)
		MiniMusica.Image = "rbxassetid://120329190202259"
		MiniMusica.ImageRectOffset = Vector2.new(0, 0)
		MiniMusica.ImageRectSize = Vector2.new(0, 0)
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = false
		MiniVideo.Visible = false
		TimerTotal.Text = "00:00"
		FotoAutor.Image = "rbxassetid://130243480255582"
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Hey .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Play .. "</font>"
		return
	end

	_G.CurrentPlaying = currentPlaying
	Play.Image = "rbxassetid://80704722265943"
	MiniPlay.Image = "rbxassetid://110232191351528"
	flag9 = true

	if sound2 then
		pcall(function()
			sound2:Stop()
			sound2.TimePosition = 0
		end)
	end

	if Video then
		pcall(function()
			Video:Pause()
			Video.TimePosition = 0
		end)
	end

	if MiniVideo then
		pcall(function()
			MiniVideo:Pause()
			MiniVideo.TimePosition = 0
		end)
	end

	local function fn5(arg3)
		v12 = arg3 and (visible and MiniVideo or Video) or sound2
		Musica.Visible = true
		MiniMusica.Visible = true
		Video.Visible = arg3 and not visible
		MiniVideo.Visible = arg3 and visible
	end

	local function fn6(arg3, arg4)
		return "<font color=\"rgb(255,255,255)\">" .. arg3 .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. arg4 .. "</font>"
	end

	local function fn7(arg3)
		local n5 = math.floor(arg3 or 0)
		return string.format("%02d:%02d", math.floor(n5 / 60), n5 % 60)
	end

	local function fn8(arg3)
		local ok3, result3 = pcall(function()
			return getcustomasset(arg3)
		end)

		if ok3 and typeof(result3) == "string" then
			return result3
		end
		return nil
	end

	local function fn9(arg3, arg4)
		local str6 = "YouTube Music Player/Internal/Cache/" .. arg4 .. ".png"
		if isfile(str6) then
			return fn8(str6)
		end

		local ok3 = pcall(function()
			local response = game:HttpGet(arg3)
			if not response or typeof(response) ~= "string" or #response < 50 then
				return
			end
			writefile(str6, response)
		end)

		task.wait(0.08)
		if not ok3 or not isfile(str6) then
			return nil
		end
		return fn8(str6)
	end

	local function fn10()
		if arg == "Musica" then
			for _, v17 in ipairs(BibliotecaMusicas) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Video" then
			for _, v17 in ipairs(BilbliotecaVideos) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Roblox" then
			for _, v17 in ipairs(BibliotecaRoblox) do
				if v17.id == arg2 then
					return v17
				end
			end
		elseif arg == "Local" then
			for _, v17 in ipairs(BibliotecaLocal) do
				if v17.name == arg2 then
					return v17
				end
			end
		end
	end

	local v17 = fn10()
	if not v17 then
		return
	end
	TimerTotal.Text = "00:00"
	Girar(true)

	if arg == "Musica" or arg == "Video" then
		fn5(arg == "Video")
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://108154884074176"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		FotoAutor.Image = "rbxassetid://108154884074176"
		TituloMusica.Text = fn6(v17.name, v17.author)

		task.spawn(function()
			task.wait(0.05)
			if CurrentRequestId ~= n4 then
				return
			end
			local authorUrl = v17.authorUrl and fn9(v17.authorUrl, "author_" .. arg2)
			if CurrentRequestId ~= n4 then
				return
			end
			FotoAutor.Image = authorUrl or "rbxassetid://106804518898726"

			if arg == "Musica" and v17.thumb then
				local v19 = fn9(v17.thumb, "thumb_" .. arg2)
				if CurrentRequestId ~= n4 then
					return
				end

				if v19 then
					v18.Image = v19
					thumbAtual = v19
					v18.ImageRectOffset = Vector2.new(0, 45)
					v18.ImageRectSize = Vector2.new(480, 270)
				else
					v18.Image = "rbxassetid://110787075859454"
					v18.ImageRectOffset = Vector2.new(0, 0)
					v18.ImageRectSize = Vector2.new(0, 0)
				end
			end

			BloquearMidia = false
		end)

		if arg == "Musica" then
			pcall(function()
				sound2.SoundId = getcustomasset("YouTube Music Player/Musics/" .. arg2 .. ".mp3")
				sound2:Play()
				Equalizador(true)
				GiroSpeed = GiroBackup

				task.spawn(function()
					local n5 = 0

					while sound2.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(sound2.TimeLength)
				end)
			end)
		else
			pcall(function()
				local v19 = getcustomasset("YouTube Music Player/Videos/" .. arg2 .. ".webm")
				local v20 = visible and MiniVideo or Video
				v20.Video = v19
				v20:Play()
				Equalizador(false)
				GiroSpeed = 1

				task.spawn(function()
					local n5 = 0

					while v20.TimeLength == 0 and n5 < 5 do
						n5 += task.wait(0.1)
					end

					if CurrentRequestId ~= n4 then
						return
					end
					TimerTotal.Text = fn7(v20.TimeLength)
				end)
			end)
		end
	elseif arg == "Roblox" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://100415102639682"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. v17.name .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.De .. " " .. v17.creatorName .. "</font>"
		FotoAutor.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. v17.creatorId .. "&width=420&height=420&format=png"

		pcall(function()
			sound2.SoundId = "rbxassetid://" .. arg2
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	elseif arg == "Local" then
		fn5(false)
		local v18 = visible and MiniMusica or Musica
		v18.Image = "rbxassetid://84131152943912"
		v18.ImageRectOffset = Vector2.new(0, 0)
		v18.ImageRectSize = Vector2.new(0, 0)
		TituloMusica.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.In .. " " .. Traducao.LocalTitle .. "</font>"
		FotoAutor.Image = "rbxassetid://99316239950686"

		pcall(function()
			sound2.SoundId = getcustomasset("YouTube Music Player/Local Audios/" .. arg2 .. ".mp3")
			sound2:Play()
			Equalizador(true)
			GiroSpeed = GiroBackup

			task.spawn(function()
				local n5 = 0

				while sound2.TimeLength == 0 and n5 < 5 do
					n5 += task.wait(0.1)
				end

				if CurrentRequestId ~= n4 then
					return
				end
				TimerTotal.Text = fn7(sound2.TimeLength)
			end)
		end)

		BloquearMidia = false
	end
end

SetMiniPlayer = function(visible)
	imageButton2.Visible = visible

	local function fn5(arg)
		if arg then
			pcall(function()
				arg:Pause()
				arg:Stop()
				arg.Video = nil
			end)
		end
	end

	local function fn6(arg)
		local v17 = nil

		pcall(function()
			v17 = getcustomasset(arg)
		end)

		return v17
	end

	local function fn7(arg, arg2)
		if not arg then
			return
		end

		if arg2 then
			arg.ImageRectOffset = Vector2.new(0, 45)
			arg.ImageRectSize = Vector2.new(480, 270)
		else
			arg.ImageRectOffset = Vector2.new(0, 0)
			arg.ImageRectSize = Vector2.new(0, 0)
		end
	end

	local function fn8(arg)
		if arg == "rbxassetid://108154884074176" then
			return "loading"
		end

		if arg == "rbxassetid://110787075859454" then
			return "empty"
		end

		if arg == "rbxassetid://84131152943912" then
			return "special"
		end

		if arg == "rbxassetid://109021809317392" then
			return "mini"
		end

		if arg == "rbxassetid://100415102639682" then
			return "roblox"
		end
		return "default"
	end

	local function fn9(arg, arg2)
		if arg2 == "loading" then
			arg.Image = "rbxassetid://108154884074176"
			fn7(arg, false)
		elseif arg2 == "empty" then
			arg.Image = "rbxassetid://110787075859454"
			fn7(arg, false)
		elseif arg2 == "special" then
			arg.Image = "rbxassetid://84131152943912"
			fn7(arg, false)
		elseif arg2 == "mini" then
			arg.Image = "rbxassetid://109021809317392"
			fn7(arg, false)
		elseif arg2 == "roblox" then
			arg.Image = "rbxassetid://100415102639682"
			fn7(arg, false)
		else
			arg.Image = "rbxassetid://120329190202259"
			fn7(arg, false)
		end
	end

	if visible then
		if Musica then
			Musica.Visible = true
			local v17 = fn8(Musica.Image)
			fn9(MiniMusica, v17)
			Musica.Image = "rbxassetid://109021809317392"
			fn7(Musica, false)
		end

		if MiniMusica then
			MiniMusica.Visible = true

			if thumbAtual then
				MiniMusica.Image = thumbAtual
				fn7(MiniMusica, true)
				Musica.Image = "rbxassetid://109021809317392"
				fn7(Musica, false)
			end
		end

		if Video and Video.Visible then
			local timePosition = Video.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(Video)

			if MiniVideo and v17 then
				fn5(MiniVideo)
				MiniVideo.Visible = true
				MiniVideo.Video = v17
				MiniVideo.TimePosition = timePosition
				MiniVideo:Play()
				v12 = MiniVideo
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end

			Video.Visible = false
		elseif MiniVideo and MiniVideo.Visible then
			Video.Visible = false
		end
	else
		if MiniVideo and MiniVideo.Visible then
			local timePosition = MiniVideo.TimePosition
			local v17 = fn6("YouTube Music Player/Videos/" .. CurrentMediaId .. ".webm")
			fn5(MiniVideo)

			if Video and v17 then
				fn5(Video)
				Video.Visible = true
				Video.Video = v17
				Video.TimePosition = timePosition
				Video:Play()
				v12 = Video
				Play.Image = "rbxassetid://80704722265943"
				MiniPlay.Image = "rbxassetid://110232191351528"
			end
		end

		if Musica then
			Musica.Visible = true

			if MiniMusica then
				MiniMusica.Visible = true
			end

			if MiniMusica then
				local v17 = fn8(MiniMusica.Image)
				fn9(Musica, v17)

				if thumbAtual then
					Musica.Image = thumbAtual
					fn7(Musica, true)
				end
			end
		end
	end
end

SortMedia = function(arg, arg2)
	local attribute = arg:GetAttribute("Build")
	local attribute2 = arg2:GetAttribute("Build")
	if attribute and not attribute2 then
		return true
	end

	if attribute2 and not attribute then
		return false
	end
	local tag = arg:FindFirstChild("tag")
	local tag2 = arg2:FindFirstChild("tag")

	if tag then
		tag = tag.Text:match("^%s*(.-)%s*$"):lower()
	end

	tag = tag or ""

	if tag2 then
		tag2 = tag2.Text:match("^%s*(.-)%s*$"):lower()
	end

	return tag < (tag2 or "")
end

GetScrollAtual = function()
	for _, v17 in ipairs(scrolls) do
		if v17.Visible then
			return v17
		end
	end
end

GetLista = function(arg)
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("ImageButton") then
			if not child:GetAttribute("Privado") then
				local match, v17 = child.Name:match("(.+):(.+)")

				if match and v17 then
					if not ((v17 == "Video" or v17 == "Roblox") and not flag19) then
						table.insert(tbl12, child)
					end
				end
			end
		end
	end

	table.sort(tbl12, SortMedia)
	return tbl12
end

GetSelecionado = function(arg)
	for _, v17 in ipairs(arg) do
		if v17.BackgroundColor3 == Color3.fromRGB(139, 0, 0) then
			return v17
		end
	end
end

PlayBtn = function(arg)
	local match, v17 = arg.Name:match("(.+):(.+)")

	if match and v17 then
		fn4(v17, match)
	end
end

Pause = function()
	if not v12 or not flag9 then
		return
	end

	if v12:IsA("Sound") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Resume()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	elseif v12:IsA("VideoFrame") then
		if v12.Playing then
			v12:Pause()
			Play.Image = "rbxassetid://110560238983134"
			MiniPlay.Image = "rbxassetid://119936293795425"
			SetFreeze(true)
		else
			v12:Play()
			Play.Image = "rbxassetid://80704722265943"
			MiniPlay.Image = "rbxassetid://110232191351528"
			SetFreeze(false)
		end
	end
end

Avancar10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition + 10

	if v17.TimeLength < timePosition then
		timePosition = v17.TimeLength
	end

	v17.TimePosition = timePosition
end

Retroceder10s = function()
	if not v12 or not flag9 then
		return
	end
	local v17 = v12
	if v17.TimeLength <= 0 then
		return
	end
	local timePosition = v17.TimePosition - 10

	if timePosition < 0 then
		timePosition = 0
	end

	v17.TimePosition = timePosition
end

Skip = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 + 1

	if n4 > #v18 then
		n4 = 1
	end

	PlayBtn(v18[n4])
end

Back = function()
	local v17 = GetScrollAtual()
	if not v17 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end
	local v18 = GetLista(v17)
	if #v18 == 0 then
		fn3(Traducao.Erro, Traducao.NenhumaMidia, 5)
		return
	end

	if #v18 == 1 then
		if v18[1].BackgroundColor3 ~= Color3.fromRGB(139, 0, 0) then
			PlayBtn(v18[1])
		end

		return
	end

	local v19 = GetSelecionado(v18)
	if not v19 then
		PlayBtn(v18[1])
		return
	end
	local v20 = nil

	for i, v21 in ipairs(v18) do
		if v21 == v19 then
			v20 = i
			break
		else
			v20 = nil
		end
	end

	local n4 = v20 - 1

	if n4 < 1 then
		n4 = #v18
	end

	PlayBtn(v18[n4])
end

EscolherRandom = function(arg)
	local tbl12 = {}
	local v17 = GetSelecionado(arg)

	for _, v18 in ipairs(arg) do
		if v18 ~= v17 and not tbl5[v18] then
			table.insert(tbl12, v18)
		end
	end

	if #tbl12 == 0 then
		tbl5 = {}

		for _, v18 in ipairs(arg) do
			if v18 ~= v17 then
				table.insert(tbl12, v18)
			end
		end
	end

	if #tbl12 == 0 then
		return v17
	end
	local v18 = tbl12[math.random(1, #tbl12)]
	tbl5[v18] = true
	return v18
end

HandleEnded = function(arg)
	if str4 == "nill" then
		return
	end
	task.wait()
	arg.Looped = false
	local v17 = GetScrollAtual()

	if v17 ~= v11 then
		tbl5 = {}
		v11 = v17
	end

	if not v17 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v18 = GetLista(v17)

	if #v18 == 0 then
		fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
		v12.TimePosition = 0
		v12:Play()
		return
	end

	local v19 = GetSelecionado(v18)

	if v19 then
		tbl5[v19] = true
	end

	if #v18 == 1 then
		if not v19 then
			PlayBtn(v18[1])
		else
			fn3(Traducao.PlayMode, Traducao.PlayModeRepetir, 5)
			v12.TimePosition = 0
			v12:Play()
		end

		return
	end

	if str4 == "Random" then
		local v20 = EscolherRandom(v18)

		if v20 then
			PlayBtn(v20)
		end

		return
	end

	Skip()
end

sound2.Ended:Connect(function()
	HandleEnded(sound2)
end)

Video.Ended:Connect(function()
	if Video and Video.Visible then
		HandleEnded(Video)
	end
end)

MiniVideo.Ended:Connect(function()
	if MiniVideo and MiniVideo.Visible then
		HandleEnded(MiniVideo)
	end
end)

Deletar = function(arg, arg2)
	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if _G.CurrentPlaying then
		local match, v17 = _G.CurrentPlaying:match("^(.-)%:(.+)$")

		if v17 == arg then
			fn4(match, v17)
		end
	end

	local tbl12 = {
		"YouTube Music Player/Internal/Cache/author_" .. arg .. ".png",
		"YouTube Music Player/Internal/Cache/thumb_" .. arg .. ".png",
	}

	for _, v17 in ipairs({
		"YouTube Music Player/Musics/" .. arg .. ".mp3",
		"YouTube Music Player/Videos/" .. arg .. ".webm",
		"YouTube Music Player/Roblox IDS/" .. arg .. ".rbx",
		"YouTube Music Player/Local Audios/" .. arg .. ".mp3",
	}) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for _, v17 in ipairs(tbl12) do
		if isfile(v17) then
			delfile(v17)
		end
	end

	for i = #BibliotecaMusicas, 1, -1 do
		if BibliotecaMusicas[i].id == arg then
			table.remove(BibliotecaMusicas, i)
		end
	end

	for i = #BilbliotecaVideos, 1, -1 do
		if BilbliotecaVideos[i].id == arg then
			table.remove(BilbliotecaVideos, i)
		end
	end

	for i = #BibliotecaRoblox, 1, -1 do
		if BibliotecaRoblox[i].id == arg then
			table.remove(BibliotecaRoblox, i)
		end
	end

	for i = #BibliotecaLocal, 1, -1 do
		if BibliotecaLocal[i].name == arg then
			table.remove(BibliotecaLocal, i)
		end
	end

	DesfavoritarFile(arg)
	fn3(Traducao.Excluido, arg2, 8)

	local function fn5(arg3)
		for _, child in ipairs(arg3:GetChildren()) do
			local name = child:IsA("ImageButton") and child.Name and arg

			if name then
				local str6 = arg .. ":"
				name = child.Name:sub(1, #arg + 1) == str6
			end

			if name then
				child:Destroy()
			end
		end
	end

	task.wait(0.1)
	fn5(ScrollTodos)
	fn5(ScrollMusicas)
	fn5(ScrollVideos)
	fn5(ScrollRoblox)
	fn5(ScrollLocal)
	fn5(ScrollFav)
	fn5(ScrollPesquisa)
end

-- https://discord.gg/AwGHNh7Z7T
local function fn5(text2, arg, arg2, arg3)
	local tbl12 = {}
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Name = arg2 .. ":" .. arg
	imageButton3.Size = UDim2.new(0, 148, 0, 35)
	imageButton3.Position = UDim2.new(0, 5, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton3.BackgroundTransparency = 0
	imageButton3.AutoButtonColor = false
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 35, 0, 35)
	imageLabel.Position = UDim2.new(0, 0, 0, 0)
	imageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageLabel.BackgroundTransparency = 0
	local v17 = ScrollTodos
	local v18

	if arg == "Musica" then
		imageLabel.Image = "rbxassetid://136933987460149"

		if str2 == "Musicas" then
			v18 = ScrollMusicas
		else
			v18 = v17
		end
	elseif arg == "Video" then
		imageLabel.Image = "rbxassetid://105308603886068"

		if str2 == "Videos" then
			v18 = ScrollVideos
		else
			v18 = v17
		end
	elseif arg == "Roblox" then
		imageLabel.Image = "rbxassetid://118724747640040"

		if str2 ~= "Roblox" then
			v18 = v17
		else
			v18 = ScrollRoblox
		end
	elseif arg == "Local" then
		imageLabel.Image = "rbxassetid://93635917640466"

		if str2 ~= "Local" then
			v18 = v17
		else
			v18 = ScrollLocal
		end
	else
		v18 = v17
	end

	imageButton3.Parent = v18
	imageLabel.Parent = imageButton3
	imageLabel.ImageTransparency = 0
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 107, 1, 0)
	textLabel.Position = UDim2.new(0, 38, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextScaled = true
	textLabel.TextWrapped = true
	textLabel.Name = "tag"
	textLabel.Text = text2
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 35, 0, 35)
	imageButton4.Position = UDim2.new(1, 8, 0, 0)
	imageButton4.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton4.Parent = imageButton3
	local v19 = ipairs
	local v20 = tbl6
	local tbl13

	if tbl6 then
		tbl13 = v20
	else
		tbl13 = {}
	end

	local flag21 = false

	for _, v21 in v19(tbl13) do
		if v21 == arg2 then
			flag21 = true
			break
		end
	end

	if flag21 then
		imageButton4.Image = "rbxassetid://122765197997575"
	else
		imageButton4.Image = "rbxassetid://102097543764342"
	end

	local imageButton5 = Instance.new("ImageButton")
	imageButton5.Size = UDim2.new(0, 35, 0, 35)
	imageButton5.Position = UDim2.new(1, 51, 0, 0)
	imageButton5.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton5.BackgroundTransparency = 0
	imageButton5.Image = "rbxassetid://125370105968945"
	imageButton5.Parent = imageButton3

	if arg2 == "LvvrO6JifEA" then
		imageButton5.ImageTransparency = 0.8
		imageButton5.Active = false
		imageButton3:SetAttribute("Build", true)
	end

	Corner(imageButton3, 5)
	Corner(imageLabel, 5)
	Corner(imageButton4, 5)
	Corner(imageButton5, 5)
	Stroke(imageButton3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton4, 50, 50, 50, 2)
	Stroke(imageButton5, 50, 50, 50, 2)

	if arg == "Roblox" and arg3 == false then
		imageButton3:SetAttribute("Privado", true)
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	end

	if (arg == "Video" or arg == "Roblox") and not flag19 then
		imageButton3.BackgroundTransparency = 0.9
		imageLabel.BackgroundTransparency = 0.9
		imageLabel.ImageTransparency = 0.9
		textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	end

	tbl12[#tbl12 + 1] = imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" and arg3 == false then
			fn3(Traducao.Erro, Traducao.Privado, 10)
			return
		end

		if (arg == "Video" or arg == "Roblox") and not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		else
			fn4(arg, arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton4.MouseButton1Click:Connect(function()
		if imageButton4.Image == "rbxassetid://122765197997575" then
			imageButton4.Image = "rbxassetid://102097543764342"
			fn3(Traducao.Desfavoritado, text2, 8)
			DesfavoritarFile(arg2)

			if str2 == "Favoritos" then
				local v21 = ScrollTodos

				if arg == "Musica" then
					v21 = ScrollMusicas
				elseif arg == "Video" then
					v21 = ScrollVideos
				elseif arg == "Roblox" then
					v21 = ScrollRoblox
				end

				if imageButton3.Parent ~= v21 then
					imageButton3.Parent = v21
				end
			end
		else
			imageButton4.Image = "rbxassetid://122765197997575"
			fn3(Traducao.Favoritado, text2, 8)
			FavoritarFile(arg2)
		end
	end)

	tbl12[#tbl12 + 1] = imageButton5.MouseButton1Click:Connect(function()
		if not imageButton5.Active then
			return
		end
		Deletar(arg2, textLabel.Text)
	end)

	imageButton3.Destroying:Connect(function()
		for _, v21 in ipairs(tbl12) do
			pcall(function()
				v21:Disconnect()
			end)
		end

		tbl12 = {}
	end)
end

Parent = function(arg)
	local tbl12 = {}

	local v17 = ({
		Musica = ScrollMusicas,
		Video = ScrollVideos,
		Roblox = ScrollRoblox,
		Local = ScrollLocal,
		Todos = ScrollTodos,
		Favoritos = ScrollFav,
	})[arg]

	if not v17 then
		return
	end

	for i = 1, #scrolls do
		local children = scrolls[i]:GetChildren()

		for i2 = 1, #children do
			local v18 = children[i2]

			if v18:IsA("GuiObject") then
				tbl12[#tbl12 + 1] = v18
			end
		end
	end

	if arg == "Todos" then
		for i = 1, #tbl12 do
			tbl12[i].Parent = v17
		end
	elseif arg == "Favoritos" then
		local v18 = tbl6

		for i = 1, #tbl12 do
			local v19 = tbl12[i]
			local match = v19.Name:match("^(.-):")

			if table.find(v18, match) then
				v19.Parent = v17
			end
		end
	else
		for i = 1, #tbl12 do
			local v18 = tbl12[i]
			local match, v19 = v18.Name:match("^(.-):(.+)$")

			if v19 == arg then
				v18.Parent = v17
			end
		end
	end

	v17.CanvasPosition = Vector2.zero
end

AtualizarScroll = function(arg)
	if arg == ScrollLocal and #arg:GetChildren() == 0 then
		arg.Visible = false
		VazioLocal.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.LocalTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.LocalText .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		Vazio.Visible = false
		return
	end

	if #arg:GetChildren() > 0 then
		arg.Visible = true
		Vazio.Visible = false
		VazioLocal.Visible = false
		ErroPL.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
	else
		arg.Visible = false
		Vazio.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Vazio .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.VazioTexto .. "</font>"
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = false
		VazioLocal.Visible = false
	end
end

Abas = {
	Todos = {
		parent = "Todos",
		text = function()
			return Traducao.Todos
		end,
		scroll = ScrollTodos,
	},
	Musicas = {
		parent = "Musica",
		text = function()
			return Traducao.Musicas
		end,
		scroll = ScrollMusicas,
	},
	Videos = {
		parent = "Video",
		text = function()
			return "Videos"
		end,
		scroll = ScrollVideos,
	},
	Roblox = {
		parent = "Roblox",
		text = function()
			return "Roblox IDS"
		end,
		scroll = ScrollRoblox,
	},
	Favoritos = {
		parent = "Favoritos",
		text = function()
			return Traducao.Favoritos
		end,
		scroll = ScrollFav,
	},
	Local = {
		parent = "Local",
		text = function()
			return Traducao.LocalTitle
		end,
		scroll = ScrollLocal,
	},
}

Ordem = { "Todos", "Musicas", "Videos", "Roblox", "Favoritos", "Local", "Pesquisar" }

OcultarScrolls = function()
	ScrollTodos.Visible = false
	ScrollMusicas.Visible = false
	ScrollVideos.Visible = false
	ScrollRoblox.Visible = false
	ScrollFav.Visible = false
	ScrollLocal.Visible = false
	ScrollPesquisa.Visible = false
end

ToTab = function(arg)
	str2 = arg
	OcultarScrolls()

	if arg == "Pesquisar" then
		AbaPL.Visible = false
		PesquisaPL.Visible = true
		AguardandoPL.Visible = true
		Vazio.Visible = false
		ErroPL.Visible = true
		PesquisaPL.Text = ""
		VazioLocal.Visible = false
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local v17 = Abas[arg]
	if not v17 then
		return
	end
	Parent(v17.parent)
	AbaPL.Text = v17.text()
	AbaPL.Visible = true
	PesquisaPL.Visible = false
	AtualizarScroll(v17.scroll)
end

ProximaAba = function(arg)
	local v17 = nil

	for i, v18 in ipairs(Ordem) do
		if v18 == str2 then
			v17 = i
			break
		else
			v17 = nil
		end
	end

	if not v17 then
		return
	end
	local n4 = v17 + arg

	if #Ordem < n4 then
		n4 = 1
	end

	if n4 < 1 then
		n4 = #Ordem
	end

	return Ordem[n4]
end

DireitaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(1))
end)

EsquerdaPL.MouseButton1Click:Connect(function()
	fn2("88442833509532")
	ToTab(ProximaAba(-1))
end)

OrganizarSF = function(arg)
	task.wait()
	local tbl12 = {}

	for _, child in ipairs(arg:GetChildren()) do
		if child:IsA("GuiObject") then
			table.insert(tbl12, child)
		end
	end

	table.sort(tbl12, SortMedia)
	local n4 = 5

	for _, v17 in ipairs(tbl12) do
		v17.Position = UDim2.new(0, 5, 0, n4)
		n4 = n4 + v17.Size.Y.Offset + 10
	end

	arg.CanvasSize = UDim2.new(0, 243, 0, math.max(n4 - 6, 0))
end

Pesquisando = false

PesquisarPL = function(arg)
	local tbl12 = { ScrollTodos, ScrollMusicas, ScrollVideos, ScrollRoblox, ScrollFav, ScrollLocal }
	ScrollPesquisa.CanvasPosition = Vector2.new(0, 0)
	Pesquisando = true

	for _, child in ipairs(ScrollPesquisa:GetChildren()) do
		if child:IsA("ImageButton") then
			child.Parent = ScrollTodos
		end
	end

	Pesquisando = false

	if not arg or arg:match("^%s*$") then
		ScrollPesquisa.Visible = false
		SemResultadoPL.Visible = false
		AguardandoPL.Visible = true
		ErroPL.Visible = true
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseTextPL .. "</font>"
		return
	end

	local str6 = arg:lower()
	local visible = false

	for _, v17 in ipairs(tbl12) do
		for _, child in ipairs(v17:GetChildren()) do
			if child:IsA("GuiObject") then
				local tag = child:FindFirstChild("tag")

				if tag and tag.Text then
					if string.find(tag.Text:lower(), str6, 1, true) then
						child.Parent = ScrollPesquisa
						visible = true
					end
				end
			end
		end
	end

	ScrollPesquisa.Visible = visible
	AguardandoPL.Visible = false
	local visible2 = not visible
	SemResultadoPL.Visible = visible2
	ErroPL.Visible = visible2

	if visible2 then
		ErroPL.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.SemResutadoTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.SemResutadoTextPL .. "</font>"
	end
end

Scrolls = {
	Todos = ScrollTodos,
	Musicas = ScrollMusicas,
	Videos = ScrollVideos,
	Roblox = ScrollRoblox,
	Favoritos = ScrollFav,
	Local = ScrollLocal,
}

ConectarScroll = function(arg, arg2)
	arg2.ChildAdded:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)

	arg2.ChildRemoved:Connect(function()
		OrganizarSF(arg2)

		if str2 == arg then
			AtualizarScroll(arg2)
		end
	end)
end

for k, v17 in pairs(Scrolls) do
	ConectarScroll(k, v17)
end

ScrollPesquisa.ChildAdded:Connect(function()
	OrganizarSF(ScrollPesquisa)
end)

ScrollPesquisa.ChildRemoved:Connect(function()
	if ScrollPesquisa.Visible and not Pesquisando then
		PesquisarPL(PesquisaPL.Text)
	end
end)

PesquisaPL.Focused:Connect(function()
	PesquisarPL()
end)

PesquisaPL.FocusLost:Connect(function()
	local match = PesquisaPL.Text:match("^%s*(.-)%s*$")
	PesquisaPL.Text = match

	if match ~= "" then
		PesquisarPL(match)
	end
end)

FixNome = function()
	local str6 = "YouTube Music Player/Local Audios"

	for _, v17 in ipairs(listfiles("YouTube Music Player/Local Audios")) do
		pcall(function()
			local match = v17:match("[^/\\]+$")

			if match and match:sub(-4) == ".mp3" then
				local str7 = match:sub(1, -5)

				if #str7 > 90 then
					local str8 = str6 .. "/" .. str7:sub(1, 80) .. "_" .. tostring(math.random(10000, 99999)) .. ".mp3"

					if not isfile(str8) then
						local v18 = readfile(v17)
						writefile(str8, v18)
						delfile(v17)
						local n4 = 0

						while isfile(v17) and n4 < 50 do
							task.wait()
							n4 += 1
						end
					end
				end
			end
		end)
	end
end

UpdatePlaylist = function()
	task.spawn(function()
		local tbl12 = {
			Musics = "YouTube Music Player/Musics",
			Videos = "YouTube Music Player/Videos",
			Roblox = "YouTube Music Player/Roblox IDS",
			Local = "YouTube Music Player/Local Audios",
		}

		FixNome()

		for _, v17 in pairs(tbl12) do
			if not isfolder(v17) then
				makefolder(v17)
			end
		end

		local function fn6(arg)
			local ok3, result3 = pcall(listfiles, arg)
			return ok3 and result3 or {}
		end

		local function fn7(arg)
			return arg:match("[^/\\]+$")
		end

		local function fn8(arg, arg2)
			return arg:gsub(arg2:gsub("%.", "%%."), "")
		end

		local tbl13 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }

		for _, v17 in pairs(BibliotecaMusicas) do
			tbl13.Musics[v17.id] = true
		end

		for _, v17 in pairs(BilbliotecaVideos) do
			tbl13.Videos[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaRoblox) do
			tbl13.Roblox[v17.id] = true
		end

		for _, v17 in pairs(BibliotecaLocal) do
			tbl13.Local[v17.name] = true
		end

		local tbl14 = { Musics = {}, Videos = {}, Roblox = {}, Local = {} }
		local v17 = ipairs
		local v18 = fn6(tbl12.Musics)

		for _, v19 in v17(v18) do
			local v20 = fn8(fn7(v19), ".mp3")
			tbl14.Musics[v20] = true

			if not tbl13.Musics[v20] then
				task.spawn(function()
					local v21, v22, v23, v24 = ApiInfo(v20)
					if not (v21 and v22 and v23) then
						return
					end
					table.insert(BibliotecaMusicas, { id = v20, name = v21, author = v22, thumb = v23, authorUrl = v24 })
					fn5(v21, "Musica", v20)
				end)
			end
		end

		local v19 = ipairs
		local v20 = fn6(tbl12.Videos)

		for _, v21 in v19(v20) do
			local v22 = fn8(fn7(v21), ".webm")
			tbl14.Videos[v22] = true

			if not tbl13.Videos[v22] then
				task.spawn(function()
					local v23, v24, v25, v26 = ApiInfo(v22)
					if not (v23 and v24 and v25) then
						return
					end
					table.insert(BilbliotecaVideos, { id = v22, name = v23, author = v24, thumb = v25, authorUrl = v26 })
					fn5(v23, "Video", v22)
				end)
			end
		end

		local v21 = ipairs
		local v22 = fn6(tbl12.Roblox)

		for _, v23 in v21(v22) do
			local v24 = fn8(fn7(v23), ".rbx")
			tbl14.Roblox[v24] = true

			if not tbl13.Roblox[v24] then
				task.spawn(function()
					local v25, v26, v27, v28 = ApiRoblox(v24)
					if not (v25 and v26 and v27) then
						return
					end
					table.insert(BibliotecaRoblox, { id = v24, name = v25, creatorId = v26, creatorName = v27 })
					fn5(v25, "Roblox", v24, v28)
				end)
			end
		end

		local v23 = ipairs
		local v24 = fn6(tbl12.Local)

		for _, v25 in v23(v24) do
			local match = fn7(v25):match("^(.*)%.mp3$")
			tbl14.Local[match] = true

			if not tbl13.Local[match] then
				table.insert(BibliotecaLocal, { name = match })
				fn5(match, "Local", match)
			end
		end

		for i = #BibliotecaMusicas, 1, -1 do
			local v25 = BibliotecaMusicas[i]

			if not tbl14.Musics[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaMusicas, i)
			end
		end

		for i = #BilbliotecaVideos, 1, -1 do
			local v25 = BilbliotecaVideos[i]

			if not tbl14.Videos[v25.id] then
				Deletar(v25.id)
				table.remove(BilbliotecaVideos, i)
			end
		end

		for i = #BibliotecaRoblox, 1, -1 do
			local v25 = BibliotecaRoblox[i]

			if not tbl14.Roblox[v25.id] then
				Deletar(v25.id)
				table.remove(BibliotecaRoblox, i)
			end
		end

		for i = #BibliotecaLocal, 1, -1 do
			local v25 = BibliotecaLocal[i]

			if not tbl14.Local[v25.name] then
				Deletar(v25.name)
				table.remove(BibliotecaLocal, i)
			end
		end
	end)
end

UpdatePlaylist()
CACHE_LINK = nil
KEY_ATUAL = nil
VIDEO_ATUAL = nil
DownloadAtual = nil
DOWNLOAD_SESSION = nil
DOWNLOAD_TOKEN = nil
DOWNLOAD_CLEARANCE = nil

ApiSearchFree = function(arg)
	local str6 = str3 .. "/search/youtube/free/" .. HttpService:UrlEncode(arg)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v17 = string.lower(result3)
	if string.find(v17, "too many requests") then
		return "rate"
	end

	if string.find(v17, "no results") then
		return "sem"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

ApiSearchPremium = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
	local v17 = HttpService
	local str6 = str3 .. "/search/youtube/premium/" .. tostring(arg) .. "/" .. tostring(arg2) .. "/" .. tostring(arg3) .. "/" .. tostring(arg4) .. "/" .. tostring(arg5) .. "/" .. tostring(YmpHwid()) .. "/" .. v17:UrlEncode(arg7)
	if not CheckRequest() then
		return "error"
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str6)
	end)

	if not ok3 or not result3 then
		return "error"
	end
	local v18 = string.lower(result3)
	if string.find(v18, "no results") then
		return "sem"
	end

	if string.find(v18, "request denied") then
		return "denied"
	end

	if string.find(v18, "too many requests") then
		return "rate"
	end

	local ok4, result4 = pcall(function()
		return HttpService:JSONDecode(result3)
	end)

	if ok4 and result4 and result4.results then
		return result4.results
	end
	return "error"
end

DownloadLog = function(arg, arg2)
	if not CheckRequest() then
		return
	end

	task.spawn(function()
		pcall(function()
			YmpRequest({
				Url = str3 .. "/dl",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = HttpService:JSONEncode({ tipo = arg2, link = arg }),
			})
		end)
	end)
end

local tbl12 = {
	1116352408,
	1899447441,
	3049323471,
	3921009573,
	961987163,
	1508970993,
	2453635748,
	2870763221,
	3624381080,
	310598401,
	607225278,
	1426881987,
	1925078388,
	2162078206,
	2614888103,
	3248222580,
	3835390401,
	4022224774,
	264347078,
	604807628,
	770255983,
	1249150122,
	1555081692,
	1996064986,
	2554220882,
	2821834349,
	2952996808,
	3210313671,
	3336571891,
	3584528711,
	113926993,
	338241895,
	666307205,
	773529912,
	1294757372,
	1396182291,
	1695183700,
	1986661051,
	2177026350,
	2456956037,
	2730485921,
	2820302411,
	3259730800,
	3345764771,
	3516065817,
	3600352804,
	4094571909,
	275423344,
	430227734,
	506948616,
	659060556,
	883997877,
	958139571,
	1322822218,
	1537002063,
	1747873779,
	1955562222,
	2024104815,
	2227730452,
	2361852424,
	2428436474,
	2756734187,
	3204031479,
	3329325298,
}

local str6 = "https://p.savenow.to"
local str7 = "https://en.loader.to/"
local str8 = "dfcb6d76f2f6a9894gjkege8a4ab232222"
local n4 = 200
local n5 = 0.003
local n6 = 30

local str9 = str:gsub("^(%a+)%-(%a+)$", function(arg, arg2)
	return arg .. "-" .. arg2:upper()
end) .. "," .. (str:match("^(%a+)") or "en") .. ";q=0.9,en-US;q=0.8,en;q=0.7"

local v17 = nil
local n7 = 0
local flag21 = false

local function fn6(arg, arg2)
	return bit32.rrotate(arg, arg2)
end

local function fn7(...)
	local v18 = table.pack(...)
	local n8 = 0

	for i = 1, select("#", ...) do
		n8 = bit32.band(n8 + select(i, table.unpack(v18, 1, v18.n)), 4294967295)
	end

	return n8
end

local function fn8(arg)
	local n8 = #arg
	local tbl13 = { string.byte(arg, 1, n8) }
	local n9 = n8 * 8
	tbl13[#tbl13 + 1] = 128

	while #tbl13 % 64 ~= 56 do
		tbl13[#tbl13 + 1] = 0
	end

	local n10 = math.floor(n9 / 4294967296)
	local n11 = n9 % 4294967296

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n10, i), 255)
	end

	for i = 24, 0, -8 do
		tbl13[#tbl13 + 1] = bit32.band(bit32.rshift(n11, i), 255)
	end

	local n12 = 1779033703
	local n13 = 3144134277
	local n14 = 1013904242
	local n15 = 2773480762
	local n16 = 1359893119
	local n17 = 2600822924
	local n18 = 528734635
	local n19 = 1541459225

	for i = 1, #tbl13, 64 do
		local tbl14 = {}

		for i2 = 0, 15 do
			local n20 = i + i2 * 4
			tbl14[i2 + 1] = bit32.bor(bit32.lshift(tbl13[n20], 24), bit32.lshift(tbl13[n20 + 1], 16), bit32.lshift(tbl13[n20 + 2], 8), tbl13[n20 + 3])
		end

		for i2 = 17, 64 do
			local v18 = tbl14[i2 - 15]
			local v19 = tbl14[i2 - 2]
			local rshift = bit32.rshift
			local v20 = bit32.bxor(fn6(v18, 7), fn6(v18, 18), rshift(v18, 3))
			local rshift2 = bit32.rshift
			local v21 = bit32.bxor(fn6(v19, 17), fn6(v19, 19), rshift2(v19, 10))
			tbl14[i2] = fn7(tbl14[i2 - 16], v20, tbl14[i2 - 7], v21)
		end

		local v18 = n16
		local v19 = n17
		local v20 = n18
		local v21 = n19
		local v22 = n12
		local v23 = n13
		local v24 = n14
		local v25 = n15

		for i2 = 1, 64 do
			local bxor = bit32.bxor
			local v26 = tbl12[i2]
			local v27 = tbl14[i2]
			local v28 = fn7(v21, bit32.bxor(fn6(v18, 6), fn6(v18, 11), fn6(v18, 25)), bxor(bit32.band(v18, v19), bit32.band(bit32.bnot(v18), v20)), v26, v27)
			local v29 = bit32.bxor(fn6(v22, 2), fn6(v22, 13), fn6(v22, 22))
			local band = bit32.band
			local v30 = bit32.bxor(bit32.band(v22, v23), bit32.band(v22, v24), band(v23, v24))
			local v31 = fn7(v29, v30)
			local v32 = fn7(v25, v28)
			v21 = v20
			v25 = v24
			v20 = v19
			v24 = v23
			v19 = v18
			v23 = v22
			v18 = v32
			v22 = fn7(v28, v31)
		end

		n12 = fn7(n12, v22)
		n13 = fn7(n13, v23)
		n14 = fn7(n14, v24)
		n15 = fn7(n15, v25)
		n16 = fn7(n16, v18)
		n17 = fn7(n17, v19)
		n18 = fn7(n18, v20)
		n19 = fn7(n19, v21)
	end

	return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", n12, n13, n14, n15, n16, n17, n18, n19)
end

local function fn9(arg, arg2)
	local num = tonumber(arg2)
	if not num then
		return nil
	end
	local str10 = string.rep("0", num)
	local n8 = #str10
	local str11 = tostring(arg) .. ":"
	local n9 = 0

	while true do
		local now = os.clock()
		local exitTo = nil

		while fn8(str11 .. tostring(n9)):sub(1, n8) ~= str10 do
			n9 += 1
			if n5 <= os.clock() - now then
				exitTo = 1
				break
			end
		end

		if exitTo == 1 then
			task.wait()
			continue
		end
		break
	end

	return tostring(n9)
end

local function fn10(arg, arg2)
	local tbl13 = {
		accept = "*/*",
		["accept-language"] = str9,
		referer = str7,
		["sec-ch-ua"] = "\"Chromium\";v=\"137\", \"Not/A)Brand\";v=\"24\"",
		["sec-ch-ua-mobile"] = "?1",
		["sec-ch-ua-platform"] = "\"Android\"",
		["sec-fetch-dest"] = "empty",
		["sec-fetch-mode"] = "cors",
		["sec-fetch-site"] = "cross-site",
	}

	if arg2 then
		tbl13["content-type"] = "application/json"
	end

	if arg then
		tbl13.authorization = "Bearer " .. arg
	end

	return tbl13
end

local function fn11(arg)
	if not arg then
		return nil
	end
	local body = arg.Body or arg.body
	if type(body) ~= "string" then
		return nil
	end
	local ok3, result3 = pcall(HttpService.JSONDecode, HttpService, body)
	if not ok3 or type(result3) ~= "table" then
		return nil
	end
	return result3
end

local function fn12()
	local now = os.time()
	if v17 and now < n7 - n6 then
		return v17
	end

	if flag21 then
		local now2 = os.clock()

		while flag21 do
			if not (os.clock() - now2 >= 10) then
				task.wait()
				continue
			end
			break
		end

		local now3 = os.time()
		if v17 and now3 < n7 - n6 then
			return v17
		end
	end

	flag21 = true

	local ok3, result3, result4 = pcall(function()
		local v18 = YmpRequest({ Url = str6 .. "/api/pow/challenge", Method = "GET", Headers = fn10() })
		local v19 = fn11(v18)
		if not v19 then
			return nil
		end

		if v19.salt == nil or v19.difficulty == nil or v19.expires_at == nil or v19.signature == nil then
			return nil
		end
		local v20 = fn9(v19.salt, v19.difficulty)
		if not v20 then
			return nil
		end

		local v21 = YmpRequest({
			Url = str6 .. "/api/pow/verify",
			Method = "POST",
			Headers = fn10(nil, true),
			Body = HttpService:JSONEncode({
				salt = v19.salt,
				difficulty = v19.difficulty,
				expires_at = v19.expires_at,
				signature = v19.signature,
				nonce = v20,
			}),
		})

		local v22 = fn11(v21)
		if not v22 or v22.success ~= true or type(v22.token) ~= "string" then
			return nil
		end
		return v22.token, tonumber(v22.expires_at) or tonumber(v19.expires_at) or os.time() + 300
	end)

	flag21 = false
	if not ok3 or type(result3) ~= "string" then
		return nil
	end
	v17 = result3
	n7 = tonumber(result4) or os.time() + 300
	return v17
end

local function fn13(arg, arg2, arg3)
	local now = os.clock()
	local v18 = fn12()
	local v19 = HttpService
	local str10 = "&apikey=" .. str8
	local str11 = str6 .. "/api/v2/download?format=" .. HttpService:UrlEncode(arg2) .. "&url=" .. v19:UrlEncode(arg) .. str10
	local v20 = fn10(v18)

	local ok3, result3 = pcall(function()
		return YmpRequest({ Url = str11, Method = "GET", Headers = v20 })
	end)

	if not ok3 then
		return "error"
	end
	local v21 = fn11(result3)
	if not v21 or v21.success == false or type(v21.progress_url) ~= "string" then
		return "error"
	end
	local progressUrl = v21.progress_url
	task.wait(2)
	local v22

	while true do
		v22 = nil

		if os.clock() - now <= n4 then
			local ok4, result4 = pcall(function()
				return YmpRequest({ Url = progressUrl, Method = "GET", Headers = v20 })
			end)

			if ok4 then
				local v23 = fn11(result4)

				if v23 then
					if v23.progress == 1000 and type(v23.download_url) == "string" then
						v22 = v23
						break
					else
						task.wait(2)
					end
				else
					task.wait(2)
				end
			else
				task.wait(2)
			end
		else
			break
		end
	end

	if not v22 then
		return "error"
	end
	local tbl13 = {}

	if type(v22.download_url) == "string" then
		tbl13[#tbl13 + 1] = v22.download_url
	end

	if type(v22.alternative_download_urls) == "table" then
		for _, alternativeDownloadUrl in ipairs(v22.alternative_download_urls) do
			if not (#tbl13 >= 4) then
				if type(alternativeDownloadUrl) == "table" and type(alternativeDownloadUrl.url) == "string" and alternativeDownloadUrl.url ~= v22.download_url then
					tbl13[#tbl13 + 1] = alternativeDownloadUrl.url
				end

				continue
			end

			break
		end
	end

	if #tbl13 == 0 then
		return "error"
	end
	DownloadLog(arg, arg3)
	local v23 = table.create(math.min(#tbl13, 4))

	for i = 1, math.min(#tbl13, 4) do
		v23[i] = "Download" .. i .. ": " .. tbl13[i]
	end

	return table.concat(v23, "\n")
end

DownloadMusic = function(arg)
	return fn13(arg, "mp3", "music")
end

DownloadVideo = function(arg)
	return fn13(arg, "360", "video")
end

DesativarBusca = function(arg)
	if arg then
		PesquisarBox.Text = Traducao.Processando
		PesquisarBox.Active = false
		PaginaFrame.Visible = false
		PaginaEsperandoFrame.Visible = true
	else
		PesquisarBox.Text = text
		PesquisarBox.Active = true
		PaginaFrame.Visible = true
		PaginaEsperandoFrame.Visible = false
	end
end

CancelarBusca = function()
	ScrollDownload.Visible = false
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)
	Aguardando.Visible = true
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.PesquiseTitle .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.PesquiseText .. "</font>"
	DownloadFrameTexto.Visible = true
	Concluido.Visible = false
	PaginaFrame.Visible = false
	PaginaEsperandoFrame.Visible = true
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	FiltroFrame.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = false
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	DownloadAtual = nil

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end

Carregando = function(arg)
	if arg then
		flag12 = true
		Loading.Visible = true
		ScrollDownload.Visible = false
		Aguardando.Visible = false

		task.spawn(function()
			while flag12 do
				local v18 = Loading
				v18.Rotation = v18.Rotation + 5
				task.wait(0.04)
			end
		end)
	else
		flag12 = false
		Loading.Visible = false
	end
end

CarregandoRoblox = function(arg)
	if arg then
		if flag13 then
			return
		end
		flag13 = true
		Baixando.Visible = true

		task.spawn(function()
			while flag13 do
				local n8 = Baixando.Rotation + 360
				tween = v6:Create(Baixando, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Rotation = n8 })
				tween:Play()
				tween.Completed:Wait()
				local n9 = 0

				while n9 < 0.35 and flag13 do
					n9 += task.wait()
				end
			end
		end)
	else
		flag13 = false

		if tween then
			tween:Cancel()
			tween = nil
		end

		Baixando.Visible = false
		Baixando.Rotation = 0
	end
end

AddRoblox = function(arg)
	local str10 = "YouTube Music Player/Roblox IDS" .. "/" .. tostring(arg) .. ".rbx"

	pcall(function()
		if not isfolder("YouTube Music Player/Roblox IDS") then
			makefolder("YouTube Music Player/Roblox IDS")
		end

		writefile(str10, "")
	end)

	CancelarBusca()
	UpdatePlaylist()
end

TelaDownload = function(arg, arg2, arg3)
	VIDEO_ATUAL = arg
	ScrollDownload.Visible = false
	Formato.Visible = true
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. tostring(arg) .. ".jpg"

	if isfile and isfile(str10) then
		Thumbfor.Image = getcustomasset(str10)
		Thumbfor.ImageRectOffset = Vector2.new(0, 45)
		Thumbfor.ImageRectSize = Vector2.new(480, 270)
	else
		Thumbfor.Image = "rbxassetid://110787075859454"
		Thumbfor.ImageRectOffset = Vector2.new(0, 0)
		Thumbfor.ImageRectSize = Vector2.new(0, 0)
	end

	local str11 = "Youtube Music Player/Musics/" .. tostring(arg) .. ".mp3"
	local str12 = "Youtube Music Player/Videos/" .. tostring(arg) .. ".webm"
	local v18 = isfile and isfile(str11)
	local v19 = flag19 and isfile and isfile(str12)

	if v18 then
		BotaoMp3.BackgroundTransparency = 0.9
		BotaoMp3.AutoButtonColor = false
		NomeMp3.TextColor3 = Color3.fromRGB(20, 20, 20)
	else
		BotaoMp3.BackgroundTransparency = 0
		BotaoMp3.AutoButtonColor = true
		NomeMp3.TextColor3 = Color3.fromRGB(0, 191, 255)
	end

	if flag19 then
		if v19 then
			BotaoMp4.BackgroundTransparency = 0.9
			BotaoMp4.AutoButtonColor = false
			NomeMp4.TextColor3 = Color3.fromRGB(20, 20, 20)
		else
			BotaoMp4.BackgroundTransparency = 0
			BotaoMp4.AutoButtonColor = true
			NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
		end
	end

	TextoTituloFor.Text = "<font color=\"rgb(255,255,255)\">" .. arg2 .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. arg3 .. "</font>"
end

CriarResultado = function(arg, arg2, arg3, arg4, arg5, arg6)
	local tbl13 = {}
	local flag22 = false
	local str10 = "Youtube Music Player/Internal/Cache/Search_" .. arg2 .. ".jpg"
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0, 221, 0, 43)
	frame3.Position = UDim2.new(0, 7, 0, 5)
	frame3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	frame3.BorderSizePixel = 0
	frame3.Parent = ScrollDownload
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 60, 0, 43)
	imageLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 25, 0, 10)
	frame4.Position = UDim2.new(0, 3, 0, 3)
	frame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame4.BackgroundTransparency = 0.5
	frame4.BorderSizePixel = 0
	frame4.Visible = arg6 ~= nil
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = tostring(arg6 or "00:00")
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 2, 1, 0)
	frame5.Position = UDim2.new(0, 60, 0, 0)
	frame5.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame5.BorderSizePixel = 0
	frame5.Parent = frame3
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(0, 108, 1, -6)
	textLabel2.Position = UDim2.new(0, 65, 0, 3)
	textLabel2.BackgroundTransparency = 1
	textLabel2.RichText = true
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s %s</font>", arg3, Traducao.De, arg4)
	textLabel2.Parent = frame3
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 2, 1, 0)
	frame6.Position = UDim2.new(0, 176, 0, 0)
	frame6.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 33, 0, 33)
	imageButton3.Position = UDim2.new(0, 183, 0, 5)
	imageButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton3.AutoButtonColor = false
	imageButton3.Parent = frame3
	Corner(frame3, 5)
	Corner(imageLabel, 5)
	Corner(frame4, 5)
	Corner(imageButton3, 5)
	Stroke(frame3, 50, 50, 50, 2)
	Stroke(imageLabel, 50, 50, 50, 2)
	Stroke(imageButton3, 50, 50, 50, 2)

	if arg == "Roblox" then
		local str11 = tostring(arg2) .. ".rbx"

		pcall(function()
			if isfolder and isfolder("YouTube Music Player/Roblox IDS") then
				for _, v18 in ipairs(listfiles("YouTube Music Player/Roblox IDS")) do
					if string.find(v18, str11) then
						flag22 = true
						break
					end
				end
			end
		end)

		imageButton3.Image = flag22 and "rbxassetid://75203635436406" or "rbxassetid://125446601626694"
		imageLabel.Image = "rbxassetid://112075012925512"
	else
		imageButton3.Image = "rbxassetid://126311565377599"

		task.spawn(function()
			if not pcall(function()
				if not isfolder("Youtube Music Player/Internal/Cache") then
					makefolder("Youtube Music Player/Internal/Cache")
				end

				local response = game:HttpGet(arg5)
				writefile(str10, response)
				imageLabel.Image = getcustomasset(str10)
				imageLabel.ImageRectOffset = Vector2.new(0, 45)
				imageLabel.ImageRectSize = Vector2.new(480, 270)
			end) then
				imageLabel.Image = "rbxassetid://110787075859454"
			end
		end)
	end

	table.insert(tbl13, imageButton3.MouseButton1Click:Connect(function()
		if arg == "Roblox" then
			if not flag19 then
				return
			end

			if flag22 then
				fn3(Traducao.Erro, Traducao.JaTemRoblox, 5)
			else
				AddRoblox(arg2)
			end
		else
			TelaDownload(arg2, arg3, arg4)
		end
	end))

	frame3.Destroying:Connect(function()
		for _, v18 in ipairs(tbl13) do
			v18:Disconnect()
		end

		if arg ~= "Roblox" then
			pcall(function()
				if delfile and isfile(str10) then
					delfile(str10)
				end
			end)
		end
	end)
end

organizarItens = function()
	n3 = 0

	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child.Position = UDim2.new(0, 7, 0, n3 + 5)
			n3 += 58
		end
	end

	ScrollDownload.CanvasSize = UDim2.new(0, 0, 0, n3 - 3)
end

Buscar = function(arg)
	for _, child in ipairs(ScrollDownload:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	DesativarBusca(true)
	Carregando(true)
	DownloadFrameTexto.Visible = false
	FiltroFrame.Visible = false

	local function fn14()
		DesativarBusca(false)
		Carregando(false)
	end

	local function fn15(arg2, arg3, arg4)
		ScrollDownload.Visible = false

		if arg4 then
			SemResultado.Visible = true
		else
			Erro.Visible = true
			Tutorial.Visible = true
		end

		DownloadFrameTexto.Text = string.format("<font color=\"rgb(255,255,255)\">%s</font>\n<font color=\"rgb(192,192,192)\">%s</font>", arg2, arg3)
		DownloadFrameTexto.Visible = true
		fn14()
	end

	if not CheckRequest() then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end
	local v18 = nil
	local flag22 = false

	task.spawn(function()
		if flag19 then
			v18 = ApiSearchPremium(tbl.Ordem or "relevance", tbl.Data or "any", tbl.Duracao or "any", tbl.Pagina or 1, KEY_ATUAL, YmpHwid(), arg)
		else
			v18 = ApiSearchFree(arg)
		end

		flag22 = true
	end)

	local now = tick()

	while true do
		task.wait(0.1)
		if not (flag22 or tick() - now > 15) then
			continue
		end
		break
	end

	if not flag22 or v18 == "error" or not v18 then
		fn15(Traducao.ErroTitle, Traducao.ErroText)
		return
	end

	if v18 == "denied" then
		fn15(Traducao.ErroCrackTitle, Traducao.ErroCrackText)
		return
	end

	if v18 == "rate" then
		fn15(Traducao.TooMany, Traducao.RateLi)
		return
	end

	if v18 == "sem" then
		fn15(Traducao.SemResutadoTitle, Traducao.SemResutadoText, true)
		return
	end

	for _, v19 in ipairs(v18) do
		if flag19 and v19.type == "roblox" then
			CriarResultado("Roblox", v19.id, v19.Name, v19.CreatorName, nil, nil)
		else
			CriarResultado("YouTube", v19.id, v19.name, v19.author, v19.thumbnail, v19.duration)
		end
	end

	fn14()
	ScrollDownload.Visible = true
end

SetPag = function(pagina)
	if not flag19 then
		return
	end

	if tbl.Pagina == pagina then
		return
	end
	tbl.Pagina = pagina
	ScrollDownload.CanvasPosition = Vector2.new(0, 0)

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") then
			local uiStroke = child:FindFirstChildOfClass("UIStroke")

			if child.Name == tostring(pagina) then
				child.BackgroundColor3 = Color3.fromRGB(139, 0, 0)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(255, 0, 0)
				end
			else
				child.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(50, 50, 50)
				end
			end
		end
	end
end

Baixar = function(arg)
	Formato.Visible = false
	FiltroFrame.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	DesativarBusca(true)
	CarregandoRoblox(true)
	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Aguarde .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Dados .. "</font>"
	DownloadFrameTexto.Visible = true
	local v18 = VIDEO_ATUAL
	local str10 = "https://youtu.be/" .. tostring(v18)

	local function fn14(arg2)
		if type(arg2) ~= "string" then
			return nil
		end
		local tbl13 = {}

		for match in string.gmatch(arg2, "[^\n]+") do
			local v19, v20 = string.match(match, "Download(%d+):%s*(.+)")

			if v19 and v20 then
				tbl13[tonumber(v19)] = v20
			end
		end

		return tbl13
	end

	local v19

	if arg == "Musica" then
		v19 = DownloadMusic(str10)
	else
		v19 = nil

		if arg == "Video" then
			v19 = DownloadVideo(str10)
		end
	end

	if v19 == "error" or v19 == "rate" or v19 == "denied" or not CheckRequest() then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local v20 = fn14(v19)

	if not v20 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.MaisUmPauco .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Baixando .. "</font>"
	local v21 = nil

	for i = 1, 4 do
		local v22 = v20[i]

		if v22 and type(v22) == "string" then
			for i2 = 1, 2 do
				local ok3, result3 = pcall(function()
					return game:HttpGet(v22)
				end)

				if ok3 and result3 then
					v21 = result3
					break
				else
					task.wait(0.5)
				end
			end

			if not v21 then
				continue
			end
		else
			continue
		end

		break
	end

	if not v21 then
		CarregandoRoblox(false)
		DesativarBusca(false)
		Erro.Visible = true
		Tutorial.Visible = true
		Novamente.Visible = true

		if not frame.Visible or not Tela4.Visible then
			fn3(Traducao.ErroTitle, Traducao.ErroText, 10)
		end

		DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.ErroTitle .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.ErroText .. "</font>"
		return
	end

	local str11 = "YouTube Music Player/" .. (arg == "Video" and "Videos" or "Musics")
	local str12 = arg == "Video" and ".webm" or ".mp3"
	local str13 = str11 .. "/" .. tostring(v18) .. str12

	pcall(function()
		if not isfolder(str11) then
			makefolder(str11)
		end

		writefile(str13, v21)
	end)

	task.wait(1)
	UpdatePlaylist()
	CarregandoRoblox(false)
	DesativarBusca(false)
	Concluido.Visible = true

	if not frame.Visible or not Tela4.Visible then
		fn3(Traducao.Baixado, Traducao.Terminou, 10)
	end

	DownloadFrameTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.Baixado .. "</font>\n" .. "<font color=\"rgb(192,192,192)\">" .. Traducao.Terminou .. "</font>"
end

for i = 1, 10 do
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 21, 0, 21)
	imageButton3.Position = UDim2.new(0, 3 + (i - 1) * 28, 0, 3)
	imageButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	imageButton3.BackgroundTransparency = 0.9
	imageButton3.Name = i
	imageButton3.Parent = ScrollPagina
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
	textLabel.BackgroundTransparency = 1
	textLabel.BorderSizePixel = 0
	textLabel.Text = tostring(i)
	textLabel.Parent = imageButton3
	Corner(imageButton3, 20)
	Stroke(imageButton3, 50, 50, 50, 1)
	local uiStroke = imageButton3:FindFirstChildOfClass("UIStroke")

	if i == 1 then
		imageButton3.BackgroundTransparency = 0
		imageButton3.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

		if uiStroke then
			uiStroke.Color = Color3.fromRGB(255, 0, 0)
		end
	end

	imageButton3.MouseButton1Click:Connect(function()
		if i == tbl.Pagina then
			return
		end

		if not flag19 then
			fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
			return
		end

		if Loading.Visible or Baixando.Visible then
			return
		end
		SetPag(i)
		Concluido.Visible = false
		DownloadFrameTexto.Visible = false
		SemResultado.Visible = false
		Erro.Visible = false
		Tutorial.Visible = false
		Novamente.Visible = false
		Buscar(text)
	end)
end

AplicarFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if not PaginaFrame.Visible then
		fn3(Traducao.Erro, Traducao.NaoPodeFiltro, 10)
		return
	end
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
	SetPag(1)
	Buscar(text)
end)

RemoverFiltro.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if ordem == "relevance" and data == "any" and duracao == "any" then
		fn3(Traducao.Erro, Traducao.FiltrosJaPadrao, 10)
		return
	end
	ordem = "relevance"
	data = "any"
	duracao = "any"
	tbl.Ordem = ordem
	tbl.Data = data
	tbl.Duracao = duracao
	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao.Relevance
	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao.Any
	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao.Any
	DownloadFrameTexto.Visible = false
	SemResultado.Visible = false
	Erro.Visible = false
	Tutorial.Visible = false
	Novamente.Visible = false
	fn3(Traducao.Sucesso, Traducao.FiltrosRemovidos, 5)

	if PaginaFrame.Visible then
		Formato.Visible = false
		ScrollDownload.Visible = true
		TextoTituloFor.Text = ""
		Thumbfor.Image = "rbxassetid://0"
		SetPag(1)
		Buscar(text)
	end
end)

Relevancia.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl2) do
		if v18 == ordem then
			ordem = tbl2[i % #tbl2 + 1]
			break
		end
	end

	RelevanciaTexto.Text = Traducao.Order .. "\n" .. Traducao[ordem:gsub("^%l", string.upper)]
end)

DataUpload.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl3) do
		if v18 == data then
			data = tbl3[i % #tbl3 + 1]
			break
		end
	end

	DataUploadTexto.Text = Traducao.UploaDate .. "\n" .. Traducao[data:gsub("^%l", string.upper)]
end)

Duracao.MouseButton1Click:Connect(function()
	for i, v18 in ipairs(tbl4) do
		if v18 == duracao then
			duracao = tbl4[i % #tbl4 + 1]
			break
		end
	end

	DuracaoTexto.Text = Traducao.Duration .. "\n" .. Traducao[duracao:gsub("^%l", string.upper)]
end)

Filtro.MouseButton1Click:Connect(function()
	if Loading.Visible or Baixando.Visible then
		return
	end

	if not FiltroFrame.Visible then
		tbl10 = {}

		for _, v18 in ipairs({
			DownloadFrameTexto,
			Aguardando,
			Loading,
			SemResultado,
			Formato,
			ScrollDownload,
			Concluido,
			SemResultado,
			Erro,
		}) do
			if v18.Visible then
				table.insert(tbl10, v18)
				v18.Visible = false
			end
		end

		FiltroFrame.Visible = true
	else
		for _, v18 in ipairs(tbl10) do
			if v18 then
				v18.Visible = true
			end
		end

		tbl10 = {}
		FiltroFrame.Visible = false
	end
end)

ClearSearch = function()
	pcall(function()
		if isfolder("Youtube Music Player/Internal/Cache") then
			local Cache = listfiles("Youtube Music Player/Internal/Cache")

			for _, v18 in ipairs(Cache) do
				if string.find(v18, "Search_") then
					delfile(v18)
				end
			end
		end
	end)
end

PesquisarBox.FocusLost:Connect(function()
	local match = PesquisarBox.Text:match("^%s*(.-)%s*$")
	if match == "" then
		PesquisarBox.Text = ""
		return
	end
	ClearSearch()
	text = tostring(match)
	SetPag(1)
	Buscar(text)
end)

PesquisarBox.Focused:Connect(function()
	CancelarBusca()
end)

Lupa.MouseButton1Down:Connect(function()
	if not PesquisarBox.Active then
		return
	end
	flag14 = PesquisarBox:IsFocused()
end)

Lupa.MouseButton1Click:Connect(function()
	if not PesquisarBox.Active then
		return
	end

	if flag14 then
		PesquisarBox:ReleaseFocus()
	else
		PesquisarBox:CaptureFocus()
	end
end)

BotaoMp3.MouseButton1Click:Connect(function()
	if isfile("YouTube Music Player/Musics" .. "/" .. tostring(VIDEO_ATUAL) .. ".mp3") then
		fn3(Traducao.Erro, Traducao.JaTemMusica, 5)
		return
	end
	Baixar("Musica")
	DownloadAtual = "M"
end)

BotaoMp4.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if isfile("YouTube Music Player/Videos" .. "/" .. tostring(VIDEO_ATUAL) .. ".webm") then
		fn3(Traducao.Erro, Traducao.JaTemVideo, 5)
		return
	end
	Baixar("Video")
	DownloadAtual = "V"
end)

BotaoCancelar.MouseButton1Click:Connect(function()
	Formato.Visible = false
	ScrollDownload.Visible = true
	TextoTituloFor.Text = ""
	Thumbfor.Image = "rbxassetid://0"
end)

Novamente.MouseButton1Click:Connect(function()
	if DownloadAtual == "M" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Musica")
	elseif DownloadAtual == "V" then
		fn3(Traducao.Tentando, Traducao.TentandoTexto, 7)
		Baixar("Video")
	end
end)

Tutorial.MouseButton1Click:Connect(function()
	fn3(Traducao.LinkCopiado, Traducao.Tutorial, 8)
	YmpClipboard("https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/Tutorial.txt")
end)

ScrollDownload.ChildAdded:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

ScrollDownload.ChildRemoved:Connect(function(child)
	if not child:IsA("Frame") then
		return
	end
	organizarItens()
end)

SetVolume = function(volume)
	sound2.Volume = volume
	Video.Volume = volume
	MiniVideo.Volume = volume
	VolumeBox.Text = tostring(volume)
end

SetPitch = function(playbackSpeed)
	sound2.PlaybackSpeed = playbackSpeed
	GiroSpeed = playbackSpeed
	GiroBackup = playbackSpeed
	PitchBox.Text = tostring(playbackSpeed)
end

SetEqualizer = function(lowGain, midGain, highGain)
	Equalizer.LowGain = lowGain
	Equalizer.MidGain = midGain
	Equalizer.HighGain = highGain
	GravesBox.Text = tostring(lowGain)
	MediosBox.Text = tostring(midGain)
	AgudosBox.Text = tostring(highGain)
end

EquaValue = function(arg, arg2)
	local v18 = string.match(string.gsub(string.gsub(arg, "^%s+", ""), "%s+$", ""), "-?%d+%.?%d*")
	if not v18 then
		return arg2
	end
	local num = tonumber(v18)
	if not num then
		return arg2
	end
	return (math.clamp(num, -1000, 1000))
end

SetEffect = function(arg)
	for _, child in pairs(sound2:GetChildren()) do
		if child:IsA("SoundEffect") then
			child:Destroy()
		end
	end

	SetPitch(1)
	SetEqualizer(1, 1, 1)
	if arg == "Nenhum" then
		return
	end

	if arg == "Reverb" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 2.6
		reverbSoundEffect.Density = 0.75
		reverbSoundEffect.Diffusion = 0.9
		reverbSoundEffect.WetLevel = -9
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(-1, 0, -3)
	elseif arg == "Echo" then
		local echoSoundEffect = Instance.new("EchoSoundEffect", sound2)
		echoSoundEffect.Delay = 0.7
		echoSoundEffect.Feedback = 0.5
		echoSoundEffect.WetLevel = -6
		echoSoundEffect.DryLevel = 0
	elseif arg == "Distortion" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.4
		SetEqualizer(-4, 2, -2)
	elseif arg == "Chorus" then
		local chorusSoundEffect = Instance.new("ChorusSoundEffect", sound2)
		chorusSoundEffect.Depth = 0.25
		chorusSoundEffect.Rate = 1.2
		chorusSoundEffect.Mix = 0.6
	elseif arg == "Flanger" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.4
		flangeSoundEffect.Rate = 2
		flangeSoundEffect.Mix = 0.5
	elseif arg == "Tremolo" then
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 0.5
		tremoloSoundEffect.Frequency = 8
	elseif arg == "Compressor" then
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -25
		compressorSoundEffect.Ratio = 15
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.1
	elseif arg == "Radio" then
		Instance.new("DistortionSoundEffect", sound2).Level = 0.25
		local compressorSoundEffect = Instance.new("CompressorSoundEffect", sound2)
		compressorSoundEffect.Threshold = -10
		compressorSoundEffect.Ratio = 12
		compressorSoundEffect.Attack = 0.02
		compressorSoundEffect.Release = 0.08
		local equalizerSoundEffect = Instance.new("EqualizerSoundEffect", sound2)
		equalizerSoundEffect.LowGain = -10
		equalizerSoundEffect.MidGain = 10
		equalizerSoundEffect.HighGain = -12
		SetPitch(0.97)
	elseif arg == "Cinema" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 5
		reverbSoundEffect.Density = 0.7
		reverbSoundEffect.WetLevel = -15
		reverbSoundEffect.DryLevel = 0
		SetEqualizer(6, -2, 2)
	elseif arg == "Underwater" then
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 1.5
		reverbSoundEffect.Density = 1
		reverbSoundEffect.WetLevel = -6
		reverbSoundEffect.DryLevel = -4
		SetEqualizer(4, -12, -25)
	elseif arg == "Kid" then
		SetPitch(1.45)
		SetEqualizer(-5, 2, 4)
	elseif arg == "Robot" then
		local flangeSoundEffect = Instance.new("FlangeSoundEffect", sound2)
		flangeSoundEffect.Depth = 0.5
		flangeSoundEffect.Rate = 3
		local tremoloSoundEffect = Instance.new("TremoloSoundEffect", sound2)
		tremoloSoundEffect.Depth = 1
		tremoloSoundEffect.Frequency = 4
		SetEqualizer(-5, 5, 2)
	elseif arg == "Slowed" then
		SetPitch(0.72)
		Instance.new("DistortionSoundEffect", sound2).Level = 0.35
		local reverbSoundEffect = Instance.new("ReverbSoundEffect", sound2)
		reverbSoundEffect.DecayTime = 4
		reverbSoundEffect.WetLevel = -10
		SetEqualizer(8, -2, -12)
	end
end

SelecionarEqua = function(arg)
	local children = ScrollEqua:GetChildren()

	local function fn14(arg2)
		if not arg2:IsA("ImageButton") or arg2.Name == "Resetar" then
			return
		end
		local imageLabel = arg2:FindFirstChildOfClass("ImageLabel")
		arg2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Stroke(arg2, 50, 50, 50, 2)

		if imageLabel then
			Stroke(imageLabel, 50, 50, 50, 2)
		end
	end

	for _, child in ipairs(children) do
		fn14(child)
	end

	local imageLabel = arg:FindFirstChildOfClass("ImageLabel")
	arg.BackgroundColor3 = Color3.fromRGB(139, 0, 0)
	Stroke(arg, 255, 0, 0, 2)

	if imageLabel then
		Stroke(imageLabel, 255, 0, 0, 2)
	end

	if arg.Name == "Nenhum" then
		SetEffect("Nenhum")
	elseif arg.Name == "Reverb" then
		SetEffect("Reverb")
	elseif arg.Name == "Echo" then
		SetEffect("Echo")
	elseif arg.Name == "Distortion" then
		SetEffect("Distortion")
	elseif arg.Name == "Chorus" then
		SetEffect("Chorus")
	elseif arg.Name == "Flanger" then
		SetEffect("Flanger")
	elseif arg.Name == "Tremolo" then
		SetEffect("Tremolo")
	elseif arg.Name == "Compressor" then
		SetEffect("Compressor")
	elseif arg.Name == "Radio" then
		SetEffect("Radio")
	elseif arg.Name == "Cinema" then
		SetEffect("Cinema")
	elseif arg.Name == "Underwater" then
		SetEffect("Underwater")
	elseif arg.Name == "Kid" then
		SetEffect("Kid")
	elseif arg.Name == "Robot" then
		SetEffect("Robot")
	elseif arg.Name == "Slowed" then
		SetEffect("Slowed")
	end
end

VolumeBox.FocusLost:Connect(function()
	SetVolume(EquaValue(VolumeBox.Text, 1))
end)

PitchBox.FocusLost:Connect(function()
	SetPitch(EquaValue(PitchBox.Text, 1))
end)

GravesBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

MediosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

AgudosBox.FocusLost:Connect(function()
	local v18 = EquaValue
	local text2 = AgudosBox.Text
	SetEqualizer(EquaValue(GravesBox.Text, 1), EquaValue(MediosBox.Text, 1), v18(text2, 1))
end)

for _, child in ipairs(ScrollEqua:GetChildren()) do
	if child:IsA("ImageButton") and child.Name ~= "Resetar" then
		child.MouseButton1Click:Connect(function()
			SelecionarEqua(child)
		end)
	end
end

ResetarEqua.MouseButton1Click:Connect(function()
	SetVolume(1)
	SetPitch(1)
	SelecionarEqua(Nenhum)
	fn3(Traducao.Sucesso, Traducao.RsetadoEqua, 5)
end)

NumeroGC = function(arg)
	if arg == false then
		ContadorJA.Visible = false
		ContadorJABO.Visible = false
		ContadorJANU.Text = "0"
		ContadorJANUBO.Text = "0"
		return
	end

	ContadorJA.Visible = not flag17
	ContadorJABO.Visible = true
	local text2 = ContadorJANUBO.Text
	if text2 == "9+" then
		return
	end
	local n8 = tonumber(text2) or 1

	if n8 < 9 then
		local n9 = n8 + 1
		ContadorJANU.Text = tostring(n9)
		ContadorJANUBO.Text = tostring(n9)
	else
		ContadorJANU.Text = "9+"
		ContadorJANUBO.Text = "9+"
	end
end

if websocket_ then
	Botao5.BackgroundTransparency = 0
	Icone5.BackgroundTransparency = 0
	Icone5.ImageTransparency = 0
	Nome5.TextColor3 = Color3.fromRGB(255, 255, 255)
	Stroke(Nome5, 0, 0, 0, 1.5)
end

Tela = function(arg)
	if arg == n then
		return
	end
	local tbl13 = { Tela1, Tela2, Tela3, Tela4, Tela5, Tela6 }
	local v18 = ScrollNave:FindFirstChild("Botao" .. arg)
	if arg == 5 and v18 and v18.BackgroundTransparency > 0 then
		fn3(Traducao.Erro, Traducao.ExploitIcomGC, 5)
		return
	end
	n = arg

	if arg == 5 then
		NumeroGC(false)
	end

	for i = 1, #tbl13 do
		tbl13[i].Visible = false
	end

	fn2("102702078778790")

	for _, child in ipairs(ScrollNave:GetChildren()) do
		if child:IsA("ImageButton") then
			child.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
			local uiStroke = child:FindFirstChild("UIStroke")

			if uiStroke then
				uiStroke.Color = Color3.fromRGB(50, 50, 50)
			end

			local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

				if uiStroke2 then
					uiStroke2.Color = Color3.fromRGB(50, 50, 50)
				end
			end
		end
	end

	if tbl13[arg] then
		tbl13[arg].Visible = true
	end

	if v18 then
		local color = Color3.fromRGB(139, 0, 0)
		local color2 = Color3.fromRGB(255, 0, 0)

		if arg == 6 then
			color = Color3.fromRGB(255, 215, 0)
			color2 = Color3.fromRGB(184, 134, 11)
		end

		v18.BackgroundColor3 = color
		local uiStroke = v18:FindFirstChild("UIStroke")

		if uiStroke then
			uiStroke.Color = color2
		end

		local imageLabel = v18:FindFirstChildWhichIsA("ImageLabel")

		if imageLabel then
			local uiStroke2 = imageLabel:FindFirstChild("UIStroke")

			if uiStroke2 then
				uiStroke2.Color = color2
			end
		end
	end
end

Botao1.MouseButton1Click:Connect(function()
	Tela(1)
end)

Botao2.MouseButton1Click:Connect(function()
	Tela(2)
end)

Botao3.MouseButton1Click:Connect(function()
	Tela(3)
end)

Botao4.MouseButton1Click:Connect(function()
	Tela(4)
end)

Botao5.MouseButton1Click:Connect(function()
	Tela(5)
end)

Botao6.MouseButton1Click:Connect(function()
	Tela(6)
end)

Discord.MouseButton1Click:Connect(function()
	if flag3 then
		return
	end
	flag3 = true
	local tween4 = v6:Create(UIScaleDis, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeDiscord, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleDis, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeDiscord, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3(Traducao.LinkCopiado, "https://discord.gg/kbh2dEdnYP", 10)
	YmpClipboard("https://discord.gg/kbh2dEdnYP")
	tween6.Completed:Wait()
	flag3 = false
end)

You.MouseButton1Click:Connect(function()
	if flag4 then
		return
	end
	flag4 = true
	local tween4 = v6:Create(UIScaleYou, tweenInfo, { Scale = 0.9 })
	local tween5 = v6:Create(IconeYou, tweenInfo, { Rotation = -6 })
	tween4:Play()
	tween5:Play()
	tween4.Completed:Wait()
	local tween6 = v6:Create(UIScaleYou, tweenInfo2, { Scale = 1 })
	local tween7 = v6:Create(IconeYou, tweenInfo2, { Rotation = 0 })
	tween6:Play()
	tween7:Play()
	fn3("YouTube", "@Termux_404", 10)
	tween6.Completed:Wait()
	flag4 = false
end)

local tbl13 = {}
local tween4 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, 6, 0, 6) })
local tween5 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 174, 0, 6) })
local tween6 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -54) })
local tween7 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -54) })
local create = v6.Create
local v18 = BarraProgresso
local tbl14 = { Position = UDim2.new(0, 6, 0, 103) }
tbl13[1] = tween4
tbl13[2] = tween5
tbl13[3] = tween6
tbl13[4] = tween7

do
	local values = table.pack(create(v6, v18, tweenInfo4, tbl14))
	table.move(values, 1, values.n, 5, tbl13)
end

tweensMostrar = tbl13
local tbl15 = {}
local tween8 = v6:Create(TempoAtual, tweenInfo4, { Position = UDim2.new(0, -60, 0, 6) })
local tween9 = v6:Create(TempoTotal, tweenInfo4, { Position = UDim2.new(0, 235, 0, 6) })
local tween10 = v6:Create(Repetir, tweenInfo4, { Position = UDim2.new(0.5, -35, 0.5, -120) })
local tween11 = v6:Create(Miniplayer, tweenInfo4, { Position = UDim2.new(0.5, 5, 0.5, -120) })
local create2 = v6.Create
local v19 = BarraProgresso
local tbl16 = { Position = UDim2.new(0, 6, 0, 125) }
tbl15[1] = tween8
tbl15[2] = tween9
tbl15[3] = tween10
tbl15[4] = tween11

do
	local values = table.pack(create2(v6, v19, tweenInfo4, tbl16))
	table.move(values, 1, values.n, 5, tbl15)
end

tweensOcultar = tbl15
infoTweenMini = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
listaControlesMini = { MiniBack, MiniRetroceder, MiniPlay, MiniAvancar, MiniSkip, TelaCheia, FecharMini }

Exibir = function()
	if flag6 then
		return
	end
	flag6 = true
	fn2("123430321654900")
	task.wait(0.1)
	flag5 = not flag5
	local v20 = flag5 and tweensMostrar or tweensOcultar

	for _, v21 in ipairs(v20) do
		v21:Play()
	end

	v20[1].Completed:Wait()
	flag6 = false
end

BotaoTela.MouseButton1Click:Connect(function()
	Exibir()
end)

Repetir.MouseButton1Click:Connect(function()
	if Repetir.Image == "rbxassetid://72571947341676" then
		Repetir.Image = "rbxassetid://133261841375114"
		fn3(Traducao.PlayMode, Traducao.Repetir, 8)
		str4 = "nill"
		sound2.Looped = true
		Video.Looped = true
		MiniVideo.Looped = true
	elseif Repetir.Image == "rbxassetid://133261841375114" then
		Repetir.Image = "rbxassetid://70388482182322"
		fn3(Traducao.PlayMode, Traducao.Random, 8)
		str4 = "Random"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	else
		Repetir.Image = "rbxassetid://72571947341676"
		fn3(Traducao.PlayMode, Traducao.Auto, 8)
		str4 = "Auto"
		sound2.Looped = false
		Video.Looped = false
		MiniVideo.Looped = false
	end
end)

Miniplayer.MouseButton1Click:Connect(function()
	if not flag19 then
		fn3(Traducao.OpcaoBloqueadaTitle, Traducao.OpcaoBloqueadaText, 10)
		return
	end

	if BloquearMidia then
		fn3(Traducao.Aguarde, Traducao.DownloadFazendo, 5)
		return
	end

	if Miniplayer.Image == "rbxassetid://102723588572082" then
		Miniplayer.Image = "rbxassetid://84519235983477"
		fn2("85730811347567")
		SetMiniPlayer(true)
	elseif Miniplayer.Image == "rbxassetid://84519235983477" then
		Miniplayer.Image = "rbxassetid://102723588572082"
		fn2("85730811347567")
		SetMiniPlayer(false)
	end
end)

aplicarVisibilidadeMini = function(arg)
	flag11 = true
	local n8 = #listaControlesMini

	for _, v20 in ipairs(listaControlesMini) do
		if arg then
			v20.Visible = true
		end

		local tbl17 = {}

		if v20:IsA("ImageButton") or v20:IsA("ImageLabel") then
			tbl17.ImageTransparency = arg and 0 or 1
		end

		if v20:IsA("TextButton") or v20:IsA("TextLabel") then
			tbl17.TextTransparency = arg and 0 or 1
		end

		if v20.BackgroundTransparency ~= nil then
			tbl17.BackgroundTransparency = arg and 0 or 1
		end

		local tween12 = v6:Create(v20, infoTweenMini, tbl17)
		tween12:Play()

		tween12.Completed:Once(function()
			n8 -= 1

			if not arg then
				v20.Visible = false
			end

			if n8 <= 0 then
				flag11 = false
			end
		end)
	end
end

imageButton2.MouseButton1Click:Connect(function()
	if flag11 then
		return
	end

	if imageButton2:GetAttribute("Blocked") then
		return
	end

	if imageButton2:GetAttribute("Moved") then
		imageButton2:SetAttribute("Moved", false)
		return
	end
	estadoMiniUI = not estadoMiniUI
	aplicarVisibilidadeMini(estadoMiniUI)
end)

imageButton.MouseButton1Click:Connect(function()
	if imageButton:GetAttribute("Blocked") then
		return
	end

	if imageButton:GetAttribute("Moved") then
		imageButton:SetAttribute("Moved", false)
		return
	end
	imageButton.Visible = false
	frame.Visible = true

	if Tela5.Visible then
		NumeroGC(false)
	end

	fn2("122954374321453")
end)

BotaoFechar.MouseButton1Click:Connect(function()
	frame.Visible = false
	task.wait(0.2)
	imageButton.Visible = true
end)

animar = function(arg)
	if tbl8[arg] then
		return
	end
	tbl8[arg] = true
	local size = arg.Size
	local position = arg.Position

	if tbl9[arg] then
		for _, v20 in ipairs(tbl9[arg]) do
			v20:Cancel()
		end
	end

	tbl9[arg] = {}
	fn2("136328893130485")
	local tween12 = v6:Create(arg, tweenInfo5, { Size = size - UDim2.new(0, 6, 0, 6), Position = position + UDim2.new(0, 3, 0, 3) })
	local tween13 = v6:Create(arg, tweenInfo6, { Size = size, Position = position })
	local tween14 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 6 })
	local tween15 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = -6 })
	local tween16 = v6:Create(arg, TweenInfo.new(0.05), { Rotation = 0 })
	table.insert(tbl9[arg], tween12)
	table.insert(tbl9[arg], tween13)
	table.insert(tbl9[arg], tween14)
	table.insert(tbl9[arg], tween15)
	table.insert(tbl9[arg], tween16)
	tween12:Play()
	tween12.Completed:Wait()
	tween13:Play()
	tween14:Play()
	tween14.Completed:Wait()
	tween15:Play()
	tween15.Completed:Wait()
	tween16:Play()
	tween16.Completed:Wait()
	tbl8[arg] = nil
end

FecharMini.MouseButton1Click:Connect(function()
	fn2("85730811347567")
	Miniplayer.Image = "rbxassetid://102723588572082"
	SetMiniPlayer(false)
end)

Voltar.MouseButton1Click:Connect(function()
	Back()
	animar(Voltar)
end)

Retroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(Retroceder)
end)

Play.MouseButton1Click:Connect(function()
	Pause()
	animar(Play)
end)

Adiantar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(Adiantar)
end)

Pular.MouseButton1Click:Connect(function()
	Skip()
	animar(Pular)
end)

MiniBack.MouseButton1Click:Connect(function()
	Back()
	animar(MiniBack)
end)

MiniRetroceder.MouseButton1Click:Connect(function()
	Retroceder10s()
	animar(MiniRetroceder)
end)

MiniPlay.MouseButton1Click:Connect(function()
	Pause()
	animar(MiniPlay)
end)

MiniAvancar.MouseButton1Click:Connect(function()
	Avancar10s()
	animar(MiniAvancar)
end)

MiniSkip.MouseButton1Click:Connect(function()
	Skip()
	animar(MiniSkip)
end)

TelaCheia.MouseButton1Click:Connect(function()
	if isAnimating then
		return
	end
	isAnimating = true
	flag10 = not flag10
	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
		TelaCheia.Image = "rbxassetid://104681366724942"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.29, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.29, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.29, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.29, 0)
	else
		udim24 = udim2
		TelaCheia.Image = "rbxassetid://73952228795506"
		fn2("125296945528316")
		MiniBack.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniRetroceder.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniPlay.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniAvancar.Size = UDim2.new(0.18, -8, 0.27, 0)
		MiniSkip.Size = UDim2.new(0.18, -8, 0.27, 0)
		TelaCheia.Size = UDim2.new(0.18, -8, 0.27, 0)
		FecharMini.Size = UDim2.new(0.18, -8, 0.27, 0)
	end

	local tween12 = v6:Create(imageButton2, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), { Size = udim24 })
	tween12:Play()

	tween12.Completed:Connect(function()
		isAnimating = false
	end)
end)

REPORT_ID = nil
REPORT_MOTIVO = nil

local function fn14(arg)
	if REPORT_MOTIVO == nil then
		fn3(Traducao.ReportErro, Traducao.ReportErro10, 8)
		return
	end
	local n8 = #REPORT_MOTIVO
	if n8 < 10 or n8 > 200 then
		fn3(Traducao.ReportErro, Traducao.ReportErro11, 8)
		return
	end
	Denunciar.Active = false
	CancelarReport.Active = false
	DenunciarTexto.Text = "..."
	CancelarReportTexto.Text = "..."

	local ok3, result3 = pcall(function()
		return YmpRequest({
			Url = str3 .. "/report",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), msgid = tostring(arg), reason = REPORT_MOTIVO }),
		})
	end)

	if ok3 then
		local str10 = tostring(result3.Body or result3):gsub("^\"", ""):gsub("\"$", "")

		if str10 == "request denied" then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 8)
		elseif str10 == "invalid report" then
			fn3(Traducao.ReportErro, Traducao.ReportErro2, 8)
		elseif str10 == "server error" then
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		elseif str10 == "too many reports" then
			fn3(Traducao.ReportErro, Traducao.ReportErro4, 8)
		elseif str10 == "reporting to oneself is not allowed" then
			fn3(Traducao.ReportErro, Traducao.ReportErro5, 8)
		elseif str10 == "already reported by you" then
			fn3(Traducao.ReportErro, Traducao.ReportErro6, 8)
		elseif str10 == "already reported by another" then
			fn3(Traducao.ReportErro, Traducao.ReportErro7, 8)
		elseif str10 == "banned" then
			fn3(Traducao.ReportErro, Traducao.ReportErro8, 8)
		elseif string.find(tostring(str10), "reported") then
			fn3(Traducao.ReportSucesso, Traducao.ReportSucesso2, 8)
			task.wait(0.5)
			REPORT_ID = nil
			REPORT_MOTIVO = nil
			TextoReportFrame.Text = ""
			MotivoBox.Text = ""
			FotoReport.Image = ""
			ReportFrame.Visible = false
			frame.Visible = true
		else
			fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
		end
	else
		fn3(Traducao.ReportErro, Traducao.ReportErro3, 8)
	end

	task.wait(0.5)
	Denunciar.Active = true
	CancelarReport.Active = true
	DenunciarTexto.Text = "Report"
	CancelarReportTexto.Text = Traducao.Cancelar
end

Reportar = function(arg, arg2, image)
	REPORT_ID = arg2
	TextoReportFrame.Text = Traducao.AvisoReport1 .. " '{" .. arg .. "}' " .. Traducao.AvisoReport2
	FotoReport.Image = image
	ReportFrame.Visible = true
	frame.Visible = false
end

local function fn15(arg)
	if Warn.Visible then
		return
	end

	if v12 and v12.Playing then
		Pause()
	end

	if frame.Visible then
		frame.Visible = false
	end

	if imageButton.Visible then
		imageButton.Visible = false
	end

	if ReportFrame.Visible then
		REPORT_ID = nil
		TextoReportFrame.Text = ""
		FotoReport.Image = ""
		ReportFrame.Visible = false
	end

	task.wait(0.1)
	CloseWarn.BackgroundTransparency = 0.7
	CloseWarnTexto.TextColor3 = Color3.fromRGB(20, 20, 20)
	Warn.Visible = true
	BlurEffect.Size = 56
	fn2("107089652181213")
	TextoWarn.Text = Traducao.MsgMod .. " " .. arg
	task.wait(5)
	CloseWarn.BackgroundTransparency = 0
	CloseWarnTexto.TextColor3 = Color3.fromRGB(255, 255, 255)
end

ProFinal = function()
	local n8 = ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y

	if tween3 then
		tween3:Cancel()
	end

	tween3 = v6:Create(ScrollGC, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(0, n8) })
	tween3:Play()
end

ChekFinal = function()
	local y = ScrollGC.CanvasPosition.Y
	return math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 5
end

local function fn16(arg, text2, arg2, arg3)
	layoutOrder += 1
	task.wait()

	local function fn17(arg4)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg4
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg4)
		end)

		return ok3 and result3 or arg4
	end

	local v20 = fn17(arg2 or "")
	local result3 = nil

	if arg ~= "ymp" then
		local num = tonumber(arg)
		if not num then
			return
		end

		if tbl11[num] then
			result3 = tbl11[num]
		else
			local ok3

			ok3, result3 = pcall(function()
				local response = game:HttpGet("https://users.roblox.com/v1/users/" .. num)

				return {
					displayName = game:GetService("HttpService"):JSONDecode(response).displayName,
					image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. num .. "&width=420&height=420&format=png",
				}
			end)

			if not ok3 or not result3 or not result3.displayName then
				return
			end
			tbl11[num] = result3
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 1, 0, 1)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
	frame4.BorderSizePixel = 0
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BackgroundTransparency = 1
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, 0, 1, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.TextColor3 = Color3.fromRGB(192, 192, 192)
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local imageButton4 = Instance.new("ImageButton")
	imageButton4.Size = UDim2.new(0, 17, 0, 17)
	imageButton4.Position = UDim2.new(0, 200, 0, 12)
	imageButton4.BackgroundTransparency = 1
	imageButton4.BorderSizePixel = 0
	imageButton4.Visible = arg ~= tostring(userId) and arg ~= "ymp"
	imageButton4.Parent = imageLabel
	local imageLabel2 = Instance.new("ImageLabel")
	imageLabel2.Size = UDim2.new(0, 10, 0, 10)
	imageLabel2.Position = UDim2.new(0, 4, 0, 4)
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Image = "rbxassetid://74995247007994"
	imageLabel2.Parent = imageButton4
	local textSize = game:GetService("TextService"):GetTextSize(v20, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 180, 0, textSize.Y + 10)
	frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame6.BackgroundTransparency = 0.7
	frame6.BorderSizePixel = 0
	frame6.Parent = frame3
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Size = UDim2.new(0, 170, 0, textSize.Y)
	textLabel4.BackgroundTransparency = 1
	textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel4.Font = Enum.Font.SourceSansBold
	textLabel4.TextWrapped = true
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.TextYAlignment = Enum.TextYAlignment.Top
	textLabel4.TextSize = 14
	textLabel4.Text = v20
	textLabel4.Parent = frame6
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, v20, 5)
		YmpClipboard(v20)
	end)

	if arg == "ymp" then
		imageLabel.Image = "rbxassetid://83758613781843"
		imageLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		textLabel.Text = "YMP OFFICIAL"
		textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel2.Text = Traducao.Sistema
		textLabel2.TextColor3 = Color3.fromRGB(255, 0, 0)
		textLabel3.TextColor3 = Color3.fromRGB(255, 0, 0)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(imageButton4, 255, 255, 255, 1)
		Stroke(textLabel2, 255, 255, 255, 0.5)
		Stroke(textLabel3, 255, 255, 255, 0.5)
		Stroke(textLabel, 255, 255, 255, 0.5)
	else
		imageLabel.Image = result3.image and result3.image ~= "" and result3.image or "rbxassetid://106804518898726"
		textLabel.Text = result3.displayName
		textLabel2.Text = text2
		Stroke(imageLabel, 50, 50, 50, 1)
		Stroke(frame4, 50, 50, 50, 1)
		Stroke(frame5, 50, 50, 50, 1)
		Stroke(imageButton3, 50, 50, 50, 1)
		Stroke(imageButton4, 50, 50, 50, 1)
		Stroke(textLabel, 50, 50, 50, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(imageButton4, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	imageButton4.MouseButton1Click:Connect(function()
		if not flag19 then
			fn3(Traducao.ReportErro, Traducao.ReportErro1, 10)
			return
		end
		Reportar(text2, arg3, imageLabel.Image)
	end)

	if v21 then
		task.wait()
		ProFinal()
	end
end

local function fn17(arg, text2, arg2, arg3, arg4)
	layoutOrder += 1
	task.wait()
	local str10 = arg4 or ""

	local function fn18(arg5)
		local tbl17 = {}
		local n8 = 1

		while n8 <= #arg5 do
			local v20, v21, v22, v23 = string.find(arg5, "<:([%w_]+):(%d+)>", n8)

			if v20 then
				if v20 > n8 then
					table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8, v20 - 1) })
				end

				table.insert(tbl17, { tipo = "emoji", id = v23 })
				n8 = v21 + 1
			else
				table.insert(tbl17, { tipo = "texto", valor = string.sub(arg5, n8) })
				break
			end
		end

		return tbl17
	end

	local function fn19(arg5)
		if not (FotoTradu and FotoTradu.Image == "rbxassetid://72657045512999") then
			return arg5
		end

		local ok3, result3 = pcall(function()
			return TraduzirMsg(arg5)
		end)

		return ok3 and result3 or arg5
	end

	local v20 = fn18(str10)

	for _, v21 in ipairs(v20) do
		if v21.tipo == "texto" then
			v21.valor = fn19(v21.valor)
		end
	end

	local tbl17 = {}

	for _, v21 in ipairs(v20) do
		if v21.tipo == "emoji" then
			local id = v21.id
			local str11 = "YouTube Music Player/internal/Cache/emoji_" .. id .. ".png"

			if isfile and isfile(str11) then
				tbl17[id] = getcustomasset(str11)
			else
				local ok3, result3 = pcall(function()
					return game:HttpGet("https://cdn.discordapp.com/emojis/" .. id .. ".png")
				end)

				ok3 = ok3 and result3 and writefile
				local str12 = "rbxassetid://110787075859454"

				if ok3 then
					if pcall(function()
						writefile(str11, result3)
					end) and getcustomasset then
						str12 = getcustomasset(str11)
					end
				end

				tbl17[id] = str12
			end
		end
	end

	local str11 = "YouTube Music Player/internal/Cache/Dc_" .. tostring(arg) .. ".jpg"
	local image

	if isfile and isfile(str11) then
		image = getcustomasset(str11)
	else
		local ok3, result3 = pcall(function()
			return game:HttpGet(arg3)
		end)

		ok3 = ok3 and writefile
		image = "rbxassetid://106804518898726"

		if ok3 then
			if pcall(function()
				writefile(str11, result3)
			end) and getcustomasset then
				image = getcustomasset(str11)
			end
		end
	end

	if not Tela5.Visible or imageButton.Visible == true then
		NumeroGC()
	end

	local v21 = ChekFinal()
	local frame3 = Instance.new("Frame")
	frame3.Size = UDim2.new(0.9, 0, 0, 0)
	frame3.AutomaticSize = Enum.AutomaticSize.Y
	frame3.BackgroundTransparency = 1
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = ScrollGC
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = frame3
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Size = UDim2.new(0, 40, 0, 40)
	imageLabel.Position = UDim2.new(0, 4, 0, 4)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = image
	imageLabel.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Size = UDim2.new(0, 60, 0, 15)
	frame4.Position = UDim2.new(0, 47, 0, 12)
	frame4.Parent = imageLabel
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text2 or ""
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = true
	textLabel.Parent = frame4
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 1)
	uiPadding.PaddingTop = UDim.new(0, 1)
	uiPadding.PaddingRight = UDim.new(0, 1)
	uiPadding.PaddingBottom = UDim.new(0, 1)
	uiPadding.Parent = textLabel
	local frame5 = Instance.new("Frame")
	frame5.Size = UDim2.new(0, 60, 0, 15)
	frame5.Position = UDim2.new(0, 112, 0, 12)
	frame5.BorderSizePixel = 0
	frame5.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Size = UDim2.new(1, -7, 1, 0)
	textLabel2.Position = UDim2.new(0, 4, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Font = Enum.Font.SourceSansBold
	textLabel2.TextScaled = true
	textLabel2.Parent = frame5
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(1, -10, 0, 0)
	frame6.AutomaticSize = Enum.AutomaticSize.Y
	frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame6.BackgroundTransparency = 0.7
	frame6.Parent = frame3
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.PaddingLeft = UDim.new(0, 5)
	uiPadding2.PaddingRight = UDim.new(0, 5)
	uiPadding2.PaddingTop = UDim.new(0, 5)
	uiPadding2.PaddingBottom = UDim.new(0, 5)
	uiPadding2.Parent = frame6
	local imageButton3 = Instance.new("ImageButton")
	imageButton3.Size = UDim2.new(0, 17, 0, 17)
	imageButton3.Position = UDim2.new(0, 177, 0, 12)
	imageButton3.BorderSizePixel = 0
	imageButton3.Parent = imageLabel
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Size = UDim2.new(1, -7, 1, 0)
	textLabel3.Position = UDim2.new(0, 3, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Font = Enum.Font.SourceSansBold
	textLabel3.TextScaled = true
	textLabel3.Text = "C"
	textLabel3.Parent = imageButton3
	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout2.Wraps = true
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.Padding = UDim.new(0, 2)
	uiListLayout2.Parent = frame6
	local uiPadding3 = Instance.new("UIPadding")
	uiPadding3.PaddingLeft = UDim.new(0, 5)
	uiPadding3.PaddingTop = UDim.new(0, 5)
	uiPadding3.PaddingRight = UDim.new(0, 5)
	uiPadding3.PaddingBottom = UDim.new(0, 5)
	uiPadding3.Parent = frame6

	imageButton3.MouseButton1Click:Connect(function()
		fn3(Traducao.TextoCopiado, arg4, 5)
		YmpClipboard(arg4)
	end)

	local function fn20(text3)
		if text3 == "" then
			return
		end
		local textLabel4 = Instance.new("TextLabel")
		textLabel4.BackgroundTransparency = 1
		textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel4.Font = Enum.Font.SourceSansBold
		textLabel4.TextSize = 14
		textLabel4.TextWrapped = true
		textLabel4.TextXAlignment = Enum.TextXAlignment.Left
		textLabel4.TextYAlignment = Enum.TextYAlignment.Top
		textLabel4.Text = text3
		local textSize = game:GetService("TextService"):GetTextSize(text3, 16, Enum.Font.SourceSansBold, Vector2.new(170, math.huge))
		local max = math.max
		local y = textSize.Y
		textLabel4.Size = UDim2.new(0, math.min(textSize.X, 170), 0, max(y, 21))
		textLabel4.Parent = frame6
	end

	local function fn21(arg5)
		local imageLabel2 = Instance.new("ImageLabel")
		imageLabel2.Size = UDim2.new(0, 21, 0, 21)
		imageLabel2.BackgroundTransparency = 1
		imageLabel2.Image = tbl17[arg5]
		imageLabel2.Parent = frame6
	end

	for _, v22 in ipairs(v20) do
		if v22.tipo == "texto" then
			fn20(v22.valor)
		else
			fn21(v22.id)
		end
	end

	if arg2 == "Mod" then
		textLabel.TextColor3 = Color3.fromRGB(255, 160, 122)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		frame5.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		imageButton3.BackgroundColor3 = Color3.fromRGB(255, 99, 71)
		textLabel2.Text = "Mod"
		textLabel2.TextColor3 = Color3.fromRGB(255, 160, 122)
		textLabel3.TextColor3 = Color3.fromRGB(255, 160, 122)
		Stroke(frame4, 255, 160, 122, 1)
		Stroke(imageLabel, 255, 160, 122, 1.5)
		Stroke(frame5, 255, 160, 122, 1)
		Stroke(imageButton3, 255, 160, 122, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Admin" then
		textLabel.TextColor3 = Color3.fromRGB(220, 20, 60)
		frame4.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		frame5.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		imageButton3.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
		textLabel2.Text = "Admin"
		textLabel2.TextColor3 = Color3.fromRGB(220, 20, 60)
		textLabel3.TextColor3 = Color3.fromRGB(220, 20, 60)
		Stroke(frame4, 220, 20, 60, 1)
		Stroke(imageLabel, 220, 20, 60, 1)
		Stroke(frame5, 220, 20, 60, 1)
		Stroke(imageButton3, 220, 20, 60, 1)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	elseif arg2 == "Dev" then
		textLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		imageButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
		textLabel2.Text = "Dev"
		textLabel2.TextColor3 = Color3.fromRGB(255, 215, 0)
		textLabel3.TextColor3 = Color3.fromRGB(255, 215, 0)
		Stroke(frame4, 0, 0, 0, 1.5)
		Stroke(imageLabel, 0, 0, 0, 1.5)
		Stroke(textLabel, 0, 0, 0, 1)
		Stroke(frame5, 0, 0, 0, 1.5)
		Stroke(imageButton3, 0, 0, 0, 1.5)
		Stroke(textLabel2, 0, 0, 0, 1)
		Stroke(textLabel3, 0, 0, 0, 1)
	else
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		frame4.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		frame5.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		imageButton3.BackgroundColor3 = Color3.fromRGB(30, 144, 255)
		textLabel2.Text = "Discord"
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
		Stroke(frame4, 255, 255, 255, 1)
		Stroke(imageLabel, 255, 255, 255, 1)
		Stroke(textLabel, 0, 0, 0, 0.5)
		Stroke(frame5, 255, 255, 255, 1)
		Stroke(imageButton3, 255, 255, 255, 1)
		Stroke(textLabel2, 0, 0, 0, 0.5)
		Stroke(textLabel3, 0, 0, 0, 0.5)
	end

	Corner(imageLabel, 30)
	Corner(frame4, 30)
	Corner(frame5, 30)
	Corner(imageButton3, 30)
	Corner(frame6, 5)
	Stroke(frame6, 50, 50, 50, 0.2)

	if v21 then
		task.wait()
		ProFinal()
	end
end

IndoFinal = function(arg)
	if arg == v13 then
		return
	end
	estadoAtual = arg
	local v20 = arg and udim23 or udim22

	if v13 then
		tween2:Cancel()
	end

	tween2 = v6:Create(FinalGC, tweenInfo3, { Position = v20 })
	tween2:Play()
end

ScrollGC:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
	local y = ScrollGC.CanvasPosition.Y
	local flag22 = math.max(ScrollGC.AbsoluteCanvasSize.Y - ScrollGC.AbsoluteWindowSize.Y, 0) - y <= 120

	if flag22 ~= flag15 then
		flag15 = flag22
		IndoFinal(flag22)
	end
end)

FinalGC.MouseButton1Click:Connect(function()
	ProFinal()
end)

ScrollGC.ChildAdded:Connect(function()
	local tbl17 = {}
	EsperandoIMG.Visible = false
	ScrollGC.Visible = true

	for _, child in ipairs(ScrollGC:GetChildren()) do
		if child:IsA("Frame") then
			table.insert(tbl17, child)
		end
	end

	if #tbl17 > 30 then
		table.sort(tbl17, function(arg, arg2)
			return arg.LayoutOrder < arg2.LayoutOrder
		end)

		task.wait()
		tbl17[1]:Destroy()
	end
end)

local function fn18(arg)
	MsgErroGC.Visible = true
	MsgErroGC.Text = Traducao.GcBan .. " " .. tostring(arg or "")
	GCBox.Active = false
	GCBox.Visible = false
	SendGC.Visible = false
	Traduzir.Visible = false
	LinhaTraducao.Visible = false
	fn3(Traducao.Banido, Traducao.GcBan .. " " .. tostring(arg or ""), 10)
end

local function fn19()
	fn3(Traducao.Desbanido, Traducao.GcUnban, 10)

	if flag19 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	else
		MsgErroGC.Text = Traducao.GcKey
	end
end

local function fn20(arg)
	if arg == flag20 then
		return
	end

	if flag19 then
		return
	end

	if arg then
		if not flag16 and websocket_ ~= nil then
			flag20 = true
			MsgErroGC.Visible = false
			GCBox.Active = true
			GCBox.Visible = true
			SendGC.Visible = true
			Traduzir.Visible = true
			LinhaTraducao.Visible = true
			fn3(Traducao.Keyless, Traducao.KeylessOn, 15, 93360393539898)
		end
	elseif not flag19 and not flag16 then
		flag20 = false
		MsgErroGC.Visible = true
		MsgErroGC.Text = Traducao.GcKey
		GCBox.Active = false
		GCBox.Visible = false
		SendGC.Visible = false
		Traduzir.Visible = false
		LinhaTraducao.Visible = false
		fn3(Traducao.Keyless, Traducao.KeylessOff, 15, 93360393539898)
	end
end

hwidUrl = "wss://ymp-api.ddns.net/gc" .. "?hwid=" .. tostring(YmpHwid())

task.spawn(function()
	local flag22 = false
	local v20 = nil
	local n8 = 0
	local n9 = 0

	local function fn21()
		if not websocket_ then
			return
		end

		if flag22 then
			return
		end
		flag22 = true
		n8 += 1

		local ok3, result3 = pcall(function()
			local connect = websocket_.connect or websocket_.Connect or websocket_.new or websocket_.New
			if not connect then
				return nil
			end
			return connect(hwidUrl)
		end)

		if not ok3 or not result3 then
			flag22 = false
			return
		end
		v20 = result3
		flag22 = false

		if v20.OnClose then
			v20.OnClose:Connect(function()
				v20 = nil
			end)
		end

		local onMessage = result3.OnMessage or result3.onmessage or result3.MessageReceived

		if onMessage then
			onMessage:Connect(function(arg)
				if not arg then
					return
				end

				if arg == "keyless" then
					fn20(true)
					return
				end

				if arg == "unkeyless" then
					fn20(false)
					return
				end

				if arg:sub(1, 6) == "banned" then
					local match = arg:match("banned:%s*(%S+)")
					flag16 = true
					fn18(match)
					return
				end

				if arg == "unbanned" then
					flag16 = false
					fn19()
					return
				end

				if arg:sub(1, 6) == "warned" then
					fn15(arg:match("reason:%s*(.+)") or "")
					return
				end

				if arg:sub(1, 6) == "system" then
					local match = arg:match("message:%s*(.+)")

					if match then
						fn16("ymp", "a", match, "0")
						fn3(Traducao.Sistema, match, 10)
					else
						local match2 = arg:match("system\n(.+)")

						if match2 then
							fn16("ymp", "a", match2, "0")
						end
					end

					return
				end

				if arg:sub(1, 7) == "discord" then
					local match = arg:match("id:%s*([^\n]+)")
					local match2 = arg:match("name:%s*([^\n]+)")
					local match3 = arg:match("rank:%s*([^\n]+)")
					local match4 = arg:match("image:%s*([^\n]*)")
					local match5 = arg:match("message:%s*(.+)")

					if match and match2 and match3 and match5 then
						fn17(match, match2, match3, match4 ~= "" and match4 or nil, match5)
					end

					return
				end

				local match = arg:match("UserId:%s*(%d+)")
				local match2 = arg:match("id:%s*(%S+)")
				local match3 = arg:match("message:%s*(.+)")
				local match4 = arg:match("msgid:%s*(%d+)")

				if match and match2 and match3 then
					fn16(match, match2, match3, match4)
				end
			end)
		end
	end

	task.spawn(function()
		while task.wait(2) do
			if websocket_ then
				if not flag22 then
					if not v20 then
						if not (os.clock() - n9 < 3) then
							n9 = os.clock()
							fn21()
						end
					end
				end
			end
		end
	end)

	fn21()
end)

local function fn21(arg)
	if not arg or arg == "" then
		return
	end

	if not CheckRequest() then
		return
	end

	local v20 = YmpRequest({
		Url = str3 .. "/sendgc",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ key = KEY_ATUAL, hwid = YmpHwid(), Userid = userId, msg = arg }),
	})

	if v20 and v20.Body then
		local str10 = tostring(v20.Body):gsub("%s+", ""):gsub("\"", "")

		if str10 == "banned" then
			flag16 = true
			fn18()
		elseif str10 == "requestdenied" then
			fn3(Traducao.ErroCrackTitle, Traducao.ErroCrackText, 10)
		end
	end

	return v20
end

SendGC.MouseButton1Click:Connect(function()
	if Aviao.ImageTransparency ~= 0 then
		return
	end
	local text2 = GCBox.Text

	if text2 and text2 ~= "" then
		GCBox.Text = ""
		Aviao.ImageTransparency = 0.7
		fn21(text2)
		task.wait(3)
		Aviao.ImageTransparency = 0
	end
end)

GCBox.FocusLost:Connect(function()
	local match = GCBox.Text:gsub("[\r\n]", ""):match("^%s*(.-)%s*$")
	if match == "" then
		GCBox.Text = ""
		return
	end

	if #match > 200 then
		match = match:sub(1, 200)
	end

	GCBox.Text = match
end)

Regras.MouseButton1Click:Connect(function()
	fn3(Traducao.RegrasTi, Traducao.Regras, 10)
end)

NotificarGC.MouseButton1Click:Connect(function()
	if Sino.Image == "rbxassetid://115374069603142" then
		Sino.Image = "rbxassetid://89973491623305"
		fn3(Traducao.GCmudo, Traducao.GCmudoTexto, 6)
		flag17 = true
	else
		Sino.Image = "rbxassetid://115374069603142"
		fn3(Traducao.GCunmudo, Traducao.GCunmudoTexto, 6)
		flag17 = false
	end
end)

Denunciar.MouseButton1Click:Connect(function()
	if not Denunciar.Active then
		return
	end
	fn14(REPORT_ID)
end)

MotivoBox.FocusLost:Connect(function()
	local match = MotivoBox.Text:match("^%s*(.-)%s*$")

	if match == "" then
		MotivoBox.Text = ""
		REPORT_MOTIVO = nil
	else
		REPORT_MOTIVO = match
	end
end)

CancelarReport.MouseButton1Click:Connect(function()
	if not CancelarReport.Active then
		return
	end
	REPORT_ID = nil
	REPORT_MOTIVO = nil
	TextoReportFrame.Text = ""
	MotivoBox.Text = ""
	FotoReport.Image = ""
	ReportFrame.Visible = false
	frame.Visible = true
end)

CloseWarn.MouseButton1Click:Connect(function()
	if CloseWarn.BackgroundTransparency ~= 0 then
		return
	end
	Warn.Visible = false
	BlurEffect.Size = 0
	imageButton.Visible = true
	fn2("88442833509532")
end)

Traduzir.MouseButton1Click:Connect(function()
	if FotoTradu.Image == "rbxassetid://84867288877251" then
		FotoTradu.Image = "rbxassetid://72657045512999"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOn, 5)
	else
		FotoTradu.Image = "rbxassetid://84867288877251"
		fn3(Traducao.TraducaoSystem, Traducao.TraduOff, 5)
	end
end)

Priv1.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri1, 8)
end)

Priv2.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri2, 8)
end)

Priv3.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri3, 8)
end)

Priv4.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri4, 8)
end)

Priv5.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri5, 8)
end)

Priv6.MouseButton1Click:Connect(function()
	fn3(Traducao.PP, Traducao.SobrePri6, 8)
end)

local function fn22()
	pcall(function()
		game:GetService("Players").LocalPlayer:Kick("[Sussy Activity]\nPlease do not attempt to crack the script!")
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Remove()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer:Destroy()
	end)

	pcall(function()
		game:GetService("Players").LocalPlayer.Parent = nil
	end)

	task.wait(2)

	while true do
	end
end

LockedUIS = { Video, imageButton2, frame2 }

for _, v20 in ipairs(LockedUIS) do
	if v20:IsA("GuiObject") then
		v20:GetPropertyChangedSignal("Visible"):Connect(function()
			if v20.Visible == true and flag19 == false then
				fn22()
			end
		end)
	end
end

SetKey = function(key)
	task.spawn(function()
		table.insert(tbl7, function()
			local ok3, result3 = pcall(function()
				return HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))
			end)

			local v20 = ok3 and result3
			local tbl17

			if v20 then
				tbl17 = v20
			else
				tbl17 = { { Key = "", Favorites = tbl6 or {} } }
			end

			tbl17[1] = tbl17[1] or { Key = "", Favorites = {} }
			tbl17[1].Key = key or ""

			pcall(function()
				writefile("YouTube Music Player/Internal/Data.json", HttpService:JSONEncode(tbl17))
			end)
		end)

		processQueue()
	end)
end

local function fn23()
	if flag19 == true then
		return
	end
	flag19 = true
	KeyFrame.Visible = false
	GetKey.Visible = false
	PremiumOkTexto.Text = "<font color=\"rgb(255,255,255)\">" .. Traducao.VocePremium .. "</font>\n<font color=\"rgb(192,192,192)\">" .. Traducao.VocePremiumTexto .. "</font>"
	frame2.Visible = true
	imageButton2.Parent = screenGui
	Video.Parent = Tela2
	BotaoMp4.BackgroundTransparency = 0
	NomeMp4.TextColor3 = Color3.fromRGB(154, 205, 50)
	BotaoMp4.AutoButtonColor = true
	AplicarFiltro.BackgroundTransparency = 0
	RemoverFiltro.BackgroundTransparency = 0
	NomeAplicarFiltro.TextColor3 = Color3.fromRGB(154, 205, 50)
	NomeRemoverFiltro.TextColor3 = Color3.fromRGB(178, 34, 34)
	AplicarFiltro.AutoButtonColor = true
	RemoverFiltro.AutoButtonColor = true
	PesquisarBox.PlaceholderText = Traducao.Pesquisar2
	imageButton.Image = "rbxassetid://76673896881913"
	fn3(Traducao.VocePremium, Traducao.VocePremiumTexto, 15)
	imageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Stroke(imageButton, 255, 215, 0, 3)

	if not flag16 and websocket_ ~= nil and not flag20 then
		MsgErroGC.Visible = false
		GCBox.Active = true
		GCBox.Visible = true
		SendGC.Visible = true
		Traduzir.Visible = true
		LinhaTraducao.Visible = true
	end

	for _, child in ipairs(ScrollPagina:GetChildren()) do
		if child:IsA("ImageButton") and child.Name ~= "1" then
			child.BackgroundTransparency = 0
			local textLabel = child:FindFirstChildOfClass("TextLabel")

			if textLabel then
				textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end
	end

	for _, v20 in ipairs(scrolls) do
		for _, child in ipairs(v20:GetChildren()) do
			if child:IsA("ImageButton") and not child:GetAttribute("Privado") then
				local match = child.Name:match(":(.+)$")
				child.Name:match("^(.-):")
				local tag = child:FindFirstChild("tag")
				local imageLabel = child:FindFirstChildWhichIsA("ImageLabel")

				if match and tag and imageLabel then
					if match == "Video" or match == "Roblox" then
						child.BackgroundTransparency = 0
						imageLabel.BackgroundTransparency = 0
						imageLabel.ImageTransparency = 0
						tag.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	end
end

Token = nil

local function fn24()
	pcall(function()
		local fn25

		fn25 = function(arg, arg2)
			local tbl17 = arg2 or {}
			local kind = typeof(arg)
			if kind == "nil" then
				return "nil"
			end

			if kind == "string" then
				return arg
			end

			if kind == "number" then
				if arg ~= arg then
					return "nan"
				end
				local str10 = ""

				if arg < 0 then
					arg = -arg
					str10 = "-"
				end

				local n8 = math.floor(arg)
				local n9 = arg - n8
				local str11 = ""

				repeat
					str11 = string.char(48 + n8 % 10) .. str11
					n8 = math.floor(n8 / 10)
				until n8 == 0

				if n9 > 0 then
					str11 ..= "."
					local n10 = 0

					while n9 > 0 and n10 < 6 do
						local n11 = n9 * 10
						local n12 = math.floor(n11)
						str11 ..= string.char(48 + n12)
						n9 = n11 - n12
						n10 += 1
					end
				end

				return str10 .. str11
			end

			if kind == "boolean" then
				if arg then
					return "true"
				end
				return "false"
			end

			if kind == "table" then
				if tbl17[arg] then
					return "{cycle}"
				end
				tbl17[arg] = true
				local tbl18 = {}

				for k, v20 in pairs(arg) do
					table.insert(tbl18, "[" .. fn25(k, tbl17) .. "]=" .. fn25(v20, tbl17))
				end

				return "{ " .. table.concat(tbl18, ", ") .. " }"
			end

			return "<" .. kind .. ">"
		end

		local jobId = game.JobId
		local str10 = HttpService:GenerateGUID(false) .. HttpService:GenerateGUID(false) .. jobId .. tick() .. os.clock() .. os.time() .. os.date("%Y%m%d%H%M%S") .. math.random() .. fn25({})
		local n8 = 2166136261

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			local n9 = bit32.bxor(n8, v20) * 16777619 % 4294967296
			n8 = bit32.bxor(n9, bit32.rshift(n9, 13)) * 2246822519 % 4294967296
		end

		math.randomseed(n8)
		local str11 = ""
		local n9 = 1

		while true do
			local n10 = math.random(1, 62)
			local str12 = str11 .. string.sub("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789", n10, n10)
			local n11 = bit32.bxor(n8, n10 * n9) * 3266489917 % 4294967296
			n8 = bit32.bxor(n11, bit32.lshift(n11, 11))

			if #str12 > 10 and bit32.band(n8, 3) == 0 then
				local n12 = math.floor(#str12 / 2)
				local str13 = string.sub(str12, 1, n12)
				str12 = string.sub(str12, n12 + 1) .. str13
			end

			if #str12 > 15 and bit32.band(n8, 7) == 1 then
				str11 = ""

				for i = #str12, 1, -1 do
					str11 ..= string.sub(str12, i, i)
				end
			else
				str11 = str12
			end

			local v20 = bit32.band(n8, 15)
			if not (#str11 > 110 and v20 == 0 or #str11 > 111) then
				n9 += 1
				continue
			end
			break
		end

		Token = str11
	end)
end

local function fn25(arg)
	local tbl17 = { bit32.bxor, bit32.lrotate, string.byte, string.format, tostring }

	if typeof(ishooked) == "function" and typeof(restorefunction) == "function" then
		local ok3, result3 = pcall(ishooked, ishooked)

		if ok3 and result3 then
			pcall(restorefunction, ishooked)
		end

		local v20 = ishooked

		for _, v21 in ipairs(tbl17) do
			local ok4, result4 = pcall(v20, v21)
			if not ok4 or result4 then
				return
			end
		end
	end

	local function fn26(arg2)
		local str10 = tostring(arg2 or "nil")
		local n8 = 2246822507
		local n9 = 3266489909
		local n10 = 2146245185

		for i = 1, #str10 do
			local v20 = string.byte(str10, i)
			n8 = (bit32.lrotate(bit32.bxor(n8, v20 + i), 13) * 5 + 3864292196) % 4294967296
			n9 = (bit32.lrotate(bit32.bxor(n9, n8 + v20), 17) * 3 + 2246822507) % 4294967296
			n10 = (bit32.lrotate(bit32.bxor(n10, n9 + i), 19) * 7 + 2815685321) % 4294967296
		end

		local v20 = bit32.bxor(n8, n9, n10, 2674666769)
		local str11 = string.format("%08x%08x%08x%08x%08x", n8, n9, n10, 2674666769, v20)
		return (str11 .. string.reverse(str11)):sub(1, 40)
	end

	if arg == fn26(Token) and #Token > 110 then
		fn23()
	else
		SetKey("")
	end
end

local function fn26(arg)
	local now = os.clock()
	local flag22 = false
	local str10 = nil

	task.spawn(function()
		local v20 = HttpService
		local str11 = str3 .. "/check/" .. arg .. "/" .. YmpHwid() .. "/" .. v20:UrlEncode(Token)

		local ok3, result3 = pcall(function()
			return game:HttpGet(str11)
		end)

		if not CheckRequest() then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		if not (ok3 and result3) then
			fn3(Traducao.Erro, Traducao.FalhaAoChekar, 10)
			KeyBox.Active = true
			str10 = "error"
			flag22 = true
			return
		end

		local v21 = string.lower(result3)

		if string.find(v21, "request denied") then
			str10 = "invalid"
			flag22 = true
			return
		end

		if string.find(v21, "too many request") then
			str10 = "too"
			flag22 = true
			return
		end

		if string.find(v21, "already registered") then
			str10 = "already"
			flag22 = true
			return
		end

		local v22 = string.match(result3, "Ok:%s*(.+)")

		if not v22 then
			str10 = "error"
			flag22 = true
			return
		end

		task.wait(1)
		fn25(v22)
		SetKey(arg)
		str10 = "ok"
		flag22 = true
	end)

	while not flag22 do
		if os.clock() - now > 10 then
			return "error"
		end
		task.wait()
	end

	return str10 or "error"
end

local function fn27()
	if CACHE_LINK ~= nil then
		YmpClipboard(CACHE_LINK)
		fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
		return CACHE_LINK
	end

	if not CheckRequest() then
		return nil
	end

	local ok3, result3 = pcall(function()
		return game:HttpGet(str3 .. "/getkey?hwid=" .. tostring(YmpHwid()))
	end)

	if not ok3 or not result3 then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	local data2 = nil

	pcall(function()
		data2 = game:GetService("HttpService"):JSONDecode(result3)
	end)

	if not data2 or not data2.success or not data2.url then
		fn3("Premium Key", Traducao.KeyError, 5)
		return nil
	end
	CACHE_LINK = data2.url
	YmpClipboard(CACHE_LINK)
	fn3(Traducao.LinkCopiado, Traducao.Navegador, 10)
	return CACHE_LINK
end

SetaES.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		GetKey.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaES.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaDI.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(255, 255, 153)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		GetKey.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaES.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaDI.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
	end
end)

SetaDI.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		GetKey.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaES.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		SetaDI.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
		GetKeyTexto.Text = Traducao.Robux
		GetKeyTexto.TextColor3 = Color3.fromRGB(255, 255, 153)
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		GetKey.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaES.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		SetaDI.BackgroundColor3 = Color3.fromRGB(47, 79, 79)
		GetKeyTexto.Text = Traducao.Link
		GetKeyTexto.TextColor3 = Color3.fromRGB(70, 130, 180)
	end
end)

local function fn28(text2)
	fn3("Premium Key", text2, 5)
	KeyBox.Active = false
	KeyBox.TextColor3 = Color3.fromRGB(255, 0, 0)
	KeyBox.Text = text2
	task.wait(2)
	KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	KeyBox.Text = ""
	KeyBox.Active = true
end

local function fn29()
	if KEY_ATUAL and KEY_ATUAL ~= "" then
		KeyBox.Active = false
		fn24()

		if not KEY_ATUAL:match("^KEY_") and not KEY_ATUAL:match("^FREE_") then
			fn28(Traducao.KeyInvalida)
			SetKey("")
			return
		end

		local v20 = fn26(KEY_ATUAL)
		if v20 == true then
			return
		end

		if v20 == "invalid" then
			fn28(Traducao.KeyInvalida)
			SetKey("")
		elseif v20 == "error" then
			fn28(Traducao.KeyErro)
		elseif v20 == "already" then
			fn28(Traducao.JaTemKey)
		elseif v20 == "too" then
			fn28(Traducao.RateLi)
		end
	end
end

KeyBox.FocusLost:Connect(function()
	if KeyBox.Active and KeyBox.Text then
		local match = KeyBox.Text:match("^%s*(.-)%s*$")
		if match == "" then
			KeyBox.Text = ""
			return
		end
		KEY_ATUAL = match
		fn29()
	end
end)

GetKey.MouseButton1Click:Connect(function()
	if GetKey.BackgroundColor3 == Color3.fromRGB(255, 215, 0) then
		fn3(Traducao.LinkCopiado, "https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase", 8)
		YmpClipboard("https://www.roblox.com/games/113089627618447/CHAOTIC-Purchase")
	elseif GetKey.BackgroundColor3 == Color3.fromRGB(47, 79, 79) then
		fn27()
	end
end)

uiScale = frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", frame)

Resize = function()
	local viewportSize = currentCamera.ViewportSize
	uiScale.Scale = math.min(viewportSize.X * 0.8 / frame.AbsoluteSize.X / uiScale.Scale, viewportSize.Y * 0.8 / frame.AbsoluteSize.Y / uiScale.Scale, 1)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)

	task.defer(function()
		if flag8 then
			return
		end
		local v20 = v12
		local flag22 = v12

		if v20 then
			flag22 = v20.TimeLength > 0
		end

		if flag22 then
			setProgress(v20.TimePosition / v20.TimeLength)
		end
	end)
end

ResizeJa = function()
	imageButton.AnchorPoint = Vector2.new(0.5, 0)
	imageButton.Position = UDim2.new(0.5, 0, 0, 20)
end

ResizeMiniPlayer = function()
	local viewportSize = currentCamera.ViewportSize

	if viewportSize.Y > viewportSize.X then
		udim2 = UDim2.new(0.45, 0, 0.1, 0)
	else
		udim2 = UDim2.new(0.27, 0, 0.37, 0)
	end

	local udim24

	if flag10 then
		udim24 = UDim2.new(udim2.X.Scale * 1.4, 0, udim2.Y.Scale * 1.4, 0)
	else
		udim24 = udim2
	end

	imageButton2.Size = udim24
	imageButton2.Position = UDim2.new(1, -20, 1, -20)
end

currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	Resize()
	ResizeJa()
	ResizeMiniPlayer()
end)

Resize()
ResizeJa()
ResizeMiniPlayer()

game:GetService("GuiService").MenuOpened:Connect(function()
	if flag or not frame.Visible then
		return
	end
	frame.Visible = false
	imageButton.Visible = true
end)

v5.MessageOut:Connect(function(arg)
	if type(arg) ~= "string" then
		return
	end
	local str10 = arg:lower():gsub("%s+", "")

	if str10:match("^failedtoloadrbxasset://.+%.mp3$") or str10:match("^failedtoloadrbxasset://.+%.webm$") then
		fn3(Traducao.MidiaErro, Traducao.MidiaErroMsg, 10)
	end
end)

Corner(frame, 5)
Corner(imageButton, 30)
Corner(ContadorJA, 30)
Corner(ContadorJABO, 30)
Corner(Titulo, 30)
Corner(Mutar, 30)
Corner(BotaoFechar, 22)
Corner(Welcome, 5)
Corner(Navegacao, 5)
Corner(Playlist, 5)
Corner(TituloNave, 32)
Corner(FotoNave, 32)
Corner(TituloPlayL, 32)
Corner(FotoPlayL, 32)
Corner(Botao1, 5)
Corner(Botao2, 5)
Corner(Botao3, 5)
Corner(Botao4, 5)
Corner(Botao5, 5)
Corner(Botao6, 5)
Corner(Icone1, 5)
Corner(Icone2, 5)
Corner(Icone3, 5)
Corner(Icone4, 5)
Corner(Icone5, 5)
Corner(Icone6, 5)
Corner(EsquerdaPL, 5)
Corner(FrameAbaPL, 5)
Corner(DireitaPL, 5)
Corner(ErroPL, 5)
Corner(Dev, 5)
Corner(FotoDev, 50)
Corner(Social, 5)
Corner(SocialTitulo, 5)
Corner(You, 32)
Corner(IconeYou, 32)
Corner(Discord, 32)
Corner(IconeDiscord, 32)
Corner(Musica, 5)
Corner(Video, 5)
Corner(TempoAtual, 5)
Corner(TempoTotal, 5)
Corner(Repetir, 30)
Corner(Novamente, 30)
Corner(Miniplayer, 30)
Corner(BarraProgresso, 30)
Corner(Rastro, 30)
Corner(BolaProgresso, 30)
Corner(MicroBola, 10)
Corner(PlayerInfo, 5)
Corner(FotoAutor, 50)
Corner(Disco, 50)
Corner(Controles, 5)
Corner(Voltar, 40)
Corner(Retroceder, 40)
Corner(Play, 40)
Corner(Adiantar, 40)
Corner(Pular, 40)
Corner(MiniMusica, 10)
Corner(MiniVideo, 10)
Corner(MiniBack, 2, 0)
Corner(MiniRetroceder, 2, 0)
Corner(MiniPlay, 1, 0)
Corner(MiniAvancar, 1, 0)
Corner(MiniSkip, 1, 0)
Corner(TelaCheia, 1, 0)
Corner(FecharMini, 1, 0)
Corner(TituloEqua, 5)
Corner(EquaFrame, 5)
Corner(NoEquaFrame, 5)
Corner(ErroEqua, 5)
Corner(Volume, 5)
Corner(IconeVolume, 5)
Corner(Pitch, 5)
Corner(IconePitch, 5)
Corner(FrequenciaTitulo, 5)
Corner(Graves, 5)
Corner(IconeGraves, 5)
Corner(Medios, 5)
Corner(IconeMedios, 5)
Corner(Agudos, 5)
Corner(IconeAgudos, 5)
Corner(EfeitosTitulo, 5)
Corner(Nenhum, 5)
Corner(IconeNenhum, 5)
Corner(Reverb, 5)
Corner(IconeReverb, 5)
Corner(Echo, 5)
Corner(IconeEcho, 5)
Corner(Distortion, 5)
Corner(IconeDistortion, 5)
Corner(Chorus, 5)
Corner(IconeChorus, 5)
Corner(Flanger, 5)
Corner(IconeFlanger, 5)
Corner(Tremolo, 5)
Corner(IconeTremolo, 5)
Corner(Compressor, 5)
Corner(IconeCompressor, 5)
Corner(Radio, 5)
Corner(IconeRadio, 5)
Corner(Cinema, 5)
Corner(IconeCinema, 5)
Corner(Underwater, 5)
Corner(IconeUnderwater, 5)
Corner(Kid, 5)
Corner(IconeKid, 5)
Corner(Robot, 5)
Corner(IconeRobot, 5)
Corner(Slowed, 5)
Corner(IconeSlowed, 5)
Corner(ResetarEqua, 5)
Corner(Pesquisa, 5)
Corner(Lupa, 5)
Corner(Filtro, 5)
Corner(DownloadFrame, 5)
Corner(PaginaFrame, 5)
Corner(PaginaEsperandoFrame, 5)
Corner(PaginaEsperandoIcon, 5)
Corner(SemResultadoTexto, 5)
Corner(ErroTexto, 5)
Corner(Tutorial, 30)
Corner(BaixandoTexto, 5)
Corner(DownloadFrameTexto, 5)
Corner(Relevancia, 5)
Corner(DataUpload, 5)
Corner(Duracao, 5)
Corner(IconeRelevancia, 5)
Corner(IconeDataUpload, 5)
Corner(IconeDuracao, 5)
Corner(AplicarFiltro, 5)
Corner(RemoverFiltro, 5)
Corner(Thumbfor, 5)
Corner(Titulofor, 5)
Corner(TituloFiltro, 30)
Corner(TituloFormato, 30)
Corner(BotaoMp3, 5)
Corner(BotaoMp4, 5)
Corner(BotaoCancelar, 5)
Corner(TituloGC, 5)
Corner(GCFrame, 5)
Corner(Traduzir, 5)
Corner(SendGC, 5)
Corner(MsgFrame, 5)
Corner(AvisoGC, 30)
Corner(FinalGC, 32)
Corner(TituloPremium, 5)
Corner(Privilegios, 5)
Corner(Priv1, 35)
Corner(Priv2, 35)
Corner(Priv3, 35)
Corner(Priv4, 35)
Corner(Priv5, 35)
Corner(Priv6, 35)
Corner(IconePriv1, 35)
Corner(IconePriv2, 35)
Corner(IconePriv3, 35)
Corner(IconePriv4, 35)
Corner(IconePriv5, 35)
Corner(IconePriv6, 35)
Corner(frame2, 5)
Corner(PremiumOkTexto, 5)
Corner(KeyFrame, 5)
Corner(SendKey, 5)
Corner(GetKey, 5)
Corner(SetaES, 5)
Corner(SetaDI, 5)
Corner(ReportFrame, 5)
Corner(TituloReportFrame, 30)
Corner(TextoReportFrameFrame, 5)
Corner(Motivo, 5)
Corner(CancelarReport, 7)
Corner(FotoReport, 50)
Corner(Denunciar, 7)
Corner(Warn, 5)
Corner(TituloWarn, 30)
Corner(TextoWarnFrame, 5)
Corner(CloseWarn, 7)
Stroke(frame, 255, 0, 0, 5)
Stroke(imageButton, 255, 255, 255, 3)
Stroke(ContadorJA, 255, 255, 255, 1)
Stroke(ContadorJANU, 255, 255, 255, 0.5)
Stroke(ContadorJABO, 255, 255, 255, 1)
Stroke(ContadorJANUBO, 255, 255, 255, 0.5)
Stroke(Mutar, 255, 255, 255, 1)
Stroke(BotaoFechar, 255, 255, 255, 1)
Stroke(Titulo, 50, 50, 50, 1.5)
Stroke(TextoTitulo, 0, 0, 0, 1.5)
Stroke(Welcome, 50, 50, 50, 1.5)
Stroke(NomeWelcome, 255, 255, 255, 1)
Stroke(Navegacao, 50, 50, 50, 1.5)
Stroke(Playlist, 50, 50, 50, 1.5)
Stroke(TituloNave, 255, 255, 255, 1)
Stroke(FotoNave, 255, 255, 255, 1)
Stroke(NomeNave, 255, 255, 255, 1)
Stroke(TituloPlayL, 255, 255, 255, 1)
Stroke(FotoPlayL, 255, 255, 255, 1)
Stroke(NomePlayL, 255, 255, 255, 1)
Stroke(AbaPL, 255, 255, 255, 1)
Stroke(Botao1, 255, 0, 0, 2)
Stroke(Botao2, 50, 50, 50, 2)
Stroke(Botao3, 50, 50, 50, 2)
Stroke(Botao4, 50, 50, 50, 2)
Stroke(Botao5, 50, 50, 50, 2)
Stroke(Botao6, 50, 50, 50, 2)
Stroke(Icone1, 255, 0, 0, 2)
Stroke(Icone2, 50, 50, 50, 2)
Stroke(Icone3, 50, 50, 50, 2)
Stroke(Icone4, 50, 50, 50, 2)
Stroke(Icone5, 50, 50, 50, 2)
Stroke(Icone6, 50, 50, 50, 2)
Stroke(Nome1, 0, 0, 0, 1.5)
Stroke(Nome2, 0, 0, 0, 1.5)
Stroke(Nome3, 0, 0, 0, 1.5)
Stroke(Nome4, 0, 0, 0, 1.5)
Stroke(Nome6, 0, 0, 0, 1.5)
Stroke(EsquerdaPL, 255, 255, 255, 1)
Stroke(FrameAbaPL, 255, 255, 255, 1)
Stroke(DireitaPL, 255, 255, 255, 1)
Stroke(Dev, 50, 50, 50, 1.5)
Stroke(FotoDev, 178, 34, 34, 1.5)
Stroke(TextoDev, 0, 0, 0, 2)
Stroke(Social, 50, 50, 50, 1.5)
Stroke(SocialTitulo, 50, 50, 50, 1.5)
Stroke(SocialTexto, 0, 0, 0, 2)
Stroke(Discord, 0, 0, 0, 1.5)
Stroke(IconeDiscord, 0, 0, 0, 1.5)
Stroke(TextoDiscord, 0, 0, 0, 1.5)
Stroke(You, 255, 255, 255, 1.5)
Stroke(IconeYou, 255, 255, 255, 1.5)
Stroke(TextoYou, 0, 0, 0, 1.5)
Stroke(Musica, 50, 50, 50, 1.5)
Stroke(Video, 50, 50, 50, 1.5)
Stroke(TempoAtual, 50, 50, 50, 1)
Stroke(TempoTotal, 50, 50, 50, 1)
Stroke(Repetir, 50, 50, 50, 1)
Stroke(Novamente, 50, 50, 50, 1)
Stroke(Miniplayer, 50, 50, 50, 1)
Stroke(BolaProgresso, 255, 255, 255, 1)
Stroke(BarraProgresso, 50, 50, 50, 1.5)
Stroke(PlayerInfo, 50, 50, 50, 1.5)
Stroke(FotoAutor, 178, 34, 34, 1.5)
Stroke(Disco, 178, 34, 34, 1.5)
Stroke(Controles, 178, 34, 34, 1.5)
Stroke(Voltar, 255, 255, 255, 1)
Stroke(Retroceder, 255, 255, 255, 1)
Stroke(Play, 255, 255, 255, 1)
Stroke(Adiantar, 255, 255, 255, 1)
Stroke(Pular, 255, 255, 255, 1)
Stroke(TituloMusica, 0, 0, 0, 1)
Stroke(MiniMusica, 255, 255, 255, 1, 0.5)
Stroke(MiniVideo, 255, 255, 255, 1, 0.5)
Stroke(TituloEqua, 50, 50, 50, 1.5)
Stroke(NomeEqua, 255, 255, 255, 1)
Stroke(EquaFrame, 50, 50, 50, 1.5)
Stroke(NoEquaFrame, 50, 50, 50, 1.5)
Stroke(Volume, 50, 50, 50, 2)
Stroke(IconeVolume, 50, 50, 50, 2)
Stroke(VolumeBox, 0, 0, 0, 1)
Stroke(Pitch, 50, 50, 50, 2)
Stroke(IconePitch, 50, 50, 50, 2)
Stroke(PitchBox, 0, 0, 0, 1)
Stroke(FrequenciaTitulo, 50, 50, 50, 2)
Stroke(TextoFrenquencia, 255, 255, 255, 0.4)
Stroke(Graves, 50, 50, 50, 2)
Stroke(IconeGraves, 50, 50, 50, 2)
Stroke(GravesBox, 0, 0, 0, 1)
Stroke(Medios, 50, 50, 50, 2)
Stroke(IconeMedios, 50, 50, 50, 2)
Stroke(MediosBox, 0, 0, 0, 1)
Stroke(Agudos, 50, 50, 50, 2)
Stroke(IconeAgudos, 50, 50, 50, 2)
Stroke(AgudosBox, 0, 0, 0, 1)
Stroke(EfeitosTitulo, 50, 50, 50, 2)
Stroke(Nenhum, 255, 0, 0, 2)
Stroke(IconeNenhum, 255, 0, 0, 2)
Stroke(NenhumTexto, 0, 0, 0, 1)
Stroke(Reverb, 50, 50, 50, 2)
Stroke(IconeReverb, 50, 50, 50, 2)
Stroke(ReverbTexto, 0, 0, 0, 1)
Stroke(Echo, 50, 50, 50, 2)
Stroke(IconeEcho, 50, 50, 50, 2)
Stroke(EchoTexto, 0, 0, 0, 1)
Stroke(Distortion, 50, 50, 50, 2)
Stroke(IconeDistortion, 50, 50, 50, 2)
Stroke(DistortionTexto, 0, 0, 0, 1)
Stroke(Chorus, 50, 50, 50, 2)
Stroke(IconeChorus, 50, 50, 50, 2)
Stroke(ChorusTexto, 0, 0, 0, 1)
Stroke(Flanger, 50, 50, 50, 2)
Stroke(IconeFlanger, 50, 50, 50, 2)
Stroke(FlangerTexto, 0, 0, 0, 1)
Stroke(Tremolo, 50, 50, 50, 2)
Stroke(IconeTremolo, 50, 50, 50, 2)
Stroke(TremoloTexto, 0, 0, 0, 1)
Stroke(Compressor, 50, 50, 50, 2)
Stroke(IconeCompressor, 50, 50, 50, 2)
Stroke(CompressorTexto, 0, 0, 0, 1)
Stroke(Radio, 50, 50, 50, 2)
Stroke(IconeRadio, 50, 50, 50, 2)
Stroke(RadioTexto, 0, 0, 0, 1)
Stroke(Cinema, 50, 50, 50, 2)
Stroke(IconeCinema, 50, 50, 50, 2)
Stroke(CinemaTexto, 0, 0, 0, 1)
Stroke(Underwater, 50, 50, 50, 2)
Stroke(IconeUnderwater, 50, 50, 50, 2)
Stroke(UnderwaterTexto, 0, 0, 0, 1)
Stroke(Kid, 50, 50, 50, 2)
Stroke(IconeKid, 50, 50, 50, 2)
Stroke(KidTexto, 0, 0, 0, 1)
Stroke(Robot, 50, 50, 50, 2)
Stroke(IconeRobot, 50, 50, 50, 2)
Stroke(RobotTexto, 0, 0, 0, 1)
Stroke(Slowed, 50, 50, 50, 2)
Stroke(IconeSlowed, 50, 50, 50, 2)
Stroke(SlowedTexto, 0, 0, 0, 1)
Stroke(ResetarEqua, 20, 20, 20, 2)
Stroke(ResetarTexto, 255, 255, 255, 1)
Stroke(TextoEfeitos, 255, 255, 255, 0.4)
Stroke(Pesquisa, 50, 50, 50, 1.5)
Stroke(Lupa, 50, 50, 50, 1.5)
Stroke(PesquisarBox, 255, 0, 0, 0.3)
Stroke(Filtro, 50, 50, 50, 2)
Stroke(Tutorial, 50, 50, 50, 1.5)
Stroke(TutoTexto, 255, 255, 255, 0.5)
Stroke(DownloadFrame, 50, 50, 50, 1.5)
Stroke(PaginaFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoFrame, 50, 50, 50, 1.5)
Stroke(PaginaEsperandoIcon, 50, 50, 50, 1.5)
Stroke(Relevancia, 50, 50, 50, 2)
Stroke(DataUpload, 50, 50, 50, 2)
Stroke(Duracao, 50, 50, 50, 2)
Stroke(IconeRelevancia, 50, 50, 50, 2)
Stroke(IconeDataUpload, 50, 50, 50, 2)
Stroke(IconeDuracao, 50, 50, 50, 2)
Stroke(AplicarFiltro, 50, 50, 50, 2)
Stroke(RemoverFiltro, 50, 50, 50, 2)
Stroke(Thumbfor, 50, 50, 50, 1.5)
Stroke(Titulofor, 50, 50, 50, 1.5)
Stroke(BotaoMp3, 50, 50, 50, 1.5)
Stroke(BotaoMp4, 50, 50, 50, 1.5)
Stroke(BotaoCancelar, 50, 50, 50, 1.5)
Stroke(TituloGC, 50, 50, 50, 1.5)
Stroke(NomeGC, 255, 255, 255, 1)
Stroke(GCFrame, 50, 50, 50, 1.5)
Stroke(MsgFrame, 50, 50, 50, 1)
Stroke(Traduzir, 50, 50, 50, 1)
Stroke(SendGC, 50, 50, 50, 1)
Stroke(FinalGC, 255, 255, 255, 1)
Stroke(TituloPremium, 50, 50, 50, 1.5)
Stroke(NomePremium, 0, 0, 200, 1)
Stroke(Privilegios, 50, 50, 50, 1.5)
Stroke(Priv1, 0, 0, 0, 2)
Stroke(Priv2, 0, 0, 0, 2)
Stroke(Priv3, 0, 0, 0, 2)
Stroke(Priv4, 0, 0, 0, 2)
Stroke(Priv5, 0, 0, 0, 2)
Stroke(Priv6, 0, 0, 0, 2)
Stroke(IconePriv1, 0, 0, 0, 2)
Stroke(IconePriv2, 0, 0, 0, 2)
Stroke(IconePriv3, 0, 0, 0, 2)
Stroke(IconePriv4, 0, 0, 0, 1.5)
Stroke(IconePriv5, 0, 0, 0, 2)
Stroke(IconePriv6, 0, 0, 0, 2)
Stroke(TextoPriv1, 0, 0, 0, 1)
Stroke(TextoPriv2, 0, 0, 0, 1)
Stroke(TextoPriv3, 0, 0, 0, 1)
Stroke(TextoPriv4, 0, 0, 0, 1)
Stroke(TextoPriv5, 0, 0, 0, 1)
Stroke(TextoPriv6, 0, 0, 0, 1)
Stroke(frame2, 50, 50, 50, 1.5)
Stroke(KeyFrame, 50, 50, 50, 1.5)
Stroke(SendKey, 50, 50, 50, 1.5)
Stroke(KeyBox, 0, 0, 0, 1.5)
Stroke(GetKey, 0, 0, 0, 1.5)
Stroke(SetaES, 0, 0, 0, 1.5)
Stroke(SetaDI, 0, 0, 0, 1.5)
Stroke(GetKeyTexto, 0, 0, 0, 1.5)
Stroke(ReportFrame, 255, 0, 0, 5)
Stroke(TituloReportFrame, 50, 50, 50, 1.5)
Stroke(TextoTituloReportFrame, 0, 0, 0, 1.5)
Stroke(TextoReportFrameFrame, 50, 50, 50, 1.5)
Stroke(CancelarReport, 0, 0, 0, 1.5)
Corner(Regras, 30)
Corner(NotificarGC, 30)
Stroke(Motivo, 50, 50, 50, 1)
Stroke(FotoReport, 50, 50, 50, 1.5)
Stroke(Denunciar, 0, 0, 0, 1.5)
Stroke(DenunciarTexto, 0, 0, 0, 1.5)
Stroke(CancelarReportTexto, 0, 0, 0, 1.5)
Stroke(Warn, 255, 0, 0, 5)
Stroke(TituloWarn, 50, 50, 50, 1.5)
Stroke(TextoTituloWarn, 0, 0, 0, 1.5)
Stroke(TextoWarnFrame, 50, 50, 50, 1.5)
Stroke(CloseWarn, 0, 0, 0, 1.5)
Stroke(CloseWarnTexto, 0, 0, 0, 1.5)

local ok3, result3 = pcall(function()
	return game:HttpGet(str3 .. "/iskeyless")
end)

if ok3 and result3 and CheckRequest() and string.gsub(result3, "%s+", "") == "{\"keyless\":true}" then
	fn20(true)
	task.wait(3)
end

pcall(function()
	local data2 = HttpService:JSONDecode(readfile("YouTube Music Player/Internal/Data.json"))

	if data2[1] and data2[1].Key and data2[1].Key ~= "" then
		KEY_ATUAL = data2[1].Key
		KeyBox.Text = KEY_ATUAL
		fn29()
	end
end)

Carregar()
task.wait(0.5)
frame.Visible = true

]====]
        local musicLaunching = false
        launchButton.Activated:Connect(function()
            if musicLaunching then return end
            local env = (type(getgenv) == "function" and getgenv()) or _G
            if env.YMP then
                musicStatus.Text = "YouTube Music Player ya está iniciado."
                return
            end
            musicLaunching = true
            launchButton.Text = "♫  INICIANDO..."
            musicStatus.Text = "Cargando YouTube Music Player V8.5..."
            task.spawn(function()
                local ok, err = pcall(function()
                    local compiler = loadstring or (type(getgenv) == "function" and getgenv().loadstring)
                    assert(type(compiler) == "function", "loadstring no está disponible en este executor")
                    local chunk, compileError = compiler(musicSource)
                    assert(type(chunk) == "function", compileError or "No se pudo compilar el reproductor")
                    chunk()
                end)
                if ok then
                    musicStatus.Text = "Reproductor iniciado. Si no aparece, revisa los requisitos del executor."
                else
                    musicStatus.Text = "No se pudo iniciar: " .. tostring(err):sub(1, 180)
                end
                launchButton.Text = "♫  ABRIR YOUTUBE MUSIC"
                musicLaunching = false
            end)
        end)
    end

    -- Preserve all ＳＭＫㅤＨＵＢ controls inside the five Drakon categories.
    -- Custom contains the former Main, Player and Move controls.
    local customPage = pages.Main
    local nextOrder = 0
    for _, child in ipairs(customPage:GetChildren()) do
        if child:IsA("GuiObject") then
            nextOrder = nextOrder + 1
            child.LayoutOrder = nextOrder
        end
    end
    for _, pageName in ipairs({"Player", "Move"}) do
        local sourcePage = pages[pageName]
        for _, child in ipairs(sourcePage:GetChildren()) do
            if child:IsA("GuiObject") then
                child.Parent = customPage
                nextOrder = nextOrder + 1
                child.LayoutOrder = nextOrder
            end
        end
        sourcePage:Destroy()
        pages[pageName] = nil
    end

    local divider = Instance.new("Frame", main)
    divider.Name = "TabsDivider"
    divider.Size = UDim2.new(1, -32, 0, 1)
    divider.Position = UDim2.fromOffset(16, HEADER_H + 4)
    divider.BackgroundColor3 = C_GREY
    divider.BackgroundTransparency = 0.72
    divider.BorderSizePixel = 0
    divider.ZIndex = 4

    local tabScroll = Instance.new("ScrollingFrame", main)
    tabScroll.Name = "TabBar"
    tabScroll.Position = UDim2.fromOffset(8, HEADER_H + 8)
    tabScroll.Size = UDim2.new(1, -16, 0, TAB_H - 4)
    tabScroll.BackgroundTransparency = 1
    tabScroll.BorderSizePixel = 0
    tabScroll.ScrollBarThickness = 2
    tabScroll.ScrollBarImageColor3 = C_GREY
    tabScroll.ScrollBarImageTransparency = 0.45
    tabScroll.Active = true
    tabScroll.ScrollingEnabled = true
    tabScroll.ClipsDescendants = true
    tabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    tabScroll.ElasticBehavior = Enum.ElasticBehavior.Never
    tabScroll.ZIndex = 4
    local tabLayout = Instance.new("UIListLayout", tabScroll)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 6)
    local tabPadding = Instance.new("UIPadding", tabScroll)
    tabPadding.PaddingLeft = UDim.new(0, 4)
    tabPadding.PaddingRight = UDim.new(0, 4)
    tabPadding.PaddingTop = UDim.new(0, 3)
    tabPadding.PaddingBottom = UDim.new(0, 5)

    local activePage = nil
    local activeTabName = nil
    local tabBtns = {}
    local tabDetails = {}
    local function switchTab(name)
        local selectedPage = pages[name]
        if not selectedPage then return end
        if activeTabName == name and activePage == selectedPage then return end
        for _, page in pairs(pages) do page.Visible = false end
        selectedPage.Visible = true
        selectedPage.CanvasPosition = Vector2.new(0, 0)
        activePage = selectedPage
        activeTabName = name
        for tabName, button in pairs(tabBtns) do
            local selected = tabName == name
            TS_G:Create(button, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = selected and C_WHITE or C_CARD,
                TextColor3 = selected and C_DIM or C_GREY,
                BackgroundTransparency = selected and 0.06 or 0.18,
            }):Play()
            local details = tabDetails[tabName]
            if details then
                TS_G:Create(details.stroke, TweenInfo.new(0.18), {
                    Color = selected and C_WHITE or C_BORDER,
                    Transparency = selected and 0.12 or 0.45,
                }):Play()
                TS_G:Create(details.indicator, TweenInfo.new(0.18), {
                    BackgroundColor3 = C_DIM,
                    BackgroundTransparency = selected and 0.12 or 1,
                }):Play()
            end
        end
    end

    local tabs = {
        {key = "Speed", label = "Speed", width = 72},
        {key = "Main", label = "Custom", width = 78},
        {key = "Visual", label = "Visual", width = 72},
        {key = "Config", label = "Settings", width = 82},
        {key = "Keybinds", label = "Keybinds", width = 86},
        {key = "Music", label = "Música", width = 76},
    }
    for index, tab in ipairs(tabs) do
        local tabKey = tab.key
        local button = Instance.new("TextButton", tabScroll)
        button.Name = "Tab" .. tab.label
        button.Size = UDim2.fromOffset(tab.width, 30)
        button.LayoutOrder = index
        button.BackgroundColor3 = C_CARD
        button.BackgroundTransparency = 0.18
        button.BorderSizePixel = 0
        button.Text = tab.label
        button.TextColor3 = C_WHITE
        button.Font = Enum.Font.GothamBold
        button.TextSize = 12
        button.AutoButtonColor = false
        button.Active = true
        button.Selectable = true
        button.ZIndex = 5
        -- Full capsule rounding, softer than Drakon's 12px corners.
        Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", button)
        stroke.Color = C_BORDER
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Transparency = 0.45
        -- Keep the original capsule shape and dimensions; refine only its finish.
        local indicator = Instance.new("Frame", button)
        indicator.Name = "SelectedIndicator"
        indicator.AnchorPoint = Vector2.new(0.5, 1)
        indicator.Position = UDim2.new(0.5, 0, 1, -3)
        indicator.Size = UDim2.fromOffset(16, 2)
        indicator.BackgroundColor3 = C_DIM
        indicator.BackgroundTransparency = 1
        indicator.BorderSizePixel = 0
        indicator.ZIndex = 6
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
        tabDetails[tabKey] = {stroke = stroke, indicator = indicator}
        tabBtns[tabKey] = button
        button.MouseEnter:Connect(function()
            if activeTabName == tabKey then return end
            TS_G:Create(button, TweenInfo.new(0.14), {
                BackgroundColor3 = C_CARD_HOV, TextColor3 = C_WHITE,
                BackgroundTransparency = 0.06,
            }):Play()
            TS_G:Create(stroke, TweenInfo.new(0.14), {Color = C_HIGHLIGHT, Transparency = 0.2}):Play()
        end)
        button.MouseLeave:Connect(function()
            if activeTabName == tabKey then return end
            TS_G:Create(button, TweenInfo.new(0.18), {
                BackgroundColor3 = C_CARD, TextColor3 = C_GREY,
                BackgroundTransparency = 0.18,
            }):Play()
            TS_G:Create(stroke, TweenInfo.new(0.18), {Color = C_BORDER, Transparency = 0.45}):Play()
        end)
        button.Activated:Connect(function() switchTab(tabKey) end)
    end
    switchTab("Speed")

    -- SMK Leaked animation: scale in with a short Back easing and scale out
    -- with a compact Quart easing. No horizontal slide is used.
    local menuScale = S.mainGuiScaleObj
    local menuBaseScale = S.IS_TOUCH_DEVICE and S.phoneGuiScale or 1
    local menuClosedScale = menuBaseScale * 0.82
    S.menuTransitionToken = (S.menuTransitionToken or 0) + 1
    outer.Position = S.menuOpenPosition
    if menuScale then menuScale.Scale = menuClosedScale end
    outer.Visible = true
    S.menuTween = TS_G:Create(menuScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Scale = menuBaseScale
    })
    S.menuTween:Play()

    local function showGui()
        S.menuTransitionToken = (S.menuTransitionToken or 0) + 1
        if S.menuTween then pcall(function() S.menuTween:Cancel() end) end
        outer.Visible = true
        if S.miniToggleButton then S.miniToggleButton.Visible = false end
        outer.Position = S.menuOpenPosition
        if menuScale then menuScale.Scale = menuClosedScale end
        S.menuTween = TS_G:Create(menuScale, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = menuBaseScale
        })
        S.menuTween:Play()
    end
    local function hideGui()
        -- Capture the current location before the scale-out animation.
        S.menuOpenPosition = outer.Position
        saveConfig()
        S.menuTransitionToken = (S.menuTransitionToken or 0) + 1
        local transitionToken = S.menuTransitionToken
        if S.menuTween then pcall(function() S.menuTween:Cancel() end) end
        S.menuTween = TS_G:Create(menuScale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Scale = menuClosedScale
        })
        S.menuTween.Completed:Connect(function(playbackState)
            if transitionToken ~= S.menuTransitionToken or playbackState ~= Enum.PlaybackState.Completed then return end
            outer.Visible = false
            if menuScale then menuScale.Scale = menuBaseScale end
            if S.miniToggleButton then S.miniToggleButton.Visible = true end
        end)
        S.menuTween:Play()
    end
    closeBtn.MouseButton1Click:Connect(hideGui)
    S.miniToggleButton = buildGui_createMiniToggle(gui, showGui)
    S.miniToggleButton.Visible = false

    UIS.InputBegan:Connect(function(input, gpe)
        if input.UserInputType~=Enum.UserInputType.Keyboard and input.UserInputType~=Enum.UserInputType.Gamepad1 then return end
        if SMKBindings.suppressed() then return end
        local kc=input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end
        local field = input.UserInputType == Enum.UserInputType.Gamepad1 and "gp" or "kb"
        local function match(e) return e[field] ~= nil and kc == e[field] end
        if gpe then
            if match(S.KB.GuiHide) then if outer.Visible then hideGui() else showGui() end end
            return
        end
        if match(S.KB.DropBrainrot) then task.spawn(runDropBrainrot)
        elseif match(S.KB.TPFlor) then runTPFloor()
        elseif match(S.KB.AutoLeft) then
            S.autoLeftEnabled=not S.autoLeftEnabled
            if S.autoLeftEnabled then
                if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
                if S.batAimbotEnabled then setBatAimbot(false) end
                startAutoLeft()
            else stopAutoLeft() end
            if S.autoLeftSetVisual then S.autoLeftSetVisual(S.autoLeftEnabled) end
            S.restartMovement(); updateFloatingButtons(); saveConfig()
        elseif match(S.KB.AutoRight) then
            S.autoRightEnabled=not S.autoRightEnabled
            if S.autoRightEnabled then
                if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
                if S.batAimbotEnabled then setBatAimbot(false) end
                startAutoRight()
            else stopAutoRight() end
            if S.autoRightSetVisual then S.autoRightSetVisual(S.autoRightEnabled) end
            S.restartMovement(); updateFloatingButtons(); saveConfig()
        elseif match(S.KB.BatBypass) then S.toggleBatBypass(); saveConfig()
        elseif match(S.KB.AutoBat) then setBatAimbot(not S.batAimbotEnabled)
        elseif match(S.KB.GuiHide) then if outer.Visible then hideGui() else showGui() end
        elseif match(S.KB.SpeedToggle) then S.toggleCarryMode(); S.restartMovement(); updateFloatingButtons(); saveConfig()
        elseif match(S.KB.LaggerToggle) then S.toggleLaggerMode(); S.restartMovement(); updateFloatingButtons(); saveConfig()
        end
    end)
end


-- ===========================
-- FLOATING BUTTON PANEL (white / grey theme)
-- ===========================
local function createFloatingButtonPanel()
    local panelGui = Instance.new("ScreenGui")
    panelGui.Name = "FloatingModeMenu"
    panelGui.DisplayOrder = 50
    panelGui.IgnoreGuiInset = true
    panelGui.ResetOnSpawn = false
    panelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panelGui.Parent = LP:WaitForChild("PlayerGui")
    S.floatingPanelGui = panelGui

    local layoutFrame = Instance.new("Frame")
    layoutFrame.Name = "ButtonLayout"
    layoutFrame.AnchorPoint = Vector2.new(1, 0)
    layoutFrame.Position = UDim2.new(0.79, 0, 0, 0)
    layoutFrame.Size = UDim2.fromOffset(0, 0)
    layoutFrame.BackgroundTransparency = 1
    layoutFrame.BorderSizePixel = 0
    layoutFrame.ClipsDescendants = false
    layoutFrame.Active = false
    layoutFrame.Selectable = false
    layoutFrame.Parent = panelGui
    S.floatingPanelFrame = layoutFrame
    -- El panel principal mueve juntos sus botones; TP BAT y RESET van en una
    -- capa independiente para poder moverlos por separado.
    -- Solo esta franja superior captura el arrastre; el resto queda libre.
    local dragHandle = Instance.new("Frame")
    dragHandle.Name = "FloatingPanelDragHandle"
    dragHandle.Size = UDim2.fromOffset(0, 48)
    dragHandle.Position = UDim2.fromOffset(0, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.BorderSizePixel = 0
    dragHandle.Active = true
    dragHandle.Parent = layoutFrame
    makeDraggable(dragHandle, true, layoutFrame)

    local freeButtonLayer = Instance.new("Frame")
    freeButtonLayer.Name = "IndependentButtonLayer"
    freeButtonLayer.AnchorPoint = Vector2.new(1, 0)
    freeButtonLayer.Position = UDim2.new(0.79, 0, 0, 0)
    freeButtonLayer.Size = UDim2.fromOffset(0, 0)
    freeButtonLayer.BackgroundTransparency = 1
    freeButtonLayer.BorderSizePixel = 0
    freeButtonLayer.ClipsDescendants = false
    freeButtonLayer.Active = false
    freeButtonLayer.Selectable = false
    freeButtonLayer.Parent = panelGui

    local selectedName = "CARRY SPD"
    local buttons = {}
    local BLACK = SMKThemeRGB(1, 1, 4)
    local WHITE = SMKThemeRGB(255, 255, 255)

    local buttonDefinitions = {
        {name = "DROP BR",       displayText = "DROP\nBR",       column = 2, row = 0},
        {name = "AUTO LEFT",     displayText = "AUTO\nLEFT",     column = 3, row = 0},
        {name = "BAT AIMBOT",    displayText = "BAT\nAIMBOT",   column = 2, row = 1},
        {name = "AUTO RIGHT",    displayText = "AUTO\nRIGHT",    column = 3, row = 1},
        {name = "TP DOWN",       displayText = "TP\nDOWN",       column = 2, row = 2},
        {name = "CARRY SPD",     displayText = "CARRY\nSPD",     column = 3, row = 2},
        {name = "NORMAL LAGGER", displayText = "NORMAL\nLAGGER", column = 2, row = 3},
        {name = "LAGGER CARRY SPEED", displayText = "LAGGER\nCARRY\nSPEED", column = 3, row = 3},
    }

    S.refreshMobileTheme = function()
        BLACK = SMKThemeRGB(1, 1, 4)
        WHITE = SMKThemeRGB(255, 255, 255)
    end
    local function applyButtonStyle(info, isSelected)
        if isSelected then
            info.button.BackgroundColor3 = WHITE
            info.button.TextColor3 = SMKThemeRGB(18, 31, 28)
            info.gradient.Enabled = true
        else
            info.button.BackgroundColor3 = BLACK
            info.button.TextColor3 = WHITE
            info.gradient.Enabled = false
        end
    end

    local pressTweenInfo = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local releaseTweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    for _, definition in ipairs(buttonDefinitions) do
        local button = Instance.new("TextButton")
        button.Name = string.gsub(definition.name, "%s+", "")
        button.BackgroundColor3 = BLACK
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        button.Text = definition.displayText or definition.name
        button.TextColor3 = WHITE
        button.TextScaled = true
        button.TextWrapped = true
        button.Font = Enum.Font.GothamBold
        button.ZIndex = 2
        button.Parent = layoutFrame

        local buttonScale = Instance.new("UIScale")
        buttonScale.Parent = button
        local activeScaleTween
        local function animateScale(target, info)
            if activeScaleTween then activeScaleTween:Cancel() end
            activeScaleTween = TS_G:Create(buttonScale, info, {Scale = target})
            activeScaleTween:Play()
        end
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                animateScale(0.92, pressTweenInfo)
            end
        end)
        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                animateScale(1, releaseTweenInfo)
            end
        end)

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.24, 0)
        corner.Parent = button
        local textLimit = Instance.new("UITextSizeConstraint")
        textLimit.MinTextSize = 10
        textLimit.MaxTextSize = 15
        textLimit.Parent = button
        local gradient = Instance.new("UIGradient")
        gradient.Name = "SelectedGradient"
        gradient.Enabled = false
        gradient.Rotation = 90
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, SMKThemeRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.56, SMKThemeRGB(224, 226, 225)),
            ColorSequenceKeypoint.new(1, SMKThemeRGB(76, 80, 80)),
        })
        gradient.Parent = button

        local isFreeButton = definition.name == "TP BAT" or definition.name == "Reset"
        local info = {button = button, gradient = gradient, name = definition.name, column = definition.column, row = definition.row, independent = isFreeButton, userMoved = false}
        table.insert(buttons, info)
        if isFreeButton then
            button.Parent = freeButtonLayer
            local saved = S.floatingFreeButtonPositions[definition.name]
            if type(saved) == "table" and type(saved.X) == "number" and type(saved.Y) == "number" then
                button.Position = UDim2.fromOffset(saved.X, saved.Y)
                info.userMoved = true
            end
            makeDraggable(button, true, button, function(target)
                info.userMoved = true
                S.floatingFreeButtonPositions[definition.name] = {X = target.Position.X.Offset, Y = target.Position.Y.Offset}
            end)
        end

        button.Activated:Connect(function()
            if info.name == "TP DOWN" then return end
            -- Los botones de velocidad controlan su propia luz después de cambiar
            -- el modo. No aplicar aquí el estilo genérico, porque este evento
            -- puede ejecutarse después del handler de acción y volver a encender
            -- Carry/Lagger al apagarlos con el segundo toque.
            local isModeButton = info.name == "CARRY SPD"
                or info.name == "NORMAL LAGGER"
                or info.name == "LAGGER CARRY SPEED"
                or info.name == "BAT AIMBOT"
                or info.name == "TP BAT"
            if isModeButton then return end
            selectedName = info.name
            for _, item in ipairs(buttons) do applyButtonStyle(item, item.name == selectedName) end
        end)
    end

    local function find(name)
        for _, info in ipairs(buttons) do
            if info.name == name then return info end
        end
    end
    local function flash(info, duration)
        if not info then return end
        applyButtonStyle(info, true)
        task.delay(duration or 0.35, function()
            if info.button and info.button.Parent then applyButtonStyle(info, false) end
        end)
    end
    local function canPress()
        -- Lock solo congela las posiciones; no bloquea las acciones.
        return not S._floatingPanelDragging
    end

    local drop = find("DROP BR")
    local autoLeft = find("AUTO LEFT")
    local bat = find("BAT AIMBOT")
    local autoRight = find("AUTO RIGHT")
    local tpDown = find("TP DOWN")
    local carry = find("CARRY SPD")
    local normalLagger = find("NORMAL LAGGER")
    local carryLagger = find("LAGGER CARRY SPEED")

    local function connectAction(info, action)
        info.button.Activated:Connect(function()
            if canPress() then action() end
        end)
    end
    connectAction(drop, function() flash(drop, 0.5); task.spawn(runDropBrainrot) end)
    connectAction(bat, function()
        local on = not S.batAimbotEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled = false; stopAutoLeft(); if S.autoLeftSetVisual then S.autoLeftSetVisual(false) end end
            if S.autoRightEnabled then S.autoRightEnabled = false; stopAutoRight(); if S.autoRightSetVisual then S.autoRightSetVisual(false) end end
        end
        setBatAimbot(on)
        -- BAT AIMBOT controla su propia luz: primer toque ON, segundo toque OFF.
        applyButtonStyle(bat, on)
        updateFloatingButtons()
    end)
    connectAction(autoLeft, function()
        local on = not S.autoLeftEnabled
        if on then
            if S.autoRightEnabled then S.autoRightEnabled = false; stopAutoRight() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoLeftEnabled = true; startAutoLeft()
        else S.autoLeftEnabled = false; stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    connectAction(autoRight, function()
        local on = not S.autoRightEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled = false; stopAutoLeft() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoRightEnabled = true; startAutoRight()
        else S.autoRightEnabled = false; stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    connectAction(tpDown, function()
        applyButtonStyle(tpDown, true)
        runTPFloor()
        task.delay(0.45, function()
            if tpDown and tpDown.button and tpDown.button.Parent then applyButtonStyle(tpDown, false) end
        end)
    end)
    local function refreshLaggerButtons()
        applyButtonStyle(normalLagger, S.laggerMode == 1 and not S.speedMode)
        applyButtonStyle(carryLagger, S.laggerMode == 2 and not S.speedMode)
    end

    -- Deja los tres botones de velocidad apagados y vuelve siempre a S.NS.
    -- Esto se usa al dar el segundo toque al botón que ya está activo.
    local function returnToNormalSpeed()
        S.setNormalSpeedMode()
        S.restartMovement()
        updateFloatingButtons()
        applyButtonStyle(carry, false)
        applyButtonStyle(normalLagger, false)
        applyButtonStyle(carryLagger, false)
        saveConfig()
    end

    connectAction(carry, function()
        -- Segundo toque en Carry: apagar Carry y volver a Normal Speed.
        if S.speedMode and S.laggerMode == 0 then
            returnToNormalSpeed()
            return
        end

        -- Primer toque (o cambio desde un modo Lagger): activar Carry.
        S.setCarrySpeedMode()
        S.restartMovement()
        updateFloatingButtons()
        refreshLaggerButtons()
        applyButtonStyle(normalLagger, false)
        applyButtonStyle(carryLagger, false)
        saveConfig()
    end)

    local function setLaggerSpeedMode(mode)
        -- Segundo toque en el mismo botón Lagger: apagarlo y volver a Normal.
        if S.laggerMode == mode and not S.speedMode then
            returnToNormalSpeed()
            return
        end

        -- Primer toque, o cambio entre Normal Lagger y Carry Lagger.
        S.speedMode = false
        S.laggerMode = mode
        S.refreshSpeedModeLabel()
        S.applySpeedVelocityNow()
        S.restartMovement()
        updateFloatingButtons()
        refreshLaggerButtons()
        saveConfig()
    end

    connectAction(normalLagger, function() setLaggerSpeedMode(1) end) -- S.LS: Lagger Normal Speed
    connectAction(carryLagger, function() setLaggerSpeedMode(2) end) -- S.LCS: Lagger Carry Speed

    S.dropBrainrotSetVisual = function(active) applyButtonStyle(drop, active) end
    S.dropBrainrotFloatVisual = S.dropBrainrotSetVisual
    -- Reset remains highlighted only while its action is running; respawn clears it.
    LP.CharacterAdded:Connect(function()
        task.defer(function()
            if reset and reset.button and reset.button.Parent then applyButtonStyle(reset, false) end
            if drop and drop.button and drop.button.Parent then applyButtonStyle(drop, false) end
        end)
    end)
    S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL = autoLeft.button, nil, nil, nil
    S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR = autoRight.button, nil, nil, nil
    S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT = bat.button, nil, nil, nil
    S._setPButtonActive = function(button, _, _, _, active)
        for _, info in ipairs(buttons) do
            if info.button == button then
                applyButtonStyle(info, active)
                return
            end
        end
    end
    S._floatingButtons = {
        lagger = normalLagger.button,
        l2Lagger = {Text = ""},
        carry = carry.button,
        autoLeft = autoLeft.button,
        autoRight = autoRight.button,
        bat = bat.button,
    }

    local function updateLayout()
        local camera = workspace.CurrentCamera
        if not camera then return end
        local viewport = camera.ViewportSize
        local isLandscape = viewport.X > viewport.Y
        local sizeFactor = isLandscape and 0.16 or 0.18
        local buttonSize = math.floor(math.min(viewport.Y * sizeFactor, viewport.X * 0.24))
        local gap = math.max(8, math.floor(buttonSize * 0.14))
        local pitch = buttonSize + gap
        -- No reposicionar aquí: el usuario puede haber guardado o movido el panel.
        local firstRowY = math.floor(viewport.Y * (isLandscape and 0.18 or 0.205))
        -- Las capas solo cubren el rectángulo de los botones; no toda la pantalla.
        local groupHeight = firstRowY + buttonSize * 4 + gap * 3 + gap
        local groupWidth = buttonSize * 4 + gap * 3
        layoutFrame.Size = UDim2.fromOffset(groupWidth, groupHeight)
        freeButtonLayer.Size = UDim2.fromOffset(groupWidth, groupHeight)
        dragHandle.Size = UDim2.fromOffset(groupWidth, math.max(48, firstRowY))
        for _, info in ipairs(buttons) do
            info.button.Size = UDim2.fromOffset(buttonSize, buttonSize)
            if not info.independent or not info.userMoved then
                info.button.Position = UDim2.fromOffset(info.column * pitch, firstRowY + info.row * pitch)
            end
        end
    end
    local cameraConnection
    local function bindCamera()
        if cameraConnection then cameraConnection:Disconnect() end
        local camera = workspace.CurrentCamera
        if camera then
            cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateLayout)
            updateLayout()
        end
    end
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
    bindCamera()
    S._floatingButtonInfos = buttons
    S._floatingFreeButtonLayer = freeButtonLayer
    S._floatingUpdateLayout = updateLayout
    if S._savedFloatingPanelPos then
        local pos = S._savedFloatingPanelPos
        layoutFrame.Position = UDim2.new(pos.XS or 0.79, pos.X or 0, pos.YS or 0, pos.Y or 0)
    end
    for _, info in ipairs(buttons) do applyButtonStyle(info, false) end
    applyButtonStyle(carry, S.speedMode and S.laggerMode == 0)
    applyButtonStyle(normalLagger, S.laggerMode == 1 and not S.speedMode)
    applyButtonStyle(carryLagger, S.laggerMode == 2 and not S.speedMode)
    applyButtonStyle(autoLeft, S.autoLeftEnabled)
    applyButtonStyle(autoRight, S.autoRightEnabled)
    applyButtonStyle(bat, S.batAimbotEnabled)
    applyButtonStyle(tpBat, S.tpBatEnabled)
end

-- Insta Reset do S2: HipHeight 1e30, até 40 tentativas / 0.05s,
-- depois Health=0. Mantém a câmera apenas durante a ação.
do
    local resetThread, cameraConnection
    local busy = false
    local generation = 0
    local savedCharacter, savedHumanoid, savedHipHeight, savedAutoRotate
    local collisions = {}
    local function release()
        if cameraConnection then cameraConnection:Disconnect(); cameraConnection = nil end
        if savedCharacter and savedCharacter.Parent and savedHumanoid then
            pcall(function()
                savedHumanoid.HipHeight = savedHipHeight
                savedHumanoid.AutoRotate = savedAutoRotate
            end)
            for part, value in pairs(collisions) do
                if part.Parent then pcall(function() part.CanCollide = value end) end
            end
        end
        savedCharacter, savedHumanoid = nil, nil
        collisions = {}
        busy = false
    end
    S.stopInstaReset = function()
        generation += 1
        if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
        release()
    end
    S.instaReset = function()
        if busy then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then return end
        busy = true
        generation += 1
        local token = generation
        savedCharacter, savedHumanoid = char, hum
        savedHipHeight, savedAutoRotate = hum.HipHeight, hum.AutoRotate
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then collisions[part] = part.CanCollide end
        end
        if S.setBatBypass and S.batBypassEnabled then S.setBatBypass(false) end
        local cam = workspace.CurrentCamera
        local locked = cam and cam.CFrame
        if locked then
            cameraConnection = RunService.Heartbeat:Connect(function()
                local current = workspace.CurrentCamera
                if current and busy and generation == token then current.CFrame = locked end
            end)
        end
        resetThread = task.defer(function()
            for attempt = 1, 40 do
                if generation ~= token or LP.Character ~= char or not char.Parent or hum.Health <= 0 then break end
                pcall(function()
                    hum.HipHeight = 1e30
                    hum.AutoRotate = true
                    for part in pairs(collisions) do if part.Parent then part.CanCollide = false end end
                end)
                task.wait(0.05)
            end
            if generation == token and LP.Character == char and char.Parent and hum.Health > 0 then
                pcall(function() hum.Health = 0 end)
                task.wait(0.1)
            end
            if generation == token then resetThread = nil; release() end
        end)
    end
    LP.CharacterRemoving:Connect(S.stopInstaReset)
end

-- ===========================
-- FLOATING BUTTON PANEL (ＳＭＫㅤＨＵＢ layout, fully wired)
-- ===========================
createFloatingButtonPanel = function()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FloatingModeMenu"
    gui.DisplayOrder = 50
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LP:WaitForChild("PlayerGui")
    S.floatingPanelGui = gui

    local container = Instance.new("Frame")
    container.Name = "FloatingButtons"
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = UDim2.new(1, -58, 0, 95)
    container.Size = UDim2.fromOffset(132, 230)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = gui
    S.floatingPanelFrame = container
    container.Active = false
    local savedPanel = S._savedFloatingPanelPos
    if type(savedPanel) == "table" then
        local function finite(n)
            return type(n) == "number" and n == n and n > -math.huge and n < math.huge
        end
        if finite(savedPanel.XS) and finite(savedPanel.X) and finite(savedPanel.YS) and finite(savedPanel.Y) then
            container.Position = UDim2.new(savedPanel.XS, savedPanel.X, savedPanel.YS, savedPanel.Y)
        end
    end

    local DARK = Color3.fromRGB(0, 0, 0)
    local TEXT = Color3.fromRGB(255, 255, 255)
    local STROKE = Color3.fromRGB(35, 35, 35)
    local ACTIVE_BASE = Color3.fromRGB(255, 255, 255)
    local ACTIVE_TOP = Color3.fromRGB(255, 255, 255)
    local ACTIVE_MIDDLE = Color3.fromRGB(255, 255, 255)
    local ACTIVE_BOTTOM = Color3.fromRGB(255, 255, 255)
    local ACTIVE_STROKE = Color3.fromRGB(255, 255, 255)
    local byId, infos = {}, {}
    local positions = {
        {"Drop", "DROP\nBRAINROT", 0, 0}, {"AutoLeft", "AUTO\nLEFT", 72, 0},
        {"BatBypass", "BAT\nBYPASS", -72, 60},
        {"InstaReset", "INSTA\nRESET", -72, 120},
        {"AutoBat", "BAT\nAIMBOT", 0, 60},
        {"AutoRight", "AUTO\nRIGHT", 72, 60},
        {"TPDown", "TP\nDOWN", 0, 120}, {"CarrySpd", "CARRY\nSPD", 72, 120},
        {"LaggerCarry", "LAGGER\nCARRY\nSPEED", 0, 180}, {"LaggerNormal", "NORMAL\nLAGGER", 72, 180},
    }
    local function style(i, active)
        if not i or not i.button or not i.button.Parent then return end
        i.active = active == true
        i.button.BackgroundColor3 = i.active and ACTIVE_BASE or DARK
        i.gradient.Enabled = false
        i.gradient.Color = ColorSequence.new(i.active and ACTIVE_BASE or DARK)
        i.stroke.Color = i.active and ACTIVE_STROKE or STROKE
        i.stroke.Transparency = i.active and 0 or 0.15
        i.stroke.Thickness = i.active and 2 or 1
        i.hit.TextColor3 = i.active and Color3.fromRGB(0, 0, 0) or TEXT
    end
    S.refreshMobileTheme = function()
        DARK = Color3.fromRGB(0, 0, 0)
        TEXT = Color3.fromRGB(255, 255, 255)
        STROKE = Color3.fromRGB(35, 35, 35)
        ACTIVE_BASE = Color3.fromRGB(255, 255, 255)
        ACTIVE_TOP = Color3.fromRGB(255, 255, 255)
        ACTIVE_MIDDLE = Color3.fromRGB(255, 255, 255)
        ACTIVE_BOTTOM = Color3.fromRGB(255, 255, 255)
        ACTIVE_STROKE = Color3.fromRGB(255, 255, 255)
        for _, info in ipairs(infos) do style(info, info.active) end
    end
    S.refreshMobileButtonShape = function()
        local round = S.mobileButtonStyle == "round"
        for _, info in ipairs(infos) do
            -- Preserve grid centres and positions; only the visual changes shape.
            info.button.Size = round and UDim2.fromOffset(50, 50) or UDim2.fromScale(1, 1)
            info.corner.CornerRadius = round and UDim.new(0.5, 0) or UDim.new(0, 14)
        end
    end
    local function flash(i, duration)
        style(i, true)
        task.delay(duration or 0.45, function()
            if i and i.button and i.button.Parent then style(i, false) end
        end)
    end
    for _, p in ipairs(positions) do
        local button = Instance.new("Frame")
        button.Name = "VisualButton_" .. p[1]
        button.Position = UDim2.fromOffset(p[3], p[4])
        button.Size = UDim2.fromOffset(60, 50)
        button.BackgroundColor3 = DARK
        button.BorderSizePixel = 0
        button.ZIndex = 11
        button.Parent = container
        -- The touch target stays fixed; only this separate visual child animates.
        button.BackgroundTransparency = 1
        button.Active = false
        local visual = Instance.new("Frame")
        visual.Name = "AnimatedVisual"
        visual.AnchorPoint = Vector2.new(0.5, 0.5)
        visual.Position = UDim2.fromScale(0.5, 0.5)
        visual.Size = UDim2.fromScale(1, 1)
        visual.BackgroundColor3 = DARK
        visual.BorderSizePixel = 0
        visual.Active = false
        visual.ZIndex = 11
        visual.Parent = button
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 14)
        corner.Parent = visual
        local stroke = Instance.new("UIStroke")
        stroke.Name = "Border"
        stroke.Color = STROKE
        stroke.Transparency = 0.25
        stroke.Thickness = 1
        stroke.Parent = visual
        local gradient = Instance.new("UIGradient")
        gradient.Name = "SelectedGradient"
        gradient.Rotation = 90
        gradient.Parent = visual
        local hit = Instance.new("TextButton")
        hit.Name = "TextAndTouch"
        hit.Size = UDim2.fromScale(1, 1)
        hit.BackgroundTransparency = 1
        hit.BorderSizePixel = 0
        hit.AutoButtonColor = false
        hit.Active = true
        hit.Selectable = true
        hit.Text = p[2]
        hit.TextColor3 = TEXT
        hit.TextSize = 7
        hit.Font = Enum.Font.GothamBlack
        hit.TextWrapped = true
        hit.ZIndex = 13
        hit.Parent = button
        local buttonScale = Instance.new("UIScale")
        buttonScale.Name = "PressAnimationScale"
        buttonScale.Scale = 1
        buttonScale.Parent = visual
        local i = {id=p[1], button=visual, host=button, hit=hit, stroke=stroke, gradient=gradient, corner=corner,
            userMoved=false, defaultPosition=UDim2.fromOffset(p[3], p[4]), suppressUntil=0}
        local saved = S.mobileButtonPositions[p[1]]
        if type(saved) == "table" and type(saved.X) == "number" and type(saved.Y) == "number"
            and saved.X == saved.X and saved.Y == saved.Y
            and math.abs(saved.X) < 100000 and math.abs(saved.Y) < 100000 then
            button.Position = UDim2.fromOffset(saved.X, saved.Y)
            i.userMoved = true
        end
        local activeScaleTween
        local trackedInput, dragStart, startPosition, dragScale
        local editingGesture = false
        local function animateScale(target, duration)
            if activeScaleTween then activeScaleTween:Cancel() end
            activeScaleTween = TS_G:Create(buttonScale,
                TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale=target})
            activeScaleTween:Play()
        end
        hit.InputBegan:Connect(function(input)
            if trackedInput then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            trackedInput = input
            i.dragMoved = false
            editingGesture = S.editMobileButtons == true and not S.lockUIEnabled
            if editingGesture then
                dragStart = input.Position
                startPosition = button.Position
                dragScale = math.max(0.01, button.AbsoluteSize.X / button.Size.X.Offset)
                buttonScale.Scale = 1
            else
                animateScale(0.92, 0.07)
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if not trackedInput or not editingGesture or not S.editMobileButtons or S.lockUIEnabled then return end
            if trackedInput.UserInputType == Enum.UserInputType.Touch then
                if input ~= trackedInput then return end
            elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - dragStart
            if delta.Magnitude < 6 and not i.dragMoved then return end
            i.dragMoved = true
            local camera = workspace.CurrentCamera
            local viewport = camera and camera.ViewportSize
            local dx, dy = delta.X, delta.Y
            if viewport then
                local origin = container.AbsolutePosition + Vector2.new(startPosition.X.Offset, startPosition.Y.Offset) * dragScale
                dx = math.clamp(dx, -origin.X, math.max(-origin.X, viewport.X - origin.X - button.AbsoluteSize.X))
                dy = math.clamp(dy, -origin.Y, math.max(-origin.Y, viewport.Y - origin.Y - button.AbsoluteSize.Y))
            end
            button.Position = UDim2.fromOffset(startPosition.X.Offset + dx / dragScale, startPosition.Y.Offset + dy / dragScale)
            i.userMoved = true
            S.mobileButtonPositions[i.id] = {X=button.Position.X.Offset, Y=button.Position.Y.Offset}
            -- Moving a button must not resize or reposition the shared backdrop.
        end)
        UIS.InputEnded:Connect(function(input)
            if input ~= trackedInput then return end
            trackedInput = nil
            if editingGesture then
                i.suppressUntil = os.clock() + 0.2
                if i.dragMoved then saveConfig() end
                i.dragMoved = false
            end
            animateScale(1, 0.12)
        end)
        hit.Destroying:Connect(function()
            if activeScaleTween then activeScaleTween:Cancel() end
            trackedInput = nil
        end)
        byId[p[1]], infos[#infos+1] = i, i
        style(i, false)
    end
    S.refreshMobileButtonShape()
    local dragHandle = Instance.new("Frame")
    dragHandle.Name = "FloatingPanelDragHandle"
    dragHandle.Size = UDim2.fromOffset(132, 50)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Active = true
    dragHandle.ZIndex = 1
    dragHandle.Parent = container
    dragHandle.Active = false -- Reposition individual buttons only in edit mode.

    S._floatingButtonInfos = infos
    S._floatingFreeButtonLayer = container
    S._floatingUpdateLayout = function()
        container.Position = UDim2.new(1, -58, 0, 95)
        for _, info in ipairs(infos) do
            info.host.Position = info.defaultPosition
            info.userMoved = false
        end
    end
    S.refreshMobileEditMode = function()
        dragHandle.Active = false
        container.Active = false
        for _, info in ipairs(infos) do
            info.host.ZIndex = S.editMobileButtons and 20 or 11
            info.button.ZIndex = 11
            info.hit.ZIndex = 13
            info.hit.Active = true
            info.hit.Selectable = not S.editMobileButtons
        end
    end
    S.refreshMobileEditMode()
    local function get(id) return byId[id] end
    local function connect(id, fn)
        local info = get(id)
        info.hit.Activated:Connect(function()
            if S.editMobileButtons or os.clock() < info.suppressUntil then return end
            fn()
        end)
    end
    connect("Drop", function() flash(get("Drop"), 0.5); task.spawn(runDropBrainrot) end)
    connect("TPDown", function() flash(get("TPDown"), 0.45); runTPFloor() end)
    connect("BatBypass", function() S.toggleBatBypass() end)
    connect("InstaReset", function() flash(get("InstaReset"), 0.45); S.instaReset() end)
    S.setBatBypassVisual = function(active) style(get("BatBypass"), active) end
    gui.Destroying:Connect(function()
        if S.setBatBypass then S.setBatBypass(false) end
        if S.stopInstaReset then S.stopInstaReset() end
    end)
    connect("AutoBat", function()
        local on = not S.batAimbotEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft() end
            if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight() end
        end
        setBatAimbot(on); style(get("AutoBat"), on); updateFloatingButtons()
    end)
    connect("AutoLeft", function()
        local on = not S.autoLeftEnabled
        if on then
            if S.autoRightEnabled then S.autoRightEnabled=false; stopAutoRight() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoLeftEnabled=true; startAutoLeft()
        else S.autoLeftEnabled=false; stopAutoLeft() end
        if S.autoLeftSetVisual then S.autoLeftSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    connect("AutoRight", function()
        local on = not S.autoRightEnabled
        if on then
            if S.autoLeftEnabled then S.autoLeftEnabled=false; stopAutoLeft() end
            if S.batAimbotEnabled then setBatAimbot(false) end
            S.autoRightEnabled=true; startAutoRight()
        else S.autoRightEnabled=false; stopAutoRight() end
        if S.autoRightSetVisual then S.autoRightSetVisual(on) end
        S.restartMovement(); updateFloatingButtons(); saveConfig()
    end)
    local function normalSpeed()
        S.setNormalSpeedMode(); S.restartMovement(); updateFloatingButtons()
        style(get("CarrySpd"), false); style(get("LaggerCarry"), false); style(get("LaggerNormal"), false); saveConfig()
    end
    connect("CarrySpd", function()
        if S.speedMode and S.laggerMode == 0 then
            normalSpeed()
        else
            S.setCarrySpeedMode()
            S.restartMovement()
            updateFloatingButtons()
            style(get("LaggerNormal"), false)
            style(get("LaggerCarry"), false)
            saveConfig()
        end
    end)
    local function lagger(mode)
        if S.laggerMode == mode and not S.speedMode then normalSpeed(); return end
        S.speedMode=false; S.laggerMode=mode; S.refreshSpeedModeLabel(); S.applySpeedVelocityNow(); S.restartMovement(); updateFloatingButtons()
        style(get("LaggerCarry"), mode == 2); style(get("LaggerNormal"), mode == 1); saveConfig()
    end
    connect("LaggerCarry", function() lagger(2) end)
    connect("LaggerNormal", function() lagger(1) end)

    S.dropBrainrotSetVisual = function(active) style(get("Drop"), active) end
    S.dropBrainrotFloatVisual = S.dropBrainrotSetVisual
    S._btnAAL, S._bsAAL, S._l1AAL, S._l2AAL = get("AutoLeft").button, nil, nil, nil
    S._btnAAR, S._bsAAR, S._l1AAR, S._l2AAR = get("AutoRight").button, nil, nil, nil
    S._btnBAT, S._bsBAT, S._l1BAT, S._l2BAT = get("AutoBat").button, nil, nil, nil
    S._setPButtonActive = function(button, _, _, _, active)
        for _, i in pairs(byId) do if i.button == button then style(i, active); return end end
    end
    S._floatingButtons = {
        lagger=get("LaggerNormal").button, l2Lagger={Text=""}, carry=get("CarrySpd").button,
        autoLeft=get("AutoLeft").button, autoRight=get("AutoRight").button, bat=get("AutoBat").button,
    }
    style(get("BatBypass"), S.batBypassEnabled)
    style(get("AutoBat"), S.batAimbotEnabled)
    style(get("AutoLeft"), S.autoLeftEnabled)
    style(get("AutoRight"), S.autoRightEnabled)
    style(get("CarrySpd"), S.speedMode and S.laggerMode == 0)
    style(get("LaggerNormal"), S.laggerMode == 1 and not S.speedMode)
    style(get("LaggerCarry"), S.laggerMode == 2 and not S.speedMode)
end

-- ── Load config then build UI ─────────────────────────────────────────────
pcall(function()
    local ok, data = pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then return readfile(CONFIG_FILE) end
    end)
    if ok and data then
        local cfgOk, cfg = pcall(function() return HS:JSONDecode(data) end)
        if cfgOk and type(cfg)=="table" then
            SMKSetUserScale("menu", cfg.userMenuScale or 1, false)
            SMKSetUserScale("mobile", cfg.userMobileScale or 1, false)
            if type(cfg.normalSpeed)=="number" then S.NS=cfg.normalSpeed end
            if type(cfg.hubColor)=="string" then
                for _, optionId in ipairs(HUB_COLOR_OPTIONS) do
                    if cfg.hubColor == optionId then
                        S.hubColor = optionId
                        break
                    end
                end
            end
            S.optimizerMode = cfg.optimizerMode == "tripa" and "tripa" or "standard"
            S.mobileButtonStyle = cfg.mobileButtonStyle == "round" and "round" or "original"
            SMKBrandStyle.setFont(cfg.hubTitleFont,false)
            if S.setMedusaSkin then S.setMedusaSkin(cfg.medusaSkin,false) end
            if type(cfg.carrySpeed)=="number" then S.CS=cfg.carrySpeed end
            if type(cfg.laggerSpeed)=="number" then S.LS=cfg.laggerSpeed end
            if type(cfg.laggerCarrySpeed)=="number" then S.LCS=cfg.laggerCarrySpeed end
            if type(cfg.grabRadius)=="number" then S.Steal.StealRadius=cfg.grabRadius end
            if cfg.stealDuration ~= nil then
                S.Steal.StealDuration = sanitizeStealDuration(cfg.stealDuration, S.Steal.StealDuration)
            end
            if type(cfg.mainMenuPos) == "table" then
                local pos = cfg.mainMenuPos
                local function finite(value)
                    return type(value) == "number" and value == value
                        and value > -math.huge and value < math.huge
                end
                if finite(pos.XS) and finite(pos.X) and finite(pos.YS) and finite(pos.Y) then
                    S.menuOpenPosition = UDim2.new(pos.XS, pos.X, pos.YS, pos.Y)
                    if S.mainMenuFrame then S.mainMenuFrame.Position = S.menuOpenPosition end
                end
            end
            S.dropMode = cfg.dropMode == 2 and 2 or 1
            if type(cfg.mobileButtonPositions)=="table" then S.mobileButtonPositions=cfg.mobileButtonPositions end
            if type(cfg.floatingFreeButtonPositions)=="table" then S.floatingFreeButtonPositions=cfg.floatingFreeButtonPositions end
            if type(cfg.lockMobileButtons)=="boolean" then S.lockMobileButtons=cfg.lockMobileButtons end
            local function rl(entry, saved)
                if type(saved) ~= "table" then return end
                for _, field in ipairs({"kb", "gp"}) do
                    if type(saved[field]) == "string" then
                        local ok, key = pcall(function() return Enum.KeyCode[saved[field]] end)
                        if ok and key then SMKBindings.assign(entry, key, field == "gp") end
                    end
                end
            end
            -- Solo restaurar keybinds de configs ya migradas; las antiguas usaban teclas previas.
            if cfg.keybindVersion == 1 then
                rl(S.KB.DropBrainrot, cfg.dropBrainrotKey); rl(S.KB.AutoLeft, cfg.autoLeftKey)
                rl(S.KB.AutoRight, cfg.autoRightKey); rl(S.KB.AutoBat, cfg.autoBatKey)
                rl(S.KB.BatBypass, cfg.batBypassKey)
                rl(S.KB.TPFlor, cfg.tpFloorKey); rl(S.KB.GuiHide, cfg.guiHideKey)
                rl(S.KB.SpeedToggle, cfg.speedToggleKey); rl(S.KB.LaggerToggle, cfg.laggerToggleKey)
            end
            if cfg.batBypassVersion and S.selectBatBypassVersion then
                S.selectBatBypassVersion(cfg.batBypassVersion, false)
            end
            if tonumber(cfg.batBypassSpeed) then S.batBypassSpeed = math.clamp(tonumber(cfg.batBypassSpeed), 1, 500) end
            if S.setInformationE01 then S.setInformationE01(cfg.informationE01 ~= false, false) end
            if cfg.carryMode==true then S.speedMode=true; S.setCarrySpeedMode() end
            if cfg.laggerMode == 1 then
                S.setLaggerNormalMode()
            elseif cfg.laggerMode == 2 then
                S.setLaggerCarryMode()
            end
            if cfg.antiRagdoll==true then S.antiRagdollEnabled=true; startAntiRagdoll() end
            S.tpDownHeightTrigger = 20
            if type(cfg.tpDownHeightTrigger) == "number" then S.tpDownHeightTrigger = math.clamp(cfg.tpDownHeightTrigger, 1, 500) end
            -- Migrar el antiguo estado Infinite Jump a la única opción Hold Jump.
            if cfg.holdJumpEnabled==true or cfg["infiniteJump"]==true then S.holdJumpEnabled=true; startHoldJump() end
            if cfg.antiDrop==true then S.setAntiDrop(true, false) end
            if cfg.antiDie==true then S.setAntiDie(true, false) end
            if cfg.medusaCounter==true then
                S.medusaCounterEnabled=true
                if LP.Character then setupMedusaCounter(LP.Character) end
            end
            if cfg.batCounter==true then
                S.batCounterEnabled=true
                startBatCounter()
            end
            if cfg.autoStealEnabled==true then S.stealActive=true; startAutoSteal() end
            if cfg.batAimbot==true then S.batAimbotEnabled=true; startBatAimbot() end
            if type(cfg.batSkin) == "string" then S.setBatSkin(cfg.batSkin, false) end
            if type(cfg.displaySkin)=="string" then
                for _,name in ipairs(DAHUB_SKIN_ORDER) do if name==cfg.displaySkin then S.displaySkin=name; break end end
            end
            S.customSkinEnabled = cfg.customSkin == true and S.displaySkin ~= "Off"
            if S.customSkinEnabled and S.applyDisplaySkin then task.defer(function() pcall(S.applyDisplaySkin) end) end
            if cfg.espEnabled==true then
                S.espEnabled=true
                toggleESP(true)
                task.spawn(function()
                    task.wait(1)
                    if S.setESPVisual then S.setESPVisual(true) end
                end)
            end
            if type(cfg.stealHudPos)=="table" then
                S._savedStealHudPos = cfg.stealHudPos
                task.defer(function()
                    if S.stealHudCard and S._savedStealHudPos then
                        local pos = S._savedStealHudPos
                        S.stealHudCard.Position = UDim2.new(
                            pos.XS or 0.5, pos.X or 0,
                            pos.YS or 1, pos.Y or -106
                        )
                    end
                end)
            end
            if cfg.unwalkEnabled==true then S.unwalkEnabled=true; startUnwalk() end
            if cfg.lockUI==true then S.lockUIEnabled=true end
            if cfg.fpsBoost==true then S.fpsBoostEnabled=true; applyFPSBoost() end
            S.vividGraphicsEnabled = cfg.vividGraphics == true
            if S.vividGraphicsEnabled then pcall(enableVividGraphics) end
            if type(cfg.stretchFOV) == "number" then S.stretchFOV = math.clamp(cfg.stretchFOV, 70, 150) end
            S.stretchEnabled = cfg.stretchEnabled == true
            if S.stretchEnabled then pcall(enableStretch) end
            if type(cfg.skyTheme) == "string" and SKY_PRESETS[cfg.skyTheme] then
                S.skyTheme = cfg.skyTheme
                if S.skyTheme ~= "Off" then pcall(applyCustomSky, S.skyTheme) end
            else
                S.skyTheme = "Off"
            end
            if type(cfg.krobloxMode) == "string" and ({Off=true, Left=true, Right=true, Both=true})[cfg.krobloxMode] then
                S.krobloxMode = cfg.krobloxMode
                if S.krobloxMode ~= "Off" then pcall(_G._SMKApplyKroblox, S.krobloxMode) end
            else
                S.krobloxMode = "Off"
            end
            S.antiFlingEnabled = cfg.antiFling == true
            if S.antiFlingEnabled then pcall(YF.startAntiFling) end
            if type(cfg.lockEnemyRange) == "number" then S.bodyLockRange = math.clamp(math.floor(cfg.lockEnemyRange), 5, 200) end
            S.bodyLockEnabled = cfg.lockEnemy == true
            if S.bodyLockEnabled then pcall(YF.startBodyLock) end
            if type(cfg.animPack) == "string" and (cfg.animPack == "Off" or YF.ANIM_PACKS[cfg.animPack]) then
                S.currentAnimPack = cfg.animPack
            else
                S.currentAnimPack = "Off"
            end
            if S.currentAnimPack ~= "Off" then pcall(YF.startAnimPack, S.currentAnimPack) end
            S.antiLagEnabled = cfg.antiLag == true
            if S.antiLagEnabled then pcall(YF.enableAntiLag) end
            if cfg.hideOpiumButtons==true then S.hideOpiumButtonsEnabled=true end
            if type(cfg.floatingPanelPos)=="table" then
                -- El panel todavía no existe aquí; createFloatingButtonPanel lo aplica después.
                S._savedFloatingPanelPos = cfg.floatingPanelPos
            end
        end
    end
end)


-- ── Nueva barra Steal (diseño adjunto) ───────────────────────────────────
local function buildStealHUD()
    local sg = Instance.new("ScreenGui")
    sg.Name = "StealBarMovableSmall"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 90 -- Main menu is 100; Auto Grab stays underneath.
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global

    -- Share the menu's GUI host so DisplayOrder is reliable across executors.
    local menuGui = S.mainMenuFrame and S.mainMenuFrame:FindFirstAncestorOfClass("ScreenGui")
    local parent = menuGui and menuGui.Parent or game:GetService("CoreGui")
    if not pcall(function() sg.Parent = parent end) or not sg.Parent then
        sg.Parent = LP:WaitForChild("PlayerGui")
    end

    local panel = Instance.new("Frame")
    panel.Name = "StealProgressBar"
    panel.Size = UDim2.new(0, 300, 0, 54)
    panel.Position = UDim2.new(0.5, -150, 1, -75)
    panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    panel.BackgroundTransparency = 0
    panel.BorderSizePixel = 0
    panel.Active = true
    panel.Selectable = true
    panel.ClipsDescendants = true
    panel.Visible = true
    panel.ZIndex = 100
    panel.Parent = sg
    addPuren001Decorations(panel, true)

    local panelCorner = Instance.new("UICorner")
    panelCorner.CornerRadius = UDim.new(0, 13)
    panelCorner.Parent = panel
    local panelStroke = Instance.new("UIStroke")
    panelStroke.Color = Color3.fromRGB(0, 0, 0)
    panelStroke.Thickness = 1.3
    panelStroke.Transparency = 0.15
    panelStroke.Parent = panel


    -- Sem brilho animado permanente no HUD.

    local fpsText = Instance.new("TextLabel")
    fpsText.Name = "FPS"
    fpsText.Size = UDim2.new(1, -24, 0, 17)
    fpsText.Position = UDim2.new(0, 12, 0, 6)
    fpsText.BackgroundTransparency = 1
    fpsText.Text = "001 · AUTO GRAB · 60FPS · 0ms"
    fpsText.TextColor3 = Color3.fromRGB(255, 221, 126)
    fpsText.Font = Enum.Font.Gotham
    fpsText.TextSize = 12
    fpsText.TextXAlignment = Enum.TextXAlignment.Left
    fpsText.TextYAlignment = Enum.TextYAlignment.Center
    fpsText.ZIndex = 103
    fpsText.Parent = panel

    local row = Instance.new("Frame")
    row.Name = "ProgressRow"
    row.Size = UDim2.new(1, -20, 0, 16)
    row.Position = UDim2.new(0, 10, 0, 30)
    row.BackgroundTransparency = 1
    row.ZIndex = 101
    row.Parent = panel

    local background = Instance.new("Frame")
    background.Name = "BarBackground"
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.ClipsDescendants = true
    background.ZIndex = 101
    background.Parent = row
    local backgroundCorner = Instance.new("UICorner")
    backgroundCorner.CornerRadius = UDim.new(0, 8)
    backgroundCorner.Parent = background

    local fill = Instance.new("Frame")
    fill.Name = "ProgressFill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fill.BorderSizePixel = 0
    fill.ZIndex = 102
    fill.Parent = background
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 8)
    fillCorner.Parent = fill
    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    fillGradient.Parent = fill

    local percent = Instance.new("TextLabel")
    percent.Name = "Percent"
    percent.Size = UDim2.new(1, 0, 1, 0)
    percent.BackgroundTransparency = 1
    percent.Text = "0%"
    percent.TextColor3 = SMKThemeRGB(255, 255, 255)
    percent.Font = Enum.Font.Gotham
    percent.TextSize = 11
    percent.TextXAlignment = Enum.TextXAlignment.Center
    percent.TextYAlignment = Enum.TextYAlignment.Center
    percent.TextStrokeColor3 = SMKThemeRGB(245, 245, 250)
    percent.TextStrokeTransparency = 1
    percent.ZIndex = 104
    percent.Parent = background

    -- Lightning follows the rendered edge, including the smooth return.
    local lightning = Instance.new("Frame")
    lightning.Name = "AutoGrabLightning"
    lightning.Size = UDim2.fromOffset(24, 16)
    lightning.AnchorPoint = Vector2.new(0.5, 0.5)
    lightning.BackgroundTransparency = 1
    lightning.Active = false
    lightning.Selectable = false
    lightning.ZIndex = 103
    lightning.Visible = false
    lightning.Parent = background

    local segments = {}
    local points = {
        Vector2.new(16, 1), Vector2.new(8, 6),
        Vector2.new(14, 7), Vector2.new(7, 15),
    }
    for i = 1, #points - 1 do
        local a, b = points[i], points[i + 1]
        local delta = b - a
        local center = (a + b) * 0.5
        for layer = 1, 2 do
            local line = Instance.new("Frame")
            line.Name = layer == 1 and "LightningGlow" or "LightningCore"
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.Position = UDim2.fromOffset(center.X, center.Y)
            line.Size = UDim2.fromOffset(delta.Magnitude + 1, layer == 1 and 5 or 2)
            line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            line.BackgroundColor3 = layer == 1
                and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(0, 0, 0)
            line.BackgroundTransparency = layer == 1 and 0.55 or 0
            line.BorderSizePixel = 0
            line.ZIndex = 103
            line.Active = false
            line.Selectable = false
            line.Parent = lightning
            local corner = Instance.new("UICorner", line)
            corner.CornerRadius = UDim.new(0, 2)
            if layer == 1 then table.insert(segments, line) end
        end
    end

    -- Additional stationary bolt at the middle of the loading bar.
    local centralLightning = lightning:Clone()
    centralLightning.Name = "AutoGrabCentralLightning"
    centralLightning.Position = UDim2.fromScale(0.5, 0.5)
    centralLightning.Visible = false
    centralLightning.Parent = background
    for _, child in ipairs(centralLightning:GetChildren()) do
        if child.Name == "LightningGlow" then table.insert(segments, child) end
    end

    local trail = Instance.new("Frame")
    trail.Name = "LightningTrail"
    trail.AnchorPoint = Vector2.new(1, 0.5)
    trail.Size = UDim2.fromOffset(34, 6)
    trail.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    trail.BackgroundTransparency = 0.45
    trail.BorderSizePixel = 0
    trail.ZIndex = 103
    trail.Visible = false
    trail.Parent = background
    local trailCorner = Instance.new("UICorner", trail)
    trailCorner.CornerRadius = UDim.new(0, 3)
    local trailGradient = Instance.new("UIGradient", trail)
    trailGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.15),
    })

    local displayedProgress = 0
    local progressConnection
    local progressElapsed = 0
    progressConnection = RunService.Heartbeat:Connect(function(dt)
        progressElapsed += dt
        if progressElapsed < 1 / 30 then return end
        dt = progressElapsed
        progressElapsed = 0
        if not panel.Visible or not sg.Enabled then return end
        local now = os.clock()
        local target = S.progressVisualTarget or 0
        if now < (S.progressVisualCompleteUntil or 0) then target = 1 end
        if displayedProgress == target then return end
        -- Exponential smoothing remains consistent at different frame rates.
        local returning = target < displayedProgress
        local response = returning and 0.07 or 0.025
        displayedProgress += (target - displayedProgress) * (1 - math.exp(-dt / response))
        if math.abs(target - displayedProgress) < 0.001 then displayedProgress = target end
        fill.Size = UDim2.new(displayedProgress, 0, 1, 0)
        percent.Text = math.floor(displayedProgress * 100 + 0.5) .. "%"
        local width = background.AbsoluteSize.X
        local edge = displayedProgress * width
        lightning.Position = UDim2.new(0, math.clamp(edge, 12, math.max(12, width - 12)), 0.5, 0)
        lightning.Visible = displayedProgress > 0.003
        centralLightning.Visible = lightning.Visible
        -- Leave room for the central bolt beside the percentage, never over it.
        percent.Position = UDim2.fromOffset(centralLightning.Visible and 44 or 0, 0)
        percent.Size = UDim2.new(1, centralLightning.Visible and -44 or 0, 1, 0)
        trail.Position = UDim2.new(0, edge, 0.5, 0)
        trail.AnchorPoint = Vector2.new(returning and 0 or 1, 0.5)
        trailGradient.Rotation = returning and 180 or 0
        trail.Visible = lightning.Visible and math.abs(target - displayedProgress) > 0.002
        -- Raios estáticos: evita atualizar vários objetos a cada frame.
    end)
    sg.Destroying:Connect(function()
        if progressConnection then progressConnection:Disconnect() end
    end)

    -- Arrastre con mouse o toque.
    local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil
    local moved = false
    local function updateDrag(input)
        if S.lockUIEnabled then return end
        if (input.Position - dragStart).Magnitude > 2 then moved = true end
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
    panel.InputBegan:Connect(function(input)
        if S.lockUIEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            dragStart = input.Position
            startPosition = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if moved then saveConfig() end
                    dragging = false
                    moved = false
                end
            end)
        end
    end)
    panel.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if S.lockUIEnabled then
            dragging = false
            moved = false
            return
        end
        if input == dragInput and dragging then updateDrag(input) end
    end)

    S.progressBarFrame = background
    S.progressFill = fill
    S.progressPct = percent
    S.stealHudCard = panel
    if S._savedStealHudPos then
        local pos = S._savedStealHudPos
        panel.Position = UDim2.new(pos.XS or 0.5, pos.X or 0, pos.YS or 1, pos.Y or -106)
    end

    -- Actualización de FPS y ping del diseño adjunto.
    task.spawn(function()
        local lastTime, frameCount = os.clock(), 0
        while sg.Parent do
            RunService.RenderStepped:Wait()
            frameCount += 1
            local now = os.clock()
            if now - lastTime >= 0.5 then
                local fps = math.floor(frameCount / (now - lastTime) + 0.5)
                frameCount, lastTime = 0, now
                local ping = 0
                pcall(function() ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end)
                fpsText.Text = string.format("%dFPS · %dms", fps, ping)
            end
        end
    end)
end

interfaceLoaded = false
local function loadSMKInterface()
    if interfaceLoaded then return end
    interfaceLoaded = true
    -- Cargar la interfaz local inmediatamente; la música se reproduce por separado.
    SMKApplyColorTheme(S.hubColor or DEFAULT_HUB_COLOR)
    createFloatingButtonPanel()
    buildGui()
    SMKSetUserScale("menu", S.userMenuScale or 1, false)
    SMKSetUserScale("mobile", S.userMobileScale or 1, false)
    buildStealHUD()
    -- Borde neón violeta en los botones visibles del menú y HUD.
    for _, root in ipairs({game:GetService("CoreGui"), LP:WaitForChild("PlayerGui")}) do
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("TextButton") then decoratePuren001Button(obj) end
        end
    end
    local character = LP.Character
    if character then
        S.setupSpeedBillboard(character)
        setupSMKRagdollTimer(character)
    end

    -- Se desactivó la ejecución de código Lua remoto por seguridad.
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if interfaceLoaded then
        S.setupSpeedBillboard(char)
        setupSMKRagdollTimer(char)
    end
    if S.antiRagdollEnabled then startAntiRagdoll() end
    if S.medusaCounterEnabled then setupMedusaCounter(char) end
    if S.currentAnimPack ~= "Off" then
        task.spawn(function()
            local animate = char:WaitForChild("Animate", 5)
            if animate and LP.Character == char and S.currentAnimPack ~= "Off" then
                pcall(YF.saveOriginalAnims, char)
                pcall(YF.startAnimPack, S.currentAnimPack)
            end
        end)
    end
    if S.holdJumpEnabled and not S._youtResetInProgress then startHoldJump() end
    if S.unwalkEnabled then task.wait(1); startUnwalk() end
    S.restartMovement()
end)
if LP.Character then
    task.spawn(function()
        if interfaceLoaded then
            S.setupSpeedBillboard(LP.Character)
            setupSMKRagdollTimer(LP.Character)
        end
        if S.antiRagdollEnabled then startAntiRagdoll() end
        if S.medusaCounterEnabled then setupMedusaCounter(LP.Character) end
    end)
end

showIntro(function()
    loadSMKInterface()
end)

-- Se omitió el módulo remoto de polling/heartbeat y comandos externos.

-- ＳＭＫㅤＨＵＢ: aura trasera blanca reforzada transferida de BLESS (Aurora / Blade / Edge)
do
    pcall(function()
        if _G.__TERROR001_BackAuraCleanup then
            _G.__TERROR001_BackAuraCleanup()
        end

        local auraPlayers = game:GetService("Players")
        local auraRunService = game:GetService("RunService")
        local auraPlayer = auraPlayers.LocalPlayer
        if not auraPlayer then return end

        local auraObjects = {}
        local auraTrails = {}
        local auraRoot = nil
        local auraPosition = nil
        local auraMoving = false
        local auraConnections = {}
        local auraAlive = true

        local function clearTerrorAura()
            auraRoot, auraPosition, auraMoving = nil, nil, false
            for _, object in ipairs(auraObjects) do
                pcall(function() object:Destroy() end)
            end
            auraObjects, auraTrails = {}, {}
        end

        local function buildTerrorAura(root)
            clearTerrorAura()
            auraRoot, auraPosition = root, root.Position

            local layers = {
                {name="Aurora", top=1.05, bottom=-1.25, alpha=0.28, lifetime=0.78},
                {name="Blade",  top=0.16, bottom=-0.16, alpha=0.015, lifetime=0.66},
                {name="Edge",   top=0.065,bottom=-0.065,alpha=0.00, lifetime=0.56},
            }

            for index, layer in ipairs(layers) do
                local attachments = {}
                for i, height in ipairs({layer.top, layer.bottom}) do
                    local attachment = Instance.new("Attachment")
                    attachment.Name = "TERROR001_Aura_" .. layer.name .. i
                    attachment.Position = Vector3.new(0, height, root.Size.Z * 0.5 + 0.35)
                    attachment.Parent = root
                    attachments[i] = attachment
                    auraObjects[#auraObjects+1] = attachment
                end

                local trail = Instance.new("Trail")
                trail.Name = "TERROR001_Aura_" .. layer.name
                trail.Attachment0, trail.Attachment1 = attachments[1], attachments[2]
                trail.Enabled = false
                trail.FaceCamera = true
                trail.Lifetime = layer.lifetime
                trail.MinLength = 0.03
                trail.MaxLength = 28
                trail.LightEmission = 1
                trail.LightInfluence = 0
                trail.WidthScale = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 2.15),
                    NumberSequenceKeypoint.new(0.35, 1.75),
                    NumberSequenceKeypoint.new(0.80, 0.72),
                    NumberSequenceKeypoint.new(1, 0),
                })
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, layer.alpha),
                    NumberSequenceKeypoint.new(0.45, math.min(0.72, layer.alpha + 0.10)),
                    NumberSequenceKeypoint.new(0.8, 0.62),
                    NumberSequenceKeypoint.new(1, 1),
                })
                local bright = index == 3 and Color3.fromRGB(255,255,255) or Color3.fromRGB(225,230,240)
                trail.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.28, bright),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
                })
                trail.Parent = root
                auraObjects[#auraObjects+1] = trail
                auraTrails[index] = trail
            end
        end

        -- Aura blanca adicional para el bate equipado.
        local batAuraPart = nil
        local batAuraObjects = {}
        local batAuraTrails = {}

        local function clearTerrorBatAura()
            batAuraPart = nil
            for _, object in ipairs(batAuraObjects) do
                pcall(function() object:Destroy() end)
            end
            batAuraObjects, batAuraTrails = {}, {}
        end

        local function buildTerrorBatAura(handle)
            clearTerrorBatAura()
            batAuraPart = handle

            -- Brillo blanco constante alrededor del bate, incluso cuando está quieto.
            local batHighlight = Instance.new("Highlight")
            batHighlight.Name = "TERROR001_BatAura_WhiteGlow"
            batHighlight.Adornee = handle
            batHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            batHighlight.FillColor = Color3.fromRGB(255, 255, 255)
            batHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            batHighlight.FillTransparency = 0.72
            batHighlight.OutlineTransparency = 0.08
            batHighlight.Parent = handle
            batAuraObjects[#batAuraObjects+1] = batHighlight

            local batLight = Instance.new("PointLight")
            batLight.Name = "TERROR001_BatAura_WhiteLight"
            batLight.Color = Color3.fromRGB(255, 255, 255)
            batLight.Brightness = 1.8
            batLight.Range = 8
            batLight.Shadows = false
            batLight.Parent = handle
            batAuraObjects[#batAuraObjects+1] = batLight

            local layers = {
                {name="BatAurora", top=0.42, bottom=-0.42, alpha=0.18, lifetime=0.48},
                {name="BatBlade",  top=0.15, bottom=-0.15, alpha=0.08, lifetime=0.40},
                {name="BatEdge",   top=0.055,bottom=-0.055,alpha=0.02, lifetime=0.32},
            }
            for index, layer in ipairs(layers) do
                local attachments = {}
                for n, height in ipairs({layer.top, layer.bottom}) do
                    local attachment = Instance.new("Attachment")
                    attachment.Name = "TERROR001_BatAura_" .. layer.name .. n
                    attachment.Position = Vector3.new(0, height, 0)
                    attachment.Parent = handle
                    attachments[n] = attachment
                    batAuraObjects[#batAuraObjects+1] = attachment
                end
                local trail = Instance.new("Trail")
                trail.Name = "TERROR001_BatAura_" .. layer.name
                trail.Attachment0, trail.Attachment1 = attachments[1], attachments[2]
                trail.Enabled = false
                trail.FaceCamera = true
                trail.Lifetime = layer.lifetime
                trail.MinLength = 0.02
                trail.MaxLength = 18
                trail.LightEmission = 1
                trail.LightInfluence = 0
                trail.WidthScale = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.72),
                    NumberSequenceKeypoint.new(0.45, 0.42),
                    NumberSequenceKeypoint.new(1, 0),
                })
                trail.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, layer.alpha),
                    NumberSequenceKeypoint.new(0.65, 0.45),
                    NumberSequenceKeypoint.new(1, 1),
                })
                local shade = index == 3 and Color3.fromRGB(255,255,255) or Color3.fromRGB(225,230,240)
                trail.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
                    ColorSequenceKeypoint.new(0.35, shade),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255)),
                })
                trail.Parent = handle
                batAuraObjects[#batAuraObjects+1] = trail
                batAuraTrails[index] = trail
            end
        end

        local function updateTerrorBatAura(character, moving)
            local equippedTool = character and character:FindFirstChildOfClass("Tool")
            local handle = equippedTool and (equippedTool:FindFirstChild("Handle") or equippedTool:FindFirstChildWhichIsA("BasePart"))
            if not handle or not handle:IsA("BasePart") then
                if batAuraPart then clearTerrorBatAura() end
                return
            end
            if batAuraPart ~= handle or not batAuraTrails[1] or not batAuraTrails[1].Parent then
                buildTerrorBatAura(handle)
            end
            for _, trail in ipairs(batAuraTrails) do
                if moving then trail:Clear() end
                trail.Enabled = moving
            end
        end

        local function stepTerrorAura(dt)
            if not auraAlive then return end
            local character = auraPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if not root or not humanoid or humanoid.Health <= 0 then
                if auraRoot then clearTerrorAura() end
                return
            end

            if auraRoot ~= root or not auraTrails[1] or not auraTrails[1].Parent then
                buildTerrorAura(root)
            end

            local position = root.Position
            local delta = position - (auraPosition or position)
            auraPosition = position
            local distance = Vector3.new(delta.X, 0, delta.Z).Magnitude
            local teleported = dt <= 0 or dt > 0.25 or delta.Magnitude > math.max(24, dt * 600)
            local moving = not teleported and distance / math.max(dt, 0.001) > 2.5 and not humanoid.Sit
            updateTerrorBatAura(character, moving)

            if teleported then
                for _, trail in ipairs(auraTrails) do trail:Clear() end
            end
            if auraMoving ~= moving then
                auraMoving = moving
                for _, trail in ipairs(auraTrails) do
                    if moving then trail:Clear() end
                    trail.Enabled = moving
                end
            end
        end

        auraConnections[#auraConnections+1] = auraRunService.Heartbeat:Connect(stepTerrorAura)
        auraConnections[#auraConnections+1] = auraPlayer.CharacterRemoving:Connect(function()
            clearTerrorAura()
            clearTerrorBatAura()
        end)
        auraConnections[#auraConnections+1] = auraPlayer.CharacterAdded:Connect(function()
            clearTerrorAura()
        end)

        _G.__TERROR001_BackAuraCleanup = function()
            auraAlive = false
            for _, connection in ipairs(auraConnections) do
                pcall(function() connection:Disconnect() end)
            end
            clearTerrorAura()
            clearTerrorBatAura()
        end
    end)
end