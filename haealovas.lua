-- Shared channel view used by BOTH Hub and Extras, regardless of execution order.
local function HaramChannels()
    local env = type(getgenv) == "function" and getgenv() or _G
    local bridge = env.HaramDataBridge or _G.HaramDataBridge
    if not bridge or bridge.game ~= game or bridge.workspace ~= workspace then return nil end
    local view = bridge.channels
    if not view then view = {}; bridge.channels = view end
    for name, data in pairs(bridge.plots) do
        local key = tostring(name)
        if type(data) == "table" then
            local channel = view[key]
            if not channel then
                channel = {Index=key}
                function channel:Get(field) return self.CacheTable[field] end
                view[key] = channel
            end
            channel.CacheTable = data
        end
    end
    for name in pairs(view) do
        if type(bridge.plots[name]) ~= "table" then view[name] = nil end
    end
    _G.HaramSyncDiag = "loader live channels"
    return view
end
-- Match the loader's live service references; keep references stable across loading.
local function HaramService(name)
    local env = type(getgenv) == "function" and getgenv() or _G
    local runtime = env.HaramRuntime or _G.HaramRuntime
    if runtime and runtime.game == game and runtime.workspace == workspace then
        return runtime.Service(name)
    end
    return game:FindFirstChildOfClass(name) or game:GetService(name)
end
-- HARAM HUB v1: runway auto-buy + brainrot follow. Starts OFF. 🥀
-- Keep one Extras instance per Roblox session.  A second instance duplicates
-- keybinds/follow loops and can start another teleport while the first is busy.
if _G.HaramHubHazHub and _G.HaramHubLoadedGame == game and _G.HaramHubLoadedWorkspace == workspace then
	return
end
_G.HaramHubLoadedGame, _G.HaramHubLoadedWorkspace = game, workspace
_G.HaramHubHazHub = true

-- HARAM HUB background asset
do
	local bgUrl = "https://files.catbox.moe/srktpy.png"
	local bgPath = "HaramHubBG.png"
	local ok, err = pcall(function()
		if not isfile or not writefile or not getcustomasset then return end
		if not isfile(bgPath) then
			local data = game:HttpGet(bgUrl)
			writefile(bgPath, data)
		end
		_G.HaramHubBGAsset = getcustomasset(bgPath)
	end)
	if not ok then
		warn("[HARAM HUB] bg download failed:", err)
		_G.HaramHubBGAsset = nil
	end
end

task.wait(0)
-- LocalPlayer MUST exist before anything below touches it.
-- Without this, every early LocalPlayer.Character / LocalPlayer:... errors
-- ("index nil 'Character'" / "call nil") since the file captures/uses it at load.
do
	local _p = HaramService("Players")
	local _w = os.clock()
	while not _p.LocalPlayer and os.clock() - _w < 30 do
		task.wait()
	end
	if _p.LocalPlayer and LocalPlayer == nil then
		LocalPlayer = _p.LocalPlayer -- global fallback for legacy bare references
	end
end
_G.HaramBootT0 = _G.HaramBootT0 or (typeof(tick) == "function" and tick() or os.clock())
task.wait()
task.spawn(function()
	local speedFrame, speedLabel
	while true do
		task.wait(0.1)
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			if speedFrame then
				pcall(function()
					speedFrame.Visible = false
				end)
			end
			continue
		end
		if not speedFrame then
			local sg = Instance.new("ScreenGui")
			sg.Name = "HaramHubSpeedDisplay"
			sg.ResetOnSpawn = false
			sg.IgnoreGuiInset = true
			sg.DisplayOrder = 9999
			sg:SetAttribute("TwilightFastLoadMenu", true)
				sg.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
			speedFrame = Instance.new("Frame", sg)
			speedFrame.Size = UDim2.new(0, 140, 0, 24)
			speedFrame.Position = UDim2.new(1, -150, 1, -34)
			speedFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			speedFrame.BackgroundTransparency = 0.4
			speedFrame.BorderSizePixel = 0
			speedLabel = Instance.new("TextLabel", speedFrame)
			speedLabel.Size = UDim2.new(1, -8, 1, 0)
			speedLabel.Position = UDim2.new(0, 4, 0, 0)
			speedLabel.BackgroundTransparency = 1
			speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			speedLabel.Font = Enum.Font.GothamMedium
			speedLabel.TextSize = 13
			speedLabel.TextXAlignment = Enum.TextXAlignment.Left
		end
		speedFrame.Visible = true
		local spd = hrp.Velocity.Magnitude
		speedLabel.Text = string.format("%.0f studs/s", spd)
	end
end)

-- =====================================================================
-- EARLY BOOT -- runs DURING the loading screen, before game.Loaded.
-- ---------------------------------------------------------------------
-- The hub proper gates on game.Loaded below, but this thread overlaps the
-- loading screen with the expensive prep the TP needs: the first require() of
-- Synchronizer/Animals/etc. is the slowest part of the first pet scan, and
-- those replicate WHILE loading, so warm them now (WaitForChild yields until
-- each streams in). TP-on-load then fires without paying that cost.
--
-- NOTE: do NOT add a void-fall guard that anchors the HRP until game.Loaded.
-- game.Loaded fires ONCE, so if loading finished during the character wait its
-- :Wait() hangs forever and leaves the character permanently anchored -- the
-- grapple fires but you never move. The second thread here is the cleanup for
-- exactly that state, so re-executing always frees the character.
-- =====================================================================
do
	task.spawn(function()
		pcall(function()
			local RS = HaramService("ReplicatedStorage")
			local Packages = RS:WaitForChild("Packages", 120)
			require(Packages:WaitForChild("Synchronizer", 120))
			Packages:WaitForChild("Net", 60)
			local Datas = RS:WaitForChild("Datas", 60)
			require(Datas:WaitForChild("Animals", 60))
			local Shared = RS:WaitForChild("Shared", 60)
			require(Shared:WaitForChild("Animals", 60))
			local Utils = RS:WaitForChild("Utils", 30)
			require(Utils:WaitForChild("NumberUtils", 30))
		end)
	end)
end

if not game:IsLoaded() then
	game.Loaded:Wait()
end
_G.HaramLoadedSecs = (typeof(tick) == "function" and tick() or os.clock())
	- (_G.HaramBootT0 or (typeof(tick) == "function" and tick() or os.clock()))

local __RS = HaramService("RunService")
function _adaptWait(state, costMs)
	local target = (costMs * 10) / 1000
	if target > 0.05 then
		target = 0.05
	end
	state.d = (state.d or 0) * 0.7 + target * 0.3
	if state.d < 0.004 then
		__RS.Heartbeat:Wait()
	else
		task.wait(state.d)
	end
end
_G._HaramReady = false
_G._HaramScanFrozenUntil = 0
function _scansFrozen()
	return os.clock() < (_G._HaramScanFrozenUntil or 0)
end

local Players = HaramService("Players")
local RunService = HaramService("RunService")
local UserInputService = HaramService("UserInputService")
local ReplicatedStorage = HaramService("ReplicatedStorage")
local TweenService = HaramService("TweenService")
local HttpService = HaramService("HttpService")
local Workspace = HaramService("Workspace")
local VirtualInputManager = HaramService("VirtualInputManager")
local GuiService = HaramService("GuiService")
local LocalPlayer = Players.LocalPlayer
do
	local _wL = os.clock()
	while not LocalPlayer and os.clock() - _wL < 5 do
		task.wait()
		LocalPlayer = Players.LocalPlayer
	end
end

do
	local _GuiService = cloneref and cloneref(HaramService("GuiService")) or HaramService("GuiService")
	task.spawn(function()
		while true do
			pcall(function()
				_GuiService:ClearError()
			end)
			task.wait(0.1)
		end
	end)
end

local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)

do
	_G.__wsClearBoost = function() end
	_G.__wsApplyBoost = function() end
end

do
	local RESET_MAX_DURATION = 0.05
	local resetCooldown = false
	local resetThread = nil
	local currentCharacter = nil
	local resetSuccessful = false
	local stopResetSequence = false
	local cameraLocked = false
	local lockedCameraCFrame = nil
	local function StopResetSequence()
		stopResetSequence = true
		if resetThread then
			task.cancel(resetThread)
			resetThread = nil
		end
		resetCooldown = false
		currentCharacter = nil
		cameraLocked = false
		local character = LocalPlayer.Character
		if character then
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				pcall(function()
					humanoid.HipHeight = 2
					local rootPart = character:FindFirstChild("HumanoidRootPart")
					if rootPart then
						rootPart.CanCollide = true
					end
					for _, part in ipairs(character:GetChildren()) do
						if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
							part.CanCollide = true
						end
					end
				end)
			end
		end
	end
	local function instantReset()
		if resetCooldown then
			return
		end
		if _G.HaramSetInvisManual then
			pcall(_G.HaramSetInvisManual, false)
		end
		resetCooldown = true
		resetSuccessful = false
		stopResetSequence = false
		cameraLocked = false
		_G.AntiDieDisabled = true
		_G.Haram_IsResetting = true
		if _G.HaramPrepareMovementReset then
			pcall(_G.HaramPrepareMovementReset)
		end
		_G.HaramTPStop = true
		_G.haramTPStop = true
		pcall(function()
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:UnequipTools()
			end
			if char then
				local bp = LocalPlayer:FindFirstChild("Backpack")
				for _, t in ipairs(char:GetChildren()) do
					if t:IsA("Tool") then
						if bp then
							t.Parent = bp
						else
							t:Destroy()
						end
					end
				end
			end
		end)
		local character = LocalPlayer.Character
		if not character then
			_G.AntiDieDisabled = false
			_G.Haram_IsResetting = false
			resetCooldown = false
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			_G.AntiDieDisabled = false
			_G.Haram_IsResetting = false
			resetCooldown = false
			return
		end
		pcall(function()
			humanoid.BreakJointsOnDeath = true
			humanoid.RequiresNeck = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
		end)
		local camera = workspace.CurrentCamera
		if camera then
			lockedCameraCFrame = camera.CFrame
			cameraLocked = true
			camera.CFrame = lockedCameraCFrame
		end
		currentCharacter = character
		resetThread = task.spawn(function()
			local attempts = 0
			local maxAttempts = 40
			local originalHipHeight = humanoid.HipHeight
			while character and character.Parent and humanoid and humanoid.Health > 0 and not stopResetSequence do
				if LocalPlayer.Character ~= character then
					break
				end
				pcall(function()
					humanoid.HipHeight = 1e30
					humanoid.AutoRotate = true
					local rootPart = character:FindFirstChild("HumanoidRootPart")
					if rootPart then
						rootPart.CanCollide = false
					end
					for _, part in ipairs(character:GetChildren()) do
						if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
							part.CanCollide = false
						end
					end
				end)
				if
					not character
					or not character.Parent
					or not humanoid
					or humanoid.Health <= 0
					or LocalPlayer.Character ~= character
				then
					resetSuccessful = true
					break
				end
				attempts += 1
				if attempts >= maxAttempts then
					break
				end
				task.wait(RESET_MAX_DURATION)
			end
			if not resetSuccessful then
				if character and character.Parent and humanoid and humanoid.Health > 0 then
					pcall(function()
						humanoid.Health = 0
					end)
					task.wait(0.1)
					if not character.Parent or humanoid.Health <= 0 then
						resetSuccessful = true
					end
				end
			end
			if not resetSuccessful and character and character.Parent and humanoid then
				pcall(function()
					humanoid.HipHeight = originalHipHeight
					local rootPart = character:FindFirstChild("HumanoidRootPart")
					if rootPart then
						rootPart.CanCollide = true
					end
					for _, part in ipairs(character:GetChildren()) do
						if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
							part.CanCollide = true
						end
					end
				end)
			end
			cameraLocked = false
			resetCooldown = false
			resetThread = nil
			currentCharacter = nil
			stopResetSequence = false
			_G.Haram_IsResetting = false
			task.delay(2, function()
				if LocalPlayer.Character ~= character then
					_G.AntiDieDisabled = false
				end
			end)
		end)
	end
	_G.Haram_InstantReset = function()
		if type(_G.HaramInstantReset) == "function" then
			return _G.HaramInstantReset()
		end
		return instantReset()
	end
	_G.FrameResetLite = { Reset = instantReset, Stop = StopResetSequence }
	LocalPlayer.CharacterAdded:Connect(function()
		StopResetSequence()
		_G.AntiDieDisabled = false
		_G.Haram_IsResetting = false
	end)
	task.spawn(function()
		local camera = workspace.CurrentCamera
		while true do
			task.wait(0.016)
			if cameraLocked and lockedCameraCFrame and camera then
				pcall(function()
					camera.CFrame = lockedCameraCFrame
				end)
			end
		end
	end)
end

local FileName = "haram_hub.config.json"
local DefaultConfig = {
	UILocked = false,
	MenuKey = "RightControl",
	ConfigKey = "LeftControl",
	TeleportKey = "T",
	CarpetSpeedKey = "Q",
	CarpetTool = "Flying Carpet",
	CarpetSpeed = 180,
	InstantResetKey = "R",
	InstantCloneKey = "V",
	InfiniteJump = false,
	AntiRagdoll = true,
	XrayEnabled = false,
	ESPPlayerEnabled = false,
	ESPBaseOwnerEnabled = false,
	CarpetSpeedEnabled = false,
	AutoKickEnabled = false,
	ShowRoadBrainrots = false,
	AutoKickGuiX = false,
	AutoKickGuiY = false,
	AutoBuyEnabled = false,
	AutoBuyKey = "K",
	AutoBuyRange = 17,
	AntiFlashEnabled = false,
	AntiFlashKey = "NONE",
	KickKey = "NONE",
	InvisStealKey = "NONE",
	FlashTeleportKey = "NONE",
	BestTeleportKey = "NONE",
	StopTeleportKey = "NONE",
	FloatKey = "B",
	FloatSpeed = 40,
	NextTargetKey = "Y",
	DropBrainrotKey = "NONE",
	PlaceboScreenEnabled = true,
	PlaceboScreenSeconds = 2.5,
	FOV = 120,
	PrivateServerLink = "",
	StealMode = "Priority",
	StealHighest = false,
	StealPriority = true,
	StealNearest = false,
	AutoStealEnabled = true,
	AutoTPPriority = true,
	AutoTPFloor2FromFloor1 = false,
	AutoTPOnSteal = true,
	InstantStealEnabled = true,
	AutoGrabRadius = 95,
	AutoGrabCommitRange = 10,
	AutoGrabEntryDelay = 0.30,
	AutoGrabHoldMaxTotal = 20,
	AutoGrabUseFPP = true,
	InvisStealAngle = 180,
	SinkSliderValue = 7,
	AutoRecoverLagback = true,
	AutoInvisDuringSteal = false,
	InvisDelayEnabled = true,
	InvisDelayMs = 1000,
	AvoidPlayersInvis = false,
	AvoidPlayersInvisRange = 20,
	AvoidPlayersInvisSpeed = 20,
	PriorityList = nil,
	StealTargetUID = nil,
	PriorityAlertEnabled = true,
	AlertSoundID = "",
	HaramPositions = {},
	Visibilities = { ["TP Settings"] = false, ["Priority List"] = false },
	TpSettings = {
		GrabbleTPSpeed = 450,
		WalkTPSpeed = 280,
		CloneDelayVal = 0.01,
		TpOnLoad = true,
		Tool = "Flying Carpet",
		BrainrotCarpet = false,
		NearbyTPSpeed = 350,
		NearbyTPRange = 100,
		NearbyCloneDelay = 0.01,
		NearbyCloneRange = 100,
		PostCloneWait = 0.1,
		PlatformF2Y = 13.5,
		PlatformF3Y = 15.5,
		TpDelay = 0,
		SideEntryN = 25,
		ShowTPPath = true,
		LightRoute = true,
		RiseSpeed = 95,
		PathHeight = 20,
		PathMinDist = 100,
	},
	Positions = { Main = { X = 0.72, Y = 0.3 } },
}
local function deepMerge(dst, src)
	for k, v in pairs(src) do
		if type(v) == "table" and type(dst[k]) == "table" then
			deepMerge(dst[k], v)
		else
			dst[k] = v
		end
	end
end
local Config = {}
deepMerge(Config, DefaultConfig)
local readConfigFile = FileName
if isfile and not isfile(FileName) and isfile("haram_hub.json") then
	readConfigFile = "haram_hub.json"
end
if isfile and isfile(readConfigFile) then
	pcall(function()
		local ok, d = pcall(function()
			return HttpService:JSONDecode(readfile(readConfigFile))
		end)
		if ok and type(d) == "table" then
			deepMerge(Config, d)
		end
	end)
end

-- Migrate the old, overly fast Carpet Speed value.
-- Carpet Speed flies at a fixed 120 (same mover as the TP, see the hub's
-- HaramCarpetSpeedStep).
Config.CarpetSpeed = 120

_G.GoonUseV2TP = Config.GoonUseV2TP == true
if Config.AutoInvisDuringSteal == nil then
	Config.AutoInvisDuringSteal = true
end
Config.InvisDelayEnabled = true
Config.InvisDelayMs = 1000
Config.RunwayBuyMode = "nearest"
Config.AntiFlashEnabled = false
Config.GoonUnwalkEnabled = false
Config.XrayEnabled = false
Config.CarpetSpeedEnabled = false
Config.MenuKey = "NONE"
Config.FloatKey = "NONE"
Config.FlashTeleportKey = "NONE"
Config.BestTeleportKey = "NONE"
Config.StopTeleportKey = "NONE"
_G.GoonUnwalkEnabled = false
_G.AutoInvisDuringSteal = true
_G.JAF_InvisDelayEnabled = true
_G.JAF_InvisDelayMs = 1000

if not Config.__cfgKeySplit then
	Config.__cfgKeySplit = true
	if Config.MenuKey == "LeftControl" or not Config.MenuKey then
		Config.MenuKey = "RightControl"
	end
	if not Config.ConfigKey or Config.ConfigKey == "NONE" then
		Config.ConfigKey = "LeftControl"
	end
end

local function SaveConfig()
	Config.iPadMode, Config.iPadScale = nil, nil
	Config.WalkSpeedKey, Config.WalkSpeedValue = nil, nil
	Config.WalkSpeedOnSteal, Config.WalkSpeedEnabled = nil, nil
	if writefile then
		pcall(function()
			writefile(FileName, HttpService:JSONEncode(Config))
		end)
	end
end

-- Optimizer controls for the paired main hub v4.6.
local optimizerRequest = (Config.OptimizerMode == "default" or Config.OptimizerMode == "aa") and Config.OptimizerMode
	or nil
local function selectOptimizerMode(mode)
	if mode ~= "default" and mode ~= "aa" then
		return
	end
	Config.OptimizerMode = mode
	optimizerRequest = mode
	if type(_G.HaramSetOptimizerMode) == "function" then
		_G.HaramSetOptimizerMode(mode)
		optimizerRequest = nil
		if _G.HaramSaveSettings then
			pcall(_G.HaramSaveSettings)
		end
	end
	pcall(SaveConfig)
end
task.spawn(function()
	while _G.HaramHubLoadedGame == game do
		if optimizerRequest and type(_G.HaramSetOptimizerMode) == "function" then
			selectOptimizerMode(optimizerRequest)
		end
		task.wait(0.25)
	end
end)

-- Hide runway visuals without deleting the models/data required by AnimalClient.
do
	if _G.HaramRoadVisibilityController then
		_G.HaramRoadVisibilityController.Destroy()
	end
	local world = HaramService("Workspace")
	local connections = {}
	local saved = setmetatable({}, { __mode = "k" })
	local function roadVisual(object)
		local at = object
		while at and at ~= world do
			if at.Name == "RenderedMovingAnimals" then
				return true
			end
			at = at.Parent
		end
		return false
	end
	local function apply(object, visible)
		if object:IsA("BasePart") then
			-- Transparency belongs to the game (invisible roots must stay invisible).
			-- LocalTransparencyModifier hides only the visual rendering.
			object.LocalTransparencyModifier = visible and 0 or 1
		elseif object:IsA("BillboardGui") or object:IsA("SurfaceGui") then
			if saved[object] == nil then
				saved[object] = object.Enabled
			end
			object.Enabled = visible and saved[object] or false
		end
	end
	-- Road brainrots show only with ROAD BRAINROTS on AND the "aa" optimizer:
	-- in "default" the hub/loader conceal every animal model anyway.
	local function roadVisible()
		return Config.ShowRoadBrainrots == true and _G.HaramOptimizerMode ~= "default"
	end
	local appliedVisible = nil
	_G.HaramApplyRoadVisibility = function()
		local visible = roadVisible()
		appliedVisible = visible
		_G.HaramHideRoadBrainrots = not visible
		local folder = world:FindFirstChild("RenderedMovingAnimals")
		if folder then
			for _, object in ipairs(folder:GetDescendants()) do
				apply(object, visible)
			end
		end
		if _G.HaramSyncRoadVisibilityButton then
			_G.HaramSyncRoadVisibilityButton(Config.ShowRoadBrainrots == true)
		end
	end
	_G.HaramSetRoadBrainrotsVisible = function(visible)
		Config.ShowRoadBrainrots = visible == true
		_G.HaramApplyRoadVisibility()
		pcall(SaveConfig)
		-- The FPS pass decides at load whether road models are kept at all: if it
		-- deleted them this session, the game's road never recovers, so turning
		-- the toggle on can only take effect after a rejoin. Say so instead of
		-- leaving an empty road behind an "ON" button.
		if visible == true and _G.HaramRoadBrainrotsKept ~= true then
			pcall(function()
				HaramService("StarterGui"):SetCore("SendNotification", {
					Title = "Road Brainrots",
					Text = "Saved. Rejoin the server to see them.",
					Duration = 5,
				})
			end)
		end
	end
	connections[#connections + 1] = world.DescendantAdded:Connect(function(object)
		if roadVisual(object) then
			apply(object, roadVisible())
		end
	end)
	-- Re-apply when the optimizer mode changes (and keep newly streamed models
	-- in the right state even if the hub's own passes touched them).
	task.spawn(function()
		while _G.HaramHubLoadedGame == game and _G.HaramApplyRoadVisibility do
			task.wait(0.25)
			if roadVisible() ~= appliedVisible then
				pcall(_G.HaramApplyRoadVisibility)
			end
		end
	end)
	_G.HaramRoadVisibilityController = {
		Destroy = function()
			_G.HaramApplyRoadVisibility = nil
			for _, connection in ipairs(connections) do
				connection:Disconnect()
			end
			local folder = world:FindFirstChild("RenderedMovingAnimals")
			if folder then
				for _, object in ipairs(folder:GetDescendants()) do
					apply(object, true)
				end
			end
		end,
	}
	_G.HaramApplyRoadVisibility()
end

-- Remove keys left by the retired laser griefer/range-ring implementation.
Config.LineToStealerEnabled = nil
Config.LaserMaxDistance = nil
task.defer(SaveConfig)
local player = LocalPlayer
local UIS = UserInputService
local panels = {}
local Theme = {
	Background = Color3.fromRGB(8, 5, 12),
	MainBackground = Color3.fromRGB(6, 3, 10),
	Panel = Color3.fromRGB(16, 10, 22),
	Row = Color3.fromRGB(35, 35, 35),
	RowHover = Color3.fromRGB(50, 50, 50),
	Accent = Color3.fromRGB(255, 255, 255),
	AccentLight = Color3.fromRGB(240, 240, 240),
	Green = Color3.fromRGB(211, 211, 211),
	Red = Color3.fromRGB(117, 117, 117),
	Text = Color3.fromRGB(240, 240, 240),
	Dim = Color3.fromRGB(140, 140, 140),
	Stroke = Color3.fromRGB(60, 60, 60),
	SoftButton = Color3.fromRGB(30, 30, 30),
	SoftButtonHover = Color3.fromRGB(50, 50, 50),
	SoftAccent = Color3.fromRGB(25, 25, 25),
	SoftAccentHover = Color3.fromRGB(40, 40, 40),
	ToggleOff = Color3.fromRGB(40, 40, 40),
	ToggleOff2 = Color3.fromRGB(40, 40, 40),
	InputBg = Color3.fromRGB(15, 15, 15),
	SliderBg = Color3.fromRGB(45, 45, 45),
	Surface = Color3.fromRGB(22, 22, 22),
	SurfaceHighlight = Color3.fromRGB(38, 38, 38),
	Accent1 = Color3.fromRGB(255, 255, 255),
	Accent2 = Color3.fromRGB(220, 220, 220),
	TextPrimary = Color3.fromRGB(240, 240, 240),
	TextSecondary = Color3.fromRGB(140, 140, 140),
	Success = Color3.fromRGB(211, 211, 211),
	Error = Color3.fromRGB(117, 117, 117),
}

_G._HaramSliderDragging = false

local function savePanelPosition(name, frame)
	if not name then
		return
	end
	Config.HaramPositions = Config.HaramPositions or {}
	local p = frame.Position
	Config.HaramPositions[name] = { version = 2, xs = p.X.Scale, xo = p.X.Offset, ys = p.Y.Scale, yo = p.Y.Offset }
	SaveConfig()
end
local function MakeDraggable(handle, target, saveKey)
	local dragging, origin, startPosition, touch, oldBehavior
	local function point(input)
		if touch then
			return Vector2.new(input.Position.X, input.Position.Y)
		end
		return UIS:GetMouseLocation()
	end
	local function scale()
		local n, at = 1, target.Parent
		while at and not at:IsA("ScreenGui") do
			for _, child in ipairs(at:GetChildren()) do
				if child:IsA("UIScale") then
					n *= child.Scale
				end
			end
			at = at.Parent
		end
		return math.max(n, 0.01)
	end
	local function finish()
		if not dragging then
			return
		end
		dragging = false
		if oldBehavior then
			UIS.MouseBehavior = oldBehavior
			oldBehavior = nil
		end
		savePanelPosition(saveKey, target)
	end
	handle.Active = true
	handle.InputBegan:Connect(function(input)
		if Config.UILocked or _G._HaramSliderDragging or dragging then
			return
		end
		if
			input.UserInputType ~= Enum.UserInputType.MouseButton1
			and input.UserInputType ~= Enum.UserInputType.Touch
		then
			return
		end
		touch = input.UserInputType == Enum.UserInputType.Touch and input or nil
		origin = point(input)
		startPosition = target.Position
		dragging = true
		if not touch then
			oldBehavior = UIS.MouseBehavior
			UIS.MouseBehavior = Enum.MouseBehavior.Default
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if Config.UILocked or not target.Parent then
			finish()
			return
		end
		if _G._HaramSliderDragging then
			return
		end
		if touch and input ~= touch then
			return
		end
		if not touch and input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end
		local delta = (point(input) - origin) / scale()
		target.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
	UIS.InputEnded:Connect(function(input)
		if touch and input == touch or not touch and input.UserInputType == Enum.UserInputType.MouseButton1 then
			finish()
		end
	end)
	UIS.WindowFocusReleased:Connect(finish)
end
local function MakeBottomDragHandle(target, saveKey)
	local handle = Instance.new("TextButton")
	handle.Name = "BottomDragHandle"
	handle.Size = UDim2.new(1, -24, 0, 18)
	handle.Position = UDim2.new(0, 12, 1, -20)
	handle.BackgroundTransparency = 0.35
	handle.BackgroundColor3 = Theme.SurfaceHighlight
	handle.BorderSizePixel = 0
	handle.Text = "•••"
	handle.TextColor3 = Theme.Dim
	handle.TextSize = 12
	handle.Font = Enum.Font.GothamBold
	handle.AutoButtonColor = false
	handle.Active = true
	handle.ZIndex = 50
	handle.Parent = target
	corner(handle, 6)
	MakeDraggable(handle, target, saveKey)
	return handle
end
local function rememberPosition(name, frame)
	savePanelPosition(name, frame)
end
local function applySavedPosition(name, frame)
	if not name or not frame then
		return
	end
	local d = Config.HaramPositions and Config.HaramPositions[name]
	if d then
		frame.Position = UDim2.new(d.xs or 0, d.xo or 0, d.ys or 0, d.yo or 0)
		return
	end
	local p = Config.Positions and Config.Positions[name]
	if p then
		local vp = workspace.CurrentCamera.ViewportSize
		frame.Position = UDim2.fromOffset(math.floor((p.X or 0) * vp.X), math.floor((p.Y or 0) * vp.Y))
	end
end
Config.StealMode = "Priority"
Config.StealHighest = false
Config.StealPriority = true
Config.StealNearest = false

if Config.AutoStealEnabled == nil then
	Config.AutoStealEnabled = true
end
-- Discard the retired option from older saved configurations.
Config.SkipStolenTarget = nil
_G.HaramSkipStolenTarget = nil
_G.HaramIsBeingStolen = nil
-- Migrate the old Extras-only radius to Rose's Auto Grab radius.
if Config.AutoGrabRadius == nil or Config.AutoGrabRadius == 60 then
	Config.AutoGrabRadius = 95
end
if Config.AntiRagdoll == nil then
	Config.AntiRagdoll = true
end
if Config.AutoTPOnSteal == nil then
	Config.AutoTPOnSteal = true
end
Config.TpSettings = Config.TpSettings or {}
Config.TpSettings.TpOnLoad = true
if not Config.Positions then
	Config.Positions = DefaultConfig.Positions
end
if not Config.Visibilities then
	Config.Visibilities = DefaultConfig.Visibilities
end
for _, n in ipairs({ "TP Settings", "Priority List" }) do
	if Config.Visibilities[n] == nil then
		Config.Visibilities[n] = DefaultConfig.Visibilities[n]
	end
end

do
	local setclip = (typeof(setclipboard) == "function" and setclipboard)
		or (typeof(toclipboard) == "function" and toclipboard)
		or (typeof(set_clipboard) == "function" and set_clipboard)
	local log = getgenv().__Haram_KickLog or {}
	getgenv().__Haram_KickLog = log
	local MAX = 40
	local function push(line)
		log[#log + 1] = string.format("[%.2f] %s", os.clock(), tostring(line))
		while #log > MAX do
			table.remove(log, 1)
		end
		_G.__Haram_LastAction = line
	end
	_G.Haram_Trace = push
	local function dump(reason)
		local body = "KICK/REMOOVE reason="
			.. tostring(reason)
			.. "\nLAST="
			.. tostring(_G.__Haram_LastAction)
			.. "\n----\n"
			.. table.concat(log, "\n")
		print("[Haram_KICKTRACE]\n" .. body)
		if setclip then
			pcall(setclip, body)
		end
	end
	_G.Haram_DumpKickTrace = dump
	pcall(function()
		LocalPlayer.AncestryChanged:Connect(function(_, parent)
			if parent == nil then
				dump("AncestryChanged(nil)")
			end
		end)
	end)
end

local _xchan
local _class
local _lastSweep = 0
local _dirty = true
local SWEEP_GAP = 0.5

local function _classTable()
	if _class then
		return _class
	end
    local packages = HaramService("ReplicatedStorage"):FindFirstChild("Packages")
    local sync = packages and packages:FindFirstChild("Synchronizer")
    local channel = sync and sync:FindFirstChild("Channel")
    if not channel or not channel:IsA("ModuleScript") then return nil end
    local ok, c = pcall(require, channel)
	if ok and type(c) == "table" then
		_class = c
	end
	return _class
end

local function _sweep()
	local cls = _classTable()
	if not cls or type(getgc) ~= "function" then
		_G.HaramSyncDiag = cls and "getgc unavailable" or "Channel class not found"
		return
	end
	_lastSweep = os.clock()
	_dirty = false
	local reg, n = {}, 0
	local gc = getgc(true)
	for i = 1, #gc do
		local v = gc[i]
		if type(v) == "table" and getmetatable(v) == cls then
			local idx = rawget(v, "Index")
			if idx ~= nil then
				reg[idx] = v
				n = n + 1
			end
		end
	end
	_xchan = reg
	_G.HaramSyncDiag = string.format("heap identity - %d channels", n)
end

local function _needsSweep()
	if not _xchan then
		return true
	end
	if _dirty then
		return true
	end
	local pl = workspace:FindFirstChild("Plots")
	if pl then
		for _, p in ipairs(pl:GetChildren()) do
			if _xchan[p.Name] == nil then
				return true
			end
		end
	end
	return false
end

do
	local pl = workspace:FindFirstChild("Plots")
	if pl then
		pl.ChildAdded:Connect(function()
			_dirty = true
		end)
		pl.ChildRemoved:Connect(function()
			_dirty = true
		end)
	end
end

local function _chans()
    local live = HaramChannels()
    if live then return live end
	if _needsSweep() and (os.clock() - _lastSweep) > SWEEP_GAP then
		_sweep()
	end
	return _xchan
end

_G.HaramSyncAll = function()
	return _chans()
end
_G.HaramSyncGet = function(idx)
	local t = _chans()
	if not t or idx == nil then
		return nil
	end
	local ok, cd = pcall(rawget, t, idx)
	if ok and type(cd) == "table" then
		return cd
	end
	local ok2, cd2 = pcall(function()
		return t[idx]
	end)
	if ok2 and type(cd2) == "table" then
		return cd2
	end
	return nil
end
_G._elysiumRawCT = function(plotName)
	local c = _G.HaramSyncGet(plotName)
	if not c then
		return nil
	end
	return rawget(c, "CacheTable")
end
_G.sProp = function(ch, key)
	if type(ch) ~= "table" or key == nil then
		return nil
	end
	local ct = rawget(ch, "CacheTable")
	if type(ct) ~= "table" then
		local okC, c2 = pcall(function()
			return ch.CacheTable
		end)
		if okC and type(c2) == "table" then
			ct = c2
		end
	end
	if type(ct) ~= "table" then
		return nil
	end
	local v = rawget(ct, key)
	if v ~= nil then
		return v
	end
	local okV, v2 = pcall(function()
		return ct[key]
	end)
	if okV then
		return v2
	end
	return nil
end
local _AD, _MD, _TD
local function _data()
	if _AD then
		return true
	end
	local ok = pcall(function()
		local d = HaramService("ReplicatedStorage"):WaitForChild("Datas")
		_AD = require(d:WaitForChild("Animals"))
		_MD = require(d:WaitForChild("Mutations"))
		_TD = require(d:WaitForChild("Traits"))
	end)
	return ok and _AD ~= nil
end
_G._elysiumGen = function(index, mutation, traits)
	if not _data() then
		return 0
	end
	local info = _AD[index]
	if not info or not info.Generation then
		return 0
	end
	local mult = 1
	if mutation and mutation ~= "None" and mutation ~= "" then
		local m = _MD[mutation]
		if m and m.Modifier then
			mult = mult + m.Modifier
		end
	end
	if type(traits) == "table" then
		for _, tr in ipairs(traits) do
			local t = _TD[tr]
			if t and t.MultiplierModifier then
				mult = mult + t.MultiplierModifier
			end
		end
	end
	return info.Generation * mult
end
_G._elysiumAnimShim = setmetatable({
	GetGeneration = function(_, index, mutation, traits)
		return _G._elysiumGen(index, mutation, traits)
	end,
}, {
	__index = function(_, k)
		local ok, real = pcall(function()
			return require(HaramService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Animals"))
		end)
		if ok and type(real) == "table" then
			return rawget(real, k)
		end
		return nil
	end,
})
_G.stealthGet = function(n)
	return _G.HaramSyncGet(n)
end
_G.SyncInt = { _cache = {}, _data = nil }

_G.Haram_ChannelGet = _G.sProp
_G.Haram_GetPlotChannel = function(name)
	return _G.HaramSyncGet(tostring(name))
end
_G.Haram_AllCachedChannels = function()
	return _G.HaramSyncAll() or {}
end
_G.Haram_SynStatus = function()
	local t = _G.HaramSyncAll()
	local n = 0
	if type(t) == "table" then
		for _ in pairs(t) do
			n = n + 1
		end
	end
	return { hookedReq = true, hookedGet = (_xchan ~= nil), channels = n }
end

task.spawn(function()
	local plots
	local t0 = os.clock()
	repeat
		plots = Workspace:FindFirstChild("Plots")
		if not plots then
			task.wait(0.05)
		end
	until plots or (os.clock() - t0) > 25
	if not plots then
		return
	end
	local done, warmT0 = {}, os.clock()
	while (os.clock() - warmT0) < 15 do
		local kids = plots:GetChildren()
		local pending = false
		for _, plot in ipairs(kids) do
			if not done[plot.Name] then
				local ch = _G.HaramSyncGet and _G.HaramSyncGet(plot.Name)
				if ch then
					pcall(function()
						if ch.Get then
							ch:Get("AnimalList")
							ch:Get("Owner")
						end
					end)
					local al = _G.sProp and _G.sProp(ch, "AnimalList")
					if al ~= nil then
						done[plot.Name] = true
					else
						pending = true
					end
				else
					pending = true
				end
			end
		end
		if not pending and #kids > 0 then
			break
		end
		task.wait(0.05)
	end
end)

task.spawn(function()
	if not Workspace.StreamingEnabled then
		return
	end
	local plots
	local t0 = os.clock()
	repeat
		plots = Workspace:FindFirstChild("Plots")
		if not plots then
			task.wait(0.1)
		end
	until plots or (os.clock() - t0) > 25
	if not plots then
		return
	end
	local function plotPos(plot)
		local ok, pv = pcall(function()
			return plot:GetPivot().Position
		end)
		if ok and pv and pv.Magnitude > 1 then
			return pv
		end
		if plot.PrimaryPart then
			return plot.PrimaryPart.Position
		end
		local bp = plot:FindFirstChildWhichIsA("BasePart", true)
		return bp and bp.Position or nil
	end
	local pending = 0
	for _, plot in ipairs(plots:GetChildren()) do
		local pos = plotPos(plot)
		if pos then
			pending = pending + 1
			task.spawn(function()
				pcall(function()
					LocalPlayer:RequestStreamAroundAsync(pos)
				end)
				pending = pending - 1
			end)
		end
	end
	local sw = os.clock()
	while pending > 0 and os.clock() - sw < 10 do
		task.wait(0.05)
	end
end)

local oldHaram = PlayerGui:FindFirstChild("HaramHubPanels") or PlayerGui:FindFirstChild("HaramHubPanels")
if oldHaram then
	oldHaram:Destroy()
end
local gui_sg = Instance.new("ScreenGui")
gui_sg.Name = "HaramHubPanels"
gui_sg.ResetOnSpawn = false
gui_sg.IgnoreGuiInset = true
gui_sg.DisplayOrder = 100000000
gui_sg:SetAttribute("TwilightFastLoadMenu", true)
gui_sg.Parent = PlayerGui
local gui = Instance.new("Frame")
gui.Name = "DetachedPanelsRoot"
gui.BackgroundTransparency = 1
gui.Size = UDim2.new(1, 0, 1, 0)
gui.Parent = gui_sg


local GlobalUIScaleVal = 1.05
local function registerScreenGui(sg)
	local master = sg:FindFirstChild("HaramHub_MasterFrame")
	if not master then
		master = Instance.new("Frame")
		master.Name = "HaramHub_MasterFrame"
		master.BackgroundTransparency = 1
		master.BorderSizePixel = 0
		master.Parent = sg
		local scaleObj = Instance.new("UIScale")
		scaleObj.Name = "HaramHub_GlobalScale"
		scaleObj.Parent = master
	end
	pcall(function()
		local scaleObj = master:FindFirstChild("HaramHub_GlobalScale")
		if scaleObj then
			scaleObj.Scale = GlobalUIScaleVal
		end
		master.Size = UDim2.new(1 / GlobalUIScaleVal, 0, 1 / GlobalUIScaleVal, 0)
	end)
	return master
end
registerScreenGui(gui_sg)

local function makeOneWay(plat)
	if not plat then
		return
	end
	local rsConn
	local lastY = nil
	rsConn = HaramService("RunService").Stepped:Connect(function()
		if not plat or not plat.Parent then
			if rsConn then
				rsConn:Disconnect()
			end
			return
		end
		local char = game.Players.LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local currentY = hrp.Position.Y
			if not lastY then
				lastY = currentY
			end
			local deltaY = currentY - lastY
			local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
			if isMovingUp then
				plat.CanCollide = false
			else
				if currentY > plat.Position.Y + 0.1 then
					plat.CanCollide = true
				else
					plat.CanCollide = false
				end
			end
			lastY = currentY
		end
	end)
end
corner = function(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = o
	return c
end
tw = function(o, p, t)
	TweenService:Create(o, TweenInfo.new(t or 0.14, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p):Play()
end
addOutline = function(f)
	local o = Instance.new("UIStroke")
	o.Color = Color3.fromRGB(60, 60, 60)
	o.Thickness = 1
	o.Transparency = 0.3
	o.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	o.Parent = f
	return o
end
makeDraggable = function(frame, handle, saveName)
	MakeDraggable(handle, frame, saveName)
end
makeResizable = function(frame, minSize, panelName)
	local h = Instance.new("TextButton")
	h.Size = UDim2.new(0, 16, 0, 16)
	h.Position = UDim2.new(1, -16, 1, -16)
	h.BackgroundTransparency = 1
	h.Text = "+"
	h.TextColor3 = Theme.AccentLight or Color3.new(1, 1, 1)
	h.TextSize = 12
	h.ZIndex = 100
	h.Parent = frame
	local dragging, dragInput, dragStart, startSize = false, nil, nil, nil
	local function stopResize()
		if not dragging then
			return
		end
		dragging = false
		dragInput = nil
		if panelName then
			if not Config.sizes then
				Config.sizes = {}
			end
			Config.sizes[panelName] = { x = frame.Size.X.Offset, y = frame.Size.Y.Offset }
			SaveConfig()
		end
	end
	h.InputBegan:Connect(function(input)
		if Config.UILocked then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragging = true
			dragStart = input.Position
			startSize = frame.AbsoluteSize
			dragInput = input
			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					if conn then
						conn:Disconnect()
					end
					stopResize()
				end
			end)
		end
	end)
	h.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			stopResize()
		end
	end)
	h.InputChanged:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragInput = input
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			stopResize()
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if
			dragging
			and not Config.UILocked
			and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement)
		then
			local d = input.Position - dragStart
			local nx = math.max(minSize.X.Offset, startSize.X + d.X)
			local ny = math.max(minSize.Y.Offset, startSize.Y + d.Y)
			frame.Size = UDim2.new(0, nx, 0, ny)
		end
	end)
end
function makeHeader(f, t, isMain)
	local h = Instance.new("TextButton")
	h.Size = UDim2.new(1, 0, 0, 42)
	h.BackgroundTransparency = 1
	h.Text = ""
	h.AutoButtonColor = false
	h.Parent = f
	local parts = {}
	for s in string.gmatch(t, "([^\n]+)") do
		table.insert(parts, s)
	end
	if isMain then
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1, -50, 0, 24)
		l.Position = UDim2.new(0, 13, 0, 8)
		l.BackgroundTransparency = 1
		l.Text = parts[1] or "HARAM HUB"
		l.TextColor3 = Theme.Text
		l.Font = Enum.Font.GothamBlack
		l.TextSize = 16
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Active = false
		l.Parent = h
	else
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1, -58, 0, 16)
		l.Position = UDim2.new(0, 12, 0, 7)
		l.BackgroundTransparency = 1
		l.Text = parts[1] or "HARAM HUB"
		l.TextColor3 = Theme.Text
		l.Font = Enum.Font.GothamBlack
		l.TextSize = 12
		l.TextXAlignment = Enum.TextXAlignment.Center
		l.Active = false
		l.Parent = h
		local s = Instance.new("TextLabel")
		s.Size = UDim2.new(1, -58, 0, 13)
		s.Position = UDim2.new(0, 12, 0, 21)
		s.BackgroundTransparency = 1
		s.Text = parts[2] or ""
		s.TextColor3 = Theme.Dim
		s.Font = Enum.Font.GothamMedium
		s.TextSize = 10
		s.TextXAlignment = Enum.TextXAlignment.Center
		s.Active = false
		s.Parent = h
	end
	local d = Instance.new("Frame")
	d.Size = UDim2.new(1, -24, 0, 1)
	d.Position = UDim2.new(0, 12, 0, 40)
	d.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	d.BackgroundTransparency = isMain and 0.5 or 0.3
	d.BorderSizePixel = 0
	d.Parent = f

	local collapseBtn = Instance.new("TextButton")
	collapseBtn.Size = UDim2.new(0, 24, 0, 24)
	collapseBtn.Position = UDim2.new(1, -28, 0, 9)
	collapseBtn.BackgroundColor3 = Theme.SoftButton
	collapseBtn.BackgroundTransparency = 0.3
	collapseBtn.Text = "▼"
	collapseBtn.TextColor3 = Theme.AccentLight
	collapseBtn.Font = Enum.Font.GothamBold
	collapseBtn.TextSize = 10
	collapseBtn.AutoButtonColor = false
	collapseBtn.ZIndex = 60
	collapseBtn.Parent = h
	corner(collapseBtn, 5)
	local _panelCollapsed = false
	local _panelFullSize = f.Size
	collapseBtn.MouseButton1Click:Connect(function()
		_panelCollapsed = not _panelCollapsed
		if _panelCollapsed then
			_panelFullSize = f.Size
			for _, child in ipairs(f:GetChildren()) do
				pcall(function()
					if child ~= h then
						child.Visible = false
					end
				end)
			end
			f.Size = UDim2.new(_panelFullSize.X.Scale, _panelFullSize.X.Offset, 0, 42)
			collapseBtn.Text = "▶"
		else
			f.Size = _panelFullSize
			for _, child in ipairs(f:GetChildren()) do
				pcall(function()
					child.Visible = true
				end)
			end
			collapseBtn.Text = "▼"
		end
	end)
	makeDraggable(f, h, t)
	return h
end
function makeQuickPanel(t, size, pos, saveKey)
	local f = Instance.new("Frame")
	f.Size = size
	f.Position = pos
	f.BackgroundColor3 = Theme.Background
	f.BackgroundTransparency = 0.04
	f.BorderSizePixel = 0
	f.ClipsDescendants = true
	f.Parent = gui
	f.Active = true
	corner(f, 12)
	addOutline(f)
	makeHeader(f, t, false)
	MakeBottomDragHandle(f, saveKey or t)
	local body = Instance.new("ScrollingFrame")
	body.Size = UDim2.new(1, -12, 1, -50)
	body.Position = UDim2.new(0, 6, 0, 46)
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.ScrollBarThickness = 3
	body.ScrollBarImageColor3 = Theme.Accent
	body.CanvasSize = UDim2.new(0, 0, 0, 0)
	body.Active = true
	body.Parent = f
	local lay = Instance.new("UIListLayout")
	lay.Padding = UDim.new(0, 6)
	lay.Parent = body
	lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		body.CanvasSize = UDim2.new(0, 0, 0, lay.AbsoluteContentSize.Y + 10)
	end)
	if Config.sizes and Config.sizes[t] then
		f.Size = UDim2.new(0, Config.sizes[t].x, 0, Config.sizes[t].y)
	end
	makeResizable(f, UDim2.new(0, 150, 0, 150), t)
	return f, body
end
function makeQuickButton(parent, text, callback, bg)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -4, 0, 36)
	b.BackgroundColor3 = bg or Theme.SoftButton
	b.BackgroundTransparency = 0.02
	b.Text = text
	b.TextColor3 = Theme.Text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.AutoButtonColor = false
	b.Parent = parent
	corner(b, 6)
	b.MouseEnter:Connect(function()
		tw(b, { BackgroundColor3 = bg or Theme.SoftButtonHover }, 0.12)
	end)
	b.MouseLeave:Connect(function()
		tw(b, { BackgroundColor3 = bg or Theme.SoftButton }, 0.12)
	end)
	b.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)
	return b
end
function makeQuickSlider(parent, text, min, max, default, callback, suffix, step)
	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(1, -4, 0, 50)
	holder.BackgroundTransparency = 1
	holder.Parent = parent
	step = step or 0.1
	local stepMult = math.max(1, math.floor((1 / step) + 0.001))
	local function roundVal(v)
		return math.floor(v * stepMult + 0.5) / stepMult
	end
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 16)
	label.Position = UDim2.new(0, 4, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text .. ": " .. tostring(roundVal(default)) .. (suffix or "")
	label.TextColor3 = Theme.Text
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 10
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = holder
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -10, 0, 6)
	bar.Position = UDim2.new(0, 4, 0, 26)
	bar.BackgroundColor3 = Theme.SliderBg
	bar.BorderSizePixel = 0
	bar.Parent = holder
	corner(bar, 10)
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 1, 0)
	fill.BackgroundColor3 = Theme.Accent
	fill.BorderSizePixel = 0
	fill.Parent = bar
	corner(fill, 10)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(math.clamp((default - min) / (max - min), 0, 1), 0, 0.5, 0)
	knob.Name = "AccentSliderKnob"
	knob.BackgroundColor3 = Theme.Accent1
	knob.BorderSizePixel = 0
	knob.Parent = bar
	corner(knob, 20)
	local dragging = false
	local function update(x)
		local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		local v = roundVal(min + (max - min) * rel)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		knob.Position = UDim2.new(rel, 0, 0.5, 0)
		label.Text = text .. ": " .. tostring(v) .. (suffix or "")
		if callback then
			callback(v)
		end
	end
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			_G._HaramSliderDragging = true
			update(i.Position.X)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			_G._HaramSliderDragging = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if
			dragging
			and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch)
		then
			update(i.Position.X)
		end
	end)
	local function setVal(v, silent)
		v = roundVal(math.clamp(v, min, max))
		local rel = (v - min) / (max - min)
		fill.Size = UDim2.new(rel, 0, 1, 0)
		knob.Position = UDim2.new(rel, 0, 0.5, 0)
		label.Text = text .. ": " .. tostring(v) .. (suffix or "")
		if callback and not silent then
			callback(v)
		end
	end
	return { Set = setVal }
end

-- CAMP removed: keep the legacy block unreachable so it cannot create its panel
-- or register player-list connections in this hub version.
if false then
	task.spawn(function()
		local waitUntil = os.clock() + 15
		while type(_G.HaramCamp) ~= "table" and os.clock() < waitUntil do
			task.wait(0.1)
		end

		local panel, body =
			makeQuickPanel("CAMP\nBASE TARGET", UDim2.fromOffset(235, 310), UDim2.new(0, 20, 0.5, -155), "CAMP")
		panel.Name = "HaramCampPanel"
		panels["CAMP"] = panel
		panel.Visible = Config.Visibilities["CAMP"] ~= false

		local statusBtn = makeQuickButton(body, "CAMP: idle", function()
			local camp = _G.HaramCamp
			if camp and camp.active and type(camp.stop) == "function" then
				camp.stop()
			end
		end, Theme.Panel)
		statusBtn.Name = "HaramCampStatus"
		statusBtn.TextSize = 11

		local rows = {}
		local function clearRows()
			for _, row in ipairs(rows) do
				pcall(function()
					row:Destroy()
				end)
			end
			table.clear(rows)
		end

		local function rebuild()
			clearRows()
			local list = {}
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LocalPlayer then
					list[#list + 1] = plr
				end
			end
			table.sort(list, function(a, b)
				return (a.DisplayName or a.Name):lower() < (b.DisplayName or b.Name):lower()
			end)
			for _, plr in ipairs(list) do
				local label = plr.DisplayName == plr.Name and plr.Name or (plr.DisplayName .. "  @" .. plr.Name)
				local row = makeQuickButton(body, label, function()
					local camp = _G.HaramCamp
					if not camp then
						return
					end
					if camp.active and camp.target == plr.Name then
						if type(camp.stop) == "function" then
							camp.stop()
						end
					elseif type(camp.start) == "function" then
						local ok, why = camp.start(plr.Name)
						if not ok then
							pcall(function()
								HaramService("StarterGui"):SetCore("SendNotification", {
									Title = "Base CAMP",
									Text = tostring(why or "failed"),
									Duration = 4,
								})
							end)
						end
					end
				end)
				row.Name = "HaramCampPlayer_" .. plr.Name
				row.TextSize = 11
				row.TextTruncate = Enum.TextTruncate.AtEnd
				row:SetAttribute("CampPlayer", plr.Name)
				rows[#rows + 1] = row
			end
		end

		Players.PlayerAdded:Connect(function()
			task.defer(rebuild)
		end)
		Players.PlayerRemoving:Connect(function()
			task.defer(rebuild)
		end)
		rebuild()

		while panel.Parent do
			local camp = _G.HaramCamp
			local active = camp and camp.active
			statusBtn.Text = active and ("STOP CAMP  •  " .. tostring(camp.status or camp.target or "active"))
				or "CAMP: select a player"
			statusBtn.BackgroundColor3 = active and Theme.Accent or Theme.Panel
			statusBtn.TextColor3 = active and Color3.new(0, 0, 0) or Theme.Text
			for _, row in ipairs(rows) do
				local selected = active and row:GetAttribute("CampPlayer") == camp.target
				row.BackgroundColor3 = selected and Theme.Accent or Theme.SoftButton
				row.TextColor3 = selected and Color3.new(0, 0, 0) or Theme.Text
			end
			task.wait(0.2)
		end
	end)
end

-- Runway Auto Buy TEST: embedded supplied module, loaded on first enable.
local runwayRuntime, runwayRuntimeBuilding
local function createRunwayAutoBuy()
	if runwayRuntime then
		return runwayRuntime
	end
	if runwayRuntimeBuilding then
		repeat
			task.wait(0.03)
		until not runwayRuntimeBuilding
		if runwayRuntime then
			return runwayRuntime
		end
	end
	runwayRuntimeBuilding = true
	local function buildRuntime()
		--!nocheck
		-- Standalone runway auto-buy, extracted from Odyssey Auto Steal Spam.
		-- Load this file once. It returns the auto-buy API; buying starts only
		-- after set_enabled(true). See README.txt in this folder for integration.
		-- Every @src/@libs dependency below is embedded. require(Instance) calls load
		-- data/Observers/NumberUtils from the game, never the game Net or Synchronizer.

		local function identity(callback)
			return callback
		end
		local LPH_JIT_MAX = identity
		local LPH_NO_VIRTUALIZE = identity
		local LPH_OBFUSCATED = false
		local module_factories = {}
		local module_cache = {}
		local module_loading = {}

		local function bundle_require(module_id)
			module_id = module_id:gsub("^@libs/", "@src/libs/")
			if module_cache[module_id] ~= nil then
				return module_cache[module_id]
			end
			assert(not module_loading[module_id], "Circular standalone dependency: " .. module_id)
			local factory = assert(module_factories[module_id], "Missing standalone dependency: " .. module_id)
			module_loading[module_id] = true
			local ok, result = pcall(factory)
			module_loading[module_id] = nil
			if not ok then
				error(result, 0)
			end
			module_cache[module_id] = result
			return result
		end

		-- Source: @src/standalone/auto_buy_runway_spam
		module_factories["@src/standalone/auto_buy_runway_spam"] = function()
			-- Runtime for the test Extras; uses the supplied tracker and purchase module.
			local runway_tracker = bundle_require("@src/modules/shared/runway_tracker")
			local runway_util = bundle_require("@src/utils/runway")
			local debug_mode = bundle_require("@src/libs/debug_mode")
			local local_player = HaramService("Players").LocalPlayer
			local run_service = HaramService("RunService")
			local auto_buy = {}
			local config = {
				enabled = false,
				purchase_distance = 20,
				spam_attempts = 1,
				target_mode = "highest_value",
				target_names = {},
				follow = true,
				hover = 9,
			}
			local connection, current_target, manual_target_uid, target_provider
			local follow_lock, follow_character, body_position
			local followProgress
            local navigation = {}
            local recoveryTarget
			local exclusive, ownedTarget, lockedAnimal
			local resumeFollowAt, generation, stepBusy = 0, 0, false
			local followStepDt = 1 / 60
			local stepThread, stepStarted
			local watchedHumanoid, stateConnection, removingConnection, ragdollConnection
			local recoveringStates = {
				[Enum.HumanoidStateType.Physics] = true,
				[Enum.HumanoidStateType.Ragdoll] = true,
				[Enum.HumanoidStateType.FallingDown] = true,
				[Enum.HumanoidStateType.GettingUp] = true,
				[Enum.HumanoidStateType.PlatformStanding] = true,
			}
			local function isRagdolled(humanoid)
				local untilTime = tonumber(local_player:GetAttribute("RagdollEndTime")) or 0
				return untilTime > workspace:GetServerTimeNow()
					or (humanoid and (humanoid.PlatformStand or recoveringStates[humanoid:GetState()])) == true
			end
			local diagnostics = { phase = "off", tracked = 0, attempts = 0, sent = 0 }
			local function releaseFollow()
                local previous = navigation
                navigation = {}
                if previous.humanoid and previous.humanoid.Parent then
                    pcall(function()
                        previous.humanoid:Move(Vector3.zero, false)
                        if previous.humanoid.WalkSpeed == 32 and previous.oldSpeed then
                            previous.humanoid.WalkSpeed = previous.oldSpeed
                        end
                    end)
                end
				followProgress = nil
				if body_position then
					body_position:Destroy()
					body_position = nil
				end
				diagnostics.following = false
			end
			local function unlockFollow()
                recoveryTarget = nil
				follow_lock = nil
				follow_character = nil
				lockedAnimal = nil
				releaseFollow()
			end
			function auto_buy.suspend_follow(seconds, afterHit)
                if afterHit then
                    recoveryTarget = follow_lock or (current_target and (current_target.uuid or current_target.uid))
                end
				generation += 1
                resumeFollowAt = math.max(resumeFollowAt, os.clock() + (seconds or 0.2))
                -- Retain the selected UUID while the character recovers.
                releaseFollow()
			end
			local function watchHumanoid(humanoid)
				if watchedHumanoid == humanoid then
					return
				end
				if stateConnection then
					stateConnection:Disconnect()
					stateConnection = nil
				end
				watchedHumanoid = humanoid
				if humanoid then
					stateConnection = humanoid.StateChanged:Connect(function()
						if config.enabled and isRagdolled(humanoid) then
							auto_buy.suspend_follow(0.2, true)
                            diagnostics.phase = "paused_ragdoll"
						end
					end)
				end
			end
			local function pausedForRecovery(character, humanoid)
				if _G.Haram_IsResetting or _G.__elysiumResetBusy then
					auto_buy.suspend_follow()
					diagnostics.phase = "paused_reset"
					return true
				end
				if local_player.Character ~= character or not humanoid or humanoid.Health <= 0 then
					auto_buy.suspend_follow()
					diagnostics.phase = "no_character"
					return true
				end
				if isRagdolled(humanoid) then
					auto_buy.suspend_follow(0.2, true)
					diagnostics.phase = "paused_ragdoll"
					return true
				end
				if os.clock() < resumeFollowAt then
					releaseFollow()
					diagnostics.phase = "recovering_ragdoll"
					return true
				end
				return false
			end
            local function purchaseOwner(animal)
                local prompt = animal and animal.purchase_prompt
                if prompt and prompt.Parent then
                    return prompt:GetAttribute("TargetPlayer"), true
                end
                return nil, false
            end
			local function alreadyBought(animal)
                local owner, known = purchaseOwner(animal)
                if known then
                    return owner ~= nil and tostring(owner) == tostring(local_player.UserId)
                end
				return runway_tracker.is_animal_following_us(animal.uuid or animal.uid)
			end
            local function refreshPurchaseTarget(animal, animals)
                if not animal then return nil end
                local current = animals[animal.uuid or animal.uid] or animal
                -- A transferred animal can receive a replacement data model/prompt.
                local owner, known = purchaseOwner(current)
                if known and (owner == nil or tostring(owner) ~= tostring(local_player.UserId)) then
                    if ownedTarget == animal then ownedTarget = nil end
                    if exclusive and (exclusive.uid == current.uuid or exclusive.uid == current.uid) then
                        exclusive.bought, exclusive.complete = false, false
                    end
                end
                return current
            end
			local function followCentered(position, hrp)
				if not config.follow then
					releaseFollow()
					followProgress = nil
					return true
				end
				local character = local_player.Character
				local goal = position + Vector3.new(0, config.hover, 0)
				local delta = goal - hrp.Position
				local function blocked(reason)
                    releaseFollow()
                    diagnostics.phase = reason
                    return false
                end
				local physical = _G.HaramGetPhysicalRoot and _G.HaramGetPhysicalRoot()
				if physical and physical ~= hrp then
					return blocked("paused_clone_root")
				end
				if hrp.Anchored then
					return blocked("paused_root_locked")
				end
				-- Long gaps are approached in bounded steps; purchase radius does not stop following.
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.FilterDescendantsInstances = { character }
				params.RespectCanCollide = true
				params.CollisionGroup = hrp.CollisionGroup
				local overlap = OverlapParams.new()
				overlap.FilterType = Enum.RaycastFilterType.Exclude
				overlap.FilterDescendantsInstances = { character }
				overlap.RespectCanCollide = true
				overlap.CollisionGroup = hrp.CollisionGroup
				local boxSize = Vector3.new(
					math.max(0.5, hrp.Size.X - 0.2),
					math.max(0.5, hrp.Size.Y - 0.2),
					math.max(0.5, hrp.Size.Z - 0.2)
				)
				-- Blockcast does not detect an overlap at its start: check that separately.
				for _, part in ipairs(workspace:GetPartBoundsInBox(hrp.CFrame, boxSize, overlap)) do
					if part.CanCollide then
						return blocked("paused_obstacle")
					end
				end
				if
					delta.Magnitude > 0.1
					and workspace:Blockcast(hrp.CFrame, boxSize, delta.Unit * math.min(delta.Magnitude, 6), params)
				then
					return blocked("paused_obstacle")
				end
				if not followProgress or followProgress.root ~= hrp then
					followProgress = { root = hrp, position = hrp.Position, at = os.clock() }
				elseif os.clock() - followProgress.at >= 1 then
					local moved = (hrp.Position - followProgress.position).Magnitude
					followProgress = { root = hrp, position = hrp.Position, at = os.clock() }
					if delta.Magnitude > 3 and moved < 0.2 then
						return blocked("paused_stuck")
					end
				end
				if body_position and body_position.Parent ~= hrp then
					releaseFollow()
				end
				if not body_position then
					body_position = Instance.new("BodyPosition")
					body_position.Name = "HaramRunwayFollow"
					local force = math.clamp(hrp.AssemblyMass * 1500, 10000, 200000)
					body_position.MaxForce = Vector3.new(force, force, force)
					body_position.P = 16000
					body_position.D = 700
					body_position.Position = hrp.Position
					body_position.Parent = hrp
				end
				-- No distant PivotTo, torso writes, or unlimited force through obstacles.
				local step = math.clamp(65 * (body_position.D / body_position.P + followStepDt), 0.25, 6)
				body_position.Position = delta.Magnitude > step and hrp.Position + delta.Unit * step or goal
				diagnostics.following = true
				return true
			end

            local function returnAfterHit(position, hrp)
                if not config.follow then releaseFollow(); return true end
                local character = local_player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not humanoid or humanoid.Health <= 0 then return false end
                local physical = _G.HaramGetPhysicalRoot and _G.HaramGetPhysicalRoot()
                if hrp.Anchored or (physical and physical ~= hrp) then
                    releaseFollow()
                    diagnostics.phase = "paused_root_locked"
                    return false
                end
                if navigation.humanoid ~= humanoid then
                    releaseFollow()
                    navigation.humanoid = humanoid
                    navigation.oldSpeed = humanoid.WalkSpeed
                end
                humanoid.WalkSpeed = 32
                local goal = position
                local flat = Vector3.new(goal.X - hrp.Position.X, 0, goal.Z - hrp.Position.Z)
                -- Remain on the ground and within the native purchase prompt radius.
                if flat.Magnitude <= 4 then
                    humanoid:Move(Vector3.zero, false)
                    diagnostics.following = true
                    return true
                end
                local now = os.clock()
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Exclude
                params.FilterDescendantsInstances = { character }
                params.RespectCanCollide = true
                params.CollisionGroup = hrp.CollisionGroup
                local size = Vector3.new(math.max(2, hrp.Size.X), math.max(2, hrp.Size.Y), math.max(2, hrp.Size.Z))
                local function clearTo(point)
                    local direction = Vector3.new(point.X - hrp.Position.X, 0, point.Z - hrp.Position.Z)
                    return direction.Magnitude < 0.1 or not workspace:Blockcast(hrp.CFrame, size, direction, params)
                end
                local clear = clearTo(goal)
                if navigation.progressAt and now - navigation.progressAt >= 0.8 then
                    if (hrp.Position - navigation.progressPosition).Magnitude < 0.5 then
                        navigation.waypoints = nil
                        navigation.nextPlan = 0
                        clear = false
                    end
                    navigation.progressAt, navigation.progressPosition = now, hrp.Position
                elseif not navigation.progressAt then
                    navigation.progressAt, navigation.progressPosition = now, hrp.Position
                end
                local needsPlan = not navigation.waypoints or not navigation.waypoints[navigation.index]
                    or (navigation.goal and (goal - navigation.goal).Magnitude > 8)
                if not clear and needsPlan and not navigation.planning and now >= (navigation.nextPlan or 0) then
                    local nav, start, destination = navigation, hrp.Position, goal
                    nav.planning, nav.nextPlan = true, now + 0.65
                    local planId = (nav.planId or 0) + 1
                    nav.planId, nav.planStarted = planId, now
                    task.spawn(function()
                        local ok, waypoints = pcall(function()
                            local path = HaramService("PathfindingService"):CreatePath({
                                AgentRadius = 2.5, AgentHeight = 5,
                                AgentCanJump = true, WaypointSpacing = 4,
                            })
                            path:ComputeAsync(start, destination)
                            if path.Status == Enum.PathStatus.Success then return path:GetWaypoints() end
                        end)
                        if navigation ~= nav or nav.planId ~= planId then return end
                        nav.planning = false
                        if ok and waypoints and #waypoints > 1 then
                            nav.waypoints, nav.index, nav.goal = waypoints, 2, destination
                        end
                    end)
                end
                if navigation.planning and now - navigation.planStarted > 2 then
                    navigation.planId = navigation.planId + 1
                    navigation.planning = false
                end
                local waypoint
                if not clear and navigation.waypoints then
                    waypoint = navigation.waypoints[navigation.index]
                    while waypoint and (Vector3.new(waypoint.Position.X - hrp.Position.X, 0,
                        waypoint.Position.Z - hrp.Position.Z)).Magnitude < 2.5 do
                        navigation.index = navigation.index + 1
                        waypoint = navigation.waypoints[navigation.index]
                    end
                    if navigation.goal and (goal - navigation.goal).Magnitude > 8 then
                        navigation.nextPlan = math.min(navigation.nextPlan or 0, now)
                    end
                end
                local destination = clear and goal or waypoint and waypoint.Position
                if not destination then
                    humanoid:Move(Vector3.zero, false)
                    diagnostics.phase = "planning_route"
                    return true -- A route calculation must not block nearby purchases.
                end
                local direction = Vector3.new(destination.X - hrp.Position.X, 0, destination.Z - hrp.Position.Z)
                -- Recheck the next short segment for dynamic obstacles before walking.
                local ahead = direction.Magnitude > 0.1 and direction.Unit * math.min(3, direction.Magnitude)
                local obstacle = ahead and workspace:Blockcast(hrp.CFrame, size, ahead, params)
                if obstacle and not (waypoint and waypoint.Action == Enum.PathWaypointAction.Jump) then
                    navigation.waypoints = nil
                    humanoid:Move(Vector3.zero, false)
                    diagnostics.phase = "planning_route"
                    return true
                end
                if waypoint and waypoint.Action == Enum.PathWaypointAction.Jump then humanoid.Jump = true end
                humanoid:Move(direction.Magnitude > 0.1 and direction.Unit or Vector3.zero, false)
                diagnostics.following = true
                return true
            end


            local function followPosition(position, hrp)
                if not config.follow then releaseFollow(); return true end
                local uid = current_target and (current_target.uuid or current_target.uid)
                if recoveryTarget and uid == recoveryTarget then
                    local flat = Vector3.new(position.X - hrp.Position.X, 0, position.Z - hrp.Position.Z)
                    if flat.Magnitude > 4 then
                        return returnAfterHit(position, hrp)
                    end
                    -- Rejoin centered following only after reaching the previous target.
                    releaseFollow()
                    recoveryTarget = nil
                elseif recoveryTarget then
                    releaseFollow()
                    recoveryTarget = nil
                end
                return followCentered(position, hrp)
            end

			local function root()
				local character = local_player.Character
				return character and character:FindFirstChild("HumanoidRootPart")
			end
			function auto_buy.get_animal_position(animal)
				if not animal then
					return nil
				end
				local rendered = animal.rendered_instance
				if not rendered or not rendered.Parent then
					runway_tracker.refresh_rendered_instance(animal)
					rendered = animal.rendered_instance
				end
				local model = rendered and rendered.Parent and rendered or animal.instance
				if not model or not model.Parent then
					return nil
				end
				if model.PrimaryPart then
					return model.PrimaryPart.Position
				end
				local ok, position = pcall(function()
					return model:GetPivot().Position
				end)
				return ok and position or nil
			end
			local function choose(hrp)
				local animals = runway_tracker.get_animals()
                if ownedTarget then
                    local previous = ownedTarget
                    local refreshed = refreshPurchaseTarget(previous, animals)
                    if ownedTarget then ownedTarget = refreshed end
                end
                if exclusive and exclusive.last then
                    exclusive.last = refreshPurchaseTarget(exclusive.last, animals)
                end
                if lockedAnimal then
                    lockedAnimal = refreshPurchaseTarget(lockedAnimal, animals)
                end
				diagnostics.tracked, diagnostics.nearest_distance = 0, nil
				for _, animal in pairs(animals) do
					diagnostics.tracked += 1
					local position = auto_buy.get_animal_position(animal)
					if position then
						local distance = (hrp.Position - position).Magnitude
						if not diagnostics.nearest_distance or distance < diagnostics.nearest_distance then
							diagnostics.nearest_distance = distance
						end
					end
				end
				if exclusive then
					local selected
					for _, animal in pairs(animals) do
						auto_buy.get_animal_position(animal)
						if
							animal.uuid == exclusive.uid
							or animal.uid == exclusive.uid
							or (exclusive.model and animal.rendered_instance == exclusive.model)
						then
							selected = animal
							break
						end
					end
					if selected then
						exclusive.last = selected
						exclusive.uid = selected.uuid or selected.uid
					end
					selected = selected or exclusive.last
					local model = selected and selected.rendered_instance or exclusive.model
					if selected and model and model.Parent then
						return selected
					end
					if exclusive.bought and (not model or not model.Parent) then
						exclusive.complete = true
					end
					return nil
				end
				if ownedTarget then
					local model = ownedTarget.rendered_instance
					if model and model.Parent then
						return ownedTarget
					end
					ownedTarget = nil
				end
				if target_provider then
					local target = target_provider(animals)
					if type(target) == "string" then
						return animals[target]
					end
					return target and animals[target.uuid or target.uid] or nil
				end
				if manual_target_uid then
					return animals[manual_target_uid]
				end
				if config.follow and follow_lock then
					local animal = animals[follow_lock] or lockedAnimal
					if animal and auto_buy.get_animal_position(animal) then
						return animal
					end
					unlockFollow()
				end
				local best, score = nil, nil
				for _, animal in pairs(animals) do
					if alreadyBought(animal) then
						continue
					end
					if #config.target_names > 0 and not table.find(config.target_names, animal.display_name) then
						continue
					end
					local position = auto_buy.get_animal_position(animal)
					if not position then
						continue
					end
					local distance = (hrp.Position - position).Magnitude
					-- A distant expensive animal must not block an available nearby one.
					if distance > config.purchase_distance then
						continue
					end
					local value = config.target_mode == "nearest" and -distance or (tonumber(animal.gen_value) or 0)
					if not best or value > score or (value == score and tostring(animal.uid) < tostring(best.uid)) then
						best, score = animal, value
					end
				end
				return best
			end
			local function stopAfterError(err)
                if isRagdolled(watchedHumanoid) or os.clock() < resumeFollowAt then
                    diagnostics.recovery_error = tostring(err)
                    diagnostics.last_error = nil
                    auto_buy.suspend_follow(0.2, true)
                    diagnostics.phase = "paused_ragdoll"
                    return
                end
				diagnostics.phase = "error"
				diagnostics.last_error = tostring(err)
				config.enabled = false
				unlockFollow()
				if connection then
					connection:Disconnect()
					connection = nil
				end
			end
			function auto_buy.step()
				if not config.enabled then
					return
				end
				local stepGeneration = generation
				if _G.Haram_IsResetting or _G.__elysiumResetBusy then
					unlockFollow()
					diagnostics.phase = "paused_reset"
					return
				end
				if _G.HaramLaserGrabSession or _G.HaramSourceStealActive then
					unlockFollow()
					diagnostics.phase = "paused_pickup"
					return
				end
				if local_player:GetAttribute("Stealing") == true then
					unlockFollow()
					diagnostics.phase = "paused_carry"
					return
				end
				if _G.HaramIsTeleporting and _G.HaramIsTeleporting() then
					unlockFollow()
					diagnostics.phase = "paused_tp"
					return
				end
				local hrp = root()
				local humanoid = local_player.Character and local_player.Character:FindFirstChildOfClass("Humanoid")
				local character = local_player.Character
				watchHumanoid(humanoid)
				if not hrp then
					auto_buy.suspend_follow()
					diagnostics.phase = "no_character"
					return
				end
				if pausedForRecovery(character, humanoid) then
					return
				end
				if follow_character and follow_character ~= local_player.Character then
					unlockFollow()
				end
				current_target = choose(hrp)
				diagnostics.target, diagnostics.distance = nil, nil
				if not current_target then
					unlockFollow()
					diagnostics.phase = exclusive
							and (exclusive.complete and "target_completed" or "waiting_selected_data")
						or (diagnostics.tracked == 0 and "no_animals" or "no_nearby_target")
					return
				end
				diagnostics.target = current_target.display_name or current_target.name or current_target.uid
				local position = auto_buy.get_animal_position(current_target)
				if not position then
					unlockFollow()
					diagnostics.phase = "no_position"
					return
				end
				local distance = (hrp.Position - position).Magnitude
				diagnostics.distance = distance
				if
					not follow_lock
					and not exclusive
					and ownedTarget ~= current_target
					and not alreadyBought(current_target)
					and distance > config.purchase_distance
				then
					unlockFollow()
					diagnostics.phase = "out_of_range"
					return
				end
				if config.follow then
					follow_lock = current_target.uuid or current_target.uid
					follow_character = local_player.Character
					lockedAnimal = current_target
				end
				if not followPosition(position, hrp) then
					return
				end
				if
					alreadyBought(current_target)
					or (
						(ownedTarget == current_target or (exclusive and exclusive.bought))
						and (not current_target.instance or not current_target.instance.Parent)
					)
				then
					ownedTarget = current_target
					if exclusive then
						exclusive.bought = true
					end
					diagnostics.phase = "following_owned"
					return
				end
				if distance > config.purchase_distance then
					diagnostics.phase = "following"
					return
				end
				diagnostics.phase = "sending"
				for _ = 1, math.min(config.spam_attempts, 8) do
					if not config.enabled or generation ~= stepGeneration or pausedForRecovery(character, humanoid) then
						return
					end
					diagnostics.attempts += 1
                    if alreadyBought(current_target) then return end
					local sent, reason, retryable = runway_util.purchase_animal(current_target, config.spam_attempts)
					if generation ~= stepGeneration or not config.enabled or local_player.Character ~= character then
						return
					end
                    if sent ~= true then
                        if retryable then
                            diagnostics.phase = reason or "waiting_purchase_prompt"
                        else
                            stopAfterError(reason or "Purchase request failed")
                        end
                        return
                    end
					diagnostics.sent += 1
				end
			end
			function auto_buy.set_enabled(value)
				generation += 1
				if removingConnection then
					removingConnection:Disconnect()
					removingConnection = nil
				end
				if ragdollConnection then
					ragdollConnection:Disconnect()
					ragdollConnection = nil
				end
				watchHumanoid(nil)
				config.enabled = value == true
				if connection then
					connection:Disconnect()
					connection = nil
				end
				unlockFollow()
				if not config.enabled then
					current_target = nil
					exclusive = nil
					ownedTarget = nil
					diagnostics.phase = "off"
					return
				end
				diagnostics.last_error = nil
				diagnostics.phase = "starting"
				runway_tracker.init()
				removingConnection = local_player.CharacterRemoving:Connect(function()
					auto_buy.suspend_follow()
					watchHumanoid(nil)
				end)
				ragdollConnection = local_player:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
					if isRagdolled(watchedHumanoid) then
						auto_buy.suspend_follow(0.2, true)
					end
				end)
				connection = run_service.RenderStepped:Connect(function(dt)
					followStepDt = math.clamp(tonumber(dt) or 1 / 60, 1 / 240, 1 / 15)
					-- Purchase calls may yield: never stack follow/purchase steps across frames.
					if stepBusy then
						if stepStarted and os.clock() - stepStarted > 2 then
							generation += 1
							unlockFollow()
							local stale = stepThread
							stepBusy = false
							stepThread = nil
							if stale and stale ~= coroutine.running() then
								pcall(task.cancel, stale)
							end
							resumeFollowAt = os.clock() + 0.75
							diagnostics.phase = "recovering_request"
						end
						return
					end
					stepBusy = true
					stepThread = coroutine.running()
					stepStarted = os.clock()
					local stepGeneration = generation
					local ok, err = pcall(auto_buy.step)
					if stepThread == coroutine.running() then
						stepBusy = false
						stepThread = nil
					end
					if not ok and config.enabled and generation == stepGeneration then
						stopAfterError(err)
					end
				end)
			end
			function auto_buy.is_enabled()
				return config.enabled
			end
			function auto_buy.is_ready()
				return runway_util.is_ready()
			end
			function auto_buy.get_diagnostics()
				local result = table.clone(diagnostics)
				result.purchase_distance = config.purchase_distance
				return result
			end
			function auto_buy.set_runway_purchase_distance(value)
				config.purchase_distance = math.clamp(tonumber(value) or config.purchase_distance, 0, 100)
				unlockFollow()
			end
			function auto_buy.get_runway_purchase_distance()
				return config.purchase_distance
			end
			function auto_buy.set_runway_spam_attempts(value)
				config.spam_attempts = math.clamp(math.floor(tonumber(value) or config.spam_attempts), 1, 50)
			end
			function auto_buy.get_runway_spam_attempts()
				return config.spam_attempts
			end
			function auto_buy.set_target_mode(value)
				assert(value == "highest_value" or value == "nearest", "Expected highest_value or nearest")
				config.target_mode = value
				unlockFollow()
			end
			function auto_buy.set_follow_enabled(value)
				config.follow = value == true
				unlockFollow()
			end
			function auto_buy.set_follow_height(value)
				config.hover = math.clamp(tonumber(value) or 9, 0, 20)
			end
			function auto_buy.set_targets(names)
				config.target_names = table.clone(names)
				unlockFollow()
			end
			function auto_buy.set_exclusive_road_target(pet)
				assert(type(pet) == "table" and (pet.uid or pet.model), "Road target identity is required")
				generation += 1
				exclusive = { uid = pet.uid, model = pet.model, last = pet.animal, bought = false, complete = false }
				ownedTarget = nil
				config.follow = true
				unlockFollow()
			end
			function auto_buy.set_target(uid)
				manual_target_uid = uid
				unlockFollow()
			end
			function auto_buy.set_target_provider(callback)
				target_provider = callback
				unlockFollow()
			end
			function auto_buy.get_current_target()
				return current_target
			end
			function auto_buy.get_animals()
				runway_tracker.init()
				return runway_tracker.get_animals()
			end
			function auto_buy.set_debug(value)
				runway_tracker.set_debug(value == true)
				debug_mode.enabled = value == true
			end
			return auto_buy
		end

		-- Source: @src/modules/shared/runway_tracker
		module_factories["@src/modules/shared/runway_tracker"] = function()
			--!nonstrict
			local game_utils = bundle_require("@src/utils/game")
			local game_deps = bundle_require("@src/utils/game_deps")
			local Profiler = bundle_require("@libs/profiler")

			local Players = game_utils.get_service("Players")
			local HttpService = game_utils.get_service("HttpService")
			local Workspace = game_utils.get_service("Workspace")
            local CollectionService = game_utils.get_service("CollectionService")

			local Observers = game_deps.Observers
			local AnimalsData = game_deps.AnimalsData
			local RaritiesData = game_deps.RaritiesData
			local MutationsData = game_deps.MutationsData
			local generation = bundle_require("@src/utils/generation")
			local NumberUtils = game_deps.NumberUtils

			local local_player = Players.LocalPlayer

			local runway_tracker = {}
			local runway_animals = {}
			local animals_following_us = {}

			local on_list_changed = Instance.new("BindableEvent")
			runway_tracker.on_list_changed = on_list_changed.Event

			local initialized = false
			local debug_mode = false
			local rendered_models_container = nil
			local rendered_models_by_data_primary = {}
			local rendered_models_dirty = true
			local rendered_container_added_connection = nil
			local rendered_container_removed_connection = nil
			local workspace_child_added_connection = nil
			local workspace_child_removed_connection = nil

			local rebuild_rendered_index_profiler = Profiler.new("RunwayTracker.rebuild_rendered_index")
			local find_rendered_model_profiler = Profiler.new("RunwayTracker.find_rendered_model")
			local last_profile_log_time = 0

			local function debug_log(...)
				if not debug_mode then
					return
				end
				print("[RunwayTracker Debug]", ...)
			end

			local function maybe_log_profiler_stats()
				if not debug_mode then
					return
				end

				local current_time = os.clock()
				if current_time - last_profile_log_time < 5 then
					return
				end

				last_profile_log_time = current_time
				rebuild_rendered_index_profiler:log_results()
				find_rendered_model_profiler:log_results()
			end

			local function finish_profile(profiler)
				profiler:finish(false)
				maybe_log_profiler_stats()
			end

			local function mark_rendered_models_dirty()
				rendered_models_dirty = true
			end

			local function disconnect_rendered_container_connections()
				if rendered_container_added_connection then
					rendered_container_added_connection:Disconnect()
					rendered_container_added_connection = nil
				end

				if rendered_container_removed_connection then
					rendered_container_removed_connection:Disconnect()
					rendered_container_removed_connection = nil
				end
			end

			local function attach_rendered_container(container)
				if rendered_models_container == container then
					return
				end

				disconnect_rendered_container_connections()

				rendered_models_container = container
				rendered_models_by_data_primary = {}
				rendered_models_dirty = true

				if not container then
					return
				end

				rendered_container_added_connection = container.ChildAdded:Connect(mark_rendered_models_dirty)
				rendered_container_removed_connection = container.ChildRemoved:Connect(function(removed_child)
					mark_rendered_models_dirty()

					for data_primary, rendered_model in pairs(rendered_models_by_data_primary) do
						if rendered_model == removed_child then
							rendered_models_by_data_primary[data_primary] = nil
						end
					end
				end)
			end

			local function setup_rendered_container_tracking()
				attach_rendered_container(Workspace:FindFirstChild("RenderedMovingAnimals"))

				if not workspace_child_added_connection then
					workspace_child_added_connection = Workspace.ChildAdded:Connect(function(child)
						if child.Name == "RenderedMovingAnimals" then
							attach_rendered_container(child)
						end
					end)
				end

				if not workspace_child_removed_connection then
					workspace_child_removed_connection = Workspace.ChildRemoved:Connect(function(child)
						if child == rendered_models_container then
							attach_rendered_container(nil)
						end
					end)
				end
			end

			local function get_data_primary(animal_instance)
				local data_primary = nil

				pcall(function()
					data_primary = animal_instance.PrimaryPart
				end)

				return data_primary
			end

			local function get_connected_data_primary(rendered_primary)
				for _, child in rendered_primary:GetChildren() do
					if child:IsA("WeldConstraint") or child:IsA("Weld") then
						if child.Part0 == rendered_primary then
							return child.Part1
						end

						if child.Part1 == rendered_primary then
							return child.Part0
						end
					end
				end

				return nil
			end

			local function rebuild_rendered_index()
				if not rendered_models_dirty then
					return
				end

				if not rendered_models_container or not rendered_models_container.Parent then
					attach_rendered_container(Workspace:FindFirstChild("RenderedMovingAnimals"))
				end

				if not rendered_models_container then
					rendered_models_by_data_primary = {}
					rendered_models_dirty = false
					return
				end

				rebuild_rendered_index_profiler:start()

				local indexed_models = {}

				for _, rendered_model in rendered_models_container:GetChildren() do
					if not rendered_model:IsA("Model") then
						continue
					end

					local rendered_primary = nil
					pcall(function()
						rendered_primary = rendered_model.PrimaryPart
					end)

					if not rendered_primary then
						continue
					end

					local data_primary = get_connected_data_primary(rendered_primary)
					if data_primary then
						indexed_models[data_primary] = rendered_model
					end
				end

				rendered_models_by_data_primary = indexed_models
				rendered_models_dirty = false

				finish_profile(rebuild_rendered_index_profiler)
			end

			-- Find the rendered (visual) model for a runway animal.
			-- The "Animal" tagged instance is an invisible data model underground.
			-- The game (AnimalClient.lua) links the rendered model to the data model with either
			-- a Weld or a WeldConstraint on the rendered model's PrimaryPart.
			local function find_rendered_model(animal_instance)
				find_rendered_model_profiler:start()

				local data_primary = get_data_primary(animal_instance)
				if not data_primary then
					finish_profile(find_rendered_model_profiler)
					return nil
				end

				local cached_model = rendered_models_by_data_primary[data_primary]
				if cached_model and cached_model.Parent then
					finish_profile(find_rendered_model_profiler)
					return cached_model
				end

				rendered_models_by_data_primary[data_primary] = nil
				rendered_models_dirty = true
				rebuild_rendered_index()

				local rendered_model = rendered_models_by_data_primary[data_primary]

				finish_profile(find_rendered_model_profiler)
				return rendered_model
			end

            -- Data models may only contain a UUID; the Weld-linked visual has the name.
            local animalNames = {}
            local function nameKey(value)
                return tostring(value or ""):lower():gsub("%s+", "")
            end
            for index, info in pairs(AnimalsData) do
                if type(info) == "table" then
                    for _, name in ipairs({ tostring(index), tostring(info.DisplayName or index) }) do
                        local key = nameKey(name)
                        if animalNames[key] == nil or animalNames[key] == index then
                            animalNames[key] = index
                        else
                            animalNames[key] = false -- Ambiguous names must not select an animal.
                        end
                    end
                end
            end
			local function parse_animal_data(animal_instance, purchasePrompt)
				local uuid = animal_instance.Name
                local rendered = find_rendered_model(animal_instance)
				local index = animal_instance:GetAttribute("Index")
                if not index or not AnimalsData[index] then
                    local visualIndex = rendered and rendered:GetAttribute("Index")
                    index = visualIndex and AnimalsData[visualIndex] and visualIndex
                        or (rendered and animalNames[nameKey(rendered.Name)])
                    if not index and purchasePrompt then
                        local label = tostring(purchasePrompt.ObjectText or ""):gsub("<[^>]->", "")
                        local name = label:match("^(.-)%s*%$") or label
                        index = animalNames[nameKey(name)]
                    end
                end
				if not index then return nil end

				local animal_info = AnimalsData[index]
				if not animal_info then
					return nil
				end

				local mutation = animal_instance:GetAttribute("Mutation")
				local traits_raw = animal_instance:GetAttribute("Traits")
				local traits = nil

				if traits_raw and traits_raw ~= "" then
					pcall(function()
						traits = HttpService:JSONDecode(traits_raw)
					end)
				end

				local display_name = animal_info.DisplayName or index
				local rarity = animal_info.Rarity
				local rarity_data = RaritiesData[rarity]
				local rarity_color = rarity_data and rarity_data.Color or Color3.fromRGB(255, 255, 255)
				local rarity_gradient = rarity_data and rarity_data.GradientPreset or nil
				local mutation_data = mutation and MutationsData[mutation] or nil
				local gen_value = generation.get(index, mutation, traits)
				local gen_text = NumberUtils:ToString(gen_value) .. "/s"

				return {
					uuid = uuid,
					uid = uuid, -- Ensure compatibility with auto_steal uid
					index = index,
					display_name = display_name,
					name = display_name, -- Alias for auto_steal
					rarity = rarity,
					rarity_color = rarity_color,
					rarity_gradient = rarity_gradient,
					mutation = mutation,
					mutation_data = mutation_data,
					traits = traits,
					traits_array = traits or {}, -- Compatibility alias
					gen_value = gen_value,
					gen_text = gen_text,
					price = animal_info.Price or 0,
					instance = animal_instance,
					rendered_instance = rendered, -- visual model for ESP/highlights
                    purchase_prompt = purchasePrompt,
					is_runway = true,
					plot = nil,
					slot = nil,
					state = nil,
					state_color = nil,
					owner = "Runway",
				}
			end

			function runway_tracker.init()
				if initialized then
					return
				end
				initialized = true

				setup_rendered_container_tracking()

				Observers.observeTag("Animal", function(animal_instance)
					local animal_data = parse_animal_data(animal_instance)

					if not animal_data then
						return function() end
					end

					local uuid = animal_data.uuid
					runway_animals[uuid] = animal_data

					debug_log("Animal tracked:", animal_data.name, "UUID:", uuid)

					-- Emit event
					on_list_changed:Fire()

					return function()
						debug_log("Animal untracked:", animal_data.name, "UUID:", uuid)
						runway_animals[uuid] = nil
						animals_following_us[uuid] = nil
						on_list_changed:Fire()
					end
				end)

				Observers.observeTag("AnimalPurchasePrompt", function(prompt)
					return Observers.observeAttribute(prompt, "TargetPlayer", function(target_player_id)
						local animal_model = prompt:FindFirstAncestorOfClass("Model")
						if not animal_model then
							return
						end

						local uuid = animal_model.Name

                        if target_player_id ~= nil and tostring(target_player_id) == tostring(local_player.UserId) then
							local index_name = animal_model:GetAttribute("Index")
                            local tracked = runway_animals[uuid]
                            animals_following_us[uuid] = index_name or (tracked and tracked.index) or true
							debug_log("Animal is now following us:", index_name, "UUID:", uuid)
						else
							if animals_following_us[uuid] then
								debug_log("Animal no longer following us:", uuid)
							end
							animals_following_us[uuid] = nil
						end

						on_list_changed:Fire()
					end)
				end)
			end

            local lastReconcile = -math.huge
			function runway_tracker.get_animals()
                -- Tags can arrive before the visual/Weld. Retry unresolved entries and
                -- include existing tags even if the observer missed its initial callback.
                if initialized and os.clock() - lastReconcile >= 0.25 then
                    lastReconcile = os.clock()
                    local live, prompts, changed = {}, {}, false
                    for _, model in ipairs(CollectionService:GetTagged("Animal")) do
                        if model.Parent then live[model.Name] = model end
                    end
                    -- Purchased animals can leave the runway/tag while their
                    -- purchase prompt remains active on the walk to a base.
                    for _, prompt in ipairs(CollectionService:GetTagged("AnimalPurchasePrompt")) do
                        if prompt.Parent and prompt:IsA("ProximityPrompt") then
                            local model = prompt:FindFirstAncestorOfClass("Model")
                            if model and model.Parent then
                                local uid = prompt:GetAttribute("UID")
                                if uid == nil or tostring(uid) == tostring(model.Name) then
                                    live[model.Name] = model
                                    local previous = prompts[model.Name]
                                    if not previous or (prompt.Enabled and not previous.Enabled) then
                                        prompts[model.Name] = prompt
                                    end
                                end
                            end
                        end
                    end
                    for uuid, model in pairs(live) do
                        local prompt = prompts[uuid]
                        if not runway_animals[uuid] or runway_animals[uuid].instance ~= model then
                            local ok, animal = pcall(parse_animal_data, model, prompt)
                            if ok and animal then
                                runway_animals[uuid] = animal
                                changed = true
                            elseif not ok then
                                debug_log("Animal parse failed:", uuid, tostring(animal))
                            end
                        end
                        local animal = runway_animals[uuid]
                        if animal then animal.purchase_prompt = prompt end
                        if animal and prompt then
                            local targetPlayer = prompt:GetAttribute("TargetPlayer")
                            if targetPlayer ~= nil and tostring(targetPlayer) == tostring(local_player.UserId) then
                                animals_following_us[uuid] = animal.index or true
                            else
                                animals_following_us[uuid] = nil
                            end
                        end
                    end
                    for uuid, animal in pairs(runway_animals) do
                        if live[uuid] ~= animal.instance then
                            runway_animals[uuid], animals_following_us[uuid] = nil, nil
                            changed = true
                        end
                    end
                    if changed then on_list_changed:Fire() end
                end
				return runway_animals
			end

			function runway_tracker.get_animals_following_us()
				return animals_following_us
			end

			function runway_tracker.is_animal_following_us(uuid)
				return animals_following_us[uuid] ~= nil
			end

			function runway_tracker.refresh_rendered_instance(animal_data)
				if not animal_data or not animal_data.instance then
					return
				end

				if animal_data.rendered_instance and animal_data.rendered_instance.Parent then
					return animal_data.rendered_instance
				end

				animal_data.rendered_instance = find_rendered_model(animal_data.instance)
				return animal_data.rendered_instance
			end

			function runway_tracker.set_debug(value)
				debug_mode = value
			end

			function runway_tracker.is_debug()
				return debug_mode
			end

			return runway_tracker
		end

		-- Source: @src/utils/game
		module_factories["@src/utils/game"] = function()
			--!nonstrict
			local cloneref = cloneref or function(o)
				return o
			end

			local game_ref = cloneref(game)

			local game_utils = {}

			-- run_as_game (identity 2 + временно убранные глобалы экзекутора) удалён
			-- 2026-09-29. Колбэк шёл на нашем же потоке, так что наши кадры оставались на
			-- стеке, а cloneref/writefile/getnamecallmethod, которые ищут сканы Net и
			-- RelateChannels, из getgenv не убирались. От этих сканов он не защищал, а
			-- вокруг FireServer/InvokeServer был просто лишним: сервер стек клиента не видит.

			local GUI_READY_TIMEOUT = 5

			function game_utils.get_service(service_name)
				return game_ref:GetService(service_name)
			end

			local function usable(container)
				if not container then
					return false
				end
				return (pcall(function()
					return container:FindFirstChild("__ods_probe__")
				end))
			end

			-- Контейнер для нашего GUI: gethui(), иначе CoreGui. PlayerGui — никогда:
			-- античит сверяет имена детей PlayerGui со списком от сервера (X-23/X-24,
			-- brainrot_finder_panel-1/dumps/nil_obfuscated/ANALYSIS.md).
			--
			-- gethui() на старте сразу отдаёт объект CoreGui, но короткое время после
			-- инжекта его нельзя индексировать ("lacking capability Plugin"). Поэтому ждём,
			-- пока контейнер реально станет доступен, а не просто пока gethui вернёт не nil.
			function game_utils.get_gui()
				if type(gethui) == "function" then
					local deadline = os.clock() + GUI_READY_TIMEOUT
					repeat
						local ok, gui = pcall(gethui)
						if ok and usable(gui) then
							return gui
						end
						task.wait()
					until os.clock() >= deadline
				end

				local core_ok, core_gui = pcall(function()
					return game_ref:GetService("CoreGui")
				end)
				return core_ok and core_gui or nil
			end

			return game_utils
		end

		-- Source: @src/utils/game_deps
		module_factories["@src/utils/game_deps"] = function()
			local replicated_storage = HaramService("ReplicatedStorage")
			local datas = assert(replicated_storage:WaitForChild("Datas", 30), "Datas missing")
			local packages = assert(replicated_storage:WaitForChild("Packages", 30), "Packages missing")
			return {
				NetSafe = bundle_require("@src/utils/net_safe"),
				Observers = require(packages:WaitForChild("Observers")),
				AnimalsData = require(datas:WaitForChild("Animals")),
				RaritiesData = require(datas:WaitForChild("Rarities")),
				MutationsData = require(datas:WaitForChild("Mutations")),
				TraitsData = require(datas:WaitForChild("Traits")),
				GameData = require(datas:WaitForChild("Game")),
				NumberUtils = require(replicated_storage:WaitForChild("Utils"):WaitForChild("NumberUtils")),
			}
		end

		-- Source: @src/utils/net_safe
		module_factories["@src/utils/net_safe"] = function()
			--!nonstrict
			--[[
    Резолв игровых ремоутов расчётом имени. Без Net, без getgc, без хуков.

    ── Как игра называет ремоуты ───────────────────────────────────────────────
    Тело ReplicatedStorage.Packages.Net деобфусцировано, читаемая реконструкция
    лежит в соседнем проекте: brainrot_finder_panel-1/dumps/obfuscated/Net.clean.luau.
    Имя инстанса собирается так:

        Name = ("RE/" | "RF/" | "URE/") .. sha256hex(scramble(logical) .. SALT .. JobId)

    scramble — печатный Виженер по байтам JobId, shift(b, k) = (b - 32 + k) % 95 + 32,
    причём "/" копируется как есть и НЕ сдвигает позицию ключа. SHA-256 у игры
    стоковый и побайтово совпадает с нашим src/libs/sha256.luau.

    Проверено на живом клиенте 2026-07-29 (JobId c8e9538c-…): из каждой приманки
    взято логическое имя, посчитан хеш, найден хешированный близнец — 317/317,
    промахов 0, расхождений класса 0. Методика повтора — §6 в конце Net.clean.luau.

    Замеры этого модуля там же, живьём: первый резолв 0.88 мс (включая сверку
    схемы), холодный расчёт хеша 0.26 мс, кеш-хит 0.60 мкс. Для сравнения, старый
    GC-гарвест стоил ~110 мс на старте.

    На случай, если игра сменит схему, ниже стоит одноразовая сверка
    verify_scheme: поломка вылезет одной внятной строкой в логе, а не молчаливым
    "ремоут не найден" по каждому имени.

    ── Почему не Net ───────────────────────────────────────────────────────────
    Net:RemoteEvent / :RemoteFunction из нашего окружения возвращает константную
    канарейку "RF/068a6294…", ребёнка с таким именем не существует: вызов висит
    10 с на WaitForChild и кикает. 2026-07-27 это дважды подтвердилось живьём
    (BAC-27410, BAC-7746, через 6-9 с после вызова).

    Причина теперь известна точно: расчёт хеша внутри Net безусловно сканирует
    getfenv(1..10) на маркеры экзекутора (cloneref, getrenv, getupvalues,
    getnamecallmethod, superflow_bytecode, поддельное окружение), при детекте
    стучит на сервер и подменяет хеш канарейкой. Мы этот код просто не зовём.

    ── Почему не плоское имя ───────────────────────────────────────────────────
    В Packages.Net на каждое имя по два ребёнка: плоский и хешированный. Плоские
    это ПРИМАНКИ — на них висит Security.OnDetected:RemoveFromGame(player,
    "X-39", name, 120, 360). Слушать их бесполезно (никогда не стреляют),
    отправлять — бан. Игра пользуется только хешированными.

    ── Что было здесь раньше ───────────────────────────────────────────────────
    До 2026-08-08 модуль ставил hookfunction на getfenv и Instance.WaitForChild,
    поднимал флаг allow_spoof и звал настоящий Net:Remote* с подсунутым игровым
    окружением. Это работало, но требовало install() до первого резолва, зависело
    от hookfunction/restorefunction экзекутора и оставляло два глобальных хука на
    всю сессию. Расчёт свободен от всего этого — ему нужен только JobId и сам
    инстанс в дереве.
]]

			local logging = bundle_require("@src/libs/logging")
			local sha256 = bundle_require("@src/libs/sha256")

			local RunService = HaramService("RunService")

			-- Соль игра ротирует с апдейтами, схема при этом не меняется. История:
			--   до 2026-08-16  bd93afff-8aba-409d-9946-a875f6c33087
			--   с  2026-08-16  36bc48de-ccc6-4666-af4b-7d3bd46d6aa7  (PlaceVersion 2501)
			-- Когда verify_scheme снова заорёт, новую соль не надо выковыривать из свежего
			-- блоба: Luraph держит расшифрованные константы модуля живыми таблицами в куче,
			-- сама соль — обычная Lua-строка, а любая приманка работает оракулом. Готовый
			-- пробник: brainrot_finder_panel-1/scripts/probe/net_salt_sweep.lua
			local SALT = "36bc48de-ccc6-4666-af4b-7d3bd46d6aa7"
			-- Сам Net в Studio подставляет нулевой GUID вместо пустого game.JobId.
			local STUDIO_JOB_ID = "00000000-0000-0000-0000-000000000000"

			local PREFIX: { [string]: string } = {
				RemoteEvent = "RE/",
				RemoteFunction = "RF/",
				UnreliableRemoteEvent = "URE/",
			}

			local SEPARATOR = string.byte("/")
			local HASH_LEN = 64

			local M = {}

			local state = {
				folder = nil :: Instance?,
				job_id = nil :: string?,
				-- байты JobId, они же ключ Виженера
				key = nil :: any,
				-- logical -> посчитанный хеш (без префикса)
				hashes = {} :: { [string]: string },
				-- logical .. class -> найденный инстанс
				cache = {} :: { [string]: Instance },
				-- nil = ещё не сверяли (приманок не видно), true/false = результат сверки
				verified = nil :: boolean?,
			}

			-- Диагностику печатаем один раз на логическое имя: резолв ретраится, а
			-- дублировать одну и ту же строку каждые 30 с смысла нет.
			local diag_done = {}

			local function net_folder(): Instance?
				local cached = state.folder
				if cached and cached.Parent then
					return cached
				end
				local packages = HaramService("ReplicatedStorage"):FindFirstChild("Packages")
				state.folder = packages and packages:FindFirstChild("Net") or nil
				return state.folder
			end

			-- Ключ Виженера. Смена JobId (телепорт на другой сервер) обнуляет всё
			-- посчитанное: имена завязаны на JobId и на новом сервере другие.
			local function job_key()
				local job_id = if RunService:IsStudio() then STUDIO_JOB_ID else game.JobId
				if job_id == nil or job_id == "" then
					job_id = STUDIO_JOB_ID
				end

				if state.job_id ~= job_id then
					state.job_id = job_id
					state.key = table.pack(string.byte(job_id, 1, -1))
					table.clear(state.hashes)
					table.clear(state.cache)
					state.verified = nil
				end

				return job_id, state.key
			end

			local function hash_of(logical: string): string
				local cached = state.hashes[logical]
				if cached then
					return cached
				end

				local job_id, key = job_key()
				local key_count = key.n
				local out = table.create(#logical)
				local key_index = 1

				for i = 1, #logical do
					local byte = string.byte(logical, i)
					if byte == SEPARATOR then
						out[i] = "/" -- разделитель проходит как есть, ключ не сдвигается
					else
						out[i] = string.char((byte - 32 + key[key_index]) % 95 + 32)
						key_index = key_index % key_count + 1
					end
				end

				local digest = sha256(buffer.fromstring(table.concat(out) .. SALT .. job_id))
				state.hashes[logical] = digest
				return digest
			end

			local function is_hashed_body(body: string?): boolean
				return body ~= nil and #body == HASH_LEN and string.match(body, "^%x+$") ~= nil
			end

			-- Одноразовая сверка схемы. Берём первую попавшуюся приманку (плоское имя),
			-- считаем по формуле её хешированного близнеца и проверяем, что он есть.
			-- Приманку при этом не трогаем — только читаем её имя.
			local function verify_scheme(folder: Instance)
				if state.verified ~= nil then
					return
				end

				for _, child in folder:GetChildren() do
					local prefix, body = string.match(child.Name, "^(%a+/)(.+)$")
					if prefix and not is_hashed_body(body) then
						state.verified = folder:FindFirstChild(prefix .. hash_of(body)) ~= nil
						if state.verified then
							logging.debug("NetSafe", "схема имён сходится на " .. child.Name)
						else
							logging.warn(
								"NetSafe",
								"схема имён НЕ сходится на "
									.. child.Name
									.. " — игра сменила соль, порядок склейки или сдвиг; "
									.. "перепроверь формулу по dumps/obfuscated/Net.clean.luau"
							)
						end
						return
					end
				end
				-- Ни одной приманки не видно: Packages.Net ещё не долил детей. Оставляем
				-- verified = nil, сверимся на следующем резолве.
			end

			local function resolve(logical: string, class: string): (Instance?, string?)
				if type(logical) ~= "string" or logical == "" then
					return nil, "пустое имя"
				end

				local prefix = PREFIX[class]
				if not prefix then
					return nil, "неизвестный класс " .. tostring(class)
				end

				local cache_key = logical .. "\0" .. class
				local hit = state.cache[cache_key]
				if hit and hit.Parent then
					return hit, "cache"
				end
				state.cache[cache_key] = nil

                -- Use the same verified resolver as tool activation and the hub.
                local env = type(getgenv) == "function" and getgenv() or _G
                local actions = env.HaramActions or _G.HaramActions
                if actions and actions.game == game and actions.workspace == workspace and env.HaramLoaderNetReady then
                    local ok, remote = pcall(actions.Remote, prefix, logical)
                    if ok and typeof(remote) == "Instance" and remote.Parent and remote.ClassName == class then
                        state.cache[cache_key] = remote
                        return remote, "shared-loader"
                    end
                    return nil, "shared resolver: " .. logical .. " missing"
                end
				local folder = net_folder()
				if not folder then
					return nil, "ReplicatedStorage.Packages.Net не найден"
				end

				verify_scheme(folder)

				-- FindFirstChild, а не WaitForChild: резолв обязан быть неблокирующим, а
				-- ремоут может ещё не дореплицироваться. Промах не кешируется — вызывающий
				-- ретраит.
				local name = prefix .. hash_of(logical)
				local inst = folder:FindFirstChild(name)
				if not inst then
					return nil, "нет ребёнка " .. name
				end
				if inst.ClassName ~= class then
					return nil,
						string.format("%s оказался %s, ожидался %s", name, inst.ClassName, class)
				end

				state.cache[cache_key] = inst
				return inst, "hash"
			end

			-- Как читать при промахе:
			--   children=0            -> Packages.Net пуст, дерево ещё не доехало
			--   hashed=0 children>0   -> доехали только приманки, рабочих ещё нет
			--   verified=false        -> формула протухла, чинить net_safe, а не вызов
			--   verified=nil          -> сверяться было не на чем (приманок не видно)
			local function diag_text(folder: Instance?): string
				local total, hashed = 0, 0
				if folder then
					for _, child in folder:GetChildren() do
						total += 1
						if is_hashed_body(string.match(child.Name, "^%a+/(.+)$")) then
							hashed += 1
						end
					end
				end
				return string.format(
					"job=%s children=%d hashed=%d verified=%s",
					tostring(state.job_id),
					total,
					hashed,
					tostring(state.verified)
				)
			end

			local function public(logical: string, class: string): Instance?
				local inst, why = resolve(logical, class)
				if inst then
					logging.debug("NetSafe", string.format("%s -> %s (%s)", logical, inst.Name, tostring(why)))
				elseif not diag_done[logical] then
					-- Один раз на логическое имя. В проде логгер молчит; чтобы увидеть эту
					-- строку в обфусцированной сборке, поставь getgenv()._ODY_FORCE_LOGS = true
					-- до загрузки.
					diag_done[logical] = true
					logging.warn(
						"NetSafe",
						string.format(
							"%s не разрешён: %s | %s",
							logical,
							tostring(why),
							diag_text(net_folder())
						)
					)
				end
				return inst
			end

			function M.RemoteEvent(logical: string): RemoteEvent?
				return public(logical, "RemoteEvent") :: any
			end

			function M.RemoteFunction(logical: string): RemoteFunction?
				return public(logical, "RemoteFunction") :: any
			end

			function M.UnreliableRemoteEvent(logical: string): UnreliableRemoteEvent?
				return public(logical, "UnreliableRemoteEvent") :: any
			end

			function M.clear_cache()
				table.clear(state.cache)
				table.clear(state.hashes)
				state.folder = nil
				state.verified = nil
			end

			function M.is_available(): boolean
				return net_folder() ~= nil
			end

			-- Совместимость со старым API: install/uninstall/backend больше не нужны,
			-- резолв работает без хуков. Заглушки оставлены, чтобы вызывающий код,
			-- написанный под хуковую версию, не падал.
			function M.install(): boolean
				return true
			end

			function M.uninstall()
				M.clear_cache()
			end

			function M.is_installed(): boolean
				return true
			end

			function M.backend(): string
				return "hash"
			end

			-- Colon-style aliases for drop-in feel
			M.get_remote_event = M.RemoteEvent
			M.get_remote_function = M.RemoteFunction

			return M
		end

		-- Source: @src/libs/logging
		module_factories["@src/libs/logging"] = function()
			--!nonstrict
			--[[
    Logging Module
    Provides unified logging with timestamps and log levels
    Tracks script startup time via os.clock()
]]

			local logging = {}

			-- Log levels
			logging.levels = {
				DEBUG = 1,
				INFO = 2,
				WARN = 3,
				ERROR = 4,
				NONE = 5,
			}

			-- Private state
			local start_time = os.clock()
			local current_level = logging.levels.INFO
			local level_names = {
				[1] = "DEBUG",
				[2] = "INFO",
				[3] = "WARN",
				[4] = "ERROR",
			}

			-- Get elapsed time since script start
			function logging.get_elapsed()
				return os.clock() - start_time
			end

			-- Format elapsed time
			local function format_time(elapsed)
				return string.format("[%.3fs]", elapsed)
			end

			-- Set log level
			function logging.set_level(level: string | number)
				if type(level) == "string" then
					level = logging.levels[level:upper()] or logging.levels.INFO
				end
				current_level = level
			end

			-- Get current log level
			function logging.get_level()
				return current_level
			end

			-- Get log level name
			function logging.get_level_name()
				return level_names[current_level] or "UNKNOWN"
			end

			-- Core logging function
			local function log(level, prefix, ...)
				if level < current_level then
					return
				end

				local elapsed = logging.get_elapsed()
				local time_str = format_time(elapsed)
				local level_name = level_names[level] or "LOG"

				local args = { ... }
				local message_parts = {}

				for i, v in ipairs(args) do
					if type(v) == "table" then
						table.insert(message_parts, tostring(v))
					else
						table.insert(message_parts, tostring(v))
					end
				end

				local message = table.concat(message_parts, " ")
				local full_prefix = prefix and string.format("[%s]", prefix) or ""
				local output = string.format("%s [%s]%s %s", time_str, level_name, full_prefix, message)

				if level >= logging.levels.WARN then
					warn(output)
				else
					print(output)
				end
			end

			-- Log methods with optional prefix
			function logging.debug(prefix_or_msg, ...)
				if select("#", ...) == 0 then
					log(logging.levels.DEBUG, nil, prefix_or_msg)
				else
					log(logging.levels.DEBUG, prefix_or_msg, ...)
				end
			end

			function logging.info(prefix_or_msg, ...)
				if select("#", ...) == 0 then
					log(logging.levels.INFO, nil, prefix_or_msg)
				else
					log(logging.levels.INFO, prefix_or_msg, ...)
				end
			end

			function logging.warn(prefix_or_msg, ...)
				if select("#", ...) == 0 then
					log(logging.levels.WARN, nil, prefix_or_msg)
				else
					log(logging.levels.WARN, prefix_or_msg, ...)
				end
			end

			function logging.error(prefix_or_msg, ...)
				if select("#", ...) == 0 then
					log(logging.levels.ERROR, nil, prefix_or_msg)
				else
					log(logging.levels.ERROR, prefix_or_msg, ...)
				end
			end

			-- Timer utility for tracking operation durations
			function logging.start_timer(operation_name)
				return {
					name = operation_name,
					start = os.clock(),
				}
			end

			function logging.end_timer(timer, level: number?)
				level = level or logging.levels.INFO
				local elapsed = os.clock() - timer.start
				local total_elapsed = logging.get_elapsed()

				if level >= current_level then
					local output = string.format(
						"[%.3fs] [%s] %s completed in %.3fs",
						total_elapsed,
						level_names[level] or "INFO",
						timer.name,
						elapsed
					)

					if level >= logging.levels.WARN then
						warn(output)
					else
						print(output)
					end
				end

				return elapsed
			end

			-- Scoped timer that logs on completion
			function logging.timed(operation_name, func, level: number?)
				level = level or logging.levels.INFO
				local timer = logging.start_timer(operation_name)
				local success, result = pcall(func)
				local elapsed = logging.end_timer(timer, level)

				if not success then
					logging.error("Timer", operation_name .. " failed: " .. tostring(result))
					error(result)
				end

				return result, elapsed
			end

			-- Reset start time (useful for testing)
			function logging.reset_start_time()
				start_time = os.clock()
			end

			-- Get start time
			function logging.get_start_time()
				return start_time
			end

			return logging
		end

		-- Source: @src/libs/sha256
		module_factories["@src/libs/sha256"] = function()
			--[=[
	Cryptography library: SHA256

	Sizes:
		Digest: 32 bytes
	
        Return type: string
        Example usage:
            local Message = buffer.fromstring("Hello World")
            local hash, digest = SHA256(Message)
--]=]

			--!strict
			--!optimize 2
			--!native
			-- Macro wrappers are private to this export.

			local CONSTANTS = buffer.create(256)
			do -- CONSTANTS = k
				local RoundConstants = {
					0x428a2f98,
					0x71374491,
					0xb5c0fbcf,
					0xe9b5dba5,
					0x3956c25b,
					0x59f111f1,
					0x923f82a4,
					0xab1c5ed5,
					0xd807aa98,
					0x12835b01,
					0x243185be,
					0x550c7dc3,
					0x72be5d74,
					0x80deb1fe,
					0x9bdc06a7,
					0xc19bf174,
					0xe49b69c1,
					0xefbe4786,
					0x0fc19dc6,
					0x240ca1cc,
					0x2de92c6f,
					0x4a7484aa,
					0x5cb0a9dc,
					0x76f988da,
					0x983e5152,
					0xa831c66d,
					0xb00327c8,
					0xbf597fc7,
					0xc6e00bf3,
					0xd5a79147,
					0x06ca6351,
					0x14292967,
					0x27b70a85,
					0x2e1b2138,
					0x4d2c6dfc,
					0x53380d13,
					0x650a7354,
					0x766a0abb,
					0x81c2c92e,
					0x92722c85,
					0xa2bfe8a1,
					0xa81a664b,
					0xc24b8b70,
					0xc76c51a3,
					0xd192e819,
					0xd6990624,
					0xf40e3585,
					0x106aa070,
					0x19a4c116,
					0x1e376c08,
					0x2748774c,
					0x34b0bcb5,
					0x391c0cb3,
					0x4ed8aa4a,
					0x5b9cca4f,
					0x682e6ff3,
					0x748f82ee,
					0x78a5636f,
					0x84c87814,
					0x8cc70208,
					0x90befffa,
					0xa4506ceb,
					0xbef9a3f7,
					0xc67178f2,
				}

				for Index, Constant in ipairs(RoundConstants) do
					local BufferOffset = (Index - 1) * 4
					buffer.writeu32(CONSTANTS, BufferOffset, Constant)
				end
			end

			local PreProcess = LPH_JIT_MAX(function(Contents: buffer)
				local ContentLength = buffer.len(Contents)
				local Padding = -(ContentLength + 9) % 64

				local NewContentLength = ContentLength + 1 + Padding + 8
				local NewContent = buffer.create(NewContentLength)
				buffer.copy(NewContent, 0, Contents)
				buffer.writeu8(NewContent, ContentLength, 128)
				local Length8 = ContentLength * 8
				for Index = 7, 0, -1 do
					local Remainder = Length8 % 256
					buffer.writeu8(NewContent, Index + ContentLength + 1 + Padding, Remainder)
					Length8 = (Length8 - Remainder) / 256
				end

				return NewContent, NewContentLength
			end)

			local OFFSETS = buffer.create(256)
			local DigestBlocks = LPH_JIT_MAX(function(Blocks: buffer, Length: number)
				local A, B, C, D = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
				local E, F, G, H = 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19

				local Offsets = OFFSETS
				local Constants = CONSTANTS

				for Offset = 0, Length - 1, 64 do
					for BlockIndex = 0, 60, 4 do
						buffer.writeu32(
							Offsets,
							BlockIndex,
							bit32.byteswap(buffer.readu32(Blocks, Offset + BlockIndex))
						)
					end

					for Index = 64, 252, 4 do
						local Sub15 = buffer.readu32(Offsets, Index - 60)
						local S0 = bit32.bxor(bit32.rrotate(Sub15, 7), bit32.rrotate(Sub15, 18), bit32.rshift(Sub15, 3))

						local Sub2 = buffer.readu32(Offsets, Index - 8)
						local S1 = bit32.bxor(bit32.rrotate(Sub2, 17), bit32.rrotate(Sub2, 19), bit32.rshift(Sub2, 10))

						local Sub7, Sub16 = buffer.readu32(Offsets, Index - 28), buffer.readu32(Offsets, Index - 64)
						buffer.writeu32(Offsets, Index, (Sub16 + S0 + Sub7 + S1))
					end

					local OldA, OldB, OldC, OldD, OldE, OldF, OldG, OldH = A, B, C, D, E, F, G, H

					for BufferIndex = 0, 252, 4 do
						local S1 = bit32.bxor(bit32.rrotate(E, 6), bit32.rrotate(E, 11), bit32.rrotate(E, 25))
						local Ch = bit32.bxor(bit32.band(E, F), bit32.band(bit32.bnot(E), G))
						local Temp1 = H
							+ S1
							+ Ch
							+ buffer.readu32(Constants, BufferIndex)
							+ buffer.readu32(Offsets, BufferIndex)
						H, G, F, E, D = G, F, E, D + Temp1, C

						local S0 = bit32.bxor(bit32.rrotate(A, 2), bit32.rrotate(A, 13), bit32.rrotate(A, 22))
						local Maj = bit32.bxor(bit32.band(A, B), bit32.band(A, C), bit32.band(B, C))
						C, B, A = B, A, Temp1 + S0 + Maj
					end

					A, B, C, D, E, F, G, H =
						bit32.bor(A + OldA, 0),
						bit32.bor(B + OldB, 0),
						bit32.bor(C + OldC, 0),
						bit32.bor(D + OldD, 0),
						bit32.bor(E + OldE, 0),
						bit32.bor(F + OldF, 0),
						bit32.bor(G + OldG, 0),
						bit32.bor(H + OldH, 0) :: number
				end

				return A, B, C, D, E, F, G, H
			end)

			local SHA256 = LPH_JIT_MAX(function(Message: buffer)
				local ProcessedMessage, Length = PreProcess(Message)
				local A, B, C, D, E, F, G, H = DigestBlocks(ProcessedMessage, Length)

				local Digest = buffer.create(32)

				buffer.writeu32(Digest, 0, A)
				buffer.writeu32(Digest, 4, B)
				buffer.writeu32(Digest, 8, C)
				buffer.writeu32(Digest, 12, D)
				buffer.writeu32(Digest, 16, E)
				buffer.writeu32(Digest, 20, F)
				buffer.writeu32(Digest, 24, G)
				buffer.writeu32(Digest, 28, H)

				return string.format("%08x%08x%08x%08x%08x%08x%08x%08x", A, B, C, D, E, F, G, H), Digest
			end)

			return SHA256
		end

		-- Source: @src/libs/profiler
		module_factories["@src/libs/profiler"] = function()
			--!nonstrict
			local Profiler = {}
			Profiler.__index = Profiler

			function Profiler.new(name)
				local self = setmetatable({}, Profiler)

				self.name = name or "Unknown"
				self.start_time = 0

				self.execution_time = {
					last = 0,
					average = 0,
					minimum = math.huge,
					maximum = 0,
				}

				self.next_average_update_time = 0
				self.absolute_time = 0
				self.sample_count = 0

				return self
			end

			function Profiler:start()
				self.start_time = os.clock()
			end

			function Profiler:finish(log_results)
				local current_time = os.clock()

				-- Вычисляем время выполнения в миллисекундах
				self.execution_time.last = (current_time - self.start_time) * 1000

				-- Обновляем среднее значение каждые 5 секунд
				if self.next_average_update_time <= current_time then
					self.next_average_update_time = current_time + 5

					if self.sample_count > 0 then
						self.execution_time.average = self.absolute_time / self.sample_count
					end

					self.absolute_time = 0
					self.sample_count = 0
				end

				self.absolute_time = self.absolute_time + self.execution_time.last
				self.sample_count = self.sample_count + 1

				-- Обновляем минимум и максимум
				if self.execution_time.last < self.execution_time.minimum then
					self.execution_time.minimum = self.execution_time.last
				end

				if self.execution_time.last > self.execution_time.maximum then
					self.execution_time.maximum = self.execution_time.last
				end

				if log_results then
					self:log_results()
				end
			end

			function Profiler:log_results()
				local avg = self.execution_time.average
				local min = self.execution_time.minimum
				local max = self.execution_time.maximum
				local cur = self.execution_time.last

				-- Форматируем минимум (может быть math.huge если ещё не было измерений)
				local min_str = (min == math.huge) and "N/A" or string.format("%.4f", min)

				print(
					string.format(
						"[Profiler] %s execution time | Avg: %.4f ms | Min: %s ms | Max: %.4f ms | Current: %.4f ms",
						self.name,
						avg,
						min_str,
						max,
						cur
					)
				)
			end

			function Profiler:reset()
				self.execution_time = {
					last = 0,
					average = 0,
					minimum = math.huge,
					maximum = 0,
				}

				self.next_average_update_time = 0
				self.absolute_time = 0
				self.sample_count = 0
			end

			function Profiler:get_stats()
				return {
					name = self.name,
					last = self.execution_time.last,
					average = self.execution_time.average,
					minimum = self.execution_time.minimum,
					maximum = self.execution_time.maximum,
					samples = self.sample_count,
				}
			end

			return Profiler
		end

		-- Source: @src/utils/generation
		module_factories["@src/utils/generation"] = function()
			--!nonstrict
			--[[
    Доход брейнрота в секунду без вызова кода игры.

    Формула — копия Shared.Animals:GetGeneration
    (game/ReplicatedStorage/Shared/Animals.luau). Саму функцию не зовём:
      * её RelateChannels обходит getfenv по стеку в поисках writefile и шлёт
        "LTO" + ZWNBSP в InventoryService/Sort;
      * с игроком в 4-м аргументе она зовёт Shared.Game:GetPlayerCashMultiplayer,
        а тот — игровой Synchronizer:Get со своей RelateChannels.

    generation.get(index, mutation, traits, multiplier?) -> number
        multiplier — множитель игрока (get_cash_multiplier), по умолчанию 1.

    generation.get_cash_multiplier(player?) -> number
        Нижняя граница Shared.Game:GetPlayerCashMultiplayer: ребирт, VIP,
        2x Money, бусты 2xMoney, друзья онлайн. Бонус за собранный индекс
        (Shared.Index:GetMultipliers, +0.5 за каждый) не считается — его логика
        завязана на FFlags и лимитированные индексы, переносить её хрупко.
        Поэтому реальный доход может быть выше, но не ниже.
]]

			local Players = HaramService("Players")

			local game_deps = bundle_require("@src/utils/game_deps")

			local generation = {}

			local SLEEPY_TRAIT = "Sleepy"
			local VIP_BONUS = 0.5
			local DOUBLE_MONEY_BONUS = 2
			local BOOST_BONUS = 2

			function generation.get(index, mutation, traits, multiplier)
				local info = game_deps.AnimalsData[index]
				if type(info) ~= "table" then
					return 0
				end

				local base = info.Generation
				if type(base) ~= "number" then
					base = (tonumber(info.Price) or 0) * game_deps.GameData.Game.AnimalGanerationModifier
				end

				local modifier = 1
				if mutation then
					local mutation_info = game_deps.MutationsData[mutation]
					modifier += mutation_info and mutation_info.Modifier or 0
				end

				local sleepy = false
				if type(traits) == "table" then
					for _, trait in traits do
						local trait_info = game_deps.TraitsData[trait]
						if not trait_info then
							continue
						end
						if trait == SLEEPY_TRAIT then
							sleepy = true
						else
							modifier += trait_info.MultiplierModifier
						end
					end
				end

				local value = base * modifier
				if sleepy then
					value *= 0.5
				end
				if multiplier then
					value *= multiplier
				end

				return math.round(value)
			end

			local function is_active_boost(expiration, now)
				return typeof(expiration) == "number" and expiration > 0 and now < expiration
			end

			function generation.get_cash_multiplier(player)
				player = player or Players.LocalPlayer

				local data = game_deps.Synchronizer:Get(player)
				if not data then
					return 1
				end

				local multiplier = 1

				local rebirth = data:Get("Rebirth")
				if type(rebirth) == "number" and rebirth > 0 then
					local rebirth_info = game_deps.RebirthData[rebirth]
					if rebirth_info then
						multiplier += rebirth_info.Rewards.Multiplier
					end
				end

				if data:Get("Gamepass.VIP") == true then
					multiplier += VIP_BONUS
				end

				if data:Get("Gamepass.2x Money") == true then
					multiplier += DOUBLE_MONEY_BONUS
				end

				local now = DateTime.now().UnixTimestamp
				if
					is_active_boost(data:Get("BoostExpiration.2xMoney"), now)
					or is_active_boost(data:Get("BoostExpiration.2xMoneyBoost"), now)
				then
					multiplier += BOOST_BONUS
				end

				-- Shared.Friends — чистый поиск по таблице, без Synchronizer и сканов стека.
				local ok, friends_bonus = pcall(game_deps.Friends.GetFriendBoostModifier, game_deps.Friends, player)
				if ok and type(friends_bonus) == "number" then
					multiplier += friends_bonus
				end

				return multiplier
			end

			return generation
		end

		-- Source: @src/utils/runway
		module_factories["@src/utils/runway"] = function()
            local game_utils = bundle_require("@src/utils/game")
            local OffsetFetcher -- Only load the scanner for the legacy remote fallback.
            local Workspace = game_utils.get_service("Workspace")
            local Players = game_utils.get_service("Players")
            local runway = {}
            local purchaseData, nextScan = nil, 0
            local lastResolveError
            local lastPromptAt = setmetatable({}, { __mode = "k" })

            local function validData(data)
                return type(data) == "table" and data.remote and data.remote.Parent
                    and type(data.keys) == "table" and type(data.keys[1]) == "string"
                    and type(data.keys[2]) == "string" and type(data.offset) == "number"
            end
            local function resolveData()
                if validData(purchaseData) then return purchaseData end
                purchaseData = nil
                if os.clock() < nextScan then return nil end
                nextScan = os.clock() + 2
                local ok, data = pcall(function()
                    OffsetFetcher = OffsetFetcher or bundle_require("@src/utils/offset_fetcher")
                    return OffsetFetcher.GetAnimalData()
                end)
                if ok and validData(data) then
                    purchaseData, lastResolveError = data, nil
                else
                    lastResolveError = ok and "Purchase parameters unavailable" or tostring(data)
                end
                return purchaseData
            end
            local function purchasePrompt(animal)
                if not animal then return nil end
                local matches, seen = {}, {}
                local function inspect(model)
                    if not model or not model.Parent then return end
                    for _, prompt in ipairs(model:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and prompt.Enabled and not seen[prompt] then
                            seen[prompt] = true
                            local action = string.lower(tostring(prompt.ActionText or ""))
                            local name = string.lower(prompt.Name)
                            local buy = action:find("buy", 1, true) or action:find("purchase", 1, true)
                                or action:find("Купить", 1, true) or action:find("купить", 1, true)
                                or name == "buy" or name == "purchase"
                            if buy and name ~= "steal" and not action:find("steal", 1, true) then
                                matches[#matches + 1] = prompt
                            end
                        end
                    end
                end
                inspect(animal.rendered_instance)
                inspect(animal.instance)
                -- Never guess between different actions/prompts on a model.
                if #matches == 1 then return matches[1] end
                return nil
            end
            local function promptPosition(prompt)
                local parent = prompt.Parent
                if not parent then return nil end
                if parent:IsA("Attachment") then return parent.WorldPosition end
                if parent:IsA("BasePart") then return parent.Position end
                if parent:IsA("Model") then return parent:GetPivot().Position end
                return nil
            end
            function runway.is_ready()
                if type(fireproximityprompt) == "function" then return true, "purchase_prompt" end
                if resolveData() then return true, "resolved_purchase" end
                return false, (lastResolveError or "Purchase parameters unavailable")
                    .. "; fireproximityprompt is unavailable"
            end
            function runway.purchase_animal(animal, burstLimit)
                if type(fireproximityprompt) == "function" then
                    local prompt = purchasePrompt(animal)
                    if not prompt then return false, "waiting_purchase_prompt", true end
                    local character = Players.LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    local position = promptPosition(prompt)
                    if not root or not position then return false, "waiting_purchase_prompt", true end
                    if (root.Position - position).Magnitude > prompt.MaxActivationDistance then
                        return false, "waiting_prompt_range", true
                    end
                    local now = os.clock()
                    local cooldown = math.max(0.1, tonumber(prompt.HoldDuration) or 0)
                    local window = lastPromptAt[prompt]
                    if not window or now - window.at >= cooldown then
                        window = { at = now, count = 0 }
                        lastPromptAt[prompt] = window
                    end
                    if window.count >= math.clamp(math.floor(tonumber(burstLimit) or 1), 1, 8) then
                        return false, "waiting_purchase_cooldown", true
                    end
                    window.count = window.count + 1
                    local ok, err = pcall(fireproximityprompt, prompt)
                    if not ok then return false, "Purchase prompt: " .. tostring(err), false end
                    return true, "prompt_sent"
                end
                local data = resolveData()
                if not data then return false, lastResolveError or "Purchase parameters unavailable", false end
                local prompt = purchasePrompt(animal)
                local uid = prompt and prompt:GetAttribute("UID") or animal and (animal.uuid or animal.uid)
                if not uid then return false, "waiting_purchase_uid", true end
                local ok, err = pcall(function()
                    local serverTime = Workspace:GetServerTimeNow() + data.offset
                    data.remote:FireServer(serverTime, data.keys[1], uid)
                    data.remote:FireServer(serverTime, data.keys[2], uid)
                end)
                if not ok then return false, "Purchase request: " .. tostring(err), false end
                return true, "sent"
            end
            return runway
		end

		-- Source: @src/utils/offset_fetcher
		module_factories["@src/utils/offset_fetcher"] = function()
			--!nocheck
			--[[
    OffsetFetcher Module
    Dynamically resolves Remotes, Offsets, and Keys from game scripts.

    Settings:
        getgenv().ODS_DEBUG_MODE = true -- Enable verbose diagnostic logging
                                            (capability check, proto stats,
                                            decompile dumps, success/fail
                                            traces). Default: silent.
]]
			local game_utils = bundle_require("@src/utils/game")
			local game_deps = bundle_require("@src/utils/game_deps")
			local debug_mode = bundle_require("@src/libs/debug_mode")

			local ReplicatedStorage = game_utils.get_service("ReplicatedStorage")
			local NetSafe = game_deps.NetSafe

			-- Cache paths
			local Controllers = ReplicatedStorage:WaitForChild("Controllers")

			-- Target Scripts
			local AnimalController = Controllers:FindFirstChild("AnimalController")

			local OffsetFetcher = {}
			local Cache = {}

			-- // Logging //
			-- All diagnostic output is gated on debug_mode.enabled so the module
			-- runs silently and without string-building overhead in production. Set
			-- getgenv().ODS_DEBUG_MODE = true before requiring this module to re-enable
			-- verbose tracing.
			local function log(...)
				if debug_mode.enabled then
					print("[OffsetFetcher]", ...)
				end
			end

			local function diag(...)
				if debug_mode.enabled then
					warn("[OffsetFetcher][diag]", ...)
				end
			end

			local function safe_typeof(v)
				local ok, t = pcall(typeof, v)
				if ok then
					return t
				end
				return type(v)
			end

			-- Executor capability check — only emits diagnostics when debug mode is on,
			-- since the runtime cost is non-zero (multiple type() calls + table build).
			local function check_capabilities()
				if not debug_mode.enabled then
					return
				end

				local caps = {
					getscriptclosure = type(getscriptclosure) == "function",
					["debug.getprotos"] = type(debug) == "table" and type(debug.getprotos) == "function",
					["debug.getproto"] = type(debug) == "table" and type(debug.getproto) == "function",
					["debug.getconstants"] = type(debug) == "table" and type(debug.getconstants) == "function",
					["debug.getupvalues"] = type(debug) == "table" and type(debug.getupvalues) == "function",
					["debug.getupvalue"] = type(debug) == "table" and type(debug.getupvalue) == "function",
					["debug.info"] = type(debug) == "table" and type(debug.info) == "function",
					getgenv = type(getgenv) == "function",
				}

				local missing = {}
				for name, present in pairs(caps) do
					if not present then
						table.insert(missing, name)
					end
				end

				if #missing > 0 then
					diag("Executor missing required functions:", table.concat(missing, ", "))
				else
					diag("Executor capability check: OK")
				end

				diag(
					"Script instances:",
					"PlotClient=",
					PlotClient and PlotClient:GetFullName() or "nil",
					"| AnimalPrompt=",
					AnimalPrompt and AnimalPrompt:GetFullName() or "nil",
					"| AnimalController=",
					AnimalController and AnimalController:GetFullName() or "nil"
				)
			end

			check_capabilities()

			-- // Utils //
			local function is_uuid(str)
				return type(str) == "string"
					and str:len() == 36
					and str:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$")
			end

			local function get_all_protos_flat(func)
				local results = {}
				local MAX_DEPTH = 10

				local function collect(f, depth)
					if depth > MAX_DEPTH then
						return
					end
					table.insert(results, f)

					local ok, protos = pcall(debug.getprotos, f)
					if not ok or not protos then
						return
					end

					for i = 1, #protos do
						local ok2, proto = pcall(debug.getproto, f, i)
						if ok2 and proto then
							collect(proto, depth + 1)
						end
					end
				end

				collect(func, 0)
				log("Proto traversal found", #results, "protos")
				return results
			end

			-- // Game Net Interaction //
			local function GetRemoteObject(uuid)
				local success, remote = pcall(function()
					if NetSafe and NetSafe.RemoteEvent then
						return NetSafe.RemoteEvent(uuid)
					end
					error("NetSafe not available")
				end)

				if not success then
					diag("GetRemoteObject: pcall errored for", uuid, "->", tostring(remote))
					return nil
				end

				if not remote then
					diag("GetRemoteObject: returned nil for", uuid)
					return nil
				end

				return remote
			end

			-- // Bytecode Scan Logic //
			-- Looks for the "all-in-one-proto" pattern: GetServerTimeNow + 2 UUID keys +
			-- a positive integer offset in the same proto, plus the remote UUID in
			-- the main closure constants. Works on most executors. On hardened ones (e.g.
			-- delta) numeric/UUID constants are stripped from bytecode and this scanner
			-- returns nil — ScanFromSource is then used as the fallback path.
			local function ScanForStandardPattern(scriptInstance, label)
				label = label or (scriptInstance and scriptInstance.Name) or "<unknown>"

				if not scriptInstance then
					diag("[", label, "] Script instance not found for scan.")
					return nil
				end

				if
					type(getscriptclosure) ~= "function"
					or type(debug) ~= "table"
					or type(debug.getconstants) ~= "function"
					or type(debug.getprotos) ~= "function"
					or type(debug.getproto) ~= "function"
				then
					diag("[", label, "] getscriptclosure unavailable on this executor")
					return nil
				end

				local ok_closure, mainClosure = pcall(getscriptclosure, scriptInstance)
				if not ok_closure then
					diag("[", label, "] getscriptclosure errored:", tostring(mainClosure))
					return nil
				end
				if type(mainClosure) ~= "function" then
					diag("[", label, "] getscriptclosure returned nil for", scriptInstance:GetFullName())
					return nil
				end

				local logicData = nil
				local allProtos = get_all_protos_flat(mainClosure)
				diag("[", label, "] proto traversal returned", #allProtos, "protos")

				-- Detailed accumulators are only built when debug mode is on. The hot path
				-- (find time + 2 UUID keys + positive integer) stays intact regardless.
				local DBG = debug_mode.enabled
				local proto_stats = DBG and { with_time = 0, with_keys = 0, with_nums = 0 } or nil
				local total_const_count, total_number_count = 0, 0
				local sample_numbers = DBG and {} or nil
				local sample_strings = DBG and {} or nil
				local sample_other_types = DBG and {} or nil

				if DBG and type(debug.getupvalues) == "function" then
					local ok_uv, upvalues = pcall(debug.getupvalues, mainClosure)
					if ok_uv and type(upvalues) == "table" then
						local uv_count, uv_numbers, uv_strings, uv_other = 0, {}, {}, {}
						for _, v in pairs(upvalues) do
							uv_count = uv_count + 1
							local vt = type(v)
							if vt == "number" then
								if #uv_numbers < 24 then
									table.insert(uv_numbers, v)
								end
							elseif vt == "string" then
								if #uv_strings < 16 and #v <= 60 then
									table.insert(uv_strings, v)
								end
							else
								if #uv_other < 8 then
									table.insert(uv_other, vt)
								end
							end
						end
						local nums_str = {}
						for _, n in ipairs(uv_numbers) do
							table.insert(nums_str, tostring(n))
						end
						diag(
							"[",
							label,
							"] main upvalues count=",
							uv_count,
							"| numbers=",
							table.concat(nums_str, ","),
							"| strings=",
							table.concat(uv_strings, " | "),
							"| other_types=",
							table.concat(uv_other, ",")
						)
					end
				end

				for proto_idx, func in ipairs(allProtos) do
					local ok_consts, consts = pcall(debug.getconstants, func)
					if not ok_consts or not consts then
						continue
					end

					local time, keys, nums = false, {}, {}
					local proto_const_count = 0
					local proto_all_const_dump = DBG and {} or nil

					for _, c in pairs(consts) do
						proto_const_count = proto_const_count + 1
						total_const_count = total_const_count + 1
						local ct = type(c)

						if ct == "number" then
							total_number_count = total_number_count + 1
							if DBG and #sample_numbers < 20 then
								table.insert(sample_numbers, c)
							end
						elseif ct == "string" then
							if DBG and #sample_strings < 12 and #c <= 40 then
								table.insert(sample_strings, c)
							end
						else
							if DBG and #sample_other_types < 6 then
								table.insert(sample_other_types, ct)
							end
						end

						if DBG and #proto_all_const_dump < 60 then
							local repr
							if ct == "string" then
								repr = '"' .. (#c > 50 and (c:sub(1, 50) .. "...") or c) .. '"'
							elseif ct == "number" then
								repr = tostring(c)
							else
								repr = "<" .. ct .. ">"
							end
							table.insert(proto_all_const_dump, repr)
						end

						if c == "GetServerTimeNow" then
							time = true
						end
						if is_uuid(c) then
							table.insert(keys, c)
						end
						-- Any positive integer: the proto is already narrowed down to
						-- GetServerTimeNow + two UUID keys. The offset is not guaranteed to
						-- be large -- PlotClient's FinishSteal has used +16 since 2026-08-30,
						-- which the old >20 cut-off silently dropped.
						if ct == "number" and c >= 1 and c % 1 == 0 then
							table.insert(nums, c)
						end
					end

					if DBG then
						if time then
							proto_stats.with_time = proto_stats.with_time + 1
						end
						if #keys >= 2 then
							proto_stats.with_keys = proto_stats.with_keys + 1
						end
						if #nums > 0 then
							proto_stats.with_nums = proto_stats.with_nums + 1
						end

						if time or #keys >= 2 then
							diag(
								"[",
								label,
								"] proto#",
								proto_idx,
								"consts=",
								proto_const_count,
								"time=",
								tostring(time),
								"uuid_keys=",
								#keys,
								"nums(int>=1)=",
								#nums
							)
							diag(
								"[",
								label,
								"] proto#",
								proto_idx,
								"ALL CONSTS:",
								table.concat(proto_all_const_dump, " ")
							)
						end
					end

					if time and #keys >= 2 and #nums > 0 then
						table.sort(nums, function(a, b)
							return a > b
						end)
						logicData = { offset = nums[1], keys = { keys[1], keys[2] } }
						log("Found Logic Pattern in", scriptInstance.Name, "| Offset:", nums[1])
						break
					end
				end

				if not logicData then
					if DBG then
						diag(
							"[",
							label,
							"] Failed to find logic pattern. Stats:",
							"protos=",
							#allProtos,
							"total_consts=",
							total_const_count,
							"total_numbers=",
							total_number_count,
							"with_time=",
							proto_stats.with_time,
							"with_>=2_uuid_keys=",
							proto_stats.with_keys,
							"with_nums=",
							proto_stats.with_nums
						)

						if #sample_numbers > 0 then
							local s = {}
							for _, n in ipairs(sample_numbers) do
								table.insert(s, tostring(n))
							end
							diag("[", label, "] sample numbers:", table.concat(s, ","))
						end
						if #sample_strings > 0 then
							diag("[", label, "] sample strings:", table.concat(sample_strings, " | "))
						end
						if #sample_other_types > 0 then
							diag("[", label, "] sample non-num/non-str types:", table.concat(sample_other_types, ","))
						end
					end
					return nil
				end

				local remoteUUID = nil
				local ok_main_consts, mainConsts = pcall(debug.getconstants, mainClosure)
				if not ok_main_consts or not mainConsts then
					diag("[", label, "] debug.getconstants failed for main closure:", tostring(mainConsts))
					return nil
				end

				for _, c in pairs(mainConsts) do
					if is_uuid(c) then
						local is_key = false
						for _, k in pairs(logicData.keys) do
							if c == k then
								is_key = true
								break
							end
						end

						if not is_key then
							remoteUUID = c
							break
						end
					end
				end

				if not remoteUUID then
					diag("[", label, "] Failed to find Remote UUID")
					return nil
				end

				local remoteObj = GetRemoteObject(remoteUUID)
				if not remoteObj then
					diag("[", label, "] Failed to resolve Remote Object for UUID", remoteUUID)
					return nil
				end

				diag("[", label, "] OK | offset=", logicData.offset, "| remoteUUID=", remoteUUID)

				return {
					remote = remoteObj,
					offset = logicData.offset,
					keys = logicData.keys,
				}
			end

			-- // Source-based scan //
			-- Fallback for executors that strip integer constants and UUID strings from
			-- bytecode (notably delta). They expose decompile() as a runtime call that
			-- returns the live source of the script. We parse that source via Lua patterns
			-- to recover the same offset/keys/remote-uuid trio. Still fully dynamic —
			-- picks up game updates as long as the script's structure stays roughly the
			-- same.

			local UUID_PAT =
				"[%x][%x][%x][%x][%x][%x][%x][%x]%-[%x][%x][%x][%x]%-[%x][%x][%x][%x]%-[%x][%x][%x][%x]%-[%x][%x][%x][%x][%x][%x][%x][%x][%x][%x][%x][%x]"

			local function get_decompiled_source(scriptInstance, label)
				local fn = rawget(_G, "decompile") or decompile
				if type(fn) ~= "function" then
					diag("[", label, "] decompile unavailable on this executor")
					return nil
				end

				local ok, source = pcall(fn, scriptInstance)
				if not ok then
					diag("[", label, "] decompile errored:", tostring(source))
					return nil
				end
				if type(source) ~= "string" or #source < 32 then
					diag("[", label, "] decompile returned empty/short source")
					return nil
				end

				return source
			end

			local function collect_remote_vars(source)
				local vars = {}
				for var, uuid in
					string.gmatch(
						source,
						'local%s+([%w_]+)%s*=%s*[%w_]+:RemoteEvent%s*%(%s*"(' .. UUID_PAT .. ')"%s*%)'
					)
				do
					vars[var] = uuid
				end
				for var, uuid in
					string.gmatch(
						source,
						"local%s+([%w_]+)%s*=%s*[%w_]+:RemoteEvent%s*%(%s*'(" .. UUID_PAT .. ")'%s*%)"
					)
				do
					vars[var] = uuid
				end
				return vars
			end

			-- The game scripts hoist FireServer through one of two aliases:
			--   local <alias> = Instance.new("RemoteEvent").FireServer  (AnimalController, AnimalPrompt)
			--   local <alias> = <existing_remote_var>.FireServer        (PlotClient — decompiler binds to first remote)
			-- and then call:
			--   <alias>(<remoteVar>, workspace:GetServerTimeNow() + N, "<uuid_a>", ...)
			--   <remoteVar>:FireServer(workspace:GetServerTimeNow() + N, "<uuid_b>", ...)
			-- We collect both shapes and group by (remoteVar, offset).
			local function find_fire_pair(source)
				local fs_aliases = {}
				for var in
					string.gmatch(
						source,
						'local%s+([%w_]+)%s*=%s*Instance%.new%s*%(%s*"RemoteEvent"%s*%)%s*%.%s*FireServer'
					)
				do
					fs_aliases[var] = true
				end
				for var in string.gmatch(source, "local%s+([%w_]+)%s*=%s*[%w_]+%s*%.%s*FireServer[^%w_]") do
					fs_aliases[var] = true
				end

				local matches = {}

				-- Method-style. Use .- (lazy any) instead of [^)]- because GetServerTimeNow()'s
				-- own ')' breaks the not-closing-paren class.
				for var, offset, key in
					string.gmatch(
						source,
						'([%w_]+):FireServer%s*%(.-GetServerTimeNow%s*%(%s*%)%s*%+%s*(%-?%d+)%s*,%s*"('
							.. UUID_PAT
							.. ')"'
					)
				do
					table.insert(matches, { var = var, offset = tonumber(offset), key = key, kind = "method" })
				end

				-- Hoisted-style via FireServer alias.
				for alias in pairs(fs_aliases) do
					local alias_pat = alias:gsub("(%W)", "%%%1")
					for var, offset, key in
						string.gmatch(
							source,
							alias_pat
								.. '%s*%(%s*([%w_]+)%s*,.-GetServerTimeNow%s*%(%s*%)%s*%+%s*(%-?%d+)%s*,%s*"('
								.. UUID_PAT
								.. ')"'
						)
					do
						table.insert(matches, { var = var, offset = tonumber(offset), key = key, kind = "hoisted" })
					end
				end

				-- Generic literal-FireServer hoisted form.
				for var, offset, key in
					string.gmatch(
						source,
						'[^%w_]FireServer%s*%(%s*([%w_]+)%s*,.-GetServerTimeNow%s*%(%s*%)%s*%+%s*(%-?%d+)%s*,%s*"('
							.. UUID_PAT
							.. ')"'
					)
				do
					table.insert(matches, { var = var, offset = tonumber(offset), key = key, kind = "hoisted_literal" })
				end

				local groups = {}
				for _, m in ipairs(matches) do
					local k = m.var .. "|" .. tostring(m.offset)
					groups[k] = groups[k] or { var = m.var, offset = m.offset, keys = {} }
					local g = groups[k]
					if m.kind == "method" then
						g.keys[2] = m.key
					else
						g.keys[1] = m.key
					end
				end

				for _, g in pairs(groups) do
					if g.keys[1] and g.keys[2] and g.keys[1] ~= g.keys[2] then
						return g
					end
				end

				return nil
			end

			local function ScanFromSource(scriptInstance, label)
				label = label or (scriptInstance and scriptInstance.Name) or "<unknown>"

				if not scriptInstance then
					diag("[", label, "] source-scan: script instance missing")
					return nil
				end

				local source = get_decompiled_source(scriptInstance, label)
				if not source then
					return nil
				end

				diag("[", label, "] source-scan: decompiled source length=", #source)

				local pair = find_fire_pair(source)
				if not pair then
					diag("[", label, "] source-scan: no FireServer pair matching the steal pattern")

					if debug_mode.enabled then
						local dumped = 0
						for start_idx in string.gmatch(source, "()FireServer") do
							if dumped >= 6 then
								break
							end
							local from = math.max(1, start_idx - 60)
							local to = math.min(#source, start_idx + 240)
							local snippet = source:sub(from, to):gsub("[\r\n]+", " | "):gsub("%s+", " ")
							diag("[", label, "] FireServer ctx#", dumped + 1, ":", snippet)
							dumped = dumped + 1
						end

						if dumped == 0 then
							diag("[", label, "] no FireServer substring at all in decompiled source")
							local head = source:sub(1, 400):gsub("[\r\n]+", " | ")
							diag("[", label, "] source head:", head)
						end
					end

					return nil
				end

				local vars = collect_remote_vars(source)
				local remoteUUID = vars[pair.var]
				if not remoteUUID then
					diag("[", label, "] source-scan: remote var", pair.var, "has no Net:RemoteEvent declaration")
					return nil
				end

				local remoteObj = GetRemoteObject(remoteUUID)
				if not remoteObj then
					diag("[", label, "] source-scan: failed to resolve Remote", remoteUUID)
					return nil
				end

				diag(
					"[",
					label,
					"] source-scan OK | offset=",
					pair.offset,
					"| remoteUUID=",
					remoteUUID,
					"| var=",
					pair.var
				)

				return {
					remote = remoteObj,
					offset = pair.offset,
					keys = { pair.keys[1], pair.keys[2] },
				}
			end

			-- // Public Methods //

			function OffsetFetcher.GetAnimalData()
				if Cache.AnimalData then
					return Cache.AnimalData
				end

				diag("GetAnimalData: starting scan")

				local data = ScanForStandardPattern(AnimalController, "AnimalData/AnimalController")

				if not data then
					diag("GetAnimalData: bytecode scan failed, trying source-scan")
					data = ScanFromSource(AnimalController, "AnimalData/AnimalController")
				end

				if data then
					log("AnimalData: OK")
				else
					diag("GetAnimalData: FAILED (both scanners)")
				end

				Cache.AnimalData = data
				return data
			end

			function OffsetFetcher.ClearCache()
				Cache = {}
				log("Cache cleared")
			end

			return OffsetFetcher
		end

		-- Source: @src/libs/debug_mode
		module_factories["@src/libs/debug_mode"] = function()
			return { enabled = false }
		end

		local auto_buy_runway = bundle_require("@src/standalone/auto_buy_runway_spam")

		-- Optional diagnostic helper. No executor brand is required or assumed.
		function auto_buy_runway.get_executor_info()
			if type(identifyexecutor) ~= "function" then
				return "unknown", nil
			end
			local ok, name, version = pcall(identifyexecutor)
			if not ok then
				return "unknown", nil
			end
			return name, version
		end

		-- Reuse the authoritative runway tracker and its Weld-linked visual model lookup.
		-- Reading candidates does not enable AutoBuy or send purchase requests.
		function auto_buy_runway.get_road_candidates()
			local api = bundle_require("@src/standalone/auto_buy_runway_spam")
			local tracker = bundle_require("@src/modules/shared/runway_tracker")
			local folder = Workspace:FindFirstChild("RenderedMovingAnimals")
			local result = {}
			if not folder then
				return result
			end
			for _, animal in pairs(api.get_animals()) do
				local a = animal
				api.get_animal_position(a)
				local model = a.rendered_instance
				if
					model
					and model.Parent
					and model:IsDescendantOf(folder)
					and not tracker.is_animal_following_us(a.uuid or a.uid)
				then
					result[#result + 1] = {
						uid = a.uuid or a.uid,
						name = a.display_name or a.name,
						index = a.index or (a.instance and a.instance:GetAttribute("Index")),
						mps = tonumber(a.gen_value) or 0,
						conveyor = true,
						model = model,
						animal = a,
						getPosition = function()
							local live = a.rendered_instance
							if
								not live
								or not live.Parent
								or not live:IsDescendantOf(folder)
								or tracker.is_animal_following_us(a.uuid or a.uid)
							then
								return nil
							end
							return api.get_animal_position(a)
						end,
					}
				end
			end
			-- Source-style fallback: visible walking models can exist before the
			-- invisible data-model Weld is linked or observed by the tracker.
			local deps = bundle_require("@src/utils/game_deps")
			local generation = bundle_require("@src/utils/generation")
			local names = {}
			for index, info in pairs(deps.AnimalsData) do
				if type(info) == "table" then
					names[tostring(index):lower():gsub("%s+", "")] = { index = index, info = info }
					names[tostring(info.DisplayName or index):lower():gsub("%s+", "")] = { index = index, info = info }
				end
			end
			local seen = {}
			for _, entry in ipairs(result) do
				if entry.model then
					seen[entry.model] = true
				end
			end
			for _, model in ipairs(folder:GetDescendants()) do
				if not model:IsA("Model") then
					continue
				end
				local found = names[model.Name:lower():gsub("%s+", "")]
				if not found or not model:FindFirstChildWhichIsA("Humanoid", true) then
					continue
				end
				local nested = false
				local ancestor = model.Parent
				while ancestor and ancestor ~= folder do
					if ancestor:IsA("Model") and names[ancestor.Name:lower():gsub("%s+", "")] then
						nested = true
						break
					end
					ancestor = ancestor.Parent
				end
				if nested or seen[model] then
					continue
				end
				local liveModel = model
				local function livePosition()
					if not liveModel.Parent or not liveModel:IsDescendantOf(folder) then
						return nil
					end
					local part = liveModel.PrimaryPart
						or liveModel:FindFirstChild("HumanoidRootPart", true)
						or liveModel:FindFirstChildWhichIsA("BasePart", true)
					return part and part.Position or nil
				end
				if not livePosition() then
					continue
				end
				local traits = {}
				local rawTraits = model:GetAttribute("Traits")
				if type(rawTraits) == "string" then
					local ok, parsed = pcall(HttpService.JSONDecode, HttpService, rawTraits)
					if ok and type(parsed) == "table" then
						traits = parsed
					end
				elseif type(rawTraits) == "table" then
					traits = rawTraits
				end
				local ok, mps = pcall(generation.get, found.index, model:GetAttribute("Mutation"), traits)
				if not ok or type(mps) ~= "number" then
					mps = tonumber(found.info.Generation) or 0
				end
				result[#result + 1] = {
					uid = "visual_" .. tostring(model),
					name = found.info.DisplayName or found.index,
					index = found.index,
					mps = mps,
					conveyor = true,
					model = model,
					getPosition = livePosition,
				}
				seen[model] = true
			end
			return result
		end

		return auto_buy_runway
	end
	local ok, result = pcall(buildRuntime)
	runwayRuntimeBuilding = false
	if not ok then
		error(result, 0)
	end
	runwayRuntime = result
	return runwayRuntime
end

-- Warm the purchase tracker without enabling movement or buying anything.
task.defer(function()
    local ok, api = pcall(createRunwayAutoBuy)
    if ok then pcall(function() api.get_animals() end) end
end)

-- BEGIN RUNWAY AUTO BUY TEST CONTROLLER
do
	local api, loading, wanted, lastError = nil, false, false, nil
	local requestedRoadTarget
	local listeners = {}
	local previousRoadHidden = nil
	local previousAutoTP = nil
	_G.HaramAutoBuyTPBlocked = false
	Config.AutoBuyEnabled = false
	_G.HaramAutoBuy = false
	Config.RunwayBuyDistance = math.clamp(tonumber(Config.RunwayBuyDistance) or 20, 0, 100)
	Config.RunwayBuyAttempts = math.clamp(math.floor(tonumber(Config.RunwayBuyAttempts) or 4), 1, 50)
    if Config.RunwayBuyAttempts == 1 then Config.RunwayBuyAttempts = 4 end
	Config.RunwayBuyFollow = Config.RunwayBuyFollow ~= false
	Config.RunwayBuyHover = math.clamp(tonumber(Config.RunwayBuyHover) or 9, 0, 20)
	Config.RunwayBuyMode = "nearest"

	local function running()
		return api ~= nil and api.is_enabled() == true
	end
	local function emit()
		Config.AutoBuyEnabled = running()
		_G.HaramAutoBuy = Config.AutoBuyEnabled
		for listener in pairs(listeners) do
			pcall(listener)
		end
	end
	local function applySettings()
		if not api then
			return
		end
		api.set_runway_purchase_distance(Config.RunwayBuyDistance)
		api.set_runway_spam_attempts(Config.RunwayBuyAttempts)
		api.set_target_mode(Config.RunwayBuyMode)
		api.set_follow_enabled(Config.RunwayBuyFollow)
		api.set_follow_height(Config.RunwayBuyHover)
	end
	local function showRoad()
		if _G.HaramApplyRoadVisibility then
			_G.HaramApplyRoadVisibility()
		end
	end
	local function restoreRoad()
		if _G.HaramApplyRoadVisibility then
			_G.HaramApplyRoadVisibility()
		end
	end
	local function blockTP()
		_G.HaramAutoBuyTPBlocked = true
		_G.HaramClickTPPending = nil
		if previousAutoTP == nil then
			previousAutoTP = _G.HaramAutoTP ~= false
		end
		_G.HaramTPStop = true
		_G.HaramTPStop = true
		if type(_G.HaramStopTeleport) == "function" then
			pcall(_G.HaramStopTeleport)
		end
		if type(_G.HaramSetAutoTP) == "function" then
			_G.HaramSetAutoTP(false)
		end
	end
	local function restoreTP()
		_G.HaramAutoBuyTPBlocked = false
		if previousAutoTP == nil then
			return
		end
		local value = previousAutoTP
		previousAutoTP = nil
		if _G.HaramSetAutoTP then
			pcall(_G.HaramSetAutoTP, value)
		end
	end
	local function fail(err)
		lastError = tostring(err):gsub("[\r\n]+", " ")
		wanted = false
		if api then
			pcall(api.set_enabled, false)
		end
		restoreRoad()
		restoreTP()
		warn("[Runway AutoBuy TEST] " .. lastError)
		emit()
	end
	local function setEnabled(value)
		wanted = value == nil and not wanted or value == true
		lastError = nil
		if not wanted then
			requestedRoadTarget = nil
			if api then
				pcall(api.set_enabled, false)
			end
			restoreRoad()
			restoreTP()
			emit()
			return
		end
		if running() then
			if requestedRoadTarget then
				api.set_exclusive_road_target(requestedRoadTarget)
				requestedRoadTarget = nil
			end
			emit()
			return
		end
		if _G.HaramPrepareMovementReset then
			pcall(_G.HaramPrepareMovementReset)
		end
		_G.HaramMovementFault = nil
		blockTP()
		if loading then
			emit()
			return
		end
		loading = true
		emit()
		task.spawn(function()
			local ok, err = pcall(function()
				if not api then
					api = createRunwayAutoBuy()
				end
				if not wanted then
					return
				end
				applySettings()
				if requestedRoadTarget then
					api.set_exclusive_road_target(requestedRoadTarget)
					requestedRoadTarget = nil
				end
                local ready, reason = api.is_ready()
                if not ready then
                    error(reason or "Purchase module is not ready", 0)
                end
				if not wanted then
					return
				end
				showRoad()
				api.set_enabled(true)
			end)
			loading = false
			if not ok then
				fail(err)
				return
			end
			emit()
		end)
	end
	local controls = {}
	_G.HaramBuySelectedRoadTarget = function(pet)
		requestedRoadTarget = pet
		setEnabled(true)
	end
	function controls.GetDiagnostics()
		if api and api.get_diagnostics then
			return api.get_diagnostics()
		end
		return { phase = "off", purchase_distance = Config.RunwayBuyDistance, sent = 0 }
	end
	function controls.GetState()
		if lastError then
			return "ERROR"
		end
		if wanted and loading then
			return "LOADING"
		end
		if wanted and controls.GetDiagnostics().last_error then
			return "ERROR"
		end
		return running() and "ON" or "OFF"
	end
	function controls.GetStatusText()
        local err = controls.GetLastError()
        if err then return "Error: " .. tostring(err) end
		if wanted and loading then
			return "Loading purchase module..."
		end
		if not running() then
			return "v2 | Ready, range " .. tostring(Config.RunwayBuyDistance)
		end
		local diag = controls.GetDiagnostics()
		if diag.phase == "sending" then
			return tostring(diag.target or "Target") .. " | Requests: " .. tostring(diag.sent or 0)
		end
		if diag.phase == "following" or diag.phase == "following_owned" then
			return "Following: " .. tostring(diag.target or "brainrot")
		end
		local messages = {
            waiting_purchase_prompt = "Waiting for this animal's Buy prompt",
            waiting_prompt_range = "Waiting for Buy prompt range",
            waiting_purchase_cooldown = "Waiting between purchase requests",
            waiting_purchase_uid = "Waiting for animal identifier",
			paused_obstacle = "Obstacle: follow released",
			paused_stuck = "Stuck: follow released",
			paused_root_locked = "Root locked: follow released",
			paused_target_far = "Target moved too far",
			paused_ragdoll = "Paused during ragdoll",
			recovering_ragdoll = "Waiting for character recovery",
			paused_tp = "Finishing current teleport",
			paused_reset = "Waiting for reset",
			paused_carry = "Paused while carrying",
			paused_pickup = "Waiting for pickup to finish",
			no_character = "Waiting for character",
			no_animals = "No runway brainrots found",
			no_position = "Target position unavailable",
			starting = "Waiting for runway scan",
		}
		if diag.phase == "no_nearby_target" or diag.phase == "out_of_range" then
			local distance = tonumber(diag.distance) or tonumber(diag.nearest_distance)
			if distance then
				return string.format("Nearest: %.0f / %.0f studs", distance, Config.RunwayBuyDistance)
			end
			return "No target in purchase range"
		end
		return messages[diag.phase] or "Waiting for runway target"
	end
	function controls.GetLastError()
        return lastError or (wanted and controls.GetDiagnostics().last_error or nil)
	end
	function controls.IsEnabled()
		return running()
	end
	function controls.SetEnabled(value)
		setEnabled(value)
	end
	function controls.SetDistance(value)
		Config.RunwayBuyDistance = math.clamp(tonumber(value) or 20, 0, 100)
		applySettings()
		pcall(SaveConfig)
		emit()
		return Config.RunwayBuyDistance
	end
	function controls.SetAttempts(value)
		Config.RunwayBuyAttempts = math.clamp(math.floor(tonumber(value) or 1), 1, 50)
		applySettings()
		pcall(SaveConfig)
		emit()
		return Config.RunwayBuyAttempts
	end
	function controls.SetMode(value)
		Config.RunwayBuyMode = "nearest"
		applySettings()
		pcall(SaveConfig)
		emit()
	end
	function controls.SetFollow(value)
		Config.RunwayBuyFollow = value == true
		if api then
			api.set_follow_enabled(Config.RunwayBuyFollow)
		end
		pcall(SaveConfig)
		emit()
	end
	function controls.SetHover(value)
		Config.RunwayBuyHover = math.clamp(tonumber(value) or 9, 0, 20)
		if api then
			api.set_follow_height(Config.RunwayBuyHover)
		end
		pcall(SaveConfig)
		emit()
		return Config.RunwayBuyHover
	end
	local monitoring = false
	function controls.Subscribe(callback)
		listeners[callback] = true
		pcall(callback)
		if not monitoring then
			monitoring = true
			task.spawn(function()
				while _G.HaramRunwayAutoBuyTest == controls and next(listeners) ~= nil do
					task.wait(0.3)
					local diag = controls.GetDiagnostics()
					if wanted and not loading and diag.phase == "target_completed" then
						setEnabled(false)
					elseif wanted and not loading and diag.last_error then
						fail(diag.last_error)
					else
						emit()
					end
				end
				monitoring = false
			end)
		end
		return function()
			listeners[callback] = nil
		end
	end
	_G.HaramRunwayAutoBuyTest = controls
	_G.HaramReleaseAutoBuyFollow = function()
		if api and api.suspend_follow then
			api.suspend_follow(0.75)
		end
	end
	_G.HaramSetAutoBuy = setEnabled
	_G.HaramToggleAutoBuy = function()
		setEnabled()
	end
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed or UserInputService:GetFocusedTextBox() or _G.Haram_KeybindListening then
			return
		end
		if
			input.UserInputType == Enum.UserInputType.Keyboard
			and input.KeyCode.Name == tostring(Config.AutoBuyKey or "K")
		then
			setEnabled()
		end
	end)
end
-- END RUNWAY AUTO BUY TEST CONTROLLER

-- Both road scanning and AutoBuy share one lazily initialized runtime.
_G.HaramGetRoadCandidates = function()
	return createRunwayAutoBuy().get_road_candidates()
end

_G.MiniHubSetPanelVis = function(name, on)
	Config.Visibilities[name] = on
	SaveConfig()
	if panels[name] then
		panels[name].Visible = on
	end
end

local CARPET_TICK, ANTI_RAG_TICK = 0.066, 0.066
local function elysiumFlashEquipped(char)
    if _G.HaramExtrasFlashPaused or (_G.HaramFlashBridge and _G.HaramFlashBridge.pending) then return true end
	if not char then
		return false
	end
	local ok, children = pcall(char.GetChildren, char)
	if not ok or type(children) ~= "table" then return false end
	for _, child in ipairs(children) do
		if child:IsA("Tool") and string.lower(child.Name):gsub("[^%w]", "") == "flashteleport" then
			return true
		end
	end
	return false
end

local antiRagdollConn
local _antiRagDescConns = {}
local function isRagdolled()
	local c = LocalPlayer.Character
	if not c then
		return false
	end
	local hum = c:FindFirstChildOfClass("Humanoid")
	if not hum then
		return false
	end
	local endTime = LocalPlayer:GetAttribute("RagdollEndTime")
	if endTime and (endTime - Workspace:GetServerTimeNow()) > 0 then
		_G.HaramRagdollObservedUntil = math.max(tonumber(_G.HaramRagdollObservedUntil) or 0, endTime)
	end
	local st = hum:GetState()
	if
		st == Enum.HumanoidStateType.Physics
		or st == Enum.HumanoidStateType.Ragdoll
		or st == Enum.HumanoidStateType.FallingDown
	then
		return true
	end
	return endTime and (endTime - Workspace:GetServerTimeNow()) > 0
end
local function stopAntiRagdoll()
	if antiRagdollConn then
		antiRagdollConn:Disconnect()
		antiRagdollConn = nil
	end
	if _antiRagDescConns then
		for _, c in ipairs(_antiRagDescConns) do
			pcall(function()
				c:Disconnect()
			end)
		end
		_antiRagDescConns = {}
	end
end
local function startAntiRagdoll(enabled)
	stopAntiRagdoll()
	if not enabled then
		return
	end
	_antiRagDescConns = {}
	local function _hardenHumanoid(hum)
		if elysiumFlashEquipped(hum.Parent) or _G.HaramFlashTeleportActive then
			return
		end
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		end)
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		end)
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
		end)
	end
	local function _fixRagdoll()
		if
			elysiumFlashEquipped(LocalPlayer.Character)
			or _G.HaramFlashTeleportActive
			or os.clock() < (tonumber(_G.HaramFlashTeleportSafeUntil) or 0)
		then
			return
		end
		local c = LocalPlayer.Character
		if not c then
			return
		end
		local hum, hrp = c:FindFirstChildOfClass("Humanoid"), c:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then
			return
		end
		if not isRagdolled() then
			return
		end
		pcall(function()
			LocalPlayer:SetAttribute("RagdollEndTime", Workspace:GetServerTimeNow())
		end)
		hum:ChangeState(Enum.HumanoidStateType.Running)
		hrp.AssemblyLinearVelocity = Vector3.zero
		if Workspace.CurrentCamera.CameraSubject ~= hum then
			Workspace.CurrentCamera.CameraSubject = hum
		end
		for _, obj in ipairs(c:GetDescendants()) do
			if obj:IsA("BallSocketConstraint") or obj.Name:find("RagdollAttachment") then
				pcall(function()
					obj:Destroy()
				end)
			end
		end
	end
	local function hookChar(c)
		if not c then
			return
		end
		local hum = c:FindFirstChildOfClass("Humanoid")
		if hum then
			_hardenHumanoid(hum)
		end
		_fixRagdoll()
		local conn = c.DescendantAdded:Connect(function(obj)
			if
				elysiumFlashEquipped(c)
				or _G.HaramFlashTeleportActive
				or os.clock() < (tonumber(_G.HaramFlashTeleportSafeUntil) or 0)
			then
				return
			end
			if obj:IsA("BallSocketConstraint") or obj.Name:find("RagdollAttachment") then
				task.defer(function()
					pcall(function()
						obj:Destroy()
					end)
					_fixRagdoll()
				end)
			end
		end)
		table.insert(_antiRagDescConns, conn)
		local flashConn = c.ChildAdded:Connect(function(obj)
			if obj:IsA("Tool") and string.lower(obj.Name):gsub("[^%w]", "") == "flashteleport" then
				_G.HaramFlashTeleportSafeUntil = os.clock() + 5
				local animate = c:FindFirstChild("Animate")
				if animate then
					animate.Disabled = false
				end
				local flashHum = c:FindFirstChildOfClass("Humanoid")
				if flashHum then
					pcall(function()
						flashHum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
					end)
					pcall(function()
						flashHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
					end)
					pcall(function()
						flashHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
					end)
				end
			end
		end)
		table.insert(_antiRagDescConns, flashConn)
	end
	hookChar(LocalPlayer.Character)
	table.insert(
		_antiRagDescConns,
		LocalPlayer.CharacterAdded:Connect(function(c)
			task.wait(0.1)
			hookChar(c)
		end)
	)
	local _antiRagLastTick = 0
	antiRagdollConn = RunService.Heartbeat:Connect(function()
		local now = os.clock()
		if now - _antiRagLastTick < 0.1 then
			return
		end
		_antiRagLastTick = now
		_fixRagdoll()
	end)
end
if Config.AntiRagdoll ~= false then
	pcall(startAntiRagdoll, true)
end
_G.isCloning = false
local function instantClone()
	if _G.isCloning then
		return
	end
	_G.isCloning = true
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local cloner = LocalPlayer.Backpack:FindFirstChild("Quantum Cloner")
			or character:FindFirstChild("Quantum Cloner")
		if cloner then
			if cloner.Parent ~= character then
				humanoid:EquipTool(cloner)
				task.wait()
			end
			cloner:Activate()
			task.wait(0.05)
			local tpButton = PlayerGui:FindFirstChild("ToolsFrames")
				and PlayerGui.ToolsFrames:FindFirstChild("QuantumCloner")
				and PlayerGui.ToolsFrames.QuantumCloner:FindFirstChild("TeleportToClone")
			if tpButton then
				tpButton.Visible = true
				if typeof(firesignal) == "function" then
					firesignal(tpButton.MouseButton1Up)
				else
					local inset = GuiService:GetGuiInset()
					local pos = tpButton.AbsolutePosition + tpButton.AbsoluteSize / 2 + inset
					VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
					task.wait()
					VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
				end
			end
		end
	end
	_G.isCloning = false
end
_G.HaramInstantClone = instantClone
local PS_PLACE_ID, PS_LINK_CODE, KICK_MSG = 109983668079237, "85781667033108162011177105658744", "\nBIR PRO"
local autoKickFired, autoKickConns = false, {}
local function extractPrivateServerCode(link)
	link = tostring(link or ""):match("^%s*(.-)%s*$")
	if link == "" then
		return nil
	end
	if not string.find(link, "://", 1, true) then
		return link
	end
	return link:match("[?&]privateServerLinkCode=([^&]+)")
		or link:match("[?&]linkCode=([^&]+)")
		or link:match("[?&]code=([^&]+)")
end
local function doAutoKick()
	if autoKickFired then
		return
	end
	autoKickFired = true
	local configuredLink = tostring(Config.PrivateServerLink or ""):match("^%s*(.-)%s*$")
	local configuredCode = extractPrivateServerCode(configuredLink)
	if configuredLink ~= "" and not configuredCode then
		-- -- ShowNotification("AUTO KICK", "Lien de serveur privé invalide")
		pcall(function()
			LocalPlayer:Kick(KICK_MSG)
		end)
		return
	end
	local targetCode = configuredCode or PS_LINK_CODE
	if
		not pcall(function()
			HaramService("ExperienceService"):LaunchExperience({ placeId = PS_PLACE_ID, linkCode = targetCode })
		end)
	then
		pcall(function()
			LocalPlayer:Kick(KICK_MSG)
		end)
	end
end
local function startAutoKick()
	for _, c in ipairs(autoKickConns) do
		pcall(function()
			c:Disconnect()
		end)
	end
	autoKickConns = {}
	table.insert(
		autoKickConns,
		PlayerGui.DescendantAdded:Connect(function(gui)
			if not Config.AutoKickEnabled or autoKickFired then
				return
			end
			local txt = (gui:IsA("TextLabel") or gui:IsA("TextButton")) and gui.Text
			if txt and string.find(txt, "You stole") then
				doAutoKick()
			end
		end)
	)
end
local function stopAutoKick()
	for _, c in ipairs(autoKickConns) do
		pcall(function()
			c:Disconnect()
		end)
	end
	autoKickConns = {}
end
_G.Haram_StartAutoKick = function()
	autoKickFired = false
	startAutoKick()
end
_G.Haram_StopAutoKick = stopAutoKick
if Config.AutoKickEnabled then
	task.spawn(function()
		pcall(_G.Haram_StartAutoKick)
	end)
end

_G.Haram_DoKick = function()
	task.spawn(function()
		pcall(function()
			game:Shutdown()
		end)
		pcall(function()
			LocalPlayer:Kick("")
		end)
	end)
end
_G.Haram_ModerationKick = function()
	task.spawn(function()
		pcall(function()
			LocalPlayer:Kick(KICK_MSG)
		end)
	end)
end

local function _posInsidePartsXZ(pos, parts, margin)
	margin = margin or 2
	for _, part in ipairs(parts) do
		if part:IsA("BasePart") then
			local cf = part.CFrame
			local size = part.Size

			local local3 = cf:PointToObjectSpace(pos)
			local hx = size.X / 2 + margin
			local hz = size.Z / 2 + margin
			if math.abs(local3.X) <= hx and math.abs(local3.Z) <= hz then
				return true
			end
		end
	end
	return false
end

do
	local lastJump = 0
	RunService.Heartbeat:Connect(function()
		if _G.HaramMovementLeaseActive or _G.HaramActiveMoveCancel then return end
		if Config.InfiniteJump ~= true then
			return
		end
		if not UIS:IsKeyDown(Enum.KeyCode.Space) then
			return
		end
		local now = tick()
		if now - lastJump < 0.033 then
			return
		end
		local c = LocalPlayer.Character
		if not c then
			return
		end
		local hrp, hum = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChild("Humanoid")
		if not hrp or not hum or hum.Health <= 0 then
			return
		end
		lastJump = now
		hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 55, hrp.AssemblyLinearVelocity.Z)
	end)
end

do
	local FACE_SPEED = 8
	local _ownerPlayer, _ownerPlot = nil, nil
	local _autoRotateSaved = nil

	local function _resolveOwner(o)
		if o == nil then
			return nil
		end
		if typeof(o) == "Instance" then
			if o:IsA("Player") then
				return o
			end
			return Players:FindFirstChild(tostring(o.Name or ""))
		end
		if type(o) == "table" then
			local n = rawget(o, "Name")
			if n then
				return Players:FindFirstChild(tostring(n))
			end
			local uid = rawget(o, "UserId")
			if uid then
				return Players:GetPlayerByUserId(uid)
			end
			return nil
		end
		if type(o) == "number" then
			return Players:GetPlayerByUserId(o)
		end
		if type(o) == "string" then
			return Players:FindFirstChild(o)
		end
		return nil
	end

	local function _ownerOfPlot(plotName)
		if not plotName then
			return nil
		end
		local ch = _G.Haram_GetPlotChannel and _G.Haram_GetPlotChannel(plotName)
		if not ch or not _G.Haram_ChannelGet then
			return nil
		end
		return _resolveOwner(_G.Haram_ChannelGet(ch, "Owner"))
	end

	local function _carrying()
		local st = _G.Haram_StealStatus
		if st and (st.carrying or st.hasPet) then
			return true
		end
		return LocalPlayer:GetAttribute("HasBrainrot") == true or LocalPlayer:GetAttribute("Stealing") == true
	end

	local function _restoreAutoRotate(hum)
		if _autoRotateSaved == nil then
			return
		end
		if hum then
			pcall(function()
				hum.AutoRotate = _autoRotateSaved
			end)
		end
		_autoRotateSaved = nil
	end

	RunService.Heartbeat:Connect(function(dt)
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		local st = _G.Haram_StealStatus
		local tgt = st and (st.visualTarget or st.target)
		if tgt and tgt.plot then
			_ownerPlot = tgt.plot
		end

		if
			_G.Haram_FollowOwner ~= true
			or not _carrying()
			or _G.HaramIsTeleporting
			or not hrp
			or not hum
			or hum.Health <= 0
		then
			if not _carrying() then
				_ownerPlayer, _ownerPlot = nil, nil
			end
			_restoreAutoRotate(hum)
			return
		end

		if not _ownerPlayer or not _ownerPlayer.Parent then
			_ownerPlayer = _ownerOfPlot(_ownerPlot)
		end
		local oc = _ownerPlayer and _ownerPlayer.Character
		local ohrp = oc and oc:FindFirstChild("HumanoidRootPart")
		if not ohrp then
			_restoreAutoRotate(hum)
			return
		end

		if _autoRotateSaved == nil then
			_autoRotateSaved = hum.AutoRotate
			pcall(function()
				hum.AutoRotate = false
			end)
		end

		local flat = Vector3.new(ohrp.Position.X - hrp.Position.X, 0, ohrp.Position.Z - hrp.Position.Z)
		if flat.Magnitude < 0.5 then
			return
		end

		local wanted = math.atan2(-flat.X, -flat.Z) + math.pi
		local _, cur = hrp.CFrame:ToEulerAnglesYXZ()
		local diff = (wanted - cur + math.pi) % (2 * math.pi) - math.pi
		local step = math.clamp(diff, -FACE_SPEED * dt, FACE_SPEED * dt)
		hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, cur + step, 0)
		hrp.AssemblyAngularVelocity = Vector3.zero
	end)
end

do
	_G.HaramAutoGrabRadius = tonumber(Config.AutoGrabRadius) or 95
	_G.HaramStealCommitRange = tonumber(Config.AutoGrabCommitRange) or 10
	_G.HaramStealEntryDelay = tonumber(Config.AutoGrabEntryDelay) or 0.30
	_G.HaramStealHoldMaxTotal = tonumber(Config.AutoGrabHoldMaxTotal) or 20
	_G.HaramStealUseFPP = Config.AutoGrabUseFPP ~= false

	local _adc, _addc, _adhbc
	local function _adHarden(hum)
		if _G.AntiDieDisabled ~= false or _G.Haram_IsResetting then
			return
		end
		pcall(function()
			hum.BreakJointsOnDeath = false
		end)
		pcall(function()
			hum.RequiresNeck = false
		end)
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		end)
	end
	local function _adRevive(hum)
		pcall(function()
			hum.Health = hum.MaxHealth
		end)
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end
	local function _adBind()
		if _G.AntiDieDisabled ~= false then
			local c = player.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			if h then
				h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			end
			return
		end
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum then
			return
		end
		_adHarden(hum)
		if _adc then
			pcall(function()
				_adc:Disconnect()
			end)
		end
		if _addc then
			pcall(function()
				_addc:Disconnect()
			end)
		end
		if _adhbc then
			pcall(function()
				_adhbc:Disconnect()
			end)
		end
		_adc = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if not _G.Haram_IsResetting and hum.Health <= 0 then
				_adRevive(hum)
			end
		end)
		_addc = hum.Died:Connect(function()
			if not _G.Haram_IsResetting then
				_adRevive(hum)
			end
		end)
		local _lh = 0
		_adhbc = RunService.Heartbeat:Connect(function()
			if not hum or not hum.Parent then
				return
			end
			if _G.Haram_IsResetting or _G.AntiDieDisabled ~= false then
				return
			end
			local now = os.clock()
			if now - _lh >= 0.5 then
				_lh = now
				_adHarden(hum)
			end
			if hum.Health <= 0 then
				_adRevive(hum)
			end
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Dead then
				pcall(function()
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
		end)
	end

	_G.Haram_AntiDieOff = function()
		if _adc then
			pcall(function()
				_adc:Disconnect()
			end)
			_adc = nil
		end
		if _addc then
			pcall(function()
				_addc:Disconnect()
			end)
			_addc = nil
		end
		if _adhbc then
			pcall(function()
				_adhbc:Disconnect()
			end)
			_adhbc = nil
		end
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum then
			return
		end
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		end)
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
		end)
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		end)
		pcall(function()
			hum.BreakJointsOnDeath = true
		end)
	end
	_G.Haram_AntiDieOn = _adBind

	-- Client-created display rig: never animate or reposition the replicated avatar.
	do
		local preview
		local previewSerial = 0
		local function cleanup()
			local old = preview
			preview = nil
			if not old then
				return
			end
			if old.connection then
				old.connection:Disconnect()
			end
			if old.renderName then
				RunService:UnbindFromRenderStep(old.renderName)
			end
			for _, track in ipairs(old.tracks) do
				pcall(function()
					track:Stop(0)
					track:Destroy()
				end)
			end
			if old.camera and old.camera.CameraSubject == old.root then
				old.camera.CameraSubject = old.subject
			end
			old.model:Destroy()
		end
		_G.HaramStopInvisLocalPreview = cleanup
		_G.HaramStartInvisLocalPreview = function(character, getRoot, isActive, hip)
			cleanup()
			local archivable = character.Archivable
			character.Archivable = true
			local ok, model = pcall(function()
				return character:Clone()
			end)
			character.Archivable = archivable
			if not ok or not model then
				return false
			end
			model.Name = "HaramLocalInvisPreview"
			model:SetAttribute("HaramLocalInvisVisual", true)
			local visualRoot = model:FindFirstChild("HumanoidRootPart")
			if not visualRoot then
				model:Destroy()
				return false
			end
			local animate = character:FindFirstChild("Animate")
			local function animationId(kind)
				if not animate then
					return nil
				end
				for _, object in ipairs(animate:GetDescendants()) do
					if
						object:IsA("Animation")
						and object.Parent
						and object.Parent.Name:lower() == kind
						and object.AnimationId ~= ""
					then
						return object.AnimationId
					end
				end
			end
			local walkId = animationId("walk") or animationId("run")
			local runId = animationId("run") or walkId
			local idleId = animationId("idle")
			for _, object in ipairs(model:GetDescendants()) do
				if
					object:IsA("LuaSourceContainer")
					or object:IsA("Humanoid")
					or object:IsA("Animator")
					or object:IsA("AnimationController")
					or object:IsA("Tool")
					or object:IsA("BillboardGui")
					or object:IsA("SurfaceGui")
					or object:IsA("Constraint")
				then
					object:Destroy()
				elseif object:IsA("BasePart") then
					object.CanCollide = false
					object.CanTouch = false
					object.CanQuery = false
					object.Massless = true
					object.LocalTransparencyModifier = 0
					-- This is a display, not a physics assembly. Every part is posed below.
					object.Anchored = true
				elseif object:IsA("JointInstance") or object:IsA("WeldConstraint") then
					-- Root swapping can leave a cloned joint pointing at the real root.
					for _, key in ipairs({ "Part0", "Part1" }) do
						local part = object[key]
						if part and not part:IsDescendantOf(model) then
							local replacement = model:FindFirstChild(part.Name, true)
							object[key] = replacement and replacement:IsA("BasePart") and replacement or nil
						end
					end
					if object:IsA("Motor6D") then
						object.Transform = CFrame.new()
					end
					if not object.Part0 or not object.Part1 then
						object:Destroy()
					end
				end
			end
			-- Animation loading requires the display rig to already be in the scene.
			local camera = Workspace.CurrentCamera
			if not camera then
				model:Destroy()
				return false
			end
			for _, old in ipairs(camera:GetChildren()) do
				if old.Name == "HaramLocalInvisPreview" and old:GetAttribute("HaramLocalInvisVisual") == true then
					old:Destroy()
				end
			end
			model.PrimaryPart = visualRoot
			model.Parent = camera
			local controller = Instance.new("AnimationController", model)
			local animator = Instance.new("Animator", controller)
			local tracks = {}
			local function load(id, priority)
				if not id then
					return nil
				end
				local animation = Instance.new("Animation")
				animation.AnimationId = id
				local loaded, track = pcall(function()
					return animator:LoadAnimation(animation)
				end)
				animation:Destroy()
				if not loaded then
					return nil
				end
				track.Looped = true
				track.Priority = priority
				tracks[#tracks + 1] = track
				return track
			end
			local walking = load(walkId, Enum.AnimationPriority.Movement)
			local runningTrack = runId ~= walkId and load(runId, Enum.AnimationPriority.Movement) or walking
			local idle = load(idleId, Enum.AnimationPriority.Idle)
			local limbs = {}
			for _, joint in ipairs(model:GetDescendants()) do
				if
					joint:IsA("Motor6D")
					and (joint.Name:lower():find("hip", 1, true) or joint.Name:lower():find("shoulder", 1, true))
				then
					limbs[#limbs + 1] = joint
				end
			end
			local parts, joints, offsets = {}, {}, {}
			for _, object in ipairs(model:GetDescendants()) do
				if object:IsA("BasePart") then
					parts[#parts + 1] = object
					offsets[object] = visualRoot.CFrame:ToObjectSpace(object.CFrame)
				elseif object:IsA("JointInstance") or object:IsA("WeldConstraint") then
					if object.Part0 and object.Part1 then
						joints[#joints + 1] = {
							joint = object,
							a = object.Part0,
							b = object.Part1,
							weld = object:IsA("WeldConstraint"),
							offset = object.Part0.CFrame:ToObjectSpace(object.Part1.CFrame),
						}
					end
				end
			end
			local function pose(rootFrame)
				local frames = { [visualRoot] = rootFrame }
				-- Resolve joints in either direction; accessory handles use the same graph.
				for _ = 1, #parts do
					local changed = false
					for _, entry in ipairs(joints) do
						local relation = entry.offset
						if not entry.weld then
							local transform = entry.joint:IsA("Motor6D") and entry.joint.Transform or CFrame.new()
							relation = entry.joint.C0 * transform * entry.joint.C1:Inverse()
						end
						if frames[entry.a] and not frames[entry.b] then
							frames[entry.b] = frames[entry.a] * relation
							changed = true
						elseif frames[entry.b] and not frames[entry.a] then
							frames[entry.a] = frames[entry.b] * relation:Inverse()
							changed = true
						end
					end
					if not changed then
						break
					end
				end
				for _, part in ipairs(parts) do
					part.CFrame = frames[part] or rootFrame * offsets[part]
				end
			end
			preview =
				{ model = model, root = visualRoot, camera = camera, subject = camera.CameraSubject, tracks = tracks }
			local current = preview
			camera.CameraSubject = visualRoot
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = { character, model }
			params.RespectCanCollide = true
			local currentTrack, cycle = nil, 0
			local function update(dt)
				if preview ~= current then
					return
				end
				local root = getRoot()
				if not isActive() or LocalPlayer.Character ~= character or not root or not root.Parent then
					cleanup()
					return
				end
				local position = root.Position
				local ground = Workspace:Raycast(position + Vector3.new(0, 6, 0), Vector3.new(0, -18, 0), params)
				if ground and ground.Normal.Y > 0.5 then
					position =
						Vector3.new(position.X, ground.Position.Y + (hip or 2) + visualRoot.Size.Y / 2, position.Z)
				end
				local _, yaw = root.CFrame:ToEulerAnglesYXZ()
				local rootFrame = CFrame.new(position) * CFrame.Angles(0, yaw, 0)
				local speed = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude
				local moving = speed > 0.75
				local selected
				if moving then
					selected = (speed >= 16 and runningTrack or walking)
				else
					selected = idle
				end
				if selected ~= currentTrack then
					if currentTrack then
						currentTrack:Stop(0.15)
					end
					currentTrack = selected
					if currentTrack then
						currentTrack:Play(0.15)
					end
				end
				if selected and moving then
					selected:AdjustSpeed(math.clamp(speed / 16, 0.5, 2))
				end
				if not selected or selected.Length <= 0 then
					-- Discard the frozen invis animation pose while normal assets load.
					for _, entry in ipairs(joints) do
						if entry.joint:IsA("Motor6D") then
							entry.joint.Transform = CFrame.new()
						end
					end
					cycle += dt * math.clamp(speed, 0, 30) * 0.55
					for _, joint in ipairs(limbs) do
						local left = joint.Name:lower():find("left", 1, true) ~= nil
						local shoulder = joint.Name:lower():find("shoulder", 1, true) ~= nil
						local angle = moving and math.sin(cycle) * (left and 1 or -1) * (shoulder and -0.45 or 0.6) or 0
						joint.Transform = CFrame.Angles(angle, 0, 0)
					end
				end
				-- Keep the reference arms-forward pose over walk/idle animations.
				for _, joint in ipairs(limbs) do
					if joint.Name:lower():find("shoulder", 1, true) then
						local basis = joint.C0.Rotation
						joint.Transform = basis:Inverse() * CFrame.Angles(math.pi / 2, 0, 0) * basis
					end
				end
				pose(rootFrame)
				-- Camera transparency can reveal the real, frozen invis pose again.
				-- Override only its local rendering, after the camera has updated.
				for _, part in ipairs(character:GetDescendants()) do
					if part:IsA("BasePart") then
						part.LocalTransparencyModifier = 1
					end
				end
			end
			previewSerial += 1
			current.renderName = "HaramInvisPreview_" .. tostring(previewSerial)
			RunService:BindToRenderStep(current.renderName, Enum.RenderPriority.Last.Value + 10, update)
			return true
		end
	end

	-- Donor Invisible module, isolated from its original hub and menu.
	do
		Config.InvisAutoRotate = Config.InvisAutoRotate == true
		if Config.InvisRecoverLagback == nil then
			Config.InvisRecoverLagback = true
		end
		if Config.InvisAutoDelaySeconds == nil then
			Config.InvisAutoDelaySeconds = 0.1
		end
		local ownedConnections, ownedCleanup = {}, {}
		local core = {
			Services = setmetatable({}, {
				__index = function(t, key)
					local value = HaramService(key)
					rawset(t, key, value)
					return value
				end,
			}),
			LocalPlayer = LocalPlayer,
		}
		core.GetHui = function()
			return type(gethui) == "function" and gethui() or HaramService("CoreGui")
		end
		core.Clean = function(value)
			ownedCleanup[#ownedCleanup + 1] = value
			return value
		end
		core.Connect = function(signal, callback)
			local connection = signal:Connect(callback)
			ownedConnections[#ownedConnections + 1] = connection
			return connection
		end
		core.Menu = {
			Notify = function(_, message)
				warn("[Haram Invis] " .. tostring(message))
			end,
		}
		local options = {}
		local optionKeys = {
			Depth = "SinkSliderValue",
			Rotation = "InvisStealAngle",
			["Auto on steal"] = "AutoInvisDuringSteal",
			["Auto rotate"] = "InvisAutoRotate",
			["Recover lagback"] = "InvisRecoverLagback",
		}
		local donorController
		local function publish(enabled)
			_G.HaramInvisActive = enabled
			_G.HaramInvisActive = enabled
			_G.invisibleStealEnabled = enabled
			_G.HaramInvisStatus = enabled and "active" or "stopped"
			if _G.Haram_InvisButtonSync then
				pcall(_G.Haram_InvisButtonSync, enabled)
			end
		end
		local function option(spec, toggle)
			local key = assert(optionKeys[spec.Name], "Unknown donor option")
			if Config[key] == nil then
				Config[key] = toggle and spec.Default == true or spec.Default
			end
			local control = {}
			setmetatable(control, {
				__index = function(_, property)
					if property == "Value" then
						return tonumber(Config[key]) or spec.Default
					end
					if property == "Enabled" then
						return Config[key] == true
					end
				end,
			})
			function control:SetValue(value)
				Config[key] = math.clamp(tonumber(value) or spec.Default, spec.Min, spec.Max)
				if _G.HaramInvisDepthSync then
					_G.HaramInvisDepthSync()
				end
			end
			function control:Toggle(value)
				Config[key] = value == true
				pcall(SaveConfig)
			end
			options[spec.Name] = control
			return control
		end
		local uiAdapter = { Categories = { Blatant = {} } }
		function uiAdapter.Categories.Blatant:CreateModule(spec)
			local control = { Enabled = false }
			function control:Toggle(value)
                self.ToggleRevision = (self.ToggleRevision or 0) + 1
				value = value == true
				if self.Enabled == value then
					return
				end
				self.Enabled = value
                self.TransitionCount = (self.TransitionCount or 0) + 1
				local ok, err = pcall(spec.Function, value)
                self.TransitionCount = math.max(0, self.TransitionCount - 1)
				if not ok then
					self.Enabled = false
					publish(false)
					warn("[Haram Invis] " .. tostring(err))
					return
				end
				if value and self.IsActive and not self.IsActive() then
					self.Enabled = false
				end
				publish(self.Enabled)
			end
			function control:CreateSlider(spec)
				return option(spec, false)
			end
			function control:CreateToggle(spec)
				return option(spec, true)
			end
			donorController = control
			return control
		end
		local function buildDonor()
			local aa = core
			local ab = uiAdapter
			local ac = setmetatable({}, {
				__index = function(_, key)
					if key == "Busy" then
						return _G.HaramDropFlingActive == true or _G.HaramDropFlingActive == true
					end
				end,
			})
			local ad = math.min
			local ae = math.max
			local af = math.clamp
			local ag = math.floor
			local ah = math.deg
			local ai = math.rad
			local aj = math.asin
			local ak = math.huge
			local al = aa.Services.RunService
			local am = aa.Services.UserInputService
			local an = aa.LocalPlayer
			local ao =
				[[http=52E4B792-A760-4861-A2F1-E8D025DA910F&12334BC0-59C9-4397-A418-E6F6B91918B3&DBBB80B3-B171-42AF-9183-2D7E986CB6DF&9D62FD73-2CD4-4432-AD1F-7B0621F60FDE&F57F8527-8E86-4A90-8F8C-A99C8D78C57C&824365C2-3AD4-40D7-B01C-560A55E94D53&id=99304685759272]]
			local ap = 0.8
			local aq
			local ar
			local as
			local at
			local au
			local av
			local aw = false
			local ax = -math.huge
			local ay
			local az
			local aA
			local aB
			local aC = false
			local aD = 0
			local aE
			local aF = {}
			local aG
			local aH
			local aI
			local aJ
			local aK
			local aL
			local aM
			local aN
			local aO = {}
			local aP = {}
			local aQ = {}
			local aR = {}
			local aS = 0
			local function Notify(aT, aU)
				aa.Menu.Notify("Invisible", aT, aU, 2.5)
			end
			local function ClearConns()
				for aT, aU in aF do
					aU:Disconnect()
				end
				table.clear(aF)
			end
			local function MeasureHeight(aT)
				local aU, aV = ak, -ak
				for aW, aX in aT:GetDescendants() do
					if aX:IsA("BasePart") and aX ~= ay then
						aU = ad(aU, aX.Position.Y - aX.Size.Y / 2)
						aV = ae(aV, aX.Position.Y + aX.Size.Y / 2)
					end
				end
				aD = ae(aV - aU, 0)
			end
			local function Angle()
				if not au.Enabled then
					return as.Value
				end
				local aT = ar.Value * 0.5
				if aD <= 0 or aD <= aT then
					return 180
				end
				return af(180 + ah(aj(1 - aT / aD)) + 15, 180, 270)
			end
			local function DropShadow()
				for aT, aU in aP do
					aU:Disconnect()
				end
				table.clear(aP)
				if aL then
					aL:Destroy()
				end
				aL, aM, aN = nil, nil, nil
				table.clear(aO)
				table.clear(aQ)
				table.clear(aR)
			end
			local function StopPose()
				DropShadow()
				if aK then
					aK:Disconnect()
					aK = nil
				end
				if aI then
					aI:Stop(0)
					aI:Destroy()
					aI = nil
				end
				if aH then
					aH:Destroy()
					aH = nil
				end
				aJ = nil
			end
			local function AntiDie(aT)
				aB = aT.BreakJointsOnDeath
				aC = true
				aT.BreakJointsOnDeath = false
				aT:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				aF[#aF + 1] = aT:GetPropertyChangedSignal("Health"):Connect(function()
					if aT.Health <= 0 then
						aT.Health = aT.MaxHealth
					end
				end)
			end
			local function RemoveDoubleRig(aT)
				local aU = aT:FindFirstChild("DoubleRig")
				if aU then
					aU:Destroy()
				end
				aF[#aF + 1] = aT.ChildAdded:Connect(function(aV)
					if aV.Name == "DoubleRig" then
						task.defer(aV.Destroy, aV)
					end
				end)
			end
			local function Swap(aT, aU)
				local aV = Instance.new("Model")
				aT.Parent = aV
				local aW, aX = pcall(aU)
				aT.Parent = workspace
				aV:Destroy()
				if not aW then
					warn("invisible swap failed:", aX)
				end
				return aW
			end
			local function Rebind(aT, aU, aV)
				if not aU then
					return
				end
				for aW, aX in aT:GetDescendants() do
					if aX:IsA("Motor6D") or aX:IsA("Weld") then
						if aX.Part0 == aU then
							aX.Part0 = aV
						end
						if aX.Part1 == aU then
							aX.Part1 = aV
						end
					elseif aX:IsA("Constraint") then
						local aY = aX.Attachment0
						local aZ = aX.Attachment1
						local a_ = if aY and aY.Parent == aU then aV:FindFirstChild(aY.Name) else nil
						local a0 = if aZ and aZ.Parent == aU then aV:FindFirstChild(aZ.Name) else nil
						if a_ and a_:IsA("Attachment") then
							aX.Attachment0 = a_
						end
						if a0 and a0:IsA("Attachment") then
							aX.Attachment1 = a0
						end
					end
				end
			end
			local function DoClone(aT, aU)
				local aV = (aT:FindFirstChild("HumanoidRootPart"))
				if not aV then
					return false
				end
				aA = aU.HipHeight
				az = aV
				local aW = aV.AssemblyLinearVelocity
				local aX = Swap(aT, function()
					local aX = aV:Clone()
					for aY, aZ in aX:GetDescendants() do
						if aZ:IsA("WeldConstraint") or aZ:IsA("JointInstance") then
							aZ:Destroy()
						end
					end
					aX.Parent = aT
					aV.Parent = workspace.CurrentCamera
					aX.CFrame = aV.CFrame
					aT.PrimaryPart = aX
					Rebind(aT, aV, aX)
					ay = aX
				end)
				if ay then
					ay.AssemblyLinearVelocity = aW
				end
				return aX and ay ~= nil and aV.Parent ~= nil
			end
			local function RevertClone()
				local aT = an.Character
				local aU, aV = az, ay
				az, ay = nil, nil
				if not aT then
					if aV then
						aV:Destroy()
					end
					return
				end
				if not aU or not aU.Parent then
					if aV then
						aV:Destroy()
						Notify("Lost the real root, respawn to fix", "Warning")
					end
					if aT.Parent ~= workspace then
						aT.Parent = workspace
					end
					return
				end
				local aW = if aV and aV.Parent then aV.CFrame else aU.CFrame
				local aX = if aV and aV.Parent then aV.AssemblyLinearVelocity else Vector3.zero
				Swap(aT, function()
					aU.Parent = aT
					aT.PrimaryPart = aU
					Rebind(aT, aV, aU)
					aU.CFrame = aW
					aU.CanCollide = true
				end)
				aU.AssemblyLinearVelocity = aX
				if aV then
					aV:Destroy()
				end
				local aY = aT:FindFirstChildOfClass("Humanoid")
				if aY then
					if aA then
						aY.HipHeight = aA
					end
					if aB ~= nil then
						aY.BreakJointsOnDeath = aB
					end
					if aC then
						aY:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
					end
				end
				aB, aC = nil, false
			end
			local function Hold(aT)
				if aT.Length > 0 then
					aT.TimePosition = ap
				end
				aT:Play(0, 1, 0)
				task.spawn(function()
					local aU = os.clock()
					while aT.Length <= 0 and os.clock() - aU < 5 do
						task.wait()
					end
					if aT == aI then
						aT.TimePosition = ap
						aT:AdjustSpeed(0)
					end
				end)
			end
			local function PlayPose(aT)
				local aU = aT:FindFirstChildOfClass("Animator")
				if not aU then
					return
				end
				if aJ ~= aU then
					StopPose()
					local aV = Instance.new("Animation")
					aV.AnimationId = ao
					local aW = aU:LoadAnimation(aV)
					aW.Priority = Enum.AnimationPriority.Action4
					aW.Looped = true
					aH, aI, aJ = aV, aW, aU
					aK = aW.Stopped:Connect(function()
						if aW == aI then
							Hold(aW)
						end
					end)
				end
				local aV = aI
				if not aV.IsPlaying then
					Hold(aV)
				end
			end
			local function Hide(aT)
				local aU, aV = az, aT.PrimaryPart
				if not aU or not aV then
					return
				end
				aU.CFrame = (aV.CFrame - Vector3.new(0, ar.Value * 0.5, 0)) * CFrame.Angles(ai(Angle()), 0, 0)
				aU.AssemblyLinearVelocity = aV.AssemblyLinearVelocity
				aU.CanCollide = false
			end
			local function BuildShadow(aT, aU)
				local aV = Instance.new("Model")
				local aW = {}
				local function PartFor(aX)
					local aY = aW[aX.Name]
					if aY then
						return aY
					end
					local aZ = Instance.new("Part")
					aZ.Name = aX.Name
					aZ.Size = aX.Size
					aZ.CFrame = aX.CFrame
					aZ.Transparency = 1
					aZ.CanCollide = false
					aZ.CanQuery = false
					aZ.CanTouch = false
					aZ.Massless = true
					aZ.Anchored = aX.Name == "HumanoidRootPart"
					aZ.Parent = aV
					aW[aX.Name] = aZ
					return aZ
				end
				local function AttachmentFor(aX)
					local aY = PartFor(aX.Parent)
					local aZ = aY:FindFirstChild(aX.Name)
					if aZ and aZ:IsA("Attachment") then
						return aZ
					end
					local a_ = Instance.new("Attachment")
					a_.Name = aX.Name
					a_.CFrame = aX.CFrame
					a_.Parent = aY
					return a_
				end
				for aX, aY in aT:GetDescendants() do
					local aZ
					if
						aY:IsA("AnimationConstraint")
						and aY.IsKinematic
						and aY.Attachment0
						and aY.Attachment1
						and aY.Attachment1.Parent
						and aY.Attachment1.Parent.Parent == aT
					then
						aZ = Instance.new("AnimationConstraint")
						aZ.Attachment0 = AttachmentFor(aY.Attachment0)
						aZ.Attachment1 = AttachmentFor(aY.Attachment1)
						aZ.IsKinematic = true
						aZ.Parent = aZ.Attachment1.Parent
					elseif aY:IsA("Motor6D") and aY.Part0 and aY.Part1 and aY.Part1.Parent == aT then
						aZ = Instance.new("Motor6D")
						aZ.Part0 = PartFor(aY.Part0)
						aZ.Part1 = PartFor(aY.Part1)
						aZ.C0, aZ.C1 = aY.C0, aY.C1
						aZ.Parent = aZ.Part1
					end
					if aZ then
						aZ.Name = aY.Name
						aO[#aO + 1] = { aY, aZ }
					end
				end
				local aX = Instance.new("AnimationController")
				aX.Parent = aV
				local aY = Instance.new("Animator")
				aY.Parent = aX
				aV.PrimaryPart = aW.HumanoidRootPart
				local aZ = Instance.new("WorldModel")
				aV.Parent = aZ
				aZ.Parent = aa.GetHui()
				aL, aM = aZ, aY
				aN = aU:FindFirstChildOfClass("Animator")
			end
			local function SyncShadow()
				local aT, aU = aM, aN
				if not aT or not aU then
					return
				end
				aS += 1
				for aV, aW in aU:GetPlayingAnimationTracks() do
					local aX = aW.Animation
					if aW == aI or not aX or aX.AnimationId == "" then
						continue
					end
					local aY = aQ[aW]
					if not aY then
						local aZ = Instance.new("Animation")
						aZ.AnimationId = aX.AnimationId
						local a_ = aT:LoadAnimation(aZ)
						aZ:Destroy()
						a_.Priority = aW.Priority
						a_.Looped = aW.Looped
						a_:Play(0, aW.WeightCurrent, aW.Speed)
						aQ[aW] = a_
						aY = a_
					end
					local aZ = aY
					aR[aW] = aS
					aZ:AdjustWeight(aW.WeightCurrent, 0)
					aZ:AdjustSpeed(aW.Speed)
					aZ.TimePosition = aW.TimePosition
				end
				for aV, aW in aQ do
					if aR[aV] ~= aS then
						aW:Stop(0)
						aW:Destroy()
						aQ[aV] = nil
						aR[aV] = nil
					end
				end
			end
			local function CopyShadow()
				for aT, aU in aO do
					aU[1].Transform = aU[2].Transform
				end
			end
			local function Recover(aT, aU)
				Notify("Lagback detected, following it", "Warning")
				aU.CFrame = aU.CFrame.Rotation + aT.Position + Vector3.new(0, ar.Value * 0.5, 0)
				aU.AssemblyLinearVelocity = Vector3.zero
				aT.AssemblyLinearVelocity = Vector3.zero
			end
			local function StartLoop()
				local aT = false
				aF[#aF + 1] = am.InputBegan:Connect(function(aU, aV)
					if not aV and aU.KeyCode == Enum.KeyCode.Space then
						aT = true
					end
				end)
				aF[#aF + 1] = am.InputEnded:Connect(function(aU)
					if aU.KeyCode == Enum.KeyCode.Space then
						aT = false
					end
				end)
				aF[#aF + 1] = al.Heartbeat:Connect(function()
					if not aT then
						return
					end
					local aU = an.Character
					local aV = aU and aU:FindFirstChildOfClass("Humanoid")
					local aW = aU and aU.PrimaryPart
					if aV and aW and aV.Health > 0 then
						local aX = aW.AssemblyLinearVelocity
						aW.AssemblyLinearVelocity = Vector3.new(aX.X, aV.JumpPower, aX.Z)
					end
				end)
				local aU = 5
				local aV = os.clock()
				aE = nil
				aF[#aF + 1] = al.PreSimulation:Connect(function()
					local aW = an.Character
					local aX = aW and aW:FindFirstChildOfClass("Humanoid")
					local aY = az
					local aZ = aW and aW.PrimaryPart
					if not aX or aX.Health <= 0 or not aY or not aZ then
						return
					end
					local a_ = os.clock()
					local a0 = a_ - aV
					aV = a_
					if aU > 0 then
						aU -= 1
						aE = nil
					elseif ac.Busy or a0 > 0.15 or a_ - ax < 1 then
						aE = nil
					elseif aE and av.Enabled then
						local a2 = 3 + aY.AssemblyLinearVelocity.Magnitude * a0 + 98.1 * a0 * a0
						if (aY.Position - aE).Magnitude > a2 then
							Recover(aY, aZ)
							aU = 5
						end
					end
					if ay then
						ay.CanCollide = false
					end
					local a2 = Angle()
					if au.Enabled then
						local a3 = ag(0.5 + a2)
						if as.Value ~= a3 then
							as:SetValue(a3)
						end
					end
					aY.CFrame = (aZ.CFrame - Vector3.new(0, ar.Value * 0.5, 0)) * CFrame.Angles(ai(a2), 0, 0)
					aY.AssemblyLinearVelocity = aZ.AssemblyLinearVelocity
					aY.CanCollide = false
					aE = aY.Position
				end)
			end
			function aG()
                if _G.HaramExtrasFlashPaused then return end
				if aw then
					return
				end
				local aT = an.Character
				local aU = aT and aT:FindFirstChildOfClass("Humanoid")
				if not aT or not aU or aU.Health <= 0 then
					return
				end
				aw = true
				ClearConns()
				AntiDie(aU)
				RemoveDoubleRig(aT)
				MeasureHeight(aT)
				if not DoClone(aT, aU) then
					aw = false
					ClearConns()
					RevertClone()
					return
				end
				Hide(aT)
				PlayPose(aU)
				StartLoop()
				task.wait(0.05)
				if not aw then
					return
				end
				if not aL or aN ~= aU:FindFirstChildOfClass("Animator") then
					DropShadow()
					BuildShadow(aT, aU)
					aP[#aP + 1] = al.PreAnimation:Connect(SyncShadow)
					aP[#aP + 1] = al.PreSimulation:Connect(CopyShadow)
				end
			end
			local function TurnOff()
				StopPose()
				local aT = aw or az ~= nil or ay ~= nil
				aw = false
				ClearConns()
				if not aT then
					return
				end
				RevertClone()
				local aU = an.Character
				if aU and aU.Parent ~= workspace then
					aU.Parent = workspace
				end
				for aV, aW in workspace.CurrentCamera:GetChildren() do
					if not (aW:IsA("BasePart") and aW.Name == "HumanoidRootPart") then
						continue
					end
					if aU and not aU:FindFirstChild("HumanoidRootPart") then
						aW.Parent = aU
						aU.PrimaryPart = aW
						aW.CanCollide = true
					else
						aW:Destroy()
					end
				end
				local aV = aU and aU:FindFirstChildOfClass("Humanoid")
				if aV then
					aV:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end
			aq = ab.Categories.Blatant:CreateModule({
				Name = "Invisible",
				Fresh = true,
				Tooltip = "Hides you from o⁠ther players",
				Function = function(aT)
					if aT then
						aG()
					else
						TurnOff()
					end
				end,
			})
			ar = aq:CreateSlider({ Name = "Depth", Min = 0.5, Max = 10, Default = 5, Step = 0.1 })
			as = aq:CreateSlider({ Name = "Rotation", Min = 180, Max = 360, Default = 180 })
			at = aq:CreateToggle({ Name = "Auto on steal", Tooltip = "Turns on while stealing" })
			au = aq:CreateToggle({ Name = "Auto rotate", Tooltip = "Picks the best tilt" })
			av = aq:CreateToggle({
				Tooltip = "Moves you to where a lagback put you and stays hidden",
				Default = true,
				Name = "Recover lagback",
			})
			aa.Connect(an.CharacterAdded, function()
				ClearConns()
				StopPose()
				for aT, aU in workspace.CurrentCamera:GetChildren() do
					if aU:IsA("BasePart") and aU.Name == "HumanoidRootPart" then
						aU:Destroy()
					end
				end
				if az then
					az:Destroy()
				end
				if ay then
					ay:Destroy()
				end
				az, ay, aw = nil, nil, false
				if aq.Enabled then
					aq:Toggle(false)
				end
			end)
			aa.Connect(an.CharacterRemoving, function(aT)
				if not (aw or az or ay) then
					return
				end
				StopPose()
				ClearConns()
				if az then
					az.Parent = aT
				end
				if ay then
					ay:Destroy()
				end
				az, ay, aw = nil, nil, false
			end)
			aa.Connect(an:GetAttributeChangedSignal("Stealing"), function()
				ax = os.clock()
				if not an:GetAttribute("Stealing") then
					if aq.Enabled then
						aq:Toggle(false)
					end
					return
				end
				if not at.Enabled or aq.Enabled then
					return
				end
				task.wait(math.clamp(tonumber(Config.InvisAutoDelaySeconds) or 0.1, 0, 3))
				-- Paused by a TP/flash: wait for it to end instead of failing silently.
				local pausedUntil = os.clock() + 20
				while (_G.HaramExtrasFlashPaused or _G.HaramMovementLeaseActive)
					and an:GetAttribute("Stealing") and os.clock() < pausedUntil do
					task.wait(0.1)
				end
				if at.Enabled and an:GetAttribute("Stealing") and not aq.Enabled then
					aq:Toggle(true)
				end
			end)
			aa.Clean(StopPose)
			aq.GetRealRoot = function()
				return az
			end
			aq.GetVisibleRoot = function()
				return ay
			end
			aq.IsActive = function()
				return aw
			end
			aq.RefreshShadow = function()
				if aw then
					DropShadow()
					local char = an.Character
					local hum = char and char:FindFirstChildOfClass("Humanoid")
					if char and hum then
						BuildShadow(char, hum)
						aP[#aP + 1] = al.PreAnimation:Connect(SyncShadow)
						aP[#aP + 1] = al.PreSimulation:Connect(CopyShadow)
					end
				end
			end
			return aq
		end
		local controller = buildDonor()
        -- The visible clone and the real root must not drive the same TP route.
        local movementLeases, movementEpoch = 0, 0
        local resumeInvis, movementCharacter = false, nil
        local function acquireMovement()
            if movementLeases == 0 and not _G.HaramMovementLeaseActive then
                movementCharacter = LocalPlayer.Character
                resumeInvis = controller.Enabled == true
            end
            movementLeases = movementLeases + 1
            movementEpoch = movementEpoch + 1
            _G.HaramMovementLeaseActive = true
            _G.HaramExtrasFlashPaused = true
            if controller.Enabled or controller.IsActive() then controller:Toggle(false) end
            local released = false
            return function()
                if released then return end
                released = true
                movementLeases = math.max(0, movementLeases - 1)
                if movementLeases > 0 then return end
                local epoch = movementEpoch
                _G.HaramFlashTeleportSafeUntil = os.clock() + 0.5
                task.delay(0.5, function()
                    if movementLeases > 0 or movementEpoch ~= epoch then return end
                    _G.HaramMovementLeaseActive = false
                    _G.HaramExtrasFlashPaused = false
                    -- A pickup during the TP sets Stealing while invis is paused:
                    -- auto-invis must start here, not only resume a prior state.
                    local shouldResume = resumeInvis
                        or (Config.AutoInvisDuringSteal == true and LocalPlayer:GetAttribute("Stealing") == true)
                    resumeInvis = false
                    if shouldResume and not controller.Enabled and LocalPlayer.Character == movementCharacter
                        and not _G.Haram_IsResetting then
                        controller:Toggle(true)
                    end
                end)
            end
        end
        _G.HaramExtrasAcquireMovement = acquireMovement
        _G.HaramExtrasAcquireFlash = acquireMovement
		function _G.HaramInvisDepthSync()
			Config.SinkSliderValue = math.clamp(tonumber(Config.SinkSliderValue) or 5, 0.5, 10)
			Config.InvisStealAngle = math.clamp(tonumber(Config.InvisStealAngle) or 180, 180, 360)
			_G.HaramInvisDepth = Config.SinkSliderValue
			_G.HaramInvisDepth = Config.SinkSliderValue
			_G.SinkSliderValue = Config.SinkSliderValue
			_G.HaramInvisAngle = Config.InvisStealAngle
			_G.HaramInvisAngle = Config.InvisStealAngle
			_G.InvisStealAngle = Config.InvisStealAngle
			_G.HaramInvisAuto = Config.AutoInvisDuringSteal == true
			_G.HaramInvisAuto = _G.HaramInvisAuto
			_G.AutoInvisDuringSteal = _G.HaramInvisAuto
		end
		_G.HaramInvisDepthSync()
		_G.HaramInvisStart = function()
			controller:Toggle(true)
			return controller.Enabled
		end
		_G.HaramInvisStop = function()
			controller:Toggle(false)
		end
		_G.HaramSetInvisManual = function(value)
			controller:Toggle(value == true)
			return controller.Enabled == (value == true)
		end
		_G.HaramPrepareMovementReset = function()
			if type(_G.HaramReleaseAutoBuyFollow) == "function" then
				pcall(_G.HaramReleaseAutoBuyFollow)
			end
			controller:Toggle(false)
		end
		_G.HaramInvisToggle = function()
			controller:Toggle(not controller.Enabled)
		end
		_G.toggleInvisibleSteal = _G.HaramInvisToggle
		_G.HaramDisableInvisibleSteal = _G.HaramInvisStop
		_G.HaramGetInvisRealRoot = controller.GetRealRoot
		_G.HaramGetInvisVisibleRoot = controller.GetVisibleRoot
		_G.HaramGetInvisPhysicalRoot = function(expected)
			if expected and expected ~= LocalPlayer.Character then
				return nil
			end
			return controller.GetRealRoot()
		end
		_G.Haram_SetInvisBtnSync = function(fn)
			_G.Haram_InvisButtonSync = fn
			if type(fn) == "function" then
				fn(controller.Enabled)
			end
		end
		_G._invIsEnabled = function()
			return controller.Enabled
		end
		_G.HaramInvisSync = function()
			_G.HaramInvisDepthSync()
		end
		if Config.AutoInvisDuringSteal and LocalPlayer:GetAttribute("Stealing") then
			task.defer(function()
				controller:Toggle(true)
			end)
		end
        local function waitUntilStanding(character, humanoid, revision, carrying)
            local stableSince
            while LocalPlayer.Character == character and humanoid.Health > 0
                and controller.ToggleRevision == revision do
                if _G.HaramExtrasFlashPaused or _G.HaramMovementLeaseActive
                    or _G.Haram_IsResetting or _G.__elysiumResetBusy
                    or (_G.HaramIsTeleporting and _G.HaramIsTeleporting())
                    or (carrying and LocalPlayer:GetAttribute("Stealing") ~= true) then
                    return false
                end
                local root = character:FindFirstChild("HumanoidRootPart")
                local state = humanoid:GetState()
                local upright = state == Enum.HumanoidStateType.Running
                    or state == Enum.HumanoidStateType.RunningNoPhysics
                local standing = root and not root.Anchored and not humanoid.PlatformStand
                    and not humanoid.Sit and upright
                    and humanoid.FloorMaterial ~= Enum.Material.Air
                    and root.CFrame.UpVector.Y > 0.9
                    and math.abs(root.AssemblyLinearVelocity.Y) < 3
                    and (tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) <= workspace:GetServerTimeNow()
                if standing then
                    stableSince = stableSince or os.clock()
                    if os.clock() - stableSince >= 0.2 then return true end
                else
                    stableSince = nil
                end
                RunService.Heartbeat:Wait()
            end
            return false
        end
        local nextInvisRestart, invisRestartBusy
        local function restartInvisIfDue(now)
            if invisRestartBusy then return end
            -- Start the interval only after the initial clone/animation setup finishes.
            if (controller.TransitionCount or 0) > 0 then
                nextInvisRestart = nil
                return
            end
            if not controller.Enabled then
                nextInvisRestart = nil
                return
            end
            if not controller.IsActive() then
                nextInvisRestart = nil
                return
            end
            if not nextInvisRestart then
                nextInvisRestart = now + 0.8
                return
            end
            if now < nextInvisRestart then return end
            if _G.HaramExtrasFlashPaused or _G.HaramMovementLeaseActive
                or _G.Haram_IsResetting or _G.__elysiumResetBusy
                or (_G.HaramIsTeleporting and _G.HaramIsTeleporting()) then return end
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not humanoid or humanoid.Health <= 0 or humanoid.PlatformStand
                or (tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0) > workspace:GetServerTimeNow() then return end
            invisRestartBusy = true
            nextInvisRestart = now + 0.8
            local ok, err = pcall(function()
                local carrying = LocalPlayer:GetAttribute("Stealing") == true
                controller:Toggle(false)
                local revision = controller.ToggleRevision
                _G.HaramInvisStatus = "waiting_standing"
                if waitUntilStanding(character, humanoid, revision, carrying) then
                    controller:Toggle(true)
                end
                if not controller.Enabled and controller.ToggleRevision == revision then
                    _G.HaramInvisStatus = "stopped"
                end
            end)
            nextInvisRestart = controller.Enabled and (os.clock() + 0.8) or nil
            invisRestartBusy = false
            if not ok then warn("[Haram Invis restart] " .. tostring(err)) end
        end
		core.Connect(RunService.Heartbeat, function()
			_G.HaramInvisAutoHeartbeat = os.clock()
			if _G.Haram_IsResetting or _G.__elysiumResetBusy then
				controller:Toggle(false)
                nextInvisRestart = nil
                return
			end
            restartInvisIfDue(os.clock())
		end)
	end

	pcall(_adBind)
	player.CharacterAdded:Connect(function(char)
		local hum = char:WaitForChild("Humanoid", 5)
		if hum then
			_adHarden(hum)
		end
		task.wait(0.1)
		_adBind()
	end)
end

do
	if getgenv and getgenv().__FTP_InputConn then
		pcall(function()
			getgenv().__FTP_InputConn:Disconnect()
		end)
	end
	if getgenv and getgenv().__FTP_ClickConn then
		pcall(function()
			getgenv().__FTP_ClickConn:Disconnect()
		end)
	end

	local function _key(name)
		local k = Config[name]
		if not k or k == "NONE" then
			return nil
		end
		local ok, code = pcall(function()
			return Enum.KeyCode[k]
		end)
		if ok then
			return code
		end
		return nil
	end

	-- Carpet Speed is initialized before both the keybind and the settings UI.
	-- This keeps both controls alive even if a later optional hub section errors.
	do
		local fixedItems = {
			"Flying Carpet",
			"Waverider",
			"Santa's Sleigh",
			"Witch's Broom",
			"Cupid's Wings",
		}
		local preferredItems = {}
		local carpetEnabled = false
		local carpetConnection = nil

		local function rebuildItemOrder(selected)
			table.clear(preferredItems)
			if type(selected) == "string" and selected ~= "" then
				table.insert(preferredItems, selected)
			end
			for _, name in ipairs(fixedItems) do
				if name ~= selected then
					table.insert(preferredItems, name)
				end
			end
		end

		local function setSelectedItem(name)
			if type(name) ~= "string" or name == "" then
				return
			end
			Config.CarpetTool = name
			rebuildItemOrder(name)
			pcall(SaveConfig)
			if _G.Haram_SyncCarpetToolBtn then
				pcall(_G.Haram_SyncCarpetToolBtn)
			end
		end

		local function cycleSelectedItem()
			local current = Config.CarpetTool or fixedItems[1]
			local index = 1
			for i, name in ipairs(fixedItems) do
				if name == current then
					index = i
					break
				end
			end
			local selected = fixedItems[(index % #fixedItems) + 1]
			setSelectedItem(selected)
			return selected
		end

		local function findAndEquipItem(character, humanoid)
			local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:FindFirstChildOfClass("Backpack")
			local starterGear = LocalPlayer:FindFirstChild("StarterGear")
			for _, name in ipairs(preferredItems) do
				local tool = character:FindFirstChild(name)
					or (backpack and backpack:FindFirstChild(name))
					or (starterGear and starterGear:FindFirstChild(name))
				if tool and tool:IsA("Tool") then
					if tool.Parent ~= character then
						pcall(function()
							humanoid:EquipTool(tool)
						end)
					end
					-- EquipTool can finish on the following frame. Returning the
					-- instance lets the next Heartbeat confirm it without losing state.
					return tool
				end
			end
			return nil
		end

		local function setCarpetEnabled(value)
			carpetEnabled = value == true
			Config.CarpetSpeedEnabled = carpetEnabled
			if carpetConnection then
				carpetConnection:Disconnect()
				carpetConnection = nil
			end
			if type(_G.HaramCarpetSpeedReset) == "function" then
				pcall(_G.HaramCarpetSpeedReset)
			end
			if _G.Haram_SyncCarpetBtn then
				pcall(_G.Haram_SyncCarpetBtn, carpetEnabled)
			end
			pcall(SaveConfig)
			if not carpetEnabled then
				return false
			end

			carpetConnection = RunService.Heartbeat:Connect(function()
				if _G.Haram_IsResetting or _G.HaramAutoBuyTPBlocked or (_G.HaramIsTeleporting and _G.HaramIsTeleporting()) then
					return
				end
				local character = LocalPlayer.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				local root = character and character:FindFirstChild("HumanoidRootPart")
				if not character or not humanoid or not root or humanoid.Health <= 0 then
					return
				end
				if LocalPlayer:GetAttribute("Stealing") then
					return
				end
				-- Same mover as the TP (gear engage + sweep + ramp) when the hub is loaded.
				if type(_G.HaramCarpetSpeedStep) == "function" then
					local ok, handled = pcall(_G.HaramCarpetSpeedStep, humanoid, root)
					if ok and handled then
						return
					end
				end

				local tool = findAndEquipItem(character, humanoid)
				if not tool then
					return
				end
				local direction = humanoid.MoveDirection
				local speed = tonumber(Config.CarpetSpeed) or 120
				local velocity = root.AssemblyLinearVelocity
				if direction.Magnitude > 0 then
					root.AssemblyLinearVelocity = Vector3.new(direction.X * speed, velocity.Y, direction.Z * speed)
				else
					root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
				end
			end)
			return true
		end

		rebuildItemOrder(Config.CarpetTool or "Flying Carpet")
		Config.CarpetSpeedEnabled = false
		_G.Haram_SetCarpetTool = setSelectedItem
		_G.Haram_CurrentCarpetTool = function()
			return Config.CarpetTool or "Flying Carpet"
		end
		_G.Haram_CycleCarpetTool = cycleSelectedItem
		_G.Haram_SetCarpetSpeed = setCarpetEnabled
		_G.Haram_ToggleCarpetSpeed = function()
			return setCarpetEnabled(not carpetEnabled)
		end
		_G.__HaramCarpetV2Ready = true
	end

	do
		local _dropBusy = false
		local _flinging = false

		local function _dropRoot(char)
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			return hum and hum.RootPart
		end

		local function _flingBurst(duration)
			if _flinging then
				return
			end
			_flinging = true
			_G.HaramDropFlingActive = true
			local t0 = os.clock()
			while _flinging and (os.clock() - t0) < duration do
				RunService.Heartbeat:Wait()
				local char = player.Character
				local root = _dropRoot(char)
				if not (char and char.Parent and root and root.Parent) then
					break
				end
				local vel = root.Velocity
				root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
				RunService.RenderStepped:Wait()
				if char and char.Parent and root and root.Parent then
					root.Velocity = vel
				end
				RunService.Stepped:Wait()
				if char and char.Parent and root and root.Parent then
					root.Velocity = vel + Vector3.new(0, 0.1, 0)
				end
			end
			_flinging = false
			_G.HaramDropFlingActive = false
			local root = _dropRoot(player.Character)
			if root and root.Parent then
				root.Velocity = Vector3.new(0, 0, 0)
			end
		end

		_G.Haram_DropBrainrot = function()
			if _dropBusy then
				return
			end
			_dropBusy = true
			_G.HaramDropPending = true
			local wasInvis = _G.invisibleStealEnabled == true
			if wasInvis and _G.toggleInvisibleSteal then
				pcall(_G.toggleInvisibleSteal)
				task.wait(0.2)
			end
			pcall(_flingBurst, 0.3)
			-- -- ShowNotification("DROP", wasInvis and "Brainrot dropped (invis OFF)" or "Brainrot dropped")
			task.wait(0.2)
			_dropBusy = false
			_G.HaramDropPending = false
		end

		player.CharacterAdded:Connect(function()
			_flinging = false
			_dropBusy = false
			_G.HaramDropPending = false
			_G.HaramDropFlingActive = false
		end)
	end

	_G.Haram_KeybindListening = nil
	-- Extras owns the shared manual-TP key. tp.txt only provides the action.
	_G.HaramManualTPBridgeActive = true
	local conn1 = UIS.InputBegan:Connect(function(input, processed)
		if _G.Haram_KeybindListening ~= nil then
			return
		end
		do
			local _fb = nil
			pcall(function()
				_fb = UIS:GetFocusedTextBox()
			end)
			if _fb then
				return
			end
		end
		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		local kc = input.KeyCode
		-- Q и другие клавиши инструмента могут быть уже помечены игрой
		-- как processed. Назначенный Carpet Speed keybind всё равно должен
		-- доходить до нашего обработчика.
		if processed and kc ~= _key("CarpetSpeedKey") and kc ~= _key("TeleportKey") then
			return
		end
		if kc == _key("KickKey") then
			if _G.Haram_DoKick then
				task.spawn(function()
					pcall(_G.Haram_DoKick)
				end)
			end
		elseif kc == _key("InvisStealKey") then
			if _G.toggleInvisibleSteal then
				task.spawn(function()
					pcall(_G.toggleInvisibleSteal)
				end)
				-- -- ShowNotification("INVIS STEAL", (not _G.invisibleStealEnabled) and "ON" or "OFF")
			end
		elseif kc == _key("TeleportKey") then
			task.spawn(function()
				-- Current tp.txt API first; legacy names remain as fallbacks.
				local action = _G.HaramStartSideTP or _G.Haram_ExecuteManualTP or _G.MynxxStartSideTP
				if type(action) == "function" then
					pcall(action)
				end
			end)
		elseif kc == _key("ConfigKey") then
			if _G.Haram_ToggleConfigMenu then
				pcall(_G.Haram_ToggleConfigMenu)
			end
		elseif kc == _key("InstantResetKey") then
			if _G.Haram_InstantReset then
				task.spawn(function()
					pcall(_G.Haram_InstantReset)
				end)
				-- -- ShowNotification("INSTANT RESET", "Burst...")
			end
		elseif kc == _key("InstantCloneKey") then
			task.spawn(function()
				pcall(instantClone)
			end)
		elseif kc == _key("CarpetSpeedKey") then
			if _G.Haram_ToggleCarpetSpeed then
				task.spawn(function()
					pcall(_G.Haram_ToggleCarpetSpeed)
				end)
			end
		elseif kc == _key("NextTargetKey") then
			if _G.HaramCycleStealTarget then
				task.spawn(function()
					pcall(_G.HaramCycleStealTarget)
				end)
			end
		elseif kc == _key("DropBrainrotKey") then
			task.spawn(function()
				if _G.invisibleStealEnabled == true then
					if _G.toggleInvisibleSteal then
						pcall(_G.toggleInvisibleSteal)
					end
					task.wait(0.2)
				end
				if _G.Haram_DropBrainrot then
					pcall(_G.Haram_DropBrainrot)
				end
			end)
		end
	end)
end

task.spawn(function()
	task.wait(0.5)
	pcall(function()
		local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
		local old = pg:FindFirstChild("HaramHubUtilPanel")
		if old then
			old:Destroy()
		end

		local C_BG = Color3.fromRGB(7, 7, 7)
		local C_OFF = Color3.fromRGB(22, 22, 22)
		local C_ON = Color3.fromRGB(201, 201, 201)
		local C_ACTIVE = Color3.fromRGB(59, 59, 59)
		local C_RED = Color3.fromRGB(105, 105, 105)
		local C_TEXT = Color3.fromRGB(238, 238, 238)
		local C_DIM = Color3.fromRGB(140, 140, 140)
		local C_DIV = Color3.fromRGB(42, 42, 42)
		local FONT_BK = Enum.Font.GothamBlack
		local FONT_B = Enum.Font.GothamBold

		local sg = Instance.new("ScreenGui")
		sg.Name = "HaramHubUtilPanel"
		sg.ResetOnSpawn = false
		sg.IgnoreGuiInset = true
		sg.DisplayOrder = 9991
		sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sg.Parent = pg
		registerScreenGui(sg)
		
		local W, PAD = 320, 8
		local main = Instance.new("Frame", sg)
		main.Size = UDim2.fromOffset(W, 10)
		main.AutomaticSize = Enum.AutomaticSize.Y
		main.Position = UDim2.fromOffset(30, 240)
		main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		main.BorderSizePixel = 0
		main.BackgroundTransparency = 0.25
		main.ClipsDescendants = true
		corner(main, 5)
		-- background image ONLY (does not block clicks, not in layout)
		if _G.HaramHubBGAsset then
			local bg = Instance.new("ImageLabel")
			bg.Name = "HaramHubPanelBG"
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.Position = UDim2.new(0, 0, 0, 0)
			bg.BackgroundTransparency = 1
			bg.Image = _G.HaramHubBGAsset
			bg.ScaleType = Enum.ScaleType.Crop
			bg.ImageTransparency = 0.3
			bg.ZIndex = 0
			bg.Active = false
			bg.Selectable = false
			bg.Parent = main
		end
		do
			local g = Instance.new("UIGradient", main)
			g.Rotation = 135
			g.Color = ColorSequence.new(Color3.fromRGB(25, 12, 30), Color3.fromRGB(8, 4, 14))
		end
		do
			local _us = Instance.new("UIScale", main)
			_us.Name = "HaramHub_CompactScale"
			_us.Scale = GlobalUIScaleVal
		end
		local ms = Instance.new("UIStroke", main)
		ms.Color = Color3.fromRGB(53, 53, 53)
		ms.Thickness = 1
		ms.Transparency = 0.38

		-- content container so UIListLayout does not fight the bg ImageLabel
		local content = Instance.new("Frame", main)
		content.Name = "Content"
		content.Size = UDim2.new(1, 0, 0, 0)
		content.AutomaticSize = Enum.AutomaticSize.Y
		content.BackgroundTransparency = 1
		content.ZIndex = 1
		content.ClipsDescendants = false

		local titleBar = Instance.new("Frame", content)
		titleBar.Size = UDim2.new(1, 0, 0, 28)
		titleBar.BackgroundColor3 = C_OFF
		titleBar.BorderSizePixel = 0
		titleBar.BackgroundTransparency = 1
		titleBar.LayoutOrder = -999
		titleBar.ZIndex = 2
		corner(titleBar, 10)
		local titleLbl = Instance.new("TextLabel", titleBar)
		titleLbl.Size = UDim2.new(1, -8, 1, 0)
		titleLbl.Position = UDim2.new(0, 8, 0, 0)
		titleLbl.BackgroundTransparency = 1
		titleLbl.Text = "HARAM HUB"
		titleLbl.Font = FONT_BK
		titleLbl.TextSize = 12
		titleLbl.TextColor3 = C_TEXT
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.ZIndex = 3

		local mainPad = Instance.new("UIPadding", content)
		mainPad.PaddingLeft = UDim.new(0, PAD)
		mainPad.PaddingRight = UDim.new(0, PAD)
		mainPad.PaddingTop = UDim.new(0, PAD)
		mainPad.PaddingBottom = UDim.new(0, PAD)
		local mainList = Instance.new("UIListLayout", content)
		mainList.SortOrder = Enum.SortOrder.LayoutOrder
		mainList.Padding = UDim.new(0, 0)

		-- redirect so all the existing rowFrame / div / buttons still parent correctly
		local realMain = main
		main = content

		task.defer(function()
			applySavedPosition("Utils Panel", realMain)
		end)

		MakeDraggable(titleBar, realMain, "Utils Panel")

		local lo = 0
		local function div()
			lo = lo + 1
			local d = Instance.new("Frame", main)
			d.LayoutOrder = lo
			d.Size = UDim2.new(1, 0, 0, 1)
			d.BackgroundTransparency = 1
			d.BorderSizePixel = 0
			return d
		end
		local function rowFrame(h)
			lo = lo + 1
			local r = Instance.new("Frame", main)
			r.LayoutOrder = lo
			r.Size = UDim2.new(1, 0, 0, h)
			r.BackgroundTransparency = 1
			r.BorderSizePixel = 0
			r.ZIndex = 2
			return r
		end
		local function paint(b, on)
			b.BackgroundColor3 = on and C_ACTIVE or C_OFF
			b.TextColor3 = on and C_ON or C_TEXT
		end
		local function mkBtn(parent, text, bg, fg, ts)
			local b = Instance.new("TextButton", parent)
			b.BackgroundColor3 = bg or C_OFF
			b.AutoButtonColor = false
			b.BorderSizePixel = 0
			b.Text = text
			b.Font = FONT_BK
			b.TextSize = ts or 12
			b.TextColor3 = fg or C_TEXT
			b.ZIndex = 3
			corner(b, 4)
			return b
		end

		local f1 = rowFrame(38)
		local f1pad = Instance.new("UIPadding", f1)
		f1pad.PaddingLeft = UDim.new(0, 0)
		f1pad.PaddingRight = UDim.new(0, 0)
		f1pad.PaddingTop = UDim.new(0, 6)
		f1pad.PaddingBottom = UDim.new(0, 6)
		local f1l = Instance.new("UIListLayout", f1)
		f1l.FillDirection = Enum.FillDirection.Horizontal
		f1l.SortOrder = Enum.SortOrder.LayoutOrder
		f1l.Padding = UDim.new(0, 6)

		local rjJob = mkBtn(f1, "RJ Job", C_OFF, C_TEXT, 11)
		rjJob.Size = UDim2.new(0.5, -3, 0, 26)
		rjJob.LayoutOrder = 1
		local rjPs = mkBtn(f1, "RJ PS", C_OFF, C_TEXT, 11)
		rjPs.Size = UDim2.new(0.5, -3, 0, 26)
		rjPs.LayoutOrder = 2

		div()

		local runwayBuyRow = rowFrame(30)
		local runwayBuyButton = mkBtn(runwayBuyRow, "AUTO BUY: OFF", C_OFF, C_TEXT, 12)
		runwayBuyButton.Size = UDim2.new(1, 0, 0, 30)
		runwayBuyButton.Position = UDim2.fromOffset(0, 0)
		local function syncRunwayBuyButton()
			if not runwayBuyButton.Parent then
				return
			end
			local state = _G.HaramRunwayAutoBuyTest.GetState()
			runwayBuyButton.Text = "AUTO BUY: " .. state
			paint(runwayBuyButton, state == "ON")
		end
		local unsubscribeRunwayBuy = _G.HaramRunwayAutoBuyTest.Subscribe(syncRunwayBuyButton)
		runwayBuyRow.Destroying:Connect(unsubscribeRunwayBuy)
		runwayBuyButton.MouseButton1Click:Connect(function()
			_G.HaramToggleAutoBuy()
		end)
		div()

		local roadRow = rowFrame(30)
		local roadButton = mkBtn(roadRow, "ROAD BRAINROTS: OFF", C_OFF, C_TEXT, 12)
		roadButton.Size = UDim2.new(1, 0, 0, 30)
		local function syncRoad(visible)
			if not roadButton.Parent then
				return
			end
			roadButton.Text = "ROAD BRAINROTS: " .. (visible and "ON" or "OFF")
			paint(roadButton, visible)
		end
		_G.HaramSyncRoadVisibilityButton = syncRoad
		roadButton.MouseButton1Click:Connect(function()
			_G.HaramSetRoadBrainrotsVisible(not Config.ShowRoadBrainrots)
		end)
		syncRoad(Config.ShowRoadBrainrots == true)
		div()

		local antiRagRow = rowFrame(30)
		local antiRagButton = mkBtn(antiRagRow, "ANTI RAGDOLL", C_OFF, C_TEXT, 12)
		antiRagButton.Size = UDim2.new(1, 0, 0, 30)
		local function syncAntiRag()
			antiRagButton.Text = "ANTI RAGDOLL: " .. (Config.AntiRagdoll and "ON" or "OFF")
			paint(antiRagButton, Config.AntiRagdoll == true)
		end
		antiRagButton.MouseButton1Click:Connect(function()
			Config.AntiRagdoll = not Config.AntiRagdoll
			startAntiRagdoll(Config.AntiRagdoll)
			syncAntiRag()
			pcall(SaveConfig)
		end)
		syncAntiRag()
		div()

		local f3 = rowFrame(38)
		local f3pad = Instance.new("UIPadding", f3)
		f3pad.PaddingTop = UDim.new(0, 6)
		f3pad.PaddingBottom = UDim.new(0, 6)
		local f3l = Instance.new("UIListLayout", f3)
		f3l.FillDirection = Enum.FillDirection.Horizontal
		f3l.SortOrder = Enum.SortOrder.LayoutOrder
		f3l.Padding = UDim.new(0, 6)
		f3l.VerticalAlignment = Enum.VerticalAlignment.Center

		local akBtn = mkBtn(f3, "Auto Kick", C_OFF, C_TEXT, 12)
		akBtn.Size = UDim2.new(1 / 3, -4, 0, 26)
		akBtn.LayoutOrder = 1
		local kickBtn = mkBtn(f3, "KICK", C_RED, C_TEXT, 13)
		kickBtn.Size = UDim2.new(1 / 3, -4, 0, 26)
		kickBtn.LayoutOrder = 2
		local modKickBtn = mkBtn(f3, "MOD KICK", C_RED, C_TEXT, 11)
		modKickBtn.Size = UDim2.new(1 / 3, -4, 0, 26)
		modKickBtn.LayoutOrder = 3
		div()

		local function newSlider(label, minV, maxV, getV, setV, fmt, warnAt)
			local sRow = rowFrame(34)
			sRow.BackgroundColor3 = C_OFF
			sRow.BackgroundTransparency = 0.12
			corner(sRow, 10)
			local sp = Instance.new("UIPadding", sRow)
			sp.PaddingLeft = UDim.new(0, 8)
			sp.PaddingRight = UDim.new(0, 8)
			sp.PaddingTop = UDim.new(0, 6)
			sp.PaddingBottom = UDim.new(0, 2)

			local topL = Instance.new("Frame", sRow)
			topL.Size = UDim2.new(1, 0, 0, 14)
			topL.BackgroundTransparency = 1
			topL.BorderSizePixel = 0

			local lbl = Instance.new("TextLabel", topL)
			lbl.Size = UDim2.new(0.5, 0, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = label
			lbl.Font = FONT_B
			lbl.TextSize = 11
			lbl.TextColor3 = C_DIM
			lbl.TextXAlignment = Enum.TextXAlignment.Left

			local valLbl = Instance.new("TextLabel", topL)
			valLbl.Size = UDim2.new(0.5, 0, 1, 0)
			valLbl.Position = UDim2.new(0.5, 0, 0, 0)
			valLbl.BackgroundTransparency = 1
			valLbl.Font = FONT_BK
			valLbl.TextSize = 11
			valLbl.TextColor3 = C_ON
			valLbl.TextXAlignment = Enum.TextXAlignment.Right

			local bar = Instance.new("Frame", sRow)
			bar.Position = UDim2.new(0, 0, 0, 18)
			bar.Size = UDim2.new(1, 0, 0, 5)
			bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			bar.BorderSizePixel = 0
			corner(bar, 5)
			local fill = Instance.new("Frame", bar)
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = C_ON
			fill.BorderSizePixel = 0
			corner(fill, 5)
			local knob = Instance.new("Frame", bar)
			knob.Size = UDim2.fromOffset(13, 13)
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(0, 0, 0.5, 0)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.BorderSizePixel = 0
			corner(knob, 7)

			local function render(v)
				local a = math.clamp((v - minV) / (maxV - minV), 0, 1)
				fill.Size = UDim2.new(a, 0, 1, 0)
				knob.Position = UDim2.new(a, 0, 0.5, 0)
				if warnAt and v > warnAt then
					valLbl.Text = string.format(fmt, v) .. "  CAN DETECT"
					valLbl.TextColor3 = Color3.fromRGB(101, 101, 101)
					fill.BackgroundColor3 = Color3.fromRGB(101, 101, 101)
				else
					valLbl.Text = string.format(fmt, v)
					valLbl.TextColor3 = C_ON
					fill.BackgroundColor3 = C_ON
				end
			end
			render(getV())

			local dragging = false
			local function apply(x)
				local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
				local v = minV + a * (maxV - minV)
				setV(v)
				render(v)
			end
			bar.InputBegan:Connect(function(i)
				if
					i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					dragging = true
					_G._HaramSliderDragging = true
					apply(i.Position.X)
				end
			end)
			knob.InputBegan:Connect(function(i)
				if
					i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					dragging = true
					_G._HaramSliderDragging = true
				end
			end)
			UIS.InputChanged:Connect(function(i)
				if not dragging then
					return
				end
				if
					i.UserInputType == Enum.UserInputType.MouseMovement
					or i.UserInputType == Enum.UserInputType.Touch
				then
					apply(i.Position.X)
				end
			end)
			UIS.InputEnded:Connect(function(i)
				if
					i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					if dragging then
						dragging = false
						_G._HaramSliderDragging = false
						SaveConfig()
					end
				end
			end)
			task.spawn(function()
				while sRow.Parent do
					local current = tonumber(getV())
					if current then
						render(math.clamp(current, minV, maxV))
					end
					task.wait(0.1)
				end
			end)
			return sRow
		end

		newSlider("Rot", 180, 360, function()
			return tonumber(Config.InvisStealAngle) or 180
		end, function(v)
			v = math.floor(v + 0.5)
			Config.InvisStealAngle = v
			_G.InvisStealAngle = v
			_G.HaramInvisAngle = v
			_G.HaramInvisDepthSync()
		end, "%d")
		div()
		newSlider("Depth", 0.5, 10, function()
			return math.clamp(tonumber(Config.SinkSliderValue) or 5, 0.5, 10)
		end, function(v)
			v = math.floor(v * 10 + 0.5) / 10
			Config.SinkSliderValue = v
			_G.SinkSliderValue = v
			_G.HaramInvisDepth = v
			_G.HaramInvisDepthSync()
		end, "%.1f")

		div()
		local function invisSettingButton(title, key)
			local row = rowFrame(30)
			local button = mkBtn(row, title, C_OFF, C_TEXT, 11)
			button.Size = UDim2.new(1, 0, 0, 30)
			local function refresh()
				button.Text = title .. ": " .. (Config[key] and "ON" or "OFF")
				paint(button, Config[key] == true)
			end
			button.MouseButton1Click:Connect(function()
				Config[key] = not Config[key]
				_G.HaramInvisDepthSync()
				refresh()
				pcall(SaveConfig)
			end)
			refresh()
		end
		invisSettingButton("AUTO INVIS ON STEAL", "AutoInvisDuringSteal")
		invisSettingButton("INVIS AUTO ROTATE", "InvisAutoRotate")
		invisSettingButton("INVIS RECOVER LAGBACK", "InvisRecoverLagback")

		rjJob.MouseButton1Click:Connect(function()
			-- -- ShowNotification("REJOIN","Job...")
			local job = tostring(game.JobId or "")
			if job == "" then
				rjJob.Text = "SERVER ID UNAVAILABLE"
				return
			end
			local ok = pcall(function()
				HaramService("TeleportService"):TeleportToPlaceInstance(
					game.PlaceId,
					job,
					LocalPlayer,
					nil,
					{ peakJoin = { jobId = job }, elysiumRejoin = true }
				)
			end)
			rjJob.Text = ok and "REJOINING..." or "REJOIN FAILED"
		end)
		rjPs.MouseButton1Click:Connect(function()
			-- -- ShowNotification("REJOIN","Private server...")
			local link = tostring(Config.PrivateServerLink or ""):match("^%s*(.-)%s*$")
			local code = link
			if link ~= "" and string.find(link, "://", 1, true) then
				code = link:match("[?&]privateServerLinkCode=([^&]+)")
					or link:match("[?&]linkCode=([^&]+)")
					or link:match("[?&]code=([^&]+)")
			end
			if not code or code == "" then
				code = PS_LINK_CODE
			end
			local ok = pcall(function()
				HaramService("ExperienceService"):LaunchExperience({ placeId = PS_PLACE_ID, linkCode = code })
			end)
			if not ok then
				local job = tostring(game.JobId or "")
				if job == "" then
					rjJob.Text = "SERVER ID UNAVAILABLE"
					return
				end
				local ok = pcall(function()
					HaramService("TeleportService"):TeleportToPlaceInstance(
						game.PlaceId,
						job,
						LocalPlayer,
						nil,
						{ peakJoin = { jobId = job }, elysiumRejoin = true }
					)
				end)
				rjJob.Text = ok and "REJOINING..." or "REJOIN FAILED"
			end
		end)

		paint(akBtn, Config.AutoKickEnabled == true)
		akBtn.MouseButton1Click:Connect(function()
			Config.AutoKickEnabled = not Config.AutoKickEnabled
			if Config.AutoKickEnabled then
				if _G.Haram_StartAutoKick then
					pcall(_G.Haram_StartAutoKick)
				end
			else
				if _G.Haram_StopAutoKick then
					pcall(_G.Haram_StopAutoKick)
				end
			end
			SaveConfig()
			paint(akBtn, Config.AutoKickEnabled)
		end)
		div()

		modKickBtn.MouseButton1Click:Connect(function()
			if _G.Haram_ModerationKick then
				task.spawn(function()
					pcall(_G.Haram_ModerationKick)
				end)
			end
		end)
		local f5 = rowFrame(38)
		local f5pad = Instance.new("UIPadding", f5)
		f5pad.PaddingTop = UDim.new(0, 6)
		f5pad.PaddingBottom = UDim.new(0, 6)
		local f5l = Instance.new("UIListLayout", f5)
		f5l.FillDirection = Enum.FillDirection.Horizontal
		f5l.SortOrder = Enum.SortOrder.LayoutOrder
		f5l.Padding = UDim.new(0, 6)

		local invBtn = mkBtn(f5, "Invis Steal", C_OFF, C_TEXT, 12)
		invBtn.Size = UDim2.new(1, 0, 0, 26)
		invBtn.LayoutOrder = 1
		local invisClickBusy = false
		local function syncInvisButton()
			if not invBtn.Parent then
				return
			end
			local on = _G.HaramInvisActive == true
			paint(invBtn, on)
			invBtn.Text = on and "Invis Steal: ON" or "Invis Steal: OFF"
		end
		syncInvisButton()
		if _G.Haram_SetInvisBtnSync then
			_G.Haram_SetInvisBtnSync(syncInvisButton)
		end
		invBtn.MouseButton1Click:Connect(function()
			if invisClickBusy then
				return
			end
			invisClickBusy = true
			task.spawn(function()
				local wantEnabled = _G.HaramInvisActive ~= true
				if type(_G.HaramSetInvisManual) == "function" then
					pcall(_G.HaramSetInvisManual, wantEnabled)
				end
				syncInvisButton()
				invisClickBusy = false
				if wantEnabled and _G.HaramInvisActive ~= true and LocalPlayer:GetAttribute("Stealing") ~= true then
					pcall(function()
						HaramService("StarterGui"):SetCore("SendNotification", {
							Title = "Invis Steal",
							Text = "Start stealing a brainrot first.",
							Duration = 3,
						})
					end)
				end
			end)
		end)
		_G.Haram_SyncCarpetBtn = function() end
	end)
end)

_G.Haram_SetFOV = function(v)
	v = math.clamp(tonumber(v) or 120, 40, 120)
	Config.FOV = v
	_G.HaramFOV = v
	pcall(function()
		Workspace.CurrentCamera.FieldOfView = v
	end)
	return v
end

do
	_G.HaramFOV = math.clamp(tonumber(Config.FOV) or 120, 40, 120)
	local fovConn = nil
	local restoringFOV = false

	local function restoreFOV(cam)
		if not cam or restoringFOV then
			return
		end
		local wanted = math.clamp(tonumber(Config.FOV) or tonumber(_G.HaramFOV) or 120, 40, 120)
		_G.HaramFOV = wanted
		if math.abs((cam.FieldOfView or wanted) - wanted) <= 0.01 then
			return
		end
		restoringFOV = true
		pcall(function()
			cam.FieldOfView = wanted
		end)
		restoringFOV = false
	end

	local function bindFOVCamera(cam)
		if fovConn then
			fovConn:Disconnect()
			fovConn = nil
		end
		if not cam then
			return
		end
		restoreFOV(cam)
		fovConn = cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
			-- Flying gears commonly force 70 when equipped. Restore the user's
			-- configured value in the same frame instead of waiting for a timer.
			restoreFOV(cam)
		end)
	end

	bindFOVCamera(Workspace.CurrentCamera)
	Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		bindFOVCamera(Workspace.CurrentCamera)
	end)
end

task.spawn(function()
	pcall(function()
		local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
		local old = pg:FindFirstChild("HaramHubConfigPanel")
		if old then
			old:Destroy()
		end

		local C_BG = Color3.fromRGB(7, 7, 7)
		local C_OFF = Color3.fromRGB(22, 22, 22)
		local C_ON = Color3.fromRGB(201, 201, 201)
		local C_ACTIVE = Color3.fromRGB(59, 59, 59)
		local C_TEXT = Color3.fromRGB(238, 238, 238)
		local C_DIM = Color3.fromRGB(140, 140, 140)
		local FONT_B = Enum.Font.GothamBold

		local sg = Instance.new("ScreenGui")
		sg.Name = "HaramHubConfigPanel"
		sg.ResetOnSpawn = false
		sg.IgnoreGuiInset = true
		sg.DisplayOrder = 9995
		sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		sg.Parent = pg
		registerScreenGui(sg)
		
		local main = Instance.new("Frame", sg)
		main.AnchorPoint = Vector2.new(0.5, 0.5)
		main.Position = UDim2.new(0.5, 0, 0.5, 0)
		main.Size = UDim2.fromOffset(360, 10)
		main.AutomaticSize = Enum.AutomaticSize.Y
		main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		main.BorderSizePixel = 0
		main.BackgroundTransparency = 0.35
		main.ClipsDescendants = true
		main.Visible = false
		corner(main, 5)
		if _G.HaramHubBGAsset then
			local bg = Instance.new("ImageLabel")
			bg.Name = "HaramHubPanelBG"
			bg.Size = UDim2.new(1, 0, 1, 0)
			bg.BackgroundTransparency = 1
			bg.Image = _G.HaramHubBGAsset
			bg.ScaleType = Enum.ScaleType.Crop
			bg.ImageTransparency = 0.25
			bg.ZIndex = 0
			bg.Active = false
			bg.Selectable = false
			bg.Parent = main
		end
		do
			local g = Instance.new("UIGradient", main)
			g.Rotation = 135
			g.Color = ColorSequence.new(Color3.fromRGB(20, 10, 25), Color3.fromRGB(8, 4, 12))
			local s = Instance.new("UIStroke", main)
			s.Color = Color3.fromRGB(53, 53, 53)
			s.Thickness = 1
			s.Transparency = 0.38
		end
		do
			local _us = Instance.new("UIScale", main)
			_us.Name = "HaramHub_CompactScale"
			_us.Scale = GlobalUIScaleVal
		end
		local pad = Instance.new("UIPadding", main)
		pad.PaddingLeft = UDim.new(0, 8)
		pad.PaddingRight = UDim.new(0, 8)
		pad.PaddingTop = UDim.new(0, 8)
		pad.PaddingBottom = UDim.new(0, 8)
		local list = Instance.new("UIListLayout", main)
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 6)

		local header = Instance.new("Frame", main)
		header.LayoutOrder = 0
		header.Size = UDim2.new(1, 0, 0, 26)
		header.BackgroundColor3 = C_OFF
		header.BorderSizePixel = 0
		header.BackgroundTransparency = 1
		corner(header, 10)
		local htitle = Instance.new("TextLabel", header)
		htitle.BackgroundTransparency = 1
		htitle.Size = UDim2.new(1, -30, 1, 0)
		htitle.Position = UDim2.fromOffset(8, 0)
		htitle.Text = "HARAM CONFIG"
		htitle.Font = FONT_B
		htitle.TextSize = 13
		htitle.TextColor3 = C_TEXT
		htitle.TextXAlignment = Enum.TextXAlignment.Left
		local closeBtn = Instance.new("TextButton", header)
		closeBtn.Size = UDim2.fromOffset(22, 22)
		closeBtn.Position = UDim2.new(1, -24, 0.5, -11)
		closeBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
		closeBtn.AutoButtonColor = false
		closeBtn.Text = "X"
		closeBtn.Font = FONT_B
		closeBtn.TextSize = 13
		closeBtn.TextColor3 = C_TEXT
		closeBtn.BorderSizePixel = 0
		corner(closeBtn, 7)
		closeBtn.MouseButton1Click:Connect(function()
			main.Visible = false
		end)
		MakeDraggable(header, main, "ConfigMenu")
		task.defer(function()
			applySavedPosition("ConfigMenu", main)
		end)

		local order = 0
		local function newRow(h)
			order = order + 1
			local r = Instance.new("Frame", main)
			r.LayoutOrder = order
			r.Size = UDim2.new(1, 0, 0, h or 28)
			r.BackgroundTransparency = 1
			r.BorderSizePixel = 0
			local hl = Instance.new("UIListLayout", r)
			hl.FillDirection = Enum.FillDirection.Horizontal
			hl.SortOrder = Enum.SortOrder.LayoutOrder
			hl.Padding = UDim.new(0, 6)
			return r
		end
		local function newBtn(row, text, widthScale, o)
			local b = Instance.new("TextButton", row)
			b.LayoutOrder = o
			b.Size = UDim2.new(widthScale, widthScale == 1 and 0 or -3, 1, 0)
			b.BackgroundColor3 = C_OFF
			b.AutoButtonColor = false
			b.BackgroundTransparency = 0.3
			b.Text = text
			b.Font = FONT_B
			b.TextSize = 12
			b.TextColor3 = C_TEXT
			b.BorderSizePixel = 0
			corner(b, 9)
			return b
		end
		local function paint(b, on)
			b.BackgroundColor3 = on and C_ACTIVE or C_OFF
			b.TextColor3 = on and C_ON or C_TEXT
		end

		local function newToggleRow(lbl1, getState1, toggle1, lbl2, getState2, toggle2)
			local r = newRow(28)
			local b1 = newBtn(r, lbl1, lbl2 and 0.5 or 1, 1)
			paint(b1, getState1())
			b1.MouseButton1Click:Connect(function()
				toggle1()
				paint(b1, getState1())
			end)
			if lbl2 then
				local b2 = newBtn(r, lbl2, 0.5, 2)
				paint(b2, getState2())
				b2.MouseButton1Click:Connect(function()
					toggle2()
					paint(b2, getState2())
				end)
				return b1, b2
			end
			return b1
		end

		do
			local row = newRow(30)
			row.Name = "OptimizerModeButtons"
			local defaultBtn = newBtn(row, "Default Mode", 0.5, 1)
			local aaBtn = newBtn(row, "Aa Mode", 0.5, 2)
			defaultBtn.Name = "DefaultMode"
			aaBtn.Name = "AaMode"
			local function refreshOptimizerMode()
				local mode = optimizerRequest or _G.HaramOptimizerMode or Config.OptimizerMode or "aa"
				paint(defaultBtn, mode == "default")
				paint(aaBtn, mode == "aa")
				if
					not optimizerRequest
					and type(_G.HaramSetOptimizerMode) == "function"
					and Config.OptimizerMode ~= mode
				then
					Config.OptimizerMode = mode
					pcall(SaveConfig)
				end
			end
			defaultBtn.MouseButton1Click:Connect(function()
				selectOptimizerMode("default")
				refreshOptimizerMode()
			end)
			aaBtn.MouseButton1Click:Connect(function()
				selectOptimizerMode("aa")
				refreshOptimizerMode()
			end)
			refreshOptimizerMode()
			task.spawn(function()
				while sg.Parent do
					if main.Visible then
						refreshOptimizerMode()
					end
					task.wait(0.25)
				end
			end)
		end

		local espPBtn, espBBtn = newToggleRow(
			"ESP Player",
			function()
				return Config.ESPPlayerEnabled == true
			end,
			function()
				if _G.Haram_ToggleESPPlayer then
					pcall(_G.Haram_ToggleESPPlayer)
				end
			end,
			"ESP Base Owner",
			function()
				return Config.ESPBaseOwnerEnabled == true
			end,
			function()
				if _G.Haram_ToggleESPBaseOwner then
					pcall(_G.Haram_ToggleESPBaseOwner)
				end
			end
		)

		newToggleRow("Inf Jump", function()
			return Config.InfiniteJump
		end, function()
			Config.InfiniteJump = not Config.InfiniteJump
			pcall(SaveConfig)
		end)

		local function newSlider(label, minV, maxV, getV, setV, fmt)
			order = order + 1
			local box = Instance.new("Frame", main)
			box.LayoutOrder = order
			box.Size = UDim2.new(1, 0, 0, 40)
			box.BackgroundColor3 = C_OFF
			box.BorderSizePixel = 0
			box.BackgroundTransparency = 0.3
			corner(box, 10)
			local lbl = Instance.new("TextLabel", box)
			lbl.BackgroundTransparency = 1
			lbl.Position = UDim2.fromOffset(8, 3)
			lbl.Size = UDim2.new(0.6, 0, 0, 16)
			lbl.Text = label
			lbl.Font = FONT_B
			lbl.TextSize = 12
			lbl.TextColor3 = C_DIM
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			local val = Instance.new("TextLabel", box)
			val.BackgroundTransparency = 1
			val.Position = UDim2.new(1, -64, 0, 3)
			val.Size = UDim2.fromOffset(56, 16)
			val.Font = FONT_B
			val.TextSize = 12
			val.TextColor3 = C_ON
			val.TextXAlignment = Enum.TextXAlignment.Right
			local bar = Instance.new("Frame", box)
			bar.Position = UDim2.fromOffset(8, 26)
			bar.Size = UDim2.new(1, -16, 0, 6)
			bar.BackgroundColor3 = Color3.fromRGB(61, 61, 61)
			bar.BorderSizePixel = 0
			corner(bar, 5)
			local fill = Instance.new("Frame", bar)
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = C_ON
			fill.BorderSizePixel = 0
			corner(fill, 5)
			local knob = Instance.new("Frame", bar)
			knob.Size = UDim2.fromOffset(12, 12)
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(0, 0, 0.5, 0)
			knob.BackgroundColor3 = C_TEXT
			knob.BorderSizePixel = 0
			corner(knob, 6)
			local function render(v)
				local a = math.clamp((v - minV) / (maxV - minV), 0, 1)
				fill.Size = UDim2.new(a, 0, 1, 0)
				knob.Position = UDim2.new(a, 0, 0.5, 0)
				val.Text = string.format(fmt, v)
			end
			render(getV())
			local dragging = false
			local function apply(x)
				local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(1, bar.AbsoluteSize.X), 0, 1)
				local v = setV(minV + a * (maxV - minV))
				render(tonumber(v) or (minV + a * (maxV - minV)))
			end
			bar.InputBegan:Connect(function(i)
				if
					i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					dragging = true
					_G._HaramSliderDragging = true
					apply(i.Position.X)
				end
			end)
			knob.InputBegan:Connect(function(i)
				if
					i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					dragging = true
					_G._HaramSliderDragging = true
				end
			end)
			UIS.InputChanged:Connect(function(i)
				if
					dragging
					and (
						i.UserInputType == Enum.UserInputType.MouseMovement
						or i.UserInputType == Enum.UserInputType.Touch
					)
				then
					apply(i.Position.X)
				end
			end)
			UIS.InputEnded:Connect(function(i)
				if
					i.UserInputType == Enum.UserInputType.MouseButton1
					or i.UserInputType == Enum.UserInputType.Touch
				then
					if dragging then
						dragging = false
						_G._HaramSliderDragging = false
						pcall(SaveConfig)
					end
				end
			end)
		end

		newSlider("Invis Delay", 0, 3, function()
			return tonumber(Config.InvisAutoDelaySeconds) or 0.1
		end, function(v)
			Config.InvisAutoDelaySeconds = math.floor(v * 100 + 0.5) / 100
		end, "%.2f")

		newSlider("Auto Buy Distance", 0, 100, function()
			return Config.RunwayBuyDistance
		end, function(value)
			return _G.HaramRunwayAutoBuyTest.SetDistance(value)
		end, "%d")
		newSlider("Buy Attempts / Frame", 1, 50, function()
			return Config.RunwayBuyAttempts
		end, function(value)
			return _G.HaramRunwayAutoBuyTest.SetAttempts(value)
		end, "%d")
		newSlider("Auto Buy Float", 0, 20, function()
			return Config.RunwayBuyHover
		end, function(value)
			return _G.HaramRunwayAutoBuyTest.SetHover(value)
		end, "%d")

		newSlider("FOV", 40, 120, function()
			return math.clamp(tonumber(Config.FOV) or 70, 40, 120)
		end, function(v)
			v = math.floor(v + 0.5)
			return _G.Haram_SetFOV and _G.Haram_SetFOV(v) or v
		end, "%d")

		do
			order = order + 1
			local psBox = Instance.new("Frame", main)
			psBox.LayoutOrder = order
			psBox.Size = UDim2.new(1, 0, 0, 44)
			psBox.BackgroundColor3 = C_OFF
			psBox.BorderSizePixel = 0
			psBox.BackgroundTransparency = 0.3
			corner(psBox, 10)

			local psLbl = Instance.new("TextLabel", psBox)
			psLbl.BackgroundTransparency = 1
			psLbl.Position = UDim2.fromOffset(8, 3)
			psLbl.Size = UDim2.new(1, -16, 0, 14)
			psLbl.Text = "PS Code (Auto Kick)"
			psLbl.Font = FONT_B
			psLbl.TextSize = 11
			psLbl.TextColor3 = C_DIM
			psLbl.TextXAlignment = Enum.TextXAlignment.Left

			local psInput = Instance.new("TextBox", psBox)
			psInput.Size = UDim2.new(1, -12, 0, 22)
			psInput.Position = UDim2.fromOffset(6, 19)
			psInput.BackgroundColor3 = Color3.fromRGB(6, 3, 10)
			psInput.BorderSizePixel = 0
			psInput.Text = tostring(Config.PrivateServerLink or "")
			psInput.PlaceholderText = "Link o codigo de PS..."
			psInput.PlaceholderColor3 = C_DIM
			psInput.Font = FONT_B
			psInput.TextSize = 11
			psInput.TextColor3 = C_TEXT
			psInput.TextXAlignment = Enum.TextXAlignment.Left
			psInput.ClearTextOnFocus = false
			corner(psInput, 8)
			local psStroke = Instance.new("UIStroke", psInput)
			psStroke.Color = Color3.fromRGB(61, 61, 61)
			psStroke.Thickness = 1
			local psPad = Instance.new("UIPadding", psInput)
			psPad.PaddingLeft = UDim.new(0, 5)
			psPad.PaddingRight = UDim.new(0, 5)

			psInput.FocusLost:Connect(function()
				local v = psInput.Text:match("^%s*(.-)%s*$")
				Config.PrivateServerLink = v
				pcall(SaveConfig)
				psStroke.Color = C_ON
				task.delay(0.8, function()
					psStroke.Color = Color3.fromRGB(61, 61, 61)
				end)
			end)
			psInput.Focused:Connect(function()
				_G._HaramSliderDragging = true
			end)
			psInput.FocusLost:Connect(function()
				_G._HaramSliderDragging = false
			end)
		end

		-- ================= KEYBINDS aufklappbar =================
		do
			local kbExpanded = (Config.KeybindsExpanded == true)
			order = order + 1
			local kbHeader = Instance.new("TextButton", main)
			kbHeader.LayoutOrder = order
			kbHeader.Size = UDim2.new(1, 0, 0, 28)
			kbHeader.BackgroundColor3 = C_OFF
			kbHeader.AutoButtonColor = false
			kbHeader.BackgroundTransparency = 0.3
			kbHeader.BorderSizePixel = 0
			kbHeader.Font = FONT_B
			kbHeader.TextSize = 12
			kbHeader.TextColor3 = C_TEXT
			corner(kbHeader, 10)

			order = order + 1
			local kbContainer = Instance.new("Frame", main)
			kbContainer.LayoutOrder = order
			kbContainer.Size = UDim2.new(1, 0, 0, 10)
			kbContainer.AutomaticSize = Enum.AutomaticSize.Y
			kbContainer.BackgroundTransparency = 1
			kbContainer.BorderSizePixel = 0
			local kbList = Instance.new("UIListLayout", kbContainer)
			kbList.SortOrder = Enum.SortOrder.LayoutOrder
			kbList.Padding = UDim.new(0, 4)

			local kbRows = {}
			local keybindBtns = {}
			local function refreshKeybindBtn(cfgKey)
				local b = keybindBtns[cfgKey]
				if b then
					b.Text = tostring(Config[cfgKey] or "NONE")
				end
			end
			_G.Haram_RefreshKeybinds = function()
				for k, _ in pairs(keybindBtns) do
					refreshKeybindBtn(k)
				end
			end

			local kbOrder = 0
			local function newKeybindRow(labelText, cfgKey)
				kbOrder = kbOrder + 1
				local box = Instance.new("Frame", kbContainer)
				box.LayoutOrder = kbOrder
				box.Size = UDim2.new(1, 0, 0, 28)
				box.BackgroundColor3 = C_OFF
				box.BorderSizePixel = 0
				box.BackgroundTransparency = 0.3
				corner(box, 9)
				table.insert(kbRows, box)
				box.Visible = kbExpanded
				local lbl = Instance.new("TextLabel", box)
				lbl.BackgroundTransparency = 1
				lbl.Position = UDim2.fromOffset(8, 0)
				lbl.Size = UDim2.new(0.5, 0, 1, 0)
				lbl.Text = labelText
				lbl.Font = FONT_B
				lbl.TextSize = 11
				lbl.TextColor3 = C_DIM
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				local btn = Instance.new("TextButton", box)
				btn.Size = UDim2.new(0.45, -8, 0, 20)
				btn.Position = UDim2.new(0.55, 0, 0.5, -10)
				btn.BackgroundColor3 = Color3.fromRGB(6, 3, 10)
				btn.AutoButtonColor = false
				btn.BorderSizePixel = 0
				btn.Text = tostring(Config[cfgKey] or "NONE")
				btn.Font = FONT_B
				btn.TextSize = 11
				btn.TextColor3 = C_TEXT
				corner(btn, 8)
				local bStroke = Instance.new("UIStroke", btn)
				bStroke.Color = Color3.fromRGB(61, 61, 61)
				bStroke.Thickness = 1
				keybindBtns[cfgKey] = btn
				btn.MouseButton1Click:Connect(function()
					if _G.Haram_KeybindListening ~= nil then
						local prev = _G.Haram_KeybindListening
						_G.Haram_KeybindListening = nil
						if keybindBtns[prev] then
							keybindBtns[prev].Text = tostring(Config[prev] or "NONE")
						end
						if prev == cfgKey then
							return
						end
					end
					_G.Haram_KeybindListening = cfgKey
					btn.Text = "..."
				end)
				pcall(function()
					btn.MouseButton2Click:Connect(function()
						Config[cfgKey] = "NONE"
						pcall(SaveConfig)
						btn.Text = "NONE"
						if _G.Haram_KeybindListening == cfgKey then
							_G.Haram_KeybindListening = nil
						end
					end)
				end)
			end

			newKeybindRow("Config Menu", "ConfigKey")
			newKeybindRow("Teleport", "TeleportKey")
			newKeybindRow("Invis Steal", "InvisStealKey")
			newKeybindRow("Instant Reset", "InstantResetKey")
			newKeybindRow("Instant Clone", "InstantCloneKey")
			newKeybindRow("Carpet Speed", "CarpetSpeedKey")
			newKeybindRow("Next Target", "NextTargetKey")
			newKeybindRow("Drop Brainrot", "DropBrainrotKey")
			newKeybindRow("Kick", "KickKey")
			newKeybindRow("Auto Buy", "AutoBuyKey")

			local function setKbExpanded(on)
				kbExpanded = on
				Config.KeybindsExpanded = on
				pcall(SaveConfig)
				kbHeader.Text = on and "KEYBINDS  [v]" or "KEYBINDS  [>]"
				kbContainer.Visible = on
				for _, r in ipairs(kbRows) do
					r.Visible = on
				end
			end
			kbHeader.MouseButton1Click:Connect(function()
				setKbExpanded(not kbExpanded)
			end)
			setKbExpanded(kbExpanded)

			UIS.InputBegan:Connect(function(input, processed)
				local listening = _G.Haram_KeybindListening
				if not listening then
					return
				end
				if input.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end
				local focused = nil
				pcall(function()
					focused = UIS:GetFocusedTextBox()
				end)
				if focused then
					return
				end
				if input.KeyCode == Enum.KeyCode.Escape then
					_G.Haram_KeybindListening = nil
					refreshKeybindBtn(listening)
					return
				end
				local keyName
				if
					input.KeyCode == Enum.KeyCode.Backspace
					or input.KeyCode == Enum.KeyCode.Delete
					or input.KeyCode == Enum.KeyCode.Unknown
				then
					keyName = "NONE"
				else
					keyName = input.KeyCode.Name
				end
				Config[listening] = keyName
				pcall(SaveConfig)
				_G.Haram_KeybindListening = nil
				refreshKeybindBtn(listening)
			end)
		end
		-- =============== END KEYBINDS ===============

		_G.Haram_ToggleConfigMenu = function()
			main.Visible = not main.Visible
		end
		_G.Haram_ShowConfigMenu = function()
			main.Visible = true
		end

		-- lil draggable C button to open config
		do
			local oldB = pg:FindFirstChild("HaramHubConfigOpenBtn")
			if oldB then
				oldB:Destroy()
			end
			local bsg = Instance.new("ScreenGui")
			bsg.Name = "HaramHubConfigOpenBtn"
			bsg.ResetOnSpawn = false
			bsg.IgnoreGuiInset = true
			bsg.DisplayOrder = 9996
			bsg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			bsg.Parent = pg
			registerScreenGui(bsg)
			local cbtn = Instance.new("TextButton", bsg)
			cbtn.Name = "OpenBtn"
			cbtn.Size = UDim2.fromOffset(32, 32)
			cbtn.Position = UDim2.fromOffset(10, 300)
			cbtn.BackgroundColor3 = Color3.fromRGB(16, 10, 22)
			cbtn.BackgroundTransparency = 0.3
			cbtn.BorderSizePixel = 0
			cbtn.Text = "C"
			cbtn.Font = FONT_B
			cbtn.TextSize = 14
			cbtn.TextColor3 = C_TEXT
			cbtn.AutoButtonColor = false
			cbtn.Active = true
			corner(cbtn, 8)
			pcall(function()
				local d = Config.HaramPositions and Config.HaramPositions["ConfigOpenBtn"]
				if d and d.xo and d.yo then
					cbtn.Position = UDim2.fromOffset(d.xo, d.yo)
				end
			end)
			cbtn.MouseButton1Click:Connect(function()
				if _G.Haram_ToggleConfigMenu then
					pcall(_G.Haram_ToggleConfigMenu)
				end
			end)
			MakeDraggable(cbtn, cbtn, "ConfigOpenBtn")
		end
	end)
end)

do
	local xrayOriginal = setmetatable({}, { __mode = "k" })
	local xrayConns = {}
	local xrayLoopId = 0
	local XRAY_ALPHA = 0.75
	local XRAY_FOLDERS = {
		"Base",
		"PlotSign",
		"FriendPanel",
		"Cash",
		"Laser",
		"Decorations",
		"Skin",
		"Unlock",
		"Purchases",
		"Walls",
		"Wall",
		"Floor",
		"Roof",
		"Ceiling",
	}

	local function setTransparency(instance, alpha, loopId)
		if not instance then
			return
		end
		if loopId ~= xrayLoopId then
			return
		end
		local function apply(obj)
			if obj:IsA("BasePart") then
				if xrayOriginal[obj] == nil then
					if obj.Transparency == alpha then
						xrayOriginal[obj] = 0
					else
						xrayOriginal[obj] = obj.Transparency
					end
				end
				local orig = xrayOriginal[obj]
				if orig < 1 then
					local target = orig + (1 - orig) * alpha
					if math.abs(obj.Transparency - target) > 0.01 then
						obj.Transparency = target
					end
				end
			end
		end
		apply(instance)
		for i, child in ipairs(instance:GetDescendants()) do
			apply(child)
			if i % 300 == 0 then
				task.wait()
				if loopId ~= xrayLoopId then
					return
				end
			end
		end
	end
	local function trackSubtree(root, alpha, loopId)
		if not root or loopId ~= xrayLoopId then
			return
		end
		setTransparency(root, alpha, loopId)
		if loopId ~= xrayLoopId then
			return
		end
		xrayConns[#xrayConns + 1] = root.DescendantAdded:Connect(function(obj)
			if loopId ~= xrayLoopId then
				return
			end
			setTransparency(obj, alpha, loopId)
		end)
	end
	local function processPlot(plot, alpha, loopId)
		if not plot or loopId ~= xrayLoopId then
			return
		end
		for _, fname in ipairs(XRAY_FOLDERS) do
			if loopId ~= xrayLoopId then
				return
			end
			trackSubtree(plot:FindFirstChild(fname), alpha, loopId)
		end
		if loopId ~= xrayLoopId then
			return
		end
		xrayConns[#xrayConns + 1] = plot.ChildAdded:Connect(function(child)
			if loopId ~= xrayLoopId then
				return
			end
			for _, fname in ipairs(XRAY_FOLDERS) do
				if child.Name == fname then
					trackSubtree(child, alpha, loopId)
					break
				end
			end
		end)
		local podiums = plot:FindFirstChild("AnimalPodiums")
		if podiums then
			local function processPodium(podium)
				for _, child in ipairs(podium:GetChildren()) do
					if child.Name == "Claim" then
						trackSubtree(child, alpha, loopId)
					elseif child.Name == "Base" then
						trackSubtree(child:FindFirstChild("Decorations"), alpha, loopId)
					end
					-- animal models deliberately NOT tracked: xraying the pet
					-- pushes it to 75% transparency and it stays ghosted
					-- while carried, so stolen brainrots look invisible.
				end
			end
			for _, podium in ipairs(podiums:GetChildren()) do
				processPodium(podium)
			end
			xrayConns[#xrayConns + 1] = podiums.ChildAdded:Connect(function(podium)
				if loopId ~= xrayLoopId then
					return
				end
				task.wait(0.1)
				if loopId ~= xrayLoopId then
					return
				end
				processPodium(podium)
			end)
		end
	end
	local function applyAllPlots(alpha, loopId)
		local plotsFolder = Workspace:FindFirstChild("Plots")
		if not plotsFolder then
			return
		end
		for _, plot in ipairs(plotsFolder:GetChildren()) do
			if loopId ~= xrayLoopId then
				return
			end
			processPlot(plot, alpha, loopId)
			task.wait()
		end
		xrayConns[#xrayConns + 1] = plotsFolder.ChildAdded:Connect(function(plot)
			if loopId ~= xrayLoopId then
				return
			end
			task.wait(0.2)
			processPlot(plot, alpha, loopId)
		end)
	end

	local function enableXray()
		for _, c in ipairs(xrayConns) do
			if typeof(c) == "RBXScriptConnection" then
				c:Disconnect()
			end
		end
		xrayConns = {}
		xrayLoopId = xrayLoopId + 1
		local id = xrayLoopId
		Config.XrayEnabled = true
		task.spawn(function()
			pcall(applyAllPlots, XRAY_ALPHA, id)
		end)
	end
	local function disableXray()
		for _, c in ipairs(xrayConns) do
			if typeof(c) == "RBXScriptConnection" then
				c:Disconnect()
			end
		end
		xrayConns = {}
		xrayLoopId = xrayLoopId + 1
		Config.XrayEnabled = false
		local snapshot = xrayOriginal
		xrayOriginal = setmetatable({}, { __mode = "k" })
		for obj, orig in pairs(snapshot) do
			pcall(function()
				if obj:IsA("BasePart") then
					obj.Transparency = orig
				end
			end)
		end
	end
	_G.Haram_EnableXray = enableXray
	_G.Haram_DisableXray = disableXray
	_G.Haram_ToggleXray = function()
		if Config.XrayEnabled then
			disableXray()
		else
			enableXray()
		end
		return Config.XrayEnabled
	end

	task.spawn(function()
		enableXray()
	end)
	LocalPlayer.CharacterAdded:Connect(function()
		task.wait(1)
		if Config.XrayEnabled then
			enableXray()
		end
	end)
end

do
	local espPlayerEnabled = false
	local espPlayerConnections = {}
	local espPlayerHighlights = {}
	local _espMakeBillboard
	local _espGetPlotOwnerName
	local _espRefreshPlayer

	_espMakeBillboard = function(plr)
		if not plr.Character then
			return
		end
		local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		if espPlayerHighlights[plr] then
			pcall(function()
				espPlayerHighlights[plr].billboard:Destroy()
			end)
			espPlayerHighlights[plr] = nil
		end

		local holder = Instance.new("ScreenGui")
		holder.Name = "HaramEspHL_" .. plr.Name
		holder.ResetOnSpawn = false
		holder:SetAttribute("TwilightFastLoadMenu", true)
		holder.Parent = PlayerGui

		local hl = Instance.new("Highlight", holder)
		hl.Adornee = plr.Character
		hl.FillColor = Color3.fromRGB(117, 117, 117)
		hl.FillTransparency = 0.6
		hl.OutlineColor = Color3.fromRGB(196, 196, 196)
		hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

		local bb = Instance.new("BillboardGui", holder)
		bb.Name = "HaramEspBB_" .. plr.Name
		bb.Adornee = hrp
		bb.AlwaysOnTop = true
		bb.Size = UDim2.new(0, 190, 0, 48)
		bb.StudsOffset = Vector3.new(0, 3.2, 0)
		bb.ResetOnSpawn = false

		local nameLbl = Instance.new("TextLabel", bb)
		nameLbl.Size = UDim2.new(1, 0, 1, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = plr.Name
		nameLbl.Font = Enum.Font.GothamBlack
		nameLbl.TextSize = 14
		nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLbl.TextStrokeTransparency = 0.3

		espPlayerHighlights[plr] = { billboard = holder, highlight = hl, nameLabel = nameLbl }

		local _last = 0
		local conn = RunService.Heartbeat:Connect(function()
			if not espPlayerEnabled or not plr.Parent then
				return
			end
			local now = os.clock()
			if now - _last < 0.5 then
				return
			end
			_last = now
			if plr.Character then
				local newHrp = plr.Character:FindFirstChild("HumanoidRootPart")
				if newHrp and bb.Adornee ~= newHrp then
					bb.Adornee = newHrp
					hl.Adornee = plr.Character
				end
			end
			if _espRefreshPlayer then
				pcall(_espRefreshPlayer, plr)
			end
		end)
		table.insert(espPlayerConnections, conn)

		local caConn = plr.CharacterAdded:Connect(function(newChar)
			if not espPlayerEnabled then
				return
			end
			if espPlayerHighlights[plr] then
				pcall(function()
					espPlayerHighlights[plr].billboard:Destroy()
				end)
				espPlayerHighlights[plr] = nil
			end
			newChar:WaitForChild("HumanoidRootPart", 5)
			if espPlayerEnabled then
				pcall(_espMakeBillboard, plr)
			end
		end)
		table.insert(espPlayerConnections, caConn)
	end

	local function enableESPPlayer()
		if espPlayerEnabled then
			return
		end
		espPlayerEnabled = true
		Config.ESPPlayerEnabled = true
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				pcall(_espMakeBillboard, plr)
			end
		end
		table.insert(
			espPlayerConnections,
			Players.PlayerAdded:Connect(function(plr)
				if not espPlayerEnabled then
					return
				end
				task.wait(1)
				pcall(_espMakeBillboard, plr)
			end)
		)
		table.insert(
			espPlayerConnections,
			Players.PlayerRemoving:Connect(function(plr)
				if espPlayerHighlights[plr] then
					pcall(function()
						espPlayerHighlights[plr].billboard:Destroy()
					end)
					espPlayerHighlights[plr] = nil
				end
			end)
		)
	end
	local function disableESPPlayer()
		espPlayerEnabled = false
		Config.ESPPlayerEnabled = false
		for _, conn in ipairs(espPlayerConnections) do
			if typeof(conn) == "RBXScriptConnection" then
				conn:Disconnect()
			end
		end
		espPlayerConnections = {}
		for _, data in pairs(espPlayerHighlights) do
			pcall(function()
				data.billboard:Destroy()
			end)
		end
		espPlayerHighlights = {}
	end

	local espBaseOwnerEnabled = false
	local espBaseOwnerConn, espBaseOwnerHolder = nil, nil

	local function _espGetPlotUnderPlayer()
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return nil
		end
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then
			return nil
		end
		local nearest, nearestDist = nil, math.huge
		for _, plot in ipairs(plots:GetChildren()) do
			local okBox, boxCf, boxSize = pcall(function()
				return plot:GetBoundingBox()
			end)
			if okBox and boxCf and boxSize then
				local rel = boxCf:PointToObjectSpace(hrp.Position)
				if math.abs(rel.X) <= (boxSize.X * 0.5 + 3) and math.abs(rel.Z) <= (boxSize.Z * 0.5 + 3) then
					local flatDist = Vector3.new(rel.X, 0, rel.Z).Magnitude
					if flatDist < nearestDist then
						nearestDist = flatDist
						nearest = plot
					end
				end
			end
			local ok, cf = pcall(function()
				return plot:GetPivot()
			end)
			local px, pz
			if ok and cf then
				px, pz = cf.Position.X, cf.Position.Z
			else
				local sign = plot:FindFirstChild("PlotSign")
				local sp = sign and (sign:IsA("BasePart") and sign or sign:FindFirstChildWhichIsA("BasePart", true))
				if sp then
					px, pz = sp.Position.X, sp.Position.Z
				end
			end
			if px then
				local d = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(px, 0, pz)).Magnitude
				-- Fallback for plots whose model bounds are incomplete. The cap
				-- prevents a remote/nearest base from being treated as occupied.
				if not nearest and d <= (tonumber(_G.HaramBaseOwnerRange) or 65) and d < nearestDist then
					nearestDist = d
					nearest = plot
				end
			end
		end
		return nearest
	end

	_espGetPlotOwnerName = function(plot)
		if not plot then
			return nil
		end
		local ch = _G.Haram_GetPlotChannel and _G.Haram_GetPlotChannel(plot.Name)
		if ch then
			local o = _G.Haram_ChannelGet and _G.Haram_ChannelGet(ch, "Owner")
			if typeof(o) == "Instance" and o:IsA("Player") then
				return o.Name
			end
			if type(o) == "table" and o.Name then
				return tostring(o.Name)
			end
			if type(o) == "string" and o ~= "" then
				return o
			end
			if type(o) == "number" then
				local p = Players:GetPlayerByUserId(o)
				if p then
					return p.Name
				end
			end
		end
		local sign = plot:FindFirstChild("PlotSign")
		local lbl = sign
			and sign:FindFirstChild("SurfaceGui")
			and sign.SurfaceGui:FindFirstChild("Frame")
			and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
		if lbl then
			local nick = lbl.Text:match("^(.-)'") or lbl.Text
			if nick and nick ~= "" then
				for _, p in ipairs(Players:GetPlayers()) do
					if p.DisplayName == nick or p.Name == nick then
						return p.Name
					end
				end
			end
		end
		return nil
	end

	_espRefreshPlayer = function(plr)
		local data = espPlayerHighlights[plr]
		if not data then
			return
		end
		local char = plr.Character
		local stealingIndex = plr:GetAttribute("StealingIndex")
		if stealingIndex == nil and char then
			stealingIndex = char:GetAttribute("StealingIndex")
		end
		local stealing = plr:GetAttribute("Stealing") == true
			or (char and char:GetAttribute("Stealing") == true)
			or (stealingIndex ~= nil and tostring(stealingIndex) ~= "")
		local currentPlot = _espGetPlotUnderPlayer()
		local currentOwner = currentPlot and _espGetPlotOwnerName(currentPlot) or nil
		local isOwner = currentOwner == plr.Name

		local fill, outline, textColor, text
		if stealing then
			fill = Color3.fromRGB(90, 90, 90)
			outline = Color3.fromRGB(188, 188, 188)
			textColor = Color3.fromRGB(105, 105, 105)
			local stolenName = stealingIndex ~= nil and tostring(stealingIndex) or "Brainrot"
			text = "@" .. plr.Name .. "\nSTEALING: " .. stolenName
		elseif isOwner then
			fill = Color3.fromRGB(173, 173, 173)
			outline = Color3.fromRGB(228, 228, 228)
			textColor = Color3.fromRGB(208, 208, 208)
			text = "@" .. plr.Name .. "\nBASE OWNER"
		else
			fill = Color3.fromRGB(163, 163, 163)
			outline = Color3.fromRGB(223, 223, 223)
			textColor = Color3.fromRGB(245, 245, 245)
			text = "@" .. plr.Name
		end
		data.highlight.FillColor = fill
		data.highlight.OutlineColor = outline
		data.nameLabel.TextColor3 = textColor
		data.nameLabel.Text = text
	end

	local function _espBaseOwnerClear()
		if espBaseOwnerHolder then
			pcall(function()
				espBaseOwnerHolder:Destroy()
			end)
			espBaseOwnerHolder = nil
		end
		for _, sg in ipairs(PlayerGui:GetChildren()) do
			if sg.Name == "HaramEspBaseOwner" then
				pcall(function()
					sg:Destroy()
				end)
			end
		end
	end

	local function _espApplyBaseOwner(ownerName, plot)
		if not ownerName or not plot then
			return
		end
		if ownerName == LocalPlayer.Name then
			return
		end

		local sign = plot:FindFirstChild("PlotSign")
		local signPart = sign and (sign:IsA("BasePart") and sign or sign:FindFirstChildWhichIsA("BasePart", true))
		if not signPart then
			return
		end

		local holder = espBaseOwnerHolder
		if not holder or not holder.Parent then
			holder = Instance.new("ScreenGui")
			holder.Name = "HaramEspBaseOwner"
			holder.ResetOnSpawn = false
			holder:SetAttribute("TwilightFastLoadMenu", true)
			holder.Parent = PlayerGui
			espBaseOwnerHolder = holder
		end

		local existing = holder:FindFirstChild("Owner_" .. plot.Name)
		if existing then
			existing:Destroy()
		end

		local bb = Instance.new("BillboardGui", holder)
		bb.Name = "Owner_" .. plot.Name
		bb.Adornee = signPart
		bb.AlwaysOnTop = true
		bb.Size = UDim2.new(0, 200, 0, 28)
		bb.StudsOffset = Vector3.new(0, 4, 0)

		local nameLbl = Instance.new("TextLabel", bb)
		nameLbl.Size = UDim2.new(1, 0, 1, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = "BASE OWNER: @" .. ownerName
		nameLbl.Font = Enum.Font.GothamBlack
		nameLbl.TextSize = 14
		nameLbl.TextColor3 = Color3.fromRGB(208, 208, 208)
		nameLbl.TextStrokeTransparency = 0.3
	end

	local function enableESPBaseOwner()
		if espBaseOwnerEnabled then
			return
		end
		espBaseOwnerEnabled = true
		Config.ESPBaseOwnerEnabled = true
		_espBaseOwnerClear()
		local tickCount = 0
		local lastOwnerName, lastOwnerPlotName = nil, nil
		local function _hookBoCA(plr)
			plr.CharacterAdded:Connect(function()
				task.wait(0.5)
				if espBaseOwnerEnabled then
					lastOwnerName, lastOwnerPlotName = nil, nil
					_espBaseOwnerClear()
				end
			end)
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			_hookBoCA(plr)
		end
		Players.PlayerAdded:Connect(_hookBoCA)

		espBaseOwnerConn = RunService.Heartbeat:Connect(function()
			if not espBaseOwnerEnabled then
				return
			end
			tickCount = tickCount + 1
			if tickCount < 60 then
				return
			end
			tickCount = 0
			local plot = _espGetPlotUnderPlayer()
			local ownerName = plot and _espGetPlotOwnerName(plot) or nil
			local plotName = plot and plot.Name or nil
			if ownerName ~= lastOwnerName or plotName ~= lastOwnerPlotName then
				_espBaseOwnerClear()
				lastOwnerName, lastOwnerPlotName = ownerName, plotName
				if ownerName and plot then
					pcall(_espApplyBaseOwner, ownerName, plot)
				end
			end
		end)
	end
	local function disableESPBaseOwner()
		espBaseOwnerEnabled = false
		Config.ESPBaseOwnerEnabled = false
		if espBaseOwnerConn then
			espBaseOwnerConn:Disconnect()
			espBaseOwnerConn = nil
		end
		_espBaseOwnerClear()
	end

	_G.Haram_EnableESPPlayer = enableESPPlayer
	_G.Haram_DisableESPPlayer = disableESPPlayer
	_G.Haram_EnableESPBaseOwner = enableESPBaseOwner
	_G.Haram_DisableESPBaseOwner = disableESPBaseOwner
	_G.Haram_ToggleESPPlayer = function()
		if Config.ESPPlayerEnabled then
			disableESPPlayer()
		else
			enableESPPlayer()
		end
		return Config.ESPPlayerEnabled
	end
	_G.Haram_ToggleESPBaseOwner = function()
		if Config.ESPBaseOwnerEnabled then
			disableESPBaseOwner()
		else
			enableESPBaseOwner()
		end
		return Config.ESPBaseOwnerEnabled
	end

	task.spawn(function()
		task.wait(6)
		pcall(enableESPPlayer)
		pcall(enableESPBaseOwner)
	end)
end

do
	local subspaceMineESPData = {}
	local function refreshSubspaceMineESP()
		local tools = Workspace:FindFirstChild("ToolsAdds")
		if not tools then
			return
		end
		local currentMines = {}
		for _, obj in ipairs(tools:GetChildren()) do
			if obj.Name:match("SubspaceTripmine") and obj:IsA("BasePart") then
				currentMines[obj] = true
				if not subspaceMineESPData[obj] then
					local ownerName = obj.Name:match("SubspaceTripmine(.+)") or "Unknown"
					local sel = Instance.new("SelectionBox", obj)
					sel.Color3 = Color3.fromRGB(200, 200, 200)
					sel.LineThickness = 0.05
					local bb = Instance.new("BillboardGui", obj)
					bb.Size = UDim2.new(0, 250, 0, 50)
					bb.StudsOffset = Vector3.new(0, 2.5, 0)
					bb.AlwaysOnTop = false
					local lbl = Instance.new("TextLabel", bb)
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 1
					lbl.Text = ownerName .. "'s Subspace Mine"
					lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
					lbl.TextStrokeTransparency = 0
					lbl.Font = Enum.Font.GothamBold
					lbl.TextSize = 16
					subspaceMineESPData[obj] = { sel = sel, bb = bb }
				end
			end
		end
		for mineObj, data in pairs(subspaceMineESPData) do
			if not currentMines[mineObj] or not mineObj.Parent then
				pcall(function()
					data.sel:Destroy()
				end)
				pcall(function()
					data.bb:Destroy()
				end)
				subspaceMineESPData[mineObj] = nil
			end
		end
	end
	task.spawn(function()
		while true do
			pcall(refreshSubspaceMineESP)
			task.wait(0.5)
		end
	end)
end

do
	if not _G.__HaramCarpetV2Ready then
		-- Ported from OnixHub: selected item is preferred, then supported fallbacks.
		local CARPET_ITEMS = {
			"Flying Carpet",
			"Waverider",
			"Santa's Sleigh",
			"Witch's Broom",
			"Cupid's Wings",
		}
		local carpetOn, carpetConn = false, nil

		local function findCarpetTool(name)
			local c = LocalPlayer.Character
			local bp = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:FindFirstChildOfClass("Backpack")
			local sg = LocalPlayer:FindFirstChild("StarterGear")
			return (c and c:FindFirstChild(name))
				or (bp and bp:FindFirstChild(name))
				or (sg and sg:FindFirstChild(name))
		end

		local function setCarpetTool(name)
			if type(name) ~= "string" or name == "" then
				return
			end
			Config.CarpetTool = name
			for i = #CARPET_ITEMS, 1, -1 do
				if CARPET_ITEMS[i] == name then
					table.remove(CARPET_ITEMS, i)
				end
			end
			table.insert(CARPET_ITEMS, 1, name)
			pcall(SaveConfig)
			if _G.Haram_SyncCarpetToolBtn then
				pcall(_G.Haram_SyncCarpetToolBtn)
			end
		end

		local function currentCarpetTool()
			return (type(Config.CarpetTool) == "string" and Config.CarpetTool ~= "" and Config.CarpetTool)
				or CARPET_ITEMS[1]
				or "Flying Carpet"
		end

		local function cycleCarpetTool()
			local fixedOrder = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
			local cur, idx = currentCarpetTool(), 1
			for i, name in ipairs(fixedOrder) do
				if name == cur then
					idx = i
					break
				end
			end
			local nextName = fixedOrder[(idx % #fixedOrder) + 1]
			setCarpetTool(nextName)
			return nextName
		end

		local function equipCarpet()
			local c = LocalPlayer.Character
			local hum = c and c:FindFirstChildOfClass("Humanoid")
			if not hum then
				return nil
			end
			for _, name in ipairs(CARPET_ITEMS) do
				local tool = findCarpetTool(name)
				if tool and tool:IsA("Tool") then
					if tool.Parent ~= c then
						pcall(function()
							hum:EquipTool(tool)
						end)
					end
					if tool.Parent == c then
						return name
					end
				end
			end
			return nil
		end

		local function setCarpetSpeed(enabled)
			carpetOn = enabled and true or false
			Config.CarpetSpeedEnabled = carpetOn
			if carpetConn then
				carpetConn:Disconnect()
				carpetConn = nil
			end
			if type(_G.HaramCarpetSpeedReset) == "function" then
				pcall(_G.HaramCarpetSpeedReset)
			end
			if _G.Haram_SyncCarpetBtn then
				pcall(_G.Haram_SyncCarpetBtn, carpetOn)
			end
			if not carpetOn then
				return
			end

			carpetConn = RunService.Heartbeat:Connect(function()
				local c = LocalPlayer.Character
				if not c then
					return
				end
				local hum = c:FindFirstChildOfClass("Humanoid")
				local hrp = c:FindFirstChild("HumanoidRootPart")
				if not hum or not hrp then
					return
				end
				if LocalPlayer:GetAttribute("Stealing") then
					setCarpetSpeed(false)
					return
				end
				if _G.Haram_IsResetting or _G.HaramAutoBuyTPBlocked or (_G.HaramIsTeleporting and _G.HaramIsTeleporting()) then
					return
				end
				if _G.HaramPostTPCooldown and os.clock() < _G.HaramPostTPCooldown then
					return
				end

				-- Same mover as the TP (gear engage + sweep + ramp) when the hub is loaded.
				if type(_G.HaramCarpetSpeedStep) == "function" then
					local ok, handled = pcall(_G.HaramCarpetSpeedStep, hum, hrp)
					if ok and handled then
						return
					end
				end

				local equippedName = equipCarpet()
				if equippedName and c:FindFirstChild(equippedName) then
					local md = hum.MoveDirection
					local speed = tonumber(Config.CarpetSpeed) or 120
					if md.Magnitude > 0 then
						hrp.AssemblyLinearVelocity =
							Vector3.new(md.X * speed, hrp.AssemblyLinearVelocity.Y, md.Z * speed)
					else
						hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
					end
				end
			end)
		end

		_G.Haram_SetCarpetTool = setCarpetTool
		_G.Haram_CurrentCarpetTool = currentCarpetTool
		_G.Haram_CycleCarpetTool = cycleCarpetTool
		_G.Haram_SetCarpetSpeed = setCarpetSpeed
		_G.Haram_ToggleCarpetSpeed = function()
			setCarpetSpeed(not carpetOn)
			pcall(SaveConfig)
			return carpetOn
		end

		setCarpetTool(currentCarpetTool())
		setCarpetSpeed(false)
		pcall(function()
			LocalPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
				if LocalPlayer:GetAttribute("Stealing") and carpetOn then
					setCarpetSpeed(false)
					pcall(SaveConfig)
				end
			end)
		end)
	end
end

task.spawn(function()
	if _G._AntiBeeDiscoInstant then
		return
	end
	_G._AntiBeeDiscoInstant = true

	local Lighting = HaramService("Lighting")

	local badLightingNames = {
		Blue = true,
		DiscoEffect = true,
		BeeBlur = true,
		ColorCorrection = true,
	}

	local function nukeObj(obj)
		if not obj or not obj.Parent then
			return
		end
		if badLightingNames[obj.Name] then
			pcall(function()
				obj:Destroy()
			end)
		end
	end

	for _, inst in ipairs(Lighting:GetDescendants()) do
		nukeObj(inst)
	end
	Lighting.DescendantAdded:Connect(nukeObj)

	RunService.Heartbeat:Connect(function()
		pcall(function()
			local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
			if not playerScripts then
				return
			end
			local beeScript = playerScripts:FindFirstChild("Bee", true)
			if beeScript then
				local buzzing = beeScript:FindFirstChild("Buzzing")
				if buzzing and buzzing:IsA("Sound") then
					buzzing:Stop()
					buzzing.Volume = 0
				end
			end
		end)
	end)
end)

task.spawn(function()
	if _G._AntiEffectsAlwaysOn then
		return
	end
	_G._AntiEffectsAlwaysOn = true

	pcall(function()
		local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts", 10)
			and LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
		if not PlayerModule then
			return
		end
		local Controls = require(PlayerModule):GetControls()
		if not Controls then
			return
		end
		local originalMoveFunction = Controls.moveFunction
		local protectedMove = function(self, moveVector, relativeToCamera)
			if originalMoveFunction then
				originalMoveFunction(self, moveVector, relativeToCamera)
			end
		end
		Controls.moveFunction = protectedMove
		RunService.Heartbeat:Connect(function()
			if Controls.moveFunction ~= protectedMove then
				Controls.moveFunction = protectedMove
			end
		end)
	end)
end)

task.spawn(function()
	if _G._LineToBaseAlwaysOn then
		return
	end
	_G._LineToBaseAlwaysOn = true

	local function getMyPlotCenter()
		local plots = Workspace:FindFirstChild("Plots")
		if not plots then
			return nil
		end
		for _, plot in ipairs(plots:GetChildren()) do
			local sign = plot:FindFirstChild("PlotSign")
			if sign then
				local yourBase = sign:FindFirstChild("YourBase")
				if yourBase and yourBase.Enabled then
					local basePart = plot:FindFirstChild("Base") or plot:FindFirstChildWhichIsA("BasePart", true)
					if basePart then
						return basePart.Position
					end
					local ok, cf = pcall(function()
						return plot:GetPivot()
					end)
					if ok then
						return cf.Position
					end
				end
			end
		end
		return nil
	end

	local linePart = Instance.new("Part")
	linePart.Name = "LineToBase"
	linePart.Anchored = true
	linePart.CanCollide = false
	linePart.CanQuery = false
	linePart.CanTouch = false
	linePart.CastShadow = false
	linePart.Shape = Enum.PartType.Cylinder
	linePart.Color = Color3.fromRGB(255, 255, 255)
	linePart.Transparency = 0.1
	linePart.Material = Enum.Material.Neon
	linePart.Size = Vector3.new(0.01, 0.01, 0.01)
	linePart.Parent = Workspace

	RunService.RenderStepped:Connect(function()
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			linePart.Size = Vector3.new(0.01, 0.01, 0.01)
			return
		end

		local basePos = getMyPlotCenter()
		if not basePos then
			linePart.Size = Vector3.new(0.01, 0.01, 0.01)
			return
		end

		local from = hrp.Position
		local to = basePos
		local dist = (to - from).Magnitude
		if dist < 1 then
			linePart.Size = Vector3.new(0.01, 0.01, 0.01)
			return
		end

		linePart.Size = Vector3.new(0.35, dist, 0.35)
		linePart.CFrame = CFrame.new(from:Lerp(to, 0.5), to) * CFrame.Angles(0, math.rad(90), 0)
	end)

	_G.Haram_GetLineToBasePart = function()
		return linePart
	end
end)

-- PERF HUD: FPS | PING | LOADTIME (replaces old DATA/NET + plot timer)
task.spawn(function()
	pcall(function()
		local pg0 = LocalPlayer:FindFirstChildOfClass("PlayerGui") or PlayerGui
		local old = pg0 and pg0:FindFirstChild("HaramHubPerfHud")
		if old then
			old:Destroy()
		end
	end)

	local bootT0 = _G.HaramBootT0 or (typeof(tick) == "function" and tick() or os.clock())
	local loadSecs = tonumber(_G.HaramLoadedSecs)
	if not loadSecs then
		loadSecs = (typeof(tick) == "function" and tick() or os.clock()) - bootT0
		_G.HaramLoadedSecs = loadSecs
	end
	local loadStr = string.format("%.1fs", math.max(0, loadSecs))

	local perfSg = Instance.new("ScreenGui")
	perfSg.Name = "HaramHubPerfHud"
	perfSg.ResetOnSpawn = false
	perfSg.IgnoreGuiInset = true
	perfSg.DisplayOrder = 999
	perfSg:SetAttribute("TwilightFastLoadMenu", true)
	perfSg.Parent = PlayerGui
	if registerScreenGui then
		pcall(registerScreenGui, perfSg)
	end

	local perfHud = Instance.new("Frame", perfSg)
	perfHud.Name = "PerfHud"
	perfHud.AnchorPoint = Vector2.new(0.5, 0)
	perfHud.Position = UDim2.new(0.5, 0, 0, 8)
	perfHud.Size = UDim2.fromOffset(230, 32)
	perfHud.AutomaticSize = Enum.AutomaticSize.X
	perfHud.BackgroundColor3 = Color3.fromRGB(9, 9, 9)
	perfHud.BackgroundTransparency = 0.04
	perfHud.BorderSizePixel = 0
	perfHud.ZIndex = 50
	do
		local st = Instance.new("UIStroke", perfHud)
		st.Color = Color3.fromRGB(44, 44, 44)
		st.Thickness = 1
		st.Transparency = 0.2
	end
	do
		local c = Instance.new("UICorner", perfHud)
		c.CornerRadius = UDim.new(0, 10)
	end
	do
		local gradient = Instance.new("UIGradient", perfHud)
		gradient.Rotation = 135
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 6)),
		})
	end
	local pad = Instance.new("UIPadding", perfHud)
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 14)

	local lbl = Instance.new("TextLabel", perfHud)
	lbl.Size = UDim2.new(0, 0, 1, 0)
	lbl.AutomaticSize = Enum.AutomaticSize.X
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.ZIndex = 51
	lbl.Text = string.format("FPS: -- | PING: --ms | LOAD: %s", loadStr)

	local _frames = 0
	HaramService("RunService").RenderStepped:Connect(function()
		_frames = _frames + 1
	end)

	local last = os.clock()
	while perfHud.Parent do
		task.wait(0.5)
		local now = os.clock()
		local dt = now - last
		local fps = (dt > 0) and math.floor(_frames / dt + 0.5) or 0
		_frames, last = 0, now

		local ping = 0
		pcall(function()
			ping = math.floor((LocalPlayer:GetNetworkPing() * 1000) + 0.5)
		end)

		lbl.Text = string.format("FPS: %d | PING: %dms | LOAD: %s", fps, ping, loadStr)
	end
end)