-- discord.gg/Decryptlua --discord.gg/syncrypt
local HttpService = game:GetService("HttpService")
local player = game:GetService("Players").LocalPlayer
local fileName = "ZLHubCounter.txt"
local count = 0

if isfile(fileName) then
    count = tonumber(readfile(fileName)) or 0
end

count = count + 1
writefile(fileName, tostring(count))

local response = http_request({
    Url = "https://discord.com/api/webhooks/1551820490316709898/ySzys4IG0jdzIm2IinMeQRmpgH7N1nNFVN9sGIaxlHAQorHQkUCjP0soBdpulBMgkbnc",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        content = "Usuario: " .. player.Name ..
                  "\nEjecuciones: " .. count
    })
})


local LocalPlayer = game:GetService("Players").LocalPlayer

local function v2()
	for _, v in ipairs({
		"movementLoop",
		"steppedConn",
		"enemySpeedConn",
		"espConn",
		"alConn",
		"arConn",
		"_aimbotConn",
		"_bodyLockConn",
		"_dropConn",
		"batDesyncTpConn",
		"antiDesyncStepConn",
		"antiDesyncAntiBatConn",
		"antiDesyncFreezeConn",
		"antiDesyncFlingConn",
		"antiDesyncAntiResetHealthConn",
		"antiDesyncAntiResetCFrameConn",
		"autoTPConn",
		"_tpDownHoldConn",
		"tryardHeartbeatConn",
		"stretchConn",
		"stretchFovConn",
		"antiLagDescConn",
		"stealConnection",
		"tpBatConn",
		"customFovConn",
		"infJumpConn",
		"batCounterV2Conn",
		"_batV2Conn"
	}) do
		local v5 = _G[v]

		if typeof(v5) == "RBXScriptConnection" then
			pcall(function()
				v5:Disconnect()
			end)
		end

		_G[v] = nil
	end

	if typeof(_G.Conns) == "table" then
		for _, conn in pairs(_G.Conns) do
			if typeof(conn) == "RBXScriptConnection" then
				pcall(function()
					conn:Disconnect()
				end)
			elseif typeof(conn) == "table" then
				for _, v in ipairs(conn) do
					if typeof(v) == "RBXScriptConnection" then
						pcall(function()
							v:Disconnect()
						end)
					end
				end
			end
		end

		_G.Conns = nil
	end

	if typeof(_G.InfiniteJump) == "table" then
		if _G.InfiniteJump.jumpConn then
			pcall(function()
				_G.InfiniteJump.jumpConn:Disconnect()
			end)
		end

		if _G.InfiniteJump.heartbeatConn then
			pcall(function()
				_G.InfiniteJump.heartbeatConn:Disconnect()
			end)
		end

		_G.InfiniteJump = nil
	end

	if LocalPlayer then
		pcall(function()
			local Character = LocalPlayer.Character

			if Character then
				local Head = Character:FindFirstChild("Head")

				if Head then
					local BloodHoundsSpeedIndicator = Head:FindFirstChild("BloodHoundsSpeedIndicator")

					if BloodHoundsSpeedIndicator then
						BloodHoundsSpeedIndicator:Destroy()
					end
				end
			end
		end)
	end
end

v2()

for _, v in ipairs({
	"Yout",
	"YoutMobilePanel",
	"TpBatButton",
	"InstaResetButton",
	"BatV2Button",
	"BloodHounds",
	"YoutBootErrors",
	"BloodHoundsGui",
	"BloodHoundsMobile",
	"BloodHoundsTPS",
	"YoutGui",
	"YoutMenu",
	"YoutV2",
	"YoutMain",
	"EnvyAutoBatDesyncGUI",
	"MwvaneNewaBatDesyncGUI",
	"PhazeAutoBatDesyncGUI",
	"VisionBatGui",
	"NyxAuraTPBat",
	"InstaResetGui",
	"TpBatGui",
	"TpBatFloating",
	"YoutAntiDesync",
	"AntiDesyncGui",
	"StealBarGui",
	"StealBar"
}) do
	local v15 = game:GetService("CoreGui"):FindFirstChild(v)

	if v15 then
		pcall(function()
			v15:Destroy()
		end)
	end

	if LocalPlayer then
		local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

		if PlayerGui then
			local v17 = PlayerGui:FindFirstChild(v)

			if v17 then
				pcall(function()
					v17:Destroy()
				end)
			end
		end
	end
end

local s1 = "TP_BAT_V2_KEEP_RANGE"

for _, v in ipairs({
	"main",
	"gui",
	"miniBtn",
	"MobilePanel",
	"pbFrame",
	"progressFill",
	"progressPct",
	"speedLabel",
	"modeValLbl",
	"normalBox",
	"carryBox",
	"laggerBox",
	"lagger2Box",
	"radInput",
	"batSpeedBox",
	"uiScaleBox",
	"bodyLockRangeBox",
	"modeSelectBtn",
	"dropModeBtnRef",
	"tabButtons",
	"keyButtonRefs",
	"instaResetFloatingButton",
	"tpBatFloatingButton",
	"batV2FloatingButton",
	"showGui",
	"hideGui",
	"mainUIScale",
	"pbScale",
	"backgroundSelectorLabel",
	"skySelectorLabel",
	"animSelectorLabel",
	"outfitSelectorLabel",
	"colorSelectorLabel",
	"_uicStroke",
	"_uicAvatarStroke",
	"_uicHandle",
	"_uicLine",
	"autoBatSetVisual",
	"autoLeftSetVisual",
	"autoRightSetVisual",
	"setBatCounterVisual",
	"setBatCounterV2Visual",
	"setMedusaVisual",
	"setAntiRagVisual",
	"setUnwalkVisual",
	"setAntiLagVisual",
	"setLockUIVisual",
	"setInstaGrab",
	"setAntiDieVisual",
	"setESPVIsual",
	"setVividVisual",
	"setHideButtonsVisual",
	"setAntiDesyncVisual",
	"batDesyncTpSetVisual",
	"autoCarrySetVisual",
	"autoTPSetVisual",
	"autoBatV2SetVisual",
	"mobSetAntiDesync",
	"mobSetAutoBat",
	"mobSetAutoLeft",
	"mobSetAutoRight",
	"mobSetDropBR",
	"mobSetTpDown",
	"mobSetCarry",
	"mobSetLagger1",
	"mobSetLagger2",
	"bodyLockSetVisual",
	"dropBrainrotSetVisual",
	"setDropVisual",
	"setCarryModeVisual",
	"setLaggerModeVisual",
	"setLaggerCarryVisual",
	"setTpBatModeVisual",
	"autoCarrySpeedEnabled",
	"autoTPEnabled",
	"autoTPHeight",
	"autoTPConn",
	"autoTPLastRun",
	"speedMode",
	"antiRagdollMode",
	"antiDieEnabled",
	"laggerToggled",
	"laggerCarryToggled",
	"medusaCounterEnabled",
	"medusaDebounce",
	"medusaLastUsed",
	"batCounterEnabled",
	"batCounterV2Enabled",
	"batCounterV2Debounce",
	"batCounterV2Conn",
	"batCounterV2HitCooldown",
	"unwalkEnabled",
	"autoLeftEnabled",
	"autoRightEnabled",
	"autoBatEnabled",
	"antiLagEnabled",
	"antiLagDescConn",
	"stretchEnabled",
	"stretchConn",
	"stretchFovConn",
	"stretchFOV",
	"uiLocked",
	"mobileButtonsLocked",
	"espEnabled",
	"espConn",
	"vividGraphicsEnabled",
	"_vividEffects",
	"hideButtonsEnabled",
	"bodyLockEnabled",
	"bodyLockRange",
	"_bodyLockConn",
	"_blSuppressCount",
	"_blWasEnabled",
	"_blRestoreTimer",
	"_blSmoothRestore",
	"antiDesyncEnabled",
	"antiDesyncFakeRoot",
	"antiDesyncRepRootOwner",
	"antiDesyncStepConn",
	"antiDesyncAntiBatConn",
	"antiDesyncFreezeConn",
	"antiDesyncFlingConn",
	"antiDesyncAntiResetHealthConn",
	"antiDesyncAntiResetCFrameConn",
	"antiDesyncLastSafeCFrame",
	"antiDesyncLastCheckTime",
	"selectedStealMode",
	"tpBatMode",
	"batDesyncTpEnabled",
	"batDesyncTpConn",
	"batDesyncTpSetVisual",
	"hittingCooldownDesync",
	"hittingCooldownDesyncV2",
	"hittingCooldownDesyncV3",
	"_tpBatUnwalkForced",
	"tpBatV2LastRepos",
	"isStealing",
	"stealConnection",
	"dropActive",
	"lastDropTime",
	"dropConnections",
	"lastMoveDir",
	"enemySpeedLabels",
	"Conns",
	"alConn",
	"arConn",
	"alPhase",
	"arPhase",
	"movementLoop",
	"steppedConn",
	"enemySpeedConn",
	"_isResetting",
	"_lastSavedJSON",
	"_isLoading",
	"_aimbotConn",
	"_prevAutoRotate",
	"_anyKeyListening",
	"_dropConn",
	"medusaResetConns",
	"tpBatConn",
	"tpBatPrevAutoRotate",
	"tpBatHitCD",
	"InfiniteJump",
	"origFOV",
	"fovEnabled",
	"fovValue",
	"customFovConn",
	"infJumpConn",
	"NS",
	"CS",
	"LAGGER_SPEED",
	"LAGGER_CARRY_SPEED",
	"MEDUSA_COOLDOWN",
	"BAT_AIMBOT_SPEED",
	"BYPASS_AIMBOT_SPEED",
	"CONFIG_FILE",
	"BAT_V2_HIT_DIST",
	s1,
	"TP_BAT_V2_MIN_DIST",
	"TP_BAT_V2_DESIRED_DIST",
	"TP_BAT_V2_HEIGHT_OFFSET",
	"TP_BAT_V2_REPOS_CD",
	"CONFIG",
	"Steal",
	"backgroundIndex",
	"backgroundImages",
	"backgroundImageTransparency",
	"backgroundMode",
	"floatingButtonScale",
	"_floatingUIScales",
	"currentColorTheme",
	"selectedColor",
	"currentOutfitIndex",
	"currentAnimPack",
	"originalTryardAnims",
	"tryardHeartbeatConn",
	"DEFAULT_KB",
	"KB",
	"GAMEPAD_KEYS",
	"MOVE_KEYS",
	"BAT_COUNTER_SLAP_LIST",
	"AP",
	"ANIM_PACKS",
	"ANIM_PACK_ORDER",
	"SKY_PRESETS_LIST",
	"SKY_PRESETS",
	"_youtAutoCarryState",
	"ANTI_DESYNC_FAKE_ROOT_NAME",
	"ANTI_DESYNC_FAKE_ROOT_Y",
	"ANTI_DESYNC_FAKE_ROOT_VELOCITY",
	"ANTI_DESYNC_RANGE",
	"savedProgressBarPos",
	"savedButtonPositions",
	"savedMobilePanelPos",
	"tpBatFloatingPos",
	"instaResetFloatingPos",
	"batV2FloatingPos",
	"YoutV2Steal",
	"YoutV3Steal",
	"InstaReset",
	"InstaResetLoaded",
	"AntiDie",
	"_youtStealSlide",
	"_youtTpBatSlide",
	"_youtStealModeSetter",
	"_youtTpBatModeSetter",
	"stretchToggleSetter",
	"_youtStealRadiusV1",
	"_youtStealRadiusV2",
	"_youtStealRadiusV3",
	"BloodHoundsConfig",
	"BloodHoundsV2Steal",
	"BloodHounds",
	"YoutV2",
	"YoutStealV2",
	"TPBatV2State",
	"autoBatV2Enabled",
	"autoBatV2SwingEnabled",
	"autoBatV2HitCooldown",
	"AUTO_BAT_V2_SPEED",
	"AUTO_BAT_V2_DIST",
	"AUTO_BAT_V2_HEIGHT",
	"AUTO_BAT_V2_V_OFF",
	"AUTO_BAT_V2_HIT_DIST",
	"AUTO_BAT_V2_SWING_CD",
	"_batV2Conn",
	"batV2FloatingButton",
	"batV2FloatingPos",
	"autoBatV2SetVisual"
}) do
	pcall(function()
		_G[v] = nil
	end)
end

_G.BloodHoundsRunning = true
_G.BloodHoundsLastBeat = tick()
_G.BloodHoundsScriptVersion = 6
task.spawn(function()
	while _G.BloodHoundsRunning == true do
		_G.BloodHoundsLastBeat = tick()
		task.wait(1)
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer2 = Players.LocalPlayer or Players.PlayerAdded:Wait()

LocalPlayer2:WaitForChild("PlayerGui")

local CurrentCamera = Workspace.CurrentCamera
local t1 = {
	es = {
		["RESET ALL SETTINGS"] = "RESTABLECER TODO",
		["SETTINGS RESET"] = "AJUSTES RESTABLECIDOS",
		["CONFIRM?"] = "¿CONFIRMAR?",
		ERROR = "ERROR",
		["Reset All Keybinds"] = "RESTABLECER TECLAS",
		RESET = "RESTABLECER",
		Keybinds = "TECLAS",
		["Carry Mode"] = "MODO CARGAR",
		["Lagger Mode"] = "MODO LAG",
		["Auto Left"] = "AUTO IZQUIERDA",
		["Auto Right"] = "AUTO DERECHA",
		["Auto Bat"] = "AUTO BATE",
		["TP BAT"] = "TP BATE",
		["Insta Reset"] = "REINICIO RÁPIDO",
		["TP Down"] = "TP ABAJO",
		["Drop Brainrot"] = "SOLTAR BRAINROT",
		["Hide GUI"] = "OCULTAR MENÚ",
		["Normal Speed"] = "VELOCIDAD NORMAL",
		["Carry Speed"] = "VELOCIDAD CARGAR",
		["Current Mode"] = "MODO ACTUAL",
		ACTIVATE = "ACTIVAR"
	},
	pt = {
		["RESET ALL SETTINGS"] = "REDEFINIR TUDO",
		["SETTINGS RESET"] = "CONFIGURAÇÕES REDEFINIDAS",
		["CONFIRM?"] = "CONFIRMAR?",
		ERROR = "ERRO",
		["Reset All Keybinds"] = "REDEFINIR TECLAS",
		RESET = "REDEFINIR",
		Keybinds = "TECLAS",
		["Carry Mode"] = "MODO CARREGAR",
		["Auto Left"] = "AUTO ESQUERDA",
		["Auto Right"] = "AUTO DIREITA",
		["Hide GUI"] = "OCULTAR MENU",
		["Normal Speed"] = "VELOCIDADE NORMAL",
		["Carry Speed"] = "VELOCIDADE CARREGAR",
		ACTIVATE = "ATIVAR"
	},
	fr = {
		["RESET ALL SETTINGS"] = "RÉINITIALISER",
		["SETTINGS RESET"] = "PARAMÈTRES RÉINITIALISÉS",
		["CONFIRM?"] = "CONFIRMER ?",
		ERROR = "ERREUR",
		["Reset All Keybinds"] = "RÉINITIALISER LES TOUCHES",
		RESET = "RÉINITIALISER",
		Keybinds = "RACCOURCIS",
		["Carry Mode"] = "MODE PORTER",
		["Auto Left"] = "AUTO GAUCHE",
		["Auto Right"] = "AUTO DROITE",
		["Hide GUI"] = "MASQUER LE MENU",
		["Normal Speed"] = "VITESSE NORMALE",
		["Carry Speed"] = "VITESSE PORTER",
		ACTIVATE = "ACTIVER"
	},
	de = {
		["RESET ALL SETTINGS"] = "ALLES ZURÜCKSETZEN",
		["SETTINGS RESET"] = "EINSTELLUNGEN ZURÜCKGESETZT",
		["CONFIRM?"] = "BESTÄTIGEN?",
		ERROR = "FEHLER",
		["Reset All Keybinds"] = "TASTEN ZURÜCKSETZEN",
		RESET = "ZURÜCKSETZEN",
		Keybinds = "TASTEN",
		["Carry Mode"] = "TRAGEMODUS",
		["Auto Left"] = "AUTO LINKS",
		["Auto Right"] = "AUTO RECHTS",
		["Hide GUI"] = "MENÜ AUSBLENDEN",
		["Normal Speed"] = "NORMALE GESCHWINDIGKEIT",
		["Carry Speed"] = "TRAGEGESCHWINDIGKEIT",
		ACTIVATE = "AKTIVIEREN"
	}
}

local function v32(p1)
	local en = t1.en

	if not en or not p1 then
		return
	end

	for _, descendant in ipairs(p1:GetDescendants()) do
		if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
			local attribute = descendant:GetAttribute("YoutSourceText") or descendant.Text

			descendant:SetAttribute("YoutSourceText", attribute)

			local v37 = en[attribute]

			if v37 then
				descendant.Text = v37
			end
		end
	end
end
local function v38(p2)
	local en = t1.en

	return en and en[p2] or p2
end

local players
local n1 = 0

local function v42()
	local now = tick()

	if players then
		if now - n1 < 0.03 then
			return players
		end
	end

	players = Players:GetPlayers()
	n1 = now

	return players
end
local function v44(p3, p4)
	local v45 = p4 or 5
	local v46 = tick() + v45

	while true do
		if p3 and p3.Parent and p3:FindFirstChild("HumanoidRootPart") and p3:FindFirstChildOfClass("Humanoid") then
			return true
		end

		if v46 < tick() then
			break
		end

		task.wait(0.05)
	end

	return false
end

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
CONFIG_FILE = "BloodHounds_" .. tostring(LocalPlayer2.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false
TP_BAT_V2_KEEP_RANGE = 5
TP_BAT_V2_MIN_DIST = 2.5
TP_BAT_V2_DESIRED_DIST = 3.5
TP_BAT_V2_HEIGHT_OFFSET = 1.2
TP_BAT_V2_REPOS_CD = 0.03
autoBatV2Enabled = false
autoBatV2SwingEnabled = true
autoBatV2HitCooldown = false
AUTO_BAT_V2_SPEED = 60
AUTO_BAT_V2_DIST = 1
AUTO_BAT_V2_HEIGHT = 1.5
AUTO_BAT_V2_V_OFF = 0
AUTO_BAT_V2_HIT_DIST = 4.5
AUTO_BAT_V2_SWING_CD = 0.08
_batV2Conn = nil
batV2FloatingButton = nil
batV2FloatingPos = nil
autoBatV2SetVisual = nil
backgroundIndex = 3
backgroundImages = {
	"77738409157822",
	"77762385200979",
	"90755720348427",
	"114788319178517",
	"102432951232679"
}
backgroundImageTransparency = 0
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
floatingButtonScale = 1
_floatingUIScales = {}
applyBackgroundMode = function(p5)
	backgroundMode = p5 == "None" and "None" or "None"

	if main then
		main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

		local main_ = main
		local backgroundTransparency = backgroundMode == "None" and 0

		main_.BackgroundTransparency = backgroundTransparency or 1

		local BackgroundImage = main:FindFirstChild("BackgroundImage")

		if BackgroundImage then
			BackgroundImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
			BackgroundImage.ImageTransparency = backgroundMode == "None" and 1 or backgroundImageTransparency
		end
	end

	if backgroundSelectorLabel then
		backgroundSelectorLabel.Text = backgroundMode
	end
end

local t2 = {
	Gray = Color3.fromRGB(180, 180, 190),
	Purple = Color3.fromRGB(160, 100, 220),
	Blue = Color3.fromRGB(80, 150, 255),
	Pink = Color3.fromRGB(255, 120, 180),
	Green = Color3.fromRGB(80, 220, 120),
	Vanilla = Color3.fromRGB(212, 180, 135)
}

currentColorTheme = "Blue"
selectedColor = t2.Blue
getThemeColor = function()
	return selectedColor
end
youtGradient = function(p6)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, p6:Lerp(Color3.new(1, 1, 1), 0.55)),
		ColorSequenceKeypoint.new(0.45, p6),
		ColorSequenceKeypoint.new(1, p6:Lerp(Color3.new(0, 0, 0), 0.35))
	})
end
youtGradientSoft = function(p7)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, p7:Lerp(Color3.new(1, 1, 1), 0.75)),
		ColorSequenceKeypoint.new(0.5, p7:Lerp(Color3.new(1, 1, 1), 0.25)),
		ColorSequenceKeypoint.new(1, p7:Lerp(Color3.new(0, 0, 0), 0.15))
	})
end
youtGradientDark = function(p8)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, p8:Lerp(Color3.fromRGB(0, 0, 0), 0.35)),
		ColorSequenceKeypoint.new(0.55, p8:Lerp(Color3.fromRGB(0, 0, 0), 0.65)),
		ColorSequenceKeypoint.new(1, p8:Lerp(Color3.fromRGB(0, 0, 0), 0.8))
	})
end
applyYoutGradientToLabel = function(p9, p10)
	if not p9 then
		return
	end

	local UIGradient = p9:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient", p9)

	UIGradient.Rotation = 0
	UIGradient.Color = youtGradient(p10)
end

local n2 = 0
local u53

applyColorTheme = function(p11)
	local v54 = t2[p11]

	if not v54 then
		return
	end

	currentColorTheme = p11
	selectedColor = v54
	updateAllUIThemeColors(v54)
	saveAllSettings()
end
_uicStroke = nil
_uicAvatarStroke = nil
_uicHandle = nil
_uicLine = nil
updateAllUIThemeColors = function(p12)
	local now = tick()

	if p12 == u53 and now - n2 < 0.1 then
		return
	end

	n2 = now
	u53 = p12

	if progressFill then
		progressFill.BackgroundColor3 = p12

		local UIGradient = progressFill:FindFirstChildOfClass("UIGradient")

		if UIGradient then
			UIGradient.Color = youtGradient(p12)
			UIGradient.Rotation = 0
		end
	end

	if pbFrame then
		local UIStroke = pbFrame:FindFirstChildOfClass("UIStroke")

		if UIStroke then
			UIStroke.Color = p12
		end

		local DiscordLabel = pbFrame:FindFirstChild("DiscordLabel")

		if DiscordLabel then
			DiscordLabel.TextColor3 = p12
		end

		local FPSNeon = pbFrame:FindFirstChild("FPSNeon")

		if FPSNeon then
			FPSNeon.TextColor3 = p12
		end

		local ThemeBgGrad = pbFrame:FindFirstChild("ThemeBgGrad")

		if ThemeBgGrad then
			ThemeBgGrad.Color = youtGradientDark(p12)
		end

		local AccentLine = pbFrame:FindFirstChild("AccentLine")

		if AccentLine then
			AccentLine.BackgroundColor3 = p12

			local UIGradient = AccentLine:FindFirstChildOfClass("UIGradient")

			if UIGradient then
				UIGradient.Color = youtGradient(p12)
			end
		end
	end

	if _uicStroke then
		_uicStroke.Color = p12
	end

	if _uicAvatarStroke then
		_uicAvatarStroke.Color = p12
	end

	if _uicHandle then
		_uicHandle.TextColor3 = p12
	end

	if _uicLine then
		_uicLine.BackgroundColor3 = p12
	end

	local function v63(p13)
		for _, descendant in ipairs(p13:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				if descendant.Text:find("discord.gg") then
					descendant.TextColor3 = p12

					if descendant:IsA("UIStroke") and descendant.Color == Color3.fromRGB(180, 180, 190) then
						descendant.Color = p12
					end

					continue
				elseif descendant.Text:find("Speed") or descendant.Name == "DiscordText" or descendant.Name == "BloodHoundsSpeedIndicator" then
					descendant.TextColor3 = p12

					if descendant:IsA("UIStroke") and descendant.Color == Color3.fromRGB(180, 180, 190) then
						descendant.Color = p12
					end

					continue
				elseif descendant.Text:find("FPS") then
					descendant.TextColor3 = p12
				end
			end

			if descendant:IsA("UIStroke") and descendant.Color == Color3.fromRGB(180, 180, 190) then
				descendant.Color = p12
			end
		end
	end

	if gui then
		v63(gui)
	end

	local PlayerGui = LocalPlayer2:FindFirstChild("PlayerGui")

	PlayerGui = PlayerGui and LocalPlayer2.PlayerGui:FindFirstChild("StealBarGui")

	if PlayerGui then
		v63(PlayerGui)
	end

	if tpBatFloatingButton then
		paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
	end

	if batV2FloatingButton then
		paintFloatingBtn(batV2FloatingButton:FindFirstChild("Frame"), autoBatV2Enabled)
	end

	local tabButtons_ = tabButtons or {}

	for _, v in ipairs(tabButtons_) do
		if v:FindFirstChild("Underline") and v.Underline.Visible then
			v.TextColor3 = Color3.fromRGB(245, 245, 255)
			v.BackgroundColor3 = p12
			v.BackgroundTransparency = 0.15

			local TabBgGrad = v:FindFirstChild("TabBgGrad")

			if TabBgGrad then
				TabBgGrad.Color = youtGradient(p12)
			end
		else
			v.TextColor3 = Color3.fromRGB(150, 150, 165)
			v.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
			v.BackgroundTransparency = 1
		end

		local Underline = v:FindFirstChild("Underline")

		if Underline then
			Underline.BackgroundColor3 = p12
		end

		local TabStroke = v:FindFirstChild("TabStroke")

		if TabStroke then
			TabStroke.Color = p12
		end
	end

	for _, v in pairs(espHighlightCache) do
		if v then
			v.FillColor = p12
			v.OutlineColor = p12
		end
	end

	for _, v in pairs(espTracerCache) do
		if v then
			for _, v3 in ipairs(v) do
				if v3 then
					v3.Color = p12
				end
			end
		end
	end

	if main then
		local Frame = main:FindFirstChild("Frame")

		if Frame then
			for _, descendant in ipairs(Frame:GetDescendants()) do
				if descendant:IsA("UIStroke") and descendant.Color == Color3.fromRGB(180, 180, 190) then
					descendant.Color = p12
				end
			end
		end
	end

	if colorSelectorLabel then
		colorSelectorLabel.Text = currentColorTheme
		colorSelectorLabel.TextColor3 = p12
	end

	if _G._youtStealSlide then
		_G._youtStealSlide.BackgroundColor3 = p12

		local UIGradient = _G._youtStealSlide:FindFirstChildOfClass("UIGradient")

		if UIGradient then
			UIGradient.Color = youtGradient(p12)
		end

		local UIStroke = _G._youtStealSlide:FindFirstChildOfClass("UIStroke")

		if UIStroke then
			UIStroke.Color = p12
		end
	end

	if _G._youtTpBatSlide then
		_G._youtTpBatSlide.BackgroundColor3 = p12

		local UIGradient = _G._youtTpBatSlide:FindFirstChildOfClass("UIGradient")

		if UIGradient then
			UIGradient.Color = youtGradient(p12)
		end

		local UIStroke = _G._youtTpBatSlide:FindFirstChildOfClass("UIStroke")

		if UIStroke then
			UIStroke.Color = p12
		end
	end

	if miniBtn then
		local UIStroke = miniBtn:FindFirstChildOfClass("UIStroke")

		if UIStroke then
			UIStroke.Color = p12
		end
	end

	if MobilePanel then
		for _, child in ipairs(MobilePanel:GetChildren()) do
			if child:IsA("TextButton") and child:FindFirstChild("BtnGrad") then
				paintFloatingBtn(child, child:GetAttribute("MobActive") == true)
			end
		end
	end
end

local t3 = {
	body = {
		10725826963,
		86500008,
		86500054,
		86500036,
		86500064,
		86500078
	},
	aplicarCuerpo = true
}

t3.items = {
	{
		id = 103227869700418,
		offset = CFrame.new(0, 0, 0)
	},
	{
		id = 84952305140948,
		offset = CFrame.new(0, 0, 0)
	},
	{
		id = 122465238537030,
		offset = CFrame.new(0, 0, 0)
	}
}
t3.shirt = nil
t3.pants = "rbxassetid://78591690208112"
t3.skinColor = Color3.fromRGB(234, 184, 146)
t3.headColor = Color3.fromRGB(0, 0, 0)

local function v90(p14)
	local ok, result = pcall(function()
		return game:GetObjects("rbxassetid://" .. tostring(p14))
	end)

	if ok and typeof(result) == "table" and #result > 0 then
		return result
	end

	local ok2, result2 = pcall(function()
		return game:GetService("InsertService"):LoadAsset(p14)
	end)

	if ok2 and result2 then
		return { result2 }
	end

	return nil
end
local function v95(p15)
	local t4 = {}

	for _, v in ipairs(p15) do
		if v:IsA("BasePart") then
			t4[#t4 + 1] = v
		end

		for _, descendant in ipairs(v:GetDescendants()) do
			if descendant:IsA("BasePart") then
				t4[#t4 + 1] = descendant
			end
		end
	end

	return t4
end
local function v101(p16, p17)
	for _, descendant in ipairs(p16:GetDescendants()) do
		if descendant:IsA("Attachment") and descendant.Name == p17 then
			if descendant.Parent:IsA("BasePart") then
				return descendant
			end
		end
	end
end
local function v104(p18)
	local n3 = 0

	for _, v in ipairs(t3.body) do
		local v108 = v90(v)

		if v108 then
			for _, v3 in ipairs(v95(v108)) do
				local v111 = p18:FindFirstChild(v3.Name)

				if v111 and v111:IsA("BasePart") then
					local clone = v3:Clone()

					clone.Name = "LocalOutfit_" .. "body_" .. v3.Name
					clone.CanCollide = false
					clone.Anchored = false
					clone.Massless = true
					clone.Size = v111.Size
					clone.CFrame = v111.CFrame
					clone.Parent = p18

					local WeldConstraint = Instance.new("WeldConstraint")

					WeldConstraint.Part0 = v111
					WeldConstraint.Part1 = clone
					WeldConstraint.Parent = clone

					if v111:GetAttribute("YoutOutfitOriginalTransparency") == nil then
						v111:SetAttribute("YoutOutfitOriginalTransparency", v111.Transparency)
					end

					v111.Transparency = 1
					n3 += 1
				end
			end

			for _, v3 in ipairs(v108) do
				pcall(function()
					v3:Destroy()
				end)
			end
		end
	end

	return n3
end
local function v116(p19, p20)
	local v117 = v90(p20.id)

	if not v117 then
		return false
	end

	local v118

	for _, v in ipairs(v95(v117)) do
		if v.Name == "Handle" then
			v118 = v

			break
		else
			v118 = v118 or v
		end
	end

	if not v118 then
		for _, v in ipairs(v117) do
			pcall(function()
				v:Destroy()
			end)
		end

		return false
	end

	local clone = v118:Clone()

	for _, v in ipairs(v117) do
		pcall(function()
			v:Destroy()
		end)
	end

	clone.Name = "LocalOutfit_" .. "item_" .. tostring(p20.id)
	clone.CanCollide = false
	clone.Anchored = false
	clone.Massless = true

	local HumanoidRootPart, offset, cFrame

	if clone:FindFirstChildWhichIsA("WrapLayer") then
		local UpperTorso = p19:FindFirstChild("UpperTorso") or p19:FindFirstChild("Torso")

		HumanoidRootPart = UpperTorso or p19:FindFirstChild("HumanoidRootPart")
		offset = p20.offset or CFrame.new()
		cFrame = CFrame.new()
	else
		local Attachment = clone:FindFirstChildOfClass("Attachment")
		local v131 = Attachment and v101(p19, Attachment.Name)

		if v131 then
			HumanoidRootPart = v131.Parent
			offset = v131.CFrame * (p20.offset or CFrame.new())
			cFrame = Attachment.CFrame
		else
			HumanoidRootPart = p19:FindFirstChild("Head")
			offset = p20.offset or CFrame.new(0, 1.4, 0)
			cFrame = CFrame.new()
		end
	end

	if not HumanoidRootPart then
		clone:Destroy()

		return false
	end

	clone.CFrame = HumanoidRootPart.CFrame * offset * cFrame:Inverse()
	clone.Parent = p19

	local Weld = Instance.new("Weld")

	Weld.Part0 = HumanoidRootPart
	Weld.Part1 = clone
	Weld.C0 = offset
	Weld.C1 = cFrame
	Weld.Parent = clone

	return true
end

applyHomeroOutfit = function(p21)
	local Character = p21 or LocalPlayer2.Character

	if not Character then
		return
	end

	Character:WaitForChild("Humanoid", 10)
	Character:WaitForChild("Head", 10)
	task.wait(0.4)

	for _, child in ipairs(Character:GetChildren()) do
		if child.Name:sub(1, 12) == "LocalOutfit_" then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	if t3.skinColor then
		local BodyColors = Character:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")

		BodyColors.HeadColor3 = t3.headColor or t3.skinColor
		BodyColors.TorsoColor3 = t3.skinColor

		local skinColor = t3.skinColor

		BodyColors.LeftArmColor3 = t3.skinColor
		BodyColors.RightArmColor3 = skinColor

		local skinColor2 = t3.skinColor

		BodyColors.LeftLegColor3 = t3.skinColor
		BodyColors.RightLegColor3 = skinColor2
		BodyColors.Parent = Character
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Accessory") then
			local Handle = child:FindFirstChild("Handle")

			if Handle then
				Handle.Transparency = 1
			end
		end
	end

	if t3.shirt then
		local Shirt = Character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")

		Shirt.Name = "Shirt"
		Shirt.ShirtTemplate = t3.shirt
		Shirt.Parent = Character
	end

	if t3.pants then
		local Pants = Character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")

		Pants.Name = "Pants"
		Pants.PantsTemplate = t3.pants
		Pants.Parent = Character
	end

	if t3.aplicarCuerpo then
		v104(Character)
	end

	for _, item in ipairs(t3.items) do
		v116(Character, item)
	end
end

local u146

local function v147(p22)
	if not p22 or u146 then
		return
	end

	local t5 = {
		bodyColors = nil,
		shirt = nil,
		pants = nil,
		headMesh = nil,
		headTexture = nil
	}
	local BodyColors = p22:FindFirstChildWhichIsA("BodyColors")

	if BodyColors then
		t5.bodyColors = {
			head = BodyColors.HeadColor3,
			torso = BodyColors.TorsoColor3,
			leftArm = BodyColors.LeftArmColor3,
			rightArm = BodyColors.RightArmColor3,
			leftLeg = BodyColors.LeftLegColor3,
			rightLeg = BodyColors.RightLegColor3
		}
	end

	local Shirt = p22:FindFirstChildWhichIsA("Shirt")

	if Shirt then
		t5.shirt = Shirt.ShirtTemplate
	end

	local Pants = p22:FindFirstChildWhichIsA("Pants")

	if Pants then
		t5.pants = Pants.PantsTemplate
	end

	local Head = p22:FindFirstChild("Head")

	if Head then
		local SpecialMesh = Head:FindFirstChildWhichIsA("SpecialMesh")

		if SpecialMesh and SpecialMesh.MeshType == Enum.MeshType.FileMesh then
			t5.headMesh = SpecialMesh.MeshId
			t5.headTexture = SpecialMesh.TextureId
		end
	end

	u146 = t5
end
local function v154(p23)
	if not p23 then
		return
	end

	for _, child in ipairs(p23:GetChildren()) do
		if child.Name:sub(1, 12) == "LocalOutfit_" or child.Name == "AuFfitAccessory" or child.Name == "Korblox_RightLeg" then
			pcall(function()
				child:Destroy()
			end)
		elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	for _, descendant in ipairs(p23:GetDescendants()) do
		if descendant:IsA("BasePart") then
			local attribute = descendant:GetAttribute("YoutOutfitOriginalTransparency")

			if attribute ~= nil then
				descendant.Transparency = attribute
				descendant:SetAttribute("YoutOutfitOriginalTransparency", nil)
			end

			local attribute2 = descendant:GetAttribute("YoutOutfitOriginalLocalTransparency")

			if attribute2 ~= nil then
				descendant.LocalTransparencyModifier = attribute2
				descendant:SetAttribute("YoutOutfitOriginalLocalTransparency", nil)
			end
		end
	end

	if u146 and u146.bodyColors then
		local BodyColors = p23:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
		local bodyColors = u146.bodyColors
		local torso = bodyColors.torso

		BodyColors.HeadColor3 = bodyColors.head
		BodyColors.TorsoColor3 = torso

		local rightArm = bodyColors.rightArm

		BodyColors.LeftArmColor3 = bodyColors.leftArm
		BodyColors.RightArmColor3 = rightArm

		local rightLeg = bodyColors.rightLeg

		BodyColors.LeftLegColor3 = bodyColors.leftLeg
		BodyColors.RightLegColor3 = rightLeg
		BodyColors.Parent = p23
	end

	local Head = p23:FindFirstChild("Head")

	if Head and Head:IsA("MeshPart") and Head:GetAttribute("YoutOutfitModifiedMeshPart") then
		pcall(function()
			Head.MeshId = Head:GetAttribute("YoutOutfitOriginalMeshId") or ""
			Head.TextureID = Head:GetAttribute("YoutOutfitOriginalTextureId") or ""
		end)
		Head:SetAttribute("YoutOutfitModifiedMeshPart", nil)
		Head:SetAttribute("YoutOutfitOriginalMeshId", nil)
		Head:SetAttribute("YoutOutfitOriginalTextureId", nil)
	elseif Head then
		local SpecialMesh = Head:FindFirstChildWhichIsA("SpecialMesh")

		if SpecialMesh and SpecialMesh:GetAttribute("YoutOutfitCreatedMesh") then
			SpecialMesh:Destroy()
		elseif SpecialMesh and SpecialMesh:GetAttribute("YoutOutfitModifiedMesh") then
			SpecialMesh.MeshId = SpecialMesh:GetAttribute("YoutOutfitOriginalMeshId") or ""
			SpecialMesh.TextureId = SpecialMesh:GetAttribute("YoutOutfitOriginalTextureId") or ""
			SpecialMesh:SetAttribute("YoutOutfitModifiedMesh", nil)
			SpecialMesh:SetAttribute("YoutOutfitOriginalMeshId", nil)
			SpecialMesh:SetAttribute("YoutOutfitOriginalTextureId", nil)
		end
	end
end
local function v168(p24)
	local Character = p24 or LocalPlayer2.Character

	if not Character then
		return
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child.Name:sub(1, 12) == "LocalOutfit_" then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	local AuFfitAccessory = Character:FindFirstChild("AuFfitAccessory")

	if AuFfitAccessory then
		pcall(function()
			AuFfitAccessory:Destroy()
		end)
	end

	local Korblox_RightLeg = Character:FindFirstChild("Korblox_RightLeg")

	if Korblox_RightLeg then
		pcall(function()
			Korblox_RightLeg:Destroy()
		end)
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	local Head = Character:FindFirstChild("Head")

	if Head then
		Head.Transparency = 0
		Head.CanCollide = true
		Head.LocalTransparencyModifier = 0

		local face = Head:FindFirstChild("face")

		if face then
			face.Transparency = 0
		end

		local SpecialMesh = Head:FindFirstChildWhichIsA("SpecialMesh")

		if SpecialMesh then
			if u146 and u146.headMesh then
				SpecialMesh.MeshId = u146.headMesh
				SpecialMesh.TextureId = u146.headTexture or ""
			else
				pcall(function()
					SpecialMesh:Destroy()
				end)
			end
		end
	end

	pcall(function()
		local Neck = Character:FindFirstChild("Neck")

		if Neck then
			Neck.Enabled = true
		end
	end)

	for _, v in ipairs({
		"RightUpperLeg",
		"RightLowerLeg",
		"RightFoot"
	}) do
		local v182 = Character:FindFirstChild(v)

		if v182 then
			v182.Transparency = 0
		end
	end

	if u146 and u146.bodyColors then
		local BodyColors = Character:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
		local bodyColors = u146.bodyColors

		BodyColors.HeadColor3 = bodyColors.head
		BodyColors.TorsoColor3 = bodyColors.torso
		BodyColors.LeftArmColor3 = bodyColors.leftArm
		BodyColors.RightArmColor3 = bodyColors.rightArm
		BodyColors.LeftLegColor3 = bodyColors.leftLeg
		BodyColors.RightLegColor3 = bodyColors.rightLeg
		BodyColors.Parent = Character
	end

	if u146 and u146.shirt then
		local Shirt = Character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")

		Shirt.ShirtTemplate = u146.shirt
		Shirt.Parent = Character
	end

	if u146 and u146.pants then
		local Pants = Character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")

		Pants.PantsTemplate = u146.pants
		Pants.Parent = Character
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Accessory") then
			local Handle = child:FindFirstChild("Handle")

			if Handle then
				Handle.Transparency = 0
			end
		end
	end
end

local t6 = {
	{
		label = "OFF",
		customApply = v168
	},
	{
		accessory = 10159600649,
		offset = Vector3.new(0, 1, -0.2),
		shirt = "http://www.roblox.com/asset/?id=9683332638",
		pants = "http://www.roblox.com/asset/?id=93182020184041",
		headMesh = "http://www.roblox.com/asset/?id=134079402",
		headTexture = "http://www.roblox.com/asset/?id=133940918 ",
		korblox = "none",
		label = "Outfit 1",
		headlessKorblox = true
	},
	{
		accessory = 1744060292,
		offset = Vector3.new(0, 1.3, -0.2),
		shirt = "http://www.roblox.com/asset/?id=9683332638",
		pants = "http://www.roblox.com/asset/?id=93182020184041",
		headMesh = "http://www.roblox.com/asset/?id=134079402",
		headTexture = "http://www.roblox.com/asset/?id=133940918 ",
		korblox = "none",
		label = "Outfit 2",
		headlessKorblox = true
	},
	{
		accessory = 8349240186,
		offset = Vector3.new(0, 0.9, 0),
		shirt = "http://www.roblox.com/asset/?id=11926549070",
		pants = "http://www.roblox.com/asset/?id=13189494471",
		headMesh = "https://assetdelivery.roblox.com/v1/asset/?id=16673245747",
		headTexture = nil,
		korblox = "none",
		label = "Outfit 3",
		headlessKorblox = true
	},
	{
		accessory = 121097973925756,
		offset = Vector3.new(0, 0.9, 0),
		shirt = "http://www.roblox.com/asset/?id=123181702116947",
		pants = "http://www.roblox.com/asset/?id=93330291631062",
		headMesh = "http://www.roblox.com/asset/?id=134079402",
		headTexture = "http://www.roblox.com/asset/?id=133940918 ",
		korblox = "none",
		label = "Outfit 4",
		headlessKorblox = true
	},
	{
		label = "Homero Chino",
		customApply = applyHomeroOutfit
	}
}
local outfitIndex = 1
local TextLabel

local function v193(p25)
	local ok, result = pcall(function()
		return game:GetObjects("rbxassetid://" .. tostring(p25))
	end)

	if ok and typeof(result) == "table" and #result > 0 then
		return result
	end

	local ok2, result2 = pcall(function()
		return game:GetService("InsertService"):LoadAsset(p25)
	end)

	if ok2 and result2 then
		return { result2 }
	end

	return nil
end
local function v198(p26)
	if not p26 then
		return
	end

	pcall(function()
		LocalPlayer2.CharacterAvatarType = Enum.AvatarType.R6
	end)

	local Head = p26:FindFirstChild("Head")

	if Head then
		if Head:GetAttribute("YoutOutfitOriginalTransparency") == nil then
			Head:SetAttribute("YoutOutfitOriginalTransparency", Head.Transparency)
			Head:SetAttribute("YoutOutfitOriginalLocalTransparency", Head.LocalTransparencyModifier)
		end

		Head.Transparency = 1
		Head.CanCollide = false
		Head.LocalTransparencyModifier = 1

		local face = Head:FindFirstChild("face")

		if face then
			face.Transparency = 1
		end
	end

	pcall(function()
		local Neck = p26:FindFirstChild("Neck")

		if Neck then
			Neck.Enabled = false
		end
	end)

	for _, child in pairs(p26:GetChildren()) do
		if child:IsA("Accessory") then
			local Weld = child:FindFirstChildWhichIsA("Weld") or child:FindFirstChildWhichIsA("WeldConstraint") or child:FindFirstChildWhichIsA("Motor6D")

			if Weld then
				local Part0 = Weld.Part0
				local Part1 = Weld.Part1

				if Part0 and Part0.Name == "Head" or Part1 and Part1.Name == "Head" then
					for _, descendant in ipairs(child:GetDescendants()) do
						if descendant:IsA("BasePart") then
							if descendant:GetAttribute("YoutOutfitOriginalTransparency") == nil then
								descendant:SetAttribute("YoutOutfitOriginalTransparency", descendant.Transparency)
								descendant:SetAttribute("YoutOutfitOriginalLocalTransparency", descendant.LocalTransparencyModifier)
							end

							descendant.Transparency = 1
							descendant.LocalTransparencyModifier = 1
						end
					end
				end
			end
		end
	end

	local t7 = {
		id = "rbxassetid://139607718",
		targetBodyPart = "RightUpperLeg",
		partsToHide = {
			"RightUpperLeg",
			"RightLowerLeg",
			"RightFoot"
		},
		scale = Vector3.new(1, 1, 1),
		offset = CFrame.new(0, 0, 0)
	}
	local v210 = p26:FindFirstChild(t7.targetBodyPart)

	if v210 then
		local Korblox_RightLeg = p26:FindFirstChild("Korblox_RightLeg")

		if Korblox_RightLeg then
			Korblox_RightLeg:Destroy()
		end

		for _, v in ipairs(t7.partsToHide) do
			local v214 = p26:FindFirstChild(v)

			if v214 and v214:IsA("BasePart") then
				if v214:GetAttribute("YoutOutfitOriginalTransparency") == nil then
					v214:SetAttribute("YoutOutfitOriginalTransparency", v214.Transparency)
				end

				v214.Transparency = 1
			end
		end

		local ok, result = pcall(function()
			return game:GetObjects(t7.id)
		end)

		if ok and result and #result > 0 then
			local v217 = result[1]

			v217.Name = "Korblox_RightLeg"

			local isBasePart = v217:IsA("BasePart") and v217 or v217:FindFirstChildWhichIsA("BasePart", true)

			if isBasePart then
				isBasePart.Size *= t7.scale
				isBasePart.CanCollide = false
				isBasePart.CFrame = v210.CFrame * t7.offset

				local WeldConstraint = Instance.new("WeldConstraint")

				WeldConstraint.Part0 = v210
				WeldConstraint.Part1 = isBasePart
				WeldConstraint.Parent = isBasePart
				v217.Parent = p26
			end
		end
	end
end

applyOutfitByIndex = function(p27)
	local v220 = t6[p27]

	if not v220 then
		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	v154(Character)

	if v220.customApply then
		v220.customApply(Character)

		if TextLabel then
			TextLabel.Text = v220.label
		end

		return
	end

	Character:WaitForChild("Head", 5)

	local Head = Character:FindFirstChild("Head")

	if not Head then
		return
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	local v225 = false

	if Head:IsA("MeshPart") then
		v225 = pcall(function()
			if not Head:GetAttribute("YoutOutfitModifiedMeshPart") then
				Head:SetAttribute("YoutOutfitOriginalMeshId", Head.MeshId)
				Head:SetAttribute("YoutOutfitOriginalTextureId", Head.TextureID)
				Head:SetAttribute("YoutOutfitModifiedMeshPart", true)
			end

			Head.MeshId = v220.headMesh
			Head.TextureID = v220.headTexture or ""
		end)
	end

	if not v225 then
		local SpecialMesh = Head:FindFirstChildWhichIsA("SpecialMesh")

		if SpecialMesh then
			if not SpecialMesh:GetAttribute("YoutOutfitModifiedMesh") then
				SpecialMesh:SetAttribute("YoutOutfitOriginalMeshId", SpecialMesh.MeshId)
				SpecialMesh:SetAttribute("YoutOutfitOriginalTextureId", SpecialMesh.TextureId)
				SpecialMesh:SetAttribute("YoutOutfitModifiedMesh", true)
			end
		else
			SpecialMesh = Instance.new("SpecialMesh")
			SpecialMesh:SetAttribute("YoutOutfitCreatedMesh", true)
		end

		SpecialMesh.Parent = Head
		SpecialMesh.MeshType = Enum.MeshType.FileMesh
		SpecialMesh.MeshId = v220.headMesh
		SpecialMesh.TextureId = v220.headTexture or ""
	end

	if v220.shirt then
		local Shirt = Character:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")

		Shirt.Name = "Shirt"
		Shirt.ShirtTemplate = v220.shirt
		Shirt.Parent = Character
	end

	if v220.pants then
		local Pants = Character:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")

		Pants.Name = "Pants"
		Pants.PantsTemplate = v220.pants
		Pants.Parent = Character
	end

	local AuFfitAccessory = Character:FindFirstChild("AuFfitAccessory")

	if AuFfitAccessory then
		AuFfitAccessory:Destroy()
	end

	if v220.accessory then
		local v230 = v193(v220.accessory)

		if v230 then
			local v231

			for _, v in ipairs(v230) do
				if v:IsA("BasePart") then
					v231 = v

					break
				end

				local BasePart = v:FindFirstChildWhichIsA("BasePart", true)

				if BasePart then
					v231 = BasePart

					break
				end
			end

			if v231 then
				local clone = v231:Clone()

				clone.Name = "AuFfitAccessory"
				clone.CanCollide = false
				clone.Anchored = false
				clone.Massless = true
				clone.Parent = Character

				local Weld = Instance.new("Weld")

				Weld.Part0 = Head
				Weld.Part1 = clone
				Weld.C0 = CFrame.new(v220.offset)
				Weld.Parent = clone
			end

			for _, v in ipairs(v230) do
				pcall(function()
					v:Destroy()
				end)
			end
		end
	end

	if v220.headlessKorblox then
		v198(Character)
	else
		local Head2 = Character:FindFirstChild("Head")

		if Head2 then
			Head2.Transparency = 0
			Head2.CanCollide = true
			Head2.LocalTransparencyModifier = 0

			local face = Head2:FindFirstChild("face")

			if face then
				face.Transparency = 0
			end
		end

		pcall(function()
			local Neck = Character:FindFirstChild("Neck")

			if Neck then
				Neck.Enabled = true
			end
		end)

		for _, v in ipairs({
			"RightUpperLeg",
			"RightLowerLeg",
			"RightFoot"
		}) do
			local v244 = Character:FindFirstChild(v)

			if v244 then
				v244.Transparency = 0
			end
		end

		local Korblox_RightLeg = Character:FindFirstChild("Korblox_RightLeg")

		if Korblox_RightLeg then
			Korblox_RightLeg:Destroy()
		end
	end

	if TextLabel then
		TextLabel.Text = v220.label
	end
end
selectedStealMode = "V1"
_G._youtStealRadiusV1 = 61
_G._youtStealRadiusV2 = 60
_G._youtStealRadiusV3 = 63
autoCarrySpeedEnabled = false
autoCarrySetVisual = nil
_youtAutoCarryState = {
	applied = false,
	waiting = false,
	watchUntil = 0,
	graceUntil = 0,
	savedMode = nil,
	stealWasActive = false
}
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
autoTPLastRun = 0
autoTPSetVisual = nil
speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
mobileButtonsLocked = false
uiScaleValue = 78
espEnabled = false
antiDesyncEnabled = false
antiDesyncFakeRoot = nil
antiDesyncRepRootOwner = nil
antiDesyncStepConn = nil
antiDesyncAntiBatConn = nil
antiDesyncFreezeConn = nil
antiDesyncFlingConn = nil
antiDesyncAntiResetHealthConn = nil
antiDesyncAntiResetCFrameConn = nil
antiDesyncLastSafeCFrame = nil
antiDesyncLastCheckTime = 0
ANTI_DESYNC_FAKE_ROOT_NAME = "DavidDesyncRoot"
ANTI_DESYNC_FAKE_ROOT_Y = -1000
ANTI_DESYNC_FAKE_ROOT_VELOCITY = Vector3.new(0, -1000, 0)
ANTI_DESYNC_RANGE = 5
vividGraphicsEnabled = false
_vividEffects = {}
setVividVisual = nil
hideButtonsEnabled = false
setHideButtonsVisual = nil
bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false
savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil
neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil
currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil
lastMoveDir = Vector3.zero
game:GetService("CoreGui")

local t8 = {
	enabled = false,
	jumpPower = 55,
	minVelocity = 35,
	fallClamp = -120,
	jumpConn = nil,
	heartbeatConn = nil
}

local function v247(p28)
	if p28 then
		pcall(function()
			p28.Velocity = Vector3.new(p28.Velocity.X, t8.jumpPower, p28.Velocity.Z)
		end)

		return
	end
end
local function v248()
	if not t8.enabled then
		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		v247(HumanoidRootPart)
	end
end
local function v251()
	if not t8.enabled then
		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	if (UserInputService:IsKeyDown(Enum.KeyCode.Space) or Humanoid.Jump == true) and HumanoidRootPart.Velocity.Y < t8.minVelocity then
		v247(HumanoidRootPart)
	end

	if HumanoidRootPart.Velocity.Y < t8.fallClamp then
		HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, t8.fallClamp, HumanoidRootPart.Velocity.Z)
	end
end
local function v255()
	if t8.jumpConn then
		t8.jumpConn:Disconnect()
	end

	if t8.heartbeatConn then
		t8.heartbeatConn:Disconnect()
	end

	t8.jumpConn = UserInputService.JumpRequest:Connect(v248)
	t8.heartbeatConn = RunService.Heartbeat:Connect(v251)
end

t8.start = function()
	if t8.enabled then
		return
	end

	t8.enabled = true
	v255()
end
t8.stop = function()
	t8.enabled = false

	if t8.jumpConn then
		t8.jumpConn:Disconnect()
		t8.jumpConn = nil
	end

	if t8.heartbeatConn then
		t8.heartbeatConn:Disconnect()
		t8.heartbeatConn = nil
	end
end
t8.setJumpPower = function(p29)
	t8.jumpPower = math.clamp(tonumber(p29) or 55, 10, 200)
end
t8.isRunning = function()
	return t8.enabled == true
end
t8.start()
getActiveMoveSpeed = function()
	if laggerCarryToggled then
		return LAGGER_CARRY_SPEED
	end

	if laggerToggled then
		return LAGGER_SPEED
	end

	if speedMode then
		return CS
	end

	return NS
end
getSpeedModeName = function()
	if laggerToggled or laggerCarryToggled then
		return "LAGGER"
	end

	if speedMode then
		return "CARRY"
	end

	return "NORMAL"
end

local t9 = {}
local t10 = {}

local function v258(p30)
	t9 = {}

	if not p30 then
		return
	end

	local HumanoidRootPart = p30:WaitForChild("HumanoidRootPart", 5)

	if HumanoidRootPart then
		t9[HumanoidRootPart] = true
	end

	return HumanoidRootPart
end

local u260

local function v261(p31)
	if not p31 or t10[p31] then
		return
	end

	if u260 == false then
		return
	end

	if u260 == nil then
		u260 = type(getrawmetatable) == "function" and type(setreadonly) == "function" and type(newcclosure) == "function" and type(checkcaller) == "function"
	end

	if not u260 then
		return
	end

	t10[p31] = true

	if not pcall(function()
		local v262 = getrawmetatable(p31)

		if not v262 then
			return
		end

		setreadonly(v262, false)

		local value = rawget(v262, "__index")

		v262.__index = newcclosure(function(p32, p33)
			if not checkcaller() and t9[p32] then
				if p33 == "AssemblyLinearVelocity" or p33 == "Velocity" then
					local v264

					if type(value) == "function" then
						v264 = value(p32, p33)
					elseif type(value) == "table" then
						v264 = value[p33]
					end

					if v264 and v264.Magnitude > 20 then
						return v264.Unit * 20
					end

					return v264
				end
			end

			if type(value) == "function" then
				return value(p32, p33)
			end

			if type(value) == "table" then
				return value[p33]
			end
		end)
		setreadonly(v262, true)
	end) then
		u260 = false
	end
end

if LocalPlayer2.Character then
	local v265 = v258(LocalPlayer2.Character)

	v261(v265)
end

local function v266(p34)
	if not p34 then
		return true
	end

	local state = p34:GetState()

	return p34.PlatformStand or state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end
local function v268(p35, p36, p37)
	if not p37 or not p37.Parent then
		return
	end

	if batDesyncTpEnabled or autoBatEnabled or autoBatV2Enabled then
		return
	end

	if p35 and p35.Magnitude > 0.05 then
		pcall(function()
			if p37.SetNetworkOwner then
				p37:SetNetworkOwner(LocalPlayer2)
			end
		end)

		local Unit = p35.Unit

		p37.AssemblyLinearVelocity = Vector3.new(Unit.X * p36, p37.AssemblyLinearVelocity.Y, Unit.Z * p36)
	else
		p37.AssemblyLinearVelocity = Vector3.new(0, p37.AssemblyLinearVelocity.Y, 0)
	end
end

getAutoPathSpeed = function()
	if laggerCarryToggled or laggerToggled then
		return LAGGER_SPEED
	end

	return NS
end
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
		swimidle = "rbxassetid://616166655"
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
		swimidle = "rbxassetid://656117400"
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
		swimidle = "rbxassetid://657595757"
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
		swimidle = "rbxassetid://845397899"
	},
	Levitate = {
		idle1 = "rbxassetid://616006778",
		idle2 = "rbxassetid://616006778",
		walk = "rbxassetid://616013216",
		run = "rbxassetid://616013216",
		jump = "rbxassetid://616008936",
		fall = "rbxassetid://616005863",
		climb = "rbxassetid://616003713",
		swim = "rbxassetid://616006778",
		swimidle = "rbxassetid://616006778"
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
		swimidle = "rbxassetid://891621366"
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
		swimidle = "rbxassetid://750781874"
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
		swimidle = "rbxassetid://782841498"
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
		swimidle = "rbxassetid://1083445855"
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
		swimidle = "rbxassetid://1083195517"
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
		swimidle = "rbxassetid://2510196951"
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
		swimidle = "rbxassetid://616136790"
	}
}
ANIM_PACK_ORDER = {
	{
		"Off",
		"Off"
	},
	{
		"Zombie",
		"Zombie"
	},
	{
		"Ninja",
		"Ninja"
	},
	{
		"Knight",
		"Knight"
	},
	{
		"Elder",
		"Elder"
	},
	{
		"Levitate",
		"Levitate"
	},
	{
		"Astronaut",
		"Astronaut"
	},
	{
		"Pirate",
		"Pirate"
	},
	{
		"Toy",
		"Toy"
	},
	{
		"Vampire",
		"Vampire"
	},
	{
		"Werewolf",
		"Werewolf"
	},
	{
		"Rthro",
		"Rthro"
	},
	{
		"Stylish",
		"Stylish"
	}
}

local function v270(p38)
	for _, v in pairs(ANIM_PACKS) do
		for _, v3 in pairs(v) do
			if v3 == p38 then
				return true
			end
		end
	end

	return false
end
local function v275(p39)
	local Animate = p39:FindFirstChild("Animate")

	if not Animate then
		return
	end

	local function v277(p40)
		return p40 and p40.AnimationId or nil
	end

	local t11 = {
		idle1 = v277(Animate.idle and Animate.idle.Animation1),
		idle2 = v277(Animate.idle and Animate.idle.Animation2),
		walk = v277(Animate.walk and Animate.walk.WalkAnim),
		run = v277(Animate.run and Animate.run.RunAnim),
		jump = v277(Animate.jump and Animate.jump.JumpAnim),
		fall = v277(Animate.fall and Animate.fall.FallAnim),
		climb = v277(Animate.climb and Animate.climb.ClimbAnim),
		swim = v277(Animate.swim and Animate.swim.Swim),
		swimidle = v277(Animate.swimidle and Animate.swimidle.SwimIdle)
	}

	if not v270(t11.walk) then
		originalTryardAnims = t11
	end
end
local function v279(p41)
	currentAnimPack = p41

	if animSelectorLabel then
		animSelectorLabel.Text = p41
	end

	if p41 ~= "Off" then
		local v280 = ANIM_PACKS[p41]

		if not v280 then
			return
		end

		if tryardHeartbeatConn then
			tryardHeartbeatConn:Disconnect()
		end

		tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
			local Character = LocalPlayer2.Character

			if not Character then
				return
			end

			local Animate = Character:FindFirstChild("Animate")

			if not Animate then
				return
			end

			local function v283(p42, p43)
				if p42 then
					p42.AnimationId = p43
				end
			end

			v283(Animate.idle and Animate.idle.Animation1, v280.idle1)
			v283(Animate.idle and Animate.idle.Animation2, v280.idle2)
			v283(Animate.walk and Animate.walk.WalkAnim, v280.walk)
			v283(Animate.run and Animate.run.RunAnim, v280.run)
			v283(Animate.jump and Animate.jump.JumpAnim, v280.jump)
			v283(Animate.fall and Animate.fall.FallAnim, v280.fall)
			v283(Animate.climb and Animate.climb.ClimbAnim, v280.climb)
			v283(Animate.swim and Animate.swim.Swim, v280.swim)
			v283(Animate.swimidle and Animate.swimidle.SwimIdle, v280.swimidle)
		end)

		return
	end

	if originalTryardAnims and LocalPlayer2.Character then
		local Animate = LocalPlayer2.Character:FindFirstChild("Animate")

		if Animate then
			local function v285(p44, p45)
				if p44 then
					p44.AnimationId = p45
				end
			end

			v285(Animate.idle and Animate.idle.Animation1, originalTryardAnims.idle1)
			v285(Animate.idle and Animate.idle.Animation2, originalTryardAnims.idle2)
			v285(Animate.walk and Animate.walk.WalkAnim, originalTryardAnims.walk)
			v285(Animate.run and Animate.run.RunAnim, originalTryardAnims.run)
			v285(Animate.jump and Animate.jump.JumpAnim, originalTryardAnims.jump)
			v285(Animate.fall and Animate.fall.FallAnim, originalTryardAnims.fall)
			v285(Animate.climb and Animate.climb.ClimbAnim, originalTryardAnims.climb)
			v285(Animate.swim and Animate.swim.Swim, originalTryardAnims.swim)
			v285(Animate.swimidle and Animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
		end
	end

	if tryardHeartbeatConn then
		tryardHeartbeatConn:Disconnect()
		tryardHeartbeatConn = nil
	end
end
local function v286(p46)
	local Character = LocalPlayer2.Character

	if Character then
		v275(Character)
		v279(p46)

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
				v:Stop(0)
			end

			Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end
	else
		v279(p46)
	end

	currentAnimPack = p46
end
local function v291()
	currentAnimPack = "Off"

	if animSelectorLabel then
		animSelectorLabel.Text = "Off"
	end

	v279("Off")
end

DEFAULT_KB = {
	DropBrainrot = {
		kb = Enum.KeyCode.X,
		gp = nil
	},
	AutoLeft = {
		kb = Enum.KeyCode.Z,
		gp = nil
	},
	AutoRight = {
		kb = Enum.KeyCode.C,
		gp = nil
	},
	AutoBat = {
		kb = Enum.KeyCode.E,
		gp = nil
	},
	TPFloor = {
		kb = Enum.KeyCode.F,
		gp = nil
	},
	GuiHide = {
		kb = Enum.KeyCode.LeftControl,
		gp = nil
	},
	CarryToggle = {
		kb = Enum.KeyCode.Q,
		gp = nil
	},
	LaggerMode = {
		kb = Enum.KeyCode.R,
		gp = nil
	},
	TPBat = {
		kb = Enum.KeyCode.V,
		gp = nil
	},
	BatV2 = {
		kb = Enum.KeyCode.N,
		gp = nil
	},
	InstaReset = {
		kb = Enum.KeyCode.H,
		gp = nil
	},
	AntiDesync = {
		kb = Enum.KeyCode.G,
		gp = nil
	}
}
KB = {
	DropBrainrot = {
		kb = DEFAULT_KB.DropBrainrot.kb,
		gp = DEFAULT_KB.DropBrainrot.gp
	},
	AutoLeft = {
		kb = DEFAULT_KB.AutoLeft.kb,
		gp = DEFAULT_KB.AutoLeft.gp
	},
	AutoRight = {
		kb = DEFAULT_KB.AutoRight.kb,
		gp = DEFAULT_KB.AutoRight.gp
	},
	AutoBat = {
		kb = DEFAULT_KB.AutoBat.kb,
		gp = DEFAULT_KB.AutoBat.gp
	},
	TPFloor = {
		kb = DEFAULT_KB.TPFloor.kb,
		gp = DEFAULT_KB.TPFloor.gp
	},
	GuiHide = {
		kb = DEFAULT_KB.GuiHide.kb,
		gp = DEFAULT_KB.GuiHide.gp
	},
	CarryToggle = {
		kb = DEFAULT_KB.CarryToggle.kb,
		gp = DEFAULT_KB.CarryToggle.gp
	},
	LaggerMode = {
		kb = DEFAULT_KB.LaggerMode.kb,
		gp = DEFAULT_KB.LaggerMode.gp
	},
	TPBat = {
		kb = DEFAULT_KB.TPBat.kb,
		gp = DEFAULT_KB.TPBat.gp
	},
	BatV2 = {
		kb = DEFAULT_KB.BatV2.kb,
		gp = DEFAULT_KB.BatV2.gp
	},
	InstaReset = {
		kb = DEFAULT_KB.InstaReset.kb,
		gp = DEFAULT_KB.InstaReset.gp
	},
	AntiDesync = {
		kb = DEFAULT_KB.AntiDesync.kb,
		gp = DEFAULT_KB.AntiDesync.gp
	}
}
_isResetting = false
_lastSavedJSON = nil
_isLoading = false
CONFIG = {
	AUTO_STEAL_ENABLED = false,
	STEAL_RANGE = 61
}
Workspace:FindFirstChild("Plots")

local connection
local t12 = {
	AutoStealEnabled = false,
	StealRadius = CONFIG.STEAL_RANGE,
	StealDuration = 1.3,
	StealDelay = 0.25,
	Data = {}
}
local u294 = false
local Plots
local n4 = 0

local function v297()
	local now = tick()

	if Plots and now - n4 < 2 and Plots.Parent then
		return Plots
	end

	Plots = workspace:FindFirstChild("Plots")
	n4 = now

	return Plots
end
local function v299(p47)
	local v300 = v297()

	if not v300 then
		return false
	end

	local v301 = v300:FindFirstChild(p47)

	if not v301 then
		return false
	end

	local PlotSign = v301:FindFirstChild("PlotSign")

	if PlotSign then
		local YourBase = PlotSign:FindFirstChild("YourBase")

		if YourBase and YourBase:IsA("BillboardGui") then
			return YourBase.Enabled == true
		end
	end

	return false
end
local function v304()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil, nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil, nil
	end

	local v307 = v297()

	if not v307 then
		return nil, nil
	end

	local u308
	local huge = math.huge
	local Name
	local Position = HumanoidRootPart.Position

	for _, child in ipairs(v307:GetChildren()) do
		if not v299(child.Name) then
			local AnimalPodiums = child:FindFirstChild("AnimalPodiums")

			if AnimalPodiums then
				for _, child2 in ipairs(AnimalPodiums:GetChildren()) do
					pcall(function()
						local Base = child2:FindFirstChild("Base")
						local Spawn = Base and Base:FindFirstChild("Spawn")

						if Spawn then
							local Position2 = Spawn.Position
							local v320 = Position2.X - Position.X
							local v321 = Position2.Y - Position.Y
							local v322 = Position2.Z - Position.Z
							local v323 = math.sqrt(v320 * v320 + v321 * v321 + v322 * v322)

							if v323 < huge and v323 <= t12.StealRadius then
								local PromptAttachment = Spawn:FindFirstChild("PromptAttachment")

								if PromptAttachment then
									for _, child3 in ipairs(PromptAttachment:GetChildren()) do
										if child3:IsA("ProximityPrompt") and child3.ActionText then
											if child3.ActionText:find("Steal") then
												u308 = child3
												huge = v323
												Name = child2.Name

												break
											end
										end
									end
								end
							end
						end
					end)
				end
			end
		end
	end

	return u308, Name
end
local function v327(p48, p49)
	if u294 then
		return
	end

	if math.random(30) == 1 then
		for k in pairs(t12.Data) do
			if not k.Parent then
				t12.Data[k] = nil
			end
		end
	end

	if not t12.Data[p48] then
		t12.Data[p48] = {
			hold = {},
			trigger = {},
			ready = true
		}
		pcall(function()
			if getconnections then
				for _, v in ipairs(getconnections(p48.PromptButtonHoldBegan)) do
					if v.Function then
						table.insert(t12.Data[p48].hold, v.Function)
					end
				end

				for _, v in ipairs(getconnections(p48.Triggered)) do
					if v.Function then
						table.insert(t12.Data[p48].trigger, v.Function)
					end
				end
			end
		end)
	end

	local v333 = t12.Data[p48]

	if not v333.ready then
		return
	end

	v333.ready = false
	u294 = true

	if progressFill then
		progressFill.Size = UDim2.new(0, 0, 1, 0)
	end

	if progressPct then
		progressPct.Text = "0%"
	end

	task.spawn(function()
		for _, v in ipairs(v333.hold) do
			task.spawn(v)
		end

		local now = tick()
		local StealDuration = t12.StealDuration

		while u294 do
			if t12.AutoStealEnabled then
				local v338 = tick() - now

				if not (v338 >= 0.96) then
					local v339 = math.clamp(v338 / StealDuration, 0, 1)

					if progressFill then
						progressFill.Size = UDim2.new(v339, 0, 1, 0)
					end

					if progressPct then
						progressPct.Text = math.floor(v339 * 100) .. "%"
					end

					if p48.Parent and p48.Parent.Parent then
						local Character = LocalPlayer2.Character
						local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

						if not HumanoidRootPart or not (t12.StealRadius < (HumanoidRootPart.Position - p48.Parent.Parent.Position).Magnitude) then
							task.wait()

							continue
						end
					else
						break
					end
				end
			end

			break
		end

		local v342 = math.clamp(0.96 / StealDuration, 0, 1)

		if progressFill then
			progressFill.Size = UDim2.new(v342, 0, 1, 0)
		end

		if progressPct then
			progressPct.Text = math.floor(v342 * 100) .. "%"
		end

		local v343 = math.max(2.0300000000000002 - math.max(StealDuration - 0.96, 0), 0.05)
		local now2 = tick()
		local exitTo

		while true do
			if not u294 or not t12.AutoStealEnabled then
				exitTo = 1

				break
			end

			if v343 <= tick() - now2 then
				exitTo = 2

				break
			end

			if p48.Parent and p48.Parent.Parent then
				local Character = LocalPlayer2.Character
				local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart then
					task.wait()

					continue
				end

				local Magnitude = (HumanoidRootPart.Position - p48.Parent.Parent.Position).Magnitude

				if not (Magnitude <= 9) then
					if t12.StealRadius < Magnitude then
						exitTo = 3

						break
					end

					task.wait()

					continue
				end

				exitTo = 1

				break
			end

			break
		end

		if exitTo == 1 then
			if u294 and t12.AutoStealEnabled then
				local now3 = tick()
				local v350 = math.max(StealDuration - 0.96, 0.05)

				while true do
					local v351 = math.clamp((tick() - now3) / v350, 0, 1)
					local v352 = v342 + v351 * (1 - v342)

					if progressFill then
						progressFill.Size = UDim2.new(v352, 0, 1, 0)
					end

					if progressPct then
						progressPct.Text = math.floor(v352 * 100) .. "%"
					end

					if not (v351 >= 1) then
						task.wait()

						continue
					end

					break
				end

				pcall(function()
					for _, v in ipairs(v333.trigger) do
						task.spawn(v)
					end

					local StealAnimal = ReplicatedStorage:FindFirstChild("StealAnimal")

					if StealAnimal and p49 then
						StealAnimal:FireServer(p49)
					end

					if p48 then
						p48:Fire()
					end
				end)
				_youtAutoCarryWatch(1.25)
			end

			if progressFill then
				progressFill.Size = UDim2.new(0, 0, 1, 0)
			end

			if progressPct then
				progressPct.Text = "0%"
			end

			v333.ready = true
			u294 = false

			return
		end

		if exitTo == 2 then
			if progressFill then
				progressFill.Size = UDim2.new(0, 0, 1, 0)
			end

			if progressPct then
				progressPct.Text = "0%"
			end

			v333.ready = true
			u294 = false
			task.wait()

			local v356, v357 = v304()

			if v356 then
				v327(v356, v357)
			end

			return
		end

		if exitTo == 3 then
			u294 = false

			if progressFill then
				progressFill.Size = UDim2.new(0, 0, 1, 0)
			end

			if progressPct then
				progressPct.Text = "0%"
			end

			v333.ready = true

			return
		end

		u294 = false

		if progressFill then
			progressFill.Size = UDim2.new(0, 0, 1, 0)
		end

		if progressPct then
			progressPct.Text = "0%"
		end

		v333.ready = true
	end)
end

_G.YoutV2Steal = {
	enabled = false,
	radius = 10,
	primeRange = 80,
	holdMin = 1.3,
	holdMax = 2.6,
	entryDelay = 0.25,
	cooldown = 0.05,
	animals = {},
	promptCache = {},
	internalCache = {},
	state = {
		active = false,
		startTime = 0,
		phase = "idle",
		label = "",
		lastResult = "",
		lastResultTime = 0
	},
	plotSync = {
		caches = {},
		connections = {}
	},
	plots = nil,
	syncReady = false,
	scanThread = nil,
	conn = nil,
	lastScan = 0,
	animalsData = nil,
	channelFolder = nil,
	routeRemote = nil,
	requestData = nil
}

local function v358()
	local Character = LocalPlayer2.Character
	local HumanoidRootPart = Character and (Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("UpperTorso"))

	return HumanoidRootPart or nil
end
local function v361(p50)
	if typeof(p50) == "table" then
		return p50
	end

	local t13 = {}

	for match in string.gmatch(tostring(p50), "[^%.]+") do
		table.insert(t13, tonumber(match) or match)
	end

	return t13
end
local function v364(p51, p52)
	local v365
	local v366

	for _, v in ipairs(v361(p51)) do
		v365 = p52
		v366 = v
		p52 = p52 and p52[v] or nil
	end

	return p52, v365, v366
end
local function v369(p53, p54)
	local v370 = _G.YoutV2Steal.plotSync.caches[p53]

	if typeof(v370) ~= "table" then
		return
	end

	local v371 = p54[2]
	local v372 = p54[3]
	local v373 = p54[4]
	local v374, v375, v376 = v364(p54[1], v370)

	if v371 ~= "Changed" then
		if v371 ~= "ArrayInsert" then
			if v371 ~= "ArrayRemoved" then
				if v371 ~= "DictionaryInsert" then
					if v371 == "DictionaryRemoved" and v374 then
						v374[v373] = nil
					end
				elseif v374 then
					v374[v373] = v372
				end
			elseif v374 then
				table.remove(v374, v373)
			end
		elseif v374 then
			table.insert(v374, v373, v372)
		end
	elseif v375 then
		v375[v376] = v372
	end
end
local function v377(p55, p56, p57)
	if _G.YoutV2Steal.plotSync.connections[p55] then
		return
	end

	local v378 = tostring(p55.Name)

	if not p56:FindFirstChild(v378) then
		return
	end

	if p57 and _G.YoutV2Steal.plotSync.caches[v378] == nil then
		local ok, result = pcall(function()
			return p57:InvokeServer(v378)
		end)

		_G.YoutV2Steal.plotSync.caches[v378] = ok and typeof(result) == "table" and result or {}
	elseif _G.YoutV2Steal.plotSync.caches[v378] == nil then
		_G.YoutV2Steal.plotSync.caches[v378] = {}
	end

	_G.YoutV2Steal.plotSync.connections[p55] = p55.OnClientEvent:Connect(function(p58)
		for _, v in ipairs(p58) do
			v369(v378, v)
		end
	end)
end
local function v383()
	if _G.YoutV2Steal.syncReady then
		return true
	end

	return pcall(function()
		_G.YoutV2Steal.plots = workspace:WaitForChild("Plots", 8)

		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local Packages = ReplicatedStorage2:FindFirstChild("Packages")
		local Datas = ReplicatedStorage2:FindFirstChild("Datas")

		if not Packages or not Datas or not _G.YoutV2Steal.plots then
			return
		end

		_G.YoutV2Steal.animalsData = require(Datas:WaitForChild("Animals", 10))

		local Synchronizer = Packages:FindFirstChild("Synchronizer") or Packages:WaitForChild("Synchronizer", 10)

		if not Synchronizer then
			return
		end

		_G.YoutV2Steal.channelFolder = Synchronizer:FindFirstChild("Channel") or Synchronizer:WaitForChild("Channel", 10)
		_G.YoutV2Steal.routeRemote = Synchronizer:FindFirstChild("CommunicationRoute") or Synchronizer:WaitForChild("CommunicationRoute", 10)
		_G.YoutV2Steal.requestData = Synchronizer:FindFirstChild("RequestData")

		if _G.YoutV2Steal.channelFolder then
			for _, child in ipairs(_G.YoutV2Steal.channelFolder:GetChildren()) do
				if child:IsA("RemoteEvent") then
					v377(child, _G.YoutV2Steal.plots, _G.YoutV2Steal.requestData)
				end
			end

			_G.YoutV2Steal.channelFolder.ChildAdded:Connect(function(child)
				if child:IsA("RemoteEvent") then
					v377(child, _G.YoutV2Steal.plots, _G.YoutV2Steal.requestData)
				end
			end)
		end

		if _G.YoutV2Steal.routeRemote then
			_G.YoutV2Steal.routeRemote.OnClientEvent:Connect(function(p59)
				for _, v in ipairs(p59) do
					local v392 = v[1]
					local v393 = tostring(v[2])

					if _G.YoutV2Steal.plots then
						if _G.YoutV2Steal.plots:FindFirstChild(v393) then
							if v392 == "ListenerAdded" then
								local channelFolder = _G.YoutV2Steal.channelFolder and _G.YoutV2Steal.channelFolder:FindFirstChild(v393)

								if channelFolder and channelFolder:IsA("RemoteEvent") then
									v377(channelFolder, _G.YoutV2Steal.plots, _G.YoutV2Steal.requestData)
								end
							elseif v392 == "ListenerRemoved" then
								for k, connection2 in pairs(_G.YoutV2Steal.plotSync.connections) do
									if tostring(k.Name) == v393 then
										pcall(function()
											connection2:Disconnect()
										end)
										_G.YoutV2Steal.plotSync.connections[k] = nil
										_G.YoutV2Steal.plotSync.caches[v393] = nil

										break
									end
								end
							end
						end
					end
				end
			end)
		end

		_G.YoutV2Steal.syncReady = true
	end) and _G.YoutV2Steal.syncReady == true
end
local function v397(p60)
	local PlotSign = p60 and p60:FindFirstChild("PlotSign")
	local Frame = PlotSign and PlotSign:FindFirstChild("SurfaceGui") and PlotSign.SurfaceGui:FindFirstChild("Frame")
	local TextLabel2 = Frame and Frame:FindFirstChild("TextLabel")

	if TextLabel2 and TextLabel2.Text ~= "Empty Base" then
		return TextLabel2.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
	end

	return nil
end
local function v401(p61)
	if p61 and p61.plot then
		if _G.YoutV2Steal.plots then
			local v402 = _G.YoutV2Steal.plots:FindFirstChild(p61.plot)

			if not v402 then
				return false
			end

			local v403 = v397(v402)

			return v403 == LocalPlayer2.DisplayName or v403 == LocalPlayer2.Name
		end
	end

	return false
end
local function v404(p62)
	local plots = _G.YoutV2Steal.plots and _G.YoutV2Steal.plots:FindFirstChild(p62.plot)
	local AnimalPodiums = plots and plots:FindFirstChild("AnimalPodiums")

	return AnimalPodiums and AnimalPodiums:FindFirstChild(p62.slot) or nil
end
local function v407(p63)
	local v408 = v404(p63)

	return v408 and v408:GetPivot().Position or nil
end
local function v409(p64)
	local v410 = v358()
	local v411 = v407(p64)

	return v410 and v411 and (v410.Position - v411).Magnitude or math.huge
end
local function v412(p65)
	if not p65 then
		return nil
	end

	local v413 = _G.YoutV2Steal.promptCache[p65.uid]

	if v413 and v413.Parent then
		return v413
	end

	local v414 = v404(p65)

	if not v414 then
		return nil
	end

	for _, descendant in ipairs(v414:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			_G.YoutV2Steal.promptCache[p65.uid] = descendant

			return descendant
		end
	end

	return nil
end
local function v417(p66)
	if _G.YoutV2Steal.internalCache[p66] then
		return
	end

	local t14 = {
		holdCallbacks = {},
		triggerCallbacks = {},
		ready = true
	}

	pcall(function()
		if getconnections then
			local v419 = getconnections(p66.PromptButtonHoldBegan) or getconnections(p66.HoldBegan) or {}

			for _, v in ipairs(v419) do
				if type(v.Function) == "function" then
					table.insert(t14.holdCallbacks, v.Function)
				end
			end

			local v422 = getconnections(p66.Triggered) or {}

			for _, v in ipairs(v422) do
				if type(v.Function) == "function" then
					table.insert(t14.triggerCallbacks, v.Function)
				end
			end
		end
	end)
	_G.YoutV2Steal.internalCache[p66] = t14
end
local function v425(p67)
	if progressFill then
		progressFill.Size = UDim2.new(math.clamp(p67, 0, 1), 0, 1, 0)
	end

	if progressPct then
		progressPct.Text = math.floor(math.clamp(p67, 0, 1) * 100) .. "%"
	end
end
local function v426()
	if progressFill then
		progressFill.Size = UDim2.new(0, 0, 1, 0)
	end

	if progressPct then
		progressPct.Text = "0%"
	end
end
local function v427(p68, p69)
	if p68 and p68.Parent then
		if p69 then
			if _G.YoutV2Steal.state.active then
				return false
			end

			local now = tick()
			local lastResultTime = _G.YoutV2Steal.state.lastResultTime

			if now - (lastResultTime or 0) < (_G.YoutV2Steal.cooldown or 0.05) then
				return false
			end

			v417(p68)

			local v430 = _G.YoutV2Steal.internalCache[p68]

			if not v430 or not v430.ready then
				return false
			end

			v430.ready = false
			_G.YoutV2Steal.state.active = true
			_G.YoutV2Steal.state.startTime = tick()
			_G.YoutV2Steal.state.phase = "holding"
			_G.YoutV2Steal.state.label = p69.name or "Animal"
			task.spawn(function()
				local startTime = _G.YoutV2Steal.state.startTime
				local t15 = {
					0.7,
					0.75,
					0.8,
					0.85,
					0.9
				}
				local v433 = t15[math.random(1, #t15)]

				if #v430.holdCallbacks > 0 then
					for _, holdCallback in ipairs(v430.holdCallbacks) do
						task.spawn(function()
							pcall(holdCallback)
						end)
					end
				else
					pcall(function()
						if p68.InputHoldBegin then
							p68:InputHoldBegin()
						end
					end)
				end

				while _G.YoutV2Steal.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED do
					if not (tick() - startTime < (_G.YoutV2Steal.holdMin or 1.3)) then
						break
					end

					v425(math.min((tick() - startTime) / (_G.YoutV2Steal.holdMax or 2.6), v433))
					task.wait()
				end

				_G.YoutV2Steal.state.phase = "waitingRange"

				local v436 = v409(p69) <= (tonumber(_G.YoutV2Steal.radius) or 10)
				local v437 = false
				local exitTo

				while true do
					if not _G.YoutV2Steal.enabled or selectedStealMode ~= "V2" or not CONFIG.AUTO_STEAL_ENABLED or not p68.Parent then
						exitTo = 1

						break
					end

					local v439 = tick() - startTime

					if (_G.YoutV2Steal.holdMax or 2.6) < v439 then
						exitTo = 2

						break
					end

					v425(math.min(v439 / (_G.YoutV2Steal.holdMax or 2.6), v433))

					if not (v409(p69) <= (tonumber(_G.YoutV2Steal.radius) or 10)) then
						task.wait()

						continue
					end

					break
				end

				local state, lastResult

				if exitTo == 1 then
					state = _G.YoutV2Steal.state
					lastResult = v437 and "Stole " .. tostring(_G.YoutV2Steal.state.label)
				elseif exitTo == 2 then
					state = _G.YoutV2Steal.state
					lastResult = v437 and "Stole " .. tostring(_G.YoutV2Steal.state.label)
				else
					if not v436 then
						task.wait(_G.YoutV2Steal.entryDelay or 0.25)
					end

					if _G.YoutV2Steal.enabled and selectedStealMode == "V2" and CONFIG.AUTO_STEAL_ENABLED then
						if #v430.triggerCallbacks > 0 then
							for _, triggerCallback in ipairs(v430.triggerCallbacks) do
								task.spawn(function()
									pcall(triggerCallback)
								end)
							end
						else
							pcall(function()
								if p68.InputHoldEnd then
									p68:InputHoldEnd()
								end
							end)
						end

						_youtAutoCarryWatch(1.25)
						v437 = true
						state = _G.YoutV2Steal.state
						lastResult = v437 and "Stole " .. tostring(_G.YoutV2Steal.state.label)
					else
						state = _G.YoutV2Steal.state
						lastResult = v437 and "Stole " .. tostring(_G.YoutV2Steal.state.label)
					end
				end

				state.lastResult = lastResult or "Missed"
				_G.YoutV2Steal.state.active = false
				_G.YoutV2Steal.state.phase = "idle"
				_G.YoutV2Steal.state.lastResultTime = tick()

				if v437 then
					v425(1)
				end

				task.wait(_G.YoutV2Steal.cooldown or 0.05)
				v430.ready = true
				v426()
			end)

			return true
		end
	end

	return false
end
local function v444()
	if not v383() then
		return 0
	end

	local animals = {}

	for _, child in ipairs(_G.YoutV2Steal.plots:GetChildren()) do
		local v448 = _G.YoutV2Steal.plotSync.caches[child.Name]
		local AnimalList = v448 and v448.AnimalList

		if typeof(AnimalList) == "table" then
			for k, v in pairs(AnimalList) do
				if type(v) == "table" then
					local Index = v.Index
					local animalsData = _G.YoutV2Steal.animalsData and _G.YoutV2Steal.animalsData[Index]

					if animalsData then
						table.insert(animals, {
							name = animalsData.DisplayName or Index,
							plot = child.Name,
							slot = tostring(k),
							uid = child.Name .. "_" .. tostring(k)
						})
					end
				end
			end
		end
	end

	_G.YoutV2Steal.animals = animals

	return #animals
end
local function v454()
	local v455 = v358()

	if not v455 then
		return nil
	end

	local v456
	local huge = math.huge

	for _, animal in ipairs(_G.YoutV2Steal.animals) do
		if not v401(animal) then
			local v460 = v407(animal)
			local Magnitude = v460 and (v455.Position - v460).Magnitude or math.huge

			if Magnitude <= (_G.YoutV2Steal.primeRange or 80) and Magnitude < huge then
				v456 = animal
				huge = Magnitude
			end
		end
	end

	return v456
end
local function v462()
	if _G.YoutV2Steal.scanThread then
		return
	end

	_G.YoutV2Steal.scanThread = task.spawn(function()
		while _G.YoutV2Steal do
			if _G.YoutV2Steal.enabled then
				pcall(v444)
			elseif selectedStealMode == "V2" then
				pcall(v444)
				task.wait(5)

				continue
			end

			task.wait(5)
		end
	end)
end

stopAutoStealV2 = function()
	_G.YoutV2Steal.enabled = false

	if _G.YoutV2Steal.conn then
		_G.YoutV2Steal.conn:Disconnect()
		_G.YoutV2Steal.conn = nil
	end

	_G.YoutV2Steal.state.active = false
	_G.YoutV2Steal.state.phase = "idle"
	v426()
end
startAutoStealV2 = function()
	_G.YoutV2Steal.radius = _G._youtStealRadiusV2 or 60
	_G.YoutV2Steal.enabled = true
	pcall(v383)
	v462()
	pcall(v444)

	if _G.YoutV2Steal.conn then
		_G.YoutV2Steal.conn:Disconnect()
		_G.YoutV2Steal.conn = nil
	end

	_G.YoutV2Steal.conn = RunService.Heartbeat:Connect(function()
		if not _G.YoutV2Steal.enabled or not CONFIG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V2" or _G.YoutV2Steal.state.active then
			return
		end

		local v463 = v454()

		if v463 then
			local v464 = v412(v463)

			if v464 then
				v427(v464, v463)
			end

			return
		end

		if tick() - (_G.YoutV2Steal.lastScan or 0) > 1.2 then
			_G.YoutV2Steal.lastScan = tick()
			pcall(v444)
		end
	end)
end
_G.YoutV3Steal = _G.YoutV3Steal or {
	conn = nil,
	active = false,
	progress = 0,
	paused = false,
	pauseTime = nil,
	startTime = nil,
	progressConn = nil,
	dataCache = {},
	enabled = false,
	StealRadius = 63,
	StealDuration = 1.3,
	TriggerRadius = 10
}

local function v465()
	local Character = LocalPlayer2.Character

	return Character and Character:FindFirstChild("HumanoidRootPart")
end
local function v467(p70)
	local Plots2 = workspace:FindFirstChild("Plots")

	if not Plots2 then
		return false
	end

	local v469 = Plots2:FindFirstChild(p70)

	if not v469 then
		return false
	end

	local PlotSign = v469:FindFirstChild("PlotSign")

	if PlotSign then
		local YourBase = PlotSign:FindFirstChild("YourBase")

		if YourBase and YourBase:IsA("BillboardGui") then
			return YourBase.Enabled == true
		end
	end

	return false
end
local function v472()
	local v473 = v465()

	if not v473 then
		return nil, nil
	end

	local Plots2 = workspace:FindFirstChild("Plots")

	if not Plots2 then
		return nil, nil
	end

	local u475
	local huge = math.huge
	local u477

	for _, child in ipairs(Plots2:GetChildren()) do
		if child:IsA("Model") and not v467(child.Name) then
			local AnimalPodiums = child:FindFirstChild("AnimalPodiums")

			if AnimalPodiums then
				for _, child2 in ipairs(AnimalPodiums:GetChildren()) do
					pcall(function()
						local Base = child2:FindFirstChild("Base")
						local Spawn = Base and Base:FindFirstChild("Spawn")

						if not Spawn then
							return
						end

						local Magnitude = (Spawn.Position - v473.Position).Magnitude

						if huge <= Magnitude or _G.YoutV3Steal.StealRadius < Magnitude then
							return
						end

						local function v486(p71)
							for _, child3 in ipairs(p71:GetChildren()) do
								if child3:IsA("ProximityPrompt") then
									if not child3.Enabled then
										continue
									end

									u475 = child3
									huge = Magnitude
									u477 = Spawn

									return true
								end
							end
						end

						local PromptAttachment = Spawn:FindFirstChild("PromptAttachment")

						if not PromptAttachment or not v486(PromptAttachment) then
							for _, descendant in ipairs(Spawn:GetDescendants()) do
								if descendant:IsA("ProximityPrompt") and descendant.Enabled then
									u475 = descendant
									huge = Magnitude
									u477 = Spawn

									break
								end
							end
						end
					end)
				end
			end
		end
	end

	return u475, u477
end
local function v492(p72)
	local v493 = v465()

	if not v493 then
		return math.huge
	end

	if p72 and p72.Parent then
		return (v493.Position - p72.Position).Magnitude
	end

	local _, v495 = v472()

	return v495 and (v493.Position - v495.Position).Magnitude or math.huge
end
local function v496(p73, p74)
	if _G.YoutStealBar then
		pcall(function()
			_G.YoutStealBar.SetProgress(p73 or 0)

			if p74 then
				_G.YoutStealBar.SetState(p74)
			end
		end)
	end
end
local function v497(p75, p76)
	if _G.YoutV3Steal.active then
		return
	end

	local getconnections_ = getconnections or get_signal_cons or getconnects or syn and syn.get_signal_cons

	if not _G.YoutV3Steal.dataCache[p75] then
		local t16 = {
			hold = {},
			trigger = {},
			ready = true
		}

		if getconnections_ then
			pcall(function()
				for _, v in ipairs(getconnections_(p75.PromptButtonHoldBegan)) do
					if v.Function then
						table.insert(t16.hold, v.Function)
					end
				end

				for _, v in ipairs(getconnections_(p75.Triggered)) do
					if v.Function then
						table.insert(t16.trigger, v.Function)
					end
				end
			end)
		end

		_G.YoutV3Steal.dataCache[p75] = t16
	end

	local v504 = _G.YoutV3Steal.dataCache[p75]

	if not v504.ready then
		return
	end

	v504.ready = false
	_G.YoutV3Steal.active = true
	_G.YoutV3Steal.paused = false
	_G.YoutV3Steal.startTime = tick() - _G.YoutV3Steal.progress * _G.YoutV3Steal.StealDuration

	local u505 = true

	if _G.YoutV3Steal.progressConn then
		_G.YoutV3Steal.progressConn:Disconnect()
	end

	v496(_G.YoutV3Steal.progress, "STEALING")
	_G.YoutV3Steal.progressConn = RunService.Heartbeat:Connect(function()
		if not _G.YoutV3Steal.active then
			if _G.YoutV3Steal.progressConn then
				_G.YoutV3Steal.progressConn:Disconnect()
				_G.YoutV3Steal.progressConn = nil
			end

			return
		end

		if not _G.YoutV3Steal.enabled or not CONFIG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V3" then
			_G.YoutV3Steal.active = false
			_G.YoutV3Steal.progress = 0
			_G.YoutV3Steal.paused = false
			v504.ready = true
			v496(0, CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE")

			return
		end

		if _G.YoutV3Steal.paused then
			if not (v492(p76) <= _G.YoutV3Steal.TriggerRadius) then
				if _G.YoutV3Steal.pauseTime then
					if tick() - _G.YoutV3Steal.pauseTime >= 1.3 then
						_G.YoutV3Steal.pauseTime = nil
						_G.YoutV3Steal.paused = false
						_G.YoutV3Steal.active = false
						_G.YoutV3Steal.progress = 0
						v504.ready = true
						u505 = true

						if _G.YoutV3Steal.progressConn then
							_G.YoutV3Steal.progressConn:Disconnect()
							_G.YoutV3Steal.progressConn = nil
						end

						v496(0, CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE")

						return
					end
				else
					_G.YoutV3Steal.pauseTime = tick()
				end

				_G.YoutV3Steal.progress = 0.8
				v496(0.8, "STEALING")

				return
			end

			_G.YoutV3Steal.paused = false
			_G.YoutV3Steal.pauseTime = nil
			_G.YoutV3Steal.startTime = tick() - 0.8 * _G.YoutV3Steal.StealDuration
		end

		local progress = math.clamp((tick() - _G.YoutV3Steal.startTime) / _G.YoutV3Steal.StealDuration, 0, 1)

		_G.YoutV3Steal.progress = progress

		if u505 then
			if progress >= 0.8 then
				_G.YoutV3Steal.paused = true
				u505 = false
				_G.YoutV3Steal.progress = 0.8
				v496(0.8, "STEALING")

				return
			end
		end

		v496(progress, "STEALING")

		if progress >= 1 then
			_G.YoutV3Steal.active = false
			_G.YoutV3Steal.progress = 0
			_G.YoutV3Steal.paused = false
			u505 = true

			if _G.YoutV3Steal.progressConn then
				_G.YoutV3Steal.progressConn:Disconnect()
				_G.YoutV3Steal.progressConn = nil
			end

			for _, v in ipairs(v504.trigger) do
				task.spawn(function()
					pcall(v)
				end)
			end

			_youtAutoCarryWatch(1.25)
			v504.ready = true
			v496(0, CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE")
		end
	end)

	for _, v in ipairs(v504.hold) do
		task.spawn(function()
			pcall(v)
		end)
	end
end

startAutoStealV3 = function()
	if _G.YoutV3Steal.conn then
		_G.YoutV3Steal.conn:Disconnect()
		_G.YoutV3Steal.conn = nil
	end

	_G.YoutV3Steal.enabled = true
	_G.YoutV3Steal.StealRadius = tonumber(CONFIG.STEAL_RANGE) or 63
	_G.YoutV3Steal.StealDuration = 1.3
	_G.YoutV3Steal.TriggerRadius = 10
	_G.YoutV3Steal.conn = RunService.Heartbeat:Connect(function()
		if not _G.YoutV3Steal.enabled or _G.YoutV3Steal.active then
			return
		end

		if not CONFIG.AUTO_STEAL_ENABLED or selectedStealMode ~= "V3" then
			return
		end

		local v511, v512 = v472()

		if v511 then
			v497(v511, v512)
		end
	end)
	v496(0, "READY")
end
stopAutoStealV3 = function()
	_G.YoutV3Steal.enabled = false

	if _G.YoutV3Steal.conn then
		_G.YoutV3Steal.conn:Disconnect()
		_G.YoutV3Steal.conn = nil
	end

	if _G.YoutV3Steal.progressConn then
		_G.YoutV3Steal.progressConn:Disconnect()
		_G.YoutV3Steal.progressConn = nil
	end

	_G.YoutV3Steal.active = false
	_G.YoutV3Steal.progress = 0
	_G.YoutV3Steal.paused = false
	_G.YoutV3Steal.pauseTime = nil
	_G.YoutV3Steal.dataCache = {}
	v496(0, CONFIG.AUTO_STEAL_ENABLED and "READY" or "IDLE")
end

local function v513()
	if connection then
		local u514 = false

		pcall(function()
			u514 = connection.Connected == true
		end)

		if u514 then
			t12.StealRadius = CONFIG.STEAL_RANGE
			t12.AutoStealEnabled = true

			return true
		end

		pcall(function()
			connection:Disconnect()
		end)
		connection = nil
	end

	t12.StealRadius = CONFIG.STEAL_RANGE
	t12.AutoStealEnabled = true
	connection = RunService.Heartbeat:Connect(function()
		if not t12.AutoStealEnabled or u294 then
			return
		end

		if selectedStealMode ~= "V1" then
			return
		end

		local v515, v516 = v304()

		if v515 then
			v327(v515, v516)
		end
	end)

	return true
end
local function v517()
	if connection then
		connection:Disconnect()
		connection = nil
	end

	u294 = false
	t12.AutoStealEnabled = false

	if progressFill then
		TweenService:Create(progressFill, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 0, 1, 0)
		}):Play()
	end

	if progressPct then
		progressPct.Text = "0%"
	end
end

startAutoSteal = function()
	v517()
	stopAutoStealV2()
	stopAutoStealV3()
	CONFIG.AUTO_STEAL_ENABLED = true

	if selectedStealMode == "V3" then
		startAutoStealV3()
	elseif selectedStealMode == "V2" then
		startAutoStealV2()
	else
		v513()
	end

	return true
end
stopAutoSteal = function()
	v517()
	stopAutoStealV2()
	stopAutoStealV3()
	CONFIG.AUTO_STEAL_ENABLED = false

	if progressFill then
		TweenService:Create(progressFill, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 0, 1, 0)
		}):Play()
	end

	if progressPct then
		progressPct.Text = "0%"
	end
end

local function v518(p77, p78, p79)
	if not p77 then
		return false
	end

	local sethiddenproperty_ = sethiddenproperty or set_hidden_property

	sethiddenproperty_ = sethiddenproperty_ or sethiddenprop

	if type(sethiddenproperty_) == "function" and pcall(sethiddenproperty_, p77, p78, p79) then
		return true
	end

	return pcall(function()
		p77[p78] = p79
	end)
end
local function v520(p80, p81)
	if not p80 then
		return false, nil
	end

	local gethiddenproperty_ = gethiddenproperty or get_hidden_property or gethiddenprop

	if type(gethiddenproperty_) == "function" then
		local ok, result = pcall(gethiddenproperty_, p80, p81)

		if ok then
			return true, result
		end
	end

	local ok, result = pcall(function()
		return p80[p81]
	end)

	return ok, result
end
local function v526(p82)
	if not p82 then
		return false
	end

	local ok, result = pcall(function()
		return p82:IsA("BasePart")
	end)

	return ok and result == true
end
local function v529()
	if not v526(antiDesyncFakeRoot) then
		return false
	end

	local ok, result = pcall(function()
		return antiDesyncFakeRoot.Parent
	end)

	return ok and result ~= nil
end
local function v532()
	local antiDesyncFakeRoot_ = antiDesyncFakeRoot

	antiDesyncFakeRoot = nil

	if antiDesyncFakeRoot_ then
		pcall(function()
			antiDesyncFakeRoot_:Destroy()
		end)
	end
end
local function v534()
	local antiDesyncRepRootOwner_ = antiDesyncRepRootOwner

	if v526(antiDesyncRepRootOwner_) then
		v518(antiDesyncRepRootOwner_, "PhysicsRepRootPart", antiDesyncRepRootOwner_)
	end

	antiDesyncRepRootOwner = nil
end
local function createPart(p83)
	v532()

	local Part = Instance.new("Part")

	Part.Name = ANTI_DESYNC_FAKE_ROOT_NAME
	Part.Size = Vector3.new(2, 2, 1)
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanTouch = false
	Part.CanQuery = false
	Part.Transparency = 1
	Part.CFrame = CFrame.new(0, ANTI_DESYNC_FAKE_ROOT_Y, 0)
	Part.AssemblyLinearVelocity = ANTI_DESYNC_FAKE_ROOT_VELOCITY
	Part.Parent = workspace

	local ok, result = pcall(function()
		return p83.Position
	end)

	if ok then
		Part.CFrame = CFrame.new(result.X, ANTI_DESYNC_FAKE_ROOT_Y, result.Z)
	end

	antiDesyncFakeRoot = Part

	return Part
end
local function v540(p84, p85)
	if not v526(p84) or not v526(p85) then
		return false
	end

	v518(p84, "PhysicsRepRootPart", p84)
	antiDesyncRepRootOwner = p84

	return v518(p84, "PhysicsRepRootPart", p85)
end
local function v541()
	if not antiDesyncEnabled then
		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not v526(HumanoidRootPart) then
		return
	end

	if not v529() then
		local v544 = createPart(HumanoidRootPart)

		v540(HumanoidRootPart, v544)

		return
	end

	local ok, result, result2 = pcall(function()
		return HumanoidRootPart.Position, antiDesyncFakeRoot.Position
	end)

	if ok and (math.abs(result.X - result2.X) > 0.01 or math.abs(result.Z - result2.Z) > 0.01 or math.abs(result2.Y - ANTI_DESYNC_FAKE_ROOT_Y) > 0.01) then
		pcall(function()
			antiDesyncFakeRoot.CFrame = CFrame.new(result.X, ANTI_DESYNC_FAKE_ROOT_Y, result.Z)
		end)
	end

	pcall(function()
		antiDesyncFakeRoot.Anchored = true
		antiDesyncFakeRoot.AssemblyLinearVelocity = ANTI_DESYNC_FAKE_ROOT_VELOCITY
	end)

	local physicsRepRootPart, v549 = v520(HumanoidRootPart, "PhysicsRepRootPart")

	if not physicsRepRootPart or v549 ~= antiDesyncFakeRoot then
		v518(HumanoidRootPart, "PhysicsRepRootPart", antiDesyncFakeRoot)
	end
end
local function v550()
	if antiDesyncAntiBatConn then
		antiDesyncAntiBatConn:Disconnect()
		antiDesyncAntiBatConn = nil
	end

	antiDesyncLastSafeCFrame = nil
end
local function v551()
	v550()
	antiDesyncAntiBatConn = RunService.Heartbeat:Connect(function()
		if not antiDesyncEnabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
			return
		end

		local now = tick()
		local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

		if AssemblyLinearVelocity.Magnitude < 70 then
			antiDesyncLastSafeCFrame = HumanoidRootPart.CFrame
			antiDesyncLastCheckTime = now
		elseif AssemblyLinearVelocity.Magnitude > 110 and antiDesyncLastSafeCFrame and now - antiDesyncLastCheckTime < 1.5 then
			HumanoidRootPart.CFrame = antiDesyncLastSafeCFrame * CFrame.new(0, 0.1, 0)
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer2 and player.Character then
				local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
				local Tool = player.Character:FindFirstChildWhichIsA("Tool")

				if HumanoidRootPart2 and Tool then
					if Tool.Name:lower():find("bat") and (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude < ANTI_DESYNC_RANGE then
						local v561 = math.rad(tick() * 500)

						HumanoidRootPart.CFrame *= CFrame.new(math.sin(v561) * 3, 0, math.cos(v561) * 3)
					end
				end
			end
		end
	end)
end
local function v562()
	if antiDesyncFreezeConn then
		antiDesyncFreezeConn:Disconnect()
		antiDesyncFreezeConn = nil
	end
end
local function v563()
	v562()
	antiDesyncFreezeConn = RunService.Heartbeat:Connect(function()
		if not antiDesyncEnabled then
			return
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer2 and player.Character then
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
				end
			end
		end
	end)
end
local function v567()
	if antiDesyncFlingConn then
		antiDesyncFlingConn:Disconnect()
		antiDesyncFlingConn = nil
	end
end
local function v568()
	v567()
	antiDesyncFlingConn = RunService.Heartbeat:Connect(function()
		if not antiDesyncEnabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer2 and player.Character then
				local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 then
					if (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude < ANTI_DESYNC_RANGE then
						HumanoidRootPart2.AssemblyLinearVelocity = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Unit * 150 + Vector3.new(0, 80, 0)
					end
				end
			end
		end
	end)
end
local function v574()
	if antiDesyncAntiResetHealthConn then
		antiDesyncAntiResetHealthConn:Disconnect()
		antiDesyncAntiResetHealthConn = nil
	end

	if antiDesyncAntiResetCFrameConn then
		antiDesyncAntiResetCFrameConn:Disconnect()
		antiDesyncAntiResetCFrameConn = nil
	end
end
local function v575(p86)
	if not p86 then
		return
	end

	local Humanoid = p86:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	if antiDesyncAntiResetHealthConn then
		antiDesyncAntiResetHealthConn:Disconnect()
	end

	antiDesyncAntiResetHealthConn = Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if not antiDesyncEnabled then
			return
		end

		if Humanoid.Health <= 0 or Humanoid:GetState() == Enum.HumanoidStateType.Dead then
			pcall(function()
				Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				Humanoid.Health = Humanoid.MaxHealth
			end)
		end
	end)
	Humanoid.Died:Connect(function()
		if antiDesyncEnabled then
			pcall(function()
				Humanoid.Health = Humanoid.MaxHealth
			end)

			return
		end
	end)
end
local function v577()
	v574()
	pcall(function()
		workspace.FallenPartsDestroyHeight = -math.huge
	end)
	antiDesyncAntiResetCFrameConn = RunService.Heartbeat:Connect(function()
		if not antiDesyncEnabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return
		end

		if Humanoid.Health <= 0 then
			pcall(function()
				Humanoid.Health = Humanoid.MaxHealth
			end)
		end

		if antiDesyncLastSafeCFrame then
			if (HumanoidRootPart.Position - antiDesyncLastSafeCFrame.Position).Magnitude > 500 then
				pcall(function()
					HumanoidRootPart.CFrame = antiDesyncLastSafeCFrame
				end)
			else
				antiDesyncLastSafeCFrame = HumanoidRootPart.CFrame
			end
		else
			antiDesyncLastSafeCFrame = HumanoidRootPart.CFrame
		end
	end)

	if LocalPlayer2.Character then
		v575(LocalPlayer2.Character)
	end
end

startAntiDesync = function()
	if antiDesyncEnabled then
		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	antiDesyncEnabled = true

	local v583 = createPart(HumanoidRootPart)

	v540(HumanoidRootPart, v583)

	if antiDesyncStepConn then
		antiDesyncStepConn:Disconnect()
	end

	antiDesyncStepConn = RunService.Stepped:Connect(v541)
	v551()
	v563()
	v568()
	v577()

	if setAntiDesyncVisual then
		setAntiDesyncVisual(true)
	end

	if mobSetAntiDesync then
		mobSetAntiDesync(true)
	end
end
stopAntiDesync = function()
	if not antiDesyncEnabled then
		return
	end

	antiDesyncEnabled = false

	if antiDesyncStepConn then
		antiDesyncStepConn:Disconnect()
		antiDesyncStepConn = nil
	end

	v534()
	v532()
	v550()
	v562()
	v567()
	v574()

	if setAntiDesyncVisual then
		setAntiDesyncVisual(false)
	end

	if mobSetAntiDesync then
		mobSetAntiDesync(false)
	end
end
toggleAntiDesync = function()
	if antiDesyncEnabled then
		stopAntiDesync()
	else
		startAntiDesync()
	end
end
setAntiDesyncVisual = nil
mobSetAntiDesync = nil

local function v584()
	if laggerToggled or laggerCarryToggled then
		return laggerCarryToggled and "Lagger Carry" or "Lagger"
	end

	return speedMode and "Carry" or "Normal"
end
local function v585(p87, p88)
	laggerToggled = p87 == true
	laggerCarryToggled = false
	speedMode = p88 == true

	if p87 and p88 then
		laggerToggled = false
		laggerCarryToggled = true
		speedMode = false
	end

	if refreshSpeedModeLabel then
		refreshSpeedModeLabel()
	end

	if mobSetCarry then
		mobSetCarry(speedMode)
	end

	if mobSetLagger1 then
		mobSetLagger1(laggerToggled)
	end

	if mobSetLagger2 then
		mobSetLagger2(laggerCarryToggled)
	end
end
local function v586(p89)
	local v587 = tostring(p89 or ""):lower()

	return v587:find("bat", 1, true) or v587:find("slap", 1, true) or v587:find("medusa", 1, true) or v587:find("head", 1, true) or v587:find("stone", 1, true)
end
local function v588()
	local Character = LocalPlayer2.Character

	if not Character then
		return false
	end

	for _, v in ipairs({
		"Carrying",
		"IsCarrying",
		"Grabbed",
		"Holding",
		"StealHold",
		"HasGrab"
	}) do
		local v592 = Character:FindFirstChild(v, true)

		if v592 then
			if v592:IsA("BoolValue") and v592.Value then
				return true
			end

			if v592:IsA("ObjectValue") and v592.Value then
				return true
			end

			if not v592:IsA("StringValue") then
				continue
			end

			if v592.Value ~= "" then
				return true
			end
		end
	end

	for _, child in ipairs(Character:GetChildren()) do
		local v595 = child.Name:lower()

		if not child:IsA("Model") or not child:FindFirstChildWhichIsA("BasePart", true) then
			if not child:IsA("Tool") then
				continue
			end

			if v586(child.Name) then
				continue
			end

			return true
		end

		if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") or v595:find("brainrot", 1, true) then
			return true
		end

		if v595:find("animal", 1, true) or v595:find("carry", 1, true) or v595:find("grab", 1, true) or v595:find("steal", 1, true) or v595:find("hold", 1, true) then
			return true
		end
	end

	return false
end
local function v596()
	_youtAutoCarryState.waiting = false
	_youtAutoCarryState.watchUntil = 0

	if not _youtAutoCarryState.applied then
		_youtAutoCarryState.savedMode = v584()
	end

	_youtAutoCarryState.applied = true
	_youtAutoCarryState.graceUntil = tick() + 0.75

	if _youtAutoCarryState.savedMode == "Lagger" or _youtAutoCarryState.savedMode == "Lagger Carry" or laggerToggled or laggerCarryToggled then
		v585(true, true)
	else
		v585(false, true)
	end
end
local function v597()
	if not (_youtAutoCarryState.applied or _youtAutoCarryState.waiting) then
		return
	end

	_youtAutoCarryState.applied = false
	_youtAutoCarryState.waiting = false
	_youtAutoCarryState.watchUntil = 0
	_youtAutoCarryState.graceUntil = 0
	_youtAutoCarryState.savedMode = nil

	if not _youtAutoCarryState.applied then
		return
	end

	if _youtAutoCarryState.savedMode == "Lagger" or _youtAutoCarryState.savedMode == "Lagger Carry" then
		v585(true, false)
	elseif _youtAutoCarryState.savedMode == "Carry" then
		v585(false, true)
	else
		v585(false, false)
	end
end

_youtAutoCarryWatch = function(p90)
	if not autoCarrySpeedEnabled then
		return
	end

	_youtAutoCarryState.waiting = true
	_youtAutoCarryState.watchUntil = tick() + (p90 or 1.25)
end
_youtAutoCarryForceDisable = function()
	v597()
end
task.spawn(function()
	while task.wait(0.08) do
		if autoCarrySpeedEnabled then
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

			if Character and Humanoid and HumanoidRootPart then
				local state = Humanoid:GetState()
				local v602 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
				local v603 = LocalPlayer2:GetAttribute("Stealing") == true or Character:GetAttribute("Stealing") == true
				local v604 = v588()
				local _youtAutoCarryState_ = _youtAutoCarryState

				if not v603 or _youtAutoCarryState_.stealWasActive then
					if not v603 then
						_youtAutoCarryState_.stealWasActive = false
					end
				else
					_youtAutoCarryState_.stealWasActive = true
					v596()
				end

				if _youtAutoCarryState_.waiting then
					if v602 or _youtAutoCarryState_.watchUntil < tick() then
						_youtAutoCarryState_.waiting = false
						_youtAutoCarryState_.watchUntil = 0
					elseif v604 then
						v596()
					end
				end

				if v604 then
					if not _youtAutoCarryState_.applied then
						v596()
					end
				end

				if _youtAutoCarryState_.applied then
					local v606 = tick() > _youtAutoCarryState_.graceUntil

					if v602 or v606 and not (v604 or v603) then
						v597()
					end
				end
			else
				v597()
				_youtAutoCarryState.stealWasActive = false
			end
		else
			v597()
			_youtAutoCarryState.stealWasActive = false
		end
	end
end)
setAutoCarrySpeedEnabled = function(p91)
	autoCarrySpeedEnabled = p91 == true

	if not autoCarrySpeedEnabled then
		v597()
	end

	if autoCarrySetVisual then
		autoCarrySetVisual(autoCarrySpeedEnabled)
	end

	saveAllSettings()
end
toggleAutoCarrySpeed = function()
	setAutoCarrySpeedEnabled(not autoCarrySpeedEnabled)
end

local function v607(p92)
	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	if not p92 then
		if Humanoid.FloorMaterial ~= Enum.Material.Air then
			return
		end

		local Y = HumanoidRootPart.Position.Y

		if not ((tonumber(autoTPHeight) or 20) <= Y) then
			return
		end
	end

	local value = select(2, HumanoidRootPart.CFrame:ToEulerAnglesYXZ())

	HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, -7, HumanoidRootPart.Position.Z) * CFrame.Angles(0, value, 0)
	HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
	HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	pcall(function()
		HumanoidRootPart.Velocity = Vector3.zero
	end)
	pcall(function()
		HumanoidRootPart.RotVelocity = Vector3.zero
	end)
end
local function v613()
	pcall(function()
		v607(true)
	end)
end

startAutoTP = function()
	autoTPEnabled = true

	if autoTPConn then
		pcall(function()
			autoTPConn:Disconnect()
		end)
		autoTPConn = nil
	end

	autoTPLastRun = 0
	autoTPConn = RunService.Heartbeat:Connect(function()
		if not autoTPEnabled then
			if autoTPConn then
				autoTPConn:Disconnect()
				autoTPConn = nil
			end

			return
		end

		local now = tick()

		if now - autoTPLastRun < 0.1 then
			return
		end

		autoTPLastRun = now
		pcall(function()
			v607(false)
		end)
	end)

	if autoTPSetVisual then
		autoTPSetVisual(true)
	end
end
stopAutoTP = function()
	autoTPEnabled = false

	if autoTPConn then
		pcall(function()
			autoTPConn:Disconnect()
		end)
		autoTPConn = nil
	end

	if autoTPSetVisual then
		autoTPSetVisual(false)
	end
end
toggleAutoTP = function(p93)
	if p93 then
		startAutoTP()
	else
		stopAutoTP()
	end

	saveAllSettings()
end

local connection2

local function v616()
	if connection2 then
		return
	end

	connection2 = RunService.Heartbeat:Connect(function()
		if not KB.TPFloor then
			return
		end

		local gp = KB.TPFloor.gp or KB.TPFloor.kb

		if not gp then
			return
		end

		if UserInputService:IsKeyDown(gp) then
			pcall(function()
				v607(true)
			end)
		end
	end)
end

v616()
medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = Vector3.new(0, 0, 0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
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
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {
	autoSteal = nil,
	batCounter = nil,
	anchor = {},
	progress = nil,
	autoLeft = nil,
	autoRight = nil
}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox = nil
carryBox = nil
laggerBox = nil
lagger2Box = nil
radInput = nil
batSpeedBox = nil
uiScaleBox = nil
modeSelectBtn = nil
dropModeBtnRef = nil
autoBatSetVisual = nil
autoLeftSetVisual = nil
autoRightSetVisual = nil
setBatCounterVisual = nil
setMedusaVisual = nil
setAntiRagVisual = nil
setUnwalkVisual = nil
setAntiLagVisual = nil
setLockUIVisual = nil
setInstaGrab = nil
setAntiDieVisual = nil
setESPVIsual = nil
mobSetAutoBat = nil
mobSetAutoLeft = nil
mobSetAutoRight = nil
mobSetDropBR = nil
mobSetTpDown = nil
mobSetCarry = nil
mobSetLagger1 = nil
mobSetLagger2 = nil
miniBtn = nil
main = nil
gui = nil
MobilePanel = nil
instaResetFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil
GAMEPAD_KEYS = {
	[Enum.KeyCode.ButtonA] = true,
	[Enum.KeyCode.ButtonB] = true,
	[Enum.KeyCode.ButtonX] = true,
	[Enum.KeyCode.ButtonY] = true,
	[Enum.KeyCode.ButtonL1] = true,
	[Enum.KeyCode.ButtonR1] = true,
	[Enum.KeyCode.ButtonL2] = true,
	[Enum.KeyCode.ButtonR2] = true,
	[Enum.KeyCode.ButtonL3] = true,
	[Enum.KeyCode.ButtonR3] = true,
	[Enum.KeyCode.ButtonStart] = true,
	[Enum.KeyCode.ButtonSelect] = true,
	[Enum.KeyCode.DPadUp] = true,
	[Enum.KeyCode.DPadDown] = true,
	[Enum.KeyCode.DPadLeft] = true,
	[Enum.KeyCode.DPadRight] = true
}
MOVE_KEYS = {
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Left] = true,
	[Enum.KeyCode.Down] = true,
	[Enum.KeyCode.Right] = true
}
BAT_COUNTER_SLAP_LIST = {
	"Bat",
	"Slap",
	"Iron Slap",
	"Gold Slap",
	"Diamond Slap",
	"Emerald Slap",
	"Ruby Slap",
	"Dark Matter Slap",
	"Flame Slap",
	"Nuclear Slap",
	"Galaxy Slap",
	"Glitched Slap"
}
AP = {
	L1 = Vector3.new(-476.48, -6.28, 92.73),
	L2 = Vector3.new(-483.12, -4.95, 94.8),
	L_FACE = Vector3.new(-482.25, -4.96, 92.09),
	R1 = Vector3.new(-476.16, -6.52, 25.62),
	R2 = Vector3.new(-483.06, -5.03, 25.48),
	R_FACE = Vector3.new(-482.06, -6.93, 35.47)
}
isGamepadInput = function(p94)
	local UserInputType = p94 and p94.UserInputType

	return UserInputType and p94.UserInputType.Name:match("^Gamepad") ~= nil
end
isBindableInput = function(p95)
	if p95 then
		if p95.KeyCode ~= Enum.KeyCode.Unknown then
			if p95.UserInputType == Enum.UserInputType.Keyboard then
				return true
			end

			return isGamepadInput(p95) and GAMEPAD_KEYS[p95.KeyCode] == true
		end
	end

	return false
end
kbMatch = function(p96, p97)
	return p97 and (p97 == p96.kb or p96.gp and p97 == p96.gp)
end
resetProgressBar = function()
	if progressPct then
		progressPct.Text = "0%"
	end

	if progressFill then
		progressFill.Size = UDim2.new(0, 0, 1, 0)
	end
end

local t17 = {
	Enabled = false,
	Connection = nil,
	ResetCooldown = 0
}

local function v620()
	if t17.Connection then
		return
	end

	t17.Enabled = true
	t17.Connection = RunService.Heartbeat:Connect(function()
		if not t17.Enabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not Humanoid or not HumanoidRootPart then
			return
		end

		if Humanoid.Health <= 0 or Humanoid:GetState() == Enum.HumanoidStateType.Dead then
			return
		end

		local state = Humanoid:GetState()
		local now = tick()

		if (state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown) and now - t17.ResetCooldown > 0.15 then
			t17.ResetCooldown = now
			pcall(function()
				if Humanoid:GetState() == Enum.HumanoidStateType.GettingUp then
					return
				end

				if Humanoid.Health <= 0 or Humanoid:GetState() == Enum.HumanoidStateType.Dead then
					return
				end

				Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				HumanoidRootPart.Velocity = Vector3.zero
				HumanoidRootPart.RotVelocity = Vector3.zero
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero

				for _, descendant in ipairs(Character:GetDescendants()) do
					if descendant:IsA("Motor6D") then
						descendant.Enabled = true
					end

					if descendant:IsA("Constraint") then
						descendant.Enabled = true
					end
				end

				workspace.CurrentCamera.CameraSubject = Humanoid

				local PlayerModule = LocalPlayer2.PlayerScripts:FindFirstChild("PlayerModule")

				if PlayerModule then
					local ControlModule = require(PlayerModule:FindFirstChild("ControlModule"))

					if ControlModule then
						ControlModule:Enable()
					end
				end

				Humanoid.AutoRotate = true
				Humanoid.PlatformStand = false
				Humanoid.Sit = false
			end)
		end
	end)
end
local function v630()
	t17.Enabled = false

	if t17.Connection then
		t17.Connection:Disconnect()
		t17.Connection = nil
	end

	t17.ResetCooldown = 0
end

setAntiRagdollMode = function(p98)
	if p98 == "v2" then
		v620()
		antiRagdollMode = "v2"
	else
		v630()
		antiRagdollMode = "off"
	end

	if setAntiRagVisual then
		setAntiRagVisual(antiRagdollMode == "v2")
	end

	saveAllSettings()
end

local antiDie = {
	enabled = false,
	healthConn = nil,
	diedConn = nil,
	charConn = nil,
	humanoid = nil,
	_reviving = false
}

local function v632()
	if antiDie.healthConn then
		antiDie.healthConn:Disconnect()
		antiDie.healthConn = nil
	end

	if antiDie.diedConn then
		antiDie.diedConn:Disconnect()
		antiDie.diedConn = nil
	end

	antiDie.humanoid = nil
end
local function v633(p99)
	if not antiDie.enabled then
		return
	end

	local Character = p99 or LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()
	local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:WaitForChild("Humanoid", 3)

	if not Humanoid or not antiDie.enabled then
		return
	end

	v632()
	antiDie.humanoid = Humanoid
	pcall(function()
		Humanoid.BreakJointsOnDeath = false
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
	end)
	antiDie.healthConn = Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if not antiDie.enabled or not Humanoid.Parent then
			return
		end

		if Humanoid.Health <= 0 and not antiDie._reviving then
			antiDie._reviving = true
			pcall(function()
				Humanoid.Health = Humanoid.MaxHealth
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

				if Humanoid.Health > 0 then
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end
			end)
			task.delay(0.2, function()
				antiDie._reviving = false
			end)
		end
	end)
	antiDie.diedConn = Humanoid.Died:Connect(function()
		if not antiDie.enabled or not Character.Parent then
			return
		end

		if antiDie._reviving then
			return
		end

		antiDie._reviving = true
		task.defer(function()
			if antiDie.enabled and Character.Parent and Humanoid.Parent then
				pcall(function()
					Humanoid.Health = Humanoid.MaxHealth
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end)
				antiDie._reviving = false

				return
			end

			antiDie._reviving = false
		end)
	end)
end

antiDie.start = function()
	antiDie.enabled = true

	if antiDie.charConn then
		antiDie.charConn:Disconnect()
	end

	antiDie.charConn = LocalPlayer2.CharacterAdded:Connect(function(character)
		if antiDie.enabled then
			task.defer(function()
				v633(character)
			end)
		end
	end)
	task.defer(function()
		v633(LocalPlayer2.Character)
	end)
end
antiDie.stop = function()
	antiDie.enabled = false

	if antiDie.charConn then
		antiDie.charConn:Disconnect()
		antiDie.charConn = nil
	end

	local humanoid = antiDie.humanoid

	v632()

	if humanoid and humanoid.Parent then
		pcall(function()
			humanoid.BreakJointsOnDeath = true
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		end)
	end
end
_G.AntiDie = antiDie

local t18 = {}
local t19 = {}
local connection3
local n5 = 0

local function v641()
	for k in pairs(t18) do
		pcall(function()
			t18[k]:Destroy()
		end)
	end

	for k in pairs(t19) do
		for _, v in ipairs(t19[k]) do
			pcall(function()
				v.Visible = false
				v:Remove()
			end)
		end
	end

	t18 = {}
	t19 = {}
end
local function v646()
	if not Drawing or type(Drawing.new) ~= "function" then
		return nil
	end

	local v647 = getThemeColor()
	local Line = Drawing.new("Line")

	Line.Color = v647
	Line.Thickness = 2.2
	Line.Transparency = 0.9
	Line.Visible = false

	local Line2 = Drawing.new("Line")

	Line2.Color = v647
	Line2.Thickness = 1.2
	Line2.Transparency = 0.74
	Line2.Visible = false

	local Line3 = Drawing.new("Line")

	Line3.Color = v647
	Line3.Thickness = 0.6
	Line3.Transparency = 0.1
	Line3.Visible = false

	return {
		Line,
		Line2,
		Line3
	}
end
local function v651()
	local now = tick()

	if now - n5 < 0.05 then
		return
	end

	n5 = now

	if not espEnabled then
		v641()

		return
	end

	local Character = LocalPlayer2.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local v655, v656 = CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)
	local vector2 = Vector2.new(v655.X, v655.Y)
	local v658 = v42()
	local t20 = {}

	for _, v in ipairs(v658) do
		t20[v] = true
	end

	for k in pairs(t18) do
		if not t20[k] then
			pcall(function()
				t18[k]:Destroy()
			end)
			t18[k] = nil
		end
	end

	for k in pairs(t19) do
		if not t20[k] then
			for _, v in ipairs(t19[k]) do
				pcall(function()
					v.Visible = false
					v:Remove()
				end)
			end

			t19[k] = nil
		end
	end

	local v666 = getThemeColor()

	for _, v in ipairs(v658) do
		if v ~= LocalPlayer2 then
			local Character2 = v.Character

			if Character2 then
				local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
				local Head = Character2:FindFirstChild("Head")
				local Humanoid = Character2:FindFirstChildOfClass("Humanoid")

				if HumanoidRootPart2 and Head and Humanoid and Humanoid.Health > 0 then
					local Highlight = t18[v]

					if not Highlight or not Highlight.Parent or Highlight.Parent ~= Character2 then
						if Highlight then
							pcall(function()
								Highlight:Destroy()
							end)
						end

						Highlight = Instance.new("Highlight")
						Highlight.Name = "YoutESP"
						Highlight.FillColor = v666
						Highlight.FillTransparency = 0.72
						Highlight.OutlineColor = v666
						Highlight.OutlineTransparency = 0.05
						Highlight.Adornee = Character2
						Highlight.Parent = Character2
						t18[v] = Highlight
					end

					local v674 = t19[v]

					if not v674 then
						v674 = v646()
						t19[v] = v674 or {}
					end

					if v674 and #v674 > 0 then
						local v675, v676 = CurrentCamera:WorldToViewportPoint(HumanoidRootPart2.Position)

						if v676 and v675.Z > 0 and v656 then
							local vector22 = Vector2.new(v675.X, v675.Y)

							for _, v3 in ipairs(v674) do
								v3.From = vector2
								v3.To = vector22
								v3.Visible = true
							end
						else
							for _, v3 in ipairs(v674) do
								v3.Visible = false
							end
						end
					end
				else
					if t18[v] then
						pcall(function()
							t18[v]:Destroy()
						end)
						t18[v] = nil
					end

					if t19[v] then
						for _, v3 in ipairs(t19[v]) do
							pcall(function()
								v3.Visible = false
							end)
						end
					end
				end
			else
				if t18[v] then
					pcall(function()
						t18[v]:Destroy()
					end)
					t18[v] = nil
				end

				if t19[v] then
					for _, v3 in ipairs(t19[v]) do
						pcall(function()
							v3.Visible = false
						end)
					end
				end
			end
		end
	end
end
local function v686()
	if connection3 then
		connection3:Disconnect()
	end

	connection3 = RunService.RenderStepped:Connect(v651)
end
local function v687()
	if connection3 then
		connection3:Disconnect()
		connection3 = nil
	end

	v641()
end

toggleESP = function(p100)
	espEnabled = p100

	if p100 then
		v686()
	else
		v687()
	end

	if setESPVIsual then
		setESPVIsual(p100)
	end
end

local n6 = 0

updateEnemySpeedLabels = function()
	n6 += 1

	if n6 < 6 then
		return
	end

	n6 = 0

	local v689 = getThemeColor()
	local v690 = v42()

	for i = 1, #v690 do
		local v692 = v690[i]

		if v692 ~= LocalPlayer2 then
			local Character = v692.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart and Humanoid and Humanoid.Health > 0 then
				local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
				local v697 = math.sqrt(AssemblyLinearVelocity.X * AssemblyLinearVelocity.X + AssemblyLinearVelocity.Z * AssemblyLinearVelocity.Z)
				local v698 = enemySpeedLabels[v692]

				if v698 then
					if v698.Parent and v698.Parent.Parent ~= Character then
						local Head = Character:FindFirstChild("Head")

						if Head then
							v698.Parent.Parent = Head
						end
					end
				else
					local Head = Character:FindFirstChild("Head")

					if Head then
						local BillboardGui = Instance.new("BillboardGui")

						BillboardGui.Size = UDim2.new(0, 100, 0, 25)
						BillboardGui.StudsOffset = Vector3.new(0, 5.5, 0)
						BillboardGui.AlwaysOnTop = true
						BillboardGui.Name = "EnemySpeedGui"
						BillboardGui.Parent = Head

						local TextLabel2 = Instance.new("TextLabel", BillboardGui)

						TextLabel2.Size = UDim2.new(1, 0, 1, 0)
						TextLabel2.BackgroundTransparency = 1
						TextLabel2.TextColor3 = v689
						TextLabel2.Font = Enum.Font.GothamBlack
						TextLabel2.TextScaled = true
						TextLabel2.TextStrokeTransparency = 0
						TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						enemySpeedLabels[v692] = TextLabel2
						v698 = TextLabel2
					end
				end

				if v698 then
					v698.Text = string.format("%.1f", v697)

					if v698.TextColor3 ~= v689 then
						v698.TextColor3 = v689
					end
				end
			else
				local v703 = enemySpeedLabels[v692]

				if v703 and v703.Parent and v703.Parent.Parent then
					v703.Parent.Parent = nil
				end

				enemySpeedLabels[v692] = nil
			end
		end
	end
end
startEnemySpeed = function()
	if enemySpeedConn then
		enemySpeedConn:Disconnect()
	end

	enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end
stopEnemySpeed = function()
	if enemySpeedConn then
		enemySpeedConn:Disconnect()
		enemySpeedConn = nil
	end
end

local function v704()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil
	end

	local Position = HumanoidRootPart.Position
	local v708
	local huge = math.huge
	local v710 = v42()

	for i = 1, #v710 do
		local v712 = v710[i]

		if v712 ~= LocalPlayer2 then
			local Character2 = v712.Character

			if Character2 then
				local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 then
					local Humanoid = Character2:FindFirstChildOfClass("Humanoid")

					if Humanoid and Humanoid.Health > 0 then
						local v716 = HumanoidRootPart2.Position.X - Position.X
						local v717 = HumanoidRootPart2.Position.Y - Position.Y
						local v718 = HumanoidRootPart2.Position.Z - Position.Z
						local v719 = v716 * v716 + v717 * v717 + v718 * v718

						if v719 < huge then
							huge = v719
							v708 = HumanoidRootPart2
						end
					end
				end
			end
		end
	end

	return v708
end
local function v720()
	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	local v724 = v704()

	if not v724 then
		if not Humanoid.AutoRotate then
			Humanoid.AutoRotate = true
		end

		return
	end

	if bodyLockRange < (v724.Position - HumanoidRootPart.Position).Magnitude then
		if not Humanoid.AutoRotate then
			Humanoid.AutoRotate = true
		end

		return
	end

	if Humanoid.AutoRotate then
		Humanoid.AutoRotate = false
	end

	local AssemblyLinearVelocity = v724.AssemblyLinearVelocity
	local v726 = v724.Position + AssemblyLinearVelocity * math.clamp(AssemblyLinearVelocity.Magnitude / 80, 0.08, 0.35)
	local Head = v724.Parent and v724.Parent:FindFirstChild("Head")
	local vector3 = Vector3.new(v726.X, HumanoidRootPart.Position.Y + math.clamp(((Head and Head.Position.Y or v724.Position.Y) - (HumanoidRootPart.Position.Y + (Humanoid.HipHeight or 0))) * 0.15, -1.5, 1.5), v726.Z)

	if (vector3 - HumanoidRootPart.Position).Magnitude > 0.1 then
		local cFrame = CFrame.lookAt(HumanoidRootPart.Position, vector3)
		local _, v731 = (HumanoidRootPart.CFrame:Inverse() * cFrame):ToEulerAnglesXYZ()

		HumanoidRootPart.AssemblyAngularVelocity = HumanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(0, math.clamp(v731, -2.5, 2.5) * 42, 0))
	end
end

startBodyLock = function()
	if _bodyLockConn then
		_bodyLockConn:Disconnect()
	end

	local n7 = 0

	_bodyLockConn = RunService.Heartbeat:Connect(function(dt)
		if not bodyLockEnabled then
			return
		end

		if _blSuppressCount > 0 then
			return
		end

		n7 += dt

		if n7 < 0.033 then
			return
		end

		n7 = 0
		v720()
	end)
end
stopBodyLock = function()
	if _bodyLockConn then
		_bodyLockConn:Disconnect()
		_bodyLockConn = nil
	end

	local Character = LocalPlayer2.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X, -0.1, HumanoidRootPart.AssemblyLinearVelocity.Z)
	end

	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		Humanoid.AutoRotate = true
	end
end
_suppressBodyLock = function()
	_blSuppressCount += 1

	if _blSuppressCount == 1 and bodyLockEnabled then
		_blWasEnabled = true
		stopBodyLock()

		if bodyLockSetVisual then
			bodyLockSetVisual(false)
		end

		if _blRestoreTimer then
			task.cancel(_blRestoreTimer)
			_blRestoreTimer = nil
		end

		_blSmoothRestore = false
	end
end
_unsuppressBodyLock = function(p101)
	if _blSuppressCount > 0 then
		_blSuppressCount -= 1
	end

	if _blSuppressCount == 0 and _blWasEnabled then
		_blWasEnabled = false

		if _blRestoreTimer then
			pcall(task.cancel, _blRestoreTimer)
			_blRestoreTimer = nil
		end

		local function v737()
			_blRestoreTimer = nil

			if bodyLockEnabled then
				_blSmoothRestore = true
				startBodyLock()

				if bodyLockSetVisual then
					bodyLockSetVisual(true)
				end

				task.delay(0.5, function()
					_blSmoothRestore = false
				end)
			end
		end

		if p101 then
			_blRestoreTimer = task.delay(1, v737)
		else
			v737()
		end
	end
end
setupSpeedIndicator = function(p102)
	local Head = p102:WaitForChild("Head", 5)

	if not Head then
		return
	end

	local BloodHoundsSpeedIndicator = Head:FindFirstChild("BloodHoundsSpeedIndicator")

	if BloodHoundsSpeedIndicator then
		BloodHoundsSpeedIndicator:Destroy()
	end

	local BillboardGui = Instance.new("BillboardGui", Head)

	BillboardGui.Name = "BloodHoundsSpeedIndicator"
	BillboardGui.Size = UDim2.new(0, 240, 0, 70)
	BillboardGui.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)
	BillboardGui.AlwaysOnTop = true
	BillboardGui.LightInfluence = 0
	BillboardGui.MaxDistance = 300

	local UIListLayout = Instance.new("UIListLayout", BillboardGui)

	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 1)
	speedLabel = Instance.new("TextLabel", BillboardGui)
	speedLabel.Name = "SpeedLabel"
	speedLabel.LayoutOrder = 1
	speedLabel.Size = UDim2.new(1, 0, 0, 34)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "0.0  -  " .. getSpeedModeName()
	speedLabel.TextColor3 = getThemeColor()
	speedLabel.Font = Enum.Font.GothamBlack
	speedLabel.TextSize = 26
	speedLabel.TextXAlignment = Enum.TextXAlignment.Center
	speedLabel.TextYAlignment = Enum.TextYAlignment.Center
	speedLabel.TextStrokeTransparency = 0
	speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	speedLabel.RichText = false
	applyShimmerToText(speedLabel, 0.9)

	local TextLabel2 = Instance.new("TextLabel", BillboardGui)

	TextLabel2.Name = "DiscordText"
	TextLabel2.LayoutOrder = 2
	TextLabel2.Size = UDim2.new(1, 0, 0, 20)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "zlhub.net"
	TextLabel2.TextColor3 = getThemeColor()
	TextLabel2.Font = Enum.Font.GothamBlack
	TextLabel2.TextSize = 15
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel2.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel2.TextStrokeTransparency = 0
	TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel2.RichText = false
	applyShimmerToText(TextLabel2, 0.9)
end

local clone

startUnwalk = function()
	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		for _, v in ipairs(Humanoid:GetPlayingAnimationTracks()) do
			pcall(function()
				v:Stop()
			end)
		end
	end

	local Animate = Character:FindFirstChild("Animate")

	if Animate then
		clone = Animate:Clone()
		Animate:Destroy()
	end
end
stopUnwalk = function()
	local Character = LocalPlayer2.Character

	if Character and not Character:FindFirstChild("Animate") then
		local StarterCharacterScripts = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
		local Animate = StarterCharacterScripts and StarterCharacterScripts:FindFirstChild("Animate")

		if Animate then
			Animate:Clone().Parent = Character
		elseif clone then
			clone:Clone().Parent = Character
		end
	end

	clone = nil
end
refreshSpeedModeLabel = function()
	if modeValLbl then
		if laggerCarryToggled then
			modeValLbl.Text = "Lagger Carry"
		elseif laggerToggled then
			modeValLbl.Text = "Lagger Normal"
		elseif speedMode then
			modeValLbl.Text = "Carry"
		else
			modeValLbl.Text = "Normal"
		end
	end

	if setCarryModeVisual then
		setCarryModeVisual(speedMode)
	end

	if setLaggerModeVisual then
		setLaggerModeVisual(laggerToggled)
	end

	if setLaggerCarryVisual then
		setLaggerCarryVisual(laggerCarryToggled)
	end
end
resetMovementState = function()
	refreshSpeedModeLabel()

	if mobSetCarry then
		mobSetCarry(speedMode)
	end

	if setLaggerModeVisual then
		setLaggerModeVisual(laggerToggled)
	end

	if setLaggerCarryVisual then
		setLaggerCarryVisual(laggerCarryToggled)
	end
end
toggleCarryMode = function()
	if laggerToggled or laggerCarryToggled then
		laggerToggled = false
		laggerCarryToggled = false
		speedMode = true
	else
		speedMode = not speedMode
	end

	resetMovementState()
end
toggleLaggerMode = function()
	if laggerCarryToggled then
		laggerCarryToggled = false
	end

	speedMode = false
	laggerToggled = not laggerToggled
	resetMovementState()
end
toggleLaggerCarryMode = function()
	if laggerToggled then
		laggerToggled = false
	end

	speedMode = false
	laggerCarryToggled = not laggerCarryToggled
	resetMovementState()
end
toggleLaggerCycle = function()
	if speedMode then
		speedMode = false
		laggerToggled = true
		laggerCarryToggled = false
	elseif laggerToggled then
		speedMode = false
		laggerToggled = false
		laggerCarryToggled = true
	else
		speedMode = true
		laggerToggled = false
		laggerCarryToggled = false
	end

	resetMovementState()
end
stopAutoLeft = function()
	if alConn then
		alConn:Disconnect()
		alConn = nil
	end

	alPhase = 1

	local Character = LocalPlayer2.Character

	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid:Move(Vector3.zero, false)
		end
	end

	if autoLeftSetVisual then
		autoLeftSetVisual(false)
	end

	if mobSetAutoLeft then
		mobSetAutoLeft(false)
	end

	_unsuppressBodyLock(true)
end
startAutoLeft = function()
	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()

		if autoRightSetVisual then
			autoRightSetVisual(false)
		end

		if mobSetAutoRight then
			mobSetAutoRight(false)
		end
	end

	disableAllAimbots()
	_suppressBodyLock()

	if alConn then
		alConn:Disconnect()
	end

	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not autoLeftEnabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return
		end

		if alPhase == 1 then
			if (Vector3.new(AP.L1.X, HumanoidRootPart.Position.Y, AP.L1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
				alPhase = 2

				local v757 = AP.L2 - HumanoidRootPart.Position
				local Unit = Vector3.new(v757.X, 0, v757.Z).Unit

				Humanoid:Move(Unit, false)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * NS, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * NS)

				return
			end

			local v759 = AP.L1 - HumanoidRootPart.Position
			local Unit = Vector3.new(v759.X, 0, v759.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * NS, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * NS)
		elseif alPhase == 2 then
			if (Vector3.new(AP.L2.X, HumanoidRootPart.Position.Y, AP.L2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
				Humanoid:Move(Vector3.zero, false)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				autoLeftEnabled = false

				if alConn then
					alConn:Disconnect()
					alConn = nil
				end

				alPhase = 1

				if autoLeftSetVisual then
					autoLeftSetVisual(false)
				end

				if mobSetAutoLeft then
					mobSetAutoLeft(false)
				end

				_unsuppressBodyLock(true)

				local vector3 = Vector3.new(AP.L_FACE.X, HumanoidRootPart.Position.Y, AP.L_FACE.Z)

				if (vector3 - HumanoidRootPart.Position).Magnitude > 0.01 then
					HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, vector3)
				end

				return
			end

			local v762 = AP.L2 - HumanoidRootPart.Position
			local Unit = Vector3.new(v762.X, 0, v762.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * NS, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * NS)
		end
	end)
end
stopAutoRight = function()
	if arConn then
		arConn:Disconnect()
		arConn = nil
	end

	arPhase = 1

	local Character = LocalPlayer2.Character

	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid:Move(Vector3.zero, false)
		end
	end

	if autoRightSetVisual then
		autoRightSetVisual(false)
	end

	if mobSetAutoRight then
		mobSetAutoRight(false)
	end

	_unsuppressBodyLock(true)
end
startAutoRight = function()
	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()

		if autoLeftSetVisual then
			autoLeftSetVisual(false)
		end

		if mobSetAutoLeft then
			mobSetAutoLeft(false)
		end
	end

	disableAllAimbots()
	_suppressBodyLock()

	if arConn then
		arConn:Disconnect()
	end

	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not autoRightEnabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return
		end

		if arPhase == 1 then
			if (Vector3.new(AP.R1.X, HumanoidRootPart.Position.Y, AP.R1.Z) - HumanoidRootPart.Position).Magnitude < 1 then
				arPhase = 2

				local v769 = AP.R2 - HumanoidRootPart.Position
				local Unit = Vector3.new(v769.X, 0, v769.Z).Unit

				Humanoid:Move(Unit, false)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * NS, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * NS)

				return
			end

			local v771 = AP.R1 - HumanoidRootPart.Position
			local Unit = Vector3.new(v771.X, 0, v771.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * NS, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * NS)
		elseif arPhase == 2 then
			if (Vector3.new(AP.R2.X, HumanoidRootPart.Position.Y, AP.R2.Z) - HumanoidRootPart.Position).Magnitude < 1 then
				Humanoid:Move(Vector3.zero, false)
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				autoRightEnabled = false

				if arConn then
					arConn:Disconnect()
					arConn = nil
				end

				arPhase = 1

				if autoRightSetVisual then
					autoRightSetVisual(false)
				end

				if mobSetAutoRight then
					mobSetAutoRight(false)
				end

				_unsuppressBodyLock(true)

				local vector3 = Vector3.new(AP.R_FACE.X, HumanoidRootPart.Position.Y, AP.R_FACE.Z)

				if (vector3 - HumanoidRootPart.Position).Magnitude > 0.01 then
					HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, vector3)
				end

				return
			end

			local v774 = AP.R2 - HumanoidRootPart.Position
			local Unit = Vector3.new(v774.X, 0, v774.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(Unit.X * NS, HumanoidRootPart.AssemblyLinearVelocity.Y, Unit.Z * NS)
		end
	end)
end
getClosestTarget = function()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil
	end

	local Position = HumanoidRootPart.Position
	local v779
	local huge = math.huge
	local v781 = v42()

	for i = 1, #v781 do
		local v783 = v781[i]

		if v783 ~= LocalPlayer2 then
			local Character2 = v783.Character

			if Character2 then
				local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart2 then
					local Humanoid = Character2:FindFirstChildOfClass("Humanoid")

					if Humanoid and Humanoid.Health > 0 then
						local v787 = HumanoidRootPart2.Position.X - Position.X
						local v788 = HumanoidRootPart2.Position.Y - Position.Y
						local v789 = HumanoidRootPart2.Position.Z - Position.Z
						local v790 = v787 * v787 + v788 * v788 + v789 * v789

						if v790 < huge then
							huge = v790
							v779 = HumanoidRootPart2
						end
					end
				end
			end
		end
	end

	return v779
end
trySwing = function()
	pcall(function()
		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local Tool = Character:FindFirstChildOfClass("Tool")

		if Tool and not isBatTool(Tool) then
			return
		end

		local v793 = findBat()

		if v793 then
			if v793.Parent ~= Character then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					pcall(function()
						Humanoid:EquipTool(v793)
					end)
				end
			end

			pcall(function()
				v793:Activate()
			end)
		end
	end)
end
stopAimbotAdapt = function()
	if _aimbotConn then
		pcall(function()
			_aimbotConn:Disconnect()
		end)
		_aimbotConn = nil
	end

	local Character = LocalPlayer2.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		local autoRotate = _prevAutoRotate == nil and true

		Humanoid.AutoRotate = autoRotate or _prevAutoRotate
		Humanoid.PlatformStand = false
		pcall(function()
			Humanoid:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end

	if HumanoidRootPart then
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
		HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
	end

	_prevAutoRotate = nil
	lastMoveDir = Vector3.zero
	_unsuppressBodyLock(true)
end
startAimbotAdapt = function()
	if _aimbotConn then
		return
	end

	_suppressBodyLock()

	local Humanoid = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		if _prevAutoRotate == nil then
			_prevAutoRotate = Humanoid.AutoRotate
		end

		Humanoid.AutoRotate = false
	end

	_aimbotConn = RunService.RenderStepped:Connect(function()
		if not autoBatEnabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid2 then
			return
		end

		if not Character:FindFirstChildOfClass("Tool") then
			local v803 = findBat()

			if v803 then
				pcall(function()
					Humanoid2:EquipTool(v803)
				end)
			end
		end

		local v804 = getClosestTarget()

		if not v804 then
			return
		end

		local AssemblyLinearVelocity = v804.AssemblyLinearVelocity
		local Position = HumanoidRootPart.Position
		local Position2 = v804.Position
		local v808 = Position2 + AssemblyLinearVelocity * 0.14 + v804.CFrame.LookVector * 0.3 - Position
		local vector3 = Vector3.new(v808.X, 0, v808.Z)
		local Unit

		if vector3.Magnitude > 0 then
			Unit = vector3.Unit
		else
			Unit = Vector3.new(0, 0, 0)
		end

		local v811 = (Position2.Y + 3.7 - Position.Y) * 19.5 + AssemblyLinearVelocity.Y * 0.8

		if Humanoid2.FloorMaterial ~= Enum.Material.Air then
			v811 = math.max(v811, 13)
		end

		HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity:Lerp(Vector3.new(Unit.X * BAT_AIMBOT_SPEED, math.clamp(v811, -70, 110), Unit.Z * BAT_AIMBOT_SPEED), 0.8)

		local v812 = Position2 + AssemblyLinearVelocity * math.clamp(AssemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

		if (v812 - Position).Magnitude > 0.1 then
			local cFrame = CFrame.lookAt(Position, v812)
			local v814, v815, v816 = (HumanoidRootPart.CFrame:Inverse() * cFrame):ToEulerAnglesXYZ()

			HumanoidRootPart.AssemblyAngularVelocity = HumanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(math.clamp(v814, -2.5, 2.5) * 42, math.clamp(v815, -2.5, 2.5) * 42, math.clamp(v816, -2.5, 2.5) * 42))
		end

		if (HumanoidRootPart.Position - v804.Position).Magnitude <= 8 then
			trySwing()
		end
	end)
end
disableAutoBat = function()
	autoBatEnabled = false

	if autoBatSetVisual then
		autoBatSetVisual(false)
	end

	if mobSetAutoBat then
		mobSetAutoBat(false)
	end

	stopAimbotAdapt()
end
enableAutoBat = function()
	if autoLeftEnabled then
		autoLeftEnabled = false

		if autoLeftSetVisual then
			autoLeftSetVisual(false)
		end

		stopAutoLeft()
	end

	if autoRightEnabled then
		autoRightEnabled = false

		if autoRightSetVisual then
			autoRightSetVisual(false)
		end

		stopAutoRight()
	end

	if batDesyncTpEnabled then
		toggleBatDesyncTp()
	end

	if autoBatV2Enabled then
		disableBatV2()
	end

	autoBatEnabled = true

	if autoBatSetVisual then
		autoBatSetVisual(true)
	end

	if mobSetAutoBat then
		mobSetAutoBat(true)
	end

	startAimbotAdapt()
end

local function v817(p103)
	if tpBatFloatingButton then
		local Frame = tpBatFloatingButton:FindFirstChild("Frame")

		if Frame then
			local TextLabel2 = Frame:FindFirstChild("TextLabel")

			if p103 then
				Frame.BackgroundColor3 = getThemeColor()

				if TextLabel2 then
					TextLabel2.Text = "TP\nBAT"
					TextLabel2.TextColor3 = Color3.fromRGB(0, 0, 0)
				end
			else
				if TextLabel2 then
					TextLabel2.Text = "TP\nBAT"
				end

				paintFloatingBtn(Frame, batDesyncTpEnabled)
			end
		end
	end
end

local tpBatEnabled = false
local connection4
local tpBat
local u823 = false
local u824 = false

tpBatMode = "V1"
hittingCooldownDesyncV2 = false
hittingCooldownDesyncV3 = false
tpBatV2LastRepos = 0
setTpBatModeVisual = nil

local function v825()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	local Bat = Character:FindFirstChild("Bat")

	if Bat then
		return Bat
	end

	local Backpack = LocalPlayer2:FindFirstChild("Backpack")

	if Backpack then
		local Bat2 = Backpack:FindFirstChild("Bat")

		if Bat2 then
			Bat2.Parent = Character

			return Bat2
		end
	end

	return nil
end
local function v830()
	if u823 then
		return
	end

	u823 = true
	pcall(function()
		local v831 = v825()

		if v831 then
			v831:Activate()

			local RemoteEvent = v831:FindFirstChildWhichIsA("RemoteEvent")

			if RemoteEvent then
				RemoteEvent:FireServer()
			end
		end
	end)
	task.delay(0.08, function()
		u823 = false
	end)
end
local function v833()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil, math.huge
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil, math.huge
	end

	local Position = HumanoidRootPart.Position
	local v837
	local huge = math.huge

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer2 and player.Character then
			local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart2 then
				local Magnitude = (Position - HumanoidRootPart2.Position).Magnitude

				if Magnitude < huge then
					huge = Magnitude
					v837 = player
				end
			end
		end
	end

	return v837, huge
end
local function v843()
	if not tpBatEnabled then
		stopBatDesyncTp()

		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local v846 = v833()

	if v846 and v846.Character then
		local HumanoidRootPart2 = v846.Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart2 then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(HumanoidRootPart, "PhysicsRepRootPart", HumanoidRootPart2)
				end)
			end

			local v848 = HumanoidRootPart2.Position + Vector3.new(0, 0.9, 0)

			if (HumanoidRootPart.Position - v848).Magnitude > 8 then
				HumanoidRootPart.CFrame = CFrame.new(v848)
			end

			local CurrentCamera2 = workspace.CurrentCamera

			if CurrentCamera2 then
				CurrentCamera2.CFrame = CFrame.new(CurrentCamera2.CFrame.Position, HumanoidRootPart2.Position)
			end

			v830()
		end
	end
end
local function v850()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	local Bat = Character:FindFirstChild("Bat")

	if Bat then
		return Bat
	end

	local Backpack = LocalPlayer2:FindFirstChild("Backpack")

	if Backpack then
		local Bat2 = Backpack:FindFirstChild("Bat")

		if Bat2 then
			Bat2.Parent = Character

			return Bat2
		end
	end

	return nil
end
local function v855(p104)
	for _, descendant in ipairs(p104:GetDescendants()) do
		if descendant:IsA("RemoteEvent") then
			pcall(function()
				descendant:FireServer()
			end)
		elseif descendant:IsA("RemoteFunction") then
			pcall(function()
				descendant:InvokeServer()
			end)
		end
	end
end
local function v858()
	if hittingCooldownDesyncV2 then
		return
	end

	hittingCooldownDesyncV2 = true
	pcall(function()
		local v859 = v850()

		if v859 then
			local Character = LocalPlayer2.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

			if Humanoid and v859.Parent ~= Character then
				pcall(function()
					Humanoid:EquipTool(v859)
				end)
			end

			if v859:IsA("Tool") then
				v859:Activate()
			end

			v855(v859)
		end
	end)
	task.delay(0.05, function()
		hittingCooldownDesyncV2 = false
	end)
end
local function v862()
	if not tpBatEnabled then
		stopBatDesyncTp()

		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not HumanoidRootPart or not Humanoid then
		return
	end

	local v866 = v833()

	if v866 and v866.Character then
		local HumanoidRootPart2 = v866.Character:FindFirstChild("HumanoidRootPart")
		local Humanoid2 = v866.Character:FindFirstChildOfClass("Humanoid")

		if HumanoidRootPart2 and Humanoid2 and Humanoid2.Health > 0 then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(HumanoidRootPart, "PhysicsRepRootPart", HumanoidRootPart2)
				end)
			end

			local v869 = HumanoidRootPart2.Position + Vector3.new(0, TP_BAT_V2_HEIGHT_OFFSET, 0)
			local v870 = HumanoidRootPart.Position - HumanoidRootPart2.Position
			local vector3 = Vector3.new(v870.X, 0, v870.Z)

			if vector3.Magnitude < 0.1 then
				vector3 = HumanoidRootPart2.CFrame.LookVector * -1
			end

			local v872 = HumanoidRootPart2.Position + vector3.Unit * TP_BAT_V2_DESIRED_DIST + Vector3.new(0, TP_BAT_V2_HEIGHT_OFFSET - 1, 0)
			local now = tick()
			local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude

			if (TP_BAT_V2_KEEP_RANGE < Magnitude or Magnitude < TP_BAT_V2_MIN_DIST) and TP_BAT_V2_REPOS_CD < now - tpBatV2LastRepos then
				HumanoidRootPart.CFrame = CFrame.lookAt(v872, v869)
				tpBatV2LastRepos = now
			else
				HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, v869)
			end

			local CurrentCamera2 = workspace.CurrentCamera

			if CurrentCamera2 then
				CurrentCamera2.CFrame = CFrame.lookAt(CurrentCamera2.CFrame.Position, v869, Vector3.new(0, 1, 0))
			end

			v858()
		end
	end
end

local t21 = {
	"Bat",
	"Slap",
	"Iron Slap",
	"Gold Slap",
	"Diamond Slap",
	"Emerald Slap",
	"Ruby Slap",
	"Dark Matter Slap",
	"Flame Slap",
	"Nuclear Slap",
	"Galaxy Slap",
	"Glitched Slap"
}

local function v877()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	for _, v in ipairs(t21) do
		local v881 = Character:FindFirstChild(v)

		if v881 and v881:IsA("Tool") then
			return v881
		end
	end

	local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")

	if Backpack then
		for _, v in ipairs(t21) do
			local v885 = Backpack:FindFirstChild(v)

			if v885 and v885:IsA("Tool") then
				v885.Parent = Character

				return v885
			end
		end
	end

	return nil
end
local function v886()
	if hittingCooldownDesyncV3 then
		return
	end

	hittingCooldownDesyncV3 = true
	pcall(function()
		local v887 = v877()

		if not v887 then
			return
		end

		v887:Activate()

		local RemoteEvent = v887:FindFirstChildWhichIsA("RemoteEvent")

		if RemoteEvent then
			RemoteEvent:FireServer()
		end
	end)
	task.delay(0.08, function()
		hittingCooldownDesyncV3 = false
	end)
end
local function v889()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil, math.huge
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil, math.huge
	end

	local v892
	local huge = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer2 and player.Character then
			local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
				local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude

				if Magnitude < huge then
					huge = Magnitude
					v892 = player
				end
			end
		end
	end

	return v892, huge
end
local function v899()
	if not tpBatEnabled then
		stopBatDesyncTp()

		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local v902 = v889()

	if not v902 or not v902.Character then
		return
	end

	local HumanoidRootPart2 = v902.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart2 then
		return
	end

	if sethiddenproperty then
		pcall(sethiddenproperty, HumanoidRootPart, "PhysicsRepRootPart", HumanoidRootPart2)
	end

	local v904 = HumanoidRootPart2.Position + Vector3.new(0, 0.9, 0)

	if (HumanoidRootPart.Position - v904).Magnitude > 8 then
		HumanoidRootPart.CFrame = CFrame.new(v904)
	end

	if workspace.CurrentCamera then
		workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, HumanoidRootPart2.Position)
	end

	v886()
end
local function v905()
	if tpBatMode == "V3" then
		v899()
	elseif tpBatMode == "V2" then
		v862()
	else
		v843()
	end
end

startBatDesyncTp = function()
	if connection4 then
		return
	end

	if not unwalkEnabled then
		startUnwalk()
		unwalkEnabled = true
		u824 = true

		if setUnwalkVisual then
			setUnwalkVisual(true)
		end
	end

	tpBatEnabled = true
	tpBatV2LastRepos = 0
	connection4 = RunService.Heartbeat:Connect(v905)

	if tpBat then
		tpBat(true)
	end

	v817(true)
end
stopBatDesyncTp = function()
	if connection4 then
		connection4:Disconnect()
		connection4 = nil
	end

	tpBatEnabled = false

	if u824 then
		stopUnwalk()
		unwalkEnabled = false
		u824 = false

		if setUnwalkVisual then
			setUnwalkVisual(false)
		end
	end

	if tpBat then
		tpBat(false)
	end

	v817(false)
end
toggleBatDesyncTp = function()
	if tpBatEnabled then
		stopBatDesyncTp()
		v817(false)
	else
		disableAllAimbots()

		if autoLeftEnabled then
			autoLeftEnabled = false
			stopAutoLeft()

			if autoLeftSetVisual then
				autoLeftSetVisual(false)
			end

			if mobSetAutoLeft then
				mobSetAutoLeft(false)
			end
		end

		if autoRightEnabled then
			autoRightEnabled = false
			stopAutoRight()

			if autoRightSetVisual then
				autoRightSetVisual(false)
			end

			if mobSetAutoRight then
				mobSetAutoRight(false)
			end
		end

		startBatDesyncTp()
		v817(true)
	end

	if tpBat then
		tpBat(tpBatEnabled)
	end

	saveAllSettings()
end

local function v906()
	local Character = LocalPlayer2.Character

	if Character then
		for _, child in ipairs(Character:GetChildren()) do
			if child:IsA("Tool") then
				return child
			end
		end
	end

	local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")

	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") then
				return child
			end
		end
	end

	return nil
end
local function v913()
	local HumanoidRootPart = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil, math.huge
	end

	local Position = HumanoidRootPart.Position
	local v916
	local huge = math.huge
	local v918 = v42()

	for i = 1, #v918 do
		local v920 = v918[i]

		if v920 ~= LocalPlayer2 then
			local Character = v920.Character

			if Character then
				local HumanoidRootPart2 = Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
					local v924 = Position.X - HumanoidRootPart2.Position.X
					local v925 = Position.Y - HumanoidRootPart2.Position.Y
					local v926 = Position.Z - HumanoidRootPart2.Position.Z
					local v927 = math.sqrt(v924 * v924 + v925 * v925 + v926 * v926)

					if v927 < huge then
						huge = v927
						v916 = v920
					end
				end
			end
		end
	end

	return v916, huge
end
local function v928()
	if not autoBatV2HitCooldown then
		if autoBatV2SwingEnabled then
			autoBatV2HitCooldown = true

			local Character = LocalPlayer2.Character

			if Character then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local v931 = v906()

				if v931 then
					if v931.Parent ~= Character and Humanoid then
						pcall(function()
							Humanoid:EquipTool(v931)
						end)
					end

					local RemoteEvent = v931:FindFirstChildOfClass("RemoteEvent")

					if RemoteEvent then
						pcall(function()
							RemoteEvent:FireServer()
						end)
					else
						pcall(function()
							v931:Activate()
						end)
					end
				end
			end

			task.delay(AUTO_BAT_V2_SWING_CD, function()
				autoBatV2HitCooldown = false
			end)

			return
		end
	end
end
local function v933()
	if _batV2Conn then
		return
	end

	_batV2Conn = RunService.Heartbeat:Connect(function()
		if not autoBatV2Enabled then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return
		end

		local v937 = v913()

		if v937 and v937.Character then
			local HumanoidRootPart2 = v937.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart2 then
				local AssemblyLinearVelocity = HumanoidRootPart2.AssemblyLinearVelocity or HumanoidRootPart2.Velocity
				local v941 = HumanoidRootPart2.Position + ((AssemblyLinearVelocity.Magnitude > 0.1 and AssemblyLinearVelocity.Unit or HumanoidRootPart2.CFrame.LookVector) * AUTO_BAT_V2_DIST + Vector3.new(0, AUTO_BAT_V2_HEIGHT + AUTO_BAT_V2_V_OFF, 0)) - HumanoidRootPart.Position

				if v941.Magnitude > 0.5 then
					local v942 = v941.Unit * AUTO_BAT_V2_SPEED

					HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(v942.X, v942.Y, v942.Z)
				else
					HumanoidRootPart.AssemblyLinearVelocity *= 0.95

					if HumanoidRootPart.AssemblyLinearVelocity.Magnitude < 1 then
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					end
				end

				if (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude <= AUTO_BAT_V2_HIT_DIST then
					v928()
				end
			end
		else
			HumanoidRootPart.AssemblyLinearVelocity *= 0.9

			if HumanoidRootPart.AssemblyLinearVelocity.Magnitude < 1 then
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			end
		end
	end)
end
local function v943()
	if _batV2Conn then
		_batV2Conn:Disconnect()
		_batV2Conn = nil
	end

	local Character = LocalPlayer2.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
	end

	autoBatV2HitCooldown = false
end

enableBatV2 = function()
	if autoBatV2Enabled then
		return
	end

	if autoBatEnabled then
		disableAutoBat()
	end

	if tpBatEnabled then
		toggleBatDesyncTp()
	end

	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()

		if autoLeftSetVisual then
			autoLeftSetVisual(false)
		end

		if mobSetAutoLeft then
			mobSetAutoLeft(false)
		end
	end

	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()

		if autoRightSetVisual then
			autoRightSetVisual(false)
		end

		if mobSetAutoRight then
			mobSetAutoRight(false)
		end
	end

	autoBatV2Enabled = true
	v933()

	if autoBatV2SetVisual then
		autoBatV2SetVisual(true)
	end

	if batV2FloatingButton then
		local Frame = batV2FloatingButton:FindFirstChild("Frame")

		if Frame then
			paintFloatingBtn(Frame, true)
		end
	end
end
disableBatV2 = function()
	if not autoBatV2Enabled then
		return
	end

	autoBatV2Enabled = false
	v943()

	if autoBatV2SetVisual then
		autoBatV2SetVisual(false)
	end

	if batV2FloatingButton then
		local Frame = batV2FloatingButton:FindFirstChild("Frame")

		if Frame then
			paintFloatingBtn(Frame, false)
		end
	end
end
toggleBatV2 = function()
	if autoBatV2Enabled then
		disableBatV2()
	else
		enableBatV2()
	end
end
findBat = function()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	for _, v in ipairs(BAT_COUNTER_SLAP_LIST) do
		local v951 = Character:FindFirstChild(v)

		if v951 then
			if v951:IsA("Tool") then
				return v951
			end
		end
	end

	local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")

	if Backpack then
		for _, v in ipairs(BAT_COUNTER_SLAP_LIST) do
			local v955 = Backpack:FindFirstChild(v)

			if v955 and v955:IsA("Tool") then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					pcall(function()
						Humanoid:EquipTool(v955)
					end)
				end

				return v955
			end
		end
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Tool") then
			if child.Name:lower():find("bat") then
				return child
			end

			if child.Name:lower():find("slap") then
				return child
			end
		end
	end

	return nil
end
isBatTool = function(p105)
	if not p105 then
		return false
	end

	for _, v in ipairs(BAT_COUNTER_SLAP_LIST) do
		if p105.Name == v then
			return true
		end
	end

	return p105.Name:lower():find("bat") or p105.Name:lower():find("slap")
end
findBatForCounter = function()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	local Backpack = LocalPlayer2:FindFirstChildOfClass("Backpack")

	for _, v in ipairs(BAT_COUNTER_SLAP_LIST) do
		local v965 = Character:FindFirstChild(v) or Backpack and Backpack:FindFirstChild(v)

		if v965 then
			return v965
		end
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Tool") then
			if child.Name:lower():find("bat") then
				return child
			end

			if child.Name:lower():find("slap") then
				return child
			end
		end
	end

	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") then
				if child.Name:lower():find("bat") then
					return child
				end

				if child.Name:lower():find("slap") then
					return child
				end
			end
		end
	end

	return nil
end
swingBatForCounter = function(p106, p107)
	local Humanoid = p107:FindFirstChildOfClass("Humanoid")

	if p106.Parent ~= p107 and Humanoid then
		pcall(function()
			Humanoid:EquipTool(p106)
		end)
		task.wait(0.05)
	end

	local RemoteEvent = p106:FindFirstChildOfClass("RemoteEvent") or p106:FindFirstChildOfClass("RemoteFunction")

	if RemoteEvent and RemoteEvent:IsA("RemoteEvent") then
		pcall(function()
			RemoteEvent:FireServer()
		end)
		task.wait(0.1)
		pcall(function()
			RemoteEvent:FireServer()
		end)
	else
		pcall(function()
			p106:Activate()
		end)
		task.wait(0.1)
		pcall(function()
			p106:Activate()
		end)
	end
end
batCounterDebounce = false
stopBatCounter = function()
	if Conns.batCounter then
		Conns.batCounter:Disconnect()
		Conns.batCounter = nil
	end

	batCounterDebounce = false
end
startBatCounter = function()
	if Conns.batCounter then
		return
	end

	Conns.batCounter = RunService.Heartbeat:Connect(function()
		if not batCounterEnabled then
			return
		end

		if batCounterDebounce then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return
		end

		local state = Humanoid:GetState()

		if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
			batCounterDebounce = true
			_suppressBodyLock()
			task.spawn(function()
				task.wait(0.15)

				local v975 = findBatForCounter()

				if v975 then
					swingBatForCounter(v975, Character)
				end

				task.wait(0.3)
				batCounterDebounce = false
				_unsuppressBodyLock(true)
			end)
		end
	end)
end
findMedusa = function()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Tool") then
			local v979 = child.Name:lower()

			if v979:find("medusa") or v979:find("head") or v979:find("stone") then
				return child
			end
		end
	end

	local Backpack = LocalPlayer2:FindFirstChild("Backpack")

	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") then
				local v983 = child.Name:lower()

				if v983:find("medusa") or v983:find("head") or v983:find("stone") then
					return child
				end
			end
		end
	end

	return nil
end
useMedusaCounter = function()
	if medusaDebounce then
		return
	end

	if tick() - medusaLastUsed < MEDUSA_COOLDOWN then
		return
	end

	local Character = LocalPlayer2.Character

	if not Character then
		return
	end

	medusaDebounce = true

	local v985 = findMedusa()

	if not v985 then
		medusaDebounce = false

		return
	end

	if v985.Parent ~= Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid:EquipTool(v985)
		end
	end

	pcall(function()
		v985:Activate()
	end)
	medusaLastUsed = tick()
	medusaDebounce = false
end
onAnchorChanged = function(p108)
	return p108:GetPropertyChangedSignal("Anchored"):Connect(function()
		if medusaCounterEnabled and p108.Anchored and p108.Transparency == 1 then
			useMedusaCounter()
		end
	end)
end
setupMedusaCounter = function(p109)
	for _, v in pairs(Conns.anchor) do
		pcall(function()
			v:Disconnect()
		end)
	end

	Conns.anchor = {}

	if not p109 or not medusaCounterEnabled then
		return
	end

	for _, descendant in ipairs(p109:GetDescendants()) do
		if descendant:IsA("BasePart") then
			table.insert(Conns.anchor, onAnchorChanged(descendant))
		end
	end

	table.insert(Conns.anchor, p109.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("BasePart") then
			table.insert(Conns.anchor, onAnchorChanged(descendant))
		end
	end))
end
stopMedusaCounter = function()
	for _, v in pairs(Conns.anchor) do
		pcall(function()
			v:Disconnect()
		end)
	end

	Conns.anchor = {}
end

local connection5

stopDropBrainrot = function()
	dropActive = false

	if connection5 then
		connection5:Disconnect()
		connection5 = nil
	end

	for _, v in ipairs(dropConnections) do
		if type(v) == "thread" then
			pcall(task.cancel, v)
		elseif type(v) == "RBXScriptConnection" then
			pcall(v.Disconnect, v)
		end
	end

	dropConnections = {}

	local Character = LocalPlayer2.Character

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
		end
	end

	if dropBrainrotSetVisual then
		dropBrainrotSetVisual(false)
	end

	if mobSetDropBR then
		mobSetDropBR(false)
	end
end
runDropBrainrot = function()
	if dropActive then
		return
	end

	local Character = LocalPlayer2.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

	if not HumanoidRootPart or not Humanoid then
		return
	end

	if dropMode ~= 1 then
		if autoBatEnabled then
			autoBatEnabled = false

			if autoBatSetVisual then
				autoBatSetVisual(false)
			end

			if mobSetAutoBat then
				mobSetAutoBat(false)
			end

			if stopAimbotAdapt then
				stopAimbotAdapt()
			end
		end

		dropActive = true

		if dropBrainrotSetVisual then
			dropBrainrotSetVisual(true)
		end

		if mobSetDropBR then
			mobSetDropBR(true)
		end

		local now = tick()

		if connection5 then
			connection5:Disconnect()
		end

		connection5 = RunService.Heartbeat:Connect(function()
			local HumanoidRootPart2 = Character and Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart2 then
				if connection5 then
					connection5:Disconnect()
					connection5 = nil
				end

				dropActive = false

				if dropBrainrotSetVisual then
					dropBrainrotSetVisual(false)
				end

				if mobSetDropBR then
					mobSetDropBR(false)
				end

				return
			end

			if not (tick() - now >= 0.2) then
				HumanoidRootPart2.Velocity = Vector3.new(HumanoidRootPart2.Velocity.X, 150, HumanoidRootPart2.Velocity.Z)

				return
			end

			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end

			local raycastParams = RaycastParams.new()

			raycastParams.FilterDescendantsInstances = { Character }
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude

			local hit = workspace:Raycast(HumanoidRootPart2.Position, Vector3.new(0, -2000, 0), raycastParams)

			if hit then
				local Humanoid2 = Character:FindFirstChildOfClass("Humanoid")

				HumanoidRootPart2.CFrame = CFrame.new(HumanoidRootPart2.Position.X, hit.Position.Y + ((Humanoid2 and Humanoid2.HipHeight or 2) + HumanoidRootPart2.Size.Y / 2), HumanoidRootPart2.Position.Z)
				HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
			end

			dropActive = false

			if dropBrainrotSetVisual then
				dropBrainrotSetVisual(false)
			end

			if mobSetDropBR then
				mobSetDropBR(false)
			end
		end)

		return
	end

	local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
	local v1007 = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude > 5 and 0.6 or 0.25

	if tick() - lastDropTime < v1007 then
		return
	end

	lastDropTime = tick()
	dropActive = true

	if dropBrainrotSetVisual then
		dropBrainrotSetVisual(true)
	end

	if mobSetDropBR then
		mobSetDropBR(true)
	end

	local v1008 = false

	if autoBatEnabled then
		v1008 = true
		disableAutoBat()

		if autoBatSetVisual then
			autoBatSetVisual(false)
		end

		if mobSetAutoBat then
			mobSetAutoBat(false)
		end
	end

	local function v1009(p110)
		if p110 and dropConnections then
			for i = #dropConnections, 1, -1 do
				if dropConnections[i] == p110 then
					table.remove(dropConnections, i)

					break
				end
			end
		end

		dropActive = false

		local Character2 = LocalPlayer2.Character

		if Character2 then
			local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
			local Humanoid2 = Character2:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart2 then
				HumanoidRootPart2.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart2.AssemblyAngularVelocity = Vector3.zero

				if HumanoidRootPart2.Position.Y < -100 then
					HumanoidRootPart2.CFrame = CFrame.new(HumanoidRootPart2.Position.X, 5, HumanoidRootPart2.Position.Z)
				end

				local raycastParams = RaycastParams.new()

				raycastParams.FilterDescendantsInstances = { Character2 }
				raycastParams.FilterType = Enum.RaycastFilterType.Exclude

				local hit = workspace:Raycast(HumanoidRootPart2.Position, Vector3.new(0, -2000, 0), raycastParams)

				if hit then
					HumanoidRootPart2.CFrame = CFrame.new(HumanoidRootPart2.Position.X, hit.Position.Y + ((Humanoid2 and Humanoid2.HipHeight or 2) + HumanoidRootPart2.Size.Y / 2), HumanoidRootPart2.Position.Z)
				end

				if Humanoid2 and Humanoid2.Health > 0 then
					Humanoid2:ChangeState(Enum.HumanoidStateType.Running)
				end
			end
		end

		if v1008 then
			enableAutoBat()

			if autoBatSetVisual then
				autoBatSetVisual(true)
			end

			if mobSetAutoBat then
				mobSetAutoBat(true)
			end
		end

		if dropBrainrotSetVisual then
			dropBrainrotSetVisual(false)
		end

		if mobSetDropBR then
			mobSetDropBR(false)
		end
	end

	local thread

	thread = task.spawn(function()
		local now = tick()

		while dropActive and tick() - now < 0.25 do
			RunService.Heartbeat:Wait()

			local Character2 = LocalPlayer2.Character
			local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart2 then
				break
			end

			local vector3 = Vector3.new(0, HumanoidRootPart2.AssemblyLinearVelocity.Y, 0)

			HumanoidRootPart2.AssemblyLinearVelocity = vector3 * 10000 + Vector3.new(0, 10000, 0)
			RunService.RenderStepped:Wait()

			if HumanoidRootPart2.Parent then
				HumanoidRootPart2.AssemblyLinearVelocity = vector3
			end

			RunService.Stepped:Wait()

			if HumanoidRootPart2.Parent then
				HumanoidRootPart2.AssemblyLinearVelocity = vector3 + Vector3.new(0, 0.1, 0)
			end
		end

		v1009(thread)
	end)
	table.insert(dropConnections, thread)
	task.delay(0.35, function()
		if dropActive then
			v1009(thread)
		end
	end)
end
executeDropWithToggle = function(p111)
	if dropActive then
		return
	end

	task.spawn(function()
		if p111 then
			p111(true)
		end

		runDropBrainrot()

		while dropActive do
			task.wait()
		end

		task.wait(0.1)

		if p111 then
			p111(false)
		end
	end)
end
applyAntiLagDerender = function(p112)
	pcall(function()
		if p112:IsA("BasePart") then
			p112.Material = Enum.Material.Plastic
			p112.Reflectance = 0
			p112.CastShadow = false
		elseif p112:IsA("Decal") or p112:IsA("Texture") then
			p112.Transparency = 1
		elseif p112:IsA("ParticleEmitter") or p112:IsA("Trail") or p112:IsA("Beam") or p112:IsA("Fire") or p112:IsA("Smoke") or p112:IsA("Sparkles") then
			p112.Enabled = false
		elseif p112:IsA("AnimationController") or p112:IsA("Animator") then
			for _, v in ipairs(p112:GetPlayingAnimationTracks()) do
				pcall(function()
					v:Stop(0)
				end)
			end
		end
	end)
end
enableAntiLag = function()
	antiLagEnabled = true
	task.spawn(function()
		local descendants = workspace:GetDescendants()
		local n8 = 0
		local v1025 = #descendants

		while n8 < v1025 and antiLagEnabled do
			for i = 1, 200 do
				n8 += 1

				if not (v1025 < n8) then
					applyAntiLagDerender(descendants[n8])

					continue
				end

				break
			end

			task.wait()
		end
	end)

	if antiLagDescConn then
		antiLagDescConn:Disconnect()
	end

	antiLagDescConn = workspace.DescendantAdded:Connect(function(descendant)
		if antiLagEnabled then
			applyAntiLagDerender(descendant)
		end
	end)
end
disableAntiLag = function()
	antiLagEnabled = false

	if antiLagDescConn then
		antiLagDescConn:Disconnect()
		antiLagDescConn = nil
	end
end
applyStretchFOV = function(p113)
	if workspace.CurrentCamera then
		pcall(function()
			workspace.CurrentCamera.FieldOfView = p113
		end)
	end
end
enableStretch = function()
	if stretchConn then
		return
	end

	stretchEnabled = true

	if not workspace.CurrentCamera then
		return
	end

	origFOV = workspace.CurrentCamera.FieldOfView or 70
	applyStretchFOV(stretchFOV)
	stretchConn = RunService.RenderStepped:Connect(function()
		if stretchEnabled then
			local CurrentCamera2 = workspace.CurrentCamera

			if CurrentCamera2 then
				CurrentCamera2.CFrame *= CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
			end

			return
		end

		stretchConn:Disconnect()
		stretchConn = nil
	end)

	if stretchFovConn then
		stretchFovConn:Disconnect()
	end

	stretchFovConn = RunService.RenderStepped:Connect(function()
		if stretchEnabled then
			applyStretchFOV(stretchFOV)
		else
			stretchFovConn:Disconnect()
			stretchFovConn = nil
		end
	end)
end
disableStretch = function()
	stretchEnabled = false

	if stretchConn then
		stretchConn:Disconnect()
		stretchConn = nil
	end

	if stretchFovConn then
		stretchFovConn:Disconnect()
		stretchFovConn = nil
	end

	if workspace.CurrentCamera then
		pcall(function()
			workspace.CurrentCamera.FieldOfView = origFOV or 70
		end)
	end
end
SKY_PRESETS_LIST = {
	"Off",
	"Night",
	"Aurora",
	"Sunset",
	"Galaxy",
	"Cyber",
	"Sakura",
	"Pink Night",
	"Blood Moon",
	"Emerald Dawn",
	"Volcanic",
	"Arctic",
	"Midnight Ocean",
	"Vaporwave",
	"Toxic",
	"Solar Eclipse",
	"Hellscape",
	"Heaven",
	"Storm",
	"Sunrise",
	"Deep Space",
	"Lavender Dream",
	"Inferno",
	"Mint Sky"
}
SKY_PRESETS = {
	Off = {
		kind = "off"
	},
	Night = {
		clock = 22,
		brightness = 2,
		ambient = {
			110,
			100,
			130
		},
		outAmb = {
			120,
			110,
			140
		},
		sky = {
			stars = 4000,
			moon = 18,
			sun = 0,
			moonTex = true
		},
		atm = {
			dens = 0.45,
			color = {
				120,
				60,
				180
			},
			decay = {
				60,
				20,
				100
			},
			glare = 0.5,
			haze = 1.2
		}
	},
	Aurora = {
		clock = 14,
		brightness = 3,
		ambient = {
			150,
			120,
			150
		},
		outAmb = {
			160,
			130,
			150
		},
		atm = {
			dens = 0.55,
			color = {
				255,
				80,
				200
			},
			decay = {
				255,
				20,
				150
			},
			glare = 2.5,
			haze = 3
		},
		clouds = {
			cover = 0.7,
			dens = 0.7,
			color = {
				255,
				240,
				250
			}
		}
	},
	Sunset = {
		clock = 17.2,
		brightness = 2.5,
		ambient = {
			170,
			120,
			100
		},
		outAmb = {
			180,
			130,
			110
		},
		sky = {
			stars = 0,
			sun = 25,
			moon = 0
		},
		atm = {
			dens = 0.5,
			color = {
				255,
				130,
				60
			},
			decay = {
				255,
				80,
				30
			},
			glare = 2,
			haze = 2.5
		},
		clouds = {
			cover = 0.55,
			dens = 0.55,
			color = {
				255,
				200,
				140
			}
		}
	},
	Galaxy = {
		clock = 0,
		brightness = 1.5,
		ambient = {
			70,
			60,
			100
		},
		outAmb = {
			80,
			70,
			110
		},
		sky = {
			stars = 10000,
			moon = 30,
			sun = 0
		},
		atm = {
			dens = 0.15,
			color = {
				40,
				20,
				80
			},
			decay = {
				20,
				10,
				50
			},
			glare = 0.3,
			haze = 0.5
		}
	},
	Cyber = {
		clock = 21,
		brightness = 2.2,
		ambient = {
			90,
			130,
			170
		},
		outAmb = {
			100,
			140,
			180
		},
		sky = {
			stars = 2000,
			moon = 12
		},
		atm = {
			dens = 0.4,
			color = {
				0,
				200,
				255
			},
			decay = {
				150,
				0,
				255
			},
			glare = 2,
			haze = 2
		},
		clouds = {
			cover = 0.4,
			dens = 0.6,
			color = {
				100,
				200,
				255
			}
		}
	},
	Sakura = {
		clock = 11,
		brightness = 3.5,
		ambient = {
			170,
			150,
			160
		},
		outAmb = {
			180,
			160,
			170
		},
		sky = {
			sun = 8
		},
		atm = {
			dens = 0.3,
			color = {
				255,
				200,
				220
			},
			decay = {
				255,
				170,
				200
			},
			glare = 1,
			haze = 1.5
		},
		clouds = {
			cover = 0.6,
			dens = 0.4,
			color = {
				255,
				250,
				252
			}
		}
	},
	["Pink Night"] = {
		clock = 23,
		brightness = 2.2,
		ambient = {
			120,
			60,
			110
		},
		outAmb = {
			140,
			70,
			120
		},
		sky = {
			stars = 5000,
			moon = 22,
			sun = 0,
			moonTex = true
		},
		atm = {
			dens = 0.5,
			color = {
				255,
				80,
				180
			},
			decay = {
				140,
				30,
				100
			},
			glare = 0.7,
			haze = 1.4
		},
		clouds = {
			cover = 0.3,
			dens = 0.5,
			color = {
				180,
				90,
				150
			}
		}
	},
	["Blood Moon"] = {
		clock = 22.5,
		brightness = 1.6,
		ambient = {
			130,
			40,
			40
		},
		outAmb = {
			150,
			50,
			50
		},
		sky = {
			stars = 1500,
			moon = 28,
			sun = 0,
			moonTex = true
		},
		atm = {
			dens = 0.6,
			color = {
				220,
				30,
				30
			},
			decay = {
				120,
				10,
				10
			},
			glare = 1.4,
			haze = 2
		},
		clouds = {
			cover = 0.5,
			dens = 0.7,
			color = {
				120,
				30,
				30
			}
		}
	},
	["Emerald Dawn"] = {
		clock = 6.5,
		brightness = 2.8,
		ambient = {
			130,
			170,
			140
		},
		outAmb = {
			140,
			180,
			150
		},
		sky = {
			sun = 18,
			moon = 0,
			stars = 0
		},
		atm = {
			dens = 0.4,
			color = {
				80,
				200,
				140
			},
			decay = {
				40,
				150,
				90
			},
			glare = 1.8,
			haze = 2.2
		},
		clouds = {
			cover = 0.5,
			dens = 0.5,
			color = {
				200,
				255,
				220
			}
		}
	},
	Volcanic = {
		clock = 19,
		brightness = 2,
		ambient = {
			180,
			80,
			40
		},
		outAmb = {
			200,
			90,
			50
		},
		sky = {
			stars = 200,
			sun = 12,
			moon = 0
		},
		atm = {
			dens = 0.75,
			color = {
				255,
				60,
				0
			},
			decay = {
				180,
				20,
				0
			},
			glare = 3,
			haze = 3.5
		},
		clouds = {
			cover = 0.8,
			dens = 0.9,
			color = {
				120,
				40,
				20
			}
		}
	},
	Arctic = {
		clock = 9,
		brightness = 3.2,
		ambient = {
			200,
			220,
			235
		},
		outAmb = {
			210,
			230,
			245
		},
		sky = {
			sun = 10,
			stars = 0,
			moon = 0
		},
		atm = {
			dens = 0.3,
			color = {
				180,
				220,
				255
			},
			decay = {
				140,
				200,
				240
			},
			glare = 1.5,
			haze = 1.8
		},
		clouds = {
			cover = 0.7,
			dens = 0.6,
			color = {
				250,
				253,
				255
			}
		}
	},
	["Midnight Ocean"] = {
		clock = 1.5,
		brightness = 1.7,
		ambient = {
			60,
			90,
			130
		},
		outAmb = {
			70,
			100,
			140
		},
		sky = {
			stars = 6000,
			moon = 24,
			sun = 0,
			moonTex = true
		},
		atm = {
			dens = 0.5,
			color = {
				20,
				60,
				140
			},
			decay = {
				10,
				30,
				90
			},
			glare = 0.6,
			haze = 1.5
		}
	},
	Vaporwave = {
		clock = 19.5,
		brightness = 2.4,
		ambient = {
			180,
			120,
			200
		},
		outAmb = {
			190,
			130,
			210
		},
		sky = {
			stars = 1000,
			moon = 14
		},
		atm = {
			dens = 0.45,
			color = {
				255,
				100,
				220
			},
			decay = {
				120,
				60,
				255
			},
			glare = 2.2,
			haze = 2.4
		},
		clouds = {
			cover = 0.55,
			dens = 0.55,
			color = {
				200,
				150,
				255
			}
		}
	},
	Toxic = {
		clock = 13,
		brightness = 2.5,
		ambient = {
			140,
			180,
			80
		},
		outAmb = {
			150,
			190,
			90
		},
		atm = {
			dens = 0.55,
			color = {
				100,
				220,
				40
			},
			decay = {
				60,
				150,
				20
			},
			glare = 1.8,
			haze = 2.6
		},
		clouds = {
			cover = 0.65,
			dens = 0.7,
			color = {
				180,
				255,
				120
			}
		}
	},
	["Solar Eclipse"] = {
		clock = 12,
		brightness = 0.9,
		ambient = {
			50,
			40,
			60
		},
		outAmb = {
			60,
			50,
			70
		},
		sky = {
			stars = 3500,
			sun = 22,
			moon = 0
		},
		atm = {
			dens = 0.5,
			color = {
				255,
				140,
				40
			},
			decay = {
				30,
				20,
				40
			},
			glare = 2.8,
			haze = 1.8
		}
	},
	Hellscape = {
		clock = 18,
		brightness = 1.8,
		ambient = {
			200,
			60,
			30
		},
		outAmb = {
			220,
			70,
			40
		},
		sky = {
			stars = 100,
			sun = 30,
			moon = 0
		},
		atm = {
			dens = 0.85,
			color = {
				255,
				30,
				0
			},
			decay = {
				120,
				0,
				0
			},
			glare = 3.5,
			haze = 4
		},
		clouds = {
			cover = 0.95,
			dens = 0.95,
			color = {
				80,
				20,
				10
			}
		}
	},
	Heaven = {
		clock = 12,
		brightness = 4,
		ambient = {
			240,
			235,
			210
		},
		outAmb = {
			250,
			245,
			220
		},
		sky = {
			sun = 16,
			moon = 0,
			stars = 0
		},
		atm = {
			dens = 0.25,
			color = {
				255,
				250,
				220
			},
			decay = {
				255,
				240,
				200
			},
			glare = 3,
			haze = 1.5
		},
		clouds = {
			cover = 0.85,
			dens = 0.5,
			color = {
				255,
				255,
				255
			}
		}
	},
	Storm = {
		clock = 15,
		brightness = 1.4,
		ambient = {
			90,
			90,
			110
		},
		outAmb = {
			100,
			100,
			120
		},
		sky = {
			stars = 0,
			sun = 6,
			moon = 0
		},
		atm = {
			dens = 0.65,
			color = {
				80,
				90,
				120
			},
			decay = {
				40,
				50,
				80
			},
			glare = 0.5,
			haze = 3
		},
		clouds = {
			cover = 0.95,
			dens = 0.95,
			color = {
				60,
				65,
				80
			}
		}
	},
	Sunrise = {
		clock = 6.2,
		brightness = 2.8,
		ambient = {
			220,
			180,
			130
		},
		outAmb = {
			230,
			190,
			140
		},
		sky = {
			sun = 22,
			stars = 0,
			moon = 0
		},
		atm = {
			dens = 0.45,
			color = {
				255,
				180,
				100
			},
			decay = {
				255,
				140,
				80
			},
			glare = 2.4,
			haze = 2.2
		},
		clouds = {
			cover = 0.4,
			dens = 0.4,
			color = {
				255,
				220,
				180
			}
		}
	},
	["Deep Space"] = {
		clock = 0,
		brightness = 1,
		ambient = {
			30,
			25,
			50
		},
		outAmb = {
			40,
			35,
			60
		},
		sky = {
			stars = 15000,
			moon = 0,
			sun = 0
		},
		atm = {
			dens = 0.08,
			color = {
				15,
				5,
				40
			},
			decay = {
				5,
				0,
				20
			},
			glare = 0.2,
			haze = 0.3
		}
	},
	["Lavender Dream"] = {
		clock = 18.5,
		brightness = 2.6,
		ambient = {
			180,
			160,
			220
		},
		outAmb = {
			190,
			170,
			230
		},
		sky = {
			stars = 800,
			moon = 16,
			sun = 0
		},
		atm = {
			dens = 0.4,
			color = {
				200,
				160,
				255
			},
			decay = {
				160,
				120,
				220
			},
			glare = 1.4,
			haze = 1.8
		},
		clouds = {
			cover = 0.55,
			dens = 0.5,
			color = {
				220,
				200,
				255
			}
		}
	},
	Inferno = {
		clock = 17.5,
		brightness = 2.2,
		ambient = {
			220,
			100,
			40
		},
		outAmb = {
			235,
			110,
			50
		},
		sky = {
			sun = 26,
			moon = 0,
			stars = 0
		},
		atm = {
			dens = 0.6,
			color = {
				255,
				90,
				20
			},
			decay = {
				200,
				40,
				0
			},
			glare = 3,
			haze = 3.2
		},
		clouds = {
			cover = 0.7,
			dens = 0.7,
			color = {
				200,
				80,
				40
			}
		}
	},
	["Mint Sky"] = {
		clock = 10,
		brightness = 3.2,
		ambient = {
			180,
			230,
			210
		},
		outAmb = {
			190,
			240,
			220
		},
		sky = {
			sun = 10
		},
		atm = {
			dens = 0.32,
			color = {
				150,
				255,
				210
			},
			decay = {
				100,
				220,
				180
			},
			glare = 1.6,
			haze = 1.6
		},
		clouds = {
			cover = 0.55,
			dens = 0.45,
			color = {
				240,
				255,
				250
			}
		}
	}
}

local function v1028(p114)
	return Color3.fromRGB(p114[1], p114[2], p114[3])
end

_v4mpClearSky = function()
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:GetAttribute("_AdaptDuelsSky") then
			pcall(function()
				child:Destroy()
			end)
		end
	end

	local Terrain = workspace:FindFirstChildOfClass("Terrain")

	if Terrain then
		for _, child in ipairs(Terrain:GetChildren()) do
			if child:GetAttribute("_AdaptDuelsSky") then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end
end
applyCustomSky = function(p115)
	_v4mpClearSky()

	local v1034 = SKY_PRESETS[p115]

	if not v1034 or v1034.kind == "off" then
		Lighting.ClockTime = 14
		Lighting.Brightness = 2
		Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		Lighting.Ambient = Color3.fromRGB(127, 127, 127)
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = true
		skyTheme = "Off"

		return
	end

	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
	Lighting.FogColor = Color3.fromRGB(200, 200, 200)
	Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
	Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	Lighting.GlobalShadows = true
	Lighting.ClockTime = v1034.clock or 14
	Lighting.Brightness = v1034.brightness or 2

	if v1034.outAmb then
		Lighting.OutdoorAmbient = v1028(v1034.outAmb)
	end

	if v1034.ambient then
		Lighting.Ambient = v1028(v1034.ambient)
	end

	if v1034.sky then
		local Sky = Instance.new("Sky")

		Sky:SetAttribute("_AdaptDuelsSky", true)

		if v1034.sky.stars then
			Sky.StarCount = v1034.sky.stars
		end

		if v1034.sky.moon then
			Sky.MoonAngularSize = v1034.sky.moon
		end

		if v1034.sky.sun then
			Sky.SunAngularSize = v1034.sky.sun
		end

		if v1034.sky.moonTex then
			Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
		end

		Sky.Parent = Lighting
	end

	if v1034.atm then
		local Atmosphere = Instance.new("Atmosphere")

		Atmosphere:SetAttribute("_AdaptDuelsSky", true)
		Atmosphere.Density = v1034.atm.dens or 0.3
		Atmosphere.Color = v1028(v1034.atm.color)
		Atmosphere.Decay = v1028(v1034.atm.decay)
		Atmosphere.Glare = v1034.atm.glare or 1
		Atmosphere.Haze = v1034.atm.haze or 1
		Atmosphere.Parent = Lighting
	end

	local Terrain = workspace:FindFirstChildOfClass("Terrain")

	if v1034.clouds and Terrain then
		local Clouds = Instance.new("Clouds")

		Clouds:SetAttribute("_AdaptDuelsSky", true)
		Clouds.Cover = v1034.clouds.cover or 0.5
		Clouds.Density = v1034.clouds.dens or 0.5
		Clouds.Color = v1028(v1034.clouds.color)
		Clouds.Parent = Terrain
	end

	skyTheme = p115
end
enableVividGraphics = function()
	if vividGraphicsEnabled and #_vividEffects > 0 then
		return
	end

	vividGraphicsEnabled = true

	for _, v in ipairs(_vividEffects) do
		pcall(function()
			v:Destroy()
		end)
	end

	_vividEffects = {}

	local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")

	ColorCorrectionEffect.Parent = Lighting
	ColorCorrectionEffect.Saturation = 0.6
	ColorCorrectionEffect.Contrast = 0.4
	ColorCorrectionEffect.Brightness = 0.05
	ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 240, 220)
	table.insert(_vividEffects, ColorCorrectionEffect)

	local BloomEffect = Instance.new("BloomEffect")

	BloomEffect.Parent = Lighting
	BloomEffect.Intensity = 0.8
	BloomEffect.Size = 24
	BloomEffect.Threshold = 1
	table.insert(_vividEffects, BloomEffect)

	local Atmosphere = Instance.new("Atmosphere")

	Atmosphere.Parent = Lighting
	Atmosphere.Density = 0.3
	Atmosphere.Offset = 0.25
	Atmosphere.Color = Color3.fromRGB(199, 199, 255)
	Atmosphere.Decay = Color3.fromRGB(106, 112, 125)
	Atmosphere.Glare = 0.2
	Atmosphere.Haze = 1
	table.insert(_vividEffects, Atmosphere)

	local SunRaysEffect = Instance.new("SunRaysEffect")

	SunRaysEffect.Parent = Lighting
	SunRaysEffect.Intensity = 0.2
	SunRaysEffect.Spread = 0.8
	table.insert(_vividEffects, SunRaysEffect)

	local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

	DepthOfFieldEffect.Parent = Lighting
	DepthOfFieldEffect.FocusDistance = 25
	DepthOfFieldEffect.InFocusRadius = 10
	DepthOfFieldEffect.NearIntensity = 0.2
	DepthOfFieldEffect.FarIntensity = 0.4
	table.insert(_vividEffects, DepthOfFieldEffect)
	task.spawn(function()
		while vividGraphicsEnabled and ColorCorrectionEffect do
			if not ColorCorrectionEffect.Parent then
				break
			end

			ColorCorrectionEffect.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
			task.wait(0.03)
		end
	end)
end
disableVividGraphics = function()
	vividGraphicsEnabled = false

	for _, v in ipairs(_vividEffects) do
		pcall(function()
			v:Destroy()
		end)
	end

	_vividEffects = {}
end
toggleVividGraphics = function(p116)
	if p116 then
		enableVividGraphics()
	else
		disableVividGraphics()
	end

	saveAllSettings(true)
end
applyHideButtons = function(p117)
	hideButtonsEnabled = p117

	if MobilePanel then
		for _, child in ipairs(MobilePanel:GetChildren()) do
			if child:IsA("TextButton") then
				child.Visible = not p117
			end
		end
	end

	if tpBatFloatingButton then
		local Frame = tpBatFloatingButton:FindFirstChild("Frame")

		if Frame then
			Frame.Visible = not p117
		end
	end

	if batV2FloatingButton then
		local Frame = batV2FloatingButton:FindFirstChild("Frame")

		if Frame then
			Frame.Visible = not p117
		end
	end

	if instaResetFloatingButton then
		local Frame = instaResetFloatingButton:FindFirstChild("Frame")

		if Frame then
			Frame.Visible = not p117
		end
	end
end
toggleHideButtons = function(p118)
	applyHideButtons(p118)

	if setHideButtonsVisual then
		setHideButtonsVisual(p118)
	end

	saveAllSettings(true)
end
paintFloatingBtn = function(p119, p120)
	if not p119 then
		return
	end

	local BtnGrad = p119:FindFirstChild("BtnGrad")
	local TextLabel2 = p119:FindFirstChild("TextLabel")
	local UIStroke = p119:FindFirstChildOfClass("UIStroke")

	p119.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

	if p120 then
		local v1056 = getThemeColor()

		if BtnGrad then
			BtnGrad.Color = youtGradient(v1056)
		end

		if TextLabel2 then
			TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		if UIStroke then
			UIStroke.Color = v1056
			UIStroke.Thickness = 1.5
			UIStroke.Transparency = 0.1
		end
	else
		if BtnGrad then
			BtnGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(252, 252, 253)),
				ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233, 233, 236)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(168, 168, 176))
			})
		end

		if TextLabel2 then
			TextLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
		end

		if UIStroke then
			UIStroke.Color = Color3.fromRGB(120, 120, 128)
			UIStroke.Thickness = 1
			UIStroke.Transparency = 0.55
		end
	end
end
applyFloatingButtonScale = function()
	for _, v in ipairs(_floatingUIScales) do
		if v and v.Parent then
			v.Scale = floatingButtonScale
		end
	end
end

local function v1059(p121)
	local u1060 = false
	local Position
	local Position2
	local u1063
	local connection6

	local function v1065()
		local v1066 = u1060

		u1060 = false
		u1063 = nil

		if connection6 then
			connection6:Disconnect()
			connection6 = nil
		end

		if v1066 then
			task.defer(function()
				pcall(saveAllSettings)
			end)
		end
	end

	p121.InputBegan:Connect(function(input)
		if uiLocked then
			return
		end

		if _isDraggingButton then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			u1060 = true
			Position = input.Position
			Position2 = p121.Position

			if connection6 then
				connection6:Disconnect()
			end

			connection6 = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					v1065()
				end
			end)
		end
	end)
	p121.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			v1065()
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			v1065()
		end
	end)

	local function v1067(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			u1063 = input
		end
	end

	p121.InputChanged:Connect(v1067)
	UserInputService.InputChanged:Connect(function(input)
		if input == u1063 and u1060 then
			if uiLocked then
				v1065()

				return
			end

			if _isDraggingButton then
				return
			end

			if not Position or not Position2 then
				return
			end

			p121.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + (input.Position.X - Position.X), Position2.Y.Scale, Position2.Y.Offset + (input.Position.Y - Position.Y))
		end
	end)
end

setupMovementAndIndicators = function(p122)
	if steppedConn then
		steppedConn:Disconnect()
		steppedConn = nil
	end

	if movementLoop then
		movementLoop:Disconnect()
		movementLoop = nil
	end

	local n9 = 0

	steppedConn = RunService.Heartbeat:Connect(function(dt)
		n9 += dt

		if n9 < 0.05 then
			return
		end

		n9 = 0

		local v1069 = v42()

		for i = 1, #v1069 do
			local v1071 = v1069[i]

			if v1071 ~= LocalPlayer2 then
				local Character = v1071.Character

				if Character then
					local children = Character:GetChildren()

					for i2 = 1, #children do
						local v1075 = children[i2]

						if v1075:IsA("BasePart") and v1075.CanCollide then
							v1075.CanCollide = false
						end
					end
				end
			end
		end
	end)
	movementLoop = RunService.RenderStepped:Connect(function()
		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not Humanoid or not HumanoidRootPart then
			return
		end

		if not (autoBatEnabled or autoLeftEnabled or autoRightEnabled or tpBatEnabled or autoBatV2Enabled) then
			if v266(Humanoid) then
				lastMoveDir = Vector3.zero
			else
				local MoveDirection = Humanoid.MoveDirection
				local v1080 = getActiveMoveSpeed()
				local lastMoveDir_

				if MoveDirection.Magnitude > 0 then
					lastMoveDir = MoveDirection
					lastMoveDir_ = MoveDirection
				elseif lastMoveDir.Magnitude > 0 then
					for k in pairs(MOVE_KEYS) do
						if UserInputService:IsKeyDown(k) then
							lastMoveDir_ = lastMoveDir

							break
						end
					end
				end

				v268(lastMoveDir_, v1080, HumanoidRootPart)
			end
		end

		if speedLabel then
			local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity
			local v1084 = math.sqrt(AssemblyLinearVelocity.X * AssemblyLinearVelocity.X + AssemblyLinearVelocity.Z * AssemblyLinearVelocity.Z)

			if v1084 < 0.05 then
				v1084 = 0
			end

			speedLabel.Text = string.format("%.1f  -  %s", v1084, getSpeedModeName())
		end
	end)
	setupSpeedIndicator(p122)
	startEnemySpeed()
end
toggleLockUI = function(p123)
	if p123 == nil then
		uiLocked = not uiLocked
	else
		uiLocked = p123
	end

	if setLockUIVisual then
		setLockUIVisual(uiLocked)
	end
end
disableAllAimbots = function()
	if autoBatEnabled then
		disableAutoBat()

		if autoBatSetVisual then
			autoBatSetVisual(false)
		end

		if mobSetAutoBat then
			mobSetAutoBat(false)
		end
	end

	if tpBatEnabled then
		stopBatDesyncTp()
	end

	if autoBatV2Enabled then
		disableBatV2()

		if autoBatV2SetVisual then
			autoBatV2SetVisual(false)
		end

		if batV2FloatingButton then
			local Frame = batV2FloatingButton:FindFirstChild("Frame")

			if Frame then
				paintFloatingBtn(Frame, false)
			end
		end
	end
end
stopAllBackgroundTasks = function()
	if movementLoop then
		movementLoop:Disconnect()
		movementLoop = nil
	end

	if steppedConn then
		steppedConn:Disconnect()
		steppedConn = nil
	end

	stopEnemySpeed()

	if stretchEnabled then
		disableStretch()
	end

	if stretchConn then
		stretchConn:Disconnect()
		stretchConn = nil
	end

	if stretchFovConn then
		stretchFovConn:Disconnect()
		stretchFovConn = nil
	end

	if t17.Enabled then
		v630()
	end

	if antiDieEnabled then
		antiDie.stop()
	end

	stopBatCounter()
	stopBatCounterV2()
	stopMedusaCounter()
	stopAutoSteal()
	disableAutoBat()

	if tpBatEnabled then
		stopBatDesyncTp()
	end

	if autoBatV2Enabled then
		disableBatV2()
	end

	stopAutoLeft()
	stopAutoRight()

	if antiDesyncEnabled then
		stopAntiDesync()
	end

	if autoTPEnabled then
		stopAutoTP()
	end

	if unwalkEnabled and not u824 then
		stopUnwalk()
	end

	if antiLagEnabled then
		disableAntiLag()
	end

	if espEnabled then
		toggleESP(false)
	end

	if dropActive then
		stopDropBrainrot()
	end

	if bodyLockEnabled then
		stopBodyLock()
	end

	_blSuppressCount = 0
	_blWasEnabled = false

	if _blRestoreTimer then
		pcall(task.cancel, _blRestoreTimer)
		_blRestoreTimer = nil
	end

	if _bodyLockConn then
		_bodyLockConn:Disconnect()
		_bodyLockConn = nil
	end

	for _, v in ipairs(dropConnections) do
		if type(v) == "thread" then
			pcall(task.cancel, v)
		elseif type(v) == "RBXScriptConnection" then
			pcall(v.Disconnect, v)
		end
	end

	dropConnections = {}
	dropActive = false
	alPhase = 1
	arPhase = 1
	lastDropTime = 0
	medusaDebounce = false
	medusaLastUsed = 0
end

local t22 = {
	lastAt = 0,
	queued = false,
	writing = false,
	revision = 0
}

local function v1089()
	local genv = getgenv and getgenv() or _G
	local t23 = {
		readfile,
		syn and syn.readfile,
		genv.readfile
	}
	local t24 = {
		writefile,
		syn and syn.writefile,
		genv.writefile
	}
	local v1093
	local v1094

	for _, v in pairs(t23) do
		if type(v) == "function" then
			v1093 = v

			break
		end
	end

	for _, v in pairs(t24) do
		if type(v) == "function" then
			v1094 = v

			break
		end
	end

	return v1093, v1094
end
local function v1099(p124)
	local v1100 = v1089()

	if not v1100 then
		return false
	end

	local ok, result = pcall(v1100, p124)

	return ok and type(result) == "string"
end

buildConfigTable = function()
	local t25 = {
		normalSpeed = NS,
		carrySpeed = CS,
		laggerSpeed1 = LAGGER_SPEED,
		laggerSpeed2 = LAGGER_CARRY_SPEED,
		stealRadius = _G._youtStealRadiusV1 or CONFIG.STEAL_RANGE,
		stealRadiusV1 = _G._youtStealRadiusV1 or CONFIG.STEAL_RANGE,
		stealRadiusV2 = _G._youtStealRadiusV2 or 60,
		stealRadiusV3 = _G._youtStealRadiusV3 or 63,
		antiRagdollMode = antiRagdollMode,
		antiDieEnabled = antiDieEnabled,
		selectedStealMode = selectedStealMode,
		tpBatMode = tpBatMode,
		antiDesyncEnabled = antiDesyncEnabled,
		autoCarrySpeed = autoCarrySpeedEnabled,
		autoTPEnabled = autoTPEnabled,
		autoTPHeight = autoTPHeight,
		autoSteal = CONFIG.AUTO_STEAL_ENABLED,
		medusaCounter = medusaCounterEnabled,
		batCounter = batCounterEnabled,
		batCounterV2 = batCounterV2Enabled,
		unwalkEnabled = unwalkEnabled
	}

	t25.laggerToggled = laggerToggled
	t25.laggerCarryToggled = laggerCarryToggled
	t25.carryMode = speedMode
	t25.batAimbotSpeed = BAT_AIMBOT_SPEED
	t25.dropMode = dropMode
	t25.stretchEnabled = stretchEnabled
	t25.stretchFOV = stretchFOV
	t25.uiScale = uiScaleValue
	t25.animPack = currentAnimPack
	t25.espEnabled = espEnabled
	t25.vividGraphics = vividGraphicsEnabled
	t25.hideButtons = hideButtonsEnabled
	t25.antiLag = antiLagEnabled
	t25.tpBatEnabled = tpBatEnabled
	t25.autoBatV2Enabled = autoBatV2Enabled
	t25.skyTheme = skyTheme
	t25.mobileButtonPositions = savedButtonPositions
	t25.dropBrainrotKey = {
		kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name,
		gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name
	}

	local autoLeftKey = {
		kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name,
		gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name
	}

	t25.autoLeftKey = autoLeftKey
	t25.autoRightKey = {
		kb = KB.AutoRight.kb and KB.AutoRight.kb.Name,
		gp = KB.AutoRight.gp and KB.AutoRight.gp.Name
	}
	t25.autoBatKey = {
		kb = KB.AutoBat.kb and KB.AutoBat.kb.Name,
		gp = KB.AutoBat.gp and KB.AutoBat.gp.Name
	}
	t25.tpFloorKey = {
		kb = KB.TPFloor.kb and KB.TPFloor.kb.Name,
		gp = KB.TPFloor.gp and KB.TPFloor.gp.Name
	}
	t25.guiHideKey = {
		kb = KB.GuiHide.kb and KB.GuiHide.kb.Name,
		gp = KB.GuiHide.gp and KB.GuiHide.gp.Name
	}
	t25.carryToggleKey = {
		kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name,
		gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name
	}
	t25.laggerModeKey = {
		kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name,
		gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name
	}
	t25.tpBatKey = {
		kb = KB.TPBat.kb and KB.TPBat.kb.Name,
		gp = KB.TPBat.gp and KB.TPBat.gp.Name
	}
	t25.batV2Key = {
		kb = KB.BatV2.kb and KB.BatV2.kb.Name,
		gp = KB.BatV2.gp and KB.BatV2.gp.Name
	}
	t25.instaResetKey = {
		kb = KB.InstaReset.kb and KB.InstaReset.kb.Name,
		gp = KB.InstaReset.gp and KB.InstaReset.gp.Name
	}
	t25.antiDesyncKey = {
		kb = KB.AntiDesync.kb and KB.AntiDesync.kb.Name,
		gp = KB.AntiDesync.gp and KB.AntiDesync.gp.Name
	}
	t25.tpBatFloatingPos = tpBatFloatingPos
	t25.batV2FloatingPos = batV2FloatingPos
	t25.instaResetFloatingPos = instaResetFloatingPos
	t25.bodyLockEnabled = bodyLockEnabled
	t25.bodyLockRange = bodyLockRange
	t25.progressBarPos = savedProgressBarPos
	t25.lockUI = uiLocked
	t25.backgroundIndex = backgroundIndex
	t25.backgroundImageTransparency = backgroundImageTransparency
	t25.backgroundMode = backgroundMode
	t25.floatingButtonScale = floatingButtonScale
	t25.outfitIndex = outfitIndex
	t25.themeColor = currentColorTheme

	if main then
		t25.mainPosition = {
			XScale = main.Position.X.Scale,
			XOffset = main.Position.X.Offset,
			YScale = main.Position.Y.Scale,
			YOffset = main.Position.Y.Offset
		}
	end

	if pbFrame then
		t25.progressBarPos = {
			XScale = pbFrame.Position.X.Scale,
			XOffset = pbFrame.Position.X.Offset,
			YScale = pbFrame.Position.Y.Scale,
			YOffset = pbFrame.Position.Y.Offset
		}
	end

	if MobilePanel then
		t25.mobilePanelPos = {
			XScale = 0,
			XOffset = 10,
			YScale = 0,
			YOffset = 0
		}

		for _, child in ipairs(MobilePanel:GetChildren()) do
			if child:IsA("TextButton") then
				savedButtonPositions[child.Name] = {
					XScale = child.Position.X.Scale,
					XOffset = child.Position.X.Offset,
					YScale = child.Position.Y.Scale,
					YOffset = child.Position.Y.Offset
				}
			end
		end

		t25.mobileButtonPositions = savedButtonPositions
	end

	return t25
end
saveAllSettings = function(p125)
	if _isResetting or _isLoading then
		return true
	end

	local v1107 = buildConfigTable()

	v1107.configVersion = 3
	v1107.scriptVersion = 6
	v1107.userId = LocalPlayer2.UserId

	local ok, result = pcall(function()
		return HttpService:JSONEncode(v1107)
	end)

	if not ok then
		return false
	end

	if not (p125 or result ~= _lastSavedJSON) then
		return true
	end

	if t22.writing or not p125 and tick() - t22.lastAt < 0.25 then
		if not t22.queued then
			t22.queued = true
			task.delay(0.25, function()
				t22.queued = false
				saveAllSettings(true)
			end)
		end

		return true
	end

	local v1110, v1111 = v1089()

	if not v1110 or not v1111 then
		warn("[-$ ZL Save] Executor file API is unavailable.")

		return false
	end

	t22.writing = true
	t22.revision += 1
	v1107.revision = t22.revision
	v1107.savedAt = os.time()

	local json = HttpService:JSONEncode(v1107)
	local ok2 = pcall(function()
		if v1099(CONFIG_FILE) then
			local v1114 = v1110(CONFIG_FILE)

			if type(v1114) == "string" then
				v1111(CONFIG_FILE .. ".backup", v1114)
			end
		end

		v1111(CONFIG_FILE, json)

		local v1115 = v1110(CONFIG_FILE)

		if v1115 ~= json then
			error("save verification failed")
		end

		HttpService:JSONDecode(v1115)
	end)

	t22.writing = false
	t22.lastAt = tick()

	if ok2 then
		_lastSavedJSON = json
	else
		warn("[$~ ZL Save] Write or verification failed.")
	end

	return ok2
end
loadAllSettings = function()
	local v1116 = v1089()

	if not v1116 or not v1099(CONFIG_FILE) then
		return false
	end

	local ok, result = pcall(function()
		return HttpService:JSONDecode(v1116(CONFIG_FILE))
	end)

	if not ok or not result then
		return false
	end

	local v1119 = tonumber(result.configVersion) or 0

	if v1119 < 3 then
		local v1120, v1121 = v1089()

		pcall(function()
			if v1120 and v1121 then
				local v1122 = v1120(CONFIG_FILE)

				if type(v1122) == "string" then
					v1121(CONFIG_FILE .. ".v" .. tostring(v1119) .. ".bak", v1122)
				end
			end
		end)
		warn(("[BloodHounds] Config v%d detectado, schema actual v%d. Backup guardado como %s.v%d.bak. Se usan defaults."):format(v1119, 3, CONFIG_FILE, v1119))

		return false
	end

	_isLoading = true
	NS = result.normalSpeed or NS
	CS = result.carrySpeed or CS
	LAGGER_SPEED = result.laggerSpeed1 or LAGGER_SPEED
	LAGGER_CARRY_SPEED = result.laggerSpeed2 or LAGGER_CARRY_SPEED

	if tonumber(result.configVersion) >= 2 and result.lockUI ~= nil then
		uiLocked = result.lockUI
	else
		uiLocked = false
	end

	mobileButtonsLocked = false

	if result.antiRagdollMode then
		antiRagdollMode = result.antiRagdollMode
	else
		antiRagdollMode = result.antiRagdoll and "v2" or "off"
	end

	antiDieEnabled = result.antiDieEnabled or false

	if result.selectedStealMode == "V2" then
		selectedStealMode = "V2"
	elseif result.selectedStealMode == "V3" then
		selectedStealMode = "V3"
	else
		selectedStealMode = "V1"
	end

	tpBatMode = result.tpBatMode == "V2" and "V2" or result.tpBatMode == "V3" and "V3" or "V1"

	if type(result.stealRadiusV1) == "number" then
		_G._youtStealRadiusV1 = result.stealRadiusV1
	elseif type(result.stealRadius) == "number" then
		_G._youtStealRadiusV1 = result.stealRadius
	else
		_G._youtStealRadiusV1 = _G._youtStealRadiusV1 or 61
	end

	if type(result.stealRadiusV2) == "number" then
		_G._youtStealRadiusV2 = result.stealRadiusV2
	else
		_G._youtStealRadiusV2 = _G._youtStealRadiusV2 or 60
	end

	if type(result.stealRadiusV3) == "number" then
		_G._youtStealRadiusV3 = result.stealRadiusV3
	else
		_G._youtStealRadiusV3 = _G._youtStealRadiusV3 or 63
	end

	if selectedStealMode == "V3" then
		CONFIG.STEAL_RANGE = _G._youtStealRadiusV3
	elseif selectedStealMode == "V2" then
		CONFIG.STEAL_RANGE = _G._youtStealRadiusV2
	else
		CONFIG.STEAL_RANGE = _G._youtStealRadiusV1
	end

	t12.StealRadius = CONFIG.STEAL_RANGE

	if radInput then
		radInput.Text = tostring(CONFIG.STEAL_RANGE)
	end

	CONFIG.AUTO_STEAL_ENABLED = result.autoSteal or false
	medusaCounterEnabled = result.medusaCounter or false
	batCounterEnabled = result.batCounter or false
	batCounterV2Enabled = result.batCounterV2 or false
	unwalkEnabled = result.unwalkEnabled or result.unwalk or false
	antiLagEnabled = result.antiLag or false
	laggerToggled = result.laggerToggled or false
	speedMode = result.carryMode or false
	laggerCarryToggled = result.laggerCarryToggled or false
	autoCarrySpeedEnabled = result.autoCarrySpeed == true
	autoTPEnabled = result.autoTPEnabled == true
	autoTPHeight = tonumber(result.autoTPHeight) or autoTPHeight
	uiScaleValue = math.clamp(tonumber(result.uiScale) or 78, 50, 150)

	if mainUIScale then
		mainUIScale.Scale = uiScaleValue / 100
	end

	if pbScale then
		pbScale.Scale = uiScaleValue / 100
	end

	espEnabled = result.espEnabled or false

	if espEnabled then
		toggleESP(true)
	else
		toggleESP(false)
	end

	vividGraphicsEnabled = result.vividGraphics or false
	hideButtonsEnabled = result.hideButtons or false
	currentColorTheme = t2[result.themeColor] and result.themeColor or "Pink"
	selectedColor = t2[currentColorTheme]
	task.defer(function()
		updateAllUIThemeColors(selectedColor)
	end)

	if result.tpBatEnabled then
		task.defer(function()
			startBatDesyncTp()

			if tpBat then
				tpBat(true)
			end

			v817(true)
		end)
	else
		if tpBat then
			tpBat(false)
		end

		v817(false)
	end

	autoBatV2Enabled = result.autoBatV2Enabled or false

	if autoBatV2Enabled then
		task.defer(function()
			enableBatV2()

			if autoBatV2SetVisual then
				autoBatV2SetVisual(true)
			end
		end)
	elseif autoBatV2SetVisual then
		autoBatV2SetVisual(false)
	end

	skyTheme = result.skyTheme or "Off"

	if skyTheme ~= "Off" then
		pcall(applyCustomSky, skyTheme)
	end

	if skySelectorLabel then
		skySelectorLabel.Text = skyTheme
	end

	if result.animPack and ANIM_PACKS[result.animPack] then
		v286(result.animPack)
	else
		currentAnimPack = "Off"
		v291()
	end

	local function v1123(p126, p127)
		if not p127 then
			return
		end

		if p127.kb and Enum.KeyCode[p127.kb] then
			p126.kb = Enum.KeyCode[p127.kb]
		end

		if p127.gp and Enum.KeyCode[p127.gp] then
			p126.gp = Enum.KeyCode[p127.gp]
		end
	end

	v1123(KB.DropBrainrot, result.dropBrainrotKey)
	v1123(KB.AutoLeft, result.autoLeftKey)
	v1123(KB.AutoRight, result.autoRightKey)
	v1123(KB.AutoBat, result.autoBatKey)
	v1123(KB.TPFloor, result.tpFloorKey)
	v1123(KB.GuiHide, result.guiHideKey)
	v1123(KB.CarryToggle, result.carryToggleKey)
	v1123(KB.LaggerMode, result.laggerModeKey)
	v1123(KB.TPBat, result.tpBatKey)
	v1123(KB.BatV2, result.batV2Key)
	v1123(KB.InstaReset, result.instaResetKey)
	v1123(KB.AntiDesync, result.antiDesyncKey)

	if result.mobileButtonPositions then
		savedButtonPositions = result.mobileButtonPositions
	end

	if result.mobilePanelPos then
		savedMobilePanelPos = result.mobilePanelPos
	end

	if result.mainPosition and main then
		local XOffset = result.mainPosition.XOffset or 20
		local YOffset = result.mainPosition.YOffset or 2
		local CurrentCamera2 = workspace.CurrentCamera
		local X = CurrentCamera2 and CurrentCamera2.ViewportSize.X or 1920
		local Y = CurrentCamera2 and CurrentCamera2.ViewportSize.Y or 1080

		if XOffset < -X + 60 then
			XOffset = 20
		end

		if YOffset < -60 then
			YOffset = 2
		end

		if X - 60 < XOffset then
			XOffset = 20
		end

		if Y - 60 < YOffset then
			YOffset = 2
		end

		main.Position = UDim2.new(result.mainPosition.XScale or 0, XOffset, result.mainPosition.YScale or 0, YOffset)
	end

	if result.tpBatFloatingPos then
		tpBatFloatingPos = result.tpBatFloatingPos
	end

	if result.batV2FloatingPos then
		batV2FloatingPos = result.batV2FloatingPos
	end

	if result.instaResetFloatingPos then
		instaResetFloatingPos = result.instaResetFloatingPos
	end

	if result.progressBarPos then
		savedProgressBarPos = result.progressBarPos
	end

	if result.bodyLockEnabled ~= nil then
		bodyLockEnabled = result.bodyLockEnabled

		if bodyLockEnabled then
			task.defer(function()
				if bodyLockSetVisual then
					bodyLockSetVisual(true)
				end

				startBodyLock()
			end)
		end
	end

	if result.bodyLockRange then
		bodyLockRange = result.bodyLockRange

		if bodyLockRangeBox then
			bodyLockRangeBox.Text = tostring(bodyLockRange)
		end
	end

	dropMode = result.dropMode or 1
	stretchEnabled = result.stretchEnabled or false
	stretchFOV = result.stretchFOV or 120
	BAT_AIMBOT_SPEED = result.batAimbotSpeed or BAT_AIMBOT_SPEED
	backgroundIndex = result.backgroundIndex or 3
	backgroundImageTransparency = result.backgroundImageTransparency or 0
	backgroundMode = result.backgroundMode == "None" and "None" or "Background 1"
	floatingButtonScale = result.floatingButtonScale or 1

	if result.outfitIndex and result.outfitIndex >= 1 and result.outfitIndex <= #t6 then
		outfitIndex = result.outfitIndex
		task.defer(function()
			pcall(function()
				applyOutfitByIndex(outfitIndex)
			end)

			if TextLabel then
				TextLabel.Text = t6[outfitIndex].label
			end
		end)
	end

	if _G._youtStealModeSetter then
		task.defer(function()
			_G._youtStealModeSetter(selectedStealMode)
		end)
	end

	if _G._youtTpBatModeSetter then
		task.defer(function()
			_G._youtTpBatModeSetter(tpBatMode)
		end)
	end

	if result.antiDesyncEnabled then
		task.defer(function()
			task.wait(0.5)

			if LocalPlayer2.Character then
				startAntiDesync()

				if setAntiDesyncVisual then
					setAntiDesyncVisual(true)
				end

				if mobSetAntiDesync then
					mobSetAntiDesync(true)
				end
			end
		end)
	end

	if autoCarrySetVisual then
		task.defer(function()
			autoCarrySetVisual(autoCarrySpeedEnabled)
		end)
	end

	if autoTPEnabled then
		task.defer(function()
			task.wait(0.6)
			startAutoTP()

			if autoTPSetVisual then
				autoTPSetVisual(true)
			end
		end)
	end

	if vividGraphicsEnabled then
		task.defer(function()
			enableVividGraphics()
		end)
	else
		task.defer(function()
			disableVividGraphics()
		end)
	end

	autoBatEnabled = false
	autoLeftEnabled = false
	autoRightEnabled = false

	if dropModeBtnRef then
		dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
	end

	refreshSpeedModeLabel()
	_lastSavedJSON = HttpService:JSONEncode(buildConfigTable())
	_isLoading = false

	return true
end
forceResetUI = function()
	if normalBox then
		normalBox.Text = tostring(NS)
	end

	if carryBox then
		carryBox.Text = tostring(CS)
	end

	if radInput then
		radInput.Text = tostring(CONFIG.STEAL_RANGE)
	end

	if laggerBox then
		laggerBox.Text = tostring(LAGGER_SPEED)
	end

	if lagger2Box then
		lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
	end

	if batSpeedBox then
		batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
	end

	if uiScaleBox then
		uiScaleBox.Text = tostring(uiScaleValue)
	end

	if dropModeBtnRef then
		dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
	end

	if bodyLockRangeBox then
		bodyLockRangeBox.Text = tostring(bodyLockRange)
	end

	local function v1129(p128, p129)
		if p128 then
			p128(p129)
		end
	end

	v1129(autoBatSetVisual, false)
	v1129(autoLeftSetVisual, false)
	v1129(autoRightSetVisual, false)
	v1129(setBatCounterVisual, false)
	v1129(setBatCounterV2Visual, false)
	v1129(setMedusaVisual, false)
	v1129(setUnwalkVisual, false)
	v1129(setAntiLagVisual, false)
	v1129(setLockUIVisual, false)
	v1129(setInstaGrab, false)
	v1129(tpBat, false)
	v1129(autoBatV2SetVisual, false)
	v1129(setESPVIsual, false)
	v1129(setVividVisual, false)
	v1129(setHideButtonsVisual, false)
	v1129(bodyLockSetVisual, false)
	v1129(setAntiDieVisual, false)
	v1129(setAntiRagVisual, false)
	v1129(setAntiDesyncVisual, false)
	v1129(mobSetAntiDesync, false)
	v1129(autoCarrySetVisual, false)
	v1129(autoTPSetVisual, false)
	disableVividGraphics()
	applyHideButtons(false)

	if _G.stretchToggleSetter then
		_G.stretchToggleSetter(false)
	end

	v1129(mobSetAutoBat, false)
	v1129(mobSetAutoLeft, false)
	v1129(mobSetAutoRight, false)
	v1129(mobSetDropBR, false)
	v1129(mobSetTpDown, false)
	v1129(mobSetCarry, false)
	v1129(mobSetLagger1, false)
	v1129(mobSetLagger2, false)
	refreshSpeedModeLabel()
	updateProgressBarVisibility()
	disableAntiLag()
	skyTheme = "Off"
	pcall(applyCustomSky, "Off")

	if skySelectorLabel then
		skySelectorLabel.Text = "Off"
	end

	if antiDieEnabled then
		antiDie.stop()
		antiDieEnabled = false
	end

	v817(false)

	for _, v in ipairs(keyButtonRefs) do
		local entry = v.entry

		v.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
	end

	currentColorTheme = "Pink"
	selectedColor = t2.Pink
	updateAllUIThemeColors(selectedColor)

	if miniBtn then
		local UIStroke = miniBtn:FindFirstChildOfClass("UIStroke")

		if UIStroke then
			UIStroke.Color = Color3.fromRGB(42, 43, 47)
		end
	end

	if MobilePanel then
		for _, child in ipairs(MobilePanel:GetChildren()) do
			if child:IsA("TextButton") then
				local TextLabel2 = child:FindFirstChildOfClass("TextLabel")

				if TextLabel2 and child.BackgroundColor3 ~= selectedColor then
					TextLabel2.TextColor3 = selectedColor
				end
			end
		end
	end

	saveAllSettings()
end
resetFloatingPositions = function()
	if MobilePanel then
		savedButtonPositions = {}

		for _, child in ipairs(MobilePanel:GetChildren()) do
			if child:IsA("TextButton") and child.Name then
				if child.Name == "AntiDesync" then
					child.Position = UDim2.new(0.5, -50, 0, 10)
				else
					local v1139, v1140 = getDefaultButtonPosition(child.Name)

					child.Position = UDim2.new(0, v1139, 0, v1140)
				end
			end
		end
	end

	if tpBatFloatingButton then
		if tpBatFloatingButton:FindFirstChild("Frame") then
			tpBatFloatingButton:FindFirstChild("Frame").Position = UDim2.new(0.5, 20, 0, 10)
			tpBatFloatingPos = nil
		end
	end

	if batV2FloatingButton then
		if batV2FloatingButton:FindFirstChild("Frame") then
			batV2FloatingButton:FindFirstChild("Frame").Position = UDim2.new(0.5, -50, 0, 10)
			batV2FloatingPos = nil
		end
	end

	if instaResetFloatingButton then
		if instaResetFloatingButton:FindFirstChild("Frame") then
			instaResetFloatingButton.Frame.Position = UDim2.new(0.5, 90, 0, 10)
			instaResetFloatingPos = nil
		end
	end

	if pbFrame then
		pbFrame.Position = UDim2.new(0.5, -170, 1, -70)
		savedProgressBarPos = nil
	end

	savedMobilePanelPos = nil
	tpBatFloatingPos = nil
	batV2FloatingPos = nil
end
resetToFactoryDefaults = function()
	_isResetting = true

	local ok, result = pcall(function()
		stopAutoSteal()
		stopBatCounter()
		stopBatCounterV2()
		stopMedusaCounter()

		if t17.Enabled then
			v630()
		end

		if antiDieEnabled then
			antiDie.stop()
		end

		stopUnwalk()
		disableAutoBat()

		if tpBatEnabled then
			stopBatDesyncTp()
		end

		if autoBatV2Enabled then
			disableBatV2()
		end

		if antiDesyncEnabled then
			stopAntiDesync()
		end

		stopBodyLock()

		if espEnabled then
			toggleESP(false)
		end

		if stretchEnabled then
			disableStretch()
		end

		if antiLagEnabled then
			disableAntiLag()
		end

		if vividGraphicsEnabled then
			disableVividGraphics()
		end

		if hideButtonsEnabled then
			applyHideButtons(false)
		end

		if dropActive then
			stopDropBrainrot()
		end

		if autoTPEnabled then
			stopAutoTP()
		end

		skyTheme = "Off"
		pcall(applyCustomSky, "Off")

		if skySelectorLabel then
			skySelectorLabel.Text = "Off"
		end

		if antiDieEnabled then
			antiDie.stop()
			antiDieEnabled = false
		end

		NS = 60
		CS = 29
		LAGGER_SPEED = 15
		LAGGER_CARRY_SPEED = 24.5
		CONFIG.STEAL_RANGE = 61
		_G._youtStealRadiusV1 = 61
		_G._youtStealRadiusV2 = 60
		_G._youtStealRadiusV3 = 63
		speedMode = false
		laggerToggled = false
		laggerCarryToggled = false
		antiRagdollMode = "off"
		antiDieEnabled = false
		medusaCounterEnabled = false
		batCounterEnabled = false
		batCounterV2Enabled = false
		autoBatEnabled = false
		autoLeftEnabled = false
		autoRightEnabled = false
		autoBatV2Enabled = false
		unwalkEnabled = false
		antiLagEnabled = false
		antiDesyncEnabled = false
		autoCarrySpeedEnabled = false
		autoTPEnabled = false
		autoTPHeight = 20
		_youtAutoCarryState.applied = false
		_youtAutoCarryState.waiting = false
		_youtAutoCarryState.savedMode = nil
		uiLocked = false
		mobileButtonsLocked = false
		CONFIG.AUTO_STEAL_ENABLED = false
		selectedStealMode = "V1"
		tpBatMode = "V1"

		if _G._youtStealModeSetter then
			pcall(_G._youtStealModeSetter, "V1")
		end

		if _G._youtTpBatModeSetter then
			pcall(_G._youtTpBatModeSetter, "V1")
		end

		BAT_AIMBOT_SPEED = 58
		dropMode = 1
		stretchEnabled = false
		stretchFOV = 120
		uiScaleValue = 78

		if mainUIScale then
			mainUIScale.Scale = 1
		end

		if pbScale then
			pbScale.Scale = 1
		end

		espEnabled = false
		vividGraphicsEnabled = false
		hideButtonsEnabled = false
		bodyLockEnabled = false
		bodyLockRange = 20
		backgroundIndex = 3
		backgroundImageTransparency = 0
		backgroundMode = "Background 1"
		floatingButtonScale = 1

		if tpBatEnabled then
			stopBatDesyncTp()
		end

		currentAnimPack = "Off"
		v291()
		outfitIndex = 1
		currentColorTheme = "Pink"
		selectedColor = t2.Pink

		if main then
			main.Position = UDim2.new(0, 20, 0, 2)
		end

		for k, v in pairs(DEFAULT_KB) do
			if KB[k] then
				KB[k].kb = v.kb
				KB[k].gp = v.gp
			end
		end

		resetFloatingPositions()
		forceResetUI()
		updateProgressBarVisibility()
		refreshSpeedModeLabel()
		_lastSavedJSON = nil
	end)

	_isResetting = false

	if not ok then
		warn("[resetToFactoryDefaults]", result)
	end

	if ok then
		saveAllSettings(true)
	end

	return ok
end
updateProgressBarVisibility = function()
	local StealBarGui = LocalPlayer2:FindFirstChild("PlayerGui") and LocalPlayer2.PlayerGui:FindFirstChild("StealBarGui") or game:GetService("CoreGui"):FindFirstChild("StealBarGui")

	if StealBarGui and StealBarGui:FindFirstChild("StealBar") then
		StealBarGui.StealBar.Visible = CONFIG.AUTO_STEAL_ENABLED
	end
end
applyShimmerToText = function(p130, p131)
	local v1146 = p131 or 0.8
	local v1147 = getThemeColor()
	local UIGradient = Instance.new("UIGradient", p130)

	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v1147),
		ColorSequenceKeypoint.new(0.3, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(0.7, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(1, v1147)
	})
	UIGradient.Rotation = 45
	UIGradient.Offset = Vector2.new(0, 0)
	task.spawn(function()
		local n10 = 0

		while UIGradient and UIGradient.Parent do
			n10 += 0.02
			UIGradient.Offset = Vector2.new(math.sin(n10 * v1146) * 0.4, 0)
			task.wait(0.04)
		end
	end)

	return UIGradient
end
getDefaultButtonPosition = function(p132)
	local v1150 = ({
		DropBR = 0,
		AutoLeft = 1,
		AutoBat = 2,
		AutoRight = 3,
		TpDown = 4,
		Carry = 5,
		Lagger1 = 6,
		Lagger2 = 7,
		AntiDesync = 8
	})[p132] or 0

	return v1150 % 2 * 68, math.floor(v1150 / 2) * 78
end
_youtBuildAdaptStealBar = function()
	local StealBarGui = LocalPlayer2:FindFirstChild("PlayerGui") and LocalPlayer2.PlayerGui:FindFirstChild("StealBarGui")

	if StealBarGui then
		StealBarGui:Destroy()
	end

	local StealBarGui2 = game:GetService("CoreGui"):FindFirstChild("StealBarGui")

	if StealBarGui2 then
		StealBarGui2:Destroy()
	end

	local v1153 = getThemeColor()
	local v1154 = v1153:Lerp(Color3.fromRGB(0, 0, 0), 0.86)
	local v1155 = v1153:Lerp(Color3.fromRGB(0, 0, 0), 0.45)
	local v1156 = v1153:Lerp(Color3.fromRGB(255, 255, 255), 0.25)
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "StealBarGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 25
	pcall(function()
		if syn then
			if syn.protect_gui then
				syn.protect_gui(ScreenGui)
			end
		end
	end)

	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")
	end

	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Name = "StealBar"
	Frame.Size = UDim2.new(0, 340, 0, 60)
	Frame.Position = UDim2.new(0.5, -170, 1, -74)
	Frame.BackgroundColor3 = v1154
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.ClipsDescendants = true
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 16)

	local Frame2 = Instance.new("Frame", Frame)

	Frame2.Name = "ThemeOverlay"
	Frame2.Size = UDim2.new(1, 0, 1, 0)
	Frame2.BackgroundColor3 = v1153
	Frame2.BackgroundTransparency = 0.92
	Frame2.BorderSizePixel = 0
	Frame2.ZIndex = 0
	Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 16)

	local UIGradient = Instance.new("UIGradient", Frame2)

	UIGradient.Rotation = 45
	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.55),
		NumberSequenceKeypoint.new(0.5, 0.9),
		NumberSequenceKeypoint.new(1, 0.65)
	})

	local Frame3 = Instance.new("Frame", Frame)

	Frame3.Name = "StealWhiteGlow"
	Frame3.Size = UDim2.new(1, 0, 1, 0)
	Frame3.BackgroundColor3 = v1153
	Frame3.BackgroundTransparency = 1
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 1
	Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 16)

	local UIGradient2 = Instance.new("UIGradient", Frame3)

	UIGradient2.Rotation = 90
	UIGradient2.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.45),
		NumberSequenceKeypoint.new(0.5, 0.1),
		NumberSequenceKeypoint.new(1, 0.55)
	})

	local UIStroke = Instance.new("UIStroke", Frame)

	UIStroke.Color = v1153
	UIStroke.Thickness = 1.4
	UIStroke.Transparency = 0.2

	local Frame4 = Instance.new("Frame", Frame)

	Frame4.Name = "AccentLine"
	Frame4.Size = UDim2.new(1, -20, 0, 2)
	Frame4.Position = UDim2.new(0, 10, 0, 2)
	Frame4.BackgroundColor3 = v1153
	Frame4.BorderSizePixel = 0
	Frame4.ZIndex = 5
	Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)
	Instance.new("UIGradient", Frame4).Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.8),
		NumberSequenceKeypoint.new(0.5, 0),
		NumberSequenceKeypoint.new(1, 0.8)
	})

	local TextLabel2 = Instance.new("TextLabel", Frame)

	TextLabel2.Size = UDim2.new(0, 190, 0, 14)
	TextLabel2.Position = UDim2.new(1, -200, 0, 6)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = string.format("RADIUS  %s", tostring(CONFIG.STEAL_RANGE))
	TextLabel2.TextColor3 = v1155
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextSize = 12
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel2.ZIndex = 6

	local TextLabel3 = Instance.new("TextLabel", Frame)

	TextLabel3.Size = UDim2.new(0, 160, 0, 14)
	TextLabel3.Position = UDim2.new(0, 12, 0, 27)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = "0 FPS  |  0 ms"
	TextLabel3.TextColor3 = v1155
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextSize = 10
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.ZIndex = 6

	local TextLabel4 = Instance.new("TextLabel", Frame)

	TextLabel4.Name = "DiscordLabel"
	TextLabel4.Size = UDim2.new(0, 150, 0, 14)
	TextLabel4.Position = UDim2.new(1, -162, 0, 27)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Text = "zlhub.net"
	TextLabel4.TextColor3 = v1156
	TextLabel4.Font = Enum.Font.GothamBold
	TextLabel4.TextSize = 10
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel4.ZIndex = 6

	local TextLabel5 = Instance.new("TextLabel", Frame)

	TextLabel5.Size = UDim2.new(0, 80, 0, 18)
	TextLabel5.Position = UDim2.new(0, 12, 0, 5)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Text = "0%"
	TextLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel5.Font = Enum.Font.GothamBlack
	TextLabel5.TextSize = 15
	TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel5.ZIndex = 6

	local Frame5 = Instance.new("Frame", Frame)

	Frame5.Name = "ProgressTrack"
	Frame5.Size = UDim2.new(1, -20, 0, 12)
	Frame5.Position = UDim2.new(0, 10, 1, -20)
	Frame5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame5.BackgroundTransparency = 0.45
	Frame5.BorderSizePixel = 0
	Frame5.ClipsDescendants = true
	Frame5.ZIndex = 4
	Instance.new("UICorner", Frame5).CornerRadius = UDim.new(1, 0)

	local UIStroke2 = Instance.new("UIStroke", Frame5)

	UIStroke2.Color = v1153
	UIStroke2.Transparency = 0.55
	UIStroke2.Thickness = 1

	local Frame6 = Instance.new("Frame", Frame5)

	Frame6.Name = "Fill"
	Frame6.Size = UDim2.new(0, 0, 1, 0)
	Frame6.BackgroundColor3 = v1153
	Frame6.BackgroundTransparency = 0
	Frame6.BorderSizePixel = 0
	Frame6.ZIndex = 5
	Instance.new("UICorner", Frame6).CornerRadius = UDim.new(1, 0)

	local UIGradient3 = Instance.new("UIGradient", Frame6)

	UIGradient3.Rotation = 0
	UIGradient3.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v1153:Lerp(Color3.fromRGB(0, 0, 0), 0.35)),
		ColorSequenceKeypoint.new(0.5, v1153),
		ColorSequenceKeypoint.new(1, v1153:Lerp(Color3.fromRGB(255, 255, 255), 0.35))
	})

	local Frame7 = Instance.new("Frame", Frame6)

	Frame7.Size = UDim2.new(1, 0, 0, 3)
	Frame7.Position = UDim2.new(0, 0, 0, 1)
	Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame7.BackgroundTransparency = 0.5
	Frame7.BorderSizePixel = 0
	Frame7.ZIndex = 6
	Instance.new("UICorner", Frame7).CornerRadius = UDim.new(1, 0)

	local Frame8 = Instance.new("Frame", Frame6)

	Frame8.Name = "Shimmer"
	Frame8.Size = UDim2.new(0, 40, 1, 0)
	Frame8.Position = UDim2.new(0, -40, 0, 0)
	Frame8.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame8.BackgroundTransparency = 0.55
	Frame8.BorderSizePixel = 0
	Frame8.ZIndex = 7
	Instance.new("UIGradient", Frame8).Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.2),
		NumberSequenceKeypoint.new(1, 1)
	})
	task.spawn(function()
		while Frame and Frame.Parent do
			Frame8.Position = UDim2.new(0, -40, 0, 0)
			TweenService:Create(Frame8, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {
				Position = UDim2.new(1, 40, 0, 0)
			}):Play()
			task.wait(1.5)
		end
	end)
	progressFill = Frame6
	progressPct = TextLabel5
	pbFrame = Frame

	local u1175 = false
	local Position
	local Position2

	Frame.InputBegan:Connect(function(input)
		if uiLocked then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			u1175 = true
			Position = input.Position
			Position2 = Frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not u1175 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		local v1178 = input.Position - Position

		Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v1178.X, Position2.Y.Scale, Position2.Y.Offset + v1178.Y)
	end)
	UserInputService.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and u1175 then
			u1175 = false
			task.defer(function()
				pcall(saveAllSettings)
			end)
		end
	end)

	local UIScale = Instance.new("UIScale", Frame)

	UIScale.Name = "AdaptProgressBarScale"
	UIScale.Scale = uiScaleValue / 100
	pbScale = UIScale
	task.spawn(function()
		local now = tick()
		local t26 = {}
		local n11 = 60

		RunService.RenderStepped:Connect(function()
			local now2 = tick()
			local v1184 = now2 - now

			now = now2

			if v1184 > 0 then
				table.insert(t26, 1 / v1184)

				if #t26 > 30 then
					table.remove(t26, 1)
				end

				local n12 = 0

				for _, v in ipairs(t26) do
					n12 += v
				end

				n11 = n12 / #t26
			end
		end)

		while Frame and Frame.Parent do
			local n13 = 0

			pcall(function()
				n13 = LocalPlayer2:GetNetworkPing() * 1000
			end)
			TextLabel3.Text = string.format("%d FPS  |  %d ms", math.floor(n11 + 0.5), math.floor(n13 + 0.5))
			TextLabel2.Text = string.format("RADIUS  %s", tostring(CONFIG.STEAL_RANGE))
			task.wait(0.5)
		end
	end)

	local s2 = "IDLE"

	local function v1190(p133)
		s2 = p133

		if p133 == "STEALING" then
			local t27 = {
				Color = v1153,
				Transparency = 0,
				Thickness = 1.8
			}

			TweenService:Create(UIStroke, TweenInfo.new(0.22), t27):Play()
			TweenService:Create(Frame3, TweenInfo.new(0.28), {
				BackgroundTransparency = 0.55
			}):Play()

			local t28 = {
				TextColor3 = v1156
			}

			TweenService:Create(TextLabel2, TweenInfo.new(0.2), t28):Play()
			TweenService:Create(TextLabel5, TweenInfo.new(0.2), {
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
		elseif p133 == "READY" then
			local t29 = {
				Color = v1153,
				Transparency = 0.2,
				Thickness = 1.4
			}

			TweenService:Create(UIStroke, TweenInfo.new(0.25), t29):Play()
			TweenService:Create(Frame3, TweenInfo.new(0.3), {
				BackgroundTransparency = 1
			}):Play()

			local t30 = {
				TextColor3 = v1155
			}

			TweenService:Create(TextLabel2, TweenInfo.new(0.2), t30):Play()
			TweenService:Create(TextLabel5, TweenInfo.new(0.2), {
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
		else
			local t31 = {
				Color = v1153,
				Transparency = 0.45,
				Thickness = 1.2
			}

			TweenService:Create(UIStroke, TweenInfo.new(0.25), t31):Play()
			TweenService:Create(Frame3, TweenInfo.new(0.3), {
				BackgroundTransparency = 1
			}):Play()

			local t32 = {
				TextColor3 = v1155
			}

			TweenService:Create(TextLabel2, TweenInfo.new(0.2), t32):Play()
			TweenService:Create(TextLabel5, TweenInfo.new(0.2), {
				TextColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
		end
	end

	_G.YoutStealBar = {
		SetProgress = function(p134)
			local v1197 = math.clamp(p134 or 0, 0, 1)

			Frame6.Size = UDim2.new(v1197, 0, 1, 0)
			TextLabel5.Text = math.floor(v1197 * 100 + 0.5) .. "%"

			if s2 == "STEALING" then
				Frame3.BackgroundTransparency = 0.75 - v1197 * 0.5
				UIStroke.Transparency = math.max(0, 0.25 - v1197 * 0.25)
			end
		end,
		SetState = v1190,
		Reset = function()
			Frame6.Size = UDim2.new(0, 0, 1, 0)
			TextLabel5.Text = "0%"
			v1190("IDLE")
		end
	}
	v1190("IDLE")

	return ScreenGui
end

if not _G.InstaResetLoaded then
	_G.InstaResetLoaded = true

	local u1198 = false
	local thread
	local u1200
	local u1201 = false
	local u1202 = false
	local u1203 = false
	local CFrame_
	local n14 = 0

	local function v1206()
		if u1198 then
			return
		end

		u1198 = true
		u1201 = false
		u1202 = false
		u1203 = false

		local Character = LocalPlayer2.Character

		if not Character then
			u1198 = false

			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			u1198 = false

			return
		end

		if workspace.CurrentCamera then
			CFrame_ = workspace.CurrentCamera.CFrame
			u1203 = true
			workspace.CurrentCamera.CFrame = CFrame_
		end

		u1200 = Character

		local u1209 = false

		thread = task.spawn(function()
			local n15 = 0
			local HipHeight = Humanoid.HipHeight

			while Character and Character.Parent and Humanoid and Humanoid.Health > 0 and not (u1209 or u1202) do
				if LocalPlayer2.Character ~= Character then
					u1209 = true

					break
				end

				pcall(function()
					Humanoid.HipHeight = 1e30
					Humanoid.AutoRotate = true

					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

					if HumanoidRootPart then
						HumanoidRootPart.CanCollide = false
					end

					for _, child in ipairs(Character:GetChildren()) do
						if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
							child.CanCollide = false
						end
					end
				end)

				if Character and Character.Parent and Humanoid and not (Humanoid.Health <= 0 or LocalPlayer2.Character ~= Character) then
					n15 += 1

					if not (n15 >= 40) then
						task.wait(0.05)

						continue
					end
				else
					u1201 = true

					break
				end

				break
			end

			if not u1201 and Character and Character.Parent and Humanoid and Humanoid.Health > 0 and not u1209 then
				pcall(function()
					Humanoid.Health = 0
				end)
				task.wait(0.1)

				if not Character.Parent or Humanoid.Health <= 0 then
					u1201 = true
				end
			end

			if not u1201 and Character and Character.Parent and Humanoid then
				pcall(function()
					Humanoid.HipHeight = HipHeight

					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

					if HumanoidRootPart then
						HumanoidRootPart.CanCollide = true
					end

					for _, child in ipairs(Character:GetChildren()) do
						if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
							child.CanCollide = true
						end
					end
				end)
			end

			u1203 = false
			u1198 = false
			thread = nil
			u1200 = nil
			u1202 = false
		end)
	end
	local function v1218()
		local now = os.clock()

		if now - n14 < 0.75 then
			return
		end

		n14 = now
		v1206()
	end

	LocalPlayer2.CharacterAdded:Connect(function()
		u1202 = true

		if thread then
			pcall(task.cancel, thread)
			thread = nil
		end

		u1198 = false
		u1200 = nil
		u1203 = false
	end)
	task.spawn(function()
		while true do
			task.wait(0.016)

			local CurrentCamera2 = workspace.CurrentCamera

			if u1203 and CFrame_ and CurrentCamera2 then
				CurrentCamera2.CFrame = CFrame_
			end
		end
	end)
	_G.InstaReset = {
		Trigger = v1218
	}
end

buildGui = function()
	local color3 = Color3.fromRGB(10, 10, 10)
	local color32 = Color3.fromRGB(50, 50, 50)
	local color33 = Color3.fromRGB(255, 255, 255)
	local color34 = Color3.fromRGB(15, 15, 15)

	for _, v in ipairs({
		"Yout",
		"YoutMobilePanel",
		"TpBatButton",
		"InstaResetButton",
		"BatV2Button",
		"BloodHounds",
		"YoutBootErrors",
		"BloodHoundsGui",
		"BloodHoundsMobile",
		"BloodHoundsTPS",
		"YoutGui",
		"YoutMenu",
		"YoutV2",
		"YoutMain",
		"EnvyAutoBatDesyncGUI",
		"MwvaneNewaBatDesyncGUI",
		"PhazeAutoBatDesyncGUI",
		"VisionBatGui",
		"NyxAuraTPBat",
		"InstaResetGui",
		"TpBatGui",
		"TpBatFloating",
		"YoutAntiDesync",
		"AntiDesyncGui"
	}) do
		local v1227 = game:GetService("CoreGui"):FindFirstChild(v)

		if v1227 then
			pcall(function()
				v1227:Destroy()
			end)
		end

		local PlayerGui = LocalPlayer2:FindFirstChild("PlayerGui")

		if PlayerGui then
			local v1229 = PlayerGui:FindFirstChild(v)

			if v1229 then
				pcall(function()
					v1229:Destroy()
				end)
			end
		end
	end

	gui = Instance.new("ScreenGui")
	gui.Name = "Yout"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 10
	gui.IgnoreGuiInset = true
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(gui)
		end
	end)

	if not pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end) then
		gui.Parent = LocalPlayer2:WaitForChild("PlayerGui")
	end

	main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, 330, 0, 480)
	main.Position = UDim2.new(0, 20, 0, 2)
	main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	main.BackgroundTransparency = 1
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

	local Frame = Instance.new("Frame", main)

	Frame.Name = "ScriptHeader"
	Frame.Size = UDim2.new(1, -20, 0, 104)
	Frame.Position = UDim2.new(0, 10, 0, 0)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 8
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 13)

	local ImageLabel = Instance.new("ImageLabel", Frame)

	ImageLabel.Name = "ScriptLogo"
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = "rbxassetid://82512821999524"
	ImageLabel.ScaleType = Enum.ScaleType.Crop
	ImageLabel.ZIndex = 9

	local ImageLabel2 = Instance.new("ImageLabel", main)

	ImageLabel2.Name = "BackgroundImage"
	ImageLabel2.Size = UDim2.new(1, 0, 1, 0)
	ImageLabel2.Position = UDim2.new(0, 0, 0, 0)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
	ImageLabel2.ImageTransparency = backgroundImageTransparency
	ImageLabel2.ScaleType = Enum.ScaleType.Crop
	ImageLabel2.ZIndex = 0
	ImageLabel2.ClipsDescendants = true
	Instance.new("UICorner", ImageLabel2).CornerRadius = UDim.new(0, 18)
	mainUIScale = Instance.new("UIScale", main)
	mainUIScale.Scale = uiScaleValue / 100

	local TextButton = Instance.new("TextButton", main)

	TextButton.Size = UDim2.new(0, 32, 0, 32)
	TextButton.Position = UDim2.new(1, -42, 0, 8)
	TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	TextButton.BackgroundTransparency = 1
	TextButton.BorderSizePixel = 0
	TextButton.Text = "-"
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 30
	TextButton.AutoButtonColor = false
	TextButton.ZIndex = 200
	TextButton.MouseEnter:Connect(function()
		TweenService:Create(TextButton, TweenInfo.new(0.12), {
			TextColor3 = getThemeColor()
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		TweenService:Create(TextButton, TweenInfo.new(0.12), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end)
	miniBtn = Instance.new("TextButton", gui)
	miniBtn.Name = "MinimizedFrame"
	miniBtn.Size = UDim2.new(0, 150, 0, 36)
	miniBtn.Position = UDim2.new(0, 16, 0, 58)
	miniBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
	miniBtn.BackgroundTransparency = 0.05
	miniBtn.BorderSizePixel = 0
	miniBtn.Text = "$~ Z L"
	miniBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
	miniBtn.Font = Enum.Font.GothamBold
	miniBtn.TextSize = 13
	miniBtn.AutoButtonColor = false
	miniBtn.ZIndex = 20
	miniBtn.Visible = false
	Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 18)

	local UIStroke = Instance.new("UIStroke", miniBtn)

	UIStroke.Color = getThemeColor()
	UIStroke.Thickness = 1.2
	UIStroke.Transparency = 0.3
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local u1235 = false
	local Position = main.Position

	main:GetPropertyChangedSignal("Position"):Connect(function()
		if not u1235 then
			Position = main.Position
		end
	end)

	local UIScale = Instance.new("UIScale", main)

	UIScale.Scale = 1

	local tween
	local tween2

	showGui = function()
		if not main then
			return
		end

		if tween then
			tween:Cancel()
		end

		if tween2 then
			tween2:Cancel()
		end

		u1235 = true
		main.Visible = true
		miniBtn.Visible = false
		main.Position = UDim2.new(Position.X.Scale, Position.X.Offset - 60, Position.Y.Scale, Position.Y.Offset)
		UIScale.Scale = 0.5
		tween = TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Position = Position
		})
		TweenService:Create(UIScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = 1
		}):Play()
		tween:Play()
		tween.Completed:Connect(function()
			tween = nil
			u1235 = false
			main.Position = Position
		end)
	end
	hideGui = function()
		if not main or not main.Visible then
			return
		end

		if tween then
			tween:Cancel()
		end

		if tween2 then
			tween2:Cancel()
		end

		u1235 = true

		local uDim2 = UDim2.new(Position.X.Scale, Position.X.Offset - 60, Position.Y.Scale, Position.Y.Offset)

		tween2 = TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = uDim2
		})
		TweenService:Create(UIScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Scale = 0.5
		}):Play()
		tween2:Play()
		tween2.Completed:Connect(function()
			main.Visible = false
			miniBtn.Visible = true
			tween2 = nil
			u1235 = false
			main.Position = Position
		end)
	end
	TextButton.MouseButton1Click:Connect(hideGui)
	miniBtn.MouseButton1Click:Connect(showGui)

	local Frame2 = Instance.new("Frame", main)

	Frame2.Size = UDim2.new(1, -8, 0, 40)
	Frame2.Position = UDim2.new(0, 4, 0, 108)
	Frame2.BackgroundTransparency = 1
	Frame2.ZIndex = 10

	local UIListLayout = Instance.new("UIListLayout", Frame2)

	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 3)

	local Frame3 = Instance.new("Frame", main)

	Frame3.Size = UDim2.new(1, 0, 1, -158)
	Frame3.Position = UDim2.new(0, 0, 0, 154)
	Frame3.BackgroundTransparency = 1
	Frame3.ClipsDescendants = true
	Frame3.ZIndex = 5
	tabButtons = {}

	local t33 = {}

	for i, v in ipairs({
		"Speed",
		"Combat",
		"Visual",
		"Config",
		"Keybinds"
	}) do
		local TextButton2 = Instance.new("TextButton", Frame2)

		TextButton2.Size = UDim2.new(0, 62, 1, -6)
		TextButton2.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
		TextButton2.BackgroundTransparency = 1
		TextButton2.BorderSizePixel = 0
		TextButton2.Text = v
		TextButton2.TextColor3 = Color3.fromRGB(150, 150, 165)
		TextButton2.Font = Enum.Font.GothamBlack
		TextButton2.TextSize = 14
		TextButton2.AutoButtonColor = false
		TextButton2.ZIndex = 11
		Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 10)

		local UIGradient = Instance.new("UIGradient", TextButton2)

		UIGradient.Name = "TabBgGrad"
		UIGradient.Color = youtGradient(getThemeColor())
		UIGradient.Rotation = 0

		local UIStroke2 = Instance.new("UIStroke", TextButton2)

		UIStroke2.Name = "TabStroke"
		UIStroke2.Color = getThemeColor()
		UIStroke2.Thickness = 1.5
		UIStroke2.Transparency = 1

		local Frame4 = Instance.new("Frame", TextButton2)

		Frame4.Name = "Underline"
		Frame4.Size = UDim2.new(0, 34, 0, 3)
		Frame4.Position = UDim2.new(0.5, 0, 1, -3)
		Frame4.AnchorPoint = Vector2.new(0.5, 0)
		Frame4.BackgroundColor3 = getThemeColor()
		Frame4.BorderSizePixel = 0
		Frame4.Visible = false
		Frame4.ZIndex = 12
		Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)

		local ScrollingFrame = Instance.new("ScrollingFrame", Frame3)

		ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
		ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.ClipsDescendants = true
		ScrollingFrame.ScrollBarThickness = 2
		ScrollingFrame.ScrollBarImageColor3 = getThemeColor()
		ScrollingFrame.ScrollBarImageTransparency = 0.3
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		ScrollingFrame.ZIndex = 6
		ScrollingFrame.Visible = i == 1

		local UIListLayout2 = Instance.new("UIListLayout", ScrollingFrame)

		UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout2.Padding = UDim.new(0, 6)
		UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center

		local UIPadding = Instance.new("UIPadding", ScrollingFrame)

		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 8)
		UIPadding.PaddingTop = UDim.new(0, 6)
		UIPadding.PaddingBottom = UDim.new(0, 20)
		t33[v] = ScrollingFrame
		TextButton2.MouseButton1Click:Connect(function()
			for _, v3 in pairs(t33) do
				v3.Visible = false
			end

			ScrollingFrame.Visible = true

			for _, v3 in ipairs(tabButtons) do
				local Underline = v3:FindFirstChild("Underline")

				if Underline then
					Underline.Visible = false
				end

				local TabStroke = v3:FindFirstChild("TabStroke")

				TweenService:Create(v3, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(26, 26, 34),
					TextColor3 = Color3.fromRGB(150, 150, 165)
				}):Play()

				if TabStroke then
					TweenService:Create(TabStroke, TweenInfo.new(0.2), {
						Transparency = 1
					}):Play()
				end
			end

			local Underline = TextButton2:FindFirstChild("Underline")

			if Underline then
				Underline.Visible = true
			end

			local TabStroke = TextButton2:FindFirstChild("TabStroke")

			TweenService:Create(TextButton2, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
				BackgroundTransparency = 0.15,
				BackgroundColor3 = getThemeColor(),
				TextColor3 = Color3.fromRGB(245, 245, 255)
			}):Play()

			if TabStroke then
				TweenService:Create(TabStroke, TweenInfo.new(0.22), {
					Transparency = 0.3
				}):Play()
			end
		end)
		TextButton2.MouseEnter:Connect(function()
			if TextButton2:FindFirstChild("Underline") and TextButton2.Underline.Visible then
				return
			end

			TweenService:Create(TextButton2, TweenInfo.new(0.15), {
				BackgroundTransparency = 0.55,
				TextColor3 = Color3.fromRGB(215, 215, 230)
			}):Play()
		end)
		TextButton2.MouseLeave:Connect(function()
			if TextButton2:FindFirstChild("Underline") and TextButton2.Underline.Visible then
				return
			end

			TweenService:Create(TextButton2, TweenInfo.new(0.15), {
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(150, 150, 165)
			}):Play()
		end)
		table.insert(tabButtons, TextButton2)
	end

	if tabButtons[1] then
		local Underline = tabButtons[1]:FindFirstChild("Underline")

		if Underline then
			Underline.Visible = true
		end

		tabButtons[1].BackgroundColor3 = getThemeColor()
		tabButtons[1].BackgroundTransparency = 0.15
		tabButtons[1].TextColor3 = Color3.fromRGB(245, 245, 255)

		local TabStroke = tabButtons[1]:FindFirstChild("TabStroke")

		if TabStroke then
			TabStroke.Transparency = 0.3
		end
	end

	local t34 = {}

	local function v1265(p135)
		if not t34[p135] then
			t34[p135] = 0
		end

		t34[p135] += 1

		return t34[p135]
	end
	local function createFrame(p136, p137)
		local Frame4 = Instance.new("Frame", p136)

		Frame4.Size = UDim2.new(1, 0, 0, 30)
		Frame4.BackgroundTransparency = 1
		Frame4.BorderSizePixel = 0
		Frame4.LayoutOrder = v1265(p136)
		Frame4.ZIndex = 7

		local Frame5 = Instance.new("Frame", Frame4)

		Frame5.Name = "SectAccent"
		Frame5.Size = UDim2.new(0, 3, 0, 15)
		Frame5.Position = UDim2.new(0, 5, 0.5, -7)
		Frame5.AnchorPoint = Vector2.new(0, 0.5)
		Frame5.BackgroundColor3 = getThemeColor()
		Frame5.BorderSizePixel = 0
		Frame5.ZIndex = 8
		Instance.new("UICorner", Frame5).CornerRadius = UDim.new(1, 0)

		local UIGradient = Instance.new("UIGradient", Frame5)

		UIGradient.Color = youtGradient(getThemeColor())
		UIGradient.Rotation = 90

		local TextLabel2 = Instance.new("TextLabel", Frame4)

		TextLabel2.Size = UDim2.new(0.5, -24, 1, 0)
		TextLabel2.Position = UDim2.new(0, 14, 0, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = p137:upper()
		TextLabel2.TextColor3 = Color3.fromRGB(235, 235, 245)
		TextLabel2.Font = Enum.Font.GothamBlack
		TextLabel2.TextSize = 11
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.TextStrokeTransparency = 0.55
		TextLabel2.ZIndex = 8

		local Frame6 = Instance.new("Frame", Frame4)

		Frame6.Name = "SectLine"
		Frame6.Size = UDim2.new(0, 110, 0, 1)
		Frame6.Position = UDim2.new(1, -6, 0.5, 0)
		Frame6.AnchorPoint = Vector2.new(1, 0.5)
		Frame6.BackgroundColor3 = getThemeColor()
		Frame6.BorderSizePixel = 0
		Frame6.ZIndex = 8
		Instance.new("UIGradient", Frame6).Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.45),
			NumberSequenceKeypoint.new(1, 1)
		})

		return Frame4
	end
	local function createFrame2(p138, p139)
		local Frame4 = Instance.new("Frame", p138)

		Frame4.Size = UDim2.new(1, -4, 0, p139 or 42)
		Frame4.BackgroundColor3 = color3
		Frame4.BackgroundTransparency = 0.7
		Frame4.BorderSizePixel = 0
		Frame4.LayoutOrder = v1265(p138)
		Frame4.ZIndex = 7
		Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 11)

		local UIGradient = Instance.new("UIGradient", Frame4)

		UIGradient.Name = "RowGrad"
		UIGradient.Rotation = 90
		UIGradient.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 0.3)
		})

		local UIStroke2 = Instance.new("UIStroke", Frame4)

		UIStroke2.Color = color32
		UIStroke2.Thickness = 1
		UIStroke2.Transparency = 0.55
		Frame4.MouseEnter:Connect(function()
			TweenService:Create(Frame4, TweenInfo.new(0.15), {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26)
			}):Play()
			TweenService:Create(UIStroke2, TweenInfo.new(0.15), {
				Color = getThemeColor(),
				Transparency = 0.35
			}):Play()
		end)
		Frame4.MouseLeave:Connect(function()
			local t35 = {
				BackgroundColor3 = color3
			}

			TweenService:Create(Frame4, TweenInfo.new(0.15), t35):Play()

			local t36 = {
				Color = color32,
				Transparency = 0.55
			}

			TweenService:Create(UIStroke2, TweenInfo.new(0.15), t36):Play()
		end)

		return Frame4
	end
	local function createTextLabel(p140, p141)
		local TextLabel2 = Instance.new("TextLabel", p140)

		TextLabel2.Size = UDim2.new(0.55, 0, 1, 0)
		TextLabel2.Position = UDim2.new(0, 12, 0, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = p141
		TextLabel2.TextColor3 = Color3.fromRGB(240, 240, 250)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextSize = 14
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
		TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		TextLabel2.TextStrokeTransparency = 0.5
		TextLabel2.ZIndex = 8

		return TextLabel2
	end
	local function v1280(p142, p143)
		local Frame4 = Instance.new("Frame", p142)

		Frame4.Name = "Track"
		Frame4.Size = UDim2.new(0, 34, 0, 18)
		Frame4.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame4.Position = UDim2.new(1, -(p143 or 48), 0.5, 0)
		Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame4.BackgroundTransparency = 0.2
		Frame4.BorderSizePixel = 0
		Frame4.ZIndex = 8
		Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 9)

		local UIStroke2 = Instance.new("UIStroke", Frame4)

		UIStroke2.Color = color32
		UIStroke2.Thickness = 1
		UIStroke2.Transparency = 0.45
		UIStroke2.Name = "PillStroke"

		local UIGradient = Instance.new("UIGradient", Frame4)

		UIGradient.Name = "PillGrad"
		UIGradient.Color = youtGradient(getThemeColor())
		UIGradient.Enabled = false

		local Frame5 = Instance.new("Frame", Frame4)

		Frame5.Name = "Knob"
		Frame5.Size = UDim2.new(0, 13, 0, 13)
		Frame5.AnchorPoint = Vector2.new(0, 0)
		Frame5.Position = UDim2.new(0, 3, 0.5, -6)
		Frame5.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		Frame5.BorderSizePixel = 0
		Frame5.ZIndex = 9
		Instance.new("UICorner", Frame5).CornerRadius = UDim.new(1, 0)

		local Frame6 = Instance.new("Frame", Frame5)

		Frame6.Name = "Shine"
		Frame6.Size = UDim2.new(1, -4, 0, 4)
		Frame6.Position = UDim2.new(0, 2, 0, 2)
		Frame6.BackgroundColor3 = color33
		Frame6.BackgroundTransparency = 0.72
		Frame6.BorderSizePixel = 0
		Frame6.ZIndex = 10
		Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 4)

		return Frame4, Frame5
	end
	local function v1286(p144, p145, p146)
		local UIStroke2 = p144:FindFirstChildOfClass("UIStroke")
		local PillGrad = p144:FindFirstChild("PillGrad")
		local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		TweenService:Create(p145, tweenInfo, {
			Position = p146 and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
		}):Play()
		TweenService:Create(p144, tweenInfo, {
			BackgroundColor3 = p146 and getThemeColor() or Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = p146 and 0 or 0.2
		}):Play()

		if PillGrad then
			PillGrad.Color = youtGradient(getThemeColor())
			PillGrad.Enabled = p146
			PillGrad.Rotation = 0
		end

		if UIStroke2 then
			TweenService:Create(UIStroke2, tweenInfo, {
				Color = p146 and getThemeColor() or color32,
				Transparency = p146 and 0.2 or 0.45,
				Thickness = 1
			}):Play()
		end
	end
	local function v1290(p147, p148, p149)
		local v1291 = createFrame2(p147, 42)

		createTextLabel(v1291, p148)

		local v1292, v1293 = v1280(v1291, 48)
		local u1294 = false

		local function v1295(p150)
			u1294 = p150
			v1286(v1292, v1293, p150)
		end

		local TextButton2 = Instance.new("TextButton", v1292)

		TextButton2.Size = UDim2.new(1, 0, 1, 0)
		TextButton2.BackgroundTransparency = 1
		TextButton2.Text = ""
		TextButton2.AutoButtonColor = false
		TextButton2.ZIndex = 10
		TextButton2.MouseButton1Click:Connect(function()
			u1294 = not u1294
			v1295(u1294)
			pcall(p149, u1294)

			local function v1297()
				pcall(saveAllSettings)
			end

			task.defer(v1297)
		end)

		return v1295
	end
	local function createTextLabel2(p151, p152, p153, p154)
		local Frame4 = Instance.new("Frame", p151)

		Frame4.Size = UDim2.new(0, 160, 1, 0)
		Frame4.Position = UDim2.new(1, -168, 0, 0)
		Frame4.BackgroundTransparency = 1
		Frame4.ZIndex = 8

		local TextButton2 = Instance.new("TextButton", Frame4)

		TextButton2.Size = UDim2.new(0, 28, 0, 26)
		TextButton2.Position = UDim2.new(0, 0, 0.5, -13)
		TextButton2.BackgroundColor3 = color34
		TextButton2.BackgroundTransparency = 0.7
		TextButton2.BorderSizePixel = 0
		TextButton2.Text = "<"
		TextButton2.TextColor3 = color33
		TextButton2.Font = Enum.Font.GothamBold
		TextButton2.TextSize = 13
		TextButton2.AutoButtonColor = false
		TextButton2.ZIndex = 9
		Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)

		local TextLabel2 = Instance.new("TextLabel", Frame4)

		TextLabel2.Size = UDim2.new(0, 80, 0, 26)
		TextLabel2.Position = UDim2.new(0.5, -40, 0.5, -13)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = p152
		TextLabel2.TextColor3 = color33
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextSize = 12
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Center
		TextLabel2.ZIndex = 9

		local TextButton3 = Instance.new("TextButton", Frame4)

		TextButton3.Size = UDim2.new(0, 28, 0, 26)
		TextButton3.Position = UDim2.new(1, -28, 0.5, -13)
		TextButton3.BackgroundColor3 = color34
		TextButton3.BackgroundTransparency = 0.7
		TextButton3.BorderSizePixel = 0
		TextButton3.Text = ">"
		TextButton3.TextColor3 = color33
		TextButton3.Font = Enum.Font.GothamBold
		TextButton3.TextSize = 13
		TextButton3.AutoButtonColor = false
		TextButton3.ZIndex = 9
		Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)

		local function v1303(p155)
			TextLabel2.Text = p155
		end

		TextButton2.MouseButton1Click:Connect(function()
			if p154 then
				p154(-1, v1303)
				task.defer(function()
					pcall(saveAllSettings)
				end)
			end
		end)
		TextButton3.MouseButton1Click:Connect(function()
			if p154 then
				p154(1, v1303)
				task.defer(function()
					pcall(saveAllSettings)
				end)
			end
		end)

		return TextLabel2
	end
	local function createTextBox(p156, p157, p158, p159, p160)
		local TextBox = Instance.new("TextBox", p156)
		local v1306 = p158 or 50
		local v1307 = math.max(p159 or 56, v1306 + 12)

		TextBox.Size = UDim2.new(0, v1306, 0, 24)
		TextBox.Position = UDim2.new(1, -v1307, 0.5, -12)
		TextBox.BackgroundColor3 = color34
		TextBox.BackgroundTransparency = 0.7
		TextBox.BorderSizePixel = 0
		TextBox.Text = tostring(p157)
		TextBox.TextColor3 = color33
		TextBox.Font = Enum.Font.GothamBold
		TextBox.TextSize = 11
		TextBox.ClearTextOnFocus = false
		TextBox.ZIndex = 8
		Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)

		local UIStroke2 = Instance.new("UIStroke", TextBox)

		UIStroke2.Color = color32
		UIStroke2.Thickness = 1.2
		UIStroke2.Transparency = 0.25
		TextBox.Focused:Connect(function()
			TweenService:Create(UIStroke2, TweenInfo.new(0.12), {
				Color = getThemeColor(),
				Transparency = 0
			}):Play()
		end)
		TextBox.FocusLost:Connect(function()
			local t37 = {
				Color = color32,
				Transparency = 0.25
			}

			TweenService:Create(UIStroke2, TweenInfo.new(0.12), t37):Play()

			if p160 then
				local v1310 = tonumber(TextBox.Text)

				if v1310 then
					p160(v1310)
				else
					TextBox.Text = tostring(p157)
				end

				task.defer(function()
					saveAllSettings()
				end)
			end
		end)

		return TextBox
	end
	local function createTextButton(p161, p162)
		local TextButton2 = Instance.new("TextButton", p161)

		TextButton2.Size = UDim2.new(0, 80, 0, 24)
		TextButton2.Position = UDim2.new(1, -88, 0.5, -12)
		TextButton2.BackgroundColor3 = color34
		TextButton2.BackgroundTransparency = 0.5
		TextButton2.BorderSizePixel = 0

		local function v1313()
			return p162.gp and p162.gp.Name or p162.kb and p162.kb.Name or "None"
		end

		TextButton2.Text = v1313()
		TextButton2.TextColor3 = color33
		TextButton2.Font = Enum.Font.GothamBold
		TextButton2.TextSize = 9
		TextButton2.ZIndex = 8
		TextButton2.AutoButtonColor = false
		Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 6)

		local UIStroke2 = Instance.new("UIStroke", TextButton2)

		UIStroke2.Color = color32
		UIStroke2.Thickness = 1

		local u1315 = false
		local connection6
		local Text = TextButton2.Text
		local n16 = 0

		TextButton2.Activated:Connect(function()
			if not u1315 then
				Text = TextButton2.Text
				u1315 = true
				_anyKeyListening = true
				n16 = tick()
				TextButton2.Text = "..."
				TextButton2.TextColor3 = color33
				connection6 = UserInputService.InputBegan:Connect(function(input)
					if not u1315 then
						return
					end

					if input.KeyCode == Enum.KeyCode.Escape then
						u1315 = false
						_anyKeyListening = false

						if connection6 then
							connection6:Disconnect()
							connection6 = nil
						end

						TextButton2.Text = Text
						TextButton2.TextColor3 = color33

						return
					end

					local v1319 = isGamepadInput(input)

					if v1319 and tick() - n16 < 0.15 then
						return
					end

					if not isBindableInput(input) then
						return
					end

					TextButton2.Text = input.KeyCode.Name
					Text = input.KeyCode.Name
					TextButton2.TextColor3 = color33
					u1315 = false
					_anyKeyListening = false

					if connection6 then
						connection6:Disconnect()
						connection6 = nil
					end

					if v1319 then
						p162.gp = input.KeyCode
						p162.kb = nil
					else
						p162.kb = input.KeyCode
						p162.gp = nil
					end

					task.defer(function()
						saveAllSettings()
					end)
				end)

				return
			end

			u1315 = false
			_anyKeyListening = false

			if connection6 then
				connection6:Disconnect()
				connection6 = nil
			end

			TextButton2.Text = Text
			TextButton2.TextColor3 = color33
		end)
		table.insert(keyButtonRefs, {
			btn = TextButton2,
			entry = p162
		})

		return TextButton2
	end
	local function v1320(p163, p164, p165)
		local v1321 = createFrame2(p163, 40)

		createTextLabel(v1321, p164)
		createTextButton(v1321, p165)
	end

	local Speed = t33.Speed

	createFrame(Speed, "Movement Speeds")

	local v1323 = createFrame2(Speed, 42)

	createTextLabel(v1323, "Normal Speed")
	normalBox = createTextBox(v1323, NS, 50, 56, function(p166)
		if p166 > 0 and p166 <= 500 then
			NS = p166
		end
	end)

	local v1324 = createFrame2(Speed, 42)

	createTextLabel(v1324, "Carry Speed")
	carryBox = createTextBox(v1324, CS, 50, 56, function(p167)
		if p167 > 0 and p167 <= 500 then
			CS = p167
		end
	end)

	local v1325 = createFrame2(Speed, 42)

	createTextLabel(v1325, "Lagger Normal Speed")
	laggerBox = createTextBox(v1325, LAGGER_SPEED, 50, 56, function(p168)
		if p168 > 0 and p168 <= 500 then
			LAGGER_SPEED = p168
		end
	end)

	local v1326 = createFrame2(Speed, 42)

	createTextLabel(v1326, "Lagger Carry Speed")
	lagger2Box = createTextBox(v1326, LAGGER_CARRY_SPEED, 50, 56, function(p169)
		if p169 > 0 and p169 <= 500 then
			LAGGER_CARRY_SPEED = p169
		end
	end)
	createFrame(Speed, "Active Mode")

	local v1327 = createFrame2(Speed, 42)

	createTextLabel(v1327, "Current Mode")
	modeValLbl = Instance.new("TextLabel", v1327)
	modeValLbl.Size = UDim2.new(0, 110, 1, 0)
	modeValLbl.Position = UDim2.new(1, -118, 0, 0)
	modeValLbl.BackgroundTransparency = 1
	modeValLbl.Text = "Normal"
	modeValLbl.TextColor3 = color33
	modeValLbl.Font = Enum.Font.GothamBold
	modeValLbl.TextSize = 12
	modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
	modeValLbl.ZIndex = 8

	local TextButton2 = Instance.new("TextButton", v1327)

	TextButton2.Size = UDim2.new(1, 0, 1, 0)
	TextButton2.BackgroundTransparency = 1
	TextButton2.Text = ""
	TextButton2.AutoButtonColor = false
	TextButton2.ZIndex = 8
	TextButton2.MouseButton1Click:Connect(function()
		toggleCarryMode()
	end)
	createFrame(Speed, "Auto Movement")
	autoLeftSetVisual = v1290(Speed, "Auto Left", function(p170)
		autoLeftEnabled = p170

		if p170 then
			startAutoLeft()
		else
			stopAutoLeft()
		end

		if mobSetAutoLeft then
			mobSetAutoLeft(p170)
		end
	end)
	autoRightSetVisual = v1290(Speed, "Auto Right", function(p171)
		autoRightEnabled = p171

		if p171 then
			startAutoRight()
		else
			stopAutoRight()
		end

		if mobSetAutoRight then
			mobSetAutoRight(p171)
		end
	end)
	autoCarrySetVisual = v1290(Speed, "Auto Carry Speed", function(p172)
		setAutoCarrySpeedEnabled(p172)
	end)

	if autoCarrySetVisual then
		autoCarrySetVisual(autoCarrySpeedEnabled)
	end

	autoTPSetVisual = v1290(Speed, "Auto TP Down", function(p173)
		toggleAutoTP(p173)
	end)

	if autoTPSetVisual then
		autoTPSetVisual(autoTPEnabled)
	end

	local v1329 = createFrame2(Speed, 42)

	createTextLabel(v1329, "Auto TP Height")
	createTextBox(v1329, autoTPHeight, 50, 56, function(p174)
		if p174 and p174 >= -500 and p174 <= 500 then
			autoTPHeight = p174
			saveAllSettings()
		end
	end)

	local Combat = t33.Combat

	createFrame(Combat, "Defense")
	setAntiRagVisual = v1290(Combat, "Anti Ragdoll", function(p175)
		if p175 then
			v620()
			antiRagdollMode = "v2"
		else
			v630()
			antiRagdollMode = "off"
		end

		saveAllSettings()
	end)

	if setAntiRagVisual then
		setAntiRagVisual(antiRagdollMode == "v2")
	end

	setAntiDieVisual = v1290(Combat, "Anti Die", function(p176)
		antiDieEnabled = p176

		if p176 then
			antiDie.start()
		else
			antiDie.stop()
		end

		saveAllSettings()
	end)

	if setAntiDieVisual then
		setAntiDieVisual(antiDieEnabled)
	end

	setUnwalkVisual = v1290(Combat, "Unwalk", function(p177)
		unwalkEnabled = p177

		if p177 then
			startUnwalk()
		else
			stopUnwalk()
		end
	end)
	setAntiDesyncVisual = v1290(Combat, "Anti Desync", function(p178)
		if p178 then
			startAntiDesync()
		else
			stopAntiDesync()
		end
	end)

	if setAntiDesyncVisual then
		setAntiDesyncVisual(antiDesyncEnabled)
	end

	createFrame(Combat, "Attack")
	autoBatSetVisual = v1290(Combat, "Auto Bat", function(p179)
		if p179 then
			enableAutoBat()
		else
			disableAutoBat()
		end

		if mobSetAutoBat then
			mobSetAutoBat(p179)
		end
	end)

	local v1331 = createFrame2(Combat, 42)

	createTextLabel(v1331, "Bat Aimbot Speed")
	batSpeedBox = createTextBox(v1331, BAT_AIMBOT_SPEED, 50, 56, function(p180)
		if p180 > 0 and p180 <= 200 then
			BAT_AIMBOT_SPEED = p180
		end
	end)
	autoBatV2SetVisual = v1290(Combat, "Bat V2", function(p181)
		if p181 then
			enableBatV2()
		else
			disableBatV2()
		end
	end)

	if autoBatV2SetVisual then
		autoBatV2SetVisual(autoBatV2Enabled)
	end

	tpBat = v1290(Combat, "TP BAT", function(p182)
		if p182 then
			if not tpBatEnabled then
				toggleBatDesyncTp()
			end
		elseif tpBatEnabled then
			toggleBatDesyncTp()
		end
	end)

	if tpBat then
		tpBat(tpBatEnabled)
	end

	local v1332 = createFrame2(Combat, 42)

	createTextLabel(v1332, "TP BAT Mode")

	local Frame4 = Instance.new("Frame", v1332)

	Frame4.Name = "TpBatModeSelector"
	Frame4.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	Frame4.BackgroundTransparency = 0.15
	Frame4.Size = UDim2.new(0, 150, 0, 30)
	Frame4.Position = UDim2.new(1, -160, 0.5, -15)
	Frame4.BorderSizePixel = 0
	Frame4.ClipsDescendants = true
	Frame4.ZIndex = 8
	Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 15)

	local UIStroke2 = Instance.new("UIStroke", Frame4)

	UIStroke2.Color = Color3.fromRGB(60, 60, 70)
	UIStroke2.Thickness = 1
	UIStroke2.Transparency = 0.35

	local Frame5 = Instance.new("Frame", Frame4)

	Frame5.Name = "SelectedSlide"
	Frame5.BackgroundColor3 = getThemeColor()
	Frame5.BackgroundTransparency = 0.15
	Frame5.Size = UDim2.new(0.333, -3, 1, -4)
	Frame5.Position = UDim2.new(0, 2, 0, 2)
	Frame5.BorderSizePixel = 0
	Frame5.ZIndex = 9
	Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 13)

	local UIGradient = Instance.new("UIGradient", Frame5)

	UIGradient.Color = youtGradient(getThemeColor())
	UIGradient.Rotation = 0

	local UIStroke3 = Instance.new("UIStroke", Frame5)

	UIStroke3.Color = getThemeColor()
	UIStroke3.Thickness = 1.2
	UIStroke3.Transparency = 0.1

	local t38 = {}
	local t39 = {}

	for i, v in ipairs({
		"V1",
		"V2",
		"V3"
	}) do
		local TextLabel2 = Instance.new("TextLabel", Frame4)

		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = v
		TextLabel2.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 165)
		TextLabel2.Font = Enum.Font.GothamBlack
		TextLabel2.TextSize = 12
		TextLabel2.Size = UDim2.new(0.333, 0, 1, 0)
		TextLabel2.Position = UDim2.new((i - 1) * 0.333, 0, 0, 0)
		TextLabel2.ZIndex = 10
		t38[v] = TextLabel2

		local TextButton3 = Instance.new("TextButton", Frame4)

		TextButton3.BackgroundTransparency = 1
		TextButton3.Text = ""
		TextButton3.AutoButtonColor = false
		TextButton3.Size = UDim2.new(0.333, 0, 1, 0)
		TextButton3.Position = UDim2.new((i - 1) * 0.333, 0, 0, 0)
		TextButton3.ZIndex = 11
		t39[v] = TextButton3
	end

	local function youtTpBatModeSetter(p183)
		local v1345 = (p183 == "V2" or p183 == "V3") and p183
		local v1346 = v1345 or "V1"
		local v1347 = v1346 == "V1" and 0 or v1346 == "V2" and 1 or 2

		TweenService:Create(Frame5, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.new(v1347 * 0.333, v1347 == 0 and 2 or 0, 0, 2)
		}):Play()

		for k, v in pairs(t38) do
			local v1350 = TweenService
			local Create = TweenService.Create
			local v1352 = v
			local tweenInfo = TweenInfo.new(0.18)
			local color35 = k == v1346 and Color3.fromRGB(255, 255, 255)
			local t40 = {
				TextColor3 = color35 or Color3.fromRGB(150, 150, 165)
			}

			Create(v1350, v1352, tweenInfo, t40):Play()
		end
	end
	local function v1356(p184)
		local v1357 = (p184 == "V2" or p184 == "V3") and p184 or "V1"

		if v1357 == tpBatMode then
			return
		end

		tpBatMode = v1357
		youtTpBatModeSetter(tpBatMode)

		if tpBatEnabled then
			stopBatDesyncTp()
			task.defer(function()
				startBatDesyncTp()

				if tpBat then
					tpBat(true)
				end

				v817(true)
			end)
		end

		saveAllSettings()
	end

	for k, v in pairs(t39) do
		v.MouseButton1Click:Connect(function()
			v1356(k)
		end)
	end

	_G._youtTpBatSlide = Frame5
	_G._youtTpBatModeSetter = youtTpBatModeSetter
	youtTpBatModeSetter(tpBatMode)
	createFrame(Combat, "Targeting")
	bodyLockSetVisual = v1290(Combat, "Lock Enemy", function(p185)
		bodyLockEnabled = p185

		if p185 then
			if _blSuppressCount == 0 then
				startBodyLock()
			end
		else
			stopBodyLock()
		end
	end)

	local v1360 = createFrame2(Combat, 42)

	createTextLabel(v1360, "Lock Enemy Range")
	bodyLockRangeBox = createTextBox(v1360, bodyLockRange, 50, 56, function(p186)
		if p186 and p186 > 0 then
			bodyLockRange = math.clamp(math.floor(p186), 5, 200)

			if bodyLockRangeBox then
				bodyLockRangeBox.Text = tostring(bodyLockRange)
			end
		end
	end)
	createFrame(Combat, "Counters")
	setBatCounterVisual = v1290(Combat, "Bat Counter", function(p187)
		batCounterEnabled = p187

		if p187 then
			startBatCounter()
		else
			stopBatCounter()
		end
	end)
	setBatCounterV2Visual = v1290(Combat, "Bat Counter V2", function(p188)
		batCounterV2Enabled = p188

		if p188 then
			startBatCounterV2()
		else
			stopBatCounterV2()
		end
	end)
	setMedusaVisual = v1290(Combat, "Medusa Counter", function(p189)
		medusaCounterEnabled = p189

		if p189 then
			if LocalPlayer2.Character then
				setupMedusaCounter(LocalPlayer2.Character)
			else
				stopMedusaCounter()
			end
		else
			stopMedusaCounter()
		end

		if setMedusaVisual then
			setMedusaVisual(p189)
		end
	end)
	createFrame(Combat, "Drop")
	dropBrainrotSetVisual = v1290(Combat, "Drop Brainrot", function(p190)
		if p190 then
			executeDropWithToggle(function(p191)
				dropBrainrotSetVisual(p191)

				if mobSetDropBR then
					mobSetDropBR(p191)
				end
			end)
		end
	end)
	setDropVisual = dropBrainrotSetVisual

	local v1361 = createFrame2(Combat, 42)

	createTextLabel(v1361, "Drop Mode")
	dropModeBtnRef = createTextLabel2(v1361, dropMode == 1 and "Fling" or "Jump Drop", {
		"Fling",
		"Jump Drop"
	}, function(p192, p193)
		if dropActive then
			stopDropBrainrot()
		end

		dropMode = dropMode == 1 and 2 or 1
		p193(dropMode == 1 and "Fling" or "Jump Drop")
	end)

	local Visual = t33.Visual

	createFrame(Visual, "Interface")

	local v1363 = createFrame2(Visual, 42)

	createTextLabel(v1363, "Background")

	local t41 = {
		"None",
		"Background 1"
	}

	backgroundSelectorLabel = createTextLabel2(v1363, backgroundMode, t41, function(p194, p195)
		local v1365 = (backgroundMode == "None" and 1 or 2) + p194

		if v1365 < 1 then
			v1365 = #t41
		end

		if v1365 > #t41 then
			v1365 = 1
		end

		applyBackgroundMode(t41[v1365])
		p195(backgroundMode)
	end)
	applyBackgroundMode(backgroundMode)
	setLockUIVisual = v1290(Visual, "Lock UI", function(p196)
		toggleLockUI(p196)
	end)
	setHideButtonsVisual = v1290(Visual, "Hide Button", function(p197)
		toggleHideButtons(p197)
	end)

	if setHideButtonsVisual then
		setHideButtonsVisual(hideButtonsEnabled)
	end

	createFrame(Visual, "Display")

	local v1366 = createFrame2(Visual, 42)

	createTextLabel(v1366, "UI Scale")
	uiScaleBox = createTextBox(v1366, uiScaleValue, 50, 56, function(p198)
		local v1367 = math.clamp(math.floor(p198 + 0.5), 50, 150)

		uiScaleValue = v1367

		if mainUIScale then
			mainUIScale.Scale = v1367 / 100
		end

		if pbScale then
			pbScale.Scale = v1367 / 100
		end
	end)

	local v1368 = createFrame2(Visual, 42)

	createTextLabel(v1368, "Button Scale")
	createTextBox(v1368, math.floor(floatingButtonScale * 100), 50, 56, function(p199)
		floatingButtonScale = math.clamp(p199, 50, 200) / 100
		applyFloatingButtonScale()
		saveAllSettings()
	end)
	createFrame(Visual, "Character")

	local v1369 = createFrame2(Visual, 42)

	createTextLabel(v1369, "Anim Pack")

	local n17 = 1

	for i, v in ipairs(ANIM_PACK_ORDER) do
		if v[2] == currentAnimPack then
			n17 = i

			break
		end
	end

	local Frame6 = Instance.new("Frame", v1369)

	Frame6.Size = UDim2.new(0, 160, 1, 0)
	Frame6.Position = UDim2.new(1, -168, 0, 0)
	Frame6.BackgroundTransparency = 1
	Frame6.ZIndex = 8

	local TextButton3 = Instance.new("TextButton", Frame6)

	TextButton3.Size = UDim2.new(0, 28, 0, 26)
	TextButton3.Position = UDim2.new(0, 0, 0.5, -13)
	TextButton3.BackgroundColor3 = color34
	TextButton3.BackgroundTransparency = 0.7
	TextButton3.BorderSizePixel = 0
	TextButton3.Text = "<"
	TextButton3.TextColor3 = color33
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.TextSize = 13
	TextButton3.AutoButtonColor = false
	TextButton3.ZIndex = 9
	Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 6)
	animSelectorLabel = Instance.new("TextLabel", Frame6)
	animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
	animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
	animSelectorLabel.BackgroundTransparency = 1
	animSelectorLabel.Text = ANIM_PACK_ORDER[n17][2]
	animSelectorLabel.TextColor3 = color33
	animSelectorLabel.Font = Enum.Font.GothamBold
	animSelectorLabel.TextSize = 12
	animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
	animSelectorLabel.ZIndex = 9

	local TextButton4 = Instance.new("TextButton", Frame6)

	TextButton4.Size = UDim2.new(0, 28, 0, 26)
	TextButton4.Position = UDim2.new(1, -28, 0.5, -13)
	TextButton4.BackgroundColor3 = color34
	TextButton4.BackgroundTransparency = 0.7
	TextButton4.BorderSizePixel = 0
	TextButton4.Text = ">"
	TextButton4.TextColor3 = color33
	TextButton4.Font = Enum.Font.GothamBold
	TextButton4.TextSize = 13
	TextButton4.AutoButtonColor = false
	TextButton4.ZIndex = 9
	Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 6)

	local function v1376(p200)
		local n18 = 1

		for i, v in ipairs(ANIM_PACK_ORDER) do
			if v[2] == currentAnimPack then
				n18 = i

				break
			end
		end

		local v1380 = n18 + p200

		if v1380 < 1 then
			v1380 = #ANIM_PACK_ORDER
		end

		if v1380 > #ANIM_PACK_ORDER then
			v1380 = 1
		end

		local v1381 = ANIM_PACK_ORDER[v1380][2]

		if v1381 == "Off" then
			v291()
		else
			v286(v1381)
		end
	end

	TextButton3.MouseButton1Click:Connect(function()
		v1376(-1)
	end)
	TextButton4.MouseButton1Click:Connect(function()
		v1376(1)
	end)

	local v1382 = createFrame2(Visual, 42)

	createTextLabel(v1382, "Outfit")

	local Frame7 = Instance.new("Frame", v1382)

	Frame7.Size = UDim2.new(0, 160, 1, 0)
	Frame7.Position = UDim2.new(1, -168, 0, 0)
	Frame7.BackgroundTransparency = 1
	Frame7.ZIndex = 8

	local TextButton5 = Instance.new("TextButton", Frame7)

	TextButton5.Size = UDim2.new(0, 28, 0, 26)
	TextButton5.Position = UDim2.new(0, 0, 0.5, -13)
	TextButton5.BackgroundColor3 = color34
	TextButton5.BackgroundTransparency = 0.7
	TextButton5.BorderSizePixel = 0
	TextButton5.Text = "<"
	TextButton5.TextColor3 = color33
	TextButton5.Font = Enum.Font.GothamBold
	TextButton5.TextSize = 13
	TextButton5.AutoButtonColor = false
	TextButton5.ZIndex = 9
	Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 6)
	TextLabel = Instance.new("TextLabel", Frame7)
	TextLabel.Size = UDim2.new(0, 80, 0, 26)
	TextLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = t6[outfitIndex].label
	TextLabel.TextColor3 = color33
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 12
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel.ZIndex = 9

	local TextButton6 = Instance.new("TextButton", Frame7)

	TextButton6.Size = UDim2.new(0, 28, 0, 26)
	TextButton6.Position = UDim2.new(1, -28, 0.5, -13)
	TextButton6.BackgroundColor3 = color34
	TextButton6.BackgroundTransparency = 0.7
	TextButton6.BorderSizePixel = 0
	TextButton6.Text = ">"
	TextButton6.TextColor3 = color33
	TextButton6.Font = Enum.Font.GothamBold
	TextButton6.TextSize = 13
	TextButton6.AutoButtonColor = false
	TextButton6.ZIndex = 9
	Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 6)

	local function v1386(p201)
		local v1387 = outfitIndex + p201

		if v1387 < 1 then
			v1387 = #t6
		end

		if v1387 > #t6 then
			v1387 = 1
		end

		outfitIndex = v1387
		pcall(function()
			applyOutfitByIndex(outfitIndex)
		end)

		if TextLabel then
			TextLabel.Text = t6[outfitIndex].label
		end

		saveAllSettings()
	end

	TextButton5.MouseButton1Click:Connect(function()
		v1386(-1)
	end)
	TextButton6.MouseButton1Click:Connect(function()
		v1386(1)
	end)
	createFrame(Visual, "Effects")
	setVividVisual = v1290(Visual, "Vivid Graphics", function(p202)
		toggleVividGraphics(p202)

		if setVividVisual then
			setVividVisual(p202)
		end
	end)

	if setVividVisual then
		setVividVisual(vividGraphicsEnabled)
	end

	local v1388 = createFrame2(Visual, 42)

	createTextLabel(v1388, "Stretch Rez")

	local v1389, v1390 = v1280(v1388, 48)
	local u1391 = false

	local function stretchToggleSetter(p203)
		u1391 = p203
		v1286(v1389, v1390, p203)

		if p203 then
			enableStretch()
		else
			disableStretch()
		end

		stretchEnabled = p203
	end

	local TextButton7 = Instance.new("TextButton", v1389)

	TextButton7.Size = UDim2.new(1, 0, 1, 0)
	TextButton7.BackgroundTransparency = 1
	TextButton7.Text = ""
	TextButton7.AutoButtonColor = false
	TextButton7.ZIndex = 10
	TextButton7.MouseButton1Click:Connect(function()
		stretchToggleSetter(not u1391)
	end)
	_G.stretchToggleSetter = stretchToggleSetter
	setAntiLagVisual = v1290(Visual, "Anti Lag", function(p204)
		if p204 then
			enableAntiLag()
		else
			disableAntiLag()
		end
	end)

	local v1394 = createFrame2(Visual, 42)

	createTextLabel(v1394, "Sky Theme")

	local Frame8 = Instance.new("Frame", v1394)

	Frame8.Size = UDim2.new(0, 160, 1, 0)
	Frame8.Position = UDim2.new(1, -168, 0, 0)
	Frame8.BackgroundTransparency = 1
	Frame8.ZIndex = 8

	local TextButton8 = Instance.new("TextButton", Frame8)

	TextButton8.Size = UDim2.new(0, 28, 0, 26)
	TextButton8.Position = UDim2.new(0, 0, 0.5, -13)
	TextButton8.BackgroundColor3 = color34
	TextButton8.BackgroundTransparency = 0.7
	TextButton8.BorderSizePixel = 0
	TextButton8.Text = "<"
	TextButton8.TextColor3 = color33
	TextButton8.Font = Enum.Font.GothamBold
	TextButton8.TextSize = 13
	TextButton8.AutoButtonColor = false
	TextButton8.ZIndex = 9
	Instance.new("UICorner", TextButton8).CornerRadius = UDim.new(0, 6)
	skySelectorLabel = Instance.new("TextLabel", Frame8)
	skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
	skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
	skySelectorLabel.BackgroundTransparency = 1
	skySelectorLabel.Text = skyTheme
	skySelectorLabel.TextColor3 = color33
	skySelectorLabel.Font = Enum.Font.GothamBold
	skySelectorLabel.TextSize = 11
	skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
	skySelectorLabel.ZIndex = 9

	local TextButton9 = Instance.new("TextButton", Frame8)

	TextButton9.Size = UDim2.new(0, 28, 0, 26)
	TextButton9.Position = UDim2.new(1, -28, 0.5, -13)
	TextButton9.BackgroundColor3 = color34
	TextButton9.BackgroundTransparency = 0.7
	TextButton9.BorderSizePixel = 0
	TextButton9.Text = ">"
	TextButton9.TextColor3 = color33
	TextButton9.Font = Enum.Font.GothamBold
	TextButton9.TextSize = 13
	TextButton9.AutoButtonColor = false
	TextButton9.ZIndex = 9
	Instance.new("UICorner", TextButton9).CornerRadius = UDim.new(0, 6)

	local function v1398(p205)
		local n19 = 1

		for i, v in ipairs(SKY_PRESETS_LIST) do
			if v == skyTheme then
				n19 = i

				break
			end
		end

		local v1402 = n19 + p205

		if v1402 < 1 then
			v1402 = #SKY_PRESETS_LIST
		end

		if v1402 > #SKY_PRESETS_LIST then
			v1402 = 1
		end

		local v1403 = SKY_PRESETS_LIST[v1402]

		skyTheme = v1403
		pcall(applyCustomSky, v1403)

		if skySelectorLabel then
			skySelectorLabel.Text = v1403
		end

		pcall(saveAllSettings)
	end

	TextButton8.MouseButton1Click:Connect(function()
		v1398(-1)
	end)
	TextButton9.MouseButton1Click:Connect(function()
		v1398(1)
	end)
	createFrame(Visual, "Overlays")
	setESPVIsual = v1290(Visual, "Player ESP", function(p206)
		toggleESP(p206)
	end)

	local Config = t33.Config

	createFrame(Config, "Automation")

	local v1405 = createFrame2(Config, 42)

	createTextLabel(v1405, "Auto Steal Mode")

	local Frame9 = Instance.new("Frame", v1405)

	Frame9.Name = "StealModeSelector"
	Frame9.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	Frame9.BackgroundTransparency = 0.15
	Frame9.Size = UDim2.new(0, 150, 0, 30)
	Frame9.Position = UDim2.new(1, -160, 0.5, -15)
	Frame9.BorderSizePixel = 0
	Frame9.ClipsDescendants = true
	Frame9.ZIndex = 8
	Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 15)

	local UIStroke4 = Instance.new("UIStroke", Frame9)

	UIStroke4.Color = Color3.fromRGB(60, 60, 70)
	UIStroke4.Thickness = 1
	UIStroke4.Transparency = 0.35

	local Frame10 = Instance.new("Frame", Frame9)

	Frame10.Name = "SelectedSlide"
	Frame10.BackgroundColor3 = getThemeColor()
	Frame10.BackgroundTransparency = 0.15
	Frame10.Size = UDim2.new(0.333, -3, 1, -4)
	Frame10.Position = UDim2.new(0, 2, 0, 2)
	Frame10.BorderSizePixel = 0
	Frame10.ZIndex = 9
	Instance.new("UICorner", Frame10).CornerRadius = UDim.new(0, 13)

	local UIGradient2 = Instance.new("UIGradient", Frame10)

	UIGradient2.Color = youtGradient(getThemeColor())
	UIGradient2.Rotation = 0

	local UIStroke5 = Instance.new("UIStroke", Frame10)

	UIStroke5.Color = getThemeColor()
	UIStroke5.Thickness = 1.2
	UIStroke5.Transparency = 0.1

	local t42 = {}
	local t43 = {}

	for i, v in ipairs({
		"V1",
		"V2",
		"V3"
	}) do
		local TextLabel2 = Instance.new("TextLabel", Frame9)

		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = v
		TextLabel2.TextColor3 = i == 1 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 165)
		TextLabel2.Font = Enum.Font.GothamBlack
		TextLabel2.TextSize = 12
		TextLabel2.Size = UDim2.new(0.333, 0, 1, 0)
		TextLabel2.Position = UDim2.new((i - 1) * 0.333, 0, 0, 0)
		TextLabel2.ZIndex = 10
		t42[v] = TextLabel2

		local TextButton10 = Instance.new("TextButton", Frame9)

		TextButton10.BackgroundTransparency = 1
		TextButton10.Text = ""
		TextButton10.AutoButtonColor = false
		TextButton10.Size = UDim2.new(0.333, 0, 1, 0)
		TextButton10.Position = UDim2.new((i - 1) * 0.333, 0, 0, 0)
		TextButton10.ZIndex = 11
		t43[v] = TextButton10
	end

	local function youtStealModeSetter(p207)
		local v1418 = (p207 == "V2" or p207 == "V3") and p207
		local v1419 = v1418 or "V1"
		local v1420 = v1419 == "V1" and 0 or v1419 == "V2" and 1 or 2

		TweenService:Create(Frame10, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.new(v1420 * 0.333, v1420 == 0 and 2 or 0, 0, 2)
		}):Play()

		for k, v in pairs(t42) do
			local v1423 = TweenService
			local Create = TweenService.Create
			local v1425 = v
			local tweenInfo = TweenInfo.new(0.18)
			local color35 = k == v1419 and Color3.fromRGB(255, 255, 255)
			local t44 = {
				TextColor3 = color35 or Color3.fromRGB(150, 150, 165)
			}

			Create(v1423, v1425, tweenInfo, t44):Play()
		end
	end
	local function v1429(p208)
		local v1430 = (p208 == "V2" or p208 == "V3") and p208 or "V1"

		if v1430 == selectedStealMode then
			return
		end

		if selectedStealMode == "V3" then
			_G._youtStealRadiusV3 = CONFIG.STEAL_RANGE
		elseif selectedStealMode == "V2" then
			_G._youtStealRadiusV2 = CONFIG.STEAL_RANGE
		else
			_G._youtStealRadiusV1 = CONFIG.STEAL_RANGE
		end

		selectedStealMode = v1430

		if selectedStealMode == "V3" then
			CONFIG.STEAL_RANGE = _G._youtStealRadiusV3 or 63
		elseif selectedStealMode == "V2" then
			CONFIG.STEAL_RANGE = _G._youtStealRadiusV2 or 60
		else
			CONFIG.STEAL_RANGE = _G._youtStealRadiusV1 or 61
		end

		t12.StealRadius = CONFIG.STEAL_RANGE

		if radInput then
			radInput.Text = tostring(CONFIG.STEAL_RANGE)
		end

		youtStealModeSetter(selectedStealMode)

		if CONFIG.AUTO_STEAL_ENABLED then
			pcall(startAutoSteal)
		end

		saveAllSettings()
	end

	for k, v in pairs(t43) do
		v.MouseButton1Click:Connect(function()
			v1429(k)
		end)
	end

	_G._youtStealSlide = Frame10
	_G._youtStealModeSetter = youtStealModeSetter
	youtStealModeSetter(selectedStealMode)
	setInstaGrab = v1290(Config, "Auto Steal", function(p209)
		CONFIG.AUTO_STEAL_ENABLED = p209

		if p209 then
			pcall(startAutoSteal)
		else
			stopAutoSteal()
		end

		updateProgressBarVisibility()
	end)

	local v1433 = createFrame2(Config, 42)

	createTextLabel(v1433, "Steal Radius")
	radInput = createTextBox(v1433, CONFIG.STEAL_RANGE, 50, 56, function(p210)
		if p210 and p210 >= 5 then
			if p210 <= 300 then
				CONFIG.STEAL_RANGE = math.floor(p210 + 0.5)
				t12.StealRadius = CONFIG.STEAL_RANGE
				radInput.Text = tostring(CONFIG.STEAL_RANGE)

				if selectedStealMode == "V3" then
					_G._youtStealRadiusV3 = CONFIG.STEAL_RANGE
				elseif selectedStealMode == "V2" then
					_G._youtStealRadiusV2 = CONFIG.STEAL_RANGE
				else
					_G._youtStealRadiusV1 = CONFIG.STEAL_RANGE
				end

				saveAllSettings()
			end
		end
	end)
	createFrame(Config, "Management")

	local v1434 = createFrame2(Config, 44)

	v1434.Size = UDim2.new(1, 0, 0, 44)

	local TextButton10 = Instance.new("TextButton", v1434)

	TextButton10.Size = UDim2.new(1, -12, 0.8, 0)
	TextButton10.Position = UDim2.new(0, 6, 0.1, 0)
	TextButton10.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
	TextButton10.BorderSizePixel = 0
	TextButton10.Text = "SAVE CONFIG"
	TextButton10.TextColor3 = Color3.fromRGB(20, 20, 25)
	TextButton10.Font = Enum.Font.GothamBold
	TextButton10.TextSize = 13
	TextButton10.AutoButtonColor = false
	TextButton10.ZIndex = 8
	Instance.new("UICorner", TextButton10).CornerRadius = UDim.new(0, 10)

	local UIStroke6 = Instance.new("UIStroke", TextButton10)

	UIStroke6.Color = getThemeColor()
	UIStroke6.Thickness = 1.5
	UIStroke6.Transparency = 0.4
	TextButton10.MouseEnter:Connect(function()
		TweenService:Create(TextButton10, TweenInfo.new(0.15), {
			BackgroundColor3 = getThemeColor()
		}):Play()
		TweenService:Create(TextButton10, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end)
	TextButton10.MouseLeave:Connect(function()
		TweenService:Create(TextButton10, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(245, 245, 250)
		}):Play()
		TweenService:Create(TextButton10, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(20, 20, 25)
		}):Play()
	end)
	TextButton10.MouseButton1Click:Connect(function()
		TextButton10.Text = saveAllSettings(true) and "SAVED" or "ERROR"
		task.delay(1.2, function()
			if TextButton10 and TextButton10.Parent then
				TextButton10.Text = "SAVE CONFIG"
			end
		end)
	end)

	local v1437 = createFrame2(Config, 44)

	v1437.Size = UDim2.new(1, 0, 0, 44)

	local TextButton11 = Instance.new("TextButton", v1437)

	TextButton11.Size = UDim2.new(1, -12, 0.8, 0)
	TextButton11.Position = UDim2.new(0, 6, 0.1, 0)
	TextButton11.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
	TextButton11.BorderSizePixel = 0
	TextButton11.Text = "RESET POSITIONS"
	TextButton11.TextColor3 = Color3.fromRGB(20, 20, 25)
	TextButton11.Font = Enum.Font.GothamBold
	TextButton11.TextSize = 13
	TextButton11.AutoButtonColor = false
	TextButton11.ZIndex = 8
	Instance.new("UICorner", TextButton11).CornerRadius = UDim.new(0, 10)

	local UIStroke7 = Instance.new("UIStroke", TextButton11)

	UIStroke7.Color = getThemeColor()
	UIStroke7.Thickness = 1.5
	UIStroke7.Transparency = 0.4
	TextButton11.MouseEnter:Connect(function()
		TweenService:Create(TextButton11, TweenInfo.new(0.15), {
			BackgroundColor3 = getThemeColor()
		}):Play()
		TweenService:Create(TextButton11, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end)
	TextButton11.MouseLeave:Connect(function()
		TweenService:Create(TextButton11, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(245, 245, 250)
		}):Play()
		TweenService:Create(TextButton11, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(20, 20, 25)
		}):Play()
	end)

	local u1440 = false

	TextButton11.MouseButton1Click:Connect(function()
		if u1440 then
			return
		end

		u1440 = true
		resetFloatingPositions()
		TextButton11.Text = "RESET"
		task.delay(1.2, function()
			if TextButton11 and TextButton11.Parent then
				TextButton11.Text = "RESET POSITIONS"
				u1440 = false
			end
		end)
	end)

	local v1441 = createFrame2(Config, 44)

	v1441.Size = UDim2.new(1, 0, 0, 44)

	local TextButton12 = Instance.new("TextButton", v1441)

	TextButton12.Size = UDim2.new(1, -12, 0.8, 0)
	TextButton12.Position = UDim2.new(0, 6, 0.1, 0)
	TextButton12.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
	TextButton12.BorderSizePixel = 0
	TextButton12.Text = "RESET ALL SETTINGS"
	TextButton12.TextColor3 = Color3.fromRGB(170, 30, 50)
	TextButton12.Font = Enum.Font.GothamBold
	TextButton12.TextSize = 13
	TextButton12.AutoButtonColor = false
	TextButton12.ZIndex = 8
	Instance.new("UICorner", TextButton12).CornerRadius = UDim.new(0, 10)

	local UIStroke8 = Instance.new("UIStroke", TextButton12)

	UIStroke8.Color = Color3.fromRGB(200, 60, 80)
	UIStroke8.Thickness = 1.5
	UIStroke8.Transparency = 0.4
	TextButton12.MouseEnter:Connect(function()
		TweenService:Create(TextButton12, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(200, 50, 70)
		}):Play()
		TweenService:Create(TextButton12, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()
	end)
	TextButton12.MouseLeave:Connect(function()
		TweenService:Create(TextButton12, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(245, 245, 250)
		}):Play()
		TweenService:Create(TextButton12, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(170, 30, 50)
		}):Play()
	end)

	local n20 = 0
	local u1445 = false

	TextButton12.MouseButton1Click:Connect(function()
		if u1445 then
			return
		end

		if n20 == 0 then
			n20 = 1
			TextButton12.Text = "CONFIRM?"
			TextButton12.BackgroundColor3 = Color3.fromRGB(255, 220, 220)
			TextButton12.TextColor3 = Color3.fromRGB(160, 0, 0)
			task.delay(2, function()
				if TextButton12 and TextButton12.Parent then
					if n20 == 1 then
						n20 = 0
						TextButton12.Text = "RESET ALL SETTINGS"
						TextButton12.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
						TextButton12.TextColor3 = Color3.fromRGB(170, 30, 50)
					end
				end
			end)
		elseif n20 == 1 then
			u1445 = true

			local ok, result = pcall(resetToFactoryDefaults)

			TextButton12.Text = ok and result and "SETTINGS RESET" or "ERROR"
			TextButton12.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
			TextButton12.TextColor3 = Color3.fromRGB(170, 30, 50)
			n20 = 0
			task.delay(1.5, function()
				if TextButton12 and TextButton12.Parent then
					TextButton12.Text = "RESET ALL SETTINGS"
					TextButton12.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
					TextButton12.TextColor3 = Color3.fromRGB(170, 30, 50)
					u1445 = false
				end
			end)
		end
	end)

	local Keybinds = t33.Keybinds

	createFrame(Keybinds, "Keybinds")

	local v1449 = createFrame2(Keybinds, 40)

	createTextLabel(v1449, "Reset All Keybinds")

	local TextButton13 = Instance.new("TextButton", v1449)

	TextButton13.Size = UDim2.new(0, 92, 0, 24)
	TextButton13.Position = UDim2.new(1, -100, 0.5, -12)
	TextButton13.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
	TextButton13.BorderSizePixel = 0
	TextButton13.Text = "RESET"
	TextButton13.TextColor3 = Color3.fromRGB(170, 30, 50)
	TextButton13.Font = Enum.Font.GothamBold
	TextButton13.TextSize = 11
	TextButton13.ZIndex = 9
	Instance.new("UICorner", TextButton13).CornerRadius = UDim.new(0, 7)
	TextButton13.MouseButton1Click:Connect(function()
		for k, v in pairs(DEFAULT_KB) do
			if KB[k] then
				KB[k].kb = v.kb
				KB[k].gp = v.gp
			end
		end

		for _, v in ipairs(keyButtonRefs) do
			local entry = v.entry

			v.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
		end

		TextButton13.Text = "RESET"
		task.defer(function()
			saveAllSettings(true)
		end)
		task.delay(1, function()
			if TextButton13 and TextButton13.Parent then
				TextButton13.Text = "RESET"
			end
		end)
	end)
	createFrame(Keybinds, "Movement")
	v1320(Keybinds, "Carry Mode", KB.CarryToggle)
	v1320(Keybinds, "Lagger Mode", KB.LaggerMode)
	v1320(Keybinds, "Auto Left", KB.AutoLeft)
	v1320(Keybinds, "Auto Right", KB.AutoRight)
	createFrame(Keybinds, "Combat")
	v1320(Keybinds, "Auto Bat", KB.AutoBat)
	v1320(Keybinds, "Bat V2", KB.BatV2)
	v1320(Keybinds, "TP BAT", KB.TPBat)
	v1320(Keybinds, "Anti Desync", KB.AntiDesync)
	createFrame(Keybinds, "Utility")
	v1320(Keybinds, "Drop Brainrot", KB.DropBrainrot)
	v1320(Keybinds, "Insta Reset", KB.InstaReset)
	v1320(Keybinds, "TP Down", KB.TPFloor)
	v1320(Keybinds, "Hide GUI", KB.GuiHide)

	local Frame11 = Instance.new("Frame", Keybinds)

	Frame11.Size = UDim2.new(1, 0, 0, 16)
	Frame11.BackgroundTransparency = 1
	Frame11.LayoutOrder = v1265(Keybinds)
	Frame11.ZIndex = 7
end
createMobilePanel = function()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "YoutMobilePanel"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)

	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")
	end

	local t45 = {}
	local t46 = {
		"DROP\nBR",
		"AUTO\nLEFT",
		"BAT\nAIMBOT",
		"AUTO\nRIGHT",
		"TP\nDOWN",
		"CARRY\nSPD",
		"LAGGER\nNORMAL",
		"LAGGER\nCARRY",
		"ANTI\nDESYNC"
	}

	local function v1460(p211, p212, p213, p214, p215)
		local TextButton = Instance.new("TextButton", ScreenGui)

		TextButton.Name = p211
		TextButton.Size = UDim2.new(0, 60, 0, 60)
		TextButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
		TextButton.BorderSizePixel = 0
		TextButton.Text = ""
		TextButton.AutoButtonColor = false
		TextButton.ZIndex = 10

		local v1462 = savedButtonPositions[p211]

		if v1462 then
			if v1462.XScale == nil and v1462.YScale == nil then
				TextButton.Position = UDim2.new(0, v1462.X or 0, 0, v1462.Y or 0)
			else
				TextButton.Position = UDim2.new(v1462.XScale or 0, v1462.XOffset or 0, v1462.YScale or 0, v1462.YOffset or 0)
			end
		elseif p211 == "AntiDesync" then
			TextButton.Position = UDim2.new(0.5, -50, 0, 10)
		else
			local v1463, v1464 = getDefaultButtonPosition(p211)

			TextButton.Position = UDim2.new(0, v1463, 0, v1464)
		end

		TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 18)

		local UIGradient = Instance.new("UIGradient", TextButton)

		UIGradient.Name = "BtnGrad"
		UIGradient.Rotation = 90
		UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 150)),
			ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 210, 70)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 20))
		})

		local UIStroke = Instance.new("UIStroke", TextButton)

		UIStroke.Color = Color3.fromRGB(120, 120, 128)
		UIStroke.Thickness = 1
		UIStroke.Transparency = 0.55
		UIStroke.Name = "NormalStroke"

		local TextLabel2 = Instance.new("TextLabel", TextButton)

		TextLabel2.Name = "TextLabel"
		TextLabel2.Size = UDim2.new(1, 0, 1, 0)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = p212
		TextLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
		TextLabel2.Font = Enum.Font.GothamBlack
		TextLabel2.TextSize = 11
		TextLabel2.TextWrapped = true
		TextLabel2.ZIndex = 11

		local UIScale = Instance.new("UIScale", TextButton)

		UIScale.Scale = floatingButtonScale
		table.insert(_floatingUIScales, UIScale)

		local u1469 = false

		local function v1470(p216)
			u1469 = p216
			TextButton:SetAttribute("MobActive", p216 and true or false)
			paintFloatingBtn(TextButton, p216)
		end

		v1470(false)

		local u1471 = false
		local u1472 = false
		local Position
		local Position2
		local n21 = 0

		local function v1476(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				u1471 = true
				u1472 = false
				n21 = 0
				Position = input.Position
				Position2 = TextButton.Position
				_isDraggingButton = true
			end
		end
		local function v1477(input)
			if not u1471 then
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local v1478 = input.Position - Position

				n21 = v1478.Magnitude

				if not uiLocked then
					u1472 = true
					TextButton.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v1478.X, Position2.Y.Scale, Position2.Y.Offset + v1478.Y)
				end
			end
		end
		local function v1479(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and u1471 then
				if n21 < 12 then
					if p214 then
						if p215 then
							p215(v1470)
						end
					elseif p215 then
						p215(v1470, u1469)
					end
				elseif not uiLocked and u1472 then
					savedButtonPositions[p211] = {
						XScale = TextButton.Position.X.Scale,
						XOffset = TextButton.Position.X.Offset,
						YScale = TextButton.Position.Y.Scale,
						YOffset = TextButton.Position.Y.Offset
					}
					task.defer(function()
						pcall(saveAllSettings)
					end)
				end

				u1471 = false
				u1472 = false
				Position = nil
				Position2 = nil
				n21 = 0
				_isDraggingButton = false
			end
		end

		TextButton.InputBegan:Connect(v1476)
		TextButton.InputChanged:Connect(v1477)
		TextButton.InputEnded:Connect(v1479)
		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
				return
			end

			if u1471 then
				v1479(input)
			end
		end)
		t45[p211] = {
			btn = TextButton,
			setActive = v1470,
			label = TextLabel2
		}

		return v1470
	end

	for i, v in ipairs({
		"DropBR",
		"AutoLeft",
		"AutoBat",
		"AutoRight",
		"TpDown",
		"Carry",
		"Lagger1",
		"Lagger2",
		"AntiDesync"
	}) do
		local v1482 = t46[i]
		local v1483

		if v == "DropBR" then
			v1483 = function(p217)
				if autoBatEnabled then
					return
				end

				p217(true)
				executeDropWithToggle(function(p218)
					if dropBrainrotSetVisual then
						dropBrainrotSetVisual(p218)
					end
				end)
				task.delay(0.3, function()
					p217(false)
				end)
			end
		elseif v == "AutoLeft" then
			v1483 = function(p219)
				autoLeftEnabled = not autoLeftEnabled
				p219(autoLeftEnabled)

				if autoLeftEnabled then
					startAutoLeft()
				else
					stopAutoLeft()
				end

				if autoLeftSetVisual then
					autoLeftSetVisual(autoLeftEnabled)
				end
			end
		elseif v == "AutoBat" then
			v1483 = function(p220)
				if autoBatEnabled then
					disableAutoBat()
				else
					enableAutoBat()
				end

				p220(autoBatEnabled)
			end
		elseif v == "AutoRight" then
			v1483 = function(p221)
				autoRightEnabled = not autoRightEnabled
				p221(autoRightEnabled)

				if autoRightEnabled then
					startAutoRight()
				else
					stopAutoRight()
				end

				if autoRightSetVisual then
					autoRightSetVisual(autoRightEnabled)
				end
			end
		elseif v == "TpDown" then
			v1483 = function(p222)
				v613()
				p222(true)
				task.delay(0.2, function()
					p222(false)
				end)
			end
		elseif v == "Carry" then
			v1483 = function(p223)
				if speedMode then
					speedMode = false
					p223(false)
				else
					speedMode = true
					laggerToggled = false
					laggerCarryToggled = false
					p223(true)

					if t45.Lagger1 and t45.Lagger1.setActive then
						t45.Lagger1.setActive(false)
					end

					if t45.Lagger2 and t45.Lagger2.setActive then
						t45.Lagger2.setActive(false)
					end
				end

				refreshSpeedModeLabel()
			end
		elseif v == "Lagger1" then
			v1483 = function(p224)
				if speedMode then
					speedMode = false

					if mobSetCarry then
						mobSetCarry(false)
					end
				end

				if laggerToggled then
					laggerToggled = false
					p224(false)
				else
					laggerToggled = true
					laggerCarryToggled = false
					p224(true)

					if t45.Lagger2 and t45.Lagger2.setActive then
						t45.Lagger2.setActive(false)
					end
				end

				refreshSpeedModeLabel()
			end
		elseif v == "Lagger2" then
			v1483 = function(p225)
				if speedMode then
					speedMode = false

					if mobSetCarry then
						mobSetCarry(false)
					end
				end

				if laggerCarryToggled then
					laggerToggled = false
					p225(false)
				else
					laggerCarryToggled = true
					laggerToggled = false
					p225(true)

					if t45.Lagger1 and t45.Lagger1.setActive then
						t45.Lagger1.setActive(false)
					end
				end

				refreshSpeedModeLabel()
			end
		elseif v == "AntiDesync" then
			v1483 = function(p226)
				toggleAntiDesync()
				p226(antiDesyncEnabled)
			end
		end

		local v1484 = v1460(v, v1482, i - 1, true, v1483)

		if v == "AutoBat" then
			mobSetAutoBat = v1484
		end

		if v == "AutoLeft" then
			mobSetAutoLeft = v1484
		end

		if v == "AutoRight" then
			mobSetAutoRight = v1484
		end

		if v == "DropBR" then
			mobSetDropBR = v1484
		end

		if v == "TpDown" then
			mobSetTpDown = v1484
		end

		if v == "Carry" then
			mobSetCarry = v1484
		end

		if v == "Lagger1" then
			mobSetLagger1 = v1484
		end

		if v == "Lagger2" then
			mobSetLagger2 = v1484
		end

		if v == "AntiDesync" then
			mobSetAntiDesync = v1484
		end
	end

	if t45.AutoBat and t45.AutoBat.setActive then
		t45.AutoBat.setActive(autoBatEnabled)
	end

	if t45.AutoLeft and t45.AutoLeft.setActive then
		t45.AutoLeft.setActive(autoLeftEnabled)
	end

	if t45.AutoRight and t45.AutoRight.setActive then
		t45.AutoRight.setActive(autoRightEnabled)
	end

	if t45.Carry and t45.Carry.setActive then
		t45.Carry.setActive(speedMode)
	end

	if t45.Lagger1 and t45.Lagger1.setActive then
		t45.Lagger1.setActive(laggerToggled)
	end

	if t45.Lagger2 and t45.Lagger2.setActive then
		t45.Lagger2.setActive(laggerCarryToggled)
	end

	if t45.AntiDesync and t45.AntiDesync.setActive then
		t45.AntiDesync.setActive(antiDesyncEnabled)
	end

	return ScreenGui
end
createTpBatFloatingButton = function()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "TpBatButton"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 21
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)

	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")
	end

	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Size = UDim2.new(0, 60, 0, 60)
	Frame.Name = "Frame"

	if tpBatFloatingPos then
		Frame.Position = UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10)
	else
		Frame.Position = UDim2.new(0.5, 20, 0, 10)
	end

	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 20
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 18)

	local UIGradient = Instance.new("UIGradient", Frame)

	UIGradient.Name = "BtnGrad"
	UIGradient.Rotation = 90
	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 150)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 210, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 20))
	})

	local TextLabel2 = Instance.new("TextLabel", Frame)

	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "TP\nBAT"
	TextLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
	TextLabel2.Font = Enum.Font.GothamBlack
	TextLabel2.TextSize = 11
	TextLabel2.TextWrapped = true
	TextLabel2.ZIndex = 21

	local UIScale = Instance.new("UIScale", Frame)

	UIScale.Scale = floatingButtonScale
	table.insert(_floatingUIScales, UIScale)

	local function v1490(p227)
		TextLabel2.Text = "TP\nBAT"
		paintFloatingBtn(Frame, p227)
	end

	local u1491 = false
	local u1492 = false
	local Position
	local Position2

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			u1491 = true
			u1492 = false
			Position = input.Position
			Position2 = Frame.Position
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if not u1491 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local v1495 = input.Position - Position

			if v1495.Magnitude > 5 then
				u1492 = true
			end

			if u1492 and not uiLocked then
				Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v1495.X, Position2.Y.Scale, Position2.Y.Offset + v1495.Y)
			end
		end
	end)
	Frame.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and u1491 then
			if u1492 then
				if not uiLocked and u1492 then
					tpBatFloatingPos = {
						XScale = Frame.Position.X.Scale,
						XOffset = Frame.Position.X.Offset,
						YScale = Frame.Position.Y.Scale,
						YOffset = Frame.Position.Y.Offset
					}
					task.defer(function()
						pcall(saveAllSettings)
					end)
				end
			else
				toggleBatDesyncTp()
				v1490(tpBatEnabled)
			end

			u1491 = false
			u1492 = false
		end
	end)
	tpBatFloatingButton = ScreenGui

	return ScreenGui
end
createBatV2FloatingButton = function()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "BatV2Button"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 22
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)

	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")
	end

	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Size = UDim2.new(0, 60, 0, 60)
	Frame.Name = "Frame"

	if batV2FloatingPos then
		Frame.Position = UDim2.new(batV2FloatingPos.XScale or 0.5, batV2FloatingPos.XOffset or -50, batV2FloatingPos.YScale or 0, batV2FloatingPos.YOffset or 10)
	else
		Frame.Position = UDim2.new(0.5, -50, 0, 10)
	end

	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 20
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 18)

	local UIGradient = Instance.new("UIGradient", Frame)

	UIGradient.Name = "BtnGrad"
	UIGradient.Rotation = 90
	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 150)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 210, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 20))
	})

	local TextLabel2 = Instance.new("TextLabel", Frame)

	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "BAT\nV2"
	TextLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
	TextLabel2.Font = Enum.Font.GothamBlack
	TextLabel2.TextSize = 11
	TextLabel2.TextWrapped = true
	TextLabel2.ZIndex = 21

	local UIScale = Instance.new("UIScale", Frame)

	UIScale.Scale = floatingButtonScale
	table.insert(_floatingUIScales, UIScale)

	local function v1501(p228)
		paintFloatingBtn(Frame, p228)
	end

	local u1502 = false
	local u1503 = false
	local Position
	local Position2

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			u1502 = true
			u1503 = false
			Position = input.Position
			Position2 = Frame.Position
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if not u1502 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local v1506 = input.Position - Position

			if v1506.Magnitude > 5 then
				u1503 = true
			end

			if u1503 and not uiLocked then
				Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v1506.X, Position2.Y.Scale, Position2.Y.Offset + v1506.Y)
			end
		end
	end)
	Frame.InputEnded:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and u1502 then
			if u1503 then
				if not uiLocked and u1503 then
					batV2FloatingPos = {
						XScale = Frame.Position.X.Scale,
						XOffset = Frame.Position.X.Offset,
						YScale = Frame.Position.Y.Scale,
						YOffset = Frame.Position.Y.Offset
					}
					task.defer(function()
						pcall(saveAllSettings)
					end)
				end
			else
				v1501(not autoBatV2Enabled)
				toggleBatV2()
			end

			u1502 = false
			u1503 = false
		end
	end)
	batV2FloatingButton = ScreenGui

	return ScreenGui
end
createInstaResetFloatingButton = function()
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "InstaResetButton"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 23
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)

	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")
	end

	local Frame = Instance.new("Frame", ScreenGui)

	Frame.Size = UDim2.new(0, 60, 0, 60)
	Frame.Name = "Frame"

	if instaResetFloatingPos then
		Frame.Position = UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or 90, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10)
	else
		Frame.Position = UDim2.new(0.5, 90, 0, 10)
	end

	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 20
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 18)

	local UIGradient = Instance.new("UIGradient", Frame)

	UIGradient.Name = "BtnGrad"
	UIGradient.Rotation = 90
	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 235, 150)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 210, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 20))
	})

	local TextLabel2 = Instance.new("TextLabel", Frame)

	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = "INSTA\nRESET"
	TextLabel2.TextColor3 = Color3.fromRGB(32, 32, 40)
	TextLabel2.Font = Enum.Font.GothamBlack
	TextLabel2.TextSize = 11
	TextLabel2.TextWrapped = true
	TextLabel2.ZIndex = 21

	local UIScale = Instance.new("UIScale", Frame)

	UIScale.Scale = floatingButtonScale
	table.insert(_floatingUIScales, UIScale)

	local u1512
	local u1513
	local Position
	local Position2
	local u1516

	local function v1517(p229)
		local AbsolutePosition = Frame.AbsolutePosition
		local AbsoluteSize = Frame.AbsoluteSize

		return p229.X >= AbsolutePosition.X and p229.X <= AbsolutePosition.X + AbsoluteSize.X and p229.Y >= AbsolutePosition.Y and p229.Y <= AbsolutePosition.Y + AbsoluteSize.Y
	end
	local function v1520(p230)
		if p230 then
			TweenService:Create(Frame, TweenInfo.new(0.05), {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			}):Play()
			TweenService:Create(TextLabel2, TweenInfo.new(0.05), {
				TextColor3 = Color3.fromRGB(0, 0, 0)
			}):Play()
		else
			paintFloatingBtn(Frame, false)
		end
	end

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if u1516 then
				return
			end

			u1516 = input
			u1512 = true
			u1513 = false
			Position = input.Position
			Position2 = Frame.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not u1512 or not u1516 then
			return
		end

		if (u1516.UserInputType ~= Enum.UserInputType.Touch or input ~= u1516) and (u1516.UserInputType ~= Enum.UserInputType.MouseButton1 or input.UserInputType ~= Enum.UserInputType.MouseMovement) then
			return
		end

		local v1521 = input.Position - Position

		if v1521.Magnitude > 12 then
			u1513 = true
		end

		if u1513 and not uiLocked then
			Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v1521.X, Position2.Y.Scale, Position2.Y.Offset + v1521.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input ~= u1516 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if u1512 then
			if not u1513 and (input.Position - Position).Magnitude <= 12 and v1517(input.Position) then
				v1520(true)

				if _G.InstaReset and _G.InstaReset.Trigger then
					_G.InstaReset.Trigger()
				end

				task.delay(0.2, function()
					v1520(false)
				end)
			elseif not uiLocked and u1513 then
				instaResetFloatingPos = {
					XScale = Frame.Position.X.Scale,
					XOffset = Frame.Position.X.Offset,
					YScale = Frame.Position.Y.Scale,
					YOffset = Frame.Position.Y.Offset
				}
				pcall(saveAllSettings)
			end

			u1512 = false
			u1513 = false
			u1516 = nil
		end
	end)
	instaResetFloatingButton = ScreenGui

	return ScreenGui
end
batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil

local u1522 = false
local n22 = 0

local function v1524(p231)
	if not p231 or not p231.Character then
		return false
	end

	local Humanoid = p231.Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return false
	end

	local state = Humanoid:GetState()

	return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end
local function v1527(p232)
	if not p232 or not p232.Character then
		return false
	end

	for _, child in ipairs(p232.Character:GetChildren()) do
		if child:IsA("Tool") then
			if child:FindFirstChild("Handle") then
				return true
			end

			if child.Name:find("Animal") then
				return true
			end

			if child.Name:find("Pet") then
				return true
			end
		end
	end

	return false
end
local function v1530()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return nil
	end

	local v1533
	local huge = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer2 and player.Character and v1527(player) then
			local HumanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart2 and Humanoid and Humanoid.Health > 0 then
				local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

				if Magnitude < 12 and Magnitude < huge then
					huge = Magnitude
					v1533 = player
				end
			end
		end
	end

	return v1533
end
local function v1540()
	local Character = LocalPlayer2.Character

	if not Character then
		return nil
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Tool") then
			local v1544 = child.Name:lower()

			if v1544:find("bat") or v1544:find("slap") or v1544:find("sword") or v1544:find("knife") then
				return child
			end
		end
	end

	local Backpack = LocalPlayer2:FindFirstChild("Backpack")

	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") then
				local v1548 = child.Name:lower()

				if v1548:find("bat") or v1548:find("slap") or v1548:find("sword") then
					child.Parent = Character

					return child
				end

				if v1548:find("knife") then
					child.Parent = Character

					return child
				end
			end
		end
	end

	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") then
				child.Parent = Character

				return child
			end
		end
	end

	return nil
end
local function v1551()
	if batCounterV2HitCooldown then
		return
	end

	batCounterV2HitCooldown = true
	pcall(function()
		local v1552 = v1540()

		if v1552 then
			v1552:Activate()

			local RemoteEvent = v1552:FindFirstChildWhichIsA("RemoteEvent")

			if RemoteEvent then
				RemoteEvent:FireServer()
			end
		end
	end)
	task.delay(BAT_COUNTER_V2_SWING_CD, function()
		batCounterV2HitCooldown = false
	end)
end
local function v1554()
	local now = tick()

	if now - (n22 or 0) < 0.01 then
		return
	end

	if batCounterV2Debounce then
		return
	end

	batCounterV2Debounce = true
	n22 = now

	local v1556 = v1530()

	if not v1556 then
		batCounterV2Debounce = false

		return
	end

	if v1524(v1556) then
		batCounterV2Debounce = false

		return
	end

	if not v1527(v1556) then
		batCounterV2Debounce = false

		return
	end

	u1522 = tpBatEnabled

	if not tpBatEnabled then
		startBatDesyncTp()

		if tpBat then
			tpBat(true)
		end
	end

	local function v1557()
		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local Character2 = v1556.Character

		if not Character2 then
			return
		end

		local HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart2 then
			return
		end

		if not v1527(v1556) then
			batCounterV2Debounce = false

			return
		end

		if sethiddenproperty then
			sethiddenproperty(HumanoidRootPart, "PhysicsRepRootPart", HumanoidRootPart2)
		end

		local v1562 = HumanoidRootPart2.Position + Vector3.new(0, 0.9, 0)

		if (HumanoidRootPart.Position - v1562).Magnitude > 8 then
			HumanoidRootPart.CFrame = CFrame.new(v1562)
		end

		v1551()
		task.delay(0.05, function()
			v1551()
		end)
		task.delay(0.1, function()
			v1551()
		end)
	end

	v1557()
	task.delay(0.2, function()
		if not u1522 and tpBatEnabled then
			stopBatDesyncTp()

			if tpBat then
				tpBat(false)
			end
		end

		batCounterV2Debounce = false
	end)
end

stopBatCounterV2 = function()
	if batCounterV2Conn then
		batCounterV2Conn:Disconnect()
		batCounterV2Conn = nil
	end

	batCounterV2Debounce = false
	batCounterV2HitCooldown = false
end
startBatCounterV2 = function()
	if batCounterV2Conn then
		return
	end

	batCounterV2Conn = RunService.Heartbeat:Connect(function()
		if not batCounterV2Enabled then
			return
		end

		if batCounterV2Debounce then
			return
		end

		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid or Humanoid.Health <= 0 then
			return
		end

		local state = Humanoid:GetState()

		if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.GettingUp or state == Enum.HumanoidStateType.Stunned then
			local v1566 = v1530()

			if v1566 and not v1524(v1566) and v1527(v1566) then
				v1554()
			end
		end
	end)
end
toggleBatCounterV2 = function()
	batCounterV2Enabled = not batCounterV2Enabled

	if batCounterV2Enabled then
		startBatCounterV2()
	else
		stopBatCounterV2()
	end

	return batCounterV2Enabled
end
updateUIFromLoaded = function()
	task.wait()

	if normalBox then
		normalBox.Text = tostring(NS)
	end

	if carryBox then
		carryBox.Text = tostring(CS)
	end

	if radInput then
		radInput.Text = tostring(CONFIG.STEAL_RANGE)
	end

	if laggerBox then
		laggerBox.Text = tostring(LAGGER_SPEED)
	end

	if lagger2Box then
		lagger2Box.Text = tostring(LAGGER_CARRY_SPEED)
	end

	if batSpeedBox then
		batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED)
	end

	if uiScaleBox then
		uiScaleBox.Text = tostring(uiScaleValue)
	end

	if dropModeBtnRef then
		dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop"
	end

	if bodyLockRangeBox then
		bodyLockRangeBox.Text = tostring(bodyLockRange)
	end

	refreshSpeedModeLabel()

	for _, v in ipairs(keyButtonRefs) do
		local entry = v.entry

		v.btn.Text = entry.gp and entry.gp.Name or entry.kb and entry.kb.Name or "None"
	end

	applyBackgroundMode(backgroundMode)
	applyFloatingButtonScale()

	if uiLocked and setLockUIVisual then
		setLockUIVisual(true)
	end

	if antiRagdollMode == "v2" then
		if setAntiRagVisual then
			setAntiRagVisual(true)
		end

		v620()
	elseif setAntiRagVisual then
		setAntiRagVisual(false)
	end

	if antiDieEnabled then
		if setAntiDieVisual then
			setAntiDieVisual(true)
		end

		antiDie.start()
	elseif setAntiDieVisual then
		setAntiDieVisual(false)
	end

	if antiDesyncEnabled then
		if setAntiDesyncVisual then
			setAntiDesyncVisual(true)
		end

		if mobSetAntiDesync then
			mobSetAntiDesync(true)
		end

		startAntiDesync()
	else
		if setAntiDesyncVisual then
			setAntiDesyncVisual(false)
		end

		if mobSetAntiDesync then
			mobSetAntiDesync(false)
		end
	end

	if autoCarrySetVisual then
		autoCarrySetVisual(autoCarrySpeedEnabled)
	end

	if autoTPSetVisual then
		autoTPSetVisual(autoTPEnabled)
	end

	if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then
		setInstaGrab(true)
		pcall(startAutoSteal)
	end

	if medusaCounterEnabled then
		if setMedusaVisual then
			setMedusaVisual(true)
		end

		if LocalPlayer2.Character then
			setupMedusaCounter(LocalPlayer2.Character)
		end
	else
		if setMedusaVisual then
			setMedusaVisual(false)
		end

		stopMedusaCounter()
	end

	if batCounterEnabled and setBatCounterVisual then
		setBatCounterVisual(true)
		startBatCounter()
	end

	if batCounterV2Enabled and setBatCounterV2Visual then
		setBatCounterV2Visual(true)
		startBatCounterV2()
	end

	if unwalkEnabled and setUnwalkVisual then
		setUnwalkVisual(true)
		task.spawn(function()
			task.wait(0.5)
			startUnwalk()
		end)
	end

	if antiLagEnabled then
		if setAntiLagVisual then
			setAntiLagVisual(true)
		end

		enableAntiLag()
	else
		if setAntiLagVisual then
			setAntiLagVisual(false)
		end

		disableAntiLag()
	end

	if espEnabled then
		toggleESP(true)

		if setESPVIsual then
			setESPVIsual(true)
		end
	else
		toggleESP(false)

		if setESPVIsual then
			setESPVIsual(false)
		end
	end

	if vividGraphicsEnabled then
		enableVividGraphics()

		if setVividVisual then
			setVividVisual(true)
		end
	else
		disableVividGraphics()

		if setVividVisual then
			setVividVisual(false)
		end
	end

	if tpBatEnabled then
		if tpBat then
			tpBat(true)
		end

		if not connection4 then
			startBatDesyncTp()
		end

		v817(true)
	else
		if tpBat then
			tpBat(false)
		end

		v817(false)
	end

	if autoBatV2Enabled then
		if autoBatV2SetVisual then
			autoBatV2SetVisual(true)
		end

		if not _batV2Conn then
			v933()
		end

		if batV2FloatingButton then
			local Frame = batV2FloatingButton:FindFirstChild("Frame")

			if Frame then
				paintFloatingBtn(Frame, true)
			end
		end
	else
		if autoBatV2SetVisual then
			autoBatV2SetVisual(false)
		end

		if batV2FloatingButton then
			local Frame = batV2FloatingButton:FindFirstChild("Frame")

			if Frame then
				paintFloatingBtn(Frame, false)
			end
		end
	end

	if stretchEnabled then
		enableStretch()

		if _G.stretchToggleSetter then
			_G.stretchToggleSetter(true)
		end
	elseif _G.stretchToggleSetter then
		_G.stretchToggleSetter(false)
	end

	if mobSetAutoBat then
		mobSetAutoBat(autoBatEnabled)
	end

	if mobSetAutoLeft then
		mobSetAutoLeft(autoLeftEnabled)
	end

	if mobSetAutoRight then
		mobSetAutoRight(autoRightEnabled)
	end

	if mobSetCarry then
		mobSetCarry(speedMode)
	end

	if mobSetLagger1 then
		mobSetLagger1(laggerToggled)
	end

	if mobSetLagger2 then
		mobSetLagger2(laggerCarryToggled)
	end

	if bodyLockEnabled and bodyLockSetVisual then
		if _blSuppressCount == 0 then
			bodyLockSetVisual(true)
			startBodyLock()
		else
			bodyLockSetVisual(false)
		end
	end

	if _G._youtTpBatModeSetter then
		pcall(_G._youtTpBatModeSetter, tpBatMode)
	end

	updateProgressBarVisibility()
	startEnemySpeed()
	toggleLockUI(uiLocked)
	pcall(function()
		applyOutfitByIndex(outfitIndex)
	end)

	if TextLabel then
		TextLabel.Text = t6[outfitIndex].label
	end
end

local t47 = {}

local function v1573(p233, p234)
	local ok, result = pcall(p234)

	if not ok then
		table.insert(t47, {
			name = p233,
			err = tostring(result)
		})
		warn("[$~ ZL Boot] Error en '" .. p233 .. "': " .. tostring(result))
	end

	return ok
end

v1573("buildGui", function()
	buildGui()
end)

if gui and main then
	v1573("buildAdaptStealBar", function()
		_youtBuildAdaptStealBar()
	end)
	v1573("loadAllSettings", function()
		if loadAllSettings() then
			updateUIFromLoaded()
		end
	end)
	v1573("createMobilePanel", function()
		MobilePanel = createMobilePanel()
	end)
	v1573("createTpBatFloatingButton", function()
		tpBatFloatingButton = createTpBatFloatingButton()
	end)
	v1573("createBatV2FloatingButton", function()
		batV2FloatingButton = createBatV2FloatingButton()
	end)
	v1573("createInstaResetFloatingButton", function()
		instaResetFloatingButton = createInstaResetFloatingButton()
	end)
	v1573("offscreenFallback", function()
		task.defer(function()
			if main then
				if miniBtn then
					local CurrentCamera2 = workspace.CurrentCamera
					local X = CurrentCamera2 and CurrentCamera2.ViewportSize.X or 1920
					local Y = CurrentCamera2 and CurrentCamera2.ViewportSize.Y or 1080
					local AbsolutePosition = main.AbsolutePosition
					local AbsoluteSize = main.AbsoluteSize

					if AbsolutePosition.X + AbsoluteSize.X < 20 or AbsolutePosition.Y + AbsoluteSize.Y < 20 or AbsolutePosition.X > X - 20 or AbsolutePosition.Y > Y - 20 then
						main.Visible = false
						miniBtn.Visible = true
					end

					return
				end
			end
		end)
	end)

	if hideButtonsEnabled then
		v1573("applyHideButtons", function()
			applyHideButtons(true)

			if setHideButtonsVisual then
				setHideButtonsVisual(true)
			end
		end)
	end

	v1573("localizeYoutInterface", function()
		if gui then
			v32(gui)
		end

		if MobilePanel then
			v32(MobilePanel)
		end

		if tpBatFloatingButton then
			v32(tpBatFloatingButton)
		end

		if batV2FloatingButton then
			v32(batV2FloatingButton)
		end

		if instaResetFloatingButton then
			v32(instaResetFloatingButton)
		end
	end)

	if LocalPlayer2.Character then
		task.spawn(function()
			task.wait(0.1)

			if v44(LocalPlayer2.Character, 5) then
				pcall(function()
					v147(LocalPlayer2.Character)
				end)
				pcall(function()
					setupMovementAndIndicators(LocalPlayer2.Character)
				end)

				if currentAnimPack ~= "Off" then
					pcall(function()
						v286(currentAnimPack)
					end)
				end

				pcall(function()
					applyOutfitByIndex(outfitIndex)
				end)
			end
		end)
	end

	if #t47 > 0 then
		task.defer(function()
			pcall(function()
				local ScreenGui = Instance.new("ScreenGui")

				ScreenGui.Name = "YoutBootErrors"
				ScreenGui.ResetOnSpawn = false
				ScreenGui.DisplayOrder = 999
				pcall(function()
					ScreenGui.Parent = game:GetService("CoreGui")
				end)

				if not ScreenGui.Parent then
					ScreenGui.Parent = LocalPlayer2:WaitForChild("PlayerGui")
				end

				local Frame = Instance.new("Frame", ScreenGui)

				Frame.Size = UDim2.new(0, 400, 0, 60 + #t47 * 22)
				Frame.Position = UDim2.new(0, 10, 1, -80 - #t47 * 22)
				Frame.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
				Frame.BorderSizePixel = 0
				Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

				local UIStroke = Instance.new("UIStroke", Frame)

				UIStroke.Color = Color3.fromRGB(255, 80, 90)
				UIStroke.Thickness = 1.5

				local TextLabel2 = Instance.new("TextLabel", Frame)

				TextLabel2.Size = UDim2.new(1, -20, 0, 24)
				TextLabel2.Position = UDim2.new(0, 10, 0, 8)
				TextLabel2.BackgroundTransparency = 1
				TextLabel2.Text = "⚠ $~ ZL: " .. #t47 .. " sección(es) fallaron"
				TextLabel2.TextColor3 = Color3.fromRGB(255, 100, 110)
				TextLabel2.Font = Enum.Font.GothamBold
				TextLabel2.TextSize = 13
				TextLabel2.TextXAlignment = Enum.TextXAlignment.Left

				for i, v in ipairs(t47) do
					local TextLabel3 = Instance.new("TextLabel", Frame)

					TextLabel3.Size = UDim2.new(1, -20, 0, 18)
					TextLabel3.Position = UDim2.new(0, 10, 0, 34 + (i - 1) * 20)
					TextLabel3.BackgroundTransparency = 1
					TextLabel3.Text = "• " .. v.name .. ": " .. v.err:sub(1, 80)
					TextLabel3.TextColor3 = Color3.fromRGB(255, 180, 180)
					TextLabel3.Font = Enum.Font.Code
					TextLabel3.TextSize = 10
					TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel3.TextTruncate = Enum.TextTruncate.AtEnd
				end

				task.delay(15, function()
					pcall(function()
						ScreenGui:Destroy()
					end)
				end)
			end)
		end)
	end
else
	warn("[$~ ZL Boot] Fatal: buildGui falló. El script no puede continuar.")
	_G.BloodHoundsRunning = false
end

if LocalPlayer2 and LocalPlayer2.CharacterAdded then
	pcall(function()
		local n23 = 0

		LocalPlayer2.CharacterAdded:Connect(function(character)
			pcall(function()
				n23 += 1

				local v1589 = n23

				if connection then
					connection:Disconnect()
					connection = nil
				end

				u294 = false

				if stopAutoLeft then
					stopAutoLeft()
				end

				if stopAutoRight then
					stopAutoRight()
				end

				if stopBatCounter then
					stopBatCounter()
				end

				if stopBatCounterV2 then
					stopBatCounterV2()
				end

				if stopMedusaCounter then
					stopMedusaCounter()
				end

				if not u824 and stopUnwalk then
					stopUnwalk()
				end

				if stopDropBrainrot then
					stopDropBrainrot()
				end

				if autoBatEnabled and disableAutoBat then
					disableAutoBat()
				end

				if tpBatEnabled and stopBatDesyncTp then
					stopBatDesyncTp()
				end

				if autoBatV2Enabled and _batV2Conn then
					v943()
				end

				if antiDesyncEnabled and stopAntiDesync then
					stopAntiDesync()
				end

				if bodyLockEnabled and stopBodyLock then
					stopBodyLock()
				end

				local v1590 = tick() + 5

				while true do
					if character.Parent and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChildOfClass("Humanoid") then
						t10 = {}

						local v1591 = v258(character)

						v261(v1591)

						if not u146 then
							task.defer(function()
								v147(character)
							end)
						end

						if setupMovementAndIndicators then
							setupMovementAndIndicators(character)
						end

						if antiRagdollMode == "v2" then
							v620()
						end

						if antiDie.enabled then
							task.defer(function()
								v633(character)
							end)
						end

						if CONFIG.AUTO_STEAL_ENABLED then
							pcall(startAutoSteal)
						end

						if tpBatEnabled then
							task.defer(startBatDesyncTp)
						end

						if autoBatV2Enabled then
							task.defer(v933)
						end

						if antiDesyncEnabled then
							task.defer(function()
								task.wait(0.3)

								if antiDesyncEnabled then
									startAntiDesync()
								end
							end)
						end

						if autoTPEnabled then
							task.defer(startAutoTP)
						end

						if bodyLockEnabled and _blSuppressCount == 0 then
							startBodyLock()
						end

						if medusaCounterEnabled then
							setupMedusaCounter(character)

							if setMedusaVisual then
								setMedusaVisual(true)
							end
						else
							stopMedusaCounter()

							if setMedusaVisual then
								setMedusaVisual(false)
							end
						end

						if batCounterEnabled then
							startBatCounter()
						end

						if batCounterV2Enabled then
							startBatCounterV2()
						end

						if unwalkEnabled and not u824 then
							startUnwalk()
						end

						if currentAnimPack ~= "Off" then
							task.wait(0.3)
							v286(currentAnimPack)
						end

						updateProgressBarVisibility()
						refreshSpeedModeLabel()
						pcall(function()
							applyOutfitByIndex(outfitIndex)
						end)

						if TextLabel then
							TextLabel.Text = t6[outfitIndex].label
						end

						return
					end

					if v1590 < tick() then
						return
					end

					if v1589 ~= n23 then
						break
					end

					task.wait(0.05)
				end
			end)
		end)
	end)
end

local n24 = 0

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if _anyKeyListening then
		return
	end

	if input.UserInputType == Enum.UserInputType.Keyboard then
		if gameProcessed or UserInputService:GetFocusedTextBox() then
			return
		end
	elseif not isGamepadInput(input) then
		return
	end

	if not isBindableInput(input) then
		return
	end

	local KeyCode = input.KeyCode

	if not KeyCode then
		return
	end

	if kbMatch(KB.LaggerMode, KeyCode) then
		if tick() - n24 >= 0.3 then
			n24 = tick()
			toggleLaggerCycle()
		end

		return
	end

	if kbMatch(KB.CarryToggle, KeyCode) then
		toggleCarryMode()

		return
	end

	if kbMatch(KB.DropBrainrot, KeyCode) then
		if not dropActive then
			if dropBrainrotSetVisual then
				dropBrainrotSetVisual(true)
			end

			executeDropWithToggle(dropBrainrotSetVisual)
		end

		return
	end

	if kbMatch(KB.TPFloor, KeyCode) then
		v613()

		return
	end

	if kbMatch(KB.InstaReset, KeyCode) then
		if _G.InstaReset then
			if _G.InstaReset.Trigger then
				_G.InstaReset.Trigger()
			end
		end

		return
	end

	if kbMatch(KB.AutoLeft, KeyCode) then
		autoLeftEnabled = not autoLeftEnabled

		if autoLeftEnabled then
			startAutoLeft()
		else
			stopAutoLeft()
		end

		if autoLeftSetVisual then
			autoLeftSetVisual(autoLeftEnabled)
		end

		if mobSetAutoLeft then
			mobSetAutoLeft(autoLeftEnabled)
		end

		return
	end

	if kbMatch(KB.AutoRight, KeyCode) then
		autoRightEnabled = not autoRightEnabled

		if autoRightEnabled then
			startAutoRight()
		else
			stopAutoRight()
		end

		if autoRightSetVisual then
			autoRightSetVisual(autoRightEnabled)
		end

		if mobSetAutoRight then
			mobSetAutoRight(autoRightEnabled)
		end

		return
	end

	if kbMatch(KB.AutoBat, KeyCode) then
		if autoBatEnabled then
			disableAutoBat()

			if autoBatSetVisual then
				autoBatSetVisual(false)
			end

			if mobSetAutoBat then
				mobSetAutoBat(false)
			end
		else
			enableAutoBat()

			if autoBatSetVisual then
				autoBatSetVisual(true)
			end

			if mobSetAutoBat then
				mobSetAutoBat(true)
			end
		end

		return
	end

	if kbMatch(KB.BatV2, KeyCode) then
		toggleBatV2()

		if autoBatV2SetVisual then
			autoBatV2SetVisual(autoBatV2Enabled)
		end

		if batV2FloatingButton then
			local Frame = batV2FloatingButton:FindFirstChild("Frame")

			if Frame then
				paintFloatingBtn(Frame, autoBatV2Enabled)
			end
		end

		return
	end

	if kbMatch(KB.TPBat, KeyCode) then
		toggleBatDesyncTp()

		if tpBat then
			tpBat(tpBatEnabled)
		end

		if tpBatFloatingButton then
			local Frame = tpBatFloatingButton:FindFirstChild("Frame")

			if Frame then
				paintFloatingBtn(Frame, tpBatEnabled)
			end
		end

		return
	end

	if kbMatch(KB.AntiDesync, KeyCode) then
		toggleAntiDesync()

		if setAntiDesyncVisual then
			setAntiDesyncVisual(antiDesyncEnabled)
		end

		if mobSetAntiDesync then
			mobSetAntiDesync(antiDesyncEnabled)
		end

		return
	end

	if not kbMatch(KB.GuiHide, KeyCode) then
		return
	end

	if main then
		if main.Visible then
			hideGui()
		else
			showGui()
		end
	end
end)