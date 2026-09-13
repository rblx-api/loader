-- ============================================================
--  STARTUP / CLEANUP
-- ============================================================
if not game:IsLoaded() then game.Loaded:Wait() end

-- ============================================================
-- HIGH PING ALERT (>150 ms, once per script execution)
-- ============================================================
task.spawn(function()
	local env = (getgenv and getgenv()) or _G
	env.__BLESS_HIGH_PING_RUN = (env.__BLESS_HIGH_PING_RUN or 0) + 1
	local thisRun = env.__BLESS_HIGH_PING_RUN
	env.__BLESS_INTRO_FINISHED_RUN = 0
	local shown = false

	local function getPingMilliseconds()
		local ok, value = pcall(function()
			local stats = game:GetService("Stats")
			local network = stats:FindFirstChild("Network")
			local serverStats = network and network:FindFirstChild("ServerStatsItem")
			local pingItem = serverStats and (serverStats:FindFirstChild("Data Ping") or serverStats:FindFirstChild("Ping"))
			if not pingItem then return nil end
			local numericValue
			pcall(function() numericValue = pingItem:GetValue() end)
			if type(numericValue) == "number" then return numericValue end
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
		pcall(function() local old = CoreGui:FindFirstChild("BlessHighPingAlert"); if old then old:Destroy() end end)
		pcall(function() local old = playerGui and playerGui:FindFirstChild("BlessHighPingAlert"); if old then old:Destroy() end end)
		local gui = Instance.new("ScreenGui")
		gui.Name = "BlessHighPingAlert"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = false
		gui.DisplayOrder = 10000
		gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
		local parented = pcall(function() gui.Parent = CoreGui end)
		if not parented or not gui.Parent then gui.Parent = playerGui end
		if not gui.Parent then gui:Destroy(); return end
		local bar = Instance.new("Frame")
		bar.Name = "AlertBar"
		bar.AnchorPoint = Vector2.new(0.5, 0)
		bar.Position = UDim2.new(0.5, 0, 0, -44)
		bar.Size = UDim2.new(0, 310, 0, 32)
		bar.BackgroundColor3 = Color3.fromRGB(205, 0, 0)
		bar.BackgroundTransparency = 0.06
		bar.BorderSizePixel = 0
		bar.ClipsDescendants = true
		bar.ZIndex = 100
		bar.Parent = gui
		local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 11); corner.Parent = bar
		local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(255, 12, 12); stroke.Transparency = 0.2; stroke.Thickness = 1; stroke.Parent = bar
		local gradient = Instance.new("UIGradient")
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 0)),
		})
		gradient.Parent = bar
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.new(0, 10, 0, 0)
		label.Size = UDim2.new(1, -20, 1, 0)
		label.Font = Enum.Font.GothamBold
		label.Text = "high ping! Your ping is more than 150."
		label.TextColor3 = Color3.fromRGB(255, 55, 55)
		label.TextSize = 13
		label.TextStrokeColor3 = Color3.fromRGB(55, 0, 0)
		label.TextStrokeTransparency = 0.55
		label.TextWrapped = false
		label.TextScaled = false
		label.ZIndex = 102
		label.Parent = bar
		local slideIn = TweenService:Create(bar, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 10)})
		slideIn:Play(); slideIn.Completed:Wait()
		task.wait(2)
		local slideOut = TweenService:Create(bar, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -44)})
		slideOut:Play(); slideOut.Completed:Wait()
		gui:Destroy()
	end

	-- Esperar a que el juego cargue y haya datos de ping
	task.wait(5)
	while env.__BLESS_HIGH_PING_RUN == thisRun and not shown do
		local ping = getPingMilliseconds()
		if ping and ping > 150 then
			shown = true
			showHighPingAlert()
			break
		end
		task.wait(1)
	end
end)
Players,RunService,UIS,TS,Lighting,HS,SoundService = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService"),game:GetService("SoundService")
CoreGui = game:GetService("CoreGui")
LP = Players.LocalPlayer
UI_NAME = "blessvs"
MOBILE_UI_NAME = "blessvsMobileButtons"
pcall(function()
	local old=CoreGui:FindFirstChild(UI_NAME);if old then old:Destroy() end
	local oldMobile=CoreGui:FindFirstChild(MOBILE_UI_NAME);if oldMobile then oldMobile:Destroy() end
end)
pcall(function()
	local pg=LP:FindFirstChild("PlayerGui")
	if pg then
		local old=pg:FindFirstChild(UI_NAME);if old then old:Destroy() end
		local oldMobile=pg:FindFirstChild(MOBILE_UI_NAME);if oldMobile then oldMobile:Destroy() end
	end
end)
_G.blessvsRunning = true

-- ============================================================
--  BRANDING / THEME
-- ============================================================
BLESS_BRAND = "bless.vs"
BLESS_DISCORD = "discord.gg/blessvs"
BLESS_COLORS = {
	BG = Color3.fromRGB(10,5,8),
	PANEL = Color3.fromRGB(18,8,12),
	CARD = Color3.fromRGB(28,10,16),
	ACCENT = Color3.fromRGB(220,50,80),
	ICE = Color3.fromRGB(255,100,60),
	HOVER = Color3.fromRGB(255,80,100),
	TEXT = Color3.fromRGB(255,240,240),
	SECONDARY = Color3.fromRGB(180,140,145),
	STROKE = Color3.fromRGB(160,30,50),
	INPUT = Color3.fromRGB(220,50,80),
	OFF = Color3.fromRGB(50,20,28),
	DARK_ACCENT = Color3.fromRGB(120,15,30),
	LIGHT_GLOW = Color3.fromRGB(255,150,150)
}

-- ============================================================
--  CONFIG / STATE
-- ============================================================
showIntroEnabled = false
uiLocked = false
uiScaleValue = 1
mobileButtonScaleValue = 1
editMobileButtons = false
hideMobileButtons = false
mobileButtonPositions = {}
mobileGroupPosition = nil
mainUIScale, mobileUIScale = nil, nil
instaResetPanelOpen = false
instaResetPanelPosition = nil
instaResetPanelRef = nil
setInstaResetPanelVisible = nil
setInstaResetBtnText = nil
bgImgRef = nil  -- referencia a la imagen de fondo
fondosPanelOpen = false
fondosPanelPosition = nil
setFondosPanelVisible = nil
setFondosBtnText = nil
instaResetDefaultPos = UDim2.new(0, 10, 0, 300)
instaResetFrameRef = nil
blessLaggerPanelOpen = false
blessLaggerPanelPosition = nil
blessLaggerPanelRef = nil
setBlessLaggerPanelVisible = nil
animationsPanelOpen = false
animationsPanelPosition = nil
animationsPanelRef = nil
setAnimationsPanelVisible = nil
currentAnimPack = nil
setBlessLaggerVisual = nil
blessLaggerUiEnabled = false
blessLaggerActive = false
blessLaggerLoopId = 0
currentSkyTheme = "Night"
setLockGuiVisual, setTopLockVisual, setEditMobileVisual, setHideMobileVisual = nil, nil, nil, nil
uiSizeSetters, mobileSizeSetters = {}, {}
mobileButtonFrames = {}
mobileButtonsScreen = nil
mobileButtonContainerRef = nil
MobileButtonActions = {}
showCandyGui, hideCandyGui, isCandyGuiVisible = nil, nil, nil
function refreshMobileButtonUi()
	if mobileButtonsScreen then mobileButtonsScreen.Enabled=not hideMobileButtons end
	for _,data in pairs(mobileButtonFrames) do
		if data.stroke then
			data.stroke.Transparency=editMobileButtons and 0.06 or 0.34
			data.stroke.Thickness=editMobileButtons and 1.45 or 1
		end
	end
end
function resetMobileButtonLayout()
	mobileButtonPositions={}
	mobileGroupPosition=nil
	for id,data in pairs(mobileButtonFrames) do
		if data.frame and data.defaultPosition then
			data.frame.Position=data.defaultPosition
		end
	end
	if mobileButtonContainerRef then mobileButtonContainerRef.Position=UDim2.new(1,-20,0.12,0) end
	if mobileUIScale then mobileUIScale.Scale=mobileButtonScaleValue end
	for _,refresh in ipairs(mobileSizeSetters) do refresh() end
	refreshMobileButtonUi()
	-- Resetear también el botón flotante Insta Reset a su posición por defecto
	if instaResetFrameRef then instaResetFrameRef.Position=instaResetDefaultPos end
end
NS,CS = 60,30
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
speedMode,antiRagdollEnabled,antiDieEnabled,infJumpEnabled = false,false,false,false
laggerToggled = false
laggerCarryToggled = false  -- lagger carry mode (CleanHub)
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
medusaDebounce,medusaLastUsed,dropActive = false,0,false
autoLeftEnabled,autoRightEnabled = false,false
autoLeftSetVisual,autoRightSetVisual = nil,nil
speedLabel = nil
otherSpeedLabels = {}
setCarryModeVisual = nil
setLaggerModeVisual = nil
setLaggerCarryVisual = nil
autoBatEnabled = false
autoSwingEnabled = true
autoBatSetVisual = nil
resetAutoBatMotion = nil
toggleTpBat = nil
tpBatSetVisual = nil
State = {
	AutoBat=false,
	BatAimbot=false,
	BatV2=false,
	BatV2HittingCooldown=false
}
setBatCounterVisual = nil
startBatCounter, stopBatCounter = nil, nil
antiLagEnabled = false
removeAccessoriesEnabled = false
antiLagDescConn = nil
stretchRezEnabled = false
stretchRezConn = nil
setStretchRezVisual = nil
startAntiDie = nil
refreshBatMotionAntiDieGuard = nil
unwalkSavedAnimate = nil
_anyKeyListening = false
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
setAutoTPVisual = nil
autoTPDownEnabled = false
autoTPDownThreshold = 20
autoTPDownConn = nil
autoTPDownCooldownUntil = 0
autoTPDownSetVisual = nil
cursedResetRemote = nil
CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"

-- ============================================================
--  NINO TIME - Stun Timer (3-2-1 READY)
-- ============================================================
ninoTimeEnabled = false
ninoTimerGuiBB = nil
ninoTimerText = nil
ninoStunActive = false
ninoStunStartTime = 0
ninoStunDuration = 3.0
ninoStunConnection = nil
ninoStateChangedConnection = nil
ninoLastDisplayedSecond = nil
setNinoTimeVisual = nil

-- ============================================================
--  MÚSICA TRYHARD
-- ============================================================
tryhardMusicEnabled = false
tryhardMusicSound = nil
setTryhardMusicVisual = nil
TRYHARD_MUSIC_ID = "rbxassetid://135106901428553"

tryhard2MusicEnabled = false
tryhard2MusicSound = nil
setTryhard2MusicVisual = nil
TRYHARD2_MUSIC_ID = "rbxassetid://77142753938657"

tryhardDefMusicEnabled = false
tryhardDefMusicSound = nil
setTryhardDefMusicVisual = nil
TRYHARD_DEF_MUSIC_ID = "rbxassetid://75196377290071"

xdMusicEnabled = false
xdMusicSound = nil
setXdMusicVisual = nil
XD_MUSIC_ID = "rbxassetid://90813223538688"

music67Enabled = false
music67Sound = nil
setMusic67Visual = nil
MUSIC_67_ID = "rbxassetid://98859392001383"

music3amEnabled = false
music3amSound = nil
setMusic3amVisual = nil
MUSIC_3AM_ID = "rbxassetid://73755162651548"

berettaEnabled = false
berettaSound = nil
setBerettaVisual = nil
BERETTA_ID = "rbxassetid://94281718874647"

brasilEnabled = false
brasilSound = nil
setBrasilVisual = nil
BRASIL_ID = "rbxassetid://91225667489242"

brasil2Enabled = false
brasil2Sound = nil
setBrasil2Visual = nil
BRASIL2_ID = "rbxassetid://135750430892149"

function startTryhardMusic()
	if tryhardMusicSound then pcall(function() tryhardMusicSound:Stop();tryhardMusicSound:Destroy() end);tryhardMusicSound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=TRYHARD_MUSIC_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsTryhardMusic"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	tryhardMusicSound=snd
end

function stopTryhardMusic()
	if tryhardMusicSound then
		pcall(function() tryhardMusicSound:Stop();tryhardMusicSound:Destroy() end)
		tryhardMusicSound=nil
	end
end

function setTryhardMusic(on)
	tryhardMusicEnabled=on
	if setTryhardMusicVisual then setTryhardMusicVisual(on) end
	if on then startTryhardMusic() else stopTryhardMusic() end
end

function startTryhard2Music()
	if tryhard2MusicSound then pcall(function() tryhard2MusicSound:Stop();tryhard2MusicSound:Destroy() end);tryhard2MusicSound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=TRYHARD2_MUSIC_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsTryhard2Music"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	tryhard2MusicSound=snd
end

function stopTryhard2Music()
	if tryhard2MusicSound then
		pcall(function() tryhard2MusicSound:Stop();tryhard2MusicSound:Destroy() end)
		tryhard2MusicSound=nil
	end
end

function setTryhard2Music(on)
	tryhard2MusicEnabled=on
	if setTryhard2MusicVisual then setTryhard2MusicVisual(on) end
	if on then startTryhard2Music() else stopTryhard2Music() end
end

function startTryhardDefMusic()
	if tryhardDefMusicSound then pcall(function() tryhardDefMusicSound:Stop();tryhardDefMusicSound:Destroy() end);tryhardDefMusicSound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=TRYHARD_DEF_MUSIC_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsTryhardDefMusic"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	tryhardDefMusicSound=snd
end

function stopTryhardDefMusic()
	if tryhardDefMusicSound then
		pcall(function() tryhardDefMusicSound:Stop();tryhardDefMusicSound:Destroy() end)
		tryhardDefMusicSound=nil
	end
end

function setTryhardDefMusic(on)
	tryhardDefMusicEnabled=on
	if setTryhardDefMusicVisual then setTryhardDefMusicVisual(on) end
	if on then startTryhardDefMusic() else stopTryhardDefMusic() end
end

function startXdMusic()
	if xdMusicSound then pcall(function() xdMusicSound:Stop();xdMusicSound:Destroy() end);xdMusicSound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=XD_MUSIC_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsXdMusic"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	xdMusicSound=snd
end

function stopXdMusic()
	if xdMusicSound then
		pcall(function() xdMusicSound:Stop();xdMusicSound:Destroy() end)
		xdMusicSound=nil
	end
end

function setXdMusic(on)
	xdMusicEnabled=on
	if setXdMusicVisual then setXdMusicVisual(on) end
	if on then startXdMusic() else stopXdMusic() end
end

function startMusic67()
	if music67Sound then pcall(function() music67Sound:Stop();music67Sound:Destroy() end);music67Sound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=MUSIC_67_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsMusic67"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	music67Sound=snd
end

function stopMusic67()
	if music67Sound then
		pcall(function() music67Sound:Stop();music67Sound:Destroy() end)
		music67Sound=nil
	end
end

function setMusic67(on)
	music67Enabled=on
	if setMusic67Visual then setMusic67Visual(on) end
	if on then startMusic67() else stopMusic67() end
end

function startMusic3am()
	if music3amSound then pcall(function() music3amSound:Stop();music3amSound:Destroy() end);music3amSound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=MUSIC_3AM_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsMusic3am"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	music3amSound=snd
end

function stopMusic3am()
	if music3amSound then
		pcall(function() music3amSound:Stop();music3amSound:Destroy() end)
		music3amSound=nil
	end
end

function setMusic3am(on)
	music3amEnabled=on
	if setMusic3amVisual then setMusic3amVisual(on) end
	if on then startMusic3am() else stopMusic3am() end
end

function startBeretta()
	if berettaSound then pcall(function() berettaSound:Stop();berettaSound:Destroy() end);berettaSound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=BERETTA_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsBerettaMusic"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	berettaSound=snd
end

function stopBeretta()
	if berettaSound then
		pcall(function() berettaSound:Stop();berettaSound:Destroy() end)
		berettaSound=nil
	end
end

function setBeretta(on)
	berettaEnabled=on
	if setBerettaVisual then setBerettaVisual(on) end
	if on then startBeretta() else stopBeretta() end
end

function startBrasil()
	if brasilSound then pcall(function() brasilSound:Stop();brasilSound:Destroy() end);brasilSound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=BRASIL_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsBrasilMusic"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	brasilSound=snd
end

function stopBrasil()
	if brasilSound then
		pcall(function() brasilSound:Stop();brasilSound:Destroy() end)
		brasilSound=nil
	end
end

function setBrasil(on)
	brasilEnabled=on
	if setBrasilVisual then setBrasilVisual(on) end
	if on then startBrasil() else stopBrasil() end
end

function startBrasil2()
	if brasil2Sound then pcall(function() brasil2Sound:Stop();brasil2Sound:Destroy() end);brasil2Sound=nil end
	local snd=Instance.new("Sound")
	snd.SoundId=BRASIL2_ID
	snd.Volume=0.7
	snd.Looped=true
	snd.Name="blessvsBrasil2Music"
	snd.Parent=SoundService
	pcall(function() snd:Play() end)
	brasil2Sound=snd
end

function stopBrasil2()
	if brasil2Sound then
		pcall(function() brasil2Sound:Stop();brasil2Sound:Destroy() end)
		brasil2Sound=nil
	end
end

function setBrasil2(on)
	brasil2Enabled=on
	if setBrasil2Visual then setBrasil2Visual(on) end
	if on then startBrasil2() else stopBrasil2() end
end

-- ============================================================
--  FEATURE BACKEND
-- ============================================================
task.spawn(function()
	local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
	pcall(function() HS.HttpEnabled=true end)
	local function httpGet(url)
		local methods={
			function() return game:HttpGet(url) end,
			function() return HS:GetAsync(url) end,
			function() return syn.request({Url=url,Method="GET"}).Body end,
			function() return http_request({Url=url,Method="GET"}).Body end,
			function() return request({Url=url,Method="GET"}).Body end
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
function cursedInstaReset()
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
			pcall(function() cursedReset