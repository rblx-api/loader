-- ⏱ KEY CON EXPIRACIÓN
local keyExpiry = 1793240631564
local now = os.time() * 1000
if now > keyExpiry then
  pcall(function()
    game:GetService("Players").LocalPlayer:Kick("KEY EXPIRADA")
  end)
  return
end

-- 🔐 USUARIOS AUTORIZADOS
local authorizedUsers = {"all"}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
if not localPlayer then return end
local isAuthorized = false
for _, u in ipairs(authorizedUsers) do if u == localPlayer.Name then isAuthorized = true break end end
if not isAuthorized then pcall(function() localPlayer:Kick("RESET HWID - No autorizado") end) return end

-- MGD HUB | Fixed & Working Edition (Extreme Anti-Ragdoll, Kill Aura, Hit Egg Holder, FPS/MS & Anti-Lag)
-- Pick a pet (icon + value), press Steal: taken and delivered with the Instant TP logic only.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local localPlayer = Players.LocalPlayer

-- BURAYA RESMİNİN ASSET ID'SİNİ YAZABİLİRSİN (İSTEĞE BAĞLI):
local AVATAR_IMAGE_ID = "rbxassetid://0"

local function parentGui()
	if typeof(gethui) == "function" then
		local ok, result = pcall(gethui)
		if ok and typeof(result) == "Instance" then
			return result
		end
	end
	return CoreGui
end

-- ===== MGD HUB Splash Screen (5 Saniye) =====
local function showSplashScreen()
	local pGui = parentGui()
	local splashGui = Instance.new("ScreenGui")
	splashGui.Name = "MGD_SplashScreen"
	splashGui.ResetOnSpawn = false
	splashGui.DisplayOrder = 9999
	splashGui.IgnoreGuiInset = true
	splashGui.Parent = pGui

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.Position = UDim2.new(0, 0, 0, 0)
	bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bg.BorderSizePixel = 0
	bg.Parent = splashGui

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 1, 0)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "MGD TP"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 32
	title.Parent = bg

	task.wait(5)

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenBg = TweenService:Create(bg, tweenInfo, { BackgroundTransparency = 1 })
	local tweenText = TweenService:Create(title, tweenInfo, { TextTransparency = 1 })

	tweenBg:Play()
	tweenText:Play()
	tweenBg.Completed:Wait()

	splashGui:Destroy()
end

showSplashScreen()

------------------------------------------------------------------ settings
local CFG = {
	SpeedCap = 1.15,
	HopRatio = 1.515,
	HopMin = 40,
	HopGap = 0.06,
	HopGapMin = 0.06,
	HopGapMax = 0.2,
	HopRetries = 6,
	HopLift = 42,
	LandOffset = 14,
	LandSettle = 0.08,
	DropDelay = 0.05,
	GrabInterval = 0.03,
	RegrabFar = 40,
	Height = 70,
	ClimbShare = 0.5,
	CarryRatio = 0.9,
	EasyRatio = 1.3,
}
local FPS_CAPS = { 60, 30, 0.15 }

------------------------------------------------------------------ ANTI-LAG / FPS BOOST SYSTEM
local antiLagEnabled = false

local function enableAntiLag()
	antiLagEnabled = true
	
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.Brightness = 1
		for _, effect in ipairs(Lighting:GetChildren()) do
			if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") then
				effect.Enabled = false
			end
		end
	end)

	for _, object in ipairs(workspace:GetDescendants()) do
		pcall(function()
			if object:IsA("BasePart") then
				object.Material = Enum.Material.SmoothPlastic
				object.Reflectance = 0
			elseif object:IsA("Decal") or object:IsA("Texture") then
				object.Transparency = 1
			elseif object:IsA("ParticleEmitter") or object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles") then
				object.Enabled = false
			end
		end)
	end
end

------------------------------------------------------------------ game handles
local function safeRequire(getter)
	local ok, result = pcall(function()
		return require(getter())
	end)
	return ok and result or nil
end

local networkingFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Networking")
local EggState = safeRequire(function() return ReplicatedStorage.Client.EggState end)
local Assets = safeRequire(function() return ReplicatedStorage.Data.Assets end)
local Mutations = safeRequire(function() return ReplicatedStorage.Shared.Modules.Mutations end)

local function remote(name)
	return networkingFolder:FindFirstChild(name)
end

local function root()
	local character = localPlayer.Character
	return character and character:FindFirstChild("HumanoidRootPart")
end

------------------------------------------------------------------ EXTREME ANTI RAGDOLL SYSTEM
local antiRagdollEnabled = false
local antiRagdollConnection = nil

local function enforceAntiRagdoll()
	local character = localPlayer.Character
	if not character then return end
	
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or humanoid.Health <= 0 then return end

	humanoid.PlatformStand = false
	humanoid.Sit = false
	humanoid.AutoRotate = true

	local currentState = humanoid:GetState()
	if currentState == Enum.HumanoidStateType.Ragdoll 
		or currentState == Enum.HumanoidStateType.FallingDown 
		or currentState == Enum.HumanoidStateType.Physics 
		or currentState == Enum.HumanoidStateType.Stun 
		or currentState == Enum.HumanoidStateType.Freefall then
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	for _, inst in ipairs(character:GetDescendants()) do
		if inst:IsA("BallSocketConstraint") 
			or inst:IsA("HingeConstraint") 
			or inst:IsA("NoCollisionConstraint") 
			or inst:IsA("WeldConstraint") 
			or inst:IsA("BodyVelocity") 
			or inst:IsA("BodyForce") 
			or inst:IsA("LinearVelocity") then
			
			if inst.Name:lower():find("ragdoll") or inst.Name:lower():find("knock") or inst.Name:lower():find("stun") or inst.Name:lower():find("hit") or inst.Name:lower():find("protector") then
				pcall(function() inst:Destroy() end)
			end
		end
	end

	if hrp and (currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown) then
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.AssemblyAngularVelocity = Vector3.zero
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")
	if animator then
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			local name = string.lower(track.Name or "")
			if string.find(name, "ragdoll") or string.find(name, "fall") or string.find(name, "knock") or string.find(name, "stun") or string.find(name, "trip") or string.find(name, "hit") then
				track:Stop(0)
			end
		end
	end
end

local function setAntiRagdoll(state)
	antiRagdollEnabled = state
	if antiRagdollConnection then
		antiRagdollConnection:Disconnect()
		antiRagdollConnection = nil
	end

	if antiRagdollEnabled then
		antiRagdollConnection = RunService.Stepped:Connect(function()
			enforceAntiRagdoll()
		end)
	else
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
	end
end

------------------------------------------------------------------ KILL AURA & RED CIRCLE SYSTEM
local killAuraEnabled = false
local killAuraRange = 25
local rangeCircle = nil
local killAuraLoop = nil

local function updateRangeCircle()
	local char = localPlayer.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	
	if not killAuraEnabled or not rootPart then
		if rangeCircle then
			rangeCircle:Destroy()
			rangeCircle = nil
		end
		return
	end

	if not rangeCircle or not rangeCircle.Parent then
		local cylinder = Instance.new("Part")
		cylinder.Name = "MGD_AuraVisual"
		cylinder.Shape = Enum.PartType.Cylinder
		cylinder.Color = Color3.fromRGB(255, 0, 0)
		cylinder.Material = Enum.Material.Neon
		cylinder.Transparency = 0.7
		cylinder.Anchored = false
		cylinder.CanCollide = false
		cylinder.Massless = true
		
		local weld = Instance.new("Weld")
		weld.Part0 = rootPart
		weld.Part1 = cylinder
		weld.C0 = CFrame.new(0, -2.8, 0) * CFrame.Angles(0, 0, math.rad(90))
		weld.Parent = cylinder
		cylinder.Parent = char
		
		rangeCircle = cylinder
	end

	if rangeCircle:IsA("BasePart") then
		local diameter = killAuraRange * 2
		rangeCircle.Size = Vector3.new(0.1, diameter, diameter)
	end
end

local function equipBat()
	local myChar = localPlayer.Character
	local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
	if not myChar or not myHum then return nil end

	local tool = myChar:FindFirstChildWhichIsA("Tool")
	if tool and string.lower(tool.Name) == "bat" then
		return tool
	end

	local backpack = localPlayer:FindFirstChild("Backpack")
	if backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") and string.lower(item.Name) == "bat" then
				myHum:EquipTool(item)
				return item
			end
		end
	end

	if not tool and backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") then
				myHum:EquipTool(item)
				return item
			end
		end
	end
	return tool
end

local function processKillAura()
	if not killAuraEnabled then return end
	local myChar = localPlayer.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
	if not myRoot or not myHum or myHum.Health <= 0 then return end

	local tool = equipBat()
	local closestTarget = nil
	local closestDist = killAuraRange

	for _, target in ipairs(Players:GetPlayers()) do
		if target ~= localPlayer and target.Character then
			local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
			local tHum = target.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and tHum and tHum.Health > 0 then
				local dist = (tRoot.Position - myRoot.Position).Magnitude
				if dist <= closestDist then
					closestDist = dist
					closestTarget = tRoot
				end
			end
		end
	end

	if closestTarget then
		pcall(function()
			myRoot.CFrame = closestTarget.CFrame * CFrame.new(0, 0, 2)
			if tool then
				tool:Activate()
			end
		end)
	end
end

local function setKillAura(state)
	killAuraEnabled = state
	if killAuraLoop then
		killAuraLoop:Disconnect()
		killAuraLoop = nil
	end

	if killAuraEnabled then
		killAuraLoop = RunService.Heartbeat:Connect(function()
			updateRangeCircle()
			processKillAura()
		end)
	else
		updateRangeCircle()
	end
end

------------------------------------------------------------------ HIT EGG HOLDER SYSTEM
local function teleportAndHitEggHolder()
	local myRoot = root()
	if not myRoot then return false end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local pChar = player.Character
			local pRoot = pChar:FindFirstChild("HumanoidRootPart")
			local pHum = pChar:FindFirstChildOfClass("Humanoid")

			if pRoot and pHum and pHum.Health > 0 then
				local isHoldingEgg = false

				for _, descendant in ipairs(pChar:GetDescendants()) do
					if descendant:IsA("WeldConstraint") or descendant:IsA("Weld") or descendant:IsA("Motor6D") then
						local p0, p1 = descendant.Part0, descendant.Part1
						if (p0 and p0.Parent and (p0.Parent.Name:lower():find("egg") or p0.Name:lower():find("egg"))) or
						   (p1 and p1.Parent and (p1.Parent.Name:lower():find("egg") or p1.Name:lower():find("egg"))) then
							isHoldingEgg = true
							break
						end
					end
				end

				if isHoldingEgg then
					pcall(function()
						myRoot.CFrame = pRoot.CFrame * CFrame.new(0, 0, -10) * CFrame.Angles(0, math.rad(180), 0)
						local bat = equipBat()
						if bat then
							task.wait(0.05)
							bat:Activate()
						end
					end)
					return true
				end
			end
		end
	end
	return false
end

-- "Humanoid Swap" Shield
local shield = { Original = nil, Clone = nil, Links = {}, Connection = nil, Added = nil }

local function walkSpeed()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local speed = humanoid and humanoid.WalkSpeed or 16
	if shield.Original and shield.Original.Health > 0 then
		speed = math.min(speed, shield.Original.WalkSpeed)
	end
	local ok, result = pcall(function()
		local stat = localPlayer:FindFirstChild("leaderstats")
		stat = stat and stat:FindFirstChild("Speed")
		local util = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
		return stat and util.SpeedPowerToWalkSpeed(stat.Value) or nil
	end)
	if ok and type(result) == "number" and result > 0 then
		speed = math.min(speed, result)
	end
	return speed
end

local function shieldControls(humanoid)
	pcall(function()
		local scripts = localPlayer:FindFirstChild("PlayerScripts")
		local module = scripts and scripts:FindFirstChild("PlayerModule")
		if module then
			local controls = require(module):GetControls()
			if type(controls) == "table" then
				controls.humanoid = humanoid
			end
		end
	end)
end

local function shieldAnimate(character)
	local animate = character and character:FindFirstChild("Animate")
	if animate and animate:IsA("LocalScript") then
		task.spawn(function()
			animate.Enabled = false
			task.wait()
			animate.Enabled = true
		end)
	end
end

local function shieldUnlink()
	for _, link in ipairs(shield.Links) do
		pcall(function()
			link:Disconnect()
		end)
	end
	table.clear(shield.Links)
end

local groundedStates = {
	[Enum.HumanoidStateType.Running] = true,
	[Enum.HumanoidStateType.RunningNoPhysics] = true,
	[Enum.HumanoidStateType.Landed] = true,
}

local function grounded(humanoid)
	if not humanoid or humanoid.Health <= 0 or humanoid.FloorMaterial == Enum.Material.Air then
		return false
	end
	return groundedStates[humanoid:GetState()] == true
end

local function shieldSwap()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return
	end
	if shield.Clone and shield.Clone.Parent == character then
		return
	end
	if not grounded(humanoid) then
		return
	end

	local clone = humanoid:Clone()
	humanoid.Parent = nil
	clone.Parent = character
	workspace.CurrentCamera.CameraSubject = clone
	shieldControls(clone)
	shieldAnimate(character)
	shield.Original = humanoid
	shield.Clone = clone

	table.insert(shield.Links, humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if clone.Parent ~= nil then
			clone.WalkSpeed = humanoid.WalkSpeed
		end
	end))

	local animator = humanoid:FindFirstChildOfClass("Animator")
	local animator2 = clone:FindFirstChildOfClass("Animator")
	if animator and animator2 then
		table.insert(shield.Links, animator.AnimationPlayed:Connect(function(played)
			local animation = played.Animation
			if not animation or clone.Parent == nil then
				return
			end
			local ok, track = pcall(function()
				return animator2:LoadAnimation(animation)
			end)
			if not ok or not track then
				return
			end
			pcall(function()
				track.Priority = played.Priority
				track.Looped = played.Looped
				track:Play(0.05, math.max(played.WeightTarget, 0.01), played.Speed)
			end)
			local stopped
			stopped = played.Stopped:Connect(function()
				stopped:Disconnect()
				pcall(function()
					track:Stop(0.1)
				end)
			end)
		end))
	end

	table.insert(shield.Links, clone.Died:Connect(function()
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		local current = localPlayer.Character
		if current and humanoid.Parent == nil then
			humanoid.Parent = current
			workspace.CurrentCamera.CameraSubject = humanoid
			shieldControls(humanoid)
		end
		pcall(function()
			clone:Destroy()
		end)
		humanoid.Health = 0
	end))
end

local function shieldUndo()
	shieldUnlink()
	local character = localPlayer.Character
	local original, clone = shield.Original, shield.Clone
	shield.Original, shield.Clone = nil, nil
	if original and clone and character and original.Parent == nil and clone.Parent == character then
		original.Parent = character
		workspace.CurrentCamera.CameraSubject = original
		shieldControls(original)
		pcall(function()
			clone:Destroy()
		end)
		shieldAnimate(character)
	end
end

local function shieldStart()
	shieldSwap()
	local n = 0
	shield.Connection = RunService.Heartbeat:Connect(function(dt)
		n += dt
		local character = localPlayer.Character
		local missing = not (shield.Clone and character and shield.Clone.Parent == character)
		if (missing and 0.25 or 3) <= n then
			n = 0
			shieldSwap()
		end
	end)
	shield.Added = localPlayer.CharacterAdded:Connect(function(character)
		shieldUnlink()
		shield.Original, shield.Clone = nil, nil
		task.spawn(function()
			character:WaitForChild("Humanoid", 10)
			task.wait(1)
			if shield.Connection and localPlayer.Character == character then
				shieldSwap()
			end
		end)
	end)
end

local function shieldStop()
	if shield.Connection then
		shield.Connection:Disconnect()
		shield.Connection = nil
	end
	if shield.Added then
		shield.Added:Disconnect()
		shield.Added = nil
	end
	shieldUndo()
end

------------------------------------------------------------------ carry / delivery state
local state = { Carrying = false, Uid = nil, Delivered = 0, Busy = false, Cancel = false, Mult = 1, PulledAt = 0, HeldSeen = 0, GuessedDrop = false }

if type(EggState) == "table" and type(EggState.CarryChanged) == "table" and type(EggState.CarryChanged.Connect) == "function" then
	EggState.CarryChanged:Connect(function(arg)
		local carrying = type(arg) == "table" and arg.IsCarrying == true
		if carrying and arg.GuardDisabled == true then
			carrying = false
		end
		state.GuessedDrop = false
		if carrying then
			state.HeldSeen = os.clock()
		end
		if carrying and type(arg.Uid) == "string" then
			state.Uid = arg.Uid
			local mult = tonumber(arg.SpeedMultiplier)
			if mult and mult > 0 then
				state.Mult = mult
			end
		end
		state.Carrying = carrying
	end)
end

pcall(function()
	remote("RE/EggWorld/FieldEggRedeemVerdict").OnClientEvent:Connect(function()
		state.Delivered = os.clock()
	end)
end)

pcall(function()
	remote("RE/RigSync/Refresh").OnClientEvent:Connect(function(arg)
		if type(arg) == "table" and arg.Action == "Relocate" then
			state.PulledAt = os.clock()
		end
	end)
end)

local function takeEgg(uid)
	if type(uid) == "string" and type(EggState) == "table" and type(EggState.CarryFieldEgg) == "function" then
		pcall(EggState.CarryFieldEgg, uid)
	end
end

local function dropEgg()
	if type(EggState) == "table" and type(EggState.DropFieldEgg) == "function" then
		pcall(EggState.DropFieldEgg, "PlayerRequest")
	end
end

local function promptNear(position, radius)
	local best, bestDistance = nil, radius
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
			local prompt = child:FindFirstChild("CarryAreaEgg")
			if prompt and prompt:IsA("ProximityPrompt") then
				local distance = (child.Position - position).Magnitude
				if distance < bestDistance then
					best, bestDistance = prompt, distance
				end
			end
		end
	end
	return best
end

local function heldByMe(uid)
	local character = localPlayer.Character
	if type(uid) ~= "string" or not character then
		return false
	end
	local egg = workspace:FindFirstChild(uid)
	if not egg then
		return false
	end
	for _, d in ipairs(egg:GetDescendants()) do
		if d:IsA("WeldConstraint") or d:IsA("JointInstance") then
			local ok, a, b = pcall(function()
				return d.Part0, d.Part1
			end)
			if ok and ((a and a:IsDescendantOf(character)) or (b and b:IsDescendantOf(character))) then
				return true
			end
		end
	end
	return false
end

task.spawn(function()
	while true do
		task.wait(0.2)
		if not state.Carrying then
			if state.GuessedDrop and heldByMe(state.Uid) then
				state.GuessedDrop, state.Carrying, state.HeldSeen = false, true, os.clock()
			end
		elseif heldByMe(state.Uid) then
			state.HeldSeen = os.clock()
		elseif os.clock() - state.HeldSeen > 0.8 then
			state.Carrying, state.GuessedDrop = false, true
		end
	end
end)

local function snapshot()
	local list = {}
	local ok, result = pcall(function()
		return remote("RF/EggWorld/AskFieldEggSnapshot"):InvokeServer()
	end)
	local records = ok and type(result) == "table" and result.Records or nil
	if type(records) ~= "table" then
		return list
	end
	for _, record in pairs(records) do
		if type(record) == "table" and type(record.Uid) == "string" and (record.State == "Slot" or record.State == "Dropped") and typeof(record.BottomCFrame) == "CFrame" then
			list[#list + 1] = record
		end
	end
	return list
end

local function eggPosition(uid)
	for _, record in ipairs(snapshot()) do
		if record.Uid == uid then
			return record.BottomCFrame.Position
		end
	end
	return nil
end

------------------------------------------------------------------ egg info
local function describe(record)
	local directory = type(Assets) == "table" and Assets.Directory or nil
	local entry = type(directory) == "table" and directory[tostring(record.AssetCategory)] or nil
	local info = { Uid = record.Uid, Category = tostring(record.AssetCategory), Name = tostring(record.AssetCategory), Icon = "", Rarity = 0, Value = 0 }

	if type(entry) == "table" then
		info.Name = tostring(entry.DisplayName or record.AssetCategory)
		local icon = entry.Icon
		if icon ~= nil and tostring(icon) ~= "" then
			icon = tostring(icon)
			info.Icon = tonumber(icon) and ("rbxassetid://" .. icon) or icon
		end
		if type(entry.Rarity) == "table" then
			info.Rarity = tonumber(entry.Rarity.RarityNumber or entry.Rarity.Rank) or 0
		end

		local scale = tonumber(record.AssetScale) or 1
		local factor = scale > 5 and (scale / 5) ^ 1.2 * 19.637875755794113 or scale ^ 1.85
		local mutation = 1
		if type(Mutations) == "table" and type(Mutations.EarningsFor) == "function" then
			local okM, resM = pcall(Mutations.EarningsFor, type(record.Mutations) == "table" and record.Mutations or {})
			if okM and type(resM) == "number" then
				mutation = resM
			end
		end
		info.Value = (tonumber(entry.EarningRate) or 0) * factor * mutation
	end

	return info
end

local function money(value)
	local units = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
	for _, u in ipairs(units) do
		if value >= u[1] then
			return string.format("$%.2f%s/s", value / u[1], u[2])
		end
	end
	return string.format("$%d/s", math.floor(value + 0.5))
end

------------------------------------------------------------------ Instant TP logic
local status = function(text) end

local function frozenCamera()
	local camera = workspace.CurrentCamera
	if not camera then
		return function() end
	end
	local oldType = camera.CameraType
	local frame = camera.CFrame
	pcall(function()
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = frame
	end)
	return function()
		pcall(function()
			camera.CameraType = oldType
		end)
	end
end

local fpsGen = 0
local function fpsOn()
	if typeof(setfpscap) ~= "function" then
		return
	end
	fpsGen += 1
	local mine = fpsGen
	task.spawn(function()
		local high = true
		local started = os.clock()
		while fpsGen == mine and os.clock() - started < 60 do
			pcall(setfpscap, high and FPS_CAPS[1] or FPS_CAPS[2])
			high = not high
			task.wait(FPS_CAPS[3])
		end
	end)
end

local function fpsOff()
	fpsGen += 1
	if typeof(setfpscap) == "function" then
		pcall(setfpscap, 240)
	end
end

local stealClone = nil
local function dropClone()
	local copy = stealClone
	stealClone = nil
	if copy then
		pcall(function()
			copy:Destroy()
		end)
	end
end

local function postClone()
	dropClone()
	local character = localPlayer.Character
	if not character then
		return
	end
	local was = character.Archivable
	character.Archivable = true
	local copy = character:Clone()
	character.Archivable = was
	if copy then
		for _, d in ipairs(copy:GetDescendants()) do
			if d:IsA("LuaSourceContainer") or d:IsA("Humanoid") then
				pcall(function()
					d:Destroy()
				end)
			elseif d:IsA("BasePart") then
				d.Anchored = true
				d.CanCollide = false
				d.CanTouch = false
				d.CanQuery = false
			end
		end
		copy.Name = "Clone"
		copy.Parent = workspace
		stealClone = copy
	end
end

local function lineInfo()
	local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	world = world and world:FindFirstChild("Areas")
	world = world and world:FindFirstChild("SeparationLine")
	local ok = world and world:IsA("BasePart")
	return ok and world.Position.X or 552.2, ok and world.Position.Y or 67.67
end

local function homePoint()
	for _, def in ipairs({
		{ { "GearGiver_Slap", "Podium" }, Vector3.new(-16.415, 21.072, -6.106) },
		{ { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
		{ { "__OBJECTS", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" }, Vector3.new(-26.776, 1.75, 18.665) },
	}) do
		local node = workspace
		for _, name in ipairs(def[1]) do
			node = node and node:FindFirstChild(name) or nil
		end
		if node and node:IsA("BasePart") then
			return node.CFrame:PointToWorldSpace(def[2])
		end
	end
	return Vector3.new(528.7, 70.57, -364.11)
end

local function place(position)
	local r = root()
	if not r then
		return
	end
	pcall(function()
		r.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(90), 0)
		r.AssemblyLinearVelocity = Vector3.zero
		r.AssemblyAngularVelocity = Vector3.zero
	end)
end

local dangerCache, dangerAt = {}, 0
local function dangers()
	if os.clock() - dangerAt < 1 then
		return dangerCache
	end
	dangerAt = os.clock()
	local list = {}
	local function add(inst)
		local ok, cf, size = pcall(function()
			if inst:IsA("Model") then
				return inst:GetBoundingBox()
			elseif inst:IsA("BasePart") then
				return inst.CFrame, inst.Size
			end
		end)
		if ok and cf and size then
			local half = Vector3.new(math.abs(size.X), 0, math.abs(size.Z)) * 0.5
			local rot = (cf - cf.Position):VectorToWorldSpace(half)
			local rx = math.max(math.abs(rot.X), half.X, half.Z)
			local rz = math.max(math.abs(rot.Z), half.X, half.Z)
			list[#list + 1] = { MinX = cf.Position.X - rx, MaxX = cf.Position.X + rx, MinZ = cf.Position.Z - rz, MaxZ = cf.Position.Z + rz }
		end
	end
	local function bad(name)
		if name == "ScrambleLocalVisuals" or name == "DrScrambleEvent" then
			return false
		end
		name = string.lower(name)
		return string.find(name, "portal", 1, true) or string.find(name, "teleport", 1, true) or string.find(name, "mech", 1, true) or string.find(name, "arena", 1, true) or string.find(name, "scramble", 1, true)
	end
	for _, child in ipairs(workspace:GetChildren()) do
		if (child:IsA("Model") or child:IsA("BasePart") or child:IsA("Folder")) and bad(child.Name) then
			if child:IsA("Folder") then
				for _, inner in ipairs(child:GetChildren()) do
					add(inner)
				end
			else
				add(child)
			end
		end
	end
	local build = workspace:FindFirstChild("World")
	build = build and build:FindFirstChild("Build")
	if build then
		for _, child in ipairs(build:GetChildren()) do
			if bad(child.Name) then
				for _, inner in ipairs(child:GetChildren()) do
					add(inner)
				end
			end
		end
	end
	dangerCache = list
	return list
end

local function avoid(from, to)
	for _, d in ipairs(dangers()) do
		local x0, x1, z0, z1 = d.MinX - 12, d.MaxX + 12, d.MinZ - 12, d.MaxZ + 12
		local inside = from.X >= x0 and from.X <= x1 and from.Z >= z0 and from.Z <= z1
		if not inside then
			local t0, t1, hit = 0, 1, true
			for _, axis in ipairs({ { from.X, to.X - from.X, x0, x1 }, { from.Z, to.Z - from.Z, z0, z1 } }) do
				local pos, delta, lo, hi = axis[1], axis[2], axis[3], axis[4]
				if math.abs(delta) < 1e-6 then
					if pos < lo or pos > hi then
						hit = false
					end
				else
					local ta, tb = (lo - pos) / delta, (hi - pos) / delta
					if ta > tb then
						ta, tb = tb, ta
					end
					t0, t1 = math.max(t0, ta), math.min(t1, tb)
					if t0 > t1 then
						hit = false
					end
				end
			end
			if hit then
				local zLow, zHigh = z0 - 2, z1 + 2
				local z = math.abs(from.Z - zLow) <= math.abs(from.Z - zHigh) and zLow or zHigh
				if z < -440 or z > -290 then
					z = z == zLow and zHigh or zLow
				end
				local x = math.abs(from.X - x0) <= math.abs(from.X - x1) and x0 or x1
				if math.abs(from.Z - z) < 3 then
					x = math.abs(to.X - x0) <= math.abs(to.X - x1) and x0 or x1
				end
				return Vector3.new(x, to.Y, z)
			end
		end
	end
	return to
end

local function runToEgg(uid, egg)
	local lineX = lineInfo()
	local home = homePoint()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
		if character:FindFirstChildWhichIsA("Tool") then
			pcall(function()
				humanoid:UnequipTools()
			end)
		end
	end

	local r = root()
	if not r then
		return false
	end
	local stage = "field"
	if r.Position.X < lineX - 2 and Vector3.new(r.Position.X - home.X, 0, r.Position.Z - home.Z).Magnitude > 20 then
		stage = "safe"
	end

	local started, lastCheck, lastPos, lastTake = os.clock(), os.clock(), r.Position, 0
	while os.clock() - started < 120 and not state.Cancel do
		r = root()
		if not r then
			return false
		end
		local flatEgg = Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z)
		if stage == "field" and flatEgg.Magnitude <= 2.5 then
			break
		end
		local target = egg
		if stage == "safe" then
			if Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude <= 6 then
				stage = "field"
			else
				target = home
			end
		end

		local waypoint = avoid(r.Position, target)
		local flat = Vector3.new(waypoint.X - r.Position.X, 0, waypoint.Z - r.Position.Z)
		local unit = flat.Magnitude > 0.01 and flat.Unit or Vector3.zero
		local speed = math.max(walkSpeed() * CFG.SpeedCap, 8)
		local v = unit * math.min(speed, flat.Magnitude / 0.05)
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(v.X, r.AssemblyLinearVelocity.Y, v.Z)
			if humanoid and unit.Magnitude > 0 then
				humanoid:Move(unit, false)
			end
		end)

		if os.clock() - lastCheck >= 1.5 then
			if (r.Position - lastPos).Magnitude < 3 and humanoid and flatEgg.Magnitude > 15 then
				pcall(function()
					humanoid.Jump = true
				end)
			end
			lastPos, lastCheck = r.Position, os.clock()
		end

		if stage == "field" and flatEgg.Magnitude <= 9 and os.clock() - lastTake > 0.1 then
			lastTake = os.clock()
			takeEgg(uid)
		end
		RunService.Heartbeat:Wait()
	end

	r = root()
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
			if humanoid then
				humanoid:Move(Vector3.zero, false)
			end
		end)
	end
	return state.Carrying or (r ~= nil and Vector3.new(egg.X - r.Position.X, 0, egg.Z - r.Position.Z).Magnitude <= 6)
end

local function eggNow(uid, cache)
	local node = workspace:FindFirstChild(uid)
	local slots = workspace:FindFirstChild("AreaEggSlotsClient")
	node = node or (slots and slots:FindFirstChild(uid))
	if node then
		local ok, pos = pcall(function()
			return node:GetPivot().Position
		end)
		if ok and pos then
			cache.Pos, cache.At = pos, os.clock()
			return pos
		end
	end
	if os.clock() - cache.At >= 0.5 then
		cache.At = os.clock()
		cache.Pos = eggPosition(uid) or cache.Pos
	end
	return cache.Pos
end

local function grab(uid, timeout)
	local cache = { At = 0 }
	local waited, since = 0, 1
	while not state.Carrying and waited < timeout and not state.Cancel do
		local r = root()
		local egg = eggNow(uid, cache)
		local dt = math.max(RunService.Heartbeat:Wait(), 1 / 240)
		waited += dt
		since += dt
		if r and egg then
			local delta = egg - r.Position
			if delta.Magnitude > 2 then
				local pace = math.max(walkSpeed() * CFG.SpeedCap, 16)
				local v = delta / math.max(0.08, dt)
				if v.Magnitude > pace then
					v = v.Unit * pace
				end
				pcall(function()
					r.AssemblyLinearVelocity = v + Vector3.new(0, workspace.Gravity * dt * 0.5, 0)
					r.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			if since >= CFG.GrabInterval then
				since = 0
				local prompt = promptNear(egg - Vector3.new(0, 3, 0), 10)
				if prompt and typeof(fireproximityprompt) == "function" then
					pcall(function()
						prompt.HoldDuration = 0
					end)
					pcall(fireproximityprompt, prompt)
				end
				task.spawn(takeEgg, uid)
			end
		elseif since >= CFG.GrabInterval then
			since = 0
			task.spawn(takeEgg, uid)
		end
	end
	local r = root()
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.zero
		end)
	end
	return state.Carrying and state.Uid == uid
end

local function regrab(uid)
	if state.Carrying then
		return true
	end
	local r = root()
	local egg = eggPosition(uid)
	if r and egg and Vector3.new(r.Position.X - egg.X, 0, r.Position.Z - egg.Z).Magnitude > CFG.RegrabFar then
		status("The egg fell far behind, teleporting onto it")
		place(egg + Vector3.new(0, 3, 0))
	else
		status("The egg fell close, taking it back")
	end
	return grab(uid, 3)
end

local function groundY(position, fallback)
	local y = fallback
	pcall(function()
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { localPlayer.Character }
		params.IgnoreWater = true
		local hit = workspace:Raycast(position + Vector3.new(0, 60, 0), Vector3.new(0, -140, 0), params)
		if hit and hit.Material ~= Enum.Material.Water and math.abs(hit.Position.Y - fallback) < 40 then
			y = hit.Position.Y + 3.5
		end
	end)
	return y
end

local function carrySpeed(distance)
	local ws = walkSpeed()
	local base = ws * math.min(CFG.CarryRatio, CFG.SpeedCap) * state.Mult
	local fast = base * 1.5
	local excess = 5.5 * base
	local limit = fast
	if distance and distance > excess then
		limit = math.min(fast, base * distance / (distance - excess))
	end
	return math.min(math.max(math.min(base * CFG.EasyRatio, limit), base), math.max(ws * CFG.SpeedCap, base))
end

local function runHome(lineX, laneZ)
	local started = os.clock()
	local home = homePoint()
	local checkpoint = lineX - 7
	local height = CFG.Height
	local share = math.clamp(CFG.ClimbShare, 0.1, 0.9)
	local descent = height * math.sqrt(1 - share * share) / share
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.PlatformStand = false
	end

	local r = root()
	if r and character and height > 0.5 and home.Y + height - 2 > r.Position.Y then
		pcall(function()
			character:PivotTo(CFrame.new(Vector3.new(r.Position.X, home.Y + height, r.Position.Z)) * r.CFrame.Rotation)
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	local start = root()
	local speed = carrySpeed(start and (Vector3.new(start.Position.X - home.X, 0, start.Position.Z - home.Z).Magnitude + math.max(0, height) * 2) or nil)

	local last = os.clock()
	local timeout = 0
	status("Safe zone")
	while state.Carrying and state.Delivered < started and not state.Cancel and timeout < 25 do
		r = root()
		if not r then
			return false
		end
		local now = os.clock()
		local dt = math.max(now - last, 1 / 240)
		last = now
		timeout += dt

		local toHome = r.Position.X <= checkpoint + 2
		local target = toHome and home or Vector3.new(checkpoint, home.Y, laneZ)
		if toHome and Vector3.new(home.X - r.Position.X, 0, home.Z - r.Position.Z).Magnitude < 2 then
			break
		end
		local aim = avoid(r.Position, target)
		local flat = Vector3.new(aim.X - r.Position.X, 0, aim.Z - r.Position.Z)
		local remaining = toHome and 0 or math.max(0, r.Position.X - checkpoint)
		local wantY = home.Y + height
		if toHome or remaining <= descent then
			wantY = home.Y + height * math.clamp(remaining / math.max(descent, 1), 0, 1)
		end
		local vy = math.clamp((wantY - r.Position.Y) / 0.12, -speed * share, speed * share)
		local horizontal = math.sqrt(math.max(speed * speed - vy * vy, 0))
		local v = flat.Magnitude > 0.01 and flat.Unit * math.min(horizontal, flat.Magnitude / 0.05) or Vector3.zero
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z)
		end)
		RunService.Heartbeat:Wait()
	end

	if humanoid then
		pcall(function()
			humanoid:Move(Vector3.zero, false)
		end)
	end

	local settle = 0
	while settle < 2 and state.Delivered < started and state.Carrying and not state.Cancel do
		settle += RunService.Heartbeat:Wait()
	end
	if state.Carrying and state.Delivered < started and not state.Cancel then
		task.wait(0.2)
		dropEgg()
		local waited = 0
		while state.Delivered < started and waited < 1 do
			waited += RunService.Heartbeat:Wait()
		end
	end
	return state.Delivered >= started
end

local function instantTP(uid)
	local started = os.clock()
	local lineX, lineY = lineInfo()
	local r = root()
	if not r then
		return false
	end
	local laneZ = math.clamp(r.Position.Z, -425, -300)
	local landing = Vector3.new(lineX + CFG.LandOffset, lineY + 3.35, laneZ)

	local hopStep = math.max(walkSpeed() * CFG.HopRatio, CFG.HopMin)
	local hopY = r.Position.Y + CFG.HopLift
	local x = r.Position.X
	local retries = 0
	local releaseCamera = frozenCamera()
	state.ReleaseCamera = releaseCamera
	pcall(postClone)
	fpsOn()

	while x - hopStep > landing.X and not state.Cancel do
		if not state.Carrying then
			if not regrab(uid) then
				break
			end
			local current = root()
			if current then
				x = math.min(x, current.Position.X)
			end
			continue
		end

		local nextX = x - hopStep
		status(string.format("Instant TP: hopping home, X %d", math.floor(nextX)))
		local pulledBefore = state.PulledAt
		local held = 0
		while held < CFG.HopGap do
			place(Vector3.new(nextX, hopY, laneZ))
			held += RunService.Heartbeat:Wait()
		end

		local check = root()
		local pulled = state.PulledAt > pulledBefore or (check ~= nil and (check.Position.X - nextX > 10 or check.AssemblyLinearVelocity.Magnitude > 150))
		if pulled and state.Carrying and not state.Cancel then
			retries += 1
			CFG.HopGap = math.min(CFG.HopGapMax, CFG.HopGap + 0.02)
			if retries > CFG.HopRetries then
				break
			end
			status(string.format("Instant TP: pulled back, retry %d/%d", retries, CFG.HopRetries))
			local settle = 0
			while settle < 0.12 and not state.Cancel do
				place(Vector3.new(x, hopY, laneZ))
				settle += RunService.Heartbeat:Wait()
			end
		else
			x = nextX
			CFG.HopGap = math.max(CFG.HopGapMin, CFG.HopGap - 0.01)
		end
	end

	status("Instant TP: landing next to the line")
	landing = Vector3.new(landing.X, groundY(landing, landing.Y), landing.Z)
	local function land()
		local current = root()
		if current and current.Position.X <= landing.X + 1 and current.Position.Y > landing.Y - 25 then
			pcall(function()
				current.AssemblyLinearVelocity = Vector3.zero
			end)
			return
		end
		place(landing)
	end
	land()
	for attempt = 1, 3 do
		local settle = 0
		while settle < CFG.LandSettle and not state.Cancel do
			settle += RunService.Heartbeat:Wait()
		end
		local landed = root()
		if state.Carrying and landed and (landed.Position.X - landing.X > 12 or landed.Position.Y < landing.Y - 25) then
			status("Instant TP: landing retry " .. attempt)
			land()
		else
			break
		end
	end
	dropClone()

	if state.Carrying and not state.Cancel then
		local delay = 0
		while delay < CFG.DropDelay do
			delay += RunService.Heartbeat:Wait()
		end
		status("Instant TP: dropping the egg")
		dropEgg()
		local waited = 0
		while state.Carrying and waited < 1 and not state.Cancel do
			waited += RunService.Heartbeat:Wait()
		end
		local current = root()
		if current then
			pcall(function()
				current.AssemblyLinearVelocity = Vector3.zero
				current.AssemblyAngularVelocity = Vector3.zero
			end)
		end
		releaseCamera()
		dropClone()
		status("Instant TP: taking the egg back")
		if not grab(uid, 3) and not regrab(uid) then
			fpsOff()
			status("Could not take the egg back")
			return false
		end
		dropClone()
	end
	releaseCamera()

	local ok = false
	if state.Carrying then
		ok = runHome(lineX, laneZ)
	end
	fpsOff()
	return ok or state.Delivered >= started
end

local function stealAndDeliver(uid)
	if state.Busy then
		return
	end
	state.Busy = true
	state.Cancel = false
	task.spawn(function()
		local ok, err = pcall(function()
			status("Looking for the egg")
			local egg = eggPosition(uid)
			if not egg then
				status("That egg is gone")
				return
			end
			if state.Carrying and state.Uid ~= uid then
				dropEgg()
				local waited = 0
				while state.Carrying and waited < 1 do
					waited += RunService.Heartbeat:Wait()
				end
			end
			fpsOn()
			status("Going to the egg")
			if not runToEgg(uid, egg) then
				fpsOff()
				status("Could not reach the egg")
				return
			end
			status("Taking the egg")
			if not grab(uid, 4) then
				fpsOff()
				status("The egg would not come free")
				return
			end
			local delivered = instantTP(uid)
			status(delivered and "Delivered" or "Delivery failed")
		end)
		fpsOff()
		dropClone()
		if state.ReleaseCamera then
			pcall(state.ReleaseCamera)
			state.ReleaseCamera = nil
		end
		if not ok then
			status("Error: " .. tostring(err))
		end
		state.Busy = false
	end)
end

------------------------------------------------------------------ UI: Compact MGD HUB Style
local WHITE = Color3.fromRGB(255, 255, 255)
local SILVER = Color3.fromRGB(150, 150, 156)
local STEEL = Color3.fromRGB(70, 70, 76)
local BG = Color3.fromRGB(15, 15, 18)
local RARITY_COLORS = {
	Color3.fromRGB(190, 190, 190), Color3.fromRGB(110, 210, 110), Color3.fromRGB(90, 160, 255),
	Color3.fromRGB(190, 110, 255), Color3.fromRGB(255, 170, 50), Color3.fromRGB(255, 80, 80),
	Color3.fromRGB(255, 90, 200), Color3.fromRGB(80, 235, 235),
}

local function make(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	return inst
end

local function corner(parent, radius)
	make("UICorner", { CornerRadius = UDim.new(0, radius or 5) }).Parent = parent
end

local living = {}
local function bands(a, b)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, a), ColorSequenceKeypoint.new(0.25, b), ColorSequenceKeypoint.new(0.5, a),
		ColorSequenceKeypoint.new(0.75, b), ColorSequenceKeypoint.new(1, a),
	})
end

local function livingStroke(parent, thickness, bright)
	local s = make("UIStroke", { Thickness = thickness or 1, Color = WHITE, ApplyStrokeMode = Enum.ApplyStrokeMode.Border })
	s.Parent = parent
	local g = make("UIGradient", { Rotation = 45, Color = bands(bright and WHITE or SILVER, STEEL) })
	g.Parent = s
	living[#living + 1] = g
	return s, g
end

local function livingText(label)
	local g = make("UIGradient", { Color = bands(WHITE, SILVER) })
	g.Parent = label
	living[#living + 1] = g
	return g
end

local function text(parent, props)
	local alive = props.Living ~= false
	props.Living = nil
	props.BackgroundTransparency = 1
	props.TextColor3 = props.TextColor3 or WHITE
	local l = make("TextLabel", props)
	l.Parent = parent
	if alive then
		livingText(l)
	end
	return l
end

local old = parentGui():FindFirstChild("MGD_HUB")
if old then
	old:Destroy()
end

local gui = make("ScreenGui", { Name = "MGD_HUB", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true })
gui.Parent = parentGui()

local W, H, HEADER = 135, 240, 18
local window = make("Frame", { Size = UDim2.fromOffset(W, H), Position = UDim2.new(0.5, -W / 2, 0.5, -H / 2), BackgroundColor3 = BG, BorderSizePixel = 0, ClipsDescendants = true })
window.Parent = gui
corner(window, 12)
livingStroke(window, 1, true)

if AVATAR_IMAGE_ID ~= "rbxassetid://0" then
	local avatarBg = make("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Image = AVATAR_IMAGE_ID,
		ImageTransparency = 0.65,
		ScaleType = Enum.ScaleType.Crop,
		ZIndex = 0
	})
	avatarBg.Parent = window
end

local rotation = 0
local tickCount = 0
local shineConnection = RunService.Heartbeat:Connect(function(dt)
	tickCount += 1
	if tickCount % 2 ~= 0 then
		return
	end
	rotation = (rotation + dt * 72) % 360
	for _, g in ipairs(living) do
		if g.Parent then
			g.Rotation = g.Parent:IsA("UIStroke") and (45 + rotation) % 360 or rotation
		end
	end
end)

-- Header
local header = make("Frame", { Size = UDim2.new(1, -6, 0, HEADER - 2), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 2 })
header.Parent = window
corner(header, 8)
do
	local g = make("UIGradient", { Color = bands(WHITE, SILVER) })
	g.Parent = header
	living[#living + 1] = g
end

text(header, {
	Size = UDim2.new(1, -36, 1, 0), Position = UDim2.fromOffset(6, 0), Font = Enum.Font.GothamBlack, TextSize = 9,
	TextColor3 = Color3.new(0, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Text = "MGD HUB", Living = false, ZIndex = 3
})

local function headerButton(label, offset)
	local b = make("TextButton", { Size = UDim2.fromOffset(14, 12), Position = UDim2.new(1, offset, 0.5, -6), BackgroundColor3 = BG, Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = WHITE, Text = label, AutoButtonColor = true, ZIndex = 3 })
	b.Parent = header
	corner(b, 5)
	livingStroke(b, 1, true)
	livingText(b)
	return b
end
local minimize = headerButton("-", -32)
local close = headerButton("x", -16)

-- Stats
local statsBar = make("Frame", { Size = UDim2.new(1, -8, 0, 10), Position = UDim2.fromOffset(4, HEADER + 2), BackgroundTransparency = 1, ZIndex = 2 })
statsBar.Parent = window

local statsLabel = text(statsBar, {
	Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromOffset(0, 0), Font = Enum.Font.GothamBold, TextSize = 7,
	TextColor3 = SILVER, TextXAlignment = Enum.TextXAlignment.Center, Text = "FPS: 60 | MS: 0ms", ZIndex = 2
})

local frameCount = 0
local lastFpsUpdate = os.clock()
RunService.RenderStepped:Connect(function()
	frameCount += 1
	local now = os.clock()
	if now - lastFpsUpdate >= 0.5 then
		local fps = math.floor(frameCount / (now - lastFpsUpdate))
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		statsLabel.Text = string.format("FPS: %d | MS: %dms", fps, ping)
		frameCount = 0
		lastFpsUpdate = now
	end
end)

local body = make("Frame", { Size = UDim2.new(1, -8, 1, -(HEADER + 14)), Position = UDim2.fromOffset(4, HEADER + 13), BackgroundTransparency = 1, ZIndex = 2 })
body.Parent = window

local list = make("ScrollingFrame", {
	Size = UDim2.new(1, 0, 1, -114), BackgroundColor3 = BG, BackgroundTransparency = 0.2, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = SILVER,
	CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2
})
list.Parent = body
corner(list, 8)
livingStroke(list, 1, false)
make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }).Parent = list
make("UIPadding", { PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 4) }).Parent = list

local statusLabel = text(body, {
	Size = UDim2.new(1, 0, 0, 9), Position = UDim2.new(0, 0, 1, -108), Font = Enum.Font.Gotham, TextSize = 7,
	TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Text = "Pick a pet", ZIndex = 2
})

local PUBLIC = { ["Pick a pet"] = true, ["Looking for the egg"] = true, ["Going to the egg"] = true, ["Taking the egg"] = true, ["Delivered"] = true, ["Delivery failed"] = true, ["That egg is gone"] = true, ["Could not reach the egg"] = true, ["The egg would not come free"] = true, ["Cancelling"] = true }
status = function(msg)
	msg = tostring(msg)
	if PUBLIC[msg] or string.sub(msg, 1, 9) == "Selected:" then
		statusLabel.Text = msg
	elseif string.sub(msg, 1, 5) == "Error" then
		statusLabel.Text = "Error"
	elseif state.Busy then
		statusLabel.Text = "Delivering"
	end
end

local function tinyButton(label, position, size)
	local b = make("TextButton", { Size = size, Position = position, BackgroundColor3 = BG, BackgroundTransparency = 0.1, Font = Enum.Font.GothamBold, TextSize = 7, TextColor3 = WHITE, Text = label, AutoButtonColor = true, ZIndex = 2 })
	b.Parent = body
	corner(b, 6)
	livingStroke(b, 1, true)
	livingText(b)
	return b
end

-- Kompakt Buton Yerleşimi (Yan Yana İkili Gruplar)
local refreshButton = tinyButton("Refresh", UDim2.new(0, 0, 1, -96), UDim2.new(0.4, -1, 0, 18))
local stealButton = tinyButton("Steal", UDim2.new(0.4, 1, 1, -96), UDim2.new(0.6, -1, 0, 18))

local autoFarmOpenBtn = tinyButton("Auto Farm: OFF", UDim2.new(0, 0, 1, -76), UDim2.new(0.5, -1, 0, 18))
local autoPlaceBtn = tinyButton("Auto Place: OFF", UDim2.new(0.5, 1, 1, -76), UDim2.new(0.5, -1, 0, 18))

local antiRagdollBtn = tinyButton("Anti Ragdoll: OFF", UDim2.new(0, 0, 1, -56), UDim2.new(0.5, -1, 0, 18))
local killAuraBtn = tinyButton("Kill Aura: OFF", UDim2.new(0.5, 1, 1, -56), UDim2.new(0.5, -1, 0, 18))

local rangeBtn = tinyButton("Range: 25", UDim2.new(0, 0, 1, -36), UDim2.new(0.33, -1, 0, 18))
local hitEggHolderBtn = tinyButton("Hit Holder", UDim2.new(0.33, 1, 1, -36), UDim2.new(0.34, -1, 0, 18))
local antiLagBtn = tinyButton("Anti-Lag: OFF", UDim2.new(0.67, 1, 1, -36), UDim2.new(0.33, -1, 0, 18))

------------------------------------------------------------------ AUTO PLACE EGG LOGIC
local autoPlaceRunning = false
local autoPlaceThread = nil

autoPlaceBtn.MouseButton1Click:Connect(function()
	autoPlaceRunning = not autoPlaceRunning
	autoPlaceBtn.Text = autoPlaceRunning and "Auto Place: ON" or "Auto Place: OFF"

	if autoPlaceRunning then
		autoPlaceThread = task.spawn(function()
			while autoPlaceRunning and gui.Parent do
				local home = homePoint()
				local rx = math.random(-8, 8)
				local rz = math.random(-8, 8)
				local randomPos = home + Vector3.new(rx, 2, rz)
				
				place(randomPos)
				task.wait(0.1)
				dropEgg()
				task.wait(1.5)
			end
		end)
	else
		if autoPlaceThread then task.cancel(autoPlaceThread) end
	end
end)

------------------------------------------------------------------ AUTO FARM WINDOW & LOGIC
local autoFarmWindow = make("Frame", { Size = UDim2.fromOffset(135, 230), Position = UDim2.new(0.5, 75, 0.5, -115), BackgroundColor3 = BG, Visible = false, ClipsDescendants = true, ZIndex = 5 })
autoFarmWindow.Parent = gui
corner(autoFarmWindow, 12)
livingStroke(autoFarmWindow, 1, true)

local farmHeader = make("Frame", { Size = UDim2.new(1, -6, 0, HEADER - 2), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = WHITE, ZIndex = 6 })
farmHeader.Parent = autoFarmWindow
corner(farmHeader, 8)
do
	local g = make("UIGradient", { Color = bands(WHITE, SILVER) })
	g.Parent = farmHeader
	living[#living + 1] = g
end

text(farmHeader, { Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(6, 0), Font = Enum.Font.GothamBlack, TextSize = 9, TextColor3 = Color3.new(0, 0, 0), TextXAlignment = Enum.TextXAlignment.Left, Text = "AUTO FARM", Living = false, ZIndex = 7 })

local closeFarm = make("TextButton", { Size = UDim2.fromOffset(14, 12), Position = UDim2.new(1, -16, 0.5, -6), BackgroundColor3 = BG, Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = WHITE, Text = "x", ZIndex = 7 })
closeFarm.Parent = farmHeader
corner(closeFarm, 5)
livingStroke(closeFarm, 1, true)
livingText(closeFarm)

local thresholdValues = {
	["10M+"] = 10e6, ["20M+"] = 20e6, ["40M+"] = 40e6, ["50M+"] = 50e6,
	["100M+"] = 100e6, ["200M+"] = 200e6, ["400M+"] = 400e6, ["800M+"] = 800e6,
	["1B+"] = 1e9, ["2B+"] = 2e9, ["4B+"] = 4e9
}
local thresholdKeys = { "10M+", "20M+", "40M+", "50M+", "100M+", "200M+", "400M+", "800M+", "1B+", "2B+", "4B+" }
local selectedThresholdKey = "10M+"

local thresholdBtn = make("TextButton", { Size = UDim2.new(1, -8, 0, 18), Position = UDim2.fromOffset(4, 24), BackgroundColor3 = Color3.fromRGB(30, 30, 40), Font = Enum.Font.GothamBold, TextSize = 8, TextColor3 = WHITE, Text = "Min: 10M+", ZIndex = 6 })
thresholdBtn.Parent = autoFarmWindow
corner(thresholdBtn, 6)
livingStroke(thresholdBtn, 1, true)
livingText(thresholdBtn)

local thresholdIndex = 1
thresholdBtn.MouseButton1Click:Connect(function()
	thresholdIndex = (thresholdIndex % #thresholdKeys) + 1
	selectedThresholdKey = thresholdKeys[thresholdIndex]
	thresholdBtn.Text = "Min: " .. selectedThresholdKey
end)

local farmList = make("ScrollingFrame", { Size = UDim2.new(1, -8, 1, -75), Position = UDim2.fromOffset(4, 45), BackgroundColor3 = BG, ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 6 })
farmList.Parent = autoFarmWindow
corner(farmList, 8)
livingStroke(farmList, 1, false)
make("UIListLayout", { Padding = UDim.new(0, 2) }).Parent = farmList

local startFarmBtn = make("TextButton", { Size = UDim2.new(1, -8, 0, 20), Position = UDim2.new(0, 4, 1, -24), BackgroundColor3 = Color3.fromRGB(0, 150, 70), Font = Enum.Font.GothamBold, TextSize = 9, TextColor3 = WHITE, Text = "START FARM", ZIndex = 6 })
startFarmBtn.Parent = autoFarmWindow
corner(startFarmBtn, 6)
livingStroke(startFarmBtn, 1, true)
livingText(startFarmBtn)

local autoFarmRunning = false
local farmLoopThread = nil

local function rebuildFarmList()
	for _, child in ipairs(farmList:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	local minVal = thresholdValues[selectedThresholdKey] or 10e6
	local infos = {}
	for _, record in ipairs(snapshot()) do
		local desc = describe(record)
		if desc.Value >= minVal then
			infos[#infos + 1] = desc
		end
	end
	table.sort(infos, function(a, b) return a.Value > b.Value end)

	for index, info in ipairs(infos) do
		local frame = make("TextButton", { Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = BG, LayoutOrder = index, Text = "", ZIndex = 7 })
		frame.Parent = farmList
		corner(frame, 6)
		livingStroke(frame, 1, false)

		if info.Icon ~= "" then
			make("ImageLabel", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 3), BackgroundTransparency = 1, Image = info.Icon, ScaleType = Enum.ScaleType.Fit, ZIndex = 7 }).Parent = frame
		end

		text(frame, { Size = UDim2.new(1, -22, 0, 10), Position = UDim2.fromOffset(info.Icon ~= "" and 22 or 4, 2), Font = Enum.Font.GothamBold, TextSize = 8, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Text = info.Name, TextColor3 = RARITY_COLORS[math.clamp(info.Rarity, 1, #RARITY_COLORS)] or WHITE, ZIndex = 7 })
		text(frame, { Size = UDim2.new(1, -22, 0, 9), Position = UDim2.fromOffset(info.Icon ~= "" and 22 or 4, 11), Font = Enum.Font.GothamMedium, TextSize = 7, TextXAlignment = Enum.TextXAlignment.Left, Text = money(info.Value), ZIndex = 7 })
	end
end

autoFarmOpenBtn.MouseButton1Click:Connect(function()
	autoFarmWindow.Visible = not autoFarmWindow.Visible
	if autoFarmWindow.Visible then rebuildFarmList() end
end)

closeFarm.MouseButton1Click:Connect(function()
	autoFarmWindow.Visible = false
end)

startFarmBtn.MouseButton1Click:Connect(function()
	autoFarmRunning = not autoFarmRunning
	startFarmBtn.Text = autoFarmRunning and "STOP FARM" or "START FARM"
	startFarmBtn.BackgroundColor3 = autoFarmRunning and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(0, 150, 70)
	autoFarmOpenBtn.Text = autoFarmRunning and "Auto Farm: ON" or "Auto Farm: OFF"

	if autoFarmRunning then
		farmLoopThread = task.spawn(function()
			while autoFarmRunning and gui.Parent do
				rebuildFarmList()
				local minVal = thresholdValues[selectedThresholdKey] or 10e6
				local targetToSteal = nil

				for _, record in ipairs(snapshot()) do
					local desc = describe(record)
					if desc.Value >= minVal then
						targetToSteal = desc.Uid
						break
					end
				end

				if targetToSteal then
					stealAndDeliver(targetToSteal)
				end
				task.wait(1)
			end
		end)
	else
		if farmLoopThread then task.cancel(farmLoopThread) end
	end
end)

------------------------------------------------------------------ Other Buttons Connection
antiRagdollBtn.MouseButton1Click:Connect(function()
	local newState = not antiRagdollEnabled
	setAntiRagdoll(newState)
	antiRagdollBtn.Text = newState and "Anti Ragdoll: ON" or "Anti Ragdoll: OFF"
end)

killAuraBtn.MouseButton1Click:Connect(function()
	local newState = not killAuraEnabled
	setKillAura(newState)
	killAuraBtn.Text = newState and "Kill Aura: ON" or "Kill Aura: OFF"
end)

local presetRanges = {10, 25, 50, 75, 100}
local rangeIndex = 2
rangeBtn.MouseButton1Click:Connect(function()
	rangeIndex = (rangeIndex % #presetRanges) + 1
	killAuraRange = presetRanges[rangeIndex]
	rangeBtn.Text = "Range: " .. tostring(killAuraRange)
	if killAuraEnabled then
		updateRangeCircle()
	end
end)

hitEggHolderBtn.MouseButton1Click:Connect(function()
	local success = teleportAndHitEggHolder()
	if success then
		statusLabel.Text = "Hit Holder!"
	else
		statusLabel.Text = "No Holder Found"
	end
end)

antiLagBtn.MouseButton1Click:Connect(function()
	if not antiLagEnabled then
		enableAntiLag()
		antiLagBtn.Text = "Anti-Lag: ON"
		statusLabel.Text = "Anti-Lag Active!"
	end
end)

local selectedUid = nil
local rows = {}

local function setSelected(uid)
	selectedUid = uid
	for rowUid, row in pairs(rows) do
		local on = rowUid == uid
		row.Stroke.Thickness = on and 1.5 or 1
		row.Gradient.Color = on and bands(WHITE, STEEL) or bands(STEEL, Color3.fromRGB(30, 30, 34))
	end
end

local function rebuild()
	for _, row in pairs(rows) do
		row.Frame:Destroy()
	end
	table.clear(rows)
	for i = #living, 1, -1 do
		if not living[i].Parent then
			table.remove(living, i)
		end
	end

	local infos = {}
	for _, record in ipairs(snapshot()) do
		infos[#infos + 1] = describe(record)
	end
	table.sort(infos, function(a, b)
		return a.Value > b.Value
	end)

	local still = false
	for index, info in ipairs(infos) do
		still = still or info.Uid == selectedUid
		local frame = make("TextButton", { Size = UDim2.new(1, 0, 0, 22), BackgroundColor3 = BG, LayoutOrder = index, Text = "", AutoButtonColor = true, ZIndex = 3 })
		frame.Parent = list
		corner(frame, 6)
		local rowStroke, rowGradient = livingStroke(frame, 1, false)

		make("ImageLabel", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 3), BackgroundTransparency = 1, Image = info.Icon, ScaleType = Enum.ScaleType.Fit, ZIndex = 3 }).Parent = frame
		text(frame, {
			Size = UDim2.new(1, -22, 0, 10), Position = UDim2.fromOffset(22, 2), Font = Enum.Font.GothamBold, TextSize = 8,
			TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Text = info.Name,
			TextColor3 = RARITY_COLORS[math.clamp(info.Rarity, 1, #RARITY_COLORS)] or WHITE, ZIndex = 3
		})
		text(frame, {
			Size = UDim2.new(1, -22, 0, 9), Position = UDim2.fromOffset(22, 11), Font = Enum.Font.GothamMedium, TextSize = 7,
			TextXAlignment = Enum.TextXAlignment.Left, Text = money(info.Value), ZIndex = 3
		})

		rows[info.Uid] = { Frame = frame, Stroke = rowStroke, Gradient = rowGradient }
		frame.MouseButton1Click:Connect(function()
			setSelected(info.Uid)
			status("Selected: " .. info.Name)
		end)
	end

	setSelected(still and selectedUid or nil)
	if #infos == 0 then
		status("Pick a pet")
	end
end

refreshButton.MouseButton1Click:Connect(function()
	if not state.Busy then
		rebuild()
	end
end)

stealButton.MouseButton1Click:Connect(function()
	if state.Busy then
		state.Cancel = true
		status("Cancelling")
		return
	end
	if not selectedUid then
		status("Pick a pet")
		return
	end
	stealAndDeliver(selectedUid)
end)

task.spawn(function()
	while gui.Parent do
		task.wait(0.25)
		stealButton.Text = state.Busy and "Cancel" or "Steal"
	end
end)

-- Dragging Main Window
do
	local dragging, startPos, startInput
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, startPos, startInput = true, window.Position, input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startInput
			window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Dragging Farm Window
do
	local dragging, startPos, startInput
	farmHeader.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, startPos, startInput = true, autoFarmWindow.Position, input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startInput
			autoFarmWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	body.Visible = not minimized
	statsBar.Visible = not minimized
	window.Size = minimized and UDim2.fromOffset(W, HEADER + 2) or UDim2.fromOffset(W, H)
end)

close.MouseButton1Click:Connect(function()
	state.Cancel = true
	autoFarmRunning = false
	autoPlaceRunning = false
	if farmLoopThread then task.cancel(farmLoopThread) end
	if autoPlaceThread then task.cancel(autoPlaceThread) end
	fpsOff()
	shieldStop()
	setAntiRagdoll(false)
	setKillAura(false)
	shineConnection:Disconnect()
	gui:Destroy()
end)

rebuild()
task.spawn(function()
	while gui.Parent do
		task.wait(4)
		if not state.Busy and body.Visible then
			rebuild()
		end
		if autoFarmWindow.Visible then rebuildFarmList() end
	end
end)

shieldStart()