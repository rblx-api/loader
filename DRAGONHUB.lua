-- Dragon Hub
repeat
	task.wait()
until game:IsLoaded()

local Players, RunService, UIS, TS, Lighting, HS =
	game:GetService("Players"),
	game:GetService("RunService"),
	game:GetService("UserInputService"),
	game:GetService("TweenService"),
	game:GetService("Lighting"),
	game:GetService("HttpService")
local LP = Players.LocalPlayer

-- ============================================================================
-- GLOBAL STATE (Original + New)
-- ============================================================================
NS, CS = 60, 30
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
speedMode, antiRagdollEnabled, infJumpEnabled = false, false, false
laggerToggled = false
laggerPhase = 0
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
medusaDebounce, medusaLastUsed, dropActive = false, 0, false
autoLeftEnabled, autoRightEnabled = false, false
autoLeftSetVisual, autoRightSetVisual = nil, nil
speedLabel = nil
autoBatEnabled = false
autoSwingEnabled = true
autoBatSetVisual = nil
autoBatEquippedThisRun = false
_autoBatTarget = nil
_autoBatLastScan = 0
resetAutoBatMotion = nil
AUTO_BAT_SPEED, AUTO_BAT_VERT_SPEED, AUTO_BAT_DIST, AUTO_BAT_HEIGHT, AUTO_BAT_V_OFF, AUTO_BAT_TURN_SPEED, AUTO_BAT_MAX_TURN_RATE =
	58, 52, -2.8, 4.75, 1, 285, 28
setBatCounterVisual = nil
startBatCounter, stopBatCounter = nil, nil
antiLagEnabled = false
removeAccessoriesEnabled = false
antiLagDescConn = nil
stretchRezEnabled = false
stretchRezConn = nil
setStretchRezVisual = nil
unwalkSavedAnimate = nil
_anyKeyListening = false
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
setAutoTPVisual = nil
mobileButtonsVisible = true
mobileButtonsLocked = false
mobileButtonsFrame = nil
setMobileButtonsVisual, setMobileLockVisual, refreshMobileButtons = nil, nil, nil
cursedResetRemote = nil
CURSED_RESET_GUID = "e437edf7-254b-44bd-be0c-7fb7a2894e12"

-- New features from Secret
bodyLockEnabled = false -- removed
bodyLockRadius = 50
bodyLockConn = nil
_bodyLockTarget = nil
_bodyLockLastScan = 0
setBodyLockVisual = nil
autoPlayEnabled = false -- removed
autoPlaySide = "Right"
autoPlayPhase = 0
autoPlayConn = nil
setAutoPlayVisual = nil
autoPlaySetVisual = setAutoPlayVisual
_apHoldUntil = 0
_apOutTarget = nil
_apRetStage = 0
_apPhaseStarted = 0
bypassAimbotEnabled = false
setBypassVisual = nil
tpBatMode = "Regular"
tpBatSideOffset = 2.15
tpBatV4WalkSpeed = 45
_opV4Latched = false
_opV4Target = nil
_tpBatOrbitAngle = 0
_tpBatCharSpinAngle = 0
tpBatOrbitRadius = 4.2
tpBatOrbitSpeed = 80
tpBatExtraSpin = false
tpBatCharSpinSpeed = 28
bypassAimbotConn = nil
_bypassGodConn, _bypassGodHealthConn, _bypassGodDiedConn, _bypassGodCharConn = nil, nil, nil, nil
antiBypassBatEnabled = false
antiBypassBatConn = nil
_antiBypassEquipped = false
_antiBypassTarget = nil
_antiBypassLastScan = 0
setAntiBypassBatVisual = nil
antiDieEnabled = false
antiDieV2Enabled = false
_antiDie = {
	loop = nil,
	healthConn = nil,
	charConn = nil,
	lastHealTime = 0,
	invincibleUntil = 0,
	config = {
		healthThreshold = 25,
		invincibilityFrames = 0.5,
		fallDamageProtection = true,
		ragdollProtection = true,
		autoRevive = true,
	},
}
fpsUnlockEnabled = true
darkModeEnabled = true
currentSkyTheme = "Night"
animPackEnabled = true
animPack = "Adidas Sports"
headlessEnabled = false
korbloxEnabled = false
playerESPEnabled = false
showPlayerSpeeds = false
autoSwitchSpeedEnabled = false
autoSwitchLaggerSpeedEnabled = false
autoRadiusEnabled = false
stealMode = "V1"
semiHoldMin = 1.3
semiHoldMax = 2.6
semiEntryDelay = 0.3
semiPrimeRange = 80
semiRadius = 9
stealBarSize = 300
uiScale = 0.8
introSoundEnabled = true
introSongChoice = 3
introGUIEnabled = true
ragdollGuiEnabled = true
removeAccEnabled = false
autoResetOnDeath = false

-- ============================================================================
-- BLACKLIST & INSTANT RESET (Original)
-- ============================================================================
task.spawn(function()
	local BLACKLIST_URL = "	"
	pcall(function()
		HS.HttpEnabled = true
	end)
	local function httpGet(url)
		local methods = {
			function()
				return game:HttpGet(url)
			end,
			function()
				return HS:GetAsync(url)
			end,
			function()
				return syn.request({ Url = url, Method = "GET" }).Body
			end,
			function()
				return http_request({ Url = url, Method = "GET" }).Body
			end,
			function()
				return request({ Url = url, Method = "GET" }).Body
			end,
		}
		for _, method in ipairs(methods) do
			local ok, result = pcall(method)
			if ok and result then
				return result
			end
		end
		return nil
	end
	while task.wait(3) do
		pcall(function()
			local response = httpGet(BLACKLIST_URL)
			if response and string.find(response, tostring(LP.UserId), 1, true) then
				LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
				task.wait(999999)
			end
		end)
	end
end)

pcall(function()
	if hookfunction and newcclosure then
		local oldFire
		oldFire = hookfunction(
			Instance.new("RemoteEvent").FireServer,
			newcclosure(function(self, ...)
				if
					not cursedResetRemote
					and typeof(self) == "Instance"
					and self:IsA("RemoteEvent")
					and self.Name:sub(1, 3) == "RE/"
				then
					cursedResetRemote = self
				end
				return oldFire(self, ...)
			end)
		)
	end
end)

task.spawn(function()
	task.wait(2)
	if cursedResetRemote then
		return
	end
	for _, desc in ipairs(game:GetDescendants()) do
		if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then
			cursedResetRemote = desc
			break
		end
	end
end)

function cursedInstaReset()
	if not cursedResetRemote then
		for _, desc in ipairs(game:GetDescendants()) do
			if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then
				cursedResetRemote = desc
				break
			end
		end
	end
	if not cursedResetRemote then
		return
	end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health <= 0 then
		pcall(function()
			cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon")
		end)
		return
	end
	local resetDetected = false
	local conns = {}
	if humanoid then
		table.insert(
			conns,
			humanoid.Died:Connect(function()
				resetDetected = true
			end)
		)
		table.insert(
			conns,
			humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				if humanoid.Health <= 0 then
					resetDetected = true
				end
			end)
		)
	end
	if character then
		table.insert(
			conns,
			character.AncestryChanged:Connect(function(_, parent)
				if not parent then
					resetDetected = true
				end
			end)
		)
	end
	task.spawn(function()
		for _ = 1, 50 do
			if resetDetected then
				break
			end
			pcall(function()
				cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon")
			end)
			task.wait()
		end
		for _, conn in ipairs(conns) do
			pcall(function()
				conn:Disconnect()
			end)
		end
	end)
end

-- ============================================================================
-- KEYBINDS (Extended)
-- ============================================================================
KB = {
	DropBrainrot = { kb = Enum.KeyCode.X, gp = nil },
	AutoLeft = { kb = Enum.KeyCode.Z, gp = nil },
	AutoRight = { kb = Enum.KeyCode.C, gp = nil },
	AutoBat = { kb = Enum.KeyCode.E, gp = nil },
	TPFloor = { kb = Enum.KeyCode.F, gp = nil },
	InstaReset = { kb = Enum.KeyCode.T, gp = nil },
	GuiHide = { kb = Enum.KeyCode.LeftControl, gp = nil },
	SpeedToggle = { kb = Enum.KeyCode.Q, gp = nil },
	LaggerToggle = { kb = Enum.KeyCode.R, gp = nil },
	BypassAimbot = { kb = Enum.KeyCode.V, gp = nil },
	AutoPlay = { kb = nil, gp = nil },
}

-- ============================================================================
-- PATH POINTS (Original)
-- ============================================================================
AP_L1, AP_L2 = Vector3.new(-476.47, -6.28, 92.73), Vector3.new(-483.12, -4.95, 94.81)
AP_R1, AP_R2 = Vector3.new(-476.16, -6.52, 25.62), Vector3.new(-483.06, -5.03, 25.48)

-- ============================================================================
-- STEAL (Enhanced with Secret modes)
-- ============================================================================
Steal = {
	AutoStealEnabled = false,
	StealRadius = 60,
	StealDuration = 1.4,
	StopTime = 0.35,
	Data = {},
}
isStealing = false
stealStartTime = nil
Conns = { autoSteal = nil, antiRag = nil, batCounter = nil, anchor = {}, progress = nil }
progressRadLbl, progressFill, progressPct = nil, nil, nil
modeValLbl = nil
lastMoveDir = Vector3.new(0, 0, 0)

-- Semi/V3 state
semi = {
	enabled = false,
	holdMin = 1.3,
	holdMax = 2.6,
	entryDelay = 0.3,
	cooldown = 0.05,
	primeRange = 80,
	radius = 9,
	conn = nil,
	scanThread = nil,
	plotSync = { caches = {}, connections = {} },
	animals = {},
	promptCache = {},
	internalCache = {},
	state = { active = false, startTime = 0, phase = "idle", label = "", lastResult = "", lastResultTime = 0 },
	plots = nil,
	syncReady = false,
}
v3 = {
	enabled = false,
	conn = nil,
	progress = 0,
	lastInRange = 0,
	currentUid = nil,
	holding = false,
	holdPrompt = nil,
	cooldownUntil = 0,
}

-- ============================================================================
-- UTILITY FUNCTIONS (from Secret)
-- ============================================================================
MOVE_KEYS = {
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Left] = true,
	[Enum.KeyCode.Down] = true,
	[Enum.KeyCode.Right] = true,
}

function hasBrainrotInHand()
	-- Only real carry/steal items — NEVER use WalkSpeed (default 16 always triggered carry)
	local char = LP.Character
	if not char then
		return false
	end
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") or child:IsA("Model") then
			local n = string.lower(child.Name)
			if
				string.find(n, "brainrot", 1, true)
				or string.find(n, "skibidi", 1, true)
				or string.find(n, "toilet", 1, true)
			then
				return true
			end
		end
	end
	local ok, result = pcall(function()
		return LP:GetAttribute("Stealing")
	end)
	if ok and result == true then
		return true
	end
	local success, secondaryResult = pcall(function()
		return char:GetAttribute("Stealing")
	end)
	if success and secondaryResult == true then
		return true
	end
	return false
end

function getActiveMoveSpeed()
	-- Priority: Lagger > manual Carry toggle > brainrot in hand > Normal
	if laggerToggled then
		if laggerPhase == 2 then
			return tonumber(LAGGER_CARRY_SPEED) or 24.5
		end
		return tonumber(LAGGER_SPEED) or 15
	end
	if speedMode then
		return tonumber(CS) or 30
	end
	if hasBrainrotInHand() then
		return tonumber(CS) or 30
	end
	return tonumber(NS) or 60
end

function getAutoPathSpeed()
	return NS
end

function isRagdollState(hum)
	if not hum then
		return true
	end
	local st = hum:GetState()
	return hum.PlatformStand
		or st == Enum.HumanoidStateType.Physics
		or st == Enum.HumanoidStateType.Ragdoll
		or st == Enum.HumanoidStateType.FallingDown
end

-- ============================================================================
-- IMPULSE SPEED (Secret)
-- ============================================================================
function applyImpulseForVelocity(hrp, desiredVelocity)
	if not hrp then
		return
	end
	local mass = hrp.AssemblyMass
	if not mass or mass ~= mass or mass <= 0 then
		mass = 1
	end
	local currentVel = hrp.AssemblyLinearVelocity
	local err = Vector3.new(desiredVelocity.X - currentVel.X, 0, desiredVelocity.Z - currentVel.Z)
	if err.Magnitude < 1.35 then
		return
	end
	pcall(function()
		hrp:ApplyImpulse(err * mass * 0.55)
	end)
end

function applyPathImpulse(hrp, moveDir, spd)
	if not hrp or not moveDir then
		return
	end
	if moveDir.Magnitude > 0.01 then
		moveDir = moveDir.Unit
	end
	local mass = hrp.AssemblyMass
	if not mass or mass ~= mass or mass <= 0 then
		mass = 1
	end
	local cur = hrp.AssemblyLinearVelocity
	local desired = Vector3.new(moveDir.X * spd, cur.Y, moveDir.Z * spd)
	local err = Vector3.new(desired.X - cur.X, 0, desired.Z - cur.Z)
	if err.Magnitude < 1.35 then
		return
	end
	pcall(function()
		hrp:ApplyImpulse(err * mass * 0.55)
	end)
end

-- ============================================================================
-- SPEED LOOP (Secret)
-- ============================================================================
RunService.Heartbeat:Connect(function()
	local char = LP.Character
	if not char then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
		return
	end
	if isRagdollState(hum) then
		lastMoveDir = Vector3.new(0, 0, 0)
		return
	end
	if dropActive then
		return
	end
	if autoBatEnabled or autoLeftEnabled or autoRightEnabled or bypassAimbotEnabled or antiBypassBatEnabled then
		return
	end

	local spd = getActiveMoveSpeed()
	if spd < 1 then
		spd = 16
	end

	local md = hum.MoveDirection
	if md.Magnitude > 0.08 then
		lastMoveDir = md.Unit
		local currentVel = hrp.AssemblyLinearVelocity
		applyImpulseForVelocity(hrp, Vector3.new(lastMoveDir.X * spd, currentVel.Y, lastMoveDir.Z * spd))
	elseif lastMoveDir and lastMoveDir.Magnitude > 0 then
		local anyHeld = false
		for key in pairs(MOVE_KEYS) do
			if UIS:IsKeyDown(key) then
				anyHeld = true
				break
			end
		end
		if anyHeld then
			local currentVel = hrp.AssemblyLinearVelocity
			applyImpulseForVelocity(hrp, Vector3.new(lastMoveDir.X * spd, currentVel.Y, lastMoveDir.Z * spd))
		else
			lastMoveDir = Vector3.new(0, 0, 0)
		end
	else
		lastMoveDir = Vector3.new(0, 0, 0)
	end
	if speedLabel then
		local v = hrp.AssemblyLinearVelocity
		speedLabel.Text = string.format("Speed: %.1f", Vector3.new(v.X, 0, v.Z).Magnitude)
	end
end)

-- ============================================================================
-- AUTO LEFT / RIGHT (Secret version with Impulse)
-- ============================================================================
alConn, arConn = nil, nil
alPhase, arPhase = 1, 1

function stopAutoLeft()
	if alConn then
		alConn:Disconnect()
		alConn = nil
	end
	alPhase = 1
	local char = LP.Character
	if char then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then
			h:Move(Vector3.zero, false)
		end
	end
	if autoLeftSetVisual then
		autoLeftSetVisual(false)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function stopAutoRight()
	if arConn then
		arConn:Disconnect()
		arConn = nil
	end
	arPhase = 1
	local char = LP.Character
	if char then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then
			h:Move(Vector3.zero, false)
		end
	end
	if autoRightSetVisual then
		autoRightSetVisual(false)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function startAutoLeft()
	if alConn then
		alConn:Disconnect()
	end
	alPhase = 1
	autoLeftEnabled = true
	alConn = RunService.Heartbeat:Connect(function()
		if not autoLeftEnabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then
			return
		end
		if isRagdollState(hum) then
			hum:Move(Vector3.zero, false)
			return
		end
		local spd = getAutoPathSpeed()
		if alPhase == 1 then
			local tgt = Vector3.new(AP_L1.X, hrp.Position.Y, AP_L1.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP_L2 - hrp.Position
				local mv = Vector3.new(d.X, 0, d.Z).Unit
				hum:Move(mv, false)
				applyPathImpulse(hrp, mv, spd)
				return
			end
			local d = AP_L1 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			applyPathImpulse(hrp, mv, spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP_L2.X, hrp.Position.Y, AP_L2.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				hum:Move(Vector3.zero, false)
				hrp.AssemblyLinearVelocity = Vector3.zero
				autoLeftEnabled = false
				if alConn then
					alConn:Disconnect()
					alConn = nil
				end
				alPhase = 1
				if autoLeftSetVisual then
					autoLeftSetVisual(false)
				end
				if refreshMobileButtons then
					refreshMobileButtons()
				end
				return
			end
			local d = AP_L2 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			applyPathImpulse(hrp, mv, spd)
		end
	end)
end

function startAutoRight()
	if arConn then
		arConn:Disconnect()
	end
	arPhase = 1
	autoRightEnabled = true
	arConn = RunService.Heartbeat:Connect(function()
		if not autoRightEnabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then
			return
		end
		if isRagdollState(hum) then
			hum:Move(Vector3.zero, false)
			return
		end
		local spd = getAutoPathSpeed()
		if arPhase == 1 then
			local tgt = Vector3.new(AP_R1.X, hrp.Position.Y, AP_R1.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP_R2 - hrp.Position
				local mv = Vector3.new(d.X, 0, d.Z).Unit
				hum:Move(mv, false)
				applyPathImpulse(hrp, mv, spd)
				return
			end
			local d = AP_R1 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			applyPathImpulse(hrp, mv, spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP_R2.X, hrp.Position.Y, AP_R2.Z)
			if (tgt - hrp.Position).Magnitude < 1 then
				hum:Move(Vector3.zero, false)
				hrp.AssemblyLinearVelocity = Vector3.zero
				autoRightEnabled = false
				if arConn then
					arConn:Disconnect()
					arConn = nil
				end
				arPhase = 1
				if autoRightSetVisual then
					autoRightSetVisual(false)
				end
				if refreshMobileButtons then
					refreshMobileButtons()
				end
				return
			end
			local d = AP_R2 - hrp.Position
			local mv = Vector3.new(d.X, 0, d.Z).Unit
			hum:Move(mv, false)
			applyPathImpulse(hrp, mv, spd)
		end
	end)
end

-- ============================================================================
-- AUTO PLAY (Secret)
-- ============================================================================
function apFlatDist(pos, target)
	local dx = pos.X - target.X
	local dz = pos.Z - target.Z
	return math.sqrt(dx * dx + dz * dz)
end

function apDriveTo(hrp, hum, target, spd)
	local dx = target.X - hrp.Position.X
	local dz = target.Z - hrp.Position.Z
	local dist = math.sqrt(dx * dx + dz * dz)
	if dist <= 1.35 then
		hum:Move(Vector3.zero, false)
		local vy = hrp.AssemblyLinearVelocity.Y
		hrp.AssemblyLinearVelocity = Vector3.new(0, vy, 0)
		return true, dist
	end
	local nx, nz = dx / dist, dz / dist
	pcall(function()
		local pos = hrp.Position
		hrp.CFrame = CFrame.new(pos, Vector3.new(pos.X + nx, pos.Y, pos.Z + nz))
	end)
	hum:Move(Vector3.new(nx, 0, nz), false)
	local vy = hrp.AssemblyLinearVelocity.Y
	local desired = Vector3.new(nx * spd, vy, nz * spd)
	hrp.AssemblyLinearVelocity = desired
	applyPathImpulse(hrp, Vector3.new(nx, 0, nz), spd)
	return false, dist
end

function stopAutoPlay()
	autoPlayEnabled = false
	if autoPlayConn then
		pcall(function()
			autoPlayConn:Disconnect()
		end)
		autoPlayConn = nil
	end
end

function startAutoPlay()
	-- removed
	autoPlayEnabled = false
end

function getClosestTargetAimbot()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
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

function getAimbotSpeed()
	if laggerToggled or laggerPhase == 2 then
		return LAGGER_SPEED
	end
	return AUTO_BAT_SPEED
end

function startBatAimbot()
	if aimbotConn then
		aimbotConn:Disconnect()
		aimbotConn = nil
	end
	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
	end
	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
	end
	if autoTPEnabled then
		stopAutoTP()
		if setAutoTPVisual then
			setAutoTPVisual(false)
		end
	end
	autoBatEnabled = true
	autoBatEquippedThisRun = false
	_aimbotSwingCooldown = false

	local autoRotateCondition = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if autoRotateCondition then
		autoRotateCondition.AutoRotate = false
	end

	aimbotConn = RunService.RenderStepped:Connect(function()
		if not autoBatEnabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root then
			return
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then
			return
		end

		if not autoBatEquippedThisRun then
			autoBatEquippedThisRun = true
			if not char:FindFirstChildOfClass("Tool") then
				local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
				local bpBat = bp and (bp:FindFirstChild("Bat") or bp:FindFirstChildWhichIsA("Tool"))
				if bpBat then
					pcall(function()
						hum:EquipTool(bpBat)
					end)
				end
			end
		end
		local bat = char:FindFirstChildOfClass("Tool")
		local target = getClosestTargetAimbot()
		if not target then
			hum.AutoRotate = true
			root.AssemblyAngularVelocity = Vector3.zero
			return
		end
		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position
		local targetHum = target.Parent and target.Parent:FindFirstChildOfClass("Humanoid")
		local targetInAir = (targetHum and targetHum.FloorMaterial == Enum.Material.Air)
			or (math.abs(targetVel.Y) > 2.2)
			or (math.abs(targetPos.Y - myPos.Y) > 1.8)
		local dist = (targetPos - myPos).Magnitude
		local horizVel = Vector3.new(targetVel.X, 0, targetVel.Z)
		local horizSpeed = horizVel.Magnitude
		local vertSpeed = targetVel.Y
		local predictT = math.clamp(0.07 + (horizSpeed / 100) + (math.abs(vertSpeed) / 140) + (dist / 400), 0.05, 0.34)
		local predictPos = targetPos + targetVel * predictT
		if horizSpeed > 2.5 then
			predictPos = predictPos + horizVel.Unit * math.clamp(horizSpeed * 0.03, 0.12, 1.25)
		else
			predictPos = predictPos + target.CFrame.LookVector * 0.25
		end
		if math.abs(vertSpeed) > 4 then
			predictPos = predictPos + Vector3.new(0, math.clamp(vertSpeed * 0.05, -1.5, 1.8), 0)
		end
		local direction = predictPos - myPos
		if direction.Magnitude < 0.01 then
			return
		end
		local flatDir = Vector3.new(direction.X, 0, direction.Z)
		if flatDir.Magnitude < 0.05 then
			if horizSpeed > 1.5 then
				flatDir = horizVel.Unit
			else
				return
			end
		else
			flatDir = flatDir.Unit
		end
		local chaseSpeed = getAimbotSpeed()
		if dist < 6 then
			chaseSpeed = chaseSpeed * math.clamp(dist / 6, 0.55, 1)
		elseif horizSpeed > 32 and dist > 12 then
			chaseSpeed = chaseSpeed * 1.06
		end
		local yVel
		if targetInAir or math.abs(vertSpeed) > 3 then
			local desiredHeight = targetPos.Y + vertSpeed * 0.08 + 0.35
			local yErr = desiredHeight - myPos.Y
			yVel = vertSpeed + yErr * 58
			if yErr > 0.35 then
				yVel = math.max(yVel, vertSpeed + yErr * 50 + 20)
			elseif yErr < -0.35 then
				yVel = math.min(yVel, vertSpeed + yErr * 45)
			end
			if math.abs(vertSpeed) > 1.5 then
				yVel = yVel * 0.32 + vertSpeed * 0.68 + yErr * 24
			end
			yVel = math.clamp(yVel, -150, 190)
		else
			local desiredHeight = targetPos.Y + AUTO_BAT_HEIGHT
			local yErr = desiredHeight - myPos.Y
			yVel = yErr * 22 + vertSpeed * 0.9
			if hum.FloorMaterial ~= Enum.Material.Air then
				yVel = math.max(yVel, 12)
			end
			yVel = math.clamp(yVel, -110, 155)
		end
		local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
		local lerpA = (targetInAir or dist < 10 or math.abs(vertSpeed) > 8) and 0.97 or 0.84
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, lerpA)
		hum.AutoRotate = false
		local aimPos = predictPos + Vector3.new(0, targetInAir and 0.25 or AUTO_BAT_V_OFF, 0)
		local toAim = aimPos - myPos
		if toAim.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, aimPos)
			local diffCF = root.CFrame:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			local fast = targetInAir or dist < 12 or horizSpeed > 28 or math.abs(vertSpeed) > 10
			local turnMul = fast and 58 or 46
			local clampA = fast and 3.6 or 2.7
			rx = math.clamp(rx, -clampA, clampA)
			ry = math.clamp(ry, -clampA, clampA)
			rz = math.clamp(rz, -clampA, clampA)
			root.AssemblyAngularVelocity =
				root.CFrame:VectorToWorldSpace(Vector3.new(rx * turnMul, ry * turnMul, rz * turnMul))
		end
		if autoSwingEnabled and bat and not _aimbotSwingCooldown then
			_aimbotSwingCooldown = true
			pcall(function()
				bat:Activate()
			end)
			task.delay(dist < 8 and 0.06 or 0.08, function()
				_aimbotSwingCooldown = false
			end)
		end
	end)
	if autoBatSetVisual then
		autoBatSetVisual(true)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function stopBatAimbot()
	if aimbotConn then
		aimbotConn:Disconnect()
		aimbotConn = nil
	end
	autoBatEnabled = false
	autoBatEquippedThisRun = false
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
		root.AssemblyAngularVelocity = Vector3.zero
	end
	local autoRotateCondition = char and char:FindFirstChildOfClass("Humanoid")
	if autoRotateCondition then
		autoRotateCondition.AutoRotate = true
	end
	if autoBatSetVisual then
		autoBatSetVisual(false)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function queueAutoBatStart()
	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
	end
	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
	end
	startBatAimbot()
end

-- ============================================================================
-- BAT TP (Bypass Aimbot) from Secret
-- ============================================================================
_bypassTarget = nil
_bypassSwingCooldown = false
_tpBatRemoteCache = nil
tpBatConn = nil

function bypassFindBat()
	local char = LP.Character
	if not char then
		return nil
	end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") then
			local n = tool.Name:lower()
			if n:find("bat", 1, true) or n:find("slap", 1, true) then
				return tool
			end
		end
	end
	local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") then
				local n = tool.Name:lower()
				if n:find("bat", 1, true) or n:find("slap", 1, true) then
					return tool
				end
			end
		end
	end
	if char:FindFirstChildOfClass("Tool") then
		return char:FindFirstChildOfClass("Tool")
	end
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") then
				return tool
			end
		end
	end
	return nil
end

function bypassGetClosest()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil, math.huge, nil
	end
	local closest, minDist, closestHum = nil, math.huge, nil
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then
					minDist = dist
					closest = tRoot
					closestHum = hum
				end
			end
		end
	end
	return closest, minDist, closestHum
end

function bypassSwingBat(bat)
	if not bat then
		return
	end
	local remote = _tpBatRemoteCache
	if not remote or remote.Parent ~= bat then
		remote = bat:FindFirstChildOfClass("RemoteEvent")
			or bat:FindFirstChild("RemoteEvent")
			or bat:FindFirstChildWhichIsA("RemoteEvent", true)
		_tpBatRemoteCache = remote
	end
	for _ = 1, 3 do
		pcall(function()
			bat:Activate()
		end)
		if remote and remote:IsA("RemoteEvent") then
			pcall(function()
				remote:FireServer()
			end)
		end
	end
end

function bypassClearGodConns()
	for _, key in ipairs({ "_bypassGodConn", "_bypassGodHealthConn", "_bypassGodDiedConn", "_bypassGodCharConn" }) do
		local c = getfenv()[key]
		if c then
			pcall(function()
				c:Disconnect()
			end)
			getfenv()[key] = nil
		end
	end
end

function bypassProtectCharacter(char)
	if not char then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
	pcall(function()
		hum.MaxHealth = math.max(hum.MaxHealth, 100)
		hum.Health = hum.MaxHealth
		hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
	end)
	_bypassGodHealthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
		if not bypassAimbotEnabled then
			return
		end
		if hum.Health < hum.MaxHealth then
			pcall(function()
				hum.Health = hum.MaxHealth
			end)
		end
	end)
	_bypassGodDiedConn = hum.HealthChanged:Connect(function(hp)
		if not bypassAimbotEnabled then
			return
		end
		if hp <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then
			pcall(function()
				hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				hum.Health = hum.MaxHealth
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end)
		end
	end)
end

function startBypassAimbot()
	if tpBatConn then
		tpBatConn:Disconnect()
		tpBatConn = nil
	end
	if autoLeftEnabled then
		autoLeftEnabled = false
		stopAutoLeft()
	end
	if autoRightEnabled then
		autoRightEnabled = false
		stopAutoRight()
	end
	if antiBypassBatEnabled then
		stopAntiBypassBat()
	end
	if autoTPEnabled then
		stopAutoTP()
		if setAutoTPVisual then
			setAutoTPVisual(false)
		end
	end
	bypassAimbotEnabled = true
	_opV4Latched = false
	_opV4Target = nil
	_tpBatOrbitAngle = 0
	_tpBatCharSpinAngle = 0
	local tpBatEquippedThisRun = false

	local antiDesyncH = nil
	local antiDesyncHrp = nil
	local function setupChar(char)
		antiDesyncH = char and char:FindFirstChildOfClass("Humanoid") or nil
		antiDesyncHrp = char and char:FindFirstChild("HumanoidRootPart") or nil
		tpBatEquippedThisRun = false
	end
	if LP.Character then
		setupChar(LP.Character)
	end

	local function equipBatLikeAutoBat()
		local char = LP.Character
		if not char then
			return
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum then
			return
		end
		-- already holding a tool
		if char:FindFirstChildOfClass("Tool") then
			return
		end
		local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
		if not bp then
			return
		end
		local bpBat = bp:FindFirstChild("Bat")
		if not bpBat then
			for _, t in ipairs(bp:GetChildren()) do
				if t:IsA("Tool") then
					local n = t.Name:lower()
					if n:find("bat", 1, true) or n:find("slap", 1, true) then
						bpBat = t
						break
					end
				end
			end
		end
		if not bpBat then
			bpBat = bp:FindFirstChildWhichIsA("Tool")
		end
		if bpBat then
			pcall(function()
				hum:EquipTool(bpBat)
			end)
		end
	end

	-- equip immediately on start (same as auto bat)
	pcall(equipBatLikeAutoBat)
	tpBatEquippedThisRun = true

	local function getBat()
		return bypassFindBat()
	end

	local function trySwing()
		local bat = getBat()
		if not bat then
			return
		end
		pcall(function()
			bat:Activate()
			local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
			if ev then
				ev:FireServer()
			end
		end)
	end

	local function getClosest()
		local hrp = antiDesyncHrp
		if not hrp then
			return nil, math.huge
		end
		local best, bestDist = nil, math.huge
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				if tRoot and hum and hum.Health > 0 then
					local dist = (hrp.Position - tRoot.Position).Magnitude
					if dist < bestDist then
						bestDist = dist
						best = plr
					end
				end
			end
		end
		return best, bestDist
	end

	tpBatConn = RunService.Heartbeat:Connect(function(dt)
		if not bypassAimbotEnabled then
			return
		end
		dt = (type(dt) == "number" and dt > 0 and dt < 0.1) and dt or (1 / 60)

		if not antiDesyncH or not antiDesyncHrp or not antiDesyncHrp.Parent then
			if LP.Character then
				setupChar(LP.Character)
			end
			if not antiDesyncHrp then
				return
			end
		end

		-- auto-equip bat like auto bat (once per char + re-try if empty hands)
		local charNow = LP.Character
		if charNow and not charNow:FindFirstChildOfClass("Tool") then
			equipBatLikeAutoBat()
		end

		local target, dist = getClosest()
		if not target or not target.Character then
			return
		end
		local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
		if not tRoot then
			return
		end

		pcall(function()
			if sethiddenproperty then
				sethiddenproperty(antiDesyncHrp, "PhysicsRepRootPart", tRoot)
			end
		end)

		local center = tRoot.Position + Vector3.new(0, 0.9, 0)
		local hrp = antiDesyncHrp
		local mode = tpBatMode or "Regular"

		if mode == "OP" then
			local look = tRoot.CFrame.LookVector
			local right = tRoot.CFrame.RightVector
			local tVel = tRoot.AssemblyLinearVelocity
			local predicted = center + Vector3.new(tVel.X, 0, tVel.Z) * 0.06
			for i = 1, 100 do
				local jx = ((i % 5) - 2) * 0.04
				local jz = ((i % 7) - 3) * 0.03
				local jy = ((i % 3) - 1) * 0.02
				local pos = predicted + look * 0.15 + right * jx + Vector3.new(0, jy, 0) + look * jz
				hrp.CFrame = CFrame.new(pos, predicted)
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end
			hrp.CFrame = CFrame.new(predicted, predicted + look)
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
		elseif mode == "V3" then
			local look = tRoot.CFrame.LookVector
			local right = tRoot.CFrame.RightVector
			local tVel = tRoot.AssemblyLinearVelocity
			local predicted = center + Vector3.new(tVel.X, 0, tVel.Z) * 0.06
			_tpBatCharSpinAngle = (_tpBatCharSpinAngle or 0) + (tpBatCharSpinSpeed or 48) * dt * 2.2
			local spin = _tpBatCharSpinAngle
			local c, s = math.cos(spin), math.sin(spin)
			for i = 1, 100 do
				local jx = ((i % 5) - 2) * 0.05
				local jz = ((i % 7) - 3) * 0.04
				local jy = ((i % 3) - 1) * 0.025
				local ox = jx * c - jz * s
				local oz = jx * s + jz * c
				local pos = predicted + right * ox + look * (0.12 + oz) + Vector3.new(0, jy, 0)
				hrp.CFrame = CFrame.new(pos, predicted)
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
			end
			local face = predicted + Vector3.new(math.sin(spin) * 0.4, 0, math.cos(spin) * 0.4)
			hrp.CFrame = CFrame.new(predicted + Vector3.new(0, 0.15, 0), face)
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
		elseif mode == "OP V4" or mode == "OPV4" then
			local tVel = tRoot.AssemblyLinearVelocity
			local spd = tVel.Magnitude
			local predictT = math.clamp(0.03 + spd / 220, 0.03, 0.12)
			local predicted = tRoot.Position + tVel * predictT + Vector3.new(0, 0.9, 0)

			if _opV4Target ~= tRoot then
				_opV4Target = tRoot
				_opV4Latched = false
			end

			local toTarget = predicted - hrp.Position
			local horiz = Vector3.new(toTarget.X, 0, toTarget.Z)
			local distH = horiz.Magnitude
			local walkSpd = tonumber(tpBatV4WalkSpeed) or 45
			local arriveDist = 2.4

			if not _opV4Latched then
				if distH > arriveDist then
					local dir = horiz.Unit
					local currentVel = hrp.AssemblyLinearVelocity
					local desired = Vector3.new(dir.X * walkSpd, currentVel.Y, dir.Z * walkSpd)
					local mass = hrp.AssemblyMass
					if not mass or mass ~= mass or mass <= 0 then
						mass = 1
					end
					local err = Vector3.new(desired.X - currentVel.X, 0, desired.Z - currentVel.Z)
					if err.Magnitude >= 1.35 then
						pcall(function()
							hrp:ApplyImpulse(err * mass * 0.55)
						end)
					end
					local yErr = predicted.Y - hrp.Position.Y
					if math.abs(yErr) > 0.25 then
						local yAdj = math.clamp(yErr * 12 + tVel.Y * 0.5, -90, 130)
						local v = hrp.AssemblyLinearVelocity
						hrp.AssemblyLinearVelocity = Vector3.new(v.X, yAdj, v.Z)
					end
					hrp.AssemblyAngularVelocity = Vector3.zero
					hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(predicted.X, hrp.Position.Y, predicted.Z))
				else
					_opV4Latched = true
				end
			end

			if _opV4Latched then
				local lockPos = predicted
				local face = predicted + Vector3.new(tRoot.CFrame.LookVector.X, 0, tRoot.CFrame.LookVector.Z)
				if (face - lockPos).Magnitude < 0.05 then
					face = lockPos + Vector3.new(0, 0, -1)
				end
				for _ = 1, 20 do
					hrp.CFrame = CFrame.lookAt(lockPos, face)
					hrp.AssemblyLinearVelocity = tVel
					hrp.AssemblyAngularVelocity = Vector3.zero
				end
				hrp.CFrame = CFrame.lookAt(lockPos, face)
				hrp.AssemblyLinearVelocity = Vector3.new(tVel.X, tVel.Y, tVel.Z)
				hrp.AssemblyAngularVelocity = Vector3.zero
				if
					math.abs(hrp.Position.Y - lockPos.Y) > 0.15
					or (Vector3.new(hrp.Position.X - lockPos.X, 0, hrp.Position.Z - lockPos.Z)).Magnitude > 0.2
				then
					hrp.CFrame = CFrame.lookAt(lockPos, face)
					hrp.AssemblyLinearVelocity = tVel
				end
			end
		else
			local radius = tpBatOrbitRadius or 4.2
			local spin = tpBatOrbitSpeed or 80
			local tVel = tRoot.AssemblyLinearVelocity
			local predicted = center + Vector3.new(tVel.X, 0, tVel.Z) * 0.05
			_tpBatOrbitAngle = (_tpBatOrbitAngle or 0) + spin * dt
			local ang = _tpBatOrbitAngle
			local orbitPos = predicted + Vector3.new(math.cos(ang) * radius, 0, math.sin(ang) * radius)
			local look = CFrame.lookAt(orbitPos, predicted)
			if tpBatExtraSpin then
				_tpBatCharSpinAngle = (_tpBatCharSpinAngle or 0) + (tpBatCharSpinSpeed or 28) * dt
				look = CFrame.new(orbitPos) * CFrame.Angles(0, _tpBatCharSpinAngle, 0)
			end
			hrp.CFrame = look
			hrp.AssemblyLinearVelocity = Vector3.zero
			hrp.AssemblyAngularVelocity = Vector3.zero
		end

		local cam = workspace.CurrentCamera
		if cam then
			cam.CFrame = CFrame.new(cam.CFrame.Position, tRoot.Position)
		end

		if autoSwingEnabled ~= false then
			trySwing()
		end
	end)

	_tpBatAutoAntiDie = false
	if not antiDieV2Enabled then
		if not antiDieEnabled then
			_tpBatAutoAntiDie = true
			startAntiDie()
		end
	end

	if setBypassVisual then
		setBypassVisual(true)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function stopBypassAimbot()
	if tpBatConn then
		tpBatConn:Disconnect()
		tpBatConn = nil
	end
	bypassAimbotEnabled = false
	_opV4Latched = false
	_opV4Target = nil
	if _tpBatAutoAntiDie then
		_tpBatAutoAntiDie = false
		if not antiDieV2Enabled then
			stopAntiDie()
		end
	end
	pcall(function()
		local char = LP.Character
		if char then
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum and workspace.CurrentCamera then
				workspace.CurrentCamera.CameraSubject = hum
			end
			if hum then
				hum.AutoRotate = true
			end
		end
	end)
	if setBypassVisual then
		setBypassVisual(false)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function toggleBypassAimbot()
	if bypassAimbotEnabled then
		stopBypassAimbot()
	else
		startBypassAimbot()
	end
	if setBypassVisual then
		setBypassVisual(bypassAimbotEnabled)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

-- ============================================================================
-- ANTI-BYPASS BAT (Secret)
-- ============================================================================
function getAntiBypassTarget()
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then
		return nil
	end
	local now = tick()
	if now - (_antiBypassLastScan or 0) <= 0.1 and _antiBypassTarget and _antiBypassTarget.Parent then
		local hum = _antiBypassTarget.Parent:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health > 0 then
			return _antiBypassTarget
		end
	end
	_antiBypassLastScan = now
	_antiBypassTarget = nil
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
	_antiBypassTarget = closest
	return _antiBypassTarget
end

function ensureAntiBypassEquipped()
	local char = LP.Character
	if not char then
		return
	end
	if char:FindFirstChildOfClass("Tool") then
		return
	end
	local bp = LP:FindFirstChild("Backpack")
	if not bp then
		return
	end
	local bat = bp:FindFirstChild("Bat")
	if not bat then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") and (t.Name:lower():find("bat", 1, true) or t.Name:lower():find("slap", 1, true)) then
				bat = t
				break
			end
		end
	end
	if bat then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			pcall(function()
				hum:EquipTool(bat)
			end)
		end
	end
end

function antiBypassTick()
	if not antiBypassBatEnabled then
		return
	end
	local char = LP.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root or not hum or hum.Health <= 0 then
		return
	end
	if not _antiBypassEquipped then
		_antiBypassEquipped = true
		ensureAntiBypassEquipped()
	end
	local target = getAntiBypassTarget()
	if target then
		local aimTargetPos = target.Position + Vector3.new(0, AUTO_BAT_V_OFF, 0)
		hum.AutoRotate = false
		local look = aimTargetPos - root.Position
		local flatLook = Vector3.new(look.X, 0, look.Z)
		if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
			local targetYaw = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
			local yawDelta = (targetYaw - root.Orientation.Y + 180) % 360 - 180
			local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
			local pitchDelta = (targetPitch - root.Orientation.X + 180) % 360 - 180
			local yawRate =
				math.clamp(math.rad(yawDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
			local pitchRate =
				math.clamp(math.rad(pitchDelta) * AUTO_BAT_TURN_SPEED, -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
			local yawRad = math.rad(root.Orientation.Y)
			local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
			root.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
		else
			root.AssemblyAngularVelocity = Vector3.zero
		end
		local dir = look.Magnitude > 0.01 and look.Unit or Vector3.zero
		local standPos = aimTargetPos - (dir * AUTO_BAT_DIST) + Vector3.new(0, AUTO_BAT_HEIGHT, 0)
		local moveDir = standPos - root.Position
		local hDir = Vector3.new(moveDir.X, 0, moveDir.Z)
		local chaseSpeed = getAimbotSpeed()
		local hVel = hDir.Magnitude > 0.1 and hDir.Unit * chaseSpeed or Vector3.zero
		local vVel = math.abs(moveDir.Y) > 0.1 and Vector3.new(0, math.sign(moveDir.Y) * AUTO_BAT_VERT_SPEED, 0)
			or Vector3.new(0, -2, 0)
		root.AssemblyLinearVelocity = hVel + vVel
		if hDir.Magnitude > 0.5 then
			hum:Move(hDir.Unit, false)
		end
		if autoSwingEnabled ~= false then
			local bat = char:FindFirstChildOfClass("Tool")
			if bat then
				pcall(function()
					bat:Activate()
				end)
			end
		end
	else
		hum.AutoRotate = true
		root.AssemblyAngularVelocity = Vector3.zero
	end
end

function startAntiBypassBat()
	if bypassAimbotEnabled then
		stopBypassAimbot()
	end
	if antiBypassBatConn then
		antiBypassBatConn:Disconnect()
		antiBypassBatConn = nil
	end
	antiBypassBatEnabled = true
	_antiBypassEquipped = false
	_antiBypassTarget = nil
	antiBypassBatConn = RunService.Heartbeat:Connect(antiBypassTick)
	if setAntiBypassBatVisual then
		setAntiBypassBatVisual(true)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function stopAntiBypassBat()
	antiBypassBatEnabled = false
	if antiBypassBatConn then
		antiBypassBatConn:Disconnect()
		antiBypassBatConn = nil
	end
	_antiBypassEquipped = false
	_antiBypassTarget = nil
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if root then
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
		root.AssemblyAngularVelocity = Vector3.zero
	end
	if hum then
		hum.AutoRotate = true
	end
	if setAntiBypassBatVisual then
		setAntiBypassBatVisual(false)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

-- ============================================================================
-- ANTI-DIE (Secret)
-- ============================================================================
function antiDieSuperHeal(hum)
	if not hum then
		return
	end
	local maxHealth = hum.MaxHealth or 100
	if hum.Health >= maxHealth and hum.Health > 0 then
		return
	end
	hum.Health = maxHealth
	_antiDie.invincibleUntil = tick() + (_antiDie.config.invincibilityFrames or 0.5)
	_antiDie.lastHealTime = tick()
	pcall(function()
		local char = hum.Parent
		if not char then
			return
		end
		for _, child in ipairs(char:GetChildren()) do
			if child:IsA("NumberValue") then
				local name = child.Name:lower()
				if name:find("health") or name:find("hp") or name:find("life") then
					child.Value = 100
				end
			elseif child:IsA("BoolValue") and child.Name:lower():find("dead") then
				child.Value = false
			end
		end
	end)
end

function antiDiePreventDamage(root, hum)
	if not hum then
		return
	end
	if tick() < (_antiDie.invincibleUntil or 0) then
		if hum.Health < (hum.MaxHealth or 100) then
			hum.Health = hum.MaxHealth or 100
		end
	end
	local cfg = _antiDie.config
	if cfg.fallDamageProtection and root then
		local vy = 0
		pcall(function()
			vy = root.AssemblyLinearVelocity.Y
		end)
		if vy < -50 and hum.Health < (hum.MaxHealth or 100) then
			antiDieSuperHeal(hum)
		end
	end
	if cfg.ragdollProtection then
		local state = hum:GetState()
		if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll then
			antiDieSuperHeal(hum)
			pcall(function()
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end)
			if root then
				root.AssemblyAngularVelocity = Vector3.zero
			end
		end
	end
	if hum.Health <= 0 then
		antiDieSuperHeal(hum)
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
		if root then
			root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
			root.AssemblyLinearVelocity = Vector3.new(0, 2, 0)
		end
	end
end

function startAntiDie()
	antiDieEnabled = true
	local A = _antiDie
	if A.loop then
		pcall(function()
			A.loop:Disconnect()
		end)
		A.loop = nil
	end
	if A.healthConn then
		pcall(function()
			A.healthConn:Disconnect()
		end)
		A.healthConn = nil
	end

	local function monitorHealth(char)
		if A.healthConn then
			pcall(function()
				A.healthConn:Disconnect()
			end)
			A.healthConn = nil
		end
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum then
			return
		end
		A.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
			if not antiDieEnabled then
				return
			end
			if hum.Health <= 0 then
				antiDieSuperHeal(hum)
				hum:ChangeState(Enum.HumanoidStateType.Running)
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
					root.AssemblyLinearVelocity = Vector3.zero
				end
			end
		end)
	end

	A.loop = RunService.Heartbeat:Connect(function()
		if not antiDieEnabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum then
			return
		end
		local cfg = A.config
		if hum.Health <= 0 then
			if cfg.autoRevive then
				antiDieSuperHeal(hum)
				hum:ChangeState(Enum.HumanoidStateType.Running)
				if root then
					root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
					root.AssemblyLinearVelocity = Vector3.zero
				end
			end
			return
		end
		if hum.Health <= (cfg.healthThreshold or 25) then
			antiDieSuperHeal(hum)
		end
		antiDiePreventDamage(root, hum)
		if hum.Health < 20 and hum.Health > 0 then
			antiDieSuperHeal(hum)
		end
	end)

	if LP.Character then
		local hum = LP.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			antiDieSuperHeal(hum)
		end
		monitorHealth(LP.Character)
	end
	if not A.charConn then
		A.charConn = LP.CharacterAdded:Connect(function(char)
			if not antiDieEnabled then
				return
			end
			task.wait(0.1)
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum then
				antiDieSuperHeal(hum)
			end
			monitorHealth(char)
		end)
	end
end

function stopAntiDie()
	antiDieEnabled = false
	local A = _antiDie
	if A.loop then
		pcall(function()
			A.loop:Disconnect()
		end)
		A.loop = nil
	end
	if A.healthConn then
		pcall(function()
			A.healthConn:Disconnect()
		end)
		A.healthConn = nil
	end
end

-- ============================================================================
-- BODY LOCK (Secret)
-- ============================================================================
function getBodyLockTarget()
	return nil
end
function startBodyLock()
	bodyLockEnabled = false
end
function stopBodyLock()
	bodyLockEnabled = false
end
function toggleBodyLock()
	bodyLockEnabled = false
end
-- ANTI-RAGDOLL (Secret No Splatter)
-- ============================================================================
antiRagdollNoSplatterCooldown = 0

function forceNoSplatterReset()
	local char = LP.Character
	if not char then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then
		return
	end
	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		for _, obj in ipairs(char:GetDescendants()) do
			if obj:IsA("Motor6D") then
				obj.Enabled = true
			end
			if obj:IsA("Constraint") then
				obj.Enabled = true
			end
		end
		workspace.CurrentCamera.CameraSubject = hum
		local pm = LP.PlayerScripts:FindFirstChild("PlayerModule")
		if pm then
			local cm = pm:FindFirstChild("ControlModule")
			if cm then
				local ok, mod = pcall(require, cm)
				if ok and mod and mod.Enable then
					mod:Enable()
				end
			end
		end
		hum.AutoRotate = true
		hum.PlatformStand = false
		hum.Sit = false
	end)
end

antiRagConn = nil

function startAntiRagdoll()
	if antiRagConn then
		antiRagConn:Disconnect()
		antiRagConn = nil
	end
	antiRagdollEnabled = true
	antiRagConn = RunService.Heartbeat:Connect(function()
		if not antiRagdollEnabled then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			return
		end
		local state = hum:GetState()
		local ragdolled = (
			state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or state == Enum.HumanoidStateType.FallingDown
			or hum.PlatformStand
		)
		if ragdolled then
			local now = tick()
			if now - (antiRagdollNoSplatterCooldown or 0) > 0.15 then
				antiRagdollNoSplatterCooldown = now
				forceNoSplatterReset()
			end
		end
	end)
end

function stopAntiRagdoll()
	antiRagdollEnabled = false
	if antiRagConn then
		antiRagConn:Disconnect()
		antiRagConn = nil
	end
end

-- ============================================================================
-- ============================================================================
-- COMPLETE INFINITE JUMP LOGIC (Hold / Manual)
-- ============================================================================
infJumpMode = infJumpMode or "manual" -- "manual" | "hold"
SInf = {
	holdPressed = false,
	mobilePressed = false,
	controllerActive = false,
	hooked = {},
	lastManualBoost = 0,
}
JUMP_BOOST = 55
JUMP_FALL_CLAMP = -120
MANUAL_BOOST_COOLDOWN = 0.18
holdInfJumpConn = nil

function applyInfJumpBoost(boost)
	if not infJumpEnabled then
		return
	end
	local char = LP.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local vx = root.Velocity.X
	local vz = root.Velocity.Z
	root.Velocity = Vector3.new(vx, boost or JUMP_BOOST, vz)
end

function stopHoldInfJump()
	if holdInfJumpConn then
		pcall(function()
			holdInfJumpConn:Disconnect()
		end)
		holdInfJumpConn = nil
	end
end

function startHoldInfJump()
	stopHoldInfJump()
	holdInfJumpConn = RunService.Heartbeat:Connect(function()
		if not infJumpEnabled or infJumpMode ~= "hold" then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum or hum.Health <= 0 then
			return
		end
		local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space)
			or SInf.mobilePressed == true
			or SInf.controllerActive == true
			or SInf.holdPressed == true
		if isJumpHeld and root.Velocity.Y < 35 then
			local vx, vz = root.Velocity.X, root.Velocity.Z
			root.Velocity = Vector3.new(vx, JUMP_BOOST, vz)
		end
		if root.Velocity.Y < JUMP_FALL_CLAMP then
			root.Velocity = Vector3.new(root.Velocity.X, JUMP_FALL_CLAMP, root.Velocity.Z)
		end
	end)
end

function applyInfJumpMode()
	if infJumpEnabled and infJumpMode == "hold" then
		startHoldInfJump()
	else
		stopHoldInfJump()
	end
end

-- Manual: JumpRequest + cooldown
UIS.JumpRequest:Connect(function()
	if not infJumpEnabled or infJumpMode ~= "manual" then
		return
	end
	local now = tick()
	if now - (SInf.lastManualBoost or 0) < MANUAL_BOOST_COOLDOWN then
		return
	end
	SInf.lastManualBoost = now
	applyInfJumpBoost(JUMP_BOOST)
end)

-- Keyboard Space + controller
UIS.InputBegan:Connect(function(input, gpe)
	if UIS:GetFocusedTextBox() then
		return
	end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
		SInf.holdPressed = true
		if infJumpEnabled and infJumpMode == "manual" then
			local now = tick()
			if now - (SInf.lastManualBoost or 0) >= MANUAL_BOOST_COOLDOWN then
				SInf.lastManualBoost = now
				applyInfJumpBoost(JUMP_BOOST)
			end
		end
	elseif input.KeyCode == Enum.KeyCode.ButtonA and tostring(input.UserInputType):find("Gamepad") then
		SInf.controllerActive = true
		if infJumpEnabled and infJumpMode == "manual" then
			local now = tick()
			if now - (SInf.lastManualBoost or 0) >= MANUAL_BOOST_COOLDOWN then
				SInf.lastManualBoost = now
				applyInfJumpBoost(JUMP_BOOST)
			end
		end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
		SInf.holdPressed = false
	end
	if input.KeyCode == Enum.KeyCode.ButtonA and tostring(input.UserInputType):find("Gamepad") then
		SInf.controllerActive = false
	end
end)

-- Mobile jump button
function hookInfJumpMobileButton(obj)
	if not obj or obj.Name ~= "JumpButton" or not obj:IsA("GuiButton") or SInf.hooked[obj] then
		return
	end
	SInf.hooked[obj] = true
	obj.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch or not infJumpEnabled then
			return
		end
		SInf.mobilePressed = true
		if infJumpMode == "manual" then
			local now = tick()
			if now - (SInf.lastManualBoost or 0) >= MANUAL_BOOST_COOLDOWN then
				SInf.lastManualBoost = now
				applyInfJumpBoost(JUMP_BOOST)
			end
		end
	end)
	obj.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			SInf.mobilePressed = false
		end
	end)
	obj.AncestryChanged:Connect(function(_, parent)
		if not parent then
			SInf.hooked[obj] = nil
			SInf.mobilePressed = false
		end
	end)
end

task.spawn(function()
	local PlayerGui = LP:WaitForChild("PlayerGui", 10)
	if not PlayerGui then
		return
	end
	for _, obj in ipairs(PlayerGui:GetDescendants()) do
		hookInfJumpMobileButton(obj)
	end
	PlayerGui.DescendantAdded:Connect(function(obj)
		task.defer(hookInfJumpMobileButton, obj)
	end)
end)

-- MEDUSA COUNTER (Original)
-- ============================================================================
MEDUSA_COOLDOWN = 25
medusaConns = {}

function findMedusa()
	local c = LP.Character
	if not c then
		return nil
	end
	for _, t in ipairs(c:GetChildren()) do
		if t:IsA("Tool") then
			local n = t.Name:lower()
			if n:find("medusa") or n:find("head") or n:find("stone") then
				return t
			end
		end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, t in ipairs(bp:GetChildren()) do
			if t:IsA("Tool") then
				local n = t.Name:lower()
				if n:find("medusa") or n:find("head") or n:find("stone") then
					return t
				end
			end
		end
	end
	return nil
end

function useMedusaCounter()
	if medusaDebounce then
		return
	end
	if tick() - medusaLastUsed < MEDUSA_COOLDOWN then
		return
	end
	local c = LP.Character
	if not c then
		return
	end
	medusaDebounce = true
	local med = findMedusa()
	if not med then
		medusaDebounce = false
		return
	end
	if med.Parent ~= c then
		local humanoid = c:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:EquipTool(med)
		end
	end
	pcall(function()
		med:Activate()
	end)
	medusaLastUsed = tick()
	medusaDebounce = false
end

function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
		if part.Anchored and part.Transparency == 1 then
			if medusaCounterEnabled then
				useMedusaCounter()
			end
		end
	end)
end

function setupMedusa(char)
	for _, c in ipairs(medusaConns) do
		pcall(function()
			c:Disconnect()
		end)
	end
	medusaConns = {}
	if not char then
		return
	end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			table.insert(medusaConns, onAnchorChanged(part))
		end
	end
	table.insert(
		medusaConns,
		char.DescendantAdded:Connect(function(part)
			if part:IsA("BasePart") then
				table.insert(medusaConns, onAnchorChanged(part))
			end
		end)
	)
end

function stopMedusaCounter()
	for _, c in ipairs(medusaConns) do
		pcall(function()
			c:Disconnect()
		end)
	end
	medusaConns = {}
end

-- ============================================================================
-- BAT COUNTER (Original)
-- ============================================================================
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
	"Glitched Slap",
}
batCounterDebounce = false
batCounterConn = nil

function findBatForCounter()
	local c = LP.Character
	if not c then
		return nil
	end
	local bp = LP:FindFirstChildOfClass("Backpack")
	for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
		local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
		if t then
			return t
		end
	end
	for _, ch in ipairs(c:GetChildren()) do
		if ch:IsA("Tool") and ch.Name:lower():find("bat") then
			return ch
		end
	end
	if bp then
		for _, ch in ipairs(bp:GetChildren()) do
			if ch:IsA("Tool") and ch.Name:lower():find("bat") then
				return ch
			end
		end
	end
	return nil
end

function swingBatForCounter(bat, char)
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if bat.Parent ~= char then
		if humanoid then
			pcall(function()
				humanoid:EquipTool(bat)
			end)
		end
		task.wait(0.05)
	end
	local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
	if remote and remote:IsA("RemoteEvent") then
		pcall(function()
			remote:FireServer()
		end)
		task.wait(0.15)
		pcall(function()
			remote:FireServer()
		end)
	else
		pcall(function()
			bat:Activate()
		end)
		task.wait(0.15)
		pcall(function()
			bat:Activate()
		end)
	end
end

function startBatCounter()
	if batCounterConn then
		return
	end
	batCounterConn = RunService.Heartbeat:Connect(function()
		if not batCounterEnabled or batCounterDebounce then
			return
		end
		local char = LP.Character
		if not char then
			return
		end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		local st = humanoid:GetState()
		if
			st == Enum.HumanoidStateType.Physics
			or st == Enum.HumanoidStateType.Ragdoll
			or st == Enum.HumanoidStateType.FallingDown
		then
			batCounterDebounce = true
			task.spawn(function()
				local bat = findBatForCounter()
				if bat then
					swingBatForCounter(bat, char)
				end
				task.wait(0.5)
				batCounterDebounce = false
			end)
		end
	end)
end

function stopBatCounter()
	if batCounterConn then
		batCounterConn:Disconnect()
		batCounterConn = nil
	end
	batCounterDebounce = false
end

-- ============================================================================
-- DROP (Original + Secret)
-- ============================================================================
DROP_ASCEND_DURATION = 0.2
DROP_ASCEND_SPEED = 150

function runDrop()
	if dropActive then
		return
	end
	local char = LP.Character
	if not char then
		return
	end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	if autoBatEnabled then
		autoBatEnabled = false
		if autoBatSetVisual then
			autoBatSetVisual(false)
		end
		stopBatAimbot()
	end
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
	if autoTPEnabled then
		stopAutoTP()
		if setAutoTPVisual then
			setAutoTPVisual(false)
		end
	end

	dropActive = true
	local startTime = tick()
	local dropConn
	dropConn = RunService.Heartbeat:Connect(function()
		local currentChar = LP.Character
		local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
		if not currentChar or not currentRoot then
			if dropConn then
				dropConn:Disconnect()
			end
			dropActive = false
			return
		end
		if tick() - startTime >= DROP_ASCEND_DURATION then
			if dropConn then
				dropConn:Disconnect()
			end
			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = { currentChar }
			rayParams.FilterType = Enum.RaycastFilterType.Exclude
			local rayResult = workspace:Raycast(currentRoot.Position, Vector3.new(0, -2000, 0), rayParams)
			if rayResult then
				local hum = currentChar:FindFirstChildOfClass("Humanoid")
				local offset = (hum and hum.HipHeight or 2) + (currentRoot.Size.Y / 2)
				currentRoot.CFrame =
					CFrame.new(currentRoot.Position.X, rayResult.Position.Y + offset, currentRoot.Position.Z)
				currentRoot.AssemblyLinearVelocity = Vector3.zero
				currentRoot.AssemblyAngularVelocity = Vector3.zero
			end
			dropActive = false
			return
		end
		currentRoot.Velocity = Vector3.new(currentRoot.Velocity.X, DROP_ASCEND_SPEED, currentRoot.Velocity.Z)
	end)
end

-- ============================================================================
-- TP DOWN (Original)
-- ============================================================================
function tpDownAction()
	local char = LP.Character
	if not char then
		return
	end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
	hrp.CFrame = CFrame.new(hrp.Position.X, -7.00, hrp.Position.Z)
		* CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
	hrp.AssemblyLinearVelocity = Vector3.zero
end

function runTPFloor()
	pcall(tpDownAction)
end

-- ============================================================================
-- AUTO TP (Original)
-- ============================================================================
function doAutoTPDown(force)
	local char = LP.Character
	if not char then
		return
	end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
	if not force then
		if hum.FloorMaterial ~= Enum.Material.Air then
			return
		end
		if not (hrp.Position.Y >= autoTPHeight) then
			return
		end
	end
	tpDownAction()
end

function startAutoTP()
	if autoTPConn then
		task.cancel(autoTPConn)
		autoTPConn = nil
	end
	autoTPConn = task.spawn(function()
		while autoTPEnabled do
			task.wait(0.1)
			pcall(function()
				doAutoTPDown(false)
			end)
		end
	end)
end

function stopAutoTP()
	autoTPEnabled = false
	if autoTPConn then
		task.cancel(autoTPConn)
		autoTPConn = nil
	end
end

-- ============================================================================
-- UNWALK (Original)
-- ============================================================================
function startUnwalk()
	local c = LP.Character
	if not c then
		return
	end
	local hum = c:FindFirstChildOfClass("Humanoid")
	if hum then
		for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
			t:Stop()
		end
	end
	local anim = c:FindFirstChild("Animate")
	if anim then
		unwalkSavedAnimate = anim:Clone()
		anim:Destroy()
	end
end

function stopUnwalk()
	local c = LP.Character
	if c and unwalkSavedAnimate then
		unwalkSavedAnimate:Clone().Parent = c
		unwalkSavedAnimate = nil
	end
end

-- ============================================================================
-- ANTI KICK (Original)
-- ============================================================================
antiKickEnabled = false
brainrotDetected = false
setAntiKickVisual = nil

function enableAntiKick()
	antiKickEnabled = true
	task.spawn(function()
		while antiKickEnabled do
			task.wait(0.5)
			local char = LP.Character
			if char then
				local found = false
				for _, tool in ipairs(char:GetChildren()) do
					if tool:IsA("Tool") then
						local n = tool.Name:lower()
						if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then
							found = true
							break
						end
					end
				end
				brainrotDetected = found
				if found then
					if autoBatEnabled then
						stopBatAimbot()
						if autoBatSetVisual then
							autoBatSetVisual(false)
						end
					end
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
				end
			end
		end
	end)
end

function disableAntiKick()
	antiKickEnabled = false
	brainrotDetected = false
end

-- ============================================================================
-- ANTI LAG (Original)
-- ============================================================================
function applyAntiLagDerender(obj)
	pcall(function()
		if obj:IsA("Accessory") or obj:IsA("Hat") then
			obj:Destroy()
		elseif obj:IsA("BasePart") then
			obj.Material = Enum.Material.Plastic
			obj.Reflectance = 0
			obj.CastShadow = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			obj.Transparency = 1
		elseif
			obj:IsA("ParticleEmitter")
			or obj:IsA("Trail")
			or obj:IsA("Beam")
			or obj:IsA("Fire")
			or obj:IsA("Smoke")
			or obj:IsA("Sparkles")
		then
			obj.Enabled = false
		elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
			for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
				pcall(function()
					t:Stop(0)
				end)
			end
		end
	end)
end

function enableAntiLag()
	removeAccessoriesEnabled = true
	antiLagEnabled = true
	local defLightBrightness = Lighting.Brightness
	local defLightClock = Lighting.ClockTime
	local defLightAmbient = Lighting.OutdoorAmbient
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	for _, e in pairs(Lighting:GetChildren()) do
		pcall(function()
			if
				e:IsA("BlurEffect")
				or e:IsA("SunRaysEffect")
				or e:IsA("ColorCorrectionEffect")
				or e:IsA("BloomEffect")
				or e:IsA("DepthOfFieldEffect")
			then
				e.Enabled = false
			end
		end)
	end
	for _, obj in ipairs(workspace:GetDescendants()) do
		applyAntiLagDerender(obj)
	end
	if antiLagDescConn then
		antiLagDescConn:Disconnect()
	end
	antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
		if removeAccessoriesEnabled then
			applyAntiLagDerender(obj)
		end
	end)
end

function disableAntiLag()
	removeAccessoriesEnabled = false
	antiLagEnabled = false
	if antiLagDescConn then
		antiLagDescConn:Disconnect()
		antiLagDescConn = nil
	end
	pcall(function()
		Lighting.Brightness = 2
		Lighting.ClockTime = 14
		Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		Lighting.ExposureCompensation = 0
	end)
end

-- ============================================================================
-- STRETCH REZ (Original)
-- ============================================================================
function enableStretchRez()
	stretchRezEnabled = true
	workspace.CurrentCamera.FieldOfView = 107
	if stretchRezConn then
		stretchRezConn:Disconnect()
	end
	stretchRezConn = RunService.RenderStepped:Connect(function()
		if not stretchRezEnabled then
			stretchRezConn:Disconnect()
			stretchRezConn = nil
			return
		end
		workspace.CurrentCamera.FieldOfView = 107
	end)
end

function disableStretchRez()
	stretchRezEnabled = false
	if stretchRezConn then
		stretchRezConn:Disconnect()
		stretchRezConn = nil
	end
	workspace.CurrentCamera.FieldOfView = 70
end

-- ============================================================================
-- SKY THEME (Secret)
-- ============================================================================
CANDY_SKY_TAG = "MoveeSkyTheme"
CANDY_SKY_PRESETS = {
	["Off"] = { kind = "off" },
	["Night"] = {
		clock = 22,
		brightness = 2,
		ambient = { 110, 100, 130 },
		outAmb = { 120, 110, 140 },
		sky = { stars = 4000, moon = 18, sun = 0, moonTex = true },
		atm = { dens = 0.45, color = { 120, 60, 180 }, decay = { 60, 20, 100 }, glare = 0.5, haze = 1.2 },
	},
	["Aurora"] = {
		clock = 14,
		brightness = 3,
		ambient = { 150, 120, 150 },
		outAmb = { 160, 130, 150 },
		atm = { dens = 0.55, color = { 255, 80, 200 }, decay = { 255, 20, 150 }, glare = 2.5, haze = 3 },
		clouds = { cover = 0.7, dens = 0.7, color = { 255, 240, 250 } },
	},
	["Sunset"] = {
		clock = 17.2,
		brightness = 2.5,
		ambient = { 170, 120, 100 },
		outAmb = { 180, 130, 110 },
		sky = { stars = 0, sun = 25, moon = 0 },
		atm = { dens = 0.5, color = { 255, 130, 60 }, decay = { 255, 80, 30 }, glare = 2, haze = 2.5 },
		clouds = { cover = 0.55, dens = 0.55, color = { 255, 200, 140 } },
	},
	["Galaxy"] = {
		clock = 0,
		brightness = 1.5,
		ambient = { 70, 60, 100 },
		outAmb = { 80, 70, 110 },
		sky = { stars = 10000, moon = 30, sun = 0 },
		atm = { dens = 0.15, color = { 40, 20, 80 }, decay = { 20, 10, 50 }, glare = 0.3, haze = 0.5 },
	},
	["Cyber"] = {
		clock = 21,
		brightness = 2.2,
		ambient = { 90, 130, 170 },
		outAmb = { 100, 140, 180 },
		sky = { stars = 2000, moon = 12 },
		atm = { dens = 0.4, color = { 0, 200, 255 }, decay = { 150, 0, 255 }, glare = 2, haze = 2 },
		clouds = { cover = 0.4, dens = 0.6, color = { 100, 200, 255 } },
	},
	["Sakura"] = {
		clock = 11,
		brightness = 3.5,
		ambient = { 170, 150, 160 },
		outAmb = { 180, 160, 170 },
		sky = { sun = 8 },
		atm = { dens = 0.3, color = { 255, 200, 220 }, decay = { 255, 170, 200 }, glare = 1, haze = 1.5 },
		clouds = { cover = 0.6, dens = 0.4, color = { 255, 250, 252 } },
	},
	["Pink Night"] = {
		clock = 23,
		brightness = 2.2,
		ambient = { 120, 60, 110 },
		outAmb = { 140, 70, 120 },
		sky = { stars = 5000, moon = 22, sun = 0, moonTex = true },
		atm = { dens = 0.5, color = { 255, 80, 180 }, decay = { 140, 30, 100 }, glare = 0.7, haze = 1.4 },
		clouds = { cover = 0.3, dens = 0.5, color = { 180, 90, 150 } },
	},
	["Blood Moon"] = {
		clock = 22.5,
		brightness = 1.6,
		ambient = { 130, 40, 40 },
		outAmb = { 150, 50, 50 },
		sky = { stars = 1500, moon = 28, sun = 0, moonTex = true },
		atm = { dens = 0.6, color = { 220, 30, 30 }, decay = { 120, 10, 10 }, glare = 1.4, haze = 2 },
		clouds = { cover = 0.5, dens = 0.7, color = { 120, 30, 30 } },
	},
	["Emerald Dawn"] = {
		clock = 6.5,
		brightness = 2.8,
		ambient = { 130, 170, 140 },
		outAmb = { 140, 180, 150 },
		sky = { sun = 18, moon = 0, stars = 0 },
		atm = { dens = 0.4, color = { 80, 200, 140 }, decay = { 40, 150, 90 }, glare = 1.8, haze = 2.2 },
		clouds = { cover = 0.5, dens = 0.5, color = { 200, 255, 220 } },
	},
	["Volcanic"] = {
		clock = 19,
		brightness = 2,
		ambient = { 180, 80, 40 },
		outAmb = { 200, 90, 50 },
		sky = { stars = 200, sun = 12, moon = 0 },
		atm = { dens = 0.75, color = { 255, 60, 0 }, decay = { 180, 20, 0 }, glare = 3, haze = 3.5 },
		clouds = { cover = 0.8, dens = 0.9, color = { 120, 40, 20 } },
	},
	["Arctic"] = {
		clock = 9,
		brightness = 3.2,
		ambient = { 200, 220, 235 },
		outAmb = { 210, 230, 245 },
		sky = { sun = 10, stars = 0, moon = 0 },
		atm = { dens = 0.3, color = { 180, 220, 255 }, decay = { 140, 200, 240 }, glare = 1.5, haze = 1.8 },
		clouds = { cover = 0.7, dens = 0.6, color = { 250, 253, 255 } },
	},
	["Midnight Ocean"] = {
		clock = 1.5,
		brightness = 1.7,
		ambient = { 60, 90, 130 },
		outAmb = { 70, 100, 140 },
		sky = { stars = 6000, moon = 24, sun = 0, moonTex = true },
		atm = { dens = 0.5, color = { 20, 60, 140 }, decay = { 10, 30, 90 }, glare = 0.6, haze = 1.5 },
	},
	["Vaporwave"] = {
		clock = 19.5,
		brightness = 2.4,
		ambient = { 180, 120, 200 },
		outAmb = { 190, 130, 210 },
		sky = { stars = 1000, moon = 14 },
		atm = { dens = 0.45, color = { 255, 100, 220 }, decay = { 120, 60, 255 }, glare = 2.2, haze = 2.4 },
		clouds = { cover = 0.55, dens = 0.55, color = { 200, 150, 255 } },
	},
	["Toxic"] = {
		clock = 13,
		brightness = 2.5,
		ambient = { 140, 180, 80 },
		outAmb = { 150, 190, 90 },
		atm = { dens = 0.55, color = { 100, 220, 40 }, decay = { 60, 150, 20 }, glare = 1.8, haze = 2.6 },
		clouds = { cover = 0.65, dens = 0.7, color = { 180, 255, 120 } },
	},
	["Solar Eclipse"] = {
		clock = 12,
		brightness = 0.9,
		ambient = { 50, 40, 60 },
		outAmb = { 60, 50, 70 },
		sky = { stars = 3500, sun = 22, moon = 0 },
		atm = { dens = 0.5, color = { 255, 140, 40 }, decay = { 30, 20, 40 }, glare = 2.8, haze = 1.8 },
	},
	["Hellscape"] = {
		clock = 18,
		brightness = 1.8,
		ambient = { 200, 60, 30 },
		outAmb = { 220, 70, 40 },
		sky = { stars = 100, sun = 30, moon = 0 },
		atm = { dens = 0.85, color = { 255, 30, 0 }, decay = { 120, 0, 0 }, glare = 3.5, haze = 4 },
		clouds = { cover = 0.95, dens = 0.95, color = { 80, 20, 10 } },
	},
	["Heaven"] = {
		clock = 12,
		brightness = 4,
		ambient = { 240, 235, 210 },
		outAmb = { 250, 245, 220 },
		sky = { sun = 16, moon = 0, stars = 0 },
		atm = { dens = 0.25, color = { 255, 250, 220 }, decay = { 255, 240, 200 }, glare = 3, haze = 1.5 },
		clouds = { cover = 0.85, dens = 0.5, color = { 255, 255, 255 } },
	},
	["Storm"] = {
		clock = 15,
		brightness = 1.4,
		ambient = { 90, 90, 110 },
		outAmb = { 100, 100, 120 },
		sky = { stars = 0, sun = 6, moon = 0 },
		atm = { dens = 0.65, color = { 80, 90, 120 }, decay = { 40, 50, 80 }, glare = 0.5, haze = 3 },
		clouds = { cover = 0.95, dens = 0.95, color = { 60, 65, 80 } },
	},
	["Sunrise"] = {
		clock = 6.2,
		brightness = 2.8,
		ambient = { 220, 180, 130 },
		outAmb = { 230, 190, 140 },
		sky = { sun = 22, stars = 0, moon = 0 },
		atm = { dens = 0.45, color = { 255, 180, 100 }, decay = { 255, 140, 80 }, glare = 2.4, haze = 2.2 },
		clouds = { cover = 0.4, dens = 0.4, color = { 255, 220, 180 } },
	},
	["Deep Space"] = {
		clock = 0,
		brightness = 1,
		ambient = { 30, 25, 50 },
		outAmb = { 40, 35, 60 },
		sky = { stars = 15000, moon = 0, sun = 0 },
		atm = { dens = 0.08, color = { 15, 5, 40 }, decay = { 5, 0, 20 }, glare = 0.2, haze = 0.3 },
	},
	["Lavender Dream"] = {
		clock = 18.5,
		brightness = 2.6,
		ambient = { 180, 160, 220 },
		outAmb = { 190, 170, 230 },
		sky = { stars = 800, moon = 16, sun = 0 },
		atm = { dens = 0.4, color = { 200, 160, 255 }, decay = { 160, 120, 220 }, glare = 1.4, haze = 1.8 },
		clouds = { cover = 0.55, dens = 0.5, color = { 220, 200, 255 } },
	},
	["Inferno"] = {
		clock = 17.5,
		brightness = 2.2,
		ambient = { 220, 100, 40 },
		outAmb = { 235, 110, 50 },
		sky = { sun = 26, moon = 0, stars = 0 },
		atm = { dens = 0.6, color = { 255, 90, 20 }, decay = { 200, 40, 0 }, glare = 3, haze = 3.2 },
		clouds = { cover = 0.7, dens = 0.7, color = { 200, 80, 40 } },
	},
	["Mint Sky"] = {
		clock = 10,
		brightness = 3.2,
		ambient = { 180, 230, 210 },
		outAmb = { 190, 240, 220 },
		sky = { sun = 10 },
		atm = { dens = 0.32, color = { 150, 255, 210 }, decay = { 100, 220, 180 }, glare = 1.6, haze = 1.6 },
		clouds = { cover = 0.55, dens = 0.45, color = { 240, 255, 250 } },
	},
}
SkyOrder = {
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
	"Mint Sky",
}

function candyColor(rgb)
	return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end

function CandyApplyCustomSky(mode)
	for _, child in ipairs(Lighting:GetChildren()) do
		if child:GetAttribute(CANDY_SKY_TAG) then
			pcall(function()
				child:Destroy()
			end)
		end
	end
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
		for _, child in ipairs(terrain:GetChildren()) do
			if child:GetAttribute(CANDY_SKY_TAG) then
				pcall(function()
					child:Destroy()
				end)
			end
		end
	end
	local preset = CANDY_SKY_PRESETS[mode]
	if not preset or preset.kind == "off" then
		Lighting.ClockTime = 14
		Lighting.Brightness = 2
		Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		Lighting.Ambient = Color3.fromRGB(127, 127, 127)
		Lighting.FogEnd = 100000
		Lighting.GlobalShadows = true
		return
	end
	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
	Lighting.FogColor = Color3.fromRGB(200, 200, 200)
	Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
	Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	Lighting.GlobalShadows = true
	Lighting.ClockTime = preset.clock or 14
	Lighting.Brightness = preset.brightness or 2
	if preset.outAmb then
		Lighting.OutdoorAmbient = candyColor(preset.outAmb)
	end
	if preset.ambient then
		Lighting.Ambient = candyColor(preset.ambient)
	end
	if preset.sky then
		local skyInst = Instance.new("Sky")
		skyInst:SetAttribute(CANDY_SKY_TAG, true)
		if preset.sky.stars then
			skyInst.StarCount = preset.sky.stars
		end
		if preset.sky.moon then
			skyInst.MoonAngularSize = preset.sky.moon
		end
		if preset.sky.sun then
			skyInst.SunAngularSize = preset.sky.sun
		end
		if preset.sky.moonTex then
			skyInst.MoonTextureId = "rbxasset://sky/moon.jpg"
		end
		skyInst.Parent = Lighting
	end
	if preset.atm then
		local atm = Instance.new("Atmosphere")
		atm:SetAttribute(CANDY_SKY_TAG, true)
		atm.Density = preset.atm.dens or 0.3
		atm.Color = candyColor(preset.atm.color)
		atm.Decay = candyColor(preset.atm.decay)
		atm.Glare = preset.atm.glare or 1
		atm.Haze = preset.atm.haze or 1
		atm.Parent = Lighting
	end
	if preset.clouds and terrain then
		local clouds = Instance.new("Clouds")
		clouds:SetAttribute(CANDY_SKY_TAG, true)
		clouds.Cover = preset.clouds.cover or 0.5
		clouds.Density = preset.clouds.dens or 0.5
		clouds.Color = candyColor(preset.clouds.color)
		clouds.Parent = terrain
	end
end

function applyDarkModeForce()
	if not darkModeEnabled then
		return
	end
	pcall(function()
		Lighting.Brightness = 0.08
		Lighting.Ambient = Color3.fromRGB(5, 5, 8)
		Lighting.OutdoorAmbient = Color3.fromRGB(3, 3, 5)
		Lighting.FogStart = 0
		Lighting.FogEnd = 220
		Lighting.FogColor = Color3.fromRGB(2, 2, 4)
		Lighting.GlobalShadows = false
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
		Lighting.ShadowSoftness = 0
		pcall(function()
			Lighting.Technology = Enum.Technology.Legacy
		end)
		for _, e in ipairs(Lighting:GetChildren()) do
			if
				e:IsA("BlurEffect")
				or e:IsA("BloomEffect")
				or e:IsA("SunRaysEffect")
				or e:IsA("DepthOfFieldEffect")
				or e:IsA("ColorCorrectionEffect")
			then
				e.Enabled = false
			end
		end
	end)
end

function forceApplySkyAndDark()
	local theme = currentSkyTheme or "Night"
	pcall(function()
		CandyApplyCustomSky(theme)
	end)
	if darkModeEnabled then
		pcall(applyDarkModeForce)
	end
end

forceVisualConn = nil
forceVisualBusy = false
function startForceVisuals()
	if forceVisualConn then
		return
	end
	forceVisualConn = Lighting.Changed:Connect(function()
		if forceVisualBusy then
			return
		end
		forceVisualBusy = true
		task.delay(2.5, function()
			pcall(forceApplySkyAndDark)
			forceVisualBusy = false
		end)
	end)
end

-- ============================================================================
-- ANIMATION PACKS (Secret)
-- ============================================================================
PACKS = {
	["Adidas Sports"] = {
		WalkAnim = 18537392113,
		RunAnim = 18537384940,
		JumpAnim = 18537380791,
		FallAnim = 18537367238,
		SwimIdle = 18537387180,
		Swim = 18537389531,
		Animation1 = 18537376492,
		Animation2 = 18537371272,
		ClimbAnim = 18537363391,
	},
	["Adidas Community"] = {
		WalkAnim = 122150855457006,
		RunAnim = 82598234841035,
		JumpAnim = 75290611992385,
		FallAnim = 98600215928904,
		SwimIdle = 109346520324160,
		Swim = 133308483266208,
		Animation1 = 122257458498464,
		Animation2 = 102357151005774,
		ClimbAnim = 88763136693023,
	},
	["Adidas Aura"] = {
		WalkAnim = 83842218823011,
		RunAnim = 118320322718866,
		JumpAnim = 109996626521204,
		FallAnim = 95603166884636,
		SwimIdle = 94922130551805,
		Swim = 134530128383903,
		Animation1 = 110211186840347,
		Animation2 = 114191137265065,
		ClimbAnim = 97824616490448,
	},
	["Wicked Popular"] = {
		WalkAnim = 92072849924640,
		RunAnim = 72301599441680,
		JumpAnim = 104325245285198,
		FallAnim = 121152442762481,
		Animation1 = 118832222982049,
		ClimbAnim = 131326830509784,
		SwimIdle = 113199415118199,
		Swim = 99384245425157,
		Animation2 = 76049494037641,
	},
	Elder = {
		WalkAnim = 10921111375,
		RunAnim = 10921104374,
		JumpAnim = 10921107367,
		FallAnim = 10921105765,
		SwimIdle = 10921110146,
		Swim = 10921108971,
		ClimbAnim = 10921100400,
		Animation1 = 10921101664,
		Animation2 = 10921102574,
	},
	Zombie = {
		WalkAnim = 10921355261,
		RunAnim = 616163682,
		JumpAnim = 10921351278,
		FallAnim = 10921350320,
		SwimIdle = 10921353442,
		Swim = 10921352344,
		Animation1 = 10921344533,
		Animation2 = 10921345304,
		ClimbAnim = 10921343576,
	},
	Mage = {
		WalkAnim = 10921152678,
		RunAnim = 10921148209,
		JumpAnim = 10921149743,
		FallAnim = 10921148939,
		SwimIdle = 10921151661,
		Swim = 10921150788,
		ClimbAnim = 10921143404,
		Animation1 = 10921144709,
		Animation2 = 10921145797,
	},
	["Catwalk Glam"] = {
		WalkAnim = 109168724482748,
		RunAnim = 81024476153754,
		JumpAnim = 116936326516985,
		FallAnim = 92294537340807,
		SwimIdle = 98854111361360,
		Swim = 134591743181628,
		ClimbAnim = 119377220967554,
		Animation1 = 133806214992291,
		Animation2 = 94970088341563,
	},
	Astronaut = {
		WalkAnim = 10921046031,
		RunAnim = 10921039308,
		JumpAnim = 10921042494,
		FallAnim = 10921040576,
		SwimIdle = 10921045006,
		Swim = 10921044000,
		ClimbAnim = 10921032124,
		Animation1 = 10921034824,
		Animation2 = 10921036806,
	},
	['Wicked "Dancing Through Life"'] = {
		WalkAnim = 73718308412641,
		RunAnim = 135515454877967,
		JumpAnim = 78508480717326,
		FallAnim = 78147885297412,
		SwimIdle = 129183123083281,
		Swim = 110657013921774,
		ClimbAnim = 129447497744818,
		Animation1 = 92849173543269,
		Animation2 = 132238900951109,
	},
	Werewolf = {
		WalkAnim = 10921342074,
		RunAnim = 10921336997,
		JumpAnim = nil,
		FallAnim = 10921337907,
		SwimIdle = 10921341319,
		Swim = 10921340419,
		ClimbAnim = 10921329322,
		Animation1 = 10921330408,
		Animation2 = 10921333667,
	},
	Superhero = {
		WalkAnim = 10921298616,
		RunAnim = 10921291831,
		JumpAnim = 10921294559,
		FallAnim = 10921293373,
		SwimIdle = 10921297391,
		Swim = 10921295495,
		ClimbAnim = 10921286911,
		Animation1 = 10921288909,
		Animation2 = 10921290167,
	},
	Toy = {
		WalkAnim = 10921312010,
		RunAnim = 10921306285,
		JumpAnim = 10921308158,
		FallAnim = 10921307241,
		SwimIdle = 10921310341,
		Swim = 10921309319,
		ClimbAnim = 10921300839,
		Animation1 = 10921301576,
		Animation2 = nil,
	},
	["No Boundaries"] = {
		WalkAnim = 18747074203,
		RunAnim = 18747070484,
		JumpAnim = 18747069148,
		FallAnim = 18747062535,
		SwimIdle = 18747071682,
		Swim = 18747073181,
		ClimbAnim = 18747060903,
		Animation1 = 18747067405,
		Animation2 = 18747063918,
	},
	NFL = {
		WalkAnim = 110358958299415,
		RunAnim = 117333533048078,
		JumpAnim = 119846112151352,
		FallAnim = 129773241321032,
		SwimIdle = 79090109939093,
		Swim = 132697394189921,
		ClimbAnim = 134630013742019,
		Animation1 = 92080889861410,
		Animation2 = 74451233229259,
	},
	["Amazon Unboxed"] = {
		WalkAnim = 90478085024465,
		RunAnim = 134824450619865,
		JumpAnim = 121454505477205,
		FallAnim = 94788218468396,
		SwimIdle = 129126268464847,
		Swim = 105962919001086,
		ClimbAnim = 121145883950231,
		Animation1 = 98281136301627,
		Animation2 = nil,
	},
	Vampire = {
		WalkAnim = 10921326949,
		RunAnim = 10921320299,
		JumpAnim = 10921322186,
		FallAnim = 10921321317,
		SwimIdle = 10921325443,
		Swim = 10921324408,
		ClimbAnim = 10921314188,
		Animation1 = 10921315373,
		Animation2 = nil,
	},
	Ninja = {
		Run = 656118852,
		Walk = 656121766,
		Jump = 656117878,
		Fall = 656115606,
		Swim = 656119721,
		SwimIdle = 656121397,
		Climb = 656114359,
		Idle = { 656117400, 656118341, 886742569 },
	},
	Robot = {
		Run = 616091570,
		Walk = 616095330,
		Jump = 616090535,
		Fall = 616087089,
		Swim = 616092998,
		SwimIdle = 616094091,
		Climb = 616086039,
		Idle = { 616088211, 616089559, 885531463 },
	},
	Levitation = {
		Run = 616010382,
		Walk = 616013216,
		Jump = 616008936,
		Fall = 616005863,
		Swim = 616011509,
		SwimIdle = 616012453,
		Climb = 616003713,
		Idle = { 616006778, 616008087, 886862142 },
	},
	Stylish = {
		Run = 616140816,
		Walk = 616146177,
		Jump = 616139451,
		Fall = 616134815,
		Swim = 616143378,
		SwimIdle = 616144772,
		Climb = 616133594,
		Idle = { 616136790, 616138447, 886888594 },
	},
	Bubbly = {
		Run = 910025107,
		Walk = 910034870,
		Jump = 910016857,
		Fall = 910001910,
		Swim = 910028158,
		SwimIdle = 910030921,
		Climb = 909997997,
		Idle = { 910004836, 910009958, 1018536639 },
	},
	Cartoon = {
		Run = 742638842,
		Walk = 742640026,
		Jump = 742637942,
		Fall = 742637151,
		Swim = 742639220,
		SwimIdle = 742639812,
		Climb = 742636889,
		Idle = { 742637544, 742638445, 885477856 },
	},
}
savedAnimate = nil

function waitForAnimate(char)
	for _ = 1, 40 do
		local a = char:FindFirstChild("Animate")
		if a and a:FindFirstChild("idle") and a:FindFirstChild("run") and a:FindFirstChild("walk") then
			return a
		end
		task.wait(0.1)
	end
	return nil
end

function setAnim(animObj, id)
	if animObj and id then
		animObj.AnimationId = "rbxassetid://" .. tostring(id)
	end
end

function stopAllTracks(hum)
	if not hum then
		return
	end
	for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
		pcall(function()
			t:Stop(0)
		end)
	end
end

function ensureAnim(folder, name)
	if not folder then
		return nil
	end
	local a = folder:FindFirstChild(name)
	if not a then
		a = Instance.new("Animation")
		a.Name = name
		a.Parent = folder
	end
	return a
end

function ensureIdleSlots(idleFolder, n)
	if not idleFolder then
		return
	end
	n = n or 2
	for i = 1, n do
		ensureAnim(idleFolder, "Animation" .. i)
	end
end

function pick(pack, ...)
	for i = 1, select("#", ...) do
		local k = select(i, ...)
		local v = pack[k]
		if v ~= nil then
			return v
		end
	end
	return nil
end

function saveOriginalAnimate(char)
	if not char or savedAnimate then
		return
	end
	local animate = char:FindFirstChild("Animate")
	if animate then
		savedAnimate = animate:Clone()
	end
end

function restoreOriginalAnimate(char)
	if not char then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		stopAllTracks(hum)
	end
	local currentAnimate = char:FindFirstChild("Animate")
	if currentAnimate then
		currentAnimate:Destroy()
	end
	if savedAnimate then
		local newAnimate = savedAnimate:Clone()
		newAnimate.Parent = char
		newAnimate.Disabled = true
		task.wait(0.06)
		newAnimate.Disabled = false
	end
end

function resetAnimations(char)
	if not char then
		return
	end
	restoreOriginalAnimate(char)
end

applyingAnim = false

function applyAnimPack(packName)
	if not animPackEnabled then
		local char = LP.Character
		if char then
			resetAnimations(char)
		end
		return false
	end
	if applyingAnim then
		return false
	end
	applyingAnim = true
	local pack = PACKS[packName]
	if not pack then
		applyingAnim = false
		return false
	end
	local char = LP.Character or LP.CharacterAdded:Wait()
	saveOriginalAnimate(char)
	local animate = waitForAnimate(char)
	if not animate then
		applyingAnim = false
		return false
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	stopAllTracks(hum)
	local runObj = ensureAnim(animate:FindFirstChild("run"), "RunAnim")
	local walkObj = ensureAnim(animate:FindFirstChild("walk"), "WalkAnim")
	local jumpObj = ensureAnim(animate:FindFirstChild("jump"), "JumpAnim")
	local fallObj = ensureAnim(animate:FindFirstChild("fall"), "FallAnim")
	local climbObj = ensureAnim(animate:FindFirstChild("climb"), "ClimbAnim")
	local swimObj = ensureAnim(animate:FindFirstChild("swim"), "Swim")
	local swimIdleObj = ensureAnim(animate:FindFirstChild("swimidle"), "SwimIdle")
	local idleFolder = animate:FindFirstChild("idle")
	setAnim(walkObj, pick(pack, "WalkAnim", "Walk"))
	setAnim(runObj, pick(pack, "RunAnim", "Run"))
	setAnim(jumpObj, pick(pack, "JumpAnim", "Jump"))
	setAnim(fallObj, pick(pack, "FallAnim", "Fall"))
	setAnim(climbObj, pick(pack, "ClimbAnim", "Climb"))
	setAnim(swimObj, pick(pack, "Swim"))
	setAnim(swimIdleObj, pick(pack, "SwimIdle") or pick(pack, "Swim"))
	if idleFolder then
		local optionFlag = pick(pack, "Animation1")
		local flag = pick(pack, "Animation2")
		if optionFlag or flag then
			ensureIdleSlots(idleFolder, 2)
			local option = optionFlag or flag
			local secondaryOption = flag or optionFlag or option
			setAnim(idleFolder:FindFirstChild("Animation1"), option)
			setAnim(idleFolder:FindFirstChild("Animation2"), secondaryOption)
		elseif pack.Idle and #pack.Idle > 0 then
			ensureIdleSlots(idleFolder, math.max(2, #pack.Idle))
			setAnim(idleFolder:FindFirstChild("Animation1"), pack.Idle[1])
			setAnim(idleFolder:FindFirstChild("Animation2"), pack.Idle[2] or pack.Idle[1])
			for i = 3, #pack.Idle do
				local a = idleFolder:FindFirstChild("Animation" .. i)
				if a then
					setAnim(a, pack.Idle[i])
				end
			end
		end
	end
	animate.Disabled = true
	task.wait(0.06)
	animate.Disabled = false
	if hum then
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Landed)
			task.wait(0.03)
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end)
	end
	animPack = packName
	applyingAnim = false
	return true
end

-- ============================================================================
-- HEADLESS / KORBLOX (Secret)
-- ============================================================================
HEADLESS_MESH_ID = "rbxassetid://1095708"
KORBLOX_MESH_ID = "rbxassetid://101851696"
KORBLOX_TEXTURE_ID = "rbxassetid://101851254"
DARK_GREY_COLOR = Color3.fromRGB(64, 64, 64)

function removeFace(head)
	local face = head:FindFirstChild("face")
	if face then
		face:Destroy()
	end
end

function applyHeadlessToChar(char, enabled)
	if not char then
		return
	end
	local head = char:FindFirstChild("Head")
	if not head then
		return
	end
	if enabled then
		head.Transparency = 1
		head.CanCollide = false
		removeFace(head)
		local existing = head:FindFirstChild("HeadlessMesh")
		if not existing then
			for _, child in ipairs(head:GetChildren()) do
				if child:IsA("SpecialMesh") and child.MeshId == HEADLESS_MESH_ID then
					child:Destroy()
				end
			end
			local mesh = Instance.new("SpecialMesh")
			mesh.MeshType = Enum.MeshType.FileMesh
			mesh.MeshId = HEADLESS_MESH_ID
			mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
			mesh.Name = "HeadlessMesh"
			mesh.Parent = head
		end
		if not head:GetAttribute("MoveeHeadlessHooked") then
			head:SetAttribute("MoveeHeadlessHooked", true)
			head:GetPropertyChangedSignal("Transparency"):Connect(function()
				if headlessEnabled and head.Transparency ~= 1 then
					head.Transparency = 1
				end
			end)
			head.ChildAdded:Connect(function(child)
				if headlessEnabled and child.Name == "face" and child:IsA("Decal") then
					child:Destroy()
				end
			end)
		end
	else
		head.Transparency = 0
		head.CanCollide = true
		for _, child in ipairs(head:GetChildren()) do
			if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
				child:Destroy()
			end
		end
		removeFace(head)
	end
end

function applyKorbloxToChar(char, enabled)
	if not char then
		return
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end
	if enabled then
		if humanoid.RigType == Enum.HumanoidRigType.R6 then
			local rightLeg = char:FindFirstChild("Right Leg")
			if rightLeg then
				if not rightLeg:FindFirstChild("KorbloxMesh") then
					for _, child in ipairs(rightLeg:GetChildren()) do
						if child:IsA("SpecialMesh") or child:IsA("CharacterMesh") then
							child:Destroy()
						end
					end
					local mesh = Instance.new("SpecialMesh")
					mesh.MeshType = Enum.MeshType.FileMesh
					mesh.MeshId = KORBLOX_MESH_ID
					mesh.TextureId = KORBLOX_TEXTURE_ID
					mesh.Scale = Vector3.new(1, 1, 1)
					mesh.Name = "KorbloxMesh"
					mesh.Parent = rightLeg
				end
				rightLeg.Color = DARK_GREY_COLOR
				if not rightLeg:GetAttribute("MoveeKorbloxHooked") then
					rightLeg:SetAttribute("MoveeKorbloxHooked", true)
					rightLeg:GetPropertyChangedSignal("Color"):Connect(function()
						if korbloxEnabled and rightLeg.Color ~= DARK_GREY_COLOR then
							rightLeg.Color = DARK_GREY_COLOR
						end
					end)
				end
			end
		elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
			local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
			if rightUpperLeg then
				rightUpperLeg.Transparency = 1
				local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
				local rightFoot = char:FindFirstChild("RightFoot")
				if rightLowerLeg then
					rightLowerLeg.Transparency = 1
				end
				if rightFoot then
					rightFoot.Transparency = 1
				end
				if char:FindFirstChild("KorbloxLeg") then
					return
				end
				local korbloxLeg = Instance.new("Part")
				korbloxLeg.Name = "KorbloxLeg"
				korbloxLeg.Size = Vector3.new(1, 2, 1)
				korbloxLeg.Anchored = false
				korbloxLeg.CanCollide = false
				korbloxLeg.Color = DARK_GREY_COLOR
				korbloxLeg.Parent = char
				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = Enum.MeshType.FileMesh
				mesh.MeshId = KORBLOX_MESH_ID
				mesh.TextureId = KORBLOX_TEXTURE_ID
				mesh.Scale = Vector3.new(1, 1, 1)
				mesh.Name = "KorbloxMesh"
				mesh.Parent = korbloxLeg
				local weld = Instance.new("Weld")
				weld.Part0 = rightUpperLeg
				weld.Part1 = korbloxLeg
				weld.C0 = CFrame.new(0, -0.8, 0)
				weld.Name = "KorbloxWeld"
				weld.Parent = korbloxLeg
			end
		end
	else
		if humanoid.RigType == Enum.HumanoidRigType.R6 then
			local rightLeg = char:FindFirstChild("Right Leg")
			if rightLeg then
				for _, child in ipairs(rightLeg:GetChildren()) do
					if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
						child:Destroy()
					end
				end
				rightLeg.Color = Color3.fromRGB(255, 255, 255)
			end
		elseif humanoid.RigType == Enum.HumanoidRigType.R15 then
			local rightUpperLeg = char:FindFirstChild("RightUpperLeg")
			if rightUpperLeg then
				rightUpperLeg.Transparency = 0
				local rightLowerLeg = char:FindFirstChild("RightLowerLeg")
				local rightFoot = char:FindFirstChild("RightFoot")
				if rightLowerLeg then
					rightLowerLeg.Transparency = 0
				end
				if rightFoot then
					rightFoot.Transparency = 0
				end
				local korbloxLeg = char:FindFirstChild("KorbloxLeg")
				if korbloxLeg then
					korbloxLeg:Destroy()
				end
			end
		end
	end
end

function applyCharterToChar(char)
	if not char then
		return
	end
	applyHeadlessToChar(char, headlessEnabled)
	applyKorbloxToChar(char, korbloxEnabled)
end

LP.CharacterAdded:Connect(function(char)
	task.wait(0.15)
	applyCharterToChar(char)
end)

do
	local acc = 0
	RunService.Heartbeat:Connect(function(dt)
		if not (headlessEnabled or korbloxEnabled) then
			return
		end
		acc = acc + dt
		if acc < 1.0 then
			return
		end
		acc = 0
		local char = LP.Character
		if char then
			pcall(function()
				applyCharterToChar(char)
			end)
		end
	end)
end

-- ============================================================================
-- PLAYER ESP (Secret)
-- ============================================================================
espList = {}
espCharConns = {}

function removeESP(plr)
	local data = espList[plr]
	if data then
		pcall(function()
			if data.nameBB then
				data.nameBB:Destroy()
			end
		end)
		pcall(function()
			if data.highlight then
				data.highlight:Destroy()
			end
		end)
		pcall(function()
			if data.box then
				data.box:Destroy()
			end
		end)
		espList[plr] = nil
	end
	if espCharConns[plr] then
		pcall(function()
			espCharConns[plr]:Disconnect()
		end)
		espCharConns[plr] = nil
	end
end

function addESP(plr)
	if plr == LP then
		return
	end
	if not playerESPEnabled then
		return
	end
	local old = espList[plr]
	if old then
		local dead = false
		if not old.highlight or not old.highlight.Parent then
			dead = true
		end
		if not old.nameBB or not old.nameBB.Parent then
			dead = true
		end
		if dead then
			removeESP(plr)
		else
			return
		end
	end
	local char = plr.Character
	if not char then
		return
	end
	local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not head then
		return
	end
	local accent = UI_ACCENT or Color3.fromRGB(255, 255, 255)
	local fill = Color3.new(
		math.clamp(accent.R * 0.35 + 0.05, 0, 1),
		math.clamp(accent.G * 0.35 + 0.05, 0, 1),
		math.clamp(accent.B * 0.35 + 0.05, 0, 1)
	)
	local highlight = Instance.new("Highlight")
	highlight.Name = "SecretESP_HL"
	highlight.Adornee = char
	highlight.FillColor = fill
	highlight.OutlineColor = accent
	highlight.FillTransparency = 0.72
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Enabled = true
	pcall(function()
		if gethui then
			highlight.Parent = gethui()
		else
			highlight.Parent = game:GetService("CoreGui")
		end
	end)
	if not highlight.Parent then
		highlight.Parent = LP:FindFirstChild("PlayerGui") or workspace
	end
	local nameBB = Instance.new("BillboardGui")
	nameBB.Name = "SecretESP_BB"
	nameBB.Size = UDim2.new(0, 160, 0, 52)
	nameBB.StudsOffset = Vector3.new(0, 3.4, 0)
	nameBB.AlwaysOnTop = true
	nameBB.MaxDistance = 2000
	nameBB.Adornee = head
	nameBB.ResetOnSpawn = false
	pcall(function()
		nameBB.Parent = LP:FindFirstChild("PlayerGui") or LP:WaitForChild("PlayerGui")
	end)
	if not nameBB.Parent then
		nameBB.Parent = head
	end
	local nameLbl = Instance.new("TextLabel")
	nameLbl.Name = "Name"
	nameLbl.Size = UDim2.new(1, 0, 0, 22)
	nameLbl.Position = UDim2.new(0, 0, 0, 0)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = plr.DisplayName ~= plr.Name and (plr.DisplayName .. " (@" .. plr.Name .. ")") or plr.Name
	nameLbl.TextColor3 = accent
	nameLbl.Font = Enum.Font.GothamBlack
	nameLbl.TextSize = 15
	nameLbl.TextStrokeTransparency = 0.15
	nameLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLbl.Parent = nameBB
	local infoLbl = Instance.new("TextLabel")
	infoLbl.Name = "Info"
	infoLbl.Size = UDim2.new(1, 0, 0, 18)
	infoLbl.Position = UDim2.new(0, 0, 0, 22)
	infoLbl.BackgroundTransparency = 1
	infoLbl.Text = "..."
	infoLbl.TextColor3 = Color3.fromRGB(220, 220, 230)
	infoLbl.Font = Enum.Font.GothamBold
	infoLbl.TextSize = 13
	infoLbl.TextStrokeTransparency = 0.25
	infoLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	infoLbl.Parent = nameBB
	local hpBarBg = Instance.new("Frame")
	hpBarBg.Name = "HPBg"
	hpBarBg.Size = UDim2.new(0.7, 0, 0, 5)
	hpBarBg.Position = UDim2.new(0.15, 0, 0, 42)
	hpBarBg.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	hpBarBg.BorderSizePixel = 0
	hpBarBg.Parent = nameBB
	Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(1, 0)
	local hpBar = Instance.new("Frame")
	hpBar.Name = "HP"
	hpBar.Size = UDim2.new(1, 0, 1, 0)
	hpBar.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
	hpBar.BorderSizePixel = 0
	hpBar.Parent = hpBarBg
	Instance.new("UICorner", hpBar).CornerRadius = UDim.new(1, 0)
	espList[plr] = {
		nameBB = nameBB,
		highlight = highlight,
		nameLbl = nameLbl,
		infoLbl = infoLbl,
		hpBar = hpBar,
		hpBarBg = hpBarBg,
		char = char,
	}
	if not espCharConns[plr] then
		espCharConns[plr] = plr.CharacterAdded:Connect(function()
			if not playerESPEnabled then
				return
			end
			task.delay(0.15, function()
				if playerESPEnabled and plr.Parent then
					addESP(plr)
				end
			end)
		end)
	end
end

function refreshESPVisuals()
	if not playerESPEnabled then
		return
	end
	local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	local accent = UI_ACCENT or Color3.fromRGB(255, 255, 255)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr == LP then
			continue
		end
		local data = espList[plr]
		local char = plr.Character
		if not char then
			if data then
				removeESP(plr)
			end
			continue
		end
		if
			not data
			or not data.highlight
			or not data.highlight.Parent
			or data.highlight.Adornee ~= char
			or not data.nameBB
			or not data.nameBB.Parent
		then
			addESP(plr)
			data = espList[plr]
		end
		if not data then
			continue
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		local head = char:FindFirstChild("Head") or root
		if data.highlight then
			data.highlight.Adornee = char
			data.highlight.Enabled = true
			data.highlight.OutlineColor = accent
			data.highlight.FillColor = Color3.new(
				math.clamp(accent.R * 0.35 + 0.05, 0, 1),
				math.clamp(accent.G * 0.35 + 0.05, 0, 1),
				math.clamp(accent.B * 0.35 + 0.05, 0, 1)
			)
			data.highlight.OutlineTransparency = 0
			data.highlight.FillTransparency = 0.72
		end
		if data.nameBB and head then
			data.nameBB.Adornee = head
			data.nameBB.Enabled = true
		end
		local dist = 0
		if myRoot and root then
			dist = (root.Position - myRoot.Position).Magnitude
		end
		local hp, maxHp = 100, 100
		if hum then
			hp = hum.Health
			maxHp = math.max(hum.MaxHealth, 1)
		end
		local ratio = math.clamp(hp / maxHp, 0, 1)
		if data.infoLbl then
			data.infoLbl.Text = string.format("%dm  ·  %d HP", math.floor(dist + 0.5), math.floor(hp + 0.5))
		end
		if data.nameLbl then
			data.nameLbl.TextColor3 = accent
			data.nameLbl.Text = plr.DisplayName ~= plr.Name and (plr.DisplayName .. " (@" .. plr.Name .. ")")
				or plr.Name
		end
		if data.hpBar then
			data.hpBar.Size = UDim2.new(ratio, 0, 1, 0)
			data.hpBar.BackgroundColor3 = ratio > 0.55 and Color3.fromRGB(80, 255, 120)
				or (ratio > 0.25 and Color3.fromRGB(255, 200, 60) or Color3.fromRGB(255, 70, 70))
		end
	end
end

function toggleESP(on)
	playerESPEnabled = on == true
	if playerESPEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP then
				addESP(plr)
			end
		end
		if not espPlayerAdded then
			espPlayerAdded = Players.PlayerAdded:Connect(function(p)
				if p == LP or not playerESPEnabled then
					return
				end
				if not espCharConns[p] then
					espCharConns[p] = p.CharacterAdded:Connect(function()
						if not playerESPEnabled then
							return
						end
						task.delay(0.15, function()
							if playerESPEnabled then
								addESP(p)
							end
						end)
					end)
				end
				if p.Character then
					task.delay(0.15, function()
						if playerESPEnabled then
							addESP(p)
						end
					end)
				end
			end)
		end
		if not espPlayerRemoved then
			espPlayerRemoved = Players.PlayerRemoving:Connect(function(p)
				removeESP(p)
			end)
		end
		if not espRefreshConn then
			local acc = 0
			espRefreshConn = RunService.Heartbeat:Connect(function(dt)
				if not playerESPEnabled then
					return
				end
				acc = acc + (dt or 0.016)
				if acc < 0.2 then
					return
				end
				acc = 0
				pcall(refreshESPVisuals)
			end)
		end
		pcall(refreshESPVisuals)
	else
		for plr, _ in pairs(espList) do
			removeESP(plr)
		end
		if espRefreshConn then
			pcall(function()
				espRefreshConn:Disconnect()
			end)
			espRefreshConn = nil
		end
		if espPlayerAdded then
			pcall(function()
				espPlayerAdded:Disconnect()
			end)
			espPlayerAdded = nil
		end
		if espPlayerRemoved then
			pcall(function()
				espPlayerRemoved:Disconnect()
			end)
			espPlayerRemoved = nil
		end
	end
end

-- ============================================================================
-- PLAYER SPEED DISPLAY (Secret)
-- ============================================================================
playerSpeedGuis = {}
playerSpeedUpdateConn = nil

function createPlayerSpeedGui(plr)
	if plr == LP then
		return
	end
	if playerSpeedGuis[plr] then
		return
	end
	local char = plr.Character
	if not char then
		return
	end
	local head = char:FindFirstChild("Head")
	if not head then
		return
	end
	local old = head:FindFirstChild("MoveePlayerSpeedBB")
	if old then
		old:Destroy()
	end
	local bb = Instance.new("BillboardGui")
	bb.Name = "MoveePlayerSpeedBB"
	bb.Size = UDim2.new(0, 80, 0, 24)
	bb.StudsOffset = Vector3.new(0, 2.2, 0)
	bb.AlwaysOnTop = true
	bb.Adornee = head
	bb.Parent = head
	local label = Instance.new("TextLabel", bb)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "0"
	label.TextColor3 = UI_ACCENT or Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.TextStrokeTransparency = 0
	local conn
	conn = char.AncestryChanged:Connect(function(_, parent)
		if not parent then
			removePlayerSpeedGui(plr)
			if conn then
				conn:Disconnect()
			end
		end
	end)
	playerSpeedGuis[plr] = { gui = bb, label = label, conn = conn }
end

function removePlayerSpeedGui(plr)
	local data = playerSpeedGuis[plr]
	if data then
		if data.conn then
			data.conn:Disconnect()
		end
		if data.gui then
			data.gui:Destroy()
		end
		playerSpeedGuis[plr] = nil
	end
end

function updatePlayerSpeed(plr)
	if not showPlayerSpeeds then
		return
	end
	local data = playerSpeedGuis[plr]
	if not data then
		return
	end
	local char = plr.Character
	if not char then
		removePlayerSpeedGui(plr)
		return
	end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end
	local speed = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
	data.label.Text = string.format("%.1f", speed)
end

function updateAllPlayerSpeeds()
	for plr, _ in pairs(playerSpeedGuis) do
		updatePlayerSpeed(plr)
	end
end

function startPlayerSpeedUpdates()
	if playerSpeedUpdateConn then
		return
	end
	local acc = 0
	playerSpeedUpdateConn = RunService.Heartbeat:Connect(function(dt)
		acc = acc + (dt or 0.016)
		if acc < 0.25 then
			return
		end
		acc = 0
		updateAllPlayerSpeeds()
	end)
end

function stopPlayerSpeedUpdates()
	if playerSpeedUpdateConn then
		playerSpeedUpdateConn:Disconnect()
		playerSpeedUpdateConn = nil
	end
end

function togglePlayerSpeeds(on)
	showPlayerSpeeds = on
	if on then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP then
				createPlayerSpeedGui(plr)
			end
		end
		startPlayerSpeedUpdates()
	else
		for plr, _ in pairs(playerSpeedGuis) do
			removePlayerSpeedGui(plr)
		end
		stopPlayerSpeedUpdates()
	end
end

-- ============================================================================
-- SPEED INDICATOR (Original)
-- ============================================================================
function setupSpeedIndicator(char)
	local head = char:WaitForChild("Head", 5)
	if not head then
		return
	end
	local bb = Instance.new("BillboardGui", head)
	bb.Size = UDim2.new(0, 160, 0, 44)
	bb.StudsOffset = Vector3.new(0, 3, 0)
	bb.AlwaysOnTop = true
	speedLabel = Instance.new("TextLabel", bb)
	speedLabel.Size = UDim2.new(1, 0, 0.55, 0)
	speedLabel.BackgroundTransparency = 1
	speedLabel.Text = "Speed: 0"
	speedLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
	speedLabel.Font = Enum.Font.GothamBold
	speedLabel.TextScaled = true
	speedLabel.TextStrokeTransparency = 0
	speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	local discordLabel = Instance.new("TextLabel", bb)
	discordLabel.Size = UDim2.new(1, 0, 0.45, 0)
	discordLabel.Position = UDim2.new(0, 0, 0.55, 0)
	discordLabel.BackgroundTransparency = 1
	discordLabel.Text = "Dragon Hub"
	discordLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
	discordLabel.Font = Enum.Font.GothamBold
	discordLabel.TextScaled = true
	discordLabel.TextStrokeTransparency = 0
	discordLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
end

-- ============================================================================
-- STEAL (Enhanced with V1/V2/V3 from Secret)
-- ============================================================================
function isMyPlotByName(plotName)
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return false
	end
	local plot = plots:FindFirstChild(plotName)
	if not plot then
		return false
	end
	local sign = plot:FindFirstChild("PlotSign")
	if sign then
		local yb = sign:FindFirstChild("YourBase")
		if yb and yb:IsA("BillboardGui") then
			return yb.Enabled == true
		end
	end
	return false
end

function resetProgressBar()
	if progressPct then
		progressPct.Text = "0%"
	end
	if progressFill then
		progressFill.Size = UDim2.new(0, 0, 1, 0)
	end
end

-- NORMAL STEAL (V1)
animalCache = {}
promptCache = {}
stealCache = {}
normalScanConn = false

function scanPlotNormal(plot)
	if not plot or not plot:IsA("Model") then
		return
	end
	if isMyPlotByName(plot.Name) then
		return
	end
	local podiums = plot:FindFirstChild("AnimalPodiums")
	if not podiums then
		return
	end
	for _, pod in ipairs(podiums:GetChildren()) do
		if pod:IsA("Model") and pod:FindFirstChild("Base") then
			local uid = plot.Name .. "_" .. pod.Name
			local pos = nil
			pcall(function()
				pos = pod:GetPivot().Position
			end)
			if not pos then
				local base = pod:FindFirstChild("Base")
				local spawn = base and base:FindFirstChild("Spawn")
				if spawn and spawn:IsA("BasePart") then
					pos = spawn.Position
				end
			end
			if not pos then
				continue
			end
			local found = false
			for _, ex in ipairs(animalCache) do
				if ex.uid == uid then
					ex.worldPosition = pos
					ex.name = pod.Name
					found = true
					break
				end
			end
			if not found then
				table.insert(
					animalCache,
					{ name = pod.Name, plot = plot.Name, slot = pod.Name, worldPosition = pos, uid = uid }
				)
			end
		end
	end
end

function scanAllPlotsNormal()
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return 0
	end
	local alive = {}
	for _, ad in ipairs(animalCache) do
		local plot = plots:FindFirstChild(ad.plot)
		local pods = plot and plot:FindFirstChild("AnimalPodiums")
		local pod = pods and pods:FindFirstChild(ad.slot)
		if pod then
			table.insert(alive, ad)
		end
	end
	animalCache = alive
	local n = 0
	for _, plot in ipairs(plots:GetChildren()) do
		if plot:IsA("Model") then
			scanPlotNormal(plot)
			n = n + 1
		end
	end
	return n
end

function ensureNormalStealScanner()
	if normalScanConn then
		return
	end
	pcall(scanAllPlotsNormal)
	local plots = workspace:FindFirstChild("Plots")
	if plots and not normalPlotAdded then
		normalPlotAdded = plots.ChildAdded:Connect(function(plot)
			if plot:IsA("Model") then
				task.defer(function()
					scanPlotNormal(plot)
				end)
			end
		end)
	end
	normalScanConn = true
	task.spawn(function()
		while normalScanConn do
			pcall(scanAllPlotsNormal)
			task.wait(2)
		end
	end)
end

function findPromptNormal(ad)
	if not ad then
		return nil
	end
	local cp = promptCache[ad.uid]
	if cp and cp.Parent then
		return cp
	end
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return nil
	end
	local plot = plots:FindFirstChild(ad.plot)
	if not plot then
		return nil
	end
	local pods = plot:FindFirstChild("AnimalPodiums")
	if not pods then
		return nil
	end
	local pod = pods:FindFirstChild(ad.slot)
	if not pod then
		return nil
	end
	local base = pod:FindFirstChild("Base")
	if not base then
		return nil
	end
	local spawn = base:FindFirstChild("Spawn")
	if not spawn then
		return nil
	end
	local att = spawn:FindFirstChild("PromptAttachment")
	local prompt = nil
	if att then
		for _, p in ipairs(att:GetChildren()) do
			if p:IsA("ProximityPrompt") then
				prompt = p
				break
			end
		end
	end
	if not prompt then
		for _, secondaryPrompt in ipairs(spawn:GetDescendants()) do
			if secondaryPrompt:IsA("ProximityPrompt") then
				prompt = secondaryPrompt
				break
			end
		end
	end
	if prompt then
		promptCache[ad.uid] = prompt
	end
	return prompt
end

function nearestAnimalNormal()
	local char = LP.Character
	if not char then
		return nil
	end
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
	if not hrp then
		return nil
	end
	local best, bestD = nil, math.huge
	for _, ad in ipairs(animalCache) do
		if not isMyPlotByName(ad.plot) and ad.worldPosition then
			local d = (hrp.Position - ad.worldPosition).Magnitude
			if d < bestD then
				bestD = d
				best = ad
			end
		end
	end
	return best, bestD
end

function buildCallbacks(prompt)
	if not prompt then
		return nil
	end
	if stealCache[prompt] then
		return stealCache[prompt]
	end
	local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
	if getconnections then
		local success, result = pcall(getconnections, prompt.PromptButtonHoldBegan)
		if success and type(result) == "table" then
			for _, conn in ipairs(result) do
				if type(conn.Function) == "function" then
					table.insert(data.holdCallbacks, conn.Function)
				end
			end
		end
		local secondarySuccess, secondaryResult = pcall(getconnections, prompt.Triggered)
		if secondarySuccess and type(secondaryResult) == "table" then
			for _, conn in ipairs(secondaryResult) do
				if type(conn.Function) == "function" then
					table.insert(data.triggerCallbacks, conn.Function)
				end
			end
		end
	end
	stealCache[prompt] = data
	return data
end

function firePromptFallback(prompt, holdTime)
	holdTime = tonumber(holdTime) or 1.4
	if fireproximityprompt then
		local ok = pcall(function()
			fireproximityprompt(prompt, holdTime)
		end)
		if ok then
			return true
		end
		ok = pcall(function()
			fireproximityprompt(prompt)
		end)
		if ok then
			return true
		end
	end
	local success = pcall(function()
		if prompt.InputHoldBegin then
			prompt:InputHoldBegin()
		end
	end)
	if success then
		task.wait(holdTime)
		pcall(function()
			if prompt.InputHoldEnd then
				prompt:InputHoldEnd()
			end
		end)
		return true
	end
	return false
end

function execStealNormal(prompt, animalName)
	if not prompt or not prompt.Parent then
		return false
	end
	local data = buildCallbacks(prompt)
	if not data or not data.ready then
		return false
	end
	data.ready = false
	isStealing = true
	stealStartTime = tick()
	if progressPct then
		progressPct.Text = "STEALING"
	end
	if progressFill then
		progressFill.Size = UDim2.new(0.05, 0, 1, 0)
	end

	if Conns.progress then
		Conns.progress:Disconnect()
	end
	Conns.progress = RunService.Heartbeat:Connect(function()
		if not isStealing then
			if Conns.progress then
				Conns.progress:Disconnect()
				Conns.progress = nil
			end
			return
		end
		local prog = math.clamp((tick() - stealStartTime) / (Steal.StealDuration or 1.4), 0, 1)
		if progressFill then
			progressFill.Size = UDim2.new(prog, 0, 1, 0)
		end
		if progressPct then
			progressPct.Text = math.floor(prog * 100) .. "%"
		end
	end)

	task.spawn(function()
		local holdT = tonumber(Steal.StealDuration) or 1.4
		if #data.holdCallbacks > 0 then
			for _, fn in ipairs(data.holdCallbacks) do
				task.spawn(fn)
			end
			local elapsed = 0
			while elapsed < holdT and isStealing do
				elapsed = elapsed + task.wait()
			end
			for _, fn in ipairs(data.triggerCallbacks) do
				task.spawn(fn)
			end
		else
			firePromptFallback(prompt, holdT)
		end
		task.wait(0.05)
		if Conns.progress then
			Conns.progress:Disconnect()
			Conns.progress = nil
		end
		isStealing = false
		resetProgressBar()
		data.ready = true
	end)
	return true
end

function startNormalSteal()
	if Conns.autoSteal then
		return
	end
	ensureNormalStealScanner()
	pcall(scanAllPlotsNormal)
	Conns.autoSteal = RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled then
			return
		end
		if stealMode ~= "Normal" and stealMode ~= "V1" then
			return
		end
		if isStealing then
			return
		end
		local target, dist = nearestAnimalNormal()
		if not target then
			if (tick() - (lastStealRescan or 0)) > 1.5 then
				lastStealRescan = tick()
				pcall(scanAllPlotsNormal)
			end
			return
		end
		local radius = Steal.StealRadius
		if dist > radius then
			return
		end
		local prompt = promptCache[target.uid]
		if not prompt or not prompt.Parent then
			prompt = findPromptNormal(target)
		end
		if prompt then
			execStealNormal(prompt, target.name)
		end
	end)
end

function stopNormalSteal()
	if Conns.autoSteal then
		Conns.autoSteal:Disconnect()
		Conns.autoSteal = nil
	end
	isStealing = false
	if Conns.progress then
		Conns.progress:Disconnect()
		Conns.progress = nil
	end
	resetProgressBar()
end

-- SEMI / V2 (from Secret)
function initSemiSync()
	if semi.syncReady then
		return true
	end
	local ok = pcall(function()
		local rs = game:GetService("ReplicatedStorage")
		semi.packages = rs:WaitForChild("Packages", 8)
		semi.datas = rs:WaitForChild("Datas", 8)
		semi.plots = workspace:WaitForChild("Plots", 8)
		if not (semi.packages and semi.datas and semi.plots) then
			return
		end
		semi.animalsData = require(semi.datas:WaitForChild("Animals", 8))
		local sync = semi.packages:WaitForChild("Synchronizer", 8)
		semi.channelFolder = sync:WaitForChild("Channel", 8)
		semi.routeRemote = sync:WaitForChild("CommunicationRoute", 8)
		semi.requestData = sync:FindFirstChild("RequestData")
		for _, child in ipairs(semi.channelFolder:GetChildren()) do
			if child:IsA("RemoteEvent") then
				attachPlotChannel(child, semi.plots, semi.requestData)
			end
		end
		semi.channelFolder.ChildAdded:Connect(function(child)
			if child:IsA("RemoteEvent") then
				attachPlotChannel(child, semi.plots, semi.requestData)
			end
		end)
		semi.routeRemote.OnClientEvent:Connect(function(actions)
			for _, action in ipairs(actions) do
				local kind, channelName = action[1], tostring(action[2])
				if semi.plots and semi.plots:FindFirstChild(channelName) then
					if kind == "ListenerAdded" then
						local remote = semi.channelFolder and semi.channelFolder:FindFirstChild(channelName)
						if remote and remote:IsA("RemoteEvent") then
							attachPlotChannel(remote, semi.plots, semi.requestData)
						end
					elseif kind == "ListenerRemoved" then
						for remote, conn in pairs(semi.plotSync.connections) do
							if tostring(remote.Name) == channelName then
								pcall(function()
									conn:Disconnect()
								end)
								semi.plotSync.connections[remote] = nil
								semi.plotSync.caches[channelName] = nil
								break
							end
						end
					end
				end
			end
		end)
		semi.syncReady = true
	end)
	return ok and semi.syncReady == true
end

function attachPlotChannel(remote, plots, requestData)
	if semi.plotSync.connections[remote] then
		return
	end
	local channelName = tostring(remote.Name)
	if not plots:FindFirstChild(channelName) then
		return
	end
	if requestData and semi.plotSync.caches[channelName] == nil then
		local ok, data = pcall(function()
			return requestData:InvokeServer(channelName)
		end)
		semi.plotSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
	elseif semi.plotSync.caches[channelName] == nil then
		semi.plotSync.caches[channelName] = {}
	end
	semi.plotSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
		for _, packet in ipairs(queue) do
			applySyncDiff(channelName, packet)
		end
	end)
end

function applySyncDiff(channelName, packet)
	local cache = semi.plotSync.caches[channelName]
	if typeof(cache) ~= "table" then
		return
	end
	local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
	local current, parent, key = resolvePath(path, cache)
	if action == "Changed" then
		if parent ~= nil then
			parent[key] = a
		end
	elseif action == "ArrayInsert" then
		if current ~= nil then
			table.insert(current, b, a)
		end
	elseif action == "ArrayRemoved" then
		if current ~= nil then
			table.remove(current, b)
		end
	elseif action == "DictionaryInsert" then
		if current ~= nil then
			current[b] = a
		end
	elseif action == "DictionaryRemoved" then
		if current ~= nil then
			current[b] = nil
		end
	end
end

function resolvePath(path, root)
	local current, parent, key = root, nil, nil
	for _, part in ipairs(splitPath(path)) do
		parent = current
		key = part
		current = current and current[part] or nil
	end
	return current, parent, key
end

function splitPath(path)
	if typeof(path) == "table" then
		return path
	end
	local out = {}
	for part in string.gmatch(tostring(path), "[^%.]+") do
		table.insert(out, tonumber(part) or part)
	end
	return out
end

function getPlotOwner(plot)
	local sign = plot and plot:FindFirstChild("PlotSign")
	local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
	local label = frame and frame:FindFirstChild("TextLabel")
	if not label or label.Text == "Empty Base" then
		return nil
	end
	return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

function isMyBaseAnimal(animalData)
	if not animalData or not animalData.plot or not semi.plots then
		return false
	end
	local plot = semi.plots:FindFirstChild(animalData.plot)
	if not plot then
		return false
	end
	local owner = getPlotOwner(plot)
	return owner == LP.DisplayName or owner == LP.Name
end

function podiumFor(animalData)
	local plot = semi.plots and semi.plots:FindFirstChild(animalData.plot)
	local podiums = plot and plot:FindFirstChild("AnimalPodiums")
	return podiums and podiums:FindFirstChild(animalData.slot) or nil
end

function animalPos(animalData)
	local podium = podiumFor(animalData)
	if not podium then
		return nil
	end
	local ok, pos = pcall(function()
		return podium:GetPivot().Position
	end)
	return ok and pos or nil
end

function distToAnimal(animalData)
	local char = LP.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
	local pos = animalPos(animalData)
	return root and pos and (root.Position - pos).Magnitude or math.huge
end

function findPromptForAnimal(animalData)
	if not animalData then
		return nil
	end
	local cached = semi.promptCache[animalData.uid]
	if cached and cached.Parent then
		return cached
	end
	local podium = podiumFor(animalData)
	local base = podium and podium:FindFirstChild("Base")
	local spawn = base and base:FindFirstChild("Spawn")
	local attach = spawn and spawn:FindFirstChild("PromptAttachment")
	if not attach then
		local search = spawn or podium
		if search then
			for _, d in ipairs(search:GetDescendants()) do
				if d:IsA("ProximityPrompt") then
					semi.promptCache[animalData.uid] = d
					return d
				end
			end
		end
		return nil
	end
	for _, prompt in ipairs(attach:GetChildren()) do
		if prompt:IsA("ProximityPrompt") then
			semi.promptCache[animalData.uid] = prompt
			return prompt
		end
	end
	return nil
end

function scanAllPlotsSemi()
	if not initSemiSync() then
		return 0
	end
	local newCache = {}
	for _, plot in ipairs(semi.plots:GetChildren()) do
		local cache = semi.plotSync.caches[plot.Name]
		local animalList = cache and cache.AnimalList
		if typeof(animalList) == "table" then
			for slot, animalData in pairs(animalList) do
				if type(animalData) == "table" then
					local animalName = animalData.Index
					local info = semi.animalsData and semi.animalsData[animalName]
					if info then
						table.insert(
							newCache,
							{
								name = info.DisplayName or animalName,
								plot = plot.Name,
								slot = tostring(slot),
								uid = plot.Name .. "_" .. tostring(slot),
							}
						)
					elseif animalName then
						table.insert(
							newCache,
							{
								name = tostring(animalName),
								plot = plot.Name,
								slot = tostring(slot),
								uid = plot.Name .. "_" .. tostring(slot),
							}
						)
					end
				end
			end
		end
	end
	semi.animals = newCache
	return #newCache
end

function pickClosest()
	local char = LP.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
	if not root then
		return nil
	end
	local best, bestDist = nil, math.huge
	for _, animalData in ipairs(semi.animals) do
		if not isMyBaseAnimal(animalData) then
			local pos = animalPos(animalData)
			local dist = pos and (root.Position - pos).Magnitude or math.huge
			if dist <= (semi.primeRange or 80) and dist < bestDist then
				best, bestDist = animalData, dist
			end
		end
	end
	return best
end

function buildCallbacksSemi(prompt)
	if not prompt then
		return nil
	end
	if semi.internalCache[prompt] then
		return semi.internalCache[prompt]
	end
	local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
	if getconnections then
		local okHold, holds = pcall(getconnections, prompt.PromptButtonHoldBegan)
		if okHold and type(holds) == "table" then
			for _, conn in ipairs(holds) do
				if type(conn.Function) == "function" then
					table.insert(data.holdCallbacks, conn.Function)
				end
			end
		end
		local okTrigger, triggers = pcall(getconnections, prompt.Triggered)
		if okTrigger and type(triggers) == "table" then
			for _, conn in ipairs(triggers) do
				if type(conn.Function) == "function" then
					table.insert(data.triggerCallbacks, conn.Function)
				end
			end
		end
	end
	semi.internalCache[prompt] = data
	return data
end

function firePromptFallbackSemi(prompt, holdTime)
	holdTime = tonumber(holdTime) or 1.3
	if fireproximityprompt then
		local ok = pcall(function()
			fireproximityprompt(prompt, holdTime)
		end)
		if ok then
			return true
		end
		ok = pcall(function()
			fireproximityprompt(prompt)
		end)
		if ok then
			return true
		end
	end
	local success = pcall(function()
		if prompt.InputHoldBegin then
			prompt:InputHoldBegin()
		end
	end)
	if success then
		task.wait(holdTime)
		pcall(function()
			if prompt.InputHoldEnd then
				prompt:InputHoldEnd()
			end
		end)
		return true
	end
	return false
end

function executeSemi(prompt, animalData)
	if not prompt or not prompt.Parent or not animalData then
		return false
	end
	local data = buildCallbacksSemi(prompt)
	if not data or not data.ready then
		return false
	end
	data.ready = false
	semi.state.active = true
	semi.state.startTime = tick()
	semi.state.phase = "holding"
	semi.state.label = animalData.name or "Animal"
	isStealing = true
	stealStartTime = semi.state.startTime

	task.spawn(function()
		local startTime = semi.state.startTime
		local holdMin = tonumber(semi.holdMin) or 1.3
		local holdMax = tonumber(semi.holdMax) or 2.6
		local radius = tonumber(semi.radius) or 9
		local label = semi.state.label
		if #data.holdCallbacks > 0 then
			for _, fn in ipairs(data.holdCallbacks) do
				task.spawn(function()
					pcall(fn)
				end)
			end
		else
			pcall(function()
				if prompt.InputHoldBegin then
					prompt:InputHoldBegin()
				end
			end)
		end
		while semi.enabled and (stealMode == "Semi" or stealMode == "V2" or stealMode == "V3") do
			local elapsed = tick() - startTime
			if elapsed >= holdMin then
				break
			end
			local p = math.min(math.clamp(elapsed / holdMax, 0, 1), 0.75)
			if progressPct then
				progressPct.Text = "HOLDING " .. tostring(label) .. " " .. math.floor(p * 100) .. "%"
			end
			if progressFill then
				progressFill.Size = UDim2.new(p, 0, 1, 0)
			end
			task.wait()
		end
		semi.state.phase = "waitingRange"
		local alreadyInRange = distToAnimal(animalData) <= radius
		local fired = false
		while semi.enabled and (stealMode == "Semi" or stealMode == "V2" or stealMode == "V3") and prompt.Parent do
			local elapsed = tick() - startTime
			if elapsed > holdMax then
				break
			end
			local inRange = distToAnimal(animalData) <= radius
			local p = inRange and 0.75 or math.min(elapsed / holdMax, 0.75)
			if progressFill then
				progressFill.Size = UDim2.new(p, 0, 1, 0)
			end
			if progressPct then
				progressPct.Text = inRange and ("HOLD 75% " .. tostring(label))
					or ("MOVE CLOSER " .. tostring(label) .. " " .. math.floor(p * 100) .. "%")
			end
			if inRange then
				semi.state.phase = "finishing"
				local delay = tonumber(semi.entryDelay) or 0.3
				if not alreadyInRange and delay > 0 then
					task.wait(delay)
				end
				if semi.enabled and (stealMode == "Semi" or stealMode == "V2" or stealMode == "V3") then
					if #data.triggerCallbacks > 0 then
						for _, fn in ipairs(data.triggerCallbacks) do
							task.spawn(function()
								pcall(fn)
							end)
						end
					else
						firePromptFallbackSemi(prompt, 0.05)
					end
					fired = true
				end
				break
			end
			task.wait()
		end
		semi.state.lastResult = fired and ("Stole " .. tostring(label)) or ("Missed window: " .. tostring(label))
		semi.state.active = false
		semi.state.phase = fired and "success" or "failed"
		semi.state.lastResultTime = tick()
		if fired then
			if progressFill then
				progressFill.Size = UDim2.new(1, 0, 1, 0)
			end
			if progressPct then
				progressPct.Text = "STOLE " .. tostring(label)
			end
		else
			if progressPct then
				progressPct.Text = semi.state.lastResult
			end
			resetProgressBar()
		end
		task.wait(tonumber(semi.cooldown) or 0.05)
		data.ready = true
		isStealing = false
		resetProgressBar()
	end)
	return true
end

function startSemiSteal()
	semi.enabled = true
	semi.holdMin = 1.3
	semi.holdMax = 2.6
	semi.entryDelay = 0.3
	semi.cooldown = 0.05
	semi.primeRange = 80
	semi.radius = math.min(tonumber(semi.radius) or 9, 10)
	task.spawn(function()
		initSemiSync()
		pcall(scanAllPlotsSemi)
	end)
	if semi.conn then
		semi.conn:Disconnect()
		semi.conn = nil
	end
	semi.conn = RunService.Heartbeat:Connect(function()
		if not semi.enabled then
			return
		end
		if not Steal.AutoStealEnabled then
			return
		end
		if stealMode ~= "Semi" and stealMode ~= "V2" and stealMode ~= "V3" then
			stopSemiSteal()
			return
		end
		if semi.state.active then
			return
		end
		if #(semi.animals or {}) == 0 then
			if (tick() - (semi._lastScan or 0)) > 1.25 then
				semi._lastScan = tick()
				pcall(scanAllPlotsSemi)
			end
		end
		local target = pickClosest()
		if not target then
			return
		end
		local prompt = findPromptForAnimal(target)
		if prompt then
			executeSemi(prompt, target)
		end
	end)
	if not semi.scanThread then
		semi.scanThread = true
		task.spawn(function()
			while semi.scanThread do
				pcall(function()
					initSemiSync()
					scanAllPlotsSemi()
				end)
				task.wait(4)
			end
		end)
	end
end

function stopSemiSteal()
	semi.enabled = false
	if semi.conn then
		semi.conn:Disconnect()
		semi.conn = nil
	end
	semi.state.active = false
	semi.state.phase = "idle"
	isStealing = false
	resetProgressBar()
end

-- V3
function startV3Steal()
	semi.holdMin = 1.3
	semi.holdMax = 2.6
	semi.entryDelay = 0.3
	semi.cooldown = 0.05
	semi.primeRange = 80
	semi.radius = tonumber(semi.radius) or 9
	if semi.radius < 1 then
		semi.radius = 9
	end
	v3.enabled = true
	startSemiSteal()
end

function stopV3Steal()
	v3.enabled = false
	if stealMode == "V3" or not Steal.AutoStealEnabled then
		stopSemiSteal()
	end
	v3.progress = 0
	v3.currentUid = nil
	v3.holding = false
	v3.holdPrompt = nil
	v3.cooldownUntil = 0
	isStealing = false
	resetProgressBar()
end

function startAutoSteal()
	Steal.AutoStealEnabled = true
	local mode = stealMode or "V1"
	if mode == "Semi" or mode == "V2" then
		startSemiSteal()
	elseif mode == "V3" then
		startV3Steal()
	else
		startNormalSteal()
	end
end

function stopAutoSteal()
	Steal.AutoStealEnabled = false
	stopNormalSteal()
	stopSemiSteal()
	stopV3Steal()
	isStealing = false
	resetProgressBar()
end

function getActiveStealRadius()
	if stealMode == "Semi" or stealMode == "V2" or stealMode == "V3" then
		return math.min(tonumber(semi.radius) or 9, 10)
	end
	return Steal.StealRadius
end

-- ============================================================================
-- UI BUILD (Dragon Hub GUI, enhanced with new toggles)
-- ============================================================================
function udimToTable(u)
	if not u then
		return nil
	end
	return { sx = u.X.Scale, ox = u.X.Offset, sy = u.Y.Scale, oy = u.Y.Offset }
end

function tableToUdim(t)
	if type(t) ~= "table" then
		return nil
	end
	return UDim2.new(t.sx or 0, t.ox or 0, t.sy or 0, t.oy or 0)
end

function collectCurrentSettings()
	local function ks(e)
		if not e then
			return { kb = nil, gp = nil }
		end
		return { kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil }
	end
	return {
		normalSpeed = NS,
		carrySpeed = CS,
		laggerSpeed = LAGGER_SPEED,
		laggerCarrySpeed = LAGGER_CARRY_SPEED,
		dropBrainrotKey = ks(KB.DropBrainrot),
		autoLeftKey = ks(KB.AutoLeft),
		autoRightKey = ks(KB.AutoRight),
		autoBatKey = ks(KB.AutoBat),
		laggerToggleKey = ks(KB.LaggerToggle),
		tpFloorKey = ks(KB.TPFloor),
		instaResetKey = ks(KB.InstaReset),
		guiHideKey = ks(KB.GuiHide),
		speedToggleKey = ks(KB.SpeedToggle),
		bypassAimbotKey = ks(KB.BypassAimbot),
		grabRadius = Steal.StealRadius,
		stealDuration = Steal.StealDuration,
		stealMode = stealMode,
		antiRagdoll = antiRagdollEnabled,
		autoStealEnabled = Steal.AutoStealEnabled,
		infiniteJump = infJumpEnabled,
		infJumpMode = infJumpMode,
		medusaCounter = medusaCounterEnabled,
		batCounter = batCounterEnabled,
		carryMode = speedMode,
		laggerMode = laggerToggled,
		laggerCarryMode = laggerPhase == 2,
		autoBat = autoBatEnabled,
		autoSwing = autoSwingEnabled,
		unwalkEnabled = unwalkEnabled,
		antiKick = antiKickEnabled,
		antiLag = antiLagEnabled,
		stretchRez = stretchRezEnabled,
		autoTPEnabled = autoTPEnabled,
		autoTPHeight = autoTPHeight,
		mobileButtonsVisible = mobileButtonsVisible,
		mobileButtonsLocked = mobileButtonsLocked,
		bypassAimbotEnabled = bypassAimbotEnabled,
		tpBatMode = tpBatMode,
		antiBypassBatEnabled = antiBypassBatEnabled,
		antiDieEnabled = antiDieEnabled,
		antiDieV2Enabled = antiDieV2Enabled,
		darkMode = darkModeEnabled,
		fpsUnlock = fpsUnlockEnabled,
		currentSkyTheme = currentSkyTheme,
		animPack = animPack,
		animPackEnabled = animPackEnabled,
		headlessEnabled = headlessEnabled,
		korbloxEnabled = korbloxEnabled,
		playerESPEnabled = playerESPEnabled,
		showPlayerSpeeds = showPlayerSpeeds,
		autoSwitchSpeedEnabled = autoSwitchSpeedEnabled,
		autoSwitchLaggerSpeedEnabled = autoSwitchLaggerSpeedEnabled,
		autoRadiusEnabled = autoRadiusEnabled,
		semiRadius = semi and semi.radius,
		semiHoldMin = semi and semi.holdMin,
		semiHoldMax = semi and semi.holdMax,
		semiEntryDelay = semi and semi.entryDelay,
		semiPrimeRange = semi and semi.primeRange,
		ragdollGuiEnabled = ragdollGuiEnabled,
		introSoundEnabled = introSoundEnabled,
		introSongChoice = introSongChoice,
		introGUIEnabled = introGUIEnabled,
		removeAccEnabled = removeAccEnabled,
		autoResetOnDeath = autoResetOnDeath,
		-- UI positions
		mainPos = _G.dragonMainFrame and udimToTable(_G.dragonMainFrame.Position) or nil,
		miniPos = _G.dragonMiniBtn and udimToTable(_G.dragonMiniBtn.Position) or nil,
		mobilePos = mobileButtonsFrame and udimToTable(mobileButtonsFrame.Position) or nil,
		progressPos = _G.dragonProgressFrame and udimToTable(_G.dragonProgressFrame.Position) or nil,
	}
end

function readCursedFile()
	if not (isfile and isfile("dragon.json")) then
		return { active = "default", presets = {} }
	end
	local ok, data = pcall(function()
		return HS:JSONDecode(readfile("dragon.json"))
	end)
	if not ok or type(data) ~= "table" then
		return { active = "default", presets = {} }
	end
	if type(data.presets) ~= "table" then
		data.presets = {}
	end
	if type(data.active) ~= "string" then
		data.active = "default"
	end
	return data
end

function writeCursedFile(data)
	if not writefile then
		return false
	end
	local ok, encoded = pcall(function()
		return HS:JSONEncode(data)
	end)
	if not ok or not encoded then
		return false
	end
	local success = pcall(function()
		writefile("dragon.json", encoded)
	end)
	return success == true
end

function saveConfig()
	local data = readCursedFile()
	local settings = collectCurrentSettings()
	data.presets = data.presets or {}
	local name = (type(data.active) == "string" and data.active ~= "" and data.active) or "default"
	data.presets[name] = settings
	data.active = name
	data.lastSave = os.time and os.time() or 0
	return writeCursedFile(data)
end

function savePreset(presetName)
	if type(presetName) ~= "string" then
		return false
	end
	presetName = presetName:gsub("^%s+", ""):gsub("%s+$", "")
	if presetName == "" then
		return false
	end
	local data = readCursedFile()
	data.presets = data.presets or {}
	data.presets[presetName] = collectCurrentSettings()
	data.active = presetName
	data.lastSave = os.time and os.time() or 0
	return writeCursedFile(data)
end

function applySettings(cfg)
	if type(cfg) ~= "table" then
		return
	end
	local function lk(e, d)
		if type(d) ~= "table" then
			return
		end
		if d.kb and Enum.KeyCode[d.kb] then
			e.kb = Enum.KeyCode[d.kb]
			e.gp = nil
		end
		if d.gp and Enum.KeyCode[d.gp] then
			e.gp = Enum.KeyCode[d.gp]
			e.kb = nil
		end
	end
	if cfg.normalSpeed then
		NS = cfg.normalSpeed
	end
	if cfg.carrySpeed then
		CS = cfg.carrySpeed
	end
	if cfg.laggerSpeed then
		LAGGER_SPEED = cfg.laggerSpeed
	end
	if cfg.laggerCarrySpeed then
		LAGGER_CARRY_SPEED = cfg.laggerCarrySpeed
	end
	lk(KB.DropBrainrot, cfg.dropBrainrotKey)
	lk(KB.AutoLeft, cfg.autoLeftKey)
	lk(KB.AutoRight, cfg.autoRightKey)
	lk(KB.AutoBat, cfg.autoBatKey)
	lk(KB.LaggerToggle, cfg.laggerToggleKey)
	lk(KB.TPFloor, cfg.tpFloorKey)
	lk(KB.InstaReset, cfg.instaResetKey)
	lk(KB.GuiHide, cfg.guiHideKey)
	lk(KB.SpeedToggle, cfg.speedToggleKey)
	lk(KB.BypassAimbot, cfg.bypassAimbotKey)
	if cfg.grabRadius then
		Steal.StealRadius = cfg.grabRadius
	end
	if cfg.stealDuration then
		Steal.StealDuration = cfg.stealDuration
	end
	if cfg.stealMode then
		stealMode = cfg.stealMode
	end
	if cfg.antiRagdoll ~= nil then
		antiRagdollEnabled = cfg.antiRagdoll
	end
	if cfg.autoStealEnabled ~= nil then
		Steal.AutoStealEnabled = cfg.autoStealEnabled
	end
	if cfg.infiniteJump ~= nil then
		infJumpEnabled = cfg.infiniteJump
	end
	if cfg.infJumpMode == "hold" or cfg.infJumpMode == "manual" then
		infJumpMode = cfg.infJumpMode
	end
	if cfg.medusaCounter ~= nil then
		medusaCounterEnabled = cfg.medusaCounter
	end
	if cfg.batCounter ~= nil then
		batCounterEnabled = cfg.batCounter
	end
	if cfg.carryMode ~= nil then
		speedMode = cfg.carryMode
	end
	if cfg.laggerMode ~= nil then
		laggerToggled = cfg.laggerMode
	end
	if cfg.laggerCarryMode then
		laggerPhase = 2
	elseif cfg.laggerMode then
		laggerPhase = 1
	end
	if cfg.autoBat ~= nil then
		autoBatEnabled = cfg.autoBat
	end
	if cfg.autoSwing ~= nil then
		autoSwingEnabled = cfg.autoSwing
	end
	if cfg.unwalkEnabled ~= nil then
		unwalkEnabled = cfg.unwalkEnabled
	end
	if cfg.antiKick ~= nil then
		antiKickEnabled = cfg.antiKick
	end
	if cfg.antiLag ~= nil then
		antiLagEnabled = cfg.antiLag
	end
	if cfg.stretchRez ~= nil then
		stretchRezEnabled = cfg.stretchRez
	end
	if cfg.autoTPEnabled ~= nil then
		autoTPEnabled = cfg.autoTPEnabled
	end
	if cfg.autoTPHeight then
		autoTPHeight = cfg.autoTPHeight
	end
	if cfg.mobileButtonsVisible ~= nil then
		mobileButtonsVisible = cfg.mobileButtonsVisible
	end
	if cfg.mobileButtonsLocked ~= nil then
		mobileButtonsLocked = cfg.mobileButtonsLocked
	end
	if cfg.bypassAimbotEnabled ~= nil then
		bypassAimbotEnabled = cfg.bypassAimbotEnabled
	end
	if cfg.tpBatMode then
		tpBatMode = cfg.tpBatMode
	end
	if cfg.antiBypassBatEnabled ~= nil then
		antiBypassBatEnabled = cfg.antiBypassBatEnabled
	end
	if cfg.antiDieEnabled ~= nil then
		antiDieEnabled = cfg.antiDieEnabled
	end
	if cfg.antiDieV2Enabled ~= nil then
		antiDieV2Enabled = cfg.antiDieV2Enabled
	end
	if cfg.darkMode ~= nil then
		darkModeEnabled = cfg.darkMode
	end
	if cfg.fpsUnlock ~= nil then
		fpsUnlockEnabled = cfg.fpsUnlock
	end
	if cfg.currentSkyTheme then
		currentSkyTheme = cfg.currentSkyTheme
	end
	if cfg.animPack then
		animPack = cfg.animPack
	end
	if cfg.animPackEnabled ~= nil then
		animPackEnabled = cfg.animPackEnabled
	end
	if cfg.headlessEnabled ~= nil then
		headlessEnabled = cfg.headlessEnabled
	end
	if cfg.korbloxEnabled ~= nil then
		korbloxEnabled = cfg.korbloxEnabled
	end
	if cfg.playerESPEnabled ~= nil then
		playerESPEnabled = cfg.playerESPEnabled
	end
	if cfg.showPlayerSpeeds ~= nil then
		showPlayerSpeeds = cfg.showPlayerSpeeds
	end
	if cfg.autoSwitchSpeedEnabled ~= nil then
		autoSwitchSpeedEnabled = cfg.autoSwitchSpeedEnabled
	end
	if cfg.autoSwitchLaggerSpeedEnabled ~= nil then
		autoSwitchLaggerSpeedEnabled = cfg.autoSwitchLaggerSpeedEnabled
	end
	if cfg.autoRadiusEnabled ~= nil then
		autoRadiusEnabled = cfg.autoRadiusEnabled
	end
	if cfg.semiRadius and semi then
		semi.radius = math.min(cfg.semiRadius, 10)
	end
	if cfg.semiHoldMin and semi then
		semi.holdMin = cfg.semiHoldMin
	end
	if cfg.semiHoldMax and semi then
		semi.holdMax = cfg.semiHoldMax
	end
	if cfg.semiEntryDelay and semi then
		semi.entryDelay = cfg.semiEntryDelay
	end
	if cfg.semiPrimeRange and semi then
		semi.primeRange = cfg.semiPrimeRange
	end
	if cfg.ragdollGuiEnabled ~= nil then
		ragdollGuiEnabled = cfg.ragdollGuiEnabled
	end
	if cfg.introSoundEnabled ~= nil then
		introSoundEnabled = cfg.introSoundEnabled
	end
	if cfg.introSongChoice then
		introSongChoice = cfg.introSongChoice
	end
	if cfg.introGUIEnabled ~= nil then
		introGUIEnabled = cfg.introGUIEnabled
	end
	if cfg.removeAccEnabled ~= nil then
		removeAccEnabled = cfg.removeAccEnabled
	end
	if cfg.autoResetOnDeath ~= nil then
		autoResetOnDeath = cfg.autoResetOnDeath
	end

	-- Restore positions
	local mp = tableToUdim(cfg.mainPos)
	if mp and _G.dragonMainFrame then
		_G.dragonMainFrame.Position = mp
	end
	local minp = tableToUdim(cfg.miniPos)
	if minp and _G.dragonMiniBtn then
		_G.dragonMiniBtn.Position = minp
	end
	local mobp = tableToUdim(cfg.mobilePos)
	if mobp and mobileButtonsFrame then
		mobileButtonsFrame.Position = mobp
	end
	local pp = tableToUdim(cfg.progressPos)
	if pp and _G.dragonProgressFrame then
		_G.dragonProgressFrame.Position = pp
	end

	if mobileButtonsFrame then
		mobileButtonsFrame.Visible = mobileButtonsVisible
	end
	if refreshMobileButtons then
		pcall(refreshMobileButtons)
	end
	if refreshSpeedModeLabel then
		pcall(refreshSpeedModeLabel)
	end
	if progressRadLbl then
		progressRadLbl.Text = string.format("Radius: %.2g", Steal.StealRadius)
	end
end

function loadConfig()
	local data = readCursedFile()
	local name = data.active or "default"
	local cfg = data.presets and data.presets[name]
	-- migrate old dragon.json once
	if not cfg and isfile and isfile("dragon.json") then
		local ok, old = pcall(function()
			return HS:JSONDecode(readfile("dragon.json"))
		end)
		if ok and type(old) == "table" then
			cfg = old
			data.presets = data.presets or {}
			data.presets["default"] = old
			data.active = "default"
			writeCursedFile(data)
		end
	end
	if cfg then
		applySettings(cfg)
	end
end

function loadPreset(presetName)
	if type(presetName) ~= "string" then
		return false, "empty"
	end
	presetName = presetName:gsub("^%s+", ""):gsub("%s+$", "")
	if presetName == "" then
		return false, "empty"
	end
	local data = readCursedFile()
	local cfg = data.presets and data.presets[presetName]
	if not cfg then
		return false, "not found"
	end
	data.active = presetName
	writeCursedFile(data)
	applySettings(cfg)
	-- Re-apply live feature states after GUI exists
	task.spawn(function()
		task.wait(0.05)
		if antiRagdollEnabled then
			pcall(startAntiRagdoll)
		else
			pcall(stopAntiRagdoll)
		end
		if Steal.AutoStealEnabled then
			pcall(startAutoSteal)
		else
			pcall(stopAutoSteal)
		end
		if infJumpEnabled then
			pcall(applyInfJumpMode)
		else
			pcall(stopHoldInfJump)
		end
		if medusaCounterEnabled then
			pcall(function()
				setupMedusa(LP.Character)
			end)
		else
			pcall(stopMedusaCounter)
		end
		if batCounterEnabled then
			pcall(startBatCounter)
		else
			pcall(stopBatCounter)
		end
		if unwalkEnabled then
			pcall(startUnwalk)
		else
			pcall(stopUnwalk)
		end
		if autoTPEnabled then
			pcall(startAutoTP)
		else
			pcall(stopAutoTP)
		end
		if antiKickEnabled then
			pcall(enableAntiKick)
		else
			pcall(disableAntiKick)
		end
		if antiLagEnabled then
			pcall(enableAntiLag)
		else
			pcall(disableAntiLag)
		end
		if stretchRezEnabled then
			pcall(enableStretchRez)
		else
			pcall(disableStretchRez)
		end
		if autoBatEnabled then
			pcall(queueAutoBatStart)
		else
			pcall(stopBatAimbot)
		end
		if bypassAimbotEnabled then
			pcall(startBypassAimbot)
		else
			pcall(stopBypassAimbot)
		end
		if antiBypassBatEnabled then
			pcall(startAntiBypassBat)
		else
			pcall(stopAntiBypassBat)
		end
		if setAntiRagVisual then
			pcall(function()
				setAntiRagVisual(antiRagdollEnabled)
			end)
		end
		if setInfJumpVisual then
			pcall(function()
				setInfJumpVisual(infJumpEnabled)
			end)
		end
		if setMedusaVisual then
			pcall(function()
				setMedusaVisual(medusaCounterEnabled)
			end)
		end
		if setBatCounterVisual then
			pcall(function()
				setBatCounterVisual(batCounterEnabled)
			end)
		end
		if setUnwalkVisual then
			pcall(function()
				setUnwalkVisual(unwalkEnabled)
			end)
		end
		if setAntiKickVisual then
			pcall(function()
				setAntiKickVisual(antiKickEnabled)
			end)
		end
		if setAntiLagVisual then
			pcall(function()
				setAntiLagVisual(antiLagEnabled)
			end)
		end
		if setStretchRezVisual then
			pcall(function()
				setStretchRezVisual(stretchRezEnabled)
			end)
		end
		if setAutoTPVisual then
			pcall(function()
				setAutoTPVisual(autoTPEnabled)
			end)
		end
		if autoBatSetVisual then
			pcall(function()
				autoBatSetVisual(autoBatEnabled)
			end)
		end
		if setBypassVisual then
			pcall(function()
				setBypassVisual(bypassAimbotEnabled)
			end)
		end
		if setInstaGrab then
			pcall(function()
				setInstaGrab(Steal.AutoStealEnabled)
			end)
		end
		if setMobileButtonsVisual then
			pcall(function()
				setMobileButtonsVisual(mobileButtonsVisible)
			end)
		end
		if setMobileLockVisual then
			pcall(function()
				setMobileLockVisual(mobileButtonsLocked)
			end)
		end
		if refreshMobileButtons then
			pcall(refreshMobileButtons)
		end
		if refreshSpeedModeLabel then
			pcall(refreshSpeedModeLabel)
		end
	end)
	return true
end

function refreshSpeedModeLabel()
	if modeValLbl then
		modeValLbl.Text = laggerToggled and (laggerPhase == 2 and "Lagger Carry" or "Lagger Normal")
			or (speedMode and "Carry" or "Normal")
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
end

function toggleCarryMode()
	if laggerToggled then
		laggerToggled = false
		laggerPhase = 0
		speedMode = true
	else
		speedMode = not speedMode
	end
	refreshSpeedModeLabel()
	saveConfig()
end

function toggleLaggerMode()
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
	saveConfig()
end

function toggleAutoLeftAction()
	autoLeftEnabled = not autoLeftEnabled
	if autoLeftEnabled then
		if autoRightEnabled then
			autoRightEnabled = false
			stopAutoRight()
		end
		if autoBatEnabled then
			stopBatAimbot()
		end
		startAutoLeft()
	else
		stopAutoLeft()
	end
	if autoLeftSetVisual then
		autoLeftSetVisual(autoLeftEnabled)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
	saveConfig()
end

function toggleAutoRightAction()
	autoRightEnabled = not autoRightEnabled
	if autoRightEnabled then
		if autoLeftEnabled then
			autoLeftEnabled = false
			stopAutoLeft()
		end
		if autoBatEnabled then
			stopBatAimbot()
		end
		startAutoRight()
	else
		stopAutoRight()
	end
	if autoRightSetVisual then
		autoRightSetVisual(autoRightEnabled)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
	saveConfig()
end

function toggleAutoBatAction()
	if not autoBatEnabled then
		queueAutoBatStart()
		if autoBatSetVisual then
			autoBatSetVisual(true)
		end
	else
		stopBatAimbot()
		if autoBatSetVisual then
			autoBatSetVisual(false)
		end
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
	saveConfig()
end

function toggleBypassAimbotAction()
	if bypassAimbotEnabled then
		stopBypassAimbot()
	else
		startBypassAimbot()
	end
	if setBypassVisual then
		setBypassVisual(bypassAimbotEnabled)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
	saveConfig()
end

function toggleAntiBypassBatAction()
	if antiBypassBatEnabled then
		stopAntiBypassBat()
	else
		startAntiBypassBat()
	end
	if setAntiBypassBatVisual then
		setAntiBypassBatVisual(antiBypassBatEnabled)
	end
	if refreshMobileButtons then
		refreshMobileButtons()
	end
	saveConfig()
end

function toggleBodyLockAction()
	bodyLockEnabled = false
end

function toggleAutoPlayAction()
	autoPlayEnabled = false
	stopAutoPlay()
end

-- ============================================================================
-- BUILD GUI (Dragon Hub UI with enhanced rows)
-- ============================================================================
function buildGui()
	local BG = Color3.fromRGB(5, 5, 7)
	local backgroundColor3 = Color3.fromRGB(9, 9, 13)
	local CARD = Color3.fromRGB(14, 14, 18)
	local HOV = Color3.fromRGB(22, 22, 28)
	local RED = Color3.fromRGB(235, 235, 235)
	local REDDIM = Color3.fromRGB(180, 180, 185)
	local STROKE = Color3.fromRGB(70, 70, 78)
	local W = Color3.fromRGB(235, 235, 235)
	local DIM = Color3.fromRGB(90, 90, 100)
	local INP = Color3.fromRGB(10, 10, 14)
	local OFF = Color3.fromRGB(28, 28, 35)

	local old = game:GetService("CoreGui"):FindFirstChild("DragonHub")
	if old then
		old:Destroy()
	end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then
		local o = pg:FindFirstChild("DragonHub")
		if o then
			o:Destroy()
		end
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "DragonHub"
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
		gui.Parent = LP:WaitForChild("PlayerGui")
	end

	local main = Instance.new("Frame", gui)
	main.Size = UDim2.new(0, 260, 0, 400)
	main.Position = UDim2.new(0, 20, 0, 20)
	_G.dragonMainFrame = main
	main.BackgroundColor3 = BG
	main.BorderSizePixel = 0
	main.ClipsDescendants = false
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

	local mobileDragMoved = false
	local function isMobileDragTarget(obj)
		return obj == mobileButtonsFrame or (mobileButtonsFrame and obj.Parent == mobileButtonsFrame)
	end

	local function drag(f, target)
		local dn, ds, sp, di = false
		local moveTarget = target or f
		f.InputBegan:Connect(function(i)
			if isMobileDragTarget(moveTarget) then
				mobileDragMoved = false
			end
			if isMobileDragTarget(moveTarget) and mobileButtonsLocked then
				return
			end
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dn = true
				ds = i.Position
				sp = moveTarget.Position
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End then
						dn = false
					end
				end)
			end
		end)
		f.InputChanged:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
				di = i
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if isMobileDragTarget(moveTarget) and mobileButtonsLocked then
				dn = false
				return
			end
			if i == di and dn then
				if isMobileDragTarget(moveTarget) and ((i.Position.X - ds.X) ^ 2 + (i.Position.Y - ds.Y) ^ 2) > 36 then
					mobileDragMoved = true
				end
				local nX = sp.X.Offset + (i.Position.X - ds.X)
				local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
				moveTarget.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
			end
		end)
	end
	drag(main)

	local hdr = Instance.new("Frame", main)
	hdr.Size = UDim2.new(1, 0, 0, 36)
	hdr.BackgroundColor3 = backgroundColor3
	hdr.BorderSizePixel = 0
	Instance.new("UICorner", hdr).CornerRadius = UDim.new(0, 10)
	local ttl = Instance.new("TextLabel", hdr)
	ttl.Size = UDim2.new(1, -50, 1, 0)
	ttl.Position = UDim2.new(0, 10, 0, 0)
	ttl.BackgroundTransparency = 1
	ttl.Text = "DRAGON HUB"
	ttl.TextColor3 = RED
	ttl.Font = Enum.Font.GothamBlack
	ttl.TextSize = 12
	ttl.TextXAlignment = Enum.TextXAlignment.Left
	local closeBtn = Instance.new("TextButton", hdr)
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -30, 0.5, -12)
	closeBtn.BackgroundColor3 = backgroundColor3
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "-"
	closeBtn.TextColor3 = REDDIM
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 18
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
	closeBtn.MouseEnter:Connect(function()
		TS:Create(closeBtn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(28, 28, 34), TextColor3 = REDDIM })
			:Play()
	end)
	closeBtn.MouseLeave:Connect(function()
		TS:Create(closeBtn, TweenInfo.new(0.1), { BackgroundColor3 = backgroundColor3, TextColor3 = REDDIM }):Play()
	end)

	local miniBtn = Instance.new("TextButton", gui)
	miniBtn.Size = UDim2.new(0, 96, 0, 24)
	miniBtn.Position = UDim2.new(0, 26, 0, 26)
	miniBtn.BackgroundColor3 = backgroundColor3
	miniBtn.BorderSizePixel = 0
	miniBtn.Text = "DRAGON HUB"
	miniBtn.TextColor3 = RED
	miniBtn.Font = Enum.Font.GothamBold
	miniBtn.TextSize = 10
	miniBtn.ZIndex = 20
	miniBtn.Visible = false
	_G.dragonMiniBtn = miniBtn
	Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 8)
	local miniStroke = Instance.new("UIStroke", miniBtn)
	miniStroke.Color = STROKE
	miniStroke.Thickness = 1.2
	drag(miniBtn)
	miniBtn.MouseEnter:Connect(function()
		TS:Create(miniBtn, TweenInfo.new(0.1), { BackgroundColor3 = HOV }):Play()
	end)
	miniBtn.MouseLeave:Connect(function()
		TS:Create(miniBtn, TweenInfo.new(0.1), { BackgroundColor3 = backgroundColor3 }):Play()
	end)
	local function showGui()
		main.Visible = true
		miniBtn.Visible = false
	end
	local function hideGui()
		main.Visible = false
		miniBtn.Visible = true
	end
	closeBtn.MouseButton1Click:Connect(hideGui)
	miniBtn.MouseButton1Click:Connect(showGui)

	-- Mobile Buttons
	mobileButtonsFrame = Instance.new("Frame", gui)
	mobileButtonsFrame.Size = UDim2.new(0, 148, 0, 268)
	mobileButtonsFrame.Position = UDim2.new(1, -164, 0.5, -134)
	mobileButtonsFrame.BackgroundTransparency = 1
	mobileButtonsFrame.BorderSizePixel = 0
	mobileButtonsFrame.Active = true
	mobileButtonsFrame.Visible = mobileButtonsVisible
	mobileButtonsFrame.ZIndex = 25
	drag(mobileButtonsFrame)

	local mobileRefs = {}
	local function setMobileButton(id, on)
		local ref = mobileRefs[id]
		if not ref then
			return
		end
		TS:Create(
			ref.btn,
			TweenInfo.new(0.12),
			{
				BackgroundColor3 = on and Color3.fromRGB(45, 45, 52) or Color3.fromRGB(2, 2, 5),
				TextColor3 = on and RED or W,
			}
		):Play()
		TS:Create(ref.stroke, TweenInfo.new(0.12), { Color = on and RED or Color3.fromRGB(12, 12, 18) }):Play()
	end

	refreshMobileButtons = function()
		if mobileButtonsFrame then
			mobileButtonsFrame.Visible = mobileButtonsVisible
		end
		setMobileButton("AutoLeft", autoLeftEnabled)
		setMobileButton("AutoRight", autoRightEnabled)
		setMobileButton("Carry", speedMode and not laggerToggled)
		setMobileButton("AutoBat", autoBatEnabled)
		setMobileButton("Lagger", laggerToggled)
		setMobileButton("Bypass", bypassAimbotEnabled)
		setMobileButton("AutoPlay", autoPlayEnabled)
		if setMobileButtonsVisual then
			setMobileButtonsVisual(mobileButtonsVisible)
		end
		if setMobileLockVisual then
			setMobileLockVisual(mobileButtonsLocked)
		end
	end

	local function mkMobileButton(order, id, txt, cb)
		local btn = Instance.new("TextButton", mobileButtonsFrame)
		local col = (order - 1) % 2
		local row = math.floor((order - 1) / 2)
		btn.Size = UDim2.new(0, 68, 0, 58)
		btn.Position = UDim2.new(0, col * 78, 0, row * 68)
		btn.BackgroundColor3 = Color3.fromRGB(2, 2, 5)
		btn.BorderSizePixel = 0
		btn.Text = txt
		btn.TextColor3 = W
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = 11
		btn.TextWrapped = true
		btn.AutoButtonColor = false
		btn.ZIndex = 26
		btn.Active = true
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)
		local stroke = Instance.new("UIStroke", btn)
		stroke.Color = Color3.fromRGB(12, 12, 18)
		stroke.Thickness = 1.6
		stroke.Transparency = 0.15
		mobileRefs[id] = { btn = btn, stroke = stroke }
		drag(btn)
		btn.MouseEnter:Connect(function()
			if not mobileRefs[id].down then
				TS:Create(btn, TweenInfo.new(0.1), { BackgroundColor3 = Color3.fromRGB(10, 10, 16) }):Play()
			end
		end)
		btn.MouseLeave:Connect(function()
			refreshMobileButtons()
		end)
		btn.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			if mobileDragMoved then
				mobileDragMoved = false
				refreshMobileButtons()
				return
			end
			cb()
			refreshMobileButtons()
		end)
	end

	mkMobileButton(1, "TP", "TP\nDOWN", function()
		runTPFloor()
	end)
	mkMobileButton(2, "AutoLeft", "AUTO\nLEFT", toggleAutoLeftAction)
	mkMobileButton(3, "AutoRight", "AUTO\nRIGHT", toggleAutoRightAction)
	mkMobileButton(4, "Drop", "DROP\nBR", function()
		runDrop()
	end)
	mkMobileButton(5, "Carry", "CARRY\nSPD", function()
		toggleCarryMode()
		saveConfig()
	end)
	mkMobileButton(6, "AutoBat", "AUTO\nBAT", toggleAutoBatAction)
	mkMobileButton(7, "Reset", "INSTANT\nRESET", function()
		cursedInstaReset()
	end)
	mkMobileButton(8, "Lagger", "LAGGER\nMODE", function()
		toggleLaggerMode()
		saveConfig()
	end)
	mkMobileButton(9, "Bypass", "BAT\nTP", toggleBypassAimbotAction)

	refreshMobileButtons()

	local sf = Instance.new("ScrollingFrame", main)
	sf.Size = UDim2.new(1, 0, 1, -44)
	sf.Position = UDim2.new(0, 0, 0, 44)
	sf.BackgroundTransparency = 1
	sf.BorderSizePixel = 0
	sf.ClipsDescendants = true
	sf.ScrollBarThickness = 0
	sf.ScrollBarImageTransparency = 1
	sf.CanvasSize = UDim2.new(0, 0, 0, 0)
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	local ll = Instance.new("UIListLayout", sf)
	ll.SortOrder = Enum.SortOrder.LayoutOrder
	ll.Padding = UDim.new(0, 2)
	local pad = Instance.new("UIPadding", sf)
	pad.PaddingLeft = UDim.new(0, 7)
	pad.PaddingRight = UDim.new(0, 7)
	pad.PaddingTop = UDim.new(0, 7)
	pad.PaddingBottom = UDim.new(0, 10)

	local lo = 0
	local function LO()
		lo = lo + 1
		return lo
	end

	local function mkSect(txt)
		local f = Instance.new("Frame", sf)
		f.Size = UDim2.new(1, 0, 0, 20)
		f.BackgroundTransparency = 1
		f.BorderSizePixel = 0
		f.LayoutOrder = LO()
		local l = Instance.new("TextLabel", f)
		l.Size = UDim2.new(1, -8, 1, 0)
		l.Position = UDim2.new(0, 8, 0, 0)
		l.BackgroundTransparency = 1
		l.Text = txt:upper()
		l.TextColor3 = RED
		l.Font = Enum.Font.GothamBlack
		l.TextSize = 8
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.TextStrokeTransparency = 0.85
		l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	end

	local function mkRow(h)
		local f = Instance.new("Frame", sf)
		f.Size = UDim2.new(1, 0, 0, h or 28)
		f.BackgroundColor3 = CARD
		f.BorderSizePixel = 0
		f.LayoutOrder = LO()
		Instance.new("UICorner", f).CornerRadius = UDim.new(0, 7)
		Instance.new("UIStroke", f).Color = Color3.fromRGB(22, 22, 28)
		f.MouseEnter:Connect(function()
			TS:Create(f, TweenInfo.new(0.08), { BackgroundColor3 = HOV }):Play()
		end)
		f.MouseLeave:Connect(function()
			TS:Create(f, TweenInfo.new(0.08), { BackgroundColor3 = CARD }):Play()
		end)
		return f
	end

	local function mkLabel(row, txt)
		local l = Instance.new("TextLabel", row)
		l.Size = UDim2.new(0.58, 0, 1, 0)
		l.Position = UDim2.new(0, 9, 0, 0)
		l.BackgroundTransparency = 1
		l.Text = txt
		l.TextColor3 = W
		l.Font = Enum.Font.GothamBold
		l.TextSize = 11
		l.TextXAlignment = Enum.TextXAlignment.Left
	end

	local function mkPill(row, offset)
		local pill = Instance.new("Frame", row)
		pill.Size = UDim2.new(0, 32, 0, 17)
		pill.Position = UDim2.new(1, -(offset or 38), 0.5, -8.5)
		pill.BackgroundColor3 = OFF
		pill.BorderSizePixel = 0
		pill.ZIndex = 3
		Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
		local dot = Instance.new("Frame", pill)
		dot.Size = UDim2.new(0, 11, 0, 11)
		dot.Position = UDim2.new(0, 3, 0.5, -5.5)
		dot.BackgroundColor3 = DIM
		dot.BorderSizePixel = 0
		dot.ZIndex = 4
		Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
		return pill, dot
	end

	local function animPill(pill, dot, on)
		TS:Create(
			pill,
			TweenInfo.new(0.18, Enum.EasingStyle.Quad),
			{ BackgroundColor3 = on and Color3.fromRGB(55, 55, 62) or OFF }
		):Play()
		TS:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1, -14, 0.5, -5.5) or UDim2.new(0, 3, 0.5, -5.5),
			BackgroundColor3 = on and RED or DIM,
		}):Play()
	end

	local function mkToggle(txt, cb)
		local row = mkRow(32)
		mkLabel(row, txt)
		local pill, dot = mkPill(row, 42)
		local on = false
		local function sv(s)
			on = s
			animPill(pill, dot, s)
		end
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 5
		clk.Activated:Connect(function()
			on = not on
			sv(on)
			cb(on)
		end)
		pill.ZIndex = 3
		dot.ZIndex = 4
		return sv
	end

	local function mkBox(parent, default, w, xOff, cb)
		local tb = Instance.new("TextBox", parent)
		tb.Size = UDim2.new(0, w or 46, 0, 20)
		tb.Position = UDim2.new(1, -(xOff or 52), 0.5, -10)
		tb.BackgroundColor3 = INP
		tb.BorderSizePixel = 0
		tb.Text = tostring(default)
		tb.TextColor3 = W
		tb.Font = Enum.Font.GothamBold
		tb.TextSize = 11
		tb.ClearTextOnFocus = false
		tb.ZIndex = 5
		Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
		local bs = Instance.new("UIStroke", tb)
		bs.Color = Color3.fromRGB(30, 30, 38)
		bs.Thickness = 1
		tb.Focused:Connect(function()
			TS:Create(bs, TweenInfo.new(0.12), { Color = REDDIM }):Play()
		end)
		tb.FocusLost:Connect(function()
			TS:Create(bs, TweenInfo.new(0.12), { Color = Color3.fromRGB(30, 30, 38) }):Play()
			if cb then
				local n = tonumber(tb.Text)
				if n then
					cb(n)
				else
					tb.Text = tostring(default)
				end
			end
		end)
		return tb
	end

	local GAMEPAD_KEYS = {
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
		[Enum.KeyCode.DPadRight] = true,
	}

	local function isGamepadInput(inp)
		return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
	end

	local function isBindableInput(inp)
		if not inp or inp.KeyCode == Enum.KeyCode.Unknown then
			return false
		end
		if inp.UserInputType == Enum.UserInputType.Keyboard then
			return true
		end
		return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
	end

	local function kbMatch(entry, kc)
		return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
	end

	local function mkKB(parent, kbEntry, cb)
		local btn = Instance.new("TextButton", parent)
		btn.Size = UDim2.new(0, 42, 0, 20)
		btn.Position = UDim2.new(1, -46, 0.5, -10)
		btn.BackgroundColor3 = INP
		btn.BorderSizePixel = 0
		local function getLabel()
			return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
		end
		btn.Text = getLabel()
		btn.TextColor3 = W
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 9
		btn.ZIndex = 5
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
		local li = false
		local lc
		local pv = btn.Text
		local listenStart = 0
		btn.Activated:Connect(function()
			if li then
				li = false
				_anyKeyListening = false
				if lc then
					lc:Disconnect()
					lc = nil
				end
				btn.Text = pv
				btn.TextColor3 = W
				return
			end
			pv = btn.Text
			li = true
			_anyKeyListening = true
			listenStart = tick()
			btn.Text = "..."
			btn.TextColor3 = W
			lc = UIS.InputBegan:Connect(function(inp)
				if not li then
					return
				end
				if inp.KeyCode == Enum.KeyCode.Escape then
					li = false
					_anyKeyListening = false
					if lc then
						lc:Disconnect()
						lc = nil
					end
					btn.Text = pv
					btn.TextColor3 = W
					return
				end
				local isGp = isGamepadInput(inp)
				if isGp and tick() - listenStart < 0.15 then
					return
				end
				if not isBindableInput(inp) then
					return
				end
				btn.Text = inp.KeyCode.Name
				pv = inp.KeyCode.Name
				btn.TextColor3 = W
				li = false
				_anyKeyListening = false
				if lc then
					lc:Disconnect()
					lc = nil
				end
				if cb then
					cb(inp.KeyCode, isGp)
				end
			end)
		end)
		return btn
	end

	local function mkToggleKB(txt, kbEntry, onToggle, onKB)
		local row = mkRow(32)
		mkLabel(row, txt)
		if kbEntry then
			mkKB(row, kbEntry, function(k, isGp)
				if isGp then
					kbEntry.gp = k
					kbEntry.kb = nil
				else
					kbEntry.kb = k
					kbEntry.gp = nil
				end
				if onKB then
					onKB(k, isGp)
				end
			end)
		end
		local pill, dot = mkPill(row, kbEntry and 102 or 42)
		local on = false
		local function sv(s)
			on = s
			animPill(pill, dot, s)
		end
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 5
		clk.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			on = not on
			sv(on)
			if onToggle then
				onToggle(on)
			end
		end)
		pill.ZIndex = 3
		dot.ZIndex = 4
		return sv
	end

	-- Progress bar
	local pbFrame = Instance.new("Frame", gui)
	pbFrame.Size = UDim2.new(0, 240, 0, 42)
	pbFrame.Position = UDim2.new(0.5, -120, 1, -56)
	pbFrame.BackgroundColor3 = backgroundColor3
	pbFrame.BorderSizePixel = 0
	pbFrame.Active = true
	pbFrame.ClipsDescendants = false
	_G.dragonProgressFrame = pbFrame
	Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 9)
	drag(pbFrame)
	progressPct = Instance.new("TextLabel", pbFrame)
	progressPct.Size = UDim2.new(0, 44, 0, 16)
	progressPct.Position = UDim2.new(0, 9, 0, 7)
	progressPct.BackgroundTransparency = 1
	progressPct.Text = "0%"
	progressPct.TextColor3 = W
	progressPct.Font = Enum.Font.GothamBold
	progressPct.TextSize = 11
	progressPct.TextXAlignment = Enum.TextXAlignment.Left
	progressRadLbl = Instance.new("TextLabel", pbFrame)
	progressRadLbl.Size = UDim2.new(0, 104, 0, 16)
	progressRadLbl.Position = UDim2.new(1, -112, 0, 7)
	progressRadLbl.BackgroundTransparency = 1
	progressRadLbl.Text = string.format("Radius: %.2g", Steal.StealRadius)
	progressRadLbl.TextColor3 = W
	progressRadLbl.Font = Enum.Font.GothamBold
	progressRadLbl.TextSize = 11
	progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
	local pbg = Instance.new("Frame", pbFrame)
	pbg.Size = UDim2.new(1, -18, 0, 11)
	pbg.Position = UDim2.new(0, 9, 0, 30)
	pbg.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	pbg.BorderSizePixel = 0
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(1, 0)
	progressFill = Instance.new("Frame", pbg)
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = RED
	progressFill.BorderSizePixel = 0
	Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1, 0)

	-- Build sections
	mkSect("Speed")
	do
		local row = mkRow(32)
		mkLabel(row, "Normal Speed")
		mkBox(row, NS, 50, 48, function(v)
			if v > 0 and v <= 500 then
				NS = v
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Carry Speed")
		mkBox(row, CS, 50, 48, function(v)
			if v > 0 and v <= 500 then
				CS = v
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Lagger Normal")
		mkBox(row, LAGGER_SPEED, 50, 48, function(v)
			if v > 0 and v <= 500 then
				LAGGER_SPEED = v
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Lagger Carry")
		mkBox(row, LAGGER_CARRY_SPEED, 50, 48, function(v)
			if v > 0 and v <= 500 then
				LAGGER_CARRY_SPEED = v
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Mode")
		modeValLbl = Instance.new("TextLabel", row)
		modeValLbl.Size = UDim2.new(0, 90, 1, 0)
		modeValLbl.Position = UDim2.new(1, -94, 0, 0)
		modeValLbl.BackgroundTransparency = 1
		modeValLbl.Text = "Normal"
		modeValLbl.TextColor3 = RED
		modeValLbl.Font = Enum.Font.GothamBlack
		modeValLbl.TextSize = 11
		modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			toggleCarryMode()
			saveConfig()
		end)
	end

	mkSect("Keybinds")
	do
		local row = mkRow(32)
		mkLabel(row, "Speed Key")
		mkKB(row, KB.SpeedToggle, function(k, isGp)
			if isGp then
				KB.SpeedToggle.gp = k
				KB.SpeedToggle.kb = nil
			else
				KB.SpeedToggle.kb = k
				KB.SpeedToggle.gp = nil
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Lagger Key")
		mkKB(row, KB.LaggerToggle, function(k, isGp)
			if isGp then
				KB.LaggerToggle.gp = k
				KB.LaggerToggle.kb = nil
			else
				KB.LaggerToggle.kb = k
				KB.LaggerToggle.gp = nil
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "TP Bat Key")
		mkKB(row, KB.BypassAimbot, function(k, isGp)
			if isGp then
				KB.BypassAimbot.gp = k
				KB.BypassAimbot.kb = nil
			else
				KB.BypassAimbot.kb = k
				KB.BypassAimbot.gp = nil
			end
			saveConfig()
		end)
	end

	mkSect("Combat")
	do
		local abRow = mkRow(32)
		mkLabel(abRow, "Auto Bat")
		mkKB(abRow, KB.AutoBat, function(k, isGp)
			if isGp then
				KB.AutoBat.gp = k
				KB.AutoBat.kb = nil
			else
				KB.AutoBat.kb = k
				KB.AutoBat.gp = nil
			end
			saveConfig()
		end)
		local abPill, abDot = mkPill(abRow, 102)
		abPill.ZIndex = 3
		abDot.ZIndex = 4
		local abOn = false
		local function svAutoBat(s)
			abOn = s
			animPill(abPill, abDot, s)
		end
		autoBatSetVisual = svAutoBat
		local abClk = Instance.new("TextButton", abPill)
		abClk.Size = UDim2.new(1, 0, 1, 0)
		abClk.BackgroundTransparency = 1
		abClk.Text = ""
		abClk.ZIndex = 5
		abClk.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			abOn = not abOn
			svAutoBat(abOn)
			if abOn then
				queueAutoBatStart()
			else
				stopBatAimbot()
			end
			if refreshMobileButtons then
				refreshMobileButtons()
			end
			saveConfig()
		end)
	end

	-- Bat TP (Bypass Aimbot) toggle
	do
		local row = mkRow(32)
		mkLabel(row, "Bat TP")
		mkKB(row, KB.BypassAimbot, function(k, isGp)
			if isGp then
				KB.BypassAimbot.gp = k
				KB.BypassAimbot.kb = nil
			else
				KB.BypassAimbot.kb = k
				KB.BypassAimbot.gp = nil
			end
			saveConfig()
		end)
		local pill, dot = mkPill(row, 102)
		pill.ZIndex = 3
		dot.ZIndex = 4
		local on = false
		local function sv(s)
			on = s
			animPill(pill, dot, s)
		end
		setBypassVisual = sv
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 5
		clk.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			on = not on
			sv(on)
			if on then
				startBypassAimbot()
			else
				stopBypassAimbot()
			end
			if refreshMobileButtons then
				refreshMobileButtons()
			end
			saveConfig()
		end)
	end
	-- TP Mode selector
	do
		local row = mkRow(32)
		mkLabel(row, "TP Mode")
		local modes = { "Regular", "OP", "V3", "OP V4" }
		local idx = 1
		for i, m in ipairs(modes) do
			if m == (tpBatMode or "Regular") then
				idx = i
				break
			end
		end
		local modeBtn = Instance.new("TextButton", row)
		modeBtn.Size = UDim2.new(0, 64, 0, 20)
		modeBtn.Position = UDim2.new(1, -70, 0.5, -10)
		modeBtn.BackgroundColor3 = INP
		modeBtn.BorderSizePixel = 0
		modeBtn.Text = modes[idx]
		modeBtn.TextColor3 = W
		modeBtn.Font = Enum.Font.GothamBold
		modeBtn.TextSize = 9
		Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 5)
		modeBtn.Activated:Connect(function()
			idx = idx % #modes + 1
			tpBatMode = modes[idx]
			modeBtn.Text = tpBatMode
			saveConfig()
		end)
	end

	local setAutoSwingVisual = mkToggle("Auto Swing", function(on)
		autoSwingEnabled = on
		saveConfig()
	end)
	if setAutoSwingVisual then
		setAutoSwingVisual(autoSwingEnabled)
	end

	do
		setBatCounterVisual = mkToggle("Bat Counter", function(on)
			batCounterEnabled = on
			if on then
				startBatCounter()
			else
				stopBatCounter()
			end
			saveConfig()
		end)
	end

	mkSect("Steal")
	do
		local row = mkRow(32)
		mkLabel(row, "Radius")
		mkBox(row, Steal.StealRadius, 50, 56, function(v)
			if v >= 0.5 and v <= 300 then
				Steal.StealRadius = v
				if progressRadLbl then
					progressRadLbl.Text = string.format("Radius: %.2g", Steal.StealRadius)
				end
			end
			saveConfig()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Steal Mode")
		local modes = { "V1", "V2", "V3" }
		local idx = 1
		for i, m in ipairs(modes) do
			if m == stealMode then
				idx = i
				break
			end
		end
		local function updateMode(m)
			stealMode = m
			if Steal.AutoStealEnabled then
				stopAutoSteal()
				startAutoSteal()
			end
			saveConfig()
		end
		local modeBtn = Instance.new("TextButton", row)
		modeBtn.Size = UDim2.new(0, 54, 0, 20)
		modeBtn.Position = UDim2.new(1, -60, 0.5, -10)
		modeBtn.BackgroundColor3 = INP
		modeBtn.BorderSizePixel = 0
		modeBtn.Text = stealMode
		modeBtn.TextColor3 = W
		modeBtn.Font = Enum.Font.GothamBold
		modeBtn.TextSize = 9
		Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 5)
		modeBtn.Activated:Connect(function()
			idx = idx % #modes + 1
			modeBtn.Text = modes[idx]
			updateMode(modes[idx])
		end)
	end
	do
		local stealRow = mkRow(32)
		mkLabel(stealRow, "Auto Steal")
		local pill, dot = mkPill(stealRow, 42)
		local on = false
		local function sv(s)
			on = s
			animPill(pill, dot, s)
		end
		setInstaGrab = sv
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 5
		clk.Activated:Connect(function()
			on = not on
			sv(on)
			Steal.AutoStealEnabled = on
			if on then
				startAutoSteal()
			else
				stopAutoSteal()
			end
			saveConfig()
		end)
		pill.ZIndex = 3
		dot.ZIndex = 4
	end

	mkSect("Misc")
	do
		local row = mkRow(32)
		mkLabel(row, "Instant Reset")
		mkKB(row, KB.InstaReset, function(k, isGp)
			if isGp then
				KB.InstaReset.gp = k
				KB.InstaReset.kb = nil
			else
				KB.InstaReset.kb = k
				KB.InstaReset.gp = nil
			end
			saveConfig()
		end)
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(0.58, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			cursedInstaReset()
		end)
	end

	setInfJumpVisual = mkToggle("Infinite Jump", function(on)
		infJumpEnabled = on
		if on then
			applyInfJumpMode()
		else
			stopHoldInfJump()
		end
		saveConfig()
	end)
	do
		local row = mkRow(32)
		mkLabel(row, "Inf Jump Mode")
		local modeBtn = Instance.new("TextButton", row)
		modeBtn.Size = UDim2.new(0, 64, 0, 20)
		modeBtn.Position = UDim2.new(1, -70, 0.5, -10)
		modeBtn.BackgroundColor3 = INP
		modeBtn.BorderSizePixel = 0
		modeBtn.Text = tostring(infJumpMode or "manual")
		modeBtn.TextColor3 = W
		modeBtn.Font = Enum.Font.GothamBold
		modeBtn.TextSize = 9
		Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 5)
		modeBtn.Activated:Connect(function()
			if infJumpMode == "manual" then
				infJumpMode = "hold"
			else
				infJumpMode = "manual"
			end
			modeBtn.Text = infJumpMode
			applyInfJumpMode()
			saveConfig()
		end)
	end

	setAntiRagVisual = mkToggle("Anti Ragdoll", function(on)
		antiRagdollEnabled = on
		if on then
			startAntiRagdoll()
		else
			stopAntiRagdoll()
		end
		saveConfig()
	end)

	setMedusaVisual = mkToggle("Medusa Counter", function(on)
		medusaCounterEnabled = on
		if on then
			setupMedusa(LP.Character)
		else
			stopMedusaCounter()
		end
		saveConfig()
	end)

	setUnwalkVisual = mkToggle("Unwalk", function(on)
		unwalkEnabled = on
		if on then
			startUnwalk()
		else
			stopUnwalk()
		end
		saveConfig()
	end)

	setAntiKickVisual = mkToggle("Anti Kick", function(on)
		if on then
			enableAntiKick()
		else
			disableAntiKick()
		end
		saveConfig()
	end)

	mkSect("Visual")
	setAntiLagVisual = mkToggle("Anti Lag", function(on)
		if on then
			enableAntiLag()
		else
			disableAntiLag()
		end
		saveConfig()
	end)
	setStretchRezVisual = mkToggle("Stretch Rez", function(on)
		if on then
			enableStretchRez()
		else
			disableStretchRez()
		end
		saveConfig()
	end)
	mkToggle("Dark Mode", function(on)
		darkModeEnabled = on
		if darkModeEnabled then
			applyDarkModeForce()
		else
			forceApplySkyAndDark()
		end
		saveConfig()
	end)

	mkSect("Movement")
	do
		local sv = mkToggleKB("Auto Left", KB.AutoLeft, function(on)
			autoLeftEnabled = on
			if on then
				if autoRightEnabled then
					autoRightEnabled = false
					if autoRightSetVisual then
						autoRightSetVisual(false)
					end
					stopAutoRight()
				end
				if autoBatEnabled then
					stopBatAimbot()
					if autoBatSetVisual then
						autoBatSetVisual(false)
					end
				end
				startAutoLeft()
			else
				stopAutoLeft()
			end
			if refreshMobileButtons then
				refreshMobileButtons()
			end
			saveConfig()
		end, function(k, isGp)
			if isGp then
				KB.AutoLeft.gp = k
				KB.AutoLeft.kb = nil
			else
				KB.AutoLeft.kb = k
				KB.AutoLeft.gp = nil
			end
			saveConfig()
		end)
		autoLeftSetVisual = sv
	end
	do
		local sv = mkToggleKB("Auto Right", KB.AutoRight, function(on)
			autoRightEnabled = on
			if on then
				if autoLeftEnabled then
					autoLeftEnabled = false
					if autoLeftSetVisual then
						autoLeftSetVisual(false)
					end
					stopAutoLeft()
				end
				if autoBatEnabled then
					stopBatAimbot()
					if autoBatSetVisual then
						autoBatSetVisual(false)
					end
				end
				startAutoRight()
			else
				stopAutoRight()
			end
			if refreshMobileButtons then
				refreshMobileButtons()
			end
			saveConfig()
		end, function(k, isGp)
			if isGp then
				KB.AutoRight.gp = k
				KB.AutoRight.kb = nil
			else
				KB.AutoRight.kb = k
				KB.AutoRight.gp = nil
			end
			saveConfig()
		end)
		autoRightSetVisual = sv
	end
	do
		local row = mkRow(32)
		mkLabel(row, "Drop Brainrot")
		mkKB(row, KB.DropBrainrot, function(k, isGp)
			if isGp then
				KB.DropBrainrot.gp = k
				KB.DropBrainrot.kb = nil
			else
				KB.DropBrainrot.kb = k
				KB.DropBrainrot.gp = nil
			end
			saveConfig()
		end)
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(0.58, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			runDrop()
		end)
	end
	do
		local row = mkRow(32)
		mkLabel(row, "TP Down")
		mkKB(row, KB.TPFloor, function(k, isGp)
			if isGp then
				KB.TPFloor.gp = k
				KB.TPFloor.kb = nil
			else
				KB.TPFloor.kb = k
				KB.TPFloor.gp = nil
			end
			saveConfig()
		end)
		local clk = Instance.new("TextButton", row)
		clk.Size = UDim2.new(0.58, 0, 1, 0)
		clk.BackgroundTransparency = 1
		clk.Text = ""
		clk.ZIndex = 2
		clk.Activated:Connect(function()
			runTPFloor()
		end)
	end

	setAutoTPVisual = mkToggle("Auto TP", function(on)
		autoTPEnabled = on
		if on then
			startAutoTP()
		else
			stopAutoTP()
		end
		saveConfig()
	end)
	do
		local row = mkRow(32)
		mkLabel(row, "Auto TP Height")
		mkBox(row, autoTPHeight, 50, 56, function(v)
			if v >= 0 and v <= 500 then
				autoTPHeight = v
			else
				row.Text = tostring(autoTPHeight)
			end
			saveConfig()
		end)
	end

	mkSect("Interface")
	do
		local row = mkRow(32)
		mkLabel(row, "Hide UI")
		mkKB(row, KB.GuiHide, function(k, isGp)
			if isGp then
				KB.GuiHide.gp = k
				KB.GuiHide.kb = nil
			else
				KB.GuiHide.kb = k
				KB.GuiHide.gp = nil
			end
			saveConfig()
		end)
	end
	setMobileButtonsVisual = mkToggle("Mobile Buttons", function(on)
		mobileButtonsVisible = on
		if mobileButtonsFrame then
			mobileButtonsFrame.Visible = on
		end
		if refreshMobileButtons then
			refreshMobileButtons()
		end
		saveConfig()
	end)
	setMobileLockVisual = mkToggle("Lock Mobile Buttons", function(on)
		mobileButtonsLocked = on
		if refreshMobileButtons then
			refreshMobileButtons()
		end
		saveConfig()
	end)
	if setMobileButtonsVisual then
		setMobileButtonsVisual(mobileButtonsVisible)
	end
	if setMobileLockVisual then
		setMobileLockVisual(mobileButtonsLocked)
	end

	-- Presets + Save Config (bottom of page)
	mkSect("Presets")
	local presetNameBox
	local presetListHost
	local function refreshPresetList()
		if not presetListHost then
			return
		end
		for _, child in ipairs(presetListHost:GetChildren()) do
			if not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end
		local data = readCursedFile()
		local presets = data.presets or {}
		local names = {}
		for name in pairs(presets) do
			table.insert(names, name)
		end
		table.sort(names)
		if #names == 0 then
			local empty = Instance.new("TextLabel", presetListHost)
			empty.Size = UDim2.new(1, -8, 0, 24)
			empty.BackgroundTransparency = 1
			empty.Text = "No presets saved yet"
			empty.TextColor3 = Color3.fromRGB(120, 120, 130)
			empty.Font = Enum.Font.Gotham
			empty.TextSize = 11
			empty.TextXAlignment = Enum.TextXAlignment.Left
			return
		end
		local active = data.active
		for _, name in ipairs(names) do
			local row = Instance.new("Frame", presetListHost)
			row.Size = UDim2.new(1, -4, 0, 30)
			row.BackgroundColor3 = CARD
			row.BorderSizePixel = 0
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

			local nameLbl = Instance.new("TextLabel", row)
			nameLbl.Size = UDim2.new(1, -78, 1, 0)
			nameLbl.Position = UDim2.new(0, 8, 0, 0)
			nameLbl.BackgroundTransparency = 1
			nameLbl.Text = name .. (name == active and "  (active)" or "")
			nameLbl.TextColor3 = (name == active) and RED or W
			nameLbl.Font = Enum.Font.GothamBold
			nameLbl.TextSize = 11
			nameLbl.TextXAlignment = Enum.TextXAlignment.Left
			nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

			local loadBtn = Instance.new("TextButton", row)
			loadBtn.Size = UDim2.new(0, 62, 0, 22)
			loadBtn.Position = UDim2.new(1, -68, 0.5, -11)
			loadBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
			loadBtn.BorderSizePixel = 0
			loadBtn.Text = "LOAD"
			loadBtn.TextColor3 = W
			loadBtn.Font = Enum.Font.GothamBlack
			loadBtn.TextSize = 10
			loadBtn.AutoButtonColor = false
			loadBtn.ZIndex = 5
			Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 5)
			loadBtn.Activated:Connect(function()
				if _anyKeyListening then
					return
				end
				local ok = select(1, loadPreset(name))
				if presetNameBox then
					presetNameBox.Text = name
				end
				local old = loadBtn.Text
				loadBtn.Text = ok and "OK!" or "FAIL"
				loadBtn.BackgroundColor3 = ok and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(40, 40, 45)
				task.delay(0.9, function()
					if loadBtn and loadBtn.Parent then
						loadBtn.Text = "LOAD"
						loadBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
					end
				end)
				refreshPresetList()
			end)
		end
	end

	do
		local row = mkRow(32)
		mkLabel(row, "Preset Name")
		presetNameBox = Instance.new("TextBox", row)
		presetNameBox.Size = UDim2.new(0, 110, 0, 22)
		presetNameBox.Position = UDim2.new(1, -116, 0.5, -11)
		presetNameBox.BackgroundColor3 = INP
		presetNameBox.BorderSizePixel = 0
		presetNameBox.Text = "default"
		presetNameBox.PlaceholderText = "name..."
		presetNameBox.TextColor3 = W
		presetNameBox.Font = Enum.Font.GothamBold
		presetNameBox.TextSize = 11
		presetNameBox.ClearTextOnFocus = false
		presetNameBox.ZIndex = 5
		Instance.new("UICorner", presetNameBox).CornerRadius = UDim.new(0, 5)
		pcall(function()
			local data = readCursedFile()
			if data.active and data.active ~= "" then
				presetNameBox.Text = data.active
			end
		end)
	end
	do
		local row = mkRow(36)
		local savePresetBtn = Instance.new("TextButton", row)
		savePresetBtn.Size = UDim2.new(0.48, -8, 0, 24)
		savePresetBtn.Position = UDim2.new(0, 6, 0.5, -12)
		savePresetBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
		savePresetBtn.BorderSizePixel = 0
		savePresetBtn.Text = "SAVE PRESET"
		savePresetBtn.TextColor3 = W
		savePresetBtn.Font = Enum.Font.GothamBlack
		savePresetBtn.TextSize = 11
		savePresetBtn.AutoButtonColor = false
		savePresetBtn.ZIndex = 5
		Instance.new("UICorner", savePresetBtn).CornerRadius = UDim.new(0, 6)

		local loadPresetBtn = Instance.new("TextButton", row)
		loadPresetBtn.Size = UDim2.new(0.48, -8, 0, 24)
		loadPresetBtn.Position = UDim2.new(0.52, 2, 0.5, -12)
		loadPresetBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
		loadPresetBtn.BorderSizePixel = 0
		loadPresetBtn.Text = "LOAD PRESET"
		loadPresetBtn.TextColor3 = W
		loadPresetBtn.Font = Enum.Font.GothamBlack
		loadPresetBtn.TextSize = 11
		loadPresetBtn.AutoButtonColor = false
		loadPresetBtn.ZIndex = 5
		Instance.new("UICorner", loadPresetBtn).CornerRadius = UDim.new(0, 6)

		local function flashBtn(btn, okText, badText, ok)
			local old = btn.Text
			local oldCol = btn.BackgroundColor3
			btn.Text = ok and okText or badText
			btn.BackgroundColor3 = ok and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(40, 40, 45)
			task.delay(1.1, function()
				if btn and btn.Parent then
					btn.Text = old
					btn.BackgroundColor3 = oldCol
				end
			end)
		end

		savePresetBtn.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			local name = presetNameBox and presetNameBox.Text or "default"
			local ok = savePreset(name)
			flashBtn(savePresetBtn, "SAVED!", "FAILED", ok)
			refreshPresetList()
		end)
		loadPresetBtn.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			local name = presetNameBox and presetNameBox.Text or "default"
			local ok = select(1, loadPreset(name))
			flashBtn(loadPresetBtn, "LOADED!", "NOT FOUND", ok)
			refreshPresetList()
		end)
	end

	-- Saved presets list
	do
		local header = mkRow(22)
		local h = Instance.new("TextLabel", header)
		h.Size = UDim2.new(1, -10, 1, 0)
		h.Position = UDim2.new(0, 8, 0, 0)
		h.BackgroundTransparency = 1
		h.Text = "Saved Presets"
		h.TextColor3 = RED
		h.Font = Enum.Font.GothamBold
		h.TextSize = 11
		h.TextXAlignment = Enum.TextXAlignment.Left

		local listRow = mkRow(120)
		listRow.BackgroundTransparency = 1
		presetListHost = Instance.new("Frame", listRow)
		presetListHost.Size = UDim2.new(1, -8, 1, -4)
		presetListHost.Position = UDim2.new(0, 4, 0, 2)
		presetListHost.BackgroundTransparency = 1
		presetListHost.BorderSizePixel = 0
		local listLayout = Instance.new("UIListLayout", presetListHost)
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Padding = UDim.new(0, 4)
		listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			local hgt = math.max(120, listLayout.AbsoluteContentSize.Y + 8)
			listRow.Size = UDim2.new(1, -10, 0, hgt)
		end)
		refreshPresetList()
	end

	do
		local row = mkRow(40)
		local saveBtn = Instance.new("TextButton", row)
		saveBtn.Size = UDim2.new(1, -12, 0, 28)
		saveBtn.Position = UDim2.new(0, 6, 0.5, -14)
		saveBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
		saveBtn.BorderSizePixel = 0
		saveBtn.Text = "SAVE CONFIG"
		saveBtn.TextColor3 = W
		saveBtn.Font = Enum.Font.GothamBlack
		saveBtn.TextSize = 12
		saveBtn.AutoButtonColor = false
		saveBtn.ZIndex = 5
		Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 7)
		local saveStroke = Instance.new("UIStroke", saveBtn)
		saveStroke.Color = Color3.fromRGB(160, 160, 170)
		saveStroke.Thickness = 1
		saveStroke.Transparency = 0.35
		saveBtn.Activated:Connect(function()
			if _anyKeyListening then
				return
			end
			local ok = saveConfig()
			saveBtn.Text = ok and "SAVED!" or "FAILED"
			saveBtn.BackgroundColor3 = ok and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(40, 40, 45)
			task.delay(1.2, function()
				if saveBtn and saveBtn.Parent then
					saveBtn.Text = "SAVE CONFIG"
					saveBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
				end
			end)
			refreshPresetList()
		end)
		saveBtn.MouseEnter:Connect(function()
			TS:Create(saveBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(85, 85, 95) }):Play()
		end)
		saveBtn.MouseLeave:Connect(function()
			TS:Create(saveBtn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(55, 55, 62) }):Play()
		end)
	end

	-- Keybind input handler
	UIS.InputBegan:Connect(function(input, gpe)
		if _anyKeyListening then
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if gpe or UIS:GetFocusedTextBox() then
				return
			end
		elseif not isGamepadInput(input) then
			return
		end
		if not isBindableInput(input) then
			return
		end
		local kc = input.KeyCode
		if kbMatch(KB.LaggerToggle, kc) then
			toggleLaggerMode()
			saveConfig()
		elseif kbMatch(KB.SpeedToggle, kc) then
			toggleCarryMode()
			saveConfig()
		elseif kbMatch(KB.DropBrainrot, kc) then
			runDrop()
		elseif kbMatch(KB.TPFloor, kc) then
			runTPFloor()
		elseif kbMatch(KB.InstaReset, kc) then
			cursedInstaReset()
		elseif kbMatch(KB.AutoLeft, kc) then
			toggleAutoLeftAction()
		elseif kbMatch(KB.AutoRight, kc) then
			toggleAutoRightAction()
		elseif kbMatch(KB.AutoBat, kc) then
			toggleAutoBatAction()
		elseif kbMatch(KB.GuiHide, kc) then
			if main.Visible then
				hideGui()
			else
				showGui()
			end
		elseif kbMatch(KB.BypassAimbot, kc) then
			toggleBypassAimbotAction()
		end
	end)
end

-- ============================================================================
-- INIT
-- ============================================================================
loadConfig()

-- Apply saved states
task.spawn(function()
	if antiRagdollEnabled then
		startAntiRagdoll()
	end
	if Steal.AutoStealEnabled then
		startAutoSteal()
	end
	if infJumpEnabled then
		applyInfJumpMode()
	end
	if medusaCounterEnabled then
		setupMedusa(LP.Character)
	end
	if batCounterEnabled then
		startBatCounter()
	end
	if unwalkEnabled then
		startUnwalk()
	end
	if autoTPEnabled then
		startAutoTP()
	end
	if autoBatEnabled then
		queueAutoBatStart()
	end
	if autoLeftEnabled then
		startAutoLeft()
	end
	if autoRightEnabled then
		startAutoRight()
	end
	if bypassAimbotEnabled then
		startBypassAimbot()
	end
	if antiBypassBatEnabled then
		startAntiBypassBat()
	end
	if antiKickEnabled then
		enableAntiKick()
	end
	if antiLagEnabled then
		enableAntiLag()
	end
	if stretchRezEnabled then
		enableStretchRez()
	end
	if darkModeEnabled then
		applyDarkModeForce()
	end
	forceApplySkyAndDark()
	if playerESPEnabled then
		toggleESP(true)
	end
	if showPlayerSpeeds then
		togglePlayerSpeeds(true)
	end
	if removeAccEnabled then
		startRemoveAcc()
	end
	if headlessEnabled or korbloxEnabled then
		applyCharterToChar(LP.Character)
	end
	if animPackEnabled and animPack then
		applyAnimPack(animPack)
	end
end)

-- Character added hooks
LP.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	setupSpeedIndicator(char)
	if medusaCounterEnabled then
		setupMedusa(char)
	end
	if batCounterEnabled then
		startBatCounter()
	end
	if unwalkEnabled then
		task.wait(0.5)
		startUnwalk()
	end
	if headlessEnabled or korbloxEnabled then
		applyCharterToChar(char)
	end
	if animPackEnabled and animPack then
		applyAnimPack(animPack)
	end
end)

if LP.Character then
	setupSpeedIndicator(LP.Character)
	applyCharterToChar(LP.Character)
end

buildGui()